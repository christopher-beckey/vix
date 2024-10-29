#include "stdafx.h"
#include "decompressor.h"
#include "io.h"

decompressor::decompressor(Params * _params) : params(_params), aw(NULL), io(new imageIO)
{
	//Initialize the awj2k object
	debug("Entering Decompressor::Decompressor");
	debug("Entering Decompressor::Decompressor");
}

decompressor::~decompressor()
{
	//the cleanup call should take care of all of the resources allocated to the class
	debug("Entering Decompresor::~decompressor");
	cleanup();
	debug("Leaving Decomrpessor::~decompressor");
}

int decompressor::decompress()
{
	BYTE * writeBuffer = NULL;
	unsigned long bufferSize = 0;
	int result = 0;
	debug("Entering Decompressor::decompress");
	
	// leave if infile does not exists
	if (access(params->inFilename.c_str(), 0)) {
		return EIFILEOPEN;
	}
	// check, set params, based on inner extension (before ".j2k")
	params->outFilename = getOutFilename(); // tmpFilename is set here too

	// leave if final output file is already exists, but delete input file first
	if (access(params->outFilename.c_str(), 0) == 0) {
		remove(params->inFilename.c_str());
		return EOFILEEXISTS;
	}
	if      (decomp_extension == "dcm") params->outputType = DCM;
	else if (decomp_extension == "tga") params->outputType = TGA;
	else if (decomp_extension == "ppm") params->outputType = PPM;
	else if (decomp_extension == "pgx") params->outputType = PGX;
	else if (decomp_extension == "tif") params->outputType = TIF;
	else if (decomp_extension == "bmp") params->outputType = BMP;
	else params->outputType = TGA;

	//Initialize the aw object
	heap = HeapCreate(0,0,0);
	resultTest(aw_j2k_create_with_memory_manager(&aw, (void *)heap, memAlloc, memFree));

	//Let aware read the input file
//	if(params->inputType == UNKNOWN) {
		resultTest(aw_j2k_set_input_image_file(aw, (char *)params->inFilename.c_str()));
//	}
//	else
//		result = aw_j2k_set_input_image_file_type(aw, (char *)params->inFilename.c_str(), params->inputType);

	//Set the output type of the file to be written
	resultTest(aw_j2k_set_output_type(aw, params->outputType));

	//Get the raw output buffer
	resultTest(aw_j2k_get_output_image(aw, &writeBuffer, &bufferSize));

	// write temp file
	io->setWriteBuffer(writeBuffer, bufferSize);
	io->writeToFile(params->tmpFilename);

	// finally deallocate library memory
	resultTest(aw_j2k_destroy(aw));
	aw=NULL;

	HeapDestroy(heap);
	heap=NULL;

	// rename temp file to output file,
	if (rename(params->tmpFilename.c_str(), params->outFilename.c_str())) {
		// if rename failed it is because of the output was placed there by someone else
		remove(params->tmpFilename.c_str()); // make sure the temp file is deleted then
		return EOFILERENAME;
	}

	//  remove J2K file
	if (remove(params->inFilename.c_str())) {
		if (errno==EACCES)
			return EIFILEREMOVE; // access violation
	}

	debug("Leaving Decomrpessor::decompress");
	return SUCCESS;
}

void decompressor::cleanup()
{
	debug("Entering Decompressor::cleanup");
	//helper function for the deconstructor
	if (aw != NULL) aw_j2k_destroy(aw);
	io->~imageIO();
	debug("Leaving Decompressor::cleanup");
}

string decompressor::getOutFilename()
{
	string retval;
	string tmp;

	//Crimp the first extension off
	crimpFilename(params->inFilename, retval, '.');

	//Try to crimp again, if there is anything then there is a double extension and should be recorded otherwise
	//extension will be blank and then we have to figure it out for ourself
	decomp_extension = crimpFilename(retval, tmp, '.');
	
	params->tmpFilename = tmp + ".tmp";
	
	if (decomp_extension.empty())
		return retval + ".tga";	//default to TGA per request
	else {
//		decomp_extension = lower(decomp_extension); // lower macro does not work!
		for(int i = 0; i < decomp_extension.length(); ++i)
			decomp_extension[i] = char(tolower(decomp_extension[i]));
		return tmp + "." + decomp_extension;
	}
}

//These two functions are passed to the aware memory manager and will preform various memory allocation and deallocation needs
void * memAlloc(void * buffer, size_t size)
{
	HANDLE heap;
	heap = (HANDLE) buffer;
	return HeapAlloc(heap,0,size);
}

void memFree(void * buffer, void * ptr)
{
	HANDLE heap;
	heap = (HANDLE) buffer;
	HeapFree(heap,0,ptr);	
}
