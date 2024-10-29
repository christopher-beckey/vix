using GalaSoft.MvvmLight;
using GalaSoft.MvvmLight.Command;

namespace VISAHealthMonitorCommonControls.ViewModel
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
    public class InputDialogViewModel : ViewModelBase
    {
        public string Input { get; set; }
        public RelayCommand OKCommand { get; set; }
        public bool? DialogResult { get; set; }
        public RelayCommand WindowLoadedCommand { get; set; }

        /// <summary>
        /// Initializes a new instance of the InputDialogViewModel class.
        /// </summary>
        public InputDialogViewModel()
        {
            this.DialogResult = null;
            if (IsInDesignMode)
            {
                Input = "Test Input";
            }
            OKCommand = new RelayCommand(() => OK());
            WindowLoadedCommand = new RelayCommand(() => WindowLoaded());
            ////if (IsInDesignMode)
            ////{
            ////    // Code runs in Blend --> create design time data.
            ////}
            ////else
            ////{
            ////    // Code runs "for real": Connect to service, etc...
            ////}
        }

        public void OK()
        {
            this.DialogResult = true;
            RaisePropertyChanged("DialogResult");
        }

        private void WindowLoaded()
        {
            // necessary to reset this value each time the Window is loaded so that the value will change when Save or Close is clicked. The ViewModel is static so it persists after
            // the form is closed so the previous DialogResult value persists as well - it needs to be changed here so it can change later
            this.DialogResult = null;
        }

        ////public override void Cleanup()
        ////{
        ////    // Clean own resources if needed

        ////    base.Cleanup();
        ////}
    }
}