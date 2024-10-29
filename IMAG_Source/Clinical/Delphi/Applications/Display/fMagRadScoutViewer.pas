unit fMagRadScoutViewer;
(*
        ;; +---------------------------------------------------------------------------------------------------+
        ;;  MAG - IMAGING
        ;;  Property of the US Government.
        ;;  WARNING: Per VHA Directive 10-93-142 this unit should not be modified.
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
        ;;  Date created: April 2013
        ;;  Site Name:  Washington OI Field Office, Silver Spring, MD
        ;;  Developer:  Julian Werfel
        ;;  Description: This is a window to hold scout images for CT and MR
        ;;    studies.
        ;;
        ;;+---------------------------------------------------------------------------------------------------+
*)

interface

uses
  Windows, Messages, SysUtils, Variants, Classes, Graphics, Controls, Forms,
  Dialogs, cMag4Vgear, uMagclasses, uMagDefinitions, cMagStackViewer,
  cMagViewerRadTB2, cMagPat, Menus, cMagUtilsDB, ImgList, IMagPanWindow;

type
  TMagScoutImageMouseUpEvent = Procedure(Sender: Tobject; Button: TMouseButton;
    Shift: TShiftState; x, y: Integer; RootImg : TImageData; ScoutImage : TImageData) Of Object;

  TMagScoutColorChangeEvent = Procedure(Sender : TObject; Color : TColor) of object;

  TMagScoutViewerImageChangeEvent = Procedure(Sender : TObject) of object;

  TfrmScoutViewer = class(TForm)
    Mag4StackViewer1: TMag4StackViewer;
    magViewerRadTB21: TmagViewerRadTB2;
    MainMenu1: TMainMenu;
    mnuFile: TMenuItem;
    mnuFileClose: TMenuItem;
    mnuFileReport: TMenuItem;
    N1: TMenuItem;
    ImageList1: TImageList;
    mnuImage: TMenuItem;
    mnuImageZoom: TMenuItem;
    mnuImageZoomZoomIn: TMenuItem;
    mnuImageZoomZoomOut: TMenuItem;
    mnuImageZoomFittoWidth: TMenuItem;
    mnuImageZoomFittoHeight: TMenuItem;
    mnuImageZoomFittoWindow: TMenuItem;
    mnuImageZoomActualSize: TMenuItem;
    mnuImageMouse: TMenuItem;
    mnuImageMousePan: TMenuItem;
    mnuImageMouseMagnify: TMenuItem;
    mnuImageMouseZoom: TMenuItem;
    mnuImageMouseRuler: TMenuItem;
    mnuImageMouseAngleTool: TMenuItem;
    mnuImageMouseRulerAnglePointer: TMenuItem;
    mnuImageMouseAnnotations: TMenuItem;
    mnuImageMouseAutoWindowLevel: TMenuItem;
    mnuImageBriCon: TMenuItem;
    mnuImageBriConContrastUp: TMenuItem;
    mnuImageBriConContrastDown: TMenuItem;
    mnuImageBriConBrightnessUp: TMenuItem;
    mnuImageBriConBrightnessDown: TMenuItem;
    mnuImageWinLev: TMenuItem;
    mnuImageWinLevWindowUp: TMenuItem;
    mnuImageWinLevWindowDown: TMenuItem;
    mnuImageWinLevLevelUp: TMenuItem;
    mnuImageWinLevLevelDown: TMenuItem;
    mnuImageInvert: TMenuItem;
    mnuImageResetImage: TMenuItem;
    mnuImageScroll: TMenuItem;
    mnuImageScrollTopLeft: TMenuItem;
    mnuImageScrollTopRight: TMenuItem;
    mnuImageScrollBottomLeft: TMenuItem;
    mnuImageScrollBottomRight: TMenuItem;
    mnuImageScrollLeft: TMenuItem;
    mnuImageScrollRight: TMenuItem;
    mnuImageScrollUp: TMenuItem;
    mnuImageScrollDown: TMenuItem;
    N2: TMenuItem;
    mnuImageFirstImage: TMenuItem;
    mnuImagePreviousImage: TMenuItem;
    mnuImageNextImage: TMenuItem;
    mnuImageLastImage: TMenuItem;
    mnuView: TMenuItem;
    mnuViewPanWindow: TMenuItem;
    mnuViewBar1: TMenuItem;
    mnuViewGoToMainWindow: TMenuItem;
    mnuViewActivewindows: TMenuItem;
    mnuRotate: TMenuItem;
    mnuRotateClockwise90: TMenuItem;
    mnuRotateMinus90: TMenuItem;
    mnuRotate180: TMenuItem;
    mnuRotateBar1: TMenuItem;
    mnuRotateFlipHorizontal: TMenuItem;
    mnuRotateFlipVertical: TMenuItem;
    mnuCTPresets: TMenuItem;
    mnuCTPresetsAbdomen: TMenuItem;
    mnuCTPresetsBone: TMenuItem;
    mnuCTPresetsDisk: TMenuItem;
    mnuCTPresetsHead: TMenuItem;
    mnuCTPresetsLung: TMenuItem;
    mnuCTPresetsMediastinum: TMenuItem;
    mnuCTBar1: TMenuItem;
    mnuCTCustom1: TMenuItem;
    mnuCTCustom2: TMenuItem;
    mnuCTCustom3: TMenuItem;
    mnuViewInfo: TMenuItem;
    mnuViewInfoImageInfo: TMenuItem;
    mnuViewInfoDICOMHeader: TMenuItem;
    mnuViewInfoRadiologyImageInfo: TMenuItem;
    mnuViewInfoInformationAdvanced: TMenuItem;
    mnuOptions: TMenuItem;
    mnuOptionsMouseMagnifyShape: TMenuItem;
    mnuOptionsMouseMagnifyShapeCircle: TMenuItem;
    mnuOptionsMouseMagnifyShapeRectangle: TMenuItem;
    mnuScout: TMenuItem;
    mnuScoutRemoveImage: TMenuItem;
    mnuScoutBar1: TMenuItem;
    mnuScoutColor: TMenuItem;
    mnuScoutColorRed: TMenuItem;
    mnuScoutColorBlue: TMenuItem;
    mnuScoutColorGreen: TMenuItem;
    mnuScoutColorYellow: TMenuItem;
    mnuTest: TMenuItem;
    mnuTestFindAssociatedImageatPoint: TMenuItem;
    procedure FormCreate(Sender: TObject);
    procedure FormClose(Sender: TObject; var Action: TCloseAction);
    procedure mnuFileCloseClick(Sender: TObject);
    procedure mnuFileReportClick(Sender: TObject);
    procedure mnuImageZoomZoomInClick(Sender: TObject);
    procedure mnuImageZoomZoomOutClick(Sender: TObject);
    procedure mnuImageZoomFittoWidthClick(Sender: TObject);
    procedure mnuImageZoomFittoHeightClick(Sender: TObject);
    procedure mnuImageZoomFittoWindowClick(Sender: TObject);
    procedure mnuImageZoomActualSizeClick(Sender: TObject);
    procedure mnuImageMousePanClick(Sender: TObject);
    procedure mnuImageMouseMagnifyClick(Sender: TObject);
    procedure mnuImageMouseZoomClick(Sender: TObject);
    procedure mnuImageMouseAutoWindowLevelClick(Sender: TObject);
    procedure mnuImageMouseAnnotationsClick(Sender: TObject);
    procedure mnuImageBriConContrastUpClick(Sender: TObject);
    procedure mnuImageBriConContrastDownClick(Sender: TObject);
    procedure mnuImageBriConBrightnessUpClick(Sender: TObject);
    procedure mnuImageBriConBrightnessDownClick(Sender: TObject);
    procedure mnuImageWinLevWindowUpClick(Sender: TObject);
    procedure mnuImageWinLevWindowDownClick(Sender: TObject);
    procedure mnuImageWinLevLevelUpClick(Sender: TObject);
    procedure mnuImageWinLevLevelDownClick(Sender: TObject);
    procedure mnuImageInvertClick(Sender: TObject);
    procedure mnuImageResetImageClick(Sender: TObject);
    procedure mnuImageScrollTopLeftClick(Sender: TObject);
    procedure mnuImageScrollTopRightClick(Sender: TObject);
    procedure mnuImageScrollBottomLeftClick(Sender: TObject);
    procedure mnuImageScrollBottomRightClick(Sender: TObject);
    procedure mnuImageScrollLeftClick(Sender: TObject);
    procedure mnuImageScrollRightClick(Sender: TObject);
    procedure mnuImageScrollUpClick(Sender: TObject);
    procedure mnuImageScrollDownClick(Sender: TObject);
    procedure mnuImageFirstImageClick(Sender: TObject);
    procedure mnuImagePreviousImageClick(Sender: TObject);
    procedure mnuImageNextImageClick(Sender: TObject);
    procedure mnuImageLastImageClick(Sender: TObject);
    procedure mnuViewPanWindowClick(Sender: TObject);
    procedure mnuViewGoToMainWindowClick(Sender: TObject);
    procedure mnuViewActivewindowsClick(Sender: TObject);
    procedure mnuRotateClockwise90Click(Sender: TObject);
    procedure mnuRotateMinus90Click(Sender: TObject);
    procedure mnuRotate180Click(Sender: TObject);
    procedure mnuRotateFlipHorizontalClick(Sender: TObject);
    procedure mnuRotateFlipVerticalClick(Sender: TObject);
    procedure mnuCTPresetsMediastinumClick(Sender: TObject);
    procedure mnuCTPresetsAbdomenClick(Sender: TObject);
    procedure mnuCTPresetsBoneClick(Sender: TObject);
    procedure mnuCTPresetsDiskClick(Sender: TObject);
    procedure mnuCTPresetsHeadClick(Sender: TObject);
    procedure mnuCTPresetsLungClick(Sender: TObject);
    procedure mnuCTCustom1Click(Sender: TObject);
    procedure mnuCTCustom2Click(Sender: TObject);
    procedure mnuCTCustom3Click(Sender: TObject);
    procedure mnuViewInfoImageInfoClick(Sender: TObject);
    procedure mnuViewInfoDICOMHeaderClick(Sender: TObject);
    procedure mnuViewInfoInformationAdvancedClick(Sender: TObject);
    procedure mnuViewInfoRadiologyImageInfoClick(Sender: TObject);
    procedure mnuOptionsMouseMagnifyShapeCircleClick(Sender: TObject);
    procedure mnuOptionsMouseMagnifyShapeRectangleClick(Sender: TObject);
    procedure mnuScoutColorRedClick(Sender: TObject);
    procedure mnuScoutColorBlueClick(Sender: TObject);
    procedure mnuScoutColorGreenClick(Sender: TObject);
    procedure mnuScoutColorYellowClick(Sender: TObject);
    procedure mnuScoutRemoveImageClick(Sender: TObject);
    procedure FormDestroy(Sender: TObject);
  private
    FRootImg : TImageData;
    FScoutImages : TList;
    FCurrentPatient : TMag4Pat;
    FScoutImageMouseUp: TMagScoutImageMouseUpEvent;
    FCTPresets : TStrings;
    FForDICOMViewer : boolean;
    FScoutLineColor : TColor;
    FScoutColorChange : TMagScoutColorChangeEvent;
    FScoutViewerImageChange : TMagScoutViewerImageChangeEvent;
    FLoadingImage : boolean;
    FPanWindowHolder : TMagPanWindowHolder;

    Procedure Mag4StackViewer1ClickEvent(Sender: Tobject; StackViewer: TMag4StackViewer; MagImage: TMag4VGear);
    procedure receiveImageMouseUpEvent(Sender: Tobject; Button: TMouseButton; Shift: TShiftState; x, y: Integer);
    procedure UpdateMenuState(vGear : TMag4VGear);
    Procedure SetWindowLevel(Win, Lev: String);
    Procedure Mag4StackViewerImageChanged(Sender: Tobject; MagImage: TMag4VGear);
    Procedure PanWindowCloseEvent(Sender: Tobject);
  public
    constructor Create(AOwner: TComponent; ForDICOMViewer : boolean); reintroduce; overload;
    procedure DisplayScoutImages(CurrentPatient : TMag4Pat; RootImg : TImageData; ScoutImages : TList);
    procedure SelectedImageChanged(SelectedImage : TImageData);
    procedure ClearScoutImages();
    Procedure SetUtilsDB(UtilsDb: TMagUtilsDB);
    procedure SetCTPresets(CTPresets : TStrings);
    procedure AddImageToScoutWindow(Image : TImageData);
    function IsStudyLoaded() : boolean;
    procedure HideScoutLine();
    Procedure SetScoutLineColor(Color : TColor);
    Procedure ShowTestMenu(Value : Boolean);

  published
    Property OnScoutImageMouseUp: TMagScoutImageMouseUpEvent Read FScoutImageMouseUp Write FScoutImageMouseUp;
    Property OnScoutColorChange : TMagScoutColorChangeEvent Read FScoutColorChange Write FScoutColorChange;
    Property OnScoutViewerImageChange : TMagScoutViewerImageChangeEvent read FScoutViewerImageChange write FScoutViewerImageChange;
  end;

