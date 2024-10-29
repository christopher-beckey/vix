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
    using DicomImporter.ViewModels;
   using System;
   using System.ComponentModel;
   using System.Windows;
   using System.Windows.Controls;
   using System.Windows.Input;
   using static DicomImporter.ViewModels.ImporterHomeViewModel;

   /// <summary>
   /// Interaction logic for ImporterHomeView.xaml
   /// </summary>
   public partial class ImporterHomeView
    {
        #region Constructors and Destructors

        /// <summary>
        /// Initializes a new instance of the <see cref="ImporterHomeView"/> class.
        /// </summary>
        public ImporterHomeView()
        {
            this.InitializeComponent();
        }

        /// <summary>
        /// Initializes a new instance of the <see cref="ImporterHomeView"/> class.
        /// </summary>
        /// <param name="viewModel">
        /// The view model.
        /// </param>
        public ImporterHomeView(ImporterHomeViewModel viewModel)
        {
            this.InitializeComponent();
            viewModel.UIDispatcher = this.Dispatcher;
            this.DataContext = viewModel;
            ((ImporterHomeViewModel)DataContext).m_PropertyChanged += OnPropertyChanged;
            viewModel.UpdatePropertyChangeCompatability();
            SizeChanged += OnSizeChanged;
            Loaded += OnLoaded;
        }

      #endregion

      /*private void OnButtonMediaStagingMouseEnter(object sender, MouseEventArgs e)
      {
         m_tblkTest.Text = "Copy the contents of a CD, DVD, or other media source to a staging area for future import processing.";
      }

      private void OnButtonMediaStagingMouseLeave(object sender, MouseEventArgs e)
      {
         m_tblkTest.Text = "";
      }

      private void OnButtonImportListMouseEnter(object sender, MouseEventArgs e)
      {
         m_tblkTest.Text = "View a list of currently available importer items.This list may include staged media, failed network imports, and DICOM correct items.";
      }

      private void OnButtonImportListMouseLeave(object sender, MouseEventArgs e)
      {
         m_tblkTest.Text = "";
      }

      private void OnButtonDirectImportMouseEnter(object sender, MouseEventArgs e)
      {
         m_tblkTest.Text = "Directly import artifacts from a CD, DVD, or other media source without first staging the media.";
      }

      private void OnButtonDirectImportMouseLeave(object sender, MouseEventArgs e)
      {
         m_tblkTest.Text = "";
      }

      private void OnButtonReportsMouseEnter(object sender, MouseEventArgs e)
      {
         m_tblkTest.Text = "View DICOM Importer reports and statistics.";
      }

      private void OnButtonReportsMouseLeave(object sender, MouseEventArgs e)
      {
         m_tblkTest.Text = "";
      }

      private void OnButtonAdministrationMouseEnter(object sender, MouseEventArgs e)
      {
         m_tblkTest.Text = "View DICOM Importer reports and statistics.";
      }

      private void OnButtonAdministrationMouseLeave(object sender, MouseEventArgs e)
      {
         m_tblkTest.Text = "";
      }*/

      /// <summary>
      /// P346 - Gary Pham (oitlonphamg)
      /// Set grid dimension based on variable status.
      /// </summary>
      //Begin P346
      private void OnPropertyChanged(object sender, PropertyChangedEventArgs e)
      {
         switch (e.PropertyName)
         {
            case  "UpdatePropertyChangeCompatability" :  {  bool[] bStatus = (bool[])((PropertyChangedEventArgsGeneric)e).m_Status;
                                                            m_gridImporterError.RowDefinitions[1].Height = bStatus[0] ? GridLength.Auto : new GridLength(0, GridUnitType.Pixel);
                                                            m_gridImporterError.RowDefinitions[2].Height = bStatus[1] ? GridLength.Auto : new GridLength(0, GridUnitType.Pixel);
                                                            break;   }

            default                                   :  {  break;   }
         }
      }
      //End P346

      /// <summary>
      /// P346 - Gary Pham (oitlonphamg)
      /// Update grid importermain dimension.
      /// </summary>
      //Begin P346
      private void OnSizeChanged(object sender, System.Windows.SizeChangedEventArgs e)
      {
         if (e.PreviousSize.Width != 0 && e.PreviousSize.Height != 0)
         {
            m_gridImporterMain.Height = e.NewSize.Height;
            m_gridImporterMain.Width = e.NewSize.Width;
         }
      }
      //End P346

      /// <summary>
      /// P346 - Gary Pham (oitlonphamg)
      /// Set grid importermain dimension.
      /// </summary>
      //Begin P346
      private void OnLoaded(object sender, RoutedEventArgs e)
      {
         m_gridImporterMain.Height = ActualHeight;
         m_gridImporterMain.Width = ActualWidth;
      }
      //End P346
   }
}