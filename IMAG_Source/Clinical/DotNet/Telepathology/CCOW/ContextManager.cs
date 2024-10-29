/**
 * 
 * Package: MAG - VistA Imaging
 * WARNING: Per VHA Directive 2004-038, this routine should not be modified.
 * Date Created: 4/11/2012
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

namespace VistA.Imaging.Telepathology.CCOW
{
    using System;
    using System.Collections.Generic;
    using System.Linq;
    using System.Text;
    using VERGENCECONTEXTORLib;
    using VistA.Imaging.Telepathology.Common.Model;
    using System.ComponentModel;

    public class ContextManager : IContextManager
    {
        public string ApplicationLabel { get; set; }

        public string Passcode { get; set; }

        public string SiteID { get; set; }

        public bool ProductionAccount { get; set; }

        public Contextor Contextor { get; set; }

        public ContextState ContextState { get; private set; }

        public ContextData CurrentContext { get; set; }

        public bool IsBusy { get; set; }

        public string BusyReason { get; set; }

        /// <remarks>
        /// The PropertyChanged event is raised by NotifyPropertyWeaver (http://code.google.com/p/notifypropertyweaver/)
        /// </remarks>
        /// <summary>
        /// Event to be raised when a property is changed
        /// </summary>
#pragma warning disable 0067
        // Warning disabled because the event is raised by NotifyPropertyWeaver (http://code.google.com/p/notifypropertyweaver/)
        public event PropertyChangedEventHandler PropertyChanged;
#pragma warning restore 0067

        public ContextManager()
        {
            this.ProductionAccount = false;
            this.ContextState = ContextState.None;
            this.CurrentContext = new ContextData();
        }

        public void Run()
        {
            try
            {
                // initialize contextor 
                if ((this.ContextState == ContextState.None) && (this.Contextor != null))
                {
                    // setup event handlers
                    this.Contextor.Pending += new _IContextChangesSink_PendingEventHandler(Contextor_Pending);
                    this.Contextor.Committed += new _IContextChangesSink_CommittedEventHandler(Contextor_Committed);
                    this.Contextor.Canceled += new _IContextChangesSink_CanceledEventHandler(Contextor_Canceled);

                    this.ContextState = ContextState.Initialized;
                }

                if (this.ContextState == ContextState.Initialized)
                {
                    this.ContextState = ContextState.Participating;
                }

                if (PropertyChanged != null)
                {
                    PropertyChanged(this, new PropertyChangedEventArgs("ContextState"));
                }
            }
            catch (Exception)
            {

            }
        }

        public void Close()
        {
            this.ContextState = ContextState.None;
            this.CurrentContext = null;
            this.Contextor = null;
        }

        void Contextor_Canceled()
        {
            Console.WriteLine("Contextor_Canceled");
        }

        void Contextor_Committed()
        {
            Console.WriteLine("Contextor_Committed");

            ContextData committedContext = new ContextData(this.Contextor.CurrentContext);
            if (!committedContext.IsEqual(this.CurrentContext))
            {
                // does not match
                Suspend();
            }
        }

        void Contextor_Pending(object aContextItemCollection)
        {
            Console.WriteLine("Contextor_Pending");
            ContextData proposedContext = new ContextData((IContextItemCollection)aContextItemCollection);

            if (proposedContext.IsEqual(this.CurrentContext))
            {
                // same as current context
                //this.Contextor.SetSurveyResponse("");
            }
            else
            {
                if (this.IsBusy)
                {
                    string reason = string.IsNullOrEmpty(this.BusyReason) ? "Application is busy." : this.BusyReason;

                    // application is busy and cannot handle context change
                    this.Contextor.SetSurveyResponse(reason);
                }
                else
                {
                    // simply copy the context. Current we do not anything in the UI to show patient context
                    this.CurrentContext.Clear();
                    //this.Contextor.SetSurveyResponse("");
                }
            }
        }

        public void Suspend()
        {
            if (this.ContextState == ContextState.Participating)
            {
                this.Contextor.Suspend();

                this.ContextState = ContextState.Suspended;

                this.CurrentContext.Clear();

                if (PropertyChanged != null)
                {
                    PropertyChanged(this, new PropertyChangedEventArgs("ContextState"));
                }
            }
        }

        public void Resume()
        {
            if (this.ContextState == ContextState.Suspended)
            {
                this.Contextor.Resume();

                this.ContextState = ContextState.Participating;

                if (PropertyChanged != null)
                {
                    PropertyChanged(this, new PropertyChangedEventArgs("ContextState"));
                }
            }
        }

        public void ResumeSet(Object context)
        {
            throw new NotImplementedException();
        }

        public void ResumeGet()
        {
            throw new NotImplementedException();
        }

        public void SetCurrentPatient(Patient patient)
        {
            if (this.ContextState == ContextState.Participating)
            {
                ContextData proposedContext = new ContextData(patient);

                if (!this.CurrentContext.IsEqual(proposedContext))
                {
                    // set as new context
                    this.CurrentContext = proposedContext;
                    ContextItemCollection contextItemCollection = this.CurrentContext.GetContextCollection();

                    try
                    {
                        this.Contextor.StartContextChange();

                        // todo add hook, to bring window to top

                        UserResponse userResponse = this.Contextor.EndContextChange(true, contextItemCollection);

                        switch (userResponse)
                        {
                            case UserResponse.UrCommit:
                                // linked
                                break;

                            case UserResponse.UrCancel:
                            case UserResponse.UrBreak:
                                // proposed context cancelled or broken. the app must remain at current context

                                Suspend();

                                break;
                        }
                    }
                    catch (Exception ex)
                    {
                        Suspend();
                    }
                }
                else
                {

                }
            }
        }

        public PatientContextState GetPatientContextState(Patient patient)
        {
            PatientContextState state = PatientContextState.Broken;

            if (this.ContextState == ContextState.Participating)
            {
                if (this.CurrentContext.IsEqual(new ContextData(patient)))
                {
                    state = PatientContextState.Linked;
                }
            }

            return state;
        }

        
    }
}
