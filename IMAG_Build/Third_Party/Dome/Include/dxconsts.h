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
#ifndef _DXCONSTS_H
#define _DXCONSTS_H

//
// This file contains constants used by the DimplX ActiveX.
//

// want the Dimpl constants
#ifndef _DOME_BUILD_OCX
#include "DConsts.h"
#endif

// DimplXCtl.h
static const long DX_WPO_DISABLE_MATCHING        = 0x00000000;
static const long DX_WPO_USE_EXISTING_ENTRIES    = 0x00000001;
static const long DX_WPO_FILL_WITH_PREVIOUS      = 0x00000002;
static const long DX_WPO_FILL_WITH_COLORS        = 0x00000003;
static const long DX_WPO_FILL_WITH_GRAYS         = 0x00000004;
static const long DX_WPO_MASK                    = 0x0000FFFF;

static const long DX_WPO_CONVERT_BG_TO_GRAY_NTSC = 0x00010000;
static const long DX_WPO_CONVERT_BG_TO_GRAY_MAX  = 0x00020000;
static const long DX_WPO_CONVERT_MASK            = 0x00FF0000;

static const long DX_WPO_REALIZE_SET_IMAGE       = 0x01000000;
static const long DX_WPO_REALIZE_PAINT_IMAGE     = 0x02000000;
static const long DX_WPO_NO_REALIZE_SET_PALETTE =  0x04000000;
static const long DX_WPO_REALIZE_MASK            = 0xFF000000;

static const long DX_CACHE_PRELUT            = 0x00000001;
static const long DX_CACHE_CONVOLVE          = 0x00000002;
static const long DX_CACHE_MIRROR_AND_ROTATE = 0x00000004;
static const long DX_CACHE_WINDOWLEVEL       = 0x00000008;
static const long DX_CACHE_SCALE             = 0x00000010;
static const long DX_CACHE_FULL_UPDATE       = 0x80000000;

static const long DX_OPTION_CENTER      = 0x01;
static const long DX_OPTION_ENABLE_DRAG = 0x02;

static const long DX_BITMAP_ROTATE = 0x01;
static const long DX_BITMAP_NATIVE = 0x02;

static const long DX_PALETTE_NOT_PALETTE_DEVICE = 0x00000000;
static const long DX_PALETTE_CUSTOM             = 0x00000001;
static const long DX_PALETTE_GRAYSCALE_128      = 0x00000002;
static const long DX_PALETTE_GRAYSCALE_236      = 0x00000003;
static const long DX_PALETTE_GRAYSCALE_256      = 0x00000004;
static const long DX_PALETTE_PSEUDOCOLOR_2_3_2  = 0x00000005;
static const long DX_PALETTE_CREATE             = 0x80000000;

static const long DX_PALETTEFOCUS_FOLLOW_NONE    = 0;
static const long DX_PALETTEFOCUS_FOLLOW_KBFOCUS = 1;

static const long DX_LUT_PRELUT      = 0x01;
static const long DX_LUT_WINDOWLEVEL = 0x02;

static const long DX_FLATTEN_IMAGE_LAYERS_HIDDEN         = 0x00000001;
static const long DX_FLATTEN_IMAGE_LAYERS_VISIBLE        = 0x00000002;
static const long DX_FLATTEN_IMAGE_LAYERS_BITMAP_HIDDEN  = 0x00000004;
static const long DX_FLATTEN_IMAGE_LAYERS_BITMAP_VISIBLE = 0x00000008;
static const long DX_FLATTEN_IMAGE_LAYERS_ALL            = 0x0000000f;
static const long DX_FLATTEN_IMAGE_MASK                  = 0x0000000f;
static const long DX_FLATTEN_ANNOTATION_LAYERS_HIDDEN    = 0x00000010;
static const long DX_FLATTEN_ANNOTATION_LAYERS_VISIBLE   = 0x00000020;
static const long DX_FLATTEN_ANNOTATION_LAYERS_ALL       = 0x000000f0;
static const long DX_FLATTEN_ANNOTATION_MASK             = 0x000000f0;

static const long DX_EXPORT_DIB_TOPDOWN  = 0x00000000;
static const long DX_EXPORT_DIB_BOTTOMUP = 0x00000001;

