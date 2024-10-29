unit CPRSChart_TLB;

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
// File generated on 10/8/2004 4:27:19 PM from Type Library described below.

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
// Type Lib: \\vhaiswimm1\image1\CPRS\CPRS-GOLD\CPRSChart.exe (1)
// IID\LCID: {0A4A6086-6504-11D5-82DE-00C04F72C274}\0
// Helpfile: 
// DepndLst: 
//   (1) v2.0 stdole, (C:\WINNT\system32\stdole2.tlb)
//   (2) v1.1 Accessibility, (C:\WINNT\system32\oleacc.dll)
// Parent TypeLibrary:
//   (0) v1.0 AnnotationTool, (C:\Dev\P48\Clin\Diagram Annotation\MagAnnTool\MagAnnTool.tlb)
// ************************************************************************ //
{$TYPEDADDRESS OFF} // Unit must be compiled without type-checked pointers. 
interface

uses Windows, ActiveX, Classes, Graphics, OleServer, OleCtrls, StdVCL, 
  Accessibility_TLB;

// *********************************************************************//
// GUIDS declared in the TypeLibrary. Following prefixes are used:        
//   Type Libraries     : LIBID_xxxx                                      
//   CoClasses          : CLASS_xxxx                                      
//   DISPInterfaces     : DIID_xxxx                                       
//   Non-DISP interfaces: IID_xxxx                                        
// *********************************************************************//
const
  // TypeLibrary Major and minor versions
  CPRSChartMajorVersion = 1;
  CPRSChartMinorVersion = 0;

  LIBID_CPRSChart: TGUID = '{0A4A6086-6504-11D5-82DE-00C04F72C274}';

  IID_ICPRSBroker: TGUID = '{63DC619B-6BE0-11D5-82E6-00C04F72C274}';
  IID_ICPRSState: TGUID = '{63DC619E-6BE0-11D5-82E6-00C04F72C274}';
  IID_ICPRSExtension: TGUID = '{63DC61C4-6BE0-11D5-82E6-00C04F72C274}';
  IID_IAccessibleStringGrid: TGUID = '{EFD768F7-59C0-48D9-889E-49EDF75488A6}';
  CLASS_AccessibleStringGrid: TGUID = '{25CDBD92-C72E-47B0-9E75-9457B603000C}';
  IID_IAccessibleListBox: TGUID = '{4B6A88F7-DCFE-4992-B5FC-565FDCB3829B}';
  CLASS_AccessibleListBox: TGUID = '{758002E7-7012-4FAB-BD84-40D372694719}';
  IID_IAccessibleTreeNode: TGUID = '{5974D1D8-0F49-45E5-AEFE-674A61F8771A}';
  CLASS_AccessibleTreeNode: TGUID = '{3AD21DCA-2298-487A-8197-59B8D586C244}';
  IID_IAccessibleTreeView: TGUID = '{06AA97AB-6D67-425C-B794-15FB8C62F870}';
  CLASS_AccessibleTreeView: TGUID = '{507AD9F0-9ED6-4BCD-A3AB-DBA72153F14D}';
  IID_IAccessibleRichEdit: TGUID = '{F2C380A5-C3DD-4AE8-81ED-C08C59E92962}';
  CLASS_AccessibleRichEdit: TGUID = '{DC61493C-51FE-49A4-8749-8464A00D5CFC}';

// *********************************************************************//
// Declaration of Enumerations defined in Type Library                    
// *********************************************************************//
// Constants for enum BrokerParamType
type
  BrokerParamType = TOleEnum;
const
  bptLiteral = $00000000;
  bptReference = $00000001;
  bptList = $00000002;
  bptUndefined = $00000003;

type

