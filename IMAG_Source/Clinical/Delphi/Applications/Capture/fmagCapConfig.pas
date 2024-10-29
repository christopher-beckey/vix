Unit FmagCapConfig;
{
Package: MAG - VistA Imaging
WARNING: Per VHA Directive 10-93-142 this unit should not be modified.
Date Created:
Site Name: Silver Spring, OIFO
Developers: Garrett Kirin
Description: Capture Configuration settings
Note:
}
(*
;; +---------------------------------------------------------------------------------------------------+
;; Property of the US Government.
;; No permission to copy or redistribute this software is given.
;; Use of unreleased versions of this software requires the user
;;  to execute a written test agreement with the VistA Imaging
;;  Development Office of the Department of Veterans Affairs,
;;  telephone (301) 734-0100.
;;
;; The Food and Drug Administration classifies this software as
;; a medical device.  As such, it may not be changed
;; in any way.  Modifications to this software may result in an
;; adulterated medical device under 21CFR820, the use of which
;; is considered to be a violation of US Federal Statutes.
;; +---------------------------------------------------------------------------------------------------+
*)

Interface

Uses
  Classes,
  Controls,
  Buttons,
  ExtCtrls,
  Forms,
  Stdctrls,
  WinTypes  ,
  ComCtrls,
  //
  cMagTwain ,
  maggut1 ,
  umagutils8,
  imaginterfaces,
  umagdefinitions
,   umagCapDef
  ;

//Uses Vetted 20090810:ComCtrls, maggut1, umagutils, TabNotBk, Graphics, Classes, Messages, WinProcs, magguini, MagExeWait, MagFloatConfigu, magpositions, geardef, uMagCapUtil, INIFILES, Dialogs, Controls, SysUtils

Type
  TfrmCapConfig = Class(TForm)
    BitBtn1: TBitBtn;
    BitBtn2: TBitBtn;
    BitBtn3: TBitBtn;
    bShowConfigs: TBitBtn;
    cbPageNum: TCheckBox;
    Elum100: TEdit;
    GOther: TGroupBox;
    Label5: Tlabel;
    Label7: Tlabel; 
    LblSupportedTypes: Tlabel;
    ListBox1: TListBox;
    LLum100values: TListBox;
    Lumisys100: TRadioButton;
    OffLine: TRadioButton;
    PnlHide: Tpanel;
    PnlHide1: Tpanel;
    PnlSupportedTypes: Tpanel;
    ScanECG: TRadioButton;
    ScanJetXray: TRadioButton;
    Vidar: TRadioButton;
    Vista: TRadioButton;
    VistaInteractive: TRadioButton;
    PageControl1: TPageControl;
    tbshSourceFormat: TTabSheet;
    GLInputSource: TGroupBox;
    Label1: TLabel;
    pnlImportSource: TPanel;
    xxxlbImportMode: TLabel;
    cbImportBatch: TCheckBox;
    cmbImportMode: TComboBox;
    pnlTwainSource: TPanel;
    GLImageFormat: TGroupBox;
    Label6: TLabel;
    DocumentG4: TRadioButton;
    ImportFormat: TRadioButton;
    DICOMFormat: TRadioButton;
    tbshAssociation: TTabSheet;
    GMode: TGroupBox;
    OnLine: TRadioButton;
    rbtnTestMode: TRadioButton;
    GAssociation: TGroupBox;
    Bevel1: TBevel;
    Bevel4: TBevel;
    Label4: TLabel;
    Label3: TLabel;
    ClinImage: TRadioButton;
    PhotoID: TRadioButton;
    AdminDoc: TRadioButton;
    Laboratory: TRadioButton;
    Medicine: TRadioButton;
    TIU: TRadioButton;
    ClinProc: TRadioButton;
    Radiology: TRadioButton;
    Surgery: TRadioButton;
    TeleReaderConsult: TRadioButton;
    tbshLegacy: TTabSheet;
    GImageGroup: TGroupBox;
    ImageGroup: TRadioButton;
    SingleImage: TRadioButton;
    Lum100choice: TComboBox;
    PDFImage: TRadioButton;
    Bevel5: TBevel;
    cbMultipleCapture: TCheckBox;
    lbCombine: TLabel;
    cbPDFConvert: TCheckBox;
    Label9: TLabel;
    Import: TRadioButton;
    Twain: TRadioButton;
    ScannedDocument: TRadioButton;
    TrueColorJPG: TRadioButton;
    cbTwainALLPages: TCheckBox;
    bTwainSource: TBitBtn;
    btnTwainSettings: TBitBtn;
    grpLegacySource: TGroupBox;
    Lumisys75: TRadioButton;
    Lumisys150: TRadioButton;
    Clipboard: TRadioButton;
    pnlMeteorsettings: TPanel;
    cbMeteorInt: TCheckBox;
    bMetSettings: TBitBtn;
    Meteor: TRadioButton;
    grpLegacyFormat: TGroupBox;
    Color: TRadioButton;
    ColorScan: TRadioButton;
    Xray: TRadioButton;
    XrayJPG: TRadioButton;
    BlackandWhite: TRadioButton;
    Document: TRadioButton;
    bitmap: TRadioButton;
    btnINitColorPDF: TButton;  {/p117 T3 gek  Enable change import mode from GUI  }
    Procedure AdminDocClick(Sender: Tobject);
    Procedure BitBtn1Click(Sender: Tobject);
    Procedure BitBtn2Click(Sender: Tobject);
    Procedure BitBtn3Click(Sender: Tobject);
    Procedure BitmapClick(Sender: Tobject);
    Procedure BlackandWhiteClick(Sender: Tobject);
    Procedure bMetSettingsClick(Sender: Tobject);
    Procedure bShowConfigsClick(Sender: Tobject);
    Procedure bTwainSourceClick(Sender: Tobject);
    Procedure cbImportBatchClick(Sender: Tobject);
    Procedure cbMeteorIntClick(Sender: Tobject);
    Procedure cbTwainALLPagesClick(Sender: Tobject);
    Procedure ClinImageClick(Sender: Tobject);
    Procedure ClinProcClick(Sender: Tobject);
    Procedure ClipboardClick(Sender: Tobject);
    Procedure ColorClick(Sender: Tobject);
    Procedure ColorScanClick(Sender: Tobject);
    Procedure DICOMFormatClick(Sender: Tobject);
    Procedure DocumentClick(Sender: Tobject);
    Procedure DocumentG4Click(Sender: Tobject);
    Procedure FormCloseQuery(Sender: Tobject; Var CanClose: Boolean);
    Procedure FormCreate(Sender: Tobject);
    Procedure FormDestroy(Sender: Tobject);
    Procedure ImageGroupClick(Sender: Tobject);
    Procedure ImportClick(Sender: Tobject);
    Procedure LaboratoryClick(Sender: Tobject);
    Procedure Lum100choiceChange(Sender: Tobject);
    Procedure Lumisys150Click(Sender: Tobject);
    Procedure Lumisys75Click(Sender: Tobject);
    Procedure MedicineClick(Sender: Tobject);
    Procedure MeteorClick(Sender: Tobject);
    Procedure OffLineClick(Sender: Tobject);
    Procedure OnLineClick(Sender: Tobject);
    Procedure PhotoIDClick(Sender: Tobject);
    Procedure RadiologyClick(Sender: Tobject);
    Procedure RbtnTestModeClick(Sender: Tobject);
    Procedure ScannedDocumentClick(Sender: Tobject);
    Procedure SingleImageClick(Sender: Tobject);
    Procedure SurgeryClick(Sender: Tobject);
    Procedure TeleReaderConsultClick(Sender: Tobject);
    Procedure TiuClick(Sender: Tobject);
    Procedure TrueColorJPGClick(Sender: Tobject);
    Procedure TwainClick(Sender: Tobject);
    Procedure XrayClick(Sender: Tobject);
    Procedure XrayJPGClick(Sender: Tobject);
    Procedure ImportFormatClick(Sender: Tobject);
    procedure cmbImportModeChange(Sender: TObject);
    procedure btnTwainSettingsClick(Sender: TObject);
    procedure cbMultipleCaptureClick(Sender: TObject);
    procedure PDFImageClick(Sender: TObject);
    procedure PDFConvertClick(Sender: TObject);
    procedure cbPDFConvertClick(Sender: TObject);
    procedure btnINitColorPDFClick(Sender: TObject);
  private
    procedure UpdateTWAINDefault;
    procedure ZInitPDF;

    procedure UncheckSourceRB(Sender: Tobject);
    procedure UncheckFormatRB(Sender: Tobject);
    procedure ReInitSelectedFormat;





     //106
  Public
      //p140t1
    procedure EnableMultipleCaptures(value: boolean);
    procedure EnableCombinePDF(value: boolean);
    procedure EnableCombineTIF(value: boolean);
    procedure CapButtonCaption();
    procedure DisplayCapX(vCapX: TCapConfigObj);
    procedure INITColorPDF;
    //p129t18   Change Twain source to INI entry
    procedure SetTWAINSourceFromINI();


    Function AbleToGoOnline: Boolean;
    Function AbleToSaveAsGroup: Boolean;
    {/p117T3-CH1 }
