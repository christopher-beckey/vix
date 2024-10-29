// Stdout.h: interface for the Stdout class.
//
//////////////////////////////////////////////////////////////////////

#if !defined(AFX_STDOUT_H__99AB53A7_6A4C_4E1C_82B8_5F6852C40CD7__INCLUDED_)
#define AFX_STDOUT_H__99AB53A7_6A4C_4E1C_82B8_5F6852C40CD7__INCLUDED_


#if _MSC_VER > 1000
#pragma once
#endif // _MSC_VER > 1000


class Stdout  
{
public:
	void PrintException (char *);
	void PrintUsage ();
	Stdout();
	virtual ~Stdout();

};

#endif // !defined(AFX_STDOUT_H__99AB53A7_6A4C_4E1C_82B8_5F6852C40CD7__INCLUDED_)
