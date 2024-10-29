using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;
using System.Threading.Tasks;
using ClearCanvas.Dicom;

namespace Hydra.Dicom
{
    public class DSRTemporalCoordinatesValue
    {
        private E_TemporalRangeType TemporalRangeType;

        private DSRReferencedSamplePositionList SamplePositionList;

        private DSRReferencedTimeOffsetList TimeOffsetList;

        private DSRReferencedDatetimeList DatetimeList;

        /// <summary>
        /// Default Constructor
        /// </summary>
        public DSRTemporalCoordinatesValue()
        {
            TemporalRangeType = E_TemporalRangeType.TRT_invalid;
            SamplePositionList = new DSRReferencedSamplePositionList();
            TimeOffsetList = new DSRReferencedTimeOffsetList();
            DatetimeList = new DSRReferencedDatetimeList();
        }

        /// <summary>
        /// Constructor
        /// </summary>
        /// <param name="graphicType">graphic type specifying the geometry of the coordinates</param>
        public DSRTemporalCoordinatesValue(E_TemporalRangeType temporalRangeType)
        {
            TemporalRangeType = temporalRangeType;
            SamplePositionList = new DSRReferencedSamplePositionList();
            TimeOffsetList = new DSRReferencedTimeOffsetList();
            DatetimeList = new DSRReferencedDatetimeList();
        }

        /// <summary>
        /// Constructor
        /// </summary>
        /// <param name="coordinatesValue">spatial coordinates value to be copied</param>
        public DSRTemporalCoordinatesValue(DSRTemporalCoordinatesValue coordinatesValue)
        {
            TemporalRangeType = coordinatesValue.TemporalRangeType;
            SamplePositionList = coordinatesValue.SamplePositionList;
            TimeOffsetList = coordinatesValue.TimeOffsetList;
            DatetimeList = coordinatesValue.DatetimeList;
        }

        /// <summary>
        /// Destructor
        /// </summary>
        ~DSRTemporalCoordinatesValue()
        {

        }

        /// <summary>
        /// clear all internal variables.
        /// Temporal range type is set to TRT_invalid.  Since an empty list of graphic data is
        /// the spatial coordinates value becomes invalid afterwards.
        /// </summary>
        public virtual void clear()
        {
            TemporalRangeType = E_TemporalRangeType.TRT_invalid;
            SamplePositionList.clear();
            TimeOffsetList.clear();
            DatetimeList.clear();
        }

        /// <summary>
        /// check whether the current spatial coordinates value is valid.
        /// The value is valid if the temporal range type is not TRT_invalid and the other data
        /// is valid (see checkData() for details).
        /// </summary>
        /// <returns>true if reference value is valid, false otherwise</returns>
        public virtual bool isValid()
        {
            return checkData(TemporalRangeType, SamplePositionList, TimeOffsetList, DatetimeList);
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
            int renderfulldata = (flags & DSRTypes.HF_renderFullData);
            return (SamplePositionList.isEmpty() && TimeOffsetList.isEmpty() && DatetimeList.isEmpty()) || !(Convert.ToBoolean(renderfulldata));
        }

        /// <summary>
        /// print spatial coordinates.
        /// The output of a typical temporal coordinates value looks like this (depending on the
        /// referenced data list): (SEGMENT,1,2,3) or (SEGMENT,1,2.5,3.1) or (POINT,20001010120000)
        /// </summary>
        /// <param name="stream">output stream to which the spatial coordinates value should be printed</param>
        /// <param name="flags">flag used to customize the output (see DSRTypes::PF_xxx)</param>
        /// <returns>true if successful, false otherwise</returns>
        public virtual E_Condition print(ref StringBuilder stream, int flags)
        {
            if (stream == null)
            {
                stream = new StringBuilder();
            }

            /* TemporalRangeType */
            stream.Append("(");
            stream.Append(DSRTypes.temporalRangeTypeToEnumeratedValue(TemporalRangeType));

            /* print data */
            stream.Append(",");

            /* print only one list */
            if (!SamplePositionList.isEmpty())
            {
                SamplePositionList.print(ref stream, flags);
            }

            else if (!TimeOffsetList.isEmpty())
            {
                TimeOffsetList.print(ref stream, flags);
            }

            else
            {
                DatetimeList.print(ref stream, flags);
            }

            stream.Append(")");
            return E_Condition.EC_Normal;
        }

