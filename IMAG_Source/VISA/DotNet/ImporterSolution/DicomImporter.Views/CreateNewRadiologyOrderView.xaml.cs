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
namespace DicomImporter.Views
{
    using System;
    using System.Collections.ObjectModel;
    using System.Windows;
    using System.Windows.Controls;

    using DicomImporter.Common.Model;
    using DicomImporter.ViewModels;

    using Microsoft.Practices.ServiceLocation;

    /// <summary>
    /// Interaction logic for OrderSelectionView.xaml
    /// </summary>
    public partial class CreateNewRadiologyOrderView
    {
        #region Constants and Fields

        /// <summary>
        /// The selected procedure modifiers.
        /// </summary>
        private ObservableCollection<ProcedureModifier> selectedProcedureModifiers;

        #endregion

        #region Constructors and Destructors

        /// <summary>
        /// Initializes a new instance of the <see cref="CreateNewRadiologyOrderView"/> class.
        /// </summary>
        public CreateNewRadiologyOrderView()
        {
            this.InitializeComponent();
        }

        /// <summary>
        /// Initializes a new instance of the <see cref="CreateNewRadiologyOrderView"/> class.
        /// </summary>
        /// <param name="viewModel">
        /// The view model.
        /// </param>
        public CreateNewRadiologyOrderView(CreateNewRadiologyOrderViewModel viewModel)
        {
            this.InitializeComponent();
            viewModel.UIDispatcher = this.Dispatcher;
            this.DataContext = viewModel;
            this.ViewModel.InitializeProcedureModifiers += this.InitializeProcedureModifiers;
            this.ViewModel.RefreshSelectedProcedureModifiers += this.RefreshSelectedProcedureModifiers;
        }

        #endregion

        #region Public Properties

        /// <summary>
        /// Gets ViewModel.
        /// </summary>
        public CreateNewRadiologyOrderViewModel ViewModel
        {
            get
            {
                return (CreateNewRadiologyOrderViewModel)this.DataContext;
            }
        }

        #endregion

        #region Private Methods

        /// <summary>
        /// The initialize procedure modifiers.
        /// </summary>
        /// <param name="sender">
        /// The sender.
        /// </param>
        /// <param name="e">
        /// The e.
        /// </param>
        private void InitializeProcedureModifiers(object sender, EventArgs e)
        {
            this.procedureModifiersList.Items.Clear();

            if (this.ViewModel.SelectedProcedure != null && this.ViewModel.SelectedProcedure.ProcedureModifiers != null)
            {
                foreach (ProcedureModifier mod in this.ViewModel.SelectedProcedure.ProcedureModifiers)
                {
                    this.procedureModifiersList.Items.Add(mod);
                }
            }
        }

        /// <summary>
        /// Indicates whether an modifiers are selected.
        /// </summary>
        /// <param name="modifier">The modifier.</param>
        /// <returns>Whether an modifiers are selected</returns>
        private bool ModifierIsSelected(ProcedureModifier modifier)
        {
            foreach (ProcedureModifier selectedModifier in this.selectedProcedureModifiers)
            {
                if (selectedModifier.Id == modifier.Id)
                {
                    return true;
                }
            }

            return false;
        }

        /// <summary>
        /// The procedure modifiers_ selection changed.
        /// </summary>
        /// <param name="sender">
        /// The sender.
        /// </param>
        /// <param name="e">
        /// The e.
        /// </param>
        private void ProcedureModifiers_SelectionChanged(object sender, SelectionChangedEventArgs e)
        {
            var selectedModifiers = new ObservableCollection<ProcedureModifier>();
            foreach (ProcedureModifier modifier in this.procedureModifiersList.SelectedItems)
            {
                selectedModifiers.Add(modifier);
            }

            this.ViewModel.SelectedProcedureModifiers = selectedModifiers;
        }

