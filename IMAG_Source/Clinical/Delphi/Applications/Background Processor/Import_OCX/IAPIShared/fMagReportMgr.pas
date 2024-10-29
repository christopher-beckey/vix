unit fMagReportMgr;

{
Package: MAG - VistA Imaging
WARNING: Per VHA Directive 10-93-142 this unit should not be modified.
Date Created:  August 2010 for Patch 117
Site Name: Silver Spring, OIFO
Developers: Jerry Kashtan

[==  unit fMagReportMgr;

    Description: Centralizes report preparation using Taskman to process
    reports in the background.  For P117 this unit only services QA Statistic Reports.
    However if future patches need reports prepared from VistA, this unit can
    easily be extended with minor modifications to become a generalized
    report manager where input criteria is prepared for the type of report (e.g.,
    "QA STATS" at present), and the report status list will task them off, track
    them, and provide a means for viewing and disposing of them.

    Changed : gek T5  synchronization is no longer maintaned. awkwardness.
    A word about control synchronization.  The two paneled sides of this form, the report criteria
    selection part and the report status listing part are designed to keep in synch when the user
    selects a report in the list.  When an action is performed involving Taskman the
    synchronization is temporarily in an unknown state because there is an amount of time
    for Taskman to complete and the report line item may temporarily disappear from the list
    as it refreshes. In the meantime, as an example, a user can select a new action or create
    a new report.  When this happens and the synchronization is not re-established, the form logic
    prevents the action.  The user needs to press the refresh button or a report line item
    to re-establish synch.

    A note about saving the results of a report.  The results of the QA Statistics Report
    are prepared to be viewed in a table.  The user must save it off as an Excel file (file
    option) to preserve the data.  Otherwise, the ^XTMP area will eventually delete the
    report(s) when a scheduled administrative cleanup runs.  VistA Imaging does not
    preserve reports automatically.

==]
Note:
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
    ;; a Class II medical device.  As such, it may not be changed
    ;; in any way.  Modifications to this software may result in an
    ;; adulterated medical device under 21CFR820, the use of which
    ;; is considered to be a violation of US Federal Statutes.
    ;; +---------------------------------------------------------------------------------------------------+

*)

{/p117 T5,   Bug4 - awkwardness :
      QA Reports Window
      treat Left Panel separate than list.
      Left panel for New Reports.  List is existing reports.
      Stop changing functionality of 'Run Report' button.
      Have List button ' Re - Run ' when list item is selected
      Have Hint over list entry, to show settings for report.
      Resize Refresh Button, equal to all buttons.
      Run-Report checks for existing report with same settings, will display a dialog to user,
      to Re-Run, or Cancel building report.
       }
{  Seperate the Panel controls from the list.
    took actionCrossCheck off of all Panel controls, Action property/event  and OnClick Event.
 ... 6-7 of them}
interface

uses
  Windows, Messages, SysUtils, Variants, Classes, Graphics, Controls, Forms,
  Dialogs, StdCtrls, Buttons, ExtCtrls, ComCtrls, Menus, DateUtils,
  dmSingle,
  fmagVerifyStats,
  uMagDefinitions,
  Umagutils8,
  ActnList,
  XPStyleActnCtrls,
  ActnMan,
  MaggMsgu, ImgList;


type
  TDateCalc = (dcDateFrom, dcDateTo, dcSpan);
  TRunType = (rtNew, rtReRun);

  TListData = class
    ReportData: String;
  end;

  TfrmMagReportMgr = class(TForm)
    pnlReportStatus: TPanel;
    lbReportListTitle: TLabel;
    lvwRptStatus: TListView;
    PopupMenu1: TPopupMenu;
    popCancelReport: TMenuItem;
    popViewReport: TMenuItem;
    popRerunReport: TMenuItem;
    N1: TMenuItem;
    btnManualRefreshList: TBitBtn;
    MainMenu1: TMainMenu;
    mnuFile: TMenuItem;
    mnuHelp: TMenuItem;
    mnuFileExit: TMenuItem;
    mnuQAReportHelp: TMenuItem;
    pnlCriteriaSelection: TPanel;
    Label5: TLabel;
    btnRunReport: TBitBtn;
    cbxIncludeDeletedImages: TCheckBox;
    cbxIncludeExistingImages: TCheckBox;
    rgImageCountsBy: TRadioGroup;
    GroupBox1: TGroupBox;
    lbSelectedRange: TLabel;
    dtFrom: TDateTimePicker;
    dtTo: TDateTimePicker;
    Splitter1: TSplitter;
    mnuAction: TMenuItem;
    mnuViewReport: TMenuItem;
    mnuCancelReport: TMenuItem;
    mnuRerunReport: TMenuItem;
    StaticText1: TStaticText;
    StaticText2: TStaticText;
    mnuOptions: TMenuItem;
    mnuActiveForms: TMenuItem;
    mnuStayonTop: TMenuItem;
    lbDateConstraintMsg: TLabel;
    barStatus: TStatusBar;
    popDeleteReport: TMenuItem;
    tiRefresh: TTimer;
    mnuAutoRefreshList: TMenuItem;
    mnuDeleteReport: TMenuItem;
    ActionManager1: TActionManager;
    ActionRefreshList: TAction;
    mnuRefreshList: TMenuItem;
    N2: TMenuItem;
    ImageList1: TImageList;
    memSelSettings: TMemo;
    Label1: TLabel;
    btnViewReport: TBitBtn;
    N3: TMenuItem;
    RefreshList2: TMenuItem;
    lbRefeshPending: TLabel;
    N4: TMenuItem;
    N5: TMenuItem;
    lbRefreshSeconds: TLabel;
    lbrefreshLast: TLabel;
    procedure FormShow(Sender: TObject);
    procedure lvwRptStatusSelectItem(Sender: TObject; Item: TListItem;
      Selected: Boolean);
    procedure popViewReportClick(Sender: TObject);
    procedure popRerunReportClick(Sender: TObject);
    procedure popCancelReportClick(Sender: TObject);
    procedure lvwRptStatusDblClick(Sender: TObject);
    procedure btnRunReportClick(Sender: TObject);
    procedure lvwRptStatusColumnClick(Sender: TObject; Column: TListColumn);
    procedure lvwRptStatusClick(Sender: TObject);
    procedure PopupMenu1Popup(Sender: TObject);
    procedure FormCreate(Sender: TObject);
    procedure mnuViewReportClick(Sender: TObject);
    procedure mnuRerunReportClick(Sender: TObject);
    procedure mnuCancelReportClick(Sender: TObject);
    procedure FormKeyUp(Sender: TObject; var Key: Word; Shift: TShiftState);
    procedure mnuActionClick(Sender: TObject);
    procedure FormClose(Sender: TObject; var Action: TCloseAction);
    procedure FormDestroy(Sender: TObject);
    procedure mnuFileExitClick(Sender: TObject);
    procedure mnuQAReportHelpClick(Sender: TObject);
    procedure mnuActiveFormsClick(Sender: TObject);
    procedure mnuStayonTopClick(Sender: TObject);

    procedure RefreshList;
    procedure UpdateListView(ListData: String);
    function DecodeVistaDateTime(VistaDT: String): String;
    procedure popDeleteReportClick(Sender: TObject);
    procedure tiRefreshTimer(Sender: TObject);
    procedure dtFromChange(Sender: TObject);
    procedure dtToChange(Sender: TObject);
    procedure mnuDeleteReportClick(Sender: TObject);
    procedure dtFromCloseUp(Sender: TObject);
    procedure lvwRptStatusKeyUp(Sender: TObject; var Key: Word;
      Shift: TShiftState);
    procedure FormActivate(Sender: TObject);
    procedure FormPaint(Sender: TObject);
    procedure ActionRefreshListExecute(Sender: TObject);
