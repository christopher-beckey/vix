~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
DCF (DICOM Connectivity Framework) - Setup README File
~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~

======
Index:
======
  - Setup instructions

  - Starting the DCF via the Windows Start menu
  - Manually starting the DCF
  - Uninstalling the DCF
  - Building the Example programs

  - Appendices
    - Notes on Installation Step 7
    - Browser notes
    - Visual Studio notes
    - Eclipse Platform notes
    - Windows XP notes
    - Errata (IMPORTANT: please read.)

Note:  Refer to the DCF Release Notes text file for more information
on changes to the DCF.


==================
Setup Instructions
==================

Follow these instructions to setup your system with the
DCF Toolkit.  Please note that you should be logged in as
the Administrator (or a user with Administrator privileges)
when installing the DCF - otherwise the DCF may not be able
to access all the system resources it needs when installing
and operating.


STEP 0
------
If you have a previous version of the DCF installed, you should uninstall it
before installing the new version of the DCF.

STEP 1
------
Run the program Setup_DCF.exe.  This installer will attempt to determine if
the necessary prerequisite software, listed below, is installed on the
computer.  If their presence cannot be confirmed, you will be given the option
of installing them.  These applications should be installed and configured in
order for the DCF to work.

  JDK - Java Development Kit (Java 2 SDK)
      http://java.sun.com/downloads.html
      Recommended version: 1.6.0_02
      (Note that the Java plug-in is needed to use the applets in
      your web browser.)

     The DCF includes the capability to read and write Dicom files with
     JPEG data.  This functionality requires the following packages, whose
     installers will may be selected separately from the JDK.  They should
     be installed into the same directory as the JDK (or JRE).

        Java Advanced Imaging (JAI) 1.1.3
           https://jai.dev.java.net/binary-builds.html

        Java Advanced Imaging I/O 1.1
           https://jai-imageio.dev.java.net/binary-builds.html

  Apache web server
      http://www.apache.org/dist/httpd/
      Recommended version: 1.3.33 ( The DCF can be used with apache 2.0, requires httpd.conf tweaking )

  .NET Framework (for .NET/Visual Studio 7.x or higher installations only)
      Recommended version: 1.1 (2.0 for VS8.x installs)

  VC 8.0 Redistributable (for .NET 2.0/Visual Studio 8.x installations only)
      The VC8 Redistributable installs updated Microsoft C run-time libraries.

  Web browser
      You must also have a web browser installed in order to control the
      DCF via the Web and to use its applets to monitor the data.  It is
      recommended that you use a new browser, such as Internet Explorer 5+
      or Netscape 6+; older browsers may have issues with Java and the
      Java plug-in.  Please note that JavaScript _must_ be enabled in
      order for the pages to display correctly.  (See "Browser Notes" at
      the end for more information on browser versions.)

  Adobe Acrobat
      http://www.adobe.com
      Many supplementary documents in the DCF are PDF (Portable Document
      Format) files.  Adobe's Acrobat Reader is not necessary to the
      operation of the DCF, but it is needed to view these documents.
      (If you do not have Adobe Acrobat, you can download it from
      www.adobe.com)

  DCF Viewer
      The DCF Viewer allows you to review DICOM files that you have on your
      filesystem.  It includes simple but extensive viewing and editing
      capabilities for many types of files, not just DICOM images.
      If selected, this will be installed into a separate directory from the
      DCF; it will also require a license key to be specified, although it
      uses a different license from your DCF Toolkit uses.
      Note that this is installed _after_ the DCF is installed.

  DCF Developer Documentation
      These are supplemental documents especially useful for developers.
      If selected, these will be installed into the same directory as the
      DCF (the directory is chosen in Step 3 below).  These are optional.
      Note that these are installed _after_ the DCF is installed.

Once the system has these applications installed, proceed.  You may
wish to note where these applications are installed, as you will need to
know this information in Steps 5 and 6 of the installation process.

STEP 2
------
Setup will run the run the DCF installation program, Install_DCF.exe.

The installer will attempt to determine if necessary software, such as Apache
and Java, are installed on the computer.  If their presence cannot be confirmed,
you will be asked if you wish to continue with the installation.  You may choose
to continue installing the DCF and then install the other necessary software
later, or you may cancel the DCF installation to install the necessary support
software first.

   **NOTE** Please read in Step 1 above about installing the additional Java
            Advanced Imaging and JAI I/O packages.

