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
**		     Electronic Radiology Laboratory
**		   Mallinckrodt Institute of Radiology
**		Washington University School of Medicine
**
** Module Name(s):	TBL_Open
**			TBL_Close
**			TBL_Select
**			TBL_Update
**			TBL_Insert
**			TBL_Delete
**			TBL_Debug
** Author, Date:	David E. Beecher, 28-Feb-94
** Intent:		Provide a general set of functions to be performed
**			on tables in a relational database.
** Last Update:		$Author: Vhaiswstarkm $, $Date: 11/04/10 9:29a $
** Source File:		$RCSfile: tbl_msql.c,v $
** Revision:		$Revision: 1 $
** Status:		$State: Exp $
*/

static char rcsid[] = "$Revision: 1 $ $RCSfile: tbl_msql.c,v $";

#include <stdlib.h>
#include <stdio.h>
#include <sys/types.h>
#include <string.h>
#ifdef MALLOC_DEBUG
#include "malloc.h"
#endif
#include "dicom.h"
#include "condition.h"
#include "tblprivate.h"
#include "tbl.h"

#ifdef CTN_USE_THREADS
#include "ctnthread.h"
#endif

#ifdef MSQL

#include "tbl_msql.h"

#include "msql.h"


/*
** Static Globals for this file...
*/
static int
    G_MsqlError = 0;
static TBL_CONTEXT
*   G_ContextHead = (TBL_CONTEXT *) NULL;

static char
   *G_DBSelect = (char *) NULL;

static int
    G_DBSelectSize = 0;

static char
   *G_DBOpen = (char *) NULL,
   *G_DBInsert = (char *) NULL,
   *G_DBUpdate = (char *) NULL,
   *G_DBDelete = (char *) NULL,
   *G_DBNextUnique = (char *) NULL;

static int
    G_Msql_Sock = -1,
    G_OpenFlag = 0;

static CTNBOOLEAN
    G_Verbose = FALSE;

CONDITION
TBL_SetOption(const char *string)
{
    return TBL_NORMAL;
}

int
TBL_HasViews(void)
{
    return 0;
}

int
TBL_HasUpdateIncrement(void)
{
    return 0;
}

/* TBL_Debug
**
** Purpose:
**	Simple function to switch on/off Msql debug messages.
**
** Parameter Dictionary:
**	CTNBOOLEAN flag: the flag that controls the messages
**
** Return Values:
**	TBL_NORMAL: normal termination.
**
** Notes:
**	The initial state of the debugging messages is off (FALSE).
**
** Algorithm:
**	If flag evaluates to true, the global variable G_Verbose is
*	set (to TRUE) otherwise it is reset (to FALSE);
*/
CONDITION
TBL_Debug(CTNBOOLEAN flag)
{

    if (flag == TRUE)
	putenv("MINERVA_DEBUG=query");
    else
	putenv("MINERVA_DEBUG=");

    return TBL_NORMAL;

}

/* TBL_Open
**
** Purpose:
**	This function "opens" the specified table in the specified
**	database.  It creates a new handle for this particular table
**	and passes that identifier back to the user.
**
** Parameter Dictionary:
**	char *databaseName: The name of the database to open.
**	char *tableName: The name of the table to open in the
**		aforementioned database.
**	TBL_HANDLE **handle: The pointer for the new identifier
**		created for this database/table pair is returned
**		through handle.
**
** Return Values:
**	TBL_NORMAL: normal termination.
**	TBL_DBINITFAILED: The initial database open failed.
**	TBL_ALREADYOPENED: The table/database pair has been opened
**		previously and may not be opened again without
**		first closing it.
**	TBL_DBNOEXIST: The database specified as a calling parameter
**		does not exist.
**	TBL_TBLNOEXIST: The table specified as a calling parameter
**		does not exist within the specified database.
**	TBL_NOMEMORY: There is no memory available from the system.
**
** Notes:
**	Nothing unusual.
**
** Algorithm:
**	The first time TBL_Open is invoked, special routines
**	are called to allocate the communication structures needed
**	for subsequent operations.  A check is made to ensure that
**	this table/database pair has not already been opened.  A
**	unique handle(address) is then created for this pair and
**	returned to the user for subsequent table operations.
*/

CONDITION
TBL_Open(const char *databaseName, const char *tableName, TBL_HANDLE ** handle)
{
    TBL_CONTEXT
	* tc;
    char
       *sn,
        server_name[50],
       *tdb,
       *ttb;

    (*handle) = (void *) NULL;

#ifdef CTN_USE_THREADS
    THR_ObtainMutex(FAC_TBL);
#endif

    tc = G_ContextHead;
    while (tc != (TBL_CONTEXT *) NULL) {
	if ((strcmp(tc->databaseName, databaseName) == 0) &&
	    (strcmp(tc->tableName, tableName) == 0)) {
	    tc->refCount++;
	    (*handle) = (void *) tc;
	    G_OpenFlag++;
#ifdef CTN_USE_THREADS
	    THR_ReleaseMutex(FAC_TBL);
#endif
	    return TBL_NORMAL;


	    /* 27-May-1998, Allow multiple callers to have same open DB */
#if 0
	    return COND_PushCondition(TBL_ERROR(TBL_ALREADYOPENED),
				      "TBL_Open",
				      databaseName, tableName);
#endif
	}
	tc = tc->next;
    }

    if (G_OpenFlag == 0) {
	if ((sn = getenv("CTN_MSQL_SERVER")) == NULL)
	    strcpy(server_name, "");
	else
	    strcpy(server_name, sn);

	if ((G_Msql_Sock = msqlConnect((char *) sn)) == -1) {
	    (void) COND_PushCondition(TBL_ERROR(TBL_DBSPECIFIC), "msql",
				      msqlErrMsg, "TBL_Open");
#ifdef CTN_USE_THREADS
	    THR_ReleaseMutex(FAC_TBL);
#endif
	    return COND_PushCondition(TBL_ERROR(TBL_DBINITFAILED),
				      DATABASE, "TBL_Open");
	}
    }
    if (msqlSelectDB(G_Msql_Sock, (char *) databaseName) == -1) {
	(void) COND_PushCondition(TBL_ERROR(TBL_DBSPECIFIC), "msql",
				  msqlErrMsg, "TBL_Open");
#ifdef CTN_USE_THREADS
	THR_ReleaseMutex(FAC_TBL);
#endif
	return COND_PushCondition(TBL_ERROR(TBL_DBINITFAILED), DATABASE, "TBL_Open");
    }
    /*
     * We have to assume at this point that everything will be ok...
     */
    if ((tc = (TBL_CONTEXT *) malloc(sizeof(TBL_CONTEXT))) == (TBL_CONTEXT *) NULL) {
#ifdef CTN_USE_THREADS
	THR_ReleaseMutex(FAC_TBL);
#endif
	return COND_PushCondition(TBL_ERROR(TBL_NOMEMORY), "TBL_Open");
    }
    if ((tdb = (char *) malloc(strlen(databaseName) + 1)) == (char *) NULL) {
	free(tc);
#ifdef CTN_USE_THREADS
	THR_ReleaseMutex(FAC_TBL);
#endif
	return COND_PushCondition(TBL_ERROR(TBL_NOMEMORY), "TBL_Open");
    }
    if ((ttb = (char *) malloc(strlen(tableName) + 1)) == (char *) NULL) {
	free(tc);
	free(tdb);
#ifdef CTN_USE_THREADS
	THR_ReleaseMutex(FAC_TBL);
#endif
	return COND_PushCondition(TBL_ERROR(TBL_NOMEMORY), "TBL_Open");
    }
    strcpy(tdb, databaseName);
    strcpy(ttb, tableName);
    tc->databaseName = tdb;
    tc->tableName = ttb;
    tc->refCount = 1;
    tc->next = G_ContextHead;
    G_ContextHead = tc;

    (*handle) = (void *) G_ContextHead;

    G_OpenFlag++;

#ifdef CTN_USE_THREADS
    THR_ReleaseMutex(FAC_TBL);
#endif
    return TBL_NORMAL;

}

