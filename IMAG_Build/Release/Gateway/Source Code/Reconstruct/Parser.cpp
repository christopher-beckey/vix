// Parser.cpp: implementation of the Parser class.
//
//////////////////////////////////////////////////////////////////////

/**********
Class Name: Parser
Base Class: n/a
Author: William Peterson
Copyrighted @ 2001

Purpose: 
	Utility class to parse through text files easily.  Methods
generally search for specific characters and return at that pointer 
value.

Members:

Changes:
wfp	10/2/2001	Class creation.
wfp 01/23/2002	First build for Development testing.
wfp	01/25/2002	Added additional comments.
**********/


#include "reconstruct.h"

//////////////////////////////////////////////////////////////////////
// Construction/Destruction
//////////////////////////////////////////////////////////////////////

Parser::Parser()
{

}

Parser::~Parser()
{

}

char * Parser::NonWhite(char *Bp)
{
	while ((*Bp == SPACE) || (*Bp == TAB))
		Bp++;
	return(Bp);
}

//Forward to next whitespace.  Return location of whitespace.
//Anything previous to that whitespace is ignored.
char * Parser::NextWhite(char *Bp)
{
	while ((*Bp != SPACE) && (*Bp != TAB)) {
		if (*Bp == EOL)
			return(Bp);
		Bp++;
	}
	return(Bp);
}

//Forward to next character.  Return location of character.
//Anything previous to that character is ignored.
char * Parser::NextWord(char *Bp)
{
	while ((*Bp == SPACE) || (*Bp == TAB)) {
		if (*Bp == EOL)
			return(Bp);
		Bp++;
	}
	return(NonWhite(Bp));
}

//Forward to next pipe symbol.  Return location of pipe.
//Anything previous to that pipe is ignored.
char * Parser::NextPipe(char *Bp)
{
	while (*Bp != '|')
	{
		if (*Bp == EOL)
			return(Bp);
		Bp++;
	}
	return (Bp);
}

//Forward to next comma. Return location of comma.
//Anything previous to that comma is ignored.
char * Parser::NextComma(char *Bp)
{
	while (*Bp != ',')
	{
		if (*Bp == EOL)
			return(Bp);
		Bp++;
	}
	return (Bp);

}

//Forward to the next carat.  Return location of the carat.
//Anything previous to that carat is ignored.
char * Parser::NextCaret(char *Bp)
{
	while (*Bp != '^')
	{
		if (*Bp == EOL)
			return (Bp);
		Bp++;
	}
	return (Bp);
}

//Determine length to EOL.
int Parser::CountToEOL(char *Bp)
{
	int x;
	int len;
	x = 0;
	len = 0;

	while(*Bp != EOL)
	{
		x++;
		Bp++;
	}
	len = x;
	return len;
}

//Forward to next character.  Return location of character.
//Anything previous to that character is ignored.
bool Parser::IsNextWord(char *Bp)
{
	while ((*Bp == SPACE) || (*Bp == TAB)) {
		Bp++;
	}
	if (*Bp == EOL)
	{
		return(FALSE);
	}
	else
	{
		return(TRUE);
	}
}
