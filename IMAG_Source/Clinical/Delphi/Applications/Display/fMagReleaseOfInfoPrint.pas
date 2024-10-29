unit fMagReleaseOfInfoPrint;

{Package: MAG - VistA Imaging
WARNING: Per VHA Directive 10-93-142 this unit should not be modified.
Date Created: 01/2010
Site Name: Silver Spring, OIFO
Developers: Bill Balshem
[==   unit fMagReleaseOfInfoPrint.pas;
 This form is GUI for users to manage and run multiple image print sessions per patient, per ROI
==]
Patch Log
 -p130  modified by Jerry in 130 to add ROI OCX -connection to VIX (gek added text)
 -p149
 **p149 HIDE 130   /GEK/3-19-14
 various if Stmts to querry ini entry 'DEV-SETTINGS','p130active'
 if not TRUE then code won't be executed. 

 -p161   Post 138 Patch.   this patch goes to all sites  after 138 is installed on KIDS.
  in p161 we are taking out all the Conditionals that checked for p130active
  and 161 is based on 149.. so this patch has all 149 changes.
  + 
1)   Fix for ColorChannel  (Gregs Issue  Ticket INC000001094239
2)   DEV SEtting in INI to Disregard Restrictions for Viewing based on Resolution
     and DEMO OPTIONS INI change to Disregard Restrictions 
 - --  maybe  -- -
 check issue that Image is reloaded when image list.. becomes active.. found this when checking for colorchannel
 check issue Image Toolbar buttons don't work... but main menu image items do work.
 check issue with giving Image Properties ability to Full Res... and Image Info Advanced.
 check issue of giving ZMAGGVSS ability to Image Info Advanced.

 ---
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
  Dialogs, StdCtrls, ExtCtrls, Buttons,
  //va imaging
  cMagListView,
  uMagClasses,
  cMag4Viewer,
  cMag4VGear,
  uMagDefinitions,
  umagkeymgr,
  magPositions,
  ComCtrls,
  IMagInterfaces,
  MagROIRestUtility, {/ P130 - JK 4/26/2012 - add in the ROI REST support unit /}
  MagRemoteBrokerManager;  {/ P130 JK 4/30/2012 - need visibility to VIX properties /}
//  IMagRemoteBrokerInterface; {/ P130 JK 4/30/2012 - need visibility to VIX properties /}

type
  TfrmReleaseOfInfoPrint = class(TForm)
    pnlClient: TPanel;
    pnlSummary: TPanel;
    pnlImage: TPanel;
    pnlSummaryHeadings: TPanel;
    lstSummary: TListBox;
    Label1: TLabel;
    pnlPatientInfo: TPanel;
    lblDOB: TLabel;
    lblFilter: TLabel;
    lblMatches: TLabel;
    Label2: TLabel;
    Label3: TLabel;
    Label4: TLabel;
    Label5: TLabel;
    lblSSN: TLabel;
    lblConnected: TLabel;
    lblType: TLabel;
    pnlButtons: TPanel;
    Panel1: TPanel;
    ROIMag4Viewer: TMag4Viewer;
    lbdescPatient: TLabel;
    lbPatient: TLabel;
    PrintDialog1: TPrintDialog;
    pgROIOutput: TPageControl;
    tsToPrint: TTabSheet;
    tsToFile: TTabSheet;
    cbSuppress: TCheckBox;
    btnPrint: TBitBtn;
    btnAbort: TBitBtn;
    btnClose: TBitBtn;
    btnProcessROIRequest: TBitBtn;
    lbToFileActive: TLabel;
    pnlDICOM: TPanel;
    cbRadiologyCDQueue: TComboBox;
    Label6: TLabel;
    lbDicomInfo: TLabel;
    lbDicomInfo2: TLabel;
    lbRemoteItems: TLabel;
    BitBtn1: TBitBtn;
    procedure FormShow(Sender: TObject);
    procedure FormClose(Sender: TObject; var Action: TCloseAction);
    procedure btnPrintClick(Sender: TObject);
    procedure btnAbortClick(Sender: TObject);
    procedure FormCreate(Sender: TObject);
    procedure FormDestroy(Sender: TObject);
    procedure PrintDialogGXShow(Sender: TObject);
    procedure lbdescPatientMouseDown(Sender: TObject; Button: TMouseButton; Shift: TShiftState; X, Y: Integer);
    procedure pgROIOutputDrawTab(Control: TCustomTabControl; TabIndex: Integer;
      const Rect: TRect; Active: Boolean);
    procedure pgROIOutputChange(Sender: TObject);
    procedure btnProcessROIRequestClick(Sender: TObject);
    procedure cbRadiologyCDQueueCloseUp(Sender: TObject);
    procedure pgROIOutputMouseMove(Sender: TObject; Shift: TShiftState; X,
      Y: Integer);
    procedure btnROIJobStatusClick(Sender: TObject);
    procedure pgROIOutputChanging(Sender: TObject; var AllowChange: Boolean);
  private
    { Private declarations }

    sSignature, sReason: string;
    slSummary: TStringList;
    PageCTR: integer;
    vGear: TMag4VGear;

    FROIRestUtility: TMagROIRestUtility; {/ P130 - JK 4/26/2012 /}
    FLocalCommInfo: TVistaSite;  {/ P130 - JK 4/26/2012 /}
    QueueList: TStringList;
    NumDCMStudies: Integer;

    CurrentGuid: String;
    ResultUri: String;

    FRemoteRoiIENs: TStringList;

    procedure PrintHeader;
    procedure PrintSummary;
    procedure PrintSummaryPage(sl: TStringList; FirstPage: boolean);
    procedure PrintError;
    procedure PrintImageDetail(iCtr, iTotal: integer);
    procedure AddToSummary(IObj: TImageData; sStatus: string;  PartOfGroup: boolean);
    procedure ProcessImageGroup(IObj: TImageData);
    procedure PrintCurrentImage(IObj: TImageData; var sStatus: string);
    procedure LogRemoteImages;
    //function UserHasROIKey: boolean;
    function GetImagesToPrintCount: integer;
    procedure AddSummaryItemAndScroll(s: string);
    function BuildSummaryImageCountText(iPrintedImages: integer): string;
    procedure GetAnnotationPrintInfoLine(VGear: TMag4VGear;
      var AnnotationInfoLine: String);
    procedure OverprintAnnotInfo;
    procedure MakeQueueListFromXML(QueueXML: String);
    function MakeDisclosureList: String;
    function CountDICOMs: Integer;
    function FormattedROIStatus(Status: String): String;
    procedure EnumerateRemoteROIItems(var RemoteItems: TStringList);
  public
    { Public declarations }
    ListOfImagesToPrint: TMagListView;
    Filter: TImageFilter;
    UsingCheckBoxes: boolean;
    DODImageCTR: integer;
    procedure RunPrintSession;
    procedure Execute(UseCheckBoxes: boolean; lv: TMagListView; fltr: TImageFilter; upref:Tuserpreferences; ShowFileTab: Boolean);
    property ROIRestUtility: TMagROIRestUtility read FROIRestUtility write FROIRestUtility;
    property LocalCommInfo: TVistaSite read FLocalCommInfo write FLocalCommInfo;
    property RemoteRoiIENs: TStringlist read FRemoteRoiIENs write FRemoteRoiIENs;
  end;

var
  frmReleaseOfInfoPrint: TfrmReleaseOfInfoPrint;
  iGroupImages: integer;
  ROIKey :boolean;

const
  GROUP = ' [GROUP IMAGE] ';
  PAGE = '    Report Page ';
  PageHeaderLen = 210;
  LineLen = 120;
  MARGIN = 75;

implementation

uses
  ShLwApi,
  Printers,
  uMagDisplayMgr,
  ImagDMinterface, //RCA  DmSingle,  dmSingle,
  iMagViewer,
  Umagutils8,
  cMagIGManager,
  fMagReleaseOfInfoStatuses;

{$R *.dfm}

