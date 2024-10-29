using System;
using System.Collections.Generic;
using System.Text;
using System.Diagnostics;

namespace gov.va.med.imaging.exchange.VixInstaller.business
{
    public class ProductVersion : IComparable 
    {
        private Int32 productVersionAsInt = 0;
        private string productVersionAsString;

        public ProductVersion(String productVersion)
        {
            this.productVersionAsString = productVersion;
            string[] splits = productVersion.Split('.');
            Debug.Assert(splits.Length == 4);
            foreach (String split in splits)
            {
                this.productVersionAsInt += Int32.Parse(split);
            }
        }

        public override string ToString()
        {
            return this.productVersionAsString;
        }

        public int CompareTo(object obj)
        {
            if (!(obj is ProductVersion))
            {
                throw new ArgumentException(
                   "A ProductVersion object is required for comparison.");
            }
            return this.productVersionAsInt.CompareTo(((ProductVersion)obj).productVersionAsInt);
        }

        // Omitting Equals violates rule: OverrideMethodsOnComparableTypes.
        public override bool Equals(Object obj)
        {
            if (!(obj is ProductVersion))
                return false;
            return (this.CompareTo(obj) == 0);
        }

        // Omitting getHashCode violates rule: OverrideGetHashCodeOnOverridingEquals.
        public override int GetHashCode()
        {
            return this.productVersionAsInt;
        }

        // Omitting any of the following operator overloads 
        // violates rule: OverrideMethodsOnComparableTypes.
        public static bool operator ==(ProductVersion v1, ProductVersion v2)
        {
            return v1.Equals(v2);
        }
        public static bool operator !=(ProductVersion v1, ProductVersion v2)
        {
            return !(v1 == v2);
        }
        public static bool operator <(ProductVersion v1, ProductVersion v2)
        {
            return (v1.CompareTo(v2) < 0);
        }
        public static bool operator >(ProductVersion v1, ProductVersion v2)
        {
            return (v1.CompareTo(v2) > 0);
        }

        // other operators
        public static bool operator >=(ProductVersion v1, ProductVersion v2)
        {
            return (v1.CompareTo(v2) >= 0);
        }
        public static bool operator <=(ProductVersion v1, ProductVersion v2)
        {
            return (v1.CompareTo(v2) <= 0);
        }  


    }
}
