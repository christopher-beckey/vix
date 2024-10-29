Unit Magradlistwinu;
   {
   Package: MAG - VistA Imaging
   WARNING: Per VHA Directive 10-93-142 this unit should not be modified.
   Date Created:
   Site Name: Silver Spring, OIFO
   Developers: Garrett Kirin
   Description: Allows user to select a Radiology Exam, and view the report,
        and/or the Images associated with it.
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

Interface

Uses
  Buttons,
  Classes,
  ExtCtrls,
  Forms,
  Grids,
  Menus,
  Messages,
  Stdctrls,
  Controls
  ;

//Uses Vetted 20090929:Dialogs, Controls, Graphics, WinProcs, dmsingle, magpositions, umagutils, WinTypes, SysUtils

Type
  Tradlistwin = Class(TForm)
    Stg1: TStringGrid;
    SortList: TListBox;
    BaseList: TListBox;
    PToolbar: Tpanel;
    ShowImage: TBitBtn;
    Setcollength: TBitBtn;
    PopupMenu1: TPopupMenu;
    Columnsize1: TMenuItem;
    MnuToolbar: TMenuItem;
    Maintainfocus1: TMenuItem;
    N1: TMenuItem;
    N2: TMenuItem;
    StretchHeight1: TMenuItem;
    DefaultHeight1: TMenuItem;
    bdftHeight: TBitBtn;
    bStretch: TBitBtn;
    ShowReport: TBitBtn;
    GotoMainWindow1: TMenuItem;
    RowSorting1: TCheckBox;
    Pinfo: Tpanel;
    DFN: TEdit;
    Sortlistbyindex1: TMenuItem;
    Inverseorder1: TMenuItem;
    N4: TMenuItem;
    N5: TMenuItem;
    Report1: TMenuItem;
    bHelp: TBitBtn;
    Lmsg: Tlabel;
    StayOnTop1: TMenuItem;
    ShowHints1: TMenuItem;
    Help1: TMenuItem;
    Procedure Stg1ColumnMoved(Sender: Tobject; FromIndex,
      ToIndex: Longint);
    Procedure Stg1KeyPress(Sender: Tobject; Var Key: Char);

    Procedure SetcollengthClick(Sender: Tobject);
    Procedure Stg1DblClick(Sender: Tobject);
    Procedure Stg1KeyDown(Sender: Tobject; Var Key: Word;
      Shift: TShiftState);
    Procedure Columnsize1Click(Sender: Tobject);
    Procedure MnuToolbarClick(Sender: Tobject);
    Procedure bdftHeightClick(Sender: Tobject);
    Procedure bStretchClick(Sender: Tobject);
    Procedure Maintainfocus1Click(Sender: Tobject);
    Procedure ShowreportClick(Sender: Tobject);
    Procedure GoToMainWindow1Click(Sender: Tobject);
    Procedure FormCreate(Sender: Tobject);
    Procedure Sortlistbyindex1Click(Sender: Tobject);
    Procedure Inverseorder1Click(Sender: Tobject);
    Procedure Report1Click(Sender: Tobject);
    Procedure FormResize(Sender: Tobject);
    Procedure FormKeyDown(Sender: Tobject; Var Key: Word;
      Shift: TShiftState);
    Procedure bHelpClick(Sender: Tobject);
    Procedure FormDestroy(Sender: Tobject);
    Procedure FormClose(Sender: Tobject; Var action: TCloseAction);
    Procedure StayOnTop1Click(Sender: Tobject);
    Procedure ShowHints1Click(Sender: Tobject);
    Procedure Help1Click(Sender: Tobject);
    Procedure PopupMenu1Popup(Sender: Tobject);
    Procedure FormShow(Sender: Tobject);
  Private
    Procedure WMGetMinMaxInfo(Var Message: TWMGetMinMaxInfo); Message WM_GetMinMaxInfo;
    Procedure WMMOVE(Var Message: TWMMOVE); Message WM_MOVE;
  Public
    Procedure Msg(s: String);
    Procedure ListToGrid;
    Procedure Sizethecolumns;
    Procedure SortTheList;
    Procedure Clear;
  End;

Var
  Radlistwin: Tradlistwin;
  Dftheight: Integer;

Implementation
Uses
  ImagDMinterface, //RCA  DmSingle,DmSingle,
 // fmagMain,
  Magpositions,
  SysUtils,
  Umagdisplaymgr,
  Umagutils8,
  WinTypes
  ;

{$R *.DFM}

Procedure Tradlistwin.WMGetMinMaxInfo(Var Message: TWMGetMinMaxInfo);
Var
  Hy, Wx: Integer;
Begin
  Hy := Trunc(175 * (Pixelsperinch / 96));
  Wx := Trunc(300 * (Pixelsperinch / 96));
  With Message.Minmaxinfo^ Do
  Begin
    PtMinTrackSize.x := Wx;
    PtMinTrackSize.y := Hy;
  End;
  Message.Result := 0;
  Inherited;

End;

Procedure Tradlistwin.Stg1ColumnMoved(Sender: Tobject; FromIndex,
  ToIndex: Longint);
Begin
  If RowSorting1.Checked Then SortTheList;
  LogActions('RAD', 'COLMOVED', DFN.Text);
End;

Procedure Tradlistwin.Stg1KeyPress(Sender: Tobject; Var Key: Char);
Var
  s: String;
  k: String;
  i, St: Longint;
  Found: Boolean;
Begin

  Found := False;
  k := Uppercase(Key);
  If (Ord(k[1]) < 65) Or (Ord(k[1]) > 90) Then Exit;
  St := Stg1.Row;
  i := St;
  While Not Found Do
  Begin
    i := i + 1;
    If i = Stg1.RowCount Then i := 1;
    If i = St Then Break;
    s := Copy(Stg1.Cells[1, i], 1, 1);
    If Uppercase(s[1]) = k Then
    Begin
      Stg1.Row := i;
      Found := True;
    End;

  End;
  LogActions('RAD', 'KEYPRESS', DFN.Text);
End;

Procedure Tradlistwin.SortTheList;
Var
  i, j: Integer;
  s, S1, Hd: String;
Begin
  Msg('Sorting grid...');
  SortList.Clear;
  Hd := Stg1.Cells[0, 0];
  For j := 1 To Stg1.ColCount - 1 Do
    Hd := Hd + '^' + Stg1.Cells[j, 0];

  For i := 1 To Stg1.RowCount - 1 Do
  Begin
    s := '';
    For j := 1 To Stg1.ColCount - 1 Do
    Begin
      s := s + Stg1.Cells[j, i] + '^';
    End;
    s := s + Stg1.Cells[0, i]; { add the ien}
    SortList.Items.Add(s);
  End;

  BaseList.Clear;
  BaseList.Update;
  BaseList.Items.Add(Hd);
  For i := 0 To SortList.Items.Count - 1 Do
  Begin
    s := SortList.Items[i];
    S1 := MagPiece(s, '^', Maglength(s, '^'));
    For j := 1 To Maglength(s, '^') - 1 Do
    Begin
      S1 := S1 + '^' + MagPiece(s, '^', j);
    End;
    BaseList.Items.Add(S1);
  End;

  BaseList.Update;
  ListToGrid;
{if columnsizing1.checked then
   begin
   MSG('Resizing Grid');
   setcollength.click;
   end;}
{entries.caption := inttostr(stg1.rowcount-1);}
  Msg('Entries loaded');
End;

Procedure Tradlistwin.Msg(s: String);
Begin
(*  pmsg.caption := s;
pmsg.update;   *)
End;

Procedure Tradlistwin.ListToGrid;
Var
  j, Jrow, k: Integer;

Begin
  Stg1.RowCount := BaseList.Items.Count;
  Stg1.ColCount := Maglength(BaseList.Items[0], '^');
  For k := 1 To Stg1.ColCount Do
  Begin
    Stg1.Cells[k - 1, 0] := MagPiece(BaseList.Items[0], '^', k);
  End;

  For j := 1 To BaseList.Items.Count - 1 Do
  Begin
    For k := 1 To Stg1.ColCount Do
    Begin
      Jrow := j;
            { if inversesort.checked then jrow := stg1.rowcount-j;  }
      Stg1.Cells[k - 1, Jrow] := MagPiece(BaseList.Items[j], '^', k);
    End;
  End;
End;

Procedure Tradlistwin.SetcollengthClick(Sender: Tobject);
Begin
  If DFN.Text = '' Then Exit;
  Sizethecolumns;
End;

Procedure Tradlistwin.Sizethecolumns;
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
   {THIS WILL STOP IEN FROM BEING SHOWN }{comment out to test}
{maxl[0]:=2;  }{ comment out this line, to show ien. }
  For x := 0 To Stg1.ColCount - 1 Do
  Begin
    Stg1.ColWidths[x] := Maxl[x];
    Xh := Xh + Maxl[x];
  End;
  Width := Xh + 50;
  If Width > Screen.Width Then Left := 0;
  If (Left + Width) > Screen.Width Then Left := Screen.Width - Width;
End;

Procedure Tradlistwin.Stg1DblClick(Sender: Tobject);
Var
  s: String;
  radstr: String;
Begin
//p8t33  if (not demomode) and (dfn.text = '') then exit;
  If (DFN.Text = '') Then Exit;
  s := Stg1.Cells[0, Stg1.Row];
  If s = '' Then Exit;

  Stg1.Enabled := False;
  Stg1.Update;
  PToolbar.Enabled := False;
  PToolbar.Update;
  Lmsg.caption := 'Loading...';
  Lmsg.Update;

  LogActions('RAD', 'IMAGE', 'DFN-' + DFN.Text);
  Msg(s);
{p94t3  gek 11-30-09  stopped calling fmagmain radexamselected.  radstr := trad...
   was all it was doing.   moved RadExamImagesToGroup to umagdisplaymgr from fmagmain.}
//  frmMain.radexamselected(s);
  radstr := TRadList[Strtoint(s)];
  Umagdisplaymgr.RadExamImagesToGroup(radstr);

  Stg1.Enabled := True;
  Stg1.Update;
  PToolbar.Enabled := True;
  Lmsg.caption := '';
  Lmsg.Update;

  If Maintainfocus1.Checked Then Stg1.SetFocus;

End;

Procedure Tradlistwin.Stg1KeyDown(Sender: Tobject; Var Key: Word;
  Shift: TShiftState);
Begin
  If Key = VK_Return Then
  Begin
    Stg1DblClick(Sender);
    LogActions('RAD', 'RETURN', DFN.Text);
  End;
End;

Procedure Tradlistwin.Clear;
Var
  i, j: Integer;
Begin

  For i := 1 To Stg1.RowCount - 1 Do
  Begin
    For j := 1 To Stg1.ColCount - 1 Do
    Begin
      Stg1.Cells[j, i] := '';
    End;
  End;

  DFN.Text := '';
  Pinfo.caption := '';
  SortList.Clear;
  BaseList.Clear;
  Stg1.RowCount := 2;
  Stg1.ColCount := 4;
  caption := 'Radiology Exam listing  : ';
End;

Procedure Tradlistwin.Columnsize1Click(Sender: Tobject);
Begin
  Sizethecolumns;
End;

Procedure Tradlistwin.MnuToolbarClick(Sender: Tobject);
Begin
  MnuToolbar.Checked := Not MnuToolbar.Checked;
  PToolbar.Visible := MnuToolbar.Checked;
End;

Procedure Tradlistwin.bdftHeightClick(Sender: Tobject);
Begin
  Height := Dftheight;
End;

Procedure Tradlistwin.bStretchClick(Sender: Tobject);
Begin
//dftheight := height;
  Height := Screen.Height - Top - 30;
End;

Procedure Tradlistwin.Maintainfocus1Click(Sender: Tobject);
Begin
  Maintainfocus1.Checked := Not Maintainfocus1.Checked;
End;

Procedure Tradlistwin.ShowreportClick(Sender: Tobject);
Var
  s: String;
Begin
 //p8t33   if (not demomode) and (dfn.text = '') then exit;
  If (DFN.Text = '') Then Exit;
  s := Stg1.Cells[0, Stg1.Row];
  If s = '' Then Exit;
  Msg(s);
  LogActions('RAD', 'REPORT', 'DFN-' + DFN.Text);

  idmodobj.GetMagUtilsDB1.RadiologyExamReport(TRadList[Strtoint(Stg1.Cells[0, Stg1.Row])]);

  If Maintainfocus1.Checked Then Stg1.SetFocus;

End;

Procedure Tradlistwin.GoToMainWindow1Click(Sender: Tobject);
Begin
  Application.MainForm.SetFocus;
 //  frmMain.focustomain;
End;

Procedure Tradlistwin.FormCreate(Sender: Tobject);
Begin
  GetFormPosition(Self As TForm);
  Dftheight := 153;
End;

Procedure Tradlistwin.Sortlistbyindex1Click(Sender: Tobject);
Var
  i, j: Integer;
Begin
  For i := Stg1.RowCount - 1 Downto 1 Do
  Begin
    For j := 0 To Stg1.ColCount - 1 Do
      Stg1.Cells[j, i] := '';
  End;
  SortList.Clear;
  BaseList.Clear;
  //frmMain.listtoradlistwin;
  Umagdisplaymgr.Listtoradlistwin;
  caption := 'Radiology Exam listing  : ' + idmodobj.GetMagPat1.M_NameDisplay;
  DFN.Text := idmodobj.GetMagPat1.M_DFN;

End;

Procedure Tradlistwin.Inverseorder1Click(Sender: Tobject);
Var
  i, j: Integer;
  s, Hd: String;
Begin
  Msg('Inverse order...');
  BaseList.Clear;
  Hd := Stg1.Cells[0, 0];
  For j := 1 To Stg1.ColCount - 1 Do
    Hd := Hd + '^' + Stg1.Cells[j, 0];

  BaseList.Items.Add(Hd);

  For i := Stg1.RowCount - 1 Downto 1 Do
  Begin
    s := '';
    For j := 0 To Stg1.ColCount - 1 Do
    Begin
      s := s + Stg1.Cells[j, i] + '^';
    End;
    s := Copy(s, 1, Length(s) - 1); { strip the last '^'}
    BaseList.Items.Add(s);
  End;

  BaseList.Update;
  ListToGrid;
  Msg('Entries loaded');
End;

Procedure Tradlistwin.Report1Click(Sender: Tobject);
Begin
  ShowReport.Click;
End;

Procedure Tradlistwin.WMMOVE(Var Message: TWMMOVE);
//VAR
// L,T : INTEGER;
Begin
{P := MAKEPOINT(Message.RESULT);
P := CLIENTTOSCREEN(P);}
  Message.Result := 0;
(* if (left < 0)  OR (TOP < 0) OR (TOP MOD 10 >0) OR (LEFT MOD 10 >0) THEN
   BEGIN
   L := LEFT;
   T := TOP  ;
   if L < 0 then L := 0;
   if T < 0 then T := 0;
   if T mod 10 > 0 then T := T-(T mod 10);
   if L mod 10 > 0 then L := L-(L mod 10);
   SETBOUNDS(L,T,WIDTH,HEIGHT);
   END;    MAG32*)
  Inherited;
End;

Procedure Tradlistwin.FormResize(Sender: Tobject);
Begin
  If (Width Mod 10 > 0) Or (Height Mod 10 > 0) Then
  Begin
    SetBounds(Left, Top, Width - (Width Mod 10), Height - (Height Mod 10));
  End;
End;

Procedure Tradlistwin.FormKeyDown(Sender: Tobject; Var Key: Word;
  Shift: TShiftState);
Begin
  If (Shift = [Ssctrl]) And (Key = VK_tab) Then
    PopupMenu1.Popup(Left + 20, Top + 50);

End;

Procedure Tradlistwin.bHelpClick(Sender: Tobject);
Begin
  Application.HelpContext(HelpContext);
End;

Procedure Tradlistwin.FormDestroy(Sender: Tobject);
Begin
  SaveFormPosition(Self As TForm);
End;

Procedure Tradlistwin.FormClose(Sender: Tobject; Var action: TCloseAction);
Begin
  action := caFree;
End;

Procedure Tradlistwin.StayOnTop1Click(Sender: Tobject);
Begin
  StayOnTop1.Checked := Not StayOnTop1.Checked;
  If StayOnTop1.Checked Then
    Radlistwin.Formstyle := Fsstayontop
  Else
    Radlistwin.Formstyle := FsNormal;
End;

Procedure Tradlistwin.ShowHints1Click(Sender: Tobject);
Begin
  ShowHints1.Checked := Not ShowHints1.Checked;
  Radlistwin.ShowHint := ShowHints1.Checked;
End;

Procedure Tradlistwin.Help1Click(Sender: Tobject);
Begin
  Application.HelpContext(HelpContext);
End;

Procedure Tradlistwin.PopupMenu1Popup(Sender: Tobject);
Begin
  MnuToolbar.Checked := PToolbar.Visible;
End;

Procedure Tradlistwin.FormShow(Sender: Tobject);
Begin
  Sizethecolumns;
End;

End.
