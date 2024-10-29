{
  Package: MAG - VistA Imaging
  WARNING: Per VHA Directive 2004-038, this routine should not be modified.
  Date Created: December, 2006
  Site Name:  Washington OI Field Office, Silver Spring, MD
  Developer:  Julian Werfel
  Description:
    Viewer for displaying images in a study in a stack mode.

        ;; +--------------------------------------------------------------------+
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
        ;; +--------------------------------------------------------------------+
}
Unit cMagStackViewer;

Interface

Uses
  Buttons,
  Classes,
  cMag4Vgear,
//  cMagLogManager,  {JK 10/5/2009 - Maggmsgu refactoring - deprecated unit}
  Maggmsgu,
  cMagUtilsDB,
  ComCtrls,
  Controls,
  ExtCtrls,
  FmagImage,
  Forms,
  IMagViewer,
  Magremoteinterface,
  Menus,
  Stdctrls,
  UMagClasses,
  UMagClassesAnnot,
  UMagDefinitions,
  Windows,
  ImgList
  ;

//Uses Vetted 20090929:ToolWin, ImgList, Graphics, Variants, Messages, cMagImageUtility, cMagImageAccessLogManager, MagImageManager, Dialogs, SysUtils

Type
  TMagStackViewMode = (MagStackView11, MagStackView12, MagStackViewScout);

