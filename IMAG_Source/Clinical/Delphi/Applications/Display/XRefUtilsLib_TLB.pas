unit XRefUtilsLib_TLB;

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

// $Rev: 8291 $
// File generated on 4/19/2013 8:24:13 AM from Type Library described below.

// ************************************************************************  //
// Type Lib: C:\devd2007\P131\XRefUtils.dll (1)
// LIBID: {E95A13F4-63AC-4C9F-9393-B00E3ED6D7E4}
// LCID: 0
// Helpfile: 
// HelpString: 
// DepndLst: 
//   (1) v2.0 stdole, (C:\WINDOWS\System32\stdole2.tlb)
// Errors:
//   Error creating palette bitmap of (TRadiologyImage) : Server C:\devd2007\P131\XRefUtils.dll contains no icons
//   Error creating palette bitmap of (TXRefLUT) : Server C:\devd2007\P131\XRefUtils.dll contains no icons
// ************************************************************************ //
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
{$TYPEDADDRESS OFF} // Unit must be compiled without type-checked pointers. 
{$WARN SYMBOL_PLATFORM OFF}
{$WRITEABLECONST ON}
{$VARPROPSETTER ON}
interface

uses Windows, ActiveX, Classes, Graphics, OleServer, StdVCL, Variants;
  

// *********************************************************************//
// GUIDS declared in the TypeLibrary. Following prefixes are used:        
//   Type Libraries     : LIBID_xxxx                                      
//   CoClasses          : CLASS_xxxx                                      
//   DISPInterfaces     : DIID_xxxx                                       
//   Non-DISP interfaces: IID_xxxx                                        
// *********************************************************************//
const
  // TypeLibrary Major and minor versions
  XRefUtilsLibMajorVersion = 1;
  XRefUtilsLibMinorVersion = 0;

  LIBID_XRefUtilsLib: TGUID = '{E95A13F4-63AC-4C9F-9393-B00E3ED6D7E4}';

  IID_IRadiologyImage: TGUID = '{CB9438F3-33C1-4322-8D80-CDB42F223670}';
  CLASS_RadiologyImage: TGUID = '{A09B8B23-BD28-42D5-8756-E04EFAC128BB}';
  IID_IXRefLUT: TGUID = '{89F140FF-44F0-45D1-83A5-6A99896697E9}';
  CLASS_XRefLUT: TGUID = '{425DCE0C-58C7-4DC7-AE25-41A16AB96595}';
type

// *********************************************************************//
// Forward declaration of types defined in TypeLibrary                    
// *********************************************************************//
  IRadiologyImage = interface;
  IRadiologyImageDisp = dispinterface;
  IXRefLUT = interface;
  IXRefLUTDisp = dispinterface;

// *********************************************************************//
// Declaration of CoClasses defined in Type Library                       
// (NOTE: Here we map each CoClass to its Default Interface)              
// *********************************************************************//
  RadiologyImage = IRadiologyImage;
  XRefLUT = IXRefLUT;


// *********************************************************************//
// Interface: IRadiologyImage
// Flags:     (4544) Dual NonExtensible OleAutomation Dispatchable
// GUID:      {CB9438F3-33C1-4322-8D80-CDB42F223670}
// *********************************************************************//
  IRadiologyImage = interface(IDispatch)
    ['{CB9438F3-33C1-4322-8D80-CDB42F223670}']
    function Get_ProjectionIndex: Smallint; safecall;
    procedure Set_ProjectionIndex(pVal: Smallint); safecall;
    function Get_TagValue(group: Integer; element: Integer): WideString; safecall;
    procedure Set_TagValue(group: Integer; element: Integer; const pVal: WideString); safecall;
    function Get_UserData: OleVariant; safecall;
    procedure Set_UserData(pVal: OleVariant); safecall;
    procedure SetTag(group: Integer; element: Integer; const newValue: WideString); safecall;
    property ProjectionIndex: Smallint read Get_ProjectionIndex write Set_ProjectionIndex;
    property TagValue[group: Integer; element: Integer]: WideString read Get_TagValue write Set_TagValue;
    property UserData: OleVariant read Get_UserData write Set_UserData;
  end;

