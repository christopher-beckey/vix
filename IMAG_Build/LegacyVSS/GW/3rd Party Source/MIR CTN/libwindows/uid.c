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
** Module Name(s):	UID_NewUID
**			UID_NewNumber
**			UID_Lookup
** Author, Date:	Stephen M. Moore, 16-Apr-93
** Intent:		This file contains functions for generating new
**			Unique Identifiers using a scheme similar to that
**			described in Part 5 of the DICOM V3 standard.
** Last Update:		$Author: Vhaiswstarkm $, $Date: 11/04/10 9:08a $
** Source File:		$RCSfile: uid.c,v $
** Revision:		$Revision: 1 $
** Status:		$State: Exp $
*/

static char rcsid[] = "$Revision: 1 $ $RCSfile: uid.c,v $";

#include <stdio.h>
#include <stdlib.h>
#include <string.h>

#include "dicom.h"
#include "dicom_uids.h"
#include "condition.h"

static CONDITION getUIDFile();
static CONDITION readUIDFile(UID_BLOCK * block);
static CONDITION writeUIDFile(UID_BLOCK * block);

typedef struct {
    char *keyWord;
    unsigned long *value;
}   BLOCK_MAP;

static char
    uidFile[1024] = "";

/* UID_NewUID
**
** Purpose:
**	This function generates a unique identifier (UID).
**
** Parameter Dictionary:
**	type		The type of UID to be generated
**	uid		Generated uid, returned to caller
**
** Return Values:
**
**	UID_GENERATEFAILED
**	UID_NORMAL
**
** Algorithm:
**	Description of the algorithm (optional) and any other notes.
*/

CONDITION
UID_NewUID(UID_TYPE type, char *uid)
{
    CONDITION
	cond;
    UID_BLOCK
	b;

    cond = readUIDFile(&b);
    if (cond != UID_NORMAL) {
	return COND_PushCondition(UID_GENERATEFAILED,
				  UID_Message(UID_GENERATEFAILED));
    }
    switch (type) {
    case UID_PATIENT:
	sprintf(uid, "%s.%-ld.%-ld.%-d.%-ld",
	     b.root, b.deviceType, b.serialNumber, (int) type, ++b.patient);
	break;
    case UID_VISIT:
	sprintf(uid, "%s.%-ld.%-ld.%-d.%-ld",
		b.root, b.deviceType, b.serialNumber, (int) type, ++b.visit);
	break;
    case UID_STUDY:
	sprintf(uid, "%s.%-ld.%-ld.%-d.%-ld",
		b.root, b.deviceType, b.serialNumber, (int) type, ++b.study);
	break;
    case UID_SERIES:
	sprintf(uid, "%s.%-ld.%-ld.%-d.%-ld",
	      b.root, b.deviceType, b.serialNumber, (int) type, ++b.series);
	break;
    case UID_IMAGE:
	sprintf(uid, "%s.%-ld.%-ld.%-d.%-ld",
		b.root, b.deviceType, b.serialNumber, (int) type, ++b.image);
	break;
    case UID_RESULTS:
	sprintf(uid, "%s.%-ld.%-ld.%-d.%-ld",
	     b.root, b.deviceType, b.serialNumber, (int) type, ++b.results);
	break;
    case UID_INTERPRETATION:
	sprintf(uid, "%s.%-ld.%-ld.%-d.%-ld",
		b.root, b.deviceType, b.serialNumber, (int) type,
		++b.interpretation);
	break;
    case UID_PRINTER:
	sprintf(uid, "%s.%-ld.%-ld.%-d.%-ld",
	     b.root, b.deviceType, b.serialNumber, (int) type, ++b.printer);
	break;
    case UID_DEVICE:
	sprintf(uid, "%s.%-ld.%-ld",
		b.root, b.deviceType, b.serialNumber);
	break;
    case UID_STUDYCOMPONENT:
	sprintf(uid, "%s.%-ld.%-ld.%-d.%-ld",
		b.root, b.deviceType, b.serialNumber, (int) type,
		++b.studyComponent);
	break;
    case UID_STORAGECOMMITTRANSACTION:
	sprintf(uid, "%s.%-ld.%-ld.%-d.%-ld",
		b.root, b.deviceType, b.serialNumber, (int) type,
		++b.storageCommitTransaction);
	break;
    }
    if (type != UID_DEVICE) {
	cond = writeUIDFile(&b);
	if (cond != UID_NORMAL) {
	    return COND_PushCondition(UID_GENERATEFAILED,
				      UID_Message(UID_GENERATEFAILED));
	}
    }
    return UID_NORMAL;
}


