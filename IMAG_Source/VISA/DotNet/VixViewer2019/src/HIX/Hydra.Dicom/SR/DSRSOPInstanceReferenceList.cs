using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;
using System.Threading.Tasks;
using ClearCanvas.Dicom;

namespace Hydra.Dicom
{
    public class DSRSOPInstanceReferenceList : DSRTypes
    {
        /** constructor
         ** @param  sequence  DICOM tag specifying the attribute (sequence) of the reference list
         */
        public DSRSOPInstanceReferenceList(DicomAttribute sequence)
        {
            SequenceTag = sequence;
            StudyList = new List<StudyStruct>();
            Iterator = null;
        }

        /** destructor
         */
        ~DSRSOPInstanceReferenceList()
        {
            /* clear reference list and delete allocated memory */
            clear();
        }

        /** clear list of references
         */
        public void clear()
        {
            StudyList.Clear();
        }

        /** check whether list of references is empty
         ** @return OFTrue if list is empty, OFFalse otherwise
         */
        public bool empty()
        {
            return !StudyList.Any();
        }

        /** get number of instance stored in the list of references
         ** @return number of instances
         */
        public int getNumberOfInstances()
        {
            return StudyList.Count;
        }

        /** read list of referenced SOP instances.
         *  The hierarchical structure is automatically reorganized in a way that each study,
         *  each series (within a study) and each instance (within a series) only exist once,
         *  i.e. the structure might look different when written back to a dataset.  However,
         *  the content is identical and this way of storing information saves storage space.
         ** @param  dataset    DICOM dataset from which the data should be read
         ** @return status, EC_Normal if successful, an error code otherwise
         */
        public E_Condition read(DicomAttributeCollection dataset)
        {
            /* first, check whether sequence is present and non-empty */
            DicomAttribute sequence = SequenceTag.Tag.CreateDicomAttribute();
            E_Condition result = getElementFromDataset(dataset, ref sequence);
            checkElementValue(sequence, "1-n", "1C", result);
            if (result.good())
            {
                string sequenceName = SequenceTag.Tag.Name;
                /* iterate over all sequence items */
                for (int i = 0; i < sequence.Count; i++)
                {
                    DicomSequenceItem sequenceItem = ((DicomSequenceItem[])sequence.Values)[i];

                    /* get the study instance UID */
                    string studyUID = string.Empty;
                    if (getAndCheckStringValueFromDataset(sequenceItem, DSRTypes.getDicomAttribute(DicomTags.StudyInstanceUid), ref studyUID, "1", "1", sequenceName).good())
                    {
                        /* check whether study item already exists,
                        because the internal structure is organized in a strictly hierarchical manner  */
                        StudyStruct study = gotoStudy(studyUID);
                        if (study == null)
                        {
                            /* if not, create a new study list item */
                            study = new StudyStruct(studyUID);
                            if (study != null)
                            {
                                /* and add it to the list of studies */
                                StudyList.Add(study);
                            }
                            else
                            {
                                result = E_Condition.EC_MemoryExhausted;
                                break;
                            }
                        }
                        if (study != null)
                        {
                            /* read attributes on series and instance level */
                            result = study.read(sequenceItem);
                        }
                    }
                }
            }

            /* remove empty/incomplete items from the list structure */
            removeIncompleteItems();

            return result;
        }

        /** write list of referenced SOP instances.
         *  Does nothing if list is empty.
         ** @param  dataset    DICOM dataset to which the data should be written
         ** @return status, EC_Normal if successful, an error code otherwise
         */
        public E_Condition write(DicomAttributeCollection dataset)
        {
            //TODO: DSRSOPInstanceReferenceList.write // Need to be corrected while debugging
            E_Condition result = E_Condition.EC_Normal;
            /* iterate over all list items */
            foreach(StudyStruct study in StudyList)
            {
                if (study == null)
                {
                    continue;
                }

                DicomSequenceItem ditem = null;
                /* create a new item (and a sequence if required) */
                DicomAttribute sequence = getDicomAttribute(DicomTag.GetTagValue(SequenceTag.Tag.Group, SequenceTag.Tag.Element));
                result = getElementFromDataset(dataset, ref sequence);
                if (result.good())
                {
                    ditem = ((DicomSequenceItem[])sequence.Values)[0];
                }
                else
                {
                    ditem = new DicomSequenceItem();
                    result = E_Condition.EC_Normal;
                }

                if(ditem!=null)
                {
                    study.write(ditem);
                }
            }

            return result;
        }

        /** read list of references from XML document.
         *  The hierarchical structure is automatically reorganized in a way that each study,
         *  each series (within a study) and each instance (within a series) only exist once,
         *  i.e. the structure might look different when written back to a dataset.  However,
         *  the content is identical and this way of storing information saves storage space.
         ** @param  doc     document containing the XML file content
         *  @param  cursor  cursor pointing to the starting node
         *  @param  flags   optional flag used to customize the reading process (see DSRTypes::XF_xxx)
         ** @return status, EC_Normal if successful, an error code otherwise
         */
        public E_Condition readXML(ref DSRXMLDocument doc, DSRXMLCursor cursor, int flags)
        {
            /* default: no error, e.g. for empty list of references */
            E_Condition result = E_Condition.EC_Normal;
            if (cursor != null)
            {
                string studyUID = string.Empty;
                while (cursor.Node != null)
                {
                    /* check for known element tags */
                    if (doc.checkNode(cursor, "study").good())
                    {
                        if (!string.IsNullOrEmpty(doc.getStringFromAttribute(cursor, ref studyUID, "uid")))
                        {
                            /* check whether study item already exists,
                               because the internal structure is organized in a strictly hierarchical manner  */
                            StudyStruct study = gotoStudy(studyUID);
                            if (study == null)
                            {
                                /* if not, create a new study list item */
                                study = new StudyStruct(studyUID);
                                if (study != null)
                                {
                                    /* and add it to the list of studies */
                                    StudyList.Add(study);
                                }
                                else
                                {
                                    result = E_Condition.EC_MemoryExhausted;
                                    break;
                                }
                            }
                            if (study != null)
                            {
                                /* set cursor to new position */
                                Iterator = StudyList.ElementAt(StudyList.Count - 1);
                                /* read attributes on series and instance level */
                                result = study.readXML(ref doc, cursor.getChild());
                            }
                        }
                    }
                    /* proceed with next node */
                    cursor.gotoNext();
                }
                /* remove empty/incomplete items from the list structure */
                removeIncompleteItems();
            }
            return result;
        }

        /** write current list of references in XML format
         ** @param  stream  output stream to which the XML data is written
         *  @param  flags   optional flag used to customize the output (see DSRTypes::XF_xxx)
         ** @return status, EC_Normal if successful, an error code otherwise
         */
        public E_Condition writeXML(ref StringBuilder stream, int flags = 0)
        {
            E_Condition result = E_Condition.EC_Normal;
            /* iterate over all list items */
            foreach(StudyStruct study in StudyList)
            {
                if(study == null)
                {
                    continue;
                }

                result = study.writeXML(ref stream, flags);
            }

            return result;
        }

