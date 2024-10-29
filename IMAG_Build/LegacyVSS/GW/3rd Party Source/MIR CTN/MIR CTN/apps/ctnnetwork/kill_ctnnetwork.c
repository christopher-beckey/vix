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
** Module Name(s):	kill_ctnnetwork (main())
** Author, Date:	David E. Beecher, 4-Jul-93
** Intent:		Kill a ctnnetwork process.
** Last Update:		$Author: Vhaiswstarkm $, $Date: 11/04/10 9:08a $
** Source File:		$RCSfile: kill_ctnnetwork.c,v $
** Revision:		$Revision: 1 $
** Status:		$State: Exp $
*/

static char rcsid[] = "$Revision: 1 $ $RCSfile: kill_ctnnetwork.c,v $";
#include <stdio.h>
#include <stdlib.h>
#include <string.h>
#include "dicom.h"
#include "ctnthread.h"
#include "condition.h"
#include "iqueues.h"
#include "gq.h"

main(int argc, char *argv[])
{

    int
        qid;

    CTNNETWORK_Queue
	e;

    if (argc != 2) {
	printf("\nUsage: %s <queue_number>\n\n", argv[0]);
	exit(0);
    }
    THR_Init();
    qid = atoi(argv[1]);
    if (GQ_GetQueue(qid, sizeof(CTNNETWORK_Queue)) != GQ_NORMAL) {
	printf("\nGQ_GetQueue failed!\n\n");
	COND_DumpConditions();
	THR_Shutdown();
	exit(-1);
    }
    strcpy(e.vendorid, "KILL_DISPLAY");
    if (GQ_Enqueue(qid, (void *) &e) != GQ_NORMAL) {
	printf("\nGQ_Enqueue failed!\n\n");
	COND_DumpConditions();
	THR_Shutdown();
	exit(-1);
    }
    sleep(5);
    if (GQ_KillQueue(qid) != GQ_NORMAL) {
	printf("\nGQ_KillQueue failed!\n\n");
	COND_DumpConditions();
	THR_Shutdown();
	exit(-1);
    }
    THR_Shutdown();
    exit(0);
}
