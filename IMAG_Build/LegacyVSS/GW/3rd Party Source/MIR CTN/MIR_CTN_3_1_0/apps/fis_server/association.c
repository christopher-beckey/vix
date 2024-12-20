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
**				DICOM 94
**		     Electronic Radiology Laboratory
**		   Mallinckrodt Institute of Radiology
**		Washington University School of Medicine
**
** Module Name(s):	nextAssociation
** Author, Date:	Stephen Moore, 18-Mar-94
** Intent:
** Last Update:		$Author: Vhaiswstarkm $, $Date: 3/28/11 4:36p $
** Source File:		$RCSfile: association.c,v $
** Revision:		$Revision: 1 $
** Status:		$State: Exp $
*/

static char rcsid[] = "$Revision: 1 $ $RCSfile: association.c,v $";

#include "ctn_os.h"

#if 0
#include <stdio.h>
#include <sys/types.h>
#include <stdlib.h>
#include <string.h>
#ifdef MACH
#include <unistd.h>
#endif
/*lint -e46*/
#include <sys/wait.h>
/*lint +e46*/
#endif

#include "dicom.h"
#include "condition.h"
#include "tbl.h"
#include "lst.h"
#include "dicom_uids.h"
#include "dulprotocol.h"
#include "dicom_objects.h"
#include "dicom_messages.h"
#include "dicom_services.h"
#include "manage.h"
#include "idb.h"

#include "fis_server.h"

extern CTNBOOLEAN verboseDUL;
extern char *controlDatabase;

#define	ACCESS_READ	0x01
#define	ACCESS_WRITE	0x02

static CONDITION
checkDICOMVersion(char *node, DUL_ASSOCIATESERVICEPARAMETERS * params,
    CTNBOOLEAN forgive, DMAN_HANDLE ** handle, DUL_ABORTITEMS * abortItems);
static CONDITION
checkCalledNode(char *node, DUL_ASSOCIATESERVICEPARAMETERS * params,
    CTNBOOLEAN forgive, DMAN_HANDLE ** handle, DUL_ABORTITEMS * abortItems);
static CONDITION
checkCallingNode(char *node, DUL_ASSOCIATESERVICEPARAMETERS * params,
    CTNBOOLEAN forgive, DMAN_HANDLE ** handle, DUL_ABORTITEMS * abortItems);
static CONDITION
checkApplicationConnection(char *node, DUL_ASSOCIATESERVICEPARAMETERS * params,
    CTNBOOLEAN forgive, DMAN_HANDLE ** handle, DUL_ABORTITEMS * abortItems);

char *supportedSOPClasses[] = {
    DICOM_SOPCLASSDETACHEDPATIENTMGMT,
    DICOM_SOPCLASSDETACHEDSTUDYMGMT,
    DICOM_SOPCLASSDETACHEDRESULTSMGMT,
    DICOM_SOPCLASSDETACHEDINTERPRETMGMT,
    DICOM_SOPCLASSSTUDYCOMPONENTMGMT
};

