using ClearCanvas.Dicom;
using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;
using System.Threading.Tasks;

namespace Hydra.Dicom
{
    public class DSRGraphicData3DItem
    {
        /// <summary>
        /// constructor
        /// </summary>
        /// <param name="x"></param>
        /// <param name="y"></param>
        /// <param name="z"></param>
        public DSRGraphicData3DItem(float x = 0, float y = 0, float z = 0)
        {
            XCoord = x;
            YCoord = y;
            ZCoord = z;
        }

        /// x value (VR=FL)
        public float XCoord;
        /// y value (VR=FL)
        public float YCoord;
        /// z value (VR=FL)
        public float ZCoord;
    };

    public class DSRGraphicData3DList : DSRListOfItems<DSRGraphicData3DItem>
    {
        /// <summary>
        /// default constructor
        /// </summary>
        public DSRGraphicData3DList()
            : base()
        { 
        }

        /// <summary>
        /// copy constructor
        /// </summary>
        /// <param name="lst"></param>
        DSRGraphicData3DList(ref DSRGraphicData3DList lst)
        {

        }

        ~DSRGraphicData3DList()
        {
        }

        /// <summary>
        /// print list of graphic data.
        /// The output of a typical list looks like this: 0/0/0,127/127/127,255/255/255
        /// </summary>
        /// <param name="stream"></param>
        /// <param name="flags"></param>
        /// <param name="itemSeparator"></param>
        /// <param name="tripletSeparator"></param>
        /// <returns> status, EC_Normal if successful, an error code otherwise </returns>
        public E_Condition print(ref StringBuilder stream, int flags = 0, char tripletSeparator = '/', char itemSeparator = ',')
        {
            string buffer = string.Empty;
            foreach(DSRGraphicData3DItem iterator in ItemList)
            {
                buffer = string.Format("{0}", iterator.XCoord);
                stream.Append(buffer);
                stream.Append(tripletSeparator);
                buffer = string.Format("{0}", iterator.YCoord);
                stream.Append(buffer);
                stream.Append(tripletSeparator);
                buffer = string.Format("{0}", iterator.ZCoord);
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
        /// read list of graphic data
        /// </summary>
        /// <param name="dataset"></param>
        /// <returns> status, EC_Normal if successful, an error code otherwise </returns>
        public E_Condition read(ref DicomAttributeCollection dataset)
        {
            //TODO: Need to validate by debugging
            /* get integer string from dataset */
            DicomAttribute delem = DSRTypes.getDicomAttribute(DicomTags.GraphicData);
            E_Condition result = DSRTypes.getAndCheckElementFromDataset(dataset, ref delem, "3-3n", "1", "SCOORD3D content item");
            if (result.good())
            {
                /* clear internal list */
                clear();
                float x = 0;
                float y = 0;
                float z = 0;
                long count = delem.Count;
                /* fill list with values from floating point string */
                int i = 0;
                float defaultValue = -1;
                while ((i < count) && result.good())
                {
                    x = delem.GetFloat32(i++, defaultValue);
                    if (x != defaultValue)
                    {
                        y = delem.GetFloat32(i++, defaultValue);
                        if (y != defaultValue)
                        {
                            z = delem.GetFloat32(i++, defaultValue);
                            if (z != defaultValue)
                            {
                                addItem(x, y, z);
                                result = E_Condition.EC_Normal;
                            }
                        }
                    }
                }
            }

            return result;
        }

        /// <summary>
        /// write list of graphic data
        /// </summary>
        /// <param name="dataset"></param>
        /// <returns> status, EC_Normal if successful, an error code otherwise </returns>
        public E_Condition write(ref DicomAttributeCollection dataset)
        {
            E_Condition result = E_Condition.EC_Normal;
            /* fill string with values from list */
            DicomAttribute delem = DSRTypes.getDicomAttribute(DicomTags.GraphicData);

            int idx = 0;
            DSRGraphicData3DItem iterator = ItemList.ElementAt(idx);
            int i = 0;
            try
            {
                while ((iterator != null) && result.good())
                {
                    try
                    {
                        delem.SetFloat32(i++, (iterator).XCoord);
                        delem.SetFloat32(i++, (iterator).YCoord);
                        delem.SetFloat32(i++, (iterator).ZCoord);
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
                result = DSRTypes.addElementToDataset(dataset, delem, "3-3n", "1", "SCOORD3D content item");
            }
            return result;
        }

        /// <summary>
        /// get reference to the specified item
        /// </summary>
        /// <param name="idx"></param>
        /// <returns> reference to the specified item if successful, EmptyItem otherwise </returns>
        public DSRGraphicData3DItem getItem(int idx)
        {
            /* hidden by the following getItem() method */
            return base.getItem(idx);
        }

        /// <summary>
        /// get copy of the specified value triplet
        /// </summary>
        /// <param name="idx"></param>
        /// <param name="x"></param>
        /// <param name="y"></param>
        /// <param name="z"></param>
        /// <returns> status, EC_Normal if successful, an error code otherwise </returns>
        public E_Condition getItem(int idx, ref float x, ref float y, ref float z)
        {
            DSRGraphicData3DItem item = new DSRGraphicData3DItem();    /* default: 0,0,0 */
            E_Condition result = base.getItem(idx, ref item);
            x = item.XCoord;
            y = item.YCoord;
            z = item.ZCoord;

            return result;
        }

        /// <summary>
        /// add value triplet to the list
        /// </summary>
        /// <param name="x"></param>
        /// <param name="y"></param>
        /// <param name="z"></param>
        /// <returns> status, EC_Normal if successful, an error code otherwise </returns>
        public void addItem(float x, float y, float z)
        {
            base.addItem(new DSRGraphicData3DItem(x, y, z));
        }

        /// <summary>
        /// put list of graphic data as a string.
        /// This function expects the same input format as created by print(), i.e. a comma
        /// separated list of numerical value triplets.
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
                float x = 0;
                float y = 0;
                float z = 0;
                bool success = false;
                string[] commaSeperatedValues = stringValue.Split(',');
                /* retrieve data triplets from string */
                foreach(string ptr in commaSeperatedValues)
                {
                    if(result.bad())
                    {
                        break;
                    }

                    string[] stringValues = stringValue.Split('/');
                    if(stringValues.Count() > 0)
                    {
                        /* first get the 'x' value */
                        success = float.TryParse(stringValues[0], out x);
                        if (success && stringValues.Count() > 1)
                        {
                            /* then get the 'y' value */
                            success = float.TryParse(stringValues[1], out y);
                            if (success && stringValues.Count() > 2)
                            {
                                /* then get the 'z' value */
                                success = float.TryParse(stringValues[1], out z);
                                if (success)
                                {
                                    addItem(x, y, z);
                                }
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
