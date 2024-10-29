{
  Package: MAG - VistA Imaging
  WARNING: Per VHA Directive 2004-038, this routine should not be modified.
  Date Created: January, 2007
  Site Name:  Washington OI Field Office, Silver Spring, MD
  Developer:  Julian Werfel
  Description:
    Remote Dummy Broker is a dummy place holder broker meant for connections to
    site the user can't actually obtain or don't really exist.  This is
    necessary because the broker manager must have an IMagRemoteBroker for
    each site in its list and we need a broker that won't attempt to connect
    and will never work.
    All calls to this broker will respond with either not connected or an
    empty result set

        ;; +--------------------------------------------------------------------+
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
        ;; +--------------------------------------------------------------------+
}
Unit cMagRemoteDummyBroker;

Interface

Uses
  Classes,
  //cMagLogManager,  {JK 10/5/2009 - Maggmsgu refactoring - deprecated unit}
  IMagRemoteBrokerInterface,
  UMagClasses
  ;

Type
  TMagRemoteDummyBroker = Class(TInterfacedObject, IMagRemoteBroker)
  Private
    FSite: TVistaSite;
    FServerStatus: Integer;
    FPatientStatus: Integer;
    FPatientICN: String;
    //FOnLogEvent : TMagLogEvent; {JK 10/5/2009 - Maggmsgu refactoring - remove old method}

    //procedure LogMsg(MsgType : String; Msg : String; Priority : TMagLogPriority = MagLogINFO);  {JK 10/5/2009 - Maggmsgu refactoring - remove old method}

  Public
    {Constructor to create each remote broker object }
    Constructor Create(Site: TVistaSite);

    Destructor Destroy; Override;

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

    Function GetPatientStudies(Pkg, Cls, Types, Event, Spc,
      FrDate, ToDate, Origin: String; Var Results: TStrings; Var Partial_Returned: Boolean; Var Partial_Msg: String): TMagPatientStudyResponse;  {/ P117 NCAT - JK 11/30/2010 /}
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

  {Describes the server, Server and port for a rpcBroker}
    Function GetServerDescription(): String;

  //procedure setLogEvent(LogEvent : TMagLogEvent); {JK 10/5/2009 - Maggmsgu refactoring - remove old method}
  //function getLogEvent() : TMagLogEvent;  {JK 10/5/2009 - Maggmsgu refactoring - remove old method}
    Function GetRemoteUserDUZ(): String;

    Function IsBrokerLateCountUpdate(): Boolean;

    Function GetRemoteBrokerType(): TMagRemoteBrokerType;

    Function GetSite(): TVistaSite;

    Procedure KeepBrokerAlive(Enabled: Boolean);

    Procedure RPMagTeleReaderUnreadlistGet(Var t: TStrings;
      AcquisitionPrimaryDivision, Sitecode, SpecialtyCode, ProcedureStrings,
      LastUpdate, UserDUZ, LocalSiteCode, SiteTimeOut, StatusOptions: String);

    Procedure RPMagTeleReaderUnreadlistLock(Var Xmsg: String;
      AcquisitionPrimaryDivision, AcquisitionSiteCode, ItemID, LockUnlockValue,
      UserFullName, UserInitials, LocalDUZ, LocalSiteCode: String);

  End;

Implementation

Constructor TMagRemoteDummyBroker.Create(Site: TVistaSite);
Begin
  FSite := Site;
End;

Destructor TMagRemoteDummyBroker.Destroy;
Begin
  Inherited;
End;

Function TMagRemoteDummyBroker.SetPatientDFN(PatientICN: String): Boolean;
Begin
  FPatientICN := PatientICN;
End;

Function TMagRemoteDummyBroker.CountImages(): Integer;
Begin
  Result := -1;
End;

Function TMagRemoteDummyBroker.Connect(UserFullName: String; UserLocalDUZ: String; UserSSN: String): Boolean;
Begin
  Result := False;
End;

Function TMagRemoteDummyBroker.GetServerName(): String;
Begin
  // is this really what we want to return here?
  Result := FSite.VistaServer;
End;

