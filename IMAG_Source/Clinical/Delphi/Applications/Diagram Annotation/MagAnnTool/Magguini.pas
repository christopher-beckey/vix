unit Magguini;
   {
   Package: MAG - VistA Imaging
   WARNING: Per VHA Directive 10-93-142 this unit should not be modified.
   Date Created:
   Site Name: Silver Spring, OIFO
   Developers: Garrett Kirin
   Description: Imaging Utilities for management of Mag.ini file.
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


interface
uses inifiles, SYSUTILS, classes,
  WinTypes, WinProcs, Messages, Graphics, Controls,
  StdCtrls, ExtCtrls, forms ;

procedure ConvertInputTypeToInputSource(Tempini: Tinifile);
procedure ConvertTypeToFormat(Tempini: Tinifile);
procedure ConvertSpecToAssoc(Tempini: Tinifile);
procedure CheckMagINI; // 01/25/02 Now Only called from MagCheck.exe from MAGSETUP.
procedure CreateMagINI; // This called from Disp and Cap 01/25/02
function CreateIFNeeded: boolean;
function GetConfigFileName(xDirectory : string = ''): string;
function FindConfigFile(): string;
function IsUpdateNeeded(appversion: string): boolean; // Patch 8 calls to display a message.
procedure UpdateIfNeeded(appversion: string);
function MagGetWindowsDirectory: string;
implementation

//  8888888888888888888888888888888888888888888888
// 03/12/2002  Patch 7
//   We stopped calling CheckMagIni everytime we started the application
//   but now, changes to ConfigFile don't get set.
//   i.e. new Specialty_Choices aren't there.
//   So We'll call this procedure UpdateIfNeeded, from Display
//   and Capture.  And only update if needed.

function IsUpdateNeeded(appversion: string): boolean;
begin
try
 with tinifile.create(GetConfigFileName) do
   begin
     try
     result :=  (appversion <> ReadString('SYS_AUTOUPDATE', 'LASTINIUPDATE', ''));
     finally
     free;
     end;
   end;
except
result := false;
end;
end;

procedure UpdateIFNeeded(appversion: string);
var updversion: string;
begin

 with tinifile.create(GetConfigFileName) do
   begin
    try
    if (ReadString('SYS_AUTOUPDATE', 'SKIPINIUPDATE', 'FALSE') = 'TRUE')
      then EXIT;

    updversion := ReadString('SYS_AUTOUPDATE', 'LASTINIUPDATE', '');
    if (updversion <> appversion) then
      begin
       checkmagini;
       writeString('SYS_AUTOUPDATE', 'LASTINIUPDATE', appversion);
      end;
    finally
    free;
    end;
  end;
end;

function MagGetWindowsDirectory: string;
var size: word;
  windir: pchar;
begin
  size := 300;
  windir := stralloc(301);
  GetWindowsDirectory(windir, Size);
  result := strpas(windir);
end;

function CreateIFNeeded: boolean;
begin

  if fileexists(GetConfigFileName)
    then result := false
    else
      begin
        result := true;
        CreateMagINI;
      end;
end;

procedure CreateMagINI;
var s : string;

begin
  deletefile(pchar(GetConfigFileName));
    with tinifile.create(GetConfigFileName) do
    begin
     try
      // Testing has shown that INI file functions, sections, and entries are not case sensitive
      // BUT of course the VALUES of the entries are.

      WriteString('Demo Options', 'Open Abstract Window', 'TRUE');

      writestring('Login Options', 'Local VistA', 'BROKERSERVER');
      writestring('Login Options', 'Local VistA port', '9200');

      writestring('Login Options', 'LoginOnStartup', 'TRUE');
      writestring('Login Options', 'AllowRemoteLogin', 'FALSE');

      WRITESTRING('choice_Input Source_Default', '1', 'Lumisys75');
//p8      WRITESTRING('choice_Input Source_Default', '2', 'Lumisys100');
      WRITESTRING('choice_Input Source_Default', '3', 'Lumisys150');
//p8      WRITESTRING('choice_Input Source_Default', '4', 'Vista');
//p8      WRITESTRING('choice_Input Source_Default', '5', 'VistaInteractive');
      WRITESTRING('choice_Input Source_Default', '6', 'Meteor');
      WRITESTRING('choice_Input Source_Default', '7', 'Import');
      WRITESTRING('choice_Input Source_Default', '8', 'TWAIN');
//p8      WRITESTRING('choice_Input Source_Default', '9', 'ScanJetXray');
//p8      WRITESTRING('choice_Input Source_Default', '10', 'SCANECG');
      WRITESTRING('choice_Input Source_Default', '11', 'ScannedDocument');
      WRITESTRING('choice_Input Source_Default', '12', 'ClipBoard');

//p8      writestring('Input Source', 'ScanJetXray', 'FALSE');
      writestring('Input Source', 'Lumisys75', 'FALSE');
//p8      writestring('Input Source', 'Lumisys100', 'FALSE');
      writestring('Input Source', 'Lumisys150', 'FALSE');
//p8      writestring('Input Source', 'Vista', 'FALSE');
      writestring('Input Source', 'Meteor', 'FALSE');
      writestring('Input Source', 'TWAIN', 'FALSE');
      writestring('Input Source', 'Import', 'FALSE');
//p8      writestring('Input Source', 'SCANECG', 'FALSE');
      writestring('Input Source', 'ClipBoard', 'FALSE');
      writestring('Input Source', 'ScannedDocument', 'FALSE');
//p8      writestring('Input Source', 'VistaInteractive', 'FALSE');
      writestring('Input Source', 'Default', 'NONE');
//p8      writestring('Input Source', 'ScanJetXray', 'FALSE');

//p8      writestring('Input Source', 'Lumisys100 FilmSize', '14" x 17"');

      writestring('Image Format', 'True Color TGA', 'FALSE');
      writestring('Image Format', 'True Color JPG', 'FALSE');
      writestring('Image Format', '256 Color', 'FALSE');
      writestring('Image Format', 'Xray', 'FALSE');
      writestring('Image Format', 'Xray JPG', 'FALSE');
      writestring('Image Format', 'Black and White', 'FALSE');
      writestring('Image Format', 'Document TIF Uncompressed', 'FALSE');
      writestring('Image Format', 'Document TIF G4 FAX', 'FALSE');
      writestring('Image Format', 'Bitmap', 'FALSE');
      writestring('Image Format', 'Motion Video', 'FALSE');
      writestring('Image Format', 'Audio', 'FALSE');
      writestring('Image Format', 'Default', 'Document TIF G4 FAX');

      WRITESTRING('choice_Image Format_Default', '1', 'True Color TGA');
      WRITESTRING('choice_Image Format_Default', '2', 'True Color JPG');
      WRITESTRING('choice_Image Format_Default', '3', '256 Color');
      WRITESTRING('choice_Image Format_Default', '4', 'Xray');
      WRITESTRING('choice_Image Format_Default', '5', 'Xray JPG');
      WRITESTRING('choice_Image Format_Default', '6', 'Black and White');
      WRITESTRING('choice_Image Format_Default', '7', 'Document TIF Uncompressed');
      WRITESTRING('choice_Image Format_Default', '8', 'Document TIF G4 FAX');
      WRITESTRING('choice_Image Format_Default', '9', 'Motion Video');
      WRITESTRING('choice_Image Format_Default', '10', 'Audio');
      { TODO : change to new Assoc values }
      writestring('Image Association', 'Laboratory', 'FALSE');
      writestring('Image Association', 'Medicine', 'FALSE');
      writestring('Image Association', 'Radiology', 'FALSE');
      writestring('Image Association', 'Surgery', 'FALSE');
      writestring('Image Association', 'Progress Notes', 'FALSE');
      //CLINPROCMOD
      writestring('Image Association', 'Clinical Procedures', 'FALSE');
      writestring('Image Association', 'PhotoID', 'FALSE');
      writestring('Image Association', 'Clinical Image', 'FALSE');
      //ADMINDOC
      writestring('Image Association', 'Admin Documents', 'FALSE');
      writestring('Image Association', 'Default', 'CLINIMAGE');
      { TODO : change to new Assoc values }
      WRITESTRING('Choice_Image Association_Default', '1', 'LAB');
      WRITESTRING('Choice_Image Association_Default', '2', 'MED');
      WRITESTRING('Choice_Image Association_Default', '3', 'RAD');
      WRITESTRING('Choice_Image Association_Default', '4', 'SUR');
      WRITESTRING('Choice_Image Association_Default', '5', 'NOTES');
      WRITESTRING('Choice_Image Association_Default', '6', 'CLINPROC');
      WRITESTRING('Choice_Image Association_Default', '7', 'PHOTOID');
      WRITESTRING('Choice_Image Association_Default', '8', 'CLINIMAGE');
      //ADMINDOC  12/04/2001
      WRITESTRING('Choice_Image Association_Default', '9', 'ADMINDOC');

      writestring('Button/Field Options', 'CreateDefaultImageDesc', 'TRUE');
      writestring('Button/Field Options', 'ImageDesc', 'Selected (Windows default)');

      WRITESTRING('Choice_Button/Field Options_ImageDesc', '1', 'Selected (Windows default)');
      WRITESTRING('Choice_Button/Field Options_ImageDesc', '2', 'NoSelectCursorEnd');
      WRITESTRING('Choice_Button/Field Options_ImageDesc', '3', 'NoSelectCursorHome');

      writestring('Medicine Options', 'Create New/List Existing', 'Create New');
      writestring('Medicine Options', 'Create Procedure stub first', 'FALSE');
      WRITESTRING('Choice_Medicine Options_Create New/List Existing', '1', 'Create New');
      WRITESTRING('Choice_Medicine Options_Create New/List Existing', '2', 'List Existing');

      writestring('SaveOptions', 'Default', 'GROUP');

      WRITESTRING('choice_SaveOptions_default', '1', 'GROUP');
      WRITESTRING('choice_SaveOptions_default', '2', 'SINGLE');

      writestring('Import Options', 'Type', 'Copy to Server');
      s := extractfilepath(application.exename)+'import';
      writestring('Import Options', 'DefaultImportDir', s);
      writestring('Import Options', 'DefaultMask', '*.*');

      WRITESTRING('Choice_Import Options_Type', '1', 'Copy to Server');
      WRITESTRING('Choice_Import Options_Type', '2', 'Convert to TGA');
      WRITESTRING('Choice_Import Options_Type', '3', 'Convert File Format to Default');

      Writestring('Input Source Options', '256 Color Enabled', 'FALSE');

      writestring('Workstation Settings', 'ID', 'UNKnown');
      writestring('Workstation Settings', 'Location', 'UNKnown');
      writestring('Workstation Settings', 'Abstracts created', 'TRUE');
      writestring('Workstation Settings', 'Save Radiology BIG File', 'FALSE');
      writestring('Workstation Settings', 'Display JukeBox Abstracts', 'FALSE');    // p8t14   //p14 take out
      writestring('Workstation Settings', 'Log Session Actions', 'FALSE');
      writestring('Workstation Settings', 'VistaRad test mode', 'FALSE');   //p14 take out
      writestring('Workstation Settings', 'CacheLocationID', '');  //p14 take out
      writestring('Workstation Settings', 'MUSE Enabled', 'FALSE');
      writestring('Workstation Settings', 'MUSE Demo Mode', 'FALSE');
      writestring('Workstation Settings', 'Allow Image SaveAs', 'FALSE');
      writestring('Workstation Settings', 'Fake Name', 'Lightyear,Buzz');
      writestring('Workstation Settings', 'Allow Fake Name', 'FALSE');
      writestring('Workstation Settings', 'WorkStation TimeOut minutes', '0');
      writestring('Workstation settings', 'Alternate Video Viewer', 'C:\WINNT\SYSTEM32\MPlay32.exe');

      writestring('SYS_AUTOUPDATE', 'DIRECTORY', 'NONE');

//p8
(*      WRITESTRING('choice_Input Source_Lumisys100 FilmSize', '1', '14" x 17"');
      WRITESTRING('choice_Input Source_Lumisys100 FilmSize', '2', '14" x 17" (1728 x 2304)');
      WRITESTRING('choice_Input Source_Lumisys100 FilmSize', '3', '14" x 17" (1536 x 2048)');
      WRITESTRING('choice_Input Source_Lumisys100 FilmSize', '4', '10" x 12"');
      WRITESTRING('choice_Input Source_Lumisys100 FilmSize', '5', '8" x 10"');
      WRITESTRING('choice_Input Source_Lumisys100 FilmSize', '6', '4" x 5"');
      WRITESTRING('choice_Input Source_Lumisys100 FilmSize', '7', '2" x 2" (Dental High Res)');
  *)
      {   FW FL PPL ; X  Y }
(*      s := '14" x 17"'; v := '/FW:14 /FL:17 /PPL:1024;/S:1024,1208';
      WRITESTRING('SYS_FilmSize_Lumisys100', s, v);
      s := '14" x 17" (1728 x 2304)'; v := '/FW:14 /FL:17 /PPL:1728;/S:1728,2304';
      WRITESTRING('SYS_FilmSize_Lumisys100', s, v);
      s := '14" x 17" (1536 x 2048)'; v := '/FW:14 /FL:17 /PPL:1536;/S:1536,2048';
      WRITESTRING('SYS_FilmSize_Lumisys100', s, v);
      s := '10" x 12"'; v := '/FW:10 /FL:12 /PPL:1024;/S:730,876';
      WRITESTRING('SYS_FilmSize_Lumisys100', s, v);
      s := '8" x 10"'; v := '/FW:8 /FL:10 /PPL:1024;/S:584,730';
      WRITESTRING('SYS_FilmSize_Lumisys100', s, v);
      s := '4" x 5"'; v := '/FW:4 /FL:5 /PPL:1024;/S:292,365';
      WRITESTRING('SYS_FilmSize_Lumisys100', s, v);
      s := '2" x 2" (Dental High Res)'; v := '/FW:2 /FL:2 /PPL:2048;/S:292,292';
      WRITESTRING('SYS_FilmSize_Lumisys100', s, v);
  *)
      Writestring('SYS_Meteor', 'INTERACTIVE', 'TRUE');


  finally
    free;
  end; {TRY}
  end; {WITH}
end;

//  8888888888888888888888888888888888888888888888

procedure CheckMagINI;
var tini: tinifile;
  s, s1, s2: string;
begin
  tini := tinifile.create(GetConfigFileName);
  try
    with TINI do
    begin
      // Testing has shown that INI file functions, sections, and entries are not case sensitive
      // BUT of course the VALUES of the entries are.
      s := UPPERCASE(ReadString('demo options', 'IMAGE DEMO ENABLED', ''));
      if (s = '') then (WriteString('demo options', 'IMAGE DEMO ENABLED', 'FALSE'));
      ///  P8t44     If the INI has ENTRY=     then the Readstring will be defined as '' , not as
      ///  any default i.e. 'TRUE'  in next line.  So this  s := ... if s = '' then  ' set the default'

      s := Uppercase(Readstring('Demo Options', 'Open Abstract Window', ''));
      if (s = '') then WriteString('Demo Options', 'Open Abstract Window', 'TRUE');


      s := ReadString('Login Options', 'LoginOnStartup', '');
      if (s = '') then writestring('Login Options', 'LoginOnStartup', 'TRUE');
      S := ReadString('Login Options', 'AllowRemoteLogin', '')  ;
      if (s = '') then writestring('Login Options', 'AllowRemoteLogin', 'FLASE');
      s := Readstring('Login Options', 'Local VistA', '');
      if (s = '') then writestring('Login Options', 'Local VistA', 'BROKERSERVER');
      s := Readstring('Login Options', 'Local VistA port', '');
      if (s = '') then writestring('Login Options', 'Local VistA port', '9200');

      if ((ReadString('Input Source', 'TWAIN', '') = '') and
        (ReadString('Input Source', 'Import', '') = '')) then ConvertInputTypeToInputSource(TINI);
      EraseSection('InputType');

      if ReadString('Input Source', 'Lumisys75', '') = '' then
        writestring('Input Source', 'Lumisys75', 'FALSE');
      if ReadString('Input Source', 'Lumisys150', '') = '' then
        writestring('Input Source', 'Lumisys150', 'FALSE');
      if ReadString('Input Source', 'Meteor', '') = '' then
        writestring('Input Source', 'Meteor', 'FALSE');
      if ReadString('Input Source', 'TWAIN', '') = '' then
        writestring('Input Source', 'TWAIN', 'FALSE');
      if ReadString('Input Source', 'Import', '') = '' then
        writestring('Input Source', 'Import', 'FALSE');
      if ReadString('Input Source', 'ClipBoard', '') = '' then
        writestring('Input Source', 'ClipBoard', 'FALSE');
      if ReadString('Input Source', 'ScannedDocument', '') = '' then
        writestring('Input Source', 'ScannedDocument', 'FALSE');
      if ReadString('Input Source', 'Default', '') = '' then
        writestring('Input Source', 'Default', 'NONE');

      ERASESECTION('choice_InputType_Default');
      ERASESECTION('choice_Input Source_Default');
      WRITESTRING('choice_Input Source_Default', '1', 'Lumisys75');
//P8      WRITESTRING('choice_Input Source_Default', '2', 'Lumisys100');
      WRITESTRING('choice_Input Source_Default', '3', 'Lumisys150');
//P8      WRITESTRING('choice_Input Source_Default', '4', 'Vista');
//P8      WRITESTRING('choice_Input Source_Default', '5', 'VistaInteractive');
      WRITESTRING('choice_Input Source_Default', '6', 'Meteor');
      // 10/5/00  Take Vidar out of choices.  User will no longer be able to select it.
      //  Vidar is TWAIN so still possible to use the device.
      //WRITESTRING('choice_InputType_Default', '7', 'Vidar');
      WRITESTRING('choice_Input Source_Default', '7', 'Import');
      WRITESTRING('choice_Input Source_Default', '8', 'TWAIN');
//P8      WRITESTRING('choice_Input Source_Default', '9', 'ScanJetXray');
//P8      WRITESTRING('choice_Input Source_Default', '10', 'SCANECG');
      WRITESTRING('choice_Input Source_Default', '11', 'ScannedDocument');
      WRITESTRING('choice_Input Source_Default', '12', 'ClipBoard');

      if ((ReadString('Image Format', 'True Color JPG', '') = '') and
        (ReadString('Image Format', 'True Color TGA', '') = '')) then ConvertTypeToFormat(TINI);
      EraseSection('ImageType');
      if ReadString('Image Format', 'True Color TGA', '') = '' then
        writestring('Image Format', 'True Color TGA', 'FALSE');
      if ReadString('Image Format', 'True Color JPG', '') = '' then
        writestring('Image Format', 'True Color JPG', 'FALSE');
      if ReadString('Image Format', '256 Color', '') = '' then
        writestring('Image Format', '256 Color', 'FALSE');
      if ReadString('Image Format', 'Xray', '') = '' then
        writestring('Image Format', 'Xray', 'FALSE');
      if ReadString('Image Format', 'Xray JPG', '') = '' then
        writestring('Image Format', 'Xray JPG', 'FALSE');
      if ReadString('Image Format', 'Black and White', '') = '' then
        writestring('Image Format', 'Black and White', 'FALSE');
      if ReadString('Image Format', 'Document TIF Uncompressed', '') = '' then
        writestring('Image Format', 'Document TIF Uncompressed', 'FALSE');
      if ReadString('Image Format', 'Document TIF G4 FAX', '') = '' then
        writestring('Image Format', 'Document TIF G4 FAX', 'FALSE');
      if ReadString('Image Format', 'Bitmap', '') = '' then
        writestring('Image Format', 'Bitmap', 'FALSE');
      if ReadString('Image Format', 'Motion Video', '') = '' then
        writestring('Image Format', 'Motion Video', 'FALSE');
      if ReadString('Image Format', 'Audio', '') = '' then
        writestring('Image Format', 'Audio', 'FALSE');
      if ReadString('Image Format', 'Default', '') = '' then
        writestring('Image Format', 'Default', 'NONE');

      ERASESECTION('choice_ImageType_Default'); // old section
      ERASESECTION('choice_Image Format_Default');
      WRITESTRING('choice_Image Format_Default', '1', 'True Color TGA');
      WRITESTRING('choice_Image Format_Default', '2', 'True Color JPG');
      WRITESTRING('choice_Image Format_Default', '3', '256 Color');
      WRITESTRING('choice_Image Format_Default', '4', 'Xray');
      WRITESTRING('choice_Image Format_Default', '5', 'Xray JPG');
      WRITESTRING('choice_Image Format_Default', '6', 'Black and White');
      WRITESTRING('choice_Image Format_Default', '7', 'Document TIF Uncompressed');
      WRITESTRING('choice_Image Format_Default', '8', 'Document TIF G4 FAX');
      WRITESTRING('choice_Image Format_Default', '9', 'Motion Video');
      WRITESTRING('choice_Image Format_Default', '10', 'Audio');

      //9/10/02   convert specialty to Association
      if ((ReadString('Image Association', 'Laboratory', '') = '') and
        (ReadString('Image Association', 'Radiology', '') = '')) then ConvertSpecToAssoc(TINI);
      ERASESECTION('Specialty');
      if ReadString('Image Association', 'Laboratory', '') = '' then
        writestring('Image Association', 'Laboratory', 'FALSE');
      if ReadString('Image Association', 'Medicine', '') = '' then
        writestring('Image Association', 'Medicine', 'FALSE');
      if ReadString('Image Association', 'Radiology', '') = '' then
        writestring('Image Association', 'Radiology', 'FALSE');
      if ReadString('Image Association', 'Surgery', '') = '' then
        writestring('Image Association', 'Surgery', 'FALSE');
      if ReadString('Image Association', 'Progress Notes', '') = '' then
        writestring('Image Association', 'Progress Notes', 'FALSE');
      //CLINPROCMOD
      if ReadString('Image Association', 'Clinical Procedures', '') = '' then
        writestring('Image Association', 'Clinical Procedures', 'FALSE');
      if ReadString('Image Association', 'PhotoID', '') = '' then
        writestring('Image Association', 'PhotoID', 'FALSE');
      if ReadString('Image Association', 'Clinical Image', '') = '' then
        writestring('Image Association', 'Clinical Image', 'FALSE');
      //ADMINDOC
      if ReadString('Image Association', 'Admin Documents', '') = '' then
        writestring('Image Association', 'Admin Documents', 'FALSE');
      //   writestring('Specialty','None','');
      //9/10/02      writestring('Specialty', 'Other', '');
      if ReadString('Image Association', 'Default', '') = '' then
        writestring('Image Association', 'Default', 'ClinImage');
      { TODO : change to new Assoc values }
      ERASESECTION('Choice_Specialty_Default'); // old section
      ERASESECTION('Choice_Image Association_Default');
      WRITESTRING('Choice_Image Association_Default', '1', 'LAB');
      WRITESTRING('Choice_Image Association_Default', '2', 'MED');
      WRITESTRING('Choice_Image Association_Default', '3', 'RAD');
      WRITESTRING('Choice_Image Association_Default', '4', 'SUR');
      WRITESTRING('Choice_Image Association_Default', '5', 'NOTES');
      WRITESTRING('Choice_Image Association_Default', '6', 'CLINPROC');
      WRITESTRING('Choice_Image Association_Default', '7', 'PHOTOID');
      WRITESTRING('Choice_Image Association_Default', '8', 'CLINIMAGE');
      //ADMINDOC  12/04/2001
      WRITESTRING('Choice_Image Association_Default', '9', 'ADMINDOC');


      if ReadString('Button/Field Options', 'CreateDefaultImageDesc', '') = '' then
        writestring('Button/Field Options', 'CreateDefaultImageDesc', 'TRUE');
      if ReadString('Button/Field Options', 'ImageDesc', '') = '' then
        writestring('Button/Field Options', 'ImageDesc', 'Selected (Windows default)');

      ERASESECTION('Choice_Button/Field Options_ImageDesc');
      WRITESTRING('Choice_Button/Field Options_ImageDesc', '1', 'Selected (Windows default)');
      WRITESTRING('Choice_Button/Field Options_ImageDesc', '2', 'NoSelectCursorEnd');
      WRITESTRING('Choice_Button/Field Options_ImageDesc', '3', 'NoSelectCursorHome');

      if ReadString('Medicine Options', 'Create New/List Existing', '') = '' then
        writestring('Medicine Options', 'Create New/List Existing', 'Create New');
      if ReadString('Medicine Options', 'Create Procedure stub first', '') = '' then
        writestring('Medicine Options', 'Create Procedure stub first', 'FALSE');
      ERASESECTION('Choice_Medicine Options_Create New/List Existing');
      WRITESTRING('Choice_Medicine Options_Create New/List Existing', '1', 'Create New');
      WRITESTRING('Choice_Medicine Options_Create New/List Existing', '2', 'List Existing');

      if ReadString('SaveOptions', 'Default', '') = '' then
        writestring('SaveOptions', 'Default', 'GROUP');

      ERASESECTION('choice_SaveOptions_default');
      WRITESTRING('choice_SaveOptions_default', '1', 'GROUP');
      WRITESTRING('choice_SaveOptions_default', '2', 'SINGLE');


      s := ReadString('Import Options', 'Type', '');
      if (s = '') then s := 'Copy to Server';
      s1 := ReadString('Import Options', 'DefaultImportDir', '');
      if (s1 = '') then s1 := extractfilepath(application.exename) + 'import';
      s2 := ReadString('Import Options', 'DefaultMask', '');
      if (s2 = '') then s2 := '*.*';
      ERASESECTION('Import Options');
      writestring('Import Options', 'Type', s);
      writestring('Import Options', 'DefaultImportDir', s1);
      writestring('Import Options', 'DefaultMask', s2);

      ERASESECTION('Choice_Import Options_Type');
      WRITESTRING('Choice_Import Options_Type', '1', 'Copy to Server');
      WRITESTRING('Choice_Import Options_Type', '2', 'Convert to TGA');
      WRITESTRING('Choice_Import Options_Type', '3', 'Convert File Format to Default');

      if ReadString('Input Source Options', '256 Color Enabled', '') = '' then
        writestring('Input Source Options', '256 Color Enabled', 'FALSE');



      if ReadString('Workstation Settings', 'ID', '') = '' then
        writestring('Workstation Settings', 'ID', 'UNKnown');
      if ReadString('Workstation Settings', 'Location', '') = '' then
        writestring('Workstation Settings', 'Location', 'UNKnown');

      if ReadString('Workstation Settings', 'Abstracts created', '') = '' then
        writestring('Workstation Settings', 'Abstracts created', 'TRUE');
      if ReadString('Workstation Settings', 'Save Radiology BIG File', '') = '' then
        writestring('Workstation Settings', 'Save Radiology BIG File', 'FALSE');
      //IF ReadString('Workstation Settings','ABBREV','')='' THEN
      //   writestring('Workstation Settings','ABBREV','I2');
        // P8T14  STOP showing Jukebox abstracts "." (Period)
      //if ReadString('Workstation Settings', 'Display JukeBox Abstracts', '') = '' then  // P8T14  //p14 take out
        writestring('Workstation Settings', 'Display JukeBox Abstracts', 'FALSE');         // P8T14 //p14 take out
      if ReadString('Workstation Settings', 'Log Session Actions', '') = '' then
        writestring('Workstation Settings', 'Log Session Actions', 'FALSE');
      if ReadString('Workstation Settings', 'VistaRad test mode', '') = '' then    //p14 take out
        writestring('Workstation Settings', 'VistaRad test mode', 'FALSE');        //p14 take out
      if ReadString('Workstation Settings', 'CacheLocationID', '') = '' then       //p14 take out
        writestring('Workstation Settings', 'CacheLocationID', '');                 //p14 take out
      if ReadString('Workstation Settings', 'MUSE Enabled', '') = '' then
        writestring('Workstation Settings', 'MUSE Enabled', 'FALSE');
      if ReadString('Workstation Settings', 'MUSE Demo Mode', '') = '' then
        writestring('Workstation Settings', 'MUSE Demo Mode', 'FALSE');
      if ReadString('Workstation Settings', 'Allow Image SaveAs', '') = '' then
        writestring('Workstation Settings', 'Allow Image SaveAs', 'FALSE');
      if ReadString('Workstation Settings', 'Fake Name', '') = '' then
        writestring('Workstation Settings', 'Fake Name', 'Fake,PatientName');
      if ReadString('Workstation Settings', 'Allow Fake Name', '') = '' then
        writestring('Workstation Settings', 'Allow Fake Name', 'FALSE');
      s := ReadString('Workstation Settings', 'WorkStation TimeOut minutes', '');
      if ((s = '') or (s = '0')) then
        writestring('Workstation Settings', 'WorkStation TimeOut minutes', '0');
      //  if no default veiwer then we will just use the windows associated viewer;
      {IF ReadString('Workstation settings','Alternate Video Viewer','')=''
         THEN  writestring('Workstation settings','Alternate Video Viewer','C:\WINNT\SYSTEM32\MPlay32.exe');}

      if ReadString('SYS_AUTOUPDATE', 'DIRECTORY', '') = '' then
        writestring('SYS_AUTOUPDATE', 'DIRECTORY', 'NONE');

      ERASESECTION('choice_Input Source_Lumisys100 FilmSize');
      ERASESECTION('SYS_FilmSize_Lumisys100');
      ERASESECTION('choice_InputType_Meteor settings');
      (* Meteor settings are now being done by Matrox Defaults program*)
      ERASESECTION('SYS_FilmSize_Meteor');

      //Set interactive mode for meteor as default - clean up old stuff
      s := ReadString('SYS_Meteor', 'INTERACTIVE', 'TRUE');
      if (s='') then s := 'TRUE';
      ERASESECTION('SYS_Meteor');
        // We are erasing the whole section and only setting the One entry
      Writestring('SYS_Meteor', 'INTERACTIVE', s);
    end; {WITH TINI}

  finally
    tini.free;
  end; {TRY}
end;

function GetConfigFileName(xDirectory : string = ''): string;
var
//frFile, toFile : string;
//windir : string;
// todir : string;
   dir : string;
begin
// Patch 8 we now use mag308.ini for Patch 8 ini file.
// This call will copy the old mag.ini to apppath + mag308.ini if needed.
{TODO: Need to add check for application directory/ mag.ini FOR pATCH 33 Change.}

(* annotation had/has it's own copy of maguini... this was it, old from Patch 8..33
if (xDirectory <> '')
        then todir := xDirectory
        else todir := Extractfilepath(application.exename);
try
windir := MagGetWindowsDirectory ;
frFile :=  windir + '\MAG.INI';
toFile := todir  + 'mag308.ini';
  if (fileexists(frFile) and (not fileexists(toFile))) then
     begin
     copyfile(pchar(frFile),pchar(toFile),false);
     end;
finally
result := tofile;
end;  *)

  dir :=  GetEnvironmentVariable('ALLUSERSPROFILE') + '\Application Data\vista\imaging\' ;
  if (Xdirectory <> '') then  dir :=   Xdirectory;
  if Not Directoryexists(dir) then  Forcedirectories(dir);
  result := dir + 'mag.ini';

end;


{called from Patch 8 Magwrks.exe to find the config file.
  We no longer default to c:\winnt\mag.ini or even WindowsDir.
  This will load Patch 8 config. mag308.ini if it exists in this directory.
  or widowsdir\mag.ini}
function FindConfigFile(): string;
var oldini, p8ini : string;
windir : string;
 todir : string;
begin
{TODO: Need to add check for application directory/ mag.ini FOR pATCH 33 Change.}
todir := Extractfilepath(application.exename);
windir := MagGetWindowsDirectory ;
oldini :=  windir + '\MAG.INI';
p8ini := todir  + '\mag308.ini';
  if fileexists(p8ini)
    then result := p8ini
    else result := oldini;
end;


procedure ConvertTypeToFormat(Tempini: Tinifile);
begin
  with tempini do
  begin
    writestring('Image Format', 'True Color TGA', ReadString('ImageType', 'True Color TGA', 'FALSE'));
    writestring('Image Format', 'True Color JPG', ReadString('ImageType', 'True Color JPG', 'FALSE'));
    writestring('Image Format', '256 Color', ReadString('ImageType', '256 Color', 'FALSE'));
    writestring('Image Format', 'Xray', ReadString('ImageType', 'Xray', 'FALSE'));
    writestring('Image Format', 'Xray JPG', ReadString('ImageType', 'Xray JPG', 'FALSE'));
    writestring('Image Format', 'Black and White', ReadString('ImageType', 'Black and White', 'FALSE'));
    writestring('Image Format', 'Document TIF Uncompressed', ReadString('ImageType', 'Document TIF Uncompressed', 'FALSE'));
    writestring('Image Format', 'Document TIF G4 FAX', ReadString('ImageType', 'Document TIF G4 FAX', 'FALSE'));
    writestring('Image Format', 'Bitmap', ReadString('ImageType', 'Bitmap', 'FALSE'));
    writestring('Image Format', 'Motion Video', ReadString('ImageType', 'Motion Video', 'FALSE'));
    writestring('Image Format', 'Audio', ReadString('ImageType', 'Audio', 'FALSE'));
    writestring('Image Format', 'Default', ReadString('ImageType', 'Default', 'FALSE'));

    EraseSection('ImageType');
  end;

end;

procedure ConvertSpecToAssoc(Tempini: Tinifile);
var s : string;
begin
  with tempini do
  begin
    writestring('Image Association', 'Laboratory', ReadString('Specialty', 'Laboratory', 'FALSE'));
    writestring('Image Association', 'Medicine', ReadString('Specialty', 'Medicine', 'FALSE'));
    writestring('Image Association', 'Radiology', ReadString('Specialty', 'Radiology', 'FALSE'));
    writestring('Image Association', 'Surgery', ReadString('Specialty', 'Surgery', 'FALSE'));
    writestring('Image Association', 'Progress Notes', ReadString('Specialty', 'Progress Notes', 'FALSE'));
    writestring('Image Association', 'Clinical Procedures', ReadString('Specialty', 'Clinical Procedures', 'FALSE'));
    writestring('Image Association', 'PhotoID', ReadString('Specialty', 'PhotoID', 'FALSE'));
    //     'None;
    writestring('Image Association', 'Clinical Image', ReadString('Specialty', 'NONE', 'FALSE'));
    //     'Admin Documents'
    writestring('Image Association', 'Admin Documents', ReadString('Specialty', 'Admin Documents', 'FALSE'));
        s :=    ReadString('Specialty', 'Default', 'CLINIMAGE');
        if (UPPERCASE(s) = 'NONE' ) then s := 'CLINIMAGE';
    writestring('Image Association', 'Default', s);       //HERE
    //   writestring('Specialty','None','');
    //9/10/02      writestring('Specialty', 'Other', '');

    ERASESECTION('Specialty');
  end;

end;

procedure ConvertInputTypeToInputSource(Tempini: Tinifile);
begin
  with tempini do
  begin
   //P8 writestring('Input Source', 'ScanJetXray', ReadString('InputType', 'ScanJetXray', 'FALSE'));
    writestring('Input Source', 'Lumisys75', ReadString('InputType', 'Lumisys75', 'FALSE'));
   //P8 writestring('Input Source', 'Lumisys100', ReadString('InputType', 'Lumisys100', 'FALSE'));
    writestring('Input Source', 'Lumisys150', ReadString('InputType', 'Lumisys150', 'FALSE'));
   //P8 writestring('Input Source', 'Vista', ReadString('InputType', 'Vista', 'FALSE'));
    writestring('Input Source', 'Meteor', ReadString('InputType', 'Meteor', 'FALSE'));
    writestring('Input Source', 'TWAIN', ReadString('InputType', 'TWAIN', 'FALSE'));
    writestring('Input Source', 'Import', ReadString('InputType', 'Import', 'FALSE'));
   //P8 writestring('Input Source', 'SCANECG', ReadString('InputType', 'SCANECG', 'FALSE'));
    writestring('Input Source', 'ClipBoard', ReadString('InputType', 'ClipBoard', 'FALSE'));
    writestring('Input Source', 'ScannedDocument', ReadString('InputType', 'ScannedDocument', 'FALSE'));
    //P8writestring('Input Source', 'VistaInteractive', ReadString('InputType', 'VistaInteractive', 'FALSE'));
    writestring('Input Source', 'Default', ReadString('InputType', 'Default', 'Import'));
   //P8 writestring('Input Source', 'ScanJetXray', ReadString('InputType', 'ScanJetXray', 'FALSE'));
   //P8 writestring('Input Source', 'Lumisys100 FilmSize', ReadString('InputType', 'Lumisys100 FilmSize', '14" x 17"'));
    ERASESECTION('InputType');
  end;
end;


end.
