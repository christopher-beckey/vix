Unit FMagAbstracts;
   {
   Package: MAG - VistA Imaging
   WARNING: Per VHA Directive 10-93-142 this unit should not be modified.
   Date Created:
   Site Name: Silver Spring, OIFO
   Developers: Garrett Kirin
   Description: Abstracts window.  Here abstracts of all image in the currently
     selected image list, will be displayed.
   Note:
   }
(*
        ;; +-----------------------------------------------------------------+
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
  cmag4viewer,
  //cMagLogManager, {JK 10/5/2009 - Maggmsgu refactoring - deprecated unit}
 // Maggmsgu, {/p117 out, use interface obj}
  Controls,
  ExtCtrls,
  Forms,
  Menus,
  Stdctrls,
  UMagClasses, ComCtrls
  ;

//Uses Vetted 20090929:MagRemoteInterface, MagRemoteToolbar, maggut1, fmagROI, cMagImageList, AxCtrls, OleCtrls, Buttons, Graphics, Messages, WinProcs, imaginterfaces, magImageManager, magpositions, fmagabsresize, dmSingle, cmag4vgear, umagdefinitions, uMagAppMgr, uMagKeyMgr, umagutils, Dialogs, WinTypes, SysUtils

Type
  TfrmMagAbstracts = Class(TForm)
    PopupVImage: TPopupMenu;
    MenuItem6: TMenuItem;
    MenuItem12: TMenuItem;
    mnuViewImagein2ndRadiologyWindow: TMenuItem;
    mnuImageReport: TMenuItem;
    mnuImageDelete: TMenuItem;
    mnuImageInformation: TMenuItem;
    mnuToolbar: TMenuItem;
    mnuShowHints: TMenuItem;
    mnuGotoMainWindow: TMenuItem;
    mnuStayOnTop: TMenuItem;
    mnuHelp: TMenuItem;
    mnuOpen: TMenuItem;
    mnuImageInformationAdvanced: TMenuItem;
    LbImagecount: Tlabel;
    N1: TMenuItem;
    ImageListFilters1: TMenuItem;
    mnuFontSize: TMenuItem;
    mnuFont6: TMenuItem;
    mnuFont7: TMenuItem;
    mnuFont8: TMenuItem;
    mnuFont10: TMenuItem;
    mnuFont12: TMenuItem;
    mnuRefresh: TMenuItem;
    mnuViewerSettings: TMenuItem;
    N3: TMenuItem;
    TimerReSize: TTimer;
    ResizetheAbstracts1: TMenuItem;
    Testrefreshone1: TMenuItem;
    Testrefresh1: TMenuItem;
    TESTUPDATE1: TMenuItem;
    TESTREFRESH2: TMenuItem;
    TESTREDRA1: TMenuItem;
    TESTSLDFJKS1: TMenuItem;
    TESTAUTOREDRAWTRUE1: TMenuItem;
    Testing1: TMenuItem;
    mnuImageSaveAs: TMenuItem;
    mnuCacheGroup: TMenuItem;
    MainMenu1: TMainMenu;
    mnuFile: TMenuItem;
    mnuExit: TMenuItem;
    mnuOptions: TMenuItem;
    mnuNext: TMenuItem;
    mnuPrev: TMenuItem;
    mnuPopupMenu: TMenuItem;
    GoToMainForm1: TMenuItem;
    mnuAbsBigger: TMenuItem;
    mnuAbsSmaller: TMenuItem;
    mnuRefresh1: TMenuItem;
    NextPage1: TMenuItem;
    PrevViewerPage1: TMenuItem;
    Label1: Tlabel;
    mnuOptions2: TMenuItem;
    PagePrevViewer: TMenuItem;
    NextViewerPage1: TMenuItem;
    SmallerAbs1: TMenuItem;
    LargerAbs1: TMenuItem;
    PrevAbs1: TMenuItem;
    NextAbs1: TMenuItem;
    AcitveForms1: TMenuItem;
    Activewindows1: TMenuItem;
    Mag4Viewer1: TMag4Viewer;
    mnuImageIndexEdit: TMenuItem;
    PageControl1: TPageControl;
    TabSheet1: TTabSheet;
    TabSheet2: TTabSheet;
    Splitter1: TSplitter; //45
    Procedure FormCreate(Sender: Tobject);
    Procedure FormResize(Sender: Tobject);
    Procedure FormPaint(Sender: Tobject);
    Procedure FormDestroy(Sender: Tobject);

    Procedure Mag4Viewer1ViewerImageClick(Sender: Tobject);
    Procedure mnuImageDeleteClick(Sender: Tobject);
    Procedure mnuToolbarClick(Sender: Tobject);
    Procedure mnuShowHintsClick(Sender: Tobject);
    Procedure mnuGotoMainWindowClick(Sender: Tobject);
    Procedure mnuStayOnTopClick(Sender: Tobject);
    Procedure mnuHelpClick(Sender: Tobject);
    Procedure mnuViewImagein2ndRadiologyWindowClick(Sender: Tobject);
    Procedure mnuImageReportClick(Sender: Tobject);
    Procedure mnuOpenClick(Sender: Tobject);
    Procedure PopupVImagePopup(Sender: Tobject);
    Procedure mnuImageInformationAdvancedClick(Sender: Tobject);
    Procedure mnuImageInformationClick(Sender: Tobject);
    Procedure Mag4Viewer1ListChange(Sender: Tobject);
    Procedure ImageListFilters1Click(Sender: Tobject);
    Procedure FormClose(Sender: Tobject; Var action: TCloseAction);
    Procedure mnuFont6Click(Sender: Tobject);
    Procedure mnuFont7Click(Sender: Tobject);
    Procedure mnuFont8Click(Sender: Tobject);
    Procedure mnuFont10Click(Sender: Tobject);
    Procedure mnuFont12Click(Sender: Tobject);
    Procedure mnuFontSizeClick(Sender: Tobject);
    Procedure Mag4Viewer1EndDock(Sender, Target: Tobject; x, y: Integer);
    Procedure mnuRefreshClick(Sender: Tobject);
    Procedure mnuViewerSettingsClick(Sender: Tobject);
    Procedure ResizeAllImages(Sender: Tobject);
    Procedure TimerReSizeTimer(Sender: Tobject);
    Procedure ResizetheAbstracts1Click(Sender: Tobject);
    Procedure Testrefreshone1Click(Sender: Tobject);
    Procedure Testrefresh1Click(Sender: Tobject);
    Procedure TESTUPDATE1Click(Sender: Tobject);
    Procedure TESTREFRESH2Click(Sender: Tobject);
    Procedure TESTREDRA1Click(Sender: Tobject);
    Procedure TESTSLDFJKS1Click(Sender: Tobject);
    Procedure TESTAUTOREDRAWTRUE1Click(Sender: Tobject);
    Procedure mnuImageSaveAsClick(Sender: Tobject);
    Procedure Mag4Viewer1Resize(Sender: Tobject);
    Procedure mnuCacheGroupClick(Sender: Tobject);
    Procedure NextImage2Click(Sender: Tobject);
    Procedure mnuNextClick(Sender: Tobject);
    Procedure mnuPrevClick(Sender: Tobject);
    Procedure mnuPopupMenuClick(Sender: Tobject);
    Procedure GoToMainForm1Click(Sender: Tobject);
    Procedure mnuAbsBiggerClick(Sender: Tobject);
    Procedure mnuAbsSmallerClick(Sender: Tobject);
    Procedure PrevViewerPage1Click(Sender: Tobject);
    Procedure NextPage1Click(Sender: Tobject);
    Procedure mnuRefresh1Click(Sender: Tobject);
    Procedure PagePrevViewerClick(Sender: Tobject);
    Procedure NextViewerPage1Click(Sender: Tobject);
    Procedure SmallerAbs1Click(Sender: Tobject);
    Procedure LargerAbs1Click(Sender: Tobject);
    Procedure PrevAbs1Click(Sender: Tobject);
    Procedure NextAbs1Click(Sender: Tobject);
    Procedure AcitveForms1Click(Sender: Tobject);
    Procedure Activewindows1Click(Sender: Tobject);
    Procedure FormKeyDown(Sender: Tobject; Var Key: Word;
      Shift: TShiftState);
    procedure mnuImageIndexEditClick(Sender: TObject);
  Private
    //FOnLogEvent : TMagLogEvent; {JK 10/5/2009 - Maggmsgu refactoring}
    Procedure AbsOpenSelectedImage(IObj: TImageData; RadCode: Integer);
    procedure IndexEdit;
    //procedure LogMsg(MsgType : String; Msg : String; Priority : TMagLogPriority = MagLogINFO); {JK 10/5/2009 - Maggmsgu refactoring - remove old method}
    //procedure setLogEvent(logEvent : TMagLogEvent); {JK 10/5/2009 - Maggmsgu refactoring - remove old method}
  Public
    FImageCountmsg: String;
    HoldResize: Boolean;
    Lastscroll: Integer;
    Procedure AbsWindowCaption;

    // need to use setLogEvent to set the logger for the Mag4Viewer
    //property OnLogEvent : TMagLogEvent read FOnLogEvent write setLogEvent; {JK 10/5/2009 - Maggmsgu refactoring}
  End;

Const
  Noresize: Boolean = False;
Var
  ThisIsAnXray: Boolean;
  FrmMagAbstracts: TfrmMagAbstracts;

Implementation
Uses
  cMag4Vgear,
  Dialogs,
  ImagDMinterface, //RCA  DmSingle,
  FmagAbsResize,
  FMagImageList,
  //fmagMain,
  //RCA  FmagSaveImageAs,
  ImagInterfaces,
  MagImageManager,
  Magpositions,
  SysUtils,
  UMagAppMgr,
  UMagDefinitions,
  Umagdisplaymgr,
//uMagDisplayUtils,
  Umagkeymgr,
  Umagutils8,
  umagUtils8A,
  WinTypes
  ;

//Uses Vetted 20090929:fMagImageInfo,
{$R *.DFM}

Procedure TfrmMagAbstracts.AbsWindowCaption;
Begin
  FrmMagAbstracts.caption := '  Abstracts : ' + idmodobj.GetMagPat1.M_NameDisplay;
End;

{JK 10/5/2009 - Maggmsgu refactoring - remove old method}
//procedure TfrmMagAbstracts.SetLogEvent(logEvent : TMagLogEvent);
//begin
//  FOnLogEvent := LogEvent;
//  Mag4Viewer1.OnLogEvent := OnLogEvent;
//end;

{JK 10/5/2009 - Maggmsgu refactoring - remove old method}
//procedure TfrmMagAbstracts.LogMsg(MsgType : String; Msg : String; Priority : TMagLogPriority = MagLogINFO);
//begin
//  if assigned(OnLogEvent) then
//    OnLogEvent(self, MsgType, Msg, Priority);
//end;

Procedure TfrmMagAbstracts.ResizeAllImages(Sender: Tobject);
Begin
  TimerReSize.Enabled := False;
  Application.Processmessages;
  TimerReSize.Enabled := True;
End;

Procedure TfrmMagAbstracts.TimerReSizeTimer(Sender: Tobject);
Begin
  TimerReSize.Enabled := False;
  Application.Processmessages;
  If Mag4Viewer1.UseAutoReAlign Then Mag4Viewer1.ReAlignImages;
End;

Procedure TfrmMagAbstracts.FormCreate(Sender: Tobject);
Begin
  Mag4Viewer1.Align := alClient;
  GetFormPosition(Self As TForm);
  Mag4Viewer1.MagImageList := Nil; {on create}
// not in 93  RIVAttachListener(self.fMagRemoteToolbar1);
End;

Procedure TfrmMagAbstracts.FormResize(Sender: Tobject);
Begin
 { it is set in Form OnPaint. Setting it there,
     stops the resize being called when the form is created.}
End;

Procedure TfrmMagAbstracts.FormPaint(Sender: Tobject);
Begin
// setting it here, stops the resize being called when the form is created.
  If Not Assigned(OnResize) Then OnResize := ResizeAllImages;
End;

Procedure TfrmMagAbstracts.FormDestroy(Sender: Tobject);
Begin
  SaveFormPosition(Self As TForm);
End;

Procedure TfrmMagAbstracts.Mag4Viewer1ViewerImageClick(Sender: Tobject);
Begin
  If Sender = Nil Then Exit;
  AbsOpenSelectedImage(TMag4VGear(Sender).PI_ptrData, 1); //, 0, 1, 0);
End;

Procedure TfrmMagAbstracts.AbsOpenSelectedImage(IObj: TImageData; RadCode: Integer);
Var
  Xmsg, Retmsg: String;
//viobj : TImageData;
  NewsObj: TMagNewsObject;
Begin
  Xmsg := FImageCountmsg;
  Try
    Screen.Cursor := crHourGlass;
    Update;
    FrmMagAbstracts.Enabled := False;
    Mag4Viewer1.StopLoadingImages := True;
  {   p8t35, show what is happening.}
    LbImagecount.caption := ' Loading ID# ' + IObj.Mag0 + '  ' + IObj.ImgDes + '...';
    LbImagecount.Update;
  //function OpenSelectedImage(IObj: TImageData; RightLeft: byte; Count, TotalCount, DemoGroup: integer; duplicate: boolean = false; UseRadViewer: boolean = false): string;

 // retmsg := OpenSelectedImage(Iobj, RadCode, 0, 1, 0,false,false,self.Mag4ViewerFull);
    Retmsg := OpenSelectedImage(IObj, RadCode, 0, 1, 0, False, False);

    If FSyncImageON Then {FSyncImageOn from  AbsOpenSelectedImage click}
    Begin
      // vIobj := Mag4Viewer1.GetCurrentImageObject;
      If IObj <> Nil Then
      Begin
        NewsObj := MakeNewsObject(MpubImageSelected, 0, IObj.Mag0, IObj, Mag4Viewer1);
      //logmsg('s','Publishing ImageSelect from Abstracts window');
      //p117 use ImsgObj  MagLogger.LogMsg('s', 'Publishing ImageSelect from Abstracts window'); {JK 10/6/2009 - Maggmsgu refactoring}
  magAppMsg('s','Publishing ImageSelect from Abstracts window',MagmsgDebug);  //p117
        FrmImageList.MagPublisher1.I_SetNews(NewsObj); //procedure AbsOpenSelectedImage
      End;
    End;

    If MagPiece(Retmsg, '^', 1) = '0' Then Xmsg := MagPiece(Retmsg, '^', 2);
  Finally
    LbImagecount.caption := Xmsg;
    FrmMagAbstracts.Enabled := True;
    Screen.Cursor := crDefault;
  End;
End;

Procedure TfrmMagAbstracts.mnuImageDeleteClick(Sender: Tobject);
Var
  IObj: TImageData;
  Rmsg: String;
  NeedsReview: Boolean;  {/ P122 T15 - JK 7/18/2012 /}
  NewsObj: TMagNewsObject;  {/ P122 T15 - JK 7/18/2012 /}
Begin
  IObj := TMag4VGear(PopupVImage.PopupComponent).PI_ptrData;
  If mnuImageDelete.Tag = -1 Then Exit;
  // JMW 6/24/2005 p45t3 compare based on server and port (more accurate)
  If (IObj.ServerName <> idmodobj.GetMagDBBroker1.GetServer) Or (IObj.ServerPort <> idmodobj.GetMagDBBroker1.GetListenerPort) Then
//  if (iobj.PlaceCode <> wrksplacecode) then    // JMW 3/2/2005 p45
  Begin
    //p117 use ImsgObj instead of showmessage
    MagAppMsg('','You cannot delete an image from a remote site');
    Exit;
  End;

//  frmMain.Winmsg('s', 'Attempting deletion of ' + Iobj.ffile + '  IEN ' + Iobj.Mag0);
  MagAppMsg('s', 'Attempting deletion of ' + IObj.FFile + '  IEN ' + IObj.Mag0);

  {p94t2 gek refactoring, decoupling fmagmain.}
 // frmMain.ImageDelete(Iobj);
 // LogActions('ABS', 'DELETE', Iobj.Mag0);
  If MgrImageDelete(IObj, Rmsg, NeedsReview) Then
    if NeedsReview then
    begin
      {/ P122 T15 - JK 7/18/2012 - added back in the messaging that was in CurrentImageStatusChange when it was in this unit /}
      //ShowQAReviewStatus(IObj, umagdefinitions.mistateNeedsRefresh, umagdefinitions.MistNeedsReview, rmsg, NeedsReview)
      {/ P122 T15 - JK 8/9/2012 /}
      If FSyncImageON Then {FSyncImageOn from  Mag4Viewer1 click}
      Begin
//        VIobj := Mag4Viewer1.GetCurrentImageObject;
        If Iobj <> Nil Then
        Begin
          NewsObj := MakeNewsObject(MpubImageNeedsReview, 0, IntToStr(Iobj.IGroupIEN), Iobj, Mag4Viewer1);
          MagAppMsg('s', 'TfrmMagAbstracts.mnuImageDeleteClick: Publishing "Image Needs Review" from Abstract window');
           {p94t3 gek 11/30/09  decouple frmimagelist,  create gblobal publisher GmagPublish}
           //frmImageList.MagPublisher1.I_SetNews(newsobj);
          GmagPublish.I_SetNews(NewsObj);
        End
      else
  Begin
    LogActions('ABS', 'DELETE', IObj.Mag0);
    { TODO -cpatch 94 : do we need here to update (sync) status of other image lists. tree, list etc }
        MagAppMsg('s', 'Delete Result: ' + Rmsg);
      End;
  End;
    end;
//  Begin
//    LogActions('ABS', 'DELETE', IObj.Mag0);
//    { TODO -cpatch 94 : do we need here to update (sync) status of other image lists. tree, list etc }
//  End;
  MagAppMsg('s', 'Delete Result: ' + Rmsg);
End;

procedure TfrmMagAbstracts.mnuImageIndexEditClick(Sender: TObject);
begin
  IndexEdit;
end;

procedure TfrmMagAbstracts.IndexEdit;
var
  vresult: boolean;
  i: integer;
  Iobj: TImageData;
  rmsg: string;
begin
(*
//Index Edit Not implemented in Abs window
*)
end;


Procedure TfrmMagAbstracts.mnuToolbarClick(Sender: Tobject);
Begin
  mnuToolbar.Checked := Not mnuToolbar.Checked;
  Mag4Viewer1.TbViewer.Visible := mnuToolbar.Checked;
  Self.Update;
  Mag4Viewer1.TbViewer.Update; {JK 4/21/2009 - needed to force the repaint}
End;

Procedure TfrmMagAbstracts.mnuShowHintsClick(Sender: Tobject);
Begin
  mnuShowHints.Checked := Not mnuShowHints.Checked;
  ShowHint := mnuShowHints.Checked;
End;

Procedure TfrmMagAbstracts.mnuGotoMainWindowClick(Sender: Tobject);
Begin
  Application.MainForm.SetFocus;
End;

Procedure TfrmMagAbstracts.mnuStayOnTopClick(Sender: Tobject);
Begin
  mnuStayOnTop.Checked := Not mnuStayOnTop.Checked;
  If mnuStayOnTop.Checked Then
    Formstyle := Fsstayontop
  Else
    Formstyle := FsNormal;
End;

Procedure TfrmMagAbstracts.mnuHelpClick(Sender: Tobject);
Begin
  Application.HelpContext(HelpContext);
End;

Procedure TfrmMagAbstracts.mnuViewImagein2ndRadiologyWindowClick(Sender: Tobject);
Begin
  AbsOpenSelectedImage(TMag4VGear(PopupVImage.PopupComponent).PI_ptrData, 2);
End;

Procedure TfrmMagAbstracts.mnuImageReportClick(Sender: Tobject);
Var
  IObj: TImageData;
  Rstat: Boolean;
  Rmsg: String;
Begin
  IObj := TMag4VGear(PopupVImage.PopupComponent).PI_ptrData;
  idmodobj.GetMagUtilsDB1.ImageReport(IObj, Rstat, Rmsg);
  LogActions('ABS', 'REPORT', IObj.Mag0);
End;

Procedure TfrmMagAbstracts.mnuOpenClick(Sender: Tobject);
Var
  VGear: TMag4VGear;
  Viewer: TMag4Viewer;
Begin
  VGear := TMag4VGear(PopupVImage.PopupComponent);
  Viewer := TMag4Viewer(VGear.Parent);
  If Viewer <> Nil Then AbsOpenSelectedImage(TMag4VGear(PopupVImage.PopupComponent).PI_ptrData, 1);
End;

Procedure TfrmMagAbstracts.PopupVImagePopup(Sender: Tobject);
Var
  IObj: TImageData;
  Wasimageclicked: Boolean;
  {//p117 gek. This menu wasn't modified for 'Deleted' images being in the window. Deleted Images in
               the abstract window/ Group window new in 117.}
  isDel : boolean;    {CodeCR710}
Begin
 //p117 out gek   MagLogger.LogMsg('s', '###popupVImagePopup'); {JK 10/6/2009 - Maggmsgu refactoring}
{ /p117  MagAppMsg('s','### ((test one))popupVImagePopup',MagMsgDEBUG); Message Interfaced Object.
                                                           This DOES display ? }

magAppMsg(magmsglvlDEBUG,'### popupVImagePopup');  {/p117 Message Interfaced Object.
          This doesn't display.  That's what we want here. }


{/p117 ------- Hide certain menu items ---------   }
{       that are not applicable this session due to user security keys.}
{/p117 gek 3-23-11 Moved from below.   Note:  'if ...TAG = -1' was old way.  KEYS used now.}
  mnuImageDelete.visible := (UserHasKey('MAG DELETE'));

  {not in 117, will need okay to change this. (Image Index Edit)
          ..will need documentation updates (screen shots), Test Scripts changed, re - tested }
 //mnuImageIndexEdit.Visible := (UserHasKey('MAG SYSTEM') or UserHasKey('MAG EDIT'));
  mnuImageIndexEdit.Visible  := false;

  mnuImageInformationAdvanced.visible := (UserHasKey('MAG SYSTEM'));

  {  PopUpmenu could be activated by the window or VGear Component
     so If not any current Image, in Viewer, then disable some menu options.}
  Wasimageclicked := (PopupVImage.PopupComponent Is TMag4VGear);
    if wasimageclicked then  {/p117 need to enable/disable menu items depending on Deleted image.}
    begin
    Iobj := TMag4Vgear(PopupVImage.PopupComponent).PI_ptrData;
    isdel := Iobj.IsImageDeleted;
    if not isdel then isdel := imagedeletedthissession(iobj,false);
    end;

  //deault to false.
  mnuViewImagein2ndRadiologyWindow.visible := false;

{ * -----------  menu items ---------- * }
{ the first set of menu items are visible and/or enabled depending on Keys, and Image properties}

  mnuOpen.Enabled := Wasimageclicked  and (not isDel);
 // moved below  mnuViewImagein2ndRadiologyWindow.Enabled := Wasimageclicked;
  mnuImageReport.Enabled := Wasimageclicked  and (not isDel);
  mnuImageDelete.Enabled := Wasimageclicked  and (not isDel);

 // --- 'SaveAs' was for Testing -- not intended for Site for use
 // mnuImageSaveAs.Visible := (Userhaskey('MAG EDIT'));
 // If mnuImageSaveAs.Visible Then mnuImageSaveAs.Enabled := Wasimageclicked and (not isDel);

  // --- 'Image Index Edit... --  is not in plan. not in design.
  // I will need the okay and time to activate this menu item in this window. It's  not in design.
  //  it'll need script changes and testing, and docuement changes.
  //Not in design:. mnuImageIndexEdit.Enabled := Wasimageclicked and (not isDel);

  mnuImageInformation.Enabled := Wasimageclicked;
  mnuImageInformationAdvanced.Enabled := Wasimageclicked;
  mnuCacheGroup.enabled := wasimageclicked and (not isDel);   {note : gek  - this is enabled for any image, not just groups.}


 { * -----------  menu items ---------- * }

  {
  ---------
  ImageListFilters1     ON
  ---------
  mnuRefresh            ON
  ResizetheAbstracts1   ON
  mnuOptions2           ON
  mnuViewerSettings     >> Not Used Always OFF
  ---------
  mnuFontSize           ON
  mnuToolbar            ON
  mnuShowHints          ON
  mnuStayOnTop          >> Not Used Always OFF
  ---------
  mnuGotoMainWindow     ON
  Activewindows1        ON
  mnuHelp               ON
  Testing1              >>  Always OFF
  }

  mnuShowHints.Checked := ShowHint;
  mnuToolbar.Checked := Mag4Viewer1.TbViewer.Visible;

  If Not Wasimageclicked Then Exit;

  {  p8t21  an idea is this =>  Iobj := Mag4Viewer1.GetCurrentImageObject;
      But menu items send VGear  so that wouldn't work See mnuOpenClick
      all menu items would need to be changed to be calling a function of the
      Mag4Viewer.   also because later when multiple images can be opened at
      same time, the specifiec VGear isn't necessary, (or Mag4Viewer could
      get it itself) }

 MagAppMsg('', '');

 if not isDel then
    mnuViewImagein2ndRadiologyWindow.Visible := (Not IObj.IsImageGroup) And IObj.IsRadImage;

  mnuImageDelete.caption := 'Image Delete...';
  If IObj.IsImageGroup Then
    mnuImageDelete.caption := 'Image Group Delete...';

  Application.Processmessages;
