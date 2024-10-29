using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;
using System.Threading.Tasks;
using ClearCanvas.Dicom;

namespace Hydra.Dicom
{
    public class DSRCodingSchemeIdentificationList : DSRTypes
    {
        /** constructor (default)
        */
        public DSRCodingSchemeIdentificationList()
        {
            ItemList = new List<ItemStruct>();
            Iterator = null;
        }

        /** destructor
         */
        ~DSRCodingSchemeIdentificationList()
        {
            /* clear list and delete allocated memory */
            clear();
        }

        /** clear the list
         */
        public void clear()
        {
            ItemList.Clear();
        }

        /** check whether list is empty
         ** @return OFTrue if list is empty, OFFalse otherwise
         */
        public bool empty()
        {
            return !ItemList.Any();
        }

        /** get number of items stored in the list
        ** @return number of items
        */
        public int getNumberOfItems()
        {
            return ItemList.Count;
        }

        /** read list of items from the coding scheme identification sequence
         ** @param  dataset    DICOM dataset from which the data should be read
         ** @return status, EC_Normal if successful, an error code otherwise
         */
        public E_Condition read(DicomAttributeCollection dataset)
        {
            /* first, check whether sequence is present and non-empty */
            DicomAttribute sequence = getDicomAttribute(DicomTags.CodingSchemeIdentificationSequence);
            E_Condition result = getElementFromDataset(dataset, ref sequence);
            checkElementValue(sequence, "1-n", "3", result, "SOPCommonModule");
            if (result.good())
            {
                ItemStruct item = null;
                string codingSchemeDesignator = string.Empty;
                /* iterate over all sequence items */
                for (int i = 0; i < sequence.Count; i++)
                {
                    DicomSequenceItem ditem = ((DicomSequenceItem[])sequence.Values)[i];
                    if (ditem != null)
                    {
                        /* get the coding scheme designator */
                        if (getAndCheckStringValueFromDataset(ditem, getDicomAttribute(DicomTags.CodingSchemeDesignator), ref codingSchemeDesignator, "1", "1", "CodingSchemeIdentificationSequence").good())
                        {
                            /* add new item to the list */
                            if (addItem(codingSchemeDesignator, ref item).good())
                            {
                                string codingSchemeRegistry = string.Empty;
                                string codingSchemeUID = string.Empty;
                                string codingSchemeExternalID = string.Empty;
                                string codingSchemeName = string.Empty;
                                string codingSchemeVersion = string.Empty;
                                string responsibleOrganization = string.Empty;

                                /* read additional information */
                                getAndCheckStringValueFromDataset(ditem, getDicomAttribute(DicomTags.CodingSchemeRegistry), ref codingSchemeRegistry, "1", "1C", "CodingSchemeIdentificationSequence");
                                getAndCheckStringValueFromDataset(ditem, getDicomAttribute(DicomTags.CodingSchemeUid), ref codingSchemeUID, "1", "1C", "CodingSchemeIdentificationSequence");
                                getAndCheckStringValueFromDataset(ditem, getDicomAttribute(DicomTags.CodingSchemeExternalId), ref codingSchemeExternalID, "1", "2C", "CodingSchemeIdentificationSequence");
                                getAndCheckStringValueFromDataset(ditem, getDicomAttribute(DicomTags.CodingSchemeName), ref  codingSchemeName, "1", "3", "CodingSchemeIdentificationSequence");
                                getAndCheckStringValueFromDataset(ditem, getDicomAttribute(DicomTags.CodingSchemeVersion), ref codingSchemeVersion, "1", "3", "CodingSchemeIdentificationSequence");
                                getAndCheckStringValueFromDataset(ditem, getDicomAttribute(DicomTags.ResponsibleOrganization), ref responsibleOrganization, "1", "3", "CodingSchemeIdentificationSequence");

                                item.CodingSchemeRegistry = codingSchemeRegistry;
                                item.CodingSchemeUID = codingSchemeUID;
                                item.CodingSchemeExternalID = codingSchemeExternalID;
                                item.CodingSchemeName = codingSchemeName;
                                item.CodingSchemeVersion = codingSchemeVersion;
                                item.ResponsibleOrganization = responsibleOrganization;
                            }
                        }
                    }
                }
            }

            return result;
        }

