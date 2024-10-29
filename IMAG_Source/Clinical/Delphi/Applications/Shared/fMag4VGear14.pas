Unit FMag4VGear14;
(*
        ;; +---------------------------------------------------------------------------------------------------+
        ;;  MAG - IMAGING                                              \
        ;;  Property of the US Government.
        ;;  WARNING: Per VHA Directive 2004-038, this routine should not be modified.
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
        ;;  Description: This is the AccuSoft Image Gear v15 implementation of
        ;;  the MagImage object for use within the TMag4VGear component. It
        ;;  handles all IG specific calls and implementation.
        ;;
        ;;+---------------------------------------------------------------------------------------------------+
*)

Interface

Uses
  Forms,
  Classes,
  Controls,
  FmagImage,
  GearCORELib_TLB,
  GearDISPLAYLib_TLB,
  GearFORMATSLib_TLB,
  GearMEDLib_TLB,
  GearVIEWLib_TLB,
  Graphics,
  IGGUIWinLib_TLB,
  UMagClasses,
  UMagDefinitions,
  Windows,
  AxCtrls,
  OleCtrls
 , imaginterfaces  ,shellapi
 ,cMagLine
  ;
   {
Type
  TMagPoints = class
  public
    X1, Y1, X2, Y2 : integer;

    Constructor Create(X1, Y1, X2, Y2 : integer);
  end;

  TMagPoint = class
  public
    X, Y : integer;
    Constructor Create(X, Y : integer);
  end;
  }
type
  TMag4VGear14 = Class(TMagImage)
    IGPageViewCtl1: TIGPageViewCtl;
    Procedure IGPageViewCtl1MouseDblClick(Sender: Tobject; Button, Shift: Smallint; x, y: Integer);
    Procedure IGPageViewCtl1MouseDown(Sender: Tobject; Button, Shift: Smallint; x, y: Integer);
    Procedure IGPageViewCtl1MouseMove(Sender: Tobject; Button, Shift: Smallint; x, y: Integer);
    Procedure IGPageViewCtl1MouseUp(Sender: Tobject; Button, Shift: Smallint; x, y: Integer);
    Procedure IGPageViewCtl1Scroll(ASender: Tobject; Scrolltype: Integer);
    Procedure IGPageViewCtl1SelectEvent(Sender: Tobject; Var LplLeft, LplTop, LplRight, LplBottom: Integer);
    procedure IGPageViewCtl1AfterDraw(ASender: TObject; hDC: Integer);
    procedure FrameResize(Sender: TObject);
  Private
    CurrentGrayLUT: IGLUT;
    CurrentMedPage: IGMedPage;
    CurrentPage: IGPage;
    CurrentPageDisp: IGPageDisplay;
    CurrentPresStateMedPage: IGMedPage;
    CurrentPresStatePage: IGPage;
    FAnnotationsNeverLoaded: Boolean;
    FCurrentFilename: String;
    FDefaultComponentFunctions: TMag4VGearFunctions;
    FFontSize: Integer;
    FHeight: Integer;
    FImageFormat: enumIGFormats;
    FPage: Integer;
    FPageCount: Integer;
    FWidth: Integer;
    IGGuiMagnifierCtrl: TIGGUIMagnifierCtl;
    IGPanCtrl: TIGGUIPanCtl;
    IoLocation: IIGIOLocation;
    LoadOptions: IGLoadOptions;
    MedContrast: IGMedContrast;
    MedDataDict: IGMedDataDict;
    SaveOptions: IGSaveOptions;
