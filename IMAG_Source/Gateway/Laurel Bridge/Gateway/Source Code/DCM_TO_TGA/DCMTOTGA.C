/**********************************************************************/
/*                                                                    */
/*   dcmtotga.c -- Read DICOM formatted file and display the image    */
/*                                                                    */
/**********************************************************************/

/*******************************************************************
********************************************************************
** Property of the US Government.                                 **
** No permission to copy or redistribute this software is given.  **
** Use of unreleased versions of this software requires the user  **
** to execute a written test agreement with the VistA Imaging     **
** Development Office of the Department of Veterans Affairs,      **
** telephone (301) 734-0100.                                      **
**                                                                **
** The Food and Drug Administration classifies this software as   **
** a Class II medical device.  As such, it may not be changed     **
** in any way.  Modifications to this software may result in an   **
** adulterated medical device under 21CFR820, the use of which    **
** is considered to be a violation of US Federal Statutes.        **
********************************************************************
*******************************************************************/

#include	<stdio.h>
#include	<ctype.h>
#include	<time.h>
#include	<conio.h>
#include	<math.h>
#include	<string.h>
#include	<memory.h>

#define	NO_ERROR	0	/* No error occurred */
#define	EOF_INPUT	-1	/* End of Input File */
#define	READ_ERROR	-2	/* Read Error detected by ferror() */
#define	EOF_OUTPUT	-3	/* End of Output File */
#define	WRITE_ERROR	-4	/* Write Error detected by ferror() */
#define WIDTH_EXCEEDED	-5	/* Maximum number of columns exceeded */
#define	UNKNOWN_ERROR	-999	/* Unknown Error */

#define PICHDSIZE	18	/* TGA picture header size */
#define	MAX_WIDTH	65535	/* Maximum width of a picture */
#define	MAX_HISTOGRAM_PIXEL_VALUE	32760	/* ~ Maximum value of a 15-bit pixel */
#define MAX_ARRAY	65535	/* Maximum Array Size for DOS - 1 */

#define MINIMUM_VALUE	-32768	/* Minimum value for a 16-bit integer */
#define MAXIMUM_VALUE	32767	/* Maximum value for a 16-bit integer */

#define MS_NT	1

#ifdef MS_NT
#define OS	"NT (Intel)"
#else	
#define OS	"DOS"
#endif

extern int exit(int);
extern int atoi(char *);
extern long atol(char *);
extern char * getenv(char *);

static void usage(void);
void arg_error(char * argument_name, int * error_count);
int output_picture(FILE *input, FILE *output);


/* These global variables can be changed by environment variables */
int	VERBOSE=0;		/* Quiet or verbose mode */
int	RANGE=512;		/* Range for LUTs in 16-bit mode */

/* These global variables can be changed by the optional arguments */
int	input_bits_per_pixel = 0;
int	output_bits_per_pixel = 0;
int	pixel_addition = 0;
long pixel_subtraction = 0;	/* note that this is a long, not a short */
long image_offset = 0;
int	minimum_value = MINIMUM_VALUE;
int	maximum_value = MAXIMUM_VALUE;
int	invert_pixel = 0;
int	maximum_pixel_value;	/* maximum value of an n-bit unsigned pixel */
int	input_columns = 0;		/* input x-dimension */
int	input_rows = 0;			/* input y-dimension */
int	output_columns = 0;		/* output x-dimension */
int	output_rows = 0;		/* output y-dimension */
int	dimension_reduction = 0;	/* factor of 2 dimension reduction */
int	pixel_bit_reduction = 0;	/* 16-bit to 8 bit pixel reduction */