/* TBL_Close
**
** Purpose:
**	This function "closes" the specified table in the specified
**	database.
**
** Parameter Dictionary:
**	TBL_HANDLE **handle: The pointer for the database/table pair
**		to be closed.
**
** Return Values:
**	TBL_NORMAL: normal termination.
**	TBL_CLOSERROR: The handle to be closed could not be located
**		in the internal list or no database/table pairs
**		had been opened up to this point.
**
** Notes:
**	Nothing unusual.
**
** Algorithm:
**	Locates the handle specified in the call and removes that
**	entry from the internal list maintained by this	facility.
*/
CONDITION
TBL_Close(TBL_HANDLE ** handle)
{
    TBL_CONTEXT
	* prevtc,
	*tc,
	*hc;

#ifdef CTN_USE_THREADS
    THR_ObtainMutex(FAC_TBL);
#endif

    G_OpenFlag--;
    if (G_OpenFlag == 0) {
	msqlClose(G_Msql_Sock);
    }
    hc = (TBL_CONTEXT *) (*handle);
    prevtc = tc = G_ContextHead;
    while (tc != (TBL_HANDLE *) NULL) {
	if (hc == tc) {
	    tc->refCount--;
	    if (tc->refCount > 0) {
#ifdef CTN_USE_THREADS
		THR_ReleaseMutex(FAC_TBL);
#endif
		return TBL_NORMAL;
	    }
	    free(tc->databaseName);
	    free(tc->tableName);
	    if (tc == G_ContextHead)
		G_ContextHead = tc->next;
	    else
		prevtc->next = tc->next;
	    free(tc);
	    (*handle) = (TBL_HANDLE *) NULL;
#ifdef CTN_USE_THREADS
	    THR_ReleaseMutex(FAC_TBL);
#endif
	    return TBL_NORMAL;
	}
	prevtc = tc;
	tc = tc->next;
    }

#ifdef CTN_USE_THREADS
    THR_ReleaseMutex(FAC_TBL);
#endif
    return COND_PushCondition(TBL_ERROR(TBL_CLOSERROR), "TBL_Close");
}