        /** add the specified item to the list of references.
         *  Internally the item is inserted into the hierarchical structure of studies, series
         *  and instances, if not already contained in the list. In any case the specified item
         *  is selected as the current one.
         ** @param  studyUID     study instance UID of the entry to be added
         *  @param  seriesUID    series instance UID of the entry to be added
         *  @param  sopClassUID  SOP class UID of the entry to be added
         *  @param  instanceUID  SOP instance UID of the entry to be added
         ** @return status, EC_Normal if successful, an error code otherwise
         */
        public E_Condition addItem(string studyUID, string seriesUID, string sopClassUID, string instanceUID)
        {
            E_Condition result = E_Condition.EC_IllegalParameter;
            /* check parameters first */
            if (!string.IsNullOrEmpty(studyUID) && !string.IsNullOrEmpty(seriesUID) && !string.IsNullOrEmpty(sopClassUID) && !string.IsNullOrEmpty(instanceUID))
            {
                result = E_Condition.EC_Normal;
                StudyStruct study = gotoStudy(studyUID);
                /* check whether study already exists */
                if (study == null)
                {
                    /* if not create new study item and add it to the list */
                    study = new StudyStruct(studyUID);
                    if (study != null)
                    {
                        StudyList.Add(study);
                        /* set cursor to new position */
                        Iterator = StudyList.ElementAt(StudyList.Count - 1);
                    }
                    else
                    {
                        result = E_Condition.EC_MemoryExhausted;
                    }
                }
                /* do the same for the series and instance level */
                if (study != null)
                {
                    result = study.addItem(seriesUID, sopClassUID, instanceUID);
                }
            }
            return result;
        }

        /** add item from specified DICOM dataset to the list of references.
         *  Internally an item representing the given dataset is inserted into the hierarchical
         *  structure of studies, series and instances, if not already contained in the list.
         *  In any case the specified item is selected as the current one.
         ** @param  dataset  reference to DICOM dataset from which the relevant UIDs are retrieved
         ** @return status, EC_Normal if successful, an error code otherwise
         */
        public E_Condition addItem(DicomAttributeCollection dataset)
        {
            string studyUID = string.Empty;
            string seriesUID = string.Empty;
            string sopClassUID = string.Empty;
            string instanceUID = string.Empty;
            /* retrieve element values from dataset */
            getStringValueFromDataset(dataset, getDicomAttribute(DicomTags.StudyInstanceUid), ref studyUID);
            getStringValueFromDataset(dataset, getDicomAttribute(DicomTags.SeriesInstanceUid), ref seriesUID);
            getStringValueFromDataset(dataset, getDicomAttribute(DicomTags.SopClassUid), ref sopClassUID);
            getStringValueFromDataset(dataset, getDicomAttribute(DicomTags.SopInstanceUid), ref instanceUID);
            /* add new item to the list of references (if valid) */
            return addItem(studyUID, seriesUID, sopClassUID, instanceUID);
        }

        /** remove the current item from the list of referenced SOP instances.
         *  After sucessful removal the cursor is set to the next valid position.
         ** @return status, EC_Normal if successful, an error code otherwise
         */
        public E_Condition removeItem()
        {
            E_Condition result = E_Condition.EC_IllegalCall;
            if (Iterator != null)
            {
                if (StudyList.Remove(Iterator))
                {
                    result = E_Condition.EC_Normal;
                }
                /* check whether lower level list has become empty */
                if (result.good() && !Iterator.SeriesList.Any())
                {
                    /* if so, remove study from list and set iterator to the next item */
                    int idx = 0;
                    idx = StudyList.IndexOf(Iterator);
                    if (idx > -1)
                    {
                        Iterator = StudyList.ElementAt(idx);
                    }
                }
            }
            return result;
        }

        /** remove the specified item from the list of references.
         *  After sucessful removal the cursor is set to the next valid position.
         ** @param  sopClassUID  SOP class UID of the item to be removed
         *  @param  instanceUID  SOP instance UID of the item to be removed
         ** @return status, EC_Normal if successful, an error code otherwise
         */
        public E_Condition removeItem(string sopClassUID, string instanceUID)
        {
            /* goto specified item ... */
            E_Condition result = gotoItem(sopClassUID, instanceUID);
            /* ... and remove it */
            if (result.good())
            {
                result = removeItem();
            }
            return result;
        }

        /** remove the specified item from the list of references.
         *  After sucessful removal the cursor is set to the next valid position.
         ** @param  studyUID     study instance UID of the item to be removed
         *  @param  seriesUID    series instance UID of the item to be removed
         *  @param  instanceUID  SOP instance UID of the item to be removed
         ** @return status, EC_Normal if successful, an error code otherwise
         */
        public E_Condition removeItem(string studyUID, string seriesUID, string instanceUID)
        {
            /* goto specified item ... */
            E_Condition result = gotoItem(studyUID, seriesUID, instanceUID);
            /* ... and remove it */
            if (result.good())
            {
                result = removeItem();
            }
            return result;
        }

        /** select the specified item as the current one
         ** @param  sopClassUID  SOP class UID of the item to be selected
         *  @param  instanceUID  SOP instance UID of the item to be selected
         ** @return status, EC_Normal if successful, an error code otherwise
         */
        public E_Condition gotoItem(string sopClassUID, string instanceUID)
        {
            bool sopClassMatch = false;
            E_Condition result = E_Condition.EC_IllegalParameter;
            /* check parameters first */
            if (!string.IsNullOrEmpty(sopClassUID) && !string.IsNullOrEmpty(instanceUID))
            {
                /* check whether list is empty or iterator is invalid */
                if (StudyList.Any())
                {
                    foreach (StudyStruct studyStruct in StudyList)
                    {
                        if (studyStruct == null)
                        {
                            continue;
                        }

                        if (result == E_Condition.EC_Normal)
                        {
                            break;
                        }

                        InstanceStruct instance = studyStruct.gotoInstance(instanceUID);
                        /* if instance found, exit loop */
                        if (instance != null)
                        {
                            /* finally, check whether SOP class matches */
                            sopClassMatch = (instance.SOPClassUID == sopClassUID);
                            result = E_Condition.EC_Normal;
                            Iterator = studyStruct;
                            break;
                        }
                    }
                    /* report an error in case of SOP class mismatch */
                    if (result.good() && !sopClassMatch)
                    {
                        result = E_Condition.SR_EC_DifferentSOPClassesForAnInstance;
                    }
                }
            }

            return result;
        }

