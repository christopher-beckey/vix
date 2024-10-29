/*****************************************************************************
Portions (like 90%) Copyright (C) 2006  Nick Baicoianu

This program is free software; you can redistribute it and/or
modify it under the terms of the GNU General Public License
as published by the Free Software Foundation; either version 2
of the License, or (at your option) any later version.

This program is distributed in the hope that it will be useful,
but WITHOUT ANY WARRANTY; without even the implied warranty of
MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
GNU General Public License for more details.

You should have received a copy of the GNU General Public License
along with this program; if not, write to the Free Software
Foundation, Inc., 51 Franklin Street, Fifth Floor, Boston, MA  02110-1301, USA.

See http://www.javascriptkit.com/script/script2/epoch/index.shtml
*****************************************************************************/

/* 
* This class is an enumeration of the state, the prototype should be treated as a Singleton.
* All class members should be treated as final.
*/
function CalendarState()
{
	this.initializing = 0;
	this.redrawing = 1;
	this.finished = 2;
}

CalendarState.prototype.initialized = 1;

/*
* Date class to format and parse dates
*
*/
/**
 * Copyright (c)2005-2007 Matt Kruse (javascripttoolbox.com)
 * 
 * Dual licensed under the MIT and GPL licenses. 
 * This basically means you can use this code however you want for
 * free, but don't claim to have written it yourself!
 * Donations always accepted: http://www.JavascriptToolbox.com/donate/
 * 
 * Please do not link to the .js files on javascripttoolbox.com from
 * your site. Copy the files locally to your server instead.
 * 
 */
/*
Date functions

These functions are used to parse, format, and manipulate Date objects.
See documentation and examples at http://www.JavascriptToolbox.com/lib/date/

*/
Date.$VERSION = 1.02;

// Utility function to append a 0 to single-digit numbers
Date.LZ = function(x) {return(x<0||x>9?"":"0")+x};
// Full month names. Change this for local month names
Date.monthNames = new Array('January','February','March','April','May','June','July','August','September','October','November','December');
// Month abbreviations. Change this for local month names
Date.monthAbbreviations = new Array('Jan','Feb','Mar','Apr','May','Jun','Jul','Aug','Sep','Oct','Nov','Dec');
// Full day names. Change this for local month names
Date.dayNames = new Array('Sunday','Monday','Tuesday','Wednesday','Thursday','Friday','Saturday');
// Day abbreviations. Change this for local month names
Date.dayAbbreviations = new Array('Sun','Mon','Tue','Wed','Thu','Fri','Sat');
// Used for parsing ambiguous dates like 1/2/2000 - default to preferring 'American' format meaning Jan 2.
// Set to false to prefer 'European' format meaning Feb 1
Date.preferAmericanFormat = true;

// If the getFullYear() method is not defined, create it
if (!Date.prototype.getFullYear) { 
  Date.prototype.getFullYear = function() { var yy=this.getYear(); return (yy<1900?yy+1900:yy); } ;
} 

