/*
20000420	ljz	    Fix in MakeChapter10: type of AffectedSOPClassUID and
			RequestedSOPClassUID
20020629    wfp     Fix in MakeChapter10 and SaveDICOMDataObject.
*/
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

// Disk File I/O for PDU_Service Class

BOOL
FileBuffer	::	OpenForRead ( char	*filename )
	{
#ifndef	WINDOWS
	fp = fopen(filename, "rb");
#else
	// Open Shared mode for Windows.  Unix will allow sharing by default
	fp = _fsopen(filename, "rb", _SH_DENYWR);
#endif
	if( fp )
		return ( TRUE );
	return ( FALSE );
	}

BOOL
FileBuffer	::	OpenForWrite ( char	*filename )
	{
	fp = fopen(filename, "wb");
	if ( fp )
		return ( TRUE );
	return ( FALSE );
	}

BOOL
FileBuffer	::	Close ()
	{
	fclose(fp);
	return ( TRUE );
	}

BOOL
FileBuffer	::	SendBinary ( BYTE	*Data, UINT	Length )
	{
	fwrite((char*)Data, 1, Length, fp);
	return ( TRUE );
	}

INT
FileBuffer	::	ReadBinary ( BYTE	*Data, UINT	Length )
	{
	INT		Ret;

	//fprintf(stderr, "ReadBinary(Data, %d) : ", Length);
	if(feof(fp))
		{
		//fprintf(stderr, " -1\n");
		return ( -1 );
		}
	Ret = (INT)fread((char*)Data, 1, Length, fp);
	//fprintf(stderr, " %d\n", Ret);
	return ( Ret );
	}

DICOMDataObject	*
PDU_Service	::	LoadDICOMDataObject	(
	char	*filename )
	{
	FileBuffer		IOBuffer;
	FILE			*fp;
	char			s[256];
	DICOMDataObject	*DDO;
	UINT			Mode;
	UINT			CheckOffset;

	fp = fopen(filename, "rb");
	if(!fp)
		return ( NULL );
	fseek(fp, 128, SEEK_SET);
	fread(s, 1, 4, fp);
	s[4] = '\0';
	if(strcmp(s, "DICM"))
		{
		CheckOffset = 0;
		fseek(fp, 0, SEEK_SET);
		}
	else
		CheckOffset = 128+4;

	fread(s,1,6,fp);
	if(s[5]>10)
		Mode = TSA_EXPLICIT_LITTLE_ENDIAN;
	else
		Mode = TSA_IMPLICIT_LITTLE_ENDIAN;
	fseek(fp, CheckOffset, SEEK_SET);
		
	IOBuffer.fp = fp;

	while(IOBuffer.Buffer :: Fill(50000))
		;	// still reading from disk

	DDO = new DICOMDataObject;

	//fprintf(stderr, "Attemping to Parse...\n\n");

	Dynamic_ParseRawVRIntoDCM(IOBuffer, DDO,
		Mode);
	IOBuffer.Close();
	return ( DDO );
	}


#	define	_LittleEndianUID	"1.2.840.10008.1.2"
//wfp-soc
#ifdef PREVIOUS_VERSION
#	define	_ImplementationUID	"none yet"
#	define	_ImplementationVersion	"0.1AlphaUCDMC "
#	define	_SourceApplicationAE	"none"
#endif
//wfp-eoc