//p117  MagLogger.LogMsg('s', '### end popupVImagePopup'); {JK 10/6/2009 - Maggmsgu refactoring}
  MagAppMsg('s','### end popupVImagePopup',MagmsgDebug);  //p117


End;

Procedure TfrmMagAbstracts.mnuImageInformationAdvancedClick(Sender: Tobject);
Var
  IObj: TImageData;
Begin

  IObj := TMag4VGear(PopupVImage.PopupComponent).PI_ptrData;
  { advanced information for sysmanagers.}
  If mnuImageInformationAdvanced.Tag = -1 Then Exit;
  OpenImageInfoSys(IObj);
  LogActions('ABS', 'IMAGE INFO', IObj.Mag0);
End;

Procedure TfrmMagAbstracts.mnuImageInformationClick(Sender: Tobject);
Var
  IObj: TImageData;
  Sellist: Tlist;
  i: Integer;
Begin
  Sellist := Mag4Viewer1.GetSelectedImageList;
  For i := Sellist.Count - 1 Downto 0 Do
  Begin
    IObj := Sellist[i];
    ShowImageInformation(IObj);
  End;
End;

Procedure TfrmMagAbstracts.Mag4Viewer1ListChange(Sender: Tobject);
Begin
 {  This happens on each Item of the List Change.  toooo many.}
