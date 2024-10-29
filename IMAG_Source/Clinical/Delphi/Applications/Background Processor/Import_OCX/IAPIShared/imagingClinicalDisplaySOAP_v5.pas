// ************************************************************************ //
// The types declared in this file were generated from data read from the
// WSDL File described below:
// WSDL     : C:\DevD2007\p106\Documents\WSDL\imagingClinicalDisplaySOAP_v5.wsdl
//  >Import : C:\DevD2007\p106\Documents\WSDL\imagingClinicalDisplaySOAP_v5.wsdl:0
// Encoding : UTF-8
// Version  : 1.0
// (10/7/2010 2:01:05 PM - - $Rev: 7300 $)
// ************************************************************************ //

unit imagingClinicalDisplaySOAP_v5;

interface

uses InvokeRegistry, SOAPHTTPClient, Types, XSBuiltIns;

const
  IS_OPTN = $0001;
  IS_UNBD = $0002;
  IS_NLBL = $0004;


type

  // ************************************************************************ //
  // The following types, referred to in the WSDL document are not being represented
  // in this file. They are either aliases[@] of other types represented or were referred
  // to but never[!] declared in the document. The types from the latter category
  // typically map to predefined/known XML or Borland types; however, they could also 
  // indicate incorrect WSDL documents that failed to declare or import a schema type.
  // ************************************************************************ //
  // !:string          - "http://www.w3.org/2001/XMLSchema"[Gbl]
  // !:integer         - "http://www.w3.org/2001/XMLSchema"[Gbl]
  // !:boolean         - "http://www.w3.org/2001/XMLSchema"[Gbl]

  FilterType           = class;                 { "urn:v5.soap.webservices.clinicaldisplay.imaging.med.va.gov"[GblCplx] }
  UserCredentials      = class;                 { "urn:v5.soap.webservices.clinicaldisplay.imaging.med.va.gov"[GblCplx] }
  ImageAccessLogEventType = class;              { "urn:v5.soap.webservices.clinicaldisplay.imaging.med.va.gov"[GblCplx] }
  FatImageType         = class;                 { "urn:v5.soap.webservices.clinicaldisplay.imaging.med.va.gov"[GblCplx] }
  ShallowStudyType     = class;                 { "urn:v5.soap.webservices.clinicaldisplay.imaging.med.va.gov"[GblCplx] }
  ShallowStudiesErrorMessageType = class;       { "urn:v5.soap.webservices.clinicaldisplay.imaging.med.va.gov"[GblCplx] }
  ShallowStudiesType   = class;                 { "urn:v5.soap.webservices.clinicaldisplay.imaging.med.va.gov"[GblCplx] }
  ShallowStudiesResponseType = class;           { "urn:v5.soap.webservices.clinicaldisplay.imaging.med.va.gov"[Lit][GblCplx] }
  ImageAccessEventType = class;                 { "urn:v5.soap.webservices.clinicaldisplay.imaging.med.va.gov"[Lit][GblCplx] }
  ImageInformationType = class;                 { "urn:v5.soap.webservices.clinicaldisplay.imaging.med.va.gov"[Lit][GblCplx] }
  ImageSystemGlobalNodeType = class;            { "urn:v5.soap.webservices.clinicaldisplay.imaging.med.va.gov"[Lit][GblCplx] }
  ImageDevFieldsType   = class;                 { "urn:v5.soap.webservices.clinicaldisplay.imaging.med.va.gov"[Lit][GblCplx] }
  StudyReportType      = class;                 { "urn:v5.soap.webservices.clinicaldisplay.imaging.med.va.gov"[Lit][GblCplx] }
  RemoteMethodParameterType = class;            { "urn:v5.soap.webservices.clinicaldisplay.imaging.med.va.gov"[GblCplx] }
  RemoteMethodResponseType = class;             { "urn:v5.soap.webservices.clinicaldisplay.imaging.med.va.gov"[Lit][GblCplx] }
  PingServerType       = class;                 { "urn:v5.soap.webservices.clinicaldisplay.imaging.med.va.gov"[Lit][GblCplx] }
  PrefetchResponseType = class;                 { "urn:v5.soap.webservices.clinicaldisplay.imaging.med.va.gov"[Lit][GblCplx] }
  PatientSensitiveCheckResponseType = class;    { "urn:v5.soap.webservices.clinicaldisplay.imaging.med.va.gov"[GblCplx] }
  PatientSensitiveCheckWrapperResponseType = class;   { "urn:v5.soap.webservices.clinicaldisplay.imaging.med.va.gov"[Lit][GblCplx] }
  getPatientSensitivityLevel = class;           { "urn:v5.soap.webservices.clinicaldisplay.imaging.med.va.gov"[Lit][GblElm] }
  PatientSensitiveCheckWrapperResponseType2 = class;   { "urn:v5.soap.webservices.clinicaldisplay.imaging.med.va.gov"[Lit][GblElm] }
  GetPatientShallowStudyList = class;           { "urn:v5.soap.webservices.clinicaldisplay.imaging.med.va.gov"[Lit][GblElm] }
  ShallowStudiesResponseType2 = class;          { "urn:v5.soap.webservices.clinicaldisplay.imaging.med.va.gov"[Lit][GblElm] }
  GetStudyImageList    = class;                 { "urn:v5.soap.webservices.clinicaldisplay.imaging.med.va.gov"[Lit][GblElm] }
  PostImageAccessEvent = class;                 { "urn:v5.soap.webservices.clinicaldisplay.imaging.med.va.gov"[Lit][GblElm] }
  ImageAccessEventType2 = class;                { "urn:v5.soap.webservices.clinicaldisplay.imaging.med.va.gov"[Lit][GblElm] }
  PingServer           = class;                 { "urn:v5.soap.webservices.clinicaldisplay.imaging.med.va.gov"[Lit][GblElm] }
  PingServerType2      = class;                 { "urn:v5.soap.webservices.clinicaldisplay.imaging.med.va.gov"[Lit][GblElm] }
  PrefetchStudyList    = class;                 { "urn:v5.soap.webservices.clinicaldisplay.imaging.med.va.gov"[Lit][GblElm] }
  PrefetchResponseType2 = class;                { "urn:v5.soap.webservices.clinicaldisplay.imaging.med.va.gov"[Lit][GblElm] }
  GetImageInformation  = class;                 { "urn:v5.soap.webservices.clinicaldisplay.imaging.med.va.gov"[Lit][GblElm] }
  ImageInformationType2 = class;                { "urn:v5.soap.webservices.clinicaldisplay.imaging.med.va.gov"[Lit][GblElm] }
  GetImageSystemGlobalNode = class;             { "urn:v5.soap.webservices.clinicaldisplay.imaging.med.va.gov"[Lit][GblElm] }
  ImageSystemGlobalNodeType2 = class;           { "urn:v5.soap.webservices.clinicaldisplay.imaging.med.va.gov"[Lit][GblElm] }
  GetImageDevFields    = class;                 { "urn:v5.soap.webservices.clinicaldisplay.imaging.med.va.gov"[Lit][GblElm] }
  ImageDevFieldsType2  = class;                 { "urn:v5.soap.webservices.clinicaldisplay.imaging.med.va.gov"[Lit][GblElm] }
  getStudyReport       = class;                 { "urn:v5.soap.webservices.clinicaldisplay.imaging.med.va.gov"[Lit][GblElm] }
  StudyReportType2     = class;                 { "urn:v5.soap.webservices.clinicaldisplay.imaging.med.va.gov"[Lit][GblElm] }
  remoteMethodPassthrough = class;              { "urn:v5.soap.webservices.clinicaldisplay.imaging.med.va.gov"[Lit][GblElm] }
  RemoteMethodResponseType2 = class;            { "urn:v5.soap.webservices.clinicaldisplay.imaging.med.va.gov"[Lit][GblElm] }
  Image                = class;                 { "urn:v5.soap.webservices.clinicaldisplay.imaging.med.va.gov"[Alias] }
  Study                = class;                 { "urn:v5.soap.webservices.clinicaldisplay.imaging.med.va.gov"[Alias] }
  RemoteMethodParameterValueType = class;       { "urn:v5.soap.webservices.clinicaldisplay.imaging.med.va.gov"[GblCplx] }
  remoteMethodParameter = class;                { "urn:v5.soap.webservices.clinicaldisplay.imaging.med.va.gov"[Alias] }

  { "urn:v5.soap.webservices.clinicaldisplay.imaging.med.va.gov"[Smpl] }
  Origin = (UNSPECIFIED, VA, NON_VA, DOD, FEE);

  { "urn:v5.soap.webservices.clinicaldisplay.imaging.med.va.gov"[Smpl] }
  EventType = (IMAGE_ACCESS, IMAGE_COPY, IMAGE_PRINT, PATIENT_ID_MISMATCH, LOG_RESTRICTED_ACCESS);

  { "urn:v5.soap.webservices.clinicaldisplay.imaging.med.va.gov"[GblSmpl] }
  ShallowStudiesErrorType = (INSUFFICIENT_SENSITIVE_LEVEL, OTHER_ERROR);

  { "urn:v5.soap.webservices.clinicaldisplay.imaging.med.va.gov"[GblSmpl] }
  RemoteMethodParameterTypeType = (LIST, LITERAL, REFERENCE);

  { "urn:v5.soap.webservices.clinicaldisplay.imaging.med.va.gov"[Smpl] }
  PingResponse = (SERVER_READY, SERVER_UNAVAILABLE, VISTA_UNAVAILABLE);

  { "urn:v5.soap.webservices.clinicaldisplay.imaging.med.va.gov"[Smpl] }
  PrefetchResponse = (SUBMITTED);

  { "urn:v5.soap.webservices.clinicaldisplay.imaging.med.va.gov"[GblSmpl] }
  PatientSensitivityLevelType = (RPC_FAILURE, NO_ACTION_REQUIRED, DISPLAY_WARNING, DISPLAY_WARNING_REQUIRE_OK, DISPLAY_WARNING_CANNOT_CONTINUE, ACCESS_DENIED);

  DateType        =  type WideString;      { "urn:v5.soap.webservices.clinicaldisplay.imaging.med.va.gov"[GblSmpl] }


  // ************************************************************************ //
  // XML       : FilterType, global, <complexType>
  // Namespace : urn:v5.soap.webservices.clinicaldisplay.imaging.med.va.gov
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
    Forigin: Origin;
  published
    property package_:  WideString  Index (IS_NLBL) read Fpackage_ write Fpackage_;
    property class_:    WideString  Index (IS_NLBL) read Fclass_ write Fclass_;
    property types:     WideString  Index (IS_NLBL) read Ftypes write Ftypes;
    property event:     WideString  Index (IS_NLBL) read Fevent write Fevent;
    property specialty: WideString  Index (IS_NLBL) read Fspecialty write Fspecialty;
    property from_date: DateType    Index (IS_NLBL) read Ffrom_date write Ffrom_date;
    property to_date:   DateType    Index (IS_NLBL) read Fto_date write Fto_date;
    property origin:    Origin      Index (IS_NLBL) read Forigin write Forigin;
  end;



  // ************************************************************************ //
  // XML       : UserCredentials, global, <complexType>
  // Namespace : urn:v5.soap.webservices.clinicaldisplay.imaging.med.va.gov
  // ************************************************************************ //
  UserCredentials = class(TRemotable)
  private
    Ffullname: WideString;
    Fduz: WideString;
    Fssn: WideString;
    FsiteName: WideString;
    FsiteNumber: WideString;
    FsecurityToken: WideString;
  published
    property fullname:      WideString  read Ffullname write Ffullname;
    property duz:           WideString  Index (IS_NLBL) read Fduz write Fduz;
    property ssn:           WideString  Index (IS_NLBL) read Fssn write Fssn;
    property siteName:      WideString  read FsiteName write FsiteName;
    property siteNumber:    WideString  read FsiteNumber write FsiteNumber;
    property securityToken: WideString  Index (IS_NLBL) read FsecurityToken write FsecurityToken;
  end;



  // ************************************************************************ //
  // XML       : ImageAccessLogEventType, global, <complexType>
  // Namespace : urn:v5.soap.webservices.clinicaldisplay.imaging.med.va.gov
  // ************************************************************************ //
  ImageAccessLogEventType = class(TRemotable)
  private
    Fid: WideString;
    FpatientIcn: WideString;
    Freason: WideString;
    Fcredentials: UserCredentials;
    FeventType: EventType;
  public
    destructor Destroy; override;
  published
    property id:          WideString       read Fid write Fid;
    property patientIcn:  WideString       read FpatientIcn write FpatientIcn;
    property reason:      WideString       read Freason write Freason;
    property credentials: UserCredentials  read Fcredentials write Fcredentials;
    property eventType:   EventType        read FeventType write FeventType;
  end;



  // ************************************************************************ //
  // XML       : FatImageType, global, <complexType>
  // Namespace : urn:v5.soap.webservices.clinicaldisplay.imaging.med.va.gov
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
  published
    property image_id:              WideString  Index (IS_NLBL) read Fimage_id write Fimage_id;
    property description:           WideString  Index (IS_NLBL) read Fdescription write Fdescription;
    property procedure_date:        WideString  Index (IS_NLBL) read Fprocedure_date write Fprocedure_date;
    property procedure_:            WideString  Index (IS_NLBL) read Fprocedure_ write Fprocedure_;
    property dicom_sequence_number: WideString  Index (IS_NLBL) read Fdicom_sequence_number write Fdicom_sequence_number;
    property dicom_image_number:    WideString  Index (IS_NLBL) read Fdicom_image_number write Fdicom_image_number;
    property patient_icn:           WideString  Index (IS_NLBL) read Fpatient_icn write Fpatient_icn;
    property patient_name:          WideString  Index (IS_NLBL) read Fpatient_name write Fpatient_name;
    property site_number:           WideString  Index (IS_NLBL) read Fsite_number write Fsite_number;
    property site_abbr:             WideString  Index (IS_NLBL) read Fsite_abbr write Fsite_abbr;
    property image_type:            Int64       Index (IS_NLBL) read Fimage_type write Fimage_type;
    property abs_location:          WideString  Index (IS_NLBL) read Fabs_location write Fabs_location;
    property full_location:         WideString  Index (IS_NLBL) read Ffull_location write Ffull_location;
    property image_class:           WideString  Index (IS_NLBL) read Fimage_class write Fimage_class;
    property full_image_URI:        WideString  Index (IS_NLBL) read Ffull_image_URI write Ffull_image_URI;
    property abs_image_URI:         WideString  Index (IS_NLBL) read Fabs_image_URI write Fabs_image_URI;
    property big_image_URI:         WideString  Index (IS_NLBL) read Fbig_image_URI write Fbig_image_URI;
    property qaMessage:             WideString  Index (IS_NLBL) read FqaMessage write FqaMessage;
  end;

  FatImagesType = array of Image;               { "urn:v5.soap.webservices.clinicaldisplay.imaging.med.va.gov"[Lit][GblCplx] }


  // ************************************************************************ //
  // XML       : ShallowStudyType, global, <complexType>
  // Namespace : urn:v5.soap.webservices.clinicaldisplay.imaging.med.va.gov
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
  public
    destructor Destroy; override;
  published
    property study_id:          WideString    Index (IS_NLBL) read Fstudy_id write Fstudy_id;
    property description:       WideString    Index (IS_NLBL) read Fdescription write Fdescription;
    property procedure_date:    WideString    Index (IS_NLBL) read Fprocedure_date write Fprocedure_date;
    property procedure_:        WideString    Index (IS_NLBL) read Fprocedure_ write Fprocedure_;
    property patient_icn:       WideString    Index (IS_NLBL) read Fpatient_icn write Fpatient_icn;
    property patient_name:      WideString    Index (IS_NLBL) read Fpatient_name write Fpatient_name;
    property site_number:       WideString    Index (IS_NLBL) read Fsite_number write Fsite_number;
    property site_abbreviation: WideString    Index (IS_NLBL) read Fsite_abbreviation write Fsite_abbreviation;
    property image_count:       Int64         read Fimage_count write Fimage_count;
    property note_title:        WideString    Index (IS_NLBL) read Fnote_title write Fnote_title;
    property image_package:     WideString    Index (IS_NLBL) read Fimage_package write Fimage_package;
    property image_type:        WideString    Index (IS_NLBL) read Fimage_type write Fimage_type;
    property specialty:         WideString    Index (IS_NLBL) read Fspecialty write Fspecialty;
    property event:             WideString    Index (IS_NLBL) read Fevent write Fevent;
    property origin:            WideString    Index (IS_NLBL) read Forigin write Forigin;
    property study_package:     WideString    Index (IS_NLBL) read Fstudy_package write Fstudy_package;
    property study_class:       WideString    Index (IS_NLBL) read Fstudy_class write Fstudy_class;
    property study_type:        WideString    Index (IS_NLBL) read Fstudy_type write Fstudy_type;
    property capture_date:      DateType      Index (IS_NLBL) read Fcapture_date write Fcapture_date;
    property captured_by:       WideString    Index (IS_NLBL) read Fcaptured_by write Fcaptured_by;
    property first_image:       FatImageType  Index (IS_NLBL) read Ffirst_image write Ffirst_image;
    property rpcResponseMsg:    WideString    Index (IS_NLBL) read FrpcResponseMsg write FrpcResponseMsg;
  end;



  // ************************************************************************ //
  // XML       : ShallowStudiesErrorMessageType, global, <complexType>
  // Namespace : urn:v5.soap.webservices.clinicaldisplay.imaging.med.va.gov
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

  ShallowStudiesStudiesType = array of Study;   { "urn:v5.soap.webservices.clinicaldisplay.imaging.med.va.gov"[GblCplx] }


  // ************************************************************************ //
  // XML       : ShallowStudiesType, global, <complexType>
  // Namespace : urn:v5.soap.webservices.clinicaldisplay.imaging.med.va.gov
  // ************************************************************************ //
  ShallowStudiesType = class(TRemotable)
  private
    Fstudies: ShallowStudiesStudiesType;
    Fstudies_Specified: boolean;
    Ferror: ShallowStudiesErrorMessageType;
    Ferror_Specified: boolean;
    procedure Setstudies(Index: Integer; const AShallowStudiesStudiesType: ShallowStudiesStudiesType);
    function  studies_Specified(Index: Integer): boolean;
    procedure Seterror(Index: Integer; const AShallowStudiesErrorMessageType: ShallowStudiesErrorMessageType);
    function  error_Specified(Index: Integer): boolean;
  public
    destructor Destroy; override;
  published
    property studies: ShallowStudiesStudiesType       Index (IS_OPTN or IS_NLBL) read Fstudies write Setstudies stored studies_Specified;
    property error:   ShallowStudiesErrorMessageType  Index (IS_OPTN or IS_NLBL) read Ferror write Seterror stored error_Specified;
  end;



  // ************************************************************************ //
  // XML       : ShallowStudiesResponseType, global, <complexType>
  // Namespace : urn:v5.soap.webservices.clinicaldisplay.imaging.med.va.gov
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
  // Namespace : urn:v5.soap.webservices.clinicaldisplay.imaging.med.va.gov
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
  // Namespace : urn:v5.soap.webservices.clinicaldisplay.imaging.med.va.gov
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
  // Namespace : urn:v5.soap.webservices.clinicaldisplay.imaging.med.va.gov
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
  // Namespace : urn:v5.soap.webservices.clinicaldisplay.imaging.med.va.gov
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
  // Namespace : urn:v5.soap.webservices.clinicaldisplay.imaging.med.va.gov
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
  // Namespace : urn:v5.soap.webservices.clinicaldisplay.imaging.med.va.gov
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

  RemoteMethodInputParameterType = array of remoteMethodParameter;   { "urn:v5.soap.webservices.clinicaldisplay.imaging.med.va.gov"[GblCplx] }


  // ************************************************************************ //
  // XML       : RemoteMethodResponseType, global, <complexType>
  // Namespace : urn:v5.soap.webservices.clinicaldisplay.imaging.med.va.gov
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
  // Namespace : urn:v5.soap.webservices.clinicaldisplay.imaging.med.va.gov
  // Serializtn: [xoLiteralParam]
  // Info      : Wrapper
  // ************************************************************************ //
  PingServerType = class(TRemotable)
  private
    FpingResponse: PingResponse;
  public
    constructor Create; override;
  published
    property pingResponse: PingResponse  read FpingResponse write FpingResponse;
  end;



  // ************************************************************************ //
  // XML       : PrefetchResponseType, global, <complexType>
  // Namespace : urn:v5.soap.webservices.clinicaldisplay.imaging.med.va.gov
  // Serializtn: [xoLiteralParam]
  // Info      : Wrapper
  // ************************************************************************ //
  PrefetchResponseType = class(TRemotable)
  private
    FprefetchResponse: PrefetchResponse;
  public
    constructor Create; override;
  published
    property prefetchResponse: PrefetchResponse  read FprefetchResponse write FprefetchResponse;
  end;



  // ************************************************************************ //
  // XML       : PatientSensitiveCheckResponseType, global, <complexType>
  // Namespace : urn:v5.soap.webservices.clinicaldisplay.imaging.med.va.gov
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
  // Namespace : urn:v5.soap.webservices.clinicaldisplay.imaging.med.va.gov
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

  TransactionIdentifierType =  type WideString;      { "urn:v5.soap.webservices.clinicaldisplay.imaging.med.va.gov"[GblSmpl] }
  RemoteMethodNameType =  type WideString;      { "urn:v5.soap.webservices.clinicaldisplay.imaging.med.va.gov"[GblSmpl] }


  // ************************************************************************ //
  // XML       : getPatientSensitivityLevel, global, <element>
  // Namespace : urn:v5.soap.webservices.clinicaldisplay.imaging.med.va.gov
  // Serializtn: [xoLiteralParam]
  // Info      : Wrapper
  // ************************************************************************ //
  getPatientSensitivityLevel = class(TRemotable)
  private
    Ftransaction_id: TransactionIdentifierType;
    Fsite_id: WideString;
    Fpatient_id: WideString;
    Fcredentials: UserCredentials;
  public
    constructor Create; override;
    destructor Destroy; override;
  published
    property transaction_id: TransactionIdentifierType  read Ftransaction_id write Ftransaction_id;
    property site_id:        WideString                 read Fsite_id write Fsite_id;
    property patient_id:     WideString                 read Fpatient_id write Fpatient_id;
    property credentials:    UserCredentials            read Fcredentials write Fcredentials;
  end;



  // ************************************************************************ //
  // XML       : getPatientSensitivityLevelResponse, global, <element>
  // Namespace : urn:v5.soap.webservices.clinicaldisplay.imaging.med.va.gov
  // Info      : Wrapper
  // ************************************************************************ //
  PatientSensitiveCheckWrapperResponseType2 = class(PatientSensitiveCheckWrapperResponseType)
  private
  published
  end;



  // ************************************************************************ //
  // XML       : getPatientShallowStudyList, global, <element>
  // Namespace : urn:v5.soap.webservices.clinicaldisplay.imaging.med.va.gov
  // Serializtn: [xoLiteralParam]
  // Info      : Wrapper
  // ************************************************************************ //
  GetPatientShallowStudyList = class(TRemotable)
  private
    Ftransaction_id: TransactionIdentifierType;
    Fsite_id: WideString;
    Fpatient_id: WideString;
    Ffilter: FilterType;
    Fcredentials: UserCredentials;
    FauthorizedSensitivityLevel: Int64;
  public
    constructor Create; override;
    destructor Destroy; override;
  published
    property transaction_id:             TransactionIdentifierType  read Ftransaction_id write Ftransaction_id;
    property site_id:                    WideString                 read Fsite_id write Fsite_id;
    property patient_id:                 WideString                 read Fpatient_id write Fpatient_id;
    property filter:                     FilterType                 read Ffilter write Ffilter;
    property credentials:                UserCredentials            read Fcredentials write Fcredentials;
    property authorizedSensitivityLevel: Int64                      read FauthorizedSensitivityLevel write FauthorizedSensitivityLevel;
  end;



  // ************************************************************************ //
  // XML       : getPatientShallowStudyListResponse, global, <element>
  // Namespace : urn:v5.soap.webservices.clinicaldisplay.imaging.med.va.gov
  // Info      : Wrapper
  // ************************************************************************ //
  ShallowStudiesResponseType2 = class(ShallowStudiesResponseType)
  private
  published
  end;



  // ************************************************************************ //
  // XML       : getStudyImageList, global, <element>
  // Namespace : urn:v5.soap.webservices.clinicaldisplay.imaging.med.va.gov
  // Serializtn: [xoLiteralParam]
  // Info      : Wrapper
  // ************************************************************************ //
  GetStudyImageList = class(TRemotable)
  private
    Ftransaction_id: TransactionIdentifierType;
    Fstudy_id: WideString;
    Fcredentials: UserCredentials;
  public
    constructor Create; override;
    destructor Destroy; override;
  published
    property transaction_id: TransactionIdentifierType  read Ftransaction_id write Ftransaction_id;
    property study_id:       WideString                 read Fstudy_id write Fstudy_id;
    property credentials:    UserCredentials            read Fcredentials write Fcredentials;
  end;

  FatImagesType2  = FatImagesType;      { "urn:v5.soap.webservices.clinicaldisplay.imaging.med.va.gov"[Lit][GblElm] }


  // ************************************************************************ //
  // XML       : postImageAccessEvent, global, <element>
  // Namespace : urn:v5.soap.webservices.clinicaldisplay.imaging.med.va.gov
  // Serializtn: [xoLiteralParam]
  // Info      : Wrapper
  // ************************************************************************ //
  PostImageAccessEvent = class(TRemotable)
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
  // Namespace : urn:v5.soap.webservices.clinicaldisplay.imaging.med.va.gov
  // Info      : Wrapper
  // ************************************************************************ //
  ImageAccessEventType2 = class(ImageAccessEventType)
  private
  published
  end;



  // ************************************************************************ //
  // XML       : pingServer, global, <element>
  // Namespace : urn:v5.soap.webservices.clinicaldisplay.imaging.med.va.gov
  // Serializtn: [xoLiteralParam]
  // Info      : Wrapper
  // ************************************************************************ //
  PingServer = class(TRemotable)
  private
    Ftransaction_id: TransactionIdentifierType;
    FclientWorkstation: WideString;
    FrequestSiteNumber: WideString;
    Fcredentials: UserCredentials;
  public
    constructor Create; override;
    destructor Destroy; override;
  published
    property transaction_id:    TransactionIdentifierType  read Ftransaction_id write Ftransaction_id;
    property clientWorkstation: WideString                 read FclientWorkstation write FclientWorkstation;
    property requestSiteNumber: WideString                 read FrequestSiteNumber write FrequestSiteNumber;
    property credentials:       UserCredentials            read Fcredentials write Fcredentials;
  end;



  // ************************************************************************ //
  // XML       : postPingServerResponse, global, <element>
  // Namespace : urn:v5.soap.webservices.clinicaldisplay.imaging.med.va.gov
  // Info      : Wrapper
  // ************************************************************************ //
  PingServerType2 = class(PingServerType)
  private
  published
  end;



  // ************************************************************************ //
  // XML       : prefetchStudyList, global, <element>
  // Namespace : urn:v5.soap.webservices.clinicaldisplay.imaging.med.va.gov
  // Serializtn: [xoLiteralParam]
  // Info      : Wrapper
  // ************************************************************************ //
  PrefetchStudyList = class(TRemotable)
  private
    Ftransaction_id: TransactionIdentifierType;
    Fsite_id: WideString;
    Fpatient_id: WideString;
    Ffilter: FilterType;
    Fcredentials: UserCredentials;
  public
    constructor Create; override;
    destructor Destroy; override;
  published
    property transaction_id: TransactionIdentifierType  read Ftransaction_id write Ftransaction_id;
    property site_id:        WideString                 read Fsite_id write Fsite_id;
    property patient_id:     WideString                 read Fpatient_id write Fpatient_id;
    property filter:         FilterType                 read Ffilter write Ffilter;
    property credentials:    UserCredentials            read Fcredentials write Fcredentials;
  end;



  // ************************************************************************ //
  // XML       : PrefetchStudyListResponse, global, <element>
  // Namespace : urn:v5.soap.webservices.clinicaldisplay.imaging.med.va.gov
  // Info      : Wrapper
  // ************************************************************************ //
  PrefetchResponseType2 = class(PrefetchResponseType)
  private
  published
  end;



  // ************************************************************************ //
  // XML       : getImageInformation, global, <element>
  // Namespace : urn:v5.soap.webservices.clinicaldisplay.imaging.med.va.gov
  // Serializtn: [xoLiteralParam]
  // Info      : Wrapper
  // ************************************************************************ //
  GetImageInformation = class(TRemotable)
  private
    Fid: WideString;
    Ftransaction_id: TransactionIdentifierType;
    Fcredentials: UserCredentials;
  public
    constructor Create; override;
    destructor Destroy; override;
  published
    property id:             WideString                 read Fid write Fid;
    property transaction_id: TransactionIdentifierType  read Ftransaction_id write Ftransaction_id;
    property credentials:    UserCredentials            read Fcredentials write Fcredentials;
  end;



  // ************************************************************************ //
  // XML       : getImageInformationResponse, global, <element>
  // Namespace : urn:v5.soap.webservices.clinicaldisplay.imaging.med.va.gov
  // Info      : Wrapper
  // ************************************************************************ //
  ImageInformationType2 = class(ImageInformationType)
  private
  published
  end;



  // ************************************************************************ //
  // XML       : getImageSystemGlobalNode, global, <element>
  // Namespace : urn:v5.soap.webservices.clinicaldisplay.imaging.med.va.gov
  // Serializtn: [xoLiteralParam]
  // Info      : Wrapper
  // ************************************************************************ //
  GetImageSystemGlobalNode = class(TRemotable)
  private
    Fid: WideString;
    Ftransaction_id: TransactionIdentifierType;
    Fcredentials: UserCredentials;
  public
    constructor Create; override;
    destructor Destroy; override;
  published
    property id:             WideString                 read Fid write Fid;
    property transaction_id: TransactionIdentifierType  read Ftransaction_id write Ftransaction_id;
    property credentials:    UserCredentials            read Fcredentials write Fcredentials;
  end;



  // ************************************************************************ //
  // XML       : getImageSystemGlobalNodeResponse, global, <element>
  // Namespace : urn:v5.soap.webservices.clinicaldisplay.imaging.med.va.gov
  // Info      : Wrapper
  // ************************************************************************ //
  ImageSystemGlobalNodeType2 = class(ImageSystemGlobalNodeType)
  private
  published
  end;



  // ************************************************************************ //
  // XML       : getImageDevFields, global, <element>
  // Namespace : urn:v5.soap.webservices.clinicaldisplay.imaging.med.va.gov
  // Serializtn: [xoLiteralParam]
  // Info      : Wrapper
  // ************************************************************************ //
  GetImageDevFields = class(TRemotable)
  private
    Fid: WideString;
    Fflags: WideString;
    Ftransaction_id: TransactionIdentifierType;
    Fcredentials: UserCredentials;
  public
    constructor Create; override;
    destructor Destroy; override;
  published
    property id:             WideString                 read Fid write Fid;
    property flags:          WideString                 read Fflags write Fflags;
    property transaction_id: TransactionIdentifierType  read Ftransaction_id write Ftransaction_id;
    property credentials:    UserCredentials            read Fcredentials write Fcredentials;
  end;



  // ************************************************************************ //
  // XML       : getImageDevFieldsResponse, global, <element>
  // Namespace : urn:v5.soap.webservices.clinicaldisplay.imaging.med.va.gov
  // Info      : Wrapper
  // ************************************************************************ //
  ImageDevFieldsType2 = class(ImageDevFieldsType)
  private
  published
  end;



  // ************************************************************************ //
  // XML       : getStudyReport, global, <element>
  // Namespace : urn:v5.soap.webservices.clinicaldisplay.imaging.med.va.gov
  // Serializtn: [xoLiteralParam]
  // Info      : Wrapper
  // ************************************************************************ //
  getStudyReport = class(TRemotable)
  private
    Ftransaction_id: TransactionIdentifierType;
    Fcredentials: UserCredentials;
    Fstudy_id: WideString;
  public
    constructor Create; override;
    destructor Destroy; override;
  published
    property transaction_id: TransactionIdentifierType  read Ftransaction_id write Ftransaction_id;
    property credentials:    UserCredentials            read Fcredentials write Fcredentials;
    property study_id:       WideString                 read Fstudy_id write Fstudy_id;
  end;



  // ************************************************************************ //
  // XML       : getStudyReportResponse, global, <element>
  // Namespace : urn:v5.soap.webservices.clinicaldisplay.imaging.med.va.gov
  // Info      : Wrapper
  // ************************************************************************ //
  StudyReportType2 = class(StudyReportType)
  private
  published
  end;



  // ************************************************************************ //
  // XML       : remoteMethodPassthrough, global, <element>
  // Namespace : urn:v5.soap.webservices.clinicaldisplay.imaging.med.va.gov
  // Serializtn: [xoLiteralParam]
  // Info      : Wrapper
  // ************************************************************************ //
  remoteMethodPassthrough = class(TRemotable)
  private
    Ftransaction_id: TransactionIdentifierType;
    Fcredentials: UserCredentials;
    Fsite_id: WideString;
    FmethodName: RemoteMethodNameType;
    FinputParameters: RemoteMethodInputParameterType;
  public
    constructor Create; override;
    destructor Destroy; override;
  published
    property transaction_id:  TransactionIdentifierType       read Ftransaction_id write Ftransaction_id;
    property credentials:     UserCredentials                 read Fcredentials write Fcredentials;
    property site_id:         WideString                      read Fsite_id write Fsite_id;
    property methodName:      RemoteMethodNameType            read FmethodName write FmethodName;
    property inputParameters: RemoteMethodInputParameterType  read FinputParameters write FinputParameters;
  end;



  // ************************************************************************ //
  // XML       : remoteMethodPassthroughResponse, global, <element>
  // Namespace : urn:v5.soap.webservices.clinicaldisplay.imaging.med.va.gov
  // Info      : Wrapper
  // ************************************************************************ //
  RemoteMethodResponseType2 = class(RemoteMethodResponseType)
  private
  published
  end;



  // ************************************************************************ //
  // XML       : image, alias
  // Namespace : urn:v5.soap.webservices.clinicaldisplay.imaging.med.va.gov
  // ************************************************************************ //
  Image = class(FatImageType)
  private
  published
  end;



  // ************************************************************************ //
  // XML       : study, alias
  // Namespace : urn:v5.soap.webservices.clinicaldisplay.imaging.med.va.gov
  // ************************************************************************ //
  Study = class(ShallowStudyType)
  private
  published
  end;

  multipleValue   =  type WideString;      { "urn:v5.soap.webservices.clinicaldisplay.imaging.med.va.gov"[Alias] }
  RemoteMethodParameterMultipleType = array of multipleValue;   { "urn:v5.soap.webservices.clinicaldisplay.imaging.med.va.gov"[GblCplx] }


  // ************************************************************************ //
  // XML       : RemoteMethodParameterValueType, global, <complexType>
  // Namespace : urn:v5.soap.webservices.clinicaldisplay.imaging.med.va.gov
  // ************************************************************************ //
  RemoteMethodParameterValueType = class(TRemotable)
  private
    Fvalue: WideString;
    FmultipleValue: RemoteMethodParameterMultipleType;
    FmultipleValue_Specified: boolean;
    procedure SetmultipleValue(Index: Integer; const ARemoteMethodParameterMultipleType: RemoteMethodParameterMultipleType);
    function  multipleValue_Specified(Index: Integer): boolean;
  public
    destructor Destroy; override;
  published
    property value:         WideString                         read Fvalue write Fvalue;
    property multipleValue: RemoteMethodParameterMultipleType  Index (IS_OPTN or IS_NLBL) read FmultipleValue write SetmultipleValue stored multipleValue_Specified;
  end;



  // ************************************************************************ //
  // XML       : remoteMethodParameter, alias
  // Namespace : urn:v5.soap.webservices.clinicaldisplay.imaging.med.va.gov
  // ************************************************************************ //
  remoteMethodParameter = class(RemoteMethodParameterType)
  private
  published
  end;


  // ************************************************************************ //
  // Namespace : urn:v5.soap.webservices.clinicaldisplay.imaging.med.va.gov
  // soapAction: |getPatientShallowStudyList|getStudyImageList|postImageAccessEvent|pingServer|prefetchStudyList|getImageInformation|getImageSystemGlobalNode|getImageDevFields|getPatientSensitivityLevel|getStudyReport|remoteMethodPassthrough
  // transport : http://schemas.xmlsoap.org/soap/http
  // style     : document
  // binding   : ImageMetadataClinicalDisplaySoapBinding
  // service   : ImageMetadataClinicalDisplayService
  // port      : ImageMetadataClinicalDisplay.V5
  // URL       : http://localhost:8080/ImagingExchangeWebApp/webservices/ImageMetadataClinicalDisplay
  // ************************************************************************ //
  ImageClinicalDisplayMetadata = interface(IInvokable)
  ['{5AF72A3B-C909-B066-6803-0C3064D8E5ED}']
    function  getPatientShallowStudyList(const parameters: GetPatientShallowStudyList): ShallowStudiesResponseType2; stdcall;
    function  getStudyImageList(const parameters: GetStudyImageList): FatImagesType2; stdcall;
    function  postImageAccessEvent(const parameters: PostImageAccessEvent): ImageAccessEventType2; stdcall;

    // Cannot unwrap: 
    //     - Input element wrapper name does not match operation's name
    function  pingServerEvent(const parameters: PingServer): PingServerType2; stdcall;
    function  prefetchStudyList(const parameters: PrefetchStudyList): PrefetchResponseType2; stdcall;
    function  getImageInformation(const parameters: GetImageInformation): ImageInformationType2; stdcall;
    function  getImageSystemGlobalNode(const parameters: GetImageSystemGlobalNode): ImageSystemGlobalNodeType2; stdcall;
    function  getImageDevFields(const parameters: GetImageDevFields): ImageDevFieldsType2; stdcall;
    function  getPatientSensitivityLevel(const parameters: getPatientSensitivityLevel): PatientSensitiveCheckWrapperResponseType2; stdcall;
    function  getStudyReport(const parameters: getStudyReport): StudyReportType2; stdcall;
    function  remoteMethodPassthrough(const parameters: remoteMethodPassthrough): RemoteMethodResponseType2; stdcall;
  end;

