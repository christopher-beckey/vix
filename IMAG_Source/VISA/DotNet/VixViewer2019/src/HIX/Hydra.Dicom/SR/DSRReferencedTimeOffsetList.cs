using ClearCanvas.Dicom;
using System;
using System.Collections.Generic;
using System.Globalization;
using System.Linq;
using System.Text;
using System.Threading.Tasks;

namespace Hydra.Dicom
{
    public class DSRReferencedTimeOffsetList : DSRListOfItems<float>
    {
        /** default constructor
        */
        public DSRReferencedTimeOffsetList()
            :base()
        {
        }

        /** copy constructor
        ** @param  lst  list to be copied
        */
        public DSRReferencedTimeOffsetList(ref DSRReferencedTimeOffsetList lst)
        {
        }

        /** destructor
        */
        ~DSRReferencedTimeOffsetList()
        {

        }

        /** print list of referenced time offsets.
        *  The output of a typical list looks like this: 1,2.5 or 1,... if shortened.
        ** @param  stream     output stream to which the list should be printed
        *  @param  flags      flag used to customize the output (see DSRTypes::PF_xxx)
        *  @param  separator  character specifying the separator between the list items
        ** @return status, EC_Normal if successful, an error code otherwise
        */
        public E_Condition print(ref StringBuilder stream, int flags = 0, char separator = ',')
        {
            string buffer = string.Empty;
            foreach(float iterator in ItemList)
            {
                buffer = string.Format("{0}", iterator);
                stream.Append(buffer);
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

        /** read list of referenced time offsets
        ** @param  dataset    DICOM dataset from which the list should be read
        ** @return status, EC_Normal if successful, an error code otherwise
        */
        public E_Condition read(ref DicomAttributeCollection dataset)
        {
            //TODO: Need to validate by debugging
            /* get decimal string from dataset */
            DicomAttribute delem = DSRTypes.getDicomAttribute(DicomTags.ReferencedTimeOffsets);
            E_Condition result = DSRTypes.getAndCheckElementFromDataset(dataset, ref delem, "1-n", "1C", "TCOORD content item");
            if (result.good())
            {
                /* clear internal list */
                clear();
                double value = 0;
                long count = delem.Count;
                /* fill list with values from decimal string */
                double defaultValue = -1;
                for (int i = 0; i < count; i++)
                {
                    value = delem.GetFloat64(i, defaultValue);
                    if(value != defaultValue)
                    {
                        addItem((float)value);
                    }
                }
            }

            return result;
        }

        /** write list of referenced time offsets
        ** @param  dataset    DICOM dataset to which the list should be written
        ** @return status, EC_Normal if successful, an error code otherwise
        */
        public E_Condition write(ref DicomAttributeCollection dataset)
        {
            E_Condition result = E_Condition.EC_Normal;
            /* fill string with values from list */
            string tmpString = string.Empty;
            string buffer = string.Empty;
            /* fill string with values from list */
            foreach(float iterator in ItemList)
            {
                if (!string.IsNullOrEmpty(tmpString))
                {
                    tmpString += '\\';
                }
                buffer = string.Format("{0}", iterator);
                tmpString += buffer;
            }


            /* set decimal string */
            DicomAttribute delem = DSRTypes.getDicomAttribute(DicomTags.ReferencedTimeOffsets);
            delem.SetStringValue(tmpString);
            /* add to dataset */
            if (result.good())
            {
                result = DSRTypes.addElementToDataset(dataset, delem, "1-n", "1", "TCOORD content item");
            }
            return result;
        }

        /** put list of referenced time offsets as a string.
        *  This function expects the same input format as created by print(), i.e. a comma
        *  separated list of numerical values.
        ** @param  stringValue  string value to be set
        ** @return status, EC_Normal if successful, an error code otherwise
        */
        public E_Condition putString(string stringValue)
        {
            E_Condition result = E_Condition.EC_Normal;
            /* clear internal list */
            clear();
            /* check input string */
            if ((stringValue != null) && (stringValue.Length > 0))
            {
                float value = 0;
                string[] stringList = stringValue.Split(',');
                /* retrieve time offsets from string */
                foreach (string ptr in stringList)
                {
                    value = float.Parse(ptr, CultureInfo.InvariantCulture.NumberFormat);
                    addItem(value);
                }
            }

            return result;
        }
    }
}
