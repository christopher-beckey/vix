using Hydra.Dicom.SR;
using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;
using System.Threading.Tasks;

namespace Hydra.Dicom
{
    public class DSRContentItem : DSRTypes
    {
        //TODO : DSRContentItem
        /// internal tree node pointer (current conten item)
        private DSRDocumentTreeNode TreeNode;

        /// empty string value. Used as default return value for getStringValue()
        private static string EmptyString = "";
        /// empty coded entry value. Used as default return value for getCodeValue() and getConceptName()
        private static DSRCodedEntryValue EmptyCodedEntry;
        /// empty numberic measurement value. Used as default return value for getNumericValue()
        private static DSRNumericMeasurementValue  EmptyNumericMeasurement;
        /// empty spatial coordinates value. Used as default return value for getSpatialCoordinates()
        private static DSRSpatialCoordinatesValue  EmptySpatialCoordinates;
        /// empty temporal coordinates value. Used as default return value for getTemporalCoordinates()
        private static DSRTemporalCoordinatesValue EmptyTemporalCoordinates;
        /// empty composite reference value. Used as default return value for getCompositeReference()
        private static DSRCompositeReferenceValue  EmptyCompositeReference;
        /// empty image reference value. Used as default return value for getImageReference()
        private static DSRImageReferenceValue      EmptyImageReference;
        /// empty waveform reference value. Used as default return value for getWaveformReference()
        private static DSRWaveformReferenceValue   EmptyWaveformReference;


        // --- declaration of copy constructor and assignment operator
        //DSRContentItem(DSRContentItem)
        //{
        //}

        public DSRContentItem()
        {
           TreeNode = null;
        }

        /** destructor
        */
        ~DSRContentItem()
        {
        }

        /** check for validity/completeness.
        *  Applicable to all content items.
        ** @return OFTrue if current content item is valid, OFFalse otherwise
        */
        public bool isValid()
        {
            bool result = false;
            if (TreeNode != null)
                result = TreeNode.isValid();
            return result;
        }

        /** check for mark flag.
        *  Applicable to all content items.
        ** @return OFTrue if current content item is marked, OFFalse otherwise
        */
        public bool isMarked()
        {
            bool result = false;
            if (TreeNode != null)
                result = TreeNode.isMarked();
            return result;
        }

        /** mark/unmark item.
        *  Applicable to all content items.
        ** @param  flag  mark item if OFTrue, unmark otherwise
        */
        public void setMark(bool flag)
        {
            if (TreeNode != null)
                TreeNode.setMark(flag);
        }

        /** get value type.
        *  Applicable to all content items.
        ** @return value type of current content item if valid, VT_invalid otherwise
        */
        public E_ValueType getValueType()
        {
            E_ValueType valueType = E_ValueType.VT_invalid;
            if (TreeNode != null)
                valueType = TreeNode.getValueType();
            return valueType;
        }

        /** get relationship type.
        *  Applicable to all content items.
        ** @return relationship type of current content item if valid, RT_invalid otherwise
        */
        public E_RelationshipType getRelationshipType()
        {
            E_RelationshipType relationshipType = E_RelationshipType.RT_invalid;
            if (TreeNode != null)
                relationshipType = TreeNode.getRelationshipType();
            return relationshipType;
        }

        /** get ID of the referenced node.
        *  Applicable to: byReference relationships
        ** @return ID of the referenced node if valid, 0 otherwise
        */
        public int getReferencedNodeID()
        {
            int nodeID = 0;
            if (TreeNode != null)
            {
                if (TreeNode.getValueType() == E_ValueType.VT_byReference)
                {
                    nodeID = ((DSRByReferenceTreeNode)TreeNode).getReferencedNodeID();
                }
            }
            return nodeID;
        }

        /** get string value.
        *  Applto: TEXT, DATETIME, DATE, TIME, UIDREF, PNAME
        ** @return string value of current content item if valid, EmptyString otherwise
        */
        public string getStringValue()
        {
            if (TreeNode != null)
            {
                switch (TreeNode.getValueType())
                {
                    //TODO: DSRContentItem
                    case E_ValueType.VT_Text:
                        return ((DSRTextTreeNode)TreeNode).getValue();
                    case E_ValueType.VT_DateTime:
                        return ((DSRDateTimeTreeNode)TreeNode).getValue();
                    case E_ValueType.VT_Date:
                        return ((DSRDateTreeNode)TreeNode).getValue();
                    case E_ValueType.VT_Time:
                        return ((DSRTimeTreeNode)TreeNode).getValue();
                    case E_ValueType.VT_UIDRef:
                        return ((DSRUIDRefTreeNode)TreeNode).getValue();
                    case E_ValueType.VT_PName:
                        return ((DSRPNameTreeNode)TreeNode).getValue();
                    default:
                        break;
                }
            }

            return string.Empty;
        }

