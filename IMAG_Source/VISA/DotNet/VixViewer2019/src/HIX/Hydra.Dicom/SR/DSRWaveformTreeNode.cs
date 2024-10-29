using ClearCanvas.Dicom;
using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;
using System.Threading.Tasks;

namespace Hydra.Dicom
{
    public class DSRWaveformTreeNode : DSRDocumentTreeNode /*, DSRWaveformReferenceValue*/
    {
        DSRWaveformReferenceValue itsDSRWaveformReferenceValue = null;

         /// <summary>
        /// default constructor
        /// </summary>
        public DSRWaveformTreeNode()
        {
            itsDSRWaveformReferenceValue = new DSRWaveformReferenceValue();
        }

        /// <summary>
        /// constructor
        /// </summary>
        /// <param name="relationshipType"></param>
        public DSRWaveformTreeNode(E_RelationshipType relationshipType)
            : base(relationshipType, E_ValueType.VT_Waveform)
        {
            itsDSRWaveformReferenceValue = new DSRWaveformReferenceValue();
        }

        /// <summary>
        /// copy constructor
        /// </summary>
        /// <param name="theDSRWaveformTreeNode"></param>
        public DSRWaveformTreeNode(ref DSRWaveformTreeNode theDSRWaveformTreeNode)
        {
            itsDSRWaveformReferenceValue = new DSRWaveformReferenceValue();
        }

        /// <summary>
        /// destructor
        /// </summary>
        ~DSRWaveformTreeNode()
        {

        }

        /// <summary>
        /// clear all member variables. Please note that the content item might become invalid afterwards.
        /// </summary>
        public override void clear()
        {
            base.clear();
            itsDSRWaveformReferenceValue.clear();
        }

        /// <summary>
        /// check whether the content item is valid. 
        /// The content item is valid if the two base classes are valid.
        /// </summary>
        /// <returns> true if tree node is valid, false otherwise </returns>
        public override bool isValid()
        {
            return base.isValid() && itsDSRWaveformReferenceValue.isValid();
        }

        /// <summary>
        /// check whether the content is short.
        /// The method isShort() from the base class DSRWaveformReferenceValue is called.
        /// </summary>
        /// <returns> true if tree node is valid, false otherwise </returns>
        public override bool isShort(int flags)
        {
            return base.isValid() && itsDSRWaveformReferenceValue.isValid();
        }

        /// <summary>
        /// print content item.
        /// A typical output looks like this: has properties WAVEFORM:=(HemodynamicWaveform Storage,"1.2.3")
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
                result = itsDSRWaveformReferenceValue.print(ref stream, flags);
            }
            return result;
        }

        /// <summary>
        /// write content item in XML format.
        /// </summary>
        /// <param name="stream"></param>
        /// <param name="flags"></param>
        /// <returns> status, EC_Normal if successful, an error code otherwise </returns>
        public override E_Condition writeXML(ref StringBuilder stream, int flags)
        {
            E_Condition result = E_Condition.EC_Normal;
            writeXMLItemStart(ref stream, flags);
            result = base.writeXML(ref stream, flags);
            stream.Append("<value>");
            stream.AppendLine();
            itsDSRWaveformReferenceValue.writeXML(ref stream, flags);
            stream.Append("</value>");
            stream.AppendLine();
            writeXMLItemEnd(ref stream, flags);
            return result;
        }

        /// <summary>
        /// read content item (value) from dataset
        /// </summary>
        /// <param name="dataset"></param>
        /// <returns> status, EC_Normal if successful, an error code otherwise </returns>
        protected override E_Condition readContentItem(ref DicomAttributeCollection dataset)
        {
            /* read ReferencedSOPSequence */
            return itsDSRWaveformReferenceValue.readSequence(ref dataset, "1" /*type*/);
        }

        /// <summary>
        /// write content item (value) to dataset.
        /// </summary>
        /// <param name="dataset"></param>
        /// <returns> status, EC_Normal if successful, an error code otherwise </returns>
        protected override E_Condition writeContentItem(DicomAttributeCollection dataset)
        {
            /* write ReferencedSOPSequence */
            return itsDSRWaveformReferenceValue.writeSequence(ref dataset);
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
            return itsDSRWaveformReferenceValue.readXML(ref doc, doc.getNamedNode(cursor.gotoChild(), "value"));
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
            /* render Reference */
            if (result.good())
            {
                result = itsDSRWaveformReferenceValue.renderHTML(ref docStream, ref annexStream, ref annexNumber, flags);
                docStream.AppendLine();
            }
            return result;
        }
    }
}
