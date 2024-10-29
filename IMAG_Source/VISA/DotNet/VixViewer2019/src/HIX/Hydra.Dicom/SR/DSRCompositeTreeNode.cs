using ClearCanvas.Dicom;
using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;
using System.Threading.Tasks;

namespace Hydra.Dicom
{
    public class DSRCompositeTreeNode : DSRDocumentTreeNode/*, DSRCompositeReferenceValue*/
    {
        DSRCompositeReferenceValue itsDSRCompositeReferenceValue = null;
        /// <summary>
        /// constructor
        /// </summary>
        public DSRCompositeTreeNode()
        {
            itsDSRCompositeReferenceValue = new DSRCompositeReferenceValue();
        }

        /// <summary>
        /// declaration of default/copy constructor
        /// </summary>
        /// <param name="theDSRCompositeTreeNode"></param>
        public DSRCompositeTreeNode(DSRCompositeTreeNode theDSRCompositeTreeNode)
        {
            itsDSRCompositeReferenceValue = new DSRCompositeReferenceValue();
        }

        /// <summary>
        /// constructor
        /// </summary>
        /// <param name="relationshipType"></param>
        public DSRCompositeTreeNode(E_RelationshipType relationshipType)
            : base(relationshipType, E_ValueType.VT_Composite)
        {
            itsDSRCompositeReferenceValue = new DSRCompositeReferenceValue();
        }

        /// <summary>
        /// destructor
        /// </summary>
        ~DSRCompositeTreeNode()
        {

        }

        /// <summary>
        /// clear all member variables. Please note that the content item might become invalid afterwards.
        /// </summary>
        public override void clear()
        {
            base.clear();
            itsDSRCompositeReferenceValue.clear();
        }

        /// <summary>
        /// check whether the content item is valid. The content item is valid if the two base classes are valid.
        /// </summary>
        /// <returns> true if tree node is valid, false otherwise </returns>
        public override bool isValid()
        {
            return base.isValid() && itsDSRCompositeReferenceValue.isValid();
        }

        /// <summary>
        /// print content item. A typical output looks like this: contains COMPOSITE:=(BasicTextSR,"1.2.3")
        /// @param  stream  output stream to which the content item should be printed.
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
                result = itsDSRCompositeReferenceValue.print(ref stream, flags);
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
            stream.Append("<value>");
            stream.AppendLine();
            itsDSRCompositeReferenceValue.writeXML(ref stream, flags);
            stream.Append("</value>");
            stream.AppendLine();
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
            /* read ReferencedSOPSequence */
            return itsDSRCompositeReferenceValue.readSequence(ref dataset, "1" /* type */);
        }

        /// <summary>
        /// write content item (value) to dataset.
        /// </summary>
        /// <param name="dataset"></param>
        /// <returns> status, EC_Normal if successful, an error code otherwise </returns>
        protected override E_Condition writeContentItem(DicomAttributeCollection dataset)
        {
            /* write ReferencedSOPSequence */
            return itsDSRCompositeReferenceValue.writeSequence(ref dataset);
        }

        /// <summary>
        /// read content item specific XML data.
        /// </summary>
        /// <param name="dataset"></param>
        /// <param name="cursor"></param>
        /// <returns> status, EC_Normal if successful, an error code otherwise </returns>
        protected override E_Condition readXMLContentItem(ref DSRXMLDocument doc, DSRXMLCursor cursor)
        {
            /* retrieve value from XML element "value" */
            //DSRXMLCursor mainChildCursor = cursor.gotoChild();
            return itsDSRCompositeReferenceValue.readXML(ref doc, doc.getNamedNode(cursor.gotoChild(), "value"));
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
            /* render Reference */
            if (result.good())
            {
                result = itsDSRCompositeReferenceValue.renderHTML(ref docStream, ref annexStream, ref annexNumber, flags);
                docStream.AppendLine();
            }
            return result;
        }
    }
}
