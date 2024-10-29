using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;
using System.Threading.Tasks;
using ClearCanvas.Dicom;

namespace Hydra.Dicom
{
    public class DSRWaveformChannelItem
    {
        /// <summary>
        /// multiplex group number value (VR=US)
        /// </summary>
        public UInt16 MultiplexGroupNumber;

        /// <summary>
        /// channel number value (VR=US)
        /// </summary>
        public UInt16 ChannelNumber;

        /// <summary>
        /// Default Constructor
        /// </summary>
        public DSRWaveformChannelItem(UInt16 multiplexGroupNumber = 0, UInt16 channelNumber = 0)
        {
            //TODO: DSRWaveformChannelItem
            MultiplexGroupNumber = multiplexGroupNumber;
            ChannelNumber = channelNumber;
        }             
    }
	
	public class DSRWaveformChannelList : DSRListOfItems<DSRWaveformChannelItem>
    {
        /// <summary>
        /// Default Constructor
        /// </summary>
        public DSRWaveformChannelList()
            :base()
        {
            //TODO: DSRWaveformChannelList            
        }

        /// <summary>
        /// copy constructor
        /// </summary>
        /// <param name="cursor">lst  list to be copied</param>
        public DSRWaveformChannelList(DSRWaveformChannelList lst)
        {
            //TODO: DSRWaveformChannelList
        }

        /// <summary>
        /// print list of waveform channels.
        /// The output of a typical list looks like this: 1/2,3/4,5/6
        /// </summary>
        /// <param name="stream">output stream to which the list should be printed</param>
        /// <param name="flags">flag used to customize the output (see DSRTypes::PF_xxx)</param>
        /// <param name="pairSeparator">character specifying the separator between the value pairs</param>
        /// <param name="itemSeparator">character specifying the separator between the list items</param>
        /// <returns>true if success otherwise false</returns>
        public E_Condition print(StringBuilder stream, int flags = 0, char pairSeparator = '/', char itemSeparator = '/')
        {
            foreach(DSRWaveformChannelItem iterator in ItemList)
            {
                if(iterator == null)
                {
                    continue;
                }

                stream.Append(iterator.MultiplexGroupNumber);
                stream.Append(pairSeparator);
                stream.Append(iterator.ChannelNumber);
                if ((flags & DSRTypes.PF_shortenLongItemValues) != 0)
                {
                    stream.Append(itemSeparator);
                    stream.Append("...");
                }
                else
                {
                    stream.Append(itemSeparator);
                }
            }

            return E_Condition.EC_Normal;
        }

        /// <summary>
        /// read list of waveform channels
        /// </summary>
        /// <param name="dataset">DICOM dataset from which the list should be read</param>
        /// <returns>true if success, otherwise false</returns>
        public E_Condition read(DicomAttributeCollection dataset)
        {
            /* get integer string from dataset */
            DicomAttribute delem = DSRTypes.getDicomAttribute(DicomTags.ReferencedWaveformChannels);
            E_Condition result = DSRTypes.getAndCheckElementFromDataset(dataset, ref delem, "2-2n", "1C", "WAVEFORM content item");
            if (result.good())
            {
                /* clear internal list */
                clear();
                UInt16 group = 0;
                UInt16 channel = 0;
                UInt16 defaultValue = 65535;
                long count = delem.Count;

                /* fill list with values from integer string */
                int i = 0;
                while ((i < count) && result.good())
                {
                    group = delem.GetUInt16(i++, defaultValue);
                    if (group != defaultValue)
                    {
                        result = E_Condition.EC_Normal;
                        channel = delem.GetUInt16(i++, defaultValue);
                        if (channel != defaultValue)
                        {
                            result = E_Condition.EC_Normal;
                            addItem(group, channel);
                        }
                    }
                }
            }

            return result;
        }

