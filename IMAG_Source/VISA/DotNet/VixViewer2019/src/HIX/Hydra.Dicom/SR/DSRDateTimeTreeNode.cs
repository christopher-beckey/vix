using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;
using System.Threading.Tasks;
using ClearCanvas.Dicom;

namespace Hydra.Dicom
{
    public class DSRDateTimeTreeNode  : DSRDocumentTreeNode
    {
        DSRStringValue dsrStringValue = null;
        /** constructor
     ** @param  relationshipType  type of relationship to the parent tree node.
     *                            Should not be RT_invalid or RT_isRoot.
     */
        public DSRDateTimeTreeNode(E_RelationshipType relationshipType)
            : base(relationshipType, E_ValueType.VT_DateTime)
        {
            dsrStringValue = new DSRStringValue();
        }
        /** constructor
         ** @param  relationshipType  type of relationship to the parent tree node.
         *                            Should not be RT_invalid or RT_isRoot.
         *  @param  stringValue       initial string value to be set
         */
        public DSRDateTimeTreeNode(E_RelationshipType relationshipType, ref string stringValue)
            : base(relationshipType, E_ValueType.VT_DateTime)
        {
            dsrStringValue = new DSRStringValue();
        }

        /** destructor
         */
        ~DSRDateTimeTreeNode()
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
         *  A typical output looks like this: contains DATETIME:(,,"Code")="2000101012000000"
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
        /** write content item in XML format. Uses ISO formatted date/time value.
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
            /* output time in ISO 8601 format */
            string dsrDateTime = dsrStringValue.getValue();
            DSRUtils.getISOFormattedDateTimeFromString(ref dsrDateTime, ref tmpString, true /*seconds*/, false /*fraction*/,
                false /*timeZone*/, false /*createMissingPart*/, "T" /*dateTimeSeparator*/);
            writeStringValueToXML(stream, tmpString, "value", (flags & XF_writeEmptyTags) > 0);
            writeXMLItemEnd(ref stream, flags);
            return result;
        }

        // --- static helper function ---

        /** get DICOM datetime value from given XML element.
         *  The DICOM DateTime (DT) value is expected to be stored in ISO format as created by
         *  writeXML().
         ** @param  doc            document containing the XML file content
         *  @param  cursor         cursor pointing to the corresponding node
         *  @param  dateTimeValue  reference to string object in which the value should be stored
         *  @param  clearString    flag specifying whether to clear the 'dateTimeValue' or not
         ** @return reference to string object (might be empty)
         */
        public static string getValueFromXMLNodeContent(ref DSRXMLDocument doc, DSRXMLCursor cursor, ref string dateTimeValue, bool clearString = true)
        {
            if (clearString)
                dateTimeValue = "";
            /* check whether node is valid */
            if (cursor.valid())
            {
                string tmpString = "";
                /* retrieve value from XML element */
                if (doc.getStringFromNodeContent(cursor, ref tmpString) != string.Empty)
                {
                    dateTimeValue = tmpString;
                    //TODO: DSRDateTimeTreeNode: getValueFromXMLNodeContent
                    //OFDateTime tmpDateTime;
                    /* convert ISO to DICOM format */
                    //if (tmpDateTime.setISOFormattedDateTime(tmpString))
                      //  DcmDateTime::getDicomDateTimeFromOFDateTime(tmpDateTime, dateTimeValue);
                }
            }
            return dateTimeValue;
        }

        public E_Condition setValue(string value)
        {
            return dsrStringValue.setValue(value);
        }

        public string getValue()
        {
            return dsrStringValue.getValue();
        }

        /** read content item (value) from dataset
     ** @param  dataset    DICOM dataset from which the content item should be read
     ** @return status, EC_Normal if successful, an error code otherwise
     */
        protected override E_Condition readContentItem(ref DicomAttributeCollection dataset)
        {
            /* read DateTime */
            return dsrStringValue.read(dataset, getDicomAttribute(DicomTags.Datetime));
        }

        /** write content item (value) to dataset
         ** @param  dataset    DICOM dataset to which the content item should be written
         ** @return status, EC_Normal if successful, an error code otherwise
         */
        protected override E_Condition writeContentItem(DicomAttributeCollection dataset)
        {
            /* write DateTime */
            return dsrStringValue.write(ref dataset, getDicomAttribute(DicomTags.Datetime));
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
            string value = getValueFromXMLNodeContent(ref doc, ChildCursor, ref tmpString);
            E_Condition result = dsrStringValue.setValue(value);
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
            /* render DateTime */
            if (result.good())
            {
                string htmlString = "";
                if (!Convert.ToBoolean(flags & DSRTypes.HF_renderItemsSeparately))
                {
                    if (Convert.ToBoolean(flags & DSRTypes.HF_XHTML11Compatibility))
                        docStream.Append("<span class=\"datetime\">");
                    else if (Convert.ToBoolean(flags & DSRTypes.HF_HTML32Compatibility))
                        docStream.Append("<u>");
                    else /* HTML 4.01 */
                        docStream.Append("<span class=\"under\">");
                }
                docStream.Append(dicomToReadableDateTime(dsrStringValue.getValue(), htmlString));
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
