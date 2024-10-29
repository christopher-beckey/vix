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
  imaginterfaces,
  cMagUtils,
  IMagRemoteBrokerInterface,
  Trpcb,
  UMagClasses
  ;


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

    FSite: TVistaSite;

    FKeepBrokerAlive: Boolean;
    FKeepAliveThread: TMagKeepAliveThread;

    // necessary for BSE connections
    FLocalBrokerPort: Integer;

    FSecurityTokenNeeded: TMagSecurityTokenNeededEvent;

    FLogCapriConnect: TMagLogCapriConnectionEvent;
    FRemoteApplicationType: TMagRemoteLoginApplication;
    FPatch127Installed : Boolean;

    Function SetRemoteSiteParameters(): Boolean;

    Function shouldUseBSE(): Boolean;
    {new "secure" login method, used with patch 94 and beyond}
    Function BSEConnect(): Boolean;
    {Old RIV login method, deprecated after patch 94}
    Function CAPRIConnect(UserSSN, UserFullName, UserLocalDUZ: String): Boolean;

    Function getBSEApplicationName(): String;
    Function FindPatchInList(Rlist : TStrings; Version : String) : Boolean;
    Procedure SetInstalledImagingPatches;

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

    Function GetRemoteUserDUZ(): String;
 {7/12/12 gek Merge 130->129}
    {/ P117 NCAT - JK 11/30/2010 /}
    {/ P130 JK - 6/25/2012 added ShowDeletedImages: Boolean parameter /}

    Function GetPatientStudies(Pkg, Cls, Types, Event, Spc,
      FrDate, ToDate, Origin: String; ShowDeletedImages: Boolean;
      Var Results: TStrings; Var Partial_Returned: Boolean; Var Partial_Msg: String): TMagPatientStudyResponse;
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
      LastUpdate, UserDUZ, LocalSiteCode, SiteTimeOut, StatusOptions, LocalSiteStationNumber: String);  // P127T1 NST 04/06/2012 Send Reader Station Number (Reader Locking issue)
    Procedure RPMagTeleReaderUnreadlistLock(Var Xmsg: String;
      AcquisitionPrimaryDivision, AcquisitionSiteCode, ItemID, LockUnlockValue,
      UserFullName, UserInitials, LocalDUZ, LocalSiteCode, LocalSiteStationNumber: String);   // P127T1 NST 04/06/2012 Send Reader Station Number (Reader Locking issue)

    function IsAnnotsSupported: Boolean;   {/ P122 - JK 7/15/2011 /}
    function CanUserAnnotateRemotely: Boolean; {/ P122 - JK 9/27/2011 /}
    function HasAnnotateMasterKey: Boolean; {/ P122 - JK 9/27/2011 /}
    function GetUserAnnotDUZ: String;  {/ P122 - JK 10/4/2011 /}
    function SaveAnnots(IEN: String; AnnotSource: String; Version: String; AnnotXML: TStringList): Boolean; {/ P122 - JK 7/15/2011 /}
    function GetAnnots(IEN: String): TStrings;  {/ P122 - JK 7/21/2011 /}
    function GetAnnotDetails(IEN,LayerID: String): String;  {/ P122 - JK 7/21/2011 /}
    function GetInstalledMAGPatches( var RList: TStrings) : Boolean;  {/ P127 - NST - 03/20/2012 /}
    function IsPatch127Installed: Boolean; {/ P127 - NST - 03/20/2012 /}

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
  magAppMsg('s', 'Workstation Information sent to Remote VistA (' + Self.ServerName + ', ' + Inttostr(Self.ServerPort) + '):'); 
  //LogMsg('s', '  -> Result = ' + RemoteBroker.results[0]);
  magAppMsg('s', '  -> Result = ' + RemoteBroker.Results[0]); 
  //maggmsgf.magmsg('s', 'Workstation Information sent to Remote VistA (' + self.ServerName + ', ' + inttostr(self.ServerPort) + '):');
  //maggmsgf.magmsg('s', '  -> Result = ' + RemoteBroker.results[0]);
End;

Procedure TMagRemoteBroker.SetWorkstationID(WrksID: String);
Begin
  WorkstationID := WrksID;
End;

function TMagRemoteBroker.GetAnnotDetails(IEN, LayerID: String): String;
begin
  try
    RemoteBroker.PARAM[0].Value := IEN;
    RemoteBroker.PARAM[0].PTYPE := LITERAL;

    RemoteBroker.PARAM[1].Value := LayerID;
    RemoteBroker.PARAM[1].PTYPE := LITERAL;

    RemoteBroker.REMOTEPROCEDURE := 'MAG ANNOT GET IMAGE DETAIL';

    Result := RemoteBroker.StrCALL;
    
    magAppMsg('s', 'RemoteBroker.GetAnnotDetails for IEN = ' + IEN + ' LayerID = ' + LayerID + ' Details: ' + Result);

  except
    on E:Exception do
      magAppMsg('s', 'TMagRemoteBroker.GetAnnotDetails error = ' + E.Message);
  end;
end;

function TMagRemoteBroker.GetAnnots(IEN: String): TStrings;
var
  ReturnList: TStringList;
begin
  try
    ReturnList := TStringList.Create;
    Result := TStringList.Create;
    try

    RemoteBroker.PARAM[0].Value := IEN;
    RemoteBroker.PARAM[0].PTYPE := LITERAL;
    RemoteBroker.REMOTEPROCEDURE := 'MAG ANNOT GET IMAGE';

    RemoteBroker.LstCALL(ReturnList);
    Result.Assign(ReturnList);

    magAppMsg('s', 'RemoteBroker.GetAnnots:');
    magAppMsg('s', TStringList(Result));

  except
    on E:Exception do
      magAppMsg('s', 'TMagRemoteBroker.GetAnnots error = ' + E.Message);
  end;
  finally
    ReturnList.Free;
  end;
