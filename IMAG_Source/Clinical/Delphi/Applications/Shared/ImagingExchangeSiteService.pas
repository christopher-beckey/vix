// ************************************************************************ //
// The types declared in this file were generated from data read from the
// WSDL File described below:
// WSDL     : C:\Documents and Settings\vhaiswmaleyr\Desktop\ImagingExchangeSiteService.wsdl
//  >Import : C:\Documents and Settings\vhaiswmaleyr\Desktop\ImagingExchangeSiteService.wsdl:0
// Encoding : utf-8
// Version  : 1.0
// (9/23/2010 9:45:06 AM - - $Rev: 7300 $)
// ************************************************************************ //

unit ImagingExchangeSiteService;

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
  // !:int             - "http://www.w3.org/2001/XMLSchema"[Gbl]

  ImagingExchangeRegionTO = class;              { "http://vistaweb.med.va.gov/webservices/ImagingExchangeSiteService"[GblCplx] }
  FaultTO              = class;                 { "http://vistaweb.med.va.gov/webservices/ImagingExchangeSiteService"[GblCplx] }
  ImagingExchangeSiteTO = class;                { "http://vistaweb.med.va.gov/webservices/ImagingExchangeSiteService"[GblCplx] }
  ImagingExchangeRegionTO2 = class;             { "http://vistaweb.med.va.gov/webservices/ImagingExchangeSiteService"[GblElm] }
  ImagingExchangeSiteTO2 = class;               { "http://vistaweb.med.va.gov/webservices/ImagingExchangeSiteService"[GblElm] }

  ArrayOfImagingExchangeSiteTO = array of ImagingExchangeSiteTO;   { "http://vistaweb.med.va.gov/webservices/ImagingExchangeSiteService"[GblCplx] }


  // ************************************************************************ //
  // XML       : ImagingExchangeRegionTO, global, <complexType>
  // Namespace : http://vistaweb.med.va.gov/webservices/ImagingExchangeSiteService
  // ************************************************************************ //
  ImagingExchangeRegionTO = class(TRemotable)
  private
    Fname_: WideString;
    Fname__Specified: boolean;
    FID: WideString;
    FID_Specified: boolean;
    Fsites: ArrayOfImagingExchangeSiteTO;
    Fsites_Specified: boolean;
    FfaultTO: FaultTO;
    FfaultTO_Specified: boolean;
    procedure Setname_(Index: Integer; const AWideString: WideString);
    function  name__Specified(Index: Integer): boolean;
    procedure SetID(Index: Integer; const AWideString: WideString);
    function  ID_Specified(Index: Integer): boolean;
    procedure Setsites(Index: Integer; const AArrayOfImagingExchangeSiteTO: ArrayOfImagingExchangeSiteTO);
    function  sites_Specified(Index: Integer): boolean;
    procedure SetfaultTO(Index: Integer; const AFaultTO: FaultTO);
    function  faultTO_Specified(Index: Integer): boolean;
  public
    destructor Destroy; override;
  published
    property name_:   WideString                    Index (IS_OPTN) read Fname_ write Setname_ stored name__Specified;
    property ID:      WideString                    Index (IS_OPTN) read FID write SetID stored ID_Specified;
    property sites:   ArrayOfImagingExchangeSiteTO  Index (IS_OPTN) read Fsites write Setsites stored sites_Specified;
    property faultTO: FaultTO                       Index (IS_OPTN) read FfaultTO write SetfaultTO stored faultTO_Specified;
  end;



  // ************************************************************************ //
  // XML       : FaultTO, global, <complexType>
  // Namespace : http://vistaweb.med.va.gov/webservices/ImagingExchangeSiteService
  // ************************************************************************ //
  FaultTO = class(TRemotable)
  private
    Ftype_: WideString;
    Ftype__Specified: boolean;
    Fmessage_: WideString;
    Fmessage__Specified: boolean;
    FstackTrace: WideString;
    FstackTrace_Specified: boolean;
    Fsuggestion: WideString;
    Fsuggestion_Specified: boolean;
    procedure Settype_(Index: Integer; const AWideString: WideString);
    function  type__Specified(Index: Integer): boolean;
    procedure Setmessage_(Index: Integer; const AWideString: WideString);
    function  message__Specified(Index: Integer): boolean;
    procedure SetstackTrace(Index: Integer; const AWideString: WideString);
    function  stackTrace_Specified(Index: Integer): boolean;
    procedure Setsuggestion(Index: Integer; const AWideString: WideString);
    function  suggestion_Specified(Index: Integer): boolean;
  published
    property type_:      WideString  Index (IS_OPTN) read Ftype_ write Settype_ stored type__Specified;
    property message_:   WideString  Index (IS_OPTN) read Fmessage_ write Setmessage_ stored message__Specified;
    property stackTrace: WideString  Index (IS_OPTN) read FstackTrace write SetstackTrace stored stackTrace_Specified;
    property suggestion: WideString  Index (IS_OPTN) read Fsuggestion write Setsuggestion stored suggestion_Specified;
  end;



  // ************************************************************************ //
  // XML       : ImagingExchangeSiteTO, global, <complexType>
  // Namespace : http://vistaweb.med.va.gov/webservices/ImagingExchangeSiteService
  // ************************************************************************ //
  ImagingExchangeSiteTO = class(TRemotable)
  private
    FsiteNumber: WideString;
    FsiteNumber_Specified: boolean;
    FsiteName: WideString;
    FsiteName_Specified: boolean;
    FregionID: WideString;
    FregionID_Specified: boolean;
    FsiteAbbr: WideString;
    FsiteAbbr_Specified: boolean;
    FvistaServer: WideString;
    FvistaServer_Specified: boolean;
    FvistaPort: Integer;
    FacceleratorServer: WideString;
    FacceleratorServer_Specified: boolean;
    FacceleratorPort: Integer;
    FfaultTO: FaultTO;
    FfaultTO_Specified: boolean;
    procedure SetsiteNumber(Index: Integer; const AWideString: WideString);
    function  siteNumber_Specified(Index: Integer): boolean;
    procedure SetsiteName(Index: Integer; const AWideString: WideString);
    function  siteName_Specified(Index: Integer): boolean;
    procedure SetregionID(Index: Integer; const AWideString: WideString);
    function  regionID_Specified(Index: Integer): boolean;
    procedure SetsiteAbbr(Index: Integer; const AWideString: WideString);
    function  siteAbbr_Specified(Index: Integer): boolean;
    procedure SetvistaServer(Index: Integer; const AWideString: WideString);
    function  vistaServer_Specified(Index: Integer): boolean;
    procedure SetacceleratorServer(Index: Integer; const AWideString: WideString);
    function  acceleratorServer_Specified(Index: Integer): boolean;
    procedure SetfaultTO(Index: Integer; const AFaultTO: FaultTO);
    function  faultTO_Specified(Index: Integer): boolean;
  public
    destructor Destroy; override;
  published
    property siteNumber:        WideString  Index (IS_OPTN) read FsiteNumber write SetsiteNumber stored siteNumber_Specified;
    property siteName:          WideString  Index (IS_OPTN) read FsiteName write SetsiteName stored siteName_Specified;
    property regionID:          WideString  Index (IS_OPTN) read FregionID write SetregionID stored regionID_Specified;
    property siteAbbr:          WideString  Index (IS_OPTN) read FsiteAbbr write SetsiteAbbr stored siteAbbr_Specified;
    property vistaServer:       WideString  Index (IS_OPTN) read FvistaServer write SetvistaServer stored vistaServer_Specified;
    property vistaPort:         Integer     read FvistaPort write FvistaPort;
    property acceleratorServer: WideString  Index (IS_OPTN) read FacceleratorServer write SetacceleratorServer stored acceleratorServer_Specified;
    property acceleratorPort:   Integer     read FacceleratorPort write FacceleratorPort;
    property faultTO:           FaultTO     Index (IS_OPTN) read FfaultTO write SetfaultTO stored faultTO_Specified;
  end;



  // ************************************************************************ //
  // XML       : ImagingExchangeRegionTO, global, <element>
  // Namespace : http://vistaweb.med.va.gov/webservices/ImagingExchangeSiteService
  // ************************************************************************ //
  ImagingExchangeRegionTO2 = class(ImagingExchangeRegionTO)
  private
  published
  end;



  // ************************************************************************ //
  // XML       : ImagingExchangeSiteTO, global, <element>
  // Namespace : http://vistaweb.med.va.gov/webservices/ImagingExchangeSiteService
  // ************************************************************************ //
  ImagingExchangeSiteTO2 = class(ImagingExchangeSiteTO)
  private
  published
  end;


  // ************************************************************************ //
  // Namespace : http://vistaweb.med.va.gov/webservices/ImagingExchangeSiteService
  // soapAction: http://vistaweb.med.va.gov/webservices/ImagingExchangeSiteService/%operationName%
  // transport : http://schemas.xmlsoap.org/soap/http
  // style     : document
  // binding   : ImagingExchangeSiteServiceSoap
  // service   : ImagingExchangeSiteService
  // port      : ImagingExchangeSiteServiceSoap
  // URL       : http://localhost/VistaWebSvcs/ImagingExchangeSiteService.asmx
  // ************************************************************************ //
  ImagingExchangeSiteServiceSoap = interface(IInvokable)
  ['{447CCBE6-6E47-A739-27B2-2A5BBC47893F}']
    function  getVISN(const regionID: WideString): ImagingExchangeRegionTO; stdcall;
    function  getSites(const siteIDs: WideString): ArrayOfImagingExchangeSiteTO; stdcall;
    function  getSite(const siteID: WideString): ImagingExchangeSiteTO; stdcall;
    function  getImagingExchangeSites: ArrayOfImagingExchangeSiteTO; stdcall;
  end;

