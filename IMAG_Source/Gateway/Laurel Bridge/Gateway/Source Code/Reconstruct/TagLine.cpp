// TagLine.cpp: implementation of the TagLine class.
//
//////////////////////////////////////////////////////////////////////

/**********
Class Name: TagLine
Base Class: LineEntry
Author: William Peterson
Copyrighted @ 2001

Purpose: 
Inherits from the LineEntry class.  Add action to determine 
	purpose of Tag Line.  Add VR and VM members to TagLine.

Members:
m_iAction: Store action requested for the TagLine.  The current
	enumerated values are I for Insert, C for Change, 
	and R for Remove.
m_cDCMVR: Store TypeCode from Change file.
m_iDCMVM: Store VM from Change file.

Changes:
wfp	10/2/2001	Class creation.
wfp 01/23/2002	First build for Development testing.
wfp 01/25/2002	Added additional comments.
wfp 02/04/2002	Corrected destructor.
wfp 06/21/2003  Added code to deconstructor to avoid memory leaks.
**********/

#include "reconstruct.h"

//////////////////////////////////////////////////////////////////////
// Construction/Destruction
//////////////////////////////////////////////////////////////////////

TagLine::TagLine()
{

}

TagLine::~TagLine()
{
	if(*this->m_cDCMVR)
	{
		free(this->m_cDCMVR);
	}
}

void TagLine::SetTagLine(int iTagAction, USHORT ipTagGroup, USHORT ipTagElement, char *cpTagVR, int ipTagVM, char *cpTagValue)
{
	//read Action argument to Action state
	this->m_iAction = iTagAction;
	//read Group argument to Group state
	this->m_iDCMGroup = ipTagGroup;
	//read Element argument to Element state
	this->m_iDCMElement = ipTagElement;
	//read VR argument to VR state
	this->m_cDCMVR = (char *)malloc(strlen(cpTagVR)+1);
	memset (this->m_cDCMVR, 0, strlen(cpTagVR)+1);
	strcpy(this->m_cDCMVR, cpTagVR);
	//read VM argument to VM state
	this->m_iDCMVM = ipTagVM;
	//read Value argument to Value state
	this->m_cDCMValue = (char *)malloc(strlen(cpTagValue)+1);
	memset (this->m_cDCMValue, 0, strlen(cpTagValue)+1);
	strcpy(this->m_cDCMValue, cpTagValue);
}


int TagLine::GetAction()
{
	//return integer value for Action.
	return (m_iAction);
}


void TagLine::GetTagLine(int *iTagAction, USHORT *ipTagGroup, USHORT *ipTagElement, char *cpTagVR, int *ipTagVM, char *cpTagValue)
{
	//assign Action state to action argument.
	*iTagAction = m_iAction;
	//assign Group state to Group argument.
	*ipTagGroup = m_iDCMGroup;
	//assign Element state to Element argument.
	*ipTagElement = m_iDCMElement;
	//assign VR state to VR argument.
	strcpy(cpTagVR, m_cDCMVR);
	//assign VM state to VM argument.
	*ipTagVM = m_iDCMVM;
	//assign value state to value argument.
	strcpy(cpTagValue, m_cDCMValue);
}



TagLine& TagLine::operator =(const TagLine &TL)
{
	if(this == &TL)
	{
		return *this;
	}
	//Copying from one TagLine Object to another TagLine Object.
	this->m_iAction = TL.m_iAction;
	this->m_iDCMGroup = TL.m_iDCMGroup;
	this->m_iDCMElement = TL.m_iDCMElement;
	strcpy(this->m_cDCMVR, TL.m_cDCMVR);
	this->m_iDCMVM = TL.m_iDCMVM;
	strcpy(this->m_cDCMValue, TL.m_cDCMValue);


	return *this;
}
