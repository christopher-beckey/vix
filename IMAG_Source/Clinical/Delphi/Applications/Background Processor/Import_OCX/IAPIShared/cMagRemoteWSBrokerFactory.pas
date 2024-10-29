{
  Package: MAG - VistA Imaging
  WARNING: Per VHA Directive 2004-038, this routine should not be modified.
  Date Created: April, 2008
  Site Name:  Washington OI Field Office, Silver Spring, MD
  Developer:  Julian Werfel
  Description:
    Factory for creating web service broker instances. This attempts to
    communicate with the IDS service at the local ViX to determine how the
    client can communicate with the Vix.  If no communication is possible
    the factory creates the default web service broker instance.

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
Unit cMagRemoteWSBrokerFactory;

Interface

Uses
  Classes,
  //cMagLogManager,  {JK 10/5/2009 - Maggmsgu refactoring - deprecated unit}
  IMagRemoteBrokerInterface,
  UMagClasses
  ;

//Uses Vetted 20090929:dialogs, cmagREmoteWSBroker_v4, cMagRemoteWSBroker_v3, cMagRemoteWSBroker_v2, xmlintf, xmldoc, sysutils, idhttp, cMagRemoteWSBroker

Type
  TMagRemoteWSBrokerFactory = Class(TComponent)
  Private
    FImagingService: TMagImagingService;
    FLocalViXURL: String;
    FAllowedVersionsList: TStrings;
    //FOnLogEvent : TMagLogEvent; {JK 10/5/2009 - Maggmsgu refactoring}
    Function GetVixClinicalDisplayVersions(): Tlist;
    Function GetVersionsFromXml(XmlStream: TStream): Tlist;
    Function IsServiceVersionAllowed(ImagingService: TMagImagingService): Boolean;
    Function CreateDefaultImagingService(): TMagImagingService;
    //procedure LogMsg(MsgType : String; Msg : String; Priority : TMagLogPriority = MagLogINFO); {JK 10/5/2009 - Maggmsgu refactoring - remove old method}
  Public
    Constructor Create(LocalVixURL: String);
    Destructor Destroy; Override;

    Function GetVixClinicalDisplayVersion(): TMagImagingService;
    //property OnLogEvent : TMagLogEvent read FOnLogEvent write FOnLogEvent; {JK 10/5/2009 - Maggmsgu refactoring}
  End;

Function GetRemoteWSBroker(Site: TVistaSite; LocalVixURL: String;
  WorkstationID: String; localBrokerPort: Integer;
  SecurityTokenNeeded: TMagSecurityTokenNeededEvent): IMagRemoteBroker;
Procedure ClearBrokerFactory();
  //procedure setLogEvent(lEvent : TMagLogEvent);  {JK 10/5/2009 - Maggmsgu refactoring - remove old method}
Function IsImagingServiceAvailable(LocalVixURL: String): Boolean;

Var
  Factory: TMagRemoteWSBrokerFactory;
    //logEvent : TMagLogEvent;  {JK 10/5/2009 - Maggmsgu refactoring - remove old method}
Const
  UNKNOWN_CLINICAL_DISPLAY_VERSION = 'unknown';
Const
  CLINICAL_DISPLAY_SERVICE_TYPE = 'ClinicalDisplay';
Const
  DEFAULT_CLINICAL_DISPLAY_APP_PATH = 'ImagingExchangeWebApp';
Const
  DEFAULT_CLINICAL_DISPLAY_IMG_PATH = 'xchange/xchange';
Const
  DEFAULT_CLINICAL_DISPLAY_META_PATH = 'webservices/ImageMetadataClinicalDisplay';

Implementation

Uses
//  cMagRemoteWSBroker,
//  cMagRemoteWSBroker_v2,
//  cMagRemoteWSBroker_v3,
//  cmagREmoteWSBroker_v4,
  cMagRemoteWSBroker_V5,
  cMagRemoteWSBroker_V6,  {/ P117-NCAT JK 10/26/2010 /}
  Idhttp,
  SysUtils,
  Xmldoc,
  Xmlintf,
  Maggmsgu
  ;

//Uses Vetted 20090929:TypInfo

{JK 10/5/2009 - Maggmsgu refactoring - remove old method}
//procedure setLogEvent(lEvent : TMagLogEvent);
//begin
//  logEvent := lEvent;
//end;

Function IsImagingServiceAvailable(LocalVixURL: String): Boolean;
Var
  ImgService: TMagImagingService;
  Version: String;
Begin
  Result := False;
  If Factory = Nil Then
  Begin
    Factory := TMagRemoteWSBrokerFactory.Create(LocalVixURL);
    //factory.OnLogEvent := logEvent;  {JK 10/5/2009 - Maggmsgu refactoring}
  End;
  ImgService := Factory.GetVixClinicalDisplayVersion();
  If ImgService = Nil Then
    Exit;
  Version := ImgService.ServiceVersion;
  If (Version = UNKNOWN_CLINICAL_DISPLAY_VERSION) Then
  Begin
    Result := False;
    Exit;
  End;
  // if the version is not unknown, then it must be allowed and good
  Result := True;
End;

Function GetRemoteWSBroker(Site: TVistaSite; LocalVixURL: String;
  WorkstationID: String; localBrokerPort: Integer;
  SecurityTokenNeeded: TMagSecurityTokenNeededEvent): IMagRemoteBroker;
Var
  ImgService: TMagImagingService;
  Version: String;
Begin
  If Factory = Nil Then
  Begin
    Factory := TMagRemoteWSBrokerFactory.Create(LocalVixURL);
    //factory.OnLogEvent := logEvent; {JK 10/5/2009 - Maggmsgu refactoring}
  End;

  ImgService := Factory.GetVixClinicalDisplayVersion();
  Version := ImgService.ServiceVersion;

  {
  If (Version = '0') Or (Version = UNKNOWN_CLINICAL_DISPLAY_VERSION) Then
  Begin
    Result := TMagRemoteWSBroker.Create(Site, LocalVixURL, ImgService, WorkstationID);
  End
  Else
    If (Version = '2') Then
    Begin
      Result := TMagRemoteWSBrokerV2.Create(Site, LocalVixURL, ImgService, WorkstationID);
    End
    Else
      If (Version = '3') Then
      Begin
        Result := TMagRemoteWSBrokerV3.Create(Site, LocalVixURL, ImgService, WorkstationID);
      End
      Else
        If (Version = '4') Then
        Begin
          Result := TMagRemoteWSBrokerV4.Create(Site, LocalVixURL, ImgService,
            WorkstationID, localBrokerPort, SecurityTokenNeeded);
        End
        Else
          If (Version = '5') Then
          Begin
            Result := TMagRemoteWSBrokerV5.Create(Site, LocalVixURL, ImgService,
              WorkstationID, localBrokerPort, SecurityTokenNeeded);
          End;
          }
  // JMW 10/8/2010 Patch 83 contains version 0, 2, 3, 4, and 5 of the interface
  // but since version 5 is the best, patch 106 will only use version 5 and
  // never try to use an older version.  Patch 117 will introduce version 6 and
  // will support version 5 and version 6.

  if (Version = '5') then
    Result := TMagRemoteWSBrokerV5.Create(Site, LocalVixURL, ImgService,
                WorkstationID, localBrokerPort, SecurityTokenNeeded)
  else
  if (Version = '6') then  {/ P117-NCAT JK 10/26/2010 /}
    Result := TMagRemoteWSBrokerV6.Create(Site, LocalVixURL, ImgService,
                WorkstationID, localBrokerPort, SecurityTokenNeeded);
End;

Procedure ClearBrokerFactory();
Begin
  If Factory <> Nil Then
    FreeAndNil(Factory);
End;

Constructor TMagRemoteWSBrokerFactory.Create(LocalVixURL: String);
Begin
  Inherited Create(Nil);
  FImagingService := Nil;
  FLocalViXURL := LocalVixURL;
  FAllowedVersionsList := Tstringlist.Create();
//  FAllowedVersionsList.Add('0');  {/ P117-NCAT JK 10/26/2010 - removed 0-4 /}
//  FAllowedVersionsList.Add('2');
//  FAllowedVersionsList.Add('3');
//  FAllowedVersionsList.Add('4');
  FAllowedVersionsList.Add('5');
  FAllowedVersionsList.Add('6');  {/ P117-NCAT JK 10/26/2010 /}
End;

Destructor TMagRemoteWSBrokerFactory.Destroy;
Begin
  FLocalViXURL := '';
  If FImagingService <> Nil Then
    FreeAndNil(FImagingService);
  If FAllowedVersionsList <> Nil Then
  Begin
    FAllowedVersionsList.Clear();
    FreeAndNil(FAllowedVersionsList);
  End;
  Inherited;
End;

Function TMagRemoteWSBrokerFactory.GetVixClinicalDisplayVersions(): Tlist;
Var
  HttpClient: TIDHttp;
  URL: String;
  OutputStream: TMemoryStream;
Begin
  Result := Nil;
  HttpClient := Nil;
  Try
    Try
      HttpClient := TIDHttp.Create(Nil);
      OutputStream := TMemoryStream.Create();
      URL := FLocalViXURL + '/IDSWebApp/VersionsService?type=' + CLINICAL_DISPLAY_SERVICE_TYPE;
      HttpClient.Get(URL, OutputStream);
      Result := GetVersionsFromXml(OutputStream); //xmlResponse);
    Except
      On e: Exception Do
      Begin
        //LogMsg('s','Error getting versions from IDS service [' + e.Message + ']', MagLogERROR);
        MagLogger.LogMsg('s', 'Error getting versions from IDS service [' + e.Message + ']', MagLogERROR); {JK 10/5/2009 - Maggmsgu refactoring}
      End;
    End;
  Finally
    If HttpClient <> Nil Then
      FreeAndNil(HttpClient);
    If OutputStream <> Nil Then
      FreeAndNil(OutputStream);
  End;
End;

Function TMagRemoteWSBrokerFactory.GetVersionsFromXml(XmlStream: TStream): Tlist;
Var
  Versions: Tlist;
  Xmldoc: TXMLDocument;
  ServiceNode, ChildNode, OperationNode: IXMLNode;
  OperationPathNode: IXMLNode;
  ServiceType, ServiceVersion, ApplicationPath, ImgPath, MetaPath: String;
  ImagingService: TMagImagingService;
Begin
  Versions := Tlist.Create();
  Xmldoc := TXMLDocument.Create(Self);
  Xmldoc.LoadFromStream(XmlStream);
  Xmldoc.Active := True;
  ServiceNode := Xmldoc.DocumentElement.ChildNodes.FindNode('Service');
  While ServiceNode <> Nil Do
  Begin
    ServiceType := '';
    ServiceVersion := '';
    ApplicationPath := '';
    MetaPath := '';
    ImgPath := '';
    If ServiceNode.HasAttribute('type') Then
      ServiceType := ServiceNode.Attributes['type'];
    If ServiceNode.HasAttribute('version') Then
      ServiceVersion := ServiceNode.Attributes['version'];
    ChildNode := ServiceNode.ChildNodes.FindNode('ApplicationPath');
    If ChildNode <> Nil Then
      ApplicationPath := ChildNode.Text;
    OperationNode := ServiceNode.ChildNodes.FindNode('Operation');
    While OperationNode <> Nil Do
    Begin
      If OperationNode.HasAttribute('type') Then
      Begin
        OperationPathNode := OperationNode.ChildNodes.FindNode('OperationPath');
        If OperationNode.Attributes['type'] = 'Image' Then
        Begin
          ImgPath := OperationPathNode.Text;
        End
        Else
          If OperationNode.Attributes['type'] = 'Metadata' Then
          Begin
            MetaPath := OperationPathNode.Text;
          End;
      End;
      OperationNode := OperationNode.NextSibling;
    End;

       {
    childNode := serviceNode.ChildNodes.FindNode('MetadataPath');
    if childNode <> nil then
      metaPath := childNode.Text;
    childNode := serviceNode.ChildNodes.FindNode('ImagePath');
    if childNode <> nil then
      imgPath := childNode.Text;
      }
    If ServiceType = CLINICAL_DISPLAY_SERVICE_TYPE Then
    Begin
      ImagingService := TMagImagingService.Create(ServiceType, ServiceVersion, ApplicationPath, MetaPath, ImgPath);
      Versions.Add(ImagingService);
    End;
    ServiceNode := ServiceNode.NextSibling;
  End;
  If Xmldoc <> Nil Then
    FreeAndNil(Xmldoc);
  Result := Versions;
End;

Function TMagRemoteWSBrokerFactory.GetVixClinicalDisplayVersion(): TMagImagingService;
Var
  Versions: Tlist;
  i: Integer;
  TempService: TMagImagingService;
  Found: Boolean;
Begin
  If FImagingService = Nil Then
  Begin
    Versions := GetVixClinicalDisplayVersions();
    If Versions = Nil Then
    Begin
      FImagingService := CreateDefaultImagingService();
    End
    Else
      If Versions.Count = 0 Then
      Begin
        FImagingService := CreateDefaultImagingService();
      End
      Else
      Begin
        i := Versions.Count - 1;
        Found := False;
        While (i >= 0) And (Not Found) Do
        Begin
          TempService := Versions.Items[i];
          i := i - 1;

          If (IsServiceVersionAllowed(TempService)) Then
          Begin
            FImagingService := TempService;
            Found := True;
          End;
        End;
        If FImagingService = Nil Then
          FImagingService := CreateDefaultImagingService();
      End;

    // delete old unused ImagingService objects
    If Versions <> Nil Then
    Begin
      For i := 0 To Versions.Count - 1 Do
      Begin
        If Versions[i] <> FImagingService Then
        Begin
          TempService := Versions[i];
          FreeAndNil(TempService);
          Versions[i] := Nil;
        End
        Else
        Begin
          // don't free the imaging service (being used)
          Versions[i] := Nil;
        End;
      End;
      FreeAndNil(Versions);
    End;
  End;
  Result := FImagingService;
End;

Function TMagRemoteWSBrokerFactory.IsServiceVersionAllowed(ImagingService: TMagImagingService): Boolean;
Var
  i: Integer;
Begin
  For i := 0 To FAllowedVersionsList.Count - 1 Do
  Begin
    If ImagingService.ServiceVersion = FAllowedVersionsList.Strings[i] Then
    Begin
      Result := True;
      Exit;
    End;
  End;
  Result := False;
End;

Function TMagRemoteWSBrokerFactory.CreateDefaultImagingService(): TMagImagingService;
Begin
  Result := TMagImagingService.Create(CLINICAL_DISPLAY_SERVICE_TYPE,
    UNKNOWN_CLINICAL_DISPLAY_VERSION, DEFAULT_CLINICAL_DISPLAY_APP_PATH,
    DEFAULT_CLINICAL_DISPLAY_META_PATH, DEFAULT_CLINICAL_DISPLAY_IMG_PATH);
End;

{JK 10/5/2009 - Maggmsgu refactoring - remove old method}
//procedure TMagRemoteWSBrokerFactory.LogMsg(MsgType : String; Msg : String; Priority : TMagLogPriority = MagLogINFO);
//begin
//  if assigned(FOnLogEvent) then
//    FOnLogEvent(self, MsgType, Msg, Priority);
//end;

End.
