Unit FMagGroupAbs;
  {
   Package: MAG - VistA Imaging
 WARNING: Per VHA Directive 10-93-142 this unit should not be modified.
 Date Created:
 Site Name: Silver Spring, OIFO
 Developers: Garrett Kirin
 Description: Imageing Display Group Abstracts.  This form, displays abstracts of
 all images in the last selected Group.
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
        ;; a Class II medical device.  As such, it may not be changed
        ;; in any way.  Modifications to this software may result in an
        ;; adulterated medical device under 21CFR820, the use of which
        ;; is considered to be a violation of US Federal Statutes.
        ;; +---------------------------------------------------------------------------------------------------+
 
*)
//{$DEFINE PROTOTYPE PLAYER}
Interface

Uses
  Classes,
  cmag4viewer,
  cMagImageList,
  Controls,
  ExtCtrls,
  Forms,
  Menus,
  Stdctrls,
  UMagClasses
  ;

//Uses Vetted 20090929:AxCtrls, OleCtrls, fmxutils, ddeman, Trpcb, maggut1, fmagFullRes, Maggrptu, Buttons, Graphics, Messages, WinProcs, imaginterfaces, umagdefinitions, magResources, umagAppMgr, uMagKeyMgr, cMag4VGear, magpositions, umagutils, dmSingle, Dialogs, WinTypes, SysUtils