//Was for RCA decouple magmsg, not now.        procedure MyLogMsg(msgType, msg: String; Priority: TMagMsgPriority = magmsgINFO);  //RCA
 {7/12/12 gek Merge 130->129}
    FRChannel : IIGPage;   //p122rgb dmmn 12/12/11 - store red channel of a valid rgb image
    FGChannel : IIGPage;   //p122rgb dmmn 12/12/11 - store green channel of a valid rgb image
    FBChannel : IIGPage;   //p122rgb dmmn 12/12/11 - store blue channel of a valid rgb image
    {p129t10 gek  Skip the splitting of color channel on every image in capture.  Stops error.
                  and isn't needed.}
    FSkipColorChannel: boolean;

    FScoutLine : TMagLine; // JMW 4/17/2013 p131
    FEdgeLine1 : TMagLine;
    FEdgeLine2 : TMagLine;
    //FScoutLinePoints  : TMagLinePoints; // JMW 4/17/2013 p131
    FScoutLineDetails : TMagScoutLine;
    FRotatedCount : integer;
    FFlippedHorizontal : boolean;
    FFlippedVertical : boolean;

    FScoutLineColor : TColor;
    Function ConvertToInternalZoom(NormalizedZoom: Integer): Double;
    Function getAnnotationFontSizeFromDPI(): Integer;
    Function GetMouseButton(Button: Smallint): TMouseButton;
    Function GetShiftState(Shift: Smallint): TShiftState;
    Function GetZoomFactor(): Double;
    Function isImagePDF(): Boolean;
    Function UpdateImageResolution(Dicomdata: TDicomData): Boolean;
    Procedure AdjustForDownsizedImage(Var XDenom: Integer; Var YDenom: Integer; Dicomdata: TDicomData);
    Procedure AnnotationPointer(); Override;
    Procedure CreatePage();
    Procedure GetMedContrast();
    Procedure initializeAnnotations();
    Procedure Measurements(); Override;
    Procedure PanControlTrackDone(Sender: Tobject);
    Procedure Protractor(); Override;
    Procedure RefreshZoomValue();
    Procedure SetImagePointer(Value: TMagImageMousePointer); Override;
    Procedure SetLevelValue(Value: Integer); Override;
    Procedure setMouseZoomShape(Value: TMagMouseZoomShape); Override;
    Procedure SetView(TheView: EnumIGDsplFitModes);
    Procedure SetWindowValue(Value: Integer); Override;
    Procedure UnselectAllAnnotations();
    Procedure UpdateScrollPos();
    procedure CreateArtPages(PageCnt: Integer);
    function IsArtPageExist(FN: String): Boolean;
    procedure DrawCurrentScoutLine();
    function getRotatedPoint(point : TMagPoint) : TMagPoint;
    function getUnRotatedPoint(point : TMagPoint) : TMagPoint;
    procedure DrawScoutLineOnImage(Points : TMagLinePoints; scoutLine : boolean; Line : TMagLine);

  Public
    {/p149}  {BM-ImagePrint- Preview Rasterview***}
    ////////procedure RasterizeView;
    procedure SkipColorChannel(value : boolean); override;
    {p129  surface the IGPage for TWAIN Functions}
    function GetCurrentPage(): IGPage; override;   { p129 make new function public for TWAIN interface..  (for now);}
    Constructor Create(AOwner: TComponent; GearAbilities: TMagGearAbilities = MagGearAbilityRadiology); Override;
    Destructor Destroy; Override;
    Function GetBitsPerPixel(): Integer; Override;
    Function GetCompression(): String; Override;
    Function GetFileFormat(): String; Override;
    Function GetFileFormatID():  integer ; override;   {p129 - integer ID of the Format Accusoft ID}
    Function GetFileFormatAbbr(): string ; override;   {p129 - Short name for Format}
    Function GetHeight(): Integer; Override;
    Function GetImageDpiString(): String;
    Function GetPage: Integer; Override;
    Function GetPageCount: Integer; Override;
    Function GetPixelValue(Var x: Integer; Var y: Integer): Integer; Override;
    Function GetRedGreenBlueValue(Var x: Integer; Var y: Integer; Var Red: Integer; Var Green: Integer; Var Blue: Integer): Boolean; Override;
    Function GetWidth(): Integer; Override;
    Function GetScrollInfo(): TMagScrollInfo; Override;  //p129
    Function IsDICOMHeaderInImageFormat(): Boolean; Override;
    Function IsFormatSupportMeasurements(Dicomdata: TDicomData): Boolean; Override;
    Function IsFormatSupportWinLev(): Boolean; Override;
    Function IsSigned(): Boolean; Override;
    Function IsValidImage(): Boolean; Override;        //p129
    Function LoadDICOMData(Var Dicomdata: TDicomData): Boolean; Override;
    Procedure AddComponentToViewComponent(Control: TControl); Override;
    Procedure Annotations; Override;
    Procedure AutoWinLevel; Override;
    Procedure BrightnessContrastValue(Bri, Con: Integer); Override;
    Procedure BrightnessValue(Value: Integer); Override;
    Procedure CalculateMaxWinLev(); Override;
    Procedure ClearImage(); Override;
    Procedure ContrastValue(Value: Integer); Override;
    procedure PasteFromClipboard(); Override;  //p129
    Procedure CopyToClipboard(); Override;
    Procedure CopyToClipboardRadiology(); Override;
    Procedure DeSkewAndSmooth; Override;
    Procedure DeSkewImage; Override;
    procedure DeSpeckleImage; Override; {p129 needed for capture.}
    Procedure DisplayDICOMHeader(); Override;
    Procedure DrawCharacter(Left, Top, Red, Green, Blue: Integer; Letter: String; Height_scale: Real); Override;
    Procedure Fit1to1; Override;
    Procedure FitToHeight; Override;
    Procedure FitToWidth; Override;
    Procedure FitToWindow; Override;
    Procedure FlipHoriz; Override;
    Procedure FlipVert; Override;
    Procedure Inverse; Override;
    Procedure LoadImage(Filename: String); Override;
    Procedure MouseMagnify; Override;
    Procedure MousePan; Override;
    Procedure MouseReSet; Override;
    Procedure MouseZoomRect; Override;
    Procedure PanWindowSettings(h, w, x, y: Integer); Override;
    Procedure PrintImage(Handle: HDC); Override;
    Procedure PromoteColor(ColorValue: TMagImagePromoteValue); Override;
    Procedure ReDrawImage; Override;
    Procedure RefreshImage; Override;
    Procedure RemoveOrientationLabel(); Override;
    Procedure ResetImage; Override;
 {7/12/12 gek Merge 130->129}
    Function RGBChanger(CurrentState: Integer; ApplyAll : Boolean) : Integer; Override;  //p122rgb dmmn 12/8
    Procedure Rotate(Deg: Integer); Override;
    Procedure ScrollDown(); Override;
    Procedure ScrollLeft(); Override;
    Procedure ScrollRight(); Override;
    Procedure ScrollUp(); Override;
    Procedure SetBackgroundColor(Color: TColor); Override;
    Procedure SetOrientation(Orientation: TMagImageOrientation); Override;
    Procedure SetPage(Const Value: Integer); Override;
    Procedure SetPageCount(Const Value: Integer); Override;
    Procedure SetPanWindow(Value: Boolean); Override;
    Procedure SetPrintSize(Value: Integer); Override;
    Procedure SetScrollPos(VertScrollPos: Integer; HorizScrollPos: Integer); Override;
    Procedure SetSettingMode(Mode: Integer); Override;
    Procedure SetSettingValue(Value: Integer); Override;
    Procedure SetUpdateGUI(Value: Boolean); Override;
    Procedure SetZoomWindow(Value: Boolean); Override;
    Procedure SmoothImage; Override;
    Procedure UpdatePageView(); Override;
    Procedure WindowLevelEntireImage(); Override;
    Procedure WinLevValue(WinValue, LevValue: Integer); Override;
    Procedure ZoomValue(Value: Integer); Override;
    {JK 6/28/2012 - Surface the IGPageViewCtl}{p129}
    function GetImageViewCtl: TIGPageViewCtl; Override;

    Procedure DrawScoutLine(ScoutLineDetails : TMagScoutLine); Override;
    Procedure HideScoutLine(); Override;
    Procedure SetScoutLineColor(Color : TColor); Override;
    Procedure RefreshScoutLine(); Override;
  End;

Procedure Register;

Implementation

{$R *.dfm}

Uses
  cMag4Vgear,
  cMagIGManager,
  Dialogs,
{$IFDEF USENEWANNOTS}
  fMagAnnot,
{$ELSE}
  //RCA  FmagAnnotation,
  {$IFDEF IGX}
  //RCA  FMagAnnotationIGX,          // dn 04212011
  {$ELSE}
  //RCA   FMagAnnotationIG14,
  {$ENDIF}
{$ENDIF}
  Fmagig14dicomheader,
  FMagIG14PanWindow,
  /// was already above....Forms, {7/12/12 gek Merge 130->129}

  GearPROCESSINGLib_TLB,
  Messages,
  SysUtils,
  Umagutils8
  ;

Procedure Register;
Begin
  RegisterComponents('Imaging', [TMag4VGear14]);
End;

Destructor TMag4VGear14.Destroy;
Begin
  // this ensures the pan window is hidden when the gear control closes
  // (doesn't happen when individual image closes in FullRes but when FullRes
  // viewer closes
  if FPanWindowHolder <> nil then
  begin
    if FPanWindowHolder.PanWindow <> nil then
      FPanWindowHolder.PanWindow.SetVisible(false);
  end;
  {
  If (FrmIG14PanWindow <> Nil) Then
  Begin
    FrmIG14PanWindow.Visible := False;
    FreeAndNil(FrmIG14PanWindow);
  End;
  }
  If FAnnotationComponent <> Nil Then
    FAnnotationComponent.Free();
  FAnnotationComponent := Nil;
  If IGPanCtrl <> Nil Then
    FreeAndNil(IGPanCtrl);
  If IGGuiMagnifierCtrl <> Nil Then
  Begin
    IGGuiMagnifierCtrl.Free();
    IGGuiMagnifierCtrl := Nil;
  End;
  GetIGManager.DecrementComponentCount();
  {Use getIGManagerComponentCount() so that we don't create an IGManager when we
   are trying to determine if it should be destroyed}
  If GetIGManagerComponentCount() <= 0 Then
  Begin
//    showmessage('IG Manager component count is <= 0, destroying IG manager');
    DestroyIGManager();
  End;
  if FScoutLine <> nil then
    FreeAndNil(FScoutLine);
  if FEdgeLine1 <> nil then
    FreeAndNil(FEdgeLine1);
  if FEdgeLine2 <> nil then
    FreeAndNil(FedgeLine2);
  Inherited;
End;

Constructor TMag4VGear14.Create(AOwner: TComponent;
  GearAbilities: TMagGearAbilities = MagGearAbilityRadiology);
Begin
  Inherited;
  Self.Name := '';
  FScoutLineDetails := nil;
  FRotatedCount := 0;
  FFlippedHorizontal := false;
  FFlippedVertical := false;
  GetIGManager.IncrementComponentCount();

  FUpdatePageView := True;
  FDefaultComponentFunctions := [MagAnnotation, MagDICOM, MagDICOMHeader];
  FComponentFunctions := FDefaultComponentFunctions; //[magAnnotation, MagDICOM, MagDICOMHeader];
//  FGearAbilities := MagGearAbilityRadiology;
  FAnnotationComponent := Nil; // default empty value
  IGGuiMagnifierCtrl := Nil;
  If (FGearAbilities = MagGearAbilityClinical) Or (FGearAbilities = MagGearAbilityRadiology) Then
  Begin
    IGGuiMagnifierCtrl := TIGGUIMagnifierCtl.Create(Self);
    IGGuiMagnifierCtrl.SourceView := IGPageViewCtl1.ControlInterface;
    IGGuiMagnifierCtrl.Zoom := 2;
    IGGuiMagnifierCtrl.IsPopUp := True;
    IGGuiMagnifierCtrl.PopUpHeight := 200;
    IGGuiMagnifierCtrl.PopUpWidth := 600;
    IGGuiMagnifierCtrl.PopUpShape := IG_SHAPE_RECTANGLE; // IG_SHAPE_ELLIPSE;

    IGPanCtrl := TIGGUIPanCtl.Create(Self);
    IGPanCtrl.OnTrackDone := PanControlTrackDone;


   {p151  - Stop corrupting the Capture Viewer with Annotations that are never used.}
    if Not GNoAnnots then
      begin
    {/ P122 - JK Create the annotation component for this Gear /}
    FAnnotationComponent := TMagAnnot.Create(Self);
    FAnnotationComponent.IGPageViewCtl := IGPageViewCtl1;
    FAnnotationComponent.InitializeVariables();
      end;  {p151} 

  End;
  If FGearAbilities = MagGearAbilityRadiology Then
  Begin
    MedDataDict := GetIGManager.IGMedCtrl.DataDict;
  End;
  CreatePage();

  FWindowValueMax := 0;
  FLevelValueMax := 0;
  FLevelValueMin := 0;
  FWindowValueMin := 1;

  FHeight := -1;
  FWidth := -1;

  FImageFormat := IG_FORMAT_UNKNOWN;

  FScoutLineColor := clRed; // default to red line
  FScoutLine := TMagLine.Create(self);
  FScoutLine.Visible := false;
  FScoutLine.Parent := IGPageViewCtl1;

  FEdgeLine1 := TMagLine.Create(self);
  FEdgeLine1.Visible := false;
  FEdgeLine1.Parent := IGPageViewCtl1;

  FEdgeLine2 := TMagLine.Create(self);
  FEdgeLine2.Visible := false;
  FEdgeLine2.Parent := IGPageViewCtl1;

  FPanWindowHolder := nil;

  //fline.BringToFront;
End;

Function TMag4VGear14.LoadDICOMData(Var Dicomdata: TDicomData): Boolean;
Var
  DataSet: IGMedElemList;
  VRInfo: IGMedVRInfo;
  CurrentElem: IGMedDataElem;
  ItemIndex, TagIndex: Integer;
  Tag, Data, CurElement: String;
  TagGroup, TagElement: String;
  Temp: String;
  Val: String;
  ParentGroup: Integer;
  PrivateParent: Boolean;
  Len, i: Integer;
Begin
  ParentGroup := 0;
  PrivateParent := False;
  Result := True;
  Dicomdata.DicomDataSource := 'DICOM Header';
  Data := '';
  If Not CurrentMedPage.IsDICOMStructurePresent(MED_STRUCTURE_TYPE_DATASET) Then
  Begin
    Result := False;
//    showmessage('Current image does not contain a DataSet');
    Exit;
  End;
  DataSet := CurrentMedPage.DataSet;
  If DataSet.ElemCount <= 0 Then
  Begin
    Showmessage('DataSet is empty');
    Result := False;
    Exit;
  End;

  Try
    DataSet.MoveFirst(MED_DCM_MOVE_LEVEL_FLOAT);
    CurrentElem := DataSet.CurrentElem;
    For TagIndex := 0 To DataSet.ElemCount - 1 Do
    Begin
      CurElement := '';
      VRInfo := MedDataDict.GetVRInfo(CurrentElem.ValueRepresentation);
      TagGroup := Format('%.4x', [MedDataDict.GetTagGroup(CurrentElem.Tag)]);
      TagElement := Format('%.4x', [MedDataDict.GetTagElement(CurrentElem.Tag)]);

      If DataSet.CurrentLevel = 0 Then
      Begin
        ParentGroup := Strtointdef(TagGroup, 1);
        If (ParentGroup Mod 2) = 0 Then
          PrivateParent := False
        Else
          PrivateParent := True;
      End;

    // ignore elements from private groups and private parent groups
      If Not PrivateParent Then
      Begin

        If TagGroup = '0008' Then
        Begin
          If TagElement = '0016' Then
          Begin
            Dicomdata.SOPClassUid := Trim(CurrentElem.OutputDataToString(0, 1, '\', 100));
          End
          Else
            If TagElement = '0060' Then

            Begin
              Dicomdata.Modality := Trim(CurrentElem.OutputDataToString(0, -1, '\', 100));
            End
            Else
              If TagElement = '1030' Then
              Begin
                Dicomdata.Studydesc := CurrentElem.OutputDataToString(0, -1, '\', 100);
              End
              Else
                If TagElement = '103E' Then
                Begin
                  Dicomdata.SeriesDescription := CurrentElem.OutputDataToString(0, -1, '\', 100);
                End
                Else
                  If TagElement = '2111' Then
                  Begin
                    Dicomdata.Warning := 2;
                  End;
        End
        Else
          If TagGroup = '0010' Then
          Begin
            If TagElement = '0010' Then
            Begin
              Dicomdata.PtName := CurrentElem.OutputDataToString(0, 1, '\', 100);
            End
            Else
              If TagElement = '0020' Then
              Begin
                Dicomdata.PtID := CurrentElem.OutputDataToString(0, 1, '\', 100);
              End
              Else
                If TagElement = '1000' Then
                Begin
                  Temp := CurrentElem.OutputDataToString(0, 1, '\', 100);
                  If Temp <> '' Then
                  Begin
                    Dicomdata.PatientICN := Temp;
                  End;
                End;
          End
          Else
            If TagGroup = '0018' Then
            Begin
              If TagElement = '0050' Then
              Begin
                Temp := CurrentElem.OutputDataToString(0, -1, '^', 100);
                If Temp <> '' Then
                Begin
                  Try
                    Dicomdata.SliceThickness := Strtofloat(Temp);
                  Except
                    On e: Exception Do
                    Begin
              //LogMsg('s','Exception [' + e.Message + '] On Element (' + TagGroup + ',' + TagElement + ')', magmsgWarn);
                      magAppMsg('s', 'Exception [' + e.Message + '] On Element (' +
                        TagGroup + ',' + TagElement + ')', magmsgWarn); 
                    End;
                  End;
                End;
              End
              Else
                If TagElement = '1030' Then
                Begin
                  Temp := CurrentElem.OutputDataToString(0, -1, '\', 100);
                  If Temp <> '' Then
                    Dicomdata.Protocol := Trim(Temp);
                End
                Else
                  If TagElement = '1110' Then //Distance Source to Detector
                  Begin
                    Temp := CurrentElem.OutputDataToString(0, 1, '\', 100);
                    If Temp <> '' Then
                    Begin
                      Try
                        Dicomdata.DistanceSourceToDetector := Strtofloat(Temp);
                      Except
                        On e: Exception Do
                        Begin
               //LogMsg('s','Exception [' + e.Message + '] On Element (' + TagGroup + ',' + TagElement + ')', magmsgWarn);
                          magAppMsg('s', 'Exception [' + e.Message + '] On Element (' +
                            TagGroup + ',' + TagElement + ')', magmsgWarn); 
                        End;
                      End;
                    End;
                  End
                  Else
                    If TagElement = '1111' Then //Distance Patient to Detector
                    Begin
                      Temp := CurrentElem.OutputDataToString(0, 1, '\', 100);
                      If Temp <> '' Then
                      Begin
                        Try
                          Dicomdata.DistancePatientToDetector := Strtofloat(Temp);
                        Except
                          On e: Exception Do
                          Begin
               //LogMsg('s','Exception [' + e.Message + '] On Element (' + TagGroup + ',' + TagElement + ')', magmsgWarn);
                            magAppMsg('s', 'Exception [' + e.Message + '] On Element (' +
                              TagGroup + ',' + TagElement + ')', magmsgWarn); 
                          End;
                        End;
                      End;
                    End
                    Else
                      If TagElement = '1114' Then //Magnificat. Factor
                      Begin
                        Temp := CurrentElem.OutputDataToString(0, 1, '\', 100);
                        If Temp <> '' Then
                        Begin
                          Try
                            Dicomdata.MagnificationFactor := Strtofloat(Temp);
                          Except
                            On e: Exception Do
                            Begin
               //LogMsg('s','Exception [' + e.Message + '] On Element (' + TagGroup + ',' + TagElement + ')', magmsgWarn);
                              magAppMsg('s', 'Exception [' + e.Message + '] On Element (' +
                                TagGroup + ',' + TagElement + ')', magmsgWarn); 
                            End;
                          End;
                        End;
                      End
                      Else
                        If TagElement = '1164' Then //Imager Pixel Spacing
                        Begin
                          Temp := CurrentElem.OutputDataToString(0, -1, '\', 100);
                          Try
                            If Maglength(Temp, '\') > 1 Then
                            Begin
                              Dicomdata.ImagerPixelSpace1 := Strtofloat(MagPiece(Temp, '\', 1));
                              Dicomdata.ImagerPixelSpace2 := Strtofloat(MagPiece(Temp, '\', 2));
                            End
                            Else
                            Begin
                              Dicomdata.ImagerPixelSpace1 := Strtofloat(Temp);
                            End;
                          Except
                            On e: Exception Do
                            Begin
             //LogMsg('s','Exception [' + e.Message + '] On Element (' + TagGroup + ',' + TagElement + ')', magmsgWarn);
                              magAppMsg('s', 'Exception [' + e.Message + '] On Element (' +
                                TagGroup + ',' + TagElement + ')', magmsgWarn); 
                            End;
                          End;
                        End;
            End
            Else
              If TagGroup = '0020' Then
              Begin
                If TagElement = '0010' Then
                Begin
                  Dicomdata.STUDY_ID := CurrentElem.OutputDataToString(0, -1, '\', 100);
                End
                Else
                  If TagElement = '0011' Then
                  Begin
                    Val := CurrentElem.OutputDataToString(0, 1, '\', 100);
                    If Val <> '' Then
                    Begin
                      Try
                        Dicomdata.Seriesno := Strtofloat(Val);
                      Except
                        On e: Exception Do
                        Begin
              //LogMsg('s','Exception [' + e.Message + '] On Element (' + TagGroup + ',' + TagElement + ')', magmsgWarn);
                          magAppMsg('s', 'Exception [' + e.Message + '] On Element (' +
                            TagGroup + ',' + TagElement + ')', magmsgWarn); 
                        End;
                      End;
                    End;
                  End
                  Else
                    If TagElement = '0013' Then
                    Begin
                      Dicomdata.Imageno := CurrentElem.OutputDataToString(0, 1, '\', 100);
                    End
                    Else
                      If TagElement = '0020' Then
                      Begin
                        Temp := CurrentElem.OutputDataToString(0, -1, '^', 100);
                        If Maglength(Temp, '^') > 1 Then
                        Begin
                          Dicomdata.PatOr1 := MagPiece(Temp, '^', 1);
                          Dicomdata.PatOr2 := MagPiece(Temp, '^', 2);
                        End
                        Else
                        Begin
                          Dicomdata.PatOr1 := Temp;
                        End;
                      End
                      Else
                        If TagElement = '0037' Then
                        Begin
                          For i := 0 To CurrentElem.ItemCount - 1 Do
                          Begin
                            Try
                              Dicomdata.ImageOr[i + 1] := Strtofloat(CurrentElem.String_[i]);
                            Except
                              On e: Exception Do
                              Begin
              //LogMsg('s','Exception [' + e.Message + '] On Element (' + TagGroup + ',' + TagElement + ')', magmsgWarn);
                                magAppMsg('s', 'Exception [' + e.Message + '] On Element (' +
                                  TagGroup + ',' + TagElement + ')', magmsgWarn); 
                              End;
                            End;
                          End;
                        End
                        Else
                          If TagElement = '1040' Then
                          Begin
                            Dicomdata.Pos_Ref_Indicator := CurrentElem.OutputDataToString(0, -1, '\', 100);
                          End
                          Else
                            If TagElement = '1041' Then
                            Begin
                              Temp := CurrentElem.OutputDataToString(0, -1, '\', 100);
                              If Temp <> '' Then
                              Begin
                                Try
                                  Dicomdata.SliceLoc := Strtofloat(Temp);
                                Except
                                  On e: Exception Do
                                  Begin
              //LogMsg('s','Exception [' + e.Message + '] On Element (' + TagGroup + ',' + TagElement + ')', magmsgWarn);
                                    magAppMsg('s', 'Exception [' + e.Message + '] On Element (' +
                                      TagGroup + ',' + TagElement + ')', magmsgWarn); 
                                  End;
                                End;
                              End;
                            End;
              End
              Else
                If TagGroup = '0028' Then
                Begin
                  If TagElement = '0002' Then
                  Begin
                    Try
                      Dicomdata.SamplesPerPixel := Strtoint(CurrentElem.OutputDataToString(0, 1, '\', 100));
                    Except
                      On e: Exception Do
                      Begin
            //LogMsg('s','Exception [' + e.Message + '] On Element (' + TagGroup + ',' + TagElement + ')', magmsgWarn);
                        magAppMsg('s', 'Exception [' + e.Message + '] On Element (' +
                          TagGroup + ',' + TagElement + ')', magmsgWarn); 
                      End;
                    End;
                  End
                  Else
                    If TagElement = '0004' Then
                    Begin
                      Dicomdata.Photometric := Trim(CurrentElem.OutputDataToString(0, -1, '\', 100));
                    End
                    Else
                      If TagElement = '0010' Then
                      Begin
                        Try
                          Dicomdata.Rows := Strtoint(CurrentElem.OutputDataToString(0, 1, '\', 100));
                        Except
                          On e: Exception Do
                          Begin
            //LogMsg('s','Exception [' + e.Message + '] On Element (' + TagGroup + ',' + TagElement + ')', magmsgWarn);
                            magAppMsg('s', 'Exception [' + e.Message + '] On Element (' +
                              TagGroup + ',' + TagElement + ')', magmsgWarn); 
                          End;
                        End;
                      End
                      Else
                        If TagElement = '0011' Then
                        Begin
                          Try
                            Dicomdata.Columns := Strtoint(CurrentElem.OutputDataToString(0, 1, '\', 100));
                          Except
                            On e: Exception Do
                            Begin
            //LogMsg('s','Exception [' + e.Message + '] On Element (' + TagGroup + ',' + TagElement + ')', magmsgWarn);
                              magAppMsg('s', 'Exception [' + e.Message + '] On Element (' +
                                TagGroup + ',' + TagElement + ')', magmsgWarn); 
                            End;
                          End;
                        End
                        Else
                          If TagElement = '0030' Then
                          Begin
                            Try
                              Temp := '';
                              Temp := CurrentElem.OutputDataToString(0, -1, '\', 100);
                              If Temp <> '' Then
                              Begin
                                Val := MagPiece(Temp, '\', 1);
                                If Val <> '' Then
                                  Dicomdata.PixelSpace1 := Strtofloat(Val);
                                Val := MagPiece(Temp, '\', 2);
                                If Val <> '' Then
                                  Dicomdata.PixelSpace2 := Strtofloat(Val);
                                Val := MagPiece(Temp, '\', 3);
                                If Val <> '' Then
                                  Dicomdata.PixelSpace3 := Strtofloat(Val);
                              End;
                            Except
                              On e: Exception Do
                              Begin
            //LogMsg('s','Exception [' + e.Message + '] On Element (' + TagGroup + ',' + TagElement + ')', magmsgWarn);
                                magAppMsg('s', 'Exception [' + e.Message + '] On Element (' +
                                  TagGroup + ',' + TagElement + ')', magmsgWarn); 
                              End;
                            End;
                          End
                          Else
                            If TagElement = '0101' Then
                            Begin
                              Try
                                Dicomdata.Bits := Strtoint(CurrentElem.OutputDataToString(0, 1, '\', 100));
                              Except
                                On e: Exception Do
                                Begin
            //LogMsg('s','Exception [' + e.Message + '] On Element (' + TagGroup + ',' + TagElement + ')', magmsgWarn);
                                  magAppMsg('s', 'Exception [' + e.Message + '] On Element (' +
                                    TagGroup + ',' + TagElement + ')', magmsgWarn); 
                                End;
                              End;
                            End
                            Else
                              If TagElement = '0106' Then
                              Begin
                                Try
                                  Dicomdata.Smallest_PixelVal := Strtoint(CurrentElem.OutputDataToString(0, -1, '\', 100));
                                Except
                                  On e: Exception Do
                                  Begin
            //LogMsg('s','Exception [' + e.Message + '] On Element (' + TagGroup + ',' + TagElement + ')', magmsgWarn);
                                    magAppMsg('s', 'Exception [' + e.Message + '] On Element (' +
                                      TagGroup + ',' + TagElement + ')', magmsgWarn); 
                                  End;
                                End;
                              End
                              Else
                                If TagElement = '0107' Then
                                Begin
                                  Try
                                    Dicomdata.Largest_PixelVal := Strtoint(CurrentElem.OutputDataToString(0, -1, '\', 100));
                                  Except
                                    On e: Exception Do
                                    Begin
            //LogMsg('s','Exception [' + e.Message + '] On Element (' + TagGroup + ',' + TagElement + ')', magmsgWarn);
                                      magAppMsg('s', 'Exception [' + e.Message + '] On Element (' +
                                        TagGroup + ',' + TagElement + ')', magmsgWarn); 
                                    End;
                                  End;
                                End
                                Else
                                  If TagElement = '0120' Then // pixel padding value
                                  Begin
        // not used yet
                                  End
                                  Else
                                    If TagElement = '1050' Then
                                    Begin
                                      Try
                                        Dicomdata.Window_Center := Trunc(Strtofloat(MagPiece(CurrentElem.OutputDataToString(0, -1, '\', 100), '\', 1)));
                                      Except
                                        On e: Exception Do
                                        Begin
            // log exception
            //LogMsg('s','Exception [' + e.Message + '] On Element (' + TagGroup + ',' + TagElement + ')', magmsgWarn);
                                          magAppMsg('s', 'Exception [' + e.Message + '] On Element (' +
                                            TagGroup + ',' + TagElement + ')', magmsgWarn); 
//            showmessage('Exception [' + e.Message + '] On Element (' + TagGroup + ',' + TagElement + ')');
//            result := false;
                                        End;
                                      End;
                                    End
                                    Else
                                      If TagElement = '1051' Then
                                      Begin
                                        Try
                                          Dicomdata.Window_Width := Trunc(Strtofloat(MagPiece(CurrentElem.OutputDataToString(0, -1, '\', 100), '\', 1)));
                                        Except
                                          On e: Exception Do
                                          Begin
            //LogMsg('s','Exception [' + e.Message + '] On Element (' + TagGroup + ',' + TagElement + ')', magmsgWarn);
                                            magAppMsg('s', 'Exception [' + e.Message + '] On Element (' +
                                              TagGroup + ',' + TagElement + ')', magmsgWarn); 
            // log exception
//             result := false;
                                          End;
                                        End;
                                      End
                                      Else
                                        If TagElement = '1052' Then //Rescale Intercept
                                        Begin
                                          Try
                                            Dicomdata.Rescale_Int := Trunc(Strtofloat(CurrentElem.OutputDataToString(0, -1, '\', 100)));
                                          Except
                                            On e: Exception Do
                                            Begin
            //LogMsg('s','Exception [' + e.Message + '] On Element (' + TagGroup + ',' + TagElement + ')', magmsgWarn);
                                              magAppMsg('s', 'Exception [' + e.Message + '] On Element (' +
                                                TagGroup + ',' + TagElement + ')', magmsgWarn); 
                                            End;
                                          End;
                                        End
                                        Else
                                          If TagElement = '1053' Then // Rescale Slope
                                          Begin
                                            Try
                                              Dicomdata.Rescale_Slope := Trunc(Strtofloat(CurrentElem.OutputDataToString(0, -1, '\', 100)));
                                            Except
                                              On e: Exception Do
                                              Begin
            //LogMsg('s','Exception [' + e.Message + '] On Element (' + TagGroup + ',' + TagElement + ')', magmsgWarn);
                                                magAppMsg('s', 'Exception [' + e.Message + '] On Element (' +
                                                  TagGroup + ',' + TagElement + ')', magmsgWarn); 
                                              End;
                                            End;
                                          End;

                End;

      End; {private group check}

      DataSet.MoveNext(MED_DCM_MOVE_LEVEL_FLOAT);
    End; { for loop}

  Except
    On e: Exception Do
    Begin
      //LogMsg('s','Exception = ' + e.Message + #13 + 'TagGroup=[' + TagGroup + '], TagElement=[' + TagElement + ']', magmsgError);
      magAppMsg('s', 'Exception = ' + e.Message + #13 +
        'TagGroup=[' + TagGroup + '], TagElement=[' + TagElement + ']', magmsgError); 
      //showmessage('Exception = ' + e.Message + #13 + 'TagGroup=[' + TagGroup + '], TagElement=[' + TagElement + ']');
      Result := False;
    End;
  End;
End;

//p106 rlm 20101124 Fix Garrett's "Fix Window Leveling in Display RadViewer" START
Procedure TMag4VGear14.LoadImage(Filename: String);
Var
  Zoomzoom: IGDisplayZoomInfo;
  DataString: String;
  PageInfo: IGFormatPageInfo;
  dcmSOPClass : string; //p122t7 dmmn 10/23
  dcmManuModelName : string;  //p122t7 dmmn 10/23
  dcmSoftwareVer : string; //p122t7 dmmn 10/23
  dcmP106 : boolean; //p122t7 dmmn 10/23
  resInfo: IGImageResolution; //p122t7 dmmn 10/23
  testmsg : string;
  testi : integer;
    errorRecord : IGResultRecord;
  GsessSkipColorChannel : boolean; {p149 gek .. MAG_DCMView   doesn't login, doesn't have GSess}
Begin
   GsessSkipColorChannel := false;    {/p149} 
   if assigned(Gsess)                 {/p149}  
      then GSessSkipColorChannel :=  GSess.SkipcolorChannel;
      
  DataString := '';
             (* If Not FAnnotationsNeverLoaded Then
              Begin
                If FAnnotationComponent <> Nil Then
                Begin
                { TODO -o129 : These lines were commented out in 122...  do we need something here.}
            //122      FAnnotationComponent.ClearLastAnnotation();
            //122      FAnnotationComponent.MouseUpEvent(1, 1, 1);
                End;
                //122 do something to clear annotations object?
              End;  *)
  CurrentPage.Clear();
  FHeight := -1;
  FWidth := -1;
  // JMW 8/22/08 p72t26 - reset these values before loading the image
  // need to be reset for each image load because when loading full res image
  // from ref image, the clear is not called, but these values change for
  // diagnostic image
  FWindowValueMax := 0;
  FLevelValueMax := 0;
  FLevelValueMin := 0;
  FWindowValueMin := 1;
  FCurrentFilename := '';
  FImageFormat := IG_FORMAT_UNKNOWN;
  // not sure if this needs to be reset... might not have to be done for each image
  FAnnotationsNeverLoaded := True;
  If AnnotationComponent <> Nil Then
    AnnotationComponent.AnnotsModified := False;

  // JMW 10/10/2008 p72t27 - be sure the med contrast is cleared between each
  // image
  If GetIGManager.IGMedCtrl <> Nil Then
  Begin
    // Create Contrast settings structure
      // JMW 10/15/2008 p72t27 - need to create a new MedContrast object with
      // each image, otherwise previous values from previous images will
      // make the current image not view properly
    Try
      MedContrast := GetIGManager.IGMedCtrl.CreateObject(MED_OBJ_CONTRAST) As IIGMedContrast;
    Except
      On e: Exception Do
      Begin
        //LogMsg('s','Exception getting med contrast, ' + e.Message, magmsgError);
        magAppMsg('s', 'Exception getting med contrast, ' + e.Message, magmsgError); 
      End;
    End;
  End;
  If Filename <> '' Then
  Begin
    Try

    // shouldn't this be done elsewhere? shouldn't we handle this better?
      If Not FileExists(Filename) Then
      Begin
        If FUpdatePageView Then IGPageViewCtl1.UpdateView(); // update the view to clear the image
        Exit;
      End;

      CurrentPageDisp.Layout.alignment := IG_DSPL_ALIGN_X_CENTER Or IG_DSPL_ALIGN_Y_CENTER;
      CurrentPageDisp.Layout.UseImageResolution := True; // JMW p72 12/8/2006 - use image resolution for aspect ratio

      IoLocation := GetIGManager.IGFormatsCtrl.CreateObject(IG_FORMATS_OBJ_IOFILE) As IIGIOLocation;
      (IoLocation As IGIOFile).Filename := Filename;



/// ************************ /// *********************

      GetIGManager.IGFormatsCtrl.LoadPageFromFile(CurrentPage, Filename, 0); //dialogLoadOptions.PageNum);


//129 testing   LEAVE COMMENTED OUT code here for now.  Will clean up later. 
  (*    testmsg := ('After LoadPageFromFile : IsOK = ' +  magbooltostr(GetIGManager.IGCoreCtrl.Result.IsOk)
                  + #13 + 'Notification Flags : ' + inttostr(GetIGManager.IGCoreCtrl.result.notificationflags)
                   + #13 + 'Total Record Count : ' + inttostr(GetIGManager.IGCoreCtrl.Result.RecordsTotal) );

      if GetIGManager.IGCoreCtrl.Result.RecordsTotal > 0 then
         For testi := 0 To GetIGManager.IGCoreCtrl.Result.RecordsTotal - 1   do
            begin
            errorRecord := GetIGManager.IGCoreCtrl.Result.GetRecord(testi);
            testmsg := testmsg + #13 + ' error (' +  inttostr(errorRecord.ErrCode) + '):   '  + errorRecord.ExtraText;
            end;
       showmessage(testmsg);
    *)
 //129 testing End


      FPage := 1;
      PageInfo := GetIGManager.IGFormatsCtrl.GetPageInfo(IoLocation, FPage - 1, IG_FORMAT_UNKNOWN);
      FImageFormat := PageInfo.Format;
      FPageCount := GetIGManager.IGFormatsCtrl.GetPageCount(IoLocation, IG_FORMAT_UNKNOWN);

//      showmessage('FMag4VGear14: page count = ' + IntToStr(fpagecount));

    // update the view control to repaint the new active page (from AccuSoft for antialiasing)
    // 7/13/2006
    // JMW 5/6/08 P72 - Turn this off - certain scanned documents in TIF format were displaying
    // very bold. Complaint from Filipe (El Paso) about the images looking too bold and ugly compared to P59.
    // not sure why this was turned on, all images PDF, DICOM PDF, DICOM Report, ECG look fine with this off
    // not sure what turning this off might break...
    //  IGPageViewCtl1.PageDisplay.AntiAliasing.Method := IG_DSPL_ANTIALIAS_SCALE_TO_GRAY + IG_DSPL_ANTIALIAS_COLOR;

    // update the view control to repaint the new active page
      If FUpdatePageView Then
      Begin
        IGPageViewCtl1.UpdateView();
      End;
      Zoomzoom := CurrentPageDisp.GetZoomInfo(IGPageViewCtl1.Hwnd);
      Zoomzoom.Mode := IG_DSPL_ZOOM_H_NOT_FIXED Or IG_DSPL_ZOOM_V_NOT_FIXED;
      FZoomValue := Trunc(Zoomzoom.HZoom * 100.0 * GetZoomFactor());

      If IGPanCtrl <> Nil Then
      Begin

          IGPanCtrl.SetParentImage(GetIGManager.IGCoreCtrl.ComponentInterface,
          GetIGManager.IGDisplayCtrl.ComponentInterface,
          IGPageViewCtl1.PageDisplay, IGPageViewCtl1.Hwnd);

      End;
      FCurrentFilename := Filename;
      FComponentFunctions := FDefaultComponentFunctions;

    {
    // JMW 7/15/08 - Not sure why this was here but it causes the pan window
    // to flash when loading a new image - this doesn't make the new image
    // appear in the pan window since it hasn't been set yet, so this doesn't
    // seem to serve a purpose (not totally sure though)
    if (frmIG14PanWindow <> nil) and (frmIG14PanWindow.Visible) then
    begin
      frmIG14PanWindow.UpdateView();
    end;
    }
    // JMW 4/10/08 Put this here to read info from the header so ImageGear can
    // process the image properly - will only apply to DICOM images
    // this fixes the problem of the image showing bone black when should be bone white

    { JMW 4/11/2008 - not exactly sure/happy with the following code
      It is necessary so that images that are monochrome 1 are shown bone white
      when they should be and those which are monochrome 2 stay bone white and
      don't invert. This code was sent from AccuSoft (ticket # 1-16950).
      Seems to work for all cases, but still not entirely sure its the right way
      to do things.
      Now reading the DICOM header in many places and at many different times.
    }
      If CurrentMedPage.IsDICOMStructurePresent(MED_STRUCTURE_TYPE_DATASET) Then
      Begin
        If CurrentMedPage.DataSet.MoveFind(MED_DCM_MOVE_LEVEL_FIXED, DCM_TAG_PhotometricInterpretation) Then
        Begin
          DataString := CurrentMedPage.DataSet.CurrentElem.String_[0];
          If (AnsiCompareStr(DataString, 'MONOCHROME1 ') = 0) Then
            GetMedContrast()
          Else
            If (AnsiCompareStr(DataString, 'MONOCHROME2 ') = 0) Then
            Begin
              MedContrast.IsInverted := False;
              MedContrast := Nil;
            End;
        End;
        {/p122t7 dmmn fix for 106 dcm images /}
        If CurrentMedPage.DataSet.MoveFind(MED_DCM_MOVE_LEVEL_FLOAT, DCM_TAG_SOPClassUID) Then
          dcmSOPClass := currentMedPage.DataSet.CurrentElem.String_[0];
        If CurrentMedPage.DataSet.MoveFind(MED_DCM_MOVE_LEVEL_FLOAT, DCM_TAG_ManufacturersModelName) Then
          dcmManuModelName := currentMedPage.DataSet.CurrentElem.String_[0];
        If CurrentMedPage.DataSet.MoveFind(MED_DCM_MOVE_LEVEL_FLOAT, DCM_TAG_SoftwareVersions) Then
          dcmSoftwareVer := currentMedPage.DataSet.CurrentElem.String_[0];

        dcmP106 := (Pos('3.0.106', dcmSoftwareVer) >0) or (Pos('3.0.117', dcmSoftwareVer) > 0);

        if ((Trim(dcmSOPClass) = '1.2.840.10008.5.1.4.1.1.77.1.4') and
            (Trim(dcmManuModelName) = 'VistA Imaging Capture') and
            dcmP106) then
        begin
          resInfo := PageInfo.ImageResolution;
//          showmessage(dcmSOPClass + slinebreak +
//                      dcmManumodelName + sLinebreak +
//                      IntToStr(resInfo.XNumerator) + ' / ' + IntToStr(resInfo.XDenominator) + slinebreak +
//                      IntToStr(resInfo.YNumerator) + ' / ' + IntToStr(resInfo.YDenominator));
          resInfo.XNumerator := 0;
          resInfo.XDenominator := 1;
          resInfo.YNumerator := 0;
          resInfo.YDenominator := 1;
          CurrentPage.UpdateImageResolutionFrom(resInfo);
        end;
      End;

//    GetMedContrast();
      If ((CurrentPage.BitDepth >= 8) And (CurrentPage.BitDepth <= 16)) Then
      Begin
        CurrentGrayLUT.ChangeAttrs(CurrentPage.BitDepth, CurrentPage.Signed, 8, False);
      End;
       {7/12/12 gek Merge 130->129}{ASK JERRY  ASK DUC}//gek 9/7/12
      {/p122rgb dmmn 12/8 - separate the single page image in to 3 channels for storage
        only split 24b rgb color single page image and not abstract/}
        {p129t10  Session variable to Stop Splitting color Channel}
      if ((not self.FSkipColorChannel) and (not GSessSkipColorChannel )) then

                 if (FPageCount = 1) and
                 (CurrentPage.BitDepth = 24) and
                 ((AnsiUpperCase(ExtractFileExt(FCurrentFileName)) <> '.ABS') and
                 (AnsiUpperCase(ExtractFileExt(FCurrentFileName)) <> '.PDF')) then
                    begin
                      //p130T9 dmmn 1/31/2013 - add a try block here in case the image cannot be splited (not rasterized images
                      //such as DICOM encapsulated PDF)
                      try
                        GetIGManager.IGProcessingCtrl.SeparateImageChannels(CurrentPage, IG_COLOR_SPACE_RGB);
                        ImageRGBChannelState := 0;   //0 RGB 1 R 2 G 3 B
                        IsOriginalLoadRGB := True;
                        FRChannel := GetIGManager.IGCoreCtrl.CreatePage;
                        FGChannel := GetIGManager.IGCoreCtrl.CreatePage;
                        FBChannel := GetIGManager.IGCoreCtrl.CreatePage;
                      {}{ACCESS Violation in 129}{next line.}//gek 9/7/12
                        (GetIGManager.IGProcessingCtrl.ImageChannels.Item[0] as IIGPage).DuplicateTo(FRChannel);
                        (GetIGManager.IGProcessingCtrl.ImageChannels.Item[1] as IIGPage).DuplicateTo(FGChannel);
                        (GetIGManager.IGProcessingCtrl.ImageChannels.Item[2] as IIGPage).DuplicateTo(FBChannel);
                        ImageRGBDescription := '';
                      except
                        on E : Exception do
                        begin
                          magAppMsg('s', 'Failed to separate color channels for the image.');
                          magAppMsg('s', 'Exception = ' + e.Message , magmsgError);

                          // disable the RGB tool
                          FRChannel := nil;
                          FGChannel := nil;
                          FBChannel := nil;
                          ImageRGBChannelState := -1; // invalid;
                          IsOriginalLoadRGB := False;
                          ImageRGBDescription := '';
                        end;
                      end;
                    end
                    else
                    begin
                      FRChannel := nil;
                      FGChannel := nil;
                      FBChannel := nil;
                      ImageRGBChannelState := -1; // invalid;
                      IsOriginalLoadRGB := False;
                      ImageRGBDescription := '';
                    end;

      {/ P122 - JK 5/27/2011 - Load the art page list based on page count /}
      if FAnnotationComponent <> nil then
      begin
        CreateArtPages(FPageCount);
//        FAnnotationComponent.AssociateArtPageWithImage(FPage-1);    //p122t11 dmmn 1/17 - duplicate work
      end;
   (* p161 patch 161  Greg's issue  single vertical Line.  *)
   (* next two lines are copied and pasted from the 'Reset' function.  Testing showed
      that after this line was run in Reset function,  the Image was Okay  *)
  if IsOriginalLoadRGB then
            RGBChanger(3,true);   // after this , Image is good.

    Except
      On e: Exception Do
      Begin
        //LogMsg('s','error opening file [' + Filename + '] Error=[' + e.Message + ']', magmsgError);
        magAppMsg('s', 'error opening file [' + Filename + '] Error=[' + e.Message + ']', magmsgError); 
        CurrentPage.Clear();
//        IGPageViewCtl1.UpdateView();
      End;
    End;
  End;
End;
//p106 rlm 20101124 Fix Garrett's "Fix Window Leveling in Display RadViewer" END

Procedure TMag4VGear14.GetMedContrast();
Var
  MedMinMax: IGMedMinMax;
  RescalesFound,
    WindowFound: Boolean;
  Str: String;
  Ext: Extended;
  DecSep: Char;

  LUT: IGLUT;
  DataString: String;

Begin
  RescalesFound := False;
  WindowFound := False;
  DecSep := DecimalSeparator;
  DecimalSeparator := '.';
  If (CurrentPage.BitDepth >= 8) And (CurrentPage.BitDepth <= 16) Then
  Begin
    MedMinMax := CurrentMedPage.Processing.GetMinMax;
    If CurrentMedPage.IsDICOMStructurePresent(MED_STRUCTURE_TYPE_DATASET) Then
    Begin
      RescalesFound := True;
      If CurrentMedPage.DataSet.MoveFind(MED_DCM_MOVE_LEVEL_FIXED, DCM_TAG_RescaleSlope) Then
      Begin
        Str := CurrentMedPage.DataSet.CurrentElem.String_[0];
        TextToFloat(PChar(Str), Ext, FvExtended);
        MedContrast.RescaleSlope := Ext;
      End
      Else
        RescalesFound := False;

      If CurrentMedPage.DataSet.MoveFind(MED_DCM_MOVE_LEVEL_FIXED, DCM_TAG_RescaleIntercept) Then
      Begin
        Str := CurrentMedPage.DataSet.CurrentElem.String_[0];
        TextToFloat(PChar(Str), Ext, FvExtended);
        MedContrast.RescaleIntercept := Ext;
      End
      Else
        RescalesFound := False;
            // JMW 10/14/2008 p72t27 - if the image has a rescale type of OD, then
            // we want to ignore the rescale slope and rescale intercept.
            // might want to apply this to TGA images also, not really sure
            // only putting here for now, might need to rethink later...
            // was causing problems with image
      If CurrentMedPage.DataSet.MoveFind(MED_DCM_MOVE_LEVEL_FIXED, DCM_TAG_RescaleType) Then
      Begin
        Str := CurrentMedPage.DataSet.CurrentElem.String_[0];
        If Str = 'OD' Then
        Begin
          RescalesFound := False;
        End;
      End;

            // Modality LUT
      If CurrentMedPage.DataSetLUTExists(Nil, DCM_TAG_ModalityLUTSequence) Then
      Begin
        LUT := CurrentMedPage.GetDataSetLUTCopy(CurrentPresStateMedPage, DCM_TAG_ModalityLUTSequence);
        MedContrast.ModalityLUT.CopyFrom(LUT);
      End;

      WindowFound := True;
      If CurrentMedPage.DataSet.MoveFind(MED_DCM_MOVE_LEVEL_FIXED, DCM_TAG_WindowCenter) Then
      Begin
        Str := CurrentMedPage.DataSet.CurrentElem.String_[0];
        TextToFloat(PChar(Str), Ext, FvExtended);
        MedContrast.WindowCenter := Trunc(Ext);
      End
      Else
        WindowFound := False;

      If CurrentMedPage.DataSet.MoveFind(MED_DCM_MOVE_LEVEL_FIXED, DCM_TAG_WindowWidth) Then
      Begin
        Str := CurrentMedPage.DataSet.CurrentElem.String_[0];
        TextToFloat(PChar(Str), Ext, FvExtended);
        MedContrast.WindowWidth := Trunc(Ext);
      End
      Else
        WindowFound := False;

            // VOI LUT
      If (CurrentMedPage.DataSetLUTExists(Nil, DCM_TAG_VOILUTSequence)) Then
      Begin
        LUT := CurrentMedPage.GetDataSetLUTCopy(CurrentPresStateMedPage, DCM_TAG_VOILUTSequence);
        MedContrast.VOILUT.CopyFrom(LUT);
      End;

            // IsInverted
      MedContrast.IsInverted := False;
      If CurrentMedPage.DataSet.MoveFind(MED_DCM_MOVE_LEVEL_FIXED, DCM_TAG_PhotometricInterpretation) Then
      Begin
        DataString := CurrentMedPage.DataSet.CurrentElem.String_[0];
        If (AnsiCompareStr(DataString, 'MONOCHROME1 ') = 0) Then
        Begin
          MedContrast.IsInverted := True;
        End;
      End;

            // Presentation LUT
      If (CurrentMedPage.DataSetLUTExists(CurrentPresStateMedPage, DCM_TAG_PresentationLutSequence)) Then
      Begin
        LUT := CurrentMedPage.GetDataSetLUTCopy(CurrentPresStateMedPage, DCM_TAG_PresentationLutSequence);
        MedContrast.PresLUT.CopyFrom(LUT);
      End;
    End;

    If ((Not RescalesFound) Or (MedContrast.RescaleSlope = 0)) Then
    Begin
      MedContrast.RescaleSlope := 1;
      MedContrast.RescaleIntercept := 0;
    End;

    If (Not WindowFound) Then
    Begin
      MedContrast.WindowCenter := Trunc(((MedMinMax.Max + MedMinMax.Min) Div 2)
        * MedContrast.RescaleSlope
        + MedContrast.RescaleIntercept);
      MedContrast.WindowWidth := Trunc((MedMinMax.Max - MedMinMax.Min) * MedContrast.RescaleSlope);
    End;
  End;
  DecimalSeparator := DecSep;
End;

Procedure TMag4VGear14.CreatePage();
Begin
  FCurrentFilename := '';
      // create new save and load options
  SaveOptions := GetIGManager.IGFormatsCtrl.CreateObject(IG_FORMATS_OBJ_SAVEOPTIONS) As IIGSaveOptions;
  SaveOptions.Format := IG_SAVE_UNKNOWN;
  LoadOptions := GetIGManager.IGFormatsCtrl.CreateObject(IG_FORMATS_OBJ_LOADOPTIONS) As IIGLoadOptions;
  LoadOptions.Format := IG_FORMAT_UNKNOWN;

    // create new page and page display objects
  CurrentPage := GetIGManager.IGCoreCtrl.CreatePage;
  CurrentPageDisp := GetIGManager.IGDisplayCtrl.CreatePageDisplay(CurrentPage);
    // associate new active page display with page view control
  IGPageViewCtl1.PageDisplay := CurrentPageDisp;

  If GetIGManager.IGMedCtrl <> Nil Then
  Begin
      // create interface for working with medical images
    CurrentMedPage := GetIGManager.IGMedCtrl.CreateMedPage(CurrentPage);
  End;

    // update the view control to repaint the new page
  If FUpdatePageView Then IGPageViewCtl1.UpdateView();

  If GetIGManager.IGMedCtrl <> Nil Then
  Begin
      // Create Contrast settings structure
    MedContrast := GetIGManager.IGMedCtrl.CreateObject(MED_OBJ_CONTRAST) As IIGMedContrast;
  End;

    /// TODO: should this be here?!?!?
//    currentpagedisp.Layout.AspectRatioMode := IG_DSPL_ASPECT_FIXED;   // DON'T KNOW IF THIS SHOULD BE HERE?!!?!?!
  FPageCount := 0;
  FPage := 0;

  CurrentGrayLUT := GetIGManager.IGCoreCtrl.CreateObject(IG_OBJ_LUT) As IIGLUT;
  CurrentPresStatePage := GetIGManager.IGCoreCtrl.CreatePage;
  CurrentPresStateMedPage := GetIGManager.IGMedCtrl.CreateMedPage(CurrentPresStatePage);


End;

Procedure TMag4VGear14.SetView(TheView: EnumIGDsplFitModes);
Var
  Zoomzoom: IGDisplayZoomInfo;
Begin
  Zoomzoom := CurrentPageDisp.GetZoomInfo(IGPageViewCtl1.Hwnd);
  Zoomzoom.Mode := IG_DSPL_ZOOM_H_NOT_FIXED Or IG_DSPL_ZOOM_V_NOT_FIXED;
  CurrentPageDisp.UpdateZoomFrom(Zoomzoom);
  CurrentPageDisp.Layout.FitMode := TheView;
  If FUpdatePageView Then IGPageViewCtl1.UpdateView();
  RefreshZoomValue();
  DrawCurrentScoutLine();
End;

Procedure TMag4VGear14.RefreshZoomValue();
Var
  Zoomzoom: IGDisplayZoomInfo;
  NewVal: Double;
  IVal: Integer;
Begin
  // get the zoom again to udpate the FZoomLevel
  Zoomzoom := CurrentPageDisp.GetZoomInfo(IGPageViewCtl1.Hwnd);
  //FZoomValue := trunc(zoomzoom.HZoom * 100.0);
  NewVal := ((Zoomzoom.HZoom * 100.0)) * GetZoomFactor();
  IVal := Trunc(NewVal);
  FZoomValue := IVal;
End;

Procedure TMag4VGear14.ContrastValue(Value: Integer);
Var
  Fcontrast: Double;
Begin
// don't need to use the value passed to this function since it is set in the inherited function
  Inherited;
  Fcontrast := FContrastPassed;
  Fcontrast := Fcontrast / 100;

  CurrentPageDisp.AdjustContrast(IG_DSPL_ALL_CHANNELS, Fcontrast, Trunc(Fbrightnesspassed / 10), 1.0);
  If FUpdatePageView Then IGPageViewCtl1.UpdateView();
End;

Procedure TMag4VGear14.BrightnessValue(Value: Integer);
Var
  Fcontrast: Double;
Begin
// don't need to use the value passed to this function since it is set in the inherited function
  Inherited;
  Fcontrast := FContrastPassed;
  Fcontrast := Fcontrast / 100;
  CurrentPageDisp.AdjustContrast(IG_DSPL_ALL_CHANNELS, Fcontrast, Trunc(Fbrightnesspassed / 10), 1.0);
  If FUpdatePageView Then IGPageViewCtl1.UpdateView();
End;

Procedure TMag4VGear14.ClearImage();
Begin
  CurrentPage.Clear();
  FCurrentFilename := '';
  FWindowValue := 0;
  FLevelValue := 0;
  FWindowValueMax := 0;
  FLevelValueMax := 0;
  FLevelValueMin := 0;
  FWindowValueMin := 1;
  {
  // JMW 7/17/08 don't hide the pan window - this seems like a bad idea...
  // this is necessary for when the stack viewer is loading a new image,
  // the image is cleared first and this was causing the pan window to open
  // and then close quickly (looked bad and moved)
  if (frmIG14PanWindow <> nil) then
  begin
    if (frmIG14PanWindow.CurImage = self) and
      (frmIG14PanWindow.Visible) and
      frmIG14PanWindow.Visible := false;
  end;
  }
  
  FPrevMouseAction := MactPan; {/p122 dmmn 8/25 - keep track of mouse previous action /}
  FMouseAction := MactPan; // reset to hand pan ? maybe not...

  If FUpdatePageView Then IGPageViewCtl1.UpdateView();
End;

Procedure TMag4VGear14.FlipVert();
var
  DeviceRect: IGRectangle;
  ImageRect: IGRectangle;
Begin
  If Not CurrentPage.IsValid Then Exit;
  GetIGManager.IGProcessingCtrl.Flip(CurrentPage, IG_FLIP_VERTICAL);
 {7/12/12 gek Merge 130->129}
  //p122rgb dmmn 12/12/11 - also flip the channel
  if (FRChannel <> nil) and (FGChannel <> nil) and (FBChannel <> nil) then
  begin
    GetIGManager.IGProcessingCtrl.Flip((FRChannel as IIGPage), IG_FLIP_VERTICAL);
    GetIGManager.IGProcessingCtrl.Flip((FGChannel as IIGPage), IG_FLIP_VERTICAL);
    GetIGManager.IGProcessingCtrl.Flip((FBChannel as IIGPage), IG_FLIP_VERTICAL);
  end;

  {/ P122 - JK 5/10/2011 /}
  if FAnnotationComponent <> nil then  {p151 p161}

  if FAnnotationComponent.ArtPage <> nil then
  begin
    ImageRect := GetIGManager.IGCoreCtrl.CreateObject(IG_OBJ_RECTANGLE) As IGRectangle;
    ImageRect.Top := 0;
    ImageRect.Left := 0;
    ImageRect.Right := CurrentPage.ImageWidth;
    ImageRect.Bottom := CurrentPage.ImageHeight;
    DeviceRect := GetIGManager.IGCoreCtrl.CreateObject(IG_OBJ_RECTANGLE) as IGRectangle;
    DeviceRect.Top := 0;
    DeviceRect.Left := 0;
    DeviceRect.Right := IGPageViewCtl1.Width;
    DeviceRect.Bottom := IGPageViewCtl1.Height;
//    FAnnotationComponent.ArtPage.FlipMarks(IG_FLIP_VERTICAL, ImageRect, DeviceRect);
    FAnnotationComponent.FlipMarks(IG_FLIP_VERTICAL, ImageRect, DeviceRect); //p122t3
  end;

  FFlippedVertical := not FFlippedVertical;

  If FUpdatePageView Then
    IGPageViewCtl1.UpdateView();

  DrawCurrentScoutLine();
End;

procedure TMag4VGear14.FrameResize(Sender: TObject);
begin
  inherited;
  DrawCurrentScoutLine();
end;

Procedure TMag4VGear14.FlipHoriz();
var
  DeviceRect: IGRectangle;
  ImageRect: IGRectangle;
Begin
  If Not CurrentPage.IsValid Then Exit;
  GetIGManager.IGProcessingCtrl.Flip(CurrentPage, IG_FLIP_HORIZONTAL);
 {7/12/12 gek Merge 130->129}
  //p122rgb dmmn 12/12/11 - also flip the channels
  if (FRChannel <> nil) and (FGChannel <> nil) and (FBChannel <> nil) then
  begin
    GetIGManager.IGProcessingCtrl.Flip((FRChannel as IIGPage), IG_FLIP_HORIZONTAL);
    GetIGManager.IGProcessingCtrl.Flip((FGChannel as IIGPage), IG_FLIP_HORIZONTAL);
    GetIGManager.IGProcessingCtrl.Flip((FBChannel as IIGPage), IG_FLIP_HORIZONTAL);
  end;

    if FAnnotationComponent <> nil then
  {/ P122 - JK 5/10/2011 /}
  if FAnnotationComponent.ArtPage <> nil then
  begin
    ImageRect := GetIGManager.IGCoreCtrl.CreateObject(IG_OBJ_RECTANGLE) As IGRectangle;
    ImageRect.Top := 0;
    ImageRect.Left := 0;
    ImageRect.Right := CurrentPage.ImageWidth;
    ImageRect.Bottom := CurrentPage.ImageHeight;
    DeviceRect := GetIGManager.IGCoreCtrl.CreateObject(IG_OBJ_RECTANGLE) as IGRectangle;
    DeviceRect.Top := 0;
    DeviceRect.Left := 0;
    DeviceRect.Right := IGPageViewCtl1.Width;
    DeviceRect.Bottom := IGPageViewCtl1.Height;
//    FAnnotationComponent.ArtPage.FlipMarks(IG_FLIP_HORIZONTAL, ImageRect, DeviceRect);
    FAnnotationComponent.FlipMarks(IG_FLIP_HORIZONTAL, ImageRect, DeviceRect); //p122t3
  end;

  FFlippedHorizontal := not FFlippedHorizontal;

  If FUpdatePageView Then
    IGPageViewCtl1.UpdateView();

  DrawCurrentScoutLine();
End;

Procedure TMag4VGear14.Rotate(Deg: Integer);
var
  DeviceRect: IGRectangle;
  ImageRect: IGRectangle;
Begin
  If Not CurrentPage.IsValid Then
    Exit;
    if FAnnotationComponent <> nil then
  {/ P122 - JK 5/10/2011 /}
  if FAnnotationComponent.ArtPage <> nil then
    FAnnotationComponent.RotateImage(Deg) {/ P122 - JK 5/12/2011 - rotate image and artwork together in FAnnots /}
  else
    GetIGManager.IGProcessingCtrl.Rotate90k(CurrentPage, Deg);
 {7/12/12 gek Merge 130->129}
  //p122rgb dmmn 12/12/11 - also rotate the channels
  if (FRChannel <> nil) and (FGChannel <> nil) and (FBChannel <> nil) then
  begin
    GetIGManager.IGProcessingCtrl.Rotate90k((FRChannel as IIGPage), Deg);
    GetIGManager.IGProcessingCtrl.Rotate90k((FGChannel as IIGPage), Deg);
    GetIGManager.IGProcessingCtrl.Rotate90k((FBChannel as IIGPage), Deg);
  end;

  // JMW 5/30/2013 P131 - Bug fix for TFS #68430
  // the deg value is always positive, rotating -90, deg will be 3. So if currently
  // -90 and rotated -90 again, want to be in position 2 (180) but deg will be 3
  // so need to check for FRotatedCount higher than 4 and reduce it to get the
  // new correct orientation 
  FRotatedCount := FRotatedCount + Deg;
  if FRotatedCount >= 4 then
    FRotatedCount := FRotatedCount - 4;

  If FUpdatePageView Then
    IGPageViewCtl1.UpdateView();

  DrawCurrentScoutLine();
End;

Procedure TMag4VGear14.Inverse;
Begin
  If Not CurrentPage.IsValid Then Exit;
  CurrentPage.ROI.Convert(IG_ROI_ALL_IMAGE);
  GetIGManager.IGProcessingCtrl.ContrastOptions.Mode := IG_CONTRAST_PIXEL;
  GetIGManager.IGProcessingCtrl.InvertContrast(CurrentPage);
 {7/12/12 gek Merge 130->129}
  //p122rgb dmmn 12/12/11 - also invert the channels
  if (FRChannel <> nil) and (FGChannel <> nil) and (FBChannel <> nil) then
  begin
    GetIGManager.IGProcessingCtrl.InvertContrast(FRChannel as IIGPage);
    GetIGManager.IGProcessingCtrl.InvertContrast(FGChannel as IIGPage);
    GetIGManager.IGProcessingCtrl.InvertContrast(FBChannel as IIGPage);
  end;
  If FUpdatePageView Then IGPageViewCtl1.UpdateView();
End;
 {7/12/12 gek Merge 130->129}
{/p122rgb dmmn 12/12/11 - RGB Changer
This method will handle the splitting and merging RBG channel of the selected 24b color image.
@Params CurrentState : will contain the current state of the RGB button. This value will be use
                      together with apply all param
        ApplyAll : will signify that wether or not the action is going to affect all loaded images.
                   If value is true, all image will be chage to the next state of the RGB channel
                   determined by CurrentState
@Return the new state of the RGB button;   /}
function TMag4VGear14.RGBChanger(CurrentState: Integer; ApplyAll : Boolean) : Integer;
var
  ipage : iigpage;
begin
  //p122rgb dmmn 12/8
  Result := 0;
  If Not CurrentPage.IsValid Then Exit;

  if (FRChannel = nil) or (FGChannel = nil) or (FBChannel = nil) then
    Exit;

  if ImageRGBChannelState = -1 then
  begin
    Result := ImageRGBChannelState;
    Exit;
  end;

  try
    //if ApplyAll then
      ImageRGBChannelState := CurrentState;
      
    ImageRGBChannelState := (ImageRGBChannelState + 1) mod 4;
    // copy image channel back to common storage used by universal processing control
    FRChannel.DuplicateTo(GetIGManager.IGProcessingCtrl.ImageChannels.Item[0] as IIGPage);
    FGChannel.DuplicateTo(GetIGManager.IGProcessingCtrl.ImageChannels.Item[1] as IIGPage);
    FBChannel.DuplicateTo(GetIGManager.IGProcessingCtrl.ImageChannels.Item[2] as IIGPage);

    case ImageRGBChannelState of
      0:
      begin
        GetIGManager.IGProcessingCtrl.CombineImageChannels(CurrentPage,IG_COLOR_SPACE_RGB,IG_COLOR_SPACE_RGB);
        ImageRGBDescription := '';
      end;
      1:
      begin
        Ipage := GetIGManager.IGProcessingCtrl.ImageChannels.Item[0] as IIGPage;
        Ipage.DuplicateTo(CurrentPageDisp.Page);
        ImageRGBDescription := '--Red Channel';
      end;
      2:
      begin
        Ipage := GetIGManager.IGProcessingCtrl.ImageChannels.Item[1] as IIGPage;
        Ipage.DuplicateTo(CurrentPageDisp.Page);
        ImageRGBDescription := '--Green Channel';
      end;
      3:
      begin
        Ipage := GetIGManager.IGProcessingCtrl.ImageChannels.Item[2] as IIGPage;
        Ipage.DuplicateTo(CurrentPageDisp.Page);
        ImageRGBDescription := '--Blue Channel';
      end;
    end;

    Result := ImageRGBChannelState;
    IGPageViewCtl1.UpdateView();
  except
    on E:Exception do
      magAppMsg('s','TMag4VGear14.RGBChanger: ' + E.Message);
  end;
end;

Procedure TMag4VGear14.ZoomValue(Value: Integer);
Var
  IGZoomInfo: IGDisplayZoomInfo;
  CurrZoom: Integer;
  InternalZoom: Integer;
Begin
  Inherited;
  IGZoomInfo := CurrentPageDisp.GetZoomInfo(IGPageViewCtl1.Hwnd);
  // JMW 7/7/08 p72t23 - Need to get currZoom with zoom factor in order to
  // accurately compare current value to new desired value
  CurrZoom := Trunc(IGZoomInfo.HZoom * GetZoomFactor() * 100.0);
  // this checks to see if the new value is the same as current.
  // IG14 uses decimal zoom value so often display would say to change zoom when
  // difference was very small, not necessary, just keep what is there

  // JMW 7/1/2008 p72t23
  // new code to set zoom that uses a zoom factor
  // if values are the zoom with the zoom factor included, then do nothing
  If CurrZoom = Value Then
  Exit;
  // if values are different then calculated the new desired internal value
  // and set that value.
  InternalZoom := Trunc(ConvertToInternalZoom(Value));
  IGZoomInfo.HZoom := (InternalZoom / 100);
  IGZoomInfo.VZoom := (InternalZoom / 100);
          {
  // old code to set zoom that doesn't use a zoom factor
  if currZoom = value then exit;
  IGZoomInfo.HZoom := (value / 100);
  IGZoomInfo.VZoom := (value / 100);
           }
  IGZoomInfo.Mode := IG_DSPL_ZOOM_H_FIXED Or IG_DSPL_ZOOM_V_FIXED;
  CurrentPageDisp.UpdateZoomFrom(IGZoomInfo);
  If FUpdatePageView Then IGPageViewCtl1.UpdateView();

  // JMW 6/25/08 - update the pan window if it is visible
  // 7/14/08 - need to call this update even when the pan window is the one
  // that initiated the zoom change so the pan position on the pan window
  // gets updated properly - really stupid...
  if (FPanWindowHolder <> nil) then
        if (FPanWindowHolder.PanWindow <> nil) and (FPanWindowHolder.PanWindow.GetVisible()) then
//  If (FrmIG14PanWindow <> Nil) And (FrmIG14PanWindow.Visible) Then
  Begin
    PanWindowSettings(0, 0, 0, 0);
  End;
  DrawCurrentScoutLine();
End;

Function TMag4VGear14.ConvertToInternalZoom(NormalizedZoom: Integer): Double;
Var
  Factor: Double;
Begin
  Factor := GetZoomFactor();
  If Factor <= 0 Then
    Result := NormalizedZoom
  Else
    // add 0.5 to make sure it rounds up properly if decimal greater than 5
    Result := ((NormalizedZoom / Factor) + 0.5);
End;

Function TMag4VGear14.GetZoomFactor(): Double;
Var
  h, w, Maxdim: Integer;
  PageInfo: IIGFormatPageInfo;
Begin
  Result := 1;
  Try
    If IoLocation = Nil Then Exit;
    // JMW 7/11/08 P72t23
    // this will throw an exception if the file has been deleted from the disk
    // iolocation points to the file on disk which is cleared when the cache
    // is cleaned the file is gone so iolocation points to nothing and throws
    // an exception. The try/catch at least prevents this from being a big
    // problem but not sure of a better way to handle it...
    {
    pageInfo := getIGManager.IGFormatsCtrl.GetPageInfo(IOLocation, FPage - 1, IG_FORMAT_UNKNOWN);
    if pageInfo = nil then
      exit;
    h := pageInfo.DIBInfo.Height;
    w:= pageInfo.DIBInfo.Width;
    }
    // JMW 7/14/08 p72t23 - using the functions getHeight/getWitdh will use
    // the stored FHeight and FWidth values which will reduce the number of
    // times ioLocation is queryied and hopefully prevent these exceptions
    // from occuring after the file has been deleted
    h := GetHeight();
    w := GetWidth();
    If h > w Then
      Maxdim := h
    Else
      Maxdim := w;
    Result := (Maxdim / 1024.0);
  Except
    On e: Exception Do
    Begin
      //LogMsg('s', 'Exception getting zoom factor [' + e.Message + ']', magmsgError);
      magAppMsg('s', 'Exception getting zoom factor [' + e.Message + ']', magmsgError); 
    End;
  End;
End;

Procedure TMag4VGear14.ReDrawImage;
Begin
  If (Owner Is TMag4VGear) Then
  Begin
    //if (owner as tmag4vgear).AbstractImage then currentpagedisp.Layout.fitMode := IG_DSPL_FIT_TO_DEVICE;
    If (Owner As TMag4VGear).ViewStyle = MagGearViewAbs Then CurrentPageDisp.Layout.FitMode := IG_DSPL_FIT_TO_DEVICE;
  End;
  If FUpdatePageView Then IGPageViewCtl1.UpdateView();
End;

{*
  Set the currently displayed page
  @param Value The page to set
}

Procedure TMag4VGear14.SetPage(Const Value: Integer);
Var
  LoadOptions: IGLoadOptions;
Begin
  //TODO: need to set page in annotation tool (if being used) so it can show proper annotations
  If (Value > 0) And (Value <= FPageCount) Then
  Begin
    If (Value <> FPage) Then
    Begin
      LoadOptions := GetIGManager.IGFormatsCtrl.CreateObject(IG_FORMATS_OBJ_LOADOPTIONS) As IIGLoadOptions;
      LoadOptions.Format := FImageFormat;
//      loadOptions.Format := IG_FORMAT_UNKNOWN;
      FPage := Value;
      GetIGManager.IGFormatsCtrl.LoadPage(CurrentPage, IoLocation, FPage - 1, 1, LoadOptions);

        if FAnnotationComponent <> nil then
      {/ P122 - JK 5/28/2011 - connect the right artpage to the newly loaded page /}
      FAnnotationComponent.ConnectArtPage(FPage-1, CurrentPage, CurrentPageDisp);

      // set the window/level values before updating the page (slows things down a lot!)
      FUpdatePageView := False;
      WinLevValue(FWindowValue, FLevelValue);
      FUpdatePageView := True;
      If FUpdatePageView Then
        IGPageViewCtl1.UpdateView();
    End;
  End;
End;

Function TMag4VGear14.GetBitsPerPixel(): Integer;
Begin
 {7/12/12 gek Merge 130->129}{FYI mod in 129  }
{/p129 Get info from loaded image.  Not Dos File.  We don't always have a DOS file.}
  Result := 0;
  if not CurrentPage.IsValid then exit; //p129 ? 
  result := CurrentPage.BitDepth;
  exit;

(*
  If IoLocation = Nil Then Exit;
  If Not CurrentPage.IsValid Then Exit;
  //result := IGFormatsCtl1.GetPageInfo(IOLocation, FPage, IG_FORMAT_UNKNOWN).BitDepth;
  // need to use FPage - 1 since Fpage starts at 1 but IG14 starts pages at 0
  Result := GetIGManager.IGFormatsCtrl.GetPageInfo(IoLocation, FPage - 1, IG_FORMAT_UNKNOWN).BitDepth;
*)
End;

Function TMag4VGear14.GetWidth(): Integer;
Begin
  Result := 0;
  If IoLocation = Nil Then Exit;
  If Not CurrentPage.IsValid Then Exit;
  If FWidth >= 0 Then
  Begin
    Result := FWidth;
    Exit;
  End;
  Try
    Result := GetIGManager.IGFormatsCtrl.GetPageInfo(IoLocation, FPage - 1, IG_FORMAT_UNKNOWN).DIBInfo.Width;
    FWidth := Result;
  Except
    On e: Exception Do
    Begin
      //LogMsg('s', 'Exception getting width [' + e.Message + ']', magmsgError);
      magAppMsg('s', 'Exception getting width [' + e.Message + ']', magmsgError); 
    End;
  End;
End;

Function TMag4VGear14.GetHeight(): Integer;
Begin
  Result := 0;
  If IoLocation = Nil Then Exit;
  If Not CurrentPage.IsValid Then Exit;
  If FHeight >= 0 Then
  Begin
    Result := FHeight;
    Exit;
  End;
  Try
    Result := GetIGManager.IGFormatsCtrl.GetPageInfo(IoLocation, FPage - 1, IG_FORMAT_UNKNOWN).DIBInfo.Height;
    FHeight := Result;
  Except
    On e: Exception Do
    Begin
      //LogMsg('s', 'Exception getting height [' + e.Message + ']', magmsgError);
      magAppMsg('s', 'Exception getting height [' + e.Message + ']', magmsgError); 
    End;
  End;
End;

Procedure TMag4VGear14.FitToWidth;
Begin
  SetView(IG_DSPL_FIT_TO_WIDTH);
End;

Procedure TMag4VGear14.FitToHeight;
Begin
  SetView(IG_DSPL_FIT_TO_HEIGHT);
End;

Procedure TMag4VGear14.FitToWindow;
Begin
  SetView(IG_DSPL_FIT_TO_DEVICE);
End;

Procedure TMag4VGear14.Fit1to1;
Begin
  SetView(IG_DSPL_ACTUAL_SIZE);
End;

Function TMag4VGear14.GetPage: Integer;
Begin
  Result := FPage;
End;

Function TMag4VGear14.GetPageCount: Integer;
Begin
  Result := FPageCount;
End;

Procedure TMag4VGear14.MousePan;
Begin
  UnselectAllAnnotations();
  Inherited;
  IGPageViewCtl1.SelectEvent := IG_VIEW_SELECT_NO;
End;

Procedure TMag4VGear14.Annotations();
Var
  cPoint: IIGPoint;
Begin
  Inherited;
  If FAnnotationsNeverLoaded Then
  Begin
    initializeAnnotations();
  End;
End;

Procedure TMag4VGear14.UnselectAllAnnotations();
Begin
  If (Not FAnnotationsNeverLoaded) And (FAnnotationComponent <> Nil) Then
  Begin
    FAnnotationComponent.UnselectAllMarks();
  End;
End;

Procedure TMag4VGear14.MouseMagnify;
Begin
  UnselectAllAnnotations();
  IGPageViewCtl1.SelectEvent := IG_VIEW_SELECT_NO;
  Inherited;
End;

Procedure TMag4VGear14.RefreshImage;
Var
  Fname: String;
Begin
  Fname := FCurrentFilename;
  Self.ClearImage();
  Self.LoadImage(Fname);
End;

Procedure TMag4VGear14.MouseZoomRect;
Begin
  UnselectAllAnnotations();
  Inherited;
  IGPageViewCtl1.SelectEvent := IG_VIEW_SELECT_FIRE_AND_ZOOM;
End;

Procedure TMag4VGear14.AutoWinLevel;
Begin
  Inherited;
  IGPageViewCtl1.SelectEvent := IG_VIEW_SELECT_FIRE;
End;

Procedure TMag4VGear14.SetZoomWindow(Value: Boolean);
Begin
// do something?
///TODO: setZoomWindow
End;

Procedure TMag4VGear14.SetPanWindow(Value: Boolean);
Begin
  if FPanWindowHolder = nil then
    exit;
  if FPanWindowHolder.PanWindow = nil then
  begin
    FPanWindowHolder.PanWindow := TfrmIG14PanWindow.Create(self);
    FPanWindowHolder.PanWindow.SetPanWindowCloseEvent(FPanWindowClose);
  end;

  {
  If FrmIG14PanWindow = Nil Then
  Begin
    FrmIG14PanWindow := TfrmIG14PanWindow.Create(Self);
    FrmIG14PanWindow.OnPanWindowClose := FPanWindowClose;
  End;
  }
  If Not Value Then
  Begin
    // JMW 7/17/08 p72t23 - check to see if component uses pan window
    // to determine if pan window should be modified
    If (MagPanWindow In FComponentFunctions) Then
      FPanWindowHolder.PanWindow.SetVisible(Value);
      //FrmIG14PanWindow.Visible := Value;
  End;

End;

(*
procedure TMag4VGear14.RasterizeView;
begin
try
	  CurrentPage.Rasterize();    {BM-ImagePrint-  p143 Mod.}
    self.RefreshImage;
  except
    on E:Exception do
    begin
      magAppMsg('s', 'Failed to rasterize the image for printing.');
      magAppMsg('s', 'Exception = ' + e.Message , magmsgError);
      MessageDlg('Failed to rasterize the image for printing.', mtWarning, [mbOK], 0);
      Exit;
    end;
  end;
end;
 *)

Procedure TMag4VGear14.PrintImage(Handle: HDC);  {BM-ImagePrint-  ******}
Var
  CurrentView: EnumIGDsplFitModes;
  OldMode: EnumIGDsplBackgroundModes;
  PARAM: IIGControlParameter;
Begin
  //p130T9 dmmn 2/8/13 - rasterize the image before printing out because
  //non rasterized image will not be printed.
  {    your doing this for all images  ?     did you test the quality of output ? }
  try
 /////Testing - out in 143	if CurrentPage.HasPDFData then //p130t13 - check if image has pdf info only
 ///                             CurrentPage.Rasterize();
 if GPrintOption = magpoRasterize then         {BM-ImagePrint-  p143 Mod.}
    begin
	  CurrentPage.Rasterize();
    GPrintOption := magpoNormal;
    end;
  except
    on E:Exception do
    begin
      magAppMsg('s', 'Failed to rasterize the image for printing.');
      magAppMsg('s', 'Exception = ' + e.Message , magmsgError);
      MessageDlg('Failed to rasterize the image for printing.', mtWarning, [mbOK], 0);
      Exit;
    end;
  end;

  CurrentView := CurrentPageDisp.Layout.FitMode;
  SetView(IG_DSPL_FIT_TO_DEVICE);
  //IGPageViewCtl1.PageDisplay.PrintDirect := true; //true works pretty well, false allows Accusoft to control brightness, etc
  //IGPageViewCtl1.PageDisplay.PrintDirect := false; //then this value was true, it wasn't putting the entire image on the page

  // JMW 8/25/08 p72t26 - changed it back to true because TIF images were
  // being printed extremely huge (made them take a very long time (problem
  // reported by Greg in Charleston).
  // I did testing with many image types and they all seem to work fine...
  // Using old ImageGear we were printing directly to the driver, not allowing
  // ImageGear to handle the printing.
///  Showmessage('ImageGear Printing Image Page');     //testing testtest
  IGPageViewCtl1.PageDisplay.PrintDirect := True;

  // with this value false, makes the image VERY large (MB)

  OldMode := CurrentPageDisp.Background.Mode;
  CurrentPageDisp.Background.Mode := IG_DSPL_BACKGROUND_NONE;

  {
  if isImagePDF() then
  begin
    param := getIGManager().IGFormatsCtrl.Settings.GetFormatRef(IG_FORMAT_PDF).GetParamCopy('PRINT_DEPTH');
    param.Value.Long := 24;
    getIGManager().IGFormatsCtrl.Settings.GetFormatRef(IG_FORMAT_PDF).UpdateParamFrom(param);
  end;
   }

  {/ P122 - JK 9/14/2011 - unselect annotations so the selection marquee does not print /}
  if (AnnotationComponent <> nil) then
    AnnotationComponent.UnselectAllMarks;

  // print the page leaving space for the header
  IGPageViewCtl1.PageDisplay.PrintToPageWithLayout(Handle, 0, 0.02, 1, 0.98); {BM-ImagePrint-  ACTUAL PRINT - *** IMAGEGEAR PRINTS THE IMAGE ****}
  SetView(CurrentView);
  CurrentPageDisp.Background.Mode := OldMode;

End;

procedure TMag4VGear14.PasteFromClipboard();
begin
  ClearImage; //p129
  CurrentPageDisp.PasteFromClipboard; //p129
end; 

Procedure TMag4VGear14.CopyToClipboard();
Var
  Rect: IGRectangle;
  TmpPageCur: IGPage;
Begin
  Rect := GetIGManager.IGCoreCtrl.CreateObject(IG_OBJ_RECTANGLE) As IGRectangle;
  Rect.Top := 0;
  Rect.Left := 0;
  Rect.Right := CurrentPage.ImageWidth;
  Rect.Bottom := CurrentPage.ImageHeight;

  If CurrentPageDisp.Page.ColorSpace <> IG_COLOR_SPACE_RGB Then
  Begin
    TmpPageCur := GetIGManager.IGCoreCtrl.CreatePage();
    CurrentPageDisp.Page.DuplicateTo(TmpPageCur);
    GetIGManager.IGProcessingCtrl.ConvertToColorSpace(CurrentPageDisp.Page, IG_COLOR_SPACE_RGB);
    CurrentPageDisp.CopyToClipboard(Rect);
    TmpPageCur.DuplicateTo(CurrentPageDisp.Page);
    FAnnotationsNeverLoaded := True;
  End
  Else
  Begin
    CurrentPageDisp.CopyToClipboard(Rect);
  End;
End;

Procedure TMag4VGear14.DeSkewAndSmooth;
Begin
  Inherited;
  ///TODO: IG14 - DeSkewAndSmooth
End;

Procedure TMag4VGear14.SmoothImage;
Begin
  Inherited;
  ///TODO: IG14 - SmoothImage
End;

Procedure TMag4VGear14.DeSkewImage;
Begin
  Inherited;
  ///TODO: IG14 - DeSkewImage
  {p129 enable this function.}
  GetIGManager.IGProcessingCtrl.Deskew(currentpage,IG_ROTATE_EXPAND);
End;

procedure TMag4VGear14.DeSpeckleImage;
begin
  inherited;
  {p129 Create and enable this function, needed for capture.}
GetIGManager.IGProcessingCtrl.DeSpeckle(currentpage);
end;

Procedure TMag4VGear14.SetBackgroundColor(Color: TColor);
Var
  ColorValue: Longint;
Begin
  If (Not CurrentPage.IsValid) Then Exit;
  ColorValue := ColorToRGB(Color);        {This calls ColorToRGB from Graphics Unit}

  CurrentPageDisp.Background.Color.RGB_R := ColorValue;
  CurrentPageDisp.Background.Color.RGB_G := ColorValue Shr 8;
  CurrentPageDisp.Background.Color.RGB_B := ColorValue Shr 16;
  If FUpdatePageView Then IGPageViewCtl1.UpdateView();
End;

Procedure TMag4VGear14.MouseReSet;
Begin
  // do what?
  ///TODO: IG14 - MouseReSet
  {/p122t2 dmmn 9/8/11 - reset the mouse to pointer /}
  UnselectAllAnnotations();
  IGPageViewCtl1.SelectEvent := IG_VIEW_SELECT_NO;
  inherited;
End;

Procedure TMag4VGear14.PanWindowSettings(h, w, x, y: Integer);
var
  panWindow : TfrmIG14PanWindow;
  obj : TObject;
Begin
  If Not (MagPanWindow In FComponentFunctions)
    Then  Exit;
  // this really should not happen at this point, it should be initialized
  if FPanWindowHolder = nil then
    exit;
  If CurrentPage.IsValid Then
  Begin
    if FPanWindowHolder.PanWindow <> nil then
    begin
      obj := GetImplementingObject(FPanWindowHolder.PanWindow);
      if obj = nil then
        exit;
      panWindow := (obj as TfrmIG14PanWindow);
      panWindow.Execute(GetIGManager.IGCoreCtrl.ComponentInterface, GetIGManager.IGDisplayCtrl.ComponentInterface, IGPageViewCtl1.PageDisplay,
      IGPageViewCtl1.Hwnd, h, w, x, y, Self);
      FPanWindowHolder.PanWindow.SetPanWindowCloseEvent(FPanWindowClose);
    end;
    { Display each click, PanWinError}
    {
    FrmIG14PanWindow.Execute(GetIGManager.IGCoreCtrl.ComponentInterface, GetIGManager.IGDisplayCtrl.ComponentInterface, IGPageViewCtl1.PageDisplay,
      IGPageViewCtl1.Hwnd, h, w, x, y, Self);
    // JMW 7/14/08 p72t23 - set pan window close event to this viewer
    FrmIG14PanWindow.OnPanWindowClose := FPanWindowClose; // PanWindowCloseEvent;
    }
  End;
End;

Procedure TMag4VGear14.SetUpdateGUI(Value: Boolean);
Begin
  //TODO?
End;

Procedure TMag4VGear14.SetSettingMode(Mode: Integer);
Begin
  //TODO?
End;

Procedure TMag4VGear14.SetSettingValue(Value: Integer);
Begin
  //TODO?
End;

Procedure TMag4VGear14.SetPrintSize(Value: Integer);
Begin
  //todo?
End;

Procedure TMag4VGear14.WinLevValue(WinValue, LevValue: Integer);
Var
  Min, Max: Longint;
  Width, Center: Longint;
  PixPadSettings: IGMedPixPaddingSettings;
Begin
  {/ P122 - JK 1/23/2012 - added Try-Except to detect an issue in Fayetteville during P122 Alpha testing /}
  try
  //LogMsg('s','Applying Window value [' + inttostr(WinValue) + '], Lev Value [' + inttostr(LevValue) + '] to IG14 image', MagLogDEBUG);
  magAppMsg('s', 'Applying Window value [' +
    Inttostr(WinValue) + '], Lev Value [' + Inttostr(LevValue) + '] to IG14 image', MagmsgDebug); 
  If Not (MagWinLev In FComponentFunctions) Then Exit;
  If (FWindowValueMax = 0) Or (FLevelValueMax = 0) Then
    CalculateMaxWinLev();
  If MedContrast = Nil Then
    MedContrast := GetIGManager.IGMedCtrl.CreateObject(MED_OBJ_CONTRAST) As IIGMedContrast; ///

  Min := LevValue - Round(WinValue / 2);
  Max := LevValue + Round(WinValue / 2);
  Width := (Max - Min);
  Center := Trunc((Max + Min) / 2);

  {JW Fix for WinLev #3}
  If ((CurrentPage.ColorSpaceIDGet() And IG_COLOR_SPACE_ID_ColorMask) = IG_COLOR_SPACE_ID_I) And CurrentPage.ImageIsGray Then
    GetIGManager().IGProcessingCtrl.ConvertToGray(CurrentPage);

  PixPadSettings := CurrentMedPage.Display.GetPixPaddingSettings;
  PixPadSettings.UsePixPadding := False;

  MedContrast.WindowCenter := Center;
  MedContrast.WindowWidth := Width;

  GetIGManager.IGMedCtrl.BuildGrayscaleLUT(MedContrast, PixPadSettings, CurrentGrayLUT);
  CurrentPage.UpdateGrayscaleLUTFrom(CurrentGrayLUT);

  FWindowValue := MedContrast.WindowWidth;
  FLevelValue := MedContrast.WindowCenter;

  If FUpdatePageView Then
    IGPageViewCtl1.UpdateView();
  except
    on E:Exception do
      magappmsg(magmsglvlERROR, 'TMag4VGear14.WinLevValue: WinValue=[' +
        IntToStr(WinValue) + '] LevValue=[' +
        IntToStr(LevValue) + '] Exception = ' + E.Message);

  end;
End;

procedure TMag4VGear14.IGPageViewCtl1AfterDraw(ASender: TObject; hDC: Integer);
begin
  inherited;
  //IGPageViewCtl1.DrawEvent := IG_VIEW_DRAW_EVENT_NO;
  //DrawCurrentScoutLine();
end;

Procedure TMag4VGear14.IGPageViewCtl1MouseDblClick(Sender: Tobject; Button,
  Shift: Smallint; x, y: Integer);
Begin
  Inherited;

  {/ P122 - JK 10/19/2011 - rare case but did get access violation because AnnotationComponent was nil /}
  if AnnotationComponent = nil then
    Exit;
  {/p122t6 dmmn 10/15 - disable double click on image while in annotation mode /}
  if AnnotationComponent.Visible then
    Exit;

  If Assigned(OnImageDblClick) Then
  Begin
    OnImageDblClick(Self);
  End;
End;

Procedure TMag4VGear14.IGPageViewCtl1MouseDown(Sender: Tobject; Button,
  Shift: Smallint; x, y: Integer);
Var
  aButton: TMouseButton;
  aShift: TShiftState;
  nMessage: Integer;
Begin
  Inherited;

  aButton := GetMouseButton(Button);
  aShift := GetShiftState(Shift);
  // don't know why this is needed... wants a shift state based on button...
  // shift state needs to be left or right, not include other things

  {JMW 2/12/08 P72 - need to include the ssleft/ssright with the actual shift state
  always need ssleft/ssright}
  If aButton = Mbleft Then
    aShift := aShift + [Ssleft];
  If aButton = Mbright Then
    aShift := {aShift +} [Ssright];

{$IFDEF USENEWANNOTS}
  {/p122 dmmn 8/25/11 - check to see if the user is in annotation mode (with toolbar visible) or not,
  if not set the mouse action to previous action /}
  if (AnnotationComponent <> nil) and (Not AnnotationComponent.Visible) then
  begin
    if (FMouseAction = MactAnnotation) or (FMouseAction = MactAnnotationPointer) then
      FMouseAction := FPrevMouseAction;
    if (FMouseAction = MactZoomRect) then
      IGPageViewCtl1.SelectEvent := IG_VIEW_SELECT_FIRE_AND_ZOOM;
  end;

  If (FMouseAction = MactAnnotation) Or
     (FMouseAction = MactMeasure) Or
     (FMouseAction = MactAnnotationPointer) Or
     (FMouseAction = MactProtractor) Then
  Begin
    If Not CurrentPage.IsValid Then Exit;

    IGPageViewCtl1.SelectEvent :=  IG_VIEW_SELECT_NO; 

    AnnotationComponent.CurrentPoint.XPos := x;
    AnnotationComponent.CurrentPoint.YPos := y;
    nMessage := WM_LBUTTONDOWN;
    If (Button = 2) Then nMessage := WM_RBUTTONDOWN;
//    AnnotationComponent.IGArtXGUICtl.MouseDown(AnnotationComponent.IGArtDrawParams, nMessage, AnnotationComponent.CurrentPoint);
    AnnotationComponent.IGPageViewCtlMouseDown(Sender,Button,Shift,x, y);
    Exit;
  End;

  (*

  If (FMouseAction = MactAnnotation) Or (FMouseAction = MactMeasure) Or (FMouseAction = MactAnnotationPointer) Or (FMouseAction = MactProtractor) Then
  Begin
    If Not CurrentPage.IsValid Then Exit;
    AnnotationComponent.IGPageViewCtlMouseDown(Sender,Button,Shift,x, y);
    Exit;
  End;
  *)
{$ELSE}
  If (FMouseAction = MactAnnotation) Or (FMouseAction = MactMeasure) Or (FMouseAction = MactAnnotationPointer) Or (FMouseAction = MactProtractor) Then
  Begin
    // only pass the mousedown event to the gear control if it is not button 2
    If Button <> 2 Then
    Begin
      If Assigned(OnImageMouseDown) Then
      Begin
        OnImageMouseDown(Owner, aButton, aShift, x, y);
      End;
    End;
    If Not CurrentPage.IsValid Then Exit;
    If ((FMouseAction = MactMeasure) Or (FMouseAction = MactProtractor)) And (Button = 2) Then
    Begin
      FMouseAction := MactAnnotationPointer;
      If Assigned(OnImageToolChange) Then
        OnImageToolChange(Self, FMouseAction);
    End;

    AnnotationComponent.MouseDownEvent(Button, x, y);

    Exit;
  End;
{$ENDIF}
                 // this code doesn't work
  If (aButton = Mbleft) And (CurrentPage.IsValid) Then
  Begin
    If FMouseAction = MactPan Then // hand panning
    Begin
      If IGPanCtrl <> Nil Then
      Begin
        IGPanCtrl.TrackMouse(x, y);            {Display  PanWinError}
      End;
//      exit;  // THIS CANNOT BE HERE!!!!
    End
    Else
      If FMouseAction = MactMagnify Then // mouse magnify
      Begin
      // not sure if this should be here
      // this causes the image to be selected when they use the magnify (if coming from another image)
        If Assigned(OnImageMouseDown) Then
        Begin
          OnImageMouseDown(Owner, aButton, aShift, x, y);
        End;

        If IGPageViewCtl1.PageDisplay.Page.IsValid Then
        Begin
          If IGGuiMagnifierCtrl = Nil Then Exit;
          IGGuiMagnifierCtrl.Initialize(GetIGManager.IGCoreCtrl.ComponentInterface, GetIGManager.IGDisplayCtrl.ComponentInterface);
          IGGuiMagnifierCtrl.StartMouseTracking(x, y);
          Exit;
        End;
      End
      Else
        If FMouseAction = MactZoomRect Then
        Begin
          Application.Processmessages();
      // do nothing here...
          Exit;
        End
        Else
          If FMouseAction = MactWinLev Then
          Begin
      // do auto window level
      // done in SelectEvent

          End;
  End;
  If Assigned(OnImageMouseDown) Then
  Begin
    OnImageMouseDown(Owner, aButton, aShift, x, y);             {Display, this is defined PanWinError }
  End;
End;

Procedure TMag4VGear14.IGPageViewCtl1MouseUp(Sender: Tobject; Button,
  Shift: Smallint; x, y: Integer);
Var
  aButton: TMouseButton;
  aShift: TShiftState;
  Point : IGPoint;
  originalPoint, rotatedPoint : TMagPoint;
Begin
  Inherited;
{$IFDEF USENEWANNOTS}
  If (FMouseAction = MactAnnotation) Or (FMouseAction = MactMeasure) Or (FMouseAction = MactAnnotationPointer) Or (FMouseAction = MactProtractor) Then
  Begin
    If Not CurrentPage.IsValid Then Exit;
    AnnotationComponent.IGPageViewCtlMouseUp(Sender, Button, Shift, x, y);
    Exit;
  End;
{$ELSE}
  If (FMouseAction = MactAnnotation) Or (FMouseAction = MactMeasure) Or (FMouseAction = MactAnnotationPointer) Or (FMouseAction = MactProtractor) Then
  Begin
    If Not CurrentPage.IsValid Then Exit;
    Self.AnnotationComponent.MouseUpEvent(Button, x, y);
    Exit;
  End;
{$ENDIF}

  IGPageViewCtl1.SelectEvent := IG_VIEW_SELECT_NO;

  If (FMouseAction = MactZoomRect) {or (FMouseAction = mactWinLev)} Then
  Begin
    //FMouseAction := mactPan;   // this resets the tool to handpan after doing the zoom
    RefreshZoomValue();
    IGPageViewCtl1.SelectEvent := IG_VIEW_SELECT_FIRE_AND_ZOOM;
    If Assigned(FImageZoomChange)
       Then       FImageZoomChange(Self, FZoomValue);
    UpdateScrollPos();
    If Assigned(FImageUpdateImageState)
       Then      FImageUpdateImageState(Self);
  End;
  If FMouseAction = MactWinLev Then
  Begin
    IGPageViewCtl1.SelectEvent := IG_VIEW_SELECT_FIRE;
  End;

  // JMW 6/25/08 - update the pan window if it is visible
//  If (FrmIG14PanWindow <> Nil) And (FrmIG14PanWindow.Visible) Then
  if (FPanWindowHolder <> nil) and
      (FPanWindowHolder.PanWindow <> nil) and
      (FPanWindowHolder.PanWindow.GetVisible()) then
  Begin
    PanWindowSettings(0, 0, 0, 0);             {Display Each Mouse Up ,  Not Capture.   PanWinError}
  End;

  If Assigned(OnImageMouseUp) Then
  Begin
    aButton := GetMouseButton(Button);
    aShift := GetShiftState(Shift);
    // don't know why this is needed... wants a shift state based on button...
    If aButton = Mbleft Then
      aShift := {aShift +} [Ssleft];
    If aButton = Mbright Then
      aShift := {aShift +} [Ssright];

    // JMW 4/22/2013 P131 - the X and Y coordinates are of the IGPageViewCtrl
    // and not on the image, converting the X, Y points to the actual image
    // locations and providing that in the event
    // Scout lines need the point on the image the user clicked, not the
    // point on the control
    Point := GetIGManager.IGCoreCtrl.CreateObject(IG_OBJ_POINT) As IIGPoint;
    Point.XPos := x;
    point.YPos := y;
    CurrentPageDisp.ConvertPointCoordinates(IGPageViewCtl1.Hwnd, 0, Point, IG_DSPL_CONV_DEVICE_TO_IMAGE);
    // JMW 5/3/2013 p131
    // need to get the original location of the point and not the rotated location
    originalPoint := TMagPoint.Create(Point.XPos, point.YPos);
    rotatedPoint := getUnRotatedPoint(originalPoint);

    //OnImageMouseUp(Self, aButton, aShift, point.xpos, point.ypos);
    OnImageMouseUp(Self, aButton, aShift, rotatedPoint.x, rotatedPoint.y);
    FreeAndNil(originalPoint);
    FreeAndNil(rotatedPoint);
  End;
End;

Procedure TMag4VGear14.SetOrientation(Orientation: TMagImageOrientation);
Begin
  Case Orientation Of
    BottomLeft: CurrentPageDisp.Orientation := IG_DSPL_ORIENT_BOTTOM_LEFT;
    BottomRight: CurrentPageDisp.Orientation := IG_DSPL_ORIENT_BOTTOM_RIGHT;
    LeftBottom: CurrentPageDisp.Orientation := IG_DSPL_ORIENT_LEFT_BOTTOM;
    LeftTop: CurrentPageDisp.Orientation := IG_DSPL_ORIENT_LEFT_TOP;
    RightBottom: CurrentPageDisp.Orientation := IG_DSPL_ORIENT_RIGHT_BOTTOM;
    RightTop: CurrentPageDisp.Orientation := IG_DSPL_ORIENT_RIGHT_TOP;
    TopLeft: CurrentPageDisp.Orientation := IG_DSPL_ORIENT_TOP_LEFT;
    TopRight: CurrentPageDisp.Orientation := IG_DSPL_ORIENT_TOP_RIGHT;
  End;
  IGPageViewCtl1.UpdateView();
End;

Function TMag4VGear14.IsSigned(): Boolean;
Begin
  Result := CurrentPage.Signed;
End;

function TMag4VGear14.IsValidImage: Boolean;      //p129
begin
 Result := currentpage.IsValid;
end;

Procedure TMag4VGear14.PromoteColor(ColorValue: TMagImagePromoteValue);
Begin
  Case ColorValue Of
    PROMOTE_TO_4: GetIGManager.IGProcessingCtrl.Promote(CurrentPage, IG_PROMOTE_TO_4);
    PROMOTE_TO_8: GetIGManager.IGProcessingCtrl.Promote(CurrentPage, IG_PROMOTE_TO_8);
    PROMOTE_TO_24: GetIGManager.IGProcessingCtrl.Promote(CurrentPage, IG_PROMOTE_TO_24);
    PROMOTE_TO_32: GetIGManager.IGProcessingCtrl.Promote(CurrentPage, IG_PROMOTE_TO_32);
  End;
End;

Procedure TMag4VGear14.CopyToClipboardRadiology();
Begin
// this causes an exception!
//  currentMedPage.Processing.ReduceWithDisplayLUT();

  IGPageViewCtl1.UpdateView();
  // not sure if this is right?
  CopyToClipboard();
End;

Procedure TMag4VGear14.IGPageViewCtl1SelectEvent(Sender: Tobject;
  Var LplLeft, LplTop, LplRight, LplBottom: Integer);
Var
  Width, Height: Integer;
  MedMinMax: IGMedMinMax;

  Point1, Point2: IGPoint;
  aButton: TMouseButton;
  aShift: TShiftState;
  PixPadSettings: IGMedPixPaddingSettings;
Begin
  Inherited;
  If FMouseAction = MactWinLev Then
  Begin
    If MedContrast = Nil Then
      MedContrast := GetIGManager().IGMedCtrl.CreateObject(MED_OBJ_CONTRAST) As IIGMedContrast; ///

    Point1 := GetIGManager.IGCoreCtrl.CreateObject(IG_OBJ_POINT) As IIGPoint;
    Point2 := GetIGManager.IGCoreCtrl.CreateObject(IG_OBJ_POINT) As IIGPoint;

    Point1.XPos := LplLeft;
    Point1.YPos := LplTop;

    Point2.XPos := LplRight;
    Point2.YPos := LplBottom;

    CurrentPageDisp.ConvertPointCoordinates(IGPageViewCtl1.Hwnd, 0, Point1, IG_DSPL_CONV_DEVICE_TO_IMAGE);
    CurrentPageDisp.ConvertPointCoordinates(IGPageViewCtl1.Hwnd, 0, Point2, IG_DSPL_CONV_DEVICE_TO_IMAGE);

    Width := Point2.XPos - Point1.XPos;
    Height := Point2.YPos - Point1.YPos;
    If Height < 0 Then
      Height := Point1.YPos - Point2.YPos;

    CurrentPage.ROI.Convert(IG_ROI_RECT);
    CurrentPage.ROI.Left := Point1.XPos;
    CurrentPage.ROI.Top := Point1.YPos;
    CurrentPage.ROI.Width := Width;
    CurrentPage.ROI.Height := Height;

    {JW Fix for WinLev #3}
    If ((CurrentPage.ColorSpaceIDGet() And IG_COLOR_SPACE_ID_ColorMask) = IG_COLOR_SPACE_ID_I) And CurrentPage.ImageIsGray Then
      GetIGManager().IGProcessingCtrl.ConvertToGray(CurrentPage);

    MedMinMax := CurrentMedPage.Processing.GetMinMax;

    MedContrast.WindowCenter := Trunc(((MedMinMax.Max + MedMinMax.Min) Div 2)
      * MedContrast.RescaleSlope
      + MedContrast.RescaleIntercept);
    MedContrast.WindowWidth := Trunc((MedMinMax.Max - MedMinMax.Min) * MedContrast.RescaleSlope);

    PixPadSettings := CurrentMedPage.Display.GetPixPaddingSettings;
    PixPadSettings.UsePixPadding := False;
    MedContrast.AutoAdjustFrom(CurrentPage);

    GetIGManager.IGMedCtrl.BuildGrayscaleLUT(MedContrast, PixPadSettings, CurrentGrayLUT);
    CurrentPage.UpdateGrayscaleLUTFrom(CurrentGrayLUT);

    FWindowValue := MedContrast.WindowWidth;
    FLevelValue := MedContrast.WindowCenter;

    IGPageViewCtl1.UpdateView();

    // call image mouse down event to force the toolbar to be updated with new
    // window/level values (if connected properly)
    If Assigned(OnImageMouseDown) Then
    Begin
      aButton := Mbleft;
      aShift := [Ssleft];
      OnImageMouseDown(Self, aButton, aShift, LplLeft, LplTop);
    End;
    If Assigned(OnImageWinLevChange) Then
      OnImageWinLevChange(Self, FWindowValue, FLevelValue);
  End;
End;

Procedure TMag4VGear14.IGPageViewCtl1MouseMove(Sender: Tobject; Button,
  Shift: Smallint; x, y: Integer);
Var
  aButton: TMouseButton;
  aShift: TShiftState;
Begin
  Inherited;
{$IFDEF USENEWANNOTS}
  If (FMouseAction = MactAnnotation) Or (FMouseAction = MactMeasure) Or (FMouseAction = MactAnnotationPointer) Or (FMouseAction = MactProtractor) Then
  Begin
    If Not CurrentPage.IsValid Then Exit;
    AnnotationComponent.IGPageViewCtlMouseMove(Sender, Button, Shift, x, y);
    Exit;
  End;
{$ENDIF}
  If Assigned(OnImageMouseMove) Then
  Begin
    aButton := GetMouseButton(Button);
    aShift := GetShiftState(Shift);
    // don't know why this is needed... wants a shift state based on button...
    If aButton = Mbleft Then
      aShift := {aShift +} [Ssleft];
    If aButton = Mbright Then
      aShift := {aShift +} [Ssright];
    OnImageMouseMove(Self, aButton, aShift, x, y);
  End;
End;

Procedure TMag4VGear14.SetImagePointer(Value: TMagImageMousePointer);
Begin
  Inherited;
  Case Value Of
    MagImagePointerDefault:
      Begin
        IGPageViewCtl1.MousePointer := 0;
      End;
    MagImagePointerArrow:
      Begin
        IGPageViewCtl1.MousePointer := 1;
      End;
    MagImagePointerCrossHair:
      Begin
        IGPageViewCtl1.MousePointer := 2;
      End;
  End;
End;
{p129}
function TMag4VGear14.GetScrollInfo: TMagScrollInfo;
var ScrollAttrs : IIGDisplayScrollInfo  ;
begin
 result := TMagScrollInfo.Create;
 ScrollAttrs := CurrentPageDisp.GetScrollAttrs(IGPageViewCtl1.Hwnd);
 //  Horizontal Settings. 
 Result.H_Line := ScrollAttrs.H_Line;
 Result.H_Max  := ScrollAttrs.H_Max;
 Result.H_Min  := ScrollAttrs.H_Min;
 Result.H_Page := ScrollAttrs.H_Page;
 Result.H_Pos  := ScrollAttrs.H_Pos;
 // Vertical Settings.
 Result.V_Line := ScrollAttrs.V_Line;
 Result.V_Max  := ScrollAttrs.V_Max;
 Result.V_Min  := ScrollAttrs.V_Min;
 Result.V_Page := ScrollAttrs.V_Page;
 Result.V_Pos  := ScrollAttrs.V_Pos;
end;

Function TMag4VGear14.GetShiftState(Shift: Smallint): TShiftState;
Var
  Res: Integer;
  SHIFT_KEY, CTRL_KEY, ALT_KEY: Integer;
Begin
  SHIFT_KEY := 1;
  CTRL_KEY := 2;
  ALT_KEY := 4;

  Res := (Shift And SHIFT_KEY);
  If (Res = SHIFT_KEY) Then
    Result := Result + [SsShift];
  Res := (Shift And CTRL_KEY);
  If (Res = CTRL_KEY) Then
    Result := Result + [Ssctrl];
  Res := (Shift And ALT_KEY);
  If (Res = ALT_KEY) Then
    Result := Result + [SsAlt];
End;

//TMouseButton

Function TMag4VGear14.GetMouseButton(Button: Smallint): TMouseButton;
Begin
  Result := Mbleft;
  Case Button Of
    1:
      Begin
        Result := Mbleft;
      End;
    2:
      Begin
        Result := Mbright;
      End;
    3:
      Begin
        Result := MbMiddle;
      End;
  End;

End;

Function TMag4VGear14.GetFileFormat(): String;
Var
  PageInfo: IGFormatPageInfo;
Begin
  Try
    PageInfo := GetIGManager.IGFormatsCtrl.GetPageInfo(IoLocation, FPage - 1, IG_FORMAT_UNKNOWN);
    Result := GetIGManager.IGFormatsCtrl.Settings.GetFormatRef(PageInfo.Format).Fullname;
  Except
    On e: Exception Do
    Begin
      //LogMsg('', 'Exception getting file format: ' + e.Message, magmsgError);
      magAppMsg('', 'Exception getting file format Fullname: ' + e.Message, magmsgError); 
      Result := 'Unknown';
    End;
  End;
End;
{p129}
function TMag4VGear14.GetFileFormatAbbr: string;
Var
  PageInfo: IGFormatPageInfo;
Begin
  Try
    PageInfo := GetIGManager.IGFormatsCtrl.GetPageInfo(IoLocation, FPage - 1, IG_FORMAT_UNKNOWN);
    if pageinfo = nil  then
      begin
        result := '';
        exit;
      end;
    Result := GetIGManager.IGFormatsCtrl.Settings.GetFormatRef(PageInfo.Format).name;
  Except
    On e: Exception Do
    Begin
      //LogMsg('', 'Exception getting file format: ' + e.Message, magmsgError);
      magAppMsg('', 'Exception getting file format Name: ' + e.Message, magmsgError); 
      Result := 'Unknown';
    End;
  End;
End;
{p129}
function TMag4VGear14.GetFileFormatID: integer;
Var
  PageInfo: IGFormatPageInfo;
Begin
  Try
    PageInfo := GetIGManager.IGFormatsCtrl.GetPageInfo(IoLocation, FPage - 1, IG_FORMAT_UNKNOWN);
    Result := GetIGManager.IGFormatsCtrl.Settings.GetFormatRef(PageInfo.Format).ID;
  Except
    On e: Exception Do
    Begin
      //LogMsg('', 'Exception getting file format: ' + e.Message, magmsgError);
      magAppMsg('', 'Exception getting file format ID ' + e.Message, magmsgError); 
      Result := 0 ;
    End;
  End;
End;

{ This function updates the image resolution for non-DICOM images that
 ImageGear cannot automatically load from the DICOM header. This applies the
 values from the TXT file so measurements can accurately be calculated.
}

Function TMag4VGear14.UpdateImageResolution(Dicomdata: TDicomData): Boolean;
Var
  ImgResolution: IIGImageResolution;
  XDenom, YDenom: Integer;
  ApplyUpdates: Boolean;
Begin
  Try
    Result := False;
    ImgResolution := CurrentPage.GetImageResolutionCopy;
    ApplyUpdates := False;

    XDenom := 0;
    YDenom := 0;

    // if the header contains the Imager Pixel Spacing (0018,1164) values
    If (Dicomdata.ImagerPixelSpace1 > 0.0) And (Dicomdata.ImagerPixelSpace2 > 0.0) Then
    Begin
      YDenom := Trunc(Dicomdata.ImagerPixelSpace1 * 100000.0);
      XDenom := Trunc(Dicomdata.ImagerPixelSpace2 * 100000.0);
      AdjustForDownsizedImage(XDenom, YDenom, Dicomdata);

      // Check for the modification Factor value (0018,1114)
      If Dicomdata.MagnificationFactor > 0.0 Then
      Begin
        XDenom := Trunc(XDenom / Dicomdata.MagnificationFactor);
        YDenom := Trunc(YDenom / Dicomdata.MagnificationFactor);
      End
      Else
      Begin
        // check for the Distance to Source (0018,1110) and Distance to patient (0018,1111) values
        If (Dicomdata.DistancePatientToDetector > 0.0) And (Dicomdata.DistanceSourceToDetector > 0.0) Then
        Begin
          XDenom := Trunc((Dicomdata.DistancePatientToDetector * XDenom) / Dicomdata.DistanceSourceToDetector);
          YDenom := Trunc((Dicomdata.DistancePatientToDetector * YDenom) / Dicomdata.DistanceSourceToDetector);
        End;
        // else just use the values from ImagerPixelSpace
      End;
      ApplyUpdates := True;
    End
    Else // the header does not contain the Imager Pixel Spacing (0018,1164) Values
    Begin
      // Check for the Pixel Spacing Values (0028,0030)
      If (Dicomdata.PixelSpace1 > 0.0) And (Dicomdata.PixelSpace2 > 0.0) Then
      Begin
        // JMW 8/12/08 - if the header contains the pixel space but is a DICOM image
        // then AccuSoft will apply the adjustment itself, so we don't need to.
        // only apply if TGA image
        If Dicomdata.DicomDataSource <> 'DICOM Header' Then
        Begin
          YDenom := Trunc(Dicomdata.PixelSpace1 * 100000.0);
          XDenom := Trunc(Dicomdata.PixelSpace2 * 100000.0);
          AdjustForDownsizedImage(XDenom, YDenom, Dicomdata);
          ApplyUpdates := True;
        End;
        // measurements are ok since the pixel spacing is available
        // this is needed here since if it is a dicom image, we won't applyUpdates
        // but measurements should be enabled
        Result := True;
      End;
    End;

    // if the appropriate values were found in the header
    If ApplyUpdates Then
    Begin
      ImgResolution.Units := IG_RESOLUTION_METERS;

      ImgResolution.XNumerator := 100000000;
      ImgResolution.XDenominator := XDenom;

      ImgResolution.YNumerator := 100000000;
      ImgResolution.YDenominator := YDenom;

      CurrentPage.UpdateImageResolutionFrom(ImgResolution);

      //p122 dmmn 8/23 update resolution
      AnnotationComponent.UpdateMeasurementRatio(XDenom,YDenom);

      Result := True;
    End
    else
    begin
      {/p122 dmmn 10/118 - clear the dicom information /}
      AnnotationComponent.ClearDICOMRation;
      {/ P122 T15 - JK 7/17/2012 - DICOM calibration information was obtained from the DICOM header. Calculate
         calibration here.  It was missing for this DICOM case prior to T15. However,
         only do this when there is valid pixel spacing information. If both the
         x and y pixel spacing is zero, then allow the ruler to use manual calibration.
         NOTE: It is the condition: If Dicomdata.DicomDataSource <> 'DICOM Header' Then ... that flips the ApplyUpdates boolean
         and this only applies to the (0028,0030) tag. /}
      if (Dicomdata.PixelSpace1 <> 0.0) or (Dicomdata.PixelSpace2 <> 0.0) then
      begin
        YDenom := Trunc(Dicomdata.PixelSpace1 * 100000.0);
        XDenom := Trunc(Dicomdata.PixelSpace2 * 100000.0);
        AdjustForDownsizedImage(XDenom, YDenom, Dicomdata);

        ImgResolution.Units := IG_RESOLUTION_METERS;

        ImgResolution.XNumerator := 100000000;
        ImgResolution.XDenominator := XDenom;

        ImgResolution.YNumerator := 100000000;
        ImgResolution.YDenominator := YDenom;

        CurrentPage.UpdateImageResolutionFrom(ImgResolution);

        AnnotationComponent.UpdateMeasurementRatio(XDenom,YDenom);

        Result := True;
      end;
    end;
  Except
    On e: Exception Do
    Begin
      //LogMsg('', 'Exception updating image resolution: ' + e.Message, magmsgError);
      magAppMsg('', 'Exception updating image resolution: ' + e.Message, magmsgError); 
      Result := False;
    End;
  End;
End;

{ This function updates the X denominator and the Y denominator based on the
  resolution of the currently loaded image compared to the number of columns
  and rows in the DICOM header. This handles downsized images }

Procedure TMag4VGear14.AdjustForDownsizedImage(Var XDenom: Integer; Var YDenom: Integer; Dicomdata: TDicomData);
Var
  Val: Integer;
  col: integer;
  row: integer;
Begin
  Val := GetWidth();
  //p130T9 dmmn 2/10/13 - use the actual image width and height in case of bad
  //dicom data. Assuming Display does down sampling images or actual images,
  //the DICOM rows and cols should always be greater than or equal the actual
  //image's dimensions.
  if DicomData.Columns < CurrentPage.ImageWidth then
    col := CurrentPage.imageWidth
  else
    col := DicomData.Columns;
  if DicomData.Rows < CurrentPage.ImageHeight then
    row := CurrentPage.imageHeight
  else
    row := DicomData.Rows;

  // if the image has a different number of columns than the header values
  //p130t9 use the actual dimension    //out in 130 If Val <> Dicomdata.Columns Then
  If Val <> col Then
  Begin
    XDenom := Trunc(XDenom * (col / Val));   //Dicomdata.Columns
  End;
  Val := GetHeight();
  // if the image has a different number of rows than the header values
  If Val <> row Then  //Dicomdata.Rows 
  Begin
    YDenom := Trunc(YDenom * (row / Val));  //Dicomdata.Rows 
  End;
  (* p122t11 dmmn - since we're waiting for the annotation to be loaded after a timer
  this is no longer a good place to load annotation from vista rad *)

  //p122 dmmn 8/3/11 - scale down RAD annotation for RAD package images
//out in 122 t11  if AnnotationComponent.RADPackage then
//out in 122 t11   begin
    //p122 dmmn 8/5 - only load after everything is downsized
// //out in 122 t11    if AnnotationComponent.HasRADAnnotation then
//  //out in 122 t11     AnnotationComponent.ScaleRadAnnotations(DicomData.Columns,DicomData.Rows);
// //out in 122 t11  end;
End;

Function TMag4VGear14.IsFormatSupportMeasurements(Dicomdata: TDicomData): Boolean;
Var
  PageInfo: IGFormatPageInfo;
Begin
  Result := False;
  Try
    PageInfo := GetIGManager.IGFormatsCtrl.GetPageInfo(IoLocation, FPage - 1, IG_FORMAT_UNKNOWN);
    Case GetIGManager.IGFormatsCtrl.Settings.GetFormatRef(PageInfo.Format).ID Of
      // not sure if should call UpdateImageResolution for DICOM images, not sure if they are being handled properly or not
      IG_FORMAT_DCM: Result := UpdateImageResolution(Dicomdata); // true;
      // if the format is TGA, then check for enough data to make determination
      IG_FORMAT_TGA: Result := UpdateImageResolution(Dicomdata);
      // put other allowed formats in here or change it to only restrict certain formats
    End;

  Except
    On e: Exception Do
    Begin
      //LogMsg('', 'Exception getting file format: ' + e.Message, magmsgError);
      magAppMsg('', 'Exception getting file format: ' + e.Message, magmsgError); 
      Result := False;
    End;
  End;
End;

Function TMag4VGear14.IsFormatSupportWinLev(): Boolean;
Var
  PageInfo: IGFormatPageInfo;
Begin
  Result := True;
  Try
    PageInfo := GetIGManager.IGFormatsCtrl.GetPageInfo(IoLocation, FPage - 1, IG_FORMAT_UNKNOWN);
    Case GetIGManager.IGFormatsCtrl.Settings.GetFormatRef(PageInfo.Format).ID Of
    // a JPG/TIF can be grayscale and can be win/lev, how do we handle this?
    // look at the compression?
      IG_FORMAT_TIF: Result := False;
      IG_FORMAT_BMP: Result := False;
      IG_FORMAT_JPG: Result := False;
      IG_FORMAT_PDF: Result := False;
      IG_FORMAT_PNG: Result := False;
      IG_FORMAT_WMF: Result := False;
    // put more formats in here
  // can we safely say only TGA or DICOM should be window leveled? - no!
    End;
  Except
    On e: Exception Do
    Begin
      //LogMsg('', 'Exception getting file format: ' + e.Message, magmsgError);
      magAppMsg('', 'Exception getting file format: ' + e.Message, magmsgError); 
      Result := False;
    End;
  End;
End;

Function TMag4VGear14.IsDICOMHeaderInImageFormat(): Boolean;
Var
  PageInfo: IGFormatPageInfo;
Begin
  Result := False;
  Try
    PageInfo := GetIGManager.IGFormatsCtrl.GetPageInfo(IoLocation, FPage - 1, IG_FORMAT_UNKNOWN);
    Case GetIGManager.IGFormatsCtrl.Settings.GetFormatRef(PageInfo.Format).ID Of
      IG_FORMAT_DCM: Result := True;
    End;
  Except
    On e: Exception Do
    Begin
      //LogMsg('', 'Exception getting file format to find DICOM header: ' + e.Message, magmsgError);
      magAppMsg('', 'Exception getting file format to find DICOM header: ' + e.Message, magmsgError); 
      Result := False;
    End;
  End;
End;

Function TMag4VGear14.GetCompression(): String;
Var
  PageInfo: IGFormatPageInfo;
Begin
  Try
    PageInfo := GetIGManager.IGFormatsCtrl.GetPageInfo(IoLocation, FPage - 1, IG_FORMAT_UNKNOWN);
    Case PageInfo.Compression Of
      IG_COMPRESSION_NONE: Result := 'Uncompressed';
      IG_COMPRESSION_PACKED_BITS: Result := 'Packed Bits';
      IG_COMPRESSION_HUFFMAN: Result := 'Huffman';
      IG_COMPRESSION_CCITT_G3: Result := 'CCITT G3';
      IG_COMPRESSION_CCITT_G4: Result := 'CCITT G4';
      IG_COMPRESSION_CCITT_G32D: Result := 'CCITT G32D';
      IG_COMPRESSION_JPEG: Result := 'JPEG';
      IG_COMPRESSION_RLE: Result := 'RLE';
      IG_COMPRESSION_LZW: Result := 'LZW';
      IG_COMPRESSION_ABIC_BW: Result := 'ABIC_BW';
      IG_COMPRESSION_ABIC_GRAY: Result := 'ABIC_GRAY';
      IG_COMPRESSION_JBIG: Result := 'JBIG';
      IG_COMPRESSION_FPX_SINCOLOR: Result := 'FPX_SINCOLOR';
      IG_COMPRESSION_FPX_NOCHANGE: Result := 'FPX_NOCHANGE';
      IG_COMPRESSION_DEFLATE: Result := 'Deflate';
      IG_COMPRESSION_IBM_MMR: Result := 'IBM_MMR';
      IG_COMPRESSION_ABIC: Result := 'ABIC';
      IG_COMPRESSION_PROGRESSIVE: Result := 'Progressive';
      IG_COMPRESSION_EQPC: Result := 'PowerSDK EQPC(Wavelet)';
      IG_COMPRESSION_JBIG2: Result := 'PowerSDK JBIG2';
      IG_COMPRESSION_LURADOC: Result := 'LuraDoc';
      IG_COMPRESSION_LURAWAVE: Result := 'LuraWave';
      IG_COMPRESSION_LURAJP2: Result := 'LuraJPEG2000';
      IG_COMPRESSION_JPEG2K: Result := 'JPEG2000';
      IG_COMPRESSION_ASCII: Result := 'ASCII';
      IG_COMPRESSION_RAW: Result := 'RAW';
      IG_COMPRESSION_HDP: Result := 'HDP';
    Else
      Result := 'Unknown';
    End;
  Except
    On e: Exception Do
    Begin
      //LogMsg('','Exception getting compression: ' + e.Message, magmsgError);
      magAppMsg('', 'Exception getting compression: ' + e.Message, magmsgError); 
      Result := 'Unknown';
      Exit;
    End;
  End;

End;
{p129  surface the IGPage for TWAIN Functions}
function TMag4VGear14.GetCurrentPage(): IGPage;
begin
 result := self.CurrentPage;
end;

procedure TMag4VGear14.SkipColorChannel(value : boolean);
begin
  FSkipColorChannel := value;
end;


Procedure TMag4VGear14.SetWindowValue(Value: Integer);
Begin
  Inherited;
End;

Procedure TMag4VGear14.SetLevelValue(Value: Integer);
Begin
  Inherited;
End;

Procedure TMag4VGear14.WindowLevelEntireImage();
Var
  MedMinMax: IGMedMinMax;
  PixPadSettings: IGMedPixPaddingSettings;
  ColorSpaceID : enumIGColorSpaceIDs;
Begin
  Inherited;
  Try

    CurrentPage.ROI.Convert(IG_ROI_ALL_IMAGE);
    If MedContrast = Nil Then
      MedContrast := GetIGManager().IGMedCtrl.CreateObject(MED_OBJ_CONTRAST) As IIGMedContrast; ///

   {JW Fix for WinLev #3}
   ColorSpaceID := CurrentPage.ColorSpaceIDGet() ;
   // IG_COLOR_SPACE_ID_I : Indexed RGB
   // IG_COLOR_SPACE_ID_ColorMask : Bit mask used to access color space (for color channels) only
    If ((ColorSpaceID And IG_COLOR_SPACE_ID_ColorMask) = IG_COLOR_SPACE_ID_I) And CurrentPage.ImageIsGray Then
    begin
      GetIGManager().IGProcessingCtrl.ConvertToGray(CurrentPage);

    end;

    MedMinMax := CurrentMedPage.Processing.GetMinMax;   // Calculates image's min and max pixel values

    MedContrast.WindowCenter := Trunc(((MedMinMax.Max + MedMinMax.Min) Div 2)* MedContrast.RescaleSlope + MedContrast.RescaleIntercept);
    MedContrast.WindowWidth := Trunc((MedMinMax.Max - MedMinMax.Min) * MedContrast.RescaleSlope);

    // retrieves the Pixel Padding Value (PPV) that is being used to display 9..16-bit grayscale images.

    PixPadSettings := CurrentMedPage.Display.GetPixPaddingSettings;
    PixPadSettings.UsePixPadding := False;

    // automatically adjusts WindowWidth and WindowCenter according to minimum and maximum
    // intensities of a portion of IGPage, specified by its ROI.
    MedContrast.AutoAdjustFrom(CurrentPage);

    GetIGManager.IGMedCtrl.BuildGrayscaleLUT(MedContrast, PixPadSettings, CurrentGrayLUT);
    CurrentPage.UpdateGrayscaleLUTFrom(CurrentGrayLUT);

    // JMW 11/15/07 - removed since there is an updateview at the bottom
    //    IGPageViewCtl1.UpdateView();
//    medMinMax := currentMedPage.Processing.GetMinMax;

    FWindowValueMin := 1; // cannot be less than 1, is it always 0?
    FWindowValueMax := MedMinMax.Max - MedMinMax.Min; // abs(medminmax.Min) + abs(MedMinMax.Max);
    FLevelValueMax := MedMinMax.Max;
    FLevelValueMin := MedMinMax.Min;
    FMaxPixelValue := MedMinMax.Max;
    FMinPixelValue := MedMinMax.Min;

//    currentmedpage.Display.AdjustContrastAutoFrom(MedContrast);

    FWindowValue := MedContrast.WindowWidth;
    FLevelValue := MedContrast.WindowCenter;

    //LogMsg('s','WindowLevel Entire Image Values [' + inttostr(FWindowValue) + '], Lev Value [' + inttostr(FLevelValue) + '] to IG14 image', MagLogDEBUG);
    magAppMsg('s', 'WindowLevel Entire Image Values [' + Inttostr(FWindowValue) + '], Lev Value [' +
      Inttostr(FLevelValue) + '] to IG14 image', MagmsgDebug); 

//    if FUpdatePageView then // JMW 8/30/06
    // JMW 11/15/07 p72 - Put the check for FUpdatePageView back in
    If FUpdatePageView Then

      IGPageViewCtl1.UpdateView();
  Except
    On e: Exception Do
    Begin
      //LogMsg('','Exception window leveling entire image [' + e.Message + ']', magmsgError);
      magAppMsg('', 'Exception window leveling entire image [' + e.Message + ']', magmsgError); 
    End;
  End;
End;

Procedure TMag4VGear14.CalculateMaxWinLev();
Var
  MedMinMax: IGMedMinMax;
Begin
  Inherited;
  CurrentPage.ROI.Convert(IG_ROI_ALL_IMAGE);
  MedMinMax := CurrentMedPage.Processing.GetMinMax;
  If MedContrast = Nil Then
    MedContrast := GetIGManager().IGMedCtrl.CreateObject(MED_OBJ_CONTRAST) As IIGMedContrast; ///

  (*
  FWindowValueMax := medminmax.Max;
  FLevelValueMax := medminMax.Max;
  FLevelValueMin := medminmax.Min;
  FWindowValueMin := medminmax.Min;
  *)

  FWindowValueMin := 1; // cannot be less than 0, is it always 0?
  FWindowValueMax := MedMinMax.Max - MedMinMax.Min; // abs(medminmax.Min) + abs(MedMinMax.Max);
  FLevelValueMax := MedMinMax.Max;
  FLevelValueMin := MedMinMax.Min;
  FMaxPixelValue := MedMinMax.Max;
  FMinPixelValue := MedMinMax.Min;

  CurrentMedPage.Display.AdjustContrastAutoFrom(MedContrast);

  FWindowValue := MedContrast.WindowWidth;
  FLevelValue := MedContrast.WindowCenter;
End;

Procedure TMag4VGear14.UpdatePageView();
Begin
  Inherited;
  IGPageViewCtl1.UpdateView();
End;

Procedure TMag4VGear14.DrawCharacter(Left, Top, Red, Green, Blue: Integer; Letter: String; Height_scale: Real);
Var
  Right, Bottom: Integer;
  cPoint: IIGPoint;
  FontSize: Integer;
//  fontSize : real;
Begin
  Try
    If CurrentPage.IsValid Then
    Begin
        if FAnnotationComponent <> nil then
      If FAnnotationsNeverLoaded Then
      Begin
        initializeAnnotations();
      End;
      FontSize := Round(22 * Height_scale);
      Right := Left + Trunc(FontSize * 1.5);
      Bottom := Top + Trunc(FontSize * 2);

    // old font size = 18
    //FAnnotationComponent.drawText(left, top, right, bottom, red, green, blue, letter, fontSize);
        if FAnnotationComponent <> nil then
        begin
      FAnnotationComponent.DrawText(Left, Right, Top, Bottom, Red, Green, Blue, Letter, FontSize);
      FAnnotationComponent.SetAnnotationStyles();
        end;
    End;
  Except
    On e: Exception Do
    Begin
      //LogMsg('s', 'Exception drawing Rad Characters [' + e.Message + ']', magmsgError);
      magAppMsg('s', 'Exception drawing Rad Characters [' + e.Message + ']', magmsgError); 
    End;
  End;
End;

Procedure TMag4VGear14.DisplayDICOMHeader();
Var
  HeaderDialog: TfrmIG14DICOMHeader;
Begin
  HeaderDialog := TfrmIG14DICOMHeader.Create(Self);
  //headerDialog.OnLogEvent := OnLogEvent; LogMsg('s','Exception loading DICOM header, ' + e.Message, magmsgError);
  HeaderDialog.ShowHeader(CurrentMedPage, MedDataDict);
  FreeAndNil(HeaderDialog);
End;

{JK 10/5/2009 - Maggmsgu refactoring - remove old method}
//procedure TMag4VGear14.LogMsg(MsgType : String; Msg : String; Priority : TMagLogPriority = MagLogINFO);
//begin
//  if assigned(FOnLogEvent) then
//    FOnLogEvent(self, MsgType, Msg, Priority);
//end;

Function TMag4VGear14.GetPixelValue(Var x: Integer; Var y: Integer): Integer;
Var
  Page: IIGPage;
  Pixel: IIGPixel;
  Point: IGPoint;
Begin

  Page := CurrentPage;
  Result := -1;
  If Not Page.IsValid Then Exit;
  Try
    Point := GetIGManager.IGCoreCtrl.CreateObject(IG_OBJ_POINT) As IIGPoint;
    Point.XPos := x;
    Point.YPos := y;
    CurrentPageDisp.ConvertPointCoordinates(IGPageViewCtl1.Hwnd, 0, Point, IG_DSPL_CONV_DEVICE_TO_IMAGE);

    x := Point.XPos;
    y := Point.YPos;

    If (x < 0) Or (y < 0) Then
    Begin
      Result := -1;
      //LogMsg('','Invalid location specified for getting pixel value for point (' + inttostr(x) + '), (' + inttostr(y) + ')');
      magAppMsg('', 'Invalid location specified for getting pixel value for point (' +
        Inttostr(x) + '), (' + Inttostr(y) + ')'); 
      Exit;
    End;

    Pixel := Page.GetPixelCopy(x, y);
  {
  case pixel.type_ of
    IG_PIXEL_RGB: showmessage('rgb');
    IG_PIXEL_CMYK: showmessage('cmyk');
    IG_PIXEL_GRAY: showmessage('gray');
    IG_PIXEL_INDEX: showmessage('index');
  end;
  }

    Pixel.ChangeType(IG_PIXEL_GRAY);
    Result := Pixel.Gray;
  Except
    On e: Exception Do
    Begin
      Result := -1;
      //LogMsg('','Error getting pixel value for point (' + inttostr(x) + '), (' + inttostr(y) + ') - ' + e.Message);
      magAppMsg('', 'Error getting pixel value for point (' + Inttostr(x) + '), (' +
        Inttostr(y) + ') - ' + e.Message); 
    End;
  End;
End;

Function TMag4VGear14.GetRedGreenBlueValue(Var x: Integer; Var y: Integer; Var Red: Integer; Var Green: Integer; Var Blue: Integer): Boolean;
Var
  Point: IGPoint;
  Pixel: IIGPixel;
  Page: IIGPage;
  r, g, b: Longint;
Begin
  Page := CurrentPage;
  Result := False;
  If Not Page.IsValid Then Exit;

  Try
    Point := GetIGManager.IGCoreCtrl.CreateObject(IG_OBJ_POINT) As IIGPoint;
    Point.XPos := x;
    Point.YPos := y;
    CurrentPageDisp.ConvertPointCoordinates(IGPageViewCtl1.Hwnd, 0, Point, IG_DSPL_CONV_DEVICE_TO_IMAGE);

    x := Point.XPos;
    y := Point.YPos;

    If (x < 0) Or (y < 0) Then
    Begin
      Result := False;
      //LogMsg('','Invalid location specified for getting pixel value for point (' + inttostr(x) + '), (' + inttostr(y) + ')');
      magAppMsg('', 'Invalid location specified for getting pixel value for point (' +
        Inttostr(x) + '), (' + Inttostr(y) + ')'); 
      Exit;
    End;

    Pixel := Page.GetPixelCopy(x, y);
    Pixel.ChangeType(IG_PIXEL_RGB);

    r := Pixel.RGB_R;
    g := Pixel.RGB_G;
    b := Pixel.RGB_B;
 {7/12/12 gek Merge 130->129}
    {/P130 - JK 5/9/2012 - add color channel states to ensure the pixel values hint show correctly.
      When viewing channels separately, ImageGear puts the channel in the RGB_R property. /}
    case ImageRGBChannelState of
      0: {Composite color image}
        begin

    Red := r;
    Green := g;
    Blue := b;
        end;
      1:  {Red channel}
        begin
          Red   := r;
          Green := g;
          Blue  := b;
        end;
      2:  {Green channel}
        begin
          Red   := g;
          Green := r;
          Blue  := b;
        end;
      3:  {Blue channel}
        begin
          Red   := g;
          Green := b;
          Blue  := r;
        end;
    end;

//    Red := r;
//    Green := g;
//    Blue := b;
    Result := True;

  Except
    On E:Exception Do
    Begin
      Result := False;
      //LogMsg('','Error getting RGB value for point (' + inttostr(x) + '), (' + inttostr(y) + ') - ' + e.Message);
      magAppMsg('', 'Cannot get RGB value for point (' +
        Inttostr(x) + '), (' + Inttostr(y) + ') - ' + E.Message); 
    End;
  End;

End;

Procedure TMag4VGear14.IGPageViewCtl1Scroll(ASender: Tobject;
  Scrolltype: Integer);

Begin
  Inherited;
  UpdateScrollPos();
End;

Procedure TMag4VGear14.UpdateScrollPos();
Var
  ScrollAttrs: IIGDisplayScrollInfo;
Begin
  If Assigned(FImageScroll) Then
  Begin
    ScrollAttrs := CurrentPageDisp.GetScrollAttrs(IGPageViewCtl1.Hwnd);
    FImageScroll(Self, ScrollAttrs.V_Pos, ScrollAttrs.H_Pos);
  End;
  DrawCurrentScoutLine();
End;

Procedure TMag4VGear14.SetScrollPos(VertScrollPos: Integer; HorizScrollPos: Integer);
Var
  ScrollAttrs: IIGDisplayScrollInfo;
Begin      
  If CurrentPage.IsValid Then
  Begin
    ScrollAttrs := CurrentPageDisp.GetScrollAttrs(IGPageViewCtl1.Hwnd);
    If (ScrollAttrs.H_Pos <> HorizScrollPos) Or (ScrollAttrs.V_Pos <> VertScrollPos) Then
      CurrentPageDisp.ScrollTo(IGPageViewCtl1.Hwnd, HorizScrollPos, VertScrollPos);
  End;
  If FUpdatePageView Then
    IGPageViewCtl1.UpdateView();
End;

Procedure TMag4VGear14.PanControlTrackDone(Sender: Tobject);
Var
  ScrollAttrs: IIGDisplayScrollInfo;
Begin
  Inherited;

  If Assigned(FImageScroll) Then
  Begin
    ScrollAttrs := CurrentPageDisp.GetScrollAttrs(IGPageViewCtl1.Hwnd);
    FImageScroll(Self, ScrollAttrs.V_Pos, ScrollAttrs.H_Pos);
  End;

End;

Procedure TMag4VGear14.Measurements();
Var
  cPoint: IIGPoint;
Begin
  Inherited;
  If Not CurrentPage.IsValid Then Exit;
  if FAnnotationComponent <> nil then
  begin
    If FAnnotationsNeverLoaded Then
    Begin
      initializeAnnotations();
    End;
  FAnnotationComponent.EnableMeasurements();
  end;
{$IFDEF USENEWANNOTS}

{$ELSE}
  FAnnotationComponent.SetFont('Microsoft Sans Serif', FFontSize, False, False);
{$ENDIF}
End;

Procedure TMag4VGear14.Protractor();
Var
  cPoint: IIGPoint;
Begin
  Inherited;
  If Not CurrentPage.IsValid Then Exit;
  If FAnnotationsNeverLoaded Then
  Begin
    initializeAnnotations();
  End;
{$IFDEF USENEWANNOTS}
  if FAnnotationComponent <> nil then
  FAnnotationComponent.SetTool(MagAnnToolProtractor);
{$ELSE}
  If FAnnotationComponent.AnnotationStyle = Nil Then
  Begin
    FAnnotationComponent.SetAnnotationColor(clYellow);
    FAnnotationComponent.SetLineWidth(MagAnnLineWidthThin);
  End;
  FAnnotationComponent.SetTool(MagAnnToolProtractor);
  FAnnotationComponent.SetFont('Microsoft Sans Serif', FFontSize, False, False);
  IGPageViewCtl1.SelectEvent := IG_VIEW_SELECT_NO;
{$ENDIF}
End;

Procedure TMag4VGear14.AnnotationPointer();
Var
  cPoint: IIGPoint;
Begin
  Inherited;
  If Not CurrentPage.IsValid Then Exit;

  if FAnnotationComponent <> nil then
  begin
  If FAnnotationsNeverLoaded Then
  Begin
    initializeAnnotations();
  End;
  FAnnotationComponent.SetTool(MagAnnToolPointer);
  end;
End;

Procedure TMag4VGear14.RemoveOrientationLabel();
Begin
  If Not CurrentPage.IsValid Then
    Exit;
  If FAnnotationsNeverLoaded Then
    Exit;
  if FAnnotationComponent <> nil then
  FAnnotationComponent.RemoveOrientationLabel();

End;

Procedure TMag4VGear14.AddComponentToViewComponent(Control: TControl);
Begin
  If IGPageViewCtl1 = Nil Then
    Exit;
  IGPageViewCtl1.InsertControl(Control);
End;

Procedure TMag4VGear14.ScrollLeft();
Var
  ScrollAttrs: IIGDisplayScrollInfo;
  NewPos: Integer;
Begin
  If CurrentPage.IsValid Then
  Begin
    ScrollAttrs := CurrentPageDisp.GetScrollAttrs(IGPageViewCtl1.Hwnd);
    If ScrollAttrs.H_Pos <= ScrollAttrs.H_Min Then
      Exit;
    NewPos := ScrollAttrs.H_Pos - ScrollAttrs.H_Page;
    CurrentPageDisp.ScrollTo(IGPageViewCtl1.Hwnd, NewPos, ScrollAttrs.V_Pos);
  End;
  If FUpdatePageView Then
    IGPageViewCtl1.UpdateView();
End;

Procedure TMag4VGear14.ScrollRight();
Var
  ScrollAttrs: IIGDisplayScrollInfo;
  NewPos: Integer;
Begin
  If CurrentPage.IsValid Then
  Begin
    ScrollAttrs := CurrentPageDisp.GetScrollAttrs(IGPageViewCtl1.Hwnd);
    If ScrollAttrs.H_Pos >= ScrollAttrs.H_Max Then
      Exit;
    NewPos := ScrollAttrs.H_Pos + ScrollAttrs.H_Page;
    CurrentPageDisp.ScrollTo(IGPageViewCtl1.Hwnd, NewPos, ScrollAttrs.V_Pos);
  End;
  If FUpdatePageView Then
    IGPageViewCtl1.UpdateView();
End;

Procedure TMag4VGear14.ScrollUp();
Var
  ScrollAttrs: IIGDisplayScrollInfo;
  NewPos: Integer;
Begin
  If CurrentPage.IsValid Then
  Begin
    ScrollAttrs := CurrentPageDisp.GetScrollAttrs(IGPageViewCtl1.Hwnd);
    If ScrollAttrs.V_Pos <= ScrollAttrs.V_Min Then
      Exit;
    NewPos := ScrollAttrs.V_Pos - ScrollAttrs.V_Page;
    CurrentPageDisp.ScrollTo(IGPageViewCtl1.Hwnd, ScrollAttrs.H_Pos, NewPos);
  End;
  If FUpdatePageView Then
    IGPageViewCtl1.UpdateView();
End;

Procedure TMag4VGear14.ScrollDown();
Var
  ScrollAttrs: IIGDisplayScrollInfo;
  NewPos: Integer;
Begin
  If CurrentPage.IsValid Then
  Begin
    ScrollAttrs := CurrentPageDisp.GetScrollAttrs(IGPageViewCtl1.Hwnd);
    If ScrollAttrs.V_Pos >= ScrollAttrs.V_Max Then
      Exit;
    NewPos := ScrollAttrs.V_Pos + ScrollAttrs.V_Page;
    CurrentPageDisp.ScrollTo(IGPageViewCtl1.Hwnd, ScrollAttrs.H_Pos, NewPos);
  End;
  If FUpdatePageView Then
    IGPageViewCtl1.UpdateView();
End;

{*
 Determines if the currently displayed image is a PDF - this is needed
 for special functions to work properly in printing
 @returns True if currently displayed image is PDF, false otherwise
}

Function TMag4VGear14.isImagePDF(): Boolean;
Var
  PageInfo: IGFormatPageInfo;
Begin
  Result := False;
  Try
    PageInfo := GetIGManager.IGFormatsCtrl.GetPageInfo(IoLocation, FPage - 1, IG_FORMAT_UNKNOWN);
    Case GetIGManager.IGFormatsCtrl.Settings.GetFormatRef(PageInfo.Format).ID Of
      IG_FORMAT_PDF:
        Result := True;
    End;
  Except
    On e: Exception Do
    Begin
      //LogMsg('', 'Exception getting file format: ' + e.Message, magmsgError);
      magAppMsg('', 'Exception getting file format: ' + e.Message, magmsgError); 
      Result := False;
    End;
  End;

End;

{*
  Initialize the annotations components
}

Procedure TMag4VGear14.initializeAnnotations();
Var
  cPoint: IIGPoint;
Begin

  if FAnnotationComponent = nil then EXIT;
  If FAnnotationsNeverLoaded Then
  Begin
    FAnnotationsNeverLoaded := False;
    cPoint := GetIGManager.IGCoreCtrl.CreateObject(IG_OBJ_POINT) As IIGPoint;

    FAnnotationComponent.Initialize(cPoint, CurrentPage, CurrentPageDisp, IGPageViewCtl1.Hwnd, True);
    FAnnotationComponent.SetAnnotationStyles();     // This is where the default annot properties are set if not set globally from VISTA
    FAnnotationComponent.PageCount := FPageCount;
    FAnnotationComponent.Page := FPage;
    FAnnotationComponent.IGPageViewCtl := IGPageViewCtl1;

    FAnnotationComponent.VistaRadMessage := '';
  End;
End;

Function TMag4VGear14.getAnnotationFontSizeFromDPI(): Integer;
Var
  ImgResolution: IIGImageResolution;
  XDenom, YDenom: Integer;
  ApplyUpdates: Boolean;
  dpi, maxsize, FontSize: Integer;
Begin
  Result := 24; // default font size, really huge on some images
  Try
    ImgResolution := CurrentPage.GetImageResolutionCopy;
    ImgResolution.ConvertUnits(IG_RESOLUTION_INCHES);

    dpi := Trunc(ImgResolution.XNumerator / ImgResolution.XDenominator);
    maxSize := GetWidth();
    If maxSize < GetHeight() Then
      maxSize := GetHeight();
    FontSize := 2;
    // JMW 8/7/2009 P93T11 - add more changes for better measurement support
    // sort of a guess at this point
    If (dpi > 0) Then
    Begin
      FontSize := Trunc(maxSize / dpi);
      If FontSize <= 0 Then
        FontSize := 2
      Else
        If (maxSize > 512) Then
        Begin
          FontSize := 32;
        End
        Else
        Begin
          FontSize := 26;
        End;
    End
    Else
      If dpi = 0 Then
        FontSize := 18
      Else
        If (maxSize > 512) Then
        Begin
          FontSize := 32;
        End
        Else
          If (maxSize > 256) Then
          Begin
            FontSize := 30;
          End
          Else
          Begin
            FontSize := 26;
          End;

    Result := FontSize;

  Except
    On e: Exception Do
    Begin
      //LogMsg('s', 'Exception calculating font size, ' + e.Message, magmsgError);
      magAppMsg('s', 'Exception calculating font size, ' + e.Message, magmsgError); 
    End;
  End;
End;

{*
 Test method, should be removed before release!!!
}

Function TMag4VGear14.GetImageDpiString(): String;
Var
  Msg, msg1, msg2: String;
  ImgResolution: IIGImageResolution;
  XDenom, YDenom: Integer;
  dpi: Double;
  maxSize: Integer;
  FontSize: Integer;
Begin
  Result := '';
  Try
    ImgResolution := CurrentPage.GetImageResolutionCopy;

    Msg := '';
    Case ImgResolution.Units Of
      IG_RESOLUTION_NO_ABS: Msg := 'no abs';
      IG_RESOLUTION_METERS: Msg := 'meters';
      IG_RESOLUTION_INCHES: Msg := 'inches';
      IG_RESOLUTION_CENTIMETERS: Msg := 'cm';
      IG_RESOLUTION_10_INCHES: Msg := '10 inches';
      IG_RESOLUTION_10_CENTIMETERS: Msg := '10 cm';
//      IG_RESOLUTION_LAST: msg := 'last';
    End;

    // always work with CM, easier to always work with the same units
    msg1 := Inttostr(ImgResolution.XNumerator) + '/' + Inttostr(ImgResolution.XDenominator) + '    ' + Inttostr(ImgResolution.YNumerator) + '/' + Inttostr(ImgResolution.YDenominator);
    ImgResolution.ConvertUnits(IG_RESOLUTION_INCHES);
    msg2 := Inttostr(ImgResolution.XNumerator) + '/' + Inttostr(ImgResolution.XDenominator) + '    ' + Inttostr(ImgResolution.YNumerator) + '/' + Inttostr(ImgResolution.YDenominator);

    dpi := (ImgResolution.XNumerator / ImgResolution.XDenominator);
    maxSize := GetWidth();
    If maxSize < GetHeight() Then
      maxSize := GetHeight();
    FontSize := 2;
    If (dpi > 0) Then
    Begin
      FontSize := Trunc(maxSize / dpi);
      If FontSize <= 0 Then
        FontSize := 2;
    End
    Else
      If (maxSize > 512) Then
      Begin
        FontSize := 24;
      End
      Else
      Begin
        FontSize := 18;
      End;

    Result := Msg + #13 + #10 + msg1 + #13 + #10 + msg2 + #13 + #10 + Inttostr(FontSize);

  Except
    On e: Exception Do
    Begin
      Result := 'Exception: ' + e.Message;
    End;
  End;

End;
{JK 6/28/2012}{p129}
function TMag4VGear14.GetImageViewCtl: TIGPageViewCtl;
begin
  Result := IGPageViewCtl1;
end;

{*
  This method is not used anywhere but is defined in FMagImage
}

Procedure TMag4VGear14.SetPageCount(Const Value: Integer);
Begin
  // do nothing
End;

{*
  This method is not used anywhere but is defined in FMagImage
}

Procedure TMag4VGear14.ResetImage;
Begin
  // do nothing
  FRotatedCount := 0;
  FFlippedHorizontal := false;
  FFlippedVertical := false;
End;

{*
  Set the shape of the mouse zoom tool
  @param Value The new shape for the mouse zoom too
}

Procedure TMag4VGear14.setMouseZoomShape(Value: TMagMouseZoomShape);
Begin
  Inherited;
  If ((IGGuiMagnifierCtrl <> Nil) And
    ((FGearAbilities = MagGearAbilityClinical) Or (FGearAbilities = MagGearAbilityRadiology))) Then
  Begin
    If FMouseZoomShape = MagMouseZoomShapeCircle Then
    Begin
      IGGuiMagnifierCtrl.PopUpHeight := 200;
      IGGuiMagnifierCtrl.PopUpWidth := 200;
      IGGuiMagnifierCtrl.PopUpShape := IG_SHAPE_ELLIPSE;
    End
    Else
    Begin
      IGGuiMagnifierCtrl.PopUpHeight := 200;
      IGGuiMagnifierCtrl.PopUpWidth := 600;
      IGGuiMagnifierCtrl.PopUpShape := IG_SHAPE_RECTANGLE;
    End;
  End;
End;

{*
 Adjust the brightness and contrast in a single method - this reduces the
 number of image repaints necessary if both the brightness and contrast
 are changed.
 @param Bri New brightness value
 @param Con New contrast value
}

Procedure TMag4VGear14.BrightnessContrastValue(Bri, Con: Integer);
Var
  Fcontrast: Double;
Begin
  Inherited;
  Fcontrast := FContrastPassed;
  Fcontrast := Fcontrast / 100;
  CurrentPageDisp.AdjustContrast(IG_DSPL_ALL_CHANNELS, Fcontrast, Trunc(Fbrightnesspassed / 10), 1.0);
  If FUpdatePageView Then IGPageViewCtl1.UpdateView();
End;

{/ P122 - JK 5/27/2011 /}
procedure TMag4VGear14.CreateArtPages(PageCnt: Integer);
var
  i: integer;
  ArtPageIdx: Integer;
  ArtPageObject: TArtPageObject;
begin
  //p122t11 - clear old annotations
  if FAnnotationComponent <> nil then
    if FAnnotationComponent.ArtPageList <> nil then
    begin
      FAnnotationComponent.ArtPageList.Clear;
      //p122t13 dmmn 4/18/12 - also updating the pagecount property to avoid any
      //discrepancy between the pagecount and artpagelist count which will produce
      //out of bound error
      FAnnotationComponent.Page := 1;
      FAnnotationComponent.PageCount := PageCnt;
    end;
  for i := 0 to PageCnt - 1 do
  begin

    if FAnnotationComponent <> nil then
    begin

      ArtPageObject := TArtPageObject.Create;

      //p122 dmmn 7/25/11 - multipage support
      ArtPageObject.ArtPage := FAnnotationComponent.IGArtXCtl.CreatePage;
      ArtPageIdx := FAnnotationComponent.ArtPageList.Add(ArtPageObject);
      FAnnotationComponent.ArtPageList.Items[ArtPageIdx].ArtPageID := FAnnotationComponent.Name;

      magAppMsg('s', 'TMag4VGear14.CreateArtPages: Added page ' + IntToStr(i+1) + ' of ' + IntToStr(PageCnt) + ' for loaded image: ' + FCurrentFileName);
    end;
  end;

  {Attach the first page to the first annotation art page}
  if FAnnotationComponent <> nil then
    FAnnotationComponent.ConnectArtPage(0, CurrentPage, CurrentPageDisp);

  FAnnotationsNeverLoaded := True;
end;

function TMag4VGear14.IsArtPageExist(FN: String): Boolean;
var
  i: Integer;
begin
  Result := False;
    if FAnnotationComponent = nil then EXIT;
  for i := 0 to FAnnotationComponent.ArtPageList.Count - 1 do
    if FAnnotationComponent.ArtPageList.Items[i].ArtPageID = FN then
    begin
      Result := True;
      Exit
    end;
end;

Procedure TMag4VGear14.DrawScoutLine(ScoutLineDetails : TMagScoutLine);
begin
  FScoutLineDetails := ScoutLineDetails;// TMagLinePoints.Create(TMagPoint.Create(X1, Y1),
//    TMagPoint.Create(X2, Y2));
  DrawCurrentScoutLine();
  //IGPageViewCtl1.DrawEvent := IG_VIEW_DRAW_EVENT_AFTER ;
end;

Procedure TMag4VGear14.HideScoutLine();
begin
  FScoutLine.Visible := false;
  FEdgeLine1.Visible := false;
  FEdgeLine2.Visible := false;
  if FScoutLineDetails <> nil then
    FreeAndNil(FScoutLineDetails);
end;

Procedure TMag4VGear14.SetScoutLineColor(Color : TColor);
begin
  FScoutLineColor := Color;
  DrawCurrentScoutLine(); // refresh the scout line with the current color
end;

procedure TMag4VGear14.DrawCurrentScoutLine();
{var
  point1, point2 : IGPoint;
  minWidthHeight, height, width : integer;
//  x1, y1, x2, y2 : integer;
  backwards : boolean;
  rotatedPoint1, rotatedPoint2 : TMagPoint;
  originalPoint1, originalPoint2 : TMagPoint;
  }
begin
  if FScoutLineDetails <> nil then
  begin
    //IGPageViewCtl1.DrawEvent := IG_VIEW_DRAW_EVENT_NO;
    
    if FScoutLineDetails.ScoutLine <> nil then
    begin
      DrawScoutLineOnImage(FScoutLineDetails.ScoutLine, true, FScoutLine);
    end
    else
      FScoutLine.Visible := false ; // shouldn't happen but just in case

    if FScoutLineDetails.Edge1 <> nil then
    begin
      DrawScoutLineOnImage(FScoutLineDetails.Edge1, false, FedgeLine1);
    end
    else
      FedgeLine1.Visible := false ;

    if FScoutLineDetails.Edge2 <> nil then
    begin
      DrawScoutLineOnImage(FScoutLineDetails.Edge2, false, FedgeLine2);
    end
    else
      FedgeLine2.Visible := false ;


    
    {
    minWidthHeight := 1;
    fline.Pen.Color := FScoutLineColor;
    fline.pen.width := minWidthHeight;
    fline.Visible := true;
    fline.BringToFront;
    fline.AutoSize := false;

    originalPoint1 := TMagPoint.Create(FScoutLinePoints.Point1.X, FSCoutLinePoints.Point1.Y);
    originalPoint2 := TMagPoint.Create(FScoutLinePoints.Point2.X, FSCoutLinePoints.Point2.Y);

    rotatedPoint1 := getRotatedPoint(originalPoint1);
    rotatedPoint2 := getRotatedPoint(originalPoint2);


    Point1 := GetIGManager.IGCoreCtrl.CreateObject(IG_OBJ_POINT) As IIGPoint;
    Point1.XPos := rotatedPoint1.x;// x1;
    point1.YPos := rotatedPoint1.y;//y1;
    Point2 := GetIGManager.IGCoreCtrl.CreateObject(IG_OBJ_POINT) As IIGPoint;
    Point2.XPos := rotatedPoint2.x;//x2;
    point2.YPos := rotatedPoint2.y;//y2;
    CurrentPageDisp.ConvertPointCoordinates(IGPageViewCtl1.Hwnd, 0, Point1, IG_DSPL_CONV_IMAGE_TO_DEVICE);
    CurrentPageDisp.ConvertPointCoordinates(IGPageViewCtl1.Hwnd, 0, Point2, IG_DSPL_CONV_IMAGE_TO_DEVICE);

    // the left must be the lower X value
    if point1.XPos <= point2.XPos then
    begin
      fline.Left := point1.XPos;
    end
    else
    begin
      fline.Left := point2.XPos;
    end;

    // the top must be the lower Y value
    if point1.YPos <= point2.YPos then
      FLine.Top := point1.YPos
    else
      FLine.Top := point2.YPos;
    //fline.Top := point1.YPos;
    width := abs(point2.XPos - point1.XPos); // absolute value to ensure positive width of the area
    // in case x1 and x2 are the same the width would be 0
    if width < minWidthHeight then
      width := minWidthHeight;
    fline.Width := width;
    height := abs(point2.YPos - point1.YPos); // absolute value to ensure positive height of the area
    // in case y1 and y2 are the same the height would be 0
    if height < minWidthHeight then
      height := minWidthHeight;
    fline.Height := height;

    backwards := true;
    // if the y on the small X value is greater than the y on the larger X value
    // then need to set backwards = false to make the line slant forwards

    if point1.XPos > point2.xPos then
    begin
      // point1 x is bigger than point2 x
      if point2.YPos > point1.YPos then
        backwards := false;
    end
    else if point2.XPos > point1.XPos then
    begin
      // point2 x is bigger than point1 x
      if point1.YPos > point2.YPos then
        backwards := false;
    end;

    // backwards = true makes the line start at the top left
    // backwards = false makes the line start at the top right
    fline.Backwards := backwards; // necessary to make the start of the line be at the top/left and the end be at the bottom right of the box for the line
    
    //fline.Width := (point2.XPos - point1.XPos);// (x2 - x1);//IGPageViewCtl1.width;//(x2 - x1);//
    //fline.Height := 4;
    fline.pen.Style := psInsideFrame;
    
    if originalPoint1 <> nil then
      FreeAndNil(originalPoint1);
    if originalPoint2 <> nil then
      FreeAndNil(originalPoint2);
    if rotatedPoint1 <> nil then
      FreeAndNil(rotatedPoint1);
    if rotatedPoint2 <> nil then
      FreeAndNil(rotatedPoint2);
      }
  end;
  //IGPageViewCtl1.DrawEvent := IG_VIEW_DRAW_EVENT_AFTER ;

end;

procedure TMag4VGear14.DrawScoutLineOnImage(Points : TMagLinePoints;
  scoutLine : boolean; Line : TMagLine);
var
  point1, point2 : IGPoint;
  minWidthHeight, height, width : integer;
//  x1, y1, x2, y2 : integer;
  backwards : boolean;
  rotatedPoint1, rotatedPoint2 : TMagPoint;
  originalPoint1, originalPoint2 : TMagPoint;
begin
    minWidthHeight := 1;
    line.Pen.Color := FScoutLineColor;
    line.pen.width := minWidthHeight;
    line.Visible := true;
    line.BringToFront;
    line.AutoSize := false;

    originalPoint1 := TMagPoint.Create(Points.Point1.X, Points.Point1.Y);
    originalPoint2 := TMagPoint.Create(Points.Point2.X, Points.Point2.Y);

    rotatedPoint1 := getRotatedPoint(originalPoint1);
    rotatedPoint2 := getRotatedPoint(originalPoint2);


    Point1 := GetIGManager.IGCoreCtrl.CreateObject(IG_OBJ_POINT) As IIGPoint;
    Point1.XPos := rotatedPoint1.x;// x1;
    point1.YPos := rotatedPoint1.y;//y1;
    Point2 := GetIGManager.IGCoreCtrl.CreateObject(IG_OBJ_POINT) As IIGPoint;
    Point2.XPos := rotatedPoint2.x;//x2;
    point2.YPos := rotatedPoint2.y;//y2;
    CurrentPageDisp.ConvertPointCoordinates(IGPageViewCtl1.Hwnd, 0, Point1, IG_DSPL_CONV_IMAGE_TO_DEVICE);
    CurrentPageDisp.ConvertPointCoordinates(IGPageViewCtl1.Hwnd, 0, Point2, IG_DSPL_CONV_IMAGE_TO_DEVICE);

    // the left must be the lower X value
    if point1.XPos <= point2.XPos then
    begin
      line.Left := point1.XPos;
    end
    else
    begin
      line.Left := point2.XPos;
    end;

    // the top must be the lower Y value
    if point1.YPos <= point2.YPos then
      line.Top := point1.YPos
    else
      line.Top := point2.YPos;
    width := abs(point2.XPos - point1.XPos); // absolute value to ensure positive width of the area
    // in case x1 and x2 are the same the width would be 0
    if width < minWidthHeight then
      width := minWidthHeight;
    line.Width := width;
    height := abs(point2.YPos - point1.YPos); // absolute value to ensure positive height of the area
    // in case y1 and y2 are the same the height would be 0
    if height < minWidthHeight then
      height := minWidthHeight;
    line.Height := height;

    backwards := true;
    // if the y on the small X value is greater than the y on the larger X value
    // then need to set backwards = false to make the line slant forwards

    if point1.XPos > point2.xPos then
    begin
      // point1 x is bigger than point2 x
      if point2.YPos > point1.YPos then
        backwards := false;
    end
    else if point2.XPos > point1.XPos then
    begin
      // point2 x is bigger than point1 x
      if point1.YPos > point2.YPos then
        backwards := false;
    end;

    // backwards = true makes the line start at the top left
    // backwards = false makes the line start at the top right
    line.Backwards := backwards; // necessary to make the start of the line be at the top/left and the end be at the bottom right of the box for the line

    if scoutLine then
      line.pen.Style := psInsideFrame
    else
      line.Pen.Style := psDash;
    
    if originalPoint1 <> nil then
      FreeAndNil(originalPoint1);
    if originalPoint2 <> nil then
      FreeAndNil(originalPoint2);
    if rotatedPoint1 <> nil then
      FreeAndNil(rotatedPoint1);
    if rotatedPoint2 <> nil then
      FreeAndNil(rotatedPoint2);
end;

{ convert the point to its rotated point, assumes point is the location if the
  image has not been rotated at all. This returns the correct point based on the
  current image rotation}
function TMag4VGear14.getRotatedPoint(point : TMagPoint) : TMagPoint;
var
  newX, newY : integer;
begin
  newX := 0;
  newY := 0;
  result := nil;
  if point = nil then
    exit;
  if FRotatedCount = 0 then
  begin
    newX := point.x;
    newY := point.y;

    if FFlippedVertical then
    begin
      newX := newX;
      newY := GetHeight - newY;
    end;
    if FFlippedHorizontal then
    begin
      newX := GetWidth - newX;
      newY := newY;
    end;
  end
  else if FRotatedCount = 1 then // 90 degrees
  begin
    newY := point.X;
    newX := GetHeight - point.Y;

    if FFlippedVertical then
    begin
      newX := newX;
      newY := GetWidth - newY;
    end;
    if FFlippedHorizontal then
    begin
      newX := GetHeight - newX;
      newY := newY;
    end;
  end
  else if FRotatedCount = 2 then // 180 degrees
  begin
    newY := GetHeight - point.y;
    newX := GetWidth - point.x;

    if FFlippedVertical then
    begin
      newX := newX;
      newY := GetHeight - newY;
    end;
    if FFlippedHorizontal then
    begin
      newX := GetWidth - newX;
      newY := newY;
    end;
  end
  else if FRotatedCount = 3 then // 270 degrees
  begin
    newX := point.y;
    newY := GetWidth - point.x;

    if FFlippedVertical then
    begin
      newX := newX;
      newY := GetWidth - newY;
    end;
    if FFlippedHorizontal then
    begin
      newX := GetHeight - newX;
      newY := newY;
    end;
  end;

  result := TMagPoint.Create(newX, newY);
end;

{ convert the point to its unrotated point. This assumes point is the location
  on a rotated image. This returns the point as if the image has not been
  rotated at all. This basically does the opposite of getRotatedPoint}
function TMag4VGear14.getUnRotatedPoint(point : TMagPoint) : TMagPoint;
var
  newX, newY, temp : integer;
begin
  newX := 0;
  newY := 0;
  result := nil;
  if point = nil then
    exit;
  // flipping has to be done before rotation for undoing the calculation
  // not rotated

  // initialize the values
  newX := point.x;
  newY := point.y;

  if FRotatedCount = 0 then
  begin
    if FFlippedVertical then
    begin
      newX := newX;
      newY := GetHeight - newY;
    end;
    if FFlippedHorizontal then
    begin
      newX := GetWidth - newX;
      newY := newY;
    end;

    // do nothing for the rotation
  end
  else if FRotatedCount = 1 then // 90 degrees
  begin
    if FFlippedVertical then
    begin
      newX := newX;
      newY := GetWidth - newY;
    end;
    if FFlippedHorizontal then
    begin
      newX := GetHeight - newX;
      newY := newY;
    end;
    temp := newY; // hold onto that value since it is about to change
    newY := GetHeight - newX;
    newX := temp; // Y value before updating
  end
  else if FRotatedCount = 2 then // 180 degrees
  begin
    if FFlippedVertical then
    begin
      newX := newX;
      newY := GetHeight - newY;
    end;
    if FFlippedHorizontal then
    begin
      newX := GetWidth - newX;
      newY := newY;
    end;

    newY := GetHeight - newY;
    newX := GetWidth - newX;
  end
  else if FRotatedCount = 3 then // 270 degrees
  begin
    if FFlippedVertical then
    begin
      newX := newX;
      newY := GetWidth - newY;
    end;
    if FFlippedHorizontal then
    begin
      newX := GetHeight - newX;
      newY := newY;
    end;
    temp := newY; // hold onto Y value
    newY := newX;
    newX := GetWidth - temp;
  end;

  result := TMagPoint.Create(newX, newY);

end;
 {
Constructor TMagPoints.Create(X1, Y1, X2, Y2 : integer);
begin
  self.X1 := x1;
  self.y1 := y1;
  self.X2 := x2;
  self.y2 := y2;
end;

Constructor TMagPoint.Create(X, Y : integer);
begin
  self.X := x;
  self.Y := y;
end;
}

Procedure TMag4VGear14.RefreshScoutLine();
begin
  DrawCurrentScoutLine();
end;

End.
