/*
  In App.xaml:
  <Application.Resources>
      <vm:ViewModelLocatorTemplate xmlns:vm="clr-namespace:VISAHealthMonitor.ViewModel"
                                   x:Key="Locator" />
  </Application.Resources>
  
  In the View:
  DataContext="{Binding Source={StaticResource Locator}, Path=ViewModelName}"
  
  OR (WPF only):
  
  xmlns:vm="clr-namespace:VISAHealthMonitor.ViewModel"
  DataContext="{Binding Source={x:Static vm:ViewModelLocatorTemplate.ViewModelNameStatic}}"
*/

namespace VISAHealthMonitorCommonControls.ViewModel
{
    /// <summary>
    /// This class contains static references to all the view models in the
    /// application and provides an entry point for the bindings.
    /// <para>
    /// Use the <strong>mvvmlocatorproperty</strong> snippet to add ViewModels
    /// to this locator.
    /// </para>
    /// <para>
    /// In Silverlight and WPF, place the ViewModelLocatorTemplate in the App.xaml resources:
    /// </para>
    /// <code>
    /// &lt;Application.Resources&gt;
    ///     &lt;vm:ViewModelLocatorTemplate xmlns:vm="clr-namespace:VISAHealthMonitor.ViewModel"
    ///                                  x:Key="Locator" /&gt;
    /// &lt;/Application.Resources&gt;
    /// </code>
    /// <para>
    /// Then use:
    /// </para>
    /// <code>
    /// DataContext="{Binding Source={StaticResource Locator}, Path=ViewModelName}"
    /// </code>
    /// <para>
    /// You can also use Blend to do all this with the tool's support.
    /// </para>
    /// <para>
    /// See http://www.galasoft.ch/mvvm/getstarted
    /// </para>
    /// <para>
    /// In <strong>*WPF only*</strong> (and if databinding in Blend is not relevant), you can delete
    /// the Main property and bind to the ViewModelNameStatic property instead:
    /// </para>
    /// <code>
    /// xmlns:vm="clr-namespace:VISAHealthMonitor.ViewModel"
    /// DataContext="{Binding Source={x:Static vm:ViewModelLocatorTemplate.ViewModelNameStatic}}"
    /// </code>
    /// </summary>
    public class ViewModelLocator
    {  
        private static StatusMessageViewModel _statusMessage;
        private static ButtonBarViewModel _buttonBar;
        private static ThreadDetailsViewModel _threadDetails;
        private static ThreadsViewModel _threads;
        private static VixAdministratorsViewModel _vixAdministrators;        

        /// <summary>
        /// Initializes a new instance of the ViewModelLocator class.
        /// </summary>
        public ViewModelLocator()
        {
            ////if (ViewModelBase.IsInDesignModeStatic)
            ////{
            ////    // Create design time view models
            ////}
            ////else
            ////{
            ////    // Create run time view models
            ////}
        
            CreateStatusMessageViewModel();
            CreateButtonBarViewModel();
            CreateThreadDetailsViewModel();
            CreateThreadsViewModel();
            CreateVixAdministratorsViewModel();
            
        }

        public static VixAdministratorsViewModel VixAdministratorsStatic
        {
            get
            {
                if (_vixAdministrators == null)
                {
                    CreateVixAdministratorsViewModel();
                }
                return _vixAdministrators;
            }
        }

        public static ThreadsViewModel ThreadsStatic
        {
            get
            {
                if (_threads == null)
                {
                    CreateThreadsViewModel();
                }
                return _threads;
            }
        }

        public static ThreadDetailsViewModel ThreadDetailsStatic
        {
            get
            {
                if (_threadDetails == null)
                {
                    CreateThreadDetailsViewModel();
                }
                return _threadDetails;
            }
        }

        public static StatusMessageViewModel StatusMessageStatic
        {
            get
            {
                if (_statusMessage == null)
                {
                    CreateStatusMessageViewModel();
                }
                return _statusMessage;
            }
        }

        public static ButtonBarViewModel ButtonBarStatic
        {
            get
            {
                if (_buttonBar == null)
                {
                    CreateButtonBarViewModel();
                }
                return _buttonBar;
            }
        }

        [System.Diagnostics.CodeAnalysis.SuppressMessage("Microsoft.Performance",
            "CA1822:MarkMembersAsStatic",
            Justification = "This non-static member is needed for data binding purposes.")]
        public VixAdministratorsViewModel VixAdministrators
        {
            get
            {
                return VixAdministratorsStatic;
            }
        }

        [System.Diagnostics.CodeAnalysis.SuppressMessage("Microsoft.Performance",
            "CA1822:MarkMembersAsStatic",
            Justification = "This non-static member is needed for data binding purposes.")]
        public ThreadsViewModel Threads
        {
            get
            {
                return ThreadsStatic;
            }
        }

        [System.Diagnostics.CodeAnalysis.SuppressMessage("Microsoft.Performance",
            "CA1822:MarkMembersAsStatic",
            Justification = "This non-static member is needed for data binding purposes.")]
        public ThreadDetailsViewModel ThreadDetails
        {
            get
            {
                return ThreadDetailsStatic;
            }
        }

        [System.Diagnostics.CodeAnalysis.SuppressMessage("Microsoft.Performance",
            "CA1822:MarkMembersAsStatic",
            Justification = "This non-static member is needed for data binding purposes.")]
        public StatusMessageViewModel StatusMessage
        {
            get
            {
                return StatusMessageStatic;
            }
        }

        [System.Diagnostics.CodeAnalysis.SuppressMessage("Microsoft.Performance",
            "CA1822:MarkMembersAsStatic",
            Justification = "This non-static member is needed for data binding purposes.")]
        public ButtonBarViewModel ButtonBar
        {
            get
            {
                return ButtonBarStatic;
            }
        }

        public static void ClearVixAdministratorsViewModel()
        {
            _vixAdministrators.Cleanup();
            _vixAdministrators = null;
        }

        public static void ClearThreadsViewModel()
        {
            _threads.Cleanup();
            _threads = null;
        }

        public static void ClearThreadDetailsViewModel()
        {
            _threadDetails.Cleanup();
            _threadDetails = null;
        }

        public static void ClearStatusMessageViewModel()
        {
            _statusMessage.Cleanup();
            _statusMessage = null;
        }

        public static void ClearButtonBarViewModel()
        {
            _buttonBar.Cleanup();
            _buttonBar = null;
        }        

        public static void CreateVixAdministratorsViewModel()
        {
            if (_vixAdministrators == null)
            {
                _vixAdministrators = new VixAdministratorsViewModel();
            }
        }

        public static void CreateThreadsViewModel()
        {
            if (_threads == null)
            {
                _threads = new ThreadsViewModel();
            }
        }

        public static void CreateThreadDetailsViewModel()
        {
            if (_threadDetails == null)
            {
                _threadDetails = new ThreadDetailsViewModel();
            }
        }

        public static void CreateStatusMessageViewModel()
        {
            if (_statusMessage == null)
            {
                _statusMessage = new StatusMessageViewModel();
            }
        }

        public static void CreateButtonBarViewModel()
        {
            if (_buttonBar == null)
            {
                _buttonBar = new ButtonBarViewModel();
            }
        }      

        /// <summary>
        /// Cleans up all the resources.
        /// </summary>
        public static void CleanupBaseTypes()
        {       
            ClearStatusMessageViewModel();
            ClearButtonBarViewModel();
            ClearThreadDetailsViewModel();
            ClearThreadsViewModel();
            ClearVixAdministratorsViewModel();
        }
    }
}