        /** write list of items to the coding scheme identification sequence.
         *  Does nothing if list is empty.
         ** @param  dataset    DICOM dataset to which the data should be written
         ** @return status, EC_Normal if successful, an error code otherwise
         */
        public E_Condition write(ref DicomAttributeCollection dataset)
        {
            //TODO: DSRCodingSchemeIdentificationList.write // Need to be corrected while debugging
            E_Condition result = E_Condition.EC_Normal;
            foreach (ItemStruct item in ItemList)
            {
                /* check whether list item really exists and is valid */
                if ((item != null) && !string.IsNullOrEmpty(item.CodingSchemeDesignator))
                {
                    DicomSequenceItem ditem = null;
                    /* create a new item (and a sequence if required) */
                    DicomAttribute sequence = getDicomAttribute(DicomTags.CodingSchemeIdentificationSequence);
                    result = getElementFromDataset(dataset, ref sequence);
                    if (result.good())
                    {
                        ditem = ((DicomSequenceItem[])sequence.Values)[0];
                    }
                    else
                    {
                        ditem = new DicomSequenceItem();
                    }

                    if(ditem != null)
                    {
                        putStringValueToDataset(ditem, getDicomAttribute(DicomTags.CodingSchemeDesignator), item.CodingSchemeDesignator);
                        putStringValueToDataset(ditem, getDicomAttribute(DicomTags.CodingSchemeRegistry), item.CodingSchemeRegistry, false /*allowEmpty*/);
                        putStringValueToDataset(ditem, getDicomAttribute(DicomTags.CodingSchemeUid), item.CodingSchemeUID, false /*allowEmpty*/);
                        if(string.IsNullOrEmpty(item.CodingSchemeUID))
                        {
                            putStringValueToDataset(ditem, getDicomAttribute(DicomTags.CodingSchemeExternalId), item.CodingSchemeExternalID, false /*allowEmpty*/);
                        }
                        else if (!string.IsNullOrEmpty(item.CodingSchemeExternalID))
                        {
                            //DCMSR_WARN("Both CodingSchemeUID and CodingSchemeExternalID present for \""
                            //<< item->CodingSchemeDesignator << "\", the latter will be ignored");
                        }
                        putStringValueToDataset(ditem, getDicomAttribute(DicomTags.CodingSchemeName), item.CodingSchemeName, false /*allowEmpty*/);
                        putStringValueToDataset(ditem, getDicomAttribute(DicomTags.CodingSchemeVersion), item.CodingSchemeVersion, false /*allowEmpty*/);
                        putStringValueToDataset(ditem, getDicomAttribute(DicomTags.ResponsibleOrganization), item.ResponsibleOrganization, false /*allowEmpty*/);
                    } 
                }
            }

            return result;
        }

