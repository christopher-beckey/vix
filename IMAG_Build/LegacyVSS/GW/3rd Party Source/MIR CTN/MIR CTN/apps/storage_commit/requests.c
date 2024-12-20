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
**				DINPACS 97
**		     Electronic Radiology Laboratory
**		   Mallinckrodt Institute of Radiology
**		Washington University School of Medicine
**
** Module Name(s):
** Author, Date:	Stephen Moore, 23-Mar-1997
** Intent:
** Last Update:		$Author: Vhaiswstarkm $, $Date: 11/04/10 9:13a $
** Source File:		$RCSfile: requests.c,v $
** Revision:		$Revision: 1 $
** Status:		$State: Exp $
*/

static char rcsid[] = "$Revision: 1 $ $RCSfile: requests.c,v $";

#include "ctn_os.h"

#if 0
#include <stdio.h>
#include <sys/types.h>
#include <stdlib.h>
#include <string.h>
#ifdef MACH
#include <unistd.h>
#endif
#endif

#include "dicom.h"
#include "condition.h"
#include "tbl.h"
#include "lst.h"
#include "dicom_uids.h"
#include "dulprotocol.h"
#include "dicom_objects.h"
#include "dicom_ie.h"
#include "dicom_messages.h"
#include "dicom_services.h"
#include "tbl.h"
#include "manage.h"
#include "idb.h"
#include "fis.h"

#include "storage_commit.h"

extern char *controlDatabase;
extern CTNBOOLEAN doVerification;

typedef struct {
    char *fileName;
    char *transferSyntax;
    char *owner;
    char *groupName;
    char *priv;
    DMAN_HANDLE **handle;
}   STORAGE_PARAMS;

static IDB_HANDLE *IDBHandle;
static FIS_HANDLE *fisHandle;

extern CTNBOOLEAN silent;

/* The first set of functions are private functions, local to this file. */

/* echoCallback
**
** Purpose:
**	Call back routine provided by the service provider. It is invoked
**	by the SRV Echo Response function.
**
** Parameter Dictionary:
**	request		Pointer to C-Echo Request Message
**	response	Pointer to C-Echo Response Message
**	ctx		Context information that we ignore
**	pc		Presentation context pointer that we ignore
**
** Return Values:
**	SRV_NORMAL
**
** Notes:
**
** Algorithm:
**	Description of the algorithm (optional) and any other notes.
*/

static CONDITION
echoCallback(MSG_C_ECHO_REQ * request,
	     MSG_C_ECHO_RESP * response, void *ctx,
	     DUL_PRESENTATIONCONTEXT * pc)
{
    if (!silent)
	printf("Echo Request Received/Acknowledged\n");

    response->dataSetType = DCM_CMDDATANULL;
    response->messageIDRespondedTo = request->messageID;
    response->status = MSG_K_SUCCESS;
    strcpy(response->classUID, request->classUID);

    return SRV_NORMAL;
}

/* echoRequest
**
** Purpose:
**	This function responds to an echo request from the network.
**	It creates an echo response message with a status of success
**	and sends the message to the peer application.
**
** Parameter Dictionary:
**	association	They key which is used to access the association
**			on which requests are received.
**	ctx		Pointer to the presentation context for this command
**	message		Pointer to the MSG_C_ECHO_REQ message that was
**			received by the server.
**
** Return Values:
**
**	SRV_CALLBACKABORTEDSERVICE
**	SRV_ILLEGALPARAMETER
**	SRV_NOCALLBACK
**	SRV_NORMAL
**	SRV_OBJECTBUILDFAILED
**	SRV_RESPONSEFAILED
**
** Algorithm:
**	Description of the algorithm (optional) and any other notes.
*/

static CONDITION
echoRequest(DUL_ASSOCIATIONKEY ** association,
	    DUL_PRESENTATIONCONTEXT * ctx, MSG_C_ECHO_REQ ** echoReq)
{
    MSG_C_ECHO_RESP
    echoResponse = {
	MSG_K_C_ECHO_RESP, 0, 0, DCM_CMDDATANULL, 0, ""
    };

    return SRV_CEchoResponse(association, ctx, echoReq,
			     &echoResponse, echoCallback, NULL, "");
}


/* serviceThisCommand
**
** Purpose:
**	This function serves as a dispatch routine for the commands
**	that can be received from the network.  It uses a case statement
**	to identify the command and call the function which will
**	respond to the request.
**
** Parameter Dictionary:
**	association	They key which is used to access the association
**			on which requests are received.
**	ctx		Pointer to the presentation context for this command
**	messageType	The type of message that we are to recognize.
**	message		Pointer to a structure which contains the message.
**			We will use "messageType" to get the proper type.
**
** Return Values:
**
** Algorithm:
**	Description of the algorithm (optional) and any other notes.
*/