implementation

{$R *.dfm}
uses
  uMagRadHeaderLoader, imaginterfaces, magpositions, umagutils8a,
    uMagUtils8, FMagRadImageInfo, uMagDisplayMgr, FMagRadiologyImageInfo;

constructor TfrmScoutViewer.Create(AOwner: TComponent; ForDICOMViewer : boolean);
begin
  inherited Create(AOwner);
  FScoutImages := nil;
  self.FForDICOMViewer := ForDICOMViewer;
  FLoadingImage := false;
end;

procedure TfrmScoutViewer.DisplayScoutImages(CurrentPatient : TMag4Pat;
  RootImg : TImageData; ScoutImages : TList);
var
  IObj : TImageData;
begin
  try
    FLoadingImage := true;
    FScoutImages := ScoutImages;
    FCurrentPatient := CurrentPatient;
    FRootImg := RootImg;
    IObj := ScoutImages[0];

    self.Show;

    Mag4StackViewer1.OpenStudy(IObj, FScoutImages, IObj.ExpandedDescription(false));
    Mag4StackViewer1.SetSelected();

    UpdateMenuState(Mag4StackViewer1.GetCurrentImage());
  finally
    FLoadingImage := false;
  end;
end;

{ Scout images are already displayed, add to existing and display the new image }
procedure TfrmScoutViewer.AddImageToScoutWindow(Image : TImageData);
var
  IObj : TImageData;
  t : TList;
