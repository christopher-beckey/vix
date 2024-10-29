
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
**                      ncreateBFSCallback
**                      ncreateBFBCallback
**                      nsetBIBCallback
**                      nactionCallback
**                      ndeleteCallback
**
** Author, Date:	Aniruddha S. Gokhale, August 4, 1993.
** Intent:		This module declares the prototypes of all the
**			call back routines that are called by the SRV
**			Request routines.
** Last Update:		$Author: Vhaiswstarkm $, $Date: 11/04/10 9:24a $
** Source File:		$Source: /sw2/prj/ctn/cvs/apps/print_clients/print_callback.h,v $
** Revision:		$Revision: 1 $
** Status:		$State: Exp $
*/

/* prototype declarations of private functions used */

#ifdef SMM
CONDITION
ncreateBFSCallback(MSG_N_CREATE_REQ * createRequest,
		   MSG_N_CREATE_RESP * createResponse,
		   void *ctx);
CONDITION
ncreateBFBCallback(MSG_N_CREATE_REQ * createRequest,
		   MSG_N_CREATE_RESP * createResponse,
		   void *ctx);
CONDITION
nsetBIBCallback(MSG_N_SET_REQ * setRequest,
		MSG_N_SET_RESP * setResponse,
		void *ctx);
CONDITION
nactionCallback(MSG_N_ACTION_REQ * actionRequest,
		MSG_N_ACTION_RESP * actionResponse,
		void *ctx);
CONDITION
ndeleteCallback(MSG_N_DELETE_REQ * deleteRequest,
		MSG_N_DELETE_RESP * deleteResponse,
		void *ctx);
#endif
