Unit FmagDeleteImage;
   {
   Package: MAG - VistA Imaging
   WARNING: Per VHA Directive 10-93-142 this unit should not be modified.
   Date Created:
   Site Name: Silver Spring, OIFO
   Developers: Garrett Kirin
   Description: Prompts User to enter a reason for deletion of this image.
        As of Patch 8.  User is still only allowed to delete single images
        from the GUI.
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
        ;; a Class II medical device.  As such, it may not be changed
        ;; in any way.  Modifications to this software may result in an
        ;; adulterated medical device under 21CFR820, the use of which
        ;; is considered to be a violation of US Federal Statutes.
        ;; +---------------------------------------------------------------------------------------------------+

*)
{$DEFINE DELGRPPROTOTYPE}
Interface

Uses
  Buttons,
  Classes,
  cMag4Vgear,
  cmag4viewer,
  cMagImageList,
  ComCtrls,
  Controls,
  ExtCtrls,
  Forms,
  Menus,
  Stdctrls,
  UMagClasses,
  ImgList,
  ToolWin
  ;

//Uses Vetted 20090929:ImgList, umagdefinitions, ToolWin, AxCtrls, fmxutils, OleCtrls, trpcb, Graphics, Messages, WinProcs, umagkeymgr, magpositions, MagImageManager, dmSingle, umagutils, Dialogs, WinTypes, SysUtils

Type
  TfrmDeleteImage = Class(TForm)
    PnlControls: Tpanel;
    TabControl1: TTabControl;
    PnlImage: Tpanel;
    Memimageinfo: TMemo;
    PnlViewer: Tpanel;
    MagImageList1: TMagImageList;
    Splitter1: TSplitter;
    PopupMenu1: TPopupMenu;
    MnuToolbar: TMenuItem;
    ViewerSettings1: TMenuItem;
    PnlAbsDel: Tpanel;
    Mag4Vgear2: TMag4VGear;
    LbQI: Tlabel;
    PnlBottom: Tpanel;
    PnlReason: Tpanel;
    LblReason: Tlabel;
    btnOKDelete: TBitBtn;
    btnCancelDelete: TBitBtn;
    cboxReason: TComboBox;
    LbPrompt: Tlabel;
    ImageList1: TImageList;
    ToolBar1: TToolBar;
    TbtnReport: TToolButton;
    TbtnShowAbstracts: TToolButton;
    TbtnTXTfile: TToolButton;
    MnuMain: TMainMenu;
    File1: TMenuItem;
    MnuDelete: TMenuItem;
    N1: TMenuItem;
    MnuExit: TMenuItem;
    MnuOptions: TMenuItem;
    MnuShowReport: TMenuItem;
    MnuShowAbstracts: TMenuItem;
    MnuTXTFile: TMenuItem;
    MnuImageInformation: TMenuItem;
    MnuHelp: TMenuItem;
    MnuHelpDeleteWindow: TMenuItem;
    MnuClear: TMenuItem;
    N2: TMenuItem;
    TbInfo: TToolButton;
    Mag4Viewer1: TMag4Viewer;
    StatusBar1: TStatusBar;
    MnuWordWrap1: TMenuItem;
    N3: TMenuItem;
    Mag4Vgear1: TMag4VGear;
    Procedure FormShow(Sender: Tobject);
    Procedure btnOKDeleteClick(Sender: Tobject);
    Procedure cboxReasonChange(Sender: Tobject);
    Procedure TabControl1Change(Sender: Tobject);
    Procedure FormCreate(Sender: Tobject);
    Procedure FormDestroy(Sender: Tobject);
    Procedure TbtnReportClick(Sender: Tobject);
    Procedure TbtnShowAbstractsClick(Sender: Tobject);
    Procedure MnuToolbarClick(Sender: Tobject);
    Procedure ViewerSettings1Click(Sender: Tobject);
    Procedure TbtnTXTfileClick(Sender: Tobject);
    Procedure FormResize(Sender: Tobject);
    Procedure MnuHelpDeleteWindowClick(Sender: Tobject);
    Procedure MnuImageInformationClick(Sender: Tobject);
    Procedure TbInfoClick(Sender: Tobject);
    Procedure MnuClearClick(Sender: Tobject);
    Procedure MnuDeleteClick(Sender: Tobject);
    Procedure MnuExitClick(Sender: Tobject);
    Procedure MnuShowAbstractsClick(Sender: Tobject);
    Procedure MnuShowReportClick(Sender: Tobject);
    Procedure MnuTXTFileClick(Sender: Tobject);
    Procedure cboxReasonClick(Sender: Tobject);
    Procedure MnuOptionsClick(Sender: Tobject);
    Procedure MnuWordWrap1Click(Sender: Tobject);
  Private
    Fimageinfo: TStrings;
    DeleteReason: String;
    FReasonList: TStrings;
    XImageObj: TImageData;
    Function GetReasonCode(Reason: String): String;
    Procedure Loadreasons(Reaslist: TStrings);
    Procedure OpenAbstract;
    Procedure OpenFull;
    Procedure WinMsg(Code, Xmsg: String);
    Procedure OpenTextFile(IObj: TImageData);
    Function StripCrLf(s: String): String;
    Procedure ShowImageInformation;
    Procedure DeleteImage;
    Procedure ShowImageReport;
    Procedure ShowGroupAbs;
    Procedure OpenImagingDeleteHelp;
    { Private declarations }
  Public

    Function ConfirmDeletion(Var Rmsg: String; Rlist: TStrings; IObj: TImageData; Var Reason: String): Boolean;
  End;