static const long DX_ROTATE_0   = 0;
static const long DX_ROTATE_90  = 1;
static const long DX_ROTATE_180 = 2;
static const long DX_ROTATE_270 = 3;

// ImgWndRgn.h
static const long DX_INTERACTIVE_ENABLED        = 0x01;
static const long DX_INTERACTIVE_SCALE          = 0x02;
static const long DX_INTERACTIVE_BITMAP_OVERLAY = 0x04;
static const long DX_INTERACTIVE_CONVOLVE       = 0x08;
static const long DX_INTERACTIVE_REAL_TIME      = 0x10;

static const long DX_INTERACTIVE_ALL_ENABLED    = 0xFF;
static const long DX_INTERACTIVE_ALL_STANDBY    = 0xFE;
static const long DX_INTERACTIVE_ALL_ENABLED_EXCEPT_RT = DX_INTERACTIVE_ALL_ENABLED & ~DX_INTERACTIVE_REAL_TIME;
static const long DX_INTERACTIVE_ALL_STANDBY_EXCEPT_RT = DX_INTERACTIVE_ALL_STANDBY & ~DX_INTERACTIVE_REAL_TIME;

static const long DX_USEROP_BEFORE_PRELUT        = 0;
static const long DX_USEROP_BEFORE_CONVOLVE      = 1;
static const long DX_USEROP_BEFORE_MIRROR_ROTATE = 2;
static const long DX_USEROP_BEFORE_WINLEV_SCALE  = 3;
static const long DX_USEROP_BEFORE_PIPELINE_END  = 4;
static const long DX_USEROP_NPOSITIONS           = 5;  // not exposed

static const long DX_USEROP_TYPE_UNCHANGED   = -1;
static const long DX_USEROP_NBANDS_UNCHANGED = -1;

static const long DX_USEROP_READ_ONLY        = 0x01;
static const long DX_USEROP_FORCE_PACKED_RGB = 0x02;
static const long DX_USEROP_FORCE_PLANAR_RGB = 0x04;

static const long DX_LP_RETURNNONEXISTENT = 0x1;

static const long DX_PIPELINE_EXCLUDE_USEROP_BEFORE_PRELUT         = 0x0010;
static const long DX_PIPELINE_EXCLUDE_PRELUT                       = 0x0020;
static const long DX_PIPELINE_EXCLUDE_USEROP_BEFORE_CONVOLVE       = 0x0040;
static const long DX_PIPELINE_EXCLUDE_CONVOLVE                     = 0x0080;
static const long DX_PIPELINE_EXCLUDE_USEROP_BEFORE_MIRROR_ROTATE  = 0x0100;
static const long DX_PIPELINE_EXCLUDE_MIRROR_ROTATE                = 0x0200;
static const long DX_PIPELINE_EXCLUDE_USEROP_BEFORE_SCALE          = 0x0400;
static const long DX_PIPELINE_EXCLUDE_SCALE                        = 0x0800;
static const long DX_PIPELINE_EXCLUDE_WINLEVEL                     = 0x1000;
static const long DX_PIPELINE_EXCLUDE_USEROP_BEFORE_PIPELINE_END   = 0x2000;
static const long DX_PIPELINE_EXCLUDE_ALL                          = 0x3FF0;

static const long DX_EXECUTEPIPELINE_CLIPPEDANDOFFSET = 0x00000003;

// OverlayElement.h
static const long DX_ELEMENT_LINE      = 10;
static const long DX_ELEMENT_RECTANGLE = 11;
static const long DX_ELEMENT_TEXTBOX   = 12;
static const long DX_ELEMENT_ELLIPSE   = 13;
static const long DX_ELEMENT_POLYGON   = 14;

#ifdef _VACHANGE
static const long DX_ELEMENT_RULER     = 16;

static const long DX_RULER_X         = 0;
static const long DX_RULER_Y         = 1;
static const long DX_RULER_XY        = 2;