Type
  TMag4StackViewer = Class;

  TMagPageNextStackViewerEvent = Procedure(Sender: Tobject) Of Object;
  TMagPagePreviousStackViewerEvent = Procedure(Sender: Tobject) Of Object;
  TMagPageFirstStackViewerEvent = Procedure(Sender: Tobject) Of Object;
  TMagPageLastStackViewerEvent = Procedure(Sender: Tobject) Of Object;
  TMagImageChangedEvent = Procedure(Sender: Tobject; MagImage: TMag4VGear) Of Object;

  TMagStackViewerClickEvent = Procedure(Sender: Tobject; StackViewer: TMag4StackViewer; MagImage: TMag4VGear) Of Object;

  TMagStackImageDoubleClickEvent = Procedure(Sender: Tobject; StackViewer: TMag4StackViewer; MagImage: TMag4VGear) Of Object;

  TMag4StackViewer = Class(TFrame, IMag4Viewer, IMagRemoteinterface)
    Mag4Vgear1: TMag4VGear;
    ImageList1: TImageList;
    PnlTop: Tpanel;
    PopupMenu1: TPopupMenu;
    MnuScrollStartPosition: TMenuItem;
    MnuScrollEndPosition: TMenuItem;
    MnuScrollBar1: TMenuItem;
    MnuScrollClear: TMenuItem;
    TmrScroll: TTimer;
    MnuScrollBar2: TMenuItem;
    MnuScrollStart: TMenuItem;
    MnuScrollStop: TMenuItem;
    TopPanel: Tpanel;
    cboSeries: TComboBox;
    ImgStudyStatus: TImage;
    PnlStudyScroll: Tpanel;
    TbStudy: TTrackBar;
    TbStudySpeed: TTrackBar;
    btnScrollStartStop: TBitBtn;
    btnPageFirst: TBitBtn;
    btnPagePrev: TBitBtn;
    btnPageNext: TBitBtn;
    btnPageLast: TBitBtn;
    tmrScrollDelay: TTimer;
    Procedure Mag4Vgear1ImageClick(Sender: Tobject;
      Gearclicked: TMag4VGear);
    Procedure Mag4Vgear1ImageMouseDown(Sender: Tobject;
      Button: TMouseButton; Shift: TShiftState; x, y: Integer);
    Procedure Mag4Vgear1ImageDoubleClickEvent(Sender: Tobject);
    Procedure TbStudyChange(Sender: Tobject);
    Procedure MnuScrollStartPositionClick(Sender: Tobject);
    Procedure MnuScrollEndPositionClick(Sender: Tobject);
    Procedure MnuScrollClearClick(Sender: Tobject);
    Procedure TmrScrollTimer(Sender: Tobject);
    Procedure MnuScrollStartClick(Sender: Tobject);
    Procedure MnuScrollStopClick(Sender: Tobject);
    Procedure cboSeriesChange(Sender: Tobject);
    Procedure TbStudySpeedChange(Sender: Tobject);
    Procedure btnScrollStartStopClick(Sender: Tobject);
    Procedure btnPageFirstClick(Sender: Tobject);
    Procedure btnPagePrevClick(Sender: Tobject);
    Procedure btnPageNextClick(Sender: Tobject);
    Procedure btnPageLastClick(Sender: Tobject);
    Procedure tmrScrollDelayTimer(Sender: Tobject);
  Private
    FCurrentStackViewMode: TMagStackViewMode;
    FCurrentGearControl: TMag4VGear;
    FImageList: Tlist;
    FCurrentImageIndex: Integer;
    FCurrentFilename: String;
    FCurrentPatientSSN: String; // the SSN of the current patient
    FCurrentPatientICN: String; // the ICN of the current patient from VistA
    FMagUtilsDB: TMagUtilsDB;
    FPageSameSettings: Boolean; // determines if when paging through images, the previous image win/lev should be used
    // store the current window/level value
    Fstate: TMagImageState;
    FApplyGivenWindowSettings: Boolean; // determines if the Fwindow and FLevel values will be set and should be used in loading image
    FPanWindow: Boolean;
    FStudyDesc: String;

    { Events }
    FStackViewerClickEvent: TMagStackViewerClickEvent;
    //FOnLogEvent : TMagLogEvent;  {JK 10/5/2009 - Maggmsgu refactoring}
    FStackImageDoubleClickEvent: TMagStackImageDoubleClickEvent;
    FImageChangedEvent: TMagImageChangedEvent;

    FPageNextStackViewerEvent: TMagPageNextStackViewerEvent;
    FPagePreviousStackViewerEvent: TMagPagePreviousStackViewerEvent;
    FPageFirstStackViewerEvent: TMagPageFirstStackViewerEvent;
    FPageLastStackViewerEvent: TMagPageLastStackViewerEvent;

    FPatientIDMismatchEvent: TMagViewerPatientIDMismatchEvent;

    FApplytoall: Boolean;

    // determines if the study change trackbar should move when the change even occurs
    FStudyChangeEventEnabled: Boolean;

    // determines if Rad Viewer shows pixel values in the hint (only used in Rad Viewer)
    FShowPixelValues: Boolean;

    // determines if the default win/level should be from header/txt file or based on gear component
    FHistogramWindowLevel: Boolean;

    FShowLabels: Boolean;

    // recieves image zoom scroll event updates
    FImageScroll: TImageScrollEvent;

    FImageWinLevChange: TImageWinLevChangeEvent;
    FImageBriConChange: TImageBriConChangeEvent;
    FImageToolChange: TImageToolChangeEvent;
    FImageZoomChange: TImageZoomChangeEvent;

    // set the current tool applied (hand pan, mouse zoom, annotation, ruler, etc)
    FCurrentTool: TMagImageMouse;

    // determines if at least 1 image has been loaded into the stack.
    // The 1st image in the stack should not try to apply the previous images win/lev, it should auto win/lev
    FFirstImageLoaded: Boolean;

    FAnnotationStyle: TMagAnnotationStyle;

    FMagAnnotationStyleChangeEvent: TMagAnnotationStyleChangeEvent;
    FPanWindowClose: TMagPanWindowCloseEvent;

    FMouseZoomShape: TMagMouseZoomShape;

    Procedure SetCurrentStackViewMode(Value: TMagStackViewMode);
    Function IsStudyAlreadyLoaded(FirstImageIEN: String; Server: String; Port: Integer; StudyImgCount: Integer): Boolean;
    Procedure LoadImage(ImgIndex: Integer; BigFile: Boolean = False;
      SetIsSelected: Boolean = True);
   // procedure LogMsg(MsgType : String; Msg : String; Priority : TMagLogPriority = MagLogINFO);  {JK 10/6/2009 - Maggmsgu refactoring - remove old method}

    Procedure OnImageMouseScrollDown(Sender: Tobject; Shift: TShiftState; MousePos: TPoint; Var Handled: Boolean);
    Procedure OnImageMouseScrollUp(Sender: Tobject; Shift: TShiftState; MousePos: TPoint; Var Handled: Boolean);
    Procedure CopyImagesToFImageList(Images: Tlist);
    Procedure AddImagesToFImageList(Images: Tlist);
    Procedure SetApplyGivenWindowSettings(Value: Boolean);
    Procedure SetPageSameSettings(Value: Boolean);
    //procedure setLogEvent(Value : TMagLogEvent);  {JK 10/6/2009 - Maggmsgu refactoring - remove old method}
    Procedure CheckStudyCached(FullFileName: String; StudyCount: Integer);

    Procedure RIVRecieveUpdate_(action: String; Value: String); // recieve updates from everyone
    // checks to see if next,prev,first,last buttons are enabled based on current image selected
    Procedure CheckButtons();

    Procedure CheckStartStopButton();
    Procedure ImageZoomScroll(Sender: Tobject; VertScrollPos: Integer; HorizScrollPos: Integer);
    Procedure SetImageScroll(Value: TImageScrollEvent);

    Procedure ImageWinLevChange(Sender: Tobject; WindowValue: Integer; LevelValue: Integer);
    Procedure ImageBriConChange(Sender: Tobject; BrightnessValue: Integer; ContrastValue: Integer);
    Procedure ImageToolChange(Sender: Tobject; Tool: TMagImageMouse);
    Procedure ImageZoomChange(Sender: Tobject; ZoomValue: Integer);
    Procedure ImageUpdateImageState(Sender: Tobject);

    // looks at the current image for updating series information to update the series combo box
    Procedure ExamineSeries();

    Procedure SetAnnotationStyleChangeEvent(Value: TMagAnnotationStyleChangeEvent);
    Procedure AnnotationStyleChangeEvent(Sender: Tobject; AnnotationStyle: TMagAnnotationStyle);

    Procedure SetPanWindowClose(Value: TMagPanWindowCloseEvent);
    Procedure PanWindowCloseEvent(Sender: Tobject);
  Public
    Constructor Create(AOwner: TComponent); Override;
    Destructor Destroy; Override;

    Procedure OpenStudy(RootImg: TImageData; ImgList: Tlist; Studydesc: String; ImgIndex: Integer = -1; AppendImages: Boolean = False);
    Procedure UnSelectAll();

    Function GetStudyList(): Tlist;
    Function GetStudyListCount(): Integer;
    Function GetCurrentImage(): TMag4VGear;
    Function GetCurrentImageIndex(): Integer;

    // inherited from iMag4Viewer
    Procedure AutoWinLevel();
    Procedure MousePan();
    Procedure WinLevValue(WinValue, LevelValue: Integer);
    Procedure SetApplyToAll(Value: Boolean);
    Function GetApplyToAll(): Boolean;
    Procedure Fit1to1();
    Procedure FitToHeight();
    Procedure FitToWindow();
    Procedure Inverse();
    Procedure FitToWidth();
    Procedure Rotate(Deg: Integer);
    Procedure MouseMagnify();
    Procedure MouseZoomRect();
    Function GetPanWindow(): Boolean;
    Procedure SetPanWindow(Value: Boolean);
    Procedure TileAll();
    Procedure FlipVert();
    Procedure FlipHoriz();
    Function GetViewerStyle(): TMagViewerStyles;
    Procedure SetViewerStyle(Const Value: TMagViewerStyles);
    Procedure EditViewerSettings();
    Procedure RemoveFromList();
    Procedure ClearViewer();
    Procedure ToggleSelected();
    Procedure ZoomValue(Zoom: Integer);
    Procedure BrightnessValue(Value: Integer);
    Procedure ContrastValue(Value: Integer);
    Procedure ImagePrint();
    Procedure ImageCopy();
    Procedure ImageReport();
    Function GetImagePage(): Integer;
    Procedure SetImagePage(Const Value: Integer);
    Procedure SetImagePageUseApplyToAll(Const Value: Integer);
    Procedure PageFirstImage();
    Procedure PagePrevImage();
    Procedure PageNextImage();
    Procedure PageLastImage();
    Procedure ResetImages(ApplyToAll: Boolean = False); // resets the image (all if apply to all selected)
    Procedure SetMaximizeImage(Value: Boolean);
    Function GetMaximizeImage(): Boolean;
    Procedure SetRowColCount(r, c: Integer; ImageToDisplayIndex: Integer = -1);
    Procedure SetLockSize(Value: Boolean);
    Function GetLockSize(): Boolean;
    Function GetClearBeforeAdd(): Boolean;
    Procedure SetClearBeforeAdd(Value: Boolean);
    Procedure MouseReSet();
    Procedure PageFirstViewer(SetSelected: Boolean = True);
    Procedure PageNextViewer(SetSelected: Boolean = True);
    Procedure PagePrevViewer(SetSelected: Boolean = True);
    Procedure PageLastViewer(SetSelected: Boolean = True);
    Procedure SetMaxCount(Value: Integer);
    Function GetMaxCount(): Integer;
    Procedure ReAlignImages(Ignmax: Boolean = False; Ignlocksize: Boolean = False; ImageToDisplayIndex: Integer = -1);
    Procedure ReFreshImages();
    Procedure ViewFullResImage();
    Procedure SetShowPixelValues(Value: Boolean);
    Function GetShowPixelValues(): Boolean;
    Function GetHistogramWindowLevel(): Boolean;
    Procedure SetHistogramWindowLevel(Value: Boolean);
    Function GetShowLabels(): Boolean;
    Procedure SetShowLabels(Value: Boolean);
    Procedure ApplyViewerState(Viewer: IMag4Viewer); //jw 11/16/07
    Procedure SetSelected();
    Procedure SetDefaultState(State: TMagImageState);
    Procedure ApplyImageState(State: TMagImageState; ApplyAll: Boolean = False);

    Procedure StopScrolling();
    Procedure ApplyImageZoomScroll(Sender: Tobject; VertScrollPos: Integer; HorizScrollPos: Integer);

    Function GetCurrentTool(): TMagImageMouse;
    Procedure SetCurrentTool(Value: TMagImageMouse);

    Procedure BrightnessContrastValue(Bright, Contrast: Integer);

    { These functions are used with the DICOM Viewer }
    Procedure AddImage(IObj: TImageData);
    Procedure RemoveImageIndex(Index: Integer);
    Procedure DisplayDICOMHeader();

    Property CurrentPatientSSN: String Read FCurrentPatientSSN Write FCurrentPatientSSN;
    Property CurrentPatientICN: String Read FCurrentPatientICN Write FCurrentPatientICN;

    Procedure Annotations();
    Procedure Measurements();
    Procedure Protractor();
    Procedure AnnotationPointer();
    Procedure SetAnnotationStyle(AnnotationStyle: TMagAnnotationStyle);
    Procedure SetPanWindowWithActivateOption(Value: Boolean; Activate: Boolean);

    {  JMW 8/11/08
    Events for 508 compliance (from FMagImage)}
    Procedure ScrollCornerTL();
    Procedure ScrollCornerTR();
    Procedure ScrollCornerBL();
    Procedure ScrollCornerBR();
    Procedure ScrollLeft();
    Procedure ScrollRight();
    Procedure ScrollUp();
    Procedure ScrollDown();

    Procedure StartStackCine();
    Procedure StopStackCine();
    Procedure SpeedUpStackCine();
    Procedure SlowDownStackCine();
    Procedure SetStackCineStartPosition();
    Procedure SetStackCineStopPosition();
    Procedure ClearStackCinePosition();

    // JMW 4/6/09 P93 - add options for changing mouse zoom shape
    Procedure SetMouseZoomShape(Value: TMagMouseZoomShape);
    Function getMouseZoomShape(): TMagMouseZoomShape;
  Published
    //property OnLogEvent : TMagLogEvent read FOnLogEvent write setLogEvent;  {JK 10/5/2009 - Maggmsgu refactoring}

    Property CurrentStackViewMode: TMagStackViewMode Read FCurrentStackViewMode Write SetCurrentStackViewMode;
    Property OnStackViewerClick: TMagStackViewerClickEvent Read FStackViewerClickEvent Write FStackViewerClickEvent;
    Property OnStackImaegDoubleClick: TMagStackImageDoubleClickEvent Read FStackImageDoubleClickEvent Write FStackImageDoubleClickEvent;
    Property OnImageChanged: TMagImageChangedEvent Read FImageChangedEvent Write FImageChangedEvent;

    Property OnPageNextStackViewerClick: TMagPageNextStackViewerEvent Read FPageNextStackViewerEvent Write FPageNextStackViewerEvent;
    Property OnPagePreviousStackViewerClick: TMagPagePreviousStackViewerEvent Read FPagePreviousStackViewerEvent Write FPagePreviousStackViewerEvent;
    Property OnPageFirstStackViewerClick: TMagPageFirstStackViewerEvent Read FPageFirstStackViewerEvent Write FPageFirstStackViewerEvent;
    Property OnPageLastStackViewerClick: TMagPageLastStackViewerEvent Read FPageLastStackViewerEvent Write FPageLastStackViewerEvent;

    Property MagUtilsDB: TMagUtilsDB Read FMagUtilsDB Write FMagUtilsDB;
    Property PageSameSettings: Boolean Read FPageSameSettings Write SetPageSameSettings;
    Property ApplyGivenWindowSettings: Boolean Read FApplyGivenWindowSettings Write SetApplyGivenWindowSettings;

    Property OnImageZoomScroll: TImageScrollEvent Read FImageScroll Write SetImageScroll;
    Property OnImageWinLevChange: TImageWinLevChangeEvent Read FImageWinLevChange Write FImageWinLevChange;
    Property OnImageBriConChange: TImageBriConChangeEvent Read FImageBriConChange Write FImageBriConChange;
    Property OnImageToolChange: TImageToolChangeEvent Read FImageToolChange Write FImageToolChange;
    Property OnImageZoomChange: TImageZoomChangeEvent Read FImageZoomChange Write FImageZoomChange;

    Property OnMagAnnotationStyleChangeEvent: TMagAnnotationStyleChangeEvent Read FMagAnnotationStyleChangeEvent Write SetAnnotationStyleChangeEvent;

    Property OnPatientIDMismatchEvent: TMagViewerPatientIDMismatchEvent Read FPatientIDMismatchEvent Write FPatientIDMismatchEvent;

    Property OnPanWindowClose: TMagPanWindowCloseEvent Read FPanWindowClose Write FPanWindowClose;
  End;

Procedure Register;

Implementation
Uses
  cMagImageAccessLogManager,
  cMagImageUtility,
  Dialogs,
  MagImageManager,
  SysUtils
  ;

{$R *.dfm}

Procedure Register;
Begin
  RegisterComponents('Imaging', [TMag4StackViewer]);
End;

