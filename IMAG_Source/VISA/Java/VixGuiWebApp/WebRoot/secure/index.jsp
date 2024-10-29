<%@ page language="java" import="java.util.*" pageEncoding="ISO-8859-1"%>
<%@ taglib uri="http://imaging.med.va.gov/vix/menu" prefix="menu"%>
<jsp:directive.page session="false" contentType="text/html" />

<!DOCTYPE HTML PUBLIC "-//W3C//DTD HTML 4.01 Transitional//EN">
<html>
	<head>
		<style type="text/css" media="screen">
		@import url("/Vix/style/screen.css");
		</style>
		   
		<title>VistA Imaging Web Access</title>
		   
		<meta http-equiv="pragma" content="no-cache">
		<meta http-equiv="cache-control" content="no-cache">
		<meta http-equiv="expires" content="0">    
		<meta http-equiv="keywords" content="VistA VIX Imaging">
		<meta http-equiv="description" content="VistA Imaging Web Access">
		
		<jsp:element name="script">
			<jsp:attribute name="type">text/javascript</jsp:attribute>
			<jsp:attribute name="src">../script/menu-for-applications.js</jsp:attribute>
			<jsp:body>
			</jsp:body>
		</jsp:element>
		<jsp:element name="script">
			<jsp:attribute name="type">text/javascript</jsp:attribute>
			<jsp:attribute name="src">../script/vix.js</jsp:attribute>
			<jsp:body>
			</jsp:body>
		</jsp:element>
		
	</head>
  
	<body onload="load();" id="vista-imaging">
		<div id="pageHeader">
			<h1><span>VIX - VistA Imaging Web Access</span></h1>
		</div>
		<menu:Menu 
			menuId="menuModel" menuClass="menu" 
			subMenuClass="mainMenuSubMenu" 
			menuItemClass="mainMenuItem"
			menuDivId="menuDiv" />
		<div id="container">
			<div id="supportingText">
				<p class="p1">
				The VIX service is running.
				</p>
			</div>
			<!-- 
			// Creates canvas 640 × 480 at 10, 50
			var paper = Raphael(10, 50, 640, 480);
			// Creates pie chart at with center at 320, 200, radius 100
			// and data: [55, 20, 13, 32, 5, 1, 2, 10]
			r.g.piechart(320, 240, 100, [55, 20, 13, 32, 5, 1, 2, 10]);
			 -->
		</div>
		<div id="pageFooter">
			<jsp:include flush="false" page="../footer.html"></jsp:include>
		</div>		
	</body>
</html>
