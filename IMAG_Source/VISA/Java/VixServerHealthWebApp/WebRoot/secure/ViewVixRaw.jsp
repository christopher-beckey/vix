<%@ page language="java" import="java.util.*" pageEncoding="ISO-8859-1"%>
<%@ taglib uri="http://imaging.med.va.gov/vix/vixServerHealth" prefix="vixServerHealth"%>
<%@ taglib uri='http://java.sun.com/jsp/jstl/core' prefix='c' %>
<%
String path = request.getContextPath();
String basePath = request.getScheme()+"://"+request.getServerName()+":"+request.getServerPort()+path+"/";
String siteNumber = request.getParameter("siteNumber");
%>

<!DOCTYPE HTML PUBLIC "-//W3C//DTD HTML 4.01 Transitional//EN">
<html>
  <head>
    <title>View VIX Health Raw</title>
    
	<meta http-equiv="pragma" content="no-cache">
	<meta http-equiv="cache-control" content="no-cache">
	<meta http-equiv="expires" content="0">    
	<meta http-equiv="keywords" content="keyword1,keyword2,keyword3">
	<meta http-equiv="description" content="This is my page">
	<link rel="stylesheet" type="text/css" href="../style/vix.css">
  </head>
  
  <body>
  	
   	<vixServerHealth:VixServerHealthViewTag siteNumber="<%= siteNumber %>">
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
					<a href='ViewVix.jsp?siteNumber=<c:out value="${error}"></c:out>'>View VIX</a>
				</div>
			</div>
			<div id="main-content">
		     	<table border="1">
		     		<tr>
		     			<th>Key</th>
		     			<th>Value</th>
		     		</tr>
		     		<vixServerHealth:VixServerHealthViewAttributeCollectionTag>
		     			<tr>
		     				<td><vixServerHealth:AttributeKey /></td>
		     				<td><vixServerHealth:AttributeValue /></td>
		     			</tr>     		
		     		</vixServerHealth:VixServerHealthViewAttributeCollectionTag>     	
		     	</table>
   			</div>
   		</div>
     	<jsp:include flush="false" page="../footer.html"></jsp:include>     	
    </vixServerHealth:VixServerHealthViewTag>
  </body>
</html>