Type
  TfrmGroupAbs = Class(TForm)
    Pinfo: Tpanel;
    LbGroupDesc: Tlabel;
    MagImageList1: TMagImageList;
    PopupVImage: TPopupMenu;
    MnuOpen: TMenuItem;
    MnuViewImagein2ndRadiologyWindow: TMenuItem;
    MnuImageDelete: TMenuItem;
    MnuImageReport: TMenuItem;
    MnuImageInformation: TMenuItem;
    MnuImageInformationAdvanced: TMenuItem;
    MenuItem6: TMenuItem;
    MnuToolbar: TMenuItem;
    MnuShowHints: TMenuItem;
    MenuItem12: TMenuItem;
    MnuGotoMainWindow: TMenuItem;
    MnuStayOnTop: TMenuItem;
    MnuHelp: TMenuItem;
    MnuFontSize: TMenuItem;
    MnuFont7: TMenuItem;
    MnuFont8: TMenuItem;
    MnuFont10: TMenuItem;
    MnuFont12: TMenuItem;
    MnuFont6: TMenuItem;
    Mag4Viewer1: TMag4Viewer;
    MnuBrowsePlay: TMenuItem;
    Splitter1: TSplitter;
    Refresh1: TMenuItem;
    ViewerSettings1: TMenuItem;
    N1: TMenuItem;
    TimerReSize: TTimer;
    ResizetheAbstracts1: TMenuItem;
    MnuImageSaveAs: TMenuItem;
    MainMenu1: TMainMenu;
    MnuFile: TMenuItem;
    MnuExit: TMenuItem;
    MnuOptions: TMenuItem;
    PrevViewerPage1: TMenuItem;
    NextPage1: TMenuItem;
    MnuAbsSmaller: TMenuItem;
    MnuAbsBigger: TMenuItem;
    MnuPrev: TMenuItem;
    MnuNext: TMenuItem;
    MnuRefresh1: TMenuItem;
    MnuPopupMenu: TMenuItem;
    GoToMainForm1: TMenuItem;
    Options1: TMenuItem;
    PrevViewerPage2: TMenuItem;
    NextViewerPage1: TMenuItem;
    BiggerAbs1: TMenuItem;
    SmallerAbs1: TMenuItem;
    NextAbs1: TMenuItem;
    PrevAbs1: TMenuItem;
    ActiveForms1: TMenuItem;
    Activewindows1: TMenuItem;
    Testing1: TMenuItem;
    Procedure FormCreate(Sender: Tobject);
    Procedure MHideOtherClick(Sender: Tobject);
    Procedure Mag4Viewer1ViewerImageClick(Sender: Tobject);
    Procedure MnuOpenClick(Sender: Tobject);
    Procedure MnuImageDeleteClick(Sender: Tobject);
    Procedure PopupVImagePopup(Sender: Tobject);
    Procedure MnuImageReportClick(Sender: Tobject);
    Procedure MnuImageInformationClick(Sender: Tobject);
    Procedure MnuImageInformationAdvancedClick(Sender: Tobject);
    Procedure MnuToolbarClick(Sender: Tobject);
    Procedure MnuShowHintsClick(Sender: Tobject);
    Procedure MnuGotoMainWindowClick(Sender: Tobject);
    Procedure MnuStayOnTopClick(Sender: Tobject);
    Procedure MnuHelpClick(Sender: Tobject);
    Procedure MnuViewImagein2ndRadiologyWindowClick(Sender: Tobject);
    Procedure FormPaint(Sender: Tobject);
    Procedure Mag4Viewer1ListChange(Sender: Tobject);
    Procedure FormUnDock(Sender: Tobject; Client: TControl;
      NewTarget: TWinControl; Var Allow: Boolean);
    Procedure FormEndDock(Sender, Target: Tobject; x, y: Integer);
    Procedure MnuFont7Click(Sender: Tobject);
    Procedure MnuFont8Click(Sender: Tobject);
    Procedure MnuFont10Click(Sender: Tobject);
    Procedure MnuFont12Click(Sender: Tobject);
    Procedure MnuFont6Click(Sender: Tobject);
    Procedure MnuFontSizeClick(Sender: Tobject);
    Procedure Mag4Viewer1EndDock(Sender, Target: Tobject; x, y: Integer);
    Procedure FormClose(Sender: Tobject; Var action: TCloseAction);
    Procedure MnuBrowsePlayClick(Sender: Tobject);
    Procedure Refresh1Click(Sender: Tobject);
    Procedure ViewerSettings1Click(Sender: Tobject);
    Procedure ResizeAllImages(Sender: Tobject);
    Procedure TimerReSizeTimer(Sender: Tobject);
    Procedure ResizetheAbstracts1Click(Sender: Tobject);
    Procedure PrevViewerPage1Click(Sender: Tobject);
    Procedure NextPage1Click(Sender: Tobject);
    Procedure MnuAbsSmallerClick(Sender: Tobject);
    Procedure MnuAbsBiggerClick(Sender: Tobject);
    Procedure MnuPrevClick(Sender: Tobject);
    Procedure MnuNextClick(Sender: Tobject);
    Procedure GoToMainForm1Click(Sender: Tobject);
    Procedure MnuPopupMenuClick(Sender: Tobject);
    Procedure MnuRefresh1Click(Sender: Tobject);
    Procedure PrevViewerPage2Click(Sender: Tobject);
    Procedure NextViewerPage1Click(Sender: Tobject);
    Procedure SmallerAbs1Click(Sender: Tobject);
    Procedure BiggerAbs1Click(Sender: Tobject);
    Procedure PrevAbs1Click(Sender: Tobject);
    Procedure NextAbs1Click(Sender: Tobject);
    Procedure ActiveForms1Click(Sender: Tobject);
    Procedure Activewindows1Click(Sender: Tobject);
    Procedure Testing1Click(Sender: Tobject);
    Procedure FormKeyDown(Sender: Tobject; Var Key: Word;
      Shift: TShiftState);

  Private
    CurGroupImageCount: Integer;
//ref    FBrowsePlay: TMagBrowsePlay;
    Procedure GrpOpenSelectedImage(IObj: TImageData; RadCode, ListIndex: Integer);
    Procedure Disableabs;
  Public
    FWindowDesc: String;
    FGroupIEN: String;
    FStudyDesc: String; // holds the study description (without # of images)
    Procedure Enableabs;
    Procedure SetInfo(XCap, XWinDesc, XHint, Xien, XStudyDesc: String);
    Procedure ClearAll;
  End;

