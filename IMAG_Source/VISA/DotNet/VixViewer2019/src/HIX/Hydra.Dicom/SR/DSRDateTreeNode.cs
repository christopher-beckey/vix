using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;
using System.Threading.Tasks;
using ClearCanvas.Dicom;

namespace Hydra.Dicom
{
    public class DSRDateTreeNode : DSRDocumentTreeNode
    {
        DSRStringValue dsrStringValue = null;
        /** constructor
     ** @param  relationshipType  type of relationship to the parent tree node.
     *                            Should not be RT_invalid or RT_isRoot.
     */
        public DSRDateTreeNode(E_RelationshipType relationshipType)
            : base(relationshipType, E_ValueType.VT_Date)
        {
            dsrStringValue = new DSRStringValue();
        }

        /** constructor
         ** @param  relationshipType  type of relationship to the parent tree node.
         *                            Should not be RT_invalid or RT_isRoot.
         *  @param  stringValue       initial string value to be set
         */
        public DSRDateTreeNode(E_RelationshipType relationshipType, ref string stringValue)
            : base(relationshipType, E_ValueType.VT_Date)
        {
            dsrStringValue = new DSRStringValue();
        }

        /** destructor
         */
        ~DSRDateTreeNode()
        {
            dsrStringValue = null;
        }

        /** clear all member variables.
         *  Please note that the content item might become invalid afterwards.
         */
        public override void clear()
        {
            base.clear();
            dsrStringValue.clear();
        }

        /** check whether the content item is valid.
     *  The content item is valid if the two base classes and the concept name are valid.
     ** @return OFTrue if tree node is valid, OFFalse otherwise
     */
        public override bool isValid()
        {
            /* ConceptNameCodeSequence required */
            return base.isValid() && dsrStringValue.isValid() && getConceptName().isValid();
        }

        /** print content item.
         *  A typical output looks like this: contains DATE:(,,"Code")="20001010"
         ** @param  stream  output stream to which the content item should be printed
         *  @param  flags   flag used to customize the output (see DSRTypes::PF_xxx)
         ** @return status, EC_Normal if successful, an error code otherwise
         */
        public override E_Condition print(ref StringBuilder stream, int flags)
        {
            E_Condition result = base.print(ref stream, flags);
            if (result.good())
            {
                stream.Append("=");
                dsrStringValue.print(ref stream);
            }
            return result;
        }

        /** write content item in XML format. Uses ISO formatted date value.
         ** @param  stream     output stream to which the XML document is written
         *  @param  flags      flag used to customize the output (see DSRTypes::XF_xxx)
         ** @return status, EC_Normal if successful, an error code otherwise
         */
        public override E_Condition writeXML(ref StringBuilder stream, int flags)
        {
            string tmpString = "";
            E_Condition result = E_Condition.EC_Normal;
            writeXMLItemStart(ref stream, flags);
            result = base.writeXML(ref stream, flags);
            /* output date in ISO 8601 format */
            //TODO: DSRDateTreeNode: writeXML
            //DcmDate::getISOFormattedDateFromString(dsrStringValue.getValue(), tmpString);
            writeStringValueToXML(stream, tmpString, "value", (flags & XF_writeEmptyTags) > 0);
            writeXMLItemEnd(ref stream, flags);
            return result;
        }

        // --- static helper function ---

        /** get DICOM date value from given XML element.
         *  The DICOM Date (DA) value is expected to be stored in ISO format as created by
         *  writeXML().
         ** @param  doc          document containing the XML file content
         *  @param  cursor       cursor pointing to the corresponding node
         *  @param  dateValue    reference to string object in which the value should be stored
         *  @param  clearString  flag specifying whether to clear the 'dateTimeValue' or not
         ** @return reference to string object (might be empty)
         */
        public static string getValueFromXMLNodeContent(ref DSRXMLDocument doc, DSRXMLCursor cursor, ref string dateValue, bool clearString = true)
        {
            if (clearString)
                dateValue = "";
            /* check whether node is valid */
            if (cursor.valid())
            {
                string tmpString = "";
                /* retrieve value from XML element */
                if (doc.getStringFromNodeContent(cursor, ref tmpString) != string.Empty)
                {
                    //TODO: DSRDateTreeNode: getValueFromXMLNodeContent
                    //OFDate tmpDate;
                    /* convert ISO to DICOM format */
                    if (setISOFormattedDate(ref tmpString))
                    {
                        dateValue = tmpString;
                        //DcmDate::getDicomDateFromOFDate(tmpDate, dateValue);
                    }
                }
            }
            return dateValue;
        }

        public E_Condition setValue(string value)
        {
            return dsrStringValue.setValue(value);
        }

        public string getValue()
        {
            return dsrStringValue.getValue();
        }

