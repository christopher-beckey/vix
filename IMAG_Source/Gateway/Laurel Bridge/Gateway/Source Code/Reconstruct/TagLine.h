// TagLine.h: interface for the TagLine class.
//
//////////////////////////////////////////////////////////////////////

#if !defined(AFX_TAGLINE_H__5E95A7DD_3810_4B88_A939_799AA89A288E__INCLUDED_)
#define AFX_TAGLINE_H__5E95A7DD_3810_4B88_A939_799AA89A288E__INCLUDED_


#if _MSC_VER > 1000
#pragma once
#endif // _MSC_VER > 1000


class TagLine : public LineEntry  
{
public:
	TagLine& operator= (const TagLine &);
	void GetTagLine (int *, USHORT *, USHORT *, char *, int *, char *);
	int GetAction ();
	void SetTagLine (int, USHORT, USHORT, char *, int, char *);
	TagLine();
	virtual ~TagLine();

private:
	char * m_cDCMVR;
	int m_iDCMVM;
	int m_iAction;
};

#endif // !defined(AFX_TAGLINE_H__5E95A7DD_3810_4B88_A939_799AA89A288E__INCLUDED_)

