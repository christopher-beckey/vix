// -----------------------------------------------------------------------
// <copyright file="ServiceGroupInfoDatasource.cs" company="Department of Veterans Affairs">
// TODO: Update copyright text.
// </copyright>
// -----------------------------------------------------------------------

namespace VistA.Imaging.DataSources
{
    using System;
    using System.Collections.Generic;
    using System.Linq;
    using System.Net;
    using System.Xml.Linq;
    using VistA.Imaging;
    using VistA.Imaging.ComponentModel;
    using VistA.Imaging.Models;

    /// <summary>
    /// TODO: Update summary.
    /// </summary>
    public class ServiceGroupInfoDatasource : CachingDataSource<ServiceGroupInfo, string>, IServiceGroupInfoDatasource
    {
        /// <summary>
        /// The path to the IDS version service
        /// </summary>
        private static string idsPath = "IDSWebApp/VersionsService";

        /// <summary>
        /// Occurs when GetBySiteConnectionInfo completed.
        /// </summary>
        public event EventHandler<AsyncCompletedEventArgs<IEnumerable<ServiceGroupInfo>>> GetBySiteConnectionInfoCompleted;

        /// <summary>
        /// Gets the ServiceTypeInfo by site connection info asynchronously.
        /// </summary>
        /// <param name="siteConnectionInfo">The site connection info.</param>
        /// <param name="userState">State of the user.</param>
        public void GetBySiteConnectionInfoAsync(SiteConnectionInfo siteConnectionInfo, object userState = null)
        {
            Uri idsUrl = new Uri(siteConnectionInfo.VixUri, idsPath);
            WebClient client = new WebClient();
            client.DownloadStringCompleted += new DownloadStringCompletedEventHandler(this.GetBySiteConnectionInfoAsync_DownloadStringCompleted);
            client.DownloadStringAsync(idsUrl, userState);
        }

        /// <summary>
        /// Handles the DownloadStringCompleted event of the GetBySiteConnectionInfoAsync control.
        /// </summary>
        /// <param name="sender">The source of the event.</param>
        /// <param name="e">The <see cref="System.Net.DownloadStringCompletedEventArgs"/> instance containing the event data.</param>
        private void GetBySiteConnectionInfoAsync_DownloadStringCompleted(object sender, DownloadStringCompletedEventArgs e)
        {
            List<ServiceGroupInfo> services = null;
            if (!e.Cancelled && e.Error == null)
            {
                XDocument doc = XDocument.Parse(e.Result);
                IEnumerable<string> serviceTypesNames = doc.Root.Elements("Service").Select(svc => svc.Attribute("type").Value).Distinct();
                services = new List<ServiceGroupInfo>();
                ServiceGroupInfo currentServiceGroup;
                ServiceGroupVersionInfo currentGroupVersion;
                ServiceEndpointInfo currentEndpoint;
                foreach (string serviceGroupName in serviceTypesNames)
                {
                    currentServiceGroup = new ServiceGroupInfo() { ServiceType = serviceGroupName };
                    services.Add(currentServiceGroup);
                    foreach (XElement serviceElement in doc.Root.Elements("Service").Where(svc => svc.Attribute("type").Value.Equals(serviceGroupName)))
                    {
                        currentGroupVersion = new ServiceGroupVersionInfo()
                        {
                            Version = int.Parse(serviceElement.Attribute("version").Value),
                            Path = serviceElement.Element("ApplicationPath").Value
                        };
                        currentServiceGroup.Versions.Add(currentGroupVersion.Version, currentGroupVersion);
                        foreach (XElement operationElement in serviceElement.Elements("Operation"))
                        {
                            currentEndpoint = new ServiceEndpointInfo()
                            {
                                OperationType = operationElement.Attribute("type").Value,
                                Path = operationElement.Element("OperationPath").Value
                            };
                            currentGroupVersion.Endpoints.Add(currentEndpoint.OperationType, currentEndpoint);
                        }
                    }
                }
            }

            this.GetBySiteConnectionInfoCompleted.SafelyRaise(this, new AsyncCompletedEventArgs<IEnumerable<ServiceGroupInfo>>(services, e.Error, e.Cancelled, e.UserState));
        }
    }
}
