using ClearCanvas.Dicom;
using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;
using System.Threading.Tasks;

namespace Hydra.Dicom
{
    public class DSRDocumentTree : DSRTree
    {
        /// <summary>
        /// constructor
        /// </summary>
        public DSRDocumentTree()
        {
        }

        /// <summary>
        /// declaration of default/copy constructor
        /// </summary>
        /// <param name="theDSRDocumentTreeNode"></param>
        public DSRDocumentTree(DSRDocumentTree theDSRDocumentTree)
        {
        }

        /// <summary>
        /// constructor
        /// </summary>
        /// <param name="documentType"></param>
        public DSRDocumentTree(E_DocumentType documentType)
            : base()
        {
            DocumentType = E_DocumentType.DT_invalid;
            ConstraintChecker = null;
            /* check & set document type, create constraint checker object */
            changeDocumentType(documentType);
        }

        /// <summary>
        /// destructor
        /// </summary>
        ~DSRDocumentTree()
        {
            ConstraintChecker = null;
        }

        /// <summary>
        /// clear all member variables. The document type is not changed (e.g. set to DT_invalid).
        /// </summary>
        public override void clear()
        {
            base.clear();
        }

        /// <summary>
        /// check whether the current internal state is valid.
        /// The SR document is valid if the document type is supported, the tree is not
        /// empty the root item is a container and has the internal relationship type RT_isRoot.
        /// </summary>
        /// <returns> true if tree node is valid, false otherwise </returns>
        public virtual bool isValid()
        {
            bool result = false;
            if (isDocumentTypeSupported(DocumentType))
            {
                /* check root node */
                DSRDocumentTreeNode node = ((DSRDocumentTreeNode)getRoot());
                if (node != null)
                {
                    if ((node.getRelationshipType() == E_RelationshipType.RT_isRoot) && (node.getValueType() == E_ValueType.VT_Container))
                        result = true;
                }
            }
            return result;
        }

        /// <summary>
        /// print current SR document tree to specified output stream
        /// </summary>
        /// <param name="stream"></param>
        /// <param name="flags"></param>
        /// <returns> status, EC_Normal if successful, an error code otherwise </returns>
        public E_Condition print(ref StringBuilder stream, int flags = 0)
        {
            E_Condition result = E_Condition.EC_Normal;
            DSRTreeNodeCursor cursor = new DSRTreeNodeCursor(getRoot());
            if (cursor.isValid())
            {
                /* check and update by-reference relationships (if applicable) */
                checkByReferenceRelationships(CM_updatePositionString);
                string tmpString = "";
                int level = 0;
                DSRDocumentTreeNode node = new DSRDocumentTreeNode();
                /* iterate over all nodes */
                do {
                    node = ((DSRDocumentTreeNode)cursor.getNode());
                    if (node != null)
                    {
                        /* print node position */
                        if (Convert.ToBoolean(flags & PF_printItemPosition))
                        {
                            stream.Append(cursor.getPosition(ref tmpString));
                            stream.Append("  ");
                        }
                        else
                        {
                            /* use line identation */
                            level = cursor.getLevel();
                            if (level > 0)  // valid ?
                            {
                                string value = new string(' ', (level - 1) * 2);
                                stream.Append(value);
                            }
                                
                        }
                        /* print node content */
                        stream.Append("<");
                        result = node.print(ref stream, flags);
                        stream.Append(">");
                        if (Convert.ToBoolean(flags & PF_printTemplateIdentification))
                        {
                            /* check for template identification */
                            string templateIdentifier = "", mappingResource = "";
                            if (node.getTemplateIdentification(ref templateIdentifier, ref mappingResource).good())
                            {
                                if (templateIdentifier != string.Empty && mappingResource != string.Empty)
                                {
                                    stream.Append("  # TID ");
                                    stream.Append(templateIdentifier);
                                    stream.Append(" (");
                                    stream.Append(mappingResource);
                                    stream.Append(")");
                                }
                            }
                        }
                        stream.AppendLine();
                    } else
                        result = E_Condition.SR_EC_InvalidDocumentTree;
                } while (result.good() && Convert.ToBoolean(cursor.iterate()));
            }
            return result;
        }

