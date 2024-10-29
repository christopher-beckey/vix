Unit FMag4VGear14;
(*
        ;; +---------------------------------------------------------------------------------------------------+
        ;;  MAG - IMAGING
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
  OleCtrls,
  Maggmsgu
  ;

Type
  TMag4VGear14 = Class(TMagImage)
    IGPageViewCtl1: TIGPageViewCtl;
    Procedure IGPageViewCtl1MouseDblClick(Sender: Tobject; Button, Shift: Smallint; x, y: Integer);
    Procedure IGPageViewCtl1MouseDown(Sender: Tobject; Button, Shift: Smallint; x, y: Integer);
    Procedure IGPageViewCtl1MouseMove(Sender: Tobject; Button, Shift: Smallint; x, y: Integer);
    Procedure IGPageViewCtl1MouseUp(Sender: Tobject; Button, Shift: Smallint; x, y: Integer);
    Procedure IGPageViewCtl1Scroll(ASender: Tobject; Scrolltype: Integer);
    Procedure IGPageViewCtl1SelectEvent(Sender: Tobject; Var LplLeft, LplTop, LplRight, LplBottom: Integer);
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
  Public
    Constructor Create(AOwner: TComponent; GearAbilities: TMagGearAbilities = MagGearAbilityRadiology); Override;
    Destructor Destroy; Override;
    Function GetBitsPerPixel(): Integer; Override;
    Function GetCompression(): String; Override;
    Function GetFileFormat(): String; Override;
    Function GetHeight(): Integer; Override;
    Function GetImageDpiString(): String;
    Function GetPage: Integer; Override;
    Function GetPageCount: Integer; Override;
    Function GetPixelValue(Var x: Integer; Var y: Integer): Integer; Override;
    Function GetRedGreenBlueValue(Var x: Integer; Var y: Integer; Var Red: Integer; Var Green: Integer; Var Blue: Integer): Boolean; Override;
    Function GetWidth(): Integer; Override;
    Function IsDICOMHeaderInImageFormat(): Boolean; Override;
    Function IsFormatSupportMeasurements(Dicomdata: TDicomData): Boolean; Override;
    Function IsFormatSupportWinLev(): Boolean; Override;
    Function IsSigned(): Boolean; Override;
    Function LoadDICOMData(Var Dicomdata: TDicomData): Boolean; Override;
    Procedure AddComponentToViewComponent(Control: TControl); Override;
    Procedure Annotations; Override;
    Procedure AutoWinLevel; Override;
    Procedure BrightnessContrastValue(Bri, Con: Integer); Override;
    Procedure BrightnessValue(Value: Integer); Override;
    Procedure CalculateMaxWinLev(); Override;
    Procedure ClearImage(); Override;
    Procedure ContrastValue(Value: Integer); Override;
    Procedure CopyToClipboard(); Override;
    Procedure CopyToClipboardRadiology(); Override;
    Procedure DeSkewAndSmooth; Override;
    Procedure DeSkewImage; Override;
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
  FmagAnnotation,
  FMagAnnotationIG14,
{$ENDIF}
  Fmagig14dicomheader,
  FMagIG14PanWindow,
  Forms,
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
  If (FrmIG14PanWindow <> Nil) Then
  Begin
    FrmIG14PanWindow.Visible := False;
    FreeAndNil(FrmIG14PanWindow);
  End;
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
  Inherited;
End;

Constructor TMag4VGear14.Create(AOwner: TComponent;
  GearAbilities: TMagGearAbilities = MagGearAbilityRadiology);
Begin
  Inherited;
  Self.Name := '';
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

{$IFDEF USENEWANNOTS}
    FAnnotationComponent := TMagAnnot.Create(Self);
    FAnnotationComponent.IGPageViewCtl := IGPageViewCtl1;
    FAnnotationComponent.InitializeVariables();
{$ELSE}
    FAnnotationComponent := TMagAnnotationIG14.Create(Self);
    GetIGManager.IGCoreCtrl.AssociateComponent((FAnnotationComponent As TMagAnnotationIG14).GetArtComponentInterface());
    FAnnotationComponent.InitializeVariables();
{$ENDIF}
  End;
  If FGearAbilities = MagGearAbilityRadiology Then
  Begin
    MedDataDict := GetIGManager.IGMedCtrl.DataDict;
  End;
  CreatePage();
  FAnnotationsNeverLoaded := True;

  FWindowValueMax := 0;
  FLevelValueMax := 0;
  FLevelValueMin := 0;
  FWindowValueMin := 1;

  FHeight := -1;
  FWidth := -1;

  FImageFormat := IG_FORMAT_UNKNOWN;
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
              //LogMsg('s','Exception [' + e.Message + '] On Element (' + TagGroup + ',' + TagElement + ')', MagLogWARN);
                      MagLogger.LogMsg('s', 'Exception [' + e.Message + '] On Element (' +
                        TagGroup + ',' + TagElement + ')', MagLogWARN); {JK 10/5/2009 - Maggmsgu refactoring}
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
               //LogMsg('s','Exception [' + e.Message + '] On Element (' + TagGroup + ',' + TagElement + ')', MagLogWARN);
                          MagLogger.LogMsg('s', 'Exception [' + e.Message + '] On Element (' +
                            TagGroup + ',' + TagElement + ')', MagLogWARN); {JK 10/5/2009 - Maggmsgu refactoring}
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
               //LogMsg('s','Exception [' + e.Message + '] On Element (' + TagGroup + ',' + TagElement + ')', MagLogWARN);
                            MagLogger.LogMsg('s', 'Exception [' + e.Message + '] On Element (' +
                              TagGroup + ',' + TagElement + ')', MagLogWARN); {JK 10/5/2009 - Maggmsgu refactoring}
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
               //LogMsg('s','Exception [' + e.Message + '] On Element (' + TagGroup + ',' + TagElement + ')', MagLogWARN);
                              MagLogger.LogMsg('s', 'Exception [' + e.Message + '] On Element (' +
                                TagGroup + ',' + TagElement + ')', MagLogWARN); {JK 10/5/2009 - Maggmsgu refactoring}
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
             //LogMsg('s','Exception [' + e.Message + '] On Element (' + TagGroup + ',' + TagElement + ')', MagLogWARN);
                              MagLogger.LogMsg('s', 'Exception [' + e.Message + '] On Element (' +
                                TagGroup + ',' + TagElement + ')', MagLogWARN); {JK 10/5/2009 - Maggmsgu refactoring}
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
              //LogMsg('s','Exception [' + e.Message + '] On Element (' + TagGroup + ',' + TagElement + ')', MagLogWARN);
                          MagLogger.LogMsg('s', 'Exception [' + e.Message + '] On Element (' +
                            TagGroup + ',' + TagElement + ')', MagLogWARN); {JK 10/5/2009 - Maggmsgu refactoring}
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
              //LogMsg('s','Exception [' + e.Message + '] On Element (' + TagGroup + ',' + TagElement + ')', MagLogWARN);
                                MagLogger.LogMsg('s', 'Exception [' + e.Message + '] On Element (' +
                                  TagGroup + ',' + TagElement + ')', MagLogWARN); {JK 10/5/2009 - Maggmsgu refactoring}
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
              //LogMsg('s','Exception [' + e.Message + '] On Element (' + TagGroup + ',' + TagElement + ')', MagLogWARN);
                                    MagLogger.LogMsg('s', 'Exception [' + e.Message + '] On Element (' +
                                      TagGroup + ',' + TagElement + ')', MagLogWARN); {JK 10/5/2009 - Maggmsgu refactoring}
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
            //LogMsg('s','Exception [' + e.Message + '] On Element (' + TagGroup + ',' + TagElement + ')', MagLogWARN);
                        MagLogger.LogMsg('s', 'Exception [' + e.Message + '] On Element (' +
                          TagGroup + ',' + TagElement + ')', MagLogWARN); {JK 10/5/2009 - Maggmsgu refactoring}
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
            //LogMsg('s','Exception [' + e.Message + '] On Element (' + TagGroup + ',' + TagElement + ')', MagLogWARN);
                            MagLogger.LogMsg('s', 'Exception [' + e.Message + '] On Element (' +
                              TagGroup + ',' + TagElement + ')', MagLogWARN); {JK 10/5/2009 - Maggmsgu refactoring}
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
            //LogMsg('s','Exception [' + e.Message + '] On Element (' + TagGroup + ',' + TagElement + ')', MagLogWARN);
                              MagLogger.LogMsg('s', 'Exception [' + e.Message + '] On Element (' +
                                TagGroup + ',' + TagElement + ')', MagLogWARN); {JK 10/5/2009 - Maggmsgu refactoring}
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
            //LogMsg('s','Exception [' + e.Message + '] On Element (' + TagGroup + ',' + TagElement + ')', MagLogWARN);
                                MagLogger.LogMsg('s', 'Exception [' + e.Message + '] On Element (' +
                                  TagGroup + ',' + TagElement + ')', MagLogWARN); {JK 10/5/2009 - Maggmsgu refactoring}
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
            //LogMsg('s','Exception [' + e.Message + '] On Element (' + TagGroup + ',' + TagElement + ')', MagLogWARN);
                                  MagLogger.LogMsg('s', 'Exception [' + e.Message + '] On Element (' +
                                    TagGroup + ',' + TagElement + ')', MagLogWARN); {JK 10/5/2009 - Maggmsgu refactoring}
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
            //LogMsg('s','Exception [' + e.Message + '] On Element (' + TagGroup + ',' + TagElement + ')', MagLogWARN);
                                    MagLogger.LogMsg('s', 'Exception [' + e.Message + '] On Element (' +
                                      TagGroup + ',' + TagElement + ')', MagLogWARN); {JK 10/5/2009 - Maggmsgu refactoring}
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
            //LogMsg('s','Exception [' + e.Message + '] On Element (' + TagGroup + ',' + TagElement + ')', MagLogWARN);
                                      MagLogger.LogMsg('s', 'Exception [' + e.Message + '] On Element (' +
                                        TagGroup + ',' + TagElement + ')', MagLogWARN); {JK 10/5/2009 - Maggmsgu refactoring}
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
            //LogMsg('s','Exception [' + e.Message + '] On Element (' + TagGroup + ',' + TagElement + ')', MagLogWARN);
                                          MagLogger.LogMsg('s', 'Exception [' + e.Message + '] On Element (' +
                                            TagGroup + ',' + TagElement + ')', MagLogWARN); {JK 10/5/2009 - Maggmsgu refactoring}
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
            //LogMsg('s','Exception [' + e.Message + '] On Element (' + TagGroup + ',' + TagElement + ')', MagLogWARN);
                                            MagLogger.LogMsg('s', 'Exception [' + e.Message + '] On Element (' +
                                              TagGroup + ',' + TagElement + ')', MagLogWARN); {JK 10/5/2009 - Maggmsgu refactoring}
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
            //LogMsg('s','Exception [' + e.Message + '] On Element (' + TagGroup + ',' + TagElement + ')', MagLogWARN);
                                              MagLogger.LogMsg('s', 'Exception [' + e.Message + '] On Element (' +
                                                TagGroup + ',' + TagElement + ')', MagLogWARN); {JK 10/5/2009 - Maggmsgu refactoring}
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
            //LogMsg('s','Exception [' + e.Message + '] On Element (' + TagGroup + ',' + TagElement + ')', MagLogWARN);
                                                MagLogger.LogMsg('s', 'Exception [' + e.Message + '] On Element (' +
                                                  TagGroup + ',' + TagElement + ')', MagLogWARN); {JK 10/5/2009 - Maggmsgu refactoring}
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
      //LogMsg('s','Exception = ' + e.Message + #13 + 'TagGroup=[' + TagGroup + '], TagElement=[' + TagElement + ']', MagLogERROR);
      MagLogger.LogMsg('s', 'Exception = ' + e.Message + #13 +
        'TagGroup=[' + TagGroup + '], TagElement=[' + TagElement + ']', MagLogERROR); {JK 10/5/2009 - Maggmsgu refactoring}
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
Begin
  DataString := '';
  If Not FAnnotationsNeverLoaded Then
  Begin
    If FAnnotationComponent <> Nil Then
    Begin
//      FAnnotationComponent.ClearLastAnnotation();
//      FAnnotationComponent.MouseUpEvent(1, 1, 1);
    End;
    // do something to clear annotations object?
  End;
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
    AnnotationComponent.HasBeenModified := False;

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
        //LogMsg('s','Exception getting med contrast, ' + e.Message, MagLogERROR);
        MagLogger.LogMsg('s', 'Exception getting med contrast, ' + e.Message, MagLogERROR); {JK 10/5/2009 - Maggmsgu refactoring}
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
      GetIGManager.IGFormatsCtrl.LoadPageFromFile(CurrentPage, Filename, 0); //dialogLoadOptions.PageNum);

      FPage := 1;
      PageInfo := GetIGManager.IGFormatsCtrl.GetPageInfo(IoLocation, FPage - 1, IG_FORMAT_UNKNOWN);
      FImageFormat := PageInfo.Format;
      FPageCount := GetIGManager.IGFormatsCtrl.GetPageCount(IoLocation, IG_FORMAT_UNKNOWN);

    // update the view control to repaint the new active page (from AccuSoft for antialiasing)
    // 7/13/2006
    // JMW 5/6/08 P72 - Turn this off - certain scanned documents in TIF format were displaying
    // very bold. Complaint from Filipe (El Paso) about the images looking too bold and ugly compared to P59.
    // not sure why this was turned on, all images PDF, DICOM PDF, DICOM Report, ECG look fine with this off
    // not sure what turning this off might break...
//    IGPageViewCtl1.PageDisplay.AntiAliasing.Method := IG_DSPL_ANTIALIAS_SCALE_TO_GRAY + IG_DSPL_ANTIALIAS_COLOR;

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
      End;

//    GetMedContrast();
      If ((CurrentPage.BitDepth >= 8) And (CurrentPage.BitDepth <= 16)) Then
      Begin
        CurrentGrayLUT.ChangeAttrs(CurrentPage.BitDepth, CurrentPage.Signed, 8, False);
      End;
    Except
      On e: Exception Do
      Begin
        //LogMsg('s','error opening file [' + Filename + '] Error=[' + e.Message + ']', MagLogERROR);
        MagLogger.LogMsg('s', 'error opening file [' + Filename + '] Error=[' + e.Message + ']', MagLogERROR); {JK 10/5/2009 - Maggmsgu refactoring}
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
  FMouseAction := MactPan; // reset to hand pan ? maybe not...

  If FUpdatePageView Then IGPageViewCtl1.UpdateView();
End;

Procedure TMag4VGear14.FlipVert();
Begin
  If Not CurrentPage.IsValid Then Exit;
  GetIGManager.IGProcessingCtrl.Flip(CurrentPage, IG_FLIP_VERTICAL);
  If FUpdatePageView Then IGPageViewCtl1.UpdateView();
End;

Procedure TMag4VGear14.FlipHoriz();
Begin
  If Not CurrentPage.IsValid Then Exit;
  GetIGManager.IGProcessingCtrl.Flip(CurrentPage, IG_FLIP_HORIZONTAL);
  If FUpdatePageView Then IGPageViewCtl1.UpdateView();
End;

Procedure TMag4VGear14.Rotate(Deg: Integer);
Begin
  If Not CurrentPage.IsValid Then Exit;
  GetIGManager.IGProcessingCtrl.Rotate90k(CurrentPage, Deg);
  If FUpdatePageView Then IGPageViewCtl1.UpdateView();
End;

Procedure TMag4VGear14.Inverse;
Begin
  If Not CurrentPage.IsValid Then Exit;
  CurrentPage.ROI.Convert(IG_ROI_ALL_IMAGE);
  GetIGManager.IGProcessingCtrl.ContrastOptions.Mode := IG_CONTRAST_PIXEL;
  GetIGManager.IGProcessingCtrl.InvertContrast(CurrentPage);
  If FUpdatePageView Then IGPageViewCtl1.UpdateView();
End;

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
  If (FrmIG14PanWindow <> Nil) And (FrmIG14PanWindow.Visible) Then
  Begin
    PanWindowSettings(0, 0, 0, 0);
  End;
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
      //LogMsg('s', 'Exception getting zoom factor [' + e.Message + ']', MagLogERROR);
      MagLogger.LogMsg('s', 'Exception getting zoom factor [' + e.Message + ']', MagLogERROR); {JK 10/5/2009 - Maggmsgu refactoring}
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
  Result := 0;
  If IoLocation = Nil Then Exit;
  If Not CurrentPage.IsValid Then Exit;
  //result := IGFormatsCtl1.GetPageInfo(IOLocation, FPage, IG_FORMAT_UNKNOWN).BitDepth;
  // need to use FPage - 1 since Fpage starts at 1 but IG14 starts pages at 0
  Result := GetIGManager.IGFormatsCtrl.GetPageInfo(IoLocation, FPage - 1, IG_FORMAT_UNKNOWN).BitDepth;
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
      //LogMsg('s', 'Exception getting width [' + e.Message + ']', MagLogERROR);
      MagLogger.LogMsg('s', 'Exception getting width [' + e.Message + ']', MagLogERROR); {JK 10/5/2009 - Maggmsgu refactoring}
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
      //LogMsg('s', 'Exception getting height [' + e.Message + ']', MagLogERROR);
      MagLogger.LogMsg('s', 'Exception getting height [' + e.Message + ']', MagLogERROR); {JK 10/5/2009 - Maggmsgu refactoring}
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
  If FrmIG14PanWindow = Nil Then
  Begin
    FrmIG14PanWindow := TfrmIG14PanWindow.Create(Self);
    FrmIG14PanWindow.OnPanWindowClose := FPanWindowClose;
  End;
  If Not Value Then
  Begin
    // JMW 7/17/08 p72t23 - check to see if component uses pan window
    // to determine if pan window should be modified
    If (MagPanWindow In FComponentFunctions) Then
      FrmIG14PanWindow.Visible := Value;
  End;
End;

Procedure TMag4VGear14.PrintImage(Handle: HDC);
Var
  CurrentView: EnumIGDsplFitModes;
  OldMode: EnumIGDsplBackgroundModes;
  PARAM: IIGControlParameter;
Begin

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
  // print the page leaving space for the header
  IGPageViewCtl1.PageDisplay.PrintToPageWithLayout(Handle, 0, 0.02, 1, 0.98);
  SetView(CurrentView);
  CurrentPageDisp.Background.Mode := OldMode;

End;

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
End;

Procedure TMag4VGear14.SetBackgroundColor(Color: TColor);
Var
  ColorValue: Longint;
Begin
  If (Not CurrentPage.IsValid) Then Exit;
  ColorValue := ColorToRGB(Color);

  CurrentPageDisp.Background.Color.RGB_R := ColorValue;
  CurrentPageDisp.Background.Color.RGB_G := ColorValue Shr 8;
  CurrentPageDisp.Background.Color.RGB_B := ColorValue Shr 16;
  If FUpdatePageView Then IGPageViewCtl1.UpdateView();
End;

Procedure TMag4VGear14.MouseReSet;
Begin
  // do what?
  ///TODO: IG14 - MouseReSet
End;

Procedure TMag4VGear14.PanWindowSettings(h, w, x, y: Integer);
Begin
  If Not (MagPanWindow In FComponentFunctions) Then
    Exit;
  If CurrentPage.IsValid Then
  Begin
    FrmIG14PanWindow.Execute(GetIGManager.IGCoreCtrl.ComponentInterface, GetIGManager.IGDisplayCtrl.ComponentInterface, IGPageViewCtl1.PageDisplay,
      IGPageViewCtl1.Hwnd, h, w, x, y, Self);
    // JMW 7/14/08 p72t23 - set pan window close event to this viewer
    FrmIG14PanWindow.OnPanWindowClose := FPanWindowClose; // PanWindowCloseEvent;
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
  //LogMsg('s','Applying Window value [' + inttostr(WinValue) + '], Lev Value [' + inttostr(LevValue) + '] to IG14 image', MagLogDEBUG);
  MagLogger.LogMsg('s', 'Applying Window value [' +
    Inttostr(WinValue) + '], Lev Value [' + Inttostr(LevValue) + '] to IG14 image', MagLogDebug); {JK 10/5/2009 - Maggmsgu refactoring}
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
End;

Procedure TMag4VGear14.IGPageViewCtl1MouseDblClick(Sender: Tobject; Button,
  Shift: Smallint; x, y: Integer);
Begin
  Inherited;
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
  If (FMouseAction = MactAnnotation) Or (FMouseAction = MactMeasure) Or (FMouseAction = MactAnnotationPointer) Or (FMouseAction = MactProtractor) Then
  Begin
    If Not CurrentPage.IsValid Then Exit;
    AnnotationComponent.CurrentPoint.XPos := x;
    AnnotationComponent.CurrentPoint.YPos := y;
    nMessage := WM_LBUTTONDOWN;
    If (Button = 2) Then nMessage := WM_RBUTTONDOWN;
    AnnotationComponent.IGArtXGUICtl.MouseDown(AnnotationComponent.IGArtDrawParams, nMessage, AnnotationComponent.CurrentPoint);
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
        IGPanCtrl.TrackMouse(x, y);
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
    OnImageMouseDown(Owner, aButton, aShift, x, y);
  End;
End;

Procedure TMag4VGear14.IGPageViewCtl1MouseUp(Sender: Tobject; Button,
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
    If Assigned(FImageZoomChange) Then
      FImageZoomChange(Self, FZoomValue);
    UpdateScrollPos();
    If Assigned(FImageUpdateImageState) Then
      FImageUpdateImageState(Self);
  End;
  If FMouseAction = MactWinLev Then
  Begin
    IGPageViewCtl1.SelectEvent := IG_VIEW_SELECT_FIRE;
  End;

  // JMW 6/25/08 - update the pan window if it is visible
  If (FrmIG14PanWindow <> Nil) And (FrmIG14PanWindow.Visible) Then
  Begin
    PanWindowSettings(0, 0, 0, 0);
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
    OnImageMouseUp(Self, aButton, aShift, x, y);
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
      //LogMsg('', 'Exception getting file format: ' + e.Message, MagLogERROR);
      MagLogger.LogMsg('', 'Exception getting file format: ' + e.Message, MagLogERROR); {JK 10/5/2009 - Maggmsgu refactoring}
      Result := 'Unknown';
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
      Result := True;
    End;
  Except
    On e: Exception Do
    Begin
      //LogMsg('', 'Exception updating image resolution: ' + e.Message, MagLogERROR);
      MagLogger.LogMsg('', 'Exception updating image resolution: ' + e.Message, MagLogERROR); {JK 10/5/2009 - Maggmsgu refactoring}
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
Begin
  Val := GetWidth();
  // if the image has a different number of columns than the header values
  If Val <> Dicomdata.Columns Then
  Begin
    XDenom := Trunc(XDenom * (Dicomdata.Columns / Val));
  End;
  Val := GetHeight();
  // if the image has a different number of rows than the header values
  If Val <> Dicomdata.Rows Then
  Begin
    YDenom := Trunc(YDenom * (Dicomdata.Rows / Val));
  End;
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
      //LogMsg('', 'Exception getting file format: ' + e.Message, MagLogERROR);
      MagLogger.LogMsg('', 'Exception getting file format: ' + e.Message, MagLogERROR); {JK 10/5/2009 - Maggmsgu refactoring}
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
      //LogMsg('', 'Exception getting file format: ' + e.Message, MagLogERROR);
      MagLogger.LogMsg('', 'Exception getting file format: ' + e.Message, MagLogERROR); {JK 10/5/2009 - Maggmsgu refactoring}
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
      //LogMsg('', 'Exception getting file format to find DICOM header: ' + e.Message, MagLogERROR);
      MagLogger.LogMsg('', 'Exception getting file format to find DICOM header: ' + e.Message, MagLogERROR); {JK 10/5/2009 - Maggmsgu refactoring}
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
      //LogMsg('','Exception getting compression: ' + e.Message, MagLogERROR);
      MagLogger.LogMsg('', 'Exception getting compression: ' + e.Message, MagLogERROR); {JK 10/5/2009 - Maggmsgu refactoring}
      Result := 'Unknown';
      Exit;
    End;
  End;

End;

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
Begin
  Inherited;
  Try

    CurrentPage.ROI.Convert(IG_ROI_ALL_IMAGE);
    If MedContrast = Nil Then
      MedContrast := GetIGManager().IGMedCtrl.CreateObject(MED_OBJ_CONTRAST) As IIGMedContrast; ///

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
    MagLogger.LogMsg('s', 'WindowLevel Entire Image Values [' + Inttostr(FWindowValue) + '], Lev Value [' +
      Inttostr(FLevelValue) + '] to IG14 image', MagLogDebug); {JK 10/5/2009 - Maggmsgu refactoring}

//    if FUpdatePageView then // JMW 8/30/06
    // JMW 11/15/07 p72 - Put the check for FUpdatePageView back in
    If FUpdatePageView Then

      IGPageViewCtl1.UpdateView();
  Except
    On e: Exception Do
    Begin
      //LogMsg('','Exception window leveling entire image [' + e.Message + ']', MagLogERROR);
      MagLogger.LogMsg('', 'Exception window leveling entire image [' + e.Message + ']', MagLogERROR); {JK 10/5/2009 - Maggmsgu refactoring}
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
      If FAnnotationsNeverLoaded Then
      Begin
        initializeAnnotations();
      End;
      FontSize := Round(22 * Height_scale);
      Right := Left + Trunc(FontSize * 1.5);
      Bottom := Top + Trunc(FontSize * 2);

    // old font size = 18
    //FAnnotationComponent.drawText(left, top, right, bottom, red, green, blue, letter, fontSize);
      FAnnotationComponent.DrawText(Left, Right, Top, Bottom, Red, Green, Blue, Letter, FontSize);
      FAnnotationComponent.SetAnnotationStyles();
    End;
  Except
    On e: Exception Do
    Begin
      //LogMsg('s', 'Exception drawing Rad Characters [' + e.Message + ']', MagLogERROR);
      MagLogger.LogMsg('s', 'Exception drawing Rad Characters [' + e.Message + ']', MagLogERROR); {JK 10/5/2009 - Maggmsgu refactoring}
    End;
  End;
End;

Procedure TMag4VGear14.DisplayDICOMHeader();
Var
  HeaderDialog: TfrmIG14DICOMHeader;
Begin
  HeaderDialog := TfrmIG14DICOMHeader.Create(Self);
  //headerDialog.OnLogEvent := OnLogEvent; LogMsg('s','Exception loading DICOM header, ' + e.Message, magLogError);
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
      MagLogger.LogMsg('', 'Invalid location specified for getting pixel value for point (' +
        Inttostr(x) + '), (' + Inttostr(y) + ')'); {JK 10/5/2009 - Maggmsgu refactoring}
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
      MagLogger.LogMsg('', 'Error getting pixel value for point (' + Inttostr(x) + '), (' +
        Inttostr(y) + ') - ' + e.Message); {JK 10/5/2009 - Maggmsgu refactoring}
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
      MagLogger.LogMsg('', 'Invalid location specified for getting pixel value for point (' +
        Inttostr(x) + '), (' + Inttostr(y) + ')'); {JK 10/5/2009 - Maggmsgu refactoring}
      Exit;
    End;

    Pixel := Page.GetPixelCopy(x, y);
    Pixel.ChangeType(IG_PIXEL_RGB);

    r := Pixel.RGB_R;
    g := Pixel.RGB_G;
    b := Pixel.RGB_B;

    Red := r;
    Green := g;
    Blue := b;
    Result := True;

  Except
    On e: Exception Do
    Begin
      Result := False;
      //LogMsg('','Error getting RGB value for point (' + inttostr(x) + '), (' + inttostr(y) + ') - ' + e.Message);
      MagLogger.LogMsg('', 'Error getting RGB value for point (' +
        Inttostr(x) + '), (' + Inttostr(y) + ') - ' + e.Message); {JK 10/5/2009 - Maggmsgu refactoring}
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
  If FAnnotationsNeverLoaded Then
  Begin
    initializeAnnotations();
  End;
  FAnnotationComponent.EnableMeasurements();
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
  If FAnnotationsNeverLoaded Then
  Begin
    initializeAnnotations();
  End;
  FAnnotationComponent.SetTool(MagAnnToolPointer);
End;

Procedure TMag4VGear14.RemoveOrientationLabel();
Begin
  If Not CurrentPage.IsValid Then
    Exit;
  If FAnnotationsNeverLoaded Then
    Exit;
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
      //LogMsg('', 'Exception getting file format: ' + e.Message, MagLogERROR);
      MagLogger.LogMsg('', 'Exception getting file format: ' + e.Message, MagLogERROR); {JK 10/5/2009 - Maggmsgu refactoring}
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
  If FAnnotationsNeverLoaded Then
  Begin
    FAnnotationsNeverLoaded := False;
    cPoint := GetIGManager.IGCoreCtrl.CreateObject(IG_OBJ_POINT) As IIGPoint;
{$IFDEF USENEWANNOTS}
    FAnnotationComponent.Initialize(cPoint, CurrentPage, CurrentPageDisp, IGPageViewCtl1.Hwnd, True);
    FAnnotationComponent.SetAnnotationStyles();
    FAnnotationComponent.PageCount := FPageCount;
    FAnnotationComponent.Page := FPage;
    FAnnotationComponent.IGPageViewCtl := IGPageViewCtl1;
{$ELSE}
    (FAnnotationComponent As TMagAnnotationIG14).Initialize(cPoint, CurrentPage, CurrentPageDisp, IGPageViewCtl1.Hwnd, True);
    FAnnotationComponent.SetAnnotationStyles();
    (FAnnotationComponent As TMagAnnotationIG14).PageCount := FPageCount;
    (FAnnotationComponent As TMagAnnotationIG14).Page := FPage;
    FFontSize := getAnnotationFontSizeFromDPI;
    FAnnotationComponent.SetFont('Microsoft Sans Serif', FFontSize, False, False);
{$ENDIF}
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
      //LogMsg('s', 'Exception calculating font size, ' + e.Message, MagLogError);
      MagLogger.LogMsg('s', 'Exception calculating font size, ' + e.Message, MagLogERROR); {JK 10/5/2009 - Maggmsgu refactoring}
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

End.
