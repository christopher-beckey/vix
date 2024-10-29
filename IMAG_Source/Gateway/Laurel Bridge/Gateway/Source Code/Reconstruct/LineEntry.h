// LineEntry.h: interface for the LineEntry class.
//
//////////////////////////////////////////////////////////////////////

#if !defined(AFX_LINEENTRY_H__5BD434A1_DB6E_4A00_86A0_DD28F0F83866__INCLUDED_)
#define AFX_LINEENTRY_H__5BD434A1_DB6E_4A00_86A0_DD28F0F83866__INCLUDED_


#if _MSC_VER > 1000
#pragma once
#endif // _MSC_VER > 1000

class LineEntry	:	public CObject
{
public:
	virtual LineEntry& operator= (const LineEntry &);
	void GetTag(USHORT *,USHORT *, char *);
	void SetTag (USHORT, USHORT, char *);
	LineEntry();
	virtual ~LineEntry();

protected:
	char * m_cDCMValue;
	USHORT m_iDCMElement;
	USHORT m_iDCMGroup;

private:

};

#endif // !defined(AFX_LINEENTRY_H__5BD434A1_DB6E_4A00_86A0_DD28F0F83866__INCLUDED_)
