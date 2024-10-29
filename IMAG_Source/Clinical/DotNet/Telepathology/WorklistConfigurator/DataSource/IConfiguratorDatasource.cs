// -----------------------------------------------------------------------
// <copyright file="IConfiguratorDatasource.cs" company="Department of Veterans Affairs">
//  Package: MAG - VistA Imaging
//  WARNING: Per VHA Directive 2004-038, this routine should not be modified.
//  Date Created: April 2012
//  Site Name:  Washington OI Field Office, Silver Spring, MD
//  Developer: Duc Nguyen
//  Description: Interface for the configurator datasource
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
// -----------------------------------------------------------------------

namespace VistA.Imaging.Telepathology.Configurator.DataSource
{
    using System;
    using System.Collections.Generic;
    using System.Collections.ObjectModel;
    using System.Linq;
    using System.Text;
    using VistA.Imaging.Telepathology.Common.Model;
    using VistA.Imaging.Telepathology.Common.VixModels;

    /// <summary>
    /// Configurator Datasource Interface
    /// </summary>
    public interface IConfiguratorDatasource
    {
        void InitializeConnection();

        void CloseConnection();

        void GetMagSecurityKeys();

        int GetApplicationTimeout();

        void SetApplicationTimeout(int duration);

        int GetRetentionDays();

        void SetRetentionDays(int days);

        bool IsPrimarySiteValid(string stationNumber);

        ObservableCollection<SiteInfo> GetInstitutionList();

        void SaveReadingSite(PathologyReadingSiteType readingSite);

        void RemoveReadingSite(PathologyReadingSiteType readingSite);

        void SaveAcquisitionSite(PathologyAcquisitionSiteType acquisitionSite);

        void RemoveAcquisitionSite(PathologyAcquisitionSiteType acquisitionSite);

        AcquisitionSiteList GetAcquisitionSites(string siteID);

        ReadingSiteList GetReadingSites(string siteID);

        void SaveReportTemplate(VixReportTemplateObject templateObj);

        ObservableCollection<ReportTemplate> GetReportTemplates(string siteID);

        bool CheckPendingConsultation(string acquisitionSiteID, string readingSiteID);

        string GetReportLockTimeoutHour(string siteID);

        void SetReportLockTimeoutHour(string siteID, string hours);

        bool IsSiteSupportTelepathology(string SiteStationNumber);
    }
}