static const long DX_ELEMENT_LENGTHX      = 17;
static const long DX_ELEMENT_ELLIPSEX     = 18;
static const long DX_ELEMENT_ANGLEX       = 19;
static const long DX_ELEMENT_FREEHAND     = 20;
static const long DX_ELEMENT_RECTAREA     = 21;
static const long DX_ELEMENT_OVERLAYTEXT  = 22;
static const long DX_ELEMENT_LABEL        = 23;
static const long DX_ELEMENT_ARROW        = 24;
static const long DX_ELEMENT_AUTOLABEL    = 25;
static const long DX_ELEMENT_PROJECTION   = 26;
static const long DX_ELEMENT_ANNOTLINE    = 27;
static const long DX_ELEMENT_ANNOTRECT    = 28;
static const long DX_ELEMENT_ANNOTELLIPSE = 29;
static const long DX_ELEMENT_ANNOTFREEHAND = 31;
static const long DX_ELEMENT_COBBANGLE		 = 32;
static const long DX_ELEMENT_REDACTRECT	 = 33;
static const long DX_ELEMENT_DICOMSHUTTER	 = 34;
static const long DX_ELEMENT_OVERLAYALERT  = 35;
static const long DX_ELEMENT_OVERLAYWINLEV = 36;

#endif

static const long DX_LES_PLAIN       = 0;
static const long DX_LES_ARROW_RIGHT = 1;
static const long DX_LES_ARROW_LEFT  = 2;
static const long DX_LES_ARROW_BOTH  = 3;

static const long DX_LS_SOLID      = 0;
static const long DX_LS_DASH       = 1;  /* ------- NT only? */
static const long DX_LS_DOT        = 2;  /* ....... NT only? */
static const long DX_LS_DASHDOT    = 3;  /* _._._._ NT only? */
static const long DX_LS_DASHDOTDOT = 4;  /* _.._.._ NT only? */

static const long DX_FS_NORMAL    = 0x00;
static const long DX_FS_BOLD      = 0x01;
static const long DX_FS_ITALIC    = 0x02;
static const long DX_FS_UNDERLINE = 0x04;
static const long DX_FS_STRIKEOUT = 0x08;

static const long DX_TEXT_JUSTIFY_LEFT   = 0;
static const long DX_TEXT_JUSTIFY_CENTER = 1;
static const long DX_TEXT_JUSTIFY_RIGHT  = 2;

static const long DX_COORD_IMAGE             = 0;
static const long DX_COORD_WINDOW            = 1;

static const long DX_LAYER_LOCK_IMAGEUNLOCKED  = 0;
static const long DX_LAYER_LOCK_IMAGELOCKED    = 2;
static const long DX_LAYER_LOCK_WINDOWUNLOCKED = 3;
static const long DX_LAYER_LOCK_WINDOWLOCKED   = 1;

static const long DX_LAYER_LOCK_UNLOCKED = 0;  // deprecated
static const long DX_LAYER_LOCK_WINDOW   = 1;  // deprecated
static const long DX_LAYER_LOCK_IMAGE    = 2;  // deprecated

static const long DX_LAYER_NOT_SELECTABLE         = 0;
static const long DX_LAYER_SELECTABLE             = 1;
static const long DX_LAYER_SELECTABLE_TRANSPARENT = 2;

// OverlayLayer.h
static const long DX_MODE_NORMAL              = 0;
static const long DX_MODE_SELECT              = 1;
static const long DX_MODE_DELETE              = 2;
static const long DX_MODE_ELEMENT_BRING_FRONT = 3;
static const long DX_MODE_ELEMENT_SEND_BACK   = 4;
static const long DX_MODE_LAYER_BRING_FRONT   = 5;
static const long DX_MODE_LAYER_SEND_BACK     = 6;
static const long DX_MODE_ANIMATE_LINE        = 7;
static const long DX_MODE_LINE                = 10;
static const long DX_MODE_RECTANGLE           = 11;
static const long DX_MODE_TEXTBOX             = 12;
static const long DX_MODE_ELLIPSE             = 13;
static const long DX_MODE_POLYGON             = 14;

#ifdef _VACHANGE
static const long DX_MODE_LENGTHX             = 17;
static const long DX_MODE_ELLIPSEX            = 18;
static const long DX_MODE_ANGLEX              = 19;
static const long DX_MODE_FREEHAND            = 20;
static const long DX_MODE_RECTAREA            = 21;
static const long DX_MODE_LABEL               = 23;
static const long DX_MODE_ARROW               = 24;
static const long DX_MODE_AUTOLABEL           = 25;
static const long DX_MODE_ANNOTLINE           = 27;
static const long DX_MODE_ANNOTRECT           = 28;
static const long DX_MODE_ANNOTELLIPSE        = 29;
static const long DX_MODE_CALIBRATION         = 30;
static const long DX_MODE_ANNOTFREEHAND       = 31;
static const long DX_MODE_COBBANGLE           = 32;
static const long DX_MODE_REDACTRECT          = 33;
static const long DX_MODE_DICOMSHUTTER        = 34;
#endif

