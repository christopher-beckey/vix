
# line 2 "gram.y"
/*
+-+-+-+-+-+-+-+-+-
*/
/*
**		     Electronic Radiology Laboratory
**		   Mallinckrodt Institute of Radiology
**		Washington University School of Medicine
**
** Module Name(s):
** Author, Date:	Aniruddha Gokhale, 24-May-1995
** Intent:		This file defines a Context Free grammar for defining
**			DICOM attributes that make up a DICOM object definition
** Last Update:		$Author: Vhaiswstarkm $, $Date: 11/04/10 9:20a $
** Source File:		$RCSfile: gram_mod_w32.c,v $
** Revision:		$Revision: 1 $
** Status:		$State: Exp $
*/

static char rcsid[] = "$Revision: 1 $ $RCSfile: gram_mod_w32.c,v $";
#include "modify.h"	/* common declarations */
CONDITION
	cond;		/* status code returned by DICOM facilities */

# line 25 "gram.y"
typedef union
#ifdef __cplusplus
	YYSTYPE
#endif
{
	unsigned long	num;
	char		str[DICOM_LO_LENGTH+1];
	char		*s;
	DCM_ELEMENT	*e;
	LST_HEAD	*l;
	void		*v;
} YYSTYPE;
# define NUMBER 257
# define VALUE 258

#ifdef __STDC__
#include <stdlib.h>
#include <string.h>
#else
#include <malloc.h>
#include <memory.h>
#endif

/*#include <values.h>*/

#ifdef __cplusplus

#ifndef yyerror
	void yyerror(const char *);
#endif

#ifndef yylex
#ifdef __EXTERN_C__
	extern "C" { int yylex(void); }
#else
	int yylex(void);
#endif
#endif
	int yyparse(void);

#endif
#define yyclearin yychar = -1
#define yyerrok yyerrflag = 0
extern int yychar;
extern int yyerrflag;
YYSTYPE yylval;
YYSTYPE yyval;
typedef int yytabelem;
#ifndef YYMAXDEPTH
#define YYMAXDEPTH 150
#endif
#if YYMAXDEPTH > 0
int yy_yys[YYMAXDEPTH], *yys = yy_yys;
YYSTYPE yy_yyv[YYMAXDEPTH], *yyv = yy_yyv;
#else	/* user does initial allocation */
int *yys;
YYSTYPE *yyv;
#endif
static int yymaxdepth = YYMAXDEPTH;
# define YYERRCODE 256

# line 313 "gram.y"

yytabelem yyexca[] ={
-1, 1,
	0, -1,
	-2, 0,
	};
# define YYNPROD 20
# define YYLAST 222
yytabelem yyact[]={

    15,    12,    31,    30,    29,    23,    17,     6,     4,    28,
    26,    33,    12,    24,    15,     9,     3,     2,    14,     5,
    12,    10,     7,    19,    18,    11,     1,     0,     0,    21,
    16,     0,     0,    22,     0,     0,     0,     0,     0,     5,
     0,     0,     0,     0,    32,     0,     0,     0,     0,     0,
     0,     0,     0,     0,     0,     0,     0,     0,     0,     0,
     0,     0,     0,     0,     0,     0,     0,     0,     0,     0,
     0,     0,     0,     0,     0,     0,     0,     0,     0,     0,
     0,     0,     0,    13,     0,     0,     0,     0,     0,     0,
    27,    25,     0,     0,     0,     0,     0,     0,     0,     0,
     0,     0,     0,     0,     0,     0,     0,     0,     0,     0,
     0,     0,     0,     0,     0,     0,     0,     0,     0,     0,
     0,     0,     0,     0,     0,     0,     0,     0,     0,     0,
     0,     0,     0,     0,     0,     0,     0,     0,     0,     0,
     0,     0,     0,     0,     0,     0,     0,     0,     0,     0,
     0,     0,     0,     0,     0,     0,     0,     0,     0,     0,
     0,     0,     0,     0,     0,     0,     0,     0,     0,     0,
     0,     0,     0,     0,     0,     0,     0,     0,     0,     0,
     0,     0,     0,     0,     0,     0,     0,     0,     0,     0,
     0,     0,     0,     0,     0,     0,     0,     0,     0,    20,
     0,     0,     0,     0,     0,     0,     0,     0,     0,     0,
     0,     0,     0,     0,     0,     0,     0,     0,     8,     0,
     4,     4 };
