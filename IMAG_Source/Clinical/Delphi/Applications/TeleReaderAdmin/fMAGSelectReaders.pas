unit fMAGSelectReaders;
{Package: MAG - VistA Imaging
WARNING: Per VHA Directive 10-93-142 this unit should not be modified.
Date Created: 04/2012
Site Name: Silver Spring, OIFO
Developers: Nikolay Topalov
[==   unit fMAGSelectReaders;
 Description:  This a for used by Reader Clone process. User selects available readers
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
  Dialogs, StdCtrls, Buttons, ActnList, ComCtrls, ImgList, VA508AccessibilityManager;

type
  TfrmSelectReader = class(TForm)
    amgrMain: TVA508AccessibilityManager;
    lstAvailable: TListBox;
    lstSelected: TListBox;
    btnSave: TBitBtn;
    btnCancel: TBitBtn;
    Label1: TLabel;
    Label2: TLabel;
    btnToSelected2: TButton;
    btnToAvailable2: TButton;
    edtNameSearch: TEdit;
    Label3: TLabel;
    ActionList1: TActionList;
    actSelect: TAction;
    actDeselect: TAction;
    tvPrivileges: TTreeView;
    Label4: TLabel;
    ImageList1: TImageList;
    procedure FormShow(Sender: TObject);
    procedure FormClose(Sender: TObject; var Action: TCloseAction);
    procedure edtNameSearchKeyDown(Sender: TObject; var Key: Word;
      Shift: TShiftState);
    procedure FormDestroy(Sender: TObject);
    procedure lstAvailableKeyDown(Sender: TObject; var Key: Word;
      Shift: TShiftState);
    procedure lstSelectedKeyDown(Sender: TObject; var Key: Word;
      Shift: TShiftState);
    procedure actDeselectExecute(Sender: TObject);
    procedure actSelectExecute(Sender: TObject);
  private
    { Private declarations }
    sAlreadyAddedReaders : String;  // Readers already created

    procedure GetSelected(var SelectedIENs: TStrings; var SelectedNames : TStrings);
    procedure MoveToSelected;
    procedure MoveToAvailable;
    procedure GetUserNames(SearchStr: string);
    procedure EnableDisableActions;
    procedure CopySubtree(sourcenode : TTreenode; target : TTreeview; targetnode : TTreenode);
    procedure PopulateSourcePrivileges(sourcenode : TTreenode);
  public
    { Public declarations }
  end;

var
  frmSelectReader: TfrmSelectReader;
  function GetReadersToClone(pFormCaption : String; var pSelectedReadersIENs : TStrings; var pSelectedReadersNames : TStrings; pAlreadyAddedReaders : String; pSourceNode : TTreeNode) : Boolean;

implementation

uses
  uMAGGlobalsTRA, dmMAGTeleReaderAdmin, MagFMComponents, trpcb, DiTypLib, Fmcmpnts, MagFileVersion;

{$R *.dfm}

function GetReadersToClone(pFormCaption : String; var pSelectedReadersIENs : TStrings; var pSelectedReadersNames : TStrings; pAlreadyAddedReaders : String; pSourceNode : TTreeNode) : Boolean;
begin
  result := false;
  try
    frmSelectReader := TfrmSelectReader.Create(nil);
    frmSelectReader.Caption := pFormCaption;
    frmSelectReader.PopulateSourcePrivileges(pSourceNode);
    frmSelectReader.sAlreadyAddedReaders := pAlreadyAddedReaders;
    result := frmSelectReader.ShowModal = mrOK;
    if result then
    begin
      frmSelectReader.GetSelected(pSelectedReadersIENs,pSelectedReadersNames);
    end;
  finally
    frmSelectReader.Free;
  end;
end;


// Return selected readers
procedure TfrmSelectReader.GetSelected(var SelectedIENs: TStrings; var SelectedNames : TStrings);
var i: Integer;
begin
  SelectedIENs.Clear;
  SelectedNames.Clear;
  for i := 0 to lstSelected.Items.Count - 1 do
  begin
    SelectedIENs.Add(TIENObj(lstSelected.Items.Objects[i]).sIEN);
    SelectedNames.Add(lstSelected.Items[i]);
  end;
end;

procedure TfrmSelectReader.FormShow(Sender: TObject);
begin
  GetFormPosition(self);
end;

procedure TfrmSelectReader.MoveToSelected;
var i: integer;
begin
  for i := lstAvailable.Items.Count - 1 downto 0 do
    if lstAvailable.Selected[i] then
    begin
      lstSelected.Items.AddObject(lstAvailable.Items.Strings[i], lstAvailable.Items.Objects[i]);
      lstAvailable.Items.Delete(i);
    end;
end;

procedure TfrmSelectReader.MoveToAvailable;
var i: integer;
begin
  for i := lstSelected.Items.Count - 1 downto 0 do
    if lstSelected.Selected[i] then
    begin
      lstAvailable.Items.AddObject(lstSelected.Items.Strings[i], lstSelected.Items.Objects[i]);
      lstSelected.Items.Delete(i);
    end;
end;

procedure TfrmSelectReader.edtNameSearchKeyDown(Sender: TObject; var Key: Word;
  Shift: TShiftState);
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
    lstAvailable.Clear;
    GetUserNames(sName);
    EnableDisableActions
  end;
end;

procedure TfrmSelectReader.actSelectExecute(Sender: TObject);
begin
  MoveToSelected;
  EnableDisableActions;
end;

procedure TfrmSelectReader.actDeselectExecute(Sender: TObject);
begin
  MoveToAvailable;
  EnableDisableActions;
end;

procedure TfrmSelectReader.FormClose(Sender: TObject;
  var Action: TCloseAction);
begin
  SaveFormPosition(self);
end;

procedure TfrmSelectReader.FormDestroy(Sender: TObject);
begin
  FreeStringsIENObj(lstAvailable.Items);
  FreeStringsIENObj(lstSelected.Items);
end;


// Get user/readers with Last Name starts with SearchStr
// and populate Available Readers
procedure TfrmSelectReader.GetUserNames(SearchStr: string);
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
        lstAvailable.Items.AddObject(sReader, TIENObj.Create(sIEN));
    end;
    if lstAvailable.Items.Count = 0 then
    begin
      ShowMessage508('No matches were found for search string against the list of active users who do not yet have rights.', self.Handle);
      exit;
    end;
    lstAvailable.ItemIndex := 0;
    lstAvailable.SetFocus;
  finally
    Lister.Free;
    sl.Free;
  end;
end;

// Select a reader
procedure TfrmSelectReader.lstAvailableKeyDown(Sender: TObject; var Key: Word;
  Shift: TShiftState);
begin
 if (key = VK_RETURN) and (ssCtrl in Shift) then
    actSelect.Execute;
end;

// Deselect a reader
procedure TfrmSelectReader.lstSelectedKeyDown(Sender: TObject; var Key: Word;
  Shift: TShiftState);
begin
  if (key = VK_RETURN) and (ssCtrl in Shift) then
    actDeSelect.Execute;
end;

// Update buttons/actions
procedure TfrmSelectReader.EnableDisableActions;
begin
  btnSave.Enabled := lstSelected.Items.Count > 0;
  actSelect.Enabled :=  lstAvailable.Items.Count > 0;
  actDeSelect.Enabled :=  lstSelected.Items.Count >0;
end;

// Used to populate the privileges tree
procedure TfrmSelectReader.CopySubtree(sourcenode : TTreenode; target : TTreeview;
   targetnode : TTreenode);
 var
   anchor : TTreenode;
   child : TTreenode;
 begin { CopySubtree }
   anchor := target.Items.AddChild(targetnode, sourcenode.Text);
   anchor.Assign(sourcenode);
   child := sourcenode.GetFirstChild;
   while Assigned(child) do
    begin
     CopySubtree(child, target, anchor);
     child := child.getNextSibling;
   end; { While }
 end; { CopySubtree }

// Copy Privileges for a reader. sourcenode is a selected reader node
procedure TfrmSelectReader.PopulateSourcePrivileges(sourcenode : TTreenode);
var
  child : TTreenode;
  //sitenode, specialtynode : TTreenode;
begin
  tvPrivileges.Items.Clear;
  if sourcenode.Level = 0 then   // Reader
  begin
    child := sourcenode.GetFirstChild;
    while Assigned(child) do
    begin
      CopySubtree(child, tvPrivileges, nil);
      child := child.getNextSibling;
    end;
  end;
  {/ At this point only Reader can be selected
     In case we need to select Site, Specialty or Proceedure the code is here

  else if sourcenode.Level = 1 then   // Site
    CopySubtree(sourcenode, tvPrivileges, nil)
  else if sourcenode.Level = 2 then  // Specialty
  begin
    sitenode := tvPrivileges.Items.AddChild(nil,sourcenode.Parent.Text);
    sitenode.Assign(sourcenode.Parent);
    CopySubtree(sourcenode, tvPrivileges, sitenode)
  end
  else   // Procedure
  begin
    sitenode := tvPrivileges.Items.AddChild(nil,sourcenode.Parent.Parent.Text);
    sitenode.Assign(sourcenode.Parent.Parent);
    specialtynode :=  tvPrivileges.Items.AddChild(sitenode,sourcenode.Parent.Text);
    specialtynode.Assign(sourcenode.Parent);
    CopySubtree(sourcenode, tvPrivileges, specialtynode)
  end;
     /}
   tvPrivileges.FullExpand;
 end;
end.