void main(int argc, char *argv[])
{
	FILE	*input, *output;
	int	i;
	int	error = 0;
	char	*envar;


	if (argc < 3) {
		usage();
	}

	if ((input = fopen(argv[1], "rb")) == NULL) {
		fprintf(stderr,"Could not open input file %s\n",argv[1]);
		exit (1);
	}

	if ((output = fopen(argv[2], "wb")) == NULL) {
		fprintf(stderr,"Could not open output file %s\n",argv[2]);
		exit (1);
	}

	/* get additional arguments */

	for (i=3; i<argc; i++) {
		switch (argv[i][0] | 0x20) {	// force to lower case

		case 'a':
			pixel_addition = atoi(&argv[i][1]);
			break;

		case 'b':
			input_bits_per_pixel = atoi(&argv[i][1]);
			break;

		case 'c':
			maximum_value = atoi(&argv[i][1]);
			break;

		case 'f':
		        minimum_value = atoi(&argv[i][1]);
			break;

		case 'i':
				invert_pixel = 1;
			break;

		case 'o':
		        image_offset = atol(&argv[i][1]);
			break;
 
		case 'r':
			if (atoi(&argv[i][1]) == 1 ) {
				pixel_bit_reduction = 1;
			}
			else if (atoi(&argv[i][1]) == 2) {
				pixel_bit_reduction = 2;
			}
			else if (atoi(&argv[i][1]) == 4) {
				dimension_reduction = 2;
			}
			else if (atoi(&argv[i][1]) == 8) {
				pixel_bit_reduction = 2;
				dimension_reduction = 2;
			}
			//wfp 113004-Add the following lines to increase reduction factors.  
			//	Also added variable to carry multiple reduction factor values.
			else if (atoi(&argv[i][1]) == 16) {
				dimension_reduction = 4;
			}
			else if (atoi(&argv[i][1]) == 32) {
				pixel_bit_reduction = 2;
				dimension_reduction = 4;
			}
			else {
				printf("\nIllegal value for size reduction: %d",
					atoi(&argv[i][1]));
				printf(" -- the legal values area 1, 2, 4, 8, 16, & 32");
				exit(2);				
			}
			break;

		case 's':
			pixel_subtraction = atol(&argv[i][1]);
			if (pixel_subtraction<0) {
				pixel_subtraction = - pixel_subtraction;
			}
			break;

		case 'x':
		        input_columns = atoi(&argv[i][1]);
			break;

		case 'y':
		        input_rows = atoi(&argv[i][1]);
			break;

		default:
			printf("\nUnknown optional parameter \"%s\" ignored\n",
				argv[i]);
		}
	}

	/* Get the values of the environment variables */

	envar=getenv("DCMTOTGA_VERBOSE");
	if (envar!=NULL) {
		VERBOSE = atoi(envar);
	}

	/* Check that the options are not entered for 8-bit images */
	if (input_bits_per_pixel <= 8 ) {
		
		if (dimension_reduction) {
			printf("*** Warning: Dimension reduction is not supported for 8-bit images ***\n");
			dimension_reduction = 0;
		}
		if (pixel_bit_reduction) {
			printf("*** Warning: Pixel bit reduction is not supported for 8-bit images ***\n");
			pixel_bit_reduction = 0;
		}
		
	}
	
	if (dimension_reduction) {
		//wfp 113004-Comment out the following line and change the equation to deal with additional
		//	reduction factors 
		//output_columns = input_columns / 2;
		output_columns = input_columns / dimension_reduction;

		//output_rows = input_rows / 2;
		output_rows = input_rows / dimension_reduction;
		
		//wfp 120204-the following IF statement makes no sense.  Removing.
		//if (input_columns % 2) {
		//	if (VERBOSE) {
		//		printf("\nOdd number of columns: %d\n",input_columns);
		//	}
		//}
	}
	else {
		output_columns = input_columns;
		output_rows = input_rows;
	}

	if (pixel_bit_reduction) {
		output_bits_per_pixel = 8;
	}
	else {
		output_bits_per_pixel = input_bits_per_pixel;
	}
	
	//wfp 120204-Moved the following If statement down to this location.  This makes sure 
	//	output_columns are always even.  It was working before only when dimension_reduction was set.
	if (output_columns % 2){
		output_columns -= 1;
	}


	maximum_pixel_value = (1 << input_bits_per_pixel) - 1;

	if (VERBOSE>1) {
		printf("\nInput Values\n------------\n");
		printf("X-dimension: %d", input_columns);
		printf(",  Y-dimension: %d", input_rows);
		printf(",  Bits/Pixel: %d", input_bits_per_pixel);
		printf(",  Image Offset: %ld\n", image_offset);
		printf("Pixel Addition: %d", pixel_addition);
		printf(",  Pixel Subtraction: %ld\n", pixel_subtraction);
		printf("Minimum value: %d", minimum_value);
		printf(",  Maximum value: %d",maximum_value);
		printf("\nDimension Reduction: ", dimension_reduction);
		if (dimension_reduction) printf("YES"); else printf("no");
		printf("\nPixel Reduction: ", pixel_bit_reduction);
		if (pixel_bit_reduction) printf("YES"); else printf("no");
		if (invert_pixel) {
			printf("\nInvert each pixel by subtracting it from: %d",
				maximum_pixel_value);
		}
		else {
			printf("\nPixel inversion not requested");
		}
		printf("\n\nOutput Values\n-------------\n");
		printf("X-dimension: %d", output_columns);
		printf(",  Y-dimension: %d", output_rows);
		printf(",  Bits/Pixel: %d", output_bits_per_pixel);
	}

	if (input_columns == 0) arg_error("X-dimension", &error);
	if (input_rows == 0) arg_error("Y-dimension", &error);
	if (input_bits_per_pixel == 0) arg_error("Bits/Pixel", &error);
	if (image_offset == 0) arg_error("Image Offset", &error);

	if (error) {
		printf("\nProgram terminated due to %d missing argument(s)\n",
			error);
		exit (3);
	}

	error = output_picture(input, output);
	if (error) {
		printf("\nProgram terminated due to error #%d\n",
			error);
		exit (4);
	}	

	if (VERBOSE) {
		printf("\n");
		fflush(stdout);
	}
 
	exit (0);
}

