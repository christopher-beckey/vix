#ifndef _DECOMPRESSOR_H_
#define _DECOMPRESSOR_H_

#include "common.h"
#include "imageIO.h"
#include "aw_j2k_errors.h"

class decompressor
{
	public:
		decompressor(Params * params);
		virtual ~decompressor();

		virtual int decompress();
	private:
		virtual void cleanup();
		string getOutFilename();
		aw_j2k_object *aw;
		imageIO *io;
		string decomp_extension;
		Params *params;
		HANDLE heap;
};

void * memAlloc(void * buffer, size_t size);
void memFree(void * buffer, void * ptr);

#endif//_DECOMPRESSOR_H_