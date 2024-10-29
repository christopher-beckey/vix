Unit Mdlgridu;

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
  Timagegrid = Class(TForm)
    Stg1: TStringGrid;
    SortList: TListBox;
    BaseList: TListBox;
    PToolbar: Tpanel;
    ShowImage: TBitBtn;
    Setcollength: TBitBtn;
    PopupMenu1: TPopupMenu;
    Columnsize1: TMenuItem;
    ToolBar1: TMenuItem;
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
    wintype: TEdit;
    Pinfo: Tpanel;
    DFN: TEdit;
    Sortlistbyindex1: TMenuItem;
    Inverseorder1: TMenuItem;
    N4: TMenuItem;
    N5: TMenuItem;
    Report1: TMenuItem;
    bHelp: TBitBtn;
    Lmsg: Tlabel;
    Procedure Stg1ColumnMoved(Sender: Tobject; FromIndex,
      ToIndex: Longint);
    Procedure Stg1KeyPress(Sender: Tobject; Var Key: Char);

    Procedure SetcollengthClick(Sender: Tobject);
    Procedure Stg1DblClick(Sender: Tobject);
    Procedure Stg1KeyDown(Sender: Tobject; Var Key: Word;
      Shift: TShiftState);
    Procedure Columnsize1Click(Sender: Tobject);
    Procedure ToolBar1Click(Sender: Tobject);
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
  End;

Var
  imagegrid: Timagegrid;
  Dftheight: Integer;

Implementation
Uses magvnetu;
{$R *.DFM}

Procedure Timagegrid.Stg1ColumnMoved(Sender: Tobject; FromIndex,
  ToIndex: Longint);
Begin
  If RowSorting1.Checked Then SortTheList;
  ImageMain.LogActions(wintype.Text, 'COLMOVED', DFN.Text);
End;

Procedure Timagegrid.Stg1KeyPress(Sender: Tobject; Var Key: Char);
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
  ImageMain.LogActions(wintype.Text, 'KEYPRESS', DFN.Text);
End;

Procedure Timagegrid.SortTheList;
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

Procedure Timagegrid.Msg(s: String);
Begin
(*  pmsg.caption := s;
pmsg.update;   *)
End;

Function Timagegrid.ListToGrid: Integer;
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

Procedure Timagegrid.SetcollengthClick(Sender: Tobject);
Begin
  If DFN.Text = '' Then Exit;
  Sizethecolumns;
End;

Procedure Timagegrid.Sizethecolumns;
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

Procedure Timagegrid.Stg1DblClick(Sender: Tobject);
Var
  s: String;
Begin
  If (PatName1 <> 'Demo,Patient') And (DFN.Text = '') Then Exit;

  s := Stg1.Cells[0, Stg1.Row];
  If s = '' Then Exit;

  Stg1.Enabled := False;
  Stg1.Update;
  PToolbar.Enabled := False;
  PToolbar.Update;
  Lmsg.caption := 'Loading...';
  Lmsg.Update;

  ImageMain.LogActions(wintype.Text, 'IMAGE', 'DFN-' + DFN.Text);
  Msg(s);
  If wintype.Text = 'rad' Then ImageMain.Radexamselected(s);
  If wintype.Text = 'imagelist' Then ImageMain.Imagefromlist(Strtoint(s) - 1);

  Stg1.Enabled := True;
  Stg1.Update;
  PToolbar.Enabled := True;
  Lmsg.caption := '';
  Lmsg.Update;

  If Maintainfocus1.Checked Then Stg1.SetFocus;

End;

Procedure Timagegrid.Stg1KeyDown(Sender: Tobject; Var Key: Word;
  Shift: TShiftState);
Begin
  If Key = VK_Return Then
  Begin
    Stg1DblClick(Sender);
    ImageMain.LogActions(wintype.Text, 'RETURN', DFN.Text);
  End;
End;

Procedure Timagegrid.Clear;
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

Procedure Timagegrid.MakeMDIChild;
Begin
  ImageMain.Hide;
  imagegrid.Hide;
  imagegrid.Formstyle := fsMDIChild;
  ImageMain.tile;
  ImageMain.window1.Visible := True;
  ImageMain.Show;
  imagegrid.Show;