//p117 not needed    Function TeleReaderConsultDICOMOnly: Boolean;   //106
//p117 not needed    Function TeleReaderConsultImportOnly: Boolean; //106
    Procedure DisableAllFormats;
    Procedure DisableMultiPage;
    Procedure INITaudio;
    Procedure INITbitmap;
    Procedure INITblackandwhite;
    Procedure INITcolor;
    Procedure INITcolorscan;
    procedure INITUseImageFormat;   {/p117 T3 gek set properties of this Format  }
    Procedure INITDICOMFormat;
    Procedure INITdocument;
    Procedure INITdocumentG4;
    Procedure INITimagegroup;
    Procedure INITmotionvideo;
    Procedure INITnoimagegroup;
    Procedure INIToffline;
    Procedure INITonline;
    Procedure INITtestmode;
    Procedure INITtruecolorJPG;
    Procedure INITxray;
    Procedure INITxrayJPG;
    {/p117T3-CH1 }
//p117  out    Procedure INITAssociationVars; //106
    Procedure LoadLum100Choice;
    Procedure QuickClose;
    {/p117T3-CH1 }
//p117 out   Procedure ClearDICOMFormat(); //106
  End;

Var
  FrmCapConfig: TfrmCapConfig;
  Hotlistchanged: Boolean;
  MeteorProcessInfo: TprocessInformation;
Implementation

{$R *.DFM}
Uses
  SysUtils,
  Dialogs,
  Inifiles,
  UMagCapUtil,
  Geardef,
  Magpositions,
  MagFloatConfigu,
  MagExeWait,
  Magguini,
  FmagCapMain,
  FmagConfigList
  ;

Procedure TfrmCapConfig.Lumisys75Click(Sender: Tobject);
Begin
//p117T3-CH1  If TeleReaderConsultImportOnly Then Exit; //106
  QuickClose;
  UnCheckSourceRB(sender);
  INITlumisys75;
End;

Procedure TfrmCapConfig.Lumisys150Click(Sender: Tobject);
Begin
//p117T3-CH1    If TeleReaderConsultImportOnly Then Exit; //106
  QuickClose;
    UnCheckSourceRB(sender);
  INITlumisys150;
End;

Procedure TfrmCapConfig.MeteorClick(Sender: Tobject);
Begin
//p117T3-CH1    If TeleReaderConsultImportOnly Then Exit; //106
  QuickClose;
    UnCheckSourceRB(sender);
  INITmeteor;
End;

Procedure TfrmCapConfig.TwainClick(Sender: Tobject);
Begin
//p117T3-CH1    If TeleReaderConsultImportOnly Then Exit; //106
  QuickClose;
    UnCheckSourceRB(sender);
  INITtwain;
  SetTWAINSourceFromINI;

End;

Procedure TfrmCapConfig.ImportClick(Sender: Tobject);
Begin
  QuickClose;
  UnCheckSourceRB(sender);
  INITimport;


End;


procedure TfrmCapConfig.UncheckFormatRB(Sender: Tobject);
var magtag : integer;
i : integer;
begin


         magtag := magcfgFormat;
        For i := 0 To ComponentCount - 1 Do
        Begin
          if Components[i].Tag <> magtag then  continue;
          if Components[i] = sender then continue;

          (Components[i] as Tradiobutton).Checked := false;
        End;
end;


procedure TfrmCapConfig.UncheckSourceRB(Sender: Tobject);
var magtag : integer;
i : integer;
begin
CapX.mTwain := false;
CapX.mTwainWindow := False;

         magtag := magcfgSource;
        For i := 0 To ComponentCount - 1 Do
        Begin
          if Components[i].Tag <> magtag then  continue;
          if Components[i] = sender then continue;

          (Components[i] as Tradiobutton).Checked := false;
        End;
end;

 //106
Procedure TfrmCapConfig.ImportFormatClick(Sender: Tobject); //106
Begin
//p117T3-CH1    If TeleReaderConsultDICOMOnly Then Exit;

  UnCheckFormatRB(sender);
  INITUseImageFormat; //p117

End;

Procedure TfrmCapConfig.ScannedDocumentClick(Sender: Tobject);
Begin
//p117T3-CH1    If TeleReaderConsultImportOnly Then Exit; //106
  QuickClose;
  UnCheckSourceRB(sender);
  INITscanneddocument;
