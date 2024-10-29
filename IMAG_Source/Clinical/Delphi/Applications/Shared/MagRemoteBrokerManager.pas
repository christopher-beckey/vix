Unit MagRemoteBrokerManager;
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
        ;;  Description: This is a manager object that controls access to the remote broker objects.
        ;;
        ;;+---------------------------------------------------------------------------------------------------+
*)

Interface

Uses
  Classes,
  imaginterfaces,
  cMagUtils,
  ImagingExchangeSiteService,
  IMagRemoteBrokerInterface,
  Magremoteinterface,
  UMagClasses
  ;

//Uses Vetted 20090929:cmagRemoteWSBroker, MagImageManager, graphics, controls, extctrls, dialogs, trpcb, cMagRemoteDummyBroker, cMagRemoteWSBrokerFactory, forms, StrUtils, cMagImageUtility, fMagPatAccess, umagutils, uMagDefinitions, magremotebroker, sysutils

Type
  TMagRemoteBrokerManager = Class(TComponent, IMagRemoteinterface)
  Private
  {
    FRIVAutoConnectEnabled : boolean; // determines if auto connect is enabled for RIV
    FConnectVISNOnly : boolean;  // determines if auto connect is enabled for local VISN only
    }

    FKeepBrokersAlive: Boolean;
    FLocalSiteCode: String; // the local site code (IEN)
    FLocalSiteStationNumber: String; // the local site station number   //P127T1 -  NST 04/06/2012
    BrokerCount: Integer; // the current number of remote brokers
    BrokerMax: Integer; // the current max number of remote brokers in the array
     //LocalVISNID : String // was in 45 and 46 used it, out in 72
    LocalVISNSites: TStrings; // a list of sites in the local VISN (holds the SiteCodes only)

    LocalPatientDFN: String; // 46 not 45,72
    PatientICN: String; // the selected patient's ICN
    PatientICNWithChecksum: String; // the selected patient's ICN including the checksum
    UserSSN: String; // the logged in users SSN

    SitePreferences: TStrings; // holds site preferences, what sites to never connect to and what sites to always connect to (not used really at the moment)

    UserFullName: String; // the logged in users full name
    UserInitials: String; // the logged in user's initials 46 not 45
    UserLocalDUZ: String; // the logged in users local DUZ

    WorkstationID: String; // the local workstation ID

    // items needed for setting up the session
    ApplicationPath: String;
    ApplicationEXEName: String;
    WorkstationComputerName: String;
    WorkstationLocation: String;
    LastMagUpdate: String;
    Startmode: Integer;
    EnableConnectRemoteSites: Boolean; //46
//    SafeToChangePatient : boolean;//46
    // primary division for local site//46
    FLocalPrimaryDivison: String; //46

    SiteServiceFailed: Boolean; //46

    //FOnLogEvent : TMagLogEvent; 
    FLocalSite: TVistaSite;

    // JMW 4/1/08 P72 - determines if WS brokers can be allowed (not allowed for TeleReader)
    FUseWSBrokers: Boolean;

    // determines if the user is allowed to view studies/images from DOD sites (200)
    FAllowedDODSites: Boolean;

    // determines if the client is blocked from using the VIX for VA sites
    FBlockVixVASites: Boolean;

    FLocalBrokerPort: Integer;
    FSecurityTokenNeeded: TMagSecurityTokenNeededEvent;
    FLogCapriConnect: TMagLogCapriConnectionEvent;
    FApplicationType: TMagRemoteLoginApplication;


//Was for RCA decouple magmsg, not now.    procedure MyLogMsg(msgType, msg: String; Priority: TMagMsgPriority = magmsgINFO);  //RCA

    // checks the SitePreferences list to see if the site is allowed
    Function CheckSiteAllowed(SiteName: String): Boolean;

    // creates a new remote broker connection
//    function CreateBroker(Server :String; Port:  integer; SiteName : String; SiteCode : String) : boolean;
    Function CreateBroker(Site: TVistaSite): Boolean;

    Procedure DisconnectAllRemoteBrokers(); // disconnects all remote broker connections

    // functions for use with the class properties
//    procedure SetRIVAutoConnectEnabled(const Value: boolean);
//    procedure setConnectVISNOnly(const Value : boolean);
    Procedure SetLocalSiteCode(Const Value: String);
    Procedure SetLocalSiteStationNumber(Const Value: String);  //P127T1 -  NST 04/06/2012

    // determines if the SiteCode is in the local VISN
    Function CheckSiteInVISN(Sitecode: String): Boolean;
    // count the number of active broker connections
    Function GetPatientActiveBrokerCount(): Integer;

    // Check to see if the MPI has a different name for the site, use that on instead
    Function CheckMPISiteName(TreatingList: TStrings; Sitecode: String): String;

    //    function isSiteDOD(SiteCode : String) : boolean;
    //46 deactivate remote sites (not disconnect)
    Procedure DeactivateAll(); //46

    Function GetLocalSiteCode(): String;
   //130 made public   Function GetLocalSite(): TVistaSite;
    Function GetDemoLocalSite(): TVistaSite;
    Function GetImagingExchangeSiteService(): ImagingExchangeSiteServiceSoap;
    Procedure CheckOverrideLocalVix();
  Public
    NewPatientSelected: Boolean; //46
    //46RemoteBrokerArray : Array of TMagRemoteBroker; // array of RemoteBroker objects

    RemoteBrokerArray: Array Of IMagRemoteBroker; // TMagRemoteBroker; // array of RemoteBroker objects
    Procedure ConnectRemoteBroker(Sitecode: String); // connects the remote site  //46 made this public, 45,72 was private
    Procedure SetPatientLocalDFN(DFN: String); //46
    // for RIV context observation
    Procedure RIVRecieveUpdate_(action: String; Value: String);
    // create broker connections from a string of site codes (Code1^Code2^...)
    Function CreateBrokerFromSiteCodes(SiteCodes: String; TreatingList: TStrings = Nil): Boolean;

    Function GetBroker(Server: String; Port: Integer): IMagRemoteBroker; Overload; // retrieves a broker based on the server/port
    Function GetBroker(Sitecode: String): IMagRemoteBroker; Overload; // retrieves a broker based on the site code//46
//    function getRPCBroker(SiteCode: string) :TRPCBroker;
    Function GetDemoSites(SiteCodes: String; Var ResultSites: ArrayOfImagingExchangeSiteTO): Boolean; // retrieves the demo site information (for demomode=true)
    // counts the number of images the patient has at it's active remote sites
    //46      function getRemoteActiveImageCount() : integer;
    //45 and 72 had PatientDFN Parameter, 46 didn't
    Function GetRemoteActiveImageCount(): Integer;
    Procedure ClearActiveRemoteBrokers();
    Function IsRemoteBrokerActive(BrokerIndex: Integer): Boolean;
    Function GetRemoteDFN(BrokerIndex: Integer): String; Overload;
    Function GetRemoteDFN(Server: String; Port: Integer): String; Overload;
    Procedure SetPatientICN(ICN: String);
    Procedure SetRemoteDFN();
    // disconnects all remote brokers
    Procedure LogoffRemoteBrokers();
    // retrieves the logged in users SSN
    Function GetUserSSN(): String;
    // sets the logged in user's SSN
    Procedure SetUserSSN(NewSSN: String);
    // gets the number of brokers (connected and disconnected)
    Function GetBrokerCount(): Integer;
    // gets the max number of brokers allocated in the array
    Function GetMaxBrokerCount(): Integer;
    // gets the logged in user's DUZ
    Function GetUserLocalDUZ(): String;
    // sets the logged in user's DUZ
    Procedure SetUserLocalDUZ(NewDUZ: String);
    // gets the logged in user's full name
    Function GetUserFullName(): String;
    // sets the logged in user's Full name
    Procedure SetUserFullName(NewUserFullName: String);

    //46 gets the logged in user's Initials
    Function GetUserInitials(): String;
    //46 sets the logged in user's Initials
    Procedure SetUserInitials(NewUserInitials: String);

//    property RIVAutoConnectEnabled : boolean read FRIVAutoConnectEnabled write SetRIVAutoConnectEnabled;
//    property ConnectVISNOnly : boolean read FConnectVISNOnly write SetConnectVISNOnly;
    // property for the local site's Code
    Property LocalSiteCode: String Read FLocalSiteCode Write SetLocalSiteCode;
    // property for the local site's Station Number
    Property LocalSiteStationNumber: String Read FLocalSiteStationNumber Write SetLocalSiteStationNumber;     //P127T1 -  NST 04/06/2012
    // Get the number of brokers
//46 had this property, and function getBrokerCount
// 45,72 has Private BrokerCount, and function getBrokerCount
//    property BrokerCount : integer read getBrokerCount;

   // log broker not found details (when a broker is not found for a server and a port)
    Procedure LogBrokerNotFoundError(Server: String; Port: Integer; RPCFunction: String = '');
    // check the active sites to see if the patient is sensitive, also display dialog
 // 45 and 46 had the ..var RemoteAccess 72didn't
 // procedure checkPatientSensitive(var RemoteAccess : TList);
    Procedure CheckPatientSensitive();
    //46 changed this to function and PatDFN param added
    Function DoneMakingConnections(PatDFN: String): Boolean;
   //45 and 72 had this
//procedure DoneMakingConnections();
    // disconnects the remote site based on the site code
    Procedure DisconnectRemoteBroker(Sitecode: String); //46 made this public, 45,72 was private
    // retrieves the users remote DUZ based on the site code (p46) 2/2/2006
   //46
    Function GetRemoteUserDUZ(Sitecode: String): String;
    //46
    Property LocalPrimaryDivision: String Read FLocalPrimaryDivison Write FLocalPrimaryDivison;

    //property OnLogEvent : TMagLogEvent read FOnLogEvent write FOnLogEvent;

    {/ P117 NCAT - JK 11/30/2010 /}
 {7/12/12 gek Merge 130->129}
    {/ P130 JK - 6/25/2012 added ShowDeletedImages: Boolean parameter /}
    Function GetPatientStudies(Pkg, Cls, Types, Event, Spc, FrDate, ToDate, Origin: String;
                ShowDeletedImages: Boolean; Var Results: TStrings; Var Partial_Returned: Boolean; Var Partial_Msg: String): Boolean;

    Procedure KeepBrokersAlive(Enabled: Boolean);

    Property UseWSBrokers: Boolean Read FUseWSBrokers Write FUseWSBrokers;
    Property AllowedDODSites: Boolean Read FAllowedDODSites Write FAllowedDODSites;
    Property BlockVixVASites: Boolean Read FBlockVixVASites Write FBlockVixVASites;
 {7/12/12 gek Merge 130->129}
    Function GetLocalSite(): TVistaSite; {/ P130 - moved this from private to public to be able to see the local VIX info when needed. /}
 {7/12/12 gek Merge 130->129}
    {/P130 - JK 5/14/2012 - Expose the full ICN that includes the ICN checksum. /}
    property PatICNWithChecksum: String read PatientICNWithChecksum;
  Protected

  End;

// Initialize the MagRemoteBrokerManager
Procedure Initialize(LocalWorkstationID: String; AppPath, DispAppName,
  CapAppName, Compname, Location, LastUpdate: String; Startmode: Integer;
  TSitePreferences: TStrings; LocalBrokerPort: Integer;
  SecurityTokenNeeded: TMagSecurityTokenNeededEvent;
  LogCapriConnect: TMagLogCapriConnectionEvent;
  ApplicationType: TMagRemoteLoginApplication);
// Convert the treating facility list (if the list is not an array it must be converted)
Procedure ConvertTreatingFacilityList(InputData: TStrings; Var TreatingList: Tstringlist);

{/ P122 - Julian Werfel - remedy ticket number HD0000000529824 /}
Function ConvertTreatingFacilitySite(SiteDetails : String) : String;

