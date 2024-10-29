Unit umagThumbmgr;

Interface
Uses
  GearVIEWLib_TLB
  ;

Procedure MakeThumbForImage(Imagefile, Thumbfilename: String; VIGPageViewCtl: TIGPageViewCtl);
Procedure SaveThumb(Thumbname: String);

Implementation
Uses
  Classes,
  Controls,
  cMagIGManager,
  Forms,
  Graphics,
  ActiveX,
  GearCORELib_TLB,
  GearDISPLAYLib_TLB,
  GearEFFECTSLib_TLB,
  GearFORMATSLib_TLB,
  GearMEDLib_TLB,
  GearPDFLib_TLB,
  GearPROCESSINGLib_TLB,
  IGGUIWinLib_TLB,
  SysUtils,
  Windows
  ;

Type
  TfrmIGCtls3 = Class(TScrollingWinControl)
  Protected
    FIGCoreCtl: TIGCoreCtl;
    FIGDisplayCtl: TIGDisplayCtl;
    FIGEffectsCtl: TIGEffectsCtl;
    FIGFormatsCtl: TIGFormatsCtl;
    FIGGUIThumbnailCtl: TIGGUIThumbnailCtl;
    FIGManager: TMagIGManager;
    FIGMedCtl: TIGMedCtl;
    FIGPageViewCtl: TIGPageViewCtl;
    FIGPDFCtl: TIGPDFCtl;
    FIGProcessingCtl: TIGProcessingCtl;
    Function GetIGCoreCtl: TIGCoreCtl;
    Function GetIGDisplayCtl: TIGDisplayCtl;
    Function GetIGEffectsCtl: TIGEffectsCtl;
    Function GetIGFormatsCtl: TIGFormatsCtl;
    Function GetIGGUIThumbnailCtl: TIGGUIThumbnailCtl;
    Function GetIGMedCtl: TIGMedCtl;
    Function GetIGPDFCtl: TIGPDFCtl;
    Function GetIGProcessingCtl: TIGProcessingCtl;
    Procedure InitGearCtls();
  Public
    IGPageViewCtl1: TIGPageViewCtl;
    Procedure SavePageToFile(Const Page: IIGPage; Const Filename: WideString);
    Procedure DeleteAllThumbnails();
    Procedure FileAppend(Const FilePath: WideString);
    Constructor Create(AOwner: TComponent); Override;
    Destructor Destroy; Override;
  Published
    Property IGCoreCtl: TIGCoreCtl Read GetIGCoreCtl;
    Property IGDisplayCtl: TIGDisplayCtl Read GetIGDisplayCtl;
    Property IGEffectsCtl: TIGEffectsCtl Read GetIGEffectsCtl;
    Property IGFormatsCtl: TIGFormatsCtl Read GetIGFormatsCtl;
    Property IGGUIThumbnailCtl: TIGGUIThumbnailCtl Read GetIGGUIThumbnailCtl;
    Property IGMedCtl: TIGMedCtl Read GetIGMedCtl;
    Property IGPDFCtl: TIGPDFCtl Read GetIGPDFCtl;
    Property IGProcessingCtl: TIGProcessingCtl Read GetIGProcessingCtl;
  End;

Var
  FrmIGCtls3: TfrmIGCtls3;
  VIGLZW: IIGComponent;
  VIGJP2K: IIGComponent;
  VIGPDF: IIGComponent;

  VIGPageDisplaytomerge: IIGPageDisplay;
  VIGPageDisplaypdf: IIGPageDisplay;
  VIGPageAbs: IIGPage;
  VIGPageDisplayAbs: IIGPageDisplay;

Constructor TfrmIGCtls3.Create(AOwner: TComponent);
Begin
  Inherited;
    CoInitialize(Nil);  //RCA ... not sure what chaned, and why we need it now.
  Self.Parent := TWinControl(AOwner);
  Left := 1032;
  Top := 455;
  Height := 162;
  Width := 372;
  Color := clBtnFace;
  Try
    IGPageViewCtl1 := TIGPageViewCtl.Create(AOwner);
    With IGPageViewCtl1 Do
    Begin
      Name := 'IGPageViewCtl1';
      Parent := Self;
      Left := 32;
      Top := 64;
      Width := 245;
      Height := 73;
      TabOrder := 0;
    End;
    InitGearCtls();
  Except
  End;