Var
  FrmGroupAbs: TfrmGroupAbs;
 // ThisIsAnXray: boolean;
 // grpabslist: tlist;
 // GroupPtrList: TList;
 // Sub: string;
 // j, k, Imno, ColInv: Integer;
 // ptrGroupimage: MagRecordPtr;
 // B: Byte;
 // Y: Word;
Implementation
Uses
  cMag4Vgear,
  Dialogs,
ImagDMinterface, //RCA  DmSingle,
  FmagAbsResize,
 // fmagImageList,
  //fmagMain,
  FmagRadViewer,
  ImagInterfaces,
  Magpositions,
  MagResources,
  SysUtils,
  UMagAppMgr,
  UMagDefinitions,
 // MaggMsgu, {/ P117 - JK 9/13/2010 /}

  Umagdisplaymgr,
//uMagDisplayUtils,
  Umagkeymgr,
  Umagutils8,
  umagutils8A,
  WinTypes
  ;

//Uses Vetted 20090929:fMagImageInfo,
{$R *.DFM}

Procedure TfrmGroupAbs.FormPaint(Sender: Tobject);
Begin
// setting it here, stops the resize being called when the form is created.
  If Not Assigned(OnResize) Then OnResize := ResizeAllImages;
End;

Procedure TfrmGroupAbs.ResizeAllImages(Sender: Tobject);
Begin
  TimerReSize.Enabled := False;
  Application.Processmessages;
  TimerReSize.Enabled := True;
 (*   // this may come back in some form.  If the count is small,
      //  don't wait for the timer, just call ReAlignImages.
 if CurGroupImageCount < 200 then
   begin
   Mag4Viewer1.RealignImages;
   EXIT;
   END; *)
End;

Procedure TfrmGroupAbs.TimerReSizeTimer(Sender: Tobject);
Begin
  TimerReSize.Enabled := False;
  Application.Processmessages;
  If Mag4Viewer1.UseAutoReAlign Then Mag4Viewer1.ReAlignImages;
End;

Procedure TfrmGroupAbs.FormCreate(Sender: Tobject);
Begin
  Mag4Viewer1.Align := alClient;
  GetFormPosition(Self As TForm);
End;

Procedure TfrmGroupAbs.Disableabs;
Begin
  Enabled := False;
End;

Procedure TfrmGroupAbs.Enableabs;
Begin
  Enabled := True;
End;

Procedure TfrmGroupAbs.MHideOtherClick(Sender: Tobject);
Begin
      //not in 93   frmMain.Hide;
End;

Procedure TfrmGroupAbs.Mag4Viewer1ViewerImageClick(Sender: Tobject);
Begin
  If Sender = Nil Then Exit;
  GrpOpenSelectedImage(TMag4VGear(Sender).PI_ptrData, 1, TMag4VGear(Sender).ListIndex);
End;

Procedure TfrmGroupAbs.GrpOpenSelectedImage(IObj: TImageData; RadCode, ListIndex: Integer);
Var
  Tl: Tlist;
  Xmsg, Retmsg: String;
  FirstImage: TImageData;
  CurViewer: TMag4Viewer;
  NewsObj: TMagNewsObject;
