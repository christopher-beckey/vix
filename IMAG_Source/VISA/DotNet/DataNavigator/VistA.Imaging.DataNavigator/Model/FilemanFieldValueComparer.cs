// -----------------------------------------------------------------------
// <copyright file="FilemanFieldValueComparer.cs" company="Department of Veterans Affairs">
// TODO: Update copyright text.
// </copyright>
// -----------------------------------------------------------------------

namespace VistA.Imaging.DataNavigator.Model
{
    using System;
    using System.Collections;
    using System.Collections.Generic;
    using System.ComponentModel;

    /// <summary>
    /// TODO: Update summary.
    /// </summary>
    public class FilemanFieldValueComparer : IComparer, IComparer<FilemanFieldValue>
    {
        /// <summary>
        /// Initializes a new instance of the <see cref="FilemanFieldValueComparer"/> class.
        /// </summary>
        /// <param name="direction">The direction.</param>
        public FilemanFieldValueComparer(ListSortDirection? direction)
        {
            this.Direction = direction;
        }

        /// <summary>
        /// Gets or sets the direction of the sort.
        /// </summary>
        public ListSortDirection? Direction { get; set; }

        /// <summary>
        /// Compares two objects and returns a value indicating whether one is less than, equal to, or greater than the other.
        /// </summary>
        /// <param name="x">The first object to compare.</param>
        /// <param name="y">The second object to compare.</param>
        /// <returns>
        /// Value Condition Less than zero x is less than y.  Zero x equals y.  Greater than zero x is greater than y.
        /// </returns>
        public int Compare(FilemanFieldValue x, FilemanFieldValue y)
        {
            int result = 0;
            if (x == null && y == null)
            {
                result = 0;
            }
            else if (x == null)
            {
                result = -1;
            }
            else if (y == null)
            {
                result = 1;
            }
            else if (object.Equals(x.FieldNumber, y.FieldNumber))
            {
                result = 0;
            }
            else
            {
                decimal fieldNumberX = 0;
                decimal fieldNumberY = 0;
                decimal.TryParse(x.FieldNumber, out fieldNumberX);
                decimal.TryParse(y.FieldNumber, out fieldNumberY);
                if (fieldNumberX < fieldNumberY)
                {
                    result = -1;
                }
                else if (fieldNumberX > fieldNumberY)
                {
                    result = 1;
                }
            }

            if (this.Direction == ListSortDirection.Descending)
            {
                result *= -1;
            }

            return result;
        }

        /// <summary>
        /// Compares two objects and returns a value indicating whether one is less than, equal to, or greater than the other.
        /// </summary>
        /// <param name="x">The first object to compare.</param>
        /// <param name="y">The second object to compare.</param>
        /// <returns>
        /// A signed integer that indicates the relative values of <paramref name="x"/> and <paramref name="y"/>, as shown in the following table.Value Meaning Less than zero <paramref name="x"/> is less than <paramref name="y"/>. Zero <paramref name="x"/> equals <paramref name="y"/>. Greater than zero <paramref name="x"/> is greater than <paramref name="y"/>.
        /// </returns>
        /// <exception cref="T:System.ArgumentException">Neither <paramref name="x"/> nor <paramref name="y"/> implements the <see cref="T:System.IComparable"/> interface.-or- <paramref name="x"/> and <paramref name="y"/> are of different types and neither one can handle comparisons with the other. </exception>
        public int Compare(object x, object y)
        {
            return this.Compare(x as FilemanFieldValue, y as FilemanFieldValue);
        }
    }
}