//caption :=  inttostr(Mag4Viewer1.GetImageCount)+' Abstracts: '+dmod.MagPat1.M_NameDisplay;
End;

Procedure TfrmMagAbstracts.ImageListFilters1Click(Sender: Tobject);
Begin
{TODO: change the GetFilter to a method of an object. not a procedure
of another form.  This kind of association is what we
     don't want, a form, shouldn't have to know about another form.}
  FrmImageList.GetFilter;
End;

Procedure TfrmMagAbstracts.FormClose(Sender: Tobject; Var action: TCloseAction);
Begin
  FrmImageList.TbtnAbstracts.Down := False;
  Self.LbImagecount.caption := '';
  Self.Mag4Viewer1.ClearViewer;
  If Self.Mag4Viewer1.MagImageList = Nil Then Exit;
  Self.Mag4Viewer1.MagImageList.Detach_(Self.Mag4Viewer1);
  //93 T 10 Tucson debug  setting to NIL .... not sure if we want to.
  Self.Mag4Viewer1.MagImageList := Nil;
// Action := cafree;
End;

Procedure TfrmMagAbstracts.mnuFont6Click(Sender: Tobject);
Begin
  Mag4Viewer1.ImageFontSize := 6;
End;

Procedure TfrmMagAbstracts.mnuFont7Click(Sender: Tobject);
Begin
  Mag4Viewer1.ImageFontSize := 7;
