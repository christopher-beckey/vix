using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;
using System.Threading.Tasks;
using ClearCanvas.Dicom;

namespace Hydra.Dicom
{
    public class DSRSpatialCoordinates3DValue
    {
        private E_GraphicType3D GraphicType;

        private string FrameOfReferenceUID;

        private DSRGraphicData3DList GraphicDataList;

        /// <summary>
        /// Default Constructor
        /// </summary>
        public DSRSpatialCoordinates3DValue()
        {
            GraphicType = E_GraphicType3D.GT3_invalid;
            GraphicDataList = new DSRGraphicData3DList();
            FrameOfReferenceUID = string.Empty;
        }

        /// <summary>
        /// Constructor
        /// </summary>
        /// <param name="graphicType">graphic type specifying the geometry of the coordinates</param>
        public DSRSpatialCoordinates3DValue(E_GraphicType3D graphicType)
        {
            GraphicType = graphicType;
            GraphicDataList = new DSRGraphicData3DList();
            FrameOfReferenceUID = string.Empty;
        }

        /// <summary>
        /// Copy Constructor
        /// </summary>
        /// <param name="coordinatesValue">spatial coordinates value to be copied</param>
        public DSRSpatialCoordinates3DValue(DSRSpatialCoordinates3DValue coordinatesValue)
        {
            GraphicType = coordinatesValue.GraphicType;
            GraphicDataList = coordinatesValue.GraphicDataList;
            FrameOfReferenceUID = coordinatesValue.FrameOfReferenceUID;
        }

        /// <summary>
        /// clear all internal variables.
        /// Graphic type is set to GT3_invalid.  Since an empty list of graphic data is invalid
        /// the spatial coordinates value becomes invalid afterwards.
        /// </summary>
        public virtual void clear()
        {
            GraphicType = E_GraphicType3D.GT3_invalid;
            GraphicDataList.clear();
            FrameOfReferenceUID = string.Empty;
        }

        /// <summary>
        /// check whether the current spatial coordinates value is valid.
        /// The value is valid if the graphic type is not GT3_invalid and the graphic data is
        /// valid (see checkData() for details).
        /// </summary>
        /// <returns>true if reference value is valid, false otherwise</returns>
        public virtual bool isValid()
        {
            return checkData(GraphicType, GraphicDataList, FrameOfReferenceUID);
        }

        /// <summary>
        /// check whether the content is short.
        /// This method is used to check whether the rendered output of this content item can be
        /// expanded inline or not (used for renderHTML()).
        /// </summary>
        /// <param name="flags">flag used to customize the output (see DSRTypes::HF_xxx)</param>
        /// <returns>true if the content is short, false otherwise</returns>
        public virtual bool isShort(int flags)
        {
            return ((GraphicDataList.isEmpty()) || ((flags & DSRTypes.HF_renderFullData) == 0));
        }

        /// <summary>
        /// print spatial coordinates.
        /// The output of a typical spatial coordinates value looks like this: (POINT,,100/100/100).
        /// </summary>
        /// <param name="stream">output stream to which the spatial coordinates value should be printed</param>
        /// <param name="flags">flag used to customize the output (see DSRTypes::PF_xxx)</param>
        /// <returns>true if successful, false otherwise</returns>
        public virtual E_Condition print(StringBuilder stream, int flags)
        {
            /* GraphicType */
            stream.Append(string.Format("{0}{1}", "(", DSRTypes.graphicType3DToEnumeratedValue(GraphicType)));
            /* ReferencedFrameOfReferenceUID */
            stream.Append(",");
            if ((flags & DSRTypes.PF_printSOPInstanceUID) != 0)
            {
                stream.Append(string.Format("{0}{1}{2}", "\\", FrameOfReferenceUID,"\\"));
            }
            /* GraphicData */
            if (!GraphicDataList.isEmpty())
            {
                stream.Append(",");
                GraphicDataList.print(ref stream, flags);
            }
            stream.Append(")");
            return E_Condition.EC_Normal;
        }