End;

Procedure TfrmIGCtls3.DeleteAllThumbnails;
Begin
  IGGUIThumbnailCtl.DeleteAllItems;
End;

Destructor TfrmIGCtls3.Destroy;
Begin
  FreeAndNil(IGPageViewCtl1);
  //FreeAndNil(frmIGCtls3);
  Inherited;
End;

Procedure TfrmIGCtls3.FileAppend(Const FilePath: WideString);
Begin
  IGGUIThumbnailCtl.FileAppend(FilePath);
End;

Function TfrmIGCtls3.GetIGCoreCtl: TIGCoreCtl;
Begin
  Result := FIGCoreCtl;
End;

Function TfrmIGCtls3.GetIGDisplayCtl: TIGDisplayCtl;
Begin
  Result := FIGDisplayCtl;
End;

Function TfrmIGCtls3.GetIGEffectsCtl: TIGEffectsCtl;
Begin
  Result := FIGEffectsCtl;
End;

Function TfrmIGCtls3.GetIGFormatsCtl: TIGFormatsCtl;
Begin
  Result := FIGFormatsCtl;
End;

Function TfrmIGCtls3.GetIGGUIThumbnailCtl: TIGGUIThumbnailCtl;
Begin
  Result := FIGGUIThumbnailCtl;
End;

Function TfrmIGCtls3.GetIGMedCtl;
Begin
  Result := FIGMedCtl;
End;

Function TfrmIGCtls3.GetIGPDFCtl: TIGPDFCtl;
Begin
  Result := FIGPDFCtl;
End;

Function TfrmIGCtls3.GetIGProcessingCtl: TIGProcessingCtl;
Begin
  Result := FIGProcessingCtl;
End;

{$HINTS OFF}

Procedure TfrmIGCtls3.InitGearCtls;
Var
  UseDefault: Boolean;
Begin
  UseDefault := True;
  FIGManager := GetIGManager();
  FIGCoreCtl := FIGManager.IGCoreCtrl;
  FIGDisplayCtl := FIGManager.IGDisplayCtrl;
  FIGEffectsCtl := FIGManager.IGEffectsCtl;
  FIGFormatsCtl := FIGManager.IGFormatsCtrl;
  FIGGUIThumbnailCtl := FIGManager.IGGUIThumbnailCtl;
  FIGMedCtl := FIGManager.IGMedCtrl;
  FIGPDFCtl := FIGManager.IGPdfCtrl;
  FIGProcessingCtl := FIGManager.IGProcessingCtrl;
{$IFDEF ImageGear16}
  VIGLZW := IGCoreCtl.CreateComponent('GearLZW.IGLZW.16');
  IGCoreCtl.AssociateComponent(VIGLZW.ComponentInterface);

  VIGJP2K := IGCoreCtl.CreateComponent('GearJPEG2K.IGJPEG2K.16');
  IGCoreCtl.AssociateComponent(VIGJP2K.ComponentInterface);

  VIGPDF := IGCoreCtl.CreateComponent('GearPDF.IGPDFCtl.16');
  IGCoreCtl.AssociateComponent(VIGPDF.ComponentInterface);
  UseDefault := False;
{$ENDIF}
{$IFDEF ImageGear15}
  VIGLZW := IGCoreCtl.CreateComponent('GearLZW.IGLZW.15');
  IGCoreCtl.AssociateComponent(VIGLZW.ComponentInterface);

  VIGJP2K := IGCoreCtl.CreateComponent('GearJPEG2K.IGJPEG2K.15');
  IGCoreCtl.AssociateComponent(VIGJP2K.ComponentInterface);

  VIGPDF := IGCoreCtl.CreateComponent('GearPDF.IGPDFCtl.15');
  IGCoreCtl.AssociateComponent(VIGPDF.ComponentInterface);
  UseDefault := False;
{$ENDIF}
  If UseDefault Then
  Begin
    //Default is 15
    VIGLZW := IGCoreCtl.CreateComponent('GearLZW.IGLZW.15');
    IGCoreCtl.AssociateComponent(VIGLZW.ComponentInterface);

    VIGJP2K := IGCoreCtl.CreateComponent('GearJPEG2K.IGJPEG2K.15');
    IGCoreCtl.AssociateComponent(VIGJP2K.ComponentInterface);

    VIGPDF := IGCoreCtl.CreateComponent('GearPDF.IGPDFCtl.15');
    IGCoreCtl.AssociateComponent(VIGPDF.ComponentInterface);
    UseDefault := False;
  End;
  //This is how we enable Text File display.
  IGFormatsCtl.Settings.GetFormatRef(41).DetectionEnabled := True;

  VIGPageAbs := IGCoreCtl.CreatePage();
  VIGPageDisplayAbs := IGDisplayCtl.CreatePageDisplay(VIGPageAbs);
  IGPageViewCtl1.PageDisplay := VIGPageDisplayAbs;
  IGGUIThumbnailCtl.SetParentCtls(IGCoreCtl.ControlInterface, IGDisplayCtl.ControlInterface, IGFormatsCtl.ControlInterface);
