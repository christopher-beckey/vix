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
#ifndef _DCONSTS_H
#define _DCONSTS_H

//
// This file contains constants used by the DimplX and DimFileX ActiveXs.
//

// DOME typedefs from dometype.h
typedef char           DChar;
typedef unsigned char  DByte;
typedef short          DShort;
typedef unsigned short DUShort;
typedef long           DLong;
typedef unsigned long  DULong;
typedef long           DBool;
typedef void           DVoid;
typedef float          DFloat;
typedef double         DDouble;

// Dimpl constants from dimpl.h
#define D_DIMPL_H 1
#define D_MAJOR_VERSION             8
#define D_MINOR_VERSION             0
#define D_TYPE_BYTE                 0
#define D_TYPE_USHORT               1
#define D_TYPE_LONG                 2
#define D_TYPE_FLOAT                3
#define D_COMPRESSION_NONE          0
#define D_MAX_BANDS                 4
#define D_MAX_NAME_CHARS            16
#define D_BYTE_ORDER_MSB_FIRST      0
#define D_BYTE_ORDER_LSB_FIRST      1
#define D_BYTE_ORDER_HOST           2
#define D_DEVICE_HOST               (1<<0)
#define D_DEVICE_DISPLAY            (1<<1)
#define D_DEVICE_DEFAULT_DISPLAY    (1<<2)
#define D_DEVICE_IMAGES             (1<<3)
#define D_DEVICE_ESCAPE             (1<<4)
#define D_DEVICE_RT                 (1<<5)
#define D_PIPELINE_EMPTY            0
#define D_PIPELINE_FORMING          1
#define D_PIPELINE_COMPLETE         2
#define D_PIPELINE_EXECUTABLE       3
#define D_PIPELINE_EXECUTING        4
#define D_MAP_LINEAR_CLAMP          0
#define D_MAP_LINEAR_CLAMP_3_MASK   1
#define D_SCALE_NEAREST             0
#define D_SCALE_AREA                1
#define D_SCALE_FAST_AREA           2
#define D_SCALE_FAST                3
#define D_SCALE_BICUBIC             4
#define D_SCALE_BILINEAR            5
#define D_LOG_DISABLED              0
#define D_LOG_ERRORS                2
#define D_LOG_INFO                  4
#define D_CREATE_SESSION_LOG_ERRORS          (1 << 0)
#define D_CREATE_SESSION_LOG_INFO            (1 << 1)
#define D_CREATE_SESSION_DISABLE_USER_LOG    (1 << 2)
#define D_OP_OPEN_LOG_FILE          1
#define D_OP_WRITE_ERROR_STRING     2
#define D_OP_WRITE_INFO_STRING      3
#define D_OP_SET_LOG_MODE           4
#define D_OP_GET_LOG_MODE           5
#define D_OP_GET_LOG_STATE          6
#define D_OP_ENABLE_RT              7
#define D_OP_DISABLE_RT             8
#define D_OP_GET_ENABLE_RT          9
#define D_OP_ENABLE_PIPELINE_RT     10
#define D_OP_DISABLE_PIPELINE_RT    11
#define D_OP_ENABLE_DVA             12
#define D_OP_DISABLE_DVA            13
#define D_OP_GET_ENABLE_DVA         14
#define D_KERNEL_ABS                (1 << 0)
#define D_KERNEL_CLAMP              (1 << 1)
#define D_CONVOLVE_REPLICATE        0
#define D_CONVOLVE_CONSTANT         1
#define D_KERNEL_SHARPEN_1          1
#define D_KERNEL_SHARPEN_2          2
#define D_KERNEL_SHARPEN_3          3
#define D_KERNEL_SHARPEN_4          4
#define D_KERNEL_SHARPEN_5          5
#define D_KERNEL_SMOOTH_1          21
#define D_KERNEL_SMOOTH_2          22
#define D_KERNEL_SMOOTH_3          23
#define D_KERNEL_SMOOTH_4          24
#define D_KERNEL_SMOOTH_5          25
#define D_KERNEL_SMOOTH_6          26
#define D_KERNEL_SMOOTH_7          27
#define D_KERNEL_SMOOTH_8          28
#define D_KERNEL_SMOOTH_3_FAST     43
#define D_KERNEL_SMOOTH_4_FAST     44
#define D_KERNEL_SMOOTH_6_FAST     46
#define D_KERNEL_SMOOTH_7_FAST     47
#define D_KERNEL_SMOOTH_8_FAST     48
#define D_HISTOGRAM_CUMULATIVE     (1 << 0)
#define D_WINDOW_BYTE               0
#define D_WINDOW_SHORT              1
#define D_WINDOW_LONG               2
#define D_WINDOW_3_BYTE             3
#define D_BANDMASK_ALL              15
#define D_RED                       0
#define D_GREEN                     1
#define D_BLUE                      2
#define D_IMEXPORT_PLANAR           (1<<0)
#define D_IMEXPORT_SWAP_02          (1<<1)
#define D_PIPELINE_OP_ENABLE_RT          1
#define D_PIPELINE_OP_DISABLE_RT         2
#define D_PIPELINE_OP_SET_STRIP_SIZE     3
#define D_PIPELINE_OP_GET_STRIP_SIZE     4
#define D_SPACE_GRAY                     0
#define D_SPACE_RGB                      1
#define D_SPACE_PALETTE                  2
#define D_SPACE_YCBCR                    3
#define D_GRAY_INVERTED                  (1 << 0)

// DIMPL file constants from dfile.h
#define DF_OPEN_READ                0
#define DF_OPEN_WRITE               1

#define DF_OPEN_NO_REPLACE          (1<<0)

// DIMPL DICOM constants from dfdicom.h
#define DFD_TS_BE            (1<<0)        /* is Big Endian; else Little */
#define DFD_TS_VR            (1<<1)        /* has Explicit VRs; else Implicit */

#define DFD_TS_IMPLICIT_VR_LE   0
#define DFD_TS_EXPLICIT_VR_LE   DFD_TS_VR
#define DFD_TS_EXPLICIT_VR_BE   (DFD_TS_VR | DFD_TS_BE)

#define DFD_IS_PART_10       (1<<0)        /* is Part 10 file; else "raw" DICOM */
#define DFD_GROUP_2_NON_HOST (1<<1)        /* data in group 2 is non-host byte order */
#define DFD_OTHER_NON_HOST   (1<<2)        /* data in other groups is non-host byte order */

// DIMPL codec constants from dcodec.h
#define D_COMP_NONE                 0
#define D_COMP_JPEG                 (1 << 16)
#define D_COMP_JPEG_LL              (2 << 16)
#define D_COMP_JPEG_LL_HIER         (3 << 16)
#define D_COMP_JPEG_PROG            (5 << 16)
#define D_COMP_JPEG_12_BIT          (1 << 7)

#define D_COMP_JPEG_MAX_QUALITY     100
#define D_COMP_JPEG_QUALITY_MASK    ((1 << 7) - 1)

#define D_COMP_JPEG_LL_HIER_MAX_FRAMES     31
#define D_COMP_JPEG_LL_HIER_FRAMES_MASK    ((1 << 5) - 1)

#endif
