Unit UMagClasses;
  {
   Package: MAG - VistA Imaging
 WARNING: Per VHA Directive 10-93-142 this unit should not be modified.
 Date Created:    2002
 Site Name: Silver Spring, OIFO
 Developers: Garrett Kirin
[==  unit uMagClasses;
 Description:
           Image Classes
           TImageData: This object encapsulates information about the
           image entry from the IMAGE File (^MAG(2005,)).
           It is used extensively through out the application.
           Created when the TmagImageList object retrieves a list of images
           from the database, TMagImageList calls -
               function   StringToTImageData(....  Used to be called "StringToIMageObj(str:"...
               returns a TmageData;
           passing the '^' delimited string returned by the RPC, RPMaggImageInfo and receiving
           a TImageData object in return.  The object is then added to the ObjList :Tlist
           property of TmagImageList.
           M routine MAGGTII creates the string.

           TMagDICOMData:    Not Implemented.
             Prototype for Implementing full display ability
             of any type of image in MagViewer component. Needs input from
             Ruth. Ruth is developing a unit that any object can call, to
             use her current DisplayAnyImage code.  Also Waiting for newest
             version of AccuSoft.

           TmagDragImageObject:   Not Implemented.
              Prototype for dragging image lists between applications.
                not implemented.

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
Interface

Uses
  Classes,
  Controls,
  ExtCtrls,
  Graphics,
  WinTypes
  ;

//Uses Vetted 20090929:inifiles, Menus, Grids, Dialogs, Messages, WinProcs, StdCtrls, Forms, SysUtils

 // p93  moved here from maggut1, and made an Object, not a record.
Type
  Tuserpreferences = Class(Tobject) //  userpreferences = record
    PDFConvertAll: Boolean;
    PDFConvertGroup: Boolean;
    PDFConvertColor: Boolean;
    PDFConvert1bit: Boolean;
    SaveSettingsOnExit: Boolean;

    UseAltViewerForVideo, PlayVideoOnOpen, UseAltViewerForPDF: Boolean;
    UseDelImagePlaceHolder:  boolean; //p117       upref
    DispReleaseNotes: String;
    CapReleaseNotes: String;

    Fulltoolbar: Boolean;
    FullCols: Integer;
    FullMaxLoad: Integer;
    FullRows: Integer;
    FullLockSize: Boolean;
    FullFitMethod: Integer;
    FullControlPos: String;

    // p93 cleanup  Doctoolbar: boolean;    DocCols: integer;    DocMaxLoad: integer;    DocRows: integer;   DocLockSize: boolean;

    AbsStyle: byte; { 0 - MDIChild, 1 - MDIForm   2 - Normal 3 - StayOnTop}
    AbsPos: Trect; { top,  left , width, height  }
    AbsToolBar: Boolean;
    AbsCols: Integer;
    AbsMaxLoad: Integer;
    AbsRows: Integer;
    AbsLockSize: Boolean;
    AbsToolBarPos: Integer;
    AbsWidth: Integer;
    AbsHeight: Integer;
    AbsShowWindow: Boolean; { make it visible on patient selection}
    AbsFontSize: Integer;
    AbsViewJBox: Boolean;
    AbsRevOrder: Boolean;
    AbsViewRemote: Boolean;

    GrpShowWindow: Boolean; // Not used.  ... yet.    // p93 was showgrpwindow
    Grptoolbar: Boolean;
    GrpCols: Integer;
    GrpMaxLoad: Integer;
    GrpRows: Integer;
    GrpLockSize: Boolean;
    GrpToolBarPos: Integer;
    GrpFontsize: Integer;
    Grpstyle: byte;
    Grppos: Trect;
    Grpabswidth: Integer;
    Grpabsheight: Integer;

    Showmuse: Boolean;
    Shownotes: Boolean;
    ShowImageListWin: Boolean; { make it visible on patient selection}
    ShowRadListWin: Boolean; { run the call to get rad exam list}

    Getmain: Boolean;
    Getabs: Boolean;
    Getnotes: Boolean;
    Getmuse: Boolean;
    Getdicom: Boolean;
    Getfull: Boolean;
    Getgroup: Boolean;
    Getdoc: Boolean;
    Getreport: Boolean;
    GetImageListWin: Boolean;
    GetRadListWin: Boolean;

    Mainstyle: byte; { 0 - MDIChild, 1 - MDIForm   2 - Normal 3 - StayOnTop}
    Mainpos: Trect; { top,  left , width, height  }
    Maintoolbar: Boolean; {0 False, 1 - true}
    Mainshowhint: Boolean;

    Musestyle: byte;
    Musepos: Trect;

    Notesstyle: byte;
    Notespos: Trect;

    ImageListWinstyle: byte;
    ImageListWinpos: Trect;
    ImageListWincolwidths: String;
    ImageListPrevAbs: Boolean;
    ImageListPrevReport: Boolean;
    ImageListDefautFilter: String;
    ImageListToolbar: Boolean;
    ImageListFilterAsTabs: Boolean;
    Imagelistmultilinetabs: Boolean;

    RadListWinstyle: byte;
    RadListWinpos: Trect;
    RadListWinToolbar: Boolean;

    Dicomstyle: byte; {'DICOMWIN'}
    Dicompos: Trect;
    {upref.dicompos.bottom := strtoint(magpiece(t[i], '^', 6));}

    //  72 new uprefs for Rad Window. .. p93 mod code
{  1) Allow use of Reader for PDF.  }
      {above   UseAltViewerForPDF:  boolean;}

{  2) Store the speed of the image scrolling on the Radiology Viewer  }
    DicomScrollSpeed: Integer;

{  3) Store the speed of the CINE tool scrolling  }
    DicomCineSpeed: Integer;

{  4) Store the default stack view paging settings **   Page With Different Settings, Page With Same Settings, Page With Image Settings}
    DicomStackPaging: Integer;

{  5) Store the default layout view paging settings :  Use Selected Window Settings, Use Individual Image Settings }
    DicomLayoutSettings: Integer;

{  6) Store if stacks should page together by default  }
    DicomStackPageTogether: Boolean;

{  7) Store if labels are displayed on images by default  I am concerned that this will be a patient safety issue if we let people turn off the labels.  }
    DicomShowOrientationLabels: Boolean;

{  8) Store if pixel values are displayed by default  }
    DicomShowPixelValues: Boolean;

{  9) Store the color specified by the user for ruler measurments  }
    DicomMeasureColor: Integer; {Hex String ? }

{10) Store the line width specified by the user for ruler measurements  }
    DicomMeasureLineWidth: Integer;

{11) Store the unit of measure for ruler}
    DicomMeasureUnits: String;
{ 12) Image Settings : use device window level settings (1) or Histogram window level settings (2) }
    DicomDeviceOptionsWinLev: Integer;

{13) Determines if scout lines should be drawn on CT and MR images }
    DicomDisplayScoutLines : boolean;

{14) Determines if the scout window should be displayed automatically for CT studies}
    DicomDisplayScoutWindow : boolean;

    DicomScoutLineColor : Integer; 

    Reportstyle: byte;
    Reportpos: Trect;
    Reportfont: TFont;
    // p93 cleanup      docstyle: byte;      docpos: trect;    docfitwidth: byte;    docfitheight: byte;

    Fullstyle: byte; { 0 - MDIChild      1 = seperate window }
    Fullpos: Trect;
    Fullimagewidth: Integer;
    Fullimageheight: Integer;
    Fullfontsize: Integer;

    // JMW 6/22/2005 p45
    // Remote Image View Preferences
    RIVAutoConnectEnabled: Boolean;
    RIVAutoConnectVISNOnly: Boolean;
    RIVHideEmptySites: Boolean;
    RIVHideDisconnectedSites: Boolean;
    RIVAutoConnectDoD: Boolean; {/ P117 NCAT - JK 12/15/2010 /}
    RIVHideEmptyToolbar: Boolean; {This is not currently used, maybe later}

    // JMW 1/12/2006 p46
    // TeleReader User Preferences
    TRWinStyle: byte;
    TRPos: Trect;
    TRUnreadColumnWidths: String;
    TRReadColumnWidths: String;
    TRAutoLaunchCPRSImaging: Boolean;
    TRViewAllStudies: Boolean;
    TRShowSpecialtiesAtStartup: Boolean;
    TRSaveSettingsOnExit: Boolean;
    TRgetTeleReader: Boolean;

    UseGroupAbsWindow: Boolean; //72
    UseNewRadiologyWindow: Boolean; //72
    LoadStudyInSingleImageFullRes: Boolean; //72

    {gek p93  Add new preferences.}
    StyleShowTree: Boolean; //pnlTree.visible
    StyleAutoSelect: Boolean; //F
    StyleAutoSelectSpeed: Integer;
    StyleSyncSelection: Boolean;
    StyleWhereToShowImage: Integer; // 0 List Win,  1 Full Res.

    /// CHANGED TO NEXT    StyleWhereToShowAbs : integer ;   // 0 List Win,  1  Abs Window.
    StyleWhetherToShowAbs: Integer; // 0 No Show,  1  Show.
    StylePositionOfAbs: Integer; // 0 Left, 1 bottom, 2 in Tree. 3 = Seperate Window (3 is new)

    StyleTreeSortButtonsShow: Boolean;
    StyleTreeAutoExpand: Boolean;
    StyleShowList: Boolean;

    StyleListAbsScrollHoriz: Boolean;
    StyleListFullScrollHoriz: Boolean;

    StyleControlPos: String;
    (* Keep the next properties around until the DB okays the fields.
        in the past we've been 'ordered' to have a field for each property.
    StyleReportH : integer;
    StyleAbsPanelH : integer;
    StyleAbsPanelW : integer;
    StyleAbsRows : integer;
    StyleAbsCols : integer;
    StyleTreeW : integer;
    StyleListPanelH : integer;
    StyleAbsPrevPanelW : integer;
    StyleAbsPrevH : integer;

    Toolbarvisible
    LastFit Method    *)

    VerifyShowReport: Boolean;
    VerifyShowInfo: Boolean;
    VerifyHideQFonSearch: Boolean;
    VerifySingleView: Boolean;
    VerifyColWidths: String;
    VerifyControlPos: String;

    VerifyStyle: byte;
    VerifyPos: Trect;

    EditStyle: byte;
    EditPos: Trect;
    SuppressPrintSummary : boolean;

    {/ P122 - JK 6/6/2011 - Annotations Settings /}
//    ArtXSettings: String;             {/p122 dmmn WPR Capture Item #26 /}
//    ArtXSettingsCapture : String;     {/p122 dmmn 7/5/11 /}
    ArtXSettingsDisplay : String;

  End;

Type
  {Prototype for dragging image lists between applications.
   not implemented.}
  TmagDragImageObject = Class(TDragObject)
  Public
    DraggedImages: Tlist;
  End;
  {Prototype for Implementing full display ability of any type of
   image in MagViewer component.
   Needs input from Ruth, as to Dicom data needed.
    Not Implemented.
   Waiting for newest version of AccuSoft.}
  TMagDICOMData = Class(Tobject)
  Public
    PtName: String; {P5}
    PtID: String[11]; {P5}
    Modality: String[10];
    PixelSpace1: Real;
    PixelSpace2: Real;
    PixelSpace3: Real;
    Haunsfield: Smallint;
    SliceThickness: Real;
    Pt_Pos: String[3];
    Laterality: String[20];
    SliceLoc: Real;
    Rescale_Int: Real;
    Rescale_Slope: Real;
    Window_Center: Smallint; {from DICOM hdr}
    Window_Width: Smallint; {from DICOM hdr}
    Rows: Smallint;
    Columns: Smallint;
    Filename: String; {RED 2/7/02}
    PatOr1: String;
    PatOr2: String;
    ImageOr: Array[1..6] Of Real;
    BitDepth: Integer; {from Accusoft call, DICOM only}
    Bits: Integer; {from text file} {P5}
    Seriesno: Real;
    Imageno: String; {P5}
    Contrast: String;
    Originalbits: Integer; {when image is loaded, this is the no. of bits}
    Protocol: String;
    Warning: Integer;
    BigFile: String; {P5}
    //oo1 gearcontrol: tgear; {RED 1/31/02}
    //oo1 medcontrol: tmed; {RED 1/31/02}
    Panel: Tpanel; {RED 10/20/02}
    Panelback: Tpanel;
    GList: Tlist; {RED 11/02/02}
    Imagect: Integer; {RED 11/24/02 - count of images in group in this display control}
    Minpixel: Longint; {from Init procedure}
    Maxpixel: Longint;
    Winposition: Longint;
    Levposition: Longint;
    //oo1 imgtype: integer; {RED 3/20/02}  {1 = DICOM; 2 = TGA 8 BITS; 3 = TGA >8 BITS; 4 = OTHER -- corresponds to init performed}
    Imagebittype: Integer; {RED 3/20/02} {1 = DICOM; 2 = TGA 8 BITS; 3 = TGA >8 BITS; 4 = OTHER -- corresponds to init performed}
    Ien: Integer;
    ImageIndex: Integer;
    Magien: Integer; {RED 12/7/02}
    Smallest_PixelVal: Longint; {RED 7/25/02 from DICOM hdr}
    Largest_PixelVal: Longint; {RED 7/25/02 from DICOM hdr}
    Pos_Ref_Indicator: String;
    Dicomimage: Boolean;
    GListState: Boolean;
    Blank: String;

    //oo1 procedure clearDICOMRecorda(winnum: integer; ClearList: boolean);
    Procedure ClearData;
  End;

  TImageData = Class(Tobject)
  Private

   {}

  Public

{   NOTE: Any Change (Add/Delete) to a property here must be accompied by
          an appropriate change in MagAssign, Clear and StringToTImageData }

