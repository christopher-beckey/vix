Unit Magremoteinterface;
(*
        ;; +---------------------------------------------------------------------------------------------------+
        ;;  MAG - IMAGING
        ;;  Property of the US Government.
        ;;  WARNING: Pe VHA Directive xxxxxx, this unit should not be modified.
        ;;  No permission to copy or redistribute this software is given.
        ;;  Use of unreleased versions of this software requires the user
        ;;  to execute a written test agreement with the VistA Imaging
        ;;  Development Office of the Department of Veterans Affairs,
        ;;  telephone (301) 734-0100.
        ;;
        ;; The Food and Drug Administration classifies this software as
        ;; a Class II medical device.  As such, it may not be changed
        ;; in any way.  Modifications to this software may result in an
        ;; adulterated medical device under 21CFR820, the use of which
        ;; is considered to be a violation of US Federal Statutes.
        ;;
        ;;  Date created: May 2005
        ;;  Site Name:  Washington OI Field Office, Silver Spring, MD
        ;;  Developer:  Julian Werfel
        ;;  Description: This is an interface object which allows objects to
        ;;  extend this object to be used for RIV context changes.
        ;;
        ;;+---------------------------------------------------------------------------------------------------+
*)

Interface

Type
  IMagRemoteinterface = Interface(IInterface)
    Procedure RIVRecieveUpdate_(action: String; Value: String);
  End;

  TMagRemoteInterfaceManager = Class
  Private
    ObserverList: Array Of IMagRemoteinterface;
  Protected

  Public

  End;

Procedure Initialize();
Procedure RIVAttachListener(RemoteIntObj: IMagRemoteinterface);
Procedure RIVNotifyAllListeners(RemoteIntObj: IMagRemoteinterface; action: String; Value: String);
Procedure RIVDetachListener(RemoteIntObj: IMagRemoteinterface);
Procedure DestroyObserverList();

  // these are not used yet.
Const
  ACTION_ADDACTIVE = 1;
Const
  ACTION_ADDDISCONNECTED = 2;
Const
  ACTION_SETDISCONNECTED = 3;
Const
  ACTION_DEACTIVATEALL = 4;
Const
  ACTION_SETINACTIVE = 5;
Const
  ACTION_SETACTIVE = 6;
Const
  ACTION_REMOVEALL = 7;
Const
  ACTION_REMOVESITE = 8;

Implementation
Uses
  SysUtils;

Var
  RIVListenerManager: TMagRemoteInterfaceManager;
  Initialized: Boolean;

Procedure Initialize();
Begin
  If Not Initialized Then
  Begin
    RIVListenerManager := TMagRemoteInterfaceManager.Create();
  End;
  Initialized := True;
End;

Procedure RIVAttachListener(RemoteIntObj: IMagRemoteinterface);
Var
  Len, Count, i: Integer;
  CurFace: IMagRemoteinterface;
Begin
  If Not Initialized Then Initialize();

  Count := (High(RIVListenerManager.ObserverList));
  For i := 0 To Count Do
  Begin
    If (RemoteIntObj = RIVListenerManager.ObserverList[i]) Then
    Begin
        // already in observer list, don't need a second instance
      Exit;
    End;
  End;

  Len := Length(RIVListenerManager.ObserverList);
  SetLength(RIVListenerManager.ObserverList, Len + 1);
  RIVListenerManager.ObserverList[High(RIVListenerManager.ObserverList)] := RemoteIntObj;
End;

Procedure RIVNotifyAllListeners(RemoteIntObj: IMagRemoteinterface; action: String; Value: String);
Var
  i: Integer;
  Count: Integer;
Begin
  If RIVListenerManager = Nil Then Exit;
  Count := High(RIVListenerManager.ObserverList);
  For i := 0 To Count Do
  Begin
    If (RIVListenerManager.ObserverList[i] <> RemoteIntObj) And (RIVListenerManager.ObserverList[i] <> Nil) Then
    Begin
      RIVListenerManager.ObserverList[i].RIVRecieveUpdate_(action, Value);
    End;
  End;
End;

Procedure RIVDetachListener(RemoteIntObj: IMagRemoteinterface);
Var
  i, Count: Integer;
Begin
  If RIVListenerManager = Nil Then Exit;
  Count := (High(RIVListenerManager.ObserverList));
  For i := 0 To Count Do
  Begin
    If (RemoteIntObj = RIVListenerManager.ObserverList[i]) Then
    Begin
      RIVListenerManager.ObserverList[i] := Nil;
      Exit;
    End;
  End;
End;

Procedure DestroyObserverList();
Begin
  If RIVListenerManager <> Nil Then
  Begin
    RIVListenerManager.Free();
    RIVListenerManager := Nil;
    Initialized := False;
  End;
End;
Initialization

Finalization
  if RIVListenerManager <> nil then  {/ P117 NCAT - JK 12/9/2010 - need to check for nil because sometimes the FreeAndNil line throws an error - weird! /}  
    FreeAndNil(RIVListenerManager);//RLM Fixing MemoryLeak 6/18/2010

End.