/* UID_NewNumber
**
** Purpose:
**	Get a new number
**
** Parameter Dictionary:
**	type		UID type
**	value		The new number to be returned to caller
**
** Return Values:
**
**	UID_GENERATEFAILED
**	UID_NORMAL
**
** Notes:
**
** Algorithm:
**	Description of the algorithm (optional) and any other notes.
*/

CONDITION
UID_NewNumber(UID_TYPE type, unsigned long *value)
{
    CONDITION
	cond;
    UID_BLOCK
	block;

    cond = readUIDFile(&block);
    if (cond != UID_NORMAL) {
	return COND_PushCondition(UID_GENERATEFAILED,
				  UID_Message(UID_GENERATEFAILED));
    }
    switch (type) {
    case UID_PATIENT:
	*value = ++block.patient;
	break;
    case UID_STUDY:
	*value = ++block.study;
	break;
    case UID_SERIES:
	*value = ++block.series;
	break;
    default:
	break;
    }
    cond = writeUIDFile(&block);
    if (cond != UID_NORMAL) {
	return COND_PushCondition(UID_GENERATEFAILED,
				  UID_Message(UID_GENERATEFAILED));
    }
    return UID_NORMAL;
}

static UID_DESCRIPTION table[] = {
    {UID_CLASS_K_IMPLEMENTATION, MIR_IMPLEMENTATIONCLASSUID,
    "Implementation Class UID", "MIR"},

    {UID_CLASS_K_SOPCLASS, DICOM_SOPCLASSVERIFICATION,
    "Verification SOP Class", "NEMA"},

    {UID_CLASS_K_TRANSFERSYNTAX, DICOM_TRANSFERLITTLEENDIAN,
    "Implicit Little-Endian Transfer Syntax", "NEMA"},
    {UID_CLASS_K_TRANSFERSYNTAX, DICOM_TRANSFERLITTLEENDIANEXPLICIT,
    "Explicit Little-Endian Transfer Syntax", "NEMA"},
    {UID_CLASS_K_TRANSFERSYNTAX, DICOM_TRANSFERBIGENDIANEXPLICIT,
    "Explicit Big-Endian Transfer Syntax", "NEMA"},

    {UID_CLASS_K_SOPCLASS, DICOM_SOPCLASSSTORAGECOMMITMENTPUSHMODEL,
    "Storage Commitment Push Model SOP Class", "NEMA"},
    {UID_CLASS_K_WELLKNOWNUID, DICOM_WELLKNOWNSTORAGECOMMITMENTPUSHMODEL,
    "Storage Commitment Push Model SOP Instance", "NEMA"},
    {UID_CLASS_K_SOPCLASS, DICOM_SOPCLASSSTORAGECOMMITMENTPULLMODEL,
    "Storage Commitment Pull Model SOP Class", "NEMA"},
    {UID_CLASS_K_WELLKNOWNUID, DICOM_WELLKNOWNSTORAGECOMMITMENTPULLMODEL,
    "Storage Commitment Pull Model SOP Instance", "NEMA"},

    {UID_CLASS_K_APPLICATIONCONTEXT, DICOM_STDAPPLICATIONCONTEXT,
    "Application Context Name", "NEMA"},

    {UID_CLASS_K_SOPCLASS, DICOM_SOPCLASSDETACHEDPATIENTMGMT,
    "Detached Patient Management SOP Class", "NEMA"},
    {UID_CLASS_K_METASOPCLASS, DICOM_SOPCLASSDETACHEDPATIENTMGMTMETA,
    "Detached Patient Management Meta SOP Class", "NEMA"},
    {UID_CLASS_K_SOPCLASS, DICOM_SOPCLASSDETACHEDVISITMGMT,
    "Detached Visit Management SOP Class", "NEMA"},
    {UID_CLASS_K_SOPCLASS, DICOM_SOPCLASSDETACHEDSTUDYMGMT,
    "Detached Study Management SOP Class", "NEMA"},
    {UID_CLASS_K_METASOPCLASS, DICOM_SOPCLASSDETACHEDSTUDYMGMTMETA,
    "Detached Study Management Meta SOP Class", "NEMA"},
    {UID_CLASS_K_SOPCLASS, DICOM_SOPCLASSSTUDYCOMPONENTMGMT,
    "Detached Study Component SOP Class", "NEMA"},
    {UID_CLASS_K_SOPCLASS, DICOM_SOPCLASSDETACHEDRESULTSMGMT,
    "Detached Results Management SOP Class", "NEMA"},
    {UID_CLASS_K_SOPCLASS, DICOM_SOPCLASSDETACHEDRESULTSMGMTMETA,
    "Detached Results Management Meta SOP Class", "NEMA"},
    {UID_CLASS_K_SOPCLASS, DICOM_SOPCLASSDETACHEDINTERPRETMGMT,
    "Detached Interpretation Management SOP Class", "NEMA"},

    {UID_CLASS_K_SOPCLASS, DICOM_SOPCLASSBASICFILMSESSION,
    "Basic Film Session SOP Class", "NEMA"},
    {UID_CLASS_K_SOPCLASS, DICOM_SOPCLASSBASICFILMBOX,
    "Basic Film Box SOP Class", "NEMA"},
    {UID_CLASS_K_SOPCLASS, DICOM_SOPCLASSBASICGREYSCALEIMAGEBOX,
    "Basic Greyscale Image Box SOP Class", "NEMA"},
    {UID_CLASS_K_METASOPCLASS, DICOM_SOPCLASSGREYSCALEPRINTMGMTMETA,
    "Basic Greyscale Print Management Meta SOP Class", "NEMA"},
    {UID_CLASS_K_SOPCLASS, DICOM_SOPCLASSPRINTJOB,
    "Print Job Box SOP Class", "NEMA"},
    {UID_CLASS_K_SOPCLASS, DICOM_SOPCLASSBASICANNOTATIONBOX,
    "Basic Annotation Box SOP Class", "NEMA"},
    {UID_CLASS_K_SOPCLASS, DICOM_SOPCLASSPRINTER, "Printer SOP Class", "NEMA"},
    {UID_CLASS_K_WELLKNOWNUID, DICOM_SOPPRINTERINSTANCE,
    "Printer SOP Instance", "NEMA"},
    {UID_CLASS_K_METASOPCLASS, DICOM_SOPCLASSCOLORPRINTMGMTMETA,
    "Basic Color Print Management Meta SOP Class", "NEMA"},
/*UID_CLASS_K_SOPCLASS, DICOM_SOPCLASSPREFORMATTEDGREYIMAGE */
/*UID_CLASS_K_SOPCLASS, DICOM_SOPCLASSPREFORMATTEDCOLORIMAGE */

    {UID_CLASS_K_SOPCLASS, DICOM_SOPCLASSCOMPUTEDRADIOGRAPHY,
    "Computed Radiography Image Storage", "NEMA"},
    {UID_CLASS_K_SOPCLASS, DICOM_SOPCLASSCT,
    "CT Image Storage", "NEMA"},
    {UID_CLASS_K_SOPCLASS, DICOM_SOPCLASSUSMULTIFRAMEIMAGE1993,
    "US Multi-Frame Image Store (1993-Ret)", "NEMA"},
    {UID_CLASS_K_SOPCLASS, DICOM_SOPCLASSUSMULTIFRAMEIMAGE,
    "US Multi-Frame Image Store", "NEMA"},
    {UID_CLASS_K_SOPCLASS, DICOM_SOPCLASSMR, "MR Image Storage", "NEMA"},
    {UID_CLASS_K_SOPCLASS, DICOM_SOPCLASSNM, "NM Image Storage", "NEMA"},
    {UID_CLASS_K_SOPCLASS, DICOM_SOPCLASSUS1993, "US Image Storage (1993-Ret)", "NEMA"},
    {UID_CLASS_K_SOPCLASS, DICOM_SOPCLASSUS, "US Image Storage", "NEMA"},
    {UID_CLASS_K_SOPCLASS, DICOM_SOPCLASSSECONDARYCAPTURE,
    "Secondary Capture Image Storage", "NEMA"},
    {UID_CLASS_K_SOPCLASS, DICOM_SOPCLASSSTANDALONEOVERLAY,
    "Standalone Overlay Storage", "NEMA"},
    {UID_CLASS_K_SOPCLASS, DICOM_SOPCLASSSTANDALONECURVE,
    "Standalone Curve Storage", "NEMA"},
    {UID_CLASS_K_SOPCLASS, DICOM_SOPCLASSWAVEFORMSTORAGE,
    "Waveform Storage", "NEMA"},
    {UID_CLASS_K_SOPCLASS, DICOM_SOPCLASSECGWAVEFORMSTORAGE,
    "ECG Waveform Storage", "NEMA"},
    {UID_CLASS_K_SOPCLASS, DICOM_SOPCLASSXRAYANGIO, "XRAY Angiographic Image Storage", "NEMA"},
    {UID_CLASS_K_SOPCLASS, DICOM_SOPCLASSXRAYFLUORO, "XRAY Radiofluoroscopic Image Storage", "NEMA"},
    {UID_CLASS_K_SOPCLASS, DICOM_SOPCLASSPET, "Positron Emission Tomography Image Storage", "NEMA"},
    {UID_CLASS_K_SOPCLASS, DICOM_SOPCLASSSTANDALONEPETCURVE, "Standalone PET Curve Storage", "NEMA"},
    {UID_CLASS_K_SOPCLASS, DICOM_SOPRTIMAGESTORAGE, "RT Image Storage", "NEMA"},
    {UID_CLASS_K_SOPCLASS, DICOM_SOPRTDOSESTORAGE, "RT Dose Storage", "NEMA"},
    {UID_CLASS_K_SOPCLASS, DICOM_SOPRTSTRUCTURESETSTORAGE,
    "RT Structure Set Storage", "NEMA"},
    {UID_CLASS_K_SOPCLASS, DICOM_SOPRTPLANSTORAGE, "RT Plan Storage", "NEMA"},
	//
	// Visible light
	//
	{UID_CLASS_K_SOPCLASS, DICOM_SOPCLASSVLENDOSCOPY, "VL Endoscopic Image Storage", "NEMA"},
	{UID_CLASS_K_SOPCLASS, DICOM_SOPCLASSVLMICROSCOPY, "VL Microscopic Image Storage", "NEMA"},
	{UID_CLASS_K_SOPCLASS, DICOM_SOPCLASSVLSLIDECOORDS, "VL Slide-Coordinates Microscopic Image Storage", "NEMA"},
	{UID_CLASS_K_SOPCLASS, DICOM_SOPCLASSVLPHOTO, "VL Photographic Image Storage", "NEMA"},
	//
	// Digital X-Ray
	//
	{UID_CLASS_K_SOPCLASS, DICOM_SOPCLASSDXPRESENT, "Digital X-Ray Image Storage - For Presentation", "NEMA"},
	{UID_CLASS_K_SOPCLASS, DICOM_SOPCLASSDXPROCESS, "Digital X-Ray Image Storage - For Processing", "NEMA"},
	{UID_CLASS_K_SOPCLASS, DICOM_SOPCLASSDXMAMMOPRES, "Digital Mammography Image Storage - For Presentation", "NEMA"},
	{UID_CLASS_K_SOPCLASS, DICOM_SOPCLASSDXMAMMOPROC, "Digital Mammography Image Storage - For Processing", "NEMA"},
	{UID_CLASS_K_SOPCLASS, DICOM_SOPCLASSDXORALPRES, "Digital Intra-oral X-Ray Image Storage - For Presentation", "NEMA"},
	{UID_CLASS_K_SOPCLASS, DICOM_SOPCLASSDXORALPROC, "Digital Intra-oral X-Ray Image Storage - For Processing", "NEMA"},


    {UID_CLASS_K_SOPCLASS, DICOM_SOPPATIENTQUERY_FIND,
    "Patient Root Query/Retrieve Information Model-FIND", "NEMA"},
    {UID_CLASS_K_SOPCLASS, DICOM_SOPPATIENTQUERY_MOVE,
    "Patient Root Query/Retrieve Information Model-MOVE", "NEMA"},
    {UID_CLASS_K_SOPCLASS, DICOM_SOPPATIENTQUERY_GET,
    "Patient Root Query/Retrieve Information Model-GET", "NEMA"},
    {UID_CLASS_K_SOPCLASS, DICOM_SOPSTUDYQUERY_FIND,
    "Study Root Query/Retrieve Information Model-FIND", "NEMA"},
    {UID_CLASS_K_SOPCLASS, DICOM_SOPSTUDYQUERY_MOVE,
    "Study Root Query/Retrieve Information Model-MOVE", "NEMA"},
    {UID_CLASS_K_SOPCLASS, DICOM_SOPSTUDYQUERY_GET,
    "Study Root Query/Retrieve Information Model-GET", "NEMA"},
    {UID_CLASS_K_SOPCLASS, DICOM_SOPPATIENTSTUDYQUERY_FIND,
    "Patient/Study Only Query/Retrieve Information Model-FIND", "NEMA"},
    {UID_CLASS_K_SOPCLASS, DICOM_SOPPATIENTSTUDYQUERY_MOVE,
    "Patient/Study Only Query/Retrieve Information Model-MOVE", "NEMA"},
    {UID_CLASS_K_SOPCLASS, DICOM_SOPPATIENTSTUDYQUERY_GET,
    "Patient/Study Only Query/Retrieve Information Model-GET", "NEMA"},
    {UID_CLASS_K_SOPCLASS, DICOM_SOPMODALITYWORKLIST_FIND,
    "Modality Worklist Information Model-FIND", "NEMA"}
};

