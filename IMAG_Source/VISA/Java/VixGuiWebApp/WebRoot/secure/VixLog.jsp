<%@ page language="java"
		 import="java.util.*, java.text.*, gov.va.med.imaging.DateUtil, gov.va.med.imaging.StringUtil, 
		 gov.va.med.imaging.exchange.enums.*, gov.va.med.imaging.transactionlogger.datasource.TransactionLoggerJdbcSourceService"
		 pageEncoding="ISO-8859-1"%>

<%@ taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c"%>
<%@ taglib uri="http://imaging.med.va.gov/vix/business" prefix="business"%>
<%@ taglib uri="http://imaging.med.va.gov/vix/transactionlogs" prefix="log"%>
<%@ taglib uri="http://imaging.med.va.gov/vix/menu" prefix="menu"%>

<jsp:directive.page session="false" contentType="text/html" />

<%
	String contextPath = request.getContextPath();
	String servletPath = request.getServletPath();
	
	StringBuilder sb = new StringBuilder(request.getScheme());
	sb.append("://");
	sb.append(request.getServerName());
	sb.append(":");
	sb.append(request.getServerPort());
	sb.append(contextPath);
	
	String basePath = sb.toString();
	
	// Need to be in this format for moment.js to work properly
	DateFormat dfDateTime = new SimpleDateFormat("yyyy-MM-dd HH:mm");

	Date fromDate = DateUtil.todayISOFormat(new Date(), true);
	String fromDateParam = request.getParameter("fromDate");
	String resetFromDate = dfDateTime.format(fromDate);

	if(!StringUtil.isEmpty(fromDateParam)) {
		try {
			fromDate = dfDateTime.parse(fromDateParam);
		} catch (java.text.ParseException e) {
			// Default to today's date and "begin" time: 0 hour and min
			fromDateParam = dfDateTime.format(fromDate);
		}
	} else
		fromDateParam = dfDateTime.format(fromDate);

	Date toDate = DateUtil.todayISOFormat(new Date(), false);
	String toDateParam = request.getParameter("toDate");
	String resetToDate = dfDateTime.format(toDate);
	
	if(!StringUtil.isEmpty(toDateParam)) {
		try {
			toDate = dfDateTime.parse(toDateParam);
		} catch (java.text.ParseException e) {
			// Default to today's date and "end" time: 23 hour and 59 min
			toDateParam = dfDateTime.format(toDate);
		}
	} else
		toDateParam = dfDateTime.format(toDate);

	// Add for VAI-1224
	// No easy way get the total count once even with hidden field to keep track
	int totalCount = new TransactionLoggerJdbcSourceService().getCountByDateRange(fromDate, toDate);
	
	String imageQualityParam = request.getParameter("imageQuality");
	ImageQuality imageQuality = null;
	if(!StringUtil.isEmpty(imageQualityParam)) {
		try {
			imageQuality = ImageQuality.valueOf(imageQualityParam);
		} catch(IllegalArgumentException iaX) {}
	}
	
	String user = request.getParameter("user");
	String modality = request.getParameter("modality");

	String datasourceProtocolParam = request.getParameter("datasourceProtocol");
	DatasourceProtocol datasourceProtocol = null;
	if(!StringUtil.isEmpty(datasourceProtocolParam)) {
		try { 
			datasourceProtocol = DatasourceProtocol.valueOf(datasourceProtocolParam); 
		} catch(IllegalArgumentException iaX) {/*Ignore*/}
	}

	String errorMessage = request.getParameter("errorMessage");
	String transactionId = request.getParameter("transactionId");
	String imageUrn = request.getParameter("imageUrn");
	
	String forwardIterationParam = request.getParameter("forwardIteration");
	Boolean forwardIteration = !StringUtil.isEmpty(forwardIterationParam) ? Boolean.parseBoolean(forwardIterationParam) : Boolean.FALSE;

	String startIndexParam = request.getParameter("startIndex");
	int startIndex = !StringUtil.isEmpty(startIndexParam) && StringUtil.isNumeric(startIndexParam) ? Integer.parseInt(startIndexParam) : 0;

	String resultsPerPageParam = request.getParameter("resultsPerPage");
	Integer requestResultsPerPage = !StringUtil.isEmpty(resultsPerPageParam) && StringUtil.isNumeric(resultsPerPageParam) ? new Integer(resultsPerPageParam) : new Integer(100);
	
	int endIndex = startIndex + requestResultsPerPage;

	String byteTransferPathParam = request.getParameter("byteTransferPath");
	ByteTransferPath byteTransferPath = null;
	if(!StringUtil.isEmpty(byteTransferPathParam)) {
		try { 
			byteTransferPath = ByteTransferPath.valueOf(byteTransferPathParam); 
		} catch(IllegalArgumentException iaX) {/*Ignore*/}
	} else 
		byteTransferPath = ByteTransferPath.DS_IN_FACADE_OUT;
	
	String debugValue = request.getParameter("debug");
	boolean debug = !StringUtil.isEmpty(debugValue) ? Boolean.parseBoolean(debugValue) : false;
