using ClearCanvas.Dicom;
using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;
using System.Threading.Tasks;

namespace Hydra.Dicom
{
    public class DSRImageFrameList : DSRListOfItems<Int32>
    {
        /// <summary>
        /// default constructor
        /// </summary>
        public DSRImageFrameList()
        { 
        }

        /// <summary>
        /// copy constructor
        /// </summary>
        /// <param name="lst"></param>
        public DSRImageFrameList(ref DSRImageFrameList lst)
        {

        }

        ~DSRImageFrameList()
        {
        }

        /// <summary>
        /// print list of referenced frame numbers.
        /// The output of a typical list looks like this: 1,2,3 or 1,... if shortened.
        /// </summary>
        /// <param name="stream"></param>
        /// <param name="flags"></param>
        /// <param name="separator"></param>
        /// <returns> status, EC_Normal if successful, an error code otherwise </returns>
        public E_Condition print(ref StringBuilder stream, int flags = 0, char separator = ',')
        {
            foreach (UInt32 iterator in ItemList)
            {
                stream.Append(iterator);
                if ((flags & DSRTypes.PF_shortenLongItemValues) != 0)
                {
                    stream.Append(separator);
                    stream.Append("...");
                    /* goto last item */
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
        /// read list of referenced frame numbers.
        /// </summary>
        /// <param name="dataset"></param>
        /// <returns> status, EC_Normal if successful, an error code otherwise </returns>
        public E_Condition read(ref DicomAttributeCollection dataset)
        {
            //TODO: Need to validate by debugging
            /* get integer string from dataset */
            DicomAttribute delem = DSRTypes.getDicomAttribute(DicomTags.ReferencedFrameNumber);
            E_Condition result = DSRTypes.getElementFromDataset(dataset, ref delem);
            if (result.good())
            {
                /* clear internal list */
                clear();
                int value = 0;
                long count = delem.Count;
                /* fill list with values from integer string */
                for (uint i = 0; i < count; i++)
                {
                    if (delem.GetUInt32(value, i) != 0)
                    {
                        addItem(value);
                    }
                }
            }

            return result;
        }

        /// <summary>
        /// write list of referenced frame numbers.
        /// </summary>
        /// <param name="dataset"></param>
        /// <returns> status, EC_Normal if successful, an error code otherwise </returns>
        public E_Condition write(ref DicomAttributeCollection dataset)
        {
            E_Condition result = E_Condition.EC_Normal;
            /* fill string with values from list */
            string tmpString = string.Empty;
            string buffer = string.Empty;
            foreach(UInt32 iterator in ItemList)
            {
                if (!string.IsNullOrEmpty(tmpString))
                {
                    tmpString += '\\';
                }

                buffer = string.Format("{0}", iterator);
                tmpString += buffer;
            }

            /* set integer string */
            //DcmIntegerString delem(DCM_ReferencedFrameNumber);
            //result = delem.putOFStringArray(tmpString);/
            /* add to dataset */
            //if (result.good())
            //result = DSRTypes::addElementToDataset(result, dataset, new DcmIntegerString(delem), "1-n", "1", "IMAGE content item");
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
                int value = 0;
                string[] stringValues = stringValue.Split(' ');
                foreach (string ptr in stringValues)
                {
                    Int32.TryParse(ptr, out value);
                    addItem(value);
                }
            }

            return result;
        }
    }
}
