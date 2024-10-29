Program MagTeleReaderMAIN;
{
  Package: MAG - VistA Imaging
  WARNING: Per VHA Directive 2004-038, this routine should not be modified.
  Date created: October 2005
  Site Name:  Washington OI Field Office, Silver Spring, MD
  Developer:  Robert Graves, Julian Werfel
  Description: Main project for TeleReader application
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
        ;;+---------------------------------------------------------------------------------------------------+
*)

uses
  Forms,
  MagRemoteBrokerManager in '..\shared\MagRemoteBrokerManager.pas',
  dmSingle in '..\shared\dmSingle.pas' {DMod: TDataModule},
  MagTimeout in '..\shared\MagTimeout.pas' {MagTimeoutform},
  cMagDBMVista in '..\shared\cMagDBMVista.pas',
  magremotebroker in '..\shared\magremotebroker.pas',
  fMagPatAccess in '..\shared\fMagPatAccess.pas' {frmPatAccess},
  MagRemoteToolbar in '..\shared\MagRemoteToolbar.pas' {fMagRemoteToolbar: TFrame},
  uMagTRAppMgr in 'uMagTRAppMgr.pas',
  cMagHashmap in 'cMagHashmap.pas',
  cMagTRMsg in 'cMagTRMsg.pas',
  cMagTRUtils in 'cMagTRUtils.pas',
  cMagUserSpecialty in 'cMagUserSpecialty.pas',
  cMagWorkItem in 'cMagWorkItem.pas',
  fmagnumberselect in 'fmagnumberselect.pas' {frmNumberSelect},
  fMagTeleReaderOptions in 'fMagTeleReaderOptions.pas' {frmMagTeleReaderOptions},
  fmagTRMain in 'fmagTRMain.pas' {frmTRMain};

{$R *.res}

Begin
  Application.Initialize;
  Application.Title := 'VistA Imaging TeleReader';
  Application.CreateForm(TDmod, Dmod);
  Application.CreateForm(TfrmTRMain, frmTRMain);
  Application.CreateForm(TfrmMagTeleReaderOptions, frmMagTeleReaderOptions);
  Application.CreateForm(TMagTimeoutform, MagTimeoutform);
  Application.CreateForm(TFrmPatAccess, FrmPatAccess);
  Application.CreateForm(TfrmNumberSelect, frmNumberSelect);
  Application.Run;
End.
