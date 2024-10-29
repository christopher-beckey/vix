var fromDatePicker;      
var toDatePicker;      
var menuModel;
var menuBar;
var studyTree;

function load() {
	window.defaultStatus = "ViX Administration";
	window.status="Loading";
	initMenu();
	window.status="Loaded";
	
	initCalendars();
}

function initCalendars() {
	if( document.getElementById('fromDate') ) {
		fromDatePicker = new Calendar(document.getElementById('selection'), 'fromDatePicker', document.getElementById('fromDate'));
	}
	if( document.getElementById('toDate') ) {
		toDatePicker = new Calendar(document.getElementById('selection'), 'toDatePicker', document.getElementById('toDate'));
	}
}

function initMenu() {
	// create the menu model before accessing the configuration
	// object because the configuration object does not exist until
	// the menu model is created
	var menuModel = new DHTMLSuite.menuModel();
	
	DHTMLSuite.configObj.setCssPath('/Vix/style/');
	DHTMLSuite.configObj.setImagePath('/Vix/images/');
	
	menuModel.addItemsFromMarkup('menuModel');
	menuModel.init();
	
	var menuBar = new DHTMLSuite.menuBar();
	menuBar.addMenuItems(menuModel);
	menuBar.setTarget('menuDiv');
	menuBar.init();
}

function initStudyTree(treeRootElement) {
	studyTree = new StaticTree(treeRootElement);
}

// return the value of the radio button that is checked
// return an empty string if none are checked, or
// there are no radio buttons
function getCheckedValue(radioObj) {
	if(!radioObj)
		return "";
	var radioLength = radioObj.length;
	if(radioLength == undefined)
		if(radioObj.checked)
			return radioObj.value;
		else
			return "";
	for(var i = 0; i < radioLength; i++) {
		if(radioObj[i].checked) {
			return radioObj[i].value;
		}
	}
	return "";
}

// set the radio button with the given value as being checked
// do nothing if there are no radio buttons
// if the given value does not exist, all the radio buttons
// are reset to unchecked
function setCheckedValue(radioObj, newValue) {
	if(!radioObj)
		return;
	var radioLength = radioObj.length;
	if(radioLength == undefined) {
		radioObj.checked = (radioObj.value == newValue.toString());
		return;
	}
	for(var i = 0; i < radioLength; i++) {
		radioObj[i].checked = false;
		if(radioObj[i].value == newValue.toString()) {
			radioObj[i].checked = true;
		}
	}
}

function setRadioGroupValue(radioGroupName, value) {
	var radioGroupElements = document.getElementsByName(radioGroupName);
	for(var i=0; i < radioGroupElements.length; ++i) {
		var radioGroupElement = radioGroupElements[i];
		radioGroupElement.checked = (value == radioGroupElement.value);
	}
}

// Cookie Access and Manipulation Methods
// from http://www.quirksmode.org/js/cookies.html
function createCookie(name,value,days) {
	if (days) {
		var date = new Date();
		date.setTime(date.getTime()+(days*24*60*60*1000));
		var expires = "; expires="+date.toGMTString();
	}
	else var expires = "";
	document.cookie = name+"="+value+expires+"; path=/";
}

function readCookie(name) {
	var nameEQ = name + "=";
	var ca = document.cookie.split(';');
	for(var i=0;i < ca.length;i++) {
		var c = ca[i];
		while (c.charAt(0)==' ') c = c.substring(1,c.length);
		if (c.indexOf(nameEQ) == 0) return c.substring(nameEQ.length,c.length);
	}
	return null;
}

function eraseCookie(name) {
	createCookie(name,"",-1);
}

// addEvent and removeEvent
// cross-browser event handling for IE5+,  NS6 and Mozilla

function addEvent(elm, evType, fn, useCapture)
{
  if (elm.addEventListener){
    elm.addEventListener(evType, fn, useCapture);
    return true;
  } else if (elm.attachEvent){
    var r = elm.attachEvent("on"+evType, fn);
    return r;
  } else {
    alert(evType + " handler could not be added");
  }
} 

function removeEvent(elm, evType, fn, useCapture)
{
  if (elm.removeEventListener){
    elm.removeEventListener(evType, fn, useCapture);
    return true;
  } else if (elm.detachEvent){
    var r = elm.detachEvent("on"+evType, fn);
    return r;
  } else {
    alert(evType + " handler could not be removed");
  }
}
