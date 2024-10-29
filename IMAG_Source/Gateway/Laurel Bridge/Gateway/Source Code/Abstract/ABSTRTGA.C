/**********************************************************************/
/*                                                                    */
/*   abstrtga.c.c -- Read a TGA file and generate the abstract        */
/*                                                                    */
/**********************************************************************/

/*******************************************************************
********************************************************************
**  Property of the US Government.  No permission to copy or      **
**  redistribute this software is given. Use of this software     **
**  requires the user to execute a written test agreement with    **
**  the VistA Imaging Development Office of the Department of     **
**  Veterans Affairs, telephone (301) 734-0100.                   **
**                                                                **
**  The Food and Drug Administration classifies this software as  **
**  a medical device.  As such, it may not be changed in any way. **
**  Modifications of the software may result in an adulterated    **
**  medical device under 21CFR820 and may be a violation of US    **
**  Federal Statutes.                                             **
********************************************************************
*******************************************************************/

#include	<stdlib.h>
#include	<stdio.h>
#include	<string.h>
#include	<ctype.h>
#include	<time.h>
#include	"imagefmt.h"

#define	ABSTRACT_MAX_X	189	/* Maximum horizontal pixels */
#define	ABSTRACT_MAX_Y	122	/* Maximum vertical pixels */

#define	NO_ERROR	0	/* No error occurred */
#define	EOF_INPUT	-1	/* End of Input File */
#define	READ_ERROR	-2	/* Read Error detected by ferror() */
#define	EOF_OUTPUT	-3	/* End of Output File */
#define	WRITE_ERROR	-4	/* Write Error detected by ferror() */
#define WIDTH_EXCEEDED	-5	/* Maximum number of x_columns exceeded */
#define	UNKNOWN_ERROR	-999	/* Unknown Error */

#define	MAX_WIDTH	65534	/* Maximum width of a picture */
#define MAX_8BIT_LUT_SIZE	256	//wfp-Max range for 8bit LUT
#define MAX_16BIT_LUT_SIZE	65536	//wfp-Max range for 16bit LUT

int output_picture(FILE *input, FILE *output, PICINFO *pih);
int GetImgHdr(FILE *input, PICINFO *pih);
void PrImgHdr(PICINFO *pih);
void Map8BitLUT (int* pixel_histogram, unsigned char* LUT);

/* These global variables can be changed by environment variables */
int	VERBOSE=0;		/* Quiet or verbose mode */
int	MAX_X = ABSTRACT_MAX_X;	/* Maximum horizontal pixels */
int	MAX_Y = ABSTRACT_MAX_Y;	/* Maximum vertical pixels */
int	force_8bit=0;		/* Force 8bit pixels for monochrome images */
int	output_y_rows, output_x_columns;

 
void main(int argc, char *argv[])
{
	FILE	*input, *output;
	PICINFO	IHdr;
	int	i;
	int	error;
	char	*envar;
	static char *help[] = {
"abstrtga.c -- Read a TGA file and output a TGA file",
"\n\tVersion 1.2",
"abstrtga.c {input filename} {output filename} [/s:x,y] [/8]",
"",
"The /s switch allows the maximum x,y dimensions to be changed",
"The /8 switch forces all black & white (monochrome) pixels to be 8-bits",
"",
"The following environment variables can override the default settings",
"	ABSTR_VERBOSE=1		/* selects verbose mode */",
"	ABSTR_MAX_X=189		/* maximum x dimension */",
"	ABSTR_MAX_Y=122		/* maximum y dimension */"};



	if (argc < 3) {
		for (i=0; i < (sizeof(help)/sizeof(char *)) ; i++) {
			printf("%s\n",help[i]);
		}
		exit (2);
	}

	if ((input = fopen(argv[1], "rb")) == NULL) {
		fprintf(stderr,"Could not open input file %s\n",argv[1]);
		exit (1);
	}

	if ((output = fopen(argv[2], "wb")) == NULL) {
		fprintf(stderr,"Could not open output file %s\n",argv[2]);
		exit (1);
	}

	/* Get the values of the environment variables */
	envar=getenv("ABSTR_MAX_X");
	if (envar!=NULL) {
		MAX_X = atoi(envar);
	}

	envar=getenv("ABSTR_MAX_Y");
	if (envar!=NULL) {
		MAX_Y = atoi(envar);
	}

	envar=getenv("ABSTR_VERBOSE");
	if (envar!=NULL) {
		VERBOSE = atoi(envar);
	}

	/* get the values of the switches which can override environment */
	for (i=3 ; i <= (argc-1) ; i++) {
		if (argv[i][0]=='/') {
			switch (argv[i][1]) {
			case 'S':
			case 's':
				sscanf(argv[i],"/s:%d,%d", &MAX_X, &MAX_Y);
				break;
			case  '8':
				force_8bit = 1;
				break;
			default:
				printf("\nUnknown Switch: %s\n", argv[i]);
				break;
			}
		}
	}

	if (VERBOSE) {
		printf("\nMAX_X = %d,  MAX_Y = %d\n", MAX_X, MAX_Y);
	}


	GetImgHdr(input, &IHdr);

	if (VERBOSE) {
		PrImgHdr(&IHdr);
	}

	error = output_picture(input, output, &IHdr);

	if (VERBOSE) {
		printf("\n");
	}
	fflush(stdout);
	exit(0);
}

