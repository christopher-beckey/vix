Unit MEDXLib;

{ AccuSoft ImageGear Medical OCX-32 }
{ Version 1.1 }

{ Conversion log:
Warning: 'String' is a reserved word. Parameter _DMedx in DcmUtilDataToString.String changed to String_
 }

Interface

Uses Windows,
  ActiveX,
  Classes,
  Graphics,
  OleCtrls,
  StdVCL,
  Dcm;

Const
  LIBID_MEDXLib: TGuid = '{3B599F64-DB45-11D0-A093-DEF744F91B14}';

Const

{ Component class GUIDs }
  Class_Med: TGuid = '{3B599F67-DB45-11D0-A093-DEF744F91B14}';

Type

{ Forward declarations }
  _DMedx = Dispinterface;
  _DMedxEvents = Dispinterface;

{ Dispatch interface for IGMed32x Control }

  _DMedx = Dispinterface
    ['{3B599F65-DB45-11D0-A093-DEF744F91B14}']
    Property DestGearControl: WideString Dispid 1;
    Property _DestGearControl: WideString Dispid 0;
    Property DestGearControlInterface: IDispatch Dispid 2;
    Procedure DcmDsCreate(Ts: Smallint); Dispid 3;
    Procedure DcmDsCurrDataGet(Data, SizeOfData, SizeOfItem: OLEVariant); Dispid 4;
    Procedure DcmDsCurrDataGetString(StrResult: OLEVariant; SizeOfString: Integer); Dispid 5;
    Procedure DcmDsCurrDataSet(Data: OLEVariant; SizeOfData: Integer); Dispid 6;
    Procedure DcmDsCurrIndexGet(Index: OLEVariant); Dispid 7;
    Procedure DcmDsCurrInfoGet(Tag, VR, Vl, Level, ItemCount: OLEVariant); Dispid 8;
    Procedure DcmDsCurrRemove(Removed: OLEVariant); Dispid 9;
    Procedure DcmDsDeInsert(Tag: Integer; VR: Smallint; Data: OLEVariant; SizeOfData: Integer); Dispid 10;
    Procedure DcmDsDestroy; Dispid 11;
    Procedure DcmDsExists(Exists: OLEVariant); Dispid 12;
    Procedure DcmDsInfoGet(NumTags, MaxLevel: OLEVariant); Dispid 13;
    Procedure DcmDsIsEmpty(Empty: OLEVariant); Dispid 14;
    Procedure DcmDsMoveAscend(Tag, VR, Vl, Level, ItemCount: OLEVariant); Dispid 15;
    Procedure DcmDsMoveDescend(Tag, VR, Vl, Level, ItemCount: OLEVariant); Dispid 16;
    Procedure DcmDsMoveFind(LevelOp: Smallint; Tag, VR, Vl, Level, ItemCount, TagFound: OLEVariant); Dispid 17;
    Procedure DcmDsMoveFindFirst(LevelOp, GroupNum: Smallint; VR, Vl, Level, ItemCount, TagFound: OLEVariant); Dispid 18;
    Procedure DcmDsMoveFirst(LevelOp: Smallint; Tag, VR, Vl, Level, ItemCount: OLEVariant); Dispid 19;
    Procedure DcmDsMoveIndex(Index: Integer; Tag, VR, Vl, Level, ItemCount: OLEVariant); Dispid 20;
    Procedure DcmDsMoveLast(LevelOp: Smallint; Tag, VR, Vl, Level, ItemCount: OLEVariant); Dispid 21;
    Procedure DcmDsMoveNext(LevelOp: Smallint; Tag, VR, Vl, Level, ItemCount, NumRemaining: OLEVariant); Dispid 22;
    Procedure DcmDsMovePrev(LevelOp: Smallint; Tag, VR, Vl, Level, ItemCount, NumRemaining: OLEVariant); Dispid 23;
    Procedure DcmDsOrigTsGet(OrigTS, IsPart10, GrpLengths: OLEVariant); Dispid 24;
    Procedure DcmDsPart10Get(Part10Item: Smallint; SizeOfData: Integer; Data, SizeOfItem: OLEVariant); Dispid 25;
    Procedure DcmDsPart10Set(Part10Item: Integer; Data: OLEVariant; Vl: Integer); Dispid 26;
    Procedure DcmDsPreambleGet(Preamble: OLEVariant); Dispid 27;
    Procedure DcmDsPreambleSet(Const Preamble: WideString; BytesInPreamble: Integer); Dispid 28;
    Procedure DcmSaveDicom(Const Filename: WideString; Syntax: Smallint; IncludeGroupLengths, SaveAsPart10: WordBool; PlanarConfiguration: Smallint; InludeSmallestLargest: WordBool; JPEGQuality:
      Smallint; Reserved: OLEVariant); Dispid 29;
    Function DcmUtilDataToString(Data: OLEVariant; VR: Smallint; Vl: Integer; FirstItem, LastItem: Smallint; String_: OLEVariant; StringLen: Integer; Separator: Smallint): WordBool; Dispid 30;
    Function DcmUtilTagInfoAdd(Tag: Integer; VR, Vm, Version: Smallint; Const TagName: WideString): WordBool; Dispid 31;
    Function DcmUtilTagInfoFree: WordBool; Dispid 32;
    Function DcmUtilTagInfoGet(Tag: Integer; VR, Vm, Version, TagName: OLEVariant): WordBool; Dispid 33;
    Procedure DcmUtilVrInfoMode(VrMode: Smallint; VrString, Length, Restriction, CheckForm, IsString: OLEVariant); Dispid 34;
    Procedure DcmUtilVrInfoString(Const VrString: WideString; Length, Restriction, Reserved, IsString, VrMode: OLEVariant); Dispid 35;
    Procedure DisplayColorLimits(ThreshLow, LowRed, LowGreen, LowBlue, ThreshHigh, HighRed, HighGreen, HighBlue: Smallint); Dispid 36;
    Procedure DisplayRescale(Slope, Intercept: Double; Reserved: OLEVariant); Dispid 37;
    Procedure DisplayWindowLevel(Min, Max: Integer; Reserved: OLEVariant); Dispid 38;
    Procedure DisplayWindowLevelAuto(Reserved, Min, Max, Signed: OLEVariant); Dispid 39;
    Procedure IpHistoClear(Histo: OLEVariant; BinCount: Integer); Dispid 40;
    Procedure IpHistoTabulate(Histo: OLEVariant; BinWidth: Smallint; BinCount: Integer; Signed, Count: OLEVariant); Dispid 41;
    Procedure Ipminmax(Min, Max, Signed: OLEVariant); Dispid 42;
    Procedure IpNormalize(Min: Integer); Dispid 43;
    Procedure IpPromoteTo16Gray(Bits, HighBit: Smallint); Dispid 44;
    Procedure IpReduceDepthWithDownshift(Downshift: Smallint); Dispid 45;
    Procedure IpReduceDepthWithLUT(LUT, Entries: OLEVariant); Dispid 46;
    Procedure IpWindowLevel(Min, Max: Integer; Reserved: OLEVariant); Dispid 47;
    Procedure IpWindowLevelAuto(Reserved, Min, Max, Signed: OLEVariant); Dispid 48;
    Procedure Version; Dispid 49;
    Procedure DcmDsBitsGet(BitsAllocated, BitsStored, HighBit, SamplesPerPix: OLEVariant); Dispid 50;
    Procedure IpHighBitTransform(Min: Smallint); Dispid 51;
    Procedure IpSwapBytes; Dispid 52;
    Procedure DcmLoadDicom(Const Filename: WideString; Syntax: Smallint; PageNumber: Integer); Dispid 53;
    Procedure DcmDsTsGet(TransferSyntax: OLEVariant); Dispid 54;
    Procedure DcmDsTsSet(TransferSyntax: Smallint); Dispid 55;
    Procedure DisplayContrast(RescaleSlope, RescaleIntercept: Double; WindowCenter, WindowWidth: Integer; Gamma: Double); Dispid 56;
    Procedure UtilOptionLevelGet(OptionCode, OptionString, Eval: OLEVariant); Dispid 57;
    Procedure DcmDsRescaleGet(RescaleSlope, RescaleIntercept, Found: OLEVariant); Dispid 58;
    Procedure DcmDsWindowLevelGet(WindowWidth, WindowCenter, Found: OLEVariant); Dispid 59;
    Procedure DcmDsPixPadValSet(UsePixPadding: WordBool; PixPaddingVal: Integer; ShowPpvAs: Smallint); Dispid 60;
    Procedure DcmDsPixPadValGet(UsePixPadding, PixPaddingVal, ShowPpvAs: OLEVariant); Dispid 61;
    Procedure DisplayColorSet(RLut, GLut, BLut: OLEVariant); Dispid 62;
    Procedure DisplayColorCreate(Scheme: Smallint; Param1, Param2, Param3: Integer; RLut, GLut, BLut: OLEVariant); Dispid 63;
    Procedure DisplayContrastAuto(RescaleSlope, RescaleIntercept, Gamma: Double; Reserved, WindowCenter, WindowWidth: OLEVariant); Dispid 64;
    Procedure IpContrast(RescaleSlope, RescaleIntercept: Double; WindowCenter, WindowWidth: Integer; Gamma: Double); Dispid 65;
    Procedure IpContrastAuto(RescaleSlope, RescaleIntercept, Gamma: Double; Reserved, WindowCenter, WindowWidth: OLEVariant); Dispid 66;
    Procedure AboutBox; Dispid - 552;
  End;

