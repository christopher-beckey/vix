unit AnnotationTool_TLB;

// ************************************************************************ //
// WARNING                                                                    
// -------                                                                    
// The types declared in this file were generated from data read from a       
// Type Library. If this type library is explicitly or indirectly (via        
// another type library referring to this type library) re-imported, or the   
// 'Refresh' command of the Type Library Editor activated while editing the   
// Type Library, the contents of this file will be regenerated and all        
// manual modifications will be lost.                                         
// ************************************************************************ //

// PASTLWTR : $Revision: 1 $
// File generated on 10/4/2003 12:09:41 AM from Type Library described below.

// *************************************************************************//
// NOTE:                                                                      
// Items guarded by $IFDEF_LIVE_SERVER_AT_DESIGN_TIME are used by properties  
// which return objects that may need to be explicitly created via a function 
// call prior to any access via the property. These items have been disabled  
// in order to prevent accidental use from within the object inspector. You   
// may enable them by defining LIVE_SERVER_AT_DESIGN_TIME or by selectively   
// removing them from the $IFDEF blocks. However, such items must still be    
// programmatically created via a method of the appropriate CoClass before    
// they can be used.                                                          
// ************************************************************************ //
// Type Lib: K:\Patch 8\Dev\P-Doc\Clin\Annotation OCX\Annotation editor for CPRS (1-10-03)\MagAnnTool.tlb (1)
// IID\LCID: {9040D81E-4F3C-4943-A3F6-835BAC46037A}\0
// Helpfile: 
// DepndLst: 
//   (1) v2.0 stdole, (D:\WINNT\System32\stdole2.tlb)
//   (2) v1.0 CPRSChart, (D:\Documents and Settings\Julian Werfel\Desktop\V22\CPRSChart.exe)
//   (3) v4.0 StdVCL, (D:\WINNT\System32\STDVCL40.DLL)
// ************************************************************************ //
{$TYPEDADDRESS OFF} // Unit must be compiled without type-checked pointers. 
interface

uses Windows, ActiveX, Classes, Graphics, OleServer, OleCtrls, StdVCL, 
  CPRSChart_TLB;

// *********************************************************************//
// GUIDS declared in the TypeLibrary. Following prefixes are used:        
//   Type Libraries     : LIBID_xxxx                                      
//   CoClasses          : CLASS_xxxx                                      
//   DISPInterfaces     : DIID_xxxx                                       
//   Non-DISP interfaces: IID_xxxx                                        
// *********************************************************************//
const
  // TypeLibrary Major and minor versions
  AnnotationToolMajorVersion = 1;
  AnnotationToolMinorVersion = 0;

  LIBID_AnnotationTool: TGUID = '{9040D81E-4F3C-4943-A3F6-835BAC46037A}';

  IID_IAnnotationPlugIn: TGUID = '{07D945BE-9C80-4F05-94D6-F4F15BF71269}';
  CLASS_AnnotationPlugIn: TGUID = '{9B6B82F4-14DF-493B-B7FE-2EF349F19167}';
type

// *********************************************************************//
// Forward declaration of types defined in TypeLibrary                    
// *********************************************************************//
  IAnnotationPlugIn = interface;
  IAnnotationPlugInDisp = dispinterface;

// *********************************************************************//
// Declaration of CoClasses defined in Type Library                       
// (NOTE: Here we map each CoClass to its Default Interface)              
// *********************************************************************//
  AnnotationPlugIn = IAnnotationPlugIn;


// *********************************************************************//
// Interface: IAnnotationPlugIn
// Flags:     (4416) Dual OleAutomation Dispatchable
// GUID:      {07D945BE-9C80-4F05-94D6-F4F15BF71269}
// *********************************************************************//
  IAnnotationPlugIn = interface(IDispatch)
    ['{07D945BE-9C80-4F05-94D6-F4F15BF71269}']
  end;

// *********************************************************************//
// DispIntf:  IAnnotationPlugInDisp
// Flags:     (4416) Dual OleAutomation Dispatchable
// GUID:      {07D945BE-9C80-4F05-94D6-F4F15BF71269}
// *********************************************************************//
  IAnnotationPlugInDisp = dispinterface
    ['{07D945BE-9C80-4F05-94D6-F4F15BF71269}']
  end;

// *********************************************************************//
// The Class CoAnnotationPlugIn provides a Create and CreateRemote method to          
// create instances of the default interface IAnnotationPlugIn exposed by              
// the CoClass AnnotationPlugIn. The functions are intended to be used by             
// clients wishing to automate the CoClass objects exposed by the         
// server of this typelibrary.                                            
// *********************************************************************//
  CoAnnotationPlugIn = class
    class function Create: IAnnotationPlugIn;
    class function CreateRemote(const MachineName: string): IAnnotationPlugIn;
  end;


