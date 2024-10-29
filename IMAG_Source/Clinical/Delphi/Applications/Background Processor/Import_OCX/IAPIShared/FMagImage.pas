Unit FmagImage;
(*
;; +---------------------------------------------------------------------------------------------------+
;;  MAG - IMAGING
;;  Property of the US Government.
;;  WARNING: Pe VHA Directive xxxxxx, this unit should not be modified.
;;  No permission to copy or redistribute this software is given.
;;  Use of unreleased versions of this software requires the user
;;  to execute a written test agreement with the VistA Imaging
;;  Development Office of the Department of Veterans Affairs,
;;  telephone (301) 734-0100.
;;
;; The Food and Drug Administration classifies this software as
;; a Class II medical device.  As such, it may not be changed
;; in any way.  Modifications to this software may result in an
;; adulterated medical device under 21CFR820, the use of which
;; is considered to be a violation of US Federal Statutes.
;;
;;  Date created: June 2006
;;  Site Name:  Washington OI Field Office, Silver Spring, MD
;;  Developer:  Julian Werfel
;;  Description: This is the base image object the TMag4VGear component
;;  uses to display.  This is extended for use in the IG14 and IG99
;;  AccuSoft components.
;;
;;+---------------------------------------------------------------------------------------------------+
*)

Interface

Uses
  Classes,
  //cMagLogManager, {JK 10/5/2009 - Maggmsgu refactoring - deprecated unit}
  Controls,
{$IFDEF USENEWANNOTS}
  FMagAnnot,
{$ELSE}
  FmagAnnotation,
{$ENDIF}
  Forms,
  Graphics,
  UMagClasses,
  UMagDefinitions,
  Windows
  ;

