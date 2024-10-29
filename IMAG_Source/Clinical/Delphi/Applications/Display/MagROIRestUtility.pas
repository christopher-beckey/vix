unit MagROIRestUtility;

{Package: MAG - VistA Imaging
WARNING: Per VHA Directive 10-93-142 this unit should not be modified.
Date Created: 01/2010
Site Name: Silver Spring, OIFO
Developers: Jerry Kashtan
[==   unit MagROIRestUtility.pas;
 This unit supports REST calls to the VIX server for ROI services.
==]
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

interface                                                                                                                       

uses
  Classes,
  Windows,
  Forms,
  SysUtils,
  Dialogs,
  IMagInterfaces,
  Idhttp,
  uMagClasses,
  uMagDefinitions,
  ImagingExchangeSiteService,
  XmlIntf,
  XmlDom,
  XmlDoc;

const
  HTTPWebNodeUserName = 'alexdelarge';
  HTTPWebNodePassword = '655321';

type
  TMagRemoteCredentials = Class
  Private
    FUserLocalDUZ: String;
    FUserSSN: String;
    FLocalSiteName: String;
    FLocalSiteNumber: String;
    FUserFullname: String;
  Public
    property UserLocalDUZ: String read FUserLocalDUZ write FUserLocalDUZ;
    property UserSSN: String read FUserSSN write FUserSSN;
    property LocalSiteName: String read FLocalSiteName write FLocalSiteName;
    property LocalSiteNumber: String read FLocalSiteNumber write FLocalSiteNumber;
    property UserFullName: String read FUserFullname write FUserFullname;
  End;

  {The simple TUrnObj type is need to add an object to a string list item}
  TUrnObj = class
    URN: String;
  end;

  TMagROIRestUtility = class
  private
    FClientList: Tlist;
    FCredentialsInitialized: Boolean;
    FUserCredentials: TMagRemoteCredentials;

//    FImageQualityList: Tlist;
//    FImageCacheDirectory: String;

    FLocalVixUrl: String;
    FVixServer: String;
    FVixPort: Integer;
    FIDSAppPath: String;
    FROIOperationPaths : TStringList;   //p130T10 dmmn 2/26/13 - store as a list since there can be multiple paths

    //p94  JMW 11/25/2009 - properties needed for BSE support
    FSecurityTokenNeeded: TMagSecurityTokenNeededEvent;
    FApplicationType: TMagRemoteLoginApplication;
    FLocalBrokerPort: Integer;

    FApplicationVersion : String;

    function CreateSecurityToken(): String;
    function CreateTransactionId(): String;
    function GetHttpClient(): TIDHttp;
    function GetIDSValues(OutputList: String): Boolean;    //p130t10 dmmn 2/26/13 - switch to boolean result
    function GetJobCancelStatus(XML: String): Boolean;
    function GetStatusHandleBSE(Idhttp: TIDHttp; Guid: String): TMemoryStream;
    procedure GetStatusValues(QList: TStringList; var StatusList: TStringList);
    function GetZipHandleBSE(Idhttp: TIDHttp; URI: String): TMemoryStream;
    procedure InitializeUserCredentials;

    {/ P130 - JK 1/17/2013 - added PatIDType to QueueStudiesByIenHandleBSE.  TFS # 56553 /}
    function QueueStudiesByIenHandleBSE(Idhttp: TIDHttp; IENList, PatID, PatIDType, SiteID, QueueID: String): TMemoryStream;

    procedure ReturnClientToList(HttpClient: TIDHttp);
    function RequestCancelJobHandleBSE(Idhttp: TIDHttp; Guid: String): TMemoryStream;
    function RequestExportQueueHandleBSE(Idhttp: TIDHttp): TMemoryStream;
    function RequestIDSCheckingHandleBSE(Idhttp: TIDHttp): TMemoryStream;
    function RequestImageHandleBSE(Idhttp: TIDHttp; URL: String): TMemoryStream;
    function RequestStatusListHandleBSE(Idhttp: TIDHttp): TMemoryStream;
    function SelectNode(xmlRoot: IXmlNode; const nodePath: WideString): IXmlNode;
    function SelectNodes(xnRoot: IXmlNode; const nodePath: WideString): IXmlNodeList;
    procedure SetHttpClientCredentials(HttpClient: TIDHttp; UserCredentials: TMagRemoteCredentials);
    procedure SetClientsCredentials(UserCredentials: TMagRemoteCredentials);
    procedure AddROIStatusToListFromStream(XMLStream: TMemoryStream;
      var StatusList: TStringList);

  public
    constructor Create();
    destructor Destroy(); override;

    function AddROIGuidToList(XML: String): String;
    procedure AddROIStatusToList(XML: String; var StatusList: TStringList);
    function CancelJob(Guid: String): Boolean;
    procedure GetDisclosureZip(URI: String; var MS: TMemoryStream);
    function GetExportQueues: String;
    function GetROIStatus(Guid: String): String;
    function IsROIRestWebServiceAvailable: Boolean;
    function IsUserCredentialsSet(): Boolean;
    procedure MakeExportListFromXML(QueueXML: String; var ExportList: TStringList);

    {/ P130 - JK 1/17/2013 - added PatIDType to ProcessDisclosuresByIEN.  TFS # 56553 /}
    function ProcessDisclosuresByIEN(IENList, PatID, PatIDType, SiteID, QueueID: String): String;

    procedure RefreshStatusList(var StatusList: TStringList);
    procedure ResetUserCredentials();
    procedure setApplicationType(AppType: TMagRemoteLoginApplication);
    procedure setSecurityTokenNeededHandler(SecurityTokenNeeded: TMagSecurityTokenNeededEvent);
    procedure setLocalBrokerPort(BrokerPort: Integer);
    procedure SetUserCredentials(UserCredentials: TMagRemoteCredentials);

    property IDSAppPath: String read FIDSAppPath write FIDSAppPath;
    property LocalVixUrl: String read FLocalVixUrl write FLocalVixUrl;
    property VixServer: String read FVixServer write FVixServer;
    property VixPort: Integer read FVixPort write FVixPort;
  end;

var
  MagROIRestUtil: TMagROIRestUtility;


implementation

uses
  MagFileVersion,
  ImagDMinterface;

function GetRESTUtility: TMagROIRestUtility;
begin
  if MagROIRestUtil = nil then
    MagROIRestUtil := TMagROIRestUtility.Create;
  Result := MagROIRestUtil;
end;

function TMagROIRestUtility.CancelJob(Guid: String): Boolean;
var
  TransId: String;
  Idhttp: TIDHttp;
  OutputStream: TMemoryStream;
  Destination: String;
  QList: TStringList;
begin
  try
    Idhttp := nil;
    try
      Result := False;

      Idhttp := GetHttpClient();
      TransId := CreateTransactionId();
  //    OutputStream := TMemoryStream.Create();
      Idhttp.Request.Username := HTTPWebNodeUserName;
      Idhttp.Request.Password := HTTPWebNodePassword;
      Idhttp.Request.BasicAuthentication := True;

      OutputStream := RequestCancelJobHandleBSE(Idhttp, Guid);

      // if there is some response other than 200 (OK), error!
      if Idhttp.ResponseCode = 200 then
      begin
        magAppMsg('s', 'Response code is 200', magmsgDebug);
        OutputStream.Position := 0;

        QList := TStringlist.Create;
        try
          QList.LoadFromStream(OutputStream);
          Result := GetJobCancelStatus(QList[0]);
        finally
          QList.Free;
        end;
  //      FreeAndNil(OutputStream);
        magAppMsg('s', 'TMagROIRestUtility.CancelJob completed successfully', magmsgDebug);
      end
      else
        if Idhttp.ResponseCode = 409 then
        begin
           // this probably never happens since it looks like 409 responses are exceptions
          Result := False;
        end
        else
        begin
          Result := False;
        end;
    except
      on E:Exception do
      begin
        if Idhttp.ResponseCode = 409 then
        Begin
          magAppMsg('s', 'TMagROIRestUtility.CancelJob: 409 Exception [' + E.Message + ']', magmsgERROR);
          Result := False;
        end
        else
        begin
          magAppMsg('s', 'TMagROIRestUtility.CancelJob: Exception [' + E.Message + ']', magmsgERROR);
          Result := False;
        end;
      end;
    end;
  finally
    FreeAndNil(OutputStream);
  end;
end;

Constructor TMagROIRestUtility.Create();
Begin

  FCredentialsInitialized := False;
  FUserCredentials := Nil;
  FClientList := Tlist.Create();
//  FImageQualityList := Tlist.Create();
//  FImageCacheDirectory := '';
  FApplicationVersion := MagGetFileVersionInfo(Application.ExeName);
  InitializeUserCredentials;
  FROIOperationPaths := TStringList.Create;
End;

procedure TMagROIRestUtility.InitializeUserCredentials;
begin
  if not IsUserCredentialsSet then
  begin
    FUserCredentials               := TMagRemoteCredentials.Create;
    FUserCredentials.UserLocalDUZ  := GSess.UserDUZ; //UserLocalDUZ;
    FUserCredentials.UserSSN       := idmodobj.GetMagDBBroker1.GetUserSSN; //UserSSN;
    FUserCredentials.UserFullName  := GSess.UserName; // UserFullName;
    FUserCredentials.LocalSiteName := GSess.Wrksinst.Name;
    // JMW P72 2/6/2007 - Below should use primary site station number, not DUZ(2)
    // JMW P122 12/8/2011 - using the primary site station number, fixes HD0000000540859
    FUserCredentials.LocalSiteNumber := PrimarySiteStationNumber;
    SetUserCredentials(FUserCredentials);
  End;
end;

Destructor TMagROIRestUtility.Destroy();
Var
  i: Integer;
  CurClient: TIDHttp;
Begin
  If FClientList <> Nil Then
  Begin
    For i := 0 To FClientList.Count - 1 Do
    Begin
      CurClient := FClientList[i];
      FreeAndNil(CurClient);
    End;
    FreeAndNil(FClientList);
  End;

  FUserCredentials.Free;

  if FROIOperationPaths <> nil then
    FreeAndNil(FROIOperationPaths);
    
//  If FImageQualityList <> Nil Then
//  Begin
//    FreeAndNil(FImageQualityList);
//  End;
  Inherited;
End;

function TMagROIRestUtility.GetExportQueues: String;
var
  TransId: String;
  Idhttp: TIDHttp;
  OutputStream: TMemoryStream;
  Destination: String;
  QList: TStringList;
begin
  if (VixServer = '') or (VixPort = 0) then
  begin
    Result := '';
    Exit;
  end;

  try
  Idhttp := nil;
  try
    Result := '';

    Idhttp := GetHttpClient();
    TransId := CreateTransactionId();
//    OutputStream := TMemoryStream.Create();
    Idhttp.Request.Username := HTTPWebNodeUserName;
    Idhttp.Request.Password := HTTPWebNodePassword;
    Idhttp.Request.BasicAuthentication := True;

    OutputStream := RequestExportQueueHandleBSE(Idhttp);

    // if there is some response other than 200 (OK), error!
    if Idhttp.ResponseCode = 200 then
    begin
      magAppMsg('s', 'Response code is 200', magmsgDebug);
      OutputStream.Position := 0;

      QList := TStringlist.Create;
      try
        QList.LoadFromStream(OutputStream);
        Result := QList[0];
      finally
        QList.Free;
      end;
//      FreeAndNil(OutputStream);
      magAppMsg('s', 'TMagROIRestUtility.GetExportQueues completed successfully', magmsgDebug);
    end
    else
      if Idhttp.ResponseCode = 409 then
      begin
         // this probably never happens since it looks like 409 responses are exceptions
        Result := 'UNAVAILABLE';
      end
      else
      begin
        Result := 'FAILED';
      end;
  except
    on E:Exception do
    begin
      if Idhttp.ResponseCode = 409 then
      Begin
        magAppMsg('s', 'TMagROIRestUtility.GetExportQueues: 409 Exception [' + E.Message + ']', magmsgERROR);
        Result := 'UNAVAILABLE';
      end
      else
      begin
        magAppMsg('s', 'TMagROIRestUtility.GetExportQueues: Exception [' + E.Message + ']', magmsgERROR);
        Result := 'FAILED';
      end;
    end;
  end;
  finally
    FreeAndNil(OutputStream);
  end;
end;

{/ P130 - JK 1/17/2013 - added PatIDType to ProcessDisclosuresByIEN.  TFS # 56553 /}
function TMagROIRestUtility.ProcessDisclosuresByIEN(IENList, PatID, PatIDType, SiteID, QueueID: String): String;
var
  TransId: String;
  Idhttp: TIDHttp;
  OutputStream: TMemoryStream;
  Destination: String;
  QList: TStringList;
begin
  try
  Idhttp := nil;
  try
    Result := '';

    Idhttp := GetHttpClient();
    TransId := CreateTransactionId();
//    OutputStream := TMemoryStream.Create();

    Idhttp.Request.Username := HTTPWebNodeUserName;
    Idhttp.Request.Password := HTTPWebNodePassword;
    Idhttp.Request.BasicAuthentication := True;

    OutputStream := QueueStudiesByIenHandleBSE(Idhttp, IENList, PatID, PatIDType, SiteID, QueueID);

    // if there is some response other than 200 (OK), error!
    If Idhttp.ResponseCode = 200 Then
    Begin
      magAppMsg('s', 'Response code is 200', magmsgDebug);
      OutputStream.Position := 0;

      QList := TStringlist.Create;
      try
        QList.LoadFromStream(OutputStream);
        Result := QList[0];
      finally
        QList.Free;
      end;
//      FreeAndNil(OutputStream);
      magAppMsg('s', 'TMagROIRestUtility.ProcessDisclosuresByIEN completed successfully', magmsgDebug);
    End

    Else
      If Idhttp.ResponseCode = 409 Then
      Begin
         // this probably never happens since it looks like 409 responses are exceptions
        Result := 'UNAVAILABLE';
      End
      Else
      Begin
        Result := 'FAILED';
      End;
  Except
    On e: Exception Do
    Begin
      If Idhttp.ResponseCode = 409 Then
      Begin
        magAppMsg('s', 'TMagROIRestUtility.ProcessDisclosuresByIEN: 409 Exception [' + E.Message + ']', magmsgERROR);
        Result := 'UNAVAILABLE';
      End
      Else
      Begin
        magAppMsg('s', 'TMagROIRestUtility.ProcessDisclosuresByIEN: Exception [' + e.Message + ']', magmsgERROR);
        Result := 'FAILED';
      End;
    End;
  End;
  finally
    FreeAndNil(OutputStream);
  end;
end;


function TMagROIRestUtility.IsROIRestWebServiceAvailable: Boolean;
var
  TransId: String;
  Idhttp: TIDHttp;
  OutputStream: TMemoryStream;
  Destination: String;
  QList: TStrings;
begin
  if (VixServer = '') or (VixPort = 0) then
  begin
    Result := False;
    Exit;
  end;

  try
    Idhttp := nil;
    try
      Result := False;

      Idhttp := GetHttpClient();
      TransId := CreateTransactionId();

      Idhttp.Request.Username := HTTPWebNodeUserName;
      Idhttp.Request.Password := HTTPWebNodePassword;
      Idhttp.Request.BasicAuthentication := True;

      OutputStream := RequestIDSCheckingHandleBSE(Idhttp);

      // if there is some response other than 200 (OK), error!
      If Idhttp.ResponseCode = 200 Then
      Begin
        magAppMsg('s', 'Response code is 200', magmsgDebug);
        OutputStream.Position := 0;

        QList := TStringlist.Create;
        try
          QList.LoadFromStream(OutputStream);

          if GetIDSValues(QList[0]) = false then
          begin
            Result := False;
            magAppMsg('s', 'TMagROIRestUtility.IsROIRestWebServiceAvailable GetIDSValues returned FALSE', magmsgDebug);
          end
          else
          begin
            Result := True;
            magAppMsg('s', 'TMagROIRestUtility.IsROIRestWebServiceAvailable GetIDSValues returned TRUE', magmsgDebug);
          end;
        finally
          QList.Free;
        end;

      End
      Else
        If Idhttp.ResponseCode = 409 Then
        Begin
           // this probably never happens since it looks like 409 responses are exceptions
          Result := False;
        End
        Else
        Begin
          Result := False;
        End;
    Except
      On e: Exception Do
      Begin
        If Idhttp.ResponseCode = 409 Then
        Begin
          magAppMsg('s', 'TMagROIRestUtility.IsROIRestWebServiceAvailable: 409 Exception [' + E.Message + ']', magmsgERROR);
          Result := False;
        End
        Else
        Begin
          magAppMsg('s', 'TMagROIRestUtility.IsROIRestWebServiceAvailable: Exception [' + E.Message + ']', magmsgERROR);
          Result := False;
        End;
      End;
    End;
  finally
    FreeAndNil(OutputStream);
  end;
end;

Function TMagROIRestUtility.IsUserCredentialsSet(): Boolean;
Begin
  Result := FCredentialsInitialized;
End;

Procedure TMagROIRestUtility.ResetUserCredentials();
Begin
  FCredentialsInitialized := False;
  FUserCredentials := Nil;
  SetClientsCredentials(Nil);

End;

Procedure TMagROIRestUtility.SetUserCredentials(UserCredentials: TMagRemoteCredentials);
Begin
  If FCredentialsInitialized = True Then Exit;
  If UserCredentials = Nil Then Exit;
  FUserCredentials := UserCredentials;
  SetClientsCredentials(UserCredentials);
  FCredentialsInitialized := True;
End;

Function TMagROIRestUtility.CreateTransactionId(): String;
Var
  Guid: TGuid;
Begin
  CreateGUID(Guid);
  Result := GUIDToString(Guid);
End;

Function TMagROIRestUtility.GetHttpClient(): TIDHttp;
Var
  CurClient: TIDHttp;
Begin
  If FClientList = Nil Then
    FClientList := Tlist.Create();
  If FClientList.Count > 0 Then
  Begin
    CurClient := FClientList[0];
    FClientList.Delete(0);
  End
  Else
  Begin
    CurClient := TIDHttp.Create(Nil);
    If FCredentialsInitialized Then
    Begin
      SetHttpClientCredentials(CurClient, FUserCredentials);
    End;
  End;
  Result := CurClient;

End;

Procedure TMagROIRestUtility.ReturnClientToList(HttpClient: TIDHttp);
Begin
  If HttpClient = Nil Then
    Exit;
  If FClientList = Nil Then
    FClientList := Tlist.Create();
  FClientList.Add(HttpClient);
End;

Procedure TMagROIRestUtility.SetHttpClientCredentials(HttpClient: TIDHttp; UserCredentials: TMagRemoteCredentials);
Begin
  If UserCredentials = Nil Then
  Begin
    HttpClient.Request.CustomHeaders.Clear();
  End
  Else
  Begin
    HttpClient.Request.CustomHeaders.Add('xxx-duz: '            + UserCredentials.UserLocalDUZ);
    HttpClient.Request.CustomHeaders.Add('xxx-fullname: '       + UserCredentials.UserFullName);
    HttpClient.Request.CustomHeaders.Add('xxx-sitename: '       + UserCredentials.LocalSiteName);
    HttpClient.Request.CustomHeaders.Add('xxx-sitenumber: '     + UserCredentials.LocalSiteNumber);
    HttpClient.Request.CustomHeaders.Add('xxx-ssn: '            + UserCredentials.UserSSN);
    HttpClient.Request.CustomHeaders.Add('xxx-transaction-id: ');
    HttpClient.Request.CustomHeaders.Add('xxx-client-version: ' + FApplicationVersion);
  End;
End;

Procedure TMagROIRestUtility.SetClientsCredentials(UserCredentials: TMagRemoteCredentials);
Var
  i: Integer;
  CurClient: TIDHttp;
Begin
  If FClientList = Nil Then
    Exit;
  For i := 0 To FClientList.Count - 1 Do
  Begin
    CurClient := FClientList[i];
    SetHttpClientCredentials(CurClient, UserCredentials);
  End;
End;

//p94
Procedure TMagROIRestUtility.setApplicationType(AppType: TMagRemoteLoginApplication);
Begin
  Self.FApplicationType := AppType;
End;

Procedure TMagROIRestUtility.setSecurityTokenNeededHandler(SecurityTokenNeeded: TMagSecurityTokenNeededEvent);
Begin
  Self.FSecurityTokenNeeded := SecurityTokenNeeded;
End;

Procedure TMagROIRestUtility.setLocalBrokerPort(BrokerPort: Integer);
Begin
  FLocalBrokerPort := BrokerPort;
End;

Function TMagROIRestUtility.createSecurityToken(): String;
Begin
  Result := 'VISTA IMAGING DISPLAY';
  If FApplicationType = magRemoteAppTeleReader Then
    Result := 'VISTA IMAGING TELEREADER';

  Result := Result + '^' + gsess.SecurityToken + '^' +
    PrimarySiteStationNumber + '^' + Inttostr(FLocalBrokerPort);

  MagAppMsg('s', 'TMagROIRestUtility.createSecurityToken: ' + Result);
End;

function TMagROIRestUtility.RequestIDSCheckingHandleBSE(Idhttp: TIDHttp): TMemoryStream;
Var
  bseAttemptCount: Integer;
  tryAgain: Boolean;
  TransId: String;
  tokenIndex: Integer;
  IdsUrl: String;
Begin
  bseAttemptCount := 0;
  tryAgain := True;
  Result := TMemoryStream.Create();
  While tryAgain Do
  Begin
    Try
      bseAttemptCount := bseAttemptCount + 1;
      TransId := CreateTransactionId();
      If GSess.SecurityToken <> '' Then
      Begin
        Idhttp.Request.CustomHeaders.Values['xxx-securityToken'] := createSecurityToken();
      End
      Else
      Begin
        tokenIndex := Idhttp.Request.CustomHeaders.IndexOfName('xxx-securityToken');
        Idhttp.Request.CustomHeaders.Delete(tokenIndex);
      End;
      magAppMsg('s', 'Requesting IDS Checking for http://' + VixServer + ':' + IntToStr(VixPort) + '/IDSWebApp/VersionsService?type=ROI', magmsgDebug);

      Idhttp.Request.CustomHeaders.Values['xxx-transaction-id'] := TransId;
      IdsUrl := 'http://' + VixServer + ':' + IntToStr(VixPort) + '/IDSWebApp/VersionsService?type=ROI';
      Idhttp.Get(IdsUrl, Result);
      tryAgain := False;
    Except
      On e: Exception Do
      Begin
        tryAgain := False;

        If Idhttp.ResponseCode = 412 Then
        Begin
          magAppMsg('s', 'TMagROIRestUtility.RequestIDSCheckingHandleBSE: 412 (EXPIRED BSE TOKEN) Exception getting image from url [' + IdsUrl + '], Exception [' + e.Message + '], attempting to get new token.', magmsgERROR);
          If bseattemptCount < 3 Then
          Begin
            magAppMsg('s', 'TMagROIRestUtility.RequestIDSCheckingHandleBSE: Current BSE login attempt is ' + Inttostr(bseattemptCount) + ', try to get new token', MagmsgINFO);
            If Assigned(FSecurityTokenNeeded) Then
            Begin
              GSess.SecurityToken := FSecurityTokenNeeded;
              magAppMsg('s', 'TMagROIRestUtility.RequestIDSCheckingHandleBSE: Received new token ' + GSess.SecurityToken, MagmsgINFO);
              tryAgain := True;
            End
            Else
            Begin
              magAppMsg('s', 'TMagROIRestUtility.RequestIDSCheckingHandleBSE: FSecurityTokenNeeded not assigned, cannot get new token, clearing token to force CAPRI', MagmsgINFO);
              // clear the token so it will prevent BSE from working, will fall back to CAPRI method
              gsess.SecurityToken := '';
              tryAgain := True;
              Raise Exception.Create(e.Message);
            End;
          End;
          If Not tryAgain Then
          Begin
            magAppMsg('s', 'TMagROIRestUtility.RequestIDSCheckingHandleBSE: Could not get new token, cannot connect to remote site.', MagmsgINFO);
          End;
        End
        Else {not 412 error}
        Begin
          // not BSE Exception, some other exception type - raise this to parent
          Raise Exception.Create(E.Message);
        End;
      End;
    End; {try}
  End; {while}

end;

//p94
Function TMagROIRestUtility.RequestImageHandleBSE(Idhttp: TIDHttp; URL: String): TMemoryStream;
Var
  bseAttemptCount: Integer;
  tryAgain: Boolean;
  TransId: String;
  tokenIndex: Integer;
Begin
  bseAttemptCount := 0;
  tryAgain := True;
  Result := TMemoryStream.Create();
  While tryAgain Do
  Begin
    Try
      bseAttemptCount := bseAttemptCount + 1;
      TransId := CreateTransactionId();
      If GSess.SecurityToken <> '' Then
      Begin
        Idhttp.Request.CustomHeaders.Values['xxx-securityToken'] := createSecurityToken();
      End
      Else
      Begin
        tokenIndex := Idhttp.Request.CustomHeaders.IndexOfName('xxx-securityToken');
        Idhttp.Request.CustomHeaders.Delete(tokenIndex);
      End;
      magAppMsg('s', 'Requesting image URL [' + URL +
        '] from VIX with transId [' + TransId + '].', magmsgDebug);

      Idhttp.Request.CustomHeaders.Values['xxx-transaction-id'] := TransId;
      Idhttp.Get(URL, Result);
      tryAgain := False;
    Except
      On e: Exception Do
      Begin
        tryAgain := False;

        If Idhttp.ResponseCode = 412 Then
        Begin
          magAppMsg('s', 'TMagROIRestUtility.RequestImageHandleBSE: 412 (EXPIRED BSE TOKEN) Exception getting image from url [' + URL + '], Exception [' + e.Message + '], attempting to get new token.', magmsgERROR);
          If bseattemptCount < 3 Then
          Begin
            magAppMsg('s', 'TMagROIRestUtility.RequestImageHandleBSE: Current BSE login attempt is ' + Inttostr(bseattemptCount) + ', try to get new token', MagmsgINFO);
            If Assigned(FSecurityTokenNeeded) Then
            Begin
              GSess.SecurityToken := FSecurityTokenNeeded;
              magAppMsg('s', 'TMagROIRestUtility.RequestImageHandleBSE: Received new token ' + GSess.SecurityToken, MagmsgINFO);
              tryAgain := True;
            End
            Else
            Begin
              magAppMsg('s', 'TMagROIRestUtility.RequestImageHandleBSE: FSecurityTokenNeeded not assigned, cannot get new token, clearing token to force CAPRI', MagmsgINFO);
              // clear the token so it will prevent BSE from working, will fall back to CAPRI method
              gsess.SecurityToken := '';
              tryAgain := True;
              Raise Exception.Create(e.Message);
            End;
          End;
          If Not tryAgain Then
          Begin
            magAppMsg('s', 'TMagROIRestUtility.RequestImageHandleBSE: Could not get new token, cannot connect to remote site.', MagmsgINFO);
          End;
        End
        Else {not 412 error}
        Begin
          // not BSE Exception, some other exception type - raise this to parent
          Raise Exception.Create(E.Message);
        End;
      End;
    End; {try}
  End; {while}
End;

//p94
procedure TMagROIRestUtility.RefreshStatusList(var StatusList: TStringList);
var
  TransId: String;
  Idhttp: TIDHttp;
  OutputStream: TMemoryStream;
  Destination: String;
  QList: TStringList;
begin
  try
    Idhttp := nil;
    try

      Idhttp := GetHttpClient();
      TransId := CreateTransactionId();
  //    OutputStream := TMemoryStream.Create();
      Idhttp.Request.Username := HTTPWebNodeUserName;
      Idhttp.Request.Password := HTTPWebNodePassword;
      Idhttp.Request.BasicAuthentication := True;

      OutputStream := RequestStatusListHandleBSE(Idhttp);

      // if there is some response other than 200 (OK), error!
      If Idhttp.ResponseCode = 200 Then
      Begin
        magAppMsg('s', 'Response code is 200', magmsgDebug);
        OutputStream.Position := 0;

        QList := TStringlist.Create;
        try
          //QList.LoadFromStream(OutputStream);

          StatusList.Clear;
//          GetStatusValues(QList, StatusList);
          OutputStream.Position := 0;
          AddROIStatusToListFromStream(OutputStream, StatusList);

        finally
          QList.Free;
        end;

  //      FreeAndNil(OutputStream);
        magAppMsg('s', 'TMagROIRestUtility.RefreshStatusList completed successfully', magmsgDebug);
      End

      Else
        If Idhttp.ResponseCode = 409 Then
        Begin
           // this probably never happens since it looks like 409 responses are exceptions
          magAppMsg('s', 'TMagROIRestUtility.RefreshStatusList: Cannot refresh statuses: Response code = 409', magmsgError);
        End
        Else
        Begin
          magAppMsg('s', 'TMagROIRestUtility.RefreshStatusList: Cannot refresh statuses: Response code is unknown', magmsgError);
        End;
    Except
      On e: Exception Do
      Begin
        If Idhttp.ResponseCode = 409 Then
        Begin
          magAppMsg('s', 'TMagROIRestUtility.RefreshStatusList: Cannot refresh statuses: 409 Exception [' + e.Message + ']', magmsgERROR);
        End
        Else
        Begin
          magAppMsg('s', 'TMagROIRestUtility.RefreshStatusList: Cannot refresh statuses: Exception [' + e.Message + ']', magmsgERROR);
        End;
      End;
    End;
  finally
    FreeAndNil(OutputStream);
  end;
end;

procedure TMagROIRestUtility.GetStatusValues(QList: TStringList; var StatusList: TStringList);
var
  i: Integer;
begin
  StatusList.Clear;
  for i := 0 to QList.Count - 1 do
    AddROIStatusToList(QList[i], StatusList);
end;

Function TMagROIRestUtility.RequestStatusListHandleBSE(Idhttp: TIDHttp): TMemoryStream;
Var
  bseAttemptCount: Integer;
  tryAgain: Boolean;
  TransId: String;
  tokenIndex: Integer;
  StatusListURL: String;
Begin

  StatusListURL := 'http://' +
                   VixServer + ':' + IntToStr(VixPort) + '/' +
                   IDSAppPath +
                   FROIOperationPaths.Values['ROI'] +       //p130T10 dmmn 2/26/13 - use ROI operation path
                   'user';
  bseAttemptCount := 0;
  tryAgain := True;
  Result := TMemoryStream.Create();

  While tryAgain Do
  Begin
    Try
      bseAttemptCount := bseAttemptCount + 1;
      TransId := CreateTransactionId();
      If GSess.SecurityToken <> '' Then
      Begin
        Idhttp.Request.CustomHeaders.Values['xxx-securityToken'] := createSecurityToken();
      End
      Else
      Begin
        tokenIndex := Idhttp.Request.CustomHeaders.IndexOfName('xxx-securityToken');
        Idhttp.Request.CustomHeaders.Delete(tokenIndex);
      End;
      magAppMsg('s', 'TMagROIRestUtility.RequestStatusListHandleBSE: Requesting User Status List from VIX with transId [' + TransId + '].', magmsgDebug);

      Idhttp.Request.CustomHeaders.Values['xxx-transaction-id'] := TransId;
      Idhttp.Get(StatusListURL, Result);
      tryAgain := False;
    Except
      On e: Exception Do
      Begin
        tryAgain := False;

        If Idhttp.ResponseCode = 412 Then
        Begin
          magAppMsg('s', 'TMagROIRestUtility.RequestStatusListHandleBSE: 412 (EXPIRED BSE TOKEN) Exception [' + e.Message + '], attempting to get new token.', magmsgERROR);
          If bseattemptCount < 3 Then
          Begin
            magAppMsg('s', 'TMagROIRestUtility.RequestStatusListHandleBSE: Current BSE login attempt is ' + Inttostr(bseattemptCount) + ', try to get new token', MagmsgINFO);
            If Assigned(FSecurityTokenNeeded) Then
            Begin
              GSess.SecurityToken := FSecurityTokenNeeded;
              magAppMsg('s', 'TMagROIRestUtility.RequestStatusListHandleBSE: Received new token ' + GSess.SecurityToken, MagmsgINFO);
              tryAgain := True;
            End
            Else
            Begin
              magAppMsg('s', 'TMagROIRestUtility.RequestStatusListHandleBSE: FSecurityTokenNeeded not assigned, cannot get new token, clearing token to force CAPRI', MagmsgINFO);
              // clear the token so it will prevent BSE from working, will fall back to CAPRI method
              gsess.SecurityToken := '';
              tryAgain := True;
              Raise Exception.Create(e.Message);
            End;
          End;
          If Not tryAgain Then
          Begin
            magAppMsg('s', 'TMagROIRestUtility.RequestStatusListHandleBSE: Could not get new token, cannot connect to remote site.', MagmsgINFO);
          End;
        End
        Else {not 412 error}
        Begin
          // not BSE Exception, some other exception type - raise this to parent
          Raise Exception.Create(e.Message);
        End;
      End;
    End; {try}
  End; {while}
End;

Function TMagROIRestUtility.RequestExportQueueHandleBSE(Idhttp: TIDHttp): TMemoryStream;
Var
  bseAttemptCount: Integer;
  tryAgain: Boolean;
  TransId: String;
  tokenIndex: Integer;
  DicomExportQueueURL: String;
Begin

  DicomExportQueueURL := 'http://' +
                         VixServer + ':' + IntToStr(VixPort) + '/' +
                         IDSAppPath +
                         FROIOperationPaths.Values['ExportQueue'] +       //p130T10 dmmn 2/26/13 - use ExportQueue operation path
                         'dicom';

  bseAttemptCount := 0;
  tryAgain := True;
  Result := TMemoryStream.Create();
  While tryAgain Do
  Begin
    Try
      bseAttemptCount := bseAttemptCount + 1;
      TransId := CreateTransactionId();
      If GSess.SecurityToken <> '' Then
      Begin
        Idhttp.Request.CustomHeaders.Values['xxx-securityToken'] := createSecurityToken();
      End
      Else
      Begin
        tokenIndex := Idhttp.Request.CustomHeaders.IndexOfName('xxx-securityToken');
        Idhttp.Request.CustomHeaders.Delete(tokenIndex);
      End;
      magAppMsg('s', 'TMagROIRestUtility.RequestExportQueueHandleBSE: Requesting EXPORT QUEUES: REST URL [' + DicomExportQueueURL +
        '] from VIX with transId [' + TransId + '].', magmsgDebug);

      Idhttp.Request.CustomHeaders.Values['xxx-transaction-id'] := TransId;
      Idhttp.Get(DicomExportQueueURL, Result);
      tryAgain := False;
    Except
      On e: Exception Do
      Begin
        tryAgain := False;

        If Idhttp.ResponseCode = 412 Then
        Begin
          magAppMsg('s', 'TMagROIRestUtility.RequestExportQueueHandleBSE: 412 (EXPIRED BSE TOKEN) Exception getting image from url [' + DicomExportQueueURL + '], Exception [' + e.Message + '], attempting to get new token.', magmsgERROR);
          If bseattemptCount < 3 Then
          Begin
            magAppMsg('s', 'TMagROIRestUtility.RequestExportQueueHandleBSE: Current BSE login attempt is ' + Inttostr(bseattemptCount) + ', try to get new token', MagmsgINFO);
            If Assigned(FSecurityTokenNeeded) Then
            Begin
              GSess.SecurityToken := FSecurityTokenNeeded;
              magAppMsg('s', 'TMagROIRestUtility.RequestExportQueueHandleBSE: Received new token ' + GSess.SecurityToken, MagmsgINFO);
              tryAgain := True;
            End
            Else
            Begin
              magAppMsg('s', 'TMagROIRestUtility.RequestExportQueueHandleBSE: FSecurityTokenNeeded not assigned, cannot get new token, clearing token to force CAPRI', MagmsgINFO);
              // clear the token so it will prevent BSE from working, will fall back to CAPRI method
              gsess.SecurityToken := '';
              tryAgain := True;
              Raise Exception.Create(e.Message);
            End;
          End;
          If Not tryAgain Then
          Begin
            magAppMsg('s', 'TMagROIRestUtility.RequestExportQueueHandleBSE: Could not get new token, cannot connect to remote site.', MagmsgINFO);
          End;
        End
        Else {not 412 error}
        Begin
          // not BSE Exception, some other exception type - raise this to parent
          Raise Exception.Create(e.Message);
        End;
      End;
    End; {try}
  End; {while}
End;

Function TMagROIRestUtility.RequestCancelJobHandleBSE(Idhttp: TIDHttp; Guid: String): TMemoryStream;
Var
  bseAttemptCount: Integer;
  tryAgain: Boolean;
  TransId: String;
  tokenIndex: Integer;
  CancelJobURL: String;
Begin

  CancelJobURL := 'http://' +
                  VixServer + ':' + IntToStr(VixPort) + '/' +
                  IDSAppPath +
                  FROIOperationPaths.Values['ROI'] +       //p130T10 dmmn 2/26/13 - use ROI operation path
                  'cancel';

  CancelJobURL := CancelJobURL + '/' + Guid;                  

  bseAttemptCount := 0;
  tryAgain := True;
  Result := TMemoryStream.Create();
  While tryAgain Do
  Begin
    Try
      bseAttemptCount := bseAttemptCount + 1;
      TransId := CreateTransactionId();
      If GSess.SecurityToken <> '' Then
      Begin
        Idhttp.Request.CustomHeaders.Values['xxx-securityToken'] := createSecurityToken();
      End
      Else
      Begin
        tokenIndex := Idhttp.Request.CustomHeaders.IndexOfName('xxx-securityToken');
        Idhttp.Request.CustomHeaders.Delete(tokenIndex);
      End;

      magAppMsg('s', 'TMagROIRestUtility.RequestExportQueueHandleBSE: Requesting EXPORT QUEUES: REST URL [' + CancelJobURL +
        '] from VIX with transId [' + TransId + '].', magmsgDebug);

      Idhttp.Request.CustomHeaders.Values['xxx-transaction-id'] := TransId;
      Idhttp.Get(CancelJobURL, Result);
      tryAgain := False;
    Except
      On e: Exception Do
      Begin
        tryAgain := False;

        If Idhttp.ResponseCode = 412 Then
        Begin
          magAppMsg('s', 'TMagROIRestUtility.RequestExportQueueHandleBSE: 412 (EXPIRED BSE TOKEN) Exception getting image from url [' + CancelJobURL + '], Exception [' + e.Message + '], attempting to get new token.', magmsgERROR);
          If bseattemptCount < 3 Then
          Begin
            magAppMsg('s', 'TMagROIRestUtility.RequestExportQueueHandleBSE: Current BSE login attempt is ' + Inttostr(bseattemptCount) + ', try to get new token', MagmsgINFO);
            If Assigned(FSecurityTokenNeeded) Then
            Begin
              GSess.SecurityToken := FSecurityTokenNeeded;
              magAppMsg('s', 'TMagROIRestUtility.RequestExportQueueHandleBSE: Received new token ' + GSess.SecurityToken, MagmsgINFO);
              tryAgain := True;
            End
            Else
            Begin
              magAppMsg('s', 'TMagROIRestUtility.RequestExportQueueHandleBSE: FSecurityTokenNeeded not assigned, cannot get new token, clearing token to force CAPRI', MagmsgINFO);
              // clear the token so it will prevent BSE from working, will fall back to CAPRI method
              gsess.SecurityToken := '';
              tryAgain := True;
              Raise Exception.Create(e.Message);
            End;
          End;
          If Not tryAgain Then
          Begin
            magAppMsg('s', 'TMagROIRestUtility.RequestExportQueueHandleBSE: Could not get new token, cannot connect to remote site.', MagmsgINFO);
          End;
        End
        Else {not 412 error}
        Begin
          // not BSE Exception, some other exception type - raise this to parent
          Raise Exception.Create(e.Message);
        End;
      End;
    End; {try}
  End; {while}
End;


//p94
{/ P130 - JK 1/17/2013 - added PatIDType to QueueStudiesByIenHandleBSE.  TFS # 56553 /}
Function TMagROIRestUtility.QueueStudiesByIenHandleBSE(Idhttp: TIDHttp; IENList, PatID, PatIDType, SiteID, QueueID: String): TMemoryStream;
var
  bseAttemptCount: Integer;
  tryAgain: Boolean;
  TransId: String;
  tokenIndex: Integer;
  QueueByIenUrl: String;
begin


  QueueID := StringReplace(QueueID, ':', '%3A', [rfReplaceAll, rfIgnoreCase]);

  QueueByIenUrl := 'http://' +
                   VixServer + ':' + IntToStr(VixPort) + '/' +
                   IDSAppPath +
                   FROIOperationPaths.Values['ROI'] +       //p130T10 dmmn 2/26/13 - use ROI operation path
                   'queue';

  bseAttemptCount := 0;
  tryAgain := True;
  Result := TMemoryStream.Create;

  while tryAgain Do
  begin
    try
      bseAttemptCount := bseAttemptCount + 1;
      TransId := CreateTransactionId();
      if GSess.SecurityToken <> '' then
      begin
        Idhttp.Request.CustomHeaders.Values['xxx-securityToken'] := createSecurityToken();
      end
      else
      begin
        tokenIndex := Idhttp.Request.CustomHeaders.IndexOfName('xxx-securityToken');
        Idhttp.Request.CustomHeaders.Delete(tokenIndex);
      end;

      magAppMsg('s', 'TMagROIRestUtility.QueueStudiesByIenHandleBSE: Sending list of studies by IEN for disclosure: REST URL [' + QueueByIenUrl +
        '] from VIX with transId [' + TransId + '].', magmsgDebug);

      Idhttp.Request.CustomHeaders.Values['xxx-transaction-id'] := TransId;

      if PatIDType = 'ICN' then      
        QueueByIenUrl := QueueByIenUrl + '/icn/' + PatId + '/' + SiteId + '/' + IENList + '/' + QueueID
      else
        QueueByIenUrl := QueueByIenUrl + '/dfn/' + PatId + '/' + SiteId + '/' + IENList + '/' + QueueID;

      Idhttp.Get(QueueByIenUrl, Result);

      tryAgain := False;

    except
      on E:Exception do
      begin
        tryAgain := False;

        if Idhttp.ResponseCode = 412 then
        begin
          magAppMsg('s', 'TMagROIRestUtility.QueueStudiesByIenHandleBSE: 412 (EXPIRED BSE TOKEN) Exception getting image from url [' + QueueByIenUrl + '], Exception [' + E.Message + '], attempting to get new token.', magmsgERROR);
          if bseAttemptCount < 3 then
          begin
            magAppMsg('s', 'TMagROIRestUtility.QueueStudiesByIenHandleBSE: Current BSE login attempt is ' + Inttostr(bseattemptCount) + ', try to get new token', MagmsgINFO);
            if Assigned(FSecurityTokenNeeded) then
            begin
              GSess.SecurityToken := FSecurityTokenNeeded;
              magAppMsg('s', 'TMagROIRestUtility.QueueStudiesByIenHandleBSE: Received new token ' + GSess.SecurityToken, MagmsgINFO);
              tryAgain := True;
            end
            else
            begin
              magAppMsg('s', 'TMagROIRestUtility.QueueStudiesByIenHandleBSE: FSecurityTokenNeeded not assigned, cannot get new token, clearing token to force CAPRI', MagmsgINFO);
              // clear the token so it will prevent BSE from working, will fall back to CAPRI method
              gsess.SecurityToken := '';
              tryAgain := True;
              raise Exception.Create(E.Message);
            end;
          end;

          if not tryAgain then
          begin
            magAppMsg('s', 'TMagROIRestUtility.QueueStudiesByIenHandleBSE: Could not get new token, cannot connect to remote site.', MagmsgINFO);
          end;
        end
        else {not 412 error}
        begin
          // not BSE Exception, some other exception type - raise this to parent
          raise Exception.Create(E.Message);
        end;
      end;
    end; {try}
  end; {while}
end;

function TMagROIRestUtility.SelectNode(xmlRoot: IXmlNode;
                                       const nodePath: WideString): IXmlNode;
var
  nodeSelect : IDomNodeSelect;
  nodeResult : IDomNode;
  docAccess : IXmlDocumentAccess;
  xmlDoc: TXmlDocument;
begin
  Result := nil;
  if not Assigned(xmlRoot) or not Supports(xmlRoot.DOMNode, IDomNodeSelect, nodeSelect) then
    Exit;
  nodeResult := nodeSelect.selectNode(nodePath);

  if Assigned(nodeResult) then
  begin
    if Supports(xmlRoot.OwnerDocument, IXmlDocumentAccess, docAccess) then
      xmlDoc := docAccess.DocumentObject
    else
      xmlDoc := nil;
    Result := TXmlNode.Create(nodeResult, nil, xmlDoc);
  end;
end;

function TMagROIRestUtility.SelectNodes(xnRoot: IXmlNode; const nodePath: WideString): IXmlNodeList;
var
  nodeSelect : IDomNodeSelect;
  intfAccess : IXmlNodeAccess;
  docAccess : IXmlDocumentAccess;
  xmlDoc: TXmlDocument;
  nodeListResult  : IDomNodeList;
  i : Integer;
  dn : IDomNode;
begin
  Result := nil;
  if not Assigned(xnRoot)
    or not Supports(xnRoot, IXmlNodeAccess, intfAccess)
    or not Supports(xnRoot.DOMNode, IDomNodeSelect, nodeSelect) then
    Exit;

  nodeListResult := nodeSelect.selectNodes(nodePath);
  if Assigned(nodeListResult) then
  begin
    Result := TXmlNodeList.Create(intfAccess.GetNodeObject, '', nil);
    if Supports(xnRoot.OwnerDocument, IXmlDocumentAccess, docAccess) then
      xmlDoc := docAccess.DocumentObject
    else
      xmlDoc := nil;

    for i := 0 to nodeListResult.length - 1 do
    begin
      dn := nodeListResult.item[i];
      Result.Add(TXmlNode.Create(dn, nil, xmlDoc));
    end;
  end;
end;

procedure TMagROIRestUtility.MakeExportListFromXML(QueueXML: String; var ExportList: TStringList);
var
  iNode: IXMLNode;
  iNodes: IXMLNodeList;
  MyXMLDoc: IXmlDocument;
  XPath: String;
  StreamXML: TStringStream;
  i: Integer;
  S: String;
  UrnObj: TUrnObj;
begin

  if ExportList = nil then
    Exit;

  ExportList.Clear;

  MyXMLDoc := TXmlDocument.Create(nil);

  StreamXML := TStringStream.Create(QueueXML);
  try
    StreamXML.Position := 0;
    MyXMLDoc.LoadFromStream(StreamXML);
  finally
    StreamXML.Free;
  end;

  MyXMLDoc.Active;

  XPath := '/rOIDicomExportQueueTypes/roiDicomExportQueueType/location | ' +
           '/rOIDicomExportQueueTypes/roiDicomExportQueueType/name | ' +
           '/rOIDicomExportQueueTypes/roiDicomExportQueueType/queueId';

  iNodes := SelectNodes(MyXMLDoc.DocumentElement, XPath);

  {For each queue entry, they are returned from the server as a triplet in XML}
  i := 1;
  while i < iNodes.Count do
  begin
    s := iNodes.Nodes[i].NodeValue + ', ' + iNodes.Nodes[i-1].NodeValue;
    UrnObj := TUrnObj.Create;
    UrnObj.URN := iNodes.Nodes[i+1].NodeValue;
    ExportList.AddObject(S, UrnObj);
    i := i + 3;
  end;

  iNode := nil;
  iNodes := nil;
  MyXMLDoc := nil;
end;

function TMagROIRestUtility.GetJobCancelStatus(XML: String): Boolean;
var
  iNode: IXMLNode;
  iNodes: IXMLNodeList;
  MyXMLDoc: IXmlDocument;
  XPath: String;
  StreamXML: TStringStream;
  i: Integer;
begin
  Result := False;

  if (Trim(XML) = '') or (XML = 'FAILED') then
    Exit;

  MyXMLDoc := TXmlDocument.Create(nil);

  StreamXML := TStringStream.Create(XML);
  try
    StreamXML.Position := 0;
    MyXMLDoc.LoadFromStream(StreamXML);
  finally
    StreamXML.Free;
  end;

  MyXMLDoc.Active;

  XPath := '/restBooleanReturnType/result';

  iNodes := SelectNodes(MyXMLDoc.DocumentElement, XPath);
  if iNodes.Nodes[0].IsTextElement then
    if iNodes.Nodes[0].NodeValue = 'true' then
      Result := True;

  iNode := nil;
  iNodes := nil;
  MyXMLDoc := nil;
end;

function TMagROIRestUtility.AddROIGuidToList(XML: String): String;
var
  iNode: IXMLNode;
  iNodes: IXMLNodeList;
  MyXMLDoc: IXmlDocument;
  XPath: String;
  StreamXML: TStringStream;
  i: Integer;
  S: String;
  UrnObj: TUrnObj;
begin
  Result := '';

  if (Trim(XML) = '') or (XML = 'FAILED') then
    Exit;

  MyXMLDoc := TXmlDocument.Create(nil);

  StreamXML := TStringStream.Create(XML);
  try
    StreamXML.Position := 0;
    MyXMLDoc.LoadFromStream(StreamXML);
  finally
    StreamXML.Free;
  end;

  MyXMLDoc.Active;

  XPath := '/roiRequestType/guid';
  iNodes := SelectNodes(MyXMLDoc.DocumentElement, XPath);
  if iNodes.Nodes[0].IsTextElement then
    Result := iNodes.Nodes[0].NodeValue
  else
    Result := '^';

  XPath := '/roiRequestType/patientId';
  iNodes := SelectNodes(MyXMLDoc.DocumentElement, XPath);
  if iNodes.Nodes[0].IsTextElement then
    Result := Result + '^' + iNodes.Nodes[0].NodeValue
  else
    Result := Result + '^';

  XPath := '/roiRequestType/resultUri';
  iNodes := SelectNodes(MyXMLDoc.DocumentElement, XPath);
  if iNodes.Nodes[0].IsTextElement then  
    Result := Result + '^' + iNodes.Nodes[0].NodeValue
  else
    Result := Result + '^';

  XPath := '/roiRequestType/status';
  iNodes := SelectNodes(MyXMLDoc.DocumentElement, XPath);
  if iNodes.Nodes[0].IsTextElement then
    Result := Result + '^' + iNodes.Nodes[0].NodeValue
  else
    Result := Result + '^';

  iNode := nil;
  iNodes := nil;
  MyXMLDoc := nil;
end;

//procedure TMagROIRestUtility.AddROIStatusToList(XML: String; var StatusList: TStringList);
//var
//  iNode: IXMLNode;
//  iNodes: IXMLNodeList;
//  MyXMLDoc: IXmlDocument;
//  NodeName: String;
//  NodeCount: Integer;
//  StreamXML: TStringStream;
//  i: Integer;
//  S: String;
//  XPath: String;
//  sGuid: String;
//  sPatID: String;
//  sPatName: String;
//  sPatSSN4: String;
//  sResultUri: String;
//  sStatus: String;
//  sErrorMessage: String;
//  sLastUpdated: String;
//  sExportQueue: String;
//
//begin
//  StatusList.Clear;
//
//  if (Trim(XML) = '') or (XML = 'FAILED') then
//    Exit;
//
//  MyXMLDoc := TXmlDocument.Create(nil);
//
//  StreamXML := TStringStream.Create(XML);
//
//  StreamXML.Position := 0;
//  MyXMLDoc.LoadFromStream(StreamXML);
//
//  MyXMLDoc.Active;
//
//  XPath := '/rOIRequestTypes/roiRequestType';
//
//  {Try and get back a list of job statuses}
//  iNodes := SelectNodes(MyXMLDoc.DocumentElement, XPath);
//
//  {If the count is zero, then this is a single Guid request type}
//  if iNodes.Count = 0 then
//  begin
//    XPath := '/roiRequestType';
//    iNodes := SelectNodes(MyXMLDoc.DocumentElement, XPath);
//  end;
//
//  NodeCount := iNodes.Count;
//
//  for i := 0 to NodeCount - 1 do
//  begin
//
//      nodeName := XPath + '/guid';
//      iNodes := SelectNodes(MyXMLDoc.DocumentElement, nodeName);
//      if iNodes.Nodes[i].IsTextElement then
//        sGuid := iNodes.Nodes[i].NodeValue
//      else
//        sGuid := '';
//
//      nodeName := XPath + '/patientId';
//      iNodes := SelectNodes(MyXMLDoc.DocumentElement, nodeName);
//      if iNodes.Nodes[i].IsTextElement then
//        sPatID := iNodes.Nodes[i].NodeValue
//      else
//        sPatID := '';
//
//      nodeName := XPath + '/patientName';
//      iNodes := SelectNodes(MyXMLDoc.DocumentElement, nodeName);
//      if iNodes.Nodes[i].IsTextElement then
//        sPatName := iNodes.Nodes[i].NodeValue
//      else
//        sPatName := '';
//
//      nodeName := XPath + '/patientSsn';
//      iNodes := SelectNodes(MyXMLDoc.DocumentElement, nodeName);
//      if iNodes.Nodes[i].IsTextElement then
//        sPatSSN4 := iNodes.Nodes[i].NodeValue
//      else
//        sPatSSN4 := '';
//
//      nodeName := XPath + '/resultUri';
//      iNodes := SelectNodes(MyXMLDoc.DocumentElement, nodeName);
//      if iNodes.Nodes[i].IsTextElement then
//        sResultUri := iNodes.Nodes[i].NodeValue
//      else
//        sResultUri := '';
//
//      nodeName := XPath + '/status';
//      iNodes := SelectNodes(MyXMLDoc.DocumentElement, nodeName);
//      if iNodes.Nodes[i].IsTextElement then
//        sStatus := iNodes.Nodes[i].NodeValue
//      else
//        sStatus := '';
//
//      nodeName := XPath + '/errorMessage';
//      iNodes := SelectNodes(MyXMLDoc.DocumentElement, nodeName);
//      if iNodes.Nodes[i].IsTextElement then
//        sErrorMessage := iNodes.Nodes[i].NodeValue
//      else
//        sErrorMessage := '';
//
//      nodeName := XPath + '/lastUpdateDate';
//      iNodes := SelectNodes(MyXMLDoc.DocumentElement, nodeName);
//      if iNodes.Nodes[i].IsTextElement then
//        sLastUpdated := iNodes.Nodes[i].NodeValue
//      else
//        sLastUpdated := '';
//
//      nodeName := XPath + '/exportQueue';
//      iNodes := SelectNodes(MyXMLDoc.DocumentElement, nodeName);
//      if iNodes.Nodes[i].IsTextElement then
//        sExportQueue := iNodes.Nodes[i].NodeValue
//      else
//        sExportQueue := '';
//
//      S :=           sErrorMessage;
//      S := S + '^' + sGuid;
//      S := S + '^' + sLastUpdated;
//      S := S + '^' + sPatId;
//      S := S + '^' + sPatName;
//      S := S + '^' + sPatSSN4;
//      S := S + '^' + sResultUri;
//      S := S + '^' + sStatus;
//      S := S + '^' + sExportQueue;
//
//      StatusList.Add(S);
//
//  end;
//
//  iNode := nil;
//  iNodes := nil;
//  MyXMLDoc := nil;
//  StreamXML.Free;
//end;

procedure TMagROIRestUtility.AddROIStatusToList(XML: String;
  var StatusList: TStringList);
begin

end;

procedure TMagROIRestUtility.AddROIStatusToListFromStream(XMLStream: TMemoryStream; var StatusList: TStringList);
var
  iNode: IXMLNode;
  iNodes: IXMLNodeList;
  MyXMLDoc: IXmlDocument;
  NodeName: String;
  NodeCount: Integer;
  i: Integer;
  S: String;
  XPath: String;
  sGuid: String;
  sPatID: String;
  sPatName: String;
  sPatSSN4: String;
  sResultUri: String;
  sStatus: String;
  sErrorMessage: String;
  sLastUpdated: String;
  sExportQueue: String;
//  vAppDataFolder : string;
begin
  StatusList.Clear;


  MyXMLDoc := TXmlDocument.Create(nil);

  XMLStream.Position := 0;
  MyXMLDoc.LoadFromStream(XMLStream);

  MyXMLDoc.Active;

{
  //p130T9 dmmn 2/7/13 - instead of hard coding the path, only save the file
  //if the temp folder path is available.
  vAppDataFolder := GetEnvironmentVariable('AppData');
  if vAppDataFolder <> '' then
  begin
    vAppDataFolder := vAppDataFolder + '\VistA\Imaging\temp';
    if DirectoryExists(vAppDataFolder) then
      MyXMLDoc.SaveToFile(vAppDataFolder + '\julianxml99.txt');
  end;
}

  XPath := '/rOIRequestTypes/roiRequestType';

  {Try and get back a list of job statuses}
  iNodes := SelectNodes(MyXMLDoc.DocumentElement, XPath);

  {If the count is zero, then this is a single Guid request type}
  if iNodes.Count = 0 then
  begin
    XPath := '/roiRequestType';
    iNodes := SelectNodes(MyXMLDoc.DocumentElement, XPath);
  end;

  NodeCount := iNodes.Count;

  for i := 0 to NodeCount - 1 do
  begin

      nodeName := XPath + '/guid';
      iNodes := SelectNodes(MyXMLDoc.DocumentElement, nodeName);
      if iNodes.Nodes[i].IsTextElement then
        sGuid := iNodes.Nodes[i].NodeValue
      else
        sGuid := '';

      nodeName := XPath + '/patientId';
      iNodes := SelectNodes(MyXMLDoc.DocumentElement, nodeName);
      if iNodes.Nodes[i].IsTextElement then
        sPatID := iNodes.Nodes[i].NodeValue
      else
        sPatID := '';

      nodeName := XPath + '/patientName';
      iNodes := SelectNodes(MyXMLDoc.DocumentElement, nodeName);
      try
        if iNodes.Nodes[i].IsTextElement then
          sPatName := iNodes.Nodes[i].NodeValue
        else
          sPatName := '';
      except
        sPatName := '...';
      end;

      nodeName := XPath + '/patientSsn';
      iNodes := SelectNodes(MyXMLDoc.DocumentElement, nodeName);
      try
        if iNodes.Nodes[i].IsTextElement then
          sPatSSN4 := iNodes.Nodes[i].NodeValue
        else
          sPatSSN4 := '';
      except
        sPatSSN4 := '...';
      end;

      nodeName := XPath + '/resultUri';
      iNodes := SelectNodes(MyXMLDoc.DocumentElement, nodeName);
      try
        if iNodes.Nodes[i].IsTextElement then
          sResultUri := iNodes.Nodes[i].NodeValue
        else
          sResultUri := '';
      except
        sResultUri := '...';
      end;

      nodeName := XPath + '/status';
      iNodes := SelectNodes(MyXMLDoc.DocumentElement, nodeName);
      try
        if iNodes.Nodes[i].IsTextElement then
          sStatus := iNodes.Nodes[i].NodeValue
        else
          sStatus := '';
      except
        sStatus := '...';
      end;

      nodeName := XPath + '/errorMessage';
      iNodes := SelectNodes(MyXMLDoc.DocumentElement, nodeName);
      try
        if iNodes.Nodes[i].IsTextElement then
          sErrorMessage := iNodes.Nodes[i].NodeValue
        else
          sErrorMessage := '';
      except
        sErrorMessage := '...';
      end;

      nodeName := XPath + '/lastUpdateDate';
      iNodes := SelectNodes(MyXMLDoc.DocumentElement, nodeName);
      try
        if iNodes.Nodes[i].IsTextElement then
          sLastUpdated := iNodes.Nodes[i].NodeValue
        else
          sLastUpdated := '';
      except
        sLastUpdated := '...';
      end;

      nodeName := XPath + '/exportQueue';
      iNodes := SelectNodes(MyXMLDoc.DocumentElement, nodeName);
      try
        if iNodes.Nodes[i].IsTextElement then
          sExportQueue := iNodes.Nodes[i].NodeValue
        else
          sExportQueue := '';
      except
        sExportQueue := '...';
      end;

      S :=           sErrorMessage;
      S := S + '^' + sGuid;
      S := S + '^' + sLastUpdated;
      S := S + '^' + sPatId;
      S := S + '^' + sPatName;
      S := S + '^' + sPatSSN4;
      S := S + '^' + sResultUri;
      S := S + '^' + sStatus;
      S := S + '^' + sExportQueue;

      StatusList.Add(S);

  end;

  iNode := nil;
  iNodes := nil;
  MyXMLDoc := nil;
end;

function TMagROIRestUtility.GetIDSValues(OutputList: String): Boolean;
var
  iNode: IXMLNode;
  iNodes: IXMLNodeList;
  MyXMLDoc: IXMLDocument;
  XPath: String;
  StreamXML: TStringStream;
  i: Integer;
  opPath : String;
begin

  Result := false;
  try
    try

      MyXMLDoc := TXmlDocument.Create(nil);
      MyXMLDoc.Active := True;

      StreamXML := TStringStream.Create(OutputList);
      try
        StreamXML.Position := 0;
        MyXMLDoc.LoadFromStream(StreamXML);
      finally
        StreamXML.Free;
      end;

      // retrieving application path
      XPath := '/services/Service[@type="ROI"]/ApplicationPath';
      iNodes := SelectNodes(MyXMLDoc.DocumentElement, XPath);

      i := 0;
      while i < iNodes.Count do
      begin
        IDSAppPath := iNodes.Nodes[i].NodeValue;
        Inc(i);
      end;

      //p130t10 dmmn 2/26/13 - retrieving operation paths
      //Since there can be multiple operation path type, it's reworked into a list.
      //The list will contain a name value pair for each item. The pair will
      //be type=operation path
      XPath := '/services/Service/Operation';
      iNodes := SelectNodes(MyXMLDoc.DocumentElement, XPath);
      i:= 0;
      if FROIOperationPaths = nil then
        FROIOperationPaths := TStringList.Create();
      FROIOperationPaths.Clear();

      // go through all the operation paths in the IDS list
      while i < iNodes.Count do
      begin
          opPath := iNodes.Nodes[i].ChildValues['OperationPath'];
          if opPath = '' then
            Exit;

          // store the operation path with its type
          opPath :=iNodes.Nodes[i].GetAttribute('type') + '=' + opPath;
          FROIOperationPaths.Add(opPath);

          Inc(i);
      end;

      //p130T10 dmmn 2/26/13 since we are only using 3 types at this point,
      //it's much better to check if the paths are available right here than later
      if (FROIOperationPaths.Count = 0)
        Or (FROIOperationPaths.IndexOfName('ROI') < 0)
        Or (FROIOperationPaths.IndexOfName('ExportQueue') < 0)
        Or (FROIOperationPaths.IndexOfName('Disclosure') < 0)then
      begin
        // the type is not available
        magAppMsg('s', 'TMagROIRestUtility.GetIDSValues: Missing operation paths', magmsgERROR);
        Result := false;
      end
      else
      begin
        Result := true;
      end;
    except
      On e: Exception Do
      begin
        Result := false;
        magAppMsg('s', 'TMagROIRestUtility.GetIDSValues: [' + e.Message + ']', magmsgERROR);
      end;
    end;
  finally
    iNode := nil;
    iNodes := nil;
    MyXMLDoc := nil;
  end;

end;

function TMagROIRestUtility.GetROIStatus(Guid: String): String;
var
  TransId: String;
  Idhttp: TIDHttp;
  OutputStream: TMemoryStream;
  Destination: String;
  QList: TStringList;
begin
  try
    Idhttp := nil;
    try
      Result := '';

      Idhttp := GetHttpClient();
      TransId := CreateTransactionId();
  //    OutputStream := TMemoryStream.Create();

      Idhttp.Request.Username := HTTPWebNodeUserName;
      Idhttp.Request.Password := HTTPWebNodePassword;
      Idhttp.Request.BasicAuthentication := True;

      OutputStream := GetStatusHandleBSE(Idhttp, Guid);

      // if there is some response other than 200 (OK), error!
      If Idhttp.ResponseCode = 200 Then
      Begin
        magAppMsg('s', 'TMagROIRestUtility.GetROIStatus: Response code is 200', magmsgDebug);
        OutputStream.Position := 0;

        QList := TStringlist.Create;
        try
          QList.LoadFromStream(OutputStream);
          Result := QList[0];
        finally
          QList.Free;
        end;
  //      FreeAndNil(OutputStream);
        magAppMsg('s', 'TMagROIRestUtility.GetROIStatus: Completed successfully', magmsgDebug);
      End

      Else
        If Idhttp.ResponseCode = 409 Then
        Begin
           // this probably never happens since it looks like 409 responses are exceptions
          Result := 'UNAVAILABLE';
        End
        Else
        Begin
          Result := 'FAILED';
        End;
    Except
      On e: Exception Do
      Begin
        If Idhttp.ResponseCode = 409 Then
        Begin
          magAppMsg('s', 'TMagROIRestUtility.GetROIStatus: 409 Exception [' + e.Message + ']', magmsgERROR);
          Result := 'UNAVAILABLE';
        End
        Else
        Begin
          magAppMsg('s', 'TMagROIRestUtility.GetROIStatus: Exception [' + e.Message + ']', magmsgERROR);
          Result := 'FAILED';
        End;
      End;
    End;
  finally
    FreeAndNil(OutputStream);
  end;
end;

procedure TMagROIRestUtility.GetDisclosureZip(URI: String; var MS: TMemoryStream);
var
  TransId: String;
  Idhttp: TIDHttp;
  OutputStream: TMemoryStream;
  Destination: String;
//  QList: TStringList;
begin
  try
  Idhttp := nil;
  try
    Idhttp := GetHttpClient();
    TransId := CreateTransactionId();
//    OutputStream := TMemoryStream.Create();

    Idhttp.Request.Username := HTTPWebNodeUserName;
    Idhttp.Request.Password := HTTPWebNodePassword;
    Idhttp.Request.BasicAuthentication := True;

    OutputStream := GetZipHandleBSE(Idhttp, URI);

    // if there is some response other than 200 (OK), error!
    If Idhttp.ResponseCode = 200 Then
    Begin
      magAppMsg('s', 'TMagROIRestUtility.GetDisclosureZip: Response code is 200', magmsgDebug);
      OutputStream.Position := 0;
      MS.LoadFromStream(OutputStream);
      MS.Position := 0;

      magAppMsg('s', 'TMagROIRestUtility.GetDisclosureZip: Completed successfully', magmsgDebug);
    End

    Else
      If Idhttp.ResponseCode = 404 Then   {/ P130 - JK 7/11/2012 /}
      Begin
        MS := nil;
      End;
  Except
    On e: Exception Do
    Begin
      If Idhttp.ResponseCode = 409 Then
      Begin
        magAppMsg('s', 'TMagROIRestUtility.GetDisclosureZip: 409 Exception [' + e.Message + ']', magmsgERROR);
        MS := nil;
      End
      Else
      Begin
        magAppMsg('s', 'TMagROIRestUtility.GetDisclosureZip: Exception [' + e.Message + ']', magmsgERROR);
        MS := nil;
      End;
    End;
  End;
  finally
    FreeAndNil(OutputStream);
  end;
end;

function TMagROIRestUtility.GetZipHandleBSE(Idhttp: TIDHttp; URI: String): TMemoryStream;
var
  bseAttemptCount: Integer;
  tryAgain: Boolean;
  TransId: String;
  tokenIndex: Integer;
  GetZipUrl: String;
begin

  URI := StringReplace(URI, '&amp;', '&', [rfReplaceAll, rfIgnoreCase]);

  GetZipUrl := 'http://' +
               VixServer + ':' + IntToStr(VixPort) + '/' +
               IDSAppPath +
               FROIOperationPaths.Values['Disclosure'];       //p130T10 dmmn 2/26/13 - use Disclosure operation path

  bseAttemptCount := 0;
  tryAgain := True;
  Result := TMemoryStream.Create;

  while tryAgain Do
  begin
    try
      bseAttemptCount := bseAttemptCount + 1;
      TransId := CreateTransactionId();
      if GSess.SecurityToken <> '' then
      begin
        Idhttp.Request.CustomHeaders.Values['xxx-securityToken'] := createSecurityToken();
      end
      else
      begin
        tokenIndex := Idhttp.Request.CustomHeaders.IndexOfName('xxx-securityToken');
        Idhttp.Request.CustomHeaders.Delete(tokenIndex);
      end;

      magAppMsg('s', 'TMagROIRestUtility.GetZipHandleBSE: Getting ROI zip file using URI [' + URI + '] from VIX with transId [' + TransId + '].', magmsgDebug);

      Idhttp.Request.CustomHeaders.Values['xxx-transaction-id'] := TransId;

      GetZipUrl := GetZipUrl + URI;

      Idhttp.Get(GetZipUrl, Result);

      tryAgain := False;

    except
      on E:Exception do
      begin
        tryAgain := False;

        if Idhttp.ResponseCode = 404 then  {/ P130 - JK 7/11/2012 /}
        begin
          magAppMsg('s', 'TMagROIRestUtility.GetZipHandleBSE: 404 returned. Zip file unavailable', MagmsgINFO);
        end
        else

        if Idhttp.ResponseCode = 412 then
        begin
          magAppMsg('s', 'TMagROIRestUtility.GetZipHandleBSE: 412 (EXPIRED BSE TOKEN) Exception getting image from URL [' + GetZipUrl + '], Exception [' + E.Message + '], attempting to get new token.', magmsgERROR);
          if bseAttemptCount < 3 then
          begin
            magAppMsg('s', 'TMagROIRestUtility.GetZipHandleBSE: Current BSE login attempt is ' + Inttostr(bseattemptCount) + ', try to get new token', MagmsgINFO);
            if Assigned(FSecurityTokenNeeded) then
            begin
              GSess.SecurityToken := FSecurityTokenNeeded;
              magAppMsg('s', 'TMagROIRestUtility.GetZipHandleBSE: Received new token ' + GSess.SecurityToken, MagmsgINFO);
              tryAgain := True;
            end
            else
            begin
              magAppMsg('s', 'TMagROIRestUtility.GetZipHandleBSE: FSecurityTokenNeeded not assigned, cannot get new token, clearing token to force CAPRI', MagmsgINFO);
              // clear the token so it will prevent BSE from working, will fall back to CAPRI method
              gsess.SecurityToken := '';
              tryAgain := True;
              raise Exception.Create(E.Message);
            end;
          end;

          if not tryAgain then
          begin
            magAppMsg('s', 'TMagROIRestUtility.GetZipHandleBSE: Could not get new token, cannot connect to remote site.', MagmsgINFO);
          end;
        end
        else {not 412 error}
        begin
          // not BSE Exception, some other exception type - raise this to parent
          raise Exception.Create('TMagROIRestUtility.GetZipHandleBSE: ' + E.Message);
        end;
      end;
    end; {try}
  end; {while}

end;

Function TMagROIRestUtility.GetStatusHandleBSE(Idhttp: TIDHttp; Guid: String): TMemoryStream;
var
  bseAttemptCount: Integer;
  tryAgain: Boolean;
  TransId: String;
  tokenIndex: Integer;
  GetStatusUrl: String;
begin

  GetStatusUrl := 'http://' +
                  VixServer + ':' + IntToStr(VixPort) + '/' +
                  IDSAppPath +
                  FROIOperationPaths.Values['ROI'] +       //p130T10 dmmn 2/26/13 - use ROI operation path
                  'status';

  bseAttemptCount := 0;
  tryAgain := True;
  Result := TMemoryStream.Create;

  while tryAgain Do
  begin
    try
      bseAttemptCount := bseAttemptCount + 1;
      TransId := CreateTransactionId();
      if GSess.SecurityToken <> '' then
      begin
        Idhttp.Request.CustomHeaders.Values['xxx-securityToken'] := createSecurityToken();
      end
      else
      begin
        tokenIndex := Idhttp.Request.CustomHeaders.IndexOfName('xxx-securityToken');
        Idhttp.Request.CustomHeaders.Delete(tokenIndex);
      end;

      magAppMsg('s', 'TMagROIRestUtility.GetStatusHandleBSE: Getting ROI job status for GUID [' + Guid + ']: REST URL [' + GetStatusUrl +
        '] from VIX with transId [' + TransId + '].', magmsgDebug);

      Idhttp.Request.CustomHeaders.Values['xxx-transaction-id'] := TransId;

      GetStatusUrl := GetStatusUrl + '/' + Guid;

      Idhttp.Get(GetStatusUrl, Result);

      tryAgain := False;

    except
      on E:Exception do
      begin
        tryAgain := False;

        if Idhttp.ResponseCode = 412 then
        begin
          magAppMsg('s', 'TMagROIRestUtility.GetStatusHandleBSE: 412 (EXPIRED BSE TOKEN) Exception getting image from url [' + GetStatusUrl + '], Exception [' + E.Message + '], attempting to get new token.', magmsgERROR);
          if bseAttemptCount < 3 then
          begin
            magAppMsg('s', 'TMagROIRestUtility.GetStatusHandleBSE: Current BSE login attempt is ' + Inttostr(bseattemptCount) + ', try to get new token', MagmsgINFO);
            if Assigned(FSecurityTokenNeeded) then
            begin
              GSess.SecurityToken := FSecurityTokenNeeded;
              magAppMsg('s', 'TMagROIRestUtility.GetStatusHandleBSE: Received new token ' + GSess.SecurityToken, MagmsgINFO);
              tryAgain := True;
            end
            else
            begin
              magAppMsg('s', 'TMagROIRestUtility.GetStatusHandleBSE: FSecurityTokenNeeded not assigned, cannot get new token, clearing token to force CAPRI', MagmsgINFO);
              // clear the token so it will prevent BSE from working, will fall back to CAPRI method
              gsess.SecurityToken := '';
              tryAgain := True;
              raise Exception.Create(E.Message);
            end;
          end;

          if not tryAgain then
          begin
            magAppMsg('s', 'TMagROIRestUtility.GetStatusHandleBSE: Could not get new token, cannot connect to remote site.', MagmsgINFO);
          end;
        end
        else {not 412 error}
        begin
          // not BSE Exception, some other exception type - raise this to parent
          raise Exception.Create('TMagROIRestUtility.GetStatusHandleBSE: ' + E.Message);
        end;
      end;
    end; {try}
  end; {while}
end;

end.