{ Event interface for IGMed32x Control }

  _DMedxEvents = Dispinterface
    ['{3B599F66-DB45-11D0-A093-DEF744F91B14}']
  End;

{ IGMed32x Control }

  TMed = Class(TOleControl)
  Private
    FIntf: _DMedx;
  Protected
    Procedure InitControlData; Override;
    Procedure InitControlInterface(Const Obj: IUnknown); Override;
  Public
    Procedure DcmDsCreate(Ts: Smallint);
    Procedure DcmDsCurrDataGet(Var Data, SizeOfData, SizeOfItem: OLEVariant);
    Procedure DcmDsCurrDataGetString(Var StrResult: OLEVariant; SizeOfString: Integer);
    Procedure DcmDsCurrDataSet(Var Data: OLEVariant; SizeOfData: Integer);
    Procedure DcmDsCurrIndexGet(Var Index: OLEVariant);
    Procedure DcmDsCurrInfoGet(Var Tag, VR, Vl, Level, ItemCount: OLEVariant);
    Procedure DcmDsCurrRemove(Var Removed: OLEVariant);
    Procedure DcmDsDeInsert(Tag: Integer; VR: Smallint; Var Data: OLEVariant; SizeOfData: Integer);
    Procedure DcmDsDestroy;
    Procedure DcmDsExists(Var Exists: OLEVariant);
    Procedure DcmDsInfoGet(Var NumTags, MaxLevel: OLEVariant);
    Procedure DcmDsIsEmpty(Var Empty: OLEVariant);
    Procedure DcmDsMoveAscend(Var Tag, VR, Vl, Level, ItemCount: OLEVariant);
    Procedure DcmDsMoveDescend(Var Tag, VR, Vl, Level, ItemCount: OLEVariant);
    Procedure DcmDsMoveFind(LevelOp: Smallint; Var Tag, VR, Vl, Level, ItemCount, TagFound: OLEVariant);
    Procedure DcmDsMoveFindFirst(LevelOp, GroupNum: Smallint; Var VR, Vl, Level, ItemCount, TagFound: OLEVariant);
    Procedure DcmDsMoveFirst(LevelOp: Smallint; Var Tag, VR, Vl, Level, ItemCount: OLEVariant);
    Procedure DcmDsMoveIndex(Index: Integer; Var Tag, VR, Vl, Level, ItemCount: OLEVariant);
    Procedure DcmDsMoveLast(LevelOp: Smallint; Var Tag, VR, Vl, Level, ItemCount: OLEVariant);
    Procedure DcmDsMoveNext(LevelOp: Smallint; Var Tag, VR, Vl, Level, ItemCount, NumRemaining: OLEVariant);
    Procedure DcmDsMovePrev(LevelOp: Smallint; Var Tag, VR, Vl, Level, ItemCount, NumRemaining: OLEVariant);
    Procedure DcmDsOrigTsGet(Var OrigTS, IsPart10, GrpLengths: OLEVariant);
    Procedure DcmDsPart10Get(Part10Item: Smallint; SizeOfData: Integer; Var Data, SizeOfItem: OLEVariant);
    Procedure DcmDsPart10Set(Part10Item: Integer; Var Data: OLEVariant; Vl: Integer);
    Procedure DcmDsPreambleGet(Var Preamble: OLEVariant);
    Procedure DcmDsPreambleSet(Const Preamble: WideString; BytesInPreamble: Integer);
    Procedure DcmSaveDicom(Const Filename: WideString; Syntax: Smallint; IncludeGroupLengths, SaveAsPart10: WordBool; PlanarConfiguration: Smallint; InludeSmallestLargest: WordBool; JPEGQuality:
      Smallint; Var Reserved: OLEVariant);
    Function DcmUtilDataToString(Var Data: OLEVariant; VR: Smallint; Vl: Integer; FirstItem, LastItem: Smallint; Var String_: OLEVariant; StringLen: Integer; Separator: Smallint): WordBool;
    Function DcmUtilTagInfoAdd(Tag: Integer; VR, Vm, Version: Smallint; Const TagName: WideString): WordBool;
    Function DcmUtilTagInfoFree: WordBool;
    Function DcmUtilTagInfoGet(Tag: Integer; Var VR, Vm, Version, TagName: OLEVariant): WordBool;
    Procedure DcmUtilVrInfoMode(VrMode: Smallint; Var VrString, Length, Restriction, CheckForm, IsString: OLEVariant);
    Procedure DcmUtilVrInfoString(Const VrString: WideString; Var Length, Restriction, Reserved, IsString, VrMode: OLEVariant);
    Procedure DisplayColorLimits(ThreshLow, LowRed, LowGreen, LowBlue, ThreshHigh, HighRed, HighGreen, HighBlue: Smallint);
    Procedure DisplayRescale(Slope, Intercept: Double; Var Reserved: OLEVariant);
    Procedure DisplayWindowLevel(Min, Max: Integer; Var Reserved: OLEVariant);
    Procedure DisplayWindowLevelAuto(Var Reserved, Min, Max, Signed: OLEVariant);
    Procedure IpHistoClear(Var Histo: OLEVariant; BinCount: Integer);
    Procedure IpHistoTabulate(Var Histo: OLEVariant; BinWidth: Smallint; BinCount: Integer; Var Signed, Count: OLEVariant);
    Procedure Ipminmax(Var Min, Max, Signed: OLEVariant);
    Procedure IpNormalize(Min: Integer);
    Procedure IpPromoteTo16Gray(Bits, HighBit: Smallint);
    Procedure IpReduceDepthWithDownshift(Downshift: Smallint);
    Procedure IpReduceDepthWithLUT(Var LUT, Entries: OLEVariant);
    Procedure IpWindowLevel(Min, Max: Integer; Var Reserved: OLEVariant);
    Procedure IpWindowLevelAuto(Var Reserved, Min, Max, Signed: OLEVariant);
    Procedure Version;
    Procedure DcmDsBitsGet(Var BitsAllocated, BitsStored, HighBit, SamplesPerPix: OLEVariant);
    Procedure IpHighBitTransform(Min: Smallint);
    Procedure IpSwapBytes;
    Procedure DcmLoadDicom(Const Filename: WideString; Syntax: Smallint; PageNumber: Integer);
    Procedure DcmDsTsGet(Var TransferSyntax: OLEVariant);
    Procedure DcmDsTsSet(TransferSyntax: Smallint);
    Procedure DisplayContrast(RescaleSlope, RescaleIntercept: Double; WindowCenter, WindowWidth: Integer; Gamma: Double);
    Procedure UtilOptionLevelGet(Var OptionCode, OptionString, Eval: OLEVariant);
    Procedure DcmDsRescaleGet(Var RescaleSlope, RescaleIntercept, Found: OLEVariant);
    Procedure DcmDsWindowLevelGet(Var WindowWidth, WindowCenter, Found: OLEVariant);
    Procedure DcmDsPixPadValSet(UsePixPadding: WordBool; PixPaddingVal: Integer; ShowPpvAs: Smallint);
    Procedure DcmDsPixPadValGet(Var UsePixPadding, PixPaddingVal, ShowPpvAs: OLEVariant);
    Procedure DisplayColorSet(Var RLut, GLut, BLut: OLEVariant);
    Procedure DisplayColorCreate(Scheme: Smallint; Param1, Param2, Param3: Integer; Var RLut, GLut, BLut: OLEVariant);
    Procedure DisplayContrastAuto(RescaleSlope, RescaleIntercept, Gamma: Double; Var Reserved, WindowCenter, WindowWidth: OLEVariant);
    Procedure IpContrast(RescaleSlope, RescaleIntercept: Double; WindowCenter, WindowWidth: Integer; Gamma: Double);
    Procedure IpContrastAuto(RescaleSlope, RescaleIntercept, Gamma: Double; Var Reserved, WindowCenter, WindowWidth: OLEVariant);
    Procedure AboutBox;
    Property ControlInterface: _DMedx Read FIntf;
  Published
    Property DestGearControl: WideString Index 1 Read GetWideStringProp Write SetWideStringProp Stored False;
    Property _DestGearControl: WideString Index 0 Read GetWideStringProp Write SetWideStringProp Stored False;
    Property DestGearControlInterface: IDispatch Index 2 Read GetIDispatchProp Write SetIDispatchProp Stored False;
  End;

