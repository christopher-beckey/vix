//#include <windows.h>
#include "stdafx.h"
#include "DirectoryChanges.h"
#include "DelayedDirectoryChangeHandler.h"
#include <sys/stat.h>
#include <string>
#include <fstream>

#include "error.h"
#include "decompressor.h"
#include "dwdecomp.h"

using namespace std;

#define NOTASERVICE false
#define RWATCH		true	// toggle Rename or Modify Dir Watch Method; Note: Modify needs more delay!!! 
#define NUM5SECSWAIT	36	// adds up to 3 minutes before checking logfies for size and purge 
#define MAXLOGSCHECKED	32	// maximum number of saved log files to search for
#define NLOGSKEPT		10	// number of saved log files tp keep (must be smaller than MAXLOGSCHECKED !!!)
#define ONE_MB	   1046576	// 1024 * 1024

void logMessage(string Msg);
void manageLogFiles();

CString logFName;
static int	mSecs = 50;			// default is 50 msec for rename, more for Modify
static int	mBs = 1;			// default is 1 MBytes per log file
static int	logCheckCounter = 0;// counts the loops of 5 seconds to wait before checking log file for size
CRITICAL_SECTION CSMutex;

// ------------------------------------------------------------------------------
// The main program in non-service mode: invokes CDirectoryCgangeWatcher in an infinite loop
/*
int main(int argc, char ** argv)
{
	CDWDecompression DWDecomp;
	bool Stop=false;

	int retries=0;
	while (Stop){ 
		if ((int)DWDecomp.StartWatchDirAndDecomp(void) != SUCCESS ) {
		{
			Sleep(2000);
			retries+=1;
			if (retries > 4) break;
		}
		else { // success, keep monitoring if watch is active, loop back if not
			retries=0;
			do {
				if (Stop) {
					DWDecomp.StopWatchDirAndDecomp();
					break;
				}
				Sleep(5000);
			} while (DWDecomp.IsDirWatched());
		}

	}

	return 0;
}
*/
// ----------------------------------------------------------------------------------
// the actual J2K decompression related activity, see Decompressor.cpp
//
int do_decompress (string filespec)
{
	Params params;
	int result=-1;

	// expected input file spec: [<path>]<.ext.j2k> or [<path>]<.j2k>
	params.inFilename = filespec;

	decompressor de(&params);

	result = de.decompress();
	return result;
}

//---------------------------------------------------------------------------------
// DirWatch (callback) handler class: limits notification to file modified only and
// activated do_decompress on On-FileModified event
//
class CDeCompDirectoryChangeHandler : public CDirectoryChangeHandler
{
public:
	CDeCompDirectoryChangeHandler(){} 
	virtual ~CDeCompDirectoryChangeHandler(){}

protected:
	char logMsg[500];

    void On_FileNameChanged(const CString & strOldFileName, const CString & strNewFileName)
    {
		if (RWATCH) {
			CString ext="";
			if (4 <= strNewFileName.GetLength()) {
				ext=strNewFileName.Right(4);
			}
			if (ext.CompareNoCase(".j2k")==0) {
				if (NOTASERVICE) printf("%s ...", strNewFileName);
				
				Sleep(mSecs); // make sure file is left alone
				int result = do_decompress ((LPCTSTR) strNewFileName);
				
				if (NOTASERVICE) printf(" Status -> %s (%d)\n", getStatusText(result), result);
				sprintf(logMsg, "%s Status -> %s (%d)", strNewFileName, getStatusText(result), result);
				logMessage(logMsg);
			}
		}
    }

	void On_FileModified(const CString & strFileName)
    {
		if (!RWATCH) {
			if (NOTASERVICE) printf("%s ...", strFileName);
			
			Sleep(mSecs); // make sure file is left alone
			int result = do_decompress ((LPCTSTR) strFileName);
			
			if (NOTASERVICE) printf(" DeComp. Status -> %s (%d)\n", getStatusText(result), result);
			sprintf(logMsg, "%s DeComp. Status -> %s (%d)", strFileName, getStatusText(result), result);
			logMessage(logMsg);
		}
    }

    bool On_FilterNotification(DWORD dwNotifyAction, LPCTSTR szFileName, LPCTSTR szNewFileName)
    { 
		// This programmer defined filter will only cause notifications
		// that a file modification change to be sent only.
        //
		if( RWATCH ) {
			if ( dwNotifyAction == FILE_ACTION_RENAMED_OLD_NAME )	// for rename 
				return true;
		} else {
			if( dwNotifyAction == FILE_ACTION_MODIFIED )			// for modify 
				return true;
		}
		return false;
	}
};

CDeCompDirectoryChangeHandler DirChangeHandler; // !! instantiate handler here !!!