//this routine sets the black outline to the printed page, for pages that have the outline(header page, summary page(s))
function GetPageRect: TRect;
begin
   result := Rect(MARGIN, MARGIN, (Printer.Pagewidth - MARGIN), (Printer.PageHeight - MARGIN));
end;


//calling routine to create the multi image print screen and showmodal)
procedure TfrmReleaseOfInfoPrint.Execute(UseCheckBoxes: boolean; lv: TMagListView; fltr: TImageFilter; upref:Tuserpreferences; ShowFileTab: Boolean);
begin
  Application.CreateForm(TfrmReleaseOfInfoPrint,frmReleaseOfInfoPrint);
  {/p117 changed name of form, also create using application.createform}
//  with frmReleaseOfInfoPrint.Create(nil) do
  with frmReleaseOfInfoPrint do
  begin
    ListOfImagesToPrint := lv;
    Filter := fltr;
    UsingCheckBoxes := UseCheckBoxes;
    cbSuppress.Checked := upref.SuppressPrintSummary;

    
    if ShowFileTab then
      pgROIOutput.ActivePageIndex := 1
    else
      pgROIOutput.ActivePageIndex := 0;
    ShowModal;
    //lv.OnSelectItem := MagListView1SelectItem;
    Free;
  end;
end;

procedure TfrmReleaseOfInfoPrint.FormShow(Sender: TObject);
var
  ItemsSelected: Integer;
  i: Integer;
  tmpList: TStringList;
begin
  {/P117 GEK  override blocked images with 'TEMP IGNORE BLOCK' key}
  AddDelKey('TEMP IGNORE BLOCK',TRUE);

  if ListOfImagesToPrint = nil then
    Close;

  slSummary := TStringList.Create;

  Caption := Caption + ' ' + idmodobj.GetMagPat1.M_NameDisplay;

  {/p117 gek added a Patient Field and display patient name .  Users suggest this
    in previous patches.}
  lbPatient.Caption := idmodobj.GetMagPat1.M_NameDisplay;

  {/p117  gek changed DOB and SSN to DOB Display and SSN Display }
  lblDOB.Caption := idmodobj.GetMagPat1.M_DOBdisplay;

  lblSSN.Caption := idmodobj.GetMagPat1.M_SSNdisplay ;
  lblConnected.Caption := idmodobj.GetMagPat1.M_ServiceConnected;
  lblType.Caption := idmodobj.GetMagPat1.M_Type;
  lblFilter.Caption := lblFilter.Caption + '   ' + Filter.Name;
  lblMatches.Caption := IntToStr(GetImagesToPrintCount) + ' Image(s) selected to print'  ; 

  if pgROIOutput.ActivePageIndex = 0 then  {/ P130 JK 4/20/2012 /}
    lblMatches.Caption := IntToStr(GetImagesToPrintCount) + ' Image(s) selected to print'
  else
    lblMatches.Caption := IntToStr(GetImagesToPrintCount) + ' Image(s) selected to process';

  MagIGManager.AllowTextFiles := true;
  //ROIKey := UserHasROIKey;

  {/ P122 with P123 patient ID additions - JK 8/11/2011 /}
  if GSess.Agency.IHS then
  begin
    label3.Caption := 'HRN';
    lblSSN.Caption := 'HRN';
  end
  else
  begin
    label3.Caption := 'SSN';
    lblSSN.Caption := 'SSN';
  end;

  lbRemoteItems.Caption := '';
  if ROIRestUtility.IsROIRestWebServiceAvailable then
  begin
    tmpList := TStringList.Create;
    try
      EnumerateRemoteROIItems(tmpList);
      RemoteRoiIENs.Clear;
      RemoteRoiIENs.AddStrings(tmpList);
    finally
      tmpList.Free;
    end;

    NumDCMStudies := CountDICOMs;

    if NumDCMStudies > 0 then
    begin
      pnlDICOM.Visible := True;
      lbDicomInfo.Caption := 'This disclosure contains ' + IntToStr(NumDCMStudies) + ' DICOM studies.';

      ItemsSelected := 0;
      for i := 0 to ListOfImagesToPrint.Items.Count - 1 do
        if (not UsingCheckBoxes) or (ListOfImagesToPrint.Items[i].Checked) then
          Inc(ItemsSelected);

      if RemoteRoiIENs.Count = ItemsSelected then
      begin
        lbRemoteItems.Caption := 'Disclosure will not be made. No local images selected';
        btnProcessROIRequest.Enabled := False;
        pnlDicom.Visible := False;
        Exit;
      end;
    end
    else
    begin
      pnlDICOM.Visible := False;
      lbDicomInfo.Caption := '';
      btnProcessROIRequest.Enabled := True;
    end;

    if RemoteRoiIENs.Count > 0 then
      lbRemoteItems.Caption := 'Only local images will be disclosed. ' + IntToStr(RemoteRoiIENs.Count) + ' remote images ignored.'
    else
      lbRemoteItems.Caption := '';

    if cbRadiologyCDQueue.ItemIndex = -1 then
      lbDicomInfo2.Visible := False
    else
      lbDicomInfo2.Visible := True;

    MakeQueueListFromXML(ROIRestUtility.GetExportQueues);
  end
  else
  begin
    pgROIOutput.ActivePageIndex := 0;
  end;

end;

{/ P130 - JK 4/26/2012 - we do not process remote site items for processing to File or CD /}
procedure TfrmReleaseOfInfoPrint.EnumerateRemoteROIItems(var RemoteItems: TStringList);
var
  i: Integer;
  IObj: TImageData;
begin
  if RemoteItems = nil then
    Exit;

  RemoteItems.Clear;

  for i := 0 to ListOfImagesToPrint.Items.Count - 1 do
    if (not UsingCheckBoxes) or (ListOfImagesToPrint.Items[i].Checked) then
    begin
      IObj := TMagListViewData(ListOfImagesToPrint.Items[i].Data).IObj;

      If (IObj.PlaceCode <> Gsess.WrksPlaceCODE)
        Or (IObj.PlaceIEN <> GSess.WrksPlaceIEN) // JMW 3/25/2005 p45
        Or (IObj.ServerName <> idmodobj.GetMagDBBroker1.GetServer)
        Or (IObj.ServerPort <> idmodobj.GetMagDBBroker1.GetListenerPort) Then
        RemoteItems.Add(IObj.Mag0);

    end;

end;

{/ P130 - JK 4/26/2012 /}
procedure TfrmReleaseOfInfoPrint.MakeQueueListFromXML(QueueXML: String);
var
  i: Integer;
begin
  cbRadiologyCDQueue.Items.Clear;

  QueueList := TStringList.Create;
  ROIRestUtility.MakeExportListFromXML(QueueXML, QueueList);
  cbRadiologyCDQueue.Items.AddStrings(QueueList);
end;

//function to format strings on printed to page to improve the look on the output
function AddFrontSpaces(s: string): string;
begin
  result := s;
  while length(result) <  PageHeaderLen do
   result := ' ' + result;
end;

//function to build and format division information
function BuildDivisionStr: string;
var s: string;
begin                               
  result := '';
  s := idmodobj.GetMagDBBroker1.GetBroker.User.Division;
  if length(s) > 0 then result := MagPiece(s, '^', 2) + ' (' + MagPiece(s, '^', 3) + ')'
end;

