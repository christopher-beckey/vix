#ifndef _ERRORS_H_
#define _ERRORS_H_

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
#define EIFILEREMOVE 2006 // input file remove error

//Output File Handling Errors
#define EOFILEEXISTS 3000	//There was a problem while opening the output file
#define EOFILEOPEN 3001	//There was a problem while opening the output file
#define EONOFILEDATA 3002	//There is no file data in the writeBuffer
#define EOFILEWRITE 3003		//There was a problem while attempting to write the data to the file
#define EOFILERENAME 3004		//There was a problem while attempting to write the data to the file

//Internal Errors
#define ENOMEMORY 4000	//For when there isn't enough memory....
#define EUNREADABLE 4001 //Code has not been written yet to support that type of input file
#define EUNKNOWNTYPE 4002
#define NOTDONE 9999

#endif//_ERRORS_H_