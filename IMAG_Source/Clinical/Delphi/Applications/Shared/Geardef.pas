Unit Geardef;
Interface

{ Copyright (c) 1996-98, AccuSoft Corporation.  All rights reserved.}

{*************************************************************************}
Uses Dialogs;

{Constants for user defined types}
{Convolution}
Const
  IG_MAX_KERN_HEIGHT = 16;
Const
  IG_MAX_KERN_WIDTH = 16;
{Fonts}
Const
  LF_FACESIZE = 32;

Const
  SB_HORZ = 0;
Const
  SB_VERT = 1;

{
 Scroll Bar Commands
}
Const
  SB_LINEUP = 0;
Const
  SB_LINELEFT = 0;
Const
  SB_LINEDOWN = 1;
Const
  SB_LINERIGHT = 1;
Const
  SB_PAGEUP = 2;
Const
  SB_PAGELEFT = 2;
Const
  SB_PAGEDOWN = 3;
Const
  SB_PAGERIGHT = 3;
Const
  SB_THUMBPOSITION = 4;
Const
  SB_THUMBTRACK = 5;
Const
  SB_TOP = 6;
Const
  SB_LEFT = 6;
Const
  SB_BOTTOM = 7;
Const
  SB_RIGHT = 7;
Const
  SB_ENDSCROLL = 8;

{ raster post processing constants }
Const
  POST_PROCESS_ABIC_GREY_LUT = 1;
Const
  POST_PROCESS_INVERT_BITONAL_RASTER = 2;

{ alpha channel  constants}
Const
  IG_ALPHA_CREATE_1 = 0;
Const
  IG_ALPHA_CREATE_8 = 1;

Const
  IG_BLEND_OVER = 0;
Const
  IG_BLEND_IN = 1;
Const
  IG_BLEND_HELD_OUT = 2;
Const
  IG_BLEND_LINEAR = 3;

{ scan capabilities constants }
Const
  IG_SCAN_CAP_PIXELTYPE = 0;

Const
  IG_SCAN_CAP_XREFCOUNT = 1;
Const
  IG_SCAN_CAP_XFERCOUNT = 1;

Const
  IG_SCAN_CAP_PIXELFLAVOR = 2;
Const
  IG_SCAN_CAP_CONTRAST = 3;
Const
  IG_SCAN_CAP_BRIGHTNESS = 4;
Const
  IG_SCAN_CAP_XRES = 5;
Const
  IG_SCAN_CAP_YRES = 6;
Const
  IG_SCAN_CAP_BITSPERPIX = 7;
Const
  IG_SCAN_CAP_LAYOUT_LEFT = 8;
Const
  IG_SCAN_CAP_LAYOUT_RIGHT = 9;
Const
  IG_SCAN_CAP_LAYOUT_TOP = 10;
Const
  IG_SCAN_CAP_LAYOUT_BOTTOM = 11;

{ some pseudo-caps }
Const
  IG_SCAN_CONTROL_PAPER_SOURCE = 12 { see constants below IG_SCAN_PAPER_ };
Const
  IG_SCAN_CONTROL_FILE_APPEND = 13 { BOOL, default FALSE };
Const
  IG_SCAN_CONTROL_DISABLE_DISPLAY = 14 { BOOL, default FALSE };
Const
  IG_SCAN_CONTROL_SAVE_PAGES_SEPARATELY = 15 { BOOL, default FALSE };
Const
  IG_SCAN_CONTROL_SCAN_PAGES_MODELESS = 16 { BOOL, default FALSE };

Const
  IG_SCAN_CONTROL_APP_NAME = $0011;

Const
  IG_PIXEL_TYPE_BW = 0;
Const
  IG_PIXEL_TYPE_GRAY = 1;
Const
  IG_PIXEL_TYPE_RGB = 2;
Const
  IG_PIXEL_TYPE_PALETTE = 3;

Const
  IG_SCAN_PF_CHOCOLATE = 0;
Const
  IG_SCAN_PF_VANILLA = 1;

Const
  IG_SCAN_PAPER_AUTO = 0 { default };
Const
  IG_SCAN_PAPER_FLATBED = 1;
Const
  IG_SCAN_PAPER_ADF = 2;

{ bitmapped color components  }
Const
  IG_COLOR_COMP_R = $0001;
Const
  IG_COLOR_COMP_G = $0002;
Const
  IG_COLOR_COMP_B = $0004;
Const
  IG_COLOR_COMP_RGB = (IG_COLOR_COMP_R + IG_COLOR_COMP_G + IG_COLOR_COMP_B);
Const
  IG_COLOR_COMP_I = $0010 { used when the ave of RGB is to be used};

{ values for nAspectMethod parameter of IG_display_adjust_aspect }
Const
  IG_ASPECT_NONE = 0;
Const
  IG_ASPECT_DEFAULT = 1;
Const
  IG_ASPECT_HORIZONTAL = 2;
Const
  IG_ASPECT_VERTICAL = 3;
Const
  IG_ASPECT_MAXDIMENSION = 4;
Const
  IG_ASPECT_MINDIMENSION = 1;

{ values for altering the contrast of an image }
Const
  IG_CONTRAST_PALETTE = 0 { Alter the palette only  };
Const
  IG_CONTRAST_PIXEL = 1 { Alter the pixel values  };

{ values for nFitMethod parameter of IG_display_fit_method }
Const
  IG_DISPLAY_FIT_TO_WINDOW = 0;
Const
  IG_DISPLAY_FIT_TO_WIDTH = 1;
Const
  IG_DISPLAY_FIT_TO_HEIGHT = 2;
Const
  IG_DISPLAY_FIT_1_TO_1 = 3;

{ values for nPriority parameter of IG_display_handle_palette }
Const
  IG_PALETTE_PRIORITY_DEFAULT = 0;
Const
  IG_PALETTE_PRIORITY_HIGH = 1;
Const
  IG_PALETTE_PRIORITY_LOW = 2;
Const
  IG_PALETTE_PRIORITY_DISABLE = 3;
Const
  IG_PALETTE_PRIORITY_NOREALIZE = 4 { Same as IG_PALETTE_PRIORITY_DISABLE, };
          { except the logical palette is  }
          { selected into the DC. }

{ values for nDitherMode parameter of IG_display_dither_mode_set }
Const
  IG_DITHER_MODE_DEFAULT = 0;
Const
  IG_DITHER_MODE_NONE = 1;
Const
  IG_DITHER_MODE_BAYER = 2;

{ values for direction parameter of IG_IP_flip function }
Const
  IG_FLIP_HORIZONTAL = 0;
Const
  IG_FLIP_VERTICAL = 1;

Const
  IG_SHEAR_HORIZONTAL = 0;
Const
  IG_SHEAR_VERTICAL = 1;

Const
  IG_LOADDOC_DISPLAY_FIRST = 0;
Const
  IG_LOADDOC_DISPLAY_ALL = 1;

{ values for IG_IP_rotate_ function}
Const
  IG_ROTATE_CLIP = 0;
Const
  IG_ROTATE_EXPAND = 1;

Const
  IG_ROTATE_0 = 0;
Const
  IG_ROTATE_90 = 1;
Const
  IG_ROTATE_180 = 2;
Const
  IG_ROTATE_270 = 3;

{ values for PROMOTE function}
Const
  IG_PROMOTE_TO_4 = 1;
Const
  IG_PROMOTE_TO_8 = 2;
Const
  IG_PROMOTE_TO_24 = 3;

{ General purpose compass directions  }
Const
  IG_COMPASS_N = 1;
Const
  IG_COMPASS_NE = 2;
Const
  IG_COMPASS_E = 3;
Const
  IG_COMPASS_SE = 4;
Const
  IG_COMPASS_S = 5;
Const
  IG_COMPASS_SW = 6;
Const
  IG_COMPASS_W = 7;
Const
  IG_COMPASS_NW = 8;

{ IG_load_color()}
Const
  IG_LOAD_COLOR_DEFAULT = 0;
Const
  IG_LOAD_COLOR_1 = 1;
Const
  IG_LOAD_COLOR_4 = 2;
Const
  IG_LOAD_COLOR_8 = 3;
Const
  IG_LOAD_GRAYSCALE_8 = 4;