Procedure Register;

Implementation

Uses ComObj;

Procedure TMed.InitControlData;
Const
  CLicenseKey: Array[0..62] Of Word = (
    $0049, $006D, $0061, $0067, $0065, $0047, $0065, $0061, $0072, $002D,
    $004D, $0065, $0064, $0069, $0063, $0061, $006C, $0020, $0045, $0078,
    $0074, $0065, $006E, $0073, $0069, $006F, $006E, $0020, $004F, $0043,
    $0058, $002D, $0033, $0032, $0020, $0043, $006F, $0070, $0079, $0072,
    $0069, $0067, $0068, $0074, $0020, $0028, $0063, $0029, $0020, $0031,
    $0039, $0039, $0037, $0020, $0041, $0063, $0063, $0075, $0053, $006F,
    $0066, $0074, $0000);
  CControlData: TControlData = (
    ClassID: '{3B599F67-DB45-11D0-A093-DEF744F91B14}';
    EventIID: '';
    EventCount: 0;
    EventDispIDs: Nil;
    LicenseKey: @CLicenseKey;
    Flags: $00000000;
    Version: 300;
    FontCount: 0;
    FontIDs: Nil);
Begin
  ControlData := @CControlData;
End;

Procedure TMed.InitControlInterface(Const Obj: IUnknown);
Begin
  FIntf := Obj As _DMedx;
End;

Procedure TMed.DcmDsCreate(Ts: Smallint);
Begin
  ControlInterface.DcmDsCreate(Ts);
End;

Procedure TMed.DcmDsCurrDataGet(Var Data, SizeOfData, SizeOfItem: OLEVariant);
Var
  VaData, VaSizeOfData, VaSizeOfItem: OLEVariant;
Begin

  TVarData(VaData).VType := VarVariant Or VarByRef;
  TVarData(VaData).VPointer := Addr(Data);

  TVarData(VaSizeOfData).VType := VarVariant Or VarByRef;
  TVarData(VaSizeOfData).VPointer := Addr(SizeOfData);

  TVarData(VaSizeOfItem).VType := VarVariant Or VarByRef;
  TVarData(VaSizeOfItem).VPointer := Addr(SizeOfItem);

  ControlInterface.DcmDsCurrDataGet(VaData, VaSizeOfData, VaSizeOfItem);

End;

Procedure TMed.DcmDsCurrDataGetString(Var StrResult: OLEVariant; SizeOfString: Integer);
Var
  VaStrResult: OLEVariant;
Begin

  TVarData(VaStrResult).VType := VarVariant Or VarByRef;
  TVarData(VaStrResult).VPointer := Addr(StrResult);

  ControlInterface.DcmDsCurrDataGetString(VaStrResult, SizeOfString);

End;

Procedure TMed.DcmDsCurrDataSet(Var Data: OLEVariant; SizeOfData: Integer);
Var
  VaData: OLEVariant;
Begin

  TVarData(VaData).VType := VarVariant Or VarByRef;
  TVarData(VaData).VPointer := Addr(Data);

  ControlInterface.DcmDsCurrDataSet(VaData, SizeOfData);

End;

Procedure TMed.DcmDsCurrIndexGet(Var Index: OLEVariant);
Var
  VaIndex: OLEVariant;
Begin

  TVarData(VaIndex).VType := VarVariant Or VarByRef;
  TVarData(VaIndex).VPointer := Addr(Index);

  ControlInterface.DcmDsCurrIndexGet(VaIndex);

End;

Procedure TMed.DcmDsCurrInfoGet(Var Tag, VR, Vl, Level, ItemCount: OLEVariant);
Var
  VaTag, VaVR, VaVL, VaLevel, VaItemCount: OLEVariant;
