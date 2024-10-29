// CDWDecomp.h : header file
//
#include "stdafx.h"
#include "DirectoryChanges.h"
#include "DelayedDirectoryChangeHandler.h"

#if !defined(AFX_CDWDECOMP_H__ECE3EDC7_6C61_4153_B25B_32A8904A37B1__INCLUDED_)
#define AFX_CDWDECOMP_H__ECE3EDC7_6C61_4153_B25B_32A8904A37B1__INCLUDED_

#if _MSC_VER > 1000
#pragma once
#endif // _MSC_VER > 1000

/////////////////////////////////////////////////////////////////////////////
// CDWDecompression wrapper class


class CDWDecompression
{
public:
	CDWDecompression();

	CDirectoryChangeWatcher m_DirWatcher;

	int		m_status;
	CString m_watchDir;
	char	m_logMsg[500];

	int StartWatchDirAndDecomp(void);
	BOOL IsDirWatched(void);
	BOOL StopWatchDirAndDecomp(void);

	
};

#endif // !defined(AFX_CDWDECOMP_H__ECE3EDC7_6C61_4153_B25B_32A8904A37B1__INCLUDED_)
