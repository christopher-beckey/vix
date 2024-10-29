/*
+-+-+-+-+-+-+-+-+-
*/
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
** Author, Date:	David E. Beecher, 28-Feb-94
** Intent:		Provide a general set of functions to be performed
**			on tables in a relational database.
** Last Update:		$Author: Vhaiswstarkm $, $Date: 11/04/10 9:17a $
** Source File:		$RCSfile: sybase.c,v $
** Revision:		$Revision: 1 $
** Status:		$State: Exp $
*/

static char rcsid[] = "$Revision: 1 $ $RCSfile: sybase.c,v $";

#include <stdio.h>
#include <sys/types.h>
#include <string.h>
#include "facilities.h"
#include "sitemacros.h"
#include "condition.h"
#include "tbl.h"

#include "sybfront.h"
#include "sybdb.h"

#define TBL_ERROR(a) (a), TBL_Message((a))

/*
** Static Globals for this file...
*/
static TBL_CONTEXT
    *G_ContextHead = (TBL_CONTEXT *)NULL;

static LOGINREC 
    *G_LoginRecord;

static DBPROCESS
    *G_tempdbproc,
    *G_DBInsert,
    *G_DBUpdate,
    *G_DBDelete,
    *G_DBLayout;

static int
    G_OpenFlag = 0;

#define	BIG_2	32767
#define	BIG_4	999999999

#define	SYBASE_USER	"sybase"
#define SYBASE_PASSWORD	"sybase"
#define SYBASE_APP	"DICOM"

/*
 * Internal function calls
 */
static void
Add_Field_to_Select(DBPROCESS *, TBL_FIELD *),
Add_Criteria_to_Sybuf(DBPROCESS *, TBL_CRITERIA *),
Add_Value_to_Sybuf(DBPROCESS *, TBL_FIELD *);

static int
syb_err_handler(DBPROCESS *, int , int , int , char *, char *),
syb_msg_handler(DBPROCESS *, DBINT , int , int , char *, char *, char *, DBUSMALLINT);



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
**	The first time TBL_Open is invoked, special Sybase routines
**	are called to allocate the communication structures needed
**	for subsequent operations.  A check is made to ensure that
**	this table/database pair has not already been opened.  A
**	unique handle(address) is then created for this pair and
**	returned to the user for subsequent table operations.
*/