function GetImageClinicalDisplayMetadata(UseWSDL: Boolean=System.False; Addr: string=''; HTTPRIO: THTTPRIO = nil): ImageClinicalDisplayMetadata;


implementation
  uses SysUtils;

function GetImageClinicalDisplayMetadata(UseWSDL: Boolean; Addr: string; HTTPRIO: THTTPRIO): ImageClinicalDisplayMetadata;
const
  defWSDL = 'C:\DevD2007\p106\Documents\WSDL\imagingClinicalDisplaySOAP_v5.wsdl';
  defURL  = 'http://localhost:8080/ImagingExchangeWebApp/webservices/ImageMetadataClinicalDisplay';
  defSvc  = 'ImageMetadataClinicalDisplayService';
  defPrt  = 'ImageMetadataClinicalDisplay.V5';
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
  FreeAndNil(Fstudies);
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

constructor GetPatientShallowStudyList.Create;
begin
  inherited Create;
  FSerializationOptions := [xoLiteralParam];
end;

destructor GetPatientShallowStudyList.Destroy;
begin
  FreeAndNil(Ffilter);
  FreeAndNil(Fcredentials);
  inherited Destroy;
end;

constructor GetStudyImageList.Create;
begin
  inherited Create;
  FSerializationOptions := [xoLiteralParam];