yytabelem yypact[]={

  -249,-10000000,  -249,-10000000,  -250,-10000000,   -40,-10000000,-10000000,-10000000,
-10000000,   -26,  -252,   -59,-10000000,   -36,-10000000,   -31,   -34,   -35,
-10000000,-10000000,   -37,-10000000,  -255,-10000000,  -256,-10000000,   -48,-10000000,
   -51,-10000000,-10000000,-10000000 };
yytabelem yypgo[]={

     0,    26,    17,    25,    18,    24,    23,    16,    22,    21,
    15 };
yytabelem yyr1[]={

     0,     1,     2,     2,     7,     8,     8,     8,     8,     9,
     9,     5,     5,     6,     6,    10,     3,     3,     4,     4 };
yytabelem yyr2[]={

     0,     3,     5,     3,     7,     3,     3,     3,     3,     7,
     7,     7,     3,     7,     3,    11,     5,     3,     7,     5 };
yytabelem yychk[]={

-10000000,    -1,    -2,    -7,   257,    -7,   257,    -8,   258,   -10,
    -9,    -3,    60,   123,    -4,    40,    -4,   258,    -5,    -6,
   258,   -10,    -2,    41,    44,   125,    44,   125,    44,    41,
   258,   258,   -10,    62 };
yytabelem yydef[]={

     0,    -2,     1,     3,     0,     2,     0,     4,     5,     6,
     7,     8,     0,     0,    17,     0,    16,     0,     0,     0,
    12,    14,     0,    19,     0,     9,     0,    10,     0,    18,
     0,    11,    13,    15 };
typedef struct
#ifdef __cplusplus
	yytoktype
#endif
{ char *t_name; int t_val; } yytoktype;
#ifndef YYDEBUG
#	define YYDEBUG	0	/* don't allow debugging */
#endif

#if YYDEBUG

yytoktype yytoks[] =
{
	"NUMBER",	257,
	"VALUE",	258,
	"-unknown-",	-1	/* ends search */
};

char * yyreds[] =
{
	"-no such reduction-",
	"dicom_object : element_list",
	"element_list : element_list element",
	"element_list : element",
	"element : NUMBER NUMBER value",
	"value : VALUE",
	"value : tag",
	"value : multiple_value",
	"value : sequence",
	"multiple_value : '{' value_list '}'",
	"multiple_value : '{' tag_list '}'",
	"value_list : value_list ',' VALUE",
	"value_list : VALUE",
	"tag_list : tag_list ',' tag",
	"tag_list : tag",
	"tag : '<' VALUE ',' VALUE '>'",
	"sequence : sequence item",
	"sequence : item",
	"item : '(' element_list ')'",
	"item : '(' ')'",
};
#endif /* YYDEBUG */
/*
 * Copyright (c) 1993 by Sun Microsystems, Inc.
 */

#pragma ident	"@(#)yaccpar	6.12	93/06/07 SMI"

/*
** Skeleton parser driver for yacc output
*/

/*
** yacc user known macros and defines
*/
#define YYERROR		goto yyerrlab
#define YYACCEPT	return(0)
#define YYABORT		return(1)
#define YYBACKUP( newtoken, newvalue )\
{\
	if ( yychar >= 0 || ( yyr2[ yytmp ] >> 1 ) != 1 )\
	{\
		yyerror( "syntax error - cannot backup" );\
		goto yyerrlab;\
	}\
	yychar = newtoken;\
	yystate = *yyps;\
	yylval = newvalue;\
	goto yynewstate;\
}
#define YYRECOVERING()	(!!yyerrflag)
#define YYNEW(type)	malloc(sizeof(type) * yynewmax)
#define YYCOPY(to, from, type) \
	(type *) memcpy(to, (char *) from, yynewmax * sizeof(type))
