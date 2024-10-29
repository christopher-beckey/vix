#include "stdafx.h"
#include "imageIO.h"

imageIO::imageIO() : writeBuffer(NULL), readBuffer(NULL)
{
}

imageIO::~imageIO()
{
	if(writeBuffer)
		delete [] writeBuffer;
}

int imageIO::readToBuffer(string filename)
{
	//dummy function returns success code
	return SUCCESS;
}

int imageIO::setWriteBuffer(BYTE * _writeBuffer, int _len)
{
	int x;
	wLen = _len;
	writeBuffer = new BYTE[wLen];
	for(x = 0; x < wLen; ++x) {
		writeBuffer[x] = _writeBuffer[x];
	}

	return SUCCESS;
}

int imageIO::writeToFile(string filename)
{
	FILE * fp = fopen(filename.c_str(),"wb");
	if(fp == NULL)
		return EOFILEOPEN;

	if(fwrite(writeBuffer,1,wLen,fp) != wLen) {
		fclose(fp);
		return EOFILEWRITE;
	}

	fclose(fp);
	return SUCCESS;
}

int imageIO::writeToBuffer(BYTE ** newBuffer, int & len)
{
	//dummy function returns success code
	return SUCCESS;
}