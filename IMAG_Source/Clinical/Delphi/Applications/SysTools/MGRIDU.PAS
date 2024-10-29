Unit Mgridu;

Interface

Uses
  SysUtils,
  WinTypes,
  WinProcs,
  Messages,
  Classes,
  Graphics,
  Controls,
  Forms,
  Dialogs,
  Stdctrls,
  Grids,
  ExtCtrls,
  Maggut1,
  Buttons,
  Menus;

Type
  Tutilgrid = Class(TForm)
    Stg1: TStringGrid;
    SortList: TListBox;
    BaseList: TListBox;
    PToolbar: Tpanel;
    Setcollength: TBitBtn;
    PopupMenu1: TPopupMenu;
    Columnsize1: TMenuItem;
    ToolBar1: TMenuItem;
    N1: TMenuItem;
    StretchHeight1: TMenuItem;
    DefaultHeight1: TMenuItem;
    bdftHeight: TBitBtn;
    bStretch: TBitBtn;
    RowSorting1: TCheckBox;
    wintype: TEdit;
    Pinfo: Tpanel;
    DFN: TEdit;
    Inverseorder1: TMenuItem;
    Lmsg: Tlabel;
    bbReset: TBitBtn;
    Procedure Stg1ColumnMoved(Sender: Tobject; FromIndex,
      ToIndex: Longint);
    Procedure Stg1KeyPress(Sender: Tobject; Var Key: Char);

    Procedure SetcollengthClick(Sender: Tobject);
    Procedure Columnsize1Click(Sender: Tobject);
    Procedure ToolBar1Click(Sender: Tobject);
    Procedure bdftHeightClick(Sender: Tobject);
    Procedure bStretchClick(Sender: Tobject);
    Procedure FormCreate(Sender: Tobject);
    Procedure Inverseorder1Click(Sender: Tobject);
    Procedure FormResize(Sender: Tobject);
    Procedure FormKeyDown(Sender: Tobject; Var Key: Word;
      Shift: TShiftState);
    Procedure bbResetClick(Sender: Tobject);
  Private
    Procedure WMMOVE(Var Message: TWMMOVE); Message WM_MOVE;
  Public
    Procedure Msg(s: String);
    Function ListToGrid: Integer;
    Procedure Sizethecolumns;
    Procedure SortTheList;
    Procedure MakeMDIChild;
    Procedure MakeStandAlone;
    Procedure Clear;
    Procedure ListToDetailGridList(t: Tstringlist);
  End;

Var
  utilgrid: Tutilgrid;
  Dftheight: Integer;

Implementation
{$R *.DFM}
Uses Magsysu;

Procedure Tutilgrid.Stg1ColumnMoved(Sender: Tobject; FromIndex,
  ToIndex: Longint);
Begin
  If RowSorting1.Checked Then SortTheList;
End;

Procedure Tutilgrid.Stg1KeyPress(Sender: Tobject; Var Key: Char);
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
End;

Procedure Tutilgrid.SortTheList;
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

Procedure Tutilgrid.Msg(s: String);
Begin
(*  pmsg.caption := s;
pmsg.update;   *)
End;

Function Tutilgrid.ListToGrid: Integer;
Var
  i, j, Jrow, k: Integer;
  Str: String;
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

Procedure Tutilgrid.SetcollengthClick(Sender: Tobject);
Begin
{if dfn.text = '' then exit;}
  Sizethecolumns;
End;

Procedure Tutilgrid.Sizethecolumns;
Var
  x, Xh, Xw: Integer;
  Rx, Cx: Integer;
  s: String;
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

Procedure Tutilgrid.Clear;
Var
  i, j: Integer;
Begin
  For i := 1 To Stg1.RowCount - 1 Do
  Begin
    For j := 1 To Stg1.RowCount - 1 Do
    Begin
      Stg1.Cells[j, i] := '';
    End;
  End;

  DFN.Text := '';
  SortList.Clear;
  BaseList.Clear;
  Stg1.RowCount := 2;
  Stg1.ColCount := 4;
  caption := 'Image Listing';
End;

Procedure Tutilgrid.MakeMDIChild;
Begin

End;

Procedure Tutilgrid.MakeStandAlone;
Begin
End;

Procedure Tutilgrid.Columnsize1Click(Sender: Tobject);
Begin
  Sizethecolumns;
End;

Procedure Tutilgrid.ToolBar1Click(Sender: Tobject);
Begin
  ToolBar1.Checked := Not ToolBar1.Checked;
  PToolbar.Visible := ToolBar1.Checked;
End;

Procedure Tutilgrid.bdftHeightClick(Sender: Tobject);
Begin
  Height := Dftheight;
End;

Procedure Tutilgrid.bStretchClick(Sender: Tobject);
Begin
  Dftheight := Height;
  Height := Screen.Height - Top;
End;

Procedure Tutilgrid.FormCreate(Sender: Tobject);
Begin
  Dftheight := Height;
End;

Procedure Tutilgrid.Inverseorder1Click(Sender: Tobject);
Var
  i, j: Integer;
  s, S1, Hd: String;
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

Procedure Tutilgrid.WMMOVE(Var Message: TWMMOVE);
Var
  p: TPoint;
  L, t: Integer;
Begin
{P := MAKEPOINT(Message.RESULT);
P := CLIENTTOSCREEN(P);}
  Message.Result := 0;
  If (Left < 0) Or (Top < 0) Or (Top Mod 10 > 0) Or (Left Mod 10 > 0) Then
  Begin
    L := Left;
    t := Top;
    If L < 0 Then L := 0;
    If t < 0 Then t := 0;
    If t Mod 10 > 0 Then t := t - (t Mod 10);
    If L Mod 10 > 0 Then L := L - (L Mod 10);
    SetBounds(L, t, Width, Height);
  End;
  Inherited;
End;

Procedure Tutilgrid.FormResize(Sender: Tobject);
Begin
  If (Width Mod 10 > 0) Or (Height Mod 10 > 0) Then
  Begin
    SetBounds(Left, Top, Width - (Width Mod 10), Height - (Height Mod 10));
  End;
End;

Procedure Tutilgrid.FormKeyDown(Sender: Tobject; Var Key: Word;
  Shift: TShiftState);
Begin
  If (Shift = [Ssctrl]) And (Key = VK_tab) Then
    PopupMenu1.Popup(Left + 20, Top + 50);

End;

Procedure Tutilgrid.ListToDetailGridList(t: Tstringlist);
Var
  i, j, k: Integer;
  Dt, s: String;

Begin
  utilgrid.Clear;
  utilgrid.caption := 'Workstation Listing :';
  BaseList.Items.Add('#^' + t[0]);
  For i := 1 To t.Count - 1 Do
    BaseList.Items.Add(Inttostr(i) + '^' + t[i]);

  utilgrid.ListToGrid;
{utilgrid.sizethecolumns;  }
End;

Procedure Tutilgrid.bbResetClick(Sender: Tobject);
Begin
  Magsysf.UpdateTheWrksList;
  Sizethecolumns;
End;

End.
