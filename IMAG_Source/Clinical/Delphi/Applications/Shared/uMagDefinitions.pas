Unit UMagDefinitions;
{
Package: MAG - VistA Imaging
WARNING: Per VHA Directive 10-93-142 this unit should not be modified.
Date Created:      2002
Site Name: Silver Spring, OIFO
Developers: Garrett Kirin
[==    unit uMagDefinitions;
Description: Imaging Definitions for application constants, ordinal types,
sets etc.   Also contains functions/ procedures that deal with the types,
const, defined here.
             ==]
Note:
}
(*
;; +---------------------------------------------------------------------------------------------------+
;; Property of the US Government.
;; No permission to copy or redistribute this software is given.
;; Use of unreleased versions of this software requires the user
;;  to execute a written test agreement with the VistA Imaging
;;  Development Office of the Department of Veterans Affairs,
;;  telephone (301) 734-0100.
;;
;; The Food and Drug Administration classifies this software as
;; a medical device.  As such, it may not be changed
;; in any way.  Modifications to this software may result in an
;; adulterated medical device under 21CFR820, the use of which
;; is considered to be a violation of US Federal Statutes.
;; +---------------------------------------------------------------------------------------------------+
*)
//{$DEFINE PROTOTYPE}
//{$DEFINE DEMOCREATE}
Interface
Uses
  Classes,
  Controls,
  Graphics,
  ExtCtrls,
  UMagClasses,
//  fMagAnnotOptions, {/ P122 - JK 6/7/2011 /} {this was out Pre RCA}

{RCA. .  fMagAnnotationOptionsX  is a form, that now, every unit that uses uMagDefinitions is coupled to
         trying to get rid of couplings to forms not needed.}
 //RCA out
     fMagAnnotationOptionsX,  {/p122 - dm 7/5/2011 /}

   cMagPublishSubscribe ,
   imaginterfaces
  ;



{p140  the radio buttons were dependent on the Control they were on , i.e radioGroupAssociation, rgFormat.. etc.
  this tied us to coding in a certain way and locked those controls to those Form Controls.
  in 140 we use the Tag property of the control and use that to determine what Imageing Confiruration the control is in.}

  Const
  magcfgFormat : integer = 51 ;
  magcfgSource : integer = 50 ;
  magcfgAssociation : integer = 50 ;
  magcfgMode : integer = 50 ;
  magcfgSaveAs : integer = 50 ;
  magcfgMultipleSource : integer = 50 ;
  magcfgPDFConvert : integer = 50 ;


Const
  Nilpanel: Tpanel = Nil;

//Uses Vetted 20090929:windows, forms, sysutils, umagutils