// Parse a string and convert it to a Date object.
// If no format is passed, try a list of common formats.
// If string cannot be parsed, return null.
// Avoids regular expressions to be more portable.
Date.parseString = function(val, format) {
  // If no format is specified, try a few common formats
  if (typeof(format)=="undefined" || format==null || format=="") {
    var generalFormats=new Array('y-M-d','MMM d, y','MMM d,y','y-MMM-d','d-MMM-y','MMM d','MMM-d','d-MMM');
    var monthFirst=new Array('M/d/y','M-d-y','M.d.y','M/d','M-d');
    var dateFirst =new Array('d/M/y','d-M-y','d.M.y','d/M','d-M');
    var checkList=new Array(generalFormats,Date.preferAmericanFormat?monthFirst:dateFirst,Date.preferAmericanFormat?dateFirst:monthFirst);
    for (var i=0; i<checkList.length; i++) {
      var l=checkList[i];
      for (var j=0; j<l.length; j++) {
        var d=Date.parseString(val,l[j]);
        if (d!=null) { 
          return d; 
        }
      }
    }
    return null;
  };

  this.isInteger = function(val) {
    for (var i=0; i < val.length; i++) {
      if ("1234567890".indexOf(val.charAt(i))==-1) { 
        return false; 
      }
    }
    return true;
  };
  this.getInt = function(str,i,minlength,maxlength) {
    for (var x=maxlength; x>=minlength; x--) {
      var token=str.substring(i,i+x);
      if (token.length < minlength) { 
        return null; 
      }
      if (this.isInteger(token)) { 
        return token; 
      }
    }
  return null;
  };
  val=val+"";
  format=format+"";
  var i_val=0;
  var i_format=0;
  var c="";
  var token="";
  var token2="";
  var x,y;
  var year=new Date().getFullYear();
  var month=1;
  var date=1;
  var hh=0;
  var mm=0;
  var ss=0;
  var ampm="";
  while (i_format < format.length) {
    // Get next token from format string
    c=format.charAt(i_format);
    token="";
    while ((format.charAt(i_format)==c) && (i_format < format.length)) {
      token += format.charAt(i_format++);
    }
    // Extract contents of value based on format token
    if (token=="yyyy" || token=="yy" || token=="y") {
      if (token=="yyyy") { 
        x=4;y=4; 
      }
      if (token=="yy") { 
        x=2;y=2; 
      }
      if (token=="y") { 
        x=2;y=4; 
      }
      year=this.getInt(val,i_val,x,y);
      if (year==null) { 
        return null; 
      }
      i_val += year.length;
      if (year.length==2) {
        if (year > 70) { 
          year=1900+(year-0); 
        }
        else { 
          year=2000+(year-0); 
        }
      }
    }
    else if (token=="MMM" || token=="NNN"){
      month=0;
      var names = (token=="MMM"?(Date.monthNames.concat(Date.monthAbbreviations)):Date.monthAbbreviations);
      for (var i=0; i<names.length; i++) {
        var month_name=names[i];
        if (val.substring(i_val,i_val+month_name.length).toLowerCase()==month_name.toLowerCase()) {
          month=(i%12)+1;
          i_val += month_name.length;
          break;
        }
      }
      if ((month < 1)||(month>12)){
        return null;
      }
    }
    else if (token=="EE"||token=="E"){
      var names = (token=="EE"?Date.dayNames:Date.dayAbbreviations);
      for (var i=0; i<names.length; i++) {
        var day_name=names[i];
        if (val.substring(i_val,i_val+day_name.length).toLowerCase()==day_name.toLowerCase()) {
          i_val += day_name.length;
          break;
        }
      }
    }
    else if (token=="MM"||token=="M") {
      month=this.getInt(val,i_val,token.length,2);
      if(month==null||(month<1)||(month>12)){
        return null;
      }
      i_val+=month.length;
    }
    else if (token=="dd"||token=="d") {
      date=this.getInt(val,i_val,token.length,2);
      if(date==null||(date<1)||(date>31)){
        return null;
      }
      i_val+=date.length;
    }
    else if (token=="hh"||token=="h") {
      hh=this.getInt(val,i_val,token.length,2);
      if(hh==null||(hh<1)||(hh>12)){
        return null;
      }
      i_val+=hh.length;
    }
    else if (token=="HH"||token=="H") {
      hh=this.getInt(val,i_val,token.length,2);
      if(hh==null||(hh<0)||(hh>23)){
        return null;
      }
      i_val+=hh.length;
    }
    else if (token=="KK"||token=="K") {
      hh=this.getInt(val,i_val,token.length,2);
      if(hh==null||(hh<0)||(hh>11)){
        return null;
      }
      i_val+=hh.length;
      hh++;
    }
    else if (token=="kk"||token=="k") {
      hh=this.getInt(val,i_val,token.length,2);
      if(hh==null||(hh<1)||(hh>24)){
        return null;
      }
      i_val+=hh.length;
      hh--;
    }
    else if (token=="mm"||token=="m") {
      mm=this.getInt(val,i_val,token.length,2);
      if(mm==null||(mm<0)||(mm>59)){
        return null;
      }
      i_val+=mm.length;
    }
    else if (token=="ss"||token=="s") {
      ss=this.getInt(val,i_val,token.length,2);
      if(ss==null||(ss<0)||(ss>59)){
        return null;
      }
      i_val+=ss.length;
    }
    else if (token=="a") {
      if (val.substring(i_val,i_val+2).toLowerCase()=="am") {
        ampm="AM";
      }
      else if (val.substring(i_val,i_val+2).toLowerCase()=="pm") {
        ampm="PM";
      }
      else {
        return null;
      }
      i_val+=2;
    }
    else {
      if (val.substring(i_val,i_val+token.length)!=token) {
        return null;
      }
      else {
        i_val+=token.length;
      }
    }
  }
  // If there are any trailing characters left in the value, it doesn't match
  if (i_val != val.length) { 
    return null; 
  }
  // Is date valid for month?
  if (month==2) {
    // Check for leap year
    if ( ( (year%4==0)&&(year%100 != 0) ) || (year%400==0) ) { // leap year
      if (date > 29){ 
        return null; 
      }
    }
    else { 
      if (date > 28) { 
        return null; 
      } 
    }
  }
  if ((month==4)||(month==6)||(month==9)||(month==11)) {
    if (date > 30) { 
      return null; 
    }
  }
  // Correct hours value
  if (hh<12 && ampm=="PM") {
    hh=hh-0+12; 
  }
  else if (hh>11 && ampm=="AM") { 
    hh-=12; 
  }
  return new Date(year,month-1,date,hh,mm,ss);
};

// Check if a date string is valid
Date.isValid = function(val,format) {
  return (Date.parseString(val,format) != null);
};

// Check if a date object is before another date object
Date.prototype.isBefore = function(date2) {
  if (date2==null) { 
    return false; 
  }
  return (this.getTime()<date2.getTime());
};

// Check if a date object is after another date object
Date.prototype.isAfter = function(date2) {
  if (date2==null) { 
    return false; 
  }
  return (this.getTime()>date2.getTime());
};

