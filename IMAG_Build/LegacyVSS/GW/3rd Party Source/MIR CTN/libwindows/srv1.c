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
**				DICOM 93
**		     Electronic Radiology Laboratory
**		   Mallinckrodt Institute of Radiology
**		Washington University School of Medicine
**
** Module Name(s):	SRV_AcceptServiceClass
**			SRV_MessageIDOut
**			SRV_MessageIDIn
**			SRV_RejectServiceClass
**			SRV_RequestServiceClass
**	private modules
**			SRVPRV_ReadNextPDV
**			writeCallback
**			verifyCommandValidity
**			dequeCommand
**			enqueCommand
**			findPresentationContext
**			createFile
** Author, Date:	Stephen M. Moore, 15-Apr-93
** Intent:		This module contains general routines which are used
**			in our implementation of service classes.  These
**			routines allow users to request and accept service
**			classes, build and manipulate the public DUL
**			structures, send and receive messages, and request
**			unique Message IDs.
** Last Update:		$Author: Vhaiswstarkm $, $Date: 11/04/10 9:07a $
** Source File:		$RCSfile: srv1.c,v $
** Revision:		$Revision: 1 $
** Status:		$State: Exp $
*/

static char rcsid[] = "$Revision: 1 $ $RCSfile: srv1.c,v $";

#include <stdio.h>
#include <string.h>
#include <errno.h>
#include <stdlib.h>
#include <stdarg.h>
#include <sys/types.h>
#ifdef _MSC_VER
#include <io.h>
#include <fcntl.h>
#else
#include <sys/file.h>
#endif
#ifdef MALLOC_DEBUG
#include "malloc.h"
#endif
#ifdef SOLARIS
#include <sys/fcntl.h>
#endif

#include "dicom.h"
#include "dicom_uids.h"
#include "condition.h"
#include "lst.h"
#include "dulprotocol.h"
#include "dicom_objects.h"
#include "dicom_messages.h"
#include "dicom_services.h"
#ifdef CTN_USE_THREADS
#ifndef _MSC_VER
#include <synch.h>
#endif
#include "ctnthread.h"
#endif
#include "private.h"

#define FRAGMENTMAX 65536

typedef unsigned long SRVPERMITTED;

typedef struct {
    char classUID[DICOM_UI_LENGTH + 1];
    SRVPERMITTED *permittedSrvList;	/* list of permitted services */
    unsigned short permittedSrvListSize;
}   SOPCLASSPERMITTEDSRV;	/* defines the various services permitted for
				 * a given SOP class */

/*
static char
    fragmentBuffer[FRAGMENTMAX + 1000];
DUL_PDVLIST pdvList =
{0, fragmentBuffer, sizeof(fragmentBuffer), {0x00, 0x00, 0x00}, NULL};
*/

