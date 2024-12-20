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
#ifdef	MAC
extern	"C"	int	stricmp(char	*, char *);
#endif
#ifndef	stricmp
#ifndef	WINDOWS
#ifndef	MAC
#	define	stricmp(xxx,yyy)	strcasecmp(xxx, yyy)
#endif
#endif
#endif
#ifdef	WINDOWS
#	include	<stdlib.h>
#endif

CheckedPDU_Service	::	CheckedPDU_Service ( char	*filename )
	{
	InitializeFrom ( filename );
	}

CheckedPDU_Service	::	~CheckedPDU_Service ()
	{
	ReleaseMemory ( );
	}

static	BOOL
__is_whitespace(char	ch)
	{
	switch ( ch )
		{
		case	' ':
		case	'\t':
		case	'\n':
			return ( TRUE );
		}
	return ( FALSE );
	}

#	define	is_whitespace(xxx)	__is_whitespace(xxx)

BOOL
CheckedPDU_Service	::	ReleaseMemory ()
	{
	UINT		Index;

	if ( SOPUIDList )
		{
		Index = 0;
		while ( Index < SOPUIDListCount )
			{
			delete SOPUIDList [ Index ] ;
			delete SOPUIDListNames [ Index ] ;
			++Index;
			}
		delete SOPUIDList;
		delete SOPUIDListNames;
		SOPUIDList = NULL;
		SOPUIDListNames = NULL;
		SOPUIDListCount = 0;
		}

	if ( TransferUIDList )
		{
		Index = 0;
		while ( Index < TransferUIDListCount )
			{
			delete TransferUIDList [ Index ] ;
			delete TransferUIDListNames [ Index ] ;
			++Index;
			}
		delete TransferUIDList;
		delete TransferUIDListNames;
		TransferUIDList = NULL;
		TransferUIDListNames = NULL;
		TransferUIDListCount = 0;
		}

	if ( ApplicationUIDList )
		{
		Index = 0;
		while ( Index < ApplicationUIDListCount )
			{
			delete ApplicationUIDList [ Index ] ;
			delete ApplicationUIDListNames [ Index ] ;
			++Index;
			}
		delete ApplicationUIDList;
		delete ApplicationUIDListNames;
		ApplicationUIDList = NULL;
		ApplicationUIDListNames = NULL;
		ApplicationUIDListCount = 0;
		}
	if ( RemoteAEList )
		{
		Index = 0;
		while ( Index < RemoteAEListCount )
			{
			delete RemoteAEList [ Index ] ;
			delete RemoteAEListNames [ Index ] ;
			++Index;
			}
		delete RemoteAEList;
		delete RemoteAEListNames;
		RemoteAEList = NULL;
		RemoteAEListNames = NULL;
		RemoteAEListCount = 0;
		}
	if ( LocalAEList )
		{
		Index = 0;
		while ( Index < LocalAEListCount )
			{
			delete LocalAEList [ Index ] ;
			delete LocalAEListNames [ Index ] ;
			++Index;
			}
		delete LocalAEList;
		delete LocalAEListNames;
		LocalAEList = NULL;
		LocalAEListNames = NULL;
		LocalAEListCount = 0;
		}
	return ( TRUE );
	}

