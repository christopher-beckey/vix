using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;
using System.Threading.Tasks;

namespace Hydra.Dicom
{
    public class DSRIODConstraintChecker
    {
        public DSRIODConstraintChecker()
        {
        }

        /// <summary>
        /// 
        /// </summary>
        /// <returns></returns>
        public virtual bool isByReferenceAllowed()
        {
            return false;
        }

        /// <summary>
        /// 
        /// </summary>
        /// <returns></returns>
        public virtual bool isTemplateSupportRequired()
        {
            return true;
        }

        /// <summary>
        /// 
        /// </summary>
        /// <returns></returns>
        public virtual string getRootTemplateIdentifier()
        {
            return null;
        }

        /// <summary>
        /// 
        /// </summary>
        /// <returns></returns>
        public virtual E_DocumentType getDocumentType()
        {
            return E_DocumentType.DT_invalid;
        }

        /// <summary>
        /// 
        /// </summary>
        /// <param name="sourceValueType"></param>
        /// <param name="relationshipType"></param>
        /// <param name="targetValueType"></param>
        /// <param name="byReference"></param>
        /// <returns></returns>
        public virtual bool checkContentRelationship(E_ValueType sourceValueType,
                                                                             E_RelationshipType relationshipType,
                                                                             E_ValueType targetValueType,
                                                                             bool byReference = false)
        {
            return true;
        }
    }
}
