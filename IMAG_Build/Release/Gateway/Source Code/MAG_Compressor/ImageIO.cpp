/**********************************************************************************/
/* ImageIO : Image Reader and Writer
/*					 The ImageIO class abstracts the reading and writing of the different 
/*					 image files.  If the sdk can do it then it will by all means.  However
/*					 in the event that it can't the reader or writer will take over and 
/*					 read/write it to memory and then pass it to the sdk for the nessessary
/*  				 work.
/*Thomas Hartman*******************************************************************/
/**********************************************************************************/
#include "ImageIO.h"

//ImageIO::ImageIO
//Preconditions: Object is in a uninitialized state
//Postconditions: Object has been initialize to default parameters
ImageIO::ImageIO() : readBuffer(NULL), writeBuffer(NULL), rSize(0), wSize(0), height(0), width(0), numChannels(0),
					 bpp(0), interleaved(true), rowReverse(false), gray(false), imageOffset(0), columnReverse(false), 
					 clrmap(NULL), cmapLen(0), cmapEntrySize(0), compressionType(NONE), cmapOrigin(0), xOrigin(0), yOrigin(0)
{
}

//ImageIO::~ImageIO
//Preconditions: None
//Postconditions: Any memory allocated to the object during its duration is deallocated
ImageIO::~ImageIO()
{
	if(readBuffer)
		delete [] readBuffer;
	if(writeBuffer)
		delete [] writeBuffer;
}

//ImageIO::setWriteBuffer
//Preconditions: None
//Postconditions: Method allowing the user to pass a byte buffer to the object for writing, if the writebuffer
//								already has data in it it will be deallocated and be replaced by the new data									
void ImageIO::setWriteBuffer(BYTE * _writeBuffer, int _wSize)
{
	//If there is already data there make sure it is deallocated, no sense leaking memory
	if(writeBuffer)
		delete [] writeBuffer;
	
	//Set the new size;
	wSize = _wSize;

	//Reallocate the buffer to the correct size
	writeBuffer = new BYTE[wSize];

	//Copy the data over to the new buffer
	memcpy(writeBuffer,_writeBuffer,wSize);
}

//ImageIO::writeFile
//Preconditions: None
//Postconditions: Writes whatever data is in the writeBuffer to the file specified by the function
//								Any errors either in opening or writing the data will be returned to the top level and 
//								passed to stderr
int ImageIO::writeFile(string oFilename)
{
	FILE * fp = fopen(oFilename.c_str(),"wb");
	
	//Make sure the file opened properly
	if(fp == NULL)
		return EOFILEOPEN;
	
	//Hopefully there is data in this buffer otherwise we need to report it
	if(writeBuffer == NULL)
		return EONOFILEDATA;

	//If the whole buffer is not written then the file will not come through properly
	if(fwrite(writeBuffer,1,wSize,fp) != wSize)
		return EOFILEWRITE;

	//cleanup
	fclose(fp);
	return SUCCESS;
}

//ImageIO::readFile
//Preconditions: None
//Postconditions: Determines the type of file that is pass in by name.  The type of file will determine what will happen.
//								If the file is best read by the SDK then the function will return a success code to be handled by the caller
//								otherwise the ImageIO object will read the file.  Any errors will be returned to the top level and reported
//								to stderr
int ImageIO::readFile(string iFilename)
{
	//get the type of file we will be reading
	Type type = getInputFileType(iFilename);

	if(type == UNKNOWN)
		return EIUNKNOWNFILE;

	if(type != TGA && bpp == 12)
		return SDKREAD;

	//Get the height,width, etc and then a file pointer to the begining of the image data
	resultTest(getInputFileParams(iFilename,type));

	//If we find ourselves here that means everything went off without a hitch and so the only thing left is to get the
	//RGB or Grayscale data
	return getInputFileData(iFilename);
}