Type
  TImageBriConChangeEvent = Procedure(Sender: Tobject; BrightnessValue: Integer; ContrastValue: Integer) Of Object;
  TImageKeyDownEvent = Procedure(Sender: Tobject; Var Key, Shift: Smallint) Of Object;
  TImageMouseDblClickEvent = Procedure(Sender: Tobject) Of Object;
  TImageMouseDownEvent = Procedure(Sender: Tobject; Button: TMouseButton; Shift: TShiftState; x, y: Integer) Of Object;
  TImageMouseMoveEvent = Procedure(Sender: Tobject; Button: TMouseButton; Shift: TShiftState; x, y: Integer) Of Object;
  TImageMouseScrollDownEvent = Procedure(Sender: Tobject; Shift: TShiftState; MousePos: TPoint; Var Handled: Boolean) Of Object;
  TImageMouseScrollUpEvent = Procedure(Sender: Tobject; Shift: TShiftState; MousePos: TPoint; Var Handled: Boolean) Of Object;
  TImageMouseUpEvent = Procedure(Sender: Tobject; Button: TMouseButton; Shift: TShiftState; x, y: Integer) Of Object;
  TImageScrollEvent = Procedure(Sender: Tobject; VertScrollPos: Integer; HorizScrollPos: Integer) Of Object;
  TImageToolChangeEvent = Procedure(Sender: Tobject; Tool: TMagImageMouse) Of Object;
  TImageUpdateImageStateEvent = Procedure(Sender: Tobject) Of Object;
  TImageWinLevChangeEvent = Procedure(Sender: Tobject; WindowValue: Integer; LevelValue: Integer) Of Object;
  TImageZoomChangeEvent = Procedure(Sender: Tobject; ZoomValue: Integer) Of Object;
  TMagImageMousePointer = (MagImagePointerDefault, MagImagePointerArrow, MagImagePointerCrossHair);
  TMagImageOrientation = (BottomLeft, BottomRight, LeftBottom, LeftTop, RightBottom, RightTop, TopLeft, TopRight);
  TMagImagePromoteValue = (PROMOTE_TO_4, PROMOTE_TO_8, PROMOTE_TO_24, PROMOTE_TO_32);

  TMagImage = Class(TFrame)
    Procedure FrameMouseWheelDown(Sender: Tobject; Shift: TShiftState; MousePos: TPoint; Var Handled: Boolean);
    Procedure FrameMouseWheelUp(Sender: Tobject; Shift: TShiftState; MousePos: TPoint; Var Handled: Boolean);
  Protected
{$IFDEF USENEWANNOTS}
    FAnnotationComponent: TMagAnnot;
{$ELSE}
    FAnnotationComponent: TMagAnnotation;
{$ENDIF}
    Fbrightnesspassed: Integer;
    FComponentFunctions: TMag4VGearFunctions;
    FContrastPassed: Integer;
    FGearAbilities: TMagGearAbilities;
    FImageDblClick: TImageMouseDblClickEvent;
    FImageKeyDownChange: TImageKeyDownEvent;
    FImageMouseDown: TImageMouseDownEvent;
    FImageMouseMove: TImageMouseMoveEvent;
    FImageMouseScrollDown: TImageMouseScrollDownEvent;
    FImageMouseScrollUp: TImageMouseScrollUpEvent;
    FImageMouseUp: TImageMouseUpEvent;
    FImagePointer: TMagImageMousePointer;
    FImageScroll: TImageScrollEvent;
    FImageToolChange: TImageToolChangeEvent;
    FImageUpdateImageState: TImageUpdateImageStateEvent;
    FImageWinLevChange: TImageWinLevChangeEvent;
    FImageZoomChange: TImageZoomChangeEvent;
    FLevelValue: Integer;
    FLevelValueMax: Integer;
    FLevelValueMin: Integer;
    FMaxPixelValue: Integer;
    FMinPixelValue: Integer;
    FMouseAction: TMagImageMouse;
    FMouseZoomShape: TMagMouseZoomShape;
    FPanWindowClose: TMagPanWindowCloseEvent;
    FUpdatePageView: Boolean;
    FWindowValue: Integer;
    FWindowValueMax: Integer;
    FWindowValueMin: Integer;
    FZoomValue: Integer;
    Procedure SetImagePointer(Value: TMagImageMousePointer); Virtual;
    Procedure SetLevelValue(Value: Integer); Virtual;
    Procedure setMouseZoomShape(Value: TMagMouseZoomShape); Virtual;
    Procedure SetWindowValue(Value: Integer); Virtual;
  Public
    Constructor Create(AOwner: TComponent; GearAbilities: TMagGearAbilities = MagGearAbilityRadiology); Virtual; //override; //virtual;
    Function GetBitsPerPixel(): Integer; Virtual; Abstract;
    Function GetCompression(): String; Virtual; Abstract;
    Function GetFileFormat(): String; Virtual; Abstract;
    Function GetHeight(): Integer; Virtual; Abstract;
    Function GetMouseAction(): TMagImageMouse;
    Function GetPage: Integer; Virtual; Abstract;
    Function GetPageCount: Integer; Virtual; Abstract;
    Function GetPixelValue(Var x: Integer; Var y: Integer): Integer; Virtual; Abstract;
    Function GetRedGreenBlueValue(Var x: Integer; Var y: Integer; Var Red: Integer; Var Green: Integer; Var Blue: Integer): Boolean; Virtual; Abstract;
    Function GetWidth(): Integer; Virtual; Abstract;
    Function IsDICOMHeaderInImageFormat(): Boolean; Virtual; Abstract;
    Function IsFormatSupportMeasurements(Dicomdata: TDicomData): Boolean; Virtual; Abstract;
    Function IsFormatSupportWinLev(): Boolean; Virtual; Abstract;
    Function IsSigned(): Boolean; Virtual; Abstract;
    Function LoadDICOMData(Var Dicomdata: TDicomData): Boolean; Virtual; Abstract;
    Function ZoomLevel(): Integer; Virtual;
    Procedure AddComponentToViewComponent(Control: TControl); Virtual; Abstract;
    Procedure AnnotationPointer(); Virtual;
    Procedure Annotations(); Virtual;
    Procedure AutoWinLevel; Virtual;
    Procedure BrightnessContrastValue(Bri, Con: Integer); Virtual;
    Procedure BrightnessValue(Value: Integer); Virtual;
    Procedure CalculateMaxWinLev(); Virtual; Abstract;
    Procedure ClearImage(); Virtual; Abstract;
    Procedure ContrastValue(Value: Integer); Virtual;
    Procedure CopyToClipboard(); Virtual; Abstract;
    Procedure CopyToClipboardRadiology(); Virtual; Abstract;
    Procedure DeSkewAndSmooth; Virtual; Abstract; {Preform both operations, DeSkew to straighten and Smooth to make edges clearer.  Gives an Image that is easier to view, less strain on eyes}
    Procedure DeSkewImage; Virtual; Abstract;
    Procedure DisableWindowLevel();
    Procedure DisplayDICOMHeader(); Virtual; Abstract;
    Procedure DrawCharacter(Left, Top, Red, Green, Blue: Integer; Letter: String; Height_scale: Real); Virtual; Abstract;
    Procedure Fit1to1; Virtual; Abstract; {  Fit 1 image pixel to 1 screen pixel.  Actual Size.}
    Procedure FitToHeight; Virtual; Abstract;
    Procedure FitToWidth; Virtual; Abstract;
    Procedure FitToWindow; Virtual; Abstract;
    Procedure FlipHoriz; Virtual; Abstract;
    Procedure FlipVert; Virtual; Abstract;
    Procedure Inverse; Virtual; Abstract;
    Procedure LoadImage(Filename: String); Virtual; Abstract;
    Procedure Measurements(); Virtual;
    Procedure MouseMagnify; Virtual; // abstract; {  mouse will act as magnifier }
    Procedure MousePan; Virtual; //abstract;{  mouse will pan the image }
    Procedure MouseReSet; Virtual; {  mouse pointer }
    Procedure MouseZoomRect; Virtual; // abstract;{  mouse will select area.  That area will be zoomed to (as close as possible) }
    Procedure PanWindowSettings(h, w, x, y: Integer); Virtual; Abstract;
    Procedure PrintImage(Handle: HDC); Virtual; Abstract;
    Procedure PromoteColor(ColorValue: TMagImagePromoteValue); Virtual; Abstract;
    Procedure Protractor(); Virtual;
    Procedure ReDrawImage; Virtual; Abstract; {  Redraws the Image, does not do a Reload}
    Procedure RefreshImage; Virtual; Abstract; {  Reloads the Image from disk.}
    Procedure RemoveOrientationLabel(); Virtual; Abstract;
    Procedure ResetImage; Virtual; Abstract; {  undo all manipilations, and Fit to Window}
    Procedure Rotate(Deg: Integer); Virtual; Abstract; {  deg is 90,180 or 270}
    Procedure ScrollDown(); Virtual; Abstract;
    Procedure ScrollLeft(); Virtual; Abstract;
    Procedure ScrollRight(); Virtual; Abstract;
    Procedure ScrollUp(); Virtual; Abstract;
    Procedure SetBackgroundColor(Color: TColor); Virtual; Abstract;
    Procedure SetOrientation(Orientation: TMagImageOrientation); Virtual; Abstract;
    Procedure SetPage(Const Value: Integer); Virtual; Abstract;
    Procedure SetPageCount(Const Value: Integer); Virtual; Abstract;
    Procedure SetPanWindow(Value: Boolean); Virtual; Abstract;
    Procedure SetPrintSize(Value: Integer); Virtual; Abstract;
    Procedure SetScrollPos(VertScrollPos: Integer; HorizScrollPos: Integer); Virtual; Abstract;
    Procedure SetSettingMode(Mode: Integer); Virtual; Abstract;
    Procedure SetSettingValue(Value: Integer); Virtual; Abstract;
    Procedure SetUpdateGUI(Value: Boolean); Virtual; Abstract;
    Procedure SetUpdatePageView(Value: Boolean);
    Procedure SetZoomWindow(Value: Boolean); Virtual; Abstract;
    Procedure SmoothImage; Virtual; Abstract; //p8t43 {  smooth edges of image, used on 1 but tifs for easier, clear reading}
    Procedure UpdatePageView(); Virtual; Abstract;
    Procedure WindowLevelEntireImage(); Virtual; Abstract;
    Procedure WinLevValue(WinValue, LevValue: Integer); Virtual; Abstract;
    Procedure ZoomValue(Value: Integer); Virtual;
{$IFDEF USENEWANNOTS}
    Property AnnotationComponent: TMagAnnot Read FAnnotationComponent;
{$ELSE}
    Property AnnotationComponent: TMagAnnotation Read FAnnotationComponent;
{$ENDIF}
    Property Brightness: Integer Read Fbrightnesspassed Write BrightnessValue;
    Property ComponentFunctions: TMag4VGearFunctions Read FComponentFunctions Write FComponentFunctions;
    Property Contrast: Integer Read FContrastPassed Write ContrastValue;
    Property ImagePointer: TMagImageMousePointer Read FImagePointer Write SetImagePointer;
    Property ImageZoomValue: Integer Read FZoomValue Write ZoomValue;
    Property LevelValue: Integer Read FLevelValue Write SetLevelValue;
    Property LevelValueMax: Integer Read FLevelValueMax;
    Property LevelValueMin: Integer Read FLevelValueMin;
    Property MaxPixelValue: Integer Read FMaxPixelValue;
    Property MinPixelValue: Integer Read FMinPixelValue;
    Property MouseAction: TMagImageMouse Read FMouseAction;
    Property MouseZoomShape: TMagMouseZoomShape Read FMouseZoomShape Write setMouseZoomShape;
    Property OnImageDblClick: TImageMouseDblClickEvent Read FImageDblClick Write FImageDblClick;
    Property OnImageMouseDown: TImageMouseDownEvent Read FImageMouseDown Write FImageMouseDown;
    Property OnImageMouseMove: TImageMouseMoveEvent Read FImageMouseMove Write FImageMouseMove;
    Property OnImageMouseScrollDown: TImageMouseScrollDownEvent Read FImageMouseScrollDown Write FImageMouseScrollDown;
    Property OnImageMouseScrollUp: TImageMouseScrollUpEvent Read FImageMouseScrollUp Write FImageMouseScrollUp;
    Property OnImageMouseUp: TImageMouseUpEvent Read FImageMouseUp Write FImageMouseUp;
    Property OnImageScroll: TImageScrollEvent Read FImageScroll Write FImageScroll;
    Property OnImageToolChange: TImageToolChangeEvent Read FImageToolChange Write FImageToolChange;
    Property OnImageUpdateImageState: TImageUpdateImageStateEvent Read FImageUpdateImageState Write FImageUpdateImageState;
    Property OnImageWinLevChange: TImageWinLevChangeEvent Read FImageWinLevChange Write FImageWinLevChange;
    Property OnImageZoomChange: TImageZoomChangeEvent Read FImageZoomChange Write FImageZoomChange;
    Property OnPanWindowClose: TMagPanWindowCloseEvent Read FPanWindowClose Write FPanWindowClose;
    Property UpdatePageViewEnabled: Boolean Read FUpdatePageView Write SetUpdatePageView;
    Property WindowValue: Integer Read FWindowValue Write SetWindowValue;
    Property WindowValueMax: Integer Read FWindowValueMax;
    Property WindowValueMin: Integer Read FWindowValueMin;
  End;