Function TMagRemoteDummyBroker.GetServerPort(): Integer;
Begin
  // is this really what we want to return here?
  Result := FSite.VistaPort; // FServerPort;
End;

Procedure TMagRemoteDummyBroker.ClearPatient();
Begin
  FPatientStatus := STATUS_PATIENTINACTIVE;
End;

Procedure TMagRemoteDummyBroker.Disconnect();
Begin
  // no connection to close
  FServerStatus := STATUS_DISCONNECTED;
  FPatientStatus := STATUS_PATIENTINACTIVE;
End;

Function TMagRemoteDummyBroker.GetServerStatus(): Integer;
Begin
  Result := FServerStatus;
End;

Function TMagRemoteDummyBroker.GetPatientStatus(): Integer;
Begin
  Result := FPatientStatus;
End;

Function TMagRemoteDummyBroker.GetRemotePatientDFN(): String;
Begin
  Result := FPatientICN;
  // hmmm, won't have the DFN, mock value? do we still want to display this, is this still needed?
End;

Procedure TMagRemoteDummyBroker.SetPatientActive();
Begin
  FPatientStatus := STATUS_PATIENTACTIVE;
End;

Procedure TMagRemoteDummyBroker.SetPatientInactive();
Begin
  FPatientStatus := STATUS_PATIENTINACTIVE;
End;

Procedure TMagRemoteDummyBroker.SetWorkstationID(WrksID: String);
Begin
  // not used?
End;

Function TMagRemoteDummyBroker.GetSiteUsername(): String;
Begin
  // not going to get username from site
  Result := '';
End;

Function TMagRemoteDummyBroker.GetSitePassword(): String;
Begin
  Result := '';
End;

Function TMagRemoteDummyBroker.GetSiteDescryptedPassword(): String;
Begin
  Result := '';
End;

Function TMagRemoteDummyBroker.GetSiteCode(): String;
Begin
  Result := FSite.SiteNumber;
End;

Function TMagRemoteDummyBroker.GetSiteName(): String;
Begin
  Result := FSite.SiteName;
End;

Procedure TMagRemoteDummyBroker.clearBrokerFields();
Begin
  // hmmm, not sure
End;

Procedure TMagRemoteDummyBroker.GetNetworkLocations(Var Shares: TStrings);
Begin
  // do nothing here
End;

Function TMagRemoteDummyBroker.CheckRemoteImagingVersion(): Boolean;
Begin
  Result := True; // not sure - do we want a real version check for ViX to ViX?
End;

Function TMagRemoteDummyBroker.GetImageCount(): Integer;
Begin
  Result := -1;
End;

Procedure TMagRemoteDummyBroker.CreateSession(AppPath, DispAppName, CapAppName, Compname, Location, LastUpdate: String; Startmode: Integer);
Begin
  // do nothing?
End;

Function TMagRemoteDummyBroker.ReOpenConnection(UserFullName, UserLocalDUZ, UserSSN: String): Boolean; // this is used if the broker was already created but it was closed or there was an error.
Begin
  Result := False;
End;

Procedure TMagRemoteDummyBroker.SetServerDetails(Server: String; Port: Integer);
Begin
// JMW P72 2/13/07 I don't think we still need to do this - these values should not change
{
  FServerName := Server;
  FServerPort := Port;
  }
End;

Procedure TMagRemoteDummyBroker.CheckSensitiveAccess(Var SensitveCode: Integer; Var Msg: Tstringlist);
Begin
  // sensitive check?
  // not done to the DOD
End;

Procedure TMagRemoteDummyBroker.LogRestrictedAccess();
Begin
  // log access
End;

Function TMagRemoteDummyBroker.GetPatientStudies(Pkg, Cls, Types, Event,
  Spc, FrDate, ToDate, Origin: String; Var Results: TStrings; Var Partial_Returned: Boolean; Var Partial_Msg: String): TMagPatientStudyResponse;  {/ P117 NCAT - JK 11/30/2010 /}
Begin
  Result := MagStudyResponseException;
End;

Procedure TMagRemoteDummyBroker.GetImageGlobalLookup(Ien: String; Var Rlist: TStrings);
Begin
  // not done to the DOD