CONDITION
TBL_Open(char *databaseName, char *tableName, TBL_HANDLE **handle)
{
TBL_CONTEXT
    *tc;
char
    *tdb,
    *ttb;

    (*handle) = (void *)NULL;

    if( G_OpenFlag == 0 ){
	if( dbinit() == FAIL )
	    return TBL_DBINITFAILED;
	dberrhandle( syb_err_handler );
	dbmsghandle( syb_msg_handler );
	if( (G_LoginRecord = dblogin()) == NULL )
	    return TBL_DBINITFAILED;
	DBSETLUSER( G_LoginRecord, SYBASE_USER );
	DBSETLPWD( G_LoginRecord, SYBASE_PASSWORD );
	DBSETLAPP( G_LoginRecord, SYBASE_APP );
	if( (G_tempdbproc = dbopen( G_LoginRecord, NULL)) == NULL )
	    return TBL_DBINITFAILED;
	if( (G_DBInsert = dbopen( G_LoginRecord, NULL)) == NULL )
	    return TBL_DBINITFAILED;
	if( (G_DBDelete = dbopen( G_LoginRecord, NULL)) == NULL )
	    return TBL_DBINITFAILED;
	if( (G_DBUpdate = dbopen( G_LoginRecord, NULL)) == NULL )
	    return TBL_DBINITFAILED;
	if( (G_DBLayout = dbopen( G_LoginRecord, NULL)) == NULL )
	    return TBL_DBINITFAILED;
    }

    tc = G_ContextHead;
    while( tc != (TBL_CONTEXT *) NULL ){
	if( (strcmp(tc->databaseName,databaseName) == 0) &&
	    (strcmp(tc->tableName,tableName) == 0) ){
	    return COND_PushCondition(TBL_ERROR(TBL_ALREADYOPENED), "TBL_Open");
	}
	tc = tc->next;
    }
    /*
     * The database/table pair has not been found...so now we check to see
     * if we can access it before adding it to our list.
     */
    if( dbuse(G_tempdbproc, databaseName) != SUCCEED ){
	return COND_PushCondition(TBL_ERROR(TBL_DBNOEXIST), "TBL_Open");
    }   
    dbcmd(G_tempdbproc,"sp_help ");
    dbcmd(G_tempdbproc,tableName);
    if( dbsqlexec(G_tempdbproc) == FAIL ){
	return COND_PushCondition(TBL_ERROR(TBL_TBLNOEXIST), "TBL_Open");
    }
    dbcancel(G_tempdbproc);
    /*
     * Both the Database and the Table exist, so we can add the new
     * entry to our list.
     */
    if( (tc=(TBL_CONTEXT *)malloc(sizeof(TBL_CONTEXT))) == (TBL_CONTEXT *)NULL ){
	return COND_PushCondition(TBL_ERROR(TBL_NOMEMORY), "TBL_Open");
    }
    if( (tdb=(char *)malloc(strlen(databaseName)+1)) == (char *)NULL ){
	free(tc);
	return COND_PushCondition(TBL_ERROR(TBL_NOMEMORY), "TBL_Open");
    }
    if( (ttb=(char *)malloc(strlen(tableName)+1)) == (char *)NULL ){
	free(tc);
	free(tdb);
	return COND_PushCondition(TBL_ERROR(TBL_NOMEMORY), "TBL_Open");
    }
    strcpy(tdb,databaseName);
    strcpy(ttb,tableName);
    tc->databaseName = tdb;
    tc->tableName = ttb;
    tc->next = G_ContextHead;
    G_ContextHead = tc;

    (*handle) = (void *)G_ContextHead;

    G_OpenFlag++;

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
TBL_Close(TBL_HANDLE **handle)
{
TBL_CONTEXT
    *prevtc,
    *tc,
    *hc;


    G_OpenFlag--;
    if( G_OpenFlag == 0 ){
	dbexit();
    }

    hc = (TBL_CONTEXT *) (*handle);
    prevtc = tc = G_ContextHead;
    while( tc != (TBL_HANDLE *) NULL ){
	if( hc == tc ){
	    free(tc->databaseName);
	    free(tc->tableName);
	    if( tc == G_ContextHead )
		G_ContextHead = tc->next;
	    else
		prevtc->next = tc->next;
	    free(tc);
	    (*handle) = (TBL_HANDLE *)NULL;
	    return TBL_NORMAL;
	}
	prevtc = tc;
	tc = tc->next;
    }

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
**	TBL_DBINITFAILED: The attempt to allocate another Sybase
**		process record failed.
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
** Notes:
**	In this module the DBPROCESS structure needed to access Sybase (DBSelect)
**	is allocated and deallocated locally because this routine can be called
**	recursively (i.e. calling TBL_Select within TBL_Select) to properly allow
**	multiple selects to be active simultaneously.  With each recursive call, 
**	a new DBPROCESS structure will be allocated allowing these simultaneous
**	selects to function properly.
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
TBL_Select(TBL_HANDLE ** handle, TBL_CRITERIA *criteriaList,
	   TBL_FIELD *fieldList, long *count, CONDITION(*callback) (), void *ctx)
{
TBL_CONTEXT
    *tc;
TBL_FIELD
    *fp;
TBL_CRITERIA
    *cp;
char
    *dbName,
    *tableName;
int
    i,
    foundit;
long
    realcount,
    *lp;
DBPROCESS
    *DBSelect;

    tc = G_ContextHead;
    foundit = 0;
    while( tc != (TBL_CONTEXT *) NULL ){
	if( tc == (TBL_CONTEXT *) (*handle) ){
	    dbName = tc->databaseName;
	    tableName = tc->tableName;
	    foundit = 1;
	}
	tc = tc->next;
    }
    if( !foundit ){
    	return COND_PushCondition(TBL_ERROR(TBL_BADHANDLE), "TBL_Select");
    }
    /*
     * We found the names we need...now make sure we can access it.
     * Actually, given that we found it, we probably already know the
     * outcome of this command...but we do need to set up the correct
     * database for this command anyway...
     */
    if( (DBSelect = dbopen( G_LoginRecord, NULL)) == NULL )
	return COND_PushCondition(TBL_ERROR(TBL_DBINITFAILED), "TBL_Select");
    if( dbuse(DBSelect, dbName) != SUCCEED ){
	dbclose(DBSelect);
	return COND_PushCondition(TBL_ERROR(TBL_DBNOEXIST), "TBL_Select");
    }
    if( fieldList == (TBL_FIELD *)NULL ){
	dbclose(DBSelect);
	return COND_PushCondition(TBL_ERROR(TBL_NOFIELDLIST), "TBL_Select");
    }
    dbfreebuf(DBSelect);
    /*
     * Set up the select statement
     */
    dbcmd(DBSelect,"SELECT ");
    fp = fieldList;
    Add_Field_to_Select(DBSelect,fp);
    fp++;
    while( fp->FieldName != NULL ){
        dbcmd(DBSelect," , ");
	Add_Field_to_Select(DBSelect,fp);
	fp++;
    }
    dbfcmd(DBSelect," FROM %s ",tableName);
    cp = criteriaList;
    if( cp != (TBL_CRITERIA *)NULL ){
	dbcmd(DBSelect," WHERE ");
    	Add_Criteria_to_Sybuf(DBSelect,cp);
	cp++;
	while( cp->FieldName != NULL ){
	    dbcmd(DBSelect," AND ");
    	    Add_Criteria_to_Sybuf(DBSelect,cp);
	    cp++;
	}
    }
    if( count != (long *)NULL )
	lp = count;
    else
	lp = &realcount;
    *lp = 0;
    if( dbsqlexec(DBSelect) == FAIL ){
	dbfreebuf(DBSelect);
	dbclose(DBSelect);
	return COND_PushCondition(TBL_ERROR(TBL_SELECTFAILED), "TBL_Select");
    }
    while( dbresults(DBSelect) != NO_MORE_RESULTS ){
	if( DBROWS(DBSelect) == SUCCEED ){
	    for( fp=fieldList,i=1; fp->FieldName != NULL; fp++,i++){
		switch(fp->Value.Type){
		    case TBL_SIGNED2:
			dbbind(DBSelect,i,INTBIND,
				(DBINT)fp->Value.AllocatedSize,(BYTE *)(fp->Value.Value.Signed2));
			break;
		    case TBL_UNSIGNED2:
			dbbind(DBSelect,i,INTBIND,
				(DBINT)fp->Value.AllocatedSize,(BYTE *)(fp->Value.Value.Unsigned2));
			break;
		    case TBL_SIGNED4:
			dbbind(DBSelect,i,INTBIND,
				(DBINT)fp->Value.AllocatedSize,(BYTE *)(fp->Value.Value.Signed4));
			break;
		    case TBL_UNSIGNED4:
			dbbind(DBSelect,i,INTBIND,
				(DBINT)fp->Value.AllocatedSize,(BYTE *)(fp->Value.Value.Unsigned4));
			break;
		    case TBL_FLOAT4:
			dbbind(DBSelect,i,REALBIND,
				(DBINT)fp->Value.AllocatedSize,(BYTE *)(fp->Value.Value.Float4));
			break;
		    case TBL_FLOAT8:
			dbbind(DBSelect,i,FLT8BIND,
				(DBINT)fp->Value.AllocatedSize,(BYTE *)(fp->Value.Value.Float8));
			break;
		    case TBL_STRING:
			dbbind(DBSelect,i,NTBSTRINGBIND,
				(DBINT)fp->Value.AllocatedSize,(BYTE *)(fp->Value.Value.String));
			break;
		    case TBL_TEXT:
			dbbind(DBSelect,i,NTBSTRINGBIND,
				(DBINT)fp->Value.AllocatedSize,(BYTE *)(fp->Value.Value.Text));
			break;
		    case TBL_BINARYDATA:
			dbbind(DBSelect,i,BINARYBIND,
				(DBINT)fp->Value.AllocatedSize,(BYTE *)(fp->Value.Value.BinaryData));
			break;
		}
	    }
	    while( dbnextrow(DBSelect) != NO_MORE_ROWS ){
		(*lp)++;
		fp->Value.IsNull = 0;
	        for( fp=fieldList,i=1; fp->FieldName != NULL; fp++,i++){
		    switch(fp->Value.Type){
		        case TBL_SIGNED2:
			    fp->Value.Size = 2;
			    if( *(fp->Value.Value.Signed2) == BIG_2 ){
			        fp->Value.IsNull = 1;
			        fp->Value.Size = 0;
			    }
			    break;
		        case TBL_UNSIGNED2:
			    fp->Value.Size = 2;
			    if( *(fp->Value.Value.Unsigned2) == BIG_2 ){
			        fp->Value.IsNull = 1;
			        fp->Value.Size = 0;
			    }
			    break;
		        case TBL_SIGNED4:
			    fp->Value.Size = 4;
			    if( *(fp->Value.Value.Signed4) == BIG_4 ){
			        fp->Value.IsNull = 1;
			        fp->Value.Size = 0;
			    }
			    break;
		        case TBL_UNSIGNED4:
			    fp->Value.Size = 4;
			    if( *(fp->Value.Value.Unsigned4) == BIG_4 ){
			        fp->Value.IsNull = 1;
			        fp->Value.Size = 0;
			    }
			    break;
		        case TBL_FLOAT4:
			    fp->Value.Size = 4;
			    if( *(fp->Value.Value.Float4) == BIG_4 ){
			        fp->Value.IsNull = 1;
			        fp->Value.Size = 0;
			    }
			    break;
		        case TBL_FLOAT8:
			    fp->Value.Size = 8;
			    if( *(fp->Value.Value.Float8) == BIG_4 ){
			        fp->Value.IsNull = 1;
			        fp->Value.Size = 0;
			    }
			    break;
		        case TBL_STRING:
			    fp->Value.Size = fp->Value.AllocatedSize;
			    if( strcmp(fp->Value.Value.String,"") == 0 ){
			        fp->Value.IsNull = 1;
			        fp->Value.Size = 0;
			    }
			    break;
		        case TBL_TEXT:
			case TBL_BINARYDATA:
			    fp->Value.Size = fp->Value.AllocatedSize;
			    if( ((DBBINARY *)dbtxptr(DBSelect,i)) == ((DBBINARY *)NULL) ){
			        fp->Value.IsNull = 1;
			        fp->Value.Size = 0;
			    }
			    break;
		    }
		}
		if( callback != NULL ){
		    if( callback(fieldList,*lp,ctx) != TBL_NORMAL ){
			dbcancel(DBSelect);
			dbfreebuf(DBSelect);
			dbclose(DBSelect);
		    	return COND_PushCondition(TBL_ERROR(TBL_EARLYEXIT), "TBL_Select");
		    }
		}
	    }
	}
    }

    dbclose(DBSelect);
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
TBL_Update(TBL_HANDLE **handle, TBL_CRITERIA *criteriaList,
	   TBL_UPDATE *updateList)
{
TBL_CONTEXT
    *tc;
TBL_UPDATE
    *up;
TBL_CRITERIA
    *cp;
char
    tabcol[100],
    *dbName,
    *tableName;
int
    i,
    ret,
    first,
    FoundTextorBinary,
    foundit;
DBBINARY
    *bin_ptr;

    tc = G_ContextHead;
    foundit = 0;
    while( tc != (TBL_CONTEXT *) NULL ){
	if( tc == (TBL_CONTEXT *) (*handle) ){
	    dbName = tc->databaseName;
	    tableName = tc->tableName;
	    foundit = 1;
	}
	tc = tc->next;
    }
    if( !foundit ){
    	return COND_PushCondition(TBL_ERROR(TBL_BADHANDLE), "TBL_Update");
    }
    /*
     * We found the names we need...now make sure we can access it.
     * Actually, given that we found it, we probably already know the
     * outcome of this command...but we do need to set up the correct
     * database for this update...
     */
    if( dbuse(G_DBUpdate, dbName) != SUCCEED ){
	return COND_PushCondition(TBL_ERROR(TBL_DBNOEXIST), "TBL_Update");
    }
    if( updateList == (TBL_UPDATE *)NULL ){
	return COND_PushCondition(TBL_ERROR(TBL_NOFIELDLIST), "TBL_Update");
    }
    dbfreebuf(G_DBUpdate);
    /*
     * Set up the update statement
     */
    up = updateList;
    dbfcmd(G_DBUpdate,"UPDATE %s SET ",tableName);
    first = 1;
    FoundTextorBinary = 0;
    while( up->FieldName != NULL ){
	if( up->Value.Type != TBL_TEXT && up->Value.Type != TBL_BINARYDATA ){
	    if( !first )
	        dbcmd(G_DBUpdate," , ");
	    dbfcmd(G_DBUpdate," %s = ",up->FieldName);
	    if( up->Function == TBL_SET )
	    	Add_Value_to_Sybuf(G_DBUpdate,(TBL_FIELD *)up);
	    else if( up->Function == TBL_ZERO )
	    	dbfcmd(G_DBUpdate," 0 ");
	    else if( up->Function == TBL_INCREMENT )
	    	dbfcmd(G_DBUpdate," %s + 1 ",up->FieldName);
	    else if( up->Function == TBL_DECREMENT )
	    	dbfcmd(G_DBUpdate," %s - 1 ",up->FieldName);
	    first = 0;
	}else{
    	    FoundTextorBinary = 1;
	}
	up++;
    }
    if( (cp=criteriaList) != (TBL_CRITERIA *)NULL ){
	dbcmd(G_DBUpdate," WHERE ");
    	Add_Criteria_to_Sybuf(G_DBUpdate,cp);
	cp++;
	while( cp->FieldName != NULL ){
	    dbcmd(G_DBUpdate," AND ");
	    Add_Criteria_to_Sybuf(G_DBUpdate,cp);
	    cp++;
	}
    }

    if( dbsqlexec(G_DBUpdate) == FAIL ){
	dbfreebuf(G_DBUpdate);
	return COND_PushCondition(TBL_ERROR(TBL_UPDATEFAILED), "TBL_Update");
    }
    dbfreebuf(G_DBUpdate);
    if( FoundTextorBinary ){
        up = updateList;
    	dbfcmd(G_DBUpdate,"SELECT ",tableName);
    	first = 1;
    	while( up->FieldName != NULL ){
	    if( up->Value.Type == TBL_TEXT || up->Value.Type == TBL_BINARYDATA ){
	        if( !first )
	            dbcmd(G_DBUpdate," , ");
	    	dbfcmd(G_DBUpdate," %s ",up->FieldName);
	    	first = 0;
	    }
	    up++;
    	}
	first = 1;
	dbfcmd(G_DBUpdate," FROM %s ",tableName);
    	if( (cp=criteriaList) != (TBL_CRITERIA *)NULL ){
	    dbcmd(G_DBUpdate," WHERE ");
    	    Add_Criteria_to_Sybuf(G_DBUpdate,cp);
	    cp++;
	    while( cp->FieldName != NULL ){
	        dbcmd(G_DBUpdate," AND ");
	        Add_Criteria_to_Sybuf(G_DBUpdate,cp);
	        cp++;
	    }
        }
    	if( dbsqlexec(G_DBUpdate) == FAIL ){
	    dbcancel(G_DBUpdate);
	    return COND_PushCondition(TBL_ERROR(TBL_UPDATEFAILED), "TBL_Update");
    	}
	/*
	 * Now we have done the select on the TEXT and BINARYDATA fields...so
	 * we need to rewrite that data...
	 */
	/*
	* Now retreive the rows..get the text pointer...and copy the data
	* from the users buffer to the database.
	*/
	if ( dbresults(G_DBUpdate) != NO_MORE_RESULTS ){
	    if( DBROWS(G_DBUpdate) == SUCCEED ){
	    	while( dbnextrow( G_DBUpdate ) != NO_MORE_ROWS ){
		    i = 1;
		    ret = SUCCEED;
		    for( up=updateList;up->FieldName != 0;up++){
			if( up->Value.Type == TBL_TEXT ){
			    sprintf(tabcol,"%s.%s",tableName,up->FieldName);
		    	    bin_ptr = dbtxptr(G_DBUpdate, i);
		    	    ret = dbwritetext( G_DBUpdate, tabcol, bin_ptr, DBTXPLEN,
				dbtxtimestamp(G_DBUpdate,i), TRUE,
				(DBINT)up->Value.AllocatedSize,
				(BYTE *)(up->Value.Value.Text) );
			    i++;
			}else if( up->Value.Type == TBL_BINARYDATA){
			    sprintf(tabcol,"%s.%s",tableName,up->FieldName);
		    	    bin_ptr = dbtxptr(G_DBUpdate, i);
		    	    ret = dbwritetext( G_DBUpdate, tabcol, bin_ptr, DBTXPLEN,
				dbtxtimestamp(G_DBUpdate,i), TRUE,
				(DBINT)up->Value.AllocatedSize,
				(BYTE *)(up->Value.Value.BinaryData) );
			    i++;
			}
		    	if( ret != SUCCEED ){
			    dbcancel(G_DBUpdate);
	    		    return COND_PushCondition(TBL_ERROR(TBL_INSERTFAILED), "TBL_Update");
			}
		    }
		}
	    }
	}
    }

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
TBL_Insert(TBL_HANDLE **handle, TBL_FIELD *fieldList)
{
TBL_CONTEXT
    *tc;
TBL_FIELD
    *fp;
char
    tabcol[100],
    *dbName,
    *tableName;
int
    i,
    ret,
    FoundTextorBinary,
    foundit;
DBBINARY
    *bin_ptr;

    tc = G_ContextHead;
    foundit = 0;
    while( tc != (TBL_CONTEXT *) NULL ){
	if( tc == (TBL_CONTEXT *) (*handle) ){
	    dbName = tc->databaseName;
	    tableName = tc->tableName;
	    foundit = 1;
	}
	tc = tc->next;
    }
    if( !foundit ){
    	return COND_PushCondition(TBL_ERROR(TBL_BADHANDLE), "TBL_Insert");
    }
    /*
     * We found the names we need...now make sure we can access it.
     * Actually, given that we found it, we probably already know the
     * outcome of this command...but we do need to set up the correct
     * database for this insert...
     */
    if( dbuse(G_DBInsert, dbName) != SUCCEED ){
	return COND_PushCondition(TBL_ERROR(TBL_DBNOEXIST), "TBL_Insert");
    }
    fp = fieldList;
    if( fp == (TBL_FIELD *)NULL ){
	return COND_PushCondition(TBL_ERROR(TBL_NOFIELDLIST), "TBL_Insert");
    }
    dbfreebuf(G_DBInsert);
    /*
     * Set up the insert statement
     */
    FoundTextorBinary =0;
    dbfcmd(G_DBInsert,"INSERT %s ( ",tableName);
    dbcmd(G_DBInsert,fp->FieldName);
    if( fp->Value.Type == TBL_TEXT || fp->Value.Type == TBL_BINARYDATA )
	FoundTextorBinary = 1;
    fp++;
    while( fp->FieldName != NULL ){
	dbcmd(G_DBInsert," , ");
	dbcmd(G_DBInsert,fp->FieldName);
    	if( fp->Value.Type == TBL_TEXT || fp->Value.Type == TBL_BINARYDATA )
	    FoundTextorBinary = 1;
	fp++;
    }
    dbcmd(G_DBInsert," ) VALUES ( ");

    fp = fieldList;
    Add_Value_to_Sybuf(G_DBInsert,fp);
    fp++;
    while( fp->FieldName != NULL ){
	dbcmd(G_DBInsert," , ");
	Add_Value_to_Sybuf(G_DBInsert,fp);
	fp++;
    }

    dbcmd(G_DBInsert," )");

    if( dbsqlexec(G_DBInsert) == FAIL ){
	dbfreebuf(G_DBInsert);
	return COND_PushCondition(TBL_ERROR(TBL_INSERTFAILED), "TBL_Insert");
    }
    dbfreebuf(G_DBInsert);

    if( FoundTextorBinary ){
	int first;
	first = 1;
	dbcmd(G_DBInsert,"SELECT ");
	for(fp=fieldList;fp->FieldName != 0;fp++){
	    if( fp->Value.Type == TBL_TEXT || fp->Value.Type == TBL_BINARYDATA ){
	    	if( !first )
		    dbcmd(G_DBInsert," , ");
		dbfcmd(G_DBInsert," %s ",fp->FieldName);
		first = 0;
	    }
	}	
	first = 1;
	dbfcmd(G_DBInsert," FROM %s WHERE ",tableName);
	for(fp=fieldList;fp->FieldName != 0;fp++){
	    if( fp->Value.Type != TBL_TEXT && fp->Value.Type != TBL_BINARYDATA ){
	    	if( !first )
		    dbcmd(G_DBInsert," AND ");
		dbfcmd(G_DBInsert," %s = ",fp->FieldName);
		Add_Value_to_Sybuf(G_DBInsert, fp);
		first = 0;
	    }
	}
	/*
	* Now retreive the rows..get the text pointer...and copy the data
	* from the users buffer to the database.
	*/
    	if( dbsqlexec(G_DBInsert) == FAIL ){
	    dbcancel(G_DBInsert);
	    return COND_PushCondition(TBL_ERROR(TBL_INSERTFAILED), "TBL_Insert");
    	}
	if ( dbresults(G_DBInsert) != NO_MORE_RESULTS ){
	    if( DBROWS(G_DBInsert) == SUCCEED ){
	    	while( dbnextrow( G_DBInsert ) != NO_MORE_ROWS ){
		    i = 1;
		    ret = SUCCEED;
		    for( fp=fieldList;fp->FieldName != 0;fp++){
			if( fp->Value.Type == TBL_TEXT ){
			    sprintf(tabcol,"%s.%s",tableName,fp->FieldName);
		    	    bin_ptr = dbtxptr(G_DBInsert, i);
		    	    ret = dbwritetext( G_DBInsert, tabcol, bin_ptr, DBTXPLEN,
				dbtxtimestamp(G_DBInsert,i), TRUE,
				(DBINT)fp->Value.AllocatedSize,
				(BYTE *)(fp->Value.Value.Text) );
			    i++;
			}else if( fp->Value.Type == TBL_BINARYDATA){
			    sprintf(tabcol,"%s.%s",tableName,fp->FieldName);
		    	    bin_ptr = dbtxptr(G_DBInsert, i);
		    	    ret = dbwritetext( G_DBInsert, tabcol, bin_ptr, DBTXPLEN,
				dbtxtimestamp(G_DBInsert,i), TRUE,
				(DBINT)fp->Value.AllocatedSize,
				(BYTE *)(fp->Value.Value.BinaryData) );
			    i++;
			}
		    	if( ret != SUCCEED ){
			    dbcancel(G_DBInsert);
	    		    return COND_PushCondition(TBL_ERROR(TBL_INSERTFAILED), "TBL_Insert");
			}
		    }
		}
	    }
	}
    }
    return TBL_NORMAL;
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
TBL_Delete(TBL_HANDLE **handle, TBL_CRITERIA *criteriaList)
{
TBL_CONTEXT
    *tc;
TBL_CRITERIA
    *cp;
char
    *dbName,
    *tableName;
int
    i,
    foundit;

    tc = G_ContextHead;
    foundit = 0;
    while( tc != (TBL_CONTEXT *) NULL ){
	if( tc == (TBL_CONTEXT *) (*handle) ){
	    dbName = tc->databaseName;
	    tableName = tc->tableName;
	    foundit = 1;
	}
	tc = tc->next;
    }
    if( !foundit ){
    	return COND_PushCondition(TBL_ERROR(TBL_BADHANDLE), "TBL_Delete");
    }
    /*
     * We found the names we need...now make sure we can access it.
     * Actually, given that we found it, we probably already know the
     * outcome of this command...but we do need to set up the correct
     * database for this delete...
     */
    if( dbuse(G_DBDelete, dbName) != SUCCEED ){
	return COND_PushCondition(TBL_ERROR(TBL_DBNOEXIST), "TBL_Delete");
    }
    dbfreebuf(G_DBDelete);
    /*
     * Set up the delete statement
     */
    dbcmd(G_DBDelete,"DELETE ");
    cp = criteriaList;
    if( cp == (TBL_CRITERIA *)NULL ){
	dbcmd(G_DBDelete,tableName);
    }else{
	dbfcmd(G_DBDelete," FROM %s WHERE ",tableName);
    	Add_Criteria_to_Sybuf(G_DBDelete,cp);
	cp++;
	while( cp->FieldName != NULL ){
	    dbcmd(G_DBDelete," AND ");
    	    Add_Criteria_to_Sybuf(G_DBDelete,cp);
	    cp++;
	}
    }
    if( dbsqlexec(G_DBDelete) == FAIL ){
	dbfreebuf(G_DBDelete);
	return COND_PushCondition(TBL_ERROR(TBL_DELETEFAILED), "TBL_Delete");
    }
    dbfreebuf(G_DBDelete);
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
**	TBL_BADHANDLE: The handle passed to the routine was invalid.
**	TBL_NOCALLBACK: No callback function was specified.
**	TBL_DBNOEXIST: The database specified does not exist.
**	TBL_SELECTFAILED: The select operation failed most probably from
**		a bad specification in the fieldList or criteriaList.  This
**		return is not the same as a valid query returning no records.
**		This error return could result from a misspelled keyword, etc.
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
TBL_Layout(char *databaseName, char *tableName, CONDITION(*callback) (), void *ctx)
{
TBL_FIELD
    field;
char
    column_name[DBMAXCOLNAME+1];
int
    i,
    tableid,
    system_type,
    user_length,
    foundit;

    if( callback == NULL ){
    	return COND_PushCondition(TBL_ERROR(TBL_NOCALLBACK), "TBL_Layout");
    }
    /*
     * We found the names we need...now make sure we can access it.
     * Actually, given that we found it, we probably already know the
     * outcome of this command...but we do need to set up the correct
     * database for this command anyway...
     */
    if( dbuse(G_DBLayout, databaseName) != SUCCEED ){
	return COND_PushCondition(TBL_ERROR(TBL_DBNOEXIST), "TBL_Layout");
    }
    dbfreebuf(G_DBLayout);
    /*
     * Set up the select statement
     */
    dbfcmd(G_DBLayout,"SELECT id from sysobjects where name=\"%s\" and type=\"U\"",tableName);
    if( dbsqlexec(G_DBLayout) == FAIL ){
	dbfreebuf(G_DBLayout);
	return COND_PushCondition(TBL_ERROR(TBL_SELECTFAILED), "TBL_Layout");
    }
    if( dbresults(G_DBLayout) != NO_MORE_RESULTS ){
	if( DBROWS(G_DBLayout) == SUCCEED ){
	    dbbind(G_DBLayout,1,INTBIND, (DBINT)4,(BYTE *)(&tableid));
	    /*
	     * There should only be one here...
	     */
	    while( dbnextrow(G_DBLayout) != NO_MORE_ROWS )
		;
	}else
	    return COND_PushCondition(TBL_ERROR(TBL_TBLNOEXIST), "TBL_Layout");
    }else
	return COND_PushCondition(TBL_ERROR(TBL_TBLNOEXIST), "TBL_Layout");
    /*
     * Now lets find each column and type for that table...
     */
    dbfcmd(G_DBLayout,"SELECT name,type,length from syscolumns where id=%d",tableid);
    if( dbsqlexec(G_DBLayout) == FAIL ){
	dbfreebuf(G_DBLayout);
	return COND_PushCondition(TBL_ERROR(TBL_SELECTFAILED), "TBL_Layout");
    }

    field.FieldName = column_name;
    if( dbresults(G_DBLayout) != NO_MORE_RESULTS ){
	if( DBROWS(G_DBLayout) == SUCCEED ){
	    dbbind(G_DBLayout,1,NTBSTRINGBIND, (DBINT)DBMAXCOLNAME+1,(BYTE *)(column_name));
	    dbbind(G_DBLayout,2,INTBIND, (DBINT)4,(BYTE *)(&system_type));
	    dbbind(G_DBLayout,3,INTBIND, (DBINT)4,(BYTE *)(&user_length));

	    while( dbnextrow(G_DBLayout) != NO_MORE_ROWS ){
		field.Value.AllocatedSize = user_length;
		switch(system_type){
		    case SYBBINARY:
		    case SYBVARBINARY:
		    case SYBIMAGE:
			field.Value.Type = TBL_BINARYDATA;
			break;
		    case SYBTEXT:
			field.Value.Type = TBL_TEXT;
			break;
		    case SYBVARCHAR:
		    case SYBCHAR:
			field.Value.Type = TBL_STRING;
			break;
		    case SYBINT2:
			field.Value.Type = TBL_SIGNED2;
			break;
		    case SYBINTN:
		    case SYBINT4:
			field.Value.Type = TBL_SIGNED4;
			break;
		    case SYBFLTN:
		    case SYBREAL:
			field.Value.Type = TBL_FLOAT4;
			break;
		    case SYBFLT8:
			field.Value.Type = TBL_FLOAT8;
			break;
		    default:
			field.Value.Type = TBL_OTHER;
			break;
		}
	        if( callback != NULL ){
	            if( callback(&field,ctx) != TBL_NORMAL ){
		        dbcancel(G_DBLayout);
		        dbfreebuf(G_DBLayout);
		        return COND_PushCondition(TBL_ERROR(TBL_EARLYEXIT), "TBL_Layout");
		    }
	        }
	    }
	} else
	    return COND_PushCondition(TBL_ERROR(TBL_NOCOLUMNS), "TBL_Layout");
    } else
	return COND_PushCondition(TBL_ERROR(TBL_NOCOLUMNS), "TBL_Layout");

    return TBL_NORMAL;
}


/*
** INTERNAL USE FUNCTION **
*/
static void
Add_Field_to_Select(DBPROCESS *DBSelect, TBL_FIELD *fp)
{

    dbfcmd(DBSelect," isnull(%s,",fp->FieldName);
    switch(fp->Value.Type){
	case TBL_SIGNED2:
	case TBL_UNSIGNED2:
	    dbfcmd(DBSelect,"%d)",BIG_2);
	    break;
	case TBL_SIGNED4:
	case TBL_UNSIGNED4:
	case TBL_FLOAT4:
	case TBL_FLOAT8:
	    dbfcmd(DBSelect,"%d)",BIG_4);
	    break;
	case TBL_STRING:
	    dbfcmd(DBSelect,"\"\")");
	    break;
    }
    return;
}
/*
** INTERNAL USE FUNCTION **
*/
static void
Add_Value_to_Sybuf(DBPROCESS *DBproc, TBL_FIELD *fp)
{

    switch(fp->Value.Type){
	case TBL_SIGNED2:
	    dbfcmd(DBproc,"%d",*(fp->Value.Value.Signed2));
	    break;
	case TBL_UNSIGNED2:
	    dbfcmd(DBproc,"%d",*(fp->Value.Value.Unsigned2));
	    break;
	case TBL_SIGNED4:
	    dbfcmd(DBproc,"%d",*(fp->Value.Value.Signed4));
	    break;
	case TBL_UNSIGNED4:
	    dbfcmd(DBproc,"%d",*(fp->Value.Value.Unsigned4));
	    break;
	case TBL_FLOAT4:
	    dbfcmd(DBproc,"%f",*(fp->Value.Value.Float4));
	    break;
	case TBL_FLOAT8:
	    dbfcmd(DBproc,"%f",*(fp->Value.Value.Float8));
	    break;
	case TBL_STRING:
	    dbfcmd(DBproc,"\"%s\"",fp->Value.Value.String);
	    break;
	/*
	 * These two types are simply initialized with something
	 * (anything) so that the database will initialize the
	 * internal addresses of these fields.
	 */
	case TBL_TEXT:
	    dbcmd(DBproc,"\"FILLER-WILL BE REPLACED\"");
	    break;
	case TBL_BINARYDATA:
	    dbcmd(DBproc,"0xFFFFFFFF");
	    break;
    }
    return;
}
/*
** INTERNAL USE FUNCTION **
*/
static void
Add_Criteria_to_Sybuf(DBPROCESS *DBproc, TBL_CRITERIA *cp)
{

    dbfcmd(DBproc,"%s",cp->FieldName);
    switch(cp->Operator){
	case TBL_NULL:
	    dbcmd(DBproc," is null ");
	    break;
	case TBL_NOT_NULL:
	    dbcmd(DBproc," is not null ");
	    break;
	case TBL_EQUAL:
	    dbcmd(DBproc," = ");
	    break;
	case TBL_LIKE:
	    dbcmd(DBproc," like ");
	    break;
	case TBL_NOT_EQUAL:
	    dbcmd(DBproc," != ");
	    break;
	case TBL_GREATER:
	    dbcmd(DBproc," > ");
	    break;
	case TBL_GREATER_EQUAL:
	    dbcmd(DBproc," >= ");
	    break;
	case TBL_LESS:
	    dbcmd(DBproc," < ");
	    break;
	case TBL_LESS_EQUAL:
	    dbcmd(DBproc," <= ");
	    break;
    }
    if( cp->Operator != TBL_NULL && cp->Operator != TBL_NOT_NULL ){
        switch(cp->Value.Type){
	    case TBL_SIGNED2:
	        dbfcmd(DBproc," %d ",*(cp->Value.Value.Signed2));
	        break;
	    case TBL_UNSIGNED2:
	        dbfcmd(DBproc," %d ",*(cp->Value.Value.Unsigned2));
	        break;
	    case TBL_SIGNED4:
	        dbfcmd(DBproc," %d ",*(cp->Value.Value.Signed4));
	        break;
	    case TBL_UNSIGNED4:
	        dbfcmd(DBproc," %d ",*(cp->Value.Value.Unsigned4));
	        break;
	    case TBL_FLOAT4:
	        dbfcmd(DBproc," %f ",*(cp->Value.Value.Float4));
	        break;
	    case TBL_FLOAT8:
	        dbfcmd(DBproc," %f ",*(cp->Value.Value.Float8));
	        break;
	    case TBL_STRING:
	        dbfcmd(DBproc,"\"%s\"",cp->Value.Value.String);
	        break;
        }
    }
    return;
}

/*
** INTERNAL USE FUNCTION **
*/
/*
 * The sybase error and message handlers....
 */
static int syb_err_handler(DBPROCESS *dbproc,
			int severity, int dberr, int oserr,
			char *dberrstr, char *oserrstr)
{

    if ((dbproc == NULL) || (DBDEAD(dbproc)))
	return(INT_EXIT);
    else{
	printf("DB-Library error:\n\t%s\n", dberrstr);
	if (oserr != DBNOERR)
	    printf("Operating-system error:\n\t%s\n", oserrstr);
	return(INT_CANCEL);
    }
}

/*
** INTERNAL USE FUNCTION **
*/
static int syb_msg_handler(DBPROCESS *dbproc, DBINT msgno,
			int msgstate, int severity,
			char *msgtext, char *srvname, char *procname,
			DBUSMALLINT line)
{
/*
 * SYBASE DUMPING CODE...
 *
    printf ("Msg %ld, Level %d, State %d\n", 
    msgno, severity, msgstate);
    if (strlen(srvname) > 0)
	printf ("Server '%s', ", srvname);
    if (strlen(procname) > 0)
	printf ("Procedure '%s', ", procname);
    if (line > 0)
	printf ("Line %d", line);
    printf("\n\t%s\n", msgtext);
*/
    return(0);
}
/*
 * SYBASE DUMPING CODE...
 *
{
char sybuf[1024];
dbstrcpy(G_DBxxx,0,-1,sybuf);
printf("%d: %s\n",strlen(sybuf),sybuf);
}
*/
