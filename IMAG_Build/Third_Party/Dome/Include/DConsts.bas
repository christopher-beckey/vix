Attribute VB_Name = "DConsts"

'
' This file contains constants used by the DimplX and DimFileX ActiveXs.
'

' Dimpl constants from dimpl.h
Public Const D_DIMPL_H = 1
Public Const D_MAJOR_VERSION = 8
Public Const D_MINOR_VERSION = 0
Public Const D_TYPE_BYTE = 0
Public Const D_TYPE_USHORT = 1
Public Const D_TYPE_LONG = 2
Public Const D_TYPE_FLOAT = 3
Public Const D_COMPRESSION_NONE = 0
Public Const D_MAX_BANDS = 4
Public Const D_MAX_NAME_CHARS = 16
Public Const D_BYTE_ORDER_MSB_FIRST = 0
Public Const D_BYTE_ORDER_LSB_FIRST = 1
Public Const D_BYTE_ORDER_HOST = 2
Public Const D_DEVICE_HOST = 2 ^ 0
Public Const D_DEVICE_DISPLAY = 2 ^ 1
Public Const D_DEVICE_DEFAULT_DISPLAY = 2 ^ 2
Public Const D_DEVICE_IMAGES = 2 ^ 3
Public Const D_DEVICE_ESCAPE = 2 ^ 4
Public Const D_DEVICE_RT = 2 ^ 5
Public Const D_PIPELINE_EMPTY = 0
Public Const D_PIPELINE_FORMING = 1
Public Const D_PIPELINE_COMPLETE = 2
Public Const D_PIPELINE_EXECUTABLE = 3
Public Const D_PIPELINE_EXECUTING = 4
Public Const D_MAP_LINEAR_CLAMP = 0
Public Const D_MAP_LINEAR_CLAMP_3_MASK = 1
Public Const D_SCALE_NEAREST = 0
Public Const D_SCALE_AREA = 1
Public Const D_SCALE_FAST_AREA = 2
Public Const D_SCALE_FAST = 3
Public Const D_SCALE_BICUBIC = 4
Public Const D_SCALE_BILINEAR = 5
Public Const D_LOG_DISABLED = 0
Public Const D_LOG_ERRORS = 2
Public Const D_LOG_INFO = 4
Public Const D_CREATE_SESSION_LOG_ERRORS = 2 ^ 0
Public Const D_CREATE_SESSION_LOG_INFO = 2 ^ 1
Public Const D_CREATE_SESSION_DISABLE_USER_LOG = 2 ^ 2
Public Const D_OP_OPEN_LOG_FILE = 1
Public Const D_OP_WRITE_ERROR_STRING = 2
Public Const D_OP_WRITE_INFO_STRING = 3
Public Const D_OP_SET_LOG_MODE = 4
Public Const D_OP_GET_LOG_MODE = 5
Public Const D_OP_GET_LOG_STATE = 6
Public Const D_OP_ENABLE_RT = 7
Public Const D_OP_DISABLE_RT = 8
Public Const D_OP_GET_ENABLE_RT = 9
Public Const D_OP_ENABLE_PIPELINE_RT = 10
Public Const D_OP_DISABLE_PIPELINE_RT = 11
Public Const D_OP_ENABLE_DVA = 12
Public Const D_OP_DISABLE_DVA = 13
Public Const D_OP_GET_ENABLE_DVA = 14
Public Const D_KERNEL_ABS = 2 ^ 0
Public Const D_KERNEL_CLAMP = 2 ^ 1
Public Const D_CONVOLVE_REPLICATE = 0
Public Const D_CONVOLVE_CONSTANT = 1
Public Const D_KERNEL_SHARPEN_1 = 1
Public Const D_KERNEL_SHARPEN_2 = 2
Public Const D_KERNEL_SHARPEN_3 = 3
Public Const D_KERNEL_SHARPEN_4 = 4
Public Const D_KERNEL_SHARPEN_5 = 5
Public Const D_KERNEL_SMOOTH_1 = 21
Public Const D_KERNEL_SMOOTH_2 = 22
Public Const D_KERNEL_SMOOTH_3 = 23
Public Const D_KERNEL_SMOOTH_4 = 24
Public Const D_KERNEL_SMOOTH_5 = 25
Public Const D_KERNEL_SMOOTH_6 = 26
Public Const D_KERNEL_SMOOTH_7 = 27
Public Const D_KERNEL_SMOOTH_8 = 28
Public Const D_KERNEL_SMOOTH_3_FAST = 43
Public Const D_KERNEL_SMOOTH_4_FAST = 44
Public Const D_KERNEL_SMOOTH_6_FAST = 46
Public Const D_KERNEL_SMOOTH_7_FAST = 47
Public Const D_KERNEL_SMOOTH_8_FAST = 48
Public Const D_HISTOGRAM_CUMULATIVE = 2 ^ 0
Public Const D_WINDOW_BYTE = 0
Public Const D_WINDOW_SHORT = 1
Public Const D_WINDOW_LONG = 2
Public Const D_WINDOW_3_BYTE = 3
Public Const D_BANDMASK_ALL = 15
Public Const D_RED = 0
Public Const D_GREEN = 1
Public Const D_BLUE = 2
Public Const D_IMEXPORT_PLANAR = 2 ^ 0
Public Const D_IMEXPORT_SWAP_02 = 2 ^ 1
Public Const D_PIPELINE_OP_ENABLE_RT = 1
Public Const D_PIPELINE_OP_DISABLE_RT = 2
Public Const D_PIPELINE_OP_SET_STRIP_SIZE = 3
Public Const D_PIPELINE_OP_GET_STRIP_SIZE = 4
Public Const D_SPACE_GRAY = 0
Public Const D_SPACE_RGB = 1
Public Const D_SPACE_PALETTE = 2
Public Const D_SPACE_YCBCR = 3
Public Const D_GRAY_INVERTED = 2 ^ 0

