using ClearCanvas.Dicom;
using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;
using System.Threading.Tasks;

namespace Hydra.Dicom
{
    public class DSRDocumentTreeNode : DSRTreeNode
    {
        /// <summary>
        /// constructor
        /// </summary>
        public DSRDocumentTreeNode()
        {
        }

        /// <summary>
        /// declaration of default/copy constructor
        /// </summary>
        /// <param name="theDSRDocumentTreeNode"></param>
        public DSRDocumentTreeNode(DSRDocumentTreeNode theDSRDocumentTreeNode)
        {
        }

        /// <summary>
        /// constructor
        /// The 'relationshipType' and 'valueType' can never be changed after the tree node has been created.
        /// </summary>
        /// <param name="relationshipType"></param>
        /// <param name="valueType"></param>
        public DSRDocumentTreeNode(E_RelationshipType relationshipType, E_ValueType valueType)
            : base()
        {
            MarkFlag = false;
            ReferenceTarget = false;
            RelationshipType = relationshipType;
            ValueType = valueType;
            ConceptName = new DSRCodedEntryValue();
            ObservationDateTime = string.Empty;
            TemplateIdentifier = string.Empty;
            MappingResource = string.Empty;
            MACParameters = getDicomAttribute(DicomTags.MacParametersSequence);
            DigitalSignatures = getDicomAttribute(DicomTags.DigitalSignaturesSequence);
        }

        /// <summary>
        /// destructor
        /// </summary>
        ~DSRDocumentTreeNode()
        {

        }

        /// <summary>
        /// clear all member variables. This does not apply to the relationship and value type since they are never changed.
        /// </summary>
        public virtual void clear()
        {
            MarkFlag = false;
            ReferenceTarget = false;
            ConceptName.clear();
            ObservationDateTime = "";
            TemplateIdentifier = "";
            MappingResource = "";
            MACParameters = null;
            DigitalSignatures = null;
        }

        /// <summary>
        /// check whether the content item is valid. The content item is valid if the relationship type and the value type are both not invalid.
        /// </summary>
        /// <returns> true if tree node is valid, false otherwise </returns>
        public virtual bool isValid()
        {
            return (RelationshipType != E_RelationshipType.RT_invalid) && (ValueType != E_ValueType.VT_invalid);
        }

        /// <summary>
        /// check whether the content is short. This method is used to check whether the rendered output of this content item can be 
        /// expanded inline or not (used for renderHTML()). This base class always returns OFTrue.
        /// </summary>
        /// <param name="flags"></param>
        /// <returns> true if content is short, false otherwise </returns>
        public virtual bool isShort(int flags)
        {
            return true;
        }

        /// <summary>
        /// print content item. The output of a content item depends on its value type. This general method prints
        /// only those parts which all derived classes (= value types) do have in common, i.e. the
        /// type of relationship, the value type and the (optional) concept name.
        /// A typical output looks like this: has concept mod CODE: (,,"Concept")
        /// </summary>
        /// <param name="stream"></param>
        /// <param name="flags"></param>
        /// <returns> status, EC_Normal if successful, an error code otherwise </returns>
        public virtual E_Condition print(ref StringBuilder stream, int flags)
        {
            if (RelationshipType != E_RelationshipType.RT_isRoot)
            {
                stream.Append(relationshipTypeToReadableName(RelationshipType));
                stream.Append(" ");
            }
            stream.Append(valueTypeToDefinedTerm(ValueType));
            stream.Append(":");
            /* only print valid concept name codes */
            if (ConceptName.isValid())
                ConceptName.print(ref stream, (flags & PF_printConceptNameCodes) > 0);
            return E_Condition.EC_Normal;
        }

        /// <summary>
        /// read content item from dataset. A number of readXXX() methods are called (see "protected" part) in order to retrieve all
        /// possibly nested content items from the dataset.
        /// </summary>
        /// <param name="dataset"></param>
        /// <param name="constraintChecker"></param>
        /// <param name="flags"></param>
        /// <returns> status, EC_Normal if successful, an error code otherwise </returns>
        public virtual E_Condition read(DicomAttributeCollection dataset, DSRIODConstraintChecker constraintChecker, int flags)
        {
            return readSRDocumentContentModule(dataset, constraintChecker, flags);
        }

        /// <summary>
        /// write content item to dataset. A number of writeXXX() methods are called (see "protected" part) in order to write all
        /// possibly nested content items to the dataset.
        /// </summary>
        /// <param name="dataset"></param>
        /// <param name="markedItems"></param>
        /// <returns> status, EC_Normal if successful, an error code otherwise </returns>
        public virtual E_Condition write(ref DicomAttributeCollection dataset, Stack<DicomAttributeCollection> markedItems = null)
        {
            return writeSRDocumentContentModule(ref dataset, markedItems);
        }

        /// <summary>
        /// read general XML document tree node data.
        /// </summary>
        /// <param name="doc"></param>
        /// <param name="cursor"></param>
        /// <param name="documentType"></param>
        /// <param name="flags"></param>
        /// <returns> status, EC_Normal if successful, an error code otherwise </returns>
        public virtual E_Condition readXML(ref DSRXMLDocument doc, DSRXMLCursor cursor, E_DocumentType documentType, int flags)
        {
            E_Condition result = E_Condition.SR_EC_InvalidDocument;
            if (cursor.valid())
            {
                string idAttr = "";
                string templateIdentifier = "", mappingResource = "";
                DSRXMLCursor mainchildCursor = cursor.getChild();
                /* important: NULL indicates first child node */
                DSRDocumentTreeNode node = null;
                /* read "id" attribute (optional) and compare with expected value */
                //if ((doc.getStringFromAttribute(cursor, ref idAttr, "id", false /*encoding*/, false /*required*/) != string.Empty) &&
                //    (stringToNumber(idAttr) != Ident))
                //{
                //    /* create warning message */
                //    //TODO LOG
                //    //DCMSR_WARN("XML attribute 'id' (" << idAttr << ") deviates from current node number (" << Ident << ")");
                //}
                /* template identification information expected "inside" content item */
                if (!Convert.ToBoolean(flags & XF_templateElementEnclosesItems))
                {
                    /* check for optional template identification */

                    DSRXMLCursor childCursor = doc.getNamedNode(mainchildCursor, "template", false /*required*/);
                    if (childCursor.valid())
                    {
                        /* check whether information is stored as XML attributes */
                        if (doc.hasAttribute(ref childCursor, "tid"))
                        {
                            doc.getStringFromAttribute(childCursor, ref mappingResource, "resource");
                            doc.getStringFromAttribute(childCursor, ref templateIdentifier, "tid");
                        } else {
                            DSRXMLCursor childOfChildCursor = childCursor.getChild();
                            DSRXMLCursor arg_1 = doc.getNamedNode(childOfChildCursor, "resource");
                            DSRXMLCursor arg_2 = doc.getNamedNode(childOfChildCursor, "id");
                            doc.getStringFromNodeContent(arg_1, ref mappingResource);
                            doc.getStringFromNodeContent(arg_2, ref templateIdentifier);
                        }
                        if (setTemplateIdentification(ref templateIdentifier, ref mappingResource).bad())
                        {
                            //TODO LOG
                            //DCMSR_WARN("Content item has invalid/incomplete template identification");
                        }
                    }
                }
                /* read concept name (not required in some cases) */
                ConceptName.readXML(ref doc, doc.getNamedNode(mainchildCursor, "concept", false /*required*/));
                /* read observation datetime (optional) */
                DSRXMLCursor secchildCursor = doc.getNamedNode(mainchildCursor, "observation", false /*required*/);
                if (secchildCursor.valid())
                {
                    DSRXMLCursor childOfChildCursor = secchildCursor.getChild();
                    DSRDateTimeTreeNode.getValueFromXMLNodeContent(ref doc, doc.getNamedNode(childOfChildCursor, "datetime"), ref ObservationDateTime);
                }
                /* read node content (depends on value type) */
                result = readXMLContentItem(ref doc, cursor.getClone());
                /* goto first child node */
                cursor.gotoChild();
                /* iterate over all child content items */
                while (cursor.valid() && result.good())
                {
                    /* template identification information expected "outside" content item */
                    if (Convert.ToBoolean(flags & XF_templateElementEnclosesItems))
                    {
                        /* check for optional template identification */
                        if (doc.matchNode(cursor, "template"))
                        {
                            doc.getStringFromAttribute(cursor, ref mappingResource, "resource");
                            doc.getStringFromAttribute(cursor, ref templateIdentifier, "tid");
                            /* goto first child of the "template" element */
                            cursor.gotoChild();
                        }
                    }
                    /* get SR value type from current XML node, also supports "by-reference" detection */
                    E_ValueType valueType = doc.getValueTypeFromNode(ref cursor);
                    /* invalid types are silently ignored */
                    if (valueType != E_ValueType.VT_invalid)
                    {
                        /* get SR relationship type */
                        E_RelationshipType relationshipType = doc.getRelationshipTypeFromNode(ref cursor);
                        /* create new node (by-value or by-reference), do not check constraints */
                        result = createAndAppendNewNode(ref node, relationshipType, valueType);
                        if (Convert.ToBoolean(flags & XF_templateElementEnclosesItems) && (valueType != E_ValueType.VT_byReference))
                        {
                            /* set template identification (if any) */
						    if (node.setTemplateIdentification(ref templateIdentifier, ref mappingResource).bad())
						    {
							    //TODO LOG
							    //DCMSR_WARN("Content item has invalid/incomplete template identification"); 
						    }
                        }
                        /* proceed with reading child nodes */
                        result = node.readXML(ref doc, cursor.getClone(), documentType, flags);
                        /* print node error message (if any) */
                        doc.printGeneralNodeError(cursor, ref result);
                    } 
                    else 
                    {
                        /* create new node failed */
					    {
						    //TODO LOG
						    //DCMSR_ERROR("Cannot add \"" << relationshipTypeToReadableName(relationshipType) << " "
						    //<< valueTypeToDefinedTerm(valueType /*target item*/) << "\" to "
						    //<< valueTypeToDefinedTerm(ValueType /*source item*/) << " in "
						    //<< documentTypeToReadableName(documentType));
					    }
                     }
                    /* proceed with next node */
                    cursor.gotoNext();
                }
            }
            return result;
        }

