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

/* Version related information
 *
 * This file contains the version number/Class that will be embedded not
 * only in the executable, but in the default PDU Service transfer Class.
 *
 */
#	define	IMPLEMENTATION_CLASS_UID		"1.2.826.0.1.3680043.2.405.4848"
//wfp-soc
//wfp- created default AETitle when generating Part 10 File.
#   define PART10_SOURCE_AETITLE "UCDMC_TOOLKIT "
//wfp-eoc
#ifdef	WINDOWS
#	define	IMPLEMENTATION_VERSION_STRING	"UCDMC/1.0.3/WIN32"
#else
#ifdef	ULTRIXMIPS
#	define	IMPLEMENTATION_VERSION_STRING	"UCDMC/1.0.3/UMIPS"
#else
#ifdef	SOLARIS
#	define	IMPLEMENTATION_VERSION_STRING	"UCDMC/1.0.3/SL5"
#else
#ifdef	MAC
#	define	IMPLEMENTATION_VERSION_STRING	"UCDMC/1.0.3/MAC"
#else
#ifdef	SUNOSSPARC
#	define	IMPLEMENTATION_VERSION_STRING	"UCDMC/1.0.3/SUNOS"
#else
#	define	IMPLEMENTATION_VERSION_STRING	"UCDMC/1.0.3/OTHER"
#endif
#endif
#endif
#endif
#endif

