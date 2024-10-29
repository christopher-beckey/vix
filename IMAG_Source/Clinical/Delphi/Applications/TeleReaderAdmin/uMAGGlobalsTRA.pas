unit uMAGGlobalsTRA;
{Package: MAG - VistA Imaging
WARNING: Per VHA Directive 10-93-142 this unit should not be modified.
Date Created: 08/2009
Site Name: Silver Spring, OIFO
Developers: Bill Balshem
[==   unit uMAGGlobalsTRA;
 A collection of basic function and procedures used throughout the other units within the TeleReader Admin app project;
 Includes TReader, TReaderSubItem classes.
 These objects are used to manage/organize the assocation of Vista Reader data Delphi Components 
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
  Controls, StdCtrls, Windows, Messages, Classes, SysUtils, ComCtrls, ExtCtrls, ShellAPI, Forms, Dialogs, Graphics,
  IniFiles, dmMAGTeleReaderAdmin, MagFMComponents, trpcb, DiTypLib, Fmcmpnts;

type
  TFormState = (fsAdd, fsEdit);
  TFilterType = (ftAdd, ftRemove);

  TReaderSubItem = class(TObject)
  private
  public
    FIEN: string;
    FText: string;
    FActive: string;
    FUserPref: string; //not being used
    FLevel: integer; //1=site, 2=specialty,3=procedure
    procedure Copy(Sub: TReaderSubItem);
    function ActiveOpposite: string;
  end;

  TReader = class(TObject)
  private
  public
    FReaderIEN: string;
    FName: string;
    FSite: TReaderSubItem;
    FSpecialty: TReaderSubItem;
    FProc: TReaderSubItem;
    constructor Create;
    destructor Free;
    procedure PopulateReader(s: string);
    procedure Copy(Reader: TReader);
  end;

  //class used for sorting listviews
  TSort = class(TObject)
  private
  public
    s: string;
    p: pointer;
  end;

  TMagLogger = class(TStringList)
  public
    procedure Log(sType, sMessage: string);
  end;

  TMagScreenArea = class
    left : integer;
    top : integer;
    right : integer;
    bottom : integer;
    width : integer;
    height : integer;
  end;

  TIENObj = class
    sIEN: string;
    constructor Create(IEN: string);
  end;

function FormStateToStr(fState: TFormState): string;
function AllMandatoryFieldsSelected(Sender: TWinControl): boolean;
procedure SetCombosReadOnly(Sender: TWinControl);
procedure PopulateComboBox(cmb: TComboBox; sFileNumber, sFieldNumber, sFilterFld, sFilter: string; sScreen: string = '');
procedure PopulateComboBoxWithTextFilter(cmb: TComboBox; sFileNumber, sFieldNumber, sFilterSTR: string; FilterType: TFilterType; sScreen: string = '');
procedure PopulateComboBoxRPC(cmb: TComboBox; sRPCCall, sFilter: string; iFlags: integer);

procedure PopComboWithSites(cmb: TComboBox; FilterSTR: string = ''; Filter: TFilterType = ftRemove);
procedure PopComboWithLocalSites(cmb: TComboBox; bAdd: boolean);
function FormatSiteText(sName, sStation: string): string;
procedure LoadSites;
procedure LoadSiteStationNumbers;
procedure AddStationNumToSiteCol(LV: TListView; iCol: integer);
procedure SetLoginStationNum;
function LookupSiteStationNo(sName: string): string;
function GetSiteStationNoFromIEN(sIEN: string): string;
procedure FlagLocalSites;
procedure FlagLoginSite;

function Remove1stColumn(s: string): string;
function RemoveFrontColumns(s: string; iCols: integer): string;
function Get1stColumn(s: string): string;
procedure OpenHelpFile;
function GetIniFileName: string;
function GetIniFileDir : string;  // NST P127 09/28/2012
function GetLogFileDir : string;  // NST P127 09/28/2012 

procedure SaveFormPosition(Form: TForm);
procedure GetFormPosition(Form: TForm);
function GetScreenArea: TMagScreenArea;

procedure ResizeListViewColumns(Form: TForm; lv: TListView);
function ControlHasHelpText(Control: TWinControl): boolean;

procedure ShowMessage508(const Msg: string; Handle: HWND);
function MessageDlg508(const Msg: string; DlgType: TMsgDlgType; Buttons: TMsgDlgButtons; Handle: HWND): integer;

function GetDataDictionaryHelp(FileNum, FieldNum: string): string;

procedure SetControlFor508(CTRL: TWinControl; Order: integer; frm: TForm); overload;
procedure SetControlFor508(CTRL: TWinControl; Order: integer; gb: TGroupBox); overload;
procedure SetFormFor508(frm: TForm);
function CheckFor508Mode: boolean;

procedure FreeListViewIENObj(lv: TListView);
procedure FreeStringsIENObj(STR: TStrings);
function GetTriggerValues: string;
function FormatTriggerText(sIEN, sVal: string): string;

function KickoffListerJob: string;
function JobIsComplete(sHandle: string): boolean;
procedure GetJobResults(sHandle: string; var sl: TStringList);
procedure ClearJobResults(sHandle: string);

const
  sInstructions = 'Enter data in the order presented.';
  CancelSTR = 'Are you sure you want to cancel?';
  LST_DEL = #13 + #10;
  STR_DEL = '|';
  F1KEY = 112;

var
  slStationNumbers: TStringList;
  sLoginStation, sTriggers: string;
  MagLogger: TMagLogger;
  In508Mode: boolean;

  sHandle: string;
  JobCompleted: boolean;
  slClinicData: TStringList;

implementation

uses
  Magfileversion, StrUtils;

//slStationNumbers - each string has a layout of:
//(site name)=(site IEN)^(station number)^(Local?)
//the local value is one character  where:
//  Y = this site is local to the VistA instatllation
//  N = this site is not local to the VistA installation
//  L = this is the login site
//SALT LAKE DOM=6001^660AA^Y

procedure FreeListViewIENObj(lv: TListView);
var i, j: integer; Item: TListItem;
begin
  for i := 0 to lv.Items.Count - 1 do
  begin
    Item := lv.Items[i];
    TIENObj(Item.Data).Free;
    for j := 0 to Item.SubItems.Count - 1 do TIENObj(Item.SubItems.Objects[j]).Free;
  end;
end;

procedure FreeStringsIENObj(STR: TStrings);
var i: integer;
begin
  for i := 0 to STR.Count - 1 do
    TIENObj(STR.Objects[i]).Free;
end;

constructor TIENObj.Create(IEN: string);
begin
  sIEN := IEN;
end;

procedure TMagLogger.Log(sType, sMessage: string);
var i : integer;
const DEL = ' ' + STR_DEL + ' ';
begin
  Add(DateTimeToStr(Now) + DEL + sType + DEL + sMessage);
  if Count > 10000 then for i := 499 downto 0 do Delete(i);
end;

function FormStateToStr(fState: TFormState): string;
begin
  case fState of
    fsAdd: result := 'Add';
    fsEdit:  result := 'Edit';
  end
end;

procedure SetCombosReadOnly(Sender: TWinControl);
//set defeulat behavoir for all combo boxes on the given add/edit screen
var i: integer; cmb: TComboBox;
begin
  with Sender do
    for i := 0 to ControlCount - 1 do
    begin
      if (Controls[i] is TGroupBox) or (Controls[i] is TPanel) then SetCombosReadOnly(TWinControl(Controls[i]));
      if TControl(Controls[i]) is TComboBox then begin
        cmb := TComboBox(Controls[i]);
        cmb.Style := csDropDownList;
        cmb.Constraints.MaxHeight := 500;
      end;
    end;
end;

function AllMandatoryFieldsSelected(Sender: TWinControl): boolean;
//any combo box with a mandatory field needed for a add/edit post has its tag property set to 1
var i: integer;
begin
  result := true;
  with Sender do
    for i := 0 to ControlCount - 1 do begin
      if (Controls[i] is TGroupBox) or (Controls[i] is TPanel) then
      begin
        result := AllMandatoryFieldsSelected(TWinControl(Controls[i]));
        if result = false then break;
      end;
      if Controls[i] is TComboBox then
        if (length(TComboBox(Controls[i]).Text) < 1) and (TComboBox(Controls[i]).Tag = 0) then begin
          result := false;
          break;
        end;
      if Controls[i] is TEdit then
        if (length(TEdit(Controls[i]).Text) < 1) and (TEdit(Controls[i]).Tag = 0) then begin
          result := false;
          break;
        end;
    end;
end;

procedure PopulateComboBox(cmb: TComboBox; sFileNumber, sFieldNumber, sFilterFld, sFilter: string; sScreen: string = '');
//Populate combo box from a Fileman Lookup component, used to retrieve one colum of data from a file, usually refernce data
var Lookup: TMAGFMLookup; sIEN, sDisplay, sTemp: string; iCTR, i: integer; slDisplay, slIEN: tstringlist;
begin
  cmb.Items.Clear;
  slDisplay := TStringList.Create;
  slIEN := TStringList.Create;
  Lookup := TMAGFMLookup.Create(nil);
  try
    try
      Lookup.FMLookupGetLists(DataModule1.Broker, sFileNumber, sFieldNumber, sIEN, sDisplay, iCTR, sFilterFld, sFilter, sScreen);
      MagLogger.Log('INFO', 'Retrieved ' + sFileNumber + '/' + sFieldNumber + ' reference data.');
    except
      on e: exception do
      begin
        MagLogger.Log('ERROR', e.Message);
        raise;
      end;
    end;
    slDisplay.SetText(pAnsiChar(sDisplay));
    slIEN.SetText(pAnsiChar(sIEN));
    if cmb.Tag = 1 then cmb.Items.Add(emptystr); //if optional field, let user choose nothing
    for i := 0 to slDisplay.Count - 1 do
    begin
      sTemp := slIEN.Strings[i];
      if sTemp[1] = '.' then continue;
      sTemp := copy(sTemp, 1, length(sTemp) - 1); //remove trailing comma
      cmb.Items.AddObject(slDisplay.Strings[i], TIENObj.Create(sTemp));
    end;
  finally
    slDisplay.Free;
    slIEN.Free;
    Lookup.Free;
  end;
end;

procedure PopulateComboBoxWithTextFilter(cmb: TComboBox; sFileNumber, sFieldNumber, sFilterSTR: string; FilterType: TFilterType; sScreen: string = '');
//same as PopulateComboBox, but a list a values to be left of list are passed to routine
//ex: these values have been used in a previous record an cannot be re-selecetd
var Lookup: TMAGFMLookup; sIEN, sDisplay, sTemp: string; iCTR, i: integer; slDisplay, slIEN: tstringlist;
begin
  cmb.Items.Clear;
  slDisplay := TStringList.Create;
  slIEN := TStringList.Create;
  Lookup := TMAGFMLookup.Create(nil);
  try
    try
      Lookup.FMLookupGetLists(DataModule1.Broker, sFileNumber, sFieldNumber, sIEN, sDisplay, iCTR, emptystr, emptystr, sScreen);
      MagLogger.Log('INFO', 'Retrieved ' + sFileNumber + '/' + sFieldNumber + ' reference data.');
    except
      on e: exception do
      begin
        MagLogger.Log('ERROR', e.Message);
        raise;
      end;
    end;
    slDisplay.SetText(pAnsiChar(sDisplay));
    slIEN.SetText(pAnsiChar(sIEN));
    if cmb.Tag = 1 then cmb.Items.Add(emptystr); //if optional field, let user choose nothing
    for i := 0 to slDisplay.Count - 1 do
    begin
      sTemp := slIEN.Strings[i];
      if sTemp[1] = '.' then continue;
      if FilterType = ftRemove then
      begin
        if pos(STR_DEL + UpperCase(slDisplay.Strings[i]) + STR_DEL, UpperCase(sFilterSTR)) > 0 then continue;
      end
      else if FilterType = ftADD then
      begin
        if pos(STR_DEL + UpperCase(slDisplay.Strings[i]) + STR_DEL, UpperCase(sFilterSTR)) = 0 then continue;
      end;
      sTemp := copy(sTemp, 1, length(sTemp) - 1); //remove trailing comma
      cmb.Items.AddObject(slDisplay.Strings[i], TIENObj.Create(sTemp));
    end;
  finally
    slDisplay.Free;
    slIEN.Free;
    Lookup.Free;
  end;
end;

//'ALLERGY & IMMUNOLOGY^ALL&IMM^|41'
//'ANESTHESIOLOGY^ANESTH^|40'
procedure PopulateComboBoxRPC(cmb: TComboBox; sRPCCall, sFilter: string; iFlags: integer);
//Populate combo box from an rpc call
//Fileman componenets cannot be used for more complicated quesires, such as joins
var sl: TStringList; i: integer; s, sText, sIEN: string;
begin
  cmb.Items.Clear;
  sl := TStringList.Create;
  DataModule1.Broker.RemoteProcedure := sRPCCall;
  DataModule1.Broker.Param[0].PType := literal;
  DataModule1.Broker.Param[0].Value := emptystr;
  DataModule1.Broker.Param[1].PType := literal;
  DataModule1.Broker.Param[1].Value := sFilter;
  DataModule1.Broker.Param[2].PType := literal;
  case iFlags of
    3: DataModule1.Broker.Param[2].Value := '0^0^0^';
    4: DataModule1.Broker.Param[2].Value := '0^0^0^0^';
  end;
  try
    try
      DataModule1.Broker.lstcall(sl);
      MagLogger.Log('INFO', 'Ref data retrieval ' + sRPCCall + ' call successful.');
    except
      on e: exception do
      begin
        MagLogger.Log('ERROR', e.Message);
        raise;
      end;
    end;
    for i := 2 to sl.Count - 1 do  // first 2 strings: 0 = result, 1 = headings
    begin
      s := sl.Strings[i];
      sText := copy(s, 1, pos('^', s) - 1);
      sIEN := copy(s, pos('|', s) + 1, length(s) - pos('|', s));
      cmb.Items.AddObject(sText, TIENObj.Create(sIEN));
    end;
  finally
    sl.Free;
  end;
end;

function Remove1stColumn(s: string): string;
//remove 1st field from a delimited list, including delimiter
begin
  if pos('^', s) = 0 then
    result := ''
  else
    result := copy(s, pos('^', s) + 1, length(s) - pos('^', s));
end;

function RemoveFrontColumns(s: string; iCols: integer): string;
var i: integer;
begin
  result := s;
  for i := 1 to iCols do result := Remove1stColumn(result);
end;

function Get1stColumn(s: string): string;
//get 1st field from a delimited list
begin
  result := copy(s, 1, pos('^', s) - 1);
end;

constructor TReader.Create;
begin
  FReaderIEN := '0';
  FSite := TReaderSubItem.Create;
  FSpecialty := TReaderSubItem.Create;
  FProc := TReaderSubItem.Create;
end;

destructor TReader.Free;
begin
  FSite.Free;
  FSpecialty.Free;
  FProc.Free;
end;

function CorrectActiveIfNeccesary(s: string): string;
begin
  result := s;
  if result <> '1' then result := '0';
end;

//126^Smith,Joe^660^SALT LAKE CITY^1^57^EYE CARE^1^175^CORONARY ARTERY BYPASS^1^1
//126^Smith,Joe^660^SALT LAKE CITY^660^1^57^EYE CARE^1^175^CORONARY ARTERY BYPASS^1^1
procedure TReader.PopulateReader(s: string);
begin
  FReaderIEN := Get1stColumn(s);
  s := Remove1stColumn(s);
  FName := Get1stColumn(s);
  s := Remove1stColumn(s);
  {}
  FSite.FLevel := 1;
  FSite.FIEN := Get1stColumn(s);
  s := Remove1stColumn(s);
  FSite.FText := Get1stColumn(s);
  s := Remove1stColumn(s);
  FSite.FText := FormatSiteText(FSite.FText, Get1stColumn(s)); //new
  s := Remove1stColumn(s);  // new
  FSite.FActive := CorrectActiveIfNeccesary(Get1stColumn(s));
  s := Remove1stColumn(s);
  {}
  FSpecialty.FLevel := 2;
  FSpecialty.FIEN := Get1stColumn(s);
  s := Remove1stColumn(s);
  FSpecialty.FText := Get1stColumn(s);
  s := Remove1stColumn(s);
  FSpecialty.FActive := CorrectActiveIfNeccesary(Get1stColumn(s));
  s := Remove1stColumn(s);
  {}
  FProc.FLevel := 2;
  FProc.FIEN := Get1stColumn(s);
  s := Remove1stColumn(s);
  FProc.FText := Get1stColumn(s);
  s := Remove1stColumn(s);
  FProc.FActive := CorrectActiveIfNeccesary(Get1stColumn(s));
  s := Remove1stColumn(s);
end;

procedure TReader.Copy(Reader: TReader);
begin
  FReaderIEN := Reader.FReaderIEN;
  FName := Reader.FName;
  FSite.Copy(Reader.FSite);
  FSpecialty.Copy(Reader.FSpecialty);
  FProc.Copy(Reader.FProc);
end;

procedure TReaderSubItem.Copy(Sub: TReaderSubItem);
begin
  FIEN := Sub.FIEN;
  FText := Sub.FText;
  FActive := Sub.FActive;
  FUserPref := Sub.FUserPref;
  FLevel := Sub.FLevel;
end;

function TReaderSubItem.ActiveOpposite: string;
var i: integer; Status: boolean;
begin
  i := StrToInt(FActive);
  status := not boolean(i);
  result := IntToStr(Integer(status));
end;

function FormatSiteText(sName, sStation: string): string;
begin
  if length(sStation) > 0 then
    result := sName + ' (' + sStation + ')'
  else result := sName;
end;

function SiteStationNoByIndex(NDX: integer): string;
var s: string; Pos1, Pos2: integer;
begin
  s := slStationNumbers.Strings[NDX];
  Pos1 := pos('=', s);
  Pos2 := pos('^', s);
  result := copy(s, Pos1 + 1, Pos2 - Pos1 - 1);
end;

//see documentation for the slStationNumbers string layout at the top of the implementation section
procedure FlagLocalSites;
var Lister : TMagFMLister; sIEN, s, sStation: string; i: integer; RecordObj: TFMRecordObj;
    sl: TStringList;
begin
  Lister := TMagFMLister.Create(nil);
  sl := TStringList.Create;
  try
    Lister.RPCBroker := DataModule1.Broker;
    try
      Lister.Retrieve('40.8', '1'); //1 = Station Number
      MagLogger.Log('INFO', 'Local sites retrieved.');
    except
      on e: exception do
      begin
        MagLogger.Log('ERROR', e.Message);
        raise;
      end;
    end;
    if Lister.Results.Count = 0 then exit;
    for i := 0 to Lister.Results.Count - 1 do
    begin
      sIEN := Lister.Results[i];
      RecordObj := Lister.GetRecord(sIEN);
      sl.Add(RecordObj.GetField(RecordObj.FMFLDValues[0]).FMDBExternal);
    end;
    {}
    for i := 0 to slStationNumbers.Count - 1 do
    begin
      sStation := SiteStationNoByIndex(i);
      s := slStationNumbers.Strings[i];
      if sl.IndexOf(sStation) > -1 then s := s + '^Y'
      else s := s + '^N';
      slStationNumbers.Strings[i] := s;
    end;
  {}
  finally
    Lister.Free;
    sl.Free;
  end;
end;

procedure PopComboWithLocalSites(cmb: TComboBox; bAdd: boolean);
var i, iPos: integer; s, sName, sStationNo, sIEN, sLocal, sLogin: string;
begin
  sLogin := '';
  for i := 0 to slStationNumbers.Count - 1 do
  begin
    s := slStationNumbers.Strings[i];
    iPos := pos('=', s);
    sName := copy(s, 1, iPos - 1);
    s := copy(s, iPos + 1, length(s) - iPos);
    sStationNo := MagStrPiece(s, '^', 1);
    sIEN := MagStrPiece(s, '^', 2);
    sLocal := MagStrPiece(s, '^', 3);
    if sLocal = 'L' then sLogin := FormatSiteText(sName, sStationNo);
    if sLocal <> 'N' then cmb.Items.AddObject(FormatSiteText(sName, sStationNo), TIENObj.Create(sIEN))
  end;
  if bAdd then cmb.ItemIndex := cmb.Items.IndexOf(sLogin); //Set Local Login As Default (Acquisition side LocalOnly = true, Reader Side side LocalOnly = false)
end;

procedure PopComboWithSites(cmb: TComboBox; FilterSTR: string = ''; Filter: TFilterType = ftRemove);
var i, iPos: integer; s, sName, sStationNo, sIEN: string; bMatch: boolean;
begin
  for i := 0 to slStationNumbers.Count - 1 do
  begin
    s := slStationNumbers.Strings[i];
    iPos := pos('=', s);
    sName := copy(s, 1, iPos - 1);
    s := copy(s, iPos + 1, length(s) - iPos);
    sStationNo := MagStrPiece(s, '^', 1);
    sIEN := MagStrPiece(s, '^', 2);
    if FilterSTR = '' then
    begin
      cmb.Items.AddObject(FormatSiteText(sName, sStationNo), TIENObj.Create(sIEN));
    end
    else
    begin //check filter before adding to combo
      bMatch := pos(STR_DEL + UpperCase(FormatSiteText(sName, sStationNo)) + STR_DEL, UpperCase(FilterSTR)) > 0;
      if (bMatch and (Filter = ftAdd)) or ((not bMatch) and (Filter = ftRemove)) then
        cmb.Items.AddObject(FormatSiteText(sName, sStationNo), TIENObj.Create(sIEN))
    end;
  end;
end;

//see documentation for the slStationNumbers string layout at the top of the implementation section
procedure LoadSites;
var Lister : TMagFMLister; sIEN: string; i: integer; RecordObj: TFMRecordObj;
begin
  Lister := TMagFMLister.Create(nil);
  try
    Lister.RPCBroker := DataModule1.Broker;
    try
      Lister.Retrieve('4', '@' + LST_DEL + '.01' + LST_DEL + '99');
      //Lister.Retrieve('4', '.01' + LST_DEL + '99');
      MagLogger.Log('INFO', 'Retrieved sites from institution file(#4).');
    except
      on e: exception do
      begin
        MagLogger.Log('ERROR', e.Message);
        raise;
      end;
    end;
    if Lister.Results.Count = 0 then exit;
    for i := 0 to Lister.Results.Count - 1 do
    begin
      sIEN := Lister.Results[i];
      RecordObj := Lister.GetRecord(sIEN);
      slStationNumbers.Add(RecordObj.GetField(RecordObj.FMFLDValues[0]).FMDBExternal + '=' + RecordObj.GetField(RecordObj.FMFLDValues[1]).FMDBExternal + '^' + sIEN);
    end;
  finally
    Lister.Free;
  end;
end;

procedure LoadSiteStationNumbers;
var Lister : TMagFMLister; sIEN: string; i: integer; RecordObj: TFMRecordObj;
begin
  Lister := TMagFMLister.Create(nil);
  try
    Lister.RPCBroker := DataModule1.Broker;
    try
      Lister.Retrieve('4', '99');
      MagLogger.Log('INFO', 'Retrieved site station numbers.');
    except
      on e: exception do
      begin
        MagLogger.Log('ERROR', e.Message);
        raise;
      end;
    end;
    if Lister.Results.Count = 0 then exit;
    for i := 0 to Lister.Results.Count - 1 do
    begin
      sIEN := Lister.Results[i];
      RecordObj := Lister.GetRecord(sIEN);
      slStationNumbers.Add(sIEN+'='+RecordObj.GetField(RecordObj.FMFLDValues[0]).FMDBExternal);
    end;
  finally
    Lister.Free;
  end;
end;

function GetListItemMatch(LV: TListView; sIEN: string): TListItem;
var i: integer; RecordObj: TFMRecordObj;
begin
  result := nil;
  for i := 0 to LV.Items.Count - 1 do
  begin
    RecordObj := TFMRecordObj(LV.Items[i].Data);
    if RecordObj.IEN = sIEN then
    begin
      result := LV.Items[i];
      exit;
    end;
  end;
end;

function LookupSiteStationNo(sName: string): string;
begin
  result := slStationNumbers.Values[sName];
  result := copy(result, 1, pos('^', result) - 1);
end;

function GetSiteStationNoFromIEN(sIEN: string): string;
var i: integer; s, TempIEN: string;
begin
  result := '';
  for i := 0 to slStationNumbers.Count - 1 do
  begin
    s := MagStrPiece(slStationNumbers.Strings[i], '=', 2);
    TempIEN := MagStrPiece(s, '^', 2);
    if TempIEN = sIEN then
    begin
      result := MagStrPiece(s, '^', 1);
      exit;
    end;
  end;
end;

procedure AddStationNumToSiteCol(LV: TListView; iCol: integer);
var i: integer; LI: TListItem;
begin
  for i := 0 to LV.Items.Count - 1 do
  begin
    LI := LV.Items[i];
    if iCol = 1 then LI.Caption := FormatSiteText(LI.Caption, LookupSiteStationNo(LI.Caption))
    else LI.SubItems[iCol - 2] := FormatSiteText(LI.SubItems[iCol - 2], LookupSiteStationNo(LI.SubItems[iCol - 2]));
  end;
end;

procedure SetLoginStationNum;
var sIEN, sName, sStationNum: string; MagFMGets: TMagFMGets;
begin
  //get login IEN
  DataModule1.Broker.RemoteProcedure := 'XWB GET VARIABLE VALUE';
  DataModule1.Broker.Param[0].PType := reference;
  DataModule1.Broker.Param[0].Value := 'DUZ(2)';
  sIEN := DataModule1.Broker.strcall;
  //get login station name, number
  MagFMGets := TMagFMGets.Create(nil);
  try
    MagFMGets.RPCBroker := DataModule1.Broker;
    MagFMGets.FileNumber := '4';
    MagFMGets.AddField('.01'); // station name
    MagFMGets.AddField('99'); // station number
    MagFMGets.IENS:= sIEN + ',';
    try
      MagFMGets.GetData;
      MagLogger.Log('INFO', 'Login station number set');
    except
      on e: exception do
      begin
        MagLogger.Log('ERROR', e.Message);
        raise;
      end;
    end;
    sName := MagFMGets.GetField('.01').FMDBExternal;
    sStationNum := MagFMGets.GetField('99').FMDBExternal;
    sLoginStation := FormatSiteText(sName, sStationNum);
  finally
    MagFMGets.Free;
  end;
end;

//see documentation for the slStationNumbers string layout at the top of the implementation section
procedure FlagLoginSite;
var sIEN, s, sTempIEN: string; i, Pos1, Pos2: integer;
begin
  //get login IEN
  DataModule1.Broker.RemoteProcedure := 'XWB GET VARIABLE VALUE';
  DataModule1.Broker.Param[0].PType := reference;
  DataModule1.Broker.Param[0].Value := 'DUZ(2)';
  try
    sIEN := DataModule1.Broker.strcall;
    MagLogger.Log('INFO', 'Retrieved Login station IEN');
  except
    on e: exception do
      begin
        MagLogger.Log('ERROR', e.Message);
        raise;
      end;
  end;
  for i := 0 to slStationNumbers.Count - 1 do
  begin
    s := slStationNumbers.Strings[i];
    if copy(s, length(s), 1) = 'Y' then
    begin
      Pos1 := pos('^', s);
      Pos2 := PosEx('^', s, Pos1 + 1);
      sTempIEN := copy(s, Pos1 + 1, Pos2 - Pos1 - 1);
      if sTempIEN = sIEN then
      begin
        s := copy(s, 1, length(s) - 1) + 'L'; //replace Y with L for Login site
        slStationNumbers.Strings[i] := s;
        exit;
      end;
    end;
  end;
end;

function MagExecuteFile(const FileName, Params, DefaultDir: string;
 ShowCmd: Integer; oper : string = 'open'): THandle;
var zOper, zFileName, zParams, zDir: array[0..279] of Char;
begin
  try
    Result := ShellExecute(Application.MainForm.Handle,strPcopy(zOper,oper),
    StrPCopy(zFileName, FileName), StrPCopy(zParams, Params),
    StrPCopy(zDir, DefaultDir), ShowCmd);
    MagLogger.Log('INFO', 'Successfully opened ' + FileName);
  except
    on e: exception do
    begin
      MagLogger.Log('ERROR', e.Message);
      raise;
    end;
  end
end;

procedure OpenHelpFile;
begin
  MagExecuteFile('MAGTeleReaderConfig.pdf', '', ExtractFilePath(Application.Exename), SW_SHOW);
end;

function GetIniFileName: string;
const FileName = 'MagTeleReaderConfig.ini';
var oldIniFile : String;
begin
  // NST P127 09/21/2012  Updated for Windows 7
  Result :=  GetIniFileDir +  FileName;
  If FileExists(Result) Then exit;

{So the AppData ini does not exist yet.}
{If old ini exists,  then copy it, and Done.}
  oldIniFile := ExtractFilePath(Application.ExeName) + FileName;
  if FileExists(oldIniFile) then
  begin
     copyfile(pchar(oldIniFile),pchar(Result),true);
     application.ProcessMessages;
     setfileattributes(pchar(result),0);   {change attributes to allow writing.}
  end;
end;

// NST P127 09/28/2012 Get Directory to retrieve/write Ini file
function GetIniFileDir : string;
begin
   Result := GetEnvironmentVariable('ALLUSERSPROFILE') + '\Application Data\VistA\Imaging\';
   if Not Directoryexists(Result) then  Forcedirectories(Result);
end;

// NST P127 09/28/2012 Get Directory to retrieve/write Log file
function GetLogFileDir : string;
begin
   Result := GetEnvironmentVariable('ALLUSERSPROFILE') + '\Application Data\VistA\Imaging\Log\';
   if Not Directoryexists(Result) then  Forcedirectories(Result);
end;

{* SAVE Screen position *}

procedure SaveFormPosition(Form: TForm);
begin
  if (Form.ClassName <> 'TfrmAcquisitionSetup') and (Form.windowstate <> wsnormal) then exit;
  with tinifile.create(GetIniFileName) do
  begin
    try
      writestring('SYS_LastPositions', form.name, inttostr(form.left) + ',' + inttostr(form.top) + ',' + inttostr(form.width) + ',' + inttostr(form.height));
    finally
      free;
    end;
  end;
end;

//cannot set form to screen center at design time, otherwise it will override settings made in GetFormPosition and screen will always come up centered
//cannot changed position property from sceen center to default at run time, will get error 'cannot change a non visible form...'
procedure CenterTheForm(Form: TForm);
begin
  Form.Left := round((Screen.Width - Form.Width) / 2);
  Form.Top := round((Screen.Height - Form.Height) / 2);
end;

procedure GetFormPosition(Form: TForm);
var FORMpos: string; wrksarea : TMagScreenArea; INI: TIniFile;
begin
  try
    INI := TIniFile.create(GetIniFileName);
    MagLogger.Log('INFO', 'retrieved form position coordinates from ini file.');
  except
    on e: exception do
    begin
      MagLogger.Log('ERROR', e.Message);
      raise;
    end;
  end;
  with INI do
  begin
    try
      FORMpos := readstring('SYS_LastPositions', form.name, 'NONE');
    finally
      free;
    end;
  end;
  if FORMpos <> 'NONE' then
  begin
    if ((form.BorderStyle = bsSizeToolWin) or (form.borderstyle = bssizeable))
      then FORM.setbounds(strtoint(magSTRpiece(formpos, ',', 1)), strtoint(magSTRpiece(formpos, ',', 2)),
        strtoint(magSTRpiece(formpos, ',', 3)), strtoint(magSTRpiece(formpos, ',', 4)))
    else begin
      FORM.LEFT := strtoint(magSTRpiece(formpos, ',', 1));
      FORM.TOP := strtoint(magSTRpiece(formpos, ',', 2));
    end;
  end
  else
  begin
    CenterTheForm(Form);
  end;
  wrksarea := GetScreenArea;
  try
    if (form.Left + form.Width) > wrksarea.right then form.left := wrksarea.right - form.Width;
    if (form.top + form.height) > wrksarea.bottom then form.top := wrksarea.bottom - form.height;
    if (form.top < wrksarea.top) then form.top := wrksarea.top;
    if (form.left < wrksarea.left) then form.left := wrksarea.left;
  finally
    wrksarea.free;
  end;
end;

function getScreenWidth: integer;
var i: integer;
begin
  result := 0;
  for i := 0 to screen.MonitorCount - 1 do result := result + screen.Monitors[i].Width;
end;

function GetScreenArea: TMagScreenArea;
var wrkbar : APPBARDATA;
begin

  result := TmagscreenArea.create;
  wrkbar.cbSize := 36;
  SHAppBarMessage(ABM_GETTASKBARPOS, wrkBar);

  // get the left and right positions of the workstation area.
  if (wrkBar.rc.Left <= 0) and (wrkbar.rc.right >= screen.width) then // taskbar is at top or bottom
  begin
    result.left := 0 ;
    result.right := getScreenWidth;
  end
  else if (wrkBar.rc.left <=0) then //taskbar is at left
  begin
    result.left := wrkBar.rc.Right;
    result.right := getScreenWidth(); //screen.width;
  end
  else if (wrkbar.rc.right >=screen.width) then //taskbar is at right
  begin
    result.left := 0;
    result.right := getScreenWidth(); //wrkbar.rc.Left;
  end;

  if (wrkBar.rc.top <= 0) and (wrkbar.rc.bottom >= screen.height) then //taskbar is at top or bottom
  begin
    result.top := 0 ;
    result.bottom := screen.height;
  end
  else if (wrkBar.rc.top <=0) then //taskbar is at top
  begin
    result.top := wrkBar.rc.bottom;
    result.bottom := screen.height;
  end
  else if (wrkbar.rc.bottom >=screen.height) then //taskbar is at bottom
  begin
    result.top := 0;
    result.bottom := wrkbar.rc.top;
  end;
  result.width := result.right - result.left;
  result.height := result.bottom - result.top;

end;

procedure CheckMaxColWidth(sl: TStringList; i, Val: integer);
begin
  if StrToInt(sl.Strings[i]) < Val then sl.Strings[i] := IntToStr(Val);
end;

procedure ResizeListViewColumns(Form: TForm; lv: TListView);
var iCol, iRow: integer; sl: TStringList; LI: TListItem;
begin
  sl := TStringList.Create;
  try
    for iCol := 0 to lv.Columns.Count - 1 do sl.Add(IntToStr(lv.Columns[iCol].Width));
    for iRow := 0 to lv.Items.Count - 1 do
    begin
      LI := lv.Items[iRow];
      CheckMaxColWidth(sl, 0, Form.Canvas.TextWidth(LI.caption));
      for iCol := 1 to lv.Columns.Count - 1 do CheckMaxColWidth(sl, iCol, Form.Canvas.TextWidth(LI.SubItems[iCol - 1]));
    end;
    for iCol := 0 to lv.Columns.Count - 1 do  lv.Columns[iCol].Width := StrToInt(sl.Strings[iCol]) + 25;
  finally
    sl.Free;
  end;
end;

function ControlHasHelpText(Control: TWinControl): boolean;
begin
  result := false;
  if (Control is TComboBox) or
     (Control is TCheckBox) or
     (Control is TEdit) or
     (Control is TListBox) then
    result := true;
end;

//I:CREATE/UPDATE WITH EVERY ACQUIRED IMAGE;O:CREATE WHEN REQUEST IS ORDERED;F:CREATE WHEN CONSULT IS FORWARDED TO IFC;
function GetTriggerValues: string;
begin
  DataModule1.Broker.REMOTEPROCEDURE := 'XWB GET VARIABLE VALUE';
  DataModule1.Broker.PARAM[0].PTYPE := Reference;
  DataModule1.Broker.PARAM[0].Value := '$P($G(^DD(2006.5841,5,0)),U,3)';
  Result := UpperCase(DataModule1.Broker.STRCALL);
end;

function FormatTriggerText(sIEN, sVal: string): string;
begin
  result := UpperCase('(' + sIEN + ') - ' + sVal);
end;

procedure ShowMessage508(const Msg: string; Handle: HWND);
var Text, Cap: PAnsichar;
begin 
  Text:= PAnsiChar(Msg);
  Cap := PAnsiChar(Application.Title);
  MessageBox(Handle, Text, Cap, MB_OK);
end;

function MessageDlg508(const Msg: string; DlgType: TMsgDlgType; Buttons: TMsgDlgButtons; Handle: HWND): integer;
var Text, Cap: PAnsichar;  uType: integer;
begin
  uType := 0;
  Text:= PAnsiChar(Msg);
  case DlgType of
    mtInformation: Cap := PAnsiChar('Information');
    mtConfirmation: Cap := PAnsiChar('Confirmation');
    mtError: Cap := PAnsiChar('Error');
  end;
  if DlgType = mtError then uType := uType + MB_ICONERROR
  else if DlgType = mtInformation then uType := uType + MB_ICONINFORMATION
  else if (DlgType = mtConfirmation) and (Buttons = [mbYes, mbNo]) then uType := uType + MB_ICONQUESTION + MB_YESNO
  else if (DlgType = mtConfirmation) and (Buttons = [mbOK, mbCancel]) then uType := uType + MB_ICONQUESTION + MB_OKCANCEL;
  result := MessageBox(Handle, Text, Cap, uType)
end;

function GetDataDictionaryHelp(FileNum, FieldNum: string): string;
var Help: TMAGFMHelp; HelpObj: TFMHelpObj;
begin
  HelpObj := nil; //to remove compiler warning
  Help := TMAGFMHelp.Create(nil);
  try
    Help.RPCBroker := DataModule1.Broker;
    Help.FileNumber := FileNum;
    Help.FieldNumber := FieldNum;
    Help.REMOTEPROCEDURE := 'DDR GET DD HELP';
    Help.HelpFlags := 'D';
    HelpObj := Help.GetHelp;
    if HelpObj <> nil then result := HelpObj.HelpText.Text
    else result := 'No Help Text Available';
  finally
    if HelpObj <> nil then HelpObj.Free;
    Help.Free;
  end;
end;

//508 routines

function SortByTabOrder(List: TStringList; Index1, Index2: integer): integer;
var i1, i2: integer;
begin
  i1 := TWinControl(List.Objects[Index1]).TabOrder;
  i2 := TWinControl(List.Objects[Index2]).TabOrder;
  if i1 < i2 then
    Result := -1
  else if i1 > i2 then
    Result := 1
  else
    Result := 0;
end;

procedure SetControlFor508(CTRL: TWinControl; Order: integer; frm: TForm);
var Edit: TEdit;
begin
  if (not(CTRL.Enabled)) and (CTRL.ClassName = 'TComboBox') then
  begin
    CTRL.TabStop := false;
    Edit := TEdit.Create(frm);
    Edit.Top := CTRL.Top;
    Edit.Height := CTRL.Height;
    Edit.Width := CTRL.Width;
    Edit.Left := CTRL.Left;
    Edit.Text := TComboBox(CTRL).Text + ' (CANNOT EDIT)';
    Edit.TabStop := true;
    Edit.TabOrder := Order;
    Edit.ReadOnly := true;
    Edit.Color := clBtnFace;
    Edit.Tag := 508;
    Edit.Name := CTRL.Name + '2';
    frm.InsertControl(Edit);
  end
  else
  begin
    CTRL.TabOrder := Order;
  end;
end;

procedure SetControlFor508(CTRL: TWinControl; Order: integer; gb: TGroupBox);
var Edit: TEdit;
begin
  if (not(CTRL.Enabled)) and (CTRL.ClassName = 'TComboBox') then
  begin
    CTRL.TabStop := false;
    Edit := TEdit.Create(gb);
    Edit.Top := CTRL.Top;
    Edit.Height := CTRL.Height;
    Edit.Width := CTRL.Width;
    Edit.Left := CTRL.Left;
    Edit.Text := TComboBox(CTRL).Text + ' (CANNOT EDIT)';
    Edit.Font.Size := 10;
    Edit.TabStop := true;
    Edit.ReadOnly := true;
    Edit.Color := clBtnFace;
    Edit.OnKeyPress := TComboBox(CTRL).OnKeyPress;
    Edit.Tag := 508;
    Edit.Name := CTRL.Name + '2';
    gb.InsertControl(Edit);
    Edit.TabOrder := Order;
  end
  else
  begin
    CTRL.TabOrder := Order;
  end;
end;

procedure SetFormFor508(frm: TForm);
var i: integer;  sl: TStringList;
begin
  sl := TStringList.Create;
  try
    for i := 0 to frm.ControlCount - 1 do
      if (frm.Controls[i] is TWinControl) and (TWinControl(frm.Controls[i]).TabStop) then
        sl.AddObject(IntToStr(TWinControl(frm.Controls[i]).TabOrder), frm.Controls[i]);
    sl.CustomSort(SortByTabOrder);
    for i := 0 to sl.Count - 1 do SetControlFor508(TWinControl(sl.Objects[i]), StrToInt(sl.Strings[i]), frm);
  finally
    sl.Free;
  end;
end;

function CheckFor508Mode: boolean;
var i: integer;
begin
  result := false;
  for i := 0 to ParamCount do
    if ParamStr(i) = '508' then
    begin
      result := true;
      exit;
    end;
end;

{*** server backround job kickoff ***}

function KickoffListerJob: string;
var sl: TStringList;
begin
  sl := TStringList.Create;
  try
    DataModule1.Broker.RemoteProcedure := 'XWB DEFERRED RPC';
    DataModule1.Broker.Param[0].PType := literal;
    DataModule1.Broker.Param[0].Value := 'MAGDDR LISTER';
    DataModule1.Broker.Param[1].PType := list;
    DataModule1.Broker.Param[1].Value := '.x';
    DataModule1.Broker.Param[1].Mult['"FILE"'] := '44';
    DataModule1.Broker.Param[1].Mult['"FIELDS"'] := '.01;3;';
    DataModule1.Broker.Param[1].Mult['"FLAGS"'] := 'P';
    DataModule1.Broker.Param[1].Mult['"MAX"'] := '*';
    DataModule1.Broker.Param[1].Mult['"OPTIONS"'] := '';
    DataModule1.Broker.lstCall(sl);
    result := sl.Strings[0];
  finally
    sl.Free;
  end;
end;

function JobIsComplete(sHandle: string): boolean;
var sl: TStringList;
begin
  result := false;
  sl := TStringList.Create;
  try
    DataModule1.Broker.RemoteProcedure := 'XWB DEFERRED STATUS';
    DataModule1.Broker.Param[0].PType := literal;
    DataModule1.Broker.Param[0].Value := sHandle;
    DataModule1.Broker.lstCall(sl);
    if pos('DONE', uppercase(sl.Strings[0])) > 0 then result := true;
  finally
    sl.Free;
  end;
end;

procedure GetJobResults(sHandle: string; var sl: TStringList);
begin
  DataModule1.Broker.RemoteProcedure := 'XWB DEFERRED GETDATA';
  DataModule1.Broker.Param[0].PType := literal;
  DataModule1.Broker.Param[0].Value := sHandle;
  DataModule1.Broker.lstCall(sl);
end;

procedure ClearJobResults(sHandle: string);
var sl: TStringList;
begin
  sl := TStringList.Create;
  try
    DataModule1.Broker.RemoteProcedure := 'XWB DEFERRED CLEAR';
    DataModule1.Broker.Param[0].PType := literal;
    DataModule1.Broker.Param[0].Value := sHandle;
    DataModule1.Broker.lstCall(sl);
  finally
    sl.Free;
  end;
end;

end.
