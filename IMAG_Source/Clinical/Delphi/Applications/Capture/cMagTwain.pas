unit cMagTwain;
   {
   Package: MAG - VistA Imaging
   WARNING: Per VHA Directive 10-93-142 this unit should not be modified.
   Date Created:  Version 3.0.129   3/3/2012
   Site Name: Silver Spring, OIFO
   Developers: Garrett Kirin
   [==
   Description:
     This unit holds all functions for Twain Scanning using Accusoft ImageGear
     V 16.2.11 as first version.
     The ReDeclaring of the constants sections are so that the form/unit  that
     makes the TMagTwain function calls,   does not have to have knowledge
     of the Accusoft Constants.   If frees the calling program from needing
     to be coupled with Accusoft Components.
    A test program for this control is
    C:\devd2007\UnitTest\AccuTwain2mag4vgear\AccuTwain2.exe
       ==]

   Note:
   }
(*
        ;; +------------------------------------------------------------------+
        ;; Property of the US Government.
        ;; No permission to copy or redistribute this software is given.
        ;; Use of unreleased versions of this software requires the user
        ;;  to execute a written test agreement with the VistA Imaging
        ;;  Development Office of the Department of Veterans Affairs,
        ;;  telephone (301) 734-0100.
        ;;
        ;; The Food and Drug Administration classifies this software as
        ;; a Class II medical device.  As such, it may not be changed
        ;; in any way.  Modifications to this software may result in an
        ;; adulterated medical device under 21CFR820, the use of which
        ;; is considered to be a violation of US Federal Statutes.
        ;; +------------------------------------------------------------------+

*)

interface
Uses
  windows,
  Sysutils,
  Classes,

  uMagClasses,
  uMagDefinitions,
  uMagUtils8,
  iMaginterfaces,
  forms,
  controls,
  ExtCtrls,

  GearCORELib_TLB,
  GearDIALOGSLib_TLB,
  GearDISPLAYLib_TLB,
  GearEFFECTSLib_TLB,
  GearFORMATSLib_TLB,
  GearMEDLib_TLB,
  GearPDFLib_TLB,
  GearPROCESSINGLib_TLB,
  IGGUIDlgLib_TLB,
  IGGUIWinLib_TLB,
  VECTLib_TLB    ,
  GearTWAINlib_TLB,
  GearVIEWLib_TLB,


  cMag4Vgear,
  cmagIGmanager  ,
  umagCapUtil,
  umagCapDef

  ;

type
  TMagTwain = Class(Tobject)
  Private
  FlastErrorCount : integer;
  FlastErrorList : tStrings;
  Fmg1 : Tmag4VGear;
  FIGCoreCtl1 :  TIGCoreCtl;
  FDSIsOpen : boolean;
  CurrentPage: IIGPage;

  TwainInfo: IGTWAINFileInfo;
  FDS : IGTwainDataSources;
  FIGDSarr : IGstringarray;
  FIGDSdft : integer;
  FJPEGQuality : integer;

  procedure CreateTwainControls(ctl : Twincontrol);

    function MagIGErrorCheck: boolean;
    function GetSavePagesSeparately() : boolean;
    procedure SetSavePagesSeparately(value : boolean);
    function GetIsSourceOpen() : boolean;

    function GetUseUI: boolean;
    procedure SetUseUI(const Value: boolean);
    function GetCapabilityIDDesc(TWCap: integer): string;
    function GetCapabilityDesc(TWCap: integer): string;
    function GetCapEnumItemDesc(capEnum: IIGTWAINCapEnumeration; indxVal: integer): string;
    procedure ShowCapArray(caparray: IIGTwainCapArray; rlist: Tstrings);
    procedure ShowCapEnum(capEnum: IIGTWAINCapEnumeration; rlist: Tstrings);
    procedure ShowCapOneValue(capOneValue: IIGTWAINCapOneValue; rlist: Tstrings);
    procedure ShowCapRange(capRange: IIGTWAINCapRange; rlist: Tstrings);
    function GetColorSpaceDesc(value: integer): string;
    function GetContainerDesc(value: integer): string;
    function GetImageChannelTypeDesc(value: integer): string;
    function GetResolutionUnitsDesc(value: integer): string;

    function GetIGDataItemDesc(pItemtype: enumIGSysDataType; pItemvalue: IGDataItem): string;
    function GetIGSysDataTypeDesc(sysdatatype: enumIGSysDataType): String;
    function Magbooltostr(Value: Boolean): String;
    function MagGetFileSize(fileName: wideString): int64;
    //p140
    function GetSaveFormatDesc(value: integer): string;






  Public

    FIGTwainCtl1 : TIGTWAINCtl;
    Tw1: String;


    constructor Create;
    destructor Destroy;    override;
    {p140t1  made these two  public}
    procedure CloseFile;
    function GetCompressionDesc(comp: integer): string;
    function GetFormatDesc(value: integer): string;
    {p129t18  made this public}
    function LoadDSSources: boolean;
    procedure GetDSSourcesList(dsList : Tstrings; var dsDft : integer);

    function MagAcquireToFile(filename : string; pagecount : integer; SaveFmt : integer): boolean;
    function MagAcquireToPage(mag4Vgear : Tmag4VGear) : boolean;
    procedure MagIGErrorInit(UseErrorCount: boolean = true);
    procedure InitTwainControls(Ctl : TwinControl);

    function SourceOpenByIndex(srcIndex : string = '') : boolean;
    procedure SourceShowUI;
    function SourceOpenSelect(): boolean;
    function SourceOpenDefault() : boolean;
    procedure SourceClose;

    procedure LoadCustomDSData(dsfile : string);
    procedure SaveCustomDSData(filename : string);


    procedure SetResolution(horiz, vert: string);
    procedure GetTwainVersion(var t : tstrings);
    function GetLastErrorCount(): integer;
    procedure GetLastErrorList(var t : tStrings);

    procedure MagSetCapability(mID: string; mItemType, mChangeType: integer; mVal: string); overload;
    procedure MagSetCapability(mID, mItemType, mChangeType, mVal : integer); overload;
    procedure SetCapGroup1(pFormat,pPixelType,pCompression,pBitDepth: Integer);
    procedure SetCompression(mCompression : integer);
    procedure SetSaveJPG();
    procedure SetSaveTIF();
    procedure SetJPEGQuality(value: integer);

    procedure LoadOneCapability(capint: integer; rlist: tstrings);
    procedure LoadCapabilities(var rlist: Tstrings; capDetails : boolean = true);

    procedure ShowIGProperties(rlist: Tstrings; m4VGear : TMag4VGear = nil );
    procedure ShowFileInfo(filename: string; rlist: Tstrings);

    {The Scanning configurations that we use in capture.}
    //Procedure MagScanJPG();
    //Procedure MagScanTIF);
    //Procedure MagScanTIFmulti();
    //Procedure MagScanTGA();
    //Procedure MagScan256Color8BitTIF();
    //Procedure MagScanXray8BitTGAGray();
    //Procedure MagScanXray8BitJPGGray();
    //Procedure MagScanBW8BitTGAGray();  {same as Xray8BitTGAGray}
    //Procedure MagScanTIFUncompressed();
    //Procedure MagDoc1bitTIFg4();



  published
    //    Property SelectionWidth: Integer Read FSelectRectWidth Write FSelectRectWidth;
        Property SavePagesSeparately: boolean Read GetSavePagesSeparately Write SetSavePagesSeparately;
        Property UseUI: boolean Read GetUseUI Write SetUseUI;
        Property IsSourceOpen : boolean Read GetIsSourceOpen ;
        property JPEGQuality : integer Read FJPEGQuality write FJPEGQuality;

  End;

var
  MagTwain1 : TMagTwain;

  const
  mag_IG_TW_ICAP_IMAGEFILEFORMAT = $0000110C;
  mag_IG_TW_ICAP_PIXELTYPE = $00000101;
  mag_IG_TW_ICAP_COMPRESSION = $00000100;
  mag_IG_TW_ICAP_BITDEPTH = $0000112B;

  // Constants for enum enumIGSaveFormats      GearFORMATSLib_TLB
  mag_IG_SAVE_UNKNOWN = $00000000;
  mag_IG_SAVE_BRK_G3 = $00030003;
  mag_IG_SAVE_BRK_G3_2D = $00050003;
  mag_IG_SAVE_BMP_RLE = $00070002;
  mag_IG_SAVE_BMP_UNCOMP = $00000002;
  mag_IG_SAVE_CAL = $00000004;
  mag_IG_SAVE_CLP = $00000005;
  mag_IG_SAVE_DCX = $00000008;
  mag_IG_SAVE_EPS_UNCOMP = $0000000A;
  mag_IG_SAVE_EPS_JPG = $0006000A;
  mag_IG_SAVE_EPS_G3 = $0003000A;
  mag_IG_SAVE_EPS_G4 = $0004000A;
  mag_IG_SAVE_GIF = $0000000E;
  mag_IG_SAVE_ICA_G3 = $00030010;
  mag_IG_SAVE_ICA_G4 = $00040010;
  mag_IG_SAVE_ICA_IBM_MMR = $000F0010;
  mag_IG_SAVE_ICO = $00000011;
  mag_IG_SAVE_IMT = $00000014;
  mag_IG_SAVE_IFF = $00000012;
  mag_IG_SAVE_IFF_RLE = $00070012;
  mag_IG_SAVE_JPG = $00000015;
  mag_IG_SAVE_PJPEG = $00110015;
  mag_IG_SAVE_MOD_G3 = $0003001A;
  mag_IG_SAVE_MOD_G4 = $0004001A;
  mag_IG_SAVE_MOD_IBM_MMR = $000F001A;
  mag_IG_SAVE_NCR = $0000001B;
  mag_IG_SAVE_NCR_G4 = $0004001B;
  mag_IG_SAVE_PBM_ASCII = $0017001C;
  mag_IG_SAVE_PBM_RAW = $0018001C;
  mag_IG_SAVE_PCT = $0000001E;
  mag_IG_SAVE_PCX = $0000001F;
  mag_IG_SAVE_PDF_UNCOMP = $00000038;
  mag_IG_SAVE_PDF_JPG = $00060038;
  mag_IG_SAVE_PDF_G3 = $00030038;
  mag_IG_SAVE_PDF_G3_2D = $00050038;
  mag_IG_SAVE_PDF_G4 = $00040038;
  mag_IG_SAVE_PDF_RLE = $00070038;
  mag_IG_SAVE_PDF_DEFLATE = $000E0038;
  mag_IG_SAVE_PDF_LZW = $00080038;
  mag_IG_SAVE_PS_UNCOMP = $00000066;
  mag_IG_SAVE_PS_JPG = $00060066;
  mag_IG_SAVE_PS_G3 = $00030066;
  mag_IG_SAVE_PS_G3_2D = $00050066;
  mag_IG_SAVE_PS_G4 = $00040066;
  mag_IG_SAVE_PS_RLE = $00070066;
  mag_IG_SAVE_PS_DEFLATE = $000E0066;
  mag_IG_SAVE_PS_LZW = $00080066;
  mag_IG_SAVE_PNG = $00000021;
  mag_IG_SAVE_PSD = $00000024;
  mag_IG_SAVE_PSB = $00000070;
  mag_IG_SAVE_PSD_PACKED = $00010024;
  mag_IG_SAVE_PSB_PACKED = $00010070;
  mag_IG_SAVE_RAS = $00000025;
  mag_IG_SAVE_RAW_G3 = $0003000B;
  mag_IG_SAVE_RAW_G4 = $0004000C;
  mag_IG_SAVE_RAW_G32D = $00050035;
  mag_IG_SAVE_RAW_LZW = $00080000;
  mag_IG_SAVE_RAW_RLE = $00070000;
  mag_IG_SAVE_SGI = $00000026;
  mag_IG_SAVE_SGI_RLE = $00070026;
  mag_IG_SAVE_TGA = $00000027;
  mag_IG_SAVE_TGA_RLE = $00070027;
  mag_IG_SAVE_TIF_UNCOMP = $00000028;
  mag_IG_SAVE_TIF_G3 = $00030028;
  mag_IG_SAVE_TIF_G3_2D = $00050028;
  mag_IG_SAVE_TIF_G4 = $00040028;
  mag_IG_SAVE_TIF_HUFFMAN = $00020028;
  mag_IG_SAVE_TIF_JPG = $00060028;
  mag_IG_SAVE_TIF_LZW = $00080028;
  mag_IG_SAVE_TIF_PACKED = $00010028;
  mag_IG_SAVE_TIF_DEFLATE = $000E0028;
  mag_IG_SAVE_XBM = $0000002B;
  mag_IG_SAVE_XPM = $0000002D;
  mag_IG_SAVE_XWD = $0000002F;
  mag_IG_SAVE_WMF = $0000002C;
  mag_IG_SAVE_WLT = $0000003D;
  mag_IG_SAVE_JB2 = $0000003E;
  mag_IG_SAVE_WL16 = $0000003F;
  mag_IG_SAVE_WBMP = $00000042;
  mag_IG_SAVE_FPX_NOCHANGE = $000D0032;
  mag_IG_SAVE_FPX_UNCOMP = $00000032;
  mag_IG_SAVE_FPX_JPG = $00060032;
  mag_IG_SAVE_FPX_SINCOLOR = $000C0032;
  mag_IG_SAVE_DCM = $00000030;
  mag_IG_SAVE_JBIG = $00000039;
  mag_IG_SAVE_SCI_ST = $0000005B;
  mag_IG_SAVE_LURAWAVE = $00000062;
  mag_IG_SAVE_LURADOC = $00000061;
  mag_IG_SAVE_LURAJP2 = $00000063;
  mag_IG_SAVE_JPEG2K = $00000064;
  mag_IG_SAVE_JPX = $00000065;
  mag_IG_SAVE_HDP = $0000006E;
  mag_IG_SAVE_EXIF_JPEG = $00000047;
  mag_IG_SAVE_EXIF_TIFF = $0000004A;
  mag_IG_SAVE_EXIF_TIFF_LZW = $0008004A;
  mag_IG_SAVE_EXIF_TIFF_DEFLATE = $000E004A;
  mag_IG_SAVE_CGM = $0000004B;
  mag_IG_SAVE_SVG = $0000004D;
  mag_IG_SAVE_DWG = $00000045;
  mag_IG_SAVE_DXF = $00000046;
  mag_IG_SAVE_U3D = $0000004F;
  mag_IG_SAVE_DWF = $0000004E;

// Constants for enum enumIGSysDataType     GearFORMATSLib_TLB
  mag_AM_TID_META_INT8 = $00000015;
  mag_AM_TID_META_UINT8 = $00000016;
  mag_AM_TID_META_INT16 = $00000017;
  mag_AM_TID_META_UINT16 = $00000018;
  mag_AM_TID_META_INT32 = $00000019;
  mag_AM_TID_META_UINT32 = $0000001A;
  mag_AM_TID_META_BOOL = $0000001B;
  mag_AM_TID_META_STRING = $0000001C;
  mag_AM_TID_META_RATIONAL_UINT32 = $0000001D;
  mag_AM_TID_META_RATIONAL_INT32 = $0000001E;
  mag_AM_TID_META_FLOAT = $0000001F;
  mag_AM_TID_META_DOUBLE = $00000020;
  mag_AM_TID_RAW_DATA = $00000021;
  mag_AM_TID_META_INT64 = $00000022;
  mag_AM_TID_META_UINT64 = $00000023;
  mag_AM_TID_META_STRING32 = $00000024;
  mag_AM_TID_META_STRING64 = $00000025;
  mag_AM_TID_META_STRING128 = $00000026;
  mag_AM_TID_META_STRING255 = $00000027;
  mag_AM_TID_META_STRING1024 = $00000028;
  mag_AM_TID_META_STRING_UNICODE512 = $00000029;
  mag_AM_TID_META_DRECT = $0000002A;

  // Constants for enum enumIGAbsDataType   GearCORE_Lib_TLB
  mag_IG_DATA_LONG = $00000000;
  mag_IG_DATA_BOOLEAN = $00000001;
  mag_IG_DATA_STRING = $00000002;
  mag_IG_DATA_RECTANGLE = $00000003;
  mag_IG_DATA_D_LONG = $00000004;
  mag_IG_DATA_DOUBLE = $00000005;
  mag_IG_DATA_ARRAY = $00000006;
  mag_IG_DATA_DBL_RECTANGLE = $00000007;
  mag_IG_DATA_LUT = $00000008;
  mag_IG_DATA_RATIONAL = $00000009;

// Constants for enum enumIGCompressions    GearCORE_Lib_TLB
  mag_IG_COMPRESSION_NONE = $00000000;
  mag_IG_COMPRESSION_PACKED_BITS = $00000001;
  mag_IG_COMPRESSION_HUFFMAN = $00000002;
  mag_IG_COMPRESSION_CCITT_G3 = $00000003;
  mag_IG_COMPRESSION_CCITT_G4 = $00000004;
  mag_IG_COMPRESSION_CCITT_G32D = $00000005;
  mag_IG_COMPRESSION_JPEG = $00000006;
  mag_IG_COMPRESSION_RLE = $00000007;
  mag_IG_COMPRESSION_LZW = $00000008;
  mag_IG_COMPRESSION_ABIC_BW = $00000009;
  mag_IG_COMPRESSION_ABIC_GRAY = $0000000A;
  mag_IG_COMPRESSION_JBIG = $0000000B;
  mag_IG_COMPRESSION_FPX_SINCOLOR = $0000000C;
  mag_IG_COMPRESSION_FPX_NOCHANGE = $0000000D;
  mag_IG_COMPRESSION_DEFLATE = $0000000E;
  mag_IG_COMPRESSION_IBM_MMR = $0000000F;
  mag_IG_COMPRESSION_ABIC = $00000010;
  mag_IG_COMPRESSION_PROGRESSIVE = $00000011;
  mag_IG_COMPRESSION_EQPC = $00000012;
  mag_IG_COMPRESSION_JBIG2 = $00000013;
  mag_IG_COMPRESSION_LURAWAVE = $00000014;
  mag_IG_COMPRESSION_LURADOC = $00000015;
  mag_IG_COMPRESSION_LURAJP2 = $00000016;
  mag_IG_COMPRESSION_ASCII = $00000017;
  mag_IG_COMPRESSION_RAW = $00000018;
  mag_IG_COMPRESSION_JPEG2K = $00000019;
  mag_IG_COMPRESSION_HDP = $0000001A;


// Constants for enum enumIGTWAINPixelType

  mag_IG_TW_PT_BW = $00000000;
  mag_IG_TW_PT_GRAY = $00000001;
  mag_IG_TW_PT_RGB = $00000002;
  mag_IG_TW_PT_PALETTE = $00000003;
  mag_IG_TW_PT_CMY = $00000004;
  mag_IG_TW_PT_CMYK = $00000005;
  mag_IG_TW_PT_YUV = $00000006;
  mag_IG_TW_PT_YUVK = $00000007;
  mag_IG_TW_PT_CIEXYZ = $00000008;

// Constants for enum enumIGTWAINSupportedSizes

  mag_IG_TW_SS_NONE = $00000000;
  mag_IG_TW_SS_A4LETTER = $00000001;
  mag_IG_TW_SS_B5LETTER = $00000002;
  mag_IG_TW_SS_USLETTER = $00000003;
  mag_IG_TW_SS_USLEGAL = $00000004;
  mag_IG_TW_SS_A5 = $00000005;
  mag_IG_TW_SS_B4 = $00000006;
  mag_IG_TW_SS_B6 = $00000007;
  mag_IG_TW_SS_USLEDGER = $00000009;
  mag_IG_TW_SS_USEXECUTIVE = $0000000A;
  mag_IG_TW_SS_A3 = $0000000B;
  mag_IG_TW_SS_B3 = $0000000C;
  mag_IG_TW_SS_A6 = $0000000D;
  mag_IG_TW_SS_C4 = $0000000E;
  mag_IG_TW_SS_C5 = $0000000F;
  mag_IG_TW_SS_C6 = $00000010;
  mag_IG_TW_SS_4A0 = $00000011;
  mag_IG_TW_SS_2A0 = $00000012;
  mag_IG_TW_SS_A0 = $00000013;
  mag_IG_TW_SS_A1 = $00000014;
  mag_IG_TW_SS_A2 = $00000015;
  mag_IG_TW_SS_A4 = $00000001;
  mag_IG_TW_SS_A7 = $00000016;
  mag_IG_TW_SS_A8 = $00000017;
  mag_IG_TW_SS_A9 = $00000018;
  mag_IG_TW_SS_A10 = $00000019;
  mag_IG_TW_SS_ISOB0 = $0000001A;
  mag_IG_TW_SS_ISOB1 = $0000001B;
  mag_IG_TW_SS_ISOB2 = $0000001C;
  mag_IG_TW_SS_ISOB3 = $0000000C;
  mag_IG_TW_SS_ISOB4 = $00000006;
  mag_IG_TW_SS_ISOB5 = $0000001D;
  mag_IG_TW_SS_ISOB6 = $00000007;
  mag_IG_TW_SS_ISOB7 = $0000001E;
  mag_IG_TW_SS_ISOB8 = $0000001F;
  mag_IG_TW_SS_ISOB9 = $00000020;
  mag_IG_TW_SS_ISOB10 = $00000021;
  mag_IG_TW_SS_JISB0 = $00000022;
  mag_IG_TW_SS_JISB1 = $00000023;
  mag_IG_TW_SS_JISB2 = $00000024;
  mag_IG_TW_SS_JISB3 = $00000025;
  mag_IG_TW_SS_JISB4 = $00000026;
  mag_IG_TW_SS_JISB5 = $00000002;
  mag_IG_TW_SS_JISB6 = $00000027;
  mag_IG_TW_SS_JISB7 = $00000028;
  mag_IG_TW_SS_JISB8 = $00000029;
  mag_IG_TW_SS_JISB9 = $0000002A;
  mag_IG_TW_SS_JISB10 = $0000002B;
  mag_IG_TW_SS_C0 = $0000002C;
  mag_IG_TW_SS_C1 = $0000002D;
  mag_IG_TW_SS_C2 = $0000002E;
  mag_IG_TW_SS_C3 = $0000002F;
  mag_IG_TW_SS_C7 = $00000030;
  mag_IG_TW_SS_C8 = $00000031;
  mag_IG_TW_SS_C9 = $00000032;
  mag_IG_TW_SS_C10 = $00000033;
  mag_IG_TW_SS_USSTATEMENT = $00000034;
  mag_IG_TW_SS_BUSINESSCARD = $00000035;

