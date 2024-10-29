Attribute VB_Name = "DXConsts"

'
' This file contains constants used by the DimplX ActiveX.
'

' DimplXCtl.h
Public Const DX_WPO_DISABLE_MATCHING        As Long = 0
Public Const DX_WPO_USE_EXISTING_ENTRIES    As Long = 1
Public Const DX_WPO_FILL_WITH_PREVIOUS      As Long = 2
Public Const DX_WPO_FILL_WITH_COLORS        As Long = 3
Public Const DX_WPO_FILL_WITH_GRAYS         As Long = 4
Public Const DX_WPO_MASK                    As Long = &HFFFF

Public Const DX_WPO_CONVERT_BG_TO_GRAY_NTSC As Long = &H10000
Public Const DX_WPO_CONVERT_BG_TO_GRAY_MAX  As Long = &H20000
Public Const DX_WPO_CONVERT_MASK            As Long = &HFF0000

Public Const DX_WPO_REALIZE_SET_IMAGE       As Long = &H1000000
Public Const DX_WPO_REALIZE_PAINT_IMAGE     As Long = &H2000000
Public Const DX_WPO_NO_REALIZE_SET_PALETTE  As Long = &H4000000
Public Const DX_WPO_REALIZE_MASK            As Long = &HFF000000

Public Const DX_CACHE_PRELUT As Long = &H1
Public Const DX_CACHE_CONVOLVE As Long = &H2
Public Const DX_CACHE_MIRROR_AND_ROTATE As Long = &H4
Public Const DX_CACHE_WINDOWLEVEL As Long = &H8
Public Const DX_CACHE_SCALE As Long = &H10
Public Const DX_CACHE_FULL_UPDATE As Long = &H80000000

Public Const DX_OPTION_CENTER As Long = &H1
Public Const DX_OPTION_ENABLE_DRAG As Long = &H2

Public Const DX_BITMAP_ROTATE As Long = &H1
Public Const DX_BITMAP_NATIVE As Long = &H2

Public Const DX_PALETTE_NOT_PALETTE_DEVICE As Long = 0
Public Const DX_PALETTE_CUSTOM As Long = 1
Public Const DX_PALETTE_GRAYSCALE_128 As Long = 2
Public Const DX_PALETTE_GRAYSCALE_236 As Long = 3
Public Const DX_PALETTE_GRAYSCALE_256 As Long = 4
Public Const DX_PALETTE_PSEUDOCOLOR_2_3_2 As Long = 5
Public Const DX_PALETTE_CREATE As Long = &H80000000

Public Const DX_PALETTEFOCUS_FOLLOW_NONE    As Long = 0
Public Const DX_PALETTEFOCUS_FOLLOW_KBFOCUS As Long = 1

Public Const DX_LUT_PRELUT As Long = &H1
Public Const DX_LUT_WINDOWLEVEL As Long = &H2

Public Const DX_FLATTEN_IMAGE_LAYERS_HIDDEN         As Long = &H1
Public Const DX_FLATTEN_IMAGE_LAYERS_VISIBLE        As Long = &H2
Public Const DX_FLATTEN_IMAGE_LAYERS_BITMAP_HIDDEN  As Long = &H4
Public Const DX_FLATTEN_IMAGE_LAYERS_BITMAP_VISIBLE As Long = &H8
Public Const DX_FLATTEN_IMAGE_LAYERS_ALL            As Long = &HF
Public Const DX_FLATTEN_IMAGE_MASK                  As Long = &HF
Public Const DX_FLATTEN_ANNOTATION_LAYERS_HIDDEN    As Long = &H10
Public Const DX_FLATTEN_ANNOTATION_LAYERS_VISIBLE   As Long = &H20
Public Const DX_FLATTEN_ANNOTATION_LAYERS_ALL       As Long = &HF0
Public Const DX_FLATTEN_ANNOTATION_MASK             As Long = &HF0

Public Const DX_EXPORT_DIB_TOPDOWN  As Long = &H0
Public Const DX_EXPORT_DIB_BOTTOMUP As Long = &H1

Public Const DX_ROTATE_0 As Long = 0
Public Const DX_ROTATE_90 As Long = 1
Public Const DX_ROTATE_180 As Long = 2
Public Const DX_ROTATE_270 As Long = 3

' ImgWndRgn.h
Public Const DX_INTERACTIVE_ENABLED As Long = &H1
Public Const DX_INTERACTIVE_SCALE As Long = &H2
Public Const DX_INTERACTIVE_BITMAP_OVERLAY As Long = &H4
Public Const DX_INTERACTIVE_CONVOLVE As Long = &H8
Public Const DX_INTERACTIVE_REAL_TIME As Long = &H10