        /// <summary>
        /// read temporal coordinates value from XML document
        /// </summary>
        /// <param name="doc">document containing the XML file content</param>
        /// <param name="cursor">cursor pointing to the starting node</param>
        /// <returns>true if successful, false otherwise</returns>
        public virtual E_Condition readXML(DSRXMLDocument doc, DSRXMLCursor cursor)
        {
            E_Condition result = E_Condition.SR_EC_CorruptedXMLStructure;
            if (cursor.valid())
            {
                DSRXMLCursor aXMLCursor = cursor.getChild();
                /* graphic data (required) */
                cursor = doc.getNamedNode(aXMLCursor, "data");
                if (cursor.valid())
                {
                    string tmpString = string.Empty;
                    string typeString = string.Empty;
                    /* read 'type' and check validity */
                    doc.getStringFromAttribute(cursor, ref typeString, "type");
                    if (typeString == "SAMPLE POSITION")
                    {
                        /* put value to the sample position list */
                        result = SamplePositionList.putString(doc.getStringFromNodeContent(cursor, ref tmpString));
                    }

                    else if (typeString == "TIME OFFSET")
                    {
                        /* put value to the time offset list */
                        result = TimeOffsetList.putString(doc.getStringFromNodeContent(cursor, ref tmpString));
                    }

                    else if (typeString == "DATETIME")
                    {
                        /* put value to the datetime list (tbd: convert from ISO 8601 format?) */
                        result = DatetimeList.putString(doc.getStringFromNodeContent(cursor, ref tmpString));
                    }

                    else
                    {
                        DSRTypes.printUnknownValueWarningMessage("TCOORD data type", typeString);
                        result = E_Condition.SR_EC_InvalidValue;
                    }
                }
            }
            return result;
        }

        /// <summary>
        /// write temporal coordinates value in XML format
        /// </summary>
        /// <param name="stream">output stream to which the XML document is written</param>
        /// <param name="flags">flag used to customize the output (see DSRTypes::XF_xxx)</param>
        /// <returns>true if successful, false otherwise</returns>
        public virtual E_Condition writeXML(ref StringBuilder stream, int flags)
        {
            /* TemporalRangeType is written in TreeNode class */
            int writeEmptyTags = (flags & DSRTypes.XF_writeEmptyTags);
            if ((Convert.ToBoolean(writeEmptyTags)) || !SamplePositionList.isEmpty() || !TimeOffsetList.isEmpty() || !DatetimeList.isEmpty())
            {
                stream.Append("<data type=\"");

                /* print only one list */
                if (!SamplePositionList.isEmpty())
                {
                    stream.Append("SAMPLE POSITION\">");
                    SamplePositionList.print(ref stream);
                }
                else if (!TimeOffsetList.isEmpty())
                {
                    stream.Append("TIME OFFSET\">");
                    TimeOffsetList.print(ref stream);
                }
                else
                {
                    /* tbd: convert output to ISO 8601 format? */
                    stream.Append("DATETIME\">");
                    DatetimeList.print(ref stream);
                }
                stream.Append("</data>");
                stream.AppendLine();
            }
            return E_Condition.EC_Normal;
        }

        /// <summary>
        /// render temporal coordinates value in HTML/XHTML format
        /// </summary>
        /// <param name="docStream">output stream to which the main HTML/XHTML document is written</param>
        /// <param name="annexStream">output stream to which the HTML/XHTML document annex is written</param>
        /// <param name="annexNumber">reference to the variable where the current annex number is stored. Value is increased automatically by 1 after a new entry has been added.</param>
        /// <param name="flags">flag used to customize the output (see DSRTypes::HF_xxx)</param>
        /// <returns>true if successful, false otherwise</returns>
        public virtual E_Condition renderHTML(ref StringBuilder docStream, ref StringBuilder annexStream, ref int annexNumber, int flags)
        {
            /* render TemporalRangeType */
            docStream.Append(DSRTypes.temporalRangeTypeToReadableName(TemporalRangeType));
            /* render data */
            if (!isShort(flags))
            {
                int XHTML11Compatibility = flags & DSRTypes.HF_XHTML11Compatibility;
                int HF_renderSectionTitlesInline = flags & DSRTypes.HF_renderSectionTitlesInline;

                string lineBreak = (Convert.ToBoolean(HF_renderSectionTitlesInline)) ? " " : (Convert.ToBoolean(XHTML11Compatibility)) ? "<br />" : "<br>";

                int HF_currentlyInsideAnnex = flags & DSRTypes.HF_currentlyInsideAnnex;
                if (Convert.ToBoolean(HF_currentlyInsideAnnex))
                {
                    docStream.AppendLine();
                    docStream.Append("<p>");
                    docStream.AppendLine();

                    /* render data list (= print)*/
                    if (!SamplePositionList.isEmpty())
                    {
                        docStream.Append("<b>Reference Sample Positions:</b>");
                        docStream.Append(lineBreak);
                        SamplePositionList.print(ref docStream);
                    }
                    else if (!TimeOffsetList.isEmpty())
                    {
                        docStream.Append("<b>Referenced Time Offsets:</b>");
                        docStream.Append(lineBreak);
                        TimeOffsetList.print(ref docStream);
                    }
                    else
                    {
                        docStream.Append("<b>Referenced Datetime:</b>");
                        docStream.Append(lineBreak);
                        DatetimeList.print(ref docStream);
                    }
                    docStream.Append("</p>");
                }
                else
                {
                    DSRTypes.createHTMLAnnexEntry(docStream, annexStream, "for more details see", ref annexNumber, flags);
                    annexStream.Append("<p>");
                    annexStream.AppendLine();

                    /* render data list (= print)*/
                    if (!SamplePositionList.isEmpty())
                    {
                        annexStream.Append("<b>Reference Sample Positions:</b>");
                        annexStream.Append(lineBreak);
                        SamplePositionList.print(ref annexStream);
                    }
                    else if (!TimeOffsetList.isEmpty())
                    {
                        annexStream.Append("<b>Referenced Time Offsets:</b>");
                        annexStream.Append(lineBreak);
                        TimeOffsetList.print(ref annexStream);
                    }
                    else
                    {
                        annexStream.Append("<b>Referenced Datetime:</b>");
                        annexStream.Append(lineBreak);
                        DatetimeList.print(ref annexStream);
                    }
                    annexStream.Append("</p>");
                    annexStream.AppendLine();
                }
            }
            return E_Condition.EC_Normal;
        }

