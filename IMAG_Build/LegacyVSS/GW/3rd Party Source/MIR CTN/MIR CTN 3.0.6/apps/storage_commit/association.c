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
** Author, Date:	Stephen Moore, 13-Feb-97
** Intent:
** Last Update:		$Author: Vhaiswstarkm $, $Date: 11/04/10 9:26a $
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
#include "iap.h"

#include "storage_commit.h"

extern CTNBOOLEAN silent;
extern CTNBOOLEAN verboseDUL;
extern char *controlDatabase;

typedef struct {
    char *levelChar;
    int levelInt;
}   QUERY_MAP;

typedef struct {
    void *reserved[2];
    IDB_Query query;
}   QUERY_LIST_ITEM;


/* establishAssociation
**
** Purpose:
**	Request for the specific service class and then establish an
**	Association
**
** Parameter Dictionary:
**	networkKey		Key describing the network connection
**	queryList		Handle to list of queries
**	moveDestination		Name of destination where images are to be moved
**	sendAssociation		Key describing the Association
**	params			Service parameters describing the Association
**
** Return Values:
**	DUL_NORMAL	on success
**
** Notes:
**
** Algorithm:
**	Description of the algorithm (optional) and any other notes.
*/
CONDITION
establishAssociation(DUL_NETWORKKEY ** networkKey,
		     char *destination,
		     DMAN_HANDLE ** handle,
		     DUL_ASSOCIATIONKEY ** sendAssociation,
		     DUL_ASSOCIATESERVICEPARAMETERS * params)
{
    CONDITION cond;
    DMAN_APPLICATIONENTITY ae;
    DMAN_APPLICATIONENTITY criteria;
    long count;

    memset(&criteria, 0, sizeof(criteria));
    criteria.Type = ae.Type = DMAN_K_APPLICATIONENTITY;
    criteria.Flag = DMAN_K_APPLICATION_TITLE;
    strcpy(criteria.Title, destination);
    cond = DMAN_Select(handle, (DMAN_GENERICRECORD *) & ae,
	       (DMAN_GENERICRECORD *) & criteria, NULL, NULL, &count, NULL);
    if (cond != DMAN_NORMAL)
	return 0;
    if (count != 1)
	return 0;

    sprintf(params->calledPresentationAddress, "%s:%-d", ae.Node, ae.Port);

    cond = SRV_RequestServiceClass(DICOM_SOPCLASSSTORAGECOMMITMENTPUSHMODEL,
				   DUL_SC_ROLE_DEFAULT, params);
    if (CTN_INFORM(cond))
	(void) COND_PopCondition(FALSE);
    else if (cond != SRV_NORMAL)
	return 0;		/* repair */

    cond = DUL_RequestAssociation(networkKey, params, sendAssociation);
    if (cond != DUL_NORMAL) {
	printf("Could not establish Association with %s %s %s\n",
	       params->callingAPTitle,
	       params->calledAPTitle,
	       params->calledPresentationAddress);
	COND_DumpConditions();
	return 0;		/* repair */
    }
    return APP_NORMAL;
}

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
static CONDITION
checkOrganizationCount(char *node, DUL_ASSOCIATESERVICEPARAMETERS * params,
    CTNBOOLEAN forgive, DMAN_HANDLE ** handle, DUL_ABORTITEMS * abortItems);


typedef struct {
    char *SOPClassUID;
    int accessRights;
}   ACCESS_MAP;

static ACCESS_MAP map[] = {
    {DICOM_SOPCLASSVERIFICATION, 0},
    {DICOM_SOPCLASSSTORAGECOMMITMENTPUSHMODEL, ACCESS_WRITE}
};

