Program MAG_DCMView;

uses
  Forms,
  fmagRadViewer in 'fmagRadViewer.pas' {frmRadViewer},
  fMagCTConfigure in 'fMagCTConfigure.pas' {frmCTConfigure},
  fMagAnnot in '..\Shared\fMagAnnot.pas' {MagAnnot},
  fMagAnnotationOptionsX in '..\Shared\fMagAnnotationOptionsX.pas' {frmAnnotOptionsX},
  fMagAnnotationMarkProperty in '..\Shared\fMagAnnotationMarkProperty.pas' {frmMagAnnotationMarkProperty},
  FMagImage in '..\Shared\FMagImage.pas' {MagImage: TFrame};

{$R *.res}

Begin
  Application.Initialize;
  Application.Title := 'MagDICOMViewer';
  Application.CreateForm(TfrmRadViewer, frmRadViewer);
  Application.Run;
End.
