unit fMAGAddEditUnreadList;
{Package: MAG - VistA Imaging
WARNING: Per VHA Directive 10-93-142 this unit should not be modified.
Date Created: 08/2009
Site Name: Silver Spring, OIFO
Developers: Bill Balshem
[==   unit fMAGAddEditUnreadList;
 Description: User selects choices from the combo boxes to add a new consult to the, edit consult in the unreadlist configuration file (2006.5841)
 The Procedure Index is a subset of the Specialty index and there will be cleared out whenever a specialty is selceted, the choices from the Procedure Index
 changes based on the Specialty Index selection.
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
  TfrmAddEditUnreadList = class(TForm)
    amgrMain: TVA508AccessibilityManager;
    lblSite: TLabel;
    lblTrigger: TLabel;
    lblTIU: TLabel;
    lblInstruct: TLabel;
    cmbSite: TComboBox;
    cmbTrigger: TComboBox;
    cmbTIU: TComboBox;
    btnSave: TBitBtn;
    btnCancel: TBitBtn;
    imgSite: TImage;
    imgTrigger: TImage;
    imgTIU: TImage;
    gpConsult: TGroupBox;
    lblName: TLabel;
    cmbName: TComboBox;
    imgName: TImage;
    lblProcedure: TLabel;
    imgProcedure: TImage;
    cmbProcedure: TComboBox;
    gpImaging: TGroupBox;
    lblSpecialtyIndex: TLabel;
    lblProcedureIndex: TLabel;
    imgSpecialtyIndex: TImage;
    imgProcedureIndex: TImage;
    cmbSpecialtyIndex: TComboBox;
    cmbProcedureIndex: TComboBox;
    procedure SetSaveButton(Sender: TObject);
    procedure btnCancelClick(Sender: TObject);
    procedure FormShow(Sender: TObject);
    procedure btnSaveClick(Sender: TObject);
    procedure PopulateComboBoxes;
    procedure SetSelections;
    procedure cmbSpecialtyIndexChange(Sender: TObject);
    procedure PopulateTIUNote;
    procedure HelpClick(Sender: TObject);
    procedure cmbNameChange(Sender: TObject);
    procedure FormKeyDown(Sender: TObject; var Key: Word;
      Shift: TShiftState);
    procedure FormClose(Sender: TObject; var Action: TCloseAction);
    procedure FormDestroy(Sender: TObject);
    procedure PopulateTriggers;
  private
    { Private declarations }
    bChange : boolean;
    bOnShowComplete: boolean;
  public
    { Public declarations }
    sIEN: string;
    sAlreadyAddedServices: string;
  end;

var
  frmAddEditUnreadList: TfrmAddEditUnreadList;

implementation

uses
  uMAGGlobalsTRA, dmMAGTeleReaderAdmin, MagFMComponents, trpcb, DiTypLib, MagFileVersion;

{$R *.dfm}

procedure TfrmAddEditUnreadList.SetSaveButton(Sender: TObject);
begin
  if bOnShowComplete then //*** BB 03/03/2010 ***
    bChange := true;
  btnSave.Enabled := AllMandatoryFieldsSelected(Self) and (cmbName.Enabled or bChange);
end;

procedure TfrmAddEditUnreadList.btnCancelClick(Sender: TObject);
begin
  if (not bChange) or (MessageDlg508(CancelSTR, mtConfirmation, [mbYes, mbNo], self.Handle)  = mrYes) then Close;
end;

procedure TfrmAddEditUnreadList.PopulateComboBoxes;
begin
  PopComboWithLocalSites(cmbSite, cmbName.Enabled);
 //P127T1 NST 04/13/2012 Don't exclude current services. The check for duplicate (service,procedure) is done on server side
  PopulateComboBox(cmbName, '123.5', '.01', emptystr, emptystr); //Service Name
  PopulateComboBox(cmbProcedure, '123.3', '.01', emptystr, emptystr); //Procedure (Optional)
  PopulateTIUNote;
  PopulateTriggers;
  PopulateComboBoxRPC(cmbSpecialtyIndex, 'MAG4 INDEX GET SPECIALTY', emptystr, 4);
end;

procedure TfrmAddEditUnreadList.SetSelections;
begin
  cmbSite.ItemIndex := cmbSite.Items.IndexOf(cmbSite.Text);
  cmbName.ItemIndex := cmbName.Items.IndexOf(cmbName.Text);
  cmbProcedure.ItemIndex := cmbProcedure.Items.IndexOf(cmbProcedure.Text);
  cmbSpecialtyIndex.ItemIndex := cmbSpecialtyIndex.Items.IndexOf(cmbSpecialtyIndex.Text);
  cmbTrigger.ItemIndex := cmbTrigger.Items.IndexOf(cmbTrigger.Text);
  cmbTIU.ItemIndex := cmbTIU.Items.IndexOf(cmbTIU.Text);
end;

procedure TfrmAddEditUnreadList.FormShow(Sender: TObject);
var sProcedureText: string;
begin
  bOnShowComplete := false;  // *** BB 03/03/2010 ***
  lblInstruct.Caption := sInstructions;
  PopulateComboBoxes;
  SetSelections; //only needed for edits but doesn't hurt to do with adds as well
  {need to place 2 lines below here for timing to work properly}
  cmbSpecialtyIndexChange(self);
  cmbProcedureIndex.ItemIndex := cmbProcedureIndex.Items.IndexOf(cmbProcedureIndex.Text);
  {}
  sProcedureText := cmbProcedure.Text;
  cmbNameChange(self);
  cmbProcedure.ItemIndex := cmbProcedure.Items.IndexOf(sProcedureText); //cmbProcedure.Items.IndexOf(cmbProcedure.Text);
  {}
  SetCombosReadOnly(Self);
  bChange := false;
  GetFormPosition(self);
  bOnShowComplete := true; // *** BB 03/03/2010 ***
end;

procedure TfrmAddEditUnreadList.btnSaveClick(Sender: TObject);
var sResult: string; FormState: TFormState;
    sError : String;  //P127T1 NST 04/13/2012  Error message variable
begin
  if cmbName.Enabled then FormState := fsAdd else FormState := fsEdit;
  DataModule1.Broker.RemoteProcedure := 'MAG3 TELEREADER ACQ SRVC SETUP';
  DataModule1.Broker.Param[0].PType := list;
  DataModule1.Broker.Param[0].Value := '.x';
  DataModule1.Broker.Param[0].Mult['"NAME"'] := TIENObj(cmbName.Items.Objects[cmbName.ItemIndex]).sIEN;        //IENs FROM Service Name Ref file, saved in combo box tstrings as TObject
                                                                                                               //after convert from string to integer - strings cant be cast as TOBject
                                                                                                               //see combo box population code in GlobalsTRA unit (same for other params below)
  if cmbProcedure.Text = '' then
    DataModule1.Broker.Param[0].Mult['"PROCEDURE"'] := ''
  else
    DataModule1.Broker.Param[0].Mult['"PROCEDURE"'] := TIENObj(cmbProcedure.Items.Objects[cmbProcedure.ItemIndex]).sIEN;
  DataModule1.Broker.Param[0].Mult['"SPECIALTY INDEX"'] := TIENObj(cmbSpecialtyIndex.Items.Objects[cmbSpecialtyIndex.ItemIndex]).sIEN;
  DataModule1.Broker.Param[0].Mult['"PROCEDURE INDEX"'] := TIENObj(cmbProcedureIndex.Items.Objects[cmbProcedureIndex.ItemIndex]).sIEN;
  DataModule1.Broker.Param[0].Mult['"ACQUISITION SITE"'] := TIENObj(cmbSite.Items.Objects[cmbSite.ItemIndex]).sIEN;
  DataModule1.Broker.Param[0].Mult['"UNREAD LIST CREATION TRIGGER"'] := TIENObj(cmbTrigger.Items.Objects[cmbTrigger.ItemIndex]).sIEN;
  DataModule1.Broker.Param[0].Mult['"TIU NOTE FILE"'] := TIENObj(cmbTIU.Items.Objects[cmbTIU.ItemIndex]).sIEN;
  if FormState = fsAdd then
    DataModule1.Broker.Param[0].Mult['"ACTION"'] := 'ADD'
  else if FormState = fsEdit then
    DataModule1.Broker.Param[0].Mult['"ACTION"'] := 'UPDATE';
  DataModule1.Broker.Param[0].Mult['"IEN"'] := sIEN;
  try
    sResult := DataModule1.Broker.strCall;
    //P127T1 NST 04/13/2012 Check for RPC error message
    if MagSTRPiece(sResult,'^',1)='0' then
    begin
      sError := MagSTRPiece(sResult,'^',2);
      MessageDlg508(sError, mtError, [mbOK], self.Handle);
      MagLogger.Log('ERROR', FormStateToStr(FormState) + ' to Telereader Acquisition Service file failed: '+ sError);
    end
    else
    begin
      MagLogger.Log('INFO', 'Successful ' + FormStateToStr(FormState) + ' to Telereader Acquisition Service file.');
      ModalResult := mrOK;
    end;
  except
    on e: exception do
    begin
      MagLogger.Log('ERROR', e.Message);
      raise;
    end;
  end;
end;

procedure TfrmAddEditUnreadList.cmbSpecialtyIndexChange(Sender: TObject);
var sIEN: string;
begin
  if bOnShowComplete then // *** BB 03/03/2010 ***
    bChange := true;
  cmbProcedureIndex.ItemIndex := -1;
  if cmbSpecialtyIndex.ItemIndex = -1 then
  begin
    cmbProcedureIndex.Items.Clear;
  end
  else
  begin
    sIEN := TIENObj(cmbSpecialtyIndex.Items.Objects[cmbSpecialtyIndex.ItemIndex]).sIEN;
    PopulateComboBoxRPC(cmbProcedureIndex, 'MAG4 INDEX GET EVENT', sIEN, 3);
  end;
  btnSave.Enabled := AllMandatoryFieldsSelected(Self) and (cmbName.Enabled or bChange);
end;

//CARE <CARE COORDINATION HOME TELEHEALTH SCREENING CONSULT>
//CARE COORDINATION HOME TELEHEALTH SCREENING CONSULT

{*  P127T1 NST 04/11/2012 aboslete function.
          No formatting - the TIU Note Title will appear as ones in CPRS and Imaging Capture

function FormatTIUNoteRecord(s: string): string;
var HasKeyWord: boolean; sKeyWord, sNote: string;
    iPos1, iPos2: integer;
begin
  HasKeyWord := pos('<', s) > 0;
  if HasKeyWord then
    begin
      iPos1 := pos('<', s) + 1;
      iPos2 := pos('>', s) - 1;
      sKeyWord := trim(copy(s, iPos1, iPos2 - iPos1 + 1));
      sNote := trim(copy(s, 1, pos('^', s) - 1));
      result := '[' + sNote + '] ' + sKeyword;
    end
  else
    begin
      result := copy(s, 1, pos('^^', s) - 1);
    end;
end;
*}

//'621 ^ CARDIOLOGY  ^<CARDIOLOGY CONSULT >     //P127T1 NST 04/11/2012  a record that comes from MAG3 TELEREADER TIU TITLES LST
procedure TfrmAddEditUnreadList.PopulateTIUNote;
var sl: TStringList; i: integer; s, sText, sIEN: string;
begin
  cmbTIU.Items.Clear;
  sl := TStringList.Create;
  DataModule1.Broker.RemoteProcedure := 'MAG3 TELEREADER TIU TITLES LST';     // P127T1 NST 04/11/2012 - Use a new RPC to get List of TIU Note Titles

  try
    DataModule1.Broker.lstcall(sl);
    if MagStrPiece(sl[0], '^', 1) = '1' then
    begin
      for i := 1 to sl.Count - 1  do
      begin
        s := sl[i];
        sIEN := MagStrPiece(s,'^',1);     //P127T1 NST 04/11/2012 Modified to address the result from  RPC [MAG3 TELEREADER TIU TITLES LST]
        sText := MagStrPiece(s,'^',2);
        cmbTIU.Items.AddObject(sText, TIENObj.Create(sIEN));
      end;
    end;
  finally
    sl.Free;
  end;
end;

procedure TfrmAddEditUnreadList.PopulateTriggers;
var i: integer; sTemp, sIEN, sVal, sDefault: string;
begin
  i := 1;
  sTemp := MagStrPiece(sTriggers, ';', 1);
  while sTemp <> '' do
  begin
    sIEN := MagStrPiece(sTemp, ':', 1);
    sVal := MagStrPiece(sTemp, ':', 2);
    cmbTrigger.Items.AddObject(FormatTriggerText(sIEN, sVal), TIENObj.Create(sIEN));
    if i = 1 then sDefault := FormatTriggerText(sIEN, sVal);
    Inc(i);
    sTemp := MagStrPiece(sTriggers, ';', i);
  end;
  if cmbName.Enabled  then cmbTrigger.Text := sDefault;
end;

procedure TfrmAddEditUnreadList.HelpClick(Sender: TObject);
var s, sField: string;
begin
  case TImage(Sender).Tag of
    1: sField := '.01';
    else sField := IntToStr(TImage(Sender).Tag - 1) 
  end;
  s := GetDataDictionaryHelp('2006.5841', sField);
  MessageDlg508(s, mtInformation, [mbOK], self.Handle);
end;

procedure TfrmAddEditUnreadList.cmbNameChange(Sender: TObject);
var sIEN, sScreen: string;
begin

  bChange := true;
  cmbProcedure.ItemIndex := -1;
  if cmbName.ItemIndex = -1 then
  begin
    cmbProcedure.Items.Clear;
  end
  else
  begin
    sIEN := TIENObj(cmbName.Items.Objects[cmbName.ItemIndex]).sIEN;
    sScreen := 'I $D(^(2,"B",' + sIEN + '))>0';
    PopulateComboBox(cmbProcedure, '123.3', '.01', emptystr, emptystr, sScreen);
  end;
  if bOnShowComplete then // *** BB 03/03/2010 ***
    btnSave.Enabled := AllMandatoryFieldsSelected(Self) and (cmbName.Enabled or bChange);
end;

procedure TfrmAddEditUnreadList.FormKeyDown(Sender: TObject; var Key: Word;
  Shift: TShiftState);
begin
  if Key = F1KEY then
  begin
    if ControlHasHelpText(ActiveControl) then
      begin
        if (ActiveControl.Name = 'cmbName') or (ActiveControl.Tag = 508) then HelpClick(imgName)
        else if ActiveControl.Name = 'cmbProcedure' then HelpClick(imgProcedure)
        else if ActiveControl.Name = 'cmbSpecialtyIndex' then HelpClick(imgSpecialtyIndex)
        else if ActiveControl.Name = 'cmbProcedureIndex' then HelpClick(imgProcedureIndex)
        else if ActiveControl.Name = 'cmbSite' then HelpClick(imgSite)
        else if ActiveControl.Name = 'cmbTrigger' then HelpClick(imgTrigger)
        else if ActiveControl.Name = 'cmbTIU' then HelpClick(imgTIU);
      end
    else
      begin
        OpenHelpFile;
      end
  end;
end;

procedure TfrmAddEditUnreadList.FormClose(Sender: TObject;
  var Action: TCloseAction);
begin
  SaveFormPosition(self);
end;

procedure TfrmAddEditUnreadList.FormDestroy(Sender: TObject);
begin
  FreeStringsIENObj(cmbName.Items);
  FreeStringsIENObj(cmbProcedure.Items);
  FreeStringsIENObj(cmbSpecialtyIndex.Items);
  FreeStringsIENObj(cmbProcedureIndex.Items);
  FreeStringsIENObj(cmbSite.Items);
  FreeStringsIENObj(cmbTIU.Items);
  FreeStringsIENObj(cmbTrigger.Items);
end;

end.
