Unit cMagImageUtility;

Interface

Uses
  Classes,
  //cMagLogManager,  {JK 10/5/2009 - Maggmsgu refactoring - deprecated unit}
  Idhttp,
  UMagClasses,
  Maggmsgu
  ;

//Uses Vetted 20090929:dialogs, umagutils, fmxutils

Type
  MagStorageProtocol = (MagStorageUNC, MagStorageHTTP);

Type
  TMagRemoteCredentials = Class
  Private
    FUserLocalDUZ: String;
    FUserSSN: String;
    FLocalSiteName: String;
    FLocalSiteNumber: String;
    FUserFullname: String;
  Public
    Property UserLocalDUZ: String Read FUserLocalDUZ Write FUserLocalDUZ;
    Property UserSSN: String Read FUserSSN Write FUserSSN;
    Property LocalSiteName: String Read FLocalSiteName Write FLocalSiteName;
    Property LocalSiteNumber: String Read FLocalSiteNumber Write FLocalSiteNumber;
    Property UserFullName: String Read FUserFullname Write FUserFullname;
  End;

Type
  TMagImageQualityItem = Class
  Public
    FDestinationFilename: String;
    FImageQuality: TMagImageQuality;

    Function GetImageQualityString(): String;
  End;

Type
  TMagImageUtility = Class

  Private
    // FOnLogEvent : TMagLogEvent;  {JK 10/5/2009 - Maggmsgu refactoring}//out in 94 keep
    FCredentialsInitialized: Boolean;
    FUserCredentials: TMagRemoteCredentials;
    FClientList: Tlist;
    FImageQualityList: Tlist;
    FImageCacheDirectory: String;

    //p94  JMW 11/25/2009 - properties needed for BSE support
    FSecurityTokenNeeded: TMagSecurityTokenNeededEvent;
    FApplicationType: TMagRemoteLoginApplication;
    FLocalBrokerPort: Integer;

    //procedure LogMsg(MsgType : String; Msg : String; Priority : TMagLogPriority = MagLogINFO);  {JK 10/5/2009 - MaggMsgu refactoring - remove old method}//out in 94 keep
    Function CreateTransactionId(): String;
    Function GetHttpClient(): TIDHttp;
    Procedure ReturnClientToList(HttpClient: TIDHttp);
    Procedure SetHttpClientCredentials(HttpClient: TIDHttp; UserCredentials: TMagRemoteCredentials);
    Procedure SetClientsCredentials(UserCredentials: TMagRemoteCredentials);
    Procedure AddImageAlternateQualityToList(Destination: String;
      Quality: TMagImageQuality);
    Function ConvertQuality(ImgQuality: String): TMagImageQuality;
    Procedure LoadImageAlternateQualityListFromCache();
    Procedure PersistImageAlternateQualityListToCache();
    Procedure ClearImageAlternateQualityList();
    Function GetImageTypeRequestString(ImgType: Integer): String;
    //p94 start
    Function createSecurityToken(): String;
    Function RequestImageHandleBSE(Idhttp: TIDHttp; URL: String): TMemoryStream;
	//p94 end
  Public
    Constructor Create();
    Destructor Destroy(); Override;
    Function MagcopyFile(Filename: String; Destination: String;
      ImgFormatType: Integer; IsTXTFile: Boolean = False): TMagImageTransferResult;
    Function DetermineStorageProtocol(Filename: String): MagStorageProtocol;
    Function MagHttpCopyFile(URL: String; Destination: String;
      IsTXTFile: Boolean; ImgFormatType: Integer): TMagImageTransferResult;
    Function MagUNCCopyFile(Filename: String; Destination: String): TMagImageTransferResult;
    Function ExtractUrlFileName(Const AUrl: String): String;
    Function MagFileExists(Filename: String): Boolean;
    Procedure DeleteFilesAndDirs(DirPath: String);
    Procedure SetUserCredentials(UserCredentials: TMagRemoteCredentials);
    Function IsUserCredentialsSet(): Boolean;
    Procedure ResetUserCredentials();
    Function GetImageAlternateQuality(Destination: String): TMagImageQuality;
    Procedure SetImageCacheDirectory(CacheDir: String);
	//p94 start
    Procedure setApplicationType(AppType: TMagRemoteLoginApplication);
    Procedure setSecurityTokenNeededHandler(SecurityTokenNeeded: TMagSecurityTokenNeededEvent);
    Procedure setLocalBrokerPort(BrokerPort: Integer);
	//p94 end.
    //property OnLogEvent : TMagLogEvent read FOnLogEvent write FOnLogEvent;  {JK 10/5/2009 - MaggMsgu refactoring - remove old method}//out in 94 keep

  End;