//routine to write header page to print output, called by main print run function 'RunPrintSession'
procedure TfrmReleaseOfInfoPrint.PrintHeader;
var r: TRect;
const IND = '          ';
begin
  with Printer do
    begin
      r := GetPageRect;
      Canvas.Brush.Style := bsClear;
      Canvas.TextOut(MARGIN, 200, AddFrontSpaces(PAGE + '1'));
      Canvas.Font.Size := Canvas.Font.Size + 2;
      Canvas.TextOut(MARGIN, 200 + (1 * Canvas.TextHeight('')), '');
      Canvas.TextOut(MARGIN, 200 + (2 * Canvas.TextHeight(idmodobj.GetMagPat1.M_NameDisplay)), IND + idmodobj.GetMagPat1.M_NameDisplay);
      Canvas.TextOut(MARGIN, 200 + (3 * Canvas.TextHeight('DOB: ' + idmodobj.GetMagPat1.M_DOB)), IND + 'DOB: ' + idmodobj.GetMagPat1.M_DOB);

      {/ P122 with P123 patient ID additions - JK 8/11/2011 /}
      if GSess.Agency.IHS then
        Canvas.TextOut(MARGIN, 200 + (4 * Canvas.TextHeight('HRN: ' + idmodobj.GetMagPat1.M_SSN)), IND + 'HRN: ' + idmodobj.GetMagPat1.M_SSN)
      else
        Canvas.TextOut(MARGIN, 200 + (4 * Canvas.TextHeight('SSN: ' + idmodobj.GetMagPat1.M_SSN)), IND + 'SSN: ' + idmodobj.GetMagPat1.M_SSN);

      Canvas.TextOut(MARGIN, 200 + (5 * Canvas.TextHeight('Service Connected: ' + idmodobj.GetMagPat1.M_ServiceConnected)), IND + 'Service Connected: ' + idmodobj.GetMagPat1.M_ServiceConnected);
      Canvas.TextOut(MARGIN, 200 + (6 * Canvas.TextHeight('Type: ' + idmodobj.GetMagPat1.M_Type)), IND + 'Type: ' + idmodobj.GetMagPat1.M_Type);
      Canvas.TextOut(MARGIN, 200 + (7 * Canvas.TextHeight('Printed By: ' + idmodobj.GetMagDBBroker1.GetBroker.User.Name)), IND + 'Printed By: ' + idmodobj.GetMagDBBroker1.GetBroker.User.Name);
      Canvas.TextOut(MARGIN, 200 + (8 * Canvas.TextHeight('Division: ' + BuildDivisionStr)), IND + 'Division: ' + BuildDivisionStr);
      Canvas.TextOut(MARGIN, 200 + (9 * Canvas.TextHeight(IntToStr(GetImagesToPrintCount) + 'Image(s)')), IND + IntToStr(GetImagesToPrintCount) + ' Item(s)');
      Canvas.Font.Size := Canvas.Font.Size - 2;
      Canvas.Brush.Color := clBlack;
      Canvas.FrameRect(r);
    end;
end;

function TfrmReleaseOfInfoPrint.GetImagesToPrintCount: integer;
var i,ctr: integer;
begin
  i := 0;
  ctr := 0;
  result := ListOfImagesToPrint.Items.Count;
  if UsingCheckBoxes then
  begin
    for i := 0 to ListOfImagesToPrint.Items.Count - 1 do
      if ListOfImagesToPrint.Items[i].Checked then ctr := ctr + 1;
    result := ctr;
  end;
end;

procedure TfrmReleaseOfInfoPrint.lbdescPatientMouseDown(Sender: TObject; Button: TMouseButton; Shift: TShiftState; X, Y: Integer);
Begin

End;

//builds and formats first line in print summary, which gives counts(items selected, total images printed, etc...
function TfrmReleaseOfInfoPrint.BuildSummaryImageCountText(iPrintedImages: integer): string;
begin
  result := IntToStr(ListOfImagesToPrint.Items.Count) + ' item(s) in filter. ' + IntToStr(GetImagesToPrintCount) + ' item(s) selected to print. ' +
    IntToStr(iPrintedImages) + ' image(s) printed.'
end;

procedure TfrmReleaseOfInfoPrint.btnROIJobStatusClick(Sender: TObject);
var
  StatusXML: String;
  StatusList: TStringList;
  S: String;
  sGuid: String;
  sLastUpdated: String;
  sPatId: String;
  sResultUri: String;
  sStatus: String;
  sErrMsg: String;
  sPatName: String;
  sPatSSN4: String;
  sExportQueue: String;
begin
  if CurrentGuid <> '' then
  begin
    StatusList := TStringList.Create;
    StatusXML := ROIRestUtility.GetROIStatus(CurrentGuid);
    ROIRestUtility.AddROIStatusToList(StatusXML, StatusList);

//    if MagLength(StatusList[0], '^') = 7 then
//    begin
//      sGuid        := Trim(MagPiece(StatusList[0], '^', 2));
//      sLastUpdated := Trim(MagPiece(StatusList[0], '^', 3));
//      sPatId       := Trim(MagPiece(StatusList[0], '^', 4));
//      sResultUri   := Trim(MagPiece(StatusList[0], '^', 5));
//      sStatus      := Trim(MagPiece(StatusList[0], '^', 6));
//      sErrMsg      := Trim(MagPiece(StatusList[0], '^', 1));
//    end
//    else
//    begin
//      sGuid        := Trim(MagPiece(StatusList[0], '^', 1));
//      sLastUpdated := Trim(MagPiece(StatusList[0], '^', 2));
//      sPatId       := Trim(MagPiece(StatusList[0], '^', 3));
//      sResultUri   := Trim(MagPiece(StatusList[0], '^', 4));
//      sStatus      := Trim(MagPiece(StatusList[0], '^', 5));
//    end;

      sErrMsg      := Trim(MagPiece(StatusList[0], '^', 1));
      sGuid        := Trim(MagPiece(StatusList[0], '^', 2));
      sLastUpdated := Trim(MagPiece(StatusList[0], '^', 3));
      sPatId       := Trim(MagPiece(StatusList[0], '^', 4));
      sPatName     := Trim(MagPiece(StatusList[0], '^', 5));
      sPatSSN4     := Trim(MagPiece(StatusList[0], '^', 6));
      sResultUri   := Trim(MagPiece(StatusList[0], '^', 7));
      sStatus      := Trim(MagPiece(StatusList[0], '^', 8));
      sExportQueue := Trim(MagPiece(StatusList[0], '^', 9));

      if sErrMsg = '' then
        sErrMsg := 'None';

      if sExportQueue = '' then
        sErrMsg := 'None';

    S := 'Patient: '       + sPatName     + #13#10 +
         'SSN4: '          + sPatSSN4     + #13#10 +
         'Guid: '          + sGuid        + #13#10 +
         'Last Updated: '  + sLastUpdated + #13#10 +
         'Patient ID: '    + sPatId       + #13#10 +
         'Result URI: '    + sResultUri   + #13#10 +
         'Status: '        + sStatus      + #13#10 +
         'DICOM Queue: '   + sExportQueue + #13#10;

    if sErrMsg <> '' then
      S := S + 'Error Msg: ' + sErrMsg;

    MessageDlg(S, mtInformation, [mbOK], 0);
  end
  else
    MessageDlg('There is no job to check status for', mtInformation, [mbOK], 0);

  ResultURI := sResultUri;
  StatusList.Free;

end;

procedure TfrmReleaseOfInfoPrint.cbRadiologyCDQueueCloseUp(Sender: TObject);
begin
//  btnProcessROIRequest.Enabled := True;

  if cbRadiologyCDQueue.ItemIndex = -1 then
  begin
    lbDicomInfo2.Visible := True;
    btnProcessROIRequest.Enabled := False;
  end
  else
  begin
    lbDicomInfo2.Visible := False;
    btnProcessROIRequest.Enabled := True;
  end;
end;

//routine to write summary to print output, called by main print run function 'RunPrintSession'
procedure TfrmReleaseOfInfoPrint.PrintSummary;
var sl: TStringList; i: integer;
begin
  sl := TStringList.Create;
  try
    i := 0;
    while i < lstSummary.Items.Count do
    begin
      sl.Add(lstSummary.Items.Strings[i]);
      if sl.Count = 68 then
      begin
        PrintSummaryPage(sl, i <= 68);
        sl.Clear;
      end;
      Inc(i);
    end;
    if sl.Count > 0 then PrintSummaryPage(sl, i <= 68);
  finally
    sl.Free;
  end;
end;

