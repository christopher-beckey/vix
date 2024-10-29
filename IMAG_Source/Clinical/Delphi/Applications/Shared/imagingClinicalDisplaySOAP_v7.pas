// ************************************************************************ //
// The types declared in this file were generated from data read from the
// WSDL File described below:
// WSDL     : C:\DevD2007\P122\Clin\WSDL\imagingClinicalDisplaySOAP_v7.wsdl
//  >Import : C:\DevD2007\P122\Clin\WSDL\imagingClinicalDisplaySOAP_v7.wsdl:0
// Encoding : UTF-8
// Version  : 1.0
// (7/28/2011 8:42:50 AM - - $Rev: 10138 $)
// ************************************************************************ //

unit imagingClinicalDisplaySOAP_v7;

interface

uses InvokeRegistry, SOAPHTTPClient, Types, XSBuiltIns;

const
  IS_OPTN = $0001;
  IS_UNBD = $0002;
  IS_NLBL = $0004;
  IS_REF  = $0080;


type

  // ************************************************************************ //
  // The following types, referred to in the WSDL document are not being represented
  // in this file. They are either aliases[@] of other types represented or were referred
  // to but never[!] declared in the document. The types from the latter category
  // typically map to predefined/known XML or Borland types; however, they could also 
  // indicate incorrect WSDL documents that failed to declare or import a schema type.
  // ************************************************************************ //
  // !:string          - "http://www.w3.org/2001/XMLSchema"[Gbl]
  // !:boolean         - "http://www.w3.org/2001/XMLSchema"[Gbl]
  // !:integer         - "http://www.w3.org/2001/XMLSchema"[Gbl]

  AnnotationUserType   = class;                 { "urn:v7.soap.webservices.clinicaldisplay.imaging.med.va.gov"[GblCplx] }
  AnnotationType       = class;                 { "urn:v7.soap.webservices.clinicaldisplay.imaging.med.va.gov"[GblCplx] }
  AnnotationDetailsType = class;                { "urn:v7.soap.webservices.clinicaldisplay.imaging.med.va.gov"[GblCplx] }
  FilterType           = class;                 { "urn:v7.soap.webservices.clinicaldisplay.imaging.med.va.gov"[GblCplx] }
  UserCredentialsType  = class;                 { "urn:v7.soap.webservices.clinicaldisplay.imaging.med.va.gov"[GblCplx] }
  ImageAccessLogEventType = class;              { "urn:v7.soap.webservices.clinicaldisplay.imaging.med.va.gov"[GblCplx] }
  FatImageType         = class;                 { "urn:v7.soap.webservices.clinicaldisplay.imaging.med.va.gov"[GblCplx] }
  ShallowStudyType     = class;                 { "urn:v7.soap.webservices.clinicaldisplay.imaging.med.va.gov"[GblCplx] }
  ShallowStudiesErrorMessageType = class;       { "urn:v7.soap.webservices.clinicaldisplay.imaging.med.va.gov"[GblCplx] }
  ShallowStudiesType   = class;                 { "urn:v7.soap.webservices.clinicaldisplay.imaging.med.va.gov"[GblCplx] }
  ShallowStudiesResponseType = class;           { "urn:v7.soap.webservices.clinicaldisplay.imaging.med.va.gov"[Lit][GblCplx] }
  ImageAccessEventType = class;                 { "urn:v7.soap.webservices.clinicaldisplay.imaging.med.va.gov"[Lit][GblCplx] }
  ImageInformationType = class;                 { "urn:v7.soap.webservices.clinicaldisplay.imaging.med.va.gov"[Lit][GblCplx] }
  ImageSystemGlobalNodeType = class;            { "urn:v7.soap.webservices.clinicaldisplay.imaging.med.va.gov"[Lit][GblCplx] }
  ImageDevFieldsType   = class;                 { "urn:v7.soap.webservices.clinicaldisplay.imaging.med.va.gov"[Lit][GblCplx] }
  StudyReportType      = class;                 { "urn:v7.soap.webservices.clinicaldisplay.imaging.med.va.gov"[Lit][GblCplx] }
  RemoteMethodParameterType = class;            { "urn:v7.soap.webservices.clinicaldisplay.imaging.med.va.gov"[GblCplx] }
  RemoteMethodResponseType = class;             { "urn:v7.soap.webservices.clinicaldisplay.imaging.med.va.gov"[Lit][GblCplx] }
  PingServerType       = class;                 { "urn:v7.soap.webservices.clinicaldisplay.imaging.med.va.gov"[Lit][GblCplx] }
  PrefetchResponseType = class;                 { "urn:v7.soap.webservices.clinicaldisplay.imaging.med.va.gov"[Lit][GblCplx] }
  PatientSensitiveCheckResponseType = class;    { "urn:v7.soap.webservices.clinicaldisplay.imaging.med.va.gov"[GblCplx] }
  PatientSensitiveCheckWrapperResponseType = class;   { "urn:v7.soap.webservices.clinicaldisplay.imaging.med.va.gov"[Lit][GblCplx] }
  getAnnotationDetailsResponseType = class;     { "urn:v7.soap.webservices.clinicaldisplay.imaging.med.va.gov"[Lit][GblCplx] }
  postAnnotationDetailsResponseType = class;    { "urn:v7.soap.webservices.clinicaldisplay.imaging.med.va.gov"[Lit][GblCplx] }
  getUserDetailsResponseType = class;           { "urn:v7.soap.webservices.clinicaldisplay.imaging.med.va.gov"[Lit][GblCplx] }
  isAnnotationsSupportedResponseType = class;   { "urn:v7.soap.webservices.clinicaldisplay.imaging.med.va.gov"[Lit][GblCplx] }
  getPatientSensitivityLevel = class;           { "urn:v7.soap.webservices.clinicaldisplay.imaging.med.va.gov"[Lit][GblElm] }
  getPatientSensitivityLevelResponse = class;   { "urn:v7.soap.webservices.clinicaldisplay.imaging.med.va.gov"[Lit][GblElm] }
  getPatientShallowStudyList = class;           { "urn:v7.soap.webservices.clinicaldisplay.imaging.med.va.gov"[Lit][GblElm] }
  getPatientShallowStudyListResponse = class;   { "urn:v7.soap.webservices.clinicaldisplay.imaging.med.va.gov"[Lit][GblElm] }
  getStudyImageList    = class;                 { "urn:v7.soap.webservices.clinicaldisplay.imaging.med.va.gov"[Lit][GblElm] }
  postImageAccessEvent = class;                 { "urn:v7.soap.webservices.clinicaldisplay.imaging.med.va.gov"[Lit][GblElm] }
  postImageAccessEventResponse = class;         { "urn:v7.soap.webservices.clinicaldisplay.imaging.med.va.gov"[Lit][GblElm] }
  pingServer           = class;                 { "urn:v7.soap.webservices.clinicaldisplay.imaging.med.va.gov"[Lit][GblElm] }
  postPingServerResponse = class;               { "urn:v7.soap.webservices.clinicaldisplay.imaging.med.va.gov"[Lit][GblElm] }
  prefetchStudyList    = class;                 { "urn:v7.soap.webservices.clinicaldisplay.imaging.med.va.gov"[Lit][GblElm] }
  PrefetchStudyListResponse = class;            { "urn:v7.soap.webservices.clinicaldisplay.imaging.med.va.gov"[Lit][GblElm] }
  getImageInformation  = class;                 { "urn:v7.soap.webservices.clinicaldisplay.imaging.med.va.gov"[Lit][GblElm] }
  getImageInformationResponse = class;          { "urn:v7.soap.webservices.clinicaldisplay.imaging.med.va.gov"[Lit][GblElm] }
  getImageSystemGlobalNode = class;             { "urn:v7.soap.webservices.clinicaldisplay.imaging.med.va.gov"[Lit][GblElm] }
  getImageSystemGlobalNodeResponse = class;     { "urn:v7.soap.webservices.clinicaldisplay.imaging.med.va.gov"[Lit][GblElm] }
  getImageDevFields    = class;                 { "urn:v7.soap.webservices.clinicaldisplay.imaging.med.va.gov"[Lit][GblElm] }
  getImageDevFieldsResponse = class;            { "urn:v7.soap.webservices.clinicaldisplay.imaging.med.va.gov"[Lit][GblElm] }
  getStudyReport       = class;                 { "urn:v7.soap.webservices.clinicaldisplay.imaging.med.va.gov"[Lit][GblElm] }
  getStudyReportResponse = class;               { "urn:v7.soap.webservices.clinicaldisplay.imaging.med.va.gov"[Lit][GblElm] }
  remoteMethodPassthrough = class;              { "urn:v7.soap.webservices.clinicaldisplay.imaging.med.va.gov"[Lit][GblElm] }
  remoteMethodPassthroughResponse = class;      { "urn:v7.soap.webservices.clinicaldisplay.imaging.med.va.gov"[Lit][GblElm] }
  getImageAnnotations  = class;                 { "urn:v7.soap.webservices.clinicaldisplay.imaging.med.va.gov"[Lit][GblElm] }
  getAnnotationDetails = class;                 { "urn:v7.soap.webservices.clinicaldisplay.imaging.med.va.gov"[Lit][GblElm] }
  getAnnotationDetailsResponse = class;         { "urn:v7.soap.webservices.clinicaldisplay.imaging.med.va.gov"[Lit][GblElm] }
  postAnnotationDetails = class;                { "urn:v7.soap.webservices.clinicaldisplay.imaging.med.va.gov"[Lit][GblElm] }
  postAnnotationDetailsResponse = class;        { "urn:v7.soap.webservices.clinicaldisplay.imaging.med.va.gov"[Lit][GblElm] }
  getUserDetails       = class;                 { "urn:v7.soap.webservices.clinicaldisplay.imaging.med.va.gov"[Lit][GblElm] }
  getUserDetailsResponse = class;               { "urn:v7.soap.webservices.clinicaldisplay.imaging.med.va.gov"[Lit][GblElm] }
  isAnnotationsSupported = class;               { "urn:v7.soap.webservices.clinicaldisplay.imaging.med.va.gov"[Lit][GblElm] }
  isAnnotationsSupportedResponse = class;       { "urn:v7.soap.webservices.clinicaldisplay.imaging.med.va.gov"[Lit][GblElm] }
  image                = class;                 { "urn:v7.soap.webservices.clinicaldisplay.imaging.med.va.gov"[Alias] }
  study                = class;                 { "urn:v7.soap.webservices.clinicaldisplay.imaging.med.va.gov"[Alias] }
  RemoteMethodParameterValueType = class;       { "urn:v7.soap.webservices.clinicaldisplay.imaging.med.va.gov"[GblCplx] }
  remoteMethodParameter = class;                { "urn:v7.soap.webservices.clinicaldisplay.imaging.med.va.gov"[Alias] }
  response             = class;                 { "urn:v7.soap.webservices.clinicaldisplay.imaging.med.va.gov"[Alias] }
  UserType             = class;                 { "urn:v7.soap.webservices.clinicaldisplay.imaging.med.va.gov"[GblCplx] }

  { "urn:v7.soap.webservices.clinicaldisplay.imaging.med.va.gov"[Smpl] }
  source = (ClinicalDisplay, VistARad, ClinicalCapture);

  { "urn:v7.soap.webservices.clinicaldisplay.imaging.med.va.gov"[Smpl] }
  origin = (UNSPECIFIED, VA, NON_VA, DOD, FEE);

  { "urn:v7.soap.webservices.clinicaldisplay.imaging.med.va.gov"[Smpl] }
  eventType = (IMAGE_ACCESS, IMAGE_COPY, IMAGE_PRINT, PATIENT_ID_MISMATCH, LOG_RESTRICTED_ACCESS);

  { "urn:v7.soap.webservices.clinicaldisplay.imaging.med.va.gov"[GblSmpl] }
  ShallowStudiesErrorType = (INSUFFICIENT_SENSITIVE_LEVEL, OTHER_ERROR);

  { "urn:v7.soap.webservices.clinicaldisplay.imaging.med.va.gov"[GblSmpl] }
  RemoteMethodParameterTypeType = (LIST, LITERAL, REFERENCE);

  { "urn:v7.soap.webservices.clinicaldisplay.imaging.med.va.gov"[Smpl] }
  pingResponse = (SERVER_READY, SERVER_UNAVAILABLE, VISTA_UNAVAILABLE);

  { "urn:v7.soap.webservices.clinicaldisplay.imaging.med.va.gov"[Smpl] }
  prefetchResponse = (SUBMITTED);

  { "urn:v7.soap.webservices.clinicaldisplay.imaging.med.va.gov"[GblSmpl] }
  PatientSensitivityLevelType = (RPC_FAILURE, NO_ACTION_REQUIRED, DISPLAY_WARNING, DISPLAY_WARNING_REQUIRE_OK, DISPLAY_WARNING_CANNOT_CONTINUE, ACCESS_DENIED);



  // ************************************************************************ //
  // XML       : AnnotationUserType, global, <complexType>
  // Namespace : urn:v7.soap.webservices.clinicaldisplay.imaging.med.va.gov
  // ************************************************************************ //
  AnnotationUserType = class(TRemotable)
  private
    Fname_: WideString;
    Fduz: WideString;
    Fservice: WideString;
  published
    property name_:   WideString  read Fname_ write Fname_;
    property duz:     WideString  read Fduz write Fduz;
    property service: WideString  read Fservice write Fservice;
  end;



  // ************************************************************************ //
  // XML       : AnnotationType, global, <complexType>
  // Namespace : urn:v7.soap.webservices.clinicaldisplay.imaging.med.va.gov
  // ************************************************************************ //
  AnnotationType = class(TRemotable)
  private
    Fuser: AnnotationUserType;
    Fsaved_date: WideString;
    Fannotation_id: WideString;
    Fimage_id: WideString;
    Fsource: source;
    Fsaved_after_result: Boolean;
    Fannotation_version: WideString;
    Fannotation_deleted: Boolean;
  public
    destructor Destroy; override;
  published
    property user:               AnnotationUserType  read Fuser write Fuser;
    property saved_date:         WideString          read Fsaved_date write Fsaved_date;
    property annotation_id:      WideString          read Fannotation_id write Fannotation_id;
    property image_id:           WideString          read Fimage_id write Fimage_id;
    property source:             source              read Fsource write Fsource;
    property saved_after_result: Boolean             read Fsaved_after_result write Fsaved_after_result;
    property annotation_version: WideString          read Fannotation_version write Fannotation_version;
    property annotation_deleted: Boolean             read Fannotation_deleted write Fannotation_deleted;
  end;



  // ************************************************************************ //
  // XML       : AnnotationDetailsType, global, <complexType>
  // Namespace : urn:v7.soap.webservices.clinicaldisplay.imaging.med.va.gov
  // ************************************************************************ //
  AnnotationDetailsType = class(TRemotable)
  private
    FAnnotation: AnnotationType;
    Fdetails: WideString;
  public
    destructor Destroy; override;
  published
    property Annotation: AnnotationType  read FAnnotation write FAnnotation;
    property details:    WideString      read Fdetails write Fdetails;
  end;

  DateType        =  type WideString;      { "urn:v7.soap.webservices.clinicaldisplay.imaging.med.va.gov"[GblSmpl] }


  // ************************************************************************ //
  // XML       : FilterType, global, <complexType>
  // Namespace : urn:v7.soap.webservices.clinicaldisplay.imaging.med.va.gov
  // ************************************************************************ //
  FilterType = class(TRemotable)
  private
    Fpackage_: WideString;
    Fclass_: WideString;
    Ftypes: WideString;
    Fevent: WideString;
    Fspecialty: WideString;
    Ffrom_date: DateType;
    Fto_date: DateType;
    Forigin: origin;
    Finclude_deleted: Boolean;
  published
    property package_:        WideString  Index (IS_NLBL) read Fpackage_ write Fpackage_;
    property class_:          WideString  Index (IS_NLBL) read Fclass_ write Fclass_;
    property types:           WideString  Index (IS_NLBL) read Ftypes write Ftypes;
    property event:           WideString  Index (IS_NLBL) read Fevent write Fevent;
    property specialty:       WideString  Index (IS_NLBL) read Fspecialty write Fspecialty;
    property from_date:       DateType    Index (IS_NLBL) read Ffrom_date write Ffrom_date;
    property to_date:         DateType    Index (IS_NLBL) read Fto_date write Fto_date;
    property origin:          origin      Index (IS_NLBL) read Forigin write Forigin;
    property include_deleted: Boolean     Index (IS_NLBL) read Finclude_deleted write Finclude_deleted;
  end;



  // ************************************************************************ //
  // XML       : UserCredentialsType, global, <complexType>
  // Namespace : urn:v7.soap.webservices.clinicaldisplay.imaging.med.va.gov
  // ************************************************************************ //
  UserCredentialsType = class(TRemotable)
  private
    Ffullname: WideString;
    Fduz: WideString;
    Fssn: WideString;
    FsiteName: WideString;
    FsiteNumber: WideString;
    FsecurityToken: WideString;
    Fclient_version: WideString;
  published
    property fullname:       WideString  read Ffullname write Ffullname;
    property duz:            WideString  Index (IS_NLBL) read Fduz write Fduz;
    property ssn:            WideString  Index (IS_NLBL) read Fssn write Fssn;
    property siteName:       WideString  read FsiteName write FsiteName;
    property siteNumber:     WideString  read FsiteNumber write FsiteNumber;
    property securityToken:  WideString  Index (IS_NLBL) read FsecurityToken write FsecurityToken;
    property client_version: WideString  Index (IS_NLBL) read Fclient_version write Fclient_version;
  end;



  // ************************************************************************ //
  // XML       : ImageAccessLogEventType, global, <complexType>
  // Namespace : urn:v7.soap.webservices.clinicaldisplay.imaging.med.va.gov
  // ************************************************************************ //
  ImageAccessLogEventType = class(TRemotable)
  private
    Fid: WideString;
    FpatientIcn: WideString;
    Freason_code: WideString;
    Freason_description: WideString;
    Fcredentials: UserCredentialsType;
    FeventType: eventType;
  public
    destructor Destroy; override;
  published
    property id:                 WideString           read Fid write Fid;
    property patientIcn:         WideString           read FpatientIcn write FpatientIcn;
    property reason_code:        WideString           read Freason_code write Freason_code;
    property reason_description: WideString           read Freason_description write Freason_description;
    property credentials:        UserCredentialsType  read Fcredentials write Fcredentials;
    property eventType:          eventType            read FeventType write FeventType;
  end;



  // ************************************************************************ //
  // XML       : FatImageType, global, <complexType>
  // Namespace : urn:v7.soap.webservices.clinicaldisplay.imaging.med.va.gov
  // ************************************************************************ //
  FatImageType = class(TRemotable)
  private
    Fimage_id: WideString;
    Fdescription: WideString;
    Fprocedure_date: WideString;
    Fprocedure_: WideString;
    Fdicom_sequence_number: WideString;
    Fdicom_image_number: WideString;
    Fpatient_icn: WideString;
    Fpatient_name: WideString;
    Fsite_number: WideString;
    Fsite_abbr: WideString;
    Fimage_type: Int64;
    Fabs_location: WideString;
    Ffull_location: WideString;
    Fimage_class: WideString;
    Ffull_image_URI: WideString;
    Fabs_image_URI: WideString;
    Fbig_image_URI: WideString;
    FqaMessage: WideString;
    Fcapture_date: WideString;
    Fdocument_date: WideString;
    Fsensitive: Boolean;
    Fstatus: WideString;
    Fview_status: WideString;
    Fimage_has_annotations: Boolean;
    Fimage_annotation_status: Int64;
    Fimage_annotation_status_description: WideString;
    Fassociated_note_resulted: WideString;
    Fimage_package: WideString;
  published
    property image_id:                            WideString  Index (IS_NLBL) read Fimage_id write Fimage_id;
    property description:                         WideString  Index (IS_NLBL) read Fdescription write Fdescription;
    property procedure_date:                      WideString  Index (IS_NLBL) read Fprocedure_date write Fprocedure_date;
    property procedure_:                          WideString  Index (IS_NLBL) read Fprocedure_ write Fprocedure_;
    property dicom_sequence_number:               WideString  Index (IS_NLBL) read Fdicom_sequence_number write Fdicom_sequence_number;
    property dicom_image_number:                  WideString  Index (IS_NLBL) read Fdicom_image_number write Fdicom_image_number;
    property patient_icn:                         WideString  Index (IS_NLBL) read Fpatient_icn write Fpatient_icn;
    property patient_name:                        WideString  Index (IS_NLBL) read Fpatient_name write Fpatient_name;
    property site_number:                         WideString  Index (IS_NLBL) read Fsite_number write Fsite_number;
    property site_abbr:                           WideString  Index (IS_NLBL) read Fsite_abbr write Fsite_abbr;
    property image_type:                          Int64       Index (IS_NLBL) read Fimage_type write Fimage_type;
    property abs_location:                        WideString  Index (IS_NLBL) read Fabs_location write Fabs_location;
    property full_location:                       WideString  Index (IS_NLBL) read Ffull_location write Ffull_location;
    property image_class:                         WideString  Index (IS_NLBL) read Fimage_class write Fimage_class;
    property full_image_URI:                      WideString  Index (IS_NLBL) read Ffull_image_URI write Ffull_image_URI;
    property abs_image_URI:                       WideString  Index (IS_NLBL) read Fabs_image_URI write Fabs_image_URI;
    property big_image_URI:                       WideString  Index (IS_NLBL) read Fbig_image_URI write Fbig_image_URI;
    property qaMessage:                           WideString  Index (IS_NLBL) read FqaMessage write FqaMessage;
    property capture_date:                        WideString  Index (IS_NLBL) read Fcapture_date write Fcapture_date;
    property document_date:                       WideString  Index (IS_NLBL) read Fdocument_date write Fdocument_date;
    property sensitive:                           Boolean     Index (IS_NLBL) read Fsensitive write Fsensitive;
    property status:                              WideString  Index (IS_NLBL) read Fstatus write Fstatus;
    property view_status:                         WideString  Index (IS_NLBL) read Fview_status write Fview_status;
    property image_has_annotations:               Boolean     read Fimage_has_annotations write Fimage_has_annotations;
    property image_annotation_status:             Int64       read Fimage_annotation_status write Fimage_annotation_status;
    property image_annotation_status_description: WideString  read Fimage_annotation_status_description write Fimage_annotation_status_description;
    property associated_note_resulted:            WideString  read Fassociated_note_resulted write Fassociated_note_resulted;
    property image_package:                       WideString  read Fimage_package write Fimage_package;
  end;

  FatImagesType = array of image;               { "urn:v7.soap.webservices.clinicaldisplay.imaging.med.va.gov"[Lit][GblCplx] }


  // ************************************************************************ //
  // XML       : ShallowStudyType, global, <complexType>
  // Namespace : urn:v7.soap.webservices.clinicaldisplay.imaging.med.va.gov
  // ************************************************************************ //
  ShallowStudyType = class(TRemotable)
  private
    Fstudy_id: WideString;
    Fdescription: WideString;
    Fprocedure_date: WideString;
    Fprocedure_: WideString;
    Fpatient_icn: WideString;
    Fpatient_name: WideString;
    Fsite_number: WideString;
    Fsite_abbreviation: WideString;
    Fimage_count: Int64;
    Fnote_title: WideString;
    Fimage_package: WideString;
    Fimage_type: WideString;
    Fspecialty: WideString;
    Fevent: WideString;
    Forigin: WideString;
    Fstudy_package: WideString;
    Fstudy_class: WideString;
    Fstudy_type: WideString;
    Fcapture_date: DateType;
    Fcaptured_by: WideString;
    Ffirst_image: FatImageType;
    FrpcResponseMsg: WideString;
    Fdocument_date: WideString;
    Fsensitive: Boolean;
    Fstatus: WideString;
    Fview_status: WideString;
    Fstudy_images_have_annotations: Boolean;
  public
    destructor Destroy; override;
  published
    property study_id:                      WideString    Index (IS_NLBL) read Fstudy_id write Fstudy_id;
    property description:                   WideString    Index (IS_NLBL) read Fdescription write Fdescription;
    property procedure_date:                WideString    Index (IS_NLBL) read Fprocedure_date write Fprocedure_date;
    property procedure_:                    WideString    Index (IS_NLBL) read Fprocedure_ write Fprocedure_;
    property patient_icn:                   WideString    Index (IS_NLBL) read Fpatient_icn write Fpatient_icn;
    property patient_name:                  WideString    Index (IS_NLBL) read Fpatient_name write Fpatient_name;
    property site_number:                   WideString    Index (IS_NLBL) read Fsite_number write Fsite_number;
    property site_abbreviation:             WideString    Index (IS_NLBL) read Fsite_abbreviation write Fsite_abbreviation;
    property image_count:                   Int64         read Fimage_count write Fimage_count;
    property note_title:                    WideString    Index (IS_NLBL) read Fnote_title write Fnote_title;
    property image_package:                 WideString    Index (IS_NLBL) read Fimage_package write Fimage_package;
    property image_type:                    WideString    Index (IS_NLBL) read Fimage_type write Fimage_type;
    property specialty:                     WideString    Index (IS_NLBL) read Fspecialty write Fspecialty;
    property event:                         WideString    Index (IS_NLBL) read Fevent write Fevent;
    property origin:                        WideString    Index (IS_NLBL) read Forigin write Forigin;
    property study_package:                 WideString    Index (IS_NLBL) read Fstudy_package write Fstudy_package;
    property study_class:                   WideString    Index (IS_NLBL) read Fstudy_class write Fstudy_class;
    property study_type:                    WideString    Index (IS_NLBL) read Fstudy_type write Fstudy_type;
    property capture_date:                  DateType      Index (IS_NLBL) read Fcapture_date write Fcapture_date;
    property captured_by:                   WideString    Index (IS_NLBL) read Fcaptured_by write Fcaptured_by;
    property first_image:                   FatImageType  Index (IS_NLBL) read Ffirst_image write Ffirst_image;
    property rpcResponseMsg:                WideString    Index (IS_NLBL) read FrpcResponseMsg write FrpcResponseMsg;
    property document_date:                 WideString    Index (IS_NLBL) read Fdocument_date write Fdocument_date;
    property sensitive:                     Boolean       Index (IS_NLBL) read Fsensitive write Fsensitive;
    property status:                        WideString    Index (IS_NLBL) read Fstatus write Fstatus;
    property view_status:                   WideString    Index (IS_NLBL) read Fview_status write Fview_status;
    property study_images_have_annotations: Boolean       read Fstudy_images_have_annotations write Fstudy_images_have_annotations;
  end;



  // ************************************************************************ //
  // XML       : ShallowStudiesErrorMessageType, global, <complexType>
  // Namespace : urn:v7.soap.webservices.clinicaldisplay.imaging.med.va.gov
  // ************************************************************************ //
  ShallowStudiesErrorMessageType = class(TRemotable)
  private
    FerrorMessage: WideString;
    FerrorCode: Int64;
    FshallowStudiesError: ShallowStudiesErrorType;
  published
    property errorMessage:        WideString               read FerrorMessage write FerrorMessage;
    property errorCode:           Int64                    read FerrorCode write FerrorCode;
    property shallowStudiesError: ShallowStudiesErrorType  read FshallowStudiesError write FshallowStudiesError;
  end;

  ShallowStudiesStudiesType = array of study;   { "urn:v7.soap.webservices.clinicaldisplay.imaging.med.va.gov"[GblCplx] }


  // ************************************************************************ //
  // XML       : ShallowStudiesType, global, <complexType>
  // Namespace : urn:v7.soap.webservices.clinicaldisplay.imaging.med.va.gov
  // ************************************************************************ //
  ShallowStudiesType = class(TRemotable)
  private
    Fstudies: ShallowStudiesStudiesType;
    Fstudies_Specified: boolean;
    Ferror: ShallowStudiesErrorMessageType;
    Ferror_Specified: boolean;
    Fpartial_result: Boolean;
    Fpartial_result_message: WideString;
    procedure Setstudies(Index: Integer; const AShallowStudiesStudiesType: ShallowStudiesStudiesType);
    function  studies_Specified(Index: Integer): boolean;
    procedure Seterror(Index: Integer; const AShallowStudiesErrorMessageType: ShallowStudiesErrorMessageType);
    function  error_Specified(Index: Integer): boolean;
  public
    destructor Destroy; override;
  published
    property studies:                ShallowStudiesStudiesType       Index (IS_OPTN or IS_NLBL) read Fstudies write Setstudies stored studies_Specified;
    property error:                  ShallowStudiesErrorMessageType  Index (IS_OPTN or IS_NLBL) read Ferror write Seterror stored error_Specified;
    property partial_result:         Boolean                         read Fpartial_result write Fpartial_result;
    property partial_result_message: WideString                      read Fpartial_result_message write Fpartial_result_message;
  end;



  // ************************************************************************ //
  // XML       : ShallowStudiesResponseType, global, <complexType>
  // Namespace : urn:v7.soap.webservices.clinicaldisplay.imaging.med.va.gov
  // Serializtn: [xoLiteralParam]
  // Info      : Wrapper
  // ************************************************************************ //
  ShallowStudiesResponseType = class(TRemotable)
  private
    Fresult: ShallowStudiesType;
  public
    constructor Create; override;
    destructor Destroy; override;
  published
    property result: ShallowStudiesType  read Fresult write Fresult;
  end;



  // ************************************************************************ //
  // XML       : ImageAccessEventType, global, <complexType>
  // Namespace : urn:v7.soap.webservices.clinicaldisplay.imaging.med.va.gov
  // Serializtn: [xoLiteralParam]
  // Info      : Wrapper
  // ************************************************************************ //
  ImageAccessEventType = class(TRemotable)
  private
    Fresult: Boolean;
  public
    constructor Create; override;
  published
    property result: Boolean  read Fresult write Fresult;
  end;



  // ************************************************************************ //
  // XML       : ImageInformationType, global, <complexType>
  // Namespace : urn:v7.soap.webservices.clinicaldisplay.imaging.med.va.gov
  // Serializtn: [xoLiteralParam]
  // Info      : Wrapper
  // ************************************************************************ //
  ImageInformationType = class(TRemotable)
  private
    FimageInfo: WideString;
  public
    constructor Create; override;
  published
    property imageInfo: WideString  read FimageInfo write FimageInfo;
  end;



  // ************************************************************************ //
  // XML       : ImageSystemGlobalNodeType, global, <complexType>
  // Namespace : urn:v7.soap.webservices.clinicaldisplay.imaging.med.va.gov
  // Serializtn: [xoLiteralParam]
  // Info      : Wrapper
  // ************************************************************************ //
  ImageSystemGlobalNodeType = class(TRemotable)
  private
    FimageInfo: WideString;
  public
    constructor Create; override;
  published
    property imageInfo: WideString  read FimageInfo write FimageInfo;
  end;



  // ************************************************************************ //
  // XML       : ImageDevFieldsType, global, <complexType>
  // Namespace : urn:v7.soap.webservices.clinicaldisplay.imaging.med.va.gov
  // Serializtn: [xoLiteralParam]
  // Info      : Wrapper
  // ************************************************************************ //
  ImageDevFieldsType = class(TRemotable)
  private
    FimageInfo: WideString;
  public
    constructor Create; override;
  published
    property imageInfo: WideString  read FimageInfo write FimageInfo;
  end;



  // ************************************************************************ //
  // XML       : StudyReportType, global, <complexType>
  // Namespace : urn:v7.soap.webservices.clinicaldisplay.imaging.med.va.gov
  // Serializtn: [xoLiteralParam]
  // Info      : Wrapper
  // ************************************************************************ //
  StudyReportType = class(TRemotable)
  private
    FstudyReport: WideString;
  public
    constructor Create; override;
  published
    property studyReport: WideString  read FstudyReport write FstudyReport;
  end;



  // ************************************************************************ //
  // XML       : RemoteMethodParameterType, global, <complexType>
  // Namespace : urn:v7.soap.webservices.clinicaldisplay.imaging.med.va.gov
  // ************************************************************************ //
  RemoteMethodParameterType = class(TRemotable)
  private
    FparameterIndex: Int64;
    FparameterType: RemoteMethodParameterTypeType;
    FparameterValue: RemoteMethodParameterValueType;
  public
    destructor Destroy; override;
  published
    property parameterIndex: Int64                           read FparameterIndex write FparameterIndex;
    property parameterType:  RemoteMethodParameterTypeType   read FparameterType write FparameterType;
    property parameterValue: RemoteMethodParameterValueType  read FparameterValue write FparameterValue;
  end;

  RemoteMethodInputParameterType = array of remoteMethodParameter;   { "urn:v7.soap.webservices.clinicaldisplay.imaging.med.va.gov"[GblCplx] }


  // ************************************************************************ //
  // XML       : RemoteMethodResponseType, global, <complexType>
  // Namespace : urn:v7.soap.webservices.clinicaldisplay.imaging.med.va.gov
  // Serializtn: [xoLiteralParam]
  // Info      : Wrapper
  // ************************************************************************ //
  RemoteMethodResponseType = class(TRemotable)
  private
    Fresponse: WideString;
  public
    constructor Create; override;
  published
    property response: WideString  read Fresponse write Fresponse;
  end;



  // ************************************************************************ //
  // XML       : PingServerType, global, <complexType>
  // Namespace : urn:v7.soap.webservices.clinicaldisplay.imaging.med.va.gov
  // Serializtn: [xoLiteralParam]
  // Info      : Wrapper
  // ************************************************************************ //
  PingServerType = class(TRemotable)
  private
    FpingResponse: pingResponse;
  public
    constructor Create; override;
  published
    property pingResponse: pingResponse  read FpingResponse write FpingResponse;
  end;



  // ************************************************************************ //
  // XML       : PrefetchResponseType, global, <complexType>
  // Namespace : urn:v7.soap.webservices.clinicaldisplay.imaging.med.va.gov
  // Serializtn: [xoLiteralParam]
  // Info      : Wrapper
  // ************************************************************************ //
  PrefetchResponseType = class(TRemotable)
  private
    FprefetchResponse: prefetchResponse;
  public
    constructor Create; override;
  published
    property prefetchResponse: prefetchResponse  read FprefetchResponse write FprefetchResponse;
  end;



  // ************************************************************************ //
  // XML       : PatientSensitiveCheckResponseType, global, <complexType>
  // Namespace : urn:v7.soap.webservices.clinicaldisplay.imaging.med.va.gov
  // ************************************************************************ //
  PatientSensitiveCheckResponseType = class(TRemotable)
  private
    FpatientSensitivityLevel: PatientSensitivityLevelType;
    FwarningMessage: WideString;
  published
    property patientSensitivityLevel: PatientSensitivityLevelType  read FpatientSensitivityLevel write FpatientSensitivityLevel;
    property warningMessage:          WideString                   read FwarningMessage write FwarningMessage;
  end;



  // ************************************************************************ //
  // XML       : PatientSensitiveCheckWrapperResponseType, global, <complexType>
  // Namespace : urn:v7.soap.webservices.clinicaldisplay.imaging.med.va.gov
  // Serializtn: [xoLiteralParam]
  // Info      : Wrapper
  // ************************************************************************ //
  PatientSensitiveCheckWrapperResponseType = class(TRemotable)
  private
    Fresponse: PatientSensitiveCheckResponseType;
  public
    constructor Create; override;
    destructor Destroy; override;
  published
    property response: PatientSensitiveCheckResponseType  read Fresponse write Fresponse;
  end;

  getImageAnnotationsResponseType = array of response;   { "urn:v7.soap.webservices.clinicaldisplay.imaging.med.va.gov"[Lit][GblCplx] }


  // ************************************************************************ //
  // XML       : getAnnotationDetailsResponseType, global, <complexType>
  // Namespace : urn:v7.soap.webservices.clinicaldisplay.imaging.med.va.gov
  // Serializtn: [xoLiteralParam]
  // Info      : Wrapper
  // ************************************************************************ //
  getAnnotationDetailsResponseType = class(TRemotable)
  private
    Fresponse: AnnotationDetailsType;
  public
    constructor Create; override;
    destructor Destroy; override;
  published
    property response: AnnotationDetailsType  read Fresponse write Fresponse;
  end;



  // ************************************************************************ //
  // XML       : postAnnotationDetailsResponseType, global, <complexType>
  // Namespace : urn:v7.soap.webservices.clinicaldisplay.imaging.med.va.gov
  // Serializtn: [xoLiteralParam]
  // Info      : Wrapper
  // ************************************************************************ //
  postAnnotationDetailsResponseType = class(TRemotable)
  private
    Fresponse: AnnotationType;
  public
    constructor Create; override;
    destructor Destroy; override;
  published
    property response: AnnotationType  read Fresponse write Fresponse;
  end;



  // ************************************************************************ //
  // XML       : getUserDetailsResponseType, global, <complexType>
  // Namespace : urn:v7.soap.webservices.clinicaldisplay.imaging.med.va.gov
  // Serializtn: [xoLiteralParam]
  // Info      : Wrapper
  // ************************************************************************ //
  getUserDetailsResponseType = class(TRemotable)
  private
    Fresponse: UserType;
  public
    constructor Create; override;
    destructor Destroy; override;
  published
    property response: UserType  read Fresponse write Fresponse;
  end;



  // ************************************************************************ //
  // XML       : isAnnotationsSupportedResponseType, global, <complexType>
  // Namespace : urn:v7.soap.webservices.clinicaldisplay.imaging.med.va.gov
  // Serializtn: [xoLiteralParam]
  // Info      : Wrapper
  // ************************************************************************ //
  isAnnotationsSupportedResponseType = class(TRemotable)
  private
    Fresponse: Boolean;
  public
    constructor Create; override;
  published
    property response: Boolean  read Fresponse write Fresponse;
  end;

  TransactionIdentifierType =  type WideString;      { "urn:v7.soap.webservices.clinicaldisplay.imaging.med.va.gov"[GblSmpl] }
  RemoteMethodNameType =  type WideString;      { "urn:v7.soap.webservices.clinicaldisplay.imaging.med.va.gov"[GblSmpl] }


  // ************************************************************************ //
  // XML       : getPatientSensitivityLevel, global, <element>
  // Namespace : urn:v7.soap.webservices.clinicaldisplay.imaging.med.va.gov
  // Serializtn: [xoLiteralParam]
  // Info      : Wrapper
  // ************************************************************************ //
  getPatientSensitivityLevel = class(TRemotable)
  private
    Ftransaction_id: TransactionIdentifierType;
    Fsite_id: WideString;
    Fpatient_id: WideString;
    Fcredentials: UserCredentialsType;
  public
    constructor Create; override;
    destructor Destroy; override;
  published
    property transaction_id: TransactionIdentifierType  read Ftransaction_id write Ftransaction_id;
    property site_id:        WideString                 read Fsite_id write Fsite_id;
    property patient_id:     WideString                 read Fpatient_id write Fpatient_id;
    property credentials:    UserCredentialsType        read Fcredentials write Fcredentials;
  end;



  // ************************************************************************ //
  // XML       : getPatientSensitivityLevelResponse, global, <element>
  // Namespace : urn:v7.soap.webservices.clinicaldisplay.imaging.med.va.gov
  // Info      : Wrapper
  // ************************************************************************ //
  getPatientSensitivityLevelResponse = class(PatientSensitiveCheckWrapperResponseType)
  private
  published
  end;



  // ************************************************************************ //
  // XML       : getPatientShallowStudyList, global, <element>
  // Namespace : urn:v7.soap.webservices.clinicaldisplay.imaging.med.va.gov
  // Serializtn: [xoLiteralParam]
  // Info      : Wrapper
  // ************************************************************************ //
  getPatientShallowStudyList = class(TRemotable)
  private
    Ftransaction_id: TransactionIdentifierType;
    Fsite_id: WideString;
    Fpatient_id: WideString;
    Ffilter: FilterType;
    Fcredentials: UserCredentialsType;
    FauthorizedSensitivityLevel: Int64;
    FincludeArtifacts: Boolean;
  public
    constructor Create; override;
    destructor Destroy; override;
  published
    property transaction_id:             TransactionIdentifierType  read Ftransaction_id write Ftransaction_id;
    property site_id:                    WideString                 read Fsite_id write Fsite_id;
    property patient_id:                 WideString                 read Fpatient_id write Fpatient_id;
    property filter:                     FilterType                 read Ffilter write Ffilter;
    property credentials:                UserCredentialsType        read Fcredentials write Fcredentials;
    property authorizedSensitivityLevel: Int64                      read FauthorizedSensitivityLevel write FauthorizedSensitivityLevel;
    property includeArtifacts:           Boolean                    read FincludeArtifacts write FincludeArtifacts;
  end;



  // ************************************************************************ //
  // XML       : getPatientShallowStudyListResponse, global, <element>
  // Namespace : urn:v7.soap.webservices.clinicaldisplay.imaging.med.va.gov
  // Info      : Wrapper
  // ************************************************************************ //
  getPatientShallowStudyListResponse = class(ShallowStudiesResponseType)
  private
  published
  end;



  // ************************************************************************ //
  // XML       : getStudyImageList, global, <element>
  // Namespace : urn:v7.soap.webservices.clinicaldisplay.imaging.med.va.gov
  // Serializtn: [xoLiteralParam]
  // Info      : Wrapper
  // ************************************************************************ //
  getStudyImageList = class(TRemotable)
  private
    Ftransaction_id: TransactionIdentifierType;
    Fstudy_id: WideString;
    Fcredentials: UserCredentialsType;
    Finclude_deleted_images: Boolean;
  public
    constructor Create; override;
    destructor Destroy; override;
  published
    property transaction_id:         TransactionIdentifierType  read Ftransaction_id write Ftransaction_id;
    property study_id:               WideString                 read Fstudy_id write Fstudy_id;
    property credentials:            UserCredentialsType        read Fcredentials write Fcredentials;
    property include_deleted_images: Boolean                    read Finclude_deleted_images write Finclude_deleted_images;
  end;

  getStudyImageListResponse =  type FatImagesType;      { "urn:v7.soap.webservices.clinicaldisplay.imaging.med.va.gov"[Lit][GblElm] }


  // ************************************************************************ //
  // XML       : postImageAccessEvent, global, <element>
  // Namespace : urn:v7.soap.webservices.clinicaldisplay.imaging.med.va.gov
  // Serializtn: [xoLiteralParam]
  // Info      : Wrapper
  // ************************************************************************ //
  postImageAccessEvent = class(TRemotable)
  private
    Ftransaction_id: TransactionIdentifierType;
    Flog_event: ImageAccessLogEventType;
  public
    constructor Create; override;
    destructor Destroy; override;
  published
    property transaction_id: TransactionIdentifierType  read Ftransaction_id write Ftransaction_id;
    property log_event:      ImageAccessLogEventType    read Flog_event write Flog_event;
  end;



  // ************************************************************************ //
  // XML       : postImageAccessEventResponse, global, <element>
  // Namespace : urn:v7.soap.webservices.clinicaldisplay.imaging.med.va.gov
  // Info      : Wrapper
  // ************************************************************************ //
  postImageAccessEventResponse = class(ImageAccessEventType)
  private
  published
  end;



  // ************************************************************************ //
  // XML       : pingServer, global, <element>
  // Namespace : urn:v7.soap.webservices.clinicaldisplay.imaging.med.va.gov
  // Serializtn: [xoLiteralParam]
  // Info      : Wrapper
  // ************************************************************************ //
  pingServer = class(TRemotable)
  private
    Ftransaction_id: TransactionIdentifierType;
    FclientWorkstation: WideString;
    FrequestSiteNumber: WideString;
    Fcredentials: UserCredentialsType;
  public
    constructor Create; override;
    destructor Destroy; override;
  published
    property transaction_id:    TransactionIdentifierType  read Ftransaction_id write Ftransaction_id;
    property clientWorkstation: WideString                 read FclientWorkstation write FclientWorkstation;
    property requestSiteNumber: WideString                 read FrequestSiteNumber write FrequestSiteNumber;
    property credentials:       UserCredentialsType        read Fcredentials write Fcredentials;
  end;



  // ************************************************************************ //
  // XML       : postPingServerResponse, global, <element>
  // Namespace : urn:v7.soap.webservices.clinicaldisplay.imaging.med.va.gov
  // Info      : Wrapper
  // ************************************************************************ //
  postPingServerResponse = class(PingServerType)
  private
  published
  end;



  // ************************************************************************ //
  // XML       : prefetchStudyList, global, <element>
  // Namespace : urn:v7.soap.webservices.clinicaldisplay.imaging.med.va.gov
  // Serializtn: [xoLiteralParam]
  // Info      : Wrapper
  // ************************************************************************ //
  prefetchStudyList = class(TRemotable)
  private
    Ftransaction_id: TransactionIdentifierType;
    Fsite_id: WideString;
    Fpatient_id: WideString;
    Ffilter: FilterType;
    Fcredentials: UserCredentialsType;
  public
    constructor Create; override;
    destructor Destroy; override;
  published
    property transaction_id: TransactionIdentifierType  read Ftransaction_id write Ftransaction_id;
    property site_id:        WideString                 read Fsite_id write Fsite_id;
    property patient_id:     WideString                 read Fpatient_id write Fpatient_id;
    property filter:         FilterType                 read Ffilter write Ffilter;
    property credentials:    UserCredentialsType        read Fcredentials write Fcredentials;
  end;



  // ************************************************************************ //
  // XML       : PrefetchStudyListResponse, global, <element>
  // Namespace : urn:v7.soap.webservices.clinicaldisplay.imaging.med.va.gov
  // Info      : Wrapper
  // ************************************************************************ //
  PrefetchStudyListResponse = class(PrefetchResponseType)
  private
  published
  end;



  // ************************************************************************ //
  // XML       : getImageInformation, global, <element>
  // Namespace : urn:v7.soap.webservices.clinicaldisplay.imaging.med.va.gov
  // Serializtn: [xoLiteralParam]
  // Info      : Wrapper
  // ************************************************************************ //
  getImageInformation = class(TRemotable)
  private
    Fid: WideString;
    Ftransaction_id: TransactionIdentifierType;
    Fcredentials: UserCredentialsType;
    Finclude_deleted_images: Boolean;
  public
    constructor Create; override;
    destructor Destroy; override;
  published
    property id:                     WideString                 read Fid write Fid;
    property transaction_id:         TransactionIdentifierType  read Ftransaction_id write Ftransaction_id;
    property credentials:            UserCredentialsType        read Fcredentials write Fcredentials;
    property include_deleted_images: Boolean                    Index (IS_NLBL) read Finclude_deleted_images write Finclude_deleted_images;
  end;



  // ************************************************************************ //
  // XML       : getImageInformationResponse, global, <element>
  // Namespace : urn:v7.soap.webservices.clinicaldisplay.imaging.med.va.gov
  // Info      : Wrapper
  // ************************************************************************ //
  getImageInformationResponse = class(ImageInformationType)
  private
  published
  end;



  // ************************************************************************ //
  // XML       : getImageSystemGlobalNode, global, <element>
  // Namespace : urn:v7.soap.webservices.clinicaldisplay.imaging.med.va.gov
  // Serializtn: [xoLiteralParam]
  // Info      : Wrapper
  // ************************************************************************ //
  getImageSystemGlobalNode = class(TRemotable)
  private
    Fid: WideString;
    Ftransaction_id: TransactionIdentifierType;
    Fcredentials: UserCredentialsType;
  public
    constructor Create; override;
    destructor Destroy; override;
  published
    property id:             WideString                 read Fid write Fid;
    property transaction_id: TransactionIdentifierType  read Ftransaction_id write Ftransaction_id;
    property credentials:    UserCredentialsType        read Fcredentials write Fcredentials;
  end;



  // ************************************************************************ //
  // XML       : getImageSystemGlobalNodeResponse, global, <element>
  // Namespace : urn:v7.soap.webservices.clinicaldisplay.imaging.med.va.gov
  // Info      : Wrapper
  // ************************************************************************ //
  getImageSystemGlobalNodeResponse = class(ImageSystemGlobalNodeType)
  private
  published
  end;



  // ************************************************************************ //
  // XML       : getImageDevFields, global, <element>
  // Namespace : urn:v7.soap.webservices.clinicaldisplay.imaging.med.va.gov
  // Serializtn: [xoLiteralParam]
  // Info      : Wrapper
  // ************************************************************************ //
  getImageDevFields = class(TRemotable)
  private
    Fid: WideString;
    Fflags: WideString;
    Ftransaction_id: TransactionIdentifierType;
    Fcredentials: UserCredentialsType;
  public
    constructor Create; override;
    destructor Destroy; override;
  published
    property id:             WideString                 read Fid write Fid;
    property flags:          WideString                 read Fflags write Fflags;
    property transaction_id: TransactionIdentifierType  read Ftransaction_id write Ftransaction_id;
    property credentials:    UserCredentialsType        read Fcredentials write Fcredentials;
  end;



  // ************************************************************************ //
  // XML       : getImageDevFieldsResponse, global, <element>
  // Namespace : urn:v7.soap.webservices.clinicaldisplay.imaging.med.va.gov
  // Info      : Wrapper
  // ************************************************************************ //
  getImageDevFieldsResponse = class(ImageDevFieldsType)
  private
  published
  end;



  // ************************************************************************ //
  // XML       : getStudyReport, global, <element>
  // Namespace : urn:v7.soap.webservices.clinicaldisplay.imaging.med.va.gov
  // Serializtn: [xoLiteralParam]
  // Info      : Wrapper
  // ************************************************************************ //
  getStudyReport = class(TRemotable)
  private
    Ftransaction_id: TransactionIdentifierType;
    Fcredentials: UserCredentialsType;
    Fstudy_id: WideString;
  public
    constructor Create; override;
    destructor Destroy; override;
  published
    property transaction_id: TransactionIdentifierType  read Ftransaction_id write Ftransaction_id;
    property credentials:    UserCredentialsType        read Fcredentials write Fcredentials;
    property study_id:       WideString                 read Fstudy_id write Fstudy_id;
  end;



  // ************************************************************************ //
  // XML       : getStudyReportResponse, global, <element>
  // Namespace : urn:v7.soap.webservices.clinicaldisplay.imaging.med.va.gov
  // Info      : Wrapper
  // ************************************************************************ //
  getStudyReportResponse = class(StudyReportType)
  private
  published
  end;



  // ************************************************************************ //
  // XML       : remoteMethodPassthrough, global, <element>
  // Namespace : urn:v7.soap.webservices.clinicaldisplay.imaging.med.va.gov
  // Serializtn: [xoLiteralParam]
  // Info      : Wrapper
  // ************************************************************************ //
  remoteMethodPassthrough = class(TRemotable)
  private
    Ftransaction_id: TransactionIdentifierType;
    Fcredentials: UserCredentialsType;
    Fsite_id: WideString;
    FmethodName: RemoteMethodNameType;
    FinputParameters: RemoteMethodInputParameterType;
  public
    constructor Create; override;
    destructor Destroy; override;
  published
    property transaction_id:  TransactionIdentifierType       read Ftransaction_id write Ftransaction_id;
    property credentials:     UserCredentialsType             read Fcredentials write Fcredentials;
    property site_id:         WideString                      read Fsite_id write Fsite_id;
    property methodName:      RemoteMethodNameType            read FmethodName write FmethodName;
    property inputParameters: RemoteMethodInputParameterType  read FinputParameters write FinputParameters;
  end;



  // ************************************************************************ //
  // XML       : remoteMethodPassthroughResponse, global, <element>
  // Namespace : urn:v7.soap.webservices.clinicaldisplay.imaging.med.va.gov
  // Info      : Wrapper
  // ************************************************************************ //
  remoteMethodPassthroughResponse = class(RemoteMethodResponseType)
  private
  published
  end;



  // ************************************************************************ //
  // XML       : getImageAnnotations, global, <element>
  // Namespace : urn:v7.soap.webservices.clinicaldisplay.imaging.med.va.gov
  // Serializtn: [xoLiteralParam]
  // Info      : Wrapper
  // ************************************************************************ //
  getImageAnnotations = class(TRemotable)
  private
    Ftransaction_id: TransactionIdentifierType;
    Fcredentials: UserCredentialsType;
    Fimage_id: WideString;
  public
    constructor Create; override;
    destructor Destroy; override;
  published
    property transaction_id: TransactionIdentifierType  read Ftransaction_id write Ftransaction_id;
    property credentials:    UserCredentialsType        read Fcredentials write Fcredentials;
    property image_id:       WideString                 read Fimage_id write Fimage_id;
  end;

  getImageAnnotationsResponse =  type getImageAnnotationsResponseType;      { "urn:v7.soap.webservices.clinicaldisplay.imaging.med.va.gov"[Lit][GblElm] }


  // ************************************************************************ //
  // XML       : getAnnotationDetails, global, <element>
  // Namespace : urn:v7.soap.webservices.clinicaldisplay.imaging.med.va.gov
  // Serializtn: [xoLiteralParam]
  // Info      : Wrapper
  // ************************************************************************ //
  getAnnotationDetails = class(TRemotable)
  private
    Ftransaction_id: TransactionIdentifierType;
    Fcredentials: UserCredentialsType;
    Fimage_id: WideString;
    Fannotation_id: WideString;
  public
    constructor Create; override;
    destructor Destroy; override;
  published
    property transaction_id: TransactionIdentifierType  read Ftransaction_id write Ftransaction_id;
    property credentials:    UserCredentialsType        read Fcredentials write Fcredentials;
    property image_id:       WideString                 read Fimage_id write Fimage_id;
    property annotation_id:  WideString                 read Fannotation_id write Fannotation_id;
  end;



  // ************************************************************************ //
  // XML       : getAnnotationDetailsResponse, global, <element>
  // Namespace : urn:v7.soap.webservices.clinicaldisplay.imaging.med.va.gov
  // Info      : Wrapper
  // ************************************************************************ //
  getAnnotationDetailsResponse = class(getAnnotationDetailsResponseType)
  private
  published
  end;



  // ************************************************************************ //
  // XML       : postAnnotationDetails, global, <element>
  // Namespace : urn:v7.soap.webservices.clinicaldisplay.imaging.med.va.gov
  // Serializtn: [xoLiteralParam]
  // Info      : Wrapper
  // ************************************************************************ //
  postAnnotationDetails = class(TRemotable)
  private
    Ftransaction_id: TransactionIdentifierType;
    Fcredentials: UserCredentialsType;
    Fimage_id: WideString;
    Fdetails: WideString;
    Fversion: WideString;
    Fsource: WideString;
  public
    constructor Create; override;
    destructor Destroy; override;
  published
    property transaction_id: TransactionIdentifierType  read Ftransaction_id write Ftransaction_id;
    property credentials:    UserCredentialsType        read Fcredentials write Fcredentials;
    property image_id:       WideString                 read Fimage_id write Fimage_id;
    property details:        WideString                 read Fdetails write Fdetails;
    property version:        WideString                 read Fversion write Fversion;
    property source:         WideString                 read Fsource write Fsource;
  end;



  // ************************************************************************ //
  // XML       : postAnnotationDetailsResponse, global, <element>
  // Namespace : urn:v7.soap.webservices.clinicaldisplay.imaging.med.va.gov
  // Info      : Wrapper
  // ************************************************************************ //
  postAnnotationDetailsResponse = class(postAnnotationDetailsResponseType)
  private
  published
  end;



  // ************************************************************************ //
  // XML       : getUserDetails, global, <element>
  // Namespace : urn:v7.soap.webservices.clinicaldisplay.imaging.med.va.gov
  // Serializtn: [xoLiteralParam]
  // Info      : Wrapper
  // ************************************************************************ //
  getUserDetails = class(TRemotable)
  private
    Ftransaction_id: TransactionIdentifierType;
    Fcredentials: UserCredentialsType;
    Fsite_id: WideString;
  public
    constructor Create; override;
    destructor Destroy; override;
  published
    property transaction_id: TransactionIdentifierType  read Ftransaction_id write Ftransaction_id;
    property credentials:    UserCredentialsType        read Fcredentials write Fcredentials;
    property site_id:        WideString                 read Fsite_id write Fsite_id;
  end;



  // ************************************************************************ //
  // XML       : getUserDetailsResponse, global, <element>
  // Namespace : urn:v7.soap.webservices.clinicaldisplay.imaging.med.va.gov
  // Info      : Wrapper
  // ************************************************************************ //
  getUserDetailsResponse = class(getUserDetailsResponseType)
  private
  published
  end;



  // ************************************************************************ //
  // XML       : isAnnotationsSupported, global, <element>
  // Namespace : urn:v7.soap.webservices.clinicaldisplay.imaging.med.va.gov
  // Serializtn: [xoLiteralParam]
  // Info      : Wrapper
  // ************************************************************************ //
  isAnnotationsSupported = class(TRemotable)
  private
    Ftransaction_id: TransactionIdentifierType;
    Fcredentials: UserCredentialsType;
    Fsite_id: WideString;
  public
    constructor Create; override;
    destructor Destroy; override;
  published
    property transaction_id: TransactionIdentifierType  read Ftransaction_id write Ftransaction_id;
    property credentials:    UserCredentialsType        read Fcredentials write Fcredentials;
    property site_id:        WideString                 read Fsite_id write Fsite_id;
  end;



  // ************************************************************************ //
  // XML       : isAnnotationsSupportedResponse, global, <element>
  // Namespace : urn:v7.soap.webservices.clinicaldisplay.imaging.med.va.gov
  // Info      : Wrapper
  // ************************************************************************ //
  isAnnotationsSupportedResponse = class(isAnnotationsSupportedResponseType)
  private
  published
  end;



  // ************************************************************************ //
  // XML       : image, alias
  // Namespace : urn:v7.soap.webservices.clinicaldisplay.imaging.med.va.gov
  // ************************************************************************ //
  image = class(FatImageType)
  private
  published
  end;



  // ************************************************************************ //
  // XML       : study, alias
  // Namespace : urn:v7.soap.webservices.clinicaldisplay.imaging.med.va.gov
  // ************************************************************************ //
  study = class(ShallowStudyType)
  private
  published
  end;

  multipleValue   =  type WideString;      { "urn:v7.soap.webservices.clinicaldisplay.imaging.med.va.gov"[Alias] }
  RemoteMethodParameterMultipleType = array of multipleValue;   { "urn:v7.soap.webservices.clinicaldisplay.imaging.med.va.gov"[GblCplx] }


  // ************************************************************************ //
  // XML       : RemoteMethodParameterValueType, global, <complexType>
  // Namespace : urn:v7.soap.webservices.clinicaldisplay.imaging.med.va.gov
  // ************************************************************************ //
  RemoteMethodParameterValueType = class(TRemotable)
  private
    Fvalue: WideString;
    FmultipleValue: RemoteMethodParameterMultipleType;
    FmultipleValue_Specified: boolean;
    procedure SetmultipleValue(Index: Integer; const ARemoteMethodParameterMultipleType: RemoteMethodParameterMultipleType);
    function  multipleValue_Specified(Index: Integer): boolean;
  published
    property value:         WideString                         read Fvalue write Fvalue;
    property multipleValue: RemoteMethodParameterMultipleType  Index (IS_OPTN or IS_NLBL) read FmultipleValue write SetmultipleValue stored multipleValue_Specified;
  end;



  // ************************************************************************ //
  // XML       : remoteMethodParameter, alias
  // Namespace : urn:v7.soap.webservices.clinicaldisplay.imaging.med.va.gov
  // ************************************************************************ //
  remoteMethodParameter = class(RemoteMethodParameterType)
  private
  published
  end;



  // ************************************************************************ //
  // XML       : response, alias
  // Namespace : urn:v7.soap.webservices.clinicaldisplay.imaging.med.va.gov
  // ************************************************************************ //
  response = class(AnnotationType)
  private
  published
  end;

  Array_Of_string = array of WideString;        { "http://www.w3.org/2001/XMLSchema"[GblUbnd] }


  // ************************************************************************ //
  // XML       : UserType, global, <complexType>
  // Namespace : urn:v7.soap.webservices.clinicaldisplay.imaging.med.va.gov
  // ************************************************************************ //
  UserType = class(TRemotable)
  private
    Fuser_id: WideString;
    Fkey: Array_Of_string;
    Fkey_Specified: boolean;
    Fcan_create_annotations: Boolean;
    procedure Setkey(Index: Integer; const AArray_Of_string: Array_Of_string);
    function  key_Specified(Index: Integer): boolean;
  published
    property user_id:                WideString       read Fuser_id write Fuser_id;
    property key:                    Array_Of_string  Index (IS_OPTN or IS_UNBD) read Fkey write Setkey stored key_Specified;
    property can_create_annotations: Boolean          read Fcan_create_annotations write Fcan_create_annotations;
  end;


  // ************************************************************************ //
  // Namespace : urn:v7.soap.webservices.clinicaldisplay.imaging.med.va.gov
  // soapAction: |getPatientShallowStudyList|getStudyImageList|postImageAccessEvent|pingServer|prefetchStudyList|getImageInformation|getImageSystemGlobalNode|getImageDevFields|getPatientSensitivityLevel|getStudyReport|remoteMethodPassthrough|getImageAnnotations|getAnnotationDetails|postAnnotationDetails|getUserDetails|isAnnotationsSupported
  // transport : http://schemas.xmlsoap.org/soap/http
  // style     : document
  // binding   : ImageMetadataClinicalDisplaySoapBinding
  // service   : ImageMetadataClinicalDisplayService
  // port      : ImageMetadataClinicalDisplay.V7
  // URL       : http://localhost:8080/ImagingExchangeWebApp/webservices/ImageMetadataClinicalDisplay
  // ************************************************************************ //
  ImageClinicalDisplayMetadata = interface(IInvokable)
  ['{CD033CEA-B36D-0001-0A97-DBAF8B1CAF64}']
    function  getPatientShallowStudyList(const parameters: getPatientShallowStudyList): getPatientShallowStudyListResponse; stdcall;
    function  getStudyImageList(const parameters: getStudyImageList): getStudyImageListResponse; stdcall;
    function  postImageAccessEvent(const parameters: postImageAccessEvent): postImageAccessEventResponse; stdcall;

    // Cannot unwrap: 
    //     - Input element wrapper name does not match operation's name
    function  pingServerEvent(const parameters: pingServer): postPingServerResponse; stdcall;
    function  prefetchStudyList(const parameters: prefetchStudyList): PrefetchStudyListResponse; stdcall;
    function  getImageInformation(const parameters: getImageInformation): getImageInformationResponse; stdcall;
    function  getImageSystemGlobalNode(const parameters: getImageSystemGlobalNode): getImageSystemGlobalNodeResponse; stdcall;
    function  getImageDevFields(const parameters: getImageDevFields): getImageDevFieldsResponse; stdcall;
    function  getPatientSensitivityLevel(const parameters: getPatientSensitivityLevel): getPatientSensitivityLevelResponse; stdcall;
    function  getStudyReport(const parameters: getStudyReport): getStudyReportResponse; stdcall;
    function  remoteMethodPassthrough(const parameters: remoteMethodPassthrough): remoteMethodPassthroughResponse; stdcall;
    function  getImageAnnotations(const parameters: getImageAnnotations): getImageAnnotationsResponse; stdcall;
    function  getAnnotationDetails(const parameters: getAnnotationDetails): getAnnotationDetailsResponse; stdcall;
    function  postAnnotationDetails(const parameters: postAnnotationDetails): postAnnotationDetailsResponse; stdcall;
    function  getUserDetails(const parameters: getUserDetails): getUserDetailsResponse; stdcall;
    function  isAnnotationsSupported(const parameters: isAnnotationsSupported): isAnnotationsSupportedResponse; stdcall;
  end;