        /// <summary>
        ///  get copy of temporal coordinates value
        /// </summary>
        /// <param name="coordinatesValue">reference to variable in which the value should be stored</param>
        /// <returns>true if successful, false otherwise</returns>
        public E_Condition getValue(DSRTemporalCoordinatesValue coordinatesValue)
        {
            coordinatesValue = this;
            return E_Condition.EC_Normal;
        }

        /// <summary>
        /// set temporal coordinates value.
        /// Before setting the value the graphic type, graphic data and frame of reference UID
        /// are checked (see checkData()).  If the value is invalid the current value is not
        /// replaced and remains unchanged.
        /// </summary>
        /// <param name="coordinatesValue">value to be set</param>
        /// <returns>true if successful, false otherwise</returns>
        public E_Condition setValue(DSRTemporalCoordinatesValue coordinatesValue)
        {
            E_Condition result = E_Condition.EC_IllegalParameter;
            if (checkData(coordinatesValue.TemporalRangeType, coordinatesValue.SamplePositionList,
                          coordinatesValue.TimeOffsetList, coordinatesValue.DatetimeList))
            {
                TemporalRangeType = coordinatesValue.TemporalRangeType;
                SamplePositionList = coordinatesValue.SamplePositionList;
                TimeOffsetList = coordinatesValue.TimeOffsetList;
                DatetimeList = coordinatesValue.DatetimeList;
                result = E_Condition.EC_Normal;
            }
            return result;
        }

        /// <summary>
        /// set current temporal range type.
        /// This value represents the type of temporal extent of the region of interest.
        /// </summary>
        /// <param name="temporalRangeType">temporal range type to be set</param>
        /// <returns>true if successful, false otherwise</returns>
        public E_Condition setTemporalRangeType(E_TemporalRangeType temporalRangeType)
        {
            E_Condition result = E_Condition.EC_IllegalParameter;
            if (temporalRangeType != E_TemporalRangeType.TRT_invalid)
            {
                TemporalRangeType = temporalRangeType;
                result = E_Condition.EC_Normal;
            }
            return result;
        }

        /// <summary>
        /// check the temporal range type and other data for validity.
        /// The data is valid if the 'temporalRangeType' is valid and at least one of the three
        /// lists are non-empty.  If more the one list is non-empty a warning is reported since
        /// they are mutually exclusive (type 1C).
        /// </summary>
        /// <param name="temporalRangeType">temporal range type to be checked</param>
        /// <param name="samplePositionList">list of referenced sample positions to be checked</param>
        /// <param name="timeOffsetList">list of referenced time offsets to be checked</param>
        /// <param name="datetimeList">list of referenced datetime to be checked</param>
        /// <returns>true if successful, false otherwise</returns>
        protected bool checkData(E_TemporalRangeType temporalRangeType, DSRReferencedSamplePositionList samplePositionList, DSRReferencedTimeOffsetList timeOffsetList, DSRReferencedDatetimeList datetimeList)
        {
            bool result = true;
            if (temporalRangeType == E_TemporalRangeType.TRT_invalid)
            {
                //DCMSR_WARN("Invalid TemporalRangeType for TCOORD content item");
            }
            bool list1 = !samplePositionList.isEmpty();
            bool list2 = !timeOffsetList.isEmpty();
            bool list3 = !datetimeList.isEmpty();
            if (list1 && list2 && list3)
            {
                //DCMSR_WARN("ReferencedSamplePositions/TimeOffsets/Datetime present in TCOORD content item");
            }
            else if (list1 && list2)
            {
                //DCMSR_WARN("ReferencedSamplePositions/TimeOffsets present in TCOORD content item");
            }
            else if (list1 && list3)
            {
                //DCMSR_WARN("ReferencedSamplePositions/Datetime present in TCOORD content item");
            }
            else if (list2 && list3)
            {
                //DCMSR_WARN("ReferencedTimeOffsets/Datetime present in TCOORD content item");
            }
            else if (!list1 && !list2 && !list3)
            {
                //DCMSR_WARN("ReferencedSamplePositions/TimeOffsets/Datetime empty in TCOORD content item");
                /* invalid: all lists are empty (type 1C) */
                result = false;
            }
            return result;
        }

