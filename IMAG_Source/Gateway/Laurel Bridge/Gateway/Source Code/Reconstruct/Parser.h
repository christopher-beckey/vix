// Parser.h: interface for the Parser class.
//
//////////////////////////////////////////////////////////////////////

#if !defined(AFX_PARSER_H__04B40FCE_C127_4AF1_8EED_F3B37759DC6D__INCLUDED_)
#define AFX_PARSER_H__04B40FCE_C127_4AF1_8EED_F3B37759DC6D__INCLUDED_


#if _MSC_VER > 1000
#pragma once
#endif // _MSC_VER > 1000

class Parser  
{
public:
	int CountToEOL(char *);
	char * NextCaret (char *);
	char * NextComma( char *);
	char * NextPipe ( char *);
	char * NextWord (char *);
	char * NextWhite (char *);
	char * NonWhite (char *);
	bool  IsNextWord(char *);

	Parser();
	virtual ~Parser();

private:
};

#define SPACE           ' '
#define TAB             '\t'
#define EOL             '\n'

#endif // !defined(AFX_PARSER_H__04B40FCE_C127_4AF1_8EED_F3B37759DC6D__INCLUDED_)
