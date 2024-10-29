using System;
using System.Collections.Generic;
using System.IO;
using System.Linq;
using System.Reflection;
using System.Text;
using System.Threading.Tasks;
using System.Windows.Input;

namespace Vix.Viewer.Install
{
    public class ConfigManager
    {
        private static readonly Lazy<ConfigManager> _Instance = new Lazy<ConfigManager>(() => new ConfigManager());

        private object _SyncLock = new object();

        public static ConfigManager Instance
        {
            get
            {
                return ConfigManager._Instance.Value;
            }
        }

        private bool _CanEditConfiguration;
        private bool _CanResetSecurityConfiguration;

        private bool _CanInstallViewerService;
        private bool _CanUninstallViewerService;
        private bool _CanStartViewerService;
        private bool _CanStopViewerService;
        private bool _CanInstallRenderService;
        private bool _CanUninstallRenderService;
        private bool _CanStartRenderService;
        private bool _CanStopRenderService;

        private bool _CanInstallServices;
        private bool _CanUninstallServices;
        private bool _CanStartServices;
        private bool _CanStopServices;

        private const string VIEWERSERVICENAME = "VIX Viewer Service";
        private const string RENDERSERVICENAME = "VIX Render Service";
        private const string VIEWERCONFIGFILENAME = "VIX.Viewer.config";
        private const string RENDERCONFIGFILENAME = "VIX.Render.config";
        private const string VIEWEREXEFILENAME = "VIX.Viewer.Service.exe";
        private const string RENDEREXEFILENAME = "VIX.Render.Service.exe";
        private const string VIEWERSERVICEFOLDER = "VIX.Viewer.Service";
        private const string RENDERSERVICEFOLDER = "VIX.Render.Service";
        private const string CONFIGFOLDER = "VIX.Config";

        private string _ViewerConfigFilePath;
        private string _RenderConfigFilePath;
        private string _ViewerServiceFilePath;
        private string _RenderServiceFilePath;

        public ConfigManager()
        {
            ViewerProperties = new ViewerProperties();

            // create commands
            ViewerInstallServiceCommand = new RelayCommand(p => OnViewerInstallServiceCommand(), p => _CanInstallViewerService);
            ViewerUninstallServiceCommand = new RelayCommand(p => OnViewerUninstallServiceCommand(), p => _CanUninstallViewerService);
            ViewerStartServiceCommand = new RelayCommand(p => OnViewerStartServiceCommand(), p => _CanStartViewerService);
            ViewerStopServiceCommand = new RelayCommand(p => OnViewerStopServiceCommand(), p => _CanStopViewerService);

            RenderInstallServiceCommand = new RelayCommand(p => OnRenderInstallServiceCommand(), p => _CanInstallRenderService);
            RenderUninstallServiceCommand = new RelayCommand(p => OnRenderUninstallServiceCommand(), p => _CanUninstallRenderService);
            RenderStartServiceCommand = new RelayCommand(p => OnRenderStartServiceCommand(), p => _CanStartRenderService);
            RenderStopServiceCommand = new RelayCommand(p => OnRenderStopServiceCommand(), p => _CanStopRenderService);

            EditConfigurationCommand = new RelayCommand(p => OnEditConfigurationCommand(), p => _CanEditConfiguration);
            SaveConfigurationCommand = new RelayCommand(p => OnSaveConfigurationCommand(), p => _CanEditConfiguration && IsDirty);
            ResetSecurityConfigurationCommand = new RelayCommand(p => OnResetSecurityConfigurationCommand(), p => _CanEditConfiguration && (ViewerProperties.ResetViewerSettings || ViewerProperties.ResetRenderSettings));
            InstallServicesCommand = new RelayCommand(p => OnInstallServicesCommand(), p => _CanInstallServices);
            UninstallServicesCommand = new RelayCommand(p => OnUninstallServicesCommand(), p => _CanUninstallServices);
            StartServicesCommand = new RelayCommand(p => OnStartServicesCommand(), p => _CanStartServices);
            StopServicesCommand = new RelayCommand(p => OnStopServicesCommand(), p => _CanStopServices);

            CheckInstallState();
        }

