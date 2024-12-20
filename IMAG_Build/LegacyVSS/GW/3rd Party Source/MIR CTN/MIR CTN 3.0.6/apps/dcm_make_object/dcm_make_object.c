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
**			main
**			usageerror
**			addElement
**			addpixels
**			fileSize
** Author, Date:	Stephen M. Moore, 5-Jun-93
** Intent:		Simple program which reads an ASCII description of
**			a DICOM object, creates the object and writes it
**			to a file.
** Last Update:		$Author: Vhaiswstarkm $, $Date: 11/04/10 9:22a $
** Source File:		$RCSfile: dcm_make_object.c,v $
** Revision:		$Revision: 1 $
** Status:		$State: Exp $
*/

static char rcsid[] = "$Revision: 1 $ $RCSfile: dcm_make_object.c,v $";

#include <stdio.h>
#include <stdlib.h>
#include <string.h>
#ifdef _MSC_VER
#include <io.h>
#include <fcntl.h>
#else
#include <sys/file.h>
#endif
#ifdef SOLARIS
#include <sys/fcntl.h>
#endif
#include <sys/types.h>
#include <sys/stat.h>
#include "dicom.h"
#include "ctnthread.h"
#include "lst.h"
#include "condition.h"
#include "dicom_objects.h"

static void usageerror();
static CONDITION
addElement(int group, int element, char *data,
	   DCM_OBJECT ** object);
static void addpixels(DCM_OBJECT ** object, char *pixelfile);
static int fileSize(int fd);

main(int argc, char **argv)
{
    DCM_OBJECT
	* object;
    CONDITION
	cond;
    char
        buffer[1024],
        data[1024];
    int
        group,
        element;
    char
       *pixelfile = NULL;
    CTNBOOLEAN
	verbose = FALSE;

    while (--argc > 0 && (*++argv)[0] == '-') {
	switch (*(argv[0] + 1)) {
	case 'p':
	    argc--;
	    argv++;
	    pixelfile = *argv;
	    break;
	case 'v':
	    verbose = TRUE;
	    break;
	default:
	    fprintf(stderr, "Unrecognized option: %c\n", *(argv[0] + 1));
	    break;
	}
    }
    if (argc < 1)
	usageerror();

    THR_Init();
    DCM_Debug(verbose);
    cond = DCM_CreateObject(&object, 0);
    if (cond != DCM_NORMAL) {
	COND_DumpConditions();
	THR_Shutdown();
	exit(1);
    }
    while (fgets(buffer, sizeof(buffer), stdin) != NULL) {
	printf("%s", buffer);
	if (buffer[0] != '#') {
	    if (sscanf(buffer, "%x %x %[^\n]", &group, &element, data) != 3) {
		fprintf(stderr, "Error parsing: %s\n", buffer);
		THR_Shutdown();
		exit(1);
	    }
	    printf("%04x %04x \n%s\n", group, element, data);
	    cond = addElement(group, element, data, &object);
	    if (cond != DCM_NORMAL) {
		COND_DumpConditions();
		THR_Shutdown();
		exit(1);
	    }
	}
    }
    if (pixelfile != NULL)
	addpixels(&object, pixelfile);

    (void) DCM_DumpElements(&object, 0);
    cond = DCM_WriteFile(&object, DCM_ORDERLITTLEENDIAN, *argv);
    if (cond != DCM_NORMAL)
	COND_DumpConditions();
    (void) DCM_CloseObject(&object);
    THR_Shutdown();
    return 0;
}


/* usageError
**
** Purpose:
**	Displays the correct way of invoking the command with all the options
**
** Parameter Dictionary:
**	None
**
** Return Values:
**	None
**
** Notes:
**
** Algorithm:
**	Description of the algorithm (optional) and any other notes.
*/

static void
usageerror()
{
    char msg[] = "\
Usage: dcm_make_object [-p pixels] [-v] file\n\
\n\
    -p pixels  Read raw pixel data from this file and add as 7Fe0 0010 \n\
    -v         Place DCM facility in verbose mode\n\
\n\
    file       The file created\n";

    fprintf(stderr, msg);
    exit(1);
}


/* addElement
**
** Purpose:
**	Adds an element to a DICOM object
**
** Parameter Dictionary:
**	group		Group number of the element to be added
**	element		The element to be added
**	data		The actual data that goes in the object
**	object		Handle to the DICOM object to which the element is
**			added
**
** Return Values:
**
**	DCM_ILLEGALOBJECT
**	DCM_ILLEGALREPRESENTATION
**	DCM_INSERTFAILED
**	DCM_NORMAL
**	DCM_NULLOBJECT
**	DCM_UNRECOGNIZEDELEMENT
**	DCM_UNRECOGNIZEDGROUP
**
** Notes:
**
** Algorithm:
**	Description of the algorithm (optional) and any other notes.
*/

