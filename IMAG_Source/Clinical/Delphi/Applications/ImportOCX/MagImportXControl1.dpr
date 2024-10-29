library MagImportXControl1;

uses
  ComServ,
  MagImportXControl1_TLB in 'MagImportXControl1_TLB.pas',
  MagImportImpl1 in 'MagImportImpl1.pas' {MagImportX: CoClass},
  About1 in 'About1.pas' {MagImportXAbout},
  cMagImport in '..\Shared\cMagImport.pas';

{$E ocx}

exports
  DllGetClassObject,
  DllCanUnloadNow,
  DllRegisterServer,
  DllUnregisterServer;

{$R *.TLB}

{$R *.RES}

begin
end.
