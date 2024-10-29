using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;
using System.Threading.Tasks;
using ClearCanvas.Dicom;

namespace Hydra.Dicom
{
    public class DSRImageTreeNode  : DSRDocumentTreeNode/*, DSRImageReferenceValue*/
    {
        DSRImageReferenceValue itsDSRImageReferenceValue = null;
        /// <summary>
        /// 
        /// </summary>
        /// <param name="relationshipType"></param>
        public DSRImageTreeNode(E_RelationshipType relationshipType)
            : base(relationshipType, E_ValueType.VT_Image)
        {
            itsDSRImageReferenceValue = new DSRImageReferenceValue();
        }

        /// <summary>
        /// 
        /// </summary>
        ~DSRImageTreeNode()
        {
        }

        /// <summary>
        /// 
        /// </summary>
        public override void clear()
        {
            base.clear();
            itsDSRImageReferenceValue.clear();
        }

        /// <summary>
        /// 
        /// </summary>
        /// <returns></returns>
        public override bool isValid()
        {
            return base.isValid() && itsDSRImageReferenceValue.isValid();
        }

        /// <summary>
        /// 
        /// </summary>
        /// <param name="flags"></param>
        /// <returns></returns>
        public override bool isShort(int flags)
        {
            return itsDSRImageReferenceValue.isShort(flags);
        }

        /// <summary>
        /// 
        /// </summary>
        /// <param name="stream"></param>
        /// <param name="flags"></param>
        /// <returns></returns>
        public override E_Condition print(ref StringBuilder stream, int flags)
        {
            E_Condition result = base.print(ref stream, flags);
            if (result.good())
            {
                stream.Append("=");
                result = itsDSRImageReferenceValue.print(ref stream, flags);
            }
            return result;
        }

        /// <summary>
        /// 
        /// </summary>
        /// <param name="stream"></param>
        /// <param name="flags"></param>
        /// <returns></returns>
        public override E_Condition writeXML(ref StringBuilder stream, int flags)
        {
            E_Condition result = base.print(ref stream, flags);
            if (result.good())
            {
                stream.Append("=");
                result = itsDSRImageReferenceValue.print(ref stream, flags);
            }
            return result;
        }

        public E_Condition setValue(DSRImageReferenceValue referenceValue)
        {
            try
            {
                itsDSRImageReferenceValue.setValue(referenceValue);
            }
            catch (Exception ex)
            {
                return E_Condition.EC_IllegalParameter;
            }
            return E_Condition.EC_Normal;
        }

        /// <summary>
        /// 
        /// </summary>
        /// <param name="dataset"></param>
        /// <returns></returns>
        protected override E_Condition readContentItem(ref DicomAttributeCollection dataset)
        {
             /* read ReferencedSOPSequence */
            return itsDSRImageReferenceValue.readSequence(ref dataset, "1" /*type*/);
        }

        /// <summary>
        /// 
        /// </summary>
        /// <param name="dataset"></param>
        /// <returns></returns>
        protected override E_Condition writeContentItem(DicomAttributeCollection dataset)
        {
            /* write ReferencedSOPSequence */
            return itsDSRImageReferenceValue.writeSequence(ref dataset);
        }

        /// <summary>
        /// 
        /// </summary>
        /// <param name="doc"></param>
        /// <param name="cursor"></param>
        /// <returns></returns>
        protected override E_Condition readXMLContentItem(ref DSRXMLDocument doc, DSRXMLCursor cursor)
        {
            /* retrieve value from XML element "value" */
            DSRXMLCursor mainChildCursor = cursor.gotoChild();
            return itsDSRImageReferenceValue.readXML(ref doc, doc.getNamedNode(mainChildCursor, "value"));
        }

        /// <summary>
        /// 
        /// </summary>
        /// <param name="docStream"></param>
        /// <param name="annexStream"></param>
        /// <param name="nestingLevel"></param>
        /// <param name="annexNumber"></param>
        /// <param name="flags"></param>
        /// <returns></returns>
        protected override E_Condition renderHTMLContentItem(ref StringBuilder docStream, ref StringBuilder annexStream, int nestingLevel, ref int annexNumber, int flags)
        {
            /* render ConceptName */
            E_Condition result = renderHTMLConceptName(ref docStream, flags);
            /* render Reference */
            if (result.good())
            {
                //TODO: DSRImageTreeNode: renderHTMLContentItem
                result = itsDSRImageReferenceValue.renderHTML(ref docStream, ref annexStream, ref annexNumber, flags);
                docStream.AppendLine();
            }
            return result;
        }

    }
}
