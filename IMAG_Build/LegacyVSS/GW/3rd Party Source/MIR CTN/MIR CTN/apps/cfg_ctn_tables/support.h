/*
+-+-+-+-+-+-+-+-+-
*/
/*
**		     Electronic Radiology Laboratory
**		   Mallinckrodt Institute of Radiology
**		Washington University School of Medicine
**
** Module Name(s):
** Author, Date:	Steve Moore, 29-Aug-94
** Intent:		Define structures and prototypes for supporting
**			functions for cfg application.
** Last Update:		$Author: Vhaiswstarkm $, $Date: 11/04/10 9:08a $
** Source File:		$RCSfile: support.h,v $
** Revision:		$Revision: 1 $
** Status:		$State: Exp $
*/

CONDITION extractGroups(LST_HEAD * src, LST_HEAD * dst);
CONDITION extractTitles(LST_HEAD * src, char *group, LST_HEAD * dst);