end;

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

function TMagRemoteBroker.GetUserAnnotDUZ: String;
begin
  Result := GetRemoteUserDUZ;
  magAppMsg('s', 'RemoteBroker: UserDUZ = ' + Result);
end;

function TMagRemoteBroker.HasAnnotateMasterKey: Boolean;
var
  t: TStringList;
  i: Integer;
begin
  Result := False;

  t := TStringList.Create;
  try
    RemoteBroker.REMOTEPROCEDURE := 'MAGGUSERKEYS';
    RemoteBroker.LstCALL(t);

    for i := 0 to t.Count - 1 do
      if t[i] = 'MAG ANNOTATE MGR' then
      begin
        Result := True;
        Break;
      end;

    magAppMsg('', 'RemoteBroker: ' + GetSite.SiteAbbr + ' keys:');
    magAppMsg('', t); {JK 10/5/2009 - Maggmsgu refactoring}
  finally
    t.Free;
  end;
end;

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

function TMagRemoteBroker.SaveAnnots(IEN, AnnotSource: String;
  Version: String; AnnotXML: TStringList): Boolean;
var
  i: Integer;
  FList: TStringList;
begin
  FList := TStringList.Create;
  try
    try

      RemoteBroker.PARAM[0].Value := IEN;
      RemoteBroker.PARAM[0].PTYPE := LITERAL;

      RemoteBroker.PARAM[1].Value := AnnotSource;
      RemoteBroker.PARAM[1].PTYPE := LITERAL;

      RemoteBroker.PARAM[2].Value := Version;
      RemoteBroker.PARAM[2].PTYPE := LITERAL;

      RemoteBroker.PARAM[3].PTYPE := List;
      for i := 0 To AnnotXML.Count - 1 do
        RemoteBroker.PARAM[3].Mult['' + IntToStr(i) + ''] := AnnotXML[i];

      RemoteBroker.PARAM[4].Value := '0'; //Deleted;
      RemoteBroker.PARAM[4].PTYPE := LITERAL;

      RemoteBroker.REMOTEPROCEDURE := 'MAG ANNOT STORE IMAGE DETAIL';

      RemoteBroker.LstCALL(FList);

      magAppMsg('s', 'RemoteBroker.SaveAnnots:');
      magAppMsg('s', AnnotXML);
    except
      on E:Exception do
      begin
        magAppMsg('s', 'TMagRemoteBroker.SaveAnnots error = ' + E.Message);
      end;
    end;
  finally
    FList.Free;
  end;