%>

<html>
<!--
	Notes from the JSP Spec (syntax examples have added whitespace to prevent recognition as
	directives or elements).

	A JSP page has elements and template data. An element is an instance of an element
	type known to the JSP container. Template data is everything else; that is, anything
	that the JSP translator does not know about.
	There are three types of elements: directive elements, scripting elements, and
	action elements.
	Directives "< %@ directive...%>" provide global information that is conceptually valid independent
	of any specific request received by the JSP page. They provide information for
	the translation phase.
	Action elements follow the syntax of an XML element.  Actions provide information for the request
	processing phase.  An action may create objects and may make them available to the scripting elements
	through scripting-specific variables.
	Scripting Elements EL expressions use the syntax ${expr}.  JSP 2.0 retains the three language-based
	types of scripting elements: declarations, scriptlets, and expressions.
	Declarations follow the syntax < %! ... %>.
	Scriptlets follow the syntax < % ... %>.
	Expressions follow the syntax < %= ... %>.

	A context-relative path is a path that starts with a slash (/). It is to be interpreted
	as relative to the application to which the JSP page or tag file belongs.
	A page relative path is a path that does not start with a slash (/). It is to be interpreted
	as relative to the current JSP page, or the current JSP file or tag file, depending on where the path is being used.

	A JSP Document is a JSP page that is also an XML document. When a JSP document is encountered by
	the JSP container, it is interpreted as an XML document first and after that as a JSP page.
	-->

