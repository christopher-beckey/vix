// LineEntry.cpp: implementation of the LineEntry class.
//
//////////////////////////////////////////////////////////////////////

/**********
Class Name: LineEntry
Base Class: n/a
Author: William Peterson
Copyrighted @ 2001

Purpose: 
Store states of a single line from a text file containing DICOM
	information.  This text file is organized in a specific
	fashion to only use with DICOM.

Members:
m_iDCMGroup: DICOM Group value.
m_iDCMElement: DICOM Element value
m_cDCMValue: DICOM Value value relating to the current group/
element state.

Changes:
wfp	10/2/2001	Class creation.
wfp 01/23/2002	First build for Development testing.
wfp	01/25/2002	Added additional comments.
wfp 06/21/2003  Added code to deconstructor to avoid memeory leaks.
**********/

#include "reconstruct.h"

//////////////////////////////////////////////////////////////////////
// Construction/Destruction
//////////////////////////////////////////////////////////////////////

LineEntry::LineEntry()
{

}

LineEntry::~LineEntry()
{
    //Added to avoid memory leaks
	if(*this->m_cDCMValue)
	{
		free(this->m_cDCMValue);
	}

}

void LineEntry::SetTag(USHORT iTagGroup, USHORT iTagElement, char *cTagValue)
{
	//assign group argument to group variable
	m_iDCMGroup = iTagGroup;
	//assign element argument to element variable
	m_iDCMElement = iTagElement;
	//Assign value argument to value variable.
	m_cDCMValue = cTagValue;

}


void LineEntry::GetTag(USHORT *ipTagGroup, USHORT *ipTagElement, char *cTagValue)
{

	//assign DCMGroup state to TagGroup argument
	*ipTagGroup = m_iDCMGroup;
	//assign DCMElement state to TagElement argument
	*ipTagElement = m_iDCMElement;
	//Assign DCMValue member to TagValue argument.
	cTagValue = m_cDCMValue;
}

LineEntry& LineEntry::operator = (const LineEntry &LE)
{
	if (this == &LE)
	{
		return *this;
	}
	this->m_iDCMGroup = LE.m_iDCMGroup;
	this->m_iDCMElement = LE.m_iDCMElement;
	this->m_cDCMValue = LE.m_cDCMValue;
	return *this;
}



