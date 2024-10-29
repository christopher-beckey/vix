using GalaSoft.MvvmLight;
using VISACommon;
using VISAChecksums;
using GalaSoft.MvvmLight.Command;
using VISAHealthMonitorCommon;
using System.Windows;
using System.Windows.Input;
using VISAHealthMonitorCommon.checksums;
using VISAHealthMonitorCommon.wiki;
using System;
using System.Collections.Generic;
using VISAHealthMonitorCommon.formattedvalues;
using System.Collections.ObjectModel;

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
    public class ChecksumsViewModel : ViewModelBase
    {
        public event CloseWindowDelegate OnCloseWindowEvent;
        public VisaSource VisaSource { get; set; }
        public string Title { get; private set; }
        public string SiteName { get; set; }
        public RelayCommand CloseCommand { get; set; }
        public RelayCommand RefreshCommand { get; set; }
        public VisaType VisaType { get; set; }
        public string StatusMessage { get; set; }
        public Visibility ErrorIconVisibility { get; set; }
        public Cursor Cursor { get; set; }
        public string Version { get; set; }
        public OsArchitecture OSArchitecture { get; private set; }

        public WikiConfiguration WikiConfiguration { get; set; }
        public ListViewSortedCollectionViewSource Checksums { get; private set; }
        public RelayCommand<string> SortFilesCommand { get; set; }
        public ObservableCollection<LibraryType> LibraryTypes { get; private set; }
        public object SelectedLibraryType { get; set; }

        public string Icon { get; private set; }

        /// <summary>
        /// Initializes a new instance of the ChecksumsViewModel class.
        /// </summary>
        public ChecksumsViewModel()
        {
            if (IsInDesignMode)
            {
            ////    // Code runs in Blend --> create design time data.
            }
            else
            {
            ////    // Code runs "for real": Connect to service, etc...
                CloseCommand = new RelayCommand(() => Close());
                RefreshCommand = new RelayCommand(() => LoadChecksumInformation());                
            }
            Version = "";
            Checksums = new ListViewSortedCollectionViewSource();
            SortFilesCommand = new RelayCommand<string>(val => Checksums.Sort(val));
            Checksums.Sort("Filename");
            ClearStatusMessage();

            LibraryTypes = new ObservableCollection<VISAChecksums.LibraryType>();
            LibraryTypes.Add(VISAChecksums.LibraryType.tomcatLib);
            LibraryTypes.Add(VISAChecksums.LibraryType.jreLibExt);
            SelectedLibraryType = VISAChecksums.LibraryType.tomcatLib;
            Icon = "images/Passed.ico";
            Cursor = Cursors.Arrow;
        }

        public void Initialize(WikiConfiguration wikiConfiguration, VisaSource visaSource, VisaType visaType)
        {
            this.VisaType = visaType;
            this.VisaSource = visaSource;
            this.WikiConfiguration = wikiConfiguration;
            VaSite site = (VaSite)VisaSource;
            this.SiteName = site.DisplayName;
            this.Title = site.DisplayName + "- Checksums";


            LoadChecksumInformation();
        }

        private LibraryType GetSelectedLibraryType()
        {
            if (SelectedLibraryType != null)
                return (LibraryType)SelectedLibraryType;
            return LibraryType.tomcatLib;
        }

        private void ClearStatusMessage()
        {
            SetStatusMessage("", false);
        }

        private void SetStatusMessage(string msg, bool error)
        {
            if (error)
            {
                ErrorIconVisibility = Visibility.Visible;
            }
            else
            {
                ErrorIconVisibility = Visibility.Collapsed;
            }
            StatusMessage = msg;
        }

        private void LoadChecksumInformation()
        {
            VisaHealth visaHealth =  VisaHealthManager.GetVisaHealth(VisaSource);
            if (visaHealth.LoadStatus == VixHealthLoadStatus.loaded)
            {
                ClearStatusMessage();
                try
                {
                    Cursor = Cursors.Wait;
                    this.Version = visaHealth.VisaVersion;
                    LibraryType libraryType = GetSelectedLibraryType();
                    this.OSArchitecture = GetOsArchitecture(visaHealth);
                    
                    ChecksumGroup checksumGroup = WikiChecksumRetriever.GetChecksums(WikiConfiguration,
                        Version, libraryType, VisaType, this.OSArchitecture);

                    List<FileDetails> visaChecksums = VisaChecksumRetriever.DownloadChecksums(VisaSource, libraryType);
                    if (ValidateChecksums(checksumGroup, visaChecksums))
                    {
                        Icon = "images/Passed.ico";
                    }
                    else
                    {
                        Icon = "images/failed.ico";
                    }
                }
                catch (Exception ex)
                {
                    SetStatusMessage(ex.Message, true);
                    Icon = "images/failed.ico";
                }
                finally
                {
                    Cursor = Cursors.Arrow;
                }
            }
            else
            {
                SetStatusMessage("Health must be loaded", true);
            }
        }

        private static OsArchitecture GetOsArchitecture(VisaHealth visaHealth)
        {
            switch (visaHealth.OperatingSystemArchitecture)
            {
                case "amd64":
                    return OsArchitecture.x64;
                default:
                    return OsArchitecture.x86;
            }
        }

        private bool ValidateChecksums(ChecksumGroup checksumGroup, List<FileDetails> visaChecksums)
        {
            bool allValid = true;
            List<ValidatedChecksum> validatedChecksums = new List<ValidatedChecksum>();

            foreach (FileDetails fileDetails in visaChecksums)
            {
                if (checksumGroup.Checksums.ContainsKey(fileDetails.Filename))
                {
                    FileDetails expectedFileDetails = checksumGroup.Checksums[fileDetails.Filename];
                    ValidatedChecksum validatedChecksum = new ValidatedChecksum(fileDetails.Filename, fileDetails.Checksum,
                        fileDetails.FileSize, expectedFileDetails.Checksum, expectedFileDetails.FileSize);
                    if (!validatedChecksum.Valid)
                        allValid = false;
                    validatedChecksums.Add(validatedChecksum);
                }
                else
                {
                    validatedChecksums.Add(new ValidatedChecksum(fileDetails.Filename, fileDetails.Checksum, 
                        fileDetails.FileSize, "", 0));
                    allValid = false;
                }
            }

            Checksums.SetSource(new ObservableCollection<ValidatedChecksum>(validatedChecksums));
            return allValid;
        }

        private void Close()
        {
            if (OnCloseWindowEvent != null)
                OnCloseWindowEvent();
        }

        ////public override void Cleanup()
        ////{
        ////    // Clean own resources if needed

        ////    base.Cleanup();
        ////}
    }

    public class ValidatedChecksum : FileDetails
    {
        public Visibility ValidIconVisibility { get; private set; }
        public Visibility InvalidIconVisibility { get; private set; }

        public string ExpectedChecksum { get; private set; }
        public FormattedNumber ExpectedSize { get; private set; }
        public FormattedNumber FormattedSize { get; private set; }

        public bool Valid { get; set; }

        public ValidatedChecksum(string filename, string checksum, long size, 
            string expectedChecksum, long expectedSize)
            : base(filename, checksum, size)
        {
            this.FormattedSize = new FormattedNumber(size);
            this.ExpectedChecksum = expectedChecksum;
            this.ExpectedSize = new FormattedNumber(expectedSize);

            if (checksum != expectedChecksum || size != expectedSize)
            {
                // invalid                
                ValidIconVisibility = Visibility.Collapsed;
                InvalidIconVisibility = Visibility.Visible;
                Valid = false;
            }
            else
            {
                // valid
                ValidIconVisibility = Visibility.Visible;
                InvalidIconVisibility = Visibility.Collapsed;
                Valid = true;
            }
        }
    }
}