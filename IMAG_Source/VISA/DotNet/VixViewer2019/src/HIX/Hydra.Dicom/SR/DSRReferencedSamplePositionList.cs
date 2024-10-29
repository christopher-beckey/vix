using ClearCanvas.Dicom;
using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;
using System.Threading.Tasks;

namespace Hydra.Dicom
{
    public class DSRReferencedSamplePositionList : DSRListOfItems<UInt32>
    {
        /// the list maintained by this class
        //TODO: DSRReferencedSamplePositionList
        //protected List<T> ItemList;

        /** default constructor
        */
        public DSRReferencedSamplePositionList()
            :base()
        {
        }

        /** copy constructor
        ** @param  lst  list to be copied
        */
        public DSRReferencedSamplePositionList(ref DSRReferencedSamplePositionList lst)
        {
        }

        /** destructor
        */
        ~DSRReferencedSamplePositionList()
        {

        }

        /** print list of referenced sample positions.
        *  The output of a typical list looks like this: 1,2,3 or 1,... if shortened.
        ** @param  stream     output stream to which the list should be printed
        *  @param  flags      flag used to customize the output (see DSRTypes::PF_xxx)
        *  @param  separator  character specifying the separator between the list items
        ** @return status, EC_Normal if successful, an error code otherwise
        */
        public E_Condition print(ref StringBuilder stream, int flags = 0, char separator = ',')
        {
            foreach(UInt32 iterator in ItemList)
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

        /** read list of referenced sample positions
        ** @param  dataset    DICOM dataset from which the list should be read
        ** @return status, EC_Normal if successful, an error code otherwise
        */
        public E_Condition read(ref DicomAttributeCollection dataset)
        {
            //TODO: Need to validate by debugging
            /* get element from dataset */
            DicomAttribute delem = DSRTypes.getDicomAttribute(DicomTags.ReferencedSamplePositions);
            E_Condition result = DSRTypes.getAndCheckElementFromDataset(dataset, ref delem, "1-n", "1C", "TCOORD content item");
            if (result.good())
            {
                /* clear internal list */
                clear();
                UInt32 value;
                long count = delem.Count;
                /* fill list with values from integer string */
                UInt32 defaultValue = 0;
                for(int i = 0; i<count; i++)
                {
                    value = delem.GetUInt32(i, defaultValue);
                    if (value != defaultValue)
                    {
                        addItem(value);
                        result = E_Condition.EC_Normal;
                    }
                }
            }

            return result;
        }

        /** write list of referenced sample positions
        ** @param  dataset    DICOM dataset to which the list should be written
        ** @return status, EC_Normal if successful, an error code otherwise
        */
        public E_Condition write(ref DicomAttributeCollection dataset)
        {
            E_Condition result = E_Condition.EC_Normal;
            /* set decimal string */
            DicomAttribute delem = DSRTypes.getDicomAttribute(DicomTags.ReferencedSamplePositions);
            int i = 0;
            /* fill string with values from list */
            try
            {
                foreach(UInt32 iterator in ItemList)
                {
                    delem.SetUInt32(i++, iterator);
                }

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

        /** put list of referenced sample positions as a string.
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
                UInt32 value = 0;
                /* retrieve sample positions from string */
                string[] stringList = stringValue.Split(',');
                foreach (string ptr in stringList)
                {
                    value = Convert.ToUInt32(ptr);
                    addItem(value);
                }
            }

            return result;
        }
    }
}
