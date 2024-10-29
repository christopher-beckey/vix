
library MagAnnTool;

uses
  ComServ,
  CPRSChart_TLB in 'CPRSChart_TLB.pas',
  AnnotationTool_TLB in 'AnnotationTool_TLB.pas',
  AnnotationPlugIn in 'AnnotationPlugIn.pas' {AnnotationPlugIn: CoClass},
  fmagCapAnnotate in 'fmagCapAnnotate.pas' {frmCapAnnotate},
  About1 in 'About1.pas' {frmAbout},
  FileOpenDialog in 'FileOpenDialog.pas' {frmOpenDialog};

exports
  DllGetClassObject,
  DllCanUnloadNow,
  DllRegisterServer,
  DllUnregisterServer;

{$R *.TLB}

{$R *.RES}

begin
end.
