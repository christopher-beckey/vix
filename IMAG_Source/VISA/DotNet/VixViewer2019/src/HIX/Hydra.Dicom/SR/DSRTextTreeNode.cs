using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;
using System.Threading.Tasks;
using ClearCanvas.Dicom;

namespace Hydra.Dicom
{
    public class DSRTextTreeNode : DSRDocumentTreeNode
    {
        DSRStringValue dsrStringValue = null;

        /// <summary>
        /// Constructor with single parameter
        /// </summary>
        /// <param name="relationshipType">type of relationship to the parent tree node.Should not be RT_invalid or RT_isRoot.</param>
        public DSRTextTreeNode(E_RelationshipType relationshipType)
            : base(relationshipType, E_ValueType.VT_Text)
        {
            dsrStringValue = new DSRStringValue();
        }

        /// <summary>
        /// Constructor with multiple parameter
        /// </summary>
        /// <param name="relationshipType">type of relationship to the parent tree node.Should not be RT_invalid or RT_isRoot.</param>
        /// <param name="stringValue">initial string value to be set</param>
        public DSRTextTreeNode(E_RelationshipType relationshipType, string stringValue)
            : base(relationshipType, E_ValueType.VT_Text)
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
        /// check whether the content is short.
        /// A text is short if the length is <= 40 characters.
        /// </summary>
        /// <param name="flags">flag used to customize the output (see DSRTypes::HF_xxx)</param>
        /// <returns>true if the content is short, false otherwise</returns>
        public override bool isShort(int flags)
        {
            return (dsrStringValue.getValue().Length <= 40);
        }

        /// <summary>
        /// print content item.
        /// A typical output looks like this: contains TEXT:(,,"Text Code")="This is a Text."
        /// If the 'flag' PF_shortenLongItemValues is set the text is limited to 40 characters (incl. trailing "...").
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
                if (Convert.ToBoolean(flags & PF_shortenLongItemValues))
                {
                    dsrStringValue.print(ref stream, 30);     // text output is limited to 30 characters
                }
                else
                {
                    dsrStringValue.print(ref stream);
                }
            }

            return result;
        }

        /// <summary>
        /// write content item in XML format
        /// </summary>
        /// <param name="stream">output stream to which the XML document is written</param>
        /// <param name="flags">flag used to customize the output (see DSRTypes::XF_xxx)</param>
        /// <returns>true if successful, false otherwise</returns>
        public override E_Condition writeXML(ref StringBuilder stream, int flags)
        {
            E_Condition result = E_Condition.EC_Normal;
            writeXMLItemStart(ref stream, flags);
            result = base.writeXML(ref stream, flags);
            writeStringValueToXML(stream, dsrStringValue.getValue(), "value", (flags & XF_writeEmptyTags) > 0);
            writeXMLItemEnd(ref stream, flags);
            return result;
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
        /// read content item (value) from dataset
        /// </summary>
        /// <param name="dataset">DICOM dataset from which the content item should be read</param>
        /// <returns>true if successful, false otherwise</returns>
        protected override E_Condition readContentItem(ref DicomAttributeCollection dataset)
        {
            /* read TextValue */
            return dsrStringValue.read(dataset, getDicomAttribute(DicomTags.TextValue));
        }

        /// <summary>
        /// write content item (value) to dataset
        /// </summary>
        /// <param name="dataset">DICOM dataset to which the content item should be written</param>
        /// <returns>true if successful, false otherwise</returns>
        protected override E_Condition writeContentItem(DicomAttributeCollection dataset)
        {
            /* write TextValue */
            return dsrStringValue.write(ref dataset, getDicomAttribute(DicomTags.TextValue));
        }

        /// <summary>
        /// read content item specific XML data
        /// </summary>
        /// <param name="doc">document containing the XML file content</param>
        /// <param name="cursor">cursor pointing to the starting node</param>
        /// <returns>true if successful, false otherwise</returns>
        protected override E_Condition readXMLContentItem(ref DSRXMLDocument doc, DSRXMLCursor cursor)
        {
            /* retrieve value from XML element "value" */
            return dsrStringValue.readXML(ref doc, doc.getNamedNode(cursor.getChild(), "value"), true /*encoding*/);
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
            string htmlString = "";
            /* render ConceptName */
            E_Condition result = renderHTMLConceptName(ref docStream, flags);
            /* render TextValue */
            if (Convert.ToBoolean(flags & HF_renderItemInline))
            {
                docStream.Append("\"");
                docStream.Append(convertToHTMLString(dsrStringValue.getValue(), htmlString, flags));
                docStream.Append("\"");
                docStream.AppendLine();
            }
            else
            {
                docStream.Append(convertToHTMLString(dsrStringValue.getValue(), htmlString, flags, true /*newlineAllowed*/));
                docStream.AppendLine();
            }
            return result;
        }
    }
}