Begin
  {/ P117 - JK 9/7/2010 - Check if the image has been deleted /}
  if IObj.IsImageDeleted then
    MagAppMsg('DI', IObj.GetViewStatusMsg)
  else
  begin

    Try
      Mag4Viewer1.StopLoadingImages := True;
      Xmsg := FWindowDesc;
      Screen.Cursor := crHourGlass;
      FrmGroupAbs.Enabled := False;
      Update;
    // p8t35 show what is happening.
      LbGroupDesc.caption := ' Loading # ' + Inttostr(ListIndex + 1) + '  ID# ' + IObj.Mag0 + '...';
      LbGroupDesc.Update;

      If FSyncImageON Then {FSyncImageOn from  GrpOpenSelectedImage click}
      Begin
        // vIobj := Mag4Viewer1.GetCurrentImageObject;
        If IObj <> Nil Then
        Begin
          NewsObj := MakeNewsObject(MpubImageSelected, 0, IObj.Mag0, IObj, Mag4Viewer1);
          GmagPublish.I_SetNews(NewsObj); //procedure GrpOpenSelectedImage
        End;
      End;

      If IObj.IsRadImage Then
      Begin
        if (NOT UserHasKey('TEMP NO RESTRICT')) and (NOT GNoRestrictView) then          {p161}
                  If (RestrictView(IObj) = 1) Then Exit;
        Tl := Mag4Viewer1.GetImageObjectList;

        FirstImage := Tl[0];
        OpenRadiologyWindow();
        FrmRadViewer.Show();
        FrmRadViewer.MagViewerTB1.Invalidate;
        FrmRadViewer.MagViewerTB1.Update;
        FrmRadViewer.caption := 'Radiology Viewer: ' + IObj.PtName;
        Screen.Cursor := crHourGlass;
        FrmRadViewer.OpenStudy(FirstImage, Tl, FStudyDesc, RadCode, ListIndex);
        Screen.Cursor := crDefault;

      End
      Else
      Begin
        Retmsg := OpenSelectedImage(IObj, 1, 0, 1, 0);
        If MagPiece(Retmsg, '^', 1) = '0' Then Xmsg := MagPiece(Retmsg, '^', 2);
      End;
    Finally
      FrmGroupAbs.Enabled := True;
      Enableabs;
      Screen.Cursor := crDefault;
      LbGroupDesc.caption := Xmsg;
    End;
  end;
End;

Procedure TfrmGroupAbs.MnuOpenClick(Sender: Tobject);
Begin
  {/ P117 - JK 9/7/2010 - Check for if the image has been deleted /}
  if TMag4Vgear(PopupVImage.PopupComponent).PI_ptrData.IsImageDeleted then
  begin
    MagAppMsg('DI', TMag4Vgear(PopupVImage.PopupComponent).PI_ptrData.GetViewStatusMsg);
  end
  else
  begin
    GrpOpenSelectedImage(TMag4VGear(PopupVImage.PopupComponent).PI_ptrData, 1,
      TMag4VGear(PopupVImage.PopupComponent).ListIndex);
  end;
End;

Procedure TfrmGroupAbs.MnuImageDeleteClick(Sender: Tobject);
Var // VGear : Tmag4Vgear;
  IObj: TImageData;
  Rmsg: String;
  NeedsReview: Boolean;  {/ P122 T15 - JK 7/18/2012 /}
  NewsObj: TMagNewsObject;
Begin
  {/ P117 - JK 9/7/2010 - Check for if the image has been deleted /}
  if TMag4Vgear(PopupVImage.PopupComponent).PI_ptrData.IsImageDeleted then
  begin
    MagAppMsg('DI', TMag4Vgear(PopupVImage.PopupComponent).PI_ptrData.GetViewStatusMsg);
  end
  else
  begin
  //vGear :=TMag4Vgear(popupVImage.PopupComponent);
    IObj := TMag4VGear(PopupVImage.PopupComponent).PI_ptrData;
  //

    If MnuImageDelete.Tag = -1 Then Exit;
    // JMW 6/24/2005 p45t3 compare based on server and port (more accurate)
    If (IObj.ServerName <> idmodobj.GetMagDBBroker1.GetServer) Or (IObj.ServerPort <> idmodobj.GetMagDBBroker1.GetListenerPort) Then
  //  if (iobj.PlaceCode <> wrksplacecode) then    // JMW 3/2/2005 p45
    Begin
      Showmessage('You cannot delete an image from a remote site');
      Exit;
    End;

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
            MagAppMsg('s', 'TfrmGroupAbs.MnuImageDeleteClick: Publishing "Image Needs Review" from Group Abstract window');
             {p94t3 gek 11/30/09  decouple frmimagelist,  create gblobal publisher GmagPublish}
             //frmImageList.MagPublisher1.I_SetNews(newsobj);   //Mag4Viewer1ViewerImageClick
            GmagPublish.I_SetNews(NewsObj); //Mag4Viewer1ViewerImageClick
          End
        else
    Begin
         LogActions('ABS', 'DELETE', IObj.Mag0);
         { TODO -cpatch 94 : do we need here to update (sync) status of other image lists. tree, list etc }

          MagAppMsg('s', 'Delete Result: ' + Rmsg);
        End;
      End;
    end;
  end;