int output_picture(FILE *input, FILE *output, PICINFO *pih)
{
	static unsigned char input_buffer[MAX_WIDTH*2];
	static unsigned char output_buffer[ABSTRACT_MAX_X*ABSTRACT_MAX_Y*2];
	unsigned short *input_pixelp;
	unsigned short *output_pixelp;
	unsigned long image_origin;
	int	input_y_row;
	int output_y_row, output_x_column;
	int	pixel_depth_in_bytes;
	unsigned int number_input_bytes, number_output_bytes;
	unsigned int number_read, number_wrote;
	unsigned right_shift = 0;
	float	scale, xscale, yscale;
	unsigned char tga_header[PICHDSIZE];

	//wfp-Initialize new local variables.
	int	output_pixel_depth_in_bytes;
    unsigned short output_pixel_depth;
	unsigned int total_output_bytes;
	unsigned char *ch_inp;
	unsigned char *outp;
	int i;
	int histogram[MAX_16BIT_LUT_SIZE] = {{0}};
	unsigned char PixelLUT[MAX_16BIT_LUT_SIZE] = {{0}};
	unsigned short *sh_inp;	


	clock_t	start, finish;

	start = clock();

	memset(tga_header, 0 , PICHDSIZE);

	if (pih->ImageInfo.dx > MAX_WIDTH) return (WIDTH_EXCEEDED);

	/* Calculate sampling */
	xscale=(float) pih->ImageInfo.dx/MAX_X;
	yscale=(float) pih->ImageInfo.dy/MAX_Y;

	scale = xscale > yscale ? xscale : yscale; // use maximum scale

	if (VERBOSE) {
		printf("\nusing scale=%f,  (xscale=%f,  yscale=%f)\n",
			scale,xscale,yscale);
	}

	output_y_rows = (int) (pih->ImageInfo.dy / scale);
	output_x_columns = (int) (pih->ImageInfo.dx / scale);

	if (VERBOSE) {
		printf("\noutput_y_rows=%d,   output_x_columns=%d\n",
			output_y_rows, output_x_columns);
	}

	tga_header[ 2] = pih->imageType;		// imageType
	tga_header[12] = (unsigned char) (0xff & output_x_columns); // image width (x)
	tga_header[13] = (unsigned char) (0xff & (output_x_columns >> 8)); // image width (x)
	tga_header[14] = (unsigned char) (0xff & output_y_rows); // image heigth (y)
	tga_header[15] = (unsigned char) (0xff & (output_y_rows >> 8)); // image heigth (y)
	tga_header[16] = pih->ImageInfo.depth;		// pixel depth
	tga_header[17] = pih->ImageInfo.attrib;		// attributes

	pixel_depth_in_bytes = pih->ImageInfo.depth > 8 ? 2 : 1;
	number_input_bytes = pixel_depth_in_bytes * pih->ImageInfo.dx;
	number_output_bytes = pixel_depth_in_bytes * output_x_columns;

	/* for b/w images, force the abstract to have 8-bit pixels */
	if ((pih->imageType==3) && (pixel_depth_in_bytes==2) && force_8bit) {
		right_shift = pih->ImageInfo.depth-8;
		tga_header[16] = 8;		// pixel depth
		number_output_bytes = output_x_columns;
		output_pixel_depth = 8;
		output_pixel_depth_in_bytes = 1;
	}
	else{
		output_pixel_depth = pih->ImageInfo.depth;
		output_pixel_depth_in_bytes = pixel_depth_in_bytes;
	}
	//wfp-calculate total output bytes necessary to output to file
	//	in a single transfer.
	total_output_bytes = output_y_rows*output_x_columns*output_pixel_depth_in_bytes;

	fwrite(tga_header,1, PICHDSIZE, output);

	if (VERBOSE) {
		printf("\nReading %d bytes per row, writing %d bytes per row\n",
			number_input_bytes, number_output_bytes);
	}

	image_origin=ftell(input); // picture origin

	/* advance image origin over color map, if it is present */
	if (pih->MapInfo.length) {
		image_origin += pih->MapInfo.length
			* (pih->MapInfo.width >> 3);
		if (VERBOSE) {
			printf("Image origin w/ Color Map = %lu\n",
				image_origin);
		}
	}

	//wfp-Had to move this out of the nested FOR loops below.  This is because I am now
	//	reading the entire input buffer before writing out to the new file.
	if(pixel_depth_in_bytes >1){
		output_pixelp = (unsigned short *) output_buffer;
	}
	else{
		(unsigned char *)output_pixelp = (unsigned char *) output_buffer;
	}

    
	if (VERBOSE) {
		printf("row: %4d->%-4d",0,0);
	}
	for (output_y_row=1; output_y_row <= output_y_rows ; output_y_row++) {
		input_y_row = (int) (scale * output_y_row);
        //wfp-had to add IF when input_y_row is less than 1.  If so, 
        //set input_y_row to 1. Determined his code needs this to avoid a 
        //problem with positioning the fseek command. It was not skipping 
        //the header info if input_y_row was 0.
        if (input_y_row < 1)
        {
            input_y_row = 1;
        }

		if (VERBOSE) {
			printf("\b\b\b\b\b\b\b\b\b\b%4d->%-4d",
				input_y_row,output_y_row);
		}
		fseek(input,image_origin+((long)(input_y_row-1)*number_input_bytes), SEEK_SET);
		number_read = fread(input_buffer, 1, number_input_bytes, input);

		if (number_read != number_input_bytes) {
			if (feof(input)) {
				fprintf(stderr,"\nInput EOF reached\n");
				return (EOF_INPUT); // end of file
			}
			if (ferror(input)) {
				fprintf(stderr,"\nRead error\n");
				return (READ_ERROR); // read error
			}		
			return (UNKNOWN_ERROR);
		}

		/* copy every nth pixel to the output buffer */
		if (pixel_depth_in_bytes > 1) { // assume 16 bit pixels
			input_pixelp = (unsigned short *) input_buffer;
			for (output_x_column=0;output_x_column<output_x_columns;
				output_x_column++) {
				if (force_8bit) {					
					*(unsigned short *) output_pixelp = 
						(unsigned short) input_pixelp[(short)
						(output_x_column * scale)];
					
					//wfp-count pixel value to histogram and then increment 
					//	output_pixelp pointer.
					histogram[*(unsigned short *)output_pixelp]++;

					((unsigned short *)output_pixelp)++;
				}
				else {
					*output_pixelp = input_pixelp[(short)
						(output_x_column * scale)];

					//wfp-count pixel value to histogram and then increment 
					//	output_pixelp pointer.
					histogram[*output_pixelp]++;

					*output_pixelp++;
				}
			}
		}
		else { // 8-bit pixels
			(unsigned char *)input_pixelp = (unsigned char *) input_buffer;
			for (output_x_column=0;output_x_column<output_x_columns;
				output_x_column++) {
				*(unsigned char *) output_pixelp = (unsigned char) (0xff &
					input_buffer[(short) (output_x_column * scale)]);

				//wfp-count pixel value to histogram and then increment 
				//	output_pixelp pointer.
				histogram[*(unsigned char *)output_pixelp]++;

				((unsigned char *)output_pixelp)++;
			}
		}
	}

	//wfp-determine largest pixel value and create mapping only if
	//greyscale image and bitdepth is greater than 8 bits.
	if((pih->imageType == 3) && (output_pixel_depth_in_bytes == 1))
	{
		if(pixel_depth_in_bytes > 1){
			//wfp-generate mapping array to 256 scale.
			Map8BitLUT (histogram, PixelLUT);
			sh_inp = (unsigned short *)output_buffer;
			outp = (unsigned char *)output_buffer;
			for(i=0; i<(int)total_output_bytes ; i++){
				*outp++ = PixelLUT[sh_inp[i]];
			}
		}
		else{
			//wfp-generate mapping array to 256 scale.
			Map8BitLUT (histogram, PixelLUT);
			ch_inp = (unsigned char *)output_buffer;
			outp = (unsigned char *)output_buffer;
			for(i=0; i<(int)total_output_bytes ; i++){
				*outp++ = PixelLUT[ch_inp[i]];
			}
		}
	}

	//wfp-This is existing code that was moved outside of the nested FOR loops.
	number_wrote = fwrite(output_buffer, 1, total_output_bytes, output);
	if (number_wrote != total_output_bytes) {
		if (feof(output)) {
			fprintf(stderr,"\nOutput EOF reached\n");
			return (EOF_OUTPUT);
		}
		if (ferror(input)) {
			fprintf(stderr,"\nWrite error\n");
			return (WRITE_ERROR); // read error
		}		
		return (UNKNOWN_ERROR);
	}

	finish = clock();
	if (VERBOSE) {
		printf("\nProgram takes %.2f seconds.\n",
			(float) (finish-start)/CLK_TCK);
	}
	return (0);
}

