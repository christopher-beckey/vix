//Per VHA Directive 2004-038, this routine should not be modified.
// +---------------------------------------------------------------+
// | Property of the US Government.                                |
// | No permission to copy or redistribute this software is given. |
// | Use of unreleased versions of this software requires the user |
// | to execute a written test agreement with the VistA Imaging    |
// | Development Office of the Department of Veterans Affairs,     |
// | telephone (301) 734-0100.                                     |
// |                                                               |
// | The Food and Drug Administration classifies this software as  |
// | a medical device.  As such, it may not be changed in any way. |
// | Modifications to this software may result in an adulterated   |
// | medical device under 21CFR820, the use of which is considered |
// | to be a violation of US Federal Statutes.                     |
// +---------------------------------------------------------------+
// 
// 
#ifndef _DFXCONSTS_H
#define _DFXCONSTS_H

//
// This file contains constants used by the DimplX ActiveX.
//

// want the Dimpl constants
#ifndef _DOME_BUILD_OCX
#include "DConsts.h"
#endif

// parameter values
//  new
static const long DFX_ID_OLD  = -10;
static const long DFX_ID_NOID = -11;

static const long DFX_WAIT_ALL = 1;

static const long DFX_IMAGE_UNDEFINED = 0;
static const long DFX_IMAGE_NOTLAST   = 1;
static const long DFX_IMAGE_LAST      = 2;

static const long DFX_CANCELDISPLAY = 1;

static const long DFX_MORE_QUIT      = 0;
static const long DFX_MORE_CONTINUE  = 1;
static const long DFX_MORE_FINALHIER = 2;
static const long DFX_MORE_REPRODUCE = 3;
static const long DFX_MORE_NEXTFRAME = 4;

static const long DFX_DICOM_DOPART10 = 0x00010000;

static const long DFX_DICOM_ELEMENT_PROMOTE_UNSIGNED          = 0x00000001;
static const long DFX_DICOM_ELEMENT_PROMOTE_ALL               = 0x00000002;
static const long DFX_DICOM_ELEMENT_CONVERT_NUMERICSTRINGS    = 0x00000004;
static const long DFX_DICOM_ELEMENT_DEMOTE_SIGNED             = 0x00000008;
static const long DFX_DICOM_ELEMENT_RETURN_ARRAY_MASK         = 0x00003000;
static const long DFX_DICOM_ELEMENT_RETURN_ARRAY              = 0x00001000;
static const long DFX_DICOM_ELEMENT_RETURN_SCALAR             = 0x00002000;
static const long DFX_DICOM_ELEMENT_RETURN_UNSIGNED_MASK      = 0x0000c000;
static const long DFX_DICOM_ELEMENT_RETURN_UNSIGNED           = 0x00004000;
static const long DFX_DICOM_ELEMENT_RETURN_UNSIGNED_AS_SIGNED = 0x00008000;

static const long DFX_PROGRESSIVE_HIERARCHICAL  = 0x0001;
static const long DFX_PROGRESSIVE_PAINTDOWN     = 0x0002;
static const long DFX_PROGRESSIVE_LOAD_ALL      = 0x00ff;
static const long DFX_PROGRESSIVE               = 0xffff;

static const long DFX_FIT_TYPE_MASK       = 0x00ff;
static const long DFX_FIT_TYPE_NOFIT      = 0x0000;   // not fitted
static const long DFX_FIT_TYPE_MAX        = 0x0001;
static const long DFX_FIT_TYPE_ROTATABLE  = 0x0002;
static const long DFX_FIT_TYPE_FINALSIZE  = 0x0003;   // not fitted
static const long DFX_FIT_NOUPSCALE       = 0x0100; // don't resize above final size

static const long DFX_SPACE_RGB_OR_GRAY   = -1;
//  old

