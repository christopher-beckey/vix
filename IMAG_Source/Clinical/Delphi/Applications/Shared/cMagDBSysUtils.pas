Unit cMagDBSysUtils;
   {
   Package: MAG - VistA Imaging
 WARNING: Per VHA Directive 10-93-142 this unit should not be modified.
 Date Created:
 Site Name: Silver Spring, OIFO
 Developers: Garrett Kirin
 [==
 Description:
   Imaging DataBase RPC Calls for System functions.
   (Calls made from Image Information Advanced window, MAGSYS.EXE and MAGWRKS.EXE)

   In the future there will be an  Abstract Class to inherit from, similiar to
   the abstract class cMagDBBroker and descendant classes cMagDBMVista and cMagDBDemo.
   ==]

 Note:  This function is not Released in Patch 8
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
  Controls,
  Trpcb
  ;

//Uses Vetted 20090929:umagutils, hash, Dialogs, Forms, Graphics, Messages, Windows, iMagRemoteBrokerInterface, MagRemoteBrokerManager, RPCconf1, SysUtils

Type
  TMagDBSysUtils = Class(TComponent)
  Private
    FBroker: TRPCBroker;
    Function GetBroker: TRPCBroker;
    Procedure SetBroker(Const Value: TRPCBroker);
  Protected
    { Protected declarations }
  Public
    Procedure RPMAG4SysWrksStats(t: Tstringlist; Compname, Days, Dtfr, Dtto: String);
    Procedure RPMAG4SysUserStats(t: Tstringlist; Days, Dtfr, Dtto: String);
    Procedure RPMAG4SysWrksData(t: Tstringlist; Compname, Days, Dtfr, Dtto: String);
    Procedure RPMAG4SysSessByWrks(t: Tstringlist; Wrksien, Days, Dtfr, Dtto: String);
    Procedure RPMAG4SysSessByUser(t: Tstringlist; Duz, Days, Dtfr, Dtto: String);
    Procedure MaggSysSessionDisplay(Var t: Tstringlist; Sess: Integer);
    Function DBSelect(Var Vserver, Vport: String): Boolean;
    Procedure CreateContext(Context: String);
    Procedure RPMaggSysGlbNode(Magien: String; ServerName: String; ServerPort: Integer; Var t: TStrings);
    Procedure RPMaggSysParGlb(Magien: String; Var t: Tstringlist);
    Procedure RPMaggDevFldValues(Magien, Flags: String; ServerName: String; ServerPort: Integer; Var t: Tstringlist);
    Procedure RPMaggDevParFldValues(Magien, Flags: String; Var t: Tstringlist);
    Procedure RPMaggSysAnyNode(GN1: String; Var t: Tstringlist);
    Procedure RPMaggImageInfo(Xmagien: String; Var Imagestring: String);
    Function IsConnected: Boolean;
  Published
    Property Broker: TRPCBroker Read GetBroker Write SetBroker;
  End;

Procedure Register;

Implementation
Uses
  IMagRemoteBrokerInterface,
  MagRemoteBrokerManager,
  RPCconf1,
  SysUtils
  ;

Procedure TMagDBSysUtils.RPMAG4SysSessByWrks(t: Tstringlist; Wrksien, Days, Dtfr, Dtto: String);
Begin

    // if not broker.connected then exit;
  FBroker.PARAM[0].Value := Wrksien;
  FBroker.PARAM[0].PTYPE := LITERAL;
  FBroker.PARAM[1].Value := Days;
  FBroker.PARAM[1].PTYPE := LITERAL;
  FBroker.PARAM[2].Value := Dtfr;
  FBroker.PARAM[2].PTYPE := LITERAL;
  FBroker.PARAM[3].Value := Dtto;
  FBroker.PARAM[3].PTYPE := LITERAL;
  FBroker.REMOTEPROCEDURE := 'MAG4 SYS SESSIONS WRKS'; //'MAGG SYS WRKS SESSIONS';
  Try
    FBroker.LstCALL(t);
  Except
    On e: Exception Do t.Insert(0, '0^' + e.Message);
  End;
End;

Procedure TMagDBSysUtils.RPMAG4SysSessByUser(t: Tstringlist; Duz, Days, Dtfr, Dtto: String);
Begin

    // if not broker.connected then exit;
  FBroker.PARAM[0].Value := Duz;
  FBroker.PARAM[0].PTYPE := LITERAL;
  FBroker.PARAM[1].Value := Days;
  FBroker.PARAM[1].PTYPE := LITERAL;
  FBroker.PARAM[2].Value := Dtfr;
  FBroker.PARAM[2].PTYPE := LITERAL;
  FBroker.PARAM[3].Value := Dtto;
  FBroker.PARAM[3].PTYPE := LITERAL;
  FBroker.REMOTEPROCEDURE := 'MAG4 SYS SESSIONS USER'; //'MAGG SYS WRKS SESSIONS';
  Try
    FBroker.LstCALL(t);
  Except
    On e: Exception Do t.Insert(0, '0^' + e.Message);
  End;
End;

Procedure TMagDBSysUtils.RPMAG4SysUserStats(t: Tstringlist; Days, Dtfr, Dtto: String);
Begin
  FBroker.PARAM[0].Value := Days;
  FBroker.PARAM[0].PTYPE := LITERAL;
  FBroker.PARAM[1].Value := Dtfr;
  FBroker.PARAM[1].PTYPE := LITERAL;
  FBroker.PARAM[2].Value := Dtto;
  FBroker.PARAM[2].PTYPE := LITERAL;
  FBroker.REMOTEPROCEDURE := 'MAG4 SYS USER STATS';
  Try
    FBroker.LstCALL(t);
  Except
    On e: Exception Do t.Insert(0, '0^' + e.Message);
  End;
End;

Procedure TMagDBSysUtils.RPMAG4SysWrksData(t: Tstringlist; Compname, Days, Dtfr, Dtto: String);
Begin
  FBroker.PARAM[0].Value := Compname;
  FBroker.PARAM[0].PTYPE := LITERAL;
  FBroker.PARAM[1].Value := Days;
  FBroker.PARAM[1].PTYPE := LITERAL;
  FBroker.PARAM[2].Value := Dtfr;
  FBroker.PARAM[2].PTYPE := LITERAL;
  FBroker.PARAM[3].Value := Dtto;
  FBroker.PARAM[3].PTYPE := LITERAL;
  FBroker.REMOTEPROCEDURE := 'MAG4 SYS WRKS DATA';
  Try
    FBroker.LstCALL(t);
  Except
    On e: Exception Do t.Insert(0, '0^' + e.Message);
  End;
End;

Procedure TMagDBSysUtils.RPMAG4SysWrksStats(t: Tstringlist; Compname, Days, Dtfr, Dtto: String);
Begin
  FBroker.PARAM[0].Value := Compname;
  FBroker.PARAM[0].PTYPE := LITERAL;
  FBroker.PARAM[1].Value := Days;
  FBroker.PARAM[1].PTYPE := LITERAL;
  FBroker.PARAM[2].Value := Dtfr;
  FBroker.PARAM[2].PTYPE := LITERAL;
  FBroker.PARAM[3].Value := Dtto;
  FBroker.PARAM[3].PTYPE := LITERAL;
  FBroker.REMOTEPROCEDURE := 'MAG4 SYS WRKS STATS';
  Try
    FBroker.LstCALL(t);
  Except
    On e: Exception Do t.Insert(0, '0^' + e.Message);
  End;
End;

Procedure TMagDBSysUtils.MaggSysSessionDisplay(Var t: Tstringlist; Sess: Integer);
Begin
  FBroker.PARAM[0].Value := Inttostr(Sess);
  FBroker.PARAM[0].PTYPE := LITERAL;
  FBroker.REMOTEPROCEDURE := 'MAGG SYS SESSION DISPLAY';
  FBroker.LstCALL(t);
End;

Function TMagDBSysUtils.DBSelect(Var Vserver, Vport: String): Boolean;
Begin
  If (GetServerInfo(Vserver, Vport) = MrOK) Then
  Begin
    FBroker.Server := Vserver;
    FBroker.ListenerPort := Strtoint(Vport);
    FBroker.Connected := True;
    Result := FBroker.Connected;
  End
  Else
    Result := False;
End;

Procedure Register;
Begin
  RegisterComponents('Imaging', [TMagDBSysUtils]);
End;

Function TMagDBSysUtils.GetBroker: TRPCBroker;
Begin
  Result := FBroker;
End;

Procedure TMagDBSysUtils.SetBroker(Const Value: TRPCBroker);
Begin
  FBroker := Value;
End;

Procedure TMagDBSysUtils.CreateContext(Context: String);
Begin
  FBroker.CreateContext(Context);
End;

{This function will have to be modified to pass TImageData (since it will include the report for the DOD images)}

Procedure TMagDBSysUtils.RPMaggSysGlbNode(Magien: String; ServerName: String; ServerPort: Integer; Var t: TStrings);
Var
  RemoteBroker: IMagRemoteBroker;
Begin
  // JMW 2/28/2005 p45
  If (FBroker.Server = ServerName) And (FBroker.ListenerPort = ServerPort) Then
  Begin
    FBroker.REMOTEPROCEDURE := 'MAGG SYS GLOBAL NODE';
    FBroker.PARAM[0].Value := Magien;
    FBroker.PARAM[0].PTYPE := LITERAL;
    FBroker.LstCALL(t);
  End
  Else
  Begin

    RemoteBroker := MagRemoteBrokerManager1.GetBroker(ServerName, ServerPort);
    If RemoteBroker = Nil Then
    Begin
      MagRemoteBrokerManager1.LogBrokerNotFoundError(ServerName, ServerPort, 'RPMaggSysGlbNode');
      Exit;
    End;
    RemoteBroker.GetImageGlobalLookup(Magien, t);
  End;
End;

Procedure TMagDBSysUtils.RPMaggSysParGlb(Magien: String; Var t: Tstringlist);
Begin
  FBroker.REMOTEPROCEDURE := 'MAGG SYS PARENT GLB';
  FBroker.PARAM[0].Value := Magien;
  FBroker.PARAM[0].PTYPE := LITERAL;
  FBroker.LstCALL(t);
End;

Procedure TMagDBSysUtils.RPMaggDevFldValues(Magien, Flags: String; ServerName: String; ServerPort: Integer; Var t: Tstringlist);
Var
  RemoteBroker: IMagRemoteBroker;
Begin
  // JMW 9/9/2005 p45t8 fix IR found in t7
  If (FBroker.Server = ServerName) And (FBroker.ListenerPort = ServerPort) Then
  Begin
    FBroker.REMOTEPROCEDURE := 'MAGG DEV FIELD VALUES';
    FBroker.PARAM[0].Value := Magien;
    FBroker.PARAM[0].PTYPE := LITERAL;
    FBroker.PARAM[1].Value := Uppercase(Flags);
    FBroker.PARAM[1].PTYPE := LITERAL;
    FBroker.LstCALL(t);
  End
  Else
  Begin
    RemoteBroker := MagRemoteBrokerManager1.GetBroker(ServerName, ServerPort);
    If RemoteBroker = Nil Then
    Begin
      MagRemoteBrokerManager1.LogBrokerNotFoundError(ServerName, ServerPort, 'RPMaggDevFldValues');
      Exit;
    End;
    RemoteBroker.GetMagDevFields(Magien, Flags, t);
  End;
End;

Procedure TMagDBSysUtils.RPMaggDevParFldValues(Magien, Flags: String; Var t: Tstringlist);
Begin
  FBroker.REMOTEPROCEDURE := 'MAGG DEV PARENT FIELD VALUES';
  FBroker.PARAM[0].Value := '2005';
  FBroker.PARAM[0].PTYPE := LITERAL;
  FBroker.PARAM[1].Value := Magien;
  FBroker.PARAM[1].PTYPE := LITERAL;
  FBroker.PARAM[2].Value := Uppercase(Flags);
  FBroker.PARAM[2].PTYPE := LITERAL;
  FBroker.LstCALL(t);
End;

Procedure TMagDBSysUtils.RPMaggSysAnyNode(GN1: String; Var t: Tstringlist);
Begin
  FBroker.REMOTEPROCEDURE := 'MAGG SYS ANY NODE';
  FBroker.PARAM[0].Value := GN1;
  FBroker.PARAM[0].PTYPE := LITERAL;
  FBroker.LstCALL(t);
End;

{TODO: Make a New RPC ... MAG4 SYS IMAGE INFO to keep things straight.}

Procedure TMagDBSysUtils.RPMaggImageInfo(Xmagien: String; Var Imagestring: String);
Begin
  FBroker.REMOTEPROCEDURE := 'MAGG IMAGE INFO';
  FBroker.PARAM[0].PTYPE := LITERAL;
  FBroker.PARAM[0].Value := Xmagien;
  FBroker.Call;
  Imagestring := FBroker.Results[0];
End;

Function TMagDBSysUtils.IsConnected: Boolean;
Begin
  Result := FBroker.Connected;
End;

End.
