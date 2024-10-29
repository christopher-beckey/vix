using ClearCanvas.Dicom;
using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;
using System.Threading.Tasks;

namespace Hydra.Dicom
{
    public class DSRUIDRefTreeNode : DSRDocumentTreeNode
    {
        DSRStringValue dsrStringValue = null;
        /// <summary>
        /// constructor
        /// </summary>
        public DSRUIDRefTreeNode()
        {
            dsrStringValue = new DSRStringValue();
        }

        /// <summary>
        /// declaration of default/copy constructor
        /// </summary>
        /// <param name="theDSRCompositeTreeNode"></param>
        public DSRUIDRefTreeNode(DSRCompositeTreeNode theDSRUIDRefTreeNode)
        {
            dsrStringValue = new DSRStringValue();
        }

        /// <summary>
        /// constructor
        /// </summary>
        /// <param name="relationshipType"></param>
        public DSRUIDRefTreeNode(E_RelationshipType relationshipType)
            : base(relationshipType, E_ValueType.VT_UIDRef)
        {
            dsrStringValue = new DSRStringValue();
        }

        /// <summary>
        /// constructor
        /// </summary>
        /// <param name="relationshipType"></param>
        /// <param name="stringValue"></param>
        public DSRUIDRefTreeNode(E_RelationshipType relationshipType, ref string stringValue)
            : base(relationshipType, E_ValueType.VT_UIDRef)
        {
            dsrStringValue = new DSRStringValue();
        }

        /// <summary>
        /// destructor
        /// </summary>
        ~DSRUIDRefTreeNode()
        {
            dsrStringValue = null;
        }

        /// <summary>
        /// clear all member variables. Please note that the content item might become invalid afterwards.
        /// </summary>
        public override void clear()
        {
            base.clear();
            dsrStringValue.clear();
        }

        /// <summary>
        /// check whether the content item is valid. The content item is valid if the two base classes are valid.
        /// </summary>
        /// <returns> true if tree node is valid, false otherwise </returns>
        public override bool isValid()
        {
            /* ConceptNameCodeSequence required */
            return base.isValid() && dsrStringValue.isValid() && getConceptName().isValid();
        }

        /// <summary>
        /// print content item. A typical output looks like this:  contains UIDREF:(,,"Code")="1.2.3.4.5"
        /// </summary>
        /// <param name="stream"></param>
        /// <param name="flags"></param>
        /// <returns> status, EC_Normal if successful, an error code otherwise </returns>
        public override E_Condition print(ref StringBuilder stream, int flags)
        {
            E_Condition result = base.print(ref stream, flags);
            if (result.good())
            {
                stream.Append("=");
                dsrStringValue.print(ref stream);
            }
            return result;
        }

        /// <summary>
        /// write content item in XML format
        /// </summary>
        /// <param name="stream"></param>
        /// <param name="flags"></param>
        /// <returns> status, EC_Normal if successful, an error code otherwise </returns>
        public override E_Condition writeXML(ref StringBuilder stream, int flags)
        {
            E_Condition result = E_Condition.EC_Normal;
            writeXMLItemStart(ref stream, flags);
            result = base.writeXML(ref stream, flags);
            writeStringValueToXML(stream, dsrStringValue.getValue(), "value", (flags & XF_writeEmptyTags) > 0);
            writeXMLItemEnd(ref stream, flags);
            return result;
        }

        public E_Condition setValue(string value)
        {
            return dsrStringValue.setValue(value);
        }

        public string getValue()
        {
            return dsrStringValue.getValue();
        }

        /// <summary>
        /// read content item (value) from dataset
        /// </summary>
        /// <param name="dataset"></param>
        /// <returns> status, EC_Normal if successful, an error code otherwise </returns>
        protected override E_Condition readContentItem(ref DicomAttributeCollection dataset)
        {
            /* read UID */
            return dsrStringValue.read(dataset, getDicomAttribute(DicomTags.Uid));
        }

        /// <summary>
        /// write content item (value) to dataset.
        /// </summary>
        /// <param name="dataset"></param>
        /// <returns> status, EC_Normal if successful, an error code otherwise </returns>
        protected override E_Condition writeContentItem(DicomAttributeCollection dataset)
        {
            /* write UID */
            return dsrStringValue.write(ref dataset, getDicomAttribute(DicomTags.Uid));
        }

        /// <summary>
        /// read content item specific XML data.
        /// </summary>
        /// <param name="doc"></param>
        /// <param name="cursor"></param>
        /// <returns> status, EC_Normal if successful, an error code otherwise </returns>
        protected override E_Condition readXMLContentItem(ref DSRXMLDocument doc, DSRXMLCursor cursor)
        {
            /* retrieve value from XML element "value" */
            return dsrStringValue.readXML(ref doc, doc.getNamedNode(cursor.gotoChild(), "value"));
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
            /* render ConceptName */
            E_Condition result = renderHTMLConceptName(ref docStream, flags);
            /* render UID */
            if (result.good())
            {
                result = dsrStringValue.renderHTML(ref docStream, flags);
                docStream.AppendLine();
            }
            return result;
        }

    }
}