Const
  IMAGE_ORIENTATION_BOTTOM_LEFT = 0;
  IMAGE_ORIENTATION_BOTTOM_RIGHT = 1;
  IMAGE_ORIENTATION_LEFT_BOTTOM = 2;
  IMAGE_ORIENTATION_LEFT_TOP = 3;
  IMAGE_ORIENTATION_RIGHT_BOTTOM = 4;
  IMAGE_ORIENTATION_RIGHT_TOP = 5;
  IMAGE_ORIENTATION_TOP_LEFT = 6;
  IMAGE_ORIENTATION_TOP_RIGHT = 7;

Procedure Register;

Implementation

{$R *.dfm}

Procedure Register;
Begin
  RegisterComponents('Imaging', [TMagImage]);
End;

Constructor TMagImage.Create(AOwner: TComponent; GearAbilities: TMagGearAbilities = MagGearAbilityRadiology);
Begin
  Inherited Create(AOwner);
  FGearAbilities := GearAbilities;
  Fbrightnesspassed := 100;
  FContrastPassed := 100;
  FMaxPixelValue := 0;
  FMinPixelValue := 0;
End;

Procedure TMagImage.ContrastValue(Value: Integer);
Begin
  FContrastPassed := Value;
End;

Procedure TMagImage.BrightnessValue(Value: Integer);
Begin
  Fbrightnesspassed := Value;
