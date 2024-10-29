Unit Maggsuru;
   {
   Package: MAG - VistA Imaging
   WARNING: Per VHA Directive 10-93-142 this unit should not be modified.
   Date Created:
   Site Name: Silver Spring, OIFO
   Developers: Garrett Kirin
   Description: Imaging Surgery operation Selection Window
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
  Dialogs,
  ExtCtrls,
  Forms,
  Grids,
  Menus,
  Messages,
  Stdctrls,
  Controls,
  Classes
  ;

//Uses Vetted 20090929:Graphics, Classes, WinProcs, magpositions, trpcb, MagBroker, maggut1, umagutils, Controls, WinTypes, SysUtils

Type
  TMaggsur = Class(TForm)
    Panel1: Tpanel;
    MainMenu1: TMainMenu;
    File1: TMenuItem;
    Exit1: TMenuItem;
    Help1: TMenuItem;
    N1: TMenuItem;
    Save1: TMenuItem;
    Label1: Tlabel;
    Options1: TMenuItem;
    Font1: TMenuItem;
    FontDialog1: TFontDialog;
    Entries: Tlabel;
    Stg1: TStringGrid;
    Panel3: Tpanel;
    Pmsg: Tlabel;
    Selection: Tlabel;
    Setcollength: TButton;
    Showcollength: TButton;
    SURDFN: TEdit;
    LBB1: TListBox;
    Panel2: Tpanel;
    Panel4: Tpanel;
    Info: Tlabel;
    bbOK: TBitBtn;
    bbCancel: TBitBtn;
    BitBtn1: TBitBtn;
    SurgeryCaseList1: TMenuItem;
    Procedure Stg1DblClick(Sender: Tobject);
    Procedure bbOKClick(Sender: Tobject);
    Procedure Save1Click(Sender: Tobject);
    Procedure Exit1Click(Sender: Tobject);
    Procedure SetcollengthClick(Sender: Tobject);
    Procedure ShowcollengthClick(Sender: Tobject);
    Procedure Label1DblClick(Sender: Tobject);
    Procedure Font1Click(Sender: Tobject);
    Procedure FormCreate(Sender: Tobject);
    Procedure FormDestroy(Sender: Tobject);
    Procedure SurgeryCaseList1Click(Sender: Tobject);
    procedure BitBtn1Click(Sender: TObject);
  Private
    Procedure Sizethecolumns;
    Procedure WMGetMinMaxInfo(Var Message: TWMGetMinMaxInfo); Message WM_GetMinMaxInfo;
    { Private declarations }
  Public
    Function SurgeryCaselist(XMAGDFN: String): Integer;
    { Public declarations }
  End;

Var
  Maggsur: TMaggsur;
Implementation
Uses

  MagBroker,
  Maggut1,
  Magpositions,
  SysUtils,
  Trpcb,
  Umagutils8,
  WinTypes
  ;

{$R *.DFM}

Function TMaggsur.SurgeryCaselist(XMAGDFN: String): Integer;
Var
  j, k: Integer;
Begin
  XBROKERX.PARAM[0].Value := XMAGDFN;
  XBROKERX.PARAM[0].PTYPE := LITERAL;
  XBROKERX.REMOTEPROCEDURE := 'MAGGSUR GET';
  XBROKERX.LstCALL(LBB1.Items);
  Result := Strtoint(MagPiece(LBB1.Items[0], '^', 1));
  SURDFN.Text := XMAGDFN;
  If MagPiece(LBB1.Items[0], '^', 1) = '0' Then
  Begin
    Messagedlg(MagPiece(LBB1.Items[0], '^', 2), Mtconfirmation, [Mbok], 0);
    Info.caption := MagPiece(LBB1.Items[0], '^', 2);
    Exit;
  End;
  {entries.caption := magpiece(lbb1.items[0],'^',1) + '  entries';}
  Info.caption := MagPiece(LBB1.Items[0], '^', 1) + ' ' + MagPiece(LBB1.Items[0], '^', 2);
  LBB1.Items.Delete(0);
  Stg1.RowCount := LBB1.Items.Count;
  Stg1.ColCount := Maglength(LBB1.Items[0], '^');
  For j := 0 To LBB1.Items.Count - 1 Do
  Begin
    For k := 1 To Stg1.ColCount Do
    Begin
      Stg1.Cells[k - 1, j] := MagPiece(LBB1.Items[j], '^', k);
    End;
  End;
End;

Procedure TMaggsur.Stg1DblClick(Sender: Tobject);
Begin
  bbOK.Click;
End;

Procedure TMaggsur.bbOKClick(Sender: Tobject);
Var
  s: String;
  i: Integer;
  t: TGridRect;
Begin
  i := Stg1.Selection.Top;
  s := LBB1.Items[i];
  While (MagPiece(s, '^', 4) = '') And (i > 0) Do
  Begin
    Dec(i);
    s := LBB1.Items[i];
  End;
  If i = 0 Then
  Begin
    Messagebeep(0);
    Exit;
  End;
  t.Top := i;
  t.Left := 0;
  t.Right := 3;
  t.Bottom := i;
  Stg1.Selection := t;
  Selection.caption := LBB1.Items[i];
  ModalResult := MrOK;
End;

Procedure TMaggsur.Save1Click(Sender: Tobject);
Begin
  bbOK.Click;
End;

procedure TMaggsur.BitBtn1Click(Sender: TObject);
begin
  Application.HelpContext(10195);
end;

Procedure TMaggsur.Exit1Click(Sender: Tobject);
Begin
  bbCancel.Click;
End;

Procedure TMaggsur.Sizethecolumns;
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
  {width :=xh +50;}
  If ((Xh + 50) > Width) Then Width := Xh + 50;
  If Width > Screen.Width Then Left := 0;
  If (Left + Width) > Screen.Width Then Left := Screen.Width - Width;
End;

Procedure TMaggsur.SetcollengthClick(Sender: Tobject);
Begin
  Sizethecolumns;
  Setcollength.Visible := False;
  Showcollength.Visible := False;
End;

Procedure TMaggsur.ShowcollengthClick(Sender: Tobject);
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

Procedure TMaggsur.Label1DblClick(Sender: Tobject);
Begin
  Setcollength.Visible := True;
  Showcollength.Visible := True;
End;

Procedure TMaggsur.Font1Click(Sender: Tobject);
Begin
  If FontDialog1.Execute Then
  Begin
    Stg1.Font := FontDialog1.Font;
    Setcollength.Click;
  End;
End;

Procedure TMaggsur.FormCreate(Sender: Tobject);
Begin
  GetFormPosition(Self As TForm);
  GetStringGridFont(Self.Name + '-' + Stg1.Name, Stg1);
End;

{procedure WMGetMinMaxInfo( var message : TWMGetMinMaxInfo); message WM_GETMINMAXINFO;}

Procedure TMaggsur.WMGetMinMaxInfo(Var Message: TWMGetMinMaxInfo);
Var
  Hy, Wx: Integer;
Begin
  Hy := Trunc(245 * (Pixelsperinch / 96));
  Wx := Trunc(425 * (Pixelsperinch / 96));
  With Message.Minmaxinfo^ Do
  Begin
    PtMinTrackSize.x := Wx;
    PtMinTrackSize.y := Hy;
  End;
  Message.Result := 0;
  Inherited;

End;

Procedure TMaggsur.FormDestroy(Sender: Tobject);
Begin
  SaveFormPosition(Self As TForm);
  SaveControlFont(Self.Name + '-' + Stg1.Name, Stg1.Font);
End;

Procedure TMaggsur.SurgeryCaseList1Click(Sender: Tobject);
Begin
  Application.HelpContext(135);
End;

End.