// ------------------------------------------------------------------------------------
CDWDecompression::CDWDecompression() : m_DirWatcher (false, /* no GUI */
													 CDirectoryChangeWatcher::FILTERS_TEST_HANDLER_FIRST /*16*/ |
													 CDirectoryChangeWatcher::FILTERS_DEFAULT_BEHAVIOR /*(FILTERS_CHECK_FILE_NAME_ONLY) 8 */)
{
	char * mS;
	char * lF;
	char * wD;
	char * mB;

	m_status = SUCCESS;

	InitializeCriticalSection(&CSMutex);

	lF = getenv("DECOMP_LOG_FSPEC");
	if (lF == NULL) {
		if (NOTASERVICE) printf("%s", "Environment variable 'DECOMP_LOG_FSPEC' not found -> No Logging!\n");
	} else {
		mB = getenv("DECOMP_LOG_FILE_MBYTES");
		if (mB == NULL) {
			sprintf(m_logMsg, "%s", "Environment variable 'DECOMP_LOG_FILE_MBYTES' not found -> 1 MByte used\n");
			if (NOTASERVICE) printf("%s\n", m_logMsg);
			logMessage(m_logMsg);
		} else
			mBs = atoi(mB);
		if (mBs <1) mBs = 1;

	}

	logFName = lF;
	logMessage("-----------------------------------------------------------------------------------------------------------------");

	wD = getenv("DECOMP_WATCH_DIR");
	if (wD == NULL) {
		sprintf(m_logMsg, "Environment variable 'DECOMP_WATCH_DIR' not found! Session Terminated.");
		if (NOTASERVICE) printf("%s\n", m_logMsg);
		logMessage(m_logMsg);
		m_status = -1;
		return;
	}
	m_watchDir = wD;
	if (m_watchDir[m_watchDir.GetLength()-1] != '\\')
		m_watchDir += '\\';

	mS = getenv("DECOMP_DELAY_MS");
	if (mS == NULL) {
		sprintf(m_logMsg, "%s", "Environment variable 'DECOMP_DELAY_MS' not found -> 50 msec used\n");
		if (NOTASERVICE) printf("%s\n", m_logMsg);
		logMessage(m_logMsg);
	} else
		mSecs = atoi(mS);

	sprintf(m_logMsg, "S T A R T E D  Directory-Watch/Decompression Service over %s", m_watchDir);
	if (NOTASERVICE) printf("%s\n", m_logMsg);
	logMessage(m_logMsg);

}

// ---------------------------------------------------------------------------------
// Support function to retrieve WatchDirectory error code 
//
CString GetLastErrorMessageString(DWORD dwLastError )
{
	LPVOID lpMsgBuf = NULL;
	FormatMessage( FORMAT_MESSAGE_ALLOCATE_BUFFER | FORMAT_MESSAGE_FROM_SYSTEM, NULL,
				  dwLastError, 
				  MAKELANGID(LANG_NEUTRAL, SUBLANG_DEFAULT), // Default language
							   (LPTSTR) &lpMsgBuf, 0, NULL );

	CString str = (LPCTSTR)lpMsgBuf;

	if( lpMsgBuf != NULL )
		LocalFree(lpMsgBuf);

	return str;
}

// ----------------------------------------------------------------------------------
// the Directory Watch mechanism applying DeCompression on each .j2k file found

int CDWDecompression::StartWatchDirAndDecomp(void)
{
	// see no GUI setting under constructor definition above with FILTERS_TEST_HANDLER_FIRST | FILTERS_CHECK_FILE_NAME_ONLY

	// start up DirWatcher for the WATCH_DIR tree of env. var. 
	DWORD dwWatch = 0;
	if( ERROR_SUCCESS != (dwWatch = m_DirWatcher.WatchDirectory(
												m_watchDir,		 // the dir (tree) to watch
												RWATCH ? FILE_NOTIFY_CHANGE_FILE_NAME : // dwChangeFilter, -- for Rename
												         FILE_NOTIFY_CHANGE_SIZE,		// dwChangeFilter, -- for Modify
												&DirChangeHandler,
												true,    // bWatchSubDir,
												"*.j2k", // strIncludeFilter1,
												NULL)) ) // strExcludeFilter1
	{
		sprintf(m_logMsg, "FAILED to start watch over %s -> Error: %d", m_watchDir, GetLastErrorMessageString(dwWatch));
		if (NOTASERVICE)  printf("%s\n", m_logMsg);
		logMessage(m_logMsg);
	} // while
	m_status = (int)dwWatch;
	return m_status;
}