function GetImageClinicalDisplayMetadata(UseWSDL: Boolean=System.False; Addr: string=''; HTTPRIO: THTTPRIO = nil): ImageClinicalDisplayMetadata;


implementation
  uses SysUtils;

function GetImageClinicalDisplayMetadata(UseWSDL: Boolean; Addr: string; HTTPRIO: THTTPRIO): ImageClinicalDisplayMetadata;
const
  defWSDL = 'C:\DevD2007\P122\Clin\WSDL\imagingClinicalDisplaySOAP_v7.wsdl';
  defURL  = 'http://localhost:8080/ImagingExchangeWebApp/webservices/ImageMetadataClinicalDisplay';
  defSvc  = 'ImageMetadataClinicalDisplayService';
  defPrt  = 'ImageMetadataClinicalDisplay.V7';
var
  RIO: THTTPRIO;
begin
  Result := nil;
  if (Addr = '') then
  begin
    if UseWSDL then
      Addr := defWSDL
    else
      Addr := defURL;
  end;
  if HTTPRIO = nil then
    RIO := THTTPRIO.Create(nil)
  else
    RIO := HTTPRIO;
  try
    Result := (RIO as ImageClinicalDisplayMetadata);
    if UseWSDL then
    begin
      RIO.WSDLLocation := Addr;
      RIO.Service := defSvc;
      RIO.Port := defPrt;
    end else
      RIO.URL := Addr;
  finally
    if (Result = nil) and (HTTPRIO = nil) then
      RIO.Free;
  end;
