using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;
using System.Threading.Tasks;

namespace Hydra.Dicom
{
    public class DSRBasicTextSRConstraintChecker : DSRIODConstraintChecker
    {
        /// <summary>
        /// 
        /// </summary>
        public DSRBasicTextSRConstraintChecker()
        {

        }

        /// <summary>
        /// 
        /// </summary>
        /// <returns></returns>
        bool isByReferenceAllowed()
        {
            return false;
        }

        /// <summary>
        /// 
        /// </summary>
        /// <returns></returns>
        public override bool isTemplateSupportRequired()
        {
            return false;
        }

        /// <summary>
        /// 
        /// </summary>
        /// <returns></returns>
        public override string getRootTemplateIdentifier()
        {
            return null;
        }

        /// <summary>
        /// 
        /// </summary>
        /// <returns></returns>
        public override E_DocumentType getDocumentType()
        {
            return E_DocumentType.DT_BasicTextSR;
        }

        /// <summary>
        /// 
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
            /* the following code implements the constraints of table A.35.1-2 in DICOM PS3.3 */
            bool result = false;
            /* by-reference relationships not allowed at all */
            if (!byReference)
            {
                /* row 1 of the table */
                if ((relationshipType == E_RelationshipType.RT_contains) && (sourceValueType == E_ValueType.VT_Container))
                {
                    result = (targetValueType == E_ValueType.VT_Text) || (targetValueType == E_ValueType.VT_Code) || (targetValueType == E_ValueType.VT_DateTime) ||
                             (targetValueType == E_ValueType.VT_Date) || (targetValueType == E_ValueType.VT_Time) || (targetValueType == E_ValueType.VT_UIDRef) ||
                             (targetValueType == E_ValueType.VT_PName) || (targetValueType == E_ValueType.VT_Composite) || (targetValueType == E_ValueType.VT_Image) ||
                             (targetValueType == E_ValueType.VT_Waveform) || (targetValueType == E_ValueType.VT_Container);
                }
                /* row 2 of the table */
                else if ((relationshipType == E_RelationshipType.RT_hasObsContext) && (sourceValueType == E_ValueType.VT_Container))
                {
                    result = (targetValueType == E_ValueType.VT_Text) || (targetValueType == E_ValueType.VT_Code) || (targetValueType == E_ValueType.VT_DateTime) ||
                             (targetValueType == E_ValueType.VT_Date) || (targetValueType == E_ValueType.VT_Time) || (targetValueType == E_ValueType.VT_UIDRef) ||
                             (targetValueType == E_ValueType.VT_PName) || (targetValueType == E_ValueType.VT_Composite);
                }
                /* row 3 of the table */
                else if ((relationshipType == E_RelationshipType.RT_hasAcqContext) && ((sourceValueType == E_ValueType.VT_Container) ||
                    (sourceValueType == E_ValueType.VT_Image) || (sourceValueType == E_ValueType.VT_Waveform) || (sourceValueType == E_ValueType.VT_Composite)))
                {
                    result = (targetValueType == E_ValueType.VT_Text) || (targetValueType == E_ValueType.VT_Code) || (targetValueType == E_ValueType.VT_DateTime) ||
                             (targetValueType == E_ValueType.VT_Date) || (targetValueType == E_ValueType.VT_Time) || (targetValueType == E_ValueType.VT_UIDRef) ||
                             (targetValueType == E_ValueType.VT_PName);
                }
                /* row 4 of the table */
                else if (relationshipType == E_RelationshipType.RT_hasConceptMod)
                {
                    result = (targetValueType == E_ValueType.VT_Text) || (targetValueType == E_ValueType.VT_Code);
                }
                /* row 5 and 6 of the table */
                else if (((relationshipType == E_RelationshipType.RT_hasProperties) || (relationshipType == E_RelationshipType.RT_inferredFrom)) &&
                    (sourceValueType == E_ValueType.VT_Text))
                {
                    result = (targetValueType == E_ValueType.VT_Text) || (targetValueType == E_ValueType.VT_Code) || (targetValueType == E_ValueType.VT_DateTime) ||
                             (targetValueType == E_ValueType.VT_Date) || (targetValueType == E_ValueType.VT_Time) || (targetValueType == E_ValueType.VT_UIDRef) ||
                             (targetValueType == E_ValueType.VT_PName) || (targetValueType == E_ValueType.VT_Composite) || (targetValueType == E_ValueType.VT_Image) ||
                             (targetValueType == E_ValueType.VT_Waveform);
                }
            }

            return result;
        }
    }
}