// *********************************************************************//
// DispIntf:  IRadiologyImageDisp
// Flags:     (4544) Dual NonExtensible OleAutomation Dispatchable
// GUID:      {CB9438F3-33C1-4322-8D80-CDB42F223670}
// *********************************************************************//
  IRadiologyImageDisp = dispinterface
    ['{CB9438F3-33C1-4322-8D80-CDB42F223670}']
    property ProjectionIndex: Smallint dispid 1;
    property TagValue[group: Integer; element: Integer]: WideString dispid 2;
    property UserData: OleVariant dispid 3;
    procedure SetTag(group: Integer; element: Integer; const newValue: WideString); dispid 4;
  end;

// *********************************************************************//
// Interface: IXRefLUT
// Flags:     (4544) Dual NonExtensible OleAutomation Dispatchable
// GUID:      {89F140FF-44F0-45D1-83A5-6A99896697E9}
// *********************************************************************//
  IXRefLUT = interface(IDispatch)
    ['{89F140FF-44F0-45D1-83A5-6A99896697E9}']
    procedure GetXRefLine(const image1: IRadiologyImage; const image2: IRadiologyImage; 
                          var success: Integer; var planeId: Integer; var line: OleVariant); safecall;
    procedure GetNearestImage(const image: IRadiologyImage; images: OleVariant; posX: Integer; 
                              posY: Integer; var nearestImage: IRadiologyImage); safecall;
    procedure RegisterImage(const image: IRadiologyImage); safecall;
  end;

// *********************************************************************//
// DispIntf:  IXRefLUTDisp
// Flags:     (4544) Dual NonExtensible OleAutomation Dispatchable
// GUID:      {89F140FF-44F0-45D1-83A5-6A99896697E9}
// *********************************************************************//
  IXRefLUTDisp = dispinterface
    ['{89F140FF-44F0-45D1-83A5-6A99896697E9}']
    procedure GetXRefLine(const image1: IRadiologyImage; const image2: IRadiologyImage; 
                          var success: Integer; var planeId: Integer; var line: OleVariant); dispid 1;
    procedure GetNearestImage(const image: IRadiologyImage; images: OleVariant; posX: Integer; 
                              posY: Integer; var nearestImage: IRadiologyImage); dispid 2;
    procedure RegisterImage(const image: IRadiologyImage); dispid 3;
  end;

// *********************************************************************//
// The Class CoRadiologyImage provides a Create and CreateRemote method to          
// create instances of the default interface IRadiologyImage exposed by              
// the CoClass RadiologyImage. The functions are intended to be used by             
// clients wishing to automate the CoClass objects exposed by the         
// server of this typelibrary.                                            
// *********************************************************************//
  CoRadiologyImage = class
    class function Create: IRadiologyImage;
    class function CreateRemote(const MachineName: string): IRadiologyImage;
  end;


// *********************************************************************//
// OLE Server Proxy class declaration
// Server Object    : TRadiologyImage
// Help String      : 
// Default Interface: IRadiologyImage
// Def. Intf. DISP? : No
// Event   Interface: 
// TypeFlags        : (2) CanCreate
// *********************************************************************//
{$IFDEF LIVE_SERVER_AT_DESIGN_TIME}
  TRadiologyImageProperties= class;
{$ENDIF}
  TRadiologyImage = class(TOleServer)
  private
    FIntf: IRadiologyImage;
{$IFDEF LIVE_SERVER_AT_DESIGN_TIME}
    FProps: TRadiologyImageProperties;
    function GetServerProperties: TRadiologyImageProperties;
{$ENDIF}
    function GetDefaultInterface: IRadiologyImage;
  protected
    procedure InitServerData; override;
    function Get_ProjectionIndex: Smallint;
    procedure Set_ProjectionIndex(pVal: Smallint);
    function Get_TagValue(group: Integer; element: Integer): WideString;
    procedure Set_TagValue(group: Integer; element: Integer; const pVal: WideString);
    function Get_UserData: OleVariant;
    procedure Set_UserData(pVal: OleVariant);
  public
    constructor Create(AOwner: TComponent); override;
    destructor  Destroy; override;
    procedure Connect; override;
    procedure ConnectTo(svrIntf: IRadiologyImage);
    procedure Disconnect; override;
    procedure SetTag(group: Integer; element: Integer; const newValue: WideString);
    property DefaultInterface: IRadiologyImage read GetDefaultInterface;
    property TagValue[group: Integer; element: Integer]: WideString read Get_TagValue write Set_TagValue;
    property UserData: OleVariant read Get_UserData write Set_UserData;
    property ProjectionIndex: Smallint read Get_ProjectionIndex write Set_ProjectionIndex;
  published
{$IFDEF LIVE_SERVER_AT_DESIGN_TIME}
    property Server: TRadiologyImageProperties read GetServerProperties;
{$ENDIF}
  end;