const
  magAnnotationFont = 'Arial';  {/ P122 - JK 8/30/2011 - this is the annotation font. /}  {/ P122 - JK 8/31/2011 WPR #33, 36 /}

{  all classes that are viewable in Display for Admin personnal}
Const
  MagdisclsAdmin: String = 'ADMIN,ADMIN/CLIN,CLIN/ADMIN';
Const
  MagdisclsAdminShow: String = 'Administrative';
    {  all classes that are viewable in Capture for Admin personnal}
Const
  MagcapclsAdmin: String = 'ADMIN,ADMIN/CLIN';
Const
  MagcapclsAdminShow: String = 'Administrative';
    {  all classes that are viewable in Display for Clinical personnal}
Const
  MagdisclsClin: String = 'CLIN,CLIN/ADMIN,ADMIN/CLIN';
Const
  MagdisclsClinShow: String = 'Clinical';
    {  all classes that are viewable in Capture for Clinical personnal}
Const
  MagcapclsClin: String = 'CLIN,CLIN/ADMIN';
Const
  MagcapclsClinShow: String = 'Clinical';
    {  all Classes.}
Const
  MagclsAll: String = 'CLIN,CLIN/ADMIN,ADMIN,ADMIN/CLIN';
Const
  MagclsAllShow: String = 'Any Class';
    {     define which Status Panel to display the message.  Different types of
          are displayed on different panels.  Using this method, we can easily
          change the placement of messages in the future.}
Const
  mmsglistwin: Integer = 2;
Const
  mmsgpublish: Integer = 2;
Const
  mmsgsitecode: Integer = 1;





Const
  MagcrCrossHair = 50; { cursors for Mag4VGear }
  MagcrMagnify = 51;
  MagcrPan = 52;

    { constants for status and state icons... icons for list or tree, etc.}
  MistNoStatus = 0;
  MistViewable = 1;
  MistVerified = 2;

  MistImageGroup = 4;

  MistSensitive = 7;
  MistNeedsRefresh = 8;

  MistInProgress = 10;
  MistNeedsReview = 11;
  MistDeleted = 12;

  MistQI = 21;
  MistTIULocked = 22;
  MistRADLocked = 23;

  MistSelectArrowB = 30;
  MistSelectArrowR = 31;
  MistSelectArrowG = 32;
  MistFolderDisabled = 33;
  MistFolderClosed = 34;
  MistFolderOpen = 35;
  MistFolderWithDoc = 36;
  MistCached = 37;
  MistCaching = 38;

    //////  State Icons

  MistateSensitive = 1;
  MistateCaching = 2;
  MistateCached = 3;
  MistateImageGroup = 4;
  MistateCachedGroup = 5;
  MistateSensitiveGroup = 6;
  MistateNeedsRefresh = 7;

  MistateAnnotationsPresent = 8;  {/ P122 - JK 6/22/2011.  NOTE: due to an apparent bug or
                                    bad Delphi documentation on the State Index of tree and list views,
                                    I can only use icons with index values <= 15.
                                    I moved this MistateAnnotationsPresent and the MistateAnnotationsPresentInGroup
                                    icon down from 21 to 8 and 9 which pushes *hopefully* unused state
                                    icons from 8 and 9 above to the right by two index values. /}
  MistateAnnotationsPresentInGroup = 9;

  {p149 gek - Constants for Printoptions.   Global variable GPrintOption}
Type
  TMagPrintOptions = (magpoNormal, magpoRasterize ,  magpoOther );



Type
  TEsigFailReason = (MagesfailCancel, MagesfailInvalid);
Type
  TMagApplicationTypes = (MagappDisplay, MagappCapture, MagappTeleReader, MagappClinUtils);
Type
  TMagReasonsCodes = (MagreasonOther, MagreasonPrint, MagreasonCopy, MagreasonDelete, MagreasonStatus);

Type
    // JMW 11/9/2006 P72
    {this object determines how many components of the gear control are used with this image
    Minimal is used for abstracts and does not include MED, PDF, or Annotation
    Clinical is for the full res viewer and includes PDF and Annotation but not MED
    Radiology is for the Radiology/DICOM Viewer and includes MED, J2K, PDF, and Annotation}
  TMagGearAbilities = (MagGearAbilityMinimal, MagGearAbilityClinical, MagGearAbilityRadiology);
    { packages to attach images }
  TMagPackages = Set Of (MpkgMED, MpkgSUR, MpkgRAD, MpkgLAB, MpkgNOTE, MpkgCP, MpkgCNSLT, MpkgNONE);
    { possible classes }
  TmagImageClasses = Set Of (MclsClin, MclsAdmin);
    { constants for mouse cursor for Mag4VGear}
  TMagImageMouse = (MactPan, MactDrag, MactMagnify, MactZoomRect, MactSelect, MactPointer, MactWinLev,
    MactAnnotation, MactMeasure, MactAnnotationPointer, MactProtractor);
    { JMW 4/6/09 P93 - shapes for mouse zoom pointer}
  TMagMouseZoomShape = (MagMouseZoomShapeCircle, MagMouseZoomShapeRectangle);

  TImageFMSet = Class(Tobject)
  Private
        //
  Public
    DBSetDefinition: String;
    DBSetName: String;
    Function GetInternalFromExternal(Value: String): String;
    Function GetExternalFromInternal(Value: String): String;
    Function GetListOfExternalValues(): TStrings;
  End;
    { Class to hold all properties of an Image Filter (from IMAGE LIST FILTERS File) }
  TImageFilter = Class(Tobject)
  Private
    FFltID: String;
    Fname: String;
    Fpkgs: TMagPackages;
    FClasses: TmagImageClasses;
    Ftypes: String;
    FProcEvent: String;
    FSpecSubSpec: String;
    FfromDate: String;
    FtoDate: String;
    FMthRange: Integer;
    FDayRange: Integer;
    FScope: String;
        // New for p93
    Fstatus: String;
    FShortDescHas: String;
    FImageCapturedByDUZ: String;
    FUseCapDt: Boolean;

    FMaxNumber: String;
    FColumns: String;

    FShowDeletedImageInfo: Boolean; {/ P117 - JK 8/30/2010 - if false, then get existing images /}

  Public
        //;;;;; testing
       FResultFromAddImage : string;
        {/gek p117   need way to send to M, that we want list of images that querries
                     the images of a group for status, not the Group Header.}

        FGroupImageStatus: string;
    FLocalImagesOnly: Boolean;
        {   ^DD(2005,8.1,0)=CAPTURE APPLICATION^S^C:Capture Workstation;D:DICOM Gateway;I:Import API;^2;12^Q}
    FCaptureDevice: String;
    FReturnPercent: Boolean;
    Property FilterID: String Read FFltID Write FFltID;
    Property Name: String Read Fname Write Fname;
    Property Packages: TMagPackages Read Fpkgs Write Fpkgs;
    Property Classes: TmagImageClasses Read FClasses Write FClasses;
    Property Types: String Read Ftypes Write Ftypes;
    Property ProcEvent: String Read FProcEvent Write FProcEvent;
    Property SpecSubSpec: String Read FSpecSubSpec Write FSpecSubSpec;
    Property FromDate: String Read FfromDate Write FfromDate;
    Property ToDate: String Read FtoDate Write FtoDate;
    Property MonthRange: Integer Read FMthRange Write FMthRange;
    Property DayRange: Integer Read FDayRange Write FDayRange; //93
    Property Origin: String Read FScope Write FScope;
        //p93
    Property Status: String Read Fstatus Write Fstatus;
    Property ShortDescHas: String Read FShortDescHas Write FShortDescHas;
    Property ImageCapturedBy: String Read FImageCapturedByDUZ Write FImageCapturedByDUZ;
    Property UseCapDt: Boolean Read FUseCapDt Write FUseCapDt;
    Property MaximumNumber: String Read FMaxNumber Write FMaxNumber;
    Property Columns: String Read FColumns Write FColumns;

    Property ShowDeletedImageInfo: Boolean read FShowDeletedImageInfo write FShowDeletedImageInfo; {/ P117 - JK 8/30/2010 /}

        //p93 end
    Function Detailstring: String;
    Function DetailedDesc: TStrings;
    Function GetParamList: TStrings;

  End;
    (* TSession was here
       TSession = Class(Tobject)
       ...
       ...
      constructor Create;
      end;
      *)


  TuprefCapTIU = Class(Tobject)
  Private
        //
  Public
    Top, Left, Height, Width: Integer;
    PanelTitleHeight, ListEditTextHeight, PanelPreviewHeight: Integer;
    PreviewON: Boolean; {Show preview of Selected Note}
    ShowRelatedNotes: Boolean; {Show Addendums and Notes in list tree view}
    UseStatusIcons: Boolean; {Icons in the List for Complete or Unsigned
        Annoying, or Okay}
    UseNoteGlyphs: Boolean; {on Main Window to show Action, Status of
        new Note.  Or use Text.}
    UseDefaultLoc: Boolean; {If false, Visit Location will need to be selected}
    DefaultLoc: String; {Default Visit Location}
    Listcount: Integer; {Number of Notes to show in the List}
    Listmonthsback: Integer; {Date range from Today, back a number of months}
        //listDateFrom : string;		{}
        //listDateTo : string;			{}
    NoteColumnWidths : String; {/p129 dmmn 12/20/12 store the column widths of the note views }
    Function DefaultLocDA: String; {Gets Visit Location DA from DefaultLoc}
    Function DefaultLocName: String; {Gets Visit Location Name from DefaultLoc}
  End;


      {  Mag4VGear objects can be querried for their 'state'  this object is passed
         as a result or a variable parameter in certain methods}
  TMagImageState = Class(Tobject)
  Private
        //
  Public

        // rotatecount starts at 4, each 90 inc by 1,
    RotateCount: Integer;
        // reversecount starts at 0, each invert, inc by 1, odd numbers tell
        // us that image is inverted from it's original.
    ReverseCount: Integer;
        // 0 to 255 start at 100.
        // control uses :
        //     Full1.DisplayContrast :=  tbicContrast.Position / 100;
    ContrastValue: Integer;
        // -900 to 1100 start at 100
        // control uses :
        //  Full1.DisplayBrightness := trunc(tbicBrightness.Position / 10);
    BrightnessValue: Integer;
        //20 to 800 start at 100;
        // control uses :
        //          full1.zoomlevel := tbicZoom.Position;
    ZoomValue: Integer;
        // these two, set the control, then set zoom value := 100
    Fitheight: Boolean;
    Fitwidth: Boolean;
        // This is the current Viewer Page being displayed.
    PageViewer: Integer;
        //This is number of pages in the viewer
    PageViewerCount: Integer;
        //This is the current displayed page;
    Page: Integer;
        // total number of pages.
    PageCount: Integer;
        // Image is member of Group, this is the Group index.
    ImageNumber: Integer;
        // total number of Images in Group.
    ImageCount: Integer;
        // Rad Images Window and Level values
    WinValue: Integer;
    LevValue: Integer;
        // Not sure but Win and Lev min and Max might be diff for diff images.
    WinMinValue: Integer;
    WinMaxValue: Integer;
    Levminvalue: Integer;
    Levmaxvalue: Integer;
        // JMW 4/17/09 - removed to avoid confusion, was not being used
    //    IsWinLevEnabled : boolean; //45 59
    WinLevEnabled: Boolean; //72
    ScrollHoriz, ScrollVert: Integer; //59

    MaxPixelValue: Integer;
    MinPixelValue: Integer;

        //
    MouseAction: TMagImageMouse;

    ReducedQuality: Boolean;
    CTPresetsEnabled: Boolean;
    AnnotationsDrawn: Boolean; // indicates if annotations were drawn and the pointer needs to be enabled
    MeasurementsEnabled: Boolean;
            // indicates if measurements are allowed on this image (bsaed on information from the header)
 {7/12/12 gek Merge 130->129}
   //p122rgb dmmn 12/13/11 - RGB changer
    RGBEnabled : Boolean;   // dmmn 12/13/11 - indicates if the image can cycle through the RGB channel
    RGBState : Integer;     // dmmn 12/13/11 - indicates the current state of the image (-1 n/a; 0 RGB; 1 R; 2 G; 3 B)

  End;

    {  Quick conversion utilities }
Function FilterToString(Filter: TImageFilter): String;
Procedure FilterToFieldList(Flt: TImageFilter; Var t: TStrings; Duz: String = '');
Function StringToFilter(Value: String): TImageFilter;
Function StringToClasses(Str: String): TmagImageClasses;
Function StringToPackages(Str: String): TMagPackages;
Function PackagesToString(Pkg: TMagPackages): String;
Function ClassesToStringGen(Cls: TmagImageClasses): String; //93
Function ClassesToString(Cls: TmagImageClasses): String;
Function ClassesToSet(Cls: TmagImageClasses): String;

{ imitate some of the 'M' string functions
    used mainly in userprefrences to convert Integer and Boolean properties
    to string values before saving in VistA.  and vice versa}
Function MagStrToInt(Value: String; defaultvalue: Integer = 0): Integer;
Function Magstrtobool(Value: String; defaultvalue: String = ''): Boolean;
Function Maginttobool(Value: Integer): Boolean;
Function Magbooltostr(Value: Boolean): String;
Function MagBoolToInt(Value: Boolean): Integer;
Function Magbooltostrint(Value: Boolean): String;
Function magStatusDesc(Value: Integer): String;

Procedure CursorChange(Var oldcurs: TCursor; newcurs: TCursor);
Procedure CursorRestore(oldcurs: TCursor);

procedure magAppPublish(i: integer);  {p129}

Var
  {p161 allow testing to run with Restrictions on Resolution}
  GNoRestrictView : boolean ;
 {patch 150 , ability to Turn OFF annotations from anywhere./}
 GNoAnnots : boolean;
 {p149 HIDE 130   /GEK/3-19-14}
 //out for Patch 161 (and all conditional code to Hide 130 ROI)
 //patch130active : boolean;
 {p149 - gek - Global Print variable}
 GPrintOption : TMagPrintOptions;   {p149 - gek - Global Print variable}   {BM-ImagePrint-}
 //TESTING ONLY.   On Capture a menu  a TestScript menu is visible for testing.
 // the MagCCOWManager will not attempt to Join Context if this is True
 //  It is only Read From the INI on Startup so we closely simulate Real startup.
 GDontUseCCOW : boolean;
 //
 //
 GDisplayVersion : string;
 //p129T11 gek.   10/21/12  moved here, renamed UserDir to GUserDir.
 GUserDir: TSessionDirectories; {p59 new object}

  GmagPublish: TMagPublisher;
{from umagutils 94t2}
//RCA OUT  Upreff2: Tuserpreferences;
  Upref: Tuserpreferences;
//  AnnotationOptions: TfrmAnnotOptions;  {/ P122 - JK 6/7/2011 /}  {this was out pre RCA}
{...but this was in 122...  uMagDefinitions isn't designed to be tied to forms.
..... right above here, is Upref.}


 //RCA : form AnnotationOptionsX doesn't belong here.  need to get out
 //RCA OUT     AnnotationOptionsX : TfrmAnnotOptionsX; {/p122 - DMMN 7/5/11/}
  Demobaseimagelist: Tstringlist;
  AppPath: String;    //Created by Mainform.   Apppath does not have '\' at end.
  WMIdentifier: Word;

  MuseSite: byte; // = 1;

  deletedimages: tstringlist;
{from umagutils 94t2}

  GSess: TSession; // 'G' for Global

  DebugUseOldImageListCall: Boolean; // This is used from a Testing Menu.  it will be removed in 94
  FSAppBackGroundColor: TColor;

    //To TSession  WrksPlaceCode,WrksPlaceIEN,WrksInst,WrksInstStationNumber : string;      //p48t2 DBI
    //To TSession  WrksConsolidated : boolean;

    {  PrimarySiteStationNumber   vs   LocalUserStationNumber

    The local user station number is the number of the site where the user is physically located,
     so if a user logs in and selects a Washington CBOC, the local user station number
     might be 1005 (just making that up).  The primary site station number is the number
     of the site that hosts the VistA system, this is the number that exists in the site
     service.  So for Washington this would be 688.
    So this user would have a local user station number of 1005 but a
    primary site station number of 688, when looking for data in the site service
    or determining if two sites are the same, you have to use the primary site station number.
     The local user station number is used a lot in TeleReader because the
     sites want to keep track of images from clinics and users at clinics
     and keep them separate from the primary site.  But when you are trying to
     get data from a clinic, you have to go to the primary site for the
     actual data (since the clinic doesn’t have a VistA system of its own).
    }

  LocalUserStationNumber: String;
  PrimarySiteStationNumber: String;
  VistADomain: String;
  ExternalPatientChange: Boolean;
    {   JMW 6/2/2009 P93T8 - this really should be part of cMagPat, but wouldn't
        be available to brokers. This keeps track of the highest sensitivity
        level the user has agreed to for the current patient. This should be
        reset everytime the patient is refreshed  }
  FCurrentPatientSensitiveLevel: Integer;
  FSyncImageON: Boolean; //93
  FUseThumbNailWindow: Boolean; //93

  FExtensionlist: TStrings;

  gDebugUser: boolean;
Implementation
Uses
  Forms,
  SysUtils,
  Umagutils8,

  IniFiles
  ;
Var
  ListOfExternalValues: Tstringlist;//RLM Fixing MemoryLeak 6/18/2010


{p129  Generic call to Publish.  If publisher isn't defined, No Error, }
procedure magAppPublish(i: integer);  
var NewsObj : TmagnewsObject;
begin
(* Function MakeNewsObject(Vcode: Integer = 0; Vint: Integer = 0; Vstr: String = '';
  VchangeObj: Tobject = Nil; VInitiater: Tobject = Nil; VTopic: Integer = 0): TMagNewsObject;
  *)
  if GmagPublish <> nil then
    begin
    NewsObj := MakeNewsObject(i);
    GMagPublish.I_SetNews(NewsObj);
    end;

end;


Procedure CursorChange(Var oldcurs: TCursor; newcurs: TCursor);
Begin
  oldcurs := Screen.Cursor;
  If Screen.Cursor <> newcurs Then Screen.Cursor := newcurs;
End;

Procedure CursorRestore(oldcurs: TCursor);
Begin
  If Screen.Cursor <> oldcurs Then Screen.Cursor := oldcurs;
End;

Function magStatusDesc(Value: Integer): String;
Begin
  Case Value Of
    0: Result := 'Viewable (no status)';
    1: Result := 'Viewable';
    2: Result := 'QA Reviewed';
    4: Result := 'ImageGroup';
    7: Result := 'Controlled';
    8: Result := 'NeedsRefresh';
    10: Result := 'In Progress';
    11: Result := 'Needs Review';
    12: Result := 'Deleted';
    13: Result := 'Image Never Existed';
    21: Result := 'Questionable Integrity';
    22: Result := 'TIU Authorization block.';
    23: Result := 'RAD Exam Status block.';
  Else
    Result := 'unknown status';
  End;
    (*
      mistNoStatus = 0;
      mistViewable = 1;
      mistVerified = 2;

      mistImageGroup = 4;

      mistSensitive = 7;
      mistNeedsRefresh = 8;

      mistInProgress = 10;
      mistNeedsReview = 11;
      mistDeleted = 12;

      mistQI = 21;
      mistTIULocked = 22;
      mistRADLocked = 23;
    *)

End;

Function MagStrToInt(Value: String; defaultvalue: Integer = 0): Integer;
Begin
  Try
    If Value = '' Then
      Result := defaultvalue
    Else
      Result := Strtoint(Value);
  Except
    On Exception Do
      Result := defaultvalue;
  End;
End;

Function Maginttobool(Value: Integer): Boolean;
Begin
    // Called with value from a set of codes that is 1 | 0
  Result := (Value <> 0)
End;

Function Magstrtobool(Value: String; defaultvalue: String = ''): Boolean;
Begin
     {new in 93.  IF value = '' then  use the default as value and proceed}
  If Value = '' Then Value := defaultvalue;
    // Called with a 'TRUE' 'True' 'False' 'FALSE' '0' '1'
  Result := ((Uppercase(Value) = 'TRUE') Or (Value = '1'));
End;

Function Magbooltostr(Value: Boolean): String;
Begin
  If Value Then
    Result := 'True'
  Else
    Result := 'False';
End;

Function Magbooltostrint(Value: Boolean): String;
Begin
  If Value Then
    Result := '1'
  Else
    Result := '0';
End;

Function MagBoolToInt(Value: Boolean): Integer;
Begin
  If Value Then
    Result := 1
  Else
    Result := 0;
End;

Function PackagesToString(Pkg: TMagPackages): String;
Begin
    //MED,SUR,RAD,LAB,NOTE,CP,CNSLT,NONE
  Result := '';
  If (MpkgMED In Pkg) Then
    Result := Result + 'MED,';
  If (MpkgSUR In Pkg) Then
    Result := Result + 'SUR,';
  If (MpkgRAD In Pkg) Then
    Result := Result + 'RAD,';
  If (MpkgLAB In Pkg) Then
    Result := Result + 'LAB,';
  If (MpkgNOTE In Pkg) Then
    Result := Result + 'NOTE,';
  If (MpkgCP In Pkg) Then
    Result := Result + 'CP,';
  If (MpkgCNSLT In Pkg) Then
    Result := Result + 'CNSLT,';
  If (MpkgNONE In Pkg) Then
    Result := Result + 'NONE,';
  Result := Copy(Result, 1, Length(Result) - 1);
End;

Function StringToPackages(Str: String): TMagPackages;
Var
  Pkg: TMagPackages;
Begin
  Pkg := [];
  Result := [];
    //MED,SUR,RAD,LAB,NOTE,CP,CNSLT,NONE
  If (Pos('MED', Str) > 0) Then
    Result := Result + [MpkgMED];
  If (Pos('SUR', Str) > 0) Then
    Result := Result + [MpkgSUR];
  If (Pos('RAD', Str) > 0) Then
    Result := Result + [MpkgRAD];
  If (Pos('LAB', Str) > 0) Then
    Result := Result + [MpkgLAB];
  If (Pos('NOTE', Str) > 0) Then
    Result := Result + [MpkgNOTE];
  If (Pos('CP', Str) > 0) Then
    Result := Result + [MpkgCP];
  If (Pos('CNSLT', Str) > 0) Then
    Result := Result + [MpkgCNSLT];
  If (Pos('NONE', Str) > 0) Then
    Result := Result + [MpkgNONE];
End;

Function ClassesToStringGen(Cls: TmagImageClasses): String; //93
Begin
  Result := '';
  If ((MclsClin In Cls) And (MclsAdmin In Cls)) Then
    Exit;
  If (MclsClin In Cls) Then
    Result := Result + MagdisclsClinShow + ',';
  If (MclsAdmin In Cls) Then
    Result := Result + MagdisclsAdminShow + ',';
  Result := Copy(Result, 1, Length(Result) - 1);
End;

Function ClassesToString(Cls: TmagImageClasses): String;
Begin
  Result := '';
  If (MclsClin In Cls) Then
    Result := Result + MagdisclsClin + ',';
  If (MclsAdmin In Cls) Then
    Result := Result + MagdisclsAdmin + ',';
    //tried in 93,  but error down road,
    //  if (mclsCLIN in cls) then result := result + magdisclsClinShow + ',' ;
    //  if (mclsADMIN in cls) then result := result + magdisclsADMINShow + ',' ;
  Result := Copy(Result, 1, Length(Result) - 1);
End;

Function ClassesToSet(Cls: TmagImageClasses): String;
Begin
    //CLIN, ADMIN
  Result := '';
  If (MclsClin In Cls) Then
    Result := Result + 'CLIN' + ',';
  If (MclsAdmin In Cls) Then
    Result := Result + 'ADMIN' + ',';
  Result := Copy(Result, 1, Length(Result) - 1);
End;

Function StringToClasses(Str: String): TmagImageClasses;
Begin
    //CLIN, ADMIN   Could also be the only strings sent.  Then convert to
    //              proper mcls...
  Result := [];
  If (Pos(MagclsAll, Str) > 0) Then
  Begin
    Result := Result + [MclsClin, MclsAdmin];
    Exit;
  End;
  If (Pos(MagdisclsClin, Str) > 0) Then
    Result := Result + [MclsClin];
  If (Pos(MagdisclsAdmin, Str) > 0) Then
    Result := Result + [MclsAdmin];
  If (Pos(MagdisclsClinShow, Str) > 0) Then
    Result := Result + [MclsClin];
  If (Pos(MagdisclsAdminShow, Str) > 0) Then
    Result := Result + [MclsAdmin];
  If Str = 'ADMIN' Then
    Result := Result + [MclsAdmin];
  If Str = 'CLIN' Then
    Result := Result + [MclsClin];
End;

{ TImageFilter }

Function TImageFilter.DetailedDesc: TStrings;
Var
  s: String;
Begin
    // Not yet called by Application.
  Result := Tstringlist.Create;
  Result.Add('FILTER DETAILS');
  Result.Add('');
  Result.Add('Name :      ' + Fname);
  Result.Add('');

  s := ClassesToString(FClasses);
  If s = '' Then
    s := 'Any';
  Result.Add('Class :    ' + s);
  Result.Add('');

  s := FScope;
  If s = '' Then
    s := 'Any';
  Result.Add('Origin :     ' + s);
  Result.Add('');

    // we have a few if, rather that if then else for a reason
    //  we want to make sure the date properties are getting cleared when
    //  they should.  Only one of the IF's below, should be TRUE.
    //   If not, then we'll see it and know of a problem.
  If ((FfromDate <> '') Or (FtoDate <> '')) Then
  Begin
    Result.Add('Dates:    ' + 'from: ' + FfromDate + '  thru  ' + FtoDate);
  End;
  If (FMthRange <> 0) Then
  Begin
    Result.Add('Dates:    for the last ' + Inttostr(Abs(FMthRange)) + ' months.');
  End;
  If (FMthRange = 0) And (FfromDate = '') And (FtoDate = '') Then
    Result.Add('Dates:    All Dates.');
  Result.Add('');

  s := PackagesToString(Fpkgs);
  If s = '' Then
    s := 'Any';
  Result.Add('Packages:    ' + s);
  Result.Add('');

  Result.Add('Types: ');
  s := Ftypes;
  If s = '' Then
    s := 'Any';
  Result.Add(s);
  Result.Add('');

  Result.Add('Specialty/SubSpecialty:');
  s := FSpecSubSpec;
  If s = '' Then
    s := 'Any';
  Result.Add(s);
  Result.Add('');

  Result.Add('Procedure/Event:');
  s := FProcEvent;
  If s = '' Then
    s := 'Any';
  Result.Add(s);
  Result.Add('');

End;

Function TImageFilter.Detailstring: String;
Begin
  Result := '';
  Result := PackagesToString(Fpkgs);
  Result := Result + ';' + ClassesToString(FClasses);
  Result := Result + ';' + Ftypes;
  Result := Result + ';' + FSpecSubSpec;
  Result := Result + ';' + FProcEvent;
  Result := Result + ';' + FfromDate;
  Result := Result + ' - ' + FtoDate;
    //result := copy(result,1,length(result)-1);
End;

Function StringToFilter(Value: String): TImageFilter;
//var vCls : string;
Begin
    (* ^MAG(2005.87,D0,0)= (#.01) NAME [1F] ^ (#1) PACKAGE [2F] ^ (#2) CLASS [3S] ^
                     ==>(#3) TYPE [4F] ^ (#4) EVENT [5F] ^ (#5) SPEC [6F] ^ (#6)
                     ==>FROM [7D] ^ (#7) UNTIL [8D] ^ (#8) RELATIVE RANGE [9N] ^
                     ==>(#9) Origin [10S] ^

     MAGRY(1)=FLTIEN_"^"_^MAG(2005.87,FLTIEN,0)
    *)
  Result := TImageFilter.Create;
  With Result Do
  Begin
    FFltID := MagPiece(Value, '^', 1);
    Fname := MagPiece(Value, '^', 2);
    Fpkgs := StringToPackages(MagPiece(Value, '^', 3));
    FClasses := StringToClasses(MagPiece(Value, '^', 4));
    Ftypes := MagPiece(Value, '^', 5);
    FProcEvent := MagPiece(Value, '^', 6);
    FSpecSubSpec := MagPiece(Value, '^', 7);
    FfromDate := MagPiece(Value, '^', 8);
    FtoDate := MagPiece(Value, '^', 9);
    If (MagPiece(Value, '^', 10) <> '') Then
      FMthRange := Strtoint(MagPiece(Value, '^', 10))
    Else
      FMthRange := 0;
    FScope := MagPiece(Value, '^', 11);
        {DONE -ogarrett -c93 :   Need to follow through,
              to make sure filter is saved in Vista and Returned From vista. }
    Fstatus := MagPiece(Value, '^', 12);
    FShortDescHas := MagPiece(Value, '^', 13);
    FImageCapturedByDUZ := MagPiece(Value, '^', 14);
    FUseCapDt := Magstrtobool(MagPiece(Value, '^', 15));
    FMaxNumber := MagPiece(Value, '^', 16);
  End;
End;

Function FilterToString(Filter: TImageFilter): String;
Var
  u: String;
Begin
  u := '^';
  With Filter Do
    Result := FFltID + u + Fname + u + PackagesToString(Fpkgs) + u + ClassesToString(FClasses) + u +
      Ftypes
      + u + FProcEvent + u + FSpecSubSpec + FfromDate + u + FtoDate + u + Inttostr(FMthRange) + u +
      FScope;
End;

Procedure FilterToFieldList(Flt: TImageFilter; Var t: TStrings; Duz: String = '');
//var i : integer;
Begin
    (* ^MAG(2005.87,D0,0)= (#.01) NAME [1F] ^ (#1) PACKAGE [2F] ^ (#2) CLASS [3S] ^
                     ==>(#3) TYPE [4F] ^ (#4) EVENT [5F] ^ (#5) SPEC [6F] ^ (#6)
                     ==>FROM [7D] ^ (#7) UNTIL [8D] ^ (#8) RELATIVE RANGE [9N] ^
                     ==>(#9) Origin [10S] ^

     MAGRY(1)=FLTIEN_"^"_^MAG(2005.87,FLTIEN,0)
    *)
  t.Clear;
  With Flt Do
  Begin
    If FFltID <> '' Then
      t.Add('IEN^' + FFltID);
    If Fname <> '' Then
      t.Add('.01^' + Fname);
    If Fpkgs <> [] Then
      t.Add('1^' + PackagesToString(Fpkgs));
    If FClasses <> [] Then
      t.Add('2^' + ClassesToSet(FClasses));
    If Ftypes <> '' Then
      t.Add('3^' + Ftypes);
    If FProcEvent <> '' Then
      t.Add('4^' + FProcEvent);
    If FSpecSubSpec <> '' Then
      t.Add('5^' + FSpecSubSpec);
    If FfromDate <> '' Then
      t.Add('6^' + FfromDate);
    If FtoDate <> '' Then
      t.Add('7^' + FtoDate);
        //if FMthRange  <> '' then
    t.Add('8^' + Inttostr(FMthRange));
    If FScope <> '' Then
      t.Add('9^' + FScope);
    If Duz <> '' Then
      t.Add('USER^' + Duz)
    Else
      t.Add('21^PUBLIC');
        //p93
        {
        FStatus : string;
        FShortDescHas : string;
        FImageCapturedByDUZ : string;
        FUseCapDt : string;
        }
    If Fstatus <> '' Then
      t.Add('10^' + Fstatus);
    If FShortDescHas <> '' Then
      t.Add('11^' + FShortDescHas);
    If FImageCapturedByDUZ <> '' Then
      t.Add('12^' + FImageCapturedByDUZ);
    If FUseCapDt Then
      t.Add('13^1');
        //here 5/29/09  Need to save Columns with Filter.
        // for new filter in filter window, we'll use User's default columns.
    If Upref.ImageListWincolwidths <> '' Then
      t.Add('15^' + Upref.ImageListWincolwidths);

  End;
End;
{   This returns the a list that contains the 'coded fields and values'
    that will be used in the MAG4IMAGELIST RPC call to get a list of
    images based on this filter.
    Some Filter Properties are not included in the list
    Some Filter Properties are used as other parameters in the RPC Call.}

Function TImageFilter.GetParamList: TStrings;
Var
  i: Integer;
  s: String;
Begin
      {DONE -ogarrett -cp117 :
117 In here add a new entry to tell server to return image groups only if
one of the Images in the Group meet the requested 'Status' value.
....  not remember where the change was. }
  Result := Tstringlist.Create;
  With Result Do
  Begin
        //n/a if FFltID  <> '' then add('IEN^'+FFltID);
        //n/a if FName  <> '' then add('.01^'+FName);
    If Fpkgs <> [] Then
      Add('IXPKG^^' + MagTranspose(StripFirstLastComma(PackagesToString(Fpkgs)), ',', '^'));
    If FClasses <> [] Then
      Add('IXCLASS^^' + MagTranspose(StripFirstLastComma(ClassesToString(FClasses)), ',', '^'));
    If Ftypes <> '' Then
      Add('IXTYPE^^' + MagTranspose(StripFirstLastComma(Ftypes), ',', '^'));
    If FProcEvent <> '' Then
      Add('IXPROC^^' + MagTranspose(StripFirstLastComma(FProcEvent), ',', '^'));
    If FSpecSubSpec <> '' Then
      Add('IXSPEC^^' + MagTranspose(StripFirstLastComma(FSpecSubSpec), ',', '^'));
        //n/a if FFromDate  <> '' then add('6^'+FFromDate);
        //n/a if FToDate  <> '' then add('7^'+FToDate);
        {//if FMthRange  <> '' then // commented out pre 93}
        //n/a add('8^'+inttostr(FMthRange));
    If FScope <> '' Then
      Add('IXORIGIN^^' + MagTranspose(StripFirstLastComma(FScope), ',', '^'));
        //n/a  if duz <> '' then add('USER^'+duz)
        //n/a              else add('21^PUBLIC');
        //p93
        {   we have to add  '0' for Viewable Images that are old..   All new captures get '1' for the status
            that means 'Viewable' Old images have '' for Status, Sergey worked it so that we can send '0' for them}
    If Fstatus <> '' Then
    Begin
      s := Fstatus;
      If s = 'Viewable' Then
        s := '0,1'
      Else
        For i := 1 To Maglength(Fstatus, ',') Do
        Begin
          If MagPiece(Fstatus, ',', i) = '1' Then
          Begin
            s := '0,' + Fstatus;
            Break;
          End;
          If MagPiece(Fstatus, ',', i) = 'Viewable' Then
          Begin
            s := MagSetPiece(Fstatus, ',', i, '0,1');
            Break;
          End;
        End;
      Add('ISTAT^^' + MagTranspose(StripFirstLastComma(s), ',', '^'));
    End;

    If FShortDescHas <> '' Then
      Add('GDESC^^' + FShortDescHas);
    If FImageCapturedByDUZ <> '' Then
      Add('SAVEDBY^^' + MagTranspose(StripFirstLastComma(FImageCapturedByDUZ), ',', '^'));
        //n/a if FUseCapDt  then add('13^1');
    If FCaptureDevice <> '' Then
      Add('CAPTAPP^^' + FCaptureDevice);
        //if FMaxNumber <> '' then add('MAXNUM^^' + FMaxNumber);

//117 TEST        if FGroupImageStatus <> '' then
//117 TEST            add('GRPSTAT^^' + FGroupImageStatus);
  End;
End;

{ TuPrefCapTIU }

Function TuprefCapTIU.DefaultLocDA: String;
Begin
  Result := MagPiece(DefaultLoc, '~', 1);
End;

Function TuprefCapTIU.DefaultLocName: String;
Begin
  Result := MagPiece(DefaultLoc, '~', 2);
End;

{ TImageFMSet }
    {   example Set Definition
        1:Viewable;2:QA Reviewed;3:In Progress;4:Needs Review;   }

Function TImageFMSet.GetExternalFromInternal(Value: String): String;
Var
  i : Integer;
Begin
  Try
    If Value = '' Then
      Raise Exception.Create('Invalid Set Value');
    If DBSetDefinition = '' Then
      Raise Exception.Create('Invalid Set Definition');
    For i := 1 To Maglength(DBSetDefinition, ';') Do
    Begin
      If MagPiece(MagPiece(DBSetDefinition, ';', i), ':', 1) = Value Then
      Begin
        Result := MagPiece(MagPiece(DBSetDefinition, ';', i), ':', 2);
        Break;
      End;
    End;
  Except
    Result := '';
  End;
End;

Function TImageFMSet.GetInternalFromExternal(Value: String): String;
Var
  i: Integer;
Begin
  Try
    If Value = '' Then
      Raise Exception.Create('Invalid Set Value');
    If DBSetDefinition = '' Then
      Raise Exception.Create('Invalid Set Definition');
    For i := 1 To Maglength(DBSetDefinition, ';') Do
    Begin
      If MagPiece(MagPiece(DBSetDefinition, ';', i), ':', 2) = Value Then
      Begin
        Result := MagPiece(MagPiece(DBSetDefinition, ';', i), ':', 1);
        Break;
      End;
    End;
  Except
    Result := '';
  End;
End;

Function TImageFMSet.GetListOfExternalValues: TStrings;
Var
  i: Integer;
Begin
  Result := Nil;//RLM Fixing MemoryLeak 6/18/2010
  Try
    ListOfExternalValues.Clear;//RLM Fixing MemoryLeak 6/18/2010
    If DBSetDefinition = '' Then
      Raise Exception.Create('Invalid Set Definition');
    While Copy(DBSetDefinition, Length(DBSetDefinition), 1) = ';' Do
      DBSetDefinition := Copy(DBSetDefinition, 1, Length(DBSetDefinition) - 1);
    For i := 1 To Maglength(DBSetDefinition, ';') Do
    Begin
      ListOfExternalValues.Add(MagPiece(MagPiece(DBSetDefinition, ';', i), ':', 2));//RLM Fixing MemoryLeak 6/18/2010
    End;
  Except
  End;
  Result := ListOfExternalValues;//RLM Fixing MemoryLeak 6/18/2010
End;

{ DONE -ogarrett -c140 :  get this out of here.  don't want coupled to magguini..}
//P106 BB debug added to capture, value kept in .ini

(*
function GetDebugMode: boolean;

  *)
Initialization
  ListOfExternalValues := Tstringlist.Create;//RLM Fixing MemoryLeak 6/18/2010

Finalization
  FreeAndNil(ListOfExternalValues);//RLM Fixing MemoryLeak 6/18/2010

End.
