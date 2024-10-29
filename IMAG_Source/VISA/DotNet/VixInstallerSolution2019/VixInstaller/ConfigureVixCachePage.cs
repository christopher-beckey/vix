using System;
using System.Collections.Generic;
using System.ComponentModel;
using System.Data;
using System.Drawing;
using System.Text;
using System.Windows.Forms;
using System.Diagnostics;
using System.IO;
using gov.va.med.imaging.exchange.VixInstaller.business;

namespace gov.va.med.imaging.exchange.VixInstaller.ui
{
    public partial class ConfigureVixCachePage : gov.va.med.imaging.exchange.VixInstaller.ui.InteriorWizardPage
    {
        private bool enableEventHandlers = true;
        private static bool firstTime = true;
        private DriveInfoForSelect[] cacheDrives = null;
        private DriveInfoForSelect[] configDrives = null;
        private DriveInfoForSelect[] archivelogsDrives = null;
        private VixCacheConfiguration[] cacheConfigurations = null;
        private static string vixTxDbDefaultPath; 
        
        public ConfigureVixCachePage()
        {
            InitializeComponent();
        }

        public ConfigureVixCachePage(IWizardForm wizForm, int pageIndex)
            : base(wizForm, pageIndex)
        {
            InitializeComponent();
        }
        //
        #region IWizardPage Members
        public override void Initialize()
        {
            IVixConfigurationParameters config = this.WizardForm.GetVixConfigurationParameters();
            if (firstTime)
            {
                this.InitializeBusinessFacadeDelegates();
                if (config.VixRole == VixRoleType.DicomGateway)
                {
                    this.InteriorPageHeader = @"Specify the location of the HDIG cache and configuration folders.";
                    this.groupBoxConfigDir.Text = "Specify the local drive for the HDIG Configuration files";
                    this.groupBoxLocalCacheDir.Text = "Specify the local drive for the HDIG Cache";
                    this.groupBoxArchivedLogsDir.Text = "Specify the local drive for the HDIG log archive";
                }
                else
                {
                    this.InteriorPageHeader = @"Specify the location of the VIX cache, configuration, and log archive folders.";
                    this.groupBoxConfigDir.Text = "Specify the local drive for the VIX Configuration files";
                    this.groupBoxLocalCacheDir.Text = "Specify the local drive for the VIX Cache";
                    this.groupBoxArchivedLogsDir.Text = "Specify the local drive for the VIX log archive";
                }
                this.WizardForm.EnableBackButton(true);
                this.WizardForm.EnableCancelButton(true);
                this.enableEventHandlers = false;
                //this.numericUpDownCacheSize.Value = config.VixCacheSize;

                // apply control datasource bindings
                this.cacheDrives = this.GetCacheDrives(config.VixDeploymentOption);
                this.configDrives = this.GetConfigDrives(config.VixDeploymentOption); // same as cache for now
                this.archivelogsDrives = this.GetArchivedLogsDrives(config.VixDeploymentOption); 
                this.cacheConfigurations = VixFacade.Manifest.VixCacheConfigurations;
                this.comboBoxCacheDrive.DataSource = this.cacheDrives;
                this.comboBoxCacheDrive.DisplayMember = "Description";
                this.comboBoxCacheDrive.ValueMember = "Drive";
                this.comboBoxConfigDrive.DataSource = this.configDrives;
                this.comboBoxConfigDrive.DisplayMember = "Description";
                this.comboBoxConfigDrive.ValueMember = "Drive";
                this.comboBoxArchivedLogsDrive.DataSource = this.archivelogsDrives;
                this.comboBoxArchivedLogsDrive.DisplayMember = "Description";
                this.comboBoxArchivedLogsDrive.ValueMember = "Drive";
                //this.comboBoxCacheOption.DataSource = this.cacheConfigurations;
                //this.comboBoxCacheOption.DisplayMember = "ShortDescription";
                //this.comboBoxCacheOption.ValueMember = "CacheOption";

                // Cache configuration
                if (config.LocalCacheDir != null)
                {
                    this.textBoxLocalCacheDir.Text = config.LocalCacheDir.Replace("/", @"\"); // cache dir is stored with forward slash
                }
                else
                {
                    this.textBoxLocalCacheDir.Text = VixFacade.GetDefaultLocalVixCacheDrive(config.VixDeploymentOption, config.VixCacheOption, config.VixCacheSize) + VixFacade.VIX_CACHE_DIRECTORY;
                    config.LocalCacheDir = this.textBoxLocalCacheDir.Text.Replace(@"\", "/"); // cache dir is stored with forward slash
                }
                int selectedIndex = GetCacheDriveIndex(this.textBoxLocalCacheDir.Text);
                this.comboBoxCacheDrive.SelectedIndex = selectedIndex;
                this.textBoxCacheSpaceAvailable.Text = this.cacheDrives[selectedIndex].GetAvailableFreeSpaceWithCacheGB(config.VixCacheSize).ToString();

                // configuration configuration
                if (config.ConfigDir != null)
                {
                    this.textBoxLocalConfigDir.Text = config.ConfigDir.Replace("/", @"\"); // config dir is stored with forward slash
                }
                else
                {
                    this.textBoxLocalConfigDir.Text = VixFacade.GetDefaultVixConfigDrive(config.VixDeploymentOption, config.VixCacheOption, config.VixCacheSize) + VixFacade.VIX_CONFIG_DIRECTORY;
                    config.ConfigDir = this.textBoxLocalConfigDir.Text.Replace(@"\", "/"); // config dir is stored with forward slash
                }
                this.comboBoxConfigDrive.SelectedIndex = GetConfigDriveIndex(this.textBoxLocalConfigDir.Text);

                // archived logs configuration
                string archivedLogsPathName = VixFacade.NativeMethods.GetFinalPathName(GetTomcatArchivedLogsLinkPath());
                if (!String.IsNullOrEmpty(archivedLogsPathName))
                {
                    string[] archivedLogsPathSplit = archivedLogsPathName.Split('?');
                    string archivedLogsPathName2 = archivedLogsPathSplit[1].Substring(1);
                    this.textBoxLocalArchivedLogsDir.Text = archivedLogsPathName2;              
                }
                else
                {
                    this.textBoxLocalArchivedLogsDir.Text = VixFacade.GetDefaultLocalVixCacheDrive(config.VixDeploymentOption, config.VixCacheOption, config.VixCacheSize) + VixFacade.VIX_ARCHIVED_LOGS_DIRECTORY;                  
                }
                if (Directory.Exists(this.textBoxLocalArchivedLogsDir.Text))
                {
                    this.buttonArchivedLogsDir.Text = "Update";
                }

                int selectedArchiveIndex = GetArchivedLogsDriveIndex(this.textBoxLocalArchivedLogsDir.Text);
                this.comboBoxArchivedLogsDrive.SelectedIndex = selectedArchiveIndex;
                this.textBoxArchivedLogsSpaceAvailable.Text = this.archivelogsDrives[selectedArchiveIndex].GetAvailableFreeSpaceWithCacheGB(config.VixCacheSize).ToString();

                // VIX cache option - only available in developer mode
                //this.comboBoxCacheOption.SelectedIndex = this.GetCacheOptionIndex();

                this.enableEventHandlers = true;
                firstTime = false;
            }

            if (this.WizardForm.IsDeveloperMode())
            {
                this.ConfigurePageForDeveloperMode();
            }
            //this.ConfigurePageForCache();

            if (IsCacheDirConfigured() == true)
            {
                this.buttonCacheDir.Enabled = false;
            }
            else
            {
                this.buttonCacheDir.Enabled = true;
            }

            if (IsConfigDirConfigured() == true)
            {
                this.buttonCreateConfigDir.Enabled = false;
            }
            else
            {
                this.buttonCreateConfigDir.Enabled = true;
            }

            if (IsArchivedLogsDirConfigured() == true)
            {
                this.buttonArchivedLogsDir.Enabled = false;
            }
            else
            {
                this.buttonArchivedLogsDir.Enabled = true;
            }

            this.SetPageSubHeader();

            // set wizard form button state
            if (this.IsComplete())
            {
                this.WizardForm.EnableNextButton(true);
            }
            else
            {
                this.WizardForm.EnableNextButton(false);
            }
        }

        public override bool IsComplete()
        {
            bool isComplete = true;
            IVixConfigurationParameters config = this.WizardForm.GetVixConfigurationParameters();
            this.errorProvider1.Clear();
            
            if (IsCacheDirConfigured() == false)
            {
                isComplete = false;
            }

            if (IsConfigDirConfigured() == false)
            {
                isComplete = false;
            }

            if (IsArchivedLogsDirConfigured() == false)
            {
                isComplete = false;
            }
            
            //if (config.VixCacheOption == VixCacheType.ExchangeTimeStorageEvictionLocalFilesystem)
            //{
            //    if (this.ValidateCacheSize() == false)
            //    {
            //        isComplete = false;
            //    }
            //}

            return isComplete;
        }

        #endregion

        #region events

        private void buttonCacheDir_Click(object sender, EventArgs e)
        {
            if (Directory.Exists(this.textBoxLocalCacheDir.Text) == false)
            {
                Directory.CreateDirectory(this.textBoxLocalCacheDir.Text);
                this.Initialize();
            }
        }

        private void buttonCreateConfigDir_Click(object sender, EventArgs e)
        {
            if (Directory.Exists(this.textBoxLocalConfigDir.Text) == false)
            {
                Directory.CreateDirectory(this.textBoxLocalConfigDir.Text);
                this.Initialize();
            }
        }

        private void buttonArchivedLogsDir_Click(object sender, EventArgs e)
        {
            if (Directory.Exists(this.textBoxLocalArchivedLogsDir.Text) == false)
            {
                Directory.CreateDirectory(this.textBoxLocalArchivedLogsDir.Text);
            }
            if (Directory.Exists(GetTomcatArchivedLogsLinkPath()))
            {
                Directory.Delete(GetTomcatArchivedLogsLinkPath());
            }
            VixFacade.CreateSymbolicLink(GetTomcatArchivedLogsLinkPath(), this.textBoxLocalArchivedLogsDir.Text, 0x1);
            this.Initialize();         
        }

        private void comboBoxCacheDrive_SelectedIndexChanged(object sender, EventArgs e)
        {
            if (this.enableEventHandlers)
            {
                IVixConfigurationParameters config = this.WizardForm.GetVixConfigurationParameters();
                int selectedIndex = this.comboBoxCacheDrive.SelectedIndex;
                this.textBoxLocalCacheDir.Text = this.cacheDrives[selectedIndex].Drive + VixFacade.VIX_CACHE_DIRECTORY;
                config.LocalCacheDir = this.textBoxLocalCacheDir.Text.Replace(@"\", "/"); // cache dir is stored with forward slash
                this.textBoxCacheSpaceAvailable.Text = this.cacheDrives[selectedIndex].GetAvailableFreeSpaceWithCacheGB(config.VixCacheSize).ToString();
                vixTxDbDefaultPath = this.cacheDrives[selectedIndex].Drive + VixFacade.VIX_TRANSACTION_LOGS_DB_DIRECTORY;
                config.VixTxDbDir = vixTxDbDefaultPath.Replace(@"\", "/"); // cache dir is stored with forward slash
                this.Initialize();
            }
        }

        private void comboBoxConfigDrive_SelectedIndexChanged(object sender, EventArgs e)
        {
            if (this.enableEventHandlers)
            {
                IVixConfigurationParameters config = this.WizardForm.GetVixConfigurationParameters();
                this.textBoxLocalConfigDir.Text = this.configDrives[this.comboBoxConfigDrive.SelectedIndex].Drive + VixFacade.VIX_CONFIG_DIRECTORY;
                config.ConfigDir = this.textBoxLocalConfigDir.Text.Replace(@"\", "/"); // cache dir is stored with forward slash
                this.Initialize();
            }
        }

        private void comboBoxArchivedLogsDrive_SelectedIndexChanged(object sender, EventArgs e)
        {
            if (this.enableEventHandlers)
            {
                IVixConfigurationParameters config = this.WizardForm.GetVixConfigurationParameters();
                int selectedIndex = this.comboBoxArchivedLogsDrive.SelectedIndex;
                this.textBoxLocalArchivedLogsDir.Text = this.archivelogsDrives[selectedIndex].Drive + VixFacade.VIX_ARCHIVED_LOGS_DIRECTORY;
                this.textBoxArchivedLogsSpaceAvailable.Text = this.archivelogsDrives[selectedIndex].GetAvailableFreeSpaceWithCacheGB(config.VixCacheSize).ToString();
                this.Initialize();
            }
        }

        private void textBoxLocalConfigDir_TextChanged(object sender, EventArgs e)
        {
            if (this.enableEventHandlers)
            {
                IVixConfigurationParameters config = this.WizardForm.GetVixConfigurationParameters();
                config.ConfigDir = this.textBoxLocalConfigDir.Text.Replace(@"\", "/"); // config dir is stored with forward slash
                this.Initialize();
            }
        }

        private void textBoxLocalCacheDir_TextChanged(object sender, EventArgs e)
        {
            if (this.enableEventHandlers)
            {
                IVixConfigurationParameters config = this.WizardForm.GetVixConfigurationParameters();
                config.LocalCacheDir = this.textBoxLocalCacheDir.Text.Replace(@"\", "/"); // cache dir is stored with forward slash
                this.Initialize();
            }
        }

        private void textBoxLocalArchivedLogsDir_TextChanged(object sender, EventArgs e)
        {
            if (this.enableEventHandlers)
            {
                this.Initialize();
            }
        }

        //private void comboBoxCacheOption_SelectedIndexChanged(object sender, EventArgs e)
        //{
        //    if (this.enableEventHandlers)
        //    {
        //        IVixConfigurationParameters config = this.WizardForm.GetVixConfigurationParameters();
        //        int selectedIndex = this.comboBoxCacheOption.SelectedIndex;
        //        config.VixCacheOption = this.cacheConfigurations[selectedIndex].CacheOption;
        //        this.Initialize();
        //    }
        //}

        //private void numericUpDownCacheSize_ValueChanged(object sender, EventArgs e)
        //{
        //    if (this.enableEventHandlers)
        //    {
        //        IVixConfigurationParameters config = this.WizardForm.GetVixConfigurationParameters();
        //        config.VixCacheSize = (int) this.numericUpDownCacheSize.Value;
        //        int selectedIndex = this.comboBoxCacheDrive.SelectedIndex;
        //        DriveInfoForSelect cacheDrive = this.cacheDrives[selectedIndex];
        //        this.textBoxCacheSpaceAvailable.Text = cacheDrive.GetAvailableFreeSpaceWithCacheGB(config.VixCacheSize).ToString();
        //        this.Initialize();
        //    }
        //}
        #endregion

        #region private methods

        /// <summary>
        /// 
        /// </summary>
        private void ConfigurePageForDeveloperMode()
        {
            IVixConfigurationParameters config = this.WizardForm.GetVixConfigurationParameters();

            //    switch (config.VixCacheOption)
            //    {
            //        case VixCacheType.ExchangeTimeEvictionCifsFilesystem:
            //        case VixCacheType.ExchangeTimeEvictionLocalFilesystem:
            //            this.numericUpDownCacheSize.Enabled = false;
            //            break;
            //        default:
            //            this.numericUpDownCacheSize.Enabled = true;
            //            break;
            //    }

            textBoxLocalConfigDir.ReadOnly = false;
            textBoxLocalConfigDir.BackColor = Color.White;
            textBoxLocalCacheDir.ReadOnly = false;
            textBoxLocalCacheDir.BackColor = Color.White;
            textBoxLocalArchivedLogsDir.ReadOnly = false;
            textBoxLocalArchivedLogsDir.BackColor = Color.White;
        }

        /// <summary>
        /// 
        /// </summary>
        //private void ConfigurePageForCache()
        //{
        //    if (this.WizardForm.IsDeveloperMode())
        //    {
        //        this.groupBoxCacheConfig.Visible = true;
        //    }
        //    else
        //    {
        //        this.groupBoxCacheConfig.Visible = false;
        //    }
        //}

        /// <summary>
        /// Validate the cache size. As a side effect, set the error provider with an error message if the cache is set to
        /// a size larger than the space available on the specified cache drive.
        /// </summary>
        /// <returns>true if the cache wil fix on the selected cache drive, false otherwise</returns>
        //private bool ValidateCacheSize()
        //{
        //    IVixConfigurationParameters config = this.WizardForm.GetVixConfigurationParameters();
        //    int selectedIndex = this.comboBoxCacheDrive.SelectedIndex;
        //    DriveInfoForSelect cacheDrive = this.cacheDrives[selectedIndex];

        //    if (cacheDrive.GetAvailableFreeSpaceWithCacheGB(config.VixCacheSize) > 0)
        //    {
        //        //this.errorProvider1.Clear();
        //        return true;
        //    }
        //    else
        //    {
        //        this.errorProvider1.SetError(this.numericUpDownCacheSize, "Specified cache size of " + config.VixCacheSize.ToString() +
        //            "GB exceeds the available space of " + cacheDrive.GetAvailableFreeSpaceGB().ToString() + "GB on drive " + cacheDrive.Drive);
        //        return false;
        //    }
        //}

        private bool IsCacheDirConfigured()
        {
            bool isConfigured = true;
            IVixConfigurationParameters config = this.WizardForm.GetVixConfigurationParameters();
            if (config.LocalCacheDir != null)
            {
                if (Directory.Exists(config.LocalCacheDir) == false)
                {
                    isConfigured = false;
                }
            }
            else
            {
                isConfigured = false;
            }
            return isConfigured;
        }

        private bool IsConfigDirConfigured()
        {
            bool isConfigured = true;
            IVixConfigurationParameters config = this.WizardForm.GetVixConfigurationParameters();
            if (config.ConfigDir != null)
            {
                if (Directory.Exists(config.ConfigDir) == false)
                {
                    isConfigured = false;
                }
            }
            else
            {
                isConfigured = false;
            }

            return isConfigured;
        }

        private bool IsArchivedLogsDirConfigured()
        {
            bool isConfigured = true;
            string archivedLogsPathName = VixFacade.NativeMethods.GetFinalPathName(GetTomcatArchivedLogsLinkPath());
            // archived logs configuration
            if (!String.IsNullOrEmpty(archivedLogsPathName))
            {
                string[] archivedLogsPathSplit = archivedLogsPathName.Split('?');
                string archivedLogsPathName2 = archivedLogsPathSplit[1].Substring(1);
                if (archivedLogsPathName2 == this.textBoxLocalArchivedLogsDir.Text)
                {
                    if (Directory.Exists(archivedLogsPathName2) == false)
                    {
                        isConfigured = false;
                    }
                }
                else
                {
                    isConfigured = false;
                }
            }
            else
            {
                isConfigured = false;
            }

            return isConfigured;
        }

        private int GetCacheDriveIndex(string folder)
        {
            string folderDrive = Path.GetPathRoot(folder).ToUpper();
            int index = -1;

            for (int i = 0; i < this.cacheDrives.Length; i++)
            {
                if (folderDrive == this.cacheDrives[i].Drive)
                {
                    index = i;
                    break;
                }
            }

            return index;
        }

        private int GetConfigDriveIndex(string folder)
        {
            string folderDrive = Path.GetPathRoot(folder).ToUpper();
            int index = -1;

            for (int i = 0; i < this.configDrives.Length; i++)
            {
                if (folderDrive == this.configDrives[i].Drive)
                {
                    index = i;
                    break;
                }
            }

            return index;
        }

        private int GetArchivedLogsDriveIndex(string folder)
        {
            string folderDrive = Path.GetPathRoot(folder).ToUpper();
            int index = -1;

            for (int i = 0; i < this.archivelogsDrives.Length; i++)
            {
                if (folderDrive == this.archivelogsDrives[i].Drive)
                {
                    index = i;
                    break;
                }
            }

            return index;
        }

        private int GetCacheOptionIndex()
        {
            IVixConfigurationParameters config = this.WizardForm.GetVixConfigurationParameters();
            int index = -1;

            for (int i = 0; i < this.cacheConfigurations.Length; i++)
            {
                if (config.VixCacheOption == this.cacheConfigurations[i].CacheOption)
                {
                    index = i;
                    break;
                }
            }

            return index;
        }

        private string GetTomcatArchivedLogsLinkPath()
        {
            string tomcatArchiveLogsLinkPath = TomcatFacade.TomcatInstallationFolder + "\\logs\\ImagingArchivedLogsLink";
            return tomcatArchiveLogsLinkPath;
        }

        private void SetPageSubHeader()
        {
            IVixConfigurationParameters config = this.WizardForm.GetVixConfigurationParameters();
            if (this.IsComplete())
            {
                if (config.VixRole == VixRoleType.DicomGateway)
                {
                    this.InteriorPageSubHeader = "The HDIG cache, configuration, and log archive drives have been configured. Click Next to continue.";
                }
                else
                {
                    this.InteriorPageSubHeader = "The VIX cache, configuration, and log archive drives have been configured. Click Next to continue.";
                }
            }
            else
            {
                if (config.VixRole == VixRoleType.DicomGateway)
                {
                    this.InteriorPageSubHeader = "Select the drives for the HDIG cache, configuration, and log archive directories. Then create the folders.";
                }
                else
                {
                    this.InteriorPageSubHeader = "Select the drives for the VIX cache, configuration, and log archive directories. Then create the folders.";
                }
            }
        }

        private DriveInfoForSelect[] GetCacheDrives(VixDeploymentType vixDeploymentOption)
        {
            IVixConfigurationParameters config = this.WizardForm.GetVixConfigurationParameters();
            List<DriveInfoForSelect> drives = new List<DriveInfoForSelect>();

            DriveInfo[] driveInfoArray = null;
            if (config.VixRole == VixRoleType.EnterpriseGateway)
            {
                driveInfoArray = VixFacade.GetCacheAllDrives(config.VixDeploymentOption, config.VixCacheOption, config.VixCacheSize);
            }
            else
            {
                driveInfoArray = VixFacade.GetCacheDrives(config.VixDeploymentOption, config.VixCacheOption, config.VixCacheSize);
            }

            foreach (DriveInfo driveInfo in driveInfoArray)
            {
                drives.Add(new DriveInfoForSelect(driveInfo));
            }
            return drives.ToArray();
        }

        private DriveInfoForSelect[] GetArchivedLogsDrives(VixDeploymentType vixDeploymentOption)
        {
            IVixConfigurationParameters config = this.WizardForm.GetVixConfigurationParameters();
            List<DriveInfoForSelect> drives = new List<DriveInfoForSelect>();
            DriveInfo[] driveInfoArray = VixFacade.GetArchivedLogsAllDrives();            
            foreach (DriveInfo driveInfo in driveInfoArray)
            {
                drives.Add(new DriveInfoForSelect(driveInfo));
            }
            return drives.ToArray();
        }

        private DriveInfoForSelect[] GetConfigDrives(VixDeploymentType vixDeploymentOption)
        {
            IVixConfigurationParameters config = this.WizardForm.GetVixConfigurationParameters();
            List<DriveInfoForSelect> drives = new List<DriveInfoForSelect>();
            DriveInfo[] driveInfoArray = VixFacade.GetConfigDrives();
            foreach (DriveInfo driveInfo in driveInfoArray)
            {
                drives.Add(new DriveInfoForSelect(driveInfo));
            }
            return drives.ToArray();
        }

        #endregion

        #region nested classes
        private class DriveInfoForSelect
        {
            private static readonly long ONE_GIGBYTE = (1024 * 1024 * 1024);
            private string drive;
            private string description;
            private long spaceAvailable;

            public string Drive
            {
                get { return drive; }
                set { drive = value; }
            }

            public string Description
            {
                get { return description; }
                set { description = value; }
            }

            public long SpaceAvailable
            {
                get { return spaceAvailable; }
                set { spaceAvailable = value; }
            }

            public DriveInfoForSelect(DriveInfo driveInfo)
            {
                this.drive = driveInfo.Name;
                this.description = driveInfo.Name;
                this.spaceAvailable = driveInfo.AvailableFreeSpace;
                if (driveInfo.IsReady) // sanity check - only ready fixed disks will be fed to this routine
                {
                    if (driveInfo.VolumeLabel != null && driveInfo.VolumeLabel.Length > 0)
                    {
                        this.description += " - " + driveInfo.VolumeLabel;
                    }
                }
            }

            private long GetAvailableFreeSpaceGB()
            {
                return (this.spaceAvailable > 0) ? this.spaceAvailable / ONE_GIGBYTE : 0;
            }

            public long GetAvailableFreeSpaceWithCacheGB(long cacheSizeInGB)
            {
                //long spaceAvailableInGB = (this.spaceAvailable - (cacheSizeInGB * ONE_GIGBYTE)) / ONE_GIGBYTE;
                //return spaceAvailableInGB;
                return GetAvailableFreeSpaceGB(); // we arent specifying the cache size at this time - perhaps in P119
            }
        }
        #endregion
    }
}

