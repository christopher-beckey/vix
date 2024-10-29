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
** Module Name(s):
**	private modules
** Author, Date:	Stephen M. Moore, 15-Apr-93
** Intent:		This module contains general routines which are used
**			in our implementation of service classes.  These
**			routines allow users to request and accept service
**			classes, build and manipulate the public DUL
**			structures, send and receive messages, and request
**			unique Message IDs.
** Last Update:		$Author: Vhaiswstarkm $, $Date: 11/04/10 9:07a $
** Source File:		$RCSfile: cmd_valid.c,v $
** Revision:		$Revision: 1 $
** Status:		$State: Exp $
*/

static char rcsid[] = "$Revision: 1 $ $RCSfile: cmd_valid.c,v $";

#include <stdio.h>
#include <string.h>
#include <errno.h>
#include <stdlib.h>
#include <stdarg.h>
#include <sys/types.h>
#ifdef _MSC_VER
#else
#include <sys/file.h>
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
#include "private.h"

#define FRAGMENTMAX 65536

typedef unsigned long SRVPERMITTED;

typedef struct {
    char classUID[DICOM_UI_LENGTH + 1];
    SRVPERMITTED *permittedSrvList;	/* list of permitted services */
    unsigned short permittedSrvListSize;
}   SOPCLASSPERMITTEDSRV;	/* defines the various services permitted for
				 * a given SOP class */

typedef struct {
    void *reserved[2];
    DUL_ASSOCIATIONKEY **association;
    DUL_PRESENTATIONCONTEXTID ctxID;
    unsigned short command;
    MSG_TYPE messageType;
    void *message;
}   COMMAND_ENTRY;


CTNBOOLEAN PRVSRV_debug = 0;
static DUL_PRESENTATIONCONTEXT
*
findPresentationCtx(DUL_ASSOCIATESERVICEPARAMETERS * params,
		    DUL_PRESENTATIONCONTEXTID ctxid);

/* verification SOP classes */
static SRVPERMITTED verifySOPClass[] = {
    DCM_ECHO_REQUEST,
    DCM_ECHO_RESPONSE
};
/* Storage SOP classes */
static SRVPERMITTED computedRadiographySOPClass[] = {
    DCM_STORE_REQUEST,
    DCM_STORE_RESPONSE
};
static SRVPERMITTED ctImageStorageSOPClass[] = {
    DCM_STORE_REQUEST,
    DCM_STORE_RESPONSE
};
static SRVPERMITTED usMultiframeImageStorageSOPClass1993[] = {
    DCM_STORE_REQUEST,
    DCM_STORE_RESPONSE
};
static SRVPERMITTED usMultiframeImageStorageSOPClass[] = {
    DCM_STORE_REQUEST,
    DCM_STORE_RESPONSE
};
static SRVPERMITTED mrImageStorageSOPClass[] = {
    DCM_STORE_REQUEST,
    DCM_STORE_RESPONSE
};
static SRVPERMITTED nmImageStorageSOPClass[] = {
    DCM_STORE_REQUEST,
    DCM_STORE_RESPONSE
};
static SRVPERMITTED usImageStorageSOPClass1993[] = {
    DCM_STORE_REQUEST,
    DCM_STORE_RESPONSE
};
static SRVPERMITTED usImageStorageSOPClass[] = {
    DCM_STORE_REQUEST,
    DCM_STORE_RESPONSE
};
static SRVPERMITTED secondaryCaptureImageStorageSOPClass[] = {
    DCM_STORE_REQUEST,
    DCM_STORE_RESPONSE
};
static SRVPERMITTED xrayAngioImageStorageSOPClass[] = {
    DCM_STORE_REQUEST,
    DCM_STORE_RESPONSE
};
static SRVPERMITTED xrayFluoroImageStorageSOPClass[] = {
    DCM_STORE_REQUEST,
    DCM_STORE_RESPONSE
};
static SRVPERMITTED standAloneOverlayStorageSOPClass[] = {
    DCM_STORE_REQUEST,
    DCM_STORE_RESPONSE
};
static SRVPERMITTED standAloneCurveStorageSOPClass[] = {
    DCM_STORE_REQUEST,
    DCM_STORE_RESPONSE
};
static SRVPERMITTED standAloneModalityLUTStorageSOPClass[] = {
    DCM_STORE_REQUEST,
    DCM_STORE_RESPONSE
};
static SRVPERMITTED standAloneVOILUTStorageSOPClass[] = {
    DCM_STORE_REQUEST,
    DCM_STORE_RESPONSE
};