//routine to write each summary page to print output, 'PrintSummary'  manages the priting of the summary as a whole, including
//that the number of lines does not go past number of lines allowed ona apage, this routine writes out each page
procedure TfrmReleaseOfInfoPrint.PrintSummaryPage(sl: TStringList; FirstPage: boolean);
var r: TRect; i: Integer; s: string;
begin
  with Printer do
    begin
      NewPage;
      r := GetPageRect;
      Canvas.Brush.Style := bsClear;
      Inc(PageCtr);
      Canvas.TextOut(MARGIN, 200, AddFrontSpaces(PAGE + IntToStr(PageCtr))); {BM-ImagePrint- Text Summary NON-Image}
      if FirstPage then
      begin
        s := BuildSummaryImageCountText(PageCtr - 2);
        Canvas.TextOut(MARGIN, 200 + (1 * Canvas.TextHeight(s)), s);
      end;
      for i := 0 to sl.Count - 1 do Canvas.TextOut(MARGIN, 200 + ((i + 2)* Canvas.TextHeight(sl.Strings[i])), sl.Strings[i]);
      Canvas.Brush.Color := clBlack;
      Canvas.FrameRect(r);
    end;
end;

//routine to write errored pages to print output, called by main print run function 'RunPrintSession'
procedure TfrmReleaseOfInfoPrint.PrintError;
begin
  with Printer do
    begin
      NewPage;
      Canvas.Brush.Style := bsClear;
      Canvas.TextOut(MARGIN, 200, AddFrontSpaces(PAGE + IntToStr(PageCtr)));  {BM-ImagePrint- Text NON-Image}
      Canvas.TextOut(MARGIN, 200 + (1 * Canvas.TextHeight('There was a problem printing this image')), 'There was a problem printing this image');
    end;
end;

//routine to write demographic and property info at the top of each printed page
procedure TfrmReleaseOfInfoPrint.PrintImageDetail(iCtr, iTotal: integer);
var
  sConsultInfo, sPrint: string;
  iLine: integer;
begin
  iLine := 0;
  Inc(PageCTR);
  sConsultInfo := vGear.PI_ptrData.PtName + ' ' + vGear.PI_ptrData.SSN + ' ' + vGear.PI_ptrData.ExpandedDescription(FALSE);
  if iTotal > 1 then sConsultInfo := sConsultInfo + ' (pg ' + IntToStr(iCtr) + ' of ' + IntToStr(iTotal) + ') ';
  sConsultInfo := sConsultInfo + PAGE + IntToStr(PageCtr);
  printer.Canvas.Brush.Color := clWhite;
  printer.Canvas.Brush.Style := bsClear;
  printer.canvas.textout(MARGIN, 0, sConsultInfo);  {BM-ImagePrint- Text NON-Image}
end;

{/ P122 - JK 8/11/2011 - After the title line and image print, overprint the image with the annotation
   information.  If this isn't done after the image is placed, there is a chance the image will overwrite
   this line if the image is full size on the page.  Put this information directly under the title line. /}
procedure TfrmReleaseOfInfoPrint.OverprintAnnotInfo;
var
  AnnotLine: String;
begin
  {/ P122 - JK 8/10/2011 - support annotation printing info in ROI printouts /}
  GetAnnotationPrintInfoLine(vGear, AnnotLine);
  {/ P122 - JK 8/10/2011 - create a separate line under the TPrinter.Title line for annotation-related messaging /}
  if AnnotLine <> '' then
    Printer.Canvas.Textout(MARGIN, 60 + Canvas.TextHeight('W'), AnnotLine); {BM-ImagePrint- Annotation Info NON-Image}
end;

procedure TfrmReleaseOfInfoPrint.pgROIOutputChange(Sender: TObject);
begin
  if pgROIOutput.ActivePageIndex = 0 then  {/ P130 JK 4/20/2012 /}
  begin
    lblMatches.Caption := IntToStr(GetImagesToPrintCount) + ' Image(s) selected to print';
    label1.Caption     := 'Image Print Summary';
  end
  else
  begin
    lblMatches.Caption := IntToStr(GetImagesToPrintCount) + ' Image(s) selected to process';
    label1.Caption     := 'Disclosure Summary';
  end;
end;

procedure TfrmReleaseOfInfoPrint.pgROIOutputChanging(Sender: TObject;
  var AllowChange: Boolean);
begin
  if ROIRestUtility.IsROIRestWebServiceAvailable then
  begin
    tsToFile.Hint := 'Move ROI request to file and DICOM to CD';
    tsToFile.ShowHint := True;
  end
  else
  begin
    tsToFile.Hint := 'VIX ROI Web Service is Unavailable - Contact IRM';
    tsToFile.ShowHint := True;
  end;
  
end;

procedure TfrmReleaseOfInfoPrint.pgROIOutputDrawTab(Control: TCustomTabControl;
  TabIndex: Integer; const Rect: TRect; Active: Boolean);
var
  x, y: Integer;
begin
  if Active then
  begin
    x := Rect.Left + 7;
    y := Rect.Top  + 4;
    Control.Canvas.Brush.Color := FSAppBackGroundColor;
    Control.Canvas.Font.Color  := clBlue;
  end
  else
  begin
    x := Rect.Left + 3;
    y := Rect.Top  + 2;
    Control.Canvas.Brush.Color := clBtnFace;
    Control.Canvas.Font.Color  := clWindowText;
  end;

  Control.Canvas.Rectangle(Rect);

  Control.Canvas.TextRect(Rect, x, y, TPageControl(Control).Pages[TabIndex].Caption);

  if Active then
    TPanel(TPageControl(Control).ActivePage).Color := FSAppBackGroundColor;

end;

procedure TfrmReleaseOfInfoPrint.pgROIOutputMouseMove(Sender: TObject;
  Shift: TShiftState; X, Y: Integer);
var
  tabindex: Integer;
begin
  tabindex := pgROIOutput.IndexOfTabAt(X, Y);

  if tabindex >= 0 then
    pgROIOutput.Hint := pgROIOutput.Pages[tabindex].Hint
end;

function ImageIsPrintable(IObj: TImageData): boolean;
begin
  case IObj.ImgType of
    {BB 1/18/2011 - NCAT doc (501) will pass as printable but not be printed after 'is DoD' check}
    1, 11, 13, 15, 17, 18, 104, 103, 501: result := true;
    else result := false;
  end;
end;

function ImageIsGroup(IObj: TImageData): boolean;
begin
  if IObj.ImgType in [11, 16] then result := true
  else result := false;
end;

function ImageIsRemote(IObj: TImageData): boolean;
begin
  result := (Iobj.ServerName <> idmodobj.GetMagDBBroker1.GetServer) or (Iobj.ServerPort <> idmodobj.GetMagDBBroker1.GetListenerPort);
end;


//routine to write a printable image(selected, has printable format and issues (such as imssing).
//this routine is called by main print session routine 'RunPrintSession', for single images,
//or the group image routine 'ProcessImageGroup' for groups
procedure TfrmReleaseOfInfoPrint.PrintCurrentImage(IObj: TImageData; var sStatus: string);      {BM-ImagePrint- Called from RunPrintSession}
var
  i: integer;
  OkToPrint: Boolean;