        /** select the specified item as the current one
         ** @param  studyUID     study instance UID of the item to be selected
         *  @param  seriesUID    series instance UID of the item to be selected
         *  @param  instanceUID  SOP instance UID of the item to be selected
         ** @return status, EC_Normal if successful, an error code otherwise
         */
        public E_Condition gotoItem(string studyUID, string seriesUID, string instanceUID)
        {
            E_Condition result = E_Condition.EC_IllegalParameter;
            /* check parameters first */
            if (!string.IsNullOrEmpty(studyUID) && !string.IsNullOrEmpty(seriesUID) && !string.IsNullOrEmpty(instanceUID))
            {
                /* search for given study */
                StudyStruct study = gotoStudy(studyUID);
                if (study != null)
                {
                    /* do the same for the series ... */
                    SeriesStruct series = study.gotoSeries(seriesUID);
                    if (series != null)
                    {
                        /* ... and instance level */
                        if (series.gotoInstance(instanceUID) != null)
                        {
                            result = E_Condition.EC_Normal;
                        }
                    }
                }
            }
            return result;
        }

        /** select the first item in the list.
         *  That means the first instance in the first series of the first study
         *  is selected (if available).
         ** @return status, EC_Normal if successful, an error code otherwise.
         *    (e.g. if the list is empty)
         */
        public E_Condition gotoFirstItem()
        {
            E_Condition result = E_Condition.EC_IllegalCall;
            /* check for empty study list */
            if (StudyList.Any())
            {
                /* set cursor to first list item */
                Iterator = StudyList.ElementAt(0);
                if(Iterator != null)
                {
                    /* do the same for series and instance level */
                    result = ((StudyStruct)Iterator).gotoFirstItem();
                }
            }

            return result;
        }

        /** select the next item in the list.
         *  That means the next instance in the current series, or the first instance
         *  in the next series, or the first instance in the first series of the next
         *  study is selected (if available).  The combination of this function and
         *  gotoFirstItem() allows to iterate over all referenced SOP instances.
         ** @return status, EC_Normal if successful, an error code otherwise.
         *    (e.g. if the end of the list has been reached)
         */
        public E_Condition gotoNextItem()
        {
            E_Condition result = E_Condition.EC_IllegalCall;
            /* goto next list item */
            /* check whether current list item is valid */
            if (Iterator != null)
            {
                /* try to go to the next instance item */
                result = ((StudyStruct)Iterator).gotoNextItem();
                /* if this fails ... */
                if (result.bad())
                {
                    /* goto to the first series/instance of the next stidy item */
                    int idx = StudyList.IndexOf(Iterator);
                    idx += 1;
                    Iterator = null;
                    try
                    {
                        Iterator = StudyList.ElementAt(idx);
                    }
                    catch(Exception ex)
                    {
                    }

                    if (Iterator != null)
                    {
                        result = ((StudyStruct)Iterator).gotoFirstItem();
                    }
                }
            }
            else
            {
                result = E_Condition.EC_CorruptedData;
            }

            return result;
        }

        /** get the study instance UID of the currently selected entry
         ** @param  stringValue  reference to string variable in which the result is stored
         ** @return reference to the resulting string (might be empty)
         */
        public string getStudyInstanceUID(ref string stringValue)
        {
            /* check whether current study is valid */
            StudyStruct study = getCurrentStudy();
            /* get study instance UID or clear string if invalid */
            if (study != null)
            {
                stringValue = study.StudyUID;
            }
            else
            {
                stringValue = string.Empty;
            }
            return stringValue;
        }

        /** get the series instance UID of the currently selected entry
         ** @param  stringValue  reference to string variable in which the result is stored
         ** @return reference to the resulting string (might be empty)
         */
        public string getSeriesInstanceUID(ref string stringValue)
        {
            /* check whether current series is valid */
            SeriesStruct series = getCurrentSeries();
            /* get series instance UID or clear string if invalid */
            if (series != null)
            {
                stringValue = series.SeriesUID;
            }
            else
            {
                stringValue = string.Empty;
            }
            return stringValue;
        }

        /** get the SOP instance UID of the currently selected entry
         ** @param  stringValue  reference to string variable in which the result is stored
         ** @return reference to the resulting string (might be empty)
         */
        public string getSOPInstanceUID(ref string stringValue)
        {
            /* check whether current instance is valid */
            InstanceStruct instance = getCurrentInstance();
            /* get SOP instance UID or clear string if invalid */
            if (instance != null)
            {
                stringValue = instance.InstanceUID;
            }
            else
            {
                stringValue = string.Empty;
            }
            return stringValue;
        }

        /** get the SOP class UID of the currently selected entry
         ** @param  stringValue  reference to string variable in which the result is stored
         ** @return reference to the resulting string (might be empty)
         */
        public string getSOPClassUID(ref string stringValue)
        {
            /* check whether current instance is valid */
            InstanceStruct instance = getCurrentInstance();
            /* get SOP class UID or clear string if invalid */
            if (instance != null)
            {
                stringValue = instance.SOPClassUID;
            }
            else
            {
                stringValue = string.Empty;
            }
            return stringValue;
        }

        /** get the retrieve application entity title of the currently selected entry (optional).
         *  The resulting string may contain multiple values separated by a backslash ("\").
         ** @param  stringValue  reference to string variable in which the result is stored
         ** @return reference to the resulting string (might be empty)
         */
        public string getRetrieveAETitle(ref string stringValue)
        {
            /* check whether current series is valid */
            SeriesStruct series = getCurrentSeries();
            /* get retrieve application entity title or clear string if invalid */
            if (series != null)
            {
                stringValue = series.RetrieveAETitle;
            }
            else
            {
                stringValue = string.Empty;
            }
            return stringValue;
        }

        /** get the storage media file set ID of the currently selected entry (optional)
         ** @param  stringValue  reference to string variable in which the result is stored
         ** @return reference to the resulting string (might be empty)
         */
        public string getStorageMediaFileSetID(ref string stringValue)
        {
            /* check whether current series is valid */
            SeriesStruct series = getCurrentSeries();
            /* get storage media file set ID or clear string if invalid */
            if (series != null)
            {
                stringValue = series.StorageMediaFileSetID;
            }
            else
            {
                stringValue = string.Empty;
            }
            return stringValue;
        }

        /** get the storage media file set UID of the currently selected entry (optional)
         ** @param  stringValue  reference to string variable in which the result is stored
         ** @return reference to the resulting string (might be empty)
         */
        public string getStorageMediaFileSetUID(ref string stringValue)
        {
            /* check whether current series is valid */
            SeriesStruct series = getCurrentSeries();
            /* get storage media file set UID or clear string if invalid */
            if (series != null)
            {
                stringValue = series.StorageMediaFileSetUID;
            }
            else
            {
                stringValue = string.Empty;
            }
            return stringValue;
        }

