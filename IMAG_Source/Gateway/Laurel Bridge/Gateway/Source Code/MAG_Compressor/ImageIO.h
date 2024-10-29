/**********************************************************************************/
/* ImageIO : Image Reader and Writer
/*					 The ImageIO class abstracts the reading and writing of the different 
/*					 image files.  If the sdk can do it then it will by all means.  However
/*					 in the event that it can't the reader or writer will take over and 
/*					 read/write it to memory and then pass it to the sdk for the nessessary
/*  				 work.  The majority of the file reading abilities of this class were
/*					 rendered obsolete with Aware update to the SDK allowing for the 12 bit
/*					 TGA files to be read directly by the SDK.  This however could be reused
/*					 later if other non-standard image formats get used, or for reading dcm
/*					 text data and placing it into the proper J2K location
/*Thomas Hartman*******************************************************************/
/**********************************************************************************/

#ifndef _IMAGEIO_H_
#define _IMAGEIO_H_

#include "common.h"
#include "j2k.h"
#include "aw_j2k_errors.h"
#include "errors.h"

class ImageIO
{
	public:
		ImageIO();
		virtual ~ImageIO();

		virtual int readFile(string iFilename);
		virtual int writeFile(string oFilename);

		//Mutators
		virtual void setWriteBuffer(BYTE * writeBuffer, int size);

		//Accessor Functions
		virtual BYTE * getReadBuffer();
		virtual int getHeight();
		virtual int getWidth();
		virtual int getNumChannels();
		virtual int getBPP();
		virtual bool getInterleaved();
		virtual bool isReversed();

	protected:

		virtual Type getInputFileType(string iFilename);
		virtual int getInputFileParams(string iFilename,Type type);
		virtual int getInputFileColormap(string iFilename,Type type);
		virtual int getInputFileData(string iFilename);
		
		BYTE * readBuffer;
		BYTE * writeBuffer;
		int rSize;
		int wSize;
		int height;
		int width;
		int bpp;
		int numChannels;
		int imageOffset;
		bool interleaved;
		bool rowReverse;
		bool columnReverse;
		bool gray;
		RGB * clrmap;
		int cmapLen;
		int cmapEntrySize;
		CompressionType compressionType;
		int cmapOrigin;
		int xOrigin;
		int yOrigin;

};

#endif//_IMAGEIO_H_