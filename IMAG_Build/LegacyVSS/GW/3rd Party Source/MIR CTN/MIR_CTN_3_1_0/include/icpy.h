/*
          Copyright (C) 1993, 1994, RSNA and Washington University

          The software and supporting documentation for the Radiological
          Society of North America (RSNA) 1993, 1994 Digital Imaging and
          Communications in Medicine (DICOM) Demonstration were developed
          at the
                  Electronic Radiology Laboratory
                  Mallinckrodt Institute of Radiology
                  Washington University School of Medicine
                  510 S. Kingshighway Blvd.
                  St. Louis, MO 63110
          as part of the 1993, 1994 DICOM Central Test Node project for, and
          under contract with, the Radiological Society of North America.

          THIS SOFTWARE IS MADE AVAILABLE, AS IS, AND NEITHER RSNA NOR
          WASHINGTON UNIVERSITY MAKE ANY WARRANTY ABOUT THE SOFTWARE, ITS
          PERFORMANCE, ITS MERCHANTABILITY OR FITNESS FOR ANY PARTICULAR
          USE, FREEDOM FROM ANY COMPUTER DISEASES OR ITS CONFORMITY TO ANY
          SPECIFICATION. THE ENTIRE RISK AS TO QUALITY AND PERFORMANCE OF
          THE SOFTWARE IS WITH THE USER.

          Copyright of the software and supporting documentation is
          jointly owned by RSNA and Washington University, and free access
          is hereby granted as a license to use this software, copy this
          software and prepare derivative works based upon this software.
          However, any distribution of this software source code or
          supporting documentation or derivative works (source code and
          supporting documentation) must include the three paragraphs of
          the copyright notice.
*/
/* Copyright marker.  Copyright will be inserted above.  Do not remove */

/*
**		     Electronic Radiology Laboratory
**		   Mallinckrodt Institute of Radiology
**		Washington University School of Medicine
**
** Module Name(s):
** Author, Date:	Steve Moore, 15-Jun-1994
** Intent:		Define typedefs and function prototypes for
**			ICPY facility (for image copy functions).
** Last Update:		$Author: Vhaiswstarkm $, $Date: 3/28/11 4:44p $
** Source File:		$RCSfile: icpy.h,v $
** Revision:		$Revision: 1 $
** Status:		$State: Exp $
*/


#ifndef _ICPY_IS_IN
#define _ICPY_IS_IN 1

#ifdef  __cplusplus
extern "C" {
#endif

typedef enum {
    ICPY_K_FORWARDRECORD, ICPY_K_COPYRECORD
}   ICPY_DATATYPE;

typedef struct {
    void *reserved[2];
    ICPY_DATATYPE Type;
    char SourceApplication[17];
    char DestinationApplication[17];
    char ForwardingApplication[17];
}   ICPY_FORWARDRECORD;

typedef struct {
    void *reserved[2];
    ICPY_DATATYPE Type;
    char Accession[17];
    char Source[17];
    char Destination[17];
    char Modality[3];
    char SOPInstanceUID[65];
    int CopyNumber;
    int RetryCount;
    int FailureStatus;
}   ICPY_COPYRECORD;

#define	ICPY_FAILURE_NONE	0
#define	ICPY_FAILURE_TEMPORARY	1
#define	ICPY_FAILURE_PERMANENT	2

/* Define condition values */

#define	ICPY_NORMAL		FORM_COND(FAC_ICPY, SEV_SUCC, 1)

#ifdef  __cplusplus
}
#endif

#endif
