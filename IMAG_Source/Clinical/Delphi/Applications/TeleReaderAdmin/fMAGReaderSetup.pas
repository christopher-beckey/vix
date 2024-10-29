unit fMAGReaderSetup;
{Package: MAG - VistA Imaging
WARNING: Per VHA Directive 10-93-142 this unit should not be modified.
Date Created: 08/2009
Site Name: Silver Spring, OIFO
Developers: Bill Balshem
[==   unit ffMAGReaderSetup;
 Description:  This is the main form for the Reader site configuration. There are 2 tabs.
 Acquisition sites & Reader setup.

 The Acquisition Site tab displays acquisition locations from which the reader site can read consults from the unread list (File #2006.5842).
 The user can add, edit, delete sites from which to read consults from. The sights can be made active/inactive.

 The Reader tab displays the readers configured to read conults from those sites and what their rights are. Reader Privileges file(File #2006.5843)
 Each Reader is set up with rights to one or more acquisiton sites (as defined on the acquisition sites tab). With each acquisition site the iuser has rights
 to one of more specialty. Within each specialty per acquisition site, the user has rights to one or more procedures.
 The user can add new readers, or add subcomponents (sites, specialies, procedures) to each reader. The rights for a reader can be activated, deactivated at any
 level as well) The Add button adds new components to the reader based upon the selected node when the add button is clicked. For example: A reader
 (Joe Smith) has right s to acquisition site = Salt Lake City, specialty = Eye Care, Procedure = Eye Exam. If Joe Smith if selected then a new aquistion site will
 be added, if Salt Lake City is selected, then a new specialty will be added etc...
 A reader must have at least one site, specialty, procedure. If a reader has one procedure and that procedure is prompted to be deleted, than the entire reader record mut be deleted.
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
  Dialogs, StdCtrls, Buttons, ExtCtrls, ComCtrls, ImgList, Menus, uMAGGlobalsTRA,
  ActnList, VA508AccessibilityManager;

type
  TfrmReaderSetup = class(TForm)
    amgrMain: TVA508AccessibilityManager;
    PageControl1: TPageControl;
    tsSites: TTabSheet;
    lvSite: TListView;
    tsReaders: TTabSheet;
    tvReaders: TTreeView;
    pnlBottom: TPanel;
    btnClose: TBitBtn;
    btnAdd: TBitBtn;
    btnEdit: TBitBtn;
    btnDelete: TBitBtn;
    btnNew: TBitBtn;
    popSite: TPopupMenu;
    miSiteAdd: TMenuItem;
    miSiteEdit: TMenuItem;
    miSiteDelete: TMenuItem;
    popReader: TPopupMenu;
    miRdrAdd: TMenuItem;
    miRdrEdit: TMenuItem;
    miRdrDelete: TMenuItem;
    ImageList1: TImageList;
    miNew: TMenuItem;
    btnExpand: TBitBtn;
    btnCollapse: TBitBtn;
    Label1: TLabel;
    Label2: TLabel;
    miExpand: TMenuItem;
    miCollapse: TMenuItem;
    MainMenu1: TMainMenu;
    mmiFile: TMenuItem;
    mmiHelp: TMenuItem;
    mmiContents: TMenuItem;
    mmiNewReader: TMenuItem;
    mmiAdd: TMenuItem;
    mmiEdit: TMenuItem;
    mmiDelete: TMenuItem;
    mmiClose: TMenuItem;
    mmiExpand: TMenuItem;
    mmiCollapse: TMenuItem;
    N1: TMenuItem;
    N2: TMenuItem;
    ActionList1: TActionList;
    actNewReader: TAction;
    actCloneReader: TAction;
    actAdd: TAction;
    btnClone: TBitBtn;
    actEdit: TAction;
    actDelete: TAction;
    actClose: TAction;
    actExpand: TAction;
    actCollapse: TAction;
    miClone: TMenuItem;
    mmiCloneReader: TMenuItem;
    procedure FormShow(Sender: TObject);
    procedure SetAddEditDelete;
    procedure PageControl1Change(Sender: TObject);
    procedure tvReadersClick(Sender: TObject);
    procedure lvSiteSelectItem(Sender: TObject; Item: TListItem;
      Selected: Boolean);
    procedure btnAddClick(Sender: TObject);
    procedure btnEditClick(Sender: TObject);
    procedure btnDeleteClick(Sender: TObject);
    procedure btnCloseClick(Sender: TObject);
    procedure ActivateDeactivate;
    //procedure SynchChildren(Node: TTreeNode; Active: boolean);
    procedure AddReaderData;
    procedure AddSite;
    procedure btnNewClick(Sender: TObject);
    procedure PopulateSiteListView;
    procedure PopulateReaderTreeView;
    procedure AddNodeToReaderTreeView(Reader: TReader; iLevel: integer);
    function GetAddedSiteNames: string;
    function GetAddedReaders: string;
    function GetNodeParent(iLevel: integer): TTreeNode;
    procedure DeleteReaderData;
    procedure lvSiteDblClick(Sender: TObject);
    procedure tvReadersDblClick(Sender: TObject);
    procedure btnExpandClick(Sender: TObject);
    procedure btnCollapseClick(Sender: TObject);
    procedure SettvReaderNodes(Expand: boolean);
    procedure EditAcquisitionSite;
    procedure ListViewColumnClick(Sender: TObject; Column: TListColumn);
    procedure tvReadersChange(Sender: TObject; Node: TTreeNode);
    //P127T1 NST 04/18/2012  Use Actions  procedure SetHints;
    procedure FormKeyDown(Sender: TObject; var Key: Word;
      Shift: TShiftState);
    procedure mmiContentsClick(Sender: TObject);
    procedure GetCurrPriv_1LvlDown(sl: TStringList; Node: TTreeNode);
    procedure FormClose(Sender: TObject; var Action: TCloseAction);
    procedure actCloneReaderExecute(Sender: TObject);
    procedure tvReadersExpanded(Sender: TObject; Node: TTreeNode);
    procedure tvReadersCollapsed(Sender: TObject; Node: TTreeNode);
    procedure ListViewCompare(Sender: TObject; Item1, Item2: TListItem;
      Data: Integer; var Compare: Integer);
  private
    { Private declarations }
    CurrentParent: TTreeNode;
    bCollapse: boolean;
    //SelectedIEN, NewReaderIEN: integer;
    SelectedIEN, NewReaderIEN: string;

    Descending: Boolean; // P110T10 NST 06/06/2013 Sorting order f the lisvtiew
    ColumnToSort : Integer;  // P110T10 NST 06/06/2013 Column to sort order f the lisvtiew

    function GetReadersWithAcqSitePrivCount(SiteIEN: string): integer;
    //function GetSelectedReaderIEN: integer;
    function GetSelectedReaderIEN: string;
    procedure FocusSelectedReader;
    //P127T1 NST 04/18/2012  Use Actions
    procedure SetActions;
    procedure SetActionHints(blnReaderTab : Boolean);
    procedure SetActionVisible(blnReaderTab : Boolean);
    //P127T1 NST 04/18/2012  Add Reader Clone
    procedure CloneReader(pSelectedReaders : TStrings; pReader : String);
  public
    { Public declarations }
  end;

var
  frmReaderSetup: TfrmReaderSetup;

const
  SEPERATOR = '|';
  InactiveStr = ' - [INACTIVE]';

implementation

uses
  fMAGAddEditSite, fMAGAddEditReader, MagFMComponents, DiTypLib, dmMAGTeleReaderAdmin, trpcb,
  fMAGSelectReaders, MagFileVersion;

{$R *.dfm}

procedure TfrmReaderSetup.FormShow(Sender: TObject);
begin
  PageControl1.ActivePageIndex := 0;
  PopulateSiteListView;
  PopulateReaderTreeView;
  SetActions;   //P127T1 NST 04/18/2012  Use Actions
  ResizeListViewColumns(self, lvSite);
  tvReaders.Selected := nil;
  bCollapse := false;
  SelectedIEN := '0';
  NewReaderIEN := '0';
  GetFormPosition(self);
end;

//P127T1 NST 04/17/2012 Use Actions
procedure TfrmReaderSetup.SetActionHints(blnReaderTab : Boolean);
begin
  if not blnReaderTab then
  begin
    actAdd.Hint := 'Add an Acquistion Site';
    actEdit.Hint := 'Edit an Acquistion Site';
    actDelete.Hint := 'Remove an Acquistion Site';
  end
  else
  begin
    actAdd.Hint := 'Add Site/Specialty/Procedure rights for a reader';
    actEdit.Hint := 'Edit Site/Specialty/Procedure rights for a reader';
    actDelete.Hint := 'Remove Site/Specialty/Procedure rights from a reader';
  end
end;

//P127T1 NST 04/17/2012 Use Actions
procedure TfrmReaderSetup.SetActions;
var blnReaderTab : Boolean;
begin
   blnReaderTab := PageControl1.ActivePageIndex = 1;
   SetActionVisible(blnReaderTab);
   SetAddEditDelete;
   SetActionHints(blnReaderTab);
end;

//P127T1 NST 04/17/2012 Use Actions
procedure TfrmReaderSetup.SetActionVisible(blnReaderTab : Boolean);
begin
  actNewReader.Visible := blnReaderTab;
  actNewReader.Enabled := actNewReader.Visible;

  actCloneReader.Visible := blnReaderTab;
  actCloneReader.Enabled := actCloneReader.Visible;

  actExpand.Visible := blnReaderTab;
  actExpand.Enabled := actExpand.Visible;

  actCollapse.Visible := blnReaderTab;
  actCollapse.Enabled := actCollapse.Visible;
end;

procedure TfrmReaderSetup.SetAddEditDelete;
begin
  case PageControl1.ActivePageIndex of
    0: begin
         //P127T1 NST 04/17/2012 Use Actions
         actAdd.Enabled := true;
         //P127T1 NST 04/17/2012 btnAdd.Font.Size := 10;
         actAdd.Caption := '&Add';
         actEdit.Enabled := lvSite.Selected <> nil;
         actDelete.Enabled := lvSite.Selected <> nil;
         actEdit.Caption := '&Edit';
         actCloneReader.Enabled := false;
         {*P127T1 NST 04/17/2012
         miSiteAdd.Enabled := btnAdd.Enabled;
         miSiteAdd.Caption := btnAdd.Caption;
         miSiteEdit.Enabled := btnEdit.Enabled;
         miSiteDelete.Enabled := btnDelete.Enabled;
         *}
       end;
    1: begin
         //P127T1 NST 04/17/2012 Use Actions
         actAdd.Enabled := (tvReaders.Selected <> nil) and (tvReaders.Selected.Level < 3) and (tvReaders.Selected.ImageIndex <> 0)
          and (tvReaders.Selected.ImageIndex <> 3);
         //P127T1 NST 04/17/2012btnAdd.Font.Size := 8;
         actAdd.Caption := '&Add Privilege';
         //edit button on this page is actually activate/deactivate button
         actEdit.Enabled := (tvReaders.Selected <> nil) and (tvReaders.Selected.Level > 0) and (tvReaders.Selected.Parent.ImageIndex <> 0)
          and (tvReaders.Selected.Parent.ImageIndex <> 3);
         actDelete.Enabled := tvReaders.Selected <> nil;
         if (actEdit.Enabled = false) or (tvReaders.Selected.ImageIndex = 0) or (tvReaders.Selected.ImageIndex = 3) then actEdit.Caption := 'Acti&vate'
         else actEdit.Caption := 'Deacti&vate';
         // Is reader selected
         actCloneReader.Enabled := (tvReaders.Selected <> nil) and (tvReaders.Selected.Level = 0 );

         {*P127T1 NST 04/17/2012
         miRdrAdd.Enabled := btnAdd.Enabled;
         miRdrAdd.Caption := btnAdd.Caption;
         miRdrEdit.Enabled := btnEdit.Enabled;
         miRdrEdit.Caption := btnEdit.Caption;
         miRdrDelete.Enabled := btnDelete.Enabled;
         *}
       end;
  end;
  {* P127T1 NST 04/18/2012 Use Actions
  mmiNewReader.Visible := PageControl1.ActivePageIndex = 1;
  mmiExpand.Visible := PageControl1.ActivePageIndex = 1;
  mmiCollapse.Visible := PageControl1.ActivePageIndex = 1;
  mmiAdd.Caption := btnAdd.Caption;
  mmiAdd.Enabled := btnAdd.Enabled;
  mmiEdit.Caption := btnEdit.Caption;
  mmiEdit.Enabled := btnEdit.Enabled;
  mmiDelete.Enabled := btnDelete.Enabled;

  SetHints; *}
end;

procedure TfrmReaderSetup.PageControl1Change(Sender: TObject);
begin
  SetActions;   //P127T1 NST 04/17/2012 Use Actions
end;

procedure TfrmReaderSetup.tvReadersClick(Sender: TObject);
begin
//  SetAddEditDelete;
end;

procedure TfrmReaderSetup.tvReadersCollapsed(Sender: TObject; Node: TTreeNode);
begin
  SetAddEditDelete; //P127T1 NST 04/19/2012  Update actions
end;

procedure TfrmReaderSetup.lvSiteSelectItem(Sender: TObject;
  Item: TListItem; Selected: Boolean);
begin
  SetAddEditDelete;
end;

procedure TfrmReaderSetup.btnAddClick(Sender: TObject);
begin
  case PageControl1.ActivePageIndex of
    0: AddSite;
    1: AddReaderData;
  end;
end;

function TfrmReaderSetup.GetAddedSiteNames: string;
//Builds a Pipe delimited list of acquisition sites entered in the Acquisition Site Configuration File(#2006.5842)
//This is the primary key a can only be in one entry for the file. This list is passed to the add screen and the sites are removed as choices from the
//services name combo box
var i: integer;
begin
  result := '';
  for i := 0 to lvSite.Items.Count -1 do
    result := result + STR_DEL + TListItem(lvSite.Items[i]).Caption;
  result := result + STR_DEL;
end;

procedure TfrmReaderSetup.AddSite;
var frm: TfrmAddEditSite;
begin
  frm := TfrmAddEditSite.Create(nil);
  try
    frm.Caption := 'Add ' + frm.Caption;
    frm.cbActive.Checked := true;
    frm.sAlreadyAddedSites := GetAddedSiteNames;
    if frm.ShowModal = mrOK then
      PopulateSiteListView;
  finally
    frm.Free;
  end;
end;

procedure TfrmReaderSetup.AddReaderData;
var frm: TfrmAddEditReader;
begin
  if tvReaders.Selected = nil then exit;
  frm := TfrmAddEditReader.Create(nil);
  {}
  frm.edtNameSearch.Enabled := false;
  frm.edtNameSearch.Color := clBtnFace;
  frm.PopulateReaderComboWithSelection(tvReaders.Selected);
  {}
  frm.iLevel := tvReaders.Selected.Level;
  frm.slAlreadyAddedPrivliges := TStringList.Create;
  GetCurrPriv_1LvlDown(frm.slAlreadyAddedPrivliges, tvReaders.Selected);
  try
    with frm do begin
      Caption := 'Add Items to' + frm.Caption;
      PopulateTheForm(tvReaders.Selected);
      frm.sAvailableSites := GetAddedSiteNames;
      if In508Mode then SetFormFor508(frm);
      if ShowModal = mrOK then
        PopulateReaderTreeView;
    end;
  finally
    frm.slAlreadyAddedPrivliges.Free;
    frm.Free;
  end;
end;

procedure TfrmReaderSetup.btnEditClick(Sender: TObject);
begin
  case PageControl1.ActivePageIndex of
    0: EditAcquisitionSite;
    1: ActivateDeactivate;
  end;
end;

procedure TfrmReaderSetup.EditAcquisitionSite;
var frm: TfrmAddEditSite; Item: TListItem;
begin
  frm := TfrmAddEditSite.Create(nil);
  try
    frm.Caption := 'Edit ' + frm.Caption;
    Item := lvSite.Selected;
    frm.cmbSite.Text := Item.Caption;
    frm.cmbPrimary.Text := Item.SubItems[0];
    if UpperCase(Item.SubItems[1]) = 'ACTIVE' then frm.cbActive.Checked := true
    else frm.cbActive.Checked := false;
    frm.edtLockout.OnChange := nil;
    frm.edtLockout.Text := Item.SubItems[2];
    frm.edtLockout.OnChange := frm.SetSaveButton;
    frm.cmbSite.Enabled := false; //Primary key cannot be change don an edit
    if In508Mode then SetFormFor508(frm);
    frm.btnSave.Enabled := false;
    if frm.ShowModal = mrOK then
      PopulateSiteListView;
  finally
    frm.Free;
  end;
end;

procedure TfrmReaderSetup.btnDeleteClick(Sender: TObject);
var sResult: string;
begin
  case PageControl1.ActivePageIndex of
    0: //Acquisition Sites
    begin
      if GetReadersWithAcqSitePrivCount(TFMRecordObj(lvSite.Selected.Data).IEN) > 0 then
      begin
        sResult := 'Cannot delete ' + lvSite.Selected.Caption + ' there are currently Readers that have privileges for this acquisition site';
        ShowMessage508(sResult, self.Handle);
        exit;
      end;
      if MessageDlg508('Are you sure you want to delete ' + lvSite.Selected.Caption +'?', mtConfirmation, [mbOK, mbCancel], self.Handle) = mrOK then
      begin
        DataModule1.Broker.RemoteProcedure := 'MAG3 TELEREADER SITE SETUP';
        DataModule1.Broker.Param[0].PType := list;
        DataModule1.Broker.Param[0].Value := '.x';
        DataModule1.Broker.Param[0].Mult['"ACTION"'] := 'DELETE';
        DataModule1.Broker.Param[0].Mult['"IEN"'] := TFMRecordObj(lvSite.Selected.Data).IEN;
        try
          sResult := DataModule1.Broker.strCall;
          MagLogger.Log('INFO', 'Removed record from Telereader Acquisition Site file.');
          PopulateSiteListView;
        except
          on e: exception do
          begin
            MagLogger.Log('ERROR', e.Message);
           raise;
          end; // on e...
        end; //except
      end; //if MessageDlg...
    end; //case 0...
    1: //Readers
    begin
     DeleteReaderData;
    end; //case 1:...
  end; //case statement...
end;

function GetLoneParent(Node: TTreeNode): TTreeNode;
//if a reader component is being deleted, if any parent does not have a complete record, then the entire record must be deleted
//ex if a procedure is being deleted, but the reader/site/specialty has exactly one procedure, then the specilaty must be deleted as well
//or it may go further up the chain, if the site has exactly one specialty the site must be deleted, etc...
begin
  result := nil;
  while (Node.Parent <> nil) do
  begin
    Node := Node.Parent;
    if Node.Count < 2 then
      result := Node
    else
      exit;
  end;
end;

function BldDeleteStr(Node: TTreeNode): string;
//what ever level on tree node is selecetd, retrieve all text for the record
//ex: if a procedure is being deleted, prompt that procedure being deleted from Joe Smith, Salt Lake City, Eye Care
const DEL = '|';
begin
  try
    result := Node.text;
    if Node.Level = 0 then exit;
    while Node.Level > 0 do
    begin
      Node := Node.Parent;
      result := Node.Text + DEL + result;
    end;
  finally
    result := StringReplace(result, InactiveStr, '', [rfReplaceAll, rfIgnoreCase]);
  end;
end;

function GetReaderDataIEN(Node: TTreeNode; iNodeLevel: integer): string;
var IEN_Node: TTreeNode;
begin
  IEN_Node := Node;
  while IEN_Node.Level > iNodeLevel do IEN_Node := IEN_Node.Parent;
  if IEN_Node.Level = 0 then
    result := TReader(IEN_Node.Data).FReaderIEN
  else
    result := TReaderSubItem(IEN_Node.Data).FIEN; //child components saved as TReaderSubItem - contains IEN and active FLG
end;

procedure TfrmReaderSetup.DeleteReaderData;
var iLevel: integer; SelectedNode, LoneNode: TTreeNode; sResult, sPrompt: string;
begin
  SelectedNode := tvReaders.Selected;
  LoneNode := GetLoneParent(SelectedNode); //see GetLoneParent function notes
  sPrompt := 'Are you sure you want to delete ' + BldDeleteStr(SelectedNode) + '?'; //see BldDeleteStr function notes
  if LoneNode <> nil then sPrompt := LoneNode.Text + ' will be incomplete if ' + SelectedNode.Text + ' is deleted.' + #13 + #10 +
   LoneNode.Text + ' and all child privileges will be deleted.' + #13 + #10 + sPrompt;
  sPrompt := StringReplace(sPrompt, InactiveStr, '', [rfReplaceAll, rfIgnoreCase]);
  if MessageDlg508(sPrompt, mtConfirmation, [mbOK, mbCancel], self.Handle) = mrOK then
  begin
    iLevel := SelectedNode.Level;
    {}
    DataModule1.Broker.RemoteProcedure := 'MAG3 TELEREADER READER SETUP';
    DataModule1.Broker.Param[0].PType := list;
    DataModule1.Broker.Param[0].Value := '.x';
    {}
    DataModule1.Broker.Param[0].Mult['"READER"'] := GetReaderDataIEN(SelectedNode, 0);
    if iLevel >= 1 then DataModule1.Broker.Param[0].Mult['"ACQUISITION SITE"'] := GetReaderDataIEN(SelectedNode, 1); //need to get all reference file IENs for the reader privileges file
    if iLevel >= 2 then DataModule1.Broker.Param[0].Mult['"SPECIALTY INDEX"'] := GetReaderDataIEN(SelectedNode, 2);
    if iLevel = 3 then DataModule1.Broker.Param[0].Mult['"PROCEDURE INDEX"'] := GetReaderDataIEN(SelectedNode, 3);
    {}
    case iLevel of
      0: DataModule1.Broker.Param[0].Mult['"ACTION"'] := 'DELETE READER';
      1: DataModule1.Broker.Param[0].Mult['"ACTION"'] := 'DELETE SITE';
      2: DataModule1.Broker.Param[0].Mult['"ACTION"'] := 'DELETE SPECIALTY';
      3: DataModule1.Broker.Param[0].Mult['"ACTION"'] := 'DELETE PROCEDURE';
    end;
    try
      sResult := DataModule1.Broker.strCall;
      MagLogger.Log('INFO', 'Removed record from Telereader Reader file.');
      PopulateReaderTreeView;
    except
      on e: exception do
      begin
        MagLogger.Log('ERROR', e.Message);
        raise;
      end;
    end;
  end;
end;

procedure TfrmReaderSetup.btnCloseClick(Sender: TObject);
begin
  Close;
end;

function GetReaderDataStatus(Node: TTreeNode; iNodeLevel: integer): string;
var IEN_Node: TTreeNode;
begin
  IEN_Node := Node;
  while IEN_Node.Level > iNodeLevel do IEN_Node := IEN_Node.Parent;
  if IEN_Node.Level = 0 then
    result := TReader(IEN_Node.Data).FReaderIEN
  else
    result := TReaderSubItem(IEN_Node.Data).FIEN;
end;

procedure TfrmReaderSetup.ActivateDeactivate;
var Node: TTreeNode; s, sResult: string; iLevel: integer;
begin
  s := StringReplace(lowercase(btnEdit.Caption), '&', '', [rfReplaceAll]);
  if MessageDlg508('Are you sure you want to ' + s + ' ' + BldDeleteStr(tvReaders.Selected) + '?', mtConfirmation, [mbOK, mbCancel], self.Handle) = mrOK then
  begin
    Node := tvReaders.Selected;
    iLevel := Node.Level;
    {}
    DataModule1.Broker.RemoteProcedure := 'MAG3 TELEREADER READER SETUP';
    DataModule1.Broker.Param[0].PType := list;
    DataModule1.Broker.Param[0].Value := '.x';
    {}
    DataModule1.Broker.Param[0].Mult['"READER"'] := GetReaderDataIEN(Node, 0);
    if iLevel >= 1 then DataModule1.Broker.Param[0].Mult['"ACQUISITION SITE"'] := GetReaderDataIEN(Node, 1);
    if iLevel >= 2 then DataModule1.Broker.Param[0].Mult['"SPECIALTY INDEX"'] := GetReaderDataIEN(Node, 2);
    if iLevel = 3 then DataModule1.Broker.Param[0].Mult['"PROCEDURE INDEX"'] := GetReaderDataIEN(Node, 3);
    {}
    case iLevel of
      1: begin
           DataModule1.Broker.Param[0].Mult['"ACTION"'] := 'SET SITE STATUS';
           DataModule1.Broker.Param[0].Mult['"ACQUISITION SITE STATUS"'] := TReaderSubItem(Node.Data).ActiveOpposite;
         end;
      2: begin
           DataModule1.Broker.Param[0].Mult['"ACTION"'] := 'SET SPECIALTY STATUS';
           DataModule1.Broker.Param[0].Mult['"SPECIALTY INDEX STATUS"'] := TReaderSubItem(Node.Data).ActiveOpposite;
         end;
      3: begin
           DataModule1.Broker.Param[0].Mult['"ACTION"'] := 'SET PROCEDURE STATUS';
           DataModule1.Broker.Param[0].Mult['"PROCEDURE INDEX STATUS"'] := TReaderSubItem(Node.Data).ActiveOpposite;
         end;
    end;
    try
      sResult := DataModule1.Broker.strCall;
      MagLogger.Log('INFO',  'Successful ' + s + ' of Reader Privilege.');
      PopulateReaderTreeView;
    except
      on e: exception do
      begin
        MagLogger.Log('ERROR', e.Message);
        raise;
      end;
    end;
  end;
end;

function TfrmReaderSetup.GetAddedReaders: string;
//Builds a Pipe delimited list of Readers already entered in the Reader File(#2006.5843)
//This is the primary key a can only be in one entry for the file. This list is passed to the add screen and the readers are removed as choices from the
//services name combo box
var i: integer;
begin
  result := '';
  for i := 0 to tvReaders.Items.Count -1 do
    if tvReaders.Items[i].Level = 0 then
      result := result + STR_DEL + TTreeNode(tvReaders.Items[i]).Text;
  result := result + STR_DEL;
end;

procedure TfrmReaderSetup.btnNewClick(Sender: TObject);
var frm: TfrmAddEditReader;
begin
  frm := TfrmAddEditReader.Create(nil);
  try
    frm.Caption := 'Add New Reader';
    frm.sAlreadyAddedReaders := GetAddedReaders;
    frm.sAvailableSites := GetAddedSiteNames;
    if frm.ShowModal = mrOK then
    begin
      NewReaderIEN := TIENObj(frm.cmbReader.Items.Objects[frm.cmbReader.ItemIndex]).sIEN;
      PopulateReaderTreeView;
    end;
  finally
    frm.Free;
  end;
end;

procedure TfrmReaderSetup.PopulateSiteListView;
var Lister : TMagFMLister; sIEN: string; i, j: integer;
    RecordObj: TFMRecordObj; Item: TListItem;
begin
  lvSite.Items.Clear;
  Lister := TMagFMLister.Create(nil);
  try
    Lister.RPCBroker := DataModule1.Broker;
    try
      // P127T6 NST 12/03/2012 Add 1I to get IEN of the primary site
      Lister.Retrieve('2006.5842', '.01' + LST_DEL + '1I' + LST_DEL + '1'  + LST_DEL + '2' + LST_DEL + '3'); //.01 = Acquisition Site, 1 = Primary Site, 2 = Active/Inactive, 3 = Lock Timeout
      MagLogger.Log('INFO', 'retrieved Telereader Acquisition Site file data.');
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
      Item := lvSite.Items.Add;
      sIEN := Lister.Results[i];
      RecordObj := Lister.GetRecord(sIEN);
      Item.Data := RecordObj;
      Item.Caption := RecordObj.GetField(RecordObj.FMFLDValues[0]).FMDBExternal;
      // NST 11/30/2012 P127T6 Get Station number by IEN
      Item.Caption := FormatSiteText(Item.Caption , GetSiteStationNoFromIEN(sIEN));
      for j := 2 To RecordObj.FMFLDValues.Count - 1 do
        Item.SubItems.Add(RecordObj.GetField(RecordObj.FMFLDValues[j]).FMDBExternal);

      // NST 11/30/2012 P127T6 Get Station number by IEN
       sIEN := RecordObj.GetField(RecordObj.FMFLDValues[1]).FMDBExternal;
       Item.SubItems[0]:= FormatSiteText(Item.SubItems[0] , GetSiteStationNoFromIEN(sIEN));

    end;
    // NST 11/30/2012 P127T6 The stations numbers are appended when we populate the list
    // AddStationNumToSiteCol(lvSite, 1);
    // AddStationNumToSiteCol(lvSite, 2);
  finally
    // NST 06/06/2013
    // P110 T10 sort the listview after refresh
    if lvSite.Tag > -1 then
    begin
      ColumnToSort := lvSite.Tag;
      Descending := (lvSite.Columns[ColumnToSort].Tag = 1);
      lvSite.AlphaSort;
    end;
    
    Lister.Free;
  end;
end;

function TfrmReaderSetup.GetNodeParent(iLevel: integer): TTreeNode;
var i: integer; Node: TTreeNode;
begin
  result := nil;
  for i := 0 to tvReaders.Items.Count - 1 do
  begin
    Node := tvReaders.Items[i];
    if Node.Level = iLevel then result := Node;
  end;
end;

function TfrmReaderSetup.GetSelectedReaderIEN: string;
var Node: TTreeNode;
begin
  result := '0';
  Node := tvReaders.Selected;
  if Node = nil then exit;
  while Node.Level > 0 do Node := Node.Parent;
  result := TReader(Node.Data).FReaderIEN;
end;

function GetNodeStatusCheckParent(Node: TTreeNode): integer;
//even if the component is active, if its parent is inactive, then it will be shown as inactive in the tree view
//ex: specialty for a read may be active in database, but if acquisition site for that reader for which specialty is under is inactive
//it will not show up in telereader either
var ParentNode: TTreeNode;
begin
  ParentNode := Node.Parent;
  result := ParentNode.ImageIndex;
  if result > 1 then result := result - 3;
  if result = 1 then
    result := StrToInt((TReaderSubItem(Node.Data).FActive));;
end;

procedure TfrmReaderSetup.AddNodeToReaderTreeView(Reader: TReader; iLevel: integer);
var Node: TTreeNode;
begin

  //if procedure level = 3 being added then parent will be same as last call, since recores are sorted by
  //1) Reader Name 2) Acquisition Site 3) Specialty 4) Procedure
  //if Reader added Level = 0, there is no parent, starts at root of tree view
  //otherwise get parent and add this node as child of the parent
  if (iLevel < 3) and (iLevel <> 0) then CurrentParent := GetNodeParent(iLevel - 1);

  if iLevel = 0 then
  begin
    //Node := tvReaders.Items.AddObject(nil, UpperCase(Reader.FName), TObject(StrToInt(Reader.FReaderIEN)));
    Node := tvReaders.Items.AddObject(nil, UpperCase(Reader.FName), Reader);
    Node.ImageIndex := 2;
    Node.SelectedIndex := Node.ImageIndex;
    CurrentParent := Node;
  end;
  if iLevel <= 1 then
  begin
    Node := tvReaders.Items.AddChildObject(CurrentParent, Reader.FSite.FText, Reader.FSite);
    Node.ImageIndex := StrToInt(Reader.FSite.FActive) + 3;
    Node.SelectedIndex := Node.ImageIndex;
    if Reader.FSite.FActive = '0' then Node.Text := Node.Text + InactiveStr;
    CurrentParent := Node;
  end;
  if iLevel <= 2 then
  begin
    Node := tvReaders.Items.AddChildObject(CurrentParent, Reader.FSpecialty.FText, Reader.FSpecialty);
    Node.ImageIndex := GetNodeStatusCheckParent(Node);
    Node.SelectedIndex := Node.ImageIndex;
    if Reader.FSpecialty.FActive = '0' then Node.Text := Node.Text + InactiveStr;
    CurrentParent := Node;
  end;

  Node := tvReaders.Items.AddChildObject(CurrentParent, Reader.FProc.FText, Reader.FProc);
  Node.ImageIndex := GetNodeStatusCheckParent(Node);
  Node.SelectedIndex := Node.ImageIndex;
  if Reader.FProc.FActive = '0' then Node.Text := Node.Text + InactiveStr;

end;

//Records called from rpc - MAG3 TELEREADER READER LIST are in the format of the next line below
//'126^Smith, Joe^660^SALT LAKE CITY^1^57^EYE CARE^1^175^CORONARY ARTERY BYPASS^1^1'  - last
//'126^Smith, Joe^660^SALT LAKE CITY^660^1^57^EYE CARE^1^175^CORONARY ARTERY BYPASS^1^1' -current (added station # after station name)
procedure TfrmReaderSetup.PopulateReaderTreeView;
const DEL = '^';
var sl: TStringList; i, iPos: integer; s: string; Reader, LastReader: TReader;
begin
  if NewReaderIEN <> '0' then
    SelectedIEN := NewReaderIEN
  else
    SelectedIEN := GetSelectedReaderIEN;
  tvReaders.Items.Clear;
  sl := TStringList.Create;
  LastReader := TReader.Create;
  DataModule1.Broker.RemoteProcedure := 'MAG3 TELEREADER READER LIST';
  try
    try
      DataModule1.Broker.lstcall(sl);
      MagLogger.Log('INFO', 'retrieved Telereader Reader file data.');
    except
      on e: exception do
      begin
        MagLogger.Log('ERROR', e.Message);
        raise;
      end;
    end;
    s := sl.Strings[0];         // NST 11/30/2012 P127T6 Check and report error from the reader list
    if MagSTRPiece(s, DEL, 1) = '0' then
    begin
       MessageDlg508(MagSTRPiece(s, DEL, 2), mtInformation, [mbOK], self.Handle);
      MagLogger.Log('ERROR', '[MAG3 TELEREADER READER LIST]  ' + MagSTRPiece(s, DEL, 2));
       exit;
    end;
    if sl.Count < 3 then exit; //1st string = reulst set, 2nd string =  column list
    //1st to strings are result info and column headers
    i := 0; //to remove compiler warning
    try
      for i := 2 to sl.Count - 1 do
      begin
        s := sl.Strings[i];
        //if i = 3 then s := '130713^PLAUMBO,BARBARA M^6001^LORAIN CBOC^541GB^^57^EYE CARE^1^88^DIABETIC RETINOPATHY SURVEILLANCE^1^1'; //for testing purposes
        iPos := pos(SEPERATOR, s);
        s := copy(s, iPos + 1, length(s) - iPos);  //remove sort key
        Reader := TReader.Create;
        Reader.PopulateReader(s);
        //compare to last reader record. where differnce in data occurs says which conmponent type is added and at which node level in the trr view the
        //new tree node should be added ex: if reader name is the same, but site is different start a new site for the reader, new node has a level of 1
        if (LastReader.FReaderIEN = emptystr) or (LastReader.FReaderIEN <> Reader.FReaderIEN) then AddNodeToReaderTreeView(Reader, 0)
        else if LastReader.FSite.FIEN <> Reader.FSite.FIEN then AddNodeToReaderTreeView(Reader, 1)
        else if LastReader.FSpecialty.FIEN <> Reader.FSpecialty.FIEN then AddNodeToReaderTreeView(Reader, 2)
        else AddNodeToReaderTreeView(Reader, 3);
        LastReader.Copy(Reader); //current reader record becomes last reader, to be compared to next retrieved reader record
      end;
    except
      MessageDlg('There was a problem loading TeleReader Reader data' + LST_DEL + 'Record ' + IntToStr(i) + LST_DEL + s, mtError, [mbOK], 0);
      tvReaders.Items.Clear;
      exit;
    end;
    tvReaders.AlphaSort(true);
    SettvReaderNodes(not bCollapse); //expand entire tree view
    FocusSelectedReader;
  finally
    sl.Free;
    LastReader.Free;
    NewReaderIEN := '0';
  end;
end;

procedure TfrmReaderSetup.FocusSelectedReader;
var i: integer; Node: TTreeNode;
begin

  if tvReaders.Items.Count = 0 then exit;

  if (SelectedIEN = '0') or (SelectedIEN = '')then
  begin
    tvReaders.Items[0].Selected := true;
  end
  else
  begin
    for i := 0 to tvReaders.Items.Count - 1 do
    begin
      Node := tvReaders.Items[i];
      if (Node.Level = 0) and (TReader(Node.Data).FReaderIEN = SelectedIEN) then
      begin
        Node.Selected := true;
        if bCollapse then Node.Expand(true);
        break;
      end;
    end;
  end;

  if pageControl1.ActivePageIndex = 1 then ActiveControl := tvReaders;

end;

procedure TfrmReaderSetup.lvSiteDblClick(Sender: TObject);
begin
  if lvSite.Selected <> nil then btnEditClick(nil);
end;

procedure TfrmReaderSetup.tvReadersDblClick(Sender: TObject);
begin
  //if tvReaders.Selected <> nil then btnAddClick(nil);
end;

procedure TfrmReaderSetup.tvReadersExpanded(Sender: TObject; Node: TTreeNode);
begin
  SetAddEditDelete; //P127T1 NST 04/19/2012  update actions
end;

procedure TfrmReaderSetup.SettvReaderNodes(Expand: boolean);
begin
  if Expand then
    tvReaders.FullExpand
  else
    tvReaders.FullCollapse;
  bCollapse := not(Expand);
end;

procedure TfrmReaderSetup.btnExpandClick(Sender: TObject);
begin
  SettvReaderNodes(true);
end;

procedure TfrmReaderSetup.btnCollapseClick(Sender: TObject);
begin
  SettvReaderNodes(false);
end;

procedure TfrmReaderSetup.ListViewColumnClick(Sender: TObject; Column: TListColumn);
begin
  // P110T10 NST 06/06/2013 Modified sorting method
  if Column.Tag = 0 then Column.Tag := 1 else Column.Tag := 0; //tag 1 = sort ascending, 0 = sort descending
  (Sender as TCustomListView).Tag := Column.Index;

  Descending :=  (Column.Tag = 1);
  ColumnToSort := (Sender as TCustomListView).Tag;

  (Sender as TCustomListView).AlphaSort;
end;

procedure TfrmReaderSetup.tvReadersChange(Sender: TObject;
  Node: TTreeNode);
begin
  SetAddEditDelete;
end;

procedure TfrmReaderSetup.FormKeyDown(Sender: TObject; var Key: Word;
  Shift: TShiftState);
begin
  if (Shift = [ssCtrl]) and (PageControl1.ActivePageIndex = 1) then
  begin
    if Key = 88 then btnExpandClick(self); //CTRL X
    if Key = 79 then btnCollapseClick(self); //CTRL O
    exit;
  end;
  if Key = F1KEY then OpenHelpFile;
end;

procedure TfrmReaderSetup.mmiContentsClick(Sender: TObject);
begin
  OpenHelpFile;
end;

procedure TfrmReaderSetup.GetCurrPriv_1LvlDown(sl: TStringList; Node: TTreeNode);
var CurrentNode: TTreeNode;
begin
  CurrentNode := Node.GetNext;
  while (CurrentNode <> nil) and (CurrentNode.Level > Node.Level) do
  begin
    if CurrentNode.Level = Node.Level + 1 then sl.Add(StringReplace(CurrentNode.Text, InactiveStr, '', [rfReplaceAll, rfIgnoreCase]));
    CurrentNode := CurrentNode.GetNext;
  end;
end;

function TfrmReaderSetup.GetReadersWithAcqSitePrivCount(SiteIEN: string): integer;
var i: integer; Node: TTreeNode; SubItem: TReaderSubItem;
begin
  result := 0;
  for i := 0 to tvReaders.Items.Count - 1 do
  begin
    Node := tvReaders.Items[i];
    if Node.Level = 1 then
    begin
      SubItem := TReaderSubItem(Node.Data);
      if SubItem.FIEN = SiteIEN then
        Inc(Result);
    end;
  end;
end;

procedure TfrmReaderSetup.FormClose(Sender: TObject;
  var Action: TCloseAction);
begin
  SaveFormPosition(self);
end;

//P127T1 NST 04/17/2012  Clone reader action
procedure TfrmReaderSetup.actCloneReaderExecute(Sender: TObject);
var SelectedReadersIENs : TStrings;
    SelectedReadersNames : TStrings;
    sReader : String;
    sPlural : String;
begin
  SelectedReadersIENs := TStringList.Create;
  SelectedReadersNames := TStringList.Create;;
   // Select readers to be cloned
  if GetReadersToClone('Select reader(s) to be cloned from '+tvReaders.Selected.Text,SelectedReadersIENs,SelectedReadersNames,GetAddedReaders,tvReaders.Selected) then
  begin
    if SelectedReadersNames.Count > 1 then sPlural := 's:'
    else sPlural := ':';

    if MessageDlg508('All privileges of selected reader'+sPlural+ #13#13 + SelectedReadersNames.Text+ #13 + 'will be created with privileges of '+ tvReaders.Selected.Text + #13#13 +'Are you sure you want to continue?', mtConfirmation, [mbOK, mbCancel], self.Handle) = mrOK then
    begin
      sReader := GetReaderDataIEN(tvReaders.Selected, 0);
      CloneReader(SelectedReadersIENs, sReader);
      SelectedReadersIENs.Free;
      SelectedReadersNames.Free;
    end;
  end
end;

//P127T1 NST 04/17/2012  Clone reader action
// It calls RPC [MAG3 TELEREADER CLONE READER] to clone a reader (pReader) to selected readers (pSelectedReaders)
procedure TfrmReaderSetup.CloneReader(pSelectedReaders : TStrings; pReader : String);
var I: Integer;
    rList: TStrings;
begin
  rList := Tstringlist.Create();

  DataModule1.Broker.RemoteProcedure := 'MAG3 TELEREADER CLONE READER';
  DataModule1.Broker.Param[0].PType := literal;
  DataModule1.Broker.Param[0].Value :=  pReader;

  DataModule1.Broker.Param[1].PType := list;
  DataModule1.Broker.Param[1].Value := '.x';
  for I := 0 to pSelectedReaders.Count - 1 do
  begin
      DataModule1.Broker.Param[1].Mult[pSelectedReaders[I]] := '';
  end;
  try
    DataModule1.Broker.lstCall(rList);
    // print the results from RPC in log file
    for I := 1 to rList.Count - 1 do
    begin
      if MagStrPiece(rList[I],'^',1) = '1' then
        MagLogger.Log('INFO', MagStrPiece(rList[I],'^',2))
      else
        MagLogger.Log('ERROR', MagStrPiece(rList[I],'^',2));
    end;
    PopulateReaderTreeView;
    rList.Free;
  except
    on e: exception do
    begin
      MagLogger.Log('ERROR', e.Message);
      rList.Free;
      raise;
    end;
  end;
end;

// P110T10 NST 06/06/2013 Add a new sort method
procedure TfrmReaderSetup.ListViewCompare(Sender: TObject; Item1,
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

end.