begin
  try
    FLoadingImage := true;
    IObj := FScoutImages[0];
    FScoutImages.Add(Image);

    t := TList.Create();
    t.Add(Image);

    Mag4StackViewer1.OpenStudy(IObj, t,
      IObj.ExpandedDescription(false), FScoutImages.Count - 1, true);
  finally
    FLoadingImage := false;
  end;
end;

Procedure TfrmScoutViewer.Mag4StackViewer1ClickEvent(Sender: Tobject; StackViewer: TMag4StackViewer; MagImage: TMag4VGear);
begin
  magViewerRadTB21.UpdateImageState;
  UpdateMenuState(Mag4StackViewer1.GetCurrentImage());
end;

procedure TfrmScoutViewer.UpdateMenuState(vGear : TMag4VGear);
var
  ImgState: TMagImageState;
begin
  if vGear <> nil then
  begin
    ImgState := vGear.GetState;

    Self.caption := 'Scout Window: ' + FCurrentPatient.M_PatName;
    if imgState <> nil then
    begin
      If ImgState.ReducedQuality Then
        Self.caption := Self.caption + ' -- Reduced Size, reference quality image';




      MnuCTPresets.Enabled := ImgState.CTPresetsEnabled;
    {
    If ImgState.MeasurementsEnabled Then
    Begin
      MnuToolsRulerEnabled.Enabled := True;
      If ImgState.MouseAction = MactMeasure Then
       // JMW 4/15/08 - reset to true, why was false?
        MnuToolsRulerEnabled.Checked := True //false //true  //ruler// gek - I changed this to false.
      Else
        MnuToolsRulerEnabled.Checked := False;
    End
    Else
    Begin
      MnuToolsRulerEnabled.Enabled := False;
    End;
    If ImgState.MouseAction = MactAnnotationPointer Then
      MnuToolsRulerPointer.Checked := True
    Else
      MnuToolsRulerPointer.Checked := False;
    If ImgState.MouseAction = MactProtractor Then
      MnuToolsProtractorEnabled.Checked := True
    Else
      MnuToolsProtractorEnabled.Checked := False;
      }

      // JMW 8/11/08 - set properties for the 508 menus
      MnuImageBriCon.Visible := Not ImgState.WinLevEnabled;
      MnuImageWinLev.Visible := ImgState.WinLevEnabled;
      MnuViewPanWindow.Checked := vGear.PanWindow;

      FreeAndNil(ImgState);
    end;                   
  end;
