unit fMAGSelectCPTCode;
{Package: MAG - VistA Imaging
WARNING: Per VHA Directive 10-93-142 this unit should not be modified.
Date Created: 04/2012
Site Name: Silver Spring, OIFO
Developers: vhaiswtopaln
[==   unit fMAGSelectCPTCode;
 Description:  This form is used to look up Procedure CPT code
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
  Dialogs, StdCtrls, Buttons, ActnList, ComCtrls, ImgList,
  VA508AccessibilityManager;

type
  TfrmSelectCPTCode = class(TForm)
    amgrMain: TVA508AccessibilityManager;
    lstProcedures: TListBox;
    btnSave: TBitBtn;
    btnCancel: TBitBtn;
    lblListItems: TLabel;
    edtSearch: TEdit;
    Label3: TLabel;
    ImageList1: TImageList;
    btnSearch: TBitBtn;
    procedure FormShow(Sender: TObject);
    procedure FormClose(Sender: TObject; var Action: TCloseAction);
    procedure FormDestroy(Sender: TObject);
    procedure btnSaveClick(Sender: TObject);
    procedure edtSearchChange(Sender: TObject);
    procedure btnSearchClick(Sender: TObject);
    procedure edtSearchKeyDown(Sender: TObject; var Key: Word;
      Shift: TShiftState);
    procedure lstProceduresDblClick(Sender: TObject);
  private
    { Private declarations }

    procedure GetSelected(var pCPTCodeIEN : String; var pCPTCode : String; var pCPTCodeDescr : String);
    function GetProcedures(SearchStr: string) : Boolean;

  public
    { Public declarations }
  end;

var
  frmSelectCPTCode: TfrmSelectCPTCode;
  function LookupCPTCode(var pCPTCodeIEN : String; var pCPTCode : String; var pCPTCodeDescr : String) : Boolean;

implementation

uses
  uMAGGlobalsTRA, dmMAGTeleReaderAdmin, MagFMComponents, trpcb, DiTypLib, Fmcmpnts, MagFileVersion;

{$R *.dfm}

function LookupCPTCode(var pCPTCodeIEN : String; var pCPTCode : String; var pCPTCodeDescr : String) : Boolean;
begin
  result := false;
  try
    frmSelectCPTCode := TfrmSelectCPTCode.Create(nil);
    result := frmSelectCPTCode.ShowModal = mrOK;
    if result then
    begin
      frmSelectCPTCode.GetSelected(pCPTCodeIEN, pCPTCode, pCPTCodeDescr);
    end;
  finally
    frmSelectCPTCode.Free;
  end;
end;

// Return selected CPT Code
procedure TfrmSelectCPTCode.GetSelected(var pCPTCodeIEN : String; var pCPTCode : String; var pCPTCodeDescr : String);
var sIEN : String;
begin
  if lstProcedures.ItemIndex >= 0 then
  begin
    sIEN := TIENObj(lstProcedures.Items.Objects[lstProcedures.ItemIndex]).sIEN;
    pCPTCodeIEN := MagSTRPiece(sIEN,'^',1);  // First piece is IEN
    pCPTCode := MagSTRPiece(sIEN,'^',2);      // Second piece is CPT Code
    pCPTCodeDescr := lstProcedures.Items[lstProcedures.ItemIndex];
  end
  else    // No selection . The CPT code is set to blank
  begin
    pCPTCodeIEN := '';
    pCPTCode := '';
    pCPTCodeDescr := '';
  end;
end;

procedure TfrmSelectCPTCode.lstProceduresDblClick(Sender: TObject);
begin
  btnSaveClick(Sender);
end;

procedure TfrmSelectCPTCode.FormShow(Sender: TObject);
begin
  GetFormPosition(self);
end;

procedure TfrmSelectCPTCode.btnSaveClick(Sender: TObject);
begin
  if lstProcedures.ItemIndex < 0 then
  begin
    if MessageDlg508('Procedure is not selected. Click Cancel to select a procedure.',mtConfirmation,[mbOK,mbCancel],0) = mrCancel then
    exit
  end;

  ModalResult := mrOK;
end;

procedure TfrmSelectCPTCode.btnSearchClick(Sender: TObject);
begin
  if GetProcedures(edtSearch.Text) then
    lstProcedures.SetFocus
  else
  begin
    edtSearch.SelectAll;
    edtSearch.SetFocus;
  end;
end;

procedure TfrmSelectCPTCode.edtSearchChange(Sender: TObject);
begin
  btnSearch.Enabled :=  length(trim(edtSearch.Text))>0;
end;

procedure TfrmSelectCPTCode.edtSearchKeyDown(Sender: TObject; var Key: Word;
  Shift: TShiftState);
begin
  if KEY = VK_RETURN then
  begin
    btnSearchClick(Sender);
  end;
end;

procedure TfrmSelectCPTCode.FormClose(Sender: TObject;
  var Action: TCloseAction);
begin
  SaveFormPosition(self);
end;

procedure TfrmSelectCPTCode.FormDestroy(Sender: TObject);
begin
  FreeStringsIENObj(lstProcedures.Items);
end;


// Search for CPT Code by SearchStr
function TfrmSelectCPTCode.GetProcedures(SearchStr: string) : Boolean;
var I: Integer;
    sError : String;
    rList: TStrings;
begin
  Result := False;
  rList := Tstringlist.Create();

  DataModule1.Broker.RemoteProcedure := 'MAG3 TELEREADER CPT CODELOOKUP';
  DataModule1.Broker.Param[0].PType := literal;
  DataModule1.Broker.Param[0].Value :=  SearchStr;

  try
    DataModule1.Broker.lstCall(rList);

    FreeStringsIENObj(lstProcedures.Items);
    lstProcedures.Items.Clear;

    // Check for error or nothing found
    if strtointdef(MagStrPiece(rList[0],'^',1),0) <= 0 then
    begin
      sError := MagSTRPiece(rList[0],'^',2);
      MessageDlg508(sError, mtError, [mbOK], self.Handle);
      exit;
    end;

    for I := 1 to rList.Count - 1 do
    begin
      lstProcedures.Items.AddObject(MagSTRPiece(rList[I],'^',3), TIENObj.Create(MagStrPiece(rList[I], '^', 1)+'^'+MagStrPiece(rList[I], '^', 2)));
    end;
    result := true;
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


end.
