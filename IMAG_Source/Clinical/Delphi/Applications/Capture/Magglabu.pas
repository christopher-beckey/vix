Unit Magglabu;
   {
   Package: MAG - VistA Imaging
   WARNING: Per VHA Directive 10-93-142 this unit should not be modified.
   Date Created:
   Site Name: Silver Spring, OIFO
   Developers: Garrett Kirin
   Description: Imaging Laboratory specimen Selection window.
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
  Dialogs,
  ExtCtrls,
  Forms,
  Grids,
  Menus,
  Messages,
  Stdctrls,
  Controls
  ;

//Uses Vetted 20090929:Graphics, WinProcs, dmsingle, magpositions, trpcb, MagBroker, maggut1, umagutils, Controls, WinTypes, SysUtils

Type
  TMagglabf = Class(TForm)
    Lmsg: Tpanel;
    Panel2: Tpanel;
    Info: Tlabel;
    MainMenu1: TMainMenu;
    File1: TMenuItem;
    Exit1: TMenuItem;
    Help1: TMenuItem;
    Contents1: TMenuItem;
    N1: TMenuItem;
    Save1: TMenuItem;
    Options1: TMenuItem;
    Font1: TMenuItem;
    Panel3: Tpanel;
    Entries: Tlabel;
    bbCancel: TBitBtn;
    bbOK: TBitBtn;
    Stg1: TStringGrid;
    FontDialog1: TFontDialog;
    Label3: Tlabel;
    Label5: Tlabel;
    cbSection: TComboBox;
    EAccYear: TEdit;
    EAccNumber: TEdit;
    Panel4: Tpanel;
    Selection: Tlabel;
    LBB1: TListBox;
    bSearch: TBitBtn;
    Showcollength: TButton;
    Setcollength: TButton;
    Ldfn: TEdit;
    BitBtn1: TBitBtn;
    Procedure Stg1DblClick(Sender: Tobject);
    Procedure bbOKClick(Sender: Tobject);
    Procedure Save1Click(Sender: Tobject);
    Procedure Exit1Click(Sender: Tobject);
    Procedure ShowcollengthClick(Sender: Tobject);
    Procedure Font1Click(Sender: Tobject);
    Procedure bSearchClick(Sender: Tobject);
    Procedure EAccYearExit(Sender: Tobject);
    Procedure FormPaint(Sender: Tobject);
    Procedure FormCreate(Sender: Tobject);
    Procedure EAccNumberKeyDown(Sender: Tobject; Var Key: Word;
      Shift: TShiftState);
    Procedure Stg1KeyDown(Sender: Tobject; Var Key: Word;
      Shift: TShiftState);
    Procedure FormShow(Sender: Tobject);
    Procedure EAccYearKeyDown(Sender: Tobject; Var Key: Word;
      Shift: TShiftState);
    Procedure cbSectionKeyDown(Sender: Tobject; Var Key: Word;
      Shift: TShiftState);
    Procedure FormDestroy(Sender: Tobject);
    procedure BitBtn1Click(Sender: TObject);
  Private
    Procedure WMMOVE(Var Message: TWMMOVE); Message WM_MOVE;
    Procedure WMGetMinMaxInfo(Var Message: TWMGetMinMaxInfo); Message WM_GetMinMaxInfo;

    Procedure Sizethecolumns;
    { Private declarations }
  Public
    Function RPCerror: Boolean;
    Function ValidAccYear: Boolean;
    Procedure Msg(s: String); { Public declarations }
    Procedure ClearGrid;
    Function AccessionFieldsFull: Boolean;
    Procedure Loadsection;
    Procedure SearchForSpecimen;
    Procedure InitPatient(DFN: String);
  End;

Var
  Magglabf: TMagglabf;
  Minwidth: Integer;
Implementation
Uses

    ImagDMinterface, //DmSingle,
  FmagCapConfig,
  FmagCapMain,
  MagBroker,
  Maggut1,
  Magpositions,
  SysUtils,
  Trpcb,
  Umagutils8,
  WinTypes
  ;

{$R *.DFM}

Procedure TMagglabf.InitPatient(DFN: String);
Begin
  If (DFN <> Ldfn.Text) Then
  Begin
    ClearGrid;
    LBB1.Clear;
    EAccNumber.Clear;
  End;

End;

Procedure TMagglabf.Stg1DblClick(Sender: Tobject);
Begin
  bbOK.Click;
End;

Procedure TMagglabf.bbOKClick(Sender: Tobject);
Var
  Xdfn: String;
Begin

  If Stg1.Cells[1, 1] = '' Then
  Begin
    Messagebeep(0);
    Msg('No Selections to choose');
    Exit;
  End;

  Selection.caption := XBROKERX.Results[Stg1.Selection.Top];
  Xdfn := MagPiece(Selection.caption, '^', 8);
  If Xdfn <> Ldfn.Text Then
  Begin
    If Not Frmcapmain.IsStudyGroupComplete Then Exit;
    Ldfn.Text := Xdfn;
  End;

  ModalResult := MrOK;
End;

procedure TMagglabf.BitBtn1Click(Sender: TObject);
begin
  Application.HelpContext(10005);
end;

Procedure TMagglabf.Loadsection;
Begin
  LBB1.Clear;
  Minwidth := Width;
  XBROKERX.REMOTEPROCEDURE := 'MAGGLAB SECT';
  XBROKERX.Call;
  If RPCerror Then Exit;
  cbSection.Items := XBROKERX.Results;
End;

Procedure TMagglabf.Save1Click(Sender: Tobject);
Begin
  bbOK.Click;
End;

Procedure TMagglabf.Exit1Click(Sender: Tobject);
Begin
  bbCancel.Click;
End;

Procedure TMagglabf.Sizethecolumns;
Var
  x, Xh, Xw: Integer;
  Rx, Cx: Integer;
  Maxl: Array[0..50] Of Integer;
Begin
  {without the UPDATE, the Font used is SYSTEM, and the resizing
    is done using System, NOT using the font of the StringGrid}
  Update;
  Stg1.Defaultrowheight := Stg1.Canvas.TextHeight('Test Text') + 1;
  For x := 0 To 49 Do
    Maxl[x] := 10;
  For Cx := 0 To Stg1.ColCount - 1 Do
  Begin
    For Rx := 0 To Stg1.RowCount - 1 Do
    Begin
      Xw := Stg1.Canvas.Textwidth('W');
      x := Stg1.Canvas.Textwidth(Stg1.Cells[Cx, Rx]) + Xw;
      If (x > Maxl[Cx]) Then Maxl[Cx] := x;
    End;
  End;
  Xh := 0;
  For x := 0 To Stg1.ColCount - 1 Do
  Begin
    Stg1.ColWidths[x] := Maxl[x];
    Xh := Xh + Maxl[x];
  End;
  If (Xh + 50) < Minwidth Then
  Begin
    Width := Minwidth;
    Exit;
  End;

  Width := Xh + 50;
  If Width > Screen.Width Then Left := 0;
  If (Left + Width) > Screen.Width Then Left := Screen.Width - Width;
End;

Procedure TMagglabf.ShowcollengthClick(Sender: Tobject);
Var
  i: byte;
  s: String;
Begin
  s := '';
  For i := 0 To Stg1.ColCount Do
  Begin
    s := s + Inttostr(i) + '-' + Inttostr(Stg1.ColWidths[i]) + '^';
  End;
  Info.caption := s;
  Setcollength.Visible := False;
  Showcollength.Visible := False;
End;

Procedure TMagglabf.Font1Click(Sender: Tobject);
Begin
  If FontDialog1.Execute Then
  Begin
    Stg1.Font := FontDialog1.Font;
    Setcollength.Click;
  End;
End;

Function TMagglabf.RPCerror: Boolean;
Var
  ct, s: String;

Begin
  If XBROKERX.Results.Count = 0 Then
  Begin
    Messagedlg('RPCBroker Error, use ^XTER to examine error info.', Mtconfirmation, [Mbok], 0);
    RPCerror := True;
    Exit;
  End;
  If MagPiece(XBROKERX.Results[0], '^', 1) = '0' Then
  Begin
    Msg(MagPiece(XBROKERX.Results[0], '^', 2));
    RPCerror := True;
    Exit;
  End;
  ct := MagPiece(XBROKERX.Results[0], '^', 1);
  If (ct = '1') Then
    s := ' Entry '
  Else
    s := ' Entries ';
  Msg(ct + s + ' returned');
  XBROKERX.Results.Delete(0);
  RPCerror := False;
End;

Function TMagglabf.AccessionFieldsFull: Boolean;
Begin
  Result := False;
  If cbSection.Text = '' Then
  Begin
    Msg('Section is needed !!');
    Messagebeep(0);
    cbSection.SetFocus;
    Exit;
  End;
  If cbSection.ItemIndex = -1 Then
  Begin
    Msg('Section is needed !!');
    Messagebeep(0);
    cbSection.SetFocus;
    Exit;
  End;
  If EAccYear.Text = '' Then
  Begin
    Msg('Accession Year ?? ');
    Messagebeep(0);
    EAccYear.SetFocus;
    Exit;
  End;
  If EAccNumber.Text = '' Then
  Begin
    Msg('Accession Number ?? ');
    Messagebeep(0);
    EAccNumber.SetFocus;
    Exit;
  End;
  Result := True;
End;

Procedure TMagglabf.ClearGrid;
Var
  i, j: Integer;
Begin
  For i := 1 To Stg1.RowCount - 1 Do
  Begin
    For j := 0 To Stg1.ColCount - 1 Do
      Stg1.Cells[j, i] := '';
  End;
  Stg1.Update;
End;

Procedure TMagglabf.bSearchClick(Sender: Tobject);

Begin
  SearchForSpecimen;
End;

Procedure TMagglabf.SearchForSpecimen;
Var
  k, j: Integer;
Begin
  bbOK.Enabled := False;
  If Not AccessionFieldsFull Then Exit;
  Msg('Compiling list of Lab''s');
  ClearGrid;
  LBB1.Clear;
  XBROKERX.PARAM[0].PTYPE := LITERAL;
  XBROKERX.PARAM[0].Value := MagPiece(cbSection.Items[cbSection.ItemIndex], '^', 2);
  XBROKERX.PARAM[1].PTYPE := LITERAL;
  XBROKERX.PARAM[1].Value := EAccYear.Text;
  XBROKERX.PARAM[2].PTYPE := LITERAL;
  XBROKERX.PARAM[2].Value := EAccNumber.Text;
  XBROKERX.PARAM[3].PTYPE := LITERAL;
  XBROKERX.PARAM[3].Value := Ldfn.Text;

  XBROKERX.REMOTEPROCEDURE := 'MAGGLAB START';
  XBROKERX.Call;
  If RPCerror Then Exit;
  Stg1.RowCount := XBROKERX.Results.Count;
  Stg1.ColCount := Maglength(XBROKERX.Results[0], '^');
  For j := 0 To XBROKERX.Results.Count - 1 Do
  Begin
    For k := 1 To Stg1.ColCount Do
    Begin
      Stg1.Cells[k - 1, j] := MagPiece(XBROKERX.Results[j], '^', k);
    End;
  End;
  Sizethecolumns;
  bbOK.Enabled := True;
  Stg1.SetFocus;
End;

Procedure TMagglabf.Msg(s: String);
Begin
  Info.caption := s;
  Info.Update;
End;

Procedure TMagglabf.EAccYearExit(Sender: Tobject);
Begin
  ValidAccYear;
End;

Function TMagglabf.ValidAccYear: Boolean;
Begin
  Result := True;
  If Length(EAccYear.Text) <> 4 Then
  Begin
    Result := False;
    Messagebeep(0);
    Msg(' Year ??  ' + EAccYear.Text);
    EAccYear.Text := Formatdatetime('yyyy', Now);
    EAccYear.SetFocus;
  End;
End;

Procedure TMagglabf.FormPaint(Sender: Tobject);
Begin
  If cbSection.Items.Count > 0 Then Exit;
  LBB1.Clear;
  Minwidth := Width;
  XBROKERX.REMOTEPROCEDURE := 'MAGGLAB SECT';
  XBROKERX.Call;
  If RPCerror Then Exit;
  cbSection.Items := XBROKERX.Results;

End;

Procedure TMagglabf.FormCreate(Sender: Tobject);
Begin
  GetStringGridFont(Self.Name + '-' + Stg1.Name, Stg1);
  GetFormPosition(Self As TForm);
  EAccYear.Text := Formatdatetime('yyyy', Now);
End;

Procedure TMagglabf.EAccNumberKeyDown(Sender: Tobject; Var Key: Word;
  Shift: TShiftState);
Begin
  If Key = VK_Return Then SearchForSpecimen;
  If ((Key = VK_DOWN) Or (Key = VK_UP)) Then
    If EAccNumber.Text = '' Then EAccNumber.Text := '0';
  If Key = VK_DOWN Then
  Begin
    EAccNumber.Text := Inttostr(Strtoint(EAccNumber.Text) - 1);
    If Strtoint(EAccNumber.Text) < 0 Then EAccNumber.Text := '0';
  End;

  If Key = VK_UP Then EAccNumber.Text := Inttostr(Strtoint(EAccNumber.Text) + 1);
  {if ((key < $30) or (key > $39)) then
     BEGIN
     KEY := $08 ;
     END;}
  {try
  if strtoint(EAccNumber.text) < 0 then EAccNumber.text := '0';
  except
  on Exception do
     begin
     messagebeep(0);
     key := $08;
     end;
  end; }{try}

End;

Procedure TMagglabf.Stg1KeyDown(Sender: Tobject; Var Key: Word;
  Shift: TShiftState);
Begin
  If Key = VK_Return Then bbOK.Click;
End;

Procedure TMagglabf.FormShow(Sender: Tobject);
Begin
  If (FrmCapConfig.ImageGroup.Checked) And (Frmcapmain.Imageptrlst.Items.Count > 0) Then
  Begin
    cbSection.Enabled := False;
    EAccYear.Enabled := False;
    EAccNumber.Enabled := False;
  End
  Else
  Begin
    cbSection.Enabled := True;
    EAccYear.Enabled := True;
    EAccNumber.Enabled := True;
  End;

  If (idmodobj.GetMagPat1.M_DFN <> Ldfn.Text) Then
    cbSection.SetFocus
  Else
    Stg1.SetFocus;

End;

Procedure TMagglabf.EAccYearKeyDown(Sender: Tobject; Var Key: Word;
  Shift: TShiftState);
Begin
  If Key = VK_DOWN Then
    EAccYear.Text :=
      Inttostr(Strtoint(EAccYear.Text) - 1);
  If Key = VK_UP Then
    EAccYear.Text :=
      Inttostr(Strtoint(EAccYear.Text) + 1);

  If Key = VK_Return Then
    If ValidAccYear Then SearchForSpecimen;

End;

Procedure TMagglabf.cbSectionKeyDown(Sender: Tobject; Var Key: Word;
  Shift: TShiftState);
Begin
  If Key = VK_Return Then SearchForSpecimen;
End;

Procedure TMagglabf.WMGetMinMaxInfo(Var Message: TWMGetMinMaxInfo);
Var
  Hy, Wx: Integer;
Begin
  Hy := Trunc(290 * (Pixelsperinch / 96));
  Wx := Trunc(523 * (Pixelsperinch / 96));
  With Message.Minmaxinfo^ Do
  Begin
    PtMinTrackSize.x := Wx;
    PtMinTrackSize.y := Hy;
  End;
  Message.Result := 0;
  Inherited;

End;

Procedure TMagglabf.WMMOVE(Var Message: TWMMOVE);
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

Procedure TMagglabf.FormDestroy(Sender: Tobject);
Begin
  SaveFormPosition(Self As TForm);
  SaveControlFont(Self.Name + '-' + Stg1.Name, Stg1.Font);
End;

End.