        /** read list of items from XML document
         ** @param  doc     document containing the XML file content
         *  @param  cursor  cursor pointing to the starting node
         *  @param  flags   optional flag used to customize the reading process (see DSRTypes::XF_xxx)
         ** @return status, EC_Normal if successful, an error code otherwise
         */
        public E_Condition readXML(DSRXMLDocument doc, DSRXMLCursor cursor, int flags)
        {
            //TODO: DSRCodingSchemeIdentificationList.readXML need to replace isValid(DSRXMLCursor)
            E_Condition result = E_Condition.SR_EC_InvalidDocument;
            ItemStruct item = null;
            string codingSchemeDesignator = string.Empty;
            if (cursor != null)
            {
                /* check for known element tags */
                if (doc.checkNode(cursor, "scheme").good())
                {
                    /* retrieve coding scheme designator */
                    if (!string.IsNullOrEmpty(doc.getStringFromAttribute(cursor, ref codingSchemeDesignator, "designator", true /*encoding*/)))
                    {
                        result = addItem(codingSchemeDesignator, ref item);
                        if (result.good())
                        {
                            DSRXMLCursor childCursor = cursor.getChild();

                            string CodingSchemeRegistry = string.Empty;
                            string CodingSchemeUID = string.Empty;
                            string CodingSchemeExternalID = string.Empty;
                            string CodingSchemeName = string.Empty;
                            string CodingSchemeVersion = string.Empty;
                            string ResponsibleOrganization = string.Empty;

                            /* clear any previously stored information */
                            item.clear();
                            while (childCursor.Node != null)
                            {
                                /* check for known element tags */
                                doc.getStringFromNodeContent(childCursor, ref CodingSchemeRegistry, "registry", true /*encoding*/, false /*clearString*/);
                                doc.getStringFromNodeContent(childCursor, ref CodingSchemeUID, "uid", false /*encoding*/, false /*clearString*/);
                                doc.getStringFromNodeContent(childCursor, ref CodingSchemeExternalID, "id", true /*encoding*/, false /*clearString*/);
                                doc.getStringFromNodeContent(childCursor, ref CodingSchemeName, "name", true /*encoding*/, false /*clearString*/);
                                doc.getStringFromNodeContent(childCursor, ref CodingSchemeVersion, "version", true /*encoding*/, false /*clearString*/);
                                doc.getStringFromNodeContent(childCursor, ref ResponsibleOrganization, "organization", true /*encoding*/, false /*clearString*/);

                                item.CodingSchemeRegistry = CodingSchemeRegistry;
                                item.CodingSchemeUID = CodingSchemeUID;
                                item.CodingSchemeExternalID = CodingSchemeExternalID;
                                item.CodingSchemeName = CodingSchemeName;
                                item.CodingSchemeVersion = CodingSchemeVersion;
                                item.ResponsibleOrganization = ResponsibleOrganization;
                                /* proceed with next node */
                                childCursor.gotoNext();
                            }
                        }
                    }
                }
                /* proceed with next node */
                cursor.gotoNext();
            }

            return result;
        }

        /** write current list in XML format
         ** @param  stream  output stream to which the XML data is written
         *  @param  flags   optional flag used to customize the output (see DSRTypes::XF_xxx)
         ** @return status, EC_Normal if successful, an error code otherwise
         */
        public E_Condition writeXML(ref StringBuilder stream, int flags = 0)
        {
            string tmpString = string.Empty;
            foreach (ItemStruct item in ItemList)
            {
                if (item == null)
                {
                    continue;
                }

                stream.Append("<scheme designator=\"").Append("\">");
                stream.Append(convertToXMLString(item.CodingSchemeDesignator, tmpString));
                stream.Append("\">");
                stream.Append(Environment.NewLine);

                writeStringValueToXML(stream, convertToXMLString(item.CodingSchemeRegistry, tmpString), "registry", (flags & DSRTypes.XF_writeEmptyTags) > 0);
                writeStringValueToXML(stream, convertToXMLString(item.CodingSchemeUID, tmpString), "uid", (flags & DSRTypes.XF_writeEmptyTags) > 0);
                writeStringValueToXML(stream, convertToXMLString(item.CodingSchemeExternalID, tmpString), "identifier", (flags & DSRTypes.XF_writeEmptyTags) > 0);
                writeStringValueToXML(stream, convertToXMLString(item.CodingSchemeName, tmpString), "name", (flags & DSRTypes.XF_writeEmptyTags) > 0);
                writeStringValueToXML(stream, convertToXMLString(item.CodingSchemeVersion, tmpString), "version", (flags & DSRTypes.XF_writeEmptyTags) > 0);
                writeStringValueToXML(stream, convertToXMLString(item.ResponsibleOrganization, tmpString), "organization", (flags & DSRTypes.XF_writeEmptyTags) > 0);

                stream.Append("</scheme>");
                stream.Append(Environment.NewLine);
            }

            return E_Condition.EC_Normal;
        }

