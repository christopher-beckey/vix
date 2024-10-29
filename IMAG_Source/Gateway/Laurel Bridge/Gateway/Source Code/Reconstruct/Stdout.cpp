// Stdout.cpp: implementation of the Stdout class.
//
//////////////////////////////////////////////////////////////////////

/**********
Class Name: Stdout
Base Class: n/a
Author: William Peterson
Copyrighted @ 2001

Purpose: 
Output information to the standard output.  Output either 
	exception information or usage.

Members:

Changes:
wfp	10/2/2001	Class creation.
wfp 01/23/2002	First build for Development testing.
wfp 01/25/2002	Added additional comments.
**********/

#include "reconstruct.h"

//////////////////////////////////////////////////////////////////////
// Construction/Destruction
//////////////////////////////////////////////////////////////////////

Stdout::Stdout()
{

}

Stdout::~Stdout()
{

}

void Stdout::PrintUsage()
{
	cout <<"Reconstruct Program "<<endl;
	cout <<"Solely for use with the VA Vista Imaging System."<<endl;
	//cout <<"Copyrighted 2001-2003"<<endl;	//DC stated to remove due to VA rules.
	cout <<"Designed by William Peterson,  Kinetix Medical Resources, Inc."<<endl;
	cout <<"Version "<<VERSION<<endl;
	cout <<endl;
	cout <<"MAG_recon <input file> <output file> [<change file>] [-i]"<<endl;
	cout <<endl;
	cout <<"	Where,"<<endl;
	cout <<"<input file> is the input DICOM Message file,"<<endl;
	cout <<"<output file> is the new/modified DICOM Message file,"<<endl;
	cout <<"[<change file>] is the optional Text file containing the requested changes,"<<endl;
	cout <<"-[i] will convert the output file from Explicit VR to Implicit VR format."<<endl;
}

void Stdout::PrintException(char * cpExceptionString)
{
	//Print to stdout.
	cout <<cpExceptionString<<endl;
	return;
}