Var
  FrmDeleteImage: TfrmDeleteImage;
Const
  Divider = '================================================';
Implementation
Uses
  Dialogs,
//  DmSingle,
  ImagDMinterface,
  MagImageManager,
  Magpositions,
  SysUtils,
//  u magdisplaymgr,
  Umagkeymgr,
  UMagDefinitions,
  Umagutils8,
  WinTypes
  ;

{$R *.DFM}

Function TfrmDeleteImage.ConfirmDeletion(Var Rmsg: String; Rlist: TStrings; IObj: TImageData; Var Reason: String): Boolean;
Var
  s: String;
  Rstat: Boolean;
  t: TStrings;
  TempIobj: TImageData;
//rmsg : string;
  TmpList: TStrings;
Begin
  TmpList := Tstringlist.Create;
  TempIobj := Nil;
  Try
    t := Tstringlist.Create;
    Result := False;
    If IObj.GroupCount > 1 Then
      If Not Userhaskey('MAG DELETE') Then // WAS MAG SYSTEM
      Begin
        Result := False;
        Rmsg := 'You don''t have the correct Security Keys to delete Image Groups.';
    //winmsg('1',rmsg);
        Exit;
      End;
    If IObj.QAMsg <> '' Then
    Begin
  //p94  gek, IENToTImageData function moved to magDBMVista
      TempIobj := idmodObj.GetMagDBMVista1.IENtoTImageData(IObj.Mag0, Rstat, Rmsg);
      If TempIobj = Nil Then Exit;
