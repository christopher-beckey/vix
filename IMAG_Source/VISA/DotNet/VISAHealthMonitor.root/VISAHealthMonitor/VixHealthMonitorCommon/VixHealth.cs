using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;
using VISAHealthMonitorCommon;
using VISACommon;
using GalaSoft.MvvmLight.Messaging;
using VISAHealthMonitorCommon.messages;
using VISAHealthMonitorCommon.formattedvalues;

namespace VixHealthMonitorCommon
{
    public class VixHealth : BaseVixHealth
    {

        public string Active80808443Threads { get; private set; }
        public string ClinicalDisplayCounts { get; private set; }
        public string VistaRadCounts { get; private set; }
        public string ROI { get; private set; }
        public string ROIIcon { get; private set; }        

        public VixHealth(VisaHealth visaHealth, bool registerReceiveUpdatedHealthMessage)
            : base(visaHealth,registerReceiveUpdatedHealthMessage)
        {
            
        }

        public VixHealth(VisaHealth visaHealth)
            : base(visaHealth)
        {

        }

        public override void Update()
        {
            base.Update();
            if (VisaHealth.LoadStatus == VixHealthLoadStatus.loaded)
            {
                string active8080Threads = VisaHealth.GetPropertyValue("CatalinaThreadPoolThreadsBusy_http-8080_ThreadPool");
                if (active8080Threads == null)
                    active8080Threads = "?";
                string active8443Threads = VisaHealth.GetPropertyValue("CatalinaThreadPoolThreadsBusy_http-8443_ThreadPool");
                if (active8443Threads == null)
                    active8443Threads = "?";
                Active80808443Threads = active8080Threads + "/" + active8443Threads;

                // Clinical Display counts
                string cdMetadaCount = (GetClinicalDisplayMetadataRequestCount() >= 0 ? GetClinicalDisplayMetadataRequestCount().ToString(numberFormat) : "?");
                string cdImageV2Count = (GetClinicalDisplayImageServletRequestCount() >= 0 ? GetClinicalDisplayImageServletRequestCount().ToString(numberFormat) : "?");
                string cdImageV4Count = (GetClinicalDisplayImageServletV4RequestCount() >= 0 ? GetClinicalDisplayImageServletV4RequestCount().ToString(numberFormat) : "?");
                string cdImageV5Count = (GetClinicalDisplayImageServletV5RequestCount() >= 0 ? GetClinicalDisplayImageServletV5RequestCount().ToString(numberFormat) : "?");
                string cdImageV6Count = (GetClinicalDisplayImageServletV6RequestCount() >= 0 ? GetClinicalDisplayImageServletV6RequestCount().ToString(numberFormat) : "?");
                string cdImageV7Count = (GetClinicalDisplayImageServletV7RequestCount() >= 0 ? GetClinicalDisplayImageServletV7RequestCount().ToString(numberFormat) : "?");
                ClinicalDisplayCounts = cdMetadaCount + "/" + cdImageV2Count + "/" + cdImageV4Count + "/" + cdImageV5Count + "/" + cdImageV6Count + "/" + cdImageV7Count;

                // VistaRad counts
                string vrMetadaCount = (GetVistaRadMetadataRequestCount() >= 0 ? GetVistaRadMetadataRequestCount().ToString(numberFormat) : "?");
                string vrImageCount = (GetVistaRadExamImageServletRequestCount() >= 0 ? GetVistaRadExamImageServletRequestCount().ToString(numberFormat) : "?");
                string vrImageTextCount = (GetVistaRadExamImageTextFileServletRequestCount() >= 0 ? GetVistaRadExamImageTextFileServletRequestCount().ToString(numberFormat) : "?");
                VistaRadCounts = vrMetadaCount + "/" + vrImageCount + "/" + vrImageTextCount;

                // Releasse of Information (ROI) Details
                if (this.IsROISupported())
                {
                    this.ROI = this.ROIPeriodicProcessingEnabled + "/" + this.ROIProcessWorkItemsImmediately + "/" + this.ROICompletedItemsPurgeEnabled;

                    FormattedNumber disclosureRequests = VisaHealth.GetPropertyValueFormattedNumber("ROIDisclosureRequests");
                    FormattedNumber disclosureErrors = VisaHealth.GetPropertyValueFormattedNumber("ROIDisclosureProcessingErrors");
                    FormattedNumber disclosuresCompleted = VisaHealth.GetPropertyValueFormattedNumber("ROIDisclosuresCompleted");

                    this.ROI += "/" + disclosureRequests + "/" + disclosuresCompleted + "/" + disclosureErrors;

                    if (IsROISupportedAndDisabled())
                    {
                        ROIIcon = Icons.failed;
                    }
                    else
                    {
                        ROIIcon = Icons.passed;
                    }
                }
                else
                {
                    this.ROI = "";
                    ROIIcon = Icons.passed;
                }
            }
            else
            {
                Active80808443Threads = "";
                ClinicalDisplayCounts = "";
                VistaRadCounts = "";
                ROI = "";
                ROIIcon = Icons.passed;
            }
        }
    }
}
