Unit fMagNumberSelect;
{
  Package: MAG - VistA Imaging
  WARNING: Per VHA Directive 2004-038, this routine should not be modified.
  Date created: May 2006
  Site Name:  Washington OI Field Office, Silver Spring, MD
  Developer:  Julian Werfel
  Description: Generic number selection dialog. Allows the user to select a
    number in a specified range. Prevents user from selecting a non-number value
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
        ;;+---------------------------------------------------------------------------------------------------+
*)
Interface

Uses
  Buttons,
  Controls,
  ExtCtrls,
  Forms,
  Stdctrls,
  Classes
  ;

//Uses Vetted 20090930:Dialogs, Graphics, Classes, Variants, Messages, Windows, SysUtils

Type
  TfrmNumberSelect = Class(TForm)
    lblCaption: Tlabel;
    PnlBottom: Tpanel;
    btnCancel: TBitBtn;
    btnOK: TBitBtn;
    cboValues: TComboBox;
    Procedure btnCancelClick(Sender: Tobject);
    Procedure btnOKClick(Sender: Tobject);
    Procedure FormCreate(Sender: Tobject);
  Private
    { Private declarations }
  Public
    Function Execute(Title: String; caption: String; MinValue: Integer; MaxValue: Integer; DefaultValue: Integer = 0): Integer;
    { Public declarations }
  End;

Var
  frmNumberSelect: TfrmNumberSelect;

Implementation
Uses
  SysUtils
  ;

{$R *.dfm}

Function TfrmNumberSelect.Execute(Title: String; caption: String; MinValue: Integer; MaxValue: Integer; DefaultValue: Integer = 0): Integer;
Var
  i, ind, indexValue: Integer;
Begin
  Self.caption := Title;
  lblCaption.caption := caption;
  cboValues.Clear();

  If MaxValue < MinValue Then
    MaxValue := MinValue;

  If DefaultValue < MinValue Then
    DefaultValue := MinValue;
  indexValue := 0;
  For i := MinValue To MaxValue Do
  Begin
    ind := cbovalues.Items.Add(Inttostr(i));
    If i = DefaultValue Then
      indexValue := ind;
  End;
  cbovalues.ItemIndex := indexValue;

  Result := DefaultValue;
  Showmodal();
  If ModalResult = MrOK Then
  Begin
    Result := Strtoint(cbovalues.Items[cbovalues.ItemIndex]);
  End;
End;

Procedure TfrmNumberSelect.btnCancelClick(Sender: Tobject);
Begin
  ModalResult := MrCancel;
End;

Procedure TfrmNumberSelect.btnOKClick(Sender: Tobject);
Begin
  ModalResult := MrOK;
End;

Procedure TfrmNumberSelect.FormCreate(Sender: Tobject);
Begin
  lblCaption.Align := alClient;
End;

End.
