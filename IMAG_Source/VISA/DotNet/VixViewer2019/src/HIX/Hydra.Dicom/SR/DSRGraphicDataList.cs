using ClearCanvas.Dicom;
using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;
using System.Threading.Tasks;

namespace Hydra.Dicom
{
    public class DSRGraphicDataItem
    {
        /// <summary>
        /// constructor
        /// </summary>
        /// <param name="column"></param>
        /// <param name="row"></param>
        public DSRGraphicDataItem(float column = 0, float row = 0)
        {
            Column = column;
            Row = row;
        }

        /// column value (VR=FL)
        public float Column;
        /// row value (VR=FL)
        public float Row;
    }

    public class DSRGraphicDataList : DSRListOfItems<DSRGraphicDataItem>
    {
        /// <summary>
        /// constructor
        /// </summary>
        public DSRGraphicDataList()
            : base()
        {
        }

        /// <summary>
        /// copy constructor
        /// </summary>
        /// <param name="theDSRGraphicDataList"></param>
        public DSRGraphicDataList(DSRGraphicDataList theDSRGraphicDataList)
        {
            //TODO: Need to handle copy constructor
        }

        /// <summary>
        /// destructor
        /// </summary>
        ~DSRGraphicDataList()
        {

        }

        /// <summary>
        /// print list of graphic data.
        /// The output of a typical list looks like this: 0/0,127/127,255/255
        /// </summary>
        /// <param name="stream"></param>
        /// <param name="flags"></param>
        /// <param name="itemSeparator"></param>
        /// <param name="pairSeparator"></param>
        /// <returns> status, EC_Normal if successful, an error code otherwise </returns>
        public E_Condition print(ref StringBuilder stream, int flags = 0, char pairSeparator = '/', char itemSeparator = ',')
        {
            string buffer = string.Empty;
            foreach(DSRGraphicDataItem iterator in ItemList)
            {
                buffer = string.Format("{0}", iterator.Column);
                stream.Append(buffer);
                stream.Append(pairSeparator);
                buffer = string.Format("{0}", iterator.Row);
                stream.Append(buffer);
                if ((flags & DSRTypes.PF_shortenLongItemValues) != 0)
                {
                    stream.Append(itemSeparator);
                    stream.Append("...");
                    break;
                }
                else
                {
                    stream.Append(itemSeparator);
                }
            }

            return E_Condition.EC_Normal;
        }

        /// <summary>
        /// read list of graphic data.
        /// </summary>
        /// <param name="dataset"></param>
        /// <returns> status, EC_Normal if successful, an error code otherwise </returns>
        public E_Condition read(ref DicomAttributeCollection dataset)
        {
            //TODO: Need to validate by debugging
            /* get floating point string from dataset */
            DicomAttribute delem = DSRTypes.getDicomAttribute(DicomTags.GraphicData);
            E_Condition result = DSRTypes.getAndCheckElementFromDataset(dataset, ref delem, "2-2n", "1", "SCOORD content item");
            if (result.good())
            {
                /* clear internal list */
                clear();
                float column = 0;
                float row = 0;
                long count = delem.Count;
                /* fill list with values from floating point string */
                int i = 0;
                float defaultValue = -1;
                while ((i < count) && result.good())
                {
                    column = delem.GetFloat32(i++, defaultValue);
                    if (column != defaultValue)
                    {
                        row = delem.GetFloat32(i++, defaultValue);
                        if (row != defaultValue)
                        {
                            addItem(column, row);
                            result = E_Condition.EC_Normal;
                        }
                    }
                }
            }

            return result;
        }

        /// <summary>
        /// write list of graphic data.
        /// </summary>
        /// <param name="dataset"></param>
        /// <returns> status, EC_Normal if successful, an error code otherwise </returns>
        public E_Condition write(ref DicomAttributeCollection dataset)
        {
            E_Condition result = E_Condition.EC_Normal;
            /* fill string with values from list */
            DicomAttribute delem = DSRTypes.getDicomAttribute(DicomTags.GraphicData);

            int idx = 0;
            DSRGraphicDataItem iterator = ItemList.ElementAt(idx);
            int i = 0;
            try
            {
                while ((iterator != null) && result.good())
                {
                    try
                    {
                        delem.SetFloat32(i++, (iterator).Column);
                        delem.SetFloat32(i++, (iterator).Row);
                    }
                    catch(Exception)
                    {
                        result = E_Condition.EC_CorruptedData;
                    }
                    idx++;
                    iterator = ItemList.ElementAt(idx) ;
                }
            }
            catch(Exception)
            {
            }

            /* add to dataset */
            if (result.good())
            {
                result = DSRTypes.addElementToDataset(dataset, delem, "2-2n", "1", "SCOORD content item");
            }
            return result;
        }

        /// <summary>
        /// get reference to the specified item
        /// </summary>
        /// <param name="idx"></param>
        /// <returns> reference to the specified item if successful, EmptyItem otherwise </returns>
        public DSRGraphicDataItem getItem(int idx)
        {
            /* hidden by the following getItem() method */
            return base.getItem(idx);
        }

        /// <summary>
        /// get copy of the specified value pair.
        /// </summary>
        /// <param name="idx"></param>
        /// <param name="column"></param>
        /// <param name="row"></param>
        /// <returns> status, EC_Normal if successful, an error code otherwise </returns>
        public E_Condition getItem(int idx, ref float column, ref float row)
        {
            DSRGraphicDataItem item = new DSRGraphicDataItem();    /* default: 0,0 */
            E_Condition result = base.getItem(idx, ref item);
            column = item.Column;
            row = item.Row;

            return result;
        }

        /// <summary>
        /// add value pair to the list.
        /// </summary>
        /// <param name="column"></param>
        /// <param name="row"></param>
        public void addItem(float column, float row)
        {
            base.addItem(new DSRGraphicDataItem(column, row));
        }

        /// <summary>
        /// put list of graphic data as a string.
        /// This function expects the same input format as created by print(), i.e. a comma separated list of numerical value pairs.
        /// </summary>
        /// <param name="stringValue"></param>
        /// <returns> status, EC_Normal if successful, an error code otherwise </returns>
        public E_Condition putString(string stringValue)
        {
            E_Condition result = E_Condition.EC_Normal;
            /* clear internal list */
            clear();
            /* check input string */
            if ((stringValue != null) && (stringValue.Length > 0))
            {
                float column = 0;
                float row = 0;
                bool success = false;
                string[] commaSeperatedValues = stringValue.Split(',');
                /* retrieve data pairs from string */
                foreach(string ptr in commaSeperatedValues)
                {
                    if(result.bad())
                    {
                        break;
                    }

                    string[] stringValues = stringValue.Split('/');
                    if(stringValues.Count() > 0)
                    {
                        /* first get the 'column' value */
                        success = float.TryParse(stringValues[0], out column);
                        if (success && stringValues.Count() > 1)
                        {
                            /* then get the 'row' value */
                            success = float.TryParse(stringValues[1], out row);
                            if (success)
                            {
                                addItem(column, row);
                            }
                        }
                        else
                        {
                            result = E_Condition.EC_CorruptedData;
                        }
                    }
                    else
                    {
                        result = E_Condition.EC_CorruptedData;
                    }
                }
            }
            else
            {
                result = E_Condition.EC_CorruptedData;
            }

            return result;
        }
    }
}
