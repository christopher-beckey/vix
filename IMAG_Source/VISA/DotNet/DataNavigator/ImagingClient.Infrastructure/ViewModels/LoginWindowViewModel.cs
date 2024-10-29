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
using System.Windows;
using ImagingClient.Infrastructure.Events;
using ImagingClient.Infrastructure.User.Model;
using ImagingClient.Infrastructure.UserDataSource;
using Microsoft.Practices.Prism.Commands;

namespace ImagingClient.Infrastructure.ViewModels
{
    public class LoginWindowViewModel : ImagingViewModel
    {
        protected IUserDataSource UserDataSource { get; set; }

        public String AccessCode { get; set; }
        public String VerifyCode { get; set; }
        public String AlertText { get; set; }
        public String LoginErrorMessage { get; set; }

        public DelegateCommand<object> OnCancelLogin { get; set; }
        public DelegateCommand<object> OnLogin { get; set; }

        public delegate void WindowActionEventHandler(object sender, WindowActionEventArgs e);
        public delegate void DivisionActionEventHandler(object sender, DivisionActionEventArgs e);
        public event WindowActionEventHandler WindowAction;
        public event DivisionActionEventHandler DivisionAction;

        public LoginWindowViewModel(IUserDataSource userDataSource)
        {
            UserDataSource = userDataSource;

            AlertText = UserDataSource.GetWelcomeMessage();

            // Handle Login attempt
            OnLogin = new DelegateCommand<object>(
                o =>
                {
                    // Perform Login. For now it's just a mock login that stores access and verify code, and security keys
                    // based on accesscode.
                    UserDataSource.AuthenticateUser(AccessCode, VerifyCode);

                    if (UserContext.IsLoginSuccessful)
                    {

                        ObservableCollection<Division> divisions = UserDataSource.GetDivisionList(AccessCode);
                        if (divisions.Count == 1)
                        {
                            UserContext.UserCredentials.CurrentDivision = divisions[0];
                        }
                        else if (divisions.Count > 1)
                        {
                            // Select the division
                            DivisionAction(this, new DivisionActionEventArgs(divisions));
                        }

                        WindowAction(this, new WindowActionEventArgs(true));

                    }
                    else
                    {
                        // Display a login error message
                        LoginErrorMessage = UserContext.LoginErrorMessage;
                        //RaisePropertyChanged("LoginErrorMessage");
                    }
 
                });

            // If they've cancelled login, then shutdown the application
            OnCancelLogin = new DelegateCommand<object>(o => Application.Current.Shutdown());
        }
    }
}
