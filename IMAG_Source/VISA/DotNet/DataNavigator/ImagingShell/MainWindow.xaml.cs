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

using System.ComponentModel;
using System.Windows;
using ImagingClient.Infrastructure.Commands;
using ImagingClient.Infrastructure.User.Model;
using ImagingClient.Infrastructure.Views;
using Microsoft.Practices.Prism.Regions;
using Microsoft.Practices.ServiceLocation;

namespace ImagingShell
{
    /// <summary>
    /// Interaction logic for MainWindow.xaml
    /// </summary>
    public partial class MainWindow : Window
    {
        public MainWindow(MainWindowViewModel viewModel, IRegionManager regionManager)
        {
            InitializeComponent();
            this.Name = "MainWindow";
            this.DataContext = viewModel;

            //Initialize Menus
            //MenuItem mnuDicom = new MenuItem();
            //mnuDicom.Header = "Importer";
            //this.mnuMain.Items.Insert(mnuMain.Items.Count-1, mnuDicom);

            //MenuItem mnuDicomImport = new MenuItem();
            //mnuDicomImport.Header = "Importer Home";
            //mnuDicomImport.Command = ((MainWindowViewModel)DataContext).ShowDicomHome;
            //mnuDicom.Items.Add(mnuDicomImport);

            // Register for the login event
            viewModel.ShowLoginWindow += OnShowLoginWindow;
        }

        public void OnShowLoginWindow()
        {
            UserContext.UserCredentials = null;
            LoginWindow loginWindow = ServiceLocator.Current.GetInstance<LoginWindow>();
            loginWindow.Owner = this;
            loginWindow.ShowDialog();
        }

        private void OnWindowClosing(object sender, CancelEventArgs e)
        {
            if (CompositeCommands.ShutdownCommand.CanExecute(e))
                CompositeCommands.ShutdownCommand.Execute(e);
            if (!e.Cancel)
                Application.Current.Shutdown();
        }

        private void ExitItem_Click(object sender, RoutedEventArgs e)
        {
            Close();
        }

        private void AboutDataNavigator_Click(object sender, RoutedEventArgs e)
        {
            var aboutWindow = ServiceLocator.Current.GetInstance<AboutWindow>();
            aboutWindow.Title = "Data Navigator";
            aboutWindow.ShowDialog();
        }
    }
}
