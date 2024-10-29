<%@ page language="java" import="java.util.*" pageEncoding="ISO-8859-1"%>
<%@page import="gov.va.med.imaging.vixserverhealth.configuration.VixServerHealthWebAppConfiguration"%>
<%@ taglib uri="http://imaging.med.va.gov/vix/vixServerHealth"
	prefix="vixServerHealth"%>
<%@ taglib uri='http://java.sun.com/jsp/jstl/core' prefix='c' %>
<%
	String path = request.getContextPath();
	String basePath = request.getScheme() + "://"
			+ request.getServerName() + ":" + request.getServerPort()
			+ path + "/";

	String siteNumber = request.getParameter("siteNumber");
	String refresh = request.getParameter("forceRefresh");
	boolean forceRefresh = false;
	if (refresh != null)
		forceRefresh = Boolean.parseBoolean(refresh);
%>

<!DOCTYPE HTML PUBLIC "-//W3C//DTD HTML 4.01 Transitional//EN">
<html>
	<head>
		<%
			Integer refreshInterval = VixServerHealthWebAppConfiguration.getVixServerHealthWebAppConfiguration().getReloadPageIntervalSeconds();
			if(refreshInterval == null)
				refreshInterval = 120;
		 %>
		<title>View VIX Server Health</title>

		<meta http-equiv="pragma" content="no-cache">
		<meta http-equiv="cache-control" content="no-cache">
		<meta http-equiv="expires" content="0">
		<meta http-equiv="keywords" content="keyword1,keyword2,keyword3">
		<meta http-equiv="description" content="This is my page">
		<meta http-equiv="refresh" content="<%= refreshInterval %>">
		<link rel="stylesheet" type="text/css" href="../style/vix.css">
	</head>

	<body>
		<vixServerHealth:VixServerHealthViewTag siteNumber="<%=siteNumber%>"
			forceRefresh="<%=forceRefresh%>">
			<div id="header">
				<vixServerHealth:VixSiteName />
			</div>
			<div id="content">
				<div id="sidebar">
					<div id="sidebar-item">
						<b>VIX Current Time:</b>
						<br />
						<vixServerHealth:VixServerCurrentTime />
						<br />
						<a href="SelectVix.jsp">View VIX List</a>
						<br />
						<a href="ViewVixRaw.jsp?siteNumber=<c:out value="${siteNumber}"></c:out>">View VIX
							Health Raw</a>
					</div>
				</div>

				<div id="main-content">
					<h2>
						VIX:
					</h2>
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
								JVM Start Time:
							</th>
							<td>
								<vixServerHealth:JvmStartTime />
							</td>
						</tr>
						<tr>
							<th>
								JVM Up Time:
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
					
					
					
					<form method="POST"
						action="ViewVix.jsp?siteNumber=<c:out value="${siteNumber}"></c:out>">
						<input type="hidden" name="forceRefresh" value="true" />
						<input type="submit" value="Force Refresh" />
					</form>
					<hr>
					<h2>
						Tomcat Java Logs:
					</h2>
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
					<h2>
						VIX Cache:
					</h2>
					<table border="1">
						<tr>
							<th>
								VIX Cache Dir:
							</th>
							<td>
								<vixServerHealth:VixCacheDir />
							</td>
							<td>&nbsp;</td>
						</tr>
						<tr>
							<th>
								Directory Size:
							</th>
							<td>
								<vixServerHealth:VixCacheDirSize />
							</td>
							<td>&nbsp;</td>
						</tr>
						<tr>
							<th>
								Directory Capacity:
							</th>
							<td>
								<vixServerHealth:VixCacheDirCapacity />
							</td>
							<td>&nbsp;</td>
						</tr>
						<tr>
							<th>
								Directory Available:
							</th>
							<td>
								<vixServerHealth:VixCacheDirAvailable />
							</td>
							<td>&nbsp;</td>
						</tr>
						<tr>
							<th>
								Percent Used:
							</th>
							<td>
								<vixServerHealth:VixCacheDirPercentUsed />
							</td>
							<td>
								<vixServerHealth:VixCacheDirPercentUsedCheck />
							</td>
						</tr>
						<tr>
							<th>
								Operations Initiated:
							</th>
							<td>
								<vixServerHealth:VixCacheOperationsInitiated />
							</td>
							<td>&nbsp;</td>
						</tr>
						<tr>
							<th>
								Operations Successful:
							</th>
							<td>
								<vixServerHealth:VixCacheOperationsSuccessful />
							</td>
							<td>&nbsp;</td>
						</tr>
						<tr>
							<th>
								Operations Not Found:
							</th>
							<td>
								<vixServerHealth:VixCacheOperationsNotFound />
							</td>
							<td>&nbsp;</td>
						</tr>
						<tr>
							<th>
								Operations Error:
							</th>
							<td>
								<vixServerHealth:VixCacheOperationsError />
							</td>
							<td>&nbsp;</td>
						</tr>
					</table>
					<hr>
					<h2>
						Realm Configuration:
					</h2>
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
					<h2>
						Tomcat Thread Details:
					</h2>
					<table border="1">
						<tr>
							<th>
								HTTP 8080 Thread Pool Size:
							</th>
							<td>
								<vixServerHealth:Http8080ThreadPoolSize />
							</td>
							<td>
								<vixServerHealth:Http8080ThreadPoolSizeCheck />
							</td>
						</tr>
						<tr>
							<th>
								HTTP 8080 Threads Busy:
							</th>
							<td>
								<vixServerHealth:Http8080ThreadsBusy />
							</td>
							<td>&nbsp;</td>
						</tr>
						<tr>
							<th>
								HTTP 8443 Thread Pool Size:
							</th>
							<td>
								<vixServerHealth:Http8443ThreadPoolSize />
							</td>
							<td>
								<vixServerHealth:Http8443ThreadPoolSizeCheck />
							</td>
						</tr>
						<tr>
							<th>
								HTTP 8443 Threads Busy:
							</th>
							<td>
								<vixServerHealth:Http8443ThreadsBusy />
							</td>
							<td>&nbsp;</td>
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
						</tr>
					</table>
					
					<hr>
					<h2>
						Transaction Log Statistics:
					</h2>
					<table border="1">
						<tr>
							<th>
								Transaction Log Directory:
							</th>
							<td>
								<vixServerHealth:VixServerTransactionLogDirectory />
							</td>
							<td>&nbsp;</td>							
						</tr>
						<tr>
							<th>
								Transaction Log Directory Size:
							</th>
							<td>
								<vixServerHealth:VixServerTransactionLogDirectorySize />
							</td>
							<td>&nbsp;</td>							
						</tr>
						<tr>
							<th>
								Transactions Written:
							</th>
							<td>
								<vixServerHealth:VixServerTransactionLogStatisticsTransactionsWritten />
							</td>
							<td>&nbsp;</td>							
						</tr>
						<tr>
							<th>
								Transactions Queried:
							</th>
							<td>
								<vixServerHealth:VixServerTransactionLogStatisticsTransactionsQueried />
							</td>
							<td>&nbsp;</td>
						</tr>
						<tr>
							<th>
								Transactions Purged:
							</th>
							<td>
								<vixServerHealth:VixServerTransactionLogStatisticsTransactionsPurged />
							</td>
							<td>&nbsp;</td>
						</tr>
						
					</table>
				</div>
			</div>
		</vixServerHealth:VixServerHealthViewTag>
		<jsp:include flush="false" page="../footer.html"></jsp:include>
	</body>
</html>
