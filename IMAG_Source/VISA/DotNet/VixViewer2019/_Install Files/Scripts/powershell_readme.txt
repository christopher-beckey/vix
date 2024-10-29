README FILE FOR THE VISTA IMAGING MAG*3.0*348 (PATCH 348) SCRIPTS

Please run the scripts as an Administrator in Microsoft PowerShell 7.2.X.

Note 1: This file uses xxx to refer to the current patch number,
                       nnn to refer to any patch number, and
                       yyy to refer to a script's filename.

Note 2: Patch-specific scripts automatically run during installation if in this folder:
        C:\Program Files\VistA\Imaging\Scripts

        Run at the beginning of installation during uninstall if the name matches this format:
        pxxx_pre_yyy.ps1

        Run at the end of installation if the name matches this format:
        pxxx_post_yyy.ps1
==================================================================================================
Two ways to run a PowerShell script:

1) Launch the PowerShell script in an elevated a PowerShell 7 session.

    File:   pwsh.exe located in C:\Program Files\PowerShell\7
 Purpose:   This PowerShell 7 exe lets you call scripts by specifying the path to the PowerShell
            script and any arguments.
   Use 1:   "path to Powershell script" "required_arg1_value" "optional_arg2_value"
   Use 2:   "path to Powershell script" -required_arg1_name "required_arg1_value" -optional_arg2_name "optional_arg2_value"
Examples:   .\dicom_scp_update.ps1 "CVIX"
            .\permission_fixer.ps1 "C:\VixCache" -deleteCache "$True"
            .\ssl_binder.ps1 "VIX"

2) Run the Powershell script from an elevated Windows command (CMD) prompt.

  Syntax:   pwsh "path to Powershell script" -arg1 "arg1 value"
  Example:  pwsh vixcheck.ps1 -utilPwd "THE_PASSWORD"

==================================================================================================
Additional (mostly PowerShell) scripts for Ops troubleshooting and system administration.

Filename:   CacheCurator.ps1
Argument:   Optionally accepts flag to use relative path.
 Purpose:   This script stops the Viewer/Render services, restores the SQLite database to a version with empty tables,
            completely removes the VIX Render cache contents, and starts the Viewer/Render services.

Filename:   CacheDbSelectRecords.ps1
Argument:   Optionally the path to sqlite3.exe, optionally the path to the sqlite .db file, optionally
            accepts flag to use relative path, and optionally accepts output file.
 Purpose:   Prints all records in all tables in current sqlite database file.

Filename:   CertsVvList.ps1
Argument:   None.
 Purpose:   This script lists the certificates for VIX Viewer Client Authentication.

Filename:   config_backups.ps1
Argument:   The config_backups.ps1 script takes as arguments the patch number and the role type (VIX or CVIX).
 Purpose:   This script makes timestamped backups of the critical config file folders
            for referential purposes located in C:\VIXbackup\Pnnn.

Filename:   delete_vixcache.ps1
Argument:   The delete_vixcache.ps1 script optionally takes as an argument the full path to the VixCache folder.
 Purpose:   This script deletes the contents of the Drive_Letter:\VixCache folder per the vixcache environment
            variable or searches all drives if that is unexpectedly empty.

Filename:   delete_vixcache.ps1
Argument:   The delete_vixcache.ps1 script optionally takes as argument the full path to the VixCache folder.
 Purpose:   This script deletes the contents of the Drive Letter:\VixCache folder.

Filename:   dicom_scp_update.ps1
Argument:   The dicom_scp_update.ps1 script takes as arguments the role type (VIX or CVIX) and optionally
            (CVIX only) if the server is Test or Production.
 Purpose:   This script updates the ae_title_mappings file used for Laurel Bridge and with DICOM SCP
            to use a template for the VIX (to be filled in with Commercial PACs or query retrieve device
            information) and to point to either the Test or Production NilRead(s) for CVIX.

