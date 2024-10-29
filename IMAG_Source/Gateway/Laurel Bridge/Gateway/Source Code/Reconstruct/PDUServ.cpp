// PDUServ.cpp: implementation of the PDUServ class.
//
//////////////////////////////////////////////////////////////////////

/**********
Class Name: PDUServ
Base Class: PDUService (locate in ucdavis DICOM toolkit)
Author: William Peterson
Copyrighted @ 2001

Purpose: 
	Inheiritant class to make polyphorphism of LoadDICOMDataObject.
Needed to retrieve information not available in original method.

Members:

Changes:
wfp	10/2/2001	Class creation.
wfp 01/23/2002	First build for Development testing.
wfp	01/25/2002	Added additional comments.
wfp 06/21/2003  Added code to handle and process JPEG Baseline Transfer
                Syntax.
**********/

#include "reconstruct.h"

//////////////////////////////////////////////////////////////////////
// Construction/Destruction
//////////////////////////////////////////////////////////////////////

PDUServ::PDUServ()
{

}

PDUServ::~PDUServ()
{

}

//This is a polymorphism from the inheirent class of PDUService
// in ucdavis toolkit.
DICOMDataObject * PDUServ::LoadDICOMDataObject(char *filename, UINT *ts_fileformat)
{
	FileBuffer		IOBuffer;
	FILE			*fp;
	char			s[256];
	DICOMDataObject	*DDO;
	UINT			Mode;
	UINT			CheckOffset;
	bool			isPart10;
	UINT			group2Length;
	UINT			fileMetaVersionLength;
	UINT			mediaSOPClassLength;
	UINT			mediaSOPInstanceLength;
	UINT			mediaTransferSyntaxLength;
	UINT			group2Offset;
	UINT			actualTS;

	//Open file.
	fp = fopen(filename, "rb");
	if(!fp)
		return ( NULL );
	fseek(fp, 128, SEEK_SET);
	fread(s, 1, 4, fp);
	s[4] = '\0';
	//Determine if file is in Part10 format.
	if(strcmp(s, "DICM"))
		{
		//File is not Part10.
		CheckOffset = 0;
		isPart10 = FALSE;
		}
	else
		{
		//File is Part10.
		//Get length of all data that preceeds the Transfer Syntax
		// value.
		group2Length = 12;
		fileMetaVersionLength = 14;
		CheckOffset = 128+4;
		group2Offset = group2Length+fileMetaVersionLength;
		fseek(fp, (CheckOffset+group2Offset), SEEK_SET);
		fread(s,1,7,fp);
		mediaSOPClassLength = s[6] + 8;
		group2Offset = group2Offset + mediaSOPClassLength;
		fseek(fp, (CheckOffset+group2Offset), SEEK_SET);
		fread(s,1,7,fp);
		mediaSOPInstanceLength = s[6] +8;
		group2Offset = group2Offset + mediaSOPInstanceLength;
		fseek(fp, (CheckOffset+group2Offset), SEEK_SET);
		fread(s,1,7,fp);
		mediaTransferSyntaxLength = s[6];
		group2Offset = group2Offset + 8;
		fseek(fp, (CheckOffset+group2Offset), SEEK_SET);
		fread(s,1,mediaTransferSyntaxLength,fp);
		s[mediaTransferSyntaxLength] = '\0';
		//Determine the Transfer Syntax of input file.
        Mode = 0;
		actualTS = 0;
        //Added new function to DICOM Library
        Mode = GetTransferSyntaxUID (s);
		actualTS = GetTransferSyntaxUIDName (s);

		isPart10 = TRUE;
		}

	fseek(fp, CheckOffset, SEEK_SET);
	
	//Determine if file is Part10.
    //Find the proper File format and save it for later.
	if(isPart10 == TRUE)
	{
		*ts_fileformat = actualTS;
/**** wfp 022105-Comment out.  Need to redo to deal with all the individual Transfer Syntaxes.
		if (Mode == TSA_EXPLICIT_LITTLE_ENDIAN)
		{
			//File is Explicit VR/Part10.
			*ts_fileformat = TSA_EXPLICIT_LITTLE_ENDIAN;
		}
        else
        {
		    if (Mode == TSA_IMPLICIT_LITTLE_ENDIAN)
            {
                *ts_fileformat = TSA_IMPLICIT_LITTLE_ENDIAN;
            }
            else
            {
                if (Mode == TSA_EXPLICIT_BIG_ENDIAN)
                {
                    *ts_fileformat = TSA_EXPLICIT_BIG_ENDIAN;
                }
                else
                {
                    if (Mode == TSA_JPEG_BASELINE)
                    {
                        *ts_fileformat = TSA_JPEG_BASELINE;
                    }
                }
            }
        }	**/
	}
	else
	{
		//If not Part10, must be ACR-NEMA.
		Mode = ACR_IMPLICIT_LITTLE_ENDIAN;
		*ts_fileformat = ACR_IMPLICIT_LITTLE_ENDIAN;
	}
			

	IOBuffer.fp = fp;

	while(IOBuffer.Buffer :: Fill(50000))
		;	// still reading from disk

	DDO = new DICOMDataObject;

	Dynamic_ParseRawVRIntoDCM(IOBuffer, DDO,
		Mode);
	IOBuffer.Close();
	return ( DDO );
}



BOOL PDUServ::SaveDICOMDataObject (
	char	*filename,
	UINT	Format,
	DICOMDataObject	*DDO )
{
	FileBuffer		IOBuffer;
	FILE			*fp;
	char			s[264];
	char			*TransferSyntax;
	UINT			modeFormat;

	
	modeFormat = GetTransferSyntaxUIDMode (Format);
	switch ( modeFormat )
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
			TransferSyntax = GetTransferSyntaxUIDName(Format);
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
			//TransferSyntax = GetTransferSyntaxUID(TSA_EXPLICIT_LITTLE_ENDIAN);
			TransferSyntax = GetTransferSyntaxUIDName(Format);
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
			//TransferSyntax = GetTransferSyntaxUID(TSA_JPEG_BASELINE);
			TransferSyntax = GetTransferSyntaxUIDName(Format);
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

