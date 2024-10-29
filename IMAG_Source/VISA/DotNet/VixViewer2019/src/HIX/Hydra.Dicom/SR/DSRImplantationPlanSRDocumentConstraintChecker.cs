using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;
using System.Threading.Tasks;

namespace Hydra.Dicom
{
    public class DSRImplantationPlanSRDocumentConstraintChecker : DSRIODConstraintChecker
    {
        /// <summary>
        /// constructor
        /// </summary>
        public DSRImplantationPlanSRDocumentConstraintChecker()
        {
        }

        /// <summary>
        /// Destructor
        /// </summary>
        ~DSRImplantationPlanSRDocumentConstraintChecker()
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
            return true;
        }

        /// <summary>
        /// Gets the root template identifier
        /// </summary>
        /// <returns></returns>
        public override string getRootTemplateIdentifier()
        {
            return "7000";
        }

        /// <summary>
        /// Gets the document type
        /// </summary>
        /// <returns></returns>
        public override E_DocumentType getDocumentType()
        {
            return E_DocumentType.DT_ImplantationPlanSRDocument;
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
            /* the following code implements the constraints of table A.35.Y-2 in DICOM PS3.3 (Supplement 134) */
            bool result = false;
            /* by-reference relationships not allowed at all */
            if (!byReference)
            {
                /* row 1 of the table */
                if ((relationshipType == E_RelationshipType.RT_contains) && (sourceValueType == E_ValueType.VT_Container))
                {
                    result = (targetValueType == E_ValueType.VT_Text) || (targetValueType == E_ValueType.VT_Code) || (targetValueType == E_ValueType.VT_Num) ||
                             (targetValueType == E_ValueType.VT_UIDRef) || (targetValueType == E_ValueType.VT_Composite) || (targetValueType == E_ValueType.VT_Image) ||
                             (targetValueType == E_ValueType.VT_Container);
                }
                /* row 2 of the table */
                else if ((relationshipType == E_RelationshipType.RT_hasObsContext) && (sourceValueType == E_ValueType.VT_Container))
                {
                    result = (targetValueType == E_ValueType.VT_Text) || (targetValueType == E_ValueType.VT_Code) || (targetValueType == E_ValueType.VT_Num) ||
                             (targetValueType == E_ValueType.VT_Date) || (targetValueType == E_ValueType.VT_UIDRef) || (targetValueType == E_ValueType.VT_PName) ||
                             (targetValueType == E_ValueType.VT_Composite);
                }
                /* row 3 of the table */
                else if (relationshipType == E_RelationshipType.RT_hasConceptMod)
                {
                    result = (targetValueType == E_ValueType.VT_Text) || (targetValueType == E_ValueType.VT_Code);
                }
                /* row 4 of the table */
                else if ((relationshipType == E_RelationshipType.RT_hasProperties) &&
                    ((sourceValueType == E_ValueType.VT_Text) || (sourceValueType == E_ValueType.VT_Code) || (sourceValueType == E_ValueType.VT_Num) ||
                    (sourceValueType == E_ValueType.VT_Image) || (sourceValueType == E_ValueType.VT_UIDRef) || (sourceValueType == E_ValueType.VT_Composite)))
                {
                    result = (targetValueType == E_ValueType.VT_Composite);
                }
            }

            return result;
        }
    }
}