#define YYENLARGE( from, type) \
	(type *) realloc((char *) from, yynewmax * sizeof(type))
#ifndef YYDEBUG
#	define YYDEBUG	1	/* make debugging available */
#endif

/*
** user known globals
*/
int yydebug;			/* set to 1 to get debugging */

/*
** driver internal defines
*/
#define YYFLAG		(-10000000)

/*
** global variables used by the parser
*/
YYSTYPE *yypv;			/* top of value stack */
int *yyps;			/* top of state stack */

int yystate;			/* current state */
int yytmp;			/* extra var (lasts between blocks) */

int yynerrs;			/* number of errors */
int yyerrflag;			/* error recovery flag */
int yychar;			/* current input token number */



#ifdef YYNMBCHARS
#define YYLEX()		yycvtok(yylex())
/*
** yycvtok - return a token if i is a wchar_t value that exceeds 255.
**	If i<255, i itself is the token.  If i>255 but the neither 
**	of the 30th or 31st bit is on, i is already a token.
*/
#if defined(__STDC__) || defined(__cplusplus)
int yycvtok(int i)
#else
int yycvtok(i) int i;
#endif
{
	int first = 0;
	int last = YYNMBCHARS - 1;
	int mid;
	wchar_t j;

	if(i&0x60000000){/*Must convert to a token. */
		if( yymbchars[last].character < i ){
			return i;/*Giving up*/
		}
		while ((last>=first)&&(first>=0)) {/*Binary search loop*/
			mid = (first+last)/2;
			j = yymbchars[mid].character;
			if( j==i ){/*Found*/ 
				return yymbchars[mid].tvalue;
			}else if( j<i ){
				first = mid + 1;
			}else{
				last = mid -1;
			}
		}
		/*No entry in the table.*/
		return i;/* Giving up.*/
	}else{/* i is already a token. */
		return i;
	}
}
#else/*!YYNMBCHARS*/
#define YYLEX()		yylex()
#endif/*!YYNMBCHARS*/