        /// <summary>
        /// read SR document tree from DICOM dataset.
        /// Please note that the current document tree is also deleted if the reading fails.
        /// If the log stream is set and valid the reason for any error might be obtained from the error/warning output.
        /// </summary>
        /// <param name="dataset"></param>
        /// <param name="documentType"></param>
        /// <param name="flags"></param>
        /// <returns> status, EC_Normal if successful, an error code otherwise </returns>
        public E_Condition read(DicomAttributeCollection dataset, E_DocumentType documentType, int flags = 0)
        {
            /* clear current document tree, check & change document type */
            E_Condition result = changeDocumentType(documentType);
            if (result.good())
            {
                if (ConstraintChecker == null)
                {
                    //DCMSR_WARN("Check for relationship content constraints not yet supported");
                    //TODO: Log
                }
                else if (ConstraintChecker.isTemplateSupportRequired())
                {
                    //DCMSR_WARN("Check for template constraints not yet supported");
                    //TODO: Log
                }

                if (Convert.ToBoolean(flags & RF_showCurrentlyProcessedItem))
                {
                    //DCMSR_INFO("Processing content item 1");
                    //TODO: Log
                }

                /* first try to read value type */
                string tmpString = string.Empty;
                if (getAndCheckStringValueFromDataset(dataset, getDicomAttribute(DicomTags.ValueType), ref tmpString, "1", "1").good() ||
                    (Convert.ToBoolean(flags & RF_ignoreContentItemErrors)))
                {
                    /* root node should always be a container */
                    if (definedTermToValueType(tmpString) != E_ValueType.VT_Container)
                    {
                        if (Convert.ToBoolean(flags & RF_ignoreContentItemErrors))
                        {
                            //DCMSR_WARN("Root content item should always be a CONTAINER");
                        }
                        else
                        {
                            //DCMSR_ERROR("Root content item should always be a CONTAINER");
                            result = E_Condition.SR_EC_InvalidDocumentTree;
                        }
                    }

                    if (result.good())
                    {
                        /* ... then create corresponding document tree node */
                        DSRDocumentTreeNode node = new DSRContainerTreeNode(E_RelationshipType.RT_isRoot);
                        if (node != null)
                        {
                            /* ... insert it into the (empty) tree - checking is not required here */
                            if (Convert.ToBoolean(addNode(ref node)))
                            {
                                /* ... and let the node read the rest of the document */
                                result = node.read(dataset, ConstraintChecker, flags);
                                /* check and update by-reference relationships (if applicable) */
                                checkByReferenceRelationships(CM_updateNodeID, flags);
                            }
                            else
                            {
                                result = E_Condition.SR_EC_InvalidDocumentTree;
                            }
                        }
                        else
                        {
                            result = E_Condition.EC_MemoryExhausted;
                        }
                    }
                }
                else
                {
                    //DCMSR_ERROR("ValueType attribute for root content item is missing");
                    result = E_Condition.SR_EC_MandatoryAttributeMissing;
                }
            }

            return result;
        }
         
        /// <summary>
        /// write current SR document tree to DICOM dataset.
        /// </summary>
        /// <param name="dataset"></param>
        /// <param name="markedItems"></param>
        /// <returns> status, EC_Normal if successful, an error code otherwise </returns>
        public E_Condition write(ref DicomAttributeCollection dataset, Stack<DicomAttributeCollection> markedItems = null)
        {
            E_Condition result = E_Condition.SR_EC_InvalidDocumentTree;
            /* check whether root node has correct relationship and value type */
            if (isValid())
            {
                DSRDocumentTreeNode node = ((DSRDocumentTreeNode)getRoot());
                if (node != null)
                {
                    /* check and update by-reference relationships (if applicable) */
                    checkByReferenceRelationships(CM_updatePositionString);
                    /* start writing from root node */
                    result = node.write(ref dataset, markedItems);
                }
            }
            return result;
        }