// ------------------------------------------------------------------------------
BOOL CDWDecompression::IsDirWatched(void) {
	BOOL flag;
	flag  = m_DirWatcher.IsWatchingDirectory(m_watchDir);
	// check log file size, if over limit manage log files
	manageLogFiles();
	return flag;
}
// ------------------------------------------------------------------------------
BOOL CDWDecompression::StopWatchDirAndDecomp(void) {
	BOOL flag;
	flag  = m_DirWatcher.UnwatchAllDirectories();

	sprintf(m_logMsg, "S T O P P E D  Directory-Watch/Decompression Service over %s (status=%s)", m_watchDir, flag?"ok":"nok");
	if (NOTASERVICE) printf("%s\n", m_logMsg);
	logMessage(m_logMsg);
	return flag;

}
// ------------------------------------------------------------------------------
void logMessage(string Msg)
{
	if (!logFName.IsEmpty()) {
		CTime t = CTime::GetCurrentTime();
		string datime = (LPCTSTR) t.Format("%Y-%m-%d %H:%M:%S ");
		EnterCriticalSection(&CSMutex);
		ofstream out((LPCTSTR)logFName, ios::app);
		out << datime << Msg << endl;
		out.close();
		LeaveCriticalSection(&CSMutex);
	}
}
// ------------------------------------------------------------------------------
int compare(const void *arg1, const void *arg2)
// Support function for manageLogFiles (lower case compare) 
// returns <0 if arg1 less than arg2, 0 on equal, >0 if arg1 is greater than arg2
{
	return _stricmp((char *) arg1, (char *) arg2);
}
// ------------------------------------------------------------------------------
void manageLogFiles()
// First: it checks if log file is too long and in that case renames it using date/time stamp appended to filename before '.' 
// Second: it checks if the renamed files are greater than NLOGSKEPT, if yes removes the oldest ones above NLOGSKEPT
// This procedure is called every 5 seconds, so it checks every NUM5SECSWAIT * 5 seconds
{
	logCheckCounter++;
	if ((!logFName.IsEmpty()) && (logCheckCounter >= NUM5SECSWAIT)) {
		struct _stat buf;
		int result, fnix;
		string logext, ext, datime, currentDir, tmp, coreFSpec, coreFName, crimpedFSpec, saveFSpec, saveFName;
		CString searchFSpec;
		WIN32_FIND_DATA lpFindData;
		char strings[MAXLOGSCHECKED][MAX_PATH]; // max 256 chars

		CTime t = CTime::GetCurrentTime();
		// decompose log file name
		logext = crimpFilename((LPCTSTR)logFName, crimpedFSpec, '.');
		if (logext != "") {
			ext = crimpFilename(crimpedFSpec, coreFSpec, '.');
		} else {
			coreFSpec = crimpedFSpec;
			logext = "log";
		}
		tmp = coreFSpec + ".*." + logext;
		searchFSpec=&tmp[0];

		EnterCriticalSection(&CSMutex); // ***************
		// ===============================================
		// Check if log file got too big; if so, rename it
		// ===============================================
		// Get size of current logfile
		result = _stat((LPCTSTR)logFName, &buf );
		// check first if log file exists !!! (maybe it was renamed recently and were no activities !!!

		if(( result == 0 ) && (buf.st_size > (mBs * ONE_MB))){
			// add date time to core file name + logext
			datime = (LPCTSTR) t.Format(".%Y%m%d_%H%M%S.");
			saveFSpec = coreFSpec + datime + logext;

			// do rename
			result = rename((LPCTSTR)logFName, saveFSpec.c_str());
		}

		// =====================================================================================
		// now check if there are more than NLOGSKEPT saved log files and delete the oldest ones
		// =====================================================================================
		fnix = 0;
		HANDLE fhandle = FindFirstFile((LPCTSTR) searchFSpec,  // pointer to name of file to search for
										&lpFindData // pointer to returned information
										);
		if (fhandle != INVALID_HANDLE_VALUE) {
			strncpy((char *)strings[fnix], (LPCTSTR)lpFindData.cFileName, MAX_PATH);
			fnix++;
			while (FindNextFile(fhandle, &lpFindData) && (fnix < MAXLOGSCHECKED)) {
				strncpy((char *)strings[fnix], (LPCTSTR)lpFindData.cFileName, MAX_PATH);
				fnix++;
			}
			FindClose(fhandle);
		}
		if (fnix > NLOGSKEPT) {
			// sort array and remove files older than first NLOGSKEPT
			qsort(strings, fnix, MAX_PATH, compare);

			tmp = crimpFilename(coreFSpec, currentDir, '\\');

			for (int i=0; i < (fnix-NLOGSKEPT); i++) {
				tmp = currentDir + "\\" + strings[i];
				if(remove(tmp.c_str())) { // remove old file
					result = errno;
					if (NOTASERVICE) printf("Error removing log file %s; errno=%d\n", tmp.c_str(), result);
				}
			}
		}
		LeaveCriticalSection(&CSMutex);	// ***************
		logCheckCounter=0;

	}
}
