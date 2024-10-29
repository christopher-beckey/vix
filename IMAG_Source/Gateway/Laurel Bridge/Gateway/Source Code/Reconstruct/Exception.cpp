// Exception.cpp: implementation of the Exception class.
//
//////////////////////////////////////////////////////////////////////

/**********
Class Name: Exception
Base Class: n/a
Author: William Peterson
Copyrighted @ 2001

Purpose: 
Tracks the lastest exception code.  Internal structure
	maintains exception description relating to the code.
	Class also accepts additional exception information
	relating to the code.

Members:
m_iExceptionCode: Exception Code. 0 is success. -# is error.
m_code: Code listing in array.
m_description: Code description listing  in array.

Changes:
wfp	10/2/2001	Class creation.
wfp 01/23/2002	First build for Development testing.
wfp 01/25/2002	Added additional comments.
**********/

#include "reconstruct.h"

//////////////////////////////////////////////////////////////////////
// Construction/Destruction
//////////////////////////////////////////////////////////////////////

Exception::Exception()
{
	m_code[0] = 0;
	m_description[0] = "Success";
	m_code[1] = -1;
	m_description[1] = "No File";
	m_code[2] = -2;
	m_description[2] = "Invalid Filetype";
	m_code[3] = -3;
	m_description[3] = "Cannot Open File";
	m_code[4] = -4;
	m_description[4] = "Cannot Parse Message or File";
	m_code[5] = -5;
	m_description[5] = "Out of Resources";
	m_code[6] = -6;
	m_description[6] = "Tag already exists";
	m_code[7] = -7;
	m_description[7] = "Tag does not exists";
	m_code[8] = -8;
	m_description[8] = "Value exceeded Max Length";
	m_code[9] = -9;
	m_description[9] = "Type 1 Tag";
	m_code[10] = -10;
	m_description[10] = "Invalid Tag Data";
	m_code[11] = -11;
	m_description[11] = "Sequence Tag";
	m_code[12] = -12;
	m_description[12] = "Cannot Save File";
}

Exception::~Exception()
{

}

char * Exception::GetExceptionDescription(signed int iExceptionCode)
{
	int x;
	//Loop thru exception codes to get the correct exception description.
	for (x = 0; x < NUM_ERRS; x++)
	{
		if(iExceptionCode == m_code[x])
		{
			//return exception description
			return (m_description[x]);
		}
	}
	return ("");
}

void Exception::SetException(signed int iExceptionCode)
{
	//assign m_iExceptionCode argument to m_iExceptionCode state
	this->m_iExceptionCode = iExceptionCode;

}

signed int Exception::GetExceptionCode()
{
	//return exception code
	return(m_iExceptionCode);
}

char * Exception::CreateErrString(signed int iECode, char *cpErrInfo, USHORT *ipErrGroup, USHORT *ipErrElement)
{
	char *sentence;
	char *temp;
	char *descr;
	char *codeNbr;

	//initialize
	this->SetException(iECode);
	
	//allocate enough memory to hold description.
	codeNbr = (char *)malloc(6);
	memset (codeNbr, 0, 6);
	descr = (char *)malloc(MAX_DESCR_LEN+strlen(cpErrInfo)+28);
	memset (descr, 0, (MAX_DESCR_LEN+strlen(cpErrInfo)+28));
	sprintf(codeNbr, "%i, ",iECode);
	strcpy (descr, codeNbr);
	strcat(descr,this->GetExceptionDescription(iECode));
	//allocate memory to hold group/element info if needed.
	temp = (char *)malloc(20);
	memset (temp, 0, 20);
	strcat(descr,", ");
	strcat(descr,cpErrInfo);
	//determine if group and element values were sent to this method.
	if((ipErrGroup != 0x0) && (ipErrElement != 0x0))
	{
		//If so, place group/element values in temp as a string.
		sprintf(temp,", %4.4x %4.4x ", *ipErrGroup, *ipErrElement);
		strcat (descr,temp);
	}
	sentence = descr;
	free (temp);
	//sentence is a string containing the entire exception line 
	// built in this method.
	return (sentence);
}