Begin

  TVarData(VaTag).VType := VarVariant Or VarByRef;
  TVarData(VaTag).VPointer := Addr(Tag);

  TVarData(VaVR).VType := VarVariant Or VarByRef;
  TVarData(VaVR).VPointer := Addr(VR);

  TVarData(VaVL).VType := VarVariant Or VarByRef;
  TVarData(VaVL).VPointer := Addr(Vl);

  TVarData(VaLevel).VType := VarVariant Or VarByRef;
  TVarData(VaLevel).VPointer := Addr(Level);

  TVarData(VaItemCount).VType := VarVariant Or VarByRef;
  TVarData(VaItemCount).VPointer := Addr(ItemCount);

  ControlInterface.DcmDsCurrInfoGet(VaTag, VaVR, VaVL, VaLevel, VaItemCount);

End;

Procedure TMed.DcmDsCurrRemove(Var Removed: OLEVariant);
Var
  VaRemoved: OLEVariant;
Begin

  TVarData(VaRemoved).VType := VarVariant Or VarByRef;
  TVarData(VaRemoved).VPointer := Addr(Removed);

  ControlInterface.DcmDsCurrRemove(VaRemoved);

End;

Procedure TMed.DcmDsDeInsert(Tag: Integer; VR: Smallint; Var Data: OLEVariant; SizeOfData: Integer);
Var
  VaData: OLEVariant;
Begin

  TVarData(VaData).VType := VarVariant Or VarByRef;
  TVarData(VaData).VPointer := Addr(Data);

  ControlInterface.DcmDsDeInsert(Tag, VR, VaData, SizeOfData);

End;

Procedure TMed.DcmDsDestroy;
Begin
  ControlInterface.DcmDsDestroy;
End;

Procedure TMed.DcmDsExists(Var Exists: OLEVariant);
Var
  VaExists: OLEVariant;
Begin

  TVarData(VaExists).VType := VarVariant Or VarByRef;
  TVarData(VaExists).VPointer := Addr(Exists);

  ControlInterface.DcmDsExists(VaExists);

End;

Procedure TMed.DcmDsInfoGet(Var NumTags, MaxLevel: OLEVariant);
Var
  VaNumTags, VaMaxLevel: OLEVariant;
Begin

  TVarData(VaNumTags).VType := VarVariant Or VarByRef;
  TVarData(VaNumTags).VPointer := Addr(NumTags);

  TVarData(VaMaxLevel).VType := VarVariant Or VarByRef;
  TVarData(VaMaxLevel).VPointer := Addr(MaxLevel);

  ControlInterface.DcmDsInfoGet(VaNumTags, VaMaxLevel);

End;

Procedure TMed.DcmDsIsEmpty(Var Empty: OLEVariant);
Var
  VaEmpty: OLEVariant;
Begin

  TVarData(VaEmpty).VType := VarVariant Or VarByRef;
  TVarData(VaEmpty).VPointer := Addr(Empty);

  ControlInterface.DcmDsIsEmpty(VaEmpty);

End;

Procedure TMed.DcmDsMoveAscend(Var Tag, VR, Vl, Level, ItemCount: OLEVariant);
Var
  VaTag, VaVR, VaVL, VaLevel, VaItemCount: OLEVariant;
Begin

  TVarData(VaTag).VType := VarVariant Or VarByRef;
  TVarData(VaTag).VPointer := Addr(Tag);

  TVarData(VaVR).VType := VarVariant Or VarByRef;
  TVarData(VaVR).VPointer := Addr(VR);

  TVarData(VaVL).VType := VarVariant Or VarByRef;
  TVarData(VaVL).VPointer := Addr(Vl);

  TVarData(VaLevel).VType := VarVariant Or VarByRef;
  TVarData(VaLevel).VPointer := Addr(Level);

  TVarData(VaItemCount).VType := VarVariant Or VarByRef;
  TVarData(VaItemCount).VPointer := Addr(ItemCount);

  ControlInterface.DcmDsMoveAscend(VaTag, VaVR, VaVL, VaLevel, VaItemCount);

End;

Procedure TMed.DcmDsMoveDescend(Var Tag, VR, Vl, Level, ItemCount: OLEVariant);
Var
  VaTag, VaVR, VaVL, VaLevel, VaItemCount: OLEVariant;
Begin

  TVarData(VaTag).VType := VarVariant Or VarByRef;
  TVarData(VaTag).VPointer := Addr(Tag);

  TVarData(VaVR).VType := VarVariant Or VarByRef;
  TVarData(VaVR).VPointer := Addr(VR);

  TVarData(VaVL).VType := VarVariant Or VarByRef;
  TVarData(VaVL).VPointer := Addr(Vl);

  TVarData(VaLevel).VType := VarVariant Or VarByRef;
  TVarData(VaLevel).VPointer := Addr(Level);

  TVarData(VaItemCount).VType := VarVariant Or VarByRef;
  TVarData(VaItemCount).VPointer := Addr(ItemCount);

  ControlInterface.DcmDsMoveDescend(VaTag, VaVR, VaVL, VaLevel, VaItemCount);

End;

Procedure TMed.DcmDsMoveFind(LevelOp: Smallint; Var Tag, VR, Vl, Level, ItemCount, TagFound: OLEVariant);
Var
  VaTag, VaVR, VaVL, VaLevel, VaItemCount, VaTagFound: OLEVariant;
Begin

  TVarData(VaTag).VType := VarVariant Or VarByRef;
  TVarData(VaTag).VPointer := Addr(Tag);

  TVarData(VaVR).VType := VarVariant Or VarByRef;
  TVarData(VaVR).VPointer := Addr(VR);

  TVarData(VaVL).VType := VarVariant Or VarByRef;
  TVarData(VaVL).VPointer := Addr(Vl);

  TVarData(VaLevel).VType := VarVariant Or VarByRef;
  TVarData(VaLevel).VPointer := Addr(Level);

  TVarData(VaItemCount).VType := VarVariant Or VarByRef;
  TVarData(VaItemCount).VPointer := Addr(ItemCount);

  TVarData(VaTagFound).VType := VarVariant Or VarByRef;
  TVarData(VaTagFound).VPointer := Addr(TagFound);

  ControlInterface.DcmDsMoveFind(LevelOp, VaTag, VaVR, VaVL, VaLevel, VaItemCount, VaTagFound);

End;

Procedure TMed.DcmDsMoveFindFirst(LevelOp, GroupNum: Smallint; Var VR, Vl, Level, ItemCount, TagFound: OLEVariant);
Var
  VaVR, VaVL, VaLevel, VaItemCount, VaTagFound: OLEVariant;
Begin

  TVarData(VaVR).VType := VarVariant Or VarByRef;
  TVarData(VaVR).VPointer := Addr(VR);

  TVarData(VaVL).VType := VarVariant Or VarByRef;
  TVarData(VaVL).VPointer := Addr(Vl);

  TVarData(VaLevel).VType := VarVariant Or VarByRef;
  TVarData(VaLevel).VPointer := Addr(Level);

  TVarData(VaItemCount).VType := VarVariant Or VarByRef;
  TVarData(VaItemCount).VPointer := Addr(ItemCount);

  TVarData(VaTagFound).VType := VarVariant Or VarByRef;
  TVarData(VaTagFound).VPointer := Addr(TagFound);

  ControlInterface.DcmDsMoveFindFirst(LevelOp, GroupNum, VaVR, VaVL, VaLevel, VaItemCount, VaTagFound);

End;

