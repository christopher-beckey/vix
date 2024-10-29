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
  Trpcb,
  ImgList, CCOWRPCBroker
  //RCA
  , imaginterfaces
  ,  ImagDMinterface
  ;

Type
  TDMod = Class(TDataModule, iMagDModInt)
    MagUtils1: TMagUtils;
    MagDBSysUtils1: TMagDBSysUtils;
    MagFileSecurity: TMag4Security;
    MagPat1: TMag4Pat;
    MagVUtils1: TMagVUtils;
    PrintDialog1: TPrintDialog;
    MagUtilsDB1: TMagUtilsDB;
    ImageListStatusIcons: TImageList;
    ImageListIconsXtras: TImageList;
    CCOWRPCBroker1: TCCOWRPCBroker;
    ImageListStateIcons: TImageList;

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
  // MagLogManager : TMagLogManager;  
    MagBrokerKeepAlive: TMagBrokerKeepAlive;

    { RCA : public functions to support iMagDModInt }
    (*  START iMagDModInt *)
    function GetMagUtils1: TMagUtils;
    function GetMagDBSysUtils1: TMagDBSysUtils;
    function GetMagFileSecurity: TMag4Security;
    function GetMagPat1: TMag4Pat;
    function GetMagVUtils1: TMagVUtils;
    //function GetPrintDialog1: TPrintDialog;
    function GetMagUtilsDB1: TMagUtilsDB;
    function GetImageListStatusIcons: TImageList;
    function GetImageListIconsXtras: TImageList;
    function GetCCOWRPCBroker1: TCCOWRPCBroker;
    function GetImageListStateIcons: TImageList;

    function GetRPCBroker1: TRPCBroker;
    function GetMagDBDemo1: TMagDBDemo;
    function GetMagDBMVista1: TMagDBMVista;
    function GetMagDBBroker1: TMagDBBroker;
    function GetCCOWManager: TMagCCOWManager;
    function GetMagImageListManager: TMagImageListManager;
    function GetMagBrokerKeepAlive: TMagBrokerKeepAlive;
  (*  END iMagDModInt *)
  End;

Var
  Dmod: TDMod;

Implementation
Uses
  cMagImageAccessLogManager,
 //RCA   cMagImageUtility,
 //RCA   cMagRemoteWSBrokerFactory,
  ComObj,
  MagImageManager,
  SysUtils
 ,   Umagutils8
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