int
GetImgHdr(FILE *input, PICINFO *pih )
{
	unsigned char	TempStorage[PICHDSIZE];

	if (fread(TempStorage, 1, PICHDSIZE, input) == -1) return(-1);

	pih->idLength = (unsigned char)(0xff & (int)TempStorage[0]);
	pih->mapType = (unsigned char)(0xff & (int)TempStorage[1]);
	pih->imageType = (unsigned char)(0xff & (int)TempStorage[2]);
	pih->MapInfo.origin = ((0xff & (int)TempStorage[4]) << 8) |
			(0xff & (int)TempStorage[3]);
	pih->MapInfo.length = ((0xff & (int)TempStorage[6]) << 8) |
			(0xff & (int)TempStorage[5]);
	pih->MapInfo.width = (unsigned char)(0xff & (int)TempStorage[7]);
	pih->ImageInfo.x = ((0xff & (int)TempStorage[9]) << 8) |
			(0xff & (int)TempStorage[8]);
	pih->ImageInfo.y = ((0xff & (int)TempStorage[11]) << 8) |
			(0xff & (int)TempStorage[10]);
	pih->ImageInfo.dx = ((0xff & (int)TempStorage[13]) << 8) |
			(0xff & (int)TempStorage[12]);
	pih->ImageInfo.dy = ((0xff & (int)TempStorage[15]) << 8) |
			(0xff & (int)TempStorage[14]);
	pih->ImageInfo.depth = (unsigned char)(0xff & (int)TempStorage[16]);
	pih->ImageInfo.attrib = (unsigned char)(0xff & (int)TempStorage[17]);
	return (0);
}