// Constants for enum enumIGFormats
  mag_IG_FORMAT_UNKNOWN = $00000000;
  mag_IG_FORMAT_ATT = $00000001;
  mag_IG_FORMAT_BMP = $00000002;
  mag_IG_FORMAT_BRK = $00000003;
  mag_IG_FORMAT_CAL = $00000004;
  mag_IG_FORMAT_CLP = $00000005;
  mag_IG_FORMAT_CUT = $00000007;
  mag_IG_FORMAT_DCX = $00000008;
  mag_IG_FORMAT_DIB = $00000009;
  mag_IG_FORMAT_EPS = $0000000A;
  mag_IG_FORMAT_G3 = $0000000B;
  mag_IG_FORMAT_G4 = $0000000C;
  mag_IG_FORMAT_GEM = $0000000D;
  mag_IG_FORMAT_GIF = $0000000E;
  mag_IG_FORMAT_ICA = $00000010;
  mag_IG_FORMAT_ICO = $00000011;
  mag_IG_FORMAT_IFF = $00000012;
  mag_IG_FORMAT_IMT = $00000014;
  mag_IG_FORMAT_JPG = $00000015;
  mag_IG_FORMAT_KFX = $00000016;
  mag_IG_FORMAT_LV = $00000017;
  mag_IG_FORMAT_MAC = $00000018;
  mag_IG_FORMAT_MSP = $00000019;
  mag_IG_FORMAT_MOD = $0000001A;
  mag_IG_FORMAT_NCR = $0000001B;
  mag_IG_FORMAT_PBM = $0000001C;
  mag_IG_FORMAT_PCD = $0000001D;
  mag_IG_FORMAT_PCT = $0000001E;
  mag_IG_FORMAT_PCX = $0000001F;
  mag_IG_FORMAT_PGM = $00000020;
  mag_IG_FORMAT_PNG = $00000021;
  mag_IG_FORMAT_PNM = $00000022;
  mag_IG_FORMAT_PPM = $00000023;
  mag_IG_FORMAT_PSD = $00000024;
  mag_IG_FORMAT_RAS = $00000025;
  mag_IG_FORMAT_SGI = $00000026;
  mag_IG_FORMAT_TGA = $00000027;
  mag_IG_FORMAT_TIF = $00000028;
  mag_IG_FORMAT_TXT = $00000029;
  mag_IG_FORMAT_WPG = $0000002A;
  mag_IG_FORMAT_XBM = $0000002B;
  mag_IG_FORMAT_WMF = $0000002C;
  mag_IG_FORMAT_XPM = $0000002D;
  mag_IG_FORMAT_XRX = $0000002E;
  mag_IG_FORMAT_XWD = $0000002F;
  mag_IG_FORMAT_DCM = $00000030;
  mag_IG_FORMAT_AFX = $00000031;
  mag_IG_FORMAT_FPX = $00000032;
  mag_IG_FORMAT_PJPEG = $00000015;
  mag_IG_FORMAT_AVI = $00000034;
  mag_IG_FORMAT_G32D = $00000035;
  mag_IG_FORMAT_ABIC_BILEVEL = $00000036;
  mag_IG_FORMAT_ABIC_CONCAT = $00000037;
  mag_IG_FORMAT_PDF = $00000038;
  mag_IG_FORMAT_JBIG = $00000039;
  mag_IG_FORMAT_RAW = $0000003A;
  mag_IG_FORMAT_IMR = $0000003B;
  mag_IG_FORMAT_WLT = $0000003D;
  mag_IG_FORMAT_JB2 = $0000003E;
  mag_IG_FORMAT_WL16 = $0000003F;
  mag_IG_FORMAT_MODCA = $00000040;
  mag_IG_FORMAT_PTOCA = $00000041;
  mag_IG_FORMAT_WBMP = $00000042;
  mag_IG_FORMAT_MUL = $00000043;
  mag_IG_FORMAT_CAD = $00000044;
  mag_IG_FORMAT_DWG = $00000045;
  mag_IG_FORMAT_DXF = $00000046;
  mag_IG_FORMAT_EXIF_JPEG = $00000047;
  mag_IG_FORMAT_HPGL = $00000048;
  mag_IG_FORMAT_DGN = $00000049;
  mag_IG_FORMAT_EXIF_TIFF = $0000004A;
  mag_IG_FORMAT_CGM = $0000004B;
  mag_IG_FORMAT_QUICKTIMEJPEG = $0000004C;
  mag_IG_FORMAT_SVG = $0000004D;
  mag_IG_FORMAT_DWF = $0000004E;
  mag_IG_FORMAT_U3D = $0000004F;
  mag_IG_FORMAT_XPS = $00000050;
  mag_IG_FORMAT_SCI_CT = $0000005B;
  mag_IG_FORMAT_CUR = $00000060;
  mag_IG_FORMAT_LURADOC = $00000061;
  mag_IG_FORMAT_LURAWAVE = $00000062;
  mag_IG_FORMAT_LURAJP2 = $00000063;
  mag_IG_FORMAT_JPEG2K = $00000064;
  mag_IG_FORMAT_JPX = $00000065;
  mag_IG_FORMAT_POSTSCRIPT = $00000066;
  mag_IG_FORMAT_MJ2 = $00000067;
  mag_IG_FORMAT_DCRAW = $00000068;
  mag_IG_FORMAT_QUICKTIME = $00000069;
  mag_IG_FORMAT_AFP = $0000006A;
  mag_IG_FORMAT_CIFF = $0000006B;
  mag_IG_FORMAT_DNG = $0000006C;
  mag_IG_FORMAT_LZW = $0000006D;
  mag_IG_FORMAT_HDP = $0000006E;
  mag_IG_FORMAT_DIRECTSHOW = $0000006F;
  mag_IG_FORMAT_PSB = $00000070;
  mag_IG_FORMAT_XMP = $00000071;
  mag_IG_FORMAT_HLDCRAW = $00000072;

implementation

{ TMagTwain }



function TMagTwain.MagAcquireToPage(mag4Vgear : Tmag4VGear) : boolean;
begin
try
  FIGTwainCtl1.AcquireToPage(mag4VGear.GetCurrentPage);  // this is original

 MagIGErrorCheck;
 result := true;
except
  on e:exception do
  begin
  magappmsg('','Exception : ' + e.Message);
  result := false;
  end;
end;
end;


function TMagTwain.MagAcquireToFile(filename : string; pagecount : integer; SaveFmt : integer): boolean;
var fn1, fnPath, fnfull, fnExt, mp : string;
ml : integer;
nofile : boolean;
success : boolean;

begin


FIGTwainCtl1.SavePagesSeparately := false;

nofile := false;
if not IsSourceOPen then
  begin
    result := false;
    magappmsg('d','Acquire To File: Source not open. Operation canceled.');
    exit;
  end;

    
{  These are set when each Config Radio button is clicked }
 { FmIGSaveFormat := mag_IG_SAVE_TIF_PACKED;
   FmIGScanFormat := mag_IG_FORMAT_TIF;
  FmIGScanPixelType := mag_IG_TW_PT_PALETTE;
  FmIGScanCompression := mag_IG_COMPRESSION_NONE;
  FmIGScanBitDepth := 8;}

  SetCapGroup1(CapX.mIGScanFormat,CapX.mIGScanPixelType,CapX.mIGScanCompression,CapX.mIGScanBitDepth);

(*
   IG_SAVE_PDF_UNCOMP = $00000038;
  IG_SAVE_PDF_JPG = $00060038;
  IG_SAVE_PDF_G3 = $00030038;
  IG_SAVE_PDF_G3_2D = $00050038;
  IG_SAVE_PDF_G4 = $00040038;
  IG_SAVE_PDF_RLE = $00070038;
  IG_SAVE_PDF_DEFLATE = $000E0038;
  IG_SAVE_PDF_LZW = $00080038;
*)

ml :=  maglength(filename,'.');
mp := magpiece(filename,'.',ml-1);
mp := mp+'1';
fn1 := magsetpiece(filename,'.',ml-1,mp);