        /** set string value.  Please use the correct format for the string value depending on
        *  the corresponding content item (value type).
        *  Applicable to: TEXT, DATETIME, DATE, TIME, UIDREF, PNAME
        ** @param  stringValue  value to be set
        ** @return status, EC_Normal if successful, an error code otherwise
        */
        public E_Condition setStringValue(string stringValue)
        {
            E_Condition result = E_Condition.EC_IllegalCall;
            if (TreeNode != null)
            {
                switch (TreeNode.getValueType())
                {
                    //TODO: DSRContentItem
                    case E_ValueType.VT_Text:
                        result = ((DSRTextTreeNode)TreeNode).setValue(stringValue);
                    break;

                    case E_ValueType.VT_DateTime:
                        result = ((DSRDateTimeTreeNode)TreeNode).setValue(stringValue);
                    break;

                    case E_ValueType.VT_Date:
                        result = ((DSRDateTreeNode)TreeNode).setValue(stringValue);
                    break;

                    case E_ValueType.VT_Time:
                        result = ((DSRTimeTreeNode)TreeNode).setValue(stringValue);
                    break;

                    case E_ValueType.VT_UIDRef:
                        result = ((DSRUIDRefTreeNode)TreeNode).setValue(stringValue);
                    break;

                    case E_ValueType.VT_PName:
                        result = ((DSRPNameTreeNode)TreeNode).setValue(stringValue);
                    break;

                    default:
                        break;
                }
            }

            return result;
        }

        /** get pointer to code value.
        *  Applicable to: CODE
        ** @return pointer to code value of current content item if valid, NULL otherwise
        */
        public DSRCodedEntryValue getCodeValuePtr()
        {
            //TODO: DSRContentItem
            DSRCodedEntryValue pointer = null;
            if (TreeNode != null)
            {
                if (TreeNode.getValueType() == E_ValueType.VT_Code)
                {
                    //pointer = ((DSRCodeTreeNode)TreeNode).getValuePtr();
                }
            }

            return pointer;
        }

        /** get code value.
        *  Applicable to: CODE
        ** @return coded entry value of current content item if valid, EmptyCodedEntry otherwise
        */
        public DSRCodedEntryValue getCodeValue()
        {
            //TODO: DSRContentItem
            if (TreeNode != null)
            {
                if (TreeNode.getValueType() == E_ValueType.VT_Code)
                {
                    //return ((DSRCodeTreeNode)TreeNode).getValue();
                }
            }

            return null/*EmptyCodedEntry*/;
        }

        /** get copy of code value.
        *  Applicable to: CODE
        ** @param  codeValue  variable where the copy should be stored
        ** @return status, EC_Normal if successful, an error code otherwise
        */
        public E_Condition getCodeValue(ref DSRCodedEntryValue codeValue)
        {
            //TODO: DSRContentItem
            E_Condition result = E_Condition.EC_IllegalCall;
            if (TreeNode != null)
            {
                if (TreeNode.getValueType() == E_ValueType.VT_Code)
                {
                    //result = ((DSRCodeTreeNode)TreeNode).getValue(codeValue);
                }
                else
                {
                    codeValue.clear();
                }
            }
            else
            {
                codeValue.clear();
            }

            return result;
        }

        /** set code value.
        *  Applicable to: CODE
        ** @param  codeValue  value to be set
        ** @return status, EC_Normal if successful, an error code otherwise
        */
        public E_Condition setCodeValue(DSRCodedEntryValue codeValue)
        {
            //TODO: DSRContentItem
            E_Condition result = E_Condition.EC_IllegalCall;
            if (TreeNode != null)
            {
                if (TreeNode.getValueType() == E_ValueType.VT_Code)
                {
                    //result = ((DSRCodeTreeNode)TreeNode).setValue(codeValue);
                }
            }

            return result;
        }