//    procedure ActionCrossChckExecute(Sender: TObject);
    procedure Splitter1CanResize(Sender: TObject; var NewSize: Integer;
      var Accept: Boolean);
    procedure lvwRptStatusChanging(Sender: TObject; Item: TListItem;
      Change: TItemChange; var AllowChange: Boolean);
    procedure dtFromExit(Sender: TObject);
    procedure dtToExit(Sender: TObject);
    procedure btnViewReportClick(Sender: TObject);
    procedure RefreshList2Click(Sender: TObject);
    procedure mnuAutoRefreshListClick(Sender: TObject);
  private
  selectedFromDate,selectedToDate: TDate;
  selectedD,selectedE,selectedS,selectedU : boolean;
  
    FStartDate: String;
    FEndDate: String;
    FReportTitle: String;
    MaxDateRange: Integer;
    procedure CalcRange(CalcFor: TDateCalc);
    procedure ViewQAReport(LiData: String);
    function RunReport(RunType: TRunType): Boolean;
    function CancelReport(Li: TListItem): Boolean;
    procedure GetTaskmanList(DUZ: String; var TaskManList: TStringList);
    function Padd(Val: Word): String; overload;
    function Padd(Val: String): String; overload;
    procedure InitializeMaxDateRange;
    function GetDateRangeDesc(DtFrom, DtTo: String): String;
    procedure SetFlagControls(Flags: String);
    procedure FillCriteriaFromSelection;
    function isValidDate(strDT: String): boolean;
    procedure RefreshPopStatus;
    procedure ResetCriteria;
    Procedure WMGetMinMaxInfo(Var Message: TWMGetMinMaxInfo); Message WM_GetMinMaxInfo;
    function AreValidDates: boolean;
    function ValidFromDate: boolean;
    function ValidTODate: boolean;
    function CheckForSameReport(setFromDate,setToDate: TDate; setD,setE,setS,setU,SelectIfSame : boolean): integer;
    procedure ShowSelectedSettings;
    procedure ViewSelectedReport;
    procedure Winmsg(panel: integer; value: string);
    procedure ClearMsg;
    procedure EnableRefreshTimer(value: boolean);
    procedure SaveSelectedParameters;
    procedure RunSelectedReport;

    procedure SelectedReportReRun;
    procedure SelectedReportCancel;
  public
    procedure Execute(Caller: TComponent; ReportName: String; DateFrom, DateTo, Flags: String);
  end;

var
  frmMagReportMgr: TfrmMagReportMgr;
const
  sameReportNo = 0;
  sameReportReRun = 1;
  sameReportDontRun = 2;

implementation

{$R *.dfm}

uses
  MagPositions,
  uMagUtils8A;

var
  LastSortedColumn: integer;
  Ascending: boolean;
  TaskmanID: Integer;
  RefreshCount: Integer;
{/117 gek out T7.  we use the current selected entry now. and we always get last selected
        from the control, not global variable }

//  LastSelected: Integer;
  SuppressRefresh: Boolean;
  Shutdown: Boolean;

{/ JK 8/9/2010 - P117 - this execute method allows for pre-population of
   report criteria from the dtFrom, dtTo, and Flags params if they are present.
   Otherwise the user will select them when the screen is displayed. If the
   dtFrom, dtTo, and Flags fields are partially filled in then revert to the
   situation as if none of the params are present and require the user to select
   values on the form.

   IMPORTANT:  This form must be a singleton and also not auto-created in project options.
/}
procedure TfrmMagReportMgr.Execute(Caller: TComponent; ReportName: String; DateFrom, DateTo, Flags: String);
var
  AllParamsValid: Boolean;
begin
  AllParamsValid := True;
  Shutdown := False;

  if not isValidDate(DateFrom) then AllParamsValid := False;
  if not isValidDate(DateTo)   then AllParamsValid := False;
  if Flags = ''                then AllParamsValid := False;

  if not DoesFormExist('frmMagReportMgr') then
    Application.CreateForm(TfrmMagReportMgr, frmMagReportMgr);

  FormToNormalSize(frmMagReportMgr);

 with frmMagReportMgr do
  begin
    if AllParamsValid then {Populate the values}
    begin
      dtFrom.Date := StrToDate(DateFrom);
      dtTo.Date   := StrToDate(DateTo);
      SetFlagControls(Flags);
    end;

    {if the caller is the TfrmMagVerify form, turn off the "switch application"
     option since the caller is a modal form.}
    if Caller.Name = 'frmVerify' then
    begin
      mnuActiveForms.Visible := False;
      mnuActiveForms.ShortCut := ShortCut(0, []);
    end
    else
    begin
      mnuActiveForms.Visible := True;
      mnuActiveForms.ShortCut := ShortCut(Word('W'), [ssCtrl]);
    end;
    
    {Make the screen visible}
    Show;
  end;
end;

procedure TfrmMagReportMgr.FormCreate(Sender: TObject);
begin
  GetFormPosition(Self As TForm);
  {/p117t5 gek  do this once here, not every OnPaint.}
  pnlReportStatus.Color      := FSAppBackGroundColor;
  pnlCriteriaSelection.Color := FSAppBackGroundColor;
end;

procedure TfrmMagReportMgr.FormShow(Sender: TObject);
var
  ListItem: TListItem;