end;

procedure TfrmScoutViewer.mnuCTCustom1Click(Sender: TObject);
begin
  SetWindowLevel(MagPiece(FCTPresets[6], '|', 2), MagPiece(FCTPresets[6], '|', 3));
end;

procedure TfrmScoutViewer.mnuCTCustom2Click(Sender: TObject);
begin
  SetWindowLevel(MagPiece(FCTPresets[7], '|', 2), MagPiece(FCTPresets[7], '|', 3));
end;

procedure TfrmScoutViewer.mnuCTCustom3Click(Sender: TObject);
begin
  SetWindowLevel(MagPiece(FCTPresets[8], '|', 2), MagPiece(FCTPresets[8], '|', 3));
end;

procedure TfrmScoutViewer.mnuCTPresetsAbdomenClick(Sender: TObject);
begin
  SetWindowLevel(MagPiece(FCTPresets[0], '|', 2), MagPiece(FCTPresets[0], '|', 3));
end;

procedure TfrmScoutViewer.mnuCTPresetsBoneClick(Sender: TObject);
begin
  SetWindowLevel(MagPiece(FCTPresets[1], '|', 2), MagPiece(FCTPresets[1], '|', 3));
end;

procedure TfrmScoutViewer.mnuCTPresetsDiskClick(Sender: TObject);
begin
  SetWindowLevel(MagPiece(FCTPresets[2], '|', 2), MagPiece(FCTPresets[2], '|', 3));
end;

procedure TfrmScoutViewer.mnuCTPresetsHeadClick(Sender: TObject);
begin
  SetWindowLevel(MagPiece(FCTPresets[3], '|', 2), MagPiece(FCTPresets[3], '|', 3));
end;

procedure TfrmScoutViewer.mnuCTPresetsLungClick(Sender: TObject);
begin
  SetWindowLevel(MagPiece(FCTPresets[4], '|', 2), MagPiece(FCTPresets[4], '|', 3));
end;

procedure TfrmScoutViewer.mnuCTPresetsMediastinumClick(Sender: TObject);
begin
  SetWindowLevel(MagPiece(FCTPresets[5], '|', 2), MagPiece(FCTPresets[5], '|', 3));
end;

procedure TfrmScoutViewer.mnuFileCloseClick(Sender: TObject);
begin
  self.Close;
end;

procedure TfrmScoutViewer.mnuFileReportClick(Sender: TObject);
begin
  Mag4StackViewer1.ImageReport();
end;

procedure TfrmScoutViewer.mnuImageBriConBrightnessDownClick(Sender: TObject);
begin
  With magViewerRadTB21 Do
  Begin
    If ((sbWin.Position - 15) < sbWin.Min) Then
      sbWin.Position := sbWin.Min
    Else
      sbWin.Position := sbWin.Position - 15;
  End;
end;

procedure TfrmScoutViewer.mnuImageBriConBrightnessUpClick(Sender: TObject);
begin
  With magViewerRadTB21 Do
  Begin
    If ((sbWin.Position + 15) > sbWin.Max) Then
      sbWin.Position := sbWin.Max
    Else
      sbWin.Position := sbWin.Position + 15;
  End;
end;

procedure TfrmScoutViewer.mnuImageBriConContrastDownClick(Sender: TObject);
begin
  With magViewerRadTB21 Do
  Begin
    If ((sbLev.Position - 5) < 0) Then
      sbLev.Position := 0
    Else
      sbLev.Position := sbLev.Position - 5;
  End;
end;