// Check if two date objects have equal dates and times
Date.prototype.equals = function(date2) {
  if (date2==null) { 
    return false; 
  }
  return (this.getTime()==date2.getTime());
};

// Check if two date objects have equal dates, disregarding times
Date.prototype.equalsIgnoreTime = function(date2) {
  if (date2==null) { 
    return false; 
  }
  var d1 = new Date(this.getTime()).clearTime();
  var d2 = new Date(date2.getTime()).clearTime();
  return (d1.getTime()==d2.getTime());
};

// Format a date into a string using a given format string
Date.prototype.format = function(format) {
  format=format+"";
  var result="";
  var i_format=0;
  var c="";
  var token="";
  var y=this.getYear()+"";
  var M=this.getMonth()+1;
  var d=this.getDate();
  var E=this.getDay();
  var H=this.getHours();
  var m=this.getMinutes();
  var s=this.getSeconds();
  var yyyy,yy,MMM,MM,dd,hh,h,mm,ss,ampm,HH,H,KK,K,kk,k;
  // Convert real date parts into formatted versions
  var value=new Object();
  if (y.length < 4) {
    y=""+(+y+1900);
  }
  value["y"]=""+y;
  value["yyyy"]=y;
  value["yy"]=y.substring(2,4);
  value["M"]=M;
  value["MM"]=Date.LZ(M);
  value["MMM"]=Date.monthNames[M-1];
  value["NNN"]=Date.monthAbbreviations[M-1];
  value["d"]=d;
  value["dd"]=Date.LZ(d);
  value["E"]=Date.dayAbbreviations[E];
  value["EE"]=Date.dayNames[E];
  value["H"]=H;
  value["HH"]=Date.LZ(H);
  if (H==0){
    value["h"]=12;
  }
  else if (H>12){
    value["h"]=H-12;
  }
  else {
    value["h"]=H;
  }
  value["hh"]=Date.LZ(value["h"]);
  value["K"]=value["h"]-1;
  value["k"]=value["H"]+1;
  value["KK"]=Date.LZ(value["K"]);
  value["kk"]=Date.LZ(value["k"]);
  if (H > 11) { 
    value["a"]="PM"; 
  }
  else { 
    value["a"]="AM"; 
  }
  value["m"]=m;
  value["mm"]=Date.LZ(m);
  value["s"]=s;
  value["ss"]=Date.LZ(s);
  while (i_format < format.length) {
    c=format.charAt(i_format);
    token="";
    while ((format.charAt(i_format)==c) && (i_format < format.length)) {
      token += format.charAt(i_format++);
    }
    if (typeof(value[token])!="undefined") { 
      result=result + value[token]; 
    }
    else { 
      result=result + token; 
    }
  }
  return result;
};

// Get the full name of the day for a date
Date.prototype.getDayName = function() { 
  return Date.dayNames[this.getDay()];
};

// Get the abbreviation of the day for a date
Date.prototype.getDayAbbreviation = function() { 
  return Date.dayAbbreviations[this.getDay()];
};

// Get the full name of the month for a date
Date.prototype.getMonthName = function() {
  return Date.monthNames[this.getMonth()];
};

// Get the abbreviation of the month for a date
Date.prototype.getMonthAbbreviation = function() { 
  return Date.monthAbbreviations[this.getMonth()];
};

// Clear all time information in a date object
Date.prototype.clearTime = function() {
  this.setHours(0); 
  this.setMinutes(0);
  this.setSeconds(0); 
  this.setMilliseconds(0);
  return this;
};

// Add an amount of time to a date. Negative numbers can be passed to subtract time.
Date.prototype.add = function(interval, number) {
  if (typeof(interval)=="undefined" || interval==null || typeof(number)=="undefined" || number==null) { 
    return this; 
  }
  number = +number;
  if (interval=='y') { // year
    this.setFullYear(this.getFullYear()+number);
  }
  else if (interval=='M') { // Month
    this.setMonth(this.getMonth()+number);
  }
  else if (interval=='d') { // Day
    this.setDate(this.getDate()+number);
  }
  else if (interval=='w') { // Weekday
    var step = (number>0)?1:-1;
    while (number!=0) {
      this.add('d',step);
      while(this.getDay()==0 || this.getDay()==6) { 
        this.add('d',step);
      }
      number -= step;
    }
  }
  else if (interval=='h') { // Hour
    this.setHours(this.getHours() + number);
  }
  else if (interval=='m') { // Minute
    this.setMinutes(this.getMinutes() + number);
  }
  else if (interval=='s') { // Second
    this.setSeconds(this.getSeconds() + number);
  }
  return this;
};

/* ================================================================== */
/* The Calendar 'class' manages the popup date picker                 */
/* ================================================================== */
/**
 * The Calendar 'constructor'
 * param name - the name of the calendar element created by this class
 * param target - the name of the element that this calendar writes seledcted values to
 * 
 * from http://mckoss.com/jscript/object.htm
 * Amazingly, JavaScript also can support private members in an object. 
 * When the constructor is called, variables declared in the function scope of the constructor will 
 * actually persist beyond the lifetime of the construction function itself. To access these 
 * variables, you need only create local functions within the scope of the constructor.  
 * They may reference local variables in the constructor.
 **/