End;

Procedure TMagImage.MousePan;
Begin
  FMouseAction := MactPan;
End;

Procedure TMagImage.Annotations();
Begin
  FMouseAction := MactAnnotation;
End;

Procedure TMagImage.Measurements();
Begin
  FMouseAction := MactMeasure;
End;

Procedure TMagImage.Protractor();
Begin
  FMouseAction := MactProtractor;
End;

Procedure TMagImage.AnnotationPointer();
Begin
  FMouseAction := MactAnnotationPointer;
End;

Function TMagImage.GetMouseAction(): TMagImageMouse;
Begin
  Result := FMouseAction;
End;

Procedure TMagImage.MouseMagnify;
Begin
  FMouseAction := MactMagnify;
End;

Procedure TMagImage.MouseZoomRect;
Begin
  FMouseAction := MactZoomRect;
End;

Procedure TMagImage.AutoWinLevel;
Begin
  FMouseAction := MactWinLev;
End;

Procedure TMagImage.ZoomValue(Value: Integer);
Begin
  FZoomValue := Value;
End;

Function TMagImage.ZoomLevel(): Integer;
Begin
  Result := FZoomValue;
End;

Procedure TMagImage.MouseReSet;
Begin
  FMouseAction := MactPointer;
End;

Procedure TMagImage.SetUpdatePageView(Value: Boolean);
Begin
  Self.FUpdatePageView := Value;