End;

Procedure TfrmMagAbstracts.mnuFont8Click(Sender: Tobject);
Begin
  Mag4Viewer1.ImageFontSize := 8;
End;

Procedure TfrmMagAbstracts.mnuFont10Click(Sender: Tobject);
Begin
  Mag4Viewer1.ImageFontSize := 10;
End;

Procedure TfrmMagAbstracts.mnuFont12Click(Sender: Tobject);
Begin
  Mag4Viewer1.ImageFontSize := 12;
End;

Procedure TfrmMagAbstracts.mnuFontSizeClick(Sender: Tobject);
Var
  i, Size: Integer;
Begin
 {    Check the submenu item that is relevant;}
  Size := Mag4Viewer1.ImageFontSize;
  For i := 0 To mnuFontSize.Count - 1 Do
    If mnuFontSize[i].Tag = Size Then
    Begin
      If Not (mnuFontSize[i].Checked) Then mnuFontSize[i].Checked := True;
    End
    Else
      If mnuFontSize[i].Checked Then mnuFontSize[i].Checked := False;
End;

Procedure TfrmMagAbstracts.Mag4Viewer1EndDock(Sender, Target: Tobject; x,
  y: Integer);
Begin
  Mag4Viewer1.FrameEndDock(Sender, Target, x, y);
