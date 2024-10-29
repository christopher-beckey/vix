//-----------------------------------------------------------------------
// <copyright file="TimePeriod.cs" company="Department of Veterans Affairs">
//     Copyright (c) vhaiswgraver, Department of Veterans Affairs. All rights reserved.
// </copyright>
//-----------------------------------------------------------------------
namespace ImagingClient.Infrastructure
{
    using System;
    using System.Collections.Generic;
    using System.Diagnostics.Contracts;
    using System.Linq;

    /// <summary>
    /// Represents a period of time between two DataTimes
    /// </summary>
    [Serializable]
    public class TimePeriod
    {
        #region Constructor(s)

        /// <summary>
        /// Initializes a new instance of the <see cref="TimePeriod"/> class.
        /// </summary>
        /// <param name="startDateTime">The start date time.</param>
        /// <param name="endDateTime">The end date time.</param>
        public TimePeriod(DateTime startDateTime, DateTime endDateTime)
        {
            Contract.Requires<ArgumentException>(startDateTime <= endDateTime);
            Contract.Ensures(this.StartDateTime == startDateTime);
            Contract.Ensures(this.EndDateTime == endDateTime);
            this.StartDateTime = startDateTime;
            this.EndDateTime = endDateTime;
        }

        #endregion

        #region Properties
        /// <summary>
        /// Gets the start date time.
        /// </summary>
        /// <value>
        /// The start date time.
        /// </value>
        public DateTime StartDateTime { get; private set; }

        /// <summary>
        /// Gets the end date time.
        /// </summary>
        /// <value>
        /// The end date time.
        /// </value>
        public DateTime EndDateTime { get; private set; }

        /// <summary>
        /// Gets the duration.
        /// </summary>
        public TimeSpan Duration
        {
            get
            {
                return this.EndDateTime - this.StartDateTime;
            }
        }
        #endregion

        #region Methods

        /// <summary>
        /// Determines whether the specified date is within the time period.
        /// </summary>
        /// <param name="date">The date to compare.</param>
        /// <returns>
        ///   <c>true</c> if the specified date is within the time period; otherwise, <c>false</c>.
        /// </returns>
        public bool Contains(DateTime date)
        {
            return this.StartDateTime <= date
                && this.EndDateTime >= date;
        }

        /// <summary>
        /// Determines whether this TimePeriod contains the specified TimePeriod.
        /// </summary>
        /// <param name="period">The TimePeriod to compare.</param>
        /// <returns>
        ///   <c>true</c> if this TimePeriod contains the specified period; otherwise, <c>false</c>.
        /// </returns>
        public bool Contains(TimePeriod period)
        {
            Contract.Requires<ArgumentNullException>(period != null);
            return this.Contains(period.StartDateTime)
                && this.Contains(period.EndDateTime);
        }

        /// <summary>
        /// Gets the TimePeriod of the intersection of this TimePeriod and the specified TimePeriod.
        /// </summary>
        /// <param name="period">The period.</param>
        /// <returns>The TimePeriod of the intersection of this TimePeriod and the specified TimePeriod</returns>
        public TimePeriod GetIntersection(TimePeriod period)
        {
            Contract.Requires<ArgumentNullException>(period != null);
            if (!this.Intersects(period))
            {
                return null;
            }

            DateTime intStartDateTime = this.StartDateTime > period.StartDateTime ? this.StartDateTime : period.StartDateTime;
            DateTime intEndDateTime = this.EndDateTime < period.EndDateTime ? this.EndDateTime : period.EndDateTime;
            return new TimePeriod(intStartDateTime, intEndDateTime);
        }

        /// <summary>
        /// Determines if this TimePeriod intersectses the specified TimePeriod.
        /// </summary>
        /// <param name="period">The TimePeriod to compare</param>
        /// <returns><c>true</c> if the this TimePeriod intersects with the specified TimePeriod; otherwide <c>false</c>.</returns>
        public bool Intersects(TimePeriod period)
        {
            Contract.Requires<ArgumentNullException>(period != null);
            return this.Contains(period.StartDateTime)
                || this.Contains(period.EndDateTime)
                || period.Contains(this.StartDateTime)
                || period.Contains(this.EndDateTime);
        }

        /// <summary>
        /// Determines if the specified date is after the end date of the time period
        /// </summary>
        /// <param name="date">The date to compare</param>
        /// <returns><c>true</c> if the specified date is after the time period; otherwise, <c>false</c>.</returns>
        public bool IsAfter(DateTime date)
        {
            return this.StartDateTime > date;
        }

        /// <summary>
        /// Determines if the specified TimePeriod starts after the end date of this time period
        /// </summary>
        /// <param name="period">The TimePeriod to compare.</param>
        /// <returns><c>true</c> if the specified TimePeriod is after this time period; otherwise, <c>false</c>.</returns>
        public bool IsAfter(TimePeriod period)
        {
            Contract.Requires<ArgumentNullException>(period != null);
            return this.StartDateTime > period.EndDateTime;
        }

        /// <summary>
        /// Determines if the specified date is before the start date of the time period
        /// </summary>
        /// <param name="date">The date to compare.</param>
        /// <returns>True if the specified date is before the time period; otherwise, <c>false</c>.</returns>
        public bool IsBefore(DateTime date)
        {
            return this.EndDateTime < date;
        }

        /// <summary>
        /// Determines if the specified TimePeriod ends before the start date of this time period
        /// </summary>
        /// <param name="period">The TimePeriod to compare.</param>
        /// <returns><c>true</c> if the specified TimePeriod is before this time period; otherwise, <c>false</c>.</returns>
        public bool IsBefore(TimePeriod period)
        {
            Contract.Requires<ArgumentNullException>(period != null);
            return this.EndDateTime < period.StartDateTime;
        }

        /// <summary>
        /// Determines whether the specified <see cref="System.Object"/> is equal to this instance.
        /// </summary>
        /// <param name="o">The <see cref="System.Object"/> to compare with this instance.</param>
        /// <returns>
        ///   <c>true</c> if the specified <see cref="System.Object"/> is equal to this instance; otherwise, <c>false</c>.
        /// </returns>
        public override bool Equals(object o)
        {
            TimePeriod target = o as TimePeriod;
            if (target == null)
            {
                return false;
            }

            return this.StartDateTime.Equals(target.StartDateTime)
                && this.EndDateTime.Equals(target.EndDateTime);
        }

        /// <summary>
        /// Returns a hash code for this instance.
        /// </summary>
        /// <returns>
        /// A hash code for this instance, suitable for use in hashing algorithms and data structures like a hash table. 
        /// </returns>
        public override int GetHashCode()
        {
            return this.StartDateTime.GetHashCode()
                ^ this.EndDateTime.GetHashCode();
        }

        /// <summary>
        /// Returns a <see cref="System.String"/> that represents this instance.
        /// </summary>
        /// <returns>
        /// A <see cref="System.String"/> that represents this instance.
        /// </returns>
        public override string ToString()
        {
            return this.StartDateTime.ToString()
                + " - " + this.EndDateTime.ToString();
        }

        #endregion
    }
}