Procedure TMed.DcmDsMoveFirst(LevelOp: Smallint; Var Tag, VR, Vl, Level, ItemCount: OLEVariant);
Var
  VaTag, VaVR, VaVL, VaLevel, VaItemCount: OLEVariant;
Begin

  TVarData(VaTag).VType := VarVariant Or VarByRef;
  TVarData(VaTag).VPointer := Addr(Tag);

  TVarData(VaVR).VType := VarVariant Or VarByRef;
  TVarData(VaVR).VPointer := Addr(VR);

  TVarData(VaVL).VType := VarVariant Or VarByRef;
  TVarData(VaVL).VPointer := Addr(Vl);

  TVarData(VaLevel).VType := VarVariant Or VarByRef;
  TVarData(VaLevel).VPointer := Addr(Level);

  TVarData(VaItemCount).VType := VarVariant Or VarByRef;
  TVarData(VaItemCount).VPointer := Addr(ItemCount);

  ControlInterface.DcmDsMoveFirst(LevelOp, VaTag, VaVR, VaVL, VaLevel, VaItemCount);

End;

Procedure TMed.DcmDsMoveIndex(Index: Integer; Var Tag, VR, Vl, Level, ItemCount: OLEVariant);
Var
  VaTag, VaVR, VaVL, VaLevel, VaItemCount: OLEVariant;
Begin

  TVarData(VaTag).VType := VarVariant Or VarByRef;
  TVarData(VaTag).VPointer := Addr(Tag);

  TVarData(VaVR).VType := VarVariant Or VarByRef;
  TVarData(VaVR).VPointer := Addr(VR);

  TVarData(VaVL).VType := VarVariant Or VarByRef;
  TVarData(VaVL).VPointer := Addr(Vl);

  TVarData(VaLevel).VType := VarVariant Or VarByRef;
  TVarData(VaLevel).VPointer := Addr(Level);

  TVarData(VaItemCount).VType := VarVariant Or VarByRef;
  TVarData(VaItemCount).VPointer := Addr(ItemCount);

  ControlInterface.DcmDsMoveIndex(Index, VaTag, VaVR, VaVL, VaLevel, VaItemCount);

End;

Procedure TMed.DcmDsMoveLast(LevelOp: Smallint; Var Tag, VR, Vl, Level, ItemCount: OLEVariant);
Var
  VaTag, VaVR, VaVL, VaLevel, VaItemCount: OLEVariant;
Begin

  TVarData(VaTag).VType := VarVariant Or VarByRef;
  TVarData(VaTag).VPointer := Addr(Tag);

  TVarData(VaVR).VType := VarVariant Or VarByRef;
  TVarData(VaVR).VPointer := Addr(VR);

  TVarData(VaVL).VType := VarVariant Or VarByRef;
  TVarData(VaVL).VPointer := Addr(Vl);

  TVarData(VaLevel).VType := VarVariant Or VarByRef;
  TVarData(VaLevel).VPointer := Addr(Level);

  TVarData(VaItemCount).VType := VarVariant Or VarByRef;
  TVarData(VaItemCount).VPointer := Addr(ItemCount);

  ControlInterface.DcmDsMoveLast(LevelOp, VaTag, VaVR, VaVL, VaLevel, VaItemCount);

End;

Procedure TMed.DcmDsMoveNext(LevelOp: Smallint; Var Tag, VR, Vl, Level, ItemCount, NumRemaining: OLEVariant);
Var
  VaTag, VaVR, VaVL, VaLevel, VaItemCount, VaNumRemaining: OLEVariant;
Begin

  TVarData(VaTag).VType := VarVariant Or VarByRef;
  TVarData(VaTag).VPointer := Addr(Tag);

  TVarData(VaVR).VType := VarVariant Or VarByRef;
  TVarData(VaVR).VPointer := Addr(VR);

  TVarData(VaVL).VType := VarVariant Or VarByRef;
  TVarData(VaVL).VPointer := Addr(Vl);

  TVarData(VaLevel).VType := VarVariant Or VarByRef;
  TVarData(VaLevel).VPointer := Addr(Level);

  TVarData(VaItemCount).VType := VarVariant Or VarByRef;
  TVarData(VaItemCount).VPointer := Addr(ItemCount);

  TVarData(VaNumRemaining).VType := VarVariant Or VarByRef;
  TVarData(VaNumRemaining).VPointer := Addr(NumRemaining);

  ControlInterface.DcmDsMoveNext(LevelOp, VaTag, VaVR, VaVL, VaLevel, VaItemCount, VaNumRemaining);

End;

Procedure TMed.DcmDsMovePrev(LevelOp: Smallint; Var Tag, VR, Vl, Level, ItemCount, NumRemaining: OLEVariant);
Var
  VaTag, VaVR, VaVL, VaLevel, VaItemCount, VaNumRemaining: OLEVariant;
Begin

  TVarData(VaTag).VType := VarVariant Or VarByRef;
  TVarData(VaTag).VPointer := Addr(Tag);

  TVarData(VaVR).VType := VarVariant Or VarByRef;
  TVarData(VaVR).VPointer := Addr(VR);

  TVarData(VaVL).VType := VarVariant Or VarByRef;
  TVarData(VaVL).VPointer := Addr(Vl);

  TVarData(VaLevel).VType := VarVariant Or VarByRef;
  TVarData(VaLevel).VPointer := Addr(Level);

  TVarData(VaItemCount).VType := VarVariant Or VarByRef;
  TVarData(VaItemCount).VPointer := Addr(ItemCount);

  TVarData(VaNumRemaining).VType := VarVariant Or VarByRef;
  TVarData(VaNumRemaining).VPointer := Addr(NumRemaining);

  ControlInterface.DcmDsMovePrev(LevelOp, VaTag, VaVR, VaVL, VaLevel, VaItemCount, VaNumRemaining);

End;

Procedure TMed.DcmDsOrigTsGet(Var OrigTS, IsPart10, GrpLengths: OLEVariant);
Var
  VaOrigTS, VaIsPart10, VaGrpLengths: OLEVariant;
Begin

  TVarData(VaOrigTS).VType := VarVariant Or VarByRef;
  TVarData(VaOrigTS).VPointer := Addr(OrigTS);

  TVarData(VaIsPart10).VType := VarVariant Or VarByRef;
  TVarData(VaIsPart10).VPointer := Addr(IsPart10);

  TVarData(VaGrpLengths).VType := VarVariant Or VarByRef;
  TVarData(VaGrpLengths).VPointer := Addr(GrpLengths);

  ControlInterface.DcmDsOrigTsGet(VaOrigTS, VaIsPart10, VaGrpLengths);

End;

Procedure TMed.DcmDsPart10Get(Part10Item: Smallint; SizeOfData: Integer; Var Data, SizeOfItem: OLEVariant);
Var
  VaData, VaSizeOfItem: OLEVariant;
Begin

  TVarData(VaData).VType := VarVariant Or VarByRef;
  TVarData(VaData).VPointer := Addr(Data);

  TVarData(VaSizeOfItem).VType := VarVariant Or VarByRef;
  TVarData(VaSizeOfItem).VPointer := Addr(SizeOfItem);

  ControlInterface.DcmDsPart10Get(Part10Item, SizeOfData, VaData, VaSizeOfItem);

End;

Procedure TMed.DcmDsPart10Set(Part10Item: Integer; Var Data: OLEVariant; Vl: Integer);
Var
  VaData: OLEVariant;