//ImageIO::getInputFileType
//Preconditions:	None
//Postconditions:  The type of file passed into this function will be returned, otherwise the function will return UNKNOWN
//								 to be handled by the caller
Type ImageIO::getInputFileType(string iFilename)
{
	string extension = iFilename.substr(iFilename.length()-3,3);
	//make sure the string is all lower case so that it is easier to test
	lower(extension);
	if((extension == "tga") || ((extension == "big")))
		return TGA;	//TGA in some format
	else if(extension == "dcm")
		return DCM;	//DCM
	else if(extension == "bmp")
		return BMP;
	else if(extension == "jpg")
		return JPG;
	else
		return UNKNOWN;	//Not something that is supported
}

//ImageIO::getInputFileParams
//Preconditions:  The type of file is a valid file type and not UNKNOWN
//Postconditions:	 This function is a fancy header file reader, currently it supports TGA.  The function returns SUCCESS
//								 if it is able to read all parameters required for image compression otherwise it will return an error
//								 code which will be returned to the top level and passed to stderr
int ImageIO::getInputFileParams(string iFilename,Type type)
{
	FILE * fp = fopen(iFilename.c_str(),"rb");
	switch(type) {
		case TGA:
			BYTE tmp[TGAHEADERSIZE];
			int descriptor;

			if(fp == NULL)
				return EIFILEOPEN;
			if(fread(tmp,1,18,fp) != 18)
				return EIFILEREAD;
	
			//tmp[0] is the length of the id section of the tga which often is nothing and not worth reading
			imageOffset = 18 + tmp[0];

			//Values with the 0 and 1st bit indicate that the image is in gray scale
			if(tmp[2] & 0x03 == 3) {
				gray = true;	
				numChannels = 1;
			}else
				numChannels = 3;

			if((tmp[2] & 0x08) == 8)	//Values of 9,10,11 indicate that the image is compressed using RLE encoding
				return EIRLEENCODING;

			//Grab the color map information
			if(tmp[1]) {	//Colormaped?
				cmapOrigin = ((tmp[3]) + (tmp[4] << 8));
				cmapLen = ((tmp[5]) + (tmp[6] << 8));
				cmapEntrySize = tmp[7];
				imageOffset += cmapLen*cmapEntrySize;	//make sure to add the size of the colormap to the imageOffset
			}

			//Where x and y start as far as the image is concerned
			xOrigin = ((tmp[8]) + (tmp[9] << 8));
			yOrigin = ((tmp[10]) + (tmp[11] << 8));

			//Basic information
			width = ((tmp[12]) + (tmp[13] << 8));
			height = ((tmp[14]) + (tmp[15] << 8));
			bpp = tmp[16];

			//Figure out the reverse data if applicatble
			descriptor = tmp[17];
			if(descriptor & 0x20 == 0)
				rowReverse = true;
			if(descriptor & 0x10 == 1)	//Very uncommon
				columnReverse = true;

			//Unfortunetly Aware requires that all of its data come in in reverse Row order so thats the way its gotta be
			//rowReverse = true;
			break;		
		default:
			return EIUNREADABLE;
	}
	//cleanup
	if(fp)
		fclose(fp);
	return SUCCESS;
}

