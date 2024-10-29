<%@ page 
	language="java" 
	import="java.util.*" 
	pageEncoding="ISO-8859-1"
	session="false" 
%>
<%@page import="gov.va.med.imaging.transactioncontext.TransactionContext"%>
<%@page import="gov.va.med.imaging.transactioncontext.TransactionContextFactory"%>
<%
	String contextPath = request.getContextPath();
	String imageRelativeUrl = request.getParameter("contextRelativeUrl");
	String basePath = request.getScheme()+"://"+request.getServerName()+":"+request.getServerPort()+contextPath;
	String imageBasePath = request.getScheme()+"://"+request.getServerName()+":"+request.getServerPort()+contextPath;
	String imageUrl = imageBasePath + imageRelativeUrl;
   
%>

<!DOCTYPE HTML PUBLIC "-//W3C//DTD HTML 4.01 Transitional//EN">
<html>
  <head>
    <base href="<%=basePath%>">
    
    <title>VistA Imaging Advanced Web Image Viewer</title>
    
	<meta http-equiv="pragma" content="no-cache">
	<meta http-equiv="cache-control" content="no-cache">
	<meta http-equiv="expires" content="0">    
	<!--
	<link rel="stylesheet" type="text/css" href="styles.css">
	-->

  </head>
  
  <body>
  	<h1>VistA Imaging Sample DICOM Image</h1>
   
	<APPLET
	  CODEBASE = <%= "\"" + contextPath + "/nagoya/classes" + "\"" %>
	  CODE     = "dicomviewer.Viewer.class"
	  NAME     = "viewer"
	  WIDTH    = 100%
	  HEIGHT   = 100%
	  HSPACE   = 0
	  VSPACE   = 0
	  ALIGN    = middle
	>
	    <PARAM NAME = "dicURL" VALUE = <%= basePath + "/Dicom.dic" %> />
	    <PARAM NAME = "imgURL0" VALUE =<%= basePath + "/images/dicom/brain_001.dcm"%> />
	</APPLET>  
  </body>
</html>