        /// <summary>
        /// read XML document tree.
        /// </summary>
        /// <param name="doc"></param>
        /// <param name="cursor"></param>
        /// <param name="flags"></param>
        /// <returns> status, EC_Normal if successful, an error code otherwise </returns>
        public E_Condition readXML(ref DSRXMLDocument doc, DSRXMLCursor cursor, int flags)
        {
            E_Condition result = E_Condition.SR_EC_CorruptedXMLStructure;
            if (ConstraintChecker == null)
            {
                //TODO LOG
                //DCMSR_WARN("Check for relationship content constraints not yet supported");
            }
            else if (ConstraintChecker.isTemplateSupportRequired())
            {
                //TODO LOG
                //DCMSR_WARN("Check for template constraints not yet supported");
            }
            /* we assume that 'cursor' points to the "content" element */
            if (cursor.valid())
            {
                string templateIdentifier = "", mappingResource = "";
                /* template identification information expected "outside" content item */
                if (Convert.ToBoolean(flags & XF_templateElementEnclosesItems))
                {
                    /* check for optional root template identification */
                    DSRXMLCursor childCursor = doc.getNamedNode(cursor, "template", false /*required*/);
                    if (childCursor.valid())
                    {
                        doc.getStringFromAttribute(childCursor, ref mappingResource, "resource");
                        doc.getStringFromAttribute(childCursor, ref templateIdentifier, "tid");
                        /* get first child of the "template" element */
                        cursor = childCursor.getChild();
                    }
                }
                E_ValueType valueType = doc.getValueTypeFromNode(ref cursor);
                /* proceed to first valid container (if any) */
                while (cursor.getNext().valid() && (valueType != E_ValueType.VT_Container))
                {
                    DSRXMLCursor nextCursor = cursor.gotoNext();
                    valueType = doc.getValueTypeFromNode(ref nextCursor);
                }
                /* root node should always be a container */
                if (valueType == E_ValueType.VT_Container)
                {
                    /* ... then create corresponding document tree node */
                    DSRDocumentTreeNode node = new DSRContainerTreeNode(E_RelationshipType.RT_isRoot);
                    if (node != null)
                    {
                        /* ... insert it into the (empty) tree - checking is not required here */
                        if (Convert.ToBoolean(addNode(ref node)))
                        {
                            if (Convert.ToBoolean(flags & XF_templateElementEnclosesItems))
                            {
                                /* set template identification (if any) */
                                if (node.setTemplateIdentification(ref templateIdentifier, ref mappingResource).bad())
                                {
                                    //TODO LOG
                                    //DCMSR_WARN("Root content item has invalid/incomplete template identification");
                                }
                            }
                            /* ... and let the node read the rest of the document */
                            result = node.readXML(ref doc, cursor, DocumentType, flags);
                            /* check and update by-reference relationships (if applicable) */
                            checkByReferenceRelationships(CM_updatePositionString);
                        }
                        else
                            result = E_Condition.SR_EC_InvalidDocumentTree;
                    }
                    else
                        result = E_Condition.EC_MemoryExhausted;
                }
                else
                {
                    //TODO LOG
                    //DCMSR_ERROR("Root content item should always be a CONTAINER");
                    result = E_Condition.SR_EC_InvalidDocumentTree;
                }
            }
            return result;
        }

        /// <summary>
        /// write current SR document tree in XML format.
        /// </summary>
        /// <param name="stream"></param>
        /// <param name="flags"></param>
        /// <returns> status, EC_Normal if successful, an error code otherwise </returns>
        public E_Condition writeXML(ref StringBuilder stream, int flags)
        {
            E_Condition result = E_Condition.SR_EC_InvalidDocumentTree;
            /* check whether root node has correct relationship and value type */
            if (isValid())
            {
                DSRDocumentTreeNode node = ((DSRDocumentTreeNode)getRoot());
                /* start writing from root node */
                if (node != null)
                {
                    /* check by-reference relationships (if applicable) */
                    checkByReferenceRelationships(CM_resetReferenceTargetFlag);
                    /* start writing from root node */
                    result = node.writeXML(ref stream, flags);
                }
            }
            return result;
        }