static CONDITION
serviceThisCommand(DUL_NETWORKKEY ** network, DUL_ASSOCIATIONKEY ** association,
		   DUL_PRESENTATIONCONTEXT * ctx, MSG_TYPE messageType,
		   void **message, DUL_ASSOCIATESERVICEPARAMETERS * params,
		   DMAN_HANDLE ** handle)
{
    CONDITION
    cond;
    MSG_GENERAL
	* general;

    general = *(MSG_GENERAL **) message;

    if (!silent)
	MSG_DumpMessage((void *) general, stdout);
    switch (messageType) {
    case MSG_K_C_ECHO_REQ:
	cond = echoRequest(association, ctx, (MSG_C_ECHO_REQ **) message);
	break;
    case MSG_K_C_STORE_REQ:
	fprintf(stderr, "Unimplemented message type: %d\n", messageType);
	cond = 1;
	break;
    case MSG_K_C_FIND_REQ:
	fprintf(stderr, "Unimplemented message type: %d\n", messageType);
	cond = 1;
	break;
    case MSG_K_C_MOVE_REQ:
	fprintf(stderr, "Unimplemented message type: %d\n", messageType);
	cond = 1;
	break;
    case MSG_K_C_GET_REQ:
	fprintf(stderr, "Unimplemented message type: %d\n", messageType);
	cond = 1;
	break;
    case MSG_K_C_CANCEL_REQ:
	fprintf(stderr, "Unimplemented message type: %d\n", messageType);
	cond = 1;
	break;
    case MSG_K_N_ACTION_REQ:
	fprintf(stderr, "Unimplemented message type: %d\n", messageType);
	cond = 1;
	break;
    case MSG_K_N_EVENT_REPORT_REQ:
	cond = neventReportRequest(params, association, handle, ctx,
			   (MSG_N_EVENT_REPORT_REQ **) message, &fisHandle);
	break;
    default:
	fprintf(stderr, "Unimplemented message type: %d\n", messageType);
	cond = 1;
	break;
    }
    return cond;
}

/* Following are the public functions in this file. */

/* serviceRequests
**
** Purpose:
**	This function reads requests from the network and services those
**	requests.
**
** Parameter Dictionary:
**	network		The key which is used to access the network.
**	association	They key which is used to access the association
**			on which requests are received.
**	service		The parameter list which describes the association.
**			This list includes the list of presentation contexts
**			for the association.
**	abortFlag	A test flag which tells this function to abort the
**			Association after it receives one image.
**	releaseDelay	Amount of time to delay (sleep) after release
**			is requested before acknowledging release.
**
** Return Values:
**
** Algorithm:
**	Description of the algorithm (optional) and any other notes.
*/

CONDITION
serviceRequests(DUL_NETWORKKEY ** network, DUL_ASSOCIATIONKEY ** association,
		DUL_ASSOCIATESERVICEPARAMETERS * service)
{
    CONDITION
	cond;
    DUL_PRESENTATIONCONTEXT
	* ctx;
    DUL_PRESENTATIONCONTEXTID
	ctxID;
    void
       *message;
    MSG_TYPE
	messageType;
    CTNBOOLEAN
	networkLink = TRUE,
	commandServiced;
    DMAN_HANDLE
	* handle;
    DMAN_STORAGEACCESS
	storage;
    DMAN_FISACCESS fisAccess;

    cond = DMAN_Open(controlDatabase, service->callingAPTitle,
		     service->calledAPTitle, &handle);

    if (cond == DMAN_NORMAL) {
	cond = DMAN_LookupStorage(&handle, service->calledAPTitle,
				  &storage);
    }
    if (cond == DMAN_NORMAL)
	cond = IDB_Open(storage.DbKey, &IDBHandle);

    if (!CTN_ERROR(cond)) {
	cond = DMAN_LookupFISAccess(&handle, service->calledAPTitle, &fisAccess);
	if (!CTN_ERROR(cond))
	    cond = FIS_Open(fisAccess.DbKey, &fisHandle);
    }
    while ((networkLink == TRUE) && !CTN_ERROR(cond)) {
	cond = SRV_ReceiveCommand(association, service, DUL_BLOCK, 0, &ctxID,
				  NULL, &messageType, &message);
	if (cond == SRV_PEERREQUESTEDRELEASE) {
	    networkLink = FALSE;
	    (void) DUL_AcknowledgeRelease(association);
	    (void) DUL_DropAssociation(association);
	} else if (cond == SRV_PEERABORTEDASSOCIATION) {
	    networkLink = FALSE;
	    (void) DUL_DropAssociation(association);
	} else if (cond != SRV_NORMAL) {
	    (void) DUL_DropAssociation(association);
	    COND_DumpConditions();
	    cond = 2;
	} else {
	    ctx = LST_Head(&service->acceptedPresentationContext);
	    if (ctx != NULL)
		(void) LST_Position(&service->acceptedPresentationContext, ctx);
	    commandServiced = FALSE;
	    while (ctx != NULL && !commandServiced) {
		if (ctx->presentationContextID == ctxID) {
		    if (commandServiced) {
			if (!silent)
			    fprintf(stderr,
			      "Context ID Repeat in serviceRequests (%d)\n",
				    ctxID);
		    } else {
			cond = serviceThisCommand(network, association, ctx,
					     messageType, &message, service,
						  &handle);
			if (cond == SRV_OPERATIONCANCELLED) {
			    if (!silent)
				printf("Operation cancelled\n");
			    (void) COND_PopCondition(TRUE);
			} else if (cond != SRV_NORMAL)
			    COND_DumpConditions();
			commandServiced = TRUE;
		    }
		}
		ctx = LST_Next(&service->acceptedPresentationContext);
	    }
	    if (!commandServiced) {
		fprintf(stderr, "In serviceRequests, context ID %d not found\n",
			ctxID);
		(void) DUL_DropAssociation(association);
		networkLink = FALSE;
	    }
	}
    }
    (void) DMAN_Close(&handle);
    (void) IDB_Close(&IDBHandle);
    return cond;
}
