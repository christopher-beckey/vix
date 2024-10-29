/**
 * 
 * Package: MAG - VistA Imaging
 * WARNING: Per VHA Directive 2004-038, this routine should not be modified.
 * Date Created: 08/11/2023
 * Developer:  Budy Tjahjo
 * Description: 
 *
 *       ;; +--------------------------------------------------------------------+
 *       ;; Property of the US Government.
 *       ;; No permission to copy or redistribute this software is given.
 *       ;; Use of unreleased versions of this software requires the user
 *       ;;  to execute a written test agreement with the VistA Imaging
 *       ;;  Development Office of the Department of Veterans Affairs,
 *       ;;  telephone (301) 734-0100.
 *       ;;
 *       ;; The Food and Drug Administration classifies this software as
 *       ;; a Class II medical device.  As such, it may not be changed
 *       ;; in any way.  Modifications to this software may result in an
 *       ;; adulterated medical device under 21CFR820, the use of which
 *       ;; is considered to be a violation of US Federal Statutes.
 *       ;; +--------------------------------------------------------------------+
 *
 */
namespace ImagingClient.Infrastructure.ViewModels
{
    using System;
    using System.ComponentModel;
    using ImagingClient.Infrastructure.Events;
    using ImagingClient.Infrastructure.Utilities;
    using Microsoft.Practices.Prism.Events;
    using Microsoft.Practices.ServiceLocation;

    /// <summary>
    /// The progress view model.
    /// </summary>
    public class DateRangeViewModel : INotifyPropertyChanged
    {
        // The PropertyChanged event is raised by NotifyPropertyWeaver (http://code.google.com/p/notifypropertyweaver/)
        #region Constants and Fields

        private DateTime _FromDate = DateTime.Today;
        private DateTime _ToDate = DateTime.Today;
        private string _FromDateEnabled = "False";
        private string _ToDateEnabled = "False";
        private string _SelectedDateDropDown = "d0";

        /// <summary>
        /// The event aggregator
        /// </summary>
        private IEventAggregator eventAggregator;

        #endregion

        #region Constructor
        public DateRangeViewModel()
        {
            //SelectedDateDropDown = "d2";
        }

        #endregion

        #region Public Events

        /// <summary>
        /// The property changed.
        /// </summary>
        public event PropertyChangedEventHandler PropertyChanged;

        /// <summary>
        /// The raise property changed.
        /// </summary>
        /// <param name="propertyName">
        /// The property name.
        /// </param>
        protected void RaisePropertyChanged(string propertyName)
        {
            PropertyChangedEventHandler handler = this.PropertyChanged;
            if (handler != null)
            {
                handler.Invoke(this, new PropertyChangedEventArgs(propertyName));
            }
        }

        #endregion

        #region Public Properties

        public DateTime FromDate
        {
            get { return _FromDate; }
            set
            {
                _FromDate = value;
                this.RaisePropertyChanged("FromDate");
            }
        }

        public string FromDateEnabled
        {
            get { return _FromDateEnabled; }
            set
            {
                _FromDateEnabled = value;
                this.RaisePropertyChanged("FromDateEnabled");
            }
        }

        public DateTime ToDate
        {
            get { return _ToDate; }
            set
            {
                _ToDate = value;
                this.RaisePropertyChanged("ToDate");
            }
        }

        public string ToDateEnabled
        {
            get { return _ToDateEnabled; }
            set
            {
                _ToDateEnabled = value;
                this.RaisePropertyChanged("ToDateEnabled");
            }
        }

        public string SelectedDateDropDown
        {
            get
            {
                return _SelectedDateDropDown;
            }
            set
            {
                _SelectedDateDropDown = value;
                this.RaisePropertyChanged("SelectedDateDropDown");

                setDateRange(value);
            }
        }
        #endregion

        private void setDateRange(string value)
        {
            DateTime toDay = DateTime.Today;
            DateTime thisWeekBegin = DateTime.Today.AddDays(-(int)toDay.DayOfWeek);
            FromDateEnabled = "False";
            ToDateEnabled = "False";

            switch (value)
            {
                case "d0":
                    FromDateEnabled = "True";
                    ToDateEnabled = "True";
                    break;
                case "d1":
                    FromDate = toDay;
                    ToDate = toDay;
                    break;
                case "d2":
                    //Yesterday
                    FromDate = toDay.AddDays(-1);
                    ToDate = toDay.AddDays(-1);
                    break;
                case "d3":
                    //2 days ago
                    FromDate = toDay.AddDays(-2);
                    ToDate = toDay.AddDays(-2);
                    break;
                case "d4":
                    //3 days ago
                    FromDate = toDay.AddDays(-3);
                    ToDate = toDay.AddDays(-3);
                    break;
                case "d5":
                    //last 2 days
                    FromDate = toDay.AddDays(-1);
                    ToDate = toDay;
                    break;
                case "d6":
                    //last 3 days
                    FromDate = toDay.AddDays(-2);
                    ToDate = toDay;
                    break;
                case "d7":
                    //last full week
                    FromDate = thisWeekBegin.AddDays(-7);
                    ToDate = thisWeekBegin.AddSeconds(-1);
                    break;
                case "d8":
                    //current week
                    FromDate = thisWeekBegin;
                    ToDate = thisWeekBegin.AddDays(7).AddSeconds(-1);
                    break;
                default:
                    break;
            }
            this.RaisePropertyChanged("FromDate");
            this.RaisePropertyChanged("ToDate");
            this.RaisePropertyChanged("FromDateEnabled");
            this.RaisePropertyChanged("ToDateEnabled");
        }

    }
    public static class DateTimeExtensions
    {
        public static DateTime StartOfWeek(this DateTime dt, DayOfWeek startOfWeek)
        {
            int diff = (7 + (dt.DayOfWeek - startOfWeek)) % 7;
            return dt.AddDays(-1 * diff).Date;
        }
    }

}