procedure TfrmScoutViewer.mnuImageBriConContrastUpClick(Sender: TObject);
begin
  With magViewerRadTB21 Do
  Begin
    If ((sbLev.Position + 5) > sbLev.Max) Then
      sbLev.Position := sbLev.Max
    Else
      sbLev.Position := sbLev.Position + 5;
  End;
end;

procedure TfrmScoutViewer.mnuImageFirstImageClick(Sender: TObject);
begin
  Mag4StackViewer1.PageFirstViewer(true);
end;

procedure TfrmScoutViewer.mnuImageInvertClick(Sender: TObject);
begin
  magViewerRadTB21.Inverse();
end;

procedure TfrmScoutViewer.mnuImageLastImageClick(Sender: TObject);
begin
  Mag4StackViewer1.PageLastViewer(true);
end;

procedure TfrmScoutViewer.mnuImageMouseAnnotationsClick(Sender: TObject);
begin
  Mag4StackViewer1.btnAnnotationsClick(Sender);
end;

procedure TfrmScoutViewer.mnuImageMouseAutoWindowLevelClick(Sender: TObject);
begin
  magViewerRadTB21.SetCurrentTool(MactWinLev);
end;

procedure TfrmScoutViewer.mnuImageMouseMagnifyClick(Sender: TObject);
begin
  magViewerRadTB21.SetCurrentTool(MactMagnify);
end;

procedure TfrmScoutViewer.mnuImageMousePanClick(Sender: TObject);
begin
  magViewerRadTB21.SetCurrentTool(MactPan);
end;

procedure TfrmScoutViewer.mnuImageMouseZoomClick(Sender: TObject);
begin
  magViewerRadTB21.SetCurrentTool(MactZoomRect);
end;

procedure TfrmScoutViewer.mnuImageNextImageClick(Sender: TObject);
begin
  Mag4StackViewer1.PageNextViewer(true);
end;

procedure TfrmScoutViewer.mnuImagePreviousImageClick(Sender: TObject);
begin
  Mag4StackViewer1.PagePrevViewer(true);
end;

procedure TfrmScoutViewer.mnuImageResetImageClick(Sender: TObject);
begin
  Mag4StackViewer1.ResetImages();
  magViewerRadTB21.UpdateImageState();
end;

procedure TfrmScoutViewer.mnuImageScrollBottomLeftClick(Sender: TObject);
begin
  magViewerRadTB21.ScrollCornerBL;
end;

procedure TfrmScoutViewer.mnuImageScrollBottomRightClick(Sender: TObject);
begin
  magViewerRadTB21.ScrollCornerBR;
end;

procedure TfrmScoutViewer.mnuImageScrollDownClick(Sender: TObject);
begin
  magViewerRadTB21.ScrollDown;
end;

procedure TfrmScoutViewer.mnuImageScrollLeftClick(Sender: TObject);
begin
  magViewerRadTB21.ScrollLeft
end;

procedure TfrmScoutViewer.mnuImageScrollRightClick(Sender: TObject);
begin
  magViewerRadTB21.ScrollRight;
end;

procedure TfrmScoutViewer.mnuImageScrollTopLeftClick(Sender: TObject);
begin
  magViewerRadTB21.ScrollCornerTL();
end;

procedure TfrmScoutViewer.mnuImageScrollTopRightClick(Sender: TObject);
begin
  magViewerRadTB21.ScrollCornerTR();
end;

procedure TfrmScoutViewer.mnuImageScrollUpClick(Sender: TObject);
begin
  magViewerRadTB21.ScrollUp;
end;

procedure TfrmScoutViewer.mnuImageWinLevLevelDownClick(Sender: TObject);
begin
  With magViewerRadTB21 Do
  Begin
    If ((sbLev.Position - 5) < sbLev.Min) Then
      sbLev.Position := sbLev.Min
    Else
      sbLev.Position := sbLev.Position - 5;
  End;
end;

procedure TfrmScoutViewer.mnuImageWinLevLevelUpClick(Sender: TObject);
begin
  With magViewerRadTB21 Do
  Begin
    If ((sbLev.Position + 5) > sbLev.Max) Then
      sbLev.Position := sbLev.Max
    Else
      sbLev.Position := sbLev.Position + 5;
  End;
end;

procedure TfrmScoutViewer.mnuImageWinLevWindowDownClick(Sender: TObject);
begin
  With magViewerRadTB21 Do
  Begin
    If ((sbWin.Position - 5) < sbWin.Min) Then
      sbWin.Position := sbWin.Min
    Else
      sbWin.Position := sbWin.Position - 5;
  End;
end;

procedure TfrmScoutViewer.mnuImageWinLevWindowUpClick(Sender: TObject);
begin
  With magViewerRadTB21 Do
  Begin
    If ((sbWin.Position + 5) > sbWin.Max) Then
      sbWin.Position := sbWin.Max
    Else
      sbWin.Position := sbWin.Position + 5;
  End;
end;

procedure TfrmScoutViewer.mnuImageZoomActualSizeClick(Sender: TObject);
begin
  Mag4StackViewer1.Fit1to1;
  magViewerRadTB21.UpdateImageState;
end;