// *********************************************************************//
// OLE Server Proxy class declaration
// Server Object    : TAnnotationPlugIn
// Help String      : AnnotationPlugIn Object
// Default Interface: IAnnotationPlugIn
// Def. Intf. DISP? : No
// Event   Interface: 
// TypeFlags        : (2) CanCreate
// *********************************************************************//
{$IFDEF LIVE_SERVER_AT_DESIGN_TIME}
  TAnnotationPlugInProperties= class;
{$ENDIF}
  TAnnotationPlugIn = class(TOleServer)
  private
    FIntf:        IAnnotationPlugIn;
{$IFDEF LIVE_SERVER_AT_DESIGN_TIME}
    FProps:       TAnnotationPlugInProperties;
    function      GetServerProperties: TAnnotationPlugInProperties;
{$ENDIF}
    function      GetDefaultInterface: IAnnotationPlugIn;
  protected
    procedure InitServerData; override;
  public
    constructor Create(AOwner: TComponent); override;
    destructor  Destroy; override;
    procedure Connect; override;
    procedure ConnectTo(svrIntf: IAnnotationPlugIn);
    procedure Disconnect; override;
    property  DefaultInterface: IAnnotationPlugIn read GetDefaultInterface;
  published
{$IFDEF LIVE_SERVER_AT_DESIGN_TIME}
    property Server: TAnnotationPlugInProperties read GetServerProperties;
{$ENDIF}
  end;

{$IFDEF LIVE_SERVER_AT_DESIGN_TIME}
// *********************************************************************//
// OLE Server Properties Proxy Class
// Server Object    : TAnnotationPlugIn
// (This object is used by the IDE's Property Inspector to allow editing
//  of the properties of this server)
// *********************************************************************//
 TAnnotationPlugInProperties = class(TPersistent)
  private
    FServer:    TAnnotationPlugIn;
    function    GetDefaultInterface: IAnnotationPlugIn;
    constructor Create(AServer: TAnnotationPlugIn);
  protected
  public
    property DefaultInterface: IAnnotationPlugIn read GetDefaultInterface;
  published
  end;
{$ENDIF}


procedure Register;

implementation

uses ComObj;

class function CoAnnotationPlugIn.Create: IAnnotationPlugIn;
begin
  Result := CreateComObject(CLASS_AnnotationPlugIn) as IAnnotationPlugIn;
end;

class function CoAnnotationPlugIn.CreateRemote(const MachineName: string): IAnnotationPlugIn;
begin
  Result := CreateRemoteComObject(MachineName, CLASS_AnnotationPlugIn) as IAnnotationPlugIn;
end;

procedure TAnnotationPlugIn.InitServerData;
const
  CServerData: TServerData = (
    ClassID:   '{9B6B82F4-14DF-493B-B7FE-2EF349F19167}';
    IntfIID:   '{07D945BE-9C80-4F05-94D6-F4F15BF71269}';
    EventIID:  '';
    LicenseKey: nil;
    Version: 500);
begin
  ServerData := @CServerData;
end;

procedure TAnnotationPlugIn.Connect;
var
  punk: IUnknown;
begin
  if FIntf = nil then
  begin
    punk := GetServer;
    Fintf:= punk as IAnnotationPlugIn;
  end;
end;

procedure TAnnotationPlugIn.ConnectTo(svrIntf: IAnnotationPlugIn);
begin
  Disconnect;
  FIntf := svrIntf;
end;

procedure TAnnotationPlugIn.DisConnect;
begin
  if Fintf <> nil then
  begin
    FIntf := nil;
  end;
end;

function TAnnotationPlugIn.GetDefaultInterface: IAnnotationPlugIn;
begin
  if FIntf = nil then
    Connect;
  Assert(FIntf <> nil, 'DefaultInterface is NULL. Component is not connected to Server. You must call ''Connect'' or ''ConnectTo'' before this operation');
  Result := FIntf;
end;

constructor TAnnotationPlugIn.Create(AOwner: TComponent);
begin
  inherited Create(AOwner);
{$IFDEF LIVE_SERVER_AT_DESIGN_TIME}
  FProps := TAnnotationPlugInProperties.Create(Self);
{$ENDIF}
end;

destructor TAnnotationPlugIn.Destroy;
begin
{$IFDEF LIVE_SERVER_AT_DESIGN_TIME}
  FProps.Free;
{$ENDIF}
  inherited Destroy;
end;

{$IFDEF LIVE_SERVER_AT_DESIGN_TIME}
function TAnnotationPlugIn.GetServerProperties: TAnnotationPlugInProperties;
begin
  Result := FProps;
end;
{$ENDIF}

{$IFDEF LIVE_SERVER_AT_DESIGN_TIME}
constructor TAnnotationPlugInProperties.Create(AServer: TAnnotationPlugIn);
begin
  inherited Create;
  FServer := AServer;
end;

function TAnnotationPlugInProperties.GetDefaultInterface: IAnnotationPlugIn;
begin
  Result := FServer.DefaultInterface;
end;

{$ENDIF}

procedure Register;
begin
  RegisterComponents('Servers',[TAnnotationPlugIn]);
end;

end.
