using System;
using System.Collections.Generic;
using System.Linq;

namespace Hydra.Log
{
    public class DataFieldArray
    {
        private string[] _Names = null;
        private List<object[]> _Values = new List<object[]>();

        public DataFieldArray(params object[] names)
        {
            if ((names == null) || (names.Length == 0))
                throw new ArgumentNullException();

            _Names = names.Select(x => x as string).ToArray();
        }

        public void AddItem(params object[] itemValues)
        {
            if ((itemValues == null) || (itemValues.Length == 0))
                throw new ArgumentNullException();

            if (itemValues.Length != _Names.Length)
                throw new ArgumentException("Values count does not match Names count");

            _Values.Add(itemValues);
        }

        public IEnumerable<Object[]> Values
        {
            get
            {
                return _Values;
            }
        }

        public string[] Names
        {
            get
            {
                return _Names;
            }
        }
    }
}