unit fMAGAcquisitionSetup;
{Package: MAG - VistA Imaging
WARNING: Per VHA Directive 10-93-142 this unit should not be modified.
Date Created: 08/2009
Site Name: Silver Spring, OIFO
Developers: Bill Balshem
[==   unit fMAGTeleReaderAdminMain;
 Description:  This is the main form for the Acquisition site configuration. There are 2 tabs.
 Consult Types to go the unread list & DICOM geteawy setup.

 The Consult types tab displays current consult types (File #2006.5841) going to the unread list (File #2006.5849) for the Telereader application.
 When a consultation for a patient is entered into the db, the Vista system will automatically place that conulst on the unread list,
 to be reviewed by doctors at the reader sites. The user can, edit or delete conult types from the unerad list.

 The DICOM tab display current shows current consults set up for the DICOM gateway, so images can be associated with consults on the unread list.
  The DICOM configuration file is (2006.5831). The user can add, edit and delete records from this file as well.
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
  Dialogs, Menus, ComCtrls, StdCtrls, Buttons, ExtCtrls, ActnList, ImgList,
  VA508AccessibilityManager;

type
  TfrmAcquisitionSetup = class(TForm)
    amgrMain: TVA508AccessibilityManager;
    pnlBottom: TPanel;
    btnAdd: TBitBtn;
    btnClose: TBitBtn;
    btnDelete: TBitBtn;
    btnEdit: TBitBtn;
    popUnreadList: TPopupMenu;
    miEdit: TMenuItem;
    miDelete: TMenuItem;
    miAdd: TMenuItem;
    PageControl1: TPageControl;
    tsConsults: TTabSheet;
    lblConsults: TLabel;
    lvConsultTypes: TListView;
    pnlDetail: TPanel;
    lblSite1: TLabel;
    lblServiceName1: TLabel;
    lblProcedure1: TLabel;
    lblSpecialty1: TLabel;
    lblProcIndex1: TLabel;
    lblTrigger1: TLabel;
    lblTIU1: TLabel;
    lblSiteDetail: TLabel;
    lblServiceNameDetail: TLabel;
    lblProcedureDetail: TLabel;
    lblSpecialtyIndexDetail: TLabel;
    lblProcedureIndexDetail: TLabel;
    lblTriggerDetail: TLabel;
    lblTIUDetail: TLabel;
    tsADicom: TTabSheet;
    lvDICOM: TListView;
    Label1: TLabel;
    ActionListAcq: TActionList;
    actAdd: TAction;
    actEdit: TAction;
    actDelete: TAction;
    AcquisitionMainMenu: TMainMenu;
    mmiFile: TMenuItem;
    mmiHelp: TMenuItem;
    mmiAdd: TMenuItem;
    mmiEdit: TMenuItem;
    mmiDelete: TMenuItem;
    mmiContents: TMenuItem;
    mmiClose: TMenuItem;
    Panel1: TPanel;
    lblSiteDetailMWL: TLabel;
    lblServiceNameDetailMWL: TLabel;
    lblProcedureDetailMWL: TLabel;
    lblSpecialtyIndexDetailMWL: TLabel;
    lblProcedureIndexDetailMWL: TLabel;
    Label9: TLabel;
    Label10: TLabel;
    Label11: TLabel;
    Label12: TLabel;
    Label13: TLabel;
    Label14: TLabel;
    Label15: TLabel;
    lblCPTCodeDetailMWL: TLabel;
    lblHL7DetailMWL: TLabel;
    lblSiteMWL: TLabel;
    lblServiceNameMWL: TLabel;
    lblProcedurelMWL: TLabel;
    lblSpecialtyIndexMWL: TLabel;
    lblProcedureIndexMWL: TLabel;
    lblCPTCodeMWL: TLabel;
    lblHL7MWL: TLabel;
    lblClinicsMWL: TLabel;
    lblClinicsDetailMWL: TLabel;
    ImageList1: TImageList;
    actClose: TAction;
    procedure lvConsultTypesSelectItem(Sender: TObject; Item: TListItem;
      Selected: Boolean);
    procedure AddRecord(Sender: TObject);
    procedure EditRecord(Sender: TObject);
    procedure DeleteRecord(Sender: TObject);
    procedure btnCloseClick(Sender: TObject);
    procedure FormShow(Sender: TObject);
    procedure PopulateConsultListView;
    procedure ClearDisplayLabels;
    procedure PopulateDICOMListView;
    procedure SetAddEditDelete;
    procedure PageControl1Change(Sender: TObject);
    procedure lvDICOMSelectItem(Sender: TObject; Item: TListItem;
      Selected: Boolean);
    procedure AddDICOM;
    procedure EditDICOM;
    procedure AddUnreadList;
    procedure EditUnreadList;
    procedure ListViewColumnClick(Sender: TObject; Column: TListColumn);
    procedure ListViewDblClick(Sender: TObject);
    procedure SetHints;
    procedure FormKeyDown(Sender: TObject; var Key: Word;
      Shift: TShiftState);
    procedure mmiContentsClick(Sender: TObject);
    procedure FormClose(Sender: TObject; var Action: TCloseAction);
    procedure actCloseExecute(Sender: TObject);
    procedure ListViewCompare(Sender: TObject; Item1, Item2: TListItem;
      Data: Integer; var Compare: Integer);
  private
    { Private declarations }
    Descending: Boolean; // P110T10 NST 06/06/2013 Sorting order f the lisvtiew
    ColumnToSort : Integer;  // P110T10 NST 06/06/2013 Column to sort order f the lisvtiew

    procedure ClearDisplayLabelsMWL;  // P110T1 NST 04/26/2012
  public
    { Public declarations }
  end;

var
  frmAcquisitionSetup: TfrmAcquisitionSetup;

implementation

uses
  fMAGAddEditUnreadList, fMAGAddEditDICOM, MagFMComponents, DiTypLib, dmMAGTeleReaderAdmin, uMAGGlobalsTRA, trpcb,
  MagFileVersion;

{$R *.dfm}

procedure TfrmAcquisitionSetup.lvConsultTypesSelectItem(Sender: TObject;
  Item: TListItem; Selected: Boolean);
//Populate detail panel with data from selecetd item in list item
begin
  //if Item <> nil then begin
  if selected then begin
    lblServiceNameDetail.Caption := Item.Caption;
    lblProcedureDetail.Caption := Item.SubItems[0];
    lblSpecialtyIndexDetail.Caption := Item.SubItems[1];
    lblProcedureIndexDetail.Caption := Item.SubItems[2];
    lblSiteDetail.Caption := Item.SubItems[3];
    lblTriggerDetail.Caption := Item.SubItems[4];
    lblTIUDetail.Caption := Item.SubItems[5];
  end
  else ClearDisplayLabels;
  SetAddEditDelete;
end;

function GetAddedServiceNames(lv: TListView): string;
//Builds a Pipe delimited list of services already entered in the Unread List Configuration File(#2006.5841)
//This is the primary key a can only be in one entry for the file. This list is passed to the add screen and the services are removed as choices from the
//services name combo box
var i: integer;
begin
  result := '';
  for i := 0 to lv.Items.Count -1 do
    result := result + STR_DEL + TListItem(lv.Items[i]).caption;
  result := result + STR_DEL;
end;

procedure TfrmAcquisitionSetup.AddRecord(Sender: TObject);
begin
  case PageControl1.ActivePageIndex of
    0: AddUnreadList;
    1: AddDICOM;
  end;
end;

procedure TfrmAcquisitionSetup.AddUnreadList;
var frm: TfrmAddEditUnreadList;
begin
  frm := TfrmAddEditUnreadList.Create(nil);
  try
    frm.Caption := 'Add ' + frm.Caption;
    frm.sIEN := emptystr;  //only needed to track edited reocrds to unread list
    frm.sAlreadyAddedServices := GetAddedServiceNames(lvConsultTypes);
    if frm.ShowModal = mrOK then
      PopulateConsultListView;  //Referesh the view after post to the db
  finally
    frm.Free;
  end;
end;

// P110T1 NST 04/26/2012  Use Actions
procedure TfrmAcquisitionSetup.actCloseExecute(Sender: TObject);
begin
  close
end;

procedure TfrmAcquisitionSetup.AddDICOM;
var frm: TfrmAddEditDICOM;
begin
  frm := TfrmAddEditDICOM.Create(nil);
  try
    frm.Caption := 'Add ' + frm.Caption;
    frm.sIEN := emptystr;
    // P110T1 NST 04/26/2012 user can select multiple services
    //frm.sAlreadyAddedServices := GetAddedServiceNames(lvDICOM); //list of already added services (see 'GetAddedServiceNames' function notes)
    if frm.ShowModal = mrOK then
      PopulateDICOMListView;
  finally
    frm.Free;
  end;

end;

procedure TfrmAcquisitionSetup.EditRecord(Sender: TObject);
begin
  case PageControl1.ActivePageIndex of
    0: EditUnreadList;
    1: EditDICOM;
  end;
end;

procedure TfrmAcquisitionSetup.EditUnreadList;
var frm: TfrmAddEditUnreadList; Item: TListItem;
begin
  frm := TfrmAddEditUnreadList.Create(nil);
  try
    with frm do begin
      Caption := 'Edit ' + frm.Caption;
      Item := lvConsultTypes.Selected;
      cmbName.Text := Item.Caption;
      cmbProcedure.Text := Item.SubItems[0];
      cmbSpecialtyIndex.Text := Item.SubItems[1];
      cmbProcedureIndex.Text := Item.SubItems[2];
      cmbSite.Text := Item.SubItems[3];
      cmbTrigger.Text := Item.SubItems[4];
      //P127T1 NST 04/13/2012 set TIU as it is cmbTIU.Text := trim(Item.SubItems[5]);
      cmbTIU.Text := Item.SubItems[5];
      cmbName.Enabled := false; //Service Name is primary key of record and cannot be edited
      cmbProcedure.Enabled := false;   //P127T1 NST 04/13/2012 Service and Procedure are key fields
                                       // and cannot edit them.
      sIEN := TFMRecordObj(Item.Data).IEN; //pass unreadlist record IEN to edit screen
      if In508Mode then SetControlFor508(frm.cmbName, 0, frm.gpConsult);
      if ShowModal = mrOK then
        PopulateConsultListView;
    end;
  finally
    frm.Free;
  end;
end;

procedure TfrmAcquisitionSetup.EditDICOM;
var frm: TfrmAddEditDICOM; Item: TListItem;
begin
  frm := TfrmAddEditDICOM.Create(nil);
  try
    with frm do begin
      Caption := 'Edit ' + frm.Caption;
      Item := lvDICOM.Selected;
      // P110T1 NST 04/26/2012  Set the new fields on the form
      cmbName.Text := Item.Caption;
      cmbProcedure.Text := Item.SubItems[0];
      cmbSpecialtyIndex.Text := Item.SubItems[1];
      cmbProcedureIndex.Text := Item.SubItems[2];
      cmbSite.Text := Item.SubItems[3];
      edtCPTCode.Text := Item.SubItems[4];
      CPTCodeIEN := TIENObj(Item.SubItems.Objects[4]).sIEN;
      cmbHL7.Text := Item.SubItems[5];

      if length(Item.SubItems[6]) > 0 then
        lstClinic.Items := TStringList(lvDicom.Selected.SubItems.Objects[6]);

      sIEN := TIENObj(Item.Data).sIEN;

      cmbName.Enabled := false; //Service Name is primary key of record and cannot be edited
      cmbProcedure.Enabled := false;   // Service and Procedure are key fields and cannot edit them.

      if In508Mode then SetFormFor508(frm);
      if ShowModal = mrOK then
        PopulateDICOMListView;
    end;
  finally
    frm.Free;
  end;
end;

procedure TfrmAcquisitionSetup.DeleteRecord(Sender: TObject);
var sResult: string;
begin

  case PageControl1.ActivePageIndex of
    0: // Consults (unread list)
    begin
      if MessageDlg508('Are you sure you want to delete ' + lvConsultTypes.Selected.Caption + '?', mtConfirmation, [mbOK, mbCancel], self.Handle) = mrOK then
      begin
        DataModule1.Broker.RemoteProcedure := 'MAG3 TELEREADER ACQ SRVC SETUP';
        DataModule1.Broker.Param[0].PType := list;
        DataModule1.Broker.Param[0].Value := '.x';
        DataModule1.Broker.Param[0].Mult['"ACTION"'] := 'DELETE';
        DataModule1.Broker.Param[0].Mult['"IEN"'] := TFMRecordObj(lvConsultTypes.Selected.Data).IEN;
        try
         sResult := DataModule1.Broker.strCall;
         MagLogger.Log('INFO', 'Removed record from Telereader Acquisition Service file.');
         PopulateConsultListView;
         if lvConsultTypes.Items.Count = 0 then ClearDisplayLabels;
        except
          on e: exception do
          begin
            MagLogger.Log('ERROR', e.Message);
            raise;
          end; //on e....
        end; //except
      end; //if Message...
    end; //case 0...
    1: // DICOM
    begin
      if MessageDlg508('Are you sure you want to delete ' + lvDICOM.Selected.Caption + '?', mtConfirmation, [mbOK, mbCancel], self.Handle) = mrOK then
      begin
        DataModule1.Broker.RemoteProcedure := 'MAG3 TELEREADER PDR SRVC SETUP';
        DataModule1.Broker.Param[0].PType := list;
        DataModule1.Broker.Param[0].Value := '.x';
        DataModule1.Broker.Param[0].Mult['"ACTION"'] := 'DELETE';
        DataModule1.Broker.Param[0].Mult['"IEN"'] := TIENObj(lvDICOM.Selected.Data).sIEN;
        try
         sResult := DataModule1.Broker.strCall;
         MagLogger.Log('INFO', 'Removed record from DICOM Healthcare Provider Service file.');
         PopulateDICOMListView;
        except
          on e: exception do
          begin
            MagLogger.Log('ERROR', e.Message);
            raise;
          end; // on e....
        end; //except
      end; //if message...
    end; //1: begin...
  end; //case statement

end;

procedure TfrmAcquisitionSetup.btnCloseClick(Sender: TObject);
begin
  Close;
end;

procedure TfrmAcquisitionSetup.FormShow(Sender: TObject);
begin
  PageControl1.ActivePageIndex := 0;
  PopulateConsultListView;
  PopulateDICOMListView;
  SetHints;
  ResizeListViewColumns(self, lvConsultTypes);
  ResizeListViewColumns(self, lvDICOM);
  GetFormPosition(self);
end;

function AddCodeToTriggerText(sText: string): string;
var iPos: integer; sIEN: string;
begin
  sText := UpperCase(sText);
  iPos := pos(sText, sTriggers);
  sIEN := copy(sTriggers, iPos - 2, 1);
  result := FormatTriggerText(sIEN, sText);
end;

procedure TfrmAcquisitionSetup.PopulateConsultListView;
var Lister : TMagFMLister; sIEN: string; i, j: integer;
    RecordObj: TFMRecordObj; Item: TListItem;
begin
  lvConsultTypes.Items.Clear;
  Lister := TMagFMLister.Create(nil);
  try
    Lister.RPCBroker := DataModule1.Broker;
    //.01 = Service Name, 1 = Procedure(optional), 2 = specialty index, 3 = procedure index, 4 = acquiistion site, 5 = trigger, 6 = TIU Note
    try
      // NST 11/30/2012 P127T6 Add Internal value of field field '4I'
      Lister.Retrieve('2006.5841', '.01' + LST_DEL + '4I' + LST_DEL + '1' + LST_DEL + '2' + LST_DEL + '3' + LST_DEL + '4' +  LST_DEL + '5' + LST_DEL + '6');
      MagLogger.Log('INFO', 'Retrieved Telereader Acquisition Service file data.');
    except
      on e: exception do
      begin
        MagLogger.Log('ERROR', e.Message);
        raise;
      end;
    end;
    if Lister.Results.Count = 0 Then exit;
    for i := 0 to Lister.Results.Count - 1 Do
    begin
      Item := lvConsultTypes.Items.Add;
      sIEN := Lister.Results[i];
      RecordObj := Lister.GetRecord(sIEN);
      Item.Data := RecordObj; //Record object is structure that stores rerived data from rpc, save structure to the listitem that displays record data
                              //IEN values may be needed if for post call if the user edits/deletes threcord
      Item.Caption := RecordObj.GetField(RecordObj.FMFLDValues[0]).FMDBExternal;
      for j := 2 To RecordObj.FMFLDValues.Count - 1 do
        Item.SubItems.Add(RecordObj.GetField(RecordObj.FMFLDValues[j]).FMDBExternal);

      Item.SubItems[4] := AddCodeToTriggerText(Item.SubItems[4]); //see function notes above
      // NST 11/30/2012 P127T6 Get Station number by IEN
      sIEN := RecordObj.GetField(RecordObj.FMFLDValues[1]).FMDBExternal;
      Item.SubItems[3]:= FormatSiteText(Item.SubItems[3] , GetSiteStationNoFromIEN(sIEN));
    end;
  finally
    // NST 06/06/2013
    // P110 T10 sort the listview after refresh
    if lvConsultTypes.Tag > -1 then
    begin
      ColumnToSort := lvConsultTypes.Tag;
      Descending := (lvConsultTypes.Columns[ColumnToSort].Tag = 1);
      lvConsultTypes.AlphaSort;
    end;
    
    Lister.Free;
  end;
  // NST 11/30/2012 P127T6 The stations numbers are appended when we populate the list
  //  AddStationNumToSiteCol(lvConsultTypes, 5);
  ClearDisplayLabels;
end;

procedure TfrmAcquisitionSetup.ClearDisplayLabels;
begin
  lblSiteDetail.Caption := emptystr;
  lblServiceNameDetail.Caption := emptystr;
  lblProcedureDetail.Caption := emptystr;
  lblSpecialtyIndexDetail.Caption := emptystr;
  lblProcedureIndexDetail.Caption := emptystr;
  lblTriggerDetail.Caption := emptystr;
  lblTIUDetail.Caption := emptystr;
end;

procedure TfrmAcquisitionSetup.PopulateDICOMListView;
var sl, slClinics: TStringList; i, j: integer; Item: TListItem;
    s, sText, sIEN, sClinics, sSite, sSiteIEN, sStation: string;
const DEL = '^'; SUBDEL = '~';
begin
  FreeListViewIENObj(lvDICOM);  // P110T1 NST 05/01/2012 Free IENs first
  lvDICOM.Items.Clear;
  sl := TStringList.Create;
  DataModule1.Broker.RemoteProcedure := 'MAG3 TELEREADER DHPS LIST';
  try
    try
      DataModule1.Broker.lstcall(sl);
      MagLogger.Log('INFO', 'Ref data retrieval MAG3 TELEREADER DHPS LIST call successful.');
    except
      on e: exception do
      begin
        MagLogger.Log('ERROR', e.Message);
        raise;
      end;
    end;
    for i := 2 to sl.Count - 1 do  // first 2 strings: 0 = result, 1 = headings
    begin
      sClinics := '';
      // P110T1 NST 04/26/2012  Populate the grid with the new fields
      s := sl.Strings[i]; //4^4^CARDIOLOGY^^^2^CARDIOLOGY^^^660^SALT LAKE CITY^39~CARDIOLOGY^4~EYE CLINIC~67~EYE PHOTOGRAPHY CLINIC
      Item := lvDICOM.Items.Add;
      Item.Data := TObject(TIENObj.Create(MagSTRPiece(s, DEL, 1))); //IEN
      Item.Caption := MagSTRPiece(s, DEL, 3); //service
      Item.SubItems.Add(MagSTRPiece(s, DEL, 5)); //procedure
      Item.SubItems.Add(MagSTRPiece(s, DEL, 7)); //specialty index
      Item.SubItems.Add(MagSTRPiece(s, DEL, 9)); //procedure index
      //acquisition site
      sSiteIEN := MagSTRPiece(s, DEL, 10);
      sSite := MagSTRPiece(s, DEL, 11);
      sStation := GetSiteStationNoFromIEN(sSiteIEN); // NST 11/20/2012 P127T6 Use site IEN intead Site name
      Item.SubItems.Add(FormatSiteText(sSite, sStation));
      Item.SubItems.AddObject(MagSTRPiece(s, DEL, 13),TIENObj.Create(MagSTRPiece(s, DEL, 12))); //CPT Code
      Item.SubItems.Add(MagSTRPiece(s, DEL, 15)); //HL7 Subcriber List
      s := MagSTRPiece(s, DEL, 16); //4~EYE CLINIC~67~EYE PHOTOGRAPHY CLINIC
      j := 1;
      sIEN := MagSTRPiece(s, SUBDEL, j);
      if sIEN <> '' then begin
        slClinics := TStringList.Create;
        while sIEN <> '' do //clinics
        begin
          sText := MagSTRPiece(s, SUBDEL, j + 1);
          slClinics.AddObject(sText, TObject(TIENObj.Create(siEN)));
          if sClinics = '' then
            sClinics := sText
          else
            sClinics := sClinics + ', ' + sText;
          Inc(j, 2);
          sIEN := MagSTRPiece(s, SUBDEL, j);
        end;
        Item.SubItems.AddObject(sClinics, slClinics);
      end
      else
      begin
        Item.SubItems.Add('');
      end;
    end;
  finally
    // NST 06/06/2013
    // P110 T10 sort the listview after refresh
    if lvDICOM.Tag > -1 then
    begin
      ColumnToSort := lvDICOM.Tag;
      Descending := (lvDICOM.Columns[ColumnToSort].Tag = 1);
      lvDICOM.AlphaSort;
    end;

    ClearDisplayLabelsMWL;   // P110T1 NST 04/26/2012
    sl.Free;
  end;
end;

// P110T1 NST 04/26/2012  Set hints of the actions
procedure TfrmAcquisitionSetup.SetHints;
begin
  if PageControl1.ActivePageIndex = 0 then
  begin
    actAdd.Hint := 'Add a Consult Type to the Unread List';
    actEdit.Hint := 'Edit a Consult Type on the Unread List';
    actDelete.Hint := 'Remove a Consult Type from the Unread List';
  end
  else
  begin
    actAdd.Hint := 'Add a Consult Type to the DICOM Gateway Modality Worklist';
    actEdit.Hint := 'Edit a Consult Type on the DICOM Gateway Modality Worklist';
    actDelete.Hint := 'Remove a Consult Type from the DICOM Gateway Modality Worklist';
  end
end;

procedure TfrmAcquisitionSetup.SetAddEditDelete;
var lv: TlistView;
begin
  if PageControl1.ActivePageIndex = 0 then
    lv := lvConsultTypes
  else
    lv := lvDICOM;
  actEdit.Enabled := lv.Selected <> nil;
  actDelete.Enabled := lv.Selected <> nil;
  SetHints;
end;

procedure TfrmAcquisitionSetup.PageControl1Change(Sender: TObject);
begin
  SetAddEditDelete;
end;

procedure TfrmAcquisitionSetup.ListViewCompare(Sender: TObject; Item1,
  Item2: TListItem; Data: Integer; var Compare: Integer);
var
  ix: Integer;
begin
  // P110 T10 NST 06/06/2013
  // Use a new sort method to resolve an issue with attached objects
  // to the items of the listview
  if ColumnToSort = 0 then
    Compare := CompareText(Item1.Caption,Item2.Caption)
  else begin
   ix := ColumnToSort  - 1;
   Compare := CompareText(Item1.SubItems[ix],Item2.SubItems[ix]);
  end;

  if Descending then Compare := -Compare;
end;

procedure TfrmAcquisitionSetup.lvDICOMSelectItem(Sender: TObject;
  Item: TListItem; Selected: Boolean);
  // P110T1 NST 04/26/2012
  //Populate detail panel with data from selected item in list item
begin
  if selected then begin
    lblServiceNameDetailMWL.Caption := Item.Caption;
    lblProcedureDetailMWL.Caption := Item.SubItems[0];
    lblSpecialtyIndexDetailMWL.Caption := Item.SubItems[1];
    lblProcedureIndexDetailMWL.Caption := Item.SubItems[2];
    lblSiteDetailMWL.Caption := Item.SubItems[3];
    lblCPTCodeDetailMWL.Caption := Item.SubItems[4];
    lblHL7DetailMWL.Caption := Item.SubItems[5];
    lblClinicsDetailMWL.Caption := Item.SubItems[6];
   end
  else ClearDisplayLabelsMWL;
  SetAddEditDelete;
end;

procedure TfrmAcquisitionSetup.ListViewDblClick(Sender: TObject);
begin
  if TListView(Sender).Selected <> nil then EditRecord(nil);
end;

procedure TfrmAcquisitionSetup.ListViewColumnClick(Sender: TObject; Column: TListColumn);
begin
  // P110T10 NST 06/06/2013 Modified sorting method
  if Column.Tag = 0 then Column.Tag := 1 else Column.Tag := 0; //tag 1 = sort ascending, 0 = sort descending
  (Sender as TCustomListView).Tag := Column.Index;

  Descending :=  (Column.Tag = 1);
  ColumnToSort := (Sender as TCustomListView).Tag;

  (Sender as TCustomListView).AlphaSort;
end;

procedure TfrmAcquisitionSetup.FormKeyDown(Sender: TObject; var Key: Word;
  Shift: TShiftState);
begin
  if Key = F1KEY then OpenHelpFile;
end;

procedure TfrmAcquisitionSetup.mmiContentsClick(Sender: TObject);
begin
  OpenHelpFile;
end;

procedure TfrmAcquisitionSetup.FormClose(Sender: TObject;
  var Action: TCloseAction);
begin
  SaveFormPosition(self);
  FreeListViewIENObj(lvDICOM);
end;

// P110T1 NST 04/26/2012
procedure TfrmAcquisitionSetup.ClearDisplayLabelsMWL;
begin
  lblServiceNameDetailMWL.Caption := '';
  lblProcedureDetailMWL.Caption := '';
  lblSpecialtyIndexDetailMWL.Caption := '';
  lblProcedureIndexDetailMWL.Caption := '';
  lblSiteDetailMWL.Caption := '';
  lblCPTCodeDetailMWL.Caption := '';
  lblHL7DetailMWL.Caption := '';
  lblClinicsDetailMWL.Caption := '';
end;

end.