/* UID_Lookup
**
** Purpose:
**	Lookup the specified UID in the table of valid UIDs and return the
**	description.
**
** Parameter Dictionary:
**	UID		UID to be looked up
**	description	The corresponding description to be returned to caller
**
** Return Values:
**
**	UID_NORMAL
**	UID_UIDNOTFOUND
**
** Notes:
**
** Algorithm:
**	Description of the algorithm (optional) and any other notes.
*/
CONDITION
UID_Lookup(char *UID, UID_DESCRIPTION * description)
{
    int
        index;

    for (index = 0; index < (int) DIM_OF(table); index++) {
	if (strcmp(UID, table[index].UID) == 0) {
	    *description = table[index];
	    return UID_NORMAL;
	}
    }
    strcpy(description->UID, UID);
    strcpy(description->description, "UID Not Found");
    strcpy(description->originator, "NONE");
    return COND_PushCondition(UID_UIDNOTFOUND, UID_Message(UID_UIDNOTFOUND),
			      UID, "UID_Lookup");
}

void
    UID_ScanDictionary(void (*callback) (const UID_DESCRIPTION * d1, void *ctx1),
		           void *ctx) {
    int index;

    for (index = 0; index < (int) DIM_OF(table); index++) {
	callback(&table[index], ctx);
    }
}