STEP 3
------
You will be prompted to choose a directory for the install, for instance,
"C:\Program Files\DCF".  Enter the desired directory in the dialog box, or
select whatever directory you prefer.

STEP 4
------
The DCF and its associated software require a valid license to operate
correctly.  The license installation key is in a file with the ".key"
extension (e.g., DCF-2.3.0-DEM-DEMO-YYYYMMDD.key).  This file was
provided to you by Laurel Bridge - you may have downloaded it from
the Laurel Bridge web site or had it provided to you separately.
Select the license key file to use and press the "Next"
button to continue with the installation

STEP 5
------
Please enter the paths of necessary components such as Java and Apache.
You may use the "Browse" button to locate these components.  Select a
port for the DCF's Apache Web server to use (be sure another application is
not already using this port).

If you will not be using the Java or Apache based components of the DCF,
you may bypass setting these paths by checking the "Ignore" checkboxes
on this page of the installer.

STEP 6
------
Fill in the domain name of your computer, for example, "my_company.com".
(This is used for configuring the Apache web server that runs with the DCF.)

If you will be doing development with Visual Studio, select the checkbox
and fill in the field below it with the path to the batch file for setting
the Visual Studio environment variables; you may click the "Browse" button
to locate it.  (For Visual Studio 6.x, the file is named vcvars32.bat; the
filename is vsvars32.bat for Visual Studio .NET.  Common values for these paths
are shown below the field.) The specified batch file will be sourced to add the
Visual Studio environment variables to the DCF development environment, in
a DCF Command Prompt, to aid in the development of DCF-based applications.
Uncheck the box if you are not using Visual Studio development tools.

STEP 7
------
After verifying the configuration data, the installer will copy the DCF
files to your system and then configure the DCF and set up the DCF
environment.  These configuration steps may take a few moments, so please
be patient as you wait for the setup commands to finish...

STEP 8
------
The installation will prompt you to reboot the computer. The computer must
be rebooted in order for the environment changes to take effect.

(If you are installing the DCF Developers Documentation or the DCF Viewer,
you may wish to reboot the computer _after_ installing these components.
Please remember to do this.)



===============================================
Starting the DCF via the Windows Start menu
      (See Step 9 below to start it manually):
===============================================

When you installed the DCF, menu options were created on your Start
menu, under the DICOM Connectivity Framework program group.  These
options allow you to start the DCF (and its Apache web server) without
manually opening a command prompt.
   Start -> Programs -> DCF - DICOM Connectivity Framework -> DCF Service Interface
(For Windows XP, this is:
   Start -> All Programs -> DCF - DICOM Connectivity Framework -> DCF Service Interface )

These menu options access batch files for starting Apache and the DCF:
   Start_Apache_and_DCF  -  Starts both and directs your
       browser to the DCF Remote Service Interface
The batch file may be run manually from a command prompt or via the
Start menu.

Once the DCF Remote Service Interface page is displayed, you may start
a DCF system configuration by clicking "Choose a configuration" and then
selecting a configuration of DCF servers to run.

You can also find more information about DCF applications and utilities
under the "DCF Online Documentation" link, and many of the DCF web
pages and applets have help pages accessible from them.


===========================================================
Manually starting the DCF, follow steps 9 and 10 below:
===========================================================

STEP 9
------
To start using the system:
~~~~~~~~~~~~~~~~~~~~~~~~~~
  Open a DCF Command Prompt from the Start menu:
        Start -> Programs -> DCF - DICOM Connectivity Framework -> DCF Command Prompt
  Start the Apache web server - run the command:
    perl -S run_apache.pl
You may minimize this window, which allows Apache to continue running.
If this window is closed, Apache will terminate execution and
will need to be restarted before the DCF may be used.

STEP 10
-------
Open your web browser to the URL:
   http://YOUR_HOSTNAME:APACHE_PORT/cgi-bin/dcf_index.dcfpl
(Note: YOUR_HOSTNAME is replaced with your "Computer Name";
this is found under Start -> Settings -> Control Panel -> Network.
APACHE_PORT is the port that you selected back in Step 5.)

Once the DCF Remote Service Interface page is displayed, you may start
a DCF system configuration by clicking "Choose a configuration" and then
selecting a configuration of DCF servers to run.