End;

Procedure TfrmMagAbstracts.mnuRefreshClick(Sender: Tobject);
Begin
{debug94}
//p117 out MagLogger.LogMsg('s', '**--** - mnuRefreshClick - AbsPopup - about to refresh');
  MagAppMsg('s','**--** - mnuRefreshClick - AbsPopup - about to refresh');  //p117
  Mag4Viewer1.ReFreshImages();
End;

Procedure TfrmMagAbstracts.mnuViewerSettingsClick(Sender: Tobject);
Begin
  Mag4Viewer1.EditViewerSettings;
End;

Procedure TfrmMagAbstracts.ResizetheAbstracts1Click(Sender: Tobject);
Begin
  FrmAbsResize.Execute(Mag4Viewer1.GetCurrentImage, Mag4Viewer1, Top, Left);
End;

Procedure TfrmMagAbstracts.Testrefreshone1Click(Sender: Tobject);
Var
  VGear: TMag4VGear;
Begin
  VGear := Mag4Viewer1.GetCurrentImage;
//showmessage(magbooltostr(vgear.Gear1.autoredraw));
  // just testing message, from Test Menu
  MagAppMsg('d',Magbooltostr(VGear.AutoRedraw));
  //Showmessage(Magbooltostr(VGear.AutoRedraw));