procedure TfrmScoutViewer.mnuImageZoomFittoHeightClick(Sender: TObject);
begin
  Mag4StackViewer1.FitToHeight;
  magViewerRadTB21.UpdateImageState;
end;

procedure TfrmScoutViewer.mnuImageZoomFittoWidthClick(Sender: TObject);
begin
  Mag4StackViewer1.FitToWidth;
  magViewerRadTB21.UpdateImageState;
end;

procedure TfrmScoutViewer.mnuImageZoomFittoWindowClick(Sender: TObject);
begin
  Mag4StackViewer1.FitToWindow;
  magViewerRadTB21.UpdateImageState;
end;

procedure TfrmScoutViewer.mnuImageZoomZoomInClick(Sender: TObject);
begin
  magViewerRadTB21.sbZoom.Position := magViewerRadTB21.sbZoom.Position + 20;
  magViewerRadTB21.UpdateImageState;
end;

procedure TfrmScoutViewer.mnuImageZoomZoomOutClick(Sender: TObject);
begin
  magViewerRadTB21.sbZoom.Position := magViewerRadTB21.sbZoom.Position - 20;
  magViewerRadTB21.UpdateImageState;
end;

procedure TfrmScoutViewer.mnuOptionsMouseMagnifyShapeCircleClick(
  Sender: TObject);
begin
  Mag4StackViewer1.SetMouseZoomShape(MagMouseZoomShapeCircle);
  mnuOptionsMouseMagnifyShapeCircle.Checked := True;
  mnuOptionsMouseMagnifyShapeRectangle.Checked := False;
end;

procedure TfrmScoutViewer.mnuOptionsMouseMagnifyShapeRectangleClick(
  Sender: TObject);
begin
  Mag4StackViewer1.SetMouseZoomShape(MagMouseZoomShapeRectangle);
  mnuOptionsMouseMagnifyShapeCircle.Checked := false;
  mnuOptionsMouseMagnifyShapeRectangle.Checked := true;
end;

procedure TfrmScoutViewer.mnuRotate180Click(Sender: TObject);
begin
  magViewerRadTB21.Rotate180();
end;

procedure TfrmScoutViewer.mnuRotateClockwise90Click(Sender: TObject);
begin
  magViewerRadTB21.Rotate90();
end;

procedure TfrmScoutViewer.mnuRotateFlipHorizontalClick(Sender: TObject);
begin
  magViewerRadTB21.FlipHorizontal();                                  
end;

procedure TfrmScoutViewer.mnuRotateFlipVerticalClick(Sender: TObject);
begin
  magViewerRadTB21.FlipVertical();
end;

procedure TfrmScoutViewer.mnuRotateMinus90Click(Sender: TObject);
begin
  magViewerRadTB21.Rotate270();
end;

procedure TfrmScoutViewer.mnuScoutColorBlueClick(Sender: TObject);
begin
  if assigned(FScoutColorChange) then
    FScoutColorChange(self, clBlue);
end;

procedure TfrmScoutViewer.mnuScoutColorGreenClick(Sender: TObject);
begin
  if assigned(FScoutColorChange) then
    FScoutColorChange(self, clGreen);
end;

procedure TfrmScoutViewer.mnuScoutColorRedClick(Sender: TObject);
begin
  if assigned(FScoutColorChange) then
    FScoutColorChange(self, clRed);
end;

procedure TfrmScoutViewer.mnuScoutColorYellowClick(Sender: TObject);
begin
  if assigned(FScoutColorChange) then
    FScoutColorChange(self, clYellow);
end;

procedure TfrmScoutViewer.mnuScoutRemoveImageClick(Sender: TObject);
var
  vGear : TMag4VGear;
  IObj : TImageData;
  i : integer;
begin
  if FScoutImages.Count <= 1 then
  begin
    MagAppMsg('', 'User removing only image in scout window, closing scout window', magmsgINFO);
    self.Close();
    exit;
  end;

  vGear := Mag4StackViewer1.GetCurrentImage();
  if (vGear = nil) or (vGear.PI_ptrData = nil) then
    exit;

  // need to loop through the images to find the right one to remove since
  // the pointers don't match
  IObj := nil;
  for i := 0 to FScoutImages.Count - 1 do
  begin
    IObj := FScoutImages[i];
    if IObj.IsSame(vGear.PI_ptrData) then
      break
    else
      IObj := nil;
  end;

  if IObj <> nil then
    FScoutImages.Remove(IObj);

  IObj := nil;
  vGear := nil;

  // remove the current image from the list
  Mag4StackViewer1.RemoveFromList();
  Mag4StackViewer1.ReAlignImages();

  {
  vGear := Mag4StackViewer1.GetCurrentImage();
  if (vGear = nil) or (vGear.PI_ptrData = nil) then
    exit;
  FScoutImages.Remove(vGear.PI_ptrData);
  IObj := FScoutImages[0];

  Mag4StackViewer1.OpenStudy(IObj, FScoutImages,
    IObj.ExpandedDescription(false), FScoutImages.Count, true);

  IObj := nil;
  vGear := nil;
  }
end;

procedure TfrmScoutViewer.mnuViewActivewindowsClick(Sender: TObject);
begin
  SwitchToForm();
end;