//  CCOWManager := TMagCCOWManager.Create(Self);
  CCOWManager := TMagCCOWManager.Create(self);  {/ P122 - JK 9/14/2011 P117 T6->T8 merged code. /}

  { RCA  attach the CCOWManager to MagPat1 here..  not using Interfaced object idmodobj
        here , like it was in CCOWManager.ONCreate... it shouldn't be there anyway.  Here is better  }
  MagPat1.attach_(CCOWmanager);  //RCA attach CCOWManager as observer to TmagPat here, not in ccowmanager OnCreateEvent.

  MagImageListManager := TMagImageListManager.Create(Self);
  MagImageListManager.M_DBBroker := MagDBBroker1;
  MagPat1.Attach_(MagImageListManager);
  MagImageManager.Initialize(); // JMW 4/25/2005 initialize the cache main manager

  cMagImageAccessLogManager.Initialize();

  MagImageManager1.MagSecurity := MagFileSecurity;

  MagBrokerKeepAlive := TMagBrokerKeepAlive.Create();
  MagBrokerKeepAlive.Broker := MagDBBroker1;

  magAppMsg(magmsglvlSYS, 'In TDMod.DataModuleCreate - done'); 

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

    {/ P122 - JK 9/14/2011 P117 T6->T8 merged code. /}
    if assigned(CCOWManager) then
      if (CCOWManager <> nil) then
        FreeAndNil(CCOWManager);
    if assigned(MagDBDemo1) then
      if (MagDBDemo1 <> nil) then
        FreeAndNil(MagDBDemo1);
    //RLM Fixing MemoryLeak 6/18/2010
    if assigned(MagDBMVista1) then
      if MagDBMVista1 <> nil then
        FreeAndNil(MagDBMVista1);

  {/ P122 - JK 9/23/2011 - removing this code since Garrett added a P117 T8 fix earlier in this method /}
//    //RLM Fixing MemoryLeak 6/18/2010
//    if assigned(CCOWManager) then
//      if CCOWManager <> nil then
//        FreeAndNil(CCOWManager);


  {/ P122 - JK 9/23/2011 - MagBrokerKeepAlive is an interfaced object: TMagBrokerKeepAlive = Class(TInterfacedObject, IMagRemoteinterface)
     As such, do not treat it as a reference to an object.  It is a referenced interface object.  When a interfaced object goes out of
     scope its the interface's reference count gets decremented. When it gets to zero it is released and no longer exists. Trying to
     call FREE or FREEANDNIL on an interfaced object in not a null pointer or a pointer to a valid object but NOTHING which will
     force an INVALID POINTER exception to be raised.  Since we have had issues from time to time with a runtime exception being thrown
     when the program shuts down, it is because sometimes the reference count for MagBrokerKeepAlive is zero and sometime it is not.
     The best thing here is to not try to free or free and nil it.  If the reference count is not zero at this time, when the application
     closes the interfaced object will be out of scope and the memory freed automatically.
   }
//    //RLM Fixing MemoryLeak 6/18/2010
//    if assigned(MagBrokerKeepAlive) then
//      if MagBrokerKeepAlive <> nil then
//        FreeAndNil(MagBrokerKeepAlive);

    //RLM Fixing MemoryLeak 6/18/2010
    if assigned(RPCBroker1) then
      if RPCBroker1 <> nil then
        FreeAndNil(RPCBroker1);
    DebugFile('END of TDMod.DataModuleDestroy ');

//    FreeAndNil(CCOWManager);
//    DebugFile('procedure TDMod.DataModuleDestroy Exited');
//    FreeAndNil(MagDBDemo1);//RLM Fixing MemoryLeak 6/18/2010
//    FreeAndNil(MagDBMVista1);//RLM Fixing MemoryLeak 6/18/2010
//    FreeAndNil(CCOWManager);//RLM Fixing MemoryLeak 6/18/2010
//    FreeAndNil(MagBrokerKeepAlive);//RLM Fixing MemoryLeak 6/18/2010
//    FreeAndNil(RPCBroker1);
  Except
    On e: Exception Do
      DebugFile('procedure TDMod.DataModuleDestroy: UNHANDLED EXCEPTION = ' + e.Message);
    On EOle: EOleException Do
      DebugFile('procedure TDMod.DataModuleDestroy: UNHANDLED OLE EXCEPTION = ' + EOle.Message);
  End;
End;

function TDMod.GetCCOWManager: TMagCCOWManager;
begin
result := CCOWmanager;
end;

function TDMod.GetCCOWRPCBroker1: TCCOWRPCBroker;
begin
result :=  CCOWRPCBroker1
end;

function TDMod.GetImageListIconsXtras: TImageList;
begin
 result :=  ImageListIconsXtras
end;

function TDMod.GetImageListStateIcons: TImageList;
begin
  result :=  ImageListStateIcons
end;

function TDMod.GetImageListStatusIcons: TImageList;
begin
  result := ImageListStatusIcons
end;

function TDMod.GetMagBrokerKeepAlive: TMagBrokerKeepAlive;
begin
  result := MagBrokerKeepAlive
end;

function TDMod.GetMagDBBroker1: TMagDBBroker;
begin
  result :=  MagDBBroker1
end;

function TDMod.GetMagDBDemo1: TMagDBDemo;
begin
   result :=  MagDBDemo1
end;

function TDMod.GetMagDBMVista1: TMagDBMVista;
begin
  result :=   MagDBMVista1
end;

function TDMod.GetMagDBSysUtils1: TMagDBSysUtils;
begin
  result := MagDBSysUtils1
end;

function TDMod.GetMagFileSecurity: TMag4Security;
begin
  result :=  MagFileSecurity
end;

function TDMod.GetMagImageListManager: TMagImageListManager;
begin
  result :=   MagImageListManager
end;

function TDMod.GetMagPat1: TMag4Pat;
begin
  result :=  MagPat1
end;

function TDMod.GetMagUtils1: TMagUtils;
begin
  result := MagUtils1
end;

function TDMod.GetMagUtilsDB1: TMagUtilsDB;
begin
  result :=    MagUtilsDB1
end;

function TDMod.GetMagVUtils1: TMagVUtils;
begin
  result :=   MagVUtils1
end;

function TDMod.GetRPCBroker1: TRPCBroker;
begin
  result :=  RPCBroker1
end;

End.
