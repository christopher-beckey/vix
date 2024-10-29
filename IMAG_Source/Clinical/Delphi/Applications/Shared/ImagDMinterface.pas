Unit ImagDMinterface;
   {
   Package: MAG - VistA Imaging
   WARNING: Per VHA Directive 10-93-142 this unit should not be modified.
   Date Created:  Version 3.0.8
   Site Name: Silver Spring, OIFO
   Developers: Garrett Kirin
   [==
   Description:
     To break the dependency of all forms on dmSingle  (Dmod)  we're creating an
     interface that will references to the components on dmod.
     The application will still create Dmod, and create the Interfaced Object iDModObj
     The forms/units etc will not be dependent on dmsingle,  only on iDModObj
     dmsingle out of uses, replaced by ImagDMinterface.
     'dmod' in code replaced by the implementation of the interface:  iDModObj.
       ==]
   Note:
   }
(*
        ;; +------------------------------------------------------------------+
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
        ;; +------------------------------------------------------------------+

*)
Interface
Uses
  Classes
  , controls
  , imglist
  //imaging
  , uMagClasses
  , imaginterfaces

  , trpcb
  , CCOWRPCBroker

  , cmagUtils
  , cmagDBSysutils
  , cmagSecurity
  , cmagPat
  , cmagVUtils
  , cmagUtilsDB

  , cmagdbbroker
  , cmagdbDemo
  , cmagDBMvista
  , cmagCCOWmanager
  , cmagimagelistmanager
  , cmagbrokerkeepalive
  ;


//============  *************** ================== ************ ============
{This is from dmsingle, we need interface to refer to these public components}
(*  Public
    RPCBroker1: TRPCBroker;
    MagDBDemo1: TMagDBDemo;
    MagDBMVista1: TMagDBMVista;
    MagDBBroker1: TMagDBBroker;
    CCOWManager: TMagCCOWManager;
    MagImageListManager: TMagImageListManager;
    MagBrokerKeepAlive: TMagBrokerKeepAlive;
  End;*)

type
 iMagDModInt = interface(IDispatch)
['{CBD42EA1-942A-4857-A9F0-AC642ADB4279}']

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

 end;
//=================== **************** ======================//

(* as example, keep this as comment
Type
  IMagMsg = Interface(IDispatch)
    ['{279C074C-1773-4C48-9AFD-6A9F287B6CAA}']
    {Show the message logger.}
    Procedure ShowLog;
    Procedure SetPrivLevel(Level: Integer);

    {Log a single message }
    Procedure LogMsg(Code: String; Msg: String; msgprior: Integer = 1);
    {Log a list of messages }
    Procedure LogMsgs(Code: String; Msgs: Tstringlist; msgprior: Integer = 1);
    {Log a single message }
    Procedure MagMsg(Code: String; Msg: String);
    {Log a list of messages }
    Procedure MagMsgs(Code: String; Msgs: Tstringlist);
    {/p117  implement LOG procedure..    internal call ? }
    Procedure Log( msglvl : integer ; msg : string);
  End;


//=================== **************** ======================//

  IMagObserver = Interface(IDispatch)
    ['{1BD79681-3D3D-11D4-A521-00C04F79A76D}']
    {The Observer has this method.  To get notified of a state change. }
    Procedure UpDate_(Newstate: String; Sender: Tobject);
  End;

//=================== **************** ======================//

  IMagSubject = Interface(IDispatch)
    ['{1BD79680-3D3D-11D4-A521-00C04F79A76D}']
        {Observers can Attach_ themselves to a Subject}
    Procedure Attach_(Observer: IMagObserver);

        {Observers can Detach_ themselves from a Subject}
    Procedure Detach_(Observer: IMagObserver);

        {In Notify_ Subject calls the Update_ method of all observers.
        (Note : other objects, code, can call the Notify method, forcing an update
         of all Observers.}
    Procedure Notify_(Newstate: String);

        {Unused at this time.}
        {Observers and Call GetState to get current State.}
    Procedure GetState_(Var State: String);

        {Unused at this time.}
    Procedure SetState_(State: String);
  End;
   *)
var
   iDModObj : iMagDModInt;

Implementation
Uses
  SysUtils
  ;


End.
