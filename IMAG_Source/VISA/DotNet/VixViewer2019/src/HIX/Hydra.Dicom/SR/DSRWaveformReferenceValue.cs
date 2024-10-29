using ClearCanvas.Dicom;
using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;
using System.Threading.Tasks;

namespace Hydra.Dicom
{
    public class DSRWaveformReferenceValue : DSRCompositeReferenceValue
    {
        /// <summary>
        /// list of referenced waveform channels (associated DICOM VR=US, VM=2-2n, type 1C)
        /// </summary>
        private DSRWaveformChannelList ChannelList;

        /// <summary>
        /// default contructor
        /// </summary>
        public DSRWaveformReferenceValue()
            :base()
        {
            ChannelList = new DSRWaveformChannelList();
        }

        /// <summary>
        /// contructor
        /// The UID pair is only set if it passed the validity check (see setValue()).
        /// </summary>
        /// <param name="sopClassUID"></param>
        /// <param name="sopInstanceUID"></param>
        public DSRWaveformReferenceValue(string sopClassUID, string sopInstanceUID)
            :base()
        {
            ChannelList = new DSRWaveformChannelList();
            setReference(ref sopClassUID, ref sopInstanceUID);
        }

        /// <summary>
        /// copy constructor
        /// </summary>
        /// <param name="referenceValue"></param>
        public DSRWaveformReferenceValue(ref DSRWaveformReferenceValue referenceValue)
            //: DSRCompositeReferenceValue(referenceValue)
        {
            ChannelList = referenceValue.ChannelList;
        }

        /// <summary>
        /// destructor
        /// </summary>
        ~DSRWaveformReferenceValue()
        {
        }

        /// <summary>
        /// clear all internal variables. 
        /// Since an empty waveform reference is invalid the reference becomes invalid afterwards.
        /// </summary>
        public override void clear()
        {
            base.clear();
            ChannelList.clear();
        }

        /// <summary>
        /// check whether the content is short. 
        /// This method is used to check whether the rendered output of this content item can be expanded inline or not (used for renderHTML()).
        /// </summary>
        /// <param name="flags"></param>
        /// <returns> true if content is short, false otherwise </returns>
        public virtual bool isShort(int flags)
        {
            return (ChannelList.isEmpty()) || ((flags & DSRTypes.HF_renderFullData) == 0);
        }

        /// <summary>
        /// print waveform reference.
        /// The output of a typical waveform reference value looks like this: (HemodynamicWaveform Storage,"1.2.3")
        /// If the SOP class UID is unknown the UID is printed instead of the related name.
        /// </summary>
        /// <param name="stream"></param>
        /// <param name="flags"></param>
        /// <returns> status, EC_Normal if successful, an error code otherwise </returns>
        public override E_Condition print(ref StringBuilder stream, int flags)
        {
            string className = DSRTypes.S_UIDNameMap.dcmFindNameOfUID(SOPClassUID);
            stream.Append("(");
            if (className != null)
            {
                stream.Append(className);
            }
            else
            {
                stream.Append(string.Format("{0}{1}{2}", "\\", SOPClassUID, "\\"));
            }
            stream.Append(",");
            if ((flags & DSRTypes.PF_printSOPInstanceUID) != 0)
            {
                stream.Append(string.Format("{0}{1}{2}", "\\", SOPInstanceUID, "\\"));
            }
            if (!ChannelList.isEmpty())
            {
                stream.Append(",");
                ChannelList.print(stream, flags);
            }
            stream.Append(")");
            return E_Condition.EC_Normal;
        }

        /// <summary>
        /// read waveform reference from XML document.
        /// </summary>
        /// <param name="doc"></param>
        /// <param name="cursor"></param>
        /// <returns> status, EC_Normal if successful, an error code otherwise </returns>
        public override E_Condition readXML(ref DSRXMLDocument doc, DSRXMLCursor cursor)
        {
            /* first read general composite reference information */
            E_Condition result = base.readXML(ref doc, cursor);
            if (result.good())
            {
                cursor = doc.getNamedNode(cursor, "channels");
                if (cursor.valid())
                {
                    string tmpString = null;
                    /* put element content to the channel list */
                    result = ChannelList.putString(doc.getStringFromNodeContent(cursor, ref tmpString));
                }
            }
            return result;
        }