Function GetImageUtility(): TMagImageUtility;
Function GetImageQualityFromString(QualityString: String): TMagImageQuality;

Var
  MagImageUtility: TMagImageUtility;

Const
  MAG_IMAGE_ALTERNATE_QUALITY_FILENAME = 'MagAlternateImageQuality.txt';
  MAG_ALTERNATE_QUALITY_FILE_DELIMITER = '^';

Implementation

Uses
  Fmxutils,
  SysUtils,
  Umagutils8,
  UMagDefinitions
  ;

//Uses Vetted 20090929:StrUtils

Function GetImageUtility(): TMagImageUtility;
Begin
  If MagImageUtility = Nil Then
    MagImageUtility := TMagImageUtility.Create();
  Result := MagImageUtility;
End;

Constructor TMagImageUtility.Create();
Begin

  FCredentialsInitialized := False;
  FUserCredentials := Nil;
  FClientList := Tlist.Create();
  FImageQualityList := Tlist.Create();
  FImageCacheDirectory := '';
End;

Destructor TMagImageUtility.Destroy();
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
  ClearImageAlternateQualityList();
  If FImageQualityList <> Nil Then
  Begin
    FreeAndNil(FImageQualityList);
  End;
  Inherited;
End;

Function TMagImageUtility.IsUserCredentialsSet(): Boolean;
Begin
  Result := FCredentialsInitialized;
End;

Procedure TMagImageUtility.ResetUserCredentials();
Begin
  FCredentialsInitialized := False;
  FUserCredentials := Nil;
  SetClientsCredentials(Nil);
  PersistImageAlternateQualityListToCache();
End;

Procedure TMagImageUtility.SetUserCredentials(UserCredentials: TMagRemoteCredentials);
Begin
  If FCredentialsInitialized = True Then Exit;
  If UserCredentials = Nil Then Exit;
  FUserCredentials := UserCredentials;
  SetClientsCredentials(UserCredentials);
  FCredentialsInitialized := True;
End;

Function TMagImageUtility.MagcopyFile(Filename: String; Destination: String;
  ImgFormatType: Integer; IsTXTFile: Boolean = False): TMagImageTransferResult;
Begin
  If DetermineStorageProtocol(Filename) = MagStorageUNC Then
  Begin
    Result := MagUNCCopyFile(Filename, Destination);
  End
  Else
  Begin
    Result := MagHttpCopyFile(Filename, Destination, IsTXTFile, ImgFormatType);
  End;
End;

Function TMagImageUtility.DetermineStorageProtocol(Filename: String): MagStorageProtocol;
Var
  Fname: String;
Begin
  Fname := Uppercase(Filename);
  Result := MagStorageUNC;
  If Pos('HTTP', Fname) > 0 Then
  Begin
    Result := MagStorageHTTP;
  End;
End;

Function TMagImageUtility.MagHttpCopyFile(URL: String; Destination: String;
  IsTXTFile: Boolean; ImgFormatType: Integer): TMagImageTransferResult;
Var
  OutputStream: TMemoryStream;
  TransId: String;
  Idhttp: TIDHttp;
  CopyStatus: TMagImageCopyStatus;
  ImgQuality: TMagImageQuality;
  bseAttemptCount: Integer;  //94
  tryAgain: Boolean;         //94