End;

Procedure TfrmMagAbstracts.Testrefresh1Click(Sender: Tobject);
Var
  VGear: TMag4VGear;
Begin
  VGear := Mag4Viewer1.GetCurrentImage;
//vGear.Gear1.FitMethod := IG_DISPLAY_FIT_TO_WINDOW;
  VGear.FitToWindow();

End;

Procedure TfrmMagAbstracts.TESTUPDATE1Click(Sender: Tobject);
Var
  VGear: TMag4VGear;
Begin
  VGear := Mag4Viewer1.GetCurrentImage;
//vGear.Gear1.UpdateGUI := TRUE;
  VGear.SetUpdateGUI(True);

End;

Procedure TfrmMagAbstracts.TESTREFRESH2Click(Sender: Tobject);
Var
  VGear: TMag4VGear;
Begin
  VGear := Mag4Viewer1.GetCurrentImage;
//vGear.Gear1.Refresh;
  VGear.RefreshImage();

End;

Procedure TfrmMagAbstracts.TESTREDRA1Click(Sender: Tobject);
Var
  VGear: TMag4VGear;
Begin
  VGear := Mag4Viewer1.GetCurrentImage;
//vGear.Gear1.Redraw := TRUE;
  VGear.ReDrawImage();

End;

Procedure TfrmMagAbstracts.TESTSLDFJKS1Click(Sender: Tobject);
Var
  VGear: TMag4VGear;