        /// <summary>
        /// read temporal coordinates value from dataset.
        /// Please note that all three lists are (tried to) read from the dataset.  If more than
        /// one list is present a warning messsage is reported.
        /// </summary>
        /// <param name="dataset">DICOM dataset from which the value should be read</param>
        /// <returns>true if successful, false otherwise</returns>
        public virtual E_Condition read(DicomAttributeCollection dataset)
        {
            /* read TemporalRangeType */
            string tmpString = string.Empty;
            E_Condition result = DSRTypes.getAndCheckStringValueFromDataset(dataset, DSRTypes.getDicomAttribute(DicomTags.TemporalRangeType), ref tmpString, "1", "1", "TCOORD content item");
            if (result.good())
            {
                TemporalRangeType = DSRTypes.enumeratedValueToTemporalRangeType(tmpString);
                /* check TemporalRangeType */
                if (TemporalRangeType == E_TemporalRangeType.TRT_invalid)
                    DSRTypes.printUnknownValueWarningMessage("TemporalRangeType", tmpString);
                /* first read data (all three lists) */
                SamplePositionList.read(ref dataset);
                TimeOffsetList.read(ref dataset);
                DatetimeList.read(ref dataset);
                /* then check data and report warnings if any */
                if (!checkData(TemporalRangeType, SamplePositionList, TimeOffsetList, DatetimeList))
                    result = E_Condition.SR_EC_InvalidValue;
            }
            return result;
        }

        /// <summary>
        /// write temporal coordinates reference value to dataset.
        /// Please note that only one of the three lists is actually written to the dataset.
        /// </summary>
        /// <param name="dataset">DICOM dataset to which the value should be written</param>
        /// <returns>true if successful, false otherwise</returns>
        public virtual E_Condition write(DicomAttributeCollection dataset)
        {
            /* write TemporalRangeType */
            E_Condition result = DSRTypes.putStringValueToDataset(dataset, DSRTypes.getDicomAttribute(DicomTags.TemporalRangeType), DSRTypes.temporalRangeTypeToEnumeratedValue(TemporalRangeType));
            if (result.good())
            {
                /* write data (only one list) */
                if (!SamplePositionList.isEmpty())
                {
                    SamplePositionList.write(ref dataset);
                }
                else if (!TimeOffsetList.isEmpty())
                {
                    TimeOffsetList.write(ref dataset);
                }
                else
                {
                    DatetimeList.write(ref dataset);
                }
            }
            /* check data and report warnings if any */
            checkData(TemporalRangeType, SamplePositionList, TimeOffsetList, DatetimeList);
            return result;
        }

        /// <summary>
        /// Get the value pointer
        /// </summary>
        /// <returns></returns>
        protected DSRTemporalCoordinatesValue getValuePtr()
        {
            return this;
        }

        /// <summary>
        /// Get the date timeList
        /// </summary>
        /// <returns></returns>
        public DSRReferencedDatetimeList getDatetimeList()
        {
            return DatetimeList;
        }

        /// <summary>
        /// Get samplePoisitionList
        /// </summary>
        /// <returns></returns>
        public DSRReferencedSamplePositionList getSamplePositionList()
        {
            return SamplePositionList;
        }

        /// <summary>
        /// Get time offset list
        /// </summary>
        /// <returns></returns>
        public DSRReferencedTimeOffsetList getTimeOffsetList()
        {
            return TimeOffsetList;
        }

        /// <summary>
        /// Get temporarl range type
        /// </summary>
        /// <returns></returns>
        public E_TemporalRangeType getTemporalRangeType()
        {
            return TemporalRangeType;
        }

        /// <summary>
        /// Gets the value
        /// </summary>
        /// <returns></returns>
        public DSRTemporalCoordinatesValue getValue()
        {
            return this;
        }
    }
}
