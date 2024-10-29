unit MagImportXControl1_TLB;

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
// File generated on 5/14/2015 3:38:00 PM from Type Library described below.

// ************************************************************************  //
// Type Lib: C:\DevD2007\Main-151\clin\Background Processor\Import_OCX\MagImportXControl1.tlb (1)
// LIBID: {6F3BDBBC-0CC0-4E9D-BA33-293076DB6587}
// LCID: 0
// Helpfile: 
// HelpString: MagImportXControl1 Library
// DepndLst: 
//   (1) v2.0 stdole, (C:\WINDOWS\system32\stdole2.tlb)
// ************************************************************************ //
{$TYPEDADDRESS OFF} // Unit must be compiled without type-checked pointers. 
{$WARN SYMBOL_PLATFORM OFF}
{$WRITEABLECONST ON}
{$VARPROPSETTER ON}
interface

uses Windows, ActiveX, Classes, Graphics, OleCtrls, StdVCL, Variants;
  

// *********************************************************************//
// GUIDS declared in the TypeLibrary. Following prefixes are used:        
//   Type Libraries     : LIBID_xxxx                                      
//   CoClasses          : CLASS_xxxx                                      
//   DISPInterfaces     : DIID_xxxx                                       
//   Non-DISP interfaces: IID_xxxx                                        
// *********************************************************************//
const
  // TypeLibrary Major and minor versions
  MagImportXControl1MajorVersion = 1;
  MagImportXControl1MinorVersion = 0;

  LIBID_MagImportXControl1: TGUID = '{6F3BDBBC-0CC0-4E9D-BA33-293076DB6587}';

  IID_IMagImportX: TGUID = '{0E728CE5-3518-4C87-B183-5A58AEC2C1E9}';
  DIID_IMagImportXEvents: TGUID = '{BEE8DC98-1485-4F1A-8F94-BD43E88C4401}';
  CLASS_MagImportX: TGUID = '{BDF2CF24-5759-41A5-B96A-A7AE8EAC25E7}';
type

// *********************************************************************//
// Forward declaration of types defined in TypeLibrary                    
// *********************************************************************//
  IMagImportX = interface;
  IMagImportXDisp = dispinterface;
  IMagImportXEvents = dispinterface;

// *********************************************************************//
// Declaration of CoClasses defined in Type Library                       
// (NOTE: Here we map each CoClass to its Default Interface)              
// *********************************************************************//
  MagImportX = IMagImportX;


