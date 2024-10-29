program MAGTeleReaderConfig;
{Package: MAG - VistA Imaging
WARNING: Per VHA Directive 10-93-142 this unit should not be modified.
Date Created: 08/2009
Site Name: Silver Spring, OIFO
Developers: Bill Balshem
[==   program MAGTeleReaderAdmin
 Description:  Patch #106 TeleReader Administrator Utility.
 This Application will replace the FileMan utility for configuring the TeleReader application in the VistA imaging system
 at a specific site. The are 3 parts to the application.
    Configuration at the Acquisition site
    Configuration at the Reader site
    General system settings
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

uses
  Forms,
  fMAGTeleReaderAdminMain in 'fMAGTeleReaderAdminMain.pas' {frmTeleReaderAdmin},
  dmMAGTeleReaderAdmin in 'dmMAGTeleReaderAdmin.pas' {DataModule1: TDataModule};

{$R *.res}

begin
  Application.Initialize;
  Application.Title := 'TeleReader Config';
  Application.CreateForm(TfrmTeleReaderAdmin, frmTeleReaderAdmin);
  Application.CreateForm(TDataModule1, DataModule1);
  Application.Run;
end.