{$IFDEF LIVE_SERVER_AT_DESIGN_TIME}
// *********************************************************************//
// OLE Server Properties Proxy Class
// Server Object    : TRadiologyImage
// (This object is used by the IDE's Property Inspector to allow editing
//  of the properties of this server)
// *********************************************************************//
 TRadiologyImageProperties = class(TPersistent)
  private
    FServer:    TRadiologyImage;
    function    GetDefaultInterface: IRadiologyImage;
    constructor Create(AServer: TRadiologyImage);
  protected
    function Get_ProjectionIndex: Smallint;
    procedure Set_ProjectionIndex(pVal: Smallint);
    function Get_TagValue(group: Integer; element: Integer): WideString;
    procedure Set_TagValue(group: Integer; element: Integer; const pVal: WideString);
    function Get_UserData: OleVariant;
    procedure Set_UserData(pVal: OleVariant);
  public
    property DefaultInterface: IRadiologyImage read GetDefaultInterface;
  published
    property ProjectionIndex: Smallint read Get_ProjectionIndex write Set_ProjectionIndex;
  end;
{$ENDIF}


// *********************************************************************//
// The Class CoXRefLUT provides a Create and CreateRemote method to          
// create instances of the default interface IXRefLUT exposed by              
// the CoClass XRefLUT. The functions are intended to be used by             
// clients wishing to automate the CoClass objects exposed by the         
// server of this typelibrary.                                            
// *********************************************************************//
  CoXRefLUT = class
    class function Create: IXRefLUT;
    class function CreateRemote(const MachineName: string): IXRefLUT;
  end;


// *********************************************************************//
// OLE Server Proxy class declaration
// Server Object    : TXRefLUT
// Help String      : 
// Default Interface: IXRefLUT
// Def. Intf. DISP? : No
// Event   Interface: 
// TypeFlags        : (2) CanCreate
// *********************************************************************//
{$IFDEF LIVE_SERVER_AT_DESIGN_TIME}
  TXRefLUTProperties= class;
{$ENDIF}
  TXRefLUT = class(TOleServer)
  private
    FIntf: IXRefLUT;
{$IFDEF LIVE_SERVER_AT_DESIGN_TIME}
    FProps: TXRefLUTProperties;
    function GetServerProperties: TXRefLUTProperties;
{$ENDIF}
    function GetDefaultInterface: IXRefLUT;
  protected
    procedure InitServerData; override;
  public
    constructor Create(AOwner: TComponent); override;
    destructor  Destroy; override;
    procedure Connect; override;
    procedure ConnectTo(svrIntf: IXRefLUT);
    procedure Disconnect; override;
    procedure GetXRefLine(const image1: IRadiologyImage; const image2: IRadiologyImage; 
                          var success: Integer; var planeId: Integer; var line: OleVariant);
    procedure GetNearestImage(const image: IRadiologyImage; images: OleVariant; posX: Integer; 
                              posY: Integer; var nearestImage: IRadiologyImage);
    procedure RegisterImage(const image: IRadiologyImage);
    property DefaultInterface: IXRefLUT read GetDefaultInterface;
  published
{$IFDEF LIVE_SERVER_AT_DESIGN_TIME}
    property Server: TXRefLUTProperties read GetServerProperties;
{$ENDIF}
  end;

{$IFDEF LIVE_SERVER_AT_DESIGN_TIME}
// *********************************************************************//
// OLE Server Properties Proxy Class
// Server Object    : TXRefLUT
// (This object is used by the IDE's Property Inspector to allow editing
//  of the properties of this server)
// *********************************************************************//
 TXRefLUTProperties = class(TPersistent)
  private
    FServer:    TXRefLUT;
    function    GetDefaultInterface: IXRefLUT;
    constructor Create(AServer: TXRefLUT);
  protected
  public
    property DefaultInterface: IXRefLUT read GetDefaultInterface;
  published
  end;
{$ENDIF}


procedure Register;

resourcestring
  dtlServerPage = '(none)';

  dtlOcxPage = '(none)';

implementation

uses ComObj;

class function CoRadiologyImage.Create: IRadiologyImage;
begin
  Result := CreateComObject(CLASS_RadiologyImage) as IRadiologyImage;
