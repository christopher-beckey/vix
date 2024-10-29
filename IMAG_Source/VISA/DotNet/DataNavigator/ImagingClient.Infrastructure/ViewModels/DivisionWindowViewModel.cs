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
    public class DivisionWindowViewModel : ImagingViewModel
    {
        public delegate void WindowActionEventHandler(object sender, WindowActionEventArgs e);
        public event WindowActionEventHandler WindowAction;

        public DelegateCommand<object> OnSelectDivision { get; set; }
        public DelegateCommand<object> OnCancelSelectDivision { get; set; }

        public ObservableCollection<Division> Divisions { get; set; }

        private Division selectedDivision;
        public Division SelectedDivision
        {
            get { return selectedDivision; }
            set 
            { 
                selectedDivision = value;
                OnSelectDivision.RaiseCanExecuteChanged();
                OnCancelSelectDivision.RaiseCanExecuteChanged();
            }
        }

        public DivisionWindowViewModel(ObservableCollection<Division> divisions)
        {
            Divisions = divisions;

            // Handle Login attempt
            OnSelectDivision = new DelegateCommand<object>(
                o =>
                    {
                        UserContext.UserCredentials.CurrentDivision = SelectedDivision;
                        WindowAction(this, new WindowActionEventArgs(true));
                    },
                o => SelectedDivision != null);

            // If they've cancelled login, then shutdown the application
            OnCancelSelectDivision = new DelegateCommand<object>(o => Application.Current.Shutdown());
        }
    }
}