Filename:   GetDbRecords.cmd
Argument:   Debug or Release.
 Purpose:   This script runs the CacheDbSelectRecords.ps1 script, outputs to a text file, and opens that
            text file in Notepad.

Filename:   mixdatasource_update.ps1
Argument:   The mixdatasource_update.ps1 script takes as an argument the role type (VIX or CVIX).
 Purpose:   This script updates the MIXDataSource-1.0.config to point to either the Test or Production
            <host>, <callingAE>, and <calledAE> for AcuoMed and <host> for AcuoAccess. It also applies
            SOP Class UIDs for the blacklist for Clinical Imaging Display, the VIX Viewer, and
            VistaRAd applications.

Filename:   permission_fixer.ps1
Argument:   This script optionally accepts the full path to the VixCache folder, the role type (VIX or CVIX),
            and a flag set to true (default) or false to delete the VixCache folder prior to setting permissions.
 Purpose:   This script sets "apachetomcat" user group membership and permissions for the folders:
            * C:\DCF_RunTime_x64
            * C:\VixConfig
            * C:\Program Files\Apache Software Foundation\Tomcat (latest version)
            * C:\Program Files\Java\jre1.(latest version)
            * (Drive Letter):\VixCache
            * (Drive Letter):\VixTxDb

Filename:   port_setting.ps1
Argument:   None.
 Purpose:   This script sets the tcp Dynamic Port Range to start at 1025 with number of ports set
            at 64511.

Filename:   Restart_VIX_Services.ps1
Argument:   None
 Purpose:   This script stops and restarts critical Imaging services for Tomcat9, VIX Viewer
            Service, VIX Render Service and ListenerTool. This provides a performance
            benefit when ran as a daily scheduled task.

Filename:   registry_update.ps1
Argument:   None.
 Purpose:   This script sets the client TCP/IP socket connection timeout (TcpTimedWaitDelay) value
            to 30 in the Windows Registry if it is missing or outside the range of 30 to 240.

Filename:   set_jmx_permissions
Argument:   None.
 Purpose:   This script sets or reverts the required permissions for the jmxremote.password file in
            C:\Program Files\Apache Software Foundation\Tomcat (latest version)\conf. 

Filename:   service_info.ps1
Argument:   None.
 Purpose:   This script provides status information for critical Imaging services for Tomcat,
            VIX Viewer Service, VIX Render Service, and ListenerTool.

Filename:   ssl_binder.ps1
Argument:   The ssl_binder.ps1 script takes as an argument the role type (VIX or CVIX)
            and optionally a number to signify the mode (0 is installer mode, 1 is standalone mode).
 Purpose:   This script retrieves the thumbprint of the appropriate SSL certificate
            presented by the local VIX server. It binds ports to that certificate to facilitate
            secure data traffic between the VIX and CVIX servers. The ports are read from the
            VIX.Viewer.Config file (343 and 344 are default).
            This script in standalone mode allows for deletion of expired client authentication
            certificates, determining the current thumbprints bound to ports 343 and 344,
            and re-binding of the ports 343 and 344 to a chosen certificate.

Filename:   style_broker.ps1
Argument:   None.
 Purpose:   This script displays Style Broker settings and allows toggling between new and old Style Broker settings.

Filename:   task_scheduler.ps1
Argument:   None.
 Purpose:   This script creates a Scheduled Task for the VIX services restarts (Restart_VIX_Services.ps1).
            The script sets the restart time to 04:00 but can be adjusted by the site admins if desired by editing
            line 24: Daily -At 4:00am (recommending you copy the file to your own folder).

Filename:   VixCheck.ps1
Argument:   -utilPwd theUtilityPassword followed by optional arguments (-fqdn theServer -accessCode theAC
            -verifyCode theVC -icn theICN -siteId theSiteNumber -userId theUserId).
 Purpose:   The script gets a VIX Java Security Token from a server based on a VistA Access Code and Verify Code pair.
            It also attempts to get user information and treating facilities that might need a special VistA account to work.