        /// <summary>
        /// write content item in XML format.
        /// </summary>
        /// <param name="stream"></param>
        /// <param name="flags"></param>
        /// <returns> status, EC_Normal if successful, an error code otherwise </returns>
        public virtual E_Condition writeXML(ref StringBuilder stream, int flags)
        {
            E_Condition result = E_Condition.EC_Normal;
            /* check for validity */
            if (!isValid())
                printInvalidContentItemMessage("Writing to XML", this);
            /* write optional template identification */
            if (Convert.ToBoolean(flags & XF_writeTemplateIdentification) && !Convert.ToBoolean(flags & XF_templateElementEnclosesItems))
            {
                if (TemplateIdentifier != string.Empty && MappingResource != string.Empty)
                {
                    if (Convert.ToBoolean(flags & XF_templateIdentifierAsAttribute))
                    {
                        stream.Append("<template resource=\"");
                        stream.Append(MappingResource);
                        stream.Append("\" tid=\"");
                        stream.Append(TemplateIdentifier);
                        stream.Append("\"/>");
                        stream.AppendLine();
                    }
                    else
                    {
                        stream.Append("</template>");
                        stream.AppendLine();
                        writeStringValueToXML(stream, MappingResource, "resource");
                        writeStringValueToXML(stream, TemplateIdentifier, "id");
                        stream.Append("</template>");
                        stream.AppendLine();
                    }
                }
            }
            /* relationship type */
            if ((RelationshipType != E_RelationshipType.RT_isRoot) && !Convert.ToBoolean(flags & XF_relationshipTypeAsAttribute))
                writeStringValueToXML(stream, relationshipTypeToDefinedTerm(RelationshipType), "relationship", (flags & XF_writeEmptyTags) > 0);
            /* concept name */
            if (ConceptName.isValid())
            {
                if (Convert.ToBoolean(flags & XF_codeComponentsAsAttribute))
                    stream.Append("<concept");     // bracket ">" is closed in the next writeXML() routine
                else
                {
                    stream.Append("<concept>");
                    stream.AppendLine();
                }
                ConceptName.writeXML(ref stream, flags);
                stream.Append("<concept>");
                stream.AppendLine();
            }
            /* observation datetime (optional) */
            if (ObservationDateTime != string.Empty)
            {
                string tmpString = "";
                stream.Append("<observation>");
                stream.AppendLine();
                
                DSRUtils.getISOFormattedDateTimeFromString(ref ObservationDateTime, ref tmpString, true /*seconds*/,
                    false /*fraction*/, false /*timeZone*/, false /*createMissingPart*/, "T" /*dateTimeSeparator*/);
                writeStringValueToXML(stream, tmpString, "datetime");
                stream.Append("<observation>");
                stream.AppendLine();
            }
            /* write child nodes (if any) */
            DSRTreeNodeCursor cursor = new DSRTreeNodeCursor(Down);
            if (cursor.isValid())
            {
                DSRDocumentTreeNode node = new DSRDocumentTreeNode();
                do {    /* for all child nodes */
                    node = ((DSRDocumentTreeNode)cursor.getNode());
                    if (node != null)
                        result = node.writeXML(ref stream, flags);
                    else
                        result = E_Condition.SR_EC_InvalidDocumentTree;
                } while (result.good() && Convert.ToBoolean(cursor.gotoNext()));
            }
            return result;
        }

        /// <summary>
        /// render content item in HTML/XHTML format. After rendering the current content item all child nodes (if any) are also rendered 
        /// (see renderHTMLChildNodes() for details).
        /// </summary>
        /// <param name="docStream"></param>
        /// <param name="annexStream"></param>
        /// <param name="nestingLevel"></param>
        /// <param name="annexNumber"></param>
        /// <param name="flags"></param>
        /// <returns> status, EC_Normal if successful, an error code otherwise </returns>
        public virtual E_Condition renderHTML(ref StringBuilder docStream, ref StringBuilder annexStream, int nestingLevel, ref int annexNumber, int flags)
        {
            /* check for validity */
            if (!isValid())
                printInvalidContentItemMessage("Rendering", this);
            /* declare hyperlink target */
            if (ReferenceTarget)
            {
                string attrName = Convert.ToBoolean(flags & DSRTypes.HF_XHTML11Compatibility) ? "id" : "name";
                string closeElm = Convert.ToBoolean(flags & DSRTypes.HF_XHTML11Compatibility) ? " /" : "></a";
                docStream.Append("<a ");
                docStream.Append(attrName);
                docStream.Append("=\"content_item_");
                docStream.Append(getNodeID());
                docStream.Append("\"");
                docStream.Append(closeElm);
                docStream.Append(">");
                docStream.AppendLine();
            }
            /* render content item */
            E_Condition result = renderHTMLContentItem(ref docStream, ref annexStream, nestingLevel, ref annexNumber, flags);
            /* render child nodes */
            if (result.good())
                result = renderHTMLChildNodes(ref docStream, ref annexStream, nestingLevel, ref annexNumber, flags | HF_renderItemsSeparately);
            else
                printContentItemErrorMessage("Rendering", result, this);
            return result;
        }

        /// <summary>
        /// check whether content item is digitally signed. A content item is signed if the DigitalSignaturesSequence exists. This sequence is read
        /// from the dataset if present and the 'signature' flag for the 'read' method is turned on.
        /// </summary>
        /// <returns>true if content item is signed, false otherwise </returns>
        public bool isSigned()
        {
            return (DigitalSignatures.Count > 0);
        }