// *********************************************************************//
// Interface: IMagImportX
// Flags:     (4416) Dual OleAutomation Dispatchable
// GUID:      {0E728CE5-3518-4C87-B183-5A58AEC2C1E9}
// *********************************************************************//
  IMagImportX = interface(IDispatch)
    ['{0E728CE5-3518-4C87-B183-5A58AEC2C1E9}']
    procedure SaveDirect(var status: WordBool; var xmsglist: OleVariant); safecall;
    procedure ImportQueue(var status: WordBool; const Qnum: WideString; var reslist: OleVariant; 
                          var StatusCB: WideString); safecall;
    function Get_TrkID: WideString; safecall;
    procedure Set_TrkID(const Value: WideString); safecall;
    function Get_Images: OleVariant; safecall;
    procedure Set_Images(Value: OleVariant); safecall;
    function Get_DFN: WideString; safecall;
    procedure Set_DFN(const Value: WideString); safecall;
    function Get_AcqDev: WideString; safecall;
    procedure Set_AcqDev(const Value: WideString); safecall;
    function Get_ExcpHandler: WideString; safecall;
    procedure Set_ExcpHandler(const Value: WideString); safecall;
    function Get_ProcPKG: WideString; safecall;
    procedure Set_ProcPKG(const Value: WideString); safecall;
    function Get_ProcIEN: WideString; safecall;
    procedure Set_ProcIEN(const Value: WideString); safecall;
    function Get_Username: WideString; safecall;
    procedure Set_Username(const Value: WideString); safecall;
    function Get_Password: WideString; safecall;
    procedure Set_Password(const Value: WideString); safecall;
    function Get_ProcDt: WideString; safecall;
    procedure Set_ProcDt(const Value: WideString); safecall;
    function Get_ImgType: WideString; safecall;
    procedure Set_ImgType(const Value: WideString); safecall;
    function Get_AcqSite: WideString; safecall;
    procedure Set_AcqSite(const Value: WideString); safecall;
    function Get_Method: WideString; safecall;
    procedure Set_Method(const Value: WideString); safecall;
    function Get_GroupDesc: WideString; safecall;
    procedure Set_GroupDesc(const Value: WideString); safecall;
    function Get_DeleteFlag: WordBool; safecall;
    procedure Set_DeleteFlag(Value: WordBool); safecall;
    function Get_TransType: WideString; safecall;
    procedure Set_TransType(const Value: WideString); safecall;
    function Get_AcqLocation: WideString; safecall;
    procedure Set_AcqLocation(const Value: WideString); safecall;
    function Get_DocCategory: WideString; safecall;
    procedure Set_DocCategory(const Value: WideString); safecall;
    function Get_DocDate: WideString; safecall;
    procedure Set_DocDate(const Value: WideString); safecall;
    function Get_Visible: WordBool; safecall;
    procedure Set_Visible(Value: WordBool); safecall;
    function Get_Cursor: Smallint; safecall;
    procedure Set_Cursor(Value: Smallint); safecall;
    procedure AboutBox; safecall;
    procedure ImageAdd(const imagefile: WideString); safecall;
    procedure ShowProperties; safecall;
    procedure ClearProperties; safecall;
    function Get_IndexType: WideString; safecall;
    procedure Set_IndexType(const Value: WideString); safecall;
    function Get_IndexSpec: WideString; safecall;
    procedure Set_IndexSpec(const Value: WideString); safecall;
    function Get_IndexProc: WideString; safecall;
    procedure Set_IndexProc(const Value: WideString); safecall;
    procedure VistaInit(var zstat: WordBool; var zmsg: WideString; var zserver: WideString; 
                        var zport: WideString; const zaccess: WideString; 
                        const zverify: WideString; const zdivision: WideString); safecall;
    function Get_IndexOrigin: WideString; safecall;
    procedure Set_IndexOrigin(const Value: WideString); safecall;
    function GetTypeList(const ClassChoice: WideString; out status: EXCEPINFO): OleVariant; safecall;
    function GetOriginList(out status: EXCEPINFO): OleVariant; safecall;
    function GetProcList(const ClassChoice: WideString; const SpecChoice: WideString; 
                         out status: EXCEPINFO): OleVariant; safecall;
    function GetSpecList(const ClassChoice: WideString; const ProcChoice: WideString; 
                         out status: EXCEPINFO): OleVariant; safecall;
    function Get_ProcNew: WideString; safecall;
    procedure Set_ProcNew(const Value: WideString); safecall;
    function Get_TIUTitle: WideString; safecall;
    procedure Set_TIUTitle(const Value: WideString); safecall;
    function Get_TIUSignType: WideString; safecall;
    procedure Set_TIUSignType(const Value: WideString); safecall;
    procedure SetTIUText(TIUText: OleVariant); safecall;
    function GetPatientHasPhoto(const DFN: WideString; out status: EXCEPINFO): OleVariant; safecall;
    function Get_NetSecurity: WordBool; safecall;
    procedure Set_NetSecurity(Value: WordBool); safecall;
    function Get_DelayConnectUntilImport: WordBool; safecall;
    procedure Set_DelayConnectUntilImport(Value: WordBool); safecall;
    property TrkID: WideString read Get_TrkID write Set_TrkID;
    property Images: OleVariant read Get_Images write Set_Images;
    property DFN: WideString read Get_DFN write Set_DFN;
    property AcqDev: WideString read Get_AcqDev write Set_AcqDev;
    property ExcpHandler: WideString read Get_ExcpHandler write Set_ExcpHandler;
    property ProcPKG: WideString read Get_ProcPKG write Set_ProcPKG;
    property ProcIEN: WideString read Get_ProcIEN write Set_ProcIEN;
    property Username: WideString read Get_Username write Set_Username;
    property Password: WideString read Get_Password write Set_Password;
    property ProcDt: WideString read Get_ProcDt write Set_ProcDt;
    property ImgType: WideString read Get_ImgType write Set_ImgType;
    property AcqSite: WideString read Get_AcqSite write Set_AcqSite;
    property Method: WideString read Get_Method write Set_Method;
    property GroupDesc: WideString read Get_GroupDesc write Set_GroupDesc;
    property DeleteFlag: WordBool read Get_DeleteFlag write Set_DeleteFlag;
    property TransType: WideString read Get_TransType write Set_TransType;
    property AcqLocation: WideString read Get_AcqLocation write Set_AcqLocation;
    property DocCategory: WideString read Get_DocCategory write Set_DocCategory;
    property DocDate: WideString read Get_DocDate write Set_DocDate;
    property Visible: WordBool read Get_Visible write Set_Visible;
    property Cursor: Smallint read Get_Cursor write Set_Cursor;
    property IndexType: WideString read Get_IndexType write Set_IndexType;
    property IndexSpec: WideString read Get_IndexSpec write Set_IndexSpec;
    property IndexProc: WideString read Get_IndexProc write Set_IndexProc;
    property IndexOrigin: WideString read Get_IndexOrigin write Set_IndexOrigin;
    property ProcNew: WideString read Get_ProcNew write Set_ProcNew;
    property TIUTitle: WideString read Get_TIUTitle write Set_TIUTitle;
    property TIUSignType: WideString read Get_TIUSignType write Set_TIUSignType;
    property NetSecurity: WordBool read Get_NetSecurity write Set_NetSecurity;
    property DelayConnectUntilImport: WordBool read Get_DelayConnectUntilImport write Set_DelayConnectUntilImport;
  end;