        /// <summary>
        /// read spatial coordinates value from dataset
        /// </summary>
        /// <param name="dataset">DICOM dataset from which the value should be read</param>
        /// <returns>true if successful, false otherwise</returns>
        public virtual E_Condition read(DicomAttributeCollection dataset)
        {
            string tmpString = string.Empty;
            E_Condition result = DSRTypes.getAndCheckStringValueFromDataset(dataset, DSRTypes.getDicomAttribute(DicomTags.ReferencedFrameOfReferenceUid), ref tmpString, "1", "1", "SCOORD content item");
            if (result.good())
            {
                result = DSRTypes.getAndCheckStringValueFromDataset(dataset, DSRTypes.getDicomAttribute(DicomTags.GraphicType), ref tmpString, "1", "1", "SCOORD3D content item");
            }
            if (result.good())
            {
                GraphicType = DSRTypes.enumeratedValueToGraphicType3D(tmpString);
                /* check GraphicType */
                if (GraphicType == E_GraphicType3D.GT3_invalid)
                    DSRTypes.printUnknownValueWarningMessage("GraphicType", tmpString);
                /* read GraphicData */
                result = GraphicDataList.read(ref dataset);
                /* check GraphicData and report warnings if any */
                checkData(GraphicType, GraphicDataList,FrameOfReferenceUID);
            }
            return result;
        }

        /// <summary>
        /// write spatial coordinates reference value to dataset
        /// </summary>
        /// <param name="dataset">DICOM dataset to which the value should be written</param>
        /// <returns>true if successful, false otherwise</returns>
        public virtual E_Condition write(DicomAttributeCollection dataset)
        {
            E_Condition result = DSRTypes.putStringValueToDataset(dataset, DSRTypes.getDicomAttribute(DicomTags.ReferencedFrameOfReferenceUid), FrameOfReferenceUID);
            /* write GraphicType */
            if (result.good())
            {
                DSRTypes.putStringValueToDataset(dataset, DSRTypes.getDicomAttribute(DicomTags.GraphicType), DSRTypes.graphicType3DToEnumeratedValue(GraphicType));
            }
            /* write GraphicData */
            if (result.good())
            {
                if (!GraphicDataList.isEmpty())
                {
                    result = GraphicDataList.write(ref dataset);
                }
            }
            /* check GraphicData and report warnings if any */
            checkData(GraphicType, GraphicDataList,FrameOfReferenceUID);
            return result;
        }

        /// <summary>
        /// read spatial coordinates value from XML document
        /// </summary>
        /// <param name="doc">document containing the XML file content</param>
        /// <param name="cursor">cursor pointing to the starting node</param>
        /// <returns>true if successful, false otherwise</returns>
        public virtual E_Condition readXML(DSRXMLDocument doc, DSRXMLCursor cursor)
        {
            E_Condition result = E_Condition.SR_EC_CorruptedXMLStructure;
            if (cursor.valid())
            {
                /* graphic data (required) */
                cursor = doc.getNamedNode(cursor, "data");
                if (cursor.valid())
                {
                    string tmpString = null;
                    /* put value to the graphic data list */
                    result = GraphicDataList.putString(doc.getStringFromNodeContent(cursor, ref tmpString));
                }
            }
            return result;
        }

        /// <summary>
        /// write spatial coordinates value in XML format
        /// </summary>
        /// <param name="stream">output stream to which the XML document is written</param>
        /// <param name="flags">flag used to customize the output (see DSRTypes::XF_xxx)</param>
        /// <returns>true if successful, false otherwise</returns>
        public virtual E_Condition writeXML(StringBuilder stream, int flags)
        {
            /* GraphicType is written in TreeNode class */
            if (((flags & DSRTypes.XF_writeEmptyTags) == 0) || (!GraphicDataList.isEmpty()))
            {
                stream.Append(string.Format("{0}{1}{2}","<data uid=\\",FrameOfReferenceUID,"\\")).AppendLine();
                GraphicDataList.print(ref stream);
                stream.Append("<data>").AppendLine();
            }
            return E_Condition.EC_Normal;
        }