/* TBL_Select
**
** Purpose:
**	This function selects some number of records (possibly zero),
**	that match the criteria specifications given in the input
**	parameter criteriaList.
**
** Parameter Dictionary:
**	TBL_HANDLE **handle: The pointer for the database/table pair
**		to be accessed.  This table must be open.
**	TBL_CRITERIA *criteriaList: Contains a list of the criteria
**		to use when selecting records from the specified table.
**		A null list implies that all records will be selected.
**	TBL_FIELD *fieldList: Contains a list of the fields to be
**		retreived from each record that matches the criteria
**		specification.  It is an error to specify a null
**		fieldList.
**	int *count: Contains a number that represents the total number
**		of records retreived by this particular select.  If this
**		parameter is null, then an internal counter is used and
**		the final count will not be returned when the select
**		finishes.
**	CONDITION (*callback)(): The callback function invoked whenever
**		a new record is retreived from the database.  It is
**		invoked with parameters as described below.
**	void *ctx: Ancillary data passed through to the callback function
**		and untouched by this routine.
**
** Return Values:
**	TBL_NORMAL: normal termination.
**	TBL_BADHANDLE: The handle passed to the routine was invalid.
**	TBL_DBNOEXIST: The database specified does not exist.
**	TBL_NOFIELDLIST: A null field list pointer (fieldList *) was
**		specified.
**	TBL_SELECTFAILED: The select operation failed most probably from
**		a bad specification in the fieldList or criteriaList.  This
**		return is not the same as a valid query returning no records.
**		This error return could result from a misspelled keyword, etc.
**	TBL_EARLYEXIT: The callback routine returned something other than
**		TBL_NORMAL which caused this routine to cancel the remainder
**		of the database operation and return early.
**
** Algorithm:
**	As each record is retreived from the
**	database, the fields requested by the user (contained in
**	fieldList), are filled with the informatiton retreived from
**	the database and a pointer to the list is passed to the
**	callback routine designated by the input parameter callback.
**	The callback routine is invoked as follows:
**
**		callback(fieldList *fieldList, long count, void *ctx)
**
**	The count contains the number of records retreived to this point.
**	ctx contains any additional information the user originally passed
**	to this select function.  If callback returns any value other
**	than TBL_NORMAL, it is assumed that this function should terminate
**	(i.e. cancel the current db operation), and return an abnormal
**	termination message (TBL_EARLYEXIT) to the routine which
**	originally invoked the select.
*/
CONDITION
TBL_Select(TBL_HANDLE ** handle, const TBL_CRITERIA * criteriaList,
     TBL_FIELD * fieldList, long *count, CONDITION(*callback) (), void *ctx)
{
    TBL_CONTEXT
	* tc;
    TBL_FIELD
	* fp;
    const TBL_CRITERIA
    *   cp;
    char
       *dbName,
       *tableName;
    int
        i,
        foundit;
    long
        realcount,
       *lp;
    m_row
	row;
    m_result
	* ans;

#ifdef CTN_USE_THREADS
    THR_ObtainMutex(FAC_TBL);
#endif

    tc = G_ContextHead;
    foundit = 0;
    while (tc != (TBL_CONTEXT *) NULL) {
	if (tc == (TBL_CONTEXT *) (*handle)) {
	    dbName = tc->databaseName;
	    tableName = tc->tableName;
	    foundit = 1;
	}
	tc = tc->next;
    }
    if (!foundit) {
#ifdef CTN_USE_THREADS
	THR_ReleaseMutex(FAC_TBL);
#endif
	return COND_PushCondition(TBL_ERROR(TBL_BADHANDLE), "TBL_Select");
    }
    if (msqlSelectDB(G_Msql_Sock, dbName) == -1) {
#ifdef CTN_USE_THREADS
	THR_ReleaseMutex(FAC_TBL);
#endif
	(void) COND_PushCondition(TBL_ERROR(TBL_DBSPECIFIC), "msql",
				  msqlErrMsg, "TBL_Select");
	return COND_PushCondition(TBL_ERROR(TBL_BADHANDLE), "TBL_Select");
    }
    /*
     * We found the names we need...just assume we can access it (for now).
     */
    if ((fieldList == (TBL_FIELD *) NULL) || (fieldList->FieldName == 0)) {
#ifdef CTN_USE_THREADS
	THR_ReleaseMutex(FAC_TBL);
#endif
	return COND_PushCondition(TBL_ERROR(TBL_NOFIELDLIST), "TBL_Select");
    }
    /*
     * Set up the select statement
     */
    msqlcmd(&G_DBSelect, "SELECT ");
    fp = fieldList;
    Add_FieldName_to_Buf(G_DBSelect, fp);
    fp++;
    while (fp->FieldName != NULL) {
	msqlcmd(&G_DBSelect, ",");
	Add_FieldName_to_Buf(G_DBSelect, fp);
	fp++;
    }
    msqlcmd(&G_DBSelect, "FROM ");
    Add_String_to_Buf(G_DBSelect, tableName);
    cp = criteriaList;
    if ((cp != (TBL_CRITERIA *) NULL) && (cp->FieldName != 0)) {
	msqlcmd(&G_DBSelect, " WHERE ");
	Add_Criteria_to_Buf(G_DBSelect, cp);
	cp++;
	while (cp->FieldName != NULL) {
	    msqlcmd(&G_DBSelect, " AND ");
	    Add_Criteria_to_Buf(G_DBSelect, cp);
	    cp++;
	}
    }
    if (count != (long *) NULL)
	lp = count;
    else
	lp = &realcount;
    *lp = 0;

    if (msqlQuery(G_Msql_Sock, G_DBSelect) == -1) {
	msqlfreebuf(&G_DBSelect);
#ifdef CTN_USE_THREADS
	THR_ReleaseMutex(FAC_TBL);
#endif
	(void) COND_PushCondition(TBL_ERROR(TBL_DBSPECIFIC), "msql",
				  msqlErrMsg, "TBL_Select");
	return COND_PushCondition(TBL_ERROR(TBL_SELECTFAILED), DATABASE, "TBL_Select");
    }
    ans = msqlStoreResult();
    while ((row = (m_row) msqlFetchRow(ans)) != (m_row) NULL) {
	(*lp)++;
	for (fp = fieldList, i = 0; fp->FieldName != NULL; fp++, i++) {
	    fp->Value.IsNull = 0;
	    switch (fp->Value.Type) {
	    case TBL_SIGNED2:
		fp->Value.Size = 2;
		if (row[i] == NULL)
		    *(fp->Value.Value.Signed2) = BIG_2;
		else
		    *(fp->Value.Value.Signed2) = atoi(row[i]);
		if (*(fp->Value.Value.Signed2) == BIG_2) {
		    fp->Value.IsNull = 1;
		    fp->Value.Size = 0;
		}
		break;
	    case TBL_UNSIGNED2:
		fp->Value.Size = 2;
		if (row[i] == NULL)
		    *(fp->Value.Value.Unsigned2) = BIG_2;
		else
		    *(fp->Value.Value.Unsigned2) = atoi(row[i]);
		if (*(fp->Value.Value.Unsigned2) == BIG_2) {
		    fp->Value.IsNull = 1;
		    fp->Value.Size = 0;
		}
		break;
	    case TBL_SIGNED4:
		fp->Value.Size = 4;
		if (row[i] == NULL)
		    *(fp->Value.Value.Signed4) = BIG_4;
		else
		    *(fp->Value.Value.Signed4) = atoi(row[i]);
		if (*(fp->Value.Value.Signed4) == BIG_4) {
		    fp->Value.IsNull = 1;
		    fp->Value.Size = 0;
		}
		break;
	    case TBL_UNSIGNED4:
		fp->Value.Size = 4;
		if (row[i] == NULL)
		    *(fp->Value.Value.Unsigned4) = BIG_4;
		else
		    *(fp->Value.Value.Unsigned4) = atoi(row[i]);
		if (*(fp->Value.Value.Unsigned4) == BIG_4) {
		    fp->Value.IsNull = 1;
		    fp->Value.Size = 0;
		}
		break;
	    case TBL_FLOAT4:
		fp->Value.Size = 4;
		if (row[i] == NULL)
		    *(fp->Value.Value.Float4) = BIG_4;
		else
		    *(fp->Value.Value.Float4) = atof(row[i]);
		if (*(fp->Value.Value.Float4) == BIG_4) {
		    fp->Value.IsNull = 1;
		    fp->Value.Size = 0;
		}
		break;
	    case TBL_FLOAT8:
		fp->Value.Size = 8;
		if (row[i] == NULL)
		    *(fp->Value.Value.Float8) = BIG_4;
		else
		    *(fp->Value.Value.Float8) = atof(row[i]);
		if (*(fp->Value.Value.Float8) == BIG_4) {
		    fp->Value.IsNull = 1;
		    fp->Value.Size = 0;
		}
		break;
	    case TBL_TEXT:
	    case TBL_BINARYDATA:
	    case TBL_STRING:
		fp->Value.Size = fp->Value.AllocatedSize;
		if (row[i] == NULL)
		    fp->Value.Value.String[0] = '\0';
		else
		    strncpy(fp->Value.Value.String, row[i], fp->Value.AllocatedSize - 1);
		if (strcmp(fp->Value.Value.String, "") == 0) {
		    fp->Value.IsNull = 1;
		    fp->Value.Size = 0;
		}
		break;
	    }
	}
	if (callback != NULL) {
	    if (callback(fieldList, *lp, ctx) != TBL_NORMAL) {
		msqlfreebuf(&G_DBSelect);
		msqlFreeResult(ans);
#ifdef CTN_USE_THREADS
		THR_ReleaseMutex(FAC_TBL);
#endif
		return COND_PushCondition(TBL_ERROR(TBL_EARLYEXIT), "TBL_Select");
	    }
	}
    }

    msqlfreebuf(&G_DBSelect);
    msqlFreeResult(ans);
#ifdef CTN_USE_THREADS
    THR_ReleaseMutex(FAC_TBL);
#endif
    return TBL_NORMAL;
}


