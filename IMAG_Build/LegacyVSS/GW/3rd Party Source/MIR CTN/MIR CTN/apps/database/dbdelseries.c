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
** Module Name(s):	dbdelseries (main())
** Author, Date:	David E. Beecher, 4-Jul-93
** Intent:		Delete a series from a DICOM database
** Last Update:		$Author: Vhaiswstarkm $, $Date: 11/04/10 9:09a $
** Source File:		$RCSfile: dbdelseries.c,v $
** Revision:		$Revision: 1 $
** Status:		$State: Exp $
*/

static char rcsid[] = "$Revision: 1 $ $RCSfile: dbdelseries.c,v $";
#include <stdio.h>
#include "dicom.h"
#include "dbquery.h"

main(int argc, char *argv[])
{

    CONDITION
	ret;
    short
        id;
    char
        patid[50],
        studyuid[50],
        seriesuid[50],
        dbname[50];

    if (argc != 5) {
	printf("Usage: %s SeriesUID PatID StudyUID dbname\n",
	       argv[0]);
	exit(0);
    }
    strcpy(seriesuid, argv[1]);
    strcpy(patid, argv[2]);
    strcpy(studyuid, argv[3]);
    strcpy(dbname, argv[4]);

    printf(" SeriesUID: %s\n", seriesuid);
    printf("patient id: %s\n", patid);
    printf(" study uid: %s\n", studyuid);
    printf("   DB Name: %s\n", dbname);

    if (DB_Open(dbname, &id) == DB_NORMAL)
	printf("DB_Open succeeded\n");
    else {
	printf("DB_Open failed\n");
	exit(1);
    }

    if ((ret = DB_DelSeries(id, patid, studyuid, seriesuid)) == DB_NORMAL)
	printf("%s succeeded\n", argv[0]);
    else
	printf("Another error occurred: %08x\n", ret);

    if (DB_Close(id) == DB_NORMAL)
	printf("DB_Close succeeded\n");
    else
	exit(0);
}