        /// <summary>
        /// render spatial coordinates value in HTML/XHTML format
        /// </summary>
        /// <param name="docStream">output stream to which the main HTML/XHTML document is written</param>
        /// <param name="annexStream">output stream to which the HTML/XHTML document annex is written</param>
        /// <param name="annexNumber">reference to the variable where the current annex number is stored. Value is increased automatically by 1 after a new entry has been added.</param>
        /// <param name="flags">flag used to customize the output (see DSRTypes::HF_xxx)</param>
        /// <returns>true if successful, false otherwise</returns>
        public virtual E_Condition renderHTML(StringBuilder docStream, StringBuilder annexStream, int annexNumber, int flags)
        {
            /* render GraphicType */
            docStream.Append(DSRTypes.graphicType3DToReadableName(GraphicType));
            /* render GraphicData */
            if (!isShort(flags))
            {
                string lineBreak = ((flags & DSRTypes.HF_renderSectionTitlesInline) != 0) ? " " :
                                   ((flags & DSRTypes.HF_XHTML11Compatibility) != 0) ? "<br />" : "<br>";
                if ((flags & DSRTypes.HF_currentlyInsideAnnex) != 0)
                {
                    docStream.AppendLine();
                    docStream.Append("<p>").AppendLine();
                    /* render graphic data list (= print)*/
                    docStream.Append("<b>Graphic Data:</b>").AppendLine();
                    GraphicDataList.print(ref docStream);
                    docStream.Append("<p>").AppendLine();
                }
                else
                {
                    DSRTypes.createHTMLAnnexEntry(docStream, annexStream, "for more details see", ref annexNumber, flags);
                    annexStream.Append("<p>").AppendLine();
                    annexStream.Append("<b>Graphic Data:</b>").AppendLine();
                    GraphicDataList.print(ref docStream);
                    annexStream.Append("<p>").AppendLine();

                }
            }
            return E_Condition.EC_Normal;
        }

        /// <summary>
        /// set current graphic type.
        /// The graphic type specifies the geometry of the coordinates stored in the graphic data list.
        /// </summary>
        /// <param name="graphicType">graphic type to be set (GT3_invalid is not allowed)</param>
        /// <returns>true if successful, false otherwise</returns>
        public E_Condition setGraphicType(E_GraphicType3D graphicType)
        {
            if (graphicType != E_GraphicType3D.GT3_invalid)
            {
                GraphicType = graphicType;
                return E_Condition.EC_Normal;
            }
            return E_Condition.EC_IllegalParameter;
        }

        /// <summary>
        /// set current referenced frame of reference UID
        /// </summary>
        /// <param name="frameOfReferenceUID">referenced frame of reference UID to be set</param>
        /// <returns>true if successful, false otherwise</returns>
        public E_Condition setFrameOfReferenceUID(string frameOfReferenceUID)
        {
            if (string.IsNullOrEmpty(frameOfReferenceUID) == true)
            {
                FrameOfReferenceUID = frameOfReferenceUID;
                return E_Condition.EC_Normal;
            }
            return E_Condition.EC_IllegalParameter;
        }

        /// <summary>
        ///  get copy of spatial coordinates value
        /// </summary>
        /// <param name="coordinatesValue">reference to variable in which the value should be stored</param>
        /// <returns>true if successful, false otherwise</returns>
        public E_Condition getValue(DSRSpatialCoordinates3DValue coordinatesValue)
        {
            coordinatesValue = this;
            return E_Condition.EC_Normal;
        }