CONDITION
nextAssociationRequest(char *node, DUL_NETWORKKEY ** network,
	     DUL_ASSOCIATESERVICEPARAMETERS * service, unsigned long maxPDU,
		  CTNBOOLEAN forgiveFlag, DUL_ASSOCIATIONKEY ** association)
{
    CTNBOOLEAN
	drop,
	acceptFlag,
	acceptPresentationContext,
	readAccess,
	writeAccess;
    CONDITION
	cond,
	rtnCond = APP_NORMAL;
    DUL_PRESENTATIONCONTEXT
	* requestedCtx;
    int
        classCount;
    DUL_SC_ROLE
	scRole = DUL_SC_ROLE_DEFAULT;
    DUL_ABORTITEMS
	abortItems;
    DMAN_HANDLE
	* manageHandle;

    (void) memset(service, 0, sizeof(*service));
    service->maxPDU = maxPDU;
    strcpy(service->calledImplementationClassUID,
	   MIR_IMPLEMENTATIONCLASSUID);
    strcpy(service->calledImplementationVersionName,
	   MIR_IMPLEMENTATIONVERSIONNAME);
    cond = DUL_ReceiveAssociationRQ(network, DUL_BLOCK,
				    service, association);
    if (cond != DUL_NORMAL)
	return COND_PushCondition(APP_ERROR(APP_ASSOCIATIONRQFAILED));

    acceptFlag = TRUE;
    drop = FALSE;

    cond = DMAN_Open(controlDatabase, service->callingAPTitle,
		     service->calledAPTitle, &manageHandle);
    if (cond != DMAN_NORMAL) {
	acceptFlag = FALSE;
	rtnCond = COND_PushCondition(APP_ERROR(APP_ASSOCIATIONRQFAILED));
    }
    if (acceptFlag) {

	cond = associationCheck(node, service, &manageHandle, forgiveFlag,
				&abortItems);
	if (CTN_ERROR(cond)) {
	    acceptFlag = FALSE;
	    fprintf(stderr, "Incorrect Association Request\n");
	    (void) DUL_RejectAssociationRQ(association, &abortItems);
	    rtnCond = COND_PushCondition(APP_ERROR(APP_ASSOCIATIONRQFAILED));
	} else if (!CTN_SUCCESS(cond)) {
	    COND_DumpConditions();
	}
    }
    if (acceptFlag) {
	if (verboseDUL)
	    DUL_DumpParams(service);

	requestedCtx = LST_Head(&service->requestedPresentationContext);
	if (requestedCtx != NULL)
	    (void) LST_Position(&service->requestedPresentationContext,
				requestedCtx);
	classCount = 0;
	while (requestedCtx != NULL) {
	    int i;

	    acceptPresentationContext = FALSE;
	    for (i = 0; i < DIM_OF(supportedSOPClasses); i++) {
		if (strcmp(supportedSOPClasses[i], requestedCtx->abstractSyntax) == 0)
		    acceptPresentationContext = TRUE;
	    }
	    if (acceptPresentationContext) {
		switch (requestedCtx->proposedSCRole) {
		case DUL_SC_ROLE_DEFAULT:
		    scRole = DUL_SC_ROLE_DEFAULT;
		    break;
		case DUL_SC_ROLE_SCU:
		    scRole = DUL_SC_ROLE_SCU;
		    break;
		case DUL_SC_ROLE_SCP:
		    acceptPresentationContext = FALSE;
		    break;
		case DUL_SC_ROLE_SCUSCP:
		    scRole = DUL_SC_ROLE_SCU;
		    break;
		default:
		    scRole = DUL_SC_ROLE_DEFAULT;
		    break;
		}
	    }
	    if (acceptPresentationContext) {
		cond = SRV_AcceptServiceClass(requestedCtx, scRole,
					      service);
		if (cond == SRV_NORMAL) {
		    classCount++;
		} else {
		    printf("SRV Facility rejected SOP Class: %s\n",
			   requestedCtx->abstractSyntax);
		    COND_DumpConditions();
		}
	    } else {
		printf("Simple server rejects: %s\n",
		       requestedCtx->abstractSyntax);
		cond = SRV_RejectServiceClass(requestedCtx,
				     DUL_PRESENTATION_REJECT_USER, service);
		if (cond != SRV_NORMAL) {
		    drop = TRUE;
		}
	    }
	    requestedCtx = LST_Next(&service->requestedPresentationContext);
	}
	printf("Supported classes: %d\n", classCount);

	if (drop) {
	    (void) DUL_DropAssociation(association);
	    rtnCond = COND_PushCondition(APP_ERROR(APP_ASSOCIATIONRQFAILED));
	} else {
/*	    cond = DUL_AcknowledgeAssociationRQ(association, service);
	    if (cond != DUL_NORMAL) {
		rtnCond = COND_PushCondition(APP_ERROR(APP_ASSOCIATIONRQFAILED));
	    }
	    if (verboseDUL)
		DUL_DumpParams(service);
*/
	}
    }
    (void) DMAN_Close(&manageHandle);
    return rtnCond;
}


