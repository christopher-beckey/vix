/****************************************************************************
          Copyright (C) 1995, University of California, Davis

          THIS SOFTWARE IS MADE AVAILABLE, AS IS, AND THE UNIVERSITY
          OF CALIFORNIA DOES NOT MAKE ANY WARRANTY ABOUT THE SOFTWARE, ITS
          PERFORMANCE, ITS MERCHANTABILITY OR FITNESS FOR ANY PARTICULAR
          USE, FREEDOM FROM ANY COMPUTER DISEASES OR ITS CONFORMITY TO ANY
          SPECIFICATION. THE ENTIRE RISK AS TO QUALITY AND PERFORMANCE OF
          THE SOFTWARE IS WITH THE USER.

          Copyright of the software and supporting documentation is
          owned by the University of California, and free access
          is hereby granted as a license to use this software, copy this
          software and prepare derivative works based upon this software.
          However, any distribution of this software source code or
          supporting documentation or derivative works (source code and
          supporting documentation) must include this copyright notice.
****************************************************************************/

/***************************************************************************
 *
 * University of California, Davis
 * UCDMC DICOM Network Transport Libraries
 * Version 0.1 Beta
 *
 * Technical Contact: mhoskin@ucdavis.edu
 *
 ***************************************************************************/

#	include	"dicom.hpp"


BOOL	StandardQuery	::	Read (
	PDU_Service			*PDU,
	DICOMCommandObject	*DCO)
	{
	UID	MyUID, uid;
	VR	*vr;
	DICOMDataObject	DDO;
	Array < DICOMDataObject *>	ADDO;
	UINT		Index;

	GetUID(MyUID);

	if( ! PDU )
		return ( FALSE );

	if( ! DCO )
		return ( FALSE );

	vr = DCO->GetVR(0x0000, 0x0002);
	SetUID(uid, vr);
	if (!(MyUID == uid))
		return ( FALSE );

	if (! CFindRQ :: Read (DCO, PDU, &DDO) )
		return ( FALSE ); // my SOP, but wrong command

	if (! SearchOn (&DDO, &ADDO) )
		{
		CFindRSP :: Write (PDU, DCO, 0xc001, NULL);
	//	delete DCO;
		return ( TRUE );
		}
	Index = 0;
	while ( Index < ADDO.GetSize() )
		{
		CFindRSP :: Write (PDU, DCO, ADDO.Get ( Index ) );
		delete ADDO.Get ( Index );
		++Index;
		}
	CFindRSP :: Write ( PDU, DCO, NULL );
//	delete DCO;
	
	return ( TRUE );
	}

BOOL	StandardQuery	::	Write (
	PDU_Service		*PDU,
	DICOMDataObject	*DDO)
	{
	DICOMCommandObject	*DCO;
	DICOMDataObject		*RDDO;

	if ( ! PDU )
		return ( FALSE );

	if ( ! CFindRQ :: Write ( PDU, DDO ) )
		return ( FALSE );

	CallBack ( NULL, DDO );

	DCO = new DICOMCommandObject;

	while ( PDU->Read ( DCO ) )
		{
		RDDO = new DICOMDataObject;

		if (! (CFindRSP :: Read ( DCO, PDU, RDDO) ) )
			{
			return ( FALSE );
			}
		if ( DCO->GetUINT16(0x0000, 0x0800) == 0x0101)
			{
			CallBack ( DCO, NULL );
			delete RDDO;
			delete DCO;
			return ( TRUE );
			}
		CallBack ( DCO, RDDO );
		delete RDDO;
		delete DCO;
		DCO = new DICOMCommandObject;
		}

	delete DCO;
	return ( FALSE );
	}