        /** get pointer to numeric value.
        *  Applicable to: NUM
        ** @return pointer to numeric value of current content item if valid, NULL otherwise
        */
        public DSRNumericMeasurementValue getNumericValuePtr()
        {
            //TODO: DSRContentItem
            DSRNumericMeasurementValue pointer = null;
            if (TreeNode != null)
            {
                if (TreeNode.getValueType() == E_ValueType.VT_Num)
                {
                    //pointer = ((DSRNumTreeNode)TreeNode).getValuePtr();
                }
            }

            return pointer;
        }

        /** get numeric value.
        *  Applicable to: NUM
        ** @return numeric measurement value of current content item if valid, EmptyNumericMeasurement otherwise
        */
        public DSRNumericMeasurementValue getNumericValue()
        {
            //TODO: DSRContentItem
            if (TreeNode != null)
            {
                if (TreeNode.getValueType() == E_ValueType.VT_Num)
                {
                    //return ((DSRNumTreeNode)TreeNode).getValue();
                }
            }

            return null;
        }

        /** get copy of numeric value.
        *  Applicable to: NUM
        ** @param  numericValue  variable where the copy should be stored (cleared if an error occurs)
        ** @return status, EC_Normal if successful, an error code otherwise
        */
        public E_Condition getNumericValue(ref DSRNumericMeasurementValue numericValue)
        {
            //TODO: DSRContentItem
            E_Condition result = E_Condition.EC_IllegalCall;
            if (TreeNode != null)
            {
                if (TreeNode.getValueType() == E_ValueType.VT_Num)
                {
                    //result = ((DSRNumTreeNode)TreeNode).getValue(numericValue);
                }
                else
                {
                    numericValue.clear();
                }
            }
            else
            {
                numericValue.clear();
            }

            return result;
        }

        /** set numeric value.
        *  Applicable to: NUM
        ** @param  numericValue  value to be set
        ** @return status, EC_Normal if successful, an error code otherwise
        */
        public E_Condition setNumericValue(ref DSRNumericMeasurementValue numericValue)
        {
            //TODO: DSRContentItem
            E_Condition result = E_Condition.EC_IllegalCall;
            if (TreeNode != null)
            {
                if (TreeNode.getValueType() == E_ValueType.VT_Num)
                {
                    //result = ((DSRNumTreeNode)TreeNode).setValue(numericValue);
                }
            }

            return result;
        }

        /** get pointer to spatial coordinates.
        *  Applicable to: SCOORD
        ** @return pointer to spatial coordinates value of current content item if valid, NULL otherwise
        */
        public DSRSpatialCoordinatesValue getSpatialCoordinatesPtr()
        {
            //TODO: DSRContentItem
            DSRSpatialCoordinatesValue pointer = null;
            if (TreeNode != null)
            {
                if (TreeNode.getValueType() == E_ValueType.VT_SCoord)
                {
                    //pointer = ((DSRSCoordTreeNode)TreeNode).getValuePtr();
                }
            }

            return pointer;
        }

        /** get spatial coordinates.
        *  Applicable to: SCOORD
        ** @return spatial coordinates value of current content item if valid, EmptySpatialCoordinates otherwise
        */
        public DSRSpatialCoordinatesValue getSpatialCoordinates()
        {
            //TODO: DSRContentItem
            if (TreeNode != null)
            {
                if (TreeNode.getValueType() == E_ValueType.VT_SCoord)
                {
                    //return ((DSRSCoordTreeNode)TreeNode).getValue();
                }
            }

            return null;
        }

        /** get copy of spatial coordinates.
        *  Applicable to: SCOORD
        ** @param  coordinatesValue  variable where the copy should be stored (cleared if an error occurs)
        ** @return status, EC_Normal if successful, an error code otherwise
        */
        public E_Condition getSpatialCoordinates(ref DSRSpatialCoordinatesValue coordinatesValue)
        {
            //TODO: DSRContentItem
            E_Condition result = E_Condition.EC_IllegalCall;
            if (TreeNode != null)
            {
                if (TreeNode.getValueType() == E_ValueType.VT_SCoord)
                {
                    //result= ((DSRSCoordTreeNode)TreeNode).getValue(coordinatesValue);
                }
                else
                {
                    coordinatesValue.clear();
                }
            }
            else
            {
                coordinatesValue.clear();
            }

            return result;
        }

