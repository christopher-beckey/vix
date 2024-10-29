Unit FmagVideoOptions;
   {
   Package: MAG - VistA Imaging
   WARNING: Per VHA Directive 10-93-142 this unit should not be modified.
   Date Created:
   Site Name: Silver Spring, OIFO
   Developers: Garrett Kirin
   Description: Imaging Video Player options dialog.
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
  Forms,
  Stdctrls,
  Classes,
  Controls
  ;

//Uses Vetted 20090929:maggut1, umagutils, Dialogs, Controls, Graphics, Classes, SysUtils, Messages, Windows,

Type
  TfrmVideoOptions = Class(TForm)
    cbPlayonSelect: TCheckBox;
    RbAltVideoPlayer: TRadioButton;
    RbMagVideoPlayer: TRadioButton;
    BitBtn1: TBitBtn;
    Procedure RbAltVideoPlayerClick(Sender: Tobject);
    Procedure RbMagVideoPlayerClick(Sender: Tobject);
    Procedure BitBtn1Click(Sender: Tobject);
    Procedure FormCreate(Sender: Tobject);
    Procedure FormDestroy(Sender: Tobject);
  Private
    { Private declarations }
  Public
    Procedure GetOptions(Var Usealtviewer, Playvideofile: Boolean);
  End;

Var
  FrmVideoOptions: TfrmVideoOptions;

Implementation

{$R *.DFM}

Procedure TfrmVideoOptions.RbAltVideoPlayerClick(Sender: Tobject);
Begin
  cbPlayonSelect.Enabled := False;
End;

Procedure TfrmVideoOptions.RbMagVideoPlayerClick(Sender: Tobject);
Begin
  cbPlayonSelect.Enabled := True;
End;

Procedure TfrmVideoOptions.BitBtn1Click(Sender: Tobject);
Begin
  Close;
End;

Procedure TfrmVideoOptions.FormCreate(Sender: Tobject);
//var Use, Play: string;
Begin
  { Use := GetIniEntry('Workstation settings', 'Use Alternate Video Viewer');
   Play := GetIniEntry('Workstation settings', 'Play Video File');
   if uppercase(use) = 'TRUE' then rbAltVideoPlayer.checked := true;
   if uppercase(play) = 'TRUE' then cbPlayonSelect.checked := true;}
End;

Procedure TfrmVideoOptions.FormDestroy(Sender: Tobject);
//var Use, Play: string;
Begin
  {  if rbAltVideoPlayer.checked then use := 'TRUE'
    else use := 'FALSE';
    if cbPlayonSelect.checked then play := 'TRUE'
    else play := 'FALSE';
    SetIniEntry('Workstation settings', 'Use Alternate Video Viewer', use);
    SetIniEntry('Workstation settings', 'Play Video File', play);}
End;

Procedure TfrmVideoOptions.GetOptions(Var Usealtviewer, Playvideofile: Boolean);
Begin
  FrmVideoOptions := TfrmVideoOptions.Create(Application.MainForm);
  Try
    With FrmVideoOptions Do
    Begin
      RbAltVideoPlayer.Checked := Usealtviewer;
      cbPlayonSelect.Checked := Playvideofile;
      cbPlayonSelect.Enabled := Not Usealtviewer;
      FrmVideoOptions.Showmodal;
      Usealtviewer := RbAltVideoPlayer.Checked;
      Playvideofile := cbPlayonSelect.Checked;
    End;
  Finally
    FrmVideoOptions.Free;
  End;
End;

End.