        /** add private OFFIS DCMTK coding scheme entry to the list.
         *  Please note that any information previously stored under the defined coding scheme
         *  designator "99_OFFIS_DCMTK" is replaced!
         ** @return status, EC_Normal if successful, an error code otherwise
         */
        public E_Condition addPrivateDcmtkCodingScheme()
        {
            ItemStruct item = null;
            /* add private coding scheme (if not already existent) */
            E_Condition result = addItem(DSRTypes.OFFIS_CODING_SCHEME_DESIGNATOR, ref item);
            if (result.good())
            {
                /* set additional information */
                item.CodingSchemeRegistry = string.Empty;
                item.CodingSchemeUID = "1.2.276.0.7230010.3.0.0.1";
                item.CodingSchemeExternalID = string.Empty;
                item.CodingSchemeName = "OFFIS DCMTK Coding Scheme";
                item.CodingSchemeVersion = string.Empty; // there are currently no different versions
                item.ResponsibleOrganization = "OFFIS e.V., Escherweg 2, 26121 Oldenburg, Germany";
            }
            return result;
        }

        /** add the specified coding scheme to the list.
         *  Internally, the item is inserted into the list of coding scheme designators if
         *  not already contained in the list.  In any case the specified item is selected as
         *  the current one.  See definition of 'ItemStruct' above for VR, VM and Type.
         ** @param  codingSchemeDesignator  coding scheme designator of the item to be added.
         *                                  Designators beginning with "99" and the designator
         *                                  "L" are defined to be private or local coding schemes.
         ** @return status, EC_Normal if successful, an error code otherwise
         */
        public E_Condition addItem(string codingSchemeDesignator)
        {
            ItemStruct item = null;
            /* call the "real" function */
            return addItem(codingSchemeDesignator, ref item);
        }

        /** remove the current item from the list.
         *  After sucessful removal the cursor is set to the next valid position.
         ** @return status, EC_Normal if successful, an error code otherwise
         */
        public E_Condition removeItem(string codingSchemeDesignator)
        {
            E_Condition result = E_Condition.EC_IllegalCall;
            /* check whether list is empty or iterator is invalid */
            if (ItemList.Any())
            {
                ItemStruct itemToRemove = null;
                foreach (ItemStruct item in ItemList)
                {
                    if (item == null)
                    {
                        continue;
                    }

                    if (string.Compare(item.CodingSchemeDesignator, codingSchemeDesignator) == 0)
                    {
                        itemToRemove = item;
                        break;
                    }
                }

                if (itemToRemove == null)
                {
                    return result;
                }

                ItemList.Remove(itemToRemove);
                result = E_Condition.EC_Normal;
            }
            return result;
        }

        /** remove the specified item from the list.
         *  After sucessful removal the cursor is set to the next valid position.
         ** @param  codingSchemeDesignator  coding scheme designator of the item to be removed
         ** @return status, EC_Normal if successful, an error code otherwise
         */
        //public bool removeItem(string codingSchemeDesignator)
        //{
        //    /* goto specified item ... */
        //    bool result = gotoItem(codingSchemeDesignator);
        //    /* ... and remove it */
        //    if (result)
        //        result = removeItem(codingSchemeDesignator);
        //    return result;
        //}

        /** select the specified item as the current one
         ** @param  codingSchemeDesignator  coding scheme designator of the item to be selected
         ** @return status, EC_Normal if successful, an error code otherwise
         */
        public E_Condition gotoItem(string codingSchemeDesignator)
        {
            E_Condition result = E_Condition.EC_IllegalParameter;
            /* check parameter first */
            if (!string.IsNullOrEmpty(codingSchemeDesignator))
            {
                result = E_Condition.SR_EC_CodingSchemeNotFound;
                int index = ItemList.FindIndex(f => f.CodingSchemeDesignator == codingSchemeDesignator);
                if (index >= 0)
                {
                    result = E_Condition.EC_Normal;
                }
            }

            return result;
        }

        /// <summary>
        /// 
        /// </summary>
        /// <param name="codingSchemeDesignator"></param>
        /// <returns></returns>
        public ItemStruct getItem(string codingSchemeDesignator)
        {
            /* check parameter first */
            if (!string.IsNullOrEmpty(codingSchemeDesignator))
            {
                int index = ItemList.FindIndex(f => f.CodingSchemeDesignator == codingSchemeDesignator);
                if (index >= 0)
                {
                    return ItemList.ElementAt(index);
                }
            }

            return null;
        }