You can also find more information about DCF applications and utilities
under the "DCF Online Documentation" link, and many of the DCF web
pages and applets have help pages accessible from them.


=========================
  Uninstalling the DCF
=========================

(Before uninstalling the DCF, please be sure that you have stopped it.
This is done by clicking the "Stop" link on the DCF Remote Service Interface.
You should also stop the Apache server by closing the Perl process
window that is running Apache, or stopping all instances of Apache
via the Windows Task Manager, or by running the "perl -S kill_apache.pl"
script from a DCF Command Prompt.)

Uninstalling the DCF requires removing the files that were installed
and removing the environment settings required for the DCF's operation,
as well as the shortcuts from the Start menu.  These steps are
automated in the uninst-DCF.exe program provided.  (Remember that you
must be logged in with Administrator privileges to install/uninstall the
system and to adjust the system requirements completely.)

To uninstall:
   Click on the "Uninstall DCF" option in the DICOM Connectivity Framework
   program group from the Start menu.  (It may also be uninstalled via
   the Add/Remove Programs option on the Control Panel.)


=========================================
Building the Example Programs
=========================================

Note: For more complete information on the example programs, see the
DCF Developer's Guide, the developer documentation, and the file
doc/DCF_Examples.txt.

See DCF_Examples.txt for information on running the examples

=================================
Building the C++ Example Programs
=================================

NOTE:  You should already have your development environment installed
and setup for your use before building the example programs.

1.  After the system is done rebooting, change to this
    directory:  <install directory>\devel\csrc\examples

2.  Run the "build_files.bat" script to build the examples.
    (You must have VisualStudio already installed; you may need to
    run the vcvars32.bat [vsvars32.bat for .NET installs] script to
    set up the necessary environment variables for your development
    environment.  You should also run dcf_vars.bat to set up the DCF
    environment variables, or use a DCF Command Prompt.)

   [ To build the examples using Visual Studio:
     1.  Change to the directory <install directory>\devel\csrc\examples
     2.  Run the "build_files_vc.bat" script.
     3.  For each example program you wish to build, open its .dsp project
         file in VisualStudio (or Visual C++) and build the project
         (VS .NET will convert the .dsp file to a .vcproj file) ]


==================================
Building the Java Example Programs
==================================

1.  After the system is done rebooting, change to this
    directory:  <install directory>\devel\jsrc\com\lbs\examples

2.  Run the "perl -S dcfmake.pl" command to build the examples.
    (You should also run dcf_vars.bat first to set up the DCF
    environment variables, or use a DCF Command Prompt.)

   (If you are using the Eclipse Platform, see the "Eclipse Platform notes"
   further down in this file.)


=================================
Building the C# Example Programs
=================================

1.  After the system is done rebooting, change to this
    directory:  <install directory>\devel\cssrc\examples

2.  Run the "perl -S dcfmake.pl" command to build the examples.
    (You must have VisualStudio .NET already installed; you may need to
    run the vsvars32.bat script to set up the necessary environment
    variables for your development environment. You should also run
    dcf_vars.bat to set up the DCF environment variables, or use a
    DCF Command Prompt.)



==================================
APPENDICES
==================================


==================================
Notes on Installation Step 7
==================================

Detail on STEP 7:
~~~~~~~~~~~~~~~~~
Following is more information on Step 7 of the DCF installation process.
The installation program does these configuration steps for you - you
may also do them manually if an installation error occurs or you change
the configuration of your system.

If your system's configuration changes, carefully edit the configuration file
as described below in "Editing the configuration information."  You should
then update your environment variables (see "Setting up the environment").

Editing the configuration information
-------------------------------------
    A configuration file is used to hold information necessary for the
    installation:
       <install directory>\platform.cfg
    The values must be set for your system setup.  Examples of typical
    values are provided in the file.  The file may be edited using
    editors like Notepad or Wordpad.  However, it is IMPORTANT that
    the file is saved as a text file.

