{
  Package: MAG - VistA Imaging
  WARNING: Per VHA Directive 2004-038, this routine should not be modified.
  Date Created: October 5, 2009
  Site Name:  Washington OI Field Office, Silver Spring, MD
  Developer:  Julian Werfel
  Description:
    Web Service implementation of the remote image view broker. This
    communicates with the VistA Imaging Exchange (VIX) server to retrieve
    remote patient information from VA and DOD sites. This uses the version 4
    interface between the ViX and the client which will support ViX to ViX.

    10/8/2010 JMW Updated for Patch 106 with Delphi 2007.  WS interface
    regenerated with Delphi 2007, caused a few changes to be made here, see
    comments below

    New for version 5:
      - pass through method which allows calling any RPC through the VIX
      without needing to modify the VIX interface. This method is not currently
      implemented anywhere because it has not been needed yet. In the event
      more data is needed from the VIX, this passthrough method in the WSDL
      interface can be used to get raw RPC results through the VIX without
      modifying the VIX.
        To use this method, call WSBroker.remoteMethodPassthrough with the
        appropriate parameters.

        Here is an example of using this method to make an RPC call to a remote
        site:

  var
    params : remoteMethodPassthrough;
    response : remoteMethodPassthroughResponse;
    p : remoteMethodParameter;
    m : multipleValue;
  begin
    params := remoteMethodPassthrough.Create();
    params.credentials := CreateUserCredentials;  // always need credentials
    params.site_id := '660'; // site to make query to
    params.inputParameters := RemoteMethodInputParameterType.Create();

    params.methodName := 'MAG4 IMAGE LIST'; // RPC call
    setLength(p, 5); // number of input parameters

    p[0] := RemoteMethodParameterType.Create;
    p[0].parameterType := LITERAL;
    p[0].parameterIndex := 0; // must specify the parameter index (order of parameters)
    p[0].parameterValue := RemoteMethodParameterValueType.Create();
    p[0].parameterValue.value := 'E';

    p[1] := RemoteMethodParameterType.Create;
    p[1].parameterType := LITERAL;
    p[1].parameterIndex := 1; // must specify the parameter index (order of parameters)
    p[1].parameterValue := RemoteMethodParameterValueType.Create();
    p[1].parameterValue.value := '';

    p[2] := RemoteMethodParameterType.Create;
    p[2].parameterType := LITERAL;
    p[2].parameterIndex := 2; // must specify the parameter index (order of parameters)
    p[2].parameterValue := RemoteMethodParameterValueType.Create();
    p[2].parameterValue.value := '';

    p[3] := RemoteMethodParameterType.Create;
    p[3].parameterType := LITERAL;
    p[3].parameterIndex := 3; // must specify the parameter index (order of parameters)
    p[3].parameterValue := RemoteMethodParameterValueType.Create();
    p[3].parameterValue.value := '';

    p[4] := RemoteMethodParameterType.Create;
    p[4].parameterType := LIST;  // multiple type
    p[4].parameterIndex := 4; // must specify the parameter index (order of parameters)
    p[4].parameterValue := RemoteMethodParameterValueType.Create();
    p[4].parameterValue.multipleValue := RemoteMethodParameterMultipleType.Create;
    setLength(m, 2); // size of multiples
    m[0] := 'IXCLASS^^CLIN^CLIN/ADMIN^ADMIN/CLIN';
    m[1] := 'IDFN^^959';
    p[4].parameterValue.multipleValue.multipleValue := m;

    params.inputParameters.remoteMethodParameter := p;
    params.transaction_id := createTransactionId; // always needed
    // call method, response will be a string
    response := WSBroker.remoteMethodPassthrough(params);

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
Unit cMagRemoteWSBroker_v5;

Interface

Uses
  IMagRemoteBrokerInterface,
  Classes,
  UMagClasses,
//cMagLogManager,  {JK 10/5/2009 - Maggmsgu refactoring - deprecated unit}
  Maggmsgu,
  imagingClinicalDisplaySOAP_v5,
  cMagBaseRemoteWSBroker,
  SysUtils,
  InvokeRegistry,
  soaphttptrans,
  wininet
  ;

Type
  TMagRemoteWSBrokerV5 = Class(TMagBaseRemoteWSBroker)
  Private
    WSBroker: ImageClinicalDisplayMetadata;

    Function ConvertToFilter(Pkg, Cls, Types, Event, Spc, FrDate, ToDate, Origin: String): FilterType;
    Function CreateUserCredentials(): UserCredentials;
    Function ConvertEventType(EType: TMagImageAccessEventType): EventType;

    Procedure OnBeforePostEvent(Const HTTPReqResp: THTTPReqResp; Data: Pointer);

    // JMW 11/24/2009 - p94 - new methods to handle BSE.
    Function handleBSEException(e: Exception; attemptCount: Integer): Boolean;
    Function callWSMethodWithBSE(Method: TMagRemoteWSBrokerWrapper; Input: TRemotable): TRemotable;
    // JMW 10/8/2010 P106 see description of this method below
    Function callGetStudyImageListWithBSE(Input : GetStudyImageList) : FatImagesType2;
    Procedure pingServerWrapper(Input: TRemotable; Var Response: TRemotable);
    Procedure getPatientStudyListWrapper(Input: TRemotable; Var Response: TRemotable);
    Procedure getMagDevFieldsWrapper(Input: TRemotable; Var Response: TRemotable);
    Procedure getImageGlobalLookupWrapper(Input: TRemotable; Var Response: TRemotable);
    Procedure postImageAccessEventWrapper(Input: TRemotable; Var Response: TRemotable);
    Procedure getImageInformationWrapper(Input: TRemotable; Var Response: TRemotable);
    Procedure getStudyReportWrapper(Input: TRemotable; Var Response: TRemotable);
  Public

    {Constructor to create each remote broker object }
    Constructor Create(Site: TVistaSite; LocalVixURL:
      String; ImagingService: TMagImagingService;
      WorkstationID: String; localBrokerPort: Integer;
      SecurityTokenNeeded: TMagSecurityTokenNeededEvent);

    Destructor Destroy; Override;

    {Connect this remote site}
    Function Connect(UserFullName: String; UserLocalDUZ: String; UserSSN: String): Boolean; Override;

    {}
    Function GetPatientStudies(Pkg, Cls, Types, Event, Spc,
      FrDate, ToDate, Origin: String; Var Results: TStrings; Var Partial_Results: Boolean; Var Partial_Msg: String): TMagPatientStudyResponse; Override; {/ P117 NCAT - JK 11/30/2010 /}
    Procedure GetImageGlobalLookup(Ien: String; Var Rlist: TStrings); Override;
    Procedure GetMagDevFields(Ien, Flags: String; Var Output: Tstringlist); Override;
    Procedure LogCopyAccess(IObj: TImageData; Msg: String;
      EventType: TMagImageAccessEventType); Override;
    Procedure GetImageInformation(IObj: TImageData; Var Output: TStrings); Override;
    Function Getreport(IObj: TImageData): TStrings; Override;
    Procedure LogOfflineImageAccess(IObj: TImageData); Override;
    Procedure LogAction(Msg: String); Override;
    Function QueImage(ImgType: String; IObj: TImageData): TStrings; Override;
    Function QueImageGroup(Images: String; IObj: TImageData): String; Override;
    Procedure GetImageGroup(IObj: TImageData; NoQAcheck: Boolean; Output: TStrings); Override;

    Procedure RPMagTeleReaderUnreadlistGet(Var t: TStrings;
      AcquisitionPrimaryDivision, Sitecode, SpecialtyCode, ProcedureStrings,
      LastUpdate, UserDUZ, LocalSiteCode, SiteTimeOut, StatusOptions: String); Override;

    Procedure RPMagTeleReaderUnreadlistLock(Var Xmsg: String;
      AcquisitionPrimaryDivision, AcquisitionSiteCode, ItemID, LockUnlockValue,
      UserFullName, UserInitials, LocalDUZ, LocalSiteCode: String); Override;

  End;

Implementation
Uses
  FMagPatAccess,
  Magremoteinterface,
  SOAPHTTPClient,
  UMagDefinitions,
  Umagutils8
  ;

Constructor TMagRemoteWSBrokerv5.Create(Site: TVistaSite;
  LocalVixURL: String; ImagingService: TMagImagingService;
  WorkstationID: String; localBrokerPort: Integer;
  SecurityTokenNeeded: TMagSecurityTokenNeededEvent);
Var
  HTTPRIO: THTTPRIO;
Begin
  FSite := Site;
  FImagingService := ImagingService;
  FLocalViXURL := LocalVixURL + '/' + FImagingService.ApplicationPath + '/';
  HTTPRIO := THTTPRIO.Create(Nil);
  HTTPRIO.HTTPWebNode.Username := 'alexdelarge';
  HTTPRIO.HTTPWebNode.Password := '655321';
  HTTPRIO.HTTPWebNode.OnBeforePost := OnBeforePostEvent;
  WSBroker := GetImageClinicalDisplayMetadata(False, FLocalViXURL + FImagingService.MetadataPath, HTTPRIO);
  FStudyList := Tlist.Create();
  FPatientStatus := STATUS_PATIENTINACTIVE;
  FServerStatus := STATUS_DISCONNECTED;
  FWorkstationID := WorkstationID;
  FLocalBrokerPort := localBrokerPort;
  FSecurityTokenNeeded := SecurityTokenNeeded;
End;

Destructor TMagRemoteWSBrokerV5.Destroy;
Begin
  If FStudyList <> Nil Then
    FreeAndNil(FStudyList);
  If FSite <> Nil Then
    FreeAndNil(FSite);
  Inherited;
End;

Function TMagRemoteWSBrokerV5.Connect(UserFullName: String; UserLocalDUZ: String; UserSSN: String): Boolean;
Var
  PingServerRequest: PingServer;
  PingServerResponse: PingServerType2;
Begin
  FUserFullname := UserFullName;
  FUserDUZ := UserLocalDUZ;
  FUserSSN := UserSSN;

  PingServerRequest := PingServer.Create();
  PingServerRequest.ClientWorkstation := FWorkstationID;
  PingServerRequest.RequestSiteNumber := FSite.SiteNumber;

  Try
    //LogMsg('s', 'Pinging VIX at URL [' + FLocalVIXURL +
    //  FImagingService.MetadataPath + '] using WS Broker class [' +
    //  self.ClassName + '] to connect to site [' + FSite.SiteNumber + ']',
    //  MagLogInfo);

    MagLogger.LogMsg('s', 'Pinging VIX at URL [' + FLocalViXURL +
      FImagingService.MetadataPath + '] using WS Broker class [' +
      Self.ClassName + '] to connect to site [' + FSite.SiteNumber + ']',
      MagLogINFO); {JK 10/6/2009 - Maggmsgu refactoring}

    PingServerResponse := (callWSMethodWithBSE(pingserverwrapper, TRemotable(PingServerRequest)) As PingServerType2);

    If PingServerResponse.PingResponse = SERVER_READY Then
    Begin
      FPatientStatus := STATUS_PATIENTACTIVE;
      FServerStatus := STATUS_CONNECTED;
      Result := True;
    End
    Else
    Begin
      //LogMsg('s','ViX Server status UNAVAILABLE on connect (' + FSite.VixServer + ', ' + inttostr(FSite.VistaPort) + ') through local ViX', MagLogINFO);
      MagLogger.LogMsg('s', 'ViX Server status UNAVAILABLE on connect (' + FSite.VixServer + ', ' +
        Inttostr(FSite.VistaPort) + ') through local ViX', MagLogINFO); {JK 10/6/2009 - Maggmsgu refactoring}
      Result := False;
      FPatientStatus := STATUS_PATIENTINACTIVE;
      FServerStatus := STATUS_DISCONNECTED;
    End;
  Except
    On e: Exception Do
    Begin
      //LogMsg('s','Exception Connecting to ViX server (' + FSite.VixServer + ', ' + inttostr(FSite.VistaPort) + ') Through local Vix, Exception=[' + e.Message + ']');
      MagLogger.LogMsg('s', 'Exception Connecting to ViX server (' + FSite.VixServer + ', ' +
        Inttostr(FSite.VistaPort) + ') Through local Vix, Exception=[' + e.Message + ']'); {JK 10/6/2009 - Maggmsgu refactoring}
      Result := False;
      FPatientStatus := STATUS_PATIENTINACTIVE;
      FServerStatus := STATUS_DISCONNECTED;
    End;
  End;
  // mock connect? verify able to connect? ping server? do what?
End;

Function TMagRemoteWSBrokerV5.GetPatientStudies(Pkg, Cls, Types, Event, Spc,
  FrDate, ToDate, Origin: String; Var Results: TStrings; Var Partial_Results: Boolean; Var Partial_Msg: String): TMagPatientStudyResponse; {/ P117 NCAT - JK 11/30/2010 /}
Var
  TransId: TransactionIdentifierType;
  SiteID: String;
  Study: ShallowStudyType;
  i: Integer;
  Filter: FilterType;
  StudyString: String;
  ImageURL: String;
  AbsImgUrlString: String;
  FullimgUrlString, DiagImgUrlString: String;

  ReqParam: GetPatientShallowStudyList;

  Studies: ShallowStudiesStudiesType;
  StudyImageType: String;
  Response: ShallowStudiesResponseType2;

  sensitiveCheckDone: Boolean;
  sensitiveMsg: Tstringlist;
Begin
  Result := MagStudyResponseException;
  // convert the filter to a FilterType (for WS call)
  Filter := ConvertToFilter(Pkg, Cls, Types, Event, Spc, FrDate, ToDate, Origin);
  ImageURL := FLocalViXURL + FImagingService.ImagePath + '?'; // 'xchange/xchange?';

  SiteID := FSite.SiteNumber;

  ReqParam := GetPatientShallowStudyList.Create();
  ReqParam.transaction_id := TransId;
  ReqParam.site_id := SiteID;
  ReqParam.Patient_id := FPatientICNWithChecksum;
  ReqParam.Filter := Filter;

  If Results = Nil Then
    Results := Tstringlist.Create();

  sensitiveCheckDone := False;
  Response := Nil;
  While Not sensitiveCheckDone Do
  Begin
    ReqParam.authorizedSensitivityLevel := FCurrentPatientSensitiveLevel;

    //LogMsg('s', 'Getting patient study list with sensitive code [' +
    //  inttostr(FCurrentPatientSensitiveLevel) + ']', MagLogInfo);
    MagLogger.LogMsg('s', 'Getting patient study list with sensitive code [' +
      Inttostr(FCurrentPatientSensitiveLevel) + ']', MagLogINFO); {JK 10/6/2009 - Maggmsgu refactoring}
    // execute the Web Service to get the studies
    Try
      Magremoteinterface.RIVNotifyAllListeners(Nil, 'IMAGE_COPY_STARTED', '');
      Try
        Response := (callWSMethodWithBSE(getPatientStudyListWrapper, ReqParam) As ShallowStudiesResponseType2);
      Except
        On e: Exception Do
        Begin
          Result := MagStudyResponseException;
          FImageCount := 0;
          //LogMsg('s','Exception getting studies from [' + FSite.SiteNumber + '], Exception [' + e.Message + ']');
          MagLogger.LogMsg('s', 'Exception getting studies from [' + FSite.SiteNumber + '], Exception [' +
            e.Message + ']'); {JK 10/6/2009 - Maggmsgu refactoring}
          Results.Add('1^Class: ' + Cls + ' - ');
          // add the header parameters
          Results.Add('Item^Site^Note Title^Proc DT^Procedure^# Img^Short Desc^Pkg^Class^Type^Specialty^Event^Origin^Cap Dt^Cap by^Image ID');
          If Pos('SocketTimeoutException', e.Message) > 1 Then
            Result := MagStudyResponseTimeout;
          Exit;
        End;
      End;
    Finally
      Magremoteinterface.RIVNotifyAllListeners(Nil, 'IMAGE_COPY_COMPLETE', '');
    End;

    {/p117 JMW 10/21/2010 P106/P117  u6
       In Delphi 2007, if both the errors and studies are nil, then the response.result
       object is nil, so need to check for that}
       {was AccViola here.    new if seemed to fix it.}
    //If Response.Result.error <> Nil Then     //117 u6-out       {CodeCR732}
     If (response.result <> nil) and (Response.Result.error <> Nil) Then  //117 u6-in
    Begin
      sensitiveMsg := Tstringlist.Create();
      sensitiveMsg.Add(Response.Result.error.ErrorMessage);
      Case Response.Result.error.ErrorCode Of
        1:
          Begin
            FrmPatAccess.executeForRemoteWSSite(Self, sensitiveMsg,
              1, GetSiteName());
            If FCurrentPatientSensitiveLevel < 1 Then
              FCurrentPatientSensitiveLevel := 1;
          End;
        2:
          Begin
            If FrmPatAccess.executeForRemoteWSSite(Self, sensitiveMsg,
              2, FSite.SiteName) Then
            Begin
            //LogMsg('s', 'User has chosen to view restricted patient @ ' + getSiteName());
              MagLogger.LogMsg('s', 'User has chosen to view restricted patient @ ' + GetSiteName()); {JK 10/6/2009 - Maggmsgu refactoring}
              If FCurrentPatientSensitiveLevel < 2 Then
                FCurrentPatientSensitiveLevel := 2;
            End
            Else
            Begin
              SetPatientInactive();
              Magremoteinterface.RIVNotifyAllListeners(Nil, 'SetInactive', FSite.SiteNumber);
            //LogMsg('s', 'User has chosen not to view restricted patient @ ' + getSiteName());
              MagLogger.LogMsg('s', 'User has chosen not to view restricted patient @ ' + GetSiteName()); {JK 10/6/2009 - Maggmsgu refactoring}
              Result := MagStudyResponseException;
              FImageCount := 0;
              Results.Add('1^Class: ' + Cls + ' - ');
            // add the header parameters
              Results.Add('Item^Site^Note Title^Proc DT^Procedure^# Img^Short Desc^Pkg^Class^Type^Specialty^Event^Origin^Cap Dt^Cap by^Image ID');
              Exit;
            End
          End;
        3:
          Begin
            FrmPatAccess.executeForRemoteWSSite(Self, sensitiveMsg,
              3, GetSiteName());
            SetPatientInactive();
            Magremoteinterface.RIVNotifyAllListeners(Nil, 'SetInactive', GetSiteCode());
          //LogMsg('s', 'Access to this patient @ [' + getSiteName() + '] is not allowed.');
            MagLogger.LogMsg('s', 'Access to this patient @ [' + GetSiteName() + '] is not allowed.'); {JK 10/6/2009 - Maggmsgu refactoring}
            Result := MagStudyResponseException;
            FImageCount := 0;
            Results.Add('1^Class: ' + Cls + ' - ');
          // add the header parameters
            Results.Add('Item^Site^Note Title^Proc DT^Procedure^# Img^Short Desc^Pkg^Class^Type^Specialty^Event^Origin^Cap Dt^Cap by^Image ID');
            Exit;
          End;
      End; (*CASE *)
    End // end of if error check
    Else
    Begin
      // no error value
      sensitiveCheckDone := True;
    End;
  End;
  Try


    {/p117 JMW 10/21/2010 P106/P117 -u7
      In Delphi 2007, if both the errors and studies are nil, then the response.result
     object is nil, so need to check for that }
    // Studies := response.result.studies;   //u7 -out
     Studies := nil;   //117-u7-in
     if (response.result <> nil) then  Studies := response.result.studies; //117-u7-in

    Results.Add('1^Class: ' + Cls + ' - ');
    // add the header parameters
    Results.Add('Item^Site^Note Title^Proc DT^Procedure^# Img^Short Desc^Pkg^Class^Type^Specialty^Event^Origin^Cap Dt^Cap by^Image ID');

    // JMW 8/4/2009 P93T11 - in this version of the interface, for some reason
    // if the patient has no studies at the remote site, studies will be nil.
    // In previous versions it was not nil (noted below).
    If Studies = Nil Then
    Begin
      Result := MagStudyResponseOk;
      FImageCount := 0;
      Exit;
    End;

    FImageCount := length(Studies);

    {JMW 4/1/-7
      If the ViX is trying to return 0 studies, for some reason Delphi says the length of studies is 1
      So this is a check to be sure if there is only 1 study, that it actually is a study and not an empty (null) study
    }
    If FImageCount = 1 Then
    Begin
      Study := Studies[0];//.GetShallowStudyTypeArray(0);
      // if this is nil, then the study is actually null and we got no studies back from the ViX
      If Study.First_image = Nil Then
      Begin
        Result := MagStudyResponseOk;
        FImageCount := 0;
        Exit;
      End;
    End;

    For i := 0 To length(Studies) - 1 Do
    Begin
      Study := Studies[i];
      // if this is the first item in the array, then set the first element of the response message
      If i = 0 Then
      Begin
        Results.Strings[0] := '1^' + Study.RpcResponseMsg;
      End;

      // create the study information
      StudyString := Inttostr(i + 1) + '^' + Study.Site_abbreviation + '^' + Study.Note_title + '^' + Study.Procedure_date + '^' + Study.Procedure_ + '^' + Inttostr(Study.Image_count) + '^' +
        Study.Description + '^' + Study.Study_package + '^' + Study.Study_class + '^' + Study.Study_type + '^' + Study.Specialty + '^' + Study.Event + '^' + Study.Origin + '^' + Study.Capture_Date +
        '^' +
        Study.captured_by + '^' + Study.STUDY_ID;

        // create the URLs for the images
      AbsImgUrlString := CreateImageUrlString(ImageURL, Study.First_image.Abs_Image_URI);
      FullimgUrlString := CreateImageUrlString(ImageURL, Study.First_image.Full_image_URI);
      DiagImgUrlString := CreateImageUrlString(ImageURL, Study.First_image.Big_Image_URI);

      {/ P117-NCAT JK 11/18/2010 - Create an in-memory temporary session filename and map it to the Url String}
      gsess.MagURLMap.Add(AbsImgUrlString);   {add in a name/value pair}
      gsess.MagURLMap.Add(FullImgUrlString);  {add in a name/value pair}
      gsess.MagURLMap.Add(DiagImgUrlString);  {add in a name/value pair}

      // if there is more than 1 image in the study, then it is a group
      If Study.Image_count > 1 Then
        StudyImageType := '11' // group image
      Else
        StudyImageType := Inttostr(Study.First_image.Image_type);
      // add the second piece of the study
      // JMW 2/29/08 P72 - put in the site number in as the place IEN
      StudyString := StudyString + '|' + Study.STUDY_ID + '^' + FullimgUrlString + '^' + AbsImgUrlString + '^' + Study.Description + '^' + Study.Procedure_date + '^' + StudyImageType + '^' +
        Study.Procedure_ + '^' + Study.Procedure_date + '^' + '^' + Study.First_image.Abs_Location + '^' + Study.First_image.Full_location + '^' + Study.First_image.Dicom_sequence_number + '^' +
        Study.First_image.Dicom_image_number + '^' +
        Inttostr(Study.Image_count) + '^' + Study.Site_number + '^' + Study.Site_abbreviation + '^' + Study.First_image.QaMessage + '^' + DiagImgUrlString + '^' + Study.Patient_icn + '^' +
        Study.Patient_name + '^' + Cls + '^^^^';

      Results.Add(StudyString);
      // cache the study based on the study ID
//      self.cacheStudy(study.radiology_report, study.study_id);
    End;

    Result := MagStudyResponseOk;
  Except
    On e: Exception Do
    Begin
      Result := MagStudyResponseException;
      //LogMsg('s','Exception getting studies from [' + FSite.SiteNumber + '], Exception [' + e.Message + ']');
      MagLogger.LogMsg('s', 'Exception getting studies from [' + FSite.SiteNumber + '], Exception [' +
        e.Message + ']'); {JK 10/6/2009 - Maggmsgu refactoring}
      Results.Insert(0, '0^ERROR Accessing Patient Image list.');
      Results.Insert(1, '0^' + MagPiece(e.Message, #$A, 2));
    End;
  End;
End;

Procedure TMagRemoteWSBrokerV5.GetImageGlobalLookup(Ien: String; Var Rlist: TStrings);
Var
  ImgSys: imagingClinicalDisplaySOAP_v5.GetImageSystemGlobalNode;
  ImgSysResponse: ImageSystemGlobalNodeType;
Begin
  If Rlist = Nil Then
    Rlist := Tstringlist.Create();
  Try
    If FSite.IsSiteDOD Then
    Begin
      Rlist.Add('Not available from DOD');
    End
    Else
    Begin
      //LogMsg('s','Getting system gloabl nodes from ViX for image [' + IEN + ']');
      MagLogger.LogMsg('s', 'Getting system gloabl nodes from ViX for image [' + Ien + ']'); {JK 10/6/2009 - Maggmsgu refactoring}
      ImgSys := imagingClinicalDisplaySOAP_v5.GetImageSystemGlobalNode.Create();
      ImgSys.ID := Ien;

      ImgSysResponse := (callWSMethodWithBSE(getImageGlobalLookupWrapper, ImgSys) As ImageSystemGlobalNodeType);
      SetTextStr(ImgSysResponse.ImageInfo, Rlist);
    End;
  Except
    On e: Exception Do
    Begin
        //LogMsg('','Exception getting system global node information, [' + e.Message + ']');
      MagLogger.LogMsg('', 'Exception getting system global node information, [' + e.Message + ']'); {JK 10/6/2009 - Maggmsgu refactoring}
    End;
  End;
  // not done to the DOD
End;

Procedure TMagRemoteWSBrokerV5.GetMagDevFields(Ien, Flags: String; Var Output: Tstringlist);
Var
  ImgDev: GetImageDevFields;
  ImgDevResponse: ImageDevFieldsType;
Begin
  If Output = Nil Then
    Output := Tstringlist.Create();
  Try
    If FSite.IsSiteDOD Then
    Begin
      Output.Add('Not available from DOD');
    End
    Else
    Begin
      //LogMsg('s','Getting dev fields from ViX for image [' + IEN + ']');
      MagLogger.LogMsg('s', 'Getting dev fields from ViX for image [' + Ien + ']'); {JK 10/6/2009 - Maggmsgu refactoring}
      ImgDev := GetImageDevFields.Create();
      ImgDev.ID := Ien;
      ImgDev.Flags := Flags;
      ImgDevResponse := (callWSMethodWithBSE(getMagDevFieldsWrapper, ImgDev) As ImageDevFieldsType);
      SetTextStr(ImgDevResponse.ImageInfo, Output);
    End;
  Except
    On e: Exception Do
    Begin
        //LogMsg('','Exception getting system global node information, [' + e.Message + ']');
      MagLogger.LogMsg('', 'Exception getting system global node information, [' + e.Message + ']'); {JK 10/6/2009 - Maggmsgu refactoring}
    End;
  End;
  // not done to the DOD
End;

Procedure TMagRemoteWSBrokerV5.LogCopyAccess(IObj: TImageData; Msg: String;
  EventType: TMagImageAccessEventType);
Var
  ImageEvent: PostImageAccessEvent;
  Reason: String;
Begin
  Reason := MagPiece(Msg, '^', 1);

  Try
    ImageEvent := PostImageAccessEvent.Create();
    ImageEvent.Log_event := ImageAccessLogEventType.Create();
    ImageEvent.Log_event.ID := IObj.Mag0;
    ImageEvent.Log_event.PatientICN := FPatientICN;
    ImageEvent.Log_event.Reason := Reason; //msg;
    ImageEvent.Log_event.EventType := ConvertEventType(EventType);
    callWSMethodWithBSE(postImageAccessEventWrapper, ImageEvent);

    {/ P117 NCAT - JK 12/9/2010 - Added debug lines for building P104 test scripts /}
    case EventType of
      COPY_TO_CLIPBOARD:
        MagLogger.LogMsg('', 'v5 LogCopyAccess COPY_TO_CLIPBOARD: TransactionId[' +
                         ImageEvent.transaction_id  +  '] ICN[' + FPatientICN + '] Reason[' + Reason + ']');
      PRINT_IMAGE:
        MagLogger.LogMsg('', 'v5 LogCopyAccess PRINT_IMAGE: TransactionId[' +
                         ImageEvent.transaction_id  +  '] ICN[' + FPatientICN + '] Reason[' + Reason + ']');
      UMagClasses.PATIENT_ID_MISMATCH:
        MagLogger.LogMsg('', 'v5 LogCopyAccess PATIENT_ID_MISMATCH: TransactionId[' +
                         ImageEvent.transaction_id  +  '] ICN[' + FPatientICN + '] Reason[' + Reason + ']');
    end;

  Except
    On e: Exception Do
    Begin
      //LogMsg('','Exception logging Copy Access, [' + e.Message + ']');
      MagLogger.LogMsg('', 'Exception logging Copy Access, [' + e.Message + ']'); {JK 10/6/2009 - Maggmsgu refactoring}
      // log error
    End;
  End;
End;

Function TMagRemoteWSBrokerV5.ConvertEventType(EType: TMagImageAccessEventType): EventType;
Begin
  If EType = COPY_TO_CLIPBOARD Then
    Result := IMAGE_COPY
  Else
    If EType = PRINT_IMAGE Then
      Result := IMAGE_PRINT
    Else
      If EType = UMagClasses.PATIENT_ID_MISMATCH Then
        Result := PATIENT_ID_MISMATCH
      Else
        Result := IMAGE_COPY;
End;

Procedure TMagRemoteWSBrokerV5.GetImageInformation(IObj: TImageData; Var Output: TStrings);
Var
  ImgInfo: imagingClinicalDisplaySOAP_v5.GetImageInformation;
  ImgInfoResponse: ImageInformationType;
Begin
  If Output = Nil Then
    Output := Tstringlist.Create();
  // there are a few ways this could be handled, if the request is to the
  // DOD we know we won't get anything from them
  // if the request is to another VA site, then we should make a WS call to
  // the ViX which would forward the call and then make the rpc call to get the data

  // if the site is DOD, then we could avoid making the ViX call for efficiency
  // or the ViX could respond with information
  If FSite.IsSiteDOD Then
  Begin
    Output.Add('Image ID#    : ' + IObj.Mag0);
//    output.add('Format       : ???');
    // we don't have the actual filename here so we can't get the extension of it
//    output.add('Extension    : ???');
    Output.Add('Desc         : ' + IObj.ImgDes);
    Output.Add('Procedure    : ' + IObj.Proc);
    Output.Add('   Date      : ' + IObj.Date);
    {
    output.add('Class        : ???');
    output.add('Package      : ???');
    output.add('Type         : ???');
    output.add('Proc/Event   : ???');
    output.add('Spec/SubSpec : ???');
    output.add('Origin       : ???');
    output.add('Captured on  : ???');
    output.add('     by : ???');
    }
  End
  Else
  Begin
    Try
      //LogMsg('s','Getting image information from ViX for image [' + Iobj.Mag0 + ']');
      MagLogger.LogMsg('s', 'Getting image information from ViX for image [' + IObj.Mag0 + ']'); {JK 10/6/2009 - Maggmsgu refactoring}
      ImgInfo := imagingClinicalDisplaySOAP_v5.GetImageInformation.Create();
      ImgInfo.ID := IObj.Mag0;
      ImgInfoResponse := (callWSMethodWithBSE(getimageinformationWrapper, ImgInfo) As ImageInformationType);
      SetTextStr(ImgInfoResponse.ImageInfo, Output);
    Except
      On e: Exception Do
      Begin
        //LogMsg('','Exception getting image information, [' + e.Message + ']');
        MagLogger.LogMsg('', 'Exception getting image information, [' + e.Message + ']'); {JK 10/6/2009 - Maggmsgu refactoring}
      End;
    End;
  End;
End;

{
  new for version 4 the reports are no longer included in the study list
  response. This is done because the interface to the DoD is hopefully going
  to change and the reports will not be included in the response. This is
  done to speed up the response time on the study graph from the DoD.

  The client then requests the reports it wants to see and the VIX retrieves
  them. Making this change in this interface is done now in preperation for
  that Exchange change. For now the VIX should always have the report
  in the cache and it should return quickly.
}

Function TMagRemoteWSBrokerV5.Getreport(IObj: TImageData): TStrings;
Var
  StudyId: String;
  Params: getStudyReport;
  Response: StudyReportType;
Begin
  Result := Tstringlist.Create();
  {

  if IObj.ImgType = 11 then // study
  begin
    studyId := IObj.Mag0;
  end
  else
  begin
    // JMW 2/29/08 P72
    // if the study is a single image study then the Mag0 will actually be a study URN and not an image URN
    // therefore we need to get the study Id (second piece) and not the third piece
    if pos('urn:vastudy', iobj.Mag0) = 1 then
      studyId := MAGPIECE(iobj.Mag0, '-', 2) // get the 2nd piece from the Study URN - study Id
    else
      studyId := MAGPIECE(iobj.Mag0, '-', 3); // get the 3rd piece from the Image URN - study Id
    studyId := 'urn:vastudy:' + iobj.PlaceIEN + '-' + studyId + '-' + iobj.DFN;
  end;
  }
  {/ JMW  11/30/2009  P94 - for this interface, the VIX can handle either a
    study URN or an image URN, so don't do any conversion with it.
  /}
  StudyId := IObj.Mag0;

  Try
    //LogMsg('s','Getting study report from VIX for study  [' + studyId + ']');
    MagLogger.LogMsg('s', 'Getting study report from VIX for study  [' + StudyId + ']'); {JK 10/6/2009 - Maggmsgu refactoring}
    Params := getStudyReport.Create();
    Params.STUDY_ID := StudyId;
    Response := (callWSMethodWithBSE(getStudyReportWrapper, Params) As StudyReportType);
    Result.Text := Response.studyReport;
  Except
    On e: Exception Do
    Begin
      //LogMsg('s','Exception getting study report, ' + e.Message, MagLogError);
      MagLogger.LogMsg('s', 'Exception getting study report, ' + e.Message, MagLogERROR); {JK 10/6/2009 - Maggmsgu refactoring}
      Result.Text := 'Error retrieving report for study [' + StudyId + ']';
    End;
  End;
End;

Procedure TMagRemoteWSBrokerV5.LogOfflineImageAccess(IObj: TImageData);
Begin
  // nothing to do for DOD
End;

Procedure TMagRemoteWSBrokerV5.LogAction(Msg: String);
Var
  ImageEvent: PostImageAccessEvent;
  ImgId: String;
Begin
  ImgId := MagPiece(Msg, '^', 3);
  Try
    ImageEvent := PostImageAccessEvent.Create();
    ImageEvent.Log_event := ImageAccessLogEventType.Create();
    ImageEvent.Log_event.ID := ImgId;
    ImageEvent.Log_event.PatientICN := FPatientICN;
    ImageEvent.Log_event.Reason := '';
    ImageEvent.Log_event.EventType := IMAGE_ACCESS;
    callWSMethodWithBSE(postImageAccessEventWrapper, ImageEvent);

    {/ P117 NCAT - JK 12/9/2010 - Added debug lines for building P104 test scripts /}
    MagLogger.LogMsg('', 'v5 LogAction IMAGE_ACCESS: TransactionID[' +
                     ImageEvent.transaction_id +  ']  ICN[' + FPatientICN + ']');

  Except
    On e: Exception Do
    Begin
      //LogMsg('','Exception logging Copy Access, [' + e.Message + ']');
      MagLogger.LogMsg('', 'Exception logging Copy Access, [' + e.Message + ']'); {JK 10/6/2009 - Maggmsgu refactoring}
      // log error
    End;
  End;
End;

Function TMagRemoteWSBrokerV5.QueImage(ImgType: String; IObj: TImageData): TStrings;
Begin
  //jw 11/19/07
  Result := Tstringlist.Create();
  Result.Add('-1^Not applied for Webservice broker')
  // nothing to do for DOD (maybe pre-cache)?
End;

Function TMagRemoteWSBrokerV5.QueImageGroup(Images: String; IObj: TImageData): String;
Begin
  //jw 11/19/07
  Result := '';
  // nothing to do for DOD (maybe pre-cache)?
End;

Procedure TMagRemoteWSBrokerV5.GetImageGroup(IObj: TImageData; NoQAcheck: Boolean; Output: TStrings);
Var
  ReqParam: GetStudyImageList;
  Images: FatImagesType2;
  Imagestring: String;
  i: Integer;
  Image: FatImageType;
  ImageURL: String;
  AbsImgUrlString, FullimgUrlString, DiagImgUrlString: String;
Begin
  ReqParam := GetStudyImageList.Create();
  ReqParam.STUDY_ID := IObj.Mag0;

  ImageURL := FLocalViXURL + FImagingService.ImagePath + '?'; //  'xchange/xchange?';
  If Output = Nil Then
    Output := Tstringlist.Create();

  Try
    Magremoteinterface.RIVNotifyAllListeners(Nil, 'IMAGE_COPY_STARTED', '');
    Try
      Images := callGetStudyImageListWithBSE(ReqParam);

      Output.Add('1^' + Inttostr(length( Images)));
      For i := 0 To length(Images) - 1 Do
      Begin
        Image := Images[i];
        AbsImgUrlString := CreateImageUrlString(ImageURL, Image.Abs_Image_URI);
        FullimgUrlString := CreateImageUrlString(ImageURL, Image.Full_image_URI);
        DiagImgUrlString := CreateImageUrlString(ImageURL, Image.Big_Image_URI);

        {/ P117-NCAT JK 11/18/2010 - Create a filename and map it to the Url String}
        gsess.MagURLMap.Add(AbsImgUrlString, True);   {add in a name/value pair}
        gsess.MagURLMap.Add(FullImgUrlString, True);  {add in a name/value pair}
        gsess.MagURLMap.Add(DiagImgUrlString, True);  {add in a name/value pair}
        

      // QA Message goes after the abbr and before the diagnostic image url

        Imagestring := 'B2^' + Image.Image_Id + '^' + FullimgUrlString + '^' + AbsImgUrlString + '^' + Image.Description + '^^' + Inttostr(Image.Image_type) + '^' +
          Image.Procedure_ + '^' + Image.Procedure_date + '^^' + Image.Abs_Location + '^' + Image.Full_location + '^' + Image.Dicom_sequence_number + '^' +
          Image.Dicom_image_number + '^' + '1^' + Image.Site_number + '^' + Image.Site_abbr + '^' + Image.QaMessage + '^' + DiagImgUrlString + '^' + Image.Patient_icn + '^' + Image.Patient_name + '^'
          + Image.Image_class + '^^^^';
        Output.Add(Imagestring);
      End;
    Except
      On e: Exception Do
      Begin
      //LogMsg('','Exception getting group images for study [' + iobj.Mag0 + '] from [' + FSite.SiteNumber + '], Exception [' + e.Message + ']');
        MagLogger.LogMsg('', 'Exception getting group images for study [' + IObj.Mag0 + '] from [' + FSite.SiteNumber + '], Exception [' +
          e.Message + ']'); {JK 10/6/2009 - Maggmsgu refactoring}
        Output.Add('0^ERROR: Image entry ' + IObj.Mag0 + ' Doesn''t exist');
      End;
    End;
  Finally
    Magremoteinterface.RIVNotifyAllListeners(Nil, 'IMAGE_COPY_COMPLETE', '');
  End;
End;

Function TMagRemoteWSBrokerV5.ConvertToFilter(Pkg, Cls, Types, Event, Spc, FrDate, ToDate, Origin: String): FilterType;
Begin
  Result := FilterType.Create();
  If Origin = '' Then
    Result.Origin := UNSPECIFIED
  Else
    If Origin = 'VA' Then
      Result.Origin := VA
    Else
      If Origin = 'DOD' Then
        Result.Origin := DOD
      Else
        If Origin = 'NON-VA' Then
          Result.Origin := NON_VA
        Else
          If Origin = 'FEE' Then
            Result.Origin := FEE;

  Result.package_ := Pkg;
  Result.Class_ := Cls;
  Result.Types := Types;
  Result.Event := Event;
  Result.Specialty := Spc;
  Result.From_date := FrDate;
  Result.To_date := ToDate;

End;

Function TMagRemoteWSBrokerV5.CreateUserCredentials(): UserCredentials;
Var
  Cred: UserCredentials;
Begin
  Cred := UserCredentials.Create();
  Cred.Fullname := FUserFullname;
  Cred.Duz := FUserDUZ;
  Cred.SSN := FUserSSN;
  Cred.SiteName := GSess.Wrksinst.Name;
  Cred.SiteNumber := PrimarySiteStationNumber;

  If GSess.SecurityToken <> '' Then
  Begin
    // if the VIX is ever used for TeleReader - this code needs to change
    // to say TeleReader or Display (look at app type)
    Cred.securityToken := 'VISTA IMAGING DISPLAY' + '^' +
      gsess.SecurityToken + '^' + PrimarySiteStationNumber + '^' +
      Inttostr(FLocalBrokerPort);
  End;
  Result := Cred;
End;

Procedure TMagRemoteWSBrokerV5.RPMagTeleReaderUnreadlistGet(Var t: TStrings;
  AcquisitionPrimaryDivision, Sitecode, SpecialtyCode, ProcedureStrings,
  LastUpdate, UserDUZ, LocalSiteCode, SiteTimeOut, StatusOptions: String);
Begin
  If t = Nil Then
    t := Tstringlist.Create();
End;

Procedure TMagRemoteWSBrokerV5.RPMagTeleReaderUnreadlistLock(Var Xmsg: String;
  AcquisitionPrimaryDivision, AcquisitionSiteCode, ItemID, LockUnlockValue,
  UserFullName, UserInitials, LocalDUZ, LocalSiteCode: String);
Begin
  Xmsg := '';
End;

{/
  This is an event handler that allows setting the timeout before recieving a
  response from the server. The default timeout is 30 seconds and the VIX times
  out at 30 seconds. On some systems (in some cases), the wininet timeout will
  occur before the VIX timeout (matter of ms). This ups the timeout so the VIX
  will timeout in requests creating the proper error message
/}

Procedure TMagRemoteWSBrokerV5.OnBeforePostEvent(Const HTTPReqResp: THTTPReqResp; Data: Pointer);
Var
  Timeout: Integer;
Begin
  Timeout := 50000; // in milleseconds.
  InternetSetOption(Data,
    INTERNET_OPTION_RECEIVE_TIMEOUT,
    Pointer(@Timeout),
    SizeOf(Timeout));
End;

{
  Method to handle the BSE exception. If a new token can be generated, it is
  created.

  @returns true if the client should attempt the method again, false if there have
  been too many attempts or if the exception is not BSE related
}

Function TMagRemoteWSBrokerV5.handleBSEException(e: Exception; attemptCount: Integer): Boolean;
Begin
  Result := False;
  If Pos('BSE TOKEN EXPIRED', e.Message) > 1 Then
  Begin
    MagLogger.LogMsg('s', 'Error was BSE TOKEN EXPIRED, will attempt to get a new token (if possible)', MagLogINFO); {JK 10/6/2009 - Maggmsgu refactoring}
    If attemptCount < 3 Then
    Begin
      MagLogger.LogMsg('s', 'Current BSE login attempt is ' + Inttostr(attemptCount) + ', try to get new token', MagLogINFO); {JK 10/6/2009 - Maggmsgu refactoring}
      If Assigned(FSecurityTokenNeeded) Then
      Begin
        GSess.SecurityToken := FSecurityTokenNeeded;
        MagLogger.LogMsg('s', 'Received new token ' + GSess.SecurityToken, MagLogINFO); {JK 10/6/2009 - Maggmsgu refactoring}
        Result := True;
      End
      Else
      Begin
        MagLogger.LogMsg('s', 'FSecurityTokenNeeded not assigned, cannot get new token, clearing token to force CAPRI', MagLogINFO); {JK 10/6/2009 - Maggmsgu refactoring}
        // clear the token so it will prevent BSE from working, will fall back to CAPRI method
        gsess.SecurityToken := '';
        Result := True;
      End;
    End;
    If Not Result Then
    Begin
      MagLogger.LogMsg('s', 'Could not get new token, cannot connect to remote site.', MagLogINFO); {JK 10/6/2009 - Maggmsgu refactoring}
    End;
  End;
End;

{
  This is a method used to make all VIX calls for handling BSE. By calling this
  method in all cases, BSE exceptions will be handled in here. This method may
  throw an exception if the wrapper method throws a non-BSE exception or if
  the BSE exception could not be handled.
}

Function TMagRemoteWSBrokerV5.callWSMethodWithBSE(Method: TMagRemoteWSBrokerWrapper;
  Input: TRemotable): TRemotable;
Var
  bseAttemptCount: Integer;
  tryAgain: Boolean;
  Response: TRemotable;
Begin
  tryAgain := True;
  bseAttemptCount := 0;
  Result := Nil;

  While tryAgain Do
  Begin
    Try
      bseAttemptCount := bseAttemptCount + 1;
      Method(Input, Response);
      Result := Response;
      Exit;
    Except
      On e: Exception Do
      Begin
        tryAgain := handleBSEException(e, bseAttemptCount);
        If Not tryAgain Then
        Begin
          // JMW 11/24/2009 - P94
          // need to create a new exception otherwise when the code that catches
          // this one gets it, the exception will be nil because it will have
          // been destroyed - very annoying!
          Raise Exception.Create(e.Message);
        End;
      End;
    End; {try}
  End; {while}
End;

{
  JMW 10/8/2010 P106 - Delphi 2007 generates web service code different than
  Delphi 7 did.  One consequence is webservice methods that return arrays of
  objects in Delphi 2007 come back as array of TRemotable (Delphi 7 generated
  a new object of type TRemotable). As a result, the pattern of calling the
  callWSMethodWithBSE method does not work when the result is an array because
  this method excepts the result to be of type TRemotable, not array of
  TRemotable.  Since this interface only has 1 method that returns an array,
  this is a cheap and sleezy way of getting around the problem (by making a method
  that handles this one call).  Overall this sucks and I'd like to do something
  better.  I tried creating a type of array of TRemotable and having a
  callWSMethodWithBSE that returns this type, but it didn't want to work.
}
Function TMagRemoteWSBrokerV5.callGetStudyImageListWithBSE(Input : GetStudyImageList) : FatImagesType2;
Var
  bseAttemptCount: Integer;
  tryAgain: Boolean;
  Response: FatImagesType2;
Begin
  tryAgain := True;
  bseAttemptCount := 0;
  Result := Nil;

  While tryAgain Do
  Begin
    Try
      bseAttemptCount := bseAttemptCount + 1;
      input.credentials := CreateUserCredentials();
      input.transaction_id := CreateTransactionId();

      Response := WSBroker.getStudyImageList(input);
      Result := Response;
      Exit;
    Except
      On e: Exception Do
      Begin
        tryAgain := handleBSEException(e, bseAttemptCount);
        If Not tryAgain Then
        Begin
          // JMW 11/24/2009 - P94
          // need to create a new exception otherwise when the code that catches
          // this one gets it, the exception will be nil because it will have
          // been destroyed - very annoying!
          Raise Exception.Create(e.Message);
        End;
      End;
    End; {try}
  End; {while}
End;

Procedure TMagRemoteWSBrokerV5.pingServerWrapper(Input: TRemotable;
  Var Response: TRemotable);
Begin
  (Input As PingServer).Credentials := CreateUserCredentials();
  (Input As PingServer).Transaction_id := CreateTransactionId();
  Response := WSBroker.PingServerEvent((Input As PingServer));
End;

Procedure TMagRemoteWSBrokerV5.getPatientStudyListWrapper(Input: TRemotable;
  Var Response: TRemotable);
Begin
  (Input As GetPatientShallowStudyList).Credentials := CreateUserCredentials();
  (Input As GetPatientShallowStudyList).Transaction_id := CreateTransactionId();
  Response := WSBroker.GetPatientShallowStudyList(Input As GetPatientShallowStudyList);
End;

Procedure TMagRemoteWSBrokerV5.getMagDevFieldsWrapper(Input: TRemotable; Var Response: TRemotable);
Begin
  (Input As GetImageDevFields).Credentials := CreateUserCredentials();
  (Input As GetImageDevFields).Transaction_id := CreateTransactionId();
  Response := WSBroker.GetImageDevFields(Input As GetImageDevFields);
End;

Procedure TMagRemoteWSBrokerV5.getImageGlobalLookupWrapper(Input: TRemotable;
  Var Response: TRemotable);
Begin
  (Input As imagingClinicalDisplaySOAP_v5.GetImageSystemGlobalNode).Credentials := CreateUserCredentials();
  (Input As imagingClinicalDisplaySOAP_v5.GetImageSystemGlobalNode).Transaction_id := CreateTransactionId();
  Response := WSBroker.GetImageSystemGlobalNode(Input As imagingClinicalDisplaySOAP_v5.GetImageSystemGlobalNode);
End;

Procedure TMagRemoteWSBrokerV5.postImageAccessEventWrapper(Input: TRemotable;
  Var Response: TRemotable);
Begin
  (Input As PostImageAccessEvent).Transaction_id := CreateTransactionId();
  (Input As PostImageAccessEvent).Log_event.Credentials := CreateUserCredentials();
  Response := WSBroker.PostImageAccessEvent(Input As PostImageAccessEvent);
End;

Procedure TMagRemoteWSBrokerV5.getImageInformationWrapper(Input: TRemotable;
  Var Response: TRemotable);
Begin
  (Input As imagingClinicalDisplaySOAP_v5.GetImageInformation).Credentials := CreateUserCredentials();
  (Input As imagingClinicalDisplaySOAP_v5.GetImageInformation).Transaction_id := CreateTransactionId();
  Response := WSBroker.GetImageInformation(Input As imagingClinicalDisplaySOAP_v5.GetImageInformation);
End;

Procedure TMagRemoteWSBrokerV5.getStudyReportWrapper(Input: TRemotable;
  Var Response: TRemotable);
Begin
  (Input As getStudyReport).Credentials := CreateUserCredentials();
  (Input As getStudyReport).Transaction_id := CreateTransactionId();
  Response := WSBroker.getStudyReport(Input As getstudyreport);
End;

End.