        /// <summary>
        /// check whether content item is marked. Use method 'setMark' to mark and unmark the current content item.
        /// Pointers to the DICOM dataset/item of marked content items are added to the optional
        /// stack when calling the 'write' method.  This mechanism can e.g. be used to digitally
        /// sign particular content items.
        /// </summary>
        /// <returns> true if content item is marked, false otherwise </returns>
        public bool isMarked()
        {
            return MarkFlag;
        }

        /// <summary>
        /// mark/unmark the current content item. See explanation for method 'isMarked' for details.
        /// </summary>
        /// <param name="flag"></param>
        public void setMark(bool flag)
        {
            MarkFlag = flag;
        }

        /// <summary>
        /// check whether the current content item is target of a by-reference relationship.
        /// </summary>
        /// <returns> true if the content item is target, false otherwise </returns>
        public bool isReferenceTarget()
        {
            return ReferenceTarget;
        }

        /// <summary>
        /// specify whether the current content item is target of a by-reference relationship.
        /// </summary>
        /// <param name="isTarget"></param>
        public void setReferenceTarget(bool isTarget = true)
        {
            ReferenceTarget = isTarget;
        }

        /// <summary>
        /// check whether the current content item has any children.
        /// </summary>
        /// <returns> true if there are any child nodes, false otherwise </returns>
        public bool hasChildNodes()
        {
            return (Down != null);
        }

        /// <summary>
        /// check whether the current content item has any siblings.
        /// </summary>
        /// <returns> true if there are any sibling nodes, false otherwise </returns>
        public bool hasSiblingNodes()
        {
            return (Prev != null) || (Next != null);
        }

        /// <summary>
        /// get ID of the current tree node.
        /// </summary>
        /// <returns> ID of the current tree node (should never be 0) </returns>
        public int getNodeID()
        {
            return Ident;
        }

        /// <summary>
        /// get relationship type of the current content item.
        /// </summary>
        /// <returns> relationship type of the current content item (might be RT_invalid) </returns>
        public E_RelationshipType getRelationshipType()
        {
            return RelationshipType;
        }

        /// <summary>
        /// get value type of the current content item.
        /// </summary>
        /// <returns> value type of the current content item (might be VT_invalid) </returns>
        public E_ValueType getValueType()
        {
            return ValueType;
        }

        /// <summary>
        /// get reference to the concept name.
        /// </summary>
        /// <returns> reference to the concept name (code, might be empty/invalid) </returns>
        public DSRCodedEntryValue getConceptName()
        {
            return ConceptName;
        }

        /// <summary>
        /// get copy of the concept name.
        /// Code describing the concept represented by this content item.  Also conveys the value of document title and section headings in documents.
        /// </summary>
        /// <param name="conceptName"></param>
        /// <returns> status, EC_Normal if successful, an error code otherwise </returns>
        public virtual E_Condition getConceptName(ref DSRCodedEntryValue conceptName)
        {
            conceptName = ConceptName;
            return E_Condition.EC_Normal;
        }

        /// <summary>
        /// set the concept name.
        /// Code describing the concept represented by this content item. Also conveys the value of document title and section headings in documents.
        /// If the new code is invalid the current one is not replaced. An empty code can be used to clear the current concept name.
        /// </summary>
        /// <param name="conceptName"></param>
        /// <returns> status, EC_Normal if successful, an error code otherwise </returns>
        public virtual E_Condition setConceptName(ref DSRCodedEntryValue conceptName)
        {
            E_Condition result = E_Condition.EC_IllegalParameter;
            /* check for valid code */
            if (conceptName.isValid() || conceptName.isEmpty())
            {
                ConceptName = conceptName;
                result = E_Condition.EC_Normal;
            }
            return result;
        }

        /// <summary>
        /// get observation date time.
        /// This is the date and time on which this content item was completed. Might be empty
        /// if the date and time do not differ from the content date and time, see DSRDocument.
        /// </summary>
        /// <returns> observation date and time of current content item (might be empty/invalid) </returns>
        public virtual string getObservationDateTime()
        {
            return ObservationDateTime;
        }

        /// <summary>
        /// set observation date time.
        /// This is the date and time on which this content item was completed.  Might be empty
        /// if the date and time do not differ from the content date and time, see DSRDocument.
        /// Please use the correct DICOM format (YYYYMMDDHHMMSS) or an empty string to clear
        /// the current value.  Currently no check is performed on the parameter value!
        /// </summary>
        /// <param name="observationDateTime"></param>
        /// <returns> status, EC_Normal if successful, an error code otherwise </returns>
        public virtual E_Condition setObservationDateTime(string observationDateTime)
        {
            /* might add a check for proper DateTime format */
            ObservationDateTime = observationDateTime;
            return E_Condition.EC_Normal;
        }

        /// <summary>
        /// get template identifier and mapping resource. This value pair identifies the template that was used to create this content item
        /// (and its children). According to the DICOM standard it is "required if a template
        /// was used to define the content of this Item, and the template consists of a single
        /// CONTAINER with nested content, and it is the outermost invocation of a set of
        /// nested templates that start with the same CONTAINER." However, this condition is
        /// currently not checked. The identification is valid if both values are either present(non-empty) or absent (empty).
        /// </summary>
        /// <param name="templateIdentifier"></param>
        /// <param name="mappingResource"></param>
        /// <returns> status, EC_Normal if successful, an error code otherwise </returns>
        public virtual E_Condition getTemplateIdentification(ref string templateIdentifier, ref string mappingResource)
        {
            E_Condition result = E_Condition.SR_EC_InvalidValue;
            /* check for valid value pair */
            if ((TemplateIdentifier == string.Empty && MappingResource == string.Empty) ||
                (TemplateIdentifier != string.Empty && MappingResource != string.Empty))
            {
                templateIdentifier = TemplateIdentifier;
                mappingResource = MappingResource;
                result = E_Condition.EC_Normal;
            }
            return result;
        }

        /// <summary>
        /// set template identifier and mapping resource. The identification is valid if both values are either present (non-empty) or absent
        /// (empty). See getTemplateIdentification() for details.
        /// </summary>
        /// <param name="templateIdentifier"></param>
        /// <param name="mappingResource"></param>
        /// <returns> status, EC_Normal if successful, an error code otherwise </returns>
        public virtual E_Condition setTemplateIdentification(ref string templateIdentifier, ref string mappingResource)
        {
            E_Condition result = E_Condition.EC_IllegalParameter;
            /* check for valid value pair */
            if ((templateIdentifier == string.Empty && mappingResource == string.Empty) ||
                (templateIdentifier != string.Empty && mappingResource != string.Empty))
            {
                TemplateIdentifier = templateIdentifier;
                MappingResource = mappingResource;
                result = E_Condition.EC_Normal;
            }
            return result;
        }

        /// <summary>
        /// remove digital signatures from content item. This method clears the MACParametersSequence and
        /// the DigitalSignaturesSequence for the current content item which have been filled during reading.
         /// </summary>
        public void removeSignatures()
        {
            MACParameters = null;
            DigitalSignatures = null;
        }

        protected DSRCodedEntryValue getConceptNamePtr()
        {
            return ConceptName;
        }