Setting up the environment
--------------------------
    A script is provided to configure the DCF, including its use
    of the Apache web server and many environment variables that the
    DCF needs.  The setup script operates from the
       "<install directory>" directory and executes

       'perl bin\dcfsetup.pl -zip -web -cds -force -noprompt -platform_file_name platform.cfg -envfile dcf_vars.bat -batch -dcf_root_sysmgr="<sysmgr_instdir>" -dcf_root="<instdir>"'

    to set up the configuration (with the appropriate substitution for
    "instdir" (the DCF installation directory).  After the values are configured,
    the system must be rebooted.
    (Note:  you may omit the "-web" option if you will not be using the Apache
     web server based components of the DCF.)

Setting up the DCF data files
-----------------------------
    The DCF uses a large set of data files to hold the configuration
    information for the system.  These files should be set up by the
    installation process, but they can be manually set up or re-setup
    if they are corrupted.  If this is necessary, go to to DCF install
    directory and execute the command
        "perl bin\update_cds.pl -f"


=============
Browser Notes
=============

Almost any standard web browser can be used to control the DCF and its
operations.  This is done via applets (using Sun's Java plug-in), CGIs,
and standard web pages with JavaScript.  Note that JavaScript _must_
be enabled in order to use the pages properly.  Due to differences in
the implementation of JavaScript in browsers, some browsers may not be
able to display the pages correctly (for example, Linux's Konqueror
browser).  The DCF has been tested successfully on the following browsers:
   - Netscape 4.79, 6.2, 7.0, 7.1 on Windows NT
   - Internet Explorer 5+ on Windows NT, Win2000, and WinXP
   - Mozilla 1.0, 1.2.1, 1.4, 1.7 on Windows NT
   - Mozilla Firebird 0.6.1 on Windows NT
   - Mozilla Firefox 0.9, 1.0 on Windows XP

   It has also been partially tested on:
   - Mozilla 0.9.2.1 on Redhat Linux
   - Netscape 4.78 on Solaris and Redhat Linux


===================
Visual Studio notes
===================

For Visual Studio 6.x:
----------------------
   1)  Install the latest Visual Studio Service Pack (sp5).

   2)  When prompted, do _not_ register the Visual Studio environment
       variables.  Instead, use the vcvars32.bat script to ensure that they
       are available for compilation on the command line.

   3)  If you will be creating C++ applications, you must patch the Visual C++
       6.0 compiler to make XTREE thread-safe by replacing the STL include file
       XTREE with a version to fix multi-threading problems.  Failing to apply
       this patch will cause applications to crash.

       "The header <xtree> (original 25 June 1998) presented here eliminates
       all need for thread locks and corrects a number of thread-safety issues
       for template classes map, multimap, set, and multiset.  It also solves
       some nasty problems with sharing these classes across DLLs."

       To install the XTREE patch:
       A)  Get the updated XTREE file from www.dinkumware.com/vc_fixes.html
           (the file may also be available on your DCF install CD).

       B)  Rename the existing XTREE file and replace it with the XTREE file
           in the patch in this location:
              Visual-Studio-install-dir/VC98/Include

For Visual Studio 7.x or 8.x (.NET):
------------------------------------
   You should install the .NET Framework to ensure that the necessary tools
   are present for installing the DCF's libraries and components.


======================
Eclipse Platform notes
======================

For Eclipse v3.0.1:
-------------------
   To build an example using Eclipse Platform version 3.0.1:
      (Note: if you are using a different version of eclipse, you may have to
      modify these instructions for your version of the Eclipse Platform.)

   - Change to the directory of the example you wish to build,
       e.g., ex_jdcf_HelloWorld.
   - If you have changed the cinfo.cfg file, generate new CINFO.java and
        LOG.java java files by running "perl -S dcfmake.pl -g" from a DCF Command Prompt.

   - Run eclipse from a DCF Command Prompt.
       (Note: this only needs to be done when first setting up the environment
       variables in the run dialog.  After the project is set up, Eclipse
       may be started normally, since the configuration will be saved.)

   - From the File menu, select "New...->Project"; expand "Java", select
       "Java Project", and click "Next".
   - Enter a Project Name as usual, e.g., "DCF Java Examples".
   - Select "Create project in external location"; browse to or enter the
       complete path to the jsrc directory as the "Directory" option.
   - Click next.
   - Select the "Libraries" tab, click "Add External JARS..."; browse to
       "<install directory\classes\LaurelBridge.jar", select it and
       click "Open".
   - Back in the "Libraries" tab, select "Finish".

   - Expand the newly created project, and select your examples from the
       list, e.g., "com.lbs.examples.ex_jdcf_HelloWorld".
   - Expand your example and select the source file containing the main
       class, e.g., ex_jdcf_HelloWorld.java.
   - Right-click on the source file, and choose "Run->Run...".
   - Select and highlight "Java Application" under "Configurations:".
   - Click "New" (this should create a new configuration under
       "Java Application").

   - From the "Environment" tab, click "Select".
   - Click "Select all", and click "Ok".
   - Click radio button "Replace native environment with specified
       environment".

   - Add the necessary program arguments under the "Arguments" tab, e.g.,
       "-appcfg /apps/defaults/ex_jdcf_HelloWorld".
   - Click "Apply".
   - Make sure the DCF is running, and click "Run".

   Your example application should run successfully.