/* Added 14-Jul-1997 by smm to support Supplement 11, RT objects */
static SRVPERMITTED rtImageStorageSOPClass[] = {
    DCM_STORE_REQUEST,
    DCM_STORE_RESPONSE
};
static SRVPERMITTED rtDoseStorageSOPClass[] = {
    DCM_STORE_REQUEST,
    DCM_STORE_RESPONSE
};
static SRVPERMITTED rtStructureSetStorageSOPClass[] = {
    DCM_STORE_REQUEST,
    DCM_STORE_RESPONSE
};
static SRVPERMITTED rtPlanStorageSOPClass[] = {
    DCM_STORE_REQUEST,
    DCM_STORE_RESPONSE
};

/* Added 14-Jul-1997 by smm to support Supplement 12, PET objects */
static SRVPERMITTED petImageStorageSOPClass[] = {
    DCM_STORE_REQUEST,
    DCM_STORE_RESPONSE
};
static SRVPERMITTED petCurveStorageSOPClass[] = {
    DCM_STORE_REQUEST,
    DCM_STORE_RESPONSE
};

static SRVPERMITTED StorageSOPClass[] = {
    DCM_STORE_REQUEST,
    DCM_STORE_RESPONSE
};

/* Query/Retrieve SOP classes */
static SRVPERMITTED patientQueryRetrieveFindSOPClass[] = {
    DCM_FIND_REQUEST,
    DCM_FIND_RESPONSE,
    DCM_CANCEL_REQUEST
};
static SRVPERMITTED patientQueryRetrieveMoveSOPClass[] = {
    DCM_MOVE_REQUEST,
    DCM_MOVE_RESPONSE,
    DCM_CANCEL_REQUEST
};
static SRVPERMITTED patientQueryRetrieveGetSOPClass[] = {
    DCM_GET_REQUEST,
    DCM_GET_RESPONSE,
    DCM_CANCEL_REQUEST
};
static SRVPERMITTED studyQueryRetrieveFindSOPClass[] = {
    DCM_FIND_REQUEST,
    DCM_FIND_RESPONSE,
    DCM_CANCEL_REQUEST
};
static SRVPERMITTED studyQueryRetrieveMoveSOPClass[] = {
    DCM_MOVE_REQUEST,
    DCM_MOVE_RESPONSE,
    DCM_CANCEL_REQUEST
};
static SRVPERMITTED studyQueryRetrieveGetSOPClass[] = {
    DCM_GET_REQUEST,
    DCM_GET_RESPONSE,
    DCM_CANCEL_REQUEST
};
static SRVPERMITTED patientStudyQueryRetrieveFindSOPClass[] = {
    DCM_FIND_REQUEST,
    DCM_FIND_RESPONSE,
    DCM_CANCEL_REQUEST
};
static SRVPERMITTED patientStudyQueryRetrieveMoveSOPClass[] = {
    DCM_MOVE_REQUEST,
    DCM_MOVE_RESPONSE,
    DCM_CANCEL_REQUEST
};
static SRVPERMITTED patientStudyQueryRetrieveGetSOPClass[] = {
    DCM_GET_REQUEST,
    DCM_GET_RESPONSE,
    DCM_CANCEL_REQUEST
};
/* Notification Service classes */
static SRVPERMITTED basicStudyContentNotificationSOPClass[] = {
    DCM_STORE_REQUEST,
    DCM_STORE_RESPONSE
};
/* Patient Management Service SOP classes */
static SRVPERMITTED detachedPatientManagementSOPClass[] = {
    DCM_N_EVENT_REPORT_REQUEST,
    DCM_N_EVENT_REPORT_RESPONSE,
    DCM_N_GET_REQUEST,
    DCM_N_GET_RESPONSE
};
static SRVPERMITTED detachedVisitManagementSOPClass[] = {
    DCM_N_EVENT_REPORT_REQUEST,
    DCM_N_EVENT_REPORT_RESPONSE,
    DCM_N_GET_REQUEST,
    DCM_N_GET_RESPONSE,
    DCM_N_SET_REQUEST,
    DCM_N_SET_RESPONSE
};
static SRVPERMITTED detachedPatientManagementMetaSOPClass[] = {
    DCM_N_EVENT_REPORT_REQUEST,
    DCM_N_EVENT_REPORT_RESPONSE,
    DCM_N_GET_REQUEST,
    DCM_N_GET_RESPONSE,
    DCM_N_SET_REQUEST,
    DCM_N_SET_RESPONSE
};
/* Study Management Service SOP classes */
static SRVPERMITTED detachedStudyManagementSOPClass[] = {
    DCM_N_EVENT_REPORT_REQUEST,
    DCM_N_EVENT_REPORT_RESPONSE,
    DCM_N_GET_REQUEST,
    DCM_N_GET_RESPONSE,
    DCM_N_SET_REQUEST,
    DCM_N_SET_RESPONSE
};
static SRVPERMITTED studyComponentManagementSOPClass[] = {
    DCM_N_CREATE_REQUEST,
    DCM_N_CREATE_RESPONSE,
    DCM_N_GET_REQUEST,
    DCM_N_GET_RESPONSE,
    DCM_N_SET_REQUEST,
    DCM_N_SET_RESPONSE
};
static SRVPERMITTED studyManagementMetaSOPClass[] = {
    DCM_N_EVENT_REPORT_REQUEST,
    DCM_N_EVENT_REPORT_RESPONSE,
    DCM_N_CREATE_REQUEST,
    DCM_N_CREATE_RESPONSE,
    DCM_N_GET_REQUEST,
    DCM_N_GET_RESPONSE,
    DCM_N_SET_REQUEST,
    DCM_N_SET_RESPONSE
};
/* Results Management Service SOP classes */
static SRVPERMITTED detachedResultsManagementSOPClass[] = {
    DCM_N_EVENT_REPORT_REQUEST,
    DCM_N_EVENT_REPORT_RESPONSE,
    DCM_N_GET_REQUEST,
    DCM_N_GET_RESPONSE
};
static SRVPERMITTED detachedInterpretationManagementSOPClass[] = {
    DCM_N_EVENT_REPORT_REQUEST,
    DCM_N_EVENT_REPORT_RESPONSE,
    DCM_N_GET_REQUEST,
    DCM_N_GET_RESPONSE,
    DCM_N_SET_REQUEST,
    DCM_N_SET_RESPONSE
};
static SRVPERMITTED detachedResultsManagementMetaSOPClass[] = {
    DCM_N_EVENT_REPORT_REQUEST,
    DCM_N_EVENT_REPORT_RESPONSE,
    DCM_N_GET_REQUEST,
    DCM_N_GET_RESPONSE,
    DCM_N_SET_REQUEST,
    DCM_N_SET_RESPONSE
};
/* Print Management Service SOP Classes */
static SRVPERMITTED basicGreyscalePrintManagementMetaSOPClass[] = {
    DCM_N_CREATE_REQUEST,
    DCM_N_CREATE_RESPONSE,
    DCM_N_GET_REQUEST,
    DCM_N_GET_RESPONSE,
    DCM_N_SET_REQUEST,
    DCM_N_SET_RESPONSE,
    DCM_N_EVENT_REPORT_REQUEST,
    DCM_N_EVENT_REPORT_RESPONSE,
    DCM_N_ACTION_REQUEST,
    DCM_N_ACTION_RESPONSE,
    DCM_N_DELETE_REQUEST,
    DCM_N_DELETE_RESPONSE
};
static SRVPERMITTED basicColorPrintManagementMetaSOPClass[] = {
    DCM_N_CREATE_REQUEST,
    DCM_N_CREATE_RESPONSE,
    DCM_N_GET_REQUEST,
    DCM_N_GET_RESPONSE,
    DCM_N_SET_REQUEST,
    DCM_N_SET_RESPONSE,
    DCM_N_EVENT_REPORT_REQUEST,
    DCM_N_EVENT_REPORT_RESPONSE,
    DCM_N_ACTION_REQUEST,
    DCM_N_ACTION_RESPONSE,
    DCM_N_DELETE_REQUEST,
    DCM_N_DELETE_RESPONSE
};
static SRVPERMITTED referencedGreyscalePrintManagementMetaSOPClass[] = {
    DCM_N_CREATE_REQUEST,
    DCM_N_CREATE_RESPONSE,
    DCM_N_GET_REQUEST,
    DCM_N_GET_RESPONSE,
    DCM_N_SET_REQUEST,
    DCM_N_SET_RESPONSE,
    DCM_N_EVENT_REPORT_REQUEST,
    DCM_N_EVENT_REPORT_RESPONSE,
    DCM_N_ACTION_REQUEST,
    DCM_N_ACTION_RESPONSE,
    DCM_N_DELETE_REQUEST,
    DCM_N_DELETE_RESPONSE
};
static SRVPERMITTED referencedColorPrintManagementMetaSOPClass[] = {
    DCM_N_CREATE_REQUEST,
    DCM_N_CREATE_RESPONSE,
    DCM_N_GET_REQUEST,
    DCM_N_GET_RESPONSE,
    DCM_N_SET_REQUEST,
    DCM_N_SET_RESPONSE,
    DCM_N_EVENT_REPORT_REQUEST,
    DCM_N_EVENT_REPORT_RESPONSE,
    DCM_N_ACTION_REQUEST,
    DCM_N_ACTION_RESPONSE,
    DCM_N_DELETE_REQUEST,
    DCM_N_DELETE_RESPONSE
};
static SRVPERMITTED basicFilmSessionSOPClass[] = {
    DCM_N_CREATE_REQUEST,
    DCM_N_CREATE_RESPONSE,
    DCM_N_SET_REQUEST,
    DCM_N_SET_RESPONSE,
    DCM_N_ACTION_REQUEST,
    DCM_N_ACTION_RESPONSE,
    DCM_N_DELETE_REQUEST,
    DCM_N_DELETE_RESPONSE
};
static SRVPERMITTED basicFilmBoxSOPClass[] = {
    DCM_N_CREATE_REQUEST,
    DCM_N_CREATE_RESPONSE,
    DCM_N_SET_REQUEST,
    DCM_N_SET_RESPONSE,
    DCM_N_ACTION_REQUEST,
    DCM_N_ACTION_RESPONSE,
    DCM_N_DELETE_REQUEST,
    DCM_N_DELETE_RESPONSE
};
static SRVPERMITTED basicGreyscaleImageBoxSOPClass[] = {
    DCM_N_SET_REQUEST,
    DCM_N_SET_RESPONSE
};
static SRVPERMITTED basicColorImageBoxSOPClass[] = {
    DCM_N_SET_REQUEST,
    DCM_N_SET_RESPONSE
};
static SRVPERMITTED referencedImageBoxSOPClass[] = {
    DCM_N_SET_REQUEST,
    DCM_N_SET_RESPONSE
};
static SRVPERMITTED basicAnnotationBoxSOPClass[] = {
    DCM_N_SET_REQUEST,
    DCM_N_SET_RESPONSE
};
static SRVPERMITTED printJobSOPClass[] = {
    DCM_N_EVENT_REPORT_REQUEST,
    DCM_N_EVENT_REPORT_RESPONSE,
    DCM_N_GET_REQUEST,
    DCM_N_GET_RESPONSE
};
static SRVPERMITTED printerSOPClass[] = {
    DCM_N_EVENT_REPORT_REQUEST,
    DCM_N_EVENT_REPORT_RESPONSE,
    DCM_N_GET_REQUEST,
    DCM_N_GET_RESPONSE
};
static SRVPERMITTED basicVOILUTSOPClass[] = {
    DCM_N_CREATE_REQUEST,
    DCM_N_CREATE_RESPONSE,
    DCM_N_SET_REQUEST,
    DCM_N_SET_RESPONSE,
    DCM_N_DELETE_REQUEST,
    DCM_N_DELETE_RESPONSE
};
static SRVPERMITTED imageOverlayBoxSOPClass[] = {
    DCM_N_CREATE_REQUEST,
    DCM_N_CREATE_RESPONSE,
    DCM_N_SET_REQUEST,
    DCM_N_SET_RESPONSE,
    DCM_N_DELETE_REQUEST,
    DCM_N_DELETE_RESPONSE
};

