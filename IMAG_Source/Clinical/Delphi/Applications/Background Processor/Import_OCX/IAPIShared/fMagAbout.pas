Unit FMagAbout;
   {
   Package: MAG - VistA Imaging
   WARNING: Per VHA Directive 10-93-142 this unit should not be modified.
   Date Created:  1998
   Site Name: Silver Spring, OIFO
   Developers: Garrett Kirin
   Description: Imaging About Box.  Generic, to be used by
                 any Imaging Application.
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

Interface

Uses
  Buttons,
  Classes,
  Controls,
  ExtCtrls,
  Forms,
  Graphics,
  Stdctrls,
  ComCtrls,
  Jpeg
  ,
  cMagListViewLite
  ;

//Uses Vetted 20090929:ComCtrls, Dialogs, jpeg, WinProcs, fmxutils, uMagCRC32, umagutils, MagFileVersion, shellapi, Sysutils, WinTypes

Type
  TfrmAbout = Class(TForm)
    PnlMain: Tpanel;
    ImgProgramIcon: TImage;
    LbAlign: Tlabel;
    LbFileDescription: Tlabel;
    PnlTopwithLogo: Tpanel;
    ImgVistALogo: TImage;
    LbSilverSpringinfo: Tlabel;
    LbImagingProjectinfo: Tlabel;
    LbDevelopedbyinfo: Tlabel;
    PnlUnathorizedtext: Tpanel;
    LbUnauthorizedtextinfo: Tlabel;
    PnlComputedFields: Tpanel;
    Lbfilenameprompt: Tlabel;
    Lbfilename: Tlabel;
    LbVersionprompt: Tlabel;
    Lbversion: Tlabel;
    LbPatchprompt: Tlabel;
    LbPatch: Tlabel;
    Lbfiledateprompt: Tlabel;
    Lbfiledate: Tlabel;
    Lbfilesizeprompt: Tlabel;
    Lbfilesize: Tlabel;
    LbCRCPrompt: Tlabel;
    LbVHAinfo: Tlabel;
    LbCRC: Tlabel;
    LbServerVersionprmpt: Tlabel;
    LbServerVersion: Tlabel;
    LbDelphiVersionprompt: Tlabel;
    LbOSVersionPrompt: Tlabel;
    LbDelphiVersion: Tlabel;
    LbOSVersion: Tlabel;
    PnlOKbtn: Tpanel;
    btnOK: TBitBtn;
    LbInstalledVersions: Tlabel;
    LbVerPatch: Tlabel;
    LbStatusPrompt: Tlabel;
    LbStatus: Tlabel;

    pnlListViewLite: Tpanel;
    Procedure btnOKClick(Sender: Tobject);
    Procedure FormCreate(Sender: Tobject);
  Private
    MagLVLite1: TMagListViewLite;
    Procedure DrawAppIcon(Sender: Tobject);
    Function CalculateCRC(AppName: String): Integer;
  Public
    Procedure Execute(AppName: String = ''; Reqserver: String = ''; Installlist: TStrings = Nil; Status: String = '');
  End;

Var
  FrmAbout: TfrmAbout;
Const
  Formname: String = 'frmAbout';
Implementation
Uses
  WinTypes,
  SysUtils,
  Shellapi
//imaging
  ,
  Magfileversion
  ,
  Umagutils8
  ,
  UMagCRC32
  ,
  Fmxutils

  ;

{$R *.DFM}

Procedure TfrmAbout.btnOKClick(Sender: Tobject);
Begin
  Close;
End;

Procedure TfrmAbout.Execute(AppName: String = ''; Reqserver: String = ''; Installlist: TStrings = Nil; Status: String = '');
Var
  MagVerPatch: String;
  CRC: Integer;
Begin
  If AppName = '' Then AppName := Application.ExeName;
  With TfrmAbout.Create(Nil) Do
  Begin
  { assure all are null }
    LbFileDescription.caption := '';
    Lbversion.caption := '';
    Lbfilename.caption := '';
    Lbfilesize.caption := '';
    Lbfiledate.caption := '';
    LbPatch.caption := '';
    LbCRC.caption := '';
    LbVerPatch.caption := '';

    LbFileDescription.caption := MagGetFileDescription(AppName);
    caption := 'About: ' + MagGetProductName(AppName);
    MagVerPatch := MagGetFileVersionInfo(AppName);
    LbVerPatch.caption := MagVerPatch;
    Lbversion.caption := MagPiece(MagVerPatch, '.', 1) + '.' + MagPiece(MagVerPatch, '.', 2);
    LbPatch.caption := MagPiece(MagVerPatch, '.', 3); //p63 + ' T' + magpiece(magVerPatch,'.',4);
  { required server version can be passed as parameter, if it isn't it defaults to
    the version of the Client}
    If Reqserver = '' Then Reqserver := Lbversion.caption + '.' + MagPiece(MagVerPatch, '.', 3) + '.' + MagPiece(MagVerPatch, '.', 4);
    LbServerVersion.caption := Reqserver;
    Lbfilename.caption := AppName;
    Lbfilesize.caption := Inttostr((Getfilesize(AppName) Div 1024) + 1) + ' KB';
    Lbfiledate.caption := Formatdatetime('mm/dd/yy  h:nn  am/pm', FILEDATETIME(AppName));
    LbDelphiVersion.caption := MagGetFileVersionInfo(AppName, False);
    LbOSVersion.caption := MagGetOSVersion;
    CRC := CalculateCRC(AppName);
  (*   Label1.Caption:='CRC:  '+IntToHex(CRC,8);  *)
    LbCRC.caption := IntToHex(CRC, 8);
    DrawAppIcon(Self);
    If (Installlist <> Nil) And (Installlist.Count > 1) Then
    Begin

      MagLVLite1.LoadListFromStrings(Installlist);
    End
    Else
    Begin
      MagLVLite1.ClearItems;
      MagLVLite1.Hide;
      LbInstalledVersions.caption := LbInstalledVersions.caption + '  Not Available';
    End;
  (*e1    maglistview1.LoadListFromStrings(installlist)
        else
          begin
            maglistview1.ClearItems;
            maglistview1.Hide;
            lbInstalledVersions.caption := lbInstalledVersions.caption + '  Not Available';
          end;
*)
  { Patch 59.  Show status of Version}
    LbStatusPrompt.Visible := (Status <> '');
    LbStatus.caption := Status;
    Showmodal;
    Free;
  End;
End;

Function TfrmAbout.CalculateCRC(AppName: String): Integer;
Var
  Stream: TMemoryStream;
Begin
  Try
    Stream := TMemoryStream.Create;
    Result := 0;
    Stream.LoadFromFile(AppName);
    Result := GetMemoryStreamCrc32(Stream);
    Stream.Free;
  Except
    On e: Exception Do
    Begin

    End;
  End;
End;

Procedure TfrmAbout.FormCreate(Sender: Tobject);
Begin
  PnlMain.Align := alClient;
        {/p94t3 gek 12/7/09  decouple MagListView
        MagListViewLite has most of MagListView functions, without the 'use' of the kitchen  sink.
        We create it at run time, so that small applications that use it (the About Form), don't have to have the
        Component on the Pallette for it to be compiled.}
  MagLVLite1 := TMagListViewLite.Create(Self);
  MagLVLite1.Parent := pnlListViewLite;
  MagLVLite1.Align := alClient;
 (* lbFileDescription.caption := '';
  lbVersion.caption := '';
  lbfilename.caption := '';
  lbfilesize.caption := '';
  lbfiledate.caption := '';
  lbPatch.caption := '';
  lbCRC.caption := '';
  lbFileDescription.caption := MagGetFileDescription(application.exename);
  caption := 'About: ' + MagGetProductName(application.exename);
  magVerPatch := MagGetFileVersionInfo(application.exename);
  lbVersion.caption := magpiece(magVerPatch,'.',1) + '.' + magpiece(magVerPatch,'.',2);
  lbPatch.caption := magpiece(magVerPatch,'.',3) + ' T' + magpiece(magVerPatch,'.',4);
  lbfilename.caption := application.exename;
  lbfilesize.caption := inttostr((getfilesize(Application.exename) div 1024) + 1) + ' KB';
  lbfiledate.caption := formatdatetime('mm/dd/yy  h:nn  am/pm', filedatetime(Application.exename));

  Stream:=TMemoryStream.Create;
  Stream.LoadFromFile(lbFileName.caption);
  CRC:=GetMemoryStreamCrc32(Stream);
  Stream.Free;
  lbCRC.Caption := IntToHex(CRC,8);
  DrawAppIcon(self);
  *)
End;

Procedure TfrmAbout.DrawAppIcon(Sender: Tobject);
Var
  IconIndex: Word;
  Icon: TIcon;
Begin
  Icon := TIcon.Create;
  (*  IconIndex := 0;
      h:=ExtractAssociatedIcon
      (hInstance,'C:\WINDOWS\NOTEPAD.EXE', IconIndex) ;
      DrawIcon(image2.Canvas.Handle, 10, 10, h) ;
   *)
  IconIndex := 0;
  Icon.Handle := ExtractAssociatedIcon(HInstance, PChar(Application.ExeName), IconIndex);
  DrawIcon(ImgProgramIcon.Canvas.Handle, 0, 0, Icon.Handle);
  Icon.Free;
 (* PROGRAMICON.Invalidate;*)
End;

End.
