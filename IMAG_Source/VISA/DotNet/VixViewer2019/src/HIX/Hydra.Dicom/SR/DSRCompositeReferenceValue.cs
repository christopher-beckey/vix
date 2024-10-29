using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;
using System.Threading.Tasks;
using ClearCanvas.Dicom;

namespace Hydra.Dicom
{
    public class DSRCompositeReferenceValue
    {
        // allow access to getValuePtr()
        internal class DSRContentItem { }

        /// reference SOP class UID (VR=UI, type 1)
        protected string SOPClassUID;

        /// reference SOP instance UID (VR=UI, type 1)
        protected string SOPInstanceUID;


        /** default contructor
     */
        public DSRCompositeReferenceValue()
        {
            SOPClassUID = string.Empty;
            SOPInstanceUID = string.Empty;
        }


        /** constructor.
         *  The UID pair is only set if it passed the validity check (see setValue()).
         ** @param  sopClassUID     referenced SOP class UID of the composite object.
         *                          (VR=UI, type 1)
         *  @param  sopInstanceUID  referenced SOP instance UID of the composite object.
         *                          (VR=UI, type 1)
         */
        public DSRCompositeReferenceValue(ref string sopClassUID, ref string sopInstanceUID)
        {
            SOPClassUID = string.Empty;
            SOPInstanceUID = string.Empty;

            /* use the set methods for checking purposes */
            setReference(ref sopClassUID, ref sopInstanceUID);
        }


        /** copy constructor
         ** @param  referenceValue  reference value to be copied (not checked !)
         */
        public DSRCompositeReferenceValue(ref DSRCompositeReferenceValue referenceValue)
        {
            SOPClassUID = referenceValue.SOPClassUID;
            SOPInstanceUID = referenceValue.SOPInstanceUID;
        }


        /** destructor
         */
        ~DSRCompositeReferenceValue()
        {

        }


        /** assignment operator
         ** @param  referenceValue  reference value to be copied (not checked !)
         ** @return reference to this reference value after 'referenceValue' has been copied
         */
        //DSRCompositeReferenceValue &operator=(const DSRCompositeReferenceValue &referenceValue);

        /** clear all internal variables.
         *  Since an empty reference value is invalid the reference becomes invalid afterwards.
         */
        public virtual void clear()
        {
            SOPClassUID = string.Empty;
            SOPInstanceUID = string.Empty;
        }


        /** check whether the current reference value is valid.
         *  The reference value is valid if SOP class UID and SOP instance UID are valid (see
         *  checkSOP...UID() for details).
         ** @return OFTrue if reference value is valid, OFFalse otherwise
         */
        public virtual bool isValid()
        {
            return checkSOPClassUID(ref SOPClassUID) && checkSOPInstanceUID(ref SOPInstanceUID);
        }


        /** check whether the current reference value is empty.
         *  Checks whether both UIDs of the reference value are empty.
         ** @return OFTrue if value is empty, OFFalse otherwise
         */
        public virtual bool isEmpty()
        {
            return ((string.IsNullOrEmpty(SOPClassUID)) && (string.IsNullOrEmpty(SOPInstanceUID)));
        }


        /** print reference value.
         *  The output of a typical composite reference value looks like this: (BasicTextSR,"1.2.3").
         *  If the SOP class UID is unknown the UID is printed instead of the related name.
         ** @param  stream  output stream to which the reference value should be printed
         *  @param  flags   flag used to customize the output (see DSRTypes::PF_xxx)
         ** @return status, EC_Normal if successful, an error code otherwise
         */
        public virtual E_Condition print(ref StringBuilder stream, int flags)
        {
            string className = DSRTypes.S_UIDNameMap.dcmFindNameOfUID(SOPClassUID);
            stream.Append("(");
            if (className != null)
            {
                stream.Append(className);
            }
            else
            {
                stream.Append(string.Format("{0}{1}{2}", "\\", SOPClassUID, "\\"));
            }
            stream.Append(",");
            if ((flags & DSRTypes.PF_printSOPInstanceUID) != 0)
            {
                stream.Append(string.Format("{0}{1}{2}", "\\", SOPInstanceUID, "\\"));
            }
            stream.Append(")");
            return E_Condition.EC_Normal;
        }