static char *syntaxList[] = {
    DICOM_SOPCLASSVERIFICATION,
    DICOM_SOPCLASSCOMPUTEDRADIOGRAPHY,
    DICOM_SOPCLASSCT,
    DICOM_SOPCLASSUSMULTIFRAMEIMAGE1993,
    DICOM_SOPCLASSUSMULTIFRAMEIMAGE,
    DICOM_SOPCLASSMR,
    DICOM_SOPCLASSNM,
    DICOM_SOPCLASSUS1993,
    DICOM_SOPCLASSUS,
    DICOM_SOPCLASSSECONDARYCAPTURE,
    DICOM_SOPCLASSXRAYANGIO,
    DICOM_SOPCLASSXRAYFLUORO,
    DICOM_SOPRTIMAGESTORAGE,
    DICOM_SOPRTDOSESTORAGE,
    DICOM_SOPRTSTRUCTURESETSTORAGE,
    DICOM_SOPRTPLANSTORAGE,
    DICOM_SOPCLASSPET,
    DICOM_SOPCLASSSTANDALONEPETCURVE,
    DICOM_SOPPATIENTQUERY_FIND,
    DICOM_SOPPATIENTQUERY_MOVE,
    DICOM_SOPPATIENTQUERY_GET,
    DICOM_SOPSTUDYQUERY_FIND,
    DICOM_SOPSTUDYQUERY_MOVE,
    DICOM_SOPSTUDYQUERY_GET,
    DICOM_SOPPATIENTSTUDYQUERY_FIND,
    DICOM_SOPPATIENTSTUDYQUERY_MOVE,
    DICOM_SOPPATIENTSTUDYQUERY_GET,
    DICOM_SOPCLASSGREYSCALEPRINTMGMTMETA,
    DICOM_SOPCLASSCOLORPRINTMGMTMETA,
    DICOM_SOPCLASSDETACHEDPATIENTMGMT,
    DICOM_SOPCLASSDETACHEDVISITMGMT,
    DICOM_SOPCLASSDETACHEDPATIENTMGMTMETA,
    DICOM_SOPCLASSDETACHEDSTUDYMGMT,
    DICOM_SOPCLASSDETACHEDRESULTSMGMT,
    DICOM_SOPCLASSDETACHEDINTERPRETMGMT,
    DICOM_SOPCLASSDETACHEDRESULTSMGMTMETA,
    DICOM_SOPCLASSSTUDYCOMPONENTMGMT,
    DICOM_SOPCLASSDETACHEDSTUDYMGMTMETA,
    DICOM_SOPCLASSSTORAGECOMMITMENTPUSHMODEL,
    DICOM_SOPMODALITYWORKLIST_FIND,
	DICOM_SOPCLASSVLENDOSCOPY,
	DICOM_SOPCLASSVLMICROSCOPY,
	DICOM_SOPCLASSVLSLIDECOORDS,
	DICOM_SOPCLASSVLPHOTO,	
	DICOM_SOPCLASSDXPRESENT,
	DICOM_SOPCLASSDXPROCESS,	
	DICOM_SOPCLASSDXMAMMOPRES,
	DICOM_SOPCLASSDXMAMMOPROC,
	DICOM_SOPCLASSDXORALPRES,
	DICOM_SOPCLASSDXORALPROC
};

typedef struct {
    void *reserved[2];
    DUL_ASSOCIATIONKEY **association;
    DUL_PRESENTATIONCONTEXTID ctxID;
    unsigned short command;
    MSG_TYPE messageType;
    void *message;
}   COMMAND_ENTRY;

extern CTNBOOLEAN PRVSRV_debug;
static DUL_PRESENTATIONCONTEXT
*
findPresentationCtx(DUL_ASSOCIATESERVICEPARAMETERS * params,
		    DUL_PRESENTATIONCONTEXTID ctxid);

/* SRV_RequestServiceClass
**
** Purpose:
**	This function is called by an application which is proposing an
**	Association and wishes to request a service class.  The application
**	can request the Service Class as an SCU or as an SCP.  This function
**	determines if the SERVICES library supports the service class
**	(table lookup).  If so, it builds a Presentation Context for the
**	service and adds it to the list of Presentation Contexts for the
**	Association which is to be requested.
**
** Parameter Dictionary:
**	SOPClass	UID of the abstract syntrax which defines the
**			service class
**	role		Role the application wishes to propose for this
**			class (SCU, SCP, both, default)
**	params		Parameter list for the Association to be requested.
**			This includes the list of Presentation Contexts
**			for the Association.
**
** Return Values:
**
**	SRV_LISTFAILURE
**	SRV_MALLOCFAILURE
**	SRV_NORMAL
**	SRV_PRESENTATIONCONTEXTERROR
**	SRV_UNSUPPORTEDSERVICE
**
** Algorithm:
**	Description of the algorithm (optional) and any other notes.
*/