        /** set spatial coordinates.
        *  Applicable to: SCOORD
        ** @param  coordinatesValue  value to be set
        ** @return status, EC_Normal if successful, an error code otherwise
        */
        public E_Condition setSpatialCoordinates(ref DSRSpatialCoordinatesValue coordinatesValue)
        {
            //TODO: DSRContentItem
            E_Condition result = E_Condition.EC_IllegalCall;
            if (TreeNode != null)
            {
                if (TreeNode.getValueType() == E_ValueType.VT_SCoord)
                {
                    //result = ((DSRSCoordTreeNode)TreeNode).setValue(coordinatesValue);
                }
            }

            return result;
        }

        /** get pointer to temporal coordinates.
        *  Applicable to: TCOORD
        ** @return pointer to temporal coordinates value of current content item if valid, NULL otherwise
        */
        public DSRTemporalCoordinatesValue getTemporalCoordinatesPtr()
        {
            //TODO: DSRContentItem
            DSRTemporalCoordinatesValue pointer = null;
            if (TreeNode != null)
            {
                if (TreeNode.getValueType() == E_ValueType.VT_TCoord)
                {
                    //pointer = ((DSRTCoordTreeNode)TreeNode).getValuePtr();
                }
            }

            return pointer;
        }

        /** get temporal coordinates.
        *  Applicable to: TCOORD
        ** @return temporal coordinates value of current content item if valid, EmptyTemporalCoordinates otherwise
        */
        public DSRTemporalCoordinatesValue getTemporalCoordinates()
        {
            //TODO: DSRContentItem
            if (TreeNode != null)
            {
                if (TreeNode.getValueType() == E_ValueType.VT_TCoord)
                {
                    //return ((DSRTCoordTreeNode)TreeNode).getValue();
                }
            }

            return null;
        }

        /** get copy of temporal coordinates.
        *  Applicable to: TCOORD
        ** @param  coordinatesValue  variable where the copy should be stored (cleared if an error occurs)
        ** @return status, EC_Normal if successful, an error code otherwise
        */
        public E_Condition getTemporalCoordinates(ref DSRTemporalCoordinatesValue coordinatesValue)
        {
            //TODO: DSRContentItem
            E_Condition result = E_Condition.EC_IllegalCall;
            if (TreeNode != null)
            {
                if (TreeNode.getValueType() == E_ValueType.VT_TCoord)
                {
                    //result= ((DSRTCoordTreeNode)TreeNode).getValue(coordinatesValue);
                }
                else
                {
                    coordinatesValue.clear();
                }
            }
            else
            {
                coordinatesValue.clear();
            }

            return result;
        }

        /** set temporal coordinates.
        *  Applicable to: TCOORD
        ** @param  coordinatesValue  value to be set
        ** @return status, EC_Normal if successful, an error code otherwise
        */
        public E_Condition setTemporalCoordinates(ref DSRTemporalCoordinatesValue coordinatesValue)
        {
            //TODO: DSRContentItem
            E_Condition result = E_Condition.EC_IllegalCall;
            if (TreeNode != null)
            {
                if (TreeNode.getValueType() == E_ValueType.VT_TCoord)
                {
                    //result = ((DSRTCoordTreeNode)TreeNode).setValue(coordinatesValue);
                }
            }

            return result;
        }

        /** get pointer to composite reference.
        *  Applicable to: COMPOSITE
        ** @return pointer to reference value of current content item if valid, NULL otherwise
        */
        public DSRCompositeReferenceValue getCompositeReferencePtr()
        {
            //TODO: DSRContentItem
            DSRCompositeReferenceValue pointer = null;
            if (TreeNode != null)
            {
                if (TreeNode.getValueType() == E_ValueType.VT_Composite)
                {
                    //pointer = ((DSRCompositeTreeNode)TreeNode).getValuePtr();
                }
            }

            return pointer;
        }

        /** get composite reference.
        *  Applicable to: COMPOSITE
        ** @return reference value of current content item if valid, EmptyReference otherwise
        */
        public DSRCompositeReferenceValue getCompositeReference()
        {
            //TODO: DSRContentItem
            if (TreeNode != null)
            {
                if (TreeNode.getValueType() == E_ValueType.VT_Composite)
                {
                    //return ((DSRCompositeTreeNode)TreeNode).getValue();
                }
            }

            return null;
        }