<head>
	<meta http-equiv="pragma" content="no-cache"/>
	<meta http-equiv="cache-control" content="no-cache"/>
	<meta http-equiv="expires" content="0"/>
	<meta http-equiv="keywords" content="Vista VIX Imaging Transaction"/>
	<meta http-equiv="description" content="VistA Imaging Web Access Transaction"/>

	<style type="text/css" title="currentStyle">
		@import url(../style/screen1.css);
	</style>
	<!-- addition below for a custom css for IE 7-8, and text-printing in FireFox 3.x  7/31/09 -->
	<link rel="stylesheet" type="text/css" media="print" href="../style/printer_friendly1.css" />
	
	
	<!--[if gte IE 7]>
	<style type="text/css" title="currentStyle">
		@import url(../style/screenie1.css);
	</style>
	<![endif]-->
	<!--for print preview in IE 7-8 (minimum)-->
	<!--[if gte IE 7]>
	<link rel="stylesheet" type="text/css" media="print" href="../style/printerie1.css" />
	<![endif]-->
	<title>Vix - Transaction Log (client)</title>
 
    <link rel="stylesheet" type="text/css" href="../style/jquery.datetimepicker-2.5.1.css">
    
    <script src="../script/jquery-3.5.1.min.js" /></script>
	
	<script src="../script/moment.js" /></script>
    
    <script src="../script/browser.js" ></script>
    
    <script src="../script/jquery.datetimepicker-2.5.1.full.min.js" ></script>
	
	<script>
		
		/**
		 * DHTML date validation script. Courtesy of SmartWebby.com (http://www.smartwebby.com/dhtml/)
		 * Enhanced 1-20-2010 to check date range and to avoid pop-up windows.
		 * Reworked in a few areas and cleaned up 01/23/2023
		 */

		function daysInFebruary (year) {
			
			// February has 29 days in any year evenly divisible by four,
			// EXCEPT for centurial years which are not also divisible by 400.
			return (((year % 4 == 0) && ( (!(year % 100 == 0)) || (year % 400 == 0))) ? 29 : 28 );
		}
		
		function daysArray(n) {
			for (var i = 1; i <= n; i++) {
				this[i] = 31;
				if (i == 4 || i == 6 || i == 9 || i == 11) 
					{this[i] = 30};
				if (i == 2) 
					{this[i] = 29};
			}
			return this
		}

		function isDateTimeValid(whichDate) {
			
			var defaultDate = whichDate == 'fromDate' ? '<%= org.apache.commons.lang.StringEscapeUtils.escapeXml(resetFromDate) %>'
													  : '<%= org.apache.commons.lang.StringEscapeUtils.escapeXml(resetToDate) %>';
													   
			var givenDateTime = document.getElementById(whichDate);
			
			/* The 'onchange' event fires twice: one for the origional change and one for setting to default date.
			   Need this if to stop unnecessary processing after defaulting
			*/
			if(givenDateTime.value == defaultDate)
				return true;
			
			if(givenDateTime.value.length != 16) {
				alert("The date and time format should be 'yyyy-mm-dd HH:mm'.");
				givenDateTime.value = defaultDate;
				return false;
			}

			if(!isDateValid(givenDateTime.value) || !isTimeValid(givenDateTime.value)) {
				givenDateTime.value = defaultDate;
				givenDateTime.focus();
				return false;
			}
			
			return true;
		}
		
		function isDateValid(dateStr) {
			
			var dateSeparator = "-";
			var dateSeparatorPos1 = dateStr.indexOf(dateSeparator);
			var dateSeparatorPos2 = dateStr.indexOf(dateSeparator, dateSeparatorPos1 + 1);
			
			var daysInMonth = daysArray(12);
			
			var strMonth = dateStr.substring(dateSeparatorPos1 + 1, dateSeparatorPos1 + 3);
			var strDay = dateStr.substring(dateSeparatorPos2 + 1, dateSeparatorPos2 + 3);
			var strYear = dateStr.substring(0, 4);

			strYr = strYear;
			
			if (strDay.charAt(0) == "0" && strDay.length > 1) 
				strDay = strDay.substring(1);
			
			if (strMonth.charAt(0) == "0" && strMonth.length > 1) 
				strMonth = strMonth.substring(1);
			
			for (var i = 1; i <= 3; i++)
				if (strYr.charAt(0) == "0" && strYr.length > 1) 
					strYr = strYr.substring(1);
		
			month = parseInt(strMonth);
			day = parseInt(strDay);
			year = parseInt(strYr);
			
			if (isNaN(strMonth) || strMonth.length < 1 || month < 1 || month > 12) {
				alert("Please enter a valid 2-digits month between 1 and 12");
				return false;
			}
			
			if (isNaN(strDay) || strDay.length < 1 || day < 1 || day > 31 || (month == 2 && day > daysInFebruary(year)) || day > daysInMonth[month]) {
				alert("Please enter a valid 2-digits day between 1 and 31");
				return false;
			}
			
			var minYear = new Date().getFullYear() - 100;
			var maxYear = new Date().getFullYear();
			
			if (isNaN(strYear) || strYear.length != 4 || year == 0 || year < minYear || year > maxYear) {
				alert("Please enter a valid 4-digits year between " + minYear + " and " + maxYear);
				return false;
			}
			
			return true;
		}
	
		function isTimeValid(dateStr) {
			
			var dateTimeSeparatorPos = dateStr.indexOf(" ");
			var hrMinSeparatorPos = dateStr.indexOf(":");

			var hourMinute = dateStr.substring(dateTimeSeparatorPos + 1, dateTimeSeparatorPos + 5);
			
			var strHour = dateStr.substring(dateTimeSeparatorPos + 1, dateTimeSeparatorPos + 3);
			var strMinute = dateStr.substring(hrMinSeparatorPos + 1, hrMinSeparatorPos + 3);
					
			if (strHour.charAt(0) == "0" && strHour.length > 1) 
				strHour = strHour.substring(1);
			
			if (strMinute.charAt(0) == "0" && strMinute.length > 1) 
				strMinute = strMinute.substring(1);
		
			var hour = parseInt(strHour);
			var minute = parseInt(strMinute);

			if (isNaN(strHour) || hour > 23) {
				alert("Please enter a valid 2-digits hour between 1 and 23");
				return false;
			}

			if (isNaN(strMinute) || minute > 59) {
				alert("Please enter valid a valid 2-digits minute between 0 and 59");
				return false;
			}
			
			return true;
		}

		function getCurrentPageStartIndex() {
			
			var startIndexElement = document.getElementById('startIndex');
			
			if(startIndexElement && startIndexElement.value && startIndexElement.value != '')
				return parseInt(startIndexElement.value);
			
			return 0;
		}
		
		function getCurrentPageEndIndex() {
			
			var endIndexElement = document.getElementById('endIndex');
			
			if(endIndexElement && endIndexElement.value && endIndexElement.value != '')
				return parseInt(endIndexElement.value);
			
			// Should return this value instead of the default 100
			return getSelectedResultsPerPage();
		}
		
		function getSelectedResultsPerPage() {
			
			var resultsSelectElement = document.getElementById('resultsPerPage');
			var selectedIndex = resultsSelectElement.selectedIndex;
			
			return parseInt(resultsSelectElement.options[selectedIndex].value);
		}
		
		// The following functions do the HTML GET requests.
		function move(startIndex, endIndex) {
			
			document.getElementById('transactionLogSearchCriteria').action = "<%= contextPath + servletPath %>";
			document.getElementById('format').value = 'text/html';
			document.getElementById('startIndex').value = startIndex;
			document.getElementById('endIndex').value = endIndex;
			document.getElementById('transactionLogSearchCriteria').submit();
		}
		
		function nextPage() {

			move(getCurrentPageEndIndex(), getCurrentPageEndIndex() + getSelectedResultsPerPage());
		}
		
		function previousPage() {

			move(getCurrentPageStartIndex() - getSelectedResultsPerPage(), getCurrentPageStartIndex());
		}
		
		function lastPage() {
			
			var totalCount = <%= totalCount %>;			
			move(totalCount - (totalCount % getSelectedResultsPerPage()), totalCount);
		}
		
		// Start out as "enable" --> disabled = true --> off; = false --> on
		function updateNav() {

			var resultsPerPage = getSelectedResultsPerPage();
			var totalCount = <%= totalCount %>;
			var currentPageStartIndex = getCurrentPageStartIndex();
			var currentPageEndIndex = getCurrentPageEndIndex();
			// left over from even multiple of results per page, e.g., 56 % 25 = 6
			var remainder = totalCount % resultsPerPage;
			
			// First (landing) page
			if(resultsPerPage >= totalCount) {
				
				document.getElementById("firstPageBtnTop").disabled = true;
				document.getElementById("prevPageBtnTop").disabled = true;
				document.getElementById("nextPageBtnTop").disabled = true;
				document.getElementById("lastPageBtnTop").disabled = true;
				
				document.getElementById("firstPageBtnBottom").disabled = true;
				document.getElementById("prevPageBtnBottom").disabled = true;
				document.getElementById("nextPageBtnBottom").disabled = true;
				document.getElementById("lastPageBtnBottom").disabled = true;

				return true;
			}
			
			//alert("currentPageStartIndex = " + currentPageStartIndex + ", currentPageEndIndex = " + currentPageEndIndex + ", totalCount = " + totalCount + ", remainder = " + remainder);
			
			// Click on other buttons and in any order to turn on/off appropriate button(s)
			if(resultsPerPage > remainder) {
				
				var boolDisabledNext = (totalCount - remainder) == (currentPageStartIndex + resultsPerPage);
				var boolDisabledPrev = (currentPageEndIndex - resultsPerPage) === 0;
				
				document.getElementById("prevPageBtnTop").disabled = (currentPageStartIndex === 0) || boolDisabledPrev;
				document.getElementById("firstPageBtnTop").disabled = currentPageStartIndex === 0;
				
				document.getElementById("prevPageBtnBottom").disabled = (currentPageStartIndex === 0) || boolDisabledPrev;
				document.getElementById("firstPageBtnBottom").disabled = currentPageStartIndex === 0;

				if(totalCount >= currentPageEndIndex) {
					
					document.getElementById("nextPageBtnTop").disabled = boolDisabledNext;
					document.getElementById("lastPageBtnTop").disabled = false;
					
					document.getElementById("nextPageBtnBottom").disabled = boolDisabledNext;
					document.getElementById("lastPageBtnBottom").disabled = false;

				} else {
					
					document.getElementById("nextPageBtnTop").disabled = true;
					document.getElementById("lastPageBtnTop").disabled = true;
					
					document.getElementById("nextPageBtnBottom").disabled = true;
					document.getElementById("lastPageBtnBottom").disabled = true;
				}
			}
					
			return true;
		}

		/*  Send an HTTP request for Excel, CSV and TSV formatted transaction logs.
			QN: reworked to include "Show in Browser"/"first page" as well
		*/
		function submitForm(mimeType) {
			
			var fromDate = document.getElementById('fromDate');
			var toDate = document.getElementById('toDate');

			if (moment(fromDate.value).isAfter(toDate.value)) {
				alert("'from date' value is after 'to date' value. Will flip values.");
				var startDateValuetemp = toDate.value;
				var endDateValuetemp = fromDate.value;
				fromDate.value = startDateValuetemp;
				toDate.value = endDateValuetemp;
				
				/* DON'T DO THIS - ENDLESS 'onchange' EVENT FIRING WILL HAPPEN FOR SOME REASON
					fromDate.focus();
				*/
				
				return false;
			} else if (mimeType.length == 0) {
				move(0, getSelectedResultsPerPage());
			} else {
				document.getElementById('transactionLogSearchCriteria').action = 'ExcelTransactionLog';
				document.getElementById('format').value = mimeType;
				document.getElementById('transactionLogSearchCriteria').submit();
			}
		}
		
		function resetSearchCriteria() {
			
			document.getElementById('transactionLogSearchCriteria').reset();
			document.getElementById('fromDate').value = '<%= org.apache.commons.lang.StringEscapeUtils.escapeXml(resetFromDate) %>';
			document.getElementById('toDate').value = '<%= org.apache.commons.lang.StringEscapeUtils.escapeXml(resetToDate) %>';
		}
		
		// Context Help Pop-up
		var helpSubjectElement = null;
		var helpContentElement = null;

		// regexElementId - the ID of the element that is the subject of the help
		// regexHelpElementId - the ID of the help element (the one that contains the help text)
		function showHelp(helpSubjectElementId, helpContentElementId) {
			
			helpSubjectElement = document.getElementById(helpSubjectElementId);
			helpContentElement = document.getElementById(helpContentElementId);
			helpContentElement.style.top = (browserSniffer.getElementTop(helpSubjectElementId) + 10) + 'px'
			helpContentElement.style.left = (browserSniffer.getElementLeft(helpSubjectElementId) + browserSniffer.getElementWidth(helpSubjectElementId) + 100) + 'px';
			helpContentElement.style.visibility = "visible";
		}

		function hideHelp()	{
			
			helpContentElement.style.visibility = "hidden";
			helpSubjectElement = null;
			helpContentElement = null;
		}

		function setHelpField(value) {
			
			helpSubjectElement.value = value;
		}
		
		function appendHelpField(value) {
			
			helpSubjectElement.value = helpSubjectElement.value + value;
		}

		// methods to change the displayed images on mouse events
		function turnMouseOff(ImageName) {
			
			document.images[ImageName].src = eval(ImageName + "MouseOff.src");
		}

		function turnMouseDown(ImageName) {
			
			document.images[ImageName].src = eval(ImageName + "MouseDown.src");
		}
		
	</script>