begin
{/p117 t6 5/4/2011  gek.  The order of testing to see if the image is printable is backwards.
   We need to test the attribute/property that encompases the smaller attributes first.
   i.e.
        if Image is from DoD then we're not printing it, so we don't care about it's format.
        if Image is deleted, we don't care about it's format either
        New order of tests  DoD,  Deleted,  ImageIsPrintable..  switched from ImageIsPrintable, Deleted, Dod.}
  OkToPrint := True;


  if IObj.IsImageDOD then  {/ P117 NCAT - JK 1/5/2011 /}
  begin
    sStatus := 'DoD Image not printed.';
    OkToPrint := False;
    Inc(DODImageCTR);
  end
  else if IObj.IsImageDeleted then
  begin
    sStatus := 'Image has been deleted';
    OkToPrint := False;
  end
  else if not ImageIsPrintable(IObj) then
  begin
    sStatus := 'Image type format currently not printable';
    OkToPrint := False;
  end ;




  (*else if IObj.ImgType = 501 then  {/ P117 NCAT - JK 1/5/2011 /}
  begin
    if UserHasKey('MAG REVIEW NCAT') = False then
    begin
      sStatus := 'Not authorized to print Neurocognative Assessment Tool (NCAT) Report';
      OkToPrint := False;
    end;
  end;*)


  if OkToPrint then
  begin
    try
      OpenSelectedImage(IObj, 1, 1, 1, 0, false, false, ROIMag4Viewer);
      vGear := ROIMag4Viewer.GetCurrentImage;
      for i := 1 to vGear.PageCount do
      begin
        vGear.Page := i;
        Printer.newpage;
        PrintImageDetail(i, vGear.PageCount);
        vGear.PrintImage(Printer.Handle);    {BM-ImagePrint-  in PrintCurrentImage - Calls TMag4VGear.PrintImage}
        OverprintAnnotInfo;
        sStatus := 'Image printed';
        if PageCtr = 2 then
        begin
          ROIMag4Viewer.SetRowColCount(1, 1);
          ROIMag4Viewer.ReFreshImages;
        end;
      end;
      sStatus := 'Image printed';
    except
      on e:Exception do
      begin
        PrintError;
        sStatus := 'Print failed';// + e.Message;
      end;
    end;
  end;
end;

procedure TfrmReleaseOfInfoPrint.PrintDialogGXShow(Sender: TObject);
var rethnd, hndle : THandle;
begin
hndle := PrintDialog1.Handle;
//setfocus(hndle);
setforegroundwindow(hndle);

// (Sender as TWinControl).SetFocus;
end;

{function TfrmROIPrint.UserHasROIKey: boolean;
var sl: TStringList;
begin
  sl := TStringList.Create;
  try
    idmodobj.GetMagDBBroker1.RPMaggUserKeys(sl);
    result := sl.IndexOf('MAG ROI') > -1;
  finally
    sl.Free;
  end;
end; }

//main routine for running a print session, called when user clicks print
//manages all pre print funtions(such as selecting reason, selecting printer), printing to output, writing results
//and logging to database
procedure TfrmReleaseOfInfoPrint.RunPrintSession;
var
  i: integer;
  IObj: TImageData;
  PrintDLG: TPrintDialog;
  sStatus, sDFN, Xmsg: string;

const NonVAMessage = 'VA has no authority to release records or information that '+
               'is viewable only and not stored and maintained ' +
               'in a VA system of records.';
begin
  sStatus := '';
  sDFN := '';
  iGroupImages := 0;
  DODImageCTR := 0;
  // p130t11 dmmn 4/3/13 - reenable esignature check here for situation where the user
  // has MAG SYSTEM but not MAG ROI
  If Not idmodobj.GetMagUtilsDB1.GetEsig(Xmsg) Then Exit;

  if not idmodobj.GetMagUtilsDB1.GetReason(1, sReason) then exit;
//gek 508 focus issue.  PrintDLG := TPrintDialog.Create(nil);

  try