function Calendar(parent, name, target) 
{
	var browserSniffer = new Browser();
	this.state = CalendarState.prototype.initializing;
	
	this.parent = parent;
	this.name = name;
	this.targetElement = target;
	
	this.curDate = new Date();
	this.selectedDate = this.curDate;
	this.setLocale();
	
	this.displayYearInitial = this.curDate.getFullYear(); //the initial year to display on load
	this.displayMonthInitial = this.curDate.getMonth(); //the initial month to display on load (0-11)
	this.displayDayInitial = this.curDate.getDay(); //the initial day to display on load (0- (daysInMonth-1) )
	this.rangeYearLower = 1900;
	this.rangeYearUpper = this.displayYearInitial;
	this.minDate = new Date(1900,0,1);
	this.maxDate = this.curDate;
	
	this.displayYear = this.displayYearInitial;
	this.displayMonth = this.displayMonthInitial;
	
	this.createCalendar(); //create the calendar DOM element and its children, and their related objects
	
	this.topOffset = this.targetElement.offsetHeight; // the vertical distance (in pixels) to display the calendar from the Top of its input element
	this.leftOffset = 0; 					// the horizontal distance (in pixels) to display the calendar from the Left of its input element
	
	this.calendar.style.position = 'absolute';
	this.visible = false;
	document.body.appendChild(this.calendar);
	this.targetElement.calendar = this;
	this.targetElement.onfocus = function () {this.calendar.show();}; //the calendar will popup when the input element is focused
	this.targetElement.onblur = function () {if(!this.calendar.mousein){this.calendar.hide();}}; //the calendar will hide when the input element loses focus

	this.state = CalendarState.prototype.finished;
	this.hide();

	return true;
}

Calendar.prototype.show = function () //PUBLIC: displays the calendar
{
	this.calendar.style.top = browserSniffer.getElementTop(this.targetElement.id) + "px";
	this.calendar.style.left = (browserSniffer.getElementLeft(this.targetElement.id) + browserSniffer.getElementWidth(this.targetElement.id) + 100) + "px";
	this.calendar.style.display = 'block';
	this.visible = true;
};

Calendar.prototype.hide = function () //PUBLIC: Hides the calendar
{
	this.calendar.style.display = 'none';
	this.visible = false;
};

Calendar.prototype.getTop = function (element) //PRIVATE: returns the absolute Top value of element, in pixels
{
	if(element == null){ return 0;}
	if(element === null){ return 0;}
		
    var oNode = element;
    var iTop = 0;
    
    while(oNode.tagName != 'BODY') {
        iTop += oNode.offsetTop;
        oNode = oNode.offsetParent;
    }
    
    return iTop;
};

Calendar.prototype.getLeft = function (element) //PRIVATE: returns the absolute Left value of element, in pixels
{
	if(element == null){return 0;}
	if(element === null){return 0;}
		
    var oNode = element;
    var iLeft = 0;
    
    while(oNode.tagName != 'BODY') {
        iLeft += oNode.offsetLeft;
        oNode = oNode.offsetParent;        
    }
    
    return iLeft;
};

Calendar.prototype.setClass = function (element,className) //PRIVATE: sets the CSS class of the element, W3C & IE
{
	element.setAttribute('class',className);
	element.setAttribute('className',className); //<iehack>
};

Calendar.prototype.createCalendar = function ()  //PRIVATE: creates the full DOM implementation of the calendar
{
	var tbody, tr, td;
	this.calendar = document.createElement('table');
	this.calendar.setAttribute('id',this.name);
	this.setClass(this.calendar,'calendar');
	//to prevent IE from selecting text when clicking on the calendar
	this.calendar.onselectstart = function() {return false;};
	this.calendar.ondrag = function() {return false;};
	tbody = document.createElement('tbody');
	
	//create the Main Calendar Heading
	tr = document.createElement('tr');
	td = document.createElement('td');
	td.appendChild(this.createMainHeading());
	tr.appendChild(td);
	tbody.appendChild(tr);
	
	//create the calendar Day Heading
	tr = document.createElement('tr');
	td = document.createElement('td');
	td.appendChild(this.createDayHeading());
	tr.appendChild(td);
	tbody.appendChild(tr);

	//create the calendar Day Cells
	tr = document.createElement('tr');
	td = document.createElement('td');
	td.setAttribute('id',this.name+'_cell_td');
	this.calCellContainer = td;	//used as a handle for manipulating the calendar cells as a whole
	td.appendChild(this.createCalCells());
	tr.appendChild(td);
	tbody.appendChild(tr);
	
	//create the calendar footer
	tr = document.createElement('tr');
	td = document.createElement('td');
	td.appendChild(this.createFooter());
	tr.appendChild(td);
	tbody.appendChild(tr);
	
	//add the tbody element to the main calendar table
	this.calendar.appendChild(tbody);

	//and add the onmouseover events to the calendar table
	this.calendar.owner = this;
	this.calendar.onmouseover = function() {this.owner.mousein = true;};
	this.calendar.onmouseout = function() {this.owner.mousein = false;};
};

