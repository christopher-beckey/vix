<%@ page language="java" import="java.util.*" pageEncoding="ISO-8859-1"%>
<%@ page import="gov.va.med.imaging.vixserverhealth.configuration.VixServerHealthWebAppConfiguration"%>
<%@ page import="java.util.List"%>
<%@ taglib uri='http://java.sun.com/jsp/jstl/core' prefix='c' %>
<%@ taglib uri="http://imaging.med.va.gov/vix/vixServerHealth"
	prefix="vixServerHealth"%>
<%
	String path = request.getContextPath();
	String basePath = request.getScheme() + "://"
			+ request.getServerName() + ":" + request.getServerPort()
			+ path + "/";
%>

<!DOCTYPE HTML PUBLIC "-//W3C//DTD HTML 4.01 Transitional//EN">
<html>
	<head>
		<%
			Integer refreshInterval = VixServerHealthWebAppConfiguration.getVixServerHealthWebAppConfiguration().getReloadPageIntervalSeconds();
			if(refreshInterval == null)
				refreshInterval = 120;
		 %>
		<title>VIX Server Health</title>

		<meta http-equiv="pragma" content="no-cache">
		<meta http-equiv="cache-control" content="no-cache">
		<meta http-equiv="expires" content="0">
		<meta http-equiv="keywords" content="keyword1,keyword2,keyword3">
		<meta http-equiv="description" content="This is my page">
		<meta http-equiv="refresh" content="<%= refreshInterval %>">
		<link rel="stylesheet" type="text/css" href="../style/vix.css">
	</head>

	<body>
		<vixServerHealth:VixServerHealthLocalViewTag>
			<div id="header">
				<vixServerHealth:VixSiteName />
			</div>
			<div id="content">
				<div id="sidebar">
				</div>

				<div id="main-content">
					<div id="section-header">
						VIX
					</div>
					<div id="section-description">
						General VIX information.
					</div>
					<table border="1">
						<tr>
							<th>
								VIX Hostname:
							</th>
							<td>
								<vixServerHealth:Hostname />
							</td>
						</tr>
						<tr>
							<th>
								VIX Health Updated:
							</th>
							<td>
								<vixServerHealth:HealthUpdatedTime />
							</td>
						</tr>
						<tr>
							<th>
								VIX Version:
							</th>
							<td>
								<vixServerHealth:VixVersion />
							</td>
						</tr>
						<tr>
							<th>
								VIX Start Time:
							</th>
							<td>
								<vixServerHealth:JvmStartTime />
							</td>
						</tr>
						<tr>
							<th>
								VIX Up Time:
							</th>
							<td>
								<vixServerHealth:JvmUpTime />
							</td>
						</tr>
						<tr>
							<th>
								VIX Status:
							</th>
							<td>
								<vixServerHealth:StatusCheck />
							</td>
						</tr>
					</table>
					<form method="GET"
						action="MyVix.jsp">
						<input type="submit" value="Refresh" />
					</form>
					<hr>
					<div id="section-header">
						Java Logs
					</div>
					<div id="section-description">
						This is where debug log information is stored. These logs are automatically purged after 30 days.
					</div>
					<table border="1">
						<tr>
							<th>
								Tomcat Java Logs Dir:
							</th>
							<td>
								<vixServerHealth:TomcatLogsDir />
							</td>
						</tr>
						<tr>
							<th>
								Directory Size:
							</th>
							<td>
								<vixServerHealth:TomcatLogsDirSize />
							</td>
						</tr>
					</table>
					<hr>					
					<div id="section-header">
						Realm Configuration
					</div>
					<div id="section-description">
					The realm is used to authenticate users to secure web pages hosted by the VIX. If the server/port listed here is not correct then the VIX will not be able to authenticate users properly to VistA.
					</div>
					<table border="1">
						<tr>
							<th>
								VistA Server:
							</th>
							<td>
								<vixServerHealth:RealmVistaServer />
							</td>
							<td>
								<vixServerHealth:RealmVistaServerCheck />
							</td>
						</tr>
						<tr>
							<th>
								VistA Port:
							</th>
							<td>
								<vixServerHealth:RealmVistaPort />
							</td>
							<td>
								<vixServerHealth:RealmVistaPortCheck />
							</td>
						</tr>
					</table>
					<hr>
					<div id="section-header">
						Tomcat Thread Details
					</div>
					<div id="section-description">
						This lists the number of currently active threads on the VIX.   
					</div>
					<table border="1">
						<tr>
							<th>
								HTTP 8080 Threads Busy:
							</th>
							<td>
								<vixServerHealth:Http8080ThreadsBusy />
							</td>
							<td>
								<vixServerHealth:VixServerHttp8080ThreadsBusyCheck />
							</td>
							<td>The number of active requests from clients (Clinical Display, VistARad, web users). Maximum of <vixServerHealth:VixServerConfigurationMaximum8080Requests /> at a time supported</td>
						</tr>
						<tr>
							<th>
								HTTP 8442 Threads Busy:
							</th>
							<td>
								<vixServerHealth:Http8442ThreadsBusy />
							</td>
							<td>
								<vixServerHealth:VixServerHttp8442ThreadsBusyCheck />
							</td>
							<td>The number of active requests from other VIX services. Maximum of <vixServerHealth:VixServerConfigurationMaximum8442Requests /> at a time supported</td>
						</tr>
						<tr>
							<th>
								HTTP 8443 Threads Busy:
							</th>
							<td>
								<vixServerHealth:Http8443ThreadsBusy />
							</td>
							<td>
								<vixServerHealth:VixServerHttp8443ThreadsBusyCheck />
							</td>
							<td>The number of active requests from other VIX services. Maximum of <vixServerHealth:VixServerConfigurationMaximum8443Requests /> at a time supported</td>
						</tr>
						<tr>
							<th>
								Long Running Threads:
							</th>
							<td>
								<vixServerHealth:LongRunningThreads />
							</td>
							<td>
								<vixServerHealth:LongRunningThreadsCheck />
							</td>
							<td>Long running threads are requests taking longer than <vixServerHealth:VixServerConfigurationLongRunningThreadsTime />. If they do not clear up on their own they can use up all resources on the VIX. If long running threads appear they will likely resolve on their own</td>						</tr>
					</table>
					
					<hr>
					<div id="section-header">
						Transaction Log
					</div>
					<div id="section-description">
					Every request to the VIX is stored in the transaction log
					</div>
					<table border="1">
						<tr>
							<th>
								Transaction Log Directory:
							</th>
							<td>
								<vixServerHealth:VixServerTransactionLogDirectory />
							</td>
							<td>Directory where the transactions logs are stored</td>					
						</tr>
						<tr>
							<th>
								Transaction Log Directory Size:
							</th>
							<td>
								<vixServerHealth:VixServerTransactionLogDirectorySize />
							</td>						
							<td>Size of transaction logs, logs are purged automatically</td>
						</tr>
						<tr>
							<th>
								Transactions Written:
							</th>
							<td>
								<vixServerHealth:VixServerTransactionLogStatisticsTransactionsWritten />
							</td>						
							<td>Number of transactions written since the VIX was last restarted</td>
						</tr>
						<tr>
							<th>
								Transactions/Minute:
							</th>
							<td>
								<vixServerHealth:VixServerTransactionLogStatisticsTransactionsPerMinute />
							</td>						
							<td>Number of transactions per minute written since the VIX was last restarted</td>
						</tr>
						<tr>
							<th>
								Transaction Write Errors:
							</th>
							<td>
								<vixServerHealth:VixServerTransactionLogStatisticsTransactionWriteErrors />
							</td>		
							<td>Number of errors trying to write transactions to the transaction log</td>				
						</tr>
						
						<tr>
							<th>
								Transaction Read Errors:
							</th>
							<td>
								<vixServerHealth:VixServerTransactionLogStatisticsTransactionReadErrors />
							</td>
							<td>Number of errors trying to read transactions from the transaction log</td>							
						</tr>
					</table>					
					
					<hr>
					<div id="section-header">
						Site Service
					</div>
					<div id="section-description">
					The VIX holds a copy of the site service and refreshes itself nightly
					</div>
					<table border="1">
						<tr>
							<th>
								Site Service URL:
							</th>
							<td>
								<vixServerHealth:VixServerSiteServiceUrl />
							</td>
							<td>
								<vixServerHealth:VixServerSiteServiceUrlCheck />
							</td>		
							<td>URL the VIX uses to retrieve a copy of the site service. This must be accessible from the VIX service</td>					
						</tr>
						<tr>
							<th>
								Site Service Last Updated:
							</th>
							<td>
								<vixServerHealth:VixServerSiteServiceLastUpdated />
							</td>
							<td>
								<vixServerHealth:VixServerSiteServiceLastUpdatedCheck />
							</td>							
							<td>The date/time when the site service was last refreshed, it should occur when the VIX restarts and nightly</td>
						</tr>					
					</table>
					
					<hr>
					<div id="section-header">
						Release of Information (ROI)
					</div>
					<div id="section-description">
					Release of Information disclosure configuration properties. For more details about the status of ROI processing and to change configurations go to the <a href="/ROIWebApp">ROI Status Page</a>					
					</div>
					<table border="1">
						<tr>
							<th>
								ROI Processing Enabled:
							</th>
							<td>
								<vixServerHealth:VixServerROIProcessingEnabledCheck />
							</td>		
							<td>ROI processing requires either periodic processing enabled and/or immediate processing enabled. If neither are enabled then ROI disclosures will NOT be generated by the VIX</td>					
						</tr>					
					</table>
					
					<hr>
					<div id="section-header">
						DICOM Services Transmit Failures
					</div>
					<div id="section-description">
						DICOM Services C-Storage Transmit failures to configured DICOM destination devices.
					</div>		
					<c:forEach var="dsstats" items="${VixServerHealthViewTag.dicomServicesStats}"  >
						<table border="1">
						<tr>
							<th>
								AETitle:
							</th>
							<th>
								SOP Class UID:
							</th>
							<th>
								Number of Failures:
							</th>
						</tr>
						<tr>
							<td>
								<c:out value="${dsstats.AeTitle}" />
							</td>
							<td>
								<c:out value="${dsstats.SopClassUID}" />
							
							</td>
							<td>
								<c:out value="${dsstats.totalVixSendToAEFailures}" />
							
							</td>
						</tr>
						</table>
					<br />
					</c:forEach>
				</div>
			</div>
		</vixServerHealth:VixServerHealthLocalViewTag>
		<jsp:include flush="false" page="../footer.html"></jsp:include>
	</body>
</html>