End;

Procedure TMagRemoteDummyBroker.GetMagDevFields(Ien, Flags: String; Var Output: Tstringlist);
Begin
  // not done to the DOD
End;

Procedure TMagRemoteDummyBroker.LogCopyAccess(IObj: TImageData; Msg: String;
  EventType: TMagImageAccessEventType);
Begin

End;

Procedure TMagRemoteDummyBroker.GetImageInformation(IObj: TImageData; Var Output: TStrings);
Begin
  If Output = Nil Then
    Output := Tstringlist.Create();
End;

Function TMagRemoteDummyBroker.Getreport(IObj: TImageData): TStrings;
Begin
  Result := Tstringlist.Create();
End;

Procedure TMagRemoteDummyBroker.LogOfflineImageAccess(IObj: TImageData);
Begin
  // nothing to do for DOD
End;

Procedure TMagRemoteDummyBroker.LogAction(Msg: String);
Begin
  // log action
End;

Function TMagRemoteDummyBroker.QueImage(ImgType: String; IObj: TImageData): TStrings;
Begin
  //jw 11/19/07
  Result := Tstringlist.Create();
  Result.Add('-1^Not applied for Webservice broker')
  // nothing to do for DOD (maybe pre-cache)?
End;

Function TMagRemoteDummyBroker.QueImageGroup(Images: String; IObj: TImageData): String;
Begin
  //jw 11/19/07
  Result := '';
  // nothing to do for DOD (maybe pre-cache)?
End;

Procedure TMagRemoteDummyBroker.GetImageGroup(IObj: TImageData; NoQAcheck: Boolean; Output: TStrings);
Begin

End;

Function TMagRemoteDummyBroker.GetServerDescription(): String;
Begin
  Result := '[' + FSite.SiteNumber + ']';
End;

{JK 10/5/2009 - Maggmsgu refactoring - remove old method}
//procedure TMagRemoteDummyBroker.setLogEvent(LogEvent : TMagLogEvent);
//begin
//  FOnLogEvent := LogEvent;
//end;

{JK 10/5/2009 - Maggmsgu refactoring - remove old method}
//function TMagRemoteDummyBroker.getLogEvent() : TMagLogEvent;
//begin
//  result := FOnLogEvent;
//end;

Function TMagRemoteDummyBroker.GetRemoteUserDUZ(): String;
Begin
  // not going to have this value from DOD (will get from VA?)
  Result := '';
End;

Function TMagRemoteDummyBroker.IsBrokerLateCountUpdate(): Boolean;
Begin
  Result := True;
End;

{JK 10/5/2009 - Maggmsgu refactoring - remove old method}
//procedure TMagRemoteDummyBroker.LogMsg(MsgType : String; Msg : String; Priority : TMagLogPriority = MagLogINFO);
//begin
//  if assigned(FOnLogEvent) then
//    FOnLogEvent(self, MsgType, Msg, Priority);
//end;

Function TMagRemoteDummyBroker.GetRemoteBrokerType(): TMagRemoteBrokerType;
Begin
  Result := MagRemoteWSBroker;
End;

Function TMagRemoteDummyBroker.GetSite(): TVistaSite;
Begin
  Result := FSite;
End;

Procedure TMagRemoteDummyBroker.KeepBrokerAlive(Enabled: Boolean);
Begin
  // this function should do nothing for a WS broker
End;

Procedure TMagRemoteDummyBroker.RPMagTeleReaderUnreadlistGet(Var t: TStrings;
  AcquisitionPrimaryDivision, Sitecode, SpecialtyCode, ProcedureStrings,
  LastUpdate, UserDUZ, LocalSiteCode, SiteTimeOut, StatusOptions: String);
Begin
  If t = Nil Then
    t := Tstringlist.Create();
End;

Procedure TMagRemoteDummyBroker.RPMagTeleReaderUnreadlistLock(Var Xmsg: String;
  AcquisitionPrimaryDivision, AcquisitionSiteCode, ItemID, LockUnlockValue,
  UserFullName, UserInitials, LocalDUZ, LocalSiteCode: String);
Begin
  Xmsg := '';
End;

End.
