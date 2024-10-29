/**
 * 
 * Package: MAG - VistA Imaging
 * WARNING: Per VHA Directive 2004-038, this routine should not be modified.
 * Date Created: 03/01/2011
 * Site Name:  Washington OI Field Office, Silver Spring, MD
 * Developer:  Jon Louthian
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
    using System.Collections.Generic;
    using System.Collections.ObjectModel;
    using System.Linq;

    using DicomImporter.Common.Interfaces.DataSources;
    using DicomImporter.Common.Model;
    using DicomImporter.Common.ViewModels;

    using ImagingClient.Infrastructure.DialogService;
    using ImagingClient.Infrastructure.Events;

    using Microsoft.Practices.Prism.Commands;

    /// <summary>
    /// The procedure lookup view model.
    /// </summary>
    public class ProcedureLookupViewModel : ImporterViewModel
    {
        #region Constants and Fields

        /// <summary>
        /// The procedure.
        /// </summary>
        private Procedure procedure;

        #endregion

        #region Constructors and Destructors

        /// <summary>
        /// Initializes a new instance of the <see cref="ProcedureLookupViewModel"/> class.
        /// </summary>
        /// <param name="dialogService">
        /// The dialog service.
        /// </param>
        /// <param name="dicomImporterDataSource">
        /// The dicom importer data source.
        /// </param>
        public ProcedureLookupViewModel(IDialogService dialogService, IDicomImporterDataSource dicomImporterDataSource)
        {
            this.DialogService = dialogService;
            this.DicomImporterDataSource = dicomImporterDataSource;

            this.OkCommand = new DelegateCommand<object>(o => this.PeformOk(), o => this.IsOkButtonEnabled());

            this.CancelCommand = new DelegateCommand<object>(o => this.PeformCancel());
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

        #region Public Events

        /// <summary>
        /// The window action.
        /// </summary>
        public event WindowActionEventHandler WindowAction;

        #endregion

        #region Public Properties

        /// <summary>
        /// Gets or sets AllProcedures.
        /// </summary>
        public ObservableCollection<Procedure> AllProcedures { get; set; }

        /// <summary>
        /// Gets or sets CancelCommand.
        /// </summary>
        public DelegateCommand<object> CancelCommand { get; set; }




        //Commented since binding element {NotifyPropertyWeaverMsBuildTask} is no longer available in VS 2015 and above versions. (p289-OITCOPondiS)
        /// <summary>
        /// Gets or sets MatchingProcedures.
        /// </summary>
        //public ObservableCollection<Procedure> MatchingProcedures { get; set; }

        //BEGIN-Modified MatchingProcedures property to bind control. Earlier binding made through imlementing library {NotifyPropertyWeaverMsBuildTask}.(p289-OITCOPondiS) 
        private ObservableCollection<Procedure> _MatchingProcedures { get; set; }

        
        public ObservableCollection<Procedure> MatchingProcedures
        {
            get { return _MatchingProcedures; }
            set
            {

                _MatchingProcedures = value;
                this.RaisePropertyChanged("MatchingProcedures");
            }
        }
        //END.


        /// <summary>
        /// Gets or sets OkCommand.
        /// </summary>
        public DelegateCommand<object> OkCommand { get; set; }

        /// <summary>
        /// Gets or sets SearchCriteria.
        /// </summary>
        public string SearchCriteria { get; set; }

        /// <summary>
        /// Gets or sets SelectedProcedure.
        /// </summary>
        public Procedure SelectedProcedure
        {
            get
            {
                return this.procedure;
            }

            set
            {
                this.procedure = value;
                //Added RaisePropertyChanged event handler to retain SelectedProcedure in text box.Earlier raising events are handled through imlementing library {NotifyPropertyWeaverMsBuildTask}(p289-OITCOPondiS)
                this.RaisePropertyChanged("SelectedProcedure");
                this.OkCommand.RaiseCanExecuteChanged();
            }
        }

        #endregion

        #region Public Methods

        /// <summary>
        /// The peform filter.
        /// </summary>
        public void PeformFilter()
        {
            if (this.SearchCriteria == null)
            {
                this.SearchCriteria = string.Empty;
            }

            this.MatchingProcedures = new ObservableCollection<Procedure>(
                from procedure in this.AllProcedures
                where procedure.Name.ToLower().StartsWith(this.SearchCriteria.ToLowerInvariant())
                select procedure);

            IEnumerable<Procedure> containsKeyword = from procedure in this.AllProcedures
                                                     where
                                                         procedure.Name.ToLower().Contains(
                                                             this.SearchCriteria.ToLowerInvariant())
                                                         && !this.MatchingProcedures.Contains(procedure)
                                                     select procedure;

            foreach (Procedure proc in containsKeyword)
            {
                this.MatchingProcedures.Add(proc);
            }
        }

        #endregion

        #region Methods

        /// <summary>
        /// Determines whether the OK button should be enabled.
        /// </summary>
        /// <returns>
        ///   <c>true</c> if the OK button should be enabled; otherwise, <c>false</c>.
        /// </returns>
        private bool IsOkButtonEnabled()
        {
            return this.SelectedProcedure != null;
        }

        /// <summary>
        /// The peform cancel.
        /// </summary>
        private void PeformCancel()
        {
            this.WindowAction(this, new WindowActionEventArgs(false));
        }

        /// <summary>
        /// The peform ok.
        /// </summary>
        private void PeformOk()
        {
            this.WindowAction(this, new WindowActionEventArgs(true));
        }

        #endregion
    }
}