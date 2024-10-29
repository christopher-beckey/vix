unit fMAGAddEditDICOM;
{Package: MAG - VistA Imaging
WARNING: Per VHA Directive 10-93-142 this unit should not be modified.
Date Created: 08/2009
Site Name: Silver Spring, OIFO
Developers: Bill Balshem
[==   unit fMAGAddEditDICOM;
 Description: User selects choices from the combo boxes to add a new record, edit record in the DICOM HEALTHCARE PROVIDER SERVICE configuration file
 for TELERETINAL IMAGING(2006.5831)
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
  TfrmAddEditDICOM = class(TForm)
    amgrMain: TVA508AccessibilityManager;
    lblInstruct: TLabel;
    btnSave: TBitBtn;
    btnCancel: TBitBtn;
    lblClinics: TLabel;
    imgClinic: TImage;
    btnClinic: TButton;
    lstClinic: TListBox;
    gpImaging: TGroupBox;
    lblSpecialtyIndex: TLabel;
    lblProcedureIndex: TLabel;
    imgSpecialtyIndex: TImage;
    imgProcedureIndex: TImage;
    cmbSpecialtyIndex: TComboBox;
    cmbProcedureIndex: TComboBox;
    gpConsult: TGroupBox;
    lblName: TLabel;
    imgName: TImage;
    lblProcedure: TLabel;
    imgProcedure: TImage;
    cmbName: TComboBox;
    cmbProcedure: TComboBox;
    lblSite: TLabel;
    imgSite: TImage;
    cmbSite: TComboBox;
    lblCPTCode: TLabel;
    lblHL7: TLabel;
    imgCPTCode: TImage;
    imgHL7: TImage;
    cmbHL7: TComboBox;
    imgClinics: TImage;
    edtCPTCode: TEdit;
    btnCPTCode: TButton;
    procedure SetSaveButton(Sender: TObject);
    procedure btnCancelClick(Sender: TObject);
    procedure FormShow(Sender: TObject);
    procedure btnSaveClick(Sender: TObject);
    procedure PopulateComboBoxes;
    procedure SetSelections;
    procedure HelpClick(Sender: TObject);
    procedure FormKeyDown(Sender: TObject; var Key: Word;
      Shift: TShiftState);
    procedure btnClinicClick(Sender: TObject);
    procedure FormClose(Sender: TObject; var Action: TCloseAction);
    procedure FormDestroy(Sender: TObject);
    procedure cmbSpecialtyIndexChange(Sender: TObject);
    procedure cmbNameChange(Sender: TObject);
    procedure cmbSiteChange(Sender: TObject);
    procedure btnCPTCodeClick(Sender: TObject);
  private
    { Private declarations }
    FCPTCodeIEN : String;    // CPT Code IEN    //P110T1 NST 04/13/2012

    bChange : boolean;
    bOnShowComplete: boolean;
    bChangeClinics: boolean;
    function BuildClinicIENStr: string;
  public
    { Public declarations }
    sIEN: string;
    property CPTCodeIEN : String read FCPTCodeIEN write FCPTCodeIEN;  //P110T1 NST 04/13/2012
  end;

var
  frmAddEditDICOM: TfrmAddEditDICOM;

implementation

uses
  uMAGGlobalsTRA, dmMAGTeleReaderAdmin, MagFMComponents, trpcb, DiTypLib, fMAGSelectClinics,
  MagFileVersion, fMAGSelectCPTCode;

{$R *.dfm}

procedure TfrmAddEditDICOM.SetSaveButton(Sender: TObject);
begin
  //P110T1 NST 04/21/2012 Update save button
  if bOnShowComplete then //*** BB 03/03/2010 ***
    bChange := true;
  btnSave.Enabled := AllMandatoryFieldsSelected(Self) and (cmbName.Enabled or bChange);
end;

procedure TfrmAddEditDICOM.btnCancelClick(Sender: TObject);
begin
  if (not bChange) or (MessageDlg508(CancelSTR, mtConfirmation, [mbYes, mbNo], self.Handle)  = mrYes) then Close;
end;

procedure TfrmAddEditDICOM.PopulateComboBoxes;
begin
 //P110T1 NST 04/21/2012 Don't exclude current services. The check for duplicate (service,procedure) is done on server side
  PopulateComboBox(cmbName, '123.5', '.01', emptystr, emptystr); //Service Name
  PopulateComboBox(cmbProcedure, '123.3', '.01', emptystr, emptystr); //Procedure (Optional)
  PopulateComboBoxRPC(cmbSpecialtyIndex, 'MAG4 INDEX GET SPECIALTY', emptystr, 4);
  PopComboWithLocalSites(cmbSite, cmbName.Enabled);
  PopulateComboBox(cmbHL7, '779.4', '.01', emptystr, emptystr); //HL7 list
end;

procedure TfrmAddEditDICOM.SetSelections;
begin
  //P110T1 NST 04/21/2012  Set the fields
  cmbName.ItemIndex := cmbName.Items.IndexOf(cmbName.Text);
  cmbProcedure.ItemIndex := cmbProcedure.Items.IndexOf(cmbProcedure.Text);
  cmbSite.ItemIndex := cmbSite.Items.IndexOf(cmbSite.Text);
  cmbSpecialtyIndex.ItemIndex := cmbSpecialtyIndex.Items.IndexOf(cmbSpecialtyIndex.Text);
  cmbHL7.ItemIndex := cmbHL7.Items.IndexOf(cmbHL7.Text);
end;

procedure TfrmAddEditDICOM.FormShow(Sender: TObject);
var sProcedureText: string;
begin
  //P110T1 NST 04/21/2012  Set the fields
  bOnShowComplete := false;
  lblInstruct.Caption := sInstructions;
  PopulateComboBoxes;
  SetSelections; //only needed for edits but doesn't hurt to do with adds as well
  {need to place 2 lines below here for timing to work properly}
  cmbSpecialtyIndexChange(self);
  cmbProcedureIndex.ItemIndex := cmbProcedureIndex.Items.IndexOf(cmbProcedureIndex.Text);
  {}
  sProcedureText := cmbProcedure.Text;
  cmbNameChange(self);
  cmbProcedure.ItemIndex := cmbProcedure.Items.IndexOf(sProcedureText);
  {}
  SetCombosReadOnly(Self);
  bChange := false;
  GetFormPosition(self);
  bOnShowComplete := true;
end;

procedure TfrmAddEditDICOM.btnSaveClick(Sender: TObject);
var sResult: string; FormState: TFormState;
    sError : String;  //P110T1 NST 04/13/2012  Error message variable
begin
  //P110T1 NST 04/21/2012  Send the fields
  if cmbName.Enabled then FormState := fsAdd else FormState := fsEdit;
  DataModule1.Broker.RemoteProcedure := 'MAG3 TELEREADER PDR SRVC SETUP';
  DataModule1.Broker.Param[0].PType := list;
  DataModule1.Broker.Param[0].Value := '.x';
  //IENs FROM Service Name Ref file, saved in combo box tstrings as TObject
  //after convert from string to integer - strings cant be cast as TObject
  //see combo box population code in GlobalsTRA unit
  DataModule1.Broker.Param[0].Mult['"REQUEST SERVICE"'] := TIENObj(cmbName.Items.Objects[cmbName.ItemIndex]).sIEN;        //IENs FROM Service Name Ref file, saved in combo box tstrings as TObject
                                                                                                                          //after convert from string to integer - strings cant be cast as TOBject                                                                                                              //see combo box population code in GlobalsTRA unit (same for other params below)
  if cmbProcedure.Text = '' then
    DataModule1.Broker.Param[0].Mult['"PROCEDURE"'] := ''
  else
    DataModule1.Broker.Param[0].Mult['"PROCEDURE"'] := TIENObj(cmbProcedure.Items.Objects[cmbProcedure.ItemIndex]).sIEN;

  DataModule1.Broker.Param[0].Mult['"SPECIALTY INDEX"'] := TIENObj(cmbSpecialtyIndex.Items.Objects[cmbSpecialtyIndex.ItemIndex]).sIEN;
  DataModule1.Broker.Param[0].Mult['"PROCEDURE INDEX"'] := TIENObj(cmbProcedureIndex.Items.Objects[cmbProcedureIndex.ItemIndex]).sIEN;
  DataModule1.Broker.Param[0].Mult['"ACQUISITION SITE"'] := TIENObj(cmbSite.Items.Objects[cmbSite.ItemIndex]).sIEN;
  DataModule1.Broker.Param[0].Mult['"CPT CODE"'] := CPTCodeIEN;
  if cmbHL7.Text = '' then
    DataModule1.Broker.Param[0].Mult['"HL7 HLO SUBSCRIPTION LIST"'] := ''
  else
    DataModule1.Broker.Param[0].Mult['"HL7 HLO SUBSCRIPTION LIST"'] := TIENObj(cmbHL7.Items.Objects[cmbHL7.ItemIndex]).sIEN;


  if FormState = fsAdd then
    DataModule1.Broker.Param[0].Mult['"ACTION"'] := 'ADD'
  else if FormState = fsEdit then
    DataModule1.Broker.Param[0].Mult['"ACTION"'] := 'UPDATE';

  DataModule1.Broker.Param[0].Mult['"IEN"'] := sIEN;

  if ((FormState = fsAdd) and (lstClinic.Items.Count > 0)) or (bChangeClinics) then
    DataModule1.Broker.Param[0].Mult['"CLINIC"'] := BuildClinicIENStr;
  try
    sResult := DataModule1.Broker.strCall;
    //P110T1 NST 04/13/2012 Check for RPC error message
    if MagSTRPiece(sResult,'^',1)='0' then
    begin
      sError := MagSTRPiece(sResult,'^',2);
      MessageDlg508(sError, mtError, [mbOK], self.Handle);
      MagLogger.Log('ERROR', FormStateToStr(FormState) + ' to CLINICAL SPECIALTY DICOM & HL7 file (#2006.5831) failed: '+ sError);
    end
    else
    begin
    MagLogger.Log('INFO', 'Successful ' + FormStateToStr(FormState) + ' to CLINICAL SPECIALTY DICOM & HL7 file (#2006.5831).');
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


procedure TfrmAddEditDICOM.HelpClick(Sender: TObject);
var s, sField: string;
begin
  case TImage(Sender).Tag of
    1: sField := '.01';
    else sField := IntToStr(TImage(Sender).Tag)
  end;
  s := GetDataDictionaryHelp('2006.5831', sField);
  MessageDlg508(s, mtInformation, [mbOK], self.Handle);
end;

procedure TfrmAddEditDICOM.FormKeyDown(Sender: TObject; var Key: Word;
  Shift: TShiftState);
begin
  if Key = F1KEY then
  begin
    if ControlHasHelpText(ActiveControl) then
      begin
        //P110T1 NST 04/21/2012  Check for the new fields to call HelpClick
        if (ActiveControl.Name = 'cmbName')  or (ActiveControl.Tag = 508) then HelpClick(imgName)
        else if ActiveControl.Name = 'cmbProcedure' then HelpClick(imgProcedure)
        else if ActiveControl.Name = 'cmbSpecialtyIndex' then HelpClick(imgSpecialtyIndex)
        else if ActiveControl.Name = 'cmbProcedureIndex' then HelpClick(imgProcedureIndex)
        else if ActiveControl.Name = 'cmbSite' then HelpClick(imgSite)
        else if ActiveControl.Name = 'btnCPTCode' then HelpClick(imgCPTCode)
        else if ActiveControl.Name = 'cmbHL7' then HelpClick(imgHL7)
        else if ActiveControl.Name = 'lstClinics' then HelpClick(imgClinics);
      end
    else
      begin
        OpenHelpFile;
      end
  end;
end;

procedure TfrmAddEditDICOM.btnClinicClick(Sender: TObject);
var frmSelectClinic: TfrmSelectClinic; 
begin
  if not JobCompleted then
  begin
    ShowMessage508('System is still retrieving clinics from database.' + #10 +#13 + 'Try back in 10-15 seconds.', self.Handle);
    exit;
  end;
  frmSelectClinic := TfrmSelectClinic.Create(nil);
  try
    //P110T1 NST 04/21/2012  Refactor the name
    frmSelectClinic.sSiteIEN := TIENObj(cmbSite.Items.Objects[cmbSite.ItemIndex]).sIEN;
    frmSelectClinic.lstSelected.Items := lstClinic.Items;
    if frmSelectClinic.ShowModal = mrOK then
    begin
      lstClinic.Items := frmSelectClinic.lstSelected.Items;
      bChangeClinics := true;
      SetSaveButton(self);
    end;
  finally
    frmSelectClinic.Free;
  end;
end;

//P110T1 NST 04/21/2012  CPT Code LookUp
procedure TfrmAddEditDICOM.btnCPTCodeClick(Sender: TObject);
var sCPTCodeIEN, sCPTCode, sCPTCodeDescr : String;
begin
  if LookupCPTCode( sCPTCodeIEN, sCPTCode, sCPTCodeDescr ) then    // A new CPT Code is selected
  begin
    edtCPTCode.Text := sCPTCode + ' ' + sCPTCodeDescr;
    CPTCodeIEN := sCPTCodeIEN;
  end;
end;

function TfrmAddEditDICOM.BuildClinicIENStr: string;
var i: integer;
const DEL = '^';
begin
  result := '';
  for i := 0 to lstClinic.Items.Count - 1 do
    result := result + TIENObj(lstClinic.Items.Objects[i]).sIEN + DEL;
  result := copy(result, 1, length(result) - 1) //remove last DEL
end;

procedure TfrmAddEditDICOM.FormClose(Sender: TObject;
  var Action: TCloseAction);
begin
  SaveFormPosition(self);
end;

procedure TfrmAddEditDICOM.FormDestroy(Sender: TObject);
begin
  //P110T1 NST 04/21/2012  free the new fields
  FreeStringsIENObj(cmbName.Items);
  FreeStringsIENObj(cmbProcedure.Items);
  FreeStringsIENObj(cmbSpecialtyIndex.Items);
  FreeStringsIENObj(cmbProcedureIndex.Items);
  FreeStringsIENObj(cmbSite.Items);
  FreeStringsIENObj(cmbHL7.Items);
end;

//P110T1 NST 04/21/2012  Update Procedure combo box
procedure TfrmAddEditDICOM.cmbNameChange(Sender: TObject);
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

procedure TfrmAddEditDICOM.cmbSiteChange(Sender: TObject);
begin
  lstClinic.Items.Clear;
  bChangeClinics := true;
  SetSaveButton(Sender);
end;

//P110T1 NST 04/21/2012  Set the Specialty Index combo box
procedure TfrmAddEditDICOM.cmbSpecialtyIndexChange(Sender: TObject);
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

end.