================
Windows XP notes
================

Security has been greatly tightened on Windows XP with the release of Service
Pack 2 (SP2).  Because of this, some HTML documents that use JavaScript may
not display correctly when viewed offline, or they may cause a warning message
to pop up.  This is not an error with the documents, and they will display
correctly if you choose to unblock "active content" in the Local Zone.

Another change from SP2 is that Windows Firewall will alert you to
applications that _may_ require any kind of network access (even local).
Applications may be registered as exceptions via the Windows Firewall option
on the Control Panel; registered applications may also be configured here to
allow or restrict their network access.  In the DCF, applets that are viewed
in Internet Explorer (or other browsers) may cause a warning to appear;
if this happens, you should register your browser as an exception to unblock
it and allow it to continue running normally.  Other DCF executables may cause
similar warnings and should be unblocked to prevent similar messages from
appearing in the future.

Java and Apache may also cause similar firewall warning message boxes to
appear as the DCF is started.  If this happens, you should unblock them to
prevent similar warnings from appearing in the future.

You may also wish to configure your firewall to allow open communication
on the ports used by the DCF and its applications.  The port values may be
found in the configuration files for the DCF applications; most of these
are in the %DCF_ROOT%/cfg/apps/defaults subdirectory.  (You may also find
these ports listed on the DCF's "Configure <servers.cfg>" web page.) You may
may also wish to unblock the DICOM port (104).

If the DCF is running but not communicating with other applications, you
may want to check that the DCF and the applications are configured
with the correct port values.  Then you might check if the firewall is
allowing communication for those applications or for those ports.


======
Errata
======

     1.  Port conflict on Windows
     2.  Signed JAR file for applets

1.  On some Windows systems, conflicts may occur between the ports used by the
operating system and the ports used by the DCF.  Specifically, the default
ports of the DCF's servers may be used by Windows svchost.exe.  If this problem
occurs, you should change the default ports used by the servers.
   Steps:
   a.  Start the DCF via the web browser by clicking the "Start with
       <configuration name>" link.
   b.  Return to the DCF Remote Service Interface.
   c.  Select "Configure <configuration name>.cfg" to configure the servers.
   d.  Change the TCP Port setting for the servers.  (Please be sure that none
       of the port values conflicts with any other.)
   e.  Click "Update" to save the changed values.
   f.  Click "Home" to return to the DCF Remote Service Interface.
   h.  Restart the DCF by clicking "Shutdown..", then return to the Remote
       Service Interface and click "Start with...".

2.  The Java applets used by the DCF now use a signed JAR file.  This is due
to a bug in Sun's CORBA implementation for applets, causing a security
exception to be thrown.  (Bug IDs in Sun's bugs database: 6203567, 5031209)
Now, when a user downloads a DCF applet to their web browser, they will be
prompted to accept the signed applet from "laurelbridge.com".  Most browsers
will let users view the certificate before accepting it.  If the users select
"always", they won't be prompted again about accepting applets in that JAR
file.  Some users may be concerned that accepting the applets will open up
security holes - this is not the case, as the applets do nothing to the local
box.

=================== End of Notes ====================



Disclaimers:
==============================================================================
 Copyright (C) 2000-2008,
 Laurel Bridge Software, Inc.             Tel: 302-453-0222
    160 East Main Street                  Fax: 302-453-9480
    Newark, Delaware 19711 USA            WWW: www.laurelbridge.com
 All Rights Reserved.
==============================================================================
 Note: The software is confidential, and Demo copies are for review purposes
 only.  No license to use Demo versions of the DCF nor the associated scripts,
 tools, or processes, other than for evaluation, is implied or granted.
==============================================================================

