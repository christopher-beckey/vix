#region License

// Copyright (c) 2013, ClearCanvas Inc.
// All rights reserved.
// http://www.clearcanvas.ca
//
// This file is part of the ClearCanvas RIS/PACS open source project.
//
// The ClearCanvas RIS/PACS open source project is free software: you can
// redistribute it and/or modify it under the terms of the GNU General Public
// License as published by the Free Software Foundation, either version 3 of the
// License, or (at your option) any later version.
//
// The ClearCanvas RIS/PACS open source project is distributed in the hope that it
// will be useful, but WITHOUT ANY WARRANTY; without even the implied warranty of
// MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the GNU General
// Public License for more details.
//
// You should have received a copy of the GNU General Public License along with
// the ClearCanvas RIS/PACS open source project.  If not, see
// <http://www.gnu.org/licenses/>.

#endregion

using System;
using System.Security.Permissions;
using ClearCanvas.ImageServer.Model;
using ClearCanvas.ImageServer.Web.Application.Pages.Common;
using AuthorityTokens=ClearCanvas.ImageServer.Common.Authentication.AuthorityTokens;
using Resources;

namespace ClearCanvas.ImageServer.Web.Application.Pages.Admin.Configure.ServiceLocks
{
	[PrincipalPermission(SecurityAction.Demand, Role = AuthorityTokens.Admin.Configuration.ServiceScheduling)]
	public partial class Default : BasePage
	{

		#region Private members

		#endregion Private members

		#region Protected methods

		private void ServiceLockPanel_ServiceLockUpdated(ServiceLock serviceLock)
		{
			DataBind();
		}


		protected override void OnInit(EventArgs e)
		{
			base.OnInit(e);

			ServiceLockPanel.ServiceLockUpdated += ServiceLockPanel_ServiceLockUpdated;

		}

		protected void Page_Load(object sender, EventArgs e)
		{
			DataBind();

			SetPageTitle(Titles.ServiceSchedulingPageTitle);
		}

		#endregion  Protected methods

		#region Public Methods


		#endregion
	}
}
