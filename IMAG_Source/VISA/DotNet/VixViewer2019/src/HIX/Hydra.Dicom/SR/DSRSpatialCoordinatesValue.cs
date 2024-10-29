using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;
using System.Threading.Tasks;
using ClearCanvas.Dicom;

namespace Hydra.Dicom
{
    public class DSRSpatialCoordinatesValue
    {
        private E_GraphicType GraphicType;

        private string FrameOfReferenceUID;

        private DSRGraphicDataList GraphicDataList;

        /// <summary>
        /// Default Constructor
        /// </summary>
        public DSRSpatialCoordinatesValue()
        {
            GraphicType = E_GraphicType.GT_invalid;
            GraphicDataList = new DSRGraphicDataList();
        }

        /// <summary>
        /// Constructor
        /// </summary>
        /// <param name="graphicType">graphic type specifying the geometry of the coordinates</param>
        public DSRSpatialCoordinatesValue(E_GraphicType graphicType)
        {
            GraphicType = graphicType;
            GraphicDataList = new DSRGraphicDataList();
        }

        /// <summary>
        /// Copy Constructor
        /// </summary>
        /// <param name="coordinatesValue">spatial coordinates value to be copied</param>
        public DSRSpatialCoordinatesValue(DSRSpatialCoordinatesValue coordinatesValue)
        {
            GraphicType = coordinatesValue.GraphicType;
            GraphicDataList = new DSRGraphicDataList(coordinatesValue.GraphicDataList);
        }

        /// <summary>
        /// clear all internal variables.
        /// Graphic type is set to GT_invalid.  Since an empty list of graphic data is invalid
        /// the spatial coordinates value becomes invalid afterwards.
        /// </summary>
        public virtual void clear()
        {
            GraphicType = E_GraphicType.GT_invalid;
            GraphicDataList.clear();
        }

