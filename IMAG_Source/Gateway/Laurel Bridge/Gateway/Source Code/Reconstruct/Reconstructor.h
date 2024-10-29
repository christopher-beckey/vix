// Reconstructor.h: interface for the Reconstructor class.
//
//////////////////////////////////////////////////////////////////////

#if !defined(AFX_RECONSTRUCTOR_H__0E3765BF_0B01_45E1_ADF7_BA47C6E4A7F0__INCLUDED_)
#define AFX_RECONSTRUCTOR_H__0E3765BF_0B01_45E1_ADF7_BA47C6E4A7F0__INCLUDED_


#if _MSC_VER > 1000
#pragma once
#endif // _MSC_VER > 1000

class Reconstructor  
{
public:
	signed int SaveDCMObject (char *);
	signed int LoadDCMObject (char *);
	signed int ReadChgFile (char *);
	void SetChangeFilename(char *);
	void SetDCMFilenames(char *, char *);
	signed int mSetVRConvert ();
	signed int ChangeTags (char *);
	Reconstructor();
	virtual ~Reconstructor();

private:
	Stdout m_obErrOut;
	Exception m_obError;
	EnDICOM m_obDICOMMessage;
	CObList m_colTagLines;
	TagLine * m_obTagLine;
	char * m_cpChangeFilename;
	char * m_cpOutputFilename;
	char * m_cpInputFilename;
};

#endif // !defined(AFX_RECONSTRUCTOR_H__0E3765BF_0B01_45E1_ADF7_BA47C6E4A7F0__INCLUDED_)