        /// <summary>
        /// create a new node and append it to the current one.
        /// </summary>
        /// <param name="previousNode"></param>
        /// <param name="relationshipType"></param>
        /// <param name="valueType"></param>
        /// <param name="constraintChecker"></param>
        /// <returns> status, EC_Normal if successful, an error code otherwise </returns>
        protected E_Condition createAndAppendNewNode(ref DSRDocumentTreeNode previousNode,
                                       E_RelationshipType relationshipType,
                                       E_ValueType valueType,
                                       DSRIODConstraintChecker constraintChecker = null)
        {
            E_Condition result = E_Condition.EC_Normal;
            /* do not check by-reference relationships here, will be done later (after complete reading) */
            if ((relationshipType == E_RelationshipType.RT_unknown) || ((relationshipType != E_RelationshipType.RT_invalid) && ((valueType == E_ValueType.VT_byReference) ||
        (constraintChecker == null) || constraintChecker.checkContentRelationship(ValueType, relationshipType, valueType))))
            {
                DSRDocumentTreeNode node = createDocumentTreeNode(relationshipType, valueType);
                if (node != null)
                {
                    /* first child node */
                    if (previousNode == null)
                        Down = node;
                    else
                    {
                        /* new sibling */
                        previousNode.Next = node;
                        node.Prev = previousNode;
                    }
                    /* store new node for the next time */
                    previousNode = node;
                }
                else
                {
                    if (valueType == E_ValueType.VT_invalid)
                        result = E_Condition.SR_EC_UnknownValueType;
                    else
                        result = E_Condition.EC_MemoryExhausted;
                }
            }
            else
            {
                /* summarize what went wrong */
                if (valueType == E_ValueType.VT_invalid)
                    result = E_Condition.SR_EC_UnknownValueType;
                else if (relationshipType == E_RelationshipType.RT_invalid)
                    result = E_Condition.SR_EC_UnknownRelationshipType;
                else
                    result = E_Condition.SR_EC_InvalidByValueRelationship;
            }

            return result;
        }

        /// <summary>
        /// read content item (value) from dataset. This method does nothing for this base class, 
        /// but derived classes overwrite it to read the contents according to their value type.
        /// </summary>
        /// <param name="dataset"></param>
        /// <returns> status, EC_Normal if successful, an error code otherwise </returns>
        protected virtual E_Condition readContentItem(ref DicomAttributeCollection dataset)
        {
            /* no content to read */
            return E_Condition.EC_Normal;
        }

        /// <summary>
        /// write content item (value) to dataset. This method does nothing for this base class, 
        /// but derived classes overwrite it to read the contents according to their value type.
        /// </summary>
        /// <param name="dataset"></param>
        /// <returns> status, EC_Normal if successful, an error code otherwise </returns>
        protected virtual E_Condition writeContentItem(DicomAttributeCollection dataset)
        {
            /* no content to insert */
            return E_Condition.EC_Normal;
        }

        /// <summary>
        /// read content item specific XML data.This method does nothing for this base class, 
        /// but derived classes overwrite it to read the contents according to their value type.
        /// </summary>
        /// <param name="dataset"></param>
        /// <param name="cursor"></param>
        /// <returns> status, EC_Normal if successful, an error code otherwise </returns>
        protected virtual E_Condition readXMLContentItem(ref DSRXMLDocument dataset, DSRXMLCursor cursor)
        {
            return E_Condition.EC_IllegalCall;
        }

        /// <summary>
        /// render content item (value) in HTML/XHTML format. This method does nothing for this base class, 
        /// but derived classes overwrite it to render the contents according to their value type.
        /// </summary>
        /// <param name="docStream"></param>
        /// <param name="annexStream"></param>
        /// <param name="nestingLevel"></param>
        /// <param name="annexNumber"></param>
        /// <param name="flags"></param>
        /// <returns> status, EC_Normal if successful, an error code otherwise </returns>
        protected virtual E_Condition renderHTMLContentItem(ref StringBuilder docStream, ref StringBuilder annexStream, int nestingLevel, ref int annexNumber, int flags)
        {
            /* no content to render */
            return E_Condition.EC_Normal;
        }

        /// <summary>
        /// write common item start (XML tag).
        /// </summary>
        /// <param name="stream"></param>
        /// <param name="flags"></param>
        /// <param name="closingBracket"></param>
        protected void writeXMLItemStart(ref StringBuilder stream, int flags, bool closingBracket = false)
        {
            /* write optional template identification */
            if (Convert.ToBoolean(flags & XF_writeTemplateIdentification) && Convert.ToBoolean(flags & XF_templateElementEnclosesItems))
            {
                if (TemplateIdentifier != string.Empty && MappingResource != string.Empty)
                {
                    stream.Append("<template resource=\"");
                    stream.Append(MappingResource);
                    stream.Append("\" tid=\"");
                    stream.Append(TemplateIdentifier);
                    stream.Append("\">");
                    stream.AppendLine();
                }
            }
            /* write content item */
            if (Convert.ToBoolean(flags & XF_valueTypeAsAttribute))
            {
                stream.Append("<item");
                if (ValueType != E_ValueType.VT_byReference)
                {
                    stream.Append(" valType=\"");
                    stream.Append(valueTypeToDefinedTerm(ValueType));
                    stream.Append("\"");
                }
            }
            else
            {
                stream.Append("<");
                stream.Append(valueTypeToXMLTagName(ValueType));
            }
            if ((RelationshipType != E_RelationshipType.RT_isRoot) && Convert.ToBoolean(flags & XF_relationshipTypeAsAttribute))
            {
                stream.Append( " relType=\"");
                stream.Append(relationshipTypeToDefinedTerm(RelationshipType));
                stream.Append("\"");
            }
            if (ReferenceTarget || Convert.ToBoolean(flags & XF_alwaysWriteItemIdentifier))
            {
                stream.Append(" id=\"");
                stream.Append(getNodeID());
                stream.Append("\"");
            }
            if (closingBracket)
            {
                stream.Append(">");
                stream.AppendLine();
            }
        }

        /// <summary>
        /// write  common item start (XML tag).
        /// </summary>
        /// <param name="stream"></param>
        /// <param name="flags"></param>
        protected void writeXMLItemEnd(ref StringBuilder stream, int flags)
        {
            /* close content item */
            if (Convert.ToBoolean(flags & XF_valueTypeAsAttribute))
            {
                stream.Append("</item>");
                stream.AppendLine();
            }
            else
            {
                stream.Append("</");
                stream.Append(valueTypeToXMLTagName(ValueType));
                stream.Append(">");
                stream.AppendLine();
            }
            /* close optional template identification */
            if (Convert.ToBoolean(flags & XF_writeTemplateIdentification) && Convert.ToBoolean(flags & XF_templateElementEnclosesItems))
            {
                if (TemplateIdentifier != string.Empty && MappingResource != string.Empty)
                {
                    stream.Append("</template>");
                    stream.AppendLine();
                }
            }
        }

        /// <summary>
        /// read SR document content module.
        /// </summary>
        /// <param name="dataset"></param>
        /// <param name="constraintChecker"></param>
        /// <param name="flags"></param>
        /// <returns> status, EC_Normal if successful, an error code otherwise </returns>
        protected E_Condition readSRDocumentContentModule(DicomAttributeCollection dataset, DSRIODConstraintChecker constraintChecker, int flags)
        {
            E_Condition result = E_Condition.EC_Normal;
            /* read DocumentRelationshipMacro */
            result = readDocumentRelationshipMacro(dataset, constraintChecker, "1" /*posString*/, flags);
            /* read DocumentContentMacro */
            if (result.good())
            {
                result = readDocumentContentMacro(dataset, "1" /*posString*/, flags);
            }

            return result;
        }

        /// <summary>
        /// write SR document content module.
        /// </summary>
        /// <param name="dataset"></param>
        /// <param name="markedItems"></param>
        /// <returns> status, EC_Normal if successful, an error code otherwise </returns>
        protected E_Condition writeSRDocumentContentModule(ref DicomAttributeCollection dataset, Stack<DicomAttributeCollection> markedItems)
        {
            E_Condition result = E_Condition.EC_Normal;
            /* write DocumentRelationshipMacro */
            result = writeDocumentRelationshipMacro(dataset, markedItems);
            /* write DocumentContentMacro */
            if (result.good())
                result = writeDocumentContentMacro(dataset);
            return result;
        }