        /// <summary>
        /// write waveform reference item in XML format.
        /// </summary>
        /// <param name="stream"></param>
        /// <param name="flags"></param>
        /// <returns> status, EC_Normal if successful, an error code otherwise </returns>
        public override E_Condition writeXML(ref StringBuilder stream, int flags)
        {
            E_Condition result = base.writeXML(ref stream, flags);
            if (((flags & DSRTypes.XF_writeEmptyTags) != 0) || (!ChannelList.isEmpty()))
            {
                stream.Append("<channels>");
                ChannelList.print(stream);
                stream.Append("<channels>").AppendLine();
            }
            return result;
        }

        /// <summary>
        /// render waveform reference value in HTML/XHTML format.
        /// </summary>
        /// <param name="docStream"></param>
        /// <param name="annexStream"></param>
        /// <param name="annexNumber"></param>
        /// <param name="flags"></param>
        /// <returns> status, EC_Normal if successful, an error code otherwise </returns>
        public override E_Condition renderHTML(ref StringBuilder docStream, ref StringBuilder annexStream, ref int annexNumber, int flags)
        {
            /* render reference */
            docStream.Append("<a href=\"");
            docStream.Append("http://localhost/dicom.cgi");
            docStream.Append("?waveform=");
            docStream.Append(SOPClassUID);
            docStream.Append("+");
            docStream.Append(SOPInstanceUID);
            /* reference: pstate */
            if (!ChannelList.isEmpty())
            {
                docStream.Append("&amp;channels=");
                ChannelList.print(docStream,0,'+','+');
            }      
            docStream.Append("\">");
            string className = DSRTypes.S_UIDNameMap.dcmFindNameOfUID(SOPClassUID);
            if (className != null)
            {
                docStream.Append(className);
            }
            else
            {
                docStream.Append("unknown waveform");
            }
            docStream.Append("</a>");
            if (!isShort(flags))
            {
                string lineBreak = ((flags & DSRTypes.HF_renderSectionTitlesInline) != 0) ? " " :
                                   ((flags & DSRTypes.HF_XHTML11Compatibility) != 0) ? "<br />" : "<br>";
                if ((flags & DSRTypes.HF_currentlyInsideAnnex) != 0)
                {
                    docStream.AppendLine();
                    docStream.Append("<p>").AppendLine();
                    /* render channel list (= print)*/
                    docStream.Append("<b>Referenced Waveform Channels:</b>");
                    docStream.Append(lineBreak);
                    ChannelList.print(docStream);
                    docStream.Append("</p>");
                }
                else
                {
                    docStream.Append(" ");
                    DSRTypes.createHTMLAnnexEntry(docStream, annexStream, "for more details see", ref annexNumber, flags);
                    annexStream.Append("<p>").AppendLine();
                    /* render channel list (= print)*/
                    annexStream.Append("<b>Referenced Waveform Channels:</b>");
                    annexStream.Append(lineBreak);
                    ChannelList.print(annexStream);
                    annexStream.Append("</p>");
                    annexStream.Append(Environment.NewLine);
                }
            }

            return E_Condition.EC_Normal;
        }

        /// <summary>
        /// get reference to waveform reference value
        /// </summary>
        /// <returns> reference to waveform reference value </returns>
        public DSRWaveformReferenceValue getValue()
        {
            return this;
        }

        /// <summary>
        /// get copy of waveform reference value
        /// </summary>
        /// <param name="referenceValue"></param>
        /// <returns> status, EC_Normal if successful, an error code otherwise </returns>
        public E_Condition getValue(ref DSRWaveformReferenceValue referenceValue)
        {
            referenceValue = this;
            return E_Condition.EC_Normal;
        }