end;


destructor AnnotationType.Destroy;
begin
  FreeAndNil(Fuser);
  inherited Destroy;
end;

destructor AnnotationDetailsType.Destroy;
begin
  FreeAndNil(FAnnotation);
  inherited Destroy;
end;

destructor ImageAccessLogEventType.Destroy;
begin
  FreeAndNil(Fcredentials);
  inherited Destroy;
end;

destructor ShallowStudyType.Destroy;
begin
  FreeAndNil(Ffirst_image);
  inherited Destroy;
end;

destructor ShallowStudiesType.Destroy;
var
  I: Integer;
begin
  for I := 0 to Length(Fstudies)-1 do
    FreeAndNil(Fstudies[I]);
  SetLength(Fstudies, 0);
  FreeAndNil(Ferror);
  inherited Destroy;
end;

procedure ShallowStudiesType.Setstudies(Index: Integer; const AShallowStudiesStudiesType: ShallowStudiesStudiesType);
begin
  Fstudies := AShallowStudiesStudiesType;
  Fstudies_Specified := True;
end;

function ShallowStudiesType.studies_Specified(Index: Integer): boolean;
begin
  Result := Fstudies_Specified;
end;

procedure ShallowStudiesType.Seterror(Index: Integer; const AShallowStudiesErrorMessageType: ShallowStudiesErrorMessageType);
begin
  Ferror := AShallowStudiesErrorMessageType;
  Ferror_Specified := True;