        /// <summary>
        /// read document relationship macro.
        /// </summary>
        /// <param name="dataset"></param>
        /// <param name="constraintChecker"></param>
        /// <param name="posString"></param>
        /// <param name="flags"></param>
        /// <returns> status, EC_Normal if successful, an error code otherwise </returns>
        protected E_Condition readDocumentRelationshipMacro(DicomAttributeCollection dataset, DSRIODConstraintChecker constraintChecker, 
                                                    string posString, int flags)
        {
            E_Condition result = E_Condition.EC_Normal;
            /* read digital signatures sequences (optional) */
            if (Convert.ToBoolean(flags & RF_readDigitalSignatures))
            {
                getElementFromDataset(dataset, ref MACParameters);
                getElementFromDataset(dataset, ref DigitalSignatures);
            }
            /* read ObservationDateTime (conditional) */
            getAndCheckStringValueFromDataset(dataset, getDicomAttribute(DicomTags.ObservationDateTime), ref ObservationDateTime, "1", "1C");
            /* determine template identifier expected for this document */
            string rootTemplateIdentifier = constraintChecker.getRootTemplateIdentifier();
            string expectedTemplateIdentifier = (constraintChecker != null) ? (!string.IsNullOrEmpty(rootTemplateIdentifier) ? rootTemplateIdentifier  : "") : "";
            /* read ContentTemplateSequence (conditional) */
            DicomAttribute ditem = dataset[DicomTags.ContentTemplateSequence];
            if (!ditem.IsEmpty && !ditem.IsNull)
            {
                DicomSequenceItem sequence = ((DicomSequenceItem[])ditem.Values)[0];
                getAndCheckStringValueFromDataset(sequence, getDicomAttribute(DicomTags.MappingResource), ref MappingResource, "1", "1", "ContentTemplateSequence");
                getAndCheckStringValueFromDataset(sequence, getDicomAttribute(DicomTags.TemplateIdentifier), ref TemplateIdentifier, "1", "1", "ContentTemplateSequence");
                if (!string.IsNullOrEmpty(expectedTemplateIdentifier))
                {
                     /* check for DICOM Content Mapping Resource */
                    if (MappingResource == "DCMR")
                    {
                        /* compare with expected TID */
                        if (TemplateIdentifier != expectedTemplateIdentifier)
                        {
                            //DCMSR_WARN("Incorrect value for TemplateIdentifier ("
                            //    << ((TemplateIdentifier.empty()) ? "<empty>" : TemplateIdentifier) << "), "
                            //    << expectedTemplateIdentifier << " expected");
                            //TOFO: Log
                        }
                    }
                    else if (!string.IsNullOrEmpty(MappingResource))
                    {
                        printUnknownValueWarningMessage("MappingResource", MappingResource);
                    }
                }
            }
            /* only check template identifier on dataset level (root node) */
            else if (/*(dataset == EVR_dataset) && */!string.IsNullOrEmpty(expectedTemplateIdentifier))
            {
                //DCMSR_WARN("ContentTemplateSequence missing or empty, TemplateIdentifier "
                //    << expectedTemplateIdentifier
                    /* DICOM Content Mapping Resource is currently hard-coded (see above) */
                //    << " (DCMR) expected");
            }

            /* read ContentSequence */
            if (result.good())
            {
                result = readContentSequence(dataset, constraintChecker, posString, flags);
            }

            return result;
        }

        /// <summary>
        /// write document relationship macro.
        /// </summary>
        /// <param name="dataset"></param>
        /// <param name="markedItems"></param>
        /// <returns> status, EC_Normal if successful, an error code otherwise </returns>
        protected E_Condition writeDocumentRelationshipMacro(DicomAttributeCollection dataset, Stack<DicomAttributeCollection> markedItems)
        {
            E_Condition result = E_Condition.EC_Normal;
            /* write digital signatures sequences (optional) */
            if (MACParameters.Count > 0)
                addElementToDataset(dataset, MACParameters, "1-n", "3", "SOPCommonModule");
            if (DigitalSignatures.Count > 0)
            {
                addElementToDataset(dataset, DigitalSignatures, "1-n", "3", "SOPCommonModule");
                //TODO LOG
                //DCMSR_WARN("Writing possibly incorrect digital signature - same as read from dataset");
            }
            /* add to mark stack */
            if (MarkFlag && (markedItems != null))
                markedItems.Push(dataset);
            /* write ObservationDateTime (conditional) */
            result = putStringValueToDataset(dataset, getDicomAttribute(DicomTags.ObservationDateTime), ObservationDateTime, false /*allowEmpty*/);
            /* write ContentTemplateSequence (conditional) */
            if (result.good())
            {
                if (TemplateIdentifier != string.Empty && MappingResource != string.Empty)
                {
                    DicomSequenceItem ditem = new DicomSequenceItem();
                    /* create sequence with a single item */

                    //TODO:DSRDocumentTreeNode.findOrCreateSequenceItem
                    //dataset.findOrCreateSequenceItem(getDicomAttribute(DicomTags.ContentTemplateSequence), ditem, 0 /*position*/);

                    if (result.good())
                    {
                        /* write item data */
                        putStringValueToDataset(ditem, getDicomAttribute(DicomTags.TemplateIdentifier), TemplateIdentifier);
                        putStringValueToDataset(ditem, getDicomAttribute(DicomTags.MappingResource), MappingResource);
                    }
                }
            }
            /* write ContentSequence */
            if (result.good())
                result = writeContentSequence(ref dataset, markedItems);
            return result;
        }

        /// <summary>
        /// read document content macro.
        /// </summary>
        /// <param name="dataset"></param>
        /// <param name="posString"></param>
        /// <param name="flags"></param>
        /// <returns> status, EC_Normal if successful, an error code otherwise </returns>
        protected E_Condition readDocumentContentMacro(DicomAttributeCollection dataset, string posString, int flags)
        {
            E_Condition result = E_Condition.EC_Normal;
            /* skip reading ValueType, already done somewhere else */

            DicomAttribute atri = getDicomAttribute(DicomTags.ConceptNameCodeSequence);

            /* read ConceptNameCodeSequence */
            if (RelationshipType == E_RelationshipType.RT_isRoot)
            {
                /* the concept name is required for the root container */
                result = ConceptName.readSequence(ref dataset, ref atri, "1" /*type*/);
            }
            else
            {
                /* the concept name might be empty for all other content items */
                ConceptName.readSequence(ref dataset, ref atri, "1C" /*type*/);
            }
            if (result.good() || Convert.ToBoolean(flags & RF_ignoreContentItemErrors))
            {
                /* read ContentItem (depending on ValueType) */
                result = readContentItem(ref dataset);
            }
            /* check for validity, after reading */
            if (result.bad() || !isValid())
            {
                printInvalidContentItemMessage("Reading", this, posString);
                /* ignore content item reading/parsing error if flag is set */
                if (Convert.ToBoolean(flags & RF_ignoreContentItemErrors))
                    result = E_Condition.EC_Normal;
                /* content item is not valid */
                else if (result.good())
                    result = E_Condition.SR_EC_InvalidValue;
            }
            return result;
        }

        /// <summary>
        /// write document content macro.
        /// </summary>
        /// <param name="dataset"></param>
        /// <returns> status, EC_Normal if successful, an error code otherwise </returns>
        protected E_Condition writeDocumentContentMacro(DicomAttributeCollection dataset)
        {
            E_Condition result = E_Condition.EC_Normal;
            /* write ValueType */
            result = putStringValueToDataset(dataset, getDicomAttribute(DicomTags.ValueType), valueTypeToDefinedTerm(ValueType));
            /* write ConceptNameCodeSequence */
            if (result.good())
            {
                if (ConceptName.isValid())
                {
                    DicomAttribute atri = getDicomAttribute(DicomTags.ConceptNameCodeSequence);
                    result = ConceptName.writeSequence(ref dataset, ref atri);
                }
            }
            if (result.good())
            {
                /* check for validity, before writing */
                if (!isValid())
                    printInvalidContentItemMessage("Writing", this);
                /* write ContentItem (depending on ValueType) */
                result = writeContentItem(dataset);
            }
            return result;
        }

