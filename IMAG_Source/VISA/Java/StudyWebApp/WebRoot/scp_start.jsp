<%@ page language="java" import="java.util.*,javax.ws.rs.core.*" pageEncoding="ISO-8859-1"%>
<%
String path = request.getContextPath();
String basePath = request.getScheme()+"://"+request.getServerName()+":"+request.getServerPort()+path+"/";
%>

<!DOCTYPE HTML PUBLIC "-//W3C//DTD HTML 4.01 Transitional//EN">
<html>
  <head>
    <base href="<%=basePath%>">
    
    <title>StudyWebApp JSP Starting DicomSCP</title>
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
    This page is for starting DicomSCP services. (c)SCIP, 2020<br>
	<p>
	<%
	   String szStart = gov.va.med.imaging.study.lbs.DicomScp.start();
	   out.println( "Result: " + szStart );
	   out.println( "<script>\nlocalStorage.setItem(\"favoriteMovie\", \"" + szStart + "\");\n</script>" );
	%>
	
    <script type="text/javascript" language="javascript">
       function pageRedirect() {
	      var baseP = "<%= basePath %>";
	      window.location.replace(baseP+"scp_control.jsp");
       }      
       setTimeout("pageRedirect()", 3000);
    </script>

  </body>
</html>
