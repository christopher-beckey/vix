<%@page import="gov.va.med.imaging.notifications.email.NotificationEmailConfiguration" %>
<%@page import="gov.va.med.imaging.notifications.NotificationTypes" %>
<%@ page language="java" import="java.util.*" pageEncoding="ISO-8859-1"%>
<%@ taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c"%>
<%@ taglib uri="http://java.sun.com/jsp/jstl/functions" prefix="fn"%>
<%
String path = request.getContextPath();
String basePath = request.getScheme()+"://"+request.getServerName()+":"+request.getServerPort()+path+"/";

String result = request.getParameter("result");
pageContext.setAttribute("result", result);

String error = request.getParameter("error");
pageContext.setAttribute("error", error);

NotificationEmailConfiguration emailConfiguration = NotificationEmailConfiguration.getConfiguration();

%>

<!DOCTYPE HTML PUBLIC "-//W3C//DTD HTML 4.01 Transitional//EN">
<html>
  <head>
    <title>Configure Invalid Credentials Email Notification Addresses</title>
    
	<meta http-equiv="pragma" content="no-cache">
	<meta http-equiv="cache-control" content="no-cache">
	<meta http-equiv="expires" content="0">    
	<meta http-equiv="keywords" content="keyword1,keyword2,keyword3">
	<link rel="stylesheet" type="text/css" href="../style/vix.css">
	
	<script type="text/javascript">
		function setEmailFocus() 
		{
			document.getElementById("email").focus();
		}
		
		function validateInput()
		{
			var email = document.getElementById("email").value;
			if(email == null || email == "")
			{
				alert('You must specify at least one email address');
				return false;
			}
			
			return true;
		}

		function getSecurityToken(){
			return getQueryString("securityToken");
		}

		//polyFill for URL.getSearchParameter() for IE
		function getQueryString() {
			var key = false, res = {}, itm = null;
			var qs = location.search.substring(1);
			if (arguments.length > 0 && arguments[0].length > 1)
				key = arguments[0];
			var pattern = /([^&=]+)=([^&]*)/g;
			while (itm = pattern.exec(qs)) {
				if (key !== false && decodeURIComponent(itm[1]) === key)
					return decodeURIComponent(itm[2]);
				else if (key === false)
					res[decodeURIComponent(itm[1])] = decodeURIComponent(itm[2]);
			}

			return key === false ? res : null;
		}

		document.addEventListener("DOMContentLoaded", function(event) {
			if(getSecurityToken() != ""){
				document.getElementById("status-link").href = document.getElementById("status-link").href + "?securityToken="+getSecurityToken()
			}
		})
		
	</script>
  </head>
  
  <body onLoad="setEmailFocus();">
  	<div id="header">
  	 	Configure Invalid Credentials Email Notification Addresses
  	 </div>
  	 
  	 <div id="sidebar">
  	 	<div id="sidebar-item">
  	 		<a id="status-link" href="..\index.jsp">ROI Status</a>
  	 	</div>
  	 </div>
  	 
  	 <div id="main-content">
	    <%
	    	if(result != null)
	    	{
	    		%>
	    		<div id="success"><%= result %></div>
	    		<%
	   		}
	    	if(error != null)
	    	{
	    		%>
	    		<div id="error"><%= error %></div>
	    		<%
	   		}		    
	     %>		
	    
	    
	    The VIX will use the following credentials to periodically process ROI requests
	    <form method="POST" action="UpdateInvalidCredentialsEmailNotification" onsubmit="return validateInput()">	    
	    	When the VIX detects an error with the credentials (invalid or expired) the VIX will send an alert email to the following address
	    	<br><input type="text" name="email" id="email" size="50" value="<%= emailConfiguration.getRecipientsForNotificationTypeAsDelimitedString(NotificationTypes.InvalidServiceAccountCredentials) %>"/> (comma separated email addresses)
	    	<br>
	   		<input type="submit" value="Save Configuration"/>
	    </form>
	</div>
	<jsp:include flush="false" page="../footer.html"></jsp:include>
  </body>
</html>
