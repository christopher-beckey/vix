using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;
using System.Windows;
using System.Windows.Controls;
using System.Windows.Data;
using System.Windows.Documents;
using System.Windows.Input;
using System.Windows.Media;
using System.Windows.Media.Imaging;
using System.Windows.Navigation;
using System.Windows.Shapes;
using VistA.Imaging.Telepathology.Worklist.ViewModel;
using VistA.Imaging.Telepathology.Common.Model;

namespace VistA.Imaging.Telepathology.Worklist.Views
{
    /// <summary>
    /// Interaction logic for SupplementaryReportView.xaml
    /// </summary>
    public partial class SupplementaryReportView : UserControl
    {
        public SupplementaryReportView()
        {
            InitializeComponent();
        }

        public SupplementaryReportView(SupplementaryReportViewModel viewModel)
        {
            InitializeComponent();
            DataContext = viewModel;

            CalendarDateRange leftBound = new CalendarDateRange(new DateTime(1,1,1), viewModel.SRDateStart.AddDays(-1));
            CalendarDateRange rightBound = new CalendarDateRange(viewModel.SRDateEnd.AddDays(1), new DateTime(9999, 12, 31));
            dtpk_SupRep.BlackoutDates.Add(leftBound);
            dtpk_SupRep.BlackoutDates.Add(rightBound);
        }

        private void lv_SupReps_SelectionChanged(object sender, SelectionChangedEventArgs e)
        {
            SupplementaryReport sr = (sender as ListView).SelectedItem as SupplementaryReport;
            if (sr != null)
            {
                DateTime selDt;
                DateTime.TryParse(sr.SRDate, out selDt);
                (DataContext as SupplementaryReportViewModel).SRSelectedDate = selDt;
                (DataContext as SupplementaryReportViewModel).SRSelectedContent = sr.Content;
                this.dtpk_SupRep.IsEnabled = false;
            }
            else
            {
                //(DataContext as SupplementaryReportViewModel).SRSelectedDate = null;
                (DataContext as SupplementaryReportViewModel).SRSelectedContent = string.Empty;
                this.dtpk_SupRep.IsEnabled = true;
            }
        }
    }
}