        /// <summary>
        /// render current SR document tree in HTML/XHTML format.
        /// </summary>
        /// <param name="docStream"></param>
        /// <param name="annexStream"></param>
        /// <param name="flags"></param>
        /// <returns> status, EC_Normal if successful, an error code otherwise </returns>
        public E_Condition renderHTML(ref StringBuilder docStream, ref StringBuilder annexStream, int flags = 0)
        {
            E_Condition result = E_Condition.SR_EC_InvalidDocumentTree;
            /* check whether root node has correct relationship and value type */
            if (isValid())
            {
                DSRDocumentTreeNode node = (DSRDocumentTreeNode)getRoot();
                /* start rendering from root node */
                if (node != null)
                {
                    /* check by-reference relationships (if applicable) */
                    checkByReferenceRelationships(CM_resetReferenceTargetFlag);
                    int annexNumber = 1;
                    /* start rendering from root node */
                    result = node.renderHTML(ref docStream, ref annexStream, 1 /*nestingLevel*/, ref annexNumber, flags & ~HF_internalUseOnly);
                }
            }
            return result;
        }

        /// <summary>
        /// get document type
        /// </summary>
        /// <returns> current document type (might be DT_invalid) </returns>
        public E_DocumentType getDocumentType()
        {
            return DocumentType;
        }

        /// <summary>
        /// change document type.
        /// Please note that the document tree is deleted if the specified 'documentType' is supported. 
        /// Otherwise the current document remains in force.
        /// </summary>
        /// <param name="documentType"></param>
        /// <returns> status, EC_Normal if successful, an error code otherwise </returns>
        public E_Condition changeDocumentType(E_DocumentType documentType)
        {
            E_Condition result = E_Condition.SR_EC_UnsupportedValue;
            /* first, check whether new document type is supported at all */
            if (isDocumentTypeSupported(documentType))
            {
                /* clear object */
                clear();

                /* store new document type */
                DocumentType = documentType;

                /* create appropriate IOD constraint checker */
                ConstraintChecker = createIODConstraintChecker(documentType);
                result = E_Condition.EC_Normal;
            }

            return result;
        }

        /// <summary>
        /// check whether specified content item can be added to the current one.
        /// If the tree is currently empty only a CONTAINER with the internal relationship
        /// type RT_isRoot is allowed (as the new root node).  Always returns true if no
        /// constraint checker is available.  This method can be used to decide which type
        /// of content items can be added prior to really do so.
        /// </summary>
        /// <param name="relationshipType"></param>
        /// <param name="valueType"></param>
        /// <param name="addMode"></param>
        /// <returns> true if specified node can be added, false otherwise </returns>
        public bool canAddContentItem(E_RelationshipType relationshipType, E_ValueType valueType, E_AddMode addMode = E_AddMode.AM_afterCurrent)
        {
            bool result = false;
            DSRDocumentTreeNode node = ((DSRDocumentTreeNode)getNode());
            if (node != null)
            {
                if (ConstraintChecker != null)
                {
                    if ((addMode == E_AddMode.AM_beforeCurrent) || (addMode == E_AddMode.AM_afterCurrent))
                    {
                        /* check parent node */
                        node = ((DSRDocumentTreeNode)getParentNode());
                        if (node != null)
                            result = ConstraintChecker.checkContentRelationship(node.getValueType(), relationshipType, valueType);
                    } else
                        result = ConstraintChecker.checkContentRelationship(node.getValueType(), relationshipType, valueType);
                } else
                    result = true;    /* cannot check, therefore, allow everything */
            } else {
                /* root node has to be a Container */
                result = (relationshipType == E_RelationshipType.RT_isRoot) && (valueType == E_ValueType.VT_Container);
            }
            return result;
        }

        /// <summary>
        /// check whether specified by-reference relationship can be added to the current
        /// content item. Always returns true if no constraint checker is available.
        /// </summary>
        /// <param name="relationshipType"></param>
        /// <param name="targetValueType"></param>
        /// <returns> true if specified by-reference relationship can be added, false otherwise </returns>
        public bool canAddByReferenceRelationship(E_RelationshipType relationshipType, E_ValueType targetValueType)
        {
             bool result = false;
            if (ConstraintChecker != null)
            {
                DSRDocumentTreeNode node = ((DSRDocumentTreeNode)getNode());
                if (node != null)
                    result = ConstraintChecker.checkContentRelationship(node.getValueType(), relationshipType, targetValueType, true /*byReference*/);
            } else
                result = true;    /* cannot check, therefore, allow everything */
            return result;
        }