end;

class function CoRadiologyImage.CreateRemote(const MachineName: string): IRadiologyImage;
begin
  Result := CreateRemoteComObject(MachineName, CLASS_RadiologyImage) as IRadiologyImage;
end;

procedure TRadiologyImage.InitServerData;
const
  CServerData: TServerData = (
    ClassID:   '{A09B8B23-BD28-42D5-8756-E04EFAC128BB}';
    IntfIID:   '{CB9438F3-33C1-4322-8D80-CDB42F223670}';
    EventIID:  '';
    LicenseKey: nil;
    Version: 500);
begin
  ServerData := @CServerData;
end;

procedure TRadiologyImage.Connect;
var
  punk: IUnknown;
begin
  if FIntf = nil then
  begin
    punk := GetServer;
    Fintf:= punk as IRadiologyImage;
  end;
end;

procedure TRadiologyImage.ConnectTo(svrIntf: IRadiologyImage);
begin
  Disconnect;
  FIntf := svrIntf;
end;

procedure TRadiologyImage.DisConnect;
begin
  if Fintf <> nil then
  begin
    FIntf := nil;
  end;
end;

function TRadiologyImage.GetDefaultInterface: IRadiologyImage;
begin
  if FIntf = nil then
    Connect;
  Assert(FIntf <> nil, 'DefaultInterface is NULL. Component is not connected to Server. You must call "Connect" or "ConnectTo" before this operation');
  Result := FIntf;
end;

constructor TRadiologyImage.Create(AOwner: TComponent);
begin
  inherited Create(AOwner);
{$IFDEF LIVE_SERVER_AT_DESIGN_TIME}
  FProps := TRadiologyImageProperties.Create(Self);
{$ENDIF}
end;

destructor TRadiologyImage.Destroy;
begin
{$IFDEF LIVE_SERVER_AT_DESIGN_TIME}
  FProps.Free;
{$ENDIF}
  inherited Destroy;
end;

{$IFDEF LIVE_SERVER_AT_DESIGN_TIME}
function TRadiologyImage.GetServerProperties: TRadiologyImageProperties;
begin
  Result := FProps;
end;
{$ENDIF}

function TRadiologyImage.Get_ProjectionIndex: Smallint;
begin
    Result := DefaultInterface.ProjectionIndex;
end;

procedure TRadiologyImage.Set_ProjectionIndex(pVal: Smallint);
begin
  DefaultInterface.Set_ProjectionIndex(pVal);
end;

function TRadiologyImage.Get_TagValue(group: Integer; element: Integer): WideString;
begin
    Result := DefaultInterface.TagValue[group, element];
end;

procedure TRadiologyImage.Set_TagValue(group: Integer; element: Integer; const pVal: WideString);
  { Warning: The property TagValue has a setter and a getter whose
    types do not match. Delphi was unable to generate a property of
    this sort and so is using a Variant as a passthrough. }
var
  InterfaceVariant: OleVariant;
begin
  InterfaceVariant := DefaultInterface;
  InterfaceVariant.TagValue := pVal;
end;

function TRadiologyImage.Get_UserData: OleVariant;
var
  InterfaceVariant : OleVariant;
begin
  InterfaceVariant := DefaultInterface;
  Result := InterfaceVariant.UserData;
end;

procedure TRadiologyImage.Set_UserData(pVal: OleVariant);
begin
  DefaultInterface.Set_UserData(pVal);
end;

procedure TRadiologyImage.SetTag(group: Integer; element: Integer; const newValue: WideString);
begin
  DefaultInterface.SetTag(group, element, newValue);
end;

{$IFDEF LIVE_SERVER_AT_DESIGN_TIME}
constructor TRadiologyImageProperties.Create(AServer: TRadiologyImage);
begin
  inherited Create;
  FServer := AServer;
end;

function TRadiologyImageProperties.GetDefaultInterface: IRadiologyImage;
begin
  Result := FServer.DefaultInterface;
end;

function TRadiologyImageProperties.Get_ProjectionIndex: Smallint;
begin
    Result := DefaultInterface.ProjectionIndex;
end;

procedure TRadiologyImageProperties.Set_ProjectionIndex(pVal: Smallint);
begin
  DefaultInterface.Set_ProjectionIndex(pVal);
end;

function TRadiologyImageProperties.Get_TagValue(group: Integer; element: Integer): WideString;
begin
    Result := DefaultInterface.TagValue[group, element];
