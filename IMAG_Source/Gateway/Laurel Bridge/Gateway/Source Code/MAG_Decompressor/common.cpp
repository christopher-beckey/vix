#include "stdafx.h"
#include "common.h"
#include "error.h"

string crimpFilename(string inFilename, string & newFilename, char delimiter)
// chop off last extension if inFilename, return crimped filename in newFilename
// and return extension 
{
	string retval;
	newFilename = "";
	int x;
	int index = -1;

	for(x = inFilename.length() - 1; x >= 0; --x) {
		if(inFilename[x] == delimiter) {
			index = x;
			break;
		}else{
			retval.insert(0,inFilename[x]);
		}
	}
	newFilename = inFilename.substr(0,index);
	if(index == -1)
		return "";
	else
		return retval;
}

CString getStatusText(int error) {
	if (error == 0) return "SUCCESS";
	else if ((error > 0) && (error < 1000))
		return "Decompression Error";
	else if (error >= 1000) {
		switch (error) {
			case EIFILEOPEN: return "InFile Open Error";
			case EIUNKNOWNFILE: return "InFile is of Invalid Format";
			case EIFILEREAD: return "InFile Read Error";
			case EIFILESEEK: return "InFile Seek Error";
			case EIRLEENCODING: return "RLE Decoding Not Supported";
			case EIBPPNOSUPPORTED: return "Bits per Pixel count Not Supported";
			case EIFILEREMOVE: return "InFile Remove Error - Access Violation";
			case EOFILEEXISTS: return "OutFile Already Exists, InFile Removed";
			case EOFILEOPEN: return "OutFile Open Error";
			case EONOFILEDATA: return "No Data in OutFile buffer";
			case EOFILEWRITE: return "OutFile Write Error";
			case EOFILERENAME: return "OutFile Rename Error";
			default: return "File IO Error";
		}
	}
	return "Unidentified Error";
}