CONDITION
SRV_RequestServiceClass(char *SOPClass, DUL_SC_ROLE role,
			DUL_ASSOCIATESERVICEPARAMETERS * params)
{
    DUL_PRESENTATIONCONTEXTID
	contextID = 1;
    int
        index;
    CTNBOOLEAN
	found = FALSE;
    CONDITION
	cond;
    DUL_PRESENTATIONCONTEXT
	* ctx;

    if (params->requestedPresentationContext == NULL) {
	params->requestedPresentationContext = LST_Create();
	if (params->requestedPresentationContext == NULL) {
	    return COND_PushCondition(SRV_LISTFAILURE,
		   SRV_Message(SRV_LISTFAILURE), "SRV_RequestServiceClass");
	}
    }
    ctx = LST_Head(&params->requestedPresentationContext);
    if (ctx != NULL)
	(void) LST_Position(&params->requestedPresentationContext, ctx);
    while (ctx != NULL) {
	contextID += 2;
	if (strcmp(SOPClass, ctx->abstractSyntax) == 0)
	    return SRV_NORMAL;

	ctx = LST_Next(&params->requestedPresentationContext);
    }

    for (index = 0; index < (int) DIM_OF(syntaxList) && !found; index++) {
	if (strcmp(SOPClass, syntaxList[index]) == 0) {
	    found = TRUE;
	}
    }
    if (found) {
	cond = DUL_MakePresentationCtx(&ctx, role, DUL_SC_ROLE_DEFAULT,
				       contextID, 0, SOPClass, "",
				       DICOM_TRANSFERLITTLEENDIAN, NULL);
	if (cond != DUL_NORMAL)
	    return COND_PushCondition(SRV_PRESENTATIONCONTEXTERROR,
				  SRV_Message(SRV_PRESENTATIONCONTEXTERROR),
				      "SRV_RequestServiceClass");
	else {
	    cond = LST_Enqueue(&params->requestedPresentationContext, ctx);
	    if (cond != LST_NORMAL)
		return COND_PushCondition(SRV_LISTFAILURE,
		   SRV_Message(SRV_LISTFAILURE), "SRV_RequestServiceClass");

	    contextID += 2;
	}
    } else
	return COND_PushCondition(SRV_UNSUPPORTEDSERVICE,
			      SRV_Message(SRV_UNSUPPORTEDSERVICE), SOPClass,
				  "SRV_RequestServiceClass");

/*    pdvList.count = 0; */

    return SRV_NORMAL;
}

/* SRV_AcceptServiceClass
**
** Purpose:
**	Determine if the SRV facility can accept a proposed service class and
**	and build the appropriate response for the Association Accept message.
**
** Parameter Dictionary:
**	requestedCtx	The presentation context for the sevice which has been
**			requested by the Requesting Application. This context
**			includes the UID of the service class as well as the
**			proposed transfer syntax UIDs.
**	role		Role proposed by the application for this service
**			class.
**	params		The list of service parameters for the Association
**			which is being negotiated.
**
** Return Values:
**
**	SRV_LISTFAILURE
**	SRV_NORMAL
**	SRV_PRESENTATIONCONTEXTERROR
**	SRV_PRESENTATIONCTXREJECTED
**
** Algorithm:
**	Description of the algorithm (optional) and any other notes.
*/

