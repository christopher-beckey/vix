using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;
using System.Threading.Tasks;
using ClearCanvas.Dicom;

namespace Hydra.Dicom
{
    public class DSRTimeTreeNode : DSRDocumentTreeNode
    {
        DSRStringValue dsrStringValue = null;
        /// <summary>
        /// Constructor with single parameter
        /// </summary>
        /// <param name="relationshipType">type of relationship to the parent tree node.Should not be RT_invalid or RT_isRoot.</param>
        public DSRTimeTreeNode(E_RelationshipType relationshipType)
            : base(relationshipType, E_ValueType.VT_Time)
        {
           dsrStringValue = new DSRStringValue();
        }

        /// <summary>
        /// Constructor with multiple parameter
        /// </summary>
        /// <param name="relationshipType">type of relationship to the parent tree node.Should not be RT_invalid or RT_isRoot.</param>
        /// <param name="stringValue">initial string value to be set</param>
        public DSRTimeTreeNode(E_RelationshipType relationshipType, string stringValue)
            : base(relationshipType, E_ValueType.VT_Time)
        {
            dsrStringValue = new DSRStringValue();
        }

        /// <summary>
        /// clear all member variables.
        /// Please note that the content item might become invalid afterwards.
        /// </summary>
        public override void clear()
        {
            base.clear();
            dsrStringValue.clear();
        }

        /// <summary>
        /// check whether the content item is valid.
        /// The content item is valid if the two base classes and the concept name are valid.
        /// </summary>
        /// <returns>true if tree node is valid, false otherwise</returns>
        public override bool isValid()
        {
            /* ConceptNameCodeSequence required */
            return base.isValid() && dsrStringValue.isValid() && getConceptName().isValid();
        }

        /// <summary>
        /// print content item.
        /// A typical output looks like this: contains TIME:(,,"Code")="12000000"
        /// </summary>
        /// <param name="stream">output stream to which the content item should be printed</param>
        /// <param name="flags">flag used to customize the output (see DSRTypes::PF_xxx)</param>
        /// <returns>true if successful, false otherwise</returns>
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

        /// <summary>
        /// write content item in XML format. Uses ISO formatted time value.
        /// </summary>
        /// <param name="stream">output stream to which the XML document is written</param>
        /// <param name="flags">flag used to customize the output (see DSRTypes::XF_xxx)</param>
        /// <returns>true if successful, false otherwise</returns>
        public override E_Condition writeXML(ref StringBuilder stream, int flags)
        {
            string tmpString = "";
            writeXMLItemStart(ref stream, flags);
            E_Condition result = base.writeXML(ref stream, flags);
            /* output time in ISO 8601 format */
            //TODO: DSRTimeTreeNode: writeXML
            //DcmTime::getISOFormattedTimeFromString(dsrStringValue.getValue(), tmpString);
            writeStringValueToXML(stream, tmpString, "value", (flags & XF_writeEmptyTags) > 0);
            writeXMLItemEnd(ref stream, flags);
            return result;
        }

        /// <summary>
        /// get DICOM time value from given XML element.
        /// The DICOM Time (TM) value is expected to be stored in ISO format as created by writeXML().
        /// </summary>
        /// <param name="doc">document containing the XML file content</param>
        /// <param name="cursor">cursor pointing to the corresponding node</param>
        /// <param name="timeValue">reference to string object in which the value should be stored</param>
        /// <param name="clearString">flag specifying whether to clear the 'dateTimeValue' or not</param>
        /// <returns>reference to string object (might be empty)</returns>
        public static string getValueFromXMLNodeContent(ref DSRXMLDocument doc, DSRXMLCursor cursor, ref string timeValue, bool clearString = true)
        {
            if (clearString)
                timeValue = "";
            /* check whether node is valid */
            if (cursor.valid())
            {
                string tmpString = "";
                /* retrieve value from XML element */
                if (doc.getStringFromNodeContent(cursor, ref tmpString) != string.Empty)
                {
                    //TODO: DSRTimeTreeNode: getValueFromXMLNodeContent
                    string tmpTime = string.Empty;
                    /* convert ISO to DICOM format */
                    if (setISOFormattedTime(ref tmpTime))
                    {
                        //DcmTime::getDicomTimeFromOFTime(tmpTime, timeValue);
                        timeValue = tmpString;
                    }
                }
            }
            return timeValue;
        }

        public E_Condition setValue(string value)
        {
            return dsrStringValue.setValue(value);
        }

        public string getValue()
        {
            return dsrStringValue.getValue();
        }