        /** set the retrieve application entity title of the currently selected entry.
         *  Multiple values are to be separated by a backslash ("\").
         ** @param  value  string value to be set (use empty string to omit optional attribute)
         ** @return status, EC_Normal if successful, an error code otherwise
         */
        public E_Condition setRetrieveAETitle(string value)
        {
            E_Condition result = E_Condition.EC_IllegalCall;
            /* check whether current series is valid */
            SeriesStruct series = getCurrentSeries();
            if (series != null)
            {
                /* set the value */
                series.RetrieveAETitle = value;
                result = E_Condition.EC_Normal;
            }
            return result;
        }

        /** set the storage media file set ID of the currently selected entry
         ** @param  value  string value to be set (use empty string to omit optional attribute)
         ** @return status, EC_Normal if successful, an error code otherwise
         */
        public E_Condition setStorageMediaFileSetID(string value)
        {
            E_Condition result = E_Condition.EC_IllegalCall;
            /* check whether current series is valid */
            SeriesStruct series = getCurrentSeries();
            if (series != null)
            {
                /* set the value */
                series.StorageMediaFileSetID = value;
                result = E_Condition.EC_Normal;
            }
            return result;
        }

        /** set the storage media file set UID of the currently selected entry
         ** @param  value  string value to be set (use empty string to omit optional attribute)
         ** @return status, EC_Normal if successful, an error code otherwise
         */
        public E_Condition setStorageMediaFileSetUID(string value)
        {
            E_Condition result = E_Condition.EC_IllegalCall;
            /* check whether current series is valid */
            SeriesStruct series = getCurrentSeries();
            if (series != null)
            {
                /* set the value */
                series.StorageMediaFileSetUID = value;
                result = E_Condition.EC_Normal;
            }
            return result;
        }

        /** set cursor to the specified study entry (if existent)
         ** @param  studyUID  study instance UID of the entry to be searched for
         ** @return pointer to the study structure if successful, NULL otherwise
         */
        protected StudyStruct gotoStudy(string studyUID)
        {
            /* first, check whether the current study is the one we're searching for */
            int index = StudyList.FindIndex(f => f.StudyUID == studyUID);
            if (index >= 0)
            {
                return StudyList.ElementAt(index);
            }

            return null;
        }

        /** get pointer to currently selected study structure (if any)
         ** @return pointer to the study structure if successful, NULL otherwise
         */
        protected StudyStruct getCurrentStudy()
        {
            StudyStruct study = null;
            /* check whether current study is valid */
            study = ((StudyStruct)Iterator);
            return study;
        }

        /** get pointer to currently selected series structure (if any)
         ** @return pointer to the series structure if successful, NULL otherwise
         */
        protected SeriesStruct getCurrentSeries()
        {
            SeriesStruct series = null;
            StudyStruct study = getCurrentStudy();
            /* check whether current series is valid */
            if (study != null)
            {
                series = ((SeriesStruct)study.Iterator);
            }

            return series;
        }

        /** get pointer to currently selected instance structure (if any)
         ** @return pointer to the instance structure if successful, NULL otherwise
         */
        protected InstanceStruct getCurrentInstance()
        {
            InstanceStruct instance = null;
            SeriesStruct series = getCurrentSeries();
            /* check whether current instance is valid */
            if (series != null)
            {
                instance = (series.Iterator);
            }

            return instance;
        }

        /** remove empty/incomplete items from the list.
         *  (e.g. series with no instances or studies with no series)
         *  Please note that this function modifies the value of 'Iterator'.
         */
        protected void removeIncompleteItems()
        {
            foreach (StudyStruct study in StudyList)
            {
                if(study ==null)
                {
                    continue;
                }

                /* remove empty/incomplete items on series/instance level */
                study.removeIncompleteItems();

                /* check whether list of series is empty */
                if (!study.SeriesList.Any())
                {
                    /* if so, remove study from list and set iterator to the next item */
                    StudyList.Remove(Iterator);
                }
            }
        }

        /// DICOM tag specifying the attribute (sequence) of the reference list
        DicomAttribute SequenceTag;

        /// list of studies
        List<StudyStruct> StudyList;

        StudyStruct Iterator;
    }

    /** Internal structure defining the instance list items
    */
    public class InstanceStruct
    {
        /** constructor
         ** @param  sopClassUID  SOP class UID
         ** @param  instanceUID  SOP instance UID
         */
        public InstanceStruct(string sopClassUID, string instanceUID)
        {
            SOPClassUID = sopClassUID;
            InstanceUID = instanceUID;
        }
        /// SOP class UID (VR=UI, VM=1)
        public string SOPClassUID { get; set; }
        /// SOP instance UID (VR=UI, VM=1)
        public string InstanceUID { get; set; }
    }

    /** Internal structure defining the series list items
    */
    public class SeriesStruct : DSRTypes
    {
        /** constructor
         ** @param  seriesUID  series instance UID
         */
        public SeriesStruct(string seriesUID)
        {
            SeriesUID = seriesUID;
            RetrieveAETitle = string.Empty;
            StorageMediaFileSetID = string.Empty;
            StorageMediaFileSetUID = string.Empty;
            InstanceList = new List<InstanceStruct>();
            Iterator = null;
        }

        /** destructor
         */
        ~SeriesStruct()
        {
            /* delete all items and free memory */
            InstanceList.Clear();
        }

        /** get number of instance stored in the list of instances
         ** @return number of instances
         */
        public int getNumberOfInstances()
        {
            if (InstanceList == null)
            {
                return -1;
            }

            return InstanceList.Count;
        }

