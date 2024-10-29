Unit DmSingle;
   {
   Package: MAG - VistA Imaging
   WARNING: Per VHA Directive 10-93-142 this unit should not be modified.
   Date Created:   Versoin 3.0.8
   Site Name: Silver Spring, OIFO
   Developers: Garrett Kirin
   [==        unit dmSingle;
     Description: Imaging Main Data Module.  Holds nonvisual components.
     Using TDataModule to provide a location for centralized handling of nonvisual
     components. Mainly DataBase components, and 'singleton' objects. (objects
     that we want instantiated only once in an application.)
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
Interface

Uses
  Classes,
  cMagBrokerKeepAlive,
  cMagCCOWManager,
  cMagDBBroker,
  cMagDBDemo,
  cMagDBMVista,
  cMagDBSysUtils,
  cMagImageListManager,
  //cMagLogManager, {JK 10/5/2009 - Maggmsgu refactoring - deprecated unit}
  cMagPat,
  cMagSecurity,
  cMagUtils,
  cMagUtilsDB,
  cMagVUtils,
  Controls,
  Dialogs,
  Maggmsgu,
  Trpcb,
  ImgList, CCOWRPCBroker
  ;

//Uses Vetted 20090929:ImgList, Menus, Forms, Graphics, Messages, Windows, ComObj, uMagUtils, cMagRemoteWSBrokerFactory, cMagImageUtility, cMagImageAccessLogManager, MagImageManager, SysUtils

Type
  TDMod = Class(TDataModule)
    MagUtils1: TMagUtils;
    MagDBSysUtils1: TMagDBSysUtils;
    MagFileSecurity: TMag4Security;
    MagPat1: TMag4Pat;
    MagVUtils1: TMagVUtils;
    PrintDialog1: TPrintDialog;
    MagUtilsDB1: TMagUtilsDB;
    
    ImageListStateIcons: TImageList;
    ImageListStatusIcons: TImageList;
    ImageListIconsXtras: TImageList;
    CCOWRPCBroker1: TCCOWRPCBroker;

    Procedure DataModuleCreate(Sender: Tobject);
    Procedure DataModuleDestroy(Sender: Tobject);
  Private

  Public
    RPCBroker1: TRPCBroker;
    MagDBDemo1: TMagDBDemo;
    MagDBMVista1: TMagDBMVista;
    MagDBBroker1: TMagDBBroker;
    CCOWManager: TMagCCOWManager;
    MagImageListManager: TMagImageListManager;
  // MagLogManager : TMagLogManager;  {JK 10/6/2009 - Maggmsgu refactoring}
    MagBrokerKeepAlive: TMagBrokerKeepAlive;
  End;

Var
  Dmod: TDMod;

Implementation
Uses
  cMagImageAccessLogManager,
  cMagImageUtility,
  cMagRemoteWSBrokerFactory,
  ComObj,
  MagImageManager,
  SysUtils,
  Umagutils8
  ;

{$R *.DFM}

Procedure TDMod.DataModuleCreate(Sender: Tobject);
Begin
  RPCBroker1:= TRPCBroker.Create(nil);
  MagDBDemo1 := TMagDBDemo.Create;
  MagDBMVista1 := TMagDBMVista.Create;
  MagDBBroker1 := MagDBMVista1;
  MagPat1.M_DBBroker := MagDBBroker1;
  MagUtilsDB1.MagBroker := MagDBBroker1;

 // CCOWManager := TMagCCOWManager.Create(Self);
  CCOWManager := TMagCCOWManager.Create(self);
  MagImageListManager := TMagImageListManager.Create(Self);
  MagImageListManager.M_DBBroker := MagDBBroker1;
  MagPat1.Attach_(MagImageListManager);
  MagImageManager.Initialize(); // JMW 4/25/2005 initialize the cache main manager
  //MagLogManager := TMagLogManager.Create(); {JK 10/6/2009 - Maggmsgu refactoring}
  cMagImageAccessLogManager.Initialize();
  //MagImageManager1.OnLogEvent := MagLogManager.LogEvent;  {JK 10/6/2009 - Maggmsgu refactoring}
  MagImageManager1.MagSecurity := MagFileSecurity;
  //MagDBMVista1.OnLogEvent := MagLogManager.LogEvent;  {JK 10/6/2009 - Maggmsgu refactoring}
  //MagUtilsDB1.OnLogEvent := MagLogManager.LogEvent;   {JK 10/6/2009 - Maggmsgu refactoring}

  //MagImageListManager.OnLogEvent := MagLogManager.LogEvent;   {JK 10/5/2009 - MaggMsgu refactoring - remove old method}
  //getImageUtility().OnLogEvent := MagLogManager.LogEvent;     {JK 10/5/2009 - MaggMsgu refactoring - remove old method}
  //cMagRemoteWSBrokerFactory.setLogEvent(MagLogManager.LogEvent); {JK 10/5/2009 - MaggMsgu refactoring - remove old method}

  MagBrokerKeepAlive := TMagBrokerKeepAlive.Create();
  MagBrokerKeepAlive.Broker := MagDBBroker1;

  //MagLogManager.LogEvent(nil, 's','In TDMod.DataModuleCreate - done'); {JK 10/5/2009 - MaggMsgu refactoring - remove old method}
  MagLogger.Log(SYS, 'In TDMod.DataModuleCreate - done'); {JK 10/5/2009 - MaggMsgu refactoring}

End;

{Description: Added this method to explicitly shut down and free the CCOWManager object
 JK 3/11/2009
}

Procedure TDMod.DataModuleDestroy(Sender: Tobject);
Begin
// gek tried this, but worse AViltions // if application.Terminated then exit;
  Try
    DebugFile('procedure TDMod.DataModuleDestroy Entered');
    CCOWManager.ShutDownCCOWObject;
   if assigned(CCOWManager)
     then if (CCOWManager <> nil)
       then  FreeAndNil(CCOWManager);
   if assigned(MagDBDemo1)
     then if (MagDBDemo1 <> nil)
       then  FreeAndNil(MagDBDemo1);//RLM Fixing MemoryLeak 6/18/2010
   if assigned(MagDBMVista1)
     then if MagDBMVista1 <> nil
      then  FreeAndNil(MagDBMVista1);//RLM Fixing MemoryLeak 6/18/2010
   if assigned(CCOWManager)
     then if CCOWManager <> nil
      then   FreeAndNil(CCOWManager);//RLM Fixing MemoryLeak 6/18/2010
   if assigned(MagBrokerKeepAlive)
     then if MagBrokerKeepAlive <> nil
      then     FreeAndNil(MagBrokerKeepAlive);//RLM Fixing MemoryLeak 6/18/2010
   if assigned(RPCBroker1)
     then if RPCBroker1 <> nil
      then     FreeAndNil(RPCBroker1);
   DebugFile('END of TDMod.DataModuleDestroy ');
  Except
    On e: Exception Do
      DebugFile('procedure TDMod.DataModuleDestroy: UNHANDLED EXCEPTION = ' + e.Message);
    On EOle: EOleException Do
      DebugFile('procedure TDMod.DataModuleDestroy: UNHANDLED OLE EXCEPTION = ' + EOle.Message);
  End;
End;

End.
