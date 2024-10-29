<%@ page language="java" import="java.util.*,gov.va.med.imaging.util.*" pageEncoding="ISO-8859-1"%>

<!DOCTYPE HTML PUBLIC "-//W3C//DTD HTML 4.01 Transitional//EN">
<html>
  <head>
    <title>Java Version Details</title>
    
	<meta http-equiv="pragma" content="no-cache">
	<meta http-equiv="cache-control" content="no-cache">
	<meta http-equiv="expires" content="0">    

	<head>
		<script type="text/javascript" language="javascript" src="../script/jquery-3.5.1.min.js"></script>
		<script type="text/javascript" language="javascript" src="../script/jquery.dataTables.min.js"></script>
	    <link rel="stylesheet" type="text/css" href="../style/jquery.dataTables.css"></link>
    </head>

  </head>
  
  <body>
  
	<script type="text/javascript">
		console.log("About to load datatable");
		$(document).ready(
			function() {
				var table = $('#versions').DataTable(
				{
					order : [ [ 2, 'asc' ] ],
					lengthMenu: [
						[ 10, 25, 50, 100, -1 ],
						[ '10 rows', '25 rows', '50 rows', '100 rows', 'Show all' ]
					],
					pageLength : -1,					
					initComplete : function() {
						console.log("initComplete");
						$("#versions_filter").css({"font-weight" : "bold"});
						$("#versions_filter > label > input[type=search]").width(300);
						$("#versions_filter > label > input[type=search]").css({"font-weight" : "bold"});
					},
					columns:[
						{},
						{},
						{},
						{},
						{},
						{						
						  render : function(data, type, row) {
							
							if(data == 'null') data = 'unknown';
							return data;
						} }],
					fnRowCallback: function( nRow, aData, iDisplayIndex, iDisplayIndexFull ) {
				      // Bold the grade for all 'A' grade browsers
				      if ( aData[2] != common_build )
				      {
						$('td:eq(1)', nRow).html( '<strong style="color:red">'+aData[1]+'*</strong>' );
				        $('td:eq(2)', nRow).html( '<strong style="color:red">'+aData[2]+'</strong>' );
				      }
				    }
				});
				
				var table2 = $('#summary').DataTable(
				{
					order : [ [ 0, 'asc' ] ],
					lengthMenu: [
						[ 10, 25, 50, 100, -1 ],
						[ '10 rows', '25 rows', '50 rows', '100 rows', 'Show all' ]
					],
					pageLength : -1,
					fnRowCallback: function( nRow, aData, iDisplayIndex, iDisplayIndexFull ) {
					  // Bold the grade for all 'A' grade browsers
					  if ( aData[0] != common_build )
					  {
						$('td:eq(0)', nRow).html( '<strong style="color:red">'+aData[0]+'</strong>' );
					  }
					}
				});

				$(".searchInput").on(
					"click",
					function(e) {
						e.preventDefault();
						if ($(this).html() == "All")
							$('#versions').DataTable().search("").draw();
						else
							$('#versions').DataTable().search($(this).html()).draw();
				});
		});
	</script>
	
	<% VersionFinder.VersionFinderResult results = VersionFinder.findVersions();  %>

	 <h1>Java Version Summary</h1>
	<table border="1" id="summary" class="display">
		<thead>
			<tr>
				<th>Build Number</th>
				<th>Count</th>
			</tr>
		</thead>
		<tbody>
			<%  
				Integer max = -1;
				String common_build = "";
				Map<String,Integer>versions = results.getVersionSummary();
				for(String key: versions.keySet()) {
					out.println("<tr><td>" + key + "</td><td>"+ versions.get(key) + "</td></tr>");
					if(versions.get(key)>max) { max=versions.get(key); common_build = key; }
				}
			%>
		</tbody>
	</table>
	<script type="text/javascript">
		var common_build = '<%=common_build%>';
	</script>
	<br/>
	<br/>
	<h1>Java Version Details</h1>
	<div style="padding: 6px" id="versions_filter">
		<span style="font-weight: bold">Shortcuts:</span>
		<button class="searchInput">All</button>
		<button class="searchInput">.jar</button>
		<button class="searchInput">.war</button>
	</div>
	<table border="1" id="versions" class="display">
		<thead>
			<tr>
				<th>Type</th>
				<th>Name</th>
				<th>Build Number</th>
				<th>Build Date</th>
				<th>Build User</th>
				<th>Path</th>
			</tr>
		</thead>
		<tbody>
			<%  
				for(VersionFinder.Artifact a: results.getSet()) {
					out.println(java.net.URLDecoder.decode(a.toHtml(), "UTF-8"));
				}
			%>
		</tbody>
	</table>
  </body>
  
</html>