begin
  SuppressRefresh := True;

  InitializeMaxDateRange;

  LastSortedColumn             := -1;
  Ascending                    := True;

  dtFrom.Date                  := Today;
  dtTo.Date                    := Today;
  { //117 gek Radio button selection is required, -1 causes problems.}
  rgImageCountsBy.ItemIndex    := 1 ; //-1

  CalcRange(dcDateFrom);

  RefreshList;

  SuppressRefresh := False;

  {/ P117 - JK 11/2/2010 /}
  if lvwRptStatus.Items.Count > 0 then
  begin

    EnableRefreshTimer(False);
    lvwRptStatus.Selected := lvwRptStatus.Items[0];
    FillCriteriaFromSelection;
  end;

end;

procedure TfrmMagReportMgr.FormKeyUp(Sender: TObject; var Key: Word; Shift: TShiftState);
begin
  if Key = VK_F5 then
  begin
    EnableRefreshTimer(True);
  end;
end;

procedure TfrmMagReportMgr.FormPaint(Sender: TObject);
begin
  {/ P117 - JK 9/2/2010 - Force background color to be the P94 Scheme /}
  {/p117T5 gek  moved to OnCreate} 
  // pnlReportStatus.Color      := FSAppBackGroundColor;
   // pnlCriteriaSelection.Color := FSAppBackGroundColor;
end;

procedure TfrmMagReportMgr.FormActivate(Sender: TObject);
begin
{/p117 T5 gek. - this is not needed.   The selecting of last list item 
   isn't needed.  it is accomplished by the listView Property HideSelection = False.}
EXIT;

(*  if lvwRptStatus.CanFocus then
    lvwRptStatus.SetFocus;

  if (lvwRptStatus.Items.Count > 0) and (LastSelected >= 0) then
  begin
    //gek b6    lvwRptStatus.Selected := lvwRptStatus.Items[LastSelected];
  end
  else
  begin
    LastSelected := -1;
    if dtFrom.CanFocus then
      dtFrom.SetFocus;
  end;
*)
end;

procedure TfrmMagReportMgr.FormClose(Sender: TObject; var Action: TCloseAction);
begin

  EnableRefreshTimer(False);
  Shutdown := True;
  Action := caFree;
end;

procedure TfrmMagReportMgr.FormDestroy(Sender: TObject);
begin
  SaveFormPosition(Self as TForm);
end;

function TfrmMagReportMgr.GetDateRangeDesc(Dtfrom, DtTo: String): String;
var
  DF, DT: String;
begin
  if DtFrom = '' then
    DF := '-------'
  else
    DF := DtFrom;

  if DtTo = '' then
    DT := '-------'
  else
    DT := DtTo;

  Result := 'From: ' + DF + ' thru ' + DT;
end;

procedure TfrmMagReportMgr.InitializeMaxDateRange;
Var
  Datefrom, DateTo, dtINIrange: String;
Begin
  dtINIRange := GetIniEntry('Workstation Settings', 'MaximumQADateRange');

  If dtINIRange = '' then
    dtINIRange := '0';  {/ JK 8/4/2010 - P117 - if the ini setting is null, then the range is unlimited. Use 0 to denote this /}

  try
    MaxDateRange := StrToInt(dtINIRange);
  except
    On E:Exception do
      MaxDateRange := 90;  {/ JK 8/4/2010 - P117 - Change default from 7 to 90 days /}
  end;

  DateFrom := FormatDateTime('mm/dd/yyyy', Now);

  {If the date constraint = 0 then there is no constraint.  If the constraint is not zero, then take today's
   date and subtract the constraint in number of days.}
  if MaxDateRange = 0 then
  begin
    dtFrom.Date := dtTo.Date;
    lbDateConstraintMsg.Caption := 'Maximum Range: Unlimited';
    lbDateConstraintMsg.Visible := False;
  end
  else
  begin
    dtFrom.Date := dtTo.Date - maxDateRange;
    lbDateConstraintMsg.Caption := 'Maximum Range: ' + IntToStr(MaxDateRange) + ' days';
    lbDateConstraintMsg.Visible := True;
  end;

end;

procedure TfrmMagReportMgr.lvwRptStatusSelectItem(Sender: TObject; Item: TListItem; Selected: Boolean);
var
 LastSelected: Integer;
begin

  ClearMsg;
  btnViewReport.Enabled := false;
  memSelSettings.Clear;
  memSelSettings.Lines.Add('<no selection>');

  if Selected then
  begin
    ShowSelectedSettings;
    LastSelected := lvwRptStatus.ItemIndex;
    if Item.SubItems[0] = 'Completed' then
      begin
      btnViewReport.Enabled := true;
      end;
{/p117t5 gek  We dont' need to enable/disable menu items, until the user
    activates the menu item.}
  end;
end;

{ * ******   ShowSelectedSettings ***** }
{p117t5 gek  :  Now we show the parameter of the report, (the other data that
   isn't shown in the List, below the list.  This way we don't have to sycn
   with the controls on the left (data input) panel. }

procedure TfrmMagREportMgr.ShowSelectedSettings;
var  siSt,siFr, siTo,lidatastr : string;
 i : integer;
  LastSelected: Integer;
begin
  LastSelected := lvwRptStatus.ItemIndex;
  memSelSettings.Clear;
  if LastSelected = -1 then exit;

siSt :=       lvwRptStatus.Items[LastSelected].SubItems[3];
siFr:=       lvwRptStatus.Items[LastSelected].SubItems[1];
siTo:=       lvwRptStatus.Items[LastSelected].SubItems[2];
liDataStr := (TListData(lvwRptStatus.Items[LastSelected].Data).ReportData)   ;
liDataStr := uppercase(liDataStr);


    //memSelSettings.lines.Add('This Report Was Started At:  ' + siSt );
    memSelSettings.lines.Add('From :  ' + siFr);
    memSelSettings.lines.Add('   To :  ' + siTo );
    //memSelSettings.lines.Add('Range: ' +  FormatDateRange(StrToDate(siFr), StrToDate(siTo)));

    //if C then FlagDesc.Add('Capture date range');
    memSelSettings.lines.Add('  ');
    if pos('D',liDataStr)>0 then memSelSettings.lines.Add('Include Deleted images');
    if pos('E',liDataStr)>0 then memSelSettings.lines.Add('Include Existing images');
    if pos('S',liDataStr)>0 then memSelSettings.lines.Add('Grouped by Status');
    if pos('U',liDataStr)>0 then memSelSettings.lines.Add('Gouped by Users and Status');

self.lvwRptStatus.Hint := self.memSelSettings.Text;

end;



procedure TfrmMagReportMgr.popViewReportClick(Sender: TObject);
begin
 // get code out of Click Event.  So it's callable by others.
  ViewSelectedReport;
end;


procedure TfrmMagReportMgr.mnuViewReportClick(Sender: TObject);
begin
   ViewSelectedReport;
end;

procedure TfrmMagReportMgr.ViewQAReport(LiData: String);
var
  frmVerifyStats: TfrmVerifyStats;
  ReportFlags: String;
  ListItem: TListItem;
  FStat: Boolean;
  FMsg: String;
  FList: TStringList;
  InputParams: TStringList;
  FilemanDate: String;
  Flags: String;
  Idx: Integer;
  LastSelected: Integer;
begin
  lastSelected := lvwRptStatus.ItemIndex;   //gek 117 T5 b6
  if lastSelected = -1 then
    begin
      { instead of selecting a default of first report in list. We inform user
        that they need to make a selection.}
      messagedlg('Select a Report from the list.',mtconfirmation, [mbok],0);
      exit;
    end;
  {Get the data by calling QUEUE on a finished report returns the report data}

  InputParams := TStringList.Create;
  FList       := TStringList.Create;

  try
    InputParams.Add(MagPiece(LiData, '^', 1)); //Flags
    InputParams.Add(MagPiece(LiData, '^', 2)); //Period Start
    InputParams.Add(MagPiece(LiData, '^', 3)); //Period End

    {Add the MQUE information}
    InputParams.Add('Q');

    Dmod.MagDBBroker1.RPMagImageStatisticsQue(FStat, FMsg, FList, InputParams);

    ReportFlags := LiData;

    frmVerifyStats.Execute(
       lvwRptStatus.Items[LastSelected].SubItems[3],
       lvwRptStatus.Items[LastSelected].SubItems[1],
       lvwRptStatus.Items[LastSelected].SubItems[2],
       ReportFlags,
       FList);

  finally
    frmVerifyStats.Free;
    InputParams.Free;
    FList.Free;
  end;
end;

function TfrmMagReportMgr.isValidDate(strDT: String): boolean;
var
  dt: TDate;
begin
  Result := True;
  try
    dt := StrToDate(strDT);
  except
    Result := False;
  end;
end;

procedure TfrmMagReportMgr.mnuFileExitClick(Sender: TObject);
begin
  Close;
end;

procedure TfrmMagReportMgr.popRerunReportClick(Sender: TObject);
begin
 // get code out of Click Event.  So it's callable by others.
  SelectedReportReRun;
end;

procedure TfrmMagReportMgr.SelectedReportReRun;
var  LastSelected: Integer;
begin
  lastSelected := lvwRptStatus.ItemIndex;   //gek 117 T5 b6
  if lastSelected = -1 then
    begin
      messagedlg('Select a Report from the list.',mtconfirmation, [mbok],0);
      exit;
    end;
  SuppressRefresh := true ;  //gek. stop refresh if going on now.  Enable after ReRun.

  if lvwRptStatus.Items[LastSelected] <> nil then
    RunReport(rtReRun);
    //P117T5  gek  Finding :  No exception handling.  what is intended if result is false ?
  SuppressRefresh := False;
  RefreshCount := 0;

  EnableRefreshTimer(True);
end;

procedure TfrmMagReportMgr.mnuRerunReportClick(Sender: TObject);
begin
   SelectedReportReRun;
end;

procedure TfrmMagReportMgr.popCancelReportClick(Sender: TObject);
begin
 // get code out of Click Event.  So it's callable by others.
  SelectedReportCancel;
end;

procedure TfrmMagReportMgr.SelectedReportCancel;
var  LastSelected: Integer;
begin
  lastSelected := lvwRptStatus.ItemIndex;   //gek 117 T5 b6
  if lastSelected = -1 then
    begin
      messagedlg('Select a Report from the list.',mtconfirmation, [mbok],0);
      exit;
    end;
  SuppressRefresh := False;
  if lvwRptStatus.Items[LastSelected] <> nil then
  begin
    if CancelReport(lvwRptStatus.Items[LastSelected]) then
    begin
      lvwRptStatus.Items[LastSelected].SubItems[0] := 'Cancelled';
      lvwRptStatus.Items[LastSelected].SubItems[3] := FormatDateTime('mm/dd/yyyy hh:mm AM/PM', Now);

      popViewReport.Enabled := False;
      popReRunReport.Enabled := True;
      popCancelReport.Enabled := False;
    end
    else
      MessageDlg('Could not cancel the report', mtError, [mbOK], 0);
  end;

  RefreshCount := 0;

 EnableRefreshTimer(True);

  ResetCriteria;

end;

procedure TfrmMagReportMgr.ResetCriteria;
begin
EXIT ; //p117 T5 gek.  no longer implement this synchronizing between Controls and List.
  {/ P117 - JK 11/4/2010 - When deleting, reset the criteria to nothing /}
//  cbxIncludeDeletedImages.Checked  := False;
//  cbxIncludeExistingImages.Checked := True; //false //117 t5 gek  lets not leave blank.   Existing is used 99.99 % of time
//  rgImageCountsBy.ItemIndex        := 1;     //117gek Radio button is required -1 causes problems. //-1
//  dtFrom.Date                      := Today;
//  dtTo.Date                        := Today;
//  lbSelectedRange.Caption          := 'Range: ' + FormatDateRange(dtFrom.Date, dtTo.Date);
//  btnRunReport.Caption             := 'Run Report';
//  LastSelected                     := -1;
end;

procedure TfrmMagReportMgr.popDeleteReportClick(Sender: TObject);
begin
    SelectedReportCancel;
end;

procedure TfrmMagReportMgr.mnuCancelReportClick(Sender: TObject);
begin
   SelectedReportCancel;
end;

procedure TfrmMagReportMgr.mnuDeleteReportClick(Sender: TObject);
begin
  SelectedReportCancel;
end;

procedure TfrmMagReportMgr.GetTaskmanList(DUZ: String; var TaskManList: TStringList);
var
  FStat: Boolean;
  FMsg: String;
  FList: TStringList;
begin
  FList := TStringList.Create;
  try
    Dmod.MagDBBroker1.RPMagImageStatisticsByUser(FStat, FMsg, TaskManList, DUZ);
  finally
    FList.Free;
  end;

end;

function TfrmMagReportMgr.RunReport(RunType: TRunType): Boolean;
var
  ListItem: TListItem;
  FStat: Boolean;
  FMsg: String;
  FList: TStringList;
  InputParams: TStringList;
  FilemanDate: String;
  Flags: String;
  DataParams: String;
  LastSelected: Integer;
begin
  Result := False;
  If NOT  AreValidDates()  then Exit;
  {Valid Fileman date format is: That format is "YYYDDMM.HHMMSS" where YYY is the number of years since 1700. }

  InputParams := TStringList.Create;
  FList       := TStringList.Create;
  try

    case RunType of
      rtNew:
        begin
          {Add the FLAGS}
          Flags := 'C';
          if cbxIncludeDeletedImages.Checked then
            Flags := Flags + 'D';
          if cbxIncludeExistingImages.Checked then
            Flags := Flags + 'E';
          case rgImageCountsBy.ItemIndex of
            0: Flags := Flags + 'S';
            1: Flags := Flags + 'U';
          end;

          InputParams.Add(Flags);

          {Add the "FROM" date in Fileman format}
          FileManDate := IntToStr((YearOf(dtFrom.Date) - 1700)) +
                         Padd(MonthOf(dtFrom.Date)) +
                         Padd(DayOf(dtFrom.Date));
          InputParams.Add(FileManDate);

          {Add the "TO" date in Fileman format}
          FileManDate := IntToStr((YearOf(dtTo.Date) - 1700)) +
                         Padd(MonthOf(dtTo.Date)) +
                         Padd(DayOf(dtTo.Date));
          InputParams.Add(FileManDate);

          {Add the MQUE information}
          InputParams.Add('Q');
        end;

      rtReRun:
        begin
        lastSelected := lvwRptStatus.ItemIndex;   //gek 117 T5 b6
        if lastSelected = -1 then
          begin
            { instead of selecting a default of first report in list. We inform user
              that they need to make a selection.}
            messagedlg('Select a Report from the list.',mtconfirmation, [mbok],0);
            exit;
          end;
          if LastSelected <> -1 then
          begin
            DataParams := TListData(lvwRptStatus.Items[LastSelected].Data).ReportData;
            InputParams.Add(MagPiece(DataParams, '^', 1));  //Flags
            InputParams.Add(MagPiece(DataParams, '^', 2));  //Period Start
            InputParams.Add(MagPiece(DataParams, '^', 3));  //Period End

            {Add the MQUE information}
            InputParams.Add('R');
            {Mehul - add AutoRefresh on Re-Run -  gek refresh on rerun}
            RefreshCount := 0;           //new line - gek refresh on rerun
            SuppressRefresh := False;

            EnableRefreshTimer(True);   //new line - gek refresh on rerun
          end;
        end;
    end;

    Dmod.MagDBBroker1.RPMagImageStatisticsQue(FStat, FMsg, FList, InputParams);

    if FMsg = 'In Progress' then
      MessageDlg('The job you requested is already queued and is being processed',
        mtInformation, [mbOK], 0);

    Result := FStat;

  finally
    InputParams.Free;
    FList.Free;
  end;
end;

procedure TfrmMagReportMgr.tiRefreshTimer(Sender: TObject);
var secstoupd,isec : integer;
    secdesc : string;
    dorefresh : boolean;
begin
//this test of suppressrefresh was here.  //Gek: 117T5 Added EnableRefreshTimer(T/F) to handle Displaying Refresh info.
dorefresh := false;
secdesc := ' seconds.';
if not mnuAutoRefreshlist.Checked then
  begin
    {if not autorefreshlist, then just do it once and quit.}
    RefreshList;
     EnableRefreshTimer(False);
    exit;
  end;

  if suppressrefresh then
      begin
      EnableRefreshTimer(False);
      EXIT;
      end;


  // ?? do we want to disabale the ListView while we are 'auto-refreshing'  gek ?
  //  we are NOT disabling the list view at this time. /gek
  lbRefeshPending.Visible := true;
  winmsg(2,lbRefeshPending.caption);

  Inc(RefreshCount);
if mnuAutoRefreshList.Checked then
  begin
  if refreshcount < 11
    then secstoupd := refreshcount mod 2
    else
       begin
       if (refreshcount mod 30) = 0 then  secstoupd := 0
       else secstoupd := 30 -(refreshcount mod 30);
       end;
  end;
if secstoupd = 1 then secdesc := ' second.';
if secstoupd = 0 then dorefresh := true;

if dorefresh 
      then self.lbrefreshseconds.caption := 'Updating now.'
      else self.lbRefreshSeconds.Caption := 'Updating in ' + inttostr(secstoupd) + secdesc;

if dorefresh  then
  begin
  RefreshList;
  //winmsg(0,'updated '); // testing,
  end;

IF  NOT mnuAutoRefreshList.Checked THEN  EnableRefreshTimer(False);

end;

function TfrmMagReportMgr.CancelReport(Li: TListItem): Boolean;
var
  ListItem: TListItem;
  FStat: Boolean;
  FMsg: String;
  FList: TStringList;
  InputParams: TStringList;
  FilemanDate: String;
  DataParams: String;
begin
  Result      := False;

  InputParams := TStringList.Create;
  FList       := TStringList.Create;
  try


    DataParams := TListData(Li.Data).ReportData;
    {Add the FLAGS}
    InputParams.Add(MagPiece(DataParams, '^', 1));
    {Add the Period Start Date}
    InputParams.Add(MagPiece(DataParams, '^', 2));
    {Add the Period End Date}
    InputParams.Add(MagPiece(DataParams, '^', 3));
    {Add the MQUE information}
    InputParams.Add('D');

    Dmod.MagDBBroker1.RPMagImageStatisticsQue(FStat, FMsg, FList, InputParams);
 // out !  lvwRptStatus.Items[LastSelected].SubItems[0] := FMsg;
 // The function input parameter is using  (Li : Tlistitem ) as the report to cancel.  We need to use
 //   that same Li when setting subitems[0].
   Li.SubItems[0] := FMsg;   //[BREAK]

    Result := FStat;

  finally
    InputParams.Free;
    FList.Free;
  end;
end;

function TfrmMagReportMgr.Padd(Val: Word): String;
begin
  try
    if Val = 0 then
      Result := '00'
    else if Val < 10 then
      Result := '0' + IntToStr(Val)
    else
      Result := IntToStr(Val);
  except
    Result := '00';
  end;
end;

function TfrmMagReportMgr.Padd(Val: String): String;
var
  tmpVal: String;

  function IsANumber(S: String): Boolean;
  var
    IntVal: Integer;
  begin
    try
      IntVal := StrToInt(S);
      Result := True;
    except
      Result := False;
    end;
  end;
  
begin
  tmpVal := Trim(Val);

  if IsANumber(tmpVal) then
  begin
    if Length(tmpVal) = 1 then
      Result := '0' + Val
    else
      Result := tmpVal;
  end
  else
    Result := Val;
end;

procedure TfrmMagReportMgr.mnuStayonTopClick(Sender: TObject);
begin
  If mnuStayOnTop.Checked Then
    Self.Formstyle := FsStayOnTop
  Else
    Self.Formstyle := FsNormal;
end;

procedure TfrmMagReportMgr.lvwRptStatusChanging(Sender: TObject;
  Item: TListItem; Change: TItemChange; var AllowChange: Boolean);
begin
//BUG4  if not Shutdown then
//BUG4    FillCriteriaFromSelection;
end;

procedure TfrmMagReportMgr.lvwRptStatusClick(Sender: TObject);
begin
//BUG4  FillCriteriaFromSelection;
end;

procedure TfrmMagReportMgr.FillCriteriaFromSelection;
var
  FromDate, ToDate: String;
  Flags: String;
begin
  {/p117 t5  gek. break the automatic setting of values between list and panel controls}
EXIT;

(*  if lvwRptStatus.Items[LastSelected] <> nil then
  begin
    if lvwRptStatus.Selected <> nil then
    begin
      if lvwRptStatus.Selected.Caption = 'QA STATS' then
      begin
        FromDate := lvwRptStatus.Items[LastSelected].SubItems[1];
        ToDate   := lvwRptStatus.Items[LastSelected].SubItems[2];
        try
          dtFrom.Date := StrToDate(FromDate);
          dtTo.Date   := StrToDate(ToDate);
          CalcRange(dcSpan);
        except
          dtFrom.Date := Today;
          dtTo.Date   := Today;
          lbSelectedRange.Caption := 'Range: ' + FormatDateRange(dtFrom.Date, dtTo.Date);
        end;

        {Use the values from Taskman to set the values in the report criteria section}
        {Add the FLAGS}
        //barStatus.Panels[0].Text := IntToStr(LastSelected);
        Flags := '';
        try
          if LastSelected >= 0 then
            Flags := MagPiece(TListData(lvwRptStatus.Items[LastSelected].Data).ReportData, '^', 1);

          SetFlagControls(Flags);
        except
          on E:Exception do
          begin

            EnableRefreshTimer(False);
            ResetCriteria;
          end;
        end;
      end;
    end;
  end;
*)
end;

procedure TfrmMagReportMgr.SetFlagControls(Flags: String);
var
  C,D,E,S,U: Boolean;
begin
  if Flags = '' then
  begin
    cbxIncludeDeletedImages.Checked  := False;
    cbxIncludeExistingImages.Checked := True; //false //117 t5 gek  lets not leave blank.   Existing is used 99.99 % of time
    rgImageCountsBy.ItemIndex        := 1;     //117gek Radio button is required -1 causes problems. //-1
  end
  else
  begin
    C := Pos('C', Flags) > 0; {C = Capture Date Range}
    D := Pos('D', Flags) > 0; {D = Include deleted images}
    E := Pos('E', Flags) > 0; {E = Include existing images}
    S := Pos('S', Flags) > 0; {S = Return image counts grouped by status}
    U := Pos('U', Flags) > 0; {U = Return image counts grouped by users and status}

    {/p117 T5 Gek,  don't allow both to be false (unchecked.)}
    if (D = False) and (E = False)  then E := true;
    

    cbxIncludeDeletedImages.Checked  := D;
    cbxIncludeExistingImages.Checked := E;

    if S then
      rgImageCountsBy.ItemIndex := 0
    else
      rgImageCountsBy.ItemIndex := 1;

    if U then
      rgImageCountsBy.ItemIndex := 1
    else
      rgImageCountsBy.ItemIndex := 0;
  end;
end;

procedure TfrmMagReportMgr.Splitter1CanResize(Sender: TObject;
  var NewSize: Integer; var Accept: Boolean);
begin
accept := false;  // no need to resize 

  if NewSize <= 100 then
    Accept := False;
  if NewSize >= Self.Width - 100 then
    Accept := False;
end;

procedure TfrmMagReportMgr.lvwRptStatusColumnClick(Sender: TObject; Column: TListColumn);
  function SortByColumn(Item1, Item2: TListItem; Data: integer): integer; stdcall;
  var
    I1, I2: String;
  begin
    if Data = 0 then
      Result := AnsiCompareText(Item1.Caption, Item2.Caption)

    else if (Data = 2) or (Data = 4) then
    begin
      I1 := Item1.SubItems[Data-1];
      if I1 = '' then
        I1 := '0';
      I2 := Item2.SubItems[Data-1];
      if I2 = '' then
        I2 := '0';

      Result := AnsiCompareText(FloatToStr(DateTimeToJulianDate(StrToDateTime(I1))),
                                FloatToStr(DateTimeToJulianDate(StrToDateTime(I2))))
    end

    else
      Result := AnsiCompareText(Item1.SubItems[Data-1],
                                Item2.SubItems[Data-1]);
    if not Ascending then
      Result := -Result;
  end;
begin
    if Column.Index = LastSortedColumn then
      Ascending := not Ascending
    else 
      LastSortedColumn := Column.Index; 
    TListView(Sender).CustomSort(@SortByColumn, Column.Index);

end;

procedure TfrmMagReportMgr.lvwRptStatusDblClick(Sender: TObject);
begin
  ViewSelectedReport;
end;


{create a procedure to call.  get code out of 'Click' event.}
procedure TfrmMagReportMgr.ViewSelectedReport;
var
 LastSelected: Integer;
begin
  lastSelected := lvwRptStatus.ItemIndex;   //gek 117 T5 b6
  ClearMsg;
  if lastselected = -1 then
    begin
      { instead of selecting a default of first report in list. We inform user
        that they need to make a selection.}
      messagedlg('Select a Report from the list.',mtconfirmation, [mbok],0);
      exit;
    end;

  if lvwRptStatus.Items[LastSelected] <> nil then
    begin
      if lvwRptStatus.Items[LastSelected].Caption = 'QA STATS' then
      begin
      (*  this line was in other call merged with this one.
    if TListData(lvwRptStatus.Items[LastSelected].Data).ReportData = '' then
      MessageDlg('Select a report by clicking on it', mtInformation, [mbOK], 0)
      *)
        if lvwRptStatus.Items[LastSelected].SubItems[0] = 'Completed' then
          ViewQAReport(TListData(lvwRptStatus.Items[LastSelected].Data).ReportData)

        else if lvwRptStatus.Items[LastSelected].SubItems[0] = 'Cancelled' then
          Showmessage('The report has been Cancelled.')

        else if lvwRptStatus.Items[LastSelected].SubItems[0] = 'Running' then
          Showmessage('The report is being prepared. Please check back later.');
      end;
    end;
end;




procedure TfrmMagReportMgr.lvwRptStatusKeyUp(Sender: TObject; var Key: Word;  Shift: TShiftState);
var
 LastSelected: Integer;
begin
  SuppressRefresh := True;


  if Key = VK_Return Then
  begin
    LastSelected := lvwRptStatus.ItemIndex;
    if LastSelected > -1 then
    begin
        if lvwRptStatus.Items[LastSelected].SubItems[0] = 'Completed' then
          ViewQAReport(TListData(lvwRptStatus.Items[LastSelected].Data).ReportData);
    end;
  end;

end;

procedure TfrmMagReportMgr.mnuActionClick(Sender: TObject);
var
 LastSelected: Integer;
begin
//  RefreshPopStatus;  // gek out,  no need to refresh popup menu items .
  LastSelected := lvwRptStatus.ItemIndex;

//Disable all, then enable depending on status of selected item.
      mnuViewReport.Enabled   := false;
      mnuReRunReport.Enabled  := false;
      mnuCancelReport.Enabled := false;
      mnuDeleteReport.Enabled := false;
if lastselected = -1  then exit;


    if lvwRptStatus.Items[lastselected].SubItems[0] = 'Completed' then
    begin
      mnuViewReport.Enabled   := True;
      mnuReRunReport.Enabled  := True;
      mnuDeleteReport.Enabled := True;
    end;

    if lvwRptStatus.Items[lastselected].SubItems[0] = 'Cancelled' then
    begin
      mnuReRunReport.Enabled  := True;
      mnuDeleteReport.Enabled := True;
    end;

    if lvwRptStatus.Items[lastselected].SubItems[0] = 'Running'  then
    begin
      mnuCancelReport.Enabled := True;
    end;
end;


procedure TfrmMagReportMgr.mnuActiveFormsClick(Sender: TObject);
begin
  SwitchToForm;
end;

procedure TfrmMagReportMgr.mnuAutoRefreshListClick(Sender: TObject);
begin
 RefreshCount := 0;
 EnableRefreshTimer(mnuAutoRefreshList.Checked); 

end;


    { ****   SaveSelectedParameters *******}
    {   We call this to save the info of the selected report item,  then after refresh, we use 
       the saved data to compare and Reselect the same report.}
procedure TfrmMagReportMgr.SaveSelectedParameters;
var liFlags : string;
i : integer;
begin
 i := lvwRptStatus.ItemIndex;
 if i = -1  then
   begin
   selectedFromDate := strtodate('1/1/1901');
   selectedToDate := strtodate('1/1/1901');
   exit;
   end;
        liFlags     := MagPiece(TListData(lvwRptStatus.Items[i].Data).ReportData, '^', 1);
        selectedFromDate  := strtodate(DecodeVistaDateTime(MagPiece(TListData(lvwRptStatus.Items[i].Data).ReportData, '^', 2)));
        selectedToDate    := strtodate(DecodeVistaDateTime(MagPiece(TListData(lvwRptStatus.Items[i].Data).ReportData, '^', 3)));

        selectedD := Pos('D', liFlags) > 0; {D = Include deleted images}
        selectedE := Pos('E', liFlags) > 0; {E = Include existing images}
        selectedS := Pos('S', liFlags) > 0; {S = Return image counts grouped by status}
        selectedU := Pos('U', liFlags) > 0; {U = Return image counts grouped by users and status}
end;

 {/p117 gek.  this copied from  ActionCrossCheck:   Jerrys' function .}
 {/p117 T5,   Bug4- ActionCrossCheck won't be called every time a change is made
             to panel settings.
             This New function CheckForSameReport will be called.
              only when 'Run Report is clicked'  This will stop the awkwardness.}
Function TfrmMagReportMgr.CheckForSameReport(setFromDate,setToDate: TDate; setD,setE,setS,setU,SelectIfSame : boolean) : integer;
var

  //setFromDate, setToDate : Tdate;
  //setD,setE,setS,setU : boolean;

  i: Integer;
  rptItem : integer;
  samemsg : string;

  liFlags,
  liDateFrom, liDateTo: String;
  liD, liE, liS, liU: Boolean;

  MatchFound: Boolean;
begin
{     sameReportNO = 0;
      sameReportReRun = 1;
      sameReportDontRun = 2;}
result := sameReportNo;
rptItem := -1;
  try
   (* now sent as parameters.
    setFromDate := dtFrom.Date;
    setToDate   := dtTo.Date;
    setD := cbxIncludeDeletedImages.Checked;
    setE := cbxIncludeExistingImages.Checked;

    setS := false;
    setU := false;
    if rgImageCountsBy.ItemIndex = 0 then
      setS := true
    else if rgImageCountsBy.ItemIndex = 1 then
      setU := true;
   *)
    for i := 0 to lvwRptStatus.Items.Count - 1 do
    begin
      liFlags    := '';
      liDateFrom := '';
      liDateTo   := '';
      liD           := False;
      liE           := False;
      liS           := False;
      liU           := False;

      if lvwRptStatus.Items[i].Data <> nil then
      begin
        liFlags     := MagPiece(TListData(lvwRptStatus.Items[i].Data).ReportData, '^', 1);
        liDateFrom  := DecodeVistaDateTime(MagPiece(TListData(lvwRptStatus.Items[i].Data).ReportData, '^', 2));
        liDateTo    := DecodeVistaDateTime(MagPiece(TListData(lvwRptStatus.Items[i].Data).ReportData, '^', 3));

        liD := Pos('D', liFlags) > 0; {D = Include deleted images}
        liE := Pos('E', liFlags) > 0; {E = Include existing images}
        liS := Pos('S', liFlags) > 0; {S = Return image counts grouped by status}
        liU := Pos('U', liFlags) > 0; {U = Return image counts grouped by users and status}

        {Now that I have the Taskman line broken down, compare these values to the
         values currently selected in the criteria panel. }

        MatchFound := True;
{/p117 gek  rewrite the compare of user settings to each list item
       first we assuem Matchfound, then if any difference we say MatchFound False
         logic is same,  code is changed}

        if (CompareDate(StrToDate(liDateFrom), setFromDate) <> 0)
             or
          (CompareDate(StrToDate(liDateTo), setToDate) <> 0)
          then  MatchFound := False;

        if  ((liD <> setD) or (liE <> setE) or (liU <> setU) or (liS <> setS))
            then  MatchFound := False;

      end
      else
      begin
        matchfound := false;
      end;

        if MatchFound then
           begin
            rptItem := i;
            if SelectIfSame then  lvwRptStatus.itemindex := rptItem;
            break;
           end;

    end;

   if rptItem = -1  then exit;  {no match was found, exit}

   {we're here, so match was found.  Ask to Re-Run, or Cancel.}
   {/p117 T5,   Bug4- Now  only called when 'Run Report is clicked'.
    Open dialog box and ask to 'Re-Run report or Cancel Report.  Stop Renaming the Button. and changing button function.}
    lvwRptStatus.Selected := lvwRptStatus.Items[rptItem];
    samemsg := 'The selected settings match an existing Report.' + #13  + 'Do you want to Re-Run the Report ?' ;
   if not SelectIfSame then
       if messagedlg(samemsg,mtconfirmation,[mbok,mbcancel],0) = mrok
          then result :=   sameReportReRun
          else result :=   sameReportDontRun;



  except
    on E:Exception do
      MagLogger.Log(Error, 'TfrmMagReportMgr.CheckForSameReport: ' + E.Message);
  end;

end;





procedure TfrmMagReportMgr.EnableRefreshTimer(value : boolean);
begin
  tiRefresh.Enabled :=  value;
  lbRefeshPending.Visible := value;
self.lbRefreshSeconds.visible := value;
self.lbrefreshLast.Visible := value;
  if value then winmsg(2,lbRefeshPending.caption);

 // This is in, then out, then in , ...  for now.  T5 + AutoRefresh, we'll take it out to NOT disable the list.
 //self.lvwRptStatus.Enabled := not value;



end;

procedure TfrmMagReportMgr.ActionRefreshListExecute(Sender: TObject);

begin
  RefreshList;
  // gek b6 if (LastSelected = -1) and (lvwRptStatus.Items.Count >= 1) then
 //gek b6   LastSelected := 0;
 //gek b6 lvwRptStatus.Selected := lvwRptStatus.Items[LastSelected];
end;

procedure TfrmMagReportMgr.RefreshList;
var
  TaskmanList: TStringList;
  UserDUZ: String;
  i: Integer;
  UserName: String;
  MyListData: TListData;
  refreshtime : string;
  areAllComplete , wasSelected: boolean;
  jobended : string;
begin
areAllComplete := true;
  ClearMsg;
  lbRefeshPending.Visible :=true;
self.lbRefreshSeconds.visible := true;
self.lbrefreshLast.Visible := true;
  lbRefeshPending.Update;
  winmsg(2,lbRefeshPending.caption);


  lvwRptStatus.Items.BeginUpdate;
  wasSelected := (lvwRptStatus.ItemIndex <> -1);
  self.SaveSelectedParameters;

  try


    {Delete the data objects to avoid a memory leak}
    for i := 0 to lvwRptStatus.Items.Count - 1 do
      if lvwRptStatus.Items[i].Data <> nil then
      begin
        MyListData := lvwRptStatus.Items[i].Data;
        MyListData.Free;
      end;

    lvwRptStatus.Items.Clear;

    UserDUZ         := Dmod.MagDBBroker1.GetBroker.User.Duz;
    TaskmanList     := TStringList.Create;
    try
      {Get the list of tasked jobs based on the User's DUZ}
      GetTaskmanList(UserDUZ, TaskmanList);

      UserName := Dmod.MagDBBroker1.GetBroker.User.Name;
      lbReportListTitle.Caption := 'Report Requests for User: ' + UserName;

      if TaskmanList.Count > 0 then
      begin
        if MagPiece(TaskmanList[0],'^',1) <> '1'  then
        begin
          MessageDlg('Cannot retrieve job status for user: ' + UserName, mtWarning, [mbOK], 0);
        end
        else
        begin
          for i := 1 to TaskmanList.Count - 1 do
            begin
            UpdateListView(TaskmanList[i]);
            jobended := MagPiece(TaskmanList[i], '^', 5);
            if jobended = '' then  
               begin
                 areallcomplete := false;
               end;
            end;
        end;
      end
      else
      begin
        MessageDlg('There are no jobs to display for user: ' + UserName, mtInformation, [mbOK], 0);
      end;

    finally
      TaskmanList.Free;

      if lvwRptStatus.Items.Count = 1 then
        winmsg(1,' ' + IntToStr(lvwRptStatus.Items.Count) + ' report request in list')
      else
        winmsg(1,' ' + IntToStr(lvwRptStatus.Items.Count) + ' report requests in list');

    end;

  finally
    if wasSelected then
      begin
      self.CheckForSameReport(selectedFromDate,selectedToDate,selectedD,selectedE,selectedS,selectedU,true);

      end;
    
    lvwRptStatus.Items.EndUpdate;

    {/Note : gek .  It looks like this is the only reason the 'LastSelected' variable
      is used.  To select the same item, after a refresh... but if new list has more entries,
      this could select a differnet item}

      { TODO : change this. No need for LastSelected.  Change to Save the Selected Settings to
          to a Temp.  When list is refreshed, Find the settings in the list, (like we do in  CheckForSameReport)
          and select that.}
 ////    lvwRptStatus.Selected := lvwRptStatus.Items[LastSelected];
    if not tiRefresh.Enabled then
    begin
     lbRefeshPending.Visible := false;
self.lbRefreshSeconds.visible := false;
self.lbrefreshLast.Visible := false;
    end;
  refreshtime :=  'Last Refresh: ' +  formatdatetime('hh:nn:ss',now);
  winmsg(2,refreshtime);
  self.lbrefreshLast.Caption := refreshtime;
  if areallcomplete then self.EnableRefreshTimer(false);

//bug4       ActionCrossCheckExecute(Self);
  end;

end;

procedure TfrmMagReportMgr.RefreshList2Click(Sender: TObject);
begin
  RefreshList;
end;

procedure TfrmMagReportMgr.UpdateListView(ListData: String);
var
  Flags: String;
  DateFrom, DateTo, DateJobStarted, DateJobEnded: String;
  RunStatus: String;
  ListItem: TListItem;
  DataParams: String;
  MyListData: TListData;
begin

  Flags          := MagPiece(ListData, '^', 1);
  DateFrom       := DecodeVistaDateTime(MagPiece(ListData, '^', 2));
  DateTo         := DecodeVistaDateTime(MagPiece(ListData, '^', 3));
  DateJobStarted := DecodeVistaDateTime(MagPiece(ListData, '^', 4));
  DateJobEnded   := DecodeVistaDateTime(MagPiece(ListData, '^', 5));

 (* if DateJobEnded <> '' then
    RunStatus := 'Completed'
  else if DateJobEnded = '' then
    RunStatus := 'Running'
  else
    RunStatus := 'Unknown';
    *)

{/p117 t5+ gek  fix the disappearing Report item from list.  old code above.   CodeCR712}
{the list entry may not have a start date, that means it's being tasked, and hasn't started yet.}
  if DateJobEnded <> '' then
    RunStatus := 'Completed'
  else if DateJobEnded = ''
    then
    begin
    if DateJobStarted = ''
         then RunStatus := 'Queuing'
         else RunStatus := 'Running'
    end
    else
    RunStatus := 'Unknown';
  {/end fix.}

  ListItem := lvwRptStatus.Items.Add;

  ListItem.Caption := 'QA STATS';
  ListItem.SubItems.Add(RunStatus);
  ListItem.SubItems.Add(DateFrom);
  ListItem.SubItems.Add(DateTo);
  ListItem.SubItems.Add(DateJobStarted);
  ListItem.SubItems.Add(DateJobEnded);

  MyListData := TListData.Create;
  MyListData.ReportData := ListData;

  ListItem.Data := Pointer(MyListData);

end;

function TfrmMagReportMgr.DecodeVistaDateTime(VistaDT: String): String;
var
  VistaTimePart: String;
  VistaDatePart: String;
  VistaYYY: String;
  VistaDD: String;
  VistaMM: String;
  VistaHH: String;
  VistaMT: String;
  VistaSS: String;
  WindowsDate: String;
  WindowsTime: String;
begin
  Result := VistaDT;

  if VistaDT <> '' then
  begin
    if Pos('.', VistaDt) > 0 then
    begin
      VistaDatePart := MagPiece(VistaDT, '.', 1);
      VistaTimePart := MagPiece(VistaDT, '.', 2);
    end
    else
    begin
      VistaDatePart := VistaDT;
      VistaTimePart := '';
    end;

    if VistaDatePart = '9999999' then
    begin
      Result := VistaDatePart;
      Exit;
    end;

    VistaYYY := Copy(VistaDatePart, 0, 3);
    VistaMM  := Padd(Copy(VistaDatePart, 4, 2));
    VistaDD  := Padd(Copy(VistaDatePart, 6, 2));

    if VistaTimePart <> '' then
    begin
      VistaHH := Padd(Copy(VistaTimePart, 0, 2));
      VistaMT := Padd(Copy(VistaTimePart, 3, 2));
      VistaSS := Padd(Copy(VistaTimePart, 5, 2));
    end;

    if VistaTimePart <> '' then
      WindowsTime := VistaHH + ':' + VistaMT + ':' + VistaSS
    else
      WindowsTime := '';

    WindowsDate := VistaMM + '/' + VistaDD + '/' + IntToStr(1700 + StrToInt(VistaYYY));

    if WindowsTIme <> '' then
      Result := WindowsDate + '  ' + WindowsTime
    else
      Result := WindowsDate;
  end;
end;

procedure TfrmMagReportMgr.ClearMsg;
begin
 barStatus.Panels[0].Text := '';
 barStatus.Panels[1].Text := '';
// barStatus.Panels[2].Text := '';
end;

procedure TfrmMagReportMgr.Winmsg(panel : integer; value : string);
begin
 barStatus.Panels[panel].Text := value;
 barStatus.Update;
end;

procedure TfrmMagReportMgr.btnRunReportClick(Sender: TObject);
begin
  RunSelectedReport;
end  ;

procedure TfrmMagReportMgr.RunSelectedReport;
var
samerpt : integer;
prmToDt,prmFrDt : Tdate;
prmD,prmE,prmS,prmU : boolean;
begin
  ClearMsg;
  SuppressRefresh := False;  //jk
   {//p117 t5  if not checked,  then assume Existing.}
  if (not cbxIncludeDeletedImages.Checked) and (NOT cbxIncludeExistingImages.Checked)
       then
         begin
         cbxIncludeExistingImages.Checked := true;
         cbxIncludeExistingImages.Update;
         end;
   {/117 t5 gek,  select same report after refresh.}
    prmFrDt := dtFrom.Date;
    prmToDt   := dtTo.Date;
    prmD := cbxIncludeDeletedImages.Checked;
    prmE := cbxIncludeExistingImages.Checked;

    prmS := false;
    prmU := false;
    if rgImageCountsBy.ItemIndex = 0 then
      prmS := true
    else if rgImageCountsBy.ItemIndex = 1 then
      prmU := true;


  {  CheckForSameReport will Prompt the User to 'Re-Run', if the report exists, that
     result would be returned and 'samerpt' would equal 'sameReprtReRun' }
  samerpt := CheckForSameReport(prmFrDt,prmToDt,prmD,prmE,prmS,prmU,False);
  {     sameReportNO = 0;
        sameReportReRun = 1;
        sameReportDontRun = 2;}
  case samerpt of
    sameReportNO :
       begin
       if RunReport(rtNew) = False then
           MessageDlg('Could not queue the report you requested', mtError, [mbOK], 0);
       RefreshCount := 0;
       EnableRefreshTimer(True);
       end;
    sameReportReRun :
       begin
       RunReport(rtReRun);
       end;
    sameReportDontRun :
       begin
       winmsg(1,'Re-Run Report Canceled');
       end;
    end;

EXIT;
(*

  if btnRunReport.Caption = 'Re-run Report' then
  begin
    if lvwRptStatus.Items[LastSelected] <> nil then
      begin
      RunReport(rtReRun);
    //P117T5  gek  Finding :  No exception handling.  what is intended if result is false ?
      end;
    btnRunReport.Caption  := 'Run Report';
    lvwRptStatus.Selected := lvwRptStatus.Items[LastSelected];
    lvwRptStatus.SetFocus;
      {here, here... try a quick refresh.. Try stop disappearing list items.}
      RefreshCount := 0;

      EnableRefreshTimer(True);
    Exit;
  end;

  if (not cbxIncludeDeletedImages.Checked) and (NOT cbxIncludeExistingImages.Checked)
       then
         begin
         {if not checked,  then assume 'Existing.'}
         cbxIncludeExistingImages.Checked := true;
         cbxIncludeExistingImages.Update;
         end;


  if (cbxIncludeDeletedImages.Checked = False) and
     (cbxIncludeExistingImages.Checked = False) then
  begin
    MessageDlg('You must check "Include Deleted Images" and/or "Include Existing Images" before running a job',
      mtWarning, [mbOK], 0);
    Exit;
  end;

  if rgImageCountsBy.ItemIndex = -1 then   {this should never happen now. gek. defaulted Radio Selection
                                                to User and Stats.  }
  begin
    MessageDlg('You must choose "Group by Status" or "Group by Users and Status" before running a job',
      mtWarning, [mbOK], 0);
    Exit;
  end;
    //P117T5  gek  Finding :  Exception handling here. with 'rtNew'
    // but not on other 2 calls to RunReport('rtReRun')?
   if RunReport(rtNew) = False then
    MessageDlg('Could not queue the report you requested', mtError, [mbOK], 0);
  {here, here... try a quick refresh.. Jeannie's request. Implement}
  RefreshCount := 0;

  EnableRefreshTimer(True);*)
end;

procedure TfrmMagReportMgr.btnViewReportClick(Sender: TObject);
begin
  ViewSelectedReport;
end;

procedure TfrmMagReportMgr.dtFromChange(Sender: TObject);
begin
  CalcRange(dcDateTo);
end;

procedure TfrmMagReportMgr.dtFromCloseUp(Sender: TObject);
begin
  if dtFrom.Date < StrToDate('1/1/1900') then
  begin
    MessageDlg('Please choose a ''From date'' greater than the year 1900',
      mtWarning, [mbOK], 0);
    btnRunReport.Enabled := False;
  end
  else
    btnRunReport.Enabled := True;
end;

procedure TfrmMagReportMgr.dtFromExit(Sender: TObject);
begin
  ValidFromDate();
end;

procedure TfrmMagReportMgr.dtToChange(Sender: TObject);
begin
  CalcRange(dcDateFrom);

 //bug4 take out. // ActionCrossCheck.Execute;
end;

procedure TfrmMagReportMgr.dtToExit(Sender: TObject);
begin
  ValidToDate();
end;

procedure TfrmMagReportMgr.CalcRange(CalcFor: TDateCalc);
var
  dt: TDateTime;
  dateTo, dateFrom: TDate;

  function isDateRangeLimited: Boolean;
  begin
    Result := MaxDateRange <> 0;
  end;

begin

  case CalcFor of
    dcDateFrom: begin
                  if isDateRangeLimited then
                  begin
                    {Compute the dtFrom if the days between is greater than the MaxDateRange}
                    if DaysBetween(dtTo.Date, dtFrom.Date)+1 > MaxDateRange then
                      dtFrom.Date := dtTo.Date - (MaxDateRange - 1);
                  end;
                    lbSelectedRange.Caption := 'Range: ' + FormatDateRange(dtFrom.Date, dtTo.Date);
                end;

    dcDateTo:   begin
                  if isDateRangeLimited then
                  begin
                    if DaysBetween(dtTo.Date, dtFrom.Date)+1 > MaxDateRange then
                    begin
                      dt := dtFrom.Date + (MaxDateRange-1);
                      if dt > Date then
                        dtTo.Date := Date
                      else
                        dtTo.Date := dt;
                    end;
                  end;
                  lbSelectedRange.Caption := 'Range: ' + FormatDateRange(dtFrom.Date, dtTo.Date);
                end;

  (*  cleanup : this is never called.
    dcSpan:     begin
                  dateTo   := StrToDate(lvwRptStatus.Items[LastSelected].SubItems[1]);
                  dateFrom := StrToDate(lvwRptStatus.Items[LastSelected].SubItems[2]);
                  lbSelectedRange.Caption := 'Range: ' + FormatDateRange(DtFrom.Date, DtTo.Date);
                end;
    *)
  end;

  btnRunReport.Enabled := True;
 (* {/p117 gek, moved to it's own 'IsFutureDate function, so it's not called each Mouse click, keystroke.}
  if dtFrom.Date > Date+1 then
  begin
    btnRunReport.Enabled := False;
    MessageDlg('The "From" date is for a future date that will not produce a report. Please correct this.', mtWarning, [mbOK], 0);
    lbSelectedRange.Caption := 'Selected Range:';
    Exit;
  end;

  if (dtTo.Date < dtFrom.Date) and (DaysBetween(dtTo.Date, dtFrom.Date)+1 > MaxDateRange) then
  begin
    btnRunReport.Enabled := False;
    MessageDlg('The "From" date must be before or equal to the "To" date. Please correct this.', mtWarning, [mbOK], 0);
    lbSelectedRange.Caption := 'Selected Range:';
    Exit;
  end
  *)
end;


function  TfrmMagReportMgr.ValidFromDate(): boolean;
var dtstr : string;
vFrom,vTo : Tdate;
begin
vFrom := dateof(dtfrom.Date);
vTo := dateof(dtTo.Date);
result := true;
  if vFrom > Date   then      // Q: it was Date + 1 ?   A: .. because field had time, Date didn't
  begin
    dtstr := formatdatetime('mmm/dd/yyyy', dtfrom.Date);
    //btnRunReport.Enabled := False;
    MessageDlg('The "From" date ' + dtstr + ' is a future date that will not produce a report. ' +#13 + #13
               //+  'The "From" date was changed to Today.  Please Review this.', mtWarning, [mbOK], 0);
               +  'Please Correct this.', mtWarning, [mbOK], 0);
    lbSelectedRange.Caption := 'Selected Range:';
    //dtfrom.Date := date;
    result := false;
    Exit;
  end;

end;

function  TfrmMagReportMgr.ValidTODate(): boolean;
var dtstr : string;
vFrom,vTo : Tdate;
begin
vFrom := dateof(dtfrom.Date);
vTo := dateof(dtTo.Date);
result := true;
  if (vTo < vFrom) then //and (DaysBetween(dtTo.Date, dtFrom.Date)+1 > MaxDateRange) then
  begin
    //btnRunReport.Enabled := False;
    MessageDlg('The "To" date: ' + formatdatetime('mmm/dd/yyyy', vTo) + #13
               +  ' must follow (or equal) the "From" date: ' + formatdatetime('mmm/dd/yyyy', vFrom) + #13 + #13
                 //  +  ' The "To" date was changed to equal the "From" date.   Please Review this.', mtWarning, [mbOK], 0);
               +   'Please Correct this.', mtWarning, [mbOK], 0);
    lbSelectedRange.Caption := 'Selected Range:';
   // dtTo.Date := dtFrom.Date;
    result := false;
    Exit;
  end;
  if vTo > Date   then      // Q: it was Date + 1 ?   A: .. because field had time, Date didn't
  begin
    dtstr := formatdatetime('mmm/dd/yyyy', dtto.Date);
    //btnRunReport.Enabled := False;
    MessageDlg('The "To" date ' + dtstr + ' is a future date. Future dates are not valid for reports.' +#13 + #13
               //+  'The "From" date was changed to Today.  Please Review this.', mtWarning, [mbOK], 0);
               +  'Please Correct this.', mtWarning, [mbOK], 0);
    lbSelectedRange.Caption := 'Selected Range:';
    //dtfrom.Date := date;
    result := false;
    Exit;
  end;
       

end;



function  TfrmMagReportMgr.AreValidDates(): boolean;
begin
result := true;
if Not ValidFromDate then result := false;
if NOT ValidToDate then result := false;

end;



procedure TfrmMagReportMgr.PopupMenu1Popup(Sender: TObject);
begin
  RefreshPopStatus;
end;

procedure TfrmMagReportMgr.RefreshPopStatus;
var
 LastSelected: Integer;
 begin
  lastSelected := lvwRptStatus.ItemIndex;   //gek 117 T5 b6
 {/p117T5 gek.   set all to false, and then just enable depending on status.}
  popViewReport.Enabled   := False;
  popRerunReport.Enabled  := False;
  popCancelReport.Enabled := False;
  popDeleteReport.Enabled := False;

  if lastselected = -1 then exit;

  if lvwRptStatus.Items[LastSelected].SubItems[0] = 'Completed' then
      begin
        popViewReport.Enabled   := True;
        popRerunReport.Enabled  := True;
        popDeleteReport.Enabled := True;
        exit;
      end;

  if lvwRptStatus.Items[LastSelected].SubItems[0] = 'Running' then
      begin
        popCancelReport.Enabled := True;
        exit;
      end ;

 if lvwRptStatus.Items[LastSelected].SubItems[0] = 'Cancelled' then
      begin
        popRerunReport.Enabled  := True;
        popDeleteReport.Enabled := True;
        exit;
      end ;

end;

procedure TfrmMagReportMgr.mnuQAReportHelpClick(Sender: TObject);
begin
  MessageDlg('QA Report Help Not Available', mtInformation, [mbOK], 0);
end;

Procedure TfrmMagReportMgr.WMGetMinMaxInfo(Var Message: TWMGetMinMaxInfo);
Var
  Hy, Wx: Integer;
Begin
  Hy := Trunc(100 * (Pixelsperinch / 96));
  Wx := Trunc(200 * (Pixelsperinch / 96));
  With Message.Minmaxinfo^ Do
  Begin
    PtMinTrackSize.x := Wx;
    PtMinTrackSize.y := Hy;
  End;
  Message.Result := 0;
  Inherited;

End;

end.

{/p117T5  gek  - ActionCrossChckExecut is No Longer User.  }
{   save here for now.}

(*  copy of Jerry's function
procedure TfrmMagReportMgr.ActionCrossCheckExecute(Sender: TObject);
var
  DtFromDate, DtToDate: TDate;
  IncDelImgs, IncExtImgs: Boolean;
  AggregateBy: Integer;
  i: Integer;

  JobFlags, JobDateFrom, JobDateTo: String;
  D, E, S, U: Boolean;
  MatchFound: Boolean;
begin

  try
    DtFromDate := dtFrom.Date;
    DtToDate   := dtTo.Date;
    IncDelImgs := cbxIncludeDeletedImages.Checked;
    IncExtImgs := cbxIncludeExistingImages.Checked;

    if rgImageCountsBy.ItemIndex = 0 then
      AggregateBy := 0
    else if rgImageCountsBy.ItemIndex = 1 then
      AggregateBy := 1
    else
      AggregateBy := -1;

    for i := 0 to lvwRptStatus.Items.Count - 1 do
    begin
      JobFlags    := '';
      JobDateFrom := '';
      JobDateTo   := '';
      D           := False;
      E           := False;
      S           := False;
      U           := False;

      if lvwRptStatus.Items[i].Data <> nil then
      begin
        JobFlags     := MagPiece(TListData(lvwRptStatus.Items[i].Data).ReportData, '^', 1);
        JobDateFrom  := DecodeVistaDateTime(MagPiece(TListData(lvwRptStatus.Items[i].Data).ReportData, '^', 2));
        JobDateTo    := DecodeVistaDateTime(MagPiece(TListData(lvwRptStatus.Items[i].Data).ReportData, '^', 3));

        D := Pos('D', JobFlags) > 0; {D = Include deleted images}
        E := Pos('E', JobFlags) > 0; {E = Include existing images}
        S := Pos('S', JobFlags) > 0; {S = Return image counts grouped by status}
        U := Pos('U', JobFlags) > 0; {U = Return image counts grouped by users and status}

        {Now that I have the Taskman line broken down, compare these values to the
         values currently selected in the criteria panel. }

        MatchFound := True;
//        barStatus.Panels[0].Text := '';

        if CompareDate(StrToDate(JobDateFrom), DtFromDate) <> 0 then
        begin
          MatchFound := False;
//          barStatus.Panels[0].Text := barStatus.Panels[0].Text + ' DtFrom ';
        end;

        if CompareDate(StrToDate(JobDateTo), DtToDate) <> 0 then
        begin
          MatchFound := False;
//          barStatus.Panels[0].Text := barStatus.Panels[0].Text + ' DtTo ';
        end;

        if not ((D = False) and (IncDelImgs = False)) then
          if not (D and IncDelImgs) then
          begin
            MatchFound := False;
//            barStatus.Panels[0].Text := barStatus.Panels[0].Text + ' IncDelImgs ';
          end;

        if not ((E = False) and (IncExtImgs = False)) then
          if not (E and IncExtImgs) then
          begin
            MatchFound := False;
//            barStatus.Panels[0].Text := barStatus.Panels[0].Text + ' IncExtImgs ';
          end;


        if not (((AggregateBy = 0) and S) or ((AggregateBy = 1) and U)) then
        begin
          MatchFound := False;
//          barStatus.Panels[0].Text := barStatus.Panels[0].Text + ' AggregateBy ';
        end;

        if MatchFound then
        begin
          btnRunReport.Caption := 'Re-run Report';
          lvwRptStatus.SetFocus;
          Exit;
        end
        else
          btnRunReport.Caption := 'Run Report';
      end;

    end;
  except
    on E:Exception do
      MagLogger.Log(Error, 'TfrmMagReportMgr.ActionCrossCheckExecute: ' + E.Message);
  end;

end; *)