        private void OnResetSecurityConfigurationCommand()
        {
            DisplayMessage("Resetting Security Configuration...");
            ViewerProperties.ResetSecurityConfiguration();
            DisplayMessage("Resetting Security ...Completed");

            PostInstall(); 

            UpdateCommands();
        }

        private void OnViewerInstallServiceCommand()
        {
            DisplayMessage("Installing {0}...", VIEWERSERVICENAME);
            ServiceUtil.InstallService(_ViewerServiceFilePath);
            DisplayMessage("Installing {0}...Completed", VIEWERSERVICENAME);

            UpdateCommands();
        }

        private void OnViewerUninstallServiceCommand()
        {
            DisplayMessage("Uninstalling {0}...", VIEWERSERVICENAME);
            ServiceUtil.UninstallService(VIEWERSERVICENAME);
            DisplayMessage("Uninstalling {0}...Completed", VIEWERSERVICENAME);

            UpdateCommands();
        }

        private void OnViewerStopServiceCommand()
        {
            DisplayMessage("Stopping {0}...", VIEWERSERVICENAME);
            ServiceUtil.StopService(VIEWERSERVICENAME);
            DisplayMessage("Stopping {0}...Completed", VIEWERSERVICENAME);

            UpdateCommands();
        }

        private void OnViewerStartServiceCommand()
        {
            DisplayMessage("Starting {0}...", VIEWERSERVICENAME);
            ServiceUtil.StartService(VIEWERSERVICENAME);
            DisplayMessage("Starting {0}...Completed", VIEWERSERVICENAME);

            UpdateCommands();
        }

        private void OnSaveConfigurationCommand()
        {
            DisplayMessage("Saving Configuration...");
            ViewerProperties.Save();
            DisplayMessage("Saving Configuration...Completed");

            PostInstall();

            IsDirty = false;
        }

        private void OnEditConfigurationCommand()
        {
            // do nothing
        }

        private void OnRenderInstallServiceCommand()
        {
            DisplayMessage("Installing {0}...", RENDERSERVICENAME);
            ServiceUtil.InstallService(_RenderServiceFilePath);
            DisplayMessage("Installing {0}...Completed", RENDERSERVICENAME);

            UpdateCommands();
        }

        private void OnRenderUninstallServiceCommand()
        {
            DisplayMessage("Uninstalling {0}...", RENDERSERVICENAME);
            ServiceUtil.UninstallService(RENDERSERVICENAME);
            DisplayMessage("Uninstalling {0}...Completed", RENDERSERVICENAME);

            UpdateCommands();
        }

        private void OnRenderStopServiceCommand()
        {
            DisplayMessage("Stopping {0}...", RENDERSERVICENAME);
            ServiceUtil.StopService(RENDERSERVICENAME);
            DisplayMessage("Stopping {0}...Completed", RENDERSERVICENAME);

            UpdateCommands();
        }

        private void OnRenderStartServiceCommand()
        {
            DisplayMessage("Starting {0}...", RENDERSERVICENAME);
            ServiceUtil.StartService(RENDERSERVICENAME);
            DisplayMessage("Starting {0}...Completed", RENDERSERVICENAME);

            UpdateCommands();
        }

        private void OnInstallServicesCommand()
        {
            DisplayMessage("Installing {0}...", VIEWERSERVICENAME);
            ServiceUtil.InstallService(_ViewerServiceFilePath);
            DisplayMessage("Installing {0}...Completed", VIEWERSERVICENAME);

            DisplayMessage("Installing {0}...", RENDERSERVICENAME);
            ServiceUtil.InstallService(_RenderServiceFilePath);
            DisplayMessage("Installing {0}...Completed", RENDERSERVICENAME);
            
            UpdateCommands();
        }

        private void OnUninstallServicesCommand()
        {
            DisplayMessage("Uninstalling {0}...", VIEWERSERVICENAME);
            ServiceUtil.UninstallService(VIEWERSERVICENAME);
            DisplayMessage("Uninstalling {0}...Completed", VIEWERSERVICENAME);

            DisplayMessage("Uninstalling {0}...", RENDERSERVICENAME);
            ServiceUtil.UninstallService(RENDERSERVICENAME);
            DisplayMessage("Uninstalling {0}...Completed", RENDERSERVICENAME);

            UpdateCommands();
        }

