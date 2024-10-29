using ClearCanvas.Dicom;
using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;
using System.Threading.Tasks;

namespace Hydra.Dicom
{
    public class DSRByReferenceTreeNode : DSRDocumentTreeNode
    {
        /// <summary>
        /// 
        /// </summary>
        public DSRByReferenceTreeNode()
        {
        }

        /// <summary>
        /// declaration of default/copy constructor
        /// </summary>
        public DSRByReferenceTreeNode(DSRByReferenceTreeNode theDSRByReferenceTreeNode)
        {
        }

        /// <summary>
        /// 
        /// </summary>
        /// <param name="relationshipType"></param>
        public DSRByReferenceTreeNode(E_RelationshipType relationshipType)
            : base(relationshipType, E_ValueType.VT_byReference)
        {
            ValidReference = false;
            ReferencedContentItem = "";
            ReferencedNodeID = 0;
        }

        /// <summary>
        /// 
        /// </summary>
        /// <param name="relationshipType"></param>
        /// <param name="referencedNodeID"></param>
        public DSRByReferenceTreeNode(E_RelationshipType relationshipType, int referencedNodeID)
            : base(relationshipType, E_ValueType.VT_byReference)
        {
            ValidReference = false;
            ReferencedContentItem = "";
            ReferencedNodeID = referencedNodeID;
        }

        /// <summary>
        /// clear all member variables. Please note that the content item becomes invalid afterwards.
        /// </summary>
        public override void clear()
        {
            base.clear();
            ValidReference = false;
            ReferencedContentItem = "";
            ReferencedNodeID = 0;
        }

        /// <summary>
        /// check whether the content item is valid. The content item is valid if the base class is valid, the concept name is
        /// empty and the reference (checked from outside this class) is valid.
        /// </summary>
        /// <returns> true if tree node is valid, otherwise false </returns>
        public override bool isValid()
        {
            /* ConceptNameCodeSequence not allowed */
            return base.isValid() && getConceptName().isEmpty() && ValidReference;
        }

        /// <summary>
        /// print content item.
        /// </summary>
        /// <param name="stream"></param>
        /// <param name="flags"></param>
        /// <returns> true if suucessful, otherwise false </returns>
        public override E_Condition print(ref StringBuilder stream, int flags)
        {
            stream.Append(relationshipTypeToReadableName(getRelationshipType()));
            stream.Append(" ");
            stream.Append(ReferencedContentItem);
            return E_Condition.EC_Normal;
        }

        /// <summary>
        /// write content item in XML format.
        /// </summary>
        /// <param name="stream"></param>
        /// <param name="flags"></param>
        /// <returns> true if suucessful, otherwise false </returns>
        public override E_Condition writeXML(ref StringBuilder stream, int flags)
        {
            E_Condition result = E_Condition.EC_Normal;
            writeXMLItemStart(ref stream, flags, false /*closingBracket*/);
            stream.Append(" ref=\"");
            stream.Append(ReferencedNodeID);
            stream.Append("\">");
            stream.AppendLine();
            /* basically, there should be no child content items */
            result = base.writeXML(ref stream, flags);
            writeXMLItemEnd(ref stream, flags);
            return result;
        }

        /// <summary>
        /// set the concept name.
        /// </summary>
        /// <param name="conceptName"></param>
        /// <returns> always returns EC_IllegalCall, since this content item has no template identification (part of Document Relationship Macro) </returns>
        public virtual E_Condition setConceptName(ref DSRCodedEntryValue conceptName)
        {
            /* invalid: no concept name allowed */
            return E_Condition.EC_IllegalCall;
        }

        /// <summary>
        /// set observation date time.
        /// </summary>
        /// <param name="observationDateTime"></param>
        /// <returns> always returns EC_IllegalCall, since this content item has no template identification (part of Document Relationship Macro) </returns>
        public virtual E_Condition setObservationDateTime(ref string observationDateTime)
        {
            /* invalid: no observation date and time allowed */
            return E_Condition.EC_IllegalCall;
        }

