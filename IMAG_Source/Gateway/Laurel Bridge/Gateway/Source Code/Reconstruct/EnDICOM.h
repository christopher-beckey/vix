// EnDICOM.h: interface for the EnDICOM class.
//
//////////////////////////////////////////////////////////////////////

#if !defined(AFX_DICOMOBJECT_H__7B93B9CB_7ECD_4FCB_9846_AB228FE8B1F8__INCLUDED_)
#define AFX_DICOMOBJECT_H__7B93B9CB_7ECD_4FCB_9846_AB228FE8B1F8__INCLUDED_


#if _MSC_VER > 1000
#pragma once
#endif // _MSC_VER > 1000

class EnDICOM  
{
public:
	int PrintElement();
	signed int InsertDCMTag (USHORT *, USHORT *, char *, int *, char *);
	signed int RemoveDCMTag (USHORT *, USHORT *);
	signed int ChangeDCMTag (USHORT *, USHORT *, char *, int *, char *);
	signed int ConvertFFEncoding ();
	signed int SaveDCMFile (char *);
	signed int LoadDCMFile (char *);
	EnDICOM();
	virtual ~EnDICOM();

private:
	char * m_cpFilename;
	int m_iFFEncodeScheme;
	DICOMDataObject *m_obEnDDO;
	bool PackVR(unsigned char,unsigned char,unsigned short &);


};

#endif // !defined(AFX_DICOMOBJECT_H__7B93B9CB_7ECD_4FCB_9846_AB228FE8B1F8__INCLUDED_)