        /** read instance level attributes from dataset
         ** @param  dataset    DICOM dataset from which the list should be read
         ** @return status, EC_Normal if successful, an error code otherwise
         */
        public E_Condition read(DicomAttributeCollection dataset)
        {
            string retrieveAETitle = string.Empty;
            string storageMediaFileSetID = string.Empty;
            string storageMediaFileSetUID = string.Empty;

            /* first, read optional attributes on series level */
            getAndCheckStringValueFromDataset(dataset, getDicomAttribute(DicomTags.RetrieveAeTitle), ref retrieveAETitle, "1-n", "3", "ReferencedSeriesSequence");
            getAndCheckStringValueFromDataset(dataset, getDicomAttribute(DicomTags.StorageMediaFileSetId), ref storageMediaFileSetID, "1", "3", "ReferencedSeriesSequence");
            getAndCheckStringValueFromDataset(dataset,  getDicomAttribute(DicomTags.StorageMediaFileSetUid) , ref storageMediaFileSetUID, "1", "3", "ReferencedSeriesSequence");

            RetrieveAETitle = retrieveAETitle;
            StorageMediaFileSetID = storageMediaFileSetID;
            StorageMediaFileSetUID = storageMediaFileSetID;

            /* then, check whether sequence is present and non-empty */
            DicomAttribute sequence = getDicomAttribute(DicomTags.ReferencedSopSequence);
            E_Condition result = getElementFromDataset(dataset, ref sequence);
            checkElementValue(sequence, "1-n", "1", result);
            if (result.good())
            {
                /* iterate over all sequence items */
                for (int i = 0; i < sequence.Count; i++)
                {
                    DicomSequenceItem item = ((DicomSequenceItem[])sequence.Values)[i];
                    if (item != null)
                    {
                        /* get the SOP class and SOP instance UID */
                        string sopClassUID = string.Empty;
                        string instanceUID = string.Empty;
                        if (getAndCheckStringValueFromDataset(item, getDicomAttribute(DicomTags.ReferencedSopClassUid), ref sopClassUID, "1", "1", "ReferencedSOPSequence").good() &&
                            getAndCheckStringValueFromDataset(item, getDicomAttribute(DicomTags.ReferencedSopInstanceUid), ref instanceUID, "1", "1", "ReferencedSOPSequence").good())
                        {
                            /* check whether instance item already exists */
                            InstanceStruct instance = gotoInstance(instanceUID);
                            if (instance == null)
                            {
                                /* if not, create new instance list item */
                                instance = new InstanceStruct(sopClassUID, instanceUID);
                                if (instance != null)
                                {
                                    /* add add it to the list of instances */
                                    InstanceList.Add(instance);
                                }
                                else
                                {
                                    result = E_Condition.EC_MemoryExhausted;
                                    break;
                                }
                            }
                            else
                            {
                                /* report a warning message and ignore this entry */
                                //TODO: Log
                            }
                        }
                    }
                }
            }

            return result;
        }

        /** write series and instance level attributes to dataset
         ** @param  dataset    DICOM dataset to which the list should be written
         ** @return status, EC_Normal if successful, an error code otherwise
         */
        public E_Condition write(DicomAttributeCollection dataset)
        {
            E_Condition result = E_Condition.EC_Normal;
            /* store the series level attributes */
            putStringValueToDataset(dataset, getDicomAttribute(DicomTags.SeriesInstanceUid), SeriesUID);
            /* write optional attributes if non-empty */
            if (!string.IsNullOrEmpty(RetrieveAETitle))
            {
                putStringValueToDataset(dataset, getDicomAttribute(DicomTags.RetrieveAeTitle), RetrieveAETitle);
            }

            if (!string.IsNullOrEmpty(StorageMediaFileSetID))
            {
                putStringValueToDataset(dataset, getDicomAttribute(DicomTags.StorageMediaFileSetId), StorageMediaFileSetID);
            }

            if (!string.IsNullOrEmpty(StorageMediaFileSetUID))
            {
                putStringValueToDataset(dataset, getDicomAttribute(DicomTags.StorageMediaFileSetUid), StorageMediaFileSetUID);
            }

            /* iterate over all list items */
            foreach(InstanceStruct instance in InstanceList)
            {
                if(instance == null)
                {
                    continue;
                }

                DicomSequenceItem item = null;
                /* create a new item (and a sequence if required) */
                DicomAttribute sequence = getDicomAttribute(DicomTags.ReferencedSopSequence);
                result = getElementFromDataset(dataset, ref sequence);
                if (result.good())
                {
                    item = ((DicomSequenceItem[])sequence.Values)[0];
                }
                else
                {
                    item = new DicomSequenceItem();
                }

                if (item != null)
                {
                    /* store the instance level attributes */
                    putStringValueToDataset(item, getDicomAttribute(DicomTags.ReferencedSopClassUid), instance.SOPClassUID);
                    putStringValueToDataset(item, getDicomAttribute(DicomTags.ReferencedSopInstanceUid), instance.InstanceUID);
                }
            }

            return result;
        }

        /** read series and instance level attributes from XML document
         ** @param  doc     document containing the XML file content
         *  @param  cursor  cursor pointing to the starting node
         ** @return status, EC_Normal if successful, an error code otherwise
         */
        public E_Condition readXML(ref DSRXMLDocument doc, DSRXMLCursor cursor)
        {
            E_Condition result = E_Condition.SR_EC_InvalidDocument;
            if (cursor!=null)
            {
                DSRXMLCursor tempcursor = null;
                string retrieveAETitle = string.Empty;
                tempcursor = doc.getNamedNode(cursor, "aetitle", false /*required*/);
                /* first, read optional elements on series level */
                doc.getStringFromNodeContent(tempcursor, ref retrieveAETitle);
                RetrieveAETitle = retrieveAETitle;
                DSRXMLCursor childCursor = doc.getNamedNode(cursor, "fileset", false /*required*/);
                if (childCursor.Node != null)
                {
                    string storageMediaFileSetUID = string.Empty;
                    doc.getStringFromAttribute(childCursor,  ref storageMediaFileSetUID, "uid", false /*encoding*/, false /*required*/);
                    StorageMediaFileSetUID = storageMediaFileSetUID;
                    string storageMediaFileSetID = string.Empty;
                    doc.getStringFromNodeContent(childCursor, ref storageMediaFileSetUID);
                    StorageMediaFileSetUID = storageMediaFileSetUID;
                }
                /* then proceed with instance level elements */
                string sopClassUID = string.Empty;
                string instanceUID = string.Empty;
                do
                {
                    /* iterate over all "value" elements */
                    cursor = doc.getNamedNode(cursor, "value");
                    if (cursor.Node != null)
                    {
                        tempcursor = null;
                        DSRXMLCursor tempchildcursor = null;
                        string sopUid, instanceUid;

                        tempchildcursor = cursor.getChild();
                        tempcursor = doc.getNamedNode(tempchildcursor, "sopclass");
                        sopUid = doc.getStringFromAttribute(tempcursor, ref sopClassUID, "uid");

                        tempcursor = doc.getNamedNode(tempchildcursor.gotoNext(), "instance");
                        instanceUid = doc.getStringFromAttribute(tempcursor, ref instanceUID, "uid");
                        if (!string.IsNullOrEmpty(sopUid) && !string.IsNullOrEmpty(instanceUid))
                        {
                            /* check whether instance item already exists,
                               because the internal structure is organized in a strictly hierarchical manner  */
                            InstanceStruct instance = gotoInstance(instanceUID);
                            if (instance == null)
                            {
                                /* if not, create a new instance list item */
                                instance = new InstanceStruct(sopClassUID, instanceUID);
                                if (instance != null)
                                {
                                    /* and add it to the list of instances */
                                    InstanceList.Add(instance);
                                    /* set cursor to new position */
                                    Iterator = InstanceList.ElementAt(InstanceList.Count - 1);
                                    result = E_Condition.EC_Normal;
                                }
                                else
                                {
                                    result = E_Condition.EC_MemoryExhausted;
                                    break;
                                }
                            }
                            else
                            {
                                /* report a warning message and ignore this entry */
                                //DCMSR_WARN("SOP Instance \"" << instanceUID << "\" already exists in reference list ... ignoring");
                            }
                        }
                        /* proceed with next node */
                        cursor.gotoNext();
                    }
                } while (cursor.Node != null);
                /* report a warning message if no "value" element found */
                if (result.bad())
                {
                    //DCMSR_WARN("Series \"" << SeriesUID << "\" empty in reference list ... ignoring");
                }
            }
            return result;
        }