Begin
  VGear := Mag4Viewer1.GetCurrentImage;
//vGear.Gear1.Update;
  VGear.Update();

End;

Procedure TfrmMagAbstracts.TESTAUTOREDRAWTRUE1Click(Sender: Tobject);
Var
  VGear: TMag4VGear;
Begin
  VGear := Mag4Viewer1.GetCurrentImage;
//vGear.Gear1.AutoRedraw := TRUE;
  VGear.AutoRedraw := True;

End;

Procedure TfrmMagAbstracts.mnuImageSaveAsClick(Sender: Tobject);
Var
  IObj: TImageData;
  Sellist: Tlist;
  i: Integer;
  Savedasfile: String;
Begin
  Savedasfile := '';
  Sellist := Mag4Viewer1.GetSelectedImageList;
  For i := Sellist.Count - 1 Downto 0 Do
  Begin
    IObj := Sellist[i];
   //RCA, not used.
       (* RCA But keep here for possible use later
      FrmSaveImageAs.Execute(IObj, Savedasfile);*)
  //if ImageSaveAs(Iobj,savedasfile) then //;
  End;
End;

Procedure TfrmMagAbstracts.Mag4Viewer1Resize(Sender: Tobject);
Begin
  Mag4Viewer1.Update;
End;

Procedure TfrmMagAbstracts.mnuCacheGroupClick(Sender: Tobject);
// JMW 4/19/2005 RIV p45
Var
  Temp: Tstringlist;
  IObj: TImageData;
  ConvertedList: TStrings;