function GetImagingExchangeSiteServiceSoap(UseWSDL: Boolean=System.False; Addr: string=''; HTTPRIO: THTTPRIO = nil): ImagingExchangeSiteServiceSoap;


implementation
  uses SysUtils;

function GetImagingExchangeSiteServiceSoap(UseWSDL: Boolean; Addr: string; HTTPRIO: THTTPRIO): ImagingExchangeSiteServiceSoap;
const
//  defWSDL = 'C:\Documents and Settings\vhaiswmaleyr\Desktop\ImagingExchangeSiteService.wsdl';
//  defURL  = 'http://localhost/VistaWebSvcs/ImagingExchangeSiteService.asmx';
  defSvc  = 'ImagingExchangeSiteService';
  defPrt  = 'ImagingExchangeSiteServiceSoap';
var
  RIO: THTTPRIO;
begin
  Result := nil;
  if (Addr = '') then
  begin
    Exit;
  end;
  if HTTPRIO = nil then
    RIO := THTTPRIO.Create(nil)
  else
    RIO := HTTPRIO;
  try
    Result := (RIO as ImagingExchangeSiteServiceSoap);
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


destructor ImagingExchangeRegionTO.Destroy;
var
  I: Integer;
begin
  for I := 0 to Length(Fsites)-1 do
    FreeAndNil(Fsites[I]);
  SetLength(Fsites, 0);
  FreeAndNil(FfaultTO);
  inherited Destroy;
