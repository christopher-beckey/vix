{
  Package: MAG - VistA Imaging
  WARNING: Per VHA Directive 2004-038, this routine should not be modified.
  Date Created: October 18, 2010
  Site Name:  Washington OI Field Office, Silver Spring, MD               
  Developer:  Jerry Kashtan
  Description:
    Web Service implementation of the remote image view broker. This
    communicates with the VistA Imaging Exchange (VIX) server to retrieve
    remote patient information from VA and DOD sites. This uses the version 4
    interface between the ViX and the client which will support ViX to ViX.

    10/8/2010 JMW Updated for Patch 106 with Delphi 2007.  WS interface
    regenerated with Delphi 2007, caused a few changes to be made here, see
    comments below

    10/25/2010 JK Updated for Patch 117-NCAT work.  WS interface updated to v6.
      -- support for P117 DoD artifact and DoD NCAT (Neurological Cognitive
         Assessment Test accession.

    7/4/2011 JK Updated for Patch 122 - Annotations uses v7

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
Unit cMagRemoteWSBroker_v7;

Interface

Uses
  IMagRemoteBrokerInterface,
  Classes,
  UMagClasses,
//RCA  Maggmsgu,
  Imaginterfaces,
  imagingClinicalDisplaySOAP_v7,
  cMagRemoteWSBrokerBase,
  SysUtils,
  InvokeRegistry,
  soaphttptrans,
  wininet,
  dialogs,
  MagFileVersion,
  Forms
  ;

Type
  TMagRemoteWSBrokerV7 = Class(TMagBaseRemoteWSBroker)
  Private
    WSBroker: ImageClinicalDisplayMetadata;
//Was for RCA decouple magmsg, not now.        Procedure MyLogMsg(msgType, msg: String; Priority: TMagMsgPriority = magmsgINFO);
 {7/12/12 gek Merge 130->129}
    {/ P130 JK 6/25/2012 - added the ShowDeletedImages parameter /}
    Function ConvertToFilter(Pkg, Cls, Types, Event, Spc, FrDate, ToDate, Origin: String; ShowDeletedImages: Boolean): FilterType;
    Function CreateUserCredentials(): UserCredentialsType;
    Function ConvertEventType(EType: TMagImageAccessEventType): EventType;

    Procedure OnBeforePostEvent(Const HTTPReqResp: THTTPReqResp; Data: Pointer);

    // JMW 11/24/2009 - p94 - new methods to handle BSE.
    Function handleBSEException(e: Exception; attemptCount: Integer): Boolean;
    Function callWSMethodWithBSE(Method: TMagRemoteWSBrokerWrapper; Input: TRemotable): TRemotable;
    // JMW 10/8/2010 P106 see description of this method below
    Function callGetStudyImageListWithBSE(Input : GetStudyImageList) : FatImagesType;
    Procedure pingServerWrapper(Input: TRemotable; Var Response: TRemotable);
    Procedure getPatientStudyListWrapper(Input: TRemotable; Var Response: TRemotable);
    Procedure getMagDevFieldsWrapper(Input: TRemotable; Var Response: TRemotable);
    Procedure getImageGlobalLookupWrapper(Input: TRemotable; Var Response: TRemotable);
    Procedure postImageAccessEventWrapper(Input: TRemotable; Var Response: TRemotable);
    Procedure getImageInformationWrapper(Input: TRemotable; Var Response: TRemotable);
    Procedure getStudyReportWrapper(Input: TRemotable; Var Response: TRemotable);
    procedure getIsAnnotationSupported(Input: TRemotable; Var Response: TRemotable);
    procedure postXMLAnnots(Input: TRemotable; Var Response: TRemotable);
    procedure GetXMLAnnotDetails(Input: TRemotable; var Response: TRemotable);
    function callGetAnnotListWithBSE(Input: getImageAnnotations) : getImageAnnotationsResponseType;
    procedure getAnnotUserDetails(Input: TRemotable; var Response: TRemotable);  {/ P122 - JK 10/2/2011 /}
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
 {7/12/12 gek Merge 130->129}
    {/ P117 NCAT - JK 11/30/2010 /}
    {/ P130 JK - 6/25/2012 added ShowDeletedImages: Boolean parameter /}
    Function GetPatientStudies(Pkg, Cls, Types, Event, Spc,
      FrDate, ToDate, Origin: String; ShowDeletedImages: Boolean;
      Var Results: TStrings; Var Partial_Returned: Boolean; Var Partial_Msg: String): TMagPatientStudyResponse; Override;
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
    {/ P127T1 NST 04/06/2012 Send Reader Station Number (Reader Locking issue) /}

    Procedure RPMagTeleReaderUnreadlistGet(Var t: TStrings;
      AcquisitionPrimaryDivision, Sitecode, SpecialtyCode, ProcedureStrings,
      LastUpdate, UserDUZ, LocalSiteCode, SiteTimeOut, StatusOptions, LocalSiteStationNumber: String); Override;
    {/ P127T1 NST 04/06/2012 Send Reader Station Number (Reader Locking issue)  /}

    Procedure RPMagTeleReaderUnreadlistLock(Var Xmsg: String;
      AcquisitionPrimaryDivision, AcquisitionSiteCode, ItemID, LockUnlockValue,
      UserFullName, UserInitials, LocalDUZ, LocalSiteCode, LocalSiteStationNumber: String); Override;

    procedure LogShallowStudyListProperties(Input: TRemotable);

    function IsAnnotsSupported: Boolean; override; {/ P122 - JK 7/17/2011 /}

    function CanUserAnnotateRemotely: Boolean; override; {/ P122 - JK 9/27/2011 /}
    function HasAnnotateMasterKey: Boolean; override; {/ P122 - JK 9/27/2011 /}
    function GetUserAnnotDUZ: String; override; {/ P122 - JK 10/4/2011 /}

    function SaveAnnots(IEN, AnnotSource: String; Version: String; AnnotXML: TStringList): Boolean; override; {/ P122 - JK 7/17/2011 /}
    function GetAnnots(IEN: String): TStrings; override; {/ P122 - JK 7/17/2011 /}
    function GetAnnotDetails(IEN,LayerID: String): String; override; {/ P122 - JK 7/17/2011 /}

  End;

Implementation
Uses
  FMagPatAccess,
  Magremoteinterface,
  SOAPHTTPClient,
  UMagDefinitions,
  Umagutils8,
  cMagImageUtility
  ;



//RCA 11/11/2011  gek  remove dependency on maggmsgu and VCLZip.  Use interface (if it is declared).
(*  procedure TMagRemoteWSBrokerV7.MyLogMsg(msgType, msg: String; Priority: TMagMsgPriority = magmsgINFO);
begin
if ImsgObj <> nil then  ImsgObj.LogMsg(msgtype,msg,priority);
end;
*)

Constructor TMagRemoteWSBrokerv7.Create(Site: TVistaSite;
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

Destructor TMagRemoteWSBrokerV7.Destroy;
Begin
  If FStudyList <> Nil Then
    FreeAndNil(FStudyList);
  If FSite <> Nil Then
    FreeAndNil(FSite);
  Inherited;
End;

Function TMagRemoteWSBrokerV7.Connect(UserFullName: String; UserLocalDUZ: String; UserSSN: String): Boolean;
Var
  PingServerRequest: PingServer;
  PingServerResponse: PingServerType;
Begin
  FUserFullname := UserFullName;
  FUserDUZ := UserLocalDUZ;
  FUserSSN := UserSSN;

  PingServerRequest := PingServer.Create();
  PingServerRequest.ClientWorkstation := FWorkstationID;
  PingServerRequest.RequestSiteNumber := FSite.SiteNumber;

  Try
    magAppMsg('s', 'Pinging VIX at URL [' + FLocalViXURL +
      FImagingService.MetadataPath + '] using WS Broker class [' +
      Self.ClassName + '] to connect to site [' + FSite.SiteNumber + ']',
      MagmsgINFO); {JK 10/6/2009 - Maggmsgu refactoring}

    PingServerResponse := (callWSMethodWithBSE(pingserverwrapper, TRemotable(PingServerRequest)) As PingServerType);

    If PingServerResponse.PingResponse = SERVER_READY Then
    Begin
      FPatientStatus := STATUS_PATIENTACTIVE;
      FServerStatus := STATUS_CONNECTED;
      Result := True;
    End
    Else
    Begin
      magAppMsg('s', 'ViX Server status UNAVAILABLE on connect (' + FSite.VixServer + ', ' +
        Inttostr(FSite.VistaPort) + ') through local ViX', magmsgInfo); {JK 10/6/2009 - Maggmsgu refactoring}
      Result := False;
      FPatientStatus := STATUS_PATIENTINACTIVE;
      FServerStatus := STATUS_DISCONNECTED;
    End;
  Except
    On e: Exception Do
    Begin
      magAppMsg('s', 'Exception Connecting to ViX server (' + FSite.VixServer + ', ' +
        Inttostr(FSite.VistaPort) + ') Through local Vix, Exception=[' + e.Message + ']'); {JK 10/6/2009 - Maggmsgu refactoring}
      Result := False;
      FPatientStatus := STATUS_PATIENTINACTIVE;
      FServerStatus := STATUS_DISCONNECTED;
    End;
  End;
  // mock connect? verify able to connect? ping server? do what?
End;
 {7/12/12 gek Merge 130->129}
{/ P117 NCAT - JK 11/30/2010 /}
{/ P130 JK - 6/25/2012 added ShowDeletedImages: Boolean parameter /}

Function TMagRemoteWSBrokerV7.GetPatientStudies(Pkg, Cls, Types, Event, Spc,
  FrDate, ToDate, Origin: String;
  ShowDeletedImages: Boolean;
  Var Results: TStrings; Var Partial_Returned: Boolean; Var Partial_Msg: String): TMagPatientStudyResponse;
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
  Response: ShallowStudiesResponseType;

  sensitiveCheckDone: Boolean;
  sensitiveMsg: Tstringlist;
  TxtImgUrlString : String;
Begin
  Result := MagStudyResponseException;
  // convert the filter to a FilterType (for WS call) {7/12/12 gek Merge 130->129}
  Filter := ConvertToFilter(Pkg, Cls, Types, Event, Spc, FrDate, ToDate, Origin, ShowDeletedImages);
  ImageURL := FLocalViXURL + FImagingService.ImagePath + '?'; // 'xchange/xchange?';

  SiteID := FSite.SiteNumber;

  ReqParam := GetPatientShallowStudyList.Create();
  ReqParam.transaction_id := TransId;
  ReqParam.site_id := SiteID;
  ReqParam.Patient_id := FPatientICNWithChecksum;
  ReqParam.Filter := Filter;

  ReqParam.includeArtifacts := True;  {JK 11/8/2010}

  If Results = Nil Then
    Results := Tstringlist.Create();

  sensitiveCheckDone := False;
  Response := Nil;
  While Not sensitiveCheckDone Do
  Begin
    ReqParam.authorizedSensitivityLevel := FCurrentPatientSensitiveLevel;

    magAppMsg('s', 'Getting patient study list with sensitive code [' +
      Inttostr(FCurrentPatientSensitiveLevel) + ']', magmsgInfo); {JK 10/6/2009 - Maggmsgu refactoring}

    // execute the Web Service to get the studies
    Try
      Magremoteinterface.RIVNotifyAllListeners(Nil, 'IMAGE_COPY_STARTED', '');
      Try
        Response := (callWSMethodWithBSE(getPatientStudyListWrapper, ReqParam) As ShallowStudiesResponseType);
      Except
        On E:Exception Do
        Begin
          Result := MagStudyResponseException;
          FImageCount := 0;

          magAppMsg('s', 'Exception getting studies from [' + FSite.SiteNumber + '], Exception [' +
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
    //If Response.Result.error <> Nil Then     //117 u6-out     {CodeCR732}
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
              magAppMsg('s', 'User has chosen to view restricted patient @ ' + GetSiteName()); {JK 10/6/2009 - Maggmsgu refactoring}
              If FCurrentPatientSensitiveLevel < 2 Then
                FCurrentPatientSensitiveLevel := 2;
            End
            Else
            Begin
              SetPatientInactive();
              Magremoteinterface.RIVNotifyAllListeners(Nil, 'SetInactive', FSite.SiteNumber);
            //LogMsg('s', 'User has chosen not to view restricted patient @ ' + getSiteName());
              magAppMsg('s', 'User has chosen not to view restricted patient @ ' + GetSiteName()); {JK 10/6/2009 - Maggmsgu refactoring}
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
            magAppMsg('s', 'Access to this patient @ [' + GetSiteName() + '] is not allowed.'); {JK 10/6/2009 - Maggmsgu refactoring}
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

    {/p117 gek  check for nil also.  for next two 'Partial_ ' fields.    }
     if (response.result <> nil) then
       begin
       Partial_Returned := response.result.partial_result; {/ P117 NCAT - JK 11/30/2010 /}
       Partial_Msg      := response.result.partial_result_message; {/ P117 NCAT - JK 1/17/2011 /}
       end;

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

      {JK - for reference, the positional mapping (serialization) of the StudyString into a
       TImageData object is done in uMagClasses.TImageData.StringToTImageData }

      StudyString :=
        Inttostr(i + 1)              + '^' +
        Study.Site_abbreviation      + '^' +
        Study.Note_title             + '^' +
        Study.Procedure_date         + '^' +
        Study.Procedure_             + '^' +
        Inttostr(Study.Image_count)  + '^' +
        Study.Description            + '^' +
        Study.Study_package          + '^' +
        Study.Study_class            + '^' +
        Study.Study_type             + '^' +
        Study.Specialty              + '^' +
        Study.Event                  + '^' +
        Study.Origin                 + '^' +
        Study.Capture_Date           + '^' +
        Study.captured_by            + '^' +
        Study.STUDY_ID;

      // create the URLs for the images
      AbsImgUrlString  := CreateImageUrlString(ImageURL, Study.First_image.Abs_Image_URI);
      FullimgUrlString := CreateImageUrlString(ImageURL, Study.First_image.Full_image_URI);
      DiagImgUrlString := CreateImageUrlString(ImageURL, Study.First_image.Big_Image_URI);
      // JMW 5/1/2013 p131 - need to map a location for the text file, even if
      // it isn't going to be used
      TxtImgUrlString := CreateImageUrlString(ImageURL, Study.First_image.full_image_URI);
      TxtImgUrlString := GetImageUtility().GetTxtFilePath(TxtImgUrlString);

      {/ P117-NCAT JK 11/18/2010 - Create an in-memory temporary session filename and map it to the Url String}
      gsess.MagURLMap.Add(AbsImgUrlString);   {add in a name/value pair}
      gsess.MagURLMap.Add(FullImgUrlString);  {add in a name/value pair}
      gsess.MagURLMap.Add(DiagImgUrlString);  {add in a name/value pair}
      gsess.MagURLMap.Add(TxtImgUrlString);  {add in a name/value pair}

      // if there is more than 1 image in the study, then it is a group
      If Study.Image_count > 1 Then
        StudyImageType := '11' // group image
      Else
        StudyImageType := Inttostr(Study.First_image.Image_type);

        {/ P117 NCAT - JK 12/6/2010 - Adding the descriptive title from the image type since
           the DoD does not annotate their artifacts like the VA does. /}
        if StudyImageType = '501' then
        begin
          Study.description := 'Neurocognitive Assessment Tool';
          StudyString       := MagSetPiece(StudyString, '^', 7, 'Neurocognitive Assessment Tool');
        end;

      // add the second piece of the study
      // JMW 2/29/08 P72 - put in the site number in as the place IEN
      StudyString :=
        StudyString                             + '|' +
        Study.STUDY_ID                          + '^' +
        FullimgUrlString                        + '^' +
        AbsImgUrlString                         + '^' +
        Study.Description                       + '^' +
        Study.Procedure_date                    + '^' +
        StudyImageType                          + '^' +
        Study.Procedure_                        + '^' +
        Study.Procedure_date                    + '^' +
                                                  '^' +
        Study.First_image.Abs_Location          + '^' +
        Study.First_image.Full_location         + '^' +
        Study.First_image.Dicom_sequence_number + '^' +
        Study.First_image.Dicom_image_number    + '^' +
        Inttostr(Study.Image_count)             + '^' +
        Study.Site_number                       + '^' +
        Study.Site_abbreviation                 + '^' +
        Study.First_image.QaMessage             + '^' +
        DiagImgUrlString                        + '^' +
        Study.Patient_icn                       + '^' +
        Study.Patient_name                      + '^' +
        Cls                                     + '^' +
                                                  '^' +
                                                  '^' +
                                                  '^' +
                                                  '^' +
                                                  '^' +
                                                  '^' +
        MagBoolToStr(Study.sensitive)           + '^' +   {/ P117 NCAT - JK 12/6/2010 /}
        //p122t12 dmmn 3/26/12 - Julian has commented that the following two properties
        //should be swapped. view_status first then status
        Study.view_status                       + '^' +   {/ P117 NCAT - JK 12/6/2010 /}
        Study.status                            + '^' ;   {/ P117 NCAT - JK 12/6/2010 /}

         {/ P122 - JK 7/25/2011 Piece 31 - Image Annotated Flag (0 or 1) /}
        if Study.first_image.image_has_annotations = True then
          StudyString := StudyString + '1' + '^'
        else
          StudyString := StudyString + '0' + '^';

        {/ P122 - JK 7/25/2011 Piece 32 - TIU Completed Status/}
        StudyString := StudyString + Study.first_image.associated_note_resulted + '^';

        {/ P122 - JK 7/25/2011 Piece 33 - Image Annotation Status (0 or 1) /}
        StudyString := StudyString + IntToStr(Study.first_image.image_annotation_status) + '^';

        {/ P122 - JK 7/25/2011 Piece 34 - Image Annotatation Status Description /}
        StudyString := StudyString + Study.first_image.image_annotation_status_description + '^';

        {/ P122 - JK 7/25/2011 Piece 35 - Package /}
        StudyString := StudyString + Trim(Study.first_image.image_package);

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
      magAppMsg('s', 'Exception getting studies from [' + FSite.SiteNumber + '], Exception [' +
        e.Message + ']'); {JK 10/6/2009 - Maggmsgu refactoring}
      Results.Insert(0, '0^ERROR Accessing Patient Image list.');
      Results.Insert(1, '0^' + MagPiece(e.Message, #$A, 2));
    End;
  End;
End;

Procedure TMagRemoteWSBrokerV7.GetImageGlobalLookup(Ien: String; Var Rlist: TStrings);
Var
  ImgSys: imagingClinicalDisplaySOAP_v7.GetImageSystemGlobalNode;
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
      magAppMsg('s', 'Getting system gloabl nodes from ViX for image [' + Ien + ']'); {JK 10/6/2009 - Maggmsgu refactoring}
      ImgSys := imagingClinicalDisplaySOAP_v7.GetImageSystemGlobalNode.Create();
      ImgSys.ID := Ien;

      ImgSysResponse := (callWSMethodWithBSE(getImageGlobalLookupWrapper, ImgSys) As ImageSystemGlobalNodeType);
      SetTextStr(ImgSysResponse.ImageInfo, Rlist);
    End;
  Except
    On e: Exception Do
    Begin
        //LogMsg('','Exception getting system global node information, [' + e.Message + ']');
      magAppMsg('', 'Exception getting system global node information, [' + e.Message + ']'); {JK 10/6/2009 - Maggmsgu refactoring}
    End;
  End;
  // not done to the DOD
End;

Procedure TMagRemoteWSBrokerV7.GetMagDevFields(Ien, Flags: String; Var Output: Tstringlist);
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
      magAppMsg('s', 'Getting dev fields from ViX for image [' + Ien + ']'); {JK 10/6/2009 - Maggmsgu refactoring}
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
      magAppMsg('', 'Exception getting system global node information, [' + e.Message + ']'); {JK 10/6/2009 - Maggmsgu refactoring}
    End;
  End;
  // not done to the DOD
End;

Procedure TMagRemoteWSBrokerV7.LogCopyAccess(IObj: TImageData; Msg: String;
  EventType: TMagImageAccessEventType);
Var
  ImageEvent: PostImageAccessEvent;
  ReasonCode: String;
  ReasonDesc: String;
Begin
  ReasonCode := MagPiece(Msg, '^', 1);
  ReasonDesc := MagPiece(Msg, '^', 7);

  Try
    ImageEvent                              := PostImageAccessEvent.Create();
    ImageEvent.Log_event                    := ImageAccessLogEventType.Create();
    ImageEvent.Log_event.ID                 := IObj.Mag0;
    ImageEvent.Log_event.PatientICN         := FPatientICN;
//    ImageEvent.Log_event.Reason := Reason; //msg;         {/ P117 NCAT - JK 12/12/2010 - obsolesced field /}
    ImageEvent.Log_event.reason_code        := ReasonCode;  {/ P117 NCAT - JK 12/12/2010 - new field /}
    ImageEvent.Log_event.reason_description := ReasonDesc;  {/ P117 NCAT - JK 12/12/2010 - new field /}
    ImageEvent.Log_event.EventType          := ConvertEventType(EventType);
    callWSMethodWithBSE(postImageAccessEventWrapper, ImageEvent);

    {/ P117 NCAT - JK 12/9/2010 - Added debug lines for building P104 test scripts /}
    case EventType of
      COPY_TO_CLIPBOARD:
        magAppMsg('', 'v7 LogCopyAccess COPY_TO_CLIPBOARD: TransactionId[' +
                         ImageEvent.transaction_id  +  '] ICN[' +
                         FPatientICN + '] ReasonCode[' +
                         ReasonCode + '] ReasonDesc[' + ReasonDesc + ']');
      PRINT_IMAGE:
        magAppMsg('', 'v7 LogCopyAccess PRINT_IMAGE: TransactionId[' +
                         ImageEvent.transaction_id  +  '] ICN[' +
                         FPatientICN + '] ReasonCode[' +
                         ReasonCode + '] ReasonDesc[' + ReasonDesc + ']');
      UMagClasses.PATIENT_ID_MISMATCH:
        magAppMsg('', 'v7 LogCopyAccess PATIENT_ID_MISMATCH: TransactionId[' +
                         ImageEvent.transaction_id  +  '] ICN[' +
                         FPatientICN + '] ReasonCode[' +
                         ReasonCode + '] ReasonDesc[' + ReasonDesc + ']');
    end;
  Except
    On e: Exception Do
    Begin
      //LogMsg('','Exception logging Copy Access, [' + e.Message + ']');
      magAppMsg('', 'Exception logging Copy Access, [' + e.Message + ']'); {JK 10/6/2009 - Maggmsgu refactoring}
      // log error
    End;
  End;
End;

Function TMagRemoteWSBrokerV7.ConvertEventType(EType: TMagImageAccessEventType): EventType;
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

Procedure TMagRemoteWSBrokerV7.GetImageInformation(IObj: TImageData; Var Output: TStrings);
Var
  ImgInfo: imagingClinicalDisplaySOAP_v7.GetImageInformation;
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
      magAppMsg('s', 'Getting image information from ViX for image [' + IObj.Mag0 + ']'); {JK 10/6/2009 - Maggmsgu refactoring}
      ImgInfo := imagingClinicalDisplaySOAP_v7.GetImageInformation.Create();
      ImgInfo.ID := IObj.Mag0;
      ImgInfoResponse := (callWSMethodWithBSE(getimageinformationWrapper, ImgInfo) As ImageInformationType);
      SetTextStr(ImgInfoResponse.ImageInfo, Output);
    Except
      On e: Exception Do
      Begin
        //LogMsg('','Exception getting image information, [' + e.Message + ']');
        magAppMsg('', 'Exception getting image information, [' + e.Message + ']'); {JK 10/6/2009 - Maggmsgu refactoring}
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

Function TMagRemoteWSBrokerV7.Getreport(IObj: TImageData): TStrings;
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
    magAppMsg('s', 'Getting study report from VIX for study  [' + StudyId + ']'); {JK 10/6/2009 - Maggmsgu refactoring}
    Params := getStudyReport.Create();
    Params.STUDY_ID := StudyId;
    Response := (callWSMethodWithBSE(getStudyReportWrapper, Params) As StudyReportType);
    Result.Text := Response.studyReport;
  Except
    On e: Exception Do
    Begin
      //LogMsg('s','Exception getting study report, ' + e.Message, MagLogError);
      magAppMsg('s', 'Exception getting study report, ' + e.Message, MagmsgERROR); {JK 10/6/2009 - Maggmsgu refactoring}
      Result.Text := 'Error retrieving report for study [' + StudyId + ']';
    End;
  End;
End;

Procedure TMagRemoteWSBrokerV7.LogOfflineImageAccess(IObj: TImageData);
Begin
  // nothing to do for DOD
End;

Procedure TMagRemoteWSBrokerV7.LogAction(Msg: String);
Var
  ImageEvent: PostImageAccessEvent;
  ImgId: String;
Begin
  ImgId := MagPiece(Msg, '^', 3);
  Try
    ImageEvent                              := PostImageAccessEvent.Create();
    ImageEvent.Log_event                    := ImageAccessLogEventType.Create();
    ImageEvent.Log_event.ID                 := ImgId;
    ImageEvent.Log_event.PatientICN         := FPatientICN;
//    ImageEvent.Log_event.Reason := '';            {/ P117 NCAT - JK 12/12/2010 - obsolesced field /}
    ImageEvent.Log_event.reason_code        := '';  {/ P117 NCAT - JK 12/12/2010 - new field /}
    ImageEvent.Log_event.reason_description := '';  {/ P117 NCAT - JK 12/12/2010 - new field /}
    ImageEvent.Log_event.EventType          := IMAGE_ACCESS;
    callWSMethodWithBSE(postImageAccessEventWrapper, ImageEvent);


    {/ P117 NCAT - JK 12/9/2010 - Added debug lines for building P104 test scripts /}
    magAppMsg('', 'v7 LogAction IMAGE_ACCESS: TransactionID[' +
                     ImageEvent.transaction_id +  ']  ICN[' + FPatientICN + ']');

  Except
    On e: Exception Do
    Begin
      //LogMsg('','Exception logging Copy Access, [' + e.Message + ']');
      magAppMsg('', 'Exception logging Copy Access, [' + e.Message + ']'); {JK 10/6/2009 - Maggmsgu refactoring}
      // log error
    End;
  End;
End;

Function TMagRemoteWSBrokerV7.QueImage(ImgType: String; IObj: TImageData): TStrings;
Begin
  //jw 11/19/07
  Result := Tstringlist.Create();
  Result.Add('-1^Not applied for Webservice broker')
  // nothing to do for DOD (maybe pre-cache)?
End;

Function TMagRemoteWSBrokerV7.QueImageGroup(Images: String; IObj: TImageData): String;
Begin
  //jw 11/19/07
  Result := '';
  // nothing to do for DOD (maybe pre-cache)?
End;

Procedure TMagRemoteWSBrokerV7.GetImageGroup(IObj: TImageData; NoQAcheck: Boolean; Output: TStrings);
Var
  ReqParam: GetStudyImageList;
  Images: FatImagesType;
  Imagestring: String;
  i: Integer;
  Image: FatImageType;
  ImageURL: String;
  AbsImgUrlString, FullimgUrlString, DiagImgUrlString, TxtImgUrlString: String;
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
        // JMW 5/1/2013 p131 - need to map a location for the text file, even if
        // it isn't going to be used
        TxtImgUrlString := CreateImageUrlString(ImageURL, Image.Full_image_URI);
        TxtImgUrlString := GetImageUtility().GetTxtFilePath(TxtImgUrlString);

        {/ P117-NCAT JK 11/18/2010 - Create a filename and map it to the Url String}
        gsess.MagURLMap.Add(AbsImgUrlString, True);   {add in a name/value pair}
        gsess.MagURLMap.Add(FullImgUrlString, True);  {add in a name/value pair}
        gsess.MagURLMap.Add(DiagImgUrlString, True);  {add in a name/value pair}
        gsess.MagURLMap.Add(TxtImgUrlString, True);  {add in a name/value pair}

      // QA Message goes after the abbr and before the diagnostic image url

        Imagestring :=
          'B2^' +
          Image.Image_Id + '^' +              {P2: Mag0}
          FullimgUrlString + '^' +            {P3: FFile}
          AbsImgUrlString + '^' +             {P4: AFile}
          Image.Description + '^' +           {P5: ImgDes}
          '^' +                               {P6: no longer in use}
          Inttostr(Image.Image_type) + '^' +  {P7: ImgType}
          Image.Procedure_ + '^' +            {P8: Proc}
          Image.Procedure_date + '^' +        {P9: Date}
          '^' +                               {P10: no longer in use}
          Image.Abs_Location + '^' +          {P11: AbsLocation}
          Image.Full_location + '^' +         {P12: FullLocation}
          Image.Dicom_sequence_number + '^' + {P13: DicomSequenceNumber}
          Image.Dicom_image_number + '^' +    {P14: DicomImageNumber}
          '1^' +                              {P15: GroupCount}
          Image.Site_number + '^' +           {P16: PlaceIEN}
          Image.Site_abbr + '^' +             {P17: PlaceCode}
          Image.QaMessage + '^' +             {P18: QAMsg}
          DiagImgUrlString + '^' +            {P19: BigFile}
          Image.Patient_icn + '^' +           {P20: DFN}
          Image.Patient_name + '^' +          {P21: PtName}
          Image.Image_class + '^' +           {P22: MagClass}
          '^' +                               {P23: Capture Date - not used here}
          '^' +                               {P24: DocumentDate - not used here}
          '^' +                               {P25: IGroupIEN - not used here}
          '^' +                               {P26: ICh1Type - not used here}
          '^' +                               {P27: ServerName - not used here}
          '^' +                               {P28: ServerPort - not used here}
          '^' +                               {P29: MagSensitive - not used here}
          Image.view_status + '^' +           {P30: MagViewStatus}
          Image.status + '^' +                                    {P31: MagStatus}

          {/ P122 - JK 7/28/2011 /}
          Magbooltostrint(Image.image_has_annotations) + '^' +    {P32: Annotated}
          Image.associated_note_resulted + '^' +                  {P33: Resulted}
          IntToStr(Image.image_annotation_status) + '^' +         {P34: AnnotationS tatus}
          Image.image_annotation_status_description + '^' +       {P35: Annotation Status Description}
          Image.image_package;                                    {P36: Package}


        Output.Add(Imagestring);
      End;
    Except
      On e: Exception Do
      Begin
      //LogMsg('','Exception getting group images for study [' + iobj.Mag0 + '] from [' + FSite.SiteNumber + '], Exception [' + e.Message + ']');
        magAppMsg('', 'Exception getting group images for study [' + IObj.Mag0 + '] from [' + FSite.SiteNumber + '], Exception [' +
          e.Message + ']'); {JK 10/6/2009 - Maggmsgu refactoring}
        Output.Add('0^ERROR: Image entry ' + IObj.Mag0 + ' Doesn''t exist');
      End;
    End;
  Finally
    Magremoteinterface.RIVNotifyAllListeners(Nil, 'IMAGE_COPY_COMPLETE', '');
  End;
End;
 {7/12/12 gek Merge 130->129}
{/ P130 JK 6/25/2012 - added the ShowDeletedImages parameter /}
Function TMagRemoteWSBrokerV7.ConvertToFilter(Pkg, Cls, Types, Event, Spc, FrDate, ToDate, Origin: String; ShowDeletedImages: Boolean): FilterType;
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
  Result.include_deleted := ShowDeletedImages; {/ P130 - JK 6/25/2012 /} {7/12/12 gek Merge 130->129}

End;

Function TMagRemoteWSBrokerV7.CreateUserCredentials(): UserCredentialsType;
Var
  Cred: UserCredentialsType;
Begin
  Cred := UserCredentialsType.Create();
  Cred.Fullname := FUserFullname;
  Cred.Duz := FUserDUZ;
  Cred.SSN := FUserSSN;
  Cred.SiteName := GSess.Wrksinst.Name;
  Cred.SiteNumber := PrimarySiteStationNumber;

  Cred.client_version := MagGetFileVersionInfo(Application.ExeName);  {JK 11/9/2010}  

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
   {/ P127T1 NST 04/06/2012 Send Reader Station Number (Reader Locking issue)  /}

Procedure TMagRemoteWSBrokerV7.RPMagTeleReaderUnreadlistGet(Var t: TStrings;
  AcquisitionPrimaryDivision, Sitecode, SpecialtyCode, ProcedureStrings,
  LastUpdate, UserDUZ, LocalSiteCode, SiteTimeOut, StatusOptions, LocalSiteStationNumber: String);
Begin
  If t = Nil Then
    t := Tstringlist.Create();
End;
   {/ P127T1 NST 04/06/2012 Send Reader Station Number (Reader Locking issue)  /}

Procedure TMagRemoteWSBrokerV7.RPMagTeleReaderUnreadlistLock(Var Xmsg: String;
  AcquisitionPrimaryDivision, AcquisitionSiteCode, ItemID, LockUnlockValue,
  UserFullName, UserInitials, LocalDUZ, LocalSiteCode, LocalSiteStationNumber: String);
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

Procedure TMagRemoteWSBrokerV7.OnBeforePostEvent(Const HTTPReqResp: THTTPReqResp; Data: Pointer);
Var
  Timeout: Integer;
Begin
//  Timeout := 50000; // in milleseconds.
  Timeout := 90000; // in milleseconds.    {/ P117 NCAT - JK 12/2/2010 - increased the wait time to 90 seconds in wininet.dll /}
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

Function TMagRemoteWSBrokerV7.handleBSEException(e: Exception; attemptCount: Integer): Boolean;
Begin
  Result := False;
  If Pos('BSE TOKEN EXPIRED', e.Message) > 1 Then
  Begin
    magAppMsg('s', 'Error was BSE TOKEN EXPIRED, will attempt to get a new token (if possible)', magmsgInfo); {JK 10/6/2009 - Maggmsgu refactoring}
    If attemptCount < 3 Then
    Begin
      magAppMsg('s', 'Current BSE login attempt is ' + Inttostr(attemptCount) + ', try to get new token', magmsgInfo); {JK 10/6/2009 - Maggmsgu refactoring}
      If Assigned(FSecurityTokenNeeded) Then
      Begin
        GSess.SecurityToken := FSecurityTokenNeeded;
        magAppMsg('s', 'Received new token ' + GSess.SecurityToken, magmsgInfo); {JK 10/6/2009 - Maggmsgu refactoring}
        Result := True;
      End
      Else
      Begin
        magAppMsg('s', 'FSecurityTokenNeeded not assigned, cannot get new token, clearing token to force CAPRI', magmsgInfo); {JK 10/6/2009 - Maggmsgu refactoring}
        // clear the token so it will prevent BSE from working, will fall back to CAPRI method
        gsess.SecurityToken := '';
        Result := True;
      End;
    End;
    If Not Result Then
    Begin
      magAppMsg('s', 'Could not get new token, cannot connect to remote site.', magmsgInfo); {JK 10/6/2009 - Maggmsgu refactoring}
    End;
  End;
End;

{/ P122 - JK 7/17/2011 /}
function TMagRemoteWSBrokerV7.IsAnnotsSupported: Boolean;
var
  Input: isAnnotationsSupported;
  TransId: TransactionIdentifierType;
  Response: isAnnotationsSupportedResponseType;
begin
  Input := isAnnotationsSupported.Create();
  Input.site_id := FSite.SiteNumber;
  Response := (callWSMethodWithBSE(getIsAnnotationSupported, Input) As isAnnotationsSupportedResponseType);
  Result := Response.response;
end;

{/ P122 - JK 10/4/2011 /}
function TMagRemoteWSBrokerV7.GetUserAnnotDUZ: String;
var
  Input: getUserDetails;
  TransId: TransactionIdentifierType;
  Response: getUserDetailsResponseType;
begin
  Input := getUserDetails.Create();
  Input.site_id := FSite.SiteNumber;
  Response := (callWSMethodWithBSE(GetAnnotUserDetails, Input) As getUserDetailsResponseType);
  Result := Response.response.user_id;
end;

{/ P122 - JK 9/27/2011 /}
function TMagRemoteWSBrokerV7.CanUserAnnotateRemotely: Boolean;
var
  Input: getUserDetails;
  TransId: TransactionIdentifierType;
  Response: getUserDetailsResponseType;
begin
  Input := getUserDetails.Create();
  Input.site_id := FSite.SiteNumber;
  Response := (callWSMethodWithBSE(GetAnnotUserDetails, Input) As getUserDetailsResponseType);
  Result := Response.response.can_create_annotations;
end;

{/ P122 - JK 9/27/2011 /}
function TMagRemoteWSBrokerV7.HasAnnotateMasterKey: Boolean;
var
  Input: getUserDetails;
  TransId: TransactionIdentifierType;
  Response: getUserDetailsResponseType;
  i: Integer;
begin
  Input := getUserDetails.Create();
  Input.site_id := FSite.SiteNumber;
  Response := (callWSMethodWithBSE(GetAnnotUserDetails, Input) As getUserDetailsResponseType);

  Result := False;
  for i := Low(Response.response.key) to High(Response.response.key) do
    if Response.response.key[i] = 'MAG ANNOTATE MGR' then
    begin
      Result := True;
      Break;
    end;
end;

{/ P122 - JK 7/17/2011 /}
function TMagRemoteWSBrokerV7.SaveAnnots(IEN: String; AnnotSource: String; Version: String; AnnotXML: TStringList): Boolean;
var
  Input: postAnnotationDetails;
  TransId: TransactionIdentifierType;
  Response: postAnnotationDetailsResponse;
begin
  Input := postAnnotationDetails.Create();
  Input.details := AnnotXML.Text;
  Input.image_id := IEN;
  Input.source := AnnotSource;
  Input.version := Version;
  Response := (callWSMethodWithBSE(postXMLAnnots, Input) As postAnnotationDetailsResponse);
  Result := response.response.saved_after_result;
end;

{/ P122 - JK 7/21/2011 /}
function TMagRemoteWSBrokerV7.GetAnnots(IEN: String): TStrings;
var
  Input: getImageAnnotations;
  TransId: TransactionIdentifierType;
  Response: getImageAnnotationsResponseType;
  i: Integer;
  S: String;
  Src: String;
  Completed, Deletion, SiteID: String;
  HistoryCount: Integer;
begin
  if Result = nil then
    Result := TStringList.Create
  else
    Result.Clear;

  {JK 9/7/2011 - Check for a nil IEN}
  if IEN = '' then
    Exit;

  Input := getImageAnnotations.Create;
  Input.image_id := IEN;
  Response := callGetAnnotListWithBSE(Input);

  HistoryCount := 0;
  for i := Low(Response) to High(Response) do
    Inc(HistoryCount);

  Result.Add('1^' + IntToStr(HistoryCount));

  for i := Low(Response) to High(Response) do
  begin

    if Response[i].source = ClinicalDisplay then
      Src := 'CLINICAL_DISPLAY'
    else if Response[i].source = ClinicalCapture then
      Src := 'CLINICAL_CAPTURE'
    else if Response[i].source = VistARad then
      Src := 'VISTARAD'
    else
      Src := 'SOURCENOTDEFINED';

    if Response[i].saved_after_result = True then
      Completed := '1'
    else
      Completed := '0';

    if Response[i].annotation_deleted then
      Deletion := '1'
    else
      Deletion := '0';

    SiteID := FSite.SiteNumber;

    {Create a string from the web service call that is identical in content and structure to the RPC version}
    S := Response[i].annotation_id      + '^' +      {Layer Number - a URN for a webservice call}
         Response[i].user.name_         + '^' +      {User name}
         Response[i].saved_date         + '^' +      {Saved DateTime}
         Response[i].annotation_version + '^' +      {ImageGear version number}
         Src                            + '^' +      {Source = CLINICAL_CAPTURE, CLINICAL_DISPLAY, VISTARAD}
         Deletion                       + '^' +      {Deletion}
         Completed                      + '^' +      {Resulted}
         Response[i].user.service       + '^' +      {Service}
         SiteID                         + '^' +      {SiteID}
         Response[i].user.duz           + '^';       {DUZ}

    Result.Add(S);

  end;
end;

{/ P122 - JK 7/21/2011 /}
function TMagRemoteWSBrokerV7.GetAnnotDetails(IEN, LayerID: String): String;
var
  Input: getAnnotationDetails;
  TransId: TransactionIdentifierType;
  Response: getAnnotationDetailsResponse;
  S: String;
  Src: String;
  Completed, Deletion, SiteID: String;
begin
  Input := getAnnotationDetails.Create;
  Input.transaction_id := TransId;
  Input.credentials := CreateUserCredentials;
  Input.image_id := IEN;
  Input.annotation_id := LayerID;
  Response := (callWSMethodWithBSE(GetXMLAnnotDetails, Input) As getAnnotationDetailsResponse);


    if Response.response.Annotation.source = ClinicalDisplay then
      Src := 'CLINICAL_DISPLAY'
    else if Response.response.Annotation.source = ClinicalCapture then
      Src := 'CLINICAL_CAPTURE'
    else if Response.response.Annotation.source = VistARad then
      Src := 'VISTARAD'
    else
      Src := 'SOURCENOTDEFINED';

    if Response.response.Annotation.saved_after_result = True then
      Completed := '1'
    else
      Completed := '0';

    if Response.response.Annotation.annotation_deleted then
      Deletion := '1'
    else
      Deletion := '0';

    SiteID := FSite.SiteNumber;

    {Create a string from the web service call that is identical in content and structure to the RPC version}
    S := Response.response.Annotation.annotation_id      + '^' +      {Layer Number - a URN for a webservice call}
         Response.response.Annotation.user.name_         + '^' +      {User name}
         Response.response.Annotation.saved_date         + '^' +      {Saved DateTime}
         Response.response.Annotation.annotation_version + '^' +      {ImageGear version number}
         Src                                             + '^' +      {Source = CLINICAL_CAPTURE, CLINICAL_DISPLAY, VISTARAD}
         Deletion                                        + '^' +      {Deletion}
         Completed                                       + '^' +      {Resulted}
         Response.response.Annotation.user.service       + '^' +      {Service}
         SiteID                                          + '^' +      {SiteID}
         Response.response.Annotation.user.duz           + '^' +       {DUZ}
                                                           '`' +
         Response.response.details;

  Result := S;

end;

{
  This is a method used to make all VIX calls for handling BSE. By calling this
  method in all cases, BSE exceptions will be handled in here. This method may
  throw an exception if the wrapper method throws a non-BSE exception or if
  the BSE exception could not be handled.
}

Function TMagRemoteWSBrokerV7.callWSMethodWithBSE(Method: TMagRemoteWSBrokerWrapper;
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
Function TMagRemoteWSBrokerV7.callGetStudyImageListWithBSE(Input : GetStudyImageList) : FatImagesType;
Var
  bseAttemptCount: Integer;
  tryAgain: Boolean;
  Response: getStudyImageListResponse;
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
      Result := FatImagesType(Response);
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

{/ P122 - JK 7/22/2011 - This method is based off the technique Julian created
  in callGetStudyImageListWithBSE to allow the web service call to return
  an array of objects. /}
Function TMagRemoteWSBrokerV7.callGetAnnotListWithBSE(Input: getImageAnnotations) : getImageAnnotationsResponseType;
Var
  bseAttemptCount: Integer;
  tryAgain: Boolean;
  Response: getImageAnnotationsResponse;
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

      Response := WSBroker.getImageAnnotations(input);
      Result := getImageAnnotationsResponseType(Response);
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

Procedure TMagRemoteWSBrokerV7.pingServerWrapper(Input: TRemotable;
  Var Response: TRemotable);
Begin
  (Input As PingServer).Credentials := CreateUserCredentials();
  (Input As PingServer).Transaction_id := CreateTransactionId();
  Response := WSBroker.PingServerEvent((Input As PingServer));
End;

procedure TMagRemoteWSBrokerV7.LogShallowStudyListProperties(Input: TRemotable);
const
  Delimiter = ', ';       {Use this delimiter to make for a long comma delimited string}
//  Delimiter = #13#10;   {Use this delimiter to add line breaks between items}
var
  S: WideString;
  TID, SITEID, PATIENTID: WideString;
  FilterPkg, FilterClass, FilterTypes, FilterEvent: WideString;
  FilterSpecialty: WideString;
  FilterOrigin: Origin;
  FilterFromDate, FilterToDate: DateType;
  FilterIncludeDeleted: Boolean;
  CredFullName, CredDUZ, CredSSN: WideString;
  CredSiteNumber, CredSiteName, CredSecurityToken, CredClientVersion: WideString;
  AuthSensLevel: Int64;
begin
  TID               := (Input As getpatientshallowstudyList).transaction_id;
  SITEID            := (Input As getpatientshallowstudyList).site_id;
  PATIENTID         := (Input As getpatientshallowstudyList).patient_id;
  FilterPkg         := (Input As getpatientshallowstudyList).filter.package_;
  FilterClass       := (Input As getpatientshallowstudyList).filter.class_;
  FilterTypes       := (Input As getpatientshallowstudyList).filter.types;
  FilterEvent       := (Input As getpatientshallowstudyList).filter.event;
  FilterSpecialty   := (Input As getpatientshallowstudyList).filter.specialty;
  FilterFromDate    := (Input As getpatientshallowstudyList).filter.from_date;
  FilterToDate      := (Input As getpatientshallowstudyList).filter.to_date;
  FilterOrigin      := (Input As getpatientshallowstudyList).filter.origin;

  FilterIncludeDeleted := (Input As getpatientshallowstudyList).filter.include_deleted;

  CredFullName      := (Input As getpatientshallowstudyList).credentials.fullname;
  CredDUZ           := (Input As getpatientshallowstudyList).credentials.duz;
  CredSSN           := (Input As getpatientshallowstudyList).credentials.ssn;
  CredSiteName      := (Input As getpatientshallowstudyList).credentials.siteName;
  CredSiteNumber    := (Input As getpatientshallowstudyList).credentials.siteNumber;
  CredSecurityToken := (Input As getpatientshallowstudyList).credentials.securityToken;
  CredClientVersion := (Input As getpatientshallowstudyList).credentials.client_version;

  AuthSensLevel     := (Input As getpatientshallowstudyList).authorizedSensitivityLevel;

  S := 'ShallowStudyList Properties = '                   + Delimiter +
       'Transaction ID = '   + TID                        + Delimiter +
       'Site ID = '          + SITEID                     + Delimiter +
       'Patient ID = '       + PatientID                  + Delimiter +
       'Filter PKG = '       + FilterPkg                  + Delimiter +
       'Filter CLASS = '     + FilterClass                + Delimiter +
       'Filter TYPES = '     + FilterTypes                + Delimiter +
       'Filter EVENT = '     + FilterEvent                + Delimiter +
       'Filter Specialty = ' + FilterSpecialty            + Delimiter +
       'Filter From Date = ' + WideString(FilterFromDate) + Delimiter +
       'Filter To Date = '   + WideString(FilterToDate)   + Delimiter;

   case FilterOrigin of
     UNSPECIFIED: S := S + 'Filter Origin = UNSPECIFIED' + Delimiter;
     VA:          S := S + 'Filter Origin = VA'          + Delimiter;
     NON_VA:      S := S + 'Filter Origin = NON_VA'      + Delimiter;
     DOD:         S := S + 'Filter Origin = DOD'         + Delimiter;
     FEE:         S := S + 'Filter Origin = FEE'         + Delimiter;
   end;

   if FilterIncludeDeleted = False then
     S := S + 'Filter Include Deleted = FALSE'  + Delimiter
   else
     S := S + 'Filter Include Deleted = TRUE' + Delimiter;

   S := S +
        'Cred Full Name = '      + CredFullName      + Delimiter +
        'Cred DUZ = '            + CredDUZ           + Delimiter +

        {/ P122 - JK 9/14/2011 P117 T6->T8 merged code. /}
        {/p117 gek take out SSN}
        //'Cred SSN = '            + CredSSN           + Delimiter +

        'Cred Site Name = '      + CredSiteName      + Delimiter +
        'Cred Site Number = '    + CredSiteNumber    + Delimiter +
        'Cred Security Token = ' + CredSecurityToken + Delimiter +
        'Cred Client Version = ' + CredClientVersion + Delimiter;

   S := S + 'Auth Sensitivity Level = ' + IntToStr(AuthSensLevel) + Delimiter;

   if (Input As getpatientshallowstudyList).includeArtifacts = False then
     S := S + 'Include Artifacts = FALSE'
   else
     S := S + 'Include Artifacts = TRUE';

   magAppMsg('', S);
end;

Procedure TMagRemoteWSBrokerV7.getPatientStudyListWrapper(Input: TRemotable;
  Var Response: TRemotable);
Begin
  (Input As GetPatientShallowStudyList).Credentials := CreateUserCredentials();
  (Input As GetPatientShallowStudyList).Transaction_id := CreateTransactionId();
 {7/12/12 gek Merge 130->129}{commented out in 130}
//  (Input As getpatientshallowstudyList).filter.include_deleted := False;   {/ P130 - JK 6/26/2012 /}


  {Write the Shallow Study List properties to the logger}
  LogShallowStudyListProperties(Input As GetPatientShallowStudyList);

  Response := WSBroker.GetPatientShallowStudyList(Input As GetPatientShallowStudyList);
End;

Procedure TMagRemoteWSBrokerV7.getMagDevFieldsWrapper(Input: TRemotable; Var Response: TRemotable);
Begin
  (Input As GetImageDevFields).Credentials := CreateUserCredentials();
  (Input As GetImageDevFields).Transaction_id := CreateTransactionId();
  Response := WSBroker.GetImageDevFields(Input As GetImageDevFields);
End;

Procedure TMagRemoteWSBrokerV7.getImageGlobalLookupWrapper(Input: TRemotable;
  Var Response: TRemotable);
Begin
  (Input As imagingClinicalDisplaySOAP_v7.GetImageSystemGlobalNode).Credentials := CreateUserCredentials();
  (Input As imagingClinicalDisplaySOAP_v7.GetImageSystemGlobalNode).Transaction_id := CreateTransactionId();
  Response := WSBroker.GetImageSystemGlobalNode(Input As imagingClinicalDisplaySOAP_v7.GetImageSystemGlobalNode);
End;

Procedure TMagRemoteWSBrokerV7.postImageAccessEventWrapper(Input: TRemotable;
  Var Response: TRemotable);
Begin
  (Input As PostImageAccessEvent).Transaction_id := CreateTransactionId();
  (Input As PostImageAccessEvent).Log_event.Credentials := CreateUserCredentials();
  Response := WSBroker.PostImageAccessEvent(Input As PostImageAccessEvent);
End;

Procedure TMagRemoteWSBrokerV7.getImageInformationWrapper(Input: TRemotable;
  Var Response: TRemotable);
Begin
  (Input As imagingClinicalDisplaySOAP_v7.GetImageInformation).Credentials := CreateUserCredentials();
  (Input As imagingClinicalDisplaySOAP_v7.GetImageInformation).Transaction_id := CreateTransactionId();
  Response := WSBroker.GetImageInformation(Input As imagingClinicalDisplaySOAP_v7.GetImageInformation);
End;

{/ P122 - JK 7/17/2011 /}
procedure TMagRemoteWSBrokerV7.getIsAnnotationSupported(Input: TRemotable;
  var Response: TRemotable);
begin
  (Input As IsAnnotationsSupported).Credentials := CreateUserCredentials();
  (Input As IsAnnotationsSupported).Transaction_id := CreateTransactionId();
  Response := WSBroker.IsAnnotationsSupported(Input As IsAnnotationsSupported);
end;

{/ P122 - JK 9/27/2011 /}
procedure TMagRemoteWSBrokerV7.getAnnotUserDetails(Input: TRemotable;
  var Response: TRemotable);
begin
  (Input As getUserDetails).Credentials := CreateUserCredentials();
  (Input As getUserDetails).Transaction_id := CreateTransactionId();
  Response := WSBroker.getUserDetails(Input As getUserDetails);
end;

{/ P122- JK 7/17/2011 /}
procedure TMagRemoteWSBrokerV7.postXMLAnnots(Input: TRemotable;
  var Response: TRemotable);
begin
  (Input As postAnnotationDetails).Credentials := CreateUserCredentials();
  (Input As postAnnotationDetails).Transaction_id := CreateTransactionId();
  Response := WSBroker.postAnnotationDetails(Input As postAnnotationDetails);
end;

{/ P122- JK 7/17/2011 /}
procedure TMagRemoteWSBrokerV7.GetXMLAnnotDetails(Input: TRemotable;
  var Response: TRemotable);
begin
  (Input As getAnnotationDetails).Credentials := CreateUserCredentials();
  (Input As getAnnotationDetails).Transaction_id := CreateTransactionId();
  Response := WSBroker.getAnnotationDetails(Input As getAnnotationDetails);
end;

Procedure TMagRemoteWSBrokerV7.getStudyReportWrapper(Input: TRemotable;
  Var Response: TRemotable);
Begin
  (Input As getStudyReport).Credentials := CreateUserCredentials();
  (Input As getStudyReport).Transaction_id := CreateTransactionId();
  Response := WSBroker.getStudyReport(Input As getstudyreport);
End;

End.
