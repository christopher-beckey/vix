Unit FmagFilterSaveAs;
   {
   Package: MAG - VistA Imaging
   WARNING: Per VHA Directive 10-93-142 this unit should not be modified.
   Date Created:
   Site Name: Silver Spring, OIFO
   Developers: Garrett Kirin
   Description: User can save a Filter as a new filter, or they are allowed to
      overwrite an existing filter (of their own)
      If overwritting, they will be prompted to confirm they want to overwrite.
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
  ComCtrls,
  Controls,
  Forms,
  Stdctrls
  ;

//Uses Vetted 20090929:Graphics, SysUtils, Messages, Windows, umagutils, Dialogs

Type
  TfrmFilterSaveAs = Class(TForm)
    btnSave: TBitBtn;
    btnCancel: TBitBtn;
    EdtSaveAs: TEdit;
    LbHeader: Tlabel;
    LbPrompt: Tlabel;
    LvSaveAs: TListView;
    Procedure btnSaveClick(Sender: Tobject);
    Procedure LvSaveAsSelectItem(Sender: Tobject; Item: TListItem;
      Selected: Boolean);
  Private
    FSaveAsText: String;
    FSaveAsIEN: String;
    FStopOverWrite: Boolean;
    { Private declarations }
  Public
    Function Execute(Sellist: TStrings; SaCaption, SaPrompt: String; StopOverWrite: Boolean; Var DftName: String; Var DftIEN: String; VForm: TForm): Boolean;

  End;

Var
  FrmFilterSaveAs: TfrmFilterSaveAs;

Implementation
Uses
  Dialogs,
  Umagutils8
  ;

{$R *.DFM}

Function TfrmFilterSaveAs.Execute(Sellist: TStrings; SaCaption, SaPrompt: String; StopOverWrite: Boolean; Var DftName: String; Var DftIEN: String; VForm: TForm): Boolean;
Var
  i: Integer;
  Li: TListItem;
Begin
  With TfrmFilterSaveAs.Create(VForm) Do
  Begin
    Position := PoOwnerFormCenter;
    FSaveAsText := DftName;
    FSaveAsIEN := '';
    FStopOverWrite := StopOverWrite;
      //left := vForm.Left + (vForm.width div 2) - (width div 2);
    EdtSaveAs.Text := DftName;
 //lstSaveAs.Items.AddStrings(sellist);
    LbPrompt.caption := SaPrompt;
    caption := SaCaption;
    LvSaveAs.Items.Clear;
    For i := 0 To Sellist.Count - 1 Do
    Begin
      Li := LvSaveAs.Items.Add;
      Li.caption := MagPiece(Sellist[i], '^', 1);
      Li.SubItems.Add(MagPiece(Sellist[i], '^', 2));
    End;
 // edtSaveAs.SetFocus;
    If Showmodal = MrOK Then
    Begin
      DftName := EdtSaveAs.Text;
      DftIEN := FSaveAsIEN;
      Result := True;
    End
    Else
      Result := False;
  End;
  Free;
End;

Procedure TfrmFilterSaveAs.btnSaveClick(Sender: Tobject);
Var
  Li: TListItem;
Begin
  EdtSaveAs.Text := Magstripspaces(EdtSaveAs.Text);
  If EdtSaveAs.Text = '' Then
  Begin
    Messagedlg('You must enter a Name.', Mtconfirmation, [Mbok], 0);
    Exit;
  End;
  If EdtSaveAs.Text = FSaveAsText Then
  Begin
    ModalResult := MrOK;
    Exit;
  End;
  Li := LvSaveAs.FindCaption(0, EdtSaveAs.Text, False, True, True);
  If Li <> Nil Then
  Begin
    If FStopOverWrite Then
    Begin
      Messagedlg('Filter: "' + EdtSaveAs.Text + '" exists' + #13 + 'Overwriting Public Filters is not allowed.', Mtconfirmation, [Mbok], 0);
      Exit;
    End;
    If Messagedlg('Filter: "' + EdtSaveAs.Text + '" exists.  OK to Overwrite ? ', Mtconfirmation, [Mbok, Mbcancel], 0) = MrOK Then
    Begin
      FSaveAsIEN := Li.SubItems[0];
      ModalResult := MrOK;
    End
    Else
      Exit;
  End;
  ModalResult := MrOK;

End;

Procedure TfrmFilterSaveAs.LvSaveAsSelectItem(Sender: Tobject;
  Item: TListItem; Selected: Boolean);
Begin
  If LvSaveAs.Selected <> Nil Then
    EdtSaveAs.Text := LvSaveAs.Selected.caption;
End;

End.