Public Const DX_INTERACTIVE_ALL_ENABLED As Long = &HFF
Public Const DX_INTERACTIVE_ALL_STANDBY As Long = &HFE
Public Const DX_INTERACTIVE_ALL_ENABLED_EXCEPT_RT As Long = DX_INTERACTIVE_ALL_ENABLED And Not DX_INTERACTIVE_REAL_TIME
Public Const DX_INTERACTIVE_ALL_STANDBY_EXCEPT_RT As Long = DX_INTERACTIVE_ALL_STANDBY And Not DX_INTERACTIVE_REAL_TIME

Public Const DX_USEROP_BEFORE_PRELUT As Long = 0
Public Const DX_USEROP_BEFORE_CONVOLVE As Long = 1
Public Const DX_USEROP_BEFORE_MIRROR_ROTATE As Long = 2
Public Const DX_USEROP_BEFORE_WINLEV_SCALE As Long = 3
Public Const DX_USEROP_BEFORE_PIPELINE_END As Long = 4
Public Const DX_USEROP_NPOSITIONS As Long = 5  ' not exposed

Public Const DX_USEROP_TYPE_UNCHANGED As Long = -1
Public Const DX_USEROP_NBANDS_UNCHANGED As Long = -1

Public Const DX_USEROP_READ_ONLY As Long = &H1
Public Const DX_USEROP_FORCE_PACKED_RGB As Long = &H2
Public Const DX_USEROP_FORCE_PLANAR_RGB As Long = &H4

Public Const DX_LP_RETURNNONEXISTENT As Long = &H1

Public Const DX_PIPELINE_EXCLUDE_USEROP_BEFORE_PRELUT = &H10
Public Const DX_PIPELINE_EXCLUDE_PRELUT = &H20
Public Const DX_PIPELINE_EXCLUDE_USEROP_BEFORE_CONVOLVE = &H40
Public Const DX_PIPELINE_EXCLUDE_CONVOLVE = &H80
Public Const DX_PIPELINE_EXCLUDE_USEROP_BEFORE_MIRROR_ROTATE = &H100
Public Const DX_PIPELINE_EXCLUDE_MIRROR_ROTATE = &H200
Public Const DX_PIPELINE_EXCLUDE_USEROP_BEFORE_SCALE = &H400
Public Const DX_PIPELINE_EXCLUDE_SCALE = &H800
Public Const DX_PIPELINE_EXCLUDE_WINLEVEL = &H1000
Public Const DX_PIPELINE_EXCLUDE_USEROP_BEFORE_PIPELINE_END = &H2000
Public Const DX_PIPELINE_EXCLUDE_ALL = &H3FF0

Public Const DX_EXECUTEPIPELINE_CLIPPEDANDOFFSET As Long = &H3

' OverlayElement.h
Public Const DX_ELEMENT_LINE As Long = 10
Public Const DX_ELEMENT_RECTANGLE As Long = 11
Public Const DX_ELEMENT_TEXTBOX As Long = 12
Public Const DX_ELEMENT_ELLIPSE As Long = 13
Public Const DX_ELEMENT_POLYGON As Long = 14

Public Const DX_LES_PLAIN As Long = 0
Public Const DX_LES_ARROW_RIGHT As Long = 1
Public Const DX_LES_ARROW_LEFT As Long = 2
Public Const DX_LES_ARROW_BOTH As Long = 3

Public Const DX_LS_SOLID      As Long = 0
Public Const DX_LS_DASH       As Long = 1  ' ------- NT only?
Public Const DX_LS_DOT        As Long = 2  ' ....... NT only?
Public Const DX_LS_DASHDOT    As Long = 3  ' _._._._ NT only?
Public Const DX_LS_DASHDOTDOT As Long = 4  ' _.._.._ NT only?

Public Const DX_FS_NORMAL As Long = &H0
Public Const DX_FS_BOLD As Long = &H1
Public Const DX_FS_ITALIC As Long = &H2
Public Const DX_FS_UNDERLINE As Long = &H4
Public Const DX_FS_STRIKEOUT As Long = &H8

Public Const DX_TEXT_JUSTIFY_LEFT As Long = 0
Public Const DX_TEXT_JUSTIFY_CENTER As Long = 1
Public Const DX_TEXT_JUSTIFY_RIGHT As Long = 2

Public Const DX_COORD_IMAGE As Long = 0
Public Const DX_COORD_WINDOW As Long = 1

Public Const DX_LAYER_LOCK_IMAGEUNLOCKED As Long = 0
Public Const DX_LAYER_LOCK_IMAGELOCKED As Long = 2
Public Const DX_LAYER_LOCK_WINDOWUNLOCKED As Long = 3
Public Const DX_LAYER_LOCK_WINDOWLOCKED As Long = 1