// *********************************************************************//
// DispIntf:  IMagImportXDisp
// Flags:     (4416) Dual OleAutomation Dispatchable
// GUID:      {0E728CE5-3518-4C87-B183-5A58AEC2C1E9}
// *********************************************************************//
  IMagImportXDisp = dispinterface
    ['{0E728CE5-3518-4C87-B183-5A58AEC2C1E9}']
    procedure SaveDirect(var status: WordBool; var xmsglist: OleVariant); dispid 1;
    procedure ImportQueue(var status: WordBool; const Qnum: WideString; var reslist: OleVariant; 
                          var StatusCB: WideString); dispid 4;
    property TrkID: WideString dispid 5;
    property Images: OleVariant dispid 6;
    property DFN: WideString dispid 7;
    property AcqDev: WideString dispid 9;
    property ExcpHandler: WideString dispid 10;
    property ProcPKG: WideString dispid 11;
    property ProcIEN: WideString dispid 12;
    property Username: WideString dispid 14;
    property Password: WideString dispid 15;
    property ProcDt: WideString dispid 16;
    property ImgType: WideString dispid 19;
    property AcqSite: WideString dispid 20;
    property Method: WideString dispid 21;
    property GroupDesc: WideString dispid 23;
    property DeleteFlag: WordBool dispid 25;
    property TransType: WideString dispid 26;
    property AcqLocation: WideString dispid 27;
    property DocCategory: WideString dispid 28;
    property DocDate: WideString dispid 29;
    property Visible: WordBool dispid 40;
    property Cursor: Smallint dispid 41;
    procedure AboutBox; dispid -552;
    procedure ImageAdd(const imagefile: WideString); dispid 3;
    procedure ShowProperties; dispid 8;
    procedure ClearProperties; dispid 13;
    property IndexType: WideString dispid 17;
    property IndexSpec: WideString dispid 18;
    property IndexProc: WideString dispid 22;
    procedure VistaInit(var zstat: WordBool; var zmsg: WideString; var zserver: WideString; 
                        var zport: WideString; const zaccess: WideString; 
                        const zverify: WideString; const zdivision: WideString); dispid 2;
    property IndexOrigin: WideString dispid 24;
    function GetTypeList(const ClassChoice: WideString; out status: {??EXCEPINFO}OleVariant): OleVariant; dispid 206;
    function GetOriginList(out status: {??EXCEPINFO}OleVariant): OleVariant; dispid 207;
    function GetProcList(const ClassChoice: WideString; const SpecChoice: WideString; 
                         out status: {??EXCEPINFO}OleVariant): OleVariant; dispid 208;
    function GetSpecList(const ClassChoice: WideString; const ProcChoice: WideString; 
                         out status: {??EXCEPINFO}OleVariant): OleVariant; dispid 209;
    property ProcNew: WideString dispid 202;
    property TIUTitle: WideString dispid 203;
    property TIUSignType: WideString dispid 204;
    procedure SetTIUText(TIUText: OleVariant); dispid 205;
    function GetPatientHasPhoto(const DFN: WideString; out status: {??EXCEPINFO}OleVariant): OleVariant; dispid 211;
    property NetSecurity: WordBool dispid 201;
    property DelayConnectUntilImport: WordBool dispid 210;
  end;