Begin

  TVarData(VaData).VType := VarVariant Or VarByRef;
  TVarData(VaData).VPointer := Addr(Data);

  ControlInterface.DcmDsPart10Set(Part10Item, VaData, Vl);

End;

Procedure TMed.DcmDsPreambleGet(Var Preamble: OLEVariant);
Var
  VaPreamble: OLEVariant;
Begin

  TVarData(VaPreamble).VType := VarVariant Or VarByRef;
  TVarData(VaPreamble).VPointer := Addr(Preamble);

  ControlInterface.DcmDsPreambleGet(VaPreamble);

End;

Procedure TMed.DcmDsPreambleSet(Const Preamble: WideString; BytesInPreamble: Integer);
Begin
  ControlInterface.DcmDsPreambleSet(Preamble, BytesInPreamble);
End;

Procedure TMed.DcmSaveDicom(Const Filename: WideString; Syntax: Smallint; IncludeGroupLengths, SaveAsPart10: WordBool; PlanarConfiguration: Smallint; InludeSmallestLargest: WordBool; JPEGQuality:
  Smallint; Var Reserved: OLEVariant);
Var
  VaReserved: OLEVariant;
Begin

  TVarData(VaReserved).VType := VarVariant Or VarByRef;
  TVarData(VaReserved).VPointer := Addr(Reserved);

  ControlInterface.DcmSaveDicom(Filename, Syntax, IncludeGroupLengths, SaveAsPart10, PlanarConfiguration, InludeSmallestLargest, JPEGQuality, VaReserved);

End;

Function TMed.DcmUtilDataToString(Var Data: OLEVariant; VR: Smallint; Vl: Integer; FirstItem, LastItem: Smallint; Var String_: OLEVariant; StringLen: Integer; Separator: Smallint): WordBool;
Var
  VaData, VaString_: OLEVariant;
Begin

  TVarData(VaData).VType := VarVariant Or VarByRef;
  TVarData(VaData).VPointer := Addr(Data);

  TVarData(VaString_).VType := VarVariant Or VarByRef;
  TVarData(VaString_).VPointer := Addr(String_);

  Result := ControlInterface.DcmUtilDataToString(VaData, VR, Vl, FirstItem, LastItem, VaString_, StringLen, Separator);

End;

Function TMed.DcmUtilTagInfoAdd(Tag: Integer; VR, Vm, Version: Smallint; Const TagName: WideString): WordBool;
Begin
  Result := ControlInterface.DcmUtilTagInfoAdd(Tag, VR, Vm, Version, TagName);
End;

Function TMed.DcmUtilTagInfoFree: WordBool;
Begin
  Result := ControlInterface.DcmUtilTagInfoFree;
End;

Function TMed.DcmUtilTagInfoGet(Tag: Integer; Var VR, Vm, Version, TagName: OLEVariant): WordBool;
Var
  VaVR, VaVm, VaVersion, VaTagName: OLEVariant;
Begin

  TVarData(VaVR).VType := VarVariant Or VarByRef;
  TVarData(VaVR).VPointer := Addr(VR);

  TVarData(VaVm).VType := VarVariant Or VarByRef;
  TVarData(VaVm).VPointer := Addr(Vm);

  TVarData(VaVersion).VType := VarVariant Or VarByRef;
  TVarData(VaVersion).VPointer := Addr(Version);

  TVarData(VaTagName).VType := VarVariant Or VarByRef;
  TVarData(VaTagName).VPointer := Addr(TagName);

  Result := ControlInterface.DcmUtilTagInfoGet(Tag, VaVR, VaVm, VaVersion, VaTagName);

End;

Procedure TMed.DcmUtilVrInfoMode(VrMode: Smallint; Var VrString, Length, Restriction, CheckForm, IsString: OLEVariant);
Var
  VaVrString, VaLength, VaRestriction, VaCheckForm, VaIsString: OLEVariant;
Begin

  TVarData(VaVrString).VType := VarVariant Or VarByRef;
  TVarData(VaVrString).VPointer := Addr(VrString);

  TVarData(VaLength).VType := VarVariant Or VarByRef;
  TVarData(VaLength).VPointer := Addr(Length);

  TVarData(VaRestriction).VType := VarVariant Or VarByRef;
  TVarData(VaRestriction).VPointer := Addr(Restriction);

  TVarData(VaCheckForm).VType := VarVariant Or VarByRef;
  TVarData(VaCheckForm).VPointer := Addr(CheckForm);

  TVarData(VaIsString).VType := VarVariant Or VarByRef;
  TVarData(VaIsString).VPointer := Addr(IsString);

  ControlInterface.DcmUtilVrInfoMode(VrMode, VaVrString, VaLength, VaRestriction, VaCheckForm, VaIsString);

End;

Procedure TMed.DcmUtilVrInfoString(Const VrString: WideString; Var Length, Restriction, Reserved, IsString, VrMode: OLEVariant);
Var
  VaLength, VaRestriction, VaReserved, VaIsString, VaVrMode: OLEVariant;
Begin

  TVarData(VaLength).VType := VarVariant Or VarByRef;
  TVarData(VaLength).VPointer := Addr(Length);

  TVarData(VaRestriction).VType := VarVariant Or VarByRef;
  TVarData(VaRestriction).VPointer := Addr(Restriction);

  TVarData(VaReserved).VType := VarVariant Or VarByRef;
  TVarData(VaReserved).VPointer := Addr(Reserved);

  TVarData(VaIsString).VType := VarVariant Or VarByRef;
  TVarData(VaIsString).VPointer := Addr(IsString);

  TVarData(VaVrMode).VType := VarVariant Or VarByRef;
  TVarData(VaVrMode).VPointer := Addr(VrMode);

  ControlInterface.DcmUtilVrInfoString(VrString, VaLength, VaRestriction, VaReserved, VaIsString, VaVrMode);

End;

Procedure TMed.DisplayColorLimits(ThreshLow, LowRed, LowGreen, LowBlue, ThreshHigh, HighRed, HighGreen, HighBlue: Smallint);
Begin
  ControlInterface.DisplayColorLimits(ThreshLow, LowRed, LowGreen, LowBlue, ThreshHigh, HighRed, HighGreen, HighBlue);
End;

Procedure TMed.DisplayRescale(Slope, Intercept: Double; Var Reserved: OLEVariant);
Var
  VaReserved: OLEVariant;
Begin

  TVarData(VaReserved).VType := VarVariant Or VarByRef;
  TVarData(VaReserved).VPointer := Addr(Reserved);

  ControlInterface.DisplayRescale(Slope, Intercept, VaReserved);

End;

Procedure TMed.DisplayWindowLevel(Min, Max: Integer; Var Reserved: OLEVariant);
Var
  VaReserved: OLEVariant;
Begin

  TVarData(VaReserved).VType := VarVariant Or VarByRef;
  TVarData(VaReserved).VPointer := Addr(Reserved);

  ControlInterface.DisplayWindowLevel(Min, Max, VaReserved);

End;

Procedure TMed.DisplayWindowLevelAuto(Var Reserved, Min, Max, Signed: OLEVariant);
Var
  VaReserved, VaMin, VaMax, VaSigned: OLEVariant;
