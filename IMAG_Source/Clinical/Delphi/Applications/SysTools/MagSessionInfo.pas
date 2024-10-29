Unit MagSessionInfo;

Interface

Uses
  Windows,
  Messages,
  SysUtils,
  Classes,
  Graphics,
  Controls,
  Forms,
  Dialogs,
  Stdctrls,
  ExtCtrls,
  ComCtrls,
  Umagutils8,
  Menus
  ;

Type
  TMagSessionInfoform = Class(TForm)
    Panel3: Tpanel;
    lbErrors: Tlabel;
    ErrorsList: TListBox;
    PopupMenu1: TPopupMenu;
    List1: TMenuItem;
    Details1: TMenuItem;
    Panel5: Tpanel;
    ListView1: TListView;
    Panel2: Tpanel;
    ActionsList: TListBox;
    Panel4: Tpanel;
    lbactions: Tlabel;
    LbCount: Tlabel;
    Label2: Tlabel;
    Splitter1: TSplitter;
    StatusBar1: TStatusBar;
    Label1: Tlabel;
    Procedure Details1Click(Sender: Tobject);
    Procedure List1Click(Sender: Tobject);
    Procedure ListView1ColumnClick(Sender: Tobject; Column: TListColumn);
    Procedure ListView1Compare(Sender: Tobject; Item1, Item2: TListItem;
      Data: Integer; Var Compare: Integer);
    Procedure ListView1Click(Sender: Tobject);
    Procedure FormCreate(Sender: Tobject);
  Private
    Procedure ClearAll;
    Procedure SessionDisplay(t: Tstringlist);
    { Private declarations }
  Public

    Procedure DataToSessionView(t: Tstringlist; daterange: String);
  End;

Var
  MagSessionInfoform: TMagSessionInfoform;
Const
  curColumnindex: Integer = 0;
Const
  Inverse: Boolean = False;
Implementation

Uses magwrkslistview;

{$R *.DFM}

Procedure TMagSessionInfoForm.DataToSessionView(t: Tstringlist; daterange: String);
Var
  i, j: Integer;
  s: String;
Begin
  ClearAll;
  s := t[0];
  StatusBar1.Panels[0].Text := MagPiece(s, '^', 1);
  StatusBar1.Panels[1].Text := MagPiece(s, '^', 2) + '  ' + daterange;
  t.Delete(0);
  s := t[0];
  Show;
  If ListView1.Columns.Count < 2 Then
  Begin
    ListView1.Columns.Clear;
    ListView1.Columns.Add;
    ListView1.Columns[0].caption := MagPiece(s, '^', 1);
    ListView1.Columns[0].Width := -1;

    For i := 1 To Maglength(s, '^') - 1 Do
    Begin
      ListView1.Columns.Add;
      ListView1.Columns[i].caption := MagPiece(s, '^', i + 1);
      ListView1.Columns[i].Width := -2;
    End;
  End;
  t.Delete(0);

  For i := 0 To t.Count - 1 Do
  Begin
    s := t[i];
    ListView1.Items.Add;
    If (Uppercase(MagPiece(s, '^', 4)) = 'ACTIVE') Then
    Begin
      ListView1.Items[i].StateIndex := 4;
      ListView1.Items[i].caption := MagPiece(s, '^', 1) + ' [' + MagPiece(s, '^', 3) + ']';
    End
    Else
      ListView1.Items[i].caption := MagPiece(s, '^', 1);

    //lv.items[i].caption := magpiece(s,'^',1);
    ListView1.Items[i].ImageIndex := 0;

    For j := 2 To Maglength(s, '^') Do
      ListView1.Items[i].SubItems.Add(MagPiece(s, '^', j));
  End;

End;

Procedure TMagSessionInfoForm.ClearAll;
Begin
  ListView1.Items.Clear;
  ActionsList.Clear;
  ErrorsList.Clear;
  lbActions.caption := 'Actions/Errors';
  LbCount.caption := 'Count';
End;

Procedure TMagSessionInfoform.Details1Click(Sender: Tobject);
Begin
  ListView1.ViewStyle := Vsreport;
End;

Procedure TMagSessionInfoform.List1Click(Sender: Tobject);
Begin
  ListView1.ViewStyle := Vslist;
End;

Procedure TMagSessionInfoform.SessionDisplay(t: Tstringlist);
Var
  i: Integer;
//errors : boolean;
Begin
//errors := false;
//StatusBar1.panels[0].text := magpiece(t[0],'^',1);
//StatusBar1.panels[1].text := magpiece(t[0],'^',2) ;
  LbCount.caption := MagPiece(t[0], '^', 2);
  t.Delete(0);
  actionslist.Items.Add('[Actions]');
  For i := 0 To t.Count - 1 Do
  Begin
    //if ((not errors) and (t[i] = '[ERRORS]')) then
    //   begin
    //   errors := true;
    //   continue;
    //   end;
    //if errors then errorslist.items.add(t[i])
    //          else actionslist.items.add(t[i]);
    { next line instead of all above }
    If (t[i] = '[ERRORS]') Then actionslist.Items.Add('  ');
    actionslist.Items.Add(t[i]);
  End;
End;

Procedure TMagSessionInfoform.ListView1ColumnClick(Sender: Tobject;
  Column: TListColumn);
Begin
  Begin
    Inverse := Not Inverse;
    curcolumnindex := Column.Index;
    ListView1.CustomSort(Nil, 0);

  End;
End;

Procedure TMagSessionInfoform.ListView1Compare(Sender: Tobject; Item1,
  Item2: TListItem; Data: Integer; Var Compare: Integer);
Var

  Lic1, Lic2: String;
Begin
  If curcolumnindex = 0 Then
  Begin
    Lic1 := Item1.caption;
    Lic2 := Item2.caption;
  End
  Else
  Begin
    Lic1 := Item1.SubItems[curcolumnindex - 1];
    Lic2 := Item2.SubItems[curcolumnindex - 1];
  End;

(*Result := -lstrcmp(PChar(TListItem(Item1).Caption),
                     PChar(TListItem(Item2).Caption));*)
  If Inverse Then
    Compare := -Lstrcmp(PChar(Lic1), PChar(Lic2))
  Else
    Compare := Lstrcmp(PChar(Lic1), PChar(Lic2));
  Exit;

End;

Procedure TMagSessionInfoform.ListView1Click(Sender: Tobject);
Var
  sessien: Integer;
  sessinfo: String;
  t: Tstringlist;
  i: Integer;
  TLI: TListItem;
Begin
  TLI := ListView1.Selected;
  If (TLI = Nil) Then Exit;
  i := TLI.SubItems.Count;
  sessien := Strtoint(TLI.SubItems[i - 1]);
  sessinfo := TLI.caption + ' Logon  ' + TLI.SubItems[0];
  lbActions.caption := sessinfo;
  LbCount.caption := '';
  ActionsList.Clear;
  ActionsList.Update;
  ErrorsList.Clear;
  ErrorsList.Update;

  t := Tstringlist.Create;
  Try
    MagWrksListForm.MaggSysSessionDisplay(t, sessien);

    If ((t.Count = 0) Or (MagPiece(t[0], '^', 1) = '0')) Then
      //magsysf.Dmsg('No workstation info to display')
    Else
    Begin
      SessionDisplay(t);
    End;
  Finally
    t.Free;
  End;
End;

Procedure TMagSessionInfoform.FormCreate(Sender: Tobject);
Begin
  Panel5.Align := alClient;
End;

End.