static const long DX_LAYER_SCALE_OUTLINE  = 0x01;
static const long DX_LAYER_SCALE_CONTENTS = 0x02;

static const long DX_LAYERS_FUTURE                 = -1;
static const long DX_LAYERS_CURRENT                = -2;
static const long DX_LAYERS_CURRENT_AND_FUTURE     = -3;
static const long DX_LAYERS_NONE                   = -4;  // not exposed

static const long DX_ELEMENTS_FUTURE               = -1;
static const long DX_ELEMENTS_CURRENT              = -2;
static const long DX_ELEMENTS_CURRENT_AND_FUTURE   = -3;
static const long DX_ELEMENTS_SELECTED             = -4;  // not supported
static const long DX_ELEMENTS_SELECTED_AND_FUTURE  = -5;  // not supported
static const long DX_ELEMENTS_SELECTED_ELSE_FUTURE = -6;  // not supported

#ifdef _VACHANGE
static const long DX_ELEMENTS_USER_MEASURE         = -7;
static const long DX_ELEMENTS_USER_ANNOT           = -8;
static const long DX_ELEMENTS_USER                 = -9;
#endif

// SCODEs (DimplXCtl.h)
static const int DX_SCODE_BUILD_PIPELINE      = CUSTOM_CTL_SCODE(1000);
static const int DX_SCODE_UNUSED_000          = CUSTOM_CTL_SCODE(1001);
static const int DX_SCODE_BAD_DIMPLX_OBJECT   = CUSTOM_CTL_SCODE(1002);
static const int DX_SCODE_BAD_PARAMETER       = CUSTOM_CTL_SCODE(1003);
static const int DX_SCODE_BAD_LAYER_ID        = CUSTOM_CTL_SCODE(1004);
static const int DX_SCODE_BAD_ELEMENT_ID      = CUSTOM_CTL_SCODE(1005);
static const int DX_SCODE_UNUSED_001          = CUSTOM_CTL_SCODE(1006);
static const int DX_SCODE_DIMPL_API           = CUSTOM_CTL_SCODE(1007);
static const int DX_SCODE_UNDEFINED_PROPERTY  = CUSTOM_CTL_SCODE(1008);
static const int DX_SCODE_INTERNAL_FATAL      = CUSTOM_CTL_SCODE(32766);
static const int DX_SCODE_NYI                 = CUSTOM_CTL_SCODE(32767);

// return values (DimplXCtl.h)
static const long DX_ERROR_SUCCESS             = 0;
static const long DX_ERROR_OUT_OF_MEMORY       = -1;
static const long DX_ERROR_BAD_LAYER_ID        = -2;
static const long DX_ERROR_BAD_ELEMENT_ID      = -3;
static const long DX_ERROR_NO_SUCH_ELEMENT     = -4;
static const long DX_ERROR_BAD_COORDINATES     = -5;
static const long DX_ERROR_VARIANT_FORMAT      = -6;
static const long DX_ERROR_BAD_COLOR_FORMAT    = -7;
static const long DX_ERROR_BAD_PIPELINE        = -8;
static const long DX_ERROR_USEROP_POSITION     = -9;
static const long DX_ERROR_BAD_IMAGE           = -10;
static const long DX_ERROR_WRONG_ELEMENT_TYPE  = -11;
static const long DX_ERROR_BAD_PARAMETER       = -12;
static const long DX_ERROR_WINDOWS_API         = -13;
static const long DX_ERROR_DIMPL_API           = -14;
static const long DX_ERROR_NO_SUCH_LAYER       = -15;

// results (OverlayElement.h)
static const long DX_RESULT_OK                       = 0;
static const long DX_RESULT_INDETERMINATE            = -1;
static const long DX_RESULT_NOT_APPLICABLE           = -2;

static const double DX_RESULT_INDETERMINATE_DOUBLE  = -1000000.0;
static const double DX_RESULT_NOT_APPLICABLE_DOUBLE = -2000000.0;

#endif