        private void OnStopServicesCommand()
        {
            DisplayMessage("Stopping {0}...", VIEWERSERVICENAME);
            ServiceUtil.StopService(VIEWERSERVICENAME);
            DisplayMessage("Stopping {0}...Completed", VIEWERSERVICENAME);

            DisplayMessage("Stopping {0}...", RENDERSERVICENAME);
            ServiceUtil.StopService(RENDERSERVICENAME);
            DisplayMessage("Stopping {0}...Completed", RENDERSERVICENAME);

            UpdateCommands();
        }

        private void OnStartServicesCommand()
        {
            DisplayMessage("Starting {0}...", RENDERSERVICENAME);
            ServiceUtil.StartService(RENDERSERVICENAME);
            DisplayMessage("Starting {0}...Completed", RENDERSERVICENAME);

            DisplayMessage("Starting {0}...", VIEWERSERVICENAME);
            ServiceUtil.StartService(VIEWERSERVICENAME);
            DisplayMessage("Starting {0}...Completed", VIEWERSERVICENAME);
            
            UpdateCommands();
        }
        
        public event EventHandler<object> PropertyChanged;

        public event EventHandler<string> MessageEventHandler;

        public string VixVersion
        {
            get
            {
                return ViewerProperties.VixServiceProperties.VixVersion;
            }

            set
            {
                ViewerProperties.VixServiceProperties.VixVersion = value;
            }
        }

        private string _InstallPath;
        public string InstallPath
        {
            get
            {
                return _InstallPath;
            }

            set
            {
                if (string.IsNullOrEmpty(value))
                    throw new ArgumentException("Install path is invalid");
                if (!Directory.Exists(value))
                    throw new ArgumentException("Install path does not exist");

                _InstallPath = value;

                if (Path.GetFileName(_InstallPath) == "VIX.Config")
                    throw new ArgumentException("You selected the path itself. Please select the PARENT path.");

                // get paths
                _ViewerConfigFilePath = Path.Combine(_InstallPath, CONFIGFOLDER, VIEWERCONFIGFILENAME);
                if (!File.Exists(_ViewerConfigFilePath))
                    throw new ArgumentException("Viewer service config file not found");

                _RenderConfigFilePath = Path.Combine(_InstallPath, CONFIGFOLDER, RENDERCONFIGFILENAME);
                if (!File.Exists(_RenderConfigFilePath))
                    throw new ArgumentException("Render service config file not found");

                _ViewerServiceFilePath = Path.Combine(_InstallPath, VIEWERSERVICEFOLDER, VIEWEREXEFILENAME);
                if (!File.Exists(_ViewerServiceFilePath))
                    throw new ArgumentException("Viewer service not found");

                _RenderServiceFilePath = Path.Combine(_InstallPath, RENDERSERVICEFOLDER, RENDEREXEFILENAME);
                if (!File.Exists(_RenderServiceFilePath))
                    throw new ArgumentException("Render service not found");

                DisplayMessage("Reading config files. {0}, {1}", _ViewerConfigFilePath, _RenderConfigFilePath);
                ViewerProperties.Load(_ViewerConfigFilePath, _RenderConfigFilePath);
                DisplayMessage("Reading config files...Completed");

                if (PropertyChanged != null)
                    PropertyChanged(this, ViewerProperties);

                UpdateCommands();
            }
        }

        private bool _IsDirty = false;
        internal bool IsDirty 
        {
            get
            {
                return _IsDirty;
            }

            set
            {
                _IsDirty = value;
                CommandManager.InvalidateRequerySuggested();
            }
        } 

