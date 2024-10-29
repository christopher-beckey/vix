
/*******************************************************************************
	applicationShell1.c

       Associated Header file: applicationShell1.h
*******************************************************************************/

#include <stdio.h>
#include <Xm/Xm.h>
#include <Xm/MwmUtil.h>
#include <Xm/MenuShell.h>
#include "UxXt.h"

#include <Xm/TextF.h>
#include <Xm/Label.h>
#include <Xm/List.h>
#include <Xm/ScrolledW.h>
#include <Xm/Frame.h>
#include <Xm/Form.h>
#include <Xm/CascadeB.h>
#include <Xm/PushB.h>
#include <Xm/RowColumn.h>
#include <Xm/MainW.h>
#include <X11/Shell.h>

/*******************************************************************************
       Includes, Defines, and Global variables from the Declarations Editor:
*******************************************************************************/

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
**                   Electronic Radiology Laboratory
**                 Mallinckrodt Institute of Radiology
**              Washington University School of Medicine
**
** Module Name(s):	interface support functions
**			widget creation functions
**			widget callback functions
** Author, Date:	Steve Moore, Summer 1994
** Intent:		This file contains the main part of the image
**			database (idb) viewer application.  It contains
**			the code generated by the interface builder to
**			provide the user interface as well as the code
**			that we added that actually does the work (like
**			searching through the database and displaying
**			records.
** Last Update:         $Author: Vhaiswstarkm $, $Date: 11/04/10 9:10a $
** Source File:         $RCSfile: applicationShell1.c,v $
** Revision:            $Revision: 1 $
** Status:              $State: Exp $
*/

static char rcsid[] = "$Revision: 1 $ $RCSfile: applicationShell1.c,v $";

#include <stdlib.h>

#include "dicom.h"
#include "condition.h"
#include "lst.h"
#include "dicom_objects.h"
#include "tbl.h"
#include "idb.h"
#include "mut.h"

#include "idb_viewer.h"
#include "format.h"

extern IDB_HANDLE *IDBHandle;

static LST_HEAD *patientList = NULL;
static LST_HEAD *studyList = NULL;
static LST_HEAD *seriesList = NULL;
static LST_HEAD *imageList = NULL;
static int displayLevel = 0;


/*******************************************************************************
       The following header file defines the context structure.
*******************************************************************************/

#define CONTEXT_MACRO_ACCESS 1
#include "applicationShell1.h"
#undef CONTEXT_MACRO_ACCESS


/*******************************************************************************
Auxiliary code from the Declarations Editor:
*******************************************************************************/

static CONDITION
copyInstances(IDB_Query * src, IDB_Query * dst)
{
    IDB_InstanceListElement *e1,
       *e2;

    dst->image.InstanceList = NULL;
    if (src->image.InstanceList != NULL) {
	dst->image.InstanceList = LST_Create();
	if (dst->image.InstanceList == NULL)
	    return 0;

	e1 = LST_Head(&src->image.InstanceList);
	(void) LST_Position(&src->image.InstanceList, e1);

/* Insert an extra one at the beginning */

	if (e1 != NULL) {
	    e2 = malloc(sizeof(*e2));
	    *e2 = *e1;
	    (void) LST_Enqueue(&dst->image.InstanceList, e2);
	}
/* Insert all copies of instances */

	while (e1 != NULL) {
	    e2 = malloc(sizeof(*e2));
	    *e2 = *e1;
	    (void) LST_Enqueue(&dst->image.InstanceList, e2);
	    e1 = LST_Next(&src->image.InstanceList);
	}
    }
    return 1;
}


static CONDITION
selectCallback(IDB_Query * q, long count, LST_HEAD * lst)
{
    QUERY_LIST_ITEM *item;

    item = malloc(sizeof(*item));
    if (item == NULL)
	return 0;

    item->query = *q;
    if (copyInstances(q, &item->query) != 1)
	return 0;

    (void) LST_Enqueue(&lst, item);
    if (count == 1) {		/* Add another record */
	item = malloc(sizeof(*item));
	if (item == NULL)
	    return 0;

	item->query = *q;
	if (copyInstances(q, &item->query) != 1)
	    return 0;
	(void) LST_Enqueue(&lst, item);
    }
    return IDB_NORMAL;
}

static CONDITION
createLists()
{
    if (patientList == NULL)
	patientList = LST_Create();
    if (studyList == NULL)
	studyList = LST_Create();
    if (seriesList == NULL)
	seriesList = LST_Create();
    if (imageList == NULL)
	imageList = LST_Create();

    if (patientList == NULL)
	return 0;
    if (studyList == NULL)
	return 0;
    if (seriesList == NULL)
	return 0;
    if (imageList == NULL)
	return 0;

    return 1;
}

static void
clearList(LST_HEAD * l)
{
    QUERY_LIST_ITEM *item;

    while ((item = LST_Dequeue(&l)) != NULL)
	free(item);
}

void
loadPatient()
{
    CONDITION cond;
    char b[256];
    IDB_Query queryStructure;
    long selectCount;

    if (createLists() == 0)
	return;

    clearList(patientList);
    memset(&queryStructure, 0, sizeof(queryStructure));
    cond = IDB_Select(&IDBHandle, PATIENT_ROOT, IDB_PATIENT_LEVEL,
		      IDB_PATIENT_LEVEL, &queryStructure, &selectCount,
		      selectCallback, patientList);
    if (cond != IDB_NORMAL && cond != IDB_NOMATCHES) {
	COND_DumpConditions();
	return;
    }
    MUT_LoadList(wObjectList, patientList, formatPatient, b);
    XmTextSetString(wPatientTxt, "");
    XmTextSetString(wStudyTxt, "");
    XmTextSetString(wSeriesTxt, "");
    XmTextSetString(wImageTxt, "");
    XmTextSetString(wInstanceTxt, "");
    displayLevel = IDB_PATIENT_LEVEL;
}

static void
displayPatient(QUERY_LIST_ITEM * item)
{
    char buf[256];

    formatPatient(item, 2, buf);
    XmTextSetString(wPatientTxt, buf);
    XmTextSetString(wStudyTxt, "");
    XmTextSetString(wSeriesTxt, "");
    XmTextSetString(wImageTxt, "");
    XmTextSetString(wInstanceTxt, "");
}

static void
loadStudy(char *patientID)
{
    CONDITION cond;
    char b[256];
    IDB_Query query;
    long selectCount;

    if (createLists() == 0)
	return;

    clearList(studyList);
    memset(&query, 0, sizeof(query));
    query.PatientQFlag = QF_PAT_PatID;
    strcpy(query.patient.PatID, patientID);
    cond = IDB_Select(&IDBHandle, PATIENT_ROOT, IDB_PATIENT_LEVEL,
		      IDB_STUDY_LEVEL, &query, &selectCount,
		      selectCallback, studyList);
    if (cond != IDB_NORMAL && cond != IDB_NOMATCHES) {
	COND_DumpConditions();
	return;
    }
    MUT_LoadList(wObjectList, studyList, formatStudy, b);
    XmTextSetString(wStudyTxt, "");
    XmTextSetString(wSeriesTxt, "");
    XmTextSetString(wImageTxt, "");
    XmTextSetString(wInstanceTxt, "");
    displayLevel = IDB_STUDY_LEVEL;
}

static void
displayStudy(QUERY_LIST_ITEM * item)
{
    char buf[256];

    formatStudy(item, 2, buf);
    XmTextSetString(wStudyTxt, buf);
    XmTextSetString(wSeriesTxt, "");
    XmTextSetString(wImageTxt, "");
    XmTextSetString(wInstanceTxt, "");
}

static void
loadSeries(char *patientID, char *studyInstanceUID)
{
    CONDITION cond;
    char b[256];
    IDB_Query query;
    long selectCount;

    if (createLists() == 0)
	return;

    clearList(seriesList);
    memset(&query, 0, sizeof(query));
    query.PatientQFlag = QF_PAT_PatID;
    query.StudyQFlag = QF_STU_StuInsUID;
    strcpy(query.patient.PatID, patientID);
    strcpy(query.study.StuInsUID, studyInstanceUID);
    cond = IDB_Select(&IDBHandle, PATIENT_ROOT, IDB_PATIENT_LEVEL,
		      IDB_SERIES_LEVEL, &query, &selectCount,
		      selectCallback, seriesList);
    if (cond != IDB_NORMAL && cond != IDB_NOMATCHES) {
	COND_DumpConditions();
	return;
    }
    MUT_LoadList(wObjectList, seriesList, formatSeries, b);
    XmTextSetString(wSeriesTxt, "");
    XmTextSetString(wImageTxt, "");
    XmTextSetString(wInstanceTxt, "");
    displayLevel = IDB_SERIES_LEVEL;
}

static void
displaySeries(QUERY_LIST_ITEM * item)
{
    char buf[256];

    formatSeries(item, 2, buf);
    XmTextSetString(wSeriesTxt, buf);
    XmTextSetString(wImageTxt, "");
    XmTextSetString(wInstanceTxt, "");
}

static void
loadImage(char *patientID, char *studyInstanceUID,
	  char *seriesInstanceUID)
{
    CONDITION cond;
    char b[256];
    IDB_Query query;
    long selectCount;

    if (createLists() == 0)
	return;

    clearList(imageList);
    memset(&query, 0, sizeof(query));
    query.PatientQFlag = QF_PAT_PatID;
    query.StudyQFlag = QF_STU_StuInsUID;
    query.SeriesQFlag = QF_SER_SerInsUID;
    strcpy(query.patient.PatID, patientID);
    strcpy(query.study.StuInsUID, studyInstanceUID);
    strcpy(query.series.SerInsUID, seriesInstanceUID);
    cond = IDB_Select(&IDBHandle, PATIENT_ROOT, IDB_PATIENT_LEVEL,
		      IDB_IMAGE_LEVEL, &query, &selectCount,
		      selectCallback, imageList);
    if (cond != IDB_NORMAL && cond != IDB_NOMATCHES) {
	COND_DumpConditions();
	return;
    }
    MUT_LoadList(wObjectList, imageList, formatImage, b);
    XmTextSetString(wImageTxt, "");
    XmTextSetString(wInstanceTxt, "");
    displayLevel = IDB_IMAGE_LEVEL;
}

static void
displayImage(QUERY_LIST_ITEM * item)
{
    char buf[256];

    formatImage(item, 2, buf);
    XmTextSetString(wImageTxt, buf);
    XmTextSetString(wInstanceTxt, "");
}

static void
loadInstance(LST_HEAD * instanceList)
{
    char b[256];

    MUT_LoadList(wObjectList, instanceList, formatInstance, b);
    XmTextSetString(wInstanceTxt, "");
    displayLevel = IDB_IMAGE_LEVEL + 1;
}

static void
displayInstance(IDB_InstanceListElement * item)
{
    char buf[256];

    formatInstance(item, 2, buf);
    XmTextSetString(wInstanceTxt, buf);
}

/*******************************************************************************
       The following are callback functions.
*******************************************************************************/

static void
activateCB_menu1_p1_b1(
		       Widget wgt,
		       XtPointer cd,
		       XtPointer cb)
{
    _UxCapplicationShell1 *UxSaveCtx,
       *UxContext;
    Widget UxWidget = wgt;
    XtPointer UxClientData = cd;
    XtPointer UxCallbackArg = cb;

    UxSaveCtx = UxApplicationShell1Context;
    UxApplicationShell1Context = UxContext =
	(_UxCapplicationShell1 *) UxGetContext(UxWidget);
    {
	exit(0);
    }
    UxApplicationShell1Context = UxSaveCtx;
}

static void
browseSelectionCB_wObjectList(
			      Widget wgt,
			      XtPointer cd,
			      XtPointer cb)
{
    _UxCapplicationShell1 *UxSaveCtx,
       *UxContext;
    Widget UxWidget = wgt;
    XtPointer UxClientData = cd;
    XtPointer UxCallbackArg = cb;

    UxSaveCtx = UxApplicationShell1Context;
    UxApplicationShell1Context = UxContext =
	(_UxCapplicationShell1 *) UxGetContext(UxWidget);
    {
	XmListCallbackStruct *listStruct;
	QUERY_LIST_ITEM *item;
	IDB_InstanceListElement *instance;

	listStruct = (XmListCallbackStruct *) UxCallbackArg;

	if (listStruct->item_position == 1) {
	    switch (displayLevel) {
	    case IDB_PATIENT_LEVEL:
		loadPatient();
		break;
	    case IDB_STUDY_LEVEL:
		loadPatient();
		break;
	    case IDB_SERIES_LEVEL:
		item = LST_Current(&studyList);
		loadStudy(item->query.patient.PatID);
		break;
	    case IDB_IMAGE_LEVEL:
		item = LST_Current(&seriesList);
		loadSeries(item->query.patient.PatID,
			   item->query.study.StuInsUID);
		break;
	    case IDB_IMAGE_LEVEL + 1:
		item = LST_Current(&imageList);
		loadImage(item->query.patient.PatID,
			  item->query.study.StuInsUID,
			  item->query.series.SerInsUID);
		break;
	    default:
		break;
	    }
	} else {
	    switch (displayLevel) {
	    case IDB_PATIENT_LEVEL:
		item = LST_Index(&patientList, listStruct->item_position);
		loadStudy(item->query.patient.PatID);
		displayPatient(item);
		break;
	    case IDB_STUDY_LEVEL:
		item = LST_Index(&studyList, listStruct->item_position);
		loadSeries(item->query.patient.PatID,
			   item->query.study.StuInsUID);
		displayStudy(item);
		break;
	    case IDB_SERIES_LEVEL:
		item = LST_Index(&seriesList, listStruct->item_position);
		loadImage(item->query.patient.PatID,
			  item->query.study.StuInsUID,
			  item->query.series.SerInsUID);
		displaySeries(item);
		break;
	    case IDB_IMAGE_LEVEL:
		item = LST_Index(&imageList, listStruct->item_position);
		loadInstance(item->query.image.InstanceList);
		displayImage(item);
		break;
	    case IDB_IMAGE_LEVEL + 1:
		item = LST_Current(&imageList);
		instance = LST_Index(&item->query.image.InstanceList,
				     listStruct->item_position);
		displayInstance(instance);
		break;
	    default:
		break;
	    }
	}
    }
    UxApplicationShell1Context = UxSaveCtx;
}

static void
activateCB_pushButton1(
		       Widget wgt,
		       XtPointer cd,
		       XtPointer cb)
{
    _UxCapplicationShell1 *UxSaveCtx,
       *UxContext;
    Widget UxWidget = wgt;
    XtPointer UxClientData = cd;
    XtPointer UxCallbackArg = cb;

    UxSaveCtx = UxApplicationShell1Context;
    UxApplicationShell1Context = UxContext =
	(_UxCapplicationShell1 *) UxGetContext(UxWidget);
    {
	CONDITION cond;
	char *uid = NULL;
	QUERY_LIST_ITEM *item;

	switch (displayLevel) {
	case IDB_PATIENT_LEVEL + 1:
	    item = LST_Current(&patientList);
	    uid = item->query.patient.PatID;
	    break;
	case IDB_STUDY_LEVEL + 1:
	    item = LST_Current(&studyList);
	    uid = item->query.study.StuInsUID;
	    break;
	case IDB_SERIES_LEVEL + 1:
	    item = LST_Current(&seriesList);
	    uid = item->query.series.SerInsUID;
	    break;
	case IDB_IMAGE_LEVEL + 1:
	    item = LST_Current(&imageList);
	    uid = item->query.image.SOPInsUID;
	    break;
	}

	if (uid != NULL) {
	    cond = IDB_Delete(&IDBHandle, displayLevel - 1, uid, TRUE);
	    if (cond != IDB_NORMAL)
		COND_DumpConditions();

	    loadPatient();
	}
    }
    UxApplicationShell1Context = UxSaveCtx;
}

/*******************************************************************************
       The 'build_' function creates all the widgets
       using the resource values specified in the Property Editor.
*******************************************************************************/

static Widget
_Uxbuild_applicationShell1()
{
    Widget _UxParent;
    Widget menu1_p1_shell;


    /* Creation of applicationShell1 */
    _UxParent = UxParent;
    if (_UxParent == NULL) {
	_UxParent = UxTopLevel;
    }
    applicationShell1 = XtVaCreatePopupShell("applicationShell1",
					     applicationShellWidgetClass,
					     _UxParent,
					     XmNwidth, 710,
					     XmNheight, 450,
					     XmNx, 183,
					     XmNy, 119,
					     NULL);
    UxPutContext(applicationShell1, (char *) UxApplicationShell1Context);


    /* Creation of mainWindow1 */
    mainWindow1 = XtVaCreateManagedWidget("mainWindow1",
					  xmMainWindowWidgetClass,
					  applicationShell1,
					  XmNwidth, 710,
					  XmNheight, 450,
					  XmNx, 80,
					  XmNy, 40,
					  XmNunitType, XmPIXELS,
					  NULL);
    UxPutContext(mainWindow1, (char *) UxApplicationShell1Context);


    /* Creation of menu1 */
    menu1 = XtVaCreateManagedWidget("menu1",
				    xmRowColumnWidgetClass,
				    mainWindow1,
				    XmNrowColumnType, XmMENU_BAR,
				    XmNmenuAccelerator, "<KeyUp>F10",
				    NULL);
    UxPutContext(menu1, (char *) UxApplicationShell1Context);


    /* Creation of menu1_p1 */
    menu1_p1_shell = XtVaCreatePopupShell("menu1_p1_shell",
					  xmMenuShellWidgetClass, menu1,
					  XmNwidth, 1,
					  XmNheight, 1,
					  XmNallowShellResize, TRUE,
					  XmNoverrideRedirect, TRUE,
					  NULL);

    menu1_p1 = XtVaCreateWidget("menu1_p1",
				xmRowColumnWidgetClass,
				menu1_p1_shell,
				XmNrowColumnType, XmMENU_PULLDOWN,
				NULL);
    UxPutContext(menu1_p1, (char *) UxApplicationShell1Context);


    /* Creation of menu1_p1_b1 */
    menu1_p1_b1 = XtVaCreateManagedWidget("menu1_p1_b1",
					  xmPushButtonWidgetClass,
					  menu1_p1,
					RES_CONVERT(XmNlabelString, "Quit"),
					  NULL);
    XtAddCallback(menu1_p1_b1, XmNactivateCallback,
		  (XtCallbackProc) activateCB_menu1_p1_b1,
		  (XtPointer) UxApplicationShell1Context);

    UxPutContext(menu1_p1_b1, (char *) UxApplicationShell1Context);


    /* Creation of menu1_top_b1 */
    menu1_top_b1 = XtVaCreateManagedWidget("menu1_top_b1",
					   xmCascadeButtonWidgetClass,
					   menu1,
				     RES_CONVERT(XmNlabelString, "Control"),
					   XmNsubMenuId, menu1_p1,
					   NULL);
    UxPutContext(menu1_top_b1, (char *) UxApplicationShell1Context);


    /* Creation of form1 */
    form1 = XtVaCreateManagedWidget("form1",
				    xmFormWidgetClass,
				    mainWindow1,
				    NULL);
    UxPutContext(form1, (char *) UxApplicationShell1Context);


    /* Creation of frame1 */
    frame1 = XtVaCreateManagedWidget("frame1",
				     xmFrameWidgetClass,
				     form1,
				     XmNwidth, 560,
				     XmNheight, 150,
				     XmNx, 20,
				     XmNy, 10,
				     XmNresizable, FALSE,
				     NULL);
    UxPutContext(frame1, (char *) UxApplicationShell1Context);


    /* Creation of scrolledWindowList1 */
    scrolledWindowList1 = XtVaCreateManagedWidget("scrolledWindowList1",
						xmScrolledWindowWidgetClass,
						  frame1,
				  XmNscrollingPolicy, XmAPPLICATION_DEFINED,
						XmNvisualPolicy, XmVARIABLE,
					XmNscrollBarDisplayPolicy, XmSTATIC,
						  XmNshadowThickness, 0,
						  XmNx, 110,
						  XmNy, 60,
						  NULL);
    UxPutContext(scrolledWindowList1, (char *) UxApplicationShell1Context);


    /* Creation of wObjectList */
    wObjectList = XtVaCreateManagedWidget("wObjectList",
					  xmListWidgetClass,
					  scrolledWindowList1,
					  XmNwidth, 130,
					  XmNheight, 30,
					  NULL);
    XtAddCallback(wObjectList, XmNbrowseSelectionCallback,
		  (XtCallbackProc) browseSelectionCB_wObjectList,
		  (XtPointer) UxApplicationShell1Context);

    UxPutContext(wObjectList, (char *) UxApplicationShell1Context);


    /* Creation of pushButton1 */
    pushButton1 = XtVaCreateManagedWidget("pushButton1",
					  xmPushButtonWidgetClass,
					  form1,
					  XmNx, 600,
					  XmNy, 60,
					  XmNwidth, 100,
					  XmNheight, 50,
				      RES_CONVERT(XmNlabelString, "Delete"),
					  NULL);
    XtAddCallback(pushButton1, XmNactivateCallback,
		  (XtCallbackProc) activateCB_pushButton1,
		  (XtPointer) UxApplicationShell1Context);

    UxPutContext(pushButton1, (char *) UxApplicationShell1Context);


    /* Creation of label1 */
    label1 = XtVaCreateManagedWidget("label1",
				     xmLabelWidgetClass,
				     form1,
				     XmNx, 30,
				     XmNy, 180,
				     XmNwidth, 110,
				     XmNheight, 30,
				     RES_CONVERT(XmNlabelString, "Patient"),
				     NULL);
    UxPutContext(label1, (char *) UxApplicationShell1Context);


    /* Creation of label2 */
    label2 = XtVaCreateManagedWidget("label2",
				     xmLabelWidgetClass,
				     form1,
				     XmNx, 30,
				     XmNy, 230,
				     XmNwidth, 110,
				     XmNheight, 30,
				XmNleftAttachment, XmATTACH_OPPOSITE_WIDGET,
				     XmNleftOffset, 0,
				     XmNleftWidget, label1,
				     XmNtopAttachment, XmATTACH_WIDGET,
				     XmNtopOffset, 15,
				     XmNtopWidget, label1,
				     RES_CONVERT(XmNlabelString, "Study"),
				     NULL);
    UxPutContext(label2, (char *) UxApplicationShell1Context);


    /* Creation of label3 */
    label3 = XtVaCreateManagedWidget("label3",
				     xmLabelWidgetClass,
				     form1,
				     XmNx, 30,
				     XmNy, 270,
				     XmNwidth, 110,
				     XmNheight, 30,
				XmNleftAttachment, XmATTACH_OPPOSITE_WIDGET,
				     XmNleftOffset, 0,
				     XmNleftWidget, label1,
				     XmNtopAttachment, XmATTACH_WIDGET,
				     XmNtopOffset, 15,
				     XmNtopWidget, label2,
				     RES_CONVERT(XmNlabelString, "Series"),
				     NULL);
    UxPutContext(label3, (char *) UxApplicationShell1Context);


    /* Creation of label4 */
    label4 = XtVaCreateManagedWidget("label4",
				     xmLabelWidgetClass,
				     form1,
				     XmNx, 40,
				     XmNy, 310,
				     XmNwidth, 110,
				     XmNheight, 30,
				XmNleftAttachment, XmATTACH_OPPOSITE_WIDGET,
				     XmNleftOffset, 0,
				     XmNleftWidget, label1,
				     XmNtopAttachment, XmATTACH_WIDGET,
				     XmNtopOffset, 15,
				     XmNtopWidget, label3,
				     RES_CONVERT(XmNlabelString, "Image"),
				     NULL);
    UxPutContext(label4, (char *) UxApplicationShell1Context);


    /* Creation of wPatientTxt */
    wPatientTxt = XtVaCreateManagedWidget("wPatientTxt",
					  xmTextFieldWidgetClass,
					  form1,
					  XmNwidth, 520,
					  XmNx, 180,
					  XmNy, 180,
					  XmNheight, 40,
					  XmNleftAttachment, XmATTACH_WIDGET,
					  XmNleftOffset, 15,
					  XmNleftWidget, label1,
				 XmNtopAttachment, XmATTACH_OPPOSITE_WIDGET,
					  XmNtopOffset, 0,
					  XmNtopWidget, label1,
					  NULL);
    UxPutContext(wPatientTxt, (char *) UxApplicationShell1Context);


    /* Creation of wStudyTxt */
    wStudyTxt = XtVaCreateManagedWidget("wStudyTxt",
					xmTextFieldWidgetClass,
					form1,
					XmNwidth, 520,
					XmNx, 180,
					XmNy, 220,
					XmNheight, 40,
					XmNleftAttachment, XmATTACH_WIDGET,
					XmNleftOffset, 15,
					XmNleftWidget, label1,
				 XmNtopAttachment, XmATTACH_OPPOSITE_WIDGET,
					XmNtopOffset, 0,
					XmNtopWidget, label2,
					NULL);
    UxPutContext(wStudyTxt, (char *) UxApplicationShell1Context);


    /* Creation of wSeriesTxt */
    wSeriesTxt = XtVaCreateManagedWidget("wSeriesTxt",
					 xmTextFieldWidgetClass,
					 form1,
					 XmNwidth, 520,
					 XmNx, 180,
					 XmNy, 260,
					 XmNheight, 40,
					 XmNleftAttachment, XmATTACH_WIDGET,
					 XmNleftOffset, 15,
					 XmNleftWidget, label1,
				 XmNtopAttachment, XmATTACH_OPPOSITE_WIDGET,
					 XmNtopOffset, 0,
					 XmNtopWidget, label3,
					 NULL);
    UxPutContext(wSeriesTxt, (char *) UxApplicationShell1Context);


    /* Creation of wImageTxt */
    wImageTxt = XtVaCreateManagedWidget("wImageTxt",
					xmTextFieldWidgetClass,
					form1,
					XmNwidth, 520,
					XmNx, 180,
					XmNy, 300,
					XmNheight, 40,
					XmNleftAttachment, XmATTACH_WIDGET,
					XmNleftOffset, 15,
					XmNleftWidget, label1,
				 XmNtopAttachment, XmATTACH_OPPOSITE_WIDGET,
					XmNtopOffset, 0,
					XmNtopWidget, label4,
					NULL);
    UxPutContext(wImageTxt, (char *) UxApplicationShell1Context);


    /* Creation of label5 */
    label5 = XtVaCreateManagedWidget("label5",
				     xmLabelWidgetClass,
				     form1,
				     XmNx, 40,
				     XmNy, 360,
				     XmNwidth, 110,
				     XmNheight, 30,
				     RES_CONVERT(XmNlabelString, "Instance"),
				XmNleftAttachment, XmATTACH_OPPOSITE_WIDGET,
				     XmNleftOffset, 0,
				     XmNleftWidget, label1,
				     XmNtopAttachment, XmATTACH_WIDGET,
				     XmNtopOffset, 15,
				     XmNtopWidget, label4,
				     NULL);
    UxPutContext(label5, (char *) UxApplicationShell1Context);


    /* Creation of wInstanceTxt */
    wInstanceTxt = XtVaCreateManagedWidget("wInstanceTxt",
					   xmTextFieldWidgetClass,
					   form1,
					   XmNwidth, 520,
					   XmNx, 150,
					   XmNy, 360,
					   XmNheight, 40,
					 XmNleftAttachment, XmATTACH_WIDGET,
					   XmNleftOffset, 15,
					   XmNleftWidget, label1,
				 XmNtopAttachment, XmATTACH_OPPOSITE_WIDGET,
					   XmNtopOffset, 0,
					   XmNtopWidget, label5,
					   NULL);
    UxPutContext(wInstanceTxt, (char *) UxApplicationShell1Context);


    XtAddCallback(applicationShell1, XmNdestroyCallback,
		  (XtCallbackProc) UxDestroyContextCB,
		  (XtPointer) UxApplicationShell1Context);

    XmMainWindowSetAreas(mainWindow1, menu1, (Widget) NULL,
			 (Widget) NULL, (Widget) NULL, form1);

    return (applicationShell1);
}

/*******************************************************************************
       The following is the 'Interface function' which is the
       external entry point for creating this interface.
       This function should be called from your application or from
       a callback function.
*******************************************************************************/

Widget
create_applicationShell1(swidget _UxUxParent)
{
    Widget rtrn;
    _UxCapplicationShell1 *UxContext;

    UxApplicationShell1Context = UxContext =
	(_UxCapplicationShell1 *) UxNewContext(sizeof(_UxCapplicationShell1), False);

    UxParent = _UxUxParent;

    rtrn = _Uxbuild_applicationShell1();

    return (rtrn);
}

/*******************************************************************************
       END OF FILE
*******************************************************************************/
