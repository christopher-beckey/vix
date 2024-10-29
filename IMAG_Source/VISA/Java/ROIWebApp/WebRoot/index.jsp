<%@page import="gov.va.med.imaging.roi.commands.periodic.configuration.ROIPeriodicCommandConfiguration"%>
<%@page import="gov.va.med.imaging.roi.commands.mbean.ROICommandsStatistics" %>
<%@page import="gov.va.med.imaging.notifications.email.NotificationEmailConfiguration" %>
<%@page import="gov.va.med.imaging.notifications.NotificationTypes" %>
<%@page import="gov.va.med.imaging.roi.web.ROIConfigurationView"%>
<%@ page language="java" import="java.util.*" pageEncoding="ISO-8859-1"%>
<%@ taglib uri = "http://java.sun.com/jsp/jstl/core" prefix = "c" %>
<%
	String path = request.getContextPath();
	String basePath = request.getScheme()+"://"+request.getServerName()+":"+request.getServerPort()+path+"/";

	ROIConfigurationView view = ROIConfigurationView.get();
	pageContext.setAttribute("view", view);
%>

<!DOCTYPE HTML PUBLIC "-//W3C//DTD HTML 4.01 Transitional//EN">
<html>
<head>
	<base href="<%=basePath%>">

	<title>ROI Processing Status</title>

	<meta http-equiv="pragma" content="no-cache">
	<meta http-equiv="cache-control" content="no-cache">
	<meta http-equiv="expires" content="0">
	<meta http-equiv="keywords" content="keyword1,keyword2,keyword3">
	<meta http-equiv="description" content="This is my page">
	<link rel="stylesheet" type="text/css" href="style/vix.css">
</head>

<body>

<%
	ROICommandsStatistics stats = ROICommandsStatistics.getRoiCommandsStatistics();


	boolean processingEnabled = stats.isRoiPeriodicProcessing();

	boolean completdItemPurgeEnabled = stats.isRoiCompletedItemsPurgeProcessing();

	String error = stats.getRoiPeriodicProcessingError();
	if(error == null || error.length() <= 0)
		error = "&nbsp;";

	NotificationEmailConfiguration emailConfiguration = NotificationEmailConfiguration.getConfiguration();

	ROIPeriodicCommandConfiguration roiConfiguration = ROIPeriodicCommandConfiguration.getROIPeriodicCommandConfiguration();
%>
<div id="header">
	Release of Information (ROI) Processing Status
</div>