// *********************************************************************//
// Forward declaration of types defined in TypeLibrary                    
// *********************************************************************//
  ICPRSBroker = interface;
  ICPRSBrokerDisp = dispinterface;
  ICPRSState = interface;
  ICPRSStateDisp = dispinterface;
  ICPRSExtension = interface;
  ICPRSExtensionDisp = dispinterface;
  IAccessibleStringGrid = interface;
  IAccessibleStringGridDisp = dispinterface;
  IAccessibleListBox = interface;
  IAccessibleListBoxDisp = dispinterface;
  IAccessibleTreeNode = interface;
  IAccessibleTreeNodeDisp = dispinterface;
  IAccessibleTreeView = interface;
  IAccessibleTreeViewDisp = dispinterface;
  IAccessibleRichEdit = interface;
  IAccessibleRichEditDisp = dispinterface;

// *********************************************************************//
// Declaration of CoClasses defined in Type Library                       
// (NOTE: Here we map each CoClass to its Default Interface)              
// *********************************************************************//
  AccessibleStringGrid = IAccessibleStringGrid;
  AccessibleListBox = IAccessibleListBox;
  AccessibleTreeNode = IAccessibleTreeNode;
  AccessibleTreeView = IAccessibleTreeView;
  AccessibleRichEdit = IAccessibleRichEdit;


// *********************************************************************//
// Interface: ICPRSBroker
// Flags:     (4416) Dual OleAutomation Dispatchable
// GUID:      {63DC619B-6BE0-11D5-82E6-00C04F72C274}
// *********************************************************************//
  ICPRSBroker = interface(IDispatch)
    ['{63DC619B-6BE0-11D5-82E6-00C04F72C274}']
    function  SetContext(const Context: WideString): WordBool; safecall;
    function  Server: WideString; safecall;
    function  Port: Integer; safecall;
    function  DebugMode: WordBool; safecall;
    function  Get_RPCVersion: WideString; safecall;
    procedure Set_RPCVersion(const Value: WideString); safecall;
    function  Get_ClearParameters: WordBool; safecall;
    procedure Set_ClearParameters(Value: WordBool); safecall;
    function  Get_ClearResults: WordBool; safecall;
    procedure Set_ClearResults(Value: WordBool); safecall;
    procedure CallRPC(const RPCName: WideString); safecall;
    function  Get_Results: WideString; safecall;
    procedure Set_Results(const Value: WideString); safecall;
    function  Get_Param(Index: Integer): WideString; safecall;
    procedure Set_Param(Index: Integer; const Value: WideString); safecall;
    function  Get_ParamType(Index: Integer): BrokerParamType; safecall;
    procedure Set_ParamType(Index: Integer; Value: BrokerParamType); safecall;
    function  Get_ParamList(Index: Integer; const Node: WideString): WideString; safecall;
    procedure Set_ParamList(Index: Integer; const Node: WideString; const Value: WideString); safecall;
    function  ParamCount: Integer; safecall;
    function  ParamListCount(Index: Integer): Integer; safecall;
    property RPCVersion: WideString read Get_RPCVersion write Set_RPCVersion;
    property ClearParameters: WordBool read Get_ClearParameters write Set_ClearParameters;
    property ClearResults: WordBool read Get_ClearResults write Set_ClearResults;
    property Results: WideString read Get_Results write Set_Results;
    property Param[Index: Integer]: WideString read Get_Param write Set_Param;
    property ParamType[Index: Integer]: BrokerParamType read Get_ParamType write Set_ParamType;
    property ParamList[Index: Integer; const Node: WideString]: WideString read Get_ParamList write Set_ParamList;
  end;

// *********************************************************************//
// DispIntf:  ICPRSBrokerDisp
// Flags:     (4416) Dual OleAutomation Dispatchable
// GUID:      {63DC619B-6BE0-11D5-82E6-00C04F72C274}
// *********************************************************************//
  ICPRSBrokerDisp = dispinterface
    ['{63DC619B-6BE0-11D5-82E6-00C04F72C274}']
    function  SetContext(const Context: WideString): WordBool; dispid 1;
    function  Server: WideString; dispid 2;
    function  Port: Integer; dispid 3;
    function  DebugMode: WordBool; dispid 4;
    property RPCVersion: WideString dispid 5;
    property ClearParameters: WordBool dispid 6;
    property ClearResults: WordBool dispid 7;
    procedure CallRPC(const RPCName: WideString); dispid 8;
    property Results: WideString dispid 9;
    property Param[Index: Integer]: WideString dispid 10;
    property ParamType[Index: Integer]: BrokerParamType dispid 11;
    property ParamList[Index: Integer; const Node: WideString]: WideString dispid 12;
    function  ParamCount: Integer; dispid 13;
    function  ParamListCount(Index: Integer): Integer; dispid 14;
  end;