        /// <summary>
        /// set template identifier and mapping resource.
        /// </summary>
        /// <param name="templateIdentifier"></param>
        /// <param name="mappingResource"></param>
        /// <returns> always returns EC_IllegalCall, since this content item has no template identification (part of Document Relationship Macro) </returns>
        public virtual E_Condition setTemplateIdentification(ref string templateIdentifier, ref string mappingResource)
        {
            /* invalid: no template identification allowed */
            return E_Condition.EC_IllegalCall;
        }

        /// <summary>
        /// get ID of the referenced node.
        /// </summary>
        /// <returns> ID of the referenced node if valid, 0 otherwise </returns>
        public int getReferencedNodeID()
        {
            return ReferencedNodeID;
        }

        /// <summary>
        /// read content item (value) from dataset.
        /// </summary>
        /// <param name="dataset"></param>
        /// <returns> status, EC_Normal if successful, an error code otherwise </returns>
        protected override E_Condition readContentItem(ref DicomAttributeCollection dataset)
        {
            DicomAttribute delem = getDicomAttribute(DicomTags.ReferencedContentItemIdentifier);
            /* clear before reading */
            ReferencedContentItem = "";
            ReferencedNodeID = 0;
            /* read ReferencedContentItemIdentifier */
            E_Condition result = getAndCheckElementFromDataset(dataset, ref delem, "1-n", "1C", "by-reference relationship");
            if (result.good())
            {
                /* create reference string from unsigned long values */
                UInt32 value = 0;
                string buffer = "";
                long count = delem.Count;
                for (long i = 0; i < count; i++)
                {
                    if (i > 0)
                        ReferencedContentItem += '.';
                    if (delem.TryGetUInt32(Convert.ToInt32(i), out value))
                        ReferencedContentItem += numberToString(Convert.ToInt32(value), buffer);
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
            E_Condition result = E_Condition.SR_EC_InvalidValue;
            /* only write references with valid format */
            if (checkForValidUIDFormat(ReferencedContentItem))
            {
                result = E_Condition.EC_Normal;
                DicomAttribute delem = getDicomAttribute(DicomTags.ReferencedContentItemIdentifier);
                /* create unsigned long values from reference string */
                int posStart = 0;
                int posEnd = 0;
                ulong i = 0;
                do {
                    /* search for next separator */
                    posEnd = ReferencedContentItem.IndexOf('.', posStart);
                    /* is last segment? */
                    if (posEnd == -1)
                        delem.SetUInt32(DSRTypes.stringToNumber(ReferencedContentItem.Substring(posStart)), Convert.ToUInt32(i));
                    else {
                        delem.SetUInt32(DSRTypes.stringToNumber(ReferencedContentItem.Substring(posStart, posEnd - posStart)), Convert.ToUInt32(i));
                        posStart = posEnd + 1;
                    }
                    i++;
                } while (posEnd != -1);
                /* write ReferencedContentItemIdentifier */
                addElementToDataset(dataset, delem, "1-n", "1", "by-reference relationship");
            }
            return result;
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
                string refID = "";
                /* get "ref" attribute */
                if (doc.getStringFromAttribute(cursor, ref refID, "ref") != string.Empty)
                {
                    ReferencedNodeID = stringToNumber(refID);
                    /* this does not mean that the reference is really correct, this will be checked later */
                    result = E_Condition.EC_Normal;
                }
                else
                    result = E_Condition.SR_EC_InvalidValue;
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
            /* render reference string */
            docStream.Append("Content Item <a href=\"#content_item_");
            docStream.Append(ReferencedNodeID);
            docStream.Append("\">by-reference</a>");
            docStream.AppendLine();
            return E_Condition.EC_Normal;
        }

        /// flag indicating whether the reference is valid or not (i.e. checked)
        public bool ValidReference;
        /// position string of the referenced content item (target)
        public String ReferencedContentItem;
        /// node ID of the referenced content item (target)
        public int ReferencedNodeID;
    }
}
