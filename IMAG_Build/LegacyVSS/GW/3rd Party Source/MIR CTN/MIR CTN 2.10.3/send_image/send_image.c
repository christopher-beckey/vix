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
** @$ = @$ = @$ =
*/
/*
**				DICOM 93
**		     Electronic Radiology Laboratory
**		   Mallinckrodt Institute of Radiology
**		Washington University School of Medicine
**
** Module Name(s):	main
**			usageerror
**			myExit
**			sendImage
**			sendImageSet
**			sendCallback
**			requestAssociation
** Author, Date:	Stephen M. Moore, 6-May-93
** Intent:		This program is an example and test program which
**			demonstrates the DICOM packages developed at MIR.
**			It establishes an Association with a server and sends
**			one or more images to the server.
**
** Last Update:		$Author: Vhaiswstarkm $, $Date: 11/04/10 9:20a $
** Source File:		$RCSfile: send_image.c,v $
** Revision:		$Revision: 1 $
** Status:		$State: Exp $
*/

static char rcsid[] = "$Revision: 1 $ $RCSfile: send_image.c,v $";

#include <stdio.h>
#include <string.h>
#include <stdlib.h>
#ifdef _MSC_VER
#include <io.h>
#include <fcntl.h>
#include <winsock.h>
#else
#include <sys/file.h>
#endif
#include <sys/types.h>
#include <sys/stat.h>

#include "dicom.h"
#include "ctnthread.h"
#include "dicom_uids.h"
#include "lst.h"
#include "condition.h"
#include "dulprotocol.h"
#include "dicom_objects.h"
#include "dicom_messages.h"
#include "dicom_services.h"
#include "utility.h"

static void usageerror();
static void myExit(DUL_ASSOCIATIONKEY ** association);
static void
sendImageSet(int argc, char **argv, DUL_NETWORKKEY ** network,
	  DUL_ASSOCIATESERVICEPARAMETERS * params, char *SOPName, int limit,
	     CTNBOOLEAN trimPixels, CTNBOOLEAN timeTransfer);
static CONDITION
sendImage(DUL_ASSOCIATIONKEY ** association,
	  DUL_ASSOCIATESERVICEPARAMETERS * params,
	  DCM_OBJECT ** object, char *SOPClass, char *instanceUID,
	  char *moveAETitle);
static int
requestAssociation(DUL_NETWORKKEY ** network,
		   DUL_ASSOCIATIONKEY ** association,
		   DUL_ASSOCIATESERVICEPARAMETERS * params,
		   char *SOPClass);
static CONDITION
sendCallback(MSG_C_STORE_REQ * request, MSG_C_STORE_RESP * response,
	     unsigned long transmitted, unsigned long total,
	     void *string);
static CTNBOOLEAN responseSensitive = FALSE;
static CTNBOOLEAN silent = FALSE;

