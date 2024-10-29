Unit MagRemoteBroker;

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
        ;;  Date created: April 2005
        ;;  Site Name:  Washington OI Field Office, Silver Spring, MD
        ;;  Developer:  Julian Werfel
        ;;  Description: This is a wrapper for each remote broker object.  This
        ;;    contains the extra fields needed to be stored about each remote
        ;;    site.
        ;;
        ;;+---------------------------------------------------------------------------------------------------+
*)

Interface

Uses
  Classes,
  cMagKeepAliveThread,
  //cMagLogManager, {JK 10/5/2009 - Maggmsgu refactoring - deprecated unit}
  Maggmsgu,
  cMagUtils,
  IMagRemoteBrokerInterface,
  Trpcb,
  UMagClasses
  ;

//Uses Vetted 20090929:dialogs, umagutils, fmxutils, forms, MagFileVersion, hash, umagdefinitions, sysutils

Type
  TMagRemoteBroker = Class(TInterfacedObject, IMagRemoteBroker) //TObject)//, iMagRemoteBroker)
  Private
    RemoteBroker: TRPCBroker; // broker object
    ServerStatus: Integer; // status of the server connection
    PatientStatus: Integer; // status of the patient at this site
    PatientDFN: String; // the current patient's DFN at the site
    MagUtilities: TMagUtils; // magutilites
    WorkstationID: String; // the workstation ID of the user
    SiteUsername: String; // the Site parameters username for image shares
    SitePassword: String; // the Site parameters password for image shares
    SiteName: String; // the name of the site
    Sitecode: String; // the site code for this site
    RemoteDUZ: String; // the DUZ of the logged in user at the site.

    ImageCount: Integer; // the number of images at this remote site for the current patient

    ServerName: String;
    ServerPort: Integer;

    AlreadyHasNetworkLocations: Boolean;

    //FOnLogEvent : TMagLogEvent; {JK 10/5/2009 - Maggmsgu refactoring}

    FSite: TVistaSite;

    FKeepBrokerAlive: Boolean;
    FKeepAliveThread: TMagKeepAliveThread;

    // necessary for BSE connections
    FLocalBrokerPort: Integer;

    FSecurityTokenNeeded: TMagSecurityTokenNeededEvent;

    FLogCapriConnect: TMagLogCapriConnectionEvent;
    FRemoteApplicationType: TMagRemoteLoginApplication;

    Function SetRemoteSiteParameters(): Boolean;
    //procedure LogMsg(MsgType : String; Msg : String; Priority : TMagLogPriority = MagLogINFO); overload;  {JK 10/6/2009 - Maggmsgu refactoring - remove old method}
    //procedure LogMsg(MsgType : String; Msgs : TStrings; Priority : TMagLogPriority = MagLogINFO); overload;  {JK 10/6/2009 - Maggmsgu refactoring - remove old method}
    Function shouldUseBSE(): Boolean;
    {new "secure" login method, used with patch 94 and beyond}
    Function BSEConnect(): Boolean;
    {Old RIV login method, deprecated after patch 94}
    Function CAPRIConnect(UserSSN, UserFullName, UserLocalDUZ: String): Boolean;

    Function getBSEApplicationName(): String;

  Public
    {Constructor to create each remote broker object }
    Constructor Create(Server: String; Port: Integer; SName: String;
      SCode: String; Site: TVistaSite; localBrokerPort: Integer;
      SecurityTokenNeeded: TMagSecurityTokenNeededEvent;
      LogCapriConnect: TMagLogCapriConnectionEvent;
      RemoteApplicationType: TMagRemoteLoginApplication);
    {Get the broker object}
    Function GetBroker(): TRPCBroker;
    {Set the patient's remote DFN based on the Patients ICN }
    Function SetPatientDFN(PatientICN: String): Boolean;
    {Retrieve the number of images the patient has at the remote site}
    Function CountImages(): Integer;
    {Connect this remote site}
    Function Connect(UserFullName: String; UserLocalDUZ: String; UserSSN: String): Boolean;
    {Get the server name (IP address)}
    Function GetServerName(): String;
    {Get the server port}
    Function GetServerPort(): Integer;
    {Clear the patient fields at the remote site}
    Procedure ClearPatient();
    {Disconnect this remote site}
    Procedure Disconnect();
    {Get the status of the server connection (CONNECTED, DISCONNECTED)}
    Function GetServerStatus(): Integer;
    {Get the patient status of this remote site (ACTIVE, INACTIVE)}
    Function GetPatientStatus(): Integer;
    {Get the DFN of the patient at the remote site}
    Function GetRemotePatientDFN(): String;
    {Set the patient as active at this remote site}
    Procedure SetPatientActive();
    {Set the patient inactive at this remote site}
    Procedure SetPatientInactive();
    {Set the Workstation ID for this remote site}
    Procedure SetWorkstationID(WrksID: String);
    {Get the username for image access at this remote site (from the Imaging Site Parameters}
    Function GetSiteUsername(): String;
    {Get the password for image access at this remote site (from the Imaging Site Parameters}
    Function GetSitePassword(): String;
    {Get the decrypted password for image access}
    Function GetSiteDescryptedPassword(): String;
    {Get the site Code for this remote site}
    Function GetSiteCode(): String;
    {Get the site Name}
    Function GetSiteName(): String;
    {Clear the broker fields}
    Procedure clearBrokerFields();
    {Retrieve the network shares for this remote site}
    Procedure GetNetworkLocations(Var Shares: TStrings);
    {Check the version of imaging at the remote site}
    Function CheckRemoteImagingVersion(): Boolean;
    {Returns the number of images at the remote site for the patient(doesn't count the images, returns the value)}
    Function GetImageCount(): Integer;
    {Start a session for the user at the remote site}
    Procedure CreateSession(AppPath, DispAppName, CapAppName, Compname, Location, LastUpdate: String; Startmode: Integer);
    {ReOpen an old connection to a remote site}
    Function ReOpenConnection(UserFullName, UserLocalDUZ, UserSSN: String): Boolean; // this is used if the broker was already created but it was closed or there was an error.
    // this function is used for setting the server details without using the connect function (happens if the server is not to be connected to.)
    Procedure SetServerDetails(Server: String; Port: Integer);
    {Check if the patient is sensitive at the remote site}
    Procedure CheckSensitiveAccess(Var SensitveCode: Integer; Var Msg: Tstringlist);
    {Log access to a restricted remote site for the selected patient}
    Procedure LogRestrictedAccess();

//    property OnLogEvent : TMagLogEvent read FOnLogEvent write FOnLogEvent;
    {gek this was not 45, it was 46, seems 72 has function to replace it.}
//    property RemoteUserDUZ : String read RemoteDUZ;
    //procedure setLogEvent(LogEvent : TMagLogEvent);  {JK 10/6/2009 - Maggmsgu refactoring - remove old method}
    //function getLogEvent() : TMagLogEvent;  {JK 10/6/2009 - Maggmsgu refactoring - remove old method}
    Function GetRemoteUserDUZ(): String;

    Function GetPatientStudies(Pkg, Cls, Types, Event, Spc,
      FrDate, ToDate, Origin: String; Var Results: TStrings; Var Partial_Returned: Boolean; Var Partial_Msg: String): TMagPatientStudyResponse;   {/ P117 NCAT - JK 11/30/2010 /}
    Function GetServerDescription(): String;
    Procedure GetImageGlobalLookup(Ien: String; Var Rlist: TStrings);
    Procedure GetMagDevFields(Ien, Flags: String; Var Output: Tstringlist);
    Procedure LogCopyAccess(IObj: TImageData; Msg: String;
      EventType: TMagImageAccessEventType);
    Procedure GetImageInformation(IObj: TImageData; Var Output: TStrings);
    Function Getreport(IObj: TImageData): TStrings;
    Procedure LogOfflineImageAccess(IObj: TImageData);
    Procedure LogAction(Msg: String);
    Function QueImage(ImgType: String; IObj: TImageData): TStrings;
    Function QueImageGroup(Images: String; IObj: TImageData): String;
    Procedure GetImageGroup(IObj: TImageData; NoQAcheck: Boolean; Output: TStrings);
    Function IsBrokerLateCountUpdate(): Boolean;
    Function GetRemoteBrokerType(): TMagRemoteBrokerType;
    Function GetSite(): TVistaSite;

    Procedure KeepBrokerAlive(Enabled: Boolean);
    Procedure LogCapriLogin();

    Procedure RPMagTeleReaderUnreadlistGet(Var t: TStrings;
      AcquisitionPrimaryDivision, Sitecode, SpecialtyCode, ProcedureStrings,
      LastUpdate, UserDUZ, LocalSiteCode, SiteTimeOut, StatusOptions: String);
    Procedure RPMagTeleReaderUnreadlistLock(Var Xmsg: String;
      AcquisitionPrimaryDivision, AcquisitionSiteCode, ItemID, LockUnlockValue,
      UserFullName, UserInitials, LocalDUZ, LocalSiteCode: String);

  Protected

  End;
{Get the status value based on the status code}
Function GetStatusDetails(StatusCode: Integer): String;

// constant values for the status of this remote broker
Const
  STATUS_DISCONNECTED = 1;
Const
  STATUS_CONNECTED = 2;
Const
  STATUS_PATIENTINACTIVE = 3;
Const
  STATUS_CONNECTING = 4;
Const
  STATUS_WRONGVERSION = 5;
Const
  STATUS_PATIENTACTIVE = 6;

Implementation
Uses
  Fmxutils,
  Forms,
  Hash,
  Magfileversion,
  SysUtils,
  UMagDefinitions,
  Umagutils8
  ;

Function GetStatusDetails(StatusCode: Integer): String;
Var
  caption: String;
Begin
  caption := '';
  Case StatusCode Of
    STATUS_DISCONNECTED: caption := 'Server Disconnected';
    STATUS_CONNECTED: caption := 'Server Connected';
    STATUS_PATIENTINACTIVE: caption := 'Patient Inactive';
    STATUS_CONNECTING: caption := 'Server Connecting';
    STATUS_WRONGVERSION: caption := 'Server Wrong Version';
    STATUS_PATIENTACTIVE: caption := 'Patient Active';
  Else
    caption := 'Invalid Status Code';
  End;
  Result := caption;
End;

{JK 10/5/2009 - Maggmsgu refactoring - remove old method}
//procedure TMagRemoteBroker.LogMsg(MsgType : String; Msg : String; Priority : TMagLogPriority = MagLogINFO);
//begin
//  if assigned(FOnLogEvent) then
//    FOnLogEvent(self, MsgType, Msg, Priority);
//end;

{JK 10/5/2009 - Maggmsgu refactoring - remove old method}
//procedure TMagRemoteBroker.LogMsg(MsgType : String; Msgs : TStrings; Priority : TMagLogPriority = MagLogINFO);
//var
//   i : integer;
//begin
//  if assigned(FOnLogEvent) then
//  begin
//    for i := 0 to Msgs.Count - 1 do
//    begin
//      FOnLogEvent(self, MsgType, msgs.Strings[i], Priority);
//    end;
//
//  end;
//end;

Procedure TMagRemoteBroker.CreateSession(AppPath, DispAppName, CapAppName, Compname, Location, LastUpdate: String; Startmode: Integer);
Var
  DtCapture, DtDisplay: String;
Begin
  DtDisplay := '';
  DtCapture := '';

  If (CapAppName <> '') Then
  Begin
    Try
      DtCapture := Formatdatetime('mm/dd/yy@hh:mm', FILEDATETIME(CapAppName));
    Except
      DtCapture := '';
    End;
  End;
  If (DispAppName <> '') Then
  Begin
    Try
      DtDisplay := Formatdatetime('mm/dd/yy@hh:mm', FILEDATETIME(DispAppName));
    Except
      DtDisplay := '';
    End;
  End;

  RemoteBroker.REMOTEPROCEDURE := 'MAGG WRKS UPDATES';
  RemoteBroker.PARAM[0].PTYPE := LITERAL;
  RemoteBroker.PARAM[0].Value := Compname
    + '^' + DtCapture //2
    + '^' + DtDisplay //3
    + '^' + Location //4
    + '^' + LastUpdate //5
    + '^' + MagGetFileVersionInfo(DispAppName) //6
    + '^' + MagGetFileVersionInfo(CapAppName) //7
    + '^' + Inttostr(Startmode) //8
    + '^' + MagGetOSVersion //9
    + '^' //VistaRadVersion                        //10
    + '^' + RemoteBroker.Server //11
    + '^' + Inttostr(RemoteBroker.ListenerPort) //12
    + '^';
  RemoteBroker.Call;
  //LogMsg('s', 'Workstation Information sent to Remote VistA (' + self.ServerName + ', ' + inttostr(self.ServerPort) + '):');
  MagLogger.LogMsg('s', 'Workstation Information sent to Remote VistA (' + Self.ServerName + ', ' + Inttostr(Self.ServerPort) + '):'); {JK 10/6/2009 - Maggmsgu refactoring}
  //LogMsg('s', '  -> Result = ' + RemoteBroker.results[0]);
  MagLogger.LogMsg('s', '  -> Result = ' + RemoteBroker.Results[0]); {JK 10/6/2009 - Maggmsgu refactoring}
  //maggmsgf.magmsg('s', 'Workstation Information sent to Remote VistA (' + self.ServerName + ', ' + inttostr(self.ServerPort) + '):');
  //maggmsgf.magmsg('s', '  -> Result = ' + RemoteBroker.results[0]);
End;

Procedure TMagRemoteBroker.SetWorkstationID(WrksID: String);
Begin
  WorkstationID := WrksID;
End;

Function TMagRemoteBroker.GetBroker(): TRPCBroker;
Begin
  Result := RemoteBroker;
End;

Function TMagRemoteBroker.GetImageCount(): Integer;
Begin
  Result := ImageCount;
End;

Function TMagRemoteBroker.GetSiteCode(): String;
Begin
  Result := Sitecode;
End;

Function TMagRemoteBroker.GetSiteUsername(): String;
Begin
  Result := SiteUsername;
End;

Function TMagRemoteBroker.GetSitePassword(): String;
Begin
  Result := SitePassword;
End;

Procedure TMagRemoteBroker.SetServerDetails(Server: String; Port: Integer);
Begin
  ServerName := Server;
  ServerPort := Port;
End;

Function TMagRemoteBroker.GetSiteDescryptedPassword(): String;
Begin
  Result := Decrypt(SitePassword);
End;

Function TMagRemoteBroker.GetServerStatus(): Integer;
Begin
  Result := ServerStatus;
End;

Function TMagRemoteBroker.GetPatientStatus(): Integer;
Begin
  Result := PatientStatus;
End;

Procedure TMagRemoteBroker.SetPatientActive();
Begin
  PatientStatus := STATUS_PATIENTACTIVE;
End;

Procedure TMagRemoteBroker.SetPatientInactive();
Begin
  PatientStatus := STATUS_PATIENTINACTIVE;
End;

(*    This was in 45 and 46, not in 72
     procedure TMagRemoteBroker.setSiteName(sName : String);
     begin
       SiteName := sName;
     end; *)

Function TMagRemoteBroker.GetSiteName(): String;
Begin
  Result := SiteName;
End;

Function TMagRemoteBroker.GetRemotePatientDFN(): String;
Begin
  Result := PatientDFN;
End;

//constructor TMagRemoteBroker.Create();

Constructor TMagRemoteBroker.Create(Server: String; Port: Integer;
  SName: String; SCode: String; Site: TVistaSite; localBrokerPort: Integer;
  SecurityTokenNeeded: TMagSecurityTokenNeededEvent;
  LogCapriConnect: TMagLogCapriConnectionEvent;
  RemoteApplicationType: TMagRemoteLoginApplication);
Begin
  Inherited Create();
  RemoteBroker := Nil;
  FSite := Site;
  ServerStatus := STATUS_DISCONNECTED;
  PatientStatus := STATUS_PATIENTINACTIVE;
  clearBrokerFields();
  ServerName := Server;
  ServerPort := Port;
  SiteName := SName;
  Sitecode := SCode;
  ImageCount := 0;
  FLocalBrokerPort := localBrokerPort;
  FSecurityTokenNeeded := SecurityTokenNeeded;
  FLogCapriConnect := LogCapriConnect;
  FRemoteApplicationType := RemoteApplicationType;
End;

Procedure TMagRemoteBroker.clearBrokerFields();
Begin
  ServerName := '';
  ServerPort := 0;
  PatientDFN := '';
  SiteName := '';
  SitePassword := '';
  SiteUsername := '';
  WorkstationID := '';
  AlreadyHasNetworkLocations := False;
End;

Procedure TMagRemoteBroker.Disconnect();
Begin
  If ServerStatus <> STATUS_DISCONNECTED Then
  Begin
    If RemoteBroker.Connected Then
    Begin
      RemoteBroker.REMOTEPROCEDURE := 'MAGG LOGOFF';
      Try
        RemoteBroker.Call;
      Except
        On e: EBrokerError Do
          //LogMsg('s', 'Error Connecting to VISTA.' + #13 + #13 + E.MESSAGE + #13 + #13 + 'Shutdown will continue.', MagLogError);
          MagLogger.LogMsg('s', 'Error Connecting to VISTA.' + #13 + #13 + e.Message + #13 + #13 + 'Shutdown will continue.', MagLogERROR); {JK 10/6/2009 - Maggmsgu refactoring}
        //maggmsgf.magmsg('s', 'Error Connecting to VISTA.' + #13 + #13 + E.MESSAGE + #13 + #13 + 'Shutdown will continue.');
        On e: Exception Do
          //LogMsg('s', 'Error During Log Off : ' + e.message, MagLogError);
          MagLogger.LogMsg('s', 'Error During Log Off : ' + e.Message, MagLogERROR); {JK 10/6/2009 - Maggmsgu refactoring}
        //maggmsgf.magmsg('s', 'Error During Log Off : ' + e.message);
      Else
        //maggmsgf.magmsg('de', 'Unknown Error during Log Off');
        //LogMsg('de', 'Unknown Error during Log Off', MagLogError);
        MagLogger.LogMsg('de', 'Unknown Error during Log Off', MagLogERROR); {JK 10/6/2009 - Maggmsgu refactoring}
      End;
      RemoteBroker.Connected := False;
    End;
  End;
  RemoteBroker := Nil;
  ServerStatus := STATUS_DISCONNECTED;
  PatientStatus := STATUS_PATIENTINACTIVE;
  PatientDFN := '';
End;

Function TMagRemoteBroker.GetServerName(): String;
Begin
{
  if (ServerStatus = STATUS_CONNECTED) then
  begin
    result := ServerName;//RemoteBroker.Server;
  end
  else
  begin
    result := '';
  end;
  }
  Result := ServerName;
End;

Function TMagRemoteBroker.GetServerPort(): Integer;
Begin
{
  if (ServerStatus = STATUS_CONNECTED) then
  begin
    result := ServerPort;// RemoteBroker.listenerport;
  end
  else
  begin
    result := 0;
  end;
  }
  Result := ServerPort;
End;

Procedure TMagRemoteBroker.ClearPatient();
Begin
  PatientStatus := STATUS_PATIENTINACTIVE;
  PatientDFN := '';
  ImageCount := 0;
End;

Function TMagRemoteBroker.ReOpenConnection(UserFullName, UserLocalDUZ, UserSSN: String): Boolean; // this is used if the broker was already created but it was closed or there was an error.
Begin
  Result := Connect(UserFullName, UserLocalDUZ, UserSSN);
End;

Function TMagRemoteBroker.Connect(UserFullName: String; UserLocalDUZ: String; UserSSN: String): Boolean;
Begin
  If (ServerName = '') Or (ServerPort <= 0) Then
  Begin
    //LogMsg('s', 'Server/Port empty values, unable to connect to remote site [' + ServerName + ', ' + inttostr(Serverport) + ']');
    MagLogger.LogMsg('s', 'Server/Port empty values, unable to connect to remote site [' + ServerName + ', ' +
      Inttostr(ServerPort) + ']'); {JK 10/6/2009 - Maggmsgu refactoring}
    Result := False;
    Exit;
  End;
  RemoteDUZ := '';

  If shouldUseBSE() Then
  Begin
    If Not BSEConnect() Then
    Begin
      MagLogger.LogMsg('s', 'BSE Connect method failed, falling back to CAPRI method', MagLogERROR); {JK 10/6/2009 - Maggmsgu refactoring}
      If Not CAPRIConnect(UserSSN, UserFullName, UserLocalDUZ) Then
      Begin
        MagLogger.LogMsg('s', 'CAPRI Connect method failed', MagLogWARN); {JK 10/6/2009 - Maggmsgu refactoring}
        Result := False;
        Exit;
      End;
    End;
  End
  Else
  Begin
    If Not CAPRIConnect(UserSSN, UserFullName, UserLocalDUZ) Then
    Begin
       //LogMsg('s', 'CAPRI Connect method failed', MagLogWARN);
      MagLogger.LogMsg('s', 'CAPRI Connect method failed', MagLogWARN); {JK 10/6/2009 - Maggmsgu refactoring}
      Result := False;
      Exit;
    End;
  End;

  //LogMsg('s', 'User Remote DUZ: ' + RemoteDUZ);
  MagLogger.LogMsg('s', 'User Remote DUZ: ' + RemoteDUZ); {JK 10/6/2009 - Maggmsgu refactoring}
  PatientStatus := STATUS_PATIENTACTIVE;
  ServerStatus := STATUS_CONNECTED;

  Result := True;

End;

Function TMagRemoteBroker.SetRemoteSiteParameters(): Boolean;
Var
  Rlist: TStrings;
  Rstat: Boolean;
  Consolidated: String;
Begin
  Rlist := Tstringlist.Create();
  Rstat := False;
  With RemoteBroker Do
  Begin
    PARAM[0].Value := WorkstationID;
    PARAM[0].PTYPE := LITERAL;
    RemoteBroker.REMOTEPROCEDURE := 'MAGGUSER2';
  End;
  Try
    RemoteBroker.LstCALL(Rlist);
    If (Rlist.Count <= 2) Or (MagUtilities.MagPiece(Rlist[0], '^', 1) = '0') Then
    Begin
      Rstat := False;
//        maggmsgf.MagMsg('', 'Error accessing Site Parameters for Remote Broker [' + RemoteBroker.Server + ',' + inttostr(RemoteBroker.ListenerPort) + ']');
        //LogMsg('', 'Error accessing Site Parameters for Remote Broker [' + RemoteBroker.Server + ',' + inttostr(RemoteBroker.ListenerPort) + ']', MagLogError);
      MagLogger.LogMsg('', 'Error accessing Site Parameters for Remote Broker [' + RemoteBroker.Server + ',' +
        Inttostr(RemoteBroker.ListenerPort) + ']', MagLogERROR); {JK 10/6/2009 - Maggmsgu refactoring}
      Result := Rstat;
      Exit;
    End;
    Rstat := True;

    SiteUsername := MagUtilities.MagPiece(Rlist[2], '^', 1);
    SitePassword := MagUtilities.MagPiece(Rlist[2], '^', 2);

    Consolidated := MagPiece(Rlist[4], '^', 5);
//    maggmsgf.magmsg('', 'Consolidated value [' + Consolidated + '] @ [' + RemoteBroker.Server + ',' + inttostr(RemoteBroker.ListenerPort)+ ']');
    //LogMsg('', 'Consolidated value [' + Consolidated + '] @ [' + RemoteBroker.Server + ',' + inttostr(RemoteBroker.ListenerPort)+ ']');
    MagLogger.LogMsg('', 'Consolidated value [' + Consolidated + '] @ [' + RemoteBroker.Server + ',' +
      Inttostr(RemoteBroker.ListenerPort) + ']'); {JK 10/6/2009 - Maggmsgu refactoring}

  Except
    On e: Exception Do
    Begin
//        maggmsgf.MagMsg('', 'Error accessing Site Parameters for Remote Broker [' + RemoteBroker.Server + ',' + inttostr(RemoteBroker.ListenerPort) + '], ' + e.Message);
        //LogMsg('', 'Error accessing Site Parameters for Remote Broker [' + RemoteBroker.Server + ',' + inttostr(RemoteBroker.ListenerPort) + '], ' + e.Message, MagLogError);
      MagLogger.LogMsg('', 'Error accessing Site Parameters for Remote Broker [' + RemoteBroker.Server + ',' +
        Inttostr(RemoteBroker.ListenerPort) + '], ' + e.Message, MagLogERROR); {JK 10/6/2009 - Maggmsgu refactoring}
      Rstat := False;
    End;
  End;
  Result := Rstat;
End;

Procedure TMagRemoteBroker.GetNetworkLocations(Var Shares: TStrings);
Var
  i, j, StringCount: Integer;
  ShareValue, FirstPart, SecondPart: String;
Begin
  If AlreadyHasNetworkLocations Then Exit;
  SetRemoteSiteParameters();
  If Shares = Nil Then
  Begin
    Shares := Tstringlist.Create();
  End;
  // not sure if we care if the patient is active or not... definately care that the connection is ok
  If (ServerStatus <> STATUS_CONNECTED) Or (PatientStatus <> STATUS_PATIENTACTIVE) Then Exit;
  Try
    RemoteBroker.PARAM[0].Value := 'ALL';
    RemoteBroker.PARAM[0].PTYPE := LITERAL;
    RemoteBroker.REMOTEPROCEDURE := 'MAG GET NETLOC';
    RemoteBroker.LstCALL(Shares);
    If (MagUtilities.MagPiece(Shares[0], '^', 1) = '0') Then
    Begin
//        maggmsgf.MagMsg('', magutilities.magpiece(Shares[0], '^', 2));
        //LogMsg('', magutilities.magpiece(Shares[0], '^', 2));
      MagLogger.LogMsg('', MagUtilities.MagPiece(Shares[0], '^', 2)); {JK 10/6/2009 - Maggmsgu refactoring}
      Exit;
    End;
    If (Shares.Count = 0) Then
    Begin
//        maggmsgf.MagMsg('', 'Error accessing Network Locations');
        //LogMsg('', 'Error accessing Network Locations', MagLogError);
      MagLogger.LogMsg('', 'Error accessing Network Locations', MagLogERROR); {JK 10/6/2009 - Maggmsgu refactoring}
      Exit;
    End;
    Shares.Delete(0);

  Except
    On e: Exception Do
    Begin
//        maggmsgf.MagMsg('', 'Error accessing Network Locations. Error=[' + e.Message + ']');
        //LogMsg('', 'Error accessing Network Locations. Error=[' + e.Message + ']', MagLogError);
      MagLogger.LogMsg('', 'Error accessing Network Locations. Error=[' + e.Message + ']', MagLogERROR); {JK 10/6/2009 - Maggmsgu refactoring}
      Shares[0] := 'The Attempt to get network locations. Check VistA Error Log.';
    End;
  End;

  For i := 0 To Shares.Count - 1 Do
  Begin
    If MagUtilities.MagPiece(Shares.Strings[i], '^', 5) = '' Then
    Begin
      FirstPart := '';
      SecondPart := '';
      ShareValue := Shares.Strings[i];
      StringCount := MagUtilities.Maglength(ShareValue, '^');
      For j := 1 To 4 Do
      Begin
        FirstPart := FirstPart + MagUtilities.MagPiece(ShareValue, '^', j) + '^';
      End;
      FirstPart := FirstPart + SiteUsername + '^' + SitePassword;
      For j := 7 To StringCount Do
      Begin
        SecondPart := SecondPart + '^' + MagUtilities.MagPiece(ShareValue, '^', j);
      End;
      Shares.Strings[i] := FirstPart + SecondPart;

    End
  End;
  AlreadyHasNetworkLocations := True;
End;

Function TMagRemoteBroker.CountImages(): Integer;
Var
  Count: Integer;
  Fstring: String;
Begin
  If PatientStatus = STATUS_PATIENTACTIVE Then
  Begin
    RemoteBroker.PARAM[0].PTYPE := LITERAL;
    RemoteBroker.PARAM[0].Value := PatientDFN;
    (*
       enable this parameter in Version 41 CCOW
          FBroker.Param[1].Ptype := literal;
          FBroker.Param[1].Value := magbooltostrint(isicn);
    *)
    RemoteBroker.REMOTEPROCEDURE := 'MAGG PAT INFO';
    Try
      Fstring := RemoteBroker.STRCALL;
      If (MagUtilities.MagPiece(Fstring, '^', 1) = '0') Then
      Begin
        Count := 0;
      End
      Else
      Begin
        Count := Strtoint(MagUtilities.MagPiece(Fstring, '^', 10));
      End;
    Except
      On e: Exception Do
      Begin
        Fstring := '0^' + MagUtilities.MagPiece(e.Message, #$A, 2);
//          maggmsgf.MagMsg('s', 'Error retrieving image count at remote site [' + RemoteBroker.Server + ', ' + inttostr(RemoteBroker.ListenerPort) + '], Error=[' + e.Message + '], ' +  formatdatetime('mm/dd/yy@hh:nn:ss.zzz', now));
          //LogMsg('s', 'Error retrieving image count at remote site [' + RemoteBroker.Server + ', ' + inttostr(RemoteBroker.ListenerPort) + '], Error=[' + e.Message + '], ' +  formatdatetime('mm/dd/yy@hh:nn:ss.zzz', now), MagLogError);
        MagLogger.LogMsg('s', 'Error retrieving image count at remote site [' + RemoteBroker.Server + ', ' +
          Inttostr(RemoteBroker.ListenerPort) + '], Error=[' + e.Message + '], ' +
          Formatdatetime('mm/dd/yy@hh:nn:ss.zzz', Now), MagLogERROR); {JK 10/6/2009 - Maggmsgu refactoring}
        Count := 0;
        ImageCount := 0;
      End;
    End;
    Result := Count;
    ImageCount := Count;
//    maggmsgf.MagMsg('s', '[' + inttostr(count) + '] image(s) at remote site [' + RemoteBroker.Server + ', ' + inttostr(RemoteBroker.ListenerPort) + '] for selected patient.' + formatdatetime('mm/dd/yy@hh:nn:ss.zzz', now));
    //LogMsg('s', '[' + inttostr(count) + '] image(s) at remote site [' + RemoteBroker.Server + ', ' + inttostr(RemoteBroker.ListenerPort) + '] for selected patient.' + formatdatetime('mm/dd/yy@hh:nn:ss.zzz', now));
    MagLogger.LogMsg('s', '[' + Inttostr(Count) + '] image(s) at remote site [' + RemoteBroker.Server + ', ' +
      Inttostr(RemoteBroker.ListenerPort) + '] for selected patient.' +
      Formatdatetime('mm/dd/yy@hh:nn:ss.zzz', Now)); {JK 10/6/2009 - Maggmsgu refactoring}
  End
  Else
  Begin
    Result := 0;
    ImageCount := 0;
//    maggmsgf.MagMsg('s', '[0] image(s) at remote site [' + RemoteBroker.Server + ', ' + inttostr(RemoteBroker.ListenerPort) + '] for selected patient.' + formatdatetime('mm/dd/yy@hh:nn:ss.zzz', now));
    //LogMsg('s', '[0] image(s) at remote site [' + RemoteBroker.Server + ', ' + inttostr(RemoteBroker.ListenerPort) + '] for selected patient.' + formatdatetime('mm/dd/yy@hh:nn:ss.zzz', now));
    MagLogger.LogMsg('s', '[0] image(s) at remote site [' + RemoteBroker.Server + ', ' +
      Inttostr(RemoteBroker.ListenerPort) + '] for selected patient.' +
      Formatdatetime('mm/dd/yy@hh:nn:ss.zzz', Now)); {JK 10/6/2009 - Maggmsgu refactoring}
  End;
End;

Function TMagRemoteBroker.SetPatientDFN(PatientICN: String): Boolean;
Var
  Fstring: String;
  Ret: Boolean;
Begin
  Result := False;
  If ServerStatus <> STATUS_CONNECTED Then Exit;
  If PatientStatus <> STATUS_PATIENTACTIVE Then Exit;

  // JMW 6/19/2009 P93T8 - changing logic to use RPC instead of changing
  // context and finding the value. This should work because this RPC was
  // registered to MAG WINDOWS as part of P45, so it should be on all systems
  // now.
  PatientDFN := '';
  RemoteBroker.REMOTEPROCEDURE := 'VAFCTFU CONVERT ICN TO DFN';
  RemoteBroker.PARAM[0].PTYPE := LITERAL;
  RemoteBroker.PARAM[0].Value := PatientICN;
  Try
    Fstring := RemoteBroker.STRCALL;
    If MagPiece(Fstring, '^', 1) = '-1' Then
    Begin
      //LogMsg('s', 'Unable to find patient ICN at remote site [' +
      //  RemoteBroker.Server + ', ' + inttostr(RemoteBroker.ListenerPort) +
      //  '], setting broker inactive for this patient.' +
      //  formatdatetime('mm/dd/yy@hh:nn:ss.zzz', now),
      //  MagLogError);
      MagLogger.LogMsg('s', 'Unable to find patient ICN at remote site [' +
        RemoteBroker.Server + ', ' + Inttostr(RemoteBroker.ListenerPort) +
        '], setting broker inactive for this patient.' +
        Formatdatetime('mm/dd/yy@hh:nn:ss.zzz', Now),
        MagLogERROR); {JK 10/6/2009 - Maggmsgu refactoring}
      PatientDFN := '';
      PatientStatus := STATUS_PATIENTINACTIVE;
      Result := False;
    End
    Else
    Begin
      Result := True;
      //LogMsg('s', 'Found DFN [' + fstring + '] for patient at remote site [' +
      //  self.getServerDescription  + '].',
      //  MagLogInfo);
      MagLogger.LogMsg('s', 'Found DFN [' + Fstring + '] for patient at remote site [' +
        Self.GetServerDescription + '].',
        MagLogINFO); {JK 10/6/2009 - Maggmsgu refactoring}
      PatientDFN := Fstring;
    End;
  Except
    On e: Exception Do
    Begin
      PatientDFN := '';
      //LogMsg('s', 'Error looking up patient ICN at remote site [' +
      //  RemoteBroker.Server + ', ' + inttostr(RemoteBroker.ListenerPort) +
      //  ']. Error is [' + e.Message + '] , setting broker inactive for this patient.' +
      //  formatdatetime('mm/dd/yy@hh:nn:ss.zzz', now), MagLogError);
      MagLogger.LogMsg('s', 'Error looking up patient ICN at remote site [' +
        RemoteBroker.Server + ', ' + Inttostr(RemoteBroker.ListenerPort) +
        ']. Error is [' + e.Message + '] , setting broker inactive for this patient.' +
        Formatdatetime('mm/dd/yy@hh:nn:ss.zzz', Now), MagLogERROR); {JK 10/6/2009 - Maggmsgu refactoring}
      Result := False;
    End;
  End;

               {

  ret := RemoteBroker.CreateContext('DVBA CAPRI GUI');
  if not ret then
  begin
    result := false;
    PatientDFN := '';
    PatientStatus := STATUS_PATIENTINACTIVE;
    ServerStatus := STATUS_DISCONNECTED;
    // should probably set this broker disconnected since it won't work for any patient...
//    maggmsgf.MagMsg('s', 'Unable to set CAPRI context to retrieve DFN at remote site [' + RemoteBroker.Server + ', ' + inttostr(RemoteBroker.ListenerPort) + '], disconnecting broker.' + formatdatetime('mm/dd/yy@hh:nn:ss.zzz', now));
    LogMsg('s', 'Unable to set CAPRI context to retrieve DFN at remote site [' + RemoteBroker.Server + ', ' + inttostr(RemoteBroker.ListenerPort) + '], disconnecting broker.' + formatdatetime('mm/dd/yy@hh:nn:ss.zzz', now), MagLogError);
    if not RemoteBroker.CreateContext('MAG WINDOWS') then
    begin
//      maggmsgf.MagMsg('s', 'Unable to reset MAG WINDOWS context at remote site [' + RemoteBroker.Server + ', ' + inttostr(RemoteBroker.ListenerPort) + '], disconnecting broker.' + formatdatetime('mm/dd/yy@hh:nn:ss.zzz', now));
      LogMsg('s', 'Unable to reset MAG WINDOWS context at remote site [' + RemoteBroker.Server + ', ' + inttostr(RemoteBroker.ListenerPort) + '], disconnecting broker.' + formatdatetime('mm/dd/yy@hh:nn:ss.zzz', now), MagLogError);
      RemoteBroker := nil;
      ServerStatus := STATUS_DISCONNECTED;
      PatientStatus := STATUS_PATIENTINACTIVE;
      PatientDFN := '';
    end;
    exit;
  end;
  RemoteBroker.RemoteProcedure := 'XWB GET VARIABLE VALUE';
  RemoteBroker.Param[0].Value := '$O(^DPT("AICN","' + PatientICN + '",""))';
  RemoteBroker.param[0].PType := reference;
  try
    RemoteBroker.Call;
    if RemoteBroker.Results.Count <= 0 then
    begin
//      maggmsgf.MagMsg('s', 'Unable to find patient ICN at remote site [' + RemoteBroker.Server + ', ' + inttostr(RemoteBroker.ListenerPort) + '], setting broker inactive for this patient.' + formatdatetime('mm/dd/yy@hh:nn:ss.zzz', now));
      LogMsg('s', 'Unable to find patient ICN at remote site [' + RemoteBroker.Server + ', ' + inttostr(RemoteBroker.ListenerPort) + '], setting broker inactive for this patient.' + formatdatetime('mm/dd/yy@hh:nn:ss.zzz', now), MagLogError);
      RemoteBroker.CreateContext('MAG WINDOWS');  // reset context back to MAG WINDOWS
      PatientStatus := STATUS_PATIENTINACTIVE;
      result := false;
      exit;
    end;
    FString := RemoteBroker.Results[0];
    PatientDFN := FString;
  except
    on E: Exception do
    begin
//      maggmsgf.MagMsg('s', 'Error looking up patient ICN at remote site [' + RemoteBroker.Server + ', ' + inttostr(RemoteBroker.ListenerPort) + ']. Error is [' + e.Message + '] , setting broker inactive for this patient.' + formatdatetime('mm/dd/yy@hh:nn:ss.zzz', now));
      LogMsg('s', 'Error looking up patient ICN at remote site [' + RemoteBroker.Server + ', ' + inttostr(RemoteBroker.ListenerPort) + ']. Error is [' + e.Message + '] , setting broker inactive for this patient.' + formatdatetime('mm/dd/yy@hh:nn:ss.zzz', now), MagLogError);
      RemoteBroker.CreateContext('MAG WINDOWS');  // reset context back to MAG WINDOWS
      PatientStatus := STATUS_PATIENTINACTIVE;
      result := false;
      exit;
    end;
  end;

  RemoteBroker.CreateContext('MAG WINDOWS');
  result := true;
  }
End;

Function TMagRemoteBroker.CheckRemoteImagingVersion(): Boolean;
Var
  Reslist: TStrings;
  ResCode: Integer;
  FirstAttempt: Boolean;
  P63Version: String;
Begin
  Result := False;
  FirstAttempt := True;
  Reslist := Tstringlist.Create();
  RemoteBroker.REMOTEPROCEDURE := 'MAG4 VERSION CHECK';
  RemoteBroker.PARAM[0].PTYPE := LITERAL;
  RemoteBroker.PARAM[0].Value := MagGetFileVersionInfo(Application.ExeName) + '|RIV|';

  Try
    RemoteBroker.LstCALL(Reslist);
    If (Reslist.Count = 0) Then
    Begin
//        maggmsgf.magmsg('', 'Error Checking Version on Server at remote site [' + RemoteBroker.Server + ', ' + inttostr(RemoteBroker.ListenerPort) + '].');
        //LogMsg('', 'Error Checking Version on Server at remote site [' + RemoteBroker.Server + ', ' + inttostr(RemoteBroker.ListenerPort) + '].', MagLogError);
      MagLogger.LogMsg('', 'Error Checking Version on Server at remote site [' + RemoteBroker.Server + ', ' +
        Inttostr(RemoteBroker.ListenerPort) + '].', MagLogERROR); {JK 10/6/2009 - Maggmsgu refactoring}
      Result := False;
      Exit;
    End;

  Except
    On e: Exception Do
    Begin
//        maggmsgf.magmsg('de', 'Exception Checking Version on Server at remote site [' + RemoteBroker.Server + ', ' + inttostr(RemoteBroker.ListenerPort) + ']. Error is [' + e.message + ']');
        //LogMsg('de', 'Exception Checking Version on Server at remote site [' + RemoteBroker.Server + ', ' + inttostr(RemoteBroker.ListenerPort) + ']. Error is [' + e.message + ']', MagLogError);
      MagLogger.LogMsg('de', 'Exception Checking Version on Server at remote site [' + RemoteBroker.Server + ', ' +
        Inttostr(RemoteBroker.ListenerPort) + ']. Error is [' + e.Message + ']', MagLogERROR); {JK 10/6/2009 - Maggmsgu refactoring}
      Result := False;
      Exit;
    End;
  End;

  Try

    Try
      ResCode := Strtoint(MagUtilities.MagPiece(Reslist[0], '^', 1));
    Except
      ResCode := 0;
    End;
    If Reslist[0] = '1^Version not Checked, continue' Then
    Begin
      ResCode := 2;
    End;

    Case ResCode Of
      {         Warning : Display the warning and continue. {}
      0:
        Begin
//           MaggMsgf.magmsg('s', 'First Attempt, Result of Version check = 0 at remote site [' + RemoteBroker.Server + ', ' + inttostr(RemoteBroker.ListenerPort) + '].');
           //LogMsg('s', 'First Attempt, Result of Version check = 0 at remote site [' + RemoteBroker.Server + ', ' + inttostr(RemoteBroker.ListenerPort) + '].');
          MagLogger.LogMsg('s', 'First Attempt, Result of Version check = 0 at remote site [' + RemoteBroker.Server + ', ' +
            Inttostr(RemoteBroker.ListenerPort) + '].'); {JK 10/6/2009 - Maggmsgu refactoring}
          Result := True;
          Exit;
        End;

      {         OK to continue {}
      1:
        Begin
//           MaggMsgf.magmsg('s', 'First Attempt, Result of Version check = 1 at remote site [' + RemoteBroker.Server + ', ' + inttostr(RemoteBroker.ListenerPort) + '].');
           //LogMsg('s', 'First Attempt, Result of Version check = 1 at remote site [' + RemoteBroker.Server + ', ' + inttostr(RemoteBroker.ListenerPort) + '].');
          MagLogger.LogMsg('s', 'First Attempt, Result of Version check = 1 at remote site [' + RemoteBroker.Server + ', ' +
            Inttostr(RemoteBroker.ListenerPort) + '].'); {JK 10/6/2009 - Maggmsgu refactoring}
          Result := True;
          Exit;
        End;

      {         Must Terminate {}
      2:
        Begin
//           MaggMsgf.magmsg('s', 'First Attempt, Invalid Server Version at remote site [' + RemoteBroker.Server + ', ' + inttostr(RemoteBroker.ListenerPort) + '].');
           //LogMsg('s', 'First Attempt, Invalid Server Version at remote site [' + RemoteBroker.Server + ', ' + inttostr(RemoteBroker.ListenerPort) + '].');
          MagLogger.LogMsg('s', 'First Attempt, Invalid Server Version at remote site [' + RemoteBroker.Server + ', ' +
            Inttostr(RemoteBroker.ListenerPort) + '].'); {JK 10/6/2009 - Maggmsgu refactoring}
          FirstAttempt := False;
        End;
      3:
        Begin
          FirstAttempt := True;
        End;
    Else
      //LogMsg('s', 'First Attempt, Undocumented Result of Version Check : ' + inttostr(rescode) + ' at remote site [' + RemoteBroker.Server + ', ' + inttostr(RemoteBroker.ListenerPort) + '], continuing.'); //MaggMsgf.magmsg('s', 'First Attempt, Undocumented Result of Version Check : ' + inttostr(rescode) + ' at remote site [' + RemoteBroker.Server + ', ' + inttostr(RemoteBroker.ListenerPort) + '], continuing.');
      MagLogger.LogMsg('s', 'First Attempt, Undocumented Result of Version Check : ' +
        Inttostr(ResCode) + ' at remote site [' + RemoteBroker.Server + ', ' +
        Inttostr(RemoteBroker.ListenerPort) + '], continuing.');
          //MaggMsgf.magmsg('s', 'First Attempt, Undocumented Result of Version Check : ' + inttostr(rescode) + ' at remote site [' + RemoteBroker.Server + ', ' + inttostr(RemoteBroker.ListenerPort) + '], continuing.'); {JK 10/6/2009 - Maggmsgu refactoring}
    End;
  Finally
    Reslist.Free;
  End;

  If FirstAttempt Then
  Begin
    Result := True;
    Exit;
  End;

  P63Version := MagGetFileVersionInfo(Application.ExeName);
  P63Version := MagSetPiece(P63Version, '.', 3, '63');

  Reslist := Tstringlist.Create();
  RemoteBroker.REMOTEPROCEDURE := 'MAG4 VERSION CHECK';
  RemoteBroker.PARAM[0].PTYPE := LITERAL;
  RemoteBroker.PARAM[0].Value := P63Version;

  Try
    RemoteBroker.LstCALL(Reslist);
    If (Reslist.Count = 0) Then
    Begin
//        maggmsgf.magmsg('', 'Second Attempt, Error Checking Version on Server at remote site [' + RemoteBroker.Server + ', ' + inttostr(RemoteBroker.ListenerPort) + '].');
        //LogMsg('', 'Second Attempt, Error Checking Version on Server at remote site [' + RemoteBroker.Server + ', ' + inttostr(RemoteBroker.ListenerPort) + '].');
      MagLogger.LogMsg('', 'Second Attempt, Error Checking Version on Server at remote site [' + RemoteBroker.Server + ', ' +
        Inttostr(RemoteBroker.ListenerPort) + '].'); {JK 10/6/2009 - Maggmsgu refactoring}
      Result := False;
      Exit;
    End;

  Except
    On e: Exception Do
    Begin
//        maggmsgf.magmsg('de', 'Second Attempt, Exception Checking Version on Server at remote site [' + RemoteBroker.Server + ', ' + inttostr(RemoteBroker.ListenerPort) + ']. Error is [' + e.message + ']');
        //LogMsg('de', 'Second Attempt, Exception Checking Version on Server at remote site [' + RemoteBroker.Server + ', ' + inttostr(RemoteBroker.ListenerPort) + ']. Error is [' + e.message + ']');
      MagLogger.LogMsg('de', 'Second Attempt, Exception Checking Version on Server at remote site [' + RemoteBroker.Server + ', ' +
        Inttostr(RemoteBroker.ListenerPort) + ']. Error is [' + e.Message + ']'); {JK 10/6/2009 - Maggmsgu refactoring}
      Result := False;
      Exit;
    End;
  End;

  Try

    Try
      ResCode := Strtoint(MagUtilities.MagPiece(Reslist[0], '^', 1));
    Except
      ResCode := 0;
    End;
    If Reslist[0] = '1^Version not Checked, continue' Then
    Begin
      ResCode := 2;
    End;

    Case ResCode Of
      {         Warning : Display the warning and continue. {}
      0:
        Begin
//           MaggMsgf.magmsg('s', 'Second Attempt, Result of Version check = 0 at remote site [' + RemoteBroker.Server + ', ' + inttostr(RemoteBroker.ListenerPort) + '].');
           //LogMsg('s', 'Second Attempt, Result of Version check = 0 at remote site [' + RemoteBroker.Server + ', ' + inttostr(RemoteBroker.ListenerPort) + '].');
          MagLogger.LogMsg('s', 'Second Attempt, Result of Version check = 0 at remote site [' + RemoteBroker.Server + ', ' +
            Inttostr(RemoteBroker.ListenerPort) + '].'); {JK 10/6/2009 - Maggmsgu refactoring}
          Result := True;
          Exit;
        End;

      {         OK to continue {}
      1:
        Begin
//           MaggMsgf.magmsg('s', 'Second Attempt, Result of Version check = 1 at remote site [' + RemoteBroker.Server + ', ' + inttostr(RemoteBroker.ListenerPort) + '].');
           //LogMsg('s', 'Second Attempt, Result of Version check = 1 at remote site [' + RemoteBroker.Server + ', ' + inttostr(RemoteBroker.ListenerPort) + '].');
          MagLogger.LogMsg('s', 'Second Attempt, Result of Version check = 1 at remote site [' + RemoteBroker.Server + ', ' +
            Inttostr(RemoteBroker.ListenerPort) + '].'); {JK 10/6/2009 - Maggmsgu refactoring}
          Result := True;
          Exit;
        End;

      {         Must Terminate {}
      2:
        Begin
//           MaggMsgf.magmsg('s', 'Second Attempt, Invalid Server Version at remote site [' + RemoteBroker.Server + ', ' + inttostr(RemoteBroker.ListenerPort) + ']. Site Will not be used.');
           //LogMsg('s', 'Second Attempt, Invalid Server Version at remote site [' + RemoteBroker.Server + ', ' + inttostr(RemoteBroker.ListenerPort) + ']. Site Will not be used.');
          MagLogger.LogMsg('s', 'Second Attempt, Invalid Server Version at remote site [' + RemoteBroker.Server + ', ' +
            Inttostr(RemoteBroker.ListenerPort) + ']. Site Will not be used.'); {JK 10/6/2009 - Maggmsgu refactoring}
          FirstAttempt := False;
          Result := False;
          Exit;
        End;
      3:
        Begin
          FirstAttempt := True;
        End;
    Else
      //LogMsg('s', 'Second Attempt, Undocumented Result of Version Check : ' + inttostr(rescode) + ' at remote site [' + RemoteBroker.Server + ', ' + inttostr(RemoteBroker.ListenerPort) + '], continuing.');//MaggMsgf.magmsg('s', 'Second Attempt, Undocumented Result of Version Check : ' + inttostr(rescode) + ' at remote site [' + RemoteBroker.Server + ', ' + inttostr(RemoteBroker.ListenerPort) + '], continuing.');
      MagLogger.LogMsg('s', 'Second Attempt, Undocumented Result of Version Check : ' +
        Inttostr(ResCode) + ' at remote site [' + RemoteBroker.Server + ', ' +
        Inttostr(RemoteBroker.ListenerPort) + '], continuing.');
          //MaggMsgf.magmsg('s', 'Second Attempt, Undocumented Result of Version Check : ' + inttostr(rescode) + ' at remote site [' + RemoteBroker.Server + ', ' + inttostr(RemoteBroker.ListenerPort) + '], continuing.'); {JK 10/6/2009 - Maggmsgu refactoring}
    End;
  Finally
    Reslist.Free;
  End;

  If FirstAttempt Then
  Begin
    Result := True;
    Exit;
  End;
End;

Procedure TMagRemoteBroker.CheckSensitiveAccess(Var SensitveCode: Integer; Var Msg: Tstringlist);
Begin
//  MaggMsgf.magmsg('s', 'Checking patient sensitive at remote site [' + RemoteBroker.Server + ', ' + inttostr(RemoteBroker.ListenerPort) + '].');
  //LogMsg('s', 'Checking patient sensitive at remote site [' + RemoteBroker.Server + ', ' + inttostr(RemoteBroker.ListenerPort) + '].');
  MagLogger.LogMsg('s', 'Checking patient sensitive at remote site [' + RemoteBroker.Server + ', ' +
    Inttostr(RemoteBroker.ListenerPort) + '].'); {JK 10/6/2009 - Maggmsgu refactoring}
  Msg := Tstringlist.Create();

  RemoteBroker.PARAM[0].Value := PatientDFN;
  RemoteBroker.PARAM[0].PTYPE := LITERAL;
  RemoteBroker.REMOTEPROCEDURE := 'DG SENSITIVE RECORD ACCESS';
  {
             DG SENSITIVE RECORD ACCESS
             Output value line 1 of RESULT will be made less granular
             -1 = RPC/API failed
             0 = No display or action required
             1 = Display warning message
             2 = Display warning message - require OK to continue
             3 = Display warning message - do not continue
             If the output value is 1 (display warning message) entry in DG SECURITY LOG file is automatically made; GUI application does not need to take action to log access

             DG SENSITIVITY RECORD BULLETIN
             Input parameter ACTION (send bulletin, set log, or both) will be made optional with 'both' being the default value
             Input parameter DG1 (inpatient/outpatient status) will be removed
  }
  Try
    RemoteBroker.LstCALL(Msg);
    If Msg.Count = 0 Then
    Begin
      SensitveCode := -1;
      Msg[0] := 'The Attempt to determine Patient sensitivity Failed. Check VistA Error Log.';
      Exit;
    End;

    SensitveCode := Strtoint(Msg[0]);
    Msg.Delete(0);
  Except
    On e: Exception Do
    Begin
      SensitveCode := -1;
      Msg[0] := 'The Attempt to determine Patient sensitivity Failed. Check VistA Error Log.';
    End;
  End;

End;

Procedure TMagRemoteBroker.LogRestrictedAccess();
Begin
//  MaggMsgf.magmsg('s', 'Logging access to sensitive patient at remote site [' + RemoteBroker.Server + ', ' + inttostr(RemoteBroker.ListenerPort) + '].');
  //LogMsg('s', 'Logging access to sensitive patient at remote site [' + RemoteBroker.Server + ', ' + inttostr(RemoteBroker.ListenerPort) + '].');
  MagLogger.LogMsg('s', 'Logging access to sensitive patient at remote site [' + RemoteBroker.Server + ', ' +
    Inttostr(RemoteBroker.ListenerPort) + '].'); {JK 10/6/2009 - Maggmsgu refactoring}
  RemoteBroker.PARAM[0].Value := PatientDFN;
  RemoteBroker.PARAM[0].PTYPE := LITERAL;
  RemoteBroker.REMOTEPROCEDURE := 'DG SENSITIVE RECORD BULLETIN';
  RemoteBroker.STRCALL;
End;

{JK 10/5/2009 - Maggmsgu refactoring - remove old method}
//procedure TMagRemoteBroker.setLogEvent(LogEvent : TMagLogEvent);
//begin
//  FOnLogEvent := LogEvent;
//end;

{JK 10/5/2009 - Maggmsgu refactoring - remove old method}
//function TMagRemoteBroker.getLogEvent() : TMagLogEvent;
//begin
//  result := FOnLogEvent;
//end;

Function TMagRemoteBroker.GetRemoteUserDUZ(): String;
Begin
  Result := RemoteDUZ;
End;

Function TMagRemoteBroker.GetPatientStudies(Pkg, Cls, Types, Event, Spc,
  FrDate, ToDate, Origin: String; Var Results: TStrings; Var Partial_Returned: Boolean; Var Partial_Msg: String): TMagPatientStudyResponse;  {/ P117 NCAT - JK 11/30/2010 /}
Begin
  If Results = Nil Then
    Results := Tstringlist.Create();
  With RemoteBroker Do
  Begin
    PARAM[0].Value := PatientDFN; // RemoteDFN;
    PARAM[0].PTYPE := LITERAL;
    PARAM[1].Value := Pkg;
    PARAM[1].PTYPE := LITERAL;
    PARAM[2].Value := Cls;
    PARAM[2].PTYPE := LITERAL;
    PARAM[3].Value := Types;
    PARAM[3].PTYPE := LITERAL;
    PARAM[4].Value := Event;
    PARAM[4].PTYPE := LITERAL;
    PARAM[5].Value := Spc;
    PARAM[5].PTYPE := LITERAL;
    PARAM[6].Value := FrDate;
    PARAM[6].PTYPE := LITERAL;
    PARAM[7].Value := ToDate;
    PARAM[7].PTYPE := LITERAL;
    PARAM[8].Value := Origin;
    PARAM[8].PTYPE := LITERAL;
    RemoteBroker.REMOTEPROCEDURE := 'MAG4 PAT GET IMAGES';
  End;
  Try
    RemoteBroker.LstCALL(Results);
    Result := MagStudyResponseOk;
  Except
    On e: Exception Do
    Begin
      Result := MagStudyResponseException;
      //LogMsg('s','Exception Getting patient studies from site [' + FSite.SiteNumber + '], ' + E.Message, MagLogError);
      MagLogger.LogMsg('s', 'Exception Getting patient studies from site [' + FSite.SiteNumber + '], ' + e.Message, MagLogERROR); {JK 10/6/2009 - Maggmsgu refactoring}
      Results.Add('0^ERROR Accessing Patient Image list.');
      Results.Add('0^' + MagPiece(e.Message, #$A, 2));
    End;
  End;

End;

Function TMagRemoteBroker.GetServerDescription(): String;
Begin
  Result := '[' + ServerName + ', ' + Inttostr(ServerPort) + ']';
End;

Procedure TMagRemoteBroker.GetImageGlobalLookup(Ien: String; Var Rlist: TStrings);
Begin
  If Rlist = Nil Then
    Rlist := Tstringlist.Create();
  RemoteBroker.REMOTEPROCEDURE := 'MAGG SYS GLOBAL NODE';
  RemoteBroker.PARAM[0].Value := Ien;
  RemoteBroker.PARAM[0].PTYPE := LITERAL;
  RemoteBroker.LstCALL(Rlist);
End;

Procedure TMagRemoteBroker.GetMagDevFields(Ien, Flags: String; Var Output: Tstringlist);
Begin
  If Output = Nil Then
    Output := Tstringlist.Create();
  RemoteBroker.REMOTEPROCEDURE := 'MAGG DEV FIELD VALUES';
  RemoteBroker.PARAM[0].Value := Ien;
  RemoteBroker.PARAM[0].PTYPE := LITERAL;
  RemoteBroker.PARAM[1].Value := Uppercase(Flags);
  RemoteBroker.PARAM[1].PTYPE := LITERAL;
  RemoteBroker.LstCALL(Output);
End;

Procedure TMagRemoteBroker.LogCopyAccess(IObj: TImageData; Msg: String;  EventType: TMagImageAccessEventType);
Begin
  RemoteBroker.PARAM[0].PTYPE := LITERAL;
  RemoteBroker.PARAM[0].Value := Msg;
  RemoteBroker.REMOTEPROCEDURE := 'MAGGACTION LOG';
  {/p117 gek.  add the call to log the action}
  Try
    RemoteBroker.STRCALL;
  Except
    On e: Exception Do
    Begin
      MagLogger.LogMsg('s', 'Error logging action, ' + e.Message, MagLogERROR);
    End;
  End;
End;

Procedure TMagRemoteBroker.GetImageInformation(IObj: TImageData; Var Output: TStrings);
Begin
  If Output = Nil Then
    Output := Tstringlist.Create();
  RemoteBroker.REMOTEPROCEDURE := 'MAG4 GET IMAGE INFO';
  RemoteBroker.PARAM[0].PTYPE := LITERAL;
  RemoteBroker.PARAM[0].Value := IObj.Mag0;
  RemoteBroker.LstCALL(Output);

End;

Function TMagRemoteBroker.Getreport(IObj: TImageData): TStrings;
Begin
  RemoteBroker.PARAM[0].Value := IObj.Mag0 + '^';
  RemoteBroker.PARAM[0].PTYPE := LITERAL;
  RemoteBroker.PARAM[1].Value := Magbooltostrint(False);
  RemoteBroker.PARAM[1].PTYPE := LITERAL;
  RemoteBroker.REMOTEPROCEDURE := 'MAGGRPT';
  RemoteBroker.Call;
  Result := RemoteBroker.Results;
End;

Procedure TMagRemoteBroker.LogOfflineImageAccess(IObj: TImageData);
Begin
  RemoteBroker.REMOTEPROCEDURE := 'MAGG OFFLINE IMAGE ACCESSED';
  RemoteBroker.PARAM[0].PTYPE := LITERAL;
  RemoteBroker.PARAM[0].Value := IObj.FFile;
  RemoteBroker.PARAM[1].PTYPE := LITERAL;
  RemoteBroker.PARAM[1].Value := IObj.Mag0;
  RemoteBroker.Call;
End;

Procedure TMagRemoteBroker.LogAction(Msg: String);
Var
  MsgType: String;
Begin
  // JMW 6/19/2009 P93T8 - fixing bug where the image log access
  // events were using the patient DFN from the local site instead of
  // the remote site. Only modifying the second piece if the first piece
  // is IMG
  MsgType := MagPiece(Msg, '^', 1);
  If MsgType = 'IMG' Then
    Msg := MagSetPiece(Msg, '^', 2, GetRemotePatientDFN());

  RemoteBroker.PARAM[0].Value := Msg;
  RemoteBroker.PARAM[0].PTYPE := LITERAL;
  RemoteBroker.REMOTEPROCEDURE := 'MAG3 LOGACTION';
  RemoteBroker.Call;
End;

Function TMagRemoteBroker.QueImage(ImgType: String; IObj: TImageData): TStrings;
Begin
  RemoteBroker.PARAM[0].Value := ImgType;
  RemoteBroker.PARAM[0].PTYPE := LITERAL;
  RemoteBroker.PARAM[1].Value := IObj.Mag0;
  RemoteBroker.PARAM[1].PTYPE := LITERAL;
  RemoteBroker.REMOTEPROCEDURE := 'MAGG QUE IMAGE';
  RemoteBroker.Call;
  Result := RemoteBroker.Results;
End;

Function TMagRemoteBroker.QueImageGroup(Images: String; IObj: TImageData): String;
Begin
  RemoteBroker.PARAM[0].Value := Images;
  RemoteBroker.PARAM[0].PTYPE := LITERAL;
  RemoteBroker.PARAM[1].Value := IObj.Mag0;
  RemoteBroker.PARAM[1].PTYPE := LITERAL;
  RemoteBroker.REMOTEPROCEDURE := 'MAGG QUE IMAGE GROUP';
  Result := RemoteBroker.STRCALL
End;

Procedure TMagRemoteBroker.GetImageGroup(IObj: TImageData; NoQAcheck: Boolean; Output: TStrings);
Begin
  RemoteBroker.PARAM[0].Value := IObj.Mag0;
  RemoteBroker.PARAM[0].PTYPE := LITERAL;
  RemoteBroker.PARAM[1].Value := Magbooltostrint(NoQAcheck);
  RemoteBroker.PARAM[1].PTYPE := LITERAL;
  RemoteBroker.REMOTEPROCEDURE := 'MAGG GROUP IMAGES'; //MAGOGLU';
  RemoteBroker.LstCALL(Output);
End;

Function TMagRemoteBroker.IsBrokerLateCountUpdate(): Boolean;
Begin
  Result := False;
End;

Function TMagRemoteBroker.GetRemoteBrokerType(): TMagRemoteBrokerType;
Begin
  Result := MagRemoteRPCBroker;
End;

Function TMagRemoteBroker.GetSite(): TVistaSite;
Begin
  Result := FSite;
End;

Procedure TMagRemoteBroker.KeepBrokerAlive(Enabled: Boolean);
Begin
  FKeepBrokerAlive := Enabled;
  If FKeepBrokerAlive Then
  Begin
    Try
      FKeepAliveThread := TMagKeepAliveThread.Create(True);
//    FKeepAliveThread.OnLogEvent := FOnLogEvent;  {JK 10/5/2009 - Maggmsgu refactoring}
      FKeepAliveThread.Broker := RemoteBroker;
      FKeepAliveThread.Resume();
    Except
      On e: Exception Do
      Begin
        //LogMsg('s','Exception creating keep alive thread in MagRemoteBroker, [' + e.Message + ']');
        MagLogger.LogMsg('s', 'Exception creating keep alive thread in MagRemoteBroker, [' + e.Message + ']'); {JK 10/6/2009 - Maggmsgu refactoring}
      End;
    End;
  End
  Else
  Begin
    If FKeepAliveThread <> Nil Then
    Begin
      Try
        FKeepAliveThread.Terminate;
      Except
        On e: Exception Do
        Begin
          //LogMsg('s','Exception terminating keep alive thread in MagRemoteBroker, [' + e.Message + ']');
          MagLogger.LogMsg('s', 'Exception terminating keep alive thread in MagRemoteBroker, [' + e.Message + ']'); {JK 10/6/2009 - Maggmsgu refactoring}
        End;
      End;
    End;
  End;
End;

Procedure TMagRemoteBroker.RPMagTeleReaderUnreadlistGet(Var t: TStrings;
  AcquisitionPrimaryDivision, Sitecode, SpecialtyCode, ProcedureStrings,
  LastUpdate, UserDUZ, LocalSiteCode, SiteTimeOut, StatusOptions: String);
Begin
  RemoteBroker.REMOTEPROCEDURE := 'MAG DICOM CON UNREADLIST GET';
  RemoteBroker.PARAM[0].PTYPE := LITERAL;
  RemoteBroker.PARAM[0].Value := Sitecode;
  RemoteBroker.PARAM[1].PTYPE := LITERAL;
  RemoteBroker.PARAM[1].Value := SpecialtyCode;
  RemoteBroker.PARAM[2].PTYPE := LITERAL;
  RemoteBroker.PARAM[2].Value := ProcedureStrings;
  RemoteBroker.PARAM[3].PTYPE := LITERAL;
  RemoteBroker.PARAM[3].Value := LastUpdate;
  // New method to only show work items the user can do something with
  RemoteBroker.PARAM[4].PTYPE := LITERAL;
  RemoteBroker.PARAM[4].Value := UserDUZ;
  RemoteBroker.PARAM[5].PTYPE := LITERAL;
  RemoteBroker.PARAM[5].Value := LocalSiteCode;
  // Timeout stuff, to remove old locked items that have been locked for too long
  RemoteBroker.PARAM[6].PTYPE := LITERAL;
  RemoteBroker.PARAM[6].Value := SiteTimeOut;
  // status options
  RemoteBroker.PARAM[7].PTYPE := LITERAL;
  RemoteBroker.PARAM[7].Value := StatusOptions;
  RemoteBroker.LstCALL(t);
End;

Procedure TMagRemoteBroker.RPMagTeleReaderUnreadlistLock(Var Xmsg: String;
  AcquisitionPrimaryDivision, AcquisitionSiteCode, ItemID, LockUnlockValue,
  UserFullName, UserInitials, LocalDUZ, LocalSiteCode: String);
Begin

  RemoteBroker.REMOTEPROCEDURE := 'MAG DICOM CON UNREADLIST LOCK';
  RemoteBroker.PARAM[0].Value := ItemID;
  RemoteBroker.PARAM[0].PTYPE := LITERAL;

  RemoteBroker.PARAM[1].Value := LockUnlockValue;
  RemoteBroker.PARAM[1].PTYPE := LITERAL;

  RemoteBroker.PARAM[2].Value := UserFullName;
  RemoteBroker.PARAM[2].PTYPE := LITERAL;

  RemoteBroker.PARAM[3].Value := UserInitials;
  RemoteBroker.PARAM[3].PTYPE := LITERAL;

  RemoteBroker.PARAM[4].Value := RemoteDUZ;
  RemoteBroker.PARAM[4].PTYPE := LITERAL;

  RemoteBroker.PARAM[5].Value := LocalDUZ;
  RemoteBroker.PARAM[5].PTYPE := LITERAL;

  RemoteBroker.PARAM[6].Value := LocalSiteCode;
  RemoteBroker.PARAM[6].PTYPE := LITERAL;

  Xmsg := RemoteBroker.STRCALL;

End;

Function TMagRemoteBroker.shouldUseBSE(): Boolean;
Begin
  Result := False;
  If GSess.SecurityToken <> '' Then
    Result := True;
End;

Function TMagRemoteBroker.BSEConnect(): Boolean;
Var
  bseAttemptCount: Integer;
  tryAgain: Boolean;
Begin
  If RemoteBroker <> Nil Then
    RemoteBroker.Free;

  RemoteBroker := TRPCBroker.Create(Nil);
  RemoteBroker.Server := ServerName;
  RemoteBroker.ListenerPort := ServerPort;

  RemoteBroker.ClearParameters := True;
  RemoteBroker.ClearResults := True;

  bseAttemptCount := 0;
  tryAgain := True;
  Result := False;
  While tryAgain Do
  Begin
    Try
      bseAttemptCount := bseAttemptCount + 1;
      //LogMsg('s', 'Attempting BSE connect to remote site ' + FSite.SiteNumber + ', attempt number ' + inttostr(bseAttemptCount), MagLogInfo);
      MagLogger.LogMsg('s', 'Attempting BSE connect to remote site ' + FSite.SiteNumber + ', attempt number ' +
        Inttostr(bseAttemptCount), MagLogINFO); {JK 10/6/2009 - Maggmsgu refactoring}
      RemoteBroker.SecurityPhrase := getBSEApplicationName() + '^' +
        gsess.SecurityToken + '^' + PrimarySiteStationNumber + '^' +
        Inttostr(FLocalBrokerPort);

      RemoteBroker.Connected := True;

      If RemoteBroker.Connected Then
        RemoteBroker.CreateContext('MAG WINDOWS');

      RemoteDUZ := RemoteBroker.User.Duz;

      Result := RemoteBroker.Connected;
      Exit;

    Except
      On e: Exception Do
      Begin
        tryAgain := False;
        //LogMsg('s', 'Error during BSE connect, ' + e.Message, MagLogERROR);
        MagLogger.LogMsg('s', 'Error during BSE connect, ' + e.Message, MagLogERROR); {JK 10/6/2009 - Maggmsgu refactoring}
        If (e.Message = 'BSE ERROR - BSE TOKEN EXPIRED') Then
        Begin
          //LogMsg('s', 'Error was BSE TOKEN EXPIRED, will attempt to get a new token', MagLogInfo);
          MagLogger.LogMsg('s', 'Error was BSE TOKEN EXPIRED, will attempt to get a new token', MagLogINFO); {JK 10/6/2009 - Maggmsgu refactoring}
          If bseAttemptCount < 3 Then
          Begin
            //LogMsg('s', 'Current BSE login attempt is ' + inttostr(bseAttemptCount) + ', try to get new token', MagLogInfo);
            MagLogger.LogMsg('s', 'Current BSE login attempt is ' + Inttostr(bseAttemptCount) + ', try to get new token', MagLogINFO); {JK 10/6/2009 - Maggmsgu refactoring}
            If Assigned(FSecurityTokenNeeded) Then
            Begin
              GSess.SecurityToken := FSecurityTokenNeeded;
              //LogMsg('s', 'Received new token ' + GSess.SecurityToken, MagLogInfo);
              MagLogger.LogMsg('s', 'Received new token ' + GSess.SecurityToken, MagLogINFO); {JK 10/6/2009 - Maggmsgu refactoring}
              tryAgain := True;
            End
            Else
            Begin
              //LogMsg('s', 'FSecurityTokenNeeded not assigned, cannot get new token', MagLogInfo);
              MagLogger.LogMsg('s', 'FSecurityTokenNeeded not assigned, cannot get new token', MagLogINFO); {JK 10/6/2009 - Maggmsgu refactoring}
            End;
          End;
        End;
        If Not tryAgain Then
        Begin
          //LogMsg('s', 'Try again is false, cannot connect with BSE', MagLogInfo);
          MagLogger.LogMsg('s', 'Try again is false, cannot connect with BSE', MagLogINFO); {JK 10/6/2009 - Maggmsgu refactoring}
          Result := False;
          RemoteBroker.Destroy;
          RemoteBroker := Nil;
        End;
      End;
    End;
  End; // end while
End;

Function TMagRemoteBroker.CAPRIConnect(UserSSN, UserFullName, UserLocalDUZ: String): Boolean;
Var
  AlreadyExists: Boolean;
  RemoteMAGWINDOWS: String;
  DDRFilerResults: Tstringlist;
Begin
  //LogMsg('s', 'Not using BSE for connection to remote site ' + FSite.SiteNumber);
  MagLogger.LogMsg('s', 'Initiating CAPRI login to remote site ' + FSite.SiteNumber); {JK 10/6/2009 - Maggmsgu refactoring}
  If RemoteBroker <> Nil Then
    RemoteBroker.Free;

  RemoteBroker := TRPCBroker.Create(Nil);
  RemoteBroker.Server := ServerName;
  RemoteBroker.ListenerPort := ServerPort;

  RemoteBroker.ClearParameters := True;
  RemoteBroker.ClearResults := True;

  RemoteBroker.KernelLogIn := False;
  RemoteBroker.LogIn.Mode := LmNTToken;
  RemoteBroker.REMOTEPROCEDURE := 'XUS SIGNON SETUP';
  RemoteBroker.PARAM[0].Value := '-31^DVBA_^' + UserSSN + '^' + UserFullName + '^' + GSess.Wrksinst.Name + '^' + PrimarySiteStationNumber + '^' + UserLocalDUZ + '^No Phone';
  RemoteBroker.PARAM[0].PTYPE := LITERAL;
  Try
    RemoteBroker.Call;
  Except
    On e: Exception Do
    Begin
          //LogMsg('s', 'Error connecting to remote Broker [' + ServerName + ', ' + inttostr(Serverport) + '] Error [' + e.Message + '] ' + formatdatetime('mm/dd/yy@hh:nn:ss.zzz', now), MagLogError);
      MagLogger.LogMsg('s', 'Error connecting to remote Broker [' + ServerName + ', ' +
        Inttostr(ServerPort) + '] Error [' + e.Message + '] ' +
        Formatdatetime('mm/dd/yy@hh:nn:ss.zzz', Now), MagLogERROR); {JK 10/6/2009 - Maggmsgu refactoring}
      RemoteBroker.Destroy; // is this bad?????
      RemoteBroker := Nil;
      Result := False;
      Exit;
    End;
  End;

  AlreadyExists := False; // needed to see if we need to assign MAG WINDOWS or if it already exists for this user

  Try
    If RemoteBroker.CreateContext('MAG WINDOWS') Then
    Begin
      AlreadyExists := True;
    End
    Else
    Begin
        //LogMsg('s', 'User does not have MAG WINDOWS context, will attempt to assign it on Broker [' + ServerName + ', ' + inttostr(ServerPort) + '] ' + formatdatetime('mm/dd/yy@hh:nn:ss.zzz', now));
      MagLogger.LogMsg('s', 'User does not have MAG WINDOWS context, will attempt to assign it on Broker [' + ServerName + ', ' +
        Inttostr(ServerPort) + '] ' +
        Formatdatetime('mm/dd/yy@hh:nn:ss.zzz', Now)); {JK 10/6/2009 - Maggmsgu refactoring}
    End
  Except
    On e: Exception Do
        //LogMsg('s', 'User does not have MAG WINDOWS context, will attempt to assign it on Broker [' + ServerName + ', ' + inttostr(ServerPort) + '] ' + formatdatetime('mm/dd/yy@hh:nn:ss.zzz', now));//Showmessage(E.Message);
      MagLogger.LogMsg('s', 'User does not have MAG WINDOWS context, will attempt to assign it on Broker [' + ServerName + ', ' +
        Inttostr(ServerPort) + '] ' +
        Formatdatetime('mm/dd/yy@hh:nn:ss.zzz', Now)); //Showmessage(E.Message); {JK 10/6/2009 - Maggmsgu refactoring}
  End;
  If Not AlreadyExists Then // RemoteBrokers[BrokerCount].CreateContext('MAG WINDOWS') then
  Begin
    Try
      If Not RemoteBroker.CreateContext('DVBA CAPRI GUI') Then
      Begin
          //LogMsg('s', 'Could not assign DVBA CAPRI GUI Context, unable to continue on Broker [' + ServerName + ', ' + inttostr(ServerPort) + '] ' + formatdatetime('mm/dd/yy@hh:nn:ss.zzz', now), MagLogError);
        MagLogger.LogMsg('s', 'Could not assign DVBA CAPRI GUI Context, unable to continue on Broker [' + ServerName + ', ' +
          Inttostr(ServerPort) + '] ' +
          Formatdatetime('mm/dd/yy@hh:nn:ss.zzz', Now), MagLogERROR); {JK 10/6/2009 - Maggmsgu refactoring}
        Result := False;
        Exit;
      End;
    Except
      On e: Exception Do
      Begin
          //LogMsg('s', 'Could not assign DVBA CAPRI GUI Context, unable to continue on Broker [' + ServerName + ', ' + inttostr(ServerPort) + '] Error=[' + e.message + '] ' + formatdatetime('mm/dd/yy@hh:nn:ss.zzz', now), MagLogError);
        MagLogger.LogMsg('s', 'Could not assign DVBA CAPRI GUI Context, unable to continue on Broker [' + ServerName + ', ' +
          Inttostr(ServerPort) + '] Error=[' + e.Message + '] ' +
          Formatdatetime('mm/dd/yy@hh:nn:ss.zzz', Now), MagLogERROR); {JK 10/6/2009 - Maggmsgu refactoring}
        Result := False;
        Exit;
      End;
    End;
      // get the remote users DUZ
    RemoteBroker.REMOTEPROCEDURE := 'XWB GET VARIABLE VALUE';
    RemoteBroker.PARAM[0].Value := '$O(^VA(200,"SSN","' + UserSSN + '",""))';
    RemoteBroker.PARAM[0].PTYPE := Reference;
    RemoteBroker.Call;
    If RemoteBroker.Results.Count <= 0 Then
    Begin
        //LogMsg('s', 'Could not retrieve user remote DUZ, unable to continue on Broker [' + ServerName + ', ' + inttostr(ServerPort) + ']. ' + formatdatetime('mm/dd/yy@hh:nn:ss.zzz', now), MagLogError);
      MagLogger.LogMsg('s', 'Could not retrieve user remote DUZ, unable to continue on Broker [' + ServerName + ', ' +
        Inttostr(ServerPort) + ']. ' +
        Formatdatetime('mm/dd/yy@hh:nn:ss.zzz', Now), MagLogERROR); {JK 10/6/2009 - Maggmsgu refactoring}
      Result := False;
      Exit;
    End;
    RemoteDUZ := RemoteBroker.Results[0];

      // get the MAG WINDOWS context IEN
    RemoteBroker.REMOTEPROCEDURE := 'XWB GET VARIABLE VALUE';
    RemoteBroker.PARAM[0].Value := '$O(^DIC(19,"B","MAG WINDOWS",""))';
    RemoteBroker.PARAM[0].PTYPE := Reference;
    RemoteBroker.Call;
    If RemoteBroker.Results.Count <= 0 Then
    Begin
        //LogMsg('s', 'Could not retrieve MAG WINDOWS DUZ from remote site, unable to continue on Broker [' + ServerName + ', ' + inttostr(ServerPort) + ']. ' + formatdatetime('mm/dd/yy@hh:nn:ss.zzz', now), MagLogError);
      MagLogger.LogMsg('s', 'Could not retrieve MAG WINDOWS DUZ from remote site, unable to continue on Broker [' + ServerName + ', ' +
        Inttostr(ServerPort) + ']. ' +
        Formatdatetime('mm/dd/yy@hh:nn:ss.zzz', Now), MagLogERROR); {JK 10/6/2009 - Maggmsgu refactoring}
      Result := False;
      Exit;
    End;
    RemoteMAGWINDOWS := RemoteBroker.Results[0];

      // Assign MAG WINDOWS to remote server
    RemoteBroker.REMOTEPROCEDURE := 'DDR FILER';
    RemoteBroker.PARAM[0].Value := 'ADD';
    RemoteBroker.PARAM[0].PTYPE := LITERAL;
    RemoteBroker.PARAM[1].Mult['1'] := '200.03^.01^+1,' + RemoteDUZ + '^' + RemoteMAGWINDOWS;
    RemoteBroker.PARAM[1].PTYPE := List;
    RemoteBroker.Call;
    DDRFilerResults := Tstringlist.Create();
    DDRFilerResults.AddStrings(RemoteBroker.Results);
      // display the results of adding MAG WINDOWS to the user (p45t2)
      //LogMsg('s','Results of adding MAG WINDOWS to user:');
    MagLogger.LogMsg('s', 'Results of adding MAG WINDOWS to user:'); {JK 10/6/2009 - Maggmsgu refactoring}
      //LogMsg('s', DDRFilerResults);
    MagLogger.LogMsgs('s', DDRFilerResults); {JK 10/6/2009 - Maggmsgu refactoring}
    Application.Processmessages(); // p45t2 be sure everything is done

    AlreadyExists := False;

    If Not RemoteBroker.CreateContext('MAG WINDOWS') Then
    Begin
        //LogMsg('s', 'First attempt to assign MAG WINDOWS failed on server [' + ServerName + ', ' + inttostr(ServerPort) + '], will try again... ' + formatdatetime('mm/dd/yy@hh:nn:ss.zzz', now));
      MagLogger.LogMsg('s', 'First attempt to assign MAG WINDOWS failed on server [' + ServerName + ', ' +
        Inttostr(ServerPort) + '], will try again... ' +
        Formatdatetime('mm/dd/yy@hh:nn:ss.zzz', Now)); {JK 10/6/2009 - Maggmsgu refactoring}
    End
    Else
    Begin
      AlreadyExists := True;
    End;

      // this is stupid, but it might work...  (p45t2)
    If (Not AlreadyExists) Then
    Begin
      If Not RemoteBroker.CreateContext('MAG WINDOWS') Then
      Begin
          //LogMsg('s', 'Second attempt to assign MAG WINDOWS failed, unable to continue on Broker [' + ServerName + ', ' + inttostr(ServerPort) + '] ' + formatdatetime('mm/dd/yy@hh:nn:ss.zzz', now));
        MagLogger.LogMsg('s', 'Second attempt to assign MAG WINDOWS failed, unable to continue on Broker [' + ServerName + ', ' +
          Inttostr(ServerPort) + '] ' +
          Formatdatetime('mm/dd/yy@hh:nn:ss.zzz', Now)); {JK 10/6/2009 - Maggmsgu refactoring}
        RemoteBroker.Destroy; // is this bad?????
        Result := False;
        Exit;
      End;
    End;
  End;

    // if the user had an account at the remote site, we would not have retrieved
    // the remote DUZ, TeleReader needs the remote DUZ so get it.
    // JMW 2/2/2006 p46
  If RemoteDUZ = '' Then
  Begin
    RemoteBroker.REMOTEPROCEDURE := 'XWB GET VARIABLE VALUE';
    RemoteBroker.PARAM[0].Value := '$O(^VA(200,"SSN","' + UserSSN + '",""))';
    RemoteBroker.PARAM[0].PTYPE := Reference;
    Try
      RemoteBroker.Call;
      If RemoteBroker.Results.Count <= 0 Then
      Begin
          //LogMsg('s', 'Could not retrieve user remote DUZ, will continue on Broker [' + ServerName + ', ' + inttostr(ServerPort) + ']. ' + formatdatetime('mm/dd/yy@hh:nn:ss.zzz', now));
        MagLogger.LogMsg('s', 'Could not retrieve user remote DUZ, will continue on Broker [' + ServerName + ', ' +
          Inttostr(ServerPort) + ']. ' +
          Formatdatetime('mm/dd/yy@hh:nn:ss.zzz', Now)); {JK 10/6/2009 - Maggmsgu refactoring}
      End
      Else
        RemoteDUZ := RemoteBroker.Results[0];
    Except
      On e: Exception Do
      Begin
          //LogMsg('s', 'Exception retrieving user remote DUZ on Broker [' + ServerName + ', ' + inttostr(ServerPort) + '], Exception=[' + e.Message + ']');
        MagLogger.LogMsg('s', 'Exception retrieving user remote DUZ on Broker [' + ServerName + ', ' +
          Inttostr(ServerPort) + '], Exception=[' + e.Message + ']'); {JK 10/6/2009 - Maggmsgu refactoring}
      End;
    End;
  End;
  RemoteBroker.Connected := True;

    // log using CAPRI method
  LogCapriLogin();

  Result := True;
End;

{/
  P94 JMW 10/20/2009
  Log that the application has connected to a remote site using the
  CAPRI method and not the BSE method.
/}

Procedure TMagRemoteBroker.LogCapriLogin();
Begin
  If Assigned(FLogCapriConnect) Then
  Begin
    FLogCapriConnect(FRemoteApplicationType, FSite.SiteNumber);
  End;
End;

Function TMagRemoteBroker.getBSEApplicationName(): String;
Begin
  Result := 'VISTA IMAGING DISPLAY';
  If FRemoteApplicationType = magRemoteAppTeleReader Then
    Result := 'VISTA IMAGING TELEREADER';
End;

End.