end;

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
          //LogMsg('s', 'Error Connecting to VISTA.' + #13 + #13 + E.MESSAGE + #13 + #13 + 'Shutdown will continue.', magmsgError);
          magAppMsg('s', 'Error Connecting to VISTA.' + #13 + #13 + e.Message + #13 + #13 + 'Shutdown will continue.', magmsgError); 
        //maggmsgf.magmsg('s', 'Error Connecting to VISTA.' + #13 + #13 + E.MESSAGE + #13 + #13 + 'Shutdown will continue.');
        On e: Exception Do
          //LogMsg('s', 'Error During Log Off : ' + e.message, magmsgError);
          magAppMsg('s', 'Error During Log Off : ' + e.Message, magmsgError); 
        //maggmsgf.magmsg('s', 'Error During Log Off : ' + e.message);
      Else
        //maggmsgf.magmsg('de', 'Unknown Error during Log Off');
        //LogMsg('de', 'Unknown Error during Log Off', magmsgError);
        magAppMsg('de', 'Unknown Error during Log Off', magmsgError); 
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
    magAppMsg('s', 'Server/Port empty values, unable to connect to remote site [' + ServerName + ', ' +
      Inttostr(ServerPort) + ']'); 
    Result := False;
    Exit;
  End;
  RemoteDUZ := '';

  If shouldUseBSE() Then
  Begin
    If Not BSEConnect() Then
    Begin
      magAppMsg('s', 'BSE Connect method failed, falling back to CAPRI method', magmsgError); 
      If Not CAPRIConnect(UserSSN, UserFullName, UserLocalDUZ) Then
      Begin
        magAppMsg('s', 'CAPRI Connect method failed', magmsgwarn); 
        Result := False;
        Exit;
      End;
    End;
  End
  Else
  Begin
    If Not CAPRIConnect(UserSSN, UserFullName, UserLocalDUZ) Then
    Begin
       //LogMsg('s', 'CAPRI Connect method failed', magmsgwarn);
      magAppMsg('s', 'CAPRI Connect method failed', magmsgwarn); 
      Result := False;
      Exit;
    End;
  End;

  //LogMsg('s', 'User Remote DUZ: ' + RemoteDUZ);
  magAppMsg('s', 'User Remote DUZ: ' + RemoteDUZ); 
  PatientStatus := STATUS_PATIENTACTIVE;
  ServerStatus := STATUS_CONNECTED;
  {/ P127 NST 04/04/2012
    Set Installed Patches
    e.g. FPatch127Installed /}
  SetInstalledImagingPatches;

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
        //LogMsg('', 'Error accessing Site Parameters for Remote Broker [' + RemoteBroker.Server + ',' + inttostr(RemoteBroker.ListenerPort) + ']', magmsgError);
      magAppMsg('', 'Error accessing Site Parameters for Remote Broker [' + RemoteBroker.Server + ',' +
        Inttostr(RemoteBroker.ListenerPort) + ']', magmsgError); 
      Result := Rstat;
      Exit;
    End;
    Rstat := True;

    SiteUsername := MagUtilities.MagPiece(Rlist[2], '^', 1);
    SitePassword := MagUtilities.MagPiece(Rlist[2], '^', 2);

    Consolidated := MagPiece(Rlist[4], '^', 5);
//    maggmsgf.magmsg('', 'Consolidated value [' + Consolidated + '] @ [' + RemoteBroker.Server + ',' + inttostr(RemoteBroker.ListenerPort)+ ']');
    //LogMsg('', 'Consolidated value [' + Consolidated + '] @ [' + RemoteBroker.Server + ',' + inttostr(RemoteBroker.ListenerPort)+ ']');
    magAppMsg('', 'Consolidated value [' + Consolidated + '] @ [' + RemoteBroker.Server + ',' +
      Inttostr(RemoteBroker.ListenerPort) + ']'); 

  Except
    On e: Exception Do
    Begin
//        maggmsgf.MagMsg('', 'Error accessing Site Parameters for Remote Broker [' + RemoteBroker.Server + ',' + inttostr(RemoteBroker.ListenerPort) + '], ' + e.Message);
        //LogMsg('', 'Error accessing Site Parameters for Remote Broker [' + RemoteBroker.Server + ',' + inttostr(RemoteBroker.ListenerPort) + '], ' + e.Message, magmsgError);
      magAppMsg('', 'Error accessing Site Parameters for Remote Broker [' + RemoteBroker.Server + ',' +
        Inttostr(RemoteBroker.ListenerPort) + '], ' + e.Message, magmsgError); 
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
      magAppMsg('', MagUtilities.MagPiece(Shares[0], '^', 2)); 
      Exit;
    End;
    If (Shares.Count = 0) Then
    Begin
//        maggmsgf.MagMsg('', 'Error accessing Network Locations');
        //LogMsg('', 'Error accessing Network Locations', magmsgError);
      magAppMsg('', 'Error accessing Network Locations', magmsgError); 
      Exit;
    End;
    Shares.Delete(0);

  Except
    On e: Exception Do
    Begin
//        maggmsgf.MagMsg('', 'Error accessing Network Locations. Error=[' + e.Message + ']');
        //LogMsg('', 'Error accessing Network Locations. Error=[' + e.Message + ']', magmsgError);
      magAppMsg('', 'Error accessing Network Locations. Error=[' + e.Message + ']', magmsgError); 
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
          //LogMsg('s', 'Error retrieving image count at remote site [' + RemoteBroker.Server + ', ' + inttostr(RemoteBroker.ListenerPort) + '], Error=[' + e.Message + '], ' +  formatdatetime('mm/dd/yy@hh:nn:ss.zzz', now), magmsgError);
        magAppMsg('s', 'Error retrieving image count at remote site [' + RemoteBroker.Server + ', ' +
          Inttostr(RemoteBroker.ListenerPort) + '], Error=[' + e.Message + '], ' +
          Formatdatetime('mm/dd/yy@hh:nn:ss.zzz', Now), magmsgError); 
        Count := 0;
        ImageCount := 0;
      End;
    End;
    Result := Count;
    ImageCount := Count;
//    maggmsgf.MagMsg('s', '[' + inttostr(count) + '] image(s) at remote site [' + RemoteBroker.Server + ', ' + inttostr(RemoteBroker.ListenerPort) + '] for selected patient.' + formatdatetime('mm/dd/yy@hh:nn:ss.zzz', now));
    //LogMsg('s', '[' + inttostr(count) + '] image(s) at remote site [' + RemoteBroker.Server + ', ' + inttostr(RemoteBroker.ListenerPort) + '] for selected patient.' + formatdatetime('mm/dd/yy@hh:nn:ss.zzz', now));
    magAppMsg('s', '[' + Inttostr(Count) + '] image(s) at remote site [' + RemoteBroker.Server + ', ' +
      Inttostr(RemoteBroker.ListenerPort) + '] for selected patient.' +
      Formatdatetime('mm/dd/yy@hh:nn:ss.zzz', Now)); 
  End
  Else
  Begin
    Result := 0;
    ImageCount := 0;
//    maggmsgf.MagMsg('s', '[0] image(s) at remote site [' + RemoteBroker.Server + ', ' + inttostr(RemoteBroker.ListenerPort) + '] for selected patient.' + formatdatetime('mm/dd/yy@hh:nn:ss.zzz', now));
    //LogMsg('s', '[0] image(s) at remote site [' + RemoteBroker.Server + ', ' + inttostr(RemoteBroker.ListenerPort) + '] for selected patient.' + formatdatetime('mm/dd/yy@hh:nn:ss.zzz', now));
    magAppMsg('s', '[0] image(s) at remote site [' + RemoteBroker.Server + ', ' +
      Inttostr(RemoteBroker.ListenerPort) + '] for selected patient.' +
      Formatdatetime('mm/dd/yy@hh:nn:ss.zzz', Now)); 
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
      //  magmsgError);
      magAppMsg('s', 'Unable to find patient ICN at remote site [' +
        RemoteBroker.Server + ', ' + Inttostr(RemoteBroker.ListenerPort) +
        '], setting broker inactive for this patient.' +
        Formatdatetime('mm/dd/yy@hh:nn:ss.zzz', Now),
        magmsgError); 
      PatientDFN := '';
      PatientStatus := STATUS_PATIENTINACTIVE;
      Result := False;
    End
    Else
    Begin
      Result := True;
      //LogMsg('s', 'Found DFN [' + fstring + '] for patient at remote site [' +
      //  self.getServerDescription  + '].',
      //  magmsginfo);
      magAppMsg('s', 'Found DFN [' + Fstring + '] for patient at remote site [' +
        Self.GetServerDescription + '].',
        magmsginfo); 
      PatientDFN := Fstring;
    End;
  Except
    On e: Exception Do
    Begin
      PatientDFN := '';
      //LogMsg('s', 'Error looking up patient ICN at remote site [' +
      //  RemoteBroker.Server + ', ' + inttostr(RemoteBroker.ListenerPort) +
      //  ']. Error is [' + e.Message + '] , setting broker inactive for this patient.' +
      //  formatdatetime('mm/dd/yy@hh:nn:ss.zzz', now), magmsgError);
      magAppMsg('s', 'Error looking up patient ICN at remote site [' +
        RemoteBroker.Server + ', ' + Inttostr(RemoteBroker.ListenerPort) +
        ']. Error is [' + e.Message + '] , setting broker inactive for this patient.' +
        Formatdatetime('mm/dd/yy@hh:nn:ss.zzz', Now), magmsgError); 
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
    LogMsg('s', 'Unable to set CAPRI context to retrieve DFN at remote site [' + RemoteBroker.Server + ', ' + inttostr(RemoteBroker.ListenerPort) + '], disconnecting broker.' + formatdatetime('mm/dd/yy@hh:nn:ss.zzz', now), magmsgError);
    if not RemoteBroker.CreateContext('MAG WINDOWS') then
    begin
//      maggmsgf.MagMsg('s', 'Unable to reset MAG WINDOWS context at remote site [' + RemoteBroker.Server + ', ' + inttostr(RemoteBroker.ListenerPort) + '], disconnecting broker.' + formatdatetime('mm/dd/yy@hh:nn:ss.zzz', now));
      LogMsg('s', 'Unable to reset MAG WINDOWS context at remote site [' + RemoteBroker.Server + ', ' + inttostr(RemoteBroker.ListenerPort) + '], disconnecting broker.' + formatdatetime('mm/dd/yy@hh:nn:ss.zzz', now), magmsgError);
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
      LogMsg('s', 'Unable to find patient ICN at remote site [' + RemoteBroker.Server + ', ' + inttostr(RemoteBroker.ListenerPort) + '], setting broker inactive for this patient.' + formatdatetime('mm/dd/yy@hh:nn:ss.zzz', now), magmsgError);
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
      LogMsg('s', 'Error looking up patient ICN at remote site [' + RemoteBroker.Server + ', ' + inttostr(RemoteBroker.ListenerPort) + ']. Error is [' + e.Message + '] , setting broker inactive for this patient.' + formatdatetime('mm/dd/yy@hh:nn:ss.zzz', now), magmsgError);
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
        //LogMsg('', 'Error Checking Version on Server at remote site [' + RemoteBroker.Server + ', ' + inttostr(RemoteBroker.ListenerPort) + '].', magmsgError);
      magAppMsg('', 'Error Checking Version on Server at remote site [' + RemoteBroker.Server + ', ' +
        Inttostr(RemoteBroker.ListenerPort) + '].', magmsgError); 
      Result := False;
      Exit;
    End;

  Except
    On e: Exception Do
    Begin
//        maggmsgf.magmsg('de', 'Exception Checking Version on Server at remote site [' + RemoteBroker.Server + ', ' + inttostr(RemoteBroker.ListenerPort) + ']. Error is [' + e.message + ']');
        //LogMsg('de', 'Exception Checking Version on Server at remote site [' + RemoteBroker.Server + ', ' + inttostr(RemoteBroker.ListenerPort) + ']. Error is [' + e.message + ']', magmsgError);
      magAppMsg('de', 'Exception Checking Version on Server at remote site [' + RemoteBroker.Server + ', ' +
        Inttostr(RemoteBroker.ListenerPort) + ']. Error is [' + e.Message + ']', magmsgError); 
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
          magAppMsg('s', 'First Attempt, Result of Version check = 0 at remote site [' + RemoteBroker.Server + ', ' +
            Inttostr(RemoteBroker.ListenerPort) + '].'); 
          Result := True;
          Exit;
        End;

      {         OK to continue {}
      1:
        Begin
//           MaggMsgf.magmsg('s', 'First Attempt, Result of Version check = 1 at remote site [' + RemoteBroker.Server + ', ' + inttostr(RemoteBroker.ListenerPort) + '].');
           //LogMsg('s', 'First Attempt, Result of Version check = 1 at remote site [' + RemoteBroker.Server + ', ' + inttostr(RemoteBroker.ListenerPort) + '].');
          magAppMsg('s', 'First Attempt, Result of Version check = 1 at remote site [' + RemoteBroker.Server + ', ' +
            Inttostr(RemoteBroker.ListenerPort) + '].'); 
          Result := True;
          Exit;
        End;

      {         Must Terminate {}
      2:
        Begin
//           MaggMsgf.magmsg('s', 'First Attempt, Invalid Server Version at remote site [' + RemoteBroker.Server + ', ' + inttostr(RemoteBroker.ListenerPort) + '].');
           //LogMsg('s', 'First Attempt, Invalid Server Version at remote site [' + RemoteBroker.Server + ', ' + inttostr(RemoteBroker.ListenerPort) + '].');
          magAppMsg('s', 'First Attempt, Invalid Server Version at remote site [' + RemoteBroker.Server + ', ' +
            Inttostr(RemoteBroker.ListenerPort) + '].'); 
          FirstAttempt := False;
        End;
      3:
        Begin
          FirstAttempt := True;
        End;
    Else
      //LogMsg('s', 'First Attempt, Undocumented Result of Version Check : ' + inttostr(rescode) + ' at remote site [' + RemoteBroker.Server + ', ' + inttostr(RemoteBroker.ListenerPort) + '], continuing.'); //MaggMsgf.magmsg('s', 'First Attempt, Undocumented Result of Version Check : ' + inttostr(rescode) + ' at remote site [' + RemoteBroker.Server + ', ' + inttostr(RemoteBroker.ListenerPort) + '], continuing.');
      magAppMsg('s', 'First Attempt, Undocumented Result of Version Check : ' +
        Inttostr(ResCode) + ' at remote site [' + RemoteBroker.Server + ', ' +
        Inttostr(RemoteBroker.ListenerPort) + '], continuing.');
          //MaggMsgf.magmsg('s', 'First Attempt, Undocumented Result of Version Check : ' + inttostr(rescode) + ' at remote site [' + RemoteBroker.Server + ', ' + inttostr(RemoteBroker.ListenerPort) + '], continuing.'); 
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
      magAppMsg('', 'Second Attempt, Error Checking Version on Server at remote site [' + RemoteBroker.Server + ', ' +
        Inttostr(RemoteBroker.ListenerPort) + '].'); 
      Result := False;
      Exit;
    End;

  Except
    On e: Exception Do
    Begin
//        maggmsgf.magmsg('de', 'Second Attempt, Exception Checking Version on Server at remote site [' + RemoteBroker.Server + ', ' + inttostr(RemoteBroker.ListenerPort) + ']. Error is [' + e.message + ']');
        //LogMsg('de', 'Second Attempt, Exception Checking Version on Server at remote site [' + RemoteBroker.Server + ', ' + inttostr(RemoteBroker.ListenerPort) + ']. Error is [' + e.message + ']');
      magAppMsg('de', 'Second Attempt, Exception Checking Version on Server at remote site [' + RemoteBroker.Server + ', ' +
        Inttostr(RemoteBroker.ListenerPort) + ']. Error is [' + e.Message + ']'); 
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
          magAppMsg('s', 'Second Attempt, Result of Version check = 0 at remote site [' + RemoteBroker.Server + ', ' +
            Inttostr(RemoteBroker.ListenerPort) + '].'); 
          Result := True;
          Exit;
        End;

      {         OK to continue {}
      1:
        Begin
//           MaggMsgf.magmsg('s', 'Second Attempt, Result of Version check = 1 at remote site [' + RemoteBroker.Server + ', ' + inttostr(RemoteBroker.ListenerPort) + '].');
           //LogMsg('s', 'Second Attempt, Result of Version check = 1 at remote site [' + RemoteBroker.Server + ', ' + inttostr(RemoteBroker.ListenerPort) + '].');
          magAppMsg('s', 'Second Attempt, Result of Version check = 1 at remote site [' + RemoteBroker.Server + ', ' +
            Inttostr(RemoteBroker.ListenerPort) + '].'); 
          Result := True;
          Exit;
        End;

      {         Must Terminate {}
      2:
        Begin
//           MaggMsgf.magmsg('s', 'Second Attempt, Invalid Server Version at remote site [' + RemoteBroker.Server + ', ' + inttostr(RemoteBroker.ListenerPort) + ']. Site Will not be used.');
           //LogMsg('s', 'Second Attempt, Invalid Server Version at remote site [' + RemoteBroker.Server + ', ' + inttostr(RemoteBroker.ListenerPort) + ']. Site Will not be used.');
          magAppMsg('s', 'Second Attempt, Invalid Server Version at remote site [' + RemoteBroker.Server + ', ' +
            Inttostr(RemoteBroker.ListenerPort) + ']. Site Will not be used.'); 
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
      magAppMsg('s', 'Second Attempt, Undocumented Result of Version Check : ' +
        Inttostr(ResCode) + ' at remote site [' + RemoteBroker.Server + ', ' +
        Inttostr(RemoteBroker.ListenerPort) + '], continuing.');
          //MaggMsgf.magmsg('s', 'Second Attempt, Undocumented Result of Version Check : ' + inttostr(rescode) + ' at remote site [' + RemoteBroker.Server + ', ' + inttostr(RemoteBroker.ListenerPort) + '], continuing.'); 
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
  magAppMsg('s', 'Checking patient sensitive at remote site [' + RemoteBroker.Server + ', ' +
    Inttostr(RemoteBroker.ListenerPort) + '].'); 
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
  magAppMsg('s', 'Logging access to sensitive patient at remote site [' + RemoteBroker.Server + ', ' +
    Inttostr(RemoteBroker.ListenerPort) + '].'); 
  RemoteBroker.PARAM[0].Value := PatientDFN;
  RemoteBroker.PARAM[0].PTYPE := LITERAL;
  RemoteBroker.REMOTEPROCEDURE := 'DG SENSITIVE RECORD BULLETIN';
  RemoteBroker.STRCALL;
End;


Function TMagRemoteBroker.GetRemoteUserDUZ(): String;
Begin
  Result := RemoteDUZ;
End;
 {7/12/12 gek Merge 130->129}
{/ P117 NCAT - JK 11/30/2010 /}
{/ P130 JK - 6/25/2012 added ShowDeletedImages: Boolean parameter /}

Function TMagRemoteBroker.GetPatientStudies(Pkg, Cls, Types, Event, Spc,
  FrDate, ToDate, Origin: String;
  ShowDeletedImages: Boolean; Var Results: TStrings; Var Partial_Returned: Boolean; Var Partial_Msg: String): TMagPatientStudyResponse;
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
      //LogMsg('s','Exception Getting patient studies from site [' + FSite.SiteNumber + '], ' + E.Message, magmsgError);
      magAppMsg('s', 'Exception Getting patient studies from site [' + FSite.SiteNumber + '], ' + e.Message, magmsgError); 
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
      magAppMsg('s', 'Error logging action, ' + e.Message, magmsgError);
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

{/ P122 - JK 10/10/2011 /}
function TMagRemoteBroker.IsAnnotsSupported: Boolean;
var
  RetArr: TStringList;
  Version: String;
  i: Integer;
begin
  Result := False;

  Version := '3.0P122';   {Patch 122 is the "annotations" patch}

  RetArr := TStringList.Create;
  try

    RemoteBroker.REMOTEPROCEDURE := 'MAGG INSTALL';

    try
      RemoteBroker.LSTCALL(RetArr);
      if RetArr.Count = 0 Then
      begin
        magAppMsg('', 'RemoteBroker Error Checking MAGG INSTALL on Server returns no installed patches'); {JK 10/5/2009 - Maggmsgu refactoring}
        Exit;
      end;

      for i := RetArr.Count - 1 downto 0 do
      begin
        if MagPiece(RetArr[i], '^', 1) = Version then
        begin
          Result := True;
          Break;
        end;
      end;

      if Result = True then
        magAppMsg('s', 'RemoteBroker: Annotations Are Supported at ' + GetSite.SiteAbbr)
      else
        magAppMsg('s', 'RemoteBroker: Annotations Are NOT Supported at ' + GetSite.SiteAbbr);
    except
      on E:Exception Do
        magAppMsg('de', 'RemoteBroker TMagRemoteBroker.IsAnnotsSupported Exception ' + e.Message); {JK 10/5/2009 - Maggmsgu refactoring}
    end;
  finally
    RetArr.Free;
  end;

end;

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
        magAppMsg('s', 'Exception creating keep alive thread in MagRemoteBroker, [' + e.Message + ']'); 
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
          magAppMsg('s', 'Exception terminating keep alive thread in MagRemoteBroker, [' + e.Message + ']'); 
        End;
      End;
    End;
  End;
End;
// P127T1 NST 04/06/2012 Send Reader Station Number (Reader Locking issue)

Procedure TMagRemoteBroker.RPMagTeleReaderUnreadlistGet(Var t: TStrings;
  AcquisitionPrimaryDivision, Sitecode, SpecialtyCode, ProcedureStrings,
  LastUpdate, UserDUZ, LocalSiteCode, SiteTimeOut, StatusOptions, LocalSiteStationNumber: String);
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
  // P127T1 NST 04/06/2012 Check for P127 installed and send Reader Station Number (Reader Locking issue) 
  if IsPatch127Installed then
  begin
    RemoteBroker.PARAM[8].PTYPE := LITERAL;
    RemoteBroker.PARAM[8].Value := LocalSiteStationNumber;
  end;
  try
  RemoteBroker.LstCALL(t);
  except on E:Exception do
      magAppMsg('s', 'TMagRemoteBroker.RPMagTeleReaderUnreadlistGet error = ' + E.Message);
  end;
End;
// P127T1 NST 04/06/2012 Send Reader Station Number (Reader Locking issue)

Procedure TMagRemoteBroker.RPMagTeleReaderUnreadlistLock(Var Xmsg: String;
  AcquisitionPrimaryDivision, AcquisitionSiteCode, ItemID, LockUnlockValue,
  UserFullName, UserInitials, LocalDUZ, LocalSiteCode, LocalSiteStationNumber: String);
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

  // P127T1 NST 04/06/2012 Check for patch 127 installed and send Reader Station Number
  if IsPatch127Installed then
  begin
    RemoteBroker.PARAM[7].PTYPE := LITERAL;
    RemoteBroker.PARAM[7].Value := LocalSiteStationNumber;
  end;
  try
    Xmsg := RemoteBroker.strCall;
  except on E:Exception do
      magAppMsg('s', 'TMagRemoteBroker.RPMagTeleReaderUnreadlistLock error = ' + E.Message);
  end;

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
      //LogMsg('s', 'Attempting BSE connect to remote site ' + FSite.SiteNumber + ', attempt number ' + inttostr(bseAttemptCount), magmsginfo);
      magAppMsg('s', 'Attempting BSE connect to remote site ' + FSite.SiteNumber + ', attempt number ' +
        Inttostr(bseAttemptCount), magmsginfo); 
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
        //LogMsg('s', 'Error during BSE connect, ' + e.Message, magmsgError);
        magAppMsg('s', 'Error during BSE connect, ' + e.Message, magmsgError); 
        If (e.Message = 'BSE ERROR - BSE TOKEN EXPIRED') Then
        Begin
          //LogMsg('s', 'Error was BSE TOKEN EXPIRED, will attempt to get a new token', magmsginfo);
          magAppMsg('s', 'Error was BSE TOKEN EXPIRED, will attempt to get a new token', magmsginfo); 
          If bseAttemptCount < 3 Then
          Begin
            //LogMsg('s', 'Current BSE login attempt is ' + inttostr(bseAttemptCount) + ', try to get new token', magmsginfo);
            magAppMsg('s', 'Current BSE login attempt is ' + Inttostr(bseAttemptCount) + ', try to get new token', magmsginfo); 
            If Assigned(FSecurityTokenNeeded) Then
            Begin
              GSess.SecurityToken := FSecurityTokenNeeded;
              //LogMsg('s', 'Received new token ' + GSess.SecurityToken, magmsginfo);
              magAppMsg('s', 'Received new token ' + GSess.SecurityToken, magmsginfo); 
              tryAgain := True;
            End
            Else
            Begin
              //LogMsg('s', 'FSecurityTokenNeeded not assigned, cannot get new token', magmsginfo);
              magAppMsg('s', 'FSecurityTokenNeeded not assigned, cannot get new token', magmsginfo); 
            End;
          End;
        End;
        If Not tryAgain Then
        Begin
          //LogMsg('s', 'Try again is false, cannot connect with BSE', magmsginfo);
          magAppMsg('s', 'Try again is false, cannot connect with BSE', magmsginfo); 
          Result := False;
          RemoteBroker.Destroy;
          RemoteBroker := Nil;
        End;
      End;
    End;
  End; // end while
End;

{/ P122 - JK 10/10/2011 - Check the site's kernel params to see if the user can annotate /}
function TMagRemoteBroker.CanUserAnnotateRemotely: Boolean;
var
  s: String;
begin
  try
    Result := False;
//    RemoteBroker.REMOTEPROCEDURE := 'MAG IMAGE ALLOW ANNOTATE';
    RemoteBroker.RemoteProcedure := 'MAG ANNOT IMAGE ALLOW';  //p122t11 dmmn 12/17/11 - rpc name got changed

    s := RemoteBroker.STRCALL;
    if Copy(s, 1, 1) = '0' then
    begin
      magAppMsg('s', 'TMagRemoteBroker.CanUserAnnotateRemotely Failed - Exiting.');
      Exit; //error occurred during call
    end;
    if Copy(s, 3, 1) = '1' then
      Result := True;

    if Result = True then
      magAppMsg('s', 'RemoteBroker: ' + RemoteBroker.User.Name + ' CAN annotate at ' + GetSite.SiteAbbr)
    else
      magAppMsg('s', 'RemoteBroker: ' + RemoteBroker.User.Name + ' CANNOT annotate at ' + GetSite.SiteAbbr)
  except
    on E:Exception do
      magAppMsg('s', 'TMagRemoteBroker.CanUserAnnotateRemotely Exception: Msg: ' + E.Message);
  end;
end;

Function TMagRemoteBroker.CAPRIConnect(UserSSN, UserFullName, UserLocalDUZ: String): Boolean;
Var
  AlreadyExists: Boolean;
  RemoteMAGWINDOWS: String;
  DDRFilerResults: Tstringlist;
Begin
  //LogMsg('s', 'Not using BSE for connection to remote site ' + FSite.SiteNumber);
  magAppMsg('s', 'Initiating CAPRI login to remote site ' + FSite.SiteNumber); 
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
          //LogMsg('s', 'Error connecting to remote Broker [' + ServerName + ', ' + inttostr(Serverport) + '] Error [' + e.Message + '] ' + formatdatetime('mm/dd/yy@hh:nn:ss.zzz', now), magmsgError);
      magAppMsg('s', 'Error connecting to remote Broker [' + ServerName + ', ' +
        Inttostr(ServerPort) + '] Error [' + e.Message + '] ' +
        Formatdatetime('mm/dd/yy@hh:nn:ss.zzz', Now), magmsgError); 
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
      magAppMsg('s', 'User does not have MAG WINDOWS context, will attempt to assign it on Broker [' + ServerName + ', ' +
        Inttostr(ServerPort) + '] ' +
        Formatdatetime('mm/dd/yy@hh:nn:ss.zzz', Now)); 
    End
  Except
    On e: Exception Do
        //LogMsg('s', 'User does not have MAG WINDOWS context, will attempt to assign it on Broker [' + ServerName + ', ' + inttostr(ServerPort) + '] ' + formatdatetime('mm/dd/yy@hh:nn:ss.zzz', now));//Showmessage(E.Message);
      magAppMsg('s', 'User does not have MAG WINDOWS context, will attempt to assign it on Broker [' + ServerName + ', ' +
        Inttostr(ServerPort) + '] ' +
        Formatdatetime('mm/dd/yy@hh:nn:ss.zzz', Now)); //Showmessage(E.Message); 
  End;
  If Not AlreadyExists Then // RemoteBrokers[BrokerCount].CreateContext('MAG WINDOWS') then
  Begin
    Try
      If Not RemoteBroker.CreateContext('DVBA CAPRI GUI') Then
      Begin
          //LogMsg('s', 'Could not assign DVBA CAPRI GUI Context, unable to continue on Broker [' + ServerName + ', ' + inttostr(ServerPort) + '] ' + formatdatetime('mm/dd/yy@hh:nn:ss.zzz', now), magmsgError);
        magAppMsg('s', 'Could not assign DVBA CAPRI GUI Context, unable to continue on Broker [' + ServerName + ', ' +
          Inttostr(ServerPort) + '] ' +
          Formatdatetime('mm/dd/yy@hh:nn:ss.zzz', Now), magmsgError); 
        Result := False;
        Exit;
      End;
    Except
      On e: Exception Do
      Begin
          //LogMsg('s', 'Could not assign DVBA CAPRI GUI Context, unable to continue on Broker [' + ServerName + ', ' + inttostr(ServerPort) + '] Error=[' + e.message + '] ' + formatdatetime('mm/dd/yy@hh:nn:ss.zzz', now), magmsgError);
        magAppMsg('s', 'Could not assign DVBA CAPRI GUI Context, unable to continue on Broker [' + ServerName + ', ' +
          Inttostr(ServerPort) + '] Error=[' + e.Message + '] ' +
          Formatdatetime('mm/dd/yy@hh:nn:ss.zzz', Now), magmsgError); 
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
        //LogMsg('s', 'Could not retrieve user remote DUZ, unable to continue on Broker [' + ServerName + ', ' + inttostr(ServerPort) + ']. ' + formatdatetime('mm/dd/yy@hh:nn:ss.zzz', now), magmsgError);
      magAppMsg('s', 'Could not retrieve user remote DUZ, unable to continue on Broker [' + ServerName + ', ' +
        Inttostr(ServerPort) + ']. ' +
        Formatdatetime('mm/dd/yy@hh:nn:ss.zzz', Now), magmsgError); 
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
        //LogMsg('s', 'Could not retrieve MAG WINDOWS DUZ from remote site, unable to continue on Broker [' + ServerName + ', ' + inttostr(ServerPort) + ']. ' + formatdatetime('mm/dd/yy@hh:nn:ss.zzz', now), magmsgError);
      magAppMsg('s', 'Could not retrieve MAG WINDOWS DUZ from remote site, unable to continue on Broker [' + ServerName + ', ' +
        Inttostr(ServerPort) + ']. ' +
        Formatdatetime('mm/dd/yy@hh:nn:ss.zzz', Now), magmsgError); 
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
    magAppMsg('s', 'Results of adding MAG WINDOWS to user:'); 
      //LogMsg('s', DDRFilerResults);
    magAppMsg('s', DDRFilerResults); 
    Application.Processmessages(); // p45t2 be sure everything is done

    AlreadyExists := False;

    If Not RemoteBroker.CreateContext('MAG WINDOWS') Then
    Begin
        //LogMsg('s', 'First attempt to assign MAG WINDOWS failed on server [' + ServerName + ', ' + inttostr(ServerPort) + '], will try again... ' + formatdatetime('mm/dd/yy@hh:nn:ss.zzz', now));
      magAppMsg('s', 'First attempt to assign MAG WINDOWS failed on server [' + ServerName + ', ' +
        Inttostr(ServerPort) + '], will try again... ' +
        Formatdatetime('mm/dd/yy@hh:nn:ss.zzz', Now)); 
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
        magAppMsg('s', 'Second attempt to assign MAG WINDOWS failed, unable to continue on Broker [' + ServerName + ', ' +
          Inttostr(ServerPort) + '] ' +
          Formatdatetime('mm/dd/yy@hh:nn:ss.zzz', Now)); 
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
        magAppMsg('s', 'Could not retrieve user remote DUZ, will continue on Broker [' + ServerName + ', ' +
          Inttostr(ServerPort) + ']. ' +
          Formatdatetime('mm/dd/yy@hh:nn:ss.zzz', Now)); 
      End
      Else
        RemoteDUZ := RemoteBroker.Results[0];
    Except
      On e: Exception Do
      Begin
          //LogMsg('s', 'Exception retrieving user remote DUZ on Broker [' + ServerName + ', ' + inttostr(ServerPort) + '], Exception=[' + e.Message + ']');
        magAppMsg('s', 'Exception retrieving user remote DUZ on Broker [' + ServerName + ', ' +
          Inttostr(ServerPort) + '], Exception=[' + e.Message + ']');
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

{/
  P127 NST 03/20/2012
  Get Imaging Installed Patches
/}
function TMagRemoteBroker.GetInstalledMAGPatches(var RList : TStrings) : Boolean;
var
  RetArr: TStringList;
  Version: String;
  i: Integer;
begin
  Result := False;

  If RList = Nil Then RList := Tstringlist.Create();

  RemoteBroker.REMOTEPROCEDURE := 'MAGG INSTALL';

  try
    RemoteBroker.lstCall(RList);
    if RList.Count = 0 Then
    begin
      magAppMsg('', 'RemoteBroker Error Checking MAGG INSTALL on Server returns no installed patches');
      Exit;
    end;

    Except
    On e: Exception Do
    Begin
      magAppMsg('s', 'Exception executing MAGG INSTALL', magmsgError);
    End;
  End;

  Result := True;

end;

{/
  P127 NST 03/20/2012
  Get if P127 is Installed
/}
function TMagRemoteBroker.IsPatch127Installed : Boolean;
begin
 Result := FPatch127Installed;
end;

function TMagRemoteBroker.FindPatchInList(Rlist : TStrings; Version : String) : Boolean;
var
  i : Integer;
begin
  Result := False;

  for i := Rlist.Count - 1 downto 0 do
  begin
    if MagPiece(Rlist[i], '^', 1) = Version then
    begin
      Result := True;
      Break;
    end;
  end;
end;

Procedure TMagRemoteBroker.SetInstalledImagingPatches;
var
  RList : TStrings;
Begin
  RList := TStringList.Create;
  if GetInstalledMAGPatches(RList) then
  begin
    FPatch127Installed := FindPatchInList(RList,'3.0P127');
  end
  else
  begin
    FPatch127Installed := False;
  end;

  RList.Free;
End;

End.