//-----------------------------------------------------------------------------
Calendar.prototype.createMainHeading = function () //PRIVATE: Creates the primary calendar heading, with months & years
{
	//create the containing <div> element
	var container = document.createElement('div');
	container.setAttribute('id',this.name+'_mainheading');
	this.setClass(container,'mainheading');
	//create the child elements and other variables
	this.monthSelect = document.createElement('select');
	this.yearSelect = document.createElement('select');
	var monthDn = document.createElement('input'), monthUp = document.createElement('input');
	var opt, i;
	//fill the month select box
	for(i=0;i<12;i+=1)
	{
		opt = document.createElement('option');
		opt.setAttribute('value',i);
		if(this.state == CalendarState.prototype.initializing && this.displayMonth == i) {
			opt.setAttribute('selected','selected');
		}
		opt.appendChild(document.createTextNode(this.monthlist[i]));
		this.monthSelect.appendChild(opt);
	}
	//and fill the year select box
	for(i=this.rangeYearLower;i<=this.rangeYearUpper;i+=1)
	{
		opt = document.createElement('option');
		opt.setAttribute('value',i);
		if(this.state == CalendarState.prototype.initializing && this.displayYear == i) {
			opt.setAttribute('selected','selected');
		}
		opt.appendChild(document.createTextNode(i));
		this.yearSelect.appendChild(opt);		
	}
	//add the appropriate children for the month buttons
	monthUp.setAttribute('type','button');
	monthUp.setAttribute('value','>');
	monthUp.setAttribute('title',this.monthup_title);
	monthDn.setAttribute('type','button');
	monthDn.setAttribute('value','<');
	monthDn.setAttribute('title',this.monthdn_title);
	this.monthSelect.owner = this.yearSelect.owner = monthUp.owner = monthDn.owner = this;  //hack to allow us to access this calendar in the events (<fix>??)
	
	//assign the event handlers for the controls
	monthUp.onmouseup = function () {this.owner.nextMonth();};
	monthDn.onmouseup = function () {this.owner.prevMonth();};
	this.monthSelect.onchange = function() {
		this.owner.displayMonth = this.value;
		this.owner.displayYear = this.owner.yearSelect.value; 
		this.owner.goToMonth(this.owner.displayYear,this.owner.displayMonth);
	};
	this.yearSelect.onchange = function() {
		this.owner.displayMonth = this.owner.monthSelect.value;
		this.owner.displayYear = this.value; 
		this.owner.goToMonth(this.owner.displayYear,this.owner.displayMonth);
	};
	
	//and finally add the elements to the containing div
	container.appendChild(monthDn);
	container.appendChild(this.monthSelect);
	container.appendChild(this.yearSelect);
	container.appendChild(monthUp);
	return container;
};

Calendar.prototype.createFooter = function () //PRIVATE: creates the footer of the calendar - goes under the calendar cells
{
	var container = document.createElement('div');
	
	var clearSelected = document.createElement('input');
	clearSelected.setAttribute('type','button');
	clearSelected.setAttribute('value',this.clearbtn_caption);
	clearSelected.setAttribute('title',this.clearbtn_title);
	clearSelected.owner = this;
	clearSelected.onclick = function() { this.owner.resetSelections(false);};
	container.appendChild(clearSelected);
	
	var cancel = document.createElement('input');
	cancel.setAttribute('type','button');
	cancel.setAttribute('value',this.cancel_caption);
	cancel.setAttribute('title',this.cancel_title);
	cancel.owner = this;
	cancel.onclick = function() { this.owner.cancel();};
	container.appendChild(cancel);
	
	return container;
};

Calendar.prototype.createDayHeading = function ()  //PRIVATE: creates the heading containing the day names
{
	//create the table element
	this.calHeading = document.createElement('table');
	this.calHeading.setAttribute('id',this.name+'_caldayheading');
	this.setClass(this.calHeading,'caldayheading');
	var tbody,tr,td;
	tbody = document.createElement('tbody');
	tr = document.createElement('tr');
	this.cols = new Array(false,false,false,false,false,false,false);
	
	//if we're showing the week headings, create an empty <td> for filler
	if(this.showWeeks)
	{
		td = document.createElement('td');
		td.setAttribute('class','wkhead');
		td.setAttribute('className','wkhead'); //<iehack>
		tr.appendChild(td);
	}
	//populate the day titles
	for(var dow=0;dow<7;dow+=1)
	{
		td = document.createElement('td');
		td.appendChild(document.createTextNode(this.daylist[dow]));
		if(this.selectMultiple) { //if selectMultiple is true, assign the cell a CalHeading Object to handle all events
			td.headObj = new CalHeading(this,td,(dow + this.startDay < 7 ? dow + this.startDay : dow + this.startDay - 7));
		}
		tr.appendChild(td);
	}
	tbody.appendChild(tr);
	this.calHeading.appendChild(tbody);
	return this.calHeading;	
};

