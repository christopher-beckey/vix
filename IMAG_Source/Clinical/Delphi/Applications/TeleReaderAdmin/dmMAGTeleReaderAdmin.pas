unit dmMAGTeleReaderAdmin;
{Package: MAG - VistA Imaging
WARNING: Per VHA Directive 10-93-142 this unit should not be modified.
Date Created: 08/2009
Site Name: Silver Spring, OIFO
Developers: Bill Balshem
[==   program dmMAGTeleReaderAdmin;
 Description:  Data Module for the application. Contains the Broker componenet that manages the connection, posts and retrievals from the VistA db.
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
  SysUtils, Classes, Trpcb;

type
  TDataModule1 = class(TDataModule)
    Broker: TRPCBroker;
  private
    { Private declarations }
  public
    { Public declarations }
  end;

var
  DataModule1: TDataModule1;

implementation

{$R *.dfm}

end.