// *********************************************************************//
// DispIntf:  IMagImportXEvents
// Flags:     (4096) Dispatchable
// GUID:      {BEE8DC98-1485-4F1A-8F94-BD43E88C4401}
// *********************************************************************//
  IMagImportXEvents = dispinterface
    ['{BEE8DC98-1485-4F1A-8F94-BD43E88C4401}']
  end;


// *********************************************************************//
// OLE Control Proxy class declaration
// Control Name     : TMagImportX
// Help String      : MagImportX Control
// Default Interface: IMagImportX
// Def. Intf. DISP? : No
// Event   Interface: IMagImportXEvents
// TypeFlags        : (34) CanCreate Control
// *********************************************************************//
  TMagImportX = class(TOleControl)
  private
    FIntf: IMagImportX;
    function  GetControlInterface: IMagImportX;
  protected
    procedure CreateControl;
    procedure InitControlData; override;
    function Get_Images: OleVariant;
    procedure Set_Images(Value: OleVariant);
  public
    procedure SaveDirect(var status: WordBool; var xmsglist: OleVariant);
    procedure ImportQueue(var status: WordBool; const Qnum: WideString; var reslist: OleVariant; 
                          var StatusCB: WideString);
    procedure AboutBox;
    procedure ImageAdd(const imagefile: WideString);
    procedure ShowProperties;
    procedure ClearProperties;
    procedure VistaInit(var zstat: WordBool; var zmsg: WideString; var zserver: WideString; 
                        var zport: WideString; const zaccess: WideString; 
                        const zverify: WideString; const zdivision: WideString);
    function GetTypeList(const ClassChoice: WideString; out status: EXCEPINFO): OleVariant;
    function GetOriginList(out status: EXCEPINFO): OleVariant;
    function GetProcList(const ClassChoice: WideString; const SpecChoice: WideString; 
                         out status: EXCEPINFO): OleVariant;
    function GetSpecList(const ClassChoice: WideString; const ProcChoice: WideString; 
                         out status: EXCEPINFO): OleVariant;
    procedure SetTIUText(TIUText: OleVariant);
    function GetPatientHasPhoto(const DFN: WideString; out status: EXCEPINFO): OleVariant;
    property  ControlInterface: IMagImportX read GetControlInterface;
    property  DefaultInterface: IMagImportX read GetControlInterface;
    property Images: OleVariant index 6 read GetOleVariantProp write SetOleVariantProp;
    property Visible: WordBool index 40 read GetWordBoolProp write SetWordBoolProp;
  published
    property Anchors;
    property TrkID: WideString index 5 read GetWideStringProp write SetWideStringProp stored False;
    property DFN: WideString index 7 read GetWideStringProp write SetWideStringProp stored False;
    property AcqDev: WideString index 9 read GetWideStringProp write SetWideStringProp stored False;
    property ExcpHandler: WideString index 10 read GetWideStringProp write SetWideStringProp stored False;
    property ProcPKG: WideString index 11 read GetWideStringProp write SetWideStringProp stored False;
    property ProcIEN: WideString index 12 read GetWideStringProp write SetWideStringProp stored False;
    property Username: WideString index 14 read GetWideStringProp write SetWideStringProp stored False;
    property Password: WideString index 15 read GetWideStringProp write SetWideStringProp stored False;
    property ProcDt: WideString index 16 read GetWideStringProp write SetWideStringProp stored False;
    property ImgType: WideString index 19 read GetWideStringProp write SetWideStringProp stored False;
    property AcqSite: WideString index 20 read GetWideStringProp write SetWideStringProp stored False;
    property Method: WideString index 21 read GetWideStringProp write SetWideStringProp stored False;
    property GroupDesc: WideString index 23 read GetWideStringProp write SetWideStringProp stored False;
    property DeleteFlag: WordBool index 25 read GetWordBoolProp write SetWordBoolProp stored False;
    property TransType: WideString index 26 read GetWideStringProp write SetWideStringProp stored False;
    property AcqLocation: WideString index 27 read GetWideStringProp write SetWideStringProp stored False;
    property DocCategory: WideString index 28 read GetWideStringProp write SetWideStringProp stored False;
    property DocDate: WideString index 29 read GetWideStringProp write SetWideStringProp stored False;
    property Cursor: Smallint index 41 read GetSmallintProp write SetSmallintProp stored False;
    property IndexType: WideString index 17 read GetWideStringProp write SetWideStringProp stored False;
    property IndexSpec: WideString index 18 read GetWideStringProp write SetWideStringProp stored False;
    property IndexProc: WideString index 22 read GetWideStringProp write SetWideStringProp stored False;
    property IndexOrigin: WideString index 24 read GetWideStringProp write SetWideStringProp stored False;
    property ProcNew: WideString index 202 read GetWideStringProp write SetWideStringProp stored False;
    property TIUTitle: WideString index 203 read GetWideStringProp write SetWideStringProp stored False;
    property TIUSignType: WideString index 204 read GetWideStringProp write SetWideStringProp stored False;
    property NetSecurity: WordBool index 201 read GetWordBoolProp write SetWordBoolProp stored False;
    property DelayConnectUntilImport: WordBool index 210 read GetWordBoolProp write SetWordBoolProp stored False;
  end;