BOOL
PDU_Service	::	MakeChapter10 (DICOMDataObject	*DDOPtr)
	{
	VR		*vr, *vr1;
	UINT16	tuint16;
	//VR	*TempVR;
	//char	s[140];
    //wfp-soc
#ifdef NEW_VERSION
	char	_ImplementationUID[64];
	char	_ImplementationVersion[64];
	char	_SourceApplicationAE[16];
#endif
    //wfp-eoc
	ImplementationVersion	IV;
	ImplementationClass		IC;
	DICOMDataObject			DDOTemp;
	

	GetImplementationClass(IC);
   	strcpy(_ImplementationUID, (char*)IC.ImplementationName.GetBuffer(1));
	GetImplementationVersion(IV);
	strcpy(_ImplementationVersion, (char*)IV.Version.GetBuffer(1));
    //wfp-soc
    //wfp-changed the following line.  It was originally calling
    // a nonexistant variable.
	strcpy(_SourceApplicationAE, (char*)PART10_SOURCE_AETITLE);
    //wfp-eoc

	// Strip away the existing Part 10 header..
	while(vr = DDOPtr->Pop())
		{			
		if(vr->Group!=0x0002)
			DDOTemp.Push(vr);
		else
			delete vr;
		}
	while(vr = DDOTemp.Pop())
		DDOPtr->Push(vr);
	//wfp-soc
#ifdef PREVIOUS_VERSION
	vr = DDOPtr->GetVR(0x0002, 0x0001);	// always null
#else
	vr = DDOPtr->GetVR(0x0002, 0x0000);	//wfp-change element to 0x0000
#endif
	//wfp-eoc
	if(!vr)
		{
		// This does not contain the C10 Header yet, so we need to
		// constuct it

		vr = new VR(0x0002, 0x0001, 0x0002, TRUE);
		tuint16 = 0x0100;
		memcpy(vr->Data, (void*)&tuint16, 2);
		vr->TypeCode = 'OB';
		DDOPtr->Push(vr);
		vr = DDOPtr->GetVR(0x0008, 0x0016);
		if(vr)
			{
			vr1 = new VR(0x0002, 0x0002, vr->Length, TRUE);
			memcpy(vr1->Data, vr->Data, vr->Length);
			/* Fix: vr changed to vr1.
			   Thanx to Gunter Zeilinger & Michael Hofer [M_Hofer@gmx.net]
			*/
			vr1->TypeCode = 'UI';
			DDOPtr->Push(vr1);
			}
		vr = DDOPtr->GetVR(0x0008, 0x0018);
		if(vr)
			{
			vr1 = new VR(0x0002, 0x0003, vr->Length, TRUE);
			memcpy(vr1->Data, vr->Data, vr->Length);
			/* Fix: vr changed to vr1.
			   Thanx to Gunter Zeilinger & Michael Hofer [M_Hofer@gmx.net]
			*/
			vr1->TypeCode = 'UI';
			DDOPtr->Push(vr1);
			}
		vr = new VR(0x0002, 0x0010, strlen(_LittleEndianUID), TRUE);
		memset(vr->Data, 0, vr->Length);
		memcpy(vr->Data, (void*)_LittleEndianUID, strlen(_LittleEndianUID));
		vr->TypeCode = 'UI';
		DDOPtr->Push(vr);
		vr = new VR(0x0002, 0x0012, strlen(_ImplementationUID), TRUE);
		memset(vr->Data, 0, vr->Length);
		memcpy(vr->Data, (void*)_ImplementationUID, strlen(_ImplementationUID));
		vr->TypeCode = 'UI';
		DDOPtr->Push(vr);
		vr = new VR(0x0002, 0x0013, strlen(_ImplementationVersion), TRUE);
		memset(vr->Data, 0, vr->Length);
		memcpy(vr->Data, (void*)_ImplementationVersion, strlen(_ImplementationVersion));
		vr->TypeCode = 'SH';
		DDOPtr->Push(vr);
		vr = new VR(0x0002, 0x0016, strlen(_SourceApplicationAE), TRUE);
		memset(vr->Data, 0, vr->Length);
		memcpy(vr->Data, (void*)_SourceApplicationAE, strlen(_SourceApplicationAE));
		vr->TypeCode = 'AE';
		DDOPtr->Push(vr);
		}
	return ( TRUE );
	}

#ifdef NEW_VERSION


BOOL
PDU_Service	::	MakeChapter10 (DICOMDataObject	*DDOPtr, char *TransferMode)
	{
	VR		*vr, *vr1;
	UINT16	tuint16;
	//VR	*TempVR;
	//char	s[140];
	char	_ImplementationUID[64];
	char	_ImplementationVersion[64];
	char	_SourceApplicationAE[16];
	ImplementationVersion	IV;
	ImplementationClass		IC;
	DICOMDataObject			DDOTemp;
	
	//wfp-Add ability to set your own Implementation UID and Version.
	// I check to see if user sets Implementation UID and Version.  If not,
	// insert the default information.
	GetImplementationClass(IC);
	strcpy(_ImplementationUID, (char*)IC.ImplementationName.GetBuffer(1));
	GetImplementationVersion(IV);
	strcpy(_ImplementationVersion, (char*)IV.Version.GetBuffer(1));
    //wfp-soc
    //wfp-changed the following line.  It was originally calling
    // a nonexistant variable.
	strcpy(_SourceApplicationAE, (char*)PART10_SOURCE_AETITLE);
    //wfp-eoc

	// Strip away the existing Part 10 header..
	while(vr = DDOPtr->Pop())
		{			
		if(vr->Group!=0x0002)
			DDOTemp.Push(vr);
		else
			delete vr;
		}
	while(vr = DDOTemp.Pop())
		DDOPtr->Push(vr);

	vr = DDOPtr->GetVR(0x0002, 0x0000);
	if(!vr)
		{
		// This does not contain the C10 Header yet, so we need to
		// constuct it

		vr = new VR(0x0002, 0x0001, 0x0002, TRUE);
		tuint16 = 0x0100;
		memcpy(vr->Data, (void*)&tuint16, 2);
		vr->TypeCode = 'OB';
		DDOPtr->Push(vr);
		vr = DDOPtr->GetVR(0x0008, 0x0016);
		if(vr)
			{
			vr1 = new VR(0x0002, 0x0002, vr->Length, TRUE);
			memcpy(vr1->Data, vr->Data, vr->Length);
			/* Fix: vr changed to vr1.
			   Thanx to Gunter Zeilinger & Michael Hofer [M_Hofer@gmx.net]
			*/
			vr1->TypeCode = 'UI';
			DDOPtr->Push(vr1);
			}
		vr = DDOPtr->GetVR(0x0008, 0x0018);
		if(vr)
			{
			vr1 = new VR(0x0002, 0x0003, vr->Length, TRUE);
			memcpy(vr1->Data, vr->Data, vr->Length);
			/* Fix: vr changed to vr1.
			   Thanx to Gunter Zeilinger & Michael Hofer [M_Hofer@gmx.net]
			*/
			vr1->TypeCode = 'UI';
			DDOPtr->Push(vr1);
			}
		vr = new VR(0x0002, 0x0010, strlen(TransferMode), TRUE);
		memset(vr->Data, 0, vr->Length);
		memcpy(vr->Data, (void*)TransferMode, strlen(TransferMode));
		vr->TypeCode = 'UI';
		DDOPtr->Push(vr);
		vr = new VR(0x0002, 0x0012, strlen(_ImplementationUID), TRUE);
		memset(vr->Data, 0, vr->Length);
		memcpy(vr->Data, (void*)_ImplementationUID, strlen(_ImplementationUID));
		vr->TypeCode = 'UI';
		DDOPtr->Push(vr);
		vr = new VR(0x0002, 0x0013, strlen(_ImplementationVersion), TRUE);
		memset(vr->Data, 0, vr->Length);
		memcpy(vr->Data, (void*)_ImplementationVersion, strlen(_ImplementationVersion));
		vr->TypeCode = 'SH';
		DDOPtr->Push(vr);
		vr = new VR(0x0002, 0x0016, strlen(_SourceApplicationAE), TRUE);
		memset(vr->Data, 0, vr->Length);
		memcpy(vr->Data, (void*)_SourceApplicationAE, strlen(_SourceApplicationAE));
		vr->TypeCode = 'AE';
		DDOPtr->Push(vr);
		}
	return ( TRUE );
	}