Constructor TMag4StackViewer.Create(AOwner: TComponent);
Begin
  Inherited;
  Self.Name := ''; // stupid thing so Delphi won't die
  FCurrentStackViewMode := MagStackView11;
  FCurrentGearControl := Mag4Vgear1;
  FImageList := Tlist.Create();
  FCurrentImageIndex := -1;
  FMouseZoomShape := MagMouseZoomShapeCircle;

  Mag4Vgear1.OnImageMouseScrollUpEvent := OnImageMouseScrollUp;
  Mag4Vgear1.OnImageMouseScrollDownEvent := OnImageMouseScrollDown;
  Mag4Vgear1.OnImageZoomScroll := ImageZoomScroll;
  Mag4Vgear1.OnImageWinLevChange := ImageWinLevChange;
  Mag4Vgear1.OnImageBriConChange := ImageBriConChange;
  Mag4Vgear1.OnImageToolChange := ImageToolChange;
  Mag4Vgear1.OnImageZoomChange := ImageZoomChange;
  Mag4Vgear1.OnImageUpdateImageState := ImageUpdateImageState;
  Mag4Vgear1.OnPanWindowClose := PanWindowCloseEvent;
  Mag4Vgear1.setMouseZoomShape(FMouseZoomShape);
  PnlTop.caption := '';
  FPageSameSettings := False;
  FPanWindow := False;
  FApplytoall := False;
  cboSeries.Align := alLeft;
  cboSeries.Visible := False;
  RIVAttachListener(Self);
  CheckButtons();
  FShowPixelValues := False;
  FHistogramWindowLevel := True;
  FShowLabels := True;
  btnScrollStartStop.Align := alBottom;
  CheckStartStopButton();
  btnPageFirst.Align := altop;
  btnPagePrev.Align := altop;
  btnPageNext.Align := altop;
  btnPageLast.Align := altop;
  FStudyChangeEventEnabled := True;
  FFirstImageLoaded := False;

End;

Destructor TMag4StackViewer.Destroy;
Begin
  If FImageList <> Nil Then
    FreeAndNil(FImageList);
  If Fstate <> Nil Then
    FreeAndNil(Fstate);

  Inherited;
End;

Procedure TMag4StackViewer.SetCurrentStackViewMode(Value: TMagStackViewMode);
Begin
  FCurrentStackViewMode := Value;
  {
  case FCurrentStackViewMode of
  MagStackView11:
    begin
      Mag4Vgear2.Visible := false;
    end;
  MagStackView12:
    begin
      Mag4Vgear2.Visible := true;
    end;
  end;
  }
  // make second one visible and stuff (based on mode)

End;

{JK 10/6/2009 - Maggmsgu refactoring - remove old method}
//procedure TMag4StackViewer.LogMsg(MsgType : String; Msg : String; Priority : TMagLogPriority = MagLogINFO);
//begin
//  if assigned(OnLogEvent) then
//    OnLogEvent(self, MsgType, Msg, Priority);
//end;

{JK 10/5/2009 - Maggmsgu refactoring - remove old method}
//procedure TMag4StackViewer.setLogEvent(Value : TMagLogEvent);
//begin
//  FOnLogEvent := Value;
//  Mag4Vgear1.OnLogEvent := FOnLogEvent;
////  Mag4Vgear2.OnLogEvent := FOnLogEvent;
//end;

Procedure TMag4StackViewer.Mag4Vgear1ImageClick(Sender: Tobject;
  Gearclicked: TMag4VGear);
Begin
  FCurrentGearControl := Mag4Vgear1;
  Mag4Vgear1.Selected := True;
//  Mag4VGear2.Selected := false;
  If Assigned(OnStackViewerClick) Then
    OnStackViewerClick(Self, Self, Mag4Vgear1);
  If FPanWindow Then SetPanWindow(FPanWindow);
End;

Procedure TMag4StackViewer.OpenStudy(RootImg: TImageData; ImgList: Tlist; Studydesc: String; ImgIndex: Integer = -1; AppendImages: Boolean = False);
Begin
  TmrScroll.Enabled := False;
  tmrScrollDelay.Enabled := False;
  If (Not AppendImages) And (IsStudyAlreadyLoaded(RootImg.Mag0, RootImg.ServerName, RootImg.ServerPort, ImgList.Count)) Then
  Begin
    // show the specified image
    LoadImage(ImgIndex);

  End
  Else
  Begin
    FStudyDesc := Studydesc;
    FCurrentImageIndex := -1;
    If AppendImages Then
    Begin
      AddImagesToFImageList(ImgList);
    End
    Else
    Begin
      FCurrentGearControl.ClearImage();
      PnlTop.caption := '';
      CopyImagesToFImageList(ImgList);
      CheckStudyCached(RootImg.FFile, ImgList.Count);
      // i think this will solve the problem...
//      Fstate := nil;

    End;
    If ImgList.Count = 0 Then
    Begin
      PnlTop.caption := '';
      TbStudy.Max := 0;
    End
    Else
    Begin
      PnlTop.caption := FStudyDesc + '  - ' + Inttostr(FImageList.Count) + '  Images';
      FStudyChangeEventEnabled := False;
      TbStudy.Max := FImageList.Count - 1;
      FStudyChangeEventEnabled := True;
    End;
    // JMW 4/25/08 P72. By setting FFirstImageLoaded to false, the next image loaded
    // in the study will not use the previous images win/lev values
    FFirstImageLoaded := False;
    LoadImage(ImgIndex);
  End;
End;

Procedure TMag4StackViewer.CheckStudyCached(FullFileName: String; StudyCount: Integer);
Begin
  If MagImageManager1.IsStudyCached(FullFileName, StudyCount) Then
  Begin
    //ImageList1.GetIcon(5, imgStudyStatus.Picture.Icon);
    ImageList1.GetIcon(9, ImgStudyStatus.Picture.Icon);
    ImgStudyStatus.Visible := True;
  End
  Else
  Begin
    ImgStudyStatus.Visible := False;
  End;
End;

Procedure TMag4StackViewer.AddImagesToFImageList(Images: Tlist);
Var
  i: Integer;
  NewImg, IObj: TImageData;
Begin
  If FImageList = Nil Then
    FImageList := Tlist.Create();
  For i := 0 To Images.Count - 1 Do
  Begin
    IObj := Images.Items[i];
    NewImg := TImageData.Create();
    NewImg.MagAssign(IObj);
    FImageList.Add(NewImg);
  End;

End;

Procedure TMag4StackViewer.CopyImagesToFImageList(Images: Tlist);
Var
  i: Integer;
  NewImg, IObj: TImageData;
  PrevSeriesObj, SeriesObj: TMagSeriesObject;
  PrevSeries: String;
  SeriesImgCount: Integer;
Begin
  TmrScroll.Enabled := False;
  tmrScrollDelay.Enabled := False;
  cboSeries.Clear();
  cboSeries.Hint := '';
  PrevSeries := '';
  SeriesImgCount := 0;
  cboSeries.AddItem('Series', Nil);
  If FImageList = Nil Then
    FImageList := Tlist.Create()
  Else
    FImageList.Clear();
  For i := 0 To Images.Count - 1 Do
  Begin
    IObj := Images.Items[i];
    NewImg := TImageData.Create();
    NewImg.MagAssign(IObj);
    FImageList.Add(NewImg);
    If PrevSeries <> NewImg.DicomSequenceNumber Then
    Begin
      If PrevSeries <> '' Then
      Begin
        PrevSeriesObj := (cboSeries.Items.Objects[cboSeries.Items.Count - 1] As TMagSeriesObject);
        PrevSeriesObj.SeriesImgCount := SeriesImgCount;
        cboSeries.Items[cboSeries.Items.Count - 1] := PrevSeriesObj.SeriesName + '(' + Inttostr(SeriesImgCount) + ')';
        SeriesImgCount := 0;
      End;
      SeriesObj := TMagSeriesObject.Create();
      SeriesObj.SeriesName := NewImg.DicomSequenceNumber;
      SeriesObj.ImageIndex := i;
      cboSeries.AddItem(SeriesObj.SeriesName, SeriesObj);
      PrevSeries := NewImg.DicomSequenceNumber;
    End;
    SeriesImgCount := SeriesImgCount + 1;
  End;
  cboSeries.ItemIndex := 0;
  If cboSeries.Items.Count > 1 Then
  Begin
    cboSeries.Visible := True;
    PrevSeriesObj := (cboSeries.Items.Objects[cboSeries.Items.Count - 1] As TMagSeriesObject);
    PrevSeriesObj.SeriesImgCount := SeriesImgCount;
    cboSeries.Items[cboSeries.Items.Count - 1] := PrevSeriesObj.SeriesName + '(' + Inttostr(SeriesImgCount) + ')';
  End
  Else
    cboSeries.Visible := False;
End;

Procedure TMag4StackViewer.LoadImage(ImgIndex: Integer; BigFile: Boolean = False;
  SetIsSelected: Boolean = True);
Var
  IObj: TImageData;
  Oneimage, TxtFilename: String;
  ImgState: TMagImageState;
  ImgResult, TxtResult: TMagImageTransferResult;
  GetTxtFile: Boolean;
