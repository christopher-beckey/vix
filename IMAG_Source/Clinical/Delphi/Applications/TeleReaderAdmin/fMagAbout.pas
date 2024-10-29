unit fMagAbout;
   {
   Package: MAG - VistA Imaging
   WARNING: Per VHA Directive 10-93-142 this unit should not be modified.
   Date Created:  1998, Updated 08/2009
   Site Name: Silver Spring, OIFO
   Developers: Garrett Kirin, Bill Balshem
   Description: Imaging About Box.  Generic, to be used by
                 any Imaging Application.
    08/2009 - Updated form to be less dependent on other VA units.
     MagListView component for to list versions, replaced with A TListView
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

interface

uses WinTypes, WinProcs, Classes, Graphics, Forms, Controls, StdCtrls,
  Buttons, ExtCtrls, Sysutils, jpeg, shellapi, Dialogs, ComCtrls, VA508AccessibilityManager;

type
  TfrmAbout = class(TForm)
    amgrMain: TVA508AccessibilityManager;
    pnlMain: TPanel;
    imgProgramIcon: TImage;
    lbAlign: TLabel;
    lbFileDescription: TStaticText;
    pnlTopwithLogo: TPanel;
    imgVistALogo: TImage;
    lbSilverSpringinfo: TStaticText;
    lbImagingProjectinfo: TStaticText;
    lbDevelopedbyinfo: TStaticText;
    pnlUnathorizedtext: TPanel;
    pnlComputedFields: TPanel;
    lbfilenameprompt: TStaticText;
    lbfilename: TStaticText;
    lbVersionprompt: TStaticText;
    lbversion: TStaticText;
    lbPatchprompt: TStaticText;
    lbPatch: TStaticText;
    lbfiledateprompt: TStaticText;
    lbfiledate: TStaticText;
    lbfilesizeprompt: TStaticText;
    lbfilesize: TStaticText;
    lbCRCPrompt: TStaticText;
    lbVHAinfo: TStaticText;
    lbCRC: TStaticText;
    lbServerVersionprmpt: TStaticText;
    lbServerVersion: TStaticText;
    lbDelphiVersionprompt: TStaticText;
    lbOSVersionPrompt: TStaticText;
    lbDelphiVersion: TStaticText;
    lbOSVersion: TStaticText;
    pnlOKbtn: TPanel;
    btnOK: TBitBtn;
    lbInstalledVersions: TStaticText;
    lbVerPatch: TStaticText;
    lbStatusPrompt: TStaticText;
    lbStatus: TStaticText;
    lvVersions: TListView;
    lbUnauthorizedtextinfo: TMemo;
    procedure btnOKClick(Sender: TObject);
    procedure FormCreate(Sender: TObject);
  private
    procedure DrawAppIcon(Sender: TObject);
    function CalculateCRC(AppName : String) : integer;
    procedure PopVersionListView(sVersions: TStrings);
    procedure ClearNonStaticLabelCaptions;
  public
    procedure execute(AppName: string = '';reqserver: string = ''; installlist : Tstrings = nil; status : string = '');
  end;

  function GetFieldCount(STR, DEL: string): INTEGER;

var
  frmAbout: TfrmAbout;
  const formname : string = 'frmAbout';
implementation

uses
  MagFileVersion, uMagCRC32;

{$R *.DFM}

procedure TfrmAbout.FormCreate(Sender: TObject);
begin
  pnlMain.Align := alclient;
end;

procedure TfrmAbout.btnOKClick(Sender: TObject);
begin
  close;
end;

function TfrmAbout.CalculateCRC(AppName : String) : integer;
var stream : TmemoryStream;
begin
  result := 0;
  try
    Stream:=TMemoryStream.Create;
    Stream.LoadFromFile(AppName);
    result := GetMemoryStreamCrc32(Stream);
    Stream.Free;
  except
    on E : Exception do
    begin
    end;
  end;
end;

procedure TfrmAbout.DrawAppIcon(Sender: TObject);
var IconIndex : word; icon : Ticon;
begin
  Icon := TIcon.create;
  IconIndex := 0;
  icon.Handle:=ExtractAssociatedIcon(hInstance,pchar(application.exename), IconIndex) ;
  DrawIcon(imgprogramicon.Canvas.Handle, 0, 0, icon.handle) ;
  icon.free;
end;

function GetFieldCount(STR, DEL: string): INTEGER;
var I, J: INTEGER;
  ESTR: BOOLEAN;
begin
  ESTR := FALSE;
  I := 0;
  while not ESTR do
  begin
    I := I + 1;
    if (POS(DEL, STR) = 0) then ESTR := TRUE;
    J := POS(DEL, STR); STR := COPY(STR, J + 1, LENGTH(STR));
  end;
  result := I;
end;

procedure TfrmAbout.PopVersionListView(sVersions: TStrings);
var i, j, iColumnCount: integer;
    LI: Tlistitem;
    NewColumn: TListColumn;
    s: string;
const COL_LEN = 150; DEL = '^';
begin
  iColumnCount := GetFieldCount(sVersions[0], DEL);
  with lvVersions do
  begin
    Clear;
    //Populate Columns
    for i := 1 to iColumnCount do
    begin
      NewColumn := Columns.Add;
      NewColumn.caption := StringReplace(MagSTRPiece(sVersions[0], DEL, i), '~S1', '', [rfReplaceAll, rfIgnoreCase]);
      NewColumn.width := COL_LEN;
    end;
    //Populate Rows
    for i := 1 to sVersions.count - 1 do
    begin
      s := sVersions[i];
      LI := Items.Add;
      LI.Caption := MagSTRPiece(s, '^', 1);
      for j := 2 to iColumnCount do LI.SubItems.Add(MagSTRPiece(s, '^', j));
    end;
  end; //with lvVersions...
end;

procedure TfrmAbout.ClearNonStaticLabelCaptions;
var i: integer;
begin
  for i := 0 to ControlCount -1 do
    if (Controls[i] is TLabel) and (TLabel(Controls[i]).Visible) and (TLabel(Controls[i]).Tag = 1) then
      TLabel(Controls[i]).Caption := '';
end;

procedure TfrmAbout.execute(AppName: string = '';reqserver: string = ''; installlist : Tstrings = nil; status : string = '');
var MagVerPatch: string; CRC: integer;
begin

 if AppName = '' then appname := Application.exename;

 with TfrmAbout.Create(nil) do
 begin

    ClearNonStaticLabelCaptions;
    //get application and version info
    lbFileDescription.caption := MagGetFileDescription(AppName);
    caption := 'About: ' + MagGetProductName(AppName);
    magVerPatch := MagGetFileVersionInfo(AppName);
    lbVerPatch.Caption := magVerPatch;
    lbVersion.caption := magSTRpiece(magVerPatch,'.',1) + '.' + magSTRpiece(magVerPatch,'.',2);
    lbPatch.caption := magSTRpiece(magVerPatch,'.',3); 
    //required server version can be passed as parameter, if it isn't it defaults to the version of the Client
    if reqserver = '' then reqserver := lbVersion.caption + '.'+magSTRpiece(MagVerPatch,'.',3)+'.'+magSTRpiece(MagVerPatch,'.',4);
    lbServerVersion.caption := reqserver;
    lbfilename.caption := AppName;
    lbfilesize.caption := FloatToStr((GetExeFileSize(AppName) div 1024) + 1) + ' KB';
    lbfiledate.caption := formatdatetime('mm/dd/yy  h:nn  am/pm', FileDateToDateTime(FileAge(AppName)));
    lbDelphiVersion.caption := MagGetFileVersionInfo(AppName,false);
    lbOSVersion.caption := MagGetOSVersion;
    CRC := CalculateCRC(AppName);
    lbCRC.Caption := IntToHex(CRC,8);
    DrawAppIcon(self);
    if (installlist <> nil) and (installlist.Count > 1 ) then PopVersionListView(installlist)
    else
    begin
      lvVersions.Clear;
      lvVersions.Hide;
      lbInstalledVersions.caption := lbInstalledVersions.caption + '  Not Available';
    end;
    //Patch 59.  Show status of Version
    lbStatusPrompt.Visible := (status <> '');
    lbStatus.Caption := status;
    showmodal;
    free;
  end;

end;

end.