        /** read reference value from XML document
         ** @param  doc     document containing the XML file content
         *  @param  cursor  cursor pointing to the starting node
         ** @return status, EC_Normal if successful, an error code otherwise
         */
        public virtual E_Condition readXML(ref DSRXMLDocument doc, DSRXMLCursor cursor)
        {
            E_Condition result = E_Condition.SR_EC_CorruptedXMLStructure;
            /* go one node level down */
            if (cursor.gotoChild().valid())
            {
                /* retrieve SOP Class UID and SOP Instance UID from XML tag (required) */
                doc.getStringFromAttribute(doc.getNamedNode(cursor, "sopclass"), ref SOPClassUID, "uid");
                doc.getStringFromAttribute(doc.getNamedNode(cursor, "instance"), ref SOPInstanceUID, "uid");
                /* check whether value is valid */
                result = (isValid() ? E_Condition.EC_Normal : E_Condition.SR_EC_InvalidValue);
            }
            return result;
        }


        /** write reference value in XML format
         ** @param  stream     output stream to which the XML document is written
         *  @param  flags      flag used to customize the output (see DSRTypes::XF_xxx)
         ** @return status, EC_Normal if successful, an error code otherwise
         */
        public virtual E_Condition writeXML(ref StringBuilder stream, int flags)
        {
            if (((flags & DSRTypes.XF_writeEmptyTags) != 0) || (!isEmpty()))
            {
                /* retrieve name of SOP class */
                string sopClass = DSRTypes.S_UIDNameMap.dcmFindNameOfUID(SOPClassUID);
                if (sopClass != null)
                {
                    stream.Append(sopClass);
                    stream.Append("</sopclass>").AppendLine();
                    stream.Append(string.Format("{0}{1}{2}", "<instance uid=\\", SOPInstanceUID, "\\")).AppendLine();
                }
            }
            return E_Condition.EC_Normal;
        }


        /** read referenced SOP sequence from dataset.
         *  The number of items within the sequence is checked.  If error/warning output are
         *  enabled a warning message is printed if the sequence is absent or contains more than
         *  one item.
         ** @param  dataset    DICOM dataset from which the sequence should be read
         *  @param  type       value type of the sequence (valid value: "1", "2", something else)
         *                     This parameter is used for checking purpose, any difference is reported.
         ** @return status, EC_Normal if successful, an error code otherwise
         */
        public virtual E_Condition readSequence(ref DicomAttributeCollection dataset, string type)
        {
            /* read ReferencedSOPSequence */
            DicomAttribute dseq = DSRTypes.getDicomAttribute(DicomTags.ReferencedSopSequence);
            E_Condition result = DSRTypes.getElementFromDataset(dataset, ref dseq);
            DSRTypes.checkElementValue(dseq, "1", type, result, "content item");
            if (result.good())
            {
                /* read first item */
                DicomAttributeCollection ditem = dseq.GetSequenceItem(0);
                if (ditem != null)
                {
                    /* read Code */
                    result = readItem(ref ditem);
                }
                else
                {
                    result = E_Condition.SR_EC_InvalidDocumentTree;
                }
            }
            return result;
        }


        /** write referenced SOP sequence to dataset.
     *  If the value is empty an empty sequence (without any items) is written.
     ** @param  dataset    DICOM dataset to which the sequence should be written
     ** @return status, EC_Normal if successful, an error code otherwise
     */
        public virtual E_Condition writeSequence(ref DicomAttributeCollection dataset)
        {
            E_Condition result = E_Condition.EC_MemoryExhausted;
            DicomAttribute dseq = DSRTypes.getDicomAttribute(DicomTags.ReferencedSopSequence);
            if (dseq != null)
            {
                DicomSequenceItem ditem = new DicomSequenceItem();
                if (ditem != null)
                {
                    /* write item */
                    result = writeItem(ditem);
                    if (result.good())
                    {
                        dseq.AddSequenceItem(ditem);
                    }
                }
                else
                {
                    result = E_Condition.EC_MemoryExhausted;
                }
                /* write sequence */
                if (result.good())
                {
                    dataset[dseq.Tag.TagValue] = dseq;
                }
            }                      
            return result;
        }


