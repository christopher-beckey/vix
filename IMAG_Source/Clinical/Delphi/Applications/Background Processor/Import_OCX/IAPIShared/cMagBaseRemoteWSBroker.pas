{
  Package: MAG - VistA Imaging
  WARNING: Per VHA Directive 2004-038, this routine should not be modified.
  Date Created: November 30, 2009
  Site Name:  Washington OI Field Office, Silver Spring, MD
  Developer:  Julian Werfel
  Description:
    Base web service broker. This is an abstract implementation of the
    iMagRemoteBroker interface that contains base functions for Web service
    brokers connecting to the VIX.  This is simply a convinience object that
    contains functionality common to all WS brokers and not specific to any
    version.

    Currently only TMagRemoteWSBrokerV4 and TMagRemoteWSBrokerV5 derive from
    this object.

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
Unit cMagBaseRemoteWSBroker;

Interface

Uses
  IMagRemoteBrokerInterface,
  Classes,
  UMagClasses,
  InvokeRegistry;

Type
  TMagStudyItem = Class
  Public
    FStudyId: String;
    FStudyDetails: String;
  End;

{This type defines the interface for generic procedures that make web service
  calls.  All wrapper methods must have this same method signature.}
  TMagRemoteWSBrokerWrapper = Procedure(Input: TRemotable; Var Response: TRemotable) Of Object;

  TMagBaseRemoteWSBroker = Class(TInterfacedObject, IMagRemoteBroker)

  Protected
    FPatientICN: String;
    FPatientICNWithChecksum: String;
    FServerStatus: Integer;
    FPatientStatus: Integer;
    FUserFullname: String;
    FUserDUZ: String;
    FUserSSN: String;

    FSite: TVistaSite;

    FStudyList: Tlist;

    FLocalViXURL: String;
    FImagingService: TMagImagingService;

    FWorkstationID: String;
    FLocalBrokerPort: Integer;
    FSecurityTokenNeeded: TMagSecurityTokenNeededEvent;

    { Stores the number of studies for this patient at this remote site (-1) for DOD}
    FImageCount: Integer;

    Function CreateTransactionId(): String;
    Function CreateImageUrlString(BaseImgURL: String; ImageURI: String): String;
    Procedure SetTextStr(Const Text: String; Var Output: TStrings); Overload;
    Procedure SetTextStr(Const Text: String; Var Output: Tstringlist); Overload;

  Public
    {virtual, abstract methods}
    {Connect this remote site}
    Function Connect(UserFullName: String; UserLocalDUZ: String; UserSSN: String): Boolean; Virtual; Abstract;

    Function GetPatientStudies(Pkg, Cls, Types, Event, Spc, FrDate,
      ToDate, Origin: String; Var Results: TStrings; Var Partial_Returned: Boolean; Var Partial_Msg: String): TMagPatientStudyResponse; Virtual; Abstract;  {/ P117 NCAT - JK 11/30/2010 /}
    Procedure GetImageGlobalLookup(Ien: String; Var Rlist: TStrings); Virtual; Abstract;
    Procedure GetMagDevFields(Ien, Flags: String; Var Output: Tstringlist); Virtual; Abstract;
    Procedure LogCopyAccess(IObj: TImageData; Msg: String;
      EventType: TMagImageAccessEventType); Virtual; Abstract;
    Procedure GetImageInformation(IObj: TImageData; Var Output: TStrings); Virtual; Abstract;
    Function Getreport(IObj: TImageData): TStrings; Virtual; Abstract;
    Procedure LogOfflineImageAccess(IObj: TImageData); Virtual; Abstract;
    Procedure LogAction(Msg: String); Virtual; Abstract;
    Function QueImage(ImgType: String; IObj: TImageData): TStrings; Virtual; Abstract;
    Function QueImageGroup(Images: String; IObj: TImageData): String; Virtual; Abstract;
    Procedure GetImageGroup(IObj: TImageData; NoQAcheck: Boolean; Output: TStrings); Virtual; Abstract;

    Procedure RPMagTeleReaderUnreadlistGet(Var t: TStrings;
      AcquisitionPrimaryDivision, Sitecode, SpecialtyCode, ProcedureStrings,
      LastUpdate, UserDUZ, LocalSiteCode, SiteTimeOut, StatusOptions: String); Virtual; Abstract;
    Procedure RPMagTeleReaderUnreadlistLock(Var Xmsg: String;
      AcquisitionPrimaryDivision, AcquisitionSiteCode, ItemID, LockUnlockValue,
      UserFullName, UserInitials, LocalDUZ, LocalSiteCode: String); Virtual; Abstract;

    { methods implemented here, not virual or abstract}
    {Set the patient's remote DFN based on the Patients ICN }
    Function SetPatientDFN(PatientICN: String): Boolean;
    {Retrieve the number of images the patient has at the remote site}
    Function CountImages(): Integer;
    Procedure KeepBrokerAlive(Enabled: Boolean);

    Function GetSite(): TVistaSite;
    {indicates if the broker gets the study count late}
    Function IsBrokerLateCountUpdate(): Boolean;
    {determines what type of broker this is, RPC or WS}
    Function GetRemoteBrokerType(): TMagRemoteBrokerType;
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
    Procedure CreateSession(AppPath, DispAppName, CapAppName,
      Compname, Location, LastUpdate: String; Startmode: Integer);
    {ReOpen an old connection to a remote site}
    Function ReOpenConnection(UserFullName, UserLocalDUZ, UserSSN: String): Boolean; // this is used if the broker was already created but it was closed or there was an error.
    { this function is used for setting the server details without using the connect function (happens if the server is not to be connected to.)}
    Procedure SetServerDetails(Server: String; Port: Integer);
    {Check if the patient is sensitive at the remote site}
    Procedure CheckSensitiveAccess(Var SensitveCode: Integer; Var Msg: Tstringlist);
    {Log access to a restricted remote site for the selected patient}
    Procedure LogRestrictedAccess();
    {Describes the server, Server and port for a rpcBroker}
    Function GetServerDescription(): String;

    Function GetRemoteUserDUZ(): String;
  End;

Implementation

Uses
  SysUtils,
  Umagutils8;

Function TMagBaseRemoteWSBroker.CreateTransactionId(): String;
Var
  Guid: TGuid;
Begin
  CreateGUID(Guid);
  Result := GUIDToString(Guid);
End;

Function TMagBaseRemoteWSBroker.CreateImageUrlString(BaseImgURL: String; ImageURI: String): String;
Begin
  If ImageURI = '' Then
  Begin
    Result := '';
    Exit;
  End;

  {/ P117 NCAT - JK 12/21/2010 - added the check for '.\' /}
  If (MagPiece(ImageURI, '~', 1) = '-1') or (MagPiece(ImageURI, '~', 1) = '.\') Then
  Begin
    Result := ImageURI;
    Exit;
  End;
  Result := BaseImgURL + ImageURI;
End;

Procedure TMagBaseRemoteWSBroker.SetTextStr(Const Text: String; Var Output: TStrings);
Var
  p, Start: PChar;
  s: String;
Begin
  Output.Clear;
  p := Pointer(Text);
  If p <> Nil Then
    While p^ <> #0 Do
    Begin
      Start := p;
      While Not (p^ In [#0, #10, #13]) Do
        Inc(p);
      SetString(s, Start, p - Start);
      Output.Add(s);
      If p^ = #13 Then Inc(p);
      If p^ = #10 Then Inc(p);
    End;
End;

Procedure TMagBaseRemoteWSBroker.SetTextStr(Const Text: String; Var Output: Tstringlist);
Var
  p, Start: PChar;
  s: String;
Begin
  Output.Clear;
  p := Pointer(Text);
  If p <> Nil Then
    While p^ <> #0 Do
    Begin
      Start := p;
      While Not (p^ In [#0, #10, #13]) Do
        Inc(p);
      SetString(s, Start, p - Start);
      Output.Add(s);
      If p^ = #13 Then Inc(p);
      If p^ = #10 Then Inc(p);
    End;

End;

Procedure TMagBaseRemoteWSBroker.KeepBrokerAlive(Enabled: Boolean);
Begin
  // this function should do nothing for a WS broker
End;

Function TMagBaseRemoteWSBroker.GetSite(): TVistaSite;
Begin
  Result := FSite;
End;

Function TMagBaseRemoteWSBroker.SetPatientDFN(PatientICN: String): Boolean;
Begin
  FPatientICNWithChecksum := PatientICN;
  FPatientICN := MagPiece(PatientICN, 'V', 1);
  FStudyList.Clear();
  Result := True;
  // we don't have a way to convert to DFN (nor do we need it)
End;

Function TMagBaseRemoteWSBroker.CountImages(): Integer;
Begin
  FImageCount := -1;
//  FImageCount := 4;

  Result := FImageCount;
  // need WS call for this? (maybe for VA, prob not for DOD)
End;

Function TMagBaseRemoteWSBroker.GetRemoteBrokerType(): TMagRemoteBrokerType;
Begin
  Result := MagRemoteWSBroker;
End;

Function TMagBaseRemoteWSBroker.IsBrokerLateCountUpdate(): Boolean;
Begin
  Result := True;
End;

Function TMagBaseRemoteWSBroker.GetServerName(): String;
Begin
  // is this really what we want to return here?
  Result := FSite.VistaServer;
End;

Function TMagBaseRemoteWSBroker.GetServerPort(): Integer;
Begin
  // is this really what we want to return here?
  Result := FSite.VistaPort; // FServerPort;
End;

Procedure TMagBaseRemoteWSBroker.ClearPatient();
Begin
  FPatientStatus := STATUS_PATIENTINACTIVE;
  FImageCount := 0;
  FPatientICN := '';
  FPatientICNWithChecksum := '';
End;

Procedure TMagBaseRemoteWSBroker.Disconnect();
Begin
  // no connection to close
  FServerStatus := STATUS_DISCONNECTED;
  FPatientStatus := STATUS_PATIENTINACTIVE;
  FImageCount := 0;
  FPatientICN := '';
  FPatientICNWithChecksum := '';
End;

Function TMagBaseRemoteWSBroker.GetServerStatus(): Integer;
Begin
  Result := FServerStatus;
End;

Function TMagBaseRemoteWSBroker.GetPatientStatus(): Integer;
Begin
  Result := FPatientStatus;
End;

Function TMagBaseRemoteWSBroker.GetRemotePatientDFN(): String;
Begin
  Result := FPatientICN;
  // hmmm, won't have the DFN, mock value? do we still want to display this, is this still needed?
End;

Procedure TMagBaseRemoteWSBroker.SetPatientActive();
Begin
  FPatientStatus := STATUS_PATIENTACTIVE;
End;

Procedure TMagBaseRemoteWSBroker.SetPatientInactive();
Begin
  FPatientStatus := STATUS_PATIENTINACTIVE;
End;

Procedure TMagBaseRemoteWSBroker.SetWorkstationID(WrksID: String);
Begin
  // not used?
End;

Function TMagBaseRemoteWSBroker.GetSiteUsername(): String;
Begin
  // not going to get username from site
  Result := '';
End;

Function TMagBaseRemoteWSBroker.GetSitePassword(): String;
Begin
  Result := '';
End;

Function TMagBaseRemoteWSBroker.GetSiteDescryptedPassword(): String;
Begin
  Result := '';
End;

Function TMagBaseRemoteWSBroker.GetSiteCode(): String;
Begin
  Result := FSite.SiteNumber;
End;

Function TMagBaseRemoteWSBroker.GetSiteName(): String;
Begin
  Result := FSite.SiteName;
End;

Procedure TMagBaseRemoteWSBroker.clearBrokerFields();
Begin
  // hmmm, not sure
End;

Procedure TMagBaseRemoteWSBroker.GetNetworkLocations(Var Shares: TStrings);
Begin
  // do nothing here
End;

Function TMagBaseRemoteWSBroker.CheckRemoteImagingVersion(): Boolean;
Begin
  Result := True; // not sure - do we want a real version check for ViX to ViX?
End;

Function TMagBaseRemoteWSBroker.GetImageCount(): Integer;
Begin
  Result := FImageCount;
End;

Procedure TMagBaseRemoteWSBroker.CreateSession(AppPath, DispAppName,
  CapAppName, Compname, Location, LastUpdate: String; Startmode: Integer);
Begin
  // do nothing?
End;

Function TMagBaseRemoteWSBroker.ReOpenConnection(UserFullName, UserLocalDUZ, UserSSN: String): Boolean; // this is used if the broker was already created but it was closed or there was an error.
Begin
  Result := Connect(UserFullName, UserLocalDUZ, UserSSN);
End;

Procedure TMagBaseRemoteWSBroker.SetServerDetails(Server: String; Port: Integer);
Begin
// JMW P72 2/13/07 I don't think we still need to do this - these values should not change
{
  FServerName := Server;
  FServerPort := Port;
  }
End;

Procedure TMagBaseRemoteWSBroker.CheckSensitiveAccess(Var SensitveCode: Integer; Var Msg: Tstringlist);
Begin
  If Msg = Nil Then
    Msg := Tstringlist.Create();
  SensitveCode := -1;
  Msg.Add('Patient sensitive check done when requesting studies through VIX');
End;

Procedure TMagBaseRemoteWSBroker.LogRestrictedAccess();
Begin
  // logging access to restricted patients done through VIX when requesting studies
End;

Function TMagBaseRemoteWSBroker.GetServerDescription(): String;
Begin
  Result := '[' + FSite.SiteNumber + ']';
End;

Function TMagBaseRemoteWSBroker.GetRemoteUserDUZ(): String;
Begin
  // not going to have this value from DOD (will get from VA?)
  Result := '';
End;

End.