// check if a merge of image columns is needed
Function IsMergeColumnHeadersNeeded(RowHeader1, RowHeader2: String): Boolean;
// merge the column information for image data
Procedure MergeColumnHeaders(Var RowList1: TStrings; Var RowList2: TStrings);
// add a column of image information to one list of images
Procedure InsertColumn(ColumnHeader: String; ColumnLocation: Integer; Var ImageList: TStrings);
// check to see if the site service is disabled
//function isSiteServiceDisabled() : boolean;

Function IsRIVEnabled(): Boolean;

// parse characters out of the Site Code
Function ParseSiteCode(Input: String): String;
//46 converts value to datetime and formats it for sorting
{DONE -oGarrett -cRefactor :, move to umagutils   MagConvertAndFormatDateTime}
// converts value to datetime and formats it for sorting
//function convertAndFormatDateTime(Value : String) : String;

Function ConvertExchangeSiteToVistaSite(Site: ImagingExchangeSiteTO; returnNilForFault: Boolean = False): TVistaSite;

Var
  MagRemoteBrokerManager1: TMagRemoteBrokerManager;
  NotFirstTime: Boolean;
  DemoRemoteSites: Boolean;
  SiteServiceURL: String;
  MagUtilities: TMagUtils;
  RIVEnabled: Boolean;
  LocalVixServerOverride: String;
  LocalVixPortOverride: Integer;
  ExchangeSiteService: ImagingExchangeSiteServiceSoap;

Const
  REMOTE_SITE_SERVICE_DISABLED = 'disabled';
Const
  REMOTE_SITE_SERVICE_DISABLED_URL = 'http://disabled.';

Implementation

Uses
  cMagImageUtility,
  cMagRemoteDummyBroker,
  cMagRemoteWSBrokerFactory,
  ImagDMinterface,  // DmSingle
  FMagPatAccess,
  Forms,
  MagRemoteBroker,
  StrUtils,
  SysUtils,
  UMagDefinitions,
  Umagutils8
  ;

Function IsRIVEnabled(): Boolean;
Begin
  Result := RIVEnabled;
End;
                       {
function isSiteServiceDisabled() : boolean;
begin
  if SiteServiceURL = REMOTE_SITE_SERVICE_DISABLED then
  begin
    result := true;
    exit;
  end
  else if SiteServiceURL = REMOTE_SITE_SERVICE_DISABLED_URL then
  begin
    result := true;
    exit;
  end;
  result := false;
end;
}
//46;  out in 59, moved to MagConverta.... in uMagutils.
(*
function convertAndFormatDateTime(Value : String) : String;
var
  res : String;
begin
  res := value;
  try
    res := formatdatetime('yyyymmddhhmmnn', strtodatetime(value));
  except
    on e : Exception do
    begin
      MagRemoteBrokerManager1.LogMsg('s', 'Error converting value [' + value + '] to date, Exception=[' + e.Message + ']');
    end
  end;
  result := res;
end;
*)



//RCA 11/11/2011  gek  remove dependency on maggmsgu and VCLZip.  Use interface (if it is declared).
(*  procedure TMagRemoteBrokerManager.MyLogMsg(msgType, msg: String; Priority: TMagMsgPriority = magmsgINFO);
begin
if ImsgObj <> nil then  ImsgObj.LogMsg(msgtype,msg,priority);
end;
*)

Function TMagRemoteBrokerManager.GetMaxBrokerCount(): Integer;
Begin
  Result := BrokerMax;
End;

Function TMagRemoteBrokerManager.GetBrokerCount(): Integer;
Begin
  Result := BrokerCount;
End;

Procedure TMagRemoteBrokerManager.SetLocalSiteCode(Const Value: String);
Begin
  FLocalSiteCode := Value;
End;
//P127T1 -  NST 04/06/2012
Procedure TMagRemoteBrokerManager.SetLocalSiteStationNumber(Const Value: String);
Begin
  FLocalSiteStationNumber := Value;
End;

Procedure TMagRemoteBrokerManager.LogBrokerNotFoundError(Server: String; Port: Integer; RPCFunction: String = '');
Begin
//  maggmsgf.MagMsg('s', 'Unable to find broker at [' + Server + ', ' + inttostr(Port) + '] to run function [' +  RPCFunction + '], function will not continue. ' + formatdatetime('mm/dd/yy@hh:nn:ss.zzz', now));
  //LogMsg('s', 'Unable to find broker at [' + Server + ', ' + inttostr(Port) + '] to run function [' +  RPCFunction + '], function will not continue. ' + formatdatetime('mm/dd/yy@hh:nn:ss.zzz', now), magmsgwarn);
  magAppMsg('s', 'Unable to find broker at [' + Server + ', ' +
    Inttostr(Port) + '] to run function [' + RPCFunction + '], function will not continue. ' +
    Formatdatetime('mm/dd/yy@hh:nn:ss.zzz', Now), magmsgwarn); 
End;

//46 changed this to Function, 45,72 had it as procedure.
// also 46 uses NewPatientSelected, 45,72 didn't.
// it was like this in 46, i.e. no result was returned.