end;

function ShallowStudiesType.error_Specified(Index: Integer): boolean;
begin
  Result := Ferror_Specified;
end;

constructor ShallowStudiesResponseType.Create;
begin
  inherited Create;
  FSerializationOptions := [xoLiteralParam];
end;

destructor ShallowStudiesResponseType.Destroy;
begin
  FreeAndNil(Fresult);
  inherited Destroy;
end;

constructor ImageAccessEventType.Create;
begin
  inherited Create;
  FSerializationOptions := [xoLiteralParam];
end;

constructor ImageInformationType.Create;
begin
  inherited Create;
  FSerializationOptions := [xoLiteralParam];
end;

constructor ImageSystemGlobalNodeType.Create;
begin
  inherited Create;
  FSerializationOptions := [xoLiteralParam];
end;

constructor ImageDevFieldsType.Create;
begin
  inherited Create;
  FSerializationOptions := [xoLiteralParam];
end;

constructor StudyReportType.Create;
begin
  inherited Create;
  FSerializationOptions := [xoLiteralParam];
end;

destructor RemoteMethodParameterType.Destroy;
begin
  FreeAndNil(FparameterValue);
  inherited Destroy;
end;

constructor RemoteMethodResponseType.Create;
begin
  inherited Create;
  FSerializationOptions := [xoLiteralParam];