Begin
  Idhttp := Nil;
  CopyStatus := IMAGE_COPIED;
  ImgQuality := UNKNOWN_IMG;
  Try
    Idhttp := GetHttpClient();
    TransId := CreateTransactionId();
    OutputStream := TMemoryStream.Create();
    // hard coded username and password to communicate with ViX server
    Idhttp.Request.Username := 'alexdelarge';
    Idhttp.Request.Password := '655321';
    Idhttp.Request.BasicAuthentication := True;
    Idhttp.Request.CustomHeaders.Values['xxx-contentTypeWithSubType'] := GetImageTypeRequestString(ImgFormatType);

    If IsTXTFile Then
      URL := URL + '&textFile=true';

    OutputStream := RequestImageHandleBSE(Idhttp, URL);

    // if there is some response other than 200 (OK), error!
    If Idhttp.ResponseCode = 200 Then
    Begin
      //LogMsg('s','Response code is 200, about to save to file', MagLogDEBUG);
      MagLogger.LogMsg('s', 'Response code is 200, about to save to file', MagLogDebug); {JK 10/5/2009 - MaggMsgu refactoring}
      OutputStream.SaveToFile(Destination);
      ImgQuality := ConvertQuality(Idhttp.Response.RawHeaders.Values['xxx-image-quality']);
      AddImageAlternateQualityToList(Destination, ImgQuality);
      FreeAndNil(OutputStream);
      //LogMsg('s','File saved', MagLogDEBUG);
      MagLogger.LogMsg('s', 'File saved', MagLogDebug); {JK 10/5/2009 - MaggMsgu refactoring}
    End

    Else
      If Idhttp.ResponseCode = 409 Then
      Begin
         // this probably never happens since it looks like 409 responses are exceptions
        CopyStatus := IMAGE_UNAVAILABLE;
      End
      Else
      Begin
        CopyStatus := IMAGE_FAILED;
      End;
  Except
    On e: Exception Do
    Begin
      If Idhttp.ResponseCode = 409 Then
      Begin
        //LogMsg('s','409 Exception getting image from url [' + url + '], Exception [' + e.Message + ']', MagLogERROR);
        MagLogger.LogMsg('s', '409 Exception getting image from url [' + URL + '], Exception [' + e.Message + ']', MagLogERROR); {JK 10/5/2009 - MaggMsgu refactoring}
        CopyStatus := IMAGE_UNAVAILABLE;
      End
      Else
      Begin
        //LogMsg('s','Exception getting image from url [' + url + '], Exception [' + e.Message + ']', MagLogERROR);
        MagLogger.LogMsg('s', 'Exception getting image from url [' + URL + '], Exception [' + e.Message + ']', MagLogERROR); {JK 10/5/2009 - MaggMsgu refactoring}
        CopyStatus := IMAGE_FAILED;
      End;
    End;
  End;
  Result := TMagImageTransferResult.Create(URL, Destination,
    ImgQuality, CopyStatus);
  ReturnClientToList(Idhttp);
End;

Function TMagImageUtility.MagUNCCopyFile(Filename: String; Destination: String): TMagImageTransferResult;
Var
  CopyStatus: TMagImageCopyStatus;
Begin
  CopyStatus := IMAGE_COPIED;
  Try
    CopyFile(Filename, Destination);
  Except
    On e: Exception Do
    Begin
      // log error
      //LogMsg('s', 'Error copying file from UNC path [' + filename + '], ' + e.Message, MagLogERROR);
      MagLogger.LogMsg('s', 'Error copying file from UNC path [' + Filename + '], ' + e.Message, MagLogERROR); {JK 10/5/2009 - MaggMsgu refactoring}
      CopyStatus := IMAGE_FAILED;
    End;
  End;
  Result := TMagImageTransferResult.Create(Filename, Destination, UNKNOWN_IMG, CopyStatus);
