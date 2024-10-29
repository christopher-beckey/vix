unit fMagReleaseOfInfoStatuses;

{
Package: MAG - VistA Imaging
WARNING: Per VHA Directive 10-93-142 this unit should not be modified.
Date Created:   April, 2012
Site Name: Silver Spring, OIFO
Developers: Jerry Kashtan
[==  unit fMagReleaseOfInfoStatuses

  Description: This is the ROI Web Services management form.  It lists jobs in
  progress, finished, or in error and gives the ROI clerk access to completed jobs
  so they can be downloaded from the server and put onto the ROI clerk's local file
  system.
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
      ;; a medical device.  As such, it may not be changed
      ;; in any way.  Modifications to this software may result in an
      ;; adulterated medical device under 21CFR820, the use of which
      ;; is considered to be a violation of US Federal Statutes.
      ;; +---------------------------------------------------------------------------------------------------+

*)


interface

uses
  Windows, Messages, SysUtils, Variants, Classes, Graphics, Controls, Forms,
  Dialogs,
  uMagClasses,
  IMagInterfaces,
  umagutils8,
  umagutils8A,
  magpositions,
  uMagDefinitions,
  MagRemoteBrokerManager,  {/ P130 JK 4/30/2012 - need visibility to VIX properties /}
  MagROIRestUtility, {/ P130 - JK 4/26/2012 - add in the ROI REST support unit /}
  StdCtrls,
  ComCtrls,
  DateUtils,
  Menus,
  ExtCtrls,
  ImgList,
  Buttons,
  StrUtils;

type
  TDateRangeFilter = (drfToday, drfSevenDays, drfNone);

  Tfrm_ROI_Statuses = class(TForm)
    lvROIStatus: TListView;
    sbROIStatus: TStatusBar;
    MainMenu1: TMainMenu;
    mnuFile: TMenuItem;
    mnuFileExit: TMenuItem;
    mnuAction: TMenuItem;
    mnuManualRefresh: TMenuItem;
    mnuOptions: TMenuItem;
    N2: TMenuItem;
    mnuRefreshList: TMenuItem;
    mnuActiveForms: TMenuItem;
    mnuStayonTop: TMenuItem;
    mnuAutoRefreshList: TMenuItem;
    mnuHelp: TMenuItem;
    mnuROIStatusHelp: TMenuItem;
    tiRefresh: TTimer;
    pnlHeader: TPanel;
    rgWorkFilter: TRadioGroup;
    btnRefresh: TBitBtn;
    ImageList1: TImageList;
    pmuROI: TPopupMenu;
    CancelJob1: TMenuItem;
    mnuCancelJob: TMenuItem;
    procedure FormCreate(Sender: TObject);
    procedure FormClose(Sender: TObject; var Action: TCloseAction);
    procedure FormShow(Sender: TObject);
    procedure mnuFileExitClick(Sender: TObject);
    procedure mnuActiveFormsClick(Sender: TObject);
    procedure mnuStayonTopClick(Sender: TObject);
    procedure mnuAutoRefreshListClick(Sender: TObject);
    procedure tiRefreshTimer(Sender: TObject);
    procedure FormKeyUp(Sender: TObject; var Key: Word; Shift: TShiftState);
    procedure FormActivate(Sender: TObject);
    procedure mnuManualRefreshClick(Sender: TObject);
    procedure lvROIStatusColumnClick(Sender: TObject; Column: TListColumn);
    procedure FormDestroy(Sender: TObject);
    procedure rgWorkFilterClick(Sender: TObject);
    procedure lvROIStatusClick(Sender: TObject);
    procedure btnRefreshClick(Sender: TObject);
    procedure lvROIStatusMouseDown(Sender: TObject; Button: TMouseButton;
      Shift: TShiftState; X, Y: Integer);
    procedure CancelJob1Click(Sender: TObject);
    procedure mnuCancelJobClick(Sender: TObject);
    procedure lvROIStatusChange(Sender: TObject; Item: TListItem;
      Change: TItemChange);
  private
    FLocalCommInfo: TVistaSite;  {/ P130 - JK 4/26/2012 /}
    FROIRestUtility: TMagROIRestUtility; {/ P130 - JK 4/26/2012 /}
    FStatusList: TStringList;
    FCDBurnerQueueList: TStringList;
    procedure RefreshList;
    procedure EnableRefreshTimer(value: boolean);
    procedure WinMsg(Panel: Integer; Value: String);
    procedure FilterOutDates(var tmpList: TStringlist);
    function isROIComplete(li: TListItem): Boolean;
    function GetCDBurnerName(QueueName: String): String;
    procedure CancelRunningJob(Guid: String);
    function isCancellable(ItemStatus: String): Boolean;
  public
    procedure Execute(Caller: TComponent);
    property ROIRestUtility: TMagROIRestUtility read FROIRestUtility write FROIRestUtility;
    property LocalCommInfo: TVistaSite read FLocalCommInfo write FLocalCommInfo;
    property StatusList: TStringList read FStatusList write FStatusList;
    property CDBurnerQueueList: TStringlist read FCDBurnerQueueList write FCDBurnerQueueList;
  end;

var
  frm_ROI_Statuses: Tfrm_ROI_Statuses;

implementation

uses fMagReleaseOfInfoSaveJob;

{$R *.dfm}

var
  LastSortedColumn: integer;
  Ascending: boolean;
  RefreshCount: Integer;
  SuppressRefresh: Boolean;
  Shutdown: Boolean;

{/ JK 5/6/2012 - P130 - this execute method brings up the ROI status screen/form.
   IMPORTANT:  This form must be a singleton and also not auto-created in project options.
/}
procedure Tfrm_ROI_Statuses.Execute(Caller: TComponent);
begin
  Shutdown := False;

  if not DoesFormExist('frm_ROI_Statuses') then
    Application.CreateForm(Tfrm_ROI_Statuses, frm_ROI_Statuses);

  FormToNormalSize(frm_ROI_Statuses);

 with frm_ROI_Statuses do
  begin
    {if the caller is the TfrmMagVerify form, turn off the "switch application"
     option since the caller is a modal form.}
//    if Caller.Name = 'frmVerify' then
//    begin
//      mnuActiveForms.Visible := False;
//      mnuActiveForms.ShortCut := ShortCut(0, []);
//    end
//    else
//    begin
      mnuActiveForms.Visible := True;
      mnuActiveForms.ShortCut := ShortCut(Word('R'), [ssCtrl]);
//    end;

    {Make the screen visible}
    frm_ROI_Statuses.Show;
  end;
end;

procedure Tfrm_ROI_Statuses.FormCreate(Sender: TObject);
begin
  {/ P130 - JK 4/25/2012 /}
  ROIRestUtility := TMagROIRestUtility.Create;
  LocalCommInfo := MagRemoteBrokerManager1.GetLocalSite;
  ROIRestUtility.setLocalBrokerPort(LocalCommInfo.VistaPort); {/ P130 - JK 9/12/2012 /}

  StatusList := TStringlist.Create;
  CDBurnerQueueList := TStringlist.Create;

  GetFormPosition(Self As TForm);
  {/p117t5 gek  do this once here, not every OnPaint.}
  pnlHeader.Color := FSAppBackGroundColor;

  ROIRestUtility.VixServer := LocalCommInfo.VixServer;
  ROIRestUtility.VixPort   := LocalCommInfo.VixPort;
end;

procedure Tfrm_ROI_Statuses.FormDestroy(Sender: TObject);
begin
  SaveFormPosition(Self as TForm);
end;

procedure Tfrm_ROI_Statuses.FormClose(Sender: TObject;
  var Action: TCloseAction);
var
  i: Integer;
begin
  ROIRestUtility.Free;
  StatusList.Free;

  {Free the URL object assigned to the TStrings item before freeing the string list object}
  if CDBurnerQueueList <> nil then
  begin
    for i := 0 to CDBurnerQueueList.Count - 1 do
      CDBurnerQueueList.Objects[i].Free;
  end;
  CDBurnerQueueList.Free;

  EnableRefreshTimer(False);
  Shutdown := True;
  Action := caFree;
end;

procedure Tfrm_ROI_Statuses.FormShow(Sender: TObject);
var
  Msg: String;
  QueueXML: String;
  TmpList: TStringList;
begin
    {/ P130 - JK 4/25/2012 /}
    if ROIRestUtility.IsROIRestWebServiceAvailable = False then
    begin
      Msg := 'VIX ROI web service is not available. Contact IRM';
      MessageDlg(Msg, mtWarning, [mbOK], 0);
      MagAppMsg('s', 'Tfrm_ROI_Statuses.FormShow: ' + Msg);

      //p130t9 dmmn 2/7/13 - disable the tool since it will cause exceptions
      rgWorkFilter.Enabled := False;
      btnRefresh.Enabled := False;
      mnuManualRefresh.Enabled := False;

      Exit;
    end;

  TmpList := TStringList.Create;
  try
    QueueXML := ROIRestUtility.GetExportQueues;
    ROIRestUtility.MakeExportListFromXML(QueueXML, TmpList);
    CDBurnerQueueList.Clear;
    CDBurnerQueueList.AddStrings(TmpList);
  finally
    TmpList.Free;
  end;

  RefreshList;

  SuppressRefresh := False;

  if lvROIStatus.Items.Count > 0 then
    EnableRefreshTimer(True)
  else
    EnableRefreshTimer(False);

  mnuCancelJob.Enabled := False;

  if lvROIStatus.Column[5] <> nil then
    lvROIStatus.Column[5].Width := 300;
  if lvROIStatus.Column[6] <> nil then
    lvROIStatus.Column[6].Width := 0;
  if lvROIStatus.Column[7] <> nil then
    lvROIStatus.Column[7].Width := 0;
  if lvROIStatus.Column[8] <> nil then
    lvROIStatus.Column[8].Width := 0;

end;

function Tfrm_ROI_Statuses.GetCDBurnerName(QueueName: String): String;
var
  i: Integer;
begin
  Result := '';
  for i := 0 to CDBurnerQueueList.Count - 1 do
    if Uppercase(QueueName) = UpperCase(TUrnObj(CDBurnerQueueList.Objects[i]).URN) then
    begin
      Result := CDBurnerQueueList[i];
      Break;
    end;
end;

procedure Tfrm_ROI_Statuses.lvROIStatusChange(Sender: TObject; Item: TListItem;
  Change: TItemChange);
begin
  mnuCancelJob.Enabled := False;
  if Item <> nil then
    if Item.SubItems.Count > 0 then    
      if isCancellable(Item.SubItems[2]) then
        mnuCancelJob.Enabled := True;
end;

procedure Tfrm_ROI_Statuses.lvROIStatusClick(Sender: TObject);
var
  ROIStatus: String;
  Msg: String;
  li: TListItem;
begin
  if lvROIStatus.Selected <> nil then
  begin
    li := lvROIStatus.Selected;

    if isROIComplete(li) then
    begin
      frm_ROI_SaveJob := Tfrm_ROI_SaveJob.Create(Self);
      try
        frm_ROI_SaveJob.PatName   := li.Caption;
        frm_ROI_SaveJob.PatSSN4   := li.SubItems[0];
        frm_ROI_SaveJob.ResultUri := li.SubItems[5];
        frm_ROI_SaveJob.RadiologyRouting := li.SubItems[4];
        frm_ROI_SaveJob.ShowModal;
      finally
        frm_ROI_SaveJob.Free;
      end;
    end
    else
    begin
      ROIStatus := lvROIStatus.Selected.SubItems[2];
      if ROIStatus = 'NEW' then
        Msg := 'The ROI request has been received by the server. Processing. Check back soon.' + #13#10 + '(NEW)'
      else if ROIStatus = 'EXPORT_QUEUE' then
        Msg := 'The ROI request contains only radiology study(ies) which have been routed to: ' + #13#10 + li.SubItems[4]
      else if ROIStatus = 'LOADING_STUDY' then
        Msg := 'The ROI request is being processed on the server. Check back later.' + #13#10 + '(LOADING_STUDY)'
      else if ROIStatus = 'STUDY_LOADED' then
        Msg := 'The ROI request is being processed on the server. Check back later.' + #13#10 + '(STUDY_LOADED)'
      else if ROIStatus = 'CACHING_IMAGES' then
        Msg := 'The ROI request is being processed on the server. Check back later.' + #13#10 + '(CACHING_IMAGES)'
      else if ROIStatus = 'IMAGES_CACHED' then
        Msg := 'The ROI request is being processed on the server. Check back later.' + #13#10 + '(IMAGES_CACHED)'
      else if ROIStatus = 'BURNING_ANNOTATIONS' then
        Msg := 'The ROI request is being processed on the server. Check back later.' + #13#10 + '(BURNING_ANNOTATIONS)'
      else if ROIStatus = 'ANNOTATIONS_BURNED' then
        Msg := 'The ROI request is being processed on the server. Check back later.' + #13#10 + '(ANNOTATIONS_BURNED)'
      else if ROIStatus = 'MERGING_IMAGES' then
        Msg := 'The ROI request is being processed on the server. Check back later.' + #13#10 + '(MERGING_IMAGES)'
      else if ROIStatus = 'FAILED_LOADING_STUDY' then
        Msg := 'The ROI request could not be processed on the server.' + #13#10 + '(FAILED_LOADING_STUDY)'
      else if ROIStatus = 'FAILED_CACHING_IMAGES' then
        Msg := 'The ROI request could not be processed on the server.' + #13#10 + '(FAILED_CACHING_IMAGES)'
      else if ROIStatus = 'FAILED_BURNING_ANNOTATIONS' then
        Msg := 'The ROI request could not be processed on the server.' + #13#10 + '(FAILED_BURNING_ANNOTATIONS)'
      else if ROIStatus = 'FAILED_MERGING_IMAGES' then
        Msg := 'The ROI request could not be processed on the server.' + #13#10 + '(FAILED_MERGING_IMAGES)'
      else if ROIStatus = 'CANCELLED' then
        Msg := 'The ROI processing has been cancelled by the user - stopped' + #13#10 + '(CANCELLED)';
      MessageDlg(Msg, mtInformation, [mbOK], 0);
    end;
  end;
end;

function Tfrm_ROI_Statuses.isROIComplete(li: TListItem): Boolean;
begin
  if li.SubItems[2] = 'ROI_COMPLETE' then
    Result := True
  else
    Result := False;
end;

procedure Tfrm_ROI_Statuses.lvROIStatusColumnClick(Sender: TObject;
  Column: TListColumn);
var
  i: Integer;

    function SortByColumn(Item1, Item2: TListItem; Data: integer): integer; stdcall;
    var
      I1, I2: String;
    begin
      if Data = 0 then
        Result := AnsiCompareText(Item1.Caption, Item2.Caption)

      else if Data = 4 then
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

   {Clear the column icons}
   for i := 0 to lvROIStatus.Columns.Count - 1 do
     lvROIStatus.Columns[i].ImageIndex := -1;

   for i := 0 to lvROIStatus.Items.Count - 1 do
     lvROIStatus.Items[i].ImageIndex := -1;


   if Ascending then    
     Column.ImageIndex := 1
   else
     Column.ImageIndex := 0;  

     
end;

function Tfrm_ROI_Statuses.isCancellable(ItemStatus: String): Boolean;
begin
  if (ItemStatus = 'LOADING_STUDY')       or
     (ItemStatus = 'STUDY_LOADED')        or
     (ItemStatus = 'CACHING_IMAGES')      or
     (ItemStatus = 'IMAGES_CACHED')       or
     (ItemStatus = 'BURNING_ANNOTATIONS') or
     (ItemStatus = 'ANNOTATIONS_BURNED')  or
     (ItemStatus = 'MERGING_IMAGES')      then
    Result := True
  else
    Result := False;

end;

procedure Tfrm_ROI_Statuses.lvROIStatusMouseDown(Sender: TObject;
  Button: TMouseButton; Shift: TShiftState; X, Y: Integer);
begin
  CancelJob1.Visible := False;

  if (Button = mbRight) and (lvROIStatus.Selected <> nil) then
    if isCancellable(lvROIStatus.Selected.SubItems[2]) then
      CancelJob1.Visible := True;
end;

procedure Tfrm_ROI_Statuses.FormKeyUp(Sender: TObject; var Key: Word;
  Shift: TShiftState);
begin
  if Key = VK_F5 then
  begin
    EnableRefreshTimer(True);
  end;
end;

procedure Tfrm_ROI_Statuses.RefreshList;
var
  i: Integer;
  li: TListItem;

  sGuid: String;
  sLastUpdated: String;
  sPatId: String;
  sResultUri: String;
  sStatus: String;
  sErrMsg: String;
  sPatName: String;
  sPatSSN4: String;
  sExportQueue: String;
  tmpList: TStringList;
begin
  //p130 dmmn 2/7/13 - just in case, stop the operation if no vix support
  if ROIRestUtility.IsROIRestWebServiceAvailable = False then
  begin
    MagAppMsg('sd', 'Tfrm_ROI_Statuses.RefreshList: ' + 'VIX ROI web service is not available. Contact IRM');
    Exit;
  end;

  Screen.Cursor := crHourglass;
  WinMsg(2, '...Refreshing this list');
  try
    if StatusList = nil then
      Exit;
        
    lvROIStatus.Clear;
    StatusList.Clear;

    tmpList := TStringList.Create;
    try
      ROIRestUtility.RefreshStatusList(tmpList);

      FilterOutDates(tmpList);

      StatusList.AddStrings(tmpList);
      WinMsg(0, 'Showing ' + IntToStr(StatusList.Count) + ' status items');
    finally
      tmpList.Free;
    end;

    if StatusList.Count = 0 then
      Exit;
  
    for i := 0 to StatusList.Count - 1 do
    begin

      sErrMsg      := '';
      sGuid        := '';
      sLastUpdated := '';
      sPatId       := '';
      sPatName     := '';
      sPatSSN4     := '';
      sResultUri   := '';
      sStatus      := '';

      sErrMsg      := Trim(MagPiece(StatusList[i], '^', 1));
      sGuid        := Trim(MagPiece(StatusList[i], '^', 2));

      sLastUpdated := Trim(MagPiece(StatusList[i], '^', 3));
      sLastUpdated := StringReplace(sLastUpdated, '@', ' ', [rfReplaceAll, rfIgnoreCase]);

      sPatId       := Trim(MagPiece(StatusList[i], '^', 4));
      sPatName     := Trim(MagPiece(StatusList[i], '^', 5));

      sPatSSN4     := Trim(MagPiece(StatusList[i], '^', 6));
      sPatSSN4     := StringReplace(sPatSSN4, '*', '', [rfReplaceAll, rfIgnoreCase]);

      sResultUri   := Trim(MagPiece(StatusList[i], '^', 7));

      sStatus      := Trim(MagPiece(StatusList[i], '^', 8));
//      if AnsiContainsStr(sStatus, 'FAILED') then
//        sStatus := 'Failed';
      

      if Trim(MagPiece(StatusList[i], '^', 9)) <> '' then
      begin
        sExportQueue := GetCDBurnerName(Trim(MagPiece(StatusList[i], '^', 9)))
      end
      else
        sExportQueue := '';

      li := lvROIStatus.Items.Add;

      li.Caption := sPatName;
      li.SubItems.Add(sPatSSN4);
      li.SubItems.Add(sPatId);
      li.SubItems.Add(sStatus);
      li.SubItems.Add(sLastUpdated);
      li.SubItems.Add(sExportQueue);
      li.SubItems.Add(sResultUri);
      li.SubItems.Add(sGuid);
      li.SubItems.Add(sErrMsg);

      li.ImageIndex := -1;

      LastSortedColumn := 4;
      Ascending := False;
      lvROIStatusColumnClick(Self, lvROIStatus.Columns[4]);

      if lvROIStatus.Column[5] <> nil then
        lvROIStatus.Column[5].Width := 300;
      if lvROIStatus.Column[6] <> nil then
        lvROIStatus.Column[6].Width := 0;
      if lvROIStatus.Column[7] <> nil then       
        lvROIStatus.Column[7].Width := 0;
      if lvROIStatus.Column[8] <> nil then
        lvROIStatus.Column[8].Width := 0;

    end;
  finally
    Screen.Cursor := crDefault;
    WinMsg(2, 'Refresh Complete');
  end;
end;

procedure Tfrm_ROI_Statuses.FilterOutDates(var tmpList: TStringlist);
var
  i: Integer;
  ROIItem: String;
  sDatePart: String;
  DatePart: TDate;
  SkipItem: Boolean;
begin

  for i := tmpList.Count - 1 downto 0 do
  begin
    SkipItem := False;
    ROIItem := tmpList[i];
    sDatePart := MagPiece(MagPiece(ROIItem, '^', 3), '@', 1);
    try
      DatePart := StrToDate(sDatePart);
    except
      SkipItem := True;
    end;

    if not SkipItem then
      case rgWorkFilter.ItemIndex of
        0:
          if DatePart <> Today then
            tmpList.Delete(i);
        1:
          if DatePart <= Today-6 then
            tmpList.Delete(i);
      end;
  end;
end;

procedure Tfrm_ROI_Statuses.rgWorkFilterClick(Sender: TObject);
begin
  RefreshList;
end;

{/ P130 - 5/14/2012 - not using the timer for now. Left code in in case at a later
 time we decide to implement it. The reason for not using it is because every time
 it auto-refreshes, it resets the grid sort order. This may upset the user who is
 viewing the form in a certain layout. /}
procedure Tfrm_ROI_Statuses.tiRefreshTimer(Sender: TObject);
var
  SecsToUpd, iSec: Integer;
  SecDesc: String;
  DoRefresh: Boolean;
begin
  if not Self.Visible then
  begin
    EnableRefreshTimer(False);
    Exit;
  end;

  //this test of suppressrefresh was here.  //Gek: 117T5 Added EnableRefreshTimer(T/F) to handle Displaying Refresh info.
  DoRefresh := False;
  SecDesc := ' seconds.';
  if not mnuAutoRefreshlist.Checked then
  begin
    {if not autorefreshlist, then just do it once and quit.}
    RefreshList;
    EnableRefreshTimer(False);
    Exit;
  end;

  if SuppressRefresh then
  begin
    EnableRefreshTimer(False);
    Exit;
  end;

  Inc(RefreshCount);
  if mnuAutoRefreshList.Checked then
  begin
    if RefreshCount < 11 then
      SecsToUpd := RefreshCount mod 2
    else
    begin
      if (RefreshCount mod 30) = 0 then
        SecsToUpd := 0
      else SecsToUpd := 30 - (RefreshCount mod 30);
    end;
  end;
  if SecsToUpd = 1 then
    SecDesc := ' second.';
  if SecsToUpd = 0 then
    DoRefresh := true;

  if DoRefresh  then
  begin
    RefreshList;
    //winmsg(0,'updated '); // testing,
  end;

  if not mnuAutoRefreshList.Checked then
    EnableRefreshTimer(False);

end;

procedure Tfrm_ROI_Statuses.WinMsg(Panel: Integer; Value: String);
begin
  sbROIStatus.Panels[Panel].Text := Value;
  sbROIStatus.Update;
end;

procedure Tfrm_ROI_Statuses.FormActivate(Sender: TObject);
begin
  Exit;  {the Execute method takes care of activation}
end;

procedure Tfrm_ROI_Statuses.mnuActiveFormsClick(Sender: TObject);
begin
  SwitchToForm;
end;

procedure Tfrm_ROI_Statuses.mnuAutoRefreshListClick(Sender: TObject);
begin
  RefreshCount := 0;
  EnableRefreshTimer(mnuAutoRefreshList.Checked);
end;

procedure Tfrm_ROI_Statuses.mnuCancelJobClick(Sender: TObject);
begin
  if lvROIStatus.Selected = nil then
    if isCancellable(lvROIStatus.Selected.SubItems[2]) then
      CancelRunningJob(lvROIStatus.Selected.SubItems[6]);
end;

procedure Tfrm_ROI_Statuses.btnRefreshClick(Sender: TObject);
begin
  RefreshList;
end;

procedure Tfrm_ROI_Statuses.CancelJob1Click(Sender: TObject);
begin
  CancelRunningJob(lvROIStatus.Selected.SubItems[6]);
end;

procedure Tfrm_ROI_Statuses.CancelRunningJob(Guid: String);
var
  Status: Boolean;
begin

  Status := ROIRestUtility.CancelJob(Guid);

  if Status then
    MessageDlg('Job cancelled', mtInformation, [mbOK], 0)
  else
    MessageDlg('Could not cancel this job', mtWarning, [mbOK], 0);

  RefreshList;
end;


procedure Tfrm_ROI_Statuses.EnableRefreshTimer(Value: Boolean);
begin
  //p130T9 dmmn 2/7/13 - avoid refresh when there's no vix support
  if ROIRestUtility.IsROIRestWebServiceAvailable then
  begin
    tiRefresh.Enabled             := Value;
    
    if Value then
      //    WinMsg(2, lbRefeshPending.Caption)
    else
      winmsg(2, '');
  end
  else
  begin
    tiRefresh.Enabled := False;
  end;
end;

procedure Tfrm_ROI_Statuses.mnuFileExitClick(Sender: TObject);
begin
  Close;
end;

procedure Tfrm_ROI_Statuses.mnuManualRefreshClick(Sender: TObject);
begin
  RefreshList;
end;

procedure Tfrm_ROI_Statuses.mnuStayonTopClick(Sender: TObject);
begin
  If mnuStayOnTop.Checked Then
    Self.Formstyle := FsStayOnTop
  Else
    Self.Formstyle := FsNormal;
end;

end.