(*  93T8   make a call.  This code is copied elsewhere, make a call.  REfactoring.
    // this is the only place this function is used, should be replaced by a
    // new/different ImageInfo call - 4/21/2005
    dmod.MagDBBroker1.RPMaggImageInfo(rstat,s,t,Iobj.mag0,true);
    if not rstat then
      begin
        result := rstat;
        rmsg := s;
        exit;
      end;
  //  tempIobj :=  dmod.MagVUtils1.StringToIMageObj(s) ;
    tempIobj :=  tempIobj.StringToTImageData(s,dmod.MagDBBroker1.GetServer,dmod.MagDBBroker1.GetListenerPort);

*)

    End;
    With TfrmDeleteImage.Create(Application.MainForm) Do
    Begin
  //visible := true;
      XImageObj := IObj;
      If TempIobj <> Nil Then
      Begin
      // put the filenames into xImageObj
        s := XImageObj.QAMsg;
        XImageObj.MagAssign(TempIobj);
        XImageObj.QAMsg := s;

      End;

 // now moved to OnShow Mag4VGear1.LoadTheImage(Iobj,true);
      idmodObj.GetMagDBBroker1.RPMag4GetImageInfo(IObj, Fimageinfo);
      Memimageinfo.Lines.AddStrings(Fimageinfo);
      Memimageinfo.Lines.Add(Divider);
      idmodObj.GetMagDBBroker1.RPMaggReasonList(Rstat, Rmsg, TmpList, 'D');
      If Rstat Then
      Begin
        TmpList.Delete(0);
        Loadreasons(TmpList);
      End
      Else
        Exit;

      Showmodal;
      Reason := GetReasonCode(DeleteReason); //cboxReason.Text;
      Result := (ModalResult = MrOK);

      Free;
    End;
  Finally
    t.Free;
    TmpList.Free;
  End;
End;

Procedure TfrmDeleteImage.FormShow(Sender: Tobject);
//var oneimage, xmsg: string;
Begin
  DeleteReason := '';
  OpenAbstract;
End;

Procedure TfrmDeleteImage.OpenAbstract;
Var
  Oneimage, Xmsg: String;
  Imgct: Integer;
  Msghint: String;