End;

//Function TMagImageUtility.ExtractUrlFileName(Const AUrl: String): String;
//Var
//  i: Integer;
//  Urn, Quality: String;
//Begin
//  //i := LastDelimiter('/', AUrl);
//  i := Pos('urn:vaimage:', AUrl);
//  If i > 0 Then
//    Urn := Copy(AUrl, i + 12, Length(AUrl) - (i))
//  Else
//    Urn := AUrl;
//  i := Pos('&', Urn);
//  Urn := Copy(Urn, 0, i - 1);
//
//  i := Pos('imageQuality=', AUrl);
//  Quality := Copy(AUrl, i + 13, Length(AUrl) - (i));
//  i := Pos('&', Quality);
//  Quality := Copy(Quality, 0, i - 1);
//  {Should maybe put something in here for the content type?}
//
//  Result := MagPiece(Urn, '-', 1) + '-' + MagPiece(Urn, '-', 2) + '_' + Quality;
//
//End;

{/ P117 - JK 11/12/2010 - NCAT - Enhancement. This function has been
   rewritten to make it map long URL names into legal Windows filenames
   in the local machine's cache. URLs from the DoD will not directly map
   into the maximum size of a Windows filename.  Instead, a mapping will
   occur that guarantees a 1-to-1 mapping and translation into a valid
   Windows filename. The local Windows file cache mapping is a session-supported
   data structure. /}
function TMagImageUtility.ExtractUrlFileName(Const AUrl: String): String;
begin
  Result := gsess.MagUrlMap.Find(AUrl);
  if Result = gsess.MagUrlMap.mapNotFound then
    MagLogger.Log(INFO, 'ExtractUrlFileName: ' + gsess.MagUrlMap.mapNotFound + ' looking up [' + AUrl + ']');
end;

Function TMagImageUtility.MagFileExists(Filename: String): Boolean;
Begin
  If DetermineStorageProtocol(Filename) = MagStorageHTTP Then
    Result := True // not doing a real check for web pages
  Else
  Begin
    Result := FileExists(Filename);
  End;
End;

Procedure TMagImageUtility.DeleteFilesAndDirs(DirPath: String);
Var
  Sr: TSearchRec;
  FileAttrs: Integer;