//ImageIO::getInputFileData
//Preconditions: None
//Postconditions: The actual image data of the file will be read into the readbuffer.  Any file handling or other
//								internal errors will be return to the top and sent to stderr.									
int ImageIO::getInputFileData(string iFilename)
{
	int x,y;
	FILE * fp = fopen(iFilename.c_str(),"rb");
	BYTE * bufptr;
	int sampPP = (((bpp-1)/8)+1);
	int sampWidth = sampPP*width;
	int start = (rowReverse ? imageOffset + (height*sampWidth) : imageOffset);
		
	if(fp == NULL)
		return EIFILEOPEN;
	if(fseek(fp,start,SEEK_SET) != 0)
		return EIFILESEEK;

	readBuffer = new BYTE[height*sampWidth];	//This ensures that 8 is 1, 16 and 12 are two and 24 is 3
	bufptr = readBuffer;

	for(x = 0; x < height; ++x, bufptr += sampWidth) {
		//Gotta love short circuting
		if(rowReverse && fseek(fp,-sampWidth,SEEK_CUR) != 0)
			return EIFILESEEK;
	
		//Gray scaled images are easy since they are just one channel as oppose to interlaced BGR data
		if(gray && bpp <= 8) {
			if(fread(bufptr,1,sampWidth,fp) != sampWidth)
				return EIFILEREAD;
		}else if(gray) {
			for(y = 0; y < width; ++y, bufptr += 2) {
				bufptr[0] = fgetc(fp);
				bufptr[1] = fgetc(fp);
			}
			bufptr -= sampWidth;
		}else if(clrmap != NULL){
			char ch;
			for(y = 0; y < width; ++y, bufptr += 3) {
				ch = fgetc(fp);
				bufptr[2] = clrmap[int(ch)].blue;
				bufptr[1] = clrmap[int(ch)].green;
				bufptr[0] = clrmap[int(ch)].red;
			}
			bufptr -= sampWidth;
		}else {
			switch(bpp) {
				case 24:
					//Maybe as a future development this could be sped up and have more error trapping with a bitpacked array structure
					//Like RGBStruct array[arraySize];
					//fread(array,sizeof(RGBStruct),arraySize)
					//This way the entire image could be read in at once and a simple check could be made on the amount of data read
					for(y = 0; y < width; ++y,bufptr+=3) {
						bufptr[2] = fgetc(fp);	//As usual BGR order, why? I really wish I knew...
						bufptr[1] = fgetc(fp);	
						bufptr[0] = fgetc(fp);
					}
					//...yeah this is confusing, this may or may not stay, its used to make aware happy with the data order
					//I'm pretty sure it expects everything in reverse order, i'll figure it out...
					bufptr -= sampWidth; 
					break;
				default:
					return EIBPPNOSUPPORTED;
			}
		}
			
		//More short circuting
		if(rowReverse && fseek(fp,-sampWidth,SEEK_CUR) != 0)
			return EIFILESEEK;		
	}
	fclose(fp);
	return SUCCESS;
}


//ImageIO::getInputFileColormap
//Preconditions:  There exists a color map in the image file passed to it
//Postconditions:  The colormap data is read into an array of RGB structures for use later.  Any file handling errors
//								 will be return to the top and passed along to stderr
int ImageIO::getInputFileColormap(string filename, Type type)
{
	//Do that color map thing right here
	FILE * fp = fopen(filename.c_str(),"wb");
	int cmapOffset = imageOffset - cmapLen*cmapEntrySize;
	int x;
	BYTE rgb[3];

	if(fp == NULL)
		return EIFILEOPEN;
	if(fseek(fp,cmapOffset,SEEK_SET) != 0)
		return EIFILESEEK;

	clrmap = new RGB[cmapLen];
	if(clrmap == NULL)
		return ENOMEM;

	for(x = 0; x < cmapLen; ++x){
		if(fread(rgb,1,3,fp) != 3)
			return EIFILEREAD;
		clrmap[x].red = rgb[0];
		clrmap[x].green = rgb[1];
		clrmap[x].blue = rgb[2];
	}
	
	return SUCCESS;
}

//Accessor functions: hopefully the compiler will inline these one line functions
BYTE * ImageIO::getReadBuffer() {return readBuffer;}
int ImageIO::getBPP() {return bpp;} //BPP 12 is really just 16 with 4 bits of nothing on the end
int ImageIO::getHeight() {return height;}
int ImageIO::getWidth() {return width;}
int ImageIO::getNumChannels() {return numChannels;}
bool ImageIO::getInterleaved() {return interleaved;}
bool ImageIO::isReversed() {return rowReverse;}