//gek 508 focus issue.    if PrintDLG.Execute then
//gek 508 focus issue. Use PrintDialog component instead.
{/gek Called PrintDialog in OnClick from button  for focus keyboard control issue,}
//   if self.PrintDialog1.Execute then

    begin
      btnAbort.Enabled := true;
      Printer.BeginDoc;      {BM-ImagePrint-   Calls TMag4VGear.PrintImage}
      try
        PrintHeader;
        PageCTR := 1;
        for i :=  0 to ListOfImagesToPrint.Items.Count - 1 do
        begin
          IObj := TMagListViewData(ListOfImagesToPrint.Items[i].Data).Iobj;
          if (sDFN = '') and (IObj <> nil) then sDFN := IObj.DFN;
          if (not UsingCheckBoxes) or (ListOfImagesToPrint.Items[i].Checked) then
          begin
            if ImageIsGroup(Iobj) then
            begin
              ProcessImageGroup(IObj);
              Continue;
            end
            else
              PrintCurrentImage(IObj, sStatus);
          end //if ListOfImagesToPrint...
          else
          begin
            sStatus := 'Image not selected to print';
          end;
          AddToSummary(Iobj, sStatus, false);
        end; //for i...
        AddSummaryItemAndScroll('Print session done.');
        //if DODImageCTR > 0 then AddSummaryItemAndScroll(IntToStr(DODImageCTR) + ' DoD Image(s) not printed. ' + NonVAMessage);
        {/P117 T6 gek,  5/4/2011  Don't print DoD Count, just statement.}
        if DODImageCTR > 0 then AddSummaryItemAndScroll('DoD Image(s) not printed. ' + NonVAMessage);
        if not self.cbSuppress.Checked
           then PrintSummary;
      finally
        Printer.EndDoc;
        btnAbort.Enabled := false;
        if VGear <> nil then
          VGear.ClearImage;
      end;
      idmodobj.GetMagDBBroker1.RPMaggMultiImagePrint(sDFN, sReason, slSummary);
      LogRemoteImages;
    end;
  finally
//gek 508 focus issue.    PrintDLG.Free;
  end;
end;

//routine to manage the processing of an item that is a group of images
//called by 'RunPrintSession'. for each printable images calls 'PrintCurrentImage'
procedure TfrmReleaseOfInfoPrint.ProcessImageGroup(IObj: TImageData);
var
  slGroup: TStringList;
  GroupObj: TImageData;
  i: integer;
  ImgPrintable: boolean;
  sStatus: string;
begin
  GroupObj := TImageData.Create; //to remove compiler warning
  slGroup := TStringList.Create;
  sStatus := GROUP;
  try
    idmodobj.GetMagDBBroker1.RPMaggGroupImages(IObj, slGroup, false, 'D');

    if slgroup.Count < 2 then
    begin
      sStatus := sStatus + 'Could not retrieve images';
      AddToSummary(IObj, sStatus, false);
      exit;
    end;

    GroupObj := GroupObj.StringToTImageData(slGroup.Strings[1]);
    if not ImageIsPrintable(GroupObj) then
    begin
      sStatus := sStatus + 'Image group format currently not printable';
      AddToSummary(IObj, sStatus, false);
      exit;
    end;

    AddToSummary(IObj, sStatus, false);
    for i := 1 to slGroup.Count - 1 do
    begin
      Inc(iGroupImages);
      GroupObj := GroupObj.StringToTImageData(slGroup.Strings[i]);
      PrintCurrentImage(GroupObj, sStatus);
      AddToSummary(GroupObj, sStatus, true);
    end;

  finally
    slGroup.Free;
    GroupObj.Free;
  end;
end;

//routine to write items to summary list box(specific to to status of an image)
//this routine calls 'AddSummaryItemAndScroll' which adds the item and sacrolls on the screen
procedure TfrmReleaseOfInfoPrint.AddToSummary(IObj: TImageData; sStatus: string; PartOfGroup: boolean);
var sIndent, sDemo: string; sStatus2: string;
const DEL = '-';
begin
  if PartOfGroup then sIndent := '          '
  else sIndent := '* ';
  sDemo := IObj.PlaceCode + DEL + IObj.ImgDes + DEL + IObj.Proc + DEL + IObj.Date;
  if Pos(GROUP, sStatus) > 0 then
  begin
    sStatus2 := StringReplace(sStatus, GROUP, '', []);
    AddSummaryItemAndScroll(sIndent + sDemo + GROUP);
    if length(sStatus2) > 0 then AddSummaryItemAndScroll('                    ' + sStatus2);
  end
  else
  begin
    AddSummaryItemAndScroll(sIndent + sDemo);
    AddSummaryItemAndScroll('                    ' + sStatus);
  end;
  slSummary.AddObject(Iobj.Mag0 + '^' + BoolToStr(ImageIsRemote(IObj), true) + '^' + sDemo + ':    ' + sStatus, IObj);
end;

procedure TfrmReleaseOfInfoPrint.btnProcessROIRequestClick(Sender: TObject);
var
  IENList: String;
  UrnObj: TUrnObj;
  DicomURN: String;
  OkToDisclose: Boolean;
  Status: String;
  RestReturn: String;
  PatID: String;  {/ P130 - JK 1/17/2013 - TFS #56553 /}
  PatIDType: String; {/ P130 - JK 1/17/2013 - TFS #56553 /}
begin
  CurrentGuid := '';
  ResultUri   := '';

  IENList := MakeDisclosureList;
    
  if not LocalCommInfo.IsSiteVixEnabled then
  begin
    MessageDlg('The local VIX is not enabled. Disclosure cannot be processed to file. Printing of disclosures is available only at this time.', mtWarning, [mbOK], 0);
    Exit;
  end;

  if IENList = '' then
  begin
    MessageDlg('There are no disclosures selected. Exiting', mtWarning, [mbOK], 0);
    Exit;
  end;

  {Process the list of items}
  {/ P130 - JK 4/25/2012 /}
  DicomURN := '';
  OkToDisclose := True;

  if NumDCMStudies > 0 then
  begin
    if cbRadiologyCDQueue.ItemIndex = -1 then
    begin
      MessageDlg('Select a DICOM location from the DICOM CD Writer drop down list', mtInformation, [mbOK], 0);
      Exit;
    end;
    
    if cbRadiologyCDQueue.Items.Objects[cbRadiologyCDQueue.ItemIndex] <> nil then
    begin
      UrnObj := cbRadiologyCDQueue.Items.Objects[cbRadiologyCDQueue.ItemIndex] as TUrnObj;
      DicomURN := UrnObj.URN;
    end
    else
    begin
      MessageDlg('Cannot send studies to DICOM CD queue. The queue is not defined. Disclosure not processed.', mtWarning, [mbOK], 0);
      OkToDisclose := False;
    end;
  end;

  if OkToDisclose then
  begin
    {/ P130 - JK 1/17/2013 - TFS #56553 /}
    //p130t13 dmmn 6/18/13 - more generic way to check for error in ICN, anything with -1
//    if MagRemoteBrokerManager1.PatICNWithChecksum = '-1^NO MPI NODE' then
    if (MagPiece(MagRemoteBrokerManager1.PatICNWithChecksum,'^', 1) = '-1') then
    begin
      PatID := idmodobj.GetMagPat1.M_DFN;
      PatIDType := 'DFN';
    end
    else
    begin
      PatID := MagRemoteBrokerManager1.PatICNWithChecksum;
      PatIDType := 'ICN';
    end;

    RestReturn := ROIRestUtility.ProcessDisclosuresByIEN(IENList,
                                                         PatID,
                                                         PatIDType,
                                                         GSess.WrksInstStationNumber,
                                                         DicomURN);
  end;

  Status := ROIRestUtility.AddROIGuidToList(RestReturn);
  lstSummary.Items.Add(FormattedROIStatus(Status));

  CurrentGuid := MagPiece(Status, '^', 1);
  ResultUri   := MagPiece(Status, '^', 3);
end;

function TfrmReleaseOfInfoPrint.FormattedROIStatus(Status: String): String;
var
  Piece: String;
  CurrentTime: String;
begin
  if Status = '' then
  begin
    Result := 'The ROI job failed';
    Exit;
  end;

  CurrentTime := FormatDateTime('hh:mm AM/PM mmm dd, yyyy', Now);

  Piece := MagPiece(Status, '^', 4);

  if Piece = 'NEW' then
    Result := 'ROI: Request recieved @ ' + CurrentTime + ', being processed'
  else if Piece = 'LOADING_STUDY' then
    Result := 'ROI: Loading the list of images in the studies requested @ ' + CurrentTime + ', being processed'
  else if Piece = 'STUDY_LOADED' then
    Result := 'ROI: List of images loaded @ ' + CurrentTime + ', being processed'
  else if Piece = 'CACHING_IMAGES' then
    Result := 'ROI: Caching images in local VIX @ ' + CurrentTime + ', being processed'
  else if Piece = 'IMAGES_CACHED' then
    Result := 'ROI: Images cached locally @ ' + CurrentTime + ', being processed'
  else if Piece = 'BURNING_ANNOTATIONS' then
    Result := 'ROI: Burning annotations into images that have annotations @ ' + CurrentTime + ', being processed'
  else if Piece = 'ANNOTATIONS_BURNED' then
    Result := 'ROI: Annotations burned for all images @ ' + CurrentTime + ', being processed'
  else if Piece = 'MERGING_IMAGES' then
    Result := 'ROI: Merging images into PDF and ZIP result @ ' + CurrentTime + ', being processed'
  else if Piece = 'ROI_COMPLETE' then
    Result := 'ROI: This request is complete'
  else if Piece = 'EXPORT_QUEUE' then
    Result := 'ROI: Studies sent to DICOM CD Burner device'
  else if Piece = 'FAILED_LOADING_STUDY' then
    Result := 'ROI: Failed to load list of images for study. Job has been stopped.'
  else if Piece = 'FAILED_CACHING_IMAGES' then
    Result := 'ROI: Failed to cache images. Job has been stopped.'
  else if Piece = 'FAILED_BURNING_IMAGES' then
    Result := 'ROI: Failed to burn annotations. Job has been stopped.'
  else if Piece = 'FAILED_MERGING_IMAGES' then
    Result := 'ROI: Failed to merge into PDF. Job has been stopped.'
  else if Piece = 'CANCELLED' then
    Result := 'ROI: ROI processing cancelled by user - stopped.';

end;

function TfrmReleaseOfInfoPrint.MakeDisclosureList: String;
var
  i, idx: integer;
  IObj: TImageData;
  PrintDLG: TPrintDialog;
  sStatus, sDFN, Xmsg: string;
  FoundRemoteIEN: Boolean;
const
  NonVAMessage = 'VA has no authority to release records or information that is viewable only and not stored and maintained ' +
                 'in a VA system of records.';
begin
  sStatus := '';
  sDFN := '';
  iGroupImages := 0;
  DODImageCTR := 0;

  Result := '';
  
  // p130t11 dmmn 4/3/13 - reenable esignature check here for situation where the user
  // has MAG SYSTEM but not MAG ROI
  If Not idmodobj.GetMagUtilsDB1.GetEsig(Xmsg) Then Exit;

  if not idmodobj.GetMagUtilsDB1.GetReason(1, sReason) then
    Exit;

  try
    begin
      try
        PageCTR := 1;

        for i :=  0 to ListOfImagesToPrint.Items.Count - 1 do
        begin
          IObj := TMagListViewData(ListOfImagesToPrint.Items[i].Data).Iobj;
          if (sDFN = '') and (IObj <> nil) then
            sDFN := IObj.DFN;

          if (not UsingCheckBoxes) or (ListOfImagesToPrint.Items[i].Checked) then
          begin
            FoundRemoteIEN := False;
            for idx := 0 to RemoteRoiIENs.Count - 1 do
              if IObj.Mag0 = RemoteRoiIENs[idx] then
              begin
                FoundRemoteIEN := True;
                //p130t10 dmmn 3/4/13 - add a disclosure status for remote image
                sStatus := 'Remote image will not be disclosed';
                Break;
              end;
            if not FoundRemoteIEN then            
              if Result = '' then
                Result := IObj.Mag0
              else
                Result := Result + '%5E' + IObj.Mag0;
          end
          else
          begin
            sStatus := 'Image not selected for disclosure';
          end;
          AddToSummary(Iobj, sStatus, false);
          sStatus := '';   {/ P130 - JK 1/21/2013 - TFS 60838 - P117 never cleared the sStatus after each iteration /}
        end; //for i...

        AddSummaryItemAndScroll('Disclosure session done.');

        //if DODImageCTR > 0 then AddSummaryItemAndScroll(IntToStr(DODImageCTR) + ' DoD Image(s) not printed. ' + NonVAMessage);
        {/P117 T6 gek,  5/4/2011  Don't print DoD Count, just statement.}
        if DODImageCTR > 0 then
          AddSummaryItemAndScroll('DoD Image(s) not disclosed. ' + NonVAMessage);
        if not self.cbSuppress.Checked then
//          PrintSummary;
      finally
        btnAbort.Enabled := false;
        if VGear <> nil then
          VGear.ClearImage;
      end;
//      idmodobj.GetMagDBBroker1.RPMaggMultiImagePrint(sDFN, sReason, slSummary);
      LogRemoteImages;
    end;
  finally
//gek 508 focus issue.    PrintDLG.Free;
  end;
end;

//routine that writes an entry to the image acess log, on the db of site where the image is located, for any image that is printed
procedure TfrmReleaseOfInfoPrint.LogRemoteImages;
var i: integer; IObj: TImageData; sStatus, sParam: string;
begin
  for i := 0 to slSummary.Count - 1 do
  begin
    if slSummary.Objects[i].ClassType <> TImageData then continue;
    IObj := TImageData(slSummary.Objects[i]);
    sStatus := slSummary.Strings[i];
    //if (ImageIsRemote(IObj)) and (pos('Image printed', sStatus)>0) then
    if pos('Image printed', sStatus) > 0 then
    begin
      sParam := MagPiece(sReason, '^', 1) + '^' +  // 1 Accesss Type
                idmodobj.GetRPCBroker1.User.DUZ + '^' +   // 2 User DUZ
                IObj.Mag0 + '^' +                  // 3 Image IEN
                'IMGPRT ROI' + '^' +               // 4 User Interface Software
                IObj.DFN + '^' +                   // 5 Patient DFN
                '1' + '^' +                        // 6 Image count
                MagPiece(sReason, '^', 2);         // 7 Additional Data
      idmodobj.GetMagDBBroker1.RPLogCopyAccess(sParam, IObj, PRINT_IMAGE);
    end;
  end;
end;

procedure TfrmReleaseOfInfoPrint.FormClose(Sender: TObject;
  var Action: TCloseAction);
var
  i: Integer;
begin
  {/P117 GEK  override blocked images with 'TEMP IGNORE BLOCK' key}
  AddDelKey('TEMP IGNORE BLOCK',false);
  slSummary.Free;
  MagIGManager.AllowTextFiles := false;
  upref.SuppressPrintSummary := self.cbSuppress.Checked;

  ROIRestUtility.Free;  {/ P130 - JK 4/30/2012 /}

  {Free the URL object assigned to the TStrings item before freeing the string list object}
  if QueueList <> nil then
  begin
    for i := 0 to QueueList.Count - 1 do
      QueueList.Objects[i].Free;

    QueueList.Free;
  end;

  RemoteRoiIENs.Free;
end;

procedure TfrmReleaseOfInfoPrint.btnPrintClick(Sender: TObject);
begin
if PrintDialog1.Execute then  //gek test 508
begin // gek test 508
  btnPrint.Enabled := false;
  btnClose.Enabled := false   ; //gek
  try
    lstSummary.Clear;
    slSummary.Clear;
    RunPrintSession;
  finally
    btnPrint.Enabled := true;
    btnClose.enabled := true;    //gek
  end;
end; //gek test 508
end;

procedure TfrmReleaseOfInfoPrint.btnAbortClick(Sender: TObject);
begin
  if (Printer.Printing) and (MessageDlg('Cancel printing?', mtConfirmation, [mbYes, mbNo], 0) = mrYes) then
  begin
    AddSummaryItemAndScroll(' ****   Print job was Aborted.  ****    '); {/p117 gek Show Abort On Screen also.}
    printer.NewPage;
    printer.canvas.textout(MARGIN, 0, 'Print job was Aborted.');
    Printer.Abort;
    btnAbort.Enabled := false;
  end;
end;

procedure TfrmReleaseOfInfoPrint.FormCreate(Sender: TObject);
begin

  try
  GetFormPosition(Self As TForm);
//gek not here.  do this when form shows. >  AddDelKey('TEMP IGNORE BLOCK',TRUE);
//gek if form is created at startup of the application..  then 'TEMP IGNOR..... is always active.
  with ROIMag4Viewer do
  begin
    ViewerStyle := magvsDynamic;
    ViewStyle := MagViewerViewFull;
    ClearBeforeAddDrop := true;
    RowCount := 1;
    ColumnCount := 1;
    Image1.Visible := false;
    lbPnlTop.Visible := false;
    pnlTop.Visible := false;
    TopPanel.Caption := 'Image Processing ';
    TopPanel.Font := lblDOB.Font;
    Color := FSAppBackGroundColor;
    {/p117 gek, information uses clInfoBk}
    // pnlPatientInfo.Color := FSAppBackGroundColor;
    self.pnlButtons.Color := FSAppBackGroundColor;
    self.cbSuppress.color := FSAppBackGroundColor;

  end;

  ROIMag4Viewer.SetRowColCount(1, 1);
  ROIMag4Viewer.ReFreshImages;

  {/ P130 - JK 4/25/2012 /}
  ROIRestUtility := TMagROIRestUtility.Create;
  LocalCommInfo := MagRemoteBrokerManager1.GetLocalSite;

  ROIRestUtility.VixServer := LocalCommInfo.VixServer;
  ROIRestUtility.VixPort   := LocalCommInfo.VixPort;

  {/ P130 - JK 4/25/2012 /}
  if ROIRestUtility.IsROIRestWebServiceAvailable then
  begin
    pgROIOutput.ActivePage := tsToFile;
    tsToFile.Enabled := True;
    lbToFileActive.Caption := '';
    cbRadiologyCDQueue.Enabled := True;
    btnProcessROIRequest.Enabled := True;
  end
  else
  begin
    pgROIOutput.ActivePage := tsToPrint;
    tsToFile.Enabled := True;
    lbDicomInfo.Caption := '';
    lbToFileActive.Caption := 'VIX ROI web service is not available. Contact IRM';
    cbRadiologyCDQueue.Enabled := False;
    btnProcessROIRequest.Enabled := False;
  end;

  except
    on E:Exception do
    begin
      showmessage(e.message);
      pgROIOutput.ActivePage := tsToPrint;
      tsToFile.Enabled := True;
      lbDicomInfo.Caption := '';
      lbToFileActive.Caption := 'VIX ROI web service is not available. Contact IRM';
      cbRadiologyCDQueue.Enabled := False;
      btnProcessROIRequest.Enabled := False;
    end;
  end;

  RemoteRoiIENs := TStringlist.Create;
end;

procedure TfrmReleaseOfInfoPrint.FormDestroy(Sender: TObject);
begin
  SaveFormPosition(Self As TForm);
end;

//routine to add items(image status, summary info, etc...) to the form list box, which in tuen is used to write out summary page
//and add entries to the multi image print file in VistA db
//after item is added, algoright user to make sure component scrolls to last line of listbox on the screen
procedure TfrmReleaseOfInfoPrint.AddSummaryItemAndScroll(s: string);
begin
   lstSummary.Items.Add(s);
   lstSummary.TopIndex := lstSummary.Count - trunc(lstSummary.Height/20);
end;

{/ P122 - JK 8/10/2011 - this method prepares the annotation information. Even though ROI doesn't
   print RAD package images, it may in the near future in the pending ROI patch.  Leaving the
   logic here in case it can be used later on. /}
//procedure TfrmReleaseOfInfoPrint.GetAnnotationPrintInfoLine(VGear: TMag4VGear; var AnnotationInfoLine: String);
//begin
//  AnnotationInfoLine := '';
//  if VGear.PI_ptrData.Annotated then
//  begin
//    if VGear.PI_ptrData.Package = 'RAD' then
//    begin
//      if VGear.AnnotationComponent.RADAnnotationCount > 0 then
//      begin
//        AnnotationInfoLine := AnnotationInfoLine + ' [' +
//                    IntToStr(VGear.AnnotationComponent.RADAnnotationCount) + ' annotations / ';
//
//        if VGear.AnnotationComponent.isRadVisible then
//          AnnotationInfoLine := AnnotationInfoLine + '0 hidden]'
//        else
//          AnnotationInfoLine := AnnotationInfoLine +
//                      IntToStr(VGear.AnnotationComponent.RADAnnotationCount) + ' hidden]';
//        AnnotationInfoLine := AnnotationInfoLine + ' Some annotations may be approximations of VistARad-originated annotations';
//      end;
//    end
//    else
//    begin
//      if VGear.AnnotationComponent.MarkCountCurrentPage = 1 then
//        AnnotationInfoLine := AnnotationInfoLine + ' [' +
//        IntToStr(VGear.AnnotationComponent.MarkCountCurrentPage) + ' annotation / ' +
//        IntToStr(VGear.AnnotationComponent.HiddenMarkCountCurrentPage) + ' hidden]'
//      else
//        AnnotationInfoLine := AnnotationInfoLine + ' [' +
//        IntToStr(VGear.AnnotationComponent.MarkCountCurrentPage) + ' annotations / ' +
//        IntToStr(VGear.AnnotationComponent.HiddenMarkCountCurrentPage) + ' hidden]';
//    end;
//  end;
//end;

//        procedure TfrmReleaseOfInfoPrint.GetAnnotationPrintInfoLine(VGear: TMag4VGear; var AnnotationInfoLine: String);
//        begin
//          AnnotationInfoLine := '';
////          if VGear.PI_ptrData.Annotated then
//          if VGear.AnnotationComponent <> nil then
//          begin
//            if VGear.AnnotationComponent.MarkCountCurrentPage > 0 then
//            begin
//              {/p122t3 dmmn 9/22/11 - since the there is virtually no differnces between printing out
//              images in full res viewer and Rad viewer, we should really use the same call and reduce
//              unneccessarry calls. /}
//              if VGear.AnnotationComponent.MarkCountCurrentPage = 1 then
//                AnnotationInfoLine := AnnotationInfoLine + ' [' +
//                IntToStr(VGear.AnnotationComponent.MarkCountCurrentPage) + ' annot / ' +
//                IntToStr(VGear.AnnotationComponent.HiddenMarkCountCurrentPage) + ' hidden]'
//              else
//                AnnotationInfoLine := AnnotationInfoLine + ' [' +
//                IntToStr(VGear.AnnotationComponent.MarkCountCurrentPage) + ' annots / ' +
//                IntToStr(VGear.AnnotationComponent.HiddenMarkCountCurrentPage) + ' hidden]';
//
//              {/ All we really need to add here is the warnings for approximated vista rad annotations/}
//              if (VGear.PI_ptrData.Package = 'RAD') and (VGear.AnnotationComponent.HasOddRADMarks) then
//                AnnotationInfoLine := AnnotationInfoLine + ' Some annots are approximations of VistARad annots.';
//            end;
//
//            {/ P122 JK 9/14/2011 /}
//  //          if (VGear.AnnotationComponent.MarkCountCurrentPage >= 1) or
//  //             (VGear.AnnotationComponent.RADAnnotationCount > 0) or
//  //             (VGear.AnnotationComponent.AnnotsModified) then
//            if (VGear.AnnotationComponent.MarkCountCurrentPage > 0) then  //dmmn
//            begin
//              AnnotationInfoLine := AnnotationInfoLine + ' Prnt: ' + FormatDateTime('m/d/yyyy', Now);
//              if VGear.AnnotationComponent.AnnotsModified then
//                AnnotationInfoLine := AnnotationInfoLine + ' with unsaved annots.';
//            end;
//
//            if (VGear.AnnotationComponent.HasOutsideAnnotations) then
//            begin
//              AnnotationInfoLine := AnnotationInfoLine + ' Some annots are outside printed area.';
//            end;
//          end;
//        end;

        procedure TfrmReleaseOfInfoPrint.GetAnnotationPrintInfoLine(VGear: TMag4VGear; var AnnotationInfoLine: String);
        begin
          AnnotationInfoLine := '';
//          if VGear.PI_ptrData.Annotated then
          if VGear.AnnotationComponent <> nil then
          begin
            if VGear.AnnotationComponent.MarkCountCurrentPage > 0 then
            begin
              {/p122t3 dmmn 9/22/11 - since the there is virtually no differnces between printing out
              images in full res viewer and Rad viewer, we should really use the same call and reduce
              unneccessarry calls. /}
              if VGear.AnnotationComponent.MarkCountCurrentPage = 1 then
                AnnotationInfoLine := AnnotationInfoLine +
                IntToStr(VGear.AnnotationComponent.MarkCountCurrentPage) + ' annotation/' +
                IntToStr(VGear.AnnotationComponent.HiddenMarkCountCurrentPage) + ' hidden'
              else
                AnnotationInfoLine := AnnotationInfoLine + ' ' +
                IntToStr(VGear.AnnotationComponent.MarkCountCurrentPage) + ' annotations/' +
                IntToStr(VGear.AnnotationComponent.HiddenMarkCountCurrentPage) + ' hidden';

              {/ All we really need to add here is the warnings for approximated vista rad annotations/}
              if (VGear.PI_ptrData.Package = 'RAD') and (VGear.AnnotationComponent.HasOddRADMarks) then
                AnnotationInfoLine := AnnotationInfoLine + ' Some annots are approximations of VistARad annots.';
            end;

            {/ P122 JK 9/14/2011 /}
  //          if (VGear.AnnotationComponent.MarkCountCurrentPage >= 1) or
  //             (VGear.AnnotationComponent.RADAnnotationCount > 0) or
  //             (VGear.AnnotationComponent.AnnotsModified) then
            if (VGear.AnnotationComponent.MarkCountCurrentPage > 0) then  //dmmn
            begin
              AnnotationInfoLine := AnnotationInfoLine + ' Prnt ' + FormatDateTime('m/d/yyyy', Now);
              if VGear.AnnotationComponent.AnnotsModified then
                AnnotationInfoLine := AnnotationInfoLine + ' w/unsaved annots.';
            end;

            if (VGear.AnnotationComponent.HasOutsideAnnotations) then
            begin
              AnnotationInfoLine := AnnotationInfoLine + ' Some annots are outside printed area.';
            end;
          end;
        end;

function TfrmReleaseOfInfoPrint.CountDICOMs: Integer;
var
  i: integer;
  IObj: TImageData;
  NumberOfDICOMStudies: Integer;

    procedure ProcessImageGroup(IObj: TImageData; var NumberOfDICOMStudies: Integer);
    var
      slGroup: TStringList;
      GroupObj: TImageData;
      i: integer;
      sStatus: string;
    begin
      GroupObj := TImageData.Create; //to remove compiler warning
      slGroup := TStringList.Create;
      sStatus := GROUP;
      try
        idmodobj.GetMagDBBroker1.RPMaggGroupImages(IObj, slGroup, false, 'D');

        if slgroup.Count < 2 then
          Exit;

        for i := 1 to slGroup.Count - 1 do
        begin
          GroupObj := GroupObj.StringToTImageData(slGroup.Strings[i]);
          if (GroupObj.ImgType = 100) or (GroupObj.ImgType = 3) then
          begin
            Inc(NumberOfDICOMStudies);
            Exit;
          end;
        end;
      finally
        slGroup.Free;
        GroupObj.Free;
      end;
    end;

begin
  NumberOfDICOMStudies   := 0;

  for i := 0 to ListOfImagesToPrint.Items.Count - 1 do
  begin
    if (not UsingCheckBoxes) or (ListOfImagesToPrint.Items[i].Checked) then
    begin
      IObj := TMagListViewData(ListOfImagesToPrint.Items[i].Data).IObj;
      if (IObj.ImgType = 3) or (IObj.ImgType = 100) then
        Inc(NumberOfDICOMStudies)
      else if IObj.ImgType = 11 then
        ProcessImageGroup(IObj, NumberOfDICOMStudies);

    end;
  end;
  Result := NumberOfDICOMStudies;
end;


initialization

  SetLength(TrueBoolStrs,1);
  SetLength(FalseBoolStrs,1);
  TrueBoolStrs[0] := '1';
  FalseBoolStrs[0] := '0';

end.
