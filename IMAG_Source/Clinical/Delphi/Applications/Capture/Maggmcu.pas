Unit Maggmcu;
   {
   Package: MAG - VistA Imaging
   WARNING: Per VHA Directive 10-93-142 this unit should not be modified.
   Date Created:
   Site Name: Silver Spring, OIFO
   Developers: Garrett Kirin
   Description: Imaging Medicine procedure Selection window.
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
  ExtCtrls,
  Forms,
  Menus,
  Messages,
  Stdctrls,
  Controls
  ;

//Uses Vetted 20090929:maggut1, maggplku, XWBUT1, Graphics, WinProcs, magguini, magpositions, MagBroker, trpcb, umagutils, IniFiles, Dialogs, Controls, WinTypes, SysUtils

Type
  TMAGGMCF = Class(TForm)
    Msg: Tpanel;
    Panel1: Tpanel;
    PatName: Tlabel;
    Label5: Tlabel;
    Label6: Tlabel;
    Psname: Tlabel;
    Mcdttm: Tlabel;
    Mcnew: Tlabel;
    Pscode: Tlabel;
    Label1: Tlabel;
    Panel2: Tpanel;
    Label2: Tlabel;
    Label3: Tlabel;
    ListBox1: TListBox;
    ListBox2: TListBox;
    MainMenu1: TMainMenu;
    File1: TMenuItem;
    Save1: TMenuItem;
    N1: TMenuItem;
    Exit1: TMenuItem;
    Options1: TMenuItem;
    ListAllPatientProcedures1: TMenuItem;
    ClearProcedureSelection1: TMenuItem;
    Panel3: Tpanel;
    Lbb2: TListBox;
    Newname: Tlabel;
    Button2: TButton;
    LBB1: TListBox;
    Panel4: Tpanel;
    bbOK: TBitBtn;
    bbCancel: TBitBtn;
    Button3: TButton;
    SbMagRpt: TSpeedButton;
    Mcien: Tlabel;
    Psien: Tlabel;
    DFN: Tlabel;
    DataString: Tlabel;
    ReLoadtheProcedureSubspecialtylist1: TMenuItem;
    ListPatientProcedures1: TMenuItem;
    bbNew: TBitBtn;
    Procnewdttm: TEdit;
    Procnewlabel: Tlabel;
    GroupBox1: TGroupBox;
    Rbnewproc: TRadioButton;
    Rblistproc: TRadioButton;
    bbHelp: TBitBtn;
    Button1: TButton;
    cbMakeProcStub: TCheckBox;
    Procedure Button2Click(Sender: Tobject);
    Procedure Button3Click(Sender: Tobject);
    Procedure BlistPatProcClick(Sender: Tobject);
    Procedure ListBox1KeyDown(Sender: Tobject; Var Key: Word;
      Shift: TShiftState);
    Procedure ProclistclearClick(Sender: Tobject);
    Procedure ListBox2Click(Sender: Tobject);
    Procedure FormShow(Sender: Tobject);
    Procedure FullProcedureName1Click(Sender: Tobject);
    Procedure bbOKClick(Sender: Tobject);
    Procedure bbNewClick(Sender: Tobject);
    Procedure Exit1Click(Sender: Tobject);
    Procedure ProcnewdttmKeyDown(Sender: Tobject; Var Key: Word;
      Shift: TShiftState);
    Procedure FormCreate(Sender: Tobject);
    Procedure Panel2Resize(Sender: Tobject);
    Procedure ListBox1DblClick(Sender: Tobject);
    Procedure ListBox2KeyDown(Sender: Tobject; Var Key: Word;
      Shift: TShiftState);
    Procedure ReLoadtheProcedureSubspecialtylist1Click(Sender: Tobject);
    Procedure ListPatientProcedures1Click(Sender: Tobject);
    Procedure ListBox1Click(Sender: Tobject);
    Procedure ListBox2DblClick(Sender: Tobject);
    Procedure Button1Click(Sender: Tobject);
    Procedure RbnewprocClick(Sender: Tobject);
    Procedure RblistprocClick(Sender: Tobject);
    Procedure FormClose(Sender: Tobject; Var action: TCloseAction);
    Procedure FormDestroy(Sender: Tobject);
    Procedure ProcnewdttmExit(Sender: Tobject);
    Procedure FormResize(Sender: Tobject);
    procedure bbHelpClick(Sender: TObject);
  Private
    Procedure WMMOVE(Var Message: TWMMOVE); Message WM_MOVE;
    Procedure WMGetMinMaxInfo(Var Message: TWMGetMinMaxInfo); Message WM_GetMinMaxInfo;
    Procedure RealignButtons;
    { Private declarations }
  Public
    Procedure Loadproc(Piece: Integer);
    Procedure ClearProc;
    Procedure ClearDttm;
    Procedure Newproctime;
    Procedure SetPatientName(XMagPat: TMag4Pat);
    Procedure LoadProcedures;
    { Public declarations }
  End;

Var
  MAGGMCF: TMAGGMCF;

Implementation
Uses

  Dialogs,
  Inifiles,
  MagBroker,
  Magguini,
  Magpositions,
  SysUtils,
  Trpcb,
  Umagutils8,
  WinTypes
  ;

{$R *.DFM}

Procedure TMAGGMCF.SetPatientName(XMagPat: TMag4Pat);
Begin
  DFN.caption := XMagPat.M_DFN;
  PatName.caption := XMagPat.M_NameDisplay;
  Newname.caption := 'newname';
End;

Procedure TMAGGMCF.Newproctime;
Var
  s: String;
Begin
  Mcnew.caption := '';
  Mcien.caption := '';
  Mcdttm.caption := '';
  s := Procnewdttm.Text;
  If s = '' Then Exit;
  If Uppercase(s) = 'T' Then s := 'N';
  XBROKERX.PARAM[0].PTYPE := LITERAL;
  XBROKERX.PARAM[0].Value := s;
  XBROKERX.REMOTEPROCEDURE := 'MAGG DTTM';
  XBROKERX.Call;
  s := XBROKERX.Results[0];
  If (s = '') Or (Copy(s, 1, 1) = '0') Then
  Begin
    Messagedlg(MagPiece(s, '^', 2), Mtconfirmation, [Mbok], 0);
    Exit;
  End;
  s := MagPiece(s, '^', 2);
  Procnewdttm.Text := s;

  If Maglength(s, ':') > 2 Then s := MagPiece(s, ':', 1) + ':' + MagPiece(s, ':', 2);

  Mcdttm.caption := s;
  Mcdttm.Update;
  {END OF CHNAGES TO FIX DATE WE SEND TO DHCP}

  {procnewdttm.text := '';}
  Mcnew.caption := 'New Procedure';
  {BitBtn1.setfocus ; }
  {ddatien := s ;}
End;

Procedure ClearAll;
Begin
  With MAGGMCF Do
  Begin
    PatName.caption := '';
    DFN.caption := '';
    ClearProc;
    ClearDttm;
  End;
End;

Procedure TMAGGMCF.ClearProc;
Begin
  ListBox2.Clear;
  Lbb2.Clear;
  Pscode.caption := '';
  Psname.caption := '';
  Psien.caption := '';
End;

Procedure TMAGGMCF.ClearDttm;
Begin
  Mcdttm.caption := '';
  Mcien.caption := '';
  Mcnew.caption := '';
  Procnewdttm.Clear;
End;

Procedure TMAGGMCF.Loadproc(Piece: Integer);
Var
  i: Integer;
Begin
  If ListBox1.Items.Count > 0 Then Exit;
  ClearProc;
  ClearDttm;
  LBB1.Clear;
  ListBox1.Clear;
  XBROKERX.PARAM[0].Value := 'x';
  XBROKERX.PARAM[0].PTYPE := LITERAL;
  XBROKERX.REMOTEPROCEDURE := 'MAGGLISTPROC';
  XBROKERX.LstCALL(LBB1.Items);
  For i := 0 To LBB1.Items.Count - 1 Do
    ListBox1.Items.Add(MagPiece(LBB1.Items[i], '^', Piece));
  {EXCEPT
  on  E: EGPFault do
     SHOWMESSAGE('ERROR Attempting to Access Procedure list' + '.'+ e.message);
     else  SHOWMESSAGE('ERROR other than GPF');
  end; }
End;

Procedure TMAGGMCF.Button2Click(Sender: Tobject);
Begin
  (*proclistclearClick(self);
  Maggplkf.FScreen := 'I $D(^MCAR(690,Y))' ;
  Maggplkf.showmodal;
  if maggplkf.modalresult = mrCancel then begin
                            msg.caption := 'Lookup Canceled by user';
                            exit;
                            end;
  PatName.caption := maggplkf.patname.caption;
  DFN.caption := MAGPIECE(MAGGPLKF.PATDFN.CAPTION,'^',1);
  msg.caption := '';
  *)
End;

Procedure TMAGGMCF.Button3Click(Sender: Tobject);
Begin
  (*proclistclearClick(self);
  Maggplkf.showmodal;
  if maggplkf.modalresult = mrCancel then begin
                            Msg.caption := 'Patient lookup canceled by user';
                            exit;
                            end;
  PatName.caption := maggplkf.patname.caption;
  DFN.CAPTION := MAGPIECE(MAGGPLKF.PATDFN.CAPTION,'^',1);
  *)
End;

Procedure TMAGGMCF.BlistPatProcClick(Sender: Tobject);
Var
  s: String;
  i: Integer;
  Ts: Tstringlist;
Begin
  ListBox2.Clear;
  Lbb2.Clear;
  Mcdttm.caption := '';
  Mcien.caption := '';
  Mcnew.caption := '';
  If DFN.caption = '' Then
  Begin
    Msg.caption := 'You need to Select a Patient';
    Exit;
  End;

  If ListBox1.ItemIndex = -1 Then
  Begin
    Msg.caption := 'Need to Select a Procedure';
    Exit;
  End;
  s := MagPiece(LBB1.Items[ListBox1.ItemIndex], '^', 4) + '^' + DFN.caption;
  Pscode.caption := MagPiece(LBB1.Items[ListBox1.ItemIndex], '^', 1);
  Psname.caption := MagPiece(LBB1.Items[ListBox1.ItemIndex], '^', 2);
  Psien.caption := MagPiece(LBB1.Items[ListBox1.ItemIndex], '^', 4);

  Ts := Tstringlist.Create;
  Try
    XBROKERX.PARAM[0].Value := s;
    XBROKERX.PARAM[0].PTYPE := LITERAL;
    XBROKERX.REMOTEPROCEDURE := 'MAGGPATPROC';
    XBROKERX.LstCALL(Ts);

    Msg.caption := MagPiece(Ts.Strings[0], '^', 2);
    Ts.Delete(0);
    Lbb2.Clear;
    ListBox2.Clear;
    If Ts.Count > 0 Then
    Begin
      Lbb2.Items := Ts;
      For i := 0 To Lbb2.Items.Count - 1 Do
        ListBox2.Items.Add(MagPiece(Lbb2.Items[i], '^', 1));
    End; {listbox1.items := ts; }
    {if ts.count >0 then  lbb2.items := ts;}{??????}
  Finally
    Ts.Free;
  End; {try}
End;

Procedure TMAGGMCF.ListBox1KeyDown(Sender: Tobject; Var Key: Word;
  Shift: TShiftState);
Begin
  If Not (Key = VK_Return) Then Exit;
  If ListBox1.ItemIndex = -1 Then
  Begin
    Msg.caption := 'Select an entry from the Procedure/Subspecialty list';
    Msg.Update;
    Exit;
  End;
  ListBox1DblClick(Self);
End;

Procedure TMAGGMCF.ProclistclearClick(Sender: Tobject);
Begin
  ListBox1.ItemIndex := -1;
  ClearProc;
  ClearDttm;
End;

Procedure TMAGGMCF.ListBox2Click(Sender: Tobject);
Begin
  Mcdttm.caption := MagPiece(Lbb2.Items[ListBox2.ItemIndex], '^', 1);
  Mcien.caption := MagPiece(Lbb2.Items[ListBox2.ItemIndex], '^', 5);
  Mcnew.caption := '';
  Procnewdttm.Text := '';
End;

Procedure TMAGGMCF.FormShow(Sender: Tobject);
Begin
  If Newname.caption = 'newname' Then
  Begin
    Newname.caption := '';
    ClearProc;
    ClearDttm;
    Loadproc(1);
    Exit;
  End;
  ListBox1.SetFocus;
  If ListBox1.ItemIndex > -1 Then ListBox1.Topindex := ListBox1.ItemIndex;
  ClearDttm;
  {clearall;
  loadproc(1); }{gek 3/27/97 only clear if new patient}
End;

Procedure TMAGGMCF.FullProcedureName1Click(Sender: Tobject);
Begin
  Loadproc(2);
End;

Procedure TMAGGMCF.bbOKClick(Sender: Tobject);
Var
  s, x: String;
Begin
  x := '';
  If DFN.caption = '' Then x := x + '? Patient ';
  If Psien.caption = '' Then x := x + '? Procedure/Subspecialty ';
  If (Mcien.caption = '') And (Mcnew.caption = '') Then x := x + '? Date/Time';
  If Not (x = '') Then
  Begin
    Msg.caption := x;
    Messagebeep(0);
    Exit;
  End;
  { gek new med 6/03/97 }
  If (Mcien.caption = '') And (Mcnew.caption <> '') Then
    If (cbMakeProcStub.Enabled And cbMakeProcStub.Checked) Then
    Begin
      Msg.caption := 'Creating NEW Procedure in Medicine package...';
      Msg.Update;
      XBROKERX.PARAM[0].Value := Mcdttm.caption + '^' + Psien.caption + '^' + DFN.caption + '^';
      XBROKERX.PARAM[0].PTYPE := LITERAL;
      XBROKERX.REMOTEPROCEDURE := 'MAGG MED NEW';
      s := XBROKERX.STRCALL;
      If MagPiece(s, '^', 1) = '0' Then
      Begin
        Mcien.caption := '';
        Msg.caption := 'New Procdure stub not created : ' + MagPiece(s, '^', 2);
        Messagebeep(0);
        Exit;
      End;
      If MagPiece(s, '^', 1) <> '0' Then Mcien.caption := MagPiece(s, '^', 1);
      {      ELSE MCIEN.CAPTION := '';}
    End; { end of NEW GEK 6/3/97}
  DataString.caption := Mcdttm.caption + '^' + Psien.caption + '^'
    + DFN.caption + '^' + Mcien.caption + '^' + Pscode.caption;
  DataString.Update;

  ModalResult := MrOK;
End;

procedure TMAGGMCF.bbHelpClick(Sender: TObject);
begin
  Application.HelpContext(10123);
end;

Procedure TMAGGMCF.bbNewClick(Sender: Tobject);
Begin
  Procnewdttm.Show;
  Procnewlabel.Show;
  Procnewdttm.Text := 'N';
  Newproctime;
  If ListBox1.ItemIndex = -1 Then
  Begin
    Messagebeep(0);
    Msg.caption := 'Select a Procedure/Subspecialty';
    Msg.Update;
  End;
  Pscode.caption := MagPiece(LBB1.Items[ListBox1.ItemIndex], '^', 1);
  Psname.caption := MagPiece(LBB1.Items[ListBox1.ItemIndex], '^', 2);
  Psien.caption := MagPiece(LBB1.Items[ListBox1.ItemIndex], '^', 4);
End;

Procedure TMAGGMCF.Exit1Click(Sender: Tobject);
Begin
  ModalResult := MrCancel;
End;

Procedure TMAGGMCF.ProcnewdttmKeyDown(Sender: Tobject; Var Key: Word;
  Shift: TShiftState);
Begin
  If Key <> VK_Return Then Exit;
  If Not (Procnewdttm.Text = '') Then Newproctime;
End;

Procedure TMAGGMCF.FormCreate(Sender: Tobject);
Begin
  If (Not Rbnewproc.Checked) And (Not Rblistproc.Checked) Then
    Rbnewproc.Checked := True;
  Height := Trunc(477 * (Pixelsperinch / 96));
  Width := Trunc(613 * (Pixelsperinch / 96));
  GetFormPosition(Self As TForm);
End;

Procedure TMAGGMCF.Panel2Resize(Sender: Tobject);
Begin
  ListBox1.Height := Panel2.Height - ListBox1.Top - 20;
  ListBox2.Height := Panel2.Height - ListBox2.Top - 20;
  ListBox2.Width := Panel2.Width - ListBox2.Left - 12;
End;

Procedure TMAGGMCF.ListBox1DblClick(Sender: Tobject);
Begin
  ClearProc;
  {cleardttm;}{12/19/97}
  If Rbnewproc.Checked Then
  Begin
    Pscode.caption := MagPiece(LBB1.Items[ListBox1.ItemIndex], '^', 1);
    Psname.caption := MagPiece(LBB1.Items[ListBox1.ItemIndex], '^', 2);
    Psien.caption := MagPiece(LBB1.Items[ListBox1.ItemIndex], '^', 4);
    If Mcdttm.caption = '' Then bbNew.Click;
    bbOK.Click;
    Exit;
  End;
  LoadProcedures;
End;

Procedure TMAGGMCF.LoadProcedures;
Var
  Ts: Tstringlist;
  s, St, S1, S2, S3, S4, Sp: String;
  i: Integer;
Begin
  ClearProc;
  ClearDttm;
  If DFN.caption = '' Then
  Begin
    Msg.caption := 'You need to Select a Patient';
    Exit;
  End;

  If ListBox1.ItemIndex = -1 Then
  Begin
    Msg.caption := 'You need to Select a Procedure/Subspecialty';
    Exit;
  End;

  s := MagPiece(LBB1.Items[ListBox1.ItemIndex], '^', 4) + '^' + DFN.caption;
  Pscode.caption := MagPiece(LBB1.Items[ListBox1.ItemIndex], '^', 1);
  Psname.caption := MagPiece(LBB1.Items[ListBox1.ItemIndex], '^', 2);
  Psien.caption := MagPiece(LBB1.Items[ListBox1.ItemIndex], '^', 4);
  Ts := Tstringlist.Create;
  Try
    Screen.Cursor := crHourGlass;
    Msg.caption := 'Searching for procedures...';
    Msg.Update;
    XBROKERX.PARAM[0].Value := s;
    XBROKERX.PARAM[0].PTYPE := LITERAL;
    XBROKERX.REMOTEPROCEDURE := 'MAGGPATPROC';
    XBROKERX.LstCALL(Ts);

    Screen.Cursor := crDefault;
    Msg.caption := MagPiece(Ts.Strings[0], '^', 2);
    Msg.Update;
    Ts.Delete(0);
    Lbb2.Clear;
    ListBox2.Clear;
    If Ts.Count > 0 Then
    Begin
      Lbb2.Items := Ts;
      For i := 0 To Lbb2.Items.Count - 1 Do
      Begin
        Sp := '                           ';
        S4 := '  ';
        If Strtoint(MagPiece(Lbb2.Items[i], '^', 6)) > 0 Then S4 := '* ';
        S1 := MagPiece(Lbb2.Items[i], '^', 1);
        S2 := MagPiece(Lbb2.Items[i], '^', 2);
        S3 := MagPiece(Lbb2.Items[i], '^', 3);
        St := S1 + Copy(Sp, 1, 25 - Length(S1))
          + S4 + S2 + Copy(Sp, 1, 13 - Length(S2)) + S3;
        ListBox2.Items.Add(St);
      End;
      { listbox2.itemindex := 0;
       listbox2.setfocus;
              listbox2click(self);}{ gek 6/4/97 }
    End; {listbox1.items := ts; }

    If Ts.Count > 0 Then Lbb2.Items := Ts;
  Finally
    Ts.Free;
    Screen.Cursor := crDefault;
  End;
End; {try}

Procedure TMAGGMCF.ListBox2KeyDown(Sender: Tobject; Var Key: Word;
  Shift: TShiftState);
Begin
  If Not (Key = VK_Return) Then Exit;
  If ListBox2.ItemIndex = -1 Then Exit;
  ListBox2Click(Self);
  bbOK.Click;
End;

Procedure TMAGGMCF.ReLoadtheProcedureSubspecialtylist1Click(
  Sender: Tobject);
Begin
  ListBox1.Clear;
  Loadproc(1);
End;

Procedure TMAGGMCF.ListPatientProcedures1Click(Sender: Tobject);
Begin
  LoadProcedures;
End;

Procedure TMAGGMCF.ListBox1Click(Sender: Tobject);
Begin
  If Rbnewproc.Checked Then
  Begin
    If Mcdttm.caption = '' Then bbNew.Click;
    Msg.caption := 'Click ''OK'' or ''dblclick'' ' + ListBox1.Items[ListBox1.ItemIndex] +
      ' for a New ' + ListBox1.Items[ListBox1.ItemIndex] + ' Procedure.';
    Msg.Update;
  End
  Else
  Begin
    ClearProc;
    ClearDttm;
    Msg.caption := 'To list ' + ListBox1.Items[ListBox1.ItemIndex] +
      ' Procedures:  ''Press <Enter> or ''dblclick'' ' + ListBox1.Items[ListBox1.ItemIndex];
    Msg.Update;
  End;
End;

Procedure TMAGGMCF.ListBox2DblClick(Sender: Tobject);
Begin
  If ListBox2.ItemIndex = -1 Then Exit;
  bbOK.Click;
End;

Procedure TMAGGMCF.Button1Click(Sender: Tobject);
Var
  s: String;
Begin
  XBROKERX.PARAM[0].Value := Mcdttm.caption + '^' + Psien.caption + '^' + DFN.caption + '^';
  XBROKERX.PARAM[0].PTYPE := LITERAL;
  XBROKERX.REMOTEPROCEDURE := 'MAGG MED NEW';
  s := XBROKERX.STRCALL;

//  Showmessage(s);
  messagedlg(s, Mtconfirmation, [Mbok], 0);
  Mcien.caption := MagPiece(s, '^', 2);

  {MCDTTM.caption +'^'+ PSIEN.CAPTION +'^'+DFN.CAPTION+'^'}
End;

Procedure TMAGGMCF.RbnewprocClick(Sender: Tobject);
Begin
  If Not cbMakeProcStub.Enabled Then cbMakeProcStub.Enabled := True;
  If MAGGMCF.Visible Then
  Begin
    ClearProc;
    ClearDttm;
    ListBox1.SetFocus;
    If ListBox1.ItemIndex > -1 Then ListBox1Click(Self);
  End;
End;

Procedure TMAGGMCF.RblistprocClick(Sender: Tobject);
Begin
  If cbMakeProcStub.Enabled Then cbMakeProcStub.Enabled := False;
  If MAGGMCF.Visible Then
  Begin
    ClearProc;
    ClearDttm;
    ListBox1.SetFocus;
    If ListBox1.ItemIndex > -1 Then ListBox1DblClick(Self);
  End;
End;

Procedure TMAGGMCF.FormClose(Sender: Tobject; Var action: TCloseAction);
Begin
  Msg.caption := '';
End;

Procedure TMAGGMCF.FormDestroy(Sender: Tobject);
Var
  Tini: TIniFile;
Begin
  SaveFormPosition(Self As TForm);
  Tini := TIniFile.Create(GetConfigFileName);
  Try
    If Rbnewproc.Checked Then
      Tini.Writestring('Medicine Options', 'Create New/List Existing', 'Create New')
    Else
      Tini.Writestring('Medicine Options', 'Create New/List Existing', 'List Existing');

    If cbMakeProcStub.Checked Then
      Tini.Writestring('Medicine Options', 'Create Procedure stub first', 'TRUE')
    Else
      Tini.Writestring('Medicine Options', 'Create Procedure stub first', 'FALSE');

  Finally
    Tini.Free;
  End;
End;

Procedure TMAGGMCF.WMGetMinMaxInfo(Var Message: TWMGetMinMaxInfo);
Var
  Hy, Wx: Integer;
Begin
  Hy := Trunc(380 * (Pixelsperinch / 96));
  Wx := Trunc(450 * (Pixelsperinch / 96));
  With Message.Minmaxinfo^ Do
  Begin
    PtMinTrackSize.x := Wx;
    PtMinTrackSize.y := Hy;
  End;
  Message.Result := 0;
  Inherited;

End;

Procedure TMAGGMCF.WMMOVE(Var Message: TWMMOVE);
Var
  L, t: Integer;
Begin
  Message.Result := 0;
  If (Left < 0) Or (Top < 0) Then
  Begin
    L := Left;
    t := Top;
    If L < 0 Then L := 0;
    If t < 0 Then t := 0;
    SetBounds(L, t, Width, Height);
  End;
  Inherited;
End;

Procedure TMAGGMCF.ProcnewdttmExit(Sender: Tobject);
Begin
  If (Not (Procnewdttm.Text = '') And Procnewdttm.Modified) Then Newproctime;
  Procnewdttm.Modified := False;
End;

Procedure TMAGGMCF.FormResize(Sender: Tobject);
Begin
  RealignButtons;
End;

Procedure TMAGGMCF.RealignButtons;
Var
  Sp, bw: Integer;
Begin
  bw := bbOK.Width;
  Try
    // if Disable Button is enabled then : BW*5 => BW*6   and    div 6 => div 7
    Sp := ((ClientWidth - (bw * 4)) Div 5);
  Except
    Sp := 5;
  End;
  bbOK.Left := Sp;
  bbCancel.Left := Sp + bw + Sp;
  bbNew.Left := Sp + bw + Sp + bw + Sp;
  bbHelp.Left := Sp + bw + Sp + bw + Sp + bw + Sp;
  //bClose.left := sp + bw + sp + bw + sp + bw + sp + bw + sp;
//bDisable.left := sp+bw+sp+bw+sp+bw+sp+bw+sp+bw+sp;

End;
End.
