//-----------------------------------------------------------------------
// <copyright file="LinginViewModel.cs" company="Department of Veterans Affairs">
//     Copyright (c) vhaiswgraver, Department of Veterans Affairs. All rights reserved.
// </copyright>
//-----------------------------------------------------------------------
namespace ImagingClient.Infrastructure.ViewModels
{
    using System;
    using System.Linq;
    using ImagingClient.Infrastructure.Prism.Mvvm;
    using Microsoft.Practices.Prism.Commands;
    using ImagingClient.Infrastructure.UserDataSource;
    using System.Collections.ObjectModel;
    using ImagingClient.Infrastructure.User.Model;
    using VistaCommon.gov.va.med.Security;

    /// <summary>
    /// TODO: Provide summary section in the documentation header.
    /// </summary>
    public class LoginViewModel : ViewModel
    {
        public LoginViewModel(IUserDataSource userDataSource)
        {
            this.UserDataSource = userDataSource;
            LoginCommand = new DelegateCommand<VistACredentials>(o => Login(o));
            CancelCommand = new DelegateCommand<object>(o => Cancel());
        }

        protected IUserDataSource UserDataSource { get; set; }
        public DelegateCommand<VistACredentials> LoginCommand { get; set; }
        public DelegateCommand<object> CancelCommand { get; set; }
        public String AlertText { get; set; }
        public String LoginErrorMessage { get; set; }

        protected void Login(VistACredentials credentials)
        {
            AuthenticationResult result = UserDataSource.Authenticate(credentials);
            if (result.IsSuccessful)
            {
                ObservableCollection<Division> divisions = null; // UserDataSource.GetDivisionList(AccessCode);
                if (divisions.Count == 1)
                {
                    UserContext.UserCredentials.CurrentDivision = divisions[0];
                }
                else if (divisions.Count > 1)
                {
                    // Select the division
                    //DivisionAction(this, new DivisionActionEventArgs(divisions));
                }

                //WindowAction(this, new WindowActionEventArgs(true));

            }
            else
            {
                // Display a login error message
                LoginErrorMessage = UserContext.LoginErrorMessage;
                //RaisePropertyChanged("LoginErrorMessage");
            }
        }

        private void Cancel()
        {

        }
    }
}