        /// <summary>
        /// The refresh selected procedure modifiers.
        /// </summary>
        /// <param name="sender">
        /// The sender.
        /// </param>
        /// <param name="e">
        /// The event args.
        /// </param>
        private void RefreshSelectedProcedureModifiers(object sender, EventArgs e)
        {
            if (this.ViewModel.CurrentReconciliation.Order != null
                && this.ViewModel.CurrentReconciliation.Order.IsToBeCreated)
            {
                if (this.ViewModel.SelectedProcedure != null)
                {
                    this.selectedProcedureModifiers = this.ViewModel.SelectedProcedureModifiers != null 
                        ? new ObservableCollection<ProcedureModifier>(this.ViewModel.SelectedProcedureModifiers) 
                        : new ObservableCollection<ProcedureModifier>();

                    this.InitializeProcedureModifiers(sender, e);

                    foreach (ProcedureModifier modifier in this.procedureModifiersList.Items)
                    {
                        if (this.ModifierIsSelected(modifier))
                        {
                            this.procedureModifiersList.SelectedItems.Add(modifier);
                        }
                    }
                }
                else
                {
                    this.procedureModifiersList.Items.Clear();
                }
            }
        }

        /// <summary>
        /// Event handler for the Change Ordering Location button.
        /// </summary>
        /// <param name="sender">
        /// The sender.
        /// </param>
        /// <param name="e">
        /// The event args.
        /// </param>
        private void ChangeLocation_Click(object sender, RoutedEventArgs e)
        {
            var window = ServiceLocator.Current.GetInstance<OrderingLocationLookupWindow>();
            window.ViewModel.AllLocations = this.ViewModel.DicomImporterDataSource.GetOrderingLocationList();
            window.ViewModel.MatchingLocations = window.ViewModel.AllLocations;
            window.SubscribeToNewUserLogin();
            window.ShowDialog();

            if (window.DialogResult.HasValue && window.DialogResult.Value)
            {
                this.ViewModel.SelectedOrderingLocation = window.ViewModel.SelectedLocation;
            }
        }

        /// <summary>
        /// The btn change procedure_ click.
        /// </summary>
        /// <param name="sender">
        /// The sender.
        /// </param>
        /// <param name="e">
        /// The e.
        /// </param>
        private void ChangeProcedure_Click(object sender, RoutedEventArgs e)
        {
            var window = ServiceLocator.Current.GetInstance<ProcedureLookupWindow>();
            window.ViewModel.AllProcedures = this.ViewModel.DicomImporterDataSource.GetProcedureList(ViewModel.CurrentReconciliation.ImagingLocation.Id);
            window.ViewModel.MatchingProcedures = window.ViewModel.AllProcedures;
            window.SubscribeToNewUserLogin();
            window.ShowDialog();

            if (window.DialogResult.HasValue && window.DialogResult.Value)
            {
                this.ViewModel.SelectedProcedure = window.ViewModel.SelectedProcedure;
                this.RefreshSelectedProcedureModifiers(this, null);
            }
        }

        /// <summary>
        /// The btn change provider_ click.
        /// </summary>
        /// <param name="sender">
        /// The sender.
        /// </param>
        /// <param name="e">
        /// The e.
        /// </param>
        private void ChangeProvider_Click(object sender, RoutedEventArgs e)
        {
            var window = ServiceLocator.Current.GetInstance<OrderingProviderLookupWindow>();
            window.ViewModel.UIDispatcher = this.Dispatcher;
            window.ViewModel.OwningWindow = window;
            window.Owner = Window.GetWindow(this);
            window.SubscribeToNewUserLogin();
            window.ShowDialog();

            if (window.DialogResult.HasValue && window.DialogResult.Value)
            {
                this.ViewModel.SelectedOrderingProvider = window.ViewModel.SelectedProvider;
            }
        }

        /// <summary>
        /// Shows the status change details window.
        /// </summary>
        /// <param name="sender">The sender.</param>
        /// <param name="e">The <see cref="EventArgs" /> instance containing the event data.</param>
        private void ShowStatusChangeDetailsWindow(object sender, EventArgs e)
        {
            var window = ServiceLocator.Current.GetInstance<StatusChangeDetailsWindow>();
            window.ViewModel.UIDispatcher = this.Dispatcher;
            window.ViewModel.SetCurrentStatusChangeDetails(this.ViewModel.StatusChangeDetails);
            window.ViewModel.OwningWindow = window;
            window.ViewModel.SelectedWorkItemKey = this.ViewModel.SelectedWorkItemKey;
            window.ViewModel.CurrentModalities = this.ViewModel.CurrentModalities;
            window.Owner = Window.GetWindow(this);
            window.SubscribeToNewUserLogin();
            window.ShowDialog();

            // assigns the status change details to the selected order
            if (window.DialogResult.HasValue && window.DialogResult.Value)
            {
                this.ViewModel.StatusChangeDetails = window.ViewModel.StatusChangeDetails;
            }
        }

        #endregion
    }
}