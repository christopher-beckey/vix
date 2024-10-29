unit fMAGAddEditSite;
{Package: MAG - VistA Imaging
WARNING: Per VHA Directive 10-93-142 this unit should not be modified.
Date Created: 08/2009
Site Name: Silver Spring, OIFO
Developers: Bill Balshem
[==   unit fMAGAddEditSite;
 Description: User selects choices from the combo boxes to add a new acquisition site to the, edit a acquistion site in the TeleReader Acquisition Sites file (#2006.5842)
 The user can activate/deactivate the set in the telerader app. The user can also set the defualt for how long a specific case can be locked by a reader.
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
  Dialogs, StdCtrls, Buttons, ExtCtrls, IniFiles, VA508AccessibilityManager;

type
  TfrmAddEditSite = class(TForm)
    amgrMain: TVA508AccessibilityManager;
    Label1: TLabel;
    Label3: TLabel;
    lblInstruct: TLabel;
    Label2: TLabel;
    cmbSite: TComboBox;
    edtLockout: TEdit;
    btnSave: TBitBtn;
    btnCancel: TBitBtn;
    cbActive: TCheckBox;
    cmbPrimary: TComboBox;
    imgSite: TImage;
    imgPrimary: TImage;
    imgActive: TImage;
    imgLockout: TImage;
    procedure btnCancelClick(Sender: TObject);
    procedure SetSaveButton(Sender: TObject);
    procedure FormShow(Sender: TObject);
    procedure edtLockoutKeyPress(Sender: TObject; var Key: Char);
    procedure PopulateComboBoxes;
    procedure SetSelections;
    procedure btnSaveClick(Sender: TObject);
    procedure HelpClick(Sender: TObject);
    procedure FormKeyDown(Sender: TObject; var Key: Word;
      Shift: TShiftState);
    procedure FormClose(Sender: TObject; var Action: TCloseAction);
    procedure FormDestroy(Sender: TObject);
  private
    { Private declarations }
    bChange: boolean;
    function PrimarySiteValid(sStation: string): boolean;
  public
    { Public declarations }
    sAlreadyAddedSites: string;
  end;

var
  frmAddEditSite: TfrmAddEditSite;

implementation

uses
  uMAGGlobalsTRA, dmMAGTeleReaderAdmin, MagFMComponents, trpcb, DiTypLib, Magguini, ImagingExchangeSiteService;

{$R *.dfm}

procedure TfrmAddEditSite.btnCancelClick(Sender: TObject);
begin
  if (not bChange) or (MessageDlg508(CancelSTR, mtConfirmation, [mbYes, mbNo], self.Handle) = mrYes) then Close;
end;

procedure TfrmAddEditSite.SetSaveButton(Sender: TObject);
begin
  bChange := true;
  btnSave.Enabled := AllMandatoryFieldsSelected(Self);
end;

procedure TfrmAddEditSite.FormShow(Sender: TObject);
begin
  lblInstruct.Caption := sInstructions;
  PopulateComboBoxes;
  SetSelections;
  SetCombosReadOnly(Self);
  bChange := false;
  GetFormPosition(self);
end;

procedure TfrmAddEditSite.edtLockoutKeyPress(Sender: TObject;
  var Key: Char);
begin
    if (Key in ['0'..'9']) or (Key = #13) or (Key = #8) then Key := Key
    else Key := #0
end;

procedure TfrmAddEditSite.PopulateComboBoxes;
begin
  PopComboWithSites(cmbSite, sAlreadyAddedSites, ftRemove);
  PopComboWithSites(cmbPrimary);
end;

procedure TfrmAddEditSite.SetSelections;
begin
  cmbSite.ItemIndex := cmbSite.Items.IndexOf(cmbSite.Text);
  cmbPrimary.ItemIndex := cmbPrimary.Items.IndexOf(cmbPrimary.Text);
end;

function GetWorkStationID: string;
var Ini: TIniFile;
begin
  Ini := TIniFile.Create(GetConfigFileName);
  try
    result := Ini.ReadString('Workstation Settings', 'ID', 'Unknown');
  finally
    Ini.Free;
  end;
end;

function GetWebSiteURL(WSID: string): string;
var sl: TStringList;
begin
  sl := TStringList.Create;
  try
    DataModule1.Broker.RemoteProcedure := 'MAGGUSER2';
    DataModule1.Broker.Param[0].PType := literal;
    DataModule1.Broker.Param[0].Value := WSID;
    try
      DataModule1.Broker.lstCall(sl);
      MagLogger.Log('INFO', 'Retrieved Imaging Exchange web serive URL.');
    except
      on e: exception do
      begin
        MagLogger.Log('ERROR', e.Message);
        raise;
      end;
    end;
    result := sl[9];
    if result = '' then exit;
    result := copy(result, 0, LastDelimiter('/', result)) + 'ImagingExchangeSiteService.asmx';
  finally
    sl.Free;
  end;
end;

function TfrmAddEditSite.PrimarySiteValid(sStation: string): boolean;
var WSID, URL: string;
    SOAP: ImagingExchangeSiteServiceSoap;
    Site: ImagingExchangeSiteTO;
begin
  result := true;
  try
    WSID := GetWorkStationID;
    URL := GetWebSiteURL(WSID);
    if URL = '' then
    begin
      result := false;
      MessageDlg508('Web service not available at this time.', mtError, [mbOK], self.Handle);
      MagLogger.Log('INFO', 'Web service not available at this time.');
      exit;
    end;
    SOAP := GetImagingExchangeSiteServiceSoap(false, URL, nil);
    Site := SOAP.getSite(sStation);
    if Site.siteName = '' then
    begin
      result := false;
      MessageDlg508(cmbPrimary.text + ' is not a valid primary site.', mtError, [mbOK], self.Handle);
      MagLogger.Log('INFO', 'Selected primary site not valid.');
      exit;
    end;
    MagLogger.Log('INFO', 'Selected primary site valid.');
  except
    MessageDlg508('An error occured attempting to validate ' + sStation + ' as a primary site.', mtError, [mbOK], self.Handle);
    result := false;
  end;
end;

procedure TfrmAddEditSite.btnSaveClick(Sender: TObject);
var sResult, sStation: string; FormState: TFormState;
    IEN: string; //IEN: integer;
begin
  //check primary site is valid through web service
  IEN := TIENObj(cmbPrimary.Items.Objects[cmbPrimary.ItemIndex]).sIEN;
  sStation := GetSiteStationNoFromIEN(IEN);
  if not PrimarySiteValid(sStation) then
  begin
    ModalResult := mrNone;
    cmbPrimary.SetFocus;
    exit;
  end;
  if cmbSite.Enabled then FormState := fsAdd else FormState := fsEdit;
  DataModule1.Broker.RemoteProcedure := 'MAG3 TELEREADER SITE SETUP';
  DataModule1.Broker.Param[0].PType := list;
  DataModule1.Broker.Param[0].Value := '.x';
  //IENs FROM Service Name Ref file, saved in combo box tstrings as TObject
  //after convert from string to integer - strings cant be cast as TOBject
  //see combo box population code in GlobalsTRA unit  (same for other params below)
  DataModule1.Broker.Param[0].Mult['"NAME"'] := TIENObj(cmbSite.Items.Objects[cmbSite.ItemIndex]).sIEN;
  DataModule1.Broker.Param[0].Mult['"PRIMARY SITE"'] := IEN;
  DataModule1.Broker.Param[0].Mult['"LOCK TIMEOUT IN MINUTES"'] := edtLockOut.Text;
  DataModule1.Broker.Param[0].Mult['"STATUS"'] := IntToStr(Integer(cbActive.Checked));
  if FormState = fsAdd then
    DataModule1.Broker.Param[0].Mult['"ACTION"'] := 'ADD'
  else if FormState = fsEdit then
    DataModule1.Broker.Param[0].Mult['"ACTION"'] := 'UPDATE';
  DataModule1.Broker.Param[0].Mult['"IEN"'] := TIENObj(cmbSite.Items.Objects[cmbSite.ItemIndex]).sIEN;
  try
    sResult := DataModule1.Broker.strCall;
    MagLogger.Log('INFO', 'Successful ' + FormStateToStr(FormState) + ' to Telereader Acquisition Site file.');
    ModalResult := mrOK;
  except
    on e: exception do
    begin
      MagLogger.Log('ERROR', e.Message);
      raise;
    end;
  end;
end;

procedure TfrmAddEditSite.HelpClick(Sender: TObject);
var s, sField: string;
begin
  case TImage(Sender).Tag of
    1: sField := '.01';
    else sField := IntToStr(TImage(Sender).Tag - 1) 
  end;
  s := GetDataDictionaryHelp('2006.5842', sField);
  MessageDlg508(s, mtInformation, [mbOK], self.Handle);
end;

procedure TfrmAddEditSite.FormKeyDown(Sender: TObject; var Key: Word;
  Shift: TShiftState);
begin
  if Key = F1KEY then
  begin
    if ControlHasHelpText(ActiveControl) then
      begin
        if (ActiveControl.Name = 'cmbSite')  or (ActiveControl.Tag = 508) then HelpClick(imgSite)
        else if ActiveControl.Name = 'cmbPrimary' then HelpClick(imgPrimary)
        else if ActiveControl.Name = 'cbActive' then HelpClick(imgActive)
        else if ActiveControl.Name = 'edtLockout' then HelpClick(imgLockout);
      end
    else
      begin
        OpenHelpFile;
      end
  end;
end;

procedure TfrmAddEditSite.FormClose(Sender: TObject;
  var Action: TCloseAction);
begin
  SaveFormPosition(self);
end;

procedure TfrmAddEditSite.FormDestroy(Sender: TObject);
begin
  FreeStringsIENObj(cmbSite.Items);
  FreeStringsIENObj(cmbPrimary.Items);
end;

end.
