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
namespace DicomImporter.Common.Model
{
    using System;
    using System.Collections.ObjectModel;
    using System.ComponentModel;
    using System.Globalization;
    using System.Xml.Serialization;

    using log4net;

    /// <summary>
    /// The order.
    /// </summary>
    [Serializable]
    public class Order : INotifyPropertyChanged
    {
        #region Constants and Fields

        /// <summary>
        /// The logger.
        /// </summary>
        private static readonly ILog Logger = LogManager.GetLogger(typeof(Order));

        #endregion

        #region Constructors and Destructors

        /// <summary>
        /// Initializes a new instance of the <see cref="Order"/> class.
        /// </summary>
        public Order()
        {
            this.ProcedureModifiers = new ObservableCollection<ProcedureModifier>();
        }

        #endregion

        #region Public Events

        /// <summary>
        /// The property changed event.
        /// The PropertyChanged event is raised by NotifyPropertyWeaver (http://code.google.com/p/notifypropertyweaver/)
        /// </summary>
        [field: NonSerialized]//P237 - Critical fix - Avoid  arbitrary code execution vulnerability on or after the deserialization of this class.
        public event PropertyChangedEventHandler PropertyChanged;


        //Begin-Get and set property notification in CreateNewRadiologyOrder screen-OITCOPondiS
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

        /// <summary>
        /// Gets or sets AccessionNumber.
        /// </summary>
        public string AccessionNumber { get; set; }

        /// <summary>
        /// Gets or sets CaseNumber.
        /// </summary>
        public string CaseNumber { get; set; }

        /// <summary>
        /// Gets or sets the credit method.
        /// </summary>
        public string CreditMethod { get; set; }

        /// <summary>
        /// Gets or sets Description.
        /// </summary>
        public string Description { get; set; }

        /// <summary>
        /// Gets or sets ExamDate.
        /// </summary>
        public string ExamDate { get; set; }

        /// <summary>
        /// Gets or sets ExamStatus.
        /// </summary>
        public string ExamStatus { get; set; }

        /// <summary>
        /// Gets or sets ExaminationsIen.
        /// </summary>
        public string ExaminationsIen { get; set; }

        /// <summary>
        /// Gets or sets Id.
        /// </summary>
        public int Id { get; set; }

        /// <summary>
        /// Gets or sets a value indicating whether the Order is to be 
        /// created in VistA. If true, a new Radiology order will be created.
        /// If false, the order already exists in VistA
        /// </summary>
        public bool IsToBeCreated { get; set; }

        /// <summary>
        /// Gets or sets Location.
        /// </summary>
        public string Location { get; set; }

        /// <summary>
        /// Gets or sets OrderDate.
        /// </summary>
        public string OrderDate { get; set; }

        /// <summary>
        /// Gets OrderDateAsDateTime.
        /// </summary>
        [XmlIgnore]
        public DateTime OrderDateAsDateTime
        {
            get
            {
                var orderDateTime = new DateTime(1800, 1, 1);

                try
                {
                    this.CleanUpTimePart();

                    CultureInfo provider = CultureInfo.CurrentCulture;
                    orderDateTime = DateTime.ParseExact(this.OrderDate, "MMM dd, yyyy@HH:mm:ss", provider);
                }
                catch (Exception e)
                {
                    //BEGIN-Fortify Mitigation recommendation for Log Forging.Code writes unvalidated user input to the log.Logged other details without by passing the actual issue reported by tool.(p289-OITCOPondiS)
                    Logger.Error("Error parsing Order DateTime - " + e.Message);
                    //Logger.Error("Error parsing Order DateTime: " + this.OrderDate + " - " + e.Message);
                    //END
                }

                return orderDateTime;
            }
        }

        /// <summary>
        /// Gets or sets OrderReason.
        /// </summary>
        public string OrderReason { get; set; }

        /// <summary>
        /// Gets or sets OrderingLocation.
        /// </summary>
        public OrderingLocation OrderingLocation { get; set; }

        /// <summary>
        /// Gets or sets OrderingLocationIen.
        /// </summary>
        public int OrderingLocationIen { get; set; }

        /// <summary>
        /// Gets or sets OrderingProvider.
        /// </summary>
        public OrderingProvider OrderingProvider { get; set; }

        /// <summary>
        /// Gets or sets OrderingProviderIen.
        /// </summary>
        public int OrderingProviderIen { get; set; }