procedure TfrmScoutViewer.mnuViewGoToMainWindowClick(Sender: TObject);
begin
  Application.MainForm.SetFocus();
end;

procedure TfrmScoutViewer.mnuViewInfoDICOMHeaderClick(Sender: TObject);
begin
  Mag4StackViewer1.DisplayDICOMHeader();
end;

procedure TfrmScoutViewer.mnuViewInfoImageInfoClick(Sender: TObject);
Var
  VGear: TMag4VGear;
  FrmRadImageInfo: TfrmRadImageInfo;
Begin
  VGear := Mag4StackViewer1.GetCurrentImage();
  If VGear = Nil Then Exit;
  FrmRadImageInfo := TfrmRadImageInfo.Create(Self);
  FrmRadImageInfo.Execute(VGear, FForDICOMViewer);
  FreeAndNil(FrmRadImageInfo);

end;

procedure TfrmScoutViewer.mnuViewInfoInformationAdvancedClick(Sender: TObject);
Var
  VGear: TMag4VGear;
Begin
  VGear := Mag4StackViewer1.GetCurrentImage();
  If VGear = Nil Then Exit;
  OpenImageInfoSys(VGear.PI_ptrData);

end;

procedure TfrmScoutViewer.mnuViewInfoRadiologyImageInfoClick(Sender: TObject);
Var
  VGear: TMag4VGear;
  FrmRadiologyImageInfo: TfrmRadiologyImageInfo;
Begin
  VGear := Mag4StackViewer1.GetCurrentImage;
  If VGear = Nil Then Exit;
  FrmRadiologyImageInfo := TfrmRadiologyImageInfo.Create(Self);
  FrmRadiologyImageInfo.Execute(VGear);
  FreeAndNil(FrmRadiologyImageInfo);

end;

procedure TfrmScoutViewer.mnuViewPanWindowClick(Sender: TObject);
begin
  magViewerRadTB21.PanWindow();
end;

procedure TfrmScoutViewer.FormClose(Sender: TObject; var Action: TCloseAction);
begin
  magViewerRadTB21.DisablePanWindow();
  SaveFormPosition(self);
  ClearScoutImages();
end;

procedure TfrmScoutViewer.FormCreate(Sender: TObject);
begin
  magViewerRadTB21.MagViewer := Mag4StackViewer1;
  Mag4StackViewer1.OnStackViewerClick := Mag4StackViewer1ClickEvent;
  magViewerRadTB21.AddViewerToToolbar(Mag4StackViewer1);
  Mag4StackViewer1.ShowSeriesDropDown := false;
  Mag4StackViewer1.OnImageMouseUp := receiveImageMouseUpEvent;
  FScoutImageMouseUp := nil;
  GetFormPosition(self);
  magviewerradtb21.SetCopyImageVisible(false);
  magviewerradtb21.SetPrintImageVisible(false);
  magViewerRadTB21.SetApplyToAllVisible(false);
  magViewerRadTB21.setRGBVisible(false);
  Mag4StackViewer1.SetShowPixelValues(true);
  Mag4StackViewer1.ShowScrollStartStop := false;
  Mag4StackViewer1.OnImageChanged := Mag4StackViewerImageChanged;
  Mag4StackViewer1.OnPanWindowClose := PanWindowCloseEvent;
  FPanWindowHolder := TMagPanWindowHolder.Create;
  Mag4StackViewer1.SetPanWindowHolder(FPanWindowHolder);
end;

procedure TfrmScoutViewer.FormDestroy(Sender: TObject);
var
  panWindow : TObject;
begin
  if FPanWindowHolder.PanWindow <> nil then
  begin
    panWindow := GetImplementingObject(FPanWindowHolder.PanWindow);
    panWindow.Free;
    FPanWindowHolder.PanWindow := nil;
  end;
end;

procedure TfrmScoutViewer.receiveImageMouseUpEvent(Sender: Tobject; Button: TMouseButton; Shift: TShiftState; x, y: Integer);
begin
  if assigned(FScoutImageMouseUp) and (mnuTestFindAssociatedImageatPoint.Checked) then
  begin
    FScoutImageMouseUp(Self, button, shift, x, y, FRootImg,
      Mag4StackViewer1.GetCurrentImage().PI_ptrData);
  end;
end;

procedure TfrmScoutViewer.SelectedImageChanged(SelectedImage : TImageData);
var
  study : TMagRadiologyStudy;
  selectedRadiologyImage, scoutRadiologyImage : TMagRadiologyImage;
  scoutLine : TMagScoutLine;
  currentScoutImage : TImageData;