main(int argc, char **argv)
{
    CONDITION			/* Return values from DUL and ACR routines */
	cond;
    DUL_NETWORKKEY		/* Used to initialize our network */
	* network = NULL;
    DUL_ASSOCIATESERVICEPARAMETERS	/* The items which describe this
					 * Association */
	params = {
	DICOM_STDAPPLICATIONCONTEXT, "DICOM_TEST", "DICOM_STORAGE",
	    "", 16384, 0, 0, 0,
	    "calling addr", "called addr", NULL, NULL, 0, 0,
	    MIR_IMPLEMENTATIONCLASSUID, MIR_IMPLEMENTATIONVERSIONNAME,
	    "", ""
    };
    char
       *calledAPTitle = "DICOM_STORAGE",
       *callingAPTitle = "DICOM_TEST",
        localHost[40],
       *node,			/* The node we are calling */
       *port,			/* ASCIIZ representation of TCP port */
       *SOPName = NULL;
    int
        scratch;		/* Used to check syntax of port number */
    unsigned long
        maxPDU = 16384;

    CTNBOOLEAN
	verboseDCM = FALSE,
	verboseDUL = FALSE,
	verboseSRV = FALSE,
	trimPixelData = FALSE,
	timeTransfer = FALSE;

    int limit = 1000 * 1000;	/* Limit on number of images to send */

    while (--argc > 0 && (*++argv)[0] == '-') {
	switch (*(argv[0] + 1)) {
	case 'a':
	    argc--;
	    argv++;
	    if (argc <= 0)
		usageerror();
	    callingAPTitle = *argv;
	    break;
	case 'c':
	    argc--;
	    argv++;
	    if (argc <= 0)
		usageerror();
	    calledAPTitle = *argv;
	    break;
	case 'l':
	    argc--;
	    argv++;
	    if (argc <= 0)
		usageerror();
	    if (sscanf(*argv, "%d", &limit) != 1)
		usageerror();
	    break;
	case 'm':
	    argc--;
	    argv++;
	    if (argc <= 0)
		usageerror();
	    if (sscanf(*argv, "%lu", &maxPDU) != 1)
		usageerror();
	    break;
	case 'p':
	    trimPixelData = TRUE;
	    break;
	case 'q':
	    silent = TRUE;
	    break;
	case 'r':
	    responseSensitive = TRUE;
	    break;
	case 's':
	    argc--;
	    argv++;
	    if (argc <= 0)
		usageerror();
	    SOPName = *argv;
	    break;
	case 't':
	    timeTransfer = TRUE;
	    break;
	case 'v':
	    verboseDUL = TRUE;
	    verboseSRV = TRUE;
	    break;
	case 'x':
	    argc--;
	    argv++;
	    if (argc <= 0)
		usageerror();
	    if (strcmp(*argv, "DCM") == 0)
		verboseDCM = TRUE;
	    else if (strcmp(*argv, "DUL") == 0)
		verboseDUL = TRUE;
	    else if (strcmp(*argv, "SRV") == 0)
		verboseSRV = TRUE;
	    else
		usageerror();
	    break;
	default:
	    break;
	}
    }
    if (argc < 3)
	usageerror();

    node = *argv++;
    argc--;
    port = *argv++;
    argc--;
    if (sscanf(port, "%d", &scratch) != 1)
	usageerror();

    THR_Init();
    DCM_Debug(verboseDCM);
    DUL_Debug(verboseDUL);
    SRV_Debug(verboseSRV);

    cond = DUL_InitializeNetwork(DUL_NETWORK_TCP, DUL_AEREQUESTOR,
			   NULL, DUL_TIMEOUT, DUL_ORDERBIGENDIAN, &network);
    if (cond != DUL_NORMAL)
	myExit(NULL);

    (void) gethostname(localHost, sizeof(localHost));
    sprintf(params.calledPresentationAddress, "%s:%s", node, port);
    strcpy(params.callingPresentationAddress, localHost);
    strcpy(params.calledAPTitle, calledAPTitle);
    strcpy(params.callingAPTitle, callingAPTitle);
    params.maxPDU = maxPDU;

    sendImageSet(argc, argv, &network, &params, SOPName, limit, trimPixelData,
		 timeTransfer);
    THR_Shutdown();
    return 0;
}

static void
replacePixels(DCM_OBJECT ** iod)
{
    static U32 pixel = 0;
    DCM_ELEMENT e = {DCM_PXLPIXELDATA, DCM_OB, "", 1, sizeof(pixel),
    (void *) &pixel};

    DCM_RemoveElement(iod, DCM_PXLPIXELDATA);
    DCM_AddElement(iod, &e);
}

/* sendImageSet
**
** Purpose:
**	Send a set of images to the destination
**
** Parameter Dictionary:
**	argc		Number of command line arguments
**	argv		Actual arguments
**	network		Key to the network connection
**	params		Service parameters describing the Association
**	SOPName		SOP Class ID of the image to be sent
**
** Return Values:
**	None
**
** Algorithm:
**	Description of the algorithm (optional) and any other notes.
*/

