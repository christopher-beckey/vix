<%@ page language="java" import="java.util.*" pageEncoding="ISO-8859-1"%>
<jsp:directive.page session="false" contentType="text/html" />
<%@ taglib uri="http://imaging.med.va.gov/vix/javalog" prefix="javalog"%>
<%@ taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c"%>

<!DOCTYPE HTML PUBLIC "-//W3C//DTD HTML 4.01 Transitional//EN">
<html>
<head>
<title>Java Log Viewer</title>
<meta http-equiv="pragma" content="no-cache">
<meta http-equiv="cache-control" content="no-cache">
<meta http-equiv="expires" content="0">
<meta http-equiv="keywords" content="keyword1,keyword2,keyword3">
<meta http-equiv="description" content="This is my page">

<link rel="stylesheet" type="text/css" href="../style/jquery.dataTables.css">
<link rel="stylesheet" type="text/css" href="../style/dataTables.dateTime.min.css">

<script type="text/javascript" language="javascript" src="../script/jquery-3.5.1.min.js"></script>
<script type="text/javascript" language="javascript" src="../script/jquery.dataTables.min.js"></script>
<script type="text/javascript" language="javascript" src="../script/moment.min.js"></script>
<script type="text/javascript" language="javascript" src="../script/dataTables.dateTime.min.js"></script>

<script type="text/javascript">
		function adjustForTimezone(date) {
			var timeOffsetInMS = date.getTimezoneOffset() * 60000;
			date.setTime(date.getTime() + timeOffsetInMS);
			return date;
		}
		
		function fixAllSubfolders() {
			var divs = $("#logs > tbody > tr > td:nth-child(1) > a");
			for (i = 0; i < divs.length; ++i) {
			  divs[i].href = divs[i].href.replaceAll("\\","/");
			}
		}
	
		$(document).ready(function () {
			fixAllSubfolders();
			
			$.fn.dataTable.ext.search.push(
				function( settings, data, dataIndex ) {
					var min = minDate.val(); 
					var max = maxDate.val();
					var date = new Date(new Date(Date.parse(data[2], "MMM dd,yyyy hh:MM:ss TT")).toGMTString());
			 
			        if(min !== null)
					min = adjustForTimezone(new Date(min));
				    if(max !== null)
					max = adjustForTimezone(new Date(max));
			
					if (
						( min === null && max === null ) ||
						( min === null && date <= max ) ||
						( min <= date  && max === null ) ||
						( min <= date  && date <= max )
					) {
						return true;
					}
					return false;
				}
			);
			
			// Create date inputs
			minDate = new DateTime($('#min'), {
				format: 'MMMM D YYYY h:mm A'
			});
			maxDate = new DateTime($('#max'), {
				format: 'MMMM D YYYY h:mm A'
			});
		 			
			var table = $('#logs').DataTable( {
				order: [[2, 'desc']],
				pageLength: 25,
				"columns" : [
				{
					data : 'Filename',
				},
				{
					data : 'File Size',
					type : "num",
					render : function(data, type, row) {
						let sz = "0";
						if( data.indexOf("KB") > 0) {
							sz = data.substring(0,data.indexOf("KB")-1)*1024;							
						} else if(data.indexOf("MB") > 0) {
							sz = data.substring(0,data.indexOf("MB")-1)*1024*1024;
						} else if(data.indexOf("GB") > 0) {
							sz = data.substring(0,data.indexOf("GB")-1)*1024*1024*1024;
						} else if(data.indexOf("bytes") > 0) {
							sz = data.substring(0,data.indexOf("bytes")-1);
						}												
						return type === 'sort' ? sz : data;
					}
				},
				{
					data : 'Date Modified',
					render : function(data, type, row) {
						let d = Date.parse(data, "MMM dd,yyyy hh:MM:ss TT");
						return type === 'sort' ? d : data;						
					}
				},				
				],
				initComplete: function () {
					$("#logs_filter").css({"font-weight": "bold"});
					$("#logs_filter > label > input[type=search]").width(300);
					$("#logs_filter > label > input[type=search]").css({"font-weight": "bold"});
				},
				
			});
			
			$(".searchInput").on("click", function (e) {
			   e.preventDefault();
			   if($(this).html()=="All")
				   $('#logs').DataTable().search("").draw();
			   else 
				   $('#logs').DataTable().search($(this).html()).draw();
			});
			
			$('#min, #max').on('change', function () {
				table.draw();
			});
						
		});
  </script>

</head>

<body onLoad="">
	<h1>Java Logs</h1>
	<div style="padding: 6px">
		<span style="font-weight: bold">Shortcuts:</span>
		<button class="searchInput">All</button>
		<button class="searchInput">ImagingExchangeWebApp</button>
		<button class="searchInput">Catalina</button>
		<button class="searchInput">Monitor</button>
		<button class="searchInput">DCF</button>
	</div>
	<br />
	<table border="0" cellspacing="5" cellpadding="5">
		<tbody>
			<tr>
				<td style="font-weight: bold">Start date:</td>
				<td><input type="text" id="min" name="min"></td>
				<td style="font-weight: bold">End date:</td>
				<td><input type="text" id="max" name="max"></td>
			</tr>
		</tbody>
	</table>
	<br />

	<table border="1" id="logs" class="display">
		<thead>
			<tr>
				<th>Filename</th>
				<th>File Size</th>
				<th>Date Modified</th>
			</tr>
		</thead>
		<tbody>
			<javalog:JavaLogCollection>
				<javalog:JavaLogCollectionElement>
					<tr>
						<td><jsp:element name="a">
		  					<jsp:attribute name="href">
		  						<javalog:DownloadLogFileHRef />
		  					</jsp:attribute>
		  					<jsp:body>
		  						<javalog:Filename />
		  					</jsp:body>
		  				</jsp:element></td>
						<td><javalog:FileSize /></td>
						<td><javalog:DateModified /></td>
					</tr>
				</javalog:JavaLogCollectionElement>
			</javalog:JavaLogCollection>
		</tbody>
	</table>
</body>
</html>
