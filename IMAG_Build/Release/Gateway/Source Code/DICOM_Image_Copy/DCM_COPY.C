/**********************************************************************/
/*                                                                    */
/*   dcm_copy.c -- Copy the image from a DICOM file.                  */
/*                                                                    */
/*   This routine is typically called when the DICOM header is being  */
/*   updated either to change from Explicit VR to Implicit VR or      */
/*   the values of the attributes are being change (i.e. coerced).    */
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

#include	<stdio.h>
#include	<sys/stat.h>

#define	NO_ERROR	0	/* No error occurred */
#define	EOF_INPUT	-1	/* End of Input File */
#define	READ_ERROR	-2	/* Read Error detected by ferror() */
#define	EOF_OUTPUT	-3	/* End of Output File */
#define	WRITE_ERROR	-4	/* Write Error detected by ferror() */
#define	UNKNOWN_ERROR	-999	/* Unknown Error */

#define PICHDSIZE	18	/* TGA picture header size */
#define MAX_ARRAY	65535	/* Maximum Array Size for DOS - 1 */

#define MS_NT	1

#ifdef MS_NT
#define OS	"NT (Intel)"
#else	
#define OS	"DOS"
#endif

extern int exit(int);
extern long atol(char *);
static void dicom_copy(void);
static void usage(void);

unsigned char buffer[MAX_ARRAY];/* workspace for image buffering */
long image_offset;				/* offset to the image in the file */
long number_bytes_to_copy;		/* number of bytes in image */
FILE	*input, *output;		/* tga input and dcm output files */
int	columns, rows;				/* number of columns(x) and rows(y) */

void main(int argc, char *argv[])
{


	struct stat stat_buffer;
	// int	i;

	if (argc != 5) {
		usage();
	}

	if ((input = fopen(argv[1], "rb")) == NULL) {
		fprintf(stderr,"Could not open input file %s\n",argv[1]);
		exit(1);
	}

	/* the output file must already exist, with a DICOM header */

	if (stat(argv[2], &stat_buffer) == -1) {
		fprintf(stderr,"The output file %s with the DICOM header does not exit.\n",argv[2]);
		exit(1);
	}
	
	if ((output = fopen(argv[2], "ab")) == NULL) {
		fprintf(stderr,"Could not open output file %s\n",argv[2]);
		exit(1);
	}

	image_offset = atol(argv[3]);
	number_bytes_to_copy = atol(argv[4]);

	// printf("Image offset: %ld\n", image_offset);
	// printf("Number of bytes to copy: %ld\n", number_bytes_to_copy);
	
	dicom_copy();
	
	
	exit (0);
}

void dicom_copy(void)
{
	int	error = 0;
	long number_bytes_remaining;	/* number of bytes yet to copy */
	int number_input_bytes;			/* number of bytes copied */
	int number_read, number_wrote;	/* i/o byte counters */
	
	fseek(input, image_offset, 0);	/* position to beginning of the image */

	number_bytes_remaining = number_bytes_to_copy;
	
	do {
		if (number_bytes_remaining > MAX_ARRAY) {
			number_input_bytes = MAX_ARRAY;
		}
		else {
			number_input_bytes = number_bytes_remaining;
		}
		
		number_read = fread(buffer, 1, number_input_bytes, input);

		if (number_read != number_input_bytes) {
			if (feof(input)) {
				fprintf(stderr,"\nEOF reached reading image\n");
				exit(EOF_INPUT); // end of file
			}
			if (ferror(input)) {
				fprintf(stderr,"\nRead error\n");
				exit(READ_ERROR); // read error
			}		
			exit(UNKNOWN_ERROR);
		}

		number_wrote = fwrite(buffer, 1, number_input_bytes, output);

		if (number_wrote != number_input_bytes) {
			if (feof(output)) {
				fprintf(stderr,"\nOutput EOF reached\n");
				exit(EOF_OUTPUT);
			}
			if (ferror(input)) {
				fprintf(stderr,"\nWrite error\n");
				exit(WRITE_ERROR); // read error
			}		
			exit(UNKNOWN_ERROR);
		}

		/* decrement the number of bytes remining by the number copied */
		number_bytes_remaining -= number_input_bytes;
		
		/* printf("Number bytes copied: %ld, number bytes remaining:%ld\n",
			number_input_bytes, number_bytes_remaining); */

	} while (number_bytes_remaining);
}


void usage(void)
{
	printf("\ndcm_copy -- Read a DICOM file and output a DICOM file");
	printf("\n\t(%s Version 1.0, %s %s)\n",OS,__DATE__,__TIME__);
	printf("\n\
Usage:dcm_copy {input file} {output file} {input offset} {number bytes to copy}\n");

	exit(1);
}