End;

Procedure TfrmCapConfig.LaboratoryClick(Sender: Tobject);
Begin
//p117T3-CH1        ClearDICOMFormat(); //106
  QuickClose;
  INITlaboratory;
End;

Procedure TfrmCapConfig.MedicineClick(Sender: Tobject);
Begin
//p117T3-CH1        ClearDICOMFormat(); //106
  QuickClose;
  INITMedicine;
End;

Procedure TfrmCapConfig.TiuClick(Sender: Tobject);
Begin
//p117T3-CH1        ClearDICOMFormat(); //106
  QuickClose;
  INITtiu;
End;

Procedure TfrmCapConfig.RadiologyClick(Sender: Tobject);
Begin
//p117T3-CH1        ClearDICOMFormat(); //106
  QuickClose;
  INITradiology;
End;

Procedure TfrmCapConfig.SurgeryClick(Sender: Tobject);
Begin
//p117T3-CH1        ClearDICOMFormat(); //106
  QuickClose;
  INITsurgery;
End;

procedure TfrmCapConfig.PDFConvertClick(Sender: TObject);
begin
//  QuickClose;
  CapX.m140PDFConvert := True;

end;

procedure TfrmCapConfig.PDFImageClick(Sender: TObject);
begin
//QuickClose;
UnCheckFormatRB(sender);
ZInitPDF;
end;

Procedure TfrmCapConfig.PhotoIDClick(Sender: Tobject);
Begin
//p117T3-CH1        ClearDICOMFormat(); //106
  QuickClose;
  InitPhotoID;
End;

Procedure TfrmCapConfig.ClinImageClick(Sender: Tobject);
Begin
//p117T3-CH1        ClearDICOMFormat(); //106
  QuickClose;
  INITClinImage;
End;

Procedure TfrmCapConfig.AdminDocClick(Sender: Tobject);
Begin
//p117T3-CH1        ClearDICOMFormat(); //106
  QuickClose;
  INITAdminDoc;
End;

Procedure TfrmCapConfig.XrayClick(Sender: Tobject);
Begin
//p117T3-CH1      If TeleReaderConsultDICOMOnly Then Exit; //106
  QuickClose;
  UnCheckFormatRB(sender);
  INITxray;
End;

Procedure TfrmCapConfig.ColorClick(Sender: Tobject);
Begin
//p117T3-CH1      If TeleReaderConsultDICOMOnly Then Exit; //106
  QuickClose;
  UnCheckFormatRB(sender);
  INITcolor;
End;

Procedure TfrmCapConfig.BlackandWhiteClick(Sender: Tobject);
Begin
//p117T3-CH1      If TeleReaderConsultDICOMOnly Then Exit; //106
  QuickClose;
  UnCheckFormatRB(sender);
  INITblackandwhite;
End;

Procedure TfrmCapConfig.DocumentClick(Sender: Tobject);
Begin
//p117T3-CH1      If TeleReaderConsultDICOMOnly Then Exit; //106
  QuickClose;
  UnCheckFormatRB(sender);
  INITdocument;
End;

Procedure TfrmCapConfig.ColorScanClick(Sender: Tobject);
Begin
//p117T3-CH1      If TeleReaderConsultDICOMOnly Then Exit; //106
  QuickClose;
  UnCheckFormatRB(sender);
  INITcolorscan;
End;
{/p117 T3 gek.  This is how we display the Import Mode now. User
   can switch between Import - Copy to server, and Import - Convert to Dicom.
   This is a design change discussed years ago Stuart/Garrett,  It's time
   has come because of the 'convert' action.}
