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
namespace ImagingClient.Infrastructure.ViewModels
{
    using System.ComponentModel;
    using ImagingClient.Infrastructure.Events;
    using Microsoft.Practices.Prism.Events;
    using Microsoft.Practices.ServiceLocation;

    /// <summary>
    /// The progress view model.
    /// </summary>
    public class ProgressViewModel : INotifyPropertyChanged
    {
        // The PropertyChanged event is raised by NotifyPropertyWeaver (http://code.google.com/p/notifypropertyweaver/)
        #region Constants and Fields


        //Begin-Get and set  property notification in MediaStagingView screen-OITCOPondiS
        /// <summary>
        /// The is work in progress.
        /// </summary>
        //private bool isWorkInProgress;
        private bool isWorkInProgress { get; set; }

        //End-OITCOPondiS



        /// <summary>
        /// The event aggregator
        /// </summary>
        private IEventAggregator eventAggregator;


        //Get and Set  property notification for all private  variables-OITCOPondiS
        private string _Text { get; set; }
        private bool _IsIndeterminate { get; set; }
        private int _Maximum { get; set; }
        private int _Minimum { get; set; }
        private int _Value { get; set; }

        #endregion

        #region Public Events

        /// <summary>
        /// The property changed.
        /// </summary>
        public event PropertyChangedEventHandler PropertyChanged;



        //Begin-Get and set property notification in MediaStagingView screen-OITCOPondiS
        /// <summary>
        /// The raise property changed.
        /// </summary>
        /// <param name="propertyName">
        /// The property name.
        /// </param>
        protected void RaisePropertyChanged(string propertyName)
        {
            PropertyChangedEventHandler handler = this.PropertyChanged;
            if (handler != null)
            {
                handler.Invoke(this, new PropertyChangedEventArgs(propertyName));
            }
        }
        //End-OITCOPondiS


        #endregion

        #region Public Properties
        //Get and Set  property notification for all public variables-OITCOPondiS
        /// <summary>
        /// Gets or sets a value indicating whether IsIndeterminate.
        /// </summary>
        //public bool IsIndeterminate { get; set; }

        public bool IsIndeterminate
        {
            get { return _IsIndeterminate; }
            set
            {
                _IsIndeterminate = value;
                this.RaisePropertyChanged("IsIndeterminate");
            }
        }



        /// <summary>
        /// Gets or sets a value indicating whether IsWorkInProgress.
        /// </summary>
        public bool IsWorkInProgress
        {
            get
            {
                return this.isWorkInProgress;
            }

            set
            {
                this.Value = 0;
                this.isWorkInProgress = value;
                /*COMMENTING
                PropertyChangedEventHandler handler = this.PropertyChanged;
                if (handler != null)
                {
                    handler.Invoke(this, new PropertyChangedEventArgs("IsWorkInProgress"));
                }
                */
                if (this.eventAggregator == null)
                {
                    this.eventAggregator = ServiceLocator.Current.GetInstance<IEventAggregator>();
                }

                // notifies the rest of the system that work is or isnt being done.
                this.eventAggregator.GetEvent<IsWorkInProgressEvent>().Publish(this.isWorkInProgress);
                
                //Fix property notification in MediaStagingView screen-OITCOPondiS
                this.RaisePropertyChanged("IsWorkInProgress");
               
            }
        }

        /// <summary>
        /// Gets or sets Maximum.
        /// </summary>
        //public int Maximum { get; set; }
        public int Maximum
        {
            get { return _Maximum; }
            set
            {
                _Maximum = value;
                this.RaisePropertyChanged("Maximum");
            }
        }

        /// <summary>
        /// Gets or sets Minimum.
        /// </summary>
        //public int Minimum { get; set; }
        public int Minimum
        {
            get { return _Minimum; }
            set
            {
                _Minimum = value;
                this.RaisePropertyChanged("Minimum");
            }
        }
        /// <summary>
        /// Gets or sets Text.
        /// </summary>
        //public string Text { get; set; }

        public string Text
        {
            get { return _Text; }
            set
            {
                _Text = value;
                this.RaisePropertyChanged("Text");
            }
        }
        /// <summary>
        /// Gets or sets Value.
        /// </summary>
        //public int Value { get; set; }
        public int Value
        {
            get { return _Value; }
            set
            {
                _Value = value;
                this.RaisePropertyChanged("Value");
            }
        }
        #endregion
    }
}