        /** select the first item in the list
         ** @return status, EC_Normal if successful, an error code otherwise.
         *    (e.g. if the list is empty)
         */
        public E_Condition gotoFirstItem()
        {
            E_Condition result = E_Condition.EC_IllegalCall;
            /* check for empty study list */
            if (ItemList.Any())
            {
                /* set cursor to first list item */
                Iterator = ItemList.ElementAt(0);
                result = E_Condition.EC_Normal;
            }
            return result;
        }

        /** select the next item in the list
         ** @return status, EC_Normal if successful, an error code otherwise.
         *    (e.g. if the end of the list has been reached)
         */
        public E_Condition gotoNextItem()
        {
            E_Condition result = E_Condition.EC_IllegalCall;
            /* goto next list item */
            int idx = 0;
            idx = ItemList.IndexOf(Iterator);
            if (idx > -1)
            {
                Iterator = null;
                idx += 1;

                try
                {
                    Iterator = ItemList.ElementAt(idx);
                }
                catch (Exception)
                {
                }

                result = (Iterator != null ? E_Condition.EC_Normal : E_Condition.EC_CorruptedData);
            }

            return result;
        }

        /** get the coding scheme designator of the currently selected item.
         *  Designators beginning with "99" and the designator "L" are defined to be private
         *  or local coding schemes.
         ** @param  stringValue  reference to string variable in which the result is stored
         ** @return reference to the resulting string (might be empty)
         */
        public string getCodingSchemeDesignator(ref string stringValue)
        {
            /* check whether current item is valid */
            ItemStruct item = getCurrentItem();
            /* get requested value or clear string if invalid */
            if (item != null)
            {
                stringValue = item.CodingSchemeDesignator;
            }
            else
            {
                stringValue = string.Empty;
            }
            return stringValue;
        }

        /** get the coding scheme registry of the currently selected item
         ** @param  stringValue  reference to string variable in which the result is stored
         ** @return reference to the resulting string (might be empty)
         */
        public string getCodingSchemeRegistry(ref string stringValue)
        {
            /* check whether current item is valid */
            ItemStruct item = getCurrentItem();
            /* get requested value or clear string if invalid */
            if (item != null)
            {
                stringValue = item.CodingSchemeRegistry;
            }
            else
            {
                stringValue = string.Empty;
            }
            return stringValue;
        }

        /** get the coding scheme UID of the currently selected item
         ** @param  stringValue  reference to string variable in which the result is stored
         ** @return reference to the resulting string (might be empty)
         */
        public string getCodingSchemeUID(ref string stringValue)
        {
            /* check whether current item is valid */
            ItemStruct item = getCurrentItem();
            /* get requested value or clear string if invalid */
            if (item != null)
            {
                stringValue = item.CodingSchemeUID;
            }
            else
            {
                stringValue = string.Empty;
            }
            return stringValue;
        }

        /** get the coding scheme external ID of the currently selected item
         ** @param  stringValue  reference to string variable in which the result is stored
         ** @return reference to the resulting string (might be empty)
         */
        public string getCodingSchemeExternalID(ref string stringValue)
        {
            /* check whether current item is valid */
            ItemStruct item = getCurrentItem();
            /* get requested value or clear string if invalid */
            if (item != null)
            {
                stringValue = item.CodingSchemeExternalID;
            }
            else
            {
                stringValue = string.Empty;
            }
            return stringValue;
        }

        /** get the coding scheme name of the currently selected item
         ** @param  stringValue  reference to string variable in which the result is stored
         ** @return reference to the resulting string (might be empty)
         */
        public string getCodingSchemeName(ref string stringValue)
        {
            /* check whether current item is valid */
            ItemStruct item = getCurrentItem();
            /* get requested value or clear string if invalid */
            if (item != null)
            {
                stringValue = item.CodingSchemeName;
            }
            else
            {
                stringValue = string.Empty;
            }
            return stringValue;
        }

        /** get the coding scheme version of the currently selected item
         ** @param  stringValue  reference to string variable in which the result is stored
         ** @return reference to the resulting string (might be empty)
         */
        public string getCodingSchemeVersion(ref string stringValue)
        {
            /* check whether current item is valid */
            ItemStruct item = getCurrentItem();
            /* get requested value or clear string if invalid */
            if (item != null)
            {
                stringValue = item.CodingSchemeVersion;
            }
            else
            {
                stringValue = string.Empty;
            }
            return stringValue;
        }