/* TBL_Update
**
** Purpose:
**	This updates existing records in the named table.
**
** Parameter Dictionary:
**	TBL_HANDLE **handle: The pointer for the database/table pair
**		to be accessed for modification.  This table must be open.
**	TBL_CRITERIA *criteriaList: Contains the list of criteria to
**		select those records that should be updated.
**	TBL_FIELD *fieldList: Contains a list of the keyword/value
**		pairs to be used to modify the selected records.
**
** Return Values:
**	TBL_NORMAL: normal termination.
**	TBL_BADHANDLE: The handle passed to the routine was invalid.
**	TBL_DBNOEXIST: The database specified does not exist.
**	TBL_NOFIELDLIST: No keyword/value pairs were specified for update.
**	TBL_UPDATEFAILED: The insert operation failed most probably from
**		a bad specification in the fieldList.  This error
**		return could result from a misspelled keyword, etc.
**
** Notes:
**	Nothing unusual.
**
** Algorithm:
**	The records which match the (ANDED) criteria in criteriaList
**	are retreived and updated with the information contained in
**	fieldList.  Only the fields contained in fieldList will be
**	updated by this call.
*/
CONDITION
TBL_Update(TBL_HANDLE ** handle, const TBL_CRITERIA * criteriaList,
	   TBL_UPDATE * updateList)
{
    TBL_CONTEXT
	* tc;
    TBL_UPDATE
	* up;
    const TBL_CRITERIA
    *   cp;
    char
        tabcol[100],
       *dbName,
       *tableName;
    int
        i,
        ret,
        first,
        foundit;

    tc = G_ContextHead;
    foundit = 0;
    while (tc != (TBL_CONTEXT *) NULL) {
	if (tc == (TBL_CONTEXT *) (*handle)) {
	    dbName = tc->databaseName;
	    tableName = tc->tableName;
	    foundit = 1;
	}
	tc = tc->next;
    }
    if (!foundit) {
	return COND_PushCondition(TBL_ERROR(TBL_BADHANDLE), "TBL_Update");
    }
    if (msqlSelectDB(G_Msql_Sock, dbName) == -1) {
	(void) COND_PushCondition(TBL_ERROR(TBL_DBSPECIFIC), "msql",
				  msqlErrMsg, "TBL_Update");
	return COND_PushCondition(TBL_ERROR(TBL_BADHANDLE), "TBL_Update");
    }
    /*
     * We found the names we need...now make sure we can access it. Actually,
     * given that we found it, we probably already know the outcome of this
     * command...but we do need to set up the correct database for this
     * update...
     */
    /*
     * Set up the update statement
     */
    up = updateList;
    msqlcmd(&G_DBUpdate, "UPDATE ");
    Add_String_to_Buf(G_DBUpdate, tableName);
    msqlcmd(&G_DBUpdate, " SET ");
    first = 1;
    foundit = 0;
    while (up->FieldName != NULL) {
	if (!first)
	    msqlcmd(&G_DBUpdate, " , ");
	Add_String_to_Buf(G_DBUpdate, up->FieldName);
	msqlcmd(&G_DBUpdate, " = ");
	Add_UpdateValue_to_Buf(G_DBUpdate, up);
	first = 0;
	foundit = 1;
	up++;
    }
    if (foundit) {
	if ((cp = criteriaList) != (TBL_CRITERIA *) NULL) {
	    msqlcmd(&G_DBUpdate, " WHERE ");
	    Add_Criteria_to_Buf(G_DBUpdate, cp);
	    cp++;
	    while (cp->FieldName != NULL) {
		msqlcmd(&G_DBUpdate, " AND ");
		Add_Criteria_to_Buf(G_DBUpdate, cp);
		cp++;
	    }
	}
	if (msqlQuery(G_Msql_Sock, G_DBUpdate) == -1) {
	    msqlfreebuf(&G_DBUpdate);
	    (void) COND_PushCondition(TBL_ERROR(TBL_DBSPECIFIC), "msql",
				      msqlErrMsg, "TBL_Update");
	    return COND_PushCondition(TBL_ERROR(TBL_UPDATEFAILED), DATABASE, "TBL_Update");
	}
    }
    msqlfreebuf(&G_DBUpdate);
    return TBL_NORMAL;
}