        /** get copy of composite reference.
        *  Applicable to: COMPOSITE
        ** @param  referenceValue  variable where the copy should be stored (cleared if an error occurs)   
        ** @return status, EC_Normal if successful, an error code otherwise
        */
        public E_Condition getCompositeReference(ref DSRCompositeReferenceValue referenceValue)
        {
            //TODO: DSRContentItem
            E_Condition result = E_Condition.EC_IllegalCall;
            if (TreeNode != null)
            {
                if (TreeNode.getValueType() == E_ValueType.VT_Composite)
                {
                    //result = ((DSRCompositeTreeNode)TreeNode).getValue(referenceValue);
                }
                else
                {
                    referenceValue.clear();
                }
            }
            else
            {
                referenceValue.clear();
            }

            return result;
        }

        /** set composite reference.
        *  Applicable to: COMPOSITE
        ** @param  referenceValue  value to be set
        ** @return status, EC_Normal if successful, an error code otherwise
        */
        public E_Condition setCompositeReference(ref DSRCompositeReferenceValue referenceValue)
        {
            //TODO: DSRContentItem
            E_Condition result = E_Condition.EC_IllegalCall;
            if (TreeNode != null)
            {
                if (TreeNode.getValueType() == E_ValueType.VT_Composite)
                {
                    //((DSRCompositeTreeNode)TreeNode).setValue(referenceValue);
                    result = E_Condition.EC_Normal;
                }
            }

            return result;
        }

        /** get pointer to image reference.
        *  Applicable to: IMAGE
        ** @return pointer to image reference value of current content item if valid, NULL otherwise
        */
        public DSRImageReferenceValue getImageReferencePtr()
        {
            //TODO: DSRContentItem
            DSRImageReferenceValue pointer = null;
            if (TreeNode != null)
            {
                if (TreeNode.getValueType() == E_ValueType.VT_Image)
                {
                    //pointer = ((DSRImageTreeNode)TreeNode).getValuePtr();
                }
            }

            return pointer;
        }

        /** get image reference.
        *  Applicable to: IMAGE
        ** @return image reference value of current content item if valid, EmptyImageReference otherwise
        */
        public DSRImageReferenceValue getImageReference()
        {
            //TODO: DSRContentItem
            if (TreeNode != null)
            {
                if (TreeNode.getValueType() == E_ValueType.VT_Image)
                {
                    //return ((DSRImageTreeNode)TreeNode).getValue();
                }
            }

            return null;
        }

        /** get copy of image reference.
        *  Applicable to: IMAGE
        ** @param  referenceValue  variable where the copy should be stored (cleared if an error occurs)
        ** @return status, EC_Normal if successful, an error code otherwise
        */
        public E_Condition getImageReference(ref DSRImageReferenceValue referenceValue)
        {
            //TODO: DSRContentItem
            E_Condition result = E_Condition.EC_IllegalCall;
            if (TreeNode != null)
            {
                if (TreeNode.getValueType() == E_ValueType.VT_Image)
                {
                    //result = ((DSRImageTreeNode)TreeNode).getValue(referenceValue);
                }
                else
                {
                    referenceValue.clear();
                }
            }
            else
            {
                referenceValue.clear();
            }

            return result;
        }

        /** set image reference.
        *  Applicable to: IMAGE
        ** @param  referenceValue  value to be set
        ** @return status, EC_Normal if successful, an error code otherwise
        */
        public E_Condition setImageReference(ref DSRImageReferenceValue referenceValue)
        {
            //TODO: DSRContentItem
            E_Condition result = E_Condition.EC_IllegalCall;
            if (TreeNode != null)
            {
                if (TreeNode.getValueType() == E_ValueType.VT_Image)
                {
                    ((DSRImageTreeNode)TreeNode).setValue(referenceValue);
                    result = E_Condition.EC_Normal;
                }
            }

            return result;
        }

        /** get pointer to waveform reference.
        *  Applicable to: WAVEFORM
        ** @return pointer to waveform reference value of current content item if valid, NULL otherwise
        */
        public DSRWaveformReferenceValue getWaveformReferencePtr()
        {
            //TODO: DSRContentItem
            DSRWaveformReferenceValue pointer = null;
            if (TreeNode != null)
            {
                if (TreeNode.getValueType() == E_ValueType.VT_Waveform)
                {
                    //pointer = ((DSRWaveformTreeNode)TreeNode).getValuePtr();
                }
            }

            return pointer;
        }