        /// <summary>
        /// write list of waveform channels
        /// </summary>
        /// <param name="dataset">DICOM dataset to which the list should be written</param>
        /// <returns>true if success, false otherwise</returns>
        public E_Condition write(DicomAttributeCollection dataset)
        {
            E_Condition result = E_Condition.EC_Normal;
            /* fill string with values from list */
            DicomAttribute delem = DSRTypes.getDicomAttribute(DicomTags.ReferencedWaveformChannels);
            int i = 0;
            foreach(DSRWaveformChannelItem iterator in ItemList)
            {
                if(iterator == null)
                {
                    continue;
                }

                try
                {
                    delem.SetUInt16(i++, iterator.MultiplexGroupNumber);
                    delem.SetUInt16(i++, iterator.ChannelNumber);
                }
                catch(Exception)
                {
                    result = E_Condition.EC_CorruptedData;
                }
            }

            /* add to dataset */
            if (result.good())
            {
                result = DSRTypes.addElementToDataset(dataset, delem, "2-2n", "1", "WAVEFORM content item");
            }

            return result;
        }

        /// <summary>
        /// check whether specified value pair is contained in the list
        /// </summary>
        /// <param name="multiplexGroupNumber">multiplex group number to be checked</param>
        /// <param name="channelNumber">channel number to be checked</param>
        /// <returns>true if the value pair is in the list, false otherwise</returns>
        public bool isElement(UInt16 multiplexGroupNumber, UInt16 channelNumber)
        {
            return base.isElement(new DSRWaveformChannelItem(multiplexGroupNumber, channelNumber));
        }

        /// <summary>
        /// get copy of the specified value pair
        /// </summary>
        /// <param name="idx">index of the value pair to be returned (starting from 1)</param>
        /// <param name="multiplexGroupNumber">multiplex group number of the specified index (set to 0)</param>
        /// <param name="channelNumber">channel number of the specified index (set to 0 first)</param>
        /// <returns>true if success, false otherwise</returns>
        public E_Condition getItem(int idx, UInt16 multiplexGroupNumber, UInt16 channelNumber)
        {
            DSRWaveformChannelItem item = new DSRWaveformChannelItem();    /* default: 0,0 */
            E_Condition result = base.getItem(idx, ref item);
            multiplexGroupNumber = item.MultiplexGroupNumber;
            channelNumber = item.ChannelNumber;

            return result;
        }

        /// <summary>
        /// add value pair to the list
        /// </summary>
        /// <param name="multiplexGroupNumber">multiplex group number to be added</param>
        /// <param name="channelNumber">channel number to be added</param>
        /// <returns>true if success, false otherwise</returns>
        public void addItem(UInt16 multiplexGroupNumber, UInt16 channelNumber)
        {
            base.addItem(new DSRWaveformChannelItem(multiplexGroupNumber, channelNumber));
        }

        /// <summary>
        /// put list of waveform channels as a string.
        /// This function expects the same input format as created by print(), i.e. a comma
        /// separated list of numerical value pairs.
        /// </summary>
        /// <param name="stringValue">string value to be set</param>
        /// <returns>true if success, false otherwise</returns>
        public E_Condition putString(string stringValue)
        {
            E_Condition result = E_Condition.EC_Normal;
            /* clear internal list */
            clear();
            /* check input string */
            if ((stringValue != null) && (stringValue.Length > 0))
            {
                UInt16 group = 0;
                UInt16 channel = 0;

                string[] commaSeparatesValues = stringValue.Split(',');
                foreach (string ptr in commaSeparatesValues)
                {
                    int idx = ptr.IndexOf('/');
                    if (idx > -1)
                    {
                        // Get first three characters.
                        string sub = ptr.Substring(0, idx);
                        group = UInt16.Parse(sub);
                        idx += 1;
                        sub = ptr.Substring((idx), (ptr.Length - idx));
                        channel = UInt16.Parse(sub);
                        addItem(group, channel);
                    }
                }
            }

            return result;
        }
    }
}