        /// <summary>
        /// set waveform reference value.
        /// Before setting the reference it is checked (see checkXXX()). If the value is invalid the current value is not replaced and remains unchanged.
        /// </summary>
        /// <param name="referenceValue"></param>
        /// <returns> status, EC_Normal if successful, an error code otherwise </returns>
        public E_Condition setValue(ref DSRWaveformReferenceValue referenceValue)
        {
            E_Condition result = base.setValue(referenceValue);
            if (result.good())
            {
                ChannelList = referenceValue.ChannelList;
            }
            return result;
        }

        /// <summary>
        /// get reference to list of referenced waveform channels
        /// </summary>
        /// <returns> reference to channel list </returns>
        public DSRWaveformChannelList getChannelList()
        {
            return ChannelList;
        }

        /// <summary>
        /// check whether the waveform reference applies to a specific channel.
        /// The waveform reference applies to a channel if the list of referenced waveform
        /// channels is empty or the group/channel pair is part of the list.
        /// </summary>
        /// <param name="channelNumber"></param>
        /// <param name="multiplexGroupNumber"></param>
        /// <returns> true if reference applies to the specified channel, false otherwise </returns>
        public bool appliesToChannel(ushort multiplexGroupNumber, ushort channelNumber)
        {
            bool result = true;
            if (!ChannelList.isEmpty())
            {
                result = ChannelList.isElement(multiplexGroupNumber, channelNumber);
            }
            return result;
        }

        /// <summary>
        /// get pointer to waveform reference value
        /// </summary>
        /// <returns> pointer to waveform reference value (never NULL) </returns>
        protected DSRWaveformReferenceValue getValuePtr()
        {
            return this;
        }

        /// <summary>
        /// read waveform reference value from dataset.
        /// </summary>
        /// <param name="dataset"></param>
        /// <returns> status, EC_Normal if successful, an error code otherwise </returns>
        protected override E_Condition readItem(ref DicomAttributeCollection dataset)
        {
            /* read ReferencedSOPClassUID and ReferencedSOPInstanceUID */
            E_Condition result = base.readItem(ref dataset);
            /* read ReferencedWaveformChannels (conditional) */
            if (result.good())
            {
                ChannelList.read(dataset);
            }
            return result;
        }

        /// <summary>
        /// write waveform reference value to dataset.
        /// </summary>
        /// <param name="dataset"></param>
        /// <returns> status, EC_Normal if successful, an error code otherwise </returns>
        protected override E_Condition writeItem(DicomAttributeCollection dataset)
        {
            /* write ReferencedSOPClassUID and ReferencedSOPInstanceUID */
            E_Condition result = base.writeItem(dataset);
            /* write ReferencedWaveformChannels (conditional) */
            if (result.good())
            {
                if (!ChannelList.isEmpty())
                {
                    result = ChannelList.write(dataset);
                }
            }
            return result;
        }

        /// <summary>
        /// check the specified SOP class UID for validity.
        /// Currently all waveform SOP classes that are defined in DICOM PS 3.x 2003 are allowed.
        /// </summary>
        /// <param name="sopClassUID"></param>
        /// <returns> true if SOP class UID is valid, false otherwise </returns>
        protected override bool checkSOPClassUID(ref string sopClassUID)
        {
            bool result = false;
            if (base.checkSOPClassUID(ref sopClassUID))
            {
                /* check for all valid/known SOP classes (according to DICOM PS 3.x 2003) */
                if ((sopClassUID == DicomUids.TwelveLeadECGWaveformStorage.UID) ||
                    (sopClassUID == DicomUids.GeneralECGWaveformStorage.UID) ||
                    (sopClassUID == DicomUids.AmbulatoryECGWaveformStorage.UID) ||
                    (sopClassUID == DicomUids.HemodynamicWaveformStorage.UID) ||
                    (sopClassUID == DicomUids.CardiacElectrophysiologyWaveformStorage.UID) ||
                    (sopClassUID == DicomUids.BasicVoiceAudioWaveformStorage.UID))
                {
                    result = true;
                }
            }
            return result;
        }
    }
}
