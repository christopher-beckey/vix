<%@page import="gov.va.med.imaging.roi.web.ROIConfigurationView"%>
<%@ page language="java" import="java.util.*" pageEncoding="ISO-8859-1"%>
<%@ taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c"%>
<%@ taglib uri="http://java.sun.com/jsp/jstl/functions" prefix="fn"%>
<%
	String path = request.getContextPath();
	String basePath = request.getScheme() + "://"+request.getServerName() + ":" + request.getServerPort() + path + "/";

	ROIConfigurationView view = ROIConfigurationView.get();
	pageContext.setAttribute("view", view);

	String result = request.getParameter("result");
	pageContext.setAttribute("result", result);

	String error = request.getParameter("error");
	pageContext.setAttribute("error", request.getParameter("error"));

%>

<!DOCTYPE HTML PUBLIC "-//W3C//DTD HTML 4.01 Transitional//EN">
<html>
<head>
	<title>Configure ROI and SCP</title>

	<meta http-equiv="pragma" content="no-cache">
	<meta http-equiv="cache-control" content="no-cache">
	<meta http-equiv="expires" content="0">
	<meta http-equiv="keywords" content="keyword1,keyword2,keyword3">
	<link rel="stylesheet" type="text/css" href="../style/vix.css">

	<script type="text/javascript">
		function setAccessFocus()
		{
			document.getElementById("accessCode").focus();
		}

		function validateInput()
		{
			// Get access code value
			var accessCodeValue = document.getElementById("accessCode").value;
			var verifyCodeValue = document.getElementById("verifyCode").value;
			var verifyCode2Value = document.getElementById("verifyCode2").value;

			if(accessCodeValue == "" && verifyCodeValue == "" && verifyCode2Value == ""){
				submitRoiForm();
				return true;
			}

			if (accessCodeValue != "" && accessCodeValue.length < 6)
			{
				alert('You must specify an access code at least six characters long');
				return false;
			}

			// Get verify code values

			if (verifyCodeValue != "" && verifyCodeValue.length < 6)
			{
				alert('You must specify a verify code at least six characters long');
				return false;
			}
			if(verifyCodeValue != verifyCode2Value)
			{
				alert('Your verify codes do not match');
				return false;
			}

			updateScpConfig(accessCodeValue, verifyCodeValue);
            return true;
		}

		function updateScpConfig(accessCode, verifyCode){
			var xhr = new XMLHttpRequest();
			var params = 'accessCode='+encodeURIComponent(accessCode)+'&verifyCode='+encodeURIComponent(verifyCode);
			var origin = document.location.origin;
			var securityToken = getSecurityToken();
			var url = origin + "/Study/secure/UpdateSCPConfiguration?securityToken="+securityToken;
			xhr.open("POST",url, true);
			xhr.setRequestHeader('Content-type', 'application/x-www-form-urlencoded');
			xhr.onreadystatechange = function() {//Call a function when the state changes.
				if(xhr.readyState == 4) {
					submitRoiForm();
				}
			}
			xhr.send(params);
		}

		function submitRoiForm(){
			var form = document.getElementById("roi-form");
			form.action = "UpdateROIConfiguration?securityToken="+getSecurityToken();
			form.method = "POST";
			form.submit();
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

		//polyFill for location.origin in IE
		if (!window.location.origin) {
			window.location.origin = window.location.protocol + "//"
					+ window.location.hostname
					+ (window.location.port ? ':' + window.location.port : '');
		}

		document.addEventListener("DOMContentLoaded", function(event) {
			if(getSecurityToken() != ""){
				document.getElementById("status-link").href = document.getElementById("status-link").href + "?securityToken="+getSecurityToken()
			}
		})

	</script>
</head>

<body onLoad="setAccessFocus();">
<div id="header">
	Configure Release of Information (ROI) and DICOM SCP
</div>
<div id="sidebar">
	<div id="sidebar-item">
		<a id="status-link" href="..\index.jsp">ROI Status</a>
	</div>
</div>
<div id="main-content">
	<%
		if(result != null)
		{
	%>
	<div id="success"><%= result %></div>
	<%
		}
		if(error != null)
		{
	%>
	<div id="error"><%= error %></div>
	<%
		}
	%>

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
		The currently provided ROI periodic processing credentials are not valid.  Please update the credentials below.
	</div>
	<%} %>

	<!-- form id="roi-form": VAI-528 -- Added method to satisfy Fortify -->
	<form id="roi-form" method="POST">
		<div id="section-header">
			VistA Service Account for ROI Periodic Processing and DICOM Query/Retrieve (Q/R)
		</div>
		The VIX will use the following credentials to periodically process ROI requests and to perform DICOM Q/R functions. These will not be modified on save unless values are provided.

		<table border="1">
			<tr>
				<th>Access Code:</th>
				<td><input type="password" id="accessCode" name="accessCode" autocomplete="off"/></td>
			</tr>
			<tr>
				<th>Verify Code:</th>
				<td><input type="password" id="verifyCode" name="verifyCode" autocomplete="off" /></td>
			</tr>
			<tr>
				<th>Re-Enter Verify Code:</th>
				<td><input type="password" id="verifyCode2" name="verifyCode2" autocomplete="off" /></td>
			</tr>

		</table>
		<hr />
		<br />
		<div id="section-header">
			ROI Options
		</div>
		<table border="1">
			<tr>
				<th>Periodic Processing Enabled</th>
				<td>
					<select name="periodicProcessingEnabled">
						<option value="true" <% if(view.isPeriodicProcessingEnabled()) out.print(" selected "); %> >True</option>
						<option value="false" <% if(!view.isPeriodicProcessingEnabled()) out.print(" selected "); %> >False</option>
					</select>
					<br>
					When true, ROI disclosures will be processed periodically in the background. If periodic processing is disabled, ROI disclosures will only be processed when they are requested.
					If they are interrupted for any reason they will not be completed without ROI periodic processing
				</td>
			</tr>

			<tr>
				<th>Completed Disclosures Purge Processing Enabled</th>
				<td>
					<select name="completedItemPurgeProcessingEnabled">
						<option value="true" <% if(view.isCompletedItemPurgeProcessingEnabled()) out.print(" selected "); %> >True</option>
						<option value="false" <% if(!view.isCompletedItemPurgeProcessingEnabled()) out.print(" selected "); %> >False</option>
					</select>
					<br>
					When true, old ROI disclosures are purged from the system after <%= view.getExpireCompletedItemsAfterDays() %> days (configurable below)
				</td>
			</tr>

			<tr>
				<th>Completed Disclosures Purged Days</th>
				<td>
					<input type="text" name="expiredCompletedItemsAfterDays" value="<%= view.getExpireCompletedItemsAfterDays() %>" />
					<br>
					This is the number of days the metadata for a completed disclosure will remain if purging is enabled
				</td>
			</tr>

			<tr>
				<th>Process Disclosure Requests Immediately</th>
				<td>
					<select name="processDisclosuresImmediately">
						<option value="true" <% if(view.isProcessWorkItemImmediately()) out.print(" selected "); %> >True</option>
						<option value="false" <% if(!view.isProcessWorkItemImmediately()) out.print(" selected "); %> >False</option>
					</select>
					<br>
					When true, disclosure requests are processed immediately as they are received. By default this is enabled but it could cause performance issues if too many ROI disclosure requests are received at one time
				</td>
			</tr>

			<tr>
				<th>Processing Disclosure Wait Time</th>
				<td>
					<input type="text" name="processingWorkItemWaitTime" value="<%= view.getProcessingWorkItemWaitTime() %>" />
					<br>
					The number of minutes a disclosure request can remain in a processing state before restarting.  Be sure not to set this too low in the event a disclosure really is taking that long
				</td>
			</tr>
		</table>
		<p>If Periodic Processing Enabled and Process Disclosure Requests Immediately are both disabled, ROI disclosures will NOT be generated. </p>
		<input type="button" value="Save Configuration" onclick="validateInput()"/>
	</form>
</div>
<jsp:include flush="false" page="../footer.html"></jsp:include>
</body>
</html>