/* associationCheck
**
** Purpose:
**	Check the validity of the Association service parameters
**
** Parameter Dictionary:
**	params		Service parameters describing the Association
**	forgive		Decides whether to return a warning or a failure status
**	abortItems	Structure specifying reasons for aborting the
**			Association
**
** Return Values:
**
**	APP_NORMAL
**	APP_PARAMETERFAILURE
**	APP_PARAMETERWARNINGS
**
** Notes:
**
** Algorithm:
**	Description of the algorithm (optional) and any other notes.
**	- Search the "Application Entity" table by title to see if the
**	called AE title identifies an application that exists on this
**	node.
*/

typedef struct {
    CONDITION(*function) ();
}   FUNCTION;

static FUNCTION testVector[] = {{checkDICOMVersion}, {checkCalledNode},
{checkCallingNode}, {checkApplicationConnection}};

CONDITION
associationCheck(char *node, DUL_ASSOCIATESERVICEPARAMETERS * params,
		 DMAN_HANDLE ** manageHandle, CTNBOOLEAN forgive,
		 DUL_ABORTITEMS * abortItems)
{
    CONDITION
	cond,
	rtnCond = APP_NORMAL;
    DMAN_APPLICATIONENTITY
	AEWork, AECriteria;
    long
        count;
    int
        index;


    cond = APP_NORMAL;
    for (index = 0;
	 index < DIM_OF(testVector) && CTN_SUCCESS(cond); index++) {
	cond = testVector[index].function(node, params, forgive, manageHandle,
					  abortItems);
	if (cond != APP_NORMAL) {
	    rtnCond = 0;
	    if (!CTN_FATAL(cond) && forgive) {
		cond = APP_NORMAL;
	    }
	}
    }

    if (rtnCond != APP_NORMAL) {
	if (forgive)
	    rtnCond = COND_PushCondition(APP_PARAMETERWARNINGS,
					 APP_Message(APP_PARAMETERWARNINGS));
	else
	    rtnCond = COND_PushCondition(APP_PARAMETERFAILURE,
					 APP_Message(APP_PARAMETERFAILURE));
    }
    return rtnCond;
}

/* checkDICOMVersion
**
** Purpose:
**	Check the validity of the Association service parameters
**
** Parameter Dictionary:
**	params		Service parameters describing the Association
**	forgive		Decides whether to return a warning or a failure status
**	abortItems	Structure specifying reasons for aborting the
**			Association
**
** Return Values:
**
**	APP_NORMAL
**
** Notes:
**
** Algorithm:
**	Description of the algorithm (optional) and any other notes.
*/

static CONDITION
checkDICOMVersion(char *node, DUL_ASSOCIATESERVICEPARAMETERS * params,
     CTNBOOLEAN forgive, DMAN_HANDLE ** handle, DUL_ABORTITEMS * abortItems)
{
    CONDITION
    cond = APP_NORMAL;

    if (strcmp(params->applicationContextName, DICOM_STDAPPLICATIONCONTEXT) != 0) {
	abortItems->result = DUL_REJECT_PERMANENT;
	abortItems->source = DUL_ULSU_REJECT;
	abortItems->reason = DUL_ULSU_REJ_UNSUP_APP_CTX_NAME;
	cond = COND_PushCondition(APP_ILLEGALSERVICEPARAMETER,
				  APP_Message(APP_ILLEGALSERVICEPARAMETER),
		"Application Context Name", params->applicationContextName);
    }
    if (strlen(params->callingImplementationClassUID) == 0) {
	abortItems->result = DUL_REJECT_PERMANENT;
	abortItems->source = DUL_ULSU_REJECT;
	abortItems->reason = DUL_ULSU_REJ_NOREASON;

	cond = COND_PushCondition(APP_MISSINGSERVICEPARAMETER,
				  APP_Message(APP_MISSINGSERVICEPARAMETER),
				  "Requestor's ImplementationClassUID");
    }
    return cond;
}

/* checkCalledNode
**
** Purpose:
**	Check the validity of the Association service parameters
**
** Parameter Dictionary:
**	params		Service parameters describing the Association
**	forgive		Decides whether to return a warning or a failure status
**	abortItems	Structure specifying reasons for aborting the
**			Association
**
** Return Values:
**
**	APP_NORMAL
**
** Notes:
**
** Algorithm:
**	Description of the algorithm (optional) and any other notes.
*/