CONDITION
nextAssociationRequest(char *node, DUL_NETWORKKEY ** network,
	     DUL_ASSOCIATESERVICEPARAMETERS * service, unsigned long maxPDU,
		  CTNBOOLEAN forgiveFlag, DUL_ASSOCIATIONKEY ** association,
		       PROCESS_ELEMENT * processElement)
{
    CTNBOOLEAN
	drop,
	acceptFlag,
	acceptPresentationContext,
	readAccess = FALSE,
	writeAccess = FALSE;
    CONDITION
	cond,
	rtnCond = APP_NORMAL;
    DUL_PRESENTATIONCONTEXT
	* requestedCtx;
    int
        classCount;
    DUL_SC_ROLE
	scRole;
    DUL_ABORTITEMS
	abortItems;
    DMAN_HANDLE
	* manageHandle;
    DMAN_APPLICATIONENTITY ae;

    cond = DMAN_Open(controlDatabase, "", "", &manageHandle);
    if (cond != DMAN_NORMAL) {
	rtnCond = COND_PushCondition(APP_ERROR(APP_ASSOCIATIONRQFAILED));
	goto Exit;
    }
    (void) memset(service, 0, sizeof(*service));
    service->maxPDU = maxPDU;
    strcpy(service->calledImplementationClassUID,
	   MIR_IMPLEMENTATIONCLASSUID);
    strcpy(service->calledImplementationVersionName,
	   MIR_IMPLEMENTATIONVERSIONNAME);
    cond = DUL_ReceiveAssociationRQ(network, DUL_BLOCK,
				    service, association);
    if (cond != DUL_NORMAL) {
	rtnCond = COND_PushCondition(APP_ERROR(APP_ASSOCIATIONRQFAILED));
	goto Exit;
    }
    acceptFlag = TRUE;
    drop = FALSE;
    memset(processElement, 0, sizeof(*processElement));
    strcpy(processElement->callingAPTitle, service->callingAPTitle);
    strcpy(processElement->calledAPTitle, service->calledAPTitle);
    cond = DMAN_LookupApplication(&manageHandle, service->callingAPTitle, &ae);
    if (cond == DMAN_NORMAL && (ae.Flag & DMAN_K_APPLICATION_ORGANIZATION))
	strcpy(processElement->organization, ae.Organization);

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
	if (acceptFlag) {
	    cond = DMAN_StorageAccess(&manageHandle, service->callingAPTitle,
			 service->calledAPTitle, &readAccess, &writeAccess);
	    if (cond != DMAN_NORMAL) {
		readAccess = writeAccess = FALSE;
		COND_DumpConditions();
	    }
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
	    ACCESS_MAP *p;
	    int i,
	        grantedAccess;

	    acceptPresentationContext = FALSE;
	    for (p = map, i = 0; i < DIM_OF(map) && !acceptPresentationContext; i++) {
		if (strcmp(p->SOPClassUID, requestedCtx->abstractSyntax) == 0)
		    acceptPresentationContext = TRUE;
		else
		    p++;
	    }
	    if (acceptPresentationContext) {
		if ((p->accessRights & ACCESS_WRITE)) {
		    if (!writeAccess)
			acceptPresentationContext = FALSE;
		}
		if ((p->accessRights & ACCESS_READ)) {
		    if (!readAccess)
			acceptPresentationContext = FALSE;
		}
	    }
	    if (acceptPresentationContext) {
		switch (requestedCtx->proposedSCRole) {
		case DUL_SC_ROLE_DEFAULT:
		    scRole = DUL_SC_ROLE_DEFAULT;
		    break;
		case DUL_SC_ROLE_SCU:
		    acceptPresentationContext = FALSE;
		    break;
		case DUL_SC_ROLE_SCP:
		    scRole = DUL_SC_ROLE_SCP;
		    break;
		case DUL_SC_ROLE_SCUSCP:
		    scRole = DUL_SC_ROLE_SCUSCP;
		    break;
		default:
		    acceptPresentationContext = FALSE;
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
		if (!silent)
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
	if (!silent)
	    printf("Supported classes: %d\n", classCount);

	if (drop) {
	    (void) DUL_DropAssociation(association);
	    rtnCond = COND_PushCondition(APP_ERROR(APP_ASSOCIATIONRQFAILED));
	} else {
/*	    The acknowledgment is done by the person who called this function.
**	    We don't do it here any more.
*/
	}
    }
Exit:
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
