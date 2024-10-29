<%@ page language="java" import="java.util.*" pageEncoding="ISO-8859-1"%>
<%@page import="gov.va.med.imaging.vixserverhealth.configuration.VixServerHealthWebAppConfiguration"%>
<%@ taglib uri="http://imaging.med.va.gov/vix/vixServerHealth" prefix="vixServerHealth"%>
<%
String path = request.getContextPath();
String basePath = request.getScheme()+"://"+request.getServerName()+":"+request.getServerPort()+path+"/";
String refresh = request.getParameter("forceRefresh");
boolean forceRefresh = false;
if(refresh != null)
	forceRefresh = Boolean.parseBoolean(refresh);
%>

<!DOCTYPE HTML PUBLIC "-//W3C//DTD HTML 4.01 Transitional//EN">
<html>
  <head>
    <%
		Integer refreshInterval = VixServerHealthWebAppConfiguration.getVixServerHealthWebAppConfiguration().getReloadPageIntervalSeconds();
		if(refreshInterval == null)
			refreshInterval = 300;
	 %>
    
    <title>Select VIX</title>
    
	<meta http-equiv="pragma" content="no-cache">
	<meta http-equiv="cache-control" content="no-cache">
	<meta http-equiv="expires" content="0">    
	<meta http-equiv="keywords" content="keyword1,keyword2,keyword3">
	<meta http-equiv="description" content="This is my page">
	<meta http-equiv="refresh" content="<%= refreshInterval %>" >
	<link rel="stylesheet" type="text/css" href="../style/vix.css">

  </head>
  
  <body>
  	<div id="header">
		VIX Server Health Web View
	</div>	
	
	<div id="content">
  		<div id="sidebar">
  			<div id="sidebar-item">
  				<b>VIX Current Time:</b> <br/> <vixServerHealth:VixServerCurrentTime />
  				<br/>
				<a href="ViewWebAppConfiguration.jsp">View VIX Health Configurations</a>
			</div>  			
  		</div>
  		
  		<div id="main-content">
		    <h2>Select VIX Server:</h2>    
		    <table border="1">
		    	<tr>
		    		<th>Site Name</th>
		    		<th>VIX Server</th>
		    		<th>VIX Port</th>
		    		<th>VIX Status</th>
		    		<th>Health Updated</th>
		    		<th>VIX Version</th>
		    		<th>JVM Up Time</th>
		    	</tr>
		    	
		    	<vixServerHealth:VixServerHealthViewCollectionTag forceRefresh="<%= forceRefresh %>" >
		    		<vixServerHealth:VixServerHealthViewElement>
		    			<tr>    				
		    				<td>
		    					<jsp:element name="a">
		    						<jsp:attribute name="href">
		    							<vixServerHealth:SiteHRef/>
		    						</jsp:attribute>
		    						<jsp:body>
		    							<vixServerHealth:VixSiteName/>
		    						</jsp:body>
		    					</jsp:element> 
		    				</td>
		    				<td><vixServerHealth:SiteVixServer /></td>
		    				<td><vixServerHealth:SiteVixPort /></td>
		    				<td><vixServerHealth:StatusCheck/></td>
		    				<td><vixServerHealth:HealthUpdatedTime/></td>
		    				<td><vixServerHealth:VixVersion/></td>
		    				<td><vixServerHealth:JvmUpTime/></td>
		    			</tr>
		    		</vixServerHealth:VixServerHealthViewElement>
		    	</vixServerHealth:VixServerHealthViewCollectionTag>
		    	
		    	
		    </table>
		    <form method="POST" action="SelectVix.jsp">
		    	<input type="hidden" name="forceRefresh" value="true" />
		   		<input type="submit" value="Force Refresh" />
		   	</form>	   	
		   	
   		</div>
  	</div>
  	<jsp:include flush="false" page="../footer.html"></jsp:include>
  </body>
</html>