        /** render composite reference value in HTML/XHTML format
         ** @param  docStream    output stream to which the main HTML/XHTML document is written
         *  @param  annexStream  output stream to which the HTML/XHTML document annex is written
         *  @param  annexNumber  reference to the variable where the current annex number is stored.
         *                       Value is increased automatically by 1 after a new entry has been added.
         *  @param  flags        flag used to customize the output (see DSRTypes::HF_xxx)
         ** @return status, EC_Normal if successful, an error code otherwise
         */
        public virtual E_Condition renderHTML(ref StringBuilder docStream, ref StringBuilder annexStream, ref int annexNumber, int flags)
        {
            /* render reference */
            docStream.Append("<a href=\"");
            docStream.Append("http://localhost/dicom.cgi");
            docStream.Append("?composite=");
            docStream.Append(SOPClassUID);
            docStream.Append("+");
            docStream.Append(SOPInstanceUID);
            docStream.Append("\">");
            string className = DSRTypes.S_UIDNameMap.dcmFindNameOfUID(SOPClassUID);
            if (className != null)
                docStream.Append(className);
            else
                docStream.Append("unknown composite object");
            docStream.Append("</a>");
            return E_Condition.EC_Normal;
        }


        /** get SOP class UID
         ** @return current SOP class UID (might be invalid or an empty string)
         */
        public string getSOPClassUID()
        {
            return SOPClassUID;
        }


        /** get SOP instance UID
         ** @return current SOP instance UID (might be invalid or an empty string)
         */
        public string getSOPInstanceUID()
        {
            return SOPInstanceUID;
        }


        /** get reference to composite reference value
         ** @return reference to composite reference value
         */
        public DSRCompositeReferenceValue getValue()
        {
            return this;
        }


        /** get copy of composite reference value
         ** @param  referenceValue  reference to variable in which the value should be stored
         ** @return status, EC_Normal if successful, an error code otherwise
         */
        public E_Condition getValue(ref DSRCompositeReferenceValue referenceValue)
        {
            referenceValue = this;
            return E_Condition.EC_Normal;
        }


        /** set composite reference value.
         *  Before setting the reference it is checked (see checkXXX()).  If the value is
         *  invalid the current value is not replaced and remains unchanged.
         ** @param  referenceValue  value to be set
         ** @return status, EC_Normal if successful, an error code otherwise
         */
        public E_Condition setValue(DSRCompositeReferenceValue referenceValue)
        {
            return setReference(ref referenceValue.SOPClassUID, ref referenceValue.SOPInstanceUID);
        }


        /** set SOP class UID and SOP instance UID value.
         *  Before setting the values they are checked (see checkXXX()).  If the value pair is
         *  invalid the current value pair is not replaced and remains unchanged.
         ** @param  sopClassUID     referenced SOP class UID to be set
         *  @param  sopInstanceUID  referenced SOP instance UID to be set
         ** @return status, EC_Normal if successful, an error code otherwise
         */
        public E_Condition setReference(ref string sopClassUID, ref string sopInstanceUID)
        {
            E_Condition result = E_Condition.EC_IllegalParameter;
            /* check both values before setting them */
            if (checkSOPClassUID(ref sopClassUID) && checkSOPInstanceUID(ref sopInstanceUID))
            {
                SOPClassUID = sopClassUID;
                SOPInstanceUID = sopInstanceUID;
                result = E_Condition.EC_Normal;
            }
            return result;
        }