Begin
  FileAttrs := FaAnyFile;
  If FindFirst(DirPath + '\*.*', FileAttrs, Sr) = 0 Then
  Begin
    Repeat
      If (Sr.Name <> '.') And (Sr.Name <> '..') Then
      Begin
        If Sr.Attr = Fadirectory Then
        Begin
          DeleteFilesAndDirs(DirPath + '\' + Sr.Name);
          RemoveDir(DirPath + '\' + Sr.Name);
        End
        Else
        Begin
          DeleteFile(DirPath + '\' + Sr.Name)
        End;
      End;

    Until FindNext(Sr) <> 0;
    FindClose(Sr);
  End;

End;

{JK 10/5/2009 - MaggMsgu refactoring - remove old method}//out in 94 keep
//procedure TMagImageUtility.LogMsg(MsgType : String; Msg : String; Priority : TMagLogPriority = MagLogINFO);
//begin
//  if Assigned(OnLogEvent) then
//    OnLogEvent(self, MsgType, Msg, Priority);
//end;

Function TMagImageUtility.CreateTransactionId(): String;
Var
  Guid: TGuid;
Begin
  CreateGUID(Guid);
  Result := GUIDToString(Guid);
End;

Function TMagImageUtility.GetHttpClient(): TIDHttp;
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

Procedure TMagImageUtility.ReturnClientToList(HttpClient: TIDHttp);
Begin
  If HttpClient = Nil Then
    Exit;
  If FClientList = Nil Then
    FClientList := Tlist.Create();
  FClientList.Add(HttpClient);
End;

Procedure TMagImageUtility.SetHttpClientCredentials(HttpClient: TIDHttp; UserCredentials: TMagRemoteCredentials);
Begin
  If UserCredentials = Nil Then
  Begin
    HttpClient.Request.CustomHeaders.Clear();
  End
  Else
  Begin
    HttpClient.Request.CustomHeaders.Add('xxx-duz: ' + UserCredentials.UserLocalDUZ);
    HttpClient.Request.CustomHeaders.Add('xxx-fullname: ' + UserCredentials.UserFullName);
    HttpClient.Request.CustomHeaders.Add('xxx-sitename: ' + UserCredentials.LocalSiteName);
    HttpClient.Request.CustomHeaders.Add('xxx-sitenumber: ' + UserCredentials.LocalSiteNumber);
    HttpClient.Request.CustomHeaders.Add('xxx-ssn: ' + UserCredentials.UserSSN);
    HttpClient.Request.CustomHeaders.Add('xxx-transaction-id: ');
  End;
End;

Procedure TMagImageUtility.SetClientsCredentials(UserCredentials: TMagRemoteCredentials);
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

Function TMagImageUtility.GetImageAlternateQuality(Destination: String): TMagImageQuality;
Var
  i: Integer;
  CurQuality: TMagImageQualityItem;
Begin
  Result := NOT_FOUND_IMG;
  For i := 0 To FImageQualityList.Count - 1 Do
  Begin
    CurQuality := FImageQualityList[i];
    If CurQuality.FDestinationFilename = Destination Then
    Begin
      Result := CurQuality.FImageQuality;
      Exit;
    End;
  End;
End;

Procedure TMagImageUtility.AddImageAlternateQualityToList(Destination: String;
  Quality: TMagImageQuality);
Var
  CurQuality: TMagImageQualityItem;
  FoundQuality: TMagImageQuality;
Begin
  FoundQuality := GetImageAlternateQuality(Destination);
  If FoundQuality <> NOT_FOUND_IMG Then
    Exit;
  CurQuality := TMagImageQualityItem.Create();
  CurQuality.FDestinationFilename := Destination;
  CurQuality.FImageQuality := Quality;
  FImageQualityList.Add(CurQuality);
End;

Function TMagImageUtility.ConvertQuality(ImgQuality: String): TMagImageQuality;
Begin
  Result := UNKNOWN_IMG;
  If ImgQuality = '20' Then
    Result := THUMBNAIL_IMG
  Else
    If ImgQuality = '70' Then
      Result := REFERENCE_IMG
    Else
      If (ImgQuality = '90') Or (ImgQuality = '100') Then
        Result := DIAGNOSTIC_IMG;
End;

Procedure TMagImageUtility.SetImageCacheDirectory(CacheDir: String);
Begin
  FImageCacheDirectory := CacheDir;
  LoadImageAlternateQualityListFromCache();
End;

Procedure TMagImageUtility.LoadImageAlternateQualityListFromCache();
Var
  Fname: String;
  i: Integer;
  CurQuality: TMagImageQualityItem;
  ImageQualityStringList: TStrings;
  StringLine: String;
  DestinationFilename: String;
  ImgQuality: TMagImageQuality;
Begin
  If FImageQualityList <> Nil Then
  Begin
    ClearImageAlternateQualityList();
    If FImageCacheDirectory <> '' Then
    Begin
      Fname := FImageCacheDirectory + '\' + MAG_IMAGE_ALTERNATE_QUALITY_FILENAME;
      If Not FileExists(Fname) Then
      Begin
        //LogMsg('s','Image Alternate quality list file [' + fname +
        //'] does not exist, cannot load file.', MagLogWARN);
        MagLogger.LogMsg('s', 'Image Alternate quality list file [' + Fname +
          '] does not exist, cannot load file.', MagLogWARN); {JK 10/5/2009 - MaggMsgu refactoring}
        Exit;
      End;
      ImageQualityStringList := Tstringlist.Create();
      ImageQualityStringList.LoadFromFile(Fname);
      For i := 0 To ImageQualityStringList.Count - 1 Do
      Begin
        StringLine := ImageQualityStringList[i];
        DestinationFilename :=
          MagPiece(StringLine, MAG_ALTERNATE_QUALITY_FILE_DELIMITER, 1);
        ImgQuality :=
          GetImageQualityFromString(MagPiece(StringLine, MAG_ALTERNATE_QUALITY_FILE_DELIMITER, 2));
        AddImageAlternateQualityToList(DestinationFilename, ImgQuality);
      End;
    End;
  End;
End;

Procedure TMagImageUtility.PersistImageAlternateQualityListToCache();
Var
  i: Integer;
  CurQuality: TMagImageQualityItem;
  ImageQualityStringList: TStrings;
  Fname: String;
Begin
  If (FImageQualityList <> Nil) And (FImageCacheDirectory <> '') Then
  Begin
    If Not Directoryexists(FImageCacheDirectory) Then
    Begin
      //LogMsg('s','Image Cache Directory [' + FImageCacheDirectory +
      //  '] does not exist, cannot persist image alternate quality list to disk.', MagLogWARN);
      MagLogger.LogMsg('s', 'Image Cache Directory [' + FImageCacheDirectory +
        '] does not exist, cannot persist image alternate quality list to disk.', MagLogWARN); {JK 10/5/2009 - MaggMsgu refactoring}
      Exit;
    End;
    Try
      Fname := FImageCacheDirectory + '\' + MAG_IMAGE_ALTERNATE_QUALITY_FILENAME;
      ImageQualityStringList := Tstringlist.Create();
      For i := 0 To FImageQualityList.Count - 1 Do
      Begin
        CurQuality := FImageQualityList[i];
        ImageQualityStringList.Add(CurQuality.FDestinationFilename +
          MAG_ALTERNATE_QUALITY_FILE_DELIMITER + CurQuality.GetImageQualityString());
      End;
      ImageQualityStringList.SaveToFile(Fname);

    Except
      On e: Exception Do
      Begin
        //LogMsg('s','Exception persisting alternate image quality file, ' + e.Message, MagLogERROR);
        MagLogger.LogMsg('s', 'Exception persisting alternate image quality file, ' + e.Message, MagLogERROR); {JK 10/5/2009 - MaggMsgu refactoring}
      End;
    End;

  End;

End;

Procedure TMagImageUtility.ClearImageAlternateQualityList();
Var
  i: Integer;
  CurQuality: TMagImageQualityItem;
Begin
  If FImageQualityList <> Nil Then
  Begin
    For i := 0 To FImageQualityList.Count - 1 Do
    Begin
      CurQuality := FImageQualityList[i];
      FreeAndNil(CurQuality);
    End;
    FImageQualityList.Clear();
  End;
End;

Function TMagImageQualityItem.GetImageQualityString(): String;
Begin
  Result := 'UNKNOWN';
  Case Self.FImageQuality Of
    THUMBNAIL_IMG:
      Result := 'THUMBNAIL';
    REFERENCE_IMG:
      Result := 'REFERENCE';
    DIAGNOSTIC_IMG:
      Result := 'DIAGNOSTIC';
    UNKNOWN_IMG:
      Result := 'UNKNOWN';
    NOT_FOUND_IMG:
      Result := 'NOT_FOUND';
  End;
End;

Function GetImageQualityFromString(QualityString: String): TMagImageQuality;
Begin
  Result := UNKNOWN_IMG;
  If QualityString = 'THUMBNAIL' Then
    Result := THUMBNAIL_IMG
  Else
    If QualityString = 'REFERENCE' Then
      Result := REFERENCE_IMG
    Else
      If QualityString = 'DIAGNOSTIC' Then
        Result := DIAGNOSTIC_IMG
      Else
        If QualityString = 'NOT_FOUND' Then
          Result := NOT_FOUND_IMG;
End;

{
  Create the 4-part mime type request string based on the image type of the
  image. Assume the image requested is reference quality. if its actually a
  thumbnail then the VIX will ignore this piece of the request (won't match
  other part) and should still work.  Not sure if this is so good for diagnostic
  images however, will need to test.

  This function will only return a value for image types that might have a
  4 part mime type (3, 100 - Radiology images). Otherwise it returns an empty
  string and the VIX ignores it.
}

Function TMagImageUtility.GetImageTypeRequestString(ImgType: Integer): String;
Begin
  Result := '';
  // maybe only do image types that might have a 4 part mime (dicom!)
  Case ImgType Of
//    1, 9, 15, 17, 18, 19:
//      result := 'image/jpeg,image/tiff,image/bmp';
    3, 100:
      Result := 'application/dicom/image/j2k,image/j2k,application/dicom,image/x-targa,*/*';
  End;
End;

//p94
Procedure TMagImageUtility.setApplicationType(AppType: TMagRemoteLoginApplication);
Begin
  Self.FApplicationType := AppType;
End;

Procedure TMagImageUtility.setSecurityTokenNeededHandler(SecurityTokenNeeded: TMagSecurityTokenNeededEvent);
Begin
  Self.FSecurityTokenNeeded := SecurityTokenNeeded;
End;

Procedure TMagImageUtility.setLocalBrokerPort(BrokerPort: Integer);
Begin
  FLocalBrokerPort := BrokerPort;
End;

Function TMagImageUtility.createSecurityToken(): String;
Begin
  Result := 'VISTA IMAGING DISPLAY';
  If FApplicationType = magRemoteAppTeleReader Then
    Result := 'VISTA IMAGING TELEREADER';

  Result := Result + '^' + gsess.SecurityToken + '^' +
    PrimarySiteStationNumber + '^' + Inttostr(FLocalBrokerPort);
End;

//p94
Function TMagImageUtility.RequestImageHandleBSE(Idhttp: TIDHttp; URL: String): TMemoryStream;
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
      MagLogger.LogMsg('s', 'Requesting image URL [' + URL +
        '] from VIX with transId [' + TransId + '].', MagLogDebug);

      Idhttp.Request.CustomHeaders.Values['xxx-transaction-id'] := TransId;
      Idhttp.Get(URL, Result);
      tryAgain := False;
    Except
      On e: Exception Do
      Begin
        tryAgain := False;
        If Idhttp.ResponseCode = 412 Then
        Begin
          MagLogger.LogMsg('s', '412 (EXPIRED BSE TOKEN) Exception getting image from url [' + URL + '], Exception [' + e.Message + '], attempting to get new token.', MagLogERROR);
          If bseattemptCount < 3 Then
          Begin
            MagLogger.LogMsg('s', 'Current BSE login attempt is ' + Inttostr(bseattemptCount) + ', try to get new token', MagLogINFO); {JK 10/6/2009 - Maggmsgu refactoring}
            If Assigned(FSecurityTokenNeeded) Then
            Begin
              GSess.SecurityToken := FSecurityTokenNeeded;
              MagLogger.LogMsg('s', 'Received new token ' + GSess.SecurityToken, MagLogINFO);
              tryAgain := True;
            End
            Else
            Begin
              MagLogger.LogMsg('s', 'FSecurityTokenNeeded not assigned, cannot get new token, clearing token to force CAPRI', MagLogINFO); {JK 10/6/2009 - Maggmsgu refactoring}
              // clear the token so it will prevent BSE from working, will fall back to CAPRI method
              gsess.SecurityToken := '';
              tryAgain := True;
              Raise Exception.Create(e.Message);
            End;
          End;
          If Not tryAgain Then
          Begin
            MagLogger.LogMsg('s', 'Could not get new token, cannot connect to remote site.', MagLogINFO); {JK 10/6/2009 - Maggmsgu refactoring}
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

End.
