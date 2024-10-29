/**
 * 
 * Package: MAG - VistA Imaging
 * WARNING: Per VHA Directive 2004-038, this routine should not be modified.
 * Date Created: 06/25/2013
 * Site Name:  Washington OI Field Office, Silver Spring, MD
 * Developer:  Lenard Williams
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
namespace DicomImporter.ViewModels
{
    using System;
    using System.Collections;
    using System.IO;
    using System.Windows.Interop;
    using DicomImporter.Common.Model;
    using ImageGear.Core;
    using ImageGear.Formats;
    using ImageGear.Formats.PDF;
    using ImageGear.Recognition;
    using ImageGear.TWAIN;
    using ImagingClient.Infrastructure.DialogService;
    using ImagingClient.Infrastructure.Events;
    using ImagingClient.Infrastructure.ViewModels;
    using log4net;
    using Microsoft.Practices.Prism.Commands;

    /// <summary>
    /// The scan document view model.
    /// </summary>
    public class ScanDocumentViewModel : ImporterViewModel
    {
        #region Constants and Fields

        /// <summary>
        /// The im gear DLL location
        /// </summary>
        private const string ImGearDllLocation = @"C:\Program Files (x86)\Accusoft\ImageGear.NET v20\Bin\";

        /// <summary>
        /// The number one
        /// </summary>
        private const string NumOne = "1";

        /// <summary>
        /// The PDF extension
        /// </summary>
        private const string PdfExtension = ".pdf";

        /// <summary>
        /// The select source button text
        /// </summary>
        private const string SelectSourceButtonText = "Select Source";

        /// <summary>
        /// The select source prompt
        /// </summary>
        private const string SelectSourcePrompt = "Please select a source.";

        /// <summary>
        /// The source selected text
        /// </summary>
        private const string SourceSelectedText = "Source selected";

        /// <summary>
        /// The update source button text
        /// </summary>
        private const string UpdateSourceButtonText = "Update Source";

        /// <summary>
        /// The importer temp folder.
        /// </summary>
        private readonly string importerTempFolder =
            Path.Combine(Environment.GetFolderPath(Environment.SpecialFolder.ApplicationData), "Importer");

        /// <summary>
        /// The logger.
        /// </summary>
        private static readonly ILog Logger = LogManager.GetLogger(typeof(ScanDocumentViewModel));

        /// <summary>
        /// The im gear TWAIN
        /// </summary>
        static private ImGearTWAIN imGearTWAIN;

        /// <summary>
        /// The file name
        /// </summary>
        private string fileName;

        /// <summary>
        /// The is source open
        /// </summary>
        private bool isSourceOpen;

        /// <summary>
        /// The scanned file
        /// </summary>
        private NonDicomFile scannedFile;

        /// <summary>
        /// The num pages
        /// </summary>
        private int numPages;

        /// <summary>
        /// The scan multi page
        /// </summary>
        private bool scanMultiPage;

        /// <summary>
        /// The scan multi adf page
        /// </summary>
        private bool scanMultiAdfPage;

        /// <summary>
        /// The scan single page
        /// </summary>
        private bool scanSinglePage;
        
        #endregion

        #region Constructors and Destructors

        /// <summary>
        /// Initializes a new instance of the <see cref="ScanDocumentViewModel" /> class.
        /// </summary>
        /// <param name="dialogService">The dialog service.</param>
        public ScanDocumentViewModel(IDialogService dialogService)
        {
            this.isSourceOpen = false;
            this.IsSinglePage = true;
            this.SourceStatus = SelectSourcePrompt;
            this.SourceButtonText = SelectSourceButtonText;

            this.DialogService = dialogService;

            this.ProgressViewModel = new ProgressViewModel();

            this.CancelCommand = new DelegateCommand<object>(o => this.PeformCancel(), o => !this.ProgressViewModel.IsWorkInProgress);

            this.SelectSourceCommand = new DelegateCommand<object>(o => this.SelectSource(), o => !this.ProgressViewModel.IsWorkInProgress);

            this.ScanCommand = new DelegateCommand<object>(o => this.Scan(), o => this.isSourceOpen && 
                                                                                  !this.ProgressViewModel.IsWorkInProgress && 
                                                                                  this.FileName != null && this.FileName.Length > 0);

            this.ConfigureImgLicense();

            // initializes the twain object
            imGearTWAIN = new ImGearTWAIN();
            imGearTWAIN.WindowHandle = new WindowInteropHelper(System.Windows.Application.Current.MainWindow).Handle;
            imGearTWAIN.UseUI = true;
        }

        #endregion

        #region Delegates

        /// <summary>
        /// The window action event handler.
        /// </summary>
        /// <param name="sender">
        /// The sender.
        /// </param>
        /// <param name="e">
        /// The e.
        /// </param>
        public delegate void WindowActionEventHandler(object sender, WindowActionEventArgs e);

        #endregion

        #region Public Methods

        /// <summary>
        /// Closes the twain source.
        /// </summary>
        public void CloseTwainSource()
        {
            try
            {
                if (imGearTWAIN != null)
                {
                    imGearTWAIN.CloseSource();
                }
            }
            catch (ImGearException)
            {
                // CloseSource throws an exception if you call it and the source is already closed.
            }
        }
        /// <summary>
        /// Gets the scanned file.
        /// </summary>
        /// <returns></returns>
        public NonDicomFile GetScannedFile()
        {
            return this.scannedFile;
        }

        #endregion

        #region Public Events

        /// <summary>
        /// The window action.
        /// </summary>
        public event WindowActionEventHandler WindowAction;

        #endregion

        #region Public Properties

        /// <summary>
        /// Gets or sets a value indicating whether [buttons disabled].
        /// </summary>
        public bool ButtonsDisabled
        {
            get
            {
                return this.ProgressViewModel.IsWorkInProgress;
            }
        }

        /// <summary>
        /// Gets or sets the name of the file.
        /// </summary>
        public string FileName 
        {
            get
            {
                return this.fileName;
            }

            set
            {
                this.fileName = value;

                this.RaiseControlsChanged();
            }
        }

        /// <summary>
        /// Gets or sets the num of pages.
        /// </summary>
        public string NumOfPages
        {
            get
            {
                return numPages.ToString();
            }

            set
            {
                try
                {
                    numPages = Convert.ToInt16(value);

                    if (numPages == 0)
                    {
                        throw new Exception();
                    }
                }
                catch (Exception)
                {
                    this.DialogService.ShowAlertBox(this.UIDispatcher, 
                                                    "The number of pages must be a whole number between 0 and 32,767", 
                                                    "Invalid Number of Pages", MessageTypes.Error);

                    numPages = 1;
                    this.RaisePropertyChanged("NumOfPages");
                }
            }
        }

        /// <summary>
        /// Gets or sets ProgressViewModel.
        /// </summary>
        public ProgressViewModel ProgressViewModel { get; set; }

        /// <summary>
        /// Gets or sets a value indicating whether this instance is multi page.
        /// </summary>
        /// <value>
        /// <c>true</c> if this instance is multi page; otherwise, <c>false</c>.
        /// </value>
        public bool IsMultiPage 
        {
            get
            {
                return this.scanMultiPage;
            }

            set
            {
                this.scanMultiPage = value;

                this.RaisePropertyChanged("IsMultiPage");
            }
        }

        /// <summary>
        /// Gets or sets a value indicating whether this instance is multi adf page.
        /// </summary>
        /// <value>
        /// <c>true</c> if this instance is multi adf page; otherwise, <c>false</c>.
        /// </value>
        public bool IsMultiAdfPage
        {
            get
            {
                return this.scanMultiAdfPage;
            }

            set
            {
                this.scanMultiAdfPage = value;

                this.RaisePropertyChanged("IsMultiAdfPage");
            }
        }

        /// <summary>
        /// Gets or sets a value indicating whether this instance is single page.
        /// </summary>
        /// <value>
        /// <c>true</c> if this instance is single page; otherwise, <c>false</c>.
        /// </value>
        public bool IsSinglePage 
        {
            get
            {
                return this.scanSinglePage;
            }

            set
            {
                this.NumOfPages = NumOne;
                this.scanSinglePage = value;
                this.RaisePropertyChanged("IsSinglePage");
            }

        }

        /// <summary>
        /// Gets or sets the source button text.
        /// </summary>
        public string SourceButtonText { get; set; }

        /// <summary>
        /// Gets or sets the source status.
        /// </summary>
        /// <value>
        /// The source status.
        /// </value>
        public string SourceStatus { get; set; }

        #endregion

        #region Delegate Commands

        /// <summary>
        /// Gets or sets CancelCommand.
        /// </summary>
        public DelegateCommand<object> CancelCommand { get; set; }

        /// <summary>
        /// Gets or sets ScanCommand.
        /// </summary>
        public DelegateCommand<object> ScanCommand { get; set; }

        /// <summary>
        /// Gets or sets SelectSourceCommand.
        /// </summary>
        public DelegateCommand<object> SelectSourceCommand { get; set; }

        #endregion

        #region Private Methods

        /// <summary>
        /// Closes the window.
        /// </summary>
        private void CloseWindow()
        {
            this.WindowAction(this, new WindowActionEventArgs(false));
        }

        /// <summary>
        /// Configures the Image Gear license.
        /// </summary>
        private void ConfigureImgLicense()
        {
            // Initialize evaluation manager.
           // ImGearEvaluationManager.Initialize();

         /*   if (IntPtr.Size == 8) //Win64
                ImGearLicense.SetSolutionName("AccuSoft 5-41-20");
            else //Win32
                ImGearLicense.SetSolutionName("AccuSoft 5-40-20");
            */
            ImGearLicense.SetSolutionName("Department of Veteran Affairs");
            ImGearLicense.SetSolutionKey(0xBDFAA6FB, 0x9D6555BA, 0xD65F1910, 0xA61FF100);
        }

        /// <summary>
        /// Generates the PDF.
        /// </summary>
        /// <param name="pages">The pages.</param>
        /// <returns></returns>
        private NonDicomFile GeneratePDF(Queue pages)
        {
            this.ProgressViewModel.Value = 0;
            this.ProgressViewModel.Maximum = pages.Count;
            this.ProgressViewModel.IsIndeterminate = false;

            this.ProgressViewModel.Text = "Generating PDF Page...";

            //ImGearDllLocation
            ImGearRecognition imageRecognition = new ImGearRecognition(ImGearDllLocation);

            // Initialize PDF Assembly for export
            ImGearFileFormats.Filters.Add(ImGearPDF.CreatePDFFormat(ImGearDllLocation));
            ImGearPDF.Initialize();

            ImGearPDFDocument pdfDocument = new ImGearPDFDocument();

            // Create and set PDF Output options; Text-only PDF
            ImGearRecPDFOutputOptions options = new ImGearRecPDFOutputOptions();
            options.VisibleImage = true;
            options.VisibleText = true;
          
            foreach (ImGearPage page in pages)
            {
                this.ProgressViewModel.Text = "Generating PDF Page " + (this.ProgressViewModel.Value + 1) + 
                                              " of " + this.ProgressViewModel.Maximum;

                // Import image into Recognition engine
                ImGearRecPage recPage = imageRecognition.ImportPage((ImGearRasterPage)page);
                recPage.Image.Preprocess();
                recPage.Recognize();

                // Export page to PDF
                recPage.CreatePDFPage(pdfDocument, options);
                this.ProgressViewModel.Value++;
            }
            
            string scannedInDirectory = Path.Combine(this.importerTempFolder, "Scanned_In");

            String filePath = Path.Combine(scannedInDirectory, Guid.NewGuid() + PdfExtension);
        
            var f = new FileInfo(filePath);
                
            // creates the temp directory to hold all of the scanned in PDF's
            if (f.Directory != null && !f.Directory.Exists)
            {
                f.Directory.Create();
            }

            pdfDocument.Save(filePath, ImGearSavingFormats.PDF_UNCOMP,
                             0, 0, (int)ImGearPDFPageRange.ALL_PAGES, ImGearSavingModes.OVERWRITE);

            DialogService.ShowAlertBox(this.UIDispatcher, "The document has been successfully scanned into the Importer.",
                                        "Success", MessageTypes.Info);

            if (!this.FileName.EndsWith(PdfExtension))
            {
                this.FileName += PdfExtension;   
            }
            
            return new NonDicomFile(filePath, this.FileName);
        }

        /// <summary>
        /// Initializes the ImageGear formats.
        /// </summary>
        private void InitializeIGFormats()
        {
            ImageGear.Formats.ImGearCameraRawFormats.Initialize();
            ImageGear.Formats.ImGearCommonFormats.Initialize();
            ImageGear.Formats.ImGearAdvancedFormats.Initialize();
        }

        /// <summary>
        /// The peform cancel.
        /// </summary>
        private void PeformCancel()
        {
            if (this.isSourceOpen)
            {
                imGearTWAIN.CloseSource();
                this.isSourceOpen = false;
            }

            this.WindowAction(this, new WindowActionEventArgs(false));
        }

        /// <summary>
        /// Raises the controls changed methods.
        /// </summary>
        private void RaiseControlsChanged()
        {
            this.RaisePropertyChanged("ButtonsDisabled");

            this.ScanCommand.RaiseCanExecuteChanged();
            this.CancelCommand.RaiseCanExecuteChanged();
            this.SelectSourceCommand.RaiseCanExecuteChanged();
        }

        /// <summary>
        /// Scans this instance.
        /// </summary>
        private void Scan()
        {
            this.InitializeIGFormats();

            this.ProgressViewModel.Text = "Scanning Document via External Source";
            this.ProgressViewModel.IsWorkInProgress = true;

            this.RaiseControlsChanged();

            Queue scannedPages = new Queue();

            if (this.IsMultiAdfPage)
            {
                ImGearDocument scannedDocument = imGearTWAIN.AcquireToDoc(-1);
                GC.Collect();

                // coverts the scanned document into individual pages
                foreach(ImGearPage page in scannedDocument.Pages)
                {
                    scannedPages.Enqueue(page);
                }

            }
            else
            {
                int maxNumOfPages = Convert.ToInt16(this.NumOfPages);

                // scans in each page
                for (int i = 1; i <= maxNumOfPages; i++)
                {
                    ImGearPage scannedImagePage = imGearTWAIN.AcquireToPage();
                    scannedPages.Enqueue(scannedImagePage);
                    GC.Collect();

                    if (this.IsMultiPage && (i + 1) <= (maxNumOfPages) && maxNumOfPages > 1)
                    {
                        string message = "Please place page " + (i + 1) + 
                                         " on the scanner and press OK. If you want to discontinue scanning additional pages, press Cancel.";

                        if (!DialogService.ShowOkCancelBox(this.UIDispatcher, message, "Ready For Next Page", MessageTypes.Info))
                        {
                            i = maxNumOfPages;
                        }
                    }
                }      
            }

            this.scannedFile = this.GeneratePDF(scannedPages);

            this.ProgressViewModel.IsWorkInProgress = false;
            this.RaiseControlsChanged();

            this.CloseWindow();
        }

        /// <summary>
        /// Selects the source.
        /// </summary>
        private void SelectSource()
        {
            try
            {
                if (this.isSourceOpen)
                {
                    imGearTWAIN.CloseSource();
                    this.isSourceOpen = false;
                }

                this.ProgressViewModel.IsWorkInProgress = true;
                this.ProgressViewModel.IsIndeterminate = true;
                this.ProgressViewModel.Text = "Selecting TWAIN Source...";

                this.RaiseControlsChanged();

                imGearTWAIN.OpenSource("");

                this.ProgressViewModel.IsWorkInProgress = false;

                this.isSourceOpen = true;
                this.SourceStatus = SourceSelectedText;
                this.SourceButtonText = UpdateSourceButtonText;
            }
            catch (Exception ex)
            {
                this.ProgressViewModel.IsWorkInProgress = false;
               
                this.SourceStatus =  SelectSourcePrompt;
                this.SourceButtonText = SelectSourceButtonText;

                Logger.Error(ex.Message, ex);
            }

            this.RaiseControlsChanged();
        }

        #endregion
    }
}