        /// <summary>
        /// read content sequence.
        /// </summary>
        /// <param name="dataset"></param>
        /// <param name="constraintChecker"></param>
        /// <param name="posString"></param>
        /// <param name="flags"></param>
        /// <returns> status, EC_Normal if successful, an error code otherwise </returns>
        protected E_Condition readContentSequence(DicomAttributeCollection dataset, DSRIODConstraintChecker constraintChecker, 
                                                        string posString, int flags)
        {
            if(dataset == null)
            {
                return E_Condition.EC_IllegalParameter;
            }

            E_Condition result = E_Condition.EC_Normal;
            /* read ContentSequence (might be absent or empty) */
            DicomAttribute attribute = getDicomAttribute(DicomTags.ContentSequence);
            getElementFromDataset(dataset, ref attribute);
            if (!attribute.IsEmpty && !attribute.IsNull)
            {
                string tmpString = string.Empty;
                E_ValueType valueType =  E_ValueType.VT_invalid;
                E_RelationshipType relationshipType = E_RelationshipType.RT_invalid;
                /* important: NULL indicates first child node */
                DSRDocumentTreeNode node = null;
                DicomAttributeCollection ditem = null;
                for (int i = 0; i < attribute.Count; i++)
                {
                    ditem = ((DicomSequenceItem[])attribute.Values)[i];
                    if (ditem != null)
                    {
                        DSRDocumentTreeNode newNode = null;
                        /* create current location string */
                        string buffer = string.Empty;
                        string location = posString;
                        if (!string.IsNullOrEmpty(location))
                        {
                            location += ".";
                        }
                        location += numberToString(i + 1, buffer);
                        if (Convert.ToBoolean(flags & RF_showCurrentlyProcessedItem))
                        {
                            //DCMSR_INFO("Processing content item " << location);
                        }
                        /* read RelationshipType */
                        result = getAndCheckStringValueFromDataset(ditem, getDicomAttribute(DicomTags.RelationshipType), ref tmpString, "1", "1", "content item");
                        if (result.good() || Convert.ToBoolean(flags & RF_acceptUnknownRelationshipType))
                        {
                            relationshipType = definedTermToRelationshipType(tmpString);
                            /* check relationship type */
                            if (relationshipType == E_RelationshipType.RT_invalid)
                            {
                                printUnknownValueWarningMessage("RelationshipType", tmpString);
                                if (Convert.ToBoolean(flags & RF_acceptUnknownRelationshipType))
                                {
                                    relationshipType = E_RelationshipType.RT_unknown;
                                }
                            }

                            /* check for by-reference relationship */
                            DicomAttribute referencedContentItemIdentifier = getDicomAttribute(DicomTags.ReferencedContentItemIdentifier);
                            if (getAndCheckElementFromDataset(ditem, ref referencedContentItemIdentifier, "1-n", "1C", "content item").good())
                            {
                                /* create new node (by-reference, no constraint checker required) */
                                result = createAndAppendNewNode(ref node, relationshipType, E_ValueType.VT_byReference);
                                /* read ReferencedContentItemIdentifier (again) */
                                if (result.good())
                                {
                                    newNode = node;
                                    result = node.readContentItem(ref ditem);
                                }
                            }
                            else
                            {
                                /* read ValueType (from DocumentContentMacro) - required to create new node */
                                result = getAndCheckStringValueFromDataset(ditem, getDicomAttribute(DicomTags.ValueType), ref tmpString, "1", "1", "content item");
                                if (result.good())
                                {
                                    /* read by-value relationship */
                                    valueType = definedTermToValueType(tmpString);
                                    /* check value type */
                                    if (valueType != E_ValueType.VT_invalid)
                                    {
                                        /* create new node (by-value) */
                                        result = createAndAppendNewNode(ref node, relationshipType, valueType, Convert.ToBoolean(flags & RF_ignoreRelationshipConstraints) ? null : constraintChecker);
                                        /* read RelationshipMacro */
                                        if (result.good())
                                        {
                                            newNode = node;
                                            result = node.readDocumentRelationshipMacro(ditem, constraintChecker, location, flags);
                                            /* read DocumentContentMacro */
                                            if (result.good())
                                            {
                                                result = node.readDocumentContentMacro(ditem, location, flags);
                                            }
                                        }
                                        else
                                        {
                                            /* create new node failed */

                                            /* determine document type */
                                            //const E_DocumentType documentType = (constraintChecker != null) ? constraintChecker.getDocumentType() : E_DocumentType.DT_invalid;
                                            //DCMSR_ERROR("Cannot add \"" << relationshipTypeToReadableName(relationshipType) << " "
                                            //    << valueTypeToDefinedTerm(valueType /*target item*/) << "\" to "
                                            //    << valueTypeToDefinedTerm(ValueType /*source item*/) << " in "
                                            //    << documentTypeToReadableName(documentType));
                                        }
                                    }
                                    else
                                    {
                                        /* unknown/unsupported value type */
                                        printUnknownValueWarningMessage("ValueType", tmpString);
                                        result = E_Condition.SR_EC_UnknownValueType;
                                    }
                                }
                            }
                        }

                        /* check for any errors */
                        if (result.good())
                        {
                            printContentItemErrorMessage("Reading", result, newNode, location);
                            /* print current data set (item) that caused the error */
                            //DCMSR_DEBUG(OFString(31, '-') << " DICOM DATA SET " << OFString(31, '-') << OFendl
                            //<< DcmObject::PrintHelper(*ditem, 0, 1) << OFString(78, '-'));
                        }
                    }
                    else
                    {
                        result = E_Condition.SR_EC_InvalidDocumentTree;
                    }
                }

                /* skipping complete sub-tree if flag is set */
                if (result.bad() && Convert.ToBoolean(flags & RF_skipInvalidContentItems))
                {
                    printInvalidContentItemMessage("Skipping", node);
                    result = E_Condition.EC_Normal;
                }
            }

            return result;
        }

        /// <summary>
        /// write content sequence.
        /// </summary>
        /// <param name="dataset"></param>
        /// <param name="markedItems"></param>
        /// <returns> status, EC_Normal if successful, an error code otherwise </returns>
        protected E_Condition writeContentSequence(ref DicomAttributeCollection dataset, Stack<DicomAttributeCollection> markedItems)
        {
            E_Condition result = E_Condition.EC_Normal;
            /* goto first child of current node */
            DSRTreeNodeCursor cursor = new DSRTreeNodeCursor(Down);
            if (cursor.isValid())
            {
                /* write ContentSequence */
                DicomAttribute dseq = getDicomAttribute(DicomTags.ContentSequence);
                if (dseq != null)
                {
                    DicomSequenceItem ditem = null;
                    DSRDocumentTreeNode node = new DSRDocumentTreeNode();
                    do {        /* for all child nodes */
                        node = ((DSRDocumentTreeNode)cursor.getNode());
                        if (node != null)
                        {
                            ditem = new DicomSequenceItem();
                            if (ditem != null)
                            {
                                /* write RelationshipType */
                                result = putStringValueToDataset(ditem, getDicomAttribute(DicomTags.RelationshipType), relationshipTypeToDefinedTerm(node.getRelationshipType()));
                                /* check for by-reference relationship */
                                if (node.getValueType() == E_ValueType.VT_byReference)
                                {
                                    /* write ReferencedContentItemIdentifier */
                                    if (result.good())
                                        result = node.writeContentItem(ditem);
                                } else {    // by-value
                                    /* write RelationshipMacro */
                                    if (result.good())
                                        result = node.writeDocumentRelationshipMacro(ditem, markedItems);
                                    /* write DocumentContentMacro */
                                    if (result.good())
                                        node.writeDocumentContentMacro(ditem);
                                }
                                /* check for any errors */
                                if (result.bad())
                                    printContentItemErrorMessage("Writing", result, node);
                                /* insert item into sequence */
                                if (result.good())
                                {
                                    dseq.AddSequenceItem(ditem);
                                }
                                else
                                    ditem = null;
                            } else
                                result = E_Condition.EC_MemoryExhausted;
                        } else
                            result = E_Condition.SR_EC_InvalidDocumentTree;
                    } while (result.good() && Convert.ToBoolean(cursor.gotoNext()));
                    if (result.good())
                    {
                        dataset[dseq.Tag.TagValue] = dseq;                        
                    }
                    if (result.bad())
                        dseq = null;
                } 
                else
                    result = E_Condition.EC_MemoryExhausted;
            }
            return result;
        }

