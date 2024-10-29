unit fMagReleaseOfInfoSaveJob;

{
Package: MAG - VistA Imaging
WARNING: Per VHA Directive 10-93-142 this unit should not be modified.
Date Created:   April, 2012
Site Name: Silver Spring, OIFO
Developers: Jerry Kashtan
[==  unit fMagReleaseOfInfoSaveJob

  Description: This unit fetches and saves completed ROI jobs that are
  on the server.
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
  Dialogs, StdCtrls, uMagClasses, uMagDefinitions, Buttons, ExtCtrls, FileCtrl,
  ShellAPI,
  MagRemoteBrokerManager,  {/ P130 JK 4/30/2012 - need visibility to VIX properties /}
  MagROIRestUtility, Menus;

type
  Tfrm_ROI_SaveJob = class(TForm)
    Label2: TLabel;
    Panel1: TPanel;
    Label1: TLabel;
    edDiscloseToLocation: TEdit;
    BitBtn1: TBitBtn;
    BitBtn2: TBitBtn;
    lbPatInfo: TLabel;
    DirectoryListBox1: TDirectoryListBox;
    pnlRadiologyRouting: TPanel;
    Label3: TLabel;
    lbRadiologyMessage: TLabel;
    pmuDirectory: TPopupMenu;
    CreateaSubdirectory1: TMenuItem;
    Label4: TLabel;
    procedure BitBtn2Click(Sender: TObject);
    procedure DirectoryListBox1Change(Sender: TObject);
    procedure FormCreate(Sender: TObject);
    procedure BitBtn1Click(Sender: TObject);
    procedure FormShow(Sender: TObject);
    procedure FormClose(Sender: TObject; var Action: TCloseAction);
    procedure DirectoryListBox1MouseDown(Sender: TObject; Button: TMouseButton;
      Shift: TShiftState; X, Y: Integer);
    procedure CreateaSubdirectory1Click(Sender: TObject);
    procedure DirectoryListBox1KeyDown(Sender: TObject; var Key: Word;
      Shift: TShiftState);
  private
//    FUserDir: String;
    FPatName: String;
    FPatSSN4: String;
    FResultUri: String;
    FRadiologyRouting: String;
    FLocalCommInfo: TVistaSite;
    FROIRestUtility: TMagROIRestUtility;
    procedure SaveJobToFolder;
    procedure OpenDisclosureFolder;
  public
//    property UserDir: String read FUserDir write FUserDir;
    property PatName: String read FPatName write FPatName;
    property PatSSN4: String read FPatSSN4 write FPatSSN4;
    property ResultUri: String read FResultUri write FResultUri;
    property LocalCommInfo: TVistaSite read FLocalCommInfo write FLocalCommInfo;
    property RadiologyRouting: String read FRadiologyRouting write FRadiologyRouting;
    property ROIRestUtility: TMagROIRestUtility read FROIRestUtility write FROIRestUtility;
  end;

var
  frm_ROI_SaveJob: Tfrm_ROI_SaveJob;

implementation

{$R *.dfm}

uses
  ShLwApi,
  IMagInterfaces;

procedure Tfrm_ROI_SaveJob.FormClose(Sender: TObject; var Action: TCloseAction);
begin
  ROIRestUtility.Free;

//  UserDir   := '';
  PatName   := '';
  PatSSN4   := '';
  ResultUri := '';
end;

procedure Tfrm_ROI_SaveJob.FormCreate(Sender: TObject);
begin
//  UserDir                     := GSess.ROISaveDirectory;
//  DirectoryListBox1.Directory := UserDir;
//  edDiscloseToLocation.Text   := UserDir;
  DirectoryListBox1.Directory := GSess.ROISaveDirectory;
  edDiscloseToLocation.Text   := GSess.ROISaveDirectory;

  Self.Color    := FSAppBackGroundColor;
  Panel1.Color  := FSAppBackGroundColor;
  Self.Position := poOwnerFormCenter;

  ROIRestUtility := TMagROIRestUtility.Create;
  LocalCommInfo := MagRemoteBrokerManager1.GetLocalSite;
  ROIRestUtility.setLocalBrokerPort(LocalCommInfo.VistaPort); {/ P130 - JK 9/12/2012 /}

  ROIRestUtility.VixServer := LocalCommInfo.VixServer;
  ROIRestUtility.VixPort   := LocalCommInfo.VixPort;
end;

procedure Tfrm_ROI_SaveJob.FormShow(Sender: TObject);
var
  Msg: String;
begin
  {/ P130 - JK 4/25/2012 /}
  if ROIRestUtility.IsROIRestWebServiceAvailable = False then
  begin
    Msg := 'VIX ROI web service is not available. Contact IRM';
    MessageDlg(Msg, mtWarning, [mbOK], 0);
    MagAppMsg('s', 'Tfrm_ROI_Statuses.FormShow: ' + Msg);
    Exit;
  end;

  lbPatInfo.Caption := PatName + '      SSN4: ' + PatSSN4;

  if RadiologyRouting <> '' then
  begin
    pnlRadiologyRouting.Visible := True;
    lbRadiologyMessage.Caption := RadiologyRouting;
  end
  else
  begin
    pnlRadiologyRouting.Visible := False;
    lbRadiologyMessage.Caption := '';
  end;

end;

procedure Tfrm_ROI_SaveJob.BitBtn1Click(Sender: TObject);
begin
  if MessageDlg('Download the disclosure job from the server to:' + #13#10 +
    edDiscloseToLocation.Text + #13#10, mtConfirmation, [mbYes, mbCancel], 0) = mrYes then
  begin
    GSess.ROISaveDirectory := edDiscloseToLocation.Text;
    SaveJobToFolder;
  end
  else
    MessageDlg('The download from the server has been cancelled', mtConfirmation,
    [mbOK], 0);
end;

procedure Tfrm_ROI_SaveJob.SaveJobToFolder;
var
  FS: TFileStream;
  MS: TMemoryStream;
  myFile: File of Word;
  FileName: String;
  DisclosureDir: String;
  Msg: String;
  ErrorCleanup: Boolean;

  function MakeLegalUNC(S: String): String;
  var
    i: Integer;
  begin
    for i := 1 to Length(S) do
      if PathGetCharType(S[i]) in [GCT_INVALID, GCT_SEPARATOR] then
        S[i] := '_';
    Result := S;
  end;
begin
  Screen.Cursor := crHourglass;
  ErrorCleanup := False;
  try
    if DirectoryExists(GSess.ROISaveDirectory) = False then
    begin
      Msg := 'Cannot find folder: ' + GSess.ROISaveDirectory + #13#10 +
             'Create the folder in File Explorer before attempting to save this job, or' + #13#10 +
             'select a different folder to save the job to.';
      MessageDlg(Msg, mtWarning, [mbOK], 0);
      MagAppMsg('s', 'Tfrm_ROI_Statuses.FormShow: ' + Msg);
      Exit;
    end;

    PatName := PatName + '_' + PatSSN4;
    PatName := MakeLegalUNC(PatName) + '_' + FormatDateTime('mm_dd_yyyy_hh_mm_ss', Now);
    Filename := GSess.ROISaveDirectory + '\' + PatName + '.zip';

    if FileExists(Filename) then
      DeleteFile(Filename);

    AssignFile(MyFile, Filename);
    FileMode := fmOpenWrite;
    Rewrite(myFile);
    CloseFile(myFile);

    FS := TFileStream.Create(Filename, fmOpenWrite);
    MS := TMemoryStream.Create;
    try

      ROIRestUtility.GetDisclosureZip(resultURI, MS);

      if MS = nil then
      begin
        Msg := 'The disclosure for: ' + PatName +  #13#10 +  {/ P130 - JK 7/11/2012 /}
               'could not be retrieved from the server.' + #13#10 +
               'ROI jobs are purged from the server after a period of time.' + #13#10 +
               'You can resubmit your ROI job to regenerate the ROI disclosure.';
        Showmessage(Msg);
        MagAppMsg('s', Msg);
        ErrorCleanup := True;
        Exit;      
      end;

      MS.Position := 0;
      if MS.Size > 0 then
      begin
        Msg := 'The disclosure for: ' + PatName + #13#10 +
                   'is ready and is located at: ' + #13#10 +
                   Filename;

        MagAppMsg('s', Msg);
        FS.CopyFrom(MS, MS.Size);
      end
      else
        {/ P130 - JK 7/11/2012 /}
        Msg := 'The disclosure for: ' + PatName + #13#10 +
               'could not be retrieved from the server. ' + #13#10 +
               'Older completed jobs are purged from the server.' + #13#10 +
               'Please resubmit your disclosure request.';

        MagAppMsg('s', Msg);
    finally
      FS.Free;
      MS.Free;
    end;


    if MessageDlg('The ROI job has been saved. Would you like to switch to that folder?',
      mtInformation, [mbYes, mbNo], 0) = mrYes then
      OpenDisclosureFolder;

  finally
    if ErrorCleanup then
      DeleteFile(Filename);

    Screen.Cursor := crDefault;
    Close;
  end;
end;

procedure Tfrm_ROI_SaveJob.OpenDisclosureFolder;
begin
  ShellExecute(Application.Handle, PChar('explore'), PChar(GSess.ROISaveDirectory), nil, nil, SW_SHOWNORMAL);
end;

procedure Tfrm_ROI_SaveJob.BitBtn2Click(Sender: TObject);
begin
  Close;
end;


procedure Tfrm_ROI_SaveJob.CreateaSubdirectory1Click(Sender: TObject);
var
  SubDir: String;
  UNC: String;
begin
  Subdir := InputBox('Create Subdirectory', 'Enter subdirectory name', 'ROI');
  UNC := edDiscloseToLocation.Text + '\' + Subdir;
  if CreateDir(UNC) then
  begin
    DirectoryListBox1.Refresh;
    DirectoryListBox1.Directory := UNC;
    edDiscloseToLocation.Text := UNC;
    GSess.ROISaveDirectory := UNC;
  end
  else
    MessageDlg('Cannot create folder: ' + UNC + #13#10#13#10 +
    'Ensure that the subfolder name you entered is a Windows-legal name.' + #13#10 +
    'You cannot use <,>,:,",/,\,|,?, or *, and ' + #13#10 +
    'the length of the path and filename must be less than 260 characters', mtWarning, [mbOK], 0);
  
end;

procedure Tfrm_ROI_SaveJob.DirectoryListBox1Change(Sender: TObject);
begin
  GSess.ROISaveDirectory    := DirectoryListBox1.Directory;
  edDiscloseToLocation.Text := GSess.ROISaveDirectory;
end;

procedure Tfrm_ROI_SaveJob.DirectoryListBox1KeyDown(Sender: TObject;
  var Key: Word; Shift: TShiftState);
begin
  edDiscloseToLocation.Text := DirectoryListBox1.GetItemPath(DirectoryListBox1.ItemIndex);
end;

procedure Tfrm_ROI_SaveJob.DirectoryListBox1MouseDown(Sender: TObject;
  Button: TMouseButton; Shift: TShiftState; X, Y: Integer);
begin
  edDiscloseToLocation.Text := DirectoryListBox1.GetItemPath(DirectoryListBox1.ItemIndex);
end;

end.