/* TBL_NextUnique
**
** Purpose:
**	This routine retrieves the next unique number from a predefined table.
**
** Parameter Dictionary:
**	TBL_HANDLE **handle: The pointer for the database/table pair
**		to be accessed for modification.  This table must be open.
**	char *name : The name of the unique variable to access.
**	int *unique: Contains the next unique number in the sequence upon
**			return.
**
** Return Values:
**	TBL_NORMAL: normal termination.
**	TBL_BADHANDLE: The handle passed to the routine was invalid.
**	TBL_DBNOEXIST: The database specified does not exist.
**	TBL_SELECTFAILED: The unique number name could not be found.
**	TBL_UPDATEFAILED: The unique number could not be incremented.
**
** Notes:
**	Nothing unusual.
**
** Algorithm:
**	The unique number associated with  "name" in the opened table is
**	retrieved and passed back to the user in "unique".  This number is
**	then incremented (by one) and placed back in the table in preparation
**	for the next call to this routine.
*/
CONDITION
TBL_NextUnique(TBL_HANDLE ** handle, char *name, int *unique)
{
    TBL_CONTEXT
	* tc;
    char
        num[20],
       *dbName,
       *tableName;
    int
        i,
        ret,
        foundit;
    m_row
	row;
    m_result
	* ans;

    tc = G_ContextHead;
    foundit = 0;
    while (tc != (TBL_CONTEXT *) NULL) {
	if (tc == (TBL_CONTEXT *) (*handle)) {
	    dbName = tc->databaseName;
	    tableName = tc->tableName;
	    foundit = 1;
	}
	tc = tc->next;
    }
    if (!foundit) {
	return COND_PushCondition(TBL_ERROR(TBL_BADHANDLE), "TBL_NextUnique");
    }
    if (msqlSelectDB(G_Msql_Sock, dbName) == -1) {
	return COND_PushCondition(TBL_ERROR(TBL_BADHANDLE), "TBL_NextUnique");
    }
    msqlcmd(&G_DBNextUnique, "SELECT UniqueNumber FROM ");
    Add_String_to_Buf(G_DBNextUnique, tableName);
    msqlcmd(&G_DBNextUnique, " WHERE NumberName='");
    msqlcmd(&G_DBNextUnique, name);
    msqlcmd(&G_DBNextUnique, "'");

    if (msqlQuery(G_Msql_Sock, G_DBNextUnique) == -1) {
	msqlfreebuf(&G_DBNextUnique);
	return COND_PushCondition(TBL_ERROR(TBL_SELECTFAILED), DATABASE, "TBL_NextUnique");
    }
    *unique = -1;
    ans = msqlStoreResult();
    if ((row = (m_row) msqlFetchRow(ans)) != (m_row) NULL) {
	*unique = atoi(row[0]);
    } else {
	msqlfreebuf(&G_DBNextUnique);
	msqlFreeResult(ans);
	return COND_PushCondition(TBL_ERROR(TBL_SELECTFAILED), DATABASE, "TBL_NextUnique");
    }
    msqlFreeResult(ans);
    /*
     * Now perform the update...
     */
    i = *unique + 1;
    msqlfreebuf(&G_DBNextUnique);
    msqlcmd(&G_DBNextUnique, "UPDATE ");
    Add_String_to_Buf(G_DBNextUnique, tableName);
    msqlcmd(&G_DBNextUnique, " SET UniqueNumber=");
    sprintf(num, " %d ", i);
    Add_String_to_Buf(G_DBNextUnique, num);
    msqlcmd(&G_DBNextUnique, " WHERE NumberName='");
    msqlcmd(&G_DBNextUnique, name);
    msqlcmd(&G_DBNextUnique, "'");


    if (msqlQuery(G_Msql_Sock, G_DBNextUnique) == -1) {
	msqlfreebuf(&G_DBNextUnique);
	return COND_PushCondition(TBL_ERROR(TBL_UPDATEFAILED), DATABASE, "TBL_NextUnique");
    }
    msqlfreebuf(&G_DBNextUnique);
    return TBL_NORMAL;
}

/* TBL_Insert
**
** Purpose:
**	This inserts records into the named table.
**
** Parameter Dictionary:
**	TBL_HANDLE **handle: The pointer for the database/table pair
**		to be accessed for deletion.  This table must be open.
**	TBL_FIELD *fieldList: Contains a list of the keyword/value
**		pairs to be inserted into the specified table.
**
** Return Values:
**	TBL_NORMAL: normal termination.
**	TBL_BADHANDLE: The handle passed to the routine was invalid.
**	TBL_DBNOEXIST: The database specified does not exist.
**	TBL_NOFIELDLIST: No keyword/value pairs were specified to
**		insert.
**	TBL_INSERTFAILED: The insert operation failed most probably from
**		a bad specification in the fieldList.  This error
**		return could result from a misspelled keyword, etc.
**
** Notes:
**	Nothing unusual.
**
** Algorithm:
**	The table values contained in fieldList are added to the
**	database and table specified by handle.  Each call inserts
**	exactly one record.  It is the users responsibility to ensure
**	that the correct number of values are supplied for the
**	particular table, and that any values which need to be
**	unique (i.e.for the unique key field in a table) are
**	in-fact unique.
*/
CONDITION
TBL_Insert(TBL_HANDLE ** handle, TBL_FIELD * fieldList)
{
    TBL_CONTEXT
	* tc;
    TBL_FIELD
	* fp;
    char
        tabcol[100],
       *dbName,
       *tableName;
    int
        i,
        ret,
        FoundTextorBinary,
        foundit;

    tc = G_ContextHead;
    foundit = 0;
    while (tc != (TBL_CONTEXT *) NULL) {
	if (tc == (TBL_CONTEXT *) (*handle)) {
	    dbName = tc->databaseName;
	    tableName = tc->tableName;
	    foundit = 1;
	}
	tc = tc->next;
    }
    if (!foundit) {
	return COND_PushCondition(TBL_ERROR(TBL_BADHANDLE), "TBL_Insert");
    }
    if (msqlSelectDB(G_Msql_Sock, dbName) == -1) {
	(void) COND_PushCondition(TBL_ERROR(TBL_DBSPECIFIC), "msql",
				  msqlErrMsg, "TBL_Insert");
	return COND_PushCondition(TBL_ERROR(TBL_BADHANDLE), "TBL_Insert");
    }
    fp = fieldList;
    if (fp == (TBL_FIELD *) NULL) {
	return COND_PushCondition(TBL_ERROR(TBL_NOFIELDLIST), "TBL_Insert");
    }
    /*
     * Set up the insert statement
     */
    msqlcmd(&G_DBInsert, "INSERT INTO ");
    Add_String_to_Buf(G_DBInsert, tableName);
    msqlcmd(&G_DBInsert, " (  ");
    Add_FieldName_to_Buf(G_DBInsert, fp);
    fp++;
    while (fp->FieldName != NULL) {
	msqlcmd(&G_DBInsert, " , ");
	msqlcmd(&G_DBInsert, fp->FieldName);
	fp++;
    }
    msqlcmd(&G_DBInsert, " ) VALUES ( ");

    fp = fieldList;
    Add_FieldValue_to_Buf(G_DBInsert, fp);
    fp++;
    while (fp->FieldName != NULL) {
	msqlcmd(&G_DBInsert, " , ");
	Add_FieldValue_to_Buf(G_DBInsert, fp);
	fp++;
    }

    msqlcmd(&G_DBInsert, " )");

    if (msqlQuery(G_Msql_Sock, G_DBInsert) == -1) {
	msqlfreebuf(&G_DBInsert);
	(void) COND_PushCondition(TBL_ERROR(TBL_DBSPECIFIC), "msql",
				  msqlErrMsg, "TBL_Insert");
	return COND_PushCondition(TBL_ERROR(TBL_INSERTFAILED), DATABASE, "TBL_Insert");
    }
    msqlfreebuf(&G_DBInsert);

    return TBL_NORMAL;
}
/*
** INTERNAL USE FUNCTIONS **
*/
void
TBL_BeginInsertTransaction(void)
{
    return;
}
void
TBL_CommitInsertTransaction(void)
{
    return;
}
void
TBL_RollbackInsertTransaction(void)
{
    return;
}