        /// <summary>
        /// check whether the current spatial coordinates value is valid.
        /// The value is valid if the graphic type is not GT_invalid and the graphic data is
        /// valid (see checkData() for details).
        /// </summary>
        /// <returns>true if reference value is valid, false otherwise</returns>
        public virtual bool isValid()
        {
            return checkData(GraphicType, GraphicDataList);
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
        /// The output of a typical spatial coordinates value looks like this: (CIRCLE,0/0,255/255).
        /// </summary>
        /// <param name="stream">output stream to which the spatial coordinates value should be printed</param>
        /// <param name="flags">flag used to customize the output (see DSRTypes::PF_xxx)</param>
        /// <returns>true if successful, false otherwise</returns>
        public virtual E_Condition print(StringBuilder stream, int flags)
        {
            /* GraphicType */
            stream.Append(string.Format("{0}{1}","(",DSRTypes.graphicTypeToEnumeratedValue(GraphicType)));
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
            E_Condition result = DSRTypes.getAndCheckStringValueFromDataset(dataset, DSRTypes.getDicomAttribute(DicomTags.GraphicType), ref tmpString, "1", "1", "SCOORD content item");
            if (result.good())
            {
                GraphicType = DSRTypes.enumeratedValueToGraphicType(tmpString);
                /* check GraphicType */
                if (GraphicType == E_GraphicType.GT_invalid)
                    DSRTypes.printUnknownValueWarningMessage("GraphicType", tmpString);
                /* read GraphicData */
                result = GraphicDataList.read(ref dataset);
                /* check GraphicData and report warnings if any */
                checkData(GraphicType, GraphicDataList);
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
            E_Condition result = DSRTypes.putStringValueToDataset(dataset, DSRTypes.getDicomAttribute(DicomTags.GraphicType), DSRTypes.graphicTypeToEnumeratedValue(GraphicType));
            if (result.good())
            {
                if (!GraphicDataList.isEmpty())
                {
                    result = GraphicDataList.write(ref dataset);
                }
            }
            /* check GraphicData and report warnings if any */
            checkData(GraphicType, GraphicDataList);
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
                cursor = doc.getNamedNode(cursor.getChild(), "data");
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
                stream.Append("<data>");
                GraphicDataList.print(ref stream);
                stream.Append("<data>");
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
            docStream.Append(DSRTypes.graphicTypeToReadableName(GraphicType));
            /* render GraphicData */
            if (!isShort(flags))
            {
                string lineBreak = ((flags & DSRTypes.HF_renderSectionTitlesInline)!=0) ? " " :
                                   ((flags & DSRTypes.HF_XHTML11Compatibility)!=0) ? "<br />" : "<br>";
                if ((flags & DSRTypes.HF_currentlyInsideAnnex) != 0)
                {
                    docStream.AppendLine();
                    docStream.Append("<p>");
                    docStream.AppendLine();
                    /* render graphic data list (= print)*/
                    docStream.Append("<b>Graphic Data:</b>");
                    docStream.AppendLine();
                    GraphicDataList.print(ref docStream);
                    docStream.Append("<p>");
                }
                else
                {
                    DSRTypes.createHTMLAnnexEntry(docStream, annexStream, "for more details see", ref annexNumber, flags);
                    annexStream.Append("<p>");
                    annexStream.AppendLine();
                    GraphicDataList.print(ref docStream);
                    annexStream.Append("<p>");

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
        public E_Condition setGraphicType(E_GraphicType graphicType)
        {
            if (graphicType != E_GraphicType.GT_invalid)
            {
                GraphicType = graphicType;
                return E_Condition.EC_Normal;
            }
            return E_Condition.EC_IllegalParameter;
        }        

        /// <summary>
        ///  get copy of spatial coordinates value
        /// </summary>
        /// <param name="coordinatesValue">reference to variable in which the value should be stored</param>
        /// <returns>true if successful, false otherwise</returns>
        public E_Condition getValue(DSRSpatialCoordinatesValue coordinatesValue)
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
        public E_Condition setValue(DSRSpatialCoordinatesValue coordinatesValue)
        {
            if (checkData(coordinatesValue.GraphicType, coordinatesValue.GraphicDataList))
            {
                GraphicType = coordinatesValue.GraphicType;
                GraphicDataList = coordinatesValue.GraphicDataList;
                return E_Condition.EC_Normal;
            }
            return E_Condition.EC_IllegalParameter;
        }

        /// <summary>
        /// check the graphic type, graphic data and frame of reference UID for validity.
        /// If 'graphicType' is valid the number of entries in the 'graphicDatalist' are checked.
        /// A POINT needs exactly 1 value pair (column,row), a MULTIPOINT at least 1?, a POLYLINE
        /// at least 1?, a CIRCLE exactly 2 and an ELLIPSE exactly 4.
        /// </summary>
        /// <param name="graphicType">graphic type to be checked</param>
        /// <param name="graphicDataList">list of graphic data to be checked</param>
        /// <param name="frameOfReferenceUID">referenced frame of reference UID to be checked</param>
        /// <returns>true if successful, false otherwise</returns>
        protected bool checkData(E_GraphicType graphicType, DSRGraphicDataList graphicDataList)
        {
            bool result = false;
            if (graphicType == E_GraphicType.GT_invalid)
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
                    case E_GraphicType.GT_Point:
                        if (count > 1)
                        {
                            //DCMSR_WARN("GraphicData has too many entries, only a single entry expected");                            
                        }
                        result = true;
                        break;
                    case E_GraphicType.GT_Multipoint:
                        if (count < 1)
                        {
                            //DCMSR_WARN("GraphicData has too few entries, at least one entry expected");
                        }
                        result = true;
                        break;
                    case E_GraphicType.GT_Polyline:
/*                       // not required any more according to CP-233
                        if (graphicDataList.getItem(1) != graphicDataList.getItem(count))
                            DCMSR_WARN("First and last entry in GraphicData are not equal (POLYLINE)");
*/
                    result = true;
                    break;
            case E_GraphicType.GT_Circle:
                    if (count < 2)
                    {
                        //DCMSR_WARN("GraphicData has too few entries, exactly two entries expected");
                    }
                    else
                    {
                        if (count > 2)
                        {
                            //DCMSR_WARN("GraphicData has too many entries, exactly two entries expected");
                        }
                        result = true;
                    }
                break;
            case E_GraphicType.GT_Ellipse:
                    if (count < 4)
                    {
                       //DCMSR_WARN("GraphicData has too few entries, exactly four entries expected");
                    }
                    else
                    {
                        if (count > 4)
                        {
                            //DCMSR_WARN("GraphicData has too many entries, exactly four entries expected");
                        }
                        result = true;
                    }   
                    break;
            default:
                /* GT_invalid */
                break;
                }
            }
            return result;
        }
    }
}
