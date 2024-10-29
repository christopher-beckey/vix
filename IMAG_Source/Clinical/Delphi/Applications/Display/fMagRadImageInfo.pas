Unit FMagRadImageInfo;

Interface

Uses
  cMag4Vgear,
  Controls,
  Forms,
  Stdctrls,
  Classes
  ;

//Uses Vetted 20090929:uMagClasses, Dialogs, Graphics, Classes, Variants, Messages, Windows, SysUtils

Type
  TfrmRadImageInfo = Class(TForm)
    btnOK: TButton;
    LblMaxPixel: Tlabel;
    LblFileName: Tlabel;
    LblCompression: Tlabel;
    LblFormat: Tlabel;
    LblBitDepth: Tlabel;
    LblDimensions: Tlabel;
    LblPageCount: Tlabel;
    LbPtID: Tlabel;
    LbPtName: Tlabel;
    Label7: Tlabel;
    Label8: Tlabel;
    Label2: Tlabel;
    Label3: Tlabel;
    Label4: Tlabel;
    Label9: Tlabel;
    Label5: Tlabel;
    Label6: Tlabel;
    Label10: Tlabel;
    Procedure btnOKClick(Sender: Tobject);
  Private
    { Private declarations }
  Public
    Procedure Execute(VGear: TMag4VGear; ForDicomViewer: Boolean = False);
  End;

//var
//  frmRadImageInfo: TfrmRadImageInfo;

Implementation
Uses
  SysUtils
  ;

{$R *.dfm}

Procedure TfrmRadImageInfo.Execute(VGear: TMag4VGear; ForDicomViewer: Boolean = False);
Begin
  //lbPtID.Caption := vGear.PI_ptrData.SSN;
  LbPtID.caption := VGear.Dicomdata.PtID;
  // if Rad Viewer, use data from VistA
  // if DICOM Viewer use DICOM Header/Txt file
  If (VGear.PI_ptrData <> Nil) And (Not ForDicomViewer) Then
    LbPtName.caption := VGear.PI_ptrData.PtName
  Else
    If VGear.Dicomdata <> Nil Then
      LbPtName.caption := VGear.Dicomdata.PtName
    Else
      LbPtName.caption := '';

  LblPageCount.caption := Inttostr(VGear.PageCount);
  LblDimensions.caption := Inttostr(VGear.GetImageWidth()) + ' x ' + Inttostr(VGear.GetImageHeight());
  LblBitDepth.caption := Inttostr(VGear.GetBitsPerPixel) + ' bit(s) per pixel';
  LblFormat.caption := VGear.GetFileFormat();
  LblCompression.caption := VGear.GetCompression();
  LblMaxPixel.caption := Inttostr(VGear.GetState.MaxPixelValue); // '???';

  Showmodal();

End;

Procedure TfrmRadImageInfo.btnOKClick(Sender: Tobject);
Begin
  ModalResult := MrOK;
End;

End.
