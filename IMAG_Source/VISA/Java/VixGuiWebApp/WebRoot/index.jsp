<%@ page language="java" pageEncoding="ISO-8859-1"%>
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
		<script type="text/javascript">
			if (document.images) {
				Button1MouseOff = new Image(); Button1MouseOff.src = "/Vix/images/login/Button1.jpg"
				Button1MouseOver = new Image(); Button1MouseOver.src = "/Vix/images/login/Button1MouseOver.jpg"
				Button1MouseDown = new Image(); Button1MouseDown.src = "/Vix/images/login/Button1MouseDown.jpg"
			}
			
			function turnMouseOff(ImageName) {
				if (document.images != null) {
					document[ImageName].src = eval(ImageName + "MouseOff.src");
				}
			}
			
			function turnMouseOver(ImageName) {
				if (document.images != null) {
					document[ImageName].src = eval(ImageName + "MouseOver.src");
				}
			}
			
			function turnMouseDown(ImageName) {
				if (document.images != null) {
					document[ImageName].src = eval(ImageName + "MouseDown.src");
				}
			}
			
		</script>
	</head>
  
	<body id="vista-imaging">
		<div id="pageHeader">
			<h1><span>VIX - VistA Imaging Web Access</span></h1>
		</div>
		<div id="container">
			<div id="supportingText">
				<h3>Image Sharing between the VA and DOD</h3>
				<p class="p1">
				Welcome to the ViX (VistA Imaging Exchange) Server.<br/>
				Please log in in using the "Login" link below.
				</p>
				<a href = "secure/index.jsp" 
					onmouseover="turnMouseOver('Button1')" 
					onmouseout="turnMouseOff('Button1')" 
					onmousedown="turnMouseDown('Button1')">
					<img name="Button1" src="/Vix/images/login/Button1.jpg" alt="login" width="131" height="25" border="0">
				</a>
			</div>
		</div>
		<div id="pageFooter">
			<jsp:include flush="false" page="footer.html"></jsp:include>
		</div>		
	</body>
</html>
