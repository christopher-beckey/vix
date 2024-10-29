using GalaSoft.MvvmLight;
using GalaSoft.MvvmLight.Messaging;
using GalaSoft.MvvmLight.Command;
using VISAHealthMonitorCommon.messages;
using System;

namespace VISAHealthMonitorCommon
{
    /// <summary>
    /// This class contains properties that a View can data bind to.
    /// <para>
    /// Use the <strong>mvvminpc</strong> snippet to add bindable properties to this ViewModel.
    /// </para>
    /// <para>
    /// You can also use Blend to data bind with the tool's support.
    /// </para>
    /// <para>
    /// See http://www.galasoft.ch/mvvm/getstarted
    /// </para>
    /// </summary>
    public abstract class VISADetailsViewModel : ViewModelBase
    {
        public string DateHealthLastUpdated { get; set; }
        public string VISAVersion { get; set; }
        public string Hostname { get; set; }
        public string StartTime { get; set; }
        public string UpTime { get; set; }

        public RelayCommand RefreshHealthCommand { get; set; }


        public static string numberFormat = "###,###,###,##0";
        public static string decimalFormat = "###,###,###,###.00";

        /// <summary>
        /// Initializes a new instance of the VISADetailsViewModel class.
        /// </summary>
        public VISADetailsViewModel()
        {
            RefreshHealthCommand = new RelayCommand(() => RefreshHealth());
            if (IsInDesignMode)
            {
                // Code runs in Blend --> create design time data.
            }
            else
            {
                //Messenger.Default.Register<DisplayVisaHealthMessage>(this, action => ReceiveDisplayVisaHealthMessage(action));
                //Code runs "for real": Connect to service, etc...
            }
        }

        /// <summary>
        /// Update the health of the referenced site (get new data and display it)
        /// </summary>
        protected abstract void UpdateVisaHealth();

        ////public override void Cleanup()
        ////{
        ////    // Clean own resources if needed

        ////    base.Cleanup();
        ////}

        private void RefreshHealth()
        {
            UpdateVisaHealth();
        }

        protected TimeSpan ticksToTimespan(long ticks)
        {
            int sec = (int)(ticks / 1000.0f);
            int ms = (int)(ticks % 1000);
            return new TimeSpan(0, 0, 0, sec, ms);
        }

        protected static string formatBytes(long bytes)
        {
            if (bytes < 1024)
            {
                return bytes + " bytes";
            }
            double kb = (double)bytes / 1024.0f;
            double mb = kb / 1024.0f;
            double gb = mb / 1024.0f;
            double tb = gb / 1024.0f;

            if (tb > 1.0)
            {
                return tb.ToString("N2") + " TB";
            }
            else if (gb > 1.0)
            {
                return gb.ToString("N2") + " GB";
            }
            else if (mb > 1.0)
            {
                return mb.ToString("N2") + " MB";
            }
            else
            {
                return kb.ToString("N2") + " KB";
            }
        }

        protected void ClearProperties()
        {
            DateHealthLastUpdated ="";
            VISAVersion ="";
            Hostname ="";
            StartTime ="";
            UpTime = "";
        }
    }
}