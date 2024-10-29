Unit FMagFMSetSelect;

Interface

Uses
  Buttons,
  Classes,
  Controls,
  ExtCtrls,
  Forms,
  Stdctrls,
  UMagDefinitions
  ;

//Uses Vetted 20090929:umagclasses, Dialogs, Graphics, Variants, Messages, Windows, umagutils, SysUtils

Type
  TfrmFMSetSelect = Class(TForm)
    BitBtn1: TBitBtn;
    BitBtn2: TBitBtn;
    PnlSelectLists: Tpanel;
    Lstchoice: TListBox;
    btnSelAll: TSpeedButton;
    btnSelSelected: TSpeedButton;
    btnRemoveSelected: TSpeedButton;
    RemoveAll: TSpeedButton;
    LstSel: TListBox;
    Label2: Tlabel;
    Label1: Tlabel;
    Label3: Tlabel;
    Procedure btnSelAllClick(Sender: Tobject);
    Procedure btnSelSelectedClick(Sender: Tobject);
    Procedure btnRemoveSelectedClick(Sender: Tobject);
    Procedure RemoveAllClick(Sender: Tobject);
    Procedure LstSelDblClick(Sender: Tobject);
    Procedure LstchoiceDblClick(Sender: Tobject);
    Procedure LstchoiceKeyDown(Sender: Tobject; Var Key: Word;
      Shift: TShiftState);
    Procedure LstSelKeyDown(Sender: Tobject; Var Key: Word;
      Shift: TShiftState);
    Procedure lstchoiceEnter(Sender: Tobject);
    Procedure lstSelEnter(Sender: Tobject);
  Private
    Procedure ShowCurrentSelections(Values: String);
    Procedure HideExcludedSelections(CantSelect: String);
    Function GetCurrentSelections: String;
    Procedure SelectedChoicesToSelected;
    Procedure RemoveItemFromSelected;
  Public
    Function Execute(FMSet: TImageFMSet; Values: String = ''; MultSelectOK: Boolean = True; Excluded: String = ''): String;
  End;

Var
  FrmFMSetSelect: TfrmFMSetSelect;

Implementation
Uses
  SysUtils,
  Umagutils8
  ;

{$R *.dfm}

{ TfrmFMSetSelect }
    {   }

Function TfrmFMSetSelect.Execute(FMSet: TImageFMSet; Values: String = ''; MultSelectOK: Boolean = True; Excluded: String = ''): String;
Var
  t: TStrings;
  CantSelect, s: String;
  i, j: Integer;
Begin
  With TfrmFMSetSelect.Create(Nil) Do
  Begin
    caption := FMSet.DBSetName + ' Selection:';
    //if (values = '') or (values = '<any status>') or (values = '<any>') then
    If ((Values = '')
      Or (Uppercase(Copy(Values, 1, 4)) = '<ANY')
      Or (Uppercase(Copy(Values, 1, 4)) = '<ALL')
      Or (Uppercase(Copy(Values, 1, 4)) = 'ANY ')
      Or (Uppercase(Copy(Values, 1, 4)) = 'ALL ')) Then
    Begin
      Lstchoice.Items.Assign(FMSet.GetListOfExternalValues);
    End
    Else
    Begin
      Lstchoice.Items.Assign(FMSet.GetListOfExternalValues);
     //resize the window based on length of entries.
      ShowCurrentSelections(Values);
     // cantselect := 'Deleted';
    End;
    HideExcludedSelections(Excluded);
    If Showmodal = MrOK Then
    Begin
      If ((LstSel.Count = 0) Or (Lstchoice.Count = 0))
        {   Set Result to '' for all selections on either side}Then
        Result := ''
        {return the list of current values that were sent.}
      Else
        Result := GetCurrentSelections;
        {if mrCancel, the same values will be returned  }
    End
    Else
      Result := Values;
  End;
End;

Function TfrmFMSetSelect.GetCurrentSelections(): String;
Var
  i: Integer;
Begin
  Result := '';
  For i := 0 To LstSel.Count - 1 Do
    Result := Result + ',' + LstSel.Items[i];
  Result := Copy(Result, 2, 99999);
End;

Procedure TfrmFMSetSelect.ShowCurrentSelections(Values: String);
Var
  i: Integer;
  s: String;
Begin
  For i := 0 To Maglength(Values, ',') Do
  Begin
    s := MagPiece(Values, ',', i);
    If (s = '') Or (s = '<any status>') Then
      Continue;
    If Lstchoice.Items.Indexof(s) <> -1 Then
      Lstchoice.Items.Delete(Lstchoice.Items.Indexof(s));
    If LstSel.Items.Indexof(s) = -1 Then
      LstSel.Items.Add(s);
  End;
