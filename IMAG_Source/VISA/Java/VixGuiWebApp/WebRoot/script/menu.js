/***********************************************
* AnyLink Drop Down Menu- � Dynamic Drive (www.dynamicdrive.com)
* This notice MUST stay intact for legal use
* Visit http://www.dynamicdrive.com/ for full source code
***********************************************/

//Contents for menu 1
var adminSubmenu=new Array();
adminSubmenu[0]='<a href="/Vix/secure/TransactionLog.jspx">Transaction Logs</a>';
adminSubmenu[1]='<a href="/Vix/secure/ResolvedSites.jspx">Site List</a>';
adminSubmenu[2]='<a href="/Vix/secure/SystemProperties.jspx">System Properties</a>';

//Contents for menu 2, and so on
var clientSubmenu=new Array();
clientSubmenu[1]='<a href="/Vix/secure/ClinicalDisplayTestClient.jspx">Clinical Display</a>';
clientSubmenu[2]='<a href="/Vix/secure/ExchangeTestClient.jspx">Exchange</a>';
clientSubmenu[3]='<a href="/Vix/secure/FederationTestClient.jspx">Federation</a>';
		
var webClientSubmenu=new Array();
webClientSubmenu[1]='<a href="/Vix/secure/FindPatient.jspx">Find Patient</a>';
webClientSubmenu[2]='<a href="/Vix/secure/FindTreatingFacilityList.jspx">Treating Facilities</a>';
webClientSubmenu[3]='<a href="/Vix/secure/FindPatientStudies.jspx">Patient Studies</a>';

var menuwidth='165px'; //default menu width
var menubgcolor='lightyellow';  //menu bgcolor
var disappeardelay=250;  //menu disappear speed onMouseout (in miliseconds)
var hidemenu_onclick="yes"; //hide menu when user clicks within menu?

/////No further editting needed

var ie4=document.all;
var ns6=document.getElementById&&!document.all;

//if (ie4||ns6)
//document.write('<div id="dropmenudiv" style="visibility:hidden;width:'+menuwidth+';background-color:'+menubgcolor+'" onMouseover="clearhidemenu()" onMouseout="dynamichide(event)"></div>')

function getposOffset(what, offsettype){
	var totaloffset=(offsettype=="left")? what.offsetLeft : what.offsetTop;
	var parentEl=what.offsetParent;
	while (parentEl!=null) {
		totaloffset=(offsettype=="left")? totaloffset+parentEl.offsetLeft : totaloffset+parentEl.offsetTop;
		parentEl=parentEl.offsetParent;
	}
	return totaloffset;
}


function showhide(obj, e, visible, hidden, menuwidth){
	if (ie4||ns6) dropmenuobj.style.left=dropmenuobj.style.top="-500px";
	if (menuwidth!=""){
		dropmenuobj.widthobj=dropmenuobj.style;
		dropmenuobj.widthobj.width=menuwidth;
	}
	if (e.type=="click" && obj.visibility==hidden || e.type=="mouseover") obj.visibility=visible;
	else if (e.type=="click") obj.visibility=hidden;
}

function iecompattest(){
	return (document.compatMode && document.compatMode!="BackCompat")? document.documentElement : document.body;
}

function clearbrowseredge(obj, whichedge){
	var edgeoffset=0
	if (whichedge=="rightedge"){
		var windowedge=ie4 && !window.opera? iecompattest().scrollLeft+iecompattest().clientWidth-15 : window.pageXOffset+window.innerWidth-15
		dropmenuobj.contentmeasure=dropmenuobj.offsetWidth
		if (windowedge-dropmenuobj.x < dropmenuobj.contentmeasure)
			edgeoffset=dropmenuobj.contentmeasure-obj.offsetWidth
	}
	else{
		var topedge=ie4 && !window.opera? iecompattest().scrollTop : window.pageYOffset
		var windowedge=ie4 && !window.opera? iecompattest().scrollTop+iecompattest().clientHeight-15 : window.pageYOffset+window.innerHeight-18
		dropmenuobj.contentmeasure=dropmenuobj.offsetHeight
		if (windowedge-dropmenuobj.y < dropmenuobj.contentmeasure){ //move up?
			edgeoffset=dropmenuobj.contentmeasure+obj.offsetHeight
		if ((dropmenuobj.y-topedge)<dropmenuobj.contentmeasure) //up no good either?
			edgeoffset=dropmenuobj.y+obj.offsetHeight-topedge
	}
}
return edgeoffset
}

function populatemenu(what){
	if (ie4||ns6)
		dropmenuobj.innerHTML=what.join("")
}


function dropdownmenu(obj, e, menucontents, menuwidth){
	if (window.event) event.cancelBubble=true
	else if (e.stopPropagation) e.stopPropagation()
	clearhidemenu()
	dropmenuobj=document.getElementById? document.getElementById("dropmenudiv") : dropmenudiv
	populatemenu(menucontents)

	if (ie4||ns6){
		showhide(dropmenuobj.style, e, "visible", "hidden", menuwidth)
		dropmenuobj.x=getposOffset(obj, "left")
		dropmenuobj.y=getposOffset(obj, "top")
		dropmenuobj.style.left=dropmenuobj.x-clearbrowseredge(obj, "rightedge")+"px"
		dropmenuobj.style.top=dropmenuobj.y-clearbrowseredge(obj, "bottomedge")+obj.offsetHeight+"px"
}

return clickreturnvalue()
}

function clickreturnvalue(){
	if (ie4||ns6) return false
	else return true
}

function contains_ns6(a, b) {
	while (b != null && b.parentNode)
		if ((b = b.parentNode) == a)
			return true;
	return false;
}

function dynamichide(e){
	if (ie4&&!dropmenuobj.contains(e.toElement))
		delayhidemenu()
	else if (ns6&&e.currentTarget!= e.relatedTarget&& !contains_ns6(e.currentTarget, e.relatedTarget))
		delayhidemenu()
}

function hidemenu(e){
	if (typeof dropmenuobj!="undefined"){
		if (ie4||ns6)
			dropmenuobj.style.visibility="hidden"
	}
}

function delayhidemenu(){
if (ie4||ns6)
delayhide=setTimeout("hidemenu()",disappeardelay)
}

function clearhidemenu(){
if (typeof delayhide!="undefined")
clearTimeout(delayhide)
}

if (hidemenu_onclick=="yes")
document.onclick=hidemenu