<div id="main-content">
	<%
		if(!view.isFunctionalState())
		{
	%>
	<div id="error">
		ROI Disclosures will NOT be processed. Both Periodic Processing AND Process Disclosures Immediately are disabled. At least one of these options must be enabled to create ROI disclosures
	</div>
	<% } %>

	<%
		if(view.isRoiCredentialsInvalid())
		{
	%>
	<div id="error">
		The currently provided ROI periodic processing credentials are not valid.  Please update the credentials.
	</div>
	<%} %>

	<div id="section-header">
		ROI Statistics
	</div>
	These statistics are reset when the VIX is restarted
	<table border="1">
		<tr>
			<th>Disclosure Requests</th>
			<td><%= stats.getRoiDisclosureRequests() %></td>
		</tr>
		<tr>
			<th>Disclosures Completed Successfully</th>
			<td><%= stats.getRoiDisclosuresCompleted() %></td>
		</tr>
		<tr>
			<th>Studies Sent to Export Queue</th>
			<td><%= stats.getRoiStudiesSentToExportQueue() %></td>
		</tr>
		<tr>
			<th>Disclosures Failed Processing</th>
			<td><%= stats.getRoiDisclosureProcessingErrors() %></td>
		</tr>
		<tr>
			<th>Disclosures Cancelled</th>
			<td><%= stats.getRoiDisclosuresCancelled() %></td>
		</tr>
	</table>
	<br/>
	<div id="section-header">
		Periodic Processing
	</div>
	When enabled, ROI disclosures will be processed periodically in the background.
	<table border="1">
		<tr>
			<th>Configuration Enabled</th>
			<td><%= roiConfiguration.isPeriodicROIProcessingEnabled() %></td>
		</tr>
		<tr>
			<th>Current Status</th>
			<td><% if(processingEnabled) out.print("Enabled"); else out.print("Disabled"); %></td>
		</tr>

		<tr>
			<th>Status Message</th>
			<td><c:out value="${error}"></c:out></td>
		</tr>

	</table>

	<p>If periodic processing is disabled, ROI disclosures will only be processed when they are requested.
		If they are interrupted for any reason they will not be completed without ROI periodic processing.  </p>
	<div id="section-header">
		Completed Disclosures Purge Processing
	</div>
	When enabled, old disclosures are purged from the system after <%= roiConfiguration.getExpireCompletedItemsAfterDays() %> days
	<table border="1">
		<tr>
			<th>Configuration Enabled</th>
			<td><%= roiConfiguration.isExpireCompletedItemsEnabled() %></td>
		</tr>
		<tr>
			<th>Current Status</th>
			<td><% if(completdItemPurgeEnabled) out.print("Enabled"); else out.print("Disabled"); %></td>
		</tr>
	</table>

	<br />
	<div id="section-header">
		Other ROI Options
	</div>

	<table border="1">

		<tr>
			<th>Process Disclosure Requests Immediately</th>
			<td><%= roiConfiguration.isProcessWorkItemImmediately() %></td>
			<td>When true, disclosure requests are processed immediately as they are received. By default this is enabled but it could cause performance issues if too many ROI disclosure requests are received at one time</td>
		<tr>
		<tr>
			<th>In Process Work Item Wait Time</th>
			<td><%= roiConfiguration.getProcessingWorkItemWaitTime() %></td>
			<td>The number of minutes a work item will be allowed to be in a running state before it is restarted</td>
		<tr>


	</table>
	<p>If periodic processing and Process Disclosure Requests Immediately are both disabled, ROI disclosures will NOT be generated. </p>
	<a id="roi-config" href="secure/ConfigureROI.jsp">Configure ROI Options and Update Service Account Credentials</a>
	<hr />
	<br />

	<div id="section-header">
		Invalid Credentials Email Notification
	</div>
	When the credentials for the service account are invalid an email will be sent to these addresses
	<table border="1">
		<tr>
			<th>Invalid Credentials Email Notification Addresses</th>
			<td><%= emailConfiguration.getRecipientsForNotificationTypeAsDelimitedString(NotificationTypes.InvalidServiceAccountCredentials) %></td>
		</tr>
	</table>
	<br>
	<a id="email-config" href="secure/ConfigureEmail.jsp">Update the Invalid Credentials Email Notification Addresses</a>

</div>
<jsp:include flush="false" page="footer.html"></jsp:include>
<script>

	window.onload = (event) => {
		if(getSecurityToken() != ""){
			document.getElementById("roi-config").href = "secure/ConfigureROI.jsp?securityToken="+ getSecurityToken();
			document.getElementById("email-config").href = "secure/ConfigureEmail.jsp?securityToken=" + getSecurityToken();
		}
	}

	function getSecurityToken(){
		return getQueryString("securityToken");
	}

	//polyFill for URL.getSearchParameter() for IE
	function getQueryString() {
		var key = false, res = {}, itm = null;
		var qs = location.search.substring(1);
		if (arguments.length > 0 && arguments[0].length > 1)
			key = arguments[0];
		var pattern = /([^&=]+)=([^&]*)/g;
		while (itm = pattern.exec(qs)) {
			if (key !== false && decodeURIComponent(itm[1]) === key)
				return decodeURIComponent(itm[2]);
			else if (key === false)
				res[decodeURIComponent(itm[1])] = decodeURIComponent(itm[2]);
		}

		return key === false ? res : null;
	}
</script>
</body>
</html>