/* TBL_Delete
**
** Purpose:
**	This deletes the records specified from the indicated table.
**
** Parameter Dictionary:
**	TBL_HANDLE **handle: The pointer for the database/table pair
**		to be accessed for deletion.  This table must be open.
**	TBL_CRITERIA *criteriaList: Contains a list of the criteria
**		to use when deleting records from the specified table.
**		A null list implies that all records will be deleted.
**
** Return Values:
**	TBL_NORMAL: normal termination.
**	TBL_BADHANDLE: The handle passed to the routine was invalid.
**	TBL_DBNOEXIST: The database specified does not exist.
**	TBL_DELETEFAILED: The delete operation failed most probably from
**		a bad specification in the criteriaList.  This error
**		return could result from a misspelled keyword, etc.
**
** Notes:
**	Nothing unusual.
**
** Algorithm:
**	The records selected by criteriaList are removed from the
**	database/table indicated by handle.
*/
CONDITION
TBL_Delete(TBL_HANDLE ** handle, const TBL_CRITERIA * criteriaList)
{
    TBL_CONTEXT
	* tc;
    const TBL_CRITERIA
    *   cp;
    char
       *dbName,
       *tableName;
    int
        i,
        foundit;

    tc = G_ContextHead;
    foundit = 0;
    while (tc != (TBL_CONTEXT *) NULL) {
	if (tc == (TBL_CONTEXT *) (*handle)) {
	    dbName = tc->databaseName;
	    tableName = tc->tableName;
	    foundit = 1;
	}
	tc = tc->next;
    }
    if (!foundit) {
	return COND_PushCondition(TBL_ERROR(TBL_BADHANDLE), "TBL_Delete");
    }
    if (msqlSelectDB(G_Msql_Sock, dbName) == -1) {
	return COND_PushCondition(TBL_ERROR(TBL_BADHANDLE), "TBL_NextUnique");
    }
    msqlfreebuf(&G_DBDelete);
    /*
     * Set up the delete statement
     */
    msqlcmd(&G_DBDelete, "DELETE FROM ");
    Add_String_to_Buf(G_DBDelete, tableName);
    cp = criteriaList;
    if (cp != (TBL_CRITERIA *) NULL) {
	if (cp->FieldName != NULL) {
	    msqlcmd(&G_DBDelete, " WHERE ");
	    Add_Criteria_to_Buf(G_DBDelete, cp);
	    cp++;
	    while (cp->FieldName != NULL) {
		msqlcmd(&G_DBDelete, " AND ");
		Add_Criteria_to_Buf(G_DBDelete, cp);
		cp++;
	    }
	}
    }
    if (msqlQuery(G_Msql_Sock, G_DBDelete) == -1) {
	msqlfreebuf(&G_DBDelete);
	return COND_PushCondition(TBL_ERROR(TBL_DELETEFAILED), DATABASE, "TBL_Delete");
    }
    msqlfreebuf(&G_DBDelete);
    return TBL_NORMAL;
}


