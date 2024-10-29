/**********************************************************************************/
/*Compressor.h : Main Compression Utiliy
/*							 This class abstracts the use of a compression SDK into a few simple
								 method calls, all of which return values that determine whether or
								 not the method succeded or failed.  For the list of errors please
								 see errors.h.  The compression Utility relies on the imageIO
								 class for all image reading and writing needs.  This is done so that
								 the reading of different file types is abstracted.  The compressor
								 expects a pointer to an imageIO object as part of the constructor
/*Thomas Hartman*******************************************************************/
/**********************************************************************************/
#ifndef _COMPRESSOR_H_
#define _COMPRESSOR_H_

#include "ImageIO.h"
#include "common.h"
#include "errors.h"
#include "j2k.h"
#include "aw_j2k_errors.h"

class Compressor
{
	public:
		Compressor(ImageIO *_io);
		~Compressor();

		int compress(Params * _params);
		int setCompressionOptions();

	private:
		void cleanup();
		ImageIO *io;
		Params * params;
		aw_j2k_object * awCompress;
		HANDLE heap;
		BYTE * buffer;
};

void * memAlloc(void * buffer, size_t size);
void memFree(void * buffer, void * ptr);

#endif//_COMPRESSOR_H_