        /// <summary>
        /// add specified content item to the current one.
        /// If possible this method creates a new node as specified and adds it to the currentone. 
        /// The method canAddContentItem() is called internally to check parameters first.
        /// </summary>
        /// <param name="relationshipType"></param>
        /// <param name="valueType"></param>
        /// <param name="addMode"></param>
        /// <returns> ID of new node if successful, 0 otherwise </returns>
        public int addContentItem(E_RelationshipType relationshipType, E_ValueType valueType, E_AddMode addMode = E_AddMode.AM_afterCurrent)
        {
            int nodeID = 0;
            if (canAddContentItem(relationshipType, valueType, addMode))
            {
                /* create a new node ... */
                DSRDocumentTreeNode node = createDocumentTreeNode(relationshipType, valueType);
                if (node != null)
                {
                    /* ... and add it to the current node */
                    nodeID = addNode(node, addMode);
                }
            }
            return nodeID;
        }

        /// <summary>
        /// add specified by-reference relationship to the current content item.
        /// If possible this method creates a new pseudo-node (relationship) and adds it to the current one. 
        /// The method canAddByReferenceRelationship() is called internally to check
        /// parameters first.  The internal cursor is automatically re-set to the current node.
        /// </summary>
        /// <param name="relationshipType"></param>
        /// <param name="referencedNodeID"></param>
        /// <returns> ID of new pseudo-node if successful, 0 otherwise </returns>
        public int addByReferenceRelationship(E_RelationshipType relationshipType, int referencedNodeID)
        {
            int nodeID = 0;
            if (referencedNodeID > 0)
            {
                DSRTreeNodeCursor cursor = new DSRTreeNodeCursor(getRoot());
                if (cursor.isValid())
                {
                    /* goto specified target node (might be improved later on) */
                    if (Convert.ToBoolean(cursor.gotoNode(referencedNodeID)))
                    {
                        string sourceString = "";
                        string targetString = "";
                        getPosition(ref sourceString);
                        cursor.getPosition(ref targetString);
                        /* check whether target node is an ancestor of source node (prevent loops) */
                        if (sourceString.Substring(0, targetString.Length) != targetString)
                        {
                             DSRDocumentTreeNode targetNode = ((DSRDocumentTreeNode)cursor.getNode());
                            if (targetNode != null)
                            {
                                /* check whether relationship is valid/allowed */
                                if (canAddByReferenceRelationship(relationshipType, targetNode.getValueType()))
                                {
                                    DSRDocumentTreeNode node = new DSRByReferenceTreeNode(relationshipType, referencedNodeID);
                                    if (node != null)
                                    {
                                        nodeID = addNode(node, E_AddMode.AM_belowCurrent);
                                        /* go back to current node */
                                        if (nodeID > 0)
                                            goUp();
                                    }
                                }
                            }
                        }
                    }
                }
            }
            return nodeID;
        }

        /// <summary>
        /// remove current content item from tree.
        /// Please note that not only the specified node but also all of its child nodes are
        /// removed from the tree and then deleted.  The internal cursor is set automatically
        /// to a new valid position.
        /// </summary>
        /// <returns> ID of the node which became the current one after deletion, 0 if an error occured or the tree is now empty </returns>
        public int removeCurrentContentItem()
        {
            return removeNode();
        }

        ///<summary>
        /// get reference to current content item. This mechanism allows to access all content items without using pointers.
        ///</summary>
        ///<returns> reference to current content item (might be invalid) </returns>
        public DSRContentItem getCurrentContentItem()
        {
            CurrentContentItem.setTreeNode((DSRDocumentTreeNode)getNode());
            return CurrentContentItem;
        }

