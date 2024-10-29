// -----------------------------------------------------------------------
// <copyright file="SiteConnectionInfoFacade.cs" company="Department of Veterans Affairs">
// TODO: Update copyright text.
// </copyright>
// -----------------------------------------------------------------------

namespace VistA.Imaging.Facades
{
    using System;
    using System.Collections.Generic;
    using System.Linq;
    using System.Text;
    using NLog;
    using VistA.Imaging.ComponentModel;
    using VistA.Imaging.DataSources;
    using VistA.Imaging.Models;

    /// <summary>
    /// TODO: Update summary.
    /// </summary>
    public class SiteConnectionInfoFacade : ISiteConnectionInfoFacade
    {
        /// <summary>
        /// The logger
        /// </summary>
        private readonly Logger logger = LogManager.GetCurrentClassLogger();

        /// <summary>
        /// The siteConnectionInfoDataSource
        /// </summary>
        private ISiteConnectionInfoDataSource siteConnectionInfoDataSource;

        /// <summary>
        /// The serviceTypeInfoDatasource
        /// </summary>
        private IServiceGroupInfoDatasource serviceTypeInfoDatasource;

        /// <summary>
        /// The cache
        /// </summary>
        private Dictionary<string, SiteConnectionInfo> cache;

        /// <summary>
        /// Initializes a new instance of the <see cref="SiteConnectionInfoFacade"/> class.
        /// </summary>
        /// <param name="siteConnectionInfoDataSource">The site connection info data source.</param>
        /// <param name="serviceTypeInfoDatasource">The service type info datasource.</param>
        public SiteConnectionInfoFacade(ISiteConnectionInfoDataSource siteConnectionInfoDataSource, IServiceGroupInfoDatasource serviceTypeInfoDatasource)
        {
            this.cache = new Dictionary<string, SiteConnectionInfo>();
            this.siteConnectionInfoDataSource = siteConnectionInfoDataSource;
            this.serviceTypeInfoDatasource = serviceTypeInfoDatasource;
            this.siteConnectionInfoDataSource.GetByIdCompleted +=
                new EventHandler<AsyncCompletedEventArgs<SiteConnectionInfo>>(this.SiteConnectionInfoDataSource_GetByIdCompleted);
            this.serviceTypeInfoDatasource.GetBySiteConnectionInfoCompleted +=
                new EventHandler<AsyncCompletedEventArgs<IEnumerable<ServiceGroupInfo>>>(this.ServiceTypeInfoDatasource_GetBySiteConnectionInfoCompleted);
        }

        /// <summary>
        /// Occurs when GetById completes.
        /// </summary>
        public event EventHandler<AsyncCompletedEventArgs<SiteConnectionInfo>> GetByIdCompleted;

        /// <summary>
        /// Gets the by id async.
        /// </summary>
        /// <param name="id">The id.</param>
        /// <param name="userState">State of the user.</param>
        public void GetByIdAsync(string id, object userState = null)
        {
            if (this.cache.ContainsKey(id))
            {
                this.GetByIdCompleted.SafelyRaise(this, new AsyncCompletedEventArgs<SiteConnectionInfo>(this.cache[id], null, false, userState));
            }
            else
            {
                this.siteConnectionInfoDataSource.GetByIdAsync(id, userState);
            }
        }

        /// <summary>
        /// Handles the GetByIdCompleted event of the siteConnectionInfoDataSource control.
        /// </summary>
        /// <param name="sender">The source of the event.</param>
        /// <param name="e">The <see cref="VistA.Imaging.ComponentModel.AsyncCompletedEventArgs&lt;VistA.Imaging.Models.SiteConnectionInfo&gt;"/> instance containing the event data.</param>
        protected void SiteConnectionInfoDataSource_GetByIdCompleted(object sender, AsyncCompletedEventArgs<SiteConnectionInfo> e)
        {
            if (e.Error != null)
            {
                this.logger.ErrorException(e.Error.Message, e.Error);
            }
            else if (e.Result != null)
            {
                this.serviceTypeInfoDatasource.GetBySiteConnectionInfoAsync(e.Result, new object[2] { e.UserState, e.Result });
            }
        }

        /// <summary>
        /// Handles the GetBySiteConnectionInfoCompleted event of the serviceTypeInfoDatasource control.
        /// </summary>
        /// <param name="sender">The source of the event.</param>
        /// <param name="e">The <see cref="VistA.Imaging.ComponentModel.AsyncCompletedEventArgs&lt;System.Collections.Generic.IEnumerable&lt;VistA.Imaging.Models.ServiceTypeInfo&gt;&gt;"/> instance containing the event data.</param>
        protected void ServiceTypeInfoDatasource_GetBySiteConnectionInfoCompleted(object sender, AsyncCompletedEventArgs<IEnumerable<ServiceGroupInfo>> e)
        {
            if (e.Error != null)
            {
                this.logger.ErrorException(e.Error.Message, e.Error);
            }
            else if (e.Result != null && e.UserState is object[])
            {
                object[] userState = e.UserState as object[];
                SiteConnectionInfo sci = userState[1] as SiteConnectionInfo;
                foreach (ServiceGroupInfo item in e.Result)
                {
                    sci.Services.Add(item.ServiceType, item);
                }

                this.cache.Add(sci.Name, sci);
                this.GetByIdCompleted.SafelyRaise(this, new AsyncCompletedEventArgs<SiteConnectionInfo>(sci, null, false, userState[0]));
            }
        }
    }
}