BOOL
CheckedPDU_Service	::	InitializeFrom	(char	*filename)
	{
	FILE		*fp;
	UINT		Index, ArgIndex;
	UINT	SOPUIDListIndex = 0,
			TransferUIDListIndex = 0,
			ApplicationUIDListIndex = 0,
			RemoteAEListIndex = 0,
			LocalAEListIndex = 0;
	char		s[256];
	char		Arg1[64];
	char		Arg2[64];
	char		Arg3[64];
	//char		Arg4[64];

	SOPUIDListCount = 0;
	TransferUIDListCount = 0;
	ApplicationUIDListCount = 0;
	RemoteAEListCount = 0;
	LocalAEListCount = 0;
	SOPUIDList = NULL;
	TransferUIDList = NULL;
	ApplicationUIDList = NULL;
	RemoteAEList = NULL;
	LocalAEList = NULL;

	if ( ! filename )
		return ( FALSE );

#ifndef	WINDOWS
	fp = fopen ( filename, "r" );
#else
	fp = _fsopen ( filename, "r", _SH_DENYWR );
#endif
	if ( ! fp )
		return ( FALSE );

	fgets ( s, 255, fp );
	while ( ! feof ( fp ) )
		{
		if ( s [ 0 ] == '#' )
			{
			fgets( s, 255, fp );
			continue;
			}
		Index = 0;
		ArgIndex = 0;
		while ( is_whitespace(s[Index]) )
			{
			if ( ! s[Index] )
				break;
			++Index;
			}
		if ( ! s[Index] )
			{
			fgets ( s, 255, fp );
			continue;
			}
		while ( !is_whitespace(s[Index]) )
			{
			Arg1[ArgIndex] = s[Index];
			if(!s[Index])
				break;
			++Index;
			++ArgIndex;
			}
		Arg1[ArgIndex] = '\0';
		if ( !s [Index] )
			{
			// garbled line
			fgets ( s, 255, fp );
			continue;
			}
		ArgIndex = 0;
		while ( is_whitespace(s[Index]) )
			{
			if ( ! s[Index] )
				break;
			++Index;
			}
		if ( ! s[Index] )
			{
			fgets ( s, 255, fp );
			continue;
			}
		while ( !is_whitespace(s[Index]) )
			{
			Arg2[ArgIndex] = s[Index];
			if(!s[Index])
				break;
			++Index;
			++ArgIndex;
			}
		Arg2[ArgIndex] = '\0';
		if ( !s [Index] )
			{
			fgets ( s, 255, fp );
			continue;
			}
		ArgIndex = 0;
		while ( is_whitespace(s[Index]) )
			{
			if ( ! s[Index] )
				break;
			++Index;
			}
		if ( ! s[Index] )
			{
			fgets ( s, 255, fp );
			continue;
			}
		while ( !is_whitespace(s[Index]) )
			{
			Arg3[ArgIndex] = s[Index];
			if(!s[Index])
				break;
			++Index;
			++ArgIndex;
			}
		Arg3[ArgIndex] = '\0';
		if(!stricmp(Arg3, "RemoteAE"))
			++RemoteAEListCount;
		if(!stricmp(Arg3, "LocalAE"))
			++LocalAEListCount;
		if(!stricmp(Arg3, "sop"))
			++SOPUIDListCount;
		if(!stricmp(Arg3, "abstract"))
			++SOPUIDListCount;
		if(!stricmp(Arg3, "transfer"))
			++TransferUIDListCount;
		if(!stricmp(Arg3, "Application"))
			++ApplicationUIDListCount;

		// should detect garbled / unrecognized lines

		fgets ( s, 255, fp );
		}
	//fclose ( fp );

	if ( SOPUIDListCount )
		{
		SOPUIDList = new char *[SOPUIDListCount];
		SOPUIDListNames = new char *[SOPUIDListCount];
		}
	if ( TransferUIDListCount )
		{
		TransferUIDList = new char *[TransferUIDListCount];
		TransferUIDListNames = new char *[TransferUIDListCount];
		}
	if ( ApplicationUIDListCount )
		{
		ApplicationUIDList = new char *[ApplicationUIDListCount];
		ApplicationUIDListNames = new char *[ApplicationUIDListCount];
		}
	if ( RemoteAEListCount )
		{
		RemoteAEList = new char *[RemoteAEListCount];
		RemoteAEListNames = new char *[RemoteAEListCount];
		}
	if ( LocalAEListCount )
		{
		LocalAEList = new char *[LocalAEListCount];
		LocalAEListNames = new char *[LocalAEListCount];
		}

	Index = 0;
	while ( Index < SOPUIDListCount )
		{
		SOPUIDList [ Index ] = NULL;
		SOPUIDListNames [ Index ] = NULL;
		++Index;
		}
	Index = 0;
	while ( Index < TransferUIDListCount )
		{
		TransferUIDList [ Index ] = NULL;
		TransferUIDListNames [ Index ] = NULL;
		++Index;
		}
	Index = 0;
	while ( Index < ApplicationUIDListCount )
		{
		ApplicationUIDList [ Index ] = NULL;
		ApplicationUIDListNames [ Index ] = NULL;
		++Index;
		}
	Index = 0;
	while ( Index < RemoteAEListCount )
		{
		RemoteAEList [ Index ] = NULL;
		RemoteAEListNames [ Index ] = NULL;
		++Index;
		}
	Index = 0;
	while ( Index < LocalAEListCount )
		{
		LocalAEList [ Index ] = NULL;
		LocalAEListNames [ Index] = NULL;
		++Index;
		}

	fseek(fp, 0, SEEK_SET);
//	fp = fopen ( filename, "r" );
//	if ( ! fp )
//		return ( FALSE );

	fgets ( s, 255, fp );
	while ( ! feof ( fp ) )
		{
		if ( s [ 0 ] == '#' )
			{
			fgets( s, 255, fp );
			continue;
			}
		Index = 0;
		ArgIndex = 0;
		while ( is_whitespace(s[Index]) )
			{
			if ( ! s[Index] )
				break;
			++Index;
			}
		if ( ! s[Index] )
			{
			fgets ( s, 255, fp );
			continue;
			}
		while ( !is_whitespace(s[Index]) )
			{
			Arg1[ArgIndex] = s[Index];
			if(!s[Index])
				break;
			++Index;
			++ArgIndex;
			}
		Arg1[ArgIndex] = '\0';
		if ( !s [Index] )
			{
			// garbled line
			fgets ( s, 255, fp );
			continue;
			}
		ArgIndex = 0;
		while ( is_whitespace(s[Index]) )
			{
			if ( ! s[Index] )
				break;
			++Index;
			}
		if ( ! s[Index] )
			{
			fgets ( s, 255, fp );
			continue;
			}
		while ( !is_whitespace(s[Index]) )
			{
			Arg2[ArgIndex] = s[Index];
			if(!s[Index])
				break;
			++Index;
			++ArgIndex;
			}
		Arg2[ArgIndex] = '\0';
		if ( !s [Index] )
			{
			fgets ( s, 255, fp );
			continue;
			}
		ArgIndex = 0;
		while ( is_whitespace(s[Index]) )
			{
			if ( ! s[Index] )
				break;
			++Index;
			}
		if ( ! s[Index] )
			{
			fgets ( s, 255, fp );
			continue;
			}
		while ( !is_whitespace(s[Index]) )
			{
			Arg3[ArgIndex] = s[Index];
			if(!s[Index])
				break;
			++Index;
			++ArgIndex;
			}
		Arg3[ArgIndex] = '\0';
		if(!stricmp(Arg3, "RemoteAE"))
			{
			RemoteAEList [ RemoteAEListIndex ] = 
				new char [ strlen ( Arg2 ) + 1 ];
			RemoteAEListNames [ RemoteAEListIndex ] =
				new char [ strlen ( Arg1 ) + 1 ];
			strcpy ( RemoteAEList [ RemoteAEListIndex ], Arg2 );
			strcpy ( RemoteAEListNames [ RemoteAEListIndex ], Arg1 );
			++RemoteAEListIndex;
			}
		if(!stricmp(Arg3, "LocalAE"))
			{
			LocalAEList [ LocalAEListIndex ] = 
				new char [ strlen ( Arg2 ) + 1 ];
			LocalAEListNames [ LocalAEListIndex ] =
				new char [ strlen ( Arg1 ) + 1 ];
			strcpy ( LocalAEList [ LocalAEListIndex ], Arg2 );
			strcpy ( LocalAEListNames [ LocalAEListIndex ], Arg1 );
			++LocalAEListIndex;
			}
		if(!stricmp(Arg3, "sop"))
			{
			SOPUIDList [ SOPUIDListIndex ] = 
				new char [ strlen ( Arg2 ) + 1 ];
			SOPUIDListNames [ SOPUIDListIndex ] =
				new char [ strlen ( Arg1 ) + 1 ];
			strcpy ( SOPUIDList [ SOPUIDListIndex ], Arg2 );
			strcpy ( SOPUIDListNames [ SOPUIDListIndex ], Arg1 );
			++SOPUIDListIndex;
			}
		if(!stricmp(Arg3, "abstract"))
			{
			SOPUIDList [ SOPUIDListIndex ] = 
				new char [ strlen ( Arg2 ) + 1 ];
			SOPUIDListNames [ SOPUIDListIndex ] =
				new char [ strlen ( Arg1 ) + 1 ];
			strcpy ( SOPUIDList [ SOPUIDListIndex ], Arg2 );
			strcpy ( SOPUIDListNames [ SOPUIDListIndex ], Arg1 );
			++SOPUIDListIndex;
			}
		if(!stricmp(Arg3, "transfer"))
			{
			TransferUIDList [ TransferUIDListIndex ] = 
				new char [ strlen ( Arg2 ) + 1 ];
			TransferUIDListNames [ TransferUIDListIndex ] =
				new char [ strlen ( Arg1 ) + 1 ];
			strcpy ( TransferUIDList [ TransferUIDListIndex ], Arg2 );
			strcpy ( TransferUIDListNames [ TransferUIDListIndex ], Arg1 );
			++TransferUIDListIndex;
			}
		if(!stricmp(Arg3, "Application"))
			{
			ApplicationUIDList [ ApplicationUIDListIndex ] = 
				new char [ strlen ( Arg2 ) + 1 ];
			ApplicationUIDListNames [ ApplicationUIDListIndex ] =
				new char [ strlen ( Arg1 ) + 1 ];
			strcpy ( ApplicationUIDList [ ApplicationUIDListIndex ], Arg2 );
			strcpy ( ApplicationUIDListNames [ ApplicationUIDListIndex ], Arg1 );
			++ApplicationUIDListIndex;
			}

		// should detect garbled / unrecognized lines

		fgets ( s, 255, fp );
		}
	fclose ( fp );

	return ( TRUE );	
	}