/* ============================================================
** Define private functions below.
*/

/* readUIDFile
**
** Purpose:
**	Read the UID block from the UID file
**
** Parameter Dictionary:
**	block		The UID block to be read from the UID file and returned
**			to caller
**
** Return Values:
**
**	UID_FILEOPENFAILURE
**	UID_ILLEGALNUMERIC
**	UID_ILLEGALROOT
**	UID_NODEVICETYPE
**	UID_NORMAL
**	UID_NOROOT
**	UID_NOUIDFILENAME
**
** Notes:
**
** Algorithm:
**	Description of the algorithm (optional) and any other notes.
*/

static CONDITION
readUIDFile(UID_BLOCK * block)
{
    CONDITION
    cond;
    FILE
	* f;
    static UID_BLOCK
        b;
    int
        index;
    char
        buffer[120],
        keyWord[120];

    static BLOCK_MAP map[] = {
	{"PATIENT", &b.patient},
	{"VISIT", &b.visit},
	{"STUDY", &b.study},
	{"SERIES", &b.series},
	{"IMAGE", &b.image},
	{"RESULTS", &b.results},
	{"INTERPRETATION", &b.interpretation},
	{"PRINTER", &b.printer},
	{"DEVICE", &b.deviceType},
	{"SERIAL", &b.serialNumber},
	{"STUDYCOMPONENT", &b.studyComponent},
	{"STORAGECOMMITTRANSACTION", &b.storageCommitTransaction}
    };

    cond = getUIDFile();
    if (cond != UID_NORMAL)
	return cond;

    (void) memset(&b, 0, sizeof(b));

    f = fopen(uidFile, "r");
    if (f == NULL)
	return COND_PushCondition(UID_FILEOPENFAILURE,
				  UID_Message(UID_FILEOPENFAILURE), uidFile);

    while (fgets(buffer, sizeof(buffer), f) != NULL) {
	if (sscanf(buffer, "%s", keyWord) == 1) {
	    if (strcmp(keyWord, "ROOT") == 0) {
		if (sscanf(buffer, "%s %s", keyWord, b.root) != 2)
		    return COND_PushCondition(UID_ILLEGALROOT,
				      UID_Message(UID_ILLEGALROOT), buffer);
	    } else {
		for (index = 0; index < (int) DIM_OF(map); index++) {
		    if (strcmp(keyWord, map[index].keyWord) == 0) {
			if (sscanf(buffer, "%s %ld", keyWord, map[index].value) != 2)
			    return COND_PushCondition(UID_ILLEGALNUMERIC,
				   UID_Message(UID_ILLEGALNUMERIC), buffer);
		    }
		}
	    }
	}
    }

    (void) fclose(f);
    if (b.deviceType == 0)
	return COND_PushCondition(UID_NODEVICETYPE, UID_Message(UID_NODEVICETYPE),
				  uidFile);
    if (strlen(b.root) == 0)
	return COND_PushCondition(UID_NOROOT, UID_Message(UID_NOROOT),
				  uidFile);
    *block = b;
    return UID_NORMAL;
}