void arg_error(char * argument_name, int * error_count)
{
	printf("\n*** %s is required to be set on command line ***\n",
		argument_name);
	(*error_count)++;
}

int output_picture(FILE *input, FILE *output)
{
	static unsigned char input_row_buffer[MAX_ARRAY];
	static unsigned char output_row_buffer[MAX_ARRAY];
	static long density_histogram[2 * (MAX_HISTOGRAM_PIXEL_VALUE+1)];
	short * input_row_buffer_shortp;
	short * output_row_buffer_shortp;
	short * input_row_buffer_shortp1, * input_row_buffer_shortp2;
	short * input_row_buffer_shortp3, * input_row_buffer_shortp4;
	char * input_row_buffer_charp;
	char * output_row_buffer_charp;
	int	pixel_value;
	int min_pixel_value = MAXIMUM_VALUE;
	int max_pixel_value = MINIMUM_VALUE;
	int	pixel_shift, pixel_round;
	int	pixel_sum, max_pixel_sum;
	int	row, column, input_columns_left;
	int bytes_per_pixel;
	int	i, j, k, l, h, q, r, extra;
	int	input_bytes_per_row, rows_per_transfer;
	int	input_elements_per_row;
	unsigned int number_input_bytes, number_read;
	unsigned int number_output_bytes, number_wrote;
	unsigned char tga_header[PICHDSIZE];

	clock_t	start, finish;

	start = clock();

	memset(tga_header, 0, PICHDSIZE);
	memset(density_histogram, 0, sizeof(density_histogram));

	if (input_columns > MAX_WIDTH) return (WIDTH_EXCEEDED);

	tga_header[ 2]=3;					// type = b/w
	tga_header[12]=(unsigned char)(0xff&output_columns);	// width (x)
	tga_header[13]=(unsigned char)(0xff&output_columns>>8); // width (x)
	tga_header[14]=(unsigned char)(0xff&output_rows);	// heigth (y)
	tga_header[15]=(unsigned char)(0xff&output_rows>>8);	// heigth (y)
	tga_header[16]=(unsigned char) output_bits_per_pixel;	// # pixels
	tga_header[17]=0x20;					// orgin at top

	fwrite(tga_header,1, PICHDSIZE, output);

	/* Compute the i/o blocking factor (i.e., # rows per transfer) */
	if (input_bits_per_pixel <=8) bytes_per_pixel = 1;
	else bytes_per_pixel = 2;
	
	input_bytes_per_row = bytes_per_pixel * input_columns;

	/* Determine variables for image reduction */
	if (dimension_reduction && pixel_bit_reduction) {
		//wfp 113004-Change equation to reflect multiple reduction factors
		pixel_shift = (input_bits_per_pixel - 8) + (dimension_reduction);
		pixel_round = 1 << (pixel_shift - 1);
	}
	else if (dimension_reduction) {
		//wfp 113004- Change equation to reflect multiple reduction factors.
		//pixel_shift = 2;	// 4:1 reduction in size
		//pixel_round = 2;
		pixel_shift = dimension_reduction;
		pixel_round = dimension_reduction;
		//
	}
	else if (pixel_bit_reduction) {
		pixel_shift = input_bits_per_pixel - 8;
		pixel_round = 1 << (pixel_shift - 1);
	}
	else {
		pixel_shift = 0;
		pixel_round = 0;
	}

	//wfp 113004-Change equation to reflect pixels greater than 8bits.
	///* compute the maximum sum of four bits before shifting */
	//compute the maximum sum of set bit depth multiplied by pixel shift.
	max_pixel_sum = (maximum_pixel_value << pixel_shift);

	rows_per_transfer = (int) (MAX_ARRAY/input_bytes_per_row);

	/* Limit the number of rows_per_transfer for small images */
	if (rows_per_transfer > input_rows) { 
		rows_per_transfer = input_rows;
	}
	
	//wfp 113004-Change equation to reflect multiple reduction factors and create 
	//	an integer number of rows_per_transfer.
	if(dimension_reduction)
	{
		while (rows_per_transfer % dimension_reduction){
			rows_per_transfer--;
		}
	}
	else
	{
		//this equation is still here for when dimension_reduction is 0.
		//	this is the case when only the pixel_bit_reduction is set or not set.
		if (rows_per_transfer % 2){
			rows_per_transfer--;
		}
	}

	if (VERBOSE) {
		printf("\nPixel Shift: %d,  Pixel Round: %d",
			pixel_shift,pixel_round);
		printf("\n\nRows: %d,  Columns: %d,",input_rows,input_columns);
		printf("  Number bytes/row: %d,  Rows/transfer: %d",
			input_bytes_per_row, rows_per_transfer);
	}
	if (VERBOSE>1) {
		printf("\nrow: ");
	}


	/* Transfer the data multiple rows at a time */
	fseek(input, image_offset, SEEK_SET);
	row = 1;
	for (;;) {

		if (VERBOSE>1) {
			printf("%5d",row);
		}
		// the following line must stay inside the loop.  rows_per_transfer can change at the 
		//	end of reading the input file.
		number_input_bytes = rows_per_transfer * input_bytes_per_row;
		number_read = fread(input_row_buffer, 1, number_input_bytes, input);

		if (number_read != number_input_bytes) {
			if (feof(input)) {
				fprintf(stderr,"\nEOF reached reading image\n");
				return (EOF_INPUT); // end of file
			}
			if (ferror(input)) {
				fprintf(stderr,"\nRead error\n");
				return (READ_ERROR); // read error
			}		
			return (UNKNOWN_ERROR);
		}


		/* perform arithmetic operations on each pixel */
		
		input_row_buffer_charp = (char *) input_row_buffer;
		input_row_buffer_shortp = (short *) input_row_buffer;
		
		

		for (k = 0;
                     k < (int) number_input_bytes;
                     k += (int) bytes_per_pixel) {
		
			switch (bytes_per_pixel) {
			case 1:	pixel_value = (unsigned char) *input_row_buffer_charp;	break;
			case 2:
				if (pixel_subtraction) {
					pixel_value = ((unsigned short) *input_row_buffer_shortp)
									- pixel_subtraction;
				}
				else {
					pixel_value = *input_row_buffer_shortp;
				}
				break;
			}
			
			/* Add the offset to shift a 2's complement to an unsigned */
			pixel_value = pixel_value + pixel_addition;

			/* Invert the pixel value by subtracting it from a maximum value */
		
			if (invert_pixel) {
				//pixel_value = (maximum_pixel_value - 1) - pixel_value;
				pixel_value = (maximum_pixel_value) - pixel_value;
			}

			/* Clamp the pixel value to a minimum floor level */
			if (pixel_value < minimum_value) {
				pixel_value = minimum_value;
			}

			/* Clip the pixel value to a maximum ceiling value */
			if (pixel_value > maximum_value) {
				pixel_value = maximum_value;
			}

			// printf("k=%d, pixel_value=%d, input_row_buffer_shortp=%x\n",k, pixel_value, input_row_buffer_shortp);

			switch (bytes_per_pixel) {
			case 1: *(input_row_buffer_charp++) = pixel_value;	break;
			case 2:	*(input_row_buffer_shortp++) = pixel_value;	break;
			}	
			
			if (VERBOSE>2) {
				if (pixel_value < -MAX_HISTOGRAM_PIXEL_VALUE) {
					printf("\nPixel Value negative: %d",
						pixel_value);
					pixel_value = -MAX_HISTOGRAM_PIXEL_VALUE;
				}
				if (pixel_value > MAX_HISTOGRAM_PIXEL_VALUE) {
					printf("\nPixel Value too large: %d",
						pixel_value);
					pixel_value = MAX_HISTOGRAM_PIXEL_VALUE;
				}
				density_histogram[pixel_value + MAX_HISTOGRAM_PIXEL_VALUE]++;
				
				/* find the minimum and maximum pixel values */
				if (pixel_value > max_pixel_value) max_pixel_value = pixel_value;
				if (pixel_value < min_pixel_value) min_pixel_value = pixel_value;
			}
		}

		
		/* Output the rows to the file */
	
		if ((dimension_reduction == 2) && pixel_bit_reduction) {
			/* average four input pixels to each output */
			/* reduce number of bits per pixel to eight */
			//input_elements_per_row = input_bytes_per_row
			//		/ sizeof(short);
			/* keep the number of bits per pixel the same */
			input_elements_per_row = input_bytes_per_row
					/ sizeof(short);
			input_row_buffer_shortp1 = (short *) input_row_buffer;
			input_row_buffer_shortp2 = (short *) (input_row_buffer+input_bytes_per_row);
			output_row_buffer_charp =  output_row_buffer;
			number_output_bytes = output_columns * rows_per_transfer / 2;
			pixel_sum = 0;
			

			for (k = number_output_bytes; k > 0; ) {
				for (column = 0 ;column < output_columns; column++, k-=1) {
					for (h = 0; h < dimension_reduction; h++){
						pixel_sum += (input_row_buffer_shortp1[column*2+h] +
							input_row_buffer_shortp2[column*2+h]);
					}
					if (pixel_sum > max_pixel_sum) {
						pixel_sum = max_pixel_sum;
					}
					//pixel_shift variable is here to determine the average of 4 values
					//	then shift high bit to 8 bits.
					*(output_row_buffer_charp++)
						= (unsigned char) ((
						pixel_sum) >> pixel_shift);
						//pixel_sum) >> 4);
					pixel_sum = 0;
				}
				input_row_buffer_shortp1 = (short *) ((unsigned char*)input_row_buffer_shortp1+ input_bytes_per_row*2);
				input_row_buffer_shortp2 = (short *) ((unsigned char*)input_row_buffer_shortp2+ input_bytes_per_row*2);
			}
			output_row_buffer_shortp = (short *) output_row_buffer;
		}
		
		//wfp 113004-Added 'else if' statement for 32:1 reduction.  Could not determine way to
		//	consolidate with current code.  Understand there is redundancy in this code section.
		else if ((dimension_reduction == 4) && pixel_bit_reduction) {
			/* average sixteen input pixels to each output */
			/* reduce number of bits per pixel to eight */
			input_elements_per_row = input_bytes_per_row
					/ sizeof(short);
			input_row_buffer_shortp1 = (short *) input_row_buffer;
			input_row_buffer_shortp2 = (short *) (input_row_buffer+input_bytes_per_row);
			input_row_buffer_shortp3 = (short *) (input_row_buffer+input_bytes_per_row*2);
			input_row_buffer_shortp4 = (short *) (input_row_buffer+input_bytes_per_row*3);
			output_row_buffer_charp =  output_row_buffer;

			number_output_bytes = output_columns * (rows_per_transfer / dimension_reduction);
			pixel_sum = 0;
			

			for (k = number_output_bytes; k > 0; ) {
				for (column = 0 ;column < output_columns; column++, k-=1) {
					for (h = 0; h < dimension_reduction; h++){
						pixel_sum += (input_row_buffer_shortp1[column*4+h] +
							input_row_buffer_shortp2[column*4+h] +
							input_row_buffer_shortp3[column*4+h] +
							input_row_buffer_shortp4[column*4+h]);
					}
					if (pixel_sum > max_pixel_sum) {
						pixel_sum = max_pixel_sum;
					}
					//pixel_shift variable is here to determine the average of 16 values
					//	then shift high bit to 8 bits.
					*(output_row_buffer_charp++)
						= (unsigned char) ((
						pixel_sum) >> pixel_shift);
						//pixel_sum) >> 6);
					pixel_sum = 0;
				}
				input_row_buffer_shortp1 = (short *) ((unsigned char*)input_row_buffer_shortp1+ input_bytes_per_row);
				input_row_buffer_shortp2 = (short *) ((unsigned char*)input_row_buffer_shortp2+ input_bytes_per_row);
				input_row_buffer_shortp3 = (short *) ((unsigned char*)input_row_buffer_shortp3+ input_bytes_per_row);
				input_row_buffer_shortp4 = (short *) ((unsigned char*)input_row_buffer_shortp4+ input_bytes_per_row);
			}
			output_row_buffer_shortp = (short *) output_row_buffer;
		}
		//

		else if (dimension_reduction == 2) {

			/* average four input pixels to each output */
			/* keep the number of bits per pixel the same */
			input_elements_per_row = input_bytes_per_row
					/ sizeof(short);
			input_row_buffer_shortp1 = (short *) input_row_buffer;
			input_row_buffer_shortp2 = (short *) (input_row_buffer+input_bytes_per_row);
			output_row_buffer_shortp = (short *) output_row_buffer;
			number_output_bytes = output_columns * rows_per_transfer;
			pixel_sum = 0;

			for (k = number_output_bytes; k > 0; ) {
				for (column = 0 ;column < output_columns; column++, k-=2) {
					//wfp 113004-Modified equation to match other 'else if' statements.
					for (h = 0; h < dimension_reduction; h++){
						pixel_sum += (input_row_buffer_shortp1[column*2+h] +
							input_row_buffer_shortp2[column*2+h]); //>> pixel_shift;
					}
					if (pixel_sum > max_pixel_sum) {
						pixel_sum = max_pixel_sum;
					}
					//pixel_shift is here to determine average of 4 values.
					*(output_row_buffer_shortp++) = ((pixel_sum) >> pixel_shift);
					pixel_sum = 0;
					//
				}
				input_row_buffer_shortp1 = (short *) ((unsigned char*)input_row_buffer_shortp1+ input_bytes_per_row*2);
				input_row_buffer_shortp2 = (short *) ((unsigned char*)input_row_buffer_shortp2+ input_bytes_per_row*2);
			}
			output_row_buffer_shortp = (short *) output_row_buffer;
		}
		//wfp 113004- Added complete 'else if' statement for 16:1 reduction.  Could not determine 
		//	way to consolidate with current code.  Understand there is redundancy in this code section.
		else if (dimension_reduction == 4) {

			/* average sixteen input pixels to each output */
			/* keep the number of bits per pixel the same */
			input_elements_per_row = input_bytes_per_row
					/ sizeof(short);
			input_row_buffer_shortp1 = (short *) input_row_buffer;
			input_row_buffer_shortp2 = (short *) (input_row_buffer+input_bytes_per_row);
			input_row_buffer_shortp3 = (short *) (input_row_buffer+input_bytes_per_row*2);
			input_row_buffer_shortp4 = (short *) (input_row_buffer+input_bytes_per_row*3);
			output_row_buffer_shortp = (short *) output_row_buffer;

			number_output_bytes = output_columns * (rows_per_transfer / dimension_reduction) * 2;
			pixel_sum = 0;

			for (k = number_output_bytes; k > 0; ) {
				// this loops through the number of output bytes.
				for (column = 0 ;column < output_columns; column++, k-=2) {
					//this loop fills the output buffer for a single output row. The single output row
					//	is created by 4 input rows.
					for( h = 0; h < dimension_reduction; h++){
						//wfp 113004-Modified equation to match other 'else if' statements.
						//this loop run 4 times to determine a single average output pixel for 
						//	a group of 16 input bytes
						pixel_sum += (input_row_buffer_shortp1[column*4+h] +
							input_row_buffer_shortp2[column*4+h] +
							input_row_buffer_shortp3[column*4+h] +
							input_row_buffer_shortp4[column*4+h]);   // >> pixel_shift;
					}
					if (pixel_sum > max_pixel_sum) {
						pixel_sum = max_pixel_sum;
					}
					//pixel_shift variable is here only to determine average of 16 values.
					*(output_row_buffer_shortp++) = (pixel_sum >> pixel_shift);
					pixel_sum = 0;
					//
				}
				input_row_buffer_shortp1 = (short *) ((unsigned char*)input_row_buffer_shortp1+ input_bytes_per_row*4);
				input_row_buffer_shortp2 = (short *) ((unsigned char*)input_row_buffer_shortp2+ input_bytes_per_row*4);
				input_row_buffer_shortp3 = (short *) ((unsigned char*)input_row_buffer_shortp3+ input_bytes_per_row*4);
				input_row_buffer_shortp4 = (short *) ((unsigned char*)input_row_buffer_shortp4+ input_bytes_per_row*4);
				
			}
			output_row_buffer_shortp = (short *) output_row_buffer;
		}
		//

	
		else if (pixel_bit_reduction) 
		{
			/* reduce from short 16-bit pixels to char 8-bit pixels */
			/* keep the exact same dimensions */
			input_row_buffer_shortp = (short *) input_row_buffer;
			output_row_buffer_charp = (char *) output_row_buffer;
			//number_output_bytes = number_input_bytes / 2;
			number_output_bytes = output_columns * rows_per_transfer;
			input_columns_left = input_columns - output_columns;

			if (pixel_bit_reduction == 1) {
				/* pixel reduction taking the low order byte only */
				for (k = number_output_bytes; k > 0; ) {
					for (column = 0; column < output_columns; column++, k--) {
						*(output_row_buffer_charp++)
							= (unsigned char) (
							*(input_row_buffer_shortp++));
					}
					//wfp 121404-Added FOR statement to deal with odd column length images.
					//	Basically remove the last pixel from each row.
					for (extra=0; extra < input_columns_left; extra++) {
						input_row_buffer_shortp++;
					}
				}
			}
			else if (pixel_bit_reduction == 2) {
				/* pixel reduction taking the two words and shifting */
				for (k = number_output_bytes; k > 0; ) {
					for (column = 0; column < output_columns; column++, k--){
						pixel_sum = pixel_round
							+ *(input_row_buffer_shortp++);
						if (pixel_sum > max_pixel_sum) {
							pixel_sum = max_pixel_sum;
						}
						//pixel_shift variable is here to shift high bit to 8 bits.
						*(output_row_buffer_charp++)
							= (unsigned char) ((
							pixel_sum >> pixel_shift) - 1);
						pixel_sum = 0;
					}
					//wfp 121404-Added FOR statement to deal with odd column length images.
					//	Basically remove the last pixel from each row.
					for (extra=0; extra < input_columns_left; extra++) {
						input_row_buffer_shortp++;
					}
				}
			}
			output_row_buffer_shortp = (short *) output_row_buffer;
		}

		else {
			/* no reduction, just copy from input to output */
			//output_row_buffer_shortp = (short *) input_row_buffer;
			input_row_buffer_shortp = (short *) input_row_buffer;
			input_row_buffer_charp = (unsigned char *) input_row_buffer;
			output_row_buffer_shortp = (short *) output_row_buffer;
			output_row_buffer_charp = (unsigned char *) output_row_buffer;

			//number_output_bytes = number_input_bytes;
			number_output_bytes = output_columns * rows_per_transfer * bytes_per_pixel;
			input_columns_left = input_columns - output_columns;


			//wfp 121404-Rewritten this following.  The code now addresses both 8bit and 16bit images.
			//	The code now addresses odd columns issue.  I now remove the last pixel of each row to 
			//	avoid pixel wrap around.

			if (bytes_per_pixel == 2)		//handle 16bit image
			{
				for (k = number_output_bytes; k > 0; )
				{
					for (q=0; q < output_columns; q++, k -=2)	//copy each pixel to new output pixel
					{
						*(output_row_buffer_shortp++) = *(input_row_buffer_shortp++);
					}
					for (extra=0; extra < input_columns_left; extra++)	//remove extra pixel in row if necessary
					{
						input_row_buffer_shortp++;
					}
				}
				output_row_buffer_shortp = (short *) output_row_buffer;
			}
			else		//handle 8bit image
			{
				for (l = number_output_bytes; l > 0; )
				{
					for (r=0; r < output_columns; r++, l-=1)	//copy each pixel to new output pixel
					{
						*(output_row_buffer_charp++) = *(input_row_buffer_charp++);
					}
					for (extra=0; extra < input_columns_left; extra++)	//remove extra pixel in row if necessary
					{
						input_row_buffer_charp++;
					}
				}
				output_row_buffer_charp = (unsigned char *) output_row_buffer;
			}
		}

		number_wrote = fwrite(output_row_buffer_shortp, 1,
			number_output_bytes, output);

		if (number_wrote != number_output_bytes) {
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

		/* Increment row counter based upon the last transfer */

		row = row + rows_per_transfer; 
		if (row > input_rows) break;
		if (row + rows_per_transfer > input_rows) {
			/* Decrease # rows transfered the last time */
			rows_per_transfer = input_rows - row + 1;
		}
	}
	finish = clock();
		
	if (VERBOSE>1) {
		printf("\nProgram takes %.2f seconds.\n",
			(float) (finish-start)/CLK_TCK);
	}

	if (VERBOSE>2) {
		k = 0;  /* print only non-zero rows */
		for (i=0; i< (2 * MAX_HISTOGRAM_PIXEL_VALUE); i+=10) {
			if (density_histogram[i+0]
			  | density_histogram[i+1]
			  | density_histogram[i+2]
			  | density_histogram[i+3]
			  | density_histogram[i+4]
			  | density_histogram[i+5]
			  | density_histogram[i+6]
			  | density_histogram[i+7]
			  | density_histogram[i+8]
			  | density_histogram[i+9]) {
				if (k == 2) k = 4; /* non-zero row, after zero row, afer non-zero row */
				else k = 3;	/* non-zero row, after non-zero row (or 1st non-zero row) */
			}
			else if (k) k = 2; /* zero row, after something printed */
							
			if (k > 2) {
				if (k == 4) printf("\n     *");
				printf("\n%6d:",(i - MAX_HISTOGRAM_PIXEL_VALUE));
				for (j=i; j<(i+10); j++) {
					if (density_histogram[j]) printf("%7ld",
						density_histogram[j]);
					else printf("       ");
				}
				k = 1; /* non-zero row just printed */
			}
		}
		printf("\n");
	}

	if (VERBOSE) {
		printf("\nMinimum Pixel Value: %d   Maximum Pixel Value: %d\n",
			min_pixel_value, max_pixel_value);
	}

	return (NO_ERROR);
}

void usage(void)
{
	printf("\ndcmtotga -- Read a DICOM file and output a TGA file");
	printf("\n\t(%s Version 1.1, %s %s)\n",OS,__DATE__,__TIME__);
	printf("\
Usage:	dcmtotga {input filename} {output filename} {argument(s)}\n\
\n\
Arguments (* - optional)\n\
------------------------\n\
annn* --- add nnn to each pixel (before min/max check)\n\
bnnn ---- number of bits in a pixel (stored in the TGA header)\n\
cnnn* --- ceiling (maximum) pixel value (any value > nnn becomes nnn)\n\
fnnn* --- floor (minimum) pixel value (any value < nnn becomes nnn)\n\
i ------- invert each pixel\n\
onnn ---- byte offset in DICOM file to image\n\
r{1,2,4,8,16,32}* -- reduce the size of the image file a factor of 2, 4, 8, 16, or 32\n\
snnnn* -- subtract nnnn from each pixel (unsigned arithmetic -- before add)\n\
xnnn ---- X-dimension of image (horizontal width or number of columns)\n\
ynnn ---- Y-dimension of image (vertical height or number of rows)\n\
\n\
The following environment variables can override the default settings\n\
	DCMTOTGA_VERBOSE=1		/* selects brief verbose mode */\n\
	DCMTOTGA_VERBOSE=2		/* selects total verbose mode */\n\
	DCMTOTGA_VERBOSE=3		/* turns on density histogram */\n");
	exit(1);
}