end;

destructor GetStudyImageList.Destroy;
begin
  FreeAndNil(Fcredentials);
  inherited Destroy;
end;

constructor PostImageAccessEvent.Create;
begin
  inherited Create;
  FSerializationOptions := [xoLiteralParam];
end;

destructor PostImageAccessEvent.Destroy;
begin
  FreeAndNil(Flog_event);
  inherited Destroy;
end;

constructor PingServer.Create;
begin
  inherited Create;
  FSerializationOptions := [xoLiteralParam];
end;

destructor PingServer.Destroy;
begin
  FreeAndNil(Fcredentials);
  inherited Destroy;
end;

constructor PrefetchStudyList.Create;
begin
  inherited Create;
  FSerializationOptions := [xoLiteralParam];
end;

destructor PrefetchStudyList.Destroy;
begin
  FreeAndNil(Ffilter);
  FreeAndNil(Fcredentials);
  inherited Destroy;
end;

constructor GetImageInformation.Create;
begin
  inherited Create;
  FSerializationOptions := [xoLiteralParam];
end;

destructor GetImageInformation.Destroy;
begin
  FreeAndNil(Fcredentials);
  inherited Destroy;
end;

constructor GetImageSystemGlobalNode.Create;
begin
  inherited Create;
  FSerializationOptions := [xoLiteralParam];
