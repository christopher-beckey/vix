// PDUServ.h: interface for the PDUServ class.
//
//////////////////////////////////////////////////////////////////////

#if !defined(AFX_PDUSERV_H__98C4A27E_01FB_49AC_B0E6_CEA9B3A710CD__INCLUDED_)
#define AFX_PDUSERV_H__98C4A27E_01FB_49AC_B0E6_CEA9B3A710CD__INCLUDED_

#if _MSC_VER > 1000
#pragma once
#endif // _MSC_VER > 1000

#define  EXPLICIT_LITTLE_ENDIAN_XFER_UID	"1.2.840.10008.1.2.1"
#define  IMPLICIT_LITTLE_ENDIAN_XFER_UID    "1.2.840.10008.1.2"

class PDUServ : public PDU_Service  
{
public:
	DICOMDataObject * LoadDICOMDataObject (char *, UINT *);
	BOOL SaveDICOMDataObject (char *, UINT, DICOMDataObject *);
	PDUServ();
	virtual ~PDUServ();

};

#endif // !defined(AFX_PDUSERV_H__98C4A27E_01FB_49AC_B0E6_CEA9B3A710CD__INCLUDED_)
