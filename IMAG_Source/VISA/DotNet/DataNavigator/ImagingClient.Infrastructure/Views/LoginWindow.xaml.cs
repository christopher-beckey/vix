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


using System;
using System.Collections.Generic;
using System.Collections.ObjectModel;
using System.ComponentModel;
using System.Linq;
using System.Text;
using System.Windows;
using System.Windows.Controls;
using System.Windows.Data;
using System.Windows.Documents;
using System.Windows.Input;
using System.Windows.Media;
using System.Windows.Media.Imaging;
using System.Windows.Shapes;
using ImagingClient.Infrastructure.Events;
using ImagingClient.Infrastructure.User.Model;
using ImagingClient.Infrastructure.ViewModels;
using Microsoft.Practices.Unity;

namespace ImagingClient.Infrastructure.Views
{
    /// <summary>
    /// Interaction logic for LoginWindow.xaml
    /// </summary>
    public partial class LoginWindow : Window
    {
        public bool LoginSuccessful { get; set; }
        public String AccessCode { get; set; }
        public String VerifyCode { get; set; }
        public ObservableCollection<String> SecurityKeys { get; set; }

        public LoginWindow(LoginWindowViewModel viewModel)
        {
            InitializeComponent();
            LoginSuccessful = false;
            SecurityKeys = new ObservableCollection<String>();
            DataContext = viewModel;
            ((LoginWindowViewModel)DataContext).WindowAction += HandleWindowAction;
            ((LoginWindowViewModel)DataContext).DivisionAction += HandleDivisionAction;

        }

        private void HandleWindowAction(object sender, WindowActionEventArgs e)
        {
            if (e.IsOk)
            {
                LoginSuccessful = true;

                if (UserContext.UserCredentials != null)
                {
                    Application.Current.MainWindow.Title += " " +
                                                           UserContext.UserCredentials.PlaceName + " (" +
                                                           UserContext.UserCredentials.PlaceId + ")";
                }
                DialogResult = true;
            }
            else
            {
                Close();
            }
        }

        private void HandleDivisionAction(object sender, DivisionActionEventArgs e)
        {
            DivisionWindowViewModel viewModel = new DivisionWindowViewModel(e.Divisions);
            DivisionWindow window = new DivisionWindow(viewModel);

            window.ShowDialog();
        }

        protected override void OnClosing(CancelEventArgs e)
        {
            base.OnClosing(e);

            // Don't all them to close the window (i.e. with the X button or alt-F4) if they
            // have not successfully logged in.
            if (!LoginSuccessful)
            {
                e.Cancel = true;
            }
        }

    }
}