End;
{$HINTS ON}

Procedure TfrmIGCtls3.SavePageToFile(Const Page: IIGPage; Const Filename: WideString);
Begin
  IGFormatsCtl.SavePageToFile(Page, Filename, 0, IG_PAGESAVEMODE_OVERWRITE, IG_SAVE_JPG);
End;

(*
Use Accusoft Thumb Control and make a Thumbnail for the image
imagefile  : Image file to make a thumbnail from.
thumbfilename : Image file name for the created thumbnail file.
vIGPageViewCtl  : accusoft control to use for the Image.
*)

Procedure MakeThumbForImage(Imagefile, Thumbfilename: String; VIGPageViewCtl: TIGPageViewCtl);
Var
  AbsName: String;
  ArgErr: LongWord;
  Ddb: GearDISPLAYLib_TLB.TIGDisplayDDB;
  Exinfo: EXCEPINFO;
  Handle: Integer;
  Palette: Integer;
  Params: DISPPARAMS;
  Retval: Variant;
  Thumbnail: IPictureDisp;
Begin

  If Not FileExists(Imagefile) Then Raise Exception.Create('Creating Thumbnail : Image file does not exist. ' + Imagefile);
  FrmIGCtls3.DeleteAllThumbnails();

  AbsName := ChangeFileExt(Imagefile, '.abs');
  FrmIGCtls3.FileAppend(Imagefile);
  Ddb := GearDISPLAYLib_TLB.TIGDisplayDDB.Create(Nil);
  Thumbnail := FrmIGCtls3.IGGUIThumbnailCtl[0].Thumbnail;

  Params.cArgs := 0;
  Params.cNamedArgs := 0;
  Params.Rgvarg := Nil;
  Params.RgdispidNamedArgs := Nil;

  Thumbnail.Invoke(0, GUID_NULL, LOCALE_SYSTEM_DEFAULT, DISPATCH_PROPERTYGET, Params, @Retval, @Exinfo, @ArgErr);
  Handle := Retval;
  Ddb.Bitmap := Handle;
  Thumbnail.Invoke(2, GUID_NULL, LOCALE_SYSTEM_DEFAULT, DISPATCH_PROPERTYGET, Params, @Retval, Nil, Nil);

  Palette := Retval;
  Ddb.Palette := Palette;
  If VIGPageViewCtl <> Nil Then
  Begin
    VIGPageViewCtl.PageDisplay := VIGPageDisplayAbs;
    VIGPageViewCtl.PageDisplay.ImportDDB(0, Ddb.DefaultInterface);
    VIGPageViewCtl.UpdateView();
  End
  Else
  Begin
    FrmIGCtls3.IGPageViewCtl1.PageDisplay.ImportDDB(0, Ddb.DefaultInterface);
    FrmIGCtls3.IGPageViewCtl1.UpdateView();
  End;
  If Thumbfilename <> '' Then SaveThumb(Thumbfilename);
End;

Procedure SaveThumb(Thumbname: String);
Begin
  FrmIGCtls3.SavePageToFile(VIGPageAbs, Thumbname);
End;
Initialization
  FrmIGCtls3 := TfrmIGCtls3.Create(Nil);
Finalization
  FreeAndNil(FrmIGCtls3);
End.