        /** write series and instance level attributes in XML format
         ** @param  stream  output stream to which the XML document is written
         *  @param  flags   optional flag used to customize the output (see DSRTypes::XF_xxx)
         ** @return status, EC_Normal if successful, an error code otherwise
         */
        public E_Condition writeXML(ref StringBuilder stream, int flags = 0)
        {
            StringBuilder stringStream = new StringBuilder();
            /* write the series level attributes */
            stream.Append("<series uid=\"");
            stream.Append(SeriesUID);
            stream.Append("\">");
            writeStringValueToXML(stream, RetrieveAETitle, "aetitle", (flags & XF_writeEmptyTags) > 0);
            if ((flags & XF_writeEmptyTags) != 0 || !string.IsNullOrEmpty(StorageMediaFileSetUID) || !string.IsNullOrEmpty(StorageMediaFileSetID))
            {
                stream.Append("<fileset");
                if (!string.IsNullOrEmpty(StorageMediaFileSetUID))
                {
                    stream.Append(" uid=\"");
                    stream.Append(StorageMediaFileSetUID);
                    stream.Append("\"");
                }
                stream.Append(">");
                stream.Append(StorageMediaFileSetID);
                stream.Append("</fileset>");
                stream.Append(Environment.NewLine);
            }

            /* iterate over all list items */

            foreach(InstanceStruct instance in InstanceList)
            {
                /* check whether list item really exists */
                if(instance == null)
                {
                    continue;
                }

                /* write instance level */
                stream.Append("<value>");
                stream.Append(Environment.NewLine);
                stream.Append("<sopclass uid=\"");
                stream.Append(instance.SOPClassUID);
                stream.Append("\">");
                /* retrieve name of SOP class */
                //TODO: Need to handle dcmFindNameOfUID
                //const char *sopClass = dcmFindNameOfUID(instance->SOPClassUID.c_str());
                //if (sopClass != NULL)
                //    stream << sopClass;
                stream.Append("</sopclass>");
                stream.Append(Environment.NewLine);
                stream.Append("<instance uid=\"");
                stream.Append(instance.InstanceUID);
                stream.Append("\"/>");
                stream.Append(Environment.NewLine);
                stream.Append("</value>");
                stream.Append(Environment.NewLine);
            }

            stream.Append("</series>");
            stream.Append(Environment.NewLine);

            return E_Condition.EC_Normal;
        }

        /** set cursor to the specified instance (if existent)
         ** @param  instanceUID  SOP instance UID of the entry to be searched for
         ** @return pointer to the instance structure if successful, NULL otherwise
         */
        public InstanceStruct gotoInstance(string instanceUID)
        {
            InstanceStruct instance = null;
            /* first, check whether the current instance is the one we're searching for */
            if (Iterator != null && Iterator.InstanceUID == instanceUID)
            {
                instance = Iterator;
            }
            else
            {
                /* start with the first list item */
                if (InstanceList.Count == 0)
                {
                    return null;
                }

                Iterator = InstanceList.ElementAt(0);
                foreach (InstanceStruct instanceStruct in InstanceList)
                {
                    /* search for given SOP instance UID */
                    if (instanceStruct == null)
                    {
                        continue;
                    }

                    if (instanceStruct.InstanceUID != instanceUID)
                    {
                        continue;
                    }

                    /* item found */
                    instance = Iterator = instanceStruct;
                    break;
                }
            }

            return instance;
        }

        /** select the first item in the list.
         *  That means the first instance in the current series.
         ** @return status, EC_Normal if successful, an error code otherwise
         */
        public E_Condition gotoFirstItem()
        {
            E_Condition result = E_Condition.EC_IllegalCall;
            /* check for empty instance list */
            if (InstanceList.Any())
            {
                /* set cursor to first list item */
                Iterator = InstanceList.ElementAt(0);
                /* check whether list item is valid */
                if (Iterator != null)
                {
                    result = E_Condition.EC_Normal;
                }
                else
                {
                    result = E_Condition.EC_CorruptedData;
                }
            }
            return result;
        }

        /** select the next item in the list.
         *  That means the next instance in the current series (if available).
         ** @return status, EC_Normal if successful, an error code otherwise
         */
        public E_Condition gotoNextItem()
        {
            E_Condition result = E_Condition.EC_IllegalCall;
            /* goto next list item */

            int currentIndex = InstanceList.IndexOf(Iterator);
            Iterator = null;

            foreach(InstanceStruct instantStruct in InstanceList)
            {
                if(instantStruct == null)
                {
                    continue;
                }

                if (instantStruct == Iterator)
                {
                    continue;
                }

                if (currentIndex < InstanceList.IndexOf(instantStruct))
                {
                    Iterator = instantStruct;
                    break;
                }
            }

            /* check whether list item is valid */
            if (Iterator != null)
            {
                result = E_Condition.EC_Normal;
            }
            else
            {
                result = E_Condition.EC_CorruptedData;
            }

            return result;
        }
        /** add new entry to the list of instances (if not already existent).
         *  Finally, the specified item is selected as the current one.
         ** @param  sopClassUID  SOP class UID of the entry to be added
         *  @param  instanceUID  SOP instance UID of the entry to be added
         ** @return status, EC_Normal if successful, an error code otherwise
         */
        public E_Condition addItem(string sopClassUID, string instanceUID)
        {
            E_Condition result = E_Condition.EC_Normal;
            /* check whether series already exists */
            InstanceStruct instance = gotoInstance(instanceUID);
            if (instance == null)
            {
                /* if not, create new instance item and add it to the list */
                instance = new InstanceStruct(sopClassUID, instanceUID);
                if (instance != null)
                {
                    InstanceList.Add(instance);
                    /* set cursor to new position */
                    Iterator = InstanceList.ElementAt(InstanceList.Count - 1);
                }
                else
                {
                    result = E_Condition.EC_MemoryExhausted;
                }
            }
            else
            {
                /* check whether given SOP class is the same as stored */
                if (instance.SOPClassUID != sopClassUID)
                {
                    result = E_Condition.SR_EC_DifferentSOPClassesForAnInstance;
                }
            }
            return result;
        }

        /** remove the current item from the list of instances.
         *  After sucessful removal the cursor is set to the next valid position.
         ** @return status, EC_Normal if successful, an error code otherwise
         */
        public E_Condition removeItem()
        {
            E_Condition result = E_Condition.EC_IllegalCall;
            /* check whether list is empty or iterator is invalid */
            if (InstanceList.Any() && Iterator != null)
            {
                /* remove item from list */
                int idx = InstanceList.IndexOf(Iterator);
                InstanceList.Remove(Iterator);
                Iterator = InstanceList.ElementAt(idx);
                result = E_Condition.EC_Normal;
            }
            return result;
        }

