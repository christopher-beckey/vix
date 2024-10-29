<%@ page
	import="gov.va.med.imaging.exchange.business.*,gov.va.med.imaging.core.interfaces.exceptions.*,gov.va.med.imaging.exchange.siteservice.*,gov.va.med.imaging.datasource.*,gov.va.med.siteservice.*, java.util.*, java.io.IOException"%>
<%@ page import="javax.xml.parsers.ParserConfigurationException, org.xml.sax.SAXException, java.io.File, gov.va.med.imaging.utils.FileUtilities" %>
<%
List<Region> regions = null;
SiteServiceConfiguration configuration = SiteServiceConfiguration.createDefault(
		SiteResolutionProvider.getProviderConfiguration().getConfigurationDirectory());
if(!FileUtilities.getFile(configuration.getVhaSitesXmlFileName()).exists()){%>
	<html>
	<head>
	<title>Configuration Error</title>
	</head>
	<body>
		<h2 style="text-align: center; color: #080808; margin: 18px;"> This Site does not have Site Service configured! Please contact Administrator.</h2>
	</body>
	</html>
<% } 
else {
%>

<html> <head> <title>Exchange Site Service </title> 
<meta http-equiv="X-UA-Compatible" content="IE=edge" />
<link rel="stylesheet" href="../css/styles.css">
<script type="text/javascript"	src="../js/jquery-3.3.1.min.js"></script>
<script language="javascript">
if (!Element.prototype.matches)
	Element.prototype.matches = Element.prototype.msMatchesSelector
			|| Element.prototype.webkitMatchesSelector;
if (!Element.prototype.closest) {
	Element.prototype.closest = function(s) {
		var el = this;
		if (!document.documentElement.contains(el))
			return null;
		do {
			if (el.matches(s))
				return el;
			el = el.parentElement || el.parentNode;
		} while (el !== null && el.nodeType === 1);
		return null;
	};
}
window.onscroll = function() {
	scrollFunction()
};
window.onload = function() {
	addListenerForRegionLevelCollapse();
	addListenerForSiteLevelCollapse();
};
function addListenerForRegionLevelCollapse() {
	var acc = document.getElementsByClassName('accordion');
	var i;
	for (i = 0; i < acc.length; i++) {
		acc[i].removeEventListener('click', regionLevelCollapse, false);
		acc[i].addEventListener('click', regionLevelCollapse, false); 
	}
}
function regionLevelCollapse(event) {
	if (event.target.localName != 'button' && event.target.localName != 'select' && event.target.localName != 'input') {
		this.classList.toggle('active');
		var panel = this.nextElementSibling;
		if (panel.style.maxHeight) {
			panel.style.maxHeight = null;
		} else {
			panel.style.maxHeight = panel.scrollHeight + 500 + 'px';
		}
	}
}
function addListenerForSiteLevelCollapse() {
	var acc = document.getElementsByClassName('siteLevelAccordion');
	for (var i = 0; i < acc.length; i++) {
		acc[i].removeEventListener('click', siteLevelCollapse, false);
		acc[i].addEventListener('click', siteLevelCollapse, false);
	}
}
function siteLevelCollapse(event) {
	if (event.target.localName != 'button'
			&& event.target.localName != 'select'
			&& event.target.localName != 'input') {
		this.classList.toggle('active');
		var panel = this.nextElementSibling;
		if (panel.style.maxHeight) {
			panel.style.maxHeight = null;
		} else {
			panel.style.maxHeight = panel.scrollHeight + 500 + 'px';
		}
	}
}

function scrollFunction() {
	if (document.body.scrollTop > 20
			|| document.documentElement.scrollTop > 20) {
		document.getElementById('myBtn').style.display = 'block';
	} else {
		document.getElementById('myBtn').style.display = 'none';
	}
}
function topFunction() {
	document.body.scrollTop = 0;
	document.documentElement.scrollTop = 0;
}
function addRegionClicked(ele) {  
	var mainDiv = $(ele).closest(".main-div");
	var regionToAddHTML =  
			'<div class="container">'
					+ '<div class="accordion"> <div class="region-info-div"> <span class="regionNameSpan"> <input type="text" class="regionNameInput" placeholder="Region name"> </span> <span class="regionNumberSpan"> <input type="text" class="regionNumInput" placeholder="Region number"> </span> </div>'
					+ '<div class="region-btn-div"> <button id="btnAdd" onclick="addRegionClicked()" class= "hidden">Add</button> <button id="btnEdit" onclick="editRegionClicked()" class= "hidden">Edit</button> <button id="btnDelete" onclick="deleteRegionClicked(this)" class= "hidden">Delete</button> <button id="btnSave" onclick="saveRegion(this, \'ADD\')">Save</button> <button id="btnCancelSave" onclick="cancelSaveRegion(this)">Cancel</button></div></div>'
				+ '<div class="panel" style="max-height: 660px;">'
					+ '<p style="margin-bottom: 0px;">'
						+ '<table id="tbl-regions"><tbody>'
							+ '<tr><th class="td1">Site Name</th><th class="td2">Site #</th><th class="td3">Abbr</th><th class="td4">Patient Lookup Enabled</th><th class="td5">User Authentication Enabled</th><th class="td6">Protocols</th><th class="td7">Action &nbsp;&nbsp;<button id="btnAddSite" onclick="addSiteClicked(this)">Add</button></th></tr>'
							+ '</tbody></table>'
					+ '</p>'
				+ '</div>'
			+ '</div>';
	if($('.regionNameInput').length == 0){
		$(mainDiv).append(regionToAddHTML);
		addListenerForRegionLevelCollapse();
	}
}

function saveRegion(ele, opsToDo) { 
	var containerNode = ele.closest('.container');
	var infoDiv = containerNode.querySelector(".region-info-div");
	var regionNameVal = infoDiv.querySelector('.regionNameInput').value;
	var regionNumVal = infoDiv.querySelector('.regionNumInput').value;
	if (regionNameVal.trim() === '') {
		alert('Please enter the Region name.');
		return false;
	}
	if (regionNumVal.trim() === '') {
		alert('Please enter the Region number.');
		return false;
	}
	
	var prevRegName = null;
	var prevRegNumber = null;
	if(opsToDo == 'UPDATE'){
		var hiddenRegNumNode = containerNode.querySelector('#regionNameNum');
		prevRegName = hiddenRegNumNode.value.split('|')[0];
		prevRegNumber = hiddenRegNumNode.value.split('|')[1];
	}

	var Ops;
	if(opsToDo === 'ADD'){
	 Ops = 'ADD_REGION';
	}
	else if(opsToDo === 'UPDATE'){
		Ops = 'UPDATE_REGION';
	}
	else {
		console.log("Operation not supported on the site");
		return;
	}
	
	var RegionJson = {
		Ops : Ops,
		regionName : regionNameVal,
		regionNumber : regionNumVal,
		prevRegionName:   prevRegName,
		prevRegionNumber:  prevRegNumber
	};
	
	var contextPath = '<%=getBaseUrl(request)%>';
	var urltoSave = '' + contextPath + '/ManageRegionService';
	$.ajax({
		url : urltoSave,
		type : 'POST',
		data : RegionJson,
		contentType : "application/x-www-form-urlencoded; charset=UTF-8",
		dataType : "json",
		success : function(data) {
			if (data.status == true) {
				alert('Region '+ ((opsToDo == 'ADD')? 'added': 'updated') +' successfully.');
				setTimeout(function() {
					location.reload();
				}, 400);
			} else {
				alert(data.conflict_message);
			}
		},
		error : function(jqXHR, textStatus, errorThrown) {
			console.log("error: " + textStatus);
		}
	});
}

function cancelSaveRegion(ele) {
	var container = ele.closest('.container');
	container.parentNode.removeChild(container);
}

function cancelSaveRegionOnEdit(ele){
	var containerNode = ele.closest(".container");
	var hiddenNameNumNode = containerNode.querySelector("#regionNameNum");
	var regionName = hiddenNameNumNode.value.split("|")[0];
	var regionNumber = hiddenNameNumNode.value.split("|")[1];

	containerNode.querySelector(".regionNameSpan").innerHTML = regionName;
	containerNode.querySelector(".regionNumberSpan").innerHTML = regionNumber;

	containerNode.querySelector("#btnAdd").classList.remove("hidden");
	containerNode.querySelector("#btnEdit").classList.remove("hidden");
	containerNode.querySelector("#btnDelete").classList.remove("hidden");
	containerNode.querySelector("#btnSave").classList.add("hidden");
	containerNode.querySelector("#btnCancelSave").classList.add("hidden"); 

}
function editRegionClicked(ele) {
	
	var containerNode = ele.closest(".container");
	var hiddenNameNumNode = containerNode.querySelector("#regionNameNum");
	var regionName = hiddenNameNumNode.value.split("|")[0];
	var regionNumber = hiddenNameNumNode.value.split("|")[1];   

	containerNode.querySelector(".regionNameSpan").innerHTML = '<input type="text" class="regionNameInput" value = "'+ regionName +'" placeholder="Region name">';
	containerNode.querySelector(".regionNumberSpan").innerHTML = '<input type="text" class="regionNumInput" value = "'+ regionNumber +'" placeholder="Region name">';

	containerNode.querySelector("#btnAdd").classList.add("hidden");
	containerNode.querySelector("#btnEdit").classList.add("hidden");
	containerNode.querySelector("#btnDelete").classList.add("hidden");
	containerNode.querySelector("#btnSave").classList.remove("hidden");
	containerNode.querySelector("#btnCancelSave").classList.remove("hidden"); 
}
function deleteRegionClicked(ele) {
	var regionId = null;
	var regionName = null;
	
	var contextPath = "<%=getBaseUrl(request)%>";
	var urltoDel = contextPath + '/ManageRegionService';
	var regionContainer = ele.closest('.container');
	var hiddenNameNumNode = regionContainer.querySelector('#regionNameNum');
	regionName = hiddenNameNumNode.value.split('|')[0];
	regionId = hiddenNameNumNode.value.split('|')[1];
	
	var isConfirmed = confirm('Are you sure you want to delete this region('
			+ regionName + ') ? ');
	if (isConfirmed) {
		var regionJson = {
			Ops : 'DELETE_REGION',
			regionNumber : regionId
		};
		$.ajax({
					url : urltoDel,
					type : 'POST',
					data : regionJson,
					contentType : "application/x-www-form-urlencoded; charset=UTF-8",
					dataType : "json",
					success : function(data) {
						if (data.status == true) {
							alert('Region deleted successfully(' + regionName
									+ ').');
							regionContainer.parentNode.removeChild(regionContainer);
						} else {
							alert(data.conflict_message);
						}
					},
					error : function(jqXHR, textStatus, errorThrown) {
						console.log("error: " + jqXHR);
					}
				});
	}
}

function addProtocolRow(ele) {
	var new_Protocol = "<input type='text' id='new_Protocol' class='protocol_tBox' placeholder='Protocol'>";
	var new_Server = "<input type='text' id='new_Server' class='server_tBox' placeholder='Server'>";
	var new_Port = "<input type='text' id='new_Port' class='port_tBox' placeholder='Port'>";
	var new_Modality = "<input type='text' id='new_Modality' class='modality_tBox' placeholder='Modality'>";
	var table = ele.closest('.data_table');
	table.insertRow(-1).outerHTML = "<tr><td class='td1' id='protocol_row'> "
			+ new_Protocol
			+ " </td><td class='td2' id='server_row'>"
			+ new_Server
			+ "</td><td class='td3' id='port_row'>"
			+ new_Port
			+ "</td><td class='td4' id='modality_row'>"
			+ new_Modality
			+"</td><td class='td5'><button class='btnEditProtocol hidden'>Edit</button> <button class='btnDeleteProtocol hidden' onclick='deleteProtocol(this)'>Delete</button> <button class='btnTestProtocol hidden' onclick-'testProtocol(this)'>Test</button> <button class='btnSaveProtocol' onclick=\"saveProtocol(this,'ADD')\">Save</button> <button class='btnCancelProtocol' onclick='cancelProtocolSave(this)'>Cancel</button></td></tr>";
}
function cancelProtocolSave(ele) {
	var row = ele.closest('tr');
	row.parentNode.removeChild(row);
}
function cancelSiteSave(ele) {
	var row = ele.closest('tr');
	row.parentNode.removeChild(row);
}


function addSiteClicked(ele) {
	var labelArray = new Array('Site Name', 'Site #', 'Abbr',
			'Patient Lookup Enabled', 'User Authentication Enabled', '');
	var table = ele.closest('#tbl-regions');
	var row = table.insertRow(-1);
	var i;
	for (i = 0; i <= 6; i++) {
		var cells = row.insertCell(i);
		if (i == 5) {
			continue;
		}
		cells.classList = [ 'td' + (i + 1) ];
		if (i <= 2) {
			cells.innerHTML = "<input type = 'text' name = 'txtNewInput' id = 'txtNewInput"+i+"' value = '' placeholder='"+labelArray[i]+"'/>";
		} else if (i == 3 || i == 4) {
			cells.innerHTML = "<select id = 'selectNew" + i +"'>  <option value='true'>True</option>  <option value='false'>False</option> </select>";
		} else if (i == 6) {
			cells.innerHTML = "<button onclick=\"saveSite(this, 'ADD')\" class='saveSite'>Save</button> <button onclick='cancelSiteSave(this)' class='cancelSiteSave'>Cancel</button> <button id='btnEditSite' onclick='edirRegioLevel(this)' class='hidden'>Edit</button> <button id='btnDeleteSite'onclick='deleteRow(this)' class='hidden'>Delete</button>&nbsp";
		}
	}
}
function saveSite(ele, opsToDo) {
	var row = ele.closest("tr");
	var txtNewInput0 = row.querySelector('#txtNewInput0').value;
	var txtNewInput1 = row.querySelector('#txtNewInput1').value;
	var txtNewInput2 = row.querySelector('#txtNewInput2').value;
	var selectNewInput3 = row.querySelector('#selectNew3').value;
	var selectNewInput4 = row.querySelector('#selectNew4').value;
	if (txtNewInput0.trim() === '') {
		alert('Please enter the Site name.');
		return false;
	}
	if (txtNewInput1.trim() === '') {
		alert('Please enter the Site number.');
		return false;
	}
	if (txtNewInput2.trim() === '') {
		alert('Please enter the Site abbreviation.');
		return false;
	}
	if (selectNewInput3.trim() === '') {
		alert('Please select the Patient Lookup Enabled.');
		return false;
	}
	if (selectNewInput4.trim() === '') {
		alert('Please select the User Authentication Enabled.');
		return false;
	}
	var parentNode = ele.closest('.container');
	var hiddenNameNumNode = parentNode.querySelector('#regionNameNum');
	var regionNameVal = hiddenNameNumNode.value.split('|')[0];
	var regionNumVal = hiddenNameNumNode.value.split('|')[1];
	
	var prevSiteName = null;
	var prevSiteNumber = null;
	if(opsToDo == 'UPDATE'){
		var siteParentNode = ele.closest('.siteLevelAccordion');
		var hiddenSiteNameNumNode = siteParentNode.querySelector('#siteNameNum');
		prevSiteName = hiddenSiteNameNumNode.value.split('|')[0];
		prevSiteNumber = hiddenSiteNameNumNode.value.split('|')[1];
	}

	var Ops;
	if(opsToDo === 'ADD'){
	Ops = 'ADD_SITE';
	}
	else if(opsToDo === 'UPDATE'){
		Ops = 'UPDATE_SITE';
	}
	else {
		console.log("Operation not supported on the site");
		return;
	}
	
	var SiteJson = {
		Ops : Ops,
		regionName : regionNameVal,
		regionNumber : regionNumVal,
		prevSiteName:   prevSiteName,
		prevSiteNumber:  prevSiteNumber,
		siteName : txtNewInput0,
		siteNumber : txtNewInput1,
		siteAbbr : txtNewInput2,
		sitePatientLookupable : selectNewInput3,
		siteUserAuthenticatable : selectNewInput4
	};
	var contextPath = '<%=getBaseUrl(request)%>';
	var urltoSave = '' + contextPath + '/ManageSiteService';
	$.ajax({
		url : urltoSave,
		type : 'POST',
		data : SiteJson,
		contentType : "application/x-www-form-urlencoded; charset=UTF-8",
		dataType : "json",
		success : function(data) {
			if (data.status == true) {
				ajaxCallbackForSaveSite(ele, Ops);
				alert('Site '+ ((opsToDo == 'ADD')? 'added': 'updated') +' successfully.');
			} else {
				alert(data.conflict_message);
			}
		},
		error : function(jqXHR, textStatus, errorThrown) {
			console.log("error: " + textStatus);
		}
	});
}
function ajaxCallbackForSaveSite(ele, ops) { 
	var xtable = ele.closest('#tbl-regions');
	var txtNewInput0 = xtable.querySelector('#txtNewInput0').value;
	var txtNewInput1 = xtable.querySelector('#txtNewInput1').value;
	var txtNewInput2 = xtable.querySelector('#txtNewInput2').value;
	var selectNewInput3 = xtable.querySelector('#selectNew3').value;
	var selectNewInput4 = xtable.querySelector('#selectNew4').value;
	
	if(ops === 'ADD_SITE'){
		var row = xtable.insertRow(-1);
		var cell = row.insertCell(0);
		cell.innerHTML = '<div class="siteLevelAccordion"><table class="accordion_table"><tbody><tr><td class="td1">'
				+ txtNewInput0
				+ '</td><td class="td2">'
				+ txtNewInput1
				+ '</td><td class="td3">'
				+ txtNewInput2
				+ '</td><td class="td4" align="center">'
				+ selectNewInput3
				+ '</td><td class="td5" align="center">'
				+ selectNewInput4
				+ '</td><td class="td6"></td><td class="td7"><button id="btnEditSite" onclick="editSite(this)" class="">Edit</button> <button id="btnDeleteSite" onclick="deleteSite(this)" class="">Delete</button> <button id="btnSaveSite" class="hidden">Save</button> <button id="btnCancelSite" class="hidden" onclick="cancelSiteSaveWhileEdit(this)">Cancel</button></td></tr></tbody></table><input id="siteNameNum" value="'+txtNewInput0+'|'+txtNewInput1+'" type="hidden"> <input id="siteSecondaryFields" value="'+txtNewInput2+'|'+selectNewInput3+'|'+selectNewInput4+'" type="hidden"> </div><div class="siteLevelPanel"><table class="data_table"><tbody><tr><th class="td1">Protocol</th><th class="td2">Server</th><th class="td3">Port</th><th class="td4">Modality</th><th class="td5">Action &nbsp;&nbsp;<button id="btnAddSite" onclick="addProtocolRow(this)">Add</button></th></tr></tbody></table></div>';
		cell.classList.add('site-level-cell');
		cell.colSpan = 9;
		var closestRow = xtable.querySelector('#txtNewInput0').closest('tr');
		closestRow.parentNode.removeChild(closestRow);
		addListenerForSiteLevelCollapse();
	}
	else if(ops === 'UPDATE_SITE'){
		var row = ele.closest('tr');
		row.querySelector('.td1').innerHTML = txtNewInput0;
		row.querySelector('.td2').innerHTML = txtNewInput1;
		row.querySelector('.td3').innerHTML = txtNewInput2;
		row.querySelector('.td4').innerHTML = selectNewInput3;
		row.querySelector('.td5').innerHTML = selectNewInput4;
		
		//Updating the hidden fields
		var siteParentNode = ele.closest('.siteLevelAccordion');	//change TODO
		siteParentNode.querySelector("#siteNameNum").value = txtNewInput0 + "|"+ txtNewInput1; //change TODO
		siteParentNode.querySelector("#siteSecondaryFields").value = txtNewInput2 + "|"+ selectNewInput3 +"|"+ selectNewInput4; //change TODO

		//handling the buttons on the row
		row.querySelector('#btnEditSite').classList.remove('hidden');
		row.querySelector('#btnDeleteSite').classList.remove('hidden');
		row.querySelector('#btnSaveSite').classList.add('hidden');
		row.querySelector('#btnCancelSite').classList.add('hidden'); 
	}
}
function saveProtocol(ele, opsToDo){
	var row = ele.closest("tr");
	var protocol = row.querySelector('.protocol_tBox').value;
	var server = row.querySelector('.server_tBox').value;
	var port = row.querySelector('.port_tBox').value;
	var modality = row.querySelector('.modality_tBox').value;
	
	if (protocol.trim() === '') {
		alert('Please enter the Protocol name.');
		return false;
	}
	if (server.trim() === '') {
		alert('Please enter the Server url.');
		return false;
	}
	if (port.trim() === '') {
		alert('Please enter the Port number.');
		return false;
	}
	if (modality.trim() === '') {
		alert('Please enter the Modality.');
		return false;
	}
	if(!(/^\d+$/.test(port.trim()))){
		alert('Port number should be numeric value.');
		return false;
	}
	var parentNode = ele.closest('.container');
	var hiddenNameNumNode = parentNode.querySelector('#regionNameNum');
	var regionNameVal = hiddenNameNumNode.value.split('|')[0];
	var regionNumVal = hiddenNameNumNode.value.split('|')[1];
	
	var siteParentNode = ele.closest('.site-level-cell');
	var hiddenSiteNameNumNode = siteParentNode.querySelector('#siteNameNum');
	var siteNameVal = hiddenSiteNameNumNode.value.split('|')[0];
	var siteNumberVal = hiddenSiteNameNumNode.value.split('|')[1];

	var prevProcName = null;
	var prevPort = null;
	var prevModality = null;
	if(opsToDo == 'UPDATE'){
		var cell = ele.closest('.td5');
		var hiddenProcNode = cell.querySelector("#protFields");
		prevProcName = hiddenProcNode.value.split('|')[0];
		prevPort = hiddenProcNode.value.split('|')[2];
		prevModality = hiddenProcNode.value.split('|')[3];
	}

	var Ops;
	if(opsToDo === 'ADD'){
		Ops = 'ADD_PROTOCOL';
	}
	else if(opsToDo === 'UPDATE'){
		Ops = 'UPDATE_PROTOCOL';
	}
	else {
		console.log("Operation not supported on the site");
		return;
	} 
	
	var ProcJson = {
		Ops : Ops,
		regionName : regionNameVal,
		regionNumber : regionNumVal,
		siteName:   siteNameVal,
		siteNumber:  siteNumberVal,
		prevProtocol: prevProcName,
		prevPort: prevPort,
		protocol : protocol,
		server : server,
		port : port,
		modality: modality
	};
	var contextPath = '<%=getBaseUrl(request)%>';
	var urltoSave = '' + contextPath + '/ManageProtocolService';
	$.ajax({
		url : urltoSave,
		type : 'POST',
		data : ProcJson,
		contentType : "application/x-www-form-urlencoded; charset=UTF-8",
		dataType : "json",
		success : function(data) {
			if (data.status == true) {
				alert('Protocol '+ ((opsToDo == 'ADD')? 'added': 'updated') +' successfully.');
				ajaxCallbackForSaveProtocol(ele, Ops);
			} else {
				alert(data.conflict_message);
			}
		},
		error : function(jqXHR, textStatus, errorThrown) {
			console.log("error: " + textStatus);
		}
	});
}

function ajaxCallbackForSaveProtocol(ele, ops) {
	var xtable = ele.closest('.data_table');
	var procValue = xtable.querySelector('.protocol_tBox').value;
	var serverValue = xtable.querySelector('.server_tBox').value;
	var portValue = xtable.querySelector('.port_tBox').value;
	var modalityValue = xtable.querySelector('.modality_tBox').value;
	
	if (ops === 'ADD_PROTOCOL') {
		var row = xtable.insertRow(-1);
		row.innerHTML = '<td class="td1">' + procValue + '</td>'
			+ '<td class="td2">' + serverValue + '</td>'
			+ '<td class="td3">' + portValue + '</td>'
			+ '<td class="td4">' + modalityValue + '</td>'
			+ '<td class="td5"><button id="btnEditProtocol" onclick="editProtocol(this)">Edit</button> <button id="btnDeleteProtocol" onclick="deleteProtocol(this)">Delete</button> <button id="btnSaveProtocol" onclick="saveProtocol(this, \'UPDATE\')" class="hidden">Save</button> <button id="btnCancelSave" onclick="cancelProtocolSaveWhileEdit(this)" class="hidden">Cancel</button> <button id="btnTest" onclick="testProtocol(this)">Test</button>'
			+ '<input id="protFields" value="' + procValue + '|' + serverValue + '|' + portValue +'|' + modalityValue + '" type="hidden"></td>';

		var closestRow = xtable.querySelector('#new_Protocol').closest('tr');
		closestRow.parentNode.removeChild(closestRow);
	}
	else if(ops === 'UPDATE_PROTOCOL'){
		var row = ele.closest('tr');
		row.querySelector('.td1').innerHTML = procValue;
		row.querySelector('.td2').innerHTML = serverValue;
		row.querySelector('.td3').innerHTML = portValue;
		row.querySelector('.td4').innerHTML = modalityValue;
		row.querySelector('#protFields').value = procValue +"|"+ serverValue +"|"+ portValue+"|"+ modalityValue;

		//handling the buttons on the row
		row.querySelector('#btnEditProtocol').classList.remove('hidden');
		row.querySelector('#btnDeleteProtocol').classList.remove('hidden');
		row.querySelector('#btnTest').classList.remove('hidden');
		row.querySelector('#btnSaveProtocol').classList.add('hidden');
		row.querySelector('#btnCancelSave').classList.add('hidden');
	}
}
function deleteSite(ele) {
	var regionId = null;
	var regionName = null;
	var siteId = null;
	var siteName = null;
	var contextPath = "<%=getBaseUrl(request)%>";
	var urltoDel = contextPath + '/ManageSiteService';
	var parentNode = ele.closest('.container');
	var hiddenNameNumNode = parentNode.querySelector('#regionNameNum');
	regionName = hiddenNameNumNode.value.split('|')[0];
	regionId = hiddenNameNumNode.value.split('|')[1];
	var siteParentNode = ele.closest('.siteLevelAccordion');
	var hiddenSiteNameNumNode = siteParentNode
			.querySelector('#siteNameNum');
	siteName = hiddenSiteNameNumNode.value.split('|')[0];
	siteId = hiddenSiteNameNumNode.value.split('|')[1];
	var isConfirmed = confirm('Are you sure you want to delete this site('
			+ siteName + ') ? ');
	if (isConfirmed) {
		var siteJson = {
			Ops : 'DELETE_SITE',
			regionName : regionName,
			regionNumber : regionId,
			siteName : siteName,
			siteNumber : siteId
		};
		$.ajax({
					url : urltoDel,
					type : 'POST',
					data : siteJson,
					contentType : "application/x-www-form-urlencoded; charset=UTF-8",
					dataType : "json",
					success : function(data) {
						if (data.status == true) {
							alert('Site deleted successfully(' + siteName
									+ ').');
							var dataTable = getParentByTagName(ele, 'table');
							var rowToDelete = getParentByTagName(dataTable,
									'tr');
							rowToDelete.parentNode.removeChild(rowToDelete);
						} else {
							alert(data.conflict_message);
						}
					},
					error : function(jqXHR, textStatus, errorThrown) {
						console.log("error: " + jqXHR);
					}
				});
	}
}
function deleteProtocol(ele) {
	var regionId = null;
	var regionName = null;
	var siteId = null;
	var siteName = null;
	var protocolName = null;

	var contextPath = "<%=getBaseUrl(request)%>";
	var urltoDel = contextPath + '/ManageProtocolService';

	var parentNode = ele.closest('.container');
	var hiddenNameNumNode = parentNode.querySelector('#regionNameNum');
	regionName = hiddenNameNumNode.value.split('|')[0];
	regionId = hiddenNameNumNode.value.split('|')[1];
 
	var siteParentNode = ele.closest('.site-level-cell');
	var hiddenSiteNameNumNode = siteParentNode.querySelector('#siteNameNum');
	siteName = hiddenSiteNameNumNode.value.split('|')[0];
	siteId = hiddenSiteNameNumNode.value.split('|')[1];

	var cell = ele.closest('tr');
	var hiddenProcNode = cell.querySelector("#protFields");
	protocolName = hiddenProcNode.value.split('|')[0];

	var isConfirmed = confirm('Are you sure you want to delete this Protocol('
			+ protocolName + ') ? ');
	if (isConfirmed) {
		var procJson = {
			Ops : 'DELETE_PROTOCOL',
			regionName : regionName,
			regionNumber : regionId,
			siteName : siteName,
			siteNumber : siteId,
			protocolName: protocolName
		};
		$.ajax({
					url : urltoDel,
					type : 'POST',
					data : procJson,
					contentType : "application/x-www-form-urlencoded; charset=UTF-8",
					dataType : "json",
					success : function(data) {
						if (data.status == true) {
							alert('Protocol deleted successfully(' + protocolName
									+ ').');
							var rowToDelete = getParentByTagName(ele, 'tr');
							rowToDelete.parentNode.removeChild(rowToDelete);
						} else {
							alert(data.conflict_message);
						}
					},
					error : function(jqXHR, textStatus, errorThrown) {
						console.log("error: " + jqXHR);
					}
				});
	}
}
function getParentByTagName(node, tagname) {
	var parent;
	if (node === null || tagname === '')
		return;
	parent = node.parentNode;
	tagname = tagname.toUpperCase();
	while (parent.tagName !== 'HTML') {
		if (parent.tagName === tagname) {
			return parent;
		}
		parent = parent.parentNode;
	}
	return parent;
}
function editSite(ele) {
	var row = ele.closest("tr");
	var siteNameTD = row.querySelector('.td1');
	var siteNumberTD = row.querySelector('.td2');
	var siteAbbrTD = row.querySelector('.td3');
	var patientLookupEnabledTD = row.querySelector('.td4');
	var userAuthenticationEnabledTD = row.querySelector('.td5');
	var siteName = siteNameTD.innerText;
	var siteNumber = siteNumberTD.innerText;
	var siteAbbr = siteAbbrTD.innerText;
	var patient_Lookup_Enabled = patientLookupEnabledTD.innerText;
	var user_Authentication_Enabled = userAuthenticationEnabledTD.innerText;
	siteNameTD.innerHTML = "<input type = 'text' name = 'txtNewInput' id='txtNewInput0' value = '"+siteName+"'/>";
	siteNumberTD.innerHTML = "<input type = 'text' name = 'txtNewInput' id='txtNewInput1'  value = '"+siteNumber+"'/>";
	siteAbbrTD.innerHTML = "<input type = 'text' name = 'txtNewInput' id='txtNewInput2'  value = '"+siteAbbr+"'/>";
	patientLookupEnabledTD.innerHTML = "<select id='selectNew3'>  <option value='true'>True</option>  <option value='false'>False</option> </select>";
	userAuthenticationEnabledTD.innerHTML = "<select id='selectNew4'>  <option value='true'>True</option>  <option value='false'>False</option> </select>";
	patientLookupEnabledTD.querySelector("option[value="
			+ patient_Lookup_Enabled + "]").selected = true;
	userAuthenticationEnabledTD.querySelector("option[value="
			+ user_Authentication_Enabled + "]").selected = true;
	row.querySelector('#btnEditSite').classList.add('hidden');
	row.querySelector('#btnDeleteSite').classList.add('hidden');
	row.querySelector('#btnSaveSite').classList.remove('hidden');
	row.querySelector('#btnCancelSite').classList.remove('hidden');
}

function cancelSiteSaveWhileEdit(ele) {
	var row = ele.closest("tr");
	var siteNameTD = row.querySelector('.td1');
	var siteNumberTD = row.querySelector('.td2');
	var siteAbbrTD = row.querySelector('.td3');
	var patientLookupEnabledTD = row.querySelector('.td4');
	var userAuthenticationEnabledTD = row.querySelector('.td5');
	var siteParentNode = ele.closest('.siteLevelAccordion');
	var hiddenSiteNameNumNode = siteParentNode
			.querySelector('#siteNameNum');
	var hiddenSiteSecondaryDetailsNode = siteParentNode
			.querySelector("#siteSecondaryFields");
	siteNameTD.innerHTML = hiddenSiteNameNumNode.value.split('|')[0];
	siteNumberTD.innerHTML = hiddenSiteNameNumNode.value.split('|')[1];
	siteAbbrTD.innerHTML = hiddenSiteSecondaryDetailsNode.value.split('|')[0];
	patientLookupEnabledTD.innerHTML = hiddenSiteSecondaryDetailsNode.value
			.split('|')[1];
	userAuthenticationEnabledTD.innerHTML = hiddenSiteSecondaryDetailsNode.value
			.split('|')[2];
	row.querySelector('#btnEditSite').classList.remove('hidden');
	row.querySelector('#btnDeleteSite').classList.remove('hidden');
	row.querySelector('#btnSaveSite').classList.add('hidden');
	row.querySelector('#btnCancelSite').classList.add('hidden');
}
function editProtocol(ele) {
	var row = ele.closest("tr");
	var protocolTD = row.querySelector('.td1');
	var serverTD = row.querySelector('.td2');
	var portTD = row.querySelector('.td3');
	var modalityTD = row.querySelector('.td4');
	protocolTD.innerHTML = "<input type = 'text' name = 'txtNewInput' class='protocol_tBox' value = '"+protocolTD.innerText+"'/>";
	serverTD.innerHTML = "<input type = 'text' name = 'txtNewInput' class='server_tBox' value = '"+serverTD.innerText+"'/>";
	portTD.innerHTML = "<input type = 'text' name = 'txtNewInput' class='port_tBox' value = '"+portTD.innerText+"'/>";
	modalityTD.innerHTML = "<input type = 'text' name = 'txtNewInput' class='modality_tBox' value = '"+modalityTD.innerText+"'/>";
	
	row.querySelector('#btnEditProtocol').classList.add('hidden');
	row.querySelector('#btnDeleteProtocol').classList.add('hidden');
	row.querySelector('#btnTest').classList.add('hidden');
	row.querySelector('#btnSaveProtocol').classList.remove('hidden');
	row.querySelector('#btnCancelSave').classList.remove('hidden');
}
function cancelProtocolSaveWhileEdit(ele) {
	var row = ele.closest("tr");
	var protocolTD = row.querySelector('.td1');
	var serverTD = row.querySelector('.td2');
	var portTD = row.querySelector('.td3');
	var modalityTD = row.querySelector('.td4');
	var hiddenProtFieldsNode = row.querySelector('#protFields');
	protocolTD.innerHTML = hiddenProtFieldsNode.value.split('|')[0];
	serverTD.innerHTML = hiddenProtFieldsNode.value.split('|')[1];
	portTD.innerHTML = hiddenProtFieldsNode.value.split('|')[2];
	modalityTD.innerHTML = hiddenProtFieldsNode.value.split('|')[3];
	row.querySelector('#btnEditProtocol').classList.remove('hidden');
	row.querySelector('#btnDeleteProtocol').classList.remove('hidden');
	row.querySelector('#btnTest').classList.remove('hidden');
	row.querySelector('#btnSaveProtocol').classList.add('hidden');
	row.querySelector('#btnCancelSave').classList.add('hidden');
}

function testProtocol(ele){
		var row = ele.closest('tr');
		var hiddenProcValue = row.querySelector('#protFields').value;
		var protocol = hiddenProcValue.split("|")[0];
		var server = hiddenProcValue.split("|")[1];
		var port = hiddenProcValue.split("|")[2];

		var contextPath = "<%=getBaseUrl(request)%>";
		var urltoTest = contextPath + '/ManageProtocolService';

		var procJson = {
			Ops : 'TEST_PROTOCOL',
			protocol : protocol,
			server : server,
			port: port
		};

		$("div#divLoading").addClass('show');
		$.ajax({
				async: false,
				url : urltoTest,
				type : 'POST',
				data : procJson,
				contentType : "application/x-www-form-urlencoded; charset=UTF-8",
				dataType : "json",
				timeout: 40000,
				success : function(data) {
					if (data.status == true) {
						alert('Test succeeded.');
					} else {
						alert('Test failed.');
					}
				},
				error : function(jqXHR, textStatus, errorThrown) {
					if(textStatus === "timeout") {
						alert('Test failed (Server timeout).');
					} else {
						console.log("error: " + jqXHR);
					}
				},
				complete: function(){
					$("div#divLoading").removeClass('show')
				}
			});

}

</script>
</head>

<%
SiteServiceFacadeRouter router = null;
router = SiteServiceContext.getSiteServiceFacadeRouter();

	try {
		regions = router.getRegionListForSiteService();
		Collections.sort(regions, new RegionComparator());

	} catch (ConnectionException cX) {
		throw new IOException(cX);
	} catch (MethodException mX) {
		throw new ServletException(mX);
	}
%>
<body>
	<button onclick="topFunction()" id="myBtn" title="Go to top">Top</button>

	<div class="header">
		<h2> Edit Site Service </h2>
	</div>
	<div class="main-div">
		<%
			for (Region region : regions) {
		%>
		<div class="container">
			<div class="accordion">
				<div class="region-info-div"> 
					<span class="regionNameSpan"> <%=region.getRegionName()%> </span> 
					<span class="regionNumberSpan"> [<%=region.getRegionNumber()%>] </span> 
				</div>
				<div class="region-btn-div">
					<button id="btnAdd" onclick="addRegionClicked(this)">Add</button>
					<button id="btnEdit" onclick="editRegionClicked(this)">Edit</button>
					<button id="btnDelete" onclick="deleteRegionClicked(this)">Delete</button>
					<button id="btnSave" class= "hidden" onclick="saveRegion(this, 'UPDATE')">Save</button>
					<button id="btnCancelSave" class= "hidden" onclick="cancelSaveRegionOnEdit(this)">Cancel</button>
				</div>
			</div>
			<div class="panel">
				<p style="margin-bottom: 0px;">
				<table id="tbl-regions">
					<tbody>
						<tr>
							<th class="td1">Site Name</th>
							<th class="td2">Site #</th>
							<th class="td3">Abbr</th>
							<th class="td4">Patient Lookup Enabled</th>
							<th class="td5">User Authentication Enabled</th>
							<th class="td6">Protocols</th>
							<th class="td7">Action &nbsp;&nbsp;
								<button id="btnAddSite" onclick="addSiteClicked(this)">Add</button>
							</th>
						</tr>
						<%
							List<Site> sites = region.getSites();
								Collections.sort(sites, new SiteComparator());
								for (Site site : sites) {
									Map<String, SiteConnection> siteMap = site.getSiteConnections();
									System.out.println(siteMap.keySet());

									List<String> protocolList = new ArrayList<String>();
									for (Map.Entry<String, SiteConnection> entry : siteMap.entrySet()) {
										protocolList.add(entry.getValue().getProtocol());
									}
						%>
						<tr>
							<td colspan="9" class="site-level-cell"><div
									class="siteLevelAccordion">
									<table class="accordion_table">
										<tbody>
											<tr>
												<td class="td1"><%=site.getSiteName()%></td>
												<td class="td2"><%=site.getSiteNumber()%></td>
												<td class="td3"><%=site.getSiteAbbr()%></td>
												<td align="center" class="td4"><%=site.isSitePatientLookupable()%></td>
												<td align="center" class="td5"><%=site.isSiteUserAuthenticatable()%></td>
												<td class="td6"><%=String.join(", ", protocolList)%></td>
												<td class="td7">
													<button id="btnEditSite" onclick="editSite(this)">Edit</button>
													<button id="btnDeleteSite" onclick="deleteSite(this)">Delete</button>
													<button id="btnSaveSite" class="hidden" onclick="saveSite(this, 'UPDATE')">Save</button>
													<button id="btnCancelSite" class="hidden"
														onclick="cancelSiteSaveWhileEdit(this)">Cancel</button>
												</td>
											</tr>
										</tbody>
									</table>
									<input type="hidden" id="siteNameNum"
										value="<%=site.getSiteName()%>|<%=site.getSiteNumber()%>">
									<input type="hidden" id="siteSecondaryFields"
										value="<%=site.getSiteAbbr()%>|<%=site.isSitePatientLookupable()%>|<%=site.isSiteUserAuthenticatable()%>">
								</div>
								<div class="siteLevelPanel">
									<table class="data_table">
										<tbody>
											<tr>
												<th class="td1">Protocol</th>
												<th class="td2">Server</th>
												<th class="td3">Port</th>
												<th class="td4">Modality</th>
												<th class="td5">Action &nbsp;&nbsp;
													<button id="btnAddSite"
														onclick="addProtocolRow(this)">Add</button>
												</th>
											</tr>
											<%
												for (Map.Entry<String, SiteConnection> entry : siteMap.entrySet()) {
															SiteConnection siteConnection = entry.getValue();
											%>
											<tr>
												<td class="td1"><%=siteConnection.getProtocol()%></td>
												<td class="td2"><%=siteConnection.getServer()%></td>
												<td class="td3"><%=siteConnection.getPort()%></td>
												<td class="td4"><%=siteConnection.getModality()%></td>
												
												<td class="td5">
													<button id="btnEditProtocol" onclick="editProtocol(this)">Edit</button>
													<button id="btnDeleteProtocol" onclick="deleteProtocol(this)">Delete</button>
													<button id="btnSaveProtocol" onclick="saveProtocol(this, 'UPDATE')" class="hidden">Save</button>
													<button id="btnCancelSave" onclick="cancelProtocolSaveWhileEdit(this)" class="hidden">Cancel</button>
													<button id="btnTest" onclick="testProtocol(this)">Test</button> 
													<input type="hidden" id="protFields"
													value="<%=siteConnection.getProtocol()%>|<%=siteConnection.getServer()%>|<%=siteConnection.getPort()%>|<%=siteConnection.getModality()%>">
												</td>
											</tr>
											<%
												}
											%>
										</tbody>
									</table>
								</div></td>
						</tr>
						<%
							}
						%>
					</tbody>
				</table>
				</p>
			</div>
			<input type="hidden" id="regionNameNum"
				value="<%=region.getRegionName()%>|<%=region.getRegionNumber()%>">
		</div>
		<%
			}
		%>
	</div>
	<!-- For loading image -->
	<div id="divLoading"> 
    </div>
</body>
</html>
<%
	} 
%>
<%!
	private String getBaseUrl(HttpServletRequest request) {
		String scheme = request.getScheme() + "://";
		String serverName = request.getServerName();
		String serverPort = (request.getServerPort() == 80) ? "" : ":" + request.getServerPort();
		String contextPath = request.getContextPath();
		return scheme + serverName + serverPort + contextPath;
}%>