        /** get waveform reference.
        *  Applicable to: WAVEFORM
        ** @return waveform reference value of current content item if valid, EmptyWaveformReference otherwise 
        */
        public DSRWaveformReferenceValue getWaveformReference()
        {
            //TODO: DSRContentItem
            if (TreeNode != null)
            {
                if (TreeNode.getValueType() == E_ValueType.VT_Waveform)
                {
                    //return ((DSRWaveformTreeNode)TreeNode).getValue();
                }
            }

            return null;
        }

        /** get copy of waveform reference.
        *  Applicable to: WAVEFORM
        ** @param  referenceValue  variable where the copy should be stored (cleared if an error occurs)
        ** @return status, EC_Normal if successful, an error code otherwise
        */
        public E_Condition getWaveformReference(ref DSRWaveformReferenceValue referenceValue)
        {
            //TODO: DSRContentItem
            E_Condition result = E_Condition.EC_IllegalCall;
            if (TreeNode != null)
            {
                if (TreeNode.getValueType() == E_ValueType.VT_Waveform)
                {
                    //result = ((DSRWaveformTreeNode)TreeNode).getValue(referenceValue);
                }
                else
                {
                    referenceValue.clear();
                }
            }
            else
            {
                referenceValue.clear();
            }

            return result;
        }

        /** set waveform reference.
        *  Applicable to: WAVEFORM
        ** @param  referenceValue  value to be set
        ** @return status, EC_Normal if successful, an error code otherwise
        */
        public E_Condition setWaveformReference(ref DSRWaveformReferenceValue referenceValue)
        {
            //TODO: DSRContentItem
            E_Condition result = E_Condition.EC_IllegalCall;
            if (TreeNode != null)
            {
                if (TreeNode.getValueType() == E_ValueType.VT_Waveform)
                {
                    //((DSRWaveformTreeNode)TreeNode).setValue(referenceValue);
                    result = E_Condition.EC_Normal;
                }
            }

            return result;
        }

        /** get continuity of content flag.
        *  This flag specifies whether or not its contained content items (child nodes) are
        *  logically linked in a continuous textual flow, or are sparate items.
        *  Applicable to: CONTAINER
        ** @return continuity of content flag if successful, COC_invalid otherwise
        */
        public E_ContinuityOfContent getContinuityOfContent()
        {
            E_ContinuityOfContent result = E_ContinuityOfContent.COC_invalid;
            if (TreeNode != null)
            {
                if (TreeNode.getValueType() == E_ValueType.VT_Container)
                {
                    result = ((DSRContainerTreeNode)TreeNode).getContinuityOfContent();
                }
            }

            return result;
        }

        /** set continuity of content flag.
        *  This flag specifies whether or not its contained content items (child nodes) are
        *  logically linked in a continuous textual flow, or are sparate items.
        *  Applicable to: CONTAINER
        ** @param  continuityOfContent  value to be set (should be different from COC_onvalid)
        ** @return status, EC_Normal if successful, an error code otherwise
        */
        public E_Condition setContinuityOfContent(E_ContinuityOfContent continuityOfContent)
        {
            E_Condition result = E_Condition.EC_IllegalCall;
            if (TreeNode != null)
            {
                if (TreeNode.getValueType() == E_ValueType.VT_Container)
                {
                    result = ((DSRContainerTreeNode)TreeNode).setContinuityOfContent(continuityOfContent);
                }
            }

            return result;
        }

        /** get pointer to concept name.
        *  Code describing the concept represented by this content item.  Also conveys the value
        *  of document title and section headings in documents.
        *  Applicable to all content items (by-value only).
        ** @return pointer to comcept name value of current content item if valid, NULL otherwise
        */
        public DSRCodedEntryValue getConceptNamePtr()
        {
            //TODO: DSRContentItem
            DSRCodedEntryValue pointer = null;
            if (TreeNode != null)
            {
                //pointer = TreeNode.getConceptNamePtr();
            }

            return pointer;
        }

        /** get concept name.
        *  Code describing the concept represented by this content item.  Also conveys the value
        *  of document title and section headings in documents.
        *  Applicable to all content items (by-value only).
        ** @return concept name value of current content item if valid, EmptyCodedEntry otherwise
        */
        public DSRCodedEntryValue getConceptName()
        {
            if (TreeNode != null)
            {
                return TreeNode.getConceptName();
            }

            return null;
        }

