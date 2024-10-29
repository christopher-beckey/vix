using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;
using System.Threading.Tasks;

namespace Hydra.Dicom
{
    public class DSRListOfItems<T>
    {
        /// the list maintained by this class
        protected List<T> ItemList;

        /** default constructor
        */
        public DSRListOfItems()
        {
            if (ItemList == null)
            {
                ItemList = new List<T>();
            }
        }

        /** copy constructor
        ** @param  lst  list to be copied
        */
        public DSRListOfItems(ref DSRListOfItems<T> lst)
        {
            ItemList = lst.ItemList;
        }

        /** destructor
        */
        ~DSRListOfItems()
        {
        }

        /** clear all internal variables
        */
        public void clear()
        {
            ItemList.Clear();
        }

        /** check whether the list is empty
        ** @return OFTrue if the list is empty, OFFalse otherwise
        */
        public bool isEmpty()
        {
            return (ItemList.Count == 0 ? true : false);
        }

        /** get number of items contained in the list
        ** @return number of items if any, 0 otherwise
        */
        public int getNumberOfItems()
        {
            return ItemList.Count;
        }

        /** check whether specified item is contained in the list
        ** @param  item  item to be checked
        ** @return OFTrue if the item is in the list, OFFalse otherwise
        */
        public bool isElement(T item)
        {
            return ItemList.Contains(item);
        }

        /** get reference to the specified item
        ** @param  idx  index of the item to be returned (starting from 1)
        ** @return reference to the specified item if successful, EmptyItem otherwise
        */
        public T getItem(int idx)
        {
            try
            {
                return ItemList.ElementAt(idx);
            }
            catch (Exception)
            {
                return default(T);
            }
        }

        /** get copy of the specified item
        ** @param  idx   index of the item to be returned (starting from 1)
        *  @param  item  reference to a variable where the result should be stored.
        *                (not changed/cleared if an error occurs!)
        ** @return status, EC_Normal if successful, an error code otherwise
        */
        public E_Condition getItem(int idx, ref T item)
        {
            E_Condition result = E_Condition.EC_IllegalParameter;
            try
            {
                item = ItemList.ElementAt(idx);
                result = E_Condition.EC_Normal;
            }
            catch(Exception)
            {
                item = default(T);
            }

            return result;
        }

        /** add item to the list
        ** @param  item  item to be added
        */
        public void addItem(T item)
        {
            ItemList.Add(item);
        }

        /** add item to the list only if it's not already contained
        ** @param  item  item to be added
        */
        public void addOnlyNewItem(T item)
        {
            if (!isElement(item))
            {
                ItemList.Add(item);
            }
        }

        /** insert item at specified position to the list
        ** @param  idx   index of the item before the new one should be inserted (starting from 1)
        *  @param  item  item to be inserted
        ** @return status, EC_Normal if successful, an error code otherwise
        */
        public E_Condition insertItem(int idx, T item)
        {
            E_Condition result = E_Condition.EC_IllegalParameter;
            try
            {
                if (idx == ItemList.Count + 1)
                {
                    /* append to the end of the list */
                    ItemList.Add(item);
                    result = E_Condition.EC_Normal;
                }
                else
                {
                    ItemList.Insert(idx, item);
                    result = E_Condition.EC_Normal;
                }
            }
            catch (Exception)
            { }

            return result;
        }

        /** remove item from the list
        ** @param  idx  index of the item to be removed (starting from 1)
        ** @return status, EC_Normal if successful, an error code otherwise
        */
        E_Condition removeItem(int idx)
        {
            E_Condition result = E_Condition.EC_IllegalParameter;

            try
            {
                if (ItemList.Count <= idx)
                {
                    ItemList.RemoveAt(idx);
                    result = E_Condition.EC_Normal;
                }
            }
            catch(Exception)
            {}

            return result;
        }
    }
}
