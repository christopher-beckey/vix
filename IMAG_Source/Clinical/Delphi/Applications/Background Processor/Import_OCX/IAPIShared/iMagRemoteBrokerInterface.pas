{
  Package: MAG - VistA Imaging
  WARNING: Per VHA Directive 2004-038, this routine should not be modified.
  Date Created: January, 2007
  Site Name:  Washington OI Field Office, Silver Spring, MD
  Developer:  Julian Werfel
  Description:
    Base interface for Remote Broker connections.

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
Unit IMagRemoteBrokerInterface;

Interface

Uses
  Classes,
  //cMagLogManager, {JK 10/5/2009 - Maggmsgu refactoring - deprecated unit}
  UMagClasses
  ;

Type
  TMagRemoteBrokerType = (MagRemoteRPCBroker, MagRemoteWSBroker);

{
  This is the response when requesting the list of studies. It is either
  successful, had an exception or there was a socket timeout exception. The
  socket timeout occurs when the ViX times out waiting for the DOD to respond
  to a patient study graph request. This allows the client to present
  different text on the toolbar indicating the error was a timeout and the user
  could try again to possibly retrieve data.
}
Type
  TMagPatientStudyResponse = (MagStudyResponseOk, MagStudyResponseException, MagStudyResponseTimeout);

Type
  IMagRemoteBroker = Interface(IInterface)

  {Constructor to create each remote broker object }
//  constructor Create(Server : String; Port : integer; SiteName : String; SiteCode : String);

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

  {}
    Function GetPatientStudies(Pkg, Cls, Types, Event, Spc, FrDate,
      ToDate, Origin: String; Var Results: TStrings; Var Partial_Returned: Boolean; Var Partial_Msg: String): TMagPatientStudyResponse; {/ P117 NCAT - JK 11/30/2010 /}
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

  //procedure setLogEvent(LogEvent : TMagLogEvent);  {JK 10/5/2009 - Maggmsgu refactoring - remove old method}
  //function getLogEvent() : TMagLogEvent;  {JK 10/5/2009 - Maggmsgu refactoring - remove old method}
    Function GetRemoteUserDUZ(): String;

  //property OnLogEvent : TMagLogEvent read getLogEvent write setLogEvent;  {JK 10/5/2009 - Maggmsgu refactoring - remove old method}
    Property RemoteUserDUZ: String Read GetRemoteUserDUZ;

    Function IsBrokerLateCountUpdate(): Boolean; // indicates if the broker gets the study count late

    Function GetRemoteBrokerType(): TMagRemoteBrokerType; // determines what type of broker this is, RPC or WS
    Function GetSite(): TVistaSite;

    Procedure KeepBrokerAlive(Enabled: Boolean);

    Procedure RPMagTeleReaderUnreadlistGet(Var t: TStrings;
      AcquisitionPrimaryDivision, Sitecode, SpecialtyCode, ProcedureStrings,
      LastUpdate, UserDUZ, LocalSiteCode, SiteTimeOut, StatusOptions: String);
    Procedure RPMagTeleReaderUnreadlistLock(Var Xmsg: String;
      AcquisitionPrimaryDivision, AcquisitionSiteCode, ItemID, LockUnlockValue,
      UserFullName, UserInitials, LocalDUZ, LocalSiteCode: String);

  End;

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

End.
