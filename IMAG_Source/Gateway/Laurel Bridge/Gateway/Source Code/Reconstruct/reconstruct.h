
#ifndef RECONSTRUCT_H
#define RECONSTRUCT_H


#define	VERSION		"1.5"
#define NUM_ARGS	3
#define SPACE           ' '
#define TAB             '\t'
#define EOL             '\n'
#define PIPE			'|'
//#define NULL			'\0'

//#define	ACR_IMPLICIT_LITTLE_ENDIAN		1
#define	PART10_VR_IMPLICIT	2
#define	PART10_VR_EXPLICIT	3
#define PART10_JPEG         4

#define DATADICT	"MAG_recon.txt"
#define IMPL_CLASS_UID  "1.2.840.113754.2.1.3.0"
#define IMPL_VERSION_NAME   "VA_VISTA_IMG"

#define INSERT	1
#define CHANGE	2
#define REMOVE	3

//exception constants
#define SUCCESS				0
#define NO_FILE				-1
#define INVALID_FILETYPE	-2
#define CANNOT_OPEN_FILE	-3
#define CANNOT_PARSE_FILE	-4
#define OUT_OF_RESOURCES	-5
#define TAG_ALREADY_EXISTS	-6
#define TAG_DOES_NOT_EXISTS	-7
#define VALUE_EXCEEDED		-8
#define TYPE_1				-9
#define INVALID_TAG_DATA	-10
#define SEQUENCE_TAG		-11
#define CANNOT_SAVE_FILE	-12

#include "stdafx.h"
#include "afxcoll.h"
#include "string.h"
#include "stdio.h"
#include "stdlib.h"
#include "malloc.h"
#include "iostream.h"
#include "ctype.h"
#include "Exception.h"
#include "Stdout.h"
#include "Parser.h"
#include "LineEntry.h"
#include "TagLine.h"
#include "dicom.hpp"
#include "PDUServ.h"
#include "EnDICOM.h"
#include "Reconstructor.h"

typedef unsigned short int USHORT;

#endif