        /// series instance UID (VR=UI, VM=1)
        public string SeriesUID { get; set; }
        /// optional: retrieve application entity title (VR=AE, VM=1-n)
        public string RetrieveAETitle { get; set; }
        /// optional: storage media file set ID (VR=SH, VM=1)
        public string StorageMediaFileSetID { get; set; }
        /// optional: storage media file set UID (VR=UI, VM=1)
        public string StorageMediaFileSetUID { get; set; }

        /// list of referenced instances
        public List<InstanceStruct> InstanceList = new List<InstanceStruct>();

        public InstanceStruct Iterator { get; set; }
    }

    /** Internal structure defining the study list items
    */
    public class StudyStruct : DSRTypes
    {
        /** constructor
         ** @param  studyUID  study instance UID
         */
        public StudyStruct(string studyUID)
        {
            StudyUID = studyUID;
            SeriesList = new List<SeriesStruct>();
            if (SeriesList.Count > 0)
            {
                Iterator = SeriesList.ElementAt(0);
            }
        }

        /** destructor
         */
        ~StudyStruct()
        {
            SeriesList.Clear();
        }

        /** get number of instance stored in the list of series
         ** @return number of instances
         */
        public int getNumberOfInstances()
        {
            int result = 0;
            foreach (SeriesStruct series in SeriesList)
            {
                result += series.getNumberOfInstances();
            }

            return result;
        }

        /** read series and instance level from dataset
         ** @param  dataset    DICOM dataset from which the list should be read
         ** @return status, EC_Normal if successful, an error code otherwise
         */
        public E_Condition read(DicomAttributeCollection dataset)
        {
            /* first, check whether sequence is present and non-empty */
            DicomAttribute sequence = getDicomAttribute(DicomTags.ReferencedSeriesSequence);
            E_Condition result = getElementFromDataset(dataset, ref sequence);
            checkElementValue(sequence, "1-n", "1", result);
            if (result.good())
            {
                /* iterate over all sequence items */
                for (int i = 0; i < sequence.Count; i++)
                {
                    DicomSequenceItem item = ((DicomSequenceItem[])sequence.Values)[i];
                    if (item != null)
                    {
                        /* get the series instance UID */
                        string seriesUID = string.Empty;
                        if (getAndCheckStringValueFromDataset(item, getDicomAttribute(DicomTags.SeriesInstanceUid), ref seriesUID, "1", "1", "ReferencedSeriesSequence").good())
                        {
                            /* check whether series item already exists,
                                because the internal structure is organized in a strictly hierarchical manner  */
                            SeriesStruct series = gotoSeries(seriesUID);
                            if (series == null)
                            {
                                /* if not, create a new series list item */
                                series = new SeriesStruct(seriesUID);
                                if (series != null)
                                {
                                    /* and add it to the list of studies */
                                    SeriesList.Add(series);
                                }
                                else
                                {
                                    result = E_Condition.EC_MemoryExhausted;
                                    break;
                                }
                            }

                            if (series != null)
                            {
                                /* read further attributes on series level and the instance level */
                                result = series.read(item);
                            }
                        }
                    }
                }
            }

            return result;
        }

        /** write study, series and instance level attributes to dataset
         ** @param  dataset    DICOM dataset to which the list should be written
         ** @return status, EC_Normal if successful, an error code otherwise
         */
        public E_Condition write(DicomAttributeCollection dataset)
        {
            E_Condition result = E_Condition.EC_Normal;
            /* store the study level attributes */
            putStringValueToDataset(dataset, getDicomAttribute(DicomTags.StudyInstanceUid), StudyUID);

            /* iterate over all list items */
            foreach(SeriesStruct series in SeriesList)
            {
                if(series == null)
                {
                    continue;
                }

                DicomSequenceItem item = null;
                /* create a new item (and a sequence if required) */
                DicomAttribute sequence = getDicomAttribute(DicomTags.ReferencedSeriesSequence);
                result = getElementFromDataset(dataset, ref sequence);
                if (result.good())
                {
                    item = ((DicomSequenceItem[])sequence.Values)[0];
                }
                else
                {
                    item = new DicomSequenceItem();
                }

                /* write series and instance level */
                if (item != null)
                {
                    result = series.write(item);
                }
            }

            return result;
        }

        /** read study, series and instance level attributes from XML document
         ** @param  doc     document containing the XML file content
         *  @param  cursor  cursor pointing to the starting node
         ** @return status, EC_Normal if successful, an error code otherwise
         */
        public E_Condition readXML(ref DSRXMLDocument doc, DSRXMLCursor cursor)
        {
            E_Condition result = E_Condition.SR_EC_InvalidDocument;
            if (cursor != null)
            {
                string seriesUID = string.Empty;
                while (cursor.Node != null)
                {
                    /* check for known element tags */
                    if (doc.checkNode(cursor, "series").good())
                    {
                        if (!string.IsNullOrEmpty(doc.getStringFromAttribute(cursor, ref seriesUID, "uid")))
                        {
                            /* check whether series item already exists,
                               because the internal structure is organized in a strictly hierarchical manner  */
                            SeriesStruct series = gotoSeries(seriesUID);
                            if (series == null)
                            {
                                /* if not, create a new series list item */
                                series = new SeriesStruct(seriesUID);
                                if (series != null)
                                {
                                    /* and add it to the list of series */
                                    SeriesList.Add(series);
                                }
                                else
                                {
                                    result = E_Condition.EC_MemoryExhausted;
                                    break;
                                }
                            }
                            if (series != null)
                            {
                                /* set cursor to new position */
                                Iterator = SeriesList.ElementAt(SeriesList.Count-1);
                                /* read further attributes on series level and the instance level */
                                result = series.readXML(ref doc, cursor.getChild());
                            }
                        }
                    }
                    /* proceed with next node */
                    cursor.gotoNext();
                }
                /* report a warning message if no "value" element found */
                if (result.bad())
                {
                    //DCMSR_WARN("Study \"" << StudyUID << "\" empty in reference list ... ignoring");
                }
            }
            return result;
        }

        /** write study, series and instance level attributes in XML format
         ** @param  stream  output stream to which the XML document is written
         *  @param  flags   optional flag used to customize the output (see DSRTypes::XF_xxx)
         ** @return status, EC_Normal if successful, an error code otherwise
         */
        public E_Condition writeXML(ref StringBuilder stream, int flags = 0)
        {
            E_Condition result = E_Condition.EC_Normal;
            /* write the study level attributes */
            stream.Append("<study uid=\"");
            stream.Append(StudyUID);
            stream.Append("\">");
            stream.Append(Environment.NewLine);
            /* iterate over all list items */
            foreach(SeriesStruct series in SeriesList)
            {
                /* check whether list item really exists */
                if(series==null)
                {
                    continue;
                }

                /* write series and instance level */
                result = series.writeXML(ref stream, flags);
            }

            stream.Append("</study>");
            stream.Append(Environment.NewLine);

            return result;
        }