        /// <summary>
        /// render concept name in HTML/XHTML format. If the optional observation datetime field is valid (not empty) it is also rendered.
        /// </summary>
        /// <param name="docStream"></param>
        /// <param name="flags"></param>
        /// <returns> status, EC_Normal if successful, an error code otherwise </returns>
        protected E_Condition renderHTMLConceptName(ref StringBuilder docStream, int flags)
        {
            if (!Convert.ToBoolean(flags & HF_renderItemInline) && Convert.ToBoolean(flags & HF_renderItemsSeparately))
            {
                string lineBreak = Convert.ToBoolean(flags & DSRTypes.HF_renderSectionTitlesInline) ? " " :
                                        Convert.ToBoolean(flags & DSRTypes.HF_XHTML11Compatibility) ? "<br />" : "<br>";
                /* flag indicating whether line is empty or not */
                bool writeLine = false;
                if (!string.IsNullOrEmpty(ConceptName.getCodeMeaning()))
                {
                    docStream.Append("<b>");
                    /* render ConceptName & Code (if valid) */
                    ConceptName.renderHTML(ref docStream, flags, Convert.ToBoolean(flags & HF_renderConceptNameCodes) && ConceptName.isValid() /*fullCode*/);
                    docStream.Append(":</b>");
                    writeLine = true;
                }
                else if (Convert.ToBoolean(flags & HF_currentlyInsideAnnex))
                {
                    docStream.Append("<b>");
                    /* render ValueType only */
                    docStream.Append(valueTypeToReadableName(ValueType));
                    docStream.Append(":</b>");
                    writeLine = true;
                }
                /* render optional observation datetime */
                if (!string.IsNullOrEmpty(ObservationDateTime))
                {
                    if (writeLine)
                        docStream.Append(" ");
                    string tmpString = "";
                    if (Convert.ToBoolean(flags & HF_XHTML11Compatibility))
                        docStream.Append("<span class=\"observe\">");
                    else
                        docStream.Append("<small>");
                    docStream.Append("(observed: ");
                    docStream.Append(dicomToReadableDateTime(ObservationDateTime, tmpString));
                    docStream.Append(")");
                    if (Convert.ToBoolean(flags & HF_XHTML11Compatibility))
                        docStream.Append("</span>");
                    else
                        docStream.Append("</small>");
                    writeLine = true;
                }
                if (writeLine)
                {
                    docStream.Append(lineBreak);
                    docStream.AppendLine();
                }
            }
            return E_Condition.EC_Normal;
        }

