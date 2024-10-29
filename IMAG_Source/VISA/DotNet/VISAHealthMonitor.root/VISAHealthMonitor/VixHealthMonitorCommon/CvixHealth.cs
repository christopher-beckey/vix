using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;
using VISAHealthMonitorCommon;
using VISAHealthMonitorCommon.formattedvalues;
using System.ComponentModel;
using VISAHealthMonitorCommon.certificates;

namespace VixHealthMonitorCommon
{
    public class CvixHealth : BaseVixHealth,  INotifyPropertyChanged
    {
        public string Active808443443Threads { get; private set; }
        public string AwivCounts { get; private set; }
        public string XcaCounts { get; private set; }
        public string DoDCounts { get; private set; }
        public FormattedNumber JavaThreadCount { get; private set; }
        


        public CvixHealth(VisaHealth visaHealth, bool registerReceiveUpdatedHealthMessage)
            : base(visaHealth, registerReceiveUpdatedHealthMessage)
        {

        }

        public CvixHealth(VisaHealth visaHealth)
            : base(visaHealth)
        {

        }

        public override void Update()
        {
            base.Update();
            if (VisaHealth.LoadStatus == VixHealthLoadStatus.loaded)
            {
                string active80Threads = VisaHealth.GetPropertyValue("CatalinaThreadPoolThreadsBusy_http-80_ThreadPool");
                if (active80Threads == null)
                    active80Threads = "?";
                string active8443Threads = VisaHealth.GetPropertyValue("CatalinaThreadPoolThreadsBusy_http-8443_ThreadPool");
                if (active8443Threads == null)
                    active8443Threads = "?";
                string active443Threads = VisaHealth.GetPropertyValue("CatalinaThreadPoolThreadsBusy_http-443_ThreadPool");
                if (active443Threads == null)
                    active443Threads = "?";
                Active808443443Threads = active80Threads + "/" + active8443Threads + "/" + active443Threads;

                // AWIV counts
                string awivMetadaCount = (GetAWIVMetadataRequestCount() >= 0 ? GetAWIVMetadataRequestCount().ToString(numberFormat) : "?");
                string awivImageCount = (GetAWIVImageRequestCount() >= 0 ? GetAWIVImageRequestCount().ToString(numberFormat) : "?");
                string awivPhotoCount = (GetAWIVPhotoIDRequestCount() >= 0 ? GetAWIVPhotoIDRequestCount().ToString(numberFormat) : "?");
                string awivImageCountV2 = (GetAWIVImageV2RequestCount() >= 0 ? GetAWIVImageV2RequestCount().ToString(numberFormat) : "?");
                string awivPhotoCountV2 = (GetAWIVPhotoIDV2RequestCount() >= 0 ? GetAWIVPhotoIDV2RequestCount().ToString(numberFormat) : "?");
                AwivCounts = awivMetadaCount + "/" + awivImageCount + "/" + awivPhotoCount + "/" + awivImageCountV2 + "/" + awivPhotoCountV2;

                // Xca Counts
                XcaCounts = (GetXCARequestCount() >= 0 ? GetXCARequestCount().ToString(numberFormat) : "?");

                string dodPatientArtifactRequests = (GetTotalDoDPatientArtifactRequests() >= 0 ? GetTotalDoDPatientArtifactRequests().ToString(numberFormat) : "?");
                string dodExamRequests = (GetTotalDoDExamRequests() >= 0 ? GetTotalDoDExamRequests().ToString(numberFormat) : "?");
                string nonCorrelatedPatientArtifactRequests = (GetNonCorrelatedDoDPatientArtifactRequests() >= 0 ? GetNonCorrelatedDoDPatientArtifactRequests().ToString(numberFormat) : "?"); 
                string nonCorrelatedDodExamRequests = (GetNonCorrelatedDoDExamRequests() >= 0 ? GetNonCorrelatedDoDExamRequests().ToString(numberFormat) : "?");
                DoDCounts = dodPatientArtifactRequests + "/" + nonCorrelatedPatientArtifactRequests + "/" + dodExamRequests + "/" + nonCorrelatedDodExamRequests;

                JavaThreadCount = VisaHealth.GetPropertyValueFormattedNumber("JavaThreadCount");

                string certificateExpirationDate = null;
                if (this.VisaHealth.ExternalValues.ContainsKey("CertificateExpiration"))
                {
                    // use this value
                    certificateExpirationDate = this.VisaHealth.ExternalValues["CertificateExpiration"];
                }
                else
                {
                    certificateExpirationDate = CertificateHelper.GetCertificateExpirationDate(this.VisaHealth.VisaSource);
                    this.VisaHealth.ExternalValues.Add("CertificateExpiration", certificateExpirationDate);
                }

                if (certificateExpirationDate != null)
                {
                    CertificateExpirationDate = new FormattedDate(DateTime.Parse(certificateExpirationDate).Ticks, true);
                    if (IsCertificateValid())
                        CertificateExpiredIcon = Icons.passed;
                    else
                        CertificateExpiredIcon = Icons.failed;
                }
                else
                {
                    CertificateExpirationDate = FormattedDate.UnknownFormattedDate;
                    CertificateExpiredIcon = Icons.unknown;
                }
            }
            else
            {
                AwivCounts = "";
                XcaCounts = "";
                DoDCounts = "";
                Active808443443Threads = "";
                JavaThreadCount = FormattedNumber.UnknownFormattedNumber;
                CertificateExpirationDate = FormattedDate.UnknownFormattedDate;
                CertificateExpiredIcon = Icons.unknown;
            }
        }

        private bool IsCertificateValid()
        {
            if (CertificateExpirationDate != null && CertificateExpirationDate.IsValueSet)
            {
                DateTime date = new DateTime(CertificateExpirationDate.Ticks);
                DateTime now = DateTime.Now;
                if (date.CompareTo(now) <= 0)
                    return false;
            }
            return true;
        }


        public override bool IsHealthy()
        {
            bool baseHealthy = base.IsHealthy();
            if (!baseHealthy)
                return false;
            return IsCertificateValid();
        }
    
    }
}
