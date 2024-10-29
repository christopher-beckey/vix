Unit MagLastImages;
   {
   Package: MAG - VistA Imaging
   WARNING: Per VHA Directive 10-93-142 this unit should not be modified.
   Date Created:
   Site Name: Silver Spring, OIFO
   Developers: Garrett Kirin
   Description: Imaging Capture : list of most recent patient images.
       used to verify images that have been recently captured.
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

Interface

Uses
  Buttons,
  Classes,
  cMagPat,
  ComCtrls,
  Controls,
  ExtCtrls,
  Forms,
  Graphics,
  Stdctrls,
  Imaginterfaces
  ;


Type
  TMagLastImagesForm = Class(TForm)
    LvLatest: TListView;
    Panel1: Tpanel;
    Label1: Tlabel;
    EMaxcount: TEdit;
    Label2: Tlabel;
    Panel2: Tpanel;
    cbStayOnTop: TCheckBox;
    bReload: TBitBtn;
    b50: TBitBtn;
    b100: TBitBtn;
    InfoPanel: Tpanel;
    pnlExtraMsg: TPanel;
    Procedure b50Click(Sender: Tobject);
    Procedure b100Click(Sender: Tobject);
    Procedure EMaxcountKeyDown(Sender: Tobject; Var Key: Word;
      Shift: TShiftState);
    Procedure bReloadClick(Sender: Tobject);
    Procedure LvLatestClick(Sender: Tobject);
    Procedure FormCreate(Sender: Tobject);
    Procedure cbStayOnTopClick(Sender: Tobject);
    Procedure LvLatestKeyDown(Sender: Tobject; Var Key: Word;
      Shift: TShiftState);
    Procedure FormDestroy(Sender: Tobject);
  Private
    FDFN: String;
    FPatientName: String;
    procedure WinAppMsg(MsgType: String; Msg: String; winpanel : Tpanel);


  Public
    Procedure PatientInfo(XMagPat: TMag4Pat);
    Procedure ClearPatient;
    Procedure ReLoadImageList;
    { p129 t 11  stop showing Messag Dialog, put extra message.}
    procedure ExtraWinAppMsg(Msg: String);
  End;

Var
  MagLastImagesForm: TMagLastImagesForm;
  Nilpanel: Tpanel;
Implementation
Uses
  Dialogs,
//RCA out  DmSingle,
ImagDMinterface, // RCA in
  FmagCapMain,
  MagBroker,
  UMagDefinitions,
  Magpositions,
  SysUtils,
  Umagutils8,
  Windows
  ;

{$R *.DFM}

Procedure TMagLastImagesForm.b50Click(Sender: Tobject);
Begin
  EMaxcount.Text := '50';
  EMaxcount.Update;
  ReLoadImageList;
End;

Procedure TMagLastImagesForm.b100Click(Sender: Tobject);
Begin
  EMaxcount.Text := '100';
  EMaxcount.Update;
  ReLoadImageList;
End;

Procedure TMagLastImagesForm.EMaxcountKeyDown(Sender: Tobject;
  Var Key: Word; Shift: TShiftState);
Begin
  If Key <> VK_Return Then Exit;
  Try
    ReLoadImageList;
  Except
    Begin
      Messagedlg('Invalid Integer', Mtconfirmation, [Mbok], 0);
      EMaxcount.SetFocus;
    End;
  End;
End;

Procedure TMagLastImagesForm.bReloadClick(Sender: Tobject);
Begin
  ReLoadImageList;
End;

Procedure TMagLastImagesForm.ReLoadImageList;
Var
  Max, i, j: Integer;
  Ts: Tstringlist;
Begin
  Try
    If (FDFN = '') Then
    Begin
      Messagedlg('You need to Select a Patient', Mtconfirmation, [Mbok], 0);
      Exit;
    End;
    Max := Strtoint(EMaxcount.Text);
  Except
    Begin
      Messagedlg('Invalid Integer', Mtconfirmation, [Mbok], 0);
      EMaxcount.SetFocus;
      Exit;
    End;
  End;
  Ts := Tstringlist.Create;
  Try
    RPMaggPatEachImage(FDFN, Inttostr(Max), Ts);
    If Ts.Count = 1 Then
    Begin
      If Ts.Strings[0] = '1^0' Then
        //maggmsgf.magmsg('', 'No Images on file for ' + FPatientName + '.', infopanel);
        WinAppMsg('', 'No Images on file for ' + FPatientName + '.', InfoPanel); 
      If MagPiece(Ts.Strings[0], '^', 1) = '0' Then
        //maggmsgf.magmsg('', 'ERROR:  Loading patient Images ' + magpiece(ts.strings[0], '^', 2), infopanel);
        WinAppMsg('', 'ERROR:  Loading patient Images ' + MagPiece(Ts.Strings[0], '^', 2), InfoPanel); 
      If MagPiece(Ts.Strings[0], '^', 1) = '' Then
      Begin
        //maggmsgf.magmsg('de', 'ERROR: Failed to access Images for ' + FPatientName + '. Broker Error, use ^XTER', infopanel);
        WinAppMsg('de', 'ERROR: Failed to access Images for ' + FPatientName + '. Broker Error, use ^XTER', InfoPanel); 
      End;
    End;

    If (Ts.Count < 2) Then Exit;
    LvLatest.Items.Clear;
    Ts.Delete(0);
    For j := 0 To Ts.Count - 1 Do
    Begin

      LvLatest.Items.Add;
      i := LvLatest.Items.Count - 1;
      LvLatest.Items[i].caption := MagPiece(Ts[j], '^', 4);
      LvLatest.Items[i].ImageIndex := 2;
      //    fsize := inttostr((getfilesize(addfile) div 1024)+1)+'KB';
      //          for j := 10-length(fsize) downto 0 do fsize := ' '+fsize;

      LvLatest.Items[i].SubItems.Add(MagPiece(Ts[j], '^', 7));
      LvLatest.Items[i].SubItems.Add(MagPiece(Ts[j], '^', 5));
      LvLatest.Items[i].SubItems.Add(MagPiece(Ts[j], '^', 8));
      // lv.items[i].subitems.add(formatdatetime('mm/dd/yy  h:mm am/pm',filedatetime(addfile))) ;
      LvLatest.Items[i].SubItems.Add(MagPiece(Ts[j], '^', 1));
      LvLatest.Items[i].SubItems.Add(MagPiece(Ts[j], '^', 2));

    End;

  Finally;
    Ts.Free;
  End;

End;


procedure TMagLastImagesForm.ExtraWinAppMsg( Msg: String);
begin
if not pnlExtraMsg.visible
 then   pnlExtraMsg.visible := true;
  begin
  pnlExtraMsg.Caption := msg ;
  end;
MagAppMsg('',msg);
end;


procedure TMagLastImagesForm.WinAppMsg(MsgType, Msg: String; winpanel: Tpanel);
begin
if winpanel <> nil  then
  begin
  winpanel.Caption := msg ;
  winpanel.Update;
  end;
MagAppMsg(msgType,msg);
end;

Procedure TMagLastImagesForm.LvLatestClick(Sender: Tobject);
Var
  Image, s: String;
  i: Integer;
  Selecteditem: TListItem;
  Magien: String;
Begin
  If LvLatest.Items.Count = 0 Then
  Begin
    If Messagedlg('Load Patient Images  ?', Mtconfirmation, [Mbok, Mbcancel], 0) = MrOK Then ReLoadImageList;
    ;
    Exit;
  End;
  If LvLatest.Selcount = 0 Then
  Begin
    //maggmsgf.magmsg('', 'Select an Image from the list', infopanel);
    WinAppMsg('', 'Select an Image from the list', InfoPanel); 
    Exit;
  End;
  Frmcapmain.GearClear;
  Frmcapmain.WinMsg('', '');
  Frmcapmain.mg1.UpdatePageView;
  Selecteditem := LvLatest.Selected;
  Magien := Selecteditem.SubItems[3];
  Image := Selecteditem.SubItems[4];
  Frmcapmain.WinMsg('', 'Retrieving : ' + Selecteditem.caption + '...');
  //maggmsgf.magmsg('', 'Retrieving : ' + selecteditem.caption + '...', infopanel);
  WinAppMsg('', 'Retrieving : ' + Selecteditem.caption + '...', InfoPanel); 
  If Not idmodobj.GetMagFileSecurity.MagOpenSecurePath(Image, s) Then
  Begin
    //maggmsgf.magmsg('', s, infopanel);
    WinAppMsg('', s, InfoPanel); 
    // 03/11/02 IR Elsie : connection not being closed
    //   The call MagCloseSecurity, was here, I added true, and took away second loop
    //    and moved the call up, infront of the first loop.
    idmodobj.GetMagFileSecurity.MagCloseSecurity(s, True);
    For i := 0 To idmodobj.GetMagFileSecurity.Msglist.Count - 1 Do
      //maggmsgf.magmsg('s', idmodobj.GetMagFileSecurity.Msglist[i], nilpanel);
      WinAppMsg('s', idmodobj.GetMagFileSecurity.Msglist[i], Nilpanel); 
    //  03/11/02 IR Elsie :  //dmod.MagFileSecurity.MagCloseSecurity(s,true);
    //  03/11/02 IR Elsie :  //for i := 0 to dmod.MagFileSecurity.MsgList.count - 1 do maggmsgf.magmsg('s', dmod.MagFileSecurity.Msglist[i], nilpanel);
    Exit;
  End;
  //
  If Not FileExists(Image) Then
  Begin
    //maggmsgf.magmsg('', 'File not found : ' + selecteditem.caption, frmCapMain.pmsg);
    WinAppMsg('', 'File not found : ' + Selecteditem.caption, Frmcapmain.Pmsg); 
    //maggmsgf.magmsg('s', 'File not found : ' + image + ' : ' + selecteditem.caption, nilpanel);
    WinAppMsg('s', 'File not found : ' + Image + ' : ' + Selecteditem.caption, Nilpanel); 
    //maggmsgf.magmsg('', 'File not found : ' + selecteditem.caption, infopanel);
    WinAppMsg('', 'File not found : ' + Selecteditem.caption, InfoPanel); 
    Frmcapmain.LoadGear(AppPath + '\BMP\FullResFileNotFound.BMP', Selecteditem.caption);
    idmodobj.GetMagFileSecurity.MagCloseSecurity(s);
    Exit;
  End;

  Screen.Cursor := crHourGlass;
  Try
    //SupportedFiles bmk

    If (Uppercase(ExtractFileExt(Image)) = '.AVI') Then
    Begin
      InfoPanel.caption := 'Loading .AVI Image.  Plese Wait...';
      InfoPanel.Font.Color := clRed;
      //maggmsgf.magmsg('E', 'Loading .AVI Image. Please Wait...', frmCapMain.pmsg);
      WinAppMsg('E', 'Loading .AVI Image. Please Wait...', Frmcapmain.Pmsg); 
      InfoPanel.Update;
      Screen.Cursor := crHourGlass;
      Application.Processmessages;
     (* 129 T 11   this code is pre 129.
      If Not FileExists(AppPath + '\cache\' + ExtractFileName(Image))
         Then Frmcapmain.CopyTheFile(Image, AppPath + '\cache');
         *)
      If Not FileExists(AppPath + '\cache\' + ExtractFileName(Image))
         Then Frmcapmain.CopyTheFile(Image, AppPath + '\cache');

         {for 129 and beyond, we can't Write to Apppath.  Need to use UserDir.temp}

      Frmcapmain.PlayPatVideoImage(AppPath + '\cache\' + ExtractFileName(Image), Selecteditem.caption, Magien);
      idmodobj.GetMagDBBroker1.RPMag3Logaction('IMG^' + FDFN + '^' + Magien);
      //maggmsgf.magmsg('', 'Displaying Patient Image : ' + selecteditem.caption, frmCapMain.pmsg); // fix
      WinAppMsg('', 'Displaying Patient Image : ' + Selecteditem.caption, Frmcapmain.Pmsg); // fix 
      //maggmsgf.magmsg('s', 'Image : ' + apppath + '\cache\' + extractfilename(image), frmCapMain.pmsg); // fix
      WinAppMsg('s', 'Image : ' + AppPath + '\cache\' + ExtractFileName(Image), Frmcapmain.Pmsg); // fix 
      InfoPanel.caption := Selecteditem.caption;
      InfoPanel.Font.Color := clBlack;
      Frmcapmain.Lbviewingimage.caption := Selecteditem.caption; // fix
    End
    Else
      If Frmcapmain.LoadGear(Image, Selecteditem.caption) Then {MagLastImages.frm}
      Begin
      //maggmsgf.magmsg('', 'Displaying Patient Image : ' + selecteditem.caption, frmCapMain.pmsg); // fix
        WinAppMsg('', 'Displaying Patient Image : ' + Selecteditem.caption, Frmcapmain.Pmsg); // fix 
        InfoPanel.caption := Selecteditem.caption;
        Frmcapmain.Lbviewingimage.caption := Selecteditem.caption; // fix
        Frmcapmain.FViewingLatestImage := True;
        idmodobj.GetMagDBBroker1.RPMag3Logaction('IMG^' + FDFN + '^' + Magien);
      End;

  Finally

    Screen.Cursor := crDefault;

    Frmcapmain.btnCapture.Enabled := False;
    Frmcapmain.btnCancelScan.Enabled := True;
    {SECURITY - disconnect from file server}
    Frmcapmain.LvImport1.Enabled := False;
    //STG1.ENABLED := FALSE;
    idmodobj.GetMagFileSecurity.MagCloseSecurity(s);
  End;
End;

Procedure TMagLastImagesForm.FormCreate(Sender: Tobject);
Begin
lvlatest.Align := alclient;
  Nilpanel := Nil;
  GetFormPosition(Self As TForm);
End;

Procedure TMagLastImagesForm.cbStayOnTopClick(Sender: Tobject);
Begin
  If cbStayOnTop.Checked Then
    MagLastImagesForm.Formstyle := Fsstayontop
  Else
    MagLastImagesForm.Formstyle := FsNormal;
End;

Procedure TMagLastImagesForm.ClearPatient;
Begin
  FDFN := '';
  FPatientName := '';
  LvLatest.Items.Clear;
  MagLastImagesForm.caption := 'Patient''s latest Images : ';
  InfoPanel.caption := '';
End;

Procedure TMagLastImagesForm.PatientInfo(XMagPat: TMag4Pat);
Begin
  MagLastImagesForm.caption := 'Patient''s latest Images : ' + XMagPat.M_NameDisplay;
  FDFN := XMagPat.M_DFN;
  FPatientName := XMagPat.M_NameDisplay;
  InfoPanel.caption := '';
End;

Procedure TMagLastImagesForm.LvLatestKeyDown(Sender: Tobject;
  Var Key: Word; Shift: TShiftState);
Begin
  If Key = VK_Return Then LvLatestClick(Self);
End;

Procedure TMagLastImagesForm.FormDestroy(Sender: Tobject);
Begin
  SaveFormPosition(Self As TForm);
End;

End.