Calendar.prototype.createCalCells = function ()  //PRIVATE: creates the table containing the calendar day cells
{
	this.rows = new Array(false,false,false,false,false,false);
	this.cells = new Array();
	var row = -1, totalCells = (this.showWeeks ? 48 : 42);
	var beginDate = new Date(this.displayYear,this.displayMonth, 1);
	var endDate = new Date( this.displayYear, this.displayMonth, beginDate.getDaysInMonth() );
	var sdt = new Date(beginDate);
	sdt.setDate(sdt.getDate() + (this.startDay - beginDate.getDay()) - (this.startDay - beginDate.getDay() > 0 ? 7 : 0) );
	//create the table element
	this.calCells = document.createElement('table');
	this.calCells.setAttribute('id',this.name+'_calcells');
	this.setClass(this.calCells,'calcells');
	var tbody,tr,td;
	tbody = document.createElement('tbody');
	for(var i=0;i<totalCells;i+=1)
	{
		if(this.showWeeks) //if we are showing the week headings
		{
			if(i % 8 === 0)
			{
				row+=1;
				tr = document.createElement('tr');
				td = document.createElement('td');
				if(this.selectMultiple) { //if selectMultiple is enabled, create the associated weekObj objects
					td.weekObj = new WeekHeading(this,td,sdt.getWeek(),row);
				}
				else //otherwise just set the class of the td for consistent look
				{
					td.setAttribute('class','wkhead');
					td.setAttribute('className','wkhead'); //<iehack>
				}
				td.appendChild(document.createTextNode(sdt.getWeek()));			
				tr.appendChild(td);
				i+=1;
			}
		}
		else if(i % 7 === 0){ //otherwise, new row every 7 cells
			row+=1;
			tr = document.createElement('tr');
		}
		//create the day cells
		td = document.createElement('td');
		td.appendChild(document.createTextNode(sdt.getDate()));// +' ' +sdt.getUeDay()));
		var cell = new CalCell(this,td,sdt,row);
		this.cells.push(cell);
		td.cellObj = cell;
		sdt.setDate(sdt.getDate() + 1); //increment the date
		tr.appendChild(td);
		tbody.appendChild(tr);
	}
	this.calCells.appendChild(tbody);
	this.reDraw();
	return this.calCells;
};

Calendar.prototype.dateSelectedEvent = function(dateSelected)		// PRIVATE: called by the calendar cells when the use clicks on a day
{
	this.selectedDate = dateSelected;
	this.targetElement.value = dateSelected.format("MM/dd/yyyy");
	this.hide();
	//alert(this.selectedDate + ":" + this.targetElement.value);
};

Calendar.prototype.cancel = function()
{
	this.hide();
};

Calendar.prototype.resetSelections = function (returnToDefaultMonth)  //PRIVATE: reset the calendar's selection variables to defaults
{
	this.selectedDate = new Date();
	this.rows = new Array(false,false,false,false,false,false,false);
	this.cols = new Array(false,false,false,false,false,false,false);
	if(this.tgt)  //if there is a target element, clear it too
	{
		this.tgt.value = '';
		if(this.mode == 'popup') {//hide the calendar if in popup mode
			this.hide();
		}
	}
		
	if(returnToDefaultMonth === true) {
		this.goToMonth(this.displayYearInitial,this.displayMonthInitial);
	}
	else {
		this.reDraw();
	}
};
//-----------------------------------------------------------------------------
Calendar.prototype.reDraw = function () //PRIVATE: reapplies all the CSS classes for the calendar cells, usually called after chaning their state
{
	this.state = CalendarState.prototype.redrawing;
	var i,j;
	for(i=0;i<this.cells.length;i+=1) {
		this.cells[i].selected = false;
	}
	for(i=0;i<this.cells.length;i+=1)
	{
		if(this.cells[i].date.getUeDay() == this.selectedDate.getUeDay() ) {
			this.cells[i].selected = true;
		}

		this.cells[i].setClass();
	}
	//alert(this.selectedDates);
	this.state = CalendarState.prototype.finished;
};

Calendar.prototype.deleteCells = function () //PRIVATE: removes the calendar cells from the DOM (does not delete the cell objects associated with them
{
	this.calCellContainer.removeChild(this.calCellContainer.firstChild); //get a handle on the cell table (optional - for less indirection)
	this.cells = new Array(); //reset the cells array
};

Calendar.prototype.goToMonth = function (year,month) //PUBLIC: sets the calendar to display the requested month/year
{
	this.monthSelect.value = this.displayMonth = month;
	this.yearSelect.value = this.displayYear = year;
	this.deleteCells();
	this.calCellContainer.appendChild(this.createCalCells());
};