        /// <summary>
        /// set internal cursor to the named node.
        /// If more than one node exists with the given concept name the first one will
        /// be selected.  Use gotoNextNamedNode() in order to go to the next matching node.
        /// </summary>
        /// <param name="conceptName"></param>
        /// <param name="startFromRoot"></param>
        /// <param name="searchIntoSub"></param>
        /// <returns> ID of the new current node if successful, 0 otherwise </returns>
        public int gotoNamedNode(ref DSRCodedEntryValue conceptName, bool startFromRoot = true, bool searchIntoSub = true)
        {
            int nodeID = 0;
            if (conceptName.isValid())
            {
                if (startFromRoot)
                    gotoRoot();
                DSRDocumentTreeNode node = new DSRDocumentTreeNode();
                clearNodeCursorStack();
                /* iterate over all nodes */
                do {
                    node = ((DSRDocumentTreeNode)getNode());
                    if ((node != null) && (node.getConceptName() == conceptName))
                        nodeID = node.getNodeID();
                } while ((nodeID == 0) && Convert.ToBoolean(iterate(searchIntoSub)));
            }
            return nodeID;
        }

        /// <summary>
        /// set internal cursor to the next named node.
        /// Starts from "next" node, i.e. either the first children of the current node
        /// or the first sibling following the current node.
        /// </summary>
        /// <param name="conceptName"></param>
        /// <param name="searchIntoSub"></param>
        /// <returns> ID of the new current node if successful, 0 otherwise </returns>
        public int gotoNextNamedNode(ref DSRCodedEntryValue conceptName, bool searchIntoSub = true)
        {
            /* first, goto "next" node */
            int nodeID = iterate(searchIntoSub);
            if (nodeID > 0)
                nodeID = gotoNamedNode(ref conceptName, false /*startFromRoot*/, searchIntoSub);
            return nodeID;
        }

        /// <summary>
        /// unmark all content items in the document tree.
        /// Use method 'setMark' on node-level to mark and unmark a single content item.
        /// Pointers to the DICOM dataset/item of marked content items are added to the optional
        /// stack when calling the 'write' method.  This mechanism can e.g. be used to digitally sign particular content items.
        /// </summary>
        public void unmarkAllContentItems()
        {
            DSRTreeNodeCursor cursor = new  DSRTreeNodeCursor(getRoot());
            if (cursor.isValid())
            {
                DSRDocumentTreeNode node = new DSRDocumentTreeNode();
                /* iterate over all nodes */
                do {
                    node = ((DSRDocumentTreeNode)cursor.getNode());
                    if (node != null)
                        node.setMark(false);
                } while (Convert.ToBoolean(cursor.iterate()));
            }
        }

        /// <summary>
        /// remove digital signatures from the document tree.
        /// This method clears the MACParametersSequence and the DigitalSignaturesSequence for
        /// all content items which have been filled during reading.
        /// </summary>
        public void removeSignatures()
        {
            DSRTreeNodeCursor cursor = new  DSRTreeNodeCursor(getRoot());
            if (cursor.isValid())
            {
                DSRDocumentTreeNode node = new DSRDocumentTreeNode();
                /* iterate over all nodes */
                do {
                    node = ((DSRDocumentTreeNode)cursor.getNode());
                    if (node != null)
                        node.removeSignatures();
                } while (Convert.ToBoolean(cursor.iterate()));
            }
        }

        /// <summary>
        /// add new node to the current one.
        /// Please note that no copy of the given node is created. Therefore, the node
        /// should be created with new() - do not use a reference to a local variable.
        /// If the node could be added successfully the cursor is set to it automatically.
        /// </summary>
        /// <param name="node"></param>
        /// <param name="addMode"></param>
        /// <returns> ID of the new added node if successful, 0 otherwise </returns>
        protected virtual int addNode(ref DSRDocumentTreeNode node, E_AddMode addMode = E_AddMode.AM_afterCurrent)
        {
            /* might add a check for templates later on */
            return base.addNode(node, addMode);
        }

        /// <summary>
        /// remove current node from tree.
        /// Please note that not only the specified node but also all of his child nodes are
        /// removed from the tree and deleted afterwards. The cursor is set automatically to a new valid position.
        /// </summary>
        /// <returns> ID of the node which became the current one after deletion, 0 if an error occured or the tree is now empty. </returns>
        protected virtual int removeNode()
        {
            /* might add a check for templates later on */
            return base.removeNode();
        }

