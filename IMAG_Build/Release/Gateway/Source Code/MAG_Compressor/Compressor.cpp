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
#include "compressor.h"
#include "errors.h"
#include <math.h>

//Constructor
//Preconditions: The object is in a uninitialized state
//Postconditions:  The object is in a initiialized state
Compressor::Compressor(ImageIO * _io) : io(_io), params(NULL), awCompress(NULL), heap(NULL)
{
	debug("Entering Compressor::Compressor");
	debug("Entering Compressor::Compressor");
}

//Deconstructor
//Preconditions: None
//Postconditions:  All memory and file pointers initialized are deallocated or otherwise closed
Compressor::~Compressor()
{
	debug("Entering Compressor::~Compressor");
	cleanup();
	debug("Leaving Compressor::~Compressor");
}

//Compressor::compress
//Preconditions: None
//Postconditions:  Based on the Params structure, the compressor object will call upon the sdk and compress the file into
//								 the specified format and to the specified location.  All reading and writing is done transparently when
//								 by the IO function.  If there is an error at any point it will be returned to the calling function for testing.
//								 0 indicates that the method succeced in all ways.
int Compressor::compress(Params * _params)
{
	//This is where the compressed image will end up, if set to NULL, the Aware SDK will auto allocate it.
	//Because of this it must also deallocate it using aw_j2k_free()
	BYTE * writeBuffer = NULL;
	unsigned long bufferSize = 0;
	int result = 0;

	debug("Entering Compressor::compress");

	//Initialize the input parameters
	params = _params;
	//Initialize the heap member with default parameters
	heap = HeapCreate(0,0,0);

	//Create the Aware object that will do the actual compressing with the heap member
	resultTest(aw_j2k_create_with_memory_manager(&awCompress, (void *)heap, memAlloc, memFree));

//	if(params->inputType == UNKNOWN) {
		resultTest(aw_j2k_set_input_image_file(awCompress,(char *)params->inFilename.c_str()));
//	}
//	else
//		resultTest(aw_j2k_set_input_image_file_type(awCompress,(char *)params->inFilename.c_str(),params->inputType));
	
	//This function is used to set the compression parameters, it is removed to a function in the event that new
	//Parameters on the commandline get added and need to be taken care of, this way the setting of options is
	//transparent to this method.  All of the objects need for this method are part of the class
	result = setCompressionOptions();
	resultTest(result);

	resultTest(aw_j2k_get_output_image(awCompress,&writeBuffer,&bufferSize));
	
	//Give the new compressed image buffer to the writer
	io->setWriteBuffer(writeBuffer,bufferSize);

	//Write the file
	resultTest(io->writeFile(params->outFilename));
	
	//Clean up the write buffer that was initialize by the Aware SDK
	resultTest(aw_j2k_free(awCompress,writeBuffer));
	debug("Leaving Compressor::compress");
	//There were no problems while compressing
	return SUCCESS;
}

//Compressor::setCompressionOptions
//Preconditions: The params object has been initialize and customized to the desired compression results
//Postconditions: The aware object has been initialize and customized per the request of the user through the params struct
int Compressor::setCompressionOptions()
{
	debug("Entering Compressor::setCompressionOptions");
	switch(params->outputType) {
		case J2K:
			if (params->inputType == DCM) {
				resultTest(aw_j2k_set_output_type(awCompress, AW_J2K_FORMAT_DCMJ2K));	// DICOM with J2K compression
			} else {
				resultTest(aw_j2k_set_output_type(awCompress, AW_J2K_FORMAT_J2K));	// J2K compression
			}

			if(params->lossless) {
					resultTest(aw_j2k_set_output_j2k_ratio(awCompress, 0));	//Lossless compression
					resultTest(aw_j2k_set_output_j2k_xform(awCompress, AW_J2K_WV_TYPE_R53, AUTOLEVELNUM)); // Lossless compression
			} else {
					resultTest(aw_j2k_set_output_j2k_ratio(awCompress, params->compressionRate));	// Lossy compression
			}
			break;
		case JPG:
			if (params->inputType == DCM) {
				resultTest(aw_j2k_set_output_type(awCompress, AW_J2K_FORMAT_DCMJPG)); // DICOM JPEG compression
			} else {
				resultTest(aw_j2k_set_output_type(awCompress, AW_J2K_FORMAT_JPG)); // JPEG compression
			}
			long int quality;
			if(params->lossless) {
				quality = -1;	//Lossless compression
			} else {
				quality = params->compressionRate;	// Lossy compression quality 1..100 (100 best, 75 default)
			}
			resultTest(aw_j2k_set_output_jpg_options(awCompress, quality));
			break;
		case DCM:
			resultTest(aw_j2k_set_output_type(awCompress, AW_J2K_FORMAT_DCMJ2K)); // DICOM with J2K compression
			break;
	}
	debug("Leaving Compressor::setCompressionOptions");
	return SUCCESS;
}

//Compressor::cleanup
//Preconditions: None
//Postconditions: All memory allocated is freed, the function is called when the object needs to be reset.
//								This method is also used by the destructor
void Compressor::cleanup()
{
	debug("Entering Compressor::cleanup");
	//Destroy and initialize awCompress to NULL
	if(awCompress) {
		aw_j2k_destroy(awCompress);
		awCompress = NULL;
	}

	//Destroy and initialize heap to NULL
	if(heap) {
		HeapDestroy(heap);
		heap = NULL;
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
