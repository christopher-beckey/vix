// -----------------------------------------------------------------------
// <copyright file="ConfiguratorDatasource.cs" company="Department of Veterans Affairs">
//  Package: MAG - VistA Imaging
//  WARNING: Per VHA Directive 2004-038, this routine should not be modified.
//  Date Created: April 2012
//  Site Name:  Washington OI Field Office, Silver Spring, MD
//  Developer: Duc Nguyen
//  Description: Implementation for the configurator datasource interface
//        ;; +--------------------------------------------------------------------+
//        ;; Property of the US Government.
//        ;; No permission to copy or redistribute this software is given.
//        ;; Use of unreleased versions of this software requires the user
//        ;;  to execute a written test agreement with the VistA Imaging
//        ;;  Development Office of the Department of Veterans Affairs,
//        ;;  telephone (301) 734-0100.
//        ;;
//        ;; The Food and Drug Administration classifies this software as
//        ;; a Class II medical device.  As such, it may not be changed
//        ;; in any way.  Modifications to this software may result in an
//        ;; adulterated medical device under 21CFR820, the use of which
//        ;; is considered to be a violation of US Federal Statutes.
//        ;; +--------------------------------------------------------------------+
// </copyright>
           
namespace VistA.Imaging.Telepathology.Configurator.DataSource
{
    using System.Collections.Generic;
    using System.IO;
    using System.Windows;
    using VistA.Imaging.Telepathology.Common.Model;
    using VistA.Imaging.Telepathology.Communication;
    using System.Collections.ObjectModel;
    using VistA.Imaging.Telepathology.Common.VixModels;

    public class ConfiguratorDatasource : IConfiguratorDatasource
    {
        private IVistAClient vistaClient;
        
        public ConfiguratorDatasource()
        {
            vistaClient = new VistAClient();
        }

        public void InitializeConnection()
        {
            vistaClient.InitializeConnection();
        }

        public void CloseConnection()
        {
            vistaClient.Close();
        }

        public void GetMagSecurityKeys()
        {
            vistaClient.GetMagSecurityKeys();
        }

        public bool IsPrimarySiteValid(string stationNumber)
        {
            return vistaClient.IsPrimarySiteValid(stationNumber);
        }

        public ObservableCollection<SiteInfo> GetInstitutionList()
        {
            return vistaClient.GetInstitutionList();
        }

        public AcquisitionSiteList GetAcquisitionSites(string siteID)
        {
            return vistaClient.GetAcquisitionSites(siteID);
        }

        public ReadingSiteList GetReadingSites(string siteID)
        {
            return vistaClient.GetReadingSites(siteID);
        }

        public void SaveReadingSite(PathologyReadingSiteType readingSite)
        {
            vistaClient.SaveReadingSite(UserContext.LocalSite.PrimarySiteStationNUmber, readingSite);
        }

        public void RemoveReadingSite(PathologyReadingSiteType readingSite)
        {
            vistaClient.RemoveReadingSite(UserContext.LocalSite.PrimarySiteStationNUmber, readingSite);
        }

        public void SaveAcquisitionSite(PathologyAcquisitionSiteType acquisitionSite)
        {
            vistaClient.SaveAcquisitionSite(UserContext.LocalSite.PrimarySiteStationNUmber, acquisitionSite);
        }

        public void RemoveAcquisitionSite(PathologyAcquisitionSiteType acquisitionSite)
        {
            vistaClient.RemoveAcquisitionSite(UserContext.LocalSite.PrimarySiteStationNUmber, acquisitionSite);
        }

        public void SaveReportTemplate(VixReportTemplateObject templateObj)
        {
            vistaClient.SaveReportTemplate(templateObj);
        }

        public ObservableCollection<ReportTemplate> GetReportTemplates(string siteID)
        {
            return vistaClient.GetReportTemplates(siteID);
        }

        public bool CheckPendingConsultation(string acquisitionSiteID, string readingSiteID)
        {
            return vistaClient.CheckPendingConsultation(acquisitionSiteID, readingSiteID);
        }

        public string GetReportLockTimeoutHour(string siteID)
        {
            return vistaClient.GetReportLockTimeoutHour(siteID);
        }

        public void SetReportLockTimeoutHour(string siteID, string hours)
        {
            vistaClient.SetReportLockTimeoutHour(siteID, hours);
        }

        public int GetApplicationTimeout()
        {
            return vistaClient.GetApplicationTimeout();
        }

        public void SetApplicationTimeout(int duration)
        {
            vistaClient.SetApplicationTimeout(duration);
        }

        public int GetRetentionDays()
        {
            return vistaClient.GetRetentionDays();
        }

        public void SetRetentionDays(int days)
        {
            vistaClient.SetRetentionDays(days);
        }

        public bool IsSiteSupportTelepathology(string SiteStationNumber)
        {
            return vistaClient.IsSiteSupportTelepathology(SiteStationNumber);
        }
    }
}