        /// <summary>
        /// check the by-reference relationships (if any) for validity.
        /// This function checks whether all by-reference relationships possibly contained
        /// in the document tree are valid according to the following restrictions: source
        /// and target node are not identical and the target node is not an ancestor of the
        /// source node (requirement from the DICOM standard to prevent loops -> directed
        /// acyclic graph, though this is not 100% true - see "reportlp.dcm" example).
        /// In addition, the position strings (used to encode by-reference relationships
        /// according to the DICOM standard) OR the node IDs (used internally to uniquely
        /// identify nodes) can be updated.  Please note that the modes 'CM_updatePositionString'
        /// and 'CM_updateNodeID' are mutually exclusive.
        /// </summary>
        /// <param name="mode"></param>
        /// <param name="flags"></param>
        protected E_Condition checkByReferenceRelationships(int mode = 0, int flags = 0)
        {
            E_Condition result = E_Condition.EC_IllegalParameter;
            /* the update flags are mutually exclusive */
            if (!Convert.ToBoolean(Convert.ToBoolean(mode & CM_updatePositionString) && Convert.ToBoolean(mode & CM_updateNodeID)))
            {
                result = E_Condition.EC_Normal;
                /* by-reference relationships are only allowed for particular IODs */
                if ((ConstraintChecker != null) && ConstraintChecker.isByReferenceAllowed())
                {
                    /* specify for all content items not to be the target of a by-reference relationship */
                    if (Convert.ToBoolean(mode & CM_resetReferenceTargetFlag))
                        resetReferenceTargetFlag();
                    /* start at the root of the document tree */
                    DSRTreeNodeCursor cursor = new DSRTreeNodeCursor(getRoot());
                    if (cursor.isValid())
                    {
                        DSRDocumentTreeNode node = new DSRDocumentTreeNode();
                        do {    /* for all content items */
                            node = ((DSRDocumentTreeNode)cursor.getNode());
                            if (node != null)
                            {
                                /* only check/update by-reference relationships */
                                if (node.getValueType() == E_ValueType.VT_byReference)
                                {
                                    int refNodeID = 0;
                                    /* type cast to directly access member variables of by-reference class */
                                    DSRByReferenceTreeNode refNode = ((DSRByReferenceTreeNode)node);
                                    if (Convert.ToBoolean(flags & RF_showCurrentlyProcessedItem))
                                    {
                                        string posString = "";
                                        cursor.getPosition(ref posString);
                                        //TODO LOG
                                        //DCMSR_WARN("Updating by-reference relationship in content item " << cursor.getPosition(posString));
                                    }
                                    /* start searching from root node (be careful with large trees, might be improved later on) */
                                    DSRTreeNodeCursor refCursor = new DSRTreeNodeCursor(getRoot());
                                    if (Convert.ToBoolean(mode & CM_updateNodeID))
                                    {
                                        /* update node ID */
                                        refNodeID = refCursor.gotoNode(ref refNode.ReferencedContentItem);
                                        if (refNodeID > 0)
                                            refNode.ReferencedNodeID = refCursor.getNodeID();
                                        else
                                            refNode.ReferencedNodeID = 0;
                                        refNode.ValidReference = (refNode.ReferencedNodeID > 0);
                                    } else {
                                        /* ReferenceNodeID contains a valid value */
                                        refNodeID = refCursor.gotoNode(refNode.ReferencedNodeID);
                                        if (Convert.ToBoolean(mode & CM_updatePositionString))
                                        {
                                            /* update position string */
                                            if (refNodeID > 0)
                                                refCursor.getPosition(ref refNode.ReferencedContentItem);
                                            else
                                                refNode.ReferencedContentItem = "";
                                            /* tbd: check for valid reference could be more strict */
                                            refNode.ValidReference = checkForValidUIDFormat(refNode.ReferencedContentItem);
                                        } else if (refNodeID == 0)
                                            refNode.ValidReference = false;
                                    }
                                    if (refNodeID > 0)
                                    {
                                        /* source and target content items should not be identical */
                                        if (refNodeID != cursor.getNodeID())
                                        {
                                            string posString = "";
                                            cursor.getPosition(ref posString);
                                            /* check whether target node is an ancestor of source node (prevent loops) */
                                            if (posString.Substring(0, refNode.ReferencedContentItem.Length) != refNode.ReferencedContentItem)
                                            {
                                                /* refCursor should now point to the reference target (refNodeID > 0) */
                                                DSRDocumentTreeNode parentNode = ((DSRDocumentTreeNode)cursor.getParentNode());
                                                DSRDocumentTreeNode targetNode = ((DSRDocumentTreeNode)refCursor.getNode());
                                                if ((parentNode != null) && (targetNode != null))
                                                {
                                                    /* specify that this content item is target of an by-reference relationship */
                                                    targetNode.setReferenceTarget();
                                                    /* do we really need to check the constraints? */
                                                    E_RelationshipType relationshipType = refNode.getRelationshipType();
                                                    if (!Convert.ToBoolean(flags & RF_ignoreRelationshipConstraints) &&
                                                        (!Convert.ToBoolean(flags & RF_acceptUnknownRelationshipType) || (relationshipType != E_RelationshipType.RT_unknown)))
                                                    {
                                                        /* check whether relationship is valid */
                                                        if ((ConstraintChecker != null) && !ConstraintChecker.checkContentRelationship(parentNode.getValueType(),
                                                            relationshipType, targetNode.getValueType(), true /*byReference*/))
                                                        {
                                                            //TODO LOG
                                                            //DCMSR_WARN("Invalid by-reference relationship between item \"" << posString
                                                            //    << "\" and \"" << refNode.ReferencedContentItem << "\"");
                                                        }
                                                    }
                                                } 
                                                else
                                                {
                                                    //TODO LOG
                                                    //DCMSR_WARN("Corrupted data structures while checking by-reference relationships");
                                                }
                                                    
                                            }
                                            else
                                            {
                                                //TODO LOG
                                                //DCMSR_WARN("By-reference relationship to ancestor content item (loop check)");
                                            }
                                                
                                        } 
                                        else
                                        {
                                            //TODO LOG
                                            //DCMSR_WARN("Source and target content item of by-reference relationship are identical");
                                        }
                                    } 
                                    else
                                    {
                                        if (Convert.ToBoolean(mode & CM_updateNodeID))
                                        {
                                            //TODO LOG
                                            //DCMSR_WARN("Target content item of by-reference relationship ("
                                            //    << refNode.ReferencedContentItem << ") does not exist");
                                        }
                                        else
                                        {
                                            //TODO LOG
                                            //DCMSR_WARN("Target content item of by-reference relationship does not exist");
                                        }
                                    }
                                }
                            } 
                            else
                                result = E_Condition.SR_EC_InvalidDocumentTree;
                        } while (result.good() && Convert.ToBoolean(cursor.iterate()));
                    }
                }
            }
            return result;
        }