{ These functions work fine, but above also works }
{  example filename := c:\temp\scanfile.tif

 fnPath := ExtractFilePath(filename);  // fn :=  'c:\temp\'
 fnfull := ExtractFileName(filename);  //  fnfull = 'scanfile.tif'
 fnExt := ExtractFileExt(filename);    //   fnExt := '.tif'
 fn1 := '\' + fnPath + '1' + fnExt;     }

  if CapX.m140PDFConvert then
  begin
    case CapX.mIGScanFormat of
        mag_IG_FORMAT_BMP :  CapX.mIGSaveFormat := IG_SAVE_PDF_JPG;
        mag_IG_FORMAT_JPG :  CapX.mIGSaveFormat := IG_SAVE_PDF_JPG;
        mag_IG_FORMAT_TIF :  CapX.mIGSaveFormat := IG_SAVE_PDF_G4;
        else CapX.mIGSaveFormat := IG_SAVE_PDF_JPG;
    end;
    magappmsg('','Scanning to PDF......');
    application.ProcessMessages;
  end;

if (not CapX.m140MultSources) and (not CapX.m140CombineScans) then
  begin
   deletefile(filename);
   deletefile(fn1);
  end;

 {This is for Testing : Scan multiple JPG's from the Document Feeder, save all as single JPG's}
 if (CapX.mIGSaveFormat = IG_SAVE_JPG)  and (pagecount = -1)
    then  FIGTwainCtl1.SavePagesSeparately := true;

// true  is just a quick test.
//FIGTwainCtl1.SavePagesSeparately := true;

FIGTwainCtl1.AcquireToFile(filename, pagecount, CapX.mIGSaveFormat);
 MagIGErrorCheck;
 //140 get to field.   Above OUT,   IF MagIGErrorCheck Below IN
(* if MagIGErrorCheck  then
  begin
   magappmsg('de','error Acquiring to file : ' + filename);
   exit;
  end;
  *)

//test/   FIGTwainCtl1.CloseSource;
//test/  application.ProcessMessages;
  //140 TEST
//if not self.IsSourceOpen then
//  begin
//    self.SourceOpenDefault;
//  end;


//GetFileInfo(FileName As String) As IGTWAINFileInfo
//TwainInfo := FIGTwainCtl1.GetFileInfo(FileName);

 if not fileexists(filename) then
   if fileexists(fn1) then
     begin
      renamefile(fn1,filename);
     end
     else
     begin
     nofile := true;
     result := false;
     magappmsg('','Acquire To File: No file created. Exiting.');
     exit;
     end;
result := true;
//FIGTwainCtl1.CloseFile(TwainInfo);
end;


function TMagTwain.MagIGErrorCheck: boolean;
var  i : integer;
    errrec     : IGResultRecord;
    s : string;
begin
try
FLastErrorList.Clear;
FLastErrorCount := GetIGManager.IGCoreCtrl.Result.ErrorCount   ;
Result := (FLastErrorCount > 0);

//winmsg('Error Count: ' + inttostr(errct));
if FLastErrorCount > 0 then
 begin
  for I := 1 to FLastErrorCount  do
   begin
   errrec :=  GetIGManager.IGCoreCtrl.Result.GetError(i-1);
   s := s + inttostr(i) + ' ' + errrec.ExtraText  + #13  + inttostr(errrec.ErrCode)+ #13;
   FLastErrorList.Add(inttostr(i) + ': ' + inttostr(errrec.ErrCode)+ ' - ' + errrec.ExtraText)
   end;
 magappmsg('','Errors: ' + #13 + s);
 end;
finally
  GetIGManager.IGCoreCtrl.Result.Clear;
end;
end;

procedure TMagTwain.MagIGErrorInit(UseErrorCount : boolean = true);
begin
(*
// Constants for enum enumIGErrorHandlingFlags
type
  enumIGErrorHandlingFlags = TOleEnum;
const
  IG_ERR_NO_ACTION = $00000000;
  IG_ERR_OLE_ERROR = $00000001;
  IG_ERR_EVENT_ERROR = $00000002;
  IG_ERR_EVENT_WARNING = $00000004;
*)

  GetIGManager.IGCoreCtrl.Result.Clear;


  if UseErrorCount then
  begin
  GetIGManager.IGCoreCtrl.Result.NotificationFlags := IG_ERR_NO_ACTION;
  end
  else
  begin
  GetIGManager.IGCoreCtrl.Result.NotificationFlags := IG_ERR_OLE_ERROR;
  end;

end;


procedure TMagTwain.CreateTWAINControls(ctl : Twincontrol);
var winhnd : Thandle;
    hnd  : thandle;
    s : string;
begin

  FIGDSarr := nil;
  FIGDSdft := 0;

// no luck with this ...  IGTwainCtl1 := IGTwainCtl1.CreateParented(self.Handle);
  FIGTwainCtl1 := TIGTwainCtl.Create(ctl);
  FIGTwainCtl1.Parent := ctl;


     magappmsg('','winhnd ' + inttostr(FIGTwainCtl1.WindowHandle) + '  hnd ' + inttostr(FIGTwainCtl1.Handle));
     FIGTwainCtl1.WindowHandle := FIGTwainCtl1.Handle;
     magappmsg('','winhnd ' + inttostr(FIGTwainCtl1.WindowHandle) + '  hnd ' + inttostr(FIGTwainCtl1.Handle));

  GetIGManager.IGCoreCtrl.AssociateComponent(FIGTwainCtl1.ComponentInterface);
  FIGTwainCtl1.UseUI := true;

  MagIGErrorInit(true);

end;

constructor TMagTwain.Create;
begin
inherited Create;
// code here
  FlastErrorCount :=0 ;
  FlastErrorList := tstringlist.create;
  FJPEGQuality := 95;

end;

destructor TMagTwain.Destroy;
begin
  FlastErrorList.free ;


// code here
  inherited Destroy;
end;

function TMagTwain.GetIsSourceOpen: boolean;
begin
result := FDSIsOpen;
end;

function TMagTwain.GetLastErrorCount: integer;
begin
 result := FLastErrorCount;
end;

procedure TMagTwain.GetLastErrorList(var t: tStrings);
begin
 t.clear;
 t.addstrings(FLastErrorList);
end;

function TMagTwain.GetSavePagesSeparately: boolean;
begin
result :=    FIGtwainCtl1.SavePagesSeparately ;
end;

procedure TMagTwain.GetTwainVersion(var t: tstrings);
var
 TwainInfo : IIGTwainInfo;
 major, minor : integer;
begin
TwainInfo := FIGTwainCtl1.GetTWAINInfo;
major := twaininfo.VersionMajor;
minor := twaininfo.VersionMinor;
t.add('Twain Version info:');
t.add('Major: ' + inttostr(major));
t.add('Minor: ' + inttostr(minor));

magappmsg('','TW Ver major: ' + inttostr(major) + ' TW Ver minor: ' + inttostr(minor));     //<<< Okay here.
end;

function TMagTwain.GetUseUI: boolean;
begin
  result :=   FIGTwainCtl1.UseUI ;
end;

procedure TMagTwain.InitTwainControls(Ctl: TwinControl);
begin
   CreateTWAINControls(ctl);
end;

procedure TMagTwain.LoadCustomDSData(dsfile: string);
begin
  FIGTwainctl1.LoadCustomDSData(dsfile);
end;


procedure TMagTwain.GetDSSourcesList(dsList : Tstrings; var dsDft : integer);
var
 i : integer;
begin
SourceClose;
dsList.Clear;

FDS := FIGTwainCtl1.GetDSInfo;
if MagIGErrorCheck then
  begin
  magappmsg('','Errors During GetDSSourcesList');
  end
  else
  begin
  FIGDSarr := nil;
  FIGDSdft := 0;
  FIGDSarr := FDS.DataSources;
  FIGDSdft := FDS.DefaultDSIndex;
  dsDft := FIGDSDft;
  for i := 0 to FIGDSarr.Size - 1 do
      begin
      dslist.Add(FIGDSarr.Item[i]);
      //magappmsg('',inttostr(i) + '  ' + FIGDSarr.Item[i]);
      end;
  magappmsg('','default source : ' + inttostr(FIGDSdft));
  end;
end;

function TMagTwain.LoadDSSources: boolean;
var
 i : integer;
  t : Tstrings;
  s : string;

begin
SourceClose;
//t := Tstringlist.Create;

FDS := FIGTwainCtl1.GetDSInfo;
if MagIGErrorCheck then
  begin
  magappmsg('','Errors During GetDSInfo');
  end
  else
  begin
  FIGDSarr := nil;
  FIGDSdft := 0;
  FIGDSarr := FDS.DataSources;
  FIGDSdft := FDS.DefaultDSIndex;
  for i := 0 to FIGDSarr.Size - 1 do
      begin
      magappmsg('',inttostr(i) + '  ' + FIGDSarr.Item[i]);
      end;
  magappmsg('','default source : ' + inttostr(FIGDSdft));
  end;
end;

function TMagTwain.SourceOpenSelect() : boolean;

var srcname, s : widestring;

 errct, i : integer;
 errrec     : IGResultRecord;
 CurUseUI : boolean;
begin
try
CurUseUI := FIGTwainCtl1.UseUI;  // save Cur State of Use UI
FIGTwainCtl1.UseUI := true; // Change State of Use UI to SourceUI
result := FDSIsopen;

srcname := '';

     GetIGManager.IGCoreCtrl.Result.NotificationFlags := IG_ERR_NO_ACTION;
     GetIGManager.IGCoreCtrl.Result.Clear;
    // magigmanager.IGCoreCtrl.Result.NotificationFlags := IG_ERR_OLE_ERROR;
try

SourceClose;
result := FDSIsopen;
FIGTwainCtl1.OpenSource(srcname);

application.processmessages;

errct := GetIGManager.IGCoreCtrl.Result.ErrorCount   ;
if errct = 0
  then FDSIsOpen := true
  else FDSIsOpen := False;
result := FDSIsopen;

MagIGErrorCheck;

except
  on e:exception do
   begin
   magappmsg('','Opening Source Exception: ' + e.message);
   FDSIsOpen := false;
   end;
end;

finally
result := FDSIsopen;
FIGTwainCtl1.UseUI  := curUseUI; // change UI back to Checked State.
end;
end;


function TMagTwain.SourceOpenDefault: boolean;
var srcname, s : widestring;

 errct, i : integer;
 errrec     : IGResultRecord;
 CurUseUI : boolean;
begin
try
result := FDSIsopen;
CurUseUI := FIGTwainCtl1.UseUI;  // save Cur State of Use UI
FIGTwainCtl1.UseUI := False; // Change State of Use UI to SourceUI

srcname := '';

     GetIGManager.IGCoreCtrl.Result.NotificationFlags := IG_ERR_NO_ACTION;
     GetIGManager.IGCoreCtrl.Result.Clear;
    // magigmanager.IGCoreCtrl.Result.NotificationFlags := IG_ERR_OLE_ERROR;
try
SourceClose;
result := FDSIsopen;

FIGTwainCtl1.OpenSource(srcname);

application.processmessages;

errct := GetIGManager.IGCoreCtrl.Result.ErrorCount   ;
if errct = 0
  then FDSIsOpen := true
  else FDSIsOpen := false;
result := FDSIsOpen;


MagIGErrorCheck;

except
  on e:exception do
   begin
   magappmsg('','Open Default Source Exception: ' + e.message);
   FDSIsOPen := false;
   end;
end;

finally
result := FDSIsopen;
FIGTwainCtl1.UseUI  := curUseUI; // change UI back to Checked State.
end;
end;




function TMagTwain.SourceOpenByIndex(srcIndex : string = ''): boolean;
var I :integer;
    curds : string;
begin
try
result := FDSIsOpen;
try
if FDSIsOpen then SourceClose;
result := FDSIsopen;

if FIGDSarr = nil then
  begin
   if not LoadDSSources then exit;
   application.ProcessMessages;
  end;

 i := strtoint(srcIndex);
 CurDs := FIGDSarr.Item[i];

FIGTwainCtl1.OpenSource(CurDS);

if MagIGErrorCheck
   then FDSIsOpen := false
   else FDSIsOpen := true;
result := FDSIsopen;
except
FDSIsOPen := false;
 magappmsg('','not integer value');
end;
finally
  result := FDSIsOPen;
end;
end;


procedure TMagTwain.SourceShowUI;
begin
  if not FDSIsOpen  then
      SourceOpenDefault;
  if not FDSIsOpen  then
  begin
    magappmsg('d','Twain Source is not Open');
    exit;
  end;
  FIGTwainCtl1.ShowSourceUI;
  MagIGErrorCheck;
  SourceClose;
end;

procedure TMagTwain.SourceClose;
begin
if FDSIsOpen then
  begin
  FIGTwainCtl1.CloseSource;
  MagIGErrorCheck;
  FDSIsOpen := false;
    FIGDSarr := nil;
    FIGDSdft := 0 ;
  end;
end;

Procedure TmagTwain.CloseFile();
begin
  ///
  ///
end;

procedure TMagTwain.SaveCustomDSData(filename: string);
begin
    FIGtwainCtl1.SaveCustomDSData(filename);
end;

procedure TMagTwain.SetSavePagesSeparately(value: boolean);
begin
     FIGtwainCtl1.SavePagesSeparately := value;
end;

procedure TMagTwain.SetSaveTIF;
var capOneValue :IGTWAINCapOneValue ;
begin
if not FDSIsOpen then
  begin
   magappmsg('s','TWAIN Device not open.  Action canceled.');
   exit; {need to rethink this,  but not being used in p129.}
  end;

capOneValue := IGTWAINCapOneValue(FIGTwainCtl1.CreateCapability(IG_TW_ON_ONEVALUE)) ;
capOneValue.ID := IG_TW_ICAP_IMAGEFILEFORMAT ;
capOneValue.ItemType := AM_TID_META_UINT16  ;
capOneValue.Value.ChangeType(IG_DATA_LONG);
capOneValue.Value.Long := IG_FORMAT_TIF ;
FIGTwainCtl1.SetCapability(capOneValue, IG_TW_MSG_SET );

(*    example from Help File.
Dim capOneValue As IGTWAINCapOneValue

Set capOneValue =
frmMain.IGTwainCtl1.CreateCapability(IG_TW_ON_ONEVALUE)
capOneValue.ID = IG_TW_ICAP_IMAGEFILEFORMAT
capOneValue.ItemType = AM_TID_META_UINT16
capOneValue.Value.ChangeType IG_DATA_LONG
capOneValue.Value.Long = IG_FORMAT_TIF
frmMain.IGTwainCtl1.SetCapability capOneValue, IG_TW_MSG_SET
*)


MagIGErrorCheck;
end;

procedure TMagTwain.SetUseUI(const Value: boolean);
begin
  FIGTwainCtl1.UseUI := value;
end;

procedure  TMagTwain.SetSaveJPG();
var capOneValue :IGTWAINCapOneValue ;
begin
if not FDSIsOpen then
  begin
   magappmsg('s','TWAIN Device not open.  Action canceled.');
   exit; {need to rethink this,  but not being used in p129.}
  end;

capOneValue := IGTWAINCapOneValue(FIGTwainCtl1.CreateCapability(IG_TW_ON_ONEVALUE)) ;
capOneValue.ID := IG_TW_ICAP_IMAGEFILEFORMAT ;
capOneValue.ItemType := AM_TID_META_UINT16  ;
capOneValue.Value.ChangeType(IG_DATA_LONG);
capOneValue.Value.Long := IG_FORMAT_JPG ;
FIGTwainCtl1.SetCapability(capOneValue, IG_TW_MSG_SET );

MagIGErrorCheck;
end;


procedure TMagTwain.SetJPEGQuality(value : integer);
var capOneValue :IGTWAINCapOneValue ;
begin
if not FDSIsOpen then
  begin
   magappmsg('s','TWAIN Device not open.  Action canceled.');
   exit; {need to rethink this,  but not being used in p129.}
  end;


//AM_TID_META_UINT16;
if value = 0 then value := 95;
if FJPEGQuality <> value then FJPEGQuality := value;

capOneValue := IGTWAINCapOneValue(FIGTwainCtl1.CreateCapability(IG_TW_ON_ONEVALUE)) ;
capOneValue.ID := IG_TW_ICAP_JPEGQUALITY ;
capOneValue.ItemType := AM_TID_META_UINT16  ;
capOneValue.Value.ChangeType(IG_DATA_LONG);
capOneValue.Value.long :=  value;
FIGTwainCtl1.SetCapability(capOneValue, IG_TW_MSG_SET );
end;


procedure TMagTwain.SetResolution(horiz, vert: string);
//var capRange :IGTWAINCapRange ;
//d : double;
//begin
var capOneValue :IGTWAINCapOneValue ;
begin
try
if not FDSIsOpen then
  begin
   magappmsg('s','TWAIN Device not open.  Action canceled.');
   exit; {need to rethink this,  but not being used in p129.}
  end;



  //Set the resolution units
  capOneValue := IGTWAINCapOneValue(FIGTwainCtl1.CreateCapability(IG_TW_ON_ONEVALUE)) ;
  capOneValue.ID := IG_TW_ICAP_UNITS ;
  capOneValue.ItemType := AM_TID_META_UINT16;
  capOneValue.Value.ChangeType(IG_DATA_LONG);   {Error if IG_DATA_DOUBLE}
  capOneValue.Value.Long := IG_TW_UN_INCHES ; //0;  // IG_TW_UN_INCHES     //Inches
  FIGTwainCtl1.SetCapability(capOneValue, IG_TW_MSG_SET );


capOneValue := IGTWAINCapOneValue(FIGTwainCtl1.CreateCapability(IG_TW_ON_ONEVALUE)) ;
capOneValue.ID := IG_TW_ICAP_XRESOLUTION ;
capOneValue.ItemType := AM_TID_META_DOUBLE  ;
capOneValue.Value.ChangeType(IG_DATA_DOUBLE);   {Error if IG_DATA_DOUBLE}
capOneValue.Value.double :=  strtoFloat(horiz); //  300.0 works.
FIGTwainCtl1.SetCapability(capOneValue, IG_TW_MSG_SET );


capOneValue := IGTWAINCapOneValue(FIGTwainCtl1.CreateCapability(IG_TW_ON_ONEVALUE)) ;
capOneValue.ID := IG_TW_ICAP_YRESOLUTION ;
capOneValue.ItemType := AM_TID_META_DOUBLE  ;
capOneValue.Value.ChangeType(IG_DATA_DOUBLE);
capOneValue.Value.double := strtoFloat(vert); //300.0 ;  // strtoInt(edtVres.Text)
FIGTwainCtl1.SetCapability(capOneValue, IG_TW_MSG_SET );


 except on e:exception do
  magappmsg('','Exception: ' + e.message);
 end;
(*



//d := strtofloat(edtHres.Text);
// IG_TW_ICAP_XRESOLUTION
// IG_TW_ICAP_YRESOLUTION
capRange := IGTWAINCapRange(IGTwainCtl1.CreateCapability(IG_TW_ON_RANGE)) ;
capRange.ID := IG_TW_ICAP_XRESOLUTION ;  // Horiz?
capRange.ItemType := AM_TID_META_UINT16; //AM_TID_META_UINT16  ;   // AM_TID_META_DOUBLE
capRange.CurrentValue.ChangeType(IG_DATA_DOUBLE);
//capRange.CurrentValue.double := strtoint(edtHres.text) ;
capRange.CurrentValue.Long := strtoInt(edtHres.Text);
IGTwainCtl1.SetCapability(capRange, IG_TW_MSG_SET );

MagIGErrorCheck;


// IG_TW_ICAP_XRESOLUTION
// IG_TW_ICAP_YRESOLUTION
capRange := IGTWAINCapRange(IGTwainCtl1.CreateCapability(IG_TW_ON_RANGE)) ;
capRange.ID := IG_TW_ICAP_YRESOLUTION ;  // Vert?
capRange.ItemType := AM_TID_META_DOUBLE; //AM_TID_META_UINT16  ;         // AM_TID_META_DOUBLE
capRange.CurrentValue.ChangeType(IG_DATA_DOUBLE);
capRange.CurrentValue.double := strtoint(edtVres.text) ;
IGTwainCtl1.SetCapability(capRange, IG_TW_MSG_SET );

MagIGErrorCheck;
*)
end;


procedure TMagTwain.LoadCapabilities(var rlist : Tstrings; capDetails : boolean = true);
var
 capArray : IGTWAINCapArray; //As IGTWAINCapArray
 capEnum : IGTWAINCapEnumeration; //As IGTWAINCapEnumeration
 cap : IIGTwainCap; // As IIGTWAINCap
 strCap, s : string; // As String
 i : integer; //Long
 hexstr : string;
 t : tstrings;

begin
t := tstringlist.create;
try
     GetIGManager.IGCoreCtrl.Result.NotificationFlags := IG_ERR_NO_ACTION;
     GetIGManager.IGCoreCtrl.Result.Clear;
 //   ' Hide the capability controls
 //   UpdateCapabilityControls 0

 //   ' Populate capabilities
    cap := FIGTwainCtl1.GetCapability(IG_TW_CAP_SUPPORTEDCAPS, IG_TW_MSG_GET);
    If cap.ContainerType = IG_TW_ON_ARRAY Then
        begin //added
         capArray := IGTwainCapArray(cap);
        For i := 0 To capArray.Values.Size - 1 do
        begin
        if not capDetails
          then rlist.Add(GetCapabilityIDDesc(caparray.Values.Long[i]))  // was winmsg(Get...
          else
             begin
             t.Clear;
             rlist.Add(' ---------------------- ' );
             MagTwain1.LoadOneCapability(caparray.Values.Long[i],t);
             rlist.AddStrings(t);
             end;
        end;
            ///If CapToStr(capArray.Values.Long(i), strCap) Then
            ///     begin   //added.
            ///    lstSupportedCaps.AddItem strCap
            ///    lstSupportedCaps.ItemData(lstSupportedCaps.NewIndex) = capArray.Values.Long(i)
            ///     end;  //End If
        ///Next i
        end // addedd
       else
          begin
          rlist.Add('Else ');
          end;
        (*    Else
      begin
        Set capEnum = cap
        For i = 0 To capEnum.Values.Size - 1
            If CapToStr(capEnum.Values.Long(i), strCap) Then
                lstSupportedCaps.AddItem strCap
                lstSupportedCaps.ItemData(lstSupportedCaps.NewIndex) = capEnum.Values.Long(i)
            End If
        Next i
      end; //End If
  *)

 //   lstSupportedCaps.ListIndex = 0

//    ' Populate messages
(*    cboMsg.AddItem "IG_TW_MSG_GET"
    cboMsg.ItemData(cboMsg.NewIndex) = IG_TW_MSG_GET
    cboMsg.AddItem "IG_TW_MSG_GETCURRENT"
    cboMsg.ItemData(cboMsg.NewIndex) = IG_TW_MSG_GETCURRENT
    cboMsg.AddItem "IG_TW_MSG_GETDEFAULT"
    cboMsg.ItemData(cboMsg.NewIndex) = IG_TW_MSG_GETDEFAULT

    cboMsg.ListIndex = 0

    Exit Sub
*)
finally
  t.free;
end;

end;


procedure TMagTwain.MagSetCapability(mID : string; mItemType,mChangeType : integer; mVal : string)  ;
//(ed : Tedit; cmb : TComboBox;  vItemType, vChangeType: integer);
var capOneValue :IGTWAINCapOneValue ;
begin
if not FDSIsOpen then
  begin
   magappmsg('s','TWAIN Device not open.  Action canceled.');
   exit; {need to rework this, but can't have this error, it'll force a reboot}
  end;


capOneValue := IGTWAINCapOneValue(FIGTwainCtl1.CreateCapability(IG_TW_ON_ONEVALUE)) ;
capOneValue.ID :=   strtoint(mID)  ;  //IG_TW_ICAP_COMPRESSION ;        //IG_TW_ICAP_COMPRESSION
capOneValue.ItemType := mItemType  ;
capOneValue.Value.ChangeType(mChangeType);
capOneValue.Value.Long := strtoint(mVal) ; //IG_FORMAT_TIF ;
FIGTwainCtl1.SetCapability(capOneValue, IG_TW_MSG_SET );
end;

procedure TMagTwain.MagSetCapability(mID, mItemType, mChangeType, mVal: integer);
var capOneValue :IGTWAINCapOneValue ;
begin
if not FDSIsOpen then
  begin
   magappmsg('s','TWAIN Device not open.  Action canceled.');
   exit; {need to rework this, but can't have this error, it'll force a reboot}
  end;


capOneValue := IGTWAINCapOneValue(FIGTwainCtl1.CreateCapability(IG_TW_ON_ONEVALUE)) ;
capOneValue.ID :=  mID  ;                //ex:  IG_TW_ICAP_COMPRESSION ;
capOneValue.ItemType := mItemType  ;
capOneValue.Value.ChangeType(mChangeType);
capOneValue.Value.Long := mVal ;         //ex : IG_FORMAT_TIF ;
FIGTwainCtl1.SetCapability(capOneValue, IG_TW_MSG_SET );
end;

procedure TMagTwain.SetCapGroup1(pFormat,pPixelType,pCompression,pBitDepth: Integer);
begin
if not FDSIsOpen then
  begin
   magappmsg('s','TWAIN Device not open.  Action canceled.');
   exit; {need to rework this, but can't have this error, it'll force a reboot}
  end;


try
  MagSetCapability(mag_IG_TW_ICAP_IMAGEFILEFORMAT,mag_AM_TID_META_UINT16,mag_IG_DATA_LONG
                          ,pFormat);
  MagSetCapability(mag_IG_TW_ICAP_PIXELTYPE,mag_AM_TID_META_UINT16,mag_IG_DATA_LONG
                          ,pPixelType);
  MagSetCapability(mag_IG_TW_ICAP_COMPRESSION,mag_AM_TID_META_UINT16,mag_IG_DATA_LONG
                          ,pCompression);
  MagSetCapability(mag_IG_TW_ICAP_BITDEPTH,mag_AM_TID_META_UINT16,mag_IG_DATA_LONG
                          ,pBitDepth);

  if pformat =  mag_IG_FORMAT_JPG then  self.SetJPEGQuality(FJPEGQuality);

except
  { TODO -o129 : Put exception handling.}
end;
end;

procedure TMagTwain.SetCompression(mCompression : integer);
var capOneValue :IGTWAINCapOneValue ;
begin
if not FDSIsOpen then
  begin
   magappmsg('s','TWAIN Device not open.  Action canceled.');
   exit; {need to rethink this,  but not being used in p129.}
  end;

capOneValue := IGTWAINCapOneValue(FIGTwainCtl1.CreateCapability(IG_TW_ON_ONEVALUE)) ;
capOneValue.ID := IG_TW_ICAP_COMPRESSION ;        //IG_TW_ICAP_COMPRESSION
capOneValue.ItemType := AM_TID_META_UINT16  ;
capOneValue.Value.ChangeType(IG_DATA_LONG);
capOneValue.Value.Long := mCompression ; 
FIGTwainCtl1.SetCapability(capOneValue, IG_TW_MSG_SET );
end;





procedure TMagTwain.LoadOneCapability(capint : integer; rlist : tstrings);
var
 capArray : IGTWAINCapArray; //As IGTWAINCapArray
 capEnum : IGTWAINCapEnumeration; //As IGTWAINCapEnumeration
 capOneValue : IGTWAINCapOneValue;
 capRange : IGTWAINCapRange;
 cap : IIGTwainCap; // As IIGTWAINCap
 strCap, s : string; // As String
 i : integer; //Long
 IGdataArr1 : IGDataArray;
 hexstr, str : string;
  capdesctemp : STRING;
begin
capDescTEmp := 'Error';


   capDescTemp := (GetCapabilityIDDesc(capint));
     GetIGManager.IGCoreCtrl.Result.NotificationFlags := IG_ERR_NO_ACTION;
     GetIGManager.IGCoreCtrl.Result.Clear;
//    cap := IGTwainCtl1.GetCapability(IG_TW_ICAP_IMAGEFILEFORMAT, IG_TW_MSG_GET);
  try
    cap := FIGTwainCtl1.GetCapability(capint, IG_TW_MSG_GET);
// rlist.add(GetContainerDesc(cap.ContainerType));
 if MagIGErrorCheck  then
  begin
   rlist.Add('error Check during GetCapability , exit function.');
   rlist.add(capDescTemp);
  exit;
  end;
    //winmsg(GetContainerDesc(cap.ContainerType),false);
   case cap.ContainerType of

      IG_TW_ON_ARRAY :   ShowCapArray(IGTwainCapArray(cap),rlist);
      IG_TW_ON_ENUMERATION :   ShowCapEnum(IGTWAINCapEnumeration(cap),rlist);
      IG_TW_ON_ONEVALUE  :   ShowCapOneValue(IGTWAINCapOneValue(cap),rlist);
      IG_TW_ON_RANGE :  ShowCapRange(IGTWAINCapRange(cap),rlist);
    end;


// memo1.Lines.AddStrings();
// if self.cbUseForm.checked then  form1.Memo1.Lines.AddStrings(t);

(*    If cap.ContainerType = IG_TW_ON_ARRAY Then
        begin //added
        ShowCapArray(IGTwainCapArray(cap),t);
        end ;

    If cap.ContainerType = IG_TW_ON_ENUMERATION Then
        begin //added
        ShowCapEnum(IGTWAINCapEnumeration(cap),t);
        end;

    If cap.ContainerType = IG_TW_ON_ONEVALUE  Then
        begin //added
        ShowCapOneValue(IGTWAINCapOneValue(cap),t);
        end;
    If cap.ContainerType = IG_TW_ON_RANGE  Then
        begin //added
        ShowCapRange(IGTWAINCapRange(cap),t);
        end;
                *)


        (*         IGdataArr1 :=   capEnum.Values;
    Case caparray.Values.DataType of
         IG_DATA_LONG  :
            Str := inttostr(IGdataArr1.Long[i]);
        IG_DATA_BOOLEAN    :
            Str := booltostr(IGdataArr1.Boolean[i]);
        // IG_DATA_DOUBLE   :
        //    Str := realtostr(IGdataArr1.Double(i) ;
         //IG_DATA_DBL_RECTANGLE :
         //  rect = dataArray.GetDoubleRectangleCopy(lngIndex)
         //   DataArrayToStr = CStr(rect.Left) + ", " + CStr(rect.Top) + ", " + _
         //   CStr(rect.Right) + ", " + CStr(rect.Bottom)
         IG_DATA_STRING  :
            Str := IGdataArr1.String_[i];
         Else
            Str := 'Unknown Data Type = ' + inttostr(IGdataArr1.DataType) ;
         winmsg('Str: ' + str);
      end; {case}



        end;  *)
            ///If CapToStr(capArray.Values.Long(i), strCap) Then
            ///     begin   //added.
            ///    lstSupportedCaps.AddItem strCap
            ///    lstSupportedCaps.ItemData(lstSupportedCaps.NewIndex) = capArray.Values.Long(i)
            ///     end;  //End If
        ///Next i
except
  on e:exception do
     begin
       rlist.add('Exception , LoadOneCapability : ' + e.message);
       rlist.add(capDescTemp);
     end;
  end;


 end ;


function  TMagTwain.GetCapabilityIDDesc(TWCap : integer ):string;
var strcap , Hexstr : string;
begin
          strcap := '('+ inttostr(TWCap) + ')';
          hexstr := inttohex(TWCap,6);
          //s := caparray.
      Result := ('Cap: '+ hexstr+ ' '  + strcap + '  ' + GetCapabilityDesc(TWCap))

end;


function  TMagTwain.GetCapabilityDesc(TWCap : integer ):string;
begin

case TWcap of
  IG_TW_CAP_CUSTOMBASE : result := 'CAP_CUSTOMBASE';
  IG_TW_CAP_XFERCOUNT : result := 'CAP_XFERCOUNT';
  IG_TW_ICAP_COMPRESSION : result := 'ICAP_COMPRESSION';
  IG_TW_ICAP_PIXELTYPE : result := 'ICAP_PIXELTYPE';
  IG_TW_ICAP_UNITS : result := 'ICAP_UNITS';
  IG_TW_ICAP_XFERMECH : result := 'ICAP_XFERMECH';
  IG_TW_CAP_AUTHOR : result := 'CAP_AUTHOR';
  IG_TW_CAP_CAPTION : result := 'CAP_CAPTION';
  IG_TW_CAP_FEEDERENABLED : result := 'CAP_FEEDERENABLED';
  IG_TW_CAP_FEEDERLOADED : result := 'CAP_FEEDERLOADED';
  IG_TW_CAP_TIMEDATE : result := 'CAP_TIMEDATE';
  IG_TW_CAP_SUPPORTEDCAPS : result := 'CAP_SUPPORTEDCAPS';
  IG_TW_CAP_EXTENDEDCAPS : result := 'CAP_EXTENDEDCAPS';
  IG_TW_CAP_AUTOFEED : result := 'CAP_AUTOFEED';
  IG_TW_CAP_CLEARPAGE : result := 'CAP_CLEARPAGE';
  IG_TW_CAP_FEEDPAGE : result := 'CAP_FEEDPAGE';
  IG_TW_CAP_REWINDPAGE : result := 'CAP_REWINDPAGE';
  IG_TW_CAP_INDICATORS : result := 'CAP_INDICATORS';
  IG_TW_CAP_SUPPORTEDCAPSEXT : result := 'CAP_SUPPORTEDCAPSEXT';
  IG_TW_CAP_PAPERDETECTABLE : result := 'CAP_PAPERDETECTABLE';
  IG_TW_CAP_UICONTROLLABLE : result := 'CAP_UICONTROLLABLE';
  IG_TW_CAP_DEVICEONLINE : result := 'CAP_DEVICEONLINE';
  IG_TW_CAP_AUTOSCAN : result := 'CAP_AUTOSCAN';
  IG_TW_CAP_THUMBNAILSENABLED : result := 'CAP_THUMBNAILSENABLED';
  IG_TW_CAP_DUPLEX : result := 'CAP_DUPLEX';
  IG_TW_CAP_DUPLEXENABLED : result := 'CAP_DUPLEXENABLED';
  IG_TW_CAP_ENABLEDSUIONLY : result := 'CAP_ENABLEDSUIONLY';
  IG_TW_CAP_CUSTOMDSDATA : result := 'CAP_CUSTOMDSDATA';
  IG_TW_CAP_ENDORSER : result := 'CAP_ENDORSER';
  IG_TW_CAP_JOBCONTROL : result := 'CAP_JOBCONTROL';
  IG_TW_CAP_ALARMS : result := 'CAP_ALARMS';
  IG_TW_CAP_ALARMVOLUME : result := 'CAP_ALARMVOLUME';
  IG_TW_CAP_AUTOMATICCAPTURE : result := 'CAP_AUTOMATICCAPTURE';
  IG_TW_CAP_TIMEBEFOREFIRSTCAPTURE : result := 'CAP_TIMEBEFOREFIRSTCAPTURE';
  IG_TW_CAP_TIMEBETWEENCAPTURES : result := 'CAP_TIMEBETWEENCAPTURES';
  IG_TW_CAP_CLEARBUFFERS : result := 'CAP_CLEARBUFFERS';
  IG_TW_CAP_MAXBATCHBUFFERS : result := 'CAP_MAXBATCHBUFFERS';
  IG_TW_CAP_DEVICETIMEDATE : result := 'CAP_DEVICETIMEDATE';
  IG_TW_CAP_POWERSUPPLY : result := 'CAP_POWERSUPPLY';
  IG_TW_CAP_CAMERAPREVIEWUI : result := 'CAP_CAMERAPREVIEWUI';
  IG_TW_CAP_DEVICEEVENT : result := 'CAP_DEVICEEVENT';
  IG_TW_CAP_SERIALNUMBER : result := 'CAP_SERIALNUMBER';
  IG_TW_CAP_PRINTER : result := 'CAP_PRINTER';
  IG_TW_CAP_PRINTERENABLED : result := 'CAP_PRINTERENABLED';
  IG_TW_CAP_PRINTERINDEX : result := 'CAP_PRINTERINDEX';
  IG_TW_CAP_PRINTERMODE : result := 'CAP_PRINTERMODE';
  IG_TW_CAP_PRINTERSTRING : result := 'CAP_PRINTERSTRING';
  IG_TW_CAP_PRINTERSUFFIX : result := 'CAP_PRINTERSUFFIX';
  IG_TW_CAP_LANGUAGE : result := 'CAP_LANGUAGE';
  IG_TW_CAP_FEEDERALIGNMENT : result := 'CAP_FEEDERALIGNMENT';
  IG_TW_CAP_FEEDERORDER : result := 'CAP_FEEDERORDER';
  IG_TW_CAP_REACQUIREALLOWED : result := 'CAP_REACQUIREALLOWED';
  IG_TW_CAP_BATTERYMINUTES : result := 'CAP_BATTERYMINUTES';
  IG_TW_CAP_BATTERYPERCENTAGE : result := 'CAP_BATTERYPERCENTAGE';
  IG_TW_ICAP_AUTOBRIGHT : result := 'ICAP_AUTOBRIGHT';
  IG_TW_ICAP_BRIGHTNESS : result := 'ICAP_BRIGHTNESS';
  IG_TW_ICAP_CONTRAST : result := 'ICAP_CONTRAST';
  IG_TW_ICAP_CUSTHALFTONE : result := 'ICAP_CUSTHALFTONE';
  IG_TW_ICAP_EXPOSURETIME : result := 'ICAP_EXPOSURETIME';
  IG_TW_ICAP_FILTER : result := 'ICAP_FILTER';
  IG_TW_ICAP_FLASHUSED : result := 'ICAP_FLASHUSED';
  IG_TW_ICAP_GAMMA : result := 'ICAP_GAMMA';
  IG_TW_ICAP_HALFTONES : result := 'ICAP_HALFTONES';
  IG_TW_ICAP_HIGHLIGHT : result := 'ICAP_HIGHLIGHT';
  IG_TW_ICAP_IMAGEFILEFORMAT : result := 'ICAP_IMAGEFILEFORMAT';
  IG_TW_ICAP_LAMPSTATE : result := 'ICAP_LAMPSTATE';
  IG_TW_ICAP_LIGHTSOURCE : result := 'ICAP_LIGHTSOURCE';
  IG_TW_ICAP_ORIENTATION : result := 'ICAP_ORIENTATION';
  IG_TW_ICAP_PHYSICALWIDTH : result := 'ICAP_PHYSICALWIDTH';
  IG_TW_ICAP_PHYSICALHEIGHT : result := 'ICAP_PHYSICALHEIGHT';
  IG_TW_ICAP_SHADOW : result := 'ICAP_SHADOW';
  IG_TW_ICAP_FRAMES : result := 'ICAP_FRAMES';
  IG_TW_ICAP_XNATIVERESOLUTION : result := 'ICAP_XNATIVERESOLUTION';
  IG_TW_ICAP_YNATIVERESOLUTION : result := 'ICAP_YNATIVERESOLUTION';
  IG_TW_ICAP_XRESOLUTION : result := 'ICAP_XRESOLUTION';
  IG_TW_ICAP_YRESOLUTION : result := 'ICAP_YRESOLUTION';
  IG_TW_ICAP_MAXFRAMES : result := 'ICAP_MAXFRAMES';
  IG_TW_ICAP_TILES : result := 'ICAP_TILES';
  IG_TW_ICAP_BITORDER : result := 'ICAP_BITORDER';
  IG_TW_ICAP_CCITTKFACTOR : result := 'ICAP_CCITTKFACTOR';
  IG_TW_ICAP_LIGHTPATH : result := 'ICAP_LIGHTPATH';
  IG_TW_ICAP_PIXELFLAVOR : result := 'ICAP_PIXELFLAVOR';
  IG_TW_ICAP_PLANARCHUNKY : result := 'ICAP_PLANARCHUNKY';
  IG_TW_ICAP_ROTATION : result := 'ICAP_ROTATION';
  IG_TW_ICAP_SUPPORTEDSIZES : result := 'ICAP_SUPPORTEDSIZES';
  IG_TW_ICAP_THRESHOLD : result := 'ICAP_THRESHOLD';
  IG_TW_ICAP_XSCALING : result := 'ICAP_XSCALING';
  IG_TW_ICAP_YSCALING : result := 'ICAP_YSCALING';
  IG_TW_ICAP_BITORDERCODES : result := 'ICAP_BITORDERCODES';
  IG_TW_ICAP_PIXELFLAVORCODES : result := 'ICAP_PIXELFLAVORCODES';
  IG_TW_ICAP_JPEGPIXELTYPE : result := 'ICAP_JPEGPIXELTYPE';
  IG_TW_ICAP_TIMEFILL : result := 'ICAP_TIMEFILL';
  IG_TW_ICAP_BITDEPTH : result := 'ICAP_BITDEPTH';
  IG_TW_ICAP_BITDEPTHREDUCTION : result := 'ICAP_BITDEPTHREDUCTION';
  IG_TW_ICAP_UNDEFINEDIMAGESIZE : result := 'ICAP_UNDEFINEDIMAGESIZE';
  IG_TW_ICAP_IMAGEDATASET : result := 'ICAP_IMAGEDATASET';
  IG_TW_ICAP_EXTIMAGEINFO : result := 'ICAP_EXTIMAGEINFO';
  IG_TW_ICAP_MINIMUMHEIGHT : result := 'ICAP_MINIMUMHEIGHT';
  IG_TW_ICAP_MINIMUMWIDTH : result := 'ICAP_MINIMUMWIDTH';
  IG_TW_ICAP_FLIPROTATION : result := 'ICAP_FLIPROTATION';
  IG_TW_ICAP_BARCODEDETECTIONENABLED : result := 'ICAP_BARCODEDETECTIONENABLED';
  IG_TW_ICAP_SUPPORTEDBARCODETYPES : result := 'ICAP_SUPPORTEDBARCODETYPES';
  IG_TW_ICAP_BARCODEMAXSEARCHPRIORITIES : result := 'ICAP_BARCODEMAXSEARCHPRIORITIES';
  IG_TW_ICAP_BARCODESEARCHPRIORITIES : result := 'ICAP_BARCODESEARCHPRIORITIES';
  IG_TW_ICAP_BARCODESEARCHMODE : result := 'ICAP_BARCODESEARCHMODE';
  IG_TW_ICAP_BARCODEMAXRETRIES : result := 'ICAP_BARCODEMAXRETRIES';
  IG_TW_ICAP_BARCODETIMEOUT : result := 'ICAP_BARCODETIMEOUT';
  IG_TW_ICAP_ZOOMFACTOR : result := 'ICAP_ZOOMFACTOR';
  IG_TW_ICAP_PATCHCODEDETECTIONENABLED : result := 'ICAP_PATCHCODEDETECTIONENABLED';
  IG_TW_ICAP_SUPPORTEDPATCHCODETYPES : result := 'ICAP_SUPPORTEDPATCHCODETYPES';
  IG_TW_ICAP_PATCHCODEMAXSEARCHPRIORITIES : result := 'ICAP_PATCHCODEMAXSEARCHPRIORITIES';
  IG_TW_ICAP_PATCHCODESEARCHPRIORITIES : result := 'ICAP_PATCHCODESEARCHPRIORITIES';
  IG_TW_ICAP_PATCHCODESEARCHMODE : result := 'ICAP_PATCHCODESEARCHMODE';
  IG_TW_ICAP_PATCHCODEMAXRETRIES : result := 'ICAP_PATCHCODEMAXRETRIES';
  IG_TW_ICAP_PATCHCODETIMEOUT : result := 'ICAP_PATCHCODETIMEOUT';
  IG_TW_ICAP_FLASHUSED2 : result := 'ICAP_FLASHUSED2';
  IG_TW_ICAP_IMAGEFILTER : result := 'ICAP_IMAGEFILTER';
  IG_TW_ICAP_NOISEFILTER : result := 'ICAP_NOISEFILTER';
  IG_TW_ICAP_OVERSCAN : result := 'ICAP_OVERSCAN';
  IG_TW_ICAP_AUTOMATICBORDERDETECTION : result := 'ICAP_AUTOMATICBORDERDETECTION';
  IG_TW_ICAP_AUTOMATICDESKEW : result := 'ICAP_AUTOMATICDESKEW';
  IG_TW_ICAP_AUTOMATICROTATE : result := 'ICAP_AUTOMATICROTATE';
  IG_TW_ICAP_JPEGQUALITY : result := 'ICAP_JPEGQUALITY';
  IG_TW_ACAP_AUDIOFILEFORMAT : result := 'IG_TW_ACAP_AUDIOFILEFORMAT';
  IG_TW_ACAP_XFERMECH : result := 'IG_TW_ACAP_XFERMECH';


end;




(*
type
  enumIGTWAINCapabilities = TOleEnum;
const
  IG_TW_CAP_CUSTOMBASE = $00008000;
  IG_TW_CAP_XFERCOUNT = $00000001;
  IG_TW_ICAP_COMPRESSION = $00000100;
  IG_TW_ICAP_PIXELTYPE = $00000101;
  IG_TW_ICAP_UNITS = $00000102;
  IG_TW_ICAP_XFERMECH = $00000103;
  IG_TW_CAP_AUTHOR = $00001000;
  IG_TW_CAP_CAPTION = $00001001;
  IG_TW_CAP_FEEDERENABLED = $00001002;
  IG_TW_CAP_FEEDERLOADED = $00001003;
  IG_TW_CAP_TIMEDATE = $00001004;
  IG_TW_CAP_SUPPORTEDCAPS = $00001005;
  IG_TW_CAP_EXTENDEDCAPS = $00001006;
  IG_TW_CAP_AUTOFEED = $00001007;
  IG_TW_CAP_CLEARPAGE = $00001008;
  IG_TW_CAP_FEEDPAGE = $00001009;
  IG_TW_CAP_REWINDPAGE = $0000100A;
  IG_TW_CAP_INDICATORS = $0000100B;
  IG_TW_CAP_SUPPORTEDCAPSEXT = $0000100C;
  IG_TW_CAP_PAPERDETECTABLE = $0000100D;
  IG_TW_CAP_UICONTROLLABLE = $0000100E;
  IG_TW_CAP_DEVICEONLINE = $0000100F;
  IG_TW_CAP_AUTOSCAN = $00001010;
  IG_TW_CAP_THUMBNAILSENABLED = $00001011;
  IG_TW_CAP_DUPLEX = $00001012;
  IG_TW_CAP_DUPLEXENABLED = $00001013;
  IG_TW_CAP_ENABLEDSUIONLY = $00001014;
  IG_TW_CAP_CUSTOMDSDATA = $00001015;
  IG_TW_CAP_ENDORSER = $00001016;
  IG_TW_CAP_JOBCONTROL = $00001017;
  IG_TW_CAP_ALARMS = $00001018;
  IG_TW_CAP_ALARMVOLUME = $00001019;
  IG_TW_CAP_AUTOMATICCAPTURE = $0000101A;
  IG_TW_CAP_TIMEBEFOREFIRSTCAPTURE = $0000101B;
  IG_TW_CAP_TIMEBETWEENCAPTURES = $0000101C;
  IG_TW_CAP_CLEARBUFFERS = $0000101D;
  IG_TW_CAP_MAXBATCHBUFFERS = $0000101E;
  IG_TW_CAP_DEVICETIMEDATE = $0000101F;
  IG_TW_CAP_POWERSUPPLY = $00001020;
  IG_TW_CAP_CAMERAPREVIEWUI = $00001021;
  IG_TW_CAP_DEVICEEVENT = $00001022;
  IG_TW_CAP_SERIALNUMBER = $00001024;
  IG_TW_CAP_PRINTER = $00001026;
  IG_TW_CAP_PRINTERENABLED = $00001027;
  IG_TW_CAP_PRINTERINDEX = $00001028;
  IG_TW_CAP_PRINTERMODE = $00001029;
  IG_TW_CAP_PRINTERSTRING = $0000102A;
  IG_TW_CAP_PRINTERSUFFIX = $0000102B;
  IG_TW_CAP_LANGUAGE = $0000102C;
  IG_TW_CAP_FEEDERALIGNMENT = $0000102D;
  IG_TW_CAP_FEEDERORDER = $0000102E;
  IG_TW_CAP_REACQUIREALLOWED = $00001030;
  IG_TW_CAP_BATTERYMINUTES = $00001032;
  IG_TW_CAP_BATTERYPERCENTAGE = $00001033;
  IG_TW_ICAP_AUTOBRIGHT = $00001100;
  IG_TW_ICAP_BRIGHTNESS = $00001101;
  IG_TW_ICAP_CONTRAST = $00001103;
  IG_TW_ICAP_CUSTHALFTONE = $00001104;
  IG_TW_ICAP_EXPOSURETIME = $00001105;
  IG_TW_ICAP_FILTER = $00001106;
  IG_TW_ICAP_FLASHUSED = $00001107;
  IG_TW_ICAP_GAMMA = $00001108;
  IG_TW_ICAP_HALFTONES = $00001109;
  IG_TW_ICAP_HIGHLIGHT = $0000110A;
  IG_TW_ICAP_IMAGEFILEFORMAT = $0000110C;
  IG_TW_ICAP_LAMPSTATE = $0000110D;
  IG_TW_ICAP_LIGHTSOURCE = $0000110E;
  IG_TW_ICAP_ORIENTATION = $00001110;
  IG_TW_ICAP_PHYSICALWIDTH = $00001111;
  IG_TW_ICAP_PHYSICALHEIGHT = $00001112;
  IG_TW_ICAP_SHADOW = $00001113;
  IG_TW_ICAP_FRAMES = $00001114;
  IG_TW_ICAP_XNATIVERESOLUTION = $00001116;
  IG_TW_ICAP_YNATIVERESOLUTION = $00001117;
  IG_TW_ICAP_XRESOLUTION = $00001118;
  IG_TW_ICAP_YRESOLUTION = $00001119;
  IG_TW_ICAP_MAXFRAMES = $0000111A;
  IG_TW_ICAP_TILES = $0000111B;
  IG_TW_ICAP_BITORDER = $0000111C;
  IG_TW_ICAP_CCITTKFACTOR = $0000111D;
  IG_TW_ICAP_LIGHTPATH = $0000111E;
  IG_TW_ICAP_PIXELFLAVOR = $0000111F;
  IG_TW_ICAP_PLANARCHUNKY = $00001120;
  IG_TW_ICAP_ROTATION = $00001121;
  IG_TW_ICAP_SUPPORTEDSIZES = $00001122;
  IG_TW_ICAP_THRESHOLD = $00001123;
  IG_TW_ICAP_XSCALING = $00001124;
  IG_TW_ICAP_YSCALING = $00001125;
  IG_TW_ICAP_BITORDERCODES = $00001126;
  IG_TW_ICAP_PIXELFLAVORCODES = $00001127;
  IG_TW_ICAP_JPEGPIXELTYPE = $00001128;
  IG_TW_ICAP_TIMEFILL = $0000112A;
  IG_TW_ICAP_BITDEPTH = $0000112B;
  IG_TW_ICAP_BITDEPTHREDUCTION = $0000112C;
  IG_TW_ICAP_UNDEFINEDIMAGESIZE = $0000112D;
  IG_TW_ICAP_IMAGEDATASET = $0000112E;
  IG_TW_ICAP_EXTIMAGEINFO = $0000112F;
  IG_TW_ICAP_MINIMUMHEIGHT = $00001130;
  IG_TW_ICAP_MINIMUMWIDTH = $00001131;
  IG_TW_ICAP_FLIPROTATION = $00001136;
  IG_TW_ICAP_BARCODEDETECTIONENABLED = $00001137;
  IG_TW_ICAP_SUPPORTEDBARCODETYPES = $00001138;
  IG_TW_ICAP_BARCODEMAXSEARCHPRIORITIES = $00001139;
  IG_TW_ICAP_BARCODESEARCHPRIORITIES = $0000113A;
  IG_TW_ICAP_BARCODESEARCHMODE = $0000113B;
  IG_TW_ICAP_BARCODEMAXRETRIES = $0000113C;
  IG_TW_ICAP_BARCODETIMEOUT = $0000113D;
  IG_TW_ICAP_ZOOMFACTOR = $0000113E;
  IG_TW_ICAP_PATCHCODEDETECTIONENABLED = $0000113F;
  IG_TW_ICAP_SUPPORTEDPATCHCODETYPES = $00001140;
  IG_TW_ICAP_PATCHCODEMAXSEARCHPRIORITIES = $00001141;
  IG_TW_ICAP_PATCHCODESEARCHPRIORITIES = $00001142;
  IG_TW_ICAP_PATCHCODESEARCHMODE = $00001143;
  IG_TW_ICAP_PATCHCODEMAXRETRIES = $00001144;
  IG_TW_ICAP_PATCHCODETIMEOUT = $00001145;
  IG_TW_ICAP_FLASHUSED2 = $00001146;
  IG_TW_ICAP_IMAGEFILTER = $00001147;
  IG_TW_ICAP_NOISEFILTER = $00001148;
  IG_TW_ICAP_OVERSCAN = $00001149;
  IG_TW_ICAP_AUTOMATICBORDERDETECTION = $00001150;
  IG_TW_ICAP_AUTOMATICDESKEW = $00001151;
  IG_TW_ICAP_AUTOMATICROTATE = $00001152;
  IG_TW_ICAP_JPEGQUALITY = $00001153;
  IG_TW_ACAP_AUDIOFILEFORMAT = $00001201;
  IG_TW_ACAP_XFERMECH = $00001202;
*)
end;

(*
  TIGTWAINCapArray = class(TOleServer)
  ...
  public
    ...
    property ContainerType: enumIGTWAINContainerType read Get_ContainerType;
    property Values: IIGDataArray read Get_Values;
    property ID: enumIGTWAINCapabilities read Get_ID write Set_ID;
    property ItemType: enumIGSysDataType read Get_ItemType write Set_ItemType;
*)
procedure TMagTwain.ShowCapArray(caparray : IIGTwainCapArray; rlist : Tstrings);
var i : integer;
    s : string;
    strcap : string;
    hexstr : string;
begin
rlist.add(GetCapabilityIDDesc(caparray.ID));
rlist.Add('Container Type: ' + self.GetContainerDesc(caparray.ContainerType));

        For i := 0 To capArray.Values.Size - 1 do
        begin
          strcap := inttostr(caparray.Values.long[i]);
          hexstr := inttohex(caparray.Values.long[i],6);

          rlist.Add('Cap Array: '+ hexstr+ ' '  + strcap );
          //winmsg('Cap: '+ hexstr+ ' '  + strcap + '  ' + GetCapabilityDesc(caparray.Values.Long[i])) ;
        End;

end;

 (*
   TIGTWAINCapEnumeration = class(TOleServer)
  private
    FIntf: IIGTWAINCapEnumeration;
  public
    property ContainerType: enumIGTWAINContainerType read Get_ContainerType;
    property Values: IIGDataArray read Get_Values;
    property ID: enumIGTWAINCapabilities read Get_ID write Set_ID;
    property ItemType: enumIGSysDataType read Get_ItemType write Set_ItemType;
    property CurrentValueIndex: Integer read Get_CurrentValueIndex write Set_CurrentValueIndex;
    property DefaultValueIndex: Integer read Get_DefaultValueIndex write Set_DefaultValueIndex;
    *)

procedure TMagTwain.ShowCapEnum(capEnum : IIGTWAINCapEnumeration; rlist : Tstrings);
var i : integer;
    s, s1, s2 : string;
    strcap : string;
    icap : integer;
    hexstr : string;
begin
rlist.add(GetCapabilityIDDesc(CapEnum.ID));
rlist.Add('Container Type: ' + self.GetContainerDesc(capEnum.ContainerType));
rlist.Add('Current : ' + inttostr(capEnum.CurrentValueIndex));
rlist.Add('Default : ' + inttostr(capEnum.DefaultValueIndex));
rlist.Add('Values: ');

        For i := 0 To capEnum.Values.Size - 1 do
        begin
          s1 := '';
          icap :=   capEnum.Values.Long[i];
          strcap := inttostr(capEnum.Values.Long[i]);
          hexstr := inttohex(capEnum.Values.Long[i],6);
          //s := caparray.
          s1 := '[' + inttostr(i) + '] : '+ hexstr+ ' '  + '(' + strcap + ')' ;
          s2 := GetCapENumItemDesc(capEnum, icap);
          rlist.add('    ' + s1 + '  ' + s2);
        end;
end;

function TMagTwain.GetCapEnumItemDesc(capEnum : IIGTWAINCapEnumeration; indxVal : integer) : string;

begin
  case capEnum.ID of
  IG_TW_CAP_CUSTOMBASE :
    begin
     //
    end;
  IG_TW_CAP_XFERCOUNT :
    begin
     //
    end;
  IG_TW_ICAP_COMPRESSION :
    begin
      //
  case indxVal  of


  IG_COMPRESSION_NONE : result := ('IG_COMPRESSION_NONE');
  IG_COMPRESSION_PACKED_BITS : result := ('IG_COMPRESSION_PACKED_BITS');
  IG_COMPRESSION_HUFFMAN : result := ('IG_COMPRESSION_HUFFMAN');
  IG_COMPRESSION_CCITT_G3 : result := ('IG_COMPRESSION_CCITT_G3');
  IG_COMPRESSION_CCITT_G4 : result := ('IG_COMPRESSION_CCITT_G4');
  IG_COMPRESSION_CCITT_G32D : result := ('IG_COMPRESSION_CCITT_G32D');
  IG_COMPRESSION_JPEG : result := ('IG_COMPRESSION_JPEG');
  IG_COMPRESSION_RLE : result := ('IG_COMPRESSION_RLE');
  IG_COMPRESSION_LZW : result := ('IG_COMPRESSION_LZW');
  IG_COMPRESSION_ABIC_BW : result := ('IG_COMPRESSION_ABIC_BW');
  IG_COMPRESSION_ABIC_GRAY : result := ('IG_COMPRESSION_ABIC_GRAY');
  IG_COMPRESSION_JBIG : result := ('IG_COMPRESSION_JBIG');
  IG_COMPRESSION_FPX_SINCOLOR : result := ('IG_COMPRESSION_FPX_SINCOLOR');
  IG_COMPRESSION_FPX_NOCHANGE : result := ('IG_COMPRESSION_FPX_NOCHANGE');
  IG_COMPRESSION_DEFLATE : result := ('IG_COMPRESSION_DEFLATE');
  IG_COMPRESSION_IBM_MMR : result := ('IG_COMPRESSION_IBM_MMR');
  IG_COMPRESSION_ABIC : result := ('IG_COMPRESSION_ABIC');
  IG_COMPRESSION_PROGRESSIVE : result := ('IG_COMPRESSION_PROGRESSIVE');
  IG_COMPRESSION_EQPC : result := ('IG_COMPRESSION_EQPC');
  IG_COMPRESSION_JBIG2 : result := ('IG_COMPRESSION_JBIG2');
  IG_COMPRESSION_LURAWAVE : result := ('IG_COMPRESSION_LURAWAVE');
  IG_COMPRESSION_LURADOC : result := ('IG_COMPRESSION_LURADOC');
  IG_COMPRESSION_LURAJP2 : result := ('IG_COMPRESSION_LURAJP2');
  IG_COMPRESSION_ASCII : result := ('IG_COMPRESSION_ASCII');
  IG_COMPRESSION_RAW : result := ('IG_COMPRESSION_RAW');
  IG_COMPRESSION_JPEG2K : result := ('IG_COMPRESSION_JPEG2K');
  IG_COMPRESSION_HDP : result := ('IG_COMPRESSION_HDP');
  else result := ('Unknown Compression');
  end;
 (* IG_COMPRESSION_NONE = $00000000;
  IG_COMPRESSION_PACKED_BITS = $00000001;
  IG_COMPRESSION_HUFFMAN = $00000002;
  IG_COMPRESSION_CCITT_G3 = $00000003;
  IG_COMPRESSION_CCITT_G4 = $00000004;
  IG_COMPRESSION_CCITT_G32D = $00000005;
  IG_COMPRESSION_JPEG = $00000006;
  IG_COMPRESSION_RLE = $00000007;
  IG_COMPRESSION_LZW = $00000008;
  IG_COMPRESSION_ABIC_BW = $00000009;
  IG_COMPRESSION_ABIC_GRAY = $0000000A;
  IG_COMPRESSION_JBIG = $0000000B;
  IG_COMPRESSION_FPX_SINCOLOR = $0000000C;
  IG_COMPRESSION_FPX_NOCHANGE = $0000000D;
  IG_COMPRESSION_DEFLATE = $0000000E;
  IG_COMPRESSION_IBM_MMR = $0000000F;
  IG_COMPRESSION_ABIC = $00000010;
  IG_COMPRESSION_PROGRESSIVE = $00000011;
  IG_COMPRESSION_EQPC = $00000012;
  IG_COMPRESSION_JBIG2 = $00000013;
  IG_COMPRESSION_LURAWAVE = $00000014;
  IG_COMPRESSION_LURADOC = $00000015;
  IG_COMPRESSION_LURAJP2 = $00000016;
  IG_COMPRESSION_ASCII = $00000017;
  IG_COMPRESSION_RAW = $00000018;
  IG_COMPRESSION_JPEG2K = $00000019;
  IG_COMPRESSION_HDP = $0000001A;*)
    end;
  IG_TW_ICAP_PIXELTYPE :
    begin
      //
    case indxVal  of
  IG_TW_PT_BW : result := ('IG_TW_PT_BW');
  IG_TW_PT_GRAY : result := ('IG_TW_PT_GRAY');
  IG_TW_PT_RGB : result := ('IG_TW_PT_RGB');
  IG_TW_PT_PALETTE : result := ('IG_TW_PT_PALETTE');
  IG_TW_PT_CMY : result := ('IG_TW_PT_CMY');
  IG_TW_PT_CMYK : result := ('IG_TW_PT_CMYK');
  IG_TW_PT_YUV : result := ('IG_TW_PT_YUV');
  IG_TW_PT_YUVK : result := ('IG_TW_PT_YUVK');
  IG_TW_PT_CIEXYZ : result := ('IG_TW_PT_CIEXYZ');
    end;
    (*
// Constants for enum enumIGTWAINPixelType
type
  enumIGTWAINPixelType = TOleEnum;
const
  IG_TW_PT_BW = $00000000;
  IG_TW_PT_GRAY = $00000001;
  IG_TW_PT_RGB = $00000002;
  IG_TW_PT_PALETTE = $00000003;
  IG_TW_PT_CMY = $00000004;
  IG_TW_PT_CMYK = $00000005;
  IG_TW_PT_YUV = $00000006;
  IG_TW_PT_YUVK = $00000007;
  IG_TW_PT_CIEXYZ = $00000008;
    *)
    end;
  IG_TW_ICAP_UNITS :
    begin
      //
      case indxVal of
  IG_TW_UN_INCHES : result := ('IG_TW_UN_INCHES');
  IG_TW_UN_CENTIMETERS : result := ('IG_TW_UN_CENTIMETERS');
  IG_TW_UN_PICAS : result := ('IG_TW_UN_PICAS');
  IG_TW_UN_POINTS : result := ('IG_TW_UN_POINTS');
  IG_TW_UN_TWIPS : result := ('IG_TW_UN_TWIPS');
  IG_TW_UN_PIXELS : result := ('IG_TW_UN_PIXELS');

      end;
      (*
// Constants for enum enumIGTWAINUnits
type
  enumIGTWAINUnits = TOleEnum;
const
  IG_TW_UN_INCHES = $00000000;
  IG_TW_UN_CENTIMETERS = $00000001;
  IG_TW_UN_PICAS = $00000002;
  IG_TW_UN_POINTS = $00000003;
  IG_TW_UN_TWIPS = $00000004;
  IG_TW_UN_PIXELS = $00000005;
      *)
    end;
  IG_TW_ICAP_XFERMECH :
    begin
      //
      case indxVal  of
  IG_TW_SX_NATIVE : result := ('IG_TW_SX_NATIVE');
  IG_TW_SX_FILE : result := ('IG_TW_SX_FILE');
  IG_TW_SX_MEMORY : result := ('IG_TW_SX_MEMORY');
  IG_TW_SX_FILE2 : result := ('IG_TW_SX_FILE2');

      end;
      (*
// Constants for enum enumIGTWAINXferType
type
  enumIGTWAINXferType = TOleEnum;
const
  IG_TW_SX_NATIVE = $00000000;
  IG_TW_SX_FILE = $00000001;
  IG_TW_SX_MEMORY = $00000002;
  IG_TW_SX_FILE2 = $00000003;
      *)
    end;
  IG_TW_CAP_AUTHOR :
    begin
      //
    end;
  IG_TW_CAP_CAPTION :
    begin
      //
    end;
  IG_TW_CAP_FEEDERENABLED :
    begin
      //
    end;
  IG_TW_CAP_FEEDERLOADED :
    begin
      //
    end;
  IG_TW_CAP_TIMEDATE :
    begin
      //
    end;
  IG_TW_CAP_SUPPORTEDCAPS :
    begin
      //
    end;
  IG_TW_CAP_EXTENDEDCAPS :
    begin
      //
    end;
  IG_TW_CAP_AUTOFEED :
    begin
      //
    end;
  IG_TW_CAP_CLEARPAGE :
    begin
      //
    end;
  IG_TW_CAP_FEEDPAGE :
    begin
      //
    end;
  IG_TW_CAP_REWINDPAGE :
    begin
      //
    end;
  IG_TW_CAP_INDICATORS :
    begin
      //
    end;
  IG_TW_CAP_SUPPORTEDCAPSEXT :
    begin
      //
    end;
  IG_TW_CAP_PAPERDETECTABLE :
    begin
      //
    end;
  IG_TW_CAP_UICONTROLLABLE :
    begin
      //
    end;
  IG_TW_CAP_DEVICEONLINE :
    begin
      //
    end;
  IG_TW_CAP_AUTOSCAN :
    begin
      //
    end;
  IG_TW_CAP_THUMBNAILSENABLED :
    begin
      //
    end;
  IG_TW_CAP_DUPLEX :
    begin
      //
    end;
  IG_TW_CAP_DUPLEXENABLED :
    begin
      //
    end;
  IG_TW_CAP_ENABLEDSUIONLY :
    begin
      //
    end;
  IG_TW_CAP_CUSTOMDSDATA :
    begin
      //
    end;
  IG_TW_CAP_ENDORSER :
    begin
      //
    end;
  IG_TW_CAP_JOBCONTROL :
    begin
      //
      case indxVal of
  IG_TW_JC_NONE : result := ('IG_TW_JC_NONE');
  IG_TW_JC_JSIC : result := ('IG_TW_JC_JSIC');
  IG_TW_JC_JSIS : result := ('IG_TW_JC_JSIS');
  IG_TW_JC_JSXC : result := ('IG_TW_JC_JSXC');
  IG_TW_JC_JSXS : result := ('IG_TW_JC_JSXS');

      end;
      (*
// Constants for enum enumIGTWAINJobControl
type
  enumIGTWAINJobControl = TOleEnum;
const
  IG_TW_JC_NONE = $00000000;
  IG_TW_JC_JSIC = $00000001;
  IG_TW_JC_JSIS = $00000002;
  IG_TW_JC_JSXC = $00000003;
  IG_TW_JC_JSXS = $00000004;
      *)
    end;
  IG_TW_CAP_ALARMS :
    begin
      //
    end;
  IG_TW_CAP_ALARMVOLUME :
    begin
      //
    end;
  IG_TW_CAP_AUTOMATICCAPTURE :
    begin
      //
    end;
  IG_TW_CAP_TIMEBEFOREFIRSTCAPTURE :
    begin
      //
    end;
  IG_TW_CAP_TIMEBETWEENCAPTURES :
    begin
      //
    end;
  IG_TW_CAP_CLEARBUFFERS :
    begin
      //
    end;
  IG_TW_CAP_MAXBATCHBUFFERS :
    begin
      //
    end;
  IG_TW_CAP_DEVICETIMEDATE :
    begin
      //
    end;
  IG_TW_CAP_POWERSUPPLY :
    begin
      //
    end;
  IG_TW_CAP_CAMERAPREVIEWUI :
    begin
      //
    end;
  IG_TW_CAP_DEVICEEVENT :
    begin
      //
    end;
  IG_TW_CAP_SERIALNUMBER :
    begin
      //
    end;
  IG_TW_CAP_PRINTER :
    begin
      //
    end;
  IG_TW_CAP_PRINTERENABLED :
    begin
      //
    end;
  IG_TW_CAP_PRINTERINDEX :
    begin
      //
    end;
  IG_TW_CAP_PRINTERMODE :
    begin
      //
    end;
  IG_TW_CAP_PRINTERSTRING :
    begin
      //
    end;
  IG_TW_CAP_PRINTERSUFFIX :
    begin
      //
    end;
  IG_TW_CAP_LANGUAGE :
    begin
      //
    end;
  IG_TW_CAP_FEEDERALIGNMENT :
    begin
      //
    end;
  IG_TW_CAP_FEEDERORDER :
    begin
      //
    end;
  IG_TW_CAP_REACQUIREALLOWED :
    begin
      //
    end;
  IG_TW_CAP_BATTERYMINUTES :
    begin
      //
    end;
  IG_TW_CAP_BATTERYPERCENTAGE :
    begin
      //
    end;
  IG_TW_ICAP_AUTOBRIGHT :
    begin
      //
    end;
  IG_TW_ICAP_BRIGHTNESS :
    begin
      //
    end;
  IG_TW_ICAP_CONTRAST :
    begin
      //
    end;
  IG_TW_ICAP_CUSTHALFTONE :
    begin
      //
    end;
  IG_TW_ICAP_EXPOSURETIME :
    begin
      //
    end;
  IG_TW_ICAP_FILTER :
    begin
      //
    end;
  IG_TW_ICAP_FLASHUSED :
    begin
      //
    end;
  IG_TW_ICAP_GAMMA :
    begin
      //
    end;
  IG_TW_ICAP_HALFTONES :
    begin
      //
    end;
  IG_TW_ICAP_HIGHLIGHT :
    begin
      //
    end;
  IG_TW_ICAP_IMAGEFILEFORMAT :
    begin
      //
      case indxVal of
  IG_FORMAT_UNKNOWN : result := ('IG_FORMAT_UNKNOWN');
  IG_FORMAT_ATT : result := ('IG_FORMAT_ATT');
  IG_FORMAT_BMP : result := ('IG_FORMAT_BMP');
  IG_FORMAT_BRK : result := ('IG_FORMAT_BRK');
  IG_FORMAT_CAL : result := ('IG_FORMAT_CAL');
  IG_FORMAT_CLP : result := ('IG_FORMAT_CLP');
  IG_FORMAT_CUT : result := ('IG_FORMAT_CUT');
  IG_FORMAT_DCX : result := ('IG_FORMAT_DCX');
  IG_FORMAT_DIB : result := ('IG_FORMAT_DIB');
  IG_FORMAT_EPS : result := ('IG_FORMAT_EPS');
  IG_FORMAT_G3 : result := ('IG_FORMAT_G3');
  IG_FORMAT_G4 : result := ('IG_FORMAT_G4');
  IG_FORMAT_GEM : result := ('IG_FORMAT_GEM');
  IG_FORMAT_GIF : result := ('IG_FORMAT_GIF');
  IG_FORMAT_ICA : result := ('IG_FORMAT_ICA');
  IG_FORMAT_ICO : result := ('IG_FORMAT_ICO');
  IG_FORMAT_IFF : result := ('IG_FORMAT_IFF');
  IG_FORMAT_IMT : result := ('IG_FORMAT_IMT');
  IG_FORMAT_JPG : result := ('IG_FORMAT_JPG');
  IG_FORMAT_KFX : result := ('IG_FORMAT_KFX');
  IG_FORMAT_LV : result := ('IG_FORMAT_LV');
  IG_FORMAT_MAC : result := ('IG_FORMAT_MAC');
  IG_FORMAT_MSP : result := ('IG_FORMAT_MSP');
  IG_FORMAT_MOD : result := ('IG_FORMAT_MOD');
  IG_FORMAT_NCR : result := ('IG_FORMAT_NCR');
  IG_FORMAT_PBM : result := ('IG_FORMAT_PBM');
  IG_FORMAT_PCD : result := ('IG_FORMAT_PCD');
  IG_FORMAT_PCT : result := ('IG_FORMAT_PCT');
  IG_FORMAT_PCX : result := ('IG_FORMAT_PCX');
  IG_FORMAT_PGM : result := ('IG_FORMAT_PGM');
  IG_FORMAT_PNG : result := ('IG_FORMAT_PNG');
  IG_FORMAT_PNM : result := ('IG_FORMAT_PNM');
  IG_FORMAT_PPM : result := ('IG_FORMAT_PPM');
  IG_FORMAT_PSD : result := ('IG_FORMAT_PSD');
  IG_FORMAT_RAS : result := ('IG_FORMAT_RAS');
  IG_FORMAT_SGI : result := ('IG_FORMAT_SGI');
  IG_FORMAT_TGA : result := ('IG_FORMAT_TGA');
  IG_FORMAT_TIF : result := ('IG_FORMAT_TIF');
  IG_FORMAT_TXT : result := ('IG_FORMAT_TXT');
  IG_FORMAT_WPG : result := ('IG_FORMAT_WPG');
  IG_FORMAT_XBM : result := ('IG_FORMAT_XBM');
  IG_FORMAT_WMF : result := ('IG_FORMAT_WMF');
  IG_FORMAT_XPM : result := ('IG_FORMAT_XPM');
  IG_FORMAT_XRX : result := ('IG_FORMAT_XRX');
  IG_FORMAT_XWD : result := ('IG_FORMAT_XWD');
  IG_FORMAT_DCM : result := ('IG_FORMAT_DCM');
  IG_FORMAT_AFX : result := ('IG_FORMAT_AFX');
  IG_FORMAT_FPX : result := ('IG_FORMAT_FPX');
  //IG_FORMAT_PJPEG : result := ('IG_FORMAT_PJPEG');
  IG_FORMAT_AVI : result := ('IG_FORMAT_AVI');
  IG_FORMAT_G32D : result := ('IG_FORMAT_G32D');
  IG_FORMAT_ABIC_BILEVEL : result := ('IG_FORMAT_ABIC_BILEVEL');
  IG_FORMAT_ABIC_CONCAT : result := ('IG_FORMAT_ABIC_CONCAT');
  IG_FORMAT_PDF : result := ('IG_FORMAT_PDF');
  IG_FORMAT_JBIG : result := ('IG_FORMAT_JBIG');
  IG_FORMAT_RAW : result := ('IG_FORMAT_RAW');
  IG_FORMAT_IMR : result := ('IG_FORMAT_IMR');
  IG_FORMAT_WLT : result := ('IG_FORMAT_WLT');
  IG_FORMAT_JB2 : result := ('IG_FORMAT_JB2');
  IG_FORMAT_WL16 : result := ('IG_FORMAT_WL16');
  IG_FORMAT_MODCA : result := ('IG_FORMAT_MODCA');
  IG_FORMAT_PTOCA : result := ('IG_FORMAT_PTOCA');
  IG_FORMAT_WBMP : result := ('IG_FORMAT_WBMP');
  IG_FORMAT_MUL : result := ('IG_FORMAT_MUL');
  IG_FORMAT_CAD : result := ('IG_FORMAT_CAD');
  IG_FORMAT_DWG : result := ('IG_FORMAT_DWG');
  IG_FORMAT_DXF : result := ('IG_FORMAT_DXF');
  IG_FORMAT_EXIF_JPEG : result := ('IG_FORMAT_EXIF_JPEG');
  IG_FORMAT_HPGL : result := ('IG_FORMAT_HPGL');
  IG_FORMAT_DGN : result := ('IG_FORMAT_DGN');
  IG_FORMAT_EXIF_TIFF : result := ('IG_FORMAT_EXIF_TIFF');
  IG_FORMAT_CGM : result := ('IG_FORMAT_CGM');
  IG_FORMAT_QUICKTIMEJPEG : result := ('IG_FORMAT_QUICKTIMEJPEG');
  IG_FORMAT_SVG : result := ('IG_FORMAT_SVG');
  IG_FORMAT_DWF : result := ('IG_FORMAT_DWF');
  IG_FORMAT_U3D : result := ('IG_FORMAT_U3D');
  IG_FORMAT_XPS : result := ('IG_FORMAT_XPS');
  IG_FORMAT_SCI_CT : result := ('IG_FORMAT_SCI_CT');
  IG_FORMAT_CUR : result := ('IG_FORMAT_CUR');
  IG_FORMAT_LURADOC : result := ('IG_FORMAT_LURADOC');
  IG_FORMAT_LURAWAVE : result := ('IG_FORMAT_LURAWAVE');
  IG_FORMAT_LURAJP2 : result := ('IG_FORMAT_LURAJP2');
  IG_FORMAT_JPEG2K : result := ('IG_FORMAT_JPEG2K');
  IG_FORMAT_JPX : result := ('IG_FORMAT_JPX');
  IG_FORMAT_POSTSCRIPT : result := ('IG_FORMAT_POSTSCRIPT');
  IG_FORMAT_MJ2 : result := ('IG_FORMAT_MJ2');
  IG_FORMAT_DCRAW : result := ('IG_FORMAT_DCRAW');
  IG_FORMAT_QUICKTIME : result := ('IG_FORMAT_QUICKTIME');
  IG_FORMAT_AFP : result := ('IG_FORMAT_AFP');
  IG_FORMAT_CIFF : result := ('IG_FORMAT_CIFF');
  IG_FORMAT_DNG : result := ('IG_FORMAT_DNG');
  IG_FORMAT_LZW : result := ('IG_FORMAT_LZW');
  IG_FORMAT_HDP : result := ('IG_FORMAT_HDP');
  IG_FORMAT_DIRECTSHOW : result := ('IG_FORMAT_DIRECTSHOW');
  IG_FORMAT_PSB : result := ('IG_FORMAT_PSB');
  IG_FORMAT_XMP : result := ('IG_FORMAT_XMP');
  IG_FORMAT_HLDCRAW : result := ('IG_FORMAT_HLDCRAW');
  else result := ('Unknown Image File Format');
      end;
      (*
// Constants for enum enumIGFormats
type
  enumIGFormats = TOleEnum;
const
  IG_FORMAT_UNKNOWN = $00000000;
  IG_FORMAT_ATT = $00000001;
  IG_FORMAT_BMP = $00000002;
  IG_FORMAT_BRK = $00000003;
  IG_FORMAT_CAL = $00000004;
  IG_FORMAT_CLP = $00000005;
  IG_FORMAT_CUT = $00000007;
  IG_FORMAT_DCX = $00000008;
  IG_FORMAT_DIB = $00000009;
  IG_FORMAT_EPS = $0000000A;
  IG_FORMAT_G3 = $0000000B;
  IG_FORMAT_G4 = $0000000C;
  IG_FORMAT_GEM = $0000000D;
  IG_FORMAT_GIF = $0000000E;
  IG_FORMAT_ICA = $00000010;
  IG_FORMAT_ICO = $00000011;
  IG_FORMAT_IFF = $00000012;
  IG_FORMAT_IMT = $00000014;
  IG_FORMAT_JPG = $00000015;
  IG_FORMAT_KFX = $00000016;
  IG_FORMAT_LV = $00000017;
  IG_FORMAT_MAC = $00000018;
  IG_FORMAT_MSP = $00000019;
  IG_FORMAT_MOD = $0000001A;
  IG_FORMAT_NCR = $0000001B;
  IG_FORMAT_PBM = $0000001C;
  IG_FORMAT_PCD = $0000001D;
  IG_FORMAT_PCT = $0000001E;
  IG_FORMAT_PCX = $0000001F;
  IG_FORMAT_PGM = $00000020;
  IG_FORMAT_PNG = $00000021;
  IG_FORMAT_PNM = $00000022;
  IG_FORMAT_PPM = $00000023;
  IG_FORMAT_PSD = $00000024;
  IG_FORMAT_RAS = $00000025;
  IG_FORMAT_SGI = $00000026;
  IG_FORMAT_TGA = $00000027;
  IG_FORMAT_TIF = $00000028;
  IG_FORMAT_TXT = $00000029;
  IG_FORMAT_WPG = $0000002A;
  IG_FORMAT_XBM = $0000002B;
  IG_FORMAT_WMF = $0000002C;
  IG_FORMAT_XPM = $0000002D;
  IG_FORMAT_XRX = $0000002E;
  IG_FORMAT_XWD = $0000002F;
  IG_FORMAT_DCM = $00000030;
  IG_FORMAT_AFX = $00000031;
  IG_FORMAT_FPX = $00000032;
  IG_FORMAT_PJPEG = $00000015;
  IG_FORMAT_AVI = $00000034;
  IG_FORMAT_G32D = $00000035;
  IG_FORMAT_ABIC_BILEVEL = $00000036;
  IG_FORMAT_ABIC_CONCAT = $00000037;
  IG_FORMAT_PDF = $00000038;
  IG_FORMAT_JBIG = $00000039;
  IG_FORMAT_RAW = $0000003A;
  IG_FORMAT_IMR = $0000003B;
  IG_FORMAT_WLT = $0000003D;
  IG_FORMAT_JB2 = $0000003E;
  IG_FORMAT_WL16 = $0000003F;
  IG_FORMAT_MODCA = $00000040;
  IG_FORMAT_PTOCA = $00000041;
  IG_FORMAT_WBMP = $00000042;
  IG_FORMAT_MUL = $00000043;
  IG_FORMAT_CAD = $00000044;
  IG_FORMAT_DWG = $00000045;
  IG_FORMAT_DXF = $00000046;
  IG_FORMAT_EXIF_JPEG = $00000047;
  IG_FORMAT_HPGL = $00000048;
  IG_FORMAT_DGN = $00000049;
  IG_FORMAT_EXIF_TIFF = $0000004A;
  IG_FORMAT_CGM = $0000004B;
  IG_FORMAT_QUICKTIMEJPEG = $0000004C;
  IG_FORMAT_SVG = $0000004D;
  IG_FORMAT_DWF = $0000004E;
  IG_FORMAT_U3D = $0000004F;
  IG_FORMAT_XPS = $00000050;
  IG_FORMAT_SCI_CT = $0000005B;
  IG_FORMAT_CUR = $00000060;
  IG_FORMAT_LURADOC = $00000061;
  IG_FORMAT_LURAWAVE = $00000062;
  IG_FORMAT_LURAJP2 = $00000063;
  IG_FORMAT_JPEG2K = $00000064;
  IG_FORMAT_JPX = $00000065;
  IG_FORMAT_POSTSCRIPT = $00000066;
  IG_FORMAT_MJ2 = $00000067;
  IG_FORMAT_DCRAW = $00000068;
  IG_FORMAT_QUICKTIME = $00000069;
  IG_FORMAT_AFP = $0000006A;
  IG_FORMAT_CIFF = $0000006B;
  IG_FORMAT_DNG = $0000006C;
  IG_FORMAT_LZW = $0000006D;
  IG_FORMAT_HDP = $0000006E;
  IG_FORMAT_DIRECTSHOW = $0000006F;
  IG_FORMAT_PSB = $00000070;
  IG_FORMAT_XMP = $00000071;
  IG_FORMAT_HLDCRAW = $00000072;

      *)
    end;
  IG_TW_ICAP_LAMPSTATE :
    begin
      //
    end;
  IG_TW_ICAP_LIGHTSOURCE :
    begin
      //
      case indxVal of
  IG_TW_LS_RED : result := ('IG_TW_LS_RED');
  IG_TW_LS_GREEN : result := ('IG_TW_LS_GREEN');
  IG_TW_LS_BLUE : result := ('IG_TW_LS_BLUE');
  IG_TW_LS_NONE : result := ('IG_TW_LS_NONE');
  IG_TW_LS_WHITE : result := ('IG_TW_LS_WHITE');
  IG_TW_LS_UV : result := ('IG_TW_LS_UV');
  IG_TW_LS_IR : result := ('IG_TW_LS_IR');

      end;
      (*
// Constants for enum enumIGTWAINLightSource
type
  enumIGTWAINLightSource = TOleEnum;
const
  IG_TW_LS_RED = $00000000;
  IG_TW_LS_GREEN = $00000001;
  IG_TW_LS_BLUE = $00000002;
  IG_TW_LS_NONE = $00000003;
  IG_TW_LS_WHITE = $00000004;
  IG_TW_LS_UV = $00000005;
  IG_TW_LS_IR = $00000006;
      *)
    end;
  IG_TW_ICAP_ORIENTATION :
    begin
      //
      case indxVal of
  IG_TW_OR_ROT0 : result := ('IG_TW_OR_ROT0');
  IG_TW_OR_ROT90 : result := ('IG_TW_OR_ROT90');
  IG_TW_OR_ROT180 : result := ('IG_TW_OR_ROT180');
  IG_TW_OR_ROT270 : result := ('IG_TW_OR_ROT270');
  //IG_TW_OR_PORTRAIT : result := ('IG_TW_OR_PORTRAIT');  // duplicate case label
  //IG_TW_OR_LANDSCAPE : result := ('IG_TW_OR_LANDSCAPE');  //
  else result := ('Unknown Orientation');
      end;
      (*
// Constants for enum enumIGTWAINOrientation
type
  enumIGTWAINOrientation = TOleEnum;
const
  IG_TW_OR_ROT0 = $00000000;
  IG_TW_OR_ROT90 = $00000001;
  IG_TW_OR_ROT180 = $00000002;
  IG_TW_OR_ROT270 = $00000003;
  IG_TW_OR_PORTRAIT = $00000000;
  IG_TW_OR_LANDSCAPE = $00000003;
      *)
    end;
  IG_TW_ICAP_PHYSICALWIDTH :
    begin
      //
    end;
  IG_TW_ICAP_PHYSICALHEIGHT :
    begin
      //
    end;
  IG_TW_ICAP_SHADOW :
    begin
      //
    end;
  IG_TW_ICAP_FRAMES :
    begin
      //
    end;
  IG_TW_ICAP_XNATIVERESOLUTION :
    begin
      //
    end;
  IG_TW_ICAP_YNATIVERESOLUTION :
    begin
      //
    end;
  IG_TW_ICAP_XRESOLUTION :
    begin
      //
    end;
  IG_TW_ICAP_YRESOLUTION :
    begin
      //
    end;
  IG_TW_ICAP_MAXFRAMES :
    begin
      //
    end;
  IG_TW_ICAP_TILES :
    begin
      //
    end;
  IG_TW_ICAP_BITORDER :
    begin
      //
      case indxVal of
  IG_TW_BO_LSBFIRST : result := ('IG_TW_BO_LSBFIRST');
  IG_TW_BO_MSBFIRST : result := ('IG_TW_BO_MSBFIRST');
  else result := ('Unknown Bit Order');
      end;
      (*
// Constants for enum enumIGTWAINBitOrder
type
  enumIGTWAINBitOrder = TOleEnum;
const
  IG_TW_BO_LSBFIRST = $00000000;
  IG_TW_BO_MSBFIRST = $00000001;
      *)
    end;
  IG_TW_ICAP_CCITTKFACTOR :
    begin
      //
    end;
  IG_TW_ICAP_LIGHTPATH :
    begin
      //
    end;
  IG_TW_ICAP_PIXELFLAVOR :
    begin
      //
      case indxVal of
  IG_TW_PF_CHOCOLATE : result := ('IG_TW_PF_CHOCOLATE');
  IG_TW_PF_VANILLA : result := ('IG_TW_PF_VANILLA');
  else result := ('Unknown Pixel Flavor');
      end;
      (*

// Constants for enum enumIGTWAINPixelFlavor
type
  enumIGTWAINPixelFlavor = TOleEnum;
const
  IG_TW_PF_CHOCOLATE = $00000000;
  IG_TW_PF_VANILLA = $00000001;
      *)
    end;
  IG_TW_ICAP_PLANARCHUNKY :
    begin
      //
      case indxVal of
  IG_TW_PC_CHUNKY : result := ('IG_TW_PC_CHUNKY');
  IG_TW_PC_PLANAR : result := ('IG_TW_PC_PLANAR');

      end;
      (*

// Constants for enum enumIGTWAINColorDataFormats
type
  enumIGTWAINColorDataFormats = TOleEnum;
const
  IG_TW_PC_CHUNKY = $00000000;
  IG_TW_PC_PLANAR = $00000001;
      *)
    end;
  IG_TW_ICAP_ROTATION :
    begin
      //
    end;
  IG_TW_ICAP_SUPPORTEDSIZES :
    begin
      //
      case indxVal of
  IG_TW_SS_NONE : result := ('IG_TW_SS_NONE');
  IG_TW_SS_A4LETTER : result := ('IG_TW_SS_A4LETTER');
  IG_TW_SS_B5LETTER : result := ('IG_TW_SS_B5LETTER');
  IG_TW_SS_USLETTER : result := ('IG_TW_SS_USLETTER');
  IG_TW_SS_USLEGAL : result := ('IG_TW_SS_USLEGAL');
  IG_TW_SS_A5 : result := ('IG_TW_SS_A5');
  IG_TW_SS_B4 : result := ('IG_TW_SS_B4');
  IG_TW_SS_B6 : result := ('IG_TW_SS_B6');
  IG_TW_SS_USLEDGER : result := ('IG_TW_SS_USLEDGER');
  IG_TW_SS_USEXECUTIVE : result := ('IG_TW_SS_USEXECUTIVE');
  IG_TW_SS_A3 : result := ('IG_TW_SS_A3');
  IG_TW_SS_B3 : result := ('IG_TW_SS_B3');
  IG_TW_SS_A6 : result := ('IG_TW_SS_A6');
  IG_TW_SS_C4 : result := ('IG_TW_SS_C4');
  IG_TW_SS_C5 : result := ('IG_TW_SS_C5');
  IG_TW_SS_C6 : result := ('IG_TW_SS_C6');
  IG_TW_SS_4A0 : result := ('IG_TW_SS_4A0');
  IG_TW_SS_2A0 : result := ('IG_TW_SS_2A0');
  IG_TW_SS_A0 : result := ('IG_TW_SS_A0');
  IG_TW_SS_A1 : result := ('IG_TW_SS_A1');
  IG_TW_SS_A2 : result := ('IG_TW_SS_A2');
  //IG_TW_SS_A4 : result := ('IG_TW_SS_A4');
  IG_TW_SS_A7 : result := ('IG_TW_SS_A7');
  IG_TW_SS_A8 : result := ('IG_TW_SS_A8');
  IG_TW_SS_A9 : result := ('IG_TW_SS_A9');
  IG_TW_SS_A10 : result := ('IG_TW_SS_A10');
  IG_TW_SS_ISOB0 : result := ('IG_TW_SS_ISOB0');
  IG_TW_SS_ISOB1 : result := ('IG_TW_SS_ISOB1');
  IG_TW_SS_ISOB2 : result := ('IG_TW_SS_ISOB2');
  //IG_TW_SS_ISOB3 : result := ('IG_TW_SS_ISOB3');
  //IG_TW_SS_ISOB4 : result := ('IG_TW_SS_ISOB4');
  IG_TW_SS_ISOB5 : result := ('IG_TW_SS_ISOB5');
  //IG_TW_SS_ISOB6 : result := ('IG_TW_SS_ISOB6');
  IG_TW_SS_ISOB7 : result := ('IG_TW_SS_ISOB7');
  IG_TW_SS_ISOB8 : result := ('IG_TW_SS_ISOB8');
  IG_TW_SS_ISOB9 : result := ('IG_TW_SS_ISOB9');
  IG_TW_SS_ISOB10 : result := ('IG_TW_SS_ISOB10');
  IG_TW_SS_JISB0 : result := ('IG_TW_SS_JISB0');
  IG_TW_SS_JISB1 : result := ('IG_TW_SS_JISB1');
  IG_TW_SS_JISB2 : result := ('IG_TW_SS_JISB2');
  IG_TW_SS_JISB3 : result := ('IG_TW_SS_JISB3');
  IG_TW_SS_JISB4 : result := ('IG_TW_SS_JISB4');
  //IG_TW_SS_JISB5 : result := ('IG_TW_SS_JISB5');
  IG_TW_SS_JISB6 : result := ('IG_TW_SS_JISB6');
  IG_TW_SS_JISB7 : result := ('IG_TW_SS_JISB7');
  IG_TW_SS_JISB8 : result := ('IG_TW_SS_JISB8');
  IG_TW_SS_JISB9 : result := ('IG_TW_SS_JISB9');
  IG_TW_SS_JISB10 : result := ('IG_TW_SS_JISB10');
  IG_TW_SS_C0 : result := ('IG_TW_SS_C0');
  IG_TW_SS_C1 : result := ('IG_TW_SS_C1');
  IG_TW_SS_C2 : result := ('IG_TW_SS_C2');
  IG_TW_SS_C3 : result := ('IG_TW_SS_C3');
  IG_TW_SS_C7 : result := ('IG_TW_SS_C7');
  IG_TW_SS_C8 : result := ('IG_TW_SS_C8');
  IG_TW_SS_C9 : result := ('IG_TW_SS_C9');
  IG_TW_SS_C10 : result := ('IG_TW_SS_C10');
  IG_TW_SS_USSTATEMENT : result := ('IG_TW_SS_USSTATEMENT');
  IG_TW_SS_BUSINESSCARD : result := ('IG_TW_SS_BUSINESSCARD');
  else result := ('Unsupported Size');
      end;
(*
// Constants for enum enumIGTWAINSupportedSizes
type
  enumIGTWAINSupportedSizes = TOleEnum;
const
  IG_TW_SS_NONE = $00000000;
  IG_TW_SS_A4LETTER = $00000001;
  IG_TW_SS_B5LETTER = $00000002;
  IG_TW_SS_USLETTER = $00000003;
  IG_TW_SS_USLEGAL = $00000004;
  IG_TW_SS_A5 = $00000005;
  IG_TW_SS_B4 = $00000006;
  IG_TW_SS_B6 = $00000007;
  IG_TW_SS_USLEDGER = $00000009;
  IG_TW_SS_USEXECUTIVE = $0000000A;
  IG_TW_SS_A3 = $0000000B;
  IG_TW_SS_B3 = $0000000C;
  IG_TW_SS_A6 = $0000000D;
  IG_TW_SS_C4 = $0000000E;
  IG_TW_SS_C5 = $0000000F;
  IG_TW_SS_C6 = $00000010;
  IG_TW_SS_4A0 = $00000011;
  IG_TW_SS_2A0 = $00000012;
  IG_TW_SS_A0 = $00000013;
  IG_TW_SS_A1 = $00000014;
  IG_TW_SS_A2 = $00000015;
  IG_TW_SS_A4 = $00000001;
  IG_TW_SS_A7 = $00000016;
  IG_TW_SS_A8 = $00000017;
  IG_TW_SS_A9 = $00000018;
  IG_TW_SS_A10 = $00000019;
  IG_TW_SS_ISOB0 = $0000001A;
  IG_TW_SS_ISOB1 = $0000001B;
  IG_TW_SS_ISOB2 = $0000001C;
  IG_TW_SS_ISOB3 = $0000000C;
  IG_TW_SS_ISOB4 = $00000006;
  IG_TW_SS_ISOB5 = $0000001D;
  IG_TW_SS_ISOB6 = $00000007;
  IG_TW_SS_ISOB7 = $0000001E;
  IG_TW_SS_ISOB8 = $0000001F;
  IG_TW_SS_ISOB9 = $00000020;
  IG_TW_SS_ISOB10 = $00000021;
  IG_TW_SS_JISB0 = $00000022;
  IG_TW_SS_JISB1 = $00000023;
  IG_TW_SS_JISB2 = $00000024;
  IG_TW_SS_JISB3 = $00000025;
  IG_TW_SS_JISB4 = $00000026;
  IG_TW_SS_JISB5 = $00000002;
  IG_TW_SS_JISB6 = $00000027;
  IG_TW_SS_JISB7 = $00000028;
  IG_TW_SS_JISB8 = $00000029;
  IG_TW_SS_JISB9 = $0000002A;
  IG_TW_SS_JISB10 = $0000002B;
  IG_TW_SS_C0 = $0000002C;
  IG_TW_SS_C1 = $0000002D;
  IG_TW_SS_C2 = $0000002E;
  IG_TW_SS_C3 = $0000002F;
  IG_TW_SS_C7 = $00000030;
  IG_TW_SS_C8 = $00000031;
  IG_TW_SS_C9 = $00000032;
  IG_TW_SS_C10 = $00000033;
  IG_TW_SS_USSTATEMENT = $00000034;
  IG_TW_SS_BUSINESSCARD = $00000035;
*)
    end;
  IG_TW_ICAP_THRESHOLD :
    begin
      //
    end;
  IG_TW_ICAP_XSCALING :
    begin
      //
    end;
  IG_TW_ICAP_YSCALING :
    begin
      //
    end;
  IG_TW_ICAP_BITORDERCODES :
    begin
      //
    end;
  IG_TW_ICAP_PIXELFLAVORCODES :
    begin
      //
    end;
  IG_TW_ICAP_JPEGPIXELTYPE :
    begin
      //
    end;
  IG_TW_ICAP_TIMEFILL :
    begin
      //
    end;
  IG_TW_ICAP_BITDEPTH :
    begin
      //
    end;
  IG_TW_ICAP_BITDEPTHREDUCTION :
    begin
      //
      case indxVal of
  IG_TW_BR_THRESHOLD : result := ('IG_TW_BR_THRESHOLD');
  IG_TW_BR_HALFTONE : result := ('IG_TW_BR_HALFTONE');
  IG_TW_BR_CUSTHALFTONE : result := ('IG_TW_BR_CUSTHALFTONE');
  IG_TW_BR_DIFFUSION : result := ('IG_TW_BR_DIFFUSION');
  else result := ('Unknown BitDepth Reduction');
      end;
      (*
// Constants for enum enumIGTWAINBitDepthReduction
type
  enumIGTWAINBitDepthReduction = TOleEnum;
const
  IG_TW_BR_THRESHOLD = $00000000;
  IG_TW_BR_HALFTONE = $00000001;
  IG_TW_BR_CUSTHALFTONE = $00000002;
  IG_TW_BR_DIFFUSION = $00000003;
      *)
    end;
  IG_TW_ICAP_UNDEFINEDIMAGESIZE :
    begin
      //
    end;
  IG_TW_ICAP_IMAGEDATASET :
    begin
      //
    end;
  IG_TW_ICAP_EXTIMAGEINFO :
    begin
      //
    end;
  IG_TW_ICAP_MINIMUMHEIGHT :
    begin
      //
    end;
  IG_TW_ICAP_MINIMUMWIDTH :
    begin
      //
    end;
  IG_TW_ICAP_FLIPROTATION :
    begin
      //
    end;
  IG_TW_ICAP_BARCODEDETECTIONENABLED :
    begin
      //
    end;
  IG_TW_ICAP_SUPPORTEDBARCODETYPES :
    begin
      //
    end;
  IG_TW_ICAP_BARCODEMAXSEARCHPRIORITIES :
    begin
      //
    end;
  IG_TW_ICAP_BARCODESEARCHPRIORITIES :
    begin
      //
    end;
  IG_TW_ICAP_BARCODESEARCHMODE :
    begin
      //
    end;
  IG_TW_ICAP_BARCODEMAXRETRIES :
    begin
      //
    end;
  IG_TW_ICAP_BARCODETIMEOUT :
    begin
      //
    end;
  IG_TW_ICAP_ZOOMFACTOR :
    begin
      //
    end;
  IG_TW_ICAP_PATCHCODEDETECTIONENABLED :
    begin
      //
    end;
  IG_TW_ICAP_SUPPORTEDPATCHCODETYPES :
    begin
      //
    end;
  IG_TW_ICAP_PATCHCODEMAXSEARCHPRIORITIES :
    begin
      //
    end;
  IG_TW_ICAP_PATCHCODESEARCHPRIORITIES :
    begin
      //
    end;
  IG_TW_ICAP_PATCHCODESEARCHMODE :
    begin
      //
    end;
  IG_TW_ICAP_PATCHCODEMAXRETRIES :
    begin
      //
    end;
  IG_TW_ICAP_PATCHCODETIMEOUT :
    begin
      //
    end;
  IG_TW_ICAP_FLASHUSED2 :
    begin
      //
    end;
  IG_TW_ICAP_IMAGEFILTER :
    begin
      //
    end;
  IG_TW_ICAP_NOISEFILTER :
    begin
      //
      case indxVal of
  IG_TW_NF_NONE : result := ('IG_TW_NF_NONE');
  IG_TW_NF_AUTO : result := ('IG_TW_NF_AUTO');
  IG_TW_NF_LONEPIXEL : result := ('IG_TW_NF_LONEPIXEL');
  IG_TW_NF_MAJORITYRULE : result := ('IG_TW_NF_MAJORITYRULE');

      end;
      (*
// Constants for enum enumIGTWAINNoiseFilter
type
  enumIGTWAINNoiseFilter = TOleEnum;
const
  IG_TW_NF_NONE = $00000000;
  IG_TW_NF_AUTO = $00000001;
  IG_TW_NF_LONEPIXEL = $00000002;
  IG_TW_NF_MAJORITYRULE = $00000003;
      *)
    end;
  IG_TW_ICAP_OVERSCAN :
    begin
      //
      case indxVal of
  IG_TW_OV_NONE : result := ('IG_TW_OV_NONE');
  IG_TW_OV_AUTO : result := ('IG_TW_OV_AUTO');
  IG_TW_OV_TOPBOTTOM : result := ('IG_TW_OV_TOPBOTTOM');
  IG_TW_OV_LEFTRIGHT : result := ('IG_TW_OV_LEFTRIGHT');
  IG_TW_OV_ALL : result := ('IG_TW_OV_ALL');

      end;
      (*
// Constants for enum enumIGTWAINOverscanModes
type
  enumIGTWAINOverscanModes = TOleEnum;
const
  IG_TW_OV_NONE = $00000000;
  IG_TW_OV_AUTO = $00000001;
  IG_TW_OV_TOPBOTTOM = $00000002;
  IG_TW_OV_LEFTRIGHT = $00000003;
  IG_TW_OV_ALL = $00000004;
      *)
    end;
  IG_TW_ICAP_AUTOMATICBORDERDETECTION :
    begin
      //
    end;
  IG_TW_ICAP_AUTOMATICDESKEW :
    begin
      //
    end;
  IG_TW_ICAP_AUTOMATICROTATE :
    begin
      //
    end;
  IG_TW_ICAP_JPEGQUALITY :
    begin
      //
    end;
  IG_TW_ACAP_AUDIOFILEFORMAT :
    begin
      //
    end;
  IG_TW_ACAP_XFERMECH :
    begin
      //
    end;
   ELSE
     BEGIN
       //
     END;

  end;
end;
procedure TMagTwain.ShowCapRange(capRange: IIGTWAINCapRange; rlist : Tstrings );
var i : integer;
    s : string;
    strcap : string;
    hexstr : string;
    rangeType :    enumIGSysDataType;
    rangeValue : IGDataItem;
    value : string;
begin
 rlist.add(GetCapabilityIDDesc(capRange.ID));
rlist.Add('Container Type: ' + self.GetContainerDesc(capRange.ContainerType));

  rangeType := capRange.ItemType;

  rangeValue := capRange.MinValue;
  value := GetIGDataItemDesc(rangeType, rangeValue);
  rlist.Add('  Min: ' + value);

  rangeValue := capRange.MaxValue;
  value := GetIGDataItemDesc(rangeType, rangeValue);
  rlist.Add('  Max: ' + value);

  rangeValue := capRange.StepSize;
  value := GetIGDataItemDesc(rangeType, rangeValue);
  rlist.Add('  Step: ' + value);

  rangeValue := capRange.DefaultValue;
  value := GetIGDataItemDesc(rangeType, rangeValue);
  rlist.Add('  Default: ' + value);

  rangeValue := capRange.CurrentValue;
  value := GetIGDataItemDesc(rangeType, rangeValue);
  rlist.Add('  Current: ' + value);
  //caprange.


(*
  TIGTWAINCapRange = class(TOleServer)
   ...
  public
    constructor Create(AOwner: TComponent); override;
    destructor  Destroy; override;
    procedure Connect; override;
    procedure ConnectTo(svrIntf: IIGTWAINCapRange);
    procedure Disconnect; override;
    property DefaultInterface: IIGTWAINCapRange read GetDefaultInterface;
    property ContainerType: enumIGTWAINContainerType read Get_ContainerType;
    property MinValue: IIGDataItem read Get_MinValue;
    property MaxValue: IIGDataItem read Get_MaxValue;
    property StepSize: IIGDataItem read Get_StepSize;
    property DefaultValue: IIGDataItem read Get_DefaultValue;
    property CurrentValue: IIGDataItem read Get_CurrentValue;
    property ID: enumIGTWAINCapabilities read Get_ID write Set_ID;
    property ItemType: enumIGSysDataType read Get_ItemType write Set_ItemType;
*)
end;

procedure TMagTwain.ShowCapOneValue(capOneValue: IIGTWAINCapOneValue ; rlist : Tstrings);
var i : integer;
    s : string;
    strcap : string;
    hexstr : string;
    ItemType :    enumIGSysDataType;
    itemValue : IGDataItem;
    value : string;
begin
 rlist.add(GetCapabilityIDDesc(CapOneValue.ID));
rlist.Add('Container Type: ' + self.GetContainerDesc(capOneValue.ContainerType));

  itemtype := capOneValue.ItemType;
  itemvalue := capOneVAlue.Value;
  value := GetIGDataItemDesc(itemtype, itemvalue);
  rlist.Add(value);
end;


function TMagTwain.GetImageChannelTypeDesc(value : integer): string;
begin
case value  of
  IG_ICT_RED : result := 'IG_ICT_RED';
  IG_ICT_GREEN : result := 'IG_ICT_GREEN';
  IG_ICT_BLUE : result := 'IG_ICT_BLUE';
  IG_ICT_ALPHA : result := 'IG_ICT_ALPHA';
end;
end;
(*
// Constants for enum enumIGImageChannelType
type
  enumIGImageChannelType = TOleEnum;
const
  IG_ICT_RED = $00000000;
  IG_ICT_GREEN = $00000001;
  IG_ICT_BLUE = $00000002;
  IG_ICT_ALPHA = $00000003;
*)

function TMagTwain.GetResolutionUnitsDesc(value : integer): string;
begin
case value  of
  IG_RESOLUTION_NO_ABS : result := 'IG_RESOLUTION_NO_ABS';
  IG_RESOLUTION_METERS : result := 'IG_RESOLUTION_METERS';
  IG_RESOLUTION_INCHES : result := 'IG_RESOLUTION_INCHES';
  IG_RESOLUTION_CENTIMETERS : result := 'IG_RESOLUTION_CENTIMETERS';
  IG_RESOLUTION_10_INCHES : result := 'IG_RESOLUTION_10_INCHES';
  IG_RESOLUTION_10_CENTIMETERS : result := 'IG_RESOLUTION_10_CENTIMETERS';
  //IG_RESOLUTION_LAST : result := 'IG_RESOLUTION_LAST';
end;
end;

(*
// Constants for enum enumIGResolutionUnits
type
  enumIGResolutionUnits = TOleEnum;
const
  IG_RESOLUTION_NO_ABS = $00000001;
  IG_RESOLUTION_METERS = $00000002;
  IG_RESOLUTION_INCHES = $00000003;
  IG_RESOLUTION_CENTIMETERS = $00000004;
  IG_RESOLUTION_10_INCHES = $00000005;
  IG_RESOLUTION_10_CENTIMETERS = $00000006;
  IG_RESOLUTION_LAST = $00000006;
*)


function TMagTwain.GetContainerDesc(value : integer): string;
begin
case value  of
   IG_TW_ON_ARRAY : result :=   'IG_TW_ON_ARRAY';
  IG_TW_ON_ENUMERATION : result :=   'IG_TW_ON_ENUMERATION';
  IG_TW_ON_ONEVALUE : result :=     'IG_TW_ON_ONEVALUE';
  IG_TW_ON_RANGE : result :=    'IG_TW_ON_RANGE';
  else  result := 'Container Type not defined';
end;
end;


(*
// Constants for enum enumIGTWAINContainerType
type
  enumIGTWAINContainerType = TOleEnum;
const
  IG_TW_ON_ARRAY = $00000003;
  IG_TW_ON_ENUMERATION = $00000004;
  IG_TW_ON_ONEVALUE = $00000005;
  IG_TW_ON_RANGE = $00000006;
*)


function TMagTwain.GetColorSpaceDesc(value : integer): string;   //enumIGColorSpaces
begin
case value  of

  IG_COLOR_SPACE_RGB : result := 'IG_COLOR_SPACE_RGB';
  IG_COLOR_SPACE_I : result := 'IG_COLOR_SPACE_I';
  IG_COLOR_SPACE_IHS : result := 'IG_COLOR_SPACE_IHS';
  IG_COLOR_SPACE_HLS : result := 'IG_COLOR_SPACE_HLS';
  IG_COLOR_SPACE_Lab : result := 'IG_COLOR_SPACE_Lab';
  IG_COLOR_SPACE_YIQ : result := 'IG_COLOR_SPACE_YIQ';
  IG_COLOR_SPACE_CMY : result := 'IG_COLOR_SPACE_CMY';
  IG_COLOR_SPACE_CMYK : result := 'IG_COLOR_SPACE_CMYK';
  IG_COLOR_SPACE_YCrCb : result := 'IG_COLOR_SPACE_YCrCb';
  IG_COLOR_SPACE_YUV : result := 'IG_COLOR_SPACE_YUV';
  IG_COLOR_SPACE_MONO : result := 'IG_COLOR_SPACE_MONO';
  IG_COLOR_SPACE_ALPHA : result := 'IG_COLOR_SPACE_ALPHA';
  IG_COLOR_SPACE_MA : result := 'IG_COLOR_SPACE_MA';
  IG_COLOR_SPACE_AM : result := 'IG_COLOR_SPACE_AM';
  IG_COLOR_SPACE_RGBA : result := 'IG_COLOR_SPACE_RGBA';
  IG_COLOR_SPACE_ARGB : result := 'IG_COLOR_SPACE_ARGB';
  IG_COLOR_SPACE_YCC : result := 'IG_COLOR_SPACE_YCC';
  IG_COLOR_SPACE_YCCA : result := 'IG_COLOR_SPACE_YCCA';
  IG_COLOR_SPACE_AYCC : result := 'IG_COLOR_SPACE_AYCC';
  IG_COLOR_SPACE_UNKNOWN : result := 'IG_COLOR_SPACE_UNKNOWN';
  IG_COLOR_SPACE_NOCHANGE : result := 'IG_COLOR_SPACE_NOCHANGE';
  //IG_COLOR_SPACE_HSL : result := 'IG_COLOR_SPACE_HSL';
end;
end;


(*
// Constants for enum enumIGColorSpaces
type
  enumIGColorSpaces = TOleEnum;
const
  IG_COLOR_SPACE_RGB = $00000000;
  IG_COLOR_SPACE_I = $00000001;
  IG_COLOR_SPACE_IHS = $00000002;
  IG_COLOR_SPACE_HLS = $00000003;
  IG_COLOR_SPACE_Lab = $00000004;
  IG_COLOR_SPACE_YIQ = $00000005;
  IG_COLOR_SPACE_CMY = $00000006;
  IG_COLOR_SPACE_CMYK = $00000007;
  IG_COLOR_SPACE_YCrCb = $00000008;
  IG_COLOR_SPACE_YUV = $00000009;
  IG_COLOR_SPACE_MONO = $0000000A;
  IG_COLOR_SPACE_ALPHA = $0000000B;
  IG_COLOR_SPACE_MA = $0000000C;
  IG_COLOR_SPACE_AM = $0000000D;
  IG_COLOR_SPACE_RGBA = $0000000E;
  IG_COLOR_SPACE_ARGB = $0000000F;
  IG_COLOR_SPACE_YCC = $00000010;
  IG_COLOR_SPACE_YCCA = $00000011;
  IG_COLOR_SPACE_AYCC = $00000012;
  IG_COLOR_SPACE_UNKNOWN = $00000013;
  IG_COLOR_SPACE_NOCHANGE = $00000014;
  IG_COLOR_SPACE_HSL = $00000003;
*)



function  TMagTwain.GetCompressionDesc(comp : integer ):string;
begin

case comp of
  IG_COMPRESSION_NONE : result := 'NONE';
  IG_COMPRESSION_PACKED_BITS : result := 'PACKED_BITS';
  IG_COMPRESSION_HUFFMAN : result := 'HUFFMAN';
  IG_COMPRESSION_CCITT_G3 : result := 'CCITT_G3';
  IG_COMPRESSION_CCITT_G4 : result := 'CCITT_G4';
  IG_COMPRESSION_CCITT_G32D : result := 'CCITT_G32D';
  IG_COMPRESSION_JPEG : result := 'JPEG';
  IG_COMPRESSION_RLE : result := 'RLE';
  IG_COMPRESSION_LZW : result := 'LZW';
  IG_COMPRESSION_ABIC_BW : result := 'ABIC_BW';
  IG_COMPRESSION_ABIC_GRAY : result := 'ABIC_GRAY';
  IG_COMPRESSION_JBIG : result := 'JBIG';
  IG_COMPRESSION_FPX_SINCOLOR : result := 'FPX_SINCOLOR';
  IG_COMPRESSION_FPX_NOCHANGE : result := 'FPX_NOCHANGE';
  IG_COMPRESSION_DEFLATE : result := 'DEFLATE';
  IG_COMPRESSION_IBM_MMR : result := 'IBM_MMR';
  IG_COMPRESSION_ABIC : result := 'ABIC';
  IG_COMPRESSION_PROGRESSIVE : result := 'PROGRESSIVE';
  IG_COMPRESSION_EQPC : result := 'EQPC';
  IG_COMPRESSION_JBIG2 : result := 'JBIG2';
  IG_COMPRESSION_LURAWAVE : result := 'LURAWAVE';
  IG_COMPRESSION_LURADOC : result := 'LURADOC';
  IG_COMPRESSION_LURAJP2 : result := 'LURAJP2';
  IG_COMPRESSION_ASCII : result := 'ASCII';
  IG_COMPRESSION_RAW : result := 'RAW';
  IG_COMPRESSION_JPEG2K : result := 'JPEG2K';
  IG_COMPRESSION_HDP : result := 'HDP';
end;

(*  // Constants for enum enumIGCompressions
type
  enumIGCompressions = TOleEnum;
const
  IG_COMPRESSION_NONE = $00000000;
  IG_COMPRESSION_PACKED_BITS = $00000001;
  IG_COMPRESSION_HUFFMAN = $00000002;
  IG_COMPRESSION_CCITT_G3 = $00000003;
  IG_COMPRESSION_CCITT_G4 = $00000004;
  IG_COMPRESSION_CCITT_G32D = $00000005;
  IG_COMPRESSION_JPEG = $00000006;
  IG_COMPRESSION_RLE = $00000007;
  IG_COMPRESSION_LZW = $00000008;
  IG_COMPRESSION_ABIC_BW = $00000009;
  IG_COMPRESSION_ABIC_GRAY = $0000000A;
  IG_COMPRESSION_JBIG = $0000000B;
  IG_COMPRESSION_FPX_SINCOLOR = $0000000C;
  IG_COMPRESSION_FPX_NOCHANGE = $0000000D;
  IG_COMPRESSION_DEFLATE = $0000000E;
  IG_COMPRESSION_IBM_MMR = $0000000F;
  IG_COMPRESSION_ABIC = $00000010;
  IG_COMPRESSION_PROGRESSIVE = $00000011;
  IG_COMPRESSION_EQPC = $00000012;
  IG_COMPRESSION_JBIG2 = $00000013;
  IG_COMPRESSION_LURAWAVE = $00000014;
  IG_COMPRESSION_LURADOC = $00000015;
  IG_COMPRESSION_LURAJP2 = $00000016;
  IG_COMPRESSION_ASCII = $00000017;
  IG_COMPRESSION_RAW = $00000018;
  IG_COMPRESSION_JPEG2K = $00000019;
  IG_COMPRESSION_HDP = $0000001A;
  *)
end;


function  TMagTwain.GetFormatDesc(value : integer ):string;    //enumIGFormats
begin
case value of
  IG_FORMAT_UNKNOWN : result := 'IG_FORMAT_UNKNOWN';
  IG_FORMAT_ATT : result := 'IG_FORMAT_ATT';
  IG_FORMAT_BMP : result := 'IG_FORMAT_BMP';
  IG_FORMAT_BRK : result := 'IG_FORMAT_BRK';
  IG_FORMAT_CAL : result := 'IG_FORMAT_CAL';
  IG_FORMAT_CLP : result := 'IG_FORMAT_CLP';
  IG_FORMAT_CUT : result := 'IG_FORMAT_CUT';
  IG_FORMAT_DCX : result := 'IG_FORMAT_DCX';
  IG_FORMAT_DIB : result := 'IG_FORMAT_DIB';
  IG_FORMAT_EPS : result := 'IG_FORMAT_EPS';
  IG_FORMAT_G3 : result := 'IG_FORMAT_G3';
  IG_FORMAT_G4 : result := 'IG_FORMAT_G4';
  IG_FORMAT_GEM : result := 'IG_FORMAT_GEM';
  IG_FORMAT_GIF : result := 'IG_FORMAT_GIF';
  IG_FORMAT_ICA : result := 'IG_FORMAT_ICA';
  IG_FORMAT_ICO : result := 'IG_FORMAT_ICO';
  IG_FORMAT_IFF : result := 'IG_FORMAT_IFF';
  IG_FORMAT_IMT : result := 'IG_FORMAT_IMT';
  IG_FORMAT_JPG : result := 'IG_FORMAT_JPG';
  IG_FORMAT_KFX : result := 'IG_FORMAT_KFX';
  IG_FORMAT_LV : result := 'IG_FORMAT_LV';
  IG_FORMAT_MAC : result := 'IG_FORMAT_MAC';
  IG_FORMAT_MSP : result := 'IG_FORMAT_MSP';
  IG_FORMAT_MOD : result := 'IG_FORMAT_MOD';
  IG_FORMAT_NCR : result := 'IG_FORMAT_NCR';
  IG_FORMAT_PBM : result := 'IG_FORMAT_PBM';
  IG_FORMAT_PCD : result := 'IG_FORMAT_PCD';
  IG_FORMAT_PCT : result := 'IG_FORMAT_PCT';
  IG_FORMAT_PCX : result := 'IG_FORMAT_PCX';
  IG_FORMAT_PGM : result := 'IG_FORMAT_PGM';
  IG_FORMAT_PNG : result := 'IG_FORMAT_PNG';
  IG_FORMAT_PNM : result := 'IG_FORMAT_PNM';
  IG_FORMAT_PPM : result := 'IG_FORMAT_PPM';
  IG_FORMAT_PSD : result := 'IG_FORMAT_PSD';
  IG_FORMAT_RAS : result := 'IG_FORMAT_RAS';
  IG_FORMAT_SGI : result := 'IG_FORMAT_SGI';
  IG_FORMAT_TGA : result := 'IG_FORMAT_TGA';
  IG_FORMAT_TIF : result := 'IG_FORMAT_TIF';
  IG_FORMAT_TXT : result := 'IG_FORMAT_TXT';
  IG_FORMAT_WPG : result := 'IG_FORMAT_WPG';
  IG_FORMAT_XBM : result := 'IG_FORMAT_XBM';
  IG_FORMAT_WMF : result := 'IG_FORMAT_WMF';
  IG_FORMAT_XPM : result := 'IG_FORMAT_XPM';
  IG_FORMAT_XRX : result := 'IG_FORMAT_XRX';
  IG_FORMAT_XWD : result := 'IG_FORMAT_XWD';
  IG_FORMAT_DCM : result := 'IG_FORMAT_DCM';
  IG_FORMAT_AFX : result := 'IG_FORMAT_AFX';
  IG_FORMAT_FPX : result := 'IG_FORMAT_FPX';
  //IG_FORMAT_PJPEG : result := 'IG_FORMAT_PJPEG';
  IG_FORMAT_AVI : result := 'IG_FORMAT_AVI';
  IG_FORMAT_G32D : result := 'IG_FORMAT_G32D';
  IG_FORMAT_ABIC_BILEVEL : result := 'IG_FORMAT_ABIC_BILEVEL';
  IG_FORMAT_ABIC_CONCAT : result := 'IG_FORMAT_ABIC_CONCAT';
  IG_FORMAT_PDF : result := 'IG_FORMAT_PDF';
  IG_FORMAT_JBIG : result := 'IG_FORMAT_JBIG';
  IG_FORMAT_RAW : result := 'IG_FORMAT_RAW';
  IG_FORMAT_IMR : result := 'IG_FORMAT_IMR';
  IG_FORMAT_WLT : result := 'IG_FORMAT_WLT';
  IG_FORMAT_JB2 : result := 'IG_FORMAT_JB2';
  IG_FORMAT_WL16 : result := 'IG_FORMAT_WL16';
  IG_FORMAT_MODCA : result := 'IG_FORMAT_MODCA';
  IG_FORMAT_PTOCA : result := 'IG_FORMAT_PTOCA';
  IG_FORMAT_WBMP : result := 'IG_FORMAT_WBMP';
  IG_FORMAT_MUL : result := 'IG_FORMAT_MUL';
  IG_FORMAT_CAD : result := 'IG_FORMAT_CAD';
  IG_FORMAT_DWG : result := 'IG_FORMAT_DWG';
  IG_FORMAT_DXF : result := 'IG_FORMAT_DXF';
  IG_FORMAT_EXIF_JPEG : result := 'IG_FORMAT_EXIF_JPEG';
  IG_FORMAT_HPGL : result := 'IG_FORMAT_HPGL';
  IG_FORMAT_DGN : result := 'IG_FORMAT_DGN';
  IG_FORMAT_EXIF_TIFF : result := 'IG_FORMAT_EXIF_TIFF';
  IG_FORMAT_CGM : result := 'IG_FORMAT_CGM';
  IG_FORMAT_QUICKTIMEJPEG : result := 'IG_FORMAT_QUICKTIMEJPEG';
  IG_FORMAT_SVG : result := 'IG_FORMAT_SVG';
  IG_FORMAT_DWF : result := 'IG_FORMAT_DWF';
  IG_FORMAT_U3D : result := 'IG_FORMAT_U3D';
  IG_FORMAT_XPS : result := 'IG_FORMAT_XPS';
  IG_FORMAT_SCI_CT : result := 'IG_FORMAT_SCI_CT';
  IG_FORMAT_CUR : result := 'IG_FORMAT_CUR';
  IG_FORMAT_LURADOC : result := 'IG_FORMAT_LURADOC';
  IG_FORMAT_LURAWAVE : result := 'IG_FORMAT_LURAWAVE';
  IG_FORMAT_LURAJP2 : result := 'IG_FORMAT_LURAJP2';
  IG_FORMAT_JPEG2K : result := 'IG_FORMAT_JPEG2K';
  IG_FORMAT_JPX : result := 'IG_FORMAT_JPX';
  IG_FORMAT_POSTSCRIPT : result := 'IG_FORMAT_POSTSCRIPT';
  IG_FORMAT_MJ2 : result := 'IG_FORMAT_MJ2';
  IG_FORMAT_DCRAW : result := 'IG_FORMAT_DCRAW';
  IG_FORMAT_QUICKTIME : result := 'IG_FORMAT_QUICKTIME';
  IG_FORMAT_AFP : result := 'IG_FORMAT_AFP';
  IG_FORMAT_CIFF : result := 'IG_FORMAT_CIFF';
  IG_FORMAT_DNG : result := 'IG_FORMAT_DNG';
  IG_FORMAT_LZW : result := 'IG_FORMAT_LZW';
  IG_FORMAT_HDP : result := 'IG_FORMAT_HDP';
  IG_FORMAT_DIRECTSHOW : result := 'IG_FORMAT_DIRECTSHOW';
  IG_FORMAT_PSB : result := 'IG_FORMAT_PSB';
  IG_FORMAT_XMP : result := 'IG_FORMAT_XMP';
  IG_FORMAT_HLDCRAW : result := 'IG_FORMAT_HLDCRAW';
end;
end;

(*

// Constants for enum enumIGFormats
type
  enumIGFormats = TOleEnum;
const
  IG_FORMAT_UNKNOWN = $00000000;
  IG_FORMAT_ATT = $00000001;
  IG_FORMAT_BMP = $00000002;
  IG_FORMAT_BRK = $00000003;
  IG_FORMAT_CAL = $00000004;
  IG_FORMAT_CLP = $00000005;
  IG_FORMAT_CUT = $00000007;
  IG_FORMAT_DCX = $00000008;
  IG_FORMAT_DIB = $00000009;
  IG_FORMAT_EPS = $0000000A;
  IG_FORMAT_G3 = $0000000B;
  IG_FORMAT_G4 = $0000000C;
  IG_FORMAT_GEM = $0000000D;
  IG_FORMAT_GIF = $0000000E;
  IG_FORMAT_ICA = $00000010;
  IG_FORMAT_ICO = $00000011;
  IG_FORMAT_IFF = $00000012;
  IG_FORMAT_IMT = $00000014;
  IG_FORMAT_JPG = $00000015;
  IG_FORMAT_KFX = $00000016;
  IG_FORMAT_LV = $00000017;
  IG_FORMAT_MAC = $00000018;
  IG_FORMAT_MSP = $00000019;
  IG_FORMAT_MOD = $0000001A;
  IG_FORMAT_NCR = $0000001B;
  IG_FORMAT_PBM = $0000001C;
  IG_FORMAT_PCD = $0000001D;
  IG_FORMAT_PCT = $0000001E;
  IG_FORMAT_PCX = $0000001F;
  IG_FORMAT_PGM = $00000020;
  IG_FORMAT_PNG = $00000021;
  IG_FORMAT_PNM = $00000022;
  IG_FORMAT_PPM = $00000023;
  IG_FORMAT_PSD = $00000024;
  IG_FORMAT_RAS = $00000025;
  IG_FORMAT_SGI = $00000026;
  IG_FORMAT_TGA = $00000027;
  IG_FORMAT_TIF = $00000028;
  IG_FORMAT_TXT = $00000029;
  IG_FORMAT_WPG = $0000002A;
  IG_FORMAT_XBM = $0000002B;
  IG_FORMAT_WMF = $0000002C;
  IG_FORMAT_XPM = $0000002D;
  IG_FORMAT_XRX = $0000002E;
  IG_FORMAT_XWD = $0000002F;
  IG_FORMAT_DCM = $00000030;
  IG_FORMAT_AFX = $00000031;
  IG_FORMAT_FPX = $00000032;
  IG_FORMAT_PJPEG = $00000015;
  IG_FORMAT_AVI = $00000034;
  IG_FORMAT_G32D = $00000035;
  IG_FORMAT_ABIC_BILEVEL = $00000036;
  IG_FORMAT_ABIC_CONCAT = $00000037;
  IG_FORMAT_PDF = $00000038;
  IG_FORMAT_JBIG = $00000039;
  IG_FORMAT_RAW = $0000003A;
  IG_FORMAT_IMR = $0000003B;
  IG_FORMAT_WLT = $0000003D;
  IG_FORMAT_JB2 = $0000003E;
  IG_FORMAT_WL16 = $0000003F;
  IG_FORMAT_MODCA = $00000040;
  IG_FORMAT_PTOCA = $00000041;
  IG_FORMAT_WBMP = $00000042;
  IG_FORMAT_MUL = $00000043;
  IG_FORMAT_CAD = $00000044;
  IG_FORMAT_DWG = $00000045;
  IG_FORMAT_DXF = $00000046;
  IG_FORMAT_EXIF_JPEG = $00000047;
  IG_FORMAT_HPGL = $00000048;
  IG_FORMAT_DGN = $00000049;
  IG_FORMAT_EXIF_TIFF = $0000004A;
  IG_FORMAT_CGM = $0000004B;
  IG_FORMAT_QUICKTIMEJPEG = $0000004C;
  IG_FORMAT_SVG = $0000004D;
  IG_FORMAT_DWF = $0000004E;
  IG_FORMAT_U3D = $0000004F;
  IG_FORMAT_XPS = $00000050;
  IG_FORMAT_SCI_CT = $0000005B;
  IG_FORMAT_CUR = $00000060;
  IG_FORMAT_LURADOC = $00000061;
  IG_FORMAT_LURAWAVE = $00000062;
  IG_FORMAT_LURAJP2 = $00000063;
  IG_FORMAT_JPEG2K = $00000064;
  IG_FORMAT_JPX = $00000065;
  IG_FORMAT_POSTSCRIPT = $00000066;
  IG_FORMAT_MJ2 = $00000067;
  IG_FORMAT_DCRAW = $00000068;
  IG_FORMAT_QUICKTIME = $00000069;
  IG_FORMAT_AFP = $0000006A;
  IG_FORMAT_CIFF = $0000006B;
  IG_FORMAT_DNG = $0000006C;
  IG_FORMAT_LZW = $0000006D;
  IG_FORMAT_HDP = $0000006E;
  IG_FORMAT_DIRECTSHOW = $0000006F;
  IG_FORMAT_PSB = $00000070;
  IG_FORMAT_XMP = $00000071;
  IG_FORMAT_HLDCRAW = $00000072;
*)









function TMagTwain.GetIGSysDataTypeDesc(sysdatatype : enumIGSysDataType): String      ;
begin
   case sysdatatype of
  AM_TID_META_INT8 : result := 'INT8';
  AM_TID_META_UINT8 : result := 'UINT8';
  AM_TID_META_INT16 : result := 'INT16';
  AM_TID_META_UINT16 : result := 'UINT16';
  AM_TID_META_INT32 : result := 'INT32';
  AM_TID_META_UINT32 : result := 'UINT32';
  AM_TID_META_INT64 : result := 'INT64';
  AM_TID_META_UINT64 : result := 'UINT64';
  AM_TID_META_BOOL : result := 'BOOL';
  AM_TID_META_RATIONAL_UINT32 : result := 'RATIONAL_UINT32';
  AM_TID_META_RATIONAL_INT32 : result := 'RATIONAL_INT32';
  AM_TID_META_FLOAT : result := 'FLOAT';
  AM_TID_META_DOUBLE : result := 'DOUBLE';
  AM_TID_RAW_DATA : result := 'RAW_DATA';
  AM_TID_META_STRING : result := 'STRING';
  AM_TID_META_STRING32 : result := 'STRING32';
  AM_TID_META_STRING64 : result := 'STRING64';
  AM_TID_META_STRING128 : result := 'STRING128';
  AM_TID_META_STRING255 : result := 'STRING255';
  AM_TID_META_STRING1024 : result := 'STRING1024';
  AM_TID_META_STRING_UNICODE512 : result := 'STRING_UNICODE512';
  AM_TID_META_DRECT : result := 'DRECT';
  end;
end;

function TMagTwain.GetIGDataItemDesc(pItemtype: enumIGSysDataType;  pItemvalue: IGDataItem) : string;
var i : integer;
    s : string;
    strcap : string;
    hexstr : string;
    ItemType :    enumIGSysDataType;
    itemValue : IGDataItem;
    res1, res2 : string;
begin
(*  ImageGear Help for ActiveX  in TWAIN  IGTWAINCapArray,  does not include
     the following :
  AM_TID_META_INT64,
  AM_TID_META_UINT64
    AM_TID_META_RATIONAL_UINT32,
    AM_TID_META_RATIONAL_INT32
   AM_TID_META_FLOAT,
     AM_TID_RAW_DATA :
     AM_TID_META_STRING,
*)
itemtype := pItemType;
itemValue := pItemValue;
res1 :=   GetIGSysDataTypeDesc(pItemType);

  case itemtype of
  AM_TID_META_INT8,
  AM_TID_META_UINT8,
  AM_TID_META_INT16,
  AM_TID_META_UINT16,
  AM_TID_META_INT32,
  AM_TID_META_UINT32,
  AM_TID_META_INT64,
  AM_TID_META_UINT64  : res2 := (inttostr(itemvalue.Long));

  AM_TID_META_BOOL :
    begin
        if itemvalue.Boolean
          then res2 := ('True')
          else res2 := ('False');
    end;

  AM_TID_META_RATIONAL_UINT32,
  AM_TID_META_RATIONAL_INT32 : res2 := (inttostr(itemvalue.Long));

  AM_TID_META_FLOAT,
  AM_TID_META_DOUBLE :
    begin
      res2 := (FloatToStr(itemvalue.Double));
    end;

  AM_TID_RAW_DATA :
    begin
     res2 := (' ?');
    end;

  AM_TID_META_STRING,
  AM_TID_META_STRING32,
  AM_TID_META_STRING64,
  AM_TID_META_STRING128,
  AM_TID_META_STRING255,
  AM_TID_META_STRING1024,
  AM_TID_META_STRING_UNICODE512 : res2 := (itemvalue.String_);

  AM_TID_META_DRECT :
  begin
    res2 := ('(rectangle)');
  end;
  end;
result := res1 + ' ' + res2;
end;

Function TMagTwain.Magbooltostr(Value: Boolean): String;
Begin
  If Value Then
    Result := 'True'
  Else
    Result := 'False';
End;

procedure TMagTwain.ShowFileInfo(filename : string; rlist : Tstrings);
var
           vFormatPgInfo: IIGFormatPageInfo;
           vIoLocation: IIGIOLocation;
           venumImageFormat: enumIGFormats;
           venumIGCompression :  enumIGCompressions;
           vImageChannelInfo :   IIGImageChannelInfo ;
           vImageTileInfo : IIGImageTileInfo;
           vDIBInfo  : IIGDIBInfo;
           vImageResolution : IIGImageResolution;
           vFilename : string;
           vPage : integer;
           vPageCount : integer;
           i : integer;
begin
vFileName := filename;
        //  PageInfo: IGFormatPageInfo;
        //  IoLocation: IIGIOLocation;
        //  FImageFormat: enumIGFormats;
      vIoLocation := GetIGManager.IGFormatsCtrl.CreateObject(IG_FORMATS_OBJ_IOFILE) As IIGIOLocation;
      (vIoLocation As IGIOFile).Filename := vFilename;
        //     IGFormatsCtrl.LoadPageFromFile(CurrentPage, Filename, 0); //dialogLoadOptions.PageNum);

      vPage := 1;
      vPageCount := GetIGManager.IGFormatsCtrl.GetPageCount(vIoLocation, IG_FORMAT_UNKNOWN);
      vFormatPgInfo := GetIGManager.IGFormatsCtrl.GetPageInfo(vIoLocation, vPage - 1, IG_FORMAT_UNKNOWN);
      venumImageFormat := vFormatPgInfo.Format;
      venumIGCompression := vFormatPgInfo.Compression;
      //IGFormatsCtrl.

          // vImageChannelInfo := vFormatPgInfo.
          //vImageTileInfo :
           vDIBInfo  := vFormatPgInfo.DIBInfo;
           vImageResolution := vFormatPgInfo.ImageResolution;

      rlist.Add(' ---  ');
      rlist.Add('Filename : ' + vFileName);

//      rlist.Add('(sysutils) FileSize   : ' + Inttostr((fmxutils.Getfilesize(vFileName) Div 1024) + 1) + ' KB');
//  rlist.Add(inttostr(trunc(FileSize(vfileName) Div 1024) + 1) + ' KB' );
rlist.Add('FileSize: ' + Inttostr((MagGetfilesize(vFilename) Div 1024) + 1));
      rlist.Add('Format : (' + inttostr(venumImageFormat) +') ' + GetFormatDesc(venumImageFormat));
      rlist.Add('Compression : (' + inttostr(venumIGCompression) +') '+GetCompressionDesc(venumIGCompression));
      rlist.Add('Page Count: ' + inttostr(vPageCount));



  rlist.Add('ImageWidth: ' +  inttostr(vFormatPgInfo.ImageWidth) );   //Integer read Get_ImageWidth;
  rlist.Add('ImageHeight: ' +  inttostr(vFormatPgInfo.ImageHeight) );   //Integer read Get_ImageHeight;
  rlist.Add('BitDepth: ' +   inttostr(vFormatPgInfo.BitDepth));   //Integer read Get_BitDepth;
  rlist.Add('ColorSpace: (' +  inttostr(vFormatPgInfo.ColorSpace) +') ' + GetColorSpaceDesc(vFormatPgInfo.ColorSpace));   //enumIGColorSpaces read Get_ColorSpace;
  rlist.Add('ChannelCount: ' +  inttostr(vFormatPgInfo.ChannelCount) );   //Integer read Get_ChannelCount;
  //rlist.Add('ImageChannelInfo[' +   );   //Index: Integer]: IIGImageChannelInfo read Get_ImageChannelInfo;
   for i := 0 to vFormatPgInfo.ChannelCount - 1 do
     begin
       vImageChannelInfo := vFormatPgInfo.ImageChannelInfo[i];
         rlist.Add('ImageChannelInfo[' + inttostr(i) + ']' +  ' Depth : ' + inttostr(VImageChannelInfo.Depth));
         rlist.Add('ImageChannelInfo[' + inttostr(i) + ']' +  ' Type : ' + inttostr(VImageChannelInfo.type_));
         rlist.Add('ImageChannelInfo[' + inttostr(i) + ']' +  ' Type Desc : ' + GetImageChannelTypeDesc(VImageChannelInfo.type_));

     end;

  rlist.Add('TileCount: ' +  inttostr(vFormatPgInfo.TileCount) );   //Integer read Get_TileCount;
  //rlist.Add('ImageTileInfo[' +   );   //Index: Integer]: IIGImageTileInfo read Get_ImageTileInfo;
  for I := 1 to vFormatPgInfo.TileCount  do
    begin
       vImageTileInfo := vFormatPgInfo.ImageTileInfo[i];
         if vImageTileInfo = nil then
         rlist.Add('ImageTileInfo[' + inttostr(i) + ']' +  ' =  nil')
         else
         begin
         rlist.Add('ImageTileInfo[' + inttostr(i) + ']' +  ' Height : ' + inttostr(vImageTileInfo.Height));
         rlist.Add('ImageTileInfo[' + inttostr(i) + ']' +  ' Width  : ' + inttostr(vImageTileInfo.Width));
         end;
    end;




  rlist.Add('DIBInfo: ' );   //IIGDIBInfo read Get_DIBInfo;
  rlist.Add('DIBInfo.Size: ' + inttostr(vDIBInfo.Size));
  rlist.Add('DIBInfo.Width: ' + inttostr(vDIBInfo.Width));
  rlist.Add('DIBInfo.Height: ' + inttostr(vDIBInfo.Height));
  rlist.Add('DIBInfo.Planes: ' + inttostr(vDIBInfo.Planes));
  rlist.Add('DIBInfo.BitCount: ' + inttostr(vDIBInfo.BitCount));
  rlist.Add('DIBInfo.Compression: ' + inttostr(vDIBInfo.Compression));
  rlist.Add('DIBInfo.Compression: ' + GetCompressionDesc(vDIBInfo.Compression));
  rlist.Add('DIBInfo.ImageSize: ' + inttostr(vDIBInfo.ImageSize));


  rlist.Add('ImageResolution: '  );   //IIGImageResolution read Get_ImageResolution;
  rlist.Add('ImageResolution.Units:  ' + inttostr(vImageResolution.Units) );
  rlist.Add('ImageResolution.Units:  ' + GetResolutionUnitsDesc(vImageResolution.Units) );
  rlist.Add('ImageResolution.XNumerator:  ' + inttostr(vImageResolution.XNumerator) );
  rlist.Add('ImageResolution.XDenominator:  ' + inttostr(vImageResolution.XDenominator) );
  rlist.Add('ImageResolution.YNumerator:  ' + inttostr(vImageResolution.YNumerator) );
  rlist.Add('ImageResolution.YDenominator:  ' + inttostr(vImageResolution.YDenominator) );

  (*
      property Units: enumIGResolutionUnits read Get_Units write Set_Units;
    property XNumerator: Integer read Get_XNumerator write Set_XNumerator;
    property XDenominator: Integer read Get_XDenominator write Set_XDenominator;
    property YNumerator: Integer read Get_YNumerator write Set_YNumerator;
    property YDenominator: Integer read Get_YDenominator write Set_YDenominator;
  *)

  rlist.Add(' ---  ');

(*
 TIGFormatPageInfo = class(TOleServer)
     ...
    constructor Create(AOwner: TComponent); override;
    destructor  Destroy; override;
    procedure Connect; override;
    procedure ConnectTo(svrIntf: IIGFormatPageInfo);
    procedure Disconnect; override;
    property DefaultInterface: IIGFormatPageInfo read GetDefaultInterface;

    property Format: enumIGFormats read Get_Format;
    property Compression: enumIGCompressions read Get_Compression;
    property ImageWidth: Integer read Get_ImageWidth;
    property ImageHeight: Integer read Get_ImageHeight;
    property BitDepth: Integer read Get_BitDepth;
    property ColorSpace: enumIGColorSpaces read Get_ColorSpace;
    property ImageChannelInfo[Index: Integer]: IIGImageChannelInfo read Get_ImageChannelInfo;
    property ChannelCount: Integer read Get_ChannelCount;
    property ImageTileInfo[Index: Integer]: IIGImageTileInfo read Get_ImageTileInfo;
    property TileCount: Integer read Get_TileCount;
    property DIBInfo: IIGDIBInfo read Get_DIBInfo;
    property ImageResolution: IIGImageResolution read Get_ImageResolution;
*)
end;

function TMagTwain.MagGetFileSize(fileName : wideString) :  int64;
 var
   sr : TSearchRec;
 begin
   if FindFirst(fileName, faAnyFile, sr ) = 0 then
      result := Int64(sr.FindData.nFileSizeHigh) shl Int64(32) + Int64(sr.FindData.nFileSizeLow)
   else
      result := -1;

   FindClose(sr) ;
 end;



procedure TMagTwain.ShowIGProperties(rlist : Tstrings ; m4VGear : TMag4VGear = nil );
var valid : boolean;
     vDIBInfo  : IIGDIBInfo;
     kb : integer;
     vIGPage : IIGpage;
begin
if m4VGear = nil
   then vIGPage := currentpage
   else vIGPage := m4VGear.getCurrentPage;


rlist.add('  ------  IGPage properties  ------  ');




  valid := vIGPage.IsValid;
 rlist.add('IsValid: ' + magbooltostr(valid));
 if not valid then exit;
 rlist.add('ImagePtrGet : ' + inttostr(vIGPage.ImagePtrGet));


 rlist.add('ImageIsGray: ' + MagBoolToStr(vIGPage.ImageIsGray));
 rlist.add('ImageWidth: ' + inttostr(vIGPage.ImageWidth));
 rlist.add('ImageHeight: ' + inttostr(vIGPage.ImageHeight));
 rlist.add('BitDepth: ' + inttostr(vIGPage.BitDepth));
 rlist.add('BitsPerChannel:  ' + inttostr(vIGPage.BitsPerChannel));


vDIBInfo  :=   vIGPage.GetDIBInfo;

  rlist.add('DIBInfo: ' );   //IIGDIBInfo read Get_DIBInfo;
  rlist.add('DIBInfo.Size: ' + inttostr(vDIBInfo.Size));
  rlist.add('DIBInfo.Width: ' + inttostr(vDIBInfo.Width));
  rlist.add('DIBInfo.Height: ' + inttostr(vDIBInfo.Height));
  rlist.add('DIBInfo.Planes: ' + inttostr(vDIBInfo.Planes));
  rlist.add('DIBInfo.BitCount: ' + inttostr(vDIBInfo.BitCount));
  rlist.add('DIBInfo.Compression: ' + inttostr(vDIBInfo.Compression));
  rlist.add('DIBInfo.Compression: ' + GetCompressionDesc(vDIBInfo.Compression));
       kb := trunc(vDIBInfo.imagesize / 1024);
  rlist.add('DIBInfo.ImageSize: ' + inttostr(vDIBInfo.ImageSize) + '   ' + inttostr(kb) + ' kb');

end;



(*
// Constants for enum enumIGSaveFormats
type
  enumIGSaveFormats = TOleEnum;
const
  IG_SAVE_UNKNOWN = $00000000;
  IG_SAVE_BRK_G3 = $00030003;
  IG_SAVE_BRK_G3_2D = $00050003;
  IG_SAVE_BMP_RLE = $00070002;
  IG_SAVE_BMP_UNCOMP = $00000002;
  IG_SAVE_CAL = $00000004;
  IG_SAVE_CLP = $00000005;
  IG_SAVE_DCX = $00000008;
  IG_SAVE_EPS_UNCOMP = $0000000A;
  IG_SAVE_EPS_JPG = $0006000A;
  IG_SAVE_EPS_G3 = $0003000A;
  IG_SAVE_EPS_G4 = $0004000A;
  IG_SAVE_GIF = $0000000E;
  IG_SAVE_ICA_G3 = $00030010;
  IG_SAVE_ICA_G4 = $00040010;
  IG_SAVE_ICA_IBM_MMR = $000F0010;
  IG_SAVE_ICO = $00000011;
  IG_SAVE_IMT = $00000014;
  IG_SAVE_IFF = $00000012;
  IG_SAVE_IFF_RLE = $00070012;
  IG_SAVE_JPG = $00000015;
  IG_SAVE_PJPEG = $00110015;
  IG_SAVE_MOD_G3 = $0003001A;
  IG_SAVE_MOD_G4 = $0004001A;
  IG_SAVE_MOD_IBM_MMR = $000F001A;
  IG_SAVE_NCR = $0000001B;
  IG_SAVE_NCR_G4 = $0004001B;
  IG_SAVE_PBM_ASCII = $0017001C;
  IG_SAVE_PBM_RAW = $0018001C;
  IG_SAVE_PCT = $0000001E;
  IG_SAVE_PCX = $0000001F;
  IG_SAVE_PDF_UNCOMP = $00000038;
  IG_SAVE_PDF_JPG = $00060038;
  IG_SAVE_PDF_G3 = $00030038;
  IG_SAVE_PDF_G3_2D = $00050038;
  IG_SAVE_PDF_G4 = $00040038;
  IG_SAVE_PDF_RLE = $00070038;
  IG_SAVE_PDF_DEFLATE = $000E0038;
  IG_SAVE_PDF_LZW = $00080038;
  IG_SAVE_PS_UNCOMP = $00000066;
  IG_SAVE_PS_JPG = $00060066;
  IG_SAVE_PS_G3 = $00030066;
  IG_SAVE_PS_G3_2D = $00050066;
  IG_SAVE_PS_G4 = $00040066;
  IG_SAVE_PS_RLE = $00070066;
  IG_SAVE_PS_DEFLATE = $000E0066;
  IG_SAVE_PS_LZW = $00080066;
  IG_SAVE_PNG = $00000021;
  IG_SAVE_PSD = $00000024;
  IG_SAVE_PSB = $00000070;
  IG_SAVE_PSD_PACKED = $00010024;
  IG_SAVE_PSB_PACKED = $00010070;
  IG_SAVE_RAS = $00000025;
  IG_SAVE_RAW_G3 = $0003000B;
  IG_SAVE_RAW_G4 = $0004000C;
  IG_SAVE_RAW_G32D = $00050035;
  IG_SAVE_RAW_LZW = $00080000;
  IG_SAVE_RAW_RLE = $00070000;
  IG_SAVE_SGI = $00000026;
  IG_SAVE_SGI_RLE = $00070026;
  IG_SAVE_TGA = $00000027;
  IG_SAVE_TGA_RLE = $00070027;
  IG_SAVE_TIF_UNCOMP = $00000028;
  IG_SAVE_TIF_G3 = $00030028;
  IG_SAVE_TIF_G3_2D = $00050028;
  IG_SAVE_TIF_G4 = $00040028;
  IG_SAVE_TIF_HUFFMAN = $00020028;
  IG_SAVE_TIF_JPG = $00060028;
  IG_SAVE_TIF_LZW = $00080028;
  IG_SAVE_TIF_PACKED = $00010028;
  IG_SAVE_TIF_DEFLATE = $000E0028;
  IG_SAVE_XBM = $0000002B;
  IG_SAVE_XPM = $0000002D;
  IG_SAVE_XWD = $0000002F;
  IG_SAVE_WMF = $0000002C;
  IG_SAVE_WLT = $0000003D;
  IG_SAVE_JB2 = $0000003E;
  IG_SAVE_WL16 = $0000003F;
  IG_SAVE_WBMP = $00000042;
  IG_SAVE_FPX_NOCHANGE = $000D0032;
  IG_SAVE_FPX_UNCOMP = $00000032;
  IG_SAVE_FPX_JPG = $00060032;
  IG_SAVE_FPX_SINCOLOR = $000C0032;
  IG_SAVE_DCM = $00000030;
  IG_SAVE_JBIG = $00000039;
  IG_SAVE_SCI_ST = $0000005B;
  IG_SAVE_LURAWAVE = $00000062;
  IG_SAVE_LURADOC = $00000061;
  IG_SAVE_LURAJP2 = $00000063;
  IG_SAVE_JPEG2K = $00000064;
  IG_SAVE_JPX = $00000065;
  IG_SAVE_HDP = $0000006E;
  IG_SAVE_EXIF_JPEG = $00000047;
  IG_SAVE_EXIF_TIFF = $0000004A;
  IG_SAVE_EXIF_TIFF_LZW = $0008004A;
  IG_SAVE_EXIF_TIFF_DEFLATE = $000E004A;
  IG_SAVE_CGM = $0000004B;
  IG_SAVE_SVG = $0000004D;
  IG_SAVE_DWG = $00000045;
  IG_SAVE_DXF = $00000046;
  IG_SAVE_U3D = $0000004F;
  IG_SAVE_DWF = $0000004E;

*)
function  TMagTwain.GetSaveFormatDesc(value : integer ):string;    //enumIGSaveFormats
begin
case value of
  IG_SAVE_UNKNOWN : result := 'UNKNOWN';
  IG_SAVE_BRK_G3 : result := 'BRK_G3';
  IG_SAVE_BRK_G3_2D : result := 'BRK_G3_2D';
  IG_SAVE_BMP_RLE : result := 'BMP_RLE';
  IG_SAVE_BMP_UNCOMP : result := 'BMP_UNCOMP';
  IG_SAVE_CAL : result := 'CAL';
  IG_SAVE_CLP : result := 'CLP';
  IG_SAVE_DCX : result := 'DCX';
  IG_SAVE_EPS_UNCOMP : result := 'EPS_UNCOMP';
  IG_SAVE_EPS_JPG : result := 'EPS_JPG';
  IG_SAVE_EPS_G3 : result := 'EPS_G3';
  IG_SAVE_EPS_G4 : result := 'EPS_G4';
  IG_SAVE_GIF : result := 'GIF';
  IG_SAVE_ICA_G3 : result := 'ICA_G3';
  IG_SAVE_ICA_G4 : result := 'ICA_G4';
  IG_SAVE_ICA_IBM_MMR : result := 'ICA_IBM_MMR';
  IG_SAVE_ICO : result := 'ICO';
  IG_SAVE_IMT : result := 'IMT';
  IG_SAVE_IFF : result := 'IFF';
  IG_SAVE_IFF_RLE : result := 'IFF_RLE';
  IG_SAVE_JPG : result := 'JPG';
  IG_SAVE_PJPEG : result := 'PJPEG';
  IG_SAVE_MOD_G3 : result := 'MOD_G3';
  IG_SAVE_MOD_G4 : result := 'MOD_G4';
  IG_SAVE_MOD_IBM_MMR : result := 'MOD_IBM_MMR';
  IG_SAVE_NCR : result := 'NCR';
  IG_SAVE_NCR_G4 : result := 'NCR_G4';
  IG_SAVE_PBM_ASCII : result := 'PBM_ASCII';
  IG_SAVE_PBM_RAW : result := 'PBM_RAW';
  IG_SAVE_PCT : result := 'PCT';
  IG_SAVE_PCX : result := 'PCX';
  IG_SAVE_PDF_UNCOMP : result := 'PDF_UNCOMP';
  IG_SAVE_PDF_JPG : result := 'PDF_JPG';
  IG_SAVE_PDF_G3 : result := 'PDF_G3';
  IG_SAVE_PDF_G3_2D : result := 'PDF_G3_2D';
  IG_SAVE_PDF_G4 : result := 'PDF_G4';
  IG_SAVE_PDF_RLE : result := 'PDF_RLE';
  IG_SAVE_PDF_DEFLATE : result := 'PDF_DEFLATE';
  IG_SAVE_PDF_LZW : result := 'PDF_LZW';
  IG_SAVE_PS_UNCOMP : result := 'PS_UNCOMP';
  IG_SAVE_PS_JPG : result := 'PS_JPG';
  IG_SAVE_PS_G3 : result := 'PS_G3';
  IG_SAVE_PS_G3_2D : result := 'PS_G3_2D';
  IG_SAVE_PS_G4 : result := 'PS_G4';
  IG_SAVE_PS_RLE : result := 'PS_RLE';
  IG_SAVE_PS_DEFLATE : result := 'PS_DEFLATE';
  IG_SAVE_PS_LZW : result := 'PS_LZW';
  IG_SAVE_PNG : result := 'PNG';
  IG_SAVE_PSD : result := 'PSD';
  IG_SAVE_PSB : result := 'PSB';
  IG_SAVE_PSD_PACKED : result := 'PSD_PACKED';
  IG_SAVE_PSB_PACKED : result := 'PSB_PACKED';
  IG_SAVE_RAS : result := 'RAS';
  IG_SAVE_RAW_G3 : result := 'RAW_G3';
  IG_SAVE_RAW_G4 : result := 'RAW_G4';
  IG_SAVE_RAW_G32D : result := 'RAW_G32D';
  IG_SAVE_RAW_LZW : result := 'RAW_LZW';
  IG_SAVE_RAW_RLE : result := 'RAW_RLE';
  IG_SAVE_SGI : result := 'SGI';
  IG_SAVE_SGI_RLE : result := 'SGI_RLE';
  IG_SAVE_TGA : result := 'TGA';
  IG_SAVE_TGA_RLE : result := 'TGA_RLE';
  IG_SAVE_TIF_UNCOMP : result := 'TIF_UNCOMP';
  IG_SAVE_TIF_G3 : result := 'TIF_G3';
  IG_SAVE_TIF_G3_2D : result := 'TIF_G3_2D';
  IG_SAVE_TIF_G4 : result := 'TIF_G4';
  IG_SAVE_TIF_HUFFMAN : result := 'TIF_HUFFMAN';
  IG_SAVE_TIF_JPG : result := 'TIF_JPG';
  IG_SAVE_TIF_LZW : result := 'TIF_LZW';
  IG_SAVE_TIF_PACKED : result := 'TIF_PACKED';
  IG_SAVE_TIF_DEFLATE : result := 'TIF_DEFLATE';
  IG_SAVE_XBM : result := 'XBM';
  IG_SAVE_XPM : result := 'XPM';
  IG_SAVE_XWD : result := 'XWD';
  IG_SAVE_WMF : result := 'WMF';
  IG_SAVE_WLT : result := 'WLT';
  IG_SAVE_JB2 : result := 'JB2';
  IG_SAVE_WL16 : result := 'WL16';
  IG_SAVE_WBMP : result := 'WBMP';
  IG_SAVE_FPX_NOCHANGE : result := 'FPX_NOCHANGE';
  IG_SAVE_FPX_UNCOMP : result := 'FPX_UNCOMP';
  IG_SAVE_FPX_JPG : result := 'FPX_JPG';
  IG_SAVE_FPX_SINCOLOR : result := 'FPX_SINCOLOR';
  IG_SAVE_DCM : result := 'DCM';
  IG_SAVE_JBIG : result := 'JBIG';
  IG_SAVE_SCI_ST : result := 'SCI_ST';
  IG_SAVE_LURAWAVE : result := 'LURAWAVE';
  IG_SAVE_LURADOC : result := 'LURADOC';
  IG_SAVE_LURAJP2 : result := 'LURAJP2';
  IG_SAVE_JPEG2K : result := 'JPEG2K';
  IG_SAVE_JPX : result := 'JPX';
  IG_SAVE_HDP : result := 'HDP';
  IG_SAVE_EXIF_JPEG : result := 'EXIF_JPEG';
  IG_SAVE_EXIF_TIFF : result := 'EXIF_TIFF';
  IG_SAVE_EXIF_TIFF_LZW : result := 'EXIF_TIFF_LZW';
  IG_SAVE_EXIF_TIFF_DEFLATE : result := 'EXIF_TIFF_DEFLATE';
  IG_SAVE_CGM : result := 'CGM';
  IG_SAVE_SVG : result := 'SVG';
  IG_SAVE_DWG : result := 'DWG';
  IG_SAVE_DXF : result := 'DXF';
  IG_SAVE_U3D : result := 'U3D';
  IG_SAVE_DWF : result := 'DWF';
  else result := 'UnDefined Save Format';
  end;
end;

end.

 (*
 // Constants for enum enumIGSysDataType
type
  enumIGSysDataType = TOleEnum;
const
  AM_TID_META_INT8 = $00000015;
  AM_TID_META_UINT8 = $00000016;
  AM_TID_META_INT16 = $00000017;
  AM_TID_META_UINT16 = $00000018;
  AM_TID_META_INT32 = $00000019;
  AM_TID_META_UINT32 = $0000001A;
  AM_TID_META_BOOL = $0000001B;
  AM_TID_META_STRING = $0000001C;
  AM_TID_META_RATIONAL_UINT32 = $0000001D;
  AM_TID_META_RATIONAL_INT32 = $0000001E;
  AM_TID_META_FLOAT = $0000001F;
  AM_TID_META_DOUBLE = $00000020;
  AM_TID_RAW_DATA = $00000021;
  AM_TID_META_INT64 = $00000022;
  AM_TID_META_UINT64 = $00000023;
  AM_TID_META_STRING32 = $00000024;
  AM_TID_META_STRING64 = $00000025;
  AM_TID_META_STRING128 = $00000026;
  AM_TID_META_STRING255 = $00000027;
  AM_TID_META_STRING1024 = $00000028;
  AM_TID_META_STRING_UNICODE512 = $00000029;
  AM_TID_META_DRECT = $0000002A;
 *)

 (*
  TIGDataItem = class(TOleServer)

  public
    constructor Create(AOwner: TComponent); override;
    destructor  Destroy; override;
    procedure Connect; override;
    procedure ConnectTo(svrIntf: IIGDataItem);
    procedure Disconnect; override;
    procedure ChangeType(newType: enumIGAbsDataType);
    property DefaultInterface: IIGDataItem read GetDefaultInterface;
    property type_: enumIGAbsDataType read Get_type_;
    property Rectangle: IIGRectangle read Get_Rectangle;
    property Array_: IIGDataArray read Get_Array_;
    property DLong: IIGDLong read Get_DLong;
    property DoubleRectangle: IIGDoubleRectangle read Get_DoubleRectangle;
    property Long: Integer read Get_Long write Set_Long;
    property Boolean: WordBool read Get_Boolean write Set_Boolean;
    property String_: WideString read Get_String_ write Set_String_;
    property Double: Double read Get_Double write Set_Double;
*)
(*
type
  enumIGAbsDataType = TOleEnum;
const
  IG_DATA_LONG = $00000000;
  IG_DATA_BOOLEAN = $00000001;
  IG_DATA_STRING = $00000002;
  IG_DATA_RECTANGLE = $00000003;
  IG_DATA_D_LONG = $00000004;
  IG_DATA_DOUBLE = $00000005;
  IG_DATA_ARRAY = $00000006;
  IG_DATA_DBL_RECTANGLE = $00000007;
  IG_DATA_LUT = $00000008;
  IG_DATA_RATIONAL = $00000009;
*)