Begin
  Try
    tmrScrollDelay.Enabled := False;
    IObj := Nil;
    ImgResult := Nil;
    TxtResult := Nil;
    ImgState := Nil;

    If ImgIndex < 0 Then ImgIndex := 0;
    If ImgIndex >= FImageList.Count Then Exit;
    If (ImgIndex = FCurrentImageIndex) And (Not BigFile) Then // same image
    Begin
      If Fstate <> Nil Then
      Begin
        ApplyImageState(Fstate);
      End;
      Exit;
    End;

  // JMW 8/18/08 p72t26 - added (not BigFile):
  // only want to apply the previous image state if not doing a big file
  // don't want the win/lev from ref image for the big file
    If (FPageSameSettings) And (FFirstImageLoaded) And (Not BigFile) Then
    Begin
      Fstate := Mag4Vgear1.GetState;
    End;

    FCurrentImageIndex := ImgIndex;
    FStudyChangeEventEnabled := False;
    TbStudy.Position := FCurrentImageIndex;
    FStudyChangeEventEnabled := True;
    IObj := FImageList.Items[ImgIndex];
    Screen.Cursor := crHourGlass;
    If BigFile Then
    Begin
      ImgResult := MagImageManager1.GetFile(IObj.BigFile, IObj.PlaceCode,
        IObj.ImgType, False);
      If (ImgResult.FTransferStatus = IMAGE_UNAVAILABLE) Or
        (ImgResult.FTransferStatus = IMAGE_FAILED) Then
      Begin
        Screen.Cursor := crDefault;
        Showmessage('No Full Resolution Image Available.');
        Exit;
      End;
      Oneimage := ImgResult.FDestinationFilename;
    End
    Else
    Begin
      ImgResult := MagImageManager1.GetImageGuaranteed(IObj, MagImageTypeFull, False);
      Oneimage := ImgResult.FDestinationFilename;
      If (ImgResult.FImageQuality = DIAGNOSTIC_IMG) Then
        BigFile := True;
    End;
    FCurrentFilename := Oneimage;
    Mag4Vgear1.AutoRedraw := False;
    Mag4Vgear1.LoadTheImage(Oneimage, BigFile);
//  Mag4Vgear1.FitToWindow();
    Screen.Cursor := crDefault;
    Mag4Vgear1.ImageLoaded := True;
    Mag4Vgear1.PI_ptrData := IObj; // I think this is ok here
//  Mag4VGear1.ImageNumber := ImgIndex; // should this be +1 ? (I don't think so)
    Mag4Vgear1.ListIndex := ImgIndex; // should this be +1 ? (I don't think so)

    TxtFilename := '';
    GetTxtFile := False;

  // check to see if the original file is from a URL, if it is, then we won't try to get the txt file

  // JMW 5/14/08 P72 - for the time being, if the image is from the ViX, don't
  // get the TXT file - this will change when V2V is ready
  // JMW 2/29/08 P72 - if the place IEN is not 200, then get TXT file
    If IObj.PlaceIEN <> '200' Then
    Begin
      If GetImageUtility().DetermineStorageProtocol(IObj.FFile) = MagStorageUNC Then
      Begin
        TxtFilename := ChangeFileExt(IObj.FFile, '.txt');
        GetTxtFile := True;
      End
      Else
      Begin
        If Mag4Vgear1.ImageContainsDicomHeader Then
        Begin
      //LogMsg('s','Image is from ViX and contains DICOM header, not getting TXT file', MagLogInfo);
          MagLogger.LogMsg('s', 'Image is from ViX and contains DICOM header, not getting TXT file', MagLogINFO); {JK 10/6/2009 - Maggmsgu refactoring}
          GetTxtFile := False;
        End
        Else
        Begin
          TxtFilename := IObj.FFile;
          GetTxtFile := True;
        End;
      End;
      If GetTxtFile Then
      Begin
      //LogMsg('s','About to get text file for image [' + IObj.Mag0 + ']');
        MagLogger.LogMsg('s', 'About to get text file for image [' + IObj.Mag0 + ']'); {JK 10/6/2009 - Maggmsgu refactoring}
        TxtResult := MagImageManager1.GetFile(TxtFilename, IObj.PlaceCode, IObj.ImgType, False, True);
        If (TxtResult.FTransferStatus = IMAGE_FAILED) Or
          (TxtResult.FTransferStatus = IMAGE_UNAVAILABLE) Then
          TxtFilename := ''
        Else
          TxtFilename := TxtResult.FDestinationFilename;
      End;
    End;
{
  if getImageUtility().determineStorageProtocol(IObj.FFile) = MagStorageUNC then
  begin
    Txtfilename := ChangeFileExt(IObj.FFile, '.txt');
    LogMsg('s','About to get text file for image [' + IObj.Mag0 + ']');
    txtResult := DMagImageManager.getFile(TxtFilename, IObj.PlaceCode, false);
    if (txtResult.FTransferStatus = IMAGE_FAILED) or
      (txtResult.FTransferStatus = IMAGE_UNAVAILABLE) then
      TxtFilename := ''
    else
      txtFilename := txtResult.FDestinationFilename;
  end;
  }
  //LogMsg('s','About to load DICOM header information for image [' + IObj.Mag0 + ']');
    MagLogger.LogMsg('s', 'About to load DICOM header information for image [' + IObj.Mag0 + ']'); {JK 10/6/2009 - Maggmsgu refactoring}
    If Not Mag4Vgear1.LoadDICOMData(TxtFilename, FCurrentPatientSSN,
      FCurrentPatientICN, False) Then
    Begin
      Mag4Vgear1.ClearImage();
      Mag4Vgear1.ImageLoaded := True;
      Mag4Vgear1.LoadTheImage(MagImageManager1.GetCannedBMP(MagAbsQA));
      Mag4Vgear1.DisableWindowLevel();
      If Assigned(FPatientIDMismatchEvent) Then
        FPatientIDMismatchEvent(Self, Mag4Vgear1);
    //LogMsg('DEQA','Patient identifier from VistA does not match patient identifier from image.');
      MagLogger.LogMsg('DEQA', 'Patient identifier from VistA does not match patient identifier from image.'); {JK 10/6/2009 - Maggmsgu refactoring}
    End
    Else
    Begin
    // check here to see if using current settings or whatever
    {TODO: 72BUG ? Here is the PROBLEM of not being able to window and level a TGA}
 // JMW P72 11/29/2007
 // Need to set the image state to a variable so we can free it later
      ImgState := Mag4Vgear1.GetState;
      If ImgState.WinLevEnabled Then // use window/level
      Begin