Function TMagRemoteBrokerManager.DoneMakingConnections(PatDFN: String): Boolean;
Begin
  RIVNotifyAllListeners(Self, 'ServerConnectionsComplete', '');
  NewPatientSelected := False;

     { TODO: this didn't seem like that bad of an idea, if not needed then remove parameter}
  {
  if patdfn = MagRemoteBrokerManager1.LocalPatientDFN then result := true
    else result := false;
    }
  Result := True;
End;
(* This was 45 and 72
procedure TMagRemoteBrokerManager.DoneMakingConnections();
begin
  RIVNotifyAllListeners(self,'ServerConnectionsComplete','');
end;
*)

Procedure TMagRemoteBrokerManager.RIVRecieveUpdate_(action: String; Value: String);
Begin

  If action = 'SetDisconnected' Then
  Begin
    DisconnectRemoteBroker(Value);
  End
  //else if (Action = 'SetConnected') or (Action = 'SetActive') then
  Else
    If action = 'ReconnectSite' Then
    Begin
      ConnectRemoteBroker(Value);
    End
    Else
      If action = 'Set Inactive' Then
      Begin

      End
      Else
        If action = 'DisconnectAll' Then
        Begin
          DisconnectAllRemoteBrokers();
        End
        Else
          If action = 'RIVAutoOFF' Then
          Begin
            Upref.RIVAutoConnectEnabled := False; // might not be using this feature [RIVAutoOff] anymore
//    RIVAutoConnectEnabled := false;
          End
          Else
            If action = 'RIVAutoON' Then
            Begin
              Upref.RIVAutoConnectEnabled := True;
//    RIVAutoConnectEnabled := true;
            End
            Else
              If action = 'VISNOnlyOn' Then
              Begin
                Upref.RIVAutoConnectVISNOnly := True;
//    ConnectVISNOnly := true;
              End
              Else
                If action = 'VISNOnlyOff' Then
                Begin
                  Upref.RIVAutoConnectVISNOnly := False;
//    ConnectVISNOnly := false;
                End
// in both 45 and 72, this was end of procedure,
// 46 had all code from here.
                Else
                  If action = 'StopRemoteConnections' Then
                  Begin
                    Self.EnableConnectRemoteSites := False;
     // stop connecting to remote sites...
                  End
                  Else
                    If action = 'NewPatientSelected' Then
                    Begin
    //LogMsg('s', 'MagRemoteBrokerManager - a new patient has been selected, setting new patient selected to true');
                      magAppMsg('s', 'MagRemoteBrokerManager - a new patient has been selected, setting new patient selected to true'); 
                      Self.NewPatientSelected := True;
                    End
                    Else
                      If action = 'DeactivateAll' Then
                      Begin
                        DeactivateAll();
                      End
                      {/ P117 NCAT - JK 12/15/2010 /}
                      Else
                        If action = 'RIVDoD_On' Then
                        Begin
                          Upref.RIVAutoConnectDoD := True;
                        End
                        Else
                          if action = 'RIVDoD_Off' then
                          Begin
                            Upref.RIVAutoConnectDoD := False;

{
  end
  else if Action = 'CheckSafeToChangePatient' then
  begin
    if self.SafeToChangePatient then RIVNotifyAllListeners(self,'SafeToChangePatient','');
    }
                      End
                      Else
                        If action = 'RetrySiteService' Then
                        Begin
                          SiteServiceFailed := False;
                        End;
End;

Function TMagRemoteBrokerManager.GetUserLocalDUZ(): String;
Begin
  Result := UserLocalDUZ;
End;

Procedure TMagRemoteBrokerManager.SetUserLocalDUZ(NewDUZ: String);
Begin
  UserLocalDUZ := NewDUZ;
End;

Function TMagRemoteBrokerManager.GetUserFullName(): String;
Begin
  Result := UserFullName;
End;

Procedure TMagRemoteBrokerManager.SetUserFullName(NewUserFullName: String);
Begin
  UserFullName := NewUserFullName;
End;
//46

Function TMagRemoteBrokerManager.GetUserInitials(): String;
Begin
  Result := UserInitials;
End;
//46

Procedure TMagRemoteBrokerManager.SetUserInitials(NewUserInitials: String);
Begin
  UserInitials := NewUserInitials;
End;

Function TMagRemoteBrokerManager.GetUserSSN(): String;
Begin
  Result := UserSSN;
End;

Procedure TMagRemoteBrokerManager.SetUserSSN(NewSSN: String);
Begin
  UserSSN := NewSSN;
End;

Procedure TMagRemoteBrokerManager.ClearActiveRemoteBrokers();
Begin
  DeactivateAll(); //46
  RIVNotifyAllListeners(Self, 'DeactivateAll', '');
End;

Procedure TMagRemoteBrokerManager.DeactivateAll(); //46
Var
  i: Integer;
Begin
  NewPatientSelected := False;
  For i := 0 To BrokerCount - 1 Do
  Begin
    RemoteBrokerArray[i].ClearPatient();
  End;
End;

Procedure TMagRemoteBrokerManager.LogoffRemoteBrokers();
Var
  i: Integer;
Begin
  GetImageUtility().ResetUserCredentials(); //72
  cMagRemoteWSBrokerFactory.ClearBrokerFactory();
  For i := 0 To BrokerCount - 1 Do
  Begin
    RemoteBrokerArray[i].Disconnect();
    RemoteBrokerArray[i].clearBrokerFields(); //useless since we are about to set this broker to nil... right?
    RemoteBrokerArray[i] := Nil;
  End;
  BrokerCount := 0;
  UserSSN := '';
  UserFullName := '';
  UserLocalDUZ := '';
  FLocalSiteCode := '';
  FLocalSiteStationNumber := '';   //P127T1 -  NST 04/06/2012
  If FLocalSite <> Nil Then
    FLocalSite.Free();
  FLocalSite := Nil;
  ExchangeSiteService := Nil;
  RIVNotifyAllListeners(Self, 'RemoveAll', '');
End;

//46

Procedure TMagRemoteBrokerManager.SetPatientLocalDFN(DFN: String);
Begin
  LocalPatientDFN := DFN;
End;

Procedure TMagRemoteBrokerManager.SetPatientICN(ICN: String);
Begin
  // don't know if we want to do this or not...
  // this is needed if we are using VAFCTFU CONVERT DFN TO ICN to get the ICN and then using GET VARIABLE VALUE to convert back to ICN
  PatientICNWithChecksum := ICN;
  PatientICN := MagUtilities.MagPiece(ICN, 'V', 1);

//  PatientICN := ICN;
End;

Function TMagRemoteBrokerManager.GetRemoteDFN(BrokerIndex: Integer): String;
Var
  RDFN: String;
Begin
  RDFN := '';
  If RemoteBrokerArray[BrokerIndex].GetPatientStatus = STATUS_PATIENTACTIVE Then
  Begin
    RDFN := RemoteBrokerArray[BrokerIndex].GetRemotePatientDFN();
  End;
  Result := RDFN;
End;

Function TMagRemoteBrokerManager.GetRemoteDFN(Server: String; Port: Integer): String;
Var
  SName: String;
  SPort, i: Integer;
Begin
  For i := 0 To BrokerCount - 1 Do
  Begin
    SName := Lowercase(RemoteBrokerArray[i].GetServerName());
    SPort := RemoteBrokerArray[i].GetServerPort();
    If ((SName = Lowercase(Server)) And (SPort = Port)) Then
    Begin
      Result := RemoteBrokerArray[i].GetRemotePatientDFN();
      Exit;
    End;
  End;
  Result := '';

End;

Procedure TMagRemoteBrokerManager.SetRemoteDFN();
Var
  i: Integer;
  IcnToUse: String; //72
Begin
    //46 added then RIVUpdate and if...
  RIVNotifyAllListeners(Self, 'Announcement', 'Loading remote patient information');
  If Self.NewPatientSelected Then
  Begin
    //LogMsg('s', 'MagRemoteBrokerManager - a new patient has been selected, will not retrieve patient DFN at remote sites');
    magAppMsg('s', 'MagRemoteBrokerManager - a new patient has been selected, will not retrieve patient DFN at remote sites'); 
    Exit;
  End;
     //46 end
  For i := 0 To BrokerCount - 1 Do
  Begin
    If RemoteBrokerArray[i].GetRemoteBrokerType = MagRemoteWSBroker Then //72
      IcnToUse := PatientICNWithChecksum //72
    Else //72
      IcnToUse := PatientICN; //72
    If RemoteBrokerArray[i].GetPatientStatus = STATUS_PATIENTACTIVE Then
    Begin
      If Not RemoteBrokerArray[i].SetPatientDFN(IcnToUse) Then
      Begin
      //Update_('SetInactive', RemoteBrokerArray[i].getSiteName());
        RIVNotifyAllListeners(Self, 'SetInactive', RemoteBrokerArray[i].GetSiteCode());
      End;
    End;
  End;
End;

// may want to change this to recieve the site code...

Procedure TMagRemoteBrokerManager.DisconnectRemoteBroker(Sitecode: String);
Var
  Port, i: Integer;
  Server: String;
Begin
  For i := 0 To BrokerCount - 1 Do
  Begin
//    if RemoteBrokerArray[i].getSiteName() = SiteName then
    If RemoteBrokerArray[i].GetSiteCode() = Sitecode Then
    Begin
      Server := RemoteBrokerArray[i].GetServerName();
      Port := RemoteBrokerArray[i].GetServerPort();
      RemoteBrokerArray[i].Disconnect();
      //maggmsgf.MagMsg('s', 'Connection to Broker [' + Server + ', ' + inttostr(Port) + '] has been closed. ' + formatdatetime('mm/dd/yy@hh:nn:ss.zzz', now));
      //LogMsg('s', 'Connection to Broker [' + Server + ', ' + inttostr(Port) + '] has been closed. ' + formatdatetime('mm/dd/yy@hh:nn:ss.zzz', now));
      magAppMsg('s', 'Connection to Broker [' + Server + ', ' +
        Inttostr(Port) + '] has been closed. ' +
        Formatdatetime('mm/dd/yy@hh:nn:ss.zzz', Now)); 
      Exit;
    End;
  End;
End;

Procedure TMagRemoteBrokerManager.DisconnectAllRemoteBrokers();
Var
  Port, i: Integer;
  Server: String;
Begin
  For i := 0 To BrokerCount - 1 Do
  Begin
    Server := RemoteBrokerArray[i].GetServerName();
    Port := RemoteBrokerArray[i].GetServerPort();
    RemoteBrokerArray[i].Disconnect();
    //maggmsgf.MagMsg('s', 'Connection to Broker [' + Server + ', ' + inttostr(Port) + '] has been closed. ' + formatdatetime('mm/dd/yy@hh:nn:ss.zzz', now));
    //LogMsg('s', 'Connection to Broker [' + Server + ', ' + inttostr(Port) + '] has been closed. ' + formatdatetime('mm/dd/yy@hh:nn:ss.zzz', now));
    magAppMsg('s', 'Connection to Broker [' + Server + ', ' +
      Inttostr(Port) + '] has been closed. ' +
      Formatdatetime('mm/dd/yy@hh:nn:ss.zzz', Now)); 
  End;
End;

Procedure TMagRemoteBrokerManager.ConnectRemoteBroker(Sitecode: String);
Var
  i: Integer;
  Shares: TStrings;
  Res: Boolean;
  Site: TVistaSite;
Begin
  For i := 0 To BrokerCount - 1 Do
  Begin
    If RemoteBrokerArray[i].GetSiteCode() = Sitecode Then
    Begin
      RIVNotifyAllListeners(Self, 'ConnectingRemote', RemoteBrokerArray[i].GetSiteName());
      //LogMsg('s', 'Creating Connection to Broker [' + RemoteBrokerArray[i].getServerDescription() + ']...');
      magAppMsg('s', 'Creating Connection to Broker [' + RemoteBrokerArray[i].GetServerDescription() + ']...'); 

      Res := True;
      If Not RemoteBrokerArray[i].ReOpenConnection(UserFullName, UserLocalDUZ, UserSSN) Then
      Begin
        // if the inital connect failed, see if it was with a ViX and if so and to a VA site, then try to connect with rpc method
        //logmsg('s','Failed to connect to broker [' + RemoteBrokerArray[i].getServerDescription() + ']');
        magAppMsg('s', 'Failed to connect to broker [' + RemoteBrokerArray[i].GetServerDescription() + ']'); 
        If (RemoteBrokerArray[i].GetRemoteBrokerType() = MagRemoteWSBroker) And (Not RemoteBrokerArray[i].GetSite().SiteRequiresViX()) Then
        Begin
          //LogMsg('s','Remote broker [' + remoteBrokerArray[i].getServerDescription() + '] was WS and does not require ViX, attempting to connect to remote VA site with RPC Broker');
          magAppMsg('s', 'Remote broker [' + RemoteBrokerArray[i].GetServerDescription() +
            '] was WS and does not require ViX, attempting to connect to remote VA site with RPC Broker'); 
          Site := TVistaSite.Create(RemoteBrokerArray[i].GetSite());
          RemoteBrokerArray[i] := Nil;
          RemoteBrokerArray[i] := TMagRemoteBroker.Create(Site.VistaServer,
            Site.VistaPort, Site.SiteName, Site.SiteNumber, Site,
            FLocalBrokerPort, FSecurityTokenNeeded, FLogCapriConnect, FApplicationType);
          //RemoteBrokerArray[i].OnLogEvent := OnLogEvent;   
          Res := RemoteBrokerArray[i].ReOpenConnection(UserFullName, UserLocalDUZ, UserSSN);
        End
        Else
        Begin
          Res := False;
        End;
      End;

      If Not Res Then
        Exit;

       {
      if RemoteBrokerArray[i].ReOpenConnection(UserFullName, UserLocalDUZ, UserSSN) then
      begin
      }
      Res := RemoteBrokerArray[i].CheckRemoteImagingVersion();
      If Not Res Then
      Begin
        RemoteBrokerArray[i].Disconnect(); // set this broker disconnected
        Exit;
      End;
      If RemoteBrokerArray[i].GetRemoteBrokerType = MagRemoteWSBroker Then
        RemoteBrokerArray[i].SetPatientDFN(PatientICNWithChecksum)
      Else
        RemoteBrokerArray[i].SetPatientDFN(PatientICN);
      RemoteBrokerArray[i].CreateSession(ApplicationPath, ApplicationEXEName, '', WorkstationComputerName, WorkstationLocation, LastMagUpdate, Startmode);
      Shares := Tstringlist.Create();
      RemoteBrokerArray[i].SetWorkstationID(WorkstationID); // needed to get the site parameters
      RemoteBrokerArray[i].GetNetworkLocations(Shares);

      idmodobj.GetMagFileSecurity.ShareList.AddStrings(Shares);
      FreeAndNil(Shares);
        //LogMsg('s', 'Connection to Broker [' + RemoteBrokerArray[i].getServerDescription() + '] has been established.');
      magAppMsg('s', 'Connection to Broker [' + RemoteBrokerArray[i].GetServerDescription() + '] has been established.'); 
      RIVNotifyAllListeners(Self, 'SetActive', RemoteBrokerArray[i].GetSiteCode());
      Exit;
    End;
  End;
End;

Function TMagRemoteBrokerManager.IsRemoteBrokerActive(BrokerIndex: Integer): Boolean;
Begin
  If BrokerIndex > BrokerCount Then
  Begin
    Result := False;
  End
  Else
  Begin
    If RemoteBrokerArray[BrokerIndex].GetPatientStatus = STATUS_PATIENTACTIVE Then
    Begin
      Result := True;
    End
    Else
    Begin
      Result := False;
    End;
  End;
End;

Procedure Initialize(LocalWorkstationID: String; AppPath, DispAppName,
  CapAppName, Compname, Location, LastUpdate: String; Startmode: Integer;
  TSitePreferences: TStrings; LocalBrokerPort: Integer;
  SecurityTokenNeeded: TMagSecurityTokenNeededEvent;
  LogCapriConnect: TMagLogCapriConnectionEvent;
  ApplicationType: TMagRemoteLoginApplication);
Begin
  If Not NotFirstTime Then
  Begin
    // initialize all of the variables
    MagRemoteBrokerManager1 := TMagRemoteBrokerManager.Create(Nil);
    MagRemoteBrokerManager1.WorkstationID := LocalWorkstationID;
    MagRemoteBrokerManager1.BrokerCount := 0;
    MagRemoteBrokerManager1.BrokerMax := 10;
    MagRemoteBrokerManager1.UserSSN := '';
    MagRemoteBrokerManager1.PatientICN := '';
    MagRemoteBrokerManager1.PatientICNWithChecksum := ''; //72
    MagRemoteBrokerManager1.UserFullName := '';
    MagRemoteBrokerManager1.UserLocalDUZ := '';
    MagRemoteBrokerManager1.SitePreferences := TSitePreferences;
    MagRemoteBrokerManager1.LocalSiteCode := '';
    MagRemoteBrokerManager1.LocalSiteStationNumber := '';    //P127T1 -  NST 04/06/2012
    MagRemoteBrokerManager1.ApplicationPath := AppPath;
    MagRemoteBrokerManager1.ApplicationEXEName := DispAppName;
    MagRemoteBrokerManager1.WorkstationComputerName := Compname;
    MagRemoteBrokerManager1.WorkstationLocation := Location;
    MagRemoteBrokerManager1.LastMagUpdate := LastUpdate;
    MagRemoteBrokerManager1.Startmode := Startmode;
    MagRemoteBrokerManager1.FLocalSite := Nil; //72
    MagRemoteBrokerManager1.EnableConnectRemoteSites := True; //46
    MagRemoteBrokerManager1.NewPatientSelected := False; //46
//    MagRemoteBrokerManager1.SafeToChangePatient := true;//46

    MagRemoteBrokerManager1.SiteServiceFailed := False; //46

    MagRemoteBrokerManager1.LocalVISNSites := Tstringlist.Create();
    // LocalVISNID in 45,46, out in 72     MagRemoteBrokerManager1.LocalVISNID := '';

    SetLength(MagRemoteBrokerManager1.RemoteBrokerArray, MagRemoteBrokerManager1.BrokerMax);
//    MagRemoteBrokerManager1.RIV Attach_();
    RIVAttachListener(MagRemoteBrokerManager1);
    NotFirstTime := True;
    ExchangeSiteService := Nil; //72
    MagRemoteBrokerManager1.FUseWSBrokers := True; // true by default
    MagRemoteBrokerManager1.FAllowedDODSites := True; // by default the user can access DOD sites
    MagRemoteBrokerManager1.FBlockVixVASites := False; // by default, allow the client to use a VIX for VA sites
//    SiteServiceURL := ''; // JMW 6/29/2005 p45t3 this value is written before the initialize is done
    MagRemoteBrokerManager1.FLocalBrokerPort := LocalBrokerPort;
    MagRemoteBrokerManager1.FSecurityTokenNeeded := SecurityTokenNeeded;
    MagRemoteBrokerManager1.FLogCapriConnect := LogCapriConnect;
    MagRemoteBrokerManager1.FApplicationType := ApplicationType;

    GetImageUtility().setApplicationType(applicationtype);
    GetImageUtility().setSecurityTokenNeededHandler(SecurityTokenNeeded);
    GetImageUtility().setLocalBrokerPort(LocalBrokerPort);
  End;
End;

//45,72 had param, 46 did not.
// JW is the DFN still used in this? I think it can be removed...

Function TMagRemoteBrokerManager.GetRemoteActiveImageCount(): Integer;
Var
  i: Integer;
  Count: Integer;
  SiteCount: Integer;
Begin
  Count := 0;
  If Self.NewPatientSelected Then //46 put in this if...
  Begin
    Result := Count;
    //LogMsg('s', 'MagRemoteBrokerManager - a new patient has been selected, will not count patient images at remote sites');
    magAppMsg('s', 'MagRemoteBrokerManager - a new patient has been selected, will not count patient images at remote sites'); 
    Exit;
  End;
  For i := 0 To BrokerCount - 1 Do
  Begin
    If RemoteBrokerArray[i].GetPatientStatus() = MagRemoteBroker.STATUS_PATIENTACTIVE Then
    Begin
      SiteCount := RemoteBrokerArray[i].CountImages();

      RIVNotifyAllListeners(Self, 'SetImageCount', RemoteBrokerArray[i].GetSiteCode + '^' + Inttostr(SiteCount));
      If SiteCount > 0 Then //72 put in this line, 45,46 just had next line.
        Count := Count + SiteCount;
    End;
  End;
  Result := Count;
End;

Function TMagRemoteBrokerManager.GetBroker(Server: String; Port: Integer): IMagRemoteBroker;
Var
  i, SPort: Integer;
  SName: String;
Begin
  For i := 0 To BrokerCount - 1 Do
  Begin
    SName := Lowercase(RemoteBrokerArray[i].GetServerName());
    SPort := RemoteBrokerArray[i].GetServerPort();
    If ((SName = Lowercase(Server)) And (SPort = Port)) Then
    Begin
      Result := RemoteBrokerArray[i]; //.getBroker(); //72 took out .getbroker
      Exit;
    End;
  End;
  Result := Nil;
End;
//46    - Do we still need this, resolving a Broker based on SiteCode ?  ?

Function TMagRemoteBrokerManager.GetBroker(Sitecode: String): IMagRemoteBroker; //72 : Pointer;
Var
  i: Integer;
Begin
  Result := Nil;
  For i := 0 To BrokerCount - 1 Do
  Begin
    If (RemoteBrokerArray[i].GetSiteCode() = Sitecode) Then
    Begin
      //result := RemoteBrokerArray[i].getBroker();
      Result := RemoteBrokerArray[i]; // 72 doesn't use -> .getBroker();
      Break;
    End;
  End;
End;

{
function TMagRemoteBrokerManager.getRPCBroker(SiteCode: string) :TRPCBroker; //72 : Pointer;
var
  i: integer;
begin
  result := nil;
  for i := 0 to BrokerCount -1 do
  begin
    if (RemoteBrokerArray[i].getSiteCode() = SiteCode) then
    begin
      //result := RemoteBrokerArray[i].getBroker();
      if (RemoteBrokerArray[i].getRemoteBrokerType = MagRemoteRPCBroker) then
          result := (TMagRemoteBroker(RemoteBrokerArray[i])).getbroker;           ; // 72 doesn't use -> .getBroker()
      break;
    end;
  end;
end;
}
//46

Function TMagRemoteBrokerManager.GetRemoteUserDUZ(Sitecode: String): String;
Var
  i: Integer;
Begin
  Result := '';
  For i := 0 To BrokerCount - 1 Do
  Begin
    If (RemoteBrokerArray[i].GetSiteCode() = Sitecode) Then
    Begin
      Result := RemoteBrokerArray[i].RemoteUserDUZ;
      Exit;
    End;
  End;
End;

//72 changed from ArrayofSiteTo,  ArrayOfImagingExchangeSiteTO

Function TMagRemoteBrokerManager.GetDemoSites(SiteCodes: String; Var ResultSites: ArrayOfImagingExchangeSiteTO): Boolean;
Var
  aSite: ImagingExchangeSiteTO;
  NumSites, i: Integer;
  SitesFile: Textfile;
  SiteLine: String;
  SiteName, Sitecode, SiteHost, SitePort, VixServer, VixPort: String;
  CurSite: String;
  SiteCount: Integer;
  DemoFilename: String;
Begin
  DemoFilename := MagUtilities.GetAppPath + '\demosites.txt';
  If Not FileExists(DemoFilename) Then
  Begin
    //LogMsg('s', 'Demo Site file [' + DemoFilename + '] not found, unable to connect to demo remote brokers');
    magAppMsg('s', 'Demo Site file [' + DemoFilename + '] not found, unable to connect to demo remote brokers'); 
    Result := False; // probably need to do something else... this won't work!
    Exit;
  End;
  SiteCount := 0;
  NumSites := MagUtilities.Maglength(SiteCodes, '^');
  SetLength(ResultSites, NumSites);
  AssignFile(SitesFile, DemoFilename);
  Reset(SitesFile);
  While Not Eof(SitesFile) Do
  Begin
    ReadLn(SitesFile, SiteLine);
    If (Pos('#', SiteLine) = 1) Then
    Begin
      // ignore this line, it is a comment
    End
    Else
    Begin
      SiteName := MagUtilities.MagPiece(SiteLine, '^', 1);
      Sitecode := MagUtilities.MagPiece(SiteLine, '^', 2);
      SiteHost := MagUtilities.MagPiece(SiteLine, '^', 3);
      SitePort := MagUtilities.MagPiece(SiteLine, '^', 4);
      VixServer := MagUtilities.MagPiece(SiteLine, '^', 5);
      VixPort := MagUtilities.MagPiece(SiteLine, '^', 6);
      For i := 1 To NumSites Do
      Begin
        CurSite := MagUtilities.MagPiece(SiteCodes, '^', i);
        If CurSite = Sitecode Then
        Begin
          aSite := ImagingExchangeSiteTO.Create;
          aSite.SiteNumber := Sitecode;
          aSite.SiteName := SiteName;
          aSite.VistaServer := SiteHost;
          aSite.VistaPort := Strtoint(SitePort);
          aSite.AcceleratorServer := VixServer;
          If VixPort <> '' Then
            aSite.AcceleratorPort := Strtoint(VixPort);
          ResultSites[SiteCount] := aSite;
          SiteCount := SiteCount + 1;
        End;
      End;
    End;
  End;
  CloseFile(SitesFile);
  Result := True;
End;

// this function expects SiteCodes to be a list like 660^440^...

Function TMagRemoteBrokerManager.CreateBrokerFromSiteCodes(SiteCodes: String; TreatingList: TStrings = Nil): Boolean;
Var
  NumSites: Integer;
  SiteData: ArrayOfImagingExchangeSiteTO;
  i: Integer;
  Status, CreateBrokerResult: Boolean;
  MPISiteName: String;
  UserCredentials: TMagRemoteCredentials;
Begin
  CreateBrokerResult := False;
  // JMW P72 4/19/2007 - be sure the credentials are set properly
  If Not GetImageUtility().IsUserCredentialsSet() Then
  Begin
    UserCredentials := TMagRemoteCredentials.Create();
    UserCredentials.UserLocalDUZ := UserLocalDUZ;
    UserCredentials.UserSSN := UserSSN;
    UserCredentials.UserFullName := UserFullName;
    UserCredentials.LocalSiteName := GSess.Wrksinst.Name;
    // JMW P72 2/6/2007 - Below should use primary site station number, not DUZ(2)
    // JMW P122 12/8/2011 - using the primary site station number, fixes HD0000000540859
    UserCredentials.LocalSiteNumber := PrimarySiteStationNumber;
    GetImageUtility().SetUserCredentials(UserCredentials);
  End;

  Status := True;
  If (Pos('^', SiteCodes) = 1) Then
  Begin
    SiteCodes := Copy(SiteCodes, 2, Length(SiteCodes));
  End;

  ClearActiveRemoteBrokers();
  NumSites := MagUtilities.Maglength(SiteCodes, '^');
  If DemoRemoteSites Then
  Begin
    If Not GetDemoSites(SiteCodes, SiteData) Then
    Begin
      // didn't get the demo sites, nothing to do
    End
    Else
    Begin
//      SiteData := getDemoSites(SiteCodes, SiteData);
      EnableConnectRemoteSites := True; //46
      NewPatientSelected := False; // maybe?  //46
      For i := 0 To NumSites - 1 Do
      Begin
        If SiteData[i] = Nil Then
        Begin
            //LogMsg('s', 'Server details for a demo site was not found, unable to connect to demo remote broker.');
          magAppMsg('s', 'Server details for a demo site was not found, unable to connect to demo remote broker.'); 
          Status := False;
        End
        Else
        Begin
          MPISiteName := CheckMPISiteName(TreatingList, SiteData[i].SiteNumber); //45,46 was sitecode, 72 siteNumber
          If MPISiteName = '' Then MPISiteName := SiteData[i].SiteName; //45,46 was name  , 72 sitename
          SiteData[i].SiteName := MPISiteName; //72
            //45,46 had parameters, 72 had 1
   //46 moved this line after if...CreateBrokerResult := CreateBroker(convertExchangeSiteToVistaSite(SiteData[i]));
           //46 put in if(EnableCon...
          If (EnableConnectRemoteSites) And (Not NewPatientSelected) Then
          Begin
            //46CreateBrokerResult := CreateBroker(SiteData[i].hostname, SiteData[i].port, MPISiteName, SiteData[i].sitecode);
   //72 only had the one param,
            CreateBrokerResult := CreateBroker(ConvertExchangeSiteToVistaSite(SiteData[i])); //72
          End
          Else
          Begin
            If Not EnableConnectRemoteSites Then
            Begin
                 //LogMsg('s', 'MagRemoteBrokerManager - The user has cancelled connections to remote sites, no longer connecting to remote sites');
              magAppMsg('s', 'MagRemoteBrokerManager - The user has cancelled connections to remote sites, no longer connecting to remote sites'); 
            End
            Else
              If NewPatientSelected Then
              Begin
                //LogMsg('s', 'MagRemoteBrokerManager - A new patient was selected, no longer connecting to remote sites');
                magAppMsg('s', 'MagRemoteBrokerManager - A new patient was selected, no longer connecting to remote sites'); 
              End;
          End;
          If Not CreateBrokerResult Then Status := False;
        End;
       //46 put in next 3 lines.
        If Not EnableConnectRemoteSites Then Status := False;
        If NewPatientSelected Then Status := False;
        Application.Processmessages;
      End;
    End;
  End
  Else
  Begin
    // check to see if the service has been disabled.
    If Not MagRemoteBrokerManager.IsRIVEnabled() Then
    Begin
      //LogMsg('s', 'Site Service has been disabled.  Remote Image Views will not work without this service.');
      magAppMsg('s', 'Site Service has been disabled.  Remote Image Views will not work without this service.'); 
      RIVNotifyAllListeners(Self, 'SiteServiceDisabled', '');
      Result := False;
      Exit;
    End;
    //46 if siteserviceFailed
    If SiteServiceFailed Then
    Begin
      //LogMsg('s', 'VistA Site Services has already failed, will not attempt again.  Remote Image Views will not work without this service' + formatdatetime('mm/dd/yy@hh:nn:ss.zzz', now));
      magAppMsg('s', 'VistA Site Services has already failed, will not attempt again.  Remote Image Views will not work without this service' +
        Formatdatetime('mm/dd/yy@hh:nn:ss.zzz', Now)); 
      RIVNotifyAllListeners(Self, 'SiteServiceFailed', SiteServiceURL);
      Result := False;
      Exit;
    End;

    Try
      // initialize the service, catch any exceptions
      //LogMsg('s','Retrieving remote site information for sites [' + SiteCodes + ']');
      magAppMsg('s', 'Retrieving remote site information for sites [' + SiteCodes + ']'); 

    //46  SiteService := getSiteServiceSoap(false, SiteServiceURL, nil);
    //46  SiteData := SiteService.getSites(SiteCodes);

      SiteData := GetImagingExchangeSiteService().GetSites(SiteCodes);
    Except
      On e: Exception Do // if there was an error retrieving the information
      Begin
          //LogMsg('s', 'Unable to access Remote Site Services Server.  Remote Image Views will not work without this service. Exception=[' + e.Message + '].', magmsgerror);
        magAppMsg('s', 'Unable to access Remote Site Services Server.  Remote Image Views will not work without this service. Exception=[' +
          e.Message + '].', magmsgerror); 
        RIVNotifyAllListeners(Self, 'SiteServiceFailed', SiteServiceURL);
        Result := False;
        SiteServiceFailed := True; //46
        Exit;
      End;
    End;
    SiteServiceFailed := False; // probably don't need here, just for good measure
    EnableConnectRemoteSites := True;
//    NewPatientSelected := false; // maybe?

    For i := 0 To NumSites - 1 Do
    Begin
      MPISiteName := CheckMPISiteName(TreatingList, SiteData[i].SiteNumber);
      If MPISiteName = '' Then MPISiteName := SiteData[i].SiteName;
      SiteData[i].SiteName := MPISiteName;
      If (EnableConnectRemoteSites) And (Not NewPatientSelected) Then
      Begin
        //46 CreateBrokerResult := CreateBroker(SiteData[i].hostname, SiteData[i].port, MPISiteName, SiteData[i].Sitenumber);
       //72
        CreateBrokerResult := CreateBroker(ConvertExchangeSiteToVistaSite(SiteData[i]));
      End
      Else
      Begin
        If Not EnableConnectRemoteSites Then
        Begin
          //LogMsg('s', 'MagRemoteBrokerManager - The user has cancelled connections to remote sites, no longer connecting to remote sites');
          magAppMsg('s', 'MagRemoteBrokerManager - The user has cancelled connections to remote sites, no longer connecting to remote sites'); 
        End
        Else
          If NewPatientSelected Then
          Begin
          //LogMsg('s', 'MagRemoteBrokerManager - A new patient was selected, no longer connecting to remote sites');
            magAppMsg('s', 'MagRemoteBrokerManager - A new patient was selected, no longer connecting to remote sites'); 
          End;

      End;
      If Not EnableConnectRemoteSites Then Status := False;
      If Not CreateBrokerResult Then Status := False;
      If NewPatientSelected Then Status := False;
      Application.Processmessages;
    End;

    {this was 45 and 72, 72 changed property names, and
         the parameters in the CreateBroker function }
  {this was in 72, SiteData[i].siteName only diff from 45
    for i := 0 to NumSites - 1 do
    begin    { MPISiteName = Austion here}

    {  MPISiteName := checkMPISiteName(TreatingList, SiteData[i].Sitenumber);
      if MPISiteName = '' then MPISiteName := SiteData[i].sitename;
      SiteData[i].siteName := MPISiteName;
      CreateBrokerResult := CreateBroker(convertExchangeSiteToVistaSite(SiteData[i]));
      if not CreateBrokerResult then Status := false;
    end;  }
  End;
  RIVNotifyAllListeners(Self, 'RemoteConnectionsComplete', '');
  EnableConnectRemoteSites := True; //46
  Result := Status;
End;

Function TMagRemoteBrokerManager.CheckMPISiteName(TreatingList: TStrings; Sitecode: String): String;
Var
  i: Integer;
Begin
  If TreatingList = Nil Then
  Begin
    Result := '';
    Exit;
  End;
  For i := 0 To TreatingList.Count - 1 Do
  Begin
    If MagUtilities.MagPiece(TreatingList.Strings[i], '^', 1) = Sitecode Then
    Begin
      Result := MagUtilities.MagPiece(TreatingList.Strings[i], '^', 2);
      Exit;
    End;
  End;
  Result := '';
End;

// checks to see if the site has been put on the block list to not to connect to

Function TMagRemoteBrokerManager.CheckSiteAllowed(SiteName: String): Boolean;
Var
  i: Integer;
Begin

  For i := 0 To SitePreferences.Count - 1 Do
  Begin
    If (MagUtilities.MagPiece(SitePreferences.Strings[i], '^', 2) = SiteName) And (MagUtilities.MagPiece(SitePreferences.Strings[i], '^', 3) = 'N') Then
    Begin
      Result := False;
      Exit;
    End;
  End;
  Result := True;
//
End;

Function TMagRemoteBrokerManager.CheckSiteInVISN(Sitecode: String): Boolean;
Var
  SiteData: ArrayOfImagingExchangeSiteTO;
  VISNDetails: ImagingExchangeRegionTO;
  i, Count: Integer;
Begin

  //if self.ConnectVISNOnly = false then begin result := true; exit; end;
  If Upref.RIVAutoConnectVISNOnly = False Then
  Begin
    Result := True;
    Exit;
  End;

  If FLocalSiteCode = '' Then GetLocalSiteCode();
  //LogMsg('s', 'Local Site Code=[' + FLocalSiteCode + '].');
  magAppMsg('s', 'Local Site Code=[' + FLocalSiteCode + '].'); 
  If Self.LocalVISNSites.Count <= 0 Then
  Begin

    If GetLocalSite() = Nil Then // hopefully this won't ever happen...
    Begin
      //LogMsg('s', 'Unable to access Remote Site Services Server to get local site details.  Remote Image Views will not work without this service.');
      magAppMsg('s', 'Unable to access Remote Site Services Server to get local site details.  Remote Image Views will not work without this service.'); 
      Result := False;
      Exit;
    End;
    // need to get the VISN list
    Try
      //LogMsg('s', 'Retrieving sites in local VISN. ' + formatdatetime('mm/dd/yy@hh:nn:ss.zzz', now));
      magAppMsg('s', 'Retrieving sites in local VISN. ' + Formatdatetime('mm/dd/yy@hh:nn:ss.zzz', Now)); 
      VISNDetails := GetImagingExchangeSiteService().GetVISN(GetLocalSite().RegionId);

      SiteData := VISNDetails.Sites;
      Count := Length(SiteData);
      For i := 0 To Count - 1 Do
      Begin
        LocalVISNSites.Add(SiteData[i].SiteNumber);
      End;
    Except
      On e: Exception Do
      Begin
        //LogMsg('s','Exception getting local VISN, Exception=[' + e.Message + ']', magmsgerror);
        magAppMsg('s', 'Exception getting local VISN, Exception=[' +
          e.Message + ']', magmsgerror); 
         // do something here
      End;
    End;
  End;
  //LogMsg('s', 'Determining if Remote Site [' + SiteCode + '] is in local VISN.');
  magAppMsg('s', 'Determining if Remote Site [' + Sitecode + '] is in local VISN.'); 
  For i := 0 To LocalVISNSites.Count - 1 Do
  Begin
    If LocalVISNSites.Strings[i] = Sitecode Then
    Begin
      Result := True;
      Exit;
    End;
  End;
  Result := False;

  // THIS NEEDS TO BE TESTED!

End;

Function TMagRemoteBrokerManager.CreateBroker(Site: TVistaSite): Boolean;
//function TMagRemoteBrokerManager.CreateBroker(Server :String; Port:  integer; SiteName : String; SiteCode : String) : boolean;
Var
  i: Integer;
  Shares: TStrings;
  Server, SiteName, Sitecode: String;
  Port: Integer;
  UseViX: Boolean;
  SCode: String;
  VixServiceAvailable: Boolean;
  SkipOver: Boolean; {/ P117 NCAT - JK 12/21/2010 - used with DoD Auto-connect userpreference /}
Begin
  UseViX := False;
  Port := Site.VistaPort;
  Server := Site.VistaServer;
  Sitecode := Site.SiteNumber;
  SiteName := Site.SiteName;
  VixServiceAvailable := False;

  { JMW 5/13/08 P72t22
   do this stuff up here so not always checking for ViX unless actually
   creating a new broker
  }
  If BrokerCount >= BrokerMax Then
  Begin
    BrokerMax := BrokerMax + 10;
    SetLength(RemoteBrokerArray, BrokerMax);
  End;

  // need to do changes here since multiple sites will be on the same server/port (ViX to ViX)
  For i := 0 To BrokerCount - 1 Do
  Begin
    SCode := RemoteBrokerArray[i].GetSiteCode;
    If SCode = Sitecode Then
    Begin
      Result := True;
      If RemoteBrokerArray[i].GetServerStatus() = MagRemoteBroker.STATUS_CONNECTED Then
      Begin
        RemoteBrokerArray[i].SetPatientActive();
        //LogMsg('s', 'Already connected to Broker [' + SiteCode + '], no new connection requirred');
        magAppMsg('s', 'Already connected to Broker [' + Sitecode + '], no new connection required'); 
        RIVNotifyAllListeners(Self, 'SetActive', Sitecode);
      End
      Else
      Begin
        RIVNotifyAllListeners(Self, 'SetDisconnected', Sitecode);
        //LogMsg('s', 'Broker [' + SiteCode + '], has been disconnected, information will not be loaded from this site.');
        magAppMsg('s', 'Broker [' + Sitecode + '], has been disconnected, information will not be loaded from this site.'); 
      End;
      Exit;
    End;
  End;

  { JMW 5/13/08 P72t22 - Making a change to the broker manager:
    For T22 the client will only try to use the ViX for images from the DOD AND
    if the user has the key necessary to view DOD images. For all VA images
    the client will not try to use the ViX (Federation) because T22 is not ready
    for Federation. Even though the I5 ViX doesn't support Federation and never
    allows the client to get VA data the I6 ViX eventually will and there likely
    will still be T22 clients around for that so the client must not try to get
    VA data from the ViX at this time.  This logic will change when the client
    is properly able to handle VA data from the ViX
  }

  {
  // can't do anything with the ViX unless your local site has one
  if getLocalSite().isSiteVixEnabled() then
  begin
    // only talk to ViX for DOD data
    if site.isSiteDOD then
    begin
      // only if user has proper security key
      if (FAllowedDODSites) and (FUseWSBrokers) then
      begin
        useViX := true;
        port := getLocalSite().VixPort;
        Server := getLocalSite().VixServer;
      end
      else
      begin
        LogMsg('s','Requesting access to DOD site but user does not have required key to view DOD data', magmsginfo);
        useViX := false;
      end;
    end;
  end;
  }

  // put this back in once client is ready to talk to Federation, some changes
  // needed below to not require remote site to have a ViX
  If GetLocalSite().IsSiteVixEnabled() Then
  Begin
    //LogMsg('s', 'Local site has a VIX defined in the site service, will attempt to use', magmsginfo);
    magAppMsg('s', 'Local site has a VIX defined in the site service, will attempt to use', magmsginfo); 
    // right now checking to be sure the remote site has a ViX, this will go away
    // only will care if local site has a ViX (for Federation)
    //if (FUseWSBrokers) then
    // JMW 1/13/09 - if allowed to use WS brokers
    If (FUseWSBrokers) Then
    Begin
       // JMW 1/13/09 - check to see if the VIX service is available (VIX
      //LogMsg('s','Requesting list of interface versions available from local VIX at url ['
      //  + getLocalSite().getVixUrl() + ']', magmsginfo);
      magAppMsg('s', 'Requesting list of interface versions available from local VIX at url ['
        + GetLocalSite().GetVixUrl() + ']', magmsginfo); 
      VixServiceAvailable :=
        cMagRemoteWSBrokerFactory.IsImagingServiceAvailable(GetLocalSite().GetVixUrl());

      If VixServiceAvailable Then
      Begin
        //LogMsg('s', 'Local VIX has interface versions available, will attempt to use VIX', magmsginfo);
        magAppMsg('s', 'Local VIX has interface versions available, will attempt to use VIX', magmsginfo); 
        // if the site connecting to is the DOD and DOD sites are not allowed
        // then don't allow this connection
        If (Site.IsSiteDOD) And (Not FAllowedDODSites) Then
        Begin
          //LogMsg('s','Site is DOD but Allowed DOD Sites is false', magmsginfo);
          magAppMsg('s', 'Site is DOD but Allowed DOD Sites is false', magmsginfo); 
          UseViX := False;
        End
        Else
        Begin
          If (Not Site.IsSiteDOD) And (FBlockVixVASites) Then
          Begin
            // the remote site is NOT the DoD but VA sites are blocked from using VIX
            magAppMsg('s', 'Requested site [' + Site.SiteNumber + '] is VA and there is a local VIX, but access to local VIX for VA sites is not allowed, not using VIX.', magmsginfo);
            UseViX := False;
          End
          Else
          Begin
            // the remote site can use the ViX and its allowed for this site
            //LogMsg('s', 'Requested site [' + site.SiteNumber + '] will attempt to connect using the VIX', magmsginfo);
            magAppMsg('s', 'Requested site [' + Site.SiteNumber + '] will attempt to connect using the VIX', magmsginfo); 
            UseViX := True;
            Port := GetLocalSite().VixPort;
            Server := GetLocalSite().VixServer;
          End;
        End;
      End
      Else
      Begin
        //LogMsg('s', 'Cannot find appropriate interface version from VIX - cannot communicate with IDS on VIX to get acceptable version', magmsgwarn);
        magAppMsg('s', 'Cannot find appropriate interface version from VIX - cannot communicate with IDS on VIX to get acceptable version', magmsgwarn); 
      End;
    End;
  End;

    // if there is a ViX available that can be used
  If UseViX Then
  Begin
      // make a remote WS connection
      //LogMsg('s', 'Getting remote WS broker for site [' + site.SiteNumber + '], local VIX URL [' + getLocalSite().getVixUrl() + ']', magmsginfo);
    magAppMsg('s', 'Getting remote WS broker for site [' + Site.SiteNumber + '], local VIX URL [' + GetLocalSite().GetVixUrl() + ']', magmsginfo); 
    RemoteBrokerArray[BrokerCount] := cMagRemoteWSBrokerFactory.GetRemoteWSBroker(Site,
      GetLocalSite().GetVixUrl(), WorkstationID, FLocalBrokerPort,
      FSecurityTokenNeeded);
  End
    // if there is no ViX available but one is necessary to talk to this site
  Else
    If Site.SiteRequiresViX Then
    Begin
      // make a dummy broker connection (does nothing)
      //LogMsg('s','Site [' + site.SiteNumber + '] requires a ViX but none is available, creating dummy broker', magmsginfo);
      magAppMsg('s', 'Site [' + Site.SiteNumber + '] requires a ViX but none is available, creating dummy broker', magmsginfo); 
      RemoteBrokerArray[BrokerCount] := TMagRemoteDummyBroker.Create(Site);
    End
    Else // site does not require a ViX and no ViX is available
    Begin
      //LogMsg('s', 'No local VIX is available, but is not necessary for site [' + site.SiteNumber + '], creating RPC Broker', magmsginfo);
      magAppMsg('s', 'No local VIX is available, but is not necessary for site [' + Site.SiteNumber + '], creating RPC Broker', magmsginfo); 
      RemoteBrokerArray[BrokerCount] := TMagRemoteBroker.Create(Site.VistaServer,
        Site.VistaPort, Site.SiteName, Site.SiteNumber, Site, FLocalBrokerPort,
        FSecurityTokenNeeded, FLogCapriConnect, FApplicationType);
    End;

    //RemoteBrokerArray[BrokerCount].OnLogEvent := OnLogEvent;  
  RIVNotifyAllListeners(Self, 'AddSite', SiteName + '^' + Sitecode);
    // site should be added to toolbar here, then set active/inactive/disconected.  this doesnt actually put it on the toolbar (i think)

  {/ P117 NCAT - JK 12/21/2010 - needed for new DoD Auto-connect user preference. /}
  SkipOver := False;
  if ((Upref.RIVAutoConnectDoD = True) and
      (SiteCode = '200')) and
      (Upref.RIVAutoConnectEnabled = False) then
    SkipOver := True;

  if not SkipOver then begin

    If (Not CheckSiteAllowed(SiteName)) Or
       (Not Upref.RIVAutoConnectEnabled) Or
       (Server = '') Or
       (Port <= 0) Then
    Begin
      Result := False;
        // is this still necessary?
      RemoteBrokerArray[BrokerCount].SetServerDetails(Server, Port); // set the server details incase we want to connect later
      BrokerCount := BrokerCount + 1;
      RIVNotifyAllListeners(Self, 'AddDisconnected', Sitecode);
        //LogMsg('s', 'Broker [' + SiteCode + '] has been marked to NOT auto-connect to.');
      magAppMsg('s', 'Broker [' + Sitecode + '] has been marked to NOT auto-connect to.'); 
      Exit;
    End;

    If (Not Self.CheckSiteInVISN(Sitecode)) Then
    Begin
      {/ P117 NCAT - JK 12/16/2010 /}
      if (Upref.RIVAutoConnectDoD = True) and (SiteCode = '200') then
        {/ Do nothing in case the user wants the local Vista and the DoD to auto-connect /}
      else
      begin
        Result := False;
          // is this still necessary?
        RemoteBrokerArray[BrokerCount].SetServerDetails(Server, Port);
        BrokerCount := BrokerCount + 1;
        RIVNotifyAllListeners(Self, 'AddDisconnected', Sitecode);
          //LogMsg('s', 'Broker [' + SiteCode + '] will not auto-connect because it is not in your local VISN.');
        magAppMsg('s', 'Broker [' + Sitecode + '] will not auto-connect because it is not in your local VISN.'); 
        Exit;
      end;
    End;

    {/ P117 NCAT - JK 12/16/2010 - add in this section to mate with the new user preference for DoD auto-connect /}
    if (Upref.RIVAutoConnectDoD = False) and (SiteCode = '200') then
    begin
      Result := False;
      RemoteBrokerArray[BrokerCount].SetServerDetails(Server, Port);
      BrokerCount := BrokerCount + 1;
      RIVNotifyAllListeners(Self, 'AddDisconnected', Sitecode);
      magAppMsg('s', 'Broker [' + Sitecode + '], user preference for DoD is to not auto-connect.');
      Exit;
    end;
  end; {SkipOver}

  RIVNotifyAllListeners(Self, 'ConnectingRemote', SiteName);
    //LogMsg('s', 'Creating Connection to Broker [' + SiteCode + ']...');
  magAppMsg('s', 'Creating Connection to Broker [' + Sitecode + ']...'); 

  If Not RemoteBrokerArray[BrokerCount].Connect(UserFullName, UserLocalDUZ, UserSSN) Then
  Begin
      // if the connect failed but the remote broker is a ViX server, then we can try to use the old RPC broker method
    If (RemoteBrokerArray[BrokerCount].GetRemoteBrokerType() = MagRemoteWSBroker) Then
    Begin
        //LogMsg('s','Failed to connect to remote site [' + RemoteBrokerArray[BrokerCount].getServerDescription() + '] using ViX');
      magAppMsg('s', 'Failed to connect to remote site [' + RemoteBrokerArray[BrokerCount].GetServerDescription() + '] using ViX'); 
      If Site.SiteRequiresViX Then // the remote site needs a ViX, so we have no other way to access other than ViX
      Begin
          //LogMsg('s','Connection to remote site [' + RemoteBrokerArray[BrokerCount].getServerDescription() + '] failed, site requires VIX and cannot connect through other methods');
        magAppMsg('s', 'Connection to remote site [' + RemoteBrokerArray[BrokerCount].GetServerDescription() + '] failed, site requires VIX and cannot connect through other methods');
          
        Result := False;
        BrokerCount := BrokerCount + 1;
        RIVNotifyAllListeners(Self, 'AddDisconnected', Sitecode);
        Exit;
      End
      Else
      Begin
        Site := TVistaSite.Create(RemoteBrokerArray[BrokerCount].GetSite()); // necessary because the site that was passed to remote broker is about it be destroyed
          //LogMsg('s','Creating RPC broker to connect to site [' + site.SiteNumber + '] since VIX failed', magmsginfo);
        magAppMsg('s', 'Creating RPC broker to connect to site [' + Site.SiteNumber + '] since VIX failed', magmsginfo); 
        RemoteBrokerArray[BrokerCount] := Nil; // not sure if this is good - don't know how we can free this though...
        RemoteBrokerArray[BrokerCount] := TMagRemoteBroker.Create(Site.VistaServer,
          Site.VistaPort, Site.SiteName, Site.SiteNumber, Site,
          FLocalBrokerPort, FSecurityTokenNeeded, FLogCapriConnect, FApplicationType);
          //RemoteBrokerArray[BrokerCount].OnLogEvent := OnLogEvent; 
        If Not RemoteBrokerArray[BrokerCount].Connect(UserFullName, UserLocalDUZ, UserSSN) Then
        Begin // now the rpc broker connection failed, can no longer continue
            //LogMsg('s','Second attempt to connect to remote site [' + RemoteBrokerArray[BrokerCount].getServerDescription() + '] now through rpc broker failed');
          magAppMsg('s', 'Second attempt to connect to remote site [' + RemoteBrokerArray[BrokerCount].GetServerDescription() + '] now through rpc broker failed');
            
          Result := False;
          BrokerCount := BrokerCount + 1;
          RIVNotifyAllListeners(Self, 'AddDisconnected', Sitecode);
          Exit;
        End;
      End;
    End
    Else // remote connection is not to ViX, connection failed so nothing we can do here
    Begin
        //LogMsg('s', 'Failed to connect to remote site [' + SiteCode + '], already using RPC broker, cannot do anything else', magmsgerror);
      magAppMsg('s', 'Failed to connect to remote site [' + Sitecode + '], already using RPC broker, cannot do anything else', magmsgerror); 
      Result := False;
      BrokerCount := BrokerCount + 1;
      RIVNotifyAllListeners(Self, 'AddDisconnected', Sitecode);
      Exit;
    End;

  End;

    // right here can do the version check, if it fails we don't need the network connections.
  If Not RemoteBrokerArray[BrokerCount].CheckRemoteImagingVersion Then
  Begin
    RemoteBrokerArray[BrokerCount].Disconnect(); // set this broker disconnected
    Result := False;
    BrokerCount := BrokerCount + 1;
    RIVNotifyAllListeners(Self, 'AddDisconnected', Sitecode);
    Exit;
  End;
    // create the session on the remote site
  RemoteBrokerArray[BrokerCount].CreateSession(ApplicationPath, ApplicationEXEName, '', WorkstationComputerName, WorkstationLocation, LastMagUpdate, Startmode);

  RIVNotifyAllListeners(Self, 'AddActive', Sitecode);

  Shares := Tstringlist.Create();
  RemoteBrokerArray[BrokerCount].SetWorkstationID(WorkstationID); // needed to get the site parameters
  RemoteBrokerArray[BrokerCount].GetNetworkLocations(Shares);

  idmodobj.GetMagFileSecurity.ShareList.AddStrings(Shares);
  FreeAndNil(Shares);
  Result := True;
  //LogMsg('s', 'Connection to Broker [' + SiteCode + '] Created');
  magAppMsg('s', 'Connection to Broker [' + Sitecode + '] Created'); 
  BrokerCount := BrokerCount + 1;
End;

Function ParseSiteCode(Input: String): String;
Var
  i: Integer;
  Abbr, Res: String;
  OrdValue: Integer;
Begin
  Abbr := Uppercase(Input);
  Res := '';
  // 48-57
  For i := 1 To Length(Abbr) Do
  Begin
    OrdValue := Ord(Abbr[i]);
    // 48-57 are numbers
    // 9/9/2005 p45t8 Fix bug with Station Numbers that end with numbers after letters
    If (OrdValue < 48) Or (OrdValue > 57) Then
    Begin

      If Res <> '' Then
      Begin
        Result := Res;
        Exit;
      End;
    End
    Else
    Begin
      Res := Res + Abbr[i];
    End;
    {
    if (ordValue > 47) and (ordValue < 58) then
    begin
      res := res + abbr[i];
    end;
    }
  End;
  Result := Res;
End;

Procedure ConvertTreatingFacilityList(InputData: TStrings; Var TreatingList: Tstringlist);
Var
  SiteCount, i: Integer;
  SiteDetails: String;
  Sitecode, SiteName, Part3, Part4: String;
Begin
  // JMW 1/19/2012 P122 - now calling MAGJ GET TREATING LIST rpc which
  // puts the results into a list
  TreatingList := Tstringlist.Create();
  // skip the first line - its a header line
  For i := 1 To InputData.Count - 1 Do
    Begin
      SiteDetails := InputData.Strings[i];
      SiteDetails := ConvertTreatingFacilitySite(SiteDetails);
      if SiteDetails <> '' then
        TreatingList.Add(SiteDetails);
    End;
    TreatingList.Sorted := True;
  End;

{/ P122 Julian Werfel. Remedy ticket number HD0000000529824
  Checks the site details for a single site to see if it is valid.  If the site
  number contains 200 then check to be sure it is exactly 200 to include in
  the result.  If not exactly 200 then exclude. If some other site number then
  clean up the site number (remove extract characters that might not exist
  in the site service).
  P122 JMW 1/19/2012
  See comments below
}
Function ConvertTreatingFacilitySite(SiteDetails : String) : String;
var
  siteCode : String;
  siteName, part3, part4 : String;
begin
  result := '';
  siteCode := MagPiece(SiteDetails, '^', 1);
  siteName := MagPiece(SiteDetails, '^', 2);
  part3 := MagPiece(SiteDetails, '^', 3);
  part4 := MagPiece(SiteDetails, '^', 4);
  // if 200 is in the site number
  if pos('200', siteCode) > 0 then
  begin
    // if and only if the site number is exactly 200
    // JMW 1/19/2012 p122 - if and only if site code is 200 or 200DOD do we include
    // it for the DoD, otherwise throw it away (for 200 sites)
    if (siteCode = '200') or (siteCode = '200DOD') then
    begin
      // include this site, otherwise exclude it
      // updating the site name
      siteName := 'DOD';
      siteCode := '200'; // clean up the site code in case it was 200DOD
    end
    else
    begin
      // don't include this one - exclude it, it won't show up to the user at all
      exit;
    end;
  end
  else
  begin
    // not a 200 site, clean up the site number to remove extra characters 
    siteCode := ParseSiteCode(siteCode);
  end;
  result := Sitecode + '^' + SiteName + '^' + Part3 + '^' + Part4 + '^';
end;

//procedure TMagRemoteBrokerManager.checkPatientSensitive(var RemoteAccess : Array of TRemoteSensitiveData);

Procedure TMagRemoteBrokerManager.CheckPatientSensitive();
Var
  i: Integer;
  Xmsg: String;
  ActiveRemoteSites: Integer;
  RemoteAccessSiteInfo: Tlist; // Array of TRemoteSensitiveData;
  RemoteSiteInfo: TRemoteSensitiveData;
  RemoteCode: Integer;
  RemoteMsg: Tstringlist;
  CancelAllRemaining: Boolean;
Begin
 //46 put in -> if self.NewPatientSelected then
  If Self.NewPatientSelected Then
  Begin
    //LogMsg('s', 'MagRemoteBrokerManager - a new patient has been selected, will not check patient sensitive at remote sites. Setting all remote sites to PATIENT_INACTIVE');
    magAppMsg('s', 'MagRemoteBrokerManager - a new patient has been selected, will not check patient sensitive at remote sites. ' +
      'Setting all remote sites to PATIENT_INACTIVE'); 
    For i := 0 To BrokerCount - 1 Do
    Begin
      If RemoteBrokerArray[i].GetPatientStatus = STATUS_PATIENTACTIVE Then
      Begin
        RemoteBrokerArray[i].SetPatientInactive();
        RIVNotifyAllListeners(Self, 'SetInactive', RemoteBrokerArray[i].GetSiteCode());
        Xmsg := 'Access to this site is cancelled because new patient was selected';
      End;
    End;
    Exit;
  End;
  RemoteAccessSiteInfo := Tlist.Create(); // TStringList.Create();
  // create array in size of active remote brokers for this patient
  ActiveRemoteSites := GetPatientActiveBrokerCount();
//  setLength(RemoteAccessSiteInfo, ActiveRemoteSites);
  CancelAllRemaining := False;
  For i := 0 To BrokerCount - 1 Do
  Begin {1}
    If RemoteBrokerArray[i].GetPatientStatus = STATUS_PATIENTACTIVE Then
    Begin {2}
    //46 put in -> if self.NewPatientSelected then
      If Self.NewPatientSelected Then
      Begin
        //LogMsg('s', 'MagRemoteBrokerManager - a new patient has been selected, will not check patient sensitive at remote sites. Setting all remote sites to PATIENT_INACTIVE');
        magAppMsg('s', 'MagRemoteBrokerManager - a new patient has been selected, will not check patient sensitive at remote sites. ' +
          'Setting all remote sites to PATIENT_INACTIVE'); 
        RemoteBrokerArray[i].SetPatientInactive();
        RIVNotifyAllListeners(Self, 'SetInactive', RemoteBrokerArray[i].GetSiteCode());
        Xmsg := 'Access to this site is cancelled because new patient was selected';
      End
      Else
      Begin {3}

        RemoteSiteInfo := TRemoteSensitiveData.Create();
        RemoteBrokerArray[i].CheckSensitiveAccess(RemoteCode, RemoteMsg);

        // JMW 6/2/09 P93T8
        // if the sensitivity level at the remote site is higher than the
        // local site, then ask the user if they want to continue

        // if remote site is level 3, will always be higher than
        // FCurrentPatientSensitiveLevel because 3 is never assigned
          //LogMsg('s', 'Remote sensitive code of [' + inttostr(remotecode)
          //  + '] current sensitive code is  [' +
          //  inttostr(FCurrentPatientSensitiveLevel) + ']', magmsginfo);
        magAppMsg('s', 'Remote sensitive code of [' + Inttostr(RemoteCode)
          + '] current sensitive code is  [' +
          Inttostr(FCurrentPatientSensitiveLevel) + ']', magmsginfo); 

        Case RemoteCode Of {5}
          -1:
            Begin
              Xmsg := RemoteMsg[0];
            End;
          0:
            Begin
              Xmsg := 'Access is Allowed';
            End;
          1:
            Begin
              If RemoteCode > FCurrentPatientSensitiveLevel Then
              Begin
                (*       frmPatAccess just displays the warning message*)
                FrmPatAccess.Execute(Self, RemoteMsg, 1, CancelAllRemaining, RemoteBrokerArray[i].GetSiteName());
              End;
              Xmsg := 'Access to this restricted patient has been logged.';
              If FCurrentPatientSensitiveLevel < 1 Then
                FCurrentPatientSensitiveLevel := 1;
            End;

          2:
            Begin
              If RemoteCode > FCurrentPatientSensitiveLevel Then
              Begin
                If CancelAllRemaining Or
                  (Not FrmPatAccess.Execute(Self, RemoteMsg, 2,
                  CancelAllRemaining, RemoteBrokerArray[i].GetSiteName())) Then
                Begin
                  Xmsg := 'User has Canceled access to the patient.';
                  RemoteBrokerArray[i].SetPatientInactive();
                  RIVNotifyAllListeners(Self, 'SetInactive', RemoteBrokerArray[i].GetSiteCode());
                  //LogMsg('s', 'User has chosen not to view restricted patient @ ' + RemoteBrokerArray[i].getSiteName);
                  magAppMsg('s', 'User has chosen not to view restricted patient @ ' + RemoteBrokerArray[i].GetSiteName); 
                End
                Else
                Begin
                  Xmsg := 'Access to this restricted patient has been logged.';
                  //LogMsg('s', 'User has chosen to view restricted patient @ ' + RemoteBrokerArray[i].getSiteName);
                  magAppMsg('s', 'User has chosen to view restricted patient @ ' + RemoteBrokerArray[i].GetSiteName); 
                  RemoteBrokerArray[i].LogRestrictedAccess();
                  If FCurrentPatientSensitiveLevel < 2 Then
                    FCurrentPatientSensitiveLevel := 2;
                End;
              End
              Else
              Begin
                Xmsg := 'User already agreed to current level, access to this restricted patient has been logged.';
                RemoteBrokerArray[i].LogRestrictedAccess();
              End;
            End;

          3:
            Begin
              // if the user has cancelled all remaining restricted sites, then don't display anything, just disable them
              If Not CancelAllRemaining Then
              Begin
                FrmPatAccess.Execute(Self, RemoteMsg, 3, CancelAllRemaining,
                  RemoteBrokerArray[i].GetSiteName());
              End;
              RemoteBrokerArray[i].SetPatientInactive();
              RIVNotifyAllListeners(Self, 'SetInactive', RemoteBrokerArray[i].GetSiteCode());
              Xmsg := 'Access to this restricted patient is Not Allowed';
              //LogMsg('s', 'Access to this patient @ [' + RemoteBrokerArray[i].getSiteName + '] is not allowed.');
              magAppMsg('s', 'Access to this patient @ [' + RemoteBrokerArray[i].GetSiteName + '] is not allowed.'); 
            End;
        End; (*CASE *) {5}

      End; // else {3}
    End; // if RemoteBrokerArray[i].getPatientStatus = STATUS_PATIENTACTIVE then  {2}
  End; // for i := 0 to BrokerCount - 1 do {1}
End; //

Function TMagRemoteBrokerManager.GetPatientActiveBrokerCount(): Integer;
Var
  i: Integer;
  Count: Integer;
Begin
  Count := 0;
  For i := 0 To BrokerCount - 1 Do
  Begin
    If RemoteBrokerArray[i].GetPatientStatus() = MagRemoteBroker.STATUS_PATIENTACTIVE Then
    Begin
      Count := Count + 1;
    End;
  End;
  Result := Count;
End;

Function IsMergeColumnHeadersNeeded(RowHeader1, RowHeader2: String): Boolean;
Begin
  If MagUtilities.Maglength(RowHeader1, '^') <> MagUtilities.Maglength(RowHeader2, '^') Then
  Begin
    Result := True;
    Exit;
  End;
  Result := False;
End;

// RowList1 is the current list of images, the first row of the list is the column headers
// RowList2 is the new list of images, the first row is the column headers for this information

Procedure MergeColumnHeaders(Var RowList1: TStrings; Var RowList2: TStrings);
Var
  Row1Length, Row2Length: Integer;
  i: Integer;
  Row1, Row2, Value1, Value2: String;
  SmallRowLength, SmallRow: Integer;
  RowLengthDifference: Integer;
Begin
  Row1 := RowList1.Strings[0];
  Row2 := RowList2.Strings[0];
  Row1Length := MagUtilities.Maglength(Row1, '^');
  Row2Length := MagUtilities.Maglength(Row2, '^');

  SmallRowLength := Row2Length;
  SmallRow := 2;
  If Row1Length < Row2Length Then
  Begin
    SmallRowLength := Row1Length;
    SmallRow := 1;
  End;

  For i := 1 To SmallRowLength Do
  Begin
    Value1 := MagUtilities.MagPiece(MagUtilities.MagPiece(Row1, '^', i), '~', 1);
    Value2 := MagUtilities.MagPiece(MagUtilities.MagPiece(Row2, '^', i), '~', 1);
    If Uppercase(Value1) <> Uppercase(Value2) Then
    Begin
      If SmallRow = 1 Then
      Begin
        InsertColumn(Value2, i, RowList1);
        Row1 := RowList1.Strings[0];
        Row1Length := Row1Length + 1;
      End
      Else
      Begin
        InsertColumn(Value1, i, RowList2);
        Row2 := RowList2.Strings[0];
        Row2Length := Row2Length + 1;
      End;
      SmallRowLength := SmallRowLength + 1;
    End;
  End;

  If Row1Length > Row2Length Then
  Begin
    RowLengthDifference := Row1Length - Row2Length;

    For i := Row2Length + 1 To Row1Length Do
    Begin
      Value1 := MagUtilities.MagPiece(Row1, '^', i);
      InsertColumn(Value1, i, RowList2);
    End;

  End
  Else
    If Row2Length > Row1Length Then
    Begin
      RowLengthDifference := Row2Length - Row1Length;
      For i := Row1Length + 1 To Row2Length Do
      Begin
        Value2 := MagUtilities.MagPiece(Row2, '^', i);
        InsertColumn(Value2, i, RowList1);
      End;
    End;

End;

Procedure InsertColumn(ColumnHeader: String; ColumnLocation: Integer; Var ImageList: TStrings);
Var
  i: Integer;
  piece1, piece2: String;
  Res: String;
Begin
  If ImageList = Nil Then Exit;
  If ImageList.Count = 0 Then Exit;
  ImageList.Strings[0] := MagUtilities.MagInsertPiece(ImageList.Strings[0], '^', ColumnLocation, ColumnHeader);
  For i := 1 To ImageList.Count - 1 Do
  Begin
    // JMW 6/11/2009 P93 - put in fix to handle adding new columns at the
    // end of the data set.  Need to seperate pieces of data divided by the
    // | character and only put new column on first part of | character.
    piece2 := '';
    piece1 := MagPiece(ImageList.Strings[i], '|', 1);
    piece2 := MagPiece(ImageList.Strings[i], '|', 2);
    Res := MagUtilities.MagInsertPiece(piece1, '^', ColumnLocation, ' ');
    If piece2 <> '' Then
      ImageList.Strings[i] := Res + '|' + piece2
    Else
      ImageList.Strings[i] := Res;
  End;
End;

{Future use, do all of the brokers in here and the merge the information into 1 remote list of studies}
 {7/12/12 gek Merge 130->129}
{/ P117 NCAT - JK 11/30/2010 /}
{/ P130 JK - 6/25/2012 added ShowDeletedImages: Boolean parameter /}

Function TMagRemoteBrokerManager.GetPatientStudies(Pkg, Cls, Types, Event, Spc, FrDate, ToDate, Origin: String;
                                                   ShowDeletedImages: Boolean;
                                                   Var Results: TStrings; Var Partial_Returned: Boolean; Var Partial_Msg: String): Boolean;
Var
  i: Integer;
  Broker: IMagRemoteBroker;
Begin
  For i := 0 To BrokerCount - 1 Do
  Begin
    Broker := RemoteBrokerArray[i];
    If (IsRemoteBrokerActive(i)) And (Broker.GetImageCount() > 0) Then
    Begin

    End;
  End;

  Result := True;
End;

Function TMagRemoteBrokerManager.GetImagingExchangeSiteService(): ImagingExchangeSiteServiceSoap;
Var
  ExchangeSiteServiceURL: String;
  Loc: Integer;
Begin
  Result := Nil;
  If (SiteServiceURL = '') Or (Not RIVEnabled) Then
    Exit;
  If ExchangeSiteService = Nil Then
  Begin
    Try
      ExchangeSiteServiceURL := SiteServiceURL;
      Loc := LastDelimiter('/', ExchangeSiteServiceURL);
      ExchangeSiteServiceURL := Copy(ExchangeSiteServiceURL, 0, Loc) + 'ImagingExchangeSiteService.asmx';
      //LogMsg('s','Getting ImagingExchangeSiteService, URL [' + ExchangeSiteServiceURL + ']');
      magAppMsg('s', 'Getting ImagingExchangeSiteService, URL [' + ExchangeSiteServiceURL + ']'); 
      ExchangeSiteService := GetImagingExchangeSiteServiceSoap(False, ExchangeSiteServiceURL, Nil);
    Except
      On e: Exception Do
      Begin
        //LogMsg('s','Exception getting site service proxy, URL [' + ExchangeSiteServiceURL + '], Exception [' + e.Message + ']');
        magAppMsg('s', 'Exception getting site service proxy, URL [' + ExchangeSiteServiceURL + '], Exception [' + e.Message + ']'); 
        ExchangeSiteService := Nil;
        Result := Nil;
        Exit;
      End;
    End;
  End;
  Result := ExchangeSiteService;
End;

Function TMagRemoteBrokerManager.GetLocalSiteCode(): String;
Begin
  If FLocalSiteCode = '' Then
  Begin
    // JMW P93 4/21/2009 - should be using Primary Site Station number, not DUZ(2)
    FLocalSiteCode := PrimarySiteStationNumber;
  End;
  Result := FLocalSiteCode;
End;

Function ConvertExchangeSiteToVistaSite(Site: ImagingExchangeSiteTO; returnNilForFault: Boolean = False): TVistaSite;
Begin
  If Site = Nil Then
  Begin
    Result := Nil;
    Exit;
  End;

  If (Site.FaultTO <> Nil) And (returnNilForFault) Then
  Begin

        { TODO : 
since this Functino isn't part of TMagRemoteBroker  it doesn't see magAppMsg.
. }
 //RCA  OUT Temp     magAppMsg('s', 'Site [' + Site.SiteNumber + '] returned from site service with error [' + Site.FaultTO.message_ + ']', magmsgerror);
    Result := Nil;
    Exit;
  End;

  Result := TVistaSite.Create();
  Result.SiteNumber := Site.SiteNumber;
  Result.SiteName := Site.SiteName;
  Result.SiteAbbr := Site.SiteAbbr;
  Result.RegionId := Site.RegionId;
  Result.VistaServer := Site.VistaServer;
  Result.VistaPort := Site.VistaPort;
  Result.VixServer := Site.AcceleratorServer;
  Result.VixPort := Site.AcceleratorPort;
End;

Function TMagRemoteBrokerManager.GetLocalSite(): TVistaSite;
Var
  SiteService: ImagingExchangeSiteServiceSoap;
  SNumber: String;
Begin
  If FLocalSite = Nil Then
  Begin

    If DemoRemoteSites Then
    Begin
      FLocalSite := GetDemoLocalSite();
      CheckOverrideLocalVix();
    End
    Else
    Begin
      SiteService := GetImagingExchangeSiteService();
      If SiteService <> Nil Then
      Begin
        // JMW 1/22/2010 - first try the local user station number to get the
        // local site information (for consolidated sites)
        SNumber := LocalUserStationNumber; // getLocalSiteCode();
        Try
          magAppMsg('s', 'Finding local site information from site service with local site number [' + SNumber + ']', magmsginfo);
          FLocalSite := ConvertExchangeSiteToVistaSite(SiteService.GetSite(SNumber), True);
          If FLocalSite = Nil Then
          Begin
            // if FLocalSite is nil then couldn't find a site in the site service with user station number
            // retry using primary site station number
            SNumber := PrimarySiteStationNumber; // getLocalSiteCode();
            magAppMsg('s', 'Got nil local site from site service, indicates local site number not in site service, trying again with primary site station number  [' + SNumber + ']',
              magmsginfo);
            FLocalSite := ConvertExchangeSiteToVistaSite(SiteService.GetSite(SNumber));
          End;
          CheckOverrideLocalVix();
        Except
          On e: Exception Do
          Begin
            FLocalSite := TVistaSite.Create();
            FLocalSite.SiteNumber := SNumber;
            //LogMsg('s','Exception getting local site, [' + e.Message + ']', magmsgerror);
            magAppMsg('s', 'Exception getting local site, [' + e.Message + ']', magmsgerror); 
            CheckOverrideLocalVix(); // not sure if the override should be done in this error situation...
          End;
        End;
      End
      Else // if site service is not available (not sure why...)
      Begin
        FLocalSite := TVistaSite.Create();
        FLocalSite.SiteNumber := SNumber;
        //LogMsg('s','Site service not found - null', magmsgerror);
        magAppMsg('s', 'Site service not found - null', magmsgerror); 
        CheckOverrideLocalVix(); // not sure if the override should be done in this error situation...
      End;
    End;
    If FLocalSite <> Nil Then
      magAppMsg('s', 'Local site set to site [' + FLocalSite.SiteNumber + ']', magmsginfo);
  End;
  Result := FLocalSite;
End;

Procedure TMagRemoteBrokerManager.CheckOverrideLocalVix();
Begin
  If FLocalSite = Nil Then Exit;
  If LocalVixServerOverride <> '' Then
  Begin
    FLocalSite.VixServer := LocalVixServerOverride;
    //LogMsg('s','Overriding local VIX Server from Site Service with [' + LocalVixServerOverride + ']', magmsginfo);
    magAppMsg('s', 'Overriding local VIX Server from Site Service with [' + LocalVixServerOverride + ']', magmsginfo); 
  End;
  If LocalVixPortOverride > 0 Then
  Begin
    FLocalSite.VixPort := LocalVixPortOverride;
    //LogMsg('s','Overriding local VIX Port from Site Service with [' + inttostr(LocalVixPortOverride) + ']', magmsginfo);
    magAppMsg('s', 'Overriding local VIX Port from Site Service with [' + Inttostr(LocalVixPortOverride) + ']', magmsginfo); 
  End;
End;

Function TMagRemoteBrokerManager.GetDemoLocalSite(): TVistaSite;
Var
  SiteData: ArrayOfImagingExchangeSiteTO;
  SNumber: String;
Begin
  SNumber := GetLocalSiteCode();
  If Not GetDemoSites(SNumber, SiteData) Then
  Begin
    Result := TVistaSite.Create();
    Result.SiteNumber := SNumber;
    //LogMsg('s','Could not find local site in demosites files', magmsgerror);
    magAppMsg('s', 'Could not find local site in demosites files', magmsgerror); 
  End
  Else
  Begin
    Try
      Result := ConvertExchangeSiteToVistaSite(SiteData[0]);
    Except
      On e: Exception Do
      Begin
        Result := TVistaSite.Create();
        Result.SiteNumber := SNumber;
        //LogMsg('s','Could not find local site in demosites files, Exception=[' + e.Message + ']', magmsgerror);
        magAppMsg('s', 'Could not find local site in demosites files, Exception=[' + e.Message + ']', magmsgerror);
      End;
    End;
  End;

End;

Procedure TMagRemoteBrokerManager.KeepBrokersAlive(Enabled: Boolean);
Var
  i: Integer;
Begin
  FKeepBrokersAlive := Enabled;
  For i := 0 To BrokerCount - 1 Do
  Begin
    // must check this for each connected RPC broker
    If RemoteBrokerArray[i].GetServerStatus = STATUS_CONNECTED Then
    Begin
      // only need to keep RPC brokers alive
      If RemoteBrokerArray[i].GetRemoteBrokerType() = MagRemoteRPCBroker Then
      Begin
        RemoteBrokerArray[i].KeepBrokerAlive(FKeepBrokersAlive);
      End;
    End;
  End;
End;

End.
