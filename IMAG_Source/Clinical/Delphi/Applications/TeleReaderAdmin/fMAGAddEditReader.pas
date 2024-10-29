unit fMAGAddEditReader;
{Package: MAG - VistA Imaging
WARNING: Per VHA Directive 10-93-142 this unit should not be modified.
Date Created: 08/2009
Site Name: Silver Spring, OIFO
Developers: Bill Balshem
[==   unit fMAGAddEditReader;
 Description: User selects choices from the combo boxes to add a new readers, additional rights (sites, specialties, procedures) for a reader (File #2006.5843)
 Procedure is a subset of the specialty.
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
  Dialogs, StdCtrls, Buttons, ComCtrls, ExtCtrls, VA508AccessibilityManager;

type
  TfrmAddEditReader = class(TForm)
    amgrMain: TVA508AccessibilityManager;
    Label1: TLabel;
    lblInstruct: TLabel;
    Label2: TLabel;
    Label3: TLabel;
    Label4: TLabel;
    cmbReader: TComboBox;
    btnSave: TBitBtn;
    btnCancel: TBitBtn;
    cmbSite: TComboBox;
    cmbSpecialty: TComboBox;
    cmbProcedure: TComboBox;
    imgReader: TImage;
    imgSite: TImage;
    imgSpecialty: TImage;
    imgProcedure: TImage;
    edtNameSearch: TEdit;
    Label5: TLabel;
    procedure btnCancelClick(Sender: TObject);
    procedure SetSaveButton(Sender: TObject);
    procedure FormShow(Sender: TObject);
    procedure PopulateTheForm(Node: TTreeNode);
    procedure PopulateComboBoxes;
    procedure SetSelections;
    procedure cmbSpecialtyChange(Sender: TObject);
    procedure btnSaveClick(Sender: TObject);
    procedure HelpClick(Sender: TObject);
    procedure FormKeyDown(Sender: TObject; var Key: Word;
      Shift: TShiftState);
    procedure FormClose(Sender: TObject; var Action: TCloseAction);
    procedure edtNameSearchKeyDown(Sender: TObject; var Key: Word;
      Shift: TShiftState);
    procedure FormDestroy(Sender: TObject);
  private
    { Private declarations }
    bChange: boolean;
    procedure RemoveAlreadyAddedPrivileges(CB: TComboBox);
    procedure GetUserNames(SearchStr: string);
  public
    { Public declarations }
    sAlreadyAddedReaders: string;
    sAvailableSites: string;
    slAlreadyAddedPrivliges: TStringList;
    iLevel: integer;
    procedure PopulateReaderComboWithSelection(SelectedNode: TTreeNode);
  end;

var
  frmAddEditReader: TfrmAddEditReader;

implementation

uses
  uMAGGlobalsTRA, dmMAGTeleReaderAdmin, MagFMComponents, trpcb, DiTypLib, MagFileVersion;

{$R *.dfm}

procedure TfrmAddEditReader.btnCancelClick(Sender: TObject);
begin
  if (not bChange) or (MessageDlg508(CancelSTR, mtConfirmation, [mbYes, mbNo], self.Handle)  = mrYes) then Close;
end;

procedure TfrmAddEditReader.SetSaveButton(Sender: TObject);
begin
  bChange := true;
  btnSave.Enabled := AllMandatoryFieldsSelected(Self);
end;

procedure  TfrmAddEditReader.PopulateComboBoxes;
begin
  PopComboWithSites(cmbSite, sAvailableSites, ftAdd);
  PopulateComboBoxRPC(cmbSpecialty, 'MAG4 INDEX GET SPECIALTY', emptystr, 4);
  PopulateComboBoxRPC(cmbProcedure, 'MAG4 INDEX GET EVENT', emptystr, 3);
  if slAlreadyAddedPrivliges <> nil then
  begin
    case iLevel of
      0: RemoveAlreadyAddedPrivileges(cmbSite);
      1: RemoveAlreadyAddedPrivileges(cmbSpecialty);
    end;
  end;
end;

procedure  TfrmAddEditReader.SetSelections;
begin
  cmbReader.ItemIndex := cmbReader.Items.IndexOf(cmbReader.Text);
  cmbSite.ItemIndex := cmbSite.Items.IndexOf(cmbSite.Text);
  cmbSpecialty.ItemIndex := cmbSpecialty.Items.IndexOf(cmbSpecialty.Text);
end;

procedure TfrmAddEditReader.FormShow(Sender: TObject);
begin
  lblInstruct.Caption := sInstructions;
  PopulateComboBoxes;
  SetSelections;
  cmbSpecialtyChange(nil);
  SetCombosReadOnly(Self);
  bChange := false;
  GetFormPosition(self);
end;

function GetReaderText(Node: TTreeNode; TextLevel: integer): string;
var TextNode: TTreeNode;
begin
  TextNode := Node;
  while TextNode.Level > TextLevel do TextNode := TextNode.Parent;
  result := TextNode.Text;
end;

procedure TfrmAddEditReader.PopulateTheForm(Node: TTreeNode);
//on an add need to populate all parent components
//ex: if a new specialty is being added, the reader and site are prepoulated with the data
//for which this specialty is being added
var NDX: integer;
begin
  NDX := Node.Level;
  if NDX >= 3 then
  begin
    cmbProcedure.Text := GetReaderText(Node, 3);
    cmbProcedure.Enabled := false;
  end;
  if NDX >= 2 then
  begin
    cmbSpecialty.Text := GetReaderText(Node, 2);
    cmbSpecialty.Enabled := false;
  end;
  if NDX >= 1 then
  begin
    cmbSite.Text := GetReaderText(Node, 1);
    cmbSite.Enabled := false;
  end;
  if NDX >= 0 then
  begin
    cmbReader.Text := GetReaderText(Node, 0);
    cmbReader.Enabled := false;
  end;
  caption := 'Add to ' + Node.Text;
end;

procedure TfrmAddEditReader.cmbSpecialtyChange(Sender: TObject);
//if specialty selected, the procedure combo box is wiped, and the list of availbale selection changes
//since the procedure is a subset of the specialty
var sIEN: string;
begin
  bChange := true;
  cmbProcedure.ItemIndex := -1;
  if cmbSpecialty.ItemIndex = -1 then
  begin
    cmbProcedure.Items.Clear;
  end
  else
  begin
    sIEN := TIENObj(cmbSpecialty.Items.Objects[cmbSpecialty.ItemIndex]).sIEN;
    PopulateComboBoxRPC(cmbProcedure, 'MAG4 INDEX GET EVENT', sIEN, 3);
    if slAlreadyAddedPrivliges <> nil then RemoveAlreadyAddedPrivileges(cmbProcedure);
  end;
  btnSave.Enabled := AllMandatoryFieldsSelected(Self);
end;

//this is the mumps code for the rpc called below
{S MAGNFDA(2006.5843,"?+1,",.01)=MAGPARAM("READER")
 S MAGNFDA(2006.58431,"?+2,?+1,",.01)=MAGPARAM("ACQUISITION SITE")
 S MAGNFDA(2006.58431,"?+2,?+1,",.5)=MAGPARAM("ACQUISITION SITE STATUS")
 S MAGNFDA(2006.584311,"?+3,?+2,?+1,",.01)=MAGPARAM("SPECIALTY INDEX")
 S MAGNFDA(2006.584311,"?+3,?+2,?+1,",.5)=MAGPARAM("SPECIALTY INDEX STATUS")
 S MAGNFDA(2006.5843111,"?+4,?+3,?+2,?+1,",.01)=MAGPARAM("PROCEDURE INDEX")
 S MAGNFDA(2006.5843111,"?+4,?+3,?+2,?+1,",.5)=MAGPARAM("PROCEDURE INDEX STATUS")
 S MAGNFDA(2006.5843111,"?+4,?+3,?+2,?+1,",1)=MAGPARAM("PROCEDURE INDEX USER PREFERENCE")}
procedure TfrmAddEditReader.btnSaveClick(Sender: TObject);
var sResult: string;
    sError : String;  //P127T6 NST 12/03/2012 Error message variable
begin
  DataModule1.Broker.RemoteProcedure := 'MAG3 TELEREADER READER SETUP';
  DataModule1.Broker.Param[0].PType := list;
  DataModule1.Broker.Param[0].Value := '.x';
  DataModule1.Broker.Param[0].Mult['"READER"'] := TIENObj(cmbReader.Items.Objects[cmbReader.ItemIndex]).sIEN;
  DataModule1.Broker.Param[0].Mult['"ACQUISITION SITE"'] := TIENObj(cmbSite.Items.Objects[cmbSite.ItemIndex]).sIEN;
  DataModule1.Broker.Param[0].Mult['"ACQUISITION SITE STATUS"'] := '1';
  DataModule1.Broker.Param[0].Mult['"SPECIALTY INDEX"'] := TIENObj(cmbSpecialty.Items.Objects[cmbSpecialty.ItemIndex]).sIEN;
  DataModule1.Broker.Param[0].Mult['"SPECIALTY INDEX STATUS"'] := '1';
  DataModule1.Broker.Param[0].Mult['"PROCEDURE INDEX"'] := TIENObj(cmbProcedure.Items.Objects[cmbProcedure.ItemIndex]).sIEN;
  DataModule1.Broker.Param[0].Mult['"PROCEDURE INDEX STATUS"'] := '1';
  DataModule1.Broker.Param[0].Mult['"PROCEDURE INDEX USER PREFERENCE"'] := '1';
  DataModule1.Broker.Param[0].Mult['"ACTION"'] := 'ADD';
  try
    sResult := DataModule1.Broker.strCall;
     //P127T6 NST 12/03/2012 Check for RPC error message
    if MagSTRPiece(sResult,'^',1)='0' then
    begin
      sError := MagSTRPiece(sResult,'^',2);
      MessageDlg508(sError, mtError, [mbOK], self.Handle);
      MagLogger.Log('ERROR', '[' + DataModule1.Broker.RemoteProcedure + ']  ' + sError);
    end
    else
    begin
      MagLogger.Log('INFO', 'Successful Edit to Telereader Reader file.');
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

procedure TfrmAddEditReader.HelpClick(Sender: TObject);
var s, sFile: string;
begin
  case TImage(Sender).Tag of
    1: sFile := '2006.5843';
    2: sFile := '2006.58431';
    3: sFile := '2006.584311';
    4: sFile := '2006.5843111';
  end;
  s := GetDataDictionaryHelp(sFile, '.01');
  MessageDlg508(s, mtInformation, [mbOK], self.Handle);
end;

procedure TfrmAddEditReader.FormKeyDown(Sender: TObject; var Key: Word;
  Shift: TShiftState);
begin
  if Key = F1KEY then
  begin
    if ControlHasHelpText(ActiveControl) then
      begin
        if ActiveControl.Tag = 508  then
        begin
          if ActiveControl.Name = 'cmbReader2' then HelpClick(imgReader)
          else if ActiveControl.Name = 'cmbSite2' then HelpClick(imgSite)
          else if ActiveControl.Name = 'cmbSpecialty2' then HelpClick(imgSpecialty);
        end
        else
        begin
          if ActiveControl.Name = 'cmbReader' then HelpClick(imgReader)
          else if ActiveControl.Name = 'cmbSite' then HelpClick(imgSite)
          else if ActiveControl.Name = 'cmbSpecialty' then HelpClick(imgSpecialty)
          else if ActiveControl.Name = 'cmbProcedure' then HelpClick(imgProcedure);
        end;
      end
    else
      begin
        OpenHelpFile;
      end
  end;
end;

procedure TfrmAddEditReader.RemoveAlreadyAddedPrivileges(CB: TComboBox);
var i, NDX: integer;
begin
  for i := 0 to slAlreadyAddedPrivliges.Count - 1 do
  begin
    NDX := CB.Items.IndexOf(slAlreadyAddedPrivliges.Strings[i]);
    if NDX > -1 then CB.Items.Delete(NDX);
  end;
end;

procedure TfrmAddEditReader.FormClose(Sender: TObject;
  var Action: TCloseAction);
begin
  SaveFormPosition(self);
end;

procedure TfrmAddEditReader.edtNameSearchKeyDown(Sender: TObject;
  var Key: Word; Shift: TShiftState);
var sName: string;
begin
  if KEY = VK_RETURN then
  begin
    sName := UpperCase(trim(edtNameSearch.Text));
    if length(sName) < 2 then
    begin
      ShowMessage508('Name search string must contain at least 2 characters', self.Handle);
      exit;
    end;
    cmbReader.Text := '';
    cmbReader.Items.Clear;
    cmbReader.ItemIndex := -1;
    GetUserNames(sName);
  end;
end;

procedure TfrmAddEditReader.GetUserNames(SearchStr: string);
var i: integer; sIEN, sReader: string; RecordObj: TFMRecordObj; sl: TStringList;
    Lister: TMagFMLister;
begin
  sl := TStringList.Create;
  Lister := TMagFMLister.Create(nil);
  try
    Lister.RPCBroker := DataModule1.Broker;
    Lister.Number := '200';
    Lister.FMIndex := 'B';
    Lister.Screen := 'I $L($P(^VA(200,Y,0),U,3)),$D(^XMB(3.7,+Y,0)),$$ACTIVE^XUSER(Y)';
    Lister.PartList.Add(SearchStr);
    try
      Lister.Retrieve('200', '.01');
      //Lister.Retrieve('200', '@' + LST_DEL +'.01');
      MagLogger.Log('INFO', 'Name lookup successful.');
    except
      on e: exception do
      begin
        MagLogger.Log('ERROR', e.Message);
        raise;
      end;
    end;
    for i := 0 to Lister.Results.Count - 1 do
    begin
      sIEN := Lister.Results[i];
      RecordObj := Lister.GetRecord(sIEN);
      sReader := RecordObj.GetField(RecordObj.FMFLDValues[0]).FMDBExternal;
      if pos(STR_DEL + sReader + STR_DEL, UpperCase(sAlreadyAddedReaders)) = 0 then
        cmbReader.Items.AddObject(sReader, TIENObj.Create(sIEN));
    end;
    if cmbReader.Items.Count = 0 then
    begin
      ShowMessage508('No matches were found for search string against the list of active users who do not yet have rights.', self.Handle);
      exit;
    end;
    cmbReader.ItemIndex := 0;
    cmbReader.SetFocus;
  finally
    Lister.Free;
    sl.Free;
  end;
end;

procedure TfrmAddEditReader.PopulateReaderComboWithSelection(SelectedNode: TTreeNode);
var Node: TTreeNode; sIEN: string;
begin
  Node := SelectedNode;
  while Node.Level > 0 do Node := Node.Parent;
  sIEN := TReader(Node.Data).FReaderIEN;
  cmbReader.AddItem(Node.Text, TIenObj.Create(sIEN));
end;

procedure TfrmAddEditReader.FormDestroy(Sender: TObject);
begin
  FreeStringsIENObj(cmbReader.Items);
  FreeStringsIENObj(cmbSite.Items);
  FreeStringsIENObj(cmbSpecialty.Items);
  FreeStringsIENObj(cmbProcedure.Items);
end;

end.