end;

constructor PingServerType.Create;
begin
  inherited Create;
  FSerializationOptions := [xoLiteralParam];
end;

constructor PrefetchResponseType.Create;
begin
  inherited Create;
  FSerializationOptions := [xoLiteralParam];
end;

constructor PatientSensitiveCheckWrapperResponseType.Create;
begin
  inherited Create;
  FSerializationOptions := [xoLiteralParam];
end;

destructor PatientSensitiveCheckWrapperResponseType.Destroy;
begin
  FreeAndNil(Fresponse);
  inherited Destroy;
end;

constructor getAnnotationDetailsResponseType.Create;
begin
  inherited Create;
  FSerializationOptions := [xoLiteralParam];
end;

destructor getAnnotationDetailsResponseType.Destroy;
begin
  FreeAndNil(Fresponse);
  inherited Destroy;
end;

constructor postAnnotationDetailsResponseType.Create;
begin
  inherited Create;
  FSerializationOptions := [xoLiteralParam];
end;

destructor postAnnotationDetailsResponseType.Destroy;
begin
  FreeAndNil(Fresponse);
  inherited Destroy;
end;

constructor getUserDetailsResponseType.Create;
begin
  inherited Create;
  FSerializationOptions := [xoLiteralParam];
end;

destructor getUserDetailsResponseType.Destroy;
begin
  FreeAndNil(Fresponse);
  inherited Destroy;
