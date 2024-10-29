using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;
using System.Threading.Tasks;

namespace Hydra.Dicom
{
    public class DSRColonCadSRConstraintChecker : DSRIODConstraintChecker
    {
        /// <summary>
        /// 
        /// </summary>
        public DSRColonCadSRConstraintChecker()
        {
        }

        /// <summary>
        /// 
        /// </summary>
        /// <returns></returns>
        public override bool isByReferenceAllowed()
        {
            return true;
        }

        /// <summary>
        /// 
        /// </summary>
        /// <returns></returns>
        public override bool isTemplateSupportRequired()
        {
            return true;
        }

        /// <summary>
        /// 
        /// </summary>
        /// <returns></returns>
        public override string getRootTemplateIdentifier()
        {
            return "4120";
        }

        /// <summary>
        /// 
        /// </summary>
        /// <returns></returns>
        public override E_DocumentType getDocumentType()
        {
            return E_DocumentType.DT_ColonCadSR;
        }

        /// <summary>
        /// 
        /// </summary>
        /// <param name="sourceValueType"></param>
        /// <param name="relationshipType"></param>
        /// <param name="targetValueType"></param>
        /// <param name="byReference"></param>
        /// <returns></returns>
        public override bool checkContentRelationship(E_ValueType sourceValueType, E_RelationshipType relationshipType, E_ValueType targetValueType, bool byReference = false)
        {
            /* the following code implements the constraints of table A.35.10-2 in DICOM PS3.3 */
            bool result = false;
            /* row 1 of the table */
            if ((relationshipType == E_RelationshipType.RT_contains) && !byReference && (sourceValueType == E_ValueType.VT_Container))
            {
                result = (targetValueType == E_ValueType.VT_Code) || (targetValueType == E_ValueType.VT_Num) || (targetValueType == E_ValueType.VT_Image) ||
                         (targetValueType == E_ValueType.VT_Container) || (targetValueType == E_ValueType.VT_UIDRef) || (targetValueType == E_ValueType.VT_Date) ||
                         (targetValueType == E_ValueType.VT_Time);
            }
            /* row 2 of the table */
            else if ((relationshipType == E_RelationshipType.RT_hasObsContext) && !byReference && ((sourceValueType == E_ValueType.VT_Container) ||
                (sourceValueType == E_ValueType.VT_Text) || (sourceValueType == E_ValueType.VT_Code) || (sourceValueType == E_ValueType.VT_Num)))
            {
                result = (targetValueType == E_ValueType.VT_Text) || (targetValueType == E_ValueType.VT_Code) || (targetValueType == E_ValueType.VT_Num) ||
                         (targetValueType == E_ValueType.VT_Date) || (targetValueType == E_ValueType.VT_Time) || (targetValueType == E_ValueType.VT_PName) ||
                         (targetValueType == E_ValueType.VT_UIDRef) || (targetValueType == E_ValueType.VT_Composite);
            }
            /* row 3 of the table */
            else if ((relationshipType == E_RelationshipType.RT_hasAcqContext) && (sourceValueType == E_ValueType.VT_Image))
            {
                /* by-reference allowed */
                result = (targetValueType == E_ValueType.VT_Text) || (targetValueType == E_ValueType.VT_Code) || (targetValueType == E_ValueType.VT_Date) ||
                         (targetValueType == E_ValueType.VT_Time) || (targetValueType == E_ValueType.VT_Num) || (targetValueType == E_ValueType.VT_Container);
            }
            /* row 4 of the table */
            else if ((relationshipType == E_RelationshipType.RT_hasConceptMod) && !byReference && ((sourceValueType == E_ValueType.VT_Container) ||
                (sourceValueType == E_ValueType.VT_Code) || (sourceValueType == E_ValueType.VT_Composite) || (sourceValueType == E_ValueType.VT_Num)))
            {
                result = (targetValueType == E_ValueType.VT_Text) || (targetValueType == E_ValueType.VT_Code);
            }
            /* row 5 the table */
            else if ((relationshipType == E_RelationshipType.RT_hasProperties) && !byReference &&
                ((sourceValueType == E_ValueType.VT_Text) || (sourceValueType == E_ValueType.VT_Code) || (sourceValueType == E_ValueType.VT_Num)))
            {
                result = (targetValueType == E_ValueType.VT_Container) || (targetValueType == E_ValueType.VT_Text) || (targetValueType == E_ValueType.VT_Code) ||
                         (targetValueType == E_ValueType.VT_Num) || (targetValueType == E_ValueType.VT_Date) || (targetValueType == E_ValueType.VT_Image) ||
                         (targetValueType == E_ValueType.VT_SCoord) || (targetValueType == E_ValueType.VT_SCoord3D) || (targetValueType == E_ValueType.VT_UIDRef);
            }
            /* row 6 of the table */
            else if ((relationshipType == E_RelationshipType.RT_inferredFrom) && ((sourceValueType == E_ValueType.VT_Code) || (sourceValueType == E_ValueType.VT_Num)))
            {
                /* by-reference allowed */
                result = (targetValueType == E_ValueType.VT_Code) || (targetValueType == E_ValueType.VT_Num) || (targetValueType == E_ValueType.VT_Image) ||
                         (targetValueType == E_ValueType.VT_SCoord) || (targetValueType == E_ValueType.VT_SCoord3D) || (targetValueType == E_ValueType.VT_Container) ||
                         (targetValueType == E_ValueType.VT_Text);
            }
            /* row 7 of the table */
            else if ((relationshipType == E_RelationshipType.RT_selectedFrom) && !byReference && (sourceValueType == E_ValueType.VT_SCoord))
            {
                result = (targetValueType == E_ValueType.VT_Image);
            }

            return result;
        }
    }
}