{ IG_palette_save() }
Const
  IG_PALETTE_FORMAT_INVALID = 0 { returned when file could not be read};
Const
  IG_PALETTE_FORMAT_RAW_BGR = 1 { This is the raw DIB format BGR};
Const
  IG_PALETTE_FORMAT_RAW_BGRQ = 2 { This is the raw DIB format BGRQ};
Const
  IG_PALETTE_FORMAT_RAW_RGB = 3 { This is the raw DIB format RGB};
Const
  IG_PALETTE_FORMAT_RAW_RGBQ = 4 { This is the raw DIB format RGBQ };
Const
  IG_PALETTE_FORMAT_TEXT = 5 { ASCII text file (details in manual) };
Const
  IG_PALETTE_FORMAT_HALO_CUT = 6 { Dr Halo .PAL file for use with a .CUT  };

{ IG_FX_twist()  type parameter }
Const
  IG_TWIST_90 = 1;
Const
  IG_TWIST_180 = 2;
Const
  IG_TWIST_270 = 3;
Const
  IG_TWIST_RANDOM = 4;

{ values for nAliasType parameter of IG_display_alias_set()}
Const
  IG_DISPLAY_ALIAS_NONE = 0;
Const
  IG_DISPLAY_ALIAS_PRESERVE_BLACK = 1;
Const
  IG_DISPLAY_ALIAS_SCALE_TO_GRAY = 2;
Const
  IG_DISPLAY_ALIAS_PRESERVE_BLACK_SUB = 3;
Const
  IG_DISPLAY_ALIAS_SCALE_TO_GRAY_SUB = 4;

{ values for nOption parameter of IG_display_option_set()}
Const
  IG_DISPLAY_OPTION_DOWNSHIFT = 1;
Const
  IG_DISPLAY_OPTION_LUT = 2;
Const
  IG_ORIENTATION_SUPPORT = 3;
Const
  IG_PRINT_ADJUST = 4;
Const
  IG_DISPLAY_OPTION_USEMAPMODE = 5;