static void
sendImageSet(int argc, char **argv, DUL_NETWORKKEY ** network,
	     DUL_ASSOCIATESERVICEPARAMETERS * params, char *SOPName,
	     int limit, CTNBOOLEAN trimPixels, CTNBOOLEAN timeTransfer)
{
    DUL_ASSOCIATIONKEY		/* Describes the Association with the
				 * Acceptor */
    * association = NULL;
    static char
        SOPClass[DICOM_UI_LENGTH + 1] = "",
        lastSOPClass[DICOM_UI_LENGTH + 1] = "";
    CONDITION
	cond;
    DCM_OBJECT *iod;
    static char
        instanceUID[DICOM_UI_LENGTH + 1] = "";
    DCM_ELEMENT elements[] = {
	{DCM_IDSOPCLASSUID, DCM_UI, "", 1, sizeof(SOPClass),
	(void *) SOPClass},
	{DCM_IDSOPINSTANCEUID, DCM_UI, "", 1, sizeof(instanceUID),
	(void *) instanceUID}
    };
    CTNBOOLEAN part10File;
    void *timeStamp = NULL;
    unsigned long objectLength = 0;
    double deltaTime = 0.;

    if (limit < argc)
	argc = limit;

    while (argc-- > 0) {
	if (timeTransfer) {
	    timeStamp = UTL_GetTimeStamp();
	}
	part10File = FALSE;
	cond = DCM_OpenFile(*argv, DCM_ORDERLITTLEENDIAN, &iod);
	if (cond != DCM_NORMAL) {
	    part10File = TRUE;
	    cond = DCM_OpenFile(*argv, DCM_ORDERLITTLEENDIAN | DCM_PART10FILE, &iod);
	    if (cond != DCM_NORMAL)
		myExit(&association);
	}
	(void) COND_PopCondition(TRUE);
	argv++;

	cond = DCM_ParseObject(&iod, elements, DIM_OF(elements), NULL, 0, NULL);
	if (cond != DCM_NORMAL)
	    myExit(&association);

	if (strcmp(SOPClass, lastSOPClass) != 0) {
	    if (strlen(lastSOPClass) != 0) {
		(void) DUL_ReleaseAssociation(&association);
		(void) DUL_DropAssociation(&association);
	    }
	    (void) DUL_ClearServiceParameters(params);
	    if (requestAssociation(network, &association, params, SOPClass) == 0) {
		myExit(NULL);
	    }
	}
	if (part10File) {
	    cond = DCM_RemoveGroup(&iod, DCM_GROUPFILEMETA);
	    if (cond != DCM_NORMAL)
		myExit(&association);
	    (void) DCM_RemoveGroup(&iod, DCM_GROUPPAD);
	    (void) COND_PopCondition(TRUE);
	}
	if (trimPixels)
	    replacePixels(&iod);
	if (timeTransfer) {
	    (void) DCM_GetObjectSize(&iod, &objectLength);
	}
	cond = sendImage(&association, params, &iod, SOPClass,
			 instanceUID, "");
	if (cond != SRV_NORMAL)
	    myExit(&association);

	strcpy(lastSOPClass, SOPClass);
	(void) DCM_CloseObject(&iod);
	if (timeTransfer) {
	    deltaTime = UTL_DeltaTime(timeStamp);
	    printf("%10d bytes transfer in %7.3f seconds (%f kB/s)\n",
		   objectLength, deltaTime,
		   (((float) objectLength) / 1000.) / deltaTime);
	    UTL_ReleaseTimeStamp(timeStamp);
	}
    }

    (void) DUL_ReleaseAssociation(&association);
    (void) DUL_DropAssociation(&association);
    (void) DUL_ClearServiceParameters(params);
    (void) DUL_DropNetwork(network);
}


/* sendImage
**
** Purpose:
**	Send a single image over the Association
**
** Parameter Dictionary:
**	assocition		Handle to the Association
**	params			Service parameters describing the Association
**	object			Handle to the DICOM object holding the image
**	SOPClass		SOP Class UID
**	instanceUID		SOP Instance UID of the image
**	moveAETitle		Name of the Application Entity
**
** Return Values:
**
**	SRV_ILLEGALPARAMETER
**	SRV_NOCALLBACK
**	SRV_NORMAL
**	SRV_NOSERVICEINASSOCIATION
**	SRV_OBJECTBUILDFAILED
**	SRV_REQUESTFAILED
**	SRV_UNEXPECTEDCOMMAND
**
** Algorithm:
**	Description of the algorithm (optional) and any other notes.
*/

static CONDITION
sendImage(DUL_ASSOCIATIONKEY ** association,
	  DUL_ASSOCIATESERVICEPARAMETERS * params,
	  DCM_OBJECT ** object, char *SOPClass, char *instanceUID,
	  char *moveAETitle)
{
    MSG_C_STORE_REQ
    request;
    MSG_C_STORE_RESP
	response;
    CONDITION
	cond;

    request.type = MSG_K_C_STORE_REQ;
    request.messageID = SRV_MessageIDOut();
    request.priority = 0;
    request.dataSetType = DCM_CMDDATAIMAGE;
    request.dataSet = *object;
    request.fileName = NULL;
    strcpy(request.classUID, SOPClass);
    strcpy(request.instanceUID, instanceUID);
    strcpy(request.moveAETitle, moveAETitle);

    cond = SRV_CStoreRequest(association, params, &request, &response,
			     sendCallback, "context string", "");
    MSG_DumpMessage(&response, stdout);

    if (responseSensitive && response.status != MSG_K_SUCCESS)
	cond = 0;

    return cond;
}


