<%@page import="gov.va.med.imaging.health.VixServerHealthProperties"%>
<%@page import="gov.va.med.imaging.health.VixServerHealth"%>
<%@page import="gov.va.med.imaging.visa.VisaWebContext"%>
<%@ page language="java" import="java.util.*" pageEncoding="ISO-8859-1"%>
<%
String path = request.getContextPath();
String basePath = request.getScheme()+"://"+request.getServerName()+":"+request.getServerPort()+path+"/";

String debugParameter = request.getParameter("debug");
boolean debug = false;
if("true".equalsIgnoreCase(debugParameter))
{
	debug = true;
}


%>

<!DOCTYPE HTML PUBLIC "-//W3C//DTD HTML 4.01 Transitional//EN">
<html>
  <head>
    <base href="<%=basePath%>">
    
    <title>VISA Version</title>
    
	<meta http-equiv="pragma" content="no-cache">
	<meta http-equiv="cache-control" content="no-cache">
	<meta http-equiv="expires" content="0">    
	<meta http-equiv="keywords" content="visa,version">

  </head>
  
  <body>
  	<%
  		VixServerHealth serverHealth = VisaWebContext.getRouter().getVixServerHealth(null);
  		String version = serverHealth.getVixServerHealthProperties().get(VixServerHealthProperties.VIX_SERVER_HEALTH_VIX_VERSION);
  	
  	 %>
  	<h1>VISA Version</h1>
    Welcome to the VISA Service, your current version is <b><%= version %></b>
    
    <%
    	if(debug)
    	{
    		%>
    		<br />
    		<a href="/Vix/secure/VixLog.jsp">Transaction Log</a>
    		<br />
    		<a href="/VixServerHealthWebApp/secure/MyVix.jsp">VIX Health</a>
    		
    		<%
    	
    	}
    
     %>
    
    
    
  </body>
</html>