End;

Procedure TfrmGroupAbs.PopupVImagePopup(Sender: Tobject);
Var //VGear : Tmag4Vgear;
  IObj: TImageData;
  wasImageclicked: Boolean;
  {/p117 gek  changes for Deleted Image Placeholder.  enable/disable menu items.}
  isDel : boolean;     {CodeCR710}
Begin
isdel := false;
{$IFDEF PROTOTYPE PLAYER}
  MnuBrowsePlay.Visible := True;
{$ENDIF}
 // PopUpmenu could be activated by the window or VGear Component
 //   so If not any current Image, in Viewer, then disable some menu options.

 { ------- some menu items are visible based on security keys  ------ }
   MnuImageDelete.Visible := (Userhaskey('MAG DELETE'));
   MnuImageInformationAdvanced.Visible := (Userhaskey('MAG SYSTEM'));
  {  --- 'SaveAs' was for Testing -- not available for use  }
  // MnuImageSaveAs.Visible := (Userhaskey('MAG EDIT'));
 { --------------- }


  wasImageclicked := (PopupVImage.PopupComponent Is TMag4VGear);
  if wasimageclicked then
   begin
   IObj := TMag4VGear(PopupVImage.PopupComponent).PI_ptrData;
   magAppMsg('', '');
    {/p117 gek 3-23:24-11  deleted images now show in Group window.}
    isdel := Iobj.IsImageDeleted;
    if not isdel then isdel := imagedeletedthissession(iobj,false);
   end;

  //default to false
  MnuViewImagein2ndRadiologyWindow.visible := false;

{ ------ set menu option enabled/disabled ---------}
  MnuOpen.Enabled :=             wasImageclicked and (not isdel) ;
  MnuImageReport.Enabled :=      wasImageclicked and (not isdel) ;
  {this was a test option.  not available to sites.  It might have accidentally been turned
     on to some test sites }
  // MnuImageSaveAs.Enabled := wasImageclicked and (not isdel);
  MnuImageDelete.Enabled :=      wasImageclicked and (not isdel) ;
  MnuImageInformation.Enabled := wasImageclicked;
  MnuImageInformationAdvanced.Enabled := wasImageclicked;

  MnuShowHints.Checked := ShowHint;
  MnuToolbar.Checked := Mag4Viewer1.TbViewer.Visible;

  If Not wasImageclicked Then Exit;

//p117 gek already done above  MnuToolbar.Checked := Mag4Viewer1.TbViewer.Visible;
//p117 gek already done above   MnuShowHints.Checked := ShowHint;

//gek  mnuViewImagein2ndRadiologyWindow.visible := ((Iobj.Imgtype = 3) or (Iobj.ImgType = 100))  {JK 2/19/2009 - Fixes D83};
if not isdel then
  MnuViewImagein2ndRadiologyWindow.Visible := (not Iobj.IsImageGroup) and Iobj.IsRadImage;


  MnuImageDelete.caption := 'Image Delete...';
  If IObj.IsImageGroup Then
  Begin
    MnuImageDelete.caption := 'Image Group Delete...';
  End;

End;

Procedure TfrmGroupAbs.MnuImageReportClick(Sender: Tobject);
Var //VGear : Tmag4Vgear;
  IObj: TImageData;
  Rmsg: String;
  Rstat: Boolean;