//      if ((FPageSameSettings) or (FApplyGivenWindowSettings)) and (Fstate <> nil) and (FState.WinValue > 0) and (FState.LevValue > 0) then
      // level value can be less than 0

      //if ((FPageSameSettings) or (FApplyGivenWindowSettings)) and (Fstate <> nil) and (FState.WinValue >= 0) then
        If (Fstate <> Nil) And (Fstate.WinValue >= 0) Then
        Begin
          Mag4Vgear1.CalculateMaxWinLev();
          Mag4Vgear1.WinLevValue(Fstate.WinValue, Fstate.LevValue);
          If Fstate.ZoomValue >= 0 Then
            Mag4Vgear1.ZoomValue(Fstate.ZoomValue);
        End
        Else
        Begin
          Mag4Vgear1.WindowLevelEntireImage();
        // JMW 12/8/06 auto redraw needs to be on so fitToWindow can update the zoom value
          Mag4Vgear1.AutoRedraw := True;
          Mag4Vgear1.FitToWindow();
        End;
      // reset brightness/contrast to 100
        Mag4Vgear1.BrightnessContrastValue(100, 100, True);
      End
      Else
      Begin // use brightness/contrast
      //if ((FPageSameSettings) or (FApplyGivenWindowSettings)) and (Fstate <> nil) then
        If (Fstate <> Nil) Then
        Begin
          Mag4Vgear1.BrightnessContrastValue(Fstate.BrightnessValue, Fstate.ContrastValue);
          If Fstate.ZoomValue >= 0 Then
            Mag4Vgear1.ZoomValue(Fstate.ZoomValue);
        End
        Else
        Begin
        // JMW p72 10/18/2006
        // really not sure if this is right - this should only happen when using 'Image' Settings (normally auto-window level)
        // but since color images don't win/lev, reset to 100
          Mag4Vgear1.BrightnessContrastValue(100, 100);
        // JMW 12/8/06 auto redraw needs to be on so fitToWindow can update the zoom value
          Mag4Vgear1.AutoRedraw := True;
          Mag4Vgear1.FitToWindow();
        End;
      End; { win/lev enabled}
    End; {failed SSN check}

    Mag4Vgear1.ImageDescription := '#' + Inttostr(ImgIndex + 1) + ' ' + IObj.ExpandedDescription(False);

  // maybe check if autoredraw = true, if true then don't do the updatepageview here (probably already done) - sorta weird and kludgy
    Mag4Vgear1.AutoRedraw := True;
    Mag4Vgear1.UpdatePageView();

    Mag4Vgear1.DrawRadLetters();
    Mag4Vgear1.ShowPixelValues := FShowPixelValues;
    CheckButtons();
    Mag4Vgear1.SetCurrentTool(FCurrentTool);

    if ImgResult.FTransferStatus = IMAGE_COPIED then  {/ P117 JK 1/24/2011 - don't register a LogImageAccess event if the image wan not loaded /}
      If DMagImageAccessLogManager <> Nil Then
      Begin {get the error here, after <Paramater Error> MAGGTU6}
        DMagImageAccessLogManager.LogImageAccess(IObj);
      End;

  // only set the current viewer to king if setSelected=true
    If Assigned(FImageChangedEvent) And (SetIsSelected) Then
      FImageChangedEvent(Self, Mag4Vgear1);
    If SetIsSelected Then
      SetSelected();
    SetPanWindow(FPanWindow);

  // clear the FState after every use
  Finally
    If Fstate <> Nil Then
    Begin
      Fstate.Free();
      Fstate := Nil;
    End;

    If ImgState <> Nil Then
      FreeAndNil(ImgState);
    If TxtResult <> Nil Then
      FreeAndNil(TxtResult);
    If ImgResult <> Nil Then
      FreeAndNil(ImgResult);

    FFirstImageLoaded := True;
    ExamineSeries();
  End;
End;

Function TMag4StackViewer.IsStudyAlreadyLoaded(FirstImageIEN: String; Server: String; Port: Integer; StudyImgCount: Integer): Boolean;
Var
  Img: TImageData;
Begin
  Result := False;
  If FImageList = Nil Then Exit;
  If FImageList.Count <= 0 Then Exit;
  Img := FImageList.Items[0];
  If Img = Nil Then Exit;
  If Img.Mag0 <> FirstImageIEN Then Exit;
  If Img.ServerName <> Server Then Exit;
  If Img.ServerPort <> Port Then Exit;
  If FImageList.Count <> StudyImgCount Then Exit;
  Result := True;
End;

Procedure TMag4StackViewer.UnSelectAll();
Begin
  Mag4Vgear1.Selected := False;
  {
  if Mag4Vgear2.Visible then
    Mag4VGear2.Visible := true;
  }
End;

Procedure TMag4StackViewer.OnImageMouseScrollDown(Sender: Tobject; Shift: TShiftState; MousePos: TPoint; Var Handled: Boolean);
Begin
  btnPageNextClick(Self);
  Handled := True; //jw 11/16/07
End;

Procedure TMag4StackViewer.OnImageMouseScrollUp(Sender: Tobject; Shift: TShiftState; MousePos: TPoint; Var Handled: Boolean);
Begin
  btnPagePrevClick(Self);
  Handled := True; //jw 11/16/07
End;

Function TMag4StackViewer.GetStudyList(): Tlist;
Begin
  Result := FImageList;
End;

Function TMag4StackViewer.GetStudyListCount(): Integer;
Begin
  Result := 0;
  If FImageList = Nil Then Exit;
  Result := FImageList.Count;
End;

Function TMag4StackViewer.GetCurrentImage(): TMag4VGear;
Begin
  Result := Mag4Vgear1;
  //TODO: this should return the current selected image
End;

Function TMag4StackViewer.GetCurrentImageIndex(): Integer;
Begin
  Result := FCurrentImageIndex;
End;

Procedure TMag4StackViewer.Mag4Vgear1ImageMouseDown(Sender: Tobject;
  Button: TMouseButton; Shift: TShiftState; x, y: Integer);
Begin
  FCurrentGearControl := Mag4Vgear1;
//  Mag4VGear1.Selected := true;
//  Mag4VGear2.Selected := false;
  If Assigned(OnStackViewerClick) Then
    OnStackViewerClick(Self, Self, Mag4Vgear1);

  Mag4Vgear1.Selected := True;
  // JMW 8/11/08 - hopefully this fixes the 'cannot focus a disabled or
  // invisible window' error message
  Try
    If (Mag4Vgear1.Visible) And (Mag4Vgear1.Enabled) Then
      Mag4Vgear1.SetFocus();
  Except
    On e: Exception Do
    Begin
      //LogMsg('s', 'Exception setting gear focus [' + e.Message + ']', MagLogERROR);
      MagLogger.LogMsg('s', 'Exception setting gear focus [' + e.Message + ']', MagLogERROR); {JK 10/6/2009 - Maggmsgu refactoring}
    End;
  End;
  If FPanWindow Then SetPanWindow(FPanWindow);
End;

Procedure TMag4StackViewer.AutoWinLevel();
Begin
  FCurrentTool := MactWinLev;
  FCurrentGearControl.AutoWinLevel();
   // JMW P72 12/4/07 - removing the setShowPixelValues(false), not sure why I was
   // setting this value to false for window leveling...
 //  setShowPixelValues(false);
End;

Procedure TMag4StackViewer.MousePan();
Begin
  FCurrentTool := MactPan;
  FCurrentGearControl.MousePan();
End;

Procedure TMag4StackViewer.WinLevValue(WinValue, LevelValue: Integer);
Begin
  FCurrentGearControl.WinLevValue(WinValue, LevelValue);
End;

Procedure TMag4StackViewer.SetApplyToAll(Value: Boolean);
Begin
  FApplytoall := Value;
End;

Function TMag4StackViewer.GetApplyToAll(): Boolean;
Begin
  Result := FApplytoall;
End;

Procedure TMag4StackViewer.Fit1to1();
Begin
  FCurrentGearControl.Fit1to1();
End;

Procedure TMag4StackViewer.FitToHeight();
Begin
  FCurrentGearControl.FitToHeight();
End;

Procedure TMag4StackViewer.FitToWindow();
Begin
  FCurrentGearControl.FitToWindow();
End;

Procedure TMag4StackViewer.Inverse();
Begin
  FCurrentGearControl.Inverse();
End;

Procedure TMag4StackViewer.FitToWidth();
Begin
  FCurrentGearControl.FitToWidth();
End;

Procedure TMag4StackViewer.Rotate(Deg: Integer);
Begin
  FCurrentGearControl.Rotate(Deg);
End;

Procedure TMag4StackViewer.MouseMagnify();
Begin
  FCurrentTool := MactMagnify;
  FCurrentGearControl.MouseMagnify();
End;

Procedure TMag4StackViewer.MouseZoomRect();
Begin
  FCurrentTool := MactZoomRect;
  FCurrentGearControl.MouseZoomRect();
End;

Function TMag4StackViewer.GetPanWindow(): Boolean;
Begin
  Result := FPanWindow;
End;

Procedure TMag4StackViewer.SetPanWindowWithActivateOption(Value: Boolean;
  Activate: Boolean);
Var
  x, y: Integer;
  Viewerpt, Imagept: TPoint;
  h, w: Integer;
Begin
  FPanWindow := Value;
  {    below, we are only appling PanWindow to the Current Image{}
  If FCurrentGearControl = Nil Then Exit;
  Viewerpt := Parent.ClientOrigin;
  Imagept := FCurrentGearControl.ClientOrigin;
  x := Imagept.x - 100 + FCurrentGearControl.Width; // Cur4Image.Gear1.Width;
  y := Imagept.y;
  h := Trunc(FCurrentGearControl.Height / 2.5);
  w := Trunc(FCurrentGearControl.Width / 2);
  If (Value) And (Activate) Then
    FCurrentGearControl.PanWindowSettings(h, w, x, y)
  Else
    FCurrentGearControl.PanWindow := Value;
End;

Procedure TMag4StackViewer.SetPanWindow(Value: Boolean);
Begin
  SetPanWindowWithActivateOption(Value, True);
End;

Procedure TMag4StackViewer.TileAll();
Begin
  // do nothing here
End;

Procedure TMag4StackViewer.FlipVert();
Begin
  FCurrentGearControl.FlipVert();
End;

Procedure TMag4StackViewer.FlipHoriz();
Begin
  FCurrentGearControl.FlipHoriz();
End;

Function TMag4StackViewer.GetViewerStyle(): TMagViewerStyles;
Begin
  Result := MagvsVirtual; // should even return this?
End;

Procedure TMag4StackViewer.SetViewerStyle(Const Value: TMagViewerStyles);
Begin
  // do nothing
End;

Procedure TMag4StackViewer.EditViewerSettings();
Begin
  // do nothing
End;

Procedure TMag4StackViewer.RemoveFromList();
Var
  IObj: TImageData;
Begin
  IObj := FImageList.Items[FCurrentImageIndex];
  FImageList.Remove(IObj);
  PnlTop.caption := FStudyDesc + '  - ' + Inttostr(FImageList.Count) + '  Images';
  If FImageList.Count > 0 Then
    TbStudy.Max := FImageList.Count - 1
  Else
    TbStudy.Max := 0;

  CheckButtons();
End;

Procedure TMag4StackViewer.ClearViewer();
Begin
  tmrScrollDelay.Enabled := False;
  PnlTop.caption := '';
  Mag4Vgear1.ClearImage();
//  Mag4Vgear2.ClearImage();
  FCurrentGearControl := Mag4Vgear1;
  FImageList.Clear();
  FCurrentImageIndex := -1;
  ImgStudyStatus.Visible := False;
  FStudyChangeEventEnabled := False;
  TbStudy.Max := 0;
  FStudyChangeEventEnabled := True;
  CheckButtons();
  If Fstate <> Nil Then
    Fstate.Free();
  Fstate := Nil;
  FFirstImageLoaded := False;
  cboSeries.Clear();
  cboSeries.Visible := False;
End;

Procedure TMag4StackViewer.ToggleSelected();
Begin
  // not sure what to do here
End;

Procedure TMag4StackViewer.ZoomValue(Zoom: Integer);
Begin
  FCurrentGearControl.ZoomValue(Zoom);
End;

Procedure TMag4StackViewer.BrightnessValue(Value: Integer);
Begin
  FCurrentGearControl.BrightnessValue(Value);
End;

Procedure TMag4StackViewer.ContrastValue(Value: Integer);
Begin
  FCurrentGearControl.ContrastValue(Value);
End;

Procedure TMag4StackViewer.ImagePrint();
Begin
  //TODO: handle printing
End;

Procedure TMag4StackViewer.ImageCopy();
Begin
  //TODO: handle copying
End;

Procedure TMag4StackViewer.ImageReport();
Var
  Stat: Boolean;
  Xmsg: String;
Begin
  If Not Assigned(FMagUtilsDB) Then
  Begin
    Messagedlg('DataBase Utilities are not linked (cmagUtilsDB)', MtWarning, [Mbok], 0);
    Exit;
  End;
  If Not Assigned(FCurrentGearControl) Then
  Begin
    Messagedlg('There are no selected images.', Mtconfirmation, [Mbok], 0);
    Exit;
  End;
  FMagUtilsDB.ImageReport(FCurrentGearControl.PI_ptrData, Stat, Xmsg);

End;

Function TMag4StackViewer.GetImagePage(): Integer;
Begin
  Result := FCurrentGearControl.Page;
End;

Procedure TMag4StackViewer.SetImagePage(Const Value: Integer);
Begin
  FCurrentGearControl.Page := Value;
End;

Procedure TMag4StackViewer.SetImagePageUseApplyToAll(Const Value: Integer);
Begin
  SetImagePage(Value);
End;

Procedure TMag4StackViewer.PageFirstImage();
Begin
  FCurrentGearControl.PageFirst();
End;

Procedure TMag4StackViewer.PagePrevImage();
Begin
  FCurrentGearControl.PagePrev();
End;

Procedure TMag4StackViewer.PageNextImage();
Begin
  FCurrentGearControl.PageNext();
End;

Procedure TMag4StackViewer.PageLastImage();
Begin
  FCurrentGearControl.PageLast();
End;

Procedure TMag4StackViewer.ResetImages(ApplyToAll: Boolean = False); // resets the image (all if apply to all selected)
Begin
  FCurrentGearControl.ResetImage();
End;

Procedure TMag4StackViewer.SetMaximizeImage(Value: Boolean);
Begin
  // do nothing?
End;

Function TMag4StackViewer.GetMaximizeImage(): Boolean;
Begin
  Result := True;
End;

Procedure TMag4StackViewer.SetRowColCount(r, c: Integer; ImageToDisplayIndex: Integer = -1);
Begin
  // do nothing
End;

Procedure TMag4StackViewer.SetLockSize(Value: Boolean);
Begin
  // do nothing
End;

Function TMag4StackViewer.GetLockSize(): Boolean;
Begin
  // do nothing
  Result := False;
End;

Function TMag4StackViewer.GetClearBeforeAdd(): Boolean;
Begin
  // do nothing
  Result := False;
End;

Procedure TMag4StackViewer.SetClearBeforeAdd(Value: Boolean);
Begin
  // do nothing
End;

Procedure TMag4StackViewer.MouseReSet();
Begin
  FCurrentGearControl.MouseReSet();
End;

Procedure TMag4StackViewer.PageFirstViewer(SetSelected: Boolean = True);
Begin
  LoadImage(0, False, SetSelected);
End;

Procedure TMag4StackViewer.PageNextViewer(SetSelected: Boolean = True);
Begin
  If FCurrentImageIndex < FImageList.Count Then
    LoadImage(FCurrentImageIndex + 1, False, SetSelected)
End;

Procedure TMag4StackViewer.PagePrevViewer(SetSelected: Boolean = True);
Begin
  If FCurrentImageIndex > 0 Then
    LoadImage(FCurrentImageIndex - 1, False, SetSelected);
End;

Procedure TMag4StackViewer.PageLastViewer(SetSelected: Boolean = True);
Begin
  LoadImage(FImageList.Count - 1, False, SetSelected);
End;

Procedure TMag4StackViewer.SetMaxCount(Value: Integer);
Begin
  // do nothing
End;

Function TMag4StackViewer.GetMaxCount(): Integer;
Begin
  Result := 1;
End;

Procedure TMag4StackViewer.ReAlignImages(Ignmax: Boolean = False; Ignlocksize: Boolean = False; ImageToDisplayIndex: Integer = -1);
Begin
  // this also needs to update description
  // problem if closing first image, it won't reload new one (index is the same);
  // either have to clear before loading or load new one then get rid of old one
  // or change current index when clearing image (set to -1 maybe?) sorta logical

  If ImageToDisplayIndex < 0 Then
  Begin
    If FCurrentImageIndex > 0 Then
    Begin
      ImageToDisplayIndex := FCurrentImageIndex - 1;
    End
    Else
    Begin
      If FImageList.Count > 0 Then
      Begin
        ImageToDisplayIndex := 0;
      End;
    End;
  End;

  If ImageToDisplayIndex >= 0 Then
  Begin
    FCurrentImageIndex := -1; // reset the current index to reload the selected image
    LoadImage(ImageToDisplayIndex);
  End
  Else
  Begin
    ClearViewer();
  End;
  // do nothing
End;

Procedure TMag4StackViewer.ReFreshImages();
Begin
  FCurrentGearControl.RefreshImage();
End;

Procedure TMag4StackViewer.ViewFullResImage();
Begin
  LoadImage(FCurrentImageIndex, True);
End;

Procedure TMag4StackViewer.SetSelected();
Begin
  FCurrentGearControl.Selected := True;
End;

Procedure TMag4StackViewer.Mag4Vgear1ImageDoubleClickEvent(
  Sender: Tobject);
Begin
  //  not sure what do to with this at the moment....
  If Assigned(OnStackImaegDoubleClick) Then
    OnStackImaegDoubleClick(Sender, Self, Mag4Vgear1);
End;

Procedure TMag4StackViewer.SetApplyGivenWindowSettings(Value: Boolean);
Begin
  FApplyGivenWindowSettings := Value;
  If FApplyGivenWindowSettings Then
    FPageSameSettings := False;
End;

Procedure TMag4StackViewer.SetPageSameSettings(Value: Boolean);
Begin
  FPageSameSettings := Value;
  If FPageSameSettings Then
    FApplyGivenWindowSettings := False;

End;

Procedure TMag4StackViewer.SetDefaultState(State: TMagImageState);
Begin
  Fstate := State;
End;

Procedure TMag4StackViewer.ApplyImageState(State: TMagImageState; ApplyAll: Boolean = False);
Begin
  If State = Nil Then Exit;
  FCurrentGearControl.WinLevValue(State.WinValue, State.LevValue);
  FCurrentGearControl.BrightnessValue(State.BrightnessValue);
  FCurrentGearControl.ContrastValue(State.ContrastValue);
  FCurrentGearControl.Page := State.Page;
  // JMW 1/26/2007 P72 - taking out ZoomValue - not sure if that should be applied or not...
  // was causing switching between views to double resize (normal - small - normal)

  // setting the zoom is needed for when applytoall is set with 2 stacks - need to set zoom together
  // JMW 1/26/2007 - put this back in but if -1 then don't apply zoom
  If State.ZoomValue >= 0 Then
    FCurrentGearControl.ZoomValue(State.ZoomValue);

  // use apply to all if ever using 2nd gear control
  // would be nice to apply mouse state
End;

Procedure TMag4StackViewer.AddImage(IObj: TImageData);
Var
  NewObj: TImageData;
Begin
  NewObj := TImageData.Create();
  NewObj.MagAssign(IObj);
  FImageList.Add(NewObj);
End;

Procedure TMag4StackViewer.RemoveImageIndex(Index: Integer);
Var
  IObj: TImageData;
Begin
  IObj := FImageList.Items[Index];
  FImageList.Remove(IObj);
End;

Procedure TMag4StackViewer.TbStudyChange(Sender: Tobject);
Begin
  tmrScrollDelay.Enabled := False;
  If Not FStudyChangeEventEnabled Then
    Exit;
  tmrScrollDelay.Enabled := True;
  {
  if FApplyGivenWindowSettings then
  begin
   if Fstate <> nil then
     FreeAndNil(Fstate);
    FState := FCurrentGearControl.GetState;
  end;
  LoadImage(tbStudy.Position);
  }
End;

Procedure TMag4StackViewer.DisplayDICOMHeader();
Begin
  FCurrentGearControl.DisplayDICOMHeader();
End;

Procedure TMag4StackViewer.MnuScrollStartPositionClick(Sender: Tobject);
Begin
  SetStackCineStartPosition();
End;

Procedure TMag4StackViewer.MnuScrollEndPositionClick(Sender: Tobject);
Begin
  SetStackCineStopPosition();
End;

Procedure TMag4StackViewer.MnuScrollClearClick(Sender: Tobject);
Begin
  ClearStackCinePosition();
End;

Procedure TMag4StackViewer.TmrScrollTimer(Sender: Tobject);
Var
  StartPos: Integer;
  EndPos: Integer;
Begin
  If (TbStudy.SELSTART = 0) And (TbStudy.SELEND = 0) Then
  Begin
    StartPos := TbStudy.Min;
    EndPos := TbStudy.Max;
  End
  Else
  Begin
    StartPos := TbStudy.SELSTART;
    EndPos := TbStudy.SELEND;
  End;
  If EndPos <= StartPos Then Exit;

  If FApplyGivenWindowSettings Then
  Begin
    Fstate := FCurrentGearControl.GetState;
  End;
  If TbStudy.Position >= EndPos Then
  Begin
    LoadImage(StartPos);
    If Assigned(OnStackViewerClick) Then
      OnStackViewerClick(Self, Self, FCurrentGearControl);
    If Assigned(OnPageFirstStackViewerClick) Then
      OnPageFirstStackViewerClick(Self);
  End
  Else
  Begin
    LoadImage(TbStudy.Position + 1);
    If Assigned(OnStackViewerClick) Then
      OnStackViewerClick(Self, Self, FCurrentGearControl);
    If Assigned(OnPageNextStackViewerClick) Then
      OnPageNextStackViewerClick(Self);
  End;

End;

Procedure TMag4StackViewer.MnuScrollStartClick(Sender: Tobject);
Begin
  TmrScroll.Enabled := True;
  CheckStartStopButton();
End;

Procedure TMag4StackViewer.MnuScrollStopClick(Sender: Tobject);
Begin
  TmrScroll.Enabled := False;
  CheckStartStopButton();
End;

Procedure TMag4StackViewer.cboSeriesChange(Sender: Tobject);
Var
//  index : integer;
  Series: TMagSeriesObject;
Begin
  If cboSeries.Text = 'Series' Then Exit;
  Series := (cboSeries.Items.Objects[cboSeries.ItemIndex] As TMagSeriesObject);
  If Series = Nil Then Exit;
  LoadImage(Series.ImageIndex);
End;

Procedure TMag4StackViewer.StopScrolling();
Begin
  TmrScroll.Enabled := False;
End;

Procedure TMag4StackViewer.RIVRecieveUpdate_(action: String; Value: String); // recieve updates from everyone
Var
  NetworkFilename: String;
  IObj: TImageData;
Begin
  If (FImageList = Nil) Or (FImageList.Count <= 0) Then Exit;
  IObj := FImageList.Items[0];

  NetworkFilename := Value;
  If action = 'ImageStart' Then
  Begin
    If IObj.FFile = NetworkFilename Then
    Begin
      ImageList1.GetIcon(8, ImgStudyStatus.Picture.Icon);
      ImgStudyStatus.Visible := True;
    End;
  End
  Else
    If action = 'ImageComplete' Then
    Begin
      If IObj.FFile = NetworkFilename Then
      Begin
        ImageList1.GetIcon(9, ImgStudyStatus.Picture.Icon);
        ImgStudyStatus.Visible := True;
      End;
    End;
End;

Procedure TMag4StackViewer.CheckButtons();
Var
  CanScroll: Boolean;
Begin
  CanScroll := False;
  {
  tbPagePrev.Enabled := true;
  tbPageNext.Enabled := true;
  tbPageLast.Enabled := true;
  tbPageFirst.Enabled := true;
  }
  If FImageList.Count = 0 Then
  Begin
    btnPageFirst.Enabled := False;
    btnPageNext.Enabled := False;
    btnPageLast.Enabled := False;
    btnPagePrev.Enabled := False;
    CanScroll := False;
  End
  Else
  Begin
    If FImageList.Count > 1 Then
    Begin
      CanScroll := True;
    End;
    If FCurrentImageIndex >= (FImageList.Count - 1) Then
    Begin
      btnPageNext.Enabled := False;
      btnPageLast.Enabled := False;
    End
    Else
    Begin
      btnPageNext.Enabled := True;
      btnPageLast.Enabled := True;
    End;
    If FCurrentImageIndex <= 0 Then
    Begin
      btnPageFirst.Enabled := False;
      btnPagePrev.Enabled := False;
    End
    Else
    Begin
      btnPageFirst.Enabled := True;
      btnPagePrev.Enabled := True;
    End;
  End;

  { JMW 8/12/08
  Not sure why this is disabled for multiple page images...
  seems to work ok, leave this way for now...
  }
  {
   JMW 8/12/08 - added check to be sure there are more than 1 image in the study
   before allowing the scrolling
  }
  If (FCurrentGearControl.PageCount > 1) Or (Not CanScroll) Then
  Begin
    TmrScroll.Enabled := False;
    btnScrollStartStop.Enabled := False;
    CheckStartStopButton();
    MnuScrollStart.Enabled := False;
  End
  Else
  Begin
    btnScrollStartStop.Enabled := True;
    CheckStartStopButton();
  End;
End;

Procedure TMag4StackViewer.SetShowPixelValues(Value: Boolean);
Begin
  FShowPixelValues := Value;
  Mag4Vgear1.ShowPixelValues := FShowPixelValues;
//  Mag4Vgear2.ShowPixelValues := FShowPixelValues;
End;

Function TMag4StackViewer.GetShowPixelValues(): Boolean;
Begin
  Result := FShowPixelValues;
End;

Function TMag4StackViewer.GetHistogramWindowLevel(): Boolean;
Begin
  Result := FHistogramWindowLevel;
End;

Procedure TMag4StackViewer.SetHistogramWindowLevel(Value: Boolean);
Begin
  FHistogramWindowLevel := Value;
  Mag4Vgear1.HistogramWindowLevel := FHistogramWindowLevel;
//  Mag4Vgear2.HistogramWindowLevel := FHistogramWindowLevel;
End;

Procedure TMag4StackViewer.TbStudySpeedChange(Sender: Tobject);
Begin
  TmrScroll.Interval := TbStudySpeed.Position;
End;

Procedure TMag4StackViewer.btnScrollStartStopClick(Sender: Tobject);
Begin
  TmrScroll.Enabled := Not TmrScroll.Enabled;
  CheckStartStopButton();
End;

Procedure TMag4StackViewer.CheckStartStopButton();
Begin
  // timer disabled and button enabled to allow the start menu option to be on
  MnuScrollStart.Enabled := (Not TmrScroll.Enabled) And (btnScrollStartStop.Enabled);
  MnuScrollStop.Enabled := TmrScroll.Enabled;
  btnScrollStartStop.Glyph := Nil;
  If TmrScroll.Enabled Then
  Begin
    ImageList1.GetBitmap(7, btnScrollStartStop.Glyph);
  End
  Else
  Begin
    ImageList1.GetBitmap(6, btnScrollStartStop.Glyph);
  End;
End;

Function TMag4StackViewer.GetShowLabels(): Boolean;
Begin
  Result := FShowLabels;
End;

Procedure TMag4StackViewer.SetShowLabels(Value: Boolean);
Begin
  FShowLabels := Value;
  Mag4Vgear1.ShowLabels := FShowLabels;
//  Mag4Vgear2.ShowLabels := FShowLabels;
End;

Procedure TMag4StackViewer.ImageZoomScroll(Sender: Tobject; VertScrollPos: Integer; HorizScrollPos: Integer);
Begin
  If (FApplytoall) And Assigned(FImageScroll) Then
    FImageScroll(Sender, VertScrollPos, HorizScrollPos);
{
  if FApplyToAll then
    Mag4Vgear1.OnImageZoomScroll(sender, VertScrollPos, HorizScrollPos);
    }
End;

Procedure TMag4StackViewer.ApplyImageZoomScroll(Sender: Tobject; VertScrollPos: Integer; HorizScrollPos: Integer);
Begin
  Mag4Vgear1.SetScrollPos(VertScrollPos, HorizScrollPos);
End;

Procedure TMag4StackViewer.SetImageScroll(Value: TImageScrollEvent);
Begin
  FImageScroll := Value;
//  Mag4Vgear1.OnImageZoomScroll := FImageScroll;

End;

Procedure TMag4StackViewer.ImageWinLevChange(Sender: Tobject; WindowValue: Integer; LevelValue: Integer);
Begin
  If (FApplytoall) And Assigned(OnImageWinLevChange) Then
    OnImageWinLevChange(Self, WindowValue, LevelValue);
End;

Procedure TMag4StackViewer.ImageBriConChange(Sender: Tobject; BrightnessValue: Integer; ContrastValue: Integer);
Begin
  If (FApplytoall) And Assigned(OnImageBriConChange) Then
    OnImageBriConChange(Self, BrightnessValue, ContrastValue);
End;

Procedure TMag4StackViewer.BrightnessContrastValue(Bright, Contrast: Integer);
Begin
  Mag4Vgear1.BrightnessContrastValue(Bright, Contrast);
End;

Function TMag4StackViewer.GetCurrentTool(): TMagImageMouse;
Begin
  Result := FCurrentTool;
End;

Procedure TMag4StackViewer.SetCurrentTool(Value: TMagImageMouse);
Begin
  FCurrentTool := Value;
  Case FCurrentTool Of
    MactPan:
      MousePan();
    MactMagnify:
      MouseMagnify();
    MactZoomRect:
      MouseZoomRect();
    MactWinLev:
      AutoWinLevel();
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

Procedure TMag4StackViewer.Annotations();
Begin
  FCurrentTool := MactAnnotation;
  // this event is fired when the toolbar is pressed
  If FCurrentGearControl = Nil Then Exit;
  FCurrentGearControl.Annotations();
End;

Procedure TMag4StackViewer.Measurements();
Begin
  FCurrentTool := MactMeasure;
  FCurrentGearControl.Measurements();
End;

Procedure TMag4StackViewer.Protractor();
Begin
  FCurrentTool := MactProtractor;
  FCurrentGearControl.Protractor;
End;

Procedure TMag4StackViewer.AnnotationPointer();
Begin
  FCurrentTool := MactAnnotationPointer;
  FCurrentGearControl.AnnotationPointer();
End;

Procedure TMag4StackViewer.ImageToolChange(Sender: Tobject; Tool: TMagImageMouse);
Begin
  If Assigned(OnStackViewerClick) And (Sender Is TMag4VGear) Then
    OnStackViewerClick(Self, Self, (Sender As TMag4VGear));
  FCurrentTool := Tool;
  If Assigned(OnImageToolChange) Then
    OnImageToolChange(Self, Tool);
End;

Procedure TMag4StackViewer.btnPageFirstClick(Sender: Tobject);
Begin
  // FApplyGivenWindowSettings means want to use window settings given but since
  // this vGear is changing the page it is the one giving the value so it needs
  // to get the value first
  If FApplyGivenWindowSettings Then
  Begin
    Fstate := FCurrentGearControl.GetState;
  End;
  PageFirstViewer();
//  setSelected(); // JMW 3/24/2007 - no longer needed here, done in LoadImage
  If Assigned(OnStackViewerClick) Then
    OnStackViewerClick(Self, Self, FCurrentGearControl);
  If Assigned(OnPageFirstStackViewerClick) Then
    OnPageFirstStackViewerClick(Self);

End;

Procedure TMag4StackViewer.btnPagePrevClick(Sender: Tobject);
Begin
  // FApplyGivenWindowSettings means want to use window settings given but since
  // this vGear is changing the page it is the one giving the value so it needs
  // to get the value first
  If FApplyGivenWindowSettings Then
  Begin
    Fstate := FCurrentGearControl.GetState;
  End;
  PagePrevViewer();
//  setSelected(); // JMW 3/24/2007 - no longer needed here, done in LoadImage
  If Assigned(OnStackViewerClick) Then
    OnStackViewerClick(Self, Self, FCurrentGearControl);
  If Assigned(OnPagePreviousStackViewerClick) Then
    OnPagePreviousStackViewerClick(Self);

End;

Procedure TMag4StackViewer.btnPageNextClick(Sender: Tobject);
Begin
  // FApplyGivenWindowSettings means want to use window settings given but since
  // this vGear is changing the page it is the one giving the value so it needs
  // to get the value first
  If FApplyGivenWindowSettings Then
  Begin
    Fstate := FCurrentGearControl.GetState;
  End;
  PageNextViewer();
//  setSelected(); // JMW 3/24/2007 - no longer needed here, done in LoadImage
  If Assigned(OnStackViewerClick) Then
    OnStackViewerClick(Self, Self, FCurrentGearControl);
  If Assigned(OnPageNextStackViewerClick) Then
    OnPageNextStackViewerClick(Self);

End;

Procedure TMag4StackViewer.btnPageLastClick(Sender: Tobject);
Begin
  // FApplyGivenWindowSettings means want to use window settings given but since
  // this vGear is changing the page it is the one giving the value so it needs
  // to get the value first
  If FApplyGivenWindowSettings Then
  Begin
    Fstate := FCurrentGearControl.GetState;
  End;
  PageLastViewer();
//  setSelected(); // JMW 3/24/2007 - no longer needed here, done in LoadImage
  If Assigned(OnStackViewerClick) Then
    OnStackViewerClick(Self, Self, FCurrentGearControl);
  If Assigned(OnPageLastStackViewerClick) Then
    OnPageLastStackViewerClick(Self);

End;

Procedure TMag4StackViewer.ExamineSeries();
Var
  Dicomdata: TDicomData;
  i: Integer;
  Series: TMagSeriesObject;
  IObj: TImageData;
Begin
  If cboSeries.Visible = False Then Exit;
  Dicomdata := Mag4Vgear1.Dicomdata;
  IObj := Mag4Vgear1.PI_ptrData;
  If Dicomdata = Nil Then Exit;

  For i := 0 To cboSeries.Items.Count - 1 Do
  Begin
    If cboSeries.Items[i] <> 'Series' Then
    Begin
      Series := (cboSeries.Items.Objects[i] As TMagSeriesObject);
      If (Series.SeriesName = IObj.DicomSequenceNumber) Then
      Begin
        If Not Series.SeriesNameUpdated Then
        Begin
          Series.SeriesNameUpdated := True;
          If Dicomdata.SeriesDescription <> '' Then
            cboSeries.Items[i] := IObj.DicomSequenceNumber + '-' + Dicomdata.SeriesDescription + '(' + Inttostr(Series.SeriesImgCount) + ')';
        End;
        cboSeries.ItemIndex := i;
        cboSeries.Hint := cboSeries.Items[i];
        Exit;
      End;
    End;
  End;
End;

Procedure TMag4StackViewer.ImageZoomChange(Sender: Tobject; ZoomValue: Integer);
Begin
  If (FApplytoall) And Assigned(FImageZoomChange) Then
    FImageZoomChange(Self, ZoomValue);
End;

Procedure TMag4StackViewer.ImageUpdateImageState(Sender: Tobject);
Begin
  SetSelected();
  If Assigned(OnStackViewerClick) Then
    OnStackViewerClick(Self, Self, FCurrentGearControl);
End;

Procedure TMag4StackViewer.ApplyViewerState(Viewer: IMag4Viewer);
Begin
//  self.FPanWindow := viewer.PanWindow;
  SetPanWindow(Viewer.PanWindow);
  Self.FApplytoall := Viewer.ApplyToAll;
End;

Procedure TMag4StackViewer.SetAnnotationStyle(AnnotationStyle: TMagAnnotationStyle);
Begin
  FAnnotationStyle := AnnotationStyle;
  Mag4Vgear1.SetAnnotationStyle(FAnnotationStyle);
End;

Procedure TMag4StackViewer.SetAnnotationStyleChangeEvent(Value: TMagAnnotationStyleChangeEvent);
Begin
  FMagAnnotationStyleChangeEvent := Value;
  // don't need to pass to seperate function (i don't think...)
  Mag4Vgear1.OnMagAnnotationStyleChangeEvent := AnnotationStyleChangeEvent;
End;

Procedure TMag4StackViewer.AnnotationStyleChangeEvent(Sender: Tobject;
  AnnotationStyle: TMagAnnotationStyle);
Begin
  FAnnotationStyle := AnnotationStyle;
  If Assigned(FMagAnnotationStyleChangeEvent) Then
    FMagAnnotationStyleChangeEvent(Self, AnnotationStyle);

End;

Procedure TMag4StackViewer.PanWindowCloseEvent(Sender: Tobject);
Begin
  If Assigned(FPanWindowClose) Then
    FPanWindowClose(Sender);
End;

Procedure TMag4StackViewer.SetPanWindowClose(Value: TMagPanWindowCloseEvent);
Begin
  FPanWindowClose := Value;
  Mag4Vgear1.OnPanWindowClose := FPanWindowClose;
End;

Procedure TMag4StackViewer.ScrollCornerTL();
Begin
  Mag4Vgear1.SetScrollPos(-9999, -9999);
End;

Procedure TMag4StackViewer.ScrollCornerTR();
Begin
  Mag4Vgear1.SetScrollPos(-9999, 9999);
End;

Procedure TMag4StackViewer.ScrollCornerBL();
Begin
  Mag4Vgear1.SetScrollPos(9999, -9999);
End;

Procedure TMag4StackViewer.ScrollCornerBR();
Begin
  Mag4Vgear1.SetScrollPos(9999, 9999);
End;

Procedure TMag4StackViewer.ScrollLeft();
Begin
  Mag4Vgear1.ScrollLeft();
End;

Procedure TMag4StackViewer.ScrollRight();
Begin
  Mag4Vgear1.ScrollRight();
End;

Procedure TMag4StackViewer.ScrollUp();
Begin
  Mag4Vgear1.ScrollUp();
End;

Procedure TMag4StackViewer.ScrollDown();
Begin
  Mag4Vgear1.ScrollDown();
End;

Procedure TMag4StackViewer.StartStackCine();
Begin
  If btnScrollStartStop.Enabled Then
  Begin
    TmrScroll.Enabled := True;
    CheckStartStopButton();
  End;
End;

Procedure TMag4StackViewer.StopStackCine();
Begin
  If btnScrollStartStop.Enabled Then
  Begin
    StopScrolling();
    CheckStartStopButton();
  End;
End;

Procedure TMag4StackViewer.SpeedUpStackCine();
Begin
  // need to reduce the value of the delay to speed up the cine
  If (TbStudySpeed.Position - TbStudySpeed.Frequency) <= TbStudySpeed.Min Then
    TbStudySpeed.Position := TbStudySpeed.Min
  Else
    TbStudySpeed.Position := TbStudySpeed.Position - TbStudySpeed.Frequency;
End;

Procedure TMag4StackViewer.SlowDownStackCine();
Begin
  // need to increase the value of the delay to speed up the cine
  If (TbStudySpeed.Position + TbStudySpeed.Frequency) >= TbStudySpeed.Max Then
    TbStudySpeed.Position := TbStudySpeed.Max
  Else
    TbStudySpeed.Position := TbStudySpeed.Position + TbStudySpeed.Frequency;
End;

Procedure TMag4StackViewer.SetStackCineStartPosition();
Begin
  TbStudy.SELSTART := TbStudy.Position;
End;

Procedure TMag4StackViewer.SetStackCineStopPosition();
Begin
  TbStudy.SELEND := TbStudy.Position;
End;

Procedure TMag4StackViewer.ClearStackCinePosition();
Begin
  TbStudy.SELSTART := 0; //tbStudy.Min;
  TbStudy.SELEND := 0; //tbStudy.Max;
End;

Procedure TMag4StackViewer.SetMouseZoomShape(Value: TMagMouseZoomShape);
Begin
  FMouseZoomShape := Value;
  FCurrentGearControl.setMouseZoomShape(FMouseZoomShape);
End;

Function TMag4StackViewer.getMouseZoomShape(): TMagMouseZoomShape;
Begin
  Result := FMouseZoomShape;
End;

Procedure TMag4StackViewer.tmrScrollDelayTimer(Sender: Tobject);
Begin
  tmrScrollDelay.Enabled := False;
  If FApplyGivenWindowSettings Then
  Begin
    If Fstate <> Nil Then
      FreeAndNil(Fstate);
    Fstate := FCurrentGearControl.GetState;
  End;
  LoadImage(TbStudy.Position);
End;

End.
