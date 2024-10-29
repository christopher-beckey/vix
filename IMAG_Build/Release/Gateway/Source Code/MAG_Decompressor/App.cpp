#include "stdafx.h"
#include "ntserv_msg.h"
#include "app.h"
#include "dwdecomp.h"
#include "error.h"

#ifdef _DEBUG
#define new DEBUG_NEW
#undef THIS_FILE
static char THIS_FILE[] = __FILE__;
#endif


//The one and only one application
CApp theApp;


BEGIN_MESSAGE_MAP(CApp, CWinApp)
//{{AFX_MSG_MAP(CApp)
//}}AFX_MSG_MAP
END_MESSAGE_MAP()

CApp::CApp()
{
}

BOOL CALLBACK EnumServices(DWORD /*dwData*/, ENUM_SERVICE_STATUS& Service)
{
	TRACE(_T("Service name is %s\n"), Service.lpServiceName);
	TRACE(_T("Friendly name is %s\n"), Service.lpDisplayName);
	
	return TRUE; //continue enumeration
}


BOOL CApp::InitInstance()
{
	//All that is required to get the service up and running
	//
	CNTServiceCommandLineInfo cmdInfo;
	CMyService Service;
	Service.ParseCommandLine(cmdInfo);
	Service.ProcessShellCommand(cmdInfo);

	return FALSE;
}



CMyService::CMyService() : CNTService(_T("DWDecomp"), _T("MAG J2K Decompressor Service"), SERVICE_ACCEPT_STOP/*| SERVICE_ACCEPT_PAUSE_CONTINUE*/, _T("MAG Directory Watch & J2K Decompressor Service")) 
{
	//Simple boolean which is set to request the service to stop
	m_bWantStop = FALSE;
	m_bPaused = FALSE;
}

void CMyService::ServiceMain(DWORD /*dwArgc*/, LPTSTR* /*lpszArgv*/)
{
	int retries;

	//register our control handler
	RegisterCtrlHandler();
	
	//Pretend that starting up takes some time
	ReportStatusToSCM(SERVICE_START_PENDING, NO_ERROR, 0, 1, 0);
	Sleep(500);

	// initialize service's application
	CDWDecompression DWDecomp;
	if ( DWDecomp.m_status != SUCCESS )
		goto stoplabel;

	ReportStatusToSCM(SERVICE_RUNNING, NO_ERROR, 0, 1, 0);
	
	//Report to the event log that the service has started successfully
	m_EventLogSource.Report(EVENTLOG_INFORMATION_TYPE, CNTS_MSG_SERVICE_STARTED, m_sDisplayName);
	
	if (m_bWantStop)
		goto stoplabel;

	// run the real application's loop checking for STOP event
	retries=0;
	while (!m_bWantStop) { 
		if (DWDecomp.StartWatchDirAndDecomp() != SUCCESS )
		{
			Sleep(5000);	// 5 seconds delay!
			retries+=1;
			if (retries > 4) break; // max 5 retries (25 seconds on total failure)
		}
		else { // success, keep monitoring if watch is active, loop back if not
			retries=0;
			do {
				if (m_bWantStop) {
					DWDecomp.StopWatchDirAndDecomp();
					goto stoplabel;
				}
				Sleep(5000); // 5 seconds delay!
			} while (DWDecomp.IsDirWatched());
		}

	} // while
/*
	goto stoplabel;

	// pause loop
	//The tight loop which constitutes the service
	BOOL bOldPause = m_bPaused;
	while (!m_bWantStop)
	{
		//SCM has requested a Pause / Continue
		if (m_bPaused != bOldPause)
		{
			if (m_bPaused)
			{
				ReportStatusToSCM(SERVICE_PAUSED, NO_ERROR, 0, 1, 0);
				//Report to the event log that the service has paused successfully
				m_EventLogSource.Report(EVENTLOG_INFORMATION_TYPE, CNTS_MSG_SERVICE_PAUSED, m_sDisplayName);
			}
			else
			{
				ReportStatusToSCM(SERVICE_RUNNING, NO_ERROR, 0, 1, 0);
				//Report to the event log that the service has stopped continued
				m_EventLogSource.Report(EVENTLOG_INFORMATION_TYPE, CNTS_MSG_SERVICE_CONTINUED, m_sDisplayName);
			}
		}
		
		bOldPause = m_bPaused;
	}
*/
stoplabel:
	//Pretend that closing down takes some time
	ReportStatusToSCM(SERVICE_STOP_PENDING, NO_ERROR, 0, 1, 0);
	Sleep(1000);
	ReportStatusToSCM(SERVICE_STOPPED, NO_ERROR, 0, 1, 0);
	
	//Report to the event log that the service has stopped successfully
	m_EventLogSource.Report(EVENTLOG_INFORMATION_TYPE, CNTS_MSG_SERVICE_STOPPED, m_sDisplayName);
}

void CMyService::OnStop()
{
	CSingleLock l(&m_CritSect, TRUE); //synchronise access to the variables
	
	//Change the current state to STOP_PENDING
	m_dwCurrentState = SERVICE_STOP_PENDING;  
	
	//Signal the other thread to end
	m_bWantStop = TRUE;
}

void CMyService::OnPause()
{
	CSingleLock l(&m_CritSect, TRUE); //synchronise access to the variables
	
	//Change the current state
	m_dwCurrentState = SERVICE_PAUSE_PENDING;  
	
	//Signal the other thread
	m_bPaused = TRUE;
}

void CMyService::OnContinue()
{
	CSingleLock l(&m_CritSect, TRUE); //synchronise access to the variables
	
	//Change the current state
	m_dwCurrentState = SERVICE_CONTINUE_PENDING;  
	
	//Signal the other thread
	m_bPaused = FALSE;
}

void CMyService::OnUserDefinedRequest(DWORD dwControl)
{
}

void CMyService::ShowHelp()
{
	AfxMessageBox(_T("VistA Imaging Directory Watch & J2K Decompression Service\nUsage: DWDecomp [-install | -uninstall | -help]\n"));
}