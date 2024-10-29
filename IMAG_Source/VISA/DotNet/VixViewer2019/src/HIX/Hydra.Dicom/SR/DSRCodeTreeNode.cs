using ClearCanvas.Dicom;
using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;
using System.Threading.Tasks;

namespace Hydra.Dicom
{
    public class DSRCodeTreeNode : DSRDocumentTreeNode/*, DSRCodedEntryValue*/
    {
        DSRCodedEntryValue itsDSRCodedEntryValue = null;
        /// <summary>
        /// constructor
        /// </summary>
        public DSRCodeTreeNode()
        {
            itsDSRCodedEntryValue = new DSRCodedEntryValue();
        }

        /// <summary>
        /// declaration of default/copy constructor
        /// </summary>
        /// <param name="theDSRCodeTreeNode"></param>
        public DSRCodeTreeNode(DSRCodeTreeNode theDSRCodeTreeNode)
        {
            itsDSRCodedEntryValue = new DSRCodedEntryValue();
        }

        /// <summary>
        /// constructor
        /// </summary>
        /// <param name="relationshipType"></param>
        public DSRCodeTreeNode(E_RelationshipType relationshipType)
            : base(relationshipType, E_ValueType.VT_Code)
        {
            itsDSRCodedEntryValue = new DSRCodedEntryValue();
        }

        /// <summary>
        /// destructor
        /// </summary>
        ~DSRCodeTreeNode()
        {

        }

        /// <summary>
        /// clear all member variables. Please note that the content item might become invalid afterwards.
        /// </summary>
        public override void clear()
        {
             base.clear();
             itsDSRCodedEntryValue.clear();
        }

        /// <summary>
        /// check whether the content item is valid. The content item is valid if the two base classes and the concept name are valid.
        /// </summary>
        /// <returns> true if tree node is valid, false otherwise </returns>
        public override bool isValid()
        {
            /* ConceptNameCodeSequence required */
            return base.isValid() && itsDSRCodedEntryValue.isValid() && getConceptName().isValid();
        }

        /// <summary>
        /// print content item. A typical output looks like this: has concept mod CODE:(,,"Code")=(1234,99_OFFIS_DCMTK,"Code Meaning").
        /// </summary>
        /// <param name="stream"></param>
        /// <param name="flags"></param>
        /// <returns> status, EC_Normal if successful, an error code otherwise </returns>
        public override E_Condition print(ref StringBuilder stream, int flags)
        {
            E_Condition result = base.print(ref stream, flags);
            if (result.good())
            {
                stream.Append("=");
                itsDSRCodedEntryValue.print(ref stream, true /*printCodeValue*/, true /*printInvalid*/);
            }
            return result;
        }

        /// <summary>
        /// write content item in XML format.
        /// </summary>
        /// <param name="stream"></param>
        /// <param name="flags"></param>
        /// <returns> status, EC_Normal if successful, an error code otherwise </returns>
        public override E_Condition writeXML(ref StringBuilder stream, int flags)
        {
            E_Condition result = E_Condition.EC_Normal;
            writeXMLItemStart(ref stream, flags);
            result = base.writeXML(ref stream, flags);
            if (Convert.ToBoolean(flags & DSRTypes.XF_codeComponentsAsAttribute))
            {
                stream.Append("<value"); // bracket ">" is closed in next the writeXML() routine
                //TODO DSRCodeTreeNode: writeXML
                itsDSRCodedEntryValue.writeXML(ref stream, flags);
                stream.Append("</value");
                stream.AppendLine();
            } 
            else
                base.writeXML(ref stream, flags);
            writeXMLItemEnd(ref stream, flags);
            return result;
        }

        /// <summary>
        /// read content item (value) from dataset
        /// </summary>
        /// <param name="dataset"></param>
        /// <returns> status, EC_Normal if successful, an error code otherwise </returns>
        protected override E_Condition readContentItem(ref DicomAttributeCollection dataset)
        {
            /* read ConceptCodeSequence */
            DicomAttribute atri = getDicomAttribute(DicomTags.ConceptCodeSequence);
            return itsDSRCodedEntryValue.readSequence(ref dataset, ref atri, "1" /*type*/);
        }

        /// <summary>
        /// write content item (value) to dataset.
        /// </summary>
        /// <param name="dataset"></param>
        /// <returns> status, EC_Normal if successful, an error code otherwise </returns>
        protected override E_Condition writeContentItem(DicomAttributeCollection dataset)
        {
            /* write ConceptCodeSequence */
            DicomAttribute atri = getDicomAttribute(DicomTags.ConceptCodeSequence);
            //TODO DSRCodeTreeNode: writeContentItem
            //return DSRCodedEntryValue::writeSequence(ref dataset, ref atri);
            return E_Condition.EC_IllegalCall;
        }

        /// <summary>
        /// read content item specific XML data.
        /// </summary>
        /// <param name="doc"></param>
        /// <param name="cursor"></param>
        /// <returns> status, EC_Normal if successful, an error code otherwise </returns>
        protected override E_Condition readXMLContentItem(ref DSRXMLDocument doc, DSRXMLCursor cursor)
        {
            E_Condition result = E_Condition.SR_EC_CorruptedXMLStructure;
            if (cursor.valid())
            {
                /* goto "value" element */
                DSRXMLCursor mainChildCursor = cursor.getChild();
                DSRXMLCursor childCursor = doc.getNamedNode(mainChildCursor, "value");
                if (childCursor.valid())
                {
                    DSRCodedEntryValue codeEntryValue = new DSRCodedEntryValue();
                    /* check whether code is stored as XML elements or attributes */
                    if (doc.hasAttribute(ref childCursor, "codValue"))
                        result = codeEntryValue.readXML(ref doc, childCursor);
                    else
                        result = codeEntryValue.readXML(ref doc, cursor);
                }
            }
            return result;
        }

        /// <summary>
        /// render content item (value) in HTML/XHTML format.
        /// </summary>
        /// <param name="docStream"></param>
        /// <param name="annexStream"></param>
        /// <param name="nestingLevel"></param>
        /// <param name="annexNumber"></param>
        /// <param name="flags"></param>
        /// <returns> status, EC_Normal if successful, an error code otherwise </returns>
        protected override E_Condition renderHTMLContentItem(ref StringBuilder docStream, ref StringBuilder annexStream, int nestingLevel, ref int annexNumber, int flags)
        {
            /* render ConceptName */
            E_Condition result = renderHTMLConceptName(ref docStream, flags);
            /* render Code */
            if (result.good())
            {
                bool fullCode = Convert.ToBoolean(flags & DSRTypes.HF_renderInlineCodes) || Convert.ToBoolean(flags & DSRTypes.HF_renderItemsSeparately);
                if (!fullCode || Convert.ToBoolean(flags & DSRTypes.HF_useCodeDetailsTooltip))
                {
                    if (Convert.ToBoolean(flags & DSRTypes.HF_XHTML11Compatibility))
                        docStream.Append("<span class=\"code\">");
                    else if (Convert.ToBoolean(flags & DSRTypes.HF_HTML32Compatibility))
                        docStream.Append("<u>");
                    else /* HTML 4.01 */
                        docStream.Append("<span class=\"under\">");
                }
                result = itsDSRCodedEntryValue.renderHTML(ref docStream, flags, fullCode);
                if (!fullCode || Convert.ToBoolean(flags & DSRTypes.HF_useCodeDetailsTooltip))
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