' DIMPL file constants from dfile.h
Public Const DF_OPEN_READ = 0
Public Const DF_OPEN_WRITE = 1

Public Const DF_OPEN_NO_REPLACE = 2 ^ 0

' DIMPL DICOM constants from dfdicom.h
Public Const DFD_TS_BE = 2 ^ 0        ' is Big Endian; else Little
Public Const DFD_TS_VR = 2 ^ 1        ' has Explicit VRs; else Implicit

Public Const DFD_TS_IMPLICIT_VR_LE = 0
Public Const DFD_TS_EXPLICIT_VR_LE = DFD_TS_VR
Public Const DFD_TS_EXPLICIT_VR_BE = DFD_TS_VR Or DFD_TS_BE

Public Const DFD_IS_PART_10 = 2 ^ 0              ' is Part 10 file; else "raw" DICOM
Public Const DFD_GROUP_2_NON_HOST = 2 ^ 1        ' data in group 2 is non-host byte order
Public Const DFD_OTHER_NON_HOST = 2 ^ 2          ' data in other groups is non-host byte order

' DIMPL codec constants from dcodec.h
Public Const D_COMP_NONE = 0
Public Const D_COMP_JPEG = 2 ^ 16
Public Const D_COMP_JPEG_LL = 2 * 2 ^ 16
Public Const D_COMP_JPEG_LL_HIER = 3 * 2 ^ 16
Public Const D_COMP_JPEG_12_BIT = 2 ^ 7
Public Const D_COMP_JPEG_PROG = 5 ^ 16

Public Const D_COMP_JPEG_MAX_QUALITY = 100
Public Const D_COMP_JPEG_QUALITY_MASK = 2 ^ 7 - 1

Public Const D_COMP_JPEG_LL_HIER_MAX_FRAMES = 31
Public Const D_COMP_JPEG_LL_HIER_FRAMES_MASK = 2 ^ 5 - 1