BOOL
CheckedPDU_Service	::	CanYouHandleTransferSyntax (
	TransferSyntax	&TrnSyntax)
	{
	UINT		Index;

	if ( ! TransferUIDListCount )
		return ( TRUE );

	Index = 0;
	while ( Index < TransferUIDListCount )
		{
		if ( UID ( TransferUIDList [ Index ] ) ==
			TrnSyntax.TransferSyntaxName)
			return ( TRUE );
		++Index;
		}
	return ( FALSE );
	}

BOOL
CheckedPDU_Service	::	ShouldIAcceptRemoteApTitle (
	BYTE	*ApTitle)
	{
	UINT	Index;
	char	s[64];

	if ( ! RemoteAEListCount )
		return ( TRUE );

	memset((void*)s, 0, 32);
	memcpy((void*)s, (void*)ApTitle, 16);
	Index = 0;
	while(s[Index])
		{
		if(__is_whitespace(s[Index]))
			{
			s[Index] = '\0';
			break;
			}
		++Index;
		}
	Index = 0;
	while ( Index < RemoteAEListCount )
		{
		if ( !strcmp(RemoteAEList [ Index ], s))
			return ( TRUE );
		++Index;
		}
	return ( FALSE );
	}

	
BOOL
CheckedPDU_Service	::	ShouldIAcceptLocalApTitle (
	BYTE	*ApTitle)
	{
	UINT	Index;
	char	s[64];

	if ( ! LocalAEListCount )
		return ( TRUE );

	memset((void*)s, 0, 32);
	memcpy((void*)s, (void*)ApTitle, 16);
	Index = 0;
	while(s[Index])
		{
		if(__is_whitespace(s[Index]))
			{
			s[Index] = '\0';
			break;
			}
		++Index;
		}
	Index = 0;
	while ( Index < LocalAEListCount )
		{
		if ( !strcmp(LocalAEList [ Index ], s))
			return ( TRUE );
		++Index;
		}
	return ( FALSE );
	}

BOOL
CheckedPDU_Service	::	ShouldIAcceptApplicationContext (
	ApplicationContext	&AppContext)
	{
	UINT	Index;

	if ( ! ApplicationUIDListCount )
		return ( TRUE );

	Index = 0;
	while ( Index < ApplicationUIDListCount )
		{
		if ( UID ( ApplicationUIDList [ Index ] ) ==
			AppContext.ApplicationContextName)
			return ( TRUE );
		++Index;
		}
	return ( FALSE );
	}

BOOL
CheckedPDU_Service	::	ShouldIAcceptAbstractSyntax (
	AbstractSyntax	&AbsSyntax)
	{
	UINT	Index;

	if ( ! SOPUIDListCount )
		return ( TRUE );

	Index = 0;
	while ( Index < SOPUIDListCount )
		{
		if ( UID ( SOPUIDList [ Index ] ) ==
			AbsSyntax.AbstractSyntaxName)
			return ( TRUE );
		++Index;
		}
	return ( FALSE );
	}

