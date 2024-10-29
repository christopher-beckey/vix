/*
          Copyright (C) 1993, RSNA and Washington University

          The software and supporting documentation for the Radiological
          Society of North America (RSNA) 1993 Digital Imaging and
          Communications in Medicine (DICOM) Demonstration were developed
          at the
                  Electronic Radiology Laboratory
                  Mallinckrodt Institute of Radiology
                  Washington University School of Medicine
                  510 S. Kingshighway Blvd.
                  St. Louis, MO 63110
          as part of the 1993 DICOM Central Test Node project for, and
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
/*
** @$=@$=@$=
*/
/*
**				DICOM 93
**		     Electronic Radiology Laboratory
**		   Mallinckrodt Institute of Radiology
**		Washington University School of Medicine
**
** Module Name(s):
** Author, Date:	Stephen M. Moore, 1-May-93
** Intent:		Define the ASCIZ messages that go with condition
**			codes and provide a function that returns a pointer
**			to a particular message (given a code).
** Last Update:		$Author: Vhaiswstarkm $, $Date: 3/28/11 4:42p $
** Source File:		$RCSfile: lstcond.c,v $
** Revision:		$Revision: 1 $
** Status:		$State: Exp $
*/

static char rcsid[] = "$Revision: 1 $ $RCSfile: lstcond.c,v $";

#include <stdio.h>
#include <string.h>
#include <stddef.h>

#include "dicom.h"
#include "lstprivate.h"
#include "lst.h"

typedef struct vector {
    CONDITION cond;
    char *message;
}   VECTOR;

static VECTOR messageVector[] = {
    {LST_NORMAL, "Normal return from LST routine"},
    {LST_LISTNOTEMPTY, "Destroy requested on nonempty list"},
    {LST_BADEND, "Bad END requested in LST routine"},
    {LST_NOCURRENT, "No current node in LST routine"},
    {0, NULL}
};

char *
LST_Message(CONDITION condition)
{
    int
        index;

    for (index = 0; index < DIM_OF(messageVector); index++)
	if (condition == messageVector[index].cond)
	    return messageVector[index].message;

    return NULL;
}