        /// <summary>
        /// reset flag for all content items whether they are target of a by-reference relationship.
        /// This function calls 'setReferenceTarget(false)' for all content items.
        /// </summary>
        protected void resetReferenceTargetFlag()
        {
            DSRTreeNodeCursor cursor = new  DSRTreeNodeCursor(getRoot());
            if (cursor.isValid())
            {
                DSRDocumentTreeNode node = new DSRDocumentTreeNode();
                /* iterate over all nodes */
                do {
                    node = ((DSRDocumentTreeNode)cursor.getNode());
                    if (node != null)
                        node.setReferenceTarget(false);
                } while (Convert.ToBoolean(cursor.iterate()));
            }
        }

        /// <summary>
        /// add new node to the current one.
        /// This method just overwrites the method from the base class DSRTree.  
        /// Use the above addNode() method instead.
        /// </summary>
        /// <param name="node"></param>
        /// <param name="addMode"></param>
        /// <returns> always 0 (invalid) </returns>
        protected virtual int addNode(ref DSRTreeNode node, E_AddMode addMode = E_AddMode.AM_afterCurrent)
        {
            /* invalid for this class */
            return 0;
        }

        /// document type of the associated SR document
        private E_DocumentType DocumentType;
        /// current content item.  Introduced to avoid the external use of pointers.
        private DSRContentItem CurrentContentItem;
        /// check relationship content constraints of the associated IOD
        private DSRIODConstraintChecker ConstraintChecker;
    }
}