// *********************************************************************//
// Interface: ICPRSState
// Flags:     (4416) Dual OleAutomation Dispatchable
// GUID:      {63DC619E-6BE0-11D5-82E6-00C04F72C274}
// *********************************************************************//
  ICPRSState = interface(IDispatch)
    ['{63DC619E-6BE0-11D5-82E6-00C04F72C274}']
    function  Handle: WideString; safecall;
    function  UserDUZ: WideString; safecall;
    function  UserName: WideString; safecall;
    function  PatientDFN: WideString; safecall;
    function  PatientName: WideString; safecall;
    function  PatientDOB: WideString; safecall;
    function  PatientSSN: WideString; safecall;
    function  LocationIEN: Integer; safecall;
    function  LocationName: WideString; safecall;
  end;

// *********************************************************************//
// DispIntf:  ICPRSStateDisp
// Flags:     (4416) Dual OleAutomation Dispatchable
// GUID:      {63DC619E-6BE0-11D5-82E6-00C04F72C274}
// *********************************************************************//
  ICPRSStateDisp = dispinterface
    ['{63DC619E-6BE0-11D5-82E6-00C04F72C274}']
    function  Handle: WideString; dispid 1;
    function  UserDUZ: WideString; dispid 2;
    function  UserName: WideString; dispid 3;
    function  PatientDFN: WideString; dispid 4;
    function  PatientName: WideString; dispid 5;
    function  PatientDOB: WideString; dispid 6;
    function  PatientSSN: WideString; dispid 7;
    function  LocationIEN: Integer; dispid 8;
    function  LocationName: WideString; dispid 9;
  end;

// *********************************************************************//
// Interface: ICPRSExtension
// Flags:     (4416) Dual OleAutomation Dispatchable
// GUID:      {63DC61C4-6BE0-11D5-82E6-00C04F72C274}
// *********************************************************************//
  ICPRSExtension = interface(IDispatch)
    ['{63DC61C4-6BE0-11D5-82E6-00C04F72C274}']
    function  Execute(const CPRSBroker: ICPRSBroker; const CPRSState: ICPRSState; 
                      const Param1: WideString; const Param2: WideString; const Param3: WideString; 
                      var Data1: WideString; var Data2: WideString): WordBool; safecall;
  end;

// *********************************************************************//
// DispIntf:  ICPRSExtensionDisp
// Flags:     (4416) Dual OleAutomation Dispatchable
// GUID:      {63DC61C4-6BE0-11D5-82E6-00C04F72C274}
// *********************************************************************//
  ICPRSExtensionDisp = dispinterface
    ['{63DC61C4-6BE0-11D5-82E6-00C04F72C274}']
    function  Execute(const CPRSBroker: ICPRSBroker; const CPRSState: ICPRSState; 
                      const Param1: WideString; const Param2: WideString; const Param3: WideString; 
                      var Data1: WideString; var Data2: WideString): WordBool; dispid 1;
  end;

// *********************************************************************//
// Interface: IAccessibleStringGrid
// Flags:     (4416) Dual OleAutomation Dispatchable
// GUID:      {EFD768F7-59C0-48D9-889E-49EDF75488A6}
// *********************************************************************//
  IAccessibleStringGrid = interface(IDispatch)
    ['{EFD768F7-59C0-48D9-889E-49EDF75488A6}']
  end;

// *********************************************************************//
// DispIntf:  IAccessibleStringGridDisp
// Flags:     (4416) Dual OleAutomation Dispatchable
// GUID:      {EFD768F7-59C0-48D9-889E-49EDF75488A6}
// *********************************************************************//
  IAccessibleStringGridDisp = dispinterface
    ['{EFD768F7-59C0-48D9-889E-49EDF75488A6}']
  end;