/* TBL_Layout
**
** Purpose:
**	This function returns the columns and types of a particular
**	table specified by handle.
**
** Parameter Dictionary:
**	char *databaseName: The name of the database to use.
**	char *tableName: The name of the table to access.
**	CONDITION (*callback)(): The callback function invoked whenever
**		a new record is retreived from the database.  It is
**		invoked with parameters as described below.
**	void *ctx: Ancillary data passed through to the callback function
**		and untouched by this routine.
**
** Return Values:
**	TBL_NORMAL: normal termination.
**	TBL_NOCALLBACK: No callback function was specified.
**	TBL_DBNOEXIST: The database specified does not exist.
**	TBL_TBLNOEXIST: The table specified did not exist in the correct
**		internal database table...this may indicate some sort
**		of consistency problem withing the database.
**	TBL_NOCOLUMNS: The table specified contains no columnns.
**	TBL_EARLYEXIT: The callback routine returned something other than
**		TBL_NORMAL which caused this routine to cancel the remainder
**		of the database operation and return early.
**
** Notes:
**	It is an error to specify a null callback function.
**
** Algorithm:
**	As each column is retrieved from the specified table, the
**	callback function is invoked as follows:
**
**		callback(fieldList *fieldList, void *ctx)
**
**	fieldList contains the field name and the type of the column from
**	the table specified.
**	ctx contains any additional information the user originally passed
**	to this layout function.  If callback returns any value other
**	than TBL_NORMAL, it is assumed that this function should terminate
**	(i.e. cancel the current db operation), and return an abnormal
**	termination message (TBL_EARLYEXIT) to the routine which
**	originally invoked TBL_Layout.
*/
CONDITION
TBL_Layout(char *databaseName, char *tableName, CONDITION(*callback) (), void *ctx) {

    TBL_FIELD
	field;
    int
        i;
    m_result
	* ans;
    m_field
	* fld;

    if (callback == NULL) {
	return COND_PushCondition(TBL_ERROR(TBL_NOCALLBACK), "TBL_Layout");
    }
    if (msqlSelectDB(G_Msql_Sock, databaseName) == -1) {
	return COND_PushCondition(TBL_ERROR(TBL_DBNOEXIST), "TBL_Layout");
    }
    /*
     * Set up the select statement
     */
    ans = msqlListFields(G_Msql_Sock, tableName);

    if (msqlNumFields(ans) < 1) {
	return COND_PushCondition(TBL_ERROR(TBL_NOCOLUMNS), "TBL_Layout");
    } else {
	for (i = 0; i < msqlNumFields(ans); i++) {
	    /*
	     * Now lets find each column and type for that table...
	     */
	    fld = msqlFetchField(ans);
	    field.FieldName = fld->name;
	    field.Value.AllocatedSize = fld->length;
	    switch (fld->type) {
	    case INT_TYPE:
		field.Value.Type = TBL_SIGNED4;
		break;
	    case CHAR_TYPE:
		field.Value.Type = TBL_STRING;
		break;
	    case REAL_TYPE:
		field.Value.Type = TBL_FLOAT8;
		break;
	    }
	    if (callback != NULL) {
		if (callback(&field, ctx) != TBL_NORMAL) {
		    return COND_PushCondition(TBL_ERROR(TBL_EARLYEXIT), "TBL_Layout");
		}
	    }
	}
    }
    return TBL_NORMAL;
}

/*
** INTERNAL USE FUNCTION **
*/
static void
Add_String_to_Buf(char *Buf, char *str)
{
    char *
        foo;

    foo = malloc(strlen(str) + 3);
    sprintf(foo, " %s ", str);
    msqlcmd(&Buf, foo);
    free(foo);

    return;
}
/*
** INTERNAL USE FUNCTION **
*/
static void
Add_FieldName_to_Buf(char *Buf, TBL_FIELD * fp)
{
    char *
        foo;

    foo = malloc(strlen(fp->FieldName) + 3);
    sprintf(foo, " %s ", fp->FieldName);
    msqlcmd(&Buf, foo);
    free(foo);

    return;
}
/*
** INTERNAL USE FUNCTION **
*/
static void
Add_UpdateValue_to_Buf(char *Buf, TBL_UPDATE * up)
{

    char
        foo[50];
    char
       *foos;

    if (up->Function == TBL_SET) {
	switch (up->Value.Type) {
	case TBL_SIGNED2:
	    sprintf(foo, " %d ", *(up->Value.Value.Signed2));
	    msqlcmd(&Buf, foo);
	    break;
	case TBL_UNSIGNED2:
	    sprintf(foo, " %d ", *(up->Value.Value.Unsigned2));
	    msqlcmd(&Buf, foo);
	    break;
	case TBL_SIGNED4:
	    sprintf(foo, " %d ", *(up->Value.Value.Signed4));
	    msqlcmd(&Buf, foo);
	    break;
	case TBL_UNSIGNED4:
	    sprintf(foo, " %d ", *(up->Value.Value.Unsigned4));
	    msqlcmd(&Buf, foo);
	    break;
	case TBL_FLOAT4:
	    sprintf(foo, " %f ", *(up->Value.Value.Float4));
	    msqlcmd(&Buf, foo);
	    break;
	case TBL_FLOAT8:
	    sprintf(foo, " %f ", *(up->Value.Value.Float8));
	    msqlcmd(&Buf, foo);
	    break;
	case TBL_TEXT:
	case TBL_BINARYDATA:
	case TBL_STRING:
	    foos = malloc(strlen(up->Value.Value.String) + 3);
	    sprintf(foos, "'%s'", up->Value.Value.String);
	    msqlcmd(&Buf, foos);
	    free(foos);
	    break;
	}
    } else {			/* if (up->Function == TBL_ZERO) can't
				 * support any other fancy stuff */
	msqlcmd(&Buf, " 0 ");
    }
    return;
}
/*
** INTERNAL USE FUNCTION **
*/
static void
Add_FieldValue_to_Buf(char *Buf, TBL_FIELD * fp)
{
    char
        foo[50];
    char
       *foos;

    switch (fp->Value.Type) {
    case TBL_SIGNED2:
	sprintf(foo, " %d ", *(fp->Value.Value.Signed2));
	msqlcmd(&Buf, foo);
	break;
    case TBL_UNSIGNED2:
	sprintf(foo, " %d ", *(fp->Value.Value.Unsigned2));
	msqlcmd(&Buf, foo);
	break;
    case TBL_SIGNED4:
	sprintf(foo, " %d ", *(fp->Value.Value.Signed4));
	msqlcmd(&Buf, foo);
	break;
    case TBL_UNSIGNED4:
	sprintf(foo, " %d ", *(fp->Value.Value.Unsigned4));
	msqlcmd(&Buf, foo);
	break;
    case TBL_FLOAT4:
	sprintf(foo, " %f ", *(fp->Value.Value.Float4));
	msqlcmd(&Buf, foo);
	break;
    case TBL_FLOAT8:
	sprintf(foo, " %f ", *(fp->Value.Value.Float8));
	msqlcmd(&Buf, foo);
	break;
    case TBL_TEXT:
    case TBL_BINARYDATA:
    case TBL_STRING:
	foos = malloc(strlen(fp->Value.Value.String) + 3);
	sprintf(foos, "'%s'", fp->Value.Value.String);
	msqlcmd(&Buf, foos);
	free(foos);
	break;
    }
    return;
}
/*
** INTERNAL USE FUNCTION **
*/
static void
Add_Criteria_to_Buf(char *Buf, const TBL_CRITERIA * cp)
{

    if (cp->Operator != TBL_NOP)
	Add_String_to_Buf(Buf, cp->FieldName);
    switch (cp->Operator) {
    case TBL_EQUAL:
	msqlcmd(&Buf, " = ");
	break;
    case TBL_LIKE:
	msqlcmd(&Buf, " like ");
	break;
    case TBL_NOT_EQUAL:
	msqlcmd(&Buf, " <> ");
	break;
    case TBL_GREATER:
	msqlcmd(&Buf, " > ");
	break;
    case TBL_GREATER_EQUAL:
	msqlcmd(&Buf, " >= ");
	break;
    case TBL_LESS:
	msqlcmd(&Buf, " < ");
	break;
    case TBL_LESS_EQUAL:
	msqlcmd(&Buf, " <= ");
	break;
    case TBL_NOP:
	Add_String_to_Buf(Buf, cp->Value.Value.String);
	break;
    }
    if ((cp->Operator != TBL_NULL) && (cp->Operator != TBL_NOT_NULL) && (cp->Operator != TBL_NOP)) {
	char foo[100],
	   *foos;
	switch (cp->Value.Type) {
	case TBL_SIGNED2:
	    sprintf(foo, " %d ", *(cp->Value.Value.Signed2));
	    msqlcmd(&Buf, foo);
	    break;
	case TBL_UNSIGNED2:
	    sprintf(foo, " %d ", *(cp->Value.Value.Unsigned2));
	    msqlcmd(&Buf, foo);
	    break;
	case TBL_SIGNED4:
	    sprintf(foo, " %d ", *(cp->Value.Value.Signed4));
	    msqlcmd(&Buf, foo);
	    break;
	case TBL_UNSIGNED4:
	    sprintf(foo, " %d ", *(cp->Value.Value.Unsigned4));
	    msqlcmd(&Buf, foo);
	    break;
	case TBL_FLOAT4:
	    sprintf(foo, " %f ", *(cp->Value.Value.Float4));
	    msqlcmd(&Buf, foo);
	    break;
	case TBL_FLOAT8:
	    sprintf(foo, " %f ", *(cp->Value.Value.Float8));
	    msqlcmd(&Buf, foo);
	    break;
	case TBL_STRING:
	    foos = malloc(strlen(cp->Value.Value.String) + 3);
	    sprintf(foos, "'%s'", cp->Value.Value.String);
	    msqlcmd(&Buf, foos);
	    free(foos);
	    break;
	}
    }
    return;
}
/*
** INTERNAL USE FUNCTION **
*/
static void
msqlfreebuf(char **buf)
{
    if (*buf != (char *) NULL) {
	free(*buf);
	*buf = (char *) NULL;
    }
    return;
}