        /// <summary>
        /// Gets or sets Procedure.
        /// </summary>
        public Procedure Procedure { get; set; }

        /// <summary>
        /// Gets or sets ProcedureId.
        /// </summary>
        public int ProcedureId { get; set; }

        /// <summary>
        /// Gets or sets ProcedureModifiers.
        /// </summary>
        public ObservableCollection<ProcedureModifier> ProcedureModifiers { get; set; }

        /// <summary>
        /// Gets or sets ProcedureName.
        /// </summary>
        public string ProcedureName { get; set; }

        /// <summary>
        /// Gets or sets Reconciliation.
        /// </summary>
        public Reconciliation Reconciliation { get; set; }

        /// <summary>
        /// Gets or sets RegisteredExamsIen.
        /// </summary>
        public string RegisteredExamsIen { get; set; }

        /// <summary>
        /// Gets or sets Specialty.
        /// </summary>
        public string Specialty { get; set; }

        //Begin-Get and set property notification in CreateNewRadiologyOrder screen-OITCOPondiS
        private StatusChangeDetails _StatusChangeDetails { get; set; }


        /// <summary>
        /// Gets or sets the status change details.
        /// </summary>
        //public StatusChangeDetails StatusChangeDetails { get; set; }
        public StatusChangeDetails StatusChangeDetails
        {
            get { return _StatusChangeDetails; }
            set
            {

                _StatusChangeDetails = value;
                this.RaisePropertyChanged("StatusChangeDetails");
            }

        }

        //End-OITCOPondiS


        /// <summary>
        /// Gets or sets the vista generated study uid.
        /// </summary>
        public String VistaGeneratedStudyUid { get; set; }

        #endregion

        #region Public Methods

        /// <summary>
        /// The specialized equals method
        /// </summary>
        /// <param name="other">
        /// The other Order to compare to.
        /// </param>
        /// <returns>
        /// Whether or not the objects are equal
        /// </returns>
        public bool Equals(Order other)
        {
            if (ReferenceEquals(null, other))
            {
                return false;
            }

            if (ReferenceEquals(this, other))
            {
                return true;
            }

            return other.Id == this.Id && Equals(other.AccessionNumber, this.AccessionNumber)
                   && Equals(other.Specialty, this.Specialty);
        }

        /// <summary>
        /// Determines whether the specified <see cref="System.Object"/> is equal to this instance.
        /// </summary>
        /// <param name="obj">The <see cref="System.Object"/> to compare with this instance.</param>
        /// <returns>
        ///   <c>true</c> if the specified <see cref="System.Object"/> is equal to this instance; otherwise, <c>false</c>.
        /// </returns>
        public override bool Equals(object obj)
        {
            if (ReferenceEquals(null, obj))
            {
                return false;
            }

            if (ReferenceEquals(this, obj))
            {
                return true;
            }

            if (obj.GetType() != typeof(Order))
            {
                return false;
            }

            return this.Equals((Order)obj);
        }

        /// <summary>
        /// Returns a hash code for this instance.
        /// </summary>
        /// <returns>
        /// A hash code for this instance, suitable for use in hashing algorithms and data structures like a hash table. 
        /// </returns>
        public override int GetHashCode()
        {
            unchecked
            {
                int result = this.Id;
                if (this.AccessionNumber != null)
                {
                    result = (result * 397) ^ this.AccessionNumber.GetHashCode();
                }

                if (this.Specialty != null)
                {
                    result = (result * 397) ^ this.Specialty.GetHashCode();
                }

                return result;
            }
        }

        #endregion

        #region Methods

        /// <summary>
        /// Helper method to add a valid time to the order date if one is missing or
        /// invalid. If invalid, the time is set to one second after midnight.
        /// </summary>
        private void CleanUpTimePart()
        {
            // See if seconds are present, and add them if not...
            if (!this.OrderDate.Contains("@"))
            {
                // No time at all. Add it
                this.OrderDate = this.OrderDate + "@00:00:01";
            }
            else
            {
                // The @ delimiter is present. Get the second piece, which is the time
                string time = this.OrderDate.Split('@')[1];
                if (string.IsNullOrEmpty(time))
                {
                    // No time at all. Add it
                    this.OrderDate = this.OrderDate + "00:00:01";
                }
                else if (time.Length == 5)
                {
                    this.OrderDate = this.OrderDate + ":01";
                }
                else if (time.Length == 6)
                {
                    this.OrderDate = this.OrderDate + "01";
                }
            }
        }

        #endregion
    }
}