{NOTE - JK 7/23/2011, don't forget to add new pieces to cMagDBMVista.GetSerialMapping for remote image views }

    Mag0: String; //Image IEN                    Fld 001
    AFile: String; //Full Path of Abstract
    FFile: String; //Full Path of Image
    ImgDes: String; //SHORT DESCRIPTION            Fld 10
    ImgType: Integer; //OBJECT TYPE                  Fld 3
    PtName: String; //Patient Name
    Date: String; //PROCEDURE EXAM DATE/TIME     Fld 15
    Proc: String; //PROCEDURE                    Fld 6
    AbsLocation: String; //M,W,O

    {research for 72 shows : possible values for FFullLocation are
      A = accessible
      O = Offline.
      }

    FullLocation: String; //A,O
    DicomImageNumber: String; //if one exists for image. Fld 2
                                       //  is a field in the OBJECT GROUP Mult
    DicomSequenceNumber: String; //if one exists for image. Fld 1
                                       //  is a field in the OBJECT GROUP Mult
    BaseIndex: Integer; // used internally by Mag4Viewer.
    QAMsg: String; // If QA check produces a warning
                                       //  it is put here
    BigFile: String; //Full Path to BIG File.
    DFN: String; //Patient DFN                  Fld 5
    SSN: String; //Patient SSN
    MagClass: String; //CLASS INDEX                  Fld 41
    GroupCount: Integer; //Number of images in this group
    IGroupIEN: Integer; //GROUP PARENT                 Fld 14
    IGroupIndex: Integer; //in the ObjList : Tlist maintained by TMagimageList

    ICh1IEN: Integer; //93 First Childs IEN, if this is a Group
    ICh1Type: Integer; // 93 First Childs Object Type, if this is a Group

    //DBI
    PlaceCode: String;
    PlaceIEN: String;

    CaptureDate: String; //59         //Date/Time Image Saved Fld 7
    DocumentDate: String; //59         //Document Date   Fld 110

    ServerName: String; //45
    ServerPort: Integer; //45

    StudyIEN: String;

//93
    {   0:NO;1:YES}
    MagSensitive: Boolean;

    {     Could be a combination of : DTQ or Null
         12 : D  Deleted image
         21:  Q  Questionable integrity
         22:  T  Can't view the TIU note
         23:  R  Radiology Exam Status.
 }
    MagViewStatus: Integer;

    {   1:Viewable;2:QA Reviewed;10:In Progress;11:Needs Review;12:Deleted}
    MagStatus: Integer;

    {/ P122 - JK 6/4/2011 /}
    Annotated: Boolean;  {False=no annotation on image, True=image contains one or more annotations}

    {/ P122 - JK 7/5/2011 /}
    Resulted: String;  {0 or empty string = false, 1 = true}

    {/ P122 - JK 7/21/2011 /}
    AnnotationStatus: Integer;  {0 = OK to annotate. >0 = cannot annotate. The value >0 is the reason code }

    {/ P122 - JK 7/27/2011 /}
    AnnotationStatusDesc: String; {This is a message corresponding to the AnnotationStatus piece}

    {/ P122 - JK 7/21/2011 /}
    Package: String;  {The package mnemonic for where the image is associated: RAD, LAB, SUR, MED, NONE, PHOTOID, etc.}



    Function StringToTImageData(Str: String; Vserver: String = ''; Vport: Integer = 0): TImageData;
    {    Returns an Description to use by application
        [Dicom numbers], Image Description,  Procedure, Proc Exam Date/Time }
    Function ExpandedDescription(Lf: Boolean = True): String;
    {   Returns an Description to use by application
        Image IEN, [Dicom numbers], Image Description,  Procedure, Proc Exam Date/Time }
    Function ExpandedIDDescription(Lf: Boolean = True): String;
    {   Assigns all values from one TImageData to another. Makes a Copy}
    Procedure MagAssign(IData: TImageData);
    Function ExpandedIdDateDescription(Lf: Boolean = True): String;

    // clears all fields
    Procedure Clear();

    Function ExpandedDescDtID(Lf: Boolean = True): String;
    Function ExpandedMLDescription(): String;
    Function IsOnOffLineJB(): Boolean;
    Function IsInImageGroup: Boolean;
    Function IsImageGroup: Boolean;
    Function IsRadImage: Boolean;
    Function SyncIEN: String;
    Function SyncIENG: String;
    Function IsViewAble: Boolean;
    Function GetViewStatusMsg: String;
    Function GetStatusDesc: String;

    {/ P117 - JK 9/13/2010 - function to determine if the image is deleted (MagStatus = 12) /}
    function IsImageDeleted: Boolean;

    {/ P117 - BB 1/17/2011 - function to determine if the image is from DOD /}
    function IsImageDOD: Boolean;

    {/ P122 - JK 7/21/2011 /}
    function ImageAllowsAnnotating: String;  {The returned value is a message. If the message is not 'Y',
                                              then it explains why the user cannot annotate the image}

    function IsSame(IObj : TImageData) : boolean;

  End;

  TMagAnnotationItem = Class(Tobject)
  Private
  Public
    FAnnotationID: String; // some sort of IEN
    FPatientDFN: String; // DFN of patient Annotations are attached to (might want to use ICN instead)
    FTitle: String; //Title of annotation
    // optional fields
    FDescription: String; // description of annotation
    FProvider: String;
  End;

  // JMW 4/14/2006 p72, functions that indicate what the display (gear)
  // component can do (and can't do)
  TMag4VGearFunction = (MagAnnotation, MagDICOM, MagDICOMHeader, MagWinLev, MagPanWindow);

  TMag4VGearFunctions = Set Of TMag4VGearFunction;

  // JMW 4/12/2006 p72
  TDicomData = Class(Tobject)
  Private

  Public
    PtName: String; {P5}
    PtID: String[11]; {P5}
    STUDY_ID: String; {set from TEXT file STUDY_ID, used to set ViewerRec.prevstudy and .currentstudy}
    Modality: String[10];
    PixelSpace1: Real;
    PixelSpace2: Real;
    PixelSpace3: Real;
    Haunsfield: Smallint;
    SliceThickness: Real;
    Pt_Pos: String[3];
    Laterality: String[20];
    SliceLoc: Real;
    Rescale_Int: Real;
    Rescale_Slope: Real;
    Window_Center: Smallint; {from DICOM hdr}
    Window_Width: Smallint; {from DICOM hdr}
    Rows: Smallint;
    Columns: Smallint;
    Filename: String; {RED 2/7/02}
    PatOr1: String;
    PatOr2: String;
    ImageOr: Array[1..6] Of Real;
    BitDepth: Integer; {from Accusoft call, DICOM only}
    //bits: integer; {from text file, adjusted for samples/pixel}   {RED 12/01/03}
    Bits: Integer; // not adjusted for samples/pixel
    SamplesPerPixel: Integer;

    Seriesno: Real; {from text file, SERIES_NUMBER, used for caption,hint,info window,cleared to 0}
    Imageno: String; {from text file IMAGE_NUMBER or INSTANCE_NUMBER, used for caption, hint, info, cleared to 0}
    Contrast: String;
    Originalbits: Integer; {when image is loaded, this is the no. of bits}
    Protocol: String;
    Warning: Integer;
    BigFile: String;

//    GList: TList;
    Imagect: Integer; {RED 11/24/02 - count of images in group in this display control}
    Minpixel: Longint; {from Init procedure}
    Maxpixel: Longint;
    Winposition: Longint;
    Levposition: Longint;
    ImgType: Integer; {RED 3/20/02} {1 = DICOM; 2 = TGA 8 BITS; 3 = TGA >8 BITS; 4 = OTHER -- corresponds to init performed; 5 = COLOR DICOM;}
    //ien: integer;{used when for paging label if previous image failed to load because no big file or integrity problem}
    ImageIndex: Integer; {set to ien passed in PassFileLst from group or abstract window}
    GroupIndex: Integer; {set to group ien passed in PassFileLst from group or abstract window} {RED 07/17/04}
    //magien: integer; {piece 6 of FlInfo = MagO from M, passed by PassFileLst from abstract or group window}
    Smallest_PixelVal: Longint; {RED 7/25/02 from DICOM hdr}
    Largest_PixelVal: Longint; {RED 7/25/02 from DICOM hdr}
    Pos_Ref_Indicator: String;
    Dicomimage: Boolean;
    GListState: Boolean;
    Blank: String;
    Orient: Integer;
    Studydesc: String; {RED 03/21/04}
    Photometric: String; {RED 03/21/04}
    WinLev: String; {RED 10/18/04} {WL=window/level for b/w or BC=brightness/contrast for color}
    DicomDataSource: String; // JMW determines where the DICOM data came from (DICOM header, txt file)
    SeriesDescription: String; // JMW Patch 72 2/6/2007
    ImagerPixelSpace1: Real; // JMW Patch 72 12/3/2007  (0018,1164)
    ImagerPixelSpace2: Real; // JMW Patch 72 12/3/2007  (0018,1164)
    MagnificationFactor: Real; // JMW Patch 72 12/3/2007  (0018,1114)
    DistancePatientToDetector: Real; // JMW Patch 72 12/3/2007  (0018,1111)
    DistanceSourceToDetector: Real; // JMW Patch 72 12/3/2007  (0018,1110)
    SOPClassUid: String; // JMW Patch 72 12/4/2007 (0008, 0016)
    PatientICN: String; // JMW Patch 72 5/8/2008 need to hold onto the patient ICN for comparison

    // New fields for Scout Lines (Patch 131)
    ImagePosition : array[1..3] of String; // JMW Patch 131 4/10/2013 (0020,0032)
    ImageOrientation : array[1..6] of String; // JMW Patch 131 4/10/2013 (0020,0037)
    PixelSpacing : array[1..3] of String; // JMW Patch 131 4/10/2013 (0028,0030)
    FrameOfReferenceUid : String; // JMW Patch 131 4/10/2013 (0020,0052)
    //ImageType : Array[1..4] of String; // JMW Patch 131 4/10/2013 (0008,0008)
    IsImageTypeLocalizer : boolean; // JMW Patch 131 4/10/2013 from (0008,0008)

    Procedure ClearFields();
    Function GetLevelOffset(ForceInclude: Boolean = False): Integer;
    function ToDelimitedString(Input : array of string; delimiter : string) : String;
    function IsScoutInformationAvailable() : boolean;
  End;

  { Description }
  TRemoteSensitiveData = Class(Tobject) //45
  Private
    FRemotePatientDFN: String;
    FRemoteSensitiveCode: Integer;
    FRemoteServerName: String;
    FRemoteServerPort: Integer;
    FRemoteMsg: TStrings;
    FRemoteSiteName: String;
    FSiteApproved: Boolean;

    Procedure SetRemotePatientDFN(Value: String);
    Procedure SetRemoteSensitiveCode(Value: Integer);
    Procedure SetRemoteServerName(Value: String);
    Procedure SetRemoteServerPort(Value: Integer);
    Procedure SetRemoteMsg(Value: TStrings);
    Procedure SetRemoteSiteName(Value: String);
    Procedure SetSiteApproved(Value: Boolean);
  Public
    Property RemotePatientDFN: String Read FRemotePatientDFN Write SetRemotePatientDFN;
    Property RemoteSensitiveCode: Integer Read FRemoteSensitiveCode Write SetRemoteSensitiveCode;
    Property RemoteServerName: String Read FRemoteServerName Write SetRemoteServerName;
    Property RemoteServerPort: Integer Read FRemoteServerPort Write SetRemoteServerPort;
    Property RemoteMsg: TStrings Read FRemoteMsg Write SetRemoteMsg;
    Property RemoteSiteName: String Read FRemoteSiteName Write SetRemoteSiteName;
    Property SiteApproved: Boolean Read FSiteApproved Write SetSiteApproved;
    Function GetSensitiveCodeMesssage(): String;
  End;

Type
  CprsSyncOptions = Record
    Queried: Boolean;
    SyncOn: Boolean;
    PatSync: Boolean;
    PatSyncPrompt: Boolean;
    PatRejected: String;
    ProcSync: Boolean;
    ProcSyncPrompt: Boolean;
    HandleSync: Boolean;
    HandleSyncPrompt: Boolean;
    CprsHandle: Hwnd;
    HexHand: String; {This is the handle sent in the Message from CPRS
       It’s hidden in Hexidecimal, we need to convert}

    HandleRejected: Hwnd;
  End;

  TMagIdName = Class(Tobject)
    ID: String;
      Name: String;
  End;

  TmagFieldValue = Class(Tobject)
    Number: String;
    Int: String;
    Ext: String;
    Lbl: String;
    Procedure Clear();
    Procedure Assign(Value: TmagFieldValue);
    Procedure SetVal(Value: String);
  End;
  TMagSettingsWrks = Class(Tobject)
        {       Wrks default Visit Location (Hospital Location)
                used when creating a New Note.}
    VLoc: String;
    Function VLocDA: String;
    Function VLocName: String;
(*  from old MagRec unit
  AllowSaveToDemo : boolean;
  WrksLocation: string;
  WrksCompName:string;
  LASTMAGUPDATE:string;
  LASTMUSEUPDATE:string;
  NTSecurity  : boolean;
  dual   : boolean;
  Rad2k  : boolean;
  ViewAbs : boolean;
  DOME   : boolean;
  LoginOnStartup : boolean;
  WSID : string;
  IniLogAction :  boolean;
  MuseDemoMode : Boolean;
  *)
  End;

  {/ P117-NCAT - JK 11/18/2010 - TMagUrlMap class encapsulates the conversion
     of URL names into Windows filenames.  URL names typically are longer than
     260 characters which invalidates them as a proper Windows filename.  The
     mapping creates a filename unique to the Clinical Display session (gsess).
     The session filename is the concatenation of a session timestamp with
     an incremental value from zero upwards.  If an image object is part of
     a group then a "G" is added to the filename.  When the session is closed the
     mapping is destroyed along with the physical files in local cache. In the
     event the local cache is not deleted, the next session will use a new
     timestamp to ensure uniqueness. /}

  {Name=Value pairs where Name = URL and Value = Windows Filename}

  TMagUrlMap = class
  const
    NVDelimiter = '^'; {NameValueDelimiter: Cannot use a "=" since it is legal in a URL}
    mapNotFound = 'URLMAP-NOTFOUND';
  private
    FUrlList: TStrings;
    FTimeStamp: String;
    NextID: Integer;
    function GetNewFileName(isImageAGroupMember: Boolean): String;
    function isMSWord2003InMime(AUrl: String): Boolean;  {.doc mime type}
    function isMSWord2007InMime(AUrl: String): Boolean;  {.docx mime type}
    function isAsciiInMime(AUrl: String): Boolean;
    function isPdfInMime(AUrl: String): Boolean;
    function isUrlAlreadyMapped(AURL: String): Boolean;
  public
    constructor Create;
    destructor Destroy;    override;
    property Timestamp: String read FTimestamp;
    function Add(const AUrl: String; const GroupMember: Boolean = False): Integer;
    function Count: Integer;
    function Find(const AUrl: String): String;
    function Get(Idx: Integer): String;
    function MapURN(S: String): String; {/ P122 - JK 8/29/2011 /}
    procedure StoreToDisk(Filename : String);
    Procedure LoadFromDisk(Filename : String);
  end;

  {/ P122 - P123 JK 8/25/2011 /}
  TMagAgency = class(TObject)
  Private
    FAgencyID: String;
//    FAgencyName: String;
    function GetIHS: Boolean;
    function GetVA: Boolean;
    function GetAgencyName: String;
    function GetAgencyAbbr: String;
    function GetAgencyDBName: String;
  Public
    property AgencyID: String read FAgencyID write FAgencyID;
    property IHS: Boolean read GetIHS;
    property VA: Boolean read GetVA;
    property AgencyName: String read GetAgencyName;
    property AgencyAbbr: String read GetAgencyAbbr;
    property AgencyDBName: String read GetAgencyDBName;
  end;


  TSession = Class(Tobject)
  Private
  //
  Public

  { These are TSession fields}
    WrksPlaceCODE,
    WrksPlaceIEN,
    WrksInstStationNumber: String;
//     WrksInst : String; //  Later we need to change this to a TMagIDName;
    Wrksinst: TMagIdName;
    WrksConsolidated: Boolean;
     // JMW 9/30/2009 p94, kernel broker security token used for remote connections
    SecurityToken: String;
          { TODO -oGarrett -cRefactor : We want to get these Global VAriables into the TSession Object. }
 (*
     LocalUserStationNumber : String;
     VistADomain : String;
     PrimarySiteStationNumber : String;
     ExternalPatientChange : boolean;
     DebugUseOldImageListCall : boolean; //93

  {  CPRSSyncOptions is TRecord created for the interaction between CPRS and
     imaging.  The record was used in the first Imaging <-> CPRS design.
     In this design the user would get prompted if other CPRS window sent
     a message, or any CPRS window changed Patient.  Most of this functionality
     and properties are not used now but ... Care Management... CCOW... }
  CPRSSync: CPRSSyncOptions;
    {  used in old linking method with CPRS, and in Capture. not anymore.}
  cprsFlag: boolean;
  {     set to TRUE if CPRS starts imaging.}
  CPRSStartedME: boolean;
  {}
  startmode : integer; {[1|2]  1 = Started standalone,  2 = Started by CPRS. }
  MUSEconnectFailed: boolean;
  { set from INI or DataBase  TIMEOUT WINDOWS DISPLAY: IMAGING SITE PARAMTERS Field : TIMEOUT WINDOWS DISPLAY}
  WorkStationTimeout: longint;
  MUSEenabled: boolean;
  {  if user want to see selection list when application starts up.}
  allowremotelogin: boolean;

  QueImage: string;

  { TprocessInformation is a windows structure that we use to execute a program
    and keep a link to it.  We can tell if it is open, or closed, or we can close it }
  // EKGExeProcessInfo: TprocessInformation;
  // RadExeProcessInfo: TprocessInformation;
  deletedimages: tstringlist;
  PassWord: Pchar;
  LogFile: Textfile;

  DUZName, DUZ: string;
  {  Flag set in OnPaint event, to stop certain code from being called more than once}
  Paramsearched: boolean;

  { ------------ Global variables, from INI file ----------- }
  { from INI, Logged in IMAGING WINDOWS WORKSTATION File.
      Date/Time when MagSetup.exe (MagInstall.exe) was run. Set by MagInstall.exe}
  LASTMAGUPDATE: string;

  IniListenerPort: integer;
  IniLocalServer: string;
  loginonstartup, IniLogAction: boolean;

  { WrksLocation is a free text of where the computer is located.
     99% of INI files have 'UnKnown' as the value for this}
    {TODO: dialog window to ask user to complete this text }
  WrksLocation, WrksCompName: string;
  {  Used in old,old M routines.  Still sent when user logs on and still logged.}
  {TODO: need to review, and determine if it's use can be stopped.}
  //WrksID: string;
  {   Still in question, whether we are putting Save As back in...
       allows user to save image to hard drive.}
  allowsave: boolean;
 *)

  {/ P117-NCAT JK 11/18/2010 /}
  MagUrlMap: TMagUrlMap;

  {/ P122 - JK 8/23/2011 /}
  MagAnnotMap: TMagUrlMap;

  {/ P122 - JK 6/3/2011 /}
  AnnotationTempDir: String;
  UserName: String;
  UserDUZ: String;
  UserService: String;
  PhysicianAcknowledgement : Boolean; {p130t9 dmmn 2/13/13 - this session property is to indicate that the user
                                        has agree to the statement provided when printing or copy images} 

  HasLocalAnnotatePermission: Boolean; {This session property is derived from the kernel parameters obtained
                                        from a call to MAG IMAGE ALLOW ANNOTATE on the local site.}
  HasLocalAnnotateMasterKey: Boolean;  {This is true when the user has the MAG ANNOTATE MGR key at their local site}
  SiteAnnotationInfo: TStringList; {/ P122 - JK 10/2/2011 - This stringlist is loaded when a connection is made
                                      to a VistA site (local or remote. In each string of the list contains a structured
                                      set if information: siteabbr~server:port~annotate permission~has master key~DUZ of user
                                      at that site.  MagPiece can be used to get the items./}
  AnnotationFontAvailable: Boolean; {Is the annotation font family is loaded on the client computer?}

  {/ P123 - JK 8/8/2011 /}
  Agency: TMagAgency;
 {7/12/12 gek Merge 130->129}
  ROISaveDirectory: String;  {/ P130 - JK 5/6/2012 - used to hold the disclosure directory on the user's
                                local machine while logged in as a convenience to the user. Later on we may
                                make this a user setting in VistA /}
{10/16/12 p129t10  gek   set this to True for the Session, and fmag4VGear14 will Skip the ColorChannelSplit.
                   this split is unneccessary in capture, and is causing accessviolantion in captue, and capture
                            patient photos.}
 SkipColorChannel : boolean;

 {5/16/13  p129t18 dmmn this will serve as a flag for any condition that separate capture and display}
 IsCaptureSession : boolean;
  { ------------ ------------------------------- ----------- }

    Constructor Create;
    Destructor Destroy;  override;
    Procedure Clear;
    function RemoteSiteSupportsAnnotation(Site: String): Boolean;   {/ P122 - JK 10/2/2011 /}
    function isRemoteSiteInAnnotateSiteList(Site: String): Boolean;  {/ P122 - JK 10/2/2011 /}
  End;

 {TCaptureObject: Accessed by various functions in the Capture App.
          it tells the new name of the Image File created in VistA.
          This fixes the problem of Extensions being different in the Image File
       as compared to the actual Image on the server.}



  TSessionDirectories = Class(Tobject)
  Public
    Temp: String;
    Cache: String;
    Import: String;
    Image: String;
    Function SetDirectories(BaseDir: String; Var Rmsg: String): Boolean;
  End;

 {	This is used in the MagListView for TIU Notes.  When a note is selected , this
    object can be retrieved and querried to determine properties of the selected Note.}
  TMagTIUData = Class(Tobject)
  Public
    AuthorDUZ: String; {File 200 New Person: Author's DUZ}
    AuthorName: String; {File 200 New Person: Author's Name}
    DFN: String; {Patient DFN}
    DispDT: String; {Date of Report External format}
    IntDT: String; {Date of Report FM internal format}
    PatientName: String; {Patient NAME}
    Status: String; {status of Note}
    Title: String; {Title of Note: Free Text (8925.1) }
    TiuDA: String; {TIU DOCUMENT File 8925 DA}
    TiuParDA : string ;{TIU Parent DA, if this is Addendum}
    IsAddendum : boolean;  {/p129 gek/dmmn 12/17/12 TIU Type: normal or addendum}
    HasAddendums : boolean ; {129p18  }
    Procedure Assign(VTIUdata: TMagTIUData);
  End;
  {p129 used by capture to Get Scrolling position.
  Returned as Result of Mag4VGear function 'GetScrollInfo'
   Scrolling Position is saved as preference in some capture settings}
 TMagScrollInfo = Class(Tobject)    //result of function 'GetScrollInfo'
   private
   public
   H_Line : integer ; // Size of Horizontal Scrolling Step
   H_Max  : integer ; // maximum of Horizontal Scroll Range
   H_Min  : integer ; // Minimum of Horizontal scroll range
   H_Page : integer ; // Size of Horizontal Scroll Page
   H_Pos  : integer ; // Horizontal scrolling position

   V_Line : integer ; // Size of Vertical Scrolling Step
   V_Max  : integer ; // maximum of Vertical Scroll Range
   V_Min  : integer ; // Minimum of Vertical scroll range
   V_Page : integer ; // Size of Vertical Scroll Page
   V_Pos  : integer ; // Vertical scrolling position
 End;
{	New Object returned from the TIU Window.  Tells properties of the New Note
        or New Addendum or Selected Note.  Replaces 'tiuprtstr' as the mechanism to
        pass TIU Note Data.
        After Image is created, this object is querried to determine what needs to
        be done with TIU Note or if one needs created.}
  TClinicalData = Class(Tobject)
  Private
  Public
    NewAuthor: String; {File 200 New Person: Author's Name}
    NewAuthorDUZ: String; {File 200 New Person: Author's DUZ}
    NewDate: String; {Date internal or external}
    NewLocation: String; {Hospital Location File  44 Name}
    NewLocationDA: String; {Hospital Location File  44 DA}
    NewStatus: String; {un-signed,AdminClosed,Signed}
    EncryptedEsig: String; {We need to get valid Esig Before we File Image.}
    NewTitle: String; {TIU DOCUMENT DEFINITION 8925.1   Name }
    NewTitleDA: String; {TIU DOCUMENT DEFINITION 8925.1   DA}
    NewTitleIsConsult: Boolean; {Title is a Consult, must have Consult DA}
    NewTitleConsultDA: String; {The Patient Consult DA, we link to the Note.}
    NewVisit: String; { NOT USED, THE TIU CALL, computes Visit}
    NewAddendum: Boolean; {If User is creating a New Adden}
    NewAddendumNote: String; {TIU Doucment 8925 IEN}
    NewNote: Boolean; {If user is creating a New Note}
    NewNoteDate: String; {User can select date of New Note, Adden}
    NewText: Tstringlist; { If user is adding text, it is here.}
    Pkg: String; {8925 for TIU.}
    PkgData1: String; {not used}
    PkgData2: String; {not used}
    AttachToSigned: Boolean; {Attach Image to Signed Note like always}
    AttachToUnSigned: Boolean; {Attach Image to an UnSigned Note.}
    AttachOnly: Boolean; {if locked for Editing,Prompt to attach image}
    ReportData: TMagTIUData; {if a selected note, this is the data}
    Constructor Create;
    Destructor Destroy; Override;
    Procedure Assign(VClinData: TClinicalData);
    Function IsClear: Boolean; {tells if this object is void of data}
    Procedure Clear; {Clear all data from object}
    Function GetClinDataStr: String;
    Function GetActStatLong: String; {Text Description of Action, Status}
    Function GetActStatShort: String; {Shorter Description of Action, Status}
    Procedure LoadFromClinDataStr(Value: String); {Load properties from '^' string}
    Function GetClinDataStrAll: String; {Text for Display of all properties}
  (*  function GetCDSActStataLong(vClinDataStr : string): string;
    function GetCDSActStatShort(vClinDataStr : string): string;*)

  End;


  TCaptureObject = Class(Tobject)
  Public
    ID: String; { the New entry in the Image File 2005}
    FullFileName: String; { Full path and file name of New file returned from ImageAdd.}
    Function GetPath: String; { returns the Path to the new image file.}
    Function GetFileNameNoExt: String; { returns File Name and No Extension}
    Function GetFileName: String; { returns File Name of New Image File with Extension.}
    Function GetExt: String; { returns the Extension of New File Name (with '.')}
    Function GetAbsFullFileName: String; { returns the File Name of Abstract File with Extension.}
    Function GetBIGFullFileName: String; { returns the File Name of BIG File with extension}
    Procedure Clear;
  End;

 {	used during the Editing of Image Index Values.  Has properties for Index Fields, Short Desc. }
  TImageIndexValues = Class(Tobject)
  Public
    ImageDescription, ImageIEN, Patient: String;
    ClassIndex,
      TypeIndex,
      SpecSubSpecIndex,
      ProcEventIndex,
      OriginIndex,
      ShortDesc: TmagFieldValue;

    Controlled, {   This used to be  'Sensitive' Changed to  'Controlled'}
      Status, {   Status of the Image}
      StatusReason, {   Last Status Reason on file.}
      ImageCreationDate: TmagFieldValue;

    Constructor Create;
    Destructor Destroy; Override;
    Procedure SetTypeIndex(Const Value: String);
    Procedure SetClassIndex(Const Value: String);
    Procedure SetOriginIndex(Const Value: String);
    Procedure SetProcEventIndex(Const Value: String);
    Procedure SetShortDesc(Const Value: String);
    Procedure SetSpecSubSpecIndex(Const Value: String);

    Procedure SetSensitive(Const Value: String);
    Procedure SetStatus(Const Value: String);
    Procedure SetStatusReason(Const Value: String);
    Procedure SetImageCreationDate(Const Value: String);

    Procedure Assign(IndexValObj: TImageIndexValues);
    Procedure Clear;

  End;

 {JMW Patch 72
  Used to describe a VistA site retrieved from the VistA Imaging Exchange Site
  Service }
  TVistaSite = Class(Tobject)
  Private
    FSiteNumber: String;
    FSiteName: String;
    FSiteAbbr: String;
    FRegionId: String;
    FVistaServer: String;
    FVistaPort: Integer;
    FVixServer: String;
    FVixPort: Integer;
  Public
    Constructor Create; Overload;
    Constructor Create(Site: TVistaSite); Overload;

    Property SiteNumber: String Read FSiteNumber Write FSiteNumber;
    Property SiteName: String Read FSiteName Write FSiteName;
    Property SiteAbbr: String Read FSiteAbbr Write FSiteAbbr;
    Property RegionId: String Read FRegionId Write FRegionId;
    Property VistaServer: String Read FVistaServer Write FVistaServer;
    Property VistaPort: Integer Read FVistaPort Write FVistaPort;
    Property VixServer: String Read FVixServer Write FVixServer;
    Property VixPort: Integer Read FVixPort Write FVixPort;

    Function IsSiteVixEnabled(): Boolean;
    Function GetVixUrl(): String;
    Function IsSiteDOD(): Boolean;
    Function SiteRequiresViX(): Boolean;
    Procedure MagAssign(Site: TVistaSite);

  End;

  {JMW Patch 72
  This object is used to hold information about a series, the name of the series
  and the index of the first image in the series }
  TMagSeriesObject = Class
  Public
    SeriesName: String;
    ImageIndex: Integer;
    SeriesNameUpdated: Boolean;
    SeriesImgCount: Integer;

    Constructor Create;
  End;

  TMagImagingService = Class
  Public
    ServiceType: String;
    ServiceVersion: String;
    ApplicationPath: String;
    MetadataPath: String;
    ImagePath: String;

    Constructor Create; Overload;
    Constructor Create(SerType, SerVersion, AppPath, MetaPath, ImgPath: String); Overload;
  End;
  (*
  TMagAnnotationStyle = Class
  Public
    AnnotationColor: TColor;
    LineWidth: Integer;
    MeasurementUnits: Integer;
    Constructor Create; Overload;
    Constructor Create(Color: TColor; LWidth: Integer; MeasureUnits: Integer); Overload;
  End;

  TMagAnnotationStyleChangeEvent = Procedure(Sender: Tobject; AnnotationStyle: TMagAnnotationStyle) Of Object;
  *)
  TMagImageAccessEventType = (COPY_TO_CLIPBOARD, PRINT_IMAGE, PATIENT_ID_MISMATCH);

  // JMW P72t23 - event occurs when the pan window closes
  TMagPanWindowCloseEvent = Procedure(Sender: Tobject) Of Object;

  // JMW P93 - result of copying an image
Type
  TMagImageCopyStatus = (IMAGE_COPIED, IMAGE_UNAVAILABLE, IMAGE_FAILED);

Type
  TMagImageQuality = (THUMBNAIL_IMG, REFERENCE_IMG, DIAGNOSTIC_IMG, UNKNOWN_IMG, NOT_FOUND_IMG);

  {/ P94 JMW 10/5/2009 - event for when a broker needs to generate a new local token /}
Type
  TMagSecurityTokenNeededEvent = Function(): String;

Type
  TMagRemoteLoginApplication = (magRemoteAppDisplay, magRemoteAppTeleReader);

  {/ P94 JMW 10/20/2009 - event for when a capri connection was used instead of BSE /}
Type
  TMagLogCapriConnectionEvent = Procedure(Application: TMagRemoteLoginApplication; SiteNumber: String) Of Object;

  TMagImageTransferResult = Class
  Public
    FNetworkFilename: String;
    FDestinationFilename: String;
    FTransferStatus: TMagImageCopyStatus;
    FImageQuality: TMagImageQuality;
    Constructor Create(NetworkFilename, DestinationFilename: String;
      ImageQuality: TMagImageQuality; TransferStatus: TMagImageCopyStatus);
  End;

Type
  {Represents a single point (x, y) coordinates}
  TMagPoint = class
  public
    X, Y : integer;
    constructor Create(X, Y : integer);
  end;

type
  { Represents a line (contains two points)}
  TMagLinePoints = class
  public
    Point1, Point2 : TMagPoint;
    constructor Create(Point1, Point2 : TMagPoint);
    Destructor Destroy; Override;
  end;

//type
//  TMagScoutLinePointType = (magScoutLine, magSeriesEdge);

type
  {Represents scout line information including the actual scout line and the
    series range (edges of the scout line to draw)}
  TMagScoutLine = class
  public
    ScoutLine, Edge1, Edge2 : TMagLinePoints;
    constructor Create(ScoutLine, Edge1, Edge2 : TMagLinePoints);
    Destructor Destroy; Override;
  end;

const maglocUnknown: string = '';
const maglocOffLine: string = 'O'; //integer = 1;
const maglocJB: string = 'W'; //integer = 2;
const maglocMag: string = 'M'; //integer = 2;

(*   moved to cMagVUtils.pas
   procedure StringsToIMageRec(Temppat: TMag4Pat; t: Tstrings);*)
Implementation
Uses
  Forms,
  SysUtils,
  UMagDefinitions,
  Umagutils8
  ;

//Uses Vetted 20090929:cMagPat, ImagInterfaces
{ TImageData }

{
********************************** TImageData **********************************
}

Function TImageData.ExpandedDescription(Lf: Boolean = True): String;
var dicomdata, lfs: string;
  Placedata: String; //P48T2 DBI    Added PlaceData to ImageDescription.
Begin
  Dicomdata := '';
  Placedata := '';

  if lf then lfs := #13
  else lfs := ' ';
  If Self.DicomSequenceNumber <> '' Then Dicomdata := '[' + Self.DicomSequenceNumber + ',' + Self.DicomImageNumber + '] ';
//if WrksConsolidated then If self.PlaceCode <> '' then placedata := '['+self.PlaceCode+']';
// JMW 5/6/2005 p45 - Make it so all images show the site code regardless of remote images
  If Self.PlaceCode <> '' Then Placedata := '[' + Self.PlaceCode + '] ';
  Result := Placedata + Dicomdata + ImgDes + Lfs + Proc + ' ' + Date;
End;

Function TImageData.ExpandedIDDescription(Lf: Boolean = True): String;
Begin
  Result := ' ID# ' + Mag0 + ' ' + ExpandedDescription(Lf);
End;

Function TImageData.ExpandedIdDateDescription(Lf: Boolean = True): String;
Var
  Dicomdata, Lfs: String;
  Placedata: String;
  Documentdatelabel: String;
  //P48T2 DBI    Added PlaceData to ImageDescription.
Begin
  Dicomdata := '';
  Placedata := '';
  if lf then lfs := #13
  else lfs := ' ';
  If Self.DicomSequenceNumber <> '' Then Dicomdata := '[' + Self.DicomSequenceNumber + ',' + Self.DicomImageNumber + '] ';
  //if WrksConsolidated then If self.PlaceCode <> '' then placedata := '['+self.PlaceCode+']';
  // JMW 5/6/2005 p45 - Make it so all images show the site code regardless of remote images
  If Self.PlaceCode <> '' Then Placedata := '[' + Self.PlaceCode + '] ';
  Result := Placedata + Dicomdata + ImgDes + Lfs + Proc;
  {Maybe the next three... and two below show N/A if date value is NUll ? }
  //if date = '' then date := 'N/A';
  //if CaptureDate = '' then capturedate := 'N/A';
  //if DocumentDate = '' then DocumentDate := 'N/A';
  If Self.Date <> '' Then Result := Result + Lfs + 'Procedure Date: ' + Date;
  If Self.CaptureDate <> '' Then Result := Result + Lfs + 'Capture Date:    ' + Self.CaptureDate;
  If Self.DocumentDate <> '' Then
  Begin
    Case Self.ImgType Of
      3, 9, 10, 12, 100: Documentdatelabel := 'Image Creation Date: '; //'Acquisition Date: ';
      15, 101..105: Documentdatelabel := 'Document Creation Date: ';
      11: Documentdatelabel := 'Image Creation Date: ';
        //11 : if dicomdata <> ''
        //          then documentdatelabel := 'Acquisition Date: '
        //          else documentdatelabel := 'Study Date:        ';
    else documentdatelabel := 'Image Creation Date:        ';
    End;
     {  If the Study doesn't have a Document Date, don't show anything.}
     {Maybe show N/A if date value in Null}
     //if (ImgType = 11) and (documentdate = 'N/A')
     //    then exit;
    Result := Result + Lfs + Documentdatelabel + Self.DocumentDate;
  End;
End;

Procedure TImageData.MagAssign(IData: TImageData);
Begin
{   NOTE: Any Change to either MagAssign, Clear or StringToTImageData
          must be accompied by a similiar change in the others. }
  Mag0 := IData.Mag0;
  AFile := IData.AFile;
  FFile := IData.FFile;
  ImgDes := IData.ImgDes;
  ImgType := IData.ImgType;
  PtName := IData.PtName;
  Date := IData.Date;
  Proc := IData.Proc;
  AbsLocation := IData.AbsLocation;
  FullLocation := IData.FullLocation;
  DicomSequenceNumber := IData.DicomSequenceNumber; //This is the Dicom Series Number
  DicomImageNumber := IData.DicomImageNumber;
  BaseIndex := IData.BaseIndex;
  QAMsg := IData.QAMsg;
  BigFile := IData.BigFile;
  DFN := IData.DFN;
  SSN := IData.SSN;
  MagClass := IData.MagClass;
  GroupCount := IData.GroupCount;
  IGroupIEN := IData.IGroupIEN;
  IGroupIndex := IData.IGroupIndex;
  ICh1IEN := IData.ICh1IEN; //93
  ICh1Type := IData.ICh1Type; //93
  PlaceIEN := IData.PlaceIEN;
  PlaceCode := IData.PlaceCode;
  ServerName := IData.ServerName;
  ServerPort := IData.ServerPort;
  CaptureDate := IData.CaptureDate;
  DocumentDate := IData.DocumentDate;

  StudyIEN := IData.StudyIEN;
  //93
  MagSensitive := IData.MagSensitive;
  MagViewStatus := IData.MagViewStatus;
  MagStatus := IData.MagStatus;

  {/ P122 - JK 6/4/2011 /}
  Annotated := IData.Annotated;
  {/ P122 - JK 7/5/2011 /}
  Resulted := IData.Resulted;
  {/ P122 - JK 7/5/2011 /}
  AnnotationStatus := IData.AnnotationStatus;
  {/ P122 - JK 7/27/2011 /}
  AnnotationStatusDesc := IData.AnnotationStatusDesc;
  {/ P122 - JK 7/5/2011 /}
  Package := IData.Package;

End;

Function TImageData.StringToTImageData(Str, Vserver: String; Vport: Integer): TImageData;
{ copied from cMagVUtils and put here.
     Refactored : Put the fuction with the Object that has the data.}
//function TMagVUtils.StringToIMageObj(str: string): TImageData;

{   NOTE: Any Change to either MagAssign, Clear or StringToTImageData
          must be accompied by a similiar change in the others. }

          {Note - JK - also add new pieces and properties to FMagImageInfo}
var length: integer;
//  s: String;
Begin
  Result := TImageData.Create;
//  Length := Maglength(Str, '^');
  {  Now we bring the Patient Name in the string from vista
      Result.PtName := PatName;  see below}
  Result.Mag0 := MagPiece(Str, '^', 2);
  Result.FFile := MagPiece(Str, '^', 3);
  Result.AFile := MagPiece(Str, '^', 4);
  Result.ImgDes := MagPiece(Str, '^', 5);
  (* PI^.FMProcDate :=magpiece(t[i],'^',6);   *)
  Result.ImgType := MagStrToInt(MagPiece(Str, '^', 7));
  Result.Proc := MagPiece(Str, '^', 8);
  Result.Date := MagPiece(Str, '^', 9);
  //the PARENT DATA FILE image pointer is in $p(10)
  //PI^.DemoRpt :=  magpiece(t[i],'^',10);
  Result.AbsLocation := MagPiece(Str, '^', 11);
  Result.FullLocation := MagPiece(Str, '^', 12);
  Result.DicomSequenceNumber := MagPiece(Str, '^', 13);
  Result.DicomImageNumber := MagPiece(Str, '^', 14);

  Result.GroupCount := MagStrToInt(MagPiece(Str, '^', 15));
  { $p(15^16 )(16^17 here) are SiteIEN and SiteCode Consolidation - DBI}
  Result.PlaceIEN := MagPiece(Str, '^', 16);
  Result.PlaceCode := MagPiece(Str, '^', 17);
  Result.QAMsg := MagPiece(Str, '^', 18);
  Result.BigFile := MagPiece(Str, '^', 19);
  Result.DFN := MagPiece(Str, '^', 20);
  Result.PtName := MagPiece(Str, '^', 21);
  Result.MagClass := MagPiece(Str, '^', 22);
  Result.CaptureDate := MagPiece(Str, '^', 23);
  Result.DocumentDate := MagPiece(Str, '^', 24);

  Result.IGroupIEN := MagStrToInt(MagPiece(Str, '^', 25));
  Result.ICh1IEN := MagStrToInt(MagPiece(MagPiece(Str, '^', 26), ':', 1)); //26 is Ch1:Ch1Type
  Result.ICh1Type := MagStrToInt(MagPiece(MagPiece(Str, '^', 26), ':', 2)); //26 is Ch1:Ch1Type

  {59 change   Set the ServerName and Port, if they are null, get values from MagDBBroker1}
  {93 change - the Object that made the call to get the data from VistA, will send the
                Server and Port that it used.  That way there are no problems with
                the corret server and port, and we don't have to know about the RPCBroker from here.}
  If (MagPiece(Str, '^', 27) = '') Or (MagPiece(Str, '^', 28) = '') Then
  Begin
    Result.ServerName := Vserver; //dmod.MagDBBroker1.GetServer;
    Result.ServerPort := Vport; //dmod.MagDBBroker1.GetListenerPort;
  End
  Else
  Begin
    Result.ServerName := MagPiece(Str, '^', 27);
    Result.ServerPort := MagStrToInt(MagPiece(Str, '^', 28));
  End;

  //93
  Result.MagSensitive := Magstrtobool(MagPiece(Str, '^', 29));
  Result.MagViewStatus := MagStrToInt(MagPiece(Str, '^', 30));
  Result.MagStatus := MagStrToInt(MagPiece(Str, '^', 31));

  {/ P122 - JK 7/27/2011 - definition of new pieces
     31:  Annotated image :         integer 1=annotated, 0=no annotation.
     32:  Is Note Complete :        1=Complete,  0=Other than complete, “”=Not a TIU Note.
     33:  Annotation Status : Integer
     34:  Annotation Status Description :  string
     35:  The Package : RAD,LAB,MED,SUR,NOTE,NOTE,PHOTOID
  /}

  {/ P122 - JK 6/4/2011 /}
  Result.Annotated := MagStrToBool(MagPiece(Str, '^', 32));
  {/ P122 - JK 7/5/2011 /}
  Result.Resulted := MagPiece(Str, '^', 33);
  {/ P122 - JK 7/5/2011 /}
  Result.AnnotationStatus := MagStrToInt(MagPiece(Str, '^', 34));
  {/ P122 - JK 7/27/2011 /}
  Result.AnnotationStatusDesc := MagPiece(Str, '^', 35);
  {/ P122 - JK 7/5/2011 /}
  Result.Package := MagPiece(Str, '^', 36);

End;

Procedure TImageData.Clear();
Begin
{   NOTE: Any Change to either MagAssign, Clear or StringToTImageData
          must be accompied by a similiar change in the others. }
  Mag0 := '';
  AFile := '';
  FFile := '';
  ImgDes := '';
  ImgType := 0;
  PtName := '';
  Date := '';
  Proc := '';
  AbsLocation := '';
  FullLocation := '';
  DicomSequenceNumber := ''; //This is the Dicom Series Number
  DicomImageNumber := '';
  BaseIndex := 0;
  QAMsg := '';
  BigFile := '';
  DFN := '';
  SSN := '';
  MagClass := '';

  GroupCount := 0;
  IGroupIEN := 0;
  IGroupIndex := 0;
  ICh1IEN := 0;
  ICh1Type := 0;
  //P48T3 DBI
  PlaceCode := '';
  PlaceIEN := '';

  CaptureDate := '';
  DocumentDate := '';

  ServerName := '';
  ServerPort := 0;

  StudyIEN := '';
    //93
  MagSensitive := False;
  MagViewStatus := 0;
  MagStatus := 0;

  {/ P122 - JK 6/4/2011 /}
  Annotated := False;
  {/ P122 - JK 7/5/2011 /}
  Resulted := '';
  {/ P122 - JK 7/5/2011 /}
  AnnotationStatus := -1;
  {/ P122 - 7/27/2011 /}
  AnnotationStatusDesc := '';
  {/ P122 - JK 7/5/2011 /}
  Package := '';
End;

Constructor TMagSeriesObject.Create;
Begin
  SeriesName := '';
  SeriesNameUpdated := False;
  ImageIndex := -1;
  SeriesImgCount := 0;
End;

Procedure TDicomData.ClearFields();
Begin
  PtName := '';
  PtID := '';
  STUDY_ID := '';
  Modality := '';
  PixelSpace1 := 0.0;
  PixelSpace2 := 0.0;
  PixelSpace3 := 0.0;
  Haunsfield := 0;
  SliceThickness := 0.0;
  Pt_Pos := '';
  Laterality := '';
  SliceLoc := 0.0;
  Rescale_Int := 0.0;
  Rescale_Slope := 0.0;
  Window_Center := 0;
  Window_Width := 0;
  Rows := 0;
  Columns := 0;
  Filename := '';
  PatOr1 := '';
  PatOr2 := '';
  ImageOr[1] := 0.0;
  ImageOr[2] := 0.0;
  ImageOr[3] := 0.0;
  ImageOr[4] := 0.0;
  ImageOr[5] := 0.0;
  ImageOr[6] := 0.0;
  BitDepth := 0;
  Bits := 0;
  SamplesPerPixel := 0;

  Seriesno := 0.0;
  Imageno := '';
  Contrast := '';
  Originalbits := 0;
  Protocol := '';
  Warning := 0;
  BigFile := '';

  Imagect := 0;
  Minpixel := 0;
  Maxpixel := 0;
  Winposition := 0;
  Levposition := 0;
  ImgType := 0;

  ImageIndex := 0;
  GroupIndex := 0;

  Smallest_PixelVal := 0;
  Largest_PixelVal := 0;
  Pos_Ref_Indicator := '';
  Dicomimage := False;
  GListState := False;
  Blank := '';
  Orient := 0;
  Studydesc := '';
  Photometric := '';
  WinLev := '';
  DicomDataSource := '';
  SeriesDescription := '';

  // JMW Patch 72 12/3/2007
  ImagerPixelSpace1 := 0.0;
  ImagerPixelSpace2 := 0.0;
  MagnificationFactor := 0.0;
  DistancePatientToDetector := 0.0;
  DistanceSourceToDetector := 0.0;
  SOPClassUid := '';
  PatientICN := '';

  // JMW Patch 131 4/12/2013
  ImagePosition[1] := '';
  ImagePosition[2] := '';
  ImagePosition[3] := '';
  ImageOrientation[1] := '';
  ImageOrientation[2] := '';
  ImageOrientation[3] := '';
  ImageOrientation[4] := '';
  ImageOrientation[5] := '';
  ImageOrientation[6] := '';
  PixelSpacing[1] := '';
  PixelSpacing[2] := '';
  PixelSpacing[3] := '';
  FrameOfReferenceUid := '';
  IsImageTypeLocalizer := false;

End;

{Force include indicates we should get the value regardless of if the data is
from the DICOM header or not}

Function TDicomData.GetLevelOffset(ForceInclude: Boolean = False): Integer;
Begin
  Result := 0;
  {
  // JMW P72 11/23/2007 - always apply the header offset, not sure why I was
  // only applying the value for non DICOM images, now apply for all image types
  if (DicomDataSource = 'DICOM Header') and (not ForceInclude) then
    exit;
    }
  If Haunsfield <> 0 Then
  Begin
    Result := Haunsfield;
    Exit;
  End;
  If Rescale_Int <> 0 Then
    Result := Trunc(Rescale_Int);

End;

function TDicomData.ToDelimitedString(Input : array of string; delimiter : string) : String;
var
  i, len : integer;
  curDelim : String;
begin
  result := '';
  curDelim := '';
  len := length(input);
  for i := 0 to len - 1 do
  begin
    if input[i] <> '' then
    begin
      result := result + curDelim + input[i];
      curDelim := delimiter;
    end;
  end;
end;

function TDicomData.IsScoutInformationAvailable() : boolean;
begin
  result := false;

  if (ImagePosition[1] = '') and (ImagePosition[2] = '') and (ImagePosition[3] = '') then
    exit; // now image position value, return false
  if (ImageOrientation[1] = '') and (ImageOrientation[2] = '') and
    (ImageOrientation[3] = '') and (ImageOrientation[4] = '') and
    (ImageOrientation[5] = '') and (ImageOrientation[6] = '') then
    exit;
  if (PixelSpacing[1] = '') and (PixelSpacing[2] = '') and (PixelSpacing[3] = '') then
    exit;
  if FrameOfReferenceUid = '' then
    exit;
  if Rows <= 0 then
    exit;
  if Columns <= 0 then
    exit;
  // if it gets to here then all the necesssary fields are populated
  result := true;

end;

Procedure TMagDICOMData.ClearData;
Begin
  PtName := '';
  PtID := '';
  Modality := '';
  PixelSpace1 := 0.0;
  PixelSpace2 := 0.0;
  PixelSpace3 := 0.0;
  Haunsfield := 0;
  SliceThickness := 0.0;
  Pt_Pos := '';
  Laterality := '';
  SliceLoc := 0.0;
  Rescale_Int := 0;
  Rescale_Slope := 0;
  Window_Center := 0;
  Window_Width := 0;
  Rows := 0;
  Columns := 0;
  Filename := '';
  BitDepth := 0;
  Seriesno := 0;
  Imageno := '0';
  PatOr1 := '';
  PatOr2 := '';
  Bits := 0;
  Contrast := '';
  Originalbits := 0;
  Protocol := '';
  Warning := 0; {P1}

  {bigfile not reset, already done}

//oo1 If clearlist then
//oo1 begin
  //oo1 gearcontrol := nil;
  //oo1 medcontrol := nil;
  Panel := Nil;
  GList := Nil;
  GListState := False;
  Blank := '';
//oo1   end;

  Minpixel := 0;
  Maxpixel := 0;
  Winposition := 0;
  Levposition := 0;
  //oo1 imgtype
  Imagebittype := 0;
  Ien := 0;
  Smallest_PixelVal := 0;
  Largest_PixelVal := 0;
  Dicomimage := False;
  //oo1
  (*for m := 1 to 6 do
    begin
    ADICOMRec[winnum].ImageOr[m] := -2.0;
    end;  *)
End;

{ TImageIndexValues }

Procedure TImageIndexValues.Assign(IndexValObj: TImageIndexValues);
Begin
  ImageDescription := IndexValObj.ImageDescription;
  ImageIEN := IndexValObj.ImageIEN;
  Patient := IndexValObj.Patient;
  ClassIndex.Assign(IndexValObj.ClassIndex);
  TypeIndex := IndexValObj.TypeIndex;
  SpecSubSpecIndex := IndexValObj.SpecSubSpecIndex;
  ProcEventIndex := IndexValObj.ProcEventIndex;
  OriginIndex := IndexValObj.OriginIndex;
  ShortDesc := IndexValObj.ShortDesc;

  Controlled := IndexValObj.Controlled;
  Status := IndexValObj.Status;
  StatusReason := IndexValObj.StatusReason;
  ImageCreationDate := IndexValObj.ImageCreationDate;

(*
Controlled
Status
StatusReason
ImageCreationDate

*)
End;

Procedure TImageIndexValues.Clear;
Begin
  ImageDescription := '';
  ImageIEN := '';
  Patient := '';
  TmagFieldValue(ClassIndex).Clear;
  TmagFieldValue(TypeIndex).Clear;
  TmagFieldValue(SpecSubSpecIndex).Clear;
  TmagFieldValue(ProcEventIndex).Clear;
  TmagFieldValue(OriginIndex).Clear;
  TmagFieldValue(ShortDesc).Clear;

  TmagFieldValue(Controlled).Clear;
  TmagFieldValue(Status).Clear;
  TmagFieldValue(StatusReason).Clear;
  TmagFieldValue(ImageCreationDate).Clear;

End;

Constructor TImageIndexValues.Create;
Begin
//
  Self.ClassIndex := TmagFieldValue.Create;
  Self.TypeIndex := TmagFieldValue.Create;
  Self.SpecSubSpecIndex := TmagFieldValue.Create;
  Self.ProcEventIndex := TmagFieldValue.Create;
  Self.OriginIndex := TmagFieldValue.Create;
  Self.ShortDesc := TmagFieldValue.Create;

  Self.Controlled := TmagFieldValue.Create;
  Self.Status := TmagFieldValue.Create;
  Self.StatusReason := TmagFieldValue.Create;
  Self.ImageCreationDate := TmagFieldValue.Create;

End;

Destructor TImageIndexValues.Destroy;
Begin
//
  Self.ClassIndex.Destroy;
  Self.TypeIndex.Destroy;
  Self.SpecSubSpecIndex.Destroy;
  Self.ProcEventIndex.Destroy;
  Self.OriginIndex.Destroy;
  Self.ShortDesc.Destroy;

  Self.Controlled.Destroy;
  Self.Status.Destroy;
  Self.StatusReason.Destroy;
  Self.ImageCreationDate.Destroy;

  Inherited;
End;

Procedure TImageIndexValues.SetClassIndex(Const Value: String);
Begin
  ClassIndex.Number := MagPiece(Value, '^', 1);
  ClassIndex.Int := MagPiece(Value, '^', 2);
  ClassIndex.Ext := MagPiece(Value, '^', 3);
  ClassIndex.Lbl := MagPiece(Value, '^', 4);

End;

Procedure TImageIndexValues.SetOriginIndex(Const Value: String);
Begin
  OriginIndex.Number := MagPiece(Value, '^', 1);
  OriginIndex.Int := MagPiece(Value, '^', 2);
  OriginIndex.Ext := MagPiece(Value, '^', 3);
  OriginIndex.Lbl := MagPiece(Value, '^', 4);

End;

Procedure TImageIndexValues.SetProcEventIndex(Const Value: String);
Begin
  ProcEventIndex.Number := MagPiece(Value, '^', 1);
  ProcEventIndex.Int := MagPiece(Value, '^', 2);
  ProcEventIndex.Ext := MagPiece(Value, '^', 3);
  ProcEventIndex.Lbl := MagPiece(Value, '^', 4);
End;

Procedure TImageIndexValues.SetShortDesc(Const Value: String);
Begin
  ShortDesc.Number := MagPiece(Value, '^', 1);
  ShortDesc.Int := MagPiece(Value, '^', 2);
  ShortDesc.Ext := MagPiece(Value, '^', 3);
  ShortDesc.Lbl := MagPiece(Value, '^', 4);

End;

Procedure TImageIndexValues.SetSpecSubSpecIndex(Const Value: String);
Begin
  SpecSubSpecIndex.Number := MagPiece(Value, '^', 1);
  SpecSubSpecIndex.Int := MagPiece(Value, '^', 2);
  SpecSubSpecIndex.Ext := MagPiece(Value, '^', 3);
  SpecSubSpecIndex.Lbl := MagPiece(Value, '^', 4);

End;

Procedure TImageIndexValues.SetImageCreationDate(Const Value: String);
Begin
  ImageCreationDate.SetVal(Value);
End;

Procedure TImageIndexValues.SetSensitive(Const Value: String);
Begin
  Controlled.SetVal(Value);
End;

Procedure TImageIndexValues.SetStatus(Const Value: String);
Begin
  Status.SetVal(Value);
End;

Procedure TImageIndexValues.SetStatusReason(Const Value: String);
Begin
  StatusReason.SetVal(Value);
End;

Procedure TImageIndexValues.SetTypeIndex(Const Value: String);
Begin
  TypeIndex.Number := MagPiece(Value, '^', 1);
  TypeIndex.Int := MagPiece(Value, '^', 2);
  TypeIndex.Ext := MagPiece(Value, '^', 3);
  TypeIndex.Lbl := MagPiece(Value, '^', 4);
End;

{ TCaptureObject }

Procedure TCaptureObject.Clear;
Begin
  ID := '';
  FullFileName := '';
End;

Function TCaptureObject.GetAbsFullFileName: String;
Begin
  Result := ChangeFileExt(FullFileName, '.ABS');
End;

Function TCaptureObject.GetBIGFullFileName: String;
Begin
  Result := ChangeFileExt(FullFileName, '.big');
End;

Function TCaptureObject.GetExt: String;
Begin
  Result := ExtractFileExt(FullFileName);
End;

Function TCaptureObject.GetFileName: String;
Begin
  Result := ExtractFileName(FullFileName);
End;

Function TCaptureObject.GetFileNameNoExt: String;
Begin
  Result := ChangeFileExt(GetFileName, '');
End;

Function TCaptureObject.GetPath: String;
Begin
  Result := ExtractFilePath(FullFileName);
End;

{ TClinicalData }

Procedure TClinicalData.Assign(VClinData: TClinicalData);
Begin
  NewAuthor := VClinData.NewAuthor;
  NewAuthorDUZ := VClinData.NewAuthorDUZ;
  NewDate := VClinData.NewDate;
  NewLocation := VClinData.NewLocation;
  NewLocationDA := VClinData.NewLocationDA;
  NewStatus := VClinData.NewStatus;
  NewTitle := VClinData.NewTitle;
  NewTitleDA := VClinData.NewTitleDA;
  NewVisit := VClinData.NewVisit;
  NewAddendum := VClinData.NewAddendum;
  NewAddendumNote := VClinData.NewAddendumNote;
  NewNote := VClinData.NewNote;
  NewNoteDate := VClinData.NewNoteDate;
  NewTitleIsConsult := VClinData.NewTitleIsConsult;
  NewTitleConsultDA := VClinData.NewTitleConsultDA;
  NewText.Assign(VClinData.NewText);
  Pkg := VClinData.Pkg;
  PkgData1 := VClinData.PkgData1;
  PkgData2 := VClinData.PkgData2;
  AttachToSigned := VClinData.AttachToSigned;
  AttachToUnSigned := VClinData.AttachToUnSigned;
  AttachOnly := VClinData.AttachOnly;
  if vClinData.ReportData = nil
    then ReportData := nil
  Else
  Begin
    If ReportData = Nil Then ReportData := TMagTIUData.Create;
    ReportData.Assign(VClinData.ReportData);
  End;
End;

Procedure TClinicalData.Clear;
Begin
  NewAuthor := '';
  NewAuthorDUZ := '';
  NewDate := '';
  NewLocation := '';
  NewLocationDA := '';
  NewStatus := '';
  NewTitle := '';
  NewTitleDA := '';
  NewVisit := '';
  NewAddendum := False;
  NewAddendumNote := '';
  NewNote := False;
  NewNoteDate := '';
  NewTitleIsConsult := False;
  NewTitleConsultDA := '';
  NewText.Clear;
  Pkg := '';
  PkgData1 := '';
  PkgData2 := '';
  AttachToSigned := False;
  AttachToUnSigned := False;
  AttachOnly := False;
  if ReportData <> nil
    then
  Begin
    ReportData.Free;
    ReportData := Nil;
  End;
End;

Constructor TClinicalData.Create;
Begin
  Inherited;
  Self.ReportData := TMagTIUData.Create;
  Self.NewText := Tstringlist.Create;
End;

Destructor TClinicalData.Destroy;
Begin
  ReportData.Free;
  NewText.Free;
  Inherited;
End;

Function TClinicalData.GetActStatLong: String;
var s: string;
  i: Integer;
  LcLoc: String;
Begin
  Self.PkgData1 := ''; //  we don't use this property in p59
  LcLoc := Lowercase(NewLocation);
  if lcLoc = ''
    then lcLoc := '<location>'
  else lcLoc[1] := NewLocation[1];
  s := '';
  if NewAddendum then s := 'Make Addendum'
  else if NewNote then s := 'New Note'
  else if AttachToSigned then s := 'Completed'
  else if AttachToUnSigned then s := 'Unsigned'
  else s := 'Note';
 { Status 0 : Un-Signed, 1: AdminClose 2: Signed}
  if NewStatus = ''
    then i := -1
  else i := strtoint(NewStatus);
  Case i Of
    0: s := s + ' - Unsigned';
    1: s := s + ' - Electronically Filed';
    2: begin
        if AttachToSigned
          then s := s + '-Completed'
        else s := s + '-Signed'
      End;
  End;
  If NewNote Then s := s + ' - ' + LcLoc;
  Result := s;
End;

Function TClinicalData.GetActStatShort: String;
var s: string;
  i: Integer;
  LcLoc: String;
Begin
  LcLoc := Lowercase(NewLocation);
  if lcLoc = ''
    then lcLoc := '<loc>'
  else lcLoc[1] := NewLocation[1];

  s := '';
  if NewAddendum then s := 'Addendum'
  else if NewNote then s := 'New Note'
  else if AttachToSigned then s := 'Completed'
  else if AttachToUnSigned then s := 'Unsigned'
  else s := 'Note';
 { Status 0 : Un-Signed, 1: AdminClose 2: Signed}
  if NewStatus = ''
    then i := -1
  else i := strtoint(NewStatus);
  Case i Of
    0: s := s + '-Unsigned';
    1: s := s + '-Elec Filed';
    2: begin
        if AttachToSigned
          then s := s + '-Completed'
        else s := s + '-Signed'
      End;
  End;
  if length(newlocation) > 6
    then s := s + '-' + copy(lcLoc, 1, 5) + '...'
  else s := s + '-' + lcLoc;
  Result := s;
End;

Function TClinicalData.GetClinDataStrAll: String;
var i: integer;
Begin
  Begin
    Result :=
      '-----------------------------------------'
      + #13 + 'NewAuthor:  ' + NewAuthor
      + #13 + 'NewAuthorDUZ:  ' + NewAuthorDUZ
      + #13 + 'NewDate:  ' + NewDate
      + #13 + 'NewLocation:  ' + NewLocation
      + #13 + 'NewLocationDA:  ' + NewLocationDA
      + #13 + 'NewStatus:  ' + NewStatus
      + #13 + 'NewTitle:  ' + NewTitle
      + #13 + 'NewTitleDA:  ' + NewTitleDA
      + #13 + 'NewVisit:  ' + NewVisit
      + #13 + 'NewAddendum:  ' + Magbooltostr(NewAddendum)
      + #13 + 'NewAddendumNote:  ' + NewAddendumNote
      + #13 + 'NewNote:  ' + Magbooltostr(NewNote)
      + #13 + 'NewNoteDate: ' + NewNoteDate
      + #13 + 'NewTitleConsultDA: ' + NewTitleConsultDA
      + #13 + 'NewTitleIsConsult: ' + Magbooltostr(NewTitleIsConsult)
      + #13 + 'Pkg:  ' + Pkg
      + #13 + 'PkgData1:  ' + PkgData1
      + #13 + 'PkgData2:  ' + PkgData2
      + #13 + 'AttachToSigned: ' + Magbooltostr(AttachToSigned)
      + #13 + 'AttachToUnSigned: ' + Magbooltostr(AttachToUnSigned)
      + #13;

    if ReportData = nil
      then result := result + 'Report Data :  NIL'
    Else
      With ReportData Do
      Begin
        Result := Result + 'Report Data => '
          + #13 + '    AuthorDUZ:  ' + AuthorDUZ
          + #13 + '    AuthorName:  ' + AuthorName
          + #13 + '    DFN:  ' + DFN
          + #13 + '    DispDT:  ' + DispDT
          + #13 + '    IntDT:   ' + IntDT
          + #13 + '    PatientName:   ' + PatientName
          + #13 + '    Status:    ' + Status
          + #13 + '    Title:    ' + Title
          + #13 + '    TIUDA:    ' + TiuDA;
      End;
    If NewText.Count > 0 Then
    Begin
      Result := Result + #13 + 'Text: =>';
      For i := 0 To NewText.Count - 1 Do
        Result := Result + #13 + 'Text: ' + NewText[i];
    End
    Else
      Result := Result + #13 + 'Text: NO Text';
  End;
  Result := Result + #13 + '-----------------------------------------';
End;

Function TClinicalData.GetClinDataStr: String;
Begin
{TODO: NewTitleIsConsult ? }
  Result :=
    '^^^' + // Author, AuthorDUZ, NewDate

  NewLocation + '^' + //1               4
    NewLocationDA + '^' + //2             5
    NewStatus + '^' + //3            6
    NewTitle + '^' + //4            7
    NewTitleDA + '^' + //5           8
    '^' + //New Visit
    Magbooltostr(NewAddendum) + '^' + //6         10
    '^' + //NewAddendumNote
    Magbooltostr(NewNote) + '^' + //7         12
    '^' + //NewText
    Pkg + '^' + //8         14
    PkgData1 + '^' + //9         15
    PkgData2 + '^' + //10         16
    Magbooltostr(AttachToSigned) + '^' + //11   17
    Magbooltostr(AttachToUnSigned) + '^' + ';' //12   18

  {TODO: do we have to add NewNoteDate, NewNoteConsultDA}
//Clindatastr is not all the data from TClinicalData, just these.
            (*
1    NewAuthor: string;          {File 200 New Person: Author's Name}
2    NewAuthorDUZ: string;       {File 200 New Person: Author's DUZ}
3    NewDate: string;            {Date internal or external}
4  1-  NewLocation: string;        {Hospital Location File  44 Name}
5  2-  NewLocationDA: string;      {Hospital Location File  44 DA}
6  3-  NewStatus: string;          {un-signed,AdminClosuer,Signed}
7  4-  NewTitle: string;           {TIU DOCUMENT DEFINITION 8925.1   Name }
8  5-  NewTitleDA: string;         {TIU DOCUMENT DEFINITION 8925.1   DA}
9    NewVisit: string;           { NOT USED, THE TIU CALL, computes Visit}
10  6-  NewAddendum: Boolean;      {}
11    NewAddendumNote: string;   {TIU Doucment 8925 IEN}
12  7-  NewNote: Boolean;          {}
13    NewText : Tstringlist;         { If user is adding text.}
14  8-  Pkg: string;                {8925 for TIU.}
15  9-  PkgData1: string;           {not used}
16  10-  PkgData2: string;           {not used}
    ReportData: TMagTIUData;    {if a selected note, this is the data}

            *)
End;

        {       value : Clindatastr  format}

Procedure TClinicalData.LoadFromClinDataStr(Value: String);
Begin
//    NewAuthor: string;          {File 200 New Person: Author's Name}
//    NewAuthorDUZ: string;       {File 200 New Person: Author's DUZ}
//    NewDate: string;            {Date internal or external}

  NewLocation := MagPiece(Value, '^', 4);
  NewLocationDA := MagPiece(Value, '^', 5);
  NewStatus := MagPiece(Value, '^', 6);
  NewTitle := MagPiece(Value, '^', 7);
  NewTitleDA := MagPiece(Value, '^', 8);
//    NewVisit: string;           { NOT USED, THE TIU CALL, computes Visit}
  NewAddendum := Uppercase(MagPiece(Value, '^', 10)) = 'TRUE';
//    NewAddendumNote: string;   {TIU Doucment 8925 IEN}
  NewNote := Uppercase(MagPiece(Value, '^', 12)) = 'TRUE';
//    NewText : Tstringlist;         { If user is adding text.}
  Pkg := MagPiece(Value, '^', 14);
  PkgData1 := MagPiece(Value, '^', 15);
  PkgData2 := MagPiece(Value, '^', 16);
  {TODO: NewTitleIsConsult ? }
  //    NewTitleIsConsult: boolean; {Title is a Consult, must have Consult DA}
  //   NewTitleConsultDA : string; {The Patient Consult DA, we link to the Note.}
  AttachToSigned := Uppercase(MagPiece(Value, '^', 17)) = 'TRUE';
  AttachToUnSigned := Uppercase(MagPiece(Value, '^', 18)) = 'TRUE';
  AttachOnly := False;
  ReportData := Nil;
  NewText.Clear; {loading from clinDataStr, the clindatastr can't have Text, so
                  we clear, just to be sure}
End;

Function TClinicalData.IsClear: Boolean;
Begin
  Result := True;
  If ReportData <> Nil Then Result := ReportData.TiuDA = '';
  If Result Then Result := ((NewAddendum = False) And (NewNote = False) And (NewStatus = ''));
End;

{ TmagTIUData }

Procedure TMagTIUData.Assign(VTIUdata: TMagTIUData);
Begin
  AuthorDUZ := VTIUdata.AuthorDUZ;
  AuthorName := VTIUdata.AuthorName;
  DFN := VTIUdata.DFN;
  DispDT := VTIUdata.DispDT;
  IntDT := VTIUdata.IntDT;
  PatientName := VTIUdata.PatientName;
  Status := VTIUdata.Status;
  Title := VTIUdata.Title;
  TiuDA := VTIUdata.TiuDA;
  TiuParDa := VTIUdata.TiuParDa;
  IsAddendum := VTIUData.IsAddendum;   //p129 gek/ dmmn 12/17/12
  HasAddendums :=  VTIUData.HasAddendums ; {129p18  }
End;
{	TRemoteSensitiveData defined in P45}

Procedure TRemoteSensitiveData.SetRemotePatientDFN(Value: String);
Begin
  FRemotePatientDFN := Value;
End;

Procedure TRemoteSensitiveData.SetRemoteSensitiveCode(Value: Integer);
Begin
  FRemoteSensitiveCode := Value;
End;

Procedure TRemoteSensitiveData.SetRemoteServerName(Value: String);
Begin
  FRemoteServerName := Value;
End;

Procedure TRemoteSensitiveData.SetRemoteServerPort(Value: Integer);
Begin
  FRemoteServerPort := Value;
End;

Procedure TRemoteSensitiveData.SetRemoteMsg(Value: TStrings);
Begin
  If FRemoteMsg = Nil Then
  Begin
    FRemoteMsg := Tstringlist.Create();
  End;
  FRemoteMsg.AddStrings(Value);
End;

Procedure TRemoteSensitiveData.SetRemoteSiteName(Value: String);
Begin
  FRemoteSiteName := Value;
End;

Procedure TRemoteSensitiveData.SetSiteApproved(Value: Boolean);
Begin
  FSiteApproved := Value;
End;

Function TRemoteSensitiveData.GetSensitiveCodeMesssage(): String;
Begin
  Case FRemoteSensitiveCode Of
    1: begin
        Result := 'Restricted - Access Logged';
        Exit;
      End;
    2: begin
        Result := 'Restricted - Must OK';
        Exit;
      End;
    3: begin
        Result := 'Restricted - Cannot View';
        Exit;
      End;
    4: begin
        Result := 'Means Test Required';
        Exit
      End;
    5: begin
        Result := 'Similar Patient Records';
        Exit;
      End;
  End;
End;

{ TSessionDirectories }

Function TSessionDirectories.SetDirectories(BaseDir: String; Var Rmsg: String): Boolean;
Begin
  Result := True;
  If BaseDir[Length(BaseDir)] <> '\' Then BaseDir := BaseDir + '\';
  Temp := BaseDir + 'temp\';
  Image := BaseDir + 'image\';
  Cache := BaseDir + 'cache\';
  Import := BaseDir + 'import\';
  Try
    If Not Directoryexists(Temp) Then Forcedirectories(Temp);
    If Not Directoryexists(Image) Then Forcedirectories(Image);
    If Not Directoryexists(Cache) Then Forcedirectories(Cache);
    If Not Directoryexists(Import) Then Forcedirectories(Import);
  Except
    Rmsg := 'Error creating Directories: ' + SysErrorMessage(Getlasterror);
    Result := False;
  End;
End;

{ TMagSettingsWrks }

Function TMagSettingsWrks.VLocDA: String;
Begin
  Result := MagPiece(VLoc, '~', 1);
End;

Function TMagSettingsWrks.VLocName: String;
Begin
  Result := MagPiece(VLoc, '~', 2);
End;

{ TmagFieldValue }

Procedure TmagFieldValue.Assign(Value: TmagFieldValue);
Begin
  Self.Number := Value.Number;
  Self.Int := Value.Int;
  Self.Ext := Value.Ext;
  Self.Lbl := Value.Lbl;
End;

Procedure TmagFieldValue.Clear;
Begin
  Self.Number := '';
  Self.Int := '';
  Self.Ext := '';
  Self.Lbl := '';
End;

Procedure TmagFieldValue.SetVal(Value: String);
Begin
  Self.Number := MagPiece(Value, '^', 1);
  Self.Int := MagPiece(Value, '^', 2);
  Self.Ext := MagPiece(Value, '^', 3);
  Self.Lbl := MagPiece(Value, '^', 4);
End;

Constructor TVistaSite.Create;
Begin
  FSiteNumber := '';
  FSiteName := '';
  FSiteAbbr := '';
  FRegionId := '';
  FVistaServer := '';
  FVistaPort := 0;
  FVixServer := '';
  FVixPort := 0;
End;

Constructor TVistaSite.Create(Site: TVistaSite);
Begin
  FSiteNumber := Site.FSiteNumber;
  FSiteName := Site.FSiteName;
  FSiteAbbr := Site.FSiteAbbr;
  FRegionId := Site.FRegionId;
  FVistaServer := Site.FVistaServer;
  FVistaPort := Site.FVistaPort;
  FVixServer := Site.FVixServer;
  FVixPort := Site.FVixPort;
End;

Function TVistaSite.IsSiteVixEnabled(): Boolean;
Begin                     {P161 this is the 'Patient Images Cleared'  fix.  Added the Try Except.}
try
  Result := False;
  If (FVixServer <> '') And (FVixPort > 0) Then
    Result := True;
except
 result := false;
end;
End;

Function TVistaSite.GetVixUrl(): String;
Begin
//  result := 'http://' + FVixServer + ':' + inttostr(FVixPort) + '/ImagingExchangeWebApp/';
  Result := 'http://' + FVixServer + ':' + Inttostr(FVixPort);
End;

{*
  This function determines if the site is a DOD site. While th implementation
  for this function is the same as siteRequiresViX, this might not always be true.
  Also there are special rules that are applied only to DOD sites that don't
  happen to VA sites through ViX
 }

Function TVistaSite.IsSiteDOD(): Boolean;
Begin
  Result := False;
  If FSiteNumber = '200' Then
    Result := True;
End;

Function TVistaSite.SiteRequiresViX(): Boolean;
Begin
  Result := False;
  If FSiteNumber = '200' Then
    Result := True;
End;

Procedure TVistaSite.MagAssign(Site: TVistaSite);
Begin
  FSiteNumber := Site.FSiteNumber;
  FSiteName := Site.FSiteName;
  FSiteAbbr := Site.FSiteAbbr;
  FRegionId := Site.FRegionId;
  FVistaServer := Site.FVistaServer;
  FVistaPort := Site.FVistaPort;
  FVixServer := Site.FVixServer;
  FVixPort := Site.FVixPort;
End;

Constructor TMagImagingService.Create;
Begin
  ServiceType := '';
  ServiceVersion := '';
  ApplicationPath := '';
  ImagePath := '';
  MetadataPath := '';
End;

Constructor TMagImagingService.Create(SerType, SerVersion, AppPath, MetaPath, ImgPath: String);
Begin
  ServiceType := SerType;
  ServiceVersion := SerVersion;
  ApplicationPath := AppPath;
  ImagePath := ImgPath;
  MetadataPath := MetaPath;
End;
(*
Constructor TMagAnnotationStyle.Create;
Begin
  Inherited Create;
  Self.AnnotationColor := clYellow;
  Self.LineWidth := 2;
  Self.MeasurementUnits := 6;
End;

Constructor TMagAnnotationStyle.Create(Color: TColor; LWidth: Integer;
  MeasureUnits: Integer);
Begin
  Inherited Create;
  Self.AnnotationColor := Color;
  Self.LineWidth := LWidth;
  Self.MeasurementUnits := MeasureUnits;
End;
*)

Function TImageData.ExpandedDescDtID(Lf: Boolean): String;
Var
  Lfs: String;
Begin
  Result := '';
  if lf then lfs := #13
        else lfs := ' ';
  //If self.PlaceCode <> '' then result := result + '['+self.PlaceCode+']';
  //if self.DicomSequenceNumber <> '' then result := result + '['+self.DicomSequenceNumber+','+self.DicomImageNumber+'] ';
  Result := Result + ImgDes + Lfs + Proc + ' ' + Date + ' ' + 'ID ' + Mag0
End;

Function TImageData.ExpandedMLDescription: String;
Begin
  Result := '';
//isi  If self.PlaceCode <> '' then result := result + '['+self.PlaceCode+']';
  If Self.DicomSequenceNumber <> '' Then Result := Result + '[' + Self.DicomSequenceNumber + ',' + Self.DicomImageNumber + '] ';
  Result := Result + #13 + ImgDes + #13 + Proc + ' ' + Date;
End;

Function TImageData.IsImageGroup: Boolean;
Begin
  if ImgType = 0 then result := false
  else result := (ImgType = 11);
End;

{/ P117 - JK 9/13/2010 /}
function TImageData.ImageAllowsAnnotating: String;
begin
  case AnnotationStatus of
    -1: Result := 'Annotation Status [-1] is undefined in VistA';
     0: Result := 'Y';
     else
       Result := 'Cannot Annotate This Image: Reason [' + IntToStr(AnnotationStatus) + ']';
  end;
end;

Function TImageData.IsImageDeleted: Boolean;
Begin
  if ImgType = 0 then result := false
  else result := (MagStatus = 12);
End;

Function TImageData.IsInImageGroup: Boolean;
Begin
   if ImgType = 0 then result := false
  else result := IGroupIEN > 0;
End;

Function TImageData.IsOnOffLineJB: Boolean;
Begin
  Result := False;
  { TODO : Fulllocation was '', never got that error before, have to check M code. }
  If FullLocation <> '' Then
    if (uppercase(fulllocation[1]) = 'O') then  result := true
End;

Function TImageData.IsRadImage: Boolean;
Begin
  Result := ((ImgType = 3) Or (ImgType = 100))
End;

Function TImageData.SyncIEN: String;
Var
  Ien: String;
Begin
  If Application.Terminated Then
  Begin
    Result := '0';
    Exit;
  End;
  Ien := Mag0;
  Result := Ien + '_' + ServerName + '_' + Inttostr(ServerPort);
End;

Function TImageData.SyncIENG: String;
Var
  Ien: String;
Begin
  If Application.Terminated Then
  Begin
    Result := '0';
    Exit;
  End;
  Ien := Mag0;
  If IGroupIEN > 0 Then
    Ien := Inttostr(IGroupIEN);
  Result := Ien + '_' + ServerName + '_' + Inttostr(ServerPort);
End;

Function TImageData.IsViewAble: Boolean;
Begin
  Result := (MagViewStatus < 10);
End;

Function TImageData.GetStatusDesc: String;
//var st : boolean;
Begin
   {   1:Viewable;2:QA Reviewed;10:In Progress;11:Needs Review;12:Deleted}
   TRY     //117 add try except.  
   {  find out why we're crashing here,  put in EXCEPT message}
  Case MagStatus Of
    0: Result := 'Viewable';
    1: Result := 'Viewable';
    2: Result := 'QA Reviewed';
    10: Result := 'In Progress';
    11: Result := 'Needs Review';
    12: Result := 'Deleted';
       else result := 'UnKnown status ?  ';
       end;
       EXCEPT
       RESULT := '';
  End;
End;

Function TImageData.GetViewStatusMsg: String;
var st : boolean;
Begin
  St := (MagViewStatus < 10);
if st then  result := 'Viewable image.'
  Else
  Begin
   //result := 'Non Viewable Status : '+ inttostr(MagViewStatus) + ' ' ;
    Result := 'Non Viewable Image.  Status is: ';
    Case MagViewStatus Of
      10: Result := Result + 'Image Capture in Progress. '; //p130t11 dmmn 4/17/13 - changed to more generic status for p140
      11: Result := Result + 'Needs Review. ';
      12: Result := Result + 'Deleted Image. ';
      21: Result := Result + 'Questionable Integrity. ';
      22: Result := Result + 'TIU Authorization failed. ';
      23: Result := Result + 'Rad Exam Status failed. ';
       else result := result + 'UnDefined Reason. ';
    End;
  End;
End;

function TImageData.IsImageDOD;
begin
   result := (PlaceIEN = '200');
  (*
  result := false;
  //if (pos('DoD', PlaceCode) > 0) or (PlaceIEN = '200') then
  if PlaceIEN = '200' then result := true;
  *)
end;

function TImageData.IsSame(IObj : TImageData) : boolean;
begin
  result := false;
  if iobj = nil then
    exit;
  If Mag0 <> IObj.Mag0 Then Exit;
  If ServerName <> IObj.ServerName Then Exit;
  If ServerPort <> IObj.ServerPort Then Exit;
  result := true;  
  
end;

Constructor TMagImageTransferResult.Create(NetworkFilename,
  DestinationFilename: String; ImageQuality: TMagImageQuality;
  TransferStatus: TMagImageCopyStatus);
Begin
  Inherited Create;
  Self.FNetworkFilename := NetworkFilename;
  Self.FDestinationFilename := DestinationFilename;
  Self.FTransferStatus := TransferStatus;
  Self.FImageQuality := ImageQuality;
End;

{ TSession }

Procedure TSession.Clear;
Begin
  Self.WrksPlaceCODE := '';
  Self.WrksPlaceIEN := '0';
  Self.WrksInstStationNumber := '';
  Self.Wrksinst.ID := '0';
  Self.Wrksinst.Name := '';
  Self.WrksConsolidated := False;
  Self.SecurityToken := '';

  {/ P122 - JK 6/3/2011 /}
  Self.UserName := '';
  Self.UserDUZ := '';
  Self.UserService := '';

  {/ P122 - JK 10/2/2011 /}
  SiteAnnotationInfo.Clear;

  {p130T9 dmmn 2/13/13}
  Self.PhysicianAcknowledgement := False;

End;

Constructor TSession.Create;
Begin
  Inherited;
  Wrksinst := TMagIdName.Create;//RLM Fixing MemoryLeak 6/18/2010
  Self.Wrksinst.ID := '';
  Self.Wrksinst.Name := '';
  Self.SecurityToken := '';
//gtc9/4  self.CPRSSync := CPRSSyncOptions.Create;
//  EKGExeProcessInfo := TprocessInformation;
//  RadExeProcessInfo := TprocessInformation;
//gtc9/4  self.deletedimages := tstringlist.Create;

  {/ P117-NCAT - JK 11/18/2010 /}
  if MagUrlMap = nil then
    MagUrlMap := TMagUrlMap.Create;

  {/ P122 - JK 8/23/2011 - map the URN's from remote image views. /}
  if MagAnnotMap = nil then
    MagAnnotMap := TMagUrlMap.Create;

  {/ P122 - JK 6/3/2011 /}
  Self.AnnotationTempDir := GetEnvironmentVariable('AppData') + '\icache\Annotation\';
  Self.UserName := '';
  Self.UserDUZ := '';
  Self.UserService := '';

  {/ P122 - P123 - JK 8/25/2011 /}
  if Agency = nil then
    Agency := TMagAgency.Create;

  {/ P122 - JK 10/2/2011 /}
  SiteAnnotationInfo := TStringList.Create;

  {p130T9 dmmn 2/13/13}
  PhysicianAcknowledgement := false;

End;

Destructor TSession.Destroy;
Begin
  FreeAndNil(Wrksinst);//RLM Fixing MemoryLeak 6/18/2010
  MagUrlMap.Free;  {/ P117-NCAT - JK 11/18/2010 /}
  SiteAnnotationInfo.Free; {/ P122 - JK 10/2/2011 /}
  Inherited;
End;

{/ P122 - JK 10/2/2011 /}
function TSession.RemoteSiteSupportsAnnotation(Site: String): Boolean;
var
  i: Integer;
begin
  Result := False;
  if gsess = nil then exit; 
  
  if gSess.siteAnnotationInfo <> nil  then
  
  for i := 0 to GSess.SiteAnnotationInfo.Count - 1 do
    {GSess.SiteAnnotationInfo piece #3 is the site's servername:serverport e.g., 10.23.456.222:9910}
    if MagPiece(Site, '~', 1) = MagPiece(GSess.SiteAnnotationInfo[i], '~', 3) then
    begin
      Result := True;
      Break;
    end;
end;

function TSession.isRemoteSiteInAnnotateSiteList(Site: String): Boolean;
var
  i: Integer;
  SitePiece: String;
begin
  Result := False;
  for i := 0 to GSess.SiteAnnotationInfo.Count - 1 do
  begin
    {GSess.SiteAnnotationInfo piece #1 is the site abbreviation code e.g., TUC}
    SitePiece := MagPiece(GSess.SiteAnnotationInfo[i], '~', 1);
    if Site = SitePiece then
    begin
      Result := True;
      Exit;
    end;
  end;
end;

{ TMagURLMap }

{/ P1117 NCAT - JK 12/2010 - URL-to-Windows mapping. Check first to see if the mapping
   already exists as in the case when the patient is refreshed. If so, do not remap.
   Also, DoD MS Word, PDF, and text files need a file extension to trigger the right viewer
   whenever a ShellExecute to an external viewer is called. /}

  {This first TMagURLMap implementation uses a simple TStrings memory structure to map
   Url's into session-generated Windows filenames. This is not exactly speedy
   when the URL in-memory map gets very large. However the data structure can easily
   be made into a hash table, a TClientDataset, etc. for faster performance.
   Using a TStrings name=value map, there are no hash collisions. }

constructor TMagUrlMap.Create;
begin
  inherited Create;
  
  if FUrlList = nil then
    FUrlList := TStringList.Create;

  FUrlList.NameValueSeparator := NVDelimiter;

  FTimeStamp := FormatDateTime('yyyymmdd-hhmmss', Now);
  NextID := 0;
end;

destructor TMagUrlMap.Destroy;
begin
  if FUrlList <> nil then
    FUrlList.Free;
  inherited Destroy;
end;
   
function TMagUrlMap.Add(const AUrl: String; const GroupMember: Boolean = False): Integer;
begin
  if AUrl = '' then
    Result := -1
  else
  begin
    if not isUrlAlreadyMapped(AURL) then
    begin
      if isMSWord2003InMime(AUrl) then
        Result := FUrlList.Add(AUrl + NVDelimiter + GetNewFileName(GroupMember) + '.doc')

      else if isMSWord2007InMime(AUrl) then
        Result := FUrlList.Add(AUrl + NVDelimiter + GetNewFileName(GroupMember) + '.docx')        

      else if isAsciiInMime(AUrl) then
        Result := FUrlList.Add(AUrl + NVDelimiter + GetNewFileName(GroupMember) + '.asc')   {text file using the asc file extension}

      else if isPdfInMime(AUrl) then
        Result := FUrlList.Add(AUrl + NVDelimiter + GetNewFileName(GroupMember) + '.pdf')

      else
        Result := FUrlList.Add(AUrl + NVDelimiter + GetNewFileName(GroupMember));
    end;
  end;
end;

{/ P122 - JK 8/24/2011 /}
function TMagUrlMap.MapURN(S: String): String;
begin
  with umagdefinitions.GSess do
  begin
    if MagAnnotMap.Find(S) = MagAnnotMap.mapNotFound then
    begin
      MagAnnotMap.Add(S);
      Result := MagAnnotMap.Find(S);
    end
    else
      Result := MagAnnotMap.Find(S);
  end;
end;

function TMagUrlMap.isUrlAlreadyMapped(AURL: String): Boolean;
begin
  if Find(AURL) = mapNotFound then
    Result := False
  else
    Result := True;
end;

function TMagUrlMap.Count: Integer;
begin
  if FUrlList <> nil then
    Result := FUrlList.Count
  else
    Result := -1;
end;

function TMagUrlMap.Find(const AUrl: String): String;
begin
  Result := FUrlList.ValueFromIndex[FUrlList.IndexOfName(AUrl)];
  if Result = '' then
    Result := mapNotFound;
end;

function TMagUrlMap.Get(Idx: Integer): String;
begin
  Result := FUrlList.Strings[Idx];
end;

function TMagUrlMap.GetNewFileName(isImageAGroupMember: Boolean): String;
begin
  if isImageAGroupMember then
    Result := Timestamp + '-G-' + IntToStr(NextId)
  else
    Result := Timestamp + '-' + IntToStr(NextId);
  Inc(NextID);
end;

function TMagUrlMap.IsMSWord2003InMime(AUrl: String): Boolean;
begin
  Result := False;
  if Pos('application/msword', AUrl) > 0 then
    Result := True;
end;

function TMagUrlMap.IsMSWord2007InMime(AUrl: String): Boolean;
begin
  Result := False;
  if Pos('application/vnd.openxmlformats-officedocument.wordprocessingml.document', AUrl) > 0 then
    Result := True;
end;

function TMagUrlMap.IsAsciiInMime(AUrl: String): Boolean;
begin
  Result := False;
  if Pos('text/plain', AUrl) > 0 then
    Result := True;
end;

function TMagUrlMap.IsPdfInMime(AUrl: String): Boolean;
begin
  Result := False;
  if Pos('application/pdf', AUrl) > 0 then
    Result := True;
end;

procedure TMagUrlMap.StoreToDisk(Filename : String);
begin
  FUrlList.SaveToFile(Filename);
end;

Procedure TMagUrlMap.LoadFromDisk(Filename : String);
begin
  FUrlList.LoadFromFile(Filename);
end;

{ TMagAgency }

function TMagAgency.GetAgencyAbbr: String;
begin
  if GetIHS then
    Result := 'IHS'
  else if GetVA then
    Result := 'VA'
  else
    Result := ' ';
end;

function TMagAgency.GetAgencyDBName: String;
begin
  if GetIHS then
    Result := 'RPMS'
  else if GetVA then
    Result := 'VistA'
  else
    Result := ' ';
end;

function TMagAgency.GetAgencyName: String;
begin
  if GetIHS then
    Result := 'Indian Health Services (IHS)'
  else if GetVA then
    Result := 'Veterans Administration (VA)'
  else
    Result := 'Agency is undefined';
end;

function TMagAgency.GetIHS: Boolean;
begin
  Result := False;
  if FAgencyID = 'I' then
    Result := True;
end;

function TMagAgency.GetVA: Boolean;
begin
  Result := False;
  if FAgencyID = 'V' then
    Result := True;
end;

constructor TMagPoint.Create(X, Y : integer);
begin
  self.X := X;
  self.Y := Y;
end;

constructor TMagLinePoints.Create(Point1, Point2 : TMagPoint);
begin
  self.Point1 := point1;
  self.Point2 := point2;
end;

Destructor TMagLinePoints.Destroy;
begin
  if Point1 <> nil then
    FreeAndNil(Point1);
  if Point2 <> nil then
    FreeAndNil(Point2);
end;

constructor TMagScoutLine.Create(ScoutLine, Edge1, Edge2 : TMagLinePoints);
begin
  self.ScoutLine := ScoutLine;
  self.Edge1 := Edge1;
  self.Edge2 := Edge2;
end;

Destructor TMagScoutLine.Destroy;
begin
  if ScoutLine <> nil then
    FreeAndNil(ScoutLine);
  if Edge1 <> nil then
    FreeAndNil(Edge1);
  if Edge2 <> nil then
    FreeAndNil(Edge2);
end;


End.

(*  NOTES :   This is the old definition of the TSession Object  Kept here
   for reference *)
(*
 TSession = class(Tobject)
  private
  //
  public

{ These are TSession fields}
     WrksPlaceCode,WrksPlaceIEN,WrksInst : string;      //p48t2 DBI
     WrksConsolidated : boolean;

//IniViewRemoteAbs : boolean;
//45,72 had StationNumber.
//46 changed it to LocalStationNumber.

   // StationNumber : String; // JMW 7/22/2005 p45t5

     LocalUserStationNumber : String; // JMW 7/22/2005 p45t5, renamed P46 JMW 1/24/2007
     VistADomain : String; // JMW 1/18/2006 p46
     PrimarySiteStationNumber : String; // JMW 1/24/2007 p46t27
     ExternalPatientChange : boolean;//59
     DebugUseOldImageListCall : boolean; //93
//from TfrmMain
  {  CPRSSyncOptions is TRecord created for the interaction between CPRS and
     imaging.  The record was used in the first Imaging <-> CPRS design.
     In this design the user would get prompted if other CPRS window sent
     a message, or any CPRS window changed Patient.  Most of this functionality
     and properties are not used now but ... Care Management... CCOW... }
  CPRSSync: CPRSSyncOptions;
  //  used in old linking method with CPRS, and in Capture. not anymore.
  cprsFlag: boolean;
  {     set to TRUE if CPRS starts imaging.}
  CPRSStartedME: boolean;
  {}
  startmode : integer; {[1|2]  1 = Started standalone,  2 = Started by CPRS. }
  MUSEconnectFailed: boolean;
  { set from INI or DataBase  TIMEOUT WINDOWS DISPLAY: IMAGING SITE PARAMTERS Field : TIMEOUT WINDOWS DISPLAY}
  WorkStationTimeout: longint;
  MUSEenabled: boolean;
  {  if user want to see selection list when application starts up.}
  allowremotelogin: boolean;
 //p8t46 xmsg: string;
  QueImage: string;
  // (Stu: 'Sites don't use this Muse demo '
  //Stu: N/A UseMuseDemoDB: boolean;
  { TprocessInformation is a windows structure that we use to execute a program
    and keep a link to it.  We can tell if it is open, or closed, or we
    can close it }
  //EKGExeProcessInfo: TprocessInformation;
 // RadExeProcessInfo: TprocessInformation;
  deletedimages: tstringlist;
  PassWord: Pchar;
  LogFile: Textfile;

  DUZName, DUZ: string;
  {  Flag set in OnPaint event, to stop certain code from being called more than once}
  Paramsearched: boolean;
  {   Old vs New.   tRadList is the patient Radiology Exam list, this is used
     by Main window, and Radexam list window (and others) }
  //tradlist: Tstrings;

  { ------------ Global variables, from INI file ----------- }
  { from INI, Logged in IMAGING WINDOWS WORKSTATION File.
      Date/Time when MagSetup.exe (MagInstall.exe) was run. Set by MagInstall.exe}
  LASTMAGUPDATE: string;
  //p8t46   LASTMUSEUPDATE: string;
  IniListenerPort: integer;
  IniLocalServer: string;
  loginonstartup, IniLogAction: boolean;
//p72    {IniRevOrder } {, IniViewJBox} : bool;
  //IniViewRemoteAbs : boolean;    //DBI // put in uMagDefinitions for scope
  { WrksLocation is a free text of where the computer is located.
     99% of INI files have 'UnKnown' as the value for this}
    {TODO: dialog window to ask user to complete this text }
  WrksLocation, WrksCompName: string;
  {  Used in old,old M routines.  Still sent when user logs on and still logged.}
  {TODO: need to review, and determine if it's use can be stopped.}
  //WrksID: string;
  {   Still in question, whether we are putting Save As back in...
       allows user to save image to hard drive.}
  allowsave: boolean;

  { ------------ ------------------------------- ----------- }

  //p8t46 StopLoadingAbstracts: Boolean;
  //p8t46 abstractlist : tstringlist;
  //p8t46 AbsFile: string;
  //p8t46 PtList: TStringList;
  //p8t46 Imno: Integer;
  //p8t46 TIMER2TEXT: string;
  //p8t46 MagPtrList: TList;
  { think i was simulating a Partition variable, ... like M world}
  //p8t46 B: Byte;
  //p8t46 Y: Word;
  //p8t46   DemoDirectory: string;
  //p8t46 MuseOnline: Boolean;

   // for consolidation (search for Visn15 to find all changes)
  //   This is the 'code' field in the Site Parameter file.
  //  We will compare this against the new colomn entry in IMage LIsting
  //   And  magrecord's new field PlaceCode. to determine if this is
  //   a local or remote image.
//  WrksPlaceCode,WrksPlaceIEN,WrksInst : string;      //p48t2 DBI // moved to umagdefinitions.

 constructor Create;
end;
*)