static CONDITION
checkCalledNode(char *node, DUL_ASSOCIATESERVICEPARAMETERS * params,
     CTNBOOLEAN forgive, DMAN_HANDLE ** handle, DUL_ABORTITEMS * abortItems)
{
    CONDITION
    cond,
    rtnCond = APP_NORMAL;

    cond = DMAN_VerifyApplication(handle, params->calledAPTitle, node);

    if (cond != DMAN_NORMAL) {
	rtnCond = COND_PushCondition(APP_ILLEGALSERVICEPARAMETER,
				   APP_Message(APP_ILLEGALSERVICEPARAMETER),
				  "Called AE Title", params->calledAPTitle);
    }
    if (rtnCond != APP_NORMAL) {
	abortItems->result = DUL_REJECT_PERMANENT;
	abortItems->source = DUL_ULSU_REJECT;
	abortItems->reason = DUL_ULSU_REJ_UNREC_CALLED_TITLE;
    }
    return rtnCond;
}

/* checkCallingNode
**
** Purpose:
**	Check the validity of the Association service parameters
**
** Parameter Dictionary:
**	params		Service parameters describing the Association
**	forgive		Decides whether to return a warning or a failure status
**	abortItems	Structure specifying reasons for aborting the
**			Association
**
** Return Values:
**
**	APP_NORMAL
**
** Notes:
**
** Algorithm:
**	Description of the algorithm (optional) and any other notes.
*/

static CONDITION
checkCallingNode(char *node, DUL_ASSOCIATESERVICEPARAMETERS * params,
     CTNBOOLEAN forgive, DMAN_HANDLE ** handle, DUL_ABORTITEMS * abortItems)
{
    CONDITION
    cond,
    rtnCond = APP_NORMAL;

    cond = DMAN_VerifyApplication(handle, params->callingAPTitle,
				  params->callingPresentationAddress);
    if (cond != DMAN_NORMAL) {
	rtnCond = COND_PushCondition(APP_ILLEGALSERVICEPARAMETER,
				   APP_Message(APP_ILLEGALSERVICEPARAMETER),
				"Calling AE Title", params->callingAPTitle);
    }
    if (rtnCond != APP_NORMAL) {
	abortItems->result = DUL_REJECT_PERMANENT;
	abortItems->source = DUL_ULSU_REJECT;
	abortItems->reason = DUL_ULSU_REJ_UNREC_CALLED_TITLE;
    }
    return rtnCond;
}

/* checkApplicationConnection
**
** Purpose:
**
**
** Parameter Dictionary:
**	params		Service parameters describing the Association
**	forgive		Decides whether to return a warning or a failure status
**	abortItems	Structure specifying reasons for aborting the
**			Association
**
** Return Values:
**
**	APP_NORMAL
**
** Notes:
**
** Algorithm:
**	Description of the algorithm (optional) and any other notes.
*/

static CONDITION
checkApplicationConnection(char *node, DUL_ASSOCIATESERVICEPARAMETERS * params,
     CTNBOOLEAN forgive, DMAN_HANDLE ** handle, DUL_ABORTITEMS * abortItems)
{
    CONDITION
    cond,
    rtnCond = APP_NORMAL;
    CTNBOOLEAN
	accessFlag;

    cond = DMAN_ApplicationAccess(handle, params->callingAPTitle,
				  params->calledAPTitle, &accessFlag);
    if ((cond != DMAN_NORMAL) || !accessFlag) {
	rtnCond = COND_PushCondition(APP_ILLEGALSERVICEPARAMETER,
				   APP_Message(APP_ILLEGALSERVICEPARAMETER),
				"Calling AE Title", params->callingAPTitle);
    }
    if (rtnCond != APP_NORMAL) {
	abortItems->result = DUL_REJECT_PERMANENT;
	abortItems->source = DUL_ULSU_REJECT;
	abortItems->reason = DUL_ULSU_REJ_UNREC_CALLED_TITLE;
    }
    return rtnCond;
}
