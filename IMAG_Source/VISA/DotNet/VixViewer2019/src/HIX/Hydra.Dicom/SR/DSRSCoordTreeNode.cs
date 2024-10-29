﻿using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;
using System.Threading.Tasks;
using ClearCanvas.Dicom;

namespace Hydra.Dicom
{
    public class DSRSCoordTreeNode : DSRDocumentTreeNode/*, DSRSpatialCoordinatesValue*/
    {
        DSRSpatialCoordinatesValue itsDSRSpatialCoordinatesValue = null;

        /// <summary>
        /// Constructor
        /// </summary>
        /// <param name="relationshipType">type of relationship to the parent tree node.Should not be RT_invalid or RT_isRoot.</param>
        public DSRSCoordTreeNode(E_RelationshipType relationshipType)
            : base(relationshipType, E_ValueType.VT_SCoord)
        {
            itsDSRSpatialCoordinatesValue = new DSRSpatialCoordinatesValue();
        }

        /// <summary>
        /// clear all member variables.
        /// Please note that the content item might become invalid afterwards.
        /// </summary>
        public override void clear()
        {
            base.clear();
            itsDSRSpatialCoordinatesValue.clear();
        }

        /// <summary>
        /// check whether the content item is valid.
        /// The content item is valid if the two base classes are valid.
        /// </summary>
        /// <returns>true if tree node is valid, false otherwise</returns>
        public override bool isValid()
        {
            return base.isValid() && itsDSRSpatialCoordinatesValue.isValid();
        }

        /// <summary>
        /// check whether the content is short.
        /// The method isShort() from the base class DSRSpatialCoordinatesValue is called.
        /// </summary>
        /// <param name="flags">flag used to customize the output</param>
        /// <returns>true if the content is short, false otherwise</returns>
        public override bool isShort(int flags)
        {
            return itsDSRSpatialCoordinatesValue.isShort(flags);
        }

        /// <summary>
        /// print content item.
        /// A typical output looks like this: has properties SCOORD:(,,"SCoord Code")= (CIRCLE,0/0,255/255)
        /// </summary>
        /// <param name="stream">output stream to which the content item should be printed</param>
        /// <param name="flags">flag used to customize the output</param>
        /// <returns>true if successful, false otherwise</returns>
        public override E_Condition print(ref StringBuilder stream, int flags)
        {
            E_Condition result = base.print(ref stream, flags);
            if (result.good())
            {
                stream.Append("=");
                result = itsDSRSpatialCoordinatesValue.print(stream, flags);
            }
            return result;
        }

        /// <summary>
        /// write content item in XML format
        /// </summary>
        /// <param name="stream">output stream to which the XML document is written</param>
        /// <param name="flags">flag used to customize the output (see DSRTypes::XF_xxx)</param>
        /// <returns>true if successful, false otherwise</returns>
        public override E_Condition writeXML(ref StringBuilder stream, int flags)
        {
            E_Condition result = E_Condition.EC_Normal;
            writeXMLItemStart(ref stream, flags, false /*closingBracket*/);
            stream.Append(" type=\"");
            //TODO: DSRSCoordTreeNode: writeXML
            //stream.Append(graphicTypeToEnumeratedValue(getGraphicType()));
            stream.Append("\"");
            stream.Append(">");
            stream.AppendLine();
            result = base.writeXML(ref stream, flags);
            itsDSRSpatialCoordinatesValue.writeXML(stream, flags);
            writeXMLItemEnd(ref stream, flags);
            return result;
        }

        /// <summary>
        /// read content item (value) from dataset
        /// </summary>
        /// <param name="dataset">DICOM dataset from which the content item should be read</param>
        /// <returns>true if successful, false otherwise</returns>
        protected override E_Condition readContentItem(ref DicomAttributeCollection dataset)
        {
            /* read SpatialCoordinates */
            return itsDSRSpatialCoordinatesValue.read(dataset);
        }

        /// <summary>
        /// write content item (value) to dataset
        /// </summary>
        /// <param name="dataset">DICOM dataset to which the content item should be written</param>
        /// <returns>true if successful, false otherwise</returns>
        protected override E_Condition writeContentItem(DicomAttributeCollection dataset)
        {
            /* write SpatialCoordinates */
            return itsDSRSpatialCoordinatesValue.write(dataset);
        }

        /// <summary>
        /// read content item specific XML data
        /// </summary>
        /// <param name="doc">document containing the XML file content</param>
        /// <param name="cursor">cursor pointing to the starting node</param>
        /// <returns>true if successful, false otherwise</returns>
        protected override E_Condition readXMLContentItem(ref DSRXMLDocument doc, DSRXMLCursor cursor)
        {
            E_Condition result = E_Condition.SR_EC_CorruptedXMLStructure;
            if (cursor.valid())
            {
                string tmpString = "";
                /* read 'type' and check validity */
                DSRSpatialCoordinatesValue spatialCoordinatesValue = new DSRSpatialCoordinatesValue();
                result = spatialCoordinatesValue.setGraphicType(enumeratedValueToGraphicType(doc.getStringFromAttribute(cursor, ref tmpString, "type")));
                if (result.good())
                {
                    /* proceed reading the spatial coordinates */
                    result = itsDSRSpatialCoordinatesValue.readXML(doc, cursor);
                } else
                    printUnknownValueWarningMessage("SCOORD type", tmpString);
            }
            return result;
        }

        /// <summary>
        /// render content item (value) in HTML/XHTML format
        /// </summary>
        /// <param name="docStream">output stream to which the main HTML/XHTML document is written</param>
        /// <param name="annexStream">output stream to which the HTML/XHTML document annex is written</param>
        /// <param name="nestingLevel">current nesting level.  Used to render section headings.</param>
        /// <param name="annexNumber">reference to the variable where the current annex number is stored. Value is increased automatically by 1 after a new entry has been added.</param>
        /// <param name="flags">flag used to customize the output</param>
        /// <returns>true if successful, false otherwise</returns>
        protected override E_Condition renderHTMLContentItem(ref StringBuilder docStream, ref StringBuilder annexStream, int nestingLevel, ref int annexNumber, int flags)
        {
            /* render ConceptName */
            E_Condition result = renderHTMLConceptName(ref docStream, flags);
            /* render SpatialCoordinates */
            if (result.good())
            {
                result = itsDSRSpatialCoordinatesValue.renderHTML(docStream, annexStream, annexNumber, flags);
                docStream.AppendLine();
            }
            return result;
        }
    }
}