BOOL	StandardRetrieve	::	Read (
	PDU_Service			*PDU,
	DICOMCommandObject	*DCO)
	{
	UID	MyUID, uid, iUID, AppUID ("1.2.840.10008.3.1.1.1");
	VR	*vr;
	DICOMDataObject	DDO;
	Array < DICOMDataObject *>	ADDO;
	UINT		Index;
	BYTE		IP [ 64 ], Port [ 64 ], ACRNema [ 17 ], MyACR[17];
	StandardStorage	*SS;
	DICOMDataObject	*iDDO;
	PDU_Service	NewPDU;
	UINT16		Failed;

	GetUID(MyUID);

	if( ! PDU )
		return ( FALSE );

	if( ! DCO )
		return ( FALSE );

	vr = DCO->GetVR(0x0000, 0x0002);
	SetUID(uid, vr);
	if (!(MyUID == uid))
		return ( FALSE );

	if (! CMoveRQ :: Read (DCO, PDU, &DDO) )
		return ( FALSE ); // my SOP, but wrong command


	vr = DCO->GetVR(0x0000, 0x0600);
	if(!vr)
		{
		CMoveRSP :: Write ( PDU, DCO, 0xc001 , 0, 0, 0, 0, NULL );
//		delete DCO;
		return ( TRUE );
		}

	memset((void*)ACRNema, 0, 17);
	if(vr->Length > 16)
		vr->Length = 16;
	memcpy((void*)ACRNema, vr->Data, (int) vr->Length);
	if(!vr->Length)
		{
		CMoveRSP :: Write ( PDU, DCO, 0xc002 , 0, 0, 0, 0, NULL );
//		delete DCO;
		return ( TRUE );
		}
	if(ACRNema[vr->Length-1]==' ')
		ACRNema[vr->Length-1] = '\0';

	if(!QualifyOn(ACRNema, MyACR, IP, Port))
		{
		CMoveRSP :: Write ( PDU, DCO, 0xc003 , 0, 0, 0, 0, NULL );
//		delete DCO;
		return ( TRUE );
		}


	if (! SearchOn (&DDO, &ADDO) )
		{
		CMoveRSP :: Write ( PDU, DCO, 0xc004 , 0, 0, 0, 0, NULL );
//		delete DCO;
		return ( TRUE );
		}

	NewPDU.SetApplicationContext ( AppUID );
	NewPDU.SetLocalAddress ( MyACR );
	NewPDU.SetRemoteAddress ( ACRNema );
	
	// Add all the Abstract Syntaxs we need

	Index = 0;
	while ( Index < ADDO.GetSize() )
		{
		vr = ADDO.Get ( Index ) -> GetVR(0x0008, 0x0016);
		if(!vr)
			{
			delete ADDO.Get ( Index );
			ADDO.RemoveAt ( Index );
			}
		else
			{
			SetUID ( iUID, vr );
			NewPDU.AddAbstractSyntax ( iUID );
			++Index;
			}
		}

	if (!NewPDU.Connect (IP, Port))
		{
		CMoveRSP :: Write ( PDU, DCO, 0xc005 , 0, 0, 0, 0, NULL );
//		delete DCO;
		return ( TRUE );
		}


	Index = 0;
	Failed = 0;
	while ( Index < ADDO.GetSize() )
		{
		vr = ADDO.Get ( Index ) -> GetVR(0x0008, 0x0016);
		SetUID ( iUID, vr );
		if ( !NewPDU.GetPresentationContextID(iUID) )
			{
			++Failed;
			// Remote end did not accept this UID
			}
		else
			{
			if ( !RetrieveOn (ADDO.Get(Index), &iDDO, &SS))
				++Failed;
			else
				{
				if(!SS->Write(&NewPDU, iDDO))
					{
					//++Failed;
					// Remote end should accept this image.  if it did
					// not, then just bail out.  Probably means the
					// TCP/IP link has been dropped.
					Failed += (ADDO.GetSize() - Index);
					break;
					}
				delete iDDO;
				}
			}
		CMoveRSP :: Write ( PDU,
							DCO,
							0xff00, ADDO.GetSize() - Index - 1,
							(UINT16) Index, Failed, 0,
							ADDO.Get ( Index ));
		delete ADDO.Get ( Index );
		++Index;
		}
	CMoveRSP :: Write ( PDU, DCO, 0, 0, (UINT16) Index, Failed, 0, NULL );
	// Incase we broke out from above..
	while ( Index < ADDO.GetSize () )
		{
		delete ADDO.Get(Index);
		++Index;
		}
//	delete DCO;
	
	return ( TRUE );
	}

//BOOL	DumpVR (VR	*);

BOOL	StandardRetrieve	::	Write (
	PDU_Service		*PDU,
	DICOMDataObject	*DDO,
	BYTE			*ACRNema )
	{
	DICOMCommandObject	*DCO;
	DICOMDataObject		*RDDO;

	if ( ! PDU )
		return ( FALSE );

	if ( ! CMoveRQ :: Write ( PDU, DDO, ACRNema ) )
		return ( FALSE );

	CallBack ( NULL, DDO );

	DCO = new DICOMCommandObject;

	while ( PDU->Read ( DCO ) )
		{
		RDDO = new DICOMDataObject;

		if (! (CMoveRSP :: Read ( DCO, PDU, RDDO) ) )
			{
			return ( FALSE );
			}
		if ( DCO->GetUINT16(0x0000, 0x0800) == 0x0101)
			{
			CallBack ( DCO, NULL );
			delete RDDO;
			if ( DCO->GetUINT16(0x0000, 0x0900) != 0x0000)
				{
				VR *vr;
				while (vr = DCO->Pop())
					{
					//DumpVR(vr);
					delete vr;
					}
				delete DCO;
				return ( FALSE );
				}
			delete DCO;
			return ( TRUE );
			}
		CallBack ( DCO, RDDO );
		delete RDDO;
		delete DCO;
		DCO = new DICOMCommandObject;
		}

	delete DCO;
	return ( FALSE );
	}

BOOL	PatientRootQuery	::	GetUID ( UID &uid )
	{
	uid.Set ( "1.2.840.10008.5.1.4.1.2.1.1" );
	return ( TRUE );
	}

BOOL	PatientRootRetrieve	::	GetUID ( UID &uid )
	{
	uid.Set ( "1.2.840.10008.5.1.4.1.2.1.2" );
	return ( TRUE );
	}

BOOL	StudyRootQuery	::	GetUID ( UID &uid )
	{
	uid.Set ( "1.2.840.10008.5.1.4.1.2.2.1" );
	return ( TRUE );
	}

BOOL	StudyRootRetrieve	::	GetUID ( UID &uid )
	{
	uid.Set ( "1.2.840.10008.5.1.4.1.2.2.2" );
	return ( TRUE );
	}

BOOL	PatientStudyOnlyQuery	::	GetUID ( UID &uid )
	{
	uid.Set ( "1.2.840.10008.5.1.4.1.2.3.1" );
	return ( TRUE );
	}

BOOL	PatientStudyOnlyRetrieve	::	GetUID ( UID &uid )
	{
	uid.Set ( "1.2.840.10008.5.1.4.1.2.3.2" );
	return ( TRUE );
	}