static CONDITION
addElement(int group, int element, char *data,
	   DCM_OBJECT ** object)
{
    CONDITION
    cond;
    DCM_ELEMENT
	e;
    int
        i;
    U16
	ush;
    U32
	ulo;
    S16
	ssh;
    S32
	slo;

    e.tag = DCM_MAKETAG(group, element);
    cond = DCM_LookupElement(&e);
    if (cond != DCM_NORMAL)
	return cond;

    switch (e.representation) {
    case DCM_AE:		/* Application Entity */
    case DCM_AT:		/* Attribute tag */
    case DCM_DD:		/* Data set */
    case DCM_FD:		/* Floating double */
    case DCM_FL:		/* Float */
    case DCM_OT:		/* Other binary value */
    case DCM_SQ:		/* Sequence of items */
    case DCM_UN:		/* Unknown/unspecified */
    case DCM_RET:		/* Retired */
    case DCM_CTX:		/* Context sensitive */
	printf("The representation for (%04x %04x) is unimplemented\n",
	       group, element);
	e.d.ot = NULL;
	break;
    case DCM_AS:		/* Age String */
    case DCM_CS:		/* Control string */
    case DCM_DA:		/* Date */
    case DCM_DS:		/* Decimal string */
    case DCM_IS:		/* Integer string */
    case DCM_LT:		/* Long text */
    case DCM_LO:		/* Long string */
    case DCM_PN:		/* Person Name */
    case DCM_SH:		/* Short string */
    case DCM_ST:		/* Short text */
    case DCM_TM:		/* Time */
    case DCM_UI:		/* Unique identifier (UID) */
	if (strcmp(data, "#") == 0)
	    e.length = 0;
	else
	    e.length = strlen(data);
	e.d.string = data;
	break;
    case DCM_SL:		/* Signed long */
	if (strcmp(data, "#") == 0)
	    e.length = 0;
	else {
	    if (sscanf(data, "%d", &i) != 1) {
		fprintf(stderr, "Error parsing %s as signed long\n", data);
		return 0;
	    }
	    e.length = sizeof(slo);
	    slo = (S32) i;
	}
	e.d.sl = &slo;
	break;
    case DCM_SS:		/* Signed short */
	if (strcmp(data, "#") == 0)
	    e.length = 0;
	else {
	    if (sscanf(data, "%d", &i) != 1) {
		fprintf(stderr, "Error parsing %s as signed short\n", data);
		return 0;
	    }
	    e.length = sizeof(ssh);
	    ssh = (S16) i;
	}
	e.d.ss = &ssh;
	break;
    case DCM_UL:		/* Unsigned long */
	if (strcmp(data, "#") == 0)
	    e.length = 0;
	else {
	    if (sscanf(data, "%d", &i) != 1) {
		fprintf(stderr, "Error parsing %s as unsigned long\n", data);
		return 0;
	    }
	    e.length = sizeof(ulo);
	    ulo = (U32) i;
	}
	e.d.ul = &ulo;
	break;
    case DCM_US:		/* Unsigned short */
	if (strcmp(data, "#") == 0)
	    e.length = 0;
	else {
	    if (sscanf(data, "%d", &i) != 1) {
		fprintf(stderr, "Error parsing %s as unsigned short\n", data);
		return 0;
	    }
	    e.length = sizeof(ush);
	    ush = (U16) i;
	}
	e.d.us = &ush;
	break;
    default:
	fprintf(stderr,
		"Should not reach default for element (%04x %04x)\n",
		group, element);
	e.d.ot = NULL;
    }

    if (e.d.ot != NULL)
	cond = DCM_AddElement(object, &e);
    else
	cond = 0;

    return cond;
}


/* addPixels
**
** Purpose:
**	Add pixel data to the DICOM object
**
** Parameter Dictionary:
**	object		Handle to the object to which the pixel data is to be
**			added
**	pixelfile	Name of file containing pixel data
**
** Return Values:
**	None
**
** Notes:
**
** Algorithm:
**	Description of the algorithm (optional) and any other notes.
*/

static void
addpixels(DCM_OBJECT ** object, char *pixelfile)
{
    int
        fd,
        size;
    unsigned char
       *p;

    DCM_ELEMENT e = {DCM_PXLPIXELDATA, DCM_OT, "", 0, 0, NULL};
    CONDITION
	cond;

    fd = open(pixelfile, O_RDONLY);
    if (fd < 0) {
	perror(pixelfile);
	exit(1);
    }
    size = fileSize(fd);
    if (size < 0) {
	perror(pixelfile);
	exit(1);
    }
    p = (unsigned char *) malloc(size);
    if (p == NULL) {
	perror("");
	exit(1);
    }
    e.length = (unsigned long) size;
    e.d.ot = p;
    if (read(fd, p, size) != size) {
	perror(pixelfile);
	exit(1);
    }
    cond = DCM_AddElement(object, &e);
    if (cond != DCM_NORMAL) {
	COND_DumpConditions();
	exit(1);
    }
}

/* fileSize
**
** Purpose:
**	Returns the file size
**
** Parameter Dictionary:
**	fd	File descriptor
**
** Return Values:
**	Size of file on success
**	Error status if error.
**
** Notes:
**
** Algorithm:
**	Description of the algorithm (optional) and any other notes.
*/

static int
fileSize(int fd)
{
    int
        status;
    struct stat
        im_stat;

    status = fstat(fd, &im_stat);
    if (status < 0) {
	return status;
    } else
	return im_stat.st_size;
}