begin
  // find the study associated with the images in the scout window
  study := uMagRadHeaderLoader.GetStudyHolder().getStudy(FRootImg);
  // find the radiology image objects in the study for the selected image and the scout image
  // they should be in the same study or these two are not really associated and we can stop

  currentScoutImage := Mag4StackViewer1.GetCurrentImage().PI_ptrData;
  // don't want to draw if they are the same image
  if not selectedImage.IsSame(currentScoutImage) then
  begin
    selectedRadiologyImage := study.FindRadiologyImage(selectedImage);
    scoutRadiologyImage := study.FindRadiologyImage(currentScoutImage);
    if (selectedRadiologyImage <> nil) and (scoutRadiologyImage <> nil) then
    begin
      try
        // this might throw an exception if the images don't correspond
        scoutLine := uMagRadHeaderLoader.GetXRefLine(selectedRadiologyImage,
          scoutRadiologyImage, study);
        if scoutLine <> nil then
        begin
          Mag4StackViewer1.GetCurrentImage().DrawScoutLine(scoutLine);
        end
        else
        begin
          Mag4StackViewer1.GetCurrentImage().HideScoutLine();
        end;
      except
        on E : Exception do
        begin
          MagAppMsg('', 'Exception calculating scout line, ' + e.Message, MAGMSGDebug);
          Mag4StackViewer1.GetCurrentImage().HideScoutLine();
        end;
      end;
    end
    else
    begin
      Mag4StackViewer1.GetCurrentImage().HideScoutLine();
    end;
  end
  else
  begin
    Mag4StackViewer1.GetCurrentImage().HideScoutLine();
  end;
end;

procedure TfrmScoutViewer.ClearScoutImages();
begin
  Mag4StackViewer1.GetCurrentImage().HideScoutLine();
  Mag4StackViewer1.ClearViewer();
  FRootImg := nil; // don't free since referenced elsewhere
  if FScoutImages <> nil then
    FreeAndNil(FScoutImages);
  FCurrentPatient := nil;
end;

Procedure TfrmScoutViewer.SetUtilsDB(UtilsDb: TMagUtilsDB);
begin
  Mag4StackViewer1.MagUtilsDB := UtilsDb;

end;

Procedure TfrmScoutViewer.SetWindowLevel(Win, Lev: String);
Var
  Window, Level: Integer;
Begin
  Try
    Window := Strtoint(Win);
    Level := Strtoint(Lev);
    Mag4StackViewer1.WinLevValue(Window, Level);
    magviewerradtb21.UpdateImageState;
  Except
    On e: Exception Do
    Begin
      //LogMsg('s',e.Message, magmsgError);
      MagAppMsg('s', e.Message, magmsgError); {JK 10/6/2009 - Maggmsgu refactoring}
      // do nothing
    End;
  End;
End;

procedure TfrmScoutViewer.SetCTPresets(CTPresets : TStrings);
var
  CustomUsed : boolean;
begin
  FCTPresets := CTPresets;

  CustomUsed := False;
  If FCTPresets[6] = '' Then
  Begin
    MnuCTCustom1.Visible := False;
  End
  Else
  Begin
    CustomUsed := True;
    MnuCTCustom1.caption := MagPiece(FCTPresets[6], '|', 1);
    MnuCTCustom1.Visible := True;
  End;
  If FCTPresets[7] = '' Then
  Begin
    MnuCTCustom2.Visible := False;
  End
  Else
  Begin
    CustomUsed := True;
    MnuCTCustom2.caption := MagPiece(FCTPresets[7], '|', 1);
    MnuCTCustom2.Visible := True;
  End;
  If FCTPresets[8] = '' Then
  Begin
    MnuCTCustom3.Visible := False;
  End
  Else
  Begin
    CustomUsed := True;
    MnuCTCustom3.caption := MagPiece(FCTPresets[8], '|', 1);
    MnuCTCustom3.Visible := True;
  End;

  MnuCTBar1.Visible := CustomUsed;
end;

function TfrmScoutViewer.IsStudyLoaded() : boolean;
begin
  result := (FScoutImages <> nil);
end;

procedure TfrmScoutViewer.HideScoutLine();
var
  vGear : TMag4VGear;
begin
  vGear := Mag4StackViewer1.GetCurrentImage();
  if vGear <> nil then
    vGear.HideScoutLine();
  vGear := nil;
end;

Procedure TfrmScoutViewer.SetScoutLineColor(Color : TColor);
begin
  FScoutLineColor := Color;
  Mag4StackViewer1.SetScoutLineColor(FScoutLineColor);
  
  mnuScoutColorRed.Checked := false;
  mnuScoutColorBlue.Checked := false;
  mnuScoutColorGreen.Checked := false;
  mnuScoutColorYellow.Checked := false;

  case color of
    clRed : mnuScoutColorRed.Checked := true;
    clBlue : mnuScoutColorBlue.Checked := true;
    clGreen : mnuScoutColorGreen.Checked := true;
    clYellow : mnuScoutColorYellow.Checked := true;
  end;
end;

{ Event occurs when an image in the stack viewer changes, meaning a new scout image was selected.
  This will fire an event to the rad viewer which will tell the scout window to
  show scout lines based on the current rad viewer image to the new scout viewer
  image
}
Procedure TfrmScoutViewer.Mag4StackViewerImageChanged(Sender: Tobject; MagImage: TMag4VGear);
begin
  if assigned(OnScoutViewerImageChange) and (not FLoadingImage) then
    OnScoutViewerImageChange(self);
end;

Procedure TfrmScoutViewer.ShowTestMenu(Value : Boolean);
begin
  mnuTest.Visible := Value;
end;

Procedure TfrmScoutViewer.PanWindowCloseEvent(Sender: Tobject);
Begin
  magViewerRadTB21.DisablePanWindow();
End;

end.