/* writeUIDFile
**
** Purpose:
**	Write a UID block into the UID file.
**
** Parameter Dictionary:
**	block		UID block to be written
**
** Return Values:
**
**	UID_FILECREATEFAILURE
**	UID_NORMAL
**	UID_NOUIDFILENAME
**
** Notes:
**
** Algorithm:
**	Description of the algorithm (optional) and any other notes.
*/

static CONDITION
writeUIDFile(UID_BLOCK * block)
{
    CONDITION
    cond;
    FILE
	* f;

    int
        index;
    static UID_BLOCK
        b;
    static BLOCK_MAP map[] = {
	{"PATIENT", &b.patient},
	{"VISIT", &b.visit},
	{"STUDY", &b.study},
	{"SERIES", &b.series},
	{"IMAGE", &b.image},
	{"RESULTS", &b.results},
	{"INTERPRETATION", &b.interpretation},
	{"PRINTER", &b.printer},
	{"DEVICE", &b.deviceType},
	{"SERIAL", &b.serialNumber},
	{"STUDYCOMPONENT", &b.studyComponent},
	{"STORAGECOMMITTRANSACTION", &b.storageCommitTransaction}
    };

    cond = getUIDFile();
    if (cond != UID_NORMAL)
	return cond;

    f = fopen(uidFile, "w");
    if (f == NULL)
	return COND_PushCondition(UID_FILECREATEFAILURE,
			       UID_Message(UID_FILECREATEFAILURE), uidFile);

    b = *block;
    fprintf(f, "ROOT %s\n", block->root);
    for (index = 0; index < (int) DIM_OF(map); index++)
	fprintf(f, "%s %20d\n", map[index].keyWord, *map[index].value);

    (void) fclose(f);

    return UID_NORMAL;
}

/* getUIDFile
**
** Purpose:
**	Get the name of the UID file from the environment variable UIDFILE
**
** Parameter Dictionary:
**	None
**
** Return Values:
**
**	UID_NORMAL
**	UID_NOUIDFILENAME
**
** Notes:
**
** Algorithm:
**	Description of the algorithm (optional) and any other notes.
*/

static CONDITION
getUIDFile()
{
    char
       *tmp;

    if (strlen(uidFile) == 0) {
	tmp = getenv("UIDFILE");
	if (tmp == NULL) {
	    return COND_PushCondition(UID_NOUIDFILENAME,
				      UID_Message(UID_NOUIDFILENAME));
	}
	(void) strcpy(uidFile, tmp);
    }
    return UID_NORMAL;
}