        private void UpdateCommands()
        {
            DisplayMessage("Checking service state for {0}...", VIEWERSERVICENAME);

            var serviceState = ServiceUtil.GetServiceState(VIEWERSERVICENAME);

            _CanInstallViewerService = (!string.IsNullOrEmpty(_ViewerServiceFilePath)) &&
                                                    (serviceState != ServiceState.Intermediate) &&
                                                    (serviceState == ServiceState.NotInstalled);
            _CanStopViewerService = (serviceState != ServiceState.Intermediate) && (serviceState == ServiceState.Running);
            _CanStartViewerService = (serviceState != ServiceState.Intermediate) && (serviceState == ServiceState.Stopped);
            _CanUninstallViewerService = (serviceState != ServiceState.NotInstalled) && (serviceState == ServiceState.Stopped);

            DisplayMessage("Checking service state for {0}...Completed", VIEWERSERVICENAME);

            DisplayMessage("Checking service state for {0}...", RENDERSERVICENAME);

            serviceState = ServiceUtil.GetServiceState(RENDERSERVICENAME);

            _CanInstallRenderService = (!string.IsNullOrEmpty(_RenderServiceFilePath)) &&
                                                        (serviceState != ServiceState.Intermediate) &&
                                                        (serviceState == ServiceState.NotInstalled);
            _CanStopRenderService = (serviceState != ServiceState.Intermediate) && (serviceState == ServiceState.Running);
            _CanStartRenderService = (serviceState != ServiceState.Intermediate) && (serviceState == ServiceState.Stopped);
            _CanUninstallRenderService = (serviceState != ServiceState.NotInstalled) && (serviceState == ServiceState.Stopped);

            DisplayMessage("Checking service state for {0}...Completed", RENDERSERVICENAME);

            _CanEditConfiguration = File.Exists(ViewerProperties.ViewerConfigFileName) &&
                                    File.Exists(ViewerProperties.RenderConfigFileName);

            _CanResetSecurityConfiguration = _CanEditConfiguration && (ViewerProperties.ResetViewerSettings || ViewerProperties.ResetRenderSettings);

            _CanStopServices = (_CanStopRenderService || _CanStopViewerService);
            _CanStartServices = (_CanStartRenderService || _CanStartViewerService);
            _CanInstallServices = (_CanInstallRenderService || _CanInstallViewerService);
            _CanUninstallServices = (_CanUninstallRenderService || _CanUninstallViewerService);

            CommandManager.InvalidateRequerySuggested();
        }

        private void CheckInstallState()
        {       
            string programFolder = @"C:\Program Files\VistA\Imaging";
           
            if (Directory.Exists(Path.Combine(programFolder, CONFIGFOLDER)) &&
                Directory.Exists(Path.Combine(programFolder, VIEWERSERVICEFOLDER)) &&
                Directory.Exists(Path.Combine(programFolder, RENDERSERVICEFOLDER)))
            {
                try
                {
                    InstallPath = programFolder;
                }
                catch  (Exception)
                {
                }
            }
        }

        private void DisplayMessage(string format, params object[] args)
        {
            if (MessageEventHandler != null)
                MessageEventHandler(this, string.Format(format, args));
        }
       
        private void PostInstall()
        {
            //NOTE: This code is no longer needed, but is here, commented out, in case it is needed again.
            //if (string.IsNullOrEmpty(ViewerProperties.VixServiceProperties.VixVersion))
            //    return;
            //
            //// copy help file
            //string helpFile = Path.Combine(_InstallPath, "Patches", ViewerProperties.VixServiceProperties.VixVersion, "help.pdf");
            //if (File.Exists(helpFile))
            //{
            //    string serviceFolder = Path.Combine(_InstallPath, VIEWERSERVICEFOLDER);
            //    if (Directory.Exists(serviceFolder))
            //    {
            //        DisplayMessage("Copying help file...");
            //        File.Copy(helpFile, Path.Combine(serviceFolder, "help.pdf"), true);
            //        DisplayMessage("Saving Configuration...Completed");
            //    }
            //}
        }
        
        public ViewerProperties ViewerProperties { get; private set; }

        public ICommand ViewerInstallServiceCommand { get; private set; }
        public ICommand ViewerUninstallServiceCommand { get; private set; }
        public ICommand ViewerStartServiceCommand { get; private set; }
        public ICommand ViewerStopServiceCommand { get; private set; }

        public ICommand RenderInstallServiceCommand { get; private set; }
        public ICommand RenderUninstallServiceCommand { get; private set; }
        public ICommand RenderStartServiceCommand { get; private set; }
        public ICommand RenderStopServiceCommand { get; private set; }


        public ICommand EditConfigurationCommand { get; private set; }
        public ICommand SaveConfigurationCommand { get; private set; }
        public ICommand InstallServicesCommand { get; private set; }
        public ICommand UninstallServicesCommand { get; private set; }
        public ICommand StartServicesCommand { get; private set; }
        public ICommand StopServicesCommand { get; private set; }
        public ICommand ResetSecurityConfigurationCommand { get; private set; }
    }
}