// *********************************************************************//
// Interface: IAccessibleListBox
// Flags:     (4416) Dual OleAutomation Dispatchable
// GUID:      {4B6A88F7-DCFE-4992-B5FC-565FDCB3829B}
// *********************************************************************//
  IAccessibleListBox = interface(IDispatch)
    ['{4B6A88F7-DCFE-4992-B5FC-565FDCB3829B}']
  end;

// *********************************************************************//
// DispIntf:  IAccessibleListBoxDisp
// Flags:     (4416) Dual OleAutomation Dispatchable
// GUID:      {4B6A88F7-DCFE-4992-B5FC-565FDCB3829B}
// *********************************************************************//
  IAccessibleListBoxDisp = dispinterface
    ['{4B6A88F7-DCFE-4992-B5FC-565FDCB3829B}']
  end;

// *********************************************************************//
// Interface: IAccessibleTreeNode
// Flags:     (4416) Dual OleAutomation Dispatchable
// GUID:      {5974D1D8-0F49-45E5-AEFE-674A61F8771A}
// *********************************************************************//
  IAccessibleTreeNode = interface(IDispatch)
    ['{5974D1D8-0F49-45E5-AEFE-674A61F8771A}']
  end;

// *********************************************************************//
// DispIntf:  IAccessibleTreeNodeDisp
// Flags:     (4416) Dual OleAutomation Dispatchable
// GUID:      {5974D1D8-0F49-45E5-AEFE-674A61F8771A}
// *********************************************************************//
  IAccessibleTreeNodeDisp = dispinterface
    ['{5974D1D8-0F49-45E5-AEFE-674A61F8771A}']
  end;

// *********************************************************************//
// Interface: IAccessibleTreeView
// Flags:     (4416) Dual OleAutomation Dispatchable
// GUID:      {06AA97AB-6D67-425C-B794-15FB8C62F870}
// *********************************************************************//
  IAccessibleTreeView = interface(IDispatch)
    ['{06AA97AB-6D67-425C-B794-15FB8C62F870}']
  end;

// *********************************************************************//
// DispIntf:  IAccessibleTreeViewDisp
// Flags:     (4416) Dual OleAutomation Dispatchable
// GUID:      {06AA97AB-6D67-425C-B794-15FB8C62F870}
// *********************************************************************//
  IAccessibleTreeViewDisp = dispinterface
    ['{06AA97AB-6D67-425C-B794-15FB8C62F870}']
  end;

// *********************************************************************//
// Interface: IAccessibleRichEdit
// Flags:     (4416) Dual OleAutomation Dispatchable
// GUID:      {F2C380A5-C3DD-4AE8-81ED-C08C59E92962}
// *********************************************************************//
  IAccessibleRichEdit = interface(IDispatch)
    ['{F2C380A5-C3DD-4AE8-81ED-C08C59E92962}']
  end;

// *********************************************************************//
// DispIntf:  IAccessibleRichEditDisp
// Flags:     (4416) Dual OleAutomation Dispatchable
// GUID:      {F2C380A5-C3DD-4AE8-81ED-C08C59E92962}
// *********************************************************************//
  IAccessibleRichEditDisp = dispinterface
    ['{F2C380A5-C3DD-4AE8-81ED-C08C59E92962}']
  end;

// *********************************************************************//
// The Class CoAccessibleStringGrid provides a Create and CreateRemote method to          
// create instances of the default interface IAccessibleStringGrid exposed by              
// the CoClass AccessibleStringGrid. The functions are intended to be used by             
// clients wishing to automate the CoClass objects exposed by the         
// server of this typelibrary.                                            
// *********************************************************************//
  CoAccessibleStringGrid = class
    class function Create: IAccessibleStringGrid;
    class function CreateRemote(const MachineName: string): IAccessibleStringGrid;
  end;

