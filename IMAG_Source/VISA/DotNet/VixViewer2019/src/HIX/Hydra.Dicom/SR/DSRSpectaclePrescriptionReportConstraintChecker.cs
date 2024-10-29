using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;
using System.Threading.Tasks;

namespace Hydra.Dicom
{
    public class DSRSpectaclePrescriptionReportConstraintChecker : DSRIODConstraintChecker
    {
        /// <summary>
        /// constructor
        /// </summary>
        public DSRSpectaclePrescriptionReportConstraintChecker()
        {
        }

        /// <summary>
        /// Destructor
        /// </summary>
        ~DSRSpectaclePrescriptionReportConstraintChecker()
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
        public override string getRootTemplateIdentifier()
        {
            return "2020";
        }

        /// <summary>
        /// Gets the document type
        /// </summary>
        /// <returns></returns>
        public override E_DocumentType getDocumentType()
        {
            return E_DocumentType.DT_SpectaclePrescriptionReport;
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
            /* the following code implements the constraints of table A.35.9-2 in DICOM PS3.3 */
            bool result = false;
            /* by-reference relationships not allowed at all */
            if (!byReference)
            {
                /* row 1 of the table */
                if ((relationshipType == E_RelationshipType.RT_contains) && (sourceValueType == E_ValueType.VT_Container))
                {
                    result = (targetValueType == E_ValueType.VT_Container) || (targetValueType == E_ValueType.VT_Code) ||
                             (targetValueType == E_ValueType.VT_Num) || (targetValueType == E_ValueType.VT_Text);
                }
            }

            return result;
        }
    }
}