Begin
  Mag4Vgear1.ClearImage;
  Oneimage := idModObj.GetMagVUtils1.ResolveAbstract(XImageObj, Msghint);
  Mag4Vgear1.ListIndex := -1;

  Imgct := XImageObj.GroupCount;
  If (Imgct > 1) Then
  Begin
    LbPrompt.caption := 'Delete this Study Group ( all ' + Inttostr(Imgct) + ' Images ) from Patient Record ?'
  End
  Else
  Begin
    LbPrompt.caption := 'Delete this Image from Patient Record ?';
  End;
  TbtnShowAbstracts.Visible := (Imgct > 1);
  MnuShowAbstracts.Visible := (Imgct > 1);
   // mag4viewer1.Visible := (imgct > 1);
   // mag4Viewer1.pnlTop.Caption := 'click Button to load abstracts';

  LbQI.Visible := (XImageObj.QAMsg <> '');
  If LbQI.Visible Then
  Begin
    LbQI.caption := 'Questionable Integrity: ' + StripCrLf(XImageObj.QAMsg);

    StatusBar1.Panels[0].Text := Inttostr(Imgct) + ' Images';
    StatusBar1.Panels[1].Text := StripCrLf(XImageObj.QAMsg);
  End;
  Mag4Vgear1.ImageDescription := XImageObj.ExpandedDescription;
  Mag4Vgear1.FontSize := 8;

  // we don't want to use a cached image because the entire group might not be cached...

  If Not idmodObj.GetMagFileSecurity.MagOpenSecurePath(Oneimage, Xmsg) {// was proxy.imagedata.AFile} Then
    Oneimage := idModObj.GetMagVUtils1.GetAppPath + '\bmp\AbsError.bmp'
  Else
    If Not FileExists(Oneimage) Then Oneimage := idModObj.GetMagVUtils1.GetAppPath + '\bmp\NotExist.bmp';

  Mag4Vgear1.LoadTheImage(Oneimage);
  If (Imgct > 1) Then
  Begin
    ShowGroupAbs;
    Mag4Viewer1.ColumnCount := 1;
    Mag4Viewer1.RowCount := 1;
    Mag4Viewer1.SetRowColCount(1, 1);
     // Mag4Viewer1.ReAlignImages;
  End;
  cboxReason.SetFocus;
  MagImageManager1.SafeCloseNetworkConnections();
//  dmod.MagFileSecurity.MagCloseSecurity(xmsg);
End;

Function TfrmDeleteImage.StripCrLf(s: String): String;
Var
  Del: String;
Begin
  Del := #13;
  While Pos(Del, s) > 0 Do
    s := Copy(s, 1, Pos(Del, s) - 1) + Copy(s, Pos(Del, s) + 1, 99999);
  Del := #10;
  While Pos(Del, s) > 0 Do
    s := Copy(s, 1, Pos(Del, s) - 1) + ' ' + Copy(s, Pos(Del, s) + 1, 99999);
  Result := s;
End;

Procedure TfrmDeleteImage.OpenFull;
Var
  Oneimage, Xmsg: String;
Begin
//exit;

  Mag4Vgear2.Visible := True;
 //mag4vgear2.AutoRedraw := true;
  Mag4Vgear2.ClearImage;
  //oneimage := dmod.MagVUtils1.ResolveAbstract(ximageobj);
  Oneimage := XImageObj.FFile;
  Mag4Vgear2.ListIndex := -1;

  Mag4Vgear2.ImageDescription := XImageObj.ExpandedDescription(False);
  Mag4Vgear2.FontSize := 10;
  If Not idmodObj.GetMagFileSecurity.MagOpenSecurePath(Oneimage, Xmsg) {// was proxy.imagedata.AFile} Then
    Oneimage := idModObj.GetMagVUtils1.GetAppPath + '\bmp\FullResFileOpenError.bmp'
  Else
    If Not FileExists(Oneimage) Then Oneimage := idModObj.GetMagVUtils1.GetAppPath + '\bmp\NotExist.bmp';

  Mag4Vgear2.LoadTheImage(Oneimage);
  cboxReason.SetFocus;
  If Not MagImageManager1.IsImageCurrentlyCaching() Then idmodObj.GetMagFileSecurity.MagCloseSecurity(Xmsg);

End;

Procedure TfrmDeleteImage.OpenImagingDeleteHelp;
Begin
  //executefile(apppath + '\ImagingDelete.hlp', '', '', SW_SHOW);
  Magexecutefile(AppPath + '\MAGIMAGEDELETE.HLP', '', '', SW_SHOW);

End;

Procedure TfrmDeleteImage.btnOKDeleteClick(Sender: Tobject);
Begin
  DeleteImage;
End;

Procedure TfrmDeleteImage.DeleteImage;
Begin
  If Length(cboxReason.Text) < 10 Then
  Begin
    Messagedlg('You need to enter a Reason for Deleting' + #13 + '(minimum 10 characters)', Mtconfirmation, [Mbok], 0);
    cboxReason.SetFocus;
  End
  Else
    ModalResult := MrOK;
End;

Procedure TfrmDeleteImage.cboxReasonChange(Sender: Tobject);
Begin
  DeleteReason := cboxReason.Text;
End;

Procedure TfrmDeleteImage.TabControl1Change(Sender: Tobject);
Begin
//FUTURE
  Case TabControl1.TabIndex Of
    0: OpenAbstract;
    1: OpenFull;
  End;
End;

Procedure TfrmDeleteImage.FormCreate(Sender: Tobject);
Begin
  FReasonList := Tstringlist.Create;
{$IFDEF DELGRPPROTOTYPE}
  //pnlControls.Visible := true;
  //pnlViewer.visible := true;
  //Mag4Viewer1.Visible := true;
  Mag4Viewer1.Top := PnlAbsDel.Height Div 2;
//  Mag4Viewer1.AbsWindow := true;
  Mag4Viewer1.ViewStyle := MagViewerViewAbs;
  Mag4Viewer1.RowCount := 1;
  Mag4Viewer1.ColumnCount := 1;
    {//p94t8   IgnoreBlocked images...  i.e. see the abstract.}
  { tested. Take out to see if it works ->   when out, the abs for a Group displayed the blocked canned Bitmap.}
  { The FIgnoreBlock property applies to Abstracts only , not full image.}
  Mag4Viewer1.FIgnoreBlock := true;

{$ENDIF}
  // comment.
  PnlImage.Align := alClient;
  //pnlViewer.Height := 1;
  Mag4Viewer1.Align := alClient;
  GetFormPosition(Self As TForm);
  Fimageinfo := Tstringlist.Create;
  // Hide Show Group Delete, and .TXT file dependant on MAG SYSTEM

  TbtnTXTfile.Visible := Userhaskey('MAG SYSTEM');
  MnuTXTFile.Visible := Userhaskey('MAG SYSTEM');
  TbtnShowAbstracts.Visible := Userhaskey('MAG SYSTEM');
  MnuShowAbstracts.Visible := Userhaskey('MAG SYSTEM');

  //p93t8  from ImageInfo frame;
  Mag4Vgear1.AbstractImage := False;
  Mag4Vgear1.ViewStyle := MagGearViewAbs;
  Mag4Vgear1.ImageViewState := MagGearImageViewAbs;
End;

Procedure TfrmDeleteImage.FormDestroy(Sender: Tobject);
Begin
  FReasonList.Free;
  SaveFormPosition(Self As TForm);
  Fimageinfo.Free;
  If Mag4Viewer1.GetImageCount > 0 Then Mag4Viewer1.ClearViewer;
End;

Procedure TfrmDeleteImage.TbtnReportClick(Sender: Tobject);
Begin
 //
  ShowImageReport;
End;

Procedure TfrmDeleteImage.ShowImageReport;
Var
  Rstat: Boolean;
  Rmsg: String;

Begin
  Memimageinfo.Lines.Add(Divider);
  Memimageinfo.Lines.Add('Image Report : ' + XImageObj.ExpandedDescription(False));
  idmodObj.GetMagUtilsDB1.ImageReport(XImageObj, Rstat, Rmsg, Memimageinfo, True);
  Memimageinfo.Lines.Add(Divider);

End;

Procedure TfrmDeleteImage.TbtnShowAbstractsClick(Sender: Tobject);
Begin
  ShowGroupAbs;
End;

Procedure TfrmDeleteImage.ShowGroupAbs;
Var
  Temp: Tstringlist;
Begin
  (*if pnlviewer.Height < 5 then
    begin
      height := height + 150;
      pnlviewer.height := 150; // := true;
    end; *)
  Temp := Tstringlist.Create;
  If Not Mag4Viewer1.Visible Then
  Begin
    Mag4Viewer1.Visible := True;
  End;
  Try
    idmodObj.GetMagDBBroker1.RPMaggGroupImages(XImageObj, Temp, True, '');   {/ P117 - JK 9/2/2010 /}
    WinMsg('', 'Image Group selected, accessing Group Images...');
    If Temp.Count = 1 Then WinMsg('s', MagPiece(Temp.Strings[0], '^', 2));
    idmodObj.GetMagDBBroker1.RPMaggQueImageGroup('A', XImageObj);
    If (Temp.Count = 0) Or (Temp.Count = 1) Then
    Begin
      WinMsg('D', 'ERROR: Accessing Group Images.  See VistA Error Log.');
      Screen.Cursor := crDefault;
      Exit;
    End;
    Temp.Delete(0);
    WinMsg('', 'Loading Abstracts to Viewer');
    Try
      MagImageList1.LoadGroupList(Temp, '', ''); //oot
      Application.Processmessages;

    Except
      On e: Exception Do
      Begin
        Showmessage('exception : ' + e.Message);
      End;
    End;
    WinMsg('', '');
    Mag4Viewer1.ReAlignImages;
  Finally
    Temp.Free;
  End;
End;

Procedure TfrmDeleteImage.WinMsg(Code, Xmsg: String);
Begin
  //
End;

Procedure TfrmDeleteImage.MnuToolbarClick(Sender: Tobject);
Begin
  MnuToolbar.Checked := Not MnuToolbar.Checked;
  Mag4Viewer1.ShowToolbar := MnuToolbar.Checked;
End;

Procedure TfrmDeleteImage.ViewerSettings1Click(Sender: Tobject);
Begin
//   RowColSize.execute(Mag4Viewer1);
  Mag4Viewer1.EditViewerSettings;
End;

Procedure TfrmDeleteImage.TbtnTXTfileClick(Sender: Tobject);
Begin
  OpenTextFile(XImageObj);
End;

Procedure TfrmDeleteImage.OpenTextFile(IObj: TImageData);
Var
  t: TStrings;
  Xmsg: String;
Begin
  t := Tstringlist.Create;
  Try
    MagImageManager1.GetImageTxtFileText(IObj, t, Xmsg); //94
    If t = Nil Then
    Begin
      Memimageinfo.Lines.Add(Xmsg);
      Exit;
    End;
    Memimageinfo.Lines.AddStrings(t);
    Memimageinfo.Lines.Add(Divider)
  Finally
    t.Free;
  End;
End;

Procedure TfrmDeleteImage.FormResize(Sender: Tobject);
Begin
  PnlReason.Left := ((PnlBottom.Width - PnlReason.Width) Div 2);
End;

Procedure TfrmDeleteImage.MnuHelpDeleteWindowClick(Sender: Tobject);
Begin
  OpenImagingDeleteHelp;
End;

Procedure TfrmDeleteImage.MnuImageInformationClick(Sender: Tobject);
Begin
  ShowImageInformation;
End;

Procedure TfrmDeleteImage.ShowImageInformation;
Begin
  Memimageinfo.Lines.AddStrings(Fimageinfo);
  Memimageinfo.Lines.Add(Divider);
End;

Procedure TfrmDeleteImage.TbInfoClick(Sender: Tobject);
Begin
  ShowImageInformation
End;

Procedure TfrmDeleteImage.MnuClearClick(Sender: Tobject);
Begin
  Memimageinfo.Lines.Clear;
End;

Procedure TfrmDeleteImage.MnuDeleteClick(Sender: Tobject);
Begin
  DeleteImage
End;

Procedure TfrmDeleteImage.MnuExitClick(Sender: Tobject);
Begin
  ModalResult := MrCancel;
End;

Procedure TfrmDeleteImage.MnuShowAbstractsClick(Sender: Tobject);
Begin
  ShowGroupAbs
End;

Procedure TfrmDeleteImage.MnuShowReportClick(Sender: Tobject);
Begin
  ShowImageReport
End;

Procedure TfrmDeleteImage.MnuTXTFileClick(Sender: Tobject);
Begin
  OpenTextFile(XImageObj);
End;

Procedure TfrmDeleteImage.cboxReasonClick(Sender: Tobject);
Begin
//winmsg('','Click  ' + magbooltostr(cboxReason.DroppedDown));
End;

Procedure TfrmDeleteImage.Loadreasons(Reaslist: TStrings);
Var
  i: Integer;
Begin
  FReasonList.Clear;
  cboxReason.Clear;
  FReasonList.Assign(Reaslist);
  For i := 0 To FReasonList.Count - 1 Do
  Begin
    cboxReason.Items.Add(MagPiece(Reaslist[i], '^', 2));
  End;
End;

Function TfrmDeleteImage.GetReasonCode(Reason: String): String;
Var
  i: Integer;
Begin
  Result := '';
  For i := 0 To FReasonList.Count - 1 Do
  Begin
    If Reason = MagPiece(FReasonList[i], '^', 2) Then
    Begin
     // p93 not sending the IEN^REASON now, the M code on other end expects a string,
     //  not ien^desc. Old code will file IEN^REASON as 1 piece, hence making 2 pieces in the DB.
     //result := FReasonList[i];
      Result := Reason;
      Break;
    End;
  End;
End;

Procedure TfrmDeleteImage.MnuOptionsClick(Sender: Tobject);
Begin
  MnuWordWrap1.Checked := Memimageinfo.Wordwrap;
End;

Procedure TfrmDeleteImage.MnuWordWrap1Click(Sender: Tobject);
Begin
//memimageinfo.WordWrap := mnuWordWrap1.Checked;
End;

End.
