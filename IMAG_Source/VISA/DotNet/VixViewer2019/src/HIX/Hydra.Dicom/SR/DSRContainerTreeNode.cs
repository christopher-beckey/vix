using ClearCanvas.Dicom;
using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;
using System.Threading.Tasks;

namespace Hydra.Dicom
{
    public class DSRContainerTreeNode : DSRDocumentTreeNode
    {
        /// <summary>
        /// constructor
        /// </summary>
        public DSRContainerTreeNode()
        {
        }

        /// <summary>
        /// declaration of default/copy constructor
        /// </summary>
        /// <param name="theDSRContainerTreeNode"></param>
        public DSRContainerTreeNode(DSRContainerTreeNode theDSRContainerTreeNode)
        {
        }

        /// <summary>
        /// constructor
        /// </summary>
        /// <param name="relationshipType"></param>
        /// <param name="continuityOfContent"></param>
        public DSRContainerTreeNode(E_RelationshipType relationshipType, E_ContinuityOfContent continuityOfContent = E_ContinuityOfContent.COC_Separate)
            : base(relationshipType, E_ValueType.VT_Container)
        {
            ContinuityOfContent = continuityOfContent;
        }

        /// <summary>
        /// destructor
        /// </summary>
        ~DSRContainerTreeNode()
        {

        }

        /// <summary>
        /// clear all member variables. Please note that the content item might become invalid afterwards.
        /// </summary>
        public override void clear()
        {
            ContinuityOfContent = E_ContinuityOfContent.COC_Separate;      // this is more useful that COC_invalid
        }

        /// <summary>
        /// check whether the content item is valid. The content item is valid if the base class is valid, the continuity of content 
        /// flag is valid, and the concept name is valid or the content item is not the root item.
        /// </summary>
        /// <returns> true if tree node is valid, false otherwise </returns>
        public override bool isValid()
        {
            /* ConceptNameCodeSequence required for root node container */
            return base.isValid() && (ContinuityOfContent != E_ContinuityOfContent.COC_invalid) &&
                    ((getRelationshipType() != E_RelationshipType.RT_isRoot) || getConceptName().isValid());
        }

        /// <summary>
        /// check whether the content is short. A container content item is defined to be never short (return always OFFalse).
        /// </summary>
        /// <param name="flags"></param>
        /// <returns> true if content is short, false otherwise </returns>
        public override bool isShort(int flags)
        {
            return false;
        }