Calendar.prototype.nextMonth = function () //PUBLIC: go to the next month.  if the month is december, go to january of the next year
{
	
	//increment the month/year values, provided they're within the min/max ranges
	if(this.monthSelect.value < 11) {
		this.monthSelect.value+=1;
	}
	else
	{
		if(this.yearSelect.value < this.rangeYearUpper)
		{
			this.monthSelect.value = 0;
			this.yearSelect.value+=1;
		}
		else {
			alert(this.maxrange_caption);
		}
	}
	//assign the currently displaying month/year values
	this.displayMonth = this.monthSelect.value;
	this.displayYear = this.yearSelect.value;
	
	//and refresh the calendar for the new month/year
	this.deleteCells();
	this.calCellContainer.appendChild(this.createCalCells());
};
//-----------------------------------------------------------------------------
Calendar.prototype.prevMonth = function () //PUBLIC: go to the previous month.  if the month is january, go to december of the previous year
{
	//increment the month/year values, provided they're within the min/max ranges
	if(this.monthSelect.value > 0) {
		this.monthSelect.value-=1;
	} else {
		if(this.yearSelect.value > this.rangeYearLower)
		{
			this.monthSelect.value = 11;
			this.yearSelect.value-=1;
		}
		else {
			alert(this.maxrange_caption);
		}
	}
	
	//assign the currently displaying month/year values
	this.displayMonth = this.monthSelect.value;
	this.displayYear = this.yearSelect.value;
	
	//and refresh the calendar for the new month/year
	this.deleteCells();
	this.calCellContainer.appendChild(this.createCalCells());
};
//-----------------------------------------------------------------------------
// 
//-----------------------------------------------------------------------------
function CalCell(owner,tableCell,dateObj,row)
{
	this.owner = owner;		//used primarily for event handling
	this.tableCell = tableCell; 			//the link to this cell object's table cell in the DOM
	this.cellClass = "CalendarCell";			//the CSS class of the cell
	this.selected = false;	//whether the cell is selected (and is therefore stored in the owner's selectedDates array)
	this.date = new Date(dateObj);
	this.dayOfWeek = this.date.getDay();
	this.week = this.date.getWeek();
	this.tableRow = row;
	
	//assign the event handlers for the table cell element
	this.tableCell.onclick = this.onclick;
	this.tableCell.onmouseover = this.onmouseover;
	this.tableCell.onmouseout = this.onmouseout;
	
	//and set the CSS class of the table cell
	this.setClass();
}
//-----------------------------------------------------------------------------
CalCell.prototype.onmouseover = function () //replicate CSS :hover effect for non-supporting browsers <iehack>
{
	this.setAttribute('class',this.cellClass + ' hover');
	this.setAttribute('className',this.cellClass + ' hover');
};
//-----------------------------------------------------------------------------
CalCell.prototype.onmouseout = function () //replicate CSS :hover effect for non-supporting browsers <iehack>
{
	this.cellObj.setClass();
};
//-----------------------------------------------------------------------------
CalCell.prototype.onclick = function () 
{
	//reduce indirection:
	var cell = this.cellObj;
	var owner = cell.owner;
	if(cell.date.getMonth() == owner.displayMonth && cell.date.getFullYear() == owner.displayYear)
	{
		owner.dateSelectedEvent(cell.date);
	}
};

CalCell.prototype.setClass = function ()  //private: sets the CSS class of the cell based on the specified criteria
{
	if(this.selected) {
		this.cellClass = 'cell_selected';
	}
	else if(this.owner.displayMonth != this.date.getMonth() ) {
		this.cellClass = 'notmnth';	
	}
	else if(this.date.getDay() > 0 && this.date.getDay() < 6) {
		this.cellClass = 'wkday';
	}
	else {
		this.cellClass = 'wkend';
	}
	
	if(this.date.getFullYear() == this.owner.curDate.getFullYear() && this.date.getMonth() == this.owner.curDate.getMonth() && this.date.getDate() == this.owner.curDate.getDate()) {
		this.cellClass = this.cellClass + ' curdate';
	}

	this.tableCell.setAttribute('class',this.cellClass);
	this.tableCell.setAttribute('className',this.cellClass); //<iehack>
};

// ----------------------------------------------------------------------------
// Extensions to the Date class
// ----------------------------------------------------------------------------

// return true if the year of the date parameter is a leap year
// else return false
Date.prototype.isLeapYear = function(utc) {
    var y = utc ? this.getUTCFullYear() : this.getFullYear();
    return !(y % 4) && (y % 100) || !(y % 400) ? true : false;
};

Date.prototype.getDayOfYear = function () //returns the day of the year for this date
{
	return parseInt((this.getTime() - new Date(this.getFullYear(),0,1).getTime())/86400000 + 1);
};

Date.prototype.getWeek = function () //returns the day of the year for this date
{
	return parseInt((this.getTime() - new Date(this.getFullYear(),0,1).getTime())/604800000 + 1);
};

Date.prototype.getUeDay = function () //returns the number of DAYS since the UNIX Epoch - good for comparing the date portion
{
	return parseInt(Math.floor((this.getTime() - this.getTimezoneOffset() * 60000)/86400000)); //must take into account the local timezone
};

