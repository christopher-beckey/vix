using ClearCanvas.Dicom;
using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;
using System.Threading.Tasks;

namespace Hydra.Dicom
{
    public class DSRReferencedDatetimeList : DSRListOfItems<string>
    {
        /// <summary>
        /// constructor
        /// </summary>
        public DSRReferencedDatetimeList()
            :base()
        {
        }

        /// <summary>
        /// copy constructor
        /// </summary>
        /// <param name="theDSRReferencedDatetimeList"></param>
        public DSRReferencedDatetimeList(DSRReferencedDatetimeList theDSRReferencedDatetimeList)
        {
        }

        /// <summary>
        /// destructor
        /// </summary>
        ~DSRReferencedDatetimeList()
        {

        }

        /// <summary>
        /// print list of referenced datetime.
        /// The output of a typical list looks like this: 20001010120000, ...
        /// </summary>
        /// <param name="stream"></param>
        /// <param name="flags"></param>
        /// <param name="separator"></param>
        /// <returns> status, EC_Normal if successful, an error code otherwise </returns>
        public E_Condition print(ref StringBuilder stream, int flags = 0, char separator = ',')
        {
            foreach(string iterator in ItemList)
            {
                stream.Append(iterator);
                if ((flags & DSRTypes.PF_shortenLongItemValues) != 0)
                {
                    stream.Append(separator);
                    stream.Append("...");
                    break;
                }
                else
                {
                    stream.Append(separator);
                }
            }

            return E_Condition.EC_Normal;
        }

        /// <summary>
        /// read list of referenced datetime.
        /// </summary>
        /// <param name="dataset"></param>
        /// <returns> status, EC_Normal if successful, an error code otherwise </returns>
        public E_Condition read(ref DicomAttributeCollection dataset)
        {
            //TODO: Need to validate by debugging
            /* get floating point string from dataset */
            DicomAttribute delem = DSRTypes.getDicomAttribute(DicomTags.ReferencedDatetime);
            E_Condition result = DSRTypes.getAndCheckElementFromDataset(dataset, ref delem, "1-n", "1C", "TCOORD content item");
            if (result.good())
            {
                /* clear internal list */
                clear();
                string value;
                long count = delem.Count;
                /* fill list with values from string array */
                string defaultValue = string.Empty;
                for(int i = 0; i<count; i++)
                {
                    value = delem.GetString(i, defaultValue);
                    if (value != defaultValue)
                    {
                        addItem(value);
                        result = E_Condition.EC_Normal;
                    }
                }
            }

            return result;
        }

        /// <summary>
        /// write list of referenced datetime.
        /// </summary>
        /// <param name="dataset"></param>
        /// <returns> status, EC_Normal if successful, an error code otherwise </returns>
        public E_Condition write(ref DicomAttributeCollection dataset)
        {
            E_Condition result = E_Condition.EC_Normal;

            int idx = 0;
            string iterator = ItemList.ElementAt(idx);
            int i = 0;
            /* fill string with values from list */
            string tmpString = string.Empty;
            try
            {
                while (iterator != null)
                {
                    if (!string.IsNullOrEmpty(tmpString))
                        tmpString += '\\';
                    tmpString += iterator;

                    idx++;
                    iterator = ItemList.ElementAt(idx) ;
                }

                /* set decimal string */
                DicomAttribute delem = DSRTypes.getDicomAttribute(DicomTags.ReferencedDatetime);
                delem.SetStringValue(tmpString);
                /* add to dataset */
                if (result.good())
                {
                    result = DSRTypes.addElementToDataset(dataset, delem, "1-n", "1", "TCOORD content item");
                }
            }
            catch(Exception)
            {
            }

            return result;
        }

        /// <summary>
        /// put list of referenced frame numbers as a string.
        /// This function expects the same input format as created by print(), i.e. a comma separated list of numerical values.
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
                string[] stringList = stringValue.Split(',');
                if (stringList.Count() > 0)
                {
                    /* retrieve datetime values from string */
                    foreach (string ptr1 in stringList)
                    {
                        if (string.IsNullOrEmpty(ptr1))
                        {
                            continue;
                        }
                        addItem(ptr1);
                    }
                }
                else
                {
                    addItem(stringValue);
                }
            }

            return result;
        }
    }
}