        /// <summary>
        /// print content item. A typical output looks like this: CONTAINER:(,,"Diagnosis")=SEPARATE for the root node
        /// and contains CONTAINER:=CONTINUOUS for a "normal" content item.
        /// </summary>
        /// <param name="stream"></param>
        /// <param name="flags"></param>
        /// <returns> status, EC_Normal if successful, an error code otherwise </returns>
        public override E_Condition print(ref StringBuilder stream, int flags)
        {
            E_Condition result = E_Condition.EC_IllegalParameter;
            if (stream != null)
            {
                result = base.print(ref stream, flags);
                if (result.good())
                    stream.Append(continuityOfContentToEnumeratedValue(ContinuityOfContent));
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
            writeXMLItemStart(ref stream, flags, false /*closingBracket*/);
            stream.Append(" flag=\"");
            stream.Append(continuityOfContentToEnumeratedValue(ContinuityOfContent));
            stream.Append("\"");
            stream.Append(">");
            stream.AppendLine();
            result = base.writeXML(ref stream, flags);
            writeXMLItemEnd(ref stream, flags);
            return result;
        }

        /// <summary>
        /// render content item in HTML/XHTML format. After rendering the current content item all child nodes (if any) are also rendered 
        /// (see renderHTMLChildNodes() for details). This method overwrites the one specified in base class 
        /// DSRDocumentTree since the rendering of the child nodes depends on the value of the flag 'ContinuityOfContent'.
        /// </summary>
        /// <param name="docStream"></param>
        /// <param name="annexStream"></param>
        /// <param name="nestingLevel"></param>
        /// <param name="annexNumber"></param>
        /// <param name="flags"></param>
        /// <returns> status, EC_Normal if successful, an error code otherwise </returns>
        public override E_Condition renderHTML(ref StringBuilder docStream, ref StringBuilder annexStream, int nestingLevel, ref int annexNumber, int flags)
        {
            /* check for validity */
            if (!isValid())
                printInvalidContentItemMessage("Rendering", this);
            /* render content item */
            E_Condition result = renderHTMLContentItem(ref docStream, ref annexStream, nestingLevel, ref annexNumber, flags);
            if (result.good())
            {
                /* section body: render child nodes */
                if (ContinuityOfContent == E_ContinuityOfContent.COC_Continuous)
                    result = renderHTMLChildNodes(ref docStream, ref annexStream, nestingLevel, ref annexNumber, flags & ~HF_renderItemsSeparately);
                else  // might be invalid
                    result = renderHTMLChildNodes(ref docStream, ref annexStream, nestingLevel, ref annexNumber, flags | HF_renderItemsSeparately);
            }
            else
                printContentItemErrorMessage("Rendering", result, this);
            return result;
        }

        /// <summary>
        /// get continuity of content flag. This flag specifies whether or not its contained content items (child nodes) are
        /// logically linked in a continuous textual flow, or are sparate items.
        /// </summary>
        /// <returns> continuity of content flag if successful, COC_invalid otherwise </returns>
        public E_ContinuityOfContent getContinuityOfContent()
        {
            return ContinuityOfContent;
        }

        /// <summary>
        /// set continuity of content flag. This flag specifies whether or not its contained content items (child nodes) are
        /// logically linked in a continuous textual flow, or are sparate items.
        /// </summary>
        /// <param name="continuityOfContent"></param>
        /// <returns> status, EC_Normal if successful, an error code otherwise </returns>
        public E_Condition setContinuityOfContent(E_ContinuityOfContent continuityOfContent)
        {
            E_Condition result = E_Condition.EC_IllegalParameter;
            if (continuityOfContent != E_ContinuityOfContent.COC_invalid)
            {
                ContinuityOfContent = continuityOfContent;
                result = E_Condition.EC_Normal;
            }
            return result;
        }

        /// <summary>
        /// read content item (value) from dataset
        /// </summary>
        /// <param name="dataset"></param>
        /// <returns> status, EC_Normal if successful, an error code otherwise </returns>
        protected override E_Condition readContentItem(ref DicomAttributeCollection dataset)
        {
            string tmpString = "";
            /* read ContinuityOfContent */
            E_Condition result = getAndCheckStringValueFromDataset(dataset, getDicomAttribute(DicomTags.ContinuityOfContent), ref tmpString, "1", "1", "CONTAINER content item");
            if (result.good())
            {
                ContinuityOfContent = enumeratedValueToContinuityOfContent(tmpString);
                /* check ContinuityOfContent value */
                if (ContinuityOfContent == E_ContinuityOfContent.COC_invalid)
                {
                    printUnknownValueWarningMessage("ContinuityOfContent value", tmpString);
                    result = E_Condition.SR_EC_InvalidValue;
                }
            }
            return result;
        }

        /// <summary>
        /// write content item (value) to dataset.
        /// </summary>
        /// <param name="dataset"></param>
        /// <returns> status, EC_Normal if successful, an error code otherwise </returns>
        protected override E_Condition writeContentItem(DicomAttributeCollection dataset)
        {
            /* write ContinuityOfContent */
            return putStringValueToDataset(dataset, getDicomAttribute(DicomTags.ContinuityOfContent), continuityOfContentToEnumeratedValue(ContinuityOfContent));
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
                string tmpString = "";
                /* read 'flag' and check validity */
                ContinuityOfContent = enumeratedValueToContinuityOfContent(doc.getStringFromAttribute(cursor, ref tmpString, "flag"));
                if (ContinuityOfContent == E_ContinuityOfContent.COC_invalid)
                {
                    printUnknownValueWarningMessage("CONTAINER flag", tmpString);
                    result = E_Condition.SR_EC_InvalidValue;
                }
                else
                    result = E_Condition.EC_Normal;
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
            /* section heading (optional) */
            if (nestingLevel > 0)
            {
                /* render ConceptName & Code (if valid) */
                if (getConceptName().getCodeMeaning() != string.Empty)
                {
                    int section = (nestingLevel > 6) ? 6 : nestingLevel;
                    docStream.Append("<h");
                    docStream.Append(section);
                    docStream.Append(">");

                    getConceptName().renderHTML(ref docStream, flags, ((flags & HF_renderConceptNameCodes) != 0) && getConceptName().isValid() /*fullCode*/);

                    docStream.Append("</h");
                    docStream.Append(section);
                    docStream.Append(">");
                    docStream.AppendLine();
                }
                /* render optional observation datetime */
                if (!string.IsNullOrEmpty(getObservationDateTime()))
                {
                    string tmpString = "";

                    docStream.Append("<p>");
                    docStream.AppendLine();

                    if ((flags & HF_XHTML11Compatibility) != 0)
                        docStream.Append("<span class=\"observe\">");
                    else
                        docStream.Append("<small>");

                    docStream.Append("(observed: ");
                    docStream.Append(dicomToReadableDateTime(getObservationDateTime(), tmpString));
                    docStream.Append(")");

                    if ((flags & HF_XHTML11Compatibility) != 0)
                    {
                        docStream.Append("</span>");
                        docStream.AppendLine();
                    }
                    else
                    {
                        docStream.Append("<small>");
                        docStream.AppendLine();
                    }

                    docStream.Append("<p>");
                    docStream.AppendLine();
                }
            }
            return E_Condition.EC_Normal;
        }

        /// continuity of content flag (associated DICOM VR=CS, mandatory)
        private E_ContinuityOfContent ContinuityOfContent;
    }
}
