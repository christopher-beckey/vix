using System;
using System.Collections.Generic;
using System.ComponentModel;
using System.Globalization;
using System.Linq;
using System.Text;
using System.Threading.Tasks;
using System.Windows;
using System.Windows.Controls;
using System.Windows.Data;
using System.Windows.Documents;
using System.Windows.Input;
using System.Windows.Media;
using System.Windows.Media.Imaging;
using System.Windows.Navigation;
using System.Windows.Shapes;
using ImagingClient.Infrastructure.ViewModels;

namespace ImagingClient.Infrastructure.Views
{
    /// <summary>
    /// Interaction logic for DateRangeUserControl.xaml
    /// </summary>
    public partial class DateRangeUserControl : UserControl, INotifyPropertyChanged
    {
        //DateRangeViewModel vm = new DateRangeViewModel();
        private DateTime _FromDate = DateTime.Today;
        private DateTime _ToDate = DateTime.Today;
        private string _FromDateEnabled = "False";
        private string _ToDateEnabled = "False";
        //private string _SelectedDateDropDown = "d0";
        public DateRangeUserControl()
        {
            InitializeComponent();
            //this.DataContext = vm;
            //viewModel.UIDispatcher = this.Dispatcher;
        }

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

        #region DependencyProps
        public static readonly DependencyProperty SelectedDateDropDownProperty =
               DependencyProperty.Register(
                     "SelectedDateDropDown",
                      typeof(string),
                      typeof(DateRangeUserControl),
                      new PropertyMetadata("", new PropertyChangedCallback(OnSelectedDateDropDown)));

        public static readonly DependencyProperty FromDateProperty =
               DependencyProperty.Register(
                     "FromDate",
                      typeof(string),
                      typeof(DateRangeUserControl),
                      new PropertyMetadata("", new PropertyChangedCallback(OnFromDateChanged)));

        public static readonly DependencyProperty ToDateProperty =
               DependencyProperty.Register(
                     "ToDate",
                      typeof(string),
                      typeof(DateRangeUserControl),
                      new PropertyMetadata("", new PropertyChangedCallback(OnToDateChanged)));

        public string SelectedDateDropDown
        {
            get
            {
                return (string)GetValue(SelectedDateDropDownProperty);
            }
            set
            {
                SetValue(SelectedDateDropDownProperty, value);
                setDateRange(value);
            }
        }

        public string FromDate
        {
            get
            {
                return (string)GetValue(FromDateProperty);
            }
            set
            {
                SetValue(FromDateProperty, value);
            }
        }

        public string ToDate
        {
            get
            {
                return (string)GetValue(ToDateProperty);
            }
            set
            {
                SetValue(ToDateProperty, value);
            }
        }

        #endregion

        #region Public Properties

        //public DateTime FromDate
        //{
        //    get { return _FromDate; }
        //    set
        //    {
        //        _FromDate = value;
        //        this.RaisePropertyChanged("FromDate");
        //    }
        //}

        //public string FromDateEnabled
        //{
        //    get { return _FromDateEnabled; }
        //    set
        //    {
        //        _FromDateEnabled = value;
        //        this.RaisePropertyChanged("FromDateEnabled");
        //    }
        //}

        //public DateTime ToDate
        //{
        //    get { return _ToDate; }
        //    set
        //    {
        //        _ToDate = value;
        //        this.RaisePropertyChanged("ToDate");
        //    }
        //}

        //public string ToDateEnabled
        //{
        //    get { return _ToDateEnabled; }
        //    set
        //    {
        //        _ToDateEnabled = value;
        //        this.RaisePropertyChanged("ToDateEnabled");
        //    }
        //}

        #endregion

        private static void OnSelectedDateDropDown(DependencyObject d,
            DependencyPropertyChangedEventArgs e)
        {
            DateRangeUserControl uc = d as DateRangeUserControl;
            uc.SetSelectedDateDropDown(e);
        }

        private static void OnFromDateChanged(DependencyObject d, DependencyPropertyChangedEventArgs e)
        {
            DateRangeUserControl uc = d as DateRangeUserControl;
            uc.SetFromDate(e);
        }

        private static void OnToDateChanged(DependencyObject d, DependencyPropertyChangedEventArgs e)
        {
            DateRangeUserControl uc = d as DateRangeUserControl;
            uc.SetToDate(e);
        }