Begin

  TVarData(VaReserved).VType := VarVariant Or VarByRef;
  TVarData(VaReserved).VPointer := Addr(Reserved);

  TVarData(VaMin).VType := VarVariant Or VarByRef;
  TVarData(VaMin).VPointer := Addr(Min);

  TVarData(VaMax).VType := VarVariant Or VarByRef;
  TVarData(VaMax).VPointer := Addr(Max);

  TVarData(VaSigned).VType := VarVariant Or VarByRef;
  TVarData(VaSigned).VPointer := Addr(Signed);

  ControlInterface.DisplayWindowLevelAuto(VaReserved, VaMin, VaMax, VaSigned);

End;

Procedure TMed.IpHistoClear(Var Histo: OLEVariant; BinCount: Integer);
Var
  VaHisto: OLEVariant;
Begin

  TVarData(VaHisto).VType := VarVariant Or VarByRef;
  TVarData(VaHisto).VPointer := Addr(Histo);

  ControlInterface.IpHistoClear(VaHisto, BinCount);

End;

Procedure TMed.IpHistoTabulate(Var Histo: OLEVariant; BinWidth: Smallint; BinCount: Integer; Var Signed, Count: OLEVariant);
Var
  VaHisto, VaSigned, VaCount: OLEVariant;
Begin

  TVarData(VaHisto).VType := VarVariant Or VarByRef;
  TVarData(VaHisto).VPointer := Addr(Histo);

  TVarData(VaSigned).VType := VarVariant Or VarByRef;
  TVarData(VaSigned).VPointer := Addr(Signed);

  TVarData(VaCount).VType := VarVariant Or VarByRef;
  TVarData(VaCount).VPointer := Addr(Count);

  ControlInterface.IpHistoTabulate(VaHisto, BinWidth, BinCount, VaSigned, VaCount);

End;

Procedure TMed.Ipminmax(Var Min, Max, Signed: OLEVariant);
Var
  VaMin, VaMax, VaSigned: OLEVariant;
Begin

  TVarData(VaMin).VType := VarVariant Or VarByRef;
  TVarData(VaMin).VPointer := Addr(Min);

  TVarData(VaMax).VType := VarVariant Or VarByRef;
  TVarData(VaMax).VPointer := Addr(Max);

  TVarData(VaSigned).VType := VarVariant Or VarByRef;
  TVarData(VaSigned).VPointer := Addr(Signed);

  ControlInterface.Ipminmax(VaMin, VaMax, VaSigned);

End;

Procedure TMed.IpNormalize(Min: Integer);
Begin
  ControlInterface.IpNormalize(Min);
End;

Procedure TMed.IpPromoteTo16Gray(Bits, HighBit: Smallint);
Begin
  ControlInterface.IpPromoteTo16Gray(Bits, HighBit);
End;

Procedure TMed.IpReduceDepthWithDownshift(Downshift: Smallint);
Begin
  ControlInterface.IpReduceDepthWithDownshift(Downshift);
End;

Procedure TMed.IpReduceDepthWithLUT(Var LUT, Entries: OLEVariant);
Var
  VaLUT, VaEntries: OLEVariant;
Begin

  TVarData(VaLUT).VType := VarVariant Or VarByRef;
  TVarData(VaLUT).VPointer := Addr(LUT);

  TVarData(VaEntries).VType := VarVariant Or VarByRef;
  TVarData(VaEntries).VPointer := Addr(Entries);

  ControlInterface.IpReduceDepthWithLUT(VaLUT, VaEntries);

End;

Procedure TMed.IpWindowLevel(Min, Max: Integer; Var Reserved: OLEVariant);
Var
  VaReserved: OLEVariant;
Begin

  TVarData(VaReserved).VType := VarVariant Or VarByRef;
  TVarData(VaReserved).VPointer := Addr(Reserved);

  ControlInterface.IpWindowLevel(Min, Max, VaReserved);

End;

Procedure TMed.IpWindowLevelAuto(Var Reserved, Min, Max, Signed: OLEVariant);
Var
  VaReserved, VaMin, VaMax, VaSigned: OLEVariant;
Begin

  TVarData(VaReserved).VType := VarVariant Or VarByRef;
  TVarData(VaReserved).VPointer := Addr(Reserved);

  TVarData(VaMin).VType := VarVariant Or VarByRef;
  TVarData(VaMin).VPointer := Addr(Min);

  TVarData(VaMax).VType := VarVariant Or VarByRef;
  TVarData(VaMax).VPointer := Addr(Max);

  TVarData(VaSigned).VType := VarVariant Or VarByRef;
  TVarData(VaSigned).VPointer := Addr(Signed);

  ControlInterface.IpWindowLevelAuto(VaReserved, VaMin, VaMax, VaSigned);

End;

Procedure TMed.Version;
Begin
  ControlInterface.Version;
End;

Procedure TMed.DcmDsBitsGet(Var BitsAllocated, BitsStored, HighBit, SamplesPerPix: OLEVariant);
Var
  VaBitsAllocated, VaBitsStored, VaHighBit, VaSamplesPerPix: OLEVariant;
Begin

  TVarData(VaBitsAllocated).VType := VarVariant Or VarByRef;
  TVarData(VaBitsAllocated).VPointer := Addr(BitsAllocated);

  TVarData(VaBitsStored).VType := VarVariant Or VarByRef;
  TVarData(VaBitsStored).VPointer := Addr(BitsStored);

  TVarData(VaHighBit).VType := VarVariant Or VarByRef;
  TVarData(VaHighBit).VPointer := Addr(HighBit);

  TVarData(VaSamplesPerPix).VType := VarVariant Or VarByRef;
  TVarData(VaSamplesPerPix).VPointer := Addr(SamplesPerPix);

  ControlInterface.DcmDsBitsGet(VaBitsAllocated, VaBitsStored, VaHighBit, VaSamplesPerPix);

End;

Procedure TMed.IpHighBitTransform(Min: Smallint);
Begin
  ControlInterface.IpHighBitTransform(Min);
End;

Procedure TMed.IpSwapBytes;
Begin
  ControlInterface.IpSwapBytes;
End;

Procedure TMed.DcmLoadDicom(Const Filename: WideString; Syntax: Smallint; PageNumber: Integer);
Begin
  ControlInterface.DcmLoadDicom(Filename, Syntax, PageNumber);
End;

Procedure TMed.DcmDsTsGet(Var TransferSyntax: OLEVariant);
Var
  VaTransferSyntax: OLEVariant;
Begin

  TVarData(VaTransferSyntax).VType := VarVariant Or VarByRef;
  TVarData(VaTransferSyntax).VPointer := Addr(TransferSyntax);

  ControlInterface.DcmDsTsGet(VaTransferSyntax);

End;

Procedure TMed.DcmDsTsSet(TransferSyntax: Smallint);
Begin
  ControlInterface.DcmDsTsSet(TransferSyntax);
End;

Procedure TMed.DisplayContrast(RescaleSlope, RescaleIntercept: Double; WindowCenter, WindowWidth: Integer; Gamma: Double);
Begin
  ControlInterface.DisplayContrast(RescaleSlope, RescaleIntercept, WindowCenter, WindowWidth, Gamma);
End;

Procedure TMed.UtilOptionLevelGet(Var OptionCode, OptionString, Eval: OLEVariant);
Var
  VaOptionCode, VaOptionString, VaEval: OLEVariant;