        /** set SOP class UID value.
         *  Before setting the value is is checked (see checkSOPClassUID()).  If the value is
         *  invalid the current value is not replaced and remains unchanged.
         ** @param  sopClassUID  SOP class UID to be set
         ** @return status, EC_Normal if successful, an error code otherwise
         */
        public E_Condition setSOPClassUID(ref string sopClassUID)
        {
            E_Condition result = E_Condition.EC_IllegalParameter;
            if (checkSOPClassUID(ref sopClassUID))
            {
                SOPClassUID = sopClassUID;
                result = E_Condition.EC_Normal;
            }
            return result;
        }


        /** set SOP instance UID value.
         *  Before setting the value is is checked (see checkSOPInstanceUID()).  If the value is
         *  invalid the current value is not replaced and remains unchanged.
         ** @param  sopInstanceUID  SOP instance UID to be set
         ** @return status, EC_Normal if successful, an error code otherwise
         */
        public E_Condition setSOPInstanceUID(ref string sopInstanceUID)
        {
            E_Condition result = E_Condition.EC_IllegalParameter;
            if (checkSOPInstanceUID(ref sopInstanceUID))
            {
                SOPInstanceUID = sopInstanceUID;
                result = E_Condition.EC_Normal;
            }
            return result;
        }


        /** get pointer to reference value
         ** @return pointer to reference value (never NULL)
         */
        protected DSRCompositeReferenceValue getValuePtr()
        {
            return this;
        }


        /** read reference value from dataset
         ** @param  dataset    DICOM dataset from which the value should be read
         ** @return status, EC_Normal if successful, an error code otherwise
         */
        protected virtual E_Condition readItem(ref DicomAttributeCollection dataset)
        {
            /* read ReferencedSOPClassUID */
            E_Condition result = DSRTypes.getAndCheckStringValueFromDataset(dataset, DSRTypes.getDicomAttribute(DicomTags.ReferencedSopClassUid), ref SOPClassUID, "1", "1", "ReferencedSOPSequence");
            /* read ReferencedSOPInstanceUID */
            if (result.good())
            {
                result = DSRTypes.getAndCheckStringValueFromDataset(dataset, DSRTypes.getDicomAttribute(DicomTags.ReferencedSopInstanceUid), ref SOPInstanceUID, "1", "1", "ReferencedSOPSequence");
            }
            return result;
        }


        /** write reference value to dataset
         ** @param  dataset    DICOM dataset to which the value should be written
         ** @return status, EC_Normal if successful, an error code otherwise
         */
        protected virtual E_Condition writeItem(DicomAttributeCollection dataset)
        {
            /* write ReferencedSOPClassUID */
            E_Condition result = DSRTypes.putStringValueToDataset(dataset, DSRTypes.getDicomAttribute(DicomTags.ReferencedSopClassUid), SOPClassUID);
            /* write ReferencedSOPInstanceUID */
            if (result.good())
            {
                result = DSRTypes.putStringValueToDataset(dataset, DSRTypes.getDicomAttribute(DicomTags.ReferencedSopInstanceUid), SOPInstanceUID);
            }
            return result;
        }


        /** check the specified SOP class UID for validity.
         *  The only check that is currently performed is that the UID is not empty.  Derived
         *  classes might overwrite this method for more specific tests (e.g. allowing only
         *  particular SOP classes).
         ** @param  sopClassUID   SOP class UID to be checked
         ** @return OFTrue if SOP class UID is valid, OFFalse otherwise
         */
        protected virtual bool checkSOPClassUID(ref string sopClassUID)
        {
            return DSRTypes.checkForValidUIDFormat(sopClassUID);
        }


        /** check the specified SOP instance UID for validity.
         *  The only check that is currently performed is that the UID is not empty.  Derived
         *  classes might overwrite this method for more specific tests.
         *  @param  sopInstanceUID  SOP instance UID to be checked
         ** @return OFTrue if SOP instance UID is valid, OFFalse otherwise
         */
        protected virtual bool checkSOPInstanceUID(ref string sopInstanceUID)
        {
            return DSRTypes.checkForValidUIDFormat(sopInstanceUID);
        }
    }
}
