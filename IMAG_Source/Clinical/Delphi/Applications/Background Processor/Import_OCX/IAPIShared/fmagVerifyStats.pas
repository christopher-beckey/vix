unit fmagVerifyStats;
{
   Package: MAG - VistA Imaging
   WARNING: Per VHA Directive 10-93-142 this unit should not be modified.
   Date Created:
   Site Name: Silver Spring, OIFO
   Developers: Jerry Kashtan
   [==    unit fmagVerifyStats;
   Description:
     An implementation of Sergey Gavrilov's Patch 93 Image Verify report
     unit built to work with his RPC MAGG IMAGE STATISTICS interface. This report
     lets the user get counts of images and image status's .
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
  ActnList,
  Classes,
  ComCtrls,
  Controls,
  Dialogs,
  Forms,
  Graphics,
  Menus,
  Messages,
  StdCtrls,
  ExtCtrls
  ;

//Uses Vetted 20090929:ComObj, Variants, ShellAPI, umagutils, magpositions, SysUtils, Windows

type
  TfrmVerifyStats = class(TForm)
    MainMenu1: TMainMenu;
    mnuFile1: TMenuItem;
    mnuExit: TMenuItem;
    mnuHelp1: TMenuItem;
    mnuImageReports: TMenuItem;
    mnuActiveForms: TMenuItem;
    mnuSaveAs: TMenuItem;
    mnuExporttoExcel: TMenuItem;
    lstReport: TListView;
    dlgSaveAs: TSaveDialog;
    aclMain: TActionList;
    acRunReport: TAction;
    acSaveAs: TAction;
    acOpenInSpreadsheet: TAction;
    N1: TMenuItem;
    Options1: TMenuItem;
    N3: TMenuItem;
    StayonTop1: TMenuItem;
    mnuVerifyTEST: TMenuItem;
    mnushowRPCBrokerTimeLimit: TMenuItem;
    mnusetPCBrokerTimeLimit: TMenuItem;
    Panel1: TPanel;
    lbReportStarted: TLabel;
    lbReportFlags: TLabel;
    mmoFlagDesc: TMemo;
    procedure FormCreate(Sender: TObject);
    procedure mnuImageReportsClick(Sender: TObject);
    procedure FormDestroy(Sender: TObject);
    procedure mnuActiveFormsClick(Sender: TObject);
    procedure mnuExitClick(Sender: TObject);
    procedure SaveAs1Click(Sender: TObject);
    //    procedure ExporttoExcel1Click(Sender: TObject);
    procedure lstReportCustomDrawItem(Sender: TCustomListView;
              Item: TListItem; State: TCustomDrawState; var DefaultDraw: Boolean);
    procedure acRunReportExecute(Sender: TObject);
    procedure acOpenInSpreadsheetExecute(Sender: TObject);
    procedure acSaveAsExecute(Sender: TObject);
    procedure mnuCountsByStatusClick(Sender: TObject);
    procedure mnuCountsUsersAndStatusClick(Sender: TObject);
    procedure mnuIncludeDeletedImagesClick(Sender: TObject);
    procedure mnuIncludeExistingImagesClick(Sender: TObject);
    procedure FormClose(Sender: TObject; var Action: TCloseAction);
    procedure mnuVerifyStatsSelectDateRangeClick(Sender: TObject);
    procedure StayonTop1Click(Sender: TObject);
    procedure mnusetPCBrokerTimeLimitClick(Sender: TObject);
    procedure mnushowRPCBrokerTimeLimitClick(Sender: TObject);
  private
    FStartDate,
    FEndDate: string;
    FReportTitle: string;
    {  maintain minimum and Maximum values for window size}
    procedure WMGetMinMaxInfo(var message: TWMGetMinMaxInfo); message WM_GETMINMAXINFO;
    function DisplayVerificationReport(ListView: TListView; Data: TStrings): Boolean;
    function SaveVerificationReport(ListView: TListView; const FileName: string; const ReportHeader:
        string): Boolean;
    //function ExportToExcel(ListView: TListView; const ReportHeader: String): Boolean;  {JK 6/23/2009 - removed}
    procedure RunStatisticsReport;
    procedure OpenInSpreadsheet;
    function GetDateRangeDesc(dtfrom, dtto: string): string;
    procedure SelectDateRangeAndRunReport;
    procedure DeleteLastTwoLinesBeforeExport; {JK 6/23/2009}
    procedure ShowReport(DtStarted, DtFrom, DtTo, Flags: String; ReportData: TStrings);
  public
    procedure Execute(DtStarted, DtFrom, DtTo, Flags: String; ReportData: TStrings); {/ JK 8/10/2010 - new method based on old 94 named method /}
  end;

var
  frmVerifyStats: TfrmVerifyStats;

implementation

{$R *.dfm}

uses
  Windows,
  SysUtils,
  umagUtils8A,
  ShellAPI,
  MagPositions,
  DateUtils,
  Umagutils8
  ;

procedure TfrmVerifyStats.WMGetMinMaxInfo(var message: TWMGetMinMaxInfo);
var
  hy, wx: integer;
begin
  hy := trunc(100 * (pixelsperinch / 96));
  wx := trunc(200 * (pixelsperinch / 96));
  with message.minmaxinfo^ do
  begin
    ptmintracksize.x := wx;
    ptmintracksize.y := hy;
  end;
  message.result := 0;
  inherited;
end;

procedure TfrmVerifyStats.FormCreate(Sender: TObject);
begin
  lstReport.Align := alclient;
  GetFormPosition(self as Tform);
end;

procedure TfrmVerifyStats.ShowReport(DtStarted, DtFrom, DtTo, Flags: String; ReportData: TStrings);
var
  IncludeDeletedImages,
  IncludeExistingImages,
  ImageCountsBy,
  NumberOfDaysInDateRange : String;
  C,D,E,S,U: Boolean;
  FlagDesc: TStringList;
begin
  FStartDate := DtFrom;
  FEndDate   := DtTo;

  lbReportStarted.Caption :=
    'This Report Was Started At:  ' + DtStarted + '     ' +
    'For Date Range:  ' + DtFrom + '  thru  ' + DtTo + '     ' +
    'Range: ' +
    FormatDateRange(StrToDate(dtFrom), StrToDate(dtTo));

  C := Pos('C', Flags) > 0; {C = Capture Date Range}
  D := Pos('D', Flags) > 0; {D = Include deleted images}
  E := Pos('E', Flags) > 0; {E = Include existing images}
  S := Pos('S', Flags) > 0; {S = Return image counts grouped by status}
  U := Pos('U', Flags) > 0; {U = Return image counts grouped by users and status}

  FlagDesc := TStringList.Create;
  try
   {/p117t5  gek  take off 'Capture Date Range'  NA for a report. Appropriate for a list of images.}
 //   if C then FlagDesc.Add('Capture date range');
    if D then FlagDesc.Add('Include deleted images');
    if E then FlagDesc.Add('Include existing images');
    if S then FlagDesc.Add('Return image counts grouped by status');
    if U then FlagDesc.Add('Return image counts grouped by users and status');
    mmoFlagDesc.Lines.Add(FlagDesc.Text);

  finally
    FlagDesc.Free;
  end;

  DisplayVerificationReport(lstReport, ReportData);
end;

procedure TfrmVerifyStats.mnuImageReportsClick(Sender: TObject);
//begin
//    Application.helpcontext(helpcontext);

var
  whatsnew: string;
begin
//whatsnew := apppath + '\MagWhats New in Patch 93.pdf';
    {      the file is named : 'MagWhats New in Patch 93.pdf'}
  if fileexists(whatsnew) then
  begin
//      MagExecuteFile(whatsnew, '', '', SW_SHOW);
  end
  else
    messagedlg('What''s New Help file does not exist.',mtconfirmation, [mbok],0);
end;



procedure TfrmVerifyStats.FormDestroy(Sender: TObject);
begin
  SaveFormPosition(self as Tform);
end;

procedure TfrmVerifyStats.mnuActiveFormsClick(Sender: TObject);
begin
    SwitchToForm;
end;

procedure TfrmVerifyStats.mnuExitClick(Sender: TObject);
begin
    Close;
end;

procedure TfrmVerifyStats.SaveAs1Click(Sender: TObject);
begin
    if dlgSaveAs.Execute then
        SaveVerificationReport(lstReport, dlgSaveAs.FileName, 'REPORT HEADING JERRY');
end;

{JK 6/23/2009 - removed}
//procedure TfrmVerifyStats.ExporttoExcel1Click(Sender: TObject);
//begin
//  ExportToExcel(lstReport, ReportTitle);
//end;

procedure TfrmVerifyStats.lstReportCustomDrawItem(Sender: TCustomListView;
    Item: TListItem; State: TCustomDrawState; var DefaultDraw: Boolean);
begin
    //--- Highlight the rows with user totals
    if (item.Caption = '-') then exit;

    if pos('Total',Item.Caption) > 0 then
        Sender.Canvas.Brush.Color := clSilver

    else if Item.SubItems[0] = '' then
        Sender.Canvas.Brush.Color := clBtnFace;
end;

procedure TfrmVerifyStats.acRunReportExecute(Sender: TObject);
var
    t: TStringlist;
    Options: string;
    oldTimeLimit : integer;
begin
//    try
//        oldTimeLimit := dmod.RPCBroker1.RPCTimeLimit;
//        dmod.RPCBroker1.RPCTimeLimit := 400;
//        t := TStringList.Create;
//
//        Options := 'C';
//
//        if mnuIncludeDeletedImages.Checked then
//            Options := Options + 'D';
//        if mnuIncludeExistingImages.Checked then
//            Options := Options + 'E';
//        if mnuCountsByStatus.Checked then
//            Options := Options + 'S';
//        if mnuCountsUsersAndStatus.Checked then
//            Options := Options + 'U';
//
//        Options := Trim(Options);
//        if ((FStartDate = '' ) and (FEndDate = '' )) then
//            begin
//            MessageDlg('You need to select a Date Range.',mtConfirmation, [mbOK], 0);
//            exit;
//            end;
//
//
//        if (mnuIncludeExistingImages.Checked = False) and (mnuIncludeDeletedImages.Checked = False) then
//            MessageDlg('You cannot run this report without specifying existing or deleted images (or both) under the options menu item.',
//                mtConfirmation, [mbOK], 0)
//        else
//        begin
//            DMod.MagDBBroker1.RPMagsVerifyReport(FStartDate, FEndDate, Options, t);
//
//            //--- Populate the list view
//            if (t.Count > 0) and (MagPiece(t[0], '^', 1) = '1') then
//                DisplayVerificationReport(lstReport, t)
//            else
//                raise
//                    Exception.Create('TfrmVerifyStats.acRunReportExecute: Error during execution of the report!');
//        end;
//    finally
//        dmod.RPCBroker1.RPCTimeLimit := oldTimeLimit ;
//        t.Free;
//    end;
end;

procedure TfrmVerifyStats.acOpenInSpreadsheetExecute(Sender: TObject);
begin
//     DeleteLastTwoLinesBeforeExport;
    //ExportToExcel(lstReport, ReportTitle);   {Jk 6/23/2009 - removed}
    OpenInSpreadsheet;
end;

procedure TfrmVerifyStats.DeleteLastTwoLinesBeforeExport;
begin
  lstreport.Items.Delete(lstReport.Items.Count-1);
end;

procedure TfrmVerifyStats.acSaveAsExecute(Sender: TObject);
begin
     //DeleteLastTwoLinesBeforeExport;
    if dlgSaveAs.Execute then
        SaveVerificationReport(lstReport, dlgSaveAs.FileName, FReportTitle);
end;

//function TfrmVerifyStats.DisplayVerificationReport(ListView: TListView; Data: TStrings): Boolean;
//var
//    i, j: Integer;
//    buf, curuser, usr, tagstr, totstr: string;
//    li: TListItem;
//
//    function ev(const str: string): string;
//    begin
//        if str <> '' then
//            Result := str
//        else
//            Result := '<empty>';
//    end;
//    procedure switch(var a,b: string);
//    var t : string;
//    begin
//        t := a;
//        a := b;
//        b := t;
//    end;
//
//   procedure  AddUserTotals(buf : string);
//   var usr :string;
//    j : integer;
//   li : Tlistitem;
//   begin
//     usr := MagPiece(buf, '^', 5);
//
//                li := ListView.Items.Add;
//                //--- Format the user's totals
//                li.Caption := ev(usr); // User name
//                li.SubItems.Add(''); // Image Status
//                for j := 6 to 8 do // Entries, Pages, Verification %
//                    li.SubItems.Add(MagPiece(buf, '^', j));
//   end;
//
//   procedure  AddTotals(buf : string);
//   var usr :string;
//    j : integer;
//   li : Tlistitem;
//   begin
//     usr := MagPiece(buf, '^', 5);
//                usr := '        Totals: '  ;
//                //li := ListView.Items.Add;  // this was blank line before totals.
//                //li.C1aption := '-';
//                li := listview.Items.Add;
//                //--- Format the user's totals
//                li.Caption := ev(usr); // User name
//                li.SubItems.Add(''); // Image Status
//                for j := 6 to 8 do // Entries, Pages, Verification %
//                    li.SubItems.Add(MagPiece(buf, '^', j));
//   end;
//
//
//begin
//    ListView.Clear;
//    mnuSaveAs.Enabled := True;
//    mnuExporttoExcel.Enabled := True;
//
//    Result := False;
//
//    if Data.Count <= 1 then
//    begin
//        //??? Display the error message about an empty report ???
//        ListView.Clear;
//        MessageDlg('No data returned for the date range: ' + GetDateRangeDesc(FStartDate,FEndDate),
//                   mtInformation, [mbOK], 0);
//        Exit;
//    end;
//
//    ListView.Items.BeginUpdate;
//    try
//        usr := '';
//        totstr := ''; //gek
//        curuser := '' ; //gek
//        ListView.Clear;
//        //--- Load the RPC results to the list view
//        for i := 1 to Data.Count - 1 do
//        begin
//            buf := Data[i];
//            tagstr := MagPiece(buf, '^', 1);
//            { U user  2='' means this is first line, totals for all users.  Which
//               at the moment isn't put on the Report anywhere...  Excel wouldn't play nice with it. /gek}
//            if (tagstr = 'U') and (MagPiece(buf,'^',2) = '') then
//              begin
//              totstr := buf;
//              continue;
//              end;
//
//            if (tagstr = 'U') and (MagPiece(buf, '^', 2) <> '') then
//            begin
//                usr :=  MagPiece(buf, '^', 5);
//                if curuser = '' then
//                   begin
//                   curuser := buf;
//                   continue;
//                   end;
//                if curuser <> '' then
//                   begin
//                   switch(buf,curuser)  ;
//                   AddUserTotals(buf);
//                   continue;
//                   end;
//                { gek.  we'll save the user totals and list them when User stats are done.}
//       (*            usr := MagPiece(buf, '^', 5);
//
//                li := ListView.Items.Add;
//                //--- Format the user's totals
//                li.Caption := ev(usr); // User name
//                li.SubItems.Add(''); // Image Status
//                for j := 6 to 8 do // Entries, Pages, Verification %
//                    li.SubItems.Add(MagPiece(buf, '^', j));
//         *)
//                end
//            {   US UserStatus, these always comes after the 'U' user}
//            else if tagstr = 'US' then
//            begin
//                li := ListView.Items.Add;
//                //--- Format status data
//                li.Caption := ev(usr); // User name
//                li.SubItems.Add(ev(MagPiece(buf, '^', 5))); // Image Status
//                for j := 6 to 7 do // Entries, Pages
//                    li.SubItems.Add(MagPiece(buf, '^', j));
//            end
//            else if tagstr = 'S' then
//            begin
//                //JK usr := MagPiece(buf, '^', 5);
//                li := ListView.Items.Add;
//                //--- Format the user's totals
//                li.Caption := ev(usr); // User name
//                //JK li.SubItems.Add(''); // Image Status
//                li.SubItems.Add(MagPiece(buf, '^', 5));
//                for j := 6 to 8 do // Entries, Pages, Verification %
//                    li.SubItems.Add(MagPiece(buf, '^', j));
//            end;
//        end;
//        { gek add the last one.}
//        if curuser <> '' then AddUserTotals(curuser);
//        if (data.Count > 2) and (totstr <> '') then AddTotals(totstr);
//        Result := True;
//    finally
//        ListView.Items.EndUpdate;
//        if (Data.Count = 2) and (tagstr <> 'S') then
//            MessageDlg('No data returned for the date range: ' + GetDateRangeDesc(FStartDate,FEndDate),
//                mtInformation, [mbOK], 0);
//    end;
//end;

function TfrmVerifyStats.DisplayVerificationReport(ListView: TListView; Data: TStrings): Boolean;
var
    i, j: Integer;
    buf, curuser, usr, tagstr, totstr: string;
    li: TListItem;

    function ev(const str: string): string;
    begin
        if str <> '' then
            Result := str
        else
            Result := '<empty>';
    end;
    procedure switch(var a,b: string);
    var t : string;
    begin
        t := a;
        a := b;
        b := t;
    end;

   procedure  AddUserTotals(buf : string);
   var usr :string;
    j : integer;
   li : Tlistitem;
   begin
     usr := MagPiece(buf, '^', 5);

                li := ListView.Items.Add;
                //--- Format the user's totals
                li.Caption := ev(usr); // User name
                li.SubItems.Add(''); // Image Status
                for j := 6 to 8 do // Entries, Pages, Verification %
                    li.SubItems.Add(MagPiece(buf, '^', j));
   end;

   procedure  AddTotals(buf : string);
   var usr :string;
    j : integer;
   li : Tlistitem;
   begin
     usr := MagPiece(buf, '^', 5);
                usr := '        Totals: '  ;
                //li := ListView.Items.Add;  // this was blank line before totals.
                //li.Caption := '-';
                li := listview.Items.Add;
                //--- Format the user's totals
                li.Caption := ev(usr); // User name
                li.SubItems.Add(''); // Image Status
                for j := 6 to 8 do // Entries, Pages, Verification %
                    li.SubItems.Add(MagPiece(buf, '^', j));
   end;


begin
    ListView.Clear;
    mnuSaveAs.Enabled := True;
    mnuExporttoExcel.Enabled := True;

    Result := False;

    if Data.Count <= 1 then
    begin
        //??? Display the error message about an empty report ???
        ListView.Clear;
        Exit;
    end;

    ListView.Items.BeginUpdate;
    try
        usr := '';
        totstr := ''; //gek
        curuser := '' ; //gek
        ListView.Clear;
        //--- Load the RPC results to the list view
        for i := 0 to Data.Count - 1 do
        begin
            buf := Data[i];
            tagstr := MagPiece(buf, '^', 1);
            { U user  2='' means this is first line, totals for all users.  Which
               at the moment isn't put on the Report anywhere...  Excel wouldn't play nice with it. /gek}
            if (tagstr = 'U') and (MagPiece(buf,'^',2) = '') then
              begin
              totstr := buf;
              continue;
              end;

            if (tagstr = 'U') and (MagPiece(buf, '^', 2) <> '') then
            begin
                usr :=  MagPiece(buf, '^', 5);
                if curuser = '' then
                   begin
                   curuser := buf;
                   continue;
                   end;
                if curuser <> '' then
                   begin
                   switch(buf,curuser)  ;
                   AddUserTotals(buf);
                   continue;
                   end;
                { gek.  we'll save the user totals and list them when User stats are done.}
       (*            usr := MagPiece(buf, '^', 5);

                li := ListView.Items.Add;
                //--- Format the user's totals
                li.Caption := ev(usr); // User name
                li.SubItems.Add(''); // Image Status
                for j := 6 to 8 do // Entries, Pages, Verification %
                    li.SubItems.Add(MagPiece(buf, '^', j));
         *)
                end
            {   US UserStatus, these always comes after the 'U' user}
            else if tagstr = 'US' then
            begin
                li := ListView.Items.Add;
                //--- Format status data
                li.Caption := ev(usr); // User name
                li.SubItems.Add(ev(MagPiece(buf, '^', 5))); // Image Status
                for j := 6 to 7 do // Entries, Pages
                    li.SubItems.Add(MagPiece(buf, '^', j));
            end
            else if tagstr = 'S' then
            begin
                usr := MagPiece(buf, '^', 5);
                li := ListView.Items.Add;
                //--- Format the user's totals
                li.Caption := ev(usr); // User name
                li.SubItems.Add(''); // Image Status
                for j := 6 to 8 do // Entries, Pages, Verification %
                    li.SubItems.Add(MagPiece(buf, '^', j));
            end;
        end;
        { gek add the last one.}
        if curuser <> '' then AddUserTotals(curuser);
        if (data.Count > 2) and (totstr <> '') then AddTotals(totstr);
        Result := True;
    finally
        ListView.Items.EndUpdate;
        if Data.Count = 2 then
            MessageDlg('No data returned for the date range: ' + GetDateRangeDesc(FStartDate,FEndDate),
                mtInformation, [mbOK], 0);
    end;
end;


function TfrmVerifyStats.SaveVerificationReport(ListView: TListView; const FileName: string; const
    ReportHeader: string): Boolean;
var
    i, j: Integer;
    rf: TextFile;

    //=== Encloses the parameter value in double quotes if necessary
    function csv(const str: string): string;
    begin
        if (Pos(',', str) > 0) or (Pos(',', str) > 0) then
            Result := AnsiQuotedStr(str, '"')
        else
            Result := str;
    end;

begin
    Result := False;
    //--- Create the file and write the header
    AssignFile(rf, FileName);
    Rewrite(rf);
    try
        if ReportHeader <> '' then
            //WriteLn(rf, ReportHeader);
            WriteLn(rf, '#,User Name,ImageStatus,Entries,Pages,QA %,,' + ReportHeader);
        //--- Write the report
        for i := 0 to ListView.Items.Count - 1 do
            with ListView.Items[i] do
            begin
                Write(rf, i + 1, ',', csv(Caption));
                for j := 0 to SubItems.Count - 1 do
                    Write(rf, ',', csv(SubItems[j]));
                WriteLn(rf);
            end;
        //--- Close the file
        CloseFile(rf);
        MessageDlg('The report has been written to the file.', mtInformation, [mbOk], 0);
        Result := True;
    except
        CloseFile(rf);
        raise;
    end;
end;

{JK 6/23/2009 - removed this function and replaced with OpenInSpreadsheet}
{
function TfrmVerifyStats.ExportToExcel(ListView: TListView; const ReportHeader: String): Boolean;
var
  ExcelApp, wb, ws: OleVariant;
  i, ir, j: Integer;
  newApp: Boolean;
  oldCursor: TCursor;

begin
  Result := False;
  newApp := False;
 (*
  try
    //--- Try to connect to already loaded Excel instance
   ExcelApp := GetActiveOleObject('Excel.Application');
  except
    try
      //--- Otherwise, try to create a new Excel instance
      ExcelApp := CreateOleObject('Excel.Application');
      newApp := True;
    except
      ShowMessage('Cannot start Excel!');
      Exit;
    end;
  end;

  try
    oldCursor := Screen.Cursor;
    Screen.Cursor := crHourGlass;
    try
      wb := ExcelApp.Workbooks.Add(xlWBATWorksheet);
      ExcelApp.ActiveSheet.Name := 'Verification Report';

      //--- Set the column headers
      ExcelApp.Cells[1,1].Value := '#';
      ExcelApp.Cells[1,2].Value := 'User Name';
      ExcelApp.Cells[1,3].Value := 'ImageStatus';
      ExcelApp.Cells[1,4].Value := 'Entries';
      ExcelApp.Cells[1,5].Value := 'Pages';
      ExcelApp.Cells[1,6].Value := 'Verification %';
      if ReportHeader <> '' then
        ExcelApp.Cells[1,7].Value := ReportHeader;

      //--- Format the header row
      ExcelApp.Rows[1].Font.Bold := True;
      ExcelApp.Rows[1].HorizontalAlignment := xlCenter;

      //--- Set column widths
      ws := wb.WorkSheets[1];
      ws.Columns[2].ColumnWidth := 50;
      for j:=3 to 6 do
        ws.Columns[j].ColumnWidth := 15;

      //--- Populate rows of the report
      for i:=0 to ListView.Items.Count-1 do
        with ListView.Items[i] do
          begin
            ir := i + 2;
            ExcelApp.Cells[ir,1].Value := i + 1;
            ExcelApp.Cells[ir,2].Value := Caption;
            for j:=0 to SubItems.Count-1 do
              ExcelApp.Cells[ir,j+3].Value := SubItems[j];
          end;

      //--- Make sure that the Excel is visible
      ExcelApp.Visible := True;
    finally
      Screen.Cursor := oldCursor;
    end;
  except
    //--- If a new Excel instance was created, destroy it in case of an error
    if not VarIsEmpty(ExcelApp) and newApp then
      begin
        ExcelApp.DisplayAlerts := False;
        ExcelApp.Quit;
      end;
    Raise;
  end;
  *)
end;
}

procedure TfrmVerifyStats.RunStatisticsReport;
begin
    // ReportTitle := 'Verification report for date(s): ' + ReportTitle;
    // Self.Caption := ReportTitle;
    self.Caption := 'Status / Verification report for date(s): ' + GetDateRangeDesc(FStartDate,FEndDate);
    acRunReportExecute(Self);
end;

procedure TfrmVerifyStats.mnuCountsByStatusClick(Sender: TObject);
begin
//    mnuCountsUsersAndStatus.Checked := False;
//    mnuCountsByStatus.Checked := True;
end;

procedure TfrmVerifyStats.mnuCountsUsersAndStatusClick(Sender: TObject);
begin
//    mnuCountsByStatus.Checked := False;
//    mnuCountsUsersAndStatus.Checked := True;
end;

procedure TfrmVerifyStats.mnuIncludeDeletedImagesClick(Sender: TObject);
begin
//    mnuIncludeDeletedImages.Checked := not mnuIncludeDeletedImages.Checked;
end;

procedure TfrmVerifyStats.mnuIncludeExistingImagesClick(Sender: TObject);
begin
//    mnuIncludeExistingImages.Checked := not mnuIncludeExistingImages.Checked;
end;

procedure TfrmVerifyStats.FormClose(Sender: TObject;
  var Action: TCloseAction);
begin
  action := caFree;
end;

function TfrmVerifyStats.GetDateRangeDesc(dtfrom,dtto : string): string;
begin
result := 'From: ' + dtfrom + ' thru ' + dtto;
end;

//{/ JK 8/10/2010 - P94 method /}
//procedure TfrmVerifyStats.Execute(dtfrom, dtto, desc: string);
//begin
//    with TfrmVerifyStats.Create(nil) do
//    begin
//        FStartDate := dtfrom;
//        FEndDate := dtto;
//        if desc = '' then desc := GetDateRangeDesc(dtfrom,dtto);
//        FReportTitle := desc;
//        Show;
//        if ((dtfrom = '') and ( dtto = '')) then
//           begin
//           SelectDateRangeAndRunReport;
//           exit;
//           end ;
//
//        if ((dtfrom <> '') and (dtto <> '')) then
//            RunStatisticsReport;
//    end;
//end;

{/ JK 8/10/2010 - P117 Execute method /}
procedure TfrmVerifyStats.Execute(DtStarted, DtFrom, DtTo, Flags: String; ReportData: TStrings);
begin
  with TfrmVerifyStats.Create(nil) do
  begin
    ShowReport(DtStarted, DtFrom, DtTo, Flags, ReportData);
    Show;
  end;
end;

procedure TfrmVerifyStats.mnuVerifyStatsSelectDateRangeClick(Sender: TObject);
begin
  SelectDateRangeAndRunReport;
end;

procedure TfrmVerifyStats.SelectDateRangeAndRunReport;
var
    dtfrom, dtto,
    dtINIrange: string;
    maxDateRange : integer;
begin
//    dtINIRange := GetIniEntry('Workstation Settings','MaximumQADateRange');
    if dtINIRange = '' then dtINIRange := '7';
    try
    maxDateRange := strtoint(dtINIRange);
    except
    on e:exception do  maxDateRange := 7;
    end;

//    if frmdaterange.Execute(dtfrom, dtto, maxDateRange) then
//    begin
//        self.FStartDate := dtfrom;
//        self.FEndDate := dtto;
//        self.FReportTitle := GetDateRangeDesc(FStartDate,FEndDate) ;//'From: ' + self.FStartDate + ' thru ' + self.FEndDate;
//        RunStatisticsReport;
//    end
//    else
//    begin
//        //
//    end;
end;

{JK 6/23/2009 - added this method to replace Delphi's Excel automation dcu in favor of
 writing a temporary csv file to disk and letting Windows file association
 pick the right external program to call on its behalf, usually Excel for csv.}

procedure TfrmVerifyStats.OpenInSpreadsheet;
var
    SEInfo: TShellExecuteInfo;
    ExitCode: DWORD;
    ExecuteFile, ParamString, StartInString: string;
begin
    try
        {Put the csv file in the application's exe folder as a temporary file for this operation}
        ExecuteFile := ExtractFilePath(Application.ExeName) + '\VerifyStatsTemp.csv';
        SaveVerificationReport(lstReport, ExecuteFile, FReportTitle);

        {Set up the ShellExecuteEx params}
        FillChar(SEInfo, SizeOf(SEInfo), 0);
        SEInfo.cbSize := SizeOf(TShellExecuteInfo);
        with SEInfo do
        begin
            fMask := SEE_MASK_NOCLOSEPROCESS;
            Wnd := Application.Handle;
            lpFile := PChar(ExecuteFile);
            nShow := SW_SHOWNORMAL;
        end;

        {Shell out to the external application that is associated with the file extension}
        if ShellExecuteEx(@SEInfo) then
        begin
          lstreport.Items.Delete(lstReport.Items.Count-1);

            repeat
                Application.ProcessMessages;
                GetExitCodeProcess(SEInfo.hProcess, ExitCode);
            until (ExitCode <> STILL_ACTIVE) or Application.Terminated;

        end
        else
            MessageDlg('Error displaying the Status/Verification Report in a spreadsheet', mtWarning, [mbOK],
                0);

        {Don't keep the temporary file. Try and delete it. It is in the application's exe folder.}
        DeleteFile(ExecuteFile);

    except
        on E: Exception do
            MessageDlg('Cannot open the report', mtWarning, [mbOK], 0);
    end;
end;

procedure TfrmVerifyStats.StayonTop1Click(Sender: TObject);
begin
if StayOnTop1.checked
   then  self.FormStyle := fsStayonTop
   else self.FormStyle := fsNormal;
end;

procedure TfrmVerifyStats.mnusetPCBrokerTimeLimitClick(Sender: TObject);
var x : string;
begin
x := inputbox('Time Limit', 'Seconds ','30');

//dmod.MagDBBroker1.GetBroker.RPCTimeLimit := strtoint(x);

end;

procedure TfrmVerifyStats.mnushowRPCBrokerTimeLimitClick(Sender: TObject);
var x : integer;
begin
// x := dmod.MagDBBroker1.GetBroker.RPCTimeLimit ;
 showmessage('dmod.MagDBBroker1.GetBroker.RPCTimeLimit  ' + inttostr(x));
end;

end.