end;

constructor isAnnotationsSupportedResponseType.Create;
begin
  inherited Create;
  FSerializationOptions := [xoLiteralParam];
end;

constructor getPatientSensitivityLevel.Create;
begin
  inherited Create;
  FSerializationOptions := [xoLiteralParam];
end;

destructor getPatientSensitivityLevel.Destroy;
begin
  FreeAndNil(Fcredentials);
  inherited Destroy;
end;

constructor getPatientShallowStudyList.Create;
begin
  inherited Create;
  FSerializationOptions := [xoLiteralParam];
end;

destructor getPatientShallowStudyList.Destroy;
begin
  FreeAndNil(Ffilter);
  FreeAndNil(Fcredentials);
  inherited Destroy;
end;

constructor getStudyImageList.Create;
begin
  inherited Create;
  FSerializationOptions := [xoLiteralParam];
end;

destructor getStudyImageList.Destroy;
begin
  FreeAndNil(Fcredentials);
  inherited Destroy;
end;

constructor postImageAccessEvent.Create;
begin
  inherited Create;
  FSerializationOptions := [xoLiteralParam];
end;

destructor postImageAccessEvent.Destroy;
begin
  FreeAndNil(Flog_event);
  inherited Destroy;
end;

constructor pingServer.Create;
begin
  inherited Create;
  FSerializationOptions := [xoLiteralParam];
end;

destructor pingServer.Destroy;
begin
  FreeAndNil(Fcredentials);
  inherited Destroy;
end;

constructor prefetchStudyList.Create;
begin
  inherited Create;
  FSerializationOptions := [xoLiteralParam];
end;

destructor prefetchStudyList.Destroy;
begin
  FreeAndNil(Ffilter);
  FreeAndNil(Fcredentials);
  inherited Destroy;
end;

constructor getImageInformation.Create;
begin
  inherited Create;
  FSerializationOptions := [xoLiteralParam];
end;

destructor getImageInformation.Destroy;
begin
  FreeAndNil(Fcredentials);
  inherited Destroy;
end;

constructor getImageSystemGlobalNode.Create;
begin
  inherited Create;
  FSerializationOptions := [xoLiteralParam];
end;

destructor getImageSystemGlobalNode.Destroy;
begin
  FreeAndNil(Fcredentials);
  inherited Destroy;
end;

constructor getImageDevFields.Create;
begin
  inherited Create;
  FSerializationOptions := [xoLiteralParam];
end;

destructor getImageDevFields.Destroy;
begin
  FreeAndNil(Fcredentials);
  inherited Destroy;
end;

constructor getStudyReport.Create;
begin
  inherited Create;
  FSerializationOptions := [xoLiteralParam];
end;

destructor getStudyReport.Destroy;
begin
  FreeAndNil(Fcredentials);
  inherited Destroy;
end;

constructor remoteMethodPassthrough.Create;
begin
  inherited Create;
  FSerializationOptions := [xoLiteralParam];
end;

destructor remoteMethodPassthrough.Destroy;
var
  I: Integer;
begin
  for I := 0 to Length(FinputParameters)-1 do
    FreeAndNil(FinputParameters[I]);
  SetLength(FinputParameters, 0);
  FreeAndNil(Fcredentials);
  inherited Destroy;
end;

constructor getImageAnnotations.Create;
begin
  inherited Create;
  FSerializationOptions := [xoLiteralParam];
end;

destructor getImageAnnotations.Destroy;
begin
  FreeAndNil(Fcredentials);
  inherited Destroy;
end;

constructor getAnnotationDetails.Create;
begin
  inherited Create;
  FSerializationOptions := [xoLiteralParam];
end;

destructor getAnnotationDetails.Destroy;
begin
  FreeAndNil(Fcredentials);
  inherited Destroy;
end;

constructor postAnnotationDetails.Create;
begin
  inherited Create;
  FSerializationOptions := [xoLiteralParam];
end;

destructor postAnnotationDetails.Destroy;
begin
  FreeAndNil(Fcredentials);
  inherited Destroy;
end;

constructor getUserDetails.Create;
begin
  inherited Create;
  FSerializationOptions := [xoLiteralParam];
end;

destructor getUserDetails.Destroy;
begin
  FreeAndNil(Fcredentials);
  inherited Destroy;
end;

constructor isAnnotationsSupported.Create;
begin
  inherited Create;
  FSerializationOptions := [xoLiteralParam];
end;

destructor isAnnotationsSupported.Destroy;
begin
  FreeAndNil(Fcredentials);
  inherited Destroy;
end;

procedure RemoteMethodParameterValueType.SetmultipleValue(Index: Integer; const ARemoteMethodParameterMultipleType: RemoteMethodParameterMultipleType);
begin
  FmultipleValue := ARemoteMethodParameterMultipleType;
  FmultipleValue_Specified := True;
end;

function RemoteMethodParameterValueType.multipleValue_Specified(Index: Integer): boolean;
begin
  Result := FmultipleValue_Specified;
end;

procedure UserType.Setkey(Index: Integer; const AArray_Of_string: Array_Of_string);
begin
  Fkey := AArray_Of_string;
  Fkey_Specified := True;
end;

function UserType.key_Specified(Index: Integer): boolean;
begin
  Result := Fkey_Specified;
end;