End;

Procedure TMagImage.FrameMouseWheelDown(Sender: Tobject;
  Shift: TShiftState; MousePos: TPoint; Var Handled: Boolean);
Begin
  If Assigned(OnImageMouseScrollDown) Then
    OnImageMouseScrollDown(Sender, Shift, MousePos, Handled);
End;

Procedure TMagImage.FrameMouseWheelUp(Sender: Tobject; Shift: TShiftState;
  MousePos: TPoint; Var Handled: Boolean);
Begin
  If Assigned(OnImageMouseScrollUp) Then
    OnImageMouseScrollUp(Sender, Shift, MousePos, Handled);
End;

Procedure TMagImage.SetImagePointer(Value: TMagImageMousePointer);
Begin
  FImagePointer := Value;
End;

Procedure TMagImage.SetWindowValue(Value: Integer);
Begin
  FWindowValue := Value;
End;

Procedure TMagImage.SetLevelValue(Value: Integer);
Begin
  FLevelValue := Value;
End;

Procedure TMagImage.DisableWindowLevel();
Begin
  If (MagWinLev In FComponentFunctions) Then
  Begin
    FComponentFunctions := FComponentFunctions - [MagWinLev];
  End;
End;

Procedure TMagImage.setMouseZoomShape(Value: TMagMouseZoomShape);
Begin
  FMouseZoomShape := Value;
End;

Procedure TMagImage.BrightnessContrastValue(Bri, Con: Integer);
Begin
  Fbrightnesspassed := Bri;
  FContrastPassed := Con;
End;

End.