procedure TfrmCapConfig.cmbImportModeChange(Sender: TObject);
begin
CapX.mOtherDesc := '';
  case cmbImportMode.ItemIndex of
    0:    begin  //'Copy to Server';
           CapX.mOtherDesc := cmbImportMode.Text;
           { might not need unchecked in a 'change' event. but to
		   be safe,  and force 'click' event, we'll keep it. }
           if importformat.Checked then importformat.Checked := false ;
           importformat.Checked := true;

          end;
    1:    begin  //'Convert to Dicom';
            if not iniformat.DICOM then  {if Dicom isn't enabled, quit.}
                begin
                cmbImportMode.ItemIndex := 0;
                frmCapmain.WinMsg('','Image Format Dicom is not enabled for this workstation');
                end
                else
                begin
                CapX.mOtherDesc := cmbImportMode.Text;
                { might not need unchecked in a 'change' event. but to
	              be safe, and force 'click' event, we'll keep it. }
                if Dicomformat.Checked then Dicomformat.Checked := false ;
                Dicomformat.Checked := true;
                end;
          end;
    end;
    DisplayCapX(CapX);
end;

Procedure TfrmCapConfig.TrueColorJPGClick(Sender: Tobject);
Begin
//p117T3-CH1      If TeleReaderConsultDICOMOnly Then Exit; //106
  QuickClose;
  UnCheckFormatRB(sender);
  INITtruecolorJPG;
End;

Procedure TfrmCapConfig.DocumentG4Click(Sender: Tobject);
Begin
//p117T3-CH1      If TeleReaderConsultDICOMOnly Then Exit; //106
  QuickClose;
  UnCheckFormatRB(sender);
  INITdocumentG4;
End;

Procedure TfrmCapConfig.ImageGroupClick(Sender: Tobject);
Begin
  QuickClose;
  If AbleToSaveAsGroup Then
    INITimagegroup
  Else
    SingleImage.Checked := True;
End;

Procedure TfrmCapConfig.SingleImageClick(Sender: Tobject);
Begin
  QuickClose;
  INITnoimagegroup;
End;

Procedure TfrmCapConfig.OnLineClick(Sender: Tobject);
Begin
  QuickClose;
  If AbleToGoOnline Then
    INITonline
  Else
    OffLine.Checked := True;
End;

Procedure TfrmCapConfig.OffLineClick(Sender: Tobject);
Begin
  QuickClose;
  INIToffline;
End;

Procedure TfrmCapConfig.RbtnTestModeClick(Sender: Tobject);
Begin
  QuickClose;
  INITtestmode;
End;

Procedure TfrmCapConfig.BitBtn1Click(Sender: Tobject);
Begin
  Close;
End;

Procedure TfrmCapConfig.DisableMultiPage;
  {Patch 59}
Begin
  //If FrmCapConfig.cb TwainALLPages.Checked Then

  
  if CapX.mMultipage then
  
  Begin
       {aren't allowing Color MultiPages}
      // testmsg('color multipage not allowed'+#13+'Select a Group');
    Frmcapmain.WinMsg('d', 'Multi-Page setting was turned Off. (unChecked)'
      + #13 + 'Multi-Page Images are only supported for Scanned Documents of format: TIF'
      + #13 + '         or when Converting Scanned Color pages to PDF'
      + #13
      + #13 + 'You can also scan related Images as a Study Group.');
    frmCapMain.AllPagesChecked(false);
    //a/ FrmCapConfig.cb TwainALLPages.Checked := False;
  End;
  If FrmCapConfig.cbTwainALLPages.Visible Then
  Begin
    FrmCapConfig.cbTwainALLPages.Enabled := False;
    Frmcapmain.cbALLPages.Enabled := False;
  End;

End;

Procedure TfrmCapConfig.FormCreate(Sender: Tobject);
Begin
  LoadLum100Choice;
  GetFormPosition(Self As TForm);
  frmCapConfig.PageControl1.ActivePage := tbshSourceFormat;
End;

Procedure TfrmCapConfig.LoadLum100Choice;
Var
  Tini: TIniFile;
Begin
  Tini := TIniFile.Create(GetConfigFileName);
  Try
    Tini.ReadSection('SYS_FilmSize_Lumisys100', Lum100choice.Items);
    Tini.ReadSectionValues('SYS_FilmSize_Lumisys100', LLum100values.Items);
    cbMeteorInt.Checked := Uppercase(Tini.ReadString('SYS_Meteor', 'Interactive', 'TRUE')) = 'TRUE';
  Finally
    Tini.Free;
  End;
End;

Procedure TfrmCapConfig.FormCloseQuery(Sender: Tobject;
  Var CanClose: Boolean);
Begin
  CanClose := True;
  If (Lumisys100.Checked) And (Lum100choice.ItemIndex = -1) Then
  Begin
    If Messagedlg('You are Closing without selecting a "Film Size."',
      Mtconfirmation, [Mbok, Mbcancel], 0) = MrOK Then
      CanClose := True
    Else
      CanClose := False;
  End;
  If CanClose Then
  Begin
    If
      (
      PDFImage.Checked or
      Color.Checked Or
      TrueColorJPG.Checked Or
      ColorScan.Checked Or
      Xray.Checked Or
      XrayJPG.Checked Or
      BlackAndWhite.Checked Or
      Document.Checked Or
      DocumentG4.Checked Or
      Bitmap.Checked Or
      DICOMFormat.Checked Or
      ImportFormat.Checked
      ) Then
      CanClose := True
    Else
    Begin
      If Messagedlg('You are Closing without selecting an "Image Format."',
        Mtconfirmation, [Mbok, Mbcancel], 0) = MrOK Then
        CanClose := True
      Else
        CanClose := False;
    End;
  End;
  Frmcapmain.ToolbuttonsUp;
End;

Procedure TfrmCapConfig.DisplayCapX(vCapX : TCapConfigObj)  ;
begin
  with frmCapMain do
  begin
    Lbformatdesc.caption := vCapX.mFormatDesc;
    Otherdesc.Caption := vCapX.mOtherDesc ;
    LbInputSourceDesc.caption := vCapX.GetSourceDesc;
    if vCapX.m140PDFConvert then OtherDesc.Caption := 'Save as PDF';
    if vCapX.m140MultSources then OtherDesc.Caption := 'Combine as 1 PDF';
    
    

  end;


end;

Procedure TfrmCapConfig.INITxray;
Begin
  Xray.Enabled := true;
  If Not Xray.Checked Then Xray.Checked := True;
  with CapX do
      begin
      mOtherDesc := '';
      mFormatDesc := 'Xray(8 bit)';
      mFormat := '.TGA'; {var format}
      mImageType := 3;
      mIGSaveFormat := mag_IG_SAVE_TGA;
      mIGScanFormat := mag_IG_FORMAT_BMP;
      mIGScanPixelType := mag_IG_TW_PT_GRAY;
      mIGScanCompression := mag_IG_COMPRESSION_NONE;
      mIGScanBitDepth := 8;
      end;
  DisplayCapX(CapX);
  DisableMultiPage;
End;

Procedure TfrmCapConfig.INITxrayJPG;
Begin
  If Not XrayJPG.Checked Then XrayJPG.Checked := True;
  with CapX do
      begin
      mOtherDesc := '';      
      mFormatDesc := 'Xray (JPG)';
      mFormat := '.JPG'; {var format}
      mImageType := 19;
      mIGSaveJPEGQuality := 95;
      mIGSaveFormat := mag_IG_SAVE_JPG;
      mIGScanFormat := mag_IG_FORMAT_JPG;
      mIGScanPixelType := mag_IG_TW_PT_GRAY;
      mIGScanCompression := mag_IG_COMPRESSION_JPEG;
      mIGScanBitDepth := 8;
      end;
  DisplayCapX(CapX);
  DisableMultiPage;
End;

Procedure TfrmCapConfig.INITcolor;
Begin
  If Not Color.Checked Then Color.Checked := True;
  with CapX do
      begin
      mOtherDesc := '';      
      mFormatDesc := 'True Color TGA (24 bit)';
      mFormat := '.TGA'; {var format}
      mImageType := 1;
      mIGSaveFormat := mag_IG_SAVE_TGA;
      mIGScanFormat := mag_IG_FORMAT_BMP;
      mIGScanPixelType := mag_IG_TW_PT_RGB;
      mIGScanCompression := mag_IG_COMPRESSION_NONE;
      mIGScanBitDepth := 8;
      end;
  DisplayCapX(CapX);
  DisableMultiPage;
End;

Procedure TfrmCapConfig.INITblackandwhite;
Begin
  If Not BlackAndWhite.Checked Then BlackAndWhite.Checked := True;
  with CapX do
      begin
      mOtherDesc := '';      
      mFormatDesc := 'Black and White (8 bit grayscale)';
      mFormat := '.TGA'; {var format}
      mImageType := 9;
      mIGSaveFormat := mag_IG_SAVE_TGA;

      mIGScanFormat := mag_IG_FORMAT_BMP;
      mIGScanPixelType := mag_IG_TW_PT_GRAY;
      mIGScanCompression := mag_IG_COMPRESSION_NONE;
      mIGScanBitDepth := 8;
      end;
  DisplayCapX(CapX);
  DisableMultiPage;
End;

Procedure TfrmCapConfig.INITdocument;
Begin
  If Not Document.Checked Then Document.Checked := True;

  with CapX do
      begin
      mOtherDesc := '';
      mFormatDesc := 'TIFF Uncompressed';
      mFormat := '.TIF'; {var format}
      mImageType := 15;

      mIGSaveFormat := mag_IG_SAVE_TIF_UNCOMP;

      mIGScanFormat := mag_IG_FORMAT_TIF;
      mIGScanPixelType := mag_IG_TW_PT_BW;
      mIGScanCompression := mag_IG_COMPRESSION_NONE;
      mIGScanBitDepth := 1;
      end;
  DisplayCapX(CapX);
  frmcapmain.EnableMultiPageScan;

End;

Procedure TfrmCapConfig.INITdocumentG4;
Begin

  If Not DocumentG4.Checked Then DocumentG4.Checked := True;
  with CapX do
      begin
      mOtherDesc := '';
      mFormatDesc := 'TIFF G4 FAX';
      mFormat := '.TIF'; {var format}
      mImageType := 15;

      mIGSaveFormat := mag_IG_SAVE_TIF_G4;

      mIGScanFormat := mag_IG_FORMAT_TIF;
      mIGScanPixelType := mag_IG_TW_PT_BW;
      mIGScanCompression := mag_IG_COMPRESSION_CCITT_G4;
      mIGScanBitDepth := 1;
      end;
  DisplayCapX(CapX);
  Frmcapmain.EnableMultiPageScan;
End;

Procedure TfrmCapConfig.INITbitmap;
Begin
  If Not Bitmap.Checked Then Bitmap.Checked := True;
      with CapX do
      begin
      mOtherDesc := '';      
      mFormatDesc := 'Bitmap';
      mFormat := '.BMP'; {var format}
      mImageType := 1;

      mIGSaveFormat := mag_IG_SAVE_BMP_UNCOMP;

      mIGScanFormat := mag_IG_FORMAT_BMP;
      mIGScanPixelType := mag_IG_TW_PT_RGB;
      mIGScanCompression := mag_IG_COMPRESSION_NONE;
      mIGScanBitDepth := 8;
      end;
  DisplayCapX(CapX);
  DisableMultiPage;
End;

 {This is called from the Button....  maybe leave, maybe remove button.}
 { *******************   NOT USED AT THE MOMENT }
Procedure TfrmCapConfig.INITColorPDF;
Begin

  If Not cbPDFConvert.Checked Then cbPDFConvert.Checked := True;
  INITscanneddocument;
  INITtruecolorJPG;
  application.processmessages;
  with CapX do
      begin
      mOtherDesc := '';      
      mFormatDesc := 'True Color PDF';

      mIGSaveJPEGQuality := 95;

      mIGSaveFormat :=   mag_IG_SAVE_PDF_JPG; // = $00060038;;

      mIGScanFormat := mag_IG_FORMAT_JPG;
      mIGScanPixelType := mag_IG_TW_PT_RGB;
      mIGScanCompression := mag_IG_COMPRESSION_JPEG;
      mIGScanBitDepth := 8;

      ////  DisableMultiPage;

      { ---------------      }
      mFormat :='.JPG';
      mImageType := 1;
      //QaD  keep above, so functions called by next two lines process correctlty.
      { ---------------      }
      end;

  frmCapMain.enablemultipageScan;
  frmCapMain.AllPagesChecked(true);

  CapX.mFormat :='.PDF';
  CapX.mImageType := 104;
  DisplayCapX(CapX);
End;


Procedure TfrmCapConfig.ZInitPDF; {This is called from Hidded Radio Buttton.... maybe use this method.  Not Now Though.}
Begin
// frmCapMain.F140PDFon := true;
  If Not PDFImage.Checked Then PDFImage.Checked := True;
  with CapX do
      begin
      mFormatDesc := 'PDF Image';
      mFormat := '.PDF'; {var format}
      mImageType := 104;
      //FmIGSaveJPEGQuality := 95;
      mIGSaveFormat := mag_IG_SAVE_JPG;

      mIGScanFormat :=  mag_IG_FORMAT_JPG; //////////   FmIGScanFormat := mag_IG_FORMAT_TIF;
      //140t1/ FmIGScanPixelType := mag_IG_TW_PT_BW;
      mIGScanPixelType := mag_IG_TW_PT_RGB ;
      mIGScanCompression := mag_IG_COMPRESSION_NONE;
      mIGScanBitDepth := 24;
      end;

  Frmcapmain.EnableMultiPageScan;
End;

Procedure TfrmCapConfig.INITtruecolorJPG;
Begin

  If Not TrueColorJPG.Checked Then TrueColorJPG.Checked := True;
  with CapX do
      begin
      mOtherDesc := '';      
      mFormatDesc := 'True Color JPG (24 bit)';
      mFormat := '.JPG'; {var format}
      mImageType := 1;

      mIGSaveJPEGQuality := 95;

      mIGSaveFormat := mag_IG_SAVE_JPG;

      mIGScanFormat := mag_IG_FORMAT_JPG;
      mIGScanPixelType := mag_IG_TW_PT_RGB;
      mIGScanCompression := mag_IG_COMPRESSION_JPEG;
      mIGScanBitDepth := 8;
      end;
  DisplayCapX(CapX);
  {140 add the check for PDF convert}
  if not CapX.m140PDFConvert then self.DisableMultiPage   ;
End;

Procedure TfrmCapConfig.INITDICOMFormat;
Begin

{/p117T3 gek   INITDICOMFormat is only called from the OnClick event of the Radio button.
  We don't want to allow forcing something that is disabled, to be enabled.
  that will ignore Security Keys, and site manager's INI Settings.
  i.e. we allow the Site Manager to Disable a Format for a Workstation...
  if enabled  in code, this will overwride the system managers  setting in the INI.
   note : only in application initialization, when we are setting the defaults from the
   INI file,  if site manager has selected something in the INI to be the default setting,
   and forgot to enable it in the INI,   then we force it to be enabled. }


  (*  If Not DICOMFormat.Visible Then DICOMFormat.Visible := True;
   If Not DICOMFormat.Enabled Then DICOMFormat.Enabled := True; *)

  If Not DICOMFormat.Checked Then DICOMFormat.Checked := True;

  cmbImportmode.ItemIndex := 1;  //'Convert to Dicom'; //117 gek new.

  with CapX do
      begin
      mOtherDesc :=  'Convert to Dicom';
      mFormatDesc := 'DICOM(VL Photo Image Storage)';
      mFormat := '.DCM'; {var format}
      mImageType := 100;

      mIGSaveFormat :=  mag_IG_SAVE_DCM;
      //  FmIGScanBits :=   24;
      end;
  DisplayCapX(CapX);
  DisableMultiPage;
End;

  {INIIUseImageFormat
      we dont' set Format of Gear 1.Saveformat here.
      We are copying to server,  so whatever image/document is selected, we determine the settings
      from that, after it is selected.
      }
Procedure TfrmCapConfig.INITUseImageFormat;
Begin

  with CapX do
      begin
      mFormatDesc := Nullsetting;
      mOtherDesc := 'Copy to Server';
      end;
  DisplayCapX(CapX);
  // frmCapmain.Otherdesc.Caption := 'Copy to Server';  //117 gek new.
  cmbImportmode.ItemIndex := 0;  //'Copy to Server';    //117 gek new.

  DisableMultiPage;
End;




Procedure TfrmCapConfig.INITmotionvideo;
Begin
// Nothing to Init
End;

Procedure TfrmCapConfig.INITaudio;
Begin
// nothing to init....
End;

Procedure TfrmCapConfig.INITcolorscan;
Begin
  If Not ColorScan.Checked Then ColorScan.Checked := True;
  with CapX do
      begin
      mFormatDesc := '256 Color (8 bit)';
      mFormat := '.TIF'; {var format}
      mImageType := 17;

      mIGSaveFormat := mag_IG_SAVE_TIF_PACKED;

      mIGScanFormat := mag_IG_FORMAT_TIF;
      mIGScanPixelType := mag_IG_TW_PT_PALETTE;
      mIGScanCompression := mag_IG_COMPRESSION_NONE;
      mIGScanBitDepth := 8;
      end;
  DisplayCapX(CapX);      
{Note: below was commented out prior to 129}
(*  frmCapmain.Gear 1.ScanCapsType := IG_SCAN_CAP_PIXELTYPE;
   { IG_SCAN_CAP_PIXELTYPE INT
        0 - monochrome
        1 - grayscale
        2 - RGB
        3 - Palette    }
*)

  Frmcapmain.EnableMultiPageScan;
End;

(* *** --- ***  *)

Function TfrmCapConfig.AbleToSaveAsGroup;
Begin
  If PhotoID.Checked Then
  Begin
    Messagedlg('Photo ID''s can only be captured as ' + #13 +
      'single images.', Mtconfirmation, [Mbok], 0);
    Result := False;
  End
  Else
    Result := True;
End;

Procedure TfrmCapConfig.INITimagegroup;
Begin
   if cbPDFConvert.checked then
   begin
      magappmsg('d','PDF image captures are not enabled when creating ''Study Groups'' ' + #13 +
                     '  PDF image capture will be turned off.');
      self.cbMultipleCapture.Checked := false;
      self.cbPDFConvert.checked := false;
  end;
  Frmcapmain.Imagegroupdesc.caption := 'Study';
  Frmcapmain.btnStudyComplete.Visible := True;
  Frmcapmain.btnStudyComplete.Enabled := False;
  //cbPageNum.enabled := true;
End;

Procedure TfrmCapConfig.INITnoimagegroup;
Begin
  If Frmcapmain.Imageptrlst.Items.Count > 0 Then
  Begin
    Frmcapmain.WinMsg('d', 'You Must first Click on ''Study Complete'' before switching to single image capture');
    ImageGroup.Checked := True;
    Frmcapmain.ButtonSettings(1);
  End
  Else
  Begin
    Frmcapmain.Imagegroupdesc.caption := 'Single';
    Frmcapmain.btnStudyComplete.Visible := False;
    Frmcapmain.btnStudyComplete.Enabled := False;
  End;
End;

Function TfrmCapConfig.AbleToGoOnline;
Begin
  Result := True;
End;

Procedure TfrmCapConfig.INITonline;
Begin
  FModeTest := False;
  Frmcapmain.Modedesc.caption := 'OnLine';
  Frmcapmain.SaveImageAs2.Visible := False;
End;

Procedure TfrmCapConfig.INIToffline;
Begin
  FModeTest := True;
  Frmcapmain.Modedesc.caption := 'OFF Line';
  Frmcapmain.SaveImageAs2.Visible := True;
End;

Procedure TfrmCapConfig.INITtestmode;
Begin
  FModeTest := True;
  Frmcapmain.Modedesc.caption := 'Test';
  Frmcapmain.SaveImageAs2.Visible := True;
End;

Procedure TfrmCapConfig.DisableAllFormats;
Begin
  Color.Enabled := False;
  Color.Checked := False;
  TrueColorJPG.Enabled := False;
  TrueColorJPG.Checked := False;
  ColorScan.Enabled := False;
  ColorScan.Checked := False;
  Xray.Enabled := False;
  Xray.Checked := False;
  XrayJPG.Enabled := False;
  XrayJPG.Checked := False;
  BlackAndWhite.Enabled := False;
  BlackAndWhite.Checked := False;
  Document.Enabled := False;
  Document.Checked := False;
  DocumentG4.Enabled := False;
  DocumentG4.Checked := False;
  Bitmap.Enabled := False;
  Bitmap.Checked := False;
  DICOMFormat.Enabled := False;
  DICOMFormat.Checked := False;
  ImportFormat.Enabled := False;
  ImportFormat.Checked := False;
  //********************************
  bTwainSource.Enabled := False;
  btnTwainSettings.Enabled := False ; //p140t1
  Frmcapmain.ALLPagesChecked(False);
  Frmcapmain.cbALLPages.Visible := False;
  CapX.mFormatDesc := Nullsetting;
  Frmcapmain.Otherdesc.caption := '';
  Lum100choice.Hide;
  //p140t1 PnlImportSource.Visible := False;
 // 1401 changed  PnlMeteorsettings.Visible := False;
   PnlMeteorsettings.Enabled := False;
  //140t1 Out - PnlMeteorSource.Visible := False;
  //p140T1 PnlTwainSource.Visible := False;
End;

Procedure TfrmCapConfig.cbMeteorIntClick(Sender: Tobject);
Begin
  If cbMeteorInt.Checked Then
     CapX.mOtherDesc := 'Meteor Interactive mode'

  Else
    Frmcapmain.Otherdesc.caption := 'Meteor NON - Interactive mode'
End;

procedure TfrmCapConfig.cbPDFConvertClick(Sender: TObject);

begin
if cbPDFConvert.checked  then
    begin
       { ... Not Changing Multiple Image Checkbox. Multiple Image Capture isn't dependent on if
                we are Converting to PDF. Because we can convert 1 image to PDF, or 1 Scan to PDF.}
    CapX.m140PDFConvert := True;
    if ImageGroup.Checked then
      begin
       magappmsg('d','PDF images are captured as a single multipage document' + #13 +
                           ' ''Single Image'' will be checked');
       singleimage.Checked := true;
      end;
    end
  else
    begin
    If cbMultipleCapture.Checked then cbMultipleCapture.Checked := false;
    CapX.m140PDFConvert := False ;
    ReInitSelectedFormat;

    end;
    
 frmCapMain.enablemultipageScan;

 DisplayCapX(CapX);
 CapButtonCaption;

end;

procedure TfrmCapConfig.ReInitSelectedFormat();
begin
    if TrueColorJPG.checked  then  initTrueColorJPG ;
    if DocumentG4.Checked  then   initDocumentG4 ;
    if ImportFormat.checked then     INITUseImageFormat;
    if DICOMFormat.checked then   initDICOMFormat;
    if ColorScan.checked then   initColorScan   ;
    if Xray.checked then   initXray   ;
    if XrayJPG.checked then    initXrayJPG  ;
    if BlackandWhite.checked then   initBlackandWhite   ;
    if Document.checked then  initDocument;
    if bitmap.checked then   initDocument;
end;



procedure TfrmCapConfig.CapButtonCaption();
var s1 : string;
begin
s1 :=  magpiece(frmCapMain.btnCapture.Caption,'(',1);
if CapX.m140CombineScans then
   begin
      s1 := s1 + '(Multiple)(TIF)';
      frmCapMain.btnCapture.Caption := s1;
      exit;
   end;
if CapX.m140MultSources then  s1 := s1 + '(Multiple)';
if CapX.m140PDFConvert then s1 := s1 + '(PDF)';

frmCapMain.btnCapture.Caption := s1 ;
end;

Procedure TfrmCapConfig.Lum100choiceChange(Sender: Tobject);
Begin
  Elum100.Text := LLum100values.Items.Values[Lum100choice.Items[Lum100choice.ItemIndex]];
  Frmcapmain.Otherdesc.caption := Lum100choice.Items[Lum100choice.ItemIndex];
End;

Procedure TfrmCapConfig.BitBtn3Click(Sender: Tobject);
Begin
  Application.HelpContext(10107);
End;

Procedure TfrmCapConfig.XrayJPGClick(Sender: Tobject);
Begin
//p117T3-CH1      If TeleReaderConsultDICOMOnly Then Exit; //106
  QuickClose;
  UnCheckFormatRB(sender);
  INITxrayJPG;
End;

Procedure TfrmCapConfig.bTwainSourceClick(Sender: Tobject);
Var
  FirstTwainSource: String;
Begin
{ TODO -o129 : See if we can make a MagTwain function to return the same ..
           ... false if there are no TWAIN devices found.
           Now,  we are returning the Default Source}
  // First see if there are NO Twain sources installed.
 (*
  FirstTwainSource := Frmcapmain.Gear 1.ScanfirstDS;
  If FirstTwainSource = '' Then
  Begin
    Frmcapmain.WinMsg('de', 'Cannot find a TWAIN Device installed on this Workstation.');
    Exit;
  End; *)
  {/p129  Fix bug Remedy ____ for Twain Selection window is always
      opened behind the Floating Config section window.}
  if MagFloatConfig.Visible then
    begin
     MagFloatConfig.close;
     MagFloatConfig.update;
       try
       MagTwain1.SourceOpenSelect(); //Frmcapmain.Gear 1.Scanopensource := True;
       UpdateTWAINDefault;
       finally
       frmcapmain.SettingsEditSource;
       end;
    end
  else if self.Visible then
    begin
     self.Visible := false;
     self.update;
       try
       MagTwain1.SourceOpenSelect(); //Frmcapmain.Gear 1.Scanopensource := True;
       UpdateTWAINDefault;
       finally
       self.Visible := true;
       end;
    end;
//  GInputSource.Parent.BringToFront;
//  GInputSource.Parent.SetFocus;
End;


procedure TfrmCapConfig.btnINitColorPDFClick(Sender: TObject);
begin
INITColorPDF;
end;

procedure TfrmCapConfig.SetTWAINSourceFromINI();
var
  iniTwainSourceInt : integer;
  iniTWAINSource    : string;

  curTwainSourceInt : integer;
  curTwainSource    : string;
  dsList : Tstrings;
begin
dsList := Tstringlist.create;
try
iniTwainSource := GetINIEntry('SYS_TWAIN','DEFAULT');
if (iniTWAINSource = '')  then exit;


MagTwain1.GetDSSourcesList(dsList,curTwainSourceInt);
if dslist.Count = 0  then  exit;

curTwainSource := dslist[curTwainSourceInt];

if (curTwainSource =  iniTWAINSource)then  exit;

iniTwainSourceInt := dslist.IndexOf(iniTWAINSource);
if (iniTwainSourceInt = -1) then
  begin
    UpdateTWAINDefault();
    exit;
  end;

 {HERE.   so we need to set the Source to the iniTwainSourceInt}
 magappmsg('','Changing TWAIN Source to: ' +  iniTwainSource);

MagTwain1.SourceOpenByIndex(inttostr(iniTwainSourceInt));



finally
  dslist.Free;
end;

end;


{p129t18  keep the selected Source as Default for this Capture Application.}
{   uses :    GetDSSourcesList(dsList : Tstrings; var dsDft : integer);}
procedure TfrmCapConfig.UpdateTWAINDefault();
var
  iniTwainSourceInt : integer;
  iniTwainSource : string;
  curTwainSourceInt : integer;
  curTwainSource : string;
  dsList : Tstrings;
begin
dsList := Tstringlist.create;
try
MagTwain1.GetDSSourcesList(dsList,curTwainSourceInt);
curTwainSource := dslist[curTwainSourceInt];
;
iniTwainSource := GetINIEntry('SYS_TWAIN','DEFAULT');

if iniTwainSource <> curTwainSource then
  begin
   {Changing TWAIN source, so we Notify user and store the selection and quit.}
    SetINIEntry('SYS_TWAIN','DEFAULT',curTwainSource);
    if (iniTwainSource = '') then iniTwainSource := 'undefined';
    
    magappmsg('d','Changing the Default TWAIN source for this application ' +  #13 + #13
                + 'From:  ' + iniTwainSource + #13 + #13
                + 'To:      ' + curTwainSource );

    exit;
  end;
finally
  dslist.Free;
end;



end;

Procedure TfrmCapConfig.FormDestroy(Sender: Tobject);
Begin
  SaveFormPosition(Self As TForm);
End;

Procedure TfrmCapConfig.BitmapClick(Sender: Tobject);
Begin
//p117T3-CH1      If TeleReaderConsultDICOMOnly Then Exit; //106
  QuickClose;
  UnCheckFormatRB(sender);
  INITbitmap;
End;

Procedure TfrmCapConfig.ClipboardClick(Sender: Tobject);
Begin
//p117T3-CH1    If TeleReaderConsultImportOnly Then Exit; //106
  QuickClose;
    UnCheckSourceRB(sender);
  InitClipboard;
End;

Procedure TfrmCapConfig.bShowConfigsClick(Sender: Tobject);
Begin
  Frmcapmain.OpenConfigList;
End;

procedure TfrmCapConfig.btnTwainSettingsClick(Sender: TObject);
begin
MagTwain1.SourceShowUI;
end;

Procedure TfrmCapConfig.BitBtn2Click(Sender: Tobject);

Begin
  FrmConfigList.SaveSettingAs;

End;

Procedure TfrmCapConfig.QuickClose;
Begin
// frmCapMain.F140PDFon := false;
//  frmcapmain.F140PDFConvert := False;     //p140t1  ? here ?      NO!
  If (Frmcapmain.FCloseQuickSetting And MagFloatConfig.Visible) Then MagFloatConfig.Close;
End;

Procedure TfrmCapConfig.ClinProcClick(Sender: Tobject);
Begin
//p117T3-CH1        ClearDICOMFormat(); //106
  QuickClose;
  INITClinProc;
End;

Procedure TfrmCapConfig.bMetSettingsClick(Sender: Tobject);
Var
  cmd: String;
Begin
  //launch the meteor configuration window
  //don't need to check if process is running because we are using wait mode
  cmd := AppPath + '\ActiveMILDefault.exe';
  WinExecAndWait32(cmd, 1, MeteorProcessInfo);

End;

procedure TfrmCapConfig.cbMultipleCaptureClick(Sender: TObject);
begin
  if cbMultipleCapture.Checked then
     begin
       if ImageGroup.Checked then imageGroup.Checked := false
           end;

 // showmessage('Checked : ' + magbooltostr(cbMultipleCapture.Checked));
  EnableMultipleCaptures(cbMultipleCapture.Checked) ;

CapButtonCaption;
end;

procedure TfrmCapConfig.EnableMultipleCaptures(value : boolean);
begin
CapX.m140MultSources := value;
if CapX.m140CombineScans then CapX.m140CombineScans := false;

 if value
   then
     begin
     cbPDFConvert.Checked := true;
     frmCapMain.btnReview.visible := true;
     CapX.m140PDFConvert := true;

     {DONE : NEED TO ADD A reVIEW bUTTON}
     end
   else
     begin
     frmCapMain.btnReview.visible := false;
//140 get to field
//     CapX.m140PDFConvert := cbPDFConvert.Checked;
      self.cbMultipleCapture.Checked := false;
      CapX.m140MultSources := false;
     end;
 
end;


procedure TfrmCapConfig.EnableCombineTIF(value : boolean);
begin
CapX.m140CombineScans := value;
 if value
   then
     begin
     frmCapMain.AllPagesChecked(true);
     frmCapMain.btnCapture.Enabled := true;
     frmCapMain.btnReview.visible := true;
     {If we are combining,  and if the first scan was a single page,  then we need to Copy resetfile.tif to multipage.tif}

     {DONE : NEED TO ADD A reVIEW bUTTON}
     end
   else
     begin
     frmCapMain.btnReview.visible := false;
     end;
 
end;

procedure TfrmCapConfig.EnableCombinePDF(value : boolean);
begin
CapX.m140PDFConvert := value;
CapX.m140CombineScans := value;
 if value
   then
     begin
     frmCapMain.btnCapture.Enabled := true;
     frmCapMain.btnReview.visible := true;
     {DONE : NEED TO ADD A reVIEW bUTTON}
     end
   else
     begin
     frmCapMain.btnReview.visible := false;
     end;
 
end;

Procedure TfrmCapConfig.cbImportBatchClick(Sender: Tobject);
Begin
  If Frmcapmain.cbBatch.Checked <> cbImportBatch.Checked Then Frmcapmain.cbBatch.Checked := cbImportBatch.Checked;
End;

Procedure TfrmCapConfig.cbTwainALLPagesClick(Sender: Tobject);
Begin
    Frmcapmain.ALLPagesChecked(cbTwainALLPages.Checked);  {cbTwainALLPagesClick}

 // If Frmcapmain.cb ALLPages.Checked <> cb TwainALLPages.Checked Then Frmcapmain.cb ALLPages.Checked := cb TwainALLPages.Checked;
 // CapX.mMultipage := cb TwainAllPages.Checked;
End;

Procedure TfrmCapConfig.TeleReaderConsultClick(Sender: Tobject);
Begin
  QuickClose;
  INITTeleReaderConsult;
End;


Procedure TfrmCapConfig.DICOMFormatClick(Sender: Tobject); //106
Begin
  QuickClose;
  UnCheckFormatRB(sender);
  INITDICOMFormat();
End;

{//p117T3-CH1   gek: taking off all 'hard coded' handling of Dicom TRC. 
             to stop other devices from being selected.}
{ gek: this is 106, to stop other formats from being selected.}
{DONE:  refactor to design of Import-Convert}
(* Function TfrmCapConfig.TeleReaderConsultImportOnly: Boolean; //106
Begin
  Result := False;
  EXIT;
  {/p117T3-CH1  gek 1/24/11  taking off all 'special' handling of Dicom TRC.  }
  If TeleReaderConsult.Checked Then
  Begin
  ...
  ked := True;
        Result := True;
      End;
    End;//p106 rlm 106t10  20101124 Fix Fix Garrett's "Infinite loop dialogs" START
  End
  Else
  Begin
   ....
  End;
End;
*)

{ gek: this is 106, to stop other formats from being selected.}
{DONE:  refactor to design of Import-Convert}
(* Function TfrmCapConfig.TeleReaderConsultDICOMOnly: Boolean; //106
Begin
  Result := False;
  EXIT;
  {/p117T3-CH1  gek 1/24/11  taking off all 'special' handling of Dicom TRC.  }
  If TeleReaderConsult.Checked Then
  Begin
  ......
      End;
    End; //p106 rlm 106t10  20101124 Fix Fix Garrett's "Infinite loop dialogs" START
  End
  Else
  Begin
    .....
  End;
End;
*)

{ gek: this is 106, to stop other formats from being selected.}
{DONE:  refactor to design of Import-Convert}
(*  Procedure TfrmCapConfig.ClearDICOMFormat(); //106
Begin
  EXIT;
  {/p117T3-CH1  gek 1/24/11  taking off all 'special' handling of Dicom TRC.  }

  DICOMFormat.Checked := False;
  Frmcapmain.Lbformatdesc.caption := Nullsetting;
End;
*)


{ //117 gek: this is new to 106 }
{ this functionalty is done other places in the flow }
(*   /p117 gek out.
Procedure TfrmCapConfig.INITAssociationVars; //p106 rlm 20101105 CR562
Begin
  CPPtr := '';
  Frmcapmain.FCapClinDataObj.Clear;
  LabPtr := '';
  MedPtr := '';
  RadPtr := '';
  SurPtr := '';
  TRConsultPtr := '';
  ImportIniDesc();//p106 rlm 106 t10 20101124 Fix Fix Garrett's "Infinite loop dialogs"
End;    *)

End.
