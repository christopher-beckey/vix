<%@page import="gov.va.med.imaging.transactioncontext.TransactionContext"%>
<%@page import="gov.va.med.imaging.transactioncontext.TransactionContextFactory"%>
<%@page import="gov.va.med.imaging.health.VisaConfigurationProperty"%>
<%@page import="gov.va.med.imaging.health.VisaConfiguration"%>
<%@page import="gov.va.med.imaging.health.VisaConfigurationType"%>
<%@page import="gov.va.med.imaging.StringUtil"%>
<%@ page language="java" import="java.util.*" pageEncoding="ISO-8859-1"%>
<%
String path = request.getContextPath();
String basePath = request.getScheme()+"://"+request.getServerName()+":"+request.getServerPort()+path+"/";
TransactionContext transactionContext = TransactionContextFactory.get();
%>

<!DOCTYPE HTML PUBLIC "-//W3C//DTD HTML 4.01 Transitional//EN">
<html>
  <head>
    <base href="<%=basePath%>">
    
    <title>VISA Libs (<%= transactionContext.getRealm() %>)</title>
    
	<meta http-equiv="pragma" content="no-cache">
	<meta http-equiv="cache-control" content="no-cache">
	<meta http-equiv="expires" content="0">    
	<meta http-equiv="keywords" content="keyword1,keyword2,keyword3">
	<meta http-equiv="description" content="This is my page">
	

  </head>
  
  <body>
	
	<% 
	 	String configurationType = request.getParameter("configurationType");
		VisaConfigurationType visaConfigurationType = VisaConfigurationType.tomcatLib;
		if(configurationType != null && configurationType.length() > 0)
			visaConfigurationType = VisaConfigurationType.valueOf(configurationType);
			
		boolean calculateChecksum = false;
		String calculateChecksumParameter = request.getParameter("checksum");
		if(calculateChecksumParameter != null && calculateChecksumParameter.length() > 0)
			calculateChecksum = Boolean.parseBoolean(calculateChecksumParameter);
	 
		VisaConfiguration visaConfiguration = 
			VisaConfiguration.getVisaConfiguration(visaConfigurationType, 
			calculateChecksum); 
		 
	 
	 %>
	 <h1>VISA Configuration Libs (<%= transactionContext.getRealm() %>)</h1>
	 <table border="1">
	 	<tr>
	 		<th>Name</th>
	 		<th>Date Modified</th>
	 		<th>Size</th>
	 		<th>Checksum</th>
	 	</tr>
	 	
	 	<%
	 	for(VisaConfigurationProperty property : visaConfiguration.getVisaConfigurationProperties())
	 	{
	 		%>
	 			<tr>
	 				<%-- Fortify change: added clean string (showed red "X" but built OK on command line) --%>
	 				<td><%= StringUtil.cleanString(property.getName()) %></td>
	 				<td><%= StringUtil.cleanString(property.getModifiedFormatted()) %></td>
	 				<td><%= property.getSize() %></td>
	 				<td><%= (property.getChecksum() == null ? "&nbsp;" : "" + property.getChecksum()) %></td>
	 			</tr>
	 		<%
	 	}
	 	 %>
	 	
	 </table>
	
	    
  </body>
</html>
