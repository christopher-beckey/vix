unit fMAGSystemSettings;
{Package: MAG - VistA Imaging
WARNING: Per VHA Directive 10-93-142 this unit should not be modified.
Date Created: 08/2009
Site Name: Silver Spring, OIFO
Developers: Bill Balshem
[==   unit fMAGSystemSettings;
 Description: User can update Telerader system wide settings. At the time of initial creation of this unit, the only settings is TeleReader Application Timeout.
==]
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

interface

uses
  Windows, Messages, SysUtils, Variants, Classes, Graphics, Controls, Forms,
  Dialogs, StdCtrls, Buttons, ExtCtrls, VA508AccessibilityManager;

type
  TfrmSystemSettings = class(TForm)
    amgrMain: TVA508AccessibilityManager;
    Label1: TLabel;
    edtTimeout: TEdit;
    btnSave: TBitBtn;
    btnCancel: TBitBtn;
    imgTimeout: TImage;
    procedure edtTimeoutKeyPress(Sender: TObject; var Key: Char);
    procedure FormShow(Sender: TObject);
    procedure SetSaveButton(Sender: TObject);
    procedure  btnCancelClick(Sender: TObject);
    procedure btnSaveClick(Sender: TObject);
    function GetTimeout: string;
    procedure HelpClick(Sender: TObject);
    procedure FormKeyDown(Sender: TObject; var Key: Word;
      Shift: TShiftState);
    procedure FormClose(Sender: TObject; var Action: TCloseAction);
  private
    { Private declarations }
    bChange: boolean;
  public
    { Public declarations }
  end;

var
  frmSystemSettings: TfrmSystemSettings;

implementation

uses
  uMAGGlobalsTRA, dmMAGTeleReaderAdmin, MagFMComponents, trpcb, DiTypLib;

{$R *.dfm}

procedure TfrmSystemSettings.edtTimeoutKeyPress(Sender: TObject;
  var Key: Char);
begin
  if (Key in ['0'..'9']) or (Key = #13) or (Key = #8) then Key := Key
  else Key := #0
end;

function TfrmSystemSettings.GetTimeout: string;
begin
  DataModule1.Broker.RemoteProcedure := 'MAGG GET TIMEOUT';
  DataModule1.Broker.Param[0].ptype := literal;
  DataModule1.Broker.Param[0].value := 'TELEREADER';
  try
    result := DataModule1.Broker.strcall;
    MagLogger.Log('INFO', 'Retrieved current Telereader Application Timeout value.');
  except
    on e: exception do
    begin
      MagLogger.Log('ERROR', e.Message);
      raise;
    end;
  end;
end;

procedure TfrmSystemSettings.FormShow(Sender: TObject);
begin
  edtTimeOut.Text := GetTimeout;
  btnSave.Enabled := false;
  bChange := false;
  GetFormPosition(self);
end;

procedure TfrmSystemSettings.SetSaveButton(Sender: TObject);
begin
  bChange := true;
  btnSave.Enabled := true;
end;

procedure  TfrmSystemSettings.btnCancelClick(Sender: TObject);
begin
  if (not bChange) or (MessageDlg508(CancelSTR, mtConfirmation, [mbYes, mbNo], self.Handle)  = mrYes) then Close;
end;

procedure TfrmSystemSettings.btnSaveClick(Sender: TObject);
var sResult: string;
begin
  if (length(trim(edtTimeout.Text)) > 0) and (StrToInt(edtTimeout.Text) = 0) then
  begin
    ShowMessage508('Application Timeout must be blank or an integer between 1-999999', self.Handle);
    ModalResult := mrNone;
    edtTimeout.SetFocus;
    exit;
  end;
  DataModule1.Broker.RemoteProcedure := 'MAG3 SET TIMEOUT';
  DataModule1.Broker.Param[0].PType := literal;
  DataModule1.Broker.Param[0].Value := 'TELEREADER';
  DataModule1.Broker.Param[1].PType := literal;
  DataModule1.Broker.Param[1].Value := edtTimeout.Text;
  try
    sResult := DataModule1.Broker.strCall;
    MagLogger.Log('INFO', 'Telereader Application Timeout updated.');
    ModalResult := mrOK;
  except
    on e: exception do
    begin
      MagLogger.Log('ERROR', e.Message);
      raise;
    end;
  end;
end;

procedure TfrmSystemSettings.HelpClick(Sender: TObject);
var s, sField: string;
begin
  case TImage(Sender).Tag of
    1: sField := '131';
  end;
  s := GetDataDictionaryHelp('2006.1', sField);
  MessageDlg508(s, mtInformation, [mbOK], self.Handle);
end;

procedure TfrmSystemSettings.FormKeyDown(Sender: TObject; var Key: Word;
  Shift: TShiftState);
begin
  if Key = F1KEY then
  begin
    if ControlHasHelpText(ActiveControl) then
      begin
        if ActiveControl.Name = 'edtTimeout' then HelpClick(imgTimeout);
      end
    else
      begin
        OpenHelpFile;
      end
  end;
end;

procedure TfrmSystemSettings.FormClose(Sender: TObject;
  var Action: TCloseAction);
begin
  SaveFormPosition(self);
end;

end.
