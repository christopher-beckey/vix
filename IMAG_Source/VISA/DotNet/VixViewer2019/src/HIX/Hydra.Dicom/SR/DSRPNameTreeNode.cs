using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;
using System.Threading.Tasks;
using ClearCanvas.Dicom;

namespace Hydra.Dicom
{
    public class DSRPNameTreeNode : DSRDocumentTreeNode
    {
        DSRStringValue dsrStringValue = null;
        /** constructor
     ** @param  relationshipType  type of relationship to the parent tree node.
     *                            Should not be RT_invalid or RT_isRoot.
     */
        public DSRPNameTreeNode(E_RelationshipType relationshipType)
            : base(relationshipType, E_ValueType.VT_PName)
        {
            dsrStringValue = new DSRStringValue();
        }

        /** constructor
        ** @param  relationshipType  type of relationship to the parent tree node.
        *                            Should not be RT_invalid or RT_isRoot.
        *  @param  stringValue       initial string value to be set
        */
        public DSRPNameTreeNode(E_RelationshipType relationshipType, ref string stringValue)
            : base(relationshipType, E_ValueType.VT_PName)
        {
            dsrStringValue = new DSRStringValue();
        }

        /** destructor
        */
        ~DSRPNameTreeNode()
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


        public override bool isValid()
        {
            /* ConceptNameCodeSequence required */
            return base.isValid() && dsrStringValue.isValid() && getConceptName().isValid();
        }


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
        public override E_Condition writeXML(ref StringBuilder stream, int flags)
        {
            E_Condition result = E_Condition.EC_Normal;
            writeXMLItemStart(ref stream, flags);
            result = base.writeXML(ref stream, flags);
            if (!string.IsNullOrEmpty(dsrStringValue.getValue()) || Convert.ToBoolean(flags & XF_writeEmptyTags))
            {
                string tmpString = "";
                stream.Append("<value>");
                stream.AppendLine();
                stream.Append(dicomToXMLPersonName(dsrStringValue.getValue(), tmpString));
                stream.AppendLine();
                stream.Append("</value>");
                stream.AppendLine();
            }
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


        protected override E_Condition readContentItem(ref DicomAttributeCollection dataset)
        {
            /* read PName */
            return dsrStringValue.read(dataset, getDicomAttribute(DicomTags.PersonName));
        }


        protected override E_Condition writeContentItem(DicomAttributeCollection dataset)
        {
            /* write PName */
            return dsrStringValue.write(ref dataset, getDicomAttribute(DicomTags.PersonName));
        }


        protected override E_Condition readXMLContentItem(ref DSRXMLDocument doc, DSRXMLCursor cursor)
        {
            E_Condition result = E_Condition.SR_EC_CorruptedXMLStructure;
            if (cursor.valid())
            {
                /* goto sub-node "value" */
                DSRXMLCursor mainChildCursor = cursor.getChild();
                cursor = doc.getNamedNode(mainChildCursor, "value").getChild();
                if (cursor.valid())
                {
                    /* retrieve person name from XML tag */
                    string nameString = "";
                    getValueFromXMLNodeContent(ref doc, cursor, ref nameString);
                    /* set retrieved value */
                    result = dsrStringValue.setValue(nameString);
                }
            }
            return result;
        }

        public static string getValueFromXMLNodeContent(ref DSRXMLDocument doc, DSRXMLCursor cursor, ref string nameValue)
        {
            nameValue = "";
            /* check whether node is valid */
            if (cursor.valid())
            {
                string first = "", middle = "", last = "", suffix = "", prefix = "";
                /* iterate over all nodes */
                while (cursor.valid())
                {
                    /* check for known element tags */
                    doc.getStringFromNodeContent(cursor, ref prefix, "prefix", true /*encoding*/, false /*clearString*/);
                    doc.getStringFromNodeContent(cursor, ref first, "first", true /*encoding*/, false /*clearString*/);
                    doc.getStringFromNodeContent(cursor, ref middle, "middle", true /*encoding*/, false /*clearString*/);
                    doc.getStringFromNodeContent(cursor, ref last, "last", true /*encoding*/, false /*clearString*/);
                    doc.getStringFromNodeContent(cursor, ref suffix, "suffix", true /*encoding*/, false /*clearString*/);
                    /* proceed with next node */
                    cursor.gotoNext();
                }
                /* create DICOM Person Name (PN) from name components */
                int middleLen = middle.Length;
                int prefixLen = prefix.Length;
                int suffixLen = suffix.Length;
                /* concatenate name components */
                nameValue = last;
                if (first.Length + middleLen + prefixLen + suffixLen > 0)
                    nameValue += '^';
                nameValue += first;
                if (middleLen + prefixLen + suffixLen > 0)
                    nameValue += '^';
                nameValue += middle;
                if (prefixLen + suffixLen > 0)
                    nameValue += '^';
                nameValue += prefix;
                if (suffixLen > 0)
                    nameValue += '^';
                nameValue += suffix;
            }
            return nameValue;
        }


        protected override E_Condition renderHTMLContentItem(ref StringBuilder docStream, ref StringBuilder annexStream, int nestingLevel, ref int annexNumber, int flags)
        {
            /* render ConceptName */
            E_Condition result = renderHTMLConceptName(ref docStream, flags);
            /* render PName */
            if (result.good())
            {
                string tmpString = "", htmlString = "";
                if (!Convert.ToBoolean(flags & DSRTypes.HF_renderItemsSeparately))
                {
                    if (Convert.ToBoolean(flags & DSRTypes.HF_XHTML11Compatibility))
                        docStream.Append("<span class=\"pname\">");
                    else if (Convert.ToBoolean(flags & DSRTypes.HF_HTML32Compatibility))
                        docStream.Append("<u>");
                    else /* HTML 4.01 */
                        docStream.Append("<span class=\"under\">");
                }
                docStream.Append(convertToHTMLString(dicomToReadablePersonName(dsrStringValue.getValue(), tmpString), htmlString, flags));
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
