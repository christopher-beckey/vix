<%@ page language="java" import="java.util.*,javax.ws.rs.core.*" pageEncoding="ISO-8859-1"%>
<%
String path = request.getContextPath();
String basePath = request.getScheme()+"://"+request.getServerName()+":"+request.getServerPort()+path+"/";
%>

<!DOCTYPE HTML PUBLIC "-//W3C//DTD HTML 4.01 Transitional//EN">
<html>
  <head>
    <base href="<%=basePath%>">
    
    <title>DicomSCP Control page</title>
	<meta http-equiv="pragma" content="no-cache">
	<meta http-equiv="cache-control" content="no-cache">
	<meta http-equiv="expires" content="0">    
	<meta http-equiv="keywords" content="keyword1,keyword2,keyword3">
	<meta http-equiv="description" content="This is my page">
	<!--
	<link rel="stylesheet" type="text/css" href="styles.css">
	-->
  </head>
  <!-- To call this page: http://localhost:8080/Study/index.jsp -->
  
  <body>
    DicomSCP Server Controls     (c)SCIP, 2020<br>
	<p>
    <script type="text/javascript" language="javascript">
       function ScpStart() {
    	var baseP = "<%= basePath %>";
	    document.getElementById("msg").innerHTML = "Start called...";
 	    window.location.replace(baseP+"scp_start.jsp");
       }
       function ScpStop() {
	    var baseP = "<%= basePath %>";
	    document.getElementById("msg").innerHTML = "Stop called...";
        window.location.replace(baseP+"scp_stop.jsp");
       }
       function refresh() {
    	var baseP = "<%= basePath %>";
        document.getElementById("msg").innerHTML = "Refresh called...";
	    window.location.replace(baseP+"scp_refresh.jsp");
       }
       function always() {
	       return "Click the buttons to start or stop SCP.";
        }
</script>
	Laural Bridge System SCP Server Control Buttons: <p>
	<button type="submit" style="height: 50px; width: 150px; background-color: #e3eaa7" onclick="ScpStart()"><b>Start SCP</b></button><p>
	<button type="submit" style="height: 50px; width: 150px; background-color: #eca1a6" onclick="ScpStop()"><b>Stop SCP</b></button><p>
	<button type="submit" style="height: 50px; width: 150px; background-color: #fefbd8" onclick="refresh()"><b>Refresh Config(tbd)</b></button><p>
	<div id="msg">
	
	</div>
    <script>
       document.getElementById("msg").innerHTML = window.always();
    </script>
  </body>
</html>