        /** set cursor to the specified series entry (if existent)
         ** @param  seriesUID  series instance UID of the entry to be searched for
         ** @return pointer to the series structure if successful, NULL otherwise
         */
        public SeriesStruct gotoSeries(string seriesUID)
        {
            SeriesStruct series = null;
            /* first, check whether the current series is the one we're searching for */
            if (Iterator != null && Iterator.SeriesUID == seriesUID)
            {
                series = Iterator;
            }
            else
            {
                /* start with the first list item */
                if (SeriesList.Count == 0)
                {
                    return null;
                }

                Iterator = SeriesList.ElementAt(0);
                foreach (SeriesStruct seriesStruct in SeriesList)
                {
                    if (seriesStruct == null)
                    {
                        continue;
                    }

                    /* search for given series UID */
                    if (seriesStruct.SeriesUID == seriesUID)
                    {
                        Iterator = seriesStruct;
                        series = seriesStruct;
                        break;
                    }
                }
            }

            return series;
        }

        /** set cursor to the specified instance entry (if existent)
         ** @param  instanceUID  SOP instance UID of the entry to be searched for
         ** @return pointer to the instance structure if successful, NULL otherwise
         */
        public InstanceStruct gotoInstance(string instanceUID)
        {
            InstanceStruct instance = null;
            /* start with the first list item */
            Iterator = SeriesList.ElementAt(0);
            foreach (SeriesStruct series in SeriesList)
            {
                /* continue search on instance level */
                if (series != null)
                {
                    instance = series.gotoInstance(instanceUID);
                }
                /* if found exit loop, else goto next */
                if (instance == null)
                {
                    continue;
                }
            }

            return instance;
        }

        /** select the first item in the list.
         *  That means the first instance in the first series of the current study.
         ** @return status, EC_Normal if successful, an error code otherwise
         */
        public E_Condition gotoFirstItem()
        {
            E_Condition result = E_Condition.EC_IllegalCall;
            /* check for empty series list */
            if (SeriesList.Any())
            {
                /* set cursor to first list item */
                Iterator = SeriesList.ElementAt(0);
                /* check whether list item is valid */
                if (Iterator != null)
                {
                    /* do the same for instance level */
                    result = ((SeriesStruct)Iterator).gotoFirstItem();
                }
                else
                {
                    result = E_Condition.EC_CorruptedData;
                }
            }

            return result;
        }

        /** select the next item in the list.
         *  That means the next instance in the current series, or the first instance
         *  in the next series (if available).
         ** @return status, EC_Normal if successful, an error code otherwise
         */
        public E_Condition gotoNextItem()
        {
            E_Condition result = E_Condition.EC_IllegalCall;
            /* goto next list item */
            /* check whether current list item is valid */
            if (Iterator != null)
            {
                /* try to go to the next instance item */
                result = ((SeriesStruct)Iterator).gotoNextItem();
                /* if this fails ... */
                if (result.bad())
                {
                    int idx = SeriesList.IndexOf(Iterator);
                    idx += 1;
                    Iterator = null;
                    try
                    {
                        Iterator = SeriesList.ElementAt(idx);
                    }
                    catch(Exception ex)
                    {
                    }

                    /* goto to the first instance of the next series item */
                    if (Iterator != null)
                    {
                        result = ((SeriesStruct)Iterator).gotoFirstItem();
                    }
                }
            }
            else
            {
                result = E_Condition.EC_CorruptedData;
            }

            return result;
        }

        /** add new entry to the list of series and instances (if not already existent).
         *  Finally, the specified items are selected as the current one.
         ** @param  seriesUID    series instance UID of the entry to be added
         *  @param  sopClassUID  SOP class UID of the entry to be added
         *  @param  instanceUID  SOP instance UID of the entry to be added
         ** @return status, EC_Normal if successful, an error code otherwise
         */
        public E_Condition addItem(string seriesUID, string sopClassUID, string instanceUID)
        {
            E_Condition result = E_Condition.EC_Normal;
            /* check whether series already exists */
            SeriesStruct series = gotoSeries(seriesUID);
            if (series == null)
            {
                /* if not create new series item and add it to the list */
                series = new SeriesStruct(seriesUID);
                if (series != null)
                {
                    SeriesList.Add(series);
                    /* set cursor to new position */
                    Iterator = SeriesList.ElementAt(SeriesList.Count - 1);
                }
                else
                {
                    result = E_Condition.EC_MemoryExhausted;
                }
            }
            /* do the same for the instance level */
            if (series != null)
            {
                result = series.addItem(sopClassUID, instanceUID);
            }
            return result;
        }

        /** remove the current item from the list of series and instances.
         *  After sucessful removal the cursors are set to the next valid position.
         ** @return status, EC_Normal if successful, an error code otherwise
         */
        public E_Condition removeItem()
        {
            E_Condition result = E_Condition.EC_IllegalCall;
            /* check whether list is empty or iterator is invalid */
            if (SeriesList.Any())
            {
                SeriesStruct series = ((SeriesStruct)Iterator);
                if (series != null)
                {
                    result = series.removeItem();
                    /* check whether lower level list has become empty */
                    if (result.good() && !series.InstanceList.Any())
                    {
                        /* if so, remove series from list and set iterator to the next item */
                        int idx = SeriesList.IndexOf(Iterator);
                        SeriesList.Remove(Iterator);
                        Iterator = SeriesList.ElementAt(idx);
                    }
                }
            }

            return result;
        }

        /** remove empty/incomplete items from the list.
         *  (e.g. series with no instances)
         *  Please note that this function modifies the value of 'Iterator'.
         */
        public void removeIncompleteItems()
        {
            Iterator = (SeriesList.Count > 0 ? SeriesList.ElementAt(0) : null);
            foreach(SeriesStruct series in SeriesList)
            {
                if (series != null)
                {
                    /* check whether list of series is empty */
                    if (series.InstanceList.Count == 0)
                    {
                        /* if so, remove series from list and set iterator to the next item */
                        int idx = SeriesList.IndexOf(Iterator);
                        SeriesList.Remove(Iterator);
                        Iterator = SeriesList.ElementAt(idx);
                    }
                }
            }
        }

        /// study instance UID (VR=UI, VM=1)
        public string StudyUID { get; set; }

        /// list of referenced series
        public List<SeriesStruct> SeriesList = new List<SeriesStruct>();

        public SeriesStruct Iterator;
    }
}