Begin

  TVarData(VaOptionCode).VType := VarVariant Or VarByRef;
  TVarData(VaOptionCode).VPointer := Addr(OptionCode);

  TVarData(VaOptionString).VType := VarVariant Or VarByRef;
  TVarData(VaOptionString).VPointer := Addr(OptionString);

  TVarData(VaEval).VType := VarVariant Or VarByRef;
  TVarData(VaEval).VPointer := Addr(Eval);

  ControlInterface.UtilOptionLevelGet(VaOptionCode, VaOptionString, VaEval);

End;

Procedure TMed.DcmDsRescaleGet(Var RescaleSlope, RescaleIntercept, Found: OLEVariant);
Var
  VaRescaleSlope, VaRescaleIntercept, VaFound: OLEVariant;
Begin

  TVarData(VaRescaleSlope).VType := VarVariant Or VarByRef;
  TVarData(VaRescaleSlope).VPointer := Addr(RescaleSlope);

  TVarData(VaRescaleIntercept).VType := VarVariant Or VarByRef;
  TVarData(VaRescaleIntercept).VPointer := Addr(RescaleIntercept);

  TVarData(VaFound).VType := VarVariant Or VarByRef;
  TVarData(VaFound).VPointer := Addr(Found);

  ControlInterface.DcmDsRescaleGet(VaRescaleSlope, VaRescaleIntercept, VaFound);

End;

Procedure TMed.DcmDsWindowLevelGet(Var WindowWidth, WindowCenter, Found: OLEVariant);
Var
  VaWindowWidth, VaWindowCenter, VaFound: OLEVariant;
Begin

  TVarData(VaWindowWidth).VType := VarVariant Or VarByRef;
  TVarData(VaWindowWidth).VPointer := Addr(WindowWidth);

  TVarData(VaWindowCenter).VType := VarVariant Or VarByRef;
  TVarData(VaWindowCenter).VPointer := Addr(WindowCenter);

  TVarData(VaFound).VType := VarVariant Or VarByRef;
  TVarData(VaFound).VPointer := Addr(Found);

  ControlInterface.DcmDsWindowLevelGet(VaWindowWidth, VaWindowCenter, VaFound);

End;

Procedure TMed.DcmDsPixPadValSet(UsePixPadding: WordBool; PixPaddingVal: Integer; ShowPpvAs: Smallint);
Begin
  ControlInterface.DcmDsPixPadValSet(UsePixPadding, PixPaddingVal, ShowPpvAs);
End;

Procedure TMed.DcmDsPixPadValGet(Var UsePixPadding, PixPaddingVal, ShowPpvAs: OLEVariant);
Var
  VaUsePixPadding, VaPixPaddingVal, VaShowPpvAs: OLEVariant;
Begin

  TVarData(VaUsePixPadding).VType := VarVariant Or VarByRef;
  TVarData(VaUsePixPadding).VPointer := Addr(UsePixPadding);

  TVarData(VaPixPaddingVal).VType := VarVariant Or VarByRef;
  TVarData(VaPixPaddingVal).VPointer := Addr(PixPaddingVal);

  TVarData(VaShowPpvAs).VType := VarVariant Or VarByRef;
  TVarData(VaShowPpvAs).VPointer := Addr(ShowPpvAs);

  ControlInterface.DcmDsPixPadValGet(VaUsePixPadding, VaPixPaddingVal, VaShowPpvAs);

End;

Procedure TMed.DisplayColorSet(Var RLut, GLut, BLut: OLEVariant);
Var
  VaRLut, VaGLut, VaBLut: OLEVariant;
Begin

  TVarData(VaRLut).VType := VarVariant Or VarByRef;
  TVarData(VaRLut).VPointer := Addr(RLut);

  TVarData(VaGLut).VType := VarVariant Or VarByRef;
  TVarData(VaGLut).VPointer := Addr(GLut);

  TVarData(VaBLut).VType := VarVariant Or VarByRef;
  TVarData(VaBLut).VPointer := Addr(BLut);

  ControlInterface.DisplayColorSet(VaRLut, VaGLut, VaBLut);

End;

Procedure TMed.DisplayColorCreate(Scheme: Smallint; Param1, Param2, Param3: Integer; Var RLut, GLut, BLut: OLEVariant);
Var
  VaRLut, VaGLut, VaBLut: OLEVariant;
Begin

  TVarData(VaRLut).VType := VarVariant Or VarByRef;
  TVarData(VaRLut).VPointer := Addr(RLut);

  TVarData(VaGLut).VType := VarVariant Or VarByRef;
  TVarData(VaGLut).VPointer := Addr(GLut);

  TVarData(VaBLut).VType := VarVariant Or VarByRef;
  TVarData(VaBLut).VPointer := Addr(BLut);

  ControlInterface.DisplayColorCreate(Scheme, Param1, Param2, Param3, VaRLut, VaGLut, VaBLut);

End;

Procedure TMed.DisplayContrastAuto(RescaleSlope, RescaleIntercept, Gamma: Double; Var Reserved, WindowCenter, WindowWidth: OLEVariant);
Var
  VaReserved, VaWindowCenter, VaWindowWidth: OLEVariant;
Begin

  TVarData(VaReserved).VType := VarVariant Or VarByRef;
  TVarData(VaReserved).VPointer := Addr(Reserved);

  TVarData(VaWindowCenter).VType := VarVariant Or VarByRef;
  TVarData(VaWindowCenter).VPointer := Addr(WindowCenter);

  TVarData(VaWindowWidth).VType := VarVariant Or VarByRef;
  TVarData(VaWindowWidth).VPointer := Addr(WindowWidth);

  ControlInterface.DisplayContrastAuto(RescaleSlope, RescaleIntercept, Gamma, VaReserved, VaWindowCenter, VaWindowWidth);

End;

Procedure TMed.IpContrast(RescaleSlope, RescaleIntercept: Double; WindowCenter, WindowWidth: Integer; Gamma: Double);
Begin
  ControlInterface.IpContrast(RescaleSlope, RescaleIntercept, WindowCenter, WindowWidth, Gamma);
End;

Procedure TMed.IpContrastAuto(RescaleSlope, RescaleIntercept, Gamma: Double; Var Reserved, WindowCenter, WindowWidth: OLEVariant);
Var
  VaReserved, VaWindowCenter, VaWindowWidth: OLEVariant;
Begin

  TVarData(VaReserved).VType := VarVariant Or VarByRef;
  TVarData(VaReserved).VPointer := Addr(Reserved);

  TVarData(VaWindowCenter).VType := VarVariant Or VarByRef;
  TVarData(VaWindowCenter).VPointer := Addr(WindowCenter);

  TVarData(VaWindowWidth).VType := VarVariant Or VarByRef;
  TVarData(VaWindowWidth).VPointer := Addr(WindowWidth);

  ControlInterface.IpContrastAuto(RescaleSlope, RescaleIntercept, Gamma, VaReserved, VaWindowCenter, VaWindowWidth);

End;

Procedure TMed.AboutBox;
Begin
  ControlInterface.AboutBox;
End;

Procedure Register;
Begin
  RegisterComponents('ActiveX', [TMed]);
{  RegisterNonActiveX([TMed]);}
End;

End.