/*
** INTERNAL USE FUNCTION **
*/
void
msqlcmd(char **cmdbuffer, char *str)
{
    int
        didbump;

    if (*cmdbuffer == (char *) NULL) {
	if (MSQLCMDBUFSIZE > strlen(str) + 1) {
	    G_DBSelectSize = MSQLCMDBUFSIZE;
	} else {
	    G_DBSelectSize = strlen(str) + MSQLCMDBUFSIZE;
	}
	*cmdbuffer = malloc(G_DBSelectSize);
	strcpy(*cmdbuffer, str);
    } else {
	didbump = 0;
	while (G_DBSelectSize < (strlen(*cmdbuffer) + strlen(str) + 1)) {
	    G_DBSelectSize += MSQLCMDBUFSIZE;
	    didbump = 1;
	}
	if (didbump)
	    *cmdbuffer = realloc(*cmdbuffer, G_DBSelectSize);

	strcat(*cmdbuffer, str);
    }
}


#else				/* If MSQL is not defined...just return the */

CONDITION
TBL_Open(const char *databaseName, const char *tableName, TBL_HANDLE ** handle)
{
    return COND_PushCondition(TBL_ERROR(TBL_UNIMPLEMENTED), "TBL_Open");
}

CONDITION
TBL_Close(TBL_HANDLE ** handle)
{
    return COND_PushCondition(TBL_ERROR(TBL_UNIMPLEMENTED), "TBL_Close");
}

CONDITION
TBL_Select(TBL_HANDLE ** handle, const TBL_CRITERIA * criteriaList,
     TBL_FIELD * fieldList, long *count, CONDITION(*callback) (), void *ctx)
{
    return COND_PushCondition(TBL_ERROR(TBL_UNIMPLEMENTED), "TBL_Select");
}

CONDITION
TBL_Update(TBL_HANDLE ** handle, const TBL_CRITERIA * criteriaList,
	   TBL_UPDATE * updateList)
{
    return COND_PushCondition(TBL_ERROR(TBL_UNIMPLEMENTED), "TBL_Update");
}

CONDITION
TBL_Insert(TBL_HANDLE ** handle, TBL_FIELD * fieldList)
{
    return COND_PushCondition(TBL_ERROR(TBL_UNIMPLEMENTED), "TBL_Insert");
}

CONDITION
TBL_Delete(TBL_HANDLE ** handle, const TBL_CRITERIA * criteriaList)
{
    return COND_PushCondition(TBL_ERROR(TBL_UNIMPLEMENTED), "TBL_Delete");
}

CONDITION
TBL_Layout(char *databaseName, char *tableName, CONDITION(*callback) (), void *ctx) {
    return COND_PushCondition(TBL_ERROR(TBL_UNIMPLEMENTED), "TBL_Layout");
}

CONDITION
TBL_NextUnique(TBL_HANDLE ** handle, char *name, int *unique)
{
    return COND_PushCondition(TBL_ERROR(TBL_UNIMPLEMENTED), "TBL_NextUnique");
}

void
TBL_BeginInsertTransaction(void)
{
    return;
}

void
TBL_RollbackInsertTransaction(void)
{
    return;
}

void
TBL_CommitInsertTransaction(void)
{
    return;
}

CONDITION
TBL_Debug(CTNBOOLEAN flag)
{
    return TBL_UNIMPLEMENTED;
}

CONDITION
TBL_SetOption(const char *string)
{
    return TBL_UNIMPLEMENTED;
}

int
TBL_HasViews(void)
{
    return TBL_UNIMPLEMENTED;
}

#endif