Begin
//vGear :=TMag4Vgear(popupVImage.PopupComponent);
  IObj := TMag4VGear(PopupVImage.PopupComponent).PI_ptrData;
  idmodobj.GetMagUtilsDB1.ImageReport(IObj, Rstat, Rmsg);
  LogActions('ABS', 'REPORT', IObj.Mag0);
End;

Procedure TfrmGroupAbs.MnuImageInformationClick(Sender: Tobject);
Var
  VGear: TMag4VGear;
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

Procedure TfrmGroupAbs.MnuImageInformationAdvancedClick(Sender: Tobject);
Var
  IObj: TImageData;
Begin
  IObj := TMag4VGear(PopupVImage.PopupComponent).PI_ptrData;
  {    advanced information for sysmanagers.{}
  If MnuImageInformationAdvanced.Tag = -1 Then Exit;
  OpenImageInfoSys(IObj);
  LogActions('ABS', 'IMAGE INFO', IObj.Mag0);
End;

Procedure TfrmGroupAbs.MnuToolbarClick(Sender: Tobject);
Begin
  MnuToolbar.Checked := Not MnuToolbar.Checked;
  { not same as abs {}
  Mag4Viewer1.TbViewer.Visible := MnuToolbar.Checked;
End;

Procedure TfrmGroupAbs.MnuShowHintsClick(Sender: Tobject);
Begin
  MnuShowHints.Checked := Not MnuShowHints.Checked;
  ShowHint := MnuShowHints.Checked;
End;

Procedure TfrmGroupAbs.MnuGotoMainWindowClick(Sender: Tobject);
Begin
  Application.MainForm.SetFocus;
End;

Procedure TfrmGroupAbs.MnuStayOnTopClick(Sender: Tobject);
Begin
  MnuStayOnTop.Checked := Not MnuStayOnTop.Checked;
  If MnuStayOnTop.Checked Then
    Formstyle := Fsstayontop
  Else
    Formstyle := FsNormal;
End;

Procedure TfrmGroupAbs.MnuHelpClick(Sender: Tobject);
Begin
  Application.HelpContext(HelpContext);
End;

Procedure TfrmGroupAbs.MnuViewImagein2ndRadiologyWindowClick(Sender: Tobject);
Var
  IObj: TImageData;
  VGear: TMag4VGear;
  ListIndex: Integer;
  Tl: Tlist;
Begin
  {/ P117 - JK 9/7/2010 - Check for if the image has been deleted /}
  if TMag4Vgear(PopupVImage.PopupComponent).PI_ptrData.IsImageDeleted then
  begin
    MagAppMsg('DI', TMag4Vgear(PopupVImage.PopupComponent).PI_ptrData.GetViewStatusMsg);
  end
  else
  begin
    Disableabs;
    Try
      VGear := TMag4VGear(PopupVImage.PopupComponent);
      IObj := TMag4VGear(PopupVImage.PopupComponent).PI_ptrData;
    { listindex is the index of the TMag4Gear in the Viewers FProxylist of all
      images in the viewer.  In a GroupAbs Window.  The Viewer has all images
      from the group in the FProxyList, so it works out okay. (coincidentally)}
      ListIndex := VGear.ListIndex;
  // new call to send the list to Ruth's window
      If (IObj.ImgType = 3) Or (IObj.ImgType = 100) Then
      Begin
        If Upref.UseNewRadiologyWindow Then
          GrpOpenSelectedImage(IObj, 2, ListIndex);
      End;
    Finally
      Enableabs;
    End;
  end;
End;

Procedure TfrmGroupAbs.Mag4Viewer1ListChange(Sender: Tobject);
Begin
  caption := 'Group Abstracts: (' + Inttostr(Mag4Viewer1.GetImageCount) + ')' + idmodobj.GetMagPat1.M_NameDisplay;
  CurGroupImageCount := Mag4Viewer1.GetImageCount;
End;

Procedure TfrmGroupAbs.FormUnDock(Sender: Tobject; Client: TControl;
  NewTarget: TWinControl; Var Allow: Boolean);
Begin
  //showmessage('undock from Group window');
End;

Procedure TfrmGroupAbs.FormEndDock(Sender, Target: Tobject; x, y: Integer);
Begin
  Visible := True;
End;

Procedure TfrmGroupAbs.MnuFont6Click(Sender: Tobject);
Begin
  Mag4Viewer1.ImageFontSize := 6;
End;

Procedure TfrmGroupAbs.MnuFont7Click(Sender: Tobject);
Begin
  Mag4Viewer1.ImageFontSize := 7;
End;

Procedure TfrmGroupAbs.MnuFont8Click(Sender: Tobject);
Begin
  Mag4Viewer1.ImageFontSize := 8;
End;

Procedure TfrmGroupAbs.MnuFont10Click(Sender: Tobject);
Begin
  Mag4Viewer1.ImageFontSize := 10;
End;

Procedure TfrmGroupAbs.MnuFont12Click(Sender: Tobject);
Begin
  Mag4Viewer1.ImageFontSize := 12;
End;

Procedure TfrmGroupAbs.MnuFontSizeClick(Sender: Tobject);
Var
  i, Size: Integer;
Begin
// Check the submenu item that is relevant;
  Size := Mag4Viewer1.ImageFontSize;
  For i := 0 To MnuFontSize.Count - 1 Do
    If MnuFontSize[i].Tag = Size Then
    Begin
      If Not (MnuFontSize[i].Checked) Then MnuFontSize[i].Checked := True;
    End
    Else
      If MnuFontSize[i].Checked Then MnuFontSize[i].Checked := False;
End;

Procedure TfrmGroupAbs.Mag4Viewer1EndDock(Sender, Target: Tobject; x,
  y: Integer);
Begin
  Mag4Viewer1.FrameEndDock(Sender, Target, x, y);

End;

Procedure TfrmGroupAbs.FormClose(Sender: Tobject;
  Var action: TCloseAction);
Begin
  ClearAll;
 {  testing p8t35 inserted   action := cafree{}
 { caused problems, it is assumed opened by app in many places and design.}
 (* action := cafree; *)
End;

Procedure TfrmGroupAbs.ClearAll;
Begin
  MagImageList1.UpDate_('', Self);

  LbGroupDesc.caption := '';
  LbGroupDesc.Hint := '';
  FWindowDesc := '';
  FGroupIEN := '';
  caption := 'Group Abstracts: ';
End;

Procedure TfrmGroupAbs.MnuBrowsePlayClick(Sender: Tobject);
Begin
 {ref
  if Fbrowseplay = nil then
    begin
      Fbrowseplay := Tmagbrowseplay.create(self);
      Fbrowseplay.parent := self;
      Fbrowseplay.left := 0;
      Fbrowseplay.width := 200;
      Fbrowseplay.align := alleft;
      Fbrowseplay.visible := true;
      splitter1.Left := 201;
      splitter1.Width := 5;
    end;
  mnubrowsePlay.Checked := not mnubrowsePlay.Checked;
  if mnubrowsePlay.Checked then
    begin
      FBrowsePlay.visible := true;
      Fbrowseplay.LinkToImageList(magimagelist1);
    end
    else
    begin
      FBrowsePlay.StopPlay;
      FBrowseplay.visible := false;
    end;
 ref}
End;

Procedure TfrmGroupAbs.Refresh1Click(Sender: Tobject);
Begin
  Mag4Viewer1.ReFreshImages();
End;

Procedure TfrmGroupAbs.ViewerSettings1Click(Sender: Tobject);
Begin
  Mag4Viewer1.EditViewerSettings;
End;

Procedure TfrmGroupAbs.ResizetheAbstracts1Click(Sender: Tobject);
Begin
  FrmAbsResize.Execute(Mag4Viewer1.GetCurrentImage, Mag4Viewer1, Top, Left);
End;

Procedure TfrmGroupAbs.SetInfo(XCap, XWinDesc, XHint, Xien, XStudyDesc: String);
Begin
  If XCap <> '' Then caption := XCap;
  LbGroupDesc.caption := XWinDesc;
  If XHint <> '' Then
    LbGroupDesc.Hint := XHint
  Else
    LbGroupDesc.Hint := XWinDesc;
  FWindowDesc := XWinDesc;
  FGroupIEN := Xien;
  FStudyDesc := XStudyDesc;
  Update;
End;

Procedure TfrmGroupAbs.PrevViewerPage1Click(Sender: Tobject);
Begin
  Mag4Viewer1.PagePrevViewerFocus;
End;

Procedure TfrmGroupAbs.NextPage1Click(Sender: Tobject);
Begin
  Mag4Viewer1.PageNextViewerFocus;
End;

Procedure TfrmGroupAbs.MnuAbsSmallerClick(Sender: Tobject);
Begin
  Mag4Viewer1.SetAbsSmaller;
End;

Procedure TfrmGroupAbs.MnuAbsBiggerClick(Sender: Tobject);
Begin
  Mag4Viewer1.SetAbsBigger;
End;

Procedure TfrmGroupAbs.MnuPrevClick(Sender: Tobject);
Begin
  Mag4Viewer1.SelectNextImage(-1);
End;

Procedure TfrmGroupAbs.MnuNextClick(Sender: Tobject);
Begin
  Mag4Viewer1.SelectNextImage();
End;

Procedure TfrmGroupAbs.GoToMainForm1Click(Sender: Tobject);
Begin
  Application.MainForm.SetFocus;
End;

Procedure TfrmGroupAbs.MnuPopupMenuClick(Sender: Tobject);
Var
  Pt: TPoint;
Begin
  Pt.x := Mag4Viewer1.Left;
  Pt.y := Mag4Viewer1.Top;
  Pt := Mag4Viewer1.ClientToScreen(Pt);
  PopupVImage.PopupComponent := Mag4Viewer1.GetCurrentImage;
  PopupVImage.Popup(Pt.x, Pt.y);
End;

Procedure TfrmGroupAbs.MnuRefresh1Click(Sender: Tobject);
Begin
  Mag4Viewer1.ReFreshImages();
End;

Procedure TfrmGroupAbs.PrevViewerPage2Click(Sender: Tobject);
Begin
  Mag4Viewer1.PagePrevViewerFocus;
End;

Procedure TfrmGroupAbs.NextViewerPage1Click(Sender: Tobject);
Begin
  Mag4Viewer1.PageNextViewerFocus;
End;

Procedure TfrmGroupAbs.SmallerAbs1Click(Sender: Tobject);
Begin
  Mag4Viewer1.SetAbsSmaller;
End;

Procedure TfrmGroupAbs.BiggerAbs1Click(Sender: Tobject);
Begin
  Mag4Viewer1.SetAbsBigger;
End;

Procedure TfrmGroupAbs.PrevAbs1Click(Sender: Tobject);
Begin
  Mag4Viewer1.SelectNextImage(-1);
End;

Procedure TfrmGroupAbs.NextAbs1Click(Sender: Tobject);
Begin
  Mag4Viewer1.SelectNextImage();
End;

Procedure TfrmGroupAbs.ActiveForms1Click(Sender: Tobject);
Begin
  SwitchToForm;
End;

Procedure TfrmGroupAbs.Activewindows1Click(Sender: Tobject);
Begin
  SwitchToForm;
End;

Procedure TfrmGroupAbs.Testing1Click(Sender: Tobject);
Begin
  Mag4Viewer1.SelectNextImage();
End;

Procedure TfrmGroupAbs.FormKeyDown(Sender: Tobject; Var Key: Word;
  Shift: TShiftState);
Var
  VGear: TMag4VGear;
Begin
  If Key = VK_Return Then
  Begin
    VGear := Mag4Viewer1.GetCurrentImage;
    If VGear <> Nil Then
      GrpOpenSelectedImage(VGear.PI_ptrData, 1,
        VGear.ListIndex);
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
