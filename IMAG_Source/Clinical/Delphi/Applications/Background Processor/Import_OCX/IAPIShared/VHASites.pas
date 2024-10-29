// ************************************************************************ //
// The types declared in this file were generated from data read from the
// WSDL File described below:
// WSDL     : C:\work\Remote Image View\VHASites.wsdl
// Encoding : utf-8
// Version  : 1.0
// (2/28/2005 10:18:08 AM - 1.33.2.5)
// ************************************************************************ //

Unit VHASites;

Interface

Uses
  InvokeRegistry,
  SOAPHTTPClient
  ;

//Uses Vetted 20090929:XSBuiltIns, Types

Type

  // ************************************************************************ //
  // The following types, referred to in the WSDL document are not being represented
  // in this file. They are either aliases[@] of other types represented or were referred
  // to but never[!] declared in the document. The types from the latter category
  // typically map to predefined/known XML or Borland types; however, they could also
  // indicate incorrect WSDL documents that failed to declare or import a schema type.
  // ************************************************************************ //
  // !:string          - "http://www.w3.org/2001/XMLSchema"
  // !:int             - "http://www.w3.org/2001/XMLSchema"

  FaultTO = Class; { "http://vistaweb.med.va.gov/WebServices/SiteService" }
  SiteTO = Class; { "http://vistaweb.med.va.gov/WebServices/SiteService" }
  RegionTO = Class; { "http://vistaweb.med.va.gov/WebServices/SiteService" }

  // ************************************************************************ //
  // Namespace : http://vistaweb.med.va.gov/WebServices/SiteService
  // ************************************************************************ //
  FaultTO = Class(TRemotable)
  Private
    Ftype_: WideString;
    Fmessage: WideString;
    Fsuggestion: WideString;
  Published
    Property Type_: WideString Read Ftype_ Write Ftype_;
    Property Message: WideString Read Fmessage Write Fmessage;
    Property Suggestion: WideString Read Fsuggestion Write Fsuggestion;
  End;

  // ************************************************************************ //
  // Namespace : http://vistaweb.med.va.gov/WebServices/SiteService
  // ************************************************************************ //
  SiteTO = Class(TRemotable)
  Private
    Fsitecode: WideString;
    Fname: WideString;
    FdisplayName: WideString;
    Fmoniker: WideString;
    FRegionId: WideString;
    Fhostname: WideString;
    Fport: Integer;
    Fstatus: WideString;
    FfaultTO: FaultTO;
  Public
    Destructor Destroy; Override;
  Published
    Property Sitecode: WideString Read Fsitecode Write Fsitecode;
    Property Name: WideString Read Fname Write Fname;
    Property DisplayName: WideString Read FdisplayName Write FdisplayName;
    Property Moniker: WideString Read Fmoniker Write Fmoniker;
    Property RegionId: WideString Read FRegionId Write FRegionId;
    Property Hostname: WideString Read Fhostname Write Fhostname;
    Property Port: Integer Read Fport Write Fport;
    Property Status: WideString Read Fstatus Write Fstatus;
    Property FaultTO: FaultTO Read FfaultTO Write FfaultTO;
  End;

  ArrayOfSiteTO = Array Of SiteTO; { "http://vistaweb.med.va.gov/WebServices/SiteService" }

  // ************************************************************************ //
  // Namespace : http://vistaweb.med.va.gov/WebServices/SiteService
  // ************************************************************************ //
  RegionTO = Class(TRemotable)
  Private
    Fname: WideString;
    FID: WideString;
    Fsites: ArrayOfSiteTO;
    FfaultTO: FaultTO;
  Public
    Destructor Destroy; Override;
  Published
    Property Name: WideString Read Fname Write Fname;
    Property ID: WideString Read FID Write FID;
    Property Sites: ArrayOfSiteTO Read Fsites Write Fsites;
    Property FaultTO: FaultTO Read FfaultTO Write FfaultTO;
  End;

  ArrayOfRegionTO = Array Of RegionTO; { "http://vistaweb.med.va.gov/WebServices/SiteService" }

  // ************************************************************************ //
  // Namespace : http://vistaweb.med.va.gov/WebServices/SiteService
  // soapAction: http://vistaweb.med.va.gov/WebServices/SiteService/%operationName%
  // transport : http://schemas.xmlsoap.org/soap/http
  // style     : document
  // binding   : SiteServiceSoap
  // service   : SiteService
  // port      : SiteServiceSoap
  // URL       : http://vhaanncard2/VistaWebSvcs/SiteService.asmx
  // ************************************************************************ //
  SiteServiceSoap = Interface(IInvokable)
    ['{68E048AF-5F18-7B7D-9992-2ED07FDA8122}']
    Function GetVHA: ArrayOfRegionTO; Stdcall;
    Function GetVISN(Const RegionId: WideString): RegionTO; Stdcall;
    Function GetSites(Const SiteIDs: WideString): ArrayOfSiteTO; Stdcall;
    Function GetSite(Const SiteID: WideString): SiteTO; Stdcall;
  End;