        /** get the responsible organization of the currently selected item
         ** @param  stringValue  reference to string variable in which the result is stored
         ** @return reference to the resulting string (might be empty)
         */
        public string getResponsibleOrganization(ref string stringValue)
        {
            /* check whether current item is valid */
            ItemStruct item = getCurrentItem();
            /* get requested value or clear string if invalid */
            if (item != null)
            {
                stringValue = item.ResponsibleOrganization;
            }
            else
            {
                stringValue = string.Empty;
            }
            return stringValue;
        }

        /** set the coding scheme registry of the currently selected entry.
         *  See definition of 'ItemStruct' above for VR, VM and Type.
         ** @param  value  string value to be set (use empty string to omit optional attribute)
         ** @return status, EC_Normal if successful, an error code otherwise
         */
        public E_Condition setCodingSchemeRegistry(string value)
        {
            E_Condition result = E_Condition.EC_IllegalCall;
            /* check whether current item is valid */
            ItemStruct item = getCurrentItem();
            if (item != null)
            {
                /* set the value */
                item.CodingSchemeRegistry = value;
                result = E_Condition.EC_Normal;
            }
            return result;
        }

        /** set the coding scheme UID of the currently selected entry.
         *  See definition of 'ItemStruct' above for VR, VM and Type.
         ** @param  value  string value to be set (use empty string to omit optional attribute)
         ** @return status, EC_Normal if successful, an error code otherwise
         */
        public E_Condition setCodingSchemeUID(string value)
        {
            E_Condition result = E_Condition.EC_IllegalCall;
            /* check whether current item is valid */
            ItemStruct item = getCurrentItem();
            if (item != null)
            {
                /* set the value */
                item.CodingSchemeUID = value;
                result = E_Condition.EC_Normal;
            }
            return result;
        }

        /** set the coding scheme external ID of the currently selected entry.
         *  See definition of 'ItemStruct' above for VR, VM and Type.
         ** @param  value  string value to be set (use empty string to omit optional attribute)
         ** @return status, EC_Normal if successful, an error code otherwise
         */
        public E_Condition setCodingSchemeExternalID(string value)
        {
            E_Condition result = E_Condition.EC_IllegalCall;
            /* check whether current item is valid */
            ItemStruct item = getCurrentItem();
            if (item != null)
            {
                /* set the value */
                item.CodingSchemeExternalID = value;
                result = E_Condition.EC_Normal;
            }
            return result;
        }

        /** set the coding scheme name of the currently selected entry.
         *  See definition of 'ItemStruct' above for VR, VM and Type.
         ** @param  value  string value to be set (use empty string to omit optional attribute)
         ** @return status, EC_Normal if successful, an error code otherwise
         */
        public E_Condition setCodingSchemeName(string value)
        {
            E_Condition result = E_Condition.EC_IllegalCall;
            /* check whether current item is valid */
            ItemStruct item = getCurrentItem();
            if (item != null)
            {
                /* set the value */
                item.CodingSchemeName = value;
                result = E_Condition.EC_Normal;
            }
            return result;
        }

        /** set the coding scheme version of the currently selected entry.
         *  See definition of 'ItemStruct' above for VR, VM and Type.
         ** @param  value  string value to be set (use empty string to omit optional attribute)
         ** @return status, EC_Normal if successful, an error code otherwise
         */
        public E_Condition setCodingSchemeVersion(string value)
        {
            E_Condition result = E_Condition.EC_IllegalCall;
            /* check whether current item is valid */
            ItemStruct item = getCurrentItem();
            if (item != null)
            {
                /* set the value */
                item.CodingSchemeVersion = value;
                result = E_Condition.EC_Normal;
            }
            return result;
        }