        /** get copy of concept name.
        *  Code describing the concept represented by this content item.  Also conveys the value
        *  of document title and section headings in documents.
        *  Applicable to all content items (by-value only).
        ** @param  conceptName  variable where the copy should be stored (cleared if an error occurs)
        ** @return status, EC_Normal if successful, an error code otherwise
        */
        public E_Condition getConceptName(ref DSRCodedEntryValue conceptName)
        {
            E_Condition result = E_Condition.EC_IllegalCall;
            if (TreeNode != null)
            {
                result = TreeNode.getConceptName(ref conceptName);
            }
            else
            {
                conceptName.clear();
            }

            return result;
        }

        /** set concept name.
        *  Code describing the concept represented by this content item.  Also conveys the value
        *  of document title and section headings in documents.
        *  Applicable to all content items (by-value only, optional/conditional for some value types).
        ** @param  conceptName  value to be set
        ** @return status, EC_Normal if successful, an error code otherwise
        */
        public E_Condition setConceptName(ref DSRCodedEntryValue conceptName)
        {
            //TODO: DSRContentItem
            E_Condition result = E_Condition.EC_IllegalCall;
            if (TreeNode != null)
            {
                result = TreeNode.setConceptName(ref conceptName);
            }

            return result;
        }

        /** get observation date time.
        *  This is the date and time on which this content item was completed.  Might be empty
        *  if the date and time do not differ from the content date and time, see DSRDocument.
        *  Applicable to all content items (by-value only, optional attribute).
        ** @return observation date and time of current content item if valid, EmptyString otherwise
        */
        public string getObservationDateTime()
        {
            if (TreeNode != null)
            {
                return TreeNode.getObservationDateTime();
            }

            return null;
        }

        /** set observation date time.
        *  This is the date and time on which this content item was completed.  Might be empty
        *  if the date and time do not differ from the content date and time, see DSRDocument.
        *  Please use the correct DICOM format (VR=DT).
        *  Applicable to all content items (by-value only).
        ** @param  observationDateTime  value to be set (might be an empty string)
        ** @return status, EC_Normal if successful, an error code otherwise
        */
        public E_Condition setObservationDateTime(string observationDateTime)
        {
            E_Condition result = E_Condition.EC_IllegalCall;
            if (TreeNode != null)
            {
                result = TreeNode.setObservationDateTime(observationDateTime);
            }

            return result;
        }

        /** get template identifier and mapping resource.
        *  This value pair identifies the template that was used to create this content item
        *  (and its children).  According to the DICOM standard is is "required if a template
        *  was used to define the content of this Item, and the template consists of a single
        *  CONTAINER with nested content, and it is the outermost invocation of a set of
        *  nested templates that start with the same CONTAINER."  However, this condition is
        *  currently not checked.  The identification is valid if both values are either present
        *  (non-empty) or absent (empty).
        *  Applicable to all content items (by-value only, optional attribute).
        ** @param  templateIdentifier  identifier of the template (might be empty)
        *  @param  mappingResource     mapping resource that defines the template (might be empty)
        ** @return status, EC_Normal if successful, an error code otherwise
        */
        E_Condition getTemplateIdentification(ref string templateIdentifier, ref string mappingResource)
        {
            E_Condition result = E_Condition.EC_IllegalCall;
            if (TreeNode != null)
            {
                result = TreeNode.getTemplateIdentification(ref templateIdentifier, ref mappingResource);
            }

            return result;
        }

        /** set template identifier and mapping resource.
        *  The identification is valid if both values are either present (non-empty) or absent
        *  (empty).  See getTemplateIdentification() for details.
        *  Applicable to all content items (by-value only).
        ** @param  templateIdentifier  identifier of the template to be set (VR=CS)
        *  @param  mappingResource     mapping resource that defines the template (VR=CS)
        ** @return status, EC_Normal if successful, an error code otherwise
        */
        E_Condition setTemplateIdentification(ref string templateIdentifier, ref string mappingResource)
        {
            E_Condition result = E_Condition.EC_IllegalCall;
            if (TreeNode != null)
            {
                result = TreeNode.setTemplateIdentification(ref templateIdentifier, ref mappingResource);
            }

            return result;
        }

        public void setTreeNode(DSRDocumentTreeNode node)
        {
            TreeNode = node;
        }
    }
}
