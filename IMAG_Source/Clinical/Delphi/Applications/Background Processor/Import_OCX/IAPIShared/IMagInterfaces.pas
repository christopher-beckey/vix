Unit ImagInterfaces;
   {
   Package: MAG - VistA Imaging
   WARNING: Per VHA Directive 10-93-142 this unit should not be modified.
   Date Created:  Version 3.0.8
   Site Name: Silver Spring, OIFO
   Developers: Garrett Kirin
   [==
   Description:
   The Observer Design pattern defnes a One to many relationship between objects
   so that when one object (subject) changes state, all its dependents (observers)
    are notified and updated automatically.

    The subject sends out notifications without having to know who (or what class)
    its' observers are.  This gives the freedom to add and remove observers
    at any time.
    Also the subject doesn't know the concrete class of it's observers.
    Thus the coupling is minimal.

       Defined Interfaces for VistA Imaging.
        MagObserver : Attaches itself to a MagSubject and gets notified by
                a call to it's Update_ procedure of any changes.
        MagSubject : Accepts any number of Observers.  Notifies all Observers
        attached to it, whenever a change of state occurs.
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
  //imaging
  ,
  UMagClasses
  ;

//Uses Vetted 20090929:StdCtrls, Dialogs, Forms, Controls, Graphics, Classes, Messages, Windows, SysUtils

//=================== **************** ======================//
    {IMagImageList will be a standard set of procedure calls that we can make to
      TmagListView,  TMagTreeView and Tmag4Viewer (cMagImageList ? )  to get data.}
Type
  IMagImageList = Interface(IDispatch)
    ['{367CDC4B-5E6B-4959-BA68-FF72E3494E93}']
    Procedure SyncWithIMage(IObj: TImageData);
  End;

Type
  ImagImageQuery = Interface(IDispatch)
    ['{B9BC23F2-5531-4681-8338-625C0F6F810B}']
    Function GetImageState(IObj: TImageData): Integer;
  End;

Const
  {TMagLogPriority is for backwards compatibility with P93}
{  TMagLogPriority = (MagLogDebug, MagLogINFO, MagLogWARN, MagLogERROR, MagLogFATAL)}
  magmsgDEBUG: Integer = 0;
  magmsgINFO: Integer = 1;
  magmsgWARN: Integer = 2;
  magmsgERROR: Integer = 3;
  magmsgFATAL: Integer = 4;


//p117 need mapping to Logger Levels.
  {LOGGER is for logger internal messages to the user - do not use in the host application}
{  TMagLoggerLevel = (DEBUG, TRACE, Marker, LOGGER, Warn,
                       ERROR, Info, FATAL, COMM, COMMERR, CCOW, SYS, NONSYS)}
  msglvlDEBUG   : integer = 0;
  msglvlTRACE   : integer = 1;
  msglvlMarker  : integer = 2;
  msglvlLOGGER  : integer = 3;
  msglvlWarn    : integer = 4;
  msglvlERROR   : integer = 5;
  msglvlInfo    : integer = 6;
  msglvlFATAL   : integer = 7;
  msglvlCOMM    : integer = 8;
  msglvlCOMMERR : integer = 9;
  msglvlCCOW    : integer = 10;
  msglvlSYS     : integer = 11;
  msglvlNONSYS  : integer = 12;

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

//=================== **************** ======================//
{   TMagNewsObject = class(TObject)
    A NewsObject is sent from any control to the Publisher
    the Publisher will Notify all Subscribers with the News
    The Publisher can decide if the News needs to be published or not.
    The }

  TMagNewsObject = Class(Tobject)
  Public
    Newscode: Integer;
    NewsTopic: Integer;
    NewsIntValue: Integer;
    NewsStrValue: String;
    NewsChangeObj: Tobject;
    NewsInitiater: Tobject;
    Procedure Assign(Headline: TMagNewsObject);
    Constructor Create();
  End;

//=================== **************** ======================//
(*   The Publish Subscribe pattern will be used (same as the Subject Observer,
     but we'll referr to the 'New' pattern objects this way to avoid confussion
     with the older objects.
     Subscribers will subscribe to a Publisher to be Notified when events of
     interest occur.  The events are coded with 'pubst....' codes.
     the Subscribers can ignore what they don't care about.
     The changeObj in the Update_ method will change depending on the pubst...
     code.
     with Patient changes, the object will be a TMagPat
     for Image Changes the object will be a TimageData object.  etc.
      *)

  IMagSubscribe = Interface(IDispatch)
    ['{6C63D83F-A7E5-4684-B034-F0E01742877D}']
    {The SubScriber has this method.  To get notified of a Published change. }
    Procedure I_Update(NewsObj: TMagNewsObject);
  End;

//=================== **************** ======================//

  ImagPublish = Interface(IDispatch)
    ['{B26BDC48-DDBA-4243-B823-D662E7B0D5D5}']
        {SubScribers can I_Attach themselves to a Publisher}
    Procedure I_Attach(Subscriber: IMagSubscribe);

        {SubScribers can Detach_ themselves from a Publisher}
    Procedure I_Detach(Subscriber: IMagSubscribe);

        {In I_Notify Publisher calls the I_Update method of all SubScribers.
        (Note : other objects, code, can call the I_SetNews method, which will
         call I_Notify forcing an update of all subscribers.}

//    Procedure I_Notify(newscode,NewsIntValue : integer; newsstrvalue : string = '';  changeObj : TObject = nil; Initiater : Tobject = nil);
    Procedure I_Notify(NewsObj: TMagNewsObject);

        {SubScribers and Call GetState to get current News.}
    Function I_GetNews: TMagNewsObject;

        {Other objects, can call the I_SetNews method, which will
                    call I_Notify forcing an update of all subscribers}
    Procedure I_SetNews(NewsObj: TMagNewsObject);
  End;
    (*
    class procedure MagMsg(c, s: String;  pmsg: TPanel = nil);
    class procedure MagMsgs(c: String; t: TStringList);
    class procedure LogMsg(MsgType: string; Msg: string; Priority: TMagLogPriority = MagLogINFO);
    class procedure LogMsgs(MsgType: string; Msgs: TStringList; Priority: TMagLogPriority = MagLogINFO);
    *)
Procedure MagAppMsg(c, s: String); OverLoad;
Procedure MagAppMsg(c: String; t: Tstringlist); OverLoad;
Procedure MagAppMsg(MsgType: String; Msg: String; Priority: Integer = 1); OverLoad;
Procedure MagAppMsg(MsgType: String; Msgs: Tstringlist; Priority: Integer = 1); OverLoad;

Const
 {newscodes for TmagNewsObject}
  MpubPatientSelected = 1000;
  MpubImageSelected = 2000;
  MpubImageStateChange = 2001;
  MpubImageStatusChange = 2002;
  mpubImageUnSelectAll = 2003;
  MpubRIVImage = 3000;
  mpubMessages = 5000; {JK 6/5/2009 - message code}

Var
  IMsgObj: IMagMsg;

Implementation
Uses
  SysUtils
  ;

{ TMagNewsObject }

Procedure TMagNewsObject.Assign(Headline: TMagNewsObject);
Begin
    {   //JK 1/26/2009  Added Try/Except block }
  Try
    Newscode := Headline.Newscode;
    NewsTopic := Headline.NewsTopic;
    NewsIntValue := Headline.NewsIntValue;
    NewsStrValue := Headline.NewsStrValue;
    NewsChangeObj := Headline.NewsChangeObj;
    NewsInitiater := Headline.NewsInitiater;
  Except
    On e: Exception Do
      ; //JK 1/26/2009 do nothing.
  End;
End;

Constructor TMagNewsObject.Create();
Begin
  Self.Newscode := 0;
  Self.NewsTopic := 0;
  Self.NewsIntValue := 0;
  Self.NewsStrValue := '';
  Self.NewsChangeObj := Tobject.Create;
  Self.NewsInitiater := Tobject.Create;
//self.NewsChangeObj := nil;   //JK 1/26/2009 don't set to nil on creation
//self.NewsInitiater := nil;   //JK 1/26/2009 don't set to nil on creation

End;

Procedure MagAppMsg(c, s: String); Overload;
Begin
//
End;

Procedure MagAppMsg(c: String; t: Tstringlist); Overload;
Begin
//
End;

Procedure MagAppMsg(MsgType: String; Msg: String; Priority: Integer = 1); Overload;
Begin
//
End;

Procedure MagAppMsg(MsgType: String; Msgs: Tstringlist; Priority: Integer = 1); Overload;
Begin
//
End;

End.
