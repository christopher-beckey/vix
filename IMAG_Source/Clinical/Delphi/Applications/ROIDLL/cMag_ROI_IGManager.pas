{
  Package: MAG - VistA Imaging
  WARNING: Per VHA Directive 2004-038, this routine should not be modified.
  Date Created: January, 2007
  Site Name:  Washington OI Field Office, Silver Spring, MD
  Developer:  Julian Werfel
  Description:
    This is a manager of the ImageGear v15 components. Only 1 instance of each
    of these components is necessary in the application (for single threads).
    This manages the components and ensures only one instance is created

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
{/p117  this is from patch 117}

Unit cMag_ROI_IGManager;

Interface

Uses
  GearArtXGUILib_TLB,
  GearArtXLib_TLB,
  GearCORELib_TLB,
  GearDIALOGSLib_TLB,
  GearDISPLAYLib_TLB,
  GearEFFECTSLib_TLB,
  GearFORMATSLib_TLB,
  GearMEDLib_TLB,
  GearPDFLib_TLB,
  GearPROCESSINGLib_TLB,
  IGGUIDlgLib_TLB,
  IGGUIWinLib_TLB,
  VECTLib_TLB,
  OLE2  {Needed to allow me to coinitialize the ActiveX controls}
  ;



Type
  TMagIGManager = Class
  Protected
    FComponentCount: Integer;
    //*** BB 08/24/2010 'AllowTextFiles' gives deleoper ability to turn vieweing text files on for multi print, off otherwise***
    FAllowTextFiles: boolean;
    Function GetVersion: String;
    procedure SetAllowTextFiles(Value: boolean); //*** BB 08/24/2010 ***
  Public
    IGCoreCtrl: TIGCoreCtl;
    IGDisplayCtrl: TIGDisplayCtl;
    IGDlgsCtl: TIGDlgsCtl;
    IGEffectsCtl: TIGEffectsCtl;
    IGFormatsCtrl: TIGFormatsCtl;
    IGGUIDlgCtl: TIGGUIDlgCtl;
    IGGUIThumbnailCtl: TIGGUIThumbnailCtl;
    IGMedCtrl: TIGMedCtl;
    IGPdfCtrl: TIGPDFCtl;
    IGArtXCtrl: TIGArtXCtl;
    IGArtXGUICtrl: TIGArtXGUICtl;
    IGProcessingCtrl: TIGProcessingCtl;
    IGVectorCtrl: TIGVectorCtl;
    Constructor Create();
    Destructor Destroy(); Override;
    Procedure IncrementComponentCount();
    Procedure DecrementComponentCount();
    Property Version: String Read GetVersion;
    Property ComponentCount: Integer Read FComponentCount;
    Property AllowTextFiles: boolean Read FAllowTextFiles Write SetAllowTextFiles; //*** BB 08/24/2010 see above ***
    function CheckErrors: String;
  End;

Function GetIGManager(): TMagIGManager;
Procedure DestroyIGManager();
Function GetIGManagerComponentCount(): Integer;

Var
  MagIGManager: TMagIGManager;

Implementation
Uses
  Dialogs,
  SysUtils;

{Gets the number of components from IG Manager without creating one if it is nil
This is useful for determining if the IGManager should be destroyed without
creating an IGManager first}

Function GetIGManagerComponentCount(): Integer;
Begin
  Result := 0;
  If MagIGManager = Nil Then
    Exit;
  Result := GetIGManager().FComponentCount;
End;

{Get an IGManager, if it has not been created, make one}

Function GetIGManager(): TMagIGManager;
Begin
  If MagIGManager = Nil Then
    MagIGManager := TMagIGManager.Create();
  Result := MagIGManager;
End;

{Destroy the IG Manager (if it is not nil)}

Procedure DestroyIGManager();
Begin
  If MagIGManager <> Nil Then
  Begin
    MagIGManager.Free;
    MagIGManager := Nil;
  End;
End;

{Destructor to free all the ImageGear resources}

Destructor TMagIGManager.Destroy();
Begin
  FreeAndNil(IGCoreCtrl);
  FreeAndNil(IGDisplayCtrl);
  FreeAndNil(IGDlgsCtl);
  FreeAndNil(IGEffectsCtl);
  FreeAndNil(IGFormatsCtrl);
  FreeAndNil(IGGUIDlgCtl);
  FreeAndNil(IGGUIThumbnailCtl);
  FreeAndNil(IGMedCtrl);
  FreeAndNil(IGPdfCtrl);
  FreeAndNil(IGArtXCtrl);
  FreeAndNil(IGArtXGUICtrl);
  FreeAndNil(IGProcessingCtrl);
  FreeAndNil(IGVectorCtrl);
  Inherited;
End;

Function TMagIGManager.GetVersion: String;
Var
  IGComponentInfo: IIGComponentInfo;
Begin
  Result := 'unknown';
  IGComponentInfo := MagIGManager.IGCoreCtrl.GetComponentInfo(1);
  Result := Inttostr(IGComponentInfo.VersionMajor) + '.' + Inttostr(IGComponentInfo.VersionMinor);
End;

{Default constructor to create the ImageGear components and set the license
information }

Constructor TMagIGManager.Create();
Var
  Dcm: IGFormatParams;
  DevOnly: Boolean;
  i: Integer;
  IGComp: IIGComponent;
  LicenseKey: String;
  PARAM: IIGControlParameter;
  Temp: IGFormatParams;
Begin
  CoInitialize(nil);    {/ P130 - need to coinitialize the IG activeX controls when calling from Java /}

  DevOnly := False;

  IGCoreCtrl        := TIGCoreCtl.Create(Nil);
  IGCoreCtrl.Result.NotificationFlags := IG_ERR_OLE_ERROR;
  IGDisplayCtrl     := TIGDisplayCtl.Create(Nil);
  IGDlgsCtl         := TIGDlgsCtl.Create(Nil);
  IGEffectsCtl      := TIGEffectsCtl.Create(Nil);
  IGFormatsCtrl     := TIGFormatsCtl.Create(Nil);
  IGGUIDlgCtl       := TIGGUIDlgCtl.Create(Nil);
  IGGUIThumbnailCtl := TIGGUIThumbnailCtl.Create(Nil);
  IGMedCtrl         := TIGMedCtl.Create(Nil);
  IGPdfCtrl         := TIGPDFCtl.Create(Nil);
  IGProcessingCtrl  := TIGProcessingCtl.Create(Nil);
  IGVectorCtrl      := TIGVectorCtl.Create(Nil);

  IGArtXCtrl        := TIGArtXCtl.Create(Nil);
  IGArtXGUICtrl     := TIGArtXGUICtl.Create(Nil);


  LicenseKey := '1.0.ET9kIV3FZODo9cboBOmomEBTmOLE0fsEDc1fsYLURU3fbO0cDURcmoCNZUbkLd0oRO1O96Rf3cbdsUZEBfLVDpbFupua1aB6qo0TRVqO9OIaLc';
  LicenseKey := LicenseKey + 'RU0N1YCNBomOuE0f9EmcDN0Y1YIo3fLF9FCTRFmUIVDUZkR60TmpqFq63VIOB60URVBVuf1cDOqcIa96CkRUuU0VZF1OqasYLoZFL';
  LicenseKey := LicenseKey + 'oIVCTmOZE3NuE0pDfLoDUuU9NuObp1TCcIo9f9UZkskso1O9FIaqfRpsdCUqVBfBVRcuFBpbaR6LaDTRo9EuO3OBaCc0YmO3o1VqU';
  LicenseKey := LicenseKey + 'DO9Vsf1NCOBVsYLUuT0fsFuFLo9OuaqFqkZTqTu63NRfIaqN0FCTRd1pBFsEmpuOBcbdmkmkm6BdIcsf9NsY9V0YmO3oBEbUuPRpN';
  IGCoreCtrl.License.SetSolutionName('Vista');
  IGCoreCtrl.License.SetSolutionKey(-1107646725, -1654303302, -698410736, -1507856128);
  IGCoreCtrl.License.SetOEMLicenseKey(LicenseKey);


  IGCoreCtrl.AssociateComponent(IGFormatsCtrl.ComponentInterface);
  IGCoreCtrl.AssociateComponent(IGDisplayCtrl.ComponentInterface);
  IGCoreCtrl.AssociateComponent(IGProcessingCtrl.ComponentInterface);
  IGCoreCtrl.AssociateComponent(IGMedCtrl.ComponentInterface);
  IGCoreCtrl.AssociateComponent(IGPdfCtrl.ComponentInterface);
  IGCoreCtrl.AssociateComponent(IGVectorCtrl.ComponentInterface);
  IGCoreCtrl.AssociateComponent(IGArtXCtrl.ComponentInterface);
  IGCoreCtrl.AssociateComponent(IGEffectsCtl.ComponentInterface);
  IGGUIDlgCtl.CoreCtl := IGCoreCtrl.DefaultInterface;

  IGDlgsCtl.GearCore    := IGCoreCtrl.ComponentInterface;
  IGDlgsCtl.GearFormats := IGFormatsCtrl.ComponentInterface;
  IGDlgsCtl.GearDisplay := IGDisplayCtrl.ComponentInterface;

  IGComp := IGCoreCtrl.CreateComponent('GearJPEG2K.IGJPEG2K.16');
  IGCoreCtrl.AssociateComponent(IGComp.ComponentInterface);

  IGGUIThumbnailCtl.SetParentCtls(IGCoreCtrl.ControlInterface, IGDisplayCtrl.ControlInterface, IGFormatsCtrl.ControlInterface);
//  For i := 0 To IGFormatsCtrl.Settings.FormatCount - 1 Do
//  Begin
//    Temp := IGFormatsCtrl.Settings.Format[i];
//    // modify the detection priority of DCM so that the DCM header is read before the TIF header
//    If Temp.ID = IG_FORMAT_DCM Then
//    Begin
//      Dcm := Temp;
//      Dcm.DetectionPriority := 1100;
//    End
//    // JMW 4/7/09 P93
//    // modify the print depth for PDF documents so they print in color
//    Else
//      If Temp.ID = IG_FORMAT_PDF Then
//      Begin
//        PARAM := Temp.GetParamCopy('PRINT_DEPTH');
//        PARAM.Value.Long := 24;
//        Temp.UpdateParamFrom(PARAM);
//      End;
//  End;
//  FComponentCount := 0;
//  FAllowTextFiles := false; //*** BB 08/24/2010 ***

End;

{Increment the number of ImageGear components currently in use}

Procedure TMagIGManager.IncrementComponentCount();
Begin
  FComponentCount := FComponentCount + 1;
End;

{Decrement the number of ImageGear components currently in use}

Procedure TMagIGManager.DecrementComponentCount();
Begin
  FComponentCount := FComponentCount - 1;
End;

//*** BB 08/24/2010 ***
Procedure TMagIGManager.SetAllowTextFiles(Value: boolean);
var txtformat, tempformat: IGFormatParams; i: integer;
begin
  for i := 0 to IGFormatsCtrl.settings.Formatcount - 1 do
  begin
    tempformat :=  IGFormatsCtrl.Settings.Format[i];
    if tempformat.ID = IG_FORMAT_TXT then txtformat := tempformat;
  end;
  txtformat.DetectionEnabled := Value;
  FAllowTextFiles := Value;
end;

function TMagIGManager.CheckErrors: String;
var
    igResult: IIGResult;
    errorRecord: IGResultRecord;
    errString: String;
begin

    // To prevent Delphi debugger from stopping on ImageGear exceptions,
    // add EOleException to the "Exception Types to Ignore" list
    // Main menu \ Tools \ Options \ Debugger Options

    igResult := IGCoreCtrl.Result;

    If (Not igResult.IsOk) Then
    begin
      errorRecord := igResult.GetRecord(0);
      errString :=
          'ImageGear Error: ' +
          IntToStr(Integer(errorRecord.ErrCode)) + ' ' +             // error code
          '[' + IntToStr(errorRecord.Value1) + ', ' +
                IntToStr(errorRecord.Value2) + ']' + Chr(13) +       // value
          errorRecord.FileName + '(' +                               // file name
          IntToStr(errorRecord.LineNumber) + ')' + Chr(13) +         // line number
          errorRecord.ExtraText;                                     // description
    end
    else
      errString := 'No ImageGear errors on the stack';

  	Result := errString + '. Error has been reported';
end;



end.
