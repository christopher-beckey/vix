Unit FmagCapBatchAdv;
   {
   Package: MAG - VistA Imaging
   WARNING: Per VHA Directive 10-93-142 this unit should not be modified.
   Date Created:
   Site Name: Silver Spring, OIFO
   Developers: Garrett Kirin
   Description: Imaging Advanced Batch Capture options.
   (allows capture of images that can't be displayed, and sets of images
   set : all files with the same name, different extensions.  BIG,ABS,TXT etc.
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
  ExtCtrls,
  Forms,
  Stdctrls,
  Controls,
  Classes
  ;

//Uses Vetted 20090929:Dialogs, Controls, Graphics, Classes, SysUtils, Messages, Windows, umagutils

Type
  TfrmCapBatchAdv = Class(TForm)
    chkCopyAll: TCheckBox;
    cbxModality: TComboBox;
    btnClose: TBitBtn;
    chkEnable: TCheckBox;
    Bevel1: TBevel;
    LbModality: Tlabel;
    LbCopyAll: Tlabel;
    Procedure FormCreate(Sender: Tobject);
    Procedure chkEnableClick(Sender: Tobject);
    Procedure chkCopyAllClick(Sender: Tobject);
    Procedure cbxModalityChange(Sender: Tobject);
    Procedure LbCopyAllClick(Sender: Tobject);
  Private
    { Private declarations }
  Public
    FBatchAdvCopyAll, FBatchAdvEnable: Boolean;
    FBatchAdvModality: String;
  End;

Var
  FrmCapBatchAdv: TfrmCapBatchAdv;

Implementation
Uses
  Umagutils8
  ;

{$R *.DFM}

Procedure TfrmCapBatchAdv.FormCreate(Sender: Tobject);
Begin
{initialize the settings.}
  cbxModality.ItemIndex := -1;
  chkCopyAll.Checked := False;
  chkEnable.Checked := False;
  FBatchAdvCopyAll := False;
  FBatchAdvEnable := False;
  FBatchAdvModality := '';
End;

Procedure TfrmCapBatchAdv.chkEnableClick(Sender: Tobject);
Begin
  FBatchAdvEnable := chkEnable.Checked;
  cbxModality.Enabled := chkEnable.Checked;
  LbModality.Enabled := chkEnable.Checked;
  chkCopyAll.Enabled := chkEnable.Checked;
  LbCopyAll.Enabled := chkEnable.Checked;

End;

Procedure TfrmCapBatchAdv.cbxModalityChange(Sender: Tobject);
Begin
  If cbxModality.ItemIndex = -1 Then
    FBatchAdvModality := ''
  Else
    FBatchAdvModality := MagPiece(cbxModality.Items[cbxModality.ItemIndex], ' ', 1);

End;

Procedure TfrmCapBatchAdv.chkCopyAllClick(Sender: Tobject);
Begin
  FBatchAdvCopyAll := chkCopyAll.Checked;
End;

Procedure TfrmCapBatchAdv.LbCopyAllClick(Sender: Tobject);
Begin
  chkCopyAll.Checked := Not chkCopyAll.Checked;
    {       The above line will force chkCopyAllClick to execute }
    //FBatchAdvCopyAll := chkCopyall.Checked;
End;

End.
