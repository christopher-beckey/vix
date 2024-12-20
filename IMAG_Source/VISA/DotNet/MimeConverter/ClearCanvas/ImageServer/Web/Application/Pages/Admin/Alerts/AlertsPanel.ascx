<%--  License

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

--%>
<%@ Control Language="C#" AutoEventWireup="true" CodeBehind="AlertsPanel.ascx.cs"
	Inherits="ClearCanvas.ImageServer.Web.Application.Pages.Admin.Alerts.AlertsPanel" %>
<%@ Import Namespace="Resources" %>
<%@ Register Src="AlertsGridPanel.ascx" TagName="AlertsGridPanel" TagPrefix="localAsp" %>
<asp:UpdatePanel ID="SearchUpdatePanel" runat="server" UpdateMode="Conditional">
	<ContentTemplate>
		<asp:Table runat="server">
			<asp:TableRow>
				<asp:TableCell Wrap="false">
					<asp:Panel ID="Panel6" runat="server" CssClass="SearchPanelContentWithoutTabs" DefaultButton="SearchButton">
						<div class="SearchPanelParentDiv">
							<div class="SearchPanelChildDiv">
								<asp:Label ID="Label3" runat="server" Text="<%$Resources: SearchFieldLabels,AlertComponent %>"
									CssClass="SearchTextBoxLabel"></asp:Label><br />
								<ccUI:TextBox ID="ComponentFilter" runat="server" CssClass="SearchTextBox"/>
							</div>
							<div class="SearchPanelChildDivCancelX">
								<asp:Label ID="Label2" runat="server" Text="<%$Resources: SearchFieldLabels,AlertInsertDate %>"
									CssClass="SearchTextBoxLabel" />
								<asp:LinkButton ID="ClearInsertDateButton" runat="server" Text="X" CssClass="SmallLink"
									Style="margin-left: 10px;" /><br />
								<ccUI:TextBox ID="InsertDateFilter" runat="server" ReadOnly="true" CssClass="SearchDateBox" />
							</div>
							<div class="SearchPanelChildDiv">
								<asp:Label ID="Label4" runat="server" Text="<%$Resources: SearchFieldLabels,AlertCategory %>"
								           CssClass="SearchTextBoxLabel"/><br />
								<asp:DropDownList ID="CategoryFilter" runat="server" CssClass="SearchDropDownList" />
							</div>
							<div class="SearchPanelChildDiv">
								<asp:Label ID="Label1" runat="server" Text="<%$Resources: SearchFieldLabels,AlertLevel %>"
								           CssClass="SearchTextBoxLabel"/><br />
								<asp:DropDownList ID="LevelFilter" runat="server" CssClass="SearchDropDownList" />
							</div>
							<div class="SearchPanelChildDiv">
								<asp:Panel ID="Panel1" runat="server" CssClass="SearchButtonPanel">
									<ccUI:ToolbarButton ID="SearchButton" runat="server" SkinID="<%$Image:SearchIcon%>"
										OnClick="SearchButton_Click" />
								</asp:Panel>
							</div>
						</div>
					</asp:Panel>
					<ccUI:CalendarExtender ID="InsertDateCalendarExtender" runat="server" TargetControlID="InsertDateFilter"
						CssClass="Calendar">
					</ccUI:CalendarExtender>
				</asp:TableCell>
			</asp:TableRow>
			<asp:TableRow>
				<asp:TableCell>
					<table width="100%" class="ToolbarButtonPanel">
						<tr>
							<td>
								<asp:UpdatePanel ID="ToolBarUpdatePanel" runat="server" UpdateMode="Conditional">
									<ContentTemplate>
										<asp:Panel ID="ToolbarButtons" runat="server" CssClass="ToolbarButtons">
											<ccUI:ToolbarButton ID="DeleteAlertButton" runat="server" SkinID="<%$Image:DeleteButton%>"
												OnClick="DeleteAlertButton_Click" />
											<ccUI:ToolbarButton ID="DeleteAllAlertsButton" runat="server" SkinID="<%$Image:DeleteAllButton%>"
												OnClick="DeleteAllAlertsButton_Click" />
										</asp:Panel>
									</ContentTemplate>
								</asp:UpdatePanel>
							</td>
						</tr>
						<tr>
							<td>
								<asp:Panel ID="Panel2" runat="server" CssClass="SearchPanelResultContainer">
									<table class="SearchPanelResultContainerTable">
										<tr>
											<td>
												<ccAsp:GridPager ID="GridPagerTop" runat="server" />
											</td>
										</tr>
										<tr>
											<td class="SearchPanelResultContainerTd">
												<localAsp:AlertsGridPanel ID="AlertsGridPanel" runat="server" Height="500px" />
											</td>
										</tr>
									</table>
								</asp:Panel>
							</td>
						</tr>
					</table>
				</asp:TableCell>
			</asp:TableRow>
		</asp:Table>
	</ContentTemplate>
</asp:UpdatePanel>
<ccAsp:MessageBox ID="DeleteConfirmationBox" runat="server" />
<ccAsp:MessageBox ID="DeleteAllConfirmationBox" runat="server" />
<ccAsp:MessageBox ID="MessageBox" runat="server" MessageType="INFORMATION" />