/* sendCallback
**
** Purpose:
**	Callback routine
**
** Parameter Dictionary:
**	request		Pointer to request message
**	response	Pointer to response message
**	transmitted	Number of bytes sent
**	total		Total number of bytes sent
**	string		Context Information
**
** Return Values:
**	SRV_NORMAL
**
** Algorithm:
**	Description of the algorithm (optional) and any other notes.
*/
static CONDITION
sendCallback(MSG_C_STORE_REQ * request, MSG_C_STORE_RESP * response,
	     unsigned long transmitted, unsigned long total,
	     void *string)
{
    if (transmitted == 0 && !silent)
	printf("Initial call to sendCallback\n");

    if (!silent)
	printf("%8d bytes transmitted of %8d (%s)\n", transmitted, total, (char *) string);

    if (response != NULL && !silent)
	MSG_DumpMessage(response, stdout);

    return SRV_NORMAL;
}

/* usageerror
**
** Purpose:
**	Print the usage message for this program and exit.
**
** Parameter Dictionary:
**	None
**
** Return Values:
**	None
**
** Algorithm:
**	Description of the algorithm (optional) and any other notes.
*/

static void
usageerror()
{
    char msg[] = "\
send_image [-a application] [-c called] [-m maxPDU] [-p] [-q] [-r] [-s SOPName] [-t] [-x FAC] [-v] node port image [image...]\n\
    \n\
    -a    Set application title of this (calling) application\n\
    -c    Set called AE title to title in Association RQ\n\
    -m    Set maximum PDU in Association RQ to maxPDU\n\
    -p    Alter image by sending minimal pixel data\n\
    -q    Quiet mode.  Suppresses some messages to stdout\n\
    -r    Make program sensitve to response status.  If not success, stop\n\
    -s    Force an initial Association using one SOP Class based on SOPName\n\
          (CR, CT, MR, NM, SC, US)\n\
    -t    Time the image transfer.  Print elapsed time and transfer rate.\n\
    -v    Place DUL and SRV facilities in verbose mode\n\
    -x    Place one facility(DCM, DUL, SRV) in verbose mode\n\
    \n\
    node  Node name for network connection\n\
    port  TCP / IP port number of server application\n\
    image A list of one or more images to send\n";

    fprintf(stderr, msg);
    exit(1);
}


/* myExit
**
** Purpose:
**	Exit routines which closes network connections, dumps error
**	messages and exits.
**
** Parameter Dictionary:
**	association	A handle for an association which is possibly open.
**
** Return Values:
**	None
**
** Algorithm:
**	Description of the algorithm (optional) and any other notes.
*/

static void
myExit(DUL_ASSOCIATIONKEY ** association)
{
    fprintf(stderr, "Abnormal exit\n");
    COND_DumpConditions();

    if (association != NULL)
	if (*association != NULL)
	    (void) DUL_DropAssociation(association);
    THR_Shutdown();
    exit(1);
}



/* requestAssociation
**
** Purpose:
**	Request for a Association establishment
**
** Parameter Dictionary:
**	network		Key to the network connection
**	association	Handle to the Association (to be returned)
**	params		Service parameters describing the Association
**	SOPClass	SOPClass for which the service is to be requested
**
** Return Values:
**	1 => success
**	0 => failure
**
** Algorithm:
**	Description of the algorithm (optional) and any other notes.
*/

static int
requestAssociation(DUL_NETWORKKEY ** network,
		   DUL_ASSOCIATIONKEY ** association,
		   DUL_ASSOCIATESERVICEPARAMETERS * params, char *SOPClass)
{
    CONDITION
    cond;

    cond = SRV_RequestServiceClass(SOPClass, DUL_SC_ROLE_SCU, params);
    if (cond != SRV_NORMAL) {
	COND_DumpConditions();
	return 0;
    }
    cond = DUL_RequestAssociation(network, params, association);
    if (cond != DUL_NORMAL) {
	if (cond == DUL_ASSOCIATIONREJECTED) {
	    fprintf(stderr, "Association Rejected\n");
	    fprintf(stderr, " Result: %2x Source %2x Reason %2x\n",
		    params->result, params->resultSource,
		    params->diagnostic);
	}
	return 0;
    }
    if (!silent) {
	(void) printf("Association accepted, parameters:\n");
	DUL_DumpParams(params);
    }
    return 1;
}