end;

procedure ImagingExchangeRegionTO.Setname_(Index: Integer; const AWideString: WideString);
begin
  Fname_ := AWideString;
  Fname__Specified := True;
end;

function ImagingExchangeRegionTO.name__Specified(Index: Integer): boolean;
begin
  Result := Fname__Specified;
end;

procedure ImagingExchangeRegionTO.SetID(Index: Integer; const AWideString: WideString);
begin
  FID := AWideString;
  FID_Specified := True;
end;

function ImagingExchangeRegionTO.ID_Specified(Index: Integer): boolean;
begin
  Result := FID_Specified;
end;

procedure ImagingExchangeRegionTO.Setsites(Index: Integer; const AArrayOfImagingExchangeSiteTO: ArrayOfImagingExchangeSiteTO);
begin
  Fsites := AArrayOfImagingExchangeSiteTO;
  Fsites_Specified := True;
end;

function ImagingExchangeRegionTO.sites_Specified(Index: Integer): boolean;
begin
  Result := Fsites_Specified;
end;

procedure ImagingExchangeRegionTO.SetfaultTO(Index: Integer; const AFaultTO: FaultTO);
begin
  FfaultTO := AFaultTO;
  FfaultTO_Specified := True;
end;

function ImagingExchangeRegionTO.faultTO_Specified(Index: Integer): boolean;
begin
  Result := FfaultTO_Specified;
end;

procedure FaultTO.Settype_(Index: Integer; const AWideString: WideString);
begin
  Ftype_ := AWideString;
  Ftype__Specified := True;
end;

function FaultTO.type__Specified(Index: Integer): boolean;
begin
  Result := Ftype__Specified;
end;

procedure FaultTO.Setmessage_(Index: Integer; const AWideString: WideString);
begin
  Fmessage_ := AWideString;
  Fmessage__Specified := True;
end;

function FaultTO.message__Specified(Index: Integer): boolean;
begin
  Result := Fmessage__Specified;
end;

procedure FaultTO.SetstackTrace(Index: Integer; const AWideString: WideString);
begin
  FstackTrace := AWideString;
  FstackTrace_Specified := True;
end;

function FaultTO.stackTrace_Specified(Index: Integer): boolean;
begin
  Result := FstackTrace_Specified;
end;

procedure FaultTO.Setsuggestion(Index: Integer; const AWideString: WideString);
begin
  Fsuggestion := AWideString;
  Fsuggestion_Specified := True;
end;

function FaultTO.suggestion_Specified(Index: Integer): boolean;
begin
  Result := Fsuggestion_Specified;
end;

destructor ImagingExchangeSiteTO.Destroy;
begin
  FreeAndNil(FfaultTO);
  inherited Destroy;
end;

