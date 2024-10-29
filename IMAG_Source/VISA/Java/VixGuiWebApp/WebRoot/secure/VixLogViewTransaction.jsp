<%@page import="java.text.SimpleDateFormat"%>
<%@page import="gov.va.med.imaging.exchange.transactionlog.TransactionLogEntryStartTimeComparator"%>
<%@page import="java.text.DateFormat"%>
<%@page import="gov.va.med.imaging.exchange.transactionlog.LeveledTransactionLogEntry"%>
<%@page import="gov.va.med.imaging.exchange.transactionlog.TransactionLogEntriesSorter"%>
<%@page import="gov.va.med.imaging.exchange.transactionlog.GroupedTransactionLogEntry"%>
<%@page import="gov.va.med.imaging.exchange.VixGuiWebAppRouter"%>
<%@page import="gov.va.med.imaging.access.TransactionLogEntry"%>
<%@page import="gov.va.med.imaging.access.TransactionLogWriterHolder"%>
<%@page import="gov.va.med.imaging.core.FacadeRouterUtility"%>
<%@ page language="java" import="java.util.*" pageEncoding="ISO-8859-1"%>
<%@ taglib uri='http://java.sun.com/jsp/jstl/core' prefix='c' %>
<%
String path = request.getContextPath();
String basePath = request.getScheme()+"://"+request.getServerName()+":"+request.getServerPort()+path+"/";
%>