CONDITION
SRV_AcceptServiceClass(DUL_PRESENTATIONCONTEXT * requestedCtx,
		  DUL_SC_ROLE role, DUL_ASSOCIATESERVICEPARAMETERS * params)
{
    int
        index;
    CTNBOOLEAN
	abstractFound = FALSE,
	transferFound = FALSE;

    CONDITION
	cond,
	rtnCond = SRV_NORMAL;
    DUL_PRESENTATIONCONTEXT
	* ctx;
    DUL_TRANSFERSYNTAX
	* transfer;

    if (params->acceptedPresentationContext == NULL) {
	params->acceptedPresentationContext = LST_Create();
	if (params->acceptedPresentationContext == NULL) {
	    return COND_PushCondition(SRV_LISTFAILURE,
		    SRV_Message(SRV_LISTFAILURE), "SRV_AcceptServiceClass");
	}
    }
    for (index = 0; index < (int) DIM_OF(syntaxList) && !abstractFound; index++) {
	if (strcmp(requestedCtx->abstractSyntax, syntaxList[index]) == 0) {
	    abstractFound = TRUE;
	}
    }
    if (abstractFound) {
	if ((transfer = LST_Head(&requestedCtx->proposedTransferSyntax)) == NULL)
	    return COND_PushCondition(SRV_LISTFAILURE,
		    SRV_Message(SRV_LISTFAILURE), "SRV_AcceptServiceClass");
	(void) LST_Position(&requestedCtx->proposedTransferSyntax, transfer);
	while (!transferFound && (transfer != NULL)) {
	    if (strcmp(transfer->transferSyntax, DICOM_TRANSFERLITTLEENDIAN) == 0)
		transferFound = TRUE;
	    else
		transfer = LST_Next(&requestedCtx->proposedTransferSyntax);
	}
	if (transferFound) {
	    cond = DUL_MakePresentationCtx(&ctx,
					 requestedCtx->proposedSCRole, role,
					requestedCtx->presentationContextID,
					   DUL_PRESENTATION_ACCEPT,
					   requestedCtx->abstractSyntax,
	      DICOM_TRANSFERLITTLEENDIAN, DICOM_TRANSFERLITTLEENDIAN, NULL);
	    if (cond != DUL_NORMAL)
		return COND_PushCondition(SRV_PRESENTATIONCONTEXTERROR,
				  SRV_Message(SRV_PRESENTATIONCONTEXTERROR),
					  "SRV_AcceptServiceClass");
	} else {
	    cond = DUL_MakePresentationCtx(&ctx,
					   requestedCtx->proposedSCRole,
					   DUL_SC_ROLE_DEFAULT,
					requestedCtx->presentationContextID,
				    DUL_PRESENTATION_REJECT_TRANSFER_SYNTAX,
					   requestedCtx->abstractSyntax,
	      DICOM_TRANSFERLITTLEENDIAN, DICOM_TRANSFERLITTLEENDIAN, NULL);
	    if (cond != DUL_NORMAL)
		return COND_PushCondition(SRV_PRESENTATIONCONTEXTERROR,
				  SRV_Message(SRV_PRESENTATIONCONTEXTERROR),
					  "SRV_AcceptServiceClass");

	    (void) COND_PushCondition(SRV_UNSUPPORTEDTRANSFERSYNTAX,
				 SRV_Message(SRV_UNSUPPORTEDTRANSFERSYNTAX),
		    requestedCtx->abstractSyntax, "SRV_AcceptServiceClass");
	    rtnCond = COND_PushCondition(SRV_PRESENTATIONCTXREJECTED,
				   SRV_Message(SRV_PRESENTATIONCTXREJECTED),
		    requestedCtx->abstractSyntax, "SRV_AcceptServiceClass");
	}
    } else {
	cond = DUL_MakePresentationCtx(&ctx,
				       requestedCtx->proposedSCRole,
				       DUL_SC_ROLE_DEFAULT,
				       requestedCtx->presentationContextID,
				    DUL_PRESENTATION_REJECT_ABSTRACT_SYNTAX,
				       requestedCtx->abstractSyntax,
	      DICOM_TRANSFERLITTLEENDIAN, DICOM_TRANSFERLITTLEENDIAN, NULL);
	if (cond != DUL_NORMAL)
	    return COND_PushCondition(SRV_PRESENTATIONCONTEXTERROR,
				  SRV_Message(SRV_PRESENTATIONCONTEXTERROR),
				      "SRV_AcceptServiceClass");
	(void) COND_PushCondition(SRV_UNSUPPORTEDSERVICE,
				  SRV_Message(SRV_UNSUPPORTEDSERVICE),
		    requestedCtx->abstractSyntax, "SRV_AcceptServiceClass");
	rtnCond = COND_PushCondition(SRV_PRESENTATIONCTXREJECTED,
				   SRV_Message(SRV_PRESENTATIONCTXREJECTED),
		    requestedCtx->abstractSyntax, "SRV_AcceptServiceClass");
    }
    cond = LST_Enqueue(&params->acceptedPresentationContext, ctx);
    if (cond != LST_NORMAL)
	return COND_PushCondition(SRV_LISTFAILURE, SRV_Message(SRV_LISTFAILURE),
				  "SRV_AcceptServiceClass");

/*    pdvList.count = 0; */

    return rtnCond;
}