// *********************************************************************//
// The Class CoAccessibleListBox provides a Create and CreateRemote method to          
// create instances of the default interface IAccessibleListBox exposed by              
// the CoClass AccessibleListBox. The functions are intended to be used by             
// clients wishing to automate the CoClass objects exposed by the         
// server of this typelibrary.                                            
// *********************************************************************//
  CoAccessibleListBox = class
    class function Create: IAccessibleListBox;
    class function CreateRemote(const MachineName: string): IAccessibleListBox;
  end;

// *********************************************************************//
// The Class CoAccessibleTreeNode provides a Create and CreateRemote method to          
// create instances of the default interface IAccessibleTreeNode exposed by              
// the CoClass AccessibleTreeNode. The functions are intended to be used by             
// clients wishing to automate the CoClass objects exposed by the         
// server of this typelibrary.                                            
// *********************************************************************//
  CoAccessibleTreeNode = class
    class function Create: IAccessibleTreeNode;
    class function CreateRemote(const MachineName: string): IAccessibleTreeNode;
  end;

// *********************************************************************//
// The Class CoAccessibleTreeView provides a Create and CreateRemote method to          
// create instances of the default interface IAccessibleTreeView exposed by              
// the CoClass AccessibleTreeView. The functions are intended to be used by             
// clients wishing to automate the CoClass objects exposed by the         
// server of this typelibrary.                                            
// *********************************************************************//
  CoAccessibleTreeView = class
    class function Create: IAccessibleTreeView;
    class function CreateRemote(const MachineName: string): IAccessibleTreeView;
  end;

// *********************************************************************//
// The Class CoAccessibleRichEdit provides a Create and CreateRemote method to          
// create instances of the default interface IAccessibleRichEdit exposed by              
// the CoClass AccessibleRichEdit. The functions are intended to be used by             
// clients wishing to automate the CoClass objects exposed by the         
// server of this typelibrary.                                            
// *********************************************************************//
  CoAccessibleRichEdit = class
    class function Create: IAccessibleRichEdit;
    class function CreateRemote(const MachineName: string): IAccessibleRichEdit;
  end;

implementation

uses ComObj;

class function CoAccessibleStringGrid.Create: IAccessibleStringGrid;
begin
  Result := CreateComObject(CLASS_AccessibleStringGrid) as IAccessibleStringGrid;
end;

class function CoAccessibleStringGrid.CreateRemote(const MachineName: string): IAccessibleStringGrid;
begin
  Result := CreateRemoteComObject(MachineName, CLASS_AccessibleStringGrid) as IAccessibleStringGrid;
end;

class function CoAccessibleListBox.Create: IAccessibleListBox;
begin
  Result := CreateComObject(CLASS_AccessibleListBox) as IAccessibleListBox;
end;

class function CoAccessibleListBox.CreateRemote(const MachineName: string): IAccessibleListBox;
begin
  Result := CreateRemoteComObject(MachineName, CLASS_AccessibleListBox) as IAccessibleListBox;
end;

class function CoAccessibleTreeNode.Create: IAccessibleTreeNode;
begin
  Result := CreateComObject(CLASS_AccessibleTreeNode) as IAccessibleTreeNode;
end;

class function CoAccessibleTreeNode.CreateRemote(const MachineName: string): IAccessibleTreeNode;
begin
  Result := CreateRemoteComObject(MachineName, CLASS_AccessibleTreeNode) as IAccessibleTreeNode;
end;

class function CoAccessibleTreeView.Create: IAccessibleTreeView;
begin
  Result := CreateComObject(CLASS_AccessibleTreeView) as IAccessibleTreeView;
end;

class function CoAccessibleTreeView.CreateRemote(const MachineName: string): IAccessibleTreeView;
begin
  Result := CreateRemoteComObject(MachineName, CLASS_AccessibleTreeView) as IAccessibleTreeView;
end;

class function CoAccessibleRichEdit.Create: IAccessibleRichEdit;
begin
  Result := CreateComObject(CLASS_AccessibleRichEdit) as IAccessibleRichEdit;
end;

class function CoAccessibleRichEdit.CreateRemote(const MachineName: string): IAccessibleRichEdit;
begin
  Result := CreateRemoteComObject(MachineName, CLASS_AccessibleRichEdit) as IAccessibleRichEdit;
end;

end.
