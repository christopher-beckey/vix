Unit cMag4Vgear;
   {
   Package: MAG - VistA Imaging
   WARNING: Per VHA Directive 10-93-142 this unit should not be modified.
   Date Created:
   Site Name: Silver Spring, OIFO
   Developers: Garrett Kirin
   [==     unit cMag4VGear;
   Description:
        TMag4VGear is a Wrapper around Accusoft's TGear control.  The Application
        has access to only those properties that the wrapper surfaces from the
        TGear class.
        In the Future:   TMag4VGear will implement the IMagImage Interface
        (yet to be created).  The application will be able to operate with
        any object that implements the interface, not just with TMag4VGear objects.
        It will be easy to substitute other Wrapper Objects that implement the Interface.
        We will be able to treat unrelated objects Polymorphically.
        We we won't be limited to using Accusoft controls for all our Imaging needs.

        TFrame is the ancestor of Tmag4Vgear.  By using a Frame we can make a
        Class that includes other controls and objects easier that doing it by hand.
        Being a TFrame, we have to surface certain properties of the included
        controls as published.  Example  TImageMouseUp event has to be declared
        as a published property, we connect it to the mouse up event of the TGear
        control.  But without surfacing it, the user of the control would not be
        able to connect an event handler to it.

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
//{ $ DEFINE PROTOTYPE}

Interface

Uses
  Buttons,
  Classes,
  //cmaglogmanager,  {JK 10/5/2009 - Maggmsgu refactoring - deprecated unit}
  Controls,
  ExtCtrls,
{$IFDEF USENEWANNOTS}
  fMagAnnot,
{$ELSE}
  FmagAnnotation,
{$ENDIF}
  FmagImage,
  Forms,
  Graphics,
  Stdctrls,
  UMagClasses,
  UMagClassesAnnot,
  UMagDefinitions,
  Maggmsgu,
  Windows
  , ImgList, ComCtrls, ToolWin   //117
  ;

// indicates how the VGear should look, how it should show the description and how it should be sized
Type
  TMagGearViewStyle = (MagGearViewAbs, MagGearViewImageListAbs, MagGearViewFull, MagGearViewStudy, MagGearViewRadiology);

// not implemented - used to indicate which level of an image is loaded in the viewer
// this type is basically copied in MagImageManager, should be made generic
Type
  TMagGearImageViewState = (MagGearImageViewAbs, MagGearImageViewFull, MagGearImageViewBig);

Type
  TMag4VGear = Class; // ';' means forward declaration
//59        {       The scroll event}
//59  TImageScrollEvent = procedure(sender: TObject; mag4VGear: TMag4Vgear; hpos, vpos: integer) of Object;

        {       The Image Click event }
  TImageClickEvent = Procedure(Sender: Tobject; Gearclicked: TMag4VGear) Of Object;
        {       The Image Mouse Down event }
  TImageMouseDownEvent = Procedure(Sender: Tobject; Button: TMouseButton; Shift: TShiftState; x, y: Integer) Of Object;
        {       The Image Mouse Up event }
  TImageMouseUpEvent = Procedure(Sender: Tobject; Button: TMouseButton; Shift: TShiftState; x, y: Integer) Of Object;
        {       The Image Key Down Event  }

  TImageDoubleClickEvent = Procedure(Sender: Tobject) Of Object;

  TMag4VGear = Class(TFrame)
    Bevel1: TBevel;
    btn1to1: TSpeedButton;
    btnCloseImage: TSpeedButton;
    btnDownArrow: TSpeedButton;
    LblDescIndex: Tlabel;
    LblDescPage: Tlabel;
    LblImage: Tlabel;
    PnlClose: Tpanel;
    PnlDesc: Tpanel;
    PnlHeader: Tpanel;
    PnlImage: Tpanel;
    PnlRadiology: Tpanel;
    {/117 lbImageStatus is an 117 addition }
    lbImageStatus: TLabel;

    Procedure LblImageMouseDown(Sender: Tobject; Button: TMouseButton; Shift: TShiftState; x, y: Integer);
    Procedure LblImageMouseMove(Sender: Tobject; Shift: TShiftState; x, y: Integer);
    Procedure LblImageDblClick(Sender: Tobject);

    Procedure FrameMouseMove(Sender: Tobject; Shift: TShiftState; x, y: Integer);
    Procedure FrameMouseUp(Sender: Tobject; Button: TMouseButton; Shift: TShiftState; x, y: Integer);
    Procedure FrameStartDrag(Sender: Tobject; Var DragObject: TDragObject);
    Procedure FrameEndDrag(Sender, Target: Tobject; x, y: Integer);

    Procedure btn1to1Click(Sender: Tobject);
    Procedure btnDownArrowClick(Sender: Tobject);
    Procedure LblImageMouseEnter(Sender: Tobject);
    Procedure LblImageMouseLeave(Sender: Tobject);

    Procedure LblStudyDetailsMouseDown(Sender: Tobject;
      Button: TMouseButton; Shift: TShiftState; x, y: Integer);
    Procedure FrameMouseWheelDown(Sender: Tobject; Shift: TShiftState;
      MousePos: TPoint; Var Handled: Boolean);
    Procedure FrameMouseWheelUp(Sender: Tobject; Shift: TShiftState;
      MousePos: TPoint; Var Handled: Boolean);
    Procedure btnCloseImageClick(Sender: Tobject);

  Private
    TmrDrawLetters: TTimer;
    DisplayInterface: TMagImage;
    FImageLoaded: Boolean;
    FSelectRectWidth: Integer;
    FShowImageStatus : boolean;   //117
    FImageClick: TImageClickEvent;
    FImageMouseDown: TImageMouseDownEvent;
    FImageMouseUp: TImageMouseUpEvent;
    FImageKeyDown: TImageKeyDownEvent;

    FImageMouseScrollUp: TImageMouseScrollUpEvent;
    FImageMouseScrollDown: TImageMouseScrollDownEvent;

    FImageDoubleClick: TImageDoubleClickEvent;

    FImageScroll: TImageScrollEvent;
    FImageWinLevChange: TImageWinLevChangeEvent;
    FImageBriConChange: TImageBriConChangeEvent;
    FImageToolChange: TImageToolChangeEvent;
    FImageZoomChange: TImageZoomChangeEvent;
    FImageUpdateImageState: TImageUpdateImageStateEvent;
    FAbstractImage: Boolean;
    FModINV: Boolean;
    FModFLIP: Boolean;
    FImageModified: Boolean;
    FIsDragAble: Boolean;
    FIsSizeAble: Boolean;
    FSelected: Boolean;
    FAutoRedraw: Boolean;
    FPanWindow: Boolean;
    FZoomWindow: Boolean;
    FresizeX: Boolean;
    FresizeY: Boolean;
    FShowImageOnly: Boolean;

//    Fbrightnesspassed:  integer;
//    FContrastPassed:    integer;
    Fdragx: Integer;
    Fdragy: Integer;
    FStartX: Integer;
    FStartY: Integer;
    FIndex: Integer;
    FFontSize: Integer;

    FModROT: byte;
    FOldHintHidePause: Integer;
    // JMW 2/14/2007 P72
    // variables that hold the modifications made to the image
    FModFlipHoriz: Boolean;
    FModFlipVert: Boolean;
    FModRotateDeg: Integer;
    FModFlipRotDeg: Integer;
    FModIsFront: Boolean;

    FCurrentImage: String; // filename of currently loaded image
    FDicomData: TDicomData;

    FViewStyle: TMagGearViewStyle;
    FImageViewState: TMagGearImageViewState;

    //FOnLogEvent : TMagLogEvent;   {JK 10/5/2009 - Maggmsgu refactoring}

    FMouseMoveX: Integer;
    FMouseMoveY: Integer;

    FReducedQuality: Boolean; // this means reference quality
    // JMW 8/27/08 p72t26
    // this is different from reduced, this acutally means a downsampled image, not compressed
    FDownsampledImage: Boolean;
    FCTPresetsEnabled: Boolean;

    // indicates if this image has the proper header values to do measurements
    FMeasurementsEnabled: Boolean;

    // determines if Rad Viewer shows pixel values in the hint (only used in Rad Viewer)
    FShowPixelValues: Boolean;

    // determines if Rad labels are on/off
    FShowLabels: Boolean;

    // determines if the default win/level should be from header/txt file or based on gear component
    FHistogramWindowLevel: Boolean;

    // get rid of this, not needed (listindex)
    FImageNumber: Integer;

    // determines the abilities of the gear component (PDF, Annotation, MED)
    FGearAbilities: TMagGearAbilities;

    // indicates if the loaded image is the diagnostic image (JMW 1/2/2007)
    // this variable does not actually cause the diagnostic image to be loaded,
    // it just indicates if it was loaded
    FIsDiagnosticImage: Boolean;

    FAnnotationStyle: TMagAnnotationStyle;

    FMagAnnotationStyleChangeEvent: TMagAnnotationStyleChangeEvent;

    FOrientationLabel: Tlabel;
    FPanWindowClose: TMagPanWindowCloseEvent;

    { 	the current position of the orientation label if the orientation
     label is not currently visible.  }
    FOrientationLabelAnchor: TAnchorKind;
    Procedure TmrDrawLettersTimer(Sender: Tobject);
    Procedure SetZoomWindow(Value: Boolean);
    Procedure SetPanWindow(Value: Boolean);
    Procedure SetSelected(Value: Boolean);
    Procedure SetAbstractImage(Const Value: Boolean);
    Function GetPage: Integer;
    Function GetPageCount: Integer;
    Procedure SetPage(Const Value: Integer);
    Procedure SetPageCount(Const Value: Integer);
    Function GetImageDescription: String;
    Procedure SetImageDescription(Const Value: String);
    Function IsImageAGroup: Boolean;
    Procedure SetShowImageOnly(Const Value: Boolean);
    Function IsImageInGroup: Boolean;
    Procedure ImageDescriptionUpdate;
    Procedure SetDescFont(Fname: String; FSize, FHeight: Integer);
    Procedure GetNextGroupImage;
    Procedure DeSkewImage;

//    function determineGearToUse(FileExtension : String) : TMagGearType;
    Procedure ImageDoubleClick(Owner: Tobject);
    Procedure ImageMouseDown(Sender: Tobject; Button: TMouseButton; Shift: TShiftState; x, y: Integer);
    Procedure ImageMouseUp(Sender: Tobject; Button: TMouseButton; Shift: TShiftState; x, y: Integer);
    Procedure LoadTGAText(TxtFile: String);
    Procedure LoadPatientSSNFromTxtFile(TxtFile: String);
    Function GetComponentFunctions(): TMag4VGearFunctions;
{$IFDEF USENEWANNOTS}
    Function GetAnnotationComponent(): TMagAnnot;
{$ELSE}
    Function GetAnnotationComponent(): TMagAnnotation;
{$ENDIF}
    Function GetUnsavedChanges(): Boolean;

    Procedure OnImageMouseScrollUp(Sender: Tobject; Shift: TShiftState; MousePos: TPoint; Var Handled: Boolean);
    Procedure OnImageMouseScrollDown(Sender: Tobject; Shift: TShiftState; MousePos: TPoint; Var Handled: Boolean);

    Procedure SetViewStyle(Value: TMagGearViewStyle);
    Function IsHandledType(IObj: TImageData): Boolean;
    //procedure LogMsg(MsgType : String; Msg : String; Priority : TMagLogPriority = MagLogINFO);  {JK 10/5/2009 - Maggmsgu refactoring - remove old method}

    Procedure OnImageMouseMove(Sender: Tobject; Button: TMouseButton; Shift: TShiftState; x, y: Integer);
    Procedure SetBackgroundColor();
    Function CheckSSN(SSN2005, DICOMSSN: String): Boolean;
    //procedure setLogEvent(Value : TMagLogEvent);  {JK 10/5/2009 - Maggmsgu refactoring}
    Procedure SetShowPixelValues(Value: Boolean);
    Procedure SetHistogramWindowLevel(Value: Boolean);
    Procedure RefreshRadiologyHint();
    Procedure SetImageScroll(Value: TImageScrollEvent);
    Procedure SetImageWinLevChange(Value: TImageWinLevChangeEvent);
    Procedure SetImageZoomChange(Value: TImageZoomChangeEvent);
    Procedure SetImageUpdateImageState(Value: TImageUpdateImageStateEvent);

    Procedure ImageWinLevChange(Sender: Tobject; WindowValue: Integer; LevelValue: Integer);
    Procedure ImageBriConChange(Sender: Tobject; BrightnessValue: Integer; ContrastValue: Integer);
    Procedure ImageToolChange(Sender: Tobject; Tool: TMagImageMouse);
    Procedure ImageZoomChange(Sender: Tobject; ZoomValue: Integer);
    Procedure ImageUpdateImageState(Sender: Tobject);

    Procedure DrawRadLettersExecute();
    Procedure InitDrawLettersTimer; //jw 11/16/07
    Procedure SetImageKeyDownChange(Value: TImageKeyDownEvent);
    Procedure MagAnnotationStyleChangeEvent(Sender: Tobject; AnnotationStyle: TMagAnnotationStyle);
    Function CheckICN(ICN2005, HeaderICN: String): Boolean;
    Procedure SetShowLabels(Value: Boolean);
    Procedure ShowOrientationLabel(Letter: String);
    Procedure SetPanWindowClose(Value: TMagPanWindowCloseEvent);
    Function GetDownsampledWinLevValue(OriginalValue: Integer;
      OriginalBitDepth, DownsampledBitDepth: Integer): Integer;
    Function IsPatientICNValid(ICN: String): Boolean;
    Procedure SetOrientationLabelPosition(AnchorLocation: TAnchorKind);
    Function GetOrientationLabelAnchor(): TAnchorKind;
    Procedure RotateOrientationLabel(NumTimes: Integer);
    Function GetMagImage: TMagImage;

  Protected

  Public

        {       This is a pointer to the parent control.  In some cases, this
                control needs to know if the parent is a TMag4Viewer.}
    FParentViewer: TWinControl;
        {       Image Data object.  Has data from VistA}
    PI_ptrData: TImageData;

    Constructor Create(AOwner: TComponent); Overload; Override;
    Constructor Create(AOwner: TComponent; FileExtension: String = ''; GearAbilities: TMagGearAbilities = MagGearAbilityRadiology); Overload; //override;
    Destructor Destroy; Override;
        {  Future: with new version of Accusoft}
    Procedure WinLevValue(WinValue, LevValue: Integer);
        {  smooth edges of image, used on 1 but tifs for easier, clear reading}
    Procedure SmoothImage; //p8t43
        {  Reloads the Image from disk.}
    Procedure RefreshImage;
        {  Redraws the Image, does not do a Reload}
    Procedure ReDrawImage;
        {  undo all manipilations, and Fit to Window}
    Procedure ResetImage;
        {  Load from the TImageData object
           Abs: if TRUE load the Abstract, Else it is a Full Res Image.}
    Procedure LoadTheImage(IObj: TImageData; Abs: Boolean = False; DiagnosticImage: Boolean = False); Overload;
        {  Loads the imagefile}
    Procedure LoadTheImage(Imagefile: String; DiagnosticImage: Boolean = False); Overload;
    Procedure FitToWidth;
    Procedure FitToHeight;
    Procedure FitToWindow;
        {  Fit 1 image pixel to 1 screen pixel.  Actual Size.}
    Procedure Fit1to1;
    Procedure FlipVert;
    Procedure FlipHoriz;
        {  deg is 90,180 or 270}
    Procedure Rotate(Deg: Integer);
    Procedure Inverse;
        {  Preform both operations, DeSkew to straighten and Smooth to make
           edges clearer.  Gives an Image that is easier to view, less strain on eyes}
    Procedure DeSkewAndSmooth;
        {  mouse will act as magnifier }
    Procedure MouseMagnify;
        {  mouse will pan the image }
    Procedure MousePan;
        {  mouse will select area.  That area will be zoomed to (as close as possible) }
    Procedure MouseZoomRect;
        {  mouse pointer }
    Procedure MouseReSet;

    Procedure ShowHint(Value: Boolean);
    Procedure ZoomValue(Value: Integer);
    Function GetZoomValue: Integer;
    Procedure ContrastValue(Value: Integer);
    Procedure BrightnessValue(Value: Integer);
    Procedure BrightnessContrastValue(Bright, Contrast: Integer; ApplyToRad: Boolean = False);
        {  performs a DelDoc, to clear the Image from TGear.{}
    Procedure ClearImage;
        {   returns a TMagImageState Object}
    Function GetState: TMagImageState;
    Procedure SetFontSize(Value: Integer);
        {  defines where the Pan Window for this image will be displayed.}
    Procedure PanWindowSettings(h, w, x, y: Integer);
        {  for Multipage images }
        {  Future : These 'paging' methods will also work for Image Groups.}
    Procedure PageFirst;
    Procedure PagePrev;
    Procedure PageNext;
    Procedure PageLast;
    //59 next 3
    Procedure SetScroll(Hval, Vval: Integer); {Change the Scroll position of the Image}
    Procedure ImageHint(Val: String); {Set the Hint of the Image}
    Procedure ImageDescriptionHint(Val: String); {Set the Hint of the Label}

    Procedure SetSettingMode(Mode: Integer);
    Procedure SetSettingValue(Value: Integer);
    Procedure SetPrintSize(Value: Integer);
    Procedure PrintImage(Handle: HDC);
    Procedure CopyToClipboard();
    Function GetBitsPerPixel(): Integer;
    Procedure GearToGear(Gearfr: TMag4VGear);
    Procedure SetAutoRedraw(Value: Boolean);
    Procedure SetUpdateGUI(Value: Boolean);
    Function CanUseForFile(FileExtension: String): Boolean;
    Procedure SetOrientation(Orientation: TMagImageOrientation);
    Function GetImageHeight(): Integer;
    Function GetImageWidth(): Integer;
    Function IsSigned(): Boolean;
    Procedure PromoteColor(ColorValue: TMagImagePromoteValue);
    Function LoadDICOMData(TxtFilename: String; Mag2005SSN, Mag2005ICN: String;
      OnlyUseTGA: Boolean = False): Boolean;
    Procedure Initialize(FileExtension: String = '');
    Procedure AutoWinLevel;
    Function GetFileFormat(): String;
    Function GetCompression(): String;
    Procedure WindowLevelEntireImage();

    Procedure DisableWindowLevel();
      // this is a stupid function i don't want to have, it disables window/level (for QA image) but really shouldn't be here, shouldn't require viewer to call this function
    Procedure UpdatePageView();
    Procedure CalculateMaxWinLev();
    Procedure DrawRadLetters();
    Procedure DisplayDICOMHeader();
    Procedure SetScrollPos(VertScrollPos: Integer; HorizScrollPos: Integer);
    // sets the current tool (handpan, annotation, ruler, win/lev, etc)
    Procedure SetCurrentTool(CurTool: TMagImageMouse);
    Procedure Annotations();
    Procedure Measurements();
    Procedure Protractor();
    Procedure AnnotationPointer();
    Procedure SetAnnotationStyle(AnnotationStyle: TMagAnnotationStyle);
    Procedure SetMagAnnotationStyleChangeEvent(AnnotationStyleChangeEvent: TMagAnnotationStyleChangeEvent);

    Procedure ScrollLeft();
    Procedure ScrollRight();
    Procedure ScrollUp();
    Procedure ScrollDown();
    Function ImageContainsDicomHeader(): Boolean;
    Procedure SetSelectionWidth;
    Procedure setMouseZoomShape(Value: TMagMouseZoomShape);
    Property MagImage: TMagImage Read GetMagImage;
    {/gek p117  added for the display of image status on the Abstracts}
    procedure SetShowImageStatus(value : boolean);  //117
    function GetShowImageStatus() : boolean;  //117
  Published

    (* 7/9/01  This shouldn't be published.  It's internal, when the image is
         clicked, we do stuff, and then see if OnImageClick is assigned ( ImageClick) *)
    //new   property PopUpmenu;
    Property SelectionWidth: Integer Read FSelectRectWidth Write FSelectRectWidth;
        {  show/hide the image description}
    Property ShowImageOnly: Boolean Read FShowImageOnly Write SetShowImageOnly;
        {  Information for Abstract images is displayed different that full size
            and when Loading Image from TImageData object, differnet images are loaded.}
    Property AbstractImage: Boolean Read FAbstractImage Write SetAbstractImage;
        {  Open/Hide a Zoom window for the Image.}
    Property ZoomWindow: Boolean Read FZoomWindow Write SetZoomWindow;
        {  Open/Hide a Pan window for the Image.}
    Property PanWindow: Boolean Read FPanWindow Write SetPanWindow;

        {  Future : Prototype Drag and Drop }
        {  Enable/DisAble dragging the control}
    Property IsDragAble: Boolean Read FIsDragAble Write FIsDragAble;
        {  Future : Allow resizing images. (used sparingly in ReSizeAbstracts Function}
        {  Enable/Disable Resizing the control.}
    Property IsSizeAble: Boolean Read FIsSizeAble Write FIsSizeAble;
        {  Not Implemented:  -- actually it is set to true, not changeable }
    //property AutoRedraw: boolean read FAutoRedraw write FAutoRedraw;
    Property AutoRedraw: Boolean Read FAutoRedraw Write SetAutoRedraw;
        {  Querried by viewer, to determine if operation should be exeuted.}
    Property Selected: Boolean Read FSelected Write SetSelected;
        {   EventHandlers }
 //59   property OnImageScroll: TImageScrollEvent read FImageScroll write FImageScroll;
    Property OnImageClick: TImageClickEvent Read FImageClick Write FImageClick;
    Property OnImageMouseDown: TImageMouseDownEvent Read FImageMouseDown Write FImageMouseDown;
    Property OnImageMouseUp: TImageMouseUpEvent Read FImageMouseUp Write FImageMouseUp;
    Property OnImageKeyDown: TImageKeyDownEvent Read FImageKeyDown Write SetImageKeyDownChange;

    Property OnImageMouseScrollUpEvent: TImageMouseScrollUpEvent Read FImageMouseScrollUp Write FImageMouseScrollUp;
    Property OnImageMouseScrollDownEvent: TImageMouseScrollDownEvent Read FImageMouseScrollDown Write FImageMouseScrollDown;
    Property OnImageDoubleClickEvent: TImageDoubleClickEvent Read FImageDoubleClick Write FImageDoubleClick;
    Property OnImageZoomScroll: TImageScrollEvent Read FImageScroll Write SetImageScroll;
    Property OnImageWinLevChange: TImageWinLevChangeEvent Read FImageWinLevChange Write SetImageWinLevChange;
    Property OnImageBriConChange: TImageBriConChangeEvent Read FImageBriConChange Write FImageBriConChange;
    Property OnImageToolChange: TImageToolChangeEvent Read FImageToolChange Write FImageToolChange;
    Property OnImageZoomChange: TImageZoomChangeEvent Read FImageZoomChange Write FImageZoomChange;
    Property OnImageUpdateImageState: TImageUpdateImageStateEvent Read FImageUpdateImageState Write FImageUpdateImageState;
    Property OnMagAnnotationStyleChangeEvent: TMagAnnotationStyleChangeEvent Read FMagAnnotationStyleChangeEvent Write SetMagAnnotationStyleChangeEvent;

        {  This is set by the Viewer.  It is the Index of the related TImageProxy
            in the Viewers FProxyList of all images in the viewer.}
    Property ListIndex: Integer Read FIndex Write FIndex;
        {  ImagePageCount is a ReadOnly property.  i.e. SetImagePageCount does nothing}
        {  returns number of pages in this image.}
    Property PageCount: Integer Read GetPageCount Write SetPageCount;
        {  Get/Set the current page to view.  If page > total pages, then view
           last page.}
    Property Page: Integer Read GetPage Write SetPage;
    //  {  GroupImageList, gives each group image a pointer to the group list.}
        {  Future.  Not Implemented}
//    property GroupImageList: Tmagimagelist read FGroupImageList write FGroupImageList;
        {  The description display Above (for Full Res) Below (for Abstracts) the image.}
    Property ImageDescription: String Read GetImageDescription Write SetImageDescription;
    {  Font size for Image Description. }
    Property FontSize: Integer Read FFontSize Write SetFontSize;

    Property Dicomdata: TDicomData Read FDicomData;

    Property ComponentFunctions: TMag4VGearFunctions Read GetComponentFunctions;
{$IFDEF USENEWANNOTS}
    Property AnnotationComponent: TMagAnnot Read GetAnnotationComponent;
{$ELSE}
    Property AnnotationComponent: TMagAnnotation Read GetAnnotationComponent;
{$ENDIF}
    Property UnsavedChanges: Boolean Read GetUnsavedChanges;

    Property ViewStyle: TMagGearViewStyle Read FViewStyle Write SetViewStyle;
    Property ImageViewState: TMagGearImageViewState Read FImageViewState Write FImageViewState;

    //property OnLogEvent : TMagLogEvent read FOnLogEvent write setLogEvent;  {JK 10/5/2009 - Maggmsgu refactoring}

    Property ImageLoaded: Boolean Read FImageLoaded Write FImageLoaded;

    Property ShowPixelValues: Boolean Read FShowPixelValues Write SetShowPixelValues;
    Property HistogramWindowLevel: Boolean Read FHistogramWindowLevel Write SetHistogramWindowLevel;
    Property ShowLabels: Boolean Read FShowLabels Write SetShowLabels;

    Property ImageNumber: Integer Read FImageNumber Write FImageNumber;
    Property ImageFilename: String Read FCurrentImage;

    Property OnPanWindowClose: TMagPanWindowCloseEvent Read FPanWindowClose Write SetPanWindowClose;

  End;

Procedure Register;

Implementation
{TODO -cRefactor: this needs to be taken out,  TMag4VGear shouldn't be dependent on TMag4Viewer}
Uses
  cmag4VGearManager,
  cmag4viewer,
  Dialogs,
  Math,
  SysUtils,
  Umagutils8
  ;

{$R *.DFM}

{ TMag4VGear }

Constructor TMag4VGear.Create(AOwner: TComponent);
Begin
  // override the existing base constructor and use the new one
  Create(AOwner, '', MagGearAbilityRadiology);
End;

{JK 10/5/2009 - Maggmsgu refactoring - remove old method}
//procedure TMag4VGear.LogMsg(MsgType : String; Msg : String; Priority : TMagLogPriority = MagLogINFO);
//begin
//  if assigned(OnLogEvent) then
//    OnLogEvent(self, MsgType, Msg, Priority);
//end;

Function TMag4VGear.GetComponentFunctions(): TMag4VGearFunctions;
Begin
  Result := DisplayInterface.ComponentFunctions;
End;

{$IFDEF USENEWANNOTS}

Function TMag4VGear.GetAnnotationComponent(): TMagAnnot;
Begin
  Result := DisplayInterface.AnnotationComponent;
End;
{$ELSE}

Function TMag4VGear.GetAnnotationComponent(): TMagAnnotation;
Begin
  Result := DisplayInterface.AnnotationComponent;
End;
{$ENDIF}

Procedure TMag4VGear.ImageDoubleClick(Owner: Tobject);
Begin
  If Assigned(FImageDoubleClick) Then
    FImageDoubleClick(Self);
    {
  if (FParentViewer is TMag4Viewer) then
  begin
//    if (FParentViewer as TMag4Viewer).AbsWindow then exit;
    if ((FParentViewer as TMag4Viewer).ViewStyle = MagViewerViewAbs) then exit;
    (FParentViewer as TMag4Viewer).MaxImageToggle(self.PI_ptrData);
  end;
  }
End;

// this function is needed because the tMag4VGear OnImageMouseDown event is going to be nil
// when TMag4VGear.create is called, so use this function to then call OnImageMouseDown

Procedure TMag4VGear.ImageMouseDown(Sender: Tobject; Button: TMouseButton; Shift: TShiftState; x, y: Integer);
Var
  PixelVal, XVal, YVal: Integer;
  Red, Green, Blue: Integer;
  Units: String;
Begin
  If Assigned(OnImageMouseDown) Then OnImageMouseDown(Self, Button, Shift, x, y);
    // should this send self or sender?

  If (FViewStyle = MagGearViewRadiology) And (Button = Mbright) Then
  Begin
    DisplayInterface.ImagePointer := MagImagePointerCrossHair;
  End
  Else
    If (FShowPixelValues) {and (DisplayInterface.MouseAction =  mactPan )} Then
    Begin
      XVal := x;
      YVal := y;

    //Hounsfield stuff still doesn't really work right because not easily able to get RGB values if not 24 bit image
    // not sure if this is the correct way to calculate hounsfield values

      If (MagWinLev In DisplayInterface.ComponentFunctions) Then // should determine if gray or color
      Begin
        PixelVal := DisplayInterface.GetPixelValue(XVal, YVal);
        If PixelVal = -1 Then
        Begin
        //LogMsg('','Could not get Pixel values for image hint', MagLogERROR);
          MagLogger.LogMsg('', 'Could not get Pixel values for image hint', MagLogERROR); {JK 10/5/2009 - Maggmsgu refactoring}
          DisplayInterface.Hint := 'Error getting Pixel value @ (' + Inttostr(XVal) + ', ' + Inttostr(YVal) + ')';
          Exit;
        End;
        If Uppercase(FDicomData.Modality) = 'CT' Then
        Begin
          Units := 'Hounsfield';
        End
        Else
        Begin
          Units := 'Pixel';
        End;
        DisplayInterface.Hint := Units + ' Value ' + Inttostr(PixelVal + FDicomData.GetLevelOffset()) + ' @ (' + Inttostr(XVal) + ',' + Inttostr(YVal) + ')';
      End
      Else // color image
      Begin
        If Not DisplayInterface.GetRedGreenBlueValue(XVal, YVal, Red, Green, Blue) Then
        Begin
        // log error from getting values message
        //LogMsg('','Could not get RGB values for image hint', MagLogERROR);
          MagLogger.LogMsg('', 'Could not get RGB values for image hint', MagLogERROR); {JK 10/5/2009 - Maggmsgu refactoring}
          DisplayInterface.Hint := 'Error getting RGB value @ (' + Inttostr(XVal) + ', ' + Inttostr(YVal) + ')';
          Exit;
        End;
        DisplayInterface.Hint := 'Pixel Value RGB (' + Inttostr(Red) + ',' + Inttostr(Green) + ',' + Inttostr(Blue) + ') @ (' + Inttostr(XVal) + ',' + Inttostr(YVal) + ')';
      End;
    End;
End;

Procedure TMag4VGear.ImageMouseUp(Sender: Tobject; Button: TMouseButton; Shift: TShiftState; x, y: Integer);
Begin
  If (FViewStyle = MagGearViewRadiology) And (Button = Mbright) Then
  Begin
    DisplayInterface.ImagePointer := MagImagePointerDefault;
  End;
End;

Procedure TMag4VGear.Initialize(FileExtension: String = '');
Begin
  If DisplayInterface <> Nil Then
    DisplayInterface.Free();
  DisplayInterface := cmag4VGearManager.CreateVGear(FileExtension, FGearAbilities);
  PnlImage.InsertControl(DisplayInterface);
  DisplayInterface.Align := alClient;
  DisplayInterface.Visible := True;

  // set events for object to respond to and then pass to other components
  DisplayInterface.OnImageDblClick := ImageDoubleClick;
  DisplayInterface.OnImageMouseDown := ImageMouseDown;
  DisplayInterface.OnImageMouseScrollUp := OnImageMouseScrollUp;
  DisplayInterface.OnImageMouseScrollDown := OnImageMouseScrollDown;
  DisplayInterface.OnImageMouseMove := OnImageMouseMove;
  DisplayInterface.OnImageMouseUp := ImageMouseUp;
  DisplayInterface.OnImageScroll := OnImageZoomScroll;
  DisplayInterface.OnImageWinLevChange := ImageWinLevChange;
  DisplayInterface.OnImageZoomChange := ImageZoomChange;
  DisplayInterface.OnImageToolChange := ImageToolChange;
  DisplayInterface.OnImageUpdateImageState := ImageUpdateImageState;
  DisplayInterface.OnPanWindowClose := FPanWindowClose;
  MouseReSet;
End;

Constructor TMag4VGear.Create(AOwner: TComponent; FileExtension: String = ''; GearAbilities: TMagGearAbilities = MagGearAbilityRadiology);
//constructor TMag4VGear.Create(AOwner: TComponent);
Begin
  Inherited Create(AOwner);
  FShowImageStatus := false;     //117
  TmrDrawLetters := Nil;
  FGearAbilities := GearAbilities;
  Initialize(FileExtension);
  FViewStyle := MagGearViewFull;
  FImageViewState := MagGearImageViewFull;
  FParentViewer := Nil;
  ListIndex := -1;
  LblImage.Align := alClient;
  LblDescPage.caption := '';
  LblDescIndex.caption := '';
  If (AOwner Is TMag4Viewer) Then FParentViewer := (AOwner As TMag4Viewer);
  If FParentViewer = Nil Then Self.PnlClose.Visible := False;
  (*
  Settings:	IG_ASPECT_NONE          (No adjustment)
                IG_ASPECT_DEFAULT       (Don�t increase width or height of device rect)
                IG_ASPECT_HORIZONTAL    (Preserve width of device rect)
                IG_ASPECT_VERTICAL      (Preserve height of device rect)
                IG_ASPECT_MAXDIMENSION  (Horizontal and vertical aspects are calculated �
                                                        the larger of the two is used.)
                IG_ASPECT_MINDIMENSION  (Best fit)
  *)
  FModINV := False;
  FModFLIP := False;
  FModROT := 0;
  FImageModified := False;

//  Fbrightnesspassed := 100;
//  FContrastPassed := 100;

  Name := '';

  FCurrentImage := '';
  FDicomData := TDicomData.Create();
  FDicomData.ClearFields();

//  FImageNumber := 1;

  PnlRadiology.Visible := False;

  FImageLoaded := False;
  FShowPixelValues := False;
  FHistogramWindowLevel := True;
  FShowLabels := True;
  FPanWindow := False; // pan window invisible
  FOrientationLabel := Nil;
  If FSelectRectWidth = 0 Then FSelectRectWidth := 4;
  SetSelectionWidth;
End;

Procedure TMag4VGear.SetSelectionWidth;
Var
  L, t, w, h: Integer;
Begin
  If ((PnlImage.Left <> FSelectRectWidth)
    Or (PnlImage.Top <> FSelectRectWidth)
    Or (PnlImage.Width <> (Self.Width - (2 * FSelectRectWidth)))
    Or (PnlImage.Height <> (Self.Height - (2 * FSelectRectWidth)))) Then
  Begin
    L := FSelectRectWidth;
    t := FSelectRectWidth;
    w := Self.Width - (2 * FSelectRectWidth);
    h := Self.Height - (2 * FSelectRectWidth);
    PnlImage.SetBounds(L, t, w, h);
  End;

End;

Destructor TMag4VGear.Destroy;
Var
  tmrD, DInt, FDiDa, Pid: Boolean;
  s: String;
Begin
  tmrD := (TmrDrawLetters <> Nil);
  DInt := (DisplayInterface <> Nil);
  FDiDa := (FDicomData <> Nil);
  Pid := (PI_ptrData <> Nil);

  Try // WE GET EXCEPTIONS HERE....
    If TmrDrawLetters <> Nil Then TmrDrawLetters.Free;
    If DisplayInterface <> Nil Then
    Begin
      DisplayInterface.Free();
      DisplayInterface := Nil;
    End;
    If FDicomData <> Nil Then
      FreeAndNil(FDicomData);
    If PI_ptrData <> Nil Then
      FreeAndNil(PI_ptrData);
  Except
    On e: Exception Do
    Begin // INVALID POINTER OPERATION
      s := 'tmrDrawLetters ' + Magbooltostr(tmrd) + #13 +
        'DisplayInterface ' + Magbooltostr(Dint) + #13 +
        'FDicomData ' + Magbooltostr(FDiDa) + #13 +
        'PI_ptrData ' + Magbooltostr(Pid);

      Showmessage(s);
  //
    End;
  End;
  Inherited;
  //
   { DONE -oGarrett -cConversion : Destroy the GEAR1 component here }
   { CAUSES the Display to Blink.  Also ... will need to recreate anyway.
     change to a Pool of Image Gear Components. Which are contiually reused.
     and all are destroyed when Application terminates.  See Destroy_p }
End;

{
function TMag4VGear.determineGearToUse(FileExtension : String) : TMagGearType;
begin
  result := GEAR_TYPE_IG14;
  if FileExtension = '.756' then result := GEAR_TYPE_IG99;
  //result := GEAR_TYPE_IG99;
end;
}

Function TMag4VGear.CanUseForFile(FileExtension: String): Boolean;
Var
  GearToUse: TMagGearType;
Begin
  Result := cmag4VGearManager.CanUseForFile(DisplayInterface, FileExtension);
End;

Function TMag4VGear.LoadDICOMData(TxtFilename: String; Mag2005SSN, Mag2005ICN: String;
  OnlyUseTGA: Boolean = False): Boolean;
Begin
//  Txtfilename := ChangeFileExt(FCurrentImage, '.txt');
  If (OnlyUseTGA) Or Not (MagDICOMHeader In DisplayInterface.ComponentFunctions) Then
  Begin
    LoadTGAText(TxtFilename);
    // always load Txt file
  End
  Else
  Begin
    // should probably call some function of Display Interface to determine if
    // it has a DICOM Header (could be state of image or something that asks Accusoft)
    If DisplayInterface.IsDICOMHeaderInImageFormat() Then
//    if uppercase(ExtractFileExt(FCurrentImage)) = '.DCM' then
    Begin
      If DisplayInterface.LoadDICOMData(FDicomData) Then
      Begin
        // if got header information from DICOM header, still use text file to get the patient SSN
        //LogMsg('s', 'Got Header from DICOM file, getting patient SSN from TXT file');
        MagLogger.LogMsg('s', 'Got Header from DICOM file, getting patient SSN from TXT file'); {JK 10/5/2009 - Maggmsgu refactoring}
        LoadPatientSSNFromTxtFile(TxtFilename);
      End
      Else // if could not load header from DICOM file, then try using TGA text file
      Begin
        //LogMsg('s', 'Unable to load DICOM header using Component Interface toolkit, attempt to use TXT file');
        MagLogger.LogMsg('s', 'Unable to load DICOM header using Component Interface toolkit, attempt to use TXT file'); {JK 10/5/2009 - Maggmsgu refactoring}
        LoadTGAText(TxtFilename);
      End;
    End
    Else
    Begin
      LoadTGAText(TxtFilename);
    End;
  End;

  If (DisplayInterface.GetHeight < FDicomData.Rows) Or (DisplayInterface.GetBitsPerPixel < FDicomData.Bits) Then
  Begin
    FReducedQuality := True;
    FDownsampledImage := True;
  End;

  // if the image is not diagnostic then check to see if there is one available.
  // how do we determine if there should be a diagnostic image but there isn't one? (from dod)
  If Not FIsDiagnosticImage Then
  Begin
    If (PI_ptrData.BigFile <> '') And (MagPiece(PI_ptrData.BigFile, '~', 1) <> '-1') Then
    Begin
      FReducedQuality := True;
    End;
  End;

  If FDicomData.Modality = 'CT' Then
  Begin
     // JMW P72 12/4/07 - check for secondary capture
    If Pos('1.2.840.10008.5.1.4.1.1.7', FDicomData.SOPClassUid) = 1 Then
      FCTPresetsEnabled := False
    Else
      FCTPresetsEnabled := True;
  End
  Else
    FCTPresetsEnabled := False;

     {
  if fdicomdata.PixelSpace1 <= 0 then
    FMeasurementsEnabled := false
  else
  begin
    FMeasurementsEnabled := DisplayInterface.isFormatSupportMeasurements();
  end;
  }
  FMeasurementsEnabled := DisplayInterface.IsFormatSupportMeasurements(FDicomData);
  //LogMsg('s','Photometric=[' + FDicomData.photometric + ']', MagLogDebug);
  MagLogger.LogMsg('s', 'Photometric=[' + FDicomData.Photometric + ']', MagLogDebug); {JK 10/5/2009 - Maggmsgu refactoring}
  If (Uppercase(FDicomData.Photometric) = 'MONOCHROME1') Or (Uppercase(FDicomData.Photometric) = 'MONOCHROME2') Then
  Begin
    DisplayInterface.ComponentFunctions := DisplayInterface.ComponentFunctions + [MagWinLev];
  End
  // do check to see if this is an image that might have header info ( DCM, TGA, ...)
  Else
    If FDicomData.Photometric = '' Then
    Begin
      If (DisplayInterface.GetBitsPerPixel <> 24) Then
      Begin
    // be sure image format supports window leveling (not jpg, tiff, bmp, etc) and the modality is not ECG (is this right?)
    // a JPG/TIF can be grayscale and can be win/lev, how do we handle this?
        If (DisplayInterface.IsFormatSupportWinLev) And (FDicomData.Modality <> 'ECG') Then
          DisplayInterface.ComponentFunctions := DisplayInterface.ComponentFunctions + [MagWinLev];
      End;
    End;

  Result := True;
  // JMW 5/12/08 P72 - only do this check if not viewing a DOD image
  If PI_ptrData.PlaceIEN <> '200' Then
  Begin
    // JMW 5/12/08 P72 - if there is an ICN, use that for comparison
    // If there is no ICN then use SSN, if both are missing, then allow the image

    // JMW 6/2/2009 P93T8 - check first for the ICN, if that is not valid then
    // try to use the SSN
    If (IsPatientICNValid(Mag2005ICN)) And (IsPatientICNValid(FDicomData.PatientICN)) Then
    Begin
      Result := CheckICN(Mag2005ICN, FDicomData.PatientICN);
      If (Not Result) And (Mag2005SSN <> '') Then
        Result := CheckSSN(Mag2005SSN, FDicomData.PtID);
    End
    // if ICN is not valid, rely on the SSN value
    Else
      If Mag2005SSN <> '' Then
        Result := CheckSSN(Mag2005SSN, FDicomData.PtID);
  End;
End;

{
  Checks to see if the ICN value from the database is valid and can be used.
  If a patient does not have an ICN, then the ICN value from VistA starts with
  a -1 value indicating an error.
}

Function TMag4VGear.IsPatientICNValid(ICN: String): Boolean;
Var
  OrdValue: Integer;
Begin
  Result := True;
  If ICN = '' Then
  Begin
    Result := False;
    Exit;
  End;
  If (Pos('-1', ICN) > 0) Then
  Begin
    Result := False;
    Exit;
  End;
  // JMW 9/18/08 - if the ICN starts with a letter, then its invalid
  // it might not actually be an ICN but could be a Short ID (DS1234)
  OrdValue := Ord(ICN[1]);
  If (OrdValue < 48) Or (OrdValue > 57) Then
  Begin
    Result := False;
    Exit;
  End;
End;

Function TMag4VGear.CheckICN(ICN2005, HeaderICN: String): Boolean;
Var
  I2005, H2005: String;
  Loc: Integer;
Begin
  Result := True;
  If (ICN2005 = '') Or (HeaderICN = '') Then
    Exit;
  // don't compare with the checksum value (in case it isn't there)
  I2005 := MagPiece(ICN2005, 'V', 1);
  H2005 := MagPiece(HeaderICN, 'V', 1);
  Result := (I2005 = H2005);
End;

Function TMag4VGear.CheckSSN(SSN2005, DICOMSSN: String): Boolean;
Var
  SSN2005x: String;
  SSNTXT, SSNTXTx: String;
Begin
  Result := True;
  SSNTXT := DICOMSSN;
  If Length(SSNTXT) < 1 Then Exit;
  If Length(SSN2005) > 9 Then
  Begin
    SSN2005x := MagPiece(SSN2005, '-', 1) + MagPiece(SSN2005, '-', 2) + MagPiece(SSN2005, '-', 3);
    SSN2005x := Copy(SSN2005x, 1, 9); {remove any characters appended to the end} {RED 4/21/02}
    SSN2005 := SSN2005x;
  End;
  If Length(SSNTXT) > 9 Then
  Begin
    SSNTXTx := MagPiece(SSNTXT, '-', 1) + MagPiece(SSNTXT, '-', 2) + MagPiece(SSNTXT, '-', 3);
    SSNTXTx := Copy(SSNTXTx, 1, 9); {remove any characters appended to the end}
    SSNTXT := SSNTXTx;
  End;
  If SSNTXT = SSN2005 Then Exit;
{TODO: Add the warning message for SSN Mismatch, allow the user to cancel.}
{   Log the users action to LOG FILE and MAIL Message to G.MAG SERVER}

  Result := False; {failure flag}
End;

Procedure TMag4VGear.LoadPatientSSNFromTxtFile(TxtFile: String);
Var
  LoadFile: Textfile;
  s: String;
  CurrentFile: String[130];
  Delim, LengthS: Integer;
  Desc, HdrData: String;
  Temp: String;
  Index: Integer;
  Data: Real;
  TXTfiletype: String;
  Delimiter: String;
  Tempsamples: Integer;
Begin

  If FileExists(TxtFile) Then
  Begin
    AssignFile(LoadFile, TxtFile);
    Reset(LoadFile);
    Tempsamples := 1;
    Try
      ReadLn(LoadFile, s);
      If Pos('Consult Information', s) > 0 Then
      Begin
        TXTfiletype := 'CLINICAL';
        Delimiter := ': ';
      End;
      If Pos('$$BEGIN DATA1', s) > 0 Then
      Begin
        TXTfiletype := 'DICOM';
        Delimiter := '=';
      End;
      Repeat
        ReadLn(LoadFile, s);
        Delim := Pos(Delimiter, s);
        Desc := Copy(s, 1, Delim - 1);
        LengthS := Length(s);
        HdrData := Copy(s, Delim + 1 + (Length(Delimiter) - 1), LengthS);
        If ((Pos('<unknown>', HdrData) = 0) And (Pos('<UNKNOWN>', HdrData) = 0)) Then
        Begin
          Try {protect against bad data}
            If Desc = 'Pt Name' Then Dicomdata.PtName := HdrData; {CLINICAL}
            If Desc = 'Pt ID' Then Dicomdata.PtID := HdrData; {CLINICAL}
            If Desc = 'PATIENTS_NAME' Then Dicomdata.PtName := HdrData; {DICOM}
            If Desc = 'PATIENTS_ID' Then Dicomdata.PtID := HdrData; {DICOM}
            If Desc = 'INTEGRATION_CONTROL_NUMBER' Then Dicomdata.PatientICN := Trim(HdrData); {JMW 5/8/08}

          Except
    {if an element can't be read, continue to the next}
          End; {end try}
        End; {end if doesn't contain ,<unknown>}
      Until Eof(LoadFile)
    Finally
      CloseFile(LoadFile);
    End; {end try..finally}
  End;
End;

Procedure TMag4VGear.LoadTGAText(TxtFile: String);
Var
  LoadFile: Textfile;
  s: String;
  CurrentFile: String[130];
  Delim, LengthS: Integer;
  Desc, HdrData: String;
  Temp: String;
  Index: Integer;
  Data: Real;
  TXTfiletype: String;
  Delimiter: String;
  Tempsamples: Integer;
Begin

  If FileExists(TxtFile) Then
  Begin
    Dicomdata.DicomDataSource := TxtFile;
    AssignFile(LoadFile, TxtFile);
    Reset(LoadFile);
    Tempsamples := 1;
    Try
      ReadLn(LoadFile, s);
      If Pos('Consult Information', s) > 0 Then
      Begin
        TXTfiletype := 'CLINICAL';
        Delimiter := ': ';
      End;
      If Pos('$$BEGIN DATA1', s) > 0 Then
      Begin
        TXTfiletype := 'DICOM';
        Delimiter := '=';
      End;
      Repeat
        ReadLn(LoadFile, s);
        Delim := Pos(Delimiter, s);
        Desc := Copy(s, 1, Delim - 1);
        LengthS := Length(s);
        HdrData := Copy(s, Delim + 1 + (Length(Delimiter) - 1), LengthS);
        If ((Pos('<unknown>', HdrData) = 0) And (Pos('<UNKNOWN>', HdrData) = 0)) Then
        Begin
          Try {protect against bad data}
            If Desc = 'Pt Name' Then Dicomdata.PtName := HdrData; {CLINICAL}
            If Desc = 'Pt ID' Then Dicomdata.PtID := HdrData; {CLINICAL}
            If Desc = 'PATIENTS_NAME' Then Dicomdata.PtName := HdrData; {DICOM}
            If Desc = 'PATIENTS_ID' Then Dicomdata.PtID := HdrData; {DICOM}
            If Desc = 'MODALITY' Then Dicomdata.Modality := HdrData;
            If Desc = 'PIXEL_SPACING(1)' Then Dicomdata.PixelSpace1 := Strtofloat(HdrData);
            If Desc = 'PIXEL_SPACING(2)' Then
            Begin
              Dicomdata.PixelSpace2 := Strtofloat(HdrData);
            End;
            If Desc = 'PIXEL_SPACING(3)' Then Dicomdata.PixelSpace3 := Strtofloat(HdrData);
            If Desc = 'HAUNSFIELD' Then Dicomdata.Haunsfield := Strtoint(HdrData);
            If Desc = 'SLICE_THICKNESS' Then Dicomdata.SliceThickness := Strtofloat(HdrData);
            If Desc = 'PATIENT_POSITION' Then Dicomdata.Pt_Pos := HdrData;
            If Desc = 'LATERALITY' Then Dicomdata.Laterality := HdrData;
            If Desc = 'STUDY_ID' Then
            Begin
              Dicomdata.STUDY_ID := HdrData;
            End;
            If Desc = 'SLICE_LOCATION' Then
            Begin
              If Pos('<unknown>', s) = 0 Then Dicomdata.SliceLoc := Strtofloat(HdrData);
            End;
            If Desc = 'RESCALE_INTERCEPT' Then Dicomdata.Rescale_Int := Strtofloat(HdrData);
            If Desc = 'RESCALE_SLOPE' Then Dicomdata.Rescale_Slope := Strtofloat(HdrData);
            If Desc = 'ROWS' Then Dicomdata.Rows := Strtoint(HdrData);
            If Desc = 'COLUMNS' Then Dicomdata.Columns := Strtoint(HdrData);
            If Desc = 'SERIES_NUMBER' Then Dicomdata.Seriesno := Strtofloat(HdrData);
            If Desc = 'IMAGE_NUMBER' Then Dicomdata.Imageno := HdrData;
            If Desc = 'BITS_STORED' Then Dicomdata.Bits := Round(Strtofloat(HdrData)); {RED 10/24/01}
            If Desc = 'INSTANCE_NUMBER' Then Dicomdata.Imageno := HdrData;
            If Desc = 'CONTRAST_BOLUS_AGENT' Then Dicomdata.Contrast := HdrData;
            If Desc = 'PHOTOMETRIC_INTERPRETATION' Then Dicomdata.Photometric := Trim(HdrData); {RED 03/21/04}
            If Desc = 'INTEGRATION_CONTROL_NUMBER' Then Dicomdata.PatientICN := Trim(HdrData); {JMW 5/8/08}
            If Pos('0028,1050|Window Center', s) > 0 Then
            Begin
              Temp := MagPiece(s, '|1,1|', 2);
              Dicomdata.Window_Center := Trunc(Strtofloat(MagPiece(s, '|', 4)));
            End;
            If Pos('0028,1051|Window Width', s) > 0 Then
            Begin
              Dicomdata.Window_Width := Trunc(Strtofloat(MagPiece(s, '|', 4)));
            End;
            If Pos('0028,0106|Smallest Image Pixel Value', s) > 0 Then {RED 7/25/02}
            Begin
              Dicomdata.Smallest_PixelVal := Trunc(Strtofloat(MagPiece(s, '|', 4)));
            End;
            If Pos('0028,0107|Largest Image Pixel Value', s) > 0 Then {RED 7/25/02}
            Begin
              Dicomdata.Largest_PixelVal := Trunc(Strtofloat(MagPiece(s, '|', 4)));
            End;
            If Pos('0020,0020|Patient Orientation', s) > 0 Then
            Begin
              If Pos('|1,1|', s) > 0 Then Dicomdata.PatOr1 := MagPiece(s, '|', 4);
              If Pos('|2,1|', s) > 0 Then Dicomdata.PatOr2 := MagPiece(s, '|', 4);
            End;
            If Pos('0020,0037|Image Orientation (Patient)', s) > 0 Then
            Begin
              Data := Strtofloat(MagPiece(s, '|', 4));
              Temp := MagPiece(s, '|', 3);
              Index := Strtoint(MagPiece(Temp, ',', 1));
              Dicomdata.ImageOr[Index] := Data;
            End; {end image orientation}
            If Pos('0018,1030|Protocol Name', s) > 0 Then
            Begin
              Temp := MagPiece(s, '|', 4);
              Dicomdata.Protocol := Temp;
            End;
            If Pos('0020,1040|Position Reference Indicator', s) > 0 Then
            Begin
              Temp := MagPiece(s, '|', 4);
              Dicomdata.Pos_Ref_Indicator := Temp;
            End;
            If Pos('0028,0002|Samples per Pixel', s) > 0 Then {RED 11-13-03}
            Begin {RED 11-13-03}
              Tempsamples := Strtoint(MagPiece(s, '|', 4)); {RED 11-13-03}
              Dicomdata.Bits := (Dicomdata.Bits * Tempsamples); {RED 11-13-03}
            End; {RED 11-13-03}
            If Pos('0008,1030|Study Description', s) > 0 Then {RED 11-13-03}
            Begin {RED 11-13-03}
              Temp := MagPiece(s, '^', 4); {RED 3-21-04}
              Dicomdata.Studydesc := Temp;
            End;
            If Pos('0008,103E|Series Description', s) > 0 Then // JMW Patch 72 2/6/2007
            Begin
              Temp := MagPiece(s, '|', 4);
              Dicomdata.SeriesDescription := Temp;
            End;
            If Pos('0008,2111|Derivation Description', s) > 0 Then
            Begin
              If Pos('Non-reversible compressed image', s) > 0 Then
              Begin
                Temp := MagPiece(s, '|', 4);
         // don't set ADICOMRec[winnum].Warning := 1 because this indicates FullRes option to be available
                Dicomdata.Warning := 2; {if GE PACS irreversible compression has been used}
              End;
            End;

     // JMW 8/5/2009 P93T11 - look for the DICOM header key value instead
     // of specific string (might contain unimportant characters)
     // fixes remedy ticket #332548
            If Pos('0018,1164', s) > 0 Then
            Begin
              If Pos('1,1', MagPiece(s, '|', 3)) > 0 Then
              Begin
                Temp := MagPiece(s, '|', 4);
                Dicomdata.ImagerPixelSpace1 := Strtofloat(Temp);
              End;
              If Pos('2,1', MagPiece(s, '|', 3)) > 0 Then
              Begin
                Temp := MagPiece(s, '|', 4);
                Dicomdata.ImagerPixelSpace2 := Strtofloat(Temp);
              End;
            End;
            If Pos('0018,1110|Distance Source to Detector', s) > 0 Then
            Begin
              Temp := MagPiece(s, '|', 4);
              Dicomdata.DistanceSourceToDetector := Strtofloat(Temp);
            End;
            If Pos('0018,1111|Distance Source to Patient', s) > 0 Then
            Begin
              Temp := MagPiece(s, '|', 4);
              Dicomdata.DistancePatientToDetector := Strtofloat(Temp);
            End;
            If Pos('0018,1114|Magnification Factor', s) > 0 Then
            Begin
              Temp := MagPiece(s, '|', 4);
              Dicomdata.MagnificationFactor := Strtofloat(Temp);
            End;
            If Pos('0008,0016|SOP Class UID', s) > 0 Then
            Begin
              Temp := MagPiece(s, '|', 4);
              Dicomdata.SOPClassUid := Temp;
            End;

          Except
    {if an element can't be read, continue to the next}
          End; {end try}
        End; {end if doesn't contain ,<unknown>}
      Until Eof(LoadFile)
    Finally
      CloseFile(LoadFile);
  // JMW 2/3/2007 P72
  // the haunsfield and rescale intercept should only be used for CT images
      If Uppercase(FDicomData.Modality) <> 'CT' Then
      Begin
        FDicomData.Haunsfield := 0;
        FDicomData.Rescale_Int := 0.0;
      End;
//      end; {end try..finally}  {RED 03/17/03}

    End; {end try..finally}
  End
  Else
  Begin
    Dicomdata.DicomDataSource := 'DOES NOT EXIST';
  End;

End;

Procedure Register;
Begin
  RegisterComponents('Imaging', [TMag4VGear]);
End;

Function TMag4VGear.IsHandledType(IObj: TImageData): Boolean;
Begin
  Result := True;
  Case IObj.ImgType Of
    21: {VIDEO Type}
      Result := False;
    101: {HTML}
      Result := False;
    102: {Word}
      Result := False;
    103: {TEXT }
      Result := False;
    105: {RichTEXT }
      Result := False;
    106: {AUDIO }
      Result := False;
  End;
End;

Procedure TMag4VGear.LoadTheImage(Imagefile: String; DiagnosticImage: Boolean = False);

Begin
        {       MagOpenSecurity is made before this call, by Mag4Viewer or
                other callers.}
  If TmrDrawLetters <> Nil Then TmrDrawLetters.Enabled := False;
  FOrientationLabelAnchor := akLeft;
  If FOrientationLabel <> Nil Then
  Begin
    FOrientationLabel.Visible := False;
    SetOrientationLabelPosition(akLeft);
  End;
  FIsDiagnosticImage := DiagnosticImage;
  FDicomData.ClearFields();

  DisplayInterface.LoadImage(Imagefile);
  ImageDescriptionUpdate;
  FCurrentImage := Imagefile;
  FReducedQuality := False;
  FDownsampledImage := False;
  // not sure we want this here - it will always make the pan tool used after loading an image
 //gek 93 Stop Automatic Mouse Pan    DisplayInterface.MousePan();

  // if image is not for radiology, ensure window/level is off (for 1 bit multi-page images (TIFF))
  If (ViewStyle <> MagGearViewRadiology) Then
  Begin
    DisplayInterface.DisableWindowLevel();
  End;
  // if the component is for radiology or the full res viewer, then enable
  // the pan window options
  If (FViewStyle = MagGearViewRadiology) Or (FViewStyle = MagGearViewFull) Then
  Begin
    DisplayInterface.ComponentFunctions := DisplayInterface.ComponentFunctions + [MagPanWindow];
  End;
  FModINV := False;
  FModFLIP := False;
  FModROT := 0;
  FImageModified := False;

  FModFlipHoriz := False;
  FModFlipVert := False;
  FModRotateDeg := 0;
  FModFlipRotDeg := 0;
  FModIsFront := True;

  SetBackgroundColor();
End;

Procedure TMag4VGear.LoadTheImage(IObj: TImageData; Abs: Boolean = False; DiagnosticImage: Boolean = False);
Var
  s: String;
Begin
  If Abs Then
    s := IObj.AFile
  Else
    s := IObj.FFile;
  LoadTheImage(s, DiagnosticImage);
  (*
  DisplayInterface.LoadImage(s);
  {
  if Iobj.ImgType = 15
    then
      begin
        Gear1.LoadDocument := s;
        DeSkewImage;
      end
  else magthreadedimageloader.LoadImage(s, gear1, false);// Gear1.LoadImage := s;
  Gear1.Redraw := true;
  }
  ImageDescriptionUpdate;
  FCurrentImage := s;
  *)
{ TODO -cGearError:
ERROR Checking when loading an Image.  look at Capture, we had
SaveGear, LoadGear,  if ErrorInGear procedures and functions.
Gear1.DebugLevel := 2  See Capture, it implements this }
End;

Procedure TMag4VGear.InitDrawLettersTimer;
Begin
  TmrDrawLetters := TTimer.Create(Self);
  TmrDrawLetters.Enabled := False;
  TmrDrawLetters.Interval := 1500;
  TmrDrawLetters.OnTimer := TmrDrawLettersTimer;

End;

Procedure TMag4VGear.TmrDrawLettersTimer(Sender: Tobject);
Begin
  TmrDrawLetters.Enabled := False;
  DrawRadLettersExecute();
End;

Procedure TMag4VGear.DrawRadLetters();
Begin
  If TmrDrawLetters = Nil Then InitDrawLettersTimer;
  TmrDrawLetters.Enabled := True;
End;

Procedure TMag4VGear.DrawRadLettersExecute();
Var
  CosX, CosY, CosZ: Real;
  Marker: Array[1..4] Of String[1];
  a: Array[1..4] Of String[1];
  i: Integer;
  Plane: String;
  Wth, Ht, bpp: Longint;
  Scalefactor: Real;
  Orient: String;
  Size: Integer;
Begin
  // check to see if labels are enabled
  Try

    For i := 1 To 4 Do
    Begin
      Marker[i] := '';
    End;
    If (FDicomData.Modality = 'CT') Or (FDicomData.Modality = 'MR') Then
    Begin
      If FDicomData.ImageOr[1] < -1.0 Then Exit;

      For i := 0 To 1 Do
      Begin
        CosX := FDicomData.ImageOr[1 + (i * 3)];
        CosY := FDicomData.ImageOr[2 + (i * 3)];
        CosZ := FDicomData.ImageOr[3 + (i * 3)];
        Plane := 'TRANSVERSAL';
        If ((Abs(CosX) > Abs(CosY)) And (Abs(CosX) > Abs(CosZ))) Then
          Plane := 'CORONAL';
        If ((Abs(CosY) > Abs(CosX)) And (Abs(CosY) > Abs(CosZ))) Then
          Plane := 'SAGITAL';

        If Plane = 'CORONAL' Then
        Begin
          If (CosX > 0) Then
            Marker[(i * 2) + 1] := 'R'
          Else
            Marker[(i * 2) + 1] := 'L';
          If CosX > Cos(30) Then
          Begin
            If Abs(CosY) > Abs(CosZ) Then
            Begin
              If CosY > 0 Then
                Marker[(i * 2) + 2] := 'A'
              Else
                Marker[(i * 2) + 2] := 'P';
            End;
            If Abs(CosY) <= Abs(CosZ) Then
            Begin
              If (CosZ > 0) Then
                Marker[(i * 2) + 2] := 'H'
              Else
                Marker[(i * 2) + 2] := 'F';
            End;
          End;
        End { end of CORONAL}
        Else
          If Plane = 'SAGITAL' Then
          Begin
            If (CosY > 0) Then
              Marker[(i * 2) + 1] := 'A'
            Else
              Marker[(i * 2) + 1] := 'P';
            If (CosY > Cos(30)) Then
            Begin
              If (Abs(CosX) > Abs(CosZ)) Then
              Begin
                If CosX > 0 Then
                  Marker[(i * 2) + 2] := 'R'
                Else
                  Marker[(i * 2) + 2] := 'L';
              End;
              If Abs(CosX) <= Abs(CosZ) Then
              Begin
                If CosZ > 0 Then
                  Marker[(i * 2) + 2] := 'H'
                Else
                  Marker[(i * 2) + 2] := 'F';
              End;
            End;
          End { end of SAGITAL }
          Else
            If Plane = 'TRANSVERSAL' Then
            Begin
              If CosZ > 0 Then
                Marker[(i * 2) + 1] := 'H'
              Else
                Marker[(i * 2) + 1] := 'F';
              If CosZ > Cos(30) Then
              Begin
                If Abs(CosY) > Abs(CosX) Then
                Begin
                  If CosY > 0 Then
                    Marker[(i * 2) + 2] := 'A'
                  Else
                    Marker[(i * 2) + 2] := 'P';
                End;
                If Abs(CosY) <= Abs(CosX) Then
                Begin
                  If CosX > 0 Then
                    Marker[(i * 2) + 2] := 'R'
                  Else
                    Marker[(i * 2) + 2] := 'L';
                End;
              End;
            End; {if transversal}

      End; { for loop }

    {
    ht := DisplayInterface.getHeight();
    if ht > DisplayInterface.Height then
      ht := DisplayInterface.Height;
    size := ht;
    wth := DisplayInterface.getWidth();
    if  wth > size then
    size := wth;
    if DisplayInterface.Width < size then
      size := DisplayInterface.Width;
      }
      Ht := DisplayInterface.GetHeight();
      Size := Ht;
      Wth := DisplayInterface.GetWidth();
      If Wth > Size Then
        Size := Wth;

      bpp := DisplayInterface.GetBitsPerPixel();

      Scalefactor := 0.1; {window #1}
      If Size < 2500 Then
        Scalefactor := 2.0;
      If Size < 1051 Then
        Scalefactor := 2.0;
      If Size < 800 Then
        Scalefactor := 1.0;
      If Size < 513 Then
        Scalefactor := 1.0;
      If Size < 300 Then
        Scalefactor := 0.5;

      Scalefactor := Scalefactor * ((bpp / 4) / 2);
    // JMW 5/14/08 P72t22 - use orientation label instead of drawing the annotation
//    DisplayInterface.DrawCharacter(10, trunc(ht / 2), 100, 100, 100, marker[1], scalefactor);
      ShowOrientationLabel(Marker[1]);

  // draw the character
      Exit;
    End; { end of CT or MR }

    If FDicomData.PatOr1 = '<unknown>' Then
      Exit;
    If FDicomData.PatOr1 = '' Then
      Exit;
    a[1] := Copy(FDicomData.PatOr1, 1, 1);
    a[2] := Copy(FDicomData.PatOr1, 2, 1);
    a[3] := Copy(FDicomData.PatOr2, 1, 1);
    a[4] := Copy(FDicomData.PatOr2, 2, 1);
    For i := 1 To 4 Do
    Begin
      If a[i] = 'A' Then
        Marker[i] := 'P';
      If a[i] = 'H' Then
        Marker[i] := 'F';
      If a[i] = 'L' Then
        Marker[i] := 'R';
      If a[i] = 'P' Then
        Marker[i] := 'A';
      If a[i] = 'F' Then
        Marker[i] := 'H';
      If a[i] = 'R' Then
        Marker[i] := 'L';
    End;
    Ht := DisplayInterface.GetHeight();
    If Ht > DisplayInterface.Height Then
      Ht := DisplayInterface.Height;
    Size := Ht;
    Wth := DisplayInterface.GetWidth();
    If Wth > Size Then
      Size := Wth;
    If DisplayInterface.Width < Size Then
      Size := DisplayInterface.Width;
    Scalefactor := 0.1; {window #1}
    If Size < 2500 Then
      Scalefactor := 3.0;
    If Size < 1051 Then
      Scalefactor := 2.5;
    If Size < 800 Then
      Scalefactor := 1.5;
    If Size < 513 Then
      Scalefactor := 0.5; //1.0; {RED 10/04/04}
    If Size < 300 Then
      Scalefactor := 0.5;
      // JMW 5/14/08 P72t22 - use orientation label instead of drawing the annotation
//      DisplayInterface.DrawCharacter(10, trunc(ht / 2), 100, 100, 100, marker[1], scalefactor);
    ShowOrientationLabel(Marker[1]);
  Except
    On e: Exception Do
    Begin
      //LogMsg('s', 'Exception creating orientation label, ' + e.Message, MagLogError);
      MagLogger.LogMsg('s', 'Exception creating orientation label, ' + e.Message, MagLogERROR); {JK 10/5/2009 - Maggmsgu refactoring}
    End;
  End;
End;

Procedure TMag4VGear.SetBackgroundColor();
Begin
  Case FViewStyle Of
    MagGearViewAbs:
      Begin
        DisplayInterface.SetBackgroundColor(clWhite);
      //DisplayInterface.setBackgroundColor(clbtnface);
      End;
    MagGearViewImageListAbs:
      Begin
        DisplayInterface.SetBackgroundColor(clWhite);
      //DisplayInterface.setBackgroundColor(clGrayText);
      End;
    MagGearViewFull:
      Begin
        DisplayInterface.SetBackgroundColor(clGrayText);
      End;
    MagGearViewRadiology:
      Begin
        DisplayInterface.SetBackgroundColor(clBlack);
      End;
  End;
End;

Procedure TMag4VGear.BrightnessValue(Value: Integer);
Begin
// if this image does window/leveling, don't do brightness and contrast
  If (MagWinLev In DisplayInterface.ComponentFunctions) Then
    Exit;
  DisplayInterface.BrightnessValue(Value);
End;

Procedure TMag4VGear.ClearImage;
Begin
  DisplayInterface.ClearImage();
  {/117 lbImageStatus is an 117 addition }
  lbImageStatus.caption := '';
  LblImage.caption := '';
  LblImage.Hint := '';
  LblDescPage.caption := '';
  LblDescIndex.caption := '';
  PnlRadiology.caption := '';
  // JMW p72 7/17/2006
  // set the item to not selected (not highlighted)
  SetSelected(False);
  ImageLoaded := False;
  DisplayInterface.Hint := '';
End;

Procedure TMag4VGear.ContrastValue(Value: Integer);
Begin
// if this image does window/leveling, don't do brightness and contrast
  If (MagWinLev In DisplayInterface.ComponentFunctions) Then
    Exit;
  DisplayInterface.ContrastValue(Value);
End;

Procedure TMag4VGear.BrightnessContrastValue(Bright, Contrast: Integer; ApplyToRad: Boolean = False);
Var
  FUpdate: Boolean;
Begin
  // if this image does window/leveling, don't do brightness and contrast

  If (Not ApplyToRad) And (MagWinLev In DisplayInterface.ComponentFunctions) Then
//  if(MagWinLev in DisplayInterface.ComponentFunctions) then
    Exit;
  FUpdate := DisplayInterface.UpdatePageViewEnabled;
  DisplayInterface.SetUpdatePageView(False);
  DisplayInterface.BrightnessValue(Bright);
  DisplayInterface.ContrastValue(Contrast);
  DisplayInterface.SetUpdatePageView(FUpdate);
  If FUpdate Then
    DisplayInterface.UpdatePageView();
End;

{ values for nFitMethod parameter of IG_display_fit_method
const IG_DISPLAY_FIT_TO_WINDOW=0  ;
const IG_DISPLAY_FIT_TO_WIDTH=1;
const IG_DISPLAY_FIT_TO_HEIGHT=2  ;
const IG_DISPLAY_FIT_1_TO_1=3;       }

Procedure TMag4VGear.FitToWindow;
Begin
  DisplayInterface.FitToWindow();
End;

Procedure TMag4VGear.FitToHeight;
Begin
  DisplayInterface.FitToHeight();
End;

Procedure TMag4VGear.FitToWidth;
Begin
  DisplayInterface.FitToWidth();
End;

Procedure TMag4VGear.Fit1to1;
Begin
  DisplayInterface.Fit1to1();
End;

Procedure TMag4VGear.FlipHoriz;
Var
  CurLabelAnchor: TAnchorKind;
Begin
        {       a Value is kept for FModFlip to be used when Resetting the image
                we have to modify the value for FModRot (rotate value) also
                so that the reset function works.}
  FModFlipHoriz := Not FModFlipHoriz;
  FModROT := (FModROT Mod 4);
  Case FModROT Of
    0: FModROT := 1;
    1: FModROT := 0;
    2: FModROT := 3;
    3: FModROT := 2;
  End;
  FImageModified := True;
  DisplayInterface.FlipHoriz();
  FModFLIP := Not (FModFLIP);
  FModIsFront := Not (FModIsFront);
  If FModFlipRotDeg = 0 Then
    FModFlipRotDeg := 90
  Else
    If FModFlipRotDeg = 90 Then
      FModFlipRotDeg := 0
    Else
      If FModFlipRotDeg = 180 Then
        FModFlipRotDeg := 270
      Else
        If FModFlipRotDeg = 270 Then
          FModFlipRotDeg := 180;
  CurLabelAnchor := GetOrientationLabelAnchor;
  If CurLabelAnchor = akLeft Then
    SetOrientationLabelPosition(akRight)
  Else
    If CurLabelAnchor = akRight Then
      SetOrientationLabelPosition(akLeft);
End;

Procedure TMag4VGear.FlipVert;
        {       a Value is kept for FModFlip to be used when Resetting the image
                we have to modify the value for FModRot (rotate value) also
                so that the reset function works.}
Var
  CurLabelAnchor: TAnchorKind;
Begin
  FModFlipVert := Not FModFlipVert;
  FModROT := (FModROT Mod 4);
  Case FModROT Of
    0: FModROT := 3;
    1: FModROT := 2;
    2: FModROT := 1;
    3: FModROT := 0;
  End;
  FImageModified := True;
  DisplayInterface.FlipVert();
  FModFLIP := Not (FModFLIP);

  FModIsFront := Not (FModIsFront);
  If FModFlipRotDeg = 0 Then
    FModFlipRotDeg := 270
  Else
    If FModFlipRotDeg = 90 Then
      FModFlipRotDeg := 180
    Else
      If FModFlipRotDeg = 180 Then
        FModFlipRotDeg := 90
      Else
        If FModFlipRotDeg = 270 Then
          FModFlipRotDeg := 0;
  CurLabelAnchor := GetOrientationLabelAnchor;
  If CurLabelAnchor = akTop Then
    SetOrientationLabelPosition(akBottom)
  Else
    If CurLabelAnchor = akBottom Then
      SetOrientationLabelPosition(akTop);
End;

Procedure TMag4VGear.Inverse;
Begin
  FImageModified := True;
  DisplayInterface.Inverse();
  FModINV := Not (FModINV);
End;

        {       Do both functions.}

Procedure TMag4VGear.DeSkewAndSmooth;
Begin
  DisplayInterface.DeSkewAndSmooth();
End;

Procedure TMag4VGear.DeSkewImage;
Begin
  DisplayInterface.DeSkewImage();
End;

Procedure TMag4VGear.SmoothImage;
Begin
  DisplayInterface.SmoothImage();
End;

Procedure TMag4VGear.MousePan;
Begin
  DisplayInterface.MousePan();
End;

Procedure TMag4VGear.MouseMagnify;
Begin
  DisplayInterface.MouseMagnify();
End;

Procedure TMag4VGear.RefreshImage;
Begin
  DisplayInterface.RefreshImage();
End;

Procedure TMag4VGear.Rotate(Deg: Integer);
Var
  Xdeg: Integer;
Begin
  Try
    FModRotateDeg := FModRotateDeg + Deg;
    If FModRotateDeg >= 360 Then
      FModRotateDeg := FModRotateDeg - 360;
    Xdeg := (Deg Div 90);
    DisplayInterface.Rotate(Xdeg);
    FModROT := FModROT + Xdeg;
    FImageModified := True;
    RotateOrientationLabel(Xdeg);

    If FModIsFront Then
    Begin
      FModFlipRotDeg := (FModFlipRotDeg + Deg) Mod 360;
    End
    Else
    Begin
      FModFlipRotDeg := (FModFlipRotDeg + Deg + 360) Mod 360;
    End;
  Except
    On e: Exception Do
    Begin
      //LogMsg('', 'Accusoft error during Rotate [' + e.message + '].', MagLogERROR);
      MagLogger.LogMsg('', 'Accusoft error during Rotate [' + e.Message + '].', MagLogERROR); {JK 10/5/2009 - Maggmsgu refactoring}
    End;
  End;
End;

        {       Set the Images 'Selected' State, and change display of image to
                show it is selected}

Procedure TMag4VGear.SetSelected(Value: Boolean);
Begin
  SetSelectionWidth;
  {     Only change settings if we are switching from Selected <-> Not Selected}
  If (FSelected <> Value) Then
  Begin
    FSelected := Value;
    If FSelected Then
    Begin
      Color := clhighlight; //clblue;
          {                 MagGearViewAbs, MagGearViewImageListAbs,
                            MagGearViewFull, MagGearViewStudy, MagGearViewRadiology}
      If FViewStyle = MagGearViewRadiology Then
        PnlRadiology.Color := clYellow
      Else
        If ((FViewStyle = MagGearViewAbs) Or (FViewStyle = MagGearViewFull)) Then
        Begin
          PnlDesc.Color := clActiveCaption;
          PnlDesc.Font.Color := clHighLightText;
              //lblImage.Color := clActiveCaption;
              //lblImage.Font.Color := clHighLightText;
        End;
    End
    Else {it is NOT selected}
    Begin
      If ((FViewStyle = MagGearViewAbs) Or (FViewStyle = MagGearViewFull)) Then
      Begin
        Self.ParentColor := True;
        PnlDesc.Color := clBtnFace; //clActiveCaption;
        PnlDesc.Font.Color := clWindowText; // Font.Color := clwText;
              //lblImage.ParentColor := true; //clActiveCaption;
              //lblImage.ParentFont := true;// Font.Color := clwText;
      End;
      If FViewStyle = MagGearViewRadiology Then
      Begin
        Self.ParentColor := True;
        PnlRadiology.Color := clBtnFace; // $00C2BDA0;
      End;
    End;
  End;
End;

Procedure TMag4VGear.SetPanWindow(Value: Boolean);
Begin
  If MagPanWindow In DisplayInterface.ComponentFunctions Then
  Begin
    FPanWindow := Value;
  End
  Else
  Begin
    // pan window not allowed, always make false
    FPanWindow := False;
  End;
  DisplayInterface.SetPanWindow(FPanWindow);
End;

Procedure TMag4VGear.Annotations();
Begin
  DisplayInterface.Annotations();
End;

Procedure TMag4VGear.SetZoomWindow(Value: Boolean);
Begin
  FZoomWindow := Value;
  DisplayInterface.SetZoomWindow(Value);
End;

Procedure TMag4VGear.MouseZoomRect;
Begin
  DisplayInterface.MouseZoomRect();
End;

Procedure TMag4VGear.AutoWinLevel;
Begin
  If (MagWinLev In DisplayInterface.ComponentFunctions) Then
    DisplayInterface.AutoWinLevel();
  // should this reset to hand pan if win lev not allowed?
End;

Procedure TMag4VGear.ZoomValue(Value: Integer);
Begin
  DisplayInterface.ZoomValue(Value);
End;

Function TMag4VGear.GetZoomValue(): Integer;
Begin
  Result := DisplayInterface.ZoomLevel;
End;

Procedure TMag4VGear.ReDrawImage;
Begin
  //if FAbstractImage then DisplayInterface.FitToWindow();
  If FViewStyle = MagGearViewAbs Then DisplayInterface.FitToWindow();
  DisplayInterface.ReDrawImage();
End;

Procedure TMag4VGear.LblImageMouseMove(Sender: Tobject; Shift: TShiftState;
  x, y: Integer);
Begin
  {   FIsSizable is always False for Patch 8.  This is for future patch.}
  If FIsSizeAble Then
    If (Ssleft In Shift) Then
    Begin
      Left := Left + x - FStartX;
      Top := Top + y - FStartY;
    End;
End;

Procedure TMag4VGear.FrameMouseMove(Sender: Tobject; Shift: TShiftState; x,
  y: Integer);
Var
  Movex, Movey: Boolean;
Begin
  {  FIsSizable is always False for Patch 8.  This is for future patch.}
  {   .....except .. We use this for the Resize Abstract function.  Allowing
                        the user to drag the sides of the image to a new size}
  If Not FIsSizeAble Then Exit;
  If (Shift = [Ssleft]) Then //10/15/03 test to stop the disappearing act.
  Begin
  { FresizeX and FresizeY are true if Dragging has started.  So we just
    change the width and height }
    If FresizeX Or FresizeY Then
    Begin
      If FresizeX Then Width := x;
      If FresizeY Then Height := y;
      Exit; // p8t45
    End;
  End;
  Movex := (x > (Width - 5));
  Movey := (y > (Height - 5));

  {  if cursor isn't near the right side or bottom, then exit}
  If Not (Movex Or Movey) Then
  Begin
    Cursor := crDefault;
    Exit;
  End;
  {  change the cursor to appropriate indicator}
  If (Movex And Movey) Then
    Cursor := crSizeNWSE
  Else
    If Movex Then
      Cursor := crsizeWE
    Else
      If Movey Then Cursor := crsizeNS;

  {  Only if Left mouse is pressed, we will start resizing}
  If (Ssleft In Shift) Then
  Begin
      {   Flag which direction we are resizing (or both)}
    If Movex Then FresizeX := True;
    If Movey Then FresizeY := True;
  End;

End;

Procedure TMag4VGear.FrameMouseUp(Sender: Tobject; Button: TMouseButton;
  Shift: TShiftState; x, y: Integer);
Begin
  { if any dragging was taking place. Set the flags to false}
  FresizeX := False;
  FresizeY := False;
End;

Procedure TMag4VGear.LblImageMouseDown(Sender: Tobject;
  Button: TMouseButton; Shift: TShiftState; x, y: Integer);
Begin
  {     if we are allowing resizing, we also allow moving the image, if the
        user is dragging the Caption }
  If Not FIsSizeAble Then
    If Assigned(OnImageMouseDown) Then OnImageMouseDown(Self, Button, Shift, x, y);
// pre p8t21
  FStartX := x;
  FStartY := y;
End;

Function TMag4VGear.IsImageAGroup: Boolean;
Begin
//p93   put method with the data  i.e..  IsImageGroup is now with the data.
  If Assigned(PI_ptrData) Then
    Result := PI_ptrData.IsImageGroup
  Else
    Result := False;

(*  if assigned(PI_PtrData) then
    begin
      if PI_PtrData.ImgType = 0 then result := false
      else result := (PI_PtrData.ImgType = 11); //((PI_PtrData.ImgType = 11) or (PI_ptrData.ImgType = 200));
      //p8t34 Groupof1
      //else result := (PI_PtrData.ImgType = 11) and (PI_PtrData.GroupCount > 1);
    end
  else result := false;
  *)
End;

        {Future. need to enable paging between images of a Group, like we
          do with Multipage images }

Function TMag4VGear.IsImageInGroup: Boolean;
Begin
  Result := False;
  Exit;
{TODO -c93: Need to have more properties of the ImageData, telling Group Parent.
        Then we can finish this function.}
  If Assigned(PI_ptrData) Then
  Begin

      //if PI_PtrData.ImgType = 0 then result := false
      //else result := (PI_PtrData.ImgType = 11); //((PI_PtrData.ImgType = 11) or (PI_ptrData.ImgType = 200));
  End
  Else
    Result := False;
End;

Procedure TMag4VGear.SetViewStyle(Value: TMagGearViewStyle);
Begin
  FViewStyle := Value;
  PnlHeader.Visible := False;
  PnlHeader.Align := altop;
  PnlHeader.caption := '';
  Case Value Of
    MagGearViewAbs:
      Begin
        Self.PnlClose.Visible := False; //93
        If IsImageAGroup Then
        Begin
        //TRy this 93
          PnlDesc.Align := alBottom; //93
          PnlDesc.BevelOuter := bvRaised; //93
          PnlImage.BorderStyle := bsSingle; //93

        //pnlHeader.Align := albottom;     //93
          PnlHeader.Visible := True; //93
          PnlHeader.caption := 'Group of ' + Inttostr(Self.PI_ptrData.GroupCount); //93

        //using the above two for 93
        //  for 93, try to stop using color 'black' for group
        //pnldesc.Color := clblack;      out in 93
        //pnldesc.Font.Color := clwhite;    out in 93
        End
        Else {is an Abs, but not a group}
        Begin
          PnlDesc.Align := alBottom;

          PnlDesc.BevelOuter := bvRaised;
          PnlImage.BorderStyle := bsSingle;
           //using the above two, for abstracts.
          PnlDesc.Color := clBtnFace;
          PnlDesc.Font.Color := clBlack;
        End;
        Self.ParentColor := True; //      Color := clbtnface;  //93
        DisplayInterface.SetBackgroundColor(clWhite);
        DisplayInterface.FitToWindow();
      End;
    MagGearViewImageListAbs:
      Begin
        Self.PnlClose.Visible := False; //93

        PnlDesc.Color := clBtnFace;
        PnlDesc.Font.Color := clBlack;
        Self.ParentColor := True; //   Color := clGrayText;
        DisplayInterface.SetBackgroundColor(clWhite);
        PnlDesc.Align := altop;
        LblImage.Wordwrap := False;
      // JMW 5/12/08 p72 - Make sure abstract fits to the window for the image list viewer
        DisplayInterface.FitToWindow();
      End;
    MagGearViewFull:
      Begin
        PnlDesc.Color := clBtnFace;
        PnlDesc.Font.Color := clBlack;
        Self.ParentColor := True; //Color := clGrayText;
      //DisplayInterface.setBackgroundColor(clWhite);
        DisplayInterface.SetBackgroundColor(clGrayText);
        PnlDesc.Align := altop;
        LblImage.Wordwrap := False;
      // JMW 8/29/2006 p72 Annotations are disabled in this patch
      {
      if not (MagAnnotation in DisplayInterface.ComponentFunctions) then
        btnAnnotations.Visible := false
      else
        btnAnnotations.Visible := true;
      }
        PnlRadiology.Visible := False;
        PnlDesc.Visible := True;

      // JMW 5/12/08 p72 - Make sure images are fit to width in the Full Res viewer
        DisplayInterface.FitToWidth();
      End;
    MagGearViewRadiology:
      Begin
        PnlRadiology.Visible := True;
        PnlDesc.Visible := False;
      // neither of these seem to do much... should set color to black
        DisplayInterface.SetBackgroundColor(clBlack);
      //Color := clBlack;   // this was causing a black outline on images that were not viewed yet
        Color := clGrayText;
        LblImage.Wordwrap := False;
      End;
  End;
End;

Procedure TMag4VGear.SetAbstractImage(Const Value: Boolean);
Begin
  FAbstractImage := Value;
  Exit;
  If FAbstractImage Then
  Begin
    If IsImageAGroup Then
    Begin
{$IFDEF PROTOTYPE}
             //Future: Stop using Color as the means of showing this is a group
      PnlDesc.BevelInner := bvLowered;
      PnlDesc.BevelOuter := bvRaised;
      PnlImage.BorderStyle := bsSingle;
{$ELSE}
      PnlDesc.Color := clBlack;
      PnlDesc.Font.Color := clWhite;
{$ENDIF}
    End
    Else {is an Abs, but not a group}
    Begin
{$IFDEF PROTOTYPE}
             //Future: Stop using Color as the means of showing this is a group
      PnlDesc.BevelInner := bvNone;
      PnlDesc.BevelOuter := bvNone;
      PnlImage.BorderStyle := bsSingle;
{$ELSE}
      PnlDesc.Color := clBtnFace;
      PnlDesc.Font.Color := clBlack;

{$ENDIF}
    End;
    Color := clBtnFace;
        // world's stupidest error

{
        Gear1.BackColor := clwhite;// TColor(13160660);//TColor($00C8D0D4);// TColor(clSystemColor or COLOR_BTNFACE);//15;//clWhite;
        Gear1.ScrollBars := false;
        Gear1.FitMethod := IG_DISPLAY_FIT_TO_WINDOW;
        }
    DisplayInterface.SetBackgroundColor(clWhite);
    DisplayInterface.FitToWindow();
    PnlDesc.Align := alBottom;
  End
  Else {NOT AN ABSTRACT}
  Begin
{$IFDEF PROTOTYPE}
        //Future : Stop using Color as the means of showing this is a group
    PnlDesc.BevelInner := bvNone;
    PnlDesc.BevelOuter := bvNone;
    PnlImage.BorderStyle := bsSingle;
{$ELSE}
    PnlDesc.Color := clBtnFace;
    PnlDesc.Font.Color := clBlack;
{$ENDIF}
    Color := clGrayText;
      //Gear1.BackColor := clWhite;
    DisplayInterface.SetBackgroundColor(clWhite);
    PnlDesc.Align := altop;
    LblImage.Wordwrap := False;
  End;
End;

Function TMag4VGear.GetPage: Integer;
Begin
  Result := DisplayInterface.GetPage();
End;

Function TMag4VGear.GetPageCount: Integer;
Begin
  Result := DisplayInterface.GetPageCount();
End;

Procedure TMag4VGear.SetPage(Const Value: Integer);
Begin
  DisplayInterface.SetPage(Value);
  DrawRadLetters(); // draw rad letters on page (since it clears with each page change), this could cause flashing?
End;

Procedure TMag4VGear.SetPageCount(Const Value: Integer);
Begin
  // Read Only,  do nothing.
End;

Function TMag4VGear.GetImageDescription: String;
Begin
  Result := LblImage.caption;
End;

procedure TMag4VGear.ImageDescriptionUpdate;
begin
lblDescPage.Caption := '';
 lbImageStatus.Caption := '';  //117
 { old code for pagecount
  if FAbstractImage and (listindex > -1) then
  begin
    lblDescIndex.caption := '#' + inttostr(listindex + 1) + ' ';
  end
  else if ((not FAbstractImage) and (pagecount > 1))
         then lblDescPage.Caption := 'pg ' + inttostr(page) + ' of ' + inttostr(pagecount);
       end old code  }
  if (FViewStyle = MagGearViewAbs) and (listindex > -1) then
  begin

{/117 lbImageStatus is an 117 addition 
     we need to have property of 'Show View Status' 0 = no 1 = all status's, 2= only non-viewable status's }
     {for now, we'll show or not show.}
        //      if self.PI_ptrData.IsViewAble    //117 test 1
        //      if self.PI_ptrData.MagViewStatus <> 0    //117 test 2 (need to change the '0')
        if self.FShowImageStatus
             then
               begin
               lbImageStatus.Caption := self.PI_ptrData.GetStatusDesc;
               lbImageStatus.Visible := true;
               end
             else
               begin
               lbImageStatus.Caption := '';
               lbImageStatus.Visible := false;
               end;
//117 end
    lblDescIndex.caption := '#' + inttostr(listindex + 1) + ' ';
  end
  else if ((FViewStyle <> MagGearViewAbs) and (pagecount > 1))
         then lblDescPage.Caption := 'pg ' + inttostr(page) + ' of ' + inttostr(pagecount);
end;

procedure TMag4VGear.SetImageDescription(const Value: string);
var
  WarningMsg : String;
  ImageHint : String;
begin
  // 117  testing
  IF (VALUE = '') or (copy(value,1,1)='<')  THEN
     BEGIN
     lbImageStatus.Caption := '';
     lbImageStatus.Visible := false;
     end
  else
  begin
  if value <> '' THEN
    begin
    //    if not self.PI_ptrData.IsViewAble
    //    if self.PI_ptrData.MagViewStatus <> 0
        if self.FShowImageStatus
           then
             begin
             //117  this worked, with a TImageList...  just didn't look good.
             //  self.ToolBar1.BringToFront;
             lbImageStatus.Caption := self.PI_ptrData.GetStatusDesc;
             lbImageStatus.Visible := true;
             end
           else
             begin
              lbImageStatus.Caption := '';
              lbImageStatus.Visible := false;
             end;
    end;
  end;
//END 117 testing
  lblimage.Caption := value;
  lblImage.Hint := value;
  DisplayInterface.ShowHint := false;
  if FViewStyle = MagGearViewRadiology then
  begin
    WarningMsg := '';
    If FReducedQuality Then
      WarningMsg := ' -- Reduced size, reference quality image';
    PnlRadiology.caption := Value + ' (' + Inttostr(DisplayInterface.GetBitsPerPixel) + 'x' + Inttostr(DisplayInterface.GetWidth) + 'x' + Inttostr(DisplayInterface.GetHeight) + ')' + WarningMsg;
    PnlRadiology.Hint := PnlRadiology.caption;
    RefreshRadiologyHint();
  End
  Else
    If FViewStyle = MagGearViewAbs Then
    Begin
    // JMW 10/14/2008 p72t27 - need to set the panel caption to the description
    // for 508 compliance so the reader can read a description of the image.
    // only doing this for abs images (not really sure if should do for others)
      PnlImage.caption := Value;

    End;

  {
  if FAbstractImage and (listindex > -1) then ImageDescriptionUpdate
  else if ((not FAbstractImage) and (pagecount > 1))
    then ImageDescriptionUpdate;
  }
  If (FViewStyle = MagGearViewAbs) And (ListIndex > -1) Then
    ImageDescriptionUpdate
  Else
    If ((FViewStyle <> MagGearViewAbs) And (PageCount > 1)) Then ImageDescriptionUpdate;
End;

Procedure TMag4VGear.RefreshRadiologyHint();
Var
  ImageHint: String;
Begin
  DisplayInterface.ShowHint := True;
  ImageHint := 'Ser: ' + FloatTostr(FDicomData.Seriesno) + ' ImgNo: ' + FDicomData.Imageno + ' ' + FDicomData.Modality + ' ' + FDicomData.Protocol;
  If FDicomData.SliceLoc <> 0 Then
  Begin
    ImageHint := ImageHint + ' Slice: ' + FloatTostr(FDicomData.SliceLoc);
  End;
  ImageHint := ImageHint + ' ' + FDicomData.Pos_Ref_Indicator + ' (' + Inttostr(DisplayInterface.GetBitsPerPixel) + 'x' + Inttostr(DisplayInterface.GetWidth) + 'x' +
    Inttostr(DisplayInterface.GetHeight) + ')';
  DisplayInterface.Hint := ImageHint;
End;

Procedure TMag4VGear.ResetImage;
Var
  aButton: TMouseButton;
  aShift: TShiftState;
  i: Integer;
  action: String;
  Deg: Integer;
Begin
  // in here can reset events that use tproxy

//  DisplayInterface.ResetImage();
(*

{TODO -cPonder: If we are Caching images.  it would be easier codewise to just ReLoad the
   image.  No chance of making a mistake.  But... Remote images not cached would
   take a long time to Reset... ?.  It would need some testing. }
  if FModFLIP then FlipHoriz;
  *)
  //exit;

  {  //JMW 4/29/2007 Patch 72
    Modified code to properly handle the reset of images when mixing flips and rotates
    The FModFlipHoriz, FModFlipVert, and FModRotateDeg variables are not really
    needed any more for reset, they can be removed when it is confirmed this new
    reset works properly and if those variables are not used elsewhere. }
  { //JMW 10/31/2008 - fixing problem with orientation label not adjusting when
      image is rotated/flipped
      set this to false to make sure it doesn't get moved around during flipping
      and rotating, it will be redrawn when DrawRadLetters() is caled }
  FOrientationLabelAnchor := akLeft;
  If FOrientationLabel <> Nil Then
  Begin
    FOrientationLabel.Visible := False;
    SetOrientationLabelPosition(akLeft);
  End;
  If Not FModIsFront Then
  Begin
    DisplayInterface.FlipHoriz();
    If FModFlipRotDeg = 0 Then
      FModFlipRotDeg := 90
    Else
      If FModFlipRotDeg = 90 Then
        FModFlipRotDeg := 0
      Else
        If FModFlipRotDeg = 180 Then
          FModFlipRotDeg := 270
        Else
          If FModFlipRotDeg = 270 Then
            FModFlipRotDeg := 180;
  End;
  If FModFlipRotDeg > 0 Then
  Begin
    FModFlipRotDeg := 360 - FModFlipRotDeg;
    Deg := (FModFlipRotDeg Div 90);
    DisplayInterface.Rotate(Deg);
  End;
  FModFlipRotDeg := 0;
  FModIsFront := True;

  If FModINV Then
    DisplayInterface.Inverse();
    {
  if FModFlipHoriz then
    DisplayInterface.FlipHoriz();
  if FModFlipVert then
    DisplayInterface.FlipVert();
  if FModRotateDeg > 0 then
  begin
    FModRotateDeg := 360 - FModRotateDeg;
    deg := (FModRotateDeg div 90);
    DisplayInterface.Rotate(deg);
  end;
  }

  FModINV := False;
  FModFlipHoriz := False;
  FModFlipVert := False;
  FModRotateDeg := 0;

  // this really doesn't seem to work right...
  {
  if ((FModROT mod 4) > 0) then DisplayInterface.Rotate(90 * (4 - (FModROT mod 4)));
  if FModINV then
    begin
      DisplayInterface.Inverse();
      FModINV := false;
    end;
  if FModFlip then FModFLIP := false;
  if FModRot <> 0 then FModROT := 0;
  }

  DisplayInterface.BrightnessValue(100);
  DisplayInterface.ContrastValue(100);

  FImageModified := False;
  DisplayInterface.FitToWindow();
  DisplayInterface.ReDrawImage();
  // clears annotations including the ruler marks
  If DisplayInterface.AnnotationComponent <> Nil Then
    DisplayInterface.AnnotationComponent.ClearAllAnnotations();
  // JMW 11/5/2008 - need to use the delay because when the application closes
  // the viewer clears.  calls reset image and then clear image.  need to
  // call DrawRadLetters which uses the delay before drawing the letter.
  // before drawing the letter the image metadata will be cleared so when
  // the letter is to be drawn, it will have no metadata and not try to draw
  DrawRadLetters(); // redraw the letters since they were just cleared
  //Gear1.fitmethod := IG_DISPLAY_FIT_TO_WINDOW;
  //Gear1.Redraw := true;

  // re-window level the image (if needed)
  WindowLevelEntireImage();

  // force toolbar to get updated image information
  // causes issues in abstract window - tries to open image in closed viewer
  // update of image state is now done in toolbar
  {
  if assigned(OnImageMouseDown) then
  begin
    abutton := mbleft;
    aShift := [ssleft];
    OnImageMouseDown(Self, abutton, ashift, 0, 0);
  end;
  }

  MouseReSet;
End;

Procedure TMag4VGear.SetShowImageOnly(Const Value: Boolean);
Begin
  FShowImageOnly := Value;
  PnlDesc.Visible := Not FShowImageOnly;
End;

Function TMag4VGear.GetState: TMagImageState;
Begin
  Result := TMagImageState.Create;
  Result.BrightnessValue := DisplayInterface.Brightness; // Fbrightnesspassed;
  Result.ContrastValue := DisplayInterface.Contrast;
  Result.ZoomValue := DisplayInterface.ZoomLevel;
  Result.Page := DisplayInterface.GetPage();
  Result.PageCount := DisplayInterface.GetPageCount();
        {       TMagImageMouse = set of (mcrPan, mcrDrag, mcrMagnify,
                                                mcrSelect, mcrPointer);{}
  Result.MouseAction := DisplayInterface.MouseAction;
        {  for Dicom images.  Not Used in application.  Only in Testing.}
  Result.ImageCount := 1;
  Result.ImageNumber := 1;
  Result.WinMaxValue := DisplayInterface.WindowValueMax; // 255; //self.PI_V4Data.win; ??
  Result.WinMinValue := DisplayInterface.WindowValueMin; // 0;
  Result.WinValue := DisplayInterface.WindowValue; // 125;

  // JMW P72 11/30/2007
  // don't apply the offset to the max and min value, not sure if that is correct
  // but testing without applying the offset for now
  Result.Levmaxvalue := DisplayInterface.LevelValueMax; // - FDicomData.getLevelOffset()  ;// 255;
  Result.Levminvalue := DisplayInterface.LevelValueMin; //FDicomData.getLevelOffset();// 0;
  If FDicomData <> Nil Then
  Begin
    If FDicomData.Modality = 'CT' Then
      Result.Levminvalue := -1024;
  End;
//  result.levminvalue := DisplayInterface.LevelValueMin -  1024;//FDicomData.getLevelOffset();// 0;

  Result.LevValue := DisplayInterface.LevelValue + FDicomData.GetLevelOffset(); // 125;
  Result.ReducedQuality := FReducedQuality;
  Result.MaxPixelValue := DisplayInterface.MaxPixelValue;

  Result.WinLevEnabled := False;
  Result.CTPresetsEnabled := FCTPresetsEnabled;
  If (ViewStyle = MagGearViewRadiology) Then
  Begin
    If (MagWinLev In DisplayInterface.ComponentFunctions) Then
      Result.WinLevEnabled := True;
      {
    // there are probably more rules used to determine if an image can use CT Presets
    if FDicomData.Modality = 'CT' then
      result.CTPresetsEnabled := true;
      }
  End;
  Result.MeasurementsEnabled := FMeasurementsEnabled;

  Result.AnnotationsDrawn := False;
  If MagAnnotation In DisplayInterface.ComponentFunctions Then
  Begin
    If
      (DisplayInterface.AnnotationComponent <> Nil)
      And
      (DisplayInterface.AnnotationComponent.GetMarkCount() > 0) Then
      Result.AnnotationsDrawn := True;
  End;
End;

Procedure TMag4VGear.PanWindowSettings(h, w, x, y: Integer);
Begin
  If MagPanWindow In DisplayInterface.ComponentFunctions Then
    DisplayInterface.PanWindowSettings(h, w, x, y);
End;

Procedure TMag4VGear.SetFontSize(Value: Integer);
Var
  Size: Integer;
Begin
  {  when font size changes, we change the Height of the Tpanel that shows desc
        SetDescFont does the height adjustment of pnlDesc}
  Size := Value;
  Case Size Of
    6:
      Begin
        SetDescFont('Small Fonts', Size, 25);
      End;
    7:
      Begin
        SetDescFont('Small Fonts', Size, 30);
      End;
    8, 9:
      Begin
        SetDescFont('Arial', Size, 35);
      End;
    10:
      Begin
        SetDescFont('Arial', Size, 40);
      End;
    11..99:
      Begin
        SetDescFont('Arial', Size, 45);
      End;
  End;
  //if not FAbstractImage then pnldesc.height := pnldesc.Height div 2;
  If (FViewStyle <> MagGearViewAbs) Then PnlDesc.Height := PnlDesc.Height Div 2;
  If (FViewStyle <> MagGearViewAbs) Then
    If (PnlDesc.Height < 20) Then PnlDesc.Height := 20;
End;

        {SetDescFont does the height adjustment of pnlDesc}

Procedure TMag4VGear.SetDescFont(Fname: String; FSize, FHeight: Integer);
Begin
  PnlDesc.Font.Name := Fname;
  PnlDesc.Font.Size := FSize;
  PnlDesc.Height := FHeight;
End;

Procedure TMag4VGear.MouseReSet;
Begin
  DisplayInterface.MouseReSet();
End;

Procedure TMag4VGear.LblImageDblClick(Sender: Tobject);
Begin
        {       send message to  viewer to maximize this image.
        {       MaximizeImage;  {}
  If Assigned(OnImageDoubleClickEvent) Then
  Begin
    OnImageDoubleClickEvent(Self);
  End;
   (*
  if (FParentViewer is Tmag4Viewer) then
    begin
//    IF Tmag4Viewer(FParentViewer).abswindow then exit;
    if (Tmag4Viewer(FParentViewer).ViewStyle = MagViewerViewAbs) then exit;
      (FParentViewer as TMag4Viewer).MaxImageToggle(Pi_PtrData);
    end;
    *)
End;

        {       Not implemented, reserved for Future functionality}

Procedure TMag4VGear.btn1to1Click(Sender: Tobject);
Begin
  Fit1to1;
End;

        {       Not implemented, reserved for Future functionality}

Procedure TMag4VGear.btnDownArrowClick(Sender: Tobject);
Begin
  If IsImageAGroup Then //GetNextGroupAbs;
End;

        {       For Multi-Page Images  (later , treat Groups like Multipage}

Procedure TMag4VGear.PageFirst;
Begin
  If IsImageInGroup Then
  Begin
      // GetFirstGroupImage(
  End
  Else
  Begin
    Page := 1;
    ImageDescriptionUpdate;
  End;
End;

        {       For Multi-Page Images  (later , treat Groups like Multipage}

Procedure TMag4VGear.PageLast;
Begin
  If IsImageInGroup Then
  Begin
      //
  End
  Else
  Begin
    Page := PageCount;
    ImageDescriptionUpdate;
  End;
End;

        {       For Multi-Page Images  (later , treat Groups like Multipage}

Procedure TMag4VGear.PageNext;
Begin
  If IsImageInGroup Then
  Begin
    GetNextGroupImage;
  End
  Else
  Begin
    Page := Page + 1;
    ImageDescriptionUpdate;
  End;
End;

        {       For Multi-Page Images  (later , treat Groups like Multipage}

Procedure TMag4VGear.PagePrev;
Begin
  If IsImageInGroup Then
  Begin
      //
  End
  Else
  Begin
    Page := Page - 1;
    ImageDescriptionUpdate;
  End;
End;

        {       Not Implemented }

Procedure TMag4VGear.GetNextGroupImage;
Begin
//  self.PI_ptrData.GroupIEN;
//  self.PI_ptrData.GroupIndex;
End;

        {       Not Implemented }

Procedure TMag4VGear.FrameStartDrag(Sender: Tobject; Var DragObject: TDragObject);
//var magdragobj : TmagdragImageObject;
Begin
//10-06 infortesting
//showmessage('FrameStartDrag');

  Exit;
// the dragobject worked, but didn't send an EndDrag, so the OnEndDrag was never fired.
  DragObject := TmagDragImageObject.Create;
  If FParentViewer <> Nil Then
  Begin
    TmagDragImageObject(DragObject).DraggedImages := TMag4Viewer(FParentViewer).GetSelectedImageList;
     //DragObject := magdragobj;
  End;
End;
        {       Not Implemented }

Procedure TMag4VGear.FrameEndDrag(Sender, Target: Tobject; x, y: Integer);
Begin
//showmessage('end drag FRame');

//tried but target isn't a mag4viewer, it's the scrlv (scrollbox)
//if target <> nil then
//  begin
//  Tmag4Viewer(target).imagestomagview(Tmag4Viewer(FParentViewer).GetSelectedImageList);
//  end;
  Fdragx := 0;
  Fdragy := 0;
End;
        {       Not Implemented }

Procedure TMag4VGear.WinLevValue(WinValue, LevValue: Integer);
Begin
  LevValue := LevValue - FDicomData.GetLevelOffset();
  If (MagWinLev In DisplayInterface.ComponentFunctions) And (ViewStyle = MagGearViewRadiology) Then
  Begin
    If (DisplayInterface.LevelValue <> LevValue) Or (DisplayInterface.WindowValue <> WinValue) Then
    Begin
      DisplayInterface.WinLevValue(WinValue, LevValue);
    End;
  End;

//MagApplyCTPreset(self, LevValue, WinValue);
End;

Procedure TMag4VGear.ShowHint(Value: Boolean);
Begin
  LblImage.ShowHint := Value;
End;

Procedure TMag4VGear.SetSettingMode(Mode: Integer);
Begin
  DisplayInterface.SetSettingMode(Mode);
End;

Procedure TMag4VGear.SetSettingValue(Value: Integer);
Begin
  DisplayInterface.SetSettingValue(Value);
End;

Procedure TMag4VGear.SetPrintSize(Value: Integer);
Begin
  DisplayInterface.SetPrintSize(Value);
End;

Procedure TMag4VGear.PrintImage(Handle: HDC);
Begin
  DisplayInterface.PrintImage(Handle);
End;

Procedure TMag4VGear.CopyToClipboard();
Begin
  If FViewStyle = MagGearViewRadiology Then
  Begin
    DisplayInterface.CopyToClipboardRadiology();
    If FShowLabels Then
      Self.DrawRadLettersExecute;
  End
  Else
    DisplayInterface.CopyToClipboard();
End;

Function TMag4VGear.GetBitsPerPixel(): Integer;
Begin
  Result := DisplayInterface.GetBitsPerPixel();
End;

Procedure TMag4VGear.GearToGear(Gearfr: TMag4VGear);
Var
  i: Integer;
  FHiGear: Integer;
  FHdib: Integer;
  Fiptr: Integer;
  FSize: Integer;
  Fsize2: Integer;

Begin
{no use working on fixing this.  Latest Version of Accusoft make this unneeded.}
{
FHIGEAR := Gearfr.Gear1.HiGear;
FHdib := Gearfr.Gear1.ImageHdib;
fiptr := Gearfr.Gear1.ImagePtr;
Fsize := Gearfr.Gear1.InstanceSize;
// Fsize didn't do it.
i := Gearfr.Gear1.ImageBitsPerPixel;
Fsize2 := Gearfr.Gear1.ImageWidth * Gearfr.Gear1.imageheight;
case i of
        1 : Fsize2 := (Fsize2 div 8)+ 4096; //2048;
        else Fsize2 := (Fsize2 * 3) + 2048;
  end;

 self.Gear1.MemSize := Fsize2;
self.Gear1.mempage := 0;
self.Gear1.MemLoad := Fiptr ;
  self.Gear1.AspectRatio := IG_ASPECT_MINDIMENSION;
self.Gear1.redraw := true;
}

End;

Procedure TMag4VGear.SetAutoRedraw(Value: Boolean);
Begin
  FAutoRedraw := Value;
  DisplayInterface.UpdatePageViewEnabled := Value;
End;

Procedure TMag4VGear.SetUpdateGUI(Value: Boolean);
Begin
  DisplayInterface.SetUpdateGUI(Value);
End;

Procedure TMag4VGear.SetOrientation(Orientation: TMagImageOrientation);
Begin
  DisplayInterface.SetOrientation(Orientation);
End;

Function TMag4VGear.GetImageHeight(): Integer;
Begin
  Result := DisplayInterface.GetHeight();
End;

Function TMag4VGear.GetImageWidth(): Integer;
Begin
  Result := DisplayInterface.GetWidth();
End;

Function TMag4VGear.IsSigned(): Boolean;
Begin
  Result := DisplayInterface.IsSigned();
End;

Procedure TMag4VGear.PromoteColor(ColorValue: TMagImagePromoteValue);
Begin
  DisplayInterface.PromoteColor(ColorValue);
End;

Function TMag4VGear.GetUnsavedChanges(): Boolean;
Begin
  Result := False;
  If AnnotationComponent = Nil Then Exit;
  Result := AnnotationComponent.HasBeenModified;
End;

Procedure TMag4VGear.OnImageMouseScrollUp(Sender: Tobject; Shift: TShiftState; MousePos: TPoint; Var Handled: Boolean);
Begin
  Handled := True;
  If Assigned(FImageMouseScrollUp) Then
    FImageMouseScrollUp(Self, Shift, MousePos, Handled);
End;

Procedure TMag4VGear.OnImageMouseScrollDown(Sender: Tobject; Shift: TShiftState; MousePos: TPoint; Var Handled: Boolean);
Begin
  Handled := True;
  If Assigned(FImageMouseScrollUp) Then
    FImageMouseScrollDown(Self, Shift, MousePos, Handled);
End;

Procedure TMag4VGear.LblStudyDetailsMouseDown(Sender: Tobject;
  Button: TMouseButton; Shift: TShiftState; x, y: Integer);
Begin
  {     if we are allowing resizing, we also allow moving the image, if the
        user is dragging the Caption }
  If Not FIsSizeAble Then
    If Assigned(OnImageMouseDown) Then OnImageMouseDown(Self, Button, Shift, x, y);
// pre p8t21
  FStartX := x;
  FStartY := y;
End;

Procedure TMag4VGear.OnImageMouseMove(Sender: Tobject; Button: TMouseButton; Shift: TShiftState; x, y: Integer);
Var
  DeltX: Integer;
  DeltY: Integer;
  Con, Bri: Integer;
  Win, Lev: Integer;
  Factor: Real;
  ConFactor, BriFactor: Real;
Begin

  If (FViewStyle = MagGearViewRadiology) And (Button = Mbright) Then
  Begin
    DeltX := x - FMouseMoveX;
    DeltY := y - FMouseMoveY;
    // check if to use window/level
    If (MagWinLev In DisplayInterface.ComponentFunctions) Then
    Begin
      Factor := 1;
      Case DisplayInterface.WindowValueMax Of {factor changes depending on the maxpixel value}
        0..255: Factor := 1;
        256..1023: Factor := 2;
        1024..4095: Factor := 3;
        4096..16384: Factor := 4;
        16385..32768: Factor := 32;
        32769..65599: Factor := 64;

//        4096..65599: factor := 4;
      End;
      Win := DisplayInterface.WindowValue + Round(DeltX * Factor);
      Lev := DisplayInterface.LevelValue + Round(DeltY * Factor);
      // JMW 7/24/08 p72t23 - check to make sure the user can't set a value
      // that is not in the proper range
      If Win > DisplayInterface.WindowValueMax Then
        Win := DisplayInterface.WindowValueMax;
      If Win < DisplayInterface.WindowValueMin Then
        Win := DisplayInterface.WindowValueMin;
      If Lev > DisplayInterface.LevelValueMax Then
        Lev := DisplayInterface.LevelValueMax;
      If Lev < DisplayInterface.LevelValueMin Then
        Lev := DisplayInterface.LevelValueMin;
      DisplayInterface.WinLevValue(Win, Lev);
      ImageWinLevChange(Self, Win, Lev);
    End
    Else // otherwise use brightness/contrast
    Begin
      If (DeltX = 0) And (DeltY = 0) Then
        Exit;
//      BriFactor := 0.6;
      BriFactor := 2.5;
      ConFactor := 0.4;
      Con := DisplayInterface.Contrast + Round(DeltY * ConFactor);
      Bri := DisplayInterface.Brightness + Round(DeltX * BriFactor);

      // JMW 4/6/09 - one method is better than 2
      DisplayInterface.BrightnessContrastValue(Bri, Con);

      // JMW 12/10/2009 - p94 - below line was causing if the user right
      // clicked mouse to adjust brightness with apply to all, wrong value was
      // passed to other image windows which prevented brightness adjustment
//      bri := trunc(bri / 10) + 90;
      ImageBriConChange(Self, Bri, Con);
    End;
    FMouseMoveX := x;
    FMouseMoveY := y;
    // not sure want to do this... will cause image to be selected which
    // updates toolbar values, but is this the right way to do that?
    If Assigned(OnImageClick) Then
      OnImageClick(Self, Self);

  End
  Else
  Begin
    FMouseMoveX := x;
    FMouseMoveY := y;
  End;

End;

Function TMag4VGear.GetFileFormat(): String;
Begin
  Result := DisplayInterface.GetFileFormat();
End;

Function TMag4VGear.GetCompression(): String;
Begin
  Result := DisplayInterface.GetCompression();
End;

Procedure TMag4VGear.WindowLevelEntireImage();
Var
  WinValue, LevValue: Integer;
  BitDepth: Integer;
Begin
  If (MagWinLev In DisplayInterface.ComponentFunctions) And (ViewStyle = MagGearViewRadiology) Then
  Begin
    If (Not FHistogramWindowLevel) And (FDicomData.Window_Width > 0) Then
    Begin
      WinValue := FDicomData.Window_Width;
      LevValue := FDicomData.Window_Center - FDicomData.GetLevelOffset(True);

      // JMW 8/27/08 - handle downsampled images
      // if the image is a downsampled image (not compressed)
      If FDownsampledImage Then
      Begin
        //LogMsg('s','Image is downsampled, converting w/l values [' +
        //  inttostr(WinValue) + '/' + inttostr(LevValue) + ']', MagLogINFO);
        MagLogger.LogMsg('s', 'Image is downsampled, converting w/l values [' +
          Inttostr(WinValue) + '/' + Inttostr(LevValue) + ']', MagLogINFO); {JK 10/5/2009 - Maggmsgu refactoring}
        BitDepth := DisplayInterface.GetBitsPerPixel;
        If BitDepth < FDicomData.Bits Then
        Begin
          //LogMsg('s','Bit depth of downsampled image is [' +
          //  inttostr(bitDepth) + '], less than header bit depth [' +
          //  inttostr(FDicomData.bits) + ']');
          MagLogger.LogMsg('s', 'Bit depth of downsampled image is [' +
            Inttostr(BitDepth) + '], less than header bit depth [' +
            Inttostr(FDicomData.Bits) + ']'); {JK 10/5/2009 - Maggmsgu refactoring}
          WinValue := GetDownsampledWinLevValue(WinValue, FDicomData.Bits, BitDepth);
          LevValue := GetDownsampledWinLevValue(LevValue, FDicomData.Bits, BitDepth);
          //LogMsg('s','New w/l values [' + inttostr(Winvalue) + '/' +
          //  inttostr(LevValue) + ']');
          MagLogger.LogMsg('s', 'New w/l values [' + Inttostr(WinValue) + '/' +
            Inttostr(LevValue) + ']'); {JK 10/5/2009 - Maggmsgu refactoring}
        End;
      End;
      DisplayInterface.WinLevValue(WinValue, LevValue);
    End
    Else
    Begin
      DisplayInterface.WindowLevelEntireImage();
    End;
  End;
End;

{ This function converts the window or level value from the DICOM header/TXT
  file that was specified and converts it to the value corresponding to the
  downsampled image that is shown. This uses the difference between the
  original image and the downsampled image to calculate the proper w/l value.

}

Function TMag4VGear.GetDownsampledWinLevValue(OriginalValue: Integer;
  OriginalBitDepth, DownsampledBitDepth: Integer): Integer;
Var
  Numerator, Denominator: Integer;
Begin
  Result := OriginalValue;
  Try
    Numerator := OriginalValue * Trunc((Power(2, DownsampledBitDepth) - 1));
    Denominator := Trunc(Power(2, OriginalBitDepth)) - 1;
    Result := Trunc(Numerator / Denominator);
  Except
    On e: Exception Do
    Begin
      //LogMsg('s','Error getting downsampled value [' + e.Message + ']', MagLogError);
      MagLogger.LogMsg('s', 'Error getting downsampled value [' + e.Message + ']', MagLogERROR); {JK 10/5/2009 - Maggmsgu refactoring}
    End;
  End;
End;

// this is a stupid function i don't want to have, it disables window/level
// (for QA image) but really shouldn't be here, shouldn't require viewer to call
//  this function

Procedure TMag4VGear.DisableWindowLevel();
Begin
  DisplayInterface.DisableWindowLevel();
End;

Procedure TMag4VGear.UpdatePageView();
Begin
  DisplayInterface.UpdatePageView();
End;

Procedure TMag4VGear.CalculateMaxWinLev();
Begin
  DisplayInterface.CalculateMaxWinLev();
End;

Procedure TMag4VGear.DisplayDICOMHeader();
Begin
  DisplayInterface.DisplayDICOMHeader();
End;

{JK 10/5/2009 - Maggmsgu refactoring - remove old method}
//procedure TMag4VGear.setLogEvent(Value : TMagLogEvent);
//begin
//  FOnLogEvent := Value;
//  if DisplayInterface <> nil then
//    DisplayInterface.OnLogEvent := FOnLogEvent;
//end;

Procedure TMag4VGear.SetShowPixelValues(Value: Boolean);
Begin
  FShowPixelValues := Value;
  If Not Value Then
    RefreshRadiologyHint();
End;

Procedure TMag4VGear.SetHistogramWindowLevel(Value: Boolean);
Begin
  FHistogramWindowLevel := Value;
  // should this reload the based on this information
End;

Procedure TMag4VGear.SetScrollPos(VertScrollPos: Integer; HorizScrollPos: Integer);
Begin
  DisplayInterface.SetScrollPos(VertScrollPos, HorizScrollPos);
End;

Procedure TMag4VGear.SetImageScroll(Value: TImageScrollEvent);
Begin
  FImageScroll := Value;
  DisplayInterface.OnImageScroll := OnImageZoomScroll;
End;

Procedure TMag4VGear.SetImageWinLevChange(Value: TImageWinLevChangeEvent);
Begin
  FImageWinLevChange := Value;
End;

{
This function basically intercepts the message and changes the sender to itself.
We could instead not use this function and push the event to vGears parent but
then the parent wouldn't be able to determine the sender properly (since the
parent doesn't know what a vGearIG14 is
}

Procedure TMag4VGear.ImageWinLevChange(Sender: Tobject; WindowValue: Integer; LevelValue: Integer);
Begin
  If Assigned(OnImageWinLevChange) Then
//    OnImageWinLevChange(self, WindowValue, LevelValue);
    OnImageWinLevChange(Self, WindowValue, LevelValue + FDicomData.GetLevelOffset());
End;

Procedure TMag4VGear.ImageBriConChange(Sender: Tobject; BrightnessValue: Integer; ContrastValue: Integer);
Begin
  If Assigned(OnImageBriConChange) Then
    OnImageBriConChange(Self, BrightnessValue, ContrastValue);
End;

Procedure TMag4VGear.SetCurrentTool(CurTool: TMagImageMouse);
Begin
  Case CurTool Of
    MactPan:
      Self.MousePan();
    MactMagnify:
      Self.MouseMagnify();
    MactZoomRect:
      Self.MouseZoomRect();
    MactWinLev:
      Self.AutoWinLevel();
    MactAnnotation:
      Annotations();
    MactMeasure:
      Measurements();
    MactProtractor:
      Protractor();
    MactAnnotationPointer:
      AnnotationPointer();
  End; {case}

End;

Procedure TMag4VGear.Measurements();
Begin
  // JMW P72 12/4/07 - check to be sure Measurements are enabled for current image
  If (MagAnnotation In DisplayInterface.ComponentFunctions) And FMeasurementsEnabled Then
    DisplayInterface.Measurements();
End;

Procedure TMag4VGear.Protractor();
Begin
  If (MagAnnotation In DisplayInterface.ComponentFunctions) Then
    DisplayInterface.Protractor();
End;

Procedure TMag4VGear.AnnotationPointer();
Begin
  If (MagAnnotation In DisplayInterface.ComponentFunctions) Then
    DisplayInterface.AnnotationPointer();
End;

Procedure TMag4VGear.ImageToolChange(Sender: Tobject; Tool: TMagImageMouse);
Begin
  // reassign the sender to the vGear control and not the FMagImage control
  If Assigned(OnImageToolChange) Then
    OnImageToolChange(Self, Tool);
End;

Procedure TMag4VGear.SetImageZoomChange(Value: TImageZoomChangeEvent);
Begin
  FImageZoomChange := Value;
End;

Procedure TMag4VGear.ImageZoomChange(Sender: Tobject; ZoomValue: Integer);
Begin
  If Assigned(OnImageZoomChange) Then
    OnImageZoomChange(Self, ZoomValue);
End;

Procedure TMag4VGear.SetImageUpdateImageState(Value: TImageUpdateImageStateEvent);
Begin
  FImageUpdateImageState := Value;
End;

Procedure TMag4VGear.ImageUpdateImageState(Sender: Tobject);
Begin
  If Assigned(OnImageUpdateImageState) Then
    OnImageUpdateImageState(Self);
End;

Procedure TMag4VGear.FrameMouseWheelDown(Sender: Tobject; Shift: TShiftState; MousePos: TPoint; Var Handled: Boolean);
Begin
  OnImageMouseScrollDown(Self, Shift, MousePos, Handled);
End;

Procedure TMag4VGear.FrameMouseWheelUp(Sender: Tobject; Shift: TShiftState; MousePos: TPoint; Var Handled: Boolean);
Begin
  OnImageMouseScrollUp(Self, Shift, MousePos, Handled);
End;

{//59 }

Procedure TMag4VGear.SetScroll(Hval, Vval: Integer);
Begin
  //--DisplayInterface.SetScrollPos(vval, hval); {JK 2/10/2009 - Fixes D74}
//Gear1.SetScrollPos(0,4,hval);
//Gear1.SetScrollPos(1,4,vval);
End;

{//59 }
//procedure TMag4VGear.Gear1Scroll(ASender: TObject; Scrolltype: Integer);
//begin
// if assigned(OnImageScroll) then OnImageScroll(Asender,self,gear1.GetScrollPos(0),gear1.GetScrollPos(1));
//end;

{//59 }

Procedure TMag4VGear.ImageHint(Val: String);
Begin
  DisplayInterface.Hint := Val;
//  Gear1.Hint := val;
End;

{//59 }

Procedure TMag4VGear.ImageDescriptionHint(Val: String);
Begin
  LblImage.Hint := Val;
End;

{//59 }

Procedure TMag4VGear.LblImageMouseEnter(Sender: Tobject);
Begin
  FOldHintHidePause := Application.HintHidePause;
  {Set to 10 Seconds.}
  Application.HintHidePause := 10000;
End;

{//59 }

Procedure TMag4VGear.LblImageMouseLeave(Sender: Tobject);
Begin
  If Self.FOldHintHidePause > 0 Then
    Application.HintHidePause := Self.FOldHintHidePause;
End;

{ JMW 2/12/08 - support key button events}

Procedure TMag4VGear.SetImageKeyDownChange(Value: TImageKeyDownEvent);
Begin
  FImageKeyDown := Value;

  {The ImageGear component was not properly sending the on key down event
  so the component no longer defines a handler for such an event. Key down events
  must be handled in a different way
  }
End;

Procedure TMag4VGear.SetAnnotationStyle(AnnotationStyle: TMagAnnotationStyle);
Begin
  FAnnotationStyle := AnnotationStyle;
  If AnnotationComponent <> Nil Then
    AnnotationComponent.AnnotationStyle := AnnotationStyle;
End;

Procedure TMag4VGear.SetMagAnnotationStyleChangeEvent(AnnotationStyleChangeEvent: TMagAnnotationStyleChangeEvent);
Begin
  FMagAnnotationStyleChangeEvent := AnnotationStyleChangeEvent;
  If AnnotationComponent <> Nil Then
  Begin
    AnnotationComponent.OnMagAnnotationStyleChangeEvent := MagAnnotationStyleChangeEvent;
  End;
End;

Procedure TMag4VGear.MagAnnotationStyleChangeEvent(Sender: Tobject;
  AnnotationStyle: TMagAnnotationStyle);
Begin
  FAnnotationStyle := AnnotationStyle;
  If Assigned(FMagAnnotationStyleChangeEvent) Then
    FMagAnnotationStyleChangeEvent(Self, AnnotationStyle);

End;

Procedure TMag4VGear.SetShowLabels(Value: Boolean);
Begin
  // JMW 10/31/2008 p72 - don't need to show/hide labels if same as current
  // status - occurs when first showing the image, don't want to show label
  // before image loaded (will get caught before error, but better not to try)
  If FShowLabels = Value Then
    Exit;
  FShowLabels := Value;
  If FCurrentImage = '' Then
    Exit;
  If FShowLabels Then
    DrawRadLettersExecute
  Else
  Begin
    DisplayInterface.RemoveOrientationLabel();
    If FOrientationLabel <> Nil Then
      FOrientationLabel.Visible := False;
  End;
End;

Procedure TMag4VGear.ShowOrientationLabel(Letter: String);
Begin
  If DisplayInterface = Nil Then Exit;
  If FOrientationLabel = Nil Then
  Begin
    FOrientationLabel := Tlabel.Create(Self);
    DisplayInterface.AddComponentToViewComponent(FOrientationLabel);
    FOrientationLabel.Left := 5;
    FOrientationLabel.Top := Trunc(DisplayInterface.Height / 2);
    FOrientationLabel.AutoSize := True;
    FOrientationLabel.Color := clBlack;
    FOrientationLabel.Font.Color := clWhite;
    FOrientationLabel.Font.Size := 12;
    FOrientationLabel.alignment := TaCenter;
    FOrientationLabel.Layout := TlCenter;
    //FOrientationLabel.Anchors := [FOrientationLabelAnchor];
    SetOrientationLabelPosition(FOrientationLabelAnchor);
  End;
  FOrientationLabel.caption := Letter;
  If FShowLabels Then
  Begin
    FOrientationLabel.Visible := True;
    FOrientationLabel.BringToFront;
  End
  Else
  Begin
    FOrientationLabel.Visible := False;
  End;
End;

{
 Set the position of the orientation label. This occurs even if the label is
 hidden (so in case the user makes it visible, the label will be in the right
 place).
}

Procedure TMag4VGear.SetOrientationLabelPosition(AnchorLocation: TAnchorKind);
Begin
  FOrientationLabelAnchor := AnchorLocation;
  If FOrientationLabel <> Nil Then
  Begin
    Case AnchorLocation Of
      akLeft:
        Begin
          FOrientationLabel.Left := 5;
          FOrientationLabel.Top := Trunc(DisplayInterface.Height / 2);
          FOrientationLabel.Anchors := [akLeft];
        End;
      akTop:
        Begin
          FOrientationLabel.Top := 5;
          FOrientationLabel.Left := Trunc(DisplayInterface.Width / 2);
          FOrientationLabel.Anchors := [akTop];
        End;
      akRight:
        Begin
          FOrientationLabel.Left := DisplayInterface.Width - 40;
          FOrientationLabel.Top := Trunc(DisplayInterface.Height / 2);
          FOrientationLabel.Anchors := [akRight];
        End;
      akBottom:
        Begin
          FOrientationLabel.Top := DisplayInterface.Height - 40;
          FOrientationLabel.Left := Trunc(DisplayInterface.Width / 2);
          FOrientationLabel.Anchors := [akBottom];
        End;
    End;
  End;
End;

{
 rotates the orientation label clockwise numTimes times. Always in a
 clockwise motion.
}

Procedure TMag4VGear.RotateOrientationLabel(NumTimes: Integer);
Var
  i: Integer;
  CurLabelAnchorLocation: TAnchorKind;
Begin
//  if (FOrientationLabel = nil) then
//    exit;
  CurLabelAnchorLocation := GetOrientationLabelAnchor();
  For i := 0 To NumTimes - 1 Do
  Begin
    Case CurLabelAnchorLocation Of
      akLeft:
        Begin
          CurLabelAnchorLocation := akTop;
        End;
      akTop:
        Begin
          CurLabelAnchorLocation := akRight;
        End;
      akRight:
        Begin
          CurLabelAnchorLocation := akBottom;
        End;
      akBottom:
        Begin
          CurLabelAnchorLocation := akLeft;
        End;
    End;
  End;
  SetOrientationLabelPosition(CurLabelAnchorLocation);
End;

{
 Determines the anchor type of the orientation label. This determines the
 current position of the orientation label.
}

Function TMag4VGear.GetOrientationLabelAnchor(): TAnchorKind;
Begin
  Result := FOrientationLabelAnchor;
  If FOrientationLabel = Nil Then
    Exit;
  If (akLeft In FOrientationLabel.Anchors) Then
    Result := akLeft
  Else
    If (akRight In FOrientationLabel.Anchors) Then
      Result := akRight
    Else
      If (akTop In FOrientationLabel.Anchors) Then
        Result := akTop
      Else
        If (akBottom In FOrientationLabel.Anchors) Then
          Result := akBottom
End;

Procedure TMag4VGear.SetPanWindowClose(Value: TMagPanWindowCloseEvent);
Begin
  FPanWindowClose := Value;
  If DisplayInterface <> Nil Then
    DisplayInterface.OnPanWindowClose := FPanWindowClose;
End;

Procedure TMag4VGear.ScrollLeft();
Begin
  DisplayInterface.ScrollLeft();
End;

Procedure TMag4VGear.ScrollRight();
Begin
  DisplayInterface.ScrollRight();
End;

Procedure TMag4VGear.ScrollUp();
Begin
  DisplayInterface.ScrollUp();
End;

Procedure TMag4VGear.ScrollDown();
Begin
  DisplayInterface.ScrollDown();
End;

Procedure TMag4VGear.btnCloseImageClick(Sender: Tobject);
Begin
  If (FParentViewer Is TMag4Viewer) Then
    TMag4Viewer(FParentViewer).RemoveOneFromList(Self.PI_ptrData);
End;

{*
  Determine if the image contains a DICOM header
  @returns True if the image has a DICOM header, false otherwise
}

Function TMag4VGear.ImageContainsDicomHeader(): Boolean;
Begin
  Result := False;

  If (MagDICOMHeader In DisplayInterface.ComponentFunctions)
    And (DisplayInterface.IsDICOMHeaderInImageFormat()) Then
    Result := True;
End;

Procedure TMag4VGear.setMouseZoomShape(Value: TMagMouseZoomShape);
Begin
  DisplayInterface.MouseZoomShape := Value;
End;

Function TMag4VGear.GetMagImage: TMagImage;
Begin
  Result := DisplayInterface;
End;
    {/gek p117  added for the display of image status on the Abstracts}
function TMag4VGear.GetShowImageStatus: boolean;
begin
 result := FShowImageStatus;
end;
    {/gek p117  added for the display of image status on the Abstracts}
procedure TMag4VGear.SetShowImageStatus(value: boolean);
begin
FShowImageStatus := value;
end;

End.
