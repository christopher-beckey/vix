// Exception.h: interface for the Exception class.
//
//////////////////////////////////////////////////////////////////////

#if !defined(AFX_EXCEPTION_H__5BDE7614_998A_4F60_9614_167939874CBE__INCLUDED_)
#define AFX_EXCEPTION_H__5BDE7614_998A_4F60_9614_167939874CBE__INCLUDED_

#define NUM_ERRS	25
#define MAX_DESCR_LEN	40

#if _MSC_VER > 1000
#pragma once
#endif // _MSC_VER > 1000

class Exception  
{
public:
	signed int GetExceptionCode ();
	void SetException(signed int);
	char * GetExceptionDescription (signed int);
	char * CreateErrString (signed int, char *, USHORT *, USHORT *);
	Exception();
	virtual ~Exception();
	signed int m_code [NUM_ERRS];
	char * m_description [NUM_ERRS];

private:
	signed int m_iExceptionCode;
};

#endif // !defined(AFX_EXCEPTION_H__5BDE7614_998A_4F60_9614_167939874CBE__INCLUDED_)
