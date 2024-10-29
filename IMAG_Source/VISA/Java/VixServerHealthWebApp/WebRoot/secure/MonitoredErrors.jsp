<%@page import="gov.va.med.imaging.monitorederrors.MonitoredError"%>
<%@page import="gov.va.med.imaging.monitorederrors.MonitoredErrors"%>
<%@ page language="java" import="java.util.*" pageEncoding="ISO-8859-1"%>
<%
String path = request.getContextPath();
String basePath = request.getScheme()+"://"+request.getServerName()+":"+request.getServerPort()+path+"/";
%>

<!DOCTYPE HTML PUBLIC "-//W3C//DTD HTML 4.01 Transitional//EN">
<html>
  <head>
    
    <title>Monitored Errors</title>
    
	<meta http-equiv="pragma" content="no-cache">
	<meta http-equiv="cache-control" content="no-cache">
	<meta http-equiv="expires" content="0">    
	<meta http-equiv="keywords" content="keyword1,keyword2,keyword3">
	<meta http-equiv="description" content="This is my page">
	<!--
	<link rel="stylesheet" type="text/css" href="styles.css">
	-->

  </head>
  
  <body>
  	<h1>Monitored Errors</h1>
  	All values are reset when the VIX service restarts
  	<table border="1">
  		<tr>
  			<th>Error Contains</th>
  			<th>Error Occurrences</th>
  			<th>Last Occurrence</th>
  			<th>Active</th>
  		</tr>
  	
    <%
    	List<MonitoredError> monitoredErrors = MonitoredErrors.getMonitoredErrors();
    	for(MonitoredError monitoredError : monitoredErrors)
    	{
    		%>
    		<tr>
    			<td><%= monitoredError.getErrorMessageContains() %></td>
    			<td><%= monitoredError.getCount() %></td>
    			<td><%= monitoredError.getLastOccurrenceString() %></td>
    			<td><%= monitoredError.isActive() %></td>
    		</tr>
    		<%
    	}
     %>
    </table>
    <a href="ConfigureMonitoredErrors.jsp">Configure</a>
    
  </body>
</html>