Const
  IG_DISPLAY_OPTION_DDB_OPTIMIZE = 6;
{#ifdef WIN32}
Const
  IG_DISPLAY_OPTION_OFFSCREEN_DRAW = 7;
{#endif}

{ types of edge maps}
Const
  IG_EDGE_OP_PREWITT = 1;
Const
  IG_EDGE_OP_ROBERTS = 2;
Const
  IG_EDGE_OP_SOBEL = 3;
Const
  IG_EDGE_OP_LAPLACIAN = 4;
Const
  IG_EDGE_OP_HORIZONTAL = 5;
Const
  IG_EDGE_OP_VERTICAL = 6;
Const
  IG_EDGE_OP_DIAG_POS_45 = 7;
Const
  IG_EDGE_OP_DIAG_NEG_45 = 8;

{ Types of structuring Elements and Convolution kernels }
{const IG_MAX_KERN_HEIGHT= 16;
const IG_MAX_KERN_WIDTH=  16; }

{ Types of convolution data output formats   }
Const
  IG_CONV_RESULT_RAW = 0;
Const
  IG_CONV_RESULT_ABS = 1;
Const
  IG_CONV_RESULT_8BIT_SIGNED = 2;
Const
  IG_CONV_RESULT_SIGN_CENTERED = 3;

{ Types of 24 bit convolution data inputs}
Const
  IG_CONV_24_INTENSITY = 0;
Const
  IG_CONV_24_RGB = 1;
Const
  IG_CONV_24_R = 2;
Const
  IG_CONV_24_G = 3;
Const
  IG_CONV_24_B = 4;

{ values for nFillOrder parameter of IG_load_CCITT_FD() }
Const
  IG_FILL_MSB = 1;
Const
  IG_FILL_LSB = 2;

{ IG_IP_arithmetic, IG_IP_arithmetic_rect, and IG_clipboard_paste_op_get/set() }
Const
  IG_ARITH_ADD = 1 { Add Img1=Img1 + Img2};
Const
  IG_ARITH_SUB = 2 { Sub Img1 = Img1 - Img2};
Const
  IG_ARITH_MULTI = 3 { Multi Img1 =  Img1 * Img2 };
Const
  IG_ARITH_DIVIDE = 4 { DivImg1  Img1 / Img2 };
Const
  IG_ARITH_AND = 5 { AND=Img1 = Img1 & Img2};
Const
  IG_ARITH_OR = 6 { OR Img1 = Img1 + Img2};
Const
  IG_ARITH_XOR = 7 { XOR=Img1 =  Img1 ^ Img2};
Const
  IG_ARITH_ADD_SIGN_CENTERED = 8 { NOT Img1  =Img1 + SC_Img2};
Const
  IG_ARITH_NOT = 9 { NOT Img1 = ~Img1};
Const
  IG_ARITH_OVER = 10 { NOT Img1 = Img2 };

{ Types of image blending modes  }
Const
  IG_BLEND_ON_INTENSITY = 0;
Const
  IG_BLEND_ON_IMAGE = 1;
Const
  IG_BLEND_ON_HUE = 2;

{ Encryption mode}
Const
  IG_ENCRYPT_METHOD_A = 0 { Method A };
Const
  IG_ENCRYPT_METHOD_B = 1 { Method B };
Const
  IG_ENCRYPT_METHOD_C = 2 { Method C };

{ Color spaces}
Const
  IG_COLOR_SPACE_RGB = 0 { RGB };
Const
  IG_COLOR_SPACE_I = 1 { Intensity };
Const
  IG_COLOR_SPACE_IHS = 2 { IHS };
Const
  IG_COLOR_SPACE_HSL = 3 { HSL };
Const
  IG_COLOR_SPACE_Lab = 4 { Lab };
Const
  IG_COLOR_SPACE_YIQ = 5 { YIQ };
Const
  IG_COLOR_SPACE_CMY = 6 { CMY };
Const
  IG_COLOR_SPACE_CMYK = 7 { CMYK   };
Const
  IG_COLOR_SPACE_YCrCb = 8 { YCrCb  };
Const
  IG_COLOR_SPACE_YUV = 9 { YUV };

{ the following constants are used with the FlashPix }
Const
  IG_COLOR_SPACE_MONO = 10 { 8bit grayscale };
Const
  IG_COLOR_SPACE_ALPHA = 11 { 8bit alpha };
Const
  IG_COLOR_SPACE_MA = 12 { 16bit: mono + alpha };
Const
  IG_COLOR_SPACE_AM = 13 { 16bit: alpha + mono };
Const
  IG_COLOR_SPACE_RGBA = 14 { 32bit: RGB + alpha };
Const
  IG_COLOR_SPACE_ARGB = 15 { 32bit: alpha + RGB };
Const
  IG_COLOR_SPACE_YCC = 16 { 24bit: PhotoYCC };
Const
  IG_COLOR_SPACE_YCCA = 17 { 32bit: PhotoYCC + alpha};
Const
  IG_COLOR_SPACE_AYCC = 18 { 32bit: alpha + PhotoYCC};
Const
  IG_COLOR_SPACE_UNKNOWN = 19 { unknown or invalid colorspace};
Const
  IG_COLOR_SPACE_NOCHANGE = 20 { use current colorspace};

{ IG_FX_pixelate }
Const
  IG_PIXELATE_CENTER = 0 { Sample center of each block};
Const
  IG_PIXELATE_AVERAGE = 1 { Compute the average of each block};

{ nWipeStyle of IG_display_image_wipe()  }
Const
  IG_WIPE_LEFTTORIGHT = 0 { left edge to right edge };
Const
  IG_WIPE_RIGHTTOLEFT = 1 { right edge to left edge };
Const
  IG_WIPE_UP_TO_DOWN = 22 { upper edge to lower edge };
Const
  IG_WIPE_DOWN_TO_UP = 23 { lower edge to upper edge };
Const
  IG_WIPE_SPARKLE = 2 { replace random regions  };
Const
  IG_WIPE_ULTOLRDIAG = 3 { upper left to lower right  };
Const
  IG_WIPE_LRTOULDIAG = 24 { upper left to lower right  };
Const
  IG_WIPE_URTOLLDIAG = 25 { upper left to lower right  };
Const
  IG_WIPE_LLTOURDIAG = 26 { upper left to lower right  };
Const
  IG_WIPE_CLOCK = 4;
Const
  IG_WIPE_SPARKLE_CLOCK = 5;
Const
  IG_WIPE_DOUBLE_CLOCK = 6;
Const
  IG_WIPE_SLIDE_RIGHT = 7;
Const
  IG_WIPE_SLIDE_LEFT = 8;
Const
  IG_WIPE_SLIDE_UP = 27;
Const
  IG_WIPE_SLIDE_DOWN = 28;
Const
  IG_WIPE_RANDOM_BARS_DOWN = 9;
Const
  IG_WIPE_RAIN = 10;
Const
  IG_WIPE_BOOK = 11;
Const
  IG_WIPE_ROLL = 12;
Const
  IG_WIPE_UNROLL = 13;
Const
  IG_WIPE_EXPAND_PROPORTIONAL = 14;
Const
  IG_WIPE_EXPAND_HORIZONTAL = 15;
Const
  IG_WIPE_EXPAND_VERTICAL = 16;
Const
  IG_WIPE_STRIPS_HORIZONTAL = 17;
Const
  IG_WIPE_STRIPS_VERTICAL = 18;
Const
  IG_WIPE_CELLS = 19;
Const
  IG_WIPE_BALL = 20;
Const
  IG_WIPE_GEARS = 21;

{ Data types for use with tag callbacks  }
Const
  IG_TAG_TYPE_NULL = 0 {no data -- end of tags};
Const
  IG_TAG_TYPE_BYTE = 1 {data is a 8 bit unsigned int};
Const
  IG_TAG_TYPE_ASCII = 2 {data is a 8 bit, NULL-term String};
Const
  IG_TAG_TYPE_SHORT = 3 {data is a 16 bit, unsigned int  };
Const
  IG_TAG_TYPE_LONG = 4 {data is a 32 bit, unsigned int };
Const
  IG_TAG_TYPE_RATIONAL = 5 {data is a two 32-bit unsigned integers  };
Const
  IG_TAG_TYPE_SBYTE = 6 {data is a 8 bit signed int  };
Const
  IG_TAG_TYPE_UNDEFINED = 7 {data is a 8 bit byte };
Const
  IG_TAG_TYPE_SSHORT = 8 {data is a 16-bit signed int };
Const
  IG_TAG_TYPE_SLONG = 9 {data is a 32-bit signed int };
Const
  IG_TAG_TYPE_SRATIONAL = 10 {data is a two 32-bit signed int};
Const
  IG_TAG_TYPE_FLOAT = 11 {data is a 4-byte single-prec IEEE floating point };
Const
  IG_TAG_TYPE_DOUBLE = 12 {data is a 8-byte double-prec IEEE floating point };
Const
  IG_TAG_TYPE_RAWBYTES = 13 {data is a series of raw data bytes};
Const
  IG_TAG_TYPE_LONGARRAY = 14 {data is an array of 32-bit signed ints  };
Const
  IG_TAG_TYPE_UNICODE = 15 {data is a UNICODE string, 16 bit WCHARs term. by two NULLs };
Const
  IG_TAG_TYPE_FILETIME = 16 {data is a 64 bit FILETIME structure};
Const
  IG_TAG_TYPE_DATE = 17 {data is a 64 bit DATE structure };

{ FX Blur constants }
Const
  IG_BLUR_3 = 1 { Blurs using a 3x3 kernel};
Const
  IG_BLUR_5 = 2 { Blurs using a 5x5 kernel};

{ FX resample constants}
Const
  IG_RESAMPLE_IN_AVE = 0;
Const
  IG_RESAMPLE_IN_MIN = 1;
Const
  IG_RESAMPLE_IN_MAX = 2;
Const
  IG_RESAMPLE_IN_CENTER = 3;
Const
  IG_RESAMPLE_OUT_SQUARE = 0;
Const
  IG_RESAMPLE_OUT_CIRCLE = 1;

{ FX noise constants}
Const
  IG_NOISE_LINEAR = 0;
Const
  IG_NOISE_GAUSSIAN = 1;

{ Multi Page Append image flag  }
Const
  IG_APPEND_PAGE = 0;

{ Draw Contrast Ramp Constants  }
Const
  IG_RAMP_HORIZONTAL = 0;
Const
  IG_RAMP_VERTICAL = 1;
Const
  IG_RAMP_PYRAMID = 2;
Const
  IG_RAMP_FORWARD = 0;
Const
  IG_RAMP_REVERSE = 1;

{ nPrintSize parameter of IG_print_page()}
Const
  IG_PRINT_FULL_PAGE = 0;
Const
  IG_PRINT_THREE_QUARTER_PAGE = 1;
Const
  IG_PRINT_HALF_PAGE = 2;
Const
  IG_PRINT_QUARTER_PAGE = 3;
Const
  IG_PRINT_EIGHTH_PAGE = 4;
Const
  IG_PRINT_SIXTEENTH_PAGE = 5;
Const
  IG_PRINT_CUSTOM = 6;

{ nHorzPos and nVertPos parameters of IG_print_page()}
Const
  IG_PRINT_ALIGN_LEFT = 0;
Const
  IG_PRINT_ALIGN_TOP = 0;
Const
  IG_PRINT_ALIGN_CENTER = 1;
Const
  IG_PRINT_ALIGN_RIGHT = 2;
Const
  IG_PRINT_ALIGN_BOTTOM = 2;

{ nAttributeID parameter of IG_GUI_window_attribute_set()  }
Const
  IG_GUI_WINDOW_PAINT = 0;
Const
  IG_GUI_WINDOW_HANDLE_RESIZE = 1;
Const
  IG_GUI_WINDOW_IMAGE_ADD = 2;
Const
  IG_GUI_WINDOW_IMAGE_REMOVE = 3;
Const
  IG_GUI_WINDOW_ZOOM_KEYS = 4;
Const
  IG_GUI_WINDOW_ART_DISABLE = 5;

{ nAttributeID parameter of IG_GUI_thumbnail_attribute_set()  }
Const
  IG_GUI_THUMBNAIL_WIDTH = 0;
Const
  IG_GUI_THUMBNAIL_HEIGHT = 1;
Const
  IG_GUI_THUMBNAIL_SHOW_TITLE = 2;
Const
  IG_GUI_THUMBNAIL_X_SPACING = 3;
Const
  IG_GUI_THUMBNAIL_Y_SPACING = 4;
Const
  IG_GUI_THUMBNAIL_SHOW_FLAT = 5;
Const
  IG_GUI_THUMBNAIL_BORDER_WIDTH = 6;
Const
  IG_GUI_THUMBNAIL_SHADOW_WIDTH = 7;
Const
  IG_GUI_THUMBNAIL_ZOOM_FACTOR = 8;
Const
  IG_GUI_THUMBNAIL_INTERIOR = 9;
Const
  IG_GUI_THUMBNAIL_MAGNIFY_FLAG = 10;
Const
  IG_GUI_THUMBNAIL_TITLE_HEIGHT = 11;
Const
  IG_GUI_THUMBNAIL_USE_EMBEDDED = 12;
Const
  IG_GUI_THUMBNAIL_ALL_PAGES = 13;
{#ifdef WIN32}
Const
  IG_GUI_THUMBNAIL_FONT_TITLE = 14;
{#endif}

Const
  IG_THUMB_TITLE_FILENAME = 0;
Const
  IG_THUMB_TITLE_PAGENUM = 1;
Const
  IG_THUMB_TITLE_EVENT = 2;

{ nAttributeID parameter of IG_GUI_page_attribute_set() }
Const
  IG_GUI_PAGE_REALIZEPALETTETO = 0 { Type - HWND, realize the page  };
                                      { thumbnails to this window's palette }
                                      { before realizing it's own palette  }

{GUI pixel dump window output mode}
Const
  IG_GUI_PIXDUMP_DIGITS_HEX = $00000001;
Const
  IG_GUI_PIXDUMP_DATA_COLOR = $00000002;

Const
  IG_GUI_PIXDUMP_COMPONENT_R = $00000001;
Const
  IG_GUI_PIXDUMP_COMPONENT_G = $00000002;
Const
  IG_GUI_PIXDUMP_COMPONENT_B = $00000004;
Const
  IG_GUI_PIXDUMP_COMPONENT_RGB = $00000008;
Const
  IG_GUI_PIXDUMP_COMPONENT_I = $00000010;
{GUI pixel dump window data}
Const
  IG_GUI_PIXDUMP_FONT = 100;
Const
  IG_GUI_PIXDUMP_MODE = 101;
Const
  IG_GUI_PIXDUMP_COLOR_COMPONENT = 102;

{ColorProfile}
Const
  IG_GUI_DATA_COLOR_COMPONENT = $00000001;
Const
  IG_GUI_DATA_COLORPROFILE_STYLE = $00000002;

Const
  IG_GUI_COLORPROFILE_STYLE_STACK = $00000001;
Const
  IG_GUI_COLORPROFILE_STYLE_SEPARATE = $00000002;
Const
  IG_GUI_COLORPROFILE_STYLE_OVERLAID = $00000004;
Const
  IG_GUI_COLORPROFILE_STYLE_MASK = $FFFFFF00;

Const
  IG_GUI_COLORPROFILE_STYLE_TRACK = $00000100;
Const
  IG_GUI_COLORPROFILE_STYLE_XY = $00000200;

Const
  IG_GUI_COLOR_COMPONENT_R = $00000001;
Const
  IG_GUI_COLOR_COMPONENT_G = $00000002;
Const
  IG_GUI_COLOR_COMPONENT_B = $00000004;
Const
  IG_GUI_COLOR_COMPONENT_RGB = $00000008;
Const
  IG_GUI_COLOR_COMPONENT_I = $00000010;

{*************************************************************************}
{GUI Magnify control options}

Const
  IG_GUI_MAGNIFY_POPUP_WIDTH = $0000 {Width of popup magnify window};
Const
  IG_GUI_MAGNIFY_POPUP_HEIGHT = $0001 {Height of popup magnify window};
Const
  IG_GUI_MAGNIFY_POPUP_ZOOM = $0002 {Zoom factor of popup magnify window};
Const
  IG_GUI_MAGNIFY_POPUP_CIRCLE = $0003 {Circle popup magnify window};

{ Pixel Access data format}
Const
  IG_PIXEL_PACKED = 1;
Const
  IG_PIXEL_UNPACKED = 2;
Const
  IG_PIXEL_RLE = 3;

{ IG_DIB_area_get/set=  }
Const
  IG_DIB_AREA_RAW = 0 { all pixels as they are found  };
Const
  IG_DIB_AREA_DIB = 1 { pads rows to long boundaries};
Const
  IG_DIB_AREA_UNPACKED = 2 { 1 pixel per byte or 3 bytes (24) };

{ ImageGear extension constants }
Const
  IG_EXTENTION_LZW = 0;
Const
  IG_EXTENTION_MEDICAL = 1;
Const
  IG_EXTENTION_ABIC = 2;
Const
  IG_EXTENSION_FLASHPIX = 3;

{ Area access functions}
Const
  IG_DIB_AREA_INFO_MIN = 1;
Const
  IG_DIB_AREA_INFO_MAX = 2;
Const
  IG_DIB_AREA_INFO_AVE = 3;
Const
  IG_DIB_AREA_INFO_CENTER = 4;

{ Draw frame functions }
Const
  IG_DRAW_FRAME_EXPAND = 1;
Const
  IG_DRAW_FRAME_OVERWRITE = 2;

{ Image Resolution Units   }
Const
  IG_RESOLUTION_NO_ABS = 1 { No Absolute Units };
Const
  IG_RESOLUTION_METERS = 2 { Pels (Pixels) Per Meter };
Const
  IG_RESOLUTION_INCHES = 3 { Dots (Pixels) Per Inch };
Const
  IG_RESOLUTION_CENTIMETERS = 4 { Pixles Per CentiMeter};
Const
  IG_RESOLUTION_10_INCHES = 5 { Dots (Pixels) Per 10 Inch  };
Const
  IG_RESOLUTION_10_CENTIMETERS = 6 { Pixles Per 10 CentiMeter};

{ Interpolation methods}
Const
  IG_INTERPOLATION_NONE = 0;
Const
  IG_INTERPOLATION_AVERAGE = 1 { this is for Pro Gold users only  };
Const
  IG_INTERPOLATION_BILINEAR = 2 { this is for Pro Gold users only  };
Const
  IG_INTERPOLATION_NEAREST_NEIGHBOR = 3;
Const
  IG_INTERPOLATION_PADDING = 4;
Const
  IG_INTERPOLATION_GRAYSCALE = 5 { this is for IG7 Pro Gold users only: 1 bit to 8g };

Const
  IG_ORIENT_SUPPORT_NONE = 0 { orientation is not supported };
Const
  IG_ORIENT_SUPPORT_1BIT_PROGOLD = 1 { only 1 bit rle compressed images is rotated before displaying };
Const
  IG_ORIENT_SUPPORT_FULL = 2 { 1 bit rle compressed images rotated before displaying but all other images rotated during loading };

{ color space support level }
Const
  IG_CONVERT_TO_RGB = 1;

{ Image Orientation Units
  There are 8 possible orientations.  This AT_MODE lables them according to where the
  the first row (row 0) and first col (col 0) of the image data is to be displayed.
  Normal images are display with row 0 at the top and column 0 at the left.  This is
  labeled IG_ORIENT_TOP_LEFT.  The other orientations are combinations of flips and
  rotates.  Portrait is usually IG_ORIENT_TOP_LEFT, and Landscape is either
  IG_ORIENT_RIGHT_TOP or IG_ORIENT_LEFT_BOTTOM.}
Const
  IG_ORIENT_TOP_LEFT = 1 { Row0 Top  Col0 Left Normal (Portrait) };
Const
  IG_ORIENT_TOP_RIGHT = 2 { Row0 Top  Col0 Right  Flip-H};
Const
  IG_ORIENT_BOTTOM_RIGHT = 3 { Row0 Bottom Col0 Right  Rotate 180   };
Const
  IG_ORIENT_BOTTOM_LEFT = 4 { Row0 Bottom Col0 Left Flip-V};
Const
  IG_ORIENT_LEFT_TOP = 5 { Row0 Left Col0 Top  Rotate 90 CC & Flip V};
Const
  IG_ORIENT_RIGHT_TOP = 6 { Row0 Right  Col0 Top  Rotate 90 C  (landscape)};
Const
  IG_ORIENT_RIGHT_BOTTOM = 7 { Row0 Right  Col0 Bottom Rotate 90 C & Flip V  };
Const
  IG_ORIENT_LEFT_BOTTOM = 8 { Row0 Left Col0 Bottom Rotate 90 CC (landscape)};

{ constants for threshold color reduction  }
Const
  IG_REDUCE_BITONAL_GRAYSCALE = 0;
Const
  IG_REDUCE_BITONAL_AVE = 1;
Const
  IG_REDUCE_BITONAL_WEIGHTED = 2;

{ JPEG decimation constants}
Const
  IG_JPG_DCM_1x1_1x1_1x1 = 0;
Const
  IG_JPG_DCM_2x1_1x1_1x1 = 1;
Const
  IG_JPG_DCM_1x2_1x1_1x1 = 2;
Const
  IG_JPG_DCM_2x2_1x1_1x1 = 3;
Const
  IG_JPG_DCM_2x2_2x1_2x1 = 4;
Const
  IG_JPG_DCM_4x2_1x1_1x1 = 5;
Const
  IG_JPG_DCM_2x4_1x1_1x1 = 6;
Const
  IG_JPG_DCM_4x1_1x1_1x1 = 7;
Const
  IG_JPG_DCM_1x4_1x1_1x1 = 8;
Const
  IG_JPG_DCM_4x1_2x1_2x1 = 9;
Const
  IG_JPG_DCM_1x4_1x2_1x2 = 10;
Const
  IG_JPG_DCM_4x4_2x2_2x2 = 11;
Const
  IG_FORMAT_UNKNOWN = 0;
Const
  IG_FORMAT_ATT = 1;
Const
  IG_FORMAT_BMP = 2;
Const
  IG_FORMAT_BRK = 3;
Const
  IG_FORMAT_CAL = 4;
Const
  IG_FORMAT_CLP = 5;
Const
  IG_FORMAT_CIF = 6;
Const
  IG_FORMAT_CUT = 7;
Const
  IG_FORMAT_DCX = 8;
Const
  IG_FORMAT_DIB = 9;
Const
  IG_FORMAT_EPS = 10;
Const
  IG_FORMAT_G3 = 11;
Const
  IG_FORMAT_G4 = 12;
Const
  IG_FORMAT_GEM = 13;
Const
  IG_FORMAT_GIF = 14;
Const
  IG_FORMAT_GX2 = 15;
Const
  IG_FORMAT_ICA = 16;
Const
  IG_FORMAT_ICO = 17;
Const
  IG_FORMAT_IFF = 18;
Const
  IG_FORMAT_IGF = 19;
Const
  IG_FORMAT_IMT = 20;
Const
  IG_FORMAT_JPG = 21;
Const
  IG_FORMAT_KFX = 22;
Const
  IG_FORMAT_LV = 23;
Const
  IG_FORMAT_MAC = 24;
Const
  IG_FORMAT_MSP = 25;
Const
  IG_FORMAT_MOD = 26;
Const
  IG_FORMAT_NCR = 27;
Const
  IG_FORMAT_PBM = 28;
Const
  IG_FORMAT_PCD = 29;
Const
  IG_FORMAT_PCT = 30;
Const
  IG_FORMAT_PCX = 31;
Const
  IG_FORMAT_PGM = 32;
Const
  IG_FORMAT_PNG = 33;
Const
  IG_FORMAT_PNM = 34;
Const
  IG_FORMAT_PPM = 35;
Const
  IG_FORMAT_PSD = 36;
Const
  IG_FORMAT_RAS = 37;
Const
  IG_FORMAT_SGI = 38;
Const
  IG_FORMAT_TGA = 39;
Const
  IG_FORMAT_TIF = 40;
Const
  IG_FORMAT_TXT = 41;
Const
  IG_FORMAT_WPG = 42;
Const
  IG_FORMAT_XBM = 43;
Const
  IG_FORMAT_WMF = 44;
Const
  IG_FORMAT_XPM = 45;
Const
  IG_FORMAT_XRX = 46;
Const
  IG_FORMAT_XWD = 47;
Const
  IG_FORMAT_DCM = 48;
Const
  IG_FORMAT_AFX = 49;
Const
  IG_FORMAT_FPX = 50;
Const
  IG_FORMAT_PJPEG = IG_FORMAT_JPG;
Const
  IG_FORMAT_AVI = 52;
Const
  IG_FORMAT_G32D = 53;
Const
  IG_FORMAT_ABIC_BILEVEL = 54;
Const
  IG_FORMAT_ABIC_CONCAT = 55;
Const
  IG_FORMAT_PDF = 56;
Const
  IG_FORMAT_JBIG = 57;
Const
  IG_FORMAT_RAW = 58;
Const
  IG_FORMAT_IMR = 59;
Const
  IG_FORMAT_STX = 60;
{*************************************************************************}
{ ImageGear macros for all compression types.=  }
{*************************************************************************}

Const
  IG_COMPRESSION_NONE = 0 { No compression };
Const
  IG_COMPRESSION_PACKED_BITS = 1 {Packed bits compression };
Const
  IG_COMPRESSION_HUFFMAN = 2 {Huffman encoding };
Const
  IG_COMPRESSION_CCITT_G3 = 3 {CCITT Group 3  };
Const
  IG_COMPRESSION_CCITT_G4 = 4 {CCITT Group 4  };
Const
  IG_COMPRESSION_CCITT_G32D = 5 {CCITT Group 3 2D  };
Const
  IG_COMPRESSION_JPEG = 6 {JPEG compression  };
Const
  IG_COMPRESSION_RLE = 7 {Run length encoding };

{ The following compression algorithms require special licensing }
Const
  IG_COMPRESSION_LZW = 8 {LZW compression};
Const
  IG_COMPRESSION_ABIC_BW = 9 {IBM ABIC compression };
Const
  IG_COMPRESSION_ABIC_GRAY = 10 {IBM ABIC compression };
Const
  IG_COMPRESSION_JBIG = 11 {IBM JBIG compression };
Const
  IG_COMPRESSION_FPX_SINCOLOR = 12 {single color compression};
Const
  IG_COMPRESSION_FPX_NOCHANGE = 13 {save with the same compression as loaded  };

Const
  IG_COMPRESSION_DEFLATE = 14;

Const
  IG_COMPRESSION_IBM_MMR = 15;

Const
  IG_COMPRESSION_ABIC = 16 {IBM ABIC compression };

Const
  IG_COMPRESSION_PROGRESSIVE = 17 { Progressive compression ( Progressive JPEG and may be PNG in future ) };

{*************************************************************************}
{ Format types used for saving image files  }
{*************************************************************************}

Const
  IG_SAVE_UNKNOWN = (IG_FORMAT_UNKNOWN) { Uses extension on the file name string to determine which format};

Const
  IG_SAVE_BRK_G3 = (IG_FORMAT_BRK + (IG_COMPRESSION_CCITT_G3 * $10000));
Const
  IG_SAVE_BRK_G3_2D = (IG_FORMAT_BRK + (IG_COMPRESSION_CCITT_G32D * $10000));
Const
  IG_SAVE_BMP_RLE = (IG_FORMAT_BMP + (IG_COMPRESSION_RLE * $10000));
Const
  IG_SAVE_BMP_UNCOMP = (IG_FORMAT_BMP + (IG_COMPRESSION_NONE * $10000));
Const
  IG_SAVE_CAL = (IG_FORMAT_CAL);
Const
  IG_SAVE_CLP = (IG_FORMAT_CLP);
Const
  IG_SAVE_DCX = (IG_FORMAT_DCX);
Const
  IG_SAVE_EPS = (IG_FORMAT_EPS);
Const
  IG_SAVE_GIF = (IG_FORMAT_GIF);
Const
  IG_SAVE_ICA_G3 = (IG_FORMAT_ICA + (IG_COMPRESSION_CCITT_G3 * $10000));
Const
  IG_SAVE_ICA_G4 = (IG_FORMAT_ICA + (IG_COMPRESSION_CCITT_G4 * $10000));
Const
  IG_SAVE_ICA_IBM_MMR = (IG_FORMAT_ICA + (IG_COMPRESSION_IBM_MMR * $10000));
Const
  IG_SAVE_ICO = (IG_FORMAT_ICO);
Const
  IG_SAVE_IMT = (IG_FORMAT_IMT);
Const
  IG_SAVE_IFF = (IG_FORMAT_IFF);
Const
  IG_SAVE_JPG = (IG_FORMAT_JPG);
Const
  IG_SAVE_PJPEG = (IG_FORMAT_PJPEG + (IG_COMPRESSION_PROGRESSIVE * $10000));
Const
  IG_SAVE_MOD_G3 = (IG_FORMAT_MOD + (IG_COMPRESSION_CCITT_G3 * $10000));
Const
  IG_SAVE_MOD_G4 = (IG_FORMAT_MOD + (IG_COMPRESSION_CCITT_G4 * $10000));
Const
  IG_SAVE_MOD_IBM_MMR = (IG_FORMAT_MOD + (IG_COMPRESSION_IBM_MMR * $10000));
Const
  IG_SAVE_NCR = (IG_FORMAT_NCR);
Const
  IG_SAVE_NCR_G4 = (IG_FORMAT_NCR + (IG_COMPRESSION_CCITT_G4 * $10000));
Const
  IG_SAVE_PBM_ASCII = (IG_FORMAT_PBM);
Const
  IG_SAVE_PBM_RAW = (IG_FORMAT_PBM + (IG_COMPRESSION_PACKED_BITS * $10000));
Const
  IG_SAVE_PCT = (IG_FORMAT_PCT);
Const
  IG_SAVE_PCX = (IG_FORMAT_PCX);
Const
  IG_SAVE_PNG = (IG_FORMAT_PNG);
Const
  IG_SAVE_PSD = (IG_FORMAT_PSD);
Const
  IG_SAVE_RAS = (IG_FORMAT_RAS);
Const
  IG_SAVE_RAW_G3 = (IG_FORMAT_G3 + (IG_COMPRESSION_CCITT_G3 * $10000));
Const
  IG_SAVE_RAW_G4 = (IG_FORMAT_G4 + (IG_COMPRESSION_CCITT_G4 * $10000));
Const
  IG_SAVE_RAW_G32D = (IG_FORMAT_G3 + (IG_COMPRESSION_CCITT_G32D * $10000));
Const
  IG_SAVE_RAW_LZW = (IG_FORMAT_UNKNOWN + (IG_COMPRESSION_LZW * $10000));
Const
  IG_SAVE_RAW_RLE = (IG_FORMAT_UNKNOWN + (IG_COMPRESSION_RLE * $10000));
Const
  IG_SAVE_SGI = (IG_FORMAT_SGI);
Const
  IG_SAVE_TGA = (IG_FORMAT_TGA);
Const
  IG_SAVE_TIF_UNCOMP = (IG_FORMAT_TIF + (IG_COMPRESSION_NONE * $10000));
Const
  IG_SAVE_TIF_G3 = (IG_FORMAT_TIF + (IG_COMPRESSION_CCITT_G3 * $10000));
Const
  IG_SAVE_TIF_G3_2D = (IG_FORMAT_TIF + (IG_COMPRESSION_CCITT_G32D * $10000));
Const
  IG_SAVE_TIF_G4 = (IG_FORMAT_TIF + (IG_COMPRESSION_CCITT_G4 * $10000));
Const
  IG_SAVE_TIF_HUFFMAN = (IG_FORMAT_TIF + (IG_COMPRESSION_HUFFMAN * $10000));
Const
  IG_SAVE_TIF_JPG = (IG_FORMAT_TIF + (IG_COMPRESSION_JPEG * $10000));
Const
  IG_SAVE_TIF_LZW = (IG_FORMAT_TIF + (IG_COMPRESSION_LZW * $10000));
Const
  IG_SAVE_TIF_PACKED = (IG_FORMAT_TIF + (IG_COMPRESSION_PACKED_BITS * $10000));
Const
  IG_SAVE_XBM = (IG_FORMAT_XBM);
Const
  IG_SAVE_XPM = (IG_FORMAT_XPM);
Const
  IG_SAVE_XWD = (IG_FORMAT_XWD);
Const
  IG_SAVE_WMF = (IG_FORMAT_WMF);

Const
  IG_SAVE_FPX_NOCHANGE = (IG_FORMAT_FPX + (IG_COMPRESSION_FPX_NOCHANGE * $10000));
Const
  IG_SAVE_FPX_UNCOMP = (IG_FORMAT_FPX + (IG_COMPRESSION_NONE * $10000));
Const
  IG_SAVE_FPX_JPG = (IG_FORMAT_FPX + (IG_COMPRESSION_JPEG * $10000));
Const
  IG_SAVE_FPX_SINCOLOR = (IG_FORMAT_FPX + (IG_COMPRESSION_FPX_SINCOLOR * $10000));

Const
  IG_SAVE_DCM = (IG_FORMAT_DCM);
Const
  IG_SAVE_JBIG = (IG_FORMAT_JBIG);

{**********************************************************************************}
{ ImageGear image control option IDs  }
{**********************************************************************************}
{ Option ID Format   Opt # lpData type}
{ --------------------------------=  ---------------------= ------------- }

Const
  IG_CONTROL_JPG_QUALITY = (IG_FORMAT_JPG + $0100) { UINT };
Const
  IG_CONTROL_JPG_DECIMATION_TYPE = (IG_FORMAT_JPG + $0200) { DWORD };
Const
  IG_CONTROL_JPG_SAVE_THUMBNAIL = (IG_FORMAT_JPG + $0300) { BOOL  };
Const
  IG_CONTROL_JPG_THUMBNAIL_WIDTH = (IG_FORMAT_JPG + $0400) { UINT  };
Const
  IG_CONTROL_JPG_THUMBNAIL_HEIGHT = (IG_FORMAT_JPG + $0500) { UINT };
Const
  IG_CONTROL_JPG_KEEP_ALPHA = (IG_FORMAT_JPG + $0600) { BOOL };
Const
  IG_CONTROL_JPG_TYPE = (IG_FORMAT_JPG + $0700) { BOOL  };
Const
  IG_CONTROL_JPG_PREDICTOR = (IG_FORMAT_JPG + $0800) { UINT  };

Const
  IG_CONTROL_JPG_SCAN_INFO = (IG_FORMAT_JPG + $0900) { LPAT_SCANINFO};
Const
  IG_CONTROL_JPG_SCAN_INFO_COUNT = (IG_FORMAT_JPG + $0A00) { UINT};
Const
  IG_CONTROL_JPG_LOAD_SCANS = (IG_FORMAT_JPG + $0B00) { UINT};

{ for compatibility with prev implementation }
Const
  IG_CONTROL_PJPEG_SCAN_INFO = (IG_CONTROL_JPG_SCAN_INFO) { LPAT_SCANINFO};
Const
  IG_CONTROL_PJPEG_SCAN_INFO_COUNT = (IG_CONTROL_JPG_SCAN_INFO_COUNT) { UINT};
Const
  IG_CONTROL_PJPEG_LOAD_SCANS = (IG_CONTROL_JPG_LOAD_SCANS) { UINT};

Const
  IG_CONTROL_TXT_XDPI = (IG_FORMAT_TXT + $0100) { UINT };
Const
  IG_CONTROL_TXT_YDPI = (IG_FORMAT_TXT + $0200) { UINT  };
Const
  IG_CONTROL_TXT_MARGIN_LEFT = (IG_FORMAT_TXT + $0300) { AT_DIMENSION};
Const
  IG_CONTROL_TXT_MARGIN_TOP = (IG_FORMAT_TXT + $0400) { AT_DIMENSION};
Const
  IG_CONTROL_TXT_MARGIN_RIGHT = (IG_FORMAT_TXT + $0500) { AT_DIMENSION};
Const
  IG_CONTROL_TXT_MARGIN_BOTTOM = (IG_FORMAT_TXT + $0600) { AT_DIMENSION};
Const
  IG_CONTROL_TXT_PAGE_WIDTH = (IG_FORMAT_TXT + $0700) { AT_DIMENSION};
Const
  IG_CONTROL_TXT_PAGE_HEIGHT = (IG_FORMAT_TXT + $0800) { AT_DIMENSION};
Const
  IG_CONTROL_TXT_POINT_SIZE = (IG_FORMAT_TXT + $0900) { INT};
Const
  IG_CONTROL_TXT_WEIGHT = (IG_FORMAT_TXT + $0A00) { BOOL  };
Const
  IG_CONTROL_TXT_ITALIC = (IG_FORMAT_TXT + $0B00) { BOOL };
Const
  IG_CONTROL_TXT_TAB_STOP = (IG_FORMAT_TXT + $0C00) { UINT };
Const
  IG_CONTROL_TXT_TYPEFACE = (IG_FORMAT_TXT + $0D00) { CHAR[32] };
Const
  IG_CONTROL_TXT_LINES_PER_PAGE = (IG_FORMAT_TXT + $0E00) { UINT  };
Const
  IG_CONTROL_TXT_CHAR_PER_LINE = (IG_FORMAT_TXT + $0F00) { UINT  };
Const
  IG_CONTROL_TXT_COMPATIBILITY_MODE = (IG_FORMAT_TXT + $1000) { BOOL  };

Const
  IG_CONTROL_BMP_TYPE = (IG_FORMAT_BMP + $0100) { UINT };
Const
  IG_CONTROL_BMP_UPSIDEDOWN = (IG_FORMAT_BMP + $0200) { BOOL };
Const
  IG_CONTROL_BMP_16GRAY_SCANNER = (IG_FORMAT_BMP + $0300) { BOOL };
Const
  IG_CONTROL_BMP_16GRAY_SCANNER_TYPE = (IG_FORMAT_BMP + $0400) { UINT };

Const
  IG_CONTROL_CCITT_FILL_ORDER = (IG_FORMAT_G3 + $0100) { UINT };
Const
  IG_CONTROL_CCITT_KFACTOR = (IG_FORMAT_G3 + $0200) { UINT };

Const
  IG_CONTROL_TIF_FILENAME_LEN = (IG_FORMAT_TIF + $0100) { UINT };
Const
  IG_CONTROL_TIF_FILENAME = (IG_FORMAT_TIF + $0200) { LPSTR };
Const
  IG_CONTROL_TIF_FILEDATE_LEN = (IG_FORMAT_TIF + $0300) { UINT };
Const
  IG_CONTROL_TIF_FILEDATE = (IG_FORMAT_TIF + $0400) { LPSTR };
Const
  IG_CONTROL_TIF_FORCE_SNGL_STRIP = (IG_FORMAT_TIF + $0500) { BOOL };
Const
  IG_CONTROL_TIF_BUFFER_SIZE = (IG_FORMAT_TIF + $0600) { DWORD };
Const
  IG_CONTROL_TIF_WRITE_FILL_ORDER = (IG_FORMAT_TIF + $0700) { SHORT};
Const
  IG_CONTROL_TIF_WRITE_CONFIG = (IG_FORMAT_TIF + $0800) { SHORT };
Const
  IG_CONTROL_TIF_PHOTOMETRIC = (IG_FORMAT_TIF + $0900) { SHORT };
Const
  IG_CONTROL_TIF_BIGENDIAN = (IG_FORMAT_TIF + $0A00) { BOOL };
Const
  IG_CONTROL_TIF_DOCUMENTNAME = (IG_FORMAT_TIF + $0B00) { LPSTR (maxlen=256) };
Const
  IG_CONTROL_TIF_DATETIME = (IG_FORMAT_TIF + $0C00) { LPSTR (maxlen=256) };
Const
  IG_CONTROL_TIF_IMAGE_BEFORE_IFD = (IG_FORMAT_TIF + $0D00) { BOOL };
Const
  IG_CONTROL_TIF_PLANAR = (IG_FORMAT_TIF + $0E00) { BOOL };
Const
  IG_CONTROL_TIF_NUMBER_OF_STRIPS = (IG_FORMAT_TIF + $0F00) { LONG };
Const
  IG_CONTROL_TIF_WRITE_CLASS_F = (IG_FORMAT_TIF + $1000) { BOOL};
Const
  IG_CONTROL_TIF_16_UPDATE_LUT = (IG_FORMAT_TIF + $1100) { BOOL};
{ custom project TIFF parameters	}
Const
  IG_CONTROL_TIF_NEW_SUBFILE_TYPE = (IG_FORMAT_TIF + $A000) { UINT};
Const
  IG_CONTROL_TIF_INCLUDE_PAGE_NUMBER = (IG_FORMAT_TIF + $A100) {BOOL};

Const
  IG_CONTROL_GIF_INTERLACE = (IG_FORMAT_GIF + $0100) { BOOL };
Const
  IG_CONTROL_GIF_ADD_IMAGE = (IG_FORMAT_GIF + $0200) { BOOL };
Const
  IG_CONTROL_GIF_VERSION = (IG_FORMAT_GIF + $0300) { BYTE };
Const
  IG_CONTROL_GIF_EXTBLOCKREADONLY = (IG_FORMAT_GIF + $0400) { BOOL };

Const
  IG_CONTROL_AVI_FILENAME = (IG_FORMAT_AVI + $0100) { CHAR[262]};

Const
  IG_CONTROL_KFX_BIT_SEX = (IG_FORMAT_KFX + $0100) { UINT };

Const
  IG_CONTROL_PCT_VERSION1 = (IG_FORMAT_PCT + $0100) { BOOL };

Const
  IG_CONTROL_TGA_SAVE_THUMBNAIL = (IG_FORMAT_TGA + $0100) { BOOL };
Const
  IG_CONTROL_TGA_THUMBNAIL_WIDTH = (IG_FORMAT_TGA + $0200) { UINT };
Const
  IG_CONTROL_TGA_THUMBNAIL_HEIGHT = (IG_FORMAT_TGA + $0300) { UINT };
Const
  IG_CONTROL_TGA_KEEP_ALPHA = (IG_FORMAT_TGA + $0400) { BOOL };
Const
  IG_CONTROL_TGA_CONVERT_TO_16 = (IG_FORMAT_TGA + $0500) { BOOL };

Const
  IG_CONTROL_EPS_TIFF_PREVIEW = (IG_FORMAT_EPS + $0100) { BOOL };
Const
  IG_CONTROL_EPS_FIT_TO_PAGE = (IG_FORMAT_EPS + $0200) { BOOL };
Const
  IG_CONTROL_EPS_ACTUAL_SIZE = (IG_FORMAT_EPS + $0300) { BOOL };
Const
  IG_CONTROL_EPS_PIXEL_TO_PIXEL = (IG_FORMAT_EPS + $0400) { BOOL };
Const
  IG_CONTROL_EPS_PAGE_WIDTH = (IG_FORMAT_EPS + $0500) { AT_DIMENSION};
Const
  IG_CONTROL_EPS_PAGE_HEIGHT = (IG_FORMAT_EPS + $0600) { AT_DIMENSION};
Const
  IG_CONTROL_EPS_XDPI = (IG_FORMAT_EPS + $0700) { UINT };
Const
  IG_CONTROL_EPS_YDPI = (IG_FORMAT_EPS + $0800) { UINT };

Const
  IG_CONTROL_WMF_LOAD_METAFILE = (IG_FORMAT_WMF + $0100) { BOOL};

Const
  IG_CONTROL_PNG_COMPRESSION = (IG_FORMAT_PNG + $0100) { UINT};

Const
  IG_CONTROL_JBIG_STRIP_SIZE = (IG_FORMAT_JBIG + $0300) { DWORD};
Const
  IG_CONTROL_JBIG_TYPICAL_PREDICTOR = (IG_FORMAT_JBIG + $0400) { INT};
Const
  IG_CONTROL_JBIG_CONTEXT_SHAPE = (IG_FORMAT_JBIG + $0500) { INT};
Const
  IG_CONTROL_JBIG_TAUX = (IG_FORMAT_JBIG + $0600) { INT};

Const
  IG_CONTROL_SGI_SAVE_COMPRESSED = (IG_FORMAT_SGI + $0100) {BOOL};

{ additional constants for TIFF filter}
Const
  IG_TIF_STRIP_FIXED_COUNT = 0;
Const
  IG_TIF_STRIP_FIXED_BUFFER = 1;
Const
  IG_TIF_TILED_FIXED_SIZE = $10;
Const
  IG_TIF_TILED_FIXED_COUNT = $11;

Const
  IG_TIF_PHOTO_WHITEZERO = 0;
Const
  IG_TIF_PHOTO_BLACKZERO = 1;
Const
  IG_TIF_PHOTO_RGB = 2;
Const
  IG_TIF_PHOTO_CMYK = 5;

Const
  IG_PNG_MIN_COMPRESSION = 0;
Const
  IG_PNG_MAX_COMPRESSION = 9;
Const
  IG_PNG_DEFAULT_COMPRESSION = 6;

Const
  IG_PNG_STRIP_FIXED_COUNT = 0;
Const
  IG_PNG_STRIP_FIXED_BUFFER = 1;

Const
  IG_JPG_LOSSY = 0;
Const
  IG_JPG_LOSSLESS = 1;
Const
  IG_JPG_PROGRESSIVE = 2;

{************************************************************************}
{ STANDARD PAGE SIZES   }
{************************************************************************}

Const
  IG_ASCIIXSIZELETTER = 8500 { 8 1/2"  };
Const
  IG_ASCIIYSIZELETTER = 11000 { 11"  };

Const
  IG_ASCIIXSIZELEGAL = 8500 { 8 1/2"  };
Const
  IG_ASCIIYSIZELEGAL = 14000 { 14"  };

Const
  IG_ASCIIXSIZEEXECUTIVE = 7250 { 7 1/4"  };
Const
  IG_ASCIIYSIZEEXECUTIVE = 10500 { 10 1/2" };

Const
  IG_ASCIIXSIZEENVELOPE = 4125 { 4 1/8"  };
Const
  IG_ASCIIYSIZEENVELOPE = 9500 { 9 1/2"  };

{ GUI window constants - use with GUIWindow property}
Const
  GUIPAN = 0;
Const
  GUIMAG = 1;
Const
  GUIPAL = 2;
Const
  GUITHM = 3;
Const
  GUIHST = 4;
Const
  GUIPXL = 5;
Const
  GUISRT = 6;

{Setting mode constants - use with SettingMode property}
Const
  MODE_CONTRAST = 0;
Const
  MODE_MAXCOLORS = 1;
Const
  MODE_FASTREMAP = 2;
Const
  MODE_ROTATE = 3;
Const
  MODE_BLURAMOUNT = 4;
Const
  MODE_DIRECTION = 5;
Const
  MODE_TWISTTYPE = 6;
Const
  MODE_PRINTDRIVER = 7;
Const
  MODE_DPIASPECT = 8;
Const
  MODE_ZOOMKEYS = 9;
Const
  MODE_LOADDOC = 10;
Const
  MODE_USE_BKGRND = 11;
Const
  MODE_ROTATE_DEV_RECT = 12;
Const
  MODE_PRINT_ADJUST = 13;
Const
  MODE_STITCH_IMAGE = 14;
Const
  MODE_USE_FIRETAGEX = 15;

Function SaveGearImageDialog(SaveDialog1: TSaveDialog; Var Saveformat: Integer; Var PathName: String): Boolean;

Implementation

Function SaveGearImageDialog(SaveDialog1: TSaveDialog; Var Saveformat: Integer; Var PathName: String): Boolean;
Begin
  SaveDialog1.Filter := 'Uncompressed bitmap file (*.BMP)|*.BMP' +
    '|Compressed (RLE) bitmap file (*.BMP)|*.BMP' +
    '|Brooktrout G3 (*.301)|*.301' +
    '|Brooktrout G3 2D (*.301)|*.301' +
    '|CALS (*.CAL)|*.CAL' +
    '|Windows Clipboard (*.CLP)|*.CLP' +
    '|Dicom (reqs ext.) (*.DCM) |*.DCM' +
    '|DCX (Multi Page PCX) (*.DCX) |*.DCX' +
    '|Encapsulated Postscript (*.EPS) |*.EPS' +
    '|FlashPix (*.FPX) | *.FPX' +
    '|FlashPix Uncomp. (*.FPX) | *.FPX' +
    '|FlashPix Sing. Color. (*.FPX) | *.FPX' +
    '|FlashPix JPEG (*.FPX) | *.FPX' +
    '| GIF (*.GIF)|*.GIG' +
    '| IOCA G3 (*.ICA)|*.ICA' +
    '| IOCA G4 (*.ICA)|*.ICA' +
    '| IOCA IBM MMR (*.ICA)|*.ICA' +
    '| IFF (*.IFF)|*.IFF' +
    '| IMNET G4 (*.IMT)|*.IMT' +
    '| JBIG (*.JBG)|*.JBG' +
    '| JPEG (*.JPG)|*.JPG' +
    '| Progressive JPEG (*.JPG)|*.JPG' +
    '| Windows icons(*.IC0)|*.ICO' +
    '| MO:DCA G3(*.MOD)|*.MOD' +
    '| MO:DCA G4(*.MOD)|*.MOD' +
    '| MO:DCA IBM MMR(*.MOD)|*.MOD' +
    '| NCR G4 (*.NCR)|*.NCR' +
    '| PBM ASCI (*.PBM)|*.PBM' +
    '| PBM RAW (*.PBM)|*.PBM' +
    '| PICT (*.PCT)|*.PCT' +
    '| PCX (*.PCX)|*.PCX' +
    '| PNG (*.PNG)|*.PNG' +
    '| Photo Shop (*.PSD)|*.PSD' +
    '| Sun Raster (*.RAS)|*.RAS' +
    '| RAW G3 (*.G3)|*.G3' +
    '| RAW G4 (*.G4)|*.G4' +
    '| RAW G32 (*.G32)|*.G32' +
    '| RAW LZW (*.LZW)|*.LZW' +
    '| RAW RLE (*.RLE)|*.RLE' +
    '| Silicon Graphics (*.SGI)|*.SGI' +
    '| Targa (*.TGA)|*.TGA' +
    '| TIFF Uncompressed (*.TIF)|*.TIF' +
    '| TIFF G3 2D (*.TIF)|*.TIF' +
    '| TIFF G3 (*.TIF)|*.TIF' +
    '| TIFF G4 (*.TIF)|*.TIF' +
    '| TIFF Huffman (*.TIF)|*.TIF' +
    '| TIFF JPEG (*.TIF)|*.TIF' +
    '| TIFF LZW (*.TIF)|*.TIF' +
    '| TIFF Packed Bits (*.TIF)|*.TIF' +
    '| Windows metafile (*.WMF)|*.WMF' +
    '| XBM (*.XBM)|*.XBM' +
    '| XPM (*.XPM)|*.XPM' +
    '| X Windows Dump (*.XWD)|*.XWD' +
    '| use extension (*.*)|*.*';

  If SaveDialog1.Execute Then
  Begin
    Case SaveDialog1.FilterIndex Of
      1: Saveformat := IG_SAVE_BMP_UNCOMP;
      2: Saveformat := IG_SAVE_BMP_RLE;
      3: Saveformat := IG_SAVE_BRK_G3;
      4: Saveformat := IG_SAVE_BRK_G3_2D;
      5: Saveformat := IG_SAVE_CAL;
      6: Saveformat := IG_SAVE_CLP;
      7: Saveformat := IG_SAVE_DCM;
      8: Saveformat := IG_SAVE_DCX;
      9: Saveformat := IG_SAVE_EPS;
      10: Saveformat := IG_SAVE_FPX_NOCHANGE;
      11: Saveformat := IG_SAVE_FPX_UNCOMP;
      12: Saveformat := IG_SAVE_FPX_SINCOLOR;
      13: Saveformat := IG_SAVE_FPX_JPG;
      14: Saveformat := IG_SAVE_GIF;
      15: Saveformat := IG_SAVE_ICA_G3;
      16: Saveformat := IG_SAVE_ICA_G4;
      17: Saveformat := IG_SAVE_ICA_IBM_MMR;
      18: Saveformat := IG_SAVE_IFF;
      19: Saveformat := IG_SAVE_IMT;
      20: Saveformat := IG_SAVE_JBIG;
      21: Saveformat := IG_SAVE_JPG;
      22: Saveformat := IG_SAVE_PJPEG;
      23: Saveformat := IG_SAVE_ICO;
      24: Saveformat := IG_SAVE_MOD_G3;
      25: Saveformat := IG_SAVE_MOD_G4;
      26: Saveformat := IG_SAVE_MOD_IBM_MMR;
      27: Saveformat := IG_SAVE_NCR_G4;
      28: Saveformat := IG_SAVE_PBM_ASCII;
      29: Saveformat := IG_SAVE_PBM_RAW;
      30: Saveformat := IG_SAVE_PCT;
      31: Saveformat := IG_SAVE_PCX;
      32: Saveformat := IG_SAVE_PNG;
      33: Saveformat := IG_SAVE_PSD;
      34: Saveformat := IG_SAVE_RAS;
      35: Saveformat := IG_SAVE_RAW_G3;
      36: Saveformat := IG_SAVE_RAW_G4;
      37: Saveformat := IG_SAVE_RAW_G32D;
      38: Saveformat := IG_SAVE_RAW_LZW;
      39: Saveformat := IG_SAVE_RAW_RLE;
      40: Saveformat := IG_SAVE_SGI;
      41: Saveformat := IG_SAVE_TGA;
      42: Saveformat := IG_SAVE_TIF_UNCOMP;
      43: Saveformat := IG_SAVE_TIF_G3;
      44: Saveformat := IG_SAVE_TIF_G3_2D;
      45: Saveformat := IG_SAVE_TIF_G4;
      46: Saveformat := IG_SAVE_TIF_HUFFMAN;
      47: Saveformat := IG_SAVE_TIF_JPG;
      48: Saveformat := IG_SAVE_TIF_LZW;
      49: Saveformat := IG_SAVE_TIF_PACKED;
      50: Saveformat := IG_SAVE_WMF;
      51: Saveformat := IG_SAVE_XBM;
      52: Saveformat := IG_SAVE_XPM;
      53: Saveformat := IG_SAVE_XWD;
      54: Saveformat := IG_SAVE_UNKNOWN;
    End;
    PathName := SaveDialog1.Filename;
    SaveGearImageDialog := True;
  End
  Else
    SaveGearImageDialog := False;
End;

End.
