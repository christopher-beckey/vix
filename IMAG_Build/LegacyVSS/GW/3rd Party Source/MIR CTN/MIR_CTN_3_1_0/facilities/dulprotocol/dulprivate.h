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
** @$=@$=@$=
*/
/*
**				DICOM 93
**		     Electronic Radiology Laboratory
**		   Mallinckrodt Institute of Radiology
**		Washington University School of Medicine
**
** Module Name(s):
** Author, Date:	Stephen M. Moore, xx-May-92
** Intent:
**  This header contains private typedefs for the DICOM Upper Layer
**  (DUL) protocol package.  This is to be used to compile the DUL
**  package and is not intended to be seen by the applications programmer.
**  Files at the package level should include this file to get the
**  proper typedefs and include the public file "dulprotocol.h" to
**  get the public definitions and function prototypes.  I have omitted
**  the public definitions and prototypes on purpose so that they
**  exist in only one location.
**
** Last Update:		$Author: Vhaiswstarkm $, $Date: 3/28/11 4:42p $
** Source File:		$RCSfile: dulprivate.h,v $
** Revision:		$Revision: 1 $
** Status:		$State: Exp $
*/

#ifdef  __cplusplus
extern "C" {
#endif

#define	PRV_DEFAULTTIMEOUT	-1
#define	PRV_LISTENBACKLOG	50

#define DEBUG_DEVICE	stdout

CONDITION DUL_InitializeFSM(void);
CONDITION
PRV_StateMachine(PRIVATE_NETWORKKEY ** network,
		 PRIVATE_ASSOCIATIONKEY ** association, int event, int state,
		 void *params);

CONDITION
constructAssociatePDU(DUL_ASSOCIATESERVICEPARAMETERS * items,
		      unsigned char type, PRV_ASSOCIATEPDU * pdu);
CONDITION
constructAssociateRejectPDU(unsigned char result,
			    unsigned char source, unsigned char reason,
			    DUL_REJECTRELEASEABORTPDU * pdu);
CONDITION constructReleaseRQPDU(DUL_REJECTRELEASEABORTPDU * pdu);
CONDITION constructReleaseRPPDU(DUL_REJECTRELEASEABORTPDU * pdu);
CONDITION
constructAbortPDU(unsigned char src, unsigned char reason,
		  DUL_REJECTRELEASEABORTPDU * pdu);
CONDITION
constructDataPDU(void *buf, unsigned long length, DUL_DATAPDV type,
       DUL_PRESENTATIONCONTEXTID ctxID, CTNBOOLEAN last, DUL_DATAPDU * pdu);
CONDITION
streamAssociatePDU(PRV_ASSOCIATEPDU * assoc, unsigned char *b,
		   unsigned long maxLength, unsigned long *rtnLen);
CONDITION
streamRejectReleaseAbortPDU(DUL_REJECTRELEASEABORTPDU * pdu,
	  unsigned char *b, unsigned long maxLength, unsigned long *rtnLen);
CONDITION
streamDataPDUHead(DUL_DATAPDU * pdu, unsigned char *buf,
		  unsigned long maxLength, unsigned long *rtnLen);
CONDITION
parseAssociate(unsigned char *buf, unsigned long len,
	       PRV_ASSOCIATEPDU * pdu);
CONDITION
PRV_NextPDUType(PRIVATE_ASSOCIATIONKEY ** association,
		DUL_BLOCKOPTIONS block, int timeout, unsigned char *type);

void fsmDebug(CTNBOOLEAN flag);
void constructDebug(CTNBOOLEAN flag);
void parseDebug(CTNBOOLEAN flag);
void snoopDebug(CTNBOOLEAN flag);

#ifdef  __cplusplus
}
#endif
