#ifndef _COMMON_H_
#define _COMMON_H_

#include "j2k.h"

//The DEBUG macro is used to turn on and off the debuging functionality built into this project
//For releases and demo's this should be set to 0 or disabled all together.  The advantage of having 
//this macro is when commented out, the lines of code using the debug function become blank lines thus not taking
//up any compiling or execution time.  Otherwise the function will print the msg to standard out or trace.log
//depending on the debug level.  Other levels may be added for future use and future debugging.
//If there is no need for any of the levels it is advisable to comment out the macro as leaving it in compiles
//various std libraries which can be heavy at times and may affect performace and memory footprint

//#define DEBUG 1
//#define DEBUG 2
#if DEBUG == 2
#include <string>
#include <iostream>
#include <fstream>
#else
#include <string>
#include <iostream>
#endif
using namespace std;

//The debug macros are defined to aid developers by printing messages.  The level of the debug determines where
//the messages are print.  While printf would be a lighter approach to this, when debugging memory is not an issue
//and the flexiblity of cout allows the developer to be able to print more than just strings should they desire.
//For example it a class has the << open defined it is possible to use debug to print class information
//Future development may use the debug levels for other purposes but these are just the ones I use
//#define DEBUG 1

#if DEBUG == 1
#define debug(msg) cout << msg << endl;	//The standard method of debuging to the screen
#elif DEBUG == 2
//This macro prints to a log file locate in the current working directory
#define debug(msg) \
{ofstream out("debug.log",ios::app); \
 out << msg << endl; \
 out.close();}
#else
//This debug macro prints nothing and as a result of the nature of preprocessor directives will remove the macro from
//the file at compilation.  Thus when disable, the debugging lines will take up no time during compilation and execution
//allowing the developer to make many debugging calls and ultimately being able to turn them all off for fast testing
#define debug(msg)
#endif//DEBUG

//The errTest macro is used for debugging purposes.  This was written because often error traping is 
//a redundent operation, involving testing a conditional and exiting gracefully if the condition is not met.
//Once again because there is no garuntee that the compiler will inline a function the would be similar to this
//it is a macro.  Because macros are impossible to debug, if the debug macro is present errTest will become a
//function of the same parameters
#ifdef DEBUG
inline void errTest(bool condition,int exitCode) { if(!condition) fprintf(stderr,"%d\n",exitCode); }
#else
#define errTest(condition,exitCode) (!condition ? fprintf(stderr,"%d\n",exitCode) : return;)
#endif//DEBUG

//The resultTest macro is used for results integer result returned from a method or function.  If the value sent is not 0
//the macro will return the result for the function
#define resultTest(result) if(result != 0) return result;

//This enumeration is very straight forward.  By design 0 is the unknown file type.
enum Type {UNKNOWN = 0,
					 TIF = AW_J2K_FORMAT_TIF,
					 PPM = AW_J2K_FORMAT_PPM,
					 PGX = AW_J2K_FORMAT_PGX,
					 BMP = AW_J2K_FORMAT_BMP,
					 TGA = AW_J2K_FORMAT_TGA,
					 JPG = AW_J2K_FORMAT_JPG,
					 J2K = AW_J2K_FORMAT_J2K,
					 DCM = AW_J2K_FORMAT_DCM,
					 DCMJ2K = AW_J2K_FORMAT_DCM+1};

//This structure allows the decompressor to be pass parameters based from the service
struct Params
{
	string inFilename;
	string tmpFilename;
	string outFilename;
	Type outputType;
	Type inputType;
};

//This is a little helper macro that makes a string all lower case for testing purposes
#define lower(str) \
	{string retval; \
	 for(int x = 0; x < str.length(); ++x) \
		retval += char(tolower(str[x])); \
	 str = retval;}

//Not only is it easier to write BYTE but it also used when it makes more sense to have something that is a binary buffer
typedef unsigned char BYTE;

//This function is used to strip the extension off of a file type.  The return value is the extension that was stripped,
//while the newFilename is original filename without the extension
string crimpFilename(string filename, string & newFilename, char delimiter);
CString getStatusText(int error);

#endif//_COMMON_H_