end;

procedure TRadiologyImageProperties.Set_TagValue(group: Integer; element: Integer; 
                                                 const pVal: WideString);
  { Warning: The property TagValue has a setter and a getter whose
    types do not match. Delphi was unable to generate a property of
    this sort and so is using a Variant as a passthrough. }
var
  InterfaceVariant: OleVariant;
begin
  InterfaceVariant := DefaultInterface;
  InterfaceVariant.TagValue := pVal;
end;

function TRadiologyImageProperties.Get_UserData: OleVariant;
var
  InterfaceVariant : OleVariant;
begin
  InterfaceVariant := DefaultInterface;
  Result := InterfaceVariant.UserData;
end;

procedure TRadiologyImageProperties.Set_UserData(pVal: OleVariant);
begin
  DefaultInterface.Set_UserData(pVal);
end;

{$ENDIF}

class function CoXRefLUT.Create: IXRefLUT;
begin
  Result := CreateComObject(CLASS_XRefLUT) as IXRefLUT;
end;

class function CoXRefLUT.CreateRemote(const MachineName: string): IXRefLUT;
begin
  Result := CreateRemoteComObject(MachineName, CLASS_XRefLUT) as IXRefLUT;
end;

procedure TXRefLUT.InitServerData;
const
  CServerData: TServerData = (
    ClassID:   '{425DCE0C-58C7-4DC7-AE25-41A16AB96595}';
    IntfIID:   '{89F140FF-44F0-45D1-83A5-6A99896697E9}';
    EventIID:  '';
    LicenseKey: nil;
    Version: 500);
begin
  ServerData := @CServerData;
end;

procedure TXRefLUT.Connect;
var
  punk: IUnknown;
begin
  if FIntf = nil then
  begin
    punk := GetServer;
    Fintf:= punk as IXRefLUT;
  end;
end;

procedure TXRefLUT.ConnectTo(svrIntf: IXRefLUT);
begin
  Disconnect;
  FIntf := svrIntf;
end;

procedure TXRefLUT.DisConnect;
begin
  if Fintf <> nil then
  begin
    FIntf := nil;
  end;
end;

function TXRefLUT.GetDefaultInterface: IXRefLUT;
begin
  if FIntf = nil then
    Connect;
  Assert(FIntf <> nil, 'DefaultInterface is NULL. Component is not connected to Server. You must call "Connect" or "ConnectTo" before this operation');
  Result := FIntf;
end;

constructor TXRefLUT.Create(AOwner: TComponent);
begin
  inherited Create(AOwner);
{$IFDEF LIVE_SERVER_AT_DESIGN_TIME}
  FProps := TXRefLUTProperties.Create(Self);
{$ENDIF}
end;

destructor TXRefLUT.Destroy;
begin
{$IFDEF LIVE_SERVER_AT_DESIGN_TIME}
  FProps.Free;
{$ENDIF}
  inherited Destroy;
end;

{$IFDEF LIVE_SERVER_AT_DESIGN_TIME}
function TXRefLUT.GetServerProperties: TXRefLUTProperties;
begin
  Result := FProps;
end;
{$ENDIF}

procedure TXRefLUT.GetXRefLine(const image1: IRadiologyImage; const image2: IRadiologyImage; 
                               var success: Integer; var planeId: Integer; var line: OleVariant);
begin
  DefaultInterface.GetXRefLine(image1, image2, success, planeId, line);
end;

procedure TXRefLUT.GetNearestImage(const image: IRadiologyImage; images: OleVariant; posX: Integer; 
                                   posY: Integer; var nearestImage: IRadiologyImage);
begin
  DefaultInterface.GetNearestImage(image, images, posX, posY, nearestImage);
end;

procedure TXRefLUT.RegisterImage(const image: IRadiologyImage);
begin
  DefaultInterface.RegisterImage(image);
end;

{$IFDEF LIVE_SERVER_AT_DESIGN_TIME}
constructor TXRefLUTProperties.Create(AServer: TXRefLUT);
begin
  inherited Create;
  FServer := AServer;
end;

function TXRefLUTProperties.GetDefaultInterface: IXRefLUT;
begin
  Result := FServer.DefaultInterface;
end;

{$ENDIF}

procedure Register;
begin
  RegisterComponents(dtlServerPage, [TRadiologyImage, TXRefLUT]);
end;

end.