Function GetSiteServiceSoap(UseWSDL: Boolean = System.False; Addr: String = ''; HTTPRIO: THTTPRIO = Nil): SiteServiceSoap;

Implementation

Function GetSiteServiceSoap(UseWSDL: Boolean; Addr: String; HTTPRIO: THTTPRIO): SiteServiceSoap;
Const
  DefWSDL = 'C:\work\Remote Image View\VHASites.wsdl';
  DefURL = 'http://vhaann26607.v11.med.va.gov/VistaWebSvcs/SiteService.asmx';
  DefSvc = 'SiteService';
  DefPrt = 'SiteServiceSoap';
Var
  RIO: THTTPRIO;
Begin
  Result := Nil;
  If (Addr = '') Then
  Begin
    If UseWSDL Then
      Addr := DefWSDL
    Else
      Addr := DefURL;
  End;
  If HTTPRIO = Nil Then
    RIO := THTTPRIO.Create(Nil)
  Else
    RIO := HTTPRIO;
  Try
    Result := (RIO As SiteServiceSoap);
    If UseWSDL Then
    Begin
      RIO.WSDLLocation := Addr;
      RIO.Service := DefSvc;
      RIO.Port := DefPrt;
    End
    Else
      RIO.URL := Addr;
  Finally
    If (Result = Nil) And (HTTPRIO = Nil) Then
      RIO.Free;
  End;
End;

Destructor SiteTO.Destroy;
Begin
  If Assigned(FfaultTO) Then
    FfaultTO.Free;
  Inherited Destroy;
End;

Destructor RegionTO.Destroy;
Var
  i: Integer;
Begin
  For i := 0 To Length(Fsites) - 1 Do
    If Assigned(Fsites[i]) Then
      Fsites[i].Free;
  SetLength(Fsites, 0);
  If Assigned(FfaultTO) Then
    FfaultTO.Free;
  Inherited Destroy;
End;

Initialization
  InvRegistry.RegisterInterface(TypeInfo(SiteServiceSoap), 'http://vistaweb.med.va.gov/WebServices/SiteService', 'utf-8');
  InvRegistry.RegisterDefaultSOAPAction(TypeInfo(SiteServiceSoap), 'http://vistaweb.med.va.gov/WebServices/SiteService/%operationName%');
  InvRegistry.RegisterInvokeOptions(TypeInfo(SiteServiceSoap), IoDocument);
  RemClassRegistry.RegisterXSClass(FaultTO, 'http://vistaweb.med.va.gov/WebServices/SiteService', 'FaultTO');
  RemClassRegistry.RegisterExternalPropName(TypeInfo(FaultTO), 'type_', 'type');
  RemClassRegistry.RegisterXSClass(SiteTO, 'http://vistaweb.med.va.gov/WebServices/SiteService', 'SiteTO');
  RemClassRegistry.RegisterXSInfo(TypeInfo(ArrayOfSiteTO), 'http://vistaweb.med.va.gov/WebServices/SiteService', 'ArrayOfSiteTO');
  RemClassRegistry.RegisterXSClass(RegionTO, 'http://vistaweb.med.va.gov/WebServices/SiteService', 'RegionTO');
  RemClassRegistry.RegisterXSInfo(TypeInfo(ArrayOfRegionTO), 'http://vistaweb.med.va.gov/WebServices/SiteService', 'ArrayOfRegionTO');

End.