</head>
<body id="vix-transaction">

<% System.out.println( "totalCount from request = " + request.getParameter("totalCount") ); %>

<div id="pageHeader">
	<h1><span>&nbsp;VIX - Transaction Log (client)</span></h1>
</div>
<div id="container">
	<div id="selection">
		<h1>Transaction Log Filter</h1>
	</div>
	<hr>
	<form id="transactionLogSearchCriteria" action=<%= "\"" + servletPath + "\""%> method="GET">
		<!--
        The startIndex and endIndex elements are the indexes of the currently displayed page.
        The script that submits this form will push values into these elements immediately
        before submitting the form, which get passed as query parameters.
        The resultsPerPage query parameter is set from a select element within this form.
        The aforementioned script (that submits this form) uses the resultsPerPage
        element to calculate the requested start and end index.  Other than that the
        resultsPerPage is simply passed back and forth between browser and server so
        that it remains durable.
        -->
		<!-- Fortify change: used straight, removed c:out -->
		<input type="hidden" id="startIndex" name="startIndex" value="<%= org.apache.commons.lang.StringEscapeUtils.escapeXml("" + startIndex) %>" />
		<input type="hidden" id="endIndex" name="endIndex" value="<%= org.apache.commons.lang.StringEscapeUtils.escapeXml("" + endIndex) %>" />
		<input type="hidden" id="format" name="format" value=""/>
		<input type="hidden" id="totalCount" name="totalCount" value="<%= org.apache.commons.lang.StringEscapeUtils.escapeXml("" + totalCount) %>" />
		
		<div id = "dateInputs">
			<div id="dateInputs">
			<table>
				<tr>
					<td width="50%">
						<label for="fromDate">From Date/Time&nbsp:&nbsp </label>
						<input type="text" size = 12 maxlength = 16 class = "datetimepicker" id="fromDate" name="fromDate" tabindex="1"
								value="<%= org.apache.commons.lang.StringEscapeUtils.escapeXml(fromDateParam) %>" onchange="isDateTimeValid('fromDate')"/></td>
				</tr>
				<tr></tr><tr></tr>
				<tr>
					<td width="50%">
						<label for="toDate">To Date/Time&nbsp &nbsp &nbsp:&nbsp&nbsp </label>
						<input type="text" size = 12 maxlength = 16 class = "datetimepicker" id="toDate" name="toDate" tabindex="2"
								value="<%= org.apache.commons.lang.StringEscapeUtils.escapeXml(toDateParam) %>" onchange="isDateTimeValid('toDate')"/></td>
				</tr>
			</table>
			
			<script>
			
				$('.datetimepicker').each(function(){
					$(this).datetimepicker({
						format:"Y-m-d H:i",
						step:15,
						yearStart: new Date().getFullYear() - 100,
						yearEnd: new Date().getFullYear(),
						maxDate: new Date()
					});
				});
				
				
			</script> 		
				
		</div>

		<c:set var="transactionPerPage" value="${param.resultsPerPage}"/>
		<div id="transactions">
			<label for="resultsPerPage">Transactions per Page&nbsp:&nbsp</label>
			<select id="resultsPerPage" name="resultsPerPage"/>
			<c:choose>
				<c:when test="${transactionPerPage == '25'}">
					<jsp:element name="option">
						<jsp:attribute name="value">25</jsp:attribute>
						<jsp:attribute name="selected">selected</jsp:attribute>
						<jsp:body>25</jsp:body>
					</jsp:element>
				</c:when>
				<c:otherwise>
					<jsp:element name="option">
						<jsp:attribute name="value">25</jsp:attribute>
						<jsp:body>25</jsp:body>
					</jsp:element>
				</c:otherwise>
			</c:choose>
			<c:choose>
				<c:when test="${transactionPerPage == '100' || empty param.resultsPerPage}">
					<jsp:element name="option">
						<jsp:attribute name="value">100</jsp:attribute>
						<jsp:attribute name="selected">selected</jsp:attribute>
						<jsp:body>100</jsp:body>
					</jsp:element>
				</c:when>
				<c:otherwise>
					<jsp:element name="option">
						<jsp:attribute name="value">100</jsp:attribute>
						<jsp:body>100</jsp:body>
					</jsp:element>
				</c:otherwise>
			</c:choose>
			<c:choose>
				<c:when test="${transactionPerPage == '250'}">
					<jsp:element name="option">
						<jsp:attribute name="value">250</jsp:attribute>
						<jsp:attribute name="selected">selected</jsp:attribute>
						<jsp:body>250</jsp:body>
					</jsp:element>
				</c:when>
				<c:otherwise>
					<jsp:element name="option">
						<jsp:attribute name="value">250</jsp:attribute>
						<jsp:body>250</jsp:body>
					</jsp:element>
				</c:otherwise>
			</c:choose>
			<c:choose>
				<c:when test="${transactionPerPage == '1000'}">
					<jsp:element name="option">
						<jsp:attribute name="value">1000</jsp:attribute>
						<jsp:attribute name="selected">selected</jsp:attribute>
						<jsp:body>1000</jsp:body>
					</jsp:element>
				</c:when>
				<c:otherwise>
					<jsp:element name="option">
						<jsp:attribute name="value">1000</jsp:attribute>
						<jsp:body>1000</jsp:body>
					</jsp:element>
				</c:otherwise>
			</c:choose>
			</select>
			
		</div>
		<hr><br/>
		<div id="showButtons">
			<table border="0" width="700">
				<tr>
					<td><input type="button" style="width:150;height:30;display:inline" value="Show in Browser" onclick="submitForm('');"/></td>
					<td><input type="button" style="width:150;height:30;display:inline" value="Save as CSV" onclick="submitForm('text/csv');" alt="SaveAsCSV"/></td>
					<td><input type="button" style="width:150;height:30;display:inline" value="Save as TSV" onclick="submitForm('text/tab-separated-values');" alt="SaveAsTSV"/></td>
					<td><input type="button" style="width:150;height:30;display:inline" value="Reset" onclick="resetSearchCriteria();" alt="Reset"/></td>
				</tr>
			</table>
		</div>
		<br/><hr>
		
		<div id="supportingText">
			<div id="dateRange">
				<h1>Transaction(s) - from <%= org.apache.commons.lang.StringEscapeUtils.escapeXml(fromDateParam) %> to <%= org.apache.commons.lang.StringEscapeUtils.escapeXml(toDateParam) %></h1>
			</div>
			<div id="navigation"> 
				<table border="0" cellspacing="0">
					<tr>
						<td><input id="firstPageBtnTop" type="button"  style="width:50;height:20;display:inline" value="First" onclick="submitForm('');" alt="First Page"/></td>
						<td><input id="prevPageBtnTop" type="button"  style="width:50;height:20;display:inline" value="Prev" onclick="previousPage();" alt="Previous Page"/></td>
						<td><input id="nextPageBtnTop" type="button"  style="width:50;height:20;display:inline" value="Next" onclick="nextPage();" alt="Next Page"/></td>
						<td><input id="lastPageBtnTop" type="button"  style="width:50;height:20;display:inline" value="Last" onclick="lastPage();" alt="Last Page"/></td>
					</tr>
				</table>
			 </div>
			<!-- start of inner wrap, 7-15-09 -->
			<div class="innerwrap">
				<table>
					<tr>
						<th>Date and Time</th>
						<th>Time on ViX (msec)</th>
						<th>ICN</th>
						<th>Query Type</th>
						<th>Query Filter</th>
						<th>Asynchronous?</th>
						<th>Items Returned</th>
						<th>Items Received</th>
						<th>Bytes Returned</th>
						<th>Bytes Received</th>
						<th>Throughput (KB/sec)</th>
						<th>Quality</th>
						<th>Command Class Name</th>
						<th>Originating IP Address</th>
						<th>User</th>
						<th>Application Name from Security Token</th>
						<th>Item in cache?</th>
						<th>Error Message</th>
						<th>Modality</th>
						<th>Purpose of Use</th>
						<th>Datasource Protocol</th>
						<th>Response Code</th>
						<th>Realm Site Number</th>
						<th>URN</th>
						<th>Transaction Number</th>
						<th>Vix Software Version</th>
						<th>VistA Login Method</th>
						<th>Client Version</th>
						<th>Data Source Method</th>
						<th>Data Source Version</th>
						<th>Data Source Response Server</th>
						<th>VIX Site Number</th>
						<th>Requesting VIX Site Number</th>
						<%
							if(debug)
							{
								out.print("<th>Thread ID</th>");
								out.print("<th>Debug Information</th>");
							}
						%>
					</tr>
					<log:TransactionLog
							startDate="<%= fromDate %>"
							endDate="<%= toDate %>"
							quality="<%= imageQuality %>"
							user="<%= user %>"
							modality="<%= modality %>"
							datasourceProtocol="<%= datasourceProtocol %>"
							errorMessage="<%= errorMessage %>"
							transactionId="<%= transactionId  %>"
							imageUrn="<%= imageUrn %>"
							startIndex="<%= startIndex %>"
							endIndex="<%= endIndex %>"
							forward="<%= forwardIteration %>"
							emptyResultMessage="No transaction log entries."
							byteTransferPath="<%= byteTransferPath %>">
						<log:TransactionLogEntries>
					<tr>
						<log:TransactionLogEntry>
						<td><log:TransactionLogEntryStartTime dateFormatPattern="MM/dd/yyyy hh:mm:ss a"/>&nbsp;</td>
						<td><log:TransactionLogEntryElapsedTime/>&nbsp;</td>
						<td><log:TransactionLogEntryPatientICN/>&nbsp;</td>
						<td><log:TransactionLogEntryQueryType/>&nbsp;</td>
						<td><log:TransactionLogEntryQueryFilter/>&nbsp;</td>
						<td><log:TransactionLogEntryAsynchronousCommand/>&nbsp;</td>
						<td><log:TransactionLogEntryItemCount/>&nbsp;</td>
						<td><log:TransactionLogEntryReceivedCount/>&nbsp;</td>

									<!-- For some reason, below test is no longer working. Research is in progress...
									<c:choose>
										<c:when test="${byteTransferPath == ByteTransferPath.DS_IN_FACADE_OUT}">
											<td><log:TransactionLogEntryBytesTransferred byteTransferType="<%= ByteTransferType.FACADE_BYTES_SENT %>"/>&nbsp;</td>
											<td><log:TransactionLogEntryBytesTransferred byteTransferType="<%= ByteTransferType.DATASOURCE_BYTES_RECEIVED %>"/>&nbsp;</td>
											<td><log:TransactionLogEntryImageThroughput byteTransferType="<%= ByteTransferType.FACADE_BYTES_SENT %>"/>&nbsp;</td>
										</c:when>
										<c:otherwise>
											<td><log:TransactionLogEntryBytesTransferred byteTransferType="<%= ByteTransferType.DATASOURCE_BYTES_SENT %>"/>&nbsp;</td>
											<td><log:TransactionLogEntryBytesTransferred byteTransferType="<%= ByteTransferType.FACADE_BYTES_RECEIVED %>"/>&nbsp;</td>
											<td><log:TransactionLogEntryImageThroughput byteTransferType="<%= ByteTransferType.FACADE_BYTES_RECEIVED %>"/>&nbsp;</td>
										</c:otherwise>
									</c:choose>
									-->
						<td><log:TransactionLogEntryBytesTransferred byteTransferType="<%= ByteTransferType.FACADE_BYTES_SENT %>"/>&nbsp;</td>
						<td><log:TransactionLogEntryBytesTransferred byteTransferType="<%= ByteTransferType.DATASOURCE_BYTES_RECEIVED %>"/>&nbsp;</td>
						<td><log:TransactionLogEntryImageThroughput byteTransferType="<%= ByteTransferType.FACADE_BYTES_SENT %>"/>&nbsp;</td>

						<td><log:TransactionLogEntryQuality/>&nbsp;</td>
						<td><log:TransactionLogEntryCommandClassName/>&nbsp;</td>
						<td><log:TransactionLogEntryOriginatingHost/>&nbsp;</td>
						<td><log:TransactionLogEntryUser/>&nbsp;</td>
						<td><log:TransactionLogEntrySecurityTokenApplicationName/>&nbsp;</td>
						<td><log:TransactionLogEntryCacheHit/>&nbsp;</td>
						<td><log:TransactionLogEntryErrorMessage/>&nbsp;</td>
						<td><log:TransactionLogEntryModality/>&nbsp;</td>
						<td><log:TransactionLogEntryPurposeOfUse/>&nbsp;</td>
						<td><log:TransactionLogEntryDatasourceProtocol/>&nbsp;</td>
						<td><log:TransactionLogEntryResponseCode/>&nbsp;</td>
						<td><log:TransactionLogEntryRealmSiteNumber/>&nbsp;</td>
						<td><log:TransactionLogEntryURN/>&nbsp;</td>
						<td>
										<% if(debug)
										{
										%>
										<a href="VixLogViewTransaction.jsp?transactionId=<log:TransactionLogEntryTransactionID/>"><log:TransactionLogEntryTransactionID/></a>
										<%
										}
										else
										{
										%>
										<log:TransactionLogEntryTransactionID/>&nbsp;
										<%
											}
										%>
						</td>
									<td><log:TransactionLogEntryVixSoftwareVersion/>&nbsp;</td>
									<td><log:TransactionLogEntryRemoteLoginMethod/>&nbsp;</td>
									<td><log:TransactionLogEntryClientVersion/>&nbsp;</td>
									<td><log:TransactionLogEntryDataSourceMethod/>&nbsp;</td>
									<td><log:TransactionLogEntryDataSourceVersion/>&nbsp;</td>
									<td><log:TransactionLogEntryDataSourceResponseServer/>&nbsp;</td>
									<td><log:TransactionLogEntryVixSiteNumber/>&nbsp;</td>
									<td><log:TransactionLogEntryRequestingVixSiteNumber/>&nbsp;</td>
									<%
										if(debug)
										{
									%>
									<td><log:TransactionLogEntryThreadId/>&nbsp;</td>
									<td><log:TransactionLogEntryDebugInformation/>&nbsp;</td>
									<%
										}
									%>
								</log:TransactionLogEntry>
							</tr>
						</log:TransactionLogEntries>
					</log:TransactionLog>
				</table>

				<%
					try
					{
						SimpleDateFormat sdf = new SimpleDateFormat("MMMM d, yyyy h:mm:ss.SSSS a z");
						Calendar now = Calendar.getInstance();
						out.print("Current time on VIX: " + sdf.format(now.getTime()));
					}
					catch(Exception ex) {}
				%>

			</div>
		</div>
	</form>
</div> <!-- end of innerwrap, 7-15-09 -->

<table border="0" cellspacing="0">
	<tr>
		<td><input id="firstPageBtnBottom" type="button"  style="width:50;height:20;display:inline" value="First" onclick="submitForm('');" alt="First Page"/></td>
		<td><input id="prevPageBtnBottom" type="button"  style="width:50;height:20;display:inline" value="Prev" onclick="previousPage();" alt="Previous Page"/></td>
		<td><input id="nextPageBtnBottom" type="button"  style="width:50;height:20;display:inline" value="Next" onclick="nextPage();" alt="Next Page"/></td>
		<td><input id="lastPageBtnBottom" type="button"  style="width:50;height:20;display:inline" value="Last" onclick="lastPage();" alt="Last Page"/></td>
	</tr>
</table>


<script>
	updateNav();
</script>

<div id="pageFooter">
	<jsp:include flush="false" page="../footer.html"></jsp:include>
</div>
<script src="../script/boxover.js"></script>
</body>
</html>