End;

Procedure Timagegrid.MakeStandAlone;
Begin
  imagegrid.Formstyle := FsNormal;
End;

Procedure Timagegrid.Columnsize1Click(Sender: Tobject);
Begin
  Sizethecolumns;
End;

Procedure Timagegrid.ToolBar1Click(Sender: Tobject);
Begin
  ToolBar1.Checked := Not ToolBar1.Checked;
  PToolbar.Visible := ToolBar1.Checked;
End;

Procedure Timagegrid.bdftHeightClick(Sender: Tobject);
Begin
  Height := Dftheight;
End;

Procedure Timagegrid.bStretchClick(Sender: Tobject);
Begin
  Dftheight := Height;
  Height := Screen.Height - Top;
End;

Procedure Timagegrid.Maintainfocus1Click(Sender: Tobject);
Begin
  Maintainfocus1.Checked := Not Maintainfocus1.Checked;
End;

Procedure Timagegrid.ShowreportClick(Sender: Tobject);
Var
  s: String;
  i: Integer;
Begin
  If (PatName1 <> 'Demo,Patient') And (DFN.Text = '') Then Exit;
  s := Stg1.Cells[0, Stg1.Row];
  If s = '' Then Exit;
  Msg(s);
  ImageMain.LogActions(wintype.Text, 'REPORT', 'DFN-' + DFN.Text);

  If wintype.Text = 'imagelist' Then
  Begin
    ARecord[1] := Mylist.Items[Strtoint(Stg1.Cells[0, Stg1.Row]) - 1];
    imagemain.BuildReport(ARecord[1]^.Mag0, '', 'Image Report');
  End;

  If wintype.Text = 'rad' Then ImageMain.radexamreport(Stg1.Cells[0, Stg1.Row]);

  If Maintainfocus1.Checked Then Stg1.SetFocus;

End;

Procedure Timagegrid.GoToMainWindow1Click(Sender: Tobject);
Begin
  ImageMain.Focustomain;
End;

Procedure Timagegrid.FormCreate(Sender: Tobject);
Begin
  Dftheight := Height;
End;

Procedure Timagegrid.Sortlistbyindex1Click(Sender: Tobject);
Var
  uprefgrid: Boolean;
  i, j: Integer;
Begin
  If wintype.Text = 'rad' Then
  Begin
    For i := Stg1.RowCount - 1 Downto 1 Do
    Begin
      For j := 0 To Stg1.ColCount - 1 Do
        Stg1.Cells[j, i] := '';
    End;
    SortList.Clear;
    BaseList.Clear;
    Imagemain.Listtoradlistwin;
    Radlistwin.caption := 'Radiology Exam listing  : ' + PatName1;
    Radlistwin.DFN.Text := MagDFN;
  End;
  If wintype.Text = 'imagelist' Then
  Begin
    uprefgrid := Upref.getimagegrid;
    Upref.getimagegrid := False;
    Imagemain.ListToDetailGridList;
    Upref.getimagegrid := uprefgrid;
  End;

End;

Procedure Timagegrid.Inverseorder1Click(Sender: Tobject);
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

Procedure Timagegrid.Report1Click(Sender: Tobject);
Begin
  ShowReport.Click;
End;

Procedure TImageGrid.WMMOVE(Var Message: TWMMOVE);
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

Procedure Timagegrid.FormResize(Sender: Tobject);
Begin
  If (Width Mod 10 > 0) Or (Height Mod 10 > 0) Then
  Begin
    SetBounds(Left, Top, Width - (Width Mod 10), Height - (Height Mod 10));
  End;
End;

Procedure Timagegrid.FormKeyDown(Sender: Tobject; Var Key: Word;
  Shift: TShiftState);
Begin
  If (Shift = [Ssctrl]) And (Key = VK_tab) Then
    PopupMenu1.Popup(Left + 20, Top + 50);

End;

Procedure Timagegrid.bHelpClick(Sender: Tobject);
Begin
  Application.HelpContext(bHelp.HelpContext);
End;

End.