#endif

BOOL
PDU_Service	::	SaveDICOMDataObject (
	char	*filename,
	UINT	Format,
	DICOMDataObject	*DDO )
	{
	FileBuffer		IOBuffer;
	FILE			*fp;
	char			s[264];
	char			*TransferSyntax;


	switch ( Format )
		{
		case	ACR_IMPLICIT_LITTLE_ENDIAN:
			fp = fopen(filename, "wb");
			if(!fp)
				return ( FALSE );
			ImplicitLittleEndian_ParseDCMIntoRawVR(DDO, IOBuffer);
			IOBuffer.fp = fp;
			IOBuffer.Buffer::Flush();
			IOBuffer.Close();
			return ( TRUE );
		case	TSA_IMPLICIT_LITTLE_ENDIAN:
			fp = fopen(filename, "wb");
			if(!fp)
				return ( FALSE );
			TransferSyntax = GetTransferSyntaxUID(TSA_IMPLICIT_LITTLE_ENDIAN);
			MakeChapter10(DDO, TransferSyntax);
//wfp-soc
#ifdef PREVIOUS_VERSION
			//below line is original
			ImplicitLittleEndian_ParseDCMIntoRawVR(DDO, IOBuffer);
#else
			Dynamic_ParseDCMIntoRawVR(DDO, IOBuffer, TSA_IMPLICIT_LITTLE_ENDIAN);
#endif
//wfp-eoc
			memset((void*)s, 0, 256);
			strcpy(&s[128], "DICM");
			fwrite(s, 1, 128 + 4, fp);
			IOBuffer.fp = fp;
			IOBuffer.Buffer::Flush();
			IOBuffer.Close();
			free(TransferSyntax);
			return ( TRUE );
		case	TSA_EXPLICIT_LITTLE_ENDIAN:

			fp = fopen(filename, "wb");
			if(!fp)
				return ( FALSE );
			TransferSyntax = GetTransferSyntaxUID(TSA_EXPLICIT_LITTLE_ENDIAN);
			MakeChapter10(DDO, TransferSyntax);
			Dynamic_ParseDCMIntoRawVR(DDO, IOBuffer, TSA_EXPLICIT_LITTLE_ENDIAN);
			memset((void*)s, 0, 256);
			strcpy(&s[128], "DICM");
			fwrite(s, 1, 128 + 4, fp);
			IOBuffer.fp = fp;
			IOBuffer.Buffer::Flush();
			IOBuffer.Close();
			free(TransferSyntax);
			return ( TRUE );
        case    TSA_JPEG_BASELINE:

			fp = fopen(filename, "wb");
			if(!fp)
				return ( FALSE );
			TransferSyntax = GetTransferSyntaxUID(TSA_JPEG_BASELINE);
			MakeChapter10(DDO, TransferSyntax);
			Dynamic_ParseDCMIntoRawVR(DDO, IOBuffer, TSA_JPEG_BASELINE);
			memset((void*)s, 0, 256);
			strcpy(&s[128], "DICM");
			fwrite(s, 1, 128 + 4, fp);
			IOBuffer.fp = fp;
			IOBuffer.Buffer::Flush();
			IOBuffer.Close();
			free(TransferSyntax);
			return ( TRUE );
		}
	return ( FALSE );
	}

