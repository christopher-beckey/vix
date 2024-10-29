using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;
using System.Threading.Tasks;
using ClearCanvas.Dicom;
using Hydra.Dicom.SR;

namespace Hydra.Dicom
{
    public class DSRNumTreeNode : DSRDocumentTreeNode/*, DSRNumericMeasurementValue*/
    {
        DSRNumericMeasurementValue itsDSRNumericMeasurementValue = null;

        public DSRNumTreeNode(E_RelationshipType relationshipType)
            : base(relationshipType, E_ValueType.VT_Num)
        {
            itsDSRNumericMeasurementValue = new DSRNumericMeasurementValue();
        }

        ~DSRNumTreeNode()
        {
        }

        public override void clear()
        {
            base.clear();
            itsDSRNumericMeasurementValue.clear();
        }

        public override bool isValid()
        {
            /* ConceptNameCodeSequence required */
            return base.isValid() && itsDSRNumericMeasurementValue.isValid() && getConceptName().isValid();
        }

        public override E_Condition print(ref StringBuilder stream, int flags)
        {
            E_Condition result = base.print(ref stream, flags);
            if (result.good())
            {
                stream.Append("=");
                itsDSRNumericMeasurementValue.print(ref stream, flags);
            }
            return result;
        }

        public override E_Condition writeXML(ref StringBuilder stream, int flags)
        {
            E_Condition result = E_Condition.EC_Normal;
            writeXMLItemStart(ref stream, flags);
            result = base.writeXML(ref stream, flags);
            itsDSRNumericMeasurementValue.writeXML(ref stream, flags);
            writeXMLItemEnd(ref stream, flags);
            return result;
        }

        protected override E_Condition readContentItem(ref DicomAttributeCollection dataset)
        {
            return itsDSRNumericMeasurementValue.readSequence(ref dataset);
        }

        protected override E_Condition writeContentItem(DicomAttributeCollection dataset)
        {
            return itsDSRNumericMeasurementValue.writeSequence(ref dataset);
        }

        protected override E_Condition readXMLContentItem(ref DSRXMLDocument doc, DSRXMLCursor cursor)
        {
            return itsDSRNumericMeasurementValue.readXML(ref doc, cursor);
        }

        protected override E_Condition renderHTMLContentItem(ref StringBuilder docStream, ref StringBuilder annexStream, int nestingLevel, ref int annexNumber, int flags)
        {
            /* render ConceptName */
            E_Condition result = renderHTMLConceptName(ref docStream, flags);
            /* render Num */
            if (result.good())
            {
                result = itsDSRNumericMeasurementValue.renderHTML(ref docStream, ref annexStream, ref annexNumber, flags);
                docStream.AppendLine();
            }
            return result;
        }

    }
}
