/********************************************************************************************/
/*Error.h : Contains the various error codes that are set to stderr
/*Thomas Hartman*****************************************************************************/
/********************************************************************************************/
#ifndef _ERRORS_H
#define _ERRORS_H

//Success codes
#define SUCCESS 0
#define SDKREAD -1000	//Everything is okay, but let the sdk read the file

//Command Errors	
#define EINVALIDUSAGE 1000	//The program was not called correctly
	
//Input File Handling Errors
#define EIFILEOPEN 2000	//There was a problem while opening one of the input files
#define EIUNKNOWNFILE 2001		//The file type is not known or not valid
#define EIFILEREAD 2002 //There was a problem while reading the input file
#define EIFILESEEK 2003	//There was a problem while seeking the input file
#define EIRLEENCODING 2004 //RLE decoding is currently not supported
#define EIBPPNOSUPPORTED 2005 //Bits per pixel count not currently supported

//Output File Handling Errors
#define EOFILEOPEN 3000	//There was a problem while opening the output file
#define EONOFILEDATA 3001	//There is no file data in the writeBuffer
#define EOFILEWRITE 3002		//There was a problem while attempting to write the data to the file

//Internal Errors
#define ENOMEMORY 4000	//For when there isn't enough memory....
#define EIUNREADABLE 4001 //Code has not been written yet to support that type of input file

#endif//_ERRORS_H_

