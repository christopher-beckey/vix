/*
**	Copyright (c) 1987, 1988
**	Truevision Inc.
**	All Rights Reserved
**
*/

/******************************************************************************/
/*  FILE STRUCTURE FOR THE OLD TARGA OR VISTA TIPS FILE			      */
/*	  FIELD 1 :	NUMBER OF CHARACTERS IN ID FIELD (1 BYTES)	      */
/*	  FIELD 2 :	COLOR MAP TYPE (1 BYTES)			      */
/*	  FIELD 3 :	IMAGE TYPE CODE (1 BYTES)			      */
/*				= 0 	NO IMAGE DATA INCLUDED		      */
/*				= 1	UNCOMPRESSED, COLOR-MAPPED IMAGE      */
/*				= 2	UNCOMPRESSED, REAL-COLOR IMAGE	      */
/*				= 3	UNCOMPRESSED, BLACK AND WHITE IMAGE   */
/*				= 9	RUN-LENGTH ENCODED COLOR-MAPPED IMAGE */
/*				= 10	RUN-LENGTH ENCODED REAL-COLOR IMAGE   */
/*				= 11	COMPRESSED, BLACK AND WHITE IMAGE     */
/*	  FIELD 4 :	COLOR MAP SPECIFICATION	(5 BYTES)		      */
/*				4.1 : COLOR MAP ORIGIN (2 BYTES)	      */
/*				4.2 : COLOR MAP LENGTH (2 BYTES)	      */
/*				4.3 : COLOR MAP ENTRY SIZE (2 BYTES)	      */
/*	  FIELD 5 :	IMAGE SPECIFICATION (10 BYTES)			      */
/*				5.1 : X-ORIGIN OF IMAGE (2 BYTES)	      */
/*				5.2 : Y-ORIGIN OF IMAGE (2 BYTES)	      */
/*				5.3 : WIDTH OF IMAGE (2 BYTES)		      */
/*				5.4 : HEIGHT OF IMAGE (2 BYTES)		      */
/*				5.5 : IMAGE PIXEL SIZE (1 BYTE)		      */
/*				5.6 : IMAGE DESCRIPTOR BYTE (1 BYTE) 	      */
/*	  FIELD 6 :	IMAGE ID FIELD (LENGTH SPECIFIED BY FIELD 1)	      */
/*	  FIELD 7 :	COLOR MAP DATA (BIT WIDTH SPECIFIED BY FIELD 4.3 AND  */
/*			NUMBER OF COLOR MAP ENTRIES SPECIFIED IN FIELD 4.2)   */
/*	  FIELD 8 :	IMAGE DATA FIELD (WIDTH AND HEIGHT SPECIFIED IN       */
/*			FIELD 5.3 AND 5.4)				      */
/******************************************************************************/

#define PICHDSIZE 18

typedef struct PicFile {
	unsigned char	idLength;	/* length of ID	*/
	unsigned char	mapType;	/* color map type	*/
	unsigned char	imageType;	/* image type	*/
	struct	MapHead{		/* map information	*/
		unsigned int	origin;	/* starting index of map */
		unsigned int	length;	/* length of map	*/
		unsigned char	width;	/* width of map in bits	*/
	} MapInfo;
	struct	ImHead {
		unsigned int	x;	/* x-origin of image	*/
		unsigned int	y;	/* y-origin of image	*/
		unsigned int	dx;	/* dx-origin of image	*/
		unsigned int	dy;	/* dy-origin of image	*/
		unsigned char	depth;	/* bits per pixel	*/
		unsigned char	attrib;	/* attributes per pixel	*/
	} ImageInfo;
} PICINFO;
