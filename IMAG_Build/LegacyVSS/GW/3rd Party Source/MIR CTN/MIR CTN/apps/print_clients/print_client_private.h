
/*
+-+-+-+-+-+-+-+-+-
*/
/*
**				DICOM 93
**		     Electronic Radiology Laboratory
**		   Mallinckrodt Institute of Radiology
**		Washington University School of Medicine
**
** Module Name(s):	sendGetPrinterInstance
**			sendCreateFilmSession
**			sendCreateFilmBox
**			sendSetImageBox
**
** Author, Date:	Aniruddha S. Gokhale, August 9th, 1993
** Intent:		Prototype declarations of the private
**			functions used by the print_client program
** Last Update:		$Author: Vhaiswstarkm $, $Date: 11/04/10 9:12a $
** Source File:		$Source: /sw2/prj/ctn/cvs/apps/print_clients/print_client_private.h,v $
** Revision:		$Revision: 1 $
** Status:		$State: Exp $
*/

#ifdef SMM
/* prototype declarations of private functions used */
BOOLEAN
sendGetPrinterInstance(DUL_ASSOCIATIONKEY ** association,
		       DUL_ASSOCIATESERVICEPARAMETERS * params,
		       char *SOPClass);
BOOLEAN
sendCreateFilmSession(DUL_ASSOCIATIONKEY ** association,
		      DUL_ASSOCIATESERVICEPARAMETERS * params,
		      BFS_ATTRIBUTES * bfsAttributes,
		      char *SOPClass);
BOOLEAN
sendCreateFilmBox(DUL_ASSOCIATIONKEY ** association,
		  DUL_ASSOCIATESERVICEPARAMETERS * params,
		  char *SOPClass,
		  char *format,
		  DCM_ELEMENT e[]);
BOOLEAN
sendSetImageBox(DUL_ASSOCIATIONKEY ** association,
		DUL_ASSOCIATESERVICEPARAMETERS * params,
		char *SOPClass,
		char *uid,
		int position,
		DCM_OBJECT * preformattedImag);
#endif