initialization
  InvRegistry.RegisterInterface(TypeInfo(ImageClinicalDisplayMetadata), 'urn:v7.soap.webservices.clinicaldisplay.imaging.med.va.gov', 'UTF-8');
  InvRegistry.RegisterAllSOAPActions(TypeInfo(ImageClinicalDisplayMetadata), '|getPatientShallowStudyList'
                                                                            +'|getStudyImageList'
                                                                            +'|postImageAccessEvent'
                                                                            +'|pingServer'
                                                                            +'|prefetchStudyList'
                                                                            +'|getImageInformation'
                                                                            +'|getImageSystemGlobalNode'
                                                                            +'|getImageDevFields'
                                                                            +'|getPatientSensitivityLevel'
                                                                            +'|getStudyReport'
                                                                            +'|remoteMethodPassthrough'
                                                                            +'|getImageAnnotations'
                                                                            +'|getAnnotationDetails'
                                                                            +'|postAnnotationDetails'
                                                                            +'|getUserDetails'
                                                                            +'|isAnnotationsSupported'
                                                                            );
  InvRegistry.RegisterInvokeOptions(TypeInfo(ImageClinicalDisplayMetadata), ioDocument);
  InvRegistry.RegisterInvokeOptions(TypeInfo(ImageClinicalDisplayMetadata), ioLiteral);
  InvRegistry.RegisterExternalParamName(TypeInfo(ImageClinicalDisplayMetadata), 'getPatientShallowStudyList', 'parameters1', 'parameters');
  InvRegistry.RegisterExternalParamName(TypeInfo(ImageClinicalDisplayMetadata), 'getStudyImageList', 'parameters1', 'parameters');
  InvRegistry.RegisterExternalParamName(TypeInfo(ImageClinicalDisplayMetadata), 'postImageAccessEvent', 'parameters1', 'parameters');
  InvRegistry.RegisterExternalParamName(TypeInfo(ImageClinicalDisplayMetadata), 'pingServerEvent', 'parameters1', 'parameters');
  InvRegistry.RegisterExternalParamName(TypeInfo(ImageClinicalDisplayMetadata), 'prefetchStudyList', 'parameters1', 'parameters');
  InvRegistry.RegisterExternalParamName(TypeInfo(ImageClinicalDisplayMetadata), 'getImageInformation', 'parameters1', 'parameters');
  InvRegistry.RegisterExternalParamName(TypeInfo(ImageClinicalDisplayMetadata), 'getImageSystemGlobalNode', 'parameters1', 'parameters');
  InvRegistry.RegisterExternalParamName(TypeInfo(ImageClinicalDisplayMetadata), 'getImageDevFields', 'parameters1', 'parameters');
  InvRegistry.RegisterExternalParamName(TypeInfo(ImageClinicalDisplayMetadata), 'getPatientSensitivityLevel', 'parameters1', 'parameters');
  InvRegistry.RegisterExternalParamName(TypeInfo(ImageClinicalDisplayMetadata), 'getStudyReport', 'parameters1', 'parameters');
  InvRegistry.RegisterExternalParamName(TypeInfo(ImageClinicalDisplayMetadata), 'remoteMethodPassthrough', 'parameters1', 'parameters');
  InvRegistry.RegisterExternalParamName(TypeInfo(ImageClinicalDisplayMetadata), 'getImageAnnotations', 'parameters1', 'parameters');
  InvRegistry.RegisterExternalParamName(TypeInfo(ImageClinicalDisplayMetadata), 'getAnnotationDetails', 'parameters1', 'parameters');
  InvRegistry.RegisterExternalParamName(TypeInfo(ImageClinicalDisplayMetadata), 'postAnnotationDetails', 'parameters1', 'parameters');
  InvRegistry.RegisterExternalParamName(TypeInfo(ImageClinicalDisplayMetadata), 'getUserDetails', 'parameters1', 'parameters');
  InvRegistry.RegisterExternalParamName(TypeInfo(ImageClinicalDisplayMetadata), 'isAnnotationsSupported', 'parameters1', 'parameters');
  RemClassRegistry.RegisterXSClass(AnnotationUserType, 'urn:v7.soap.webservices.clinicaldisplay.imaging.med.va.gov', 'AnnotationUserType');
  RemClassRegistry.RegisterExternalPropName(TypeInfo(AnnotationUserType), 'name_', 'name');
  RemClassRegistry.RegisterXSInfo(TypeInfo(source), 'urn:v7.soap.webservices.clinicaldisplay.imaging.med.va.gov', 'source');
  RemClassRegistry.RegisterXSClass(AnnotationType, 'urn:v7.soap.webservices.clinicaldisplay.imaging.med.va.gov', 'AnnotationType');
  RemClassRegistry.RegisterExternalPropName(TypeInfo(AnnotationType), 'saved_date', 'saved-date');
  RemClassRegistry.RegisterExternalPropName(TypeInfo(AnnotationType), 'annotation_id', 'annotation-id');
  RemClassRegistry.RegisterExternalPropName(TypeInfo(AnnotationType), 'image_id', 'image-id');
  RemClassRegistry.RegisterExternalPropName(TypeInfo(AnnotationType), 'saved_after_result', 'saved-after-result');
  RemClassRegistry.RegisterExternalPropName(TypeInfo(AnnotationType), 'annotation_version', 'annotation-version');
  RemClassRegistry.RegisterExternalPropName(TypeInfo(AnnotationType), 'annotation_deleted', 'annotation-deleted');
  RemClassRegistry.RegisterXSClass(AnnotationDetailsType, 'urn:v7.soap.webservices.clinicaldisplay.imaging.med.va.gov', 'AnnotationDetailsType');
  RemClassRegistry.RegisterXSInfo(TypeInfo(DateType), 'urn:v7.soap.webservices.clinicaldisplay.imaging.med.va.gov', 'DateType');
  RemClassRegistry.RegisterXSInfo(TypeInfo(origin), 'urn:v7.soap.webservices.clinicaldisplay.imaging.med.va.gov', 'origin');
  RemClassRegistry.RegisterExternalPropName(TypeInfo(origin), 'NON_VA', 'NON-VA');
  RemClassRegistry.RegisterXSClass(FilterType, 'urn:v7.soap.webservices.clinicaldisplay.imaging.med.va.gov', 'FilterType');
  RemClassRegistry.RegisterExternalPropName(TypeInfo(FilterType), 'package_', 'package');
  RemClassRegistry.RegisterExternalPropName(TypeInfo(FilterType), 'class_', 'class');
  RemClassRegistry.RegisterExternalPropName(TypeInfo(FilterType), 'from_date', 'from-date');
  RemClassRegistry.RegisterExternalPropName(TypeInfo(FilterType), 'to_date', 'to-date');
  RemClassRegistry.RegisterExternalPropName(TypeInfo(FilterType), 'include_deleted', 'include-deleted');
  RemClassRegistry.RegisterXSClass(UserCredentialsType, 'urn:v7.soap.webservices.clinicaldisplay.imaging.med.va.gov', 'UserCredentialsType');
  RemClassRegistry.RegisterExternalPropName(TypeInfo(UserCredentialsType), 'client_version', 'client-version');
  RemClassRegistry.RegisterXSInfo(TypeInfo(eventType), 'urn:v7.soap.webservices.clinicaldisplay.imaging.med.va.gov', 'eventType');
  RemClassRegistry.RegisterXSClass(ImageAccessLogEventType, 'urn:v7.soap.webservices.clinicaldisplay.imaging.med.va.gov', 'ImageAccessLogEventType');
  RemClassRegistry.RegisterExternalPropName(TypeInfo(ImageAccessLogEventType), 'reason_code', 'reason-code');
  RemClassRegistry.RegisterExternalPropName(TypeInfo(ImageAccessLogEventType), 'reason_description', 'reason-description');
  RemClassRegistry.RegisterXSClass(FatImageType, 'urn:v7.soap.webservices.clinicaldisplay.imaging.med.va.gov', 'FatImageType');
  RemClassRegistry.RegisterExternalPropName(TypeInfo(FatImageType), 'image_id', 'image-id');
  RemClassRegistry.RegisterExternalPropName(TypeInfo(FatImageType), 'procedure_date', 'procedure-date');
  RemClassRegistry.RegisterExternalPropName(TypeInfo(FatImageType), 'procedure_', 'procedure');
  RemClassRegistry.RegisterExternalPropName(TypeInfo(FatImageType), 'dicom_sequence_number', 'dicom-sequence-number');
  RemClassRegistry.RegisterExternalPropName(TypeInfo(FatImageType), 'dicom_image_number', 'dicom-image-number');
  RemClassRegistry.RegisterExternalPropName(TypeInfo(FatImageType), 'patient_icn', 'patient-icn');
  RemClassRegistry.RegisterExternalPropName(TypeInfo(FatImageType), 'patient_name', 'patient-name');
  RemClassRegistry.RegisterExternalPropName(TypeInfo(FatImageType), 'site_number', 'site-number');
  RemClassRegistry.RegisterExternalPropName(TypeInfo(FatImageType), 'site_abbr', 'site-abbr');
  RemClassRegistry.RegisterExternalPropName(TypeInfo(FatImageType), 'image_type', 'image-type');
  RemClassRegistry.RegisterExternalPropName(TypeInfo(FatImageType), 'abs_location', 'abs-location');
  RemClassRegistry.RegisterExternalPropName(TypeInfo(FatImageType), 'full_location', 'full-location');
  RemClassRegistry.RegisterExternalPropName(TypeInfo(FatImageType), 'image_class', 'image-class');
  RemClassRegistry.RegisterExternalPropName(TypeInfo(FatImageType), 'full_image_URI', 'full-image-URI');
  RemClassRegistry.RegisterExternalPropName(TypeInfo(FatImageType), 'abs_image_URI', 'abs-image-URI');
  RemClassRegistry.RegisterExternalPropName(TypeInfo(FatImageType), 'big_image_URI', 'big-image-URI');
  RemClassRegistry.RegisterExternalPropName(TypeInfo(FatImageType), 'capture_date', 'capture-date');
  RemClassRegistry.RegisterExternalPropName(TypeInfo(FatImageType), 'document_date', 'document-date');
  RemClassRegistry.RegisterExternalPropName(TypeInfo(FatImageType), 'view_status', 'view-status');
  RemClassRegistry.RegisterExternalPropName(TypeInfo(FatImageType), 'image_has_annotations', 'image-has-annotations');
  RemClassRegistry.RegisterExternalPropName(TypeInfo(FatImageType), 'image_annotation_status', 'image-annotation-status');
  RemClassRegistry.RegisterExternalPropName(TypeInfo(FatImageType), 'image_annotation_status_description', 'image-annotation-status-description');
  RemClassRegistry.RegisterExternalPropName(TypeInfo(FatImageType), 'associated_note_resulted', 'associated-note-resulted');
  RemClassRegistry.RegisterExternalPropName(TypeInfo(FatImageType), 'image_package', 'image-package');
  RemClassRegistry.RegisterXSInfo(TypeInfo(FatImagesType), 'urn:v7.soap.webservices.clinicaldisplay.imaging.med.va.gov', 'FatImagesType');
  RemClassRegistry.RegisterSerializeOptions(TypeInfo(FatImagesType), [xoLiteralParam]);
  RemClassRegistry.RegisterXSClass(ShallowStudyType, 'urn:v7.soap.webservices.clinicaldisplay.imaging.med.va.gov', 'ShallowStudyType');
  RemClassRegistry.RegisterExternalPropName(TypeInfo(ShallowStudyType), 'study_id', 'study-id');
  RemClassRegistry.RegisterExternalPropName(TypeInfo(ShallowStudyType), 'procedure_date', 'procedure-date');
  RemClassRegistry.RegisterExternalPropName(TypeInfo(ShallowStudyType), 'procedure_', 'procedure');
  RemClassRegistry.RegisterExternalPropName(TypeInfo(ShallowStudyType), 'patient_icn', 'patient-icn');
  RemClassRegistry.RegisterExternalPropName(TypeInfo(ShallowStudyType), 'patient_name', 'patient-name');
  RemClassRegistry.RegisterExternalPropName(TypeInfo(ShallowStudyType), 'site_number', 'site-number');
  RemClassRegistry.RegisterExternalPropName(TypeInfo(ShallowStudyType), 'site_abbreviation', 'site-abbreviation');
  RemClassRegistry.RegisterExternalPropName(TypeInfo(ShallowStudyType), 'image_count', 'image-count');
  RemClassRegistry.RegisterExternalPropName(TypeInfo(ShallowStudyType), 'note_title', 'note-title');
  RemClassRegistry.RegisterExternalPropName(TypeInfo(ShallowStudyType), 'image_package', 'image-package');
  RemClassRegistry.RegisterExternalPropName(TypeInfo(ShallowStudyType), 'image_type', 'image-type');
  RemClassRegistry.RegisterExternalPropName(TypeInfo(ShallowStudyType), 'study_package', 'study-package');
  RemClassRegistry.RegisterExternalPropName(TypeInfo(ShallowStudyType), 'study_class', 'study-class');
  RemClassRegistry.RegisterExternalPropName(TypeInfo(ShallowStudyType), 'study_type', 'study-type');
  RemClassRegistry.RegisterExternalPropName(TypeInfo(ShallowStudyType), 'capture_date', 'capture-date');
  RemClassRegistry.RegisterExternalPropName(TypeInfo(ShallowStudyType), 'captured_by', 'captured-by');
  RemClassRegistry.RegisterExternalPropName(TypeInfo(ShallowStudyType), 'first_image', 'first-image');
  RemClassRegistry.RegisterExternalPropName(TypeInfo(ShallowStudyType), 'document_date', 'document-date');
  RemClassRegistry.RegisterExternalPropName(TypeInfo(ShallowStudyType), 'view_status', 'view-status');
  RemClassRegistry.RegisterExternalPropName(TypeInfo(ShallowStudyType), 'study_images_have_annotations', 'study-images-have-annotations');
  RemClassRegistry.RegisterXSInfo(TypeInfo(ShallowStudiesErrorType), 'urn:v7.soap.webservices.clinicaldisplay.imaging.med.va.gov', 'ShallowStudiesErrorType');
  RemClassRegistry.RegisterXSClass(ShallowStudiesErrorMessageType, 'urn:v7.soap.webservices.clinicaldisplay.imaging.med.va.gov', 'ShallowStudiesErrorMessageType');
  RemClassRegistry.RegisterXSInfo(TypeInfo(ShallowStudiesStudiesType), 'urn:v7.soap.webservices.clinicaldisplay.imaging.med.va.gov', 'ShallowStudiesStudiesType');
  RemClassRegistry.RegisterXSClass(ShallowStudiesType, 'urn:v7.soap.webservices.clinicaldisplay.imaging.med.va.gov', 'ShallowStudiesType');
  RemClassRegistry.RegisterExternalPropName(TypeInfo(ShallowStudiesType), 'partial_result', 'partial-result');
  RemClassRegistry.RegisterExternalPropName(TypeInfo(ShallowStudiesType), 'partial_result_message', 'partial-result-message');
  RemClassRegistry.RegisterXSClass(ShallowStudiesResponseType, 'urn:v7.soap.webservices.clinicaldisplay.imaging.med.va.gov', 'ShallowStudiesResponseType');
  RemClassRegistry.RegisterSerializeOptions(ShallowStudiesResponseType, [xoLiteralParam]);
  RemClassRegistry.RegisterXSClass(ImageAccessEventType, 'urn:v7.soap.webservices.clinicaldisplay.imaging.med.va.gov', 'ImageAccessEventType');
  RemClassRegistry.RegisterSerializeOptions(ImageAccessEventType, [xoLiteralParam]);
  RemClassRegistry.RegisterXSClass(ImageInformationType, 'urn:v7.soap.webservices.clinicaldisplay.imaging.med.va.gov', 'ImageInformationType');
  RemClassRegistry.RegisterSerializeOptions(ImageInformationType, [xoLiteralParam]);
  RemClassRegistry.RegisterXSClass(ImageSystemGlobalNodeType, 'urn:v7.soap.webservices.clinicaldisplay.imaging.med.va.gov', 'ImageSystemGlobalNodeType');
  RemClassRegistry.RegisterSerializeOptions(ImageSystemGlobalNodeType, [xoLiteralParam]);
  RemClassRegistry.RegisterXSClass(ImageDevFieldsType, 'urn:v7.soap.webservices.clinicaldisplay.imaging.med.va.gov', 'ImageDevFieldsType');
  RemClassRegistry.RegisterSerializeOptions(ImageDevFieldsType, [xoLiteralParam]);
  RemClassRegistry.RegisterXSClass(StudyReportType, 'urn:v7.soap.webservices.clinicaldisplay.imaging.med.va.gov', 'StudyReportType');
  RemClassRegistry.RegisterSerializeOptions(StudyReportType, [xoLiteralParam]);
  RemClassRegistry.RegisterXSInfo(TypeInfo(RemoteMethodParameterTypeType), 'urn:v7.soap.webservices.clinicaldisplay.imaging.med.va.gov', 'RemoteMethodParameterTypeType');
  RemClassRegistry.RegisterXSClass(RemoteMethodParameterType, 'urn:v7.soap.webservices.clinicaldisplay.imaging.med.va.gov', 'RemoteMethodParameterType');
  RemClassRegistry.RegisterXSInfo(TypeInfo(RemoteMethodInputParameterType), 'urn:v7.soap.webservices.clinicaldisplay.imaging.med.va.gov', 'RemoteMethodInputParameterType');
  RemClassRegistry.RegisterXSClass(RemoteMethodResponseType, 'urn:v7.soap.webservices.clinicaldisplay.imaging.med.va.gov', 'RemoteMethodResponseType');
  RemClassRegistry.RegisterSerializeOptions(RemoteMethodResponseType, [xoLiteralParam]);
  RemClassRegistry.RegisterXSInfo(TypeInfo(pingResponse), 'urn:v7.soap.webservices.clinicaldisplay.imaging.med.va.gov', 'pingResponse');
  RemClassRegistry.RegisterXSClass(PingServerType, 'urn:v7.soap.webservices.clinicaldisplay.imaging.med.va.gov', 'PingServerType');
  RemClassRegistry.RegisterSerializeOptions(PingServerType, [xoLiteralParam]);
  RemClassRegistry.RegisterXSInfo(TypeInfo(prefetchResponse), 'urn:v7.soap.webservices.clinicaldisplay.imaging.med.va.gov', 'prefetchResponse');
  RemClassRegistry.RegisterXSClass(PrefetchResponseType, 'urn:v7.soap.webservices.clinicaldisplay.imaging.med.va.gov', 'PrefetchResponseType');
  RemClassRegistry.RegisterSerializeOptions(PrefetchResponseType, [xoLiteralParam]);
  RemClassRegistry.RegisterXSInfo(TypeInfo(PatientSensitivityLevelType), 'urn:v7.soap.webservices.clinicaldisplay.imaging.med.va.gov', 'PatientSensitivityLevelType');
  RemClassRegistry.RegisterXSClass(PatientSensitiveCheckResponseType, 'urn:v7.soap.webservices.clinicaldisplay.imaging.med.va.gov', 'PatientSensitiveCheckResponseType');
  RemClassRegistry.RegisterXSClass(PatientSensitiveCheckWrapperResponseType, 'urn:v7.soap.webservices.clinicaldisplay.imaging.med.va.gov', 'PatientSensitiveCheckWrapperResponseType');
  RemClassRegistry.RegisterSerializeOptions(PatientSensitiveCheckWrapperResponseType, [xoLiteralParam]);
  RemClassRegistry.RegisterXSInfo(TypeInfo(getImageAnnotationsResponseType), 'urn:v7.soap.webservices.clinicaldisplay.imaging.med.va.gov', 'getImageAnnotationsResponseType');
  RemClassRegistry.RegisterSerializeOptions(TypeInfo(getImageAnnotationsResponseType), [xoLiteralParam]);
  RemClassRegistry.RegisterXSClass(getAnnotationDetailsResponseType, 'urn:v7.soap.webservices.clinicaldisplay.imaging.med.va.gov', 'getAnnotationDetailsResponseType');
  RemClassRegistry.RegisterSerializeOptions(getAnnotationDetailsResponseType, [xoLiteralParam]);
  RemClassRegistry.RegisterXSClass(postAnnotationDetailsResponseType, 'urn:v7.soap.webservices.clinicaldisplay.imaging.med.va.gov', 'postAnnotationDetailsResponseType');
  RemClassRegistry.RegisterSerializeOptions(postAnnotationDetailsResponseType, [xoLiteralParam]);
  RemClassRegistry.RegisterXSClass(getUserDetailsResponseType, 'urn:v7.soap.webservices.clinicaldisplay.imaging.med.va.gov', 'getUserDetailsResponseType');
  RemClassRegistry.RegisterSerializeOptions(getUserDetailsResponseType, [xoLiteralParam]);
  RemClassRegistry.RegisterXSClass(isAnnotationsSupportedResponseType, 'urn:v7.soap.webservices.clinicaldisplay.imaging.med.va.gov', 'isAnnotationsSupportedResponseType');
  RemClassRegistry.RegisterSerializeOptions(isAnnotationsSupportedResponseType, [xoLiteralParam]);
  RemClassRegistry.RegisterXSInfo(TypeInfo(TransactionIdentifierType), 'urn:v7.soap.webservices.clinicaldisplay.imaging.med.va.gov', 'TransactionIdentifierType');
  RemClassRegistry.RegisterXSInfo(TypeInfo(RemoteMethodNameType), 'urn:v7.soap.webservices.clinicaldisplay.imaging.med.va.gov', 'RemoteMethodNameType');
  RemClassRegistry.RegisterXSClass(getPatientSensitivityLevel, 'urn:v7.soap.webservices.clinicaldisplay.imaging.med.va.gov', 'getPatientSensitivityLevel');
  RemClassRegistry.RegisterExternalPropName(TypeInfo(getPatientSensitivityLevel), 'transaction_id', 'transaction-id');
  RemClassRegistry.RegisterExternalPropName(TypeInfo(getPatientSensitivityLevel), 'site_id', 'site-id');
  RemClassRegistry.RegisterExternalPropName(TypeInfo(getPatientSensitivityLevel), 'patient_id', 'patient-id');
  RemClassRegistry.RegisterSerializeOptions(getPatientSensitivityLevel, [xoLiteralParam]);
  RemClassRegistry.RegisterXSClass(getPatientSensitivityLevelResponse, 'urn:v7.soap.webservices.clinicaldisplay.imaging.med.va.gov', 'getPatientSensitivityLevelResponse');
  RemClassRegistry.RegisterXSClass(getPatientShallowStudyList, 'urn:v7.soap.webservices.clinicaldisplay.imaging.med.va.gov', 'getPatientShallowStudyList');
  RemClassRegistry.RegisterExternalPropName(TypeInfo(getPatientShallowStudyList), 'transaction_id', 'transaction-id');
  RemClassRegistry.RegisterExternalPropName(TypeInfo(getPatientShallowStudyList), 'site_id', 'site-id');
  RemClassRegistry.RegisterExternalPropName(TypeInfo(getPatientShallowStudyList), 'patient_id', 'patient-id');
  RemClassRegistry.RegisterSerializeOptions(getPatientShallowStudyList, [xoLiteralParam]);
  RemClassRegistry.RegisterXSClass(getPatientShallowStudyListResponse, 'urn:v7.soap.webservices.clinicaldisplay.imaging.med.va.gov', 'getPatientShallowStudyListResponse');
  RemClassRegistry.RegisterXSClass(getStudyImageList, 'urn:v7.soap.webservices.clinicaldisplay.imaging.med.va.gov', 'getStudyImageList');
  RemClassRegistry.RegisterExternalPropName(TypeInfo(getStudyImageList), 'transaction_id', 'transaction-id');
  RemClassRegistry.RegisterExternalPropName(TypeInfo(getStudyImageList), 'study_id', 'study-id');
  RemClassRegistry.RegisterExternalPropName(TypeInfo(getStudyImageList), 'include_deleted_images', 'include-deleted-images');
  RemClassRegistry.RegisterSerializeOptions(getStudyImageList, [xoLiteralParam]);
  RemClassRegistry.RegisterXSInfo(TypeInfo(getStudyImageListResponse), 'urn:v7.soap.webservices.clinicaldisplay.imaging.med.va.gov', 'getStudyImageListResponse');
  RemClassRegistry.RegisterXSClass(postImageAccessEvent, 'urn:v7.soap.webservices.clinicaldisplay.imaging.med.va.gov', 'postImageAccessEvent');
  RemClassRegistry.RegisterExternalPropName(TypeInfo(postImageAccessEvent), 'transaction_id', 'transaction-id');
  RemClassRegistry.RegisterExternalPropName(TypeInfo(postImageAccessEvent), 'log_event', 'log-event');
  RemClassRegistry.RegisterSerializeOptions(postImageAccessEvent, [xoLiteralParam]);
  RemClassRegistry.RegisterXSClass(postImageAccessEventResponse, 'urn:v7.soap.webservices.clinicaldisplay.imaging.med.va.gov', 'postImageAccessEventResponse');
  RemClassRegistry.RegisterXSClass(pingServer, 'urn:v7.soap.webservices.clinicaldisplay.imaging.med.va.gov', 'pingServer');
  RemClassRegistry.RegisterExternalPropName(TypeInfo(pingServer), 'transaction_id', 'transaction-id');
  RemClassRegistry.RegisterSerializeOptions(pingServer, [xoLiteralParam]);
  RemClassRegistry.RegisterXSClass(postPingServerResponse, 'urn:v7.soap.webservices.clinicaldisplay.imaging.med.va.gov', 'postPingServerResponse');
  RemClassRegistry.RegisterXSClass(prefetchStudyList, 'urn:v7.soap.webservices.clinicaldisplay.imaging.med.va.gov', 'prefetchStudyList');
  RemClassRegistry.RegisterExternalPropName(TypeInfo(prefetchStudyList), 'transaction_id', 'transaction-id');
  RemClassRegistry.RegisterExternalPropName(TypeInfo(prefetchStudyList), 'site_id', 'site-id');
  RemClassRegistry.RegisterExternalPropName(TypeInfo(prefetchStudyList), 'patient_id', 'patient-id');
  RemClassRegistry.RegisterSerializeOptions(prefetchStudyList, [xoLiteralParam]);
  RemClassRegistry.RegisterXSClass(PrefetchStudyListResponse, 'urn:v7.soap.webservices.clinicaldisplay.imaging.med.va.gov', 'PrefetchStudyListResponse');
  RemClassRegistry.RegisterXSClass(getImageInformation, 'urn:v7.soap.webservices.clinicaldisplay.imaging.med.va.gov', 'getImageInformation');
  RemClassRegistry.RegisterExternalPropName(TypeInfo(getImageInformation), 'transaction_id', 'transaction-id');
  RemClassRegistry.RegisterExternalPropName(TypeInfo(getImageInformation), 'include_deleted_images', 'include-deleted-images');
  RemClassRegistry.RegisterSerializeOptions(getImageInformation, [xoLiteralParam]);
  RemClassRegistry.RegisterXSClass(getImageInformationResponse, 'urn:v7.soap.webservices.clinicaldisplay.imaging.med.va.gov', 'getImageInformationResponse');
  RemClassRegistry.RegisterXSClass(getImageSystemGlobalNode, 'urn:v7.soap.webservices.clinicaldisplay.imaging.med.va.gov', 'getImageSystemGlobalNode');
  RemClassRegistry.RegisterExternalPropName(TypeInfo(getImageSystemGlobalNode), 'transaction_id', 'transaction-id');
  RemClassRegistry.RegisterSerializeOptions(getImageSystemGlobalNode, [xoLiteralParam]);
  RemClassRegistry.RegisterXSClass(getImageSystemGlobalNodeResponse, 'urn:v7.soap.webservices.clinicaldisplay.imaging.med.va.gov', 'getImageSystemGlobalNodeResponse');
  RemClassRegistry.RegisterXSClass(getImageDevFields, 'urn:v7.soap.webservices.clinicaldisplay.imaging.med.va.gov', 'getImageDevFields');
  RemClassRegistry.RegisterExternalPropName(TypeInfo(getImageDevFields), 'transaction_id', 'transaction-id');
  RemClassRegistry.RegisterSerializeOptions(getImageDevFields, [xoLiteralParam]);
  RemClassRegistry.RegisterXSClass(getImageDevFieldsResponse, 'urn:v7.soap.webservices.clinicaldisplay.imaging.med.va.gov', 'getImageDevFieldsResponse');
  RemClassRegistry.RegisterXSClass(getStudyReport, 'urn:v7.soap.webservices.clinicaldisplay.imaging.med.va.gov', 'getStudyReport');
  RemClassRegistry.RegisterExternalPropName(TypeInfo(getStudyReport), 'transaction_id', 'transaction-id');
  RemClassRegistry.RegisterExternalPropName(TypeInfo(getStudyReport), 'study_id', 'study-id');
  RemClassRegistry.RegisterSerializeOptions(getStudyReport, [xoLiteralParam]);
  RemClassRegistry.RegisterXSClass(getStudyReportResponse, 'urn:v7.soap.webservices.clinicaldisplay.imaging.med.va.gov', 'getStudyReportResponse');
  RemClassRegistry.RegisterXSClass(remoteMethodPassthrough, 'urn:v7.soap.webservices.clinicaldisplay.imaging.med.va.gov', 'remoteMethodPassthrough');
  RemClassRegistry.RegisterExternalPropName(TypeInfo(remoteMethodPassthrough), 'transaction_id', 'transaction-id');
  RemClassRegistry.RegisterExternalPropName(TypeInfo(remoteMethodPassthrough), 'site_id', 'site-id');
  RemClassRegistry.RegisterSerializeOptions(remoteMethodPassthrough, [xoLiteralParam]);
  RemClassRegistry.RegisterXSClass(remoteMethodPassthroughResponse, 'urn:v7.soap.webservices.clinicaldisplay.imaging.med.va.gov', 'remoteMethodPassthroughResponse');
  RemClassRegistry.RegisterXSClass(getImageAnnotations, 'urn:v7.soap.webservices.clinicaldisplay.imaging.med.va.gov', 'getImageAnnotations');
  RemClassRegistry.RegisterExternalPropName(TypeInfo(getImageAnnotations), 'transaction_id', 'transaction-id');
  RemClassRegistry.RegisterExternalPropName(TypeInfo(getImageAnnotations), 'image_id', 'image-id');
  RemClassRegistry.RegisterSerializeOptions(getImageAnnotations, [xoLiteralParam]);
  RemClassRegistry.RegisterXSInfo(TypeInfo(getImageAnnotationsResponse), 'urn:v7.soap.webservices.clinicaldisplay.imaging.med.va.gov', 'getImageAnnotationsResponse');
  RemClassRegistry.RegisterXSClass(getAnnotationDetails, 'urn:v7.soap.webservices.clinicaldisplay.imaging.med.va.gov', 'getAnnotationDetails');
  RemClassRegistry.RegisterExternalPropName(TypeInfo(getAnnotationDetails), 'transaction_id', 'transaction-id');
  RemClassRegistry.RegisterExternalPropName(TypeInfo(getAnnotationDetails), 'image_id', 'image-id');
  RemClassRegistry.RegisterExternalPropName(TypeInfo(getAnnotationDetails), 'annotation_id', 'annotation-id');
  RemClassRegistry.RegisterSerializeOptions(getAnnotationDetails, [xoLiteralParam]);
  RemClassRegistry.RegisterXSClass(getAnnotationDetailsResponse, 'urn:v7.soap.webservices.clinicaldisplay.imaging.med.va.gov', 'getAnnotationDetailsResponse');
  RemClassRegistry.RegisterXSClass(postAnnotationDetails, 'urn:v7.soap.webservices.clinicaldisplay.imaging.med.va.gov', 'postAnnotationDetails');
  RemClassRegistry.RegisterExternalPropName(TypeInfo(postAnnotationDetails), 'transaction_id', 'transaction-id');
  RemClassRegistry.RegisterExternalPropName(TypeInfo(postAnnotationDetails), 'image_id', 'image-id');
  RemClassRegistry.RegisterSerializeOptions(postAnnotationDetails, [xoLiteralParam]);
  RemClassRegistry.RegisterXSClass(postAnnotationDetailsResponse, 'urn:v7.soap.webservices.clinicaldisplay.imaging.med.va.gov', 'postAnnotationDetailsResponse');
  RemClassRegistry.RegisterXSClass(getUserDetails, 'urn:v7.soap.webservices.clinicaldisplay.imaging.med.va.gov', 'getUserDetails');
  RemClassRegistry.RegisterExternalPropName(TypeInfo(getUserDetails), 'transaction_id', 'transaction-id');
  RemClassRegistry.RegisterExternalPropName(TypeInfo(getUserDetails), 'site_id', 'site-id');
  RemClassRegistry.RegisterSerializeOptions(getUserDetails, [xoLiteralParam]);
  RemClassRegistry.RegisterXSClass(getUserDetailsResponse, 'urn:v7.soap.webservices.clinicaldisplay.imaging.med.va.gov', 'getUserDetailsResponse');
  RemClassRegistry.RegisterXSClass(isAnnotationsSupported, 'urn:v7.soap.webservices.clinicaldisplay.imaging.med.va.gov', 'isAnnotationsSupported');
  RemClassRegistry.RegisterExternalPropName(TypeInfo(isAnnotationsSupported), 'transaction_id', 'transaction-id');
  RemClassRegistry.RegisterExternalPropName(TypeInfo(isAnnotationsSupported), 'site_id', 'site-id');
  RemClassRegistry.RegisterSerializeOptions(isAnnotationsSupported, [xoLiteralParam]);
  RemClassRegistry.RegisterXSClass(isAnnotationsSupportedResponse, 'urn:v7.soap.webservices.clinicaldisplay.imaging.med.va.gov', 'isAnnotationsSupportedResponse');
  RemClassRegistry.RegisterXSClass(image, 'urn:v7.soap.webservices.clinicaldisplay.imaging.med.va.gov', 'image');
  RemClassRegistry.RegisterXSClass(study, 'urn:v7.soap.webservices.clinicaldisplay.imaging.med.va.gov', 'study');
  RemClassRegistry.RegisterXSInfo(TypeInfo(multipleValue), 'urn:v7.soap.webservices.clinicaldisplay.imaging.med.va.gov', 'multipleValue');
  RemClassRegistry.RegisterXSInfo(TypeInfo(RemoteMethodParameterMultipleType), 'urn:v7.soap.webservices.clinicaldisplay.imaging.med.va.gov', 'RemoteMethodParameterMultipleType');
  RemClassRegistry.RegisterXSClass(RemoteMethodParameterValueType, 'urn:v7.soap.webservices.clinicaldisplay.imaging.med.va.gov', 'RemoteMethodParameterValueType');
  RemClassRegistry.RegisterXSClass(remoteMethodParameter, 'urn:v7.soap.webservices.clinicaldisplay.imaging.med.va.gov', 'remoteMethodParameter');
  RemClassRegistry.RegisterXSClass(response, 'urn:v7.soap.webservices.clinicaldisplay.imaging.med.va.gov', 'response');
  RemClassRegistry.RegisterXSInfo(TypeInfo(Array_Of_string), 'http://www.w3.org/2001/XMLSchema', 'Array_Of_string');
  RemClassRegistry.RegisterXSClass(UserType, 'urn:v7.soap.webservices.clinicaldisplay.imaging.med.va.gov', 'UserType');
  RemClassRegistry.RegisterExternalPropName(TypeInfo(UserType), 'user_id', 'user-id');
  RemClassRegistry.RegisterExternalPropName(TypeInfo(UserType), 'can_create_annotations', 'can-create-annotations');

end.