void
PrImgHdr( pih )
PICINFO	*pih;
{
	printf("ID Field Length = %d\n", pih->idLength );
	printf("Color Map Type = %d\n", pih->mapType );
	printf("Image Type Code = %d\n", pih->imageType );
	printf("Color Map Origin = %d\n", pih->MapInfo.origin );
	printf("Color Map Length = %d\n", pih->MapInfo.length );
	printf("Color Map Width = %d\n", pih->MapInfo.width );
	printf("Image Origin = %d,%d\n", pih->ImageInfo.x, pih->ImageInfo.y );
	printf("Image Size = %d,%d\n", pih->ImageInfo.dx, pih->ImageInfo.dy );
	printf("Image Depth = %d\n", pih->ImageInfo.depth );
	printf("Image Attributes = 0x%x\n", pih->ImageInfo.attrib );
}

void Map8BitLUT (int* pixel_histogram, unsigned char* LUT)
{
	//wfp-Initialize local variables
    int i, k;
    int palettevalue = 0;
    float rangeoffset = 0.0;
	int max_realistic_pixel_value = MAX_16BIT_LUT_SIZE-1;
	int min_realistic_pixel_value = 0;
	int min_realistic_set = 0;
	int pixel_quantity = 0;
	int max_used_pixel_value = MAX_16BIT_LUT_SIZE;
	int max_value_not_found = 1;


	pixel_quantity = (int)(output_x_columns * output_y_rows * 0.0005);

	//wfp-We already know minimum possible value is 0 (zero).  We need to find the
	//	maximum used pixel value.  This will tell us the ceiling.  I cannot use the 
	//	pixel depth given in the targa header because it could be misleading about
	//	the real pixel data in the image.
	while(max_value_not_found){
		max_used_pixel_value--;
		if(pixel_histogram[max_used_pixel_value] > 0){
			max_value_not_found = 0;
		}
	}

	//wfp-Find maximum and minimum realistic pixel values. These variables determine the pixel
	//	range of the downsampled image sitting in the output_buffer.
	//	0 and max_used_pixel_value represents the values at the extreme end that contains
	//	at least 1 pixel with that value.  Realistic pixel value represents the value
	//	at the extreme ends that contain more than PIXEL_QUANTITY pixels with that value.
	for(k=1; k<max_used_pixel_value; k++){
		if(pixel_histogram[k] > pixel_quantity){
			max_realistic_pixel_value = k;
			if(!min_realistic_set){
				min_realistic_pixel_value = k;
				min_realistic_set = 1;
			}
		}
	}

    //wfp-determine range offset.  This spreads the image pixel range along the length
	//	of an 8bit window (256).
    rangeoffset = (float)(MAX_8BIT_LUT_SIZE) / (float)(max_realistic_pixel_value-min_realistic_pixel_value);

	if(VERBOSE){
		printf("Min realistic Pixel Value: %d\n", min_realistic_pixel_value);
		printf("Max realistic Pixel Value: %d\n", max_realistic_pixel_value);
		printf("Range Offset Value: %f\n", rangeoffset);
		printf("Quantity of Min realistic Pixel Value: %d\n", pixel_histogram[min_realistic_pixel_value]);
		printf("Quantity of Max realistic Pixel Value: %d\n", pixel_histogram[max_realistic_pixel_value]);
	}

    //wfp-loop thru and calculate adjusted pixel values and insert into Lookup Table.
	for (i=0; i<MAX_16BIT_LUT_SIZE; i++)
    {
		palettevalue = (int)((i - min_realistic_pixel_value) * rangeoffset);

        if (palettevalue < 0)
        {
            palettevalue = 0;
        }
        if (palettevalue > (MAX_8BIT_LUT_SIZE-1))
        {
            palettevalue = MAX_8BIT_LUT_SIZE-1;
        }
        LUT[i] = palettevalue;
    }
}

