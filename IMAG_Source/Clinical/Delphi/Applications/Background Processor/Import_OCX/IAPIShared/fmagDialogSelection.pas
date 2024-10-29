Unit FmagDialogSelection;
   {
   Package: MAG - VistA Imaging
   WARNING: Per VHA Directive 10-93-142 this unit should not be modified.
   Date Created:
   Site Name: Silver Spring, OIFO
   Developers: Garrett Kirin
   Description: User can select from a list of 'names'  if overwrite is allowed
       and they select an existing name, they will be prompted to confirm they
       want to overwrite.
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
  cMagListView,
  ComCtrls,
  Controls,
  ExtCtrls,
  Forms,
  Stdctrls
  ;

//Uses Vetted 20090929:Graphics, SysUtils, Messages, Windows, umagutils8, Dialogs

Type
  TfrmDialogSelection = Class(TForm)
    LbHeader: Tlabel;
    LvSaveAs: TListView;
    Panel1: Tpanel;
    LbPrompt: Tlabel;
    btnOK: TBitBtn;
    btnCancel: TBitBtn;
    EdtSelected: TEdit;
    cbApply: TCheckBox;
    Procedure btnOKClick(Sender: Tobject);
    Procedure LvSaveAsSelectItem(Sender: Tobject; Item: TListItem;
      Selected: Boolean);
    Procedure cbApplyClick(Sender: Tobject);
  Private
    FMagListView: TMagListView;
    FSaveAsText: String;
    FSaveAsIEN: String;
    Procedure ApplyColumnSet;
    { Private declarations }
  Public
    Function Execute(LV: TMagListView; Selectlist: TStrings; SaCaption, SaHeader, SaPrompt: String; Var SelectedName: String; Var SelectedIEN: String): Boolean;

  End;

Var
  FrmDialogSelection: TfrmDialogSelection;

Implementation
Uses
  Dialogs,
  Umagutils8
  ;

{$R *.DFM}

Function TfrmDialogSelection.Execute(LV: TMagListView; Selectlist: TStrings; SaCaption, SaHeader, SaPrompt: String; Var SelectedName: String; Var SelectedIEN: String): Boolean;
Var
  i: Integer;
  Li: TListItem;
Begin

  With TfrmDialogSelection.Create(Self) Do
  Begin
    FMagListView := LV;
    Position := PoOwnerFormCenter;
    FSaveAsText := SelectedName;
    FSaveAsIEN := '';
      //left := vForm.Left + (vForm.width div 2) - (width div 2);

 //lstSaveAs.Items.AddStrings(selectlist);
    caption := SaCaption;
    LbHeader.caption := SaHeader;
    LbPrompt.caption := SaPrompt;
    LvSaveAs.Items.Clear;
    For i := 0 To Selectlist.Count - 1 Do
    Begin
      Li := LvSaveAs.Items.Add;
      Li.caption := MagPiece(Selectlist[i], '^', 1);
      Li.SubItems.Add(MagPiece(Selectlist[i], '^', 2));
    End;
 // edtSaveAs.SetFocus;
    If Showmodal = MrOK Then
    Begin
      SelectedName := EdtSelected.Text;
      SelectedIEN := FSaveAsIEN;
      Result := True;
    End
    Else
      Result := False;
  End;
  Free;
End;

Procedure TfrmDialogSelection.btnOKClick(Sender: Tobject);
Var
  Li: TListItem;
Begin

  If EdtSelected.Text = '' Then
  Begin
    Messagedlg('Select an Entry from the list.', Mtconfirmation, [Mbok], 0);
    Exit;
  End;
  Li := LvSaveAs.FindCaption(0, EdtSelected.Text, False, True, True);
  If Li <> Nil Then
  Begin
    FSaveAsIEN := Li.SubItems[0];
    ModalResult := MrOK;
    Exit;
  End;
End;

Procedure TfrmDialogSelection.LvSaveAsSelectItem(Sender: Tobject; Item: TListItem; Selected: Boolean);
Begin
  If LvSaveAs.Selected <> Nil Then
    EdtSelected.Text := LvSaveAs.Selected.caption;
  If cbApply.Checked Then ApplyColumnSet;
End;

Procedure TfrmDialogSelection.ApplyColumnSet;
Var
  FldSetvalue: String;
Begin
  FldSetvalue := GetIniEntry('Field Set', EdtSelected.Text);
  If FldSetvalue = '' Then Exit;
  FMagListView.ColumnSetApply(FldSetvalue);
  FMagListView.FitColumnsToForm;
End;

Procedure TfrmDialogSelection.cbApplyClick(Sender: Tobject);
Begin
  If cbApply.Checked Then Self.ApplyColumnSet;
End;

End.