procedure Register;

resourcestring
  dtlServerPage = 'Servers';

  dtlOcxPage = 'ActiveX';

implementation

uses ComObj;

procedure TMagImportX.InitControlData;
const
  CControlData: TControlData2 = (
    ClassID: '{BDF2CF24-5759-41A5-B96A-A7AE8EAC25E7}';
    EventIID: '';
    EventCount: 0;
    EventDispIDs: nil;
    LicenseKey: nil (*HR:$80040154*);
    Flags: $00000000;
    Version: 401);
begin
  ControlData := @CControlData;
end;

procedure TMagImportX.CreateControl;

  procedure DoCreate;
  begin
    FIntf := IUnknown(OleObject) as IMagImportX;
  end;

begin
  if FIntf = nil then DoCreate;
end;

function TMagImportX.GetControlInterface: IMagImportX;
begin
  CreateControl;
  Result := FIntf;
end;

function TMagImportX.Get_Images: OleVariant;
var
  InterfaceVariant : OleVariant;
begin
  InterfaceVariant := DefaultInterface;
  Result := InterfaceVariant.Images;
end;

procedure TMagImportX.Set_Images(Value: OleVariant);
begin
  DefaultInterface.Set_Images(Value);
end;

procedure TMagImportX.SaveDirect(var status: WordBool; var xmsglist: OleVariant);
begin
  DefaultInterface.SaveDirect(status, xmsglist);
end;

procedure TMagImportX.ImportQueue(var status: WordBool; const Qnum: WideString; 
                                  var reslist: OleVariant; var StatusCB: WideString);
begin
  DefaultInterface.ImportQueue(status, Qnum, reslist, StatusCB);
end;

procedure TMagImportX.AboutBox;
begin
  DefaultInterface.AboutBox;
end;

procedure TMagImportX.ImageAdd(const imagefile: WideString);
begin
  DefaultInterface.ImageAdd(imagefile);
end;

procedure TMagImportX.ShowProperties;
begin
  DefaultInterface.ShowProperties;
end;

procedure TMagImportX.ClearProperties;
begin
  DefaultInterface.ClearProperties;
end;

procedure TMagImportX.VistaInit(var zstat: WordBool; var zmsg: WideString; var zserver: WideString; 
                                var zport: WideString; const zaccess: WideString; 
                                const zverify: WideString; const zdivision: WideString);
begin
  DefaultInterface.VistaInit(zstat, zmsg, zserver, zport, zaccess, zverify, zdivision);
end;

function TMagImportX.GetTypeList(const ClassChoice: WideString; out status: EXCEPINFO): OleVariant;
begin
  Result := DefaultInterface.GetTypeList(ClassChoice, status);
end;

function TMagImportX.GetOriginList(out status: EXCEPINFO): OleVariant;
begin
  Result := DefaultInterface.GetOriginList(status);
end;

function TMagImportX.GetProcList(const ClassChoice: WideString; const SpecChoice: WideString; 
                                 out status: EXCEPINFO): OleVariant;
begin
  Result := DefaultInterface.GetProcList(ClassChoice, SpecChoice, status);
end;

function TMagImportX.GetSpecList(const ClassChoice: WideString; const ProcChoice: WideString; 
                                 out status: EXCEPINFO): OleVariant;
begin
  Result := DefaultInterface.GetSpecList(ClassChoice, ProcChoice, status);
end;

procedure TMagImportX.SetTIUText(TIUText: OleVariant);
begin
  DefaultInterface.SetTIUText(TIUText);
end;

function TMagImportX.GetPatientHasPhoto(const DFN: WideString; out status: EXCEPINFO): OleVariant;
begin
  Result := DefaultInterface.GetPatientHasPhoto(DFN, status);
end;

procedure Register;
begin
  RegisterComponents(dtlOcxPage, [TMagImportX]);
end;

end.
