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


BOOL	StandardStorage :: Read (
	PDU_Service			*PDU,
	DICOMCommandObject	*DCO,
	DICOMDataObject		*DDO)
	{
	VR	*vr;
	UID	MyUID, uid;

	GetUID(MyUID);	// always try and use GetUID to obtain my own uid

	if ( ! PDU )
		return ( FALSE );

	if ( ! DCO )
		return ( FALSE );

	if ( ! DDO )
		return ( FALSE );

	vr = DCO->GetVR ( 0x0000, 0x0002 );
	if ( ! vr )
		return ( FALSE );

	if ( !SetUID(uid, vr) )
		return ( FALSE );

	if ( MyUID != uid )
		return ( FALSE );

	if ( CStoreRQ :: Read ( DCO, PDU, DDO ) )
		{
		return ( CStoreRSP :: Write ( PDU, DCO, CheckObject( DDO ) ) );
		}
	if ( CStoreRSP :: Read ( DCO ) )
		{
		// No worries..
		return ( TRUE );
		}
	return ( FALSE );	// corrupted message
	}

BOOL	StandardStorage :: Write (
	PDU_Service *PDU,
	DICOMDataObject *DDO )
	{
	DICOMCommandObject	DCO;

	if ( ! PDU )
		return ( FALSE );

	if ( ! CStoreRQ :: Write ( PDU, DDO ) )
		return ( FALSE );

//	delete	DDO;

	if(!PDU->Read ( & DCO ))
		return (FALSE);

	if ( ! CStoreRSP :: Read ( &DCO ) )
		return ( FALSE );
	return ( TRUE );
	}

// Special "Void" storage class.  Accepts any DICOM transmission C-Store
BOOL	UnknownStorage	::	GetUID ( UID	&uid )
	{
	return ( FALSE );
	}

BOOL	UnknownStorage :: Read (
	PDU_Service			*PDU,
	DICOMCommandObject	*DCO,
	DICOMDataObject		*DDO)
	{
	//VR	*vr;
	UID	MyUID, uid;


	if ( ! PDU )
		return ( FALSE );

	if ( ! DCO )
		return ( FALSE );

	if ( ! DDO )
		return ( FALSE );

	if ( CStoreRQ :: Read ( DCO, PDU, DDO ) )
		{
		return ( CStoreRSP :: Write ( PDU, DCO, CheckObject ( DDO ) ) );
		}
	if ( CStoreRSP :: Read ( DCO ) )
		{
		// No worries..
		return ( TRUE );
		}
	return ( FALSE );	// corrupted message
	}


BOOL	CRStorage	::	GetUID ( UID	&uid )
	{
	uid.Set("1.2.840.10008.5.1.4.1.1.1");
	return ( TRUE );
	}

BOOL	CTStorage	::	GetUID ( UID	&uid )
	{
	uid.Set("1.2.840.10008.5.1.4.1.1.2");
	return ( TRUE );
	}

BOOL	USMultiframeStorage	::	GetUID ( UID	&uid )
	{
	uid.Set("1.2.840.10008.5.1.4.1.1.3");
	return ( TRUE );
	}

BOOL	MRStorage	::	GetUID ( UID	&uid )
	{
	uid.Set("1.2.840.10008.5.1.4.1.1.4");
	return ( TRUE );
	}

BOOL	NMStorage	::	GetUID ( UID	&uid )
	{
	uid.Set("1.2.840.10008.5.1.4.1.1.5");
	return ( TRUE );
	}

BOOL	USStorage	::	GetUID ( UID	&uid )
	{
	uid.Set("1.2.840.10008.5.1.4.1.1.6");
	return ( TRUE );
	}

BOOL	SCStorage	::	GetUID ( UID	&uid )
	{
	uid.Set("1.2.840.10008.5.1.4.1.1.7");
	return ( TRUE );
	}

BOOL	StandaloneOverlayStorage	::	GetUID ( UID	&uid )
	{
	uid.Set("1.2.840.10008.5.1.4.1.1.8");
	return ( TRUE );
	}

BOOL	StandaloneCurveStorage	::	GetUID ( UID	&uid )
	{
	uid.Set("1.2.840.10008.5.1.4.1.1.9");
	return ( TRUE );
	}

BOOL	StandaloneModalityLUTStorage	::	GetUID	(UID	&uid )
	{
	uid.Set("1.2.840.10008.5.1.4.1.1.10");
	return ( TRUE );
	}

BOOL	StandaloneVOILUTStorage	::	GetUID ( UID	&uid )
	{
	uid.Set("1.2.840.10008.5.1.4.1.1.11");
	return ( TRUE );
	}


BOOL	GEMRStorage	::	GetUID( UID	& uid )
	{
	uid.Set("1.2.840.113619.4.2");
	return ( TRUE );
	}

BOOL	GECTStorage	::	GetUID ( UID & uid )
	{
	uid.Set("1.2.840.113619.4.3");
	return ( TRUE );
	}
