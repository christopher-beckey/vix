Unit FmagCapSaveConfig;
   {
   Package: MAG - VistA Imaging
   WARNING: Per VHA Directive 10-93-142 this unit should not be modified.
   Date Created:
   Site Name: Silver Spring, OIFO
   Developers: Garrett Kirin
   Description: Imaging Save Configuration Dialog box.
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
  Classes,
  Forms,
  Stdctrls,
  Controls
  ;

//Uses Vetted 20090929:Dialogs, Graphics, SysUtils, Messages, Windows, umagutils, Controls

Type
  TfrmCapSaveConfig = Class(TForm)
    cmboxConfig: TComboBox;
    Label1: Tlabel;
    Label2: Tlabel;
    btnOK: TBitBtn;
    btnCancel: TBitBtn;
    Procedure cmboxConfigChange(Sender: Tobject);
  Private
  Public
    Function Execute(CfgList: TStrings; Var Config: String): Boolean;

  End;

Var
  FrmCapSaveConfig: TfrmCapSaveConfig;

Implementation
Uses
  Umagutils8
  ;

{$R *.DFM}

Procedure TfrmCapSaveConfig.cmboxConfigChange(Sender: Tobject);
Begin
  If Copy(cmboxConfig.Text, 1, 1) = ' ' Then cmboxConfig.Text := '';

  btnOK.Enabled := (cmboxConfig.Text <> '')
End;

Function TfrmCapSaveConfig.Execute(CfgList: TStrings; Var Config: String): Boolean;
Var
  i: Integer;
Begin
  Result := False;
  //if cfglist.Count = 0 then exit;
  cmboxConfig.Items.Clear;
  For i := 0 To CfgList.Count - 1 Do
    cmboxConfig.Items.Add(MagPiece(CfgList[i], '^', 1));
  cmboxConfig.Text := Config;
  btnOK.Enabled := (Config <> '');
  Showmodal;
  If ModalResult = MrOK Then
  Begin
    Config := cmboxConfig.Text;
    Result := True;
  End
  Else
    Config := '';

End;

End.