Begin
  Temp := Tstringlist.Create;
  IObj := TMag4VGear(PopupVImage.PopupComponent).PI_ptrData;

  If IObj.IsImageGroup Then
  Begin
    Temp := Tstringlist.Create;
    Try
      Begin
        idmodobj.GetMagDBBroker1.RPMaggGroupImages(IObj, Temp);
        ConvertedList := MagImageManager1.ExtractGroupImages(IObj.FFile, IObj.GroupCount, Temp);
        If (ConvertedList = Nil) Or (ConvertedList.Count = 0) Then Exit; // JMW p46 9/5/06 bug fix for caching study twice
        MagImageManager1.StartCache(ConvertedList);

      End;
    Except
      On e: Exception Do
      Begin
              //maggmsgf.magmsg('s', 'Exception auto-caching group images. Error=[' + e.message + ']');
              //LogMsg('s', 'Exception auto-caching group images. Error=[' + e.message + ']');
    //p117    MagLogger.LogMsg('s', 'Exception auto-caching group images. Error=[' + e.Message + ']'); {JK 10/6/2009 - Maggmsgu refactoring}
  MagAppMsg('s','Exception auto-caching group images. Error=[' + e.Message + ']');  //p117

      End;
    End;
  End
  Else
  Begin
    ConvertedList := MagImageManager1.ExtractSingleImage(IObj);
    If (ConvertedList = Nil) Or (ConvertedList.Count = 0) Then Exit; // JMW p46 9/5/06 bug fix for caching study twice
    MagImageManager1.StartCache(ConvertedList);
  End;

End;

Procedure TfrmMagAbstracts.NextImage2Click(Sender: Tobject);
Begin
//mag4viewer1.
End;

Procedure TfrmMagAbstracts.mnuNextClick(Sender: Tobject);
Begin
  Mag4Viewer1.SelectNextImage;
End;

Procedure TfrmMagAbstracts.mnuPrevClick(Sender: Tobject);
Begin
  Mag4Viewer1.SelectNextImage(-1);
End;

Procedure TfrmMagAbstracts.mnuPopupMenuClick(Sender: Tobject);
Var
  Pt: TPoint;
Begin
  Pt.x := Mag4Viewer1.Left;
  Pt.y := Mag4Viewer1.Top;
  Pt := Mag4Viewer1.ClientToScreen(Pt);
  PopupVImage.PopupComponent := Mag4Viewer1.GetCurrentImage;
  PopupVImage.Popup(Pt.x, Pt.y);
End;

Procedure TfrmMagAbstracts.GoToMainForm1Click(Sender: Tobject);
Begin
  Application.MainForm.SetFocus;
End;

Procedure TfrmMagAbstracts.mnuAbsBiggerClick(Sender: Tobject);
Begin
  Mag4Viewer1.SetAbsBigger;
End;

Procedure TfrmMagAbstracts.mnuAbsSmallerClick(Sender: Tobject);
Begin
  Mag4Viewer1.SetAbsSmaller;
End;

Procedure TfrmMagAbstracts.PrevViewerPage1Click(Sender: Tobject);
Begin
  Mag4Viewer1.PagePrevViewerFocus;
End;

Procedure TfrmMagAbstracts.NextPage1Click(Sender: Tobject);
Begin
  Mag4Viewer1.PageNextViewerFocus;
End;

Procedure TfrmMagAbstracts.mnuRefresh1Click(Sender: Tobject);
Begin
  Mag4Viewer1.ReFreshImages();
End;

Procedure TfrmMagAbstracts.PagePrevViewerClick(Sender: Tobject);
Begin
  Mag4Viewer1.PagePrevViewerFocus;
End;

Procedure TfrmMagAbstracts.NextViewerPage1Click(Sender: Tobject);
Begin
  Mag4Viewer1.PageNextViewerFocus;
End;

Procedure TfrmMagAbstracts.SmallerAbs1Click(Sender: Tobject);
Begin
  Mag4Viewer1.SetAbsSmaller;
End;

Procedure TfrmMagAbstracts.LargerAbs1Click(Sender: Tobject);
Begin
  Mag4Viewer1.SetAbsBigger;
End;

Procedure TfrmMagAbstracts.PrevAbs1Click(Sender: Tobject);
Begin
  Mag4Viewer1.SelectNextImage(-1);
End;

Procedure TfrmMagAbstracts.NextAbs1Click(Sender: Tobject);
Begin
  Mag4Viewer1.SelectNextImage();
End;

Procedure TfrmMagAbstracts.AcitveForms1Click(Sender: Tobject);
Begin
  SwitchToForm;
End;

Procedure TfrmMagAbstracts.Activewindows1Click(Sender: Tobject);
Begin
  SwitchToForm;
End;

Procedure TfrmMagAbstracts.FormKeyDown(Sender: Tobject; Var Key: Word;
  Shift: TShiftState);
Var
  VGear: TMag4VGear;
Begin
  If Key = VK_Return Then
  Begin
    VGear := Mag4Viewer1.GetCurrentImage;
    If VGear <> Nil Then
      AbsOpenSelectedImage(VGear.PI_ptrData, 1);
    Exit;
  End;
  If Key = 33 Then //PageUp
  Begin
    Mag4Viewer1.PagePrevViewerFocus;
  End;
  If Key = 34 Then //PageUp
  Begin
    Mag4Viewer1.PageNextViewerFocus;
  End;
End;

End.