static SRVPERMITTED storageCommitmentPushModelClass[] = {
    DCM_N_EVENT_REPORT_REQUEST,
    DCM_N_EVENT_REPORT_RESPONSE,
    DCM_N_ACTION_REQUEST,
    DCM_N_ACTION_RESPONSE
};

static SRVPERMITTED modalityWorklistFindSOPClass[] = {
    DCM_FIND_REQUEST,
    DCM_FIND_RESPONSE,
    DCM_CANCEL_REQUEST
};


/* Initialization of the permitted services table for each defined
   SOP class
*/
static SOPCLASSPERMITTEDSRV classPermittedSrvTable[] = {
    /* verification service */
    {DICOM_SOPCLASSVERIFICATION, verifySOPClass, DIM_OF(verifySOPClass)},
    /* storage service */
    {DICOM_SOPCLASSCOMPUTEDRADIOGRAPHY, computedRadiographySOPClass,
    DIM_OF(computedRadiographySOPClass)},
    {DICOM_SOPCLASSCT, ctImageStorageSOPClass, DIM_OF(ctImageStorageSOPClass)},
    {DICOM_SOPCLASSUSMULTIFRAMEIMAGE1993, usMultiframeImageStorageSOPClass1993,
    DIM_OF(usMultiframeImageStorageSOPClass1993)},
    {DICOM_SOPCLASSUSMULTIFRAMEIMAGE, usMultiframeImageStorageSOPClass,
    DIM_OF(usMultiframeImageStorageSOPClass)},
    {DICOM_SOPCLASSMR, mrImageStorageSOPClass, DIM_OF(mrImageStorageSOPClass)},
    {DICOM_SOPCLASSNM, nmImageStorageSOPClass, DIM_OF(nmImageStorageSOPClass)},
    {DICOM_SOPCLASSUS1993, usImageStorageSOPClass1993, DIM_OF(usImageStorageSOPClass1993)},
    {DICOM_SOPCLASSUS, usImageStorageSOPClass, DIM_OF(usImageStorageSOPClass)},
    {DICOM_SOPCLASSSECONDARYCAPTURE, secondaryCaptureImageStorageSOPClass,
    DIM_OF(secondaryCaptureImageStorageSOPClass)},
    {DICOM_SOPCLASSXRAYANGIO, xrayAngioImageStorageSOPClass,
    DIM_OF(xrayAngioImageStorageSOPClass)},
    {DICOM_SOPCLASSXRAYFLUORO, xrayFluoroImageStorageSOPClass,
    DIM_OF(xrayFluoroImageStorageSOPClass)},
    {DICOM_SOPCLASSSTANDALONEOVERLAY, standAloneOverlayStorageSOPClass,
    DIM_OF(standAloneOverlayStorageSOPClass)},
    {DICOM_SOPCLASSSTANDALONECURVE, standAloneCurveStorageSOPClass,
    DIM_OF(standAloneCurveStorageSOPClass)},
    {DICOM_SOPCLASSSTANDALONEMODALITYLUT, standAloneModalityLUTStorageSOPClass,
    DIM_OF(standAloneModalityLUTStorageSOPClass)},
    {DICOM_SOPCLASSSTANDALONEVOILUT, standAloneVOILUTStorageSOPClass,
    DIM_OF(standAloneVOILUTStorageSOPClass)},

    {DICOM_SOPCLASSPET, petImageStorageSOPClass,
    DIM_OF(petImageStorageSOPClass)},
    {DICOM_SOPCLASSSTANDALONEPETCURVE, petCurveStorageSOPClass,
    DIM_OF(petCurveStorageSOPClass)},

    {DICOM_SOPRTIMAGESTORAGE, rtImageStorageSOPClass,
    DIM_OF(rtImageStorageSOPClass)},
    {DICOM_SOPRTDOSESTORAGE, rtDoseStorageSOPClass,
    DIM_OF(rtDoseStorageSOPClass)},
    {DICOM_SOPRTSTRUCTURESETSTORAGE, rtStructureSetStorageSOPClass,
    DIM_OF(rtStructureSetStorageSOPClass)},
    {DICOM_SOPRTPLANSTORAGE, rtPlanStorageSOPClass,
    DIM_OF(rtPlanStorageSOPClass)},

	//	Visible light Sop classes
	//
    {DICOM_SOPCLASSVLENDOSCOPY, StorageSOPClass,
    DIM_OF(StorageSOPClass)},
    {DICOM_SOPCLASSVLMICROSCOPY, StorageSOPClass,
    DIM_OF(StorageSOPClass)},
    {DICOM_SOPCLASSVLSLIDECOORDS, StorageSOPClass,
    DIM_OF(StorageSOPClass)},
    {DICOM_SOPCLASSVLPHOTO, StorageSOPClass,
    DIM_OF(StorageSOPClass)},
	//
	// Digital X-Ray SOP Classes
	//
    {DICOM_SOPCLASSDXPRESENT, StorageSOPClass,
    DIM_OF(StorageSOPClass)},
    {DICOM_SOPCLASSDXPROCESS, StorageSOPClass,
    DIM_OF(StorageSOPClass)},
    {DICOM_SOPCLASSDXMAMMOPRES, StorageSOPClass,
    DIM_OF(StorageSOPClass)},
    {DICOM_SOPCLASSDXMAMMOPROC, StorageSOPClass,
    DIM_OF(StorageSOPClass)},
    {DICOM_SOPCLASSDXORALPRES, StorageSOPClass,
    DIM_OF(StorageSOPClass)},
    {DICOM_SOPCLASSDXORALPROC, StorageSOPClass,
    DIM_OF(StorageSOPClass)},

    /* Query/Retrieve Service */
    {DICOM_SOPPATIENTQUERY_FIND, patientQueryRetrieveFindSOPClass,
    DIM_OF(patientQueryRetrieveFindSOPClass)},
    {DICOM_SOPPATIENTQUERY_MOVE, patientQueryRetrieveMoveSOPClass,
    DIM_OF(patientQueryRetrieveMoveSOPClass)},
    {DICOM_SOPPATIENTQUERY_GET, patientQueryRetrieveGetSOPClass,
    DIM_OF(patientQueryRetrieveGetSOPClass)},
    {DICOM_SOPSTUDYQUERY_FIND, studyQueryRetrieveFindSOPClass,
    DIM_OF(studyQueryRetrieveFindSOPClass)},
    {DICOM_SOPSTUDYQUERY_MOVE, studyQueryRetrieveMoveSOPClass,
    DIM_OF(studyQueryRetrieveMoveSOPClass)},
    {DICOM_SOPSTUDYQUERY_GET, studyQueryRetrieveGetSOPClass,
    DIM_OF(studyQueryRetrieveGetSOPClass)},
    {DICOM_SOPPATIENTSTUDYQUERY_FIND, patientStudyQueryRetrieveFindSOPClass,
    DIM_OF(patientStudyQueryRetrieveFindSOPClass)},
    {DICOM_SOPPATIENTSTUDYQUERY_MOVE, patientStudyQueryRetrieveMoveSOPClass,
    DIM_OF(patientStudyQueryRetrieveMoveSOPClass)},
    {DICOM_SOPPATIENTSTUDYQUERY_GET, patientStudyQueryRetrieveGetSOPClass,
    DIM_OF(patientStudyQueryRetrieveGetSOPClass)},
    /* Notification Service */
    {DICOM_SOPCLASSBASICSTUDYCONTENTNOTIFICATION,
	basicStudyContentNotificationSOPClass,
    DIM_OF(basicStudyContentNotificationSOPClass)},
    /* Patient Management Service */
    {DICOM_SOPCLASSDETACHEDPATIENTMGMT, detachedPatientManagementSOPClass,
    DIM_OF(detachedPatientManagementSOPClass)},
    {DICOM_SOPCLASSDETACHEDVISITMGMT, detachedVisitManagementSOPClass,
    DIM_OF(detachedVisitManagementSOPClass)},
    {DICOM_SOPCLASSDETACHEDPATIENTMGMTMETA,
	detachedPatientManagementMetaSOPClass,
    DIM_OF(detachedPatientManagementMetaSOPClass)},
    /* Study Management Service */
    {DICOM_SOPCLASSDETACHEDSTUDYMGMT, detachedStudyManagementSOPClass,
    DIM_OF(detachedStudyManagementSOPClass)},
    {DICOM_SOPCLASSSTUDYCOMPONENTMGMT, studyComponentManagementSOPClass,
    DIM_OF(studyComponentManagementSOPClass)},
    {DICOM_SOPCLASSDETACHEDSTUDYMGMTMETA, studyManagementMetaSOPClass,
    DIM_OF(studyManagementMetaSOPClass)},
    /* Results Management Services */
    {DICOM_SOPCLASSDETACHEDRESULTSMGMT, detachedResultsManagementSOPClass,
    DIM_OF(detachedResultsManagementSOPClass)},
    {DICOM_SOPCLASSDETACHEDINTERPRETMGMT,
	detachedInterpretationManagementSOPClass,
    DIM_OF(detachedInterpretationManagementSOPClass)},
    {DICOM_SOPCLASSDETACHEDRESULTSMGMTMETA,
	detachedResultsManagementMetaSOPClass,
    DIM_OF(detachedResultsManagementMetaSOPClass)},
    /* Print Management services */
    {DICOM_SOPCLASSGREYSCALEPRINTMGMTMETA,
	basicGreyscalePrintManagementMetaSOPClass,
    DIM_OF(basicGreyscalePrintManagementMetaSOPClass)},
    {DICOM_SOPCLASSCOLORPRINTMGMTMETA,
	basicColorPrintManagementMetaSOPClass,
    DIM_OF(basicColorPrintManagementMetaSOPClass)},
    {DICOM_SOPCLASSREFGREYSCALEPRINTMGMTMETA,
	referencedGreyscalePrintManagementMetaSOPClass,
    DIM_OF(referencedGreyscalePrintManagementMetaSOPClass)},
    {DICOM_SOPCLASSREFCOLORPRINTMGMTMETA,
	referencedColorPrintManagementMetaSOPClass,
    DIM_OF(referencedColorPrintManagementMetaSOPClass)},
    {DICOM_SOPCLASSBASICFILMSESSION, basicFilmSessionSOPClass,
    DIM_OF(basicFilmSessionSOPClass)},
    {DICOM_SOPCLASSBASICFILMBOX, basicFilmBoxSOPClass,
    DIM_OF(basicFilmBoxSOPClass)},
    {DICOM_SOPCLASSBASICGREYSCALEIMAGEBOX, basicGreyscaleImageBoxSOPClass,
    DIM_OF(basicGreyscaleImageBoxSOPClass)},
    {DICOM_SOPCLASSBASICCOLORIMAGEBOX, basicColorImageBoxSOPClass,
    DIM_OF(basicColorImageBoxSOPClass)},
    {DICOM_SOPCLASSREFERENCEDIMAGEBOX, referencedImageBoxSOPClass,
    DIM_OF(referencedImageBoxSOPClass)},
    {DICOM_SOPCLASSBASICANNOTATIONBOX, basicAnnotationBoxSOPClass,
    DIM_OF(basicAnnotationBoxSOPClass)},
    {DICOM_SOPCLASSPRINTJOB, printJobSOPClass, DIM_OF(printJobSOPClass)},
    {DICOM_SOPCLASSPRINTER, printerSOPClass, DIM_OF(printerSOPClass)},
    {DICOM_SOPCLASSVOILUT, basicVOILUTSOPClass, DIM_OF(basicVOILUTSOPClass)},
    {DICOM_SOPCLASSIMAGEOVERLAYBOX, imageOverlayBoxSOPClass,
    DIM_OF(imageOverlayBoxSOPClass)},
    {DICOM_SOPCLASSSTORAGECOMMITMENTPUSHMODEL, storageCommitmentPushModelClass,
    DIM_OF(storageCommitmentPushModelClass)},
    {DICOM_SOPMODALITYWORKLIST_FIND, modalityWorklistFindSOPClass,
    DIM_OF(modalityWorklistFindSOPClass)}
};

