
/*
+-+-+-+-+-+-+-+-+-
*/
/*
**				DICOM 93
**		     Electronic Radiology Laboratory
**		   Mallinckrodt Institute of Radiology
**		Washington University School of Medicine
**
** Module Name(s):
** Author, Date:	Aniruddha Gokhale
**			Tze Lee
** Intent:
** Last Update:		$Author: Vhaiswstarkm $, $Date: 11/04/10 9:12a $
** Source File:		$Source: /sw2/prj/ctn/cvs/apps/print_clients/print_client.h,v $
** Revision:		$Revision: 1 $
** Status:		$State: Exp $
*/

CONDITION
initNetwork(DUL_ASSOCIATESERVICEPARAMETERS * params,
	    DUL_NETWORKKEY ** network);

CONDITION
establishAssociation(DUL_ASSOCIATESERVICEPARAMETERS * params,
		     DUL_NETWORKKEY ** network,
		     char *SOPClass,
		     DUL_ASSOCIATIONKEY ** association);

CONDITION
sendGetPrinterInstance(DUL_ASSOCIATIONKEY ** association,
		       DUL_ASSOCIATESERVICEPARAMETERS * params,
		       char *SOPClass,
		       PRINTER_ATTRIBUTES * printAttrib);

CONDITION
sendCreateFilmSession(DUL_ASSOCIATIONKEY ** association,
		      DUL_ASSOCIATESERVICEPARAMETERS * params,
		      char *SOPClass,
		      BFS_ATTRIBUTES * bfsAttributes);
CONDITION
sendCreateFilmBox(DUL_ASSOCIATIONKEY ** association,
		  DUL_ASSOCIATESERVICEPARAMETERS * params,
		  char *SOPClass,
		  BFB_ATTRIBUTES * bfbAttributes);