        /// <summary>
        /// Set the ISO time format
        /// </summary>
        /// <param name="formattedTime"></param>
        /// <returns></returns>
        private static bool setISOFormattedTime(ref string formattedTime)
        {
            bool status = true;
            int length = formattedTime.Length;
            UInt32 hours, minutes, seconds;
            /* check for supported formats: HHMM */
            if (length == 4)
            {
                ///* extract components from time string */
                //if (sscanf(formattedTime.c_str(), "%02u%02u", &hours, &minutes) == 2)
                //    status = setTime(hours, minutes, 0 /*seconds*/);
            }
            /* HH:MM */
            else if (length == 5)
            {
                ///* extract components from time string */
                //if (sscanf(formattedTime.c_str(), "%02u%*c%02u", &hours, &minutes) == 2)
                //    status = setTime(hours, minutes, 0 /*seconds*/);
            }
            /* HHMMSS */
            else if (length == 6)
            {
                ///* extract components from time string */
                //if (sscanf(formattedTime.c_str(), "%02u%02u%02u", &hours, &minutes, &seconds) == 3)
                //    status = setTime(hours, minutes, seconds);
            }
            /* HH:MM:SS */
            else if (length == 8)
            {
                ///* extract components from time string */
                //if (sscanf(formattedTime.c_str(), "%02u%*c%02u%*c%02u", &hours, &minutes, &seconds) == 3)
                //    status = setTime(hours, minutes, seconds);
            }
            return status;
        }

        /// <summary>
        /// read content item (value) from dataset
        /// </summary>
        /// <param name="dataset">DICOM dataset from which the content item should be read</param>
        /// <returns>true if successful, false otherwise</returns>
        protected override E_Condition readContentItem(ref DicomAttributeCollection dataset)
        {
            /* read Time */
            return dsrStringValue.read(dataset, getDicomAttribute(DicomTags.Time));
        }

        /// <summary>
        /// write content item (value) to dataset
        /// </summary>
        /// <param name="dataset">DICOM dataset to which the content item should be written</param>
        /// <returns>true if successful, false otherwise</returns>
        protected override E_Condition writeContentItem(DicomAttributeCollection dataset)
        {
            /* write Time */
            return dsrStringValue.write(ref dataset, getDicomAttribute(DicomTags.Time));
        }

        /// <summary>
        /// read content item specific XML data
        /// </summary>
        /// <param name="doc">document containing the XML file content</param>
        /// <param name="cursor">cursor pointing to the starting node</param>
        /// <returns>true if successful, false otherwise</returns>
        protected override E_Condition readXMLContentItem(ref DSRXMLDocument doc, DSRXMLCursor cursor)
        {
            string tmpString = "";
            /* retrieve value from XML element "value" */
            DSRXMLCursor mainChildCursor = cursor.gotoChild();
            E_Condition result = dsrStringValue.setValue(getValueFromXMLNodeContent(ref doc, doc.getNamedNode(mainChildCursor, "value"), ref tmpString));
            if (result == E_Condition.EC_IllegalParameter)
                result = E_Condition.SR_EC_InvalidValue;
            return result;
        }

        /// <summary>
        /// render content item (value) in HTML/XHTML format
        /// </summary>
        /// <param name="docStream">output stream to which the main HTML/XHTML document is written</param>
        /// <param name="annexStream">output stream to which the HTML/XHTML document annex is written</param>
        /// <param name="nestingLevel">current nesting level.  Used to render section headings.</param>
        /// <param name="annexNumber">reference to the variable where the current annex number is stored. Value is increased automatically by 1 after a new entry has been added. (see DSRTypes::HF_xxx)</param>
        /// <param name="flags">flag used to customize the output</param>
        /// <returns>true if successful, false otherwise</returns>
        protected override E_Condition renderHTMLContentItem(ref StringBuilder docStream, ref StringBuilder annexStream, int nestingLevel, ref int annexNumber, int flags)
        {
            /* render ConceptName */
            E_Condition result = renderHTMLConceptName(ref docStream, flags);
            /* render Time */
            if (result.good())
            {
                string htmlString = "";
                if (!Convert.ToBoolean(flags & DSRTypes.HF_renderItemsSeparately))
                {
                    if (Convert.ToBoolean(flags & DSRTypes.HF_XHTML11Compatibility))
                        docStream.Append("<span class=\"time\">");
                    else if (Convert.ToBoolean(flags & DSRTypes.HF_HTML32Compatibility))
                        docStream.Append("<u>");
                    else /* HTML 4.01 */
                        docStream.Append("<span class=\"under\">");
                }
                docStream.Append(dicomToReadableTime(dsrStringValue.getValue(), htmlString));
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