        /** set the responsible organization of the currently selected entry.
         *  See definition of 'ItemStruct' above for VR, VM and Type.
         ** @param  value  string value to be set (use empty string to omit optional attribute)
         ** @return status, EC_Normal if successful, an error code otherwise
         */
        public E_Condition setResponsibleOrganization(string value)
        {
            E_Condition result = E_Condition.EC_IllegalCall;
            /* check whether current item is valid */
            ItemStruct item = getCurrentItem();
            if (item != null)
            {
                /* set the value */
                item.ResponsibleOrganization = value;
                result = E_Condition.EC_Normal;
            }
            return result;
        }

        /** add the specified coding scheme to the list (if not existent)
         ** @param  codingSchemeDesignator  coding scheme designator of the item to be added
         *  @param  item       reference to item pointer (result variable)
         ** @return status, EC_Normal if successful, an error code otherwise
         */
        public E_Condition addItem(string codingSchemeDesignator, ref ItemStruct item)
        {
            E_Condition result = E_Condition.EC_IllegalParameter;
            /* check parameter first */
            if (!string.IsNullOrEmpty(codingSchemeDesignator))
            {
                ItemStruct oldCursor = Iterator;
                result = E_Condition.EC_Normal;
                /* check whether item already exists */
                if (gotoItem(codingSchemeDesignator).bad())
                {
                    /* if not create new item and add it to the list */
                    item = new ItemStruct(codingSchemeDesignator);
                    if (item != null)
                    {
                        ItemList.Add(item);
                        Iterator = ItemList.ElementAt(ItemList.Count - 1);
                    }
                    else
                    {
                        /* restore old cursor */
                        Iterator = oldCursor;
                        result = E_Condition.EC_MemoryExhausted;
                    }
                }
                else
                {
                    //DCMSR_WARN("CodingSchemeDesignator \"" << codingSchemeDesignator<< "\" already exists in CodingSchemeIdentificationSequence ... overwriting");
                    /* gotoItem() was successful, set item pointer */
                    item = (ItemStruct)Iterator;
                }
            }
            else
            {
                item = null;
            }

            return result;
        }

        /** get pointer to currently selected item structure (if any)
         ** @return pointer to the item structure if successful, NULL otherwise
         */
        public ItemStruct getCurrentItem()
        {
            if (Iterator != null)
            {
                return Iterator;
            }

            return null;
        }

        private List<ItemStruct> ItemList;

        /// internal cursor to current (selected) list item
        ItemStruct Iterator;
    }

    /** Internal structure defining the list items
    */
    public class ItemStruct
    {
        /** constructor
         ** @param  codingSchemeDesignator  Coding Scheme Designator
         */
        public ItemStruct(string codingSchemeDesignator)
        {
            CodingSchemeDesignator = codingSchemeDesignator;
            CodingSchemeRegistry = string.Empty;
            CodingSchemeUID = string.Empty;
            CodingSchemeExternalID = string.Empty;
            CodingSchemeName = string.Empty;
            CodingSchemeVersion = string.Empty;
            ResponsibleOrganization = string.Empty;
        }

        /** clear additional information
         */
        public void clear()
        {
            CodingSchemeDesignator = string.Empty;
            CodingSchemeRegistry = string.Empty;
            CodingSchemeUID = string.Empty;
            CodingSchemeExternalID = string.Empty;
            CodingSchemeName = string.Empty;
            CodingSchemeVersion = string.Empty;
            ResponsibleOrganization = string.Empty;
        }

        /// Coding Scheme Designator  (VR=SH, VM=1, Type=1)
        public string CodingSchemeDesignator { get; set; }
        /// Coding Scheme Registry    (VR=LO, VM=1, Type=1C)
        public string CodingSchemeRegistry { get; set; }
        /// Coding Scheme UID         (VR=UI, VM=1, Type=1C)
        public string CodingSchemeUID { get; set; }
        /// Coding Scheme External ID (VR=ST, VM=1, Type=2C)
        public string CodingSchemeExternalID { get; set; }
        /// Coding Scheme Name        (VR=ST, VM=1, Type=3)
        public string CodingSchemeName { get; set; }
        /// Coding Scheme Version     (VR=SH, VM=1, Type=3)
        public string CodingSchemeVersion { get; set; }
        /// Responsible Organization  (VR=ST, VM=1, Type=3)
        public string ResponsibleOrganization { get; set; }
    };
}