        private void SetSelectedDateDropDown(DependencyPropertyChangedEventArgs e)
        {
            setDateRange(e.NewValue.ToString());
        }

        private void SetFromDate(DependencyPropertyChangedEventArgs e)
        {
            dpFromDate.SelectedDate = DateTime.Parse(e.NewValue.ToString());
        }

        private void SetToDate(DependencyPropertyChangedEventArgs e)
        {
            dpToDate.SelectedDate = DateTime.Parse(e.NewValue.ToString());
        }

        private void setDateRange(string value)
        {
            DateTime toDay = DateTime.Today;
            DateTime thisWeekBegin = DateTime.Today.AddDays(-(int)toDay.DayOfWeek);

            dpFromDate.IsEnabled = false;
            dpToDate.IsEnabled = false;

            switch (value)
            {
                case "d0":
                    d0.IsSelected = true;
                    dpFromDate.IsEnabled = true;
                    dpToDate.IsEnabled = true;
                    break;
                case "d1":
                    d1.IsSelected = true;
                    dpFromDate.SelectedDate = toDay;
                    dpToDate.SelectedDate = toDay;
                    break;
                case "d2":
                    //Yesterday
                    d2.IsSelected = true;
                    dpFromDate.SelectedDate = toDay.AddDays(-1);
                    dpToDate.SelectedDate = toDay.AddDays(-1);
                    break;
                case "d3":
                    //2 days ago
                    d3.IsSelected = true;
                    dpFromDate.SelectedDate = toDay.AddDays(-2);
                    dpToDate.SelectedDate = toDay.AddDays(-2);
                    break;
                case "d4":
                    //3 days ago
                    d4.IsSelected = true;
                    dpFromDate.SelectedDate = toDay.AddDays(-3);
                    dpToDate.SelectedDate = toDay.AddDays(-3);
                    break;
                case "d5":
                    //last 2 days
                    d5.IsSelected = true;
                    dpFromDate.SelectedDate = toDay.AddDays(-1);
                    dpToDate.SelectedDate = toDay;
                    break;
                case "d6":
                    //last 3 days
                    d6.IsSelected = true;
                    dpFromDate.SelectedDate = toDay.AddDays(-2);
                    dpToDate.SelectedDate = toDay;
                    break;
                case "d7":
                    //last full week
                    d7.IsSelected = true;
                    dpFromDate.SelectedDate = thisWeekBegin.AddDays(-7);
                    dpToDate.SelectedDate = thisWeekBegin.AddSeconds(-1);
                    break;
                case "d8":
                    //current week
                    d8.IsSelected = true;
                    dpFromDate.SelectedDate = thisWeekBegin;
                    dpToDate.SelectedDate = thisWeekBegin.AddDays(7).AddSeconds(-1);
                    break;
                default:
                    break;
            }

            //FromDate = dpFromDate.SelectedDate.ToString();
            //ToDate = dpToDate.SelectedDate.ToString();
            //this.RaisePropertyChanged("FromDate");
            //this.RaisePropertyChanged("ToDate");
            //this.RaisePropertyChanged("FromDateEnabled");
            //this.RaisePropertyChanged("ToDateEnabled");
            //this.RaisePropertyChanged("SelectedDateDropDown");
        }

        private void ComboBox_SelectionChanged(object sender, SelectionChangedEventArgs e)
        {
            if (!SelectedDateDropDown.Equals(cbDateType.SelectedValue.ToString()))
            {
                SelectedDateDropDown = cbDateType.SelectedValue.ToString();
                setDateRange(cbDateType.SelectedValue.ToString());
            }
        }

        private void dpToDate_SelectedDateChanged(object sender, SelectionChangedEventArgs e)
        {
            if (!ToDate.Equals(dpToDate.SelectedDate.ToString()))
            {
                ToDate = dpToDate.SelectedDate.ToString();
            }
        }

        private void dpFromDate_SelectedDateChanged(object sender, SelectionChangedEventArgs e)
        {
            if (!FromDate.Equals(dpFromDate.SelectedDate.ToString()))
            {
                FromDate = dpFromDate.SelectedDate.ToString();
            }
        }
    }
}