/* verifyCommandValidity
**
** Purpose:
**	Verify if the command is valid for the proposed abstract syntax
**
** Parameter Dictionary:
**	params		The association service parameters which contain the
**			list of all the abstract syntaxes accepted on
**			the association.
**	ctxid		The context id which determines the current abstract
**			syntax for which the command is received
**	command		The DICOM normalized/composite service being requested
**			for the abstract syntax.
**
** Return Values:
**	SRV_NORMAL
**	SRV_UNSUPPORTEDCOMMAND
**
** Notes:
**
** Algorithm:
**	Description of the algorithm (optional) and any other notes.
*/
CONDITION
PRVSRV_verifyCommandValidity(DUL_ASSOCIATESERVICEPARAMETERS * params,
			     DUL_PRESENTATIONCONTEXTID ctxid,
			     unsigned short command)
{

    /*
     * verify if the command is valid for the given abstract syntax i.e. SOP
     * class
     */
    int
        index1,
        index2;
    DUL_PRESENTATIONCONTEXT
	* ctx;

    /*
     * using the ctxid, we first extract the abstract syntax for which the
     * command has been requested.
     */

    ctx = findPresentationCtx(params, ctxid);
    if (ctx == NULL)
	return SRV_UNSUPPORTEDCOMMAND;

    /*
     * From the current presentation context we have obtained, extract the
     * abstract syntax and find the list of valid commands for that abstract
     * syntax and then verify if the requested command is valid or not
     */
    for (index1 = 0; index1 < DIM_OF(classPermittedSrvTable); index1++) {
	if (strcmp(classPermittedSrvTable[index1].classUID,
		   ctx->abstractSyntax) == 0) {	/* they matched */
	    for (index2 = 0;
		 index2 <
		 (int) classPermittedSrvTable[index1].permittedSrvListSize;
		 index2++) {
		if (classPermittedSrvTable[index1].permittedSrvList[index2]
		    == command)
		    return SRV_NORMAL;
	    }
	    return SRV_UNSUPPORTEDCOMMAND;
	}
    }
    return SRV_UNSUPPORTEDCOMMAND;
}

/* findPresentationCtx
**
** Purpose:
**	Find the presentation context in the service parameters using the
**	context ID
**
** Parameter Dictionary:
**	params		Service parameters
**	ctxid		Context ID using which the presentation context
**			is to be returned
**
** Return Values:
**	Handle to the presentation context, if found, else NULL.
**
** Notes:
**
** Algorithm:
**	Description of the algorithm (optional) and any other notes.
*/
static DUL_PRESENTATIONCONTEXT
*
findPresentationCtx(DUL_ASSOCIATESERVICEPARAMETERS * params,
		    DUL_PRESENTATIONCONTEXTID ctxid)
{
    DUL_PRESENTATIONCONTEXT
    * ctx;

    if (params->acceptedPresentationContext == NULL)
	return NULL;
    ctx = LST_Head(&params->acceptedPresentationContext);
    if (ctx == NULL)
	return NULL;
    (void) LST_Position(&params->acceptedPresentationContext, ctx);
    while (ctx != NULL) {
	if (ctx->presentationContextID == ctxid)	/* context id found */
	    break;
	ctx = LST_Next(&params->acceptedPresentationContext);
    }

    return ctx;
}