// SCODEs
//  new
static const int DFX_SCODE_DIMPL_ERROR              = CUSTOM_CTL_SCODE(2000);
static const int DFX_SCODE_NOSUCHID                 = CUSTOM_CTL_SCODE(2001);
static const int DFX_SCODE_UNUSED_001               = CUSTOM_CTL_SCODE(2002);
static const int DFX_SCODE_NO_FILE                  = CUSTOM_CTL_SCODE(2003);
static const int DFX_SCODE_NO_IMAGE                 = CUSTOM_CTL_SCODE(2004);
static const int DFX_SCODE_NOT_AN_IMAGE             = CUSTOM_CTL_SCODE(2005);
static const int DFX_SCODE_INVALID_MORE             = CUSTOM_CTL_SCODE(2006);
static const int DFX_SCODE_FILE_NOT_FOUND           = CUSTOM_CTL_SCODE(2007);
static const int DFX_SCODE_INVALID_COLORSPACE       = CUSTOM_CTL_SCODE(2008);
static const int DFX_SCODE_NOT_FILEIMAGE            = CUSTOM_CTL_SCODE(2009);
static const int DFX_SCODE_NOT_PALETTEIMAGE         = CUSTOM_CTL_SCODE(2010);
static const int DFX_SCODE_NOT_DICOMIMAGE           = CUSTOM_CTL_SCODE(2011);
static const int DFX_SCODE_JOB_PENDING              = CUSTOM_CTL_SCODE(2012);
static const int DFX_SCODE_JOB_IN_PROGRESS          = CUSTOM_CTL_SCODE(2013);
static const int DFX_SCODE_JOB_ABORTED              = CUSTOM_CTL_SCODE(2014);
//  old
static const int DFX_SCODE_CREATE_IMAGE_FROM_DP     = CUSTOM_CTL_SCODE(1000);
static const int DFX_SCODE_CREATE_IMAGE_FROM_URL    = CUSTOM_CTL_SCODE(1001);
static const int DFX_SCODE_CANT_CHANGE_NOW          = CUSTOM_CTL_SCODE(1002);
//  shared
static const int DFX_SCODE_UNKNOWN                  = CUSTOM_CTL_SCODE(30000);
static const int DFX_SCODE_INTERNAL                 = CUSTOM_CTL_SCODE(30001);
static const int DFX_SCODE_NYI                      = CUSTOM_CTL_SCODE(32767);

// return values
//  new
//  old
static const long DFX_ERROR_SUCCESS              =  0;
static const long DFX_ERROR_UNKNOWN              = -1;
static const long DFX_ERROR_NO_SESSION           = -2;
static const long DFX_ERROR_FILE_NOT_FOUND       = -3;
static const long DFX_ERROR_FILE_IO              = -4;
static const long DFX_ERROR_FILE_NOT_DICOM       = -5;
static const long DFX_ERROR_ELEMENT_NOT_FOUND    = -6;
static const long DFX_ERROR_VR_MISMATCH          = -7;
static const long DFX_ERROR_BAD_PARAM_TYPE       = -8;
static const long DFX_ERROR_MEMORY_ALLOCATION    = -9;
static const long DFX_ERROR_ELEMENT_ZERO_LENGTH  = -10;

// utility function
#ifndef _DOME_BUILD_OCX
static inline long DFD_VR(char c0, char c1)
{
    return long((((unsigned char)(c1)) << 8) + ((unsigned char)(c0)));
}

static inline long DFD_VR1(const char* c)
{
     return long((((unsigned char)(c[1])) << 8) + ((unsigned char)(c[0])));
}

static inline long D_COMP_JPEG_QUALITY(short quality)
{
	if ( quality < 0 )
		quality = 0;
	else if ( quality > D_COMP_JPEG_MAX_QUALITY )
		quality = D_COMP_JPEG_MAX_QUALITY;
     return D_COMP_JPEG | quality;
}

static inline long D_COMP_JPEG_PROG_QUALITY(short quality)
{
	if ( quality < 0 )
		quality = 0;
	else if ( quality > D_COMP_JPEG_MAX_QUALITY )
		quality = D_COMP_JPEG_MAX_QUALITY;
     return D_COMP_JPEG_PROG | quality;
}

static inline long D_COMP_JPEG_LL_HIER_FRAMES(short nHierarchies)
{
 	if ( nHierarchies < 1 )
		nHierarchies = 1;
	else if ( nHierarchies > D_COMP_JPEG_LL_HIER_MAX_FRAMES )
		nHierarchies = D_COMP_JPEG_LL_HIER_MAX_FRAMES;
    return D_COMP_JPEG_LL_HIER | nHierarchies;
}
#endif

#endif