Date.prototype.dateFormat = function(format)
{
	if(format === null) { // the default date format to use - can be customized to the current locale
		format = 'xMM/dd/YYYY';
	}
	leftZeroFill = function(x) {return(x < 0 || x > 9 ? '' : '0') + x;};
	
	format = format + "";
	var year=this.getFullYear().toString();
	var day=this.getDate();
	var month=this.getMonth();
	
	//alert("raw date is " + month + "/" + day + "/" + year );
	
	// Convert real this parts into formatted versions
	var value = new Object();
	//if (y.length < 4) {y=''+(y-0+1900);}
	value['yy'] = year.substring(2);
	value['yyyy'] = year.toString();
	value['M'] = month+1;
	value['MM'] = leftZeroFill(month+1);
	value['MMM'] = this.getShortMonthName[month];
	value['MMMM'] = this.getLongMonthName[month];
	value['d'] = day;
	value['dd'] = leftZeroFill(day);
	value['ddd'] = this.getShortDayName(day);
	value['dddd'] = this.getLongDayName(day);

	//alert("Formated dd/MM/yyyy elements are " + value['dd'] + "/" + value['MM'] + "/" + value['yyyy'] );
	
	//construct the result string
	var indexChar="";
	var token="";
	var result="";
	var formatIndex = 0;
	while( formatIndex < format.length )
	{
		token="";
		indexChar=format.charAt(formatIndex);
		// tokenize repeating sets of characters
		while( (format.charAt(formatIndex)==indexChar) && (formatIndex < format.length) ) 
		{
			token += format.charAt(formatIndex);
			formatIndex += 1;
		}
		// alert("token = '" + token + "'");
		// if the repeating set is a recognized format token
		// then replace the value
		if (value[token] !== null) { 
			result=result + value[token]; 
		}
		// else the token is not a recognized format token
		// just copy it
		else 
		{ 
			result=result + token; 
		}
	}
	
	return result;
};

//Get the number of days in the month of this Date.
Date.prototype.getDaysInMonth = function() 
{
	var noDays=31;
	/* thirty days hast september, April, June and November ... one-indexed */
	if ( (this.getMonth() == 9) || (this.getMonth() == 4) || (this.getMonth() == 6) ||
	    (this.getMonth() == 11) )
	{
		noDays=30;
	}
	/* February is month 2, again one-indexed */
	else if (this.getMonth() == 2)
	{
		/* a leap year if divisible by 4 and NOT divisible by 1000 */
		if( this.isLeapYear(false) ) {
			noDays = 29;
		} else {
			noDays = 28;
		}
	}
	
	//alert(noDays);
	return noDays;
};

Date.prototype.getLongMonthNames = function()
{
	return new Array("January",'February','March','April','May','June','July','August','September','October','November','December');
};
Date.prototype.getShortMonthNames = function()
{
	return new Array('Jan','Feb','Mar','Apr','May','Jun','Jul','Aug','Sep','Oct','Nov','Dec');
};
Date.prototype.getLongMonthName = function(monthIndex)
{
	return this.getLongMonthNames()[monthIndex];
};
Date.prototype.getShortMonthName = function(monthIndex)
{
	return this.getShortMonthNames()[monthIndex];
};

Date.prototype.getLongDayNames = function()
{
	return new Array('Sunday','Monday','Tuesday','Wednesday','Thursday','Friday','Saturday');
};
Date.prototype.getShortDayNames = function()
{
	return new Array('Sun','Mon','Tue','Wed','Thu','Fri','Sat');
};
Date.prototype.getLongDayName = function(dayIndex)
{
	return this.getLongDayNames()[dayIndex];
};
Date.prototype.getShortDayName = function(dayIndex)
{
	return this.getShortDayNames()[dayIndex];
};
//===============================================================================
// Extensions to the Date class
//===============================================================================
Array.prototype.arrayIndex = function(searchVal,startIndex) //similar to array.indexOf() - created to fix IE deficiencies
{
	startIndex = (startIndex !== null ? startIndex : 0); //default startIndex to 0, if not set
	for(var i=startIndex;i<this.length;i+=1)
	{
		if(searchVal == this[i]) {
			return i;
		}
	}
	return -1;
};


//-----------------------------------------------------------------------------
// Methods below here may be generated to allow for differing Calendar implementations
// Methods above here should not hard code Calendar properties
//-----------------------------------------------------------------------------
Calendar.prototype.setLocale = function()
{
	this.daylist = new Array('Su','Mo','Tu','We','Th','Fr','Sa');
	this.monthlist = new Array('Jan','Feb','Mar','Apr','May','Jun','Jul','Aug','Sep','Oct','Nov','Dec');
	this.monthsInYear = this.monthlist.length;
	
	this.minrange_caption = 'Exceeds minimum calendar value.';
	this.maxrange_caption = 'Exceeds maximum calendar value.';
	this.clearbtn_caption = 'Reset';
	this.clearbtn_title = 'Reset';
	this.cancel_caption = 'Cancel';
	this.cancel_title = 'Cancel';
	
	this.daysInWeek = 7;
	this.startDay = 0;	// offset into the daylist array
};