Public Const DX_LAYER_LOCK_UNLOCKED As Long = 0  ' deprecated
Public Const DX_LAYER_LOCK_WINDOW As Long = 1    ' deprecated
Public Const DX_LAYER_LOCK_IMAGE As Long = 2     ' deprecated

Public Const DX_LAYER_NOT_SELECTABLE As Long = 0
Public Const DX_LAYER_SELECTABLE As Long = 1
Public Const DX_LAYER_SELECTABLE_TRANSPARENT As Long = 2

' OverlayLayer.h
Public Const DX_MODE_NORMAL As Long = 0
Public Const DX_MODE_SELECT As Long = 1
Public Const DX_MODE_DELETE As Long = 2
Public Const DX_MODE_ELEMENT_BRING_FRONT As Long = 3
Public Const DX_MODE_ELEMENT_SEND_BACK As Long = 4
Public Const DX_MODE_LAYER_BRING_FRONT As Long = 5
Public Const DX_MODE_LAYER_SEND_BACK As Long = 6
Public Const DX_MODE_ANIMATE_LINE As Long = 7
Public Const DX_MODE_LINE As Long = 10
Public Const DX_MODE_RECTANGLE As Long = 11
Public Const DX_MODE_TEXTBOX As Long = 12
Public Const DX_MODE_ELLIPSE As Long = 13
Public Const DX_MODE_POLYGON As Long = 14

Public Const DX_LAYER_SCALE_OUTLINE As Long = &H1
Public Const DX_LAYER_SCALE_CONTENTS As Long = &H2

Public Const DX_LAYERS_FUTURE             As Long = -1
Public Const DX_LAYERS_CURRENT            As Long = -2
Public Const DX_LAYERS_CURRENT_AND_FUTURE As Long = -3
Public Const DX_LAYERS_NONE               As Long = -3  ' not exposed

Public Const DX_ELEMENTS_FUTURE As Long = -1
Public Const DX_ELEMENTS_CURRENT As Long = -2
Public Const DX_ELEMENTS_CURRENT_AND_FUTURE As Long = -3
Public Const DX_ELEMENTS_SELECTED As Long = -4                ' not supported
Public Const DX_ELEMENTS_SELECTED_AND_FUTURE As Long = -5     ' not supported
Public Const DX_ELEMENTS_SELECTED_ELSE_FUTURE As Long = -6    ' not supported

' Err.Number (DimplXCtl.h)
Public Const DX_SCODE_BUILD_PIPELINE     As Long = 1000
Public Const DX_SCODE_UNUSED_000         As Long = 1001
Public Const DX_SCODE_BAD_DIMPLX_OBJECT  As Long = 1002
Public Const DX_SCODE_BAD_PARAMETER      As Long = 1003
Public Const DX_SCODE_BAD_LAYER_ID       As Long = 1004
Public Const DX_SCODE_BAD_ELEMENT_ID     As Long = 1005
Public Const DX_SCODE_UNUSED_001         As Long = 1006
Public Const DX_SCODE_DIMPL_API          As Long = 1007
Public Const DX_SCODE_INTERNAL_FATAL     As Long = 32766
Public Const DX_SCODE_NYI                As Long = 32767

' return values (DimplXCtl.h)
Public Const DX_ERROR_SUCCESS            As Long = 0
Public Const DX_ERROR_OUT_OF_MEMORY      As Long = -1
Public Const DX_ERROR_BAD_LAYER_ID       As Long = -2
Public Const DX_ERROR_BAD_ELEMENT_ID     As Long = -3
Public Const DX_ERROR_NO_SUCH_ELEMENT    As Long = -4
Public Const DX_ERROR_BAD_COORDINATES    As Long = -5
Public Const DX_ERROR_VARIANT_FORMAT     As Long = -6
Public Const DX_ERROR_BAD_COLOR_FORMAT   As Long = -7
Public Const DX_ERROR_BAD_PIPELINE       As Long = -8
Public Const DX_ERROR_USEROP_POSITION    As Long = -9
Public Const DX_ERROR_BAD_IMAGE          As Long = -10
Public Const DX_ERROR_WRONG_ELEMENT_TYPE As Long = -11
Public Const DX_ERROR_BAD_PARAMETER      As Long = -12
Public Const DX_ERROR_WINDOWS_API        As Long = -13
Public Const DX_ERROR_DIMPL_API          As Long = -14
Public Const DX_ERROR_NO_SUCH_LAYER      As Long = -15

' results (OverlayElement.h)
Public Const DX_RESULT_OK                As Long = 0
Public Const DX_RESULT_INDETERMINATE     As Long = -1
Public Const DX_RESULT_NOT_APPLICABLE    As Long = -2

Public Const DX_RESULT_INDETERMINATE_DOUBLE  As Double = -1000000#
Public Const DX_RESULT_NOT_APPLICABLE_DOUBLE As Double = -2000000#