        /// <summary>
        /// set spatial coordinates value.
        /// Before setting the value the graphic type, graphic data and frame of reference UID
        /// are checked (see checkData()).  If the value is invalid the current value is not
        /// replaced and remains unchanged.
        /// </summary>
        /// <param name="coordinatesValue">value to be set</param>
        /// <returns>true if successful, false otherwise</returns>
        public E_Condition setValue(DSRSpatialCoordinates3DValue coordinatesValue)
        {
            if (checkData(coordinatesValue.GraphicType, coordinatesValue.GraphicDataList, coordinatesValue.FrameOfReferenceUID))
            {
                GraphicType = coordinatesValue.GraphicType;
                GraphicDataList = coordinatesValue.GraphicDataList;
                FrameOfReferenceUID = coordinatesValue.FrameOfReferenceUID;
                return E_Condition.EC_Normal;
            }
            return E_Condition.EC_IllegalParameter;
        }

        /// <summary>
        /// check the graphic type, graphic data and frame of reference UID for validity.
        /// If 'graphicType' is valid the number of entries in the 'graphicDatalist' are checked.
        /// A POINT needs exactly 1 value triplets (x,y,z), a MULTIPOINT at least 1?, a POLYLINE
        /// at least 1?, a POLYGON at least 1? where the first and last triplet are equal, an
        /// ELLIPSE exactly 4 and an ELLIPSOID exactly 6.
        /// </summary>
        /// <param name="graphicType">graphic type to be checked</param>
        /// <param name="graphicDataList">list of graphic data to be checked</param>
        /// <param name="frameOfReferenceUID">referenced frame of reference UID to be checked</param>
        /// <returns>true if successful, false otherwise</returns>
        protected bool checkData(E_GraphicType3D graphicType, DSRGraphicData3DList graphicDataList, string frameOfReferenceUID)
        {
            bool result = false;
            if (graphicType == E_GraphicType3D.GT3_invalid)
            {
                //DCMSR_WARN("Invalid GraphicType for SCOORD content item");
            }
            else if (graphicDataList.isEmpty())
            {
                //DCMSR_WARN("No GraphicData for SCOORD content item");
            }
            else
            {
                int count = graphicDataList.getNumberOfItems();
                switch (graphicType)
                {
                    case E_GraphicType3D.GT3_Point:
                        if (count > 1)
                            //DCMSR_WARN("GraphicData has too many entries, only a single entry expected");                            
                            result = true;
                        break;
                    case E_GraphicType3D.GT3_Multipoint:
                        if (count < 1)
                            //DCMSR_WARN("GraphicData has too few entries, at least one entry expected");
                            result = true;
                        break;
                    case E_GraphicType3D.GT3_Polyline:
                        if (count < 1)
                            //DCMSR_WARN("GraphicData has too few entries, at least one entry expected");
                        result = true;
                        break;
                    case E_GraphicType3D.GT3_Polygon:
                        if (count < 1)
                        {
                            //DCMSR_WARN("GraphicData has too few entries, at least one entry expected");
                        }
                        else if (graphicDataList.getItem(1) != graphicDataList.getItem(count))
                        {
                            //DCMSR_WARN("First and last entry in GraphicData are not equal (POLYGON)");
                            result = true;
                        }
                        break;
                    case E_GraphicType3D.GT3_Ellipse:
                        if (count < 4)
                        {
                            //DCMSR_WARN("GraphicData has too few entries, exactly four entries expected");
                        }
                        else
                        {
                            if (count > 4)
                                //DCMSR_WARN("GraphicData has too many entries, exactly four entries expected");
                                result = true;
                        }
                        break;
                    case E_GraphicType3D.GT3_Ellipsoid:
                        if (count < 6)
                        {
                            //DCMSR_WARN("GraphicData has too few entries, exactly four entries expected");
                        }
                        else
                        {
                            if (count > 6)
                                //DCMSR_WARN("GraphicData has too many entries, exactly four entries expected");
                                result = true;
                        }
                        break;
                    default:
                        /* GT_invalid */
                        break;
                }
            }
            // check referenced frame of reference UID
            if (string.IsNullOrEmpty(frameOfReferenceUID))
            {
                //DCMSR_WARN("Empty ReferencedFrameOfReferenceUID for SCOORD3D content item");
                result = false;
            }
            return result;
        }
    }
}
