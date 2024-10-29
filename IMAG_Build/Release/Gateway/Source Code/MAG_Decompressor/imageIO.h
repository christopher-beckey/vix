#ifndef _IMAGEIO_H_
#define _IMAGEIO_H_

#include "error.h"
#include "common.h"

class imageIO
{
	public:
		imageIO();
		~imageIO();

		virtual int readToBuffer(string filename);
		virtual int setWriteBuffer(BYTE * writeBuffer, int len);
		virtual int writeToFile(string filename);
		virtual int writeToBuffer(BYTE ** newBuffer, int & len);
	private:
		BYTE * writeBuffer;
		BYTE * readBuffer;
		int rLen;
		int wLen;
};

#endif//_IMAGEIO_H_