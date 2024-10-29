program MagMakeAbs2;

uses
  Forms,
  FormatInfo in '.\Shared\FormatInfo.pas' {frmFormatInfo},
  Components in '.\Shared\Components.pas' {frmComponents},
  ComponentsAttach in '.\Shared\ComponentsAttach.pas' {frmComponentsAttach},
  SharedGlobals in '.\Shared\SharedGlobals.pas',
  About in '.\Shared\About.pas' {frmAbout},
  frmMagMakeAbsMainForm in 'frmMagMakeAbsMainForm.pas' {frmMagMakeAbsMain},
  uMagDCMLoadFile in 'uMagDCMLoadFile.pas',
  uMagRMakeAbsError in 'uMagRMakeAbsError.pas',
  uMagrMakeAbsR2 in 'uMagrMakeAbsR2.pas';

{$R *.res}
{$DEFINE DISPLAY}
begin
  Application.Initialize;

// DISPLAY FORM
If Paramstr(1) = '' then
begin
Application.ShowMainForm := true; // makes the main form not visible when the app starts
end;
//  //2/7/07

// DON'T SHOW FORM
If Paramstr(1) <> '' then //parameters present so MakeAbs, no form
begin
Application.ShowMainForm := false;
end;
//

  ///  DON'T SHOW DISPLAY // 2/7/07
  // might need to look at parameters here to determine if the other forms of the app should be created

//If Paramstr(1) <> '' then  // is this backwards?
//If true then
//If Paramstr(1) = '' then     // Create forms for DISPLAY
//begin

  Application.CreateForm(TfrmMagMakeAbsMain, frmMagMakeAbsMain);
  Application.CreateForm(TfrmFormatInfo, frmFormatInfo);
  Application.CreateForm(TfrmComponents, frmComponents);
  Application.CreateForm(TfrmComponentsAttach, frmComponentsAttach);
  Application.CreateForm(TfrmAbout, frmAbout);
  //  end;
//  2/7/07
  Application.Run;
//end;  // RED 2/17/07
end.