End;

Procedure TfrmFMSetSelect.btnSelAllClick(Sender: Tobject);
Var
  i: Integer;
Begin
  For i := 0 To Lstchoice.Items.Count - 1 Do
    If LstSel.Items.Indexof(Lstchoice.Items[i]) = -1 Then
      LstSel.Items.Add(Lstchoice.Items[i]);
  Lstchoice.Items.Clear; {JK 1/8/2009 - remove all items from the lstChoice side}
End;

Procedure TfrmFMSetSelect.btnSelSelectedClick(Sender: Tobject);
Begin
  SelectedChoicesToSelected;
End;

Procedure TfrmFMSetSelect.btnRemoveSelectedClick(Sender: Tobject);
Begin
  {JK 1/8/2009 - allow items to move and be removed}
  If LstSel.ItemIndex <> -1 Then
  Begin
    If Lstchoice.Items.Indexof(LstSel.Items[LstSel.ItemIndex]) = -1 Then
    Begin
      Lstchoice.Items.Add(LstSel.Items[LstSel.ItemIndex]);
      LstSel.DeleteSelected;
    End;
  End;
End;

Procedure TfrmFMSetSelect.RemoveAllClick(Sender: Tobject);
Var
  i: Integer;
Begin
  For i := 0 To LstSel.Items.Count - 1 Do
    If Lstchoice.Items.Indexof(LstSel.Items[i]) = -1 Then
      Lstchoice.Items.Add(LstSel.Items[i]);
  LstSel.Items.Clear; {JK 1/8/2009 - remove all items from the lstSel side}
End;

Procedure TfrmFMSetSelect.LstSelDblClick(Sender: Tobject);
Begin
  RemoveItemFromSelected;
  Exit;
  If LstSel.ItemIndex <> -1 Then
  Begin
    Lstchoice.Items.Add(LstSel.Items[LstSel.ItemIndex]);
    LstSel.DeleteSelected;
  End;
End;

Procedure TfrmFMSetSelect.LstchoiceDblClick(Sender: Tobject);
Begin
  SelectedChoicesToSelected;
End;

Procedure TfrmFMSetSelect.SelectedChoicesToSelected;
Var
  i: Integer;
Begin
  {JK 1/8/2009 - allow items to move and be removed}
  If Lstchoice.ItemIndex <> -1 Then
  Begin
    If LstSel.Items.Indexof(Lstchoice.Items[Lstchoice.ItemIndex]) = -1 Then
    Begin
      LstSel.Items.Add(Lstchoice.Items[Lstchoice.ItemIndex]);
      Lstchoice.DeleteSelected;
    End;
  End;
End;

Procedure TfrmFMSetSelect.LstchoiceKeyDown(Sender: Tobject; Var Key: Word;
  Shift: TShiftState);
Begin
  Case Key Of
    39: SelectedChoicesToSelected;
  End;
End;

Procedure TfrmFMSetSelect.LstSelKeyDown(Sender: Tobject; Var Key: Word;
  Shift: TShiftState);
Begin
  Case Key Of
    37: RemoveItemFromSelected;
  End;
End;

Procedure TfrmFMSetSelect.RemoveItemFromSelected;
Begin
  If LstSel.ItemIndex = -1 Then Exit;

  Lstchoice.Items.Add(LstSel.Items[LstSel.ItemIndex]);
  LstSel.DeleteSelected;
End;

{JK 1/8/2009 - Added the "all" option}

Procedure TfrmFMSetSelect.HideExcludedSelections(CantSelect: String);
Var
  i: Integer;
  s: String;
Begin
  For i := 0 To Maglength(CantSelect, ',') Do
  Begin
    s := MagPiece(CantSelect, ',', i);
    If (s = '') Or (s = '<any status>') Then
      Continue;
    If Lstchoice.Items.Indexof(s) <> -1 Then
      Lstchoice.Items.Delete(Lstchoice.Items.Indexof(s));
    If LstSel.Items.Indexof(s) <> -1 Then
      LstSel.Items.Delete(LstSel.Items.Indexof(s));
//    if lstSel.Items.IndexOf(s) = -1 then
//      lstSel.Items.Add(s);
  End;
End;

Procedure TfrmFMSetSelect.lstchoiceEnter(Sender: Tobject);
Begin
  LstSel.ItemIndex := -1;
End;

Procedure TfrmFMSetSelect.lstSelEnter(Sender: Tobject);
Begin
  Lstchoice.ItemIndex := -1;
End;

End.