<!DOCTYPE HTML PUBLIC "-//W3C//DTD HTML 4.01 Transitional//EN">
<html>
  <head>
    
    
    <title>View Transaction</title>
    
	<meta http-equiv="pragma" content="no-cache">
	<meta http-equiv="cache-control" content="no-cache">
	<meta http-equiv="expires" content="0">    
	<meta http-equiv="keywords" content="keyword1,keyword2,keyword3">
	<meta http-equiv="description" content="This is my page">
	<!--
	<link rel="stylesheet" type="text/css" href="styles.css">
	-->
	
	<%
		String transactionId = request.getParameter("transactionId");
		VixGuiWebAppRouter router = FacadeRouterUtility.getFacadeRouter (VixGuiWebAppRouter.class);
		TransactionLogWriterHolder logHolder = new TransactionLogWriterHolder();
		/*
		router.getTransactionLogEntries(logHolder, 	        
	               null, null, 
	               null, null, null, null, null,
	               null, transactionId, true, 
	               null, null);
	               */
	    router.getTransactionLogEntries(logHolder, "transactionId", transactionId);	             
		List<TransactionLogEntry> logEntryList = logHolder.getEntries();		
		List<GroupedTransactionLogEntry> groupedEntries = 
			TransactionLogEntriesSorter.sortByParents(logEntryList);
		List<LeveledTransactionLogEntry> leveledEntries = 
			TransactionLogEntriesSorter.flattenGroupedTransactionLogEntries(groupedEntries);
		int maxLevel = 0;
		for(LeveledTransactionLogEntry entry : leveledEntries)
		{
			if(entry.getLevel() > maxLevel)
				maxLevel = entry.getLevel();
		}
		maxLevel += 1;
			
	 %>

  </head>
  
  <body>
    <h1>Transaction <c:out value="${transactionId}"></c:out></h1>
    <table border="1">
    
    <tr>
    	<th>#</th>
    	<th colspan="<%= maxLevel %>">Command Class Name</th>
    	<th>Level</th>
    	<th>Date and Time</th>
		<th>Time on ViX (msec)</th>
		<th>ICN</th>
		<th>Query Type</th>
		<th>Query Filter</th>
		<th>Asynchronous?</th>
		<th>Facade Items Returned</th>
		<th>DataSource Items Received</th>
		<th>Facade Bytes Returned</th>
		<th>Data Source Bytes Received</th>		
		<th>Quality</th>		
		<th>Originating IP Address</th>
		<th>User</th>
		<th>Item in cache?</th>
		<th>Error Message</th>		
		<th>Modality</th>
		<th>Purpose of Use</th>				
		<th>Datasource Protocol</th>
		<th>Data Source Method</th>
        <th>Data Source Version</th>
        <th>Data Source Response Server</th>
		<th>Response Code</th>		
		<th>Realm Site Number</th>				
		<th>URN</th>
        <th>Transaction Number</th>
        <th>Vix Software Version</th>            
        <th>VistA Login Method</th>        
        <th>Machine Name</th>
        <th>Requesting Site</th>
        <th>Exception Class Name</th>
        <th>Time to First Byte</th>
        <th>Responding Site</th>
        <th>Facade Image Format Sent</th>
        <th>Facade Image Quality Sent</th>
        <th>Data Source Image Format Received</th>
        <th>Data Source Image Quality Received</th>        
        <th>Client Version</th>        
        <th>Command ID</th>
		<th>Parent Command ID</th>   
		<th>Thread ID</th>
		<th>VIX Site Number</th>
		<th>Requesting VIX Site Number</th>
		<th>Debug Information</th>     
    </tr>
     
    <%
    	//for(TransactionLogEntry entry : logEntryList)
    	//for(TransactionLogEntry entry : groupedEntries)	
    	
   		DateFormat dateFormat = 
   			DateFormat.getDateTimeInstance(DateFormat.SHORT, DateFormat.LONG, 
   				pageContext.getRequest().getLocale());
   		SortedSet<TransactionLogEntry> sortedEntries = 
   			new TreeSet<TransactionLogEntry>(
   				new TransactionLogEntryStartTimeComparator());
		String [] bgColor = 
			new String [] {"#00FFFF", "#FF0000", "#C0C0C0", "#FF8040", 
				"#408080", "#800000", "#00FF00", "#FFFFFF", "#FFFFFF",
				"#FFFFFF", "#FFFFFF", "#FFFFFF", "#FFFFFF"};
		int entryIndex = 0;
    	for(LeveledTransactionLogEntry leveledEntry : leveledEntries)
    	{
    		entryIndex++;
    		TransactionLogEntry entry = leveledEntry.getTransactionLogEntry();
    		sortedEntries.add(entry);    		
    		%>
    		<tr>
    			<td><a name="<%= entryIndex %>"><%= entryIndex %></a></td>
    			<%
    				int indentCount = maxLevel - leveledEntry.getLevel();
    				int level = leveledEntry.getLevel();
    				for(int i = 0; i < leveledEntry.getLevel(); i++)
    				{
    					String color = "#FFFFFF";
    					if(level < bgColor.length)
    						color = bgColor[level];
    					char levelLetter = (char)(level + 64);
    					%>
    						<td bgcolor="<%= color %>">&nbsp;<%= levelLetter %>&nbsp;</td>
    					<%
    				}
    			 %>
    			 
    		<%    		
    			String commandClassName = entry.getCommandClassName() == null ? "&nbsp;" : "" + entry.getCommandClassName();
    			String patientICN = entry.getPatientIcn() == null ? "&nbsp;" : "" + entry.getPatientIcn();
    			String queryType = entry.getQueryType() == null ? "&nbsp;" : "" + entry.getQueryType();
    			String queryFilter = entry.getQueryFilter() == null ? "&nbsp;" : "" + entry.getQueryFilter();
    			String quality = entry.getQuality() == null ? "&nbsp;" : "" + entry.getQuality();
    			String originatinHost = entry.getOriginatingHost() == null ? "&nbsp;" : "" + entry.getOriginatingHost();
    			String user = entry.getUser() == null ? "&nbsp;" : "" + entry.getUser();
    			String errorMsg = entry.getErrorMessage() == null ? "&nbsp;" : "" + entry.getErrorMessage();
    			String modality = entry.getModality() == null ? "&nbsp;" : "" + entry.getModality();
    			String purposeOfUse = entry.getPurposeOfUse() == null ? "&nbsp;" : "" + entry.getPurposeOfUse();
    			String dataSourceProtocol = entry.getDatasourceProtocol() == null ? "&nbsp;" : "" + entry.getDatasourceProtocol();
    			String dataSourceMethod = entry.getDataSourceMethod() == null ? "&nbsp;" : "" + entry.getDataSourceMethod();
    			String dataSourceVersion = entry.getDataSourceVersion() == null ? "&nbsp;" : "" + entry.getDataSourceVersion();
    			String dataSourceResponseServer = entry.getDataSourceResponseServer() == null ? "&nbsp;" : "" + entry.getDataSourceResponseServer();
    			String responseCode = entry.getResponseCode() == null ? "&nbsp;" : "" + entry.getResponseCode();
    			String realmSiteNumber = entry.getRealmSiteNumber() == null ? "&nbsp;" : "" + entry.getRealmSiteNumber();
    			String urn = entry.getUrn() == null ? "&nbsp;" : "" + entry.getUrn();
    			String transaction = entry.getTransactionId() == null ? "&nbsp;" : "" + entry.getTransactionId();
    			String vixSoftwareVersion = entry.getVixSoftwareVersion() == null ? "&nbsp;" : "" + entry.getVixSoftwareVersion();
    			String remoteLoginMethod = entry.getRemoteLoginMethod() == null ? "&nbsp;" : "" + entry.getRemoteLoginMethod();
    			String machineName = entry.getMachineName() == null ? "&nbsp;" : "" + entry.getMachineName();
    			String requestingSite = entry.getRequestingSite() == null ? "&nbsp;" : "" + entry.getRequestingSite();
        		String exceptionClassName = entry.getExceptionClassName() == null ? "&nbsp;" : "" + entry.getExceptionClassName();
        		String respondingSite = entry.getRespondingSite() == null ? "&nbsp;" : "" + entry.getRespondingSite();
        		String facadeImageFormatSent = entry.getFacadeImageFormatSent() == null ? "&nbsp;" : "" + entry.getFacadeImageFormatSent();
        		String facadeImageQualitySent = entry.getFacadeImageQualitySent() == null ? "&nbsp;" : "" + entry.getFacadeImageQualitySent();
        		String dataSourceImageFormatReceived = entry.getDataSourceImageFormatReceived() == null ? "&nbsp;" : "" + entry.getDataSourceImageFormatReceived();
        		String dataSourceImageQualityReceived = entry.getDataSourceImageQualityReceived() == null ? "&nbsp;" : "" + entry.getDataSourceImageQualityReceived();
        		String clientVersion = entry.getClientVersion() == null ? "&nbsp;" : "" + entry.getClientVersion();
        		
        		String parentCommandId = entry.getParentCommandId() == null ? "&nbsp;" : "" + entry.getParentCommandId();
        		String threadId = entry.getThreadId() == null ? "&nbsp;" : "" + entry.getThreadId();
        		String vixSiteNumber = entry.getVixSiteNumber() == null ? "&nbsp;" : "" + entry.getVixSiteNumber();
        		String requestingVixSiteNumber = entry.getRequestingVixSiteNumber() == null ? "&nbsp;" : "" + entry.getRequestingVixSiteNumber();
        		String debugInformation = entry.getDebugInformation() == null ? "&nbsp;" : "" + entry.getDebugInformation();
    		%>

			<td colspan="<%= indentCount %>"><c:out value="${commandClassName}"/></td>
    		<td><%= leveledEntry.getLevel()  %></td>
    		<td><%= entry.getStartTime() == null ? "&nbsp;" : "" + dateFormat.format(entry.getStartTime()) %></td>
    		<td><%= entry.getElapsedTime() == null ? "&nbsp;" : "" + entry.getElapsedTime()%></td>
    		<td><c:out value="${patientICN}"/></td>
    		<td><c:out value="${queryType}"/></td>
    		<td><c:out value="${queryFilter}"/></td>
    		<td><%= entry.isAsynchronousCommand() == null ? "&nbsp;" : "" + entry.isAsynchronousCommand()%></td>
    		<td><%= entry.getItemCount() == null ? "&nbsp;" : "" + entry.getItemCount()%></td>
    		<td><%= entry.getDataSourceItemsReceived() == null ? "&nbsp;" : "" + entry.getDataSourceItemsReceived()%></td>
    		<td><%= entry.getFacadeBytesSent() == null ? "&nbsp;" : "" + entry.getFacadeBytesSent() %></td>
    		<td><%= entry.getDataSourceBytesReceived() == null ? "&nbsp;" : "" + entry.getDataSourceBytesReceived()%></td>
    		<td><c:out value="${quality}"/></td>    		
    		<td><c:out value="${originatinHost}"/></td>
    		<td><c:out value="${user}"></c:out></td>
    		<td><%= entry.isCacheHit() == null ? "&nbsp;" : "" + entry.isCacheHit()%></td>
    		<td><c:out value="${errorMsg}"/></td>    		
    		<td><c:out value="${modality}"></c:out></td>
    		<td><c:out value="${purposeOfUse}"/></td>    		
    		<td><c:out value="${dataSourceProtocol}"/></td>
    		<td><c:out value="${dataSourceMethod}"></c:out></td>
    		<td><c:out value="${dataSourceVersion}"/></td>
    		<td><c:out value="${dataSourceResponseServer}"/></td>
    		<td><c:out value="${responseCode}"/></td>
    		<td><c:out value="${realmSiteNumber}"/></td>
    		<td><c:out value="${urn}"/></td>
    		<td><c:out value="${transaction}"/></td>
    		<td><c:out value="${vixSoftwareVersion}"/></td>
    		<td><c:out value="${remoteLoginMethod}"/></td>    		    	
    		<td><c:out value="${machineName}"/></td>
    		<td><c:out value="${requestingSite}"/></td>
    		<td><c:out value="${exceptionClassName}"/></td>
    		<td><%= entry.getTimeToFirstByte() == null ? "&nbsp;" : "" + entry.getTimeToFirstByte()%></td>
    		<td><c:out value="${respondingSite}"/></td>
    		<td><c:out value="${facadeImageFormatSent}"/></td>
    		<td><c:out value="${facadeImageQualitySent}"/></td>
    		<td><c:out value="${dataSourceImageFormatReceived}"/></td>
    		<td><c:out value="${dataSourceImageQualityReceived}"/></td>    		
    		<td><c:out value="${clientVersion}"/></td>    		
    		<td><c:out value="${entry.getCommandId()}"/></td>
    		<td><c:out value="${parentCommandId}"/></td>
    		<td><c:out value="${threadId}"/></td>
    		<td><c:out value="${vixSiteNumber}"/></td>
    		<td><c:out value="${requestingVixSiteNumber}"/></td>
    		<td><c:out value="${debugInformation}"/></td>
    		
    		</tr>
    		<%
    		
    	}
     %>
     </table>
     
     
     <h1>Timeline</h1>
     
     <%
     long startTime = Long.MAX_VALUE;
     	long endTime = 0;
     	for(TransactionLogEntry entry : sortedEntries)
     	{
     		if(entry.getStartTime() < startTime)
     			startTime = entry.getStartTime();
     		long et = entry.getStartTime() + entry.getElapsedTime();
     		if(et > endTime)
     			endTime = et;
     	}
     	// now start time is the first start time, endTime is the last end time
     	long range = endTime - startTime;
     	//int blockSize = 1000;
     	//out.println("Range: " + range + "<br>");
     	//out.println("Start time: " + startTime);
      %>
     
     <table border="1">
     <tr align="left">
     	<th>#</th>
     	<th>Command Name</th>
     	<th>Start Time</th>
     	<th>End Time</th>
     	<th align="center"><%= range %> ms total</th>
     </tr>
     
     <%
     //for(TransactionLogEntry entry : sortedEntries)
     entryIndex = 0;
     for(LeveledTransactionLogEntry leveledEntry : leveledEntries)
     {
     	entryIndex++;
     	TransactionLogEntry entry = leveledEntry.getTransactionLogEntry();
     	long entryStartTime = entry.getStartTime();
      	long entryDuration = entry.getElapsedTime();
      	
      	long skipSize = entryStartTime - startTime;
      	long skipEnd = range - skipSize - entryDuration;
      	SimpleDateFormat timeFormat = new SimpleDateFormat("h:mm:ss.SSSS aa"); 
      	%>
      	
      	<tr>
      		<td><a href="#<%= entryIndex %>"><%= entryIndex %></a></td>
      		
      		<%
      			String details = entry.getCommandClassName() + " (" + (entry.getRespondingSite() == null ? "" : "" + entry.getRespondingSite()) + ")" ;
      		%>
      		
      		<td><c:out value="${details}"/></td>
      		<td width=130><%= timeFormat.format(entry.getStartTime()) %></td>
      		<td width=130><%= timeFormat.format(entry.getStartTime() + entry.getElapsedTime()) %></td>
      		<td>
      			<table border=0 cellspacing=0 cellpadding=8 bgcolor="#ffffff">
      				<tr>
      					<td width="<%= skipSize %>">
      						<img src="images/blacDot.gif" alt="" width=1 height=1 />
      					</td>
      					<td width="<%= entryDuration %>" bgcolor="#000000">
      						<img src="images/blacDot.gif" alt="" width=1 height=1 />
      					</td>
      					<td width="<%= skipEnd %>">
      						<img src="images/blacDot.gif" alt="" width=1 height=1 />
      					</td>
      					
      				</tr>
      			</table>
      		</td>
      	</tr>
      	
      	<%
     }
      %>
     
     
     </table>
  </body>
</html>