        /// <summary>
        ///  render child nodes in HTML/XHTML format.
        /// </summary>
        /// <param name="docStream"></param>
        /// <param name="annexStream"></param>
        /// <param name="nestingLevel"></param>
        /// <param name="annexNumber"></param>
        /// <param name="flags"></param>
        /// <returns> status, EC_Normal if successful, an error code otherwise </returns>
        protected E_Condition renderHTMLChildNodes(ref StringBuilder docStream, ref StringBuilder annexStream, int nestingLevel, ref int annexNumber, int flags)
        {
            E_Condition result = E_Condition.EC_Normal;
            /* goto first child of current node */
            DSRTreeNodeCursor cursor = new DSRTreeNodeCursor(Down);
            if (cursor.isValid())
            {
                /* flag used to format the relationship reference texts */
                bool paragraphFlag = (flags & HF_createFootnoteReferences) > 0;
                /* local version of flags */
                int newFlags = flags;
                /* footnote counter */
                int footnoteNumber = 1;
                /* create memory output stream for the temporal document */
                StringBuilder tempDocStream = new StringBuilder();
                DSRDocumentTreeNode node = new DSRDocumentTreeNode();
                do {        /* for all child nodes */
                    node = ((DSRDocumentTreeNode)cursor.getNode());
                    if (node != null)
                    {
                        /* set/reset flag for footnote creation*/
                        newFlags &= ~HF_createFootnoteReferences;
                        if (!Convert.ToBoolean(flags & HF_renderItemsSeparately) && node.hasChildNodes() && (node.getValueType() != E_ValueType.VT_Container))
                            newFlags |= HF_createFootnoteReferences;
                        /* render (optional) reference to annex */
                        string relationshipText = "";
                        if (!string.IsNullOrEmpty(getRelationshipText(node.getRelationshipType(), ref relationshipText, flags)))
                        {
                            if (paragraphFlag)
                            {
                                /* inside paragraph: line break */
                                if (Convert.ToBoolean(flags & HF_XHTML11Compatibility))
                                {
                                    docStream.Append("<br />");
                                    docStream.AppendLine();
                                }
                                else
                                {
                                    docStream.Append("<br>");
                                    docStream.AppendLine();
                                }
                            } 
                            else 
                            {
                                /* open paragraph */
                                if (Convert.ToBoolean(flags & HF_XHTML11Compatibility))
                                {
                                    docStream.Append("<div class=\"small\">");
                                    docStream.AppendLine();
                                    docStream.Append("<p>");
                                    docStream.AppendLine();
                                } 
                                else
                                {
                                    docStream.Append("<p>");
                                    docStream.AppendLine();
                                    docStream.Append("<small>");
                                    docStream.AppendLine();
                                }
                                paragraphFlag = true;
                            }
                            if (Convert.ToBoolean(newFlags & HF_XHTML11Compatibility))
                            {
                                docStream.Append("<span class=\"relation\">");
                                docStream.Append(relationshipText);
                                docStream.Append("</span>: ");
                            }
                            else if (Convert.ToBoolean(flags & DSRTypes.HF_HTML32Compatibility))
                            {
                                docStream.Append("<u>");
                                docStream.Append(relationshipText);
                                docStream.Append("</u>: ");
                            }
                            else /* HTML 4.01 */
                            {
                                docStream.Append("<span class=\"under\">");
                                docStream.Append(relationshipText);
                                docStream.Append("</span>: ");
                            }
                            /* expand short nodes with no children inline (or depending on 'flags' all nodes) */
                            if (Convert.ToBoolean(flags & HF_alwaysExpandChildrenInline) ||
                                (!Convert.ToBoolean(flags & HF_neverExpandChildrenInline) && !node.hasChildNodes() && node.isShort(flags)))
                            {
                                if (node.getValueType() != E_ValueType.VT_byReference)
                                {
                                    /* render concept name/code or value type */
                                    if (string.IsNullOrEmpty(node.getConceptName().getCodeMeaning()))
                                    {
                                        docStream.Append(valueTypeToReadableName(node.getValueType()));
                                    }
                                    else
                                        node.getConceptName().renderHTML(ref docStream, flags, Convert.ToBoolean(flags & HF_renderConceptNameCodes) && ConceptName.isValid() /*fullCode*/);
                                    docStream.Append(" = ");
                                }
                                /* render HTML code (directly to the reference text) */
                                result = node.renderHTML(ref docStream, ref annexStream, 0 /*nesting level*/, ref annexNumber, newFlags | HF_renderItemInline);
                            } 
                            else 
                            {
                                /* render concept name or value type */
                                if (string.IsNullOrEmpty(node.getConceptName().getCodeMeaning()))
                                {
                                    docStream.Append(valueTypeToReadableName(node.getValueType()));
                                    docStream.Append(" ");
                                }
                                else
                                {
                                    docStream.Append(node.getConceptName().getCodeMeaning());
                                    docStream.Append(" ");
                                }
                                /* render annex heading and reference */
                                createHTMLAnnexEntry(docStream, annexStream, "" /*referenceText*/, ref annexNumber, newFlags);
                                if (Convert.ToBoolean(flags & HF_XHTML11Compatibility))
                                {
                                    annexStream.Append("<div class=\"para\">");
                                    annexStream.AppendLine();
                                }
                                else
                                {
                                    annexStream.Append("<div>");
                                    annexStream.AppendLine();
                                }
                                /* create memory output stream for the temporal annex */
                                StringBuilder tempAnnexStream = new StringBuilder();
                                /* render HTML code (directly to the annex) */
                                result = node.renderHTML(ref annexStream, ref tempAnnexStream, 0 /*nesting level*/, ref annexNumber, newFlags | HF_currentlyInsideAnnex);
                                annexStream.Append("</div>");
                                annexStream.AppendLine();
                                /* use empty paragraph for bottom margin */
                                if (!Convert.ToBoolean(flags & HF_XHTML11Compatibility))
                                {
                                    annexStream.Append("<p>");
                                    annexStream.AppendLine();
                                }
                                /* append temporary stream to main stream */
                                if (result.good())
                                    result = appendStream(ref annexStream, ref tempAnnexStream);
                            }
                        } else {
                            /* close paragraph */
                            if (paragraphFlag)
                            {
                                if (Convert.ToBoolean(flags & HF_XHTML11Compatibility))
                                {
                                    docStream.Append("</p>");
                                    docStream.AppendLine();
                                    docStream.Append("</div>");
                                    docStream.AppendLine();
                                }
                                else 
                                {
                                    docStream.Append("</small>");
                                    docStream.AppendLine();
                                    docStream.Append("</p>");
                                    docStream.AppendLine();
                                }
                                paragraphFlag = false;
                            }
                            /* begin new paragraph */
                            if (Convert.ToBoolean(flags & HF_renderItemsSeparately))
                            {
                                if (Convert.ToBoolean(flags & HF_XHTML11Compatibility))
                                {
                                    docStream.Append("<div class=\"para\">");
                                    docStream.AppendLine();
                                }
                                else
                                {
                                    docStream.Append("<div>"); docStream.AppendLine();
                                }
                            }
                            /* write footnote text to temporary stream */
                            if (Convert.ToBoolean(newFlags & HF_createFootnoteReferences))
                            {
                                /* render HTML code (without child nodes) */
                                result = node.renderHTMLContentItem(ref docStream, ref annexStream, 0 /*nestingLevel*/, ref annexNumber, newFlags);
                                /* create footnote numbers (individually for each child?) */
                                if (result.good())
                                {
                                    /* tags are closed automatically in 'node->renderHTMLChildNodes()' */
                                    if (Convert.ToBoolean(flags & HF_XHTML11Compatibility))
                                    {
                                        tempDocStream.Append("<div class=\"small\">");
                                        tempDocStream.AppendLine();
                                        tempDocStream.Append("<p>");
                                        tempDocStream.AppendLine();
                                    } 
                                    else 
                                    {
                                        tempDocStream.Append("<p>");
                                        tempDocStream.AppendLine();
                                        tempDocStream.Append("<small>");
                                        tempDocStream.AppendLine();
                                    }
                                    /* render footnote text and reference */
                                    createHTMLFootnote(docStream, tempDocStream, ref footnoteNumber, node.getNodeID(), flags);
                                    /* render child nodes to temporary stream */
                                    result = node.renderHTMLChildNodes(ref tempDocStream, ref annexStream, 0 /*nestingLevel*/, ref annexNumber, newFlags);
                                }
                            } else {
                                /* render HTML code (incl. child nodes)*/
                                result = node.renderHTML(ref docStream, ref annexStream, nestingLevel + 1, ref annexNumber, newFlags);
                            }
                            /* end paragraph */
                            if (Convert.ToBoolean(flags & HF_renderItemsSeparately))
                            {
                                docStream.Append("</div>");
                                docStream.AppendLine();
                                /* use empty paragraph for bottom margin */
                                if (!Convert.ToBoolean(flags & HF_XHTML11Compatibility))
                                {
                                    docStream.Append("<p>");
                                    docStream.AppendLine();
                                }
                            }
                        }
                    } else
                        result = E_Condition.SR_EC_InvalidDocumentTree;
                } while (result.good() && Convert.ToBoolean(cursor.gotoNext()));
                /* close last open paragraph (if any) */
                if (paragraphFlag)
                {
                    if (Convert.ToBoolean(flags & HF_XHTML11Compatibility))
                    {
                        docStream.Append("</p>");
                        docStream.AppendLine();
                        docStream.Append("</div>");
                        docStream.AppendLine();
                    } 
                    else
                    {
                        docStream.Append("</small>");
                        docStream.AppendLine();
                        docStream.Append("</p>");
                        docStream.AppendLine();
                    }
                }
                /* append temporary stream to main stream */
                if (result.good())
                    result = appendStream(ref docStream, ref tempDocStream);
            }
            return result;
        }

        // --- static function ---
        /// <summary>
        /// convert relationship type into a text used for HTML rendering.
        /// expanded inline or not (used for renderHTML()). This base class always returns OFTrue.
        /// </summary>
        /// <param name="relationshipType"></param>
        /// <param name="relationshipText"></param>
        /// <param name="flags"></param>
        /// <returns> reference to the 'relationshipText' string (might be empty) </returns>
        public static string getRelationshipText(E_RelationshipType relationshipType, ref string relationshipText, int flags)
        {
            switch (relationshipType)
            {
                case E_RelationshipType.RT_contains:
                    if ((flags & HF_createFootnoteReferences) != 0)
                        relationshipText = "Contains";
                    else
                        relationshipText = "";
                    break;
                case E_RelationshipType.RT_hasObsContext:
                    relationshipText = "Observation Context";
                    break;
                case E_RelationshipType.RT_hasAcqContext:
                    relationshipText = "Acquisition Context";
                    break;
                case E_RelationshipType.RT_hasConceptMod:
                    relationshipText = "Concept Modifier";
                    break;
                case E_RelationshipType.RT_hasProperties:
                    relationshipText = "Properties";
                    break;
                case E_RelationshipType.RT_inferredFrom:
                    relationshipText = "Inferred from";
                    break;
                case E_RelationshipType.RT_selectedFrom:
                    relationshipText = "Selected from";
                    break;
                default:
                    relationshipText = "";
                    break;
            }
            return relationshipText;
        }

        /// flag indicating whether the content item is marked (e.g. used for digital signatures)
        private bool MarkFlag;
        /// flag indicating whether the content item is referenced (by-reference relationship)
        private bool ReferenceTarget;

        /// relationship type to the parent node (associated DICOM VR=CS, mandatory)
        private E_RelationshipType RelationshipType;
        /// value type (associated DICOM VR=CS, mandatory)
        private E_ValueType ValueType;

        /// concept name (VR=SQ, conditional)
        private DSRCodedEntryValue ConceptName;
        /// observation date and time (VR=DT, conditional)
        private string ObservationDateTime;

        /// template identifier (VR=CS, mandatory in ContentTemplateSequence)
        private string TemplateIdentifier;
        /// mapping resource (VR=CS, mandatory in ContentTemplateSequence)
        private string MappingResource;

        /// MAC parameters sequence (VR=SQ, optional)
        private DicomAttribute /*DcmSequenceOfItems*/ MACParameters;
        /// digital signatures sequence (VR=SQ, optional)
        private DicomAttribute /*DcmSequenceOfItems*/ DigitalSignatures;
    }
}
