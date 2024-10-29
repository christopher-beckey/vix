<%@ page language="java" import="java.util.*" pageEncoding="ISO-8859-1"%>
<%@ taglib uri="http://imaging.med.va.gov/vix/vixServerHealthWebAppConfiguration" prefix="vixServerHealthWebAppConfiguration"%>
<%
String path = request.getContextPath();
String basePath = request.getScheme()+"://"+request.getServerName()+":"+request.getServerPort()+path+"/";
%>

<!DOCTYPE HTML PUBLIC "-//W3C//DTD HTML 4.01 Transitional//EN">
<html>
  <head>
    <title>VIX Health Web App Configuration</title>
    
	<meta http-equiv="pragma" content="no-cache">
	<meta http-equiv="cache-control" content="no-cache">
	<meta http-equiv="expires" content="0">    
	<meta http-equiv="keywords" content="keyword1,keyword2,keyword3">
	<meta http-equiv="description" content="This is my page">
	<link rel="stylesheet" type="text/css" href="../style/vix.css">
  </head>
  
  <body>
  	<div id="header">
   		VIX Health Configuration
	</div>
	<div id="content">
		<div id="sidebar">
			<div id="sidebar-item">
				<a href="SelectVix.jsp">View VIX List</a>
			</div>
		</div>
		<div id="main-content">
		    These are the properties which are used to determine if a VIX health property is ok or a concern.
		    <br>These properties can be modified by updating the <i>VixServerHealthWebAppConfiguration.config</i> configuration file but require the VIX to be restarted to take effect.
		    <br><br>
		    <vixServerHealthWebAppConfiguration:VixServerHealthConfigurationTag>
		    	<table border="1">
		    		<tr>
		    			<th>Drive Capacity Critical Limit:</th>
		    			<td><vixServerHealthWebAppConfiguration:DriveCapacityCriticalLimit /> </td>
		    		</tr>
		    		<tr>
		    			<th>Thread Pool Size Threshold:</th>
		    			<td><vixServerHealthWebAppConfiguration:ThreadPoolThreshold /> </td>
		    		</tr>
		    		<tr>
		    			<th>Thread Processing Time Critical Limit:</th>
		    			<td><vixServerHealthWebAppConfiguration:ThreadProcessingTimeCriticalLimit/> </td>
		    		</tr>
		    		<tr>
		    			<th>Reload Page Interval:</th>
		    			<td><vixServerHealthWebAppConfiguration:ReloadPageInterval /></td>
		    		</tr>
		    	</table>    
		    </vixServerHealthWebAppConfiguration:VixServerHealthConfigurationTag>
   		</div>
	</div>
  	<jsp:include flush="false" page="../footer.html"></jsp:include>     	    
  </body>
</html>
