<%@page import="gov.va.med.imaging.monitorederrors.MonitoredErrorConfiguration"%>
<%@ page language="java" import="java.util.*" pageEncoding="ISO-8859-1"%>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core"%>
<%
String path = request.getContextPath();
String basePath = request.getScheme()+"://"+request.getServerName()+":"+request.getServerPort()+path+"/";
%>

<!DOCTYPE HTML PUBLIC "-//W3C//DTD HTML 4.01 Transitional//EN">
<html>
  <head>
    <title>Configure Monitored Errors</title>
    
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
  	<a href="MonitoredErrors.jsp">View Monitored Errors</a>
  	<h1>Configure Monitored Errors</h1>
  	<form method="POST" action="DeleteMonitoredError">
  	<table border="1">
  		<tr>
  			<th>Delete</th>
  			<th>Error Contains</th>
  		</tr>
    <%
    	MonitoredErrorConfiguration configuration = MonitoredErrorConfiguration.getMonitoredConfiguration();
    	List<String> monitoredErrors = configuration.getMonitoredErrors();
    	
    	for(int i = 0; i < monitoredErrors.size(); i++)
    	{
    		%>
    		<tr>
    			<td><input type="checkbox" name="monitoredErrors" value="<c:out value="${i}"/>" /></td>
    			<td><c:out value="${monitoredErrors.get(i)}"/></td>
    		</tr>
    		<%
    	}
     %>
     </table>
     <input type="submit" value="Delete Checked"/>
     </form>
     
     <h1>Add Monitored Error</h1>
     <form method="POST" action="AddMonitoredError">
     <input type="text" name="newMonitoredError"/>
     <input type="submit" value="Add Monitored Error" />
     </form>
  </body>
</html>
