/**
 * 
 * Package: MAG - VistA Imaging
 * WARNING: Per VHA Directive 2004-038, this routine should not be modified.
 * Date Created: 1/9/2012
 * Site Name:  Washington OI Field Office, Silver Spring, MD
 * Developer:  Paul Pentapaty
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
 * 
 */

using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;
using GalaSoft.MvvmLight;
using GalaSoft.MvvmLight.Command;
using System.Windows.Input;
using System.ComponentModel;

namespace VistA.Imaging.Telepathology.Worklist.ViewModel
{
    public abstract class WorkspaceViewModel : ViewModelBase, IChangeTracking
    {
        RelayCommand _closeCommand;
        public ICommand CloseCommand
        {
            get
            {
                if (_closeCommand == null)
                {
                    _closeCommand = new RelayCommand(
                        () => Close(),
                        () => CanClose()
                        );
                }
                return _closeCommand;
            }
        }

        RelayCommand _cancelCommand;
        public ICommand CancelCommand
        {
            get
            {
                if (_cancelCommand == null)
                {
                    _cancelCommand = new RelayCommand(
                        () => Cancel(),
                        () => CanCancel()
                        );
                }
                return _cancelCommand;
            }
        }

        public event Action RequestClose;

        public event Action RequestCancel;

        public virtual void Close()
        {
            if (RequestClose != null)
            {
                RequestClose();
            }
        }

        public virtual void Cancel()
        {
            if (RequestCancel != null)
            {
                RequestCancel();
            }
        }

        public virtual bool CanClose()
        {
            return true;
        }

        public virtual bool CanCancel()
        {
            return true;
        }

        protected WorkspaceViewModel()
        {
            this.PropertyChanged += new PropertyChangedEventHandler(OnNotifiedOfPropertyChanged);
        }

        private void OnNotifiedOfPropertyChanged(object sender, PropertyChangedEventArgs e)
        {
            if (e != null && !String.Equals(e.PropertyName, "IsChanged", StringComparison.Ordinal))
            {
                this.IsChanged = true;
            }
        }

        public bool IsChanged
        {
            get
            {
                lock (_notifyingObjectIsChangedSyncRoot)
                {
                    return _notifyingObjectIsChanged;
                }
            }

            protected set
            {
                lock (_notifyingObjectIsChangedSyncRoot)
                {
                    if (!Boolean.Equals(_notifyingObjectIsChanged, value))
                    {
                        _notifyingObjectIsChanged = value;

                        RaisePropertyChanged("IsChanged");
                    }
                }
            }
        }
    
        private bool _notifyingObjectIsChanged;
        private readonly object _notifyingObjectIsChangedSyncRoot = new Object();

        public void AcceptChanges()
        {
            this.IsChanged = false;
        }
    }
}
