<%@ page language="java" import="java.util.*" pageEncoding="ISO-8859-1"%>
<%@ taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c"%>
<%
String path = request.getContextPath();
String basePath = request.getScheme()+"://"+request.getServerName()+":"+request.getServerPort()+path+"/";
%>

<!DOCTYPE HTML PUBLIC "-//W3C//DTD HTML 4.01 Transitional//EN">
<html>
  <head>
    
    
    <title>Site Service Utilities</title>
    
	<meta http-equiv="pragma" content="no-cache">
	<meta http-equiv="cache-control" content="no-cache">
	<meta http-equiv="expires" content="0">    
	<meta http-equiv="keywords" content="keyword1,keyword2,keyword3">
	<meta http-equiv="description" content="This is my page">
	<!--
	<link rel="stylesheet" type="text/css" href="styles.css">
	-->
	
	<%
		String status = request.getParameter("status");
	 %>

  </head>
  
  <body>
  	<h1>Site Service Utilities</h1>
  	
  	<%
  		if(status != null)
  		{
	%>
  		<c:out value="${status}"></c:out><br>	
	<%
		}
  	%>

  	 <form method="POST" action="RefreshSiteServiceServlet">
  	 	<input type="submit" value="Refresh Site Service" />
  	 </form>
    
  </body>
</html>