end;

destructor GetImageSystemGlobalNode.Destroy;
begin
  FreeAndNil(Fcredentials);
  inherited Destroy;
end;

constructor GetImageDevFields.Create;
begin
  inherited Create;
  FSerializationOptions := [xoLiteralParam];
end;

destructor GetImageDevFields.Destroy;
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
  FreeAndNil(FinputParameters);
  inherited Destroy;
end;

destructor RemoteMethodParameterValueType.Destroy;
begin
  FreeAndNil(FmultipleValue);
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

initialization
  InvRegistry.RegisterInterface(TypeInfo(ImageClinicalDisplayMetadata), 'urn:v5.soap.webservices.clinicaldisplay.imaging.med.va.gov', 'UTF-8');
  InvRegistry.RegisterAllSOAPActions(TypeInfo(ImageClinicalDisplayMetadata), '|getPatientShallowStudyList|getStudyImageList|postImageAccessEvent|pingServer|prefetchStudyList|getImageInformation|getImageSystemGlobalNode|getImageDevFields|getPatientSensitivityLevel|getStudyReport|remoteMethodPassthrough');
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
  RemClassRegistry.RegisterXSInfo(TypeInfo(DateType), 'urn:v5.soap.webservices.clinicaldisplay.imaging.med.va.gov', 'DateType');
  RemClassRegistry.RegisterXSInfo(TypeInfo(Origin), 'urn:v5.soap.webservices.clinicaldisplay.imaging.med.va.gov', 'Origin', 'origin');
  RemClassRegistry.RegisterExternalPropName(TypeInfo(Origin), 'NON_VA', 'NON-VA');
  RemClassRegistry.RegisterXSClass(FilterType, 'urn:v5.soap.webservices.clinicaldisplay.imaging.med.va.gov', 'FilterType');
  RemClassRegistry.RegisterExternalPropName(TypeInfo(FilterType), 'package_', 'package');
  RemClassRegistry.RegisterExternalPropName(TypeInfo(FilterType), 'class_', 'class');
  RemClassRegistry.RegisterExternalPropName(TypeInfo(FilterType), 'from_date', 'from-date');
  RemClassRegistry.RegisterExternalPropName(TypeInfo(FilterType), 'to_date', 'to-date');
  RemClassRegistry.RegisterXSClass(UserCredentials, 'urn:v5.soap.webservices.clinicaldisplay.imaging.med.va.gov', 'UserCredentials');
  RemClassRegistry.RegisterXSInfo(TypeInfo(EventType), 'urn:v5.soap.webservices.clinicaldisplay.imaging.med.va.gov', 'EventType', 'eventType');
  RemClassRegistry.RegisterXSClass(ImageAccessLogEventType, 'urn:v5.soap.webservices.clinicaldisplay.imaging.med.va.gov', 'ImageAccessLogEventType');
  RemClassRegistry.RegisterXSClass(FatImageType, 'urn:v5.soap.webservices.clinicaldisplay.imaging.med.va.gov', 'FatImageType');
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
  RemClassRegistry.RegisterXSInfo(TypeInfo(FatImagesType), 'urn:v5.soap.webservices.clinicaldisplay.imaging.med.va.gov', 'FatImagesType');
  RemClassRegistry.RegisterSerializeOptions(TypeInfo(FatImagesType), [xoLiteralParam]);
  RemClassRegistry.RegisterXSClass(ShallowStudyType, 'urn:v5.soap.webservices.clinicaldisplay.imaging.med.va.gov', 'ShallowStudyType');
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
  RemClassRegistry.RegisterXSInfo(TypeInfo(ShallowStudiesErrorType), 'urn:v5.soap.webservices.clinicaldisplay.imaging.med.va.gov', 'ShallowStudiesErrorType');
  RemClassRegistry.RegisterXSClass(ShallowStudiesErrorMessageType, 'urn:v5.soap.webservices.clinicaldisplay.imaging.med.va.gov', 'ShallowStudiesErrorMessageType');
  RemClassRegistry.RegisterXSInfo(TypeInfo(ShallowStudiesStudiesType), 'urn:v5.soap.webservices.clinicaldisplay.imaging.med.va.gov', 'ShallowStudiesStudiesType');
  RemClassRegistry.RegisterXSClass(ShallowStudiesType, 'urn:v5.soap.webservices.clinicaldisplay.imaging.med.va.gov', 'ShallowStudiesType');
  RemClassRegistry.RegisterXSClass(ShallowStudiesResponseType, 'urn:v5.soap.webservices.clinicaldisplay.imaging.med.va.gov', 'ShallowStudiesResponseType');
  RemClassRegistry.RegisterSerializeOptions(ShallowStudiesResponseType, [xoLiteralParam]);
  RemClassRegistry.RegisterXSClass(ImageAccessEventType, 'urn:v5.soap.webservices.clinicaldisplay.imaging.med.va.gov', 'ImageAccessEventType');
  RemClassRegistry.RegisterSerializeOptions(ImageAccessEventType, [xoLiteralParam]);
  RemClassRegistry.RegisterXSClass(ImageInformationType, 'urn:v5.soap.webservices.clinicaldisplay.imaging.med.va.gov', 'ImageInformationType');
  RemClassRegistry.RegisterSerializeOptions(ImageInformationType, [xoLiteralParam]);
  RemClassRegistry.RegisterXSClass(ImageSystemGlobalNodeType, 'urn:v5.soap.webservices.clinicaldisplay.imaging.med.va.gov', 'ImageSystemGlobalNodeType');
  RemClassRegistry.RegisterSerializeOptions(ImageSystemGlobalNodeType, [xoLiteralParam]);
  RemClassRegistry.RegisterXSClass(ImageDevFieldsType, 'urn:v5.soap.webservices.clinicaldisplay.imaging.med.va.gov', 'ImageDevFieldsType');
  RemClassRegistry.RegisterSerializeOptions(ImageDevFieldsType, [xoLiteralParam]);
  RemClassRegistry.RegisterXSClass(StudyReportType, 'urn:v5.soap.webservices.clinicaldisplay.imaging.med.va.gov', 'StudyReportType');
  RemClassRegistry.RegisterSerializeOptions(StudyReportType, [xoLiteralParam]);
  RemClassRegistry.RegisterXSInfo(TypeInfo(RemoteMethodParameterTypeType), 'urn:v5.soap.webservices.clinicaldisplay.imaging.med.va.gov', 'RemoteMethodParameterTypeType');
  RemClassRegistry.RegisterXSClass(RemoteMethodParameterType, 'urn:v5.soap.webservices.clinicaldisplay.imaging.med.va.gov', 'RemoteMethodParameterType');
  RemClassRegistry.RegisterXSInfo(TypeInfo(RemoteMethodInputParameterType), 'urn:v5.soap.webservices.clinicaldisplay.imaging.med.va.gov', 'RemoteMethodInputParameterType');
  RemClassRegistry.RegisterXSClass(RemoteMethodResponseType, 'urn:v5.soap.webservices.clinicaldisplay.imaging.med.va.gov', 'RemoteMethodResponseType');
  RemClassRegistry.RegisterSerializeOptions(RemoteMethodResponseType, [xoLiteralParam]);
  RemClassRegistry.RegisterXSInfo(TypeInfo(PingResponse), 'urn:v5.soap.webservices.clinicaldisplay.imaging.med.va.gov', 'PingResponse', 'pingResponse');
  RemClassRegistry.RegisterXSClass(PingServerType, 'urn:v5.soap.webservices.clinicaldisplay.imaging.med.va.gov', 'PingServerType');
  RemClassRegistry.RegisterSerializeOptions(PingServerType, [xoLiteralParam]);
  RemClassRegistry.RegisterXSInfo(TypeInfo(PrefetchResponse), 'urn:v5.soap.webservices.clinicaldisplay.imaging.med.va.gov', 'PrefetchResponse', 'prefetchResponse');
  RemClassRegistry.RegisterXSClass(PrefetchResponseType, 'urn:v5.soap.webservices.clinicaldisplay.imaging.med.va.gov', 'PrefetchResponseType');
  RemClassRegistry.RegisterSerializeOptions(PrefetchResponseType, [xoLiteralParam]);
  RemClassRegistry.RegisterXSInfo(TypeInfo(PatientSensitivityLevelType), 'urn:v5.soap.webservices.clinicaldisplay.imaging.med.va.gov', 'PatientSensitivityLevelType');
  RemClassRegistry.RegisterXSClass(PatientSensitiveCheckResponseType, 'urn:v5.soap.webservices.clinicaldisplay.imaging.med.va.gov', 'PatientSensitiveCheckResponseType');
  RemClassRegistry.RegisterXSClass(PatientSensitiveCheckWrapperResponseType, 'urn:v5.soap.webservices.clinicaldisplay.imaging.med.va.gov', 'PatientSensitiveCheckWrapperResponseType');
  RemClassRegistry.RegisterSerializeOptions(PatientSensitiveCheckWrapperResponseType, [xoLiteralParam]);
  RemClassRegistry.RegisterXSInfo(TypeInfo(TransactionIdentifierType), 'urn:v5.soap.webservices.clinicaldisplay.imaging.med.va.gov', 'TransactionIdentifierType');
  RemClassRegistry.RegisterXSInfo(TypeInfo(RemoteMethodNameType), 'urn:v5.soap.webservices.clinicaldisplay.imaging.med.va.gov', 'RemoteMethodNameType');
  RemClassRegistry.RegisterXSClass(getPatientSensitivityLevel, 'urn:v5.soap.webservices.clinicaldisplay.imaging.med.va.gov', 'getPatientSensitivityLevel');
  RemClassRegistry.RegisterExternalPropName(TypeInfo(getPatientSensitivityLevel), 'transaction_id', 'transaction-id');
  RemClassRegistry.RegisterExternalPropName(TypeInfo(getPatientSensitivityLevel), 'site_id', 'site-id');
  RemClassRegistry.RegisterExternalPropName(TypeInfo(getPatientSensitivityLevel), 'patient_id', 'patient-id');
  RemClassRegistry.RegisterSerializeOptions(getPatientSensitivityLevel, [xoLiteralParam]);
  RemClassRegistry.RegisterXSClass(PatientSensitiveCheckWrapperResponseType2, 'urn:v5.soap.webservices.clinicaldisplay.imaging.med.va.gov', 'PatientSensitiveCheckWrapperResponseType2', 'getPatientSensitivityLevelResponse');
  RemClassRegistry.RegisterXSClass(GetPatientShallowStudyList, 'urn:v5.soap.webservices.clinicaldisplay.imaging.med.va.gov', 'GetPatientShallowStudyList', 'getPatientShallowStudyList');
  RemClassRegistry.RegisterExternalPropName(TypeInfo(GetPatientShallowStudyList), 'transaction_id', 'transaction-id');
  RemClassRegistry.RegisterExternalPropName(TypeInfo(GetPatientShallowStudyList), 'site_id', 'site-id');
  RemClassRegistry.RegisterExternalPropName(TypeInfo(GetPatientShallowStudyList), 'patient_id', 'patient-id');
  RemClassRegistry.RegisterSerializeOptions(GetPatientShallowStudyList, [xoLiteralParam]);
  RemClassRegistry.RegisterXSClass(ShallowStudiesResponseType2, 'urn:v5.soap.webservices.clinicaldisplay.imaging.med.va.gov', 'ShallowStudiesResponseType2', 'getPatientShallowStudyListResponse');
  RemClassRegistry.RegisterXSClass(GetStudyImageList, 'urn:v5.soap.webservices.clinicaldisplay.imaging.med.va.gov', 'GetStudyImageList', 'getStudyImageList');
  RemClassRegistry.RegisterExternalPropName(TypeInfo(GetStudyImageList), 'transaction_id', 'transaction-id');
  RemClassRegistry.RegisterExternalPropName(TypeInfo(GetStudyImageList), 'study_id', 'study-id');
  RemClassRegistry.RegisterSerializeOptions(GetStudyImageList, [xoLiteralParam]);
  RemClassRegistry.RegisterXSInfo(TypeInfo(FatImagesType2), 'urn:v5.soap.webservices.clinicaldisplay.imaging.med.va.gov', 'FatImagesType2', 'getStudyImageListResponse');
  RemClassRegistry.RegisterXSClass(PostImageAccessEvent, 'urn:v5.soap.webservices.clinicaldisplay.imaging.med.va.gov', 'PostImageAccessEvent', 'postImageAccessEvent');
  RemClassRegistry.RegisterExternalPropName(TypeInfo(PostImageAccessEvent), 'transaction_id', 'transaction-id');
  RemClassRegistry.RegisterExternalPropName(TypeInfo(PostImageAccessEvent), 'log_event', 'log-event');
  RemClassRegistry.RegisterSerializeOptions(PostImageAccessEvent, [xoLiteralParam]);
  RemClassRegistry.RegisterXSClass(ImageAccessEventType2, 'urn:v5.soap.webservices.clinicaldisplay.imaging.med.va.gov', 'ImageAccessEventType2', 'postImageAccessEventResponse');
  RemClassRegistry.RegisterXSClass(PingServer, 'urn:v5.soap.webservices.clinicaldisplay.imaging.med.va.gov', 'PingServer', 'pingServer');
  RemClassRegistry.RegisterExternalPropName(TypeInfo(PingServer), 'transaction_id', 'transaction-id');
  RemClassRegistry.RegisterSerializeOptions(PingServer, [xoLiteralParam]);
  RemClassRegistry.RegisterXSClass(PingServerType2, 'urn:v5.soap.webservices.clinicaldisplay.imaging.med.va.gov', 'PingServerType2', 'postPingServerResponse');
  RemClassRegistry.RegisterXSClass(PrefetchStudyList, 'urn:v5.soap.webservices.clinicaldisplay.imaging.med.va.gov', 'PrefetchStudyList', 'prefetchStudyList');
  RemClassRegistry.RegisterExternalPropName(TypeInfo(PrefetchStudyList), 'transaction_id', 'transaction-id');
  RemClassRegistry.RegisterExternalPropName(TypeInfo(PrefetchStudyList), 'site_id', 'site-id');
  RemClassRegistry.RegisterExternalPropName(TypeInfo(PrefetchStudyList), 'patient_id', 'patient-id');
  RemClassRegistry.RegisterSerializeOptions(PrefetchStudyList, [xoLiteralParam]);
  RemClassRegistry.RegisterXSClass(PrefetchResponseType2, 'urn:v5.soap.webservices.clinicaldisplay.imaging.med.va.gov', 'PrefetchResponseType2', 'PrefetchStudyListResponse');
  RemClassRegistry.RegisterXSClass(GetImageInformation, 'urn:v5.soap.webservices.clinicaldisplay.imaging.med.va.gov', 'GetImageInformation', 'getImageInformation');
  RemClassRegistry.RegisterExternalPropName(TypeInfo(GetImageInformation), 'transaction_id', 'transaction-id');
  RemClassRegistry.RegisterSerializeOptions(GetImageInformation, [xoLiteralParam]);
  RemClassRegistry.RegisterXSClass(ImageInformationType2, 'urn:v5.soap.webservices.clinicaldisplay.imaging.med.va.gov', 'ImageInformationType2', 'getImageInformationResponse');
  RemClassRegistry.RegisterXSClass(GetImageSystemGlobalNode, 'urn:v5.soap.webservices.clinicaldisplay.imaging.med.va.gov', 'GetImageSystemGlobalNode', 'getImageSystemGlobalNode');
  RemClassRegistry.RegisterExternalPropName(TypeInfo(GetImageSystemGlobalNode), 'transaction_id', 'transaction-id');
  RemClassRegistry.RegisterSerializeOptions(GetImageSystemGlobalNode, [xoLiteralParam]);
  RemClassRegistry.RegisterXSClass(ImageSystemGlobalNodeType2, 'urn:v5.soap.webservices.clinicaldisplay.imaging.med.va.gov', 'ImageSystemGlobalNodeType2', 'getImageSystemGlobalNodeResponse');
  RemClassRegistry.RegisterXSClass(GetImageDevFields, 'urn:v5.soap.webservices.clinicaldisplay.imaging.med.va.gov', 'GetImageDevFields', 'getImageDevFields');
  RemClassRegistry.RegisterExternalPropName(TypeInfo(GetImageDevFields), 'transaction_id', 'transaction-id');
  RemClassRegistry.RegisterSerializeOptions(GetImageDevFields, [xoLiteralParam]);
  RemClassRegistry.RegisterXSClass(ImageDevFieldsType2, 'urn:v5.soap.webservices.clinicaldisplay.imaging.med.va.gov', 'ImageDevFieldsType2', 'getImageDevFieldsResponse');
  RemClassRegistry.RegisterXSClass(getStudyReport, 'urn:v5.soap.webservices.clinicaldisplay.imaging.med.va.gov', 'getStudyReport');
  RemClassRegistry.RegisterExternalPropName(TypeInfo(getStudyReport), 'transaction_id', 'transaction-id');
  RemClassRegistry.RegisterExternalPropName(TypeInfo(getStudyReport), 'study_id', 'study-id');
  RemClassRegistry.RegisterSerializeOptions(getStudyReport, [xoLiteralParam]);
  RemClassRegistry.RegisterXSClass(StudyReportType2, 'urn:v5.soap.webservices.clinicaldisplay.imaging.med.va.gov', 'StudyReportType2', 'getStudyReportResponse');
  RemClassRegistry.RegisterXSClass(remoteMethodPassthrough, 'urn:v5.soap.webservices.clinicaldisplay.imaging.med.va.gov', 'remoteMethodPassthrough');
  RemClassRegistry.RegisterExternalPropName(TypeInfo(remoteMethodPassthrough), 'transaction_id', 'transaction-id');
  RemClassRegistry.RegisterExternalPropName(TypeInfo(remoteMethodPassthrough), 'site_id', 'site-id');
  RemClassRegistry.RegisterSerializeOptions(remoteMethodPassthrough, [xoLiteralParam]);
  RemClassRegistry.RegisterXSClass(RemoteMethodResponseType2, 'urn:v5.soap.webservices.clinicaldisplay.imaging.med.va.gov', 'RemoteMethodResponseType2', 'remoteMethodPassthroughResponse');
  RemClassRegistry.RegisterXSClass(Image, 'urn:v5.soap.webservices.clinicaldisplay.imaging.med.va.gov', 'Image', 'image');
  RemClassRegistry.RegisterXSClass(Study, 'urn:v5.soap.webservices.clinicaldisplay.imaging.med.va.gov', 'Study', 'study');
  RemClassRegistry.RegisterXSInfo(TypeInfo(multipleValue), 'urn:v5.soap.webservices.clinicaldisplay.imaging.med.va.gov', 'multipleValue');
  RemClassRegistry.RegisterXSInfo(TypeInfo(RemoteMethodParameterMultipleType), 'urn:v5.soap.webservices.clinicaldisplay.imaging.med.va.gov', 'RemoteMethodParameterMultipleType');
  RemClassRegistry.RegisterXSClass(RemoteMethodParameterValueType, 'urn:v5.soap.webservices.clinicaldisplay.imaging.med.va.gov', 'RemoteMethodParameterValueType');
  RemClassRegistry.RegisterXSClass(remoteMethodParameter, 'urn:v5.soap.webservices.clinicaldisplay.imaging.med.va.gov', 'remoteMethodParameter');

end.