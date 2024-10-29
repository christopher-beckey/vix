//////////////////////////////////////////
//
// Utility functions in JavaScript
//
//////////////////////////////////////////


//
// Set and get cookies.
//
function getCookie( label1 ) {
   var label    = label1 + "=";
   var labelLen = label.length;
   var cLen     = document.cookie.length;
   var i = 0;

   while (i < cLen) {
      var j = i + labelLen;
      if ( document.cookie.substring(i,j) == label ) {
         var cEnd = document.cookie.indexOf( ";", j );
         if ( cEnd == -1 ) { 
            cEnd = document.cookie.length;
         }
         return unescape( document.cookie.substring( j, cEnd ) );
      }
      i++;
   }
   return "";
}

// Record current settings in cookie
function setCookie( name, value, expirationTimeMSecs ) {
   var expire = new Date();
   expire.setTime( expire.getTime() + expirationTimeMSecs );
   document.cookie = name + "=" + escape( value ) + "; expires=" + expire.toGMTString() + "; path=/";
}

function deleteCookie( name )
{
	setCookie( name, "deleted", -1000 );
}

//
// Open and close new windows
//
var w;

function openwin(url, winName, myWidth, myHeight)
{
	attributes = "status=no,resizable=yes,scrollbars=yes,";
	attributes += ("width=" + myWidth + ",height=" + myHeight );
	w = window.open(url, winName, attributes );
	if ( !w.opener ) {
		w.opener = self;
	}
	w.focus();
}

function closewin()
{
	w.close();
	return true;
}

// Closes all applet windows by bringing them to the front with an empty page that
// closes itself.
function closeAppletWindows( prefix )
{
	var log_viewer_state     = getLogViewerState();
	var rule_editor_state    = getRuleEditorState();
	var status_monitor_state = getStatusMonitorState();
	var filter_editor_state  = getFilterEditorState();

	if ( log_viewer_state == "open" )
	{
		realTimeLog = window.open( "/empty.html", prefix + "dcfSysConsoleWin" );
	}
	if ( rule_editor_state == "open" )
	{
		ruleEditor = window.open( "/empty.html", prefix + "dpaCfgWin" );
	}
	if ( status_monitor_state == "open" )
	{
		statusMonitor = window.open( "/empty.html", prefix + "dcfStatMonWindow" );
	}
	if ( filter_editor_state == "open" )
	{
		filterEditor = window.open( "/empty.html", prefix + "dcfFilterSets" );
	}
	return true;
}

// Mode management for the CDS editing pages
function getCfgMode() {
	return getCookie( "DcfCfgMode" );
}
function setCfgMode( n ) {
	setCookie( "DcfCfgMode", n, 24 * 1000 * 60 * 60 ); // this setting will expire in 1 day
}

function setLogViewerState( state )
{
	setCookie( "LogViewerState", state, 24 * 1000 * 60 * 60 );
}

function getLogViewerState()
{
	return getCookie( "LogViewerState" );
}

function setRuleEditorState( state )
{
	setCookie( "RuleEditorState", state, 24 * 1000 * 60 * 60 );
}

function getRuleEditorState()
{
	return getCookie( "RuleEditorState" );
}

function setStatusMonitorState( state )
{
	setCookie( "StatusMonitorState", state, 24 * 1000 * 60 * 60 );
}

function getStatusMonitorState()
{
	return getCookie( "StatusMonitorState" );
}

function setFilterEditorState( state )
{
	setCookie( "FilterEditorState", state, 24 * 1000 * 60 * 60 );
}

function getFilterEditorState()
{
	return getCookie( "FilterEditorState" );
}

// Write the current mode for toggling between View and Edit.
function writeCurrentMode()
{
   var myMode = getCfgMode();

   document.write( "<span class=\"blue\">Mode: </span>" );
   if ( myMode != "edit" )
   {
      document.write( "<span class=\"blue\"><font size=\"+1\"><b><em><img src=\"/images/radio-on.gif\" border=\"0\" hspace=\"3\">View</em></b></font></span> | " );
      document.write( "<A HREF=\"javascript:history.go(0)\" onMouseOver=\"window.parent.status=\'Toggle mode\';return true;\" onClick=\"toggleMode()\">" );
      document.write( "<img src=\"/images/radio-off.gif\" border=\"0\" hspace=\"3\">Edit" );
      document.writeln( "</a>" );
   }
   else
   {
      document.write( "<A HREF=\"javascript:history.go(0)\" onMouseOver=\"window.parent.status=\'Toggle mode\';return true;\" onClick=\"toggleMode()\">" );
      document.write( "<img src=\"/images/radio-off.gif\" border=\"0\" hspace=\"3\">View" );
      document.write( "</a>" );
      document.writeln( " | <span class=\"blue\"><font size=\"+1\"><b><em><img src=\"/images/radio-on.gif\" border=\"0\" hspace=\"3\">Edit</em></b></font></span>" );
   }
}

// Toggle the mode -- if it was view, make it edit; and vice versa.
function toggleMode()
{
   var myMode = getCfgMode();

   if ( myMode == "edit" )
   {
      setCfgMode( "view" );
   }
   else
   {
      setCfgMode( "edit" );
   }
   history.go( 0 );
}

// Write the specified text if the protocol is not file: - this allows for
// pages to appear differently if accessed as files than via the web server
function writeIfHTTP( linktext )
{
   if ( location.protocol != "file:" ) {
      document.write( linktext );
   }
}

function nuke_logs()
{
	if ( confirm( "This will delete all inactive files in the log directory,\n" +
	              "including saved log files.\n" +
	              "Do you wish to proceed?" ) )
	{
		location.href = '/cgi-bin/dcfruncgi.dcfpl?dcfnukelogs';
	}
}