/*
** yyparse - return 0 if worked, 1 if syntax error not recovered from
*/
#if defined(__STDC__) || defined(__cplusplus)
int yyparse(void)
#else
int yyparse()
#endif
{
	register YYSTYPE *yypvt;	/* top of value stack for $vars */

#if defined(__cplusplus) || defined(lint)
/*
	hacks to please C++ and lint - goto's inside switch should never be
	executed; yypvt is set to 0 to avoid "used before set" warning.
*/
	static int __yaccpar_lint_hack__ = 0;
	switch (__yaccpar_lint_hack__)
	{
		case 1: goto yyerrlab;
		case 2: goto yynewstate;
	}
	yypvt = 0;
#endif

	/*
	** Initialize externals - yyparse may be called more than once
	*/
	yypv = &yyv[-1];
	yyps = &yys[-1];
	yystate = 0;
	yytmp = 0;
	yynerrs = 0;
	yyerrflag = 0;
	yychar = -1;

#if YYMAXDEPTH <= 0
	if (yymaxdepth <= 0)
	{
		if ((yymaxdepth = YYEXPAND(0)) <= 0)
		{
			yyerror("yacc initialization error");
			YYABORT;
		}
	}
#endif

	{
		register YYSTYPE *yy_pv;	/* top of value stack */
		register int *yy_ps;		/* top of state stack */
		register int yy_state;		/* current state */
		register int  yy_n;		/* internal state number info */
	goto yystack;	/* moved from 6 lines above to here to please C++ */

		/*
		** get globals into registers.
		** branch to here only if YYBACKUP was called.
		*/
	yynewstate:
		yy_pv = yypv;
		yy_ps = yyps;
		yy_state = yystate;
		goto yy_newstate;

		/*
		** get globals into registers.
		** either we just started, or we just finished a reduction
		*/
	yystack:
		yy_pv = yypv;
		yy_ps = yyps;
		yy_state = yystate;

		/*
		** top of for (;;) loop while no reductions done
		*/
	yy_stack:
		/*
		** put a state and value onto the stacks
		*/
#if YYDEBUG
		/*
		** if debugging, look up token value in list of value vs.
		** name pairs.  0 and negative (-1) are special values.
		** Note: linear search is used since time is not a real
		** consideration while debugging.
		*/
		if ( yydebug )
		{
			register int yy_i;

			printf( "State %d, token ", yy_state );
			if ( yychar == 0 )
				printf( "end-of-file\n" );
			else if ( yychar < 0 )
				printf( "-none-\n" );
			else
			{
				for ( yy_i = 0; yytoks[yy_i].t_val >= 0;
					yy_i++ )
				{
					if ( yytoks[yy_i].t_val == yychar )
						break;
				}
				printf( "%s\n", yytoks[yy_i].t_name );
			}
		}
#endif /* YYDEBUG */
		if ( ++yy_ps >= &yys[ yymaxdepth ] )	/* room on stack? */
		{
			/*
			** reallocate and recover.  Note that pointers
			** have to be reset, or bad things will happen
			*/
			int yyps_index = (yy_ps - yys);
			int yypv_index = (yy_pv - yyv);
			int yypvt_index = (yypvt - yyv);
			int yynewmax;
#ifdef YYEXPAND
			yynewmax = YYEXPAND(yymaxdepth);
#else
			yynewmax = 2 * yymaxdepth;	/* double table size */
			if (yymaxdepth == YYMAXDEPTH)	/* first time growth */
			{
				char *newyys = (char *)YYNEW(int);
				char *newyyv = (char *)YYNEW(YYSTYPE);
				if (newyys != 0 && newyyv != 0)
				{
					yys = YYCOPY(newyys, yys, int);
					yyv = YYCOPY(newyyv, yyv, YYSTYPE);
				}
				else
					yynewmax = 0;	/* failed */
			}
			else				/* not first time */
			{
				yys = YYENLARGE(yys, int);
				yyv = YYENLARGE(yyv, YYSTYPE);
				if (yys == 0 || yyv == 0)
					yynewmax = 0;	/* failed */
			}
#endif
			if (yynewmax <= yymaxdepth)	/* tables not expanded */
			{
				yyerror( "yacc stack overflow" );
				YYABORT;
			}
			yymaxdepth = yynewmax;

			yy_ps = yys + yyps_index;
			yy_pv = yyv + yypv_index;
			yypvt = yyv + yypvt_index;
		}
		*yy_ps = yy_state;
		*++yy_pv = yyval;

		/*
		** we have a new state - find out what to do
		*/
	yy_newstate:
		if ( ( yy_n = yypact[ yy_state ] ) <= YYFLAG )
			goto yydefault;		/* simple state */
#if YYDEBUG
		/*
		** if debugging, need to mark whether new token grabbed
		*/
		yytmp = yychar < 0;
#endif
		if ( ( yychar < 0 ) && ( ( yychar = YYLEX() ) < 0 ) )
			yychar = 0;		/* reached EOF */
#if YYDEBUG
		if ( yydebug && yytmp )
		{
			register int yy_i;

			printf( "Received token " );
			if ( yychar == 0 )
				printf( "end-of-file\n" );
			else if ( yychar < 0 )
				printf( "-none-\n" );
			else
			{
				for ( yy_i = 0; yytoks[yy_i].t_val >= 0;
					yy_i++ )
				{
					if ( yytoks[yy_i].t_val == yychar )
						break;
				}
				printf( "%s\n", yytoks[yy_i].t_name );
			}
		}
#endif /* YYDEBUG */
		if ( ( ( yy_n += yychar ) < 0 ) || ( yy_n >= YYLAST ) )
			goto yydefault;
		if ( yychk[ yy_n = yyact[ yy_n ] ] == yychar )	/*valid shift*/
		{
			yychar = -1;
			yyval = yylval;
			yy_state = yy_n;
			if ( yyerrflag > 0 )
				yyerrflag--;
			goto yy_stack;
		}

	yydefault:
		if ( ( yy_n = yydef[ yy_state ] ) == -2 )
		{
#if YYDEBUG
			yytmp = yychar < 0;
#endif
			if ( ( yychar < 0 ) && ( ( yychar = YYLEX() ) < 0 ) )
				yychar = 0;		/* reached EOF */
#if YYDEBUG
			if ( yydebug && yytmp )
			{
				register int yy_i;

				printf( "Received token " );
				if ( yychar == 0 )
					printf( "end-of-file\n" );
				else if ( yychar < 0 )
					printf( "-none-\n" );
				else
				{
					for ( yy_i = 0;
						yytoks[yy_i].t_val >= 0;
						yy_i++ )
					{
						if ( yytoks[yy_i].t_val
							== yychar )
						{
							break;
						}
					}
					printf( "%s\n", yytoks[yy_i].t_name );
				}
			}
#endif /* YYDEBUG */
			/*
			** look through exception table
			*/
			{
				register int *yyxi = yyexca;

				while ( ( *yyxi != -1 ) ||
					( yyxi[1] != yy_state ) )
				{
					yyxi += 2;
				}
				while ( ( *(yyxi += 2) >= 0 ) &&
					( *yyxi != yychar ) )
					;
				if ( ( yy_n = yyxi[1] ) < 0 )
					YYACCEPT;
			}
		}

		/*
		** check for syntax error
		*/
		if ( yy_n == 0 )	/* have an error */
		{
			/* no worry about speed here! */
			switch ( yyerrflag )
			{
			case 0:		/* new error */
				yyerror( "syntax error" );
				goto skip_init;
			yyerrlab:
				/*
				** get globals into registers.
				** we have a user generated syntax type error
				*/
				yy_pv = yypv;
				yy_ps = yyps;
				yy_state = yystate;
			skip_init:
				yynerrs++;
				/* FALLTHRU */
			case 1:
			case 2:		/* incompletely recovered error */
					/* try again... */
				yyerrflag = 3;
				/*
				** find state where "error" is a legal
				** shift action
				*/
				while ( yy_ps >= yys )
				{
					yy_n = yypact[ *yy_ps ] + YYERRCODE;
					if ( yy_n >= 0 && yy_n < YYLAST &&
						yychk[yyact[yy_n]] == YYERRCODE)					{
						/*
						** simulate shift of "error"
						*/
						yy_state = yyact[ yy_n ];
						goto yy_stack;
					}
					/*
					** current state has no shift on
					** "error", pop stack
					*/
#if YYDEBUG
#	define _POP_ "Error recovery pops state %d, uncovers state %d\n"
					if ( yydebug )
						printf( _POP_, *yy_ps,
							yy_ps[-1] );
#	undef _POP_
#endif
					yy_ps--;
					yy_pv--;
				}
				/*
				** there is no state on stack with "error" as
				** a valid shift.  give up.
				*/
				YYABORT;
			case 3:		/* no shift yet; eat a token */
#if YYDEBUG
				/*
				** if debugging, look up token in list of
				** pairs.  0 and negative shouldn't occur,
				** but since timing doesn't matter when
				** debugging, it doesn't hurt to leave the
				** tests here.
				*/
				if ( yydebug )
				{
					register int yy_i;

					printf( "Error recovery discards " );
					if ( yychar == 0 )
						printf( "token end-of-file\n" );
					else if ( yychar < 0 )
						printf( "token -none-\n" );
					else
					{
						for ( yy_i = 0;
							yytoks[yy_i].t_val >= 0;
							yy_i++ )
						{
							if ( yytoks[yy_i].t_val
								== yychar )
							{
								break;
							}
						}
						printf( "token %s\n",
							yytoks[yy_i].t_name );
					}
				}
#endif /* YYDEBUG */
				if ( yychar == 0 )	/* reached EOF. quit */
					YYABORT;
				yychar = -1;
				goto yy_newstate;
			}
		}/* end if ( yy_n == 0 ) */
		/*
		** reduction by production yy_n
		** put stack tops, etc. so things right after switch
		*/
#if YYDEBUG
		/*
		** if debugging, print the string that is the user's
		** specification of the reduction which is just about
		** to be done.
		*/
		if ( yydebug )
			printf( "Reduce by (%d) \"%s\"\n",
				yy_n, yyreds[ yy_n ] );
#endif
		yytmp = yy_n;			/* value to switch over */
		yypvt = yy_pv;			/* $vars top of value stack */
		/*
		** Look in goto table for next state
		** Sorry about using yy_state here as temporary
		** register variable, but why not, if it works...
		** If yyr2[ yy_n ] doesn't have the low order bit
		** set, then there is no action to be done for
		** this reduction.  So, no saving & unsaving of
		** registers done.  The only difference between the
		** code just after the if and the body of the if is
		** the goto yy_stack in the body.  This way the test
		** can be made before the choice of what to do is needed.
		*/
		{
			/* length of production doubled with extra bit */
			register int yy_len = yyr2[ yy_n ];

			if ( !( yy_len & 01 ) )
			{
				yy_len >>= 1;
				yyval = ( yy_pv -= yy_len )[1];	/* $$ = $1 */
				yy_state = yypgo[ yy_n = yyr1[ yy_n ] ] +
					*( yy_ps -= yy_len ) + 1;
				if ( yy_state >= YYLAST ||
					yychk[ yy_state =
					yyact[ yy_state ] ] != -yy_n )
				{
					yy_state = yyact[ yypgo[ yy_n ] ];
				}
				goto yy_stack;
			}
			yy_len >>= 1;
			yyval = ( yy_pv -= yy_len )[1];	/* $$ = $1 */
			yy_state = yypgo[ yy_n = yyr1[ yy_n ] ] +
				*( yy_ps -= yy_len ) + 1;
			if ( yy_state >= YYLAST ||
				yychk[ yy_state = yyact[ yy_state ] ] != -yy_n )
			{
				yy_state = yyact[ yypgo[ yy_n ] ];
			}
		}
					/* save until reenter driver code */
		yystate = yy_state;
		yyps = yy_ps;
		yypv = yy_pv;
	}
	/*
	** code supplied by user is placed in this switch
	*/
	switch( yytmp )
	{
		
case 1:
# line 43 "gram.y"
{
		modlist = yyval.l;
	  } break;
case 2:
# line 50 "gram.y"
{
	     APP_ELEMLIST *ael;

	     ael = (APP_ELEMLIST *)malloc(sizeof(APP_ELEMLIST));
	     if (ael == NULL){
		printf("malloc: failed to acquire memory for element list\n");
		exit(1);
	     }
	     ael->e = yypvt[-0].e;
	     /* now enqueue this item */
	     cond = LST_Enqueue(&yypvt[-1].l, ael);
	     if (cond != LST_NORMAL){
		printf("LST_Enqueue: Cannot enqueue elementlist item\n");
		COND_DumpConditions();
		exit(1);
	     }
	     yyval.l = yypvt[-1].l;
	  } break;
case 3:
# line 69 "gram.y"
{
	     LST_HEAD *lh;
	     APP_ELEMLIST *ael;

	     lh = LST_Create();
	     if (lh == NULL){
		printf("LST_Create: Out of memory creating list");
		COND_DumpConditions();
		exit(1);
	     }

	     ael = (APP_ELEMLIST *)malloc(sizeof(APP_ELEMLIST));
	     if (ael == NULL){
		printf("malloc: failed to acquire memory for element list\n");
		exit(1);
	     }
	     ael->e = yypvt[-0].e;
	     /* now enqueue this item */
	     cond = LST_Enqueue(&lh, ael);
	     if (cond != LST_NORMAL){
		printf("LST_Enqueue: Cannot enqueue elementlist item\n");
		COND_DumpConditions();
		exit(1);
	     }
	     yyval.l = lh;
	  } break;
case 4:
# line 99 "gram.y"
{
		DCM_ELEMENT
			*e;

		cond = makeElement(yypvt[-2].num, yypvt[-1].num, yypvt[-0].v, &e);
		if (cond != DCM_NORMAL){
		   printf("Cannot make element for TAG (%x, %x)\n",
				yypvt[-2].num, yypvt[-1].num);
		   exit(1);
		}
		yyval.e = e;
	  } break;
case 5:
# line 114 "gram.y"
{ yyval.v = strdup(yypvt[-0].str); } break;
case 6:
# line 115 "gram.y"
{ yyval.v = strdup(yypvt[-0].str); } break;
case 7:
# line 116 "gram.y"
{ yyval.v = yypvt[-0].s; } break;
case 8:
# line 117 "gram.y"
{ yyval.v = yypvt[-0].l; } break;
case 9:
# line 122 "gram.y"
{ 
			 char *str;

			 cond = DCM_ListToString(yypvt[-1].l, 
				STRUCT_OFFSET(MULTVAL_ITEM,str), &str);
			 if (cond != DCM_NORMAL){
			     printf("DCM_ListToString failed\n");
			     COND_DumpConditions();
			     exit(1);
			 }
			 yyval.s = str;
		} break;
case 10:
# line 135 "gram.y"
{ 
			 char *str;

			 cond = DCM_ListToString(yypvt[-1].l, 
				STRUCT_OFFSET(MULTVAL_ITEM,str), &str);
			 if (cond != DCM_NORMAL){
			     printf("DCM_ListToString failed\n");
			     COND_DumpConditions();
			     exit(1);
			 }
			 yyval.s = str;
		} break;
case 11:
# line 151 "gram.y"
{
	      MULTVAL_ITEM *mvi;

	      mvi = (MULTVAL_ITEM *)malloc(sizeof(MULTVAL_ITEM));
	      if (mvi == NULL){
		 printf("malloc: Out of memory for multi-valued item\n");
		 exit(1);
	      }
	      strcpy(mvi->str, yypvt[-0].str);
	      cond = LST_Enqueue(&yypvt[-2].l,mvi);
	      if (cond != LST_NORMAL){
		 printf("LST_Enqueue: failed to enqueue multi-valued item\n");
		 COND_DumpConditions();
		 exit(1);
	      }
	      yyval.l = yypvt[-2].l;
	  } break;
case 12:
# line 169 "gram.y"
{
	      LST_HEAD *lh;
	      MULTVAL_ITEM *mvi;

	      lh = LST_Create();
	      if (lh == NULL){
		 printf("LST_Create: Out of memory for multi-valued list\n");
		 exit(1);
	      }
	      mvi = (MULTVAL_ITEM *)malloc(sizeof(MULTVAL_ITEM));
	      if (mvi == NULL){
		 printf("malloc: Out of memory for multi-valued item\n");
		 exit(1);
	      }
	      strcpy(mvi->str, yypvt[-0].str);
	      cond = LST_Enqueue(&lh,mvi);
	      if (cond != LST_NORMAL){
		 printf("LST_Enqueue: failed to enqueue multi-valued item\n");
		 COND_DumpConditions();
		 exit(1);
	      }
	      yyval.l = lh;
	  } break;
case 13:
# line 196 "gram.y"
{
	      MULTVAL_ITEM *mvi;

	      mvi = (MULTVAL_ITEM *)malloc(sizeof(MULTVAL_ITEM));
	      if (mvi == NULL){
		 printf("malloc: Out of memory for multi-valued item\n");
		 exit(1);
	      }
	      strcpy(mvi->str, yypvt[-0].str);
	      cond = LST_Enqueue(&yypvt[-2].l,mvi);
	      if (cond != LST_NORMAL){
		 printf("LST_Enqueue: failed to enqueue multi-valued item\n");
		 COND_DumpConditions();
		 exit(1);
	      }
	      yyval.l = yypvt[-2].l;
	  } break;
case 14:
# line 214 "gram.y"
{
	      LST_HEAD *lh;
	      MULTVAL_ITEM *mvi;

	      lh = LST_Create();
	      if (lh == NULL){
		 printf("LST_Create: Out of memory for multi-valued list\n");
		 exit(1);
	      }
	      mvi = (MULTVAL_ITEM *)malloc(sizeof(MULTVAL_ITEM));
	      if (mvi == NULL){
		 printf("malloc: Out of memory for multi-valued item\n");
		 exit(1);
	      }
	      strcpy(mvi->str, yypvt[-0].str);
	      cond = LST_Enqueue(&lh,mvi);
	      if (cond != LST_NORMAL){
		 printf("LST_Enqueue: failed to enqueue multi-valued item\n");
		 COND_DumpConditions();
		 exit(1);
	      }
	      yyval.l = lh;
	  } break;
case 15:
# line 241 "gram.y"
{
	     unsigned short
		group, elem;

	     sscanf(yypvt[-3].str, "%hx",&group);
	     sscanf(yypvt[-1].str, "%hx",&elem);
	     sprintf(yyval.str,"%ld",DCM_MAKETAG(group,elem));
	  } break;
case 16:
# line 253 "gram.y"
{
	     APP_ITEMSEQ
		*ais;

	     ais = (APP_ITEMSEQ *)malloc(sizeof(APP_ITEMSEQ));
	     if (ais == NULL){
		printf("malloc: Out of memory allocating APP_ITEMSEQ\n");
		exit(1);
	     }
	     ais->ael = yypvt[-0].l;
	     /* now enqueue this item */
	     cond = LST_Enqueue(&yypvt[-1].l, ais);
	     if (cond != LST_NORMAL){
		printf("LST_Enqueue: Cannot enqueue sequence item\n");
		COND_DumpConditions();
		exit(1);
	     }
	     yyval.l = yypvt[-1].l;
	  } break;
case 17:
# line 273 "gram.y"
{
	     LST_HEAD
		*lh;
	     APP_ITEMSEQ
		*ais;

	     lh = LST_Create();
	     if (lh == NULL){
		printf("LST_Create: cannot create sequence list\n");
		COND_DumpConditions();
		exit(1);
	     }

	     ais = (APP_ITEMSEQ *)malloc(sizeof(APP_ITEMSEQ));
	     if (ais == NULL){
		printf("malloc: Out of memory allocating APP_ITEMSEQ\n");
		exit(1);
	     }
	     ais->ael = yypvt[-0].l;
	     /* now enqueue this item */
	     cond = LST_Enqueue(&lh, ais);
	     if (cond != LST_NORMAL){
		printf("LST_Enqueue: Cannot enqueue sequence item\n");
		COND_DumpConditions();
		exit(1);
	     }
	     yyval.l = lh;
	  } break;
case 18:
# line 305 "gram.y"
{
		yyval.l = yypvt[-1].l;
	  } break;
case 19:
# line 309 "gram.y"
{
		yyval.l = NULL;
	  } break;
	}
	goto yystack;		/* reset registers in driver code */
}

