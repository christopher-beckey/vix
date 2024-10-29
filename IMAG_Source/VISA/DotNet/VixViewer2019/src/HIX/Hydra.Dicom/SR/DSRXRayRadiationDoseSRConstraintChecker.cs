using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;
using System.Threading.Tasks;

namespace Hydra.Dicom
{
    public class DSRXRayRadiationDoseSRConstraintChecker : DSRIODConstraintChecker
    {
        /// <summary>
        /// constructor
        /// </summary>
        public DSRXRayRadiationDoseSRConstraintChecker()
        {
        }

        /// <summary>
        /// Destructor
        /// </summary>
        ~DSRXRayRadiationDoseSRConstraintChecker()
        {
        }

        /// <summary>
        /// is by reference allowed or not
        /// </summary>
        /// <returns></returns>
        public override bool isByReferenceAllowed()
        {
            return false;
        }

        /// <summary>
        /// is template support required or not
        /// </summary>
        /// <returns></returns>
        public override bool isTemplateSupportRequired()
        {
            return false;
        }

        /// <summary>
        /// Gets the root template identifier
        /// </summary>
        /// <returns></returns>
        public override string getRootTemplateIdentifier()
        {
            return null;
        }

        /// <summary>
        /// Gets the document type
        /// </summary>
        /// <returns></returns>
        public override E_DocumentType getDocumentType()
        {
            return E_DocumentType.DT_XRayRadiationDoseSR;
        }

        /// <summary>
        /// Checks the content relationship
        /// </summary>
        /// <param name="sourceValueType"></param>
        /// <param name="relationshipType"></param>
        /// <param name="targetValueType"></param>
        /// <param name="byReference"></param>
        /// <returns></returns>
        public override bool checkContentRelationship(E_ValueType sourceValueType,
                                                     E_RelationshipType relationshipType,
                                                     E_ValueType targetValueType,
                                                     bool byReference = false)
        {
            /* the following code implements the constraints of table A.35.8-2 in DICOM PS3.3 */
            bool result = false;
            /* by-reference relationships not allowed at all */
            if (!byReference)
            {
                /* row 1 of the table */
                if ((relationshipType == E_RelationshipType.RT_contains) && (sourceValueType == E_ValueType.VT_Container))
                {
                    result = (targetValueType == E_ValueType.VT_Text) || (targetValueType == E_ValueType.VT_Code) || (targetValueType == E_ValueType.VT_Num) ||
                             (targetValueType == E_ValueType.VT_DateTime) || (targetValueType == E_ValueType.VT_UIDRef) || (targetValueType == E_ValueType.VT_PName) ||
                             (targetValueType == E_ValueType.VT_Image) || (targetValueType == E_ValueType.VT_Composite) || (targetValueType == E_ValueType.VT_Container);
                }
                /* row 2 of the table */
                else if ((relationshipType == E_RelationshipType.RT_hasObsContext) && (sourceValueType == E_ValueType.VT_Container))
                {
                    result = (targetValueType == E_ValueType.VT_Text) || (targetValueType == E_ValueType.VT_Code) || (targetValueType == E_ValueType.VT_DateTime) ||
                             (targetValueType == E_ValueType.VT_UIDRef) || (targetValueType == E_ValueType.VT_PName);
                }
                /* row 3 of the table */
                else if ((relationshipType == E_RelationshipType.RT_hasObsContext) && ((sourceValueType == E_ValueType.VT_Text) || (sourceValueType == E_ValueType.VT_Code) ||
                    (sourceValueType == E_ValueType.VT_Num)))
                {
                    result = (targetValueType == E_ValueType.VT_Text) || (targetValueType == E_ValueType.VT_Code) || (targetValueType == E_ValueType.VT_Num) ||
                             (targetValueType == E_ValueType.VT_DateTime) || (targetValueType == E_ValueType.VT_UIDRef) || (targetValueType == E_ValueType.VT_PName) ||
                             (targetValueType == E_ValueType.VT_Composite);
                }
                /* row 4 of the table */
                else if ((relationshipType == E_RelationshipType.RT_hasAcqContext) && ((sourceValueType == E_ValueType.VT_Container) || (sourceValueType == E_ValueType.VT_Image) ||
                    (sourceValueType == E_ValueType.VT_Composite)))
                {
                    result = (targetValueType == E_ValueType.VT_Text) || (targetValueType == E_ValueType.VT_Code) || (targetValueType == E_ValueType.VT_Num) ||
                             (targetValueType == E_ValueType.VT_DateTime) || (targetValueType == E_ValueType.VT_UIDRef) || (targetValueType == E_ValueType.VT_PName) ||
                             (targetValueType == E_ValueType.VT_Container);
                }
                /* row 5 of the table */
                else if (relationshipType == E_RelationshipType.RT_hasConceptMod)
                {
                    result = (targetValueType == E_ValueType.VT_Text) || (targetValueType == E_ValueType.VT_Code);
                }
                /* row 6 of the table */
                else if ((relationshipType == E_RelationshipType.RT_hasProperties) && ((sourceValueType == E_ValueType.VT_Text) || (sourceValueType == E_ValueType.VT_Code) ||
                    (sourceValueType == E_ValueType.VT_Num)))
                {
                    result = (targetValueType == E_ValueType.VT_Text) || (targetValueType == E_ValueType.VT_Code) || (targetValueType == E_ValueType.VT_Num) ||
                             (targetValueType == E_ValueType.VT_DateTime) || (targetValueType == E_ValueType.VT_UIDRef) || (targetValueType == E_ValueType.VT_PName) ||
                             (targetValueType == E_ValueType.VT_Image) || (targetValueType == E_ValueType.VT_Composite) || (targetValueType == E_ValueType.VT_Container);
                }
                /* row 7 of the table */
                else if ((relationshipType == E_RelationshipType.RT_inferredFrom) && ((sourceValueType == E_ValueType.VT_Text) || (sourceValueType == E_ValueType.VT_Code) ||
                    (sourceValueType == E_ValueType.VT_Num)))
                {
                    result = (targetValueType == E_ValueType.VT_Text) || (targetValueType == E_ValueType.VT_Code) || (targetValueType == E_ValueType.VT_Num) ||
                             (targetValueType == E_ValueType.VT_DateTime) || (targetValueType == E_ValueType.VT_UIDRef) || (targetValueType == E_ValueType.VT_Image) ||
                             (targetValueType == E_ValueType.VT_Composite) || (targetValueType == E_ValueType.VT_Container);
                }
            }

            return result;
        }
    }
}