        public static bool setISOFormattedDate(ref string formattedDate)
        {
            bool status = false;
            int length = formattedDate.Length;
            UInt32 year = 1, month = 1, day = 1;
            /* we expect the following formats: YYYY-MM-DD with arbitrary delimiters ... */
            if (length == 10)
            {
                /* extract components from date string */

                string[] formatDate = formattedDate.Split('-');
                formattedDate = formatDate[0] + formatDate[1] + formatDate[2];

                status = setDate(year, month, day);
            }
            ///* ... or YYYYMMDD (without delimiters) */
            else if (length == 8)
            {
                //    /* extract components from date string */
                //    if (sscanf(formattedDate, "%04u%02u%02u", &year, &month, &day) == 3)
                //        status = setDate(year, month, day);
            }
            return status;
        }

        private static bool setDate(UInt32 year, UInt32 month, UInt32 day)
        {
            bool status = false;
            /* only change if the new date is valid */
            if (isDateValid(year, month, day))
            {
                //Year = year;
                //Month = month;
                //Day = day;
                /* report that a new date has been set */
                status = true;
            }
            return status;
        }

        private static bool isDateValid(UInt32 year, UInt32 month, UInt32 day)
        {
            /* this very simple validity check might be enhanced in the future */
            return (month >= 1) && (month <= 12) && (day >= 1) && (day <= 31);
        }

        /** read content item (value) from dataset
     ** @param  dataset    DICOM dataset from which the content item should be read
     ** @return status, EC_Normal if successful, an error code otherwise
     */
        protected override E_Condition readContentItem(ref DicomAttributeCollection dataset)
        {
            /* read Date */
            return dsrStringValue.read(dataset, getDicomAttribute(DicomTags.Date));
        }

        /** write content item (value) to dataset
         ** @param  dataset    DICOM dataset to which the content item should be written
         ** @return status, EC_Normal if successful, an error code otherwise
         */
        protected override E_Condition writeContentItem(DicomAttributeCollection dataset)
        {
            /* write Date */
            return dsrStringValue.write(ref dataset, getDicomAttribute(DicomTags.Date));
        }

        /** read content item specific XML data
         ** @param  doc     document containing the XML file content
         *  @param  cursor  cursor pointing to the starting node
         ** @return status, EC_Normal if successful, an error code otherwise
         */
        protected override E_Condition readXMLContentItem(ref DSRXMLDocument doc, DSRXMLCursor cursor)
        {
            string tmpString = "";
            /* retrieve value from XML element "value" */
            DSRXMLCursor mainChildCursor = cursor.gotoChild();
            DSRXMLCursor ChildCursor = doc.getNamedNode(mainChildCursor, "value");
            string xmlContent = getValueFromXMLNodeContent(ref doc, ChildCursor, ref tmpString);
            E_Condition result = dsrStringValue.setValue(xmlContent);
            if (result == E_Condition.EC_IllegalParameter)
                result = E_Condition.SR_EC_InvalidValue;
            return result;
        }

        /** render content item (value) in HTML/XHTML format
         ** @param  docStream     output stream to which the main HTML/XHTML document is written
         *  @param  annexStream   output stream to which the HTML/XHTML document annex is written
         *  @param  nestingLevel  current nesting level.  Used to render section headings.
         *  @param  annexNumber   reference to the variable where the current annex number is stored.
         *                        Value is increased automatically by 1 after a new entry has been added.
         *  @param  flags         flag used to customize the output (see DSRTypes::HF_xxx)
         ** @return status, EC_Normal if successful, an error code otherwise
         */
        protected override E_Condition renderHTMLContentItem(ref StringBuilder docStream, ref StringBuilder annexStream, int nestingLevel, ref int annexNumber, int flags)
        {
            /* render ConceptName */
            E_Condition result = renderHTMLConceptName(ref docStream, flags);
            /* render Date */
            if (result.good())
            {
                string htmlString = "";
                if (!Convert.ToBoolean(flags & DSRTypes.HF_renderItemsSeparately))
                {
                    if (Convert.ToBoolean(flags & DSRTypes.HF_XHTML11Compatibility))
                        docStream.Append("<span class=\"date\">");
                    else if (Convert.ToBoolean(flags & DSRTypes.HF_HTML32Compatibility))
                        docStream.Append("<u>");
                    else /* HTML 4.01 */
                        docStream.Append("<span class=\"under\">");
                }
                docStream.Append(dicomToReadableDate(dsrStringValue.getValue(), htmlString));
                if (!Convert.ToBoolean(flags & DSRTypes.HF_renderItemsSeparately))
                {
                    if (Convert.ToBoolean(flags & DSRTypes.HF_HTML32Compatibility))
                        docStream.Append("</u>");
                    else
                        docStream.Append("</span>");
                }
                docStream.AppendLine();
            }
            return result;
        }

    }
}
