#This script will get the process IDs for the VIX Viewer, Render and Tomcat services
#It will stop and restart each service

# relaunch as an elevated process if not currently in administrator mode
if (-NOT ([Security.Principal.WindowsPrincipal] [Security.Principal.WindowsIdentity]::GetCurrent()).IsInRole([Security.Principal.WindowsBuiltInRole]::Administrator))
{
    $PSHost = If ($PSVersionTable.PSVersion.Major -gt 5) {'PwSh'} else {'PowerShell'}
    Start-Process $PSHost -Verb RunAs "-NoProfile -ExecutionPolicy Bypass -Command `"cd '$($PWD.Path)'; & '$PSCommandPath'`"";
    Exit
}

#This outputs everything to a file to troubleshoot"
#$myTimestamp = Get-Date -Format 'yyyyMMdd.hhmmss'
#Start-Transcript -path "C:\Program Files\VistA\Imaging\Scripts\autorestart_vix_services_output.txt"

function Stop-ServiceWithTimeout {
	param([string] $svcname, [int] $svcwait)
    $timespan = New-Object -TypeName System.Timespan -ArgumentList 0,0,$svcwait
    $svc = Get-Service -Name $svcname
    $svc.Stop()
    try {
        $svc.WaitForStatus([ServiceProcess.ServiceControllerStatus]::Stopped, $timespan)
    }
    catch [ServiceProcess.TimeoutException] {
        return $false
    }
    return $true
}

function Test-TomcatStartup {
	param([string] $tomname, [int] $attemptnum, [int] $tomwait)
    $attemptnum++
    $ts = Get-CimInstance -Class Win32_Service -Filter "Name LIKE '$tomname'" | Select-Object -ExpandProperty State
    Write-Output "$tomname is $ts."
    if ($ts -eq 'Running') {
        Write-Output "tomcat service successfully restarted."
        #test for DICOM SCP failure, indicative of LBS deadlock
        $scpUp = $false
        $waitCount = 0
        while (($true -ne $scpUp) -and ($waitCount -lt 18)){
            $waitCount++
            Start-Sleep -s 10 #wait for DICOM SCP listener to be up, overkill but better safe...
            Write-Output "Waiting for DICOM SCP Listener count $waitCount x 10 secs."
            $test = (Get-NetTCPConnection -State Listen).LocalPort | Select-String "^104$"
            if ($test.Length -gt 0) {
                $lp = Get-Process -Id (Get-NetTCPConnection -LocalPort 104).OwningProcess
                $tp = Get-Process -Id (Get-NetTCPConnection -LocalPort 8442).OwningProcess
                if ($lp.Id -eq $tp.Id) {
                    $scpUp = $true
                    break
                }
            }
        }
        if (-not $scpUp) {
            Write-Output "DICOM SCP not listening on port 104, restarting services."
            if ($attemptnum -le 3) {
                Stop-Tomcat -tomname $tomname -tomwait $tomwait
                Start-Tomcat -tomname $tomname -attemptnum $attemptnum -tomwait $tomwait
            } else {
                Write-Output "DICOM SCP not listening on port 104. Max retries ( $attemptnum ) exceeded. Future Image Service deadlock is likely."
            }
        } else {
            Write-Output "DICOM SCP is up."
        }
    } elseif ($attemptnum -le 3) {
        Write-Output "Tomcat startup failed. Retrying."
        Start-Tomcat -tomname $tomname -attemptnum $attemptnum -tomwait $tomwait
    } else {
         Write-Output "Tomcat startup failed. Final Tomcat state is $ts."
    }
}

function Start-Tomcat {
    [CmdletBinding(SupportsShouldProcess, ConfirmImpact = 'Low')]
	param([string] $tomname, [int] $attemptnum, [int] $tomwait)
    Start-Service -Name "$tomname"
    Start-Sleep -s 10
    Test-TomcatStartup -tomname $tomname -attemptnum $attemptnum -tomwait $tomwait
}

function Stop-Tomcat {
    [CmdletBinding(SupportsShouldProcess, ConfirmImpact = 'Low')]
	param([string] $tomname, [int] $tomwait)
    $tomcatproc =  Stop-ServiceWithTimeout -svcname $tomname -svcwait $tomwait
    if ($false -eq $tomcatproc) {
        Write-Output "tomcat service did not stop in $tomwait seconds, killing process."
        Stop-Process -Name "$tomname" -Force
    }else{
		Write-Output "verifying tomcat service did stop in $tomwait seconds."
	}
    Start-Sleep -s 10
}

$tomcatname = "Tomcat9"
$viewername = "VIX Viewer Service"
$rendername = "VIX Render Service"
#$listenername = "ListenerTool"
$tomcatwait = 20 # number of seconds to wait for tomcat to stop before killing process

#Shut down and restart Tomcat Service
#Pre-shutdown statuses
$tomcatpid = Get-CimInstance -Class Win32_Service -Filter "Name LIKE '$tomcatname'" | Select-Object -ExpandProperty ProcessId
$tomcatstatus = Get-CimInstance -Class Win32_Service -Filter "Name LIKE '$tomcatname'" | Select-Object -ExpandProperty Status
$tomcatstate = Get-CimInstance -Class Win32_Service -Filter "Name LIKE '$tomcatname'" | Select-Object -ExpandProperty State
Write-Output "***** Tomcat9 Service *****"
Write-Output "Tomcat PID:  $tomcatpid"
Write-Output $tomcatstatus
Write-Output $tomcatstate

#check state
#if "Running", proceed to shutdown.  if not log and alert.
if ($tomcatstate -eq 'Running') {
	Write-Output "$tomcatname service is running.  Stopping service..."
	Stop-Tomcat -tomname $tomcatname -tomwait $tomcatwait

	$tomcatstate2 = Get-CimInstance -Class Win32_Service -Filter "Name LIKE '$tomcatname'" | Select-Object -ExpandProperty State
	Write-Output "$tomcatname is $tomcatstate2 ."
	if ($tomcatstate2 -eq 'Stopped') {
        Write-Output "tomcat service successfully stopped.  Restarting service..."
        Start-Tomcat -tomname $tomcatname -attemptnum 0 -tomwait $tomcatwait
	}
} else {
	Write-Output "$tomcatname is not running.  That's not good."
	Write-Output "Attempting to start $tomcatname service.  Starting service..."
	Start-Tomcat -tomname $tomcatname -attemptnum 0 -tomwait $tomcatwait
}
#Post-restart statuses
$prs_tomcatpid = Get-CimInstance -Class Win32_Service -Filter "Name LIKE '$tomcatname'" | Select-Object -ExpandProperty ProcessId
$prs_tomcatstatus = Get-CimInstance -Class Win32_Service -Filter "Name LIKE '$tomcatname'" | Select-Object -ExpandProperty Status
$prs_tomcatstate = Get-CimInstance -Class Win32_Service -Filter "Name LIKE '$tomcatname'" | Select-Object -ExpandProperty State
Write-Output "-NEW- tomcat PID:  $prs_tomcatpid"
Write-Output $prs_tomcatstatus
Write-Output $prs_tomcatstate
Write-Output "**********"

#Shut down and restart VIX Viewer Service
#Pre-shutdown statuses
$viewerpid = Get-CimInstance -Class Win32_Service -Filter "Name LIKE '$viewername'" | Select-Object -ExpandProperty ProcessId
$viewerstatus = Get-CimInstance -Class Win32_Service -Filter "Name LIKE '$viewername'" | Select-Object -ExpandProperty Status
$viewerstate = Get-CimInstance -Class Win32_Service -Filter "Name LIKE '$viewername'" | Select-Object -ExpandProperty State
Write-Output "***** VIX Viewer Service *****"
Write-Output "Viewer PID:  $viewerpid"
Write-Output $viewerstatus
Write-Output $viewerstate

#check state
#if "Running", proceed to shutdown.  if not log and alert.
if ($viewerstate -eq 'Running') {
	Write-Output "Viewer service is running.  Stopping service..."
	Stop-Service -Name "$viewername" -Force
	#verifying service stopped
	Start-Sleep -s 10
	$viewerstate2 = Get-CimInstance -Class Win32_Service -Filter "Name LIKE '$viewername'" | Select-Object -ExpandProperty State
	Write-Output "$viewername is $viewerstate2"
	if ($viewerstate2 -eq 'Stopped') {
		Write-Output "Viewer service successfully stopped.  Checking for orphaned processes..."
		$viewerprocs = (Get-Process | Where-Object {$_.Name -eq 'Hydra.VistA.Worker'}).count
		Write-Output "Viewer process count: $viewerprocs"
		if ($viewerprocs -gt 0) {
			Write-Output "There are existing orphaned processes."
			Write-Output "Killing orphans...so sad."
			Stop-Process -Name "Hydra.VistA.Worker" -Force
		}

		Start-Sleep -s 5
		Write-Output "Restarting service..."
		Start-Service -Name "$viewername"
		#verifying service started
		Start-Sleep -s 10
		$viewerstate3 = Get-CimInstance -Class Win32_Service -Filter "Name LIKE '$viewername'" | Select-Object -ExpandProperty State
		Write-Output "$viewername is $viewerstate3"
		if ($viewerstate3 -eq 'Running') {
		Write-Output "Viewer service successfully restarted."
		}
	}
} else {
	Write-Output "$viewername is not running.  That's not good."
	Write-Output "Looking for orphan processes..."
	$viewerprocs = (Get-Process | Where-Object {$_.Name -eq 'Hydra.VistA.Worker'}).count
	Write-Output "Viewer process count: $viewerprocs"
	if ($viewerprocs -gt 0) {
		Write-Output "There are existing orphaned processes."
		Write-Output "Killing orphans...so sad."
		Stop-Process -Name "Hydra.VistA.Worker" -Force
	}

	Write-Output "Attempting to start $viewername service.  Starting service..."
	Start-Service -Name "$viewername"
	#verifying service started
	Start-Sleep -s 10
	$viewerstate3 = Get-CimInstance -Class Win32_Service -Filter "Name LIKE '$viewername'" | Select-Object -ExpandProperty State
	Write-Output "$viewername is $viewerstate3"
	if ($viewerstate3 -eq 'Running') {
		Write-Output "Viewer service successfully restarted."
	}
}
#Post-restart statuses
$prs_viewerpid = Get-CimInstance -Class Win32_Service -Filter "Name LIKE '$viewername'" | Select-Object -ExpandProperty ProcessId
$prs_viewerstatus = Get-CimInstance -Class Win32_Service -Filter "Name LIKE '$viewername'" | Select-Object -ExpandProperty Status
$prs_viewerstate = Get-CimInstance -Class Win32_Service -Filter "Name LIKE '$viewername'" | Select-Object -ExpandProperty State
Write-Output "-NEW- Viewer PID:  $prs_viewerpid"
Write-Output $prs_viewerstatus
Write-Output $prs_viewerstate
Write-Output "**********"


#Shut down and restart VIX Render Service
#Pre-shutdown statuses
$renderpid = Get-CimInstance -Class Win32_Service -Filter "Name LIKE '$rendername'" | Select-Object -ExpandProperty ProcessId
$renderstatus = Get-CimInstance -Class Win32_Service -Filter "Name LIKE '$rendername'" | Select-Object -ExpandProperty Status
$renderstate = Get-CimInstance -Class Win32_Service -Filter "Name LIKE '$rendername'" | Select-Object -ExpandProperty State
Write-Output "***** VIX Render Service *****"
Write-Output "Render PID:  $renderpid"
Write-Output $renderstatus
Write-Output $renderstate

#check state
#if "Running", proceed to shutdown.  if not log and alert.
if ($renderstate -eq 'Running') {
	Write-Output "Render service is running.  Stopping service..."
	Stop-Service -Name "$rendername" -Force
	#verifying service stopped
	Start-Sleep -s 10
	$renderstate2 = Get-CimInstance -Class Win32_Service -Filter "Name LIKE '$rendername'" | Select-Object -ExpandProperty State
	Write-Output "$rendername is $renderstate2"

	if ($renderstate2 -eq 'Stopped') {
		Write-Output "Render service successfully stopped.  Checking for orphaned processes..."
		$renderprocs = (Get-Process | Where-Object {$_.Name -eq 'Hydra.IX.Processor'}).count
		Write-Output "Render process count: $renderprocs"
		if ($renderprocs -gt 0) {
			Write-Output "There are existing orphaned processes."
			Write-Output "Killing orphans...so sad."
			Stop-Process -Name "Hydra.IX.Processor" -Force
		}

		Start-Sleep -s 5
		Write-Output "Restarting service..."
		Start-Service -Name "$rendername"
		#verifying service started
		Start-Sleep -s 10
		$renderstate3 = Get-CimInstance -Class Win32_Service -Filter "Name LIKE '$rendername'" | Select-Object -ExpandProperty State
		Write-Output "$rendername is $renderstate3"
		if ($renderstate3 -eq 'Running') {
		Write-Output "Render service successfully restarted."
		}
	}
} else {
	Write-Output "$rendername is not running.  That's not good."
	Write-Output "Looking for orphan processes..."
	$renderprocs = (Get-Process | Where-Object {$_.Name -eq 'Hydra.IX.Processor'}).count
	Write-Output "Render process count: $renderprocs"
	if ($renderprocs -gt 0) {
		Write-Output "There are existing orphaned processes."
		Write-Output "Killing orphans...so sad."
		Stop-Process -Name "Hydra.IX.Processor" -Force
	}

	Write-Output "Attempting to start $rendername service.  Starting service..."
	Start-Service -Name "$rendername"
	#verifying service started
	Start-Sleep -s 10
	$renderstate3 = Get-CimInstance -Class Win32_Service -Filter "Name LIKE '$rendername'" | Select-Object -ExpandProperty State
	Write-Output "$rendername is $renderstate3"
	if ($renderstate3 -eq 'Running') {
		Write-Output "Viewer service successfully restarted."
	}
}
#Post-restart statuses
$prs_renderpid = Get-CimInstance -Class Win32_Service -Filter "Name LIKE '$rendername'" | Select-Object -ExpandProperty ProcessId
$prs_renderstatus = Get-CimInstance -Class Win32_Service -Filter "Name LIKE '$rendername'" | Select-Object -ExpandProperty Status
$prs_renderstate = Get-CimInstance -Class Win32_Service -Filter "Name LIKE '$rendername'" | Select-Object -ExpandProperty State
Write-Output "-NEW- Render PID:  $prs_renderpid"
Write-Output $prs_renderstatus
Write-Output $prs_renderstate
Write-Output "**********"


#Shut down and restart Listener Tool Service
#Pre-shutdown statuses
#$listenerpid = Get-CimInstance -Class Win32_Service -Filter "Name LIKE '$listenername'" | Select-Object -ExpandProperty ProcessId
#$listenerstatus = Get-CimInstance -Class Win32_Service -Filter "Name LIKE '$listenername'" | Select-Object -ExpandProperty Status
#$listenerstate = Get-CimInstance -Class Win32_Service -Filter "Name LIKE '$listenername'" | Select-Object -ExpandProperty State
#Write-Output "***** ListenerTool Service *****"
#Write-Output "Listener PID:  $listenerpid"
#Write-Output $listenerstatus
#Write-Output $listenerstate

#check state
#if "Running", proceed to shutdown.  if not log and alert.
#if ($listenerstate -eq 'Running') {
#	Write-Output "Listener service is running.  Stopping service..."
#	Stop-Service -Name "$listenername" -Force
	#verifying service stopped
#	Start-Sleep -s 10
#	$listenerstate2 = Get-CimInstance -Class Win32_Service -Filter "Name LIKE '$listenername'" | Select-Object -ExpandProperty State
#	Write-Output "$listenername is $listenerstate2"
#	if ($listenerstate2 -eq 'Stopped') {
#		Write-Output "Listener service successfully stopped.  Restarting service..."
#		Start-Service -Name "$listenername"
		#verifying service started
#		Start-Sleep -s 10
#		$listenerstate3 = Get-CimInstance -Class Win32_Service -Filter "Name LIKE '$listenername'" | Select-Object -ExpandProperty State
#		Write-Output "$listenername is $listenerstate3"
#		if ($listenerstate3 -eq 'Running') {
#		Write-Output "Listener service successfully restarted."
#		}
#	}
#} else {
#	Write-Output "$listenername is not running.  That's not good."
#	Write-Output "Attempting to start $listenername service.  Starting service..."
#	Start-Service -Name "$listenername"
	#verifying service started
#	Start-Sleep -s 10
#	$listenerstate3 = Get-CimInstance -Class Win32_Service -Filter "Name LIKE '$listenername'" | Select-Object -ExpandProperty State
#	Write-Output "$listenername is $listenerstate3"
#	if ($listenerstate3 -eq 'Running') {
#		Write-Output "Listener service successfully restarted."

#	}
#}

#Post-restart statuses
#$prs_listenerpid = Get-CimInstance -Class Win32_Service -Filter "Name LIKE '$listenername'" | Select-Object -ExpandProperty ProcessId
#$prs_listenerstatus = Get-CimInstance -Class Win32_Service -Filter "Name LIKE '$listenername'" | Select-Object -ExpandProperty Status
#$prs_listenerstate = Get-CimInstance -Class Win32_Service -Filter "Name LIKE '$listenername'" | Select-Object -ExpandProperty State
#Write-Output "-NEW- Listener PID:  $prs_listenerpid"
#Write-Output $prs_listenerstatus
#Write-Output $prs_listenerstate
#Write-Output "**********"

#Stop-Transcript

Write-Output "***** DONE *****"