procedure ImagingExchangeSiteTO.SetsiteNumber(Index: Integer; const AWideString: WideString);
begin
  FsiteNumber := AWideString;
  FsiteNumber_Specified := True;
end;

function ImagingExchangeSiteTO.siteNumber_Specified(Index: Integer): boolean;
begin
  Result := FsiteNumber_Specified;
end;

procedure ImagingExchangeSiteTO.SetsiteName(Index: Integer; const AWideString: WideString);
begin
  FsiteName := AWideString;
  FsiteName_Specified := True;
end;

function ImagingExchangeSiteTO.siteName_Specified(Index: Integer): boolean;
begin
  Result := FsiteName_Specified;
end;

procedure ImagingExchangeSiteTO.SetregionID(Index: Integer; const AWideString: WideString);
begin
  FregionID := AWideString;
  FregionID_Specified := True;
end;

function ImagingExchangeSiteTO.regionID_Specified(Index: Integer): boolean;
begin
  Result := FregionID_Specified;
end;

procedure ImagingExchangeSiteTO.SetsiteAbbr(Index: Integer; const AWideString: WideString);
begin
  FsiteAbbr := AWideString;
  FsiteAbbr_Specified := True;
end;

function ImagingExchangeSiteTO.siteAbbr_Specified(Index: Integer): boolean;
begin
  Result := FsiteAbbr_Specified;
end;

procedure ImagingExchangeSiteTO.SetvistaServer(Index: Integer; const AWideString: WideString);
begin
  FvistaServer := AWideString;
  FvistaServer_Specified := True;
end;

function ImagingExchangeSiteTO.vistaServer_Specified(Index: Integer): boolean;
begin
  Result := FvistaServer_Specified;
end;

procedure ImagingExchangeSiteTO.SetacceleratorServer(Index: Integer; const AWideString: WideString);
begin
  FacceleratorServer := AWideString;
  FacceleratorServer_Specified := True;
end;

function ImagingExchangeSiteTO.acceleratorServer_Specified(Index: Integer): boolean;
begin
  Result := FacceleratorServer_Specified;
end;

procedure ImagingExchangeSiteTO.SetfaultTO(Index: Integer; const AFaultTO: FaultTO);
begin
  FfaultTO := AFaultTO;
  FfaultTO_Specified := True;
end;

function ImagingExchangeSiteTO.faultTO_Specified(Index: Integer): boolean;
begin
  Result := FfaultTO_Specified;
end;

initialization
  InvRegistry.RegisterInterface(TypeInfo(ImagingExchangeSiteServiceSoap), 'http://vistaweb.med.va.gov/webservices/ImagingExchangeSiteService', 'utf-8');
  InvRegistry.RegisterDefaultSOAPAction(TypeInfo(ImagingExchangeSiteServiceSoap), 'http://vistaweb.med.va.gov/webservices/ImagingExchangeSiteService/%operationName%');
  InvRegistry.RegisterInvokeOptions(TypeInfo(ImagingExchangeSiteServiceSoap), ioDocument);
  RemClassRegistry.RegisterXSInfo(TypeInfo(ArrayOfImagingExchangeSiteTO), 'http://vistaweb.med.va.gov/webservices/ImagingExchangeSiteService', 'ArrayOfImagingExchangeSiteTO');
  RemClassRegistry.RegisterXSClass(ImagingExchangeRegionTO, 'http://vistaweb.med.va.gov/webservices/ImagingExchangeSiteService', 'ImagingExchangeRegionTO');
  RemClassRegistry.RegisterExternalPropName(TypeInfo(ImagingExchangeRegionTO), 'name_', 'name');
  RemClassRegistry.RegisterXSClass(FaultTO, 'http://vistaweb.med.va.gov/webservices/ImagingExchangeSiteService', 'FaultTO');
  RemClassRegistry.RegisterExternalPropName(TypeInfo(FaultTO), 'type_', 'type');
  RemClassRegistry.RegisterExternalPropName(TypeInfo(FaultTO), 'message_', 'message');
  RemClassRegistry.RegisterXSClass(ImagingExchangeSiteTO, 'http://vistaweb.med.va.gov/webservices/ImagingExchangeSiteService', 'ImagingExchangeSiteTO');
  RemClassRegistry.RegisterXSClass(ImagingExchangeRegionTO2, 'http://vistaweb.med.va.gov/webservices/ImagingExchangeSiteService', 'ImagingExchangeRegionTO2', 'ImagingExchangeRegionTO');
  RemClassRegistry.RegisterXSClass(ImagingExchangeSiteTO2, 'http://vistaweb.med.va.gov/webservices/ImagingExchangeSiteService', 'ImagingExchangeSiteTO2', 'ImagingExchangeSiteTO');

end.