/* SRV_RejectServiceClass
**
** Purpose:
**	Reject an SOP class proposed by a calling application.
**
** Parameter Dictionary:
**	requestedCtx	Pointerto requested Presentation Context which user
**			is rejecting.
**	result		One of the defined DUL results which provide reasons
**			for rejecting a Presentation Context.
**	params		The structure which contains parameters which defines
**			the association.
**
** Return Values:
**
**	SRV_LISTFAILURE
**	SRV_NORMAL
**	SRV_PRESENTATIONCONTEXTERROR
**
** Algorithm:
**	Description of the algorithm (optional) and any other notes.
*/

CONDITION
SRV_RejectServiceClass(DUL_PRESENTATIONCONTEXT * requestedCtx,
		       unsigned short result,
		       DUL_ASSOCIATESERVICEPARAMETERS * params)
{
    CONDITION
	cond;
    DUL_PRESENTATIONCONTEXT
	* ctx;

    if (params->acceptedPresentationContext == NULL) {
	params->acceptedPresentationContext = LST_Create();
	if (params->acceptedPresentationContext == NULL) {
	    return COND_PushCondition(SRV_LISTFAILURE,
		    SRV_Message(SRV_LISTFAILURE), "SRV_RejectServiceClass");
	}
    }
    cond = DUL_MakePresentationCtx(&ctx,
				   requestedCtx->proposedSCRole,
				   DUL_SC_ROLE_DEFAULT,
				   requestedCtx->presentationContextID,
				   result, requestedCtx->abstractSyntax,
				   DICOM_TRANSFERLITTLEENDIAN,
				   DICOM_TRANSFERLITTLEENDIAN, NULL);
    if (cond != DUL_NORMAL)
	return COND_PushCondition(SRV_PRESENTATIONCONTEXTERROR,
				  SRV_Message(SRV_PRESENTATIONCONTEXTERROR),
				  "SRV_RejectServiceClass");

    cond = LST_Enqueue(&params->acceptedPresentationContext, ctx);
    if (cond != LST_NORMAL)
	return COND_PushCondition(SRV_LISTFAILURE, SRV_Message(SRV_LISTFAILURE),
				  "SRV_RejectServiceClass");

    return SRV_NORMAL;
}

/* SRV_MessageIDOut
**
** Purpose:
**	Get a unique message ID which can be used in a DICOM command.
**
** Parameter Dictionary:
**	NONE
**
** Return Values:
**	Unique message ID.
**
** Algorithm:
**	Description of the algorithm (optional) and any other notes.
*/

unsigned short
SRV_MessageIDOut()
{
    static unsigned short
        messageID = 0;

#ifdef CTN_USE_THREADS
    if (THR_ObtainMutex(FAC_SRV) != THR_NORMAL) {
	COND_DumpConditions();
	fprintf(stderr, " SRV_MessageIDOut unable to obtain mutex, exiting\n");
	exit(1);
    }
#endif
    messageID++;

#ifdef CTN_USE_THREADS
    if (THR_ReleaseMutex(FAC_SRV) != THR_NORMAL) {
	COND_DumpConditions();
	fprintf(stderr, " SRV_MessageIDOut unable to release mutex, exiting\n");
	exit(1);
    }
#endif
    return messageID;
}

/* SRV_MessageIDIn
**
** Purpose:
**	Function to reclaim ID messages after they have been used.
**
** Parameter Dictionary:
**	messageID	ID to be reclaimed.
**
** Return Values:
**	NONE
**
** Algorithm:
**	Description of the algorithm (optional) and any other notes.
*/

void
SRV_MessageIDIn(unsigned short messageID)
{
}

/* SRV_Debug
**
** Purpose:
**	Set debug flag in this module and in the other modules.
**
** Parameter Dictionary:
**	flag	Boolean flag indicating if debug mode is to be ON or OFF.
**
** Return Values:
**	NONE
**
** Algorithm:
**	Description of the algorithm (optional) and any other notes.
*/

void
SRV_Debug(CTNBOOLEAN flag)
{
    PRVSRV_debug = flag;
}
