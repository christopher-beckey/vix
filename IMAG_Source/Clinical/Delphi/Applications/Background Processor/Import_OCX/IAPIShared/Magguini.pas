Unit Magguini;
   {
   Package: MAG - VistA Imaging
   WARNING: Per VHA Directive 10-93-142 this unit should not be modified.
   Date Created:
   Site Name: Silver Spring, OIFO
   Developers: Garrett Kirin
   Description: Imaging Utilities for management of Mag.ini file.
    - Creates MAG.INI if needed.
    - procedures to insert new INI Section Entries and their defaults if needed.
    - procedures to modify INI Section Entry defaults.
    - method to return the INI name (Configuration file name). All code should
      call here to get Configuration name.  It may change Patch to Patch

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
  Inifiles
  ;

{ The 'Convert' procedures are Patch 8 specific.  Older INI files used different
     section and entry names. These methods keep the data, change the names. }
Procedure ConvertInputTypeToInputSource(Tempini: TIniFile);
Procedure ConvertTypeToFormat(Tempini: TIniFile);
Procedure ConvertSpecToAssoc(Tempini: TIniFile);
{   will convert INI Values to new version of INI files.  This is used in patches
    where New INI sections are being distributed, and we need to set defaults }
Procedure CheckMagINI;
{   Create the MAG.INI with defaults }
Procedure CreateMagINI;
{    if the INI file doesn't exist, it will be created.}
Function CreateIFNeeded: Boolean;
{   Returns the INI file name.  This should be used everywhere in place of
    hardcoding the MAG.INI value. Old INI files are copied to Patch 8 INI }
Function GetConfigFileName(XDirectory: String = ''): String;
{       Just return the INI file name of the most recent INI file.}
Function FindConfigFile(): String;
Function IsUpdateNeeded(AppVersion: String): Boolean;
Procedure UpdateIfNeeded(AppVersion: String);
Function MagGetWindowsDirectory: String;
Implementation
Uses
  Forms,
  SysUtils,
  WinTypes
  ;

{ 03/12/2002  Patch 7
   We stopped calling CheckMagIni everytime we started the application
   and we'll call this procedure UpdateIfNeeded, from Display
   and Capture.  And only update if needed. {}

Function IsUpdateNeeded(AppVersion: String): Boolean;
Begin
  Try
    With TIniFile.Create(GetConfigFileName) Do
    Begin
      Try
        Result := (AppVersion <> ReadString('SYS_AUTOUPDATE', 'LASTINIUPDATE', ''));
      Finally
        Free;
      End;
    End;
  Except
    Result := False;
  End;
End;

Procedure UpdateIfNeeded(AppVersion: String);
Var
  Updversion: String;
Begin

  With TIniFile.Create(GetConfigFileName) Do
  Begin
    Try
      If (ReadString('SYS_AUTOUPDATE', 'SKIPINIUPDATE', 'FALSE') = 'TRUE') Then Exit;

      Updversion := ReadString('SYS_AUTOUPDATE', 'LASTINIUPDATE', '');
      If (Updversion <> AppVersion) Then
      Begin
        CheckMagINI;
        Writestring('SYS_AUTOUPDATE', 'LASTINIUPDATE', AppVersion);
      End;
    Finally
      Free;
    End;
  End;
End;

Function MagGetWindowsDirectory: String;
Var
  Size: Word;
  Windir: PChar;
Begin
  Size := 300;
  Windir := Stralloc(301);
  GetWindowsDirectory(Windir, Size);
  Result := Strpas(Windir);
  StrDispose(Windir);
End;

Function CreateIFNeeded: Boolean;
Begin
  If FileExists(GetConfigFileName) Then
    Result := False
  Else
  Begin
    Result := True;
    CreateMagINI;
  End;
End;

{ Patch 8:  we now use mag308.ini for Patch 8 ini file.
 This call will copy the old mag.ini to apppath + mag308.ini if needed.}

Function GetConfigFileName(XDirectory: String = ''): String;
Var
  P7iniFile,
    P33iniFile,
    P8iniFile: String;
  P7dir,
    P33_8dir: String;
Begin
{DONE: Need to add check for application directory/ mag.ini FOR pATCH 33 Change.}
  If (XDirectory <> '') Then
    P33_8dir := XDirectory
  Else
    P33_8dir := ExtractFilePath(Application.ExeName);
  Try
{ if Patch 8 ini file exists, then just exit}
    P8iniFile := P33_8dir + 'mag308.ini';
    If FileExists(P8iniFile) Then Exit;

{ decide which INI file to copy to Patch 8 INI }
    P7dir := MagGetWindowsDirectory;
    P7iniFile := P7dir + '\MAG.INI';
    P33iniFile := P33_8dir + 'mag.ini';

    If (FileExists(P33iniFile) And (Not FileExists(P8iniFile))) Then
    Begin
      CopyFile(PChar(P33iniFile), PChar(P8iniFile), False);
      Exit;
    End;
    If (FileExists(P7iniFile) And (Not FileExists(P8iniFile))) Then
    Begin
//     copyfile(pchar(p7iniFile),pchar(p8iniFile),false);
      Exit;
    End;
  Finally
    Result := P8iniFile;
  End;
End;

{called from any version of Magwrks.exe, Display, capture to find the config file.
  We no longer default to c:\winnt\mag.ini or even WindowsDir.
  This will Return the ini file name if it exists : in reverse order.
  first Patch 8         apppath\mag308.ini
  or Patch 33           apppath\mag.ini
  or Patch 7            windowsdirectory\mag.ini
}

Function FindConfigFile(): String;
Var
  P7iniFile,
    P33iniFile,
    P8iniFile: String;
  P7dir,
    P33_8dir: String;
Begin
{DONE: Need to add check for application directory/ mag.ini FOR pATCH 33 Change.}
  Result := '';
  P33_8dir := ExtractFilePath(Application.ExeName);
  P7dir := MagGetWindowsDirectory;

  P7iniFile := P7dir + '\MAG.INI';
  P33iniFile := P33_8dir + '\mag.ini';
  P8iniFile := P33_8dir + '\mag308.ini';

  If FileExists(P8iniFile) Then
    Result := P8iniFile
  Else
    If FileExists(P33iniFile) Then
      Result := P33iniFile
    Else
      If FileExists(P7iniFile) Then Result := P7iniFile;
End;

Procedure CreateMagINI;
Var
  s: String;
Begin
  DeleteFile(PChar(GetConfigFileName));
  With TIniFile.Create(GetConfigFileName) Do
  Begin
    Try
      { Research has shown that INI file functions, sections, and entries are not case sensitive
       BUT of course the VALUES of the entries are. {}

      Writestring('Demo Options', 'Open Abstract Window', 'TRUE');

//45 startchange
     // JMW 4/1/2005 p45 - determines if we use the demosites.txt file for site information or make SOAP call
      // if this is false we use SOAP, if true we use demosites.txt file.
      Writestring('Demo Options', 'DemoRemoteSites', 'FALSE');
      Writestring('Remote Site Options', 'RemoteImageViewsEnabled', 'TRUE');

      // JMW 6/16/2005 p45t3 Caching abstracts on by default
      Writestring('Workstation Settings', 'CacheAbstracts', 'TRUE');
//45 endchange
      Writestring('Login Options', 'Local VistA', 'BROKERSERVER');
      Writestring('Login Options', 'Local VistA port', '9200');

      Writestring('Login Options', 'LoginOnStartup', 'TRUE');
      Writestring('Login Options', 'AllowRemoteLogin', 'FALSE');

      Writestring('choice_Input Source_Default', '1', 'Lumisys75');
//p8      WRITESTRING('choice_Input Source_Default', '2', 'Lumisys100');
      Writestring('choice_Input Source_Default', '3', 'Lumisys150');
//p8      WRITESTRING('choice_Input Source_Default', '4', 'Vista');
//p8      WRITESTRING('choice_Input Source_Default', '5', 'VistaInteractive');
      Writestring('choice_Input Source_Default', '6', 'Meteor');
      Writestring('choice_Input Source_Default', '7', 'Import');
      Writestring('choice_Input Source_Default', '8', 'TWAIN');
//p8      WRITESTRING('choice_Input Source_Default', '9', 'ScanJetXray');
//p8      WRITESTRING('choice_Input Source_Default', '10', 'SCANECG');
      Writestring('choice_Input Source_Default', '11', 'ScannedDocument');
      Writestring('choice_Input Source_Default', '12', 'ClipBoard');

//p8      writestring('Input Source', 'ScanJetXray', 'FALSE');
      Writestring('Input Source', 'Lumisys75', 'FALSE');
//p8      writestring('Input Source', 'Lumisys100', 'FALSE');
      Writestring('Input Source', 'Lumisys150', 'FALSE');
//p8      writestring('Input Source', 'Vista', 'FALSE');
      Writestring('Input Source', 'Meteor', 'FALSE');
      Writestring('Input Source', 'TWAIN', 'FALSE');
      Writestring('Input Source', 'Import', 'FALSE');
//p8      writestring('Input Source', 'SCANECG', 'FALSE');
      Writestring('Input Source', 'ClipBoard', 'FALSE');
      Writestring('Input Source', 'ScannedDocument', 'FALSE');
//p8      writestring('Input Source', 'VistaInteractive', 'FALSE');
      Writestring('Input Source', 'Default', 'NONE');
//p8      writestring('Input Source', 'ScanJetXray', 'FALSE');

//p8      writestring('Input Source', 'Lumisys100 FilmSize', '14" x 17"');

      Writestring('Image Format', 'True Color TGA', 'FALSE');
      Writestring('Image Format', 'True Color JPG', 'FALSE');
      Writestring('Image Format', '256 Color', 'FALSE');
      Writestring('Image Format', 'Xray', 'FALSE');
      Writestring('Image Format', 'Xray JPG', 'FALSE');
      Writestring('Image Format', 'Black and White', 'FALSE');
      Writestring('Image Format', 'Document TIF Uncompressed', 'FALSE');
      Writestring('Image Format', 'Document TIF G4 FAX', 'FALSE');
      Writestring('Image Format', 'Bitmap', 'FALSE');
      Writestring('Image Format', 'DICOM', 'FALSE');
      Writestring('Image Format', 'Motion Video', 'FALSE');
      Writestring('Image Format', 'Audio', 'FALSE');
      Writestring('Image Format', 'Default', 'Document TIF G4 FAX');

      Writestring('choice_Image Format_Default', '1', 'True Color TGA');
      Writestring('choice_Image Format_Default', '2', 'True Color JPG');
      Writestring('choice_Image Format_Default', '3', '256 Color');
      Writestring('choice_Image Format_Default', '4', 'Xray');
      Writestring('choice_Image Format_Default', '5', 'Xray JPG');
      Writestring('choice_Image Format_Default', '6', 'Black and White');
      Writestring('choice_Image Format_Default', '7', 'Document TIF Uncompressed');
      Writestring('choice_Image Format_Default', '8', 'Document TIF G4 FAX');
      Writestring('choice_Image Format_Default', '9', 'Motion Video');
      Writestring('choice_Image Format_Default', '10', 'Audio');
      Writestring('choice_Image Format_Default', '11', 'Bitmap');
      Writestring('choice_Image Format_Default', '12', 'DICOM');
      {DONE : change to new Assoc values }
      Writestring('Image Association', 'Laboratory', 'FALSE');
      Writestring('Image Association', 'Medicine', 'FALSE');
      Writestring('Image Association', 'Radiology', 'FALSE');
      Writestring('Image Association', 'Surgery', 'FALSE');
      Writestring('Image Association', 'Progress Notes', 'FALSE');
      //CLINPROCMOD
      Writestring('Image Association', 'Clinical Procedures', 'FALSE');
      Writestring('Image Association', 'TeleReader Consult', 'FALSE');
      Writestring('Image Association', 'PhotoID', 'FALSE');
      Writestring('Image Association', 'Clinical Image', 'FALSE');
      //ADMINDOC
      Writestring('Image Association', 'Admin Documents', 'FALSE');
      Writestring('Image Association', 'Default', 'CLINIMAGE');
      {DONE : change to new Assoc values }
      Writestring('Choice_Image Association_Default', '1', 'LAB');
      Writestring('Choice_Image Association_Default', '2', 'MED');
      Writestring('Choice_Image Association_Default', '3', 'RAD');
      Writestring('Choice_Image Association_Default', '4', 'SUR');
      Writestring('Choice_Image Association_Default', '5', 'NOTES');
      Writestring('Choice_Image Association_Default', '6', 'CLINPROC');
      Writestring('Choice_Image Association_Default', '7', 'PHOTOID');
      Writestring('Choice_Image Association_Default', '8', 'CLINIMAGE');
      //ADMINDOC  12/04/2001
      Writestring('Choice_Image Association_Default', '9', 'ADMINDOC');
      Writestring('Choice_Image Association_Default', '10', 'TRCONSULT');

      Writestring('Button/Field Options', 'CreateDefaultImageDesc', 'TRUE');
      Writestring('Button/Field Options', 'ImageDesc', 'Selected (Windows default)');

      Writestring('Choice_Button/Field Options_ImageDesc', '1', 'Selected (Windows default)');
      Writestring('Choice_Button/Field Options_ImageDesc', '2', 'NoSelectCursorEnd');
      Writestring('Choice_Button/Field Options_ImageDesc', '3', 'NoSelectCursorHome');

      Writestring('Medicine Options', 'Create New/List Existing', 'Create New');
      Writestring('Medicine Options', 'Create Procedure stub first', 'FALSE');
      Writestring('Choice_Medicine Options_Create New/List Existing', '1', 'Create New');
      Writestring('Choice_Medicine Options_Create New/List Existing', '2', 'List Existing');

      Writestring('SaveOptions', 'Default', 'GROUP');

      Writestring('choice_SaveOptions_default', '1', 'GROUP');
      Writestring('choice_SaveOptions_default', '2', 'SINGLE');

      Writestring('Import Options', 'Type', 'Copy to Server');
      s := ExtractFilePath(Application.ExeName) + 'import';
      Writestring('Import Options', 'DefaultImportDir', s);
      Writestring('Import Options', 'DefaultMask', '*.*');

      Writestring('Choice_Import Options_Type', '1', 'Copy to Server');
      Writestring('Choice_Import Options_Type', '2', 'Convert to TGA');
      Writestring('Choice_Import Options_Type', '3', 'Convert File Format to Default');

      Writestring('Input Source Options', '256 Color Enabled', 'FALSE');

      Writestring('Workstation Settings', 'ID', 'UNKnown');
      Writestring('Workstation Settings', 'Location', 'UNKnown');
      Writestring('Workstation Settings', 'Abstracts created', 'TRUE');
      Writestring('Workstation Settings', 'Save Radiology BIG File', 'FALSE');
      Writestring('Workstation Settings', 'Display JukeBox Abstracts', 'FALSE'); // p8t14   //p14 take out
      Writestring('Workstation Settings', 'Log Session Actions', 'FALSE');
      Writestring('Workstation Settings', 'VistaRad test mode', 'FALSE'); //p14 take out
      Writestring('Workstation Settings', 'CacheLocationID', ''); //p14 take out
      Writestring('Workstation Settings', 'MUSE Enabled', 'TRUE');
      Writestring('Workstation Settings', 'MUSE Demo Mode', 'FALSE');
      Writestring('Workstation Settings', 'Allow Image SaveAs', 'FALSE');
      Writestring('Workstation Settings', 'Fake Name', 'Lightyear,Buzz');
      Writestring('Workstation Settings', 'Allow Fake Name', 'FALSE');
      Writestring('Workstation Settings', 'WorkStation TimeOut minutes', '0');
      Writestring('Workstation settings', 'Alternate Video Viewer', 'C:\WINNT\SYSTEM32\MPlay32.exe');

      Writestring('SYS_AUTOUPDATE', 'DIRECTORY', 'NONE');

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

    Finally
      Free;
    End; {TRY}
  End; {WITH}
End;

//  8888888888888888888888888888888888888888888888

Procedure CheckMagINI;
Var
  Tini: TIniFile;
  s, S1, S2: String;
Begin
  Tini := TIniFile.Create(GetConfigFileName);
  Try
    With Tini Do
    Begin
//106 Change  DICOM format.
      If Not ValueExists('IMAGE FORMAT', 'DICOM') Then Writestring('IMAGE FORMAT', 'DICOM', 'FALSE');//p106 rlm 8/25/2010
      // 
      { Research has shown that INI file functions, sections, and entries are not case sensitive
       BUT of course the VALUES of the entries are.}
      s := Uppercase(ReadString('demo options', 'IMAGE DEMO ENABLED', ''));
      If (s = '') Then (Writestring('demo options', 'IMAGE DEMO ENABLED', 'FALSE'));
      ///  P8t44     If the INI has ENTRY=     then the Readstring will be defined as '' , not as
      ///  any default i.e. 'TRUE'  in next line.  So this  s := ... if s = '' then  ' set the default'

//45 startchanges
      // JMW 4/26/2005 p45
      // Add values to old mag.ini files for RIV to use:

      s := Uppercase(ReadString('Demo Options', 'DemoRemoteSites', ''));
      If (s = '') Then Writestring('Demo Options', 'DemoRemoteSites', 'FALSE');
      s := Uppercase(ReadString('Remote Site Options', 'RemoteImageViewsEnabled', ''));
      Writestring('Remote Site Options', 'RemoteImageViewsEnabled', 'TRUE');

      {
      s := UpperCase(ReadString('Remote Site Options','RemoteSiteLookupServer',''));
      if (s = '') then WriteString('Remote Site Options','RemoteSiteLookupServer', 'http://vhaann26607.v11.med.va.gov/VistaWebSvcs/SiteService.asmx');
       }
      Deletekey('Remote Site Options', 'RemoteSiteLookupServer');
      // gek 93  5/18/2009  defalut Origin to VA.  IHS can change to IHS.
      s := Uppercase(ReadString('Workstation settings', 'DefaultOriginIndexValue', ''));
      If (s = '') Then Writestring('Workstation settings', 'DefaultOriginIndexValue', 'VA');

      // JMW 6/16/2005 p45t3 Caching abstracts on by default
      s := Uppercase(ReadString('Workstation Settings', 'CacheAbstracts', ''));
      If (s = '') Then Writestring('Workstation Settings', 'CacheAbstracts', 'TRUE');
//45 endchanges

      s := Uppercase(ReadString('Demo Options', 'Open Abstract Window', ''));
      If (s = '') Then Writestring('Demo Options', 'Open Abstract Window', 'TRUE');

      s := ReadString('Login Options', 'LoginOnStartup', '');
      If (s = '') Then Writestring('Login Options', 'LoginOnStartup', 'TRUE');
      s := ReadString('Login Options', 'AllowRemoteLogin', '');
      If (s = '') Then Writestring('Login Options', 'AllowRemoteLogin', 'FALSE');
      s := ReadString('Login Options', 'Local VistA', '');
      If (s = '') Then Writestring('Login Options', 'Local VistA', 'BROKERSERVER');
      s := ReadString('Login Options', 'Local VistA port', '');
      If (s = '') Then Writestring('Login Options', 'Local VistA port', '9200');

      If ((ReadString('Input Source', 'TWAIN', '') = '') And
        (ReadString('Input Source', 'Import', '') = '')) Then ConvertInputTypeToInputSource(Tini);
      Erasesection('InputType');

      If ReadString('Input Source', 'Lumisys75', '') = '' Then
        Writestring('Input Source', 'Lumisys75', 'FALSE');
      If ReadString('Input Source', 'Lumisys150', '') = '' Then
        Writestring('Input Source', 'Lumisys150', 'FALSE');
      If ReadString('Input Source', 'Meteor', '') = '' Then
        Writestring('Input Source', 'Meteor', 'FALSE');
      If ReadString('Input Source', 'TWAIN', '') = '' Then
        Writestring('Input Source', 'TWAIN', 'FALSE');
      If ReadString('Input Source', 'Import', '') = '' Then
        Writestring('Input Source', 'Import', 'FALSE');
      If ReadString('Input Source', 'ClipBoard', '') = '' Then
        Writestring('Input Source', 'ClipBoard', 'FALSE');
      If ReadString('Input Source', 'ScannedDocument', '') = '' Then
        Writestring('Input Source', 'ScannedDocument', 'FALSE');
      If ReadString('Input Source', 'Default', '') = '' Then
        Writestring('Input Source', 'Default', 'NONE');

      Erasesection('choice_InputType_Default');
      Erasesection('choice_Input Source_Default');
      Writestring('choice_Input Source_Default', '1', 'Lumisys75');
//P8      WRITESTRING('choice_Input Source_Default', '2', 'Lumisys100');
      Writestring('choice_Input Source_Default', '3', 'Lumisys150');
//P8      WRITESTRING('choice_Input Source_Default', '4', 'Vista');
//P8      WRITESTRING('choice_Input Source_Default', '5', 'VistaInteractive');
      Writestring('choice_Input Source_Default', '6', 'Meteor');
      // 10/5/00  Take Vidar out of choices.  User will no longer be able to select it.
      //  Vidar is TWAIN so still possible to use the device.
      //WRITESTRING('choice_InputType_Default', '7', 'Vidar');
      Writestring('choice_Input Source_Default', '7', 'Import');
      Writestring('choice_Input Source_Default', '8', 'TWAIN');
//P8      WRITESTRING('choice_Input Source_Default', '9', 'ScanJetXray');
//P8      WRITESTRING('choice_Input Source_Default', '10', 'SCANECG');
      Writestring('choice_Input Source_Default', '11', 'ScannedDocument');
      Writestring('choice_Input Source_Default', '12', 'ClipBoard');

      If ((ReadString('Image Format', 'True Color JPG', '') = '') And
        (ReadString('Image Format', 'True Color TGA', '') = '')) Then ConvertTypeToFormat(Tini);
      Erasesection('ImageType');
      If ReadString('Image Format', 'True Color TGA', '') = '' Then
        Writestring('Image Format', 'True Color TGA', 'FALSE');
      If ReadString('Image Format', 'True Color JPG', '') = '' Then
        Writestring('Image Format', 'True Color JPG', 'FALSE');
      If ReadString('Image Format', '256 Color', '') = '' Then
        Writestring('Image Format', '256 Color', 'FALSE');
      If ReadString('Image Format', 'Xray', '') = '' Then
        Writestring('Image Format', 'Xray', 'FALSE');
      If ReadString('Image Format', 'Xray JPG', '') = '' Then
        Writestring('Image Format', 'Xray JPG', 'FALSE');
      If ReadString('Image Format', 'Black and White', '') = '' Then
        Writestring('Image Format', 'Black and White', 'FALSE');
      If ReadString('Image Format', 'Document TIF Uncompressed', '') = '' Then
        Writestring('Image Format', 'Document TIF Uncompressed', 'FALSE');
      If ReadString('Image Format', 'Document TIF G4 FAX', '') = '' Then
        Writestring('Image Format', 'Document TIF G4 FAX', 'FALSE');
      If ReadString('Image Format', 'Bitmap', '') = '' Then
        Writestring('Image Format', 'Bitmap', 'FALSE');
      If ReadString('Image Format', 'Motion Video', '') = '' Then
        Writestring('Image Format', 'Motion Video', 'FALSE');
      If ReadString('Image Format', 'Audio', '') = '' Then
        Writestring('Image Format', 'Audio', 'FALSE');
      If ReadString('Image Format', 'Default', '') = '' Then
        Writestring('Image Format', 'Default', 'NONE');

      Erasesection('choice_ImageType_Default'); // old section
      Erasesection('choice_Image Format_Default');
      Writestring('choice_Image Format_Default', '1', 'True Color TGA');
      Writestring('choice_Image Format_Default', '2', 'True Color JPG');
      Writestring('choice_Image Format_Default', '3', '256 Color');
      Writestring('choice_Image Format_Default', '4', 'Xray');
      Writestring('choice_Image Format_Default', '5', 'Xray JPG');
      Writestring('choice_Image Format_Default', '6', 'Black and White');
      Writestring('choice_Image Format_Default', '7', 'Document TIF Uncompressed');
      Writestring('choice_Image Format_Default', '8', 'Document TIF G4 FAX');
      Writestring('choice_Image Format_Default', '9', 'Motion Video');
      Writestring('choice_Image Format_Default', '10', 'Audio');
      Writestring('choice_Image Format_Default', '11', 'Bitmap');
      Writestring('choice_Image Format_Default', '12', 'DICOM');

      //9/10/02   convert specialty to Association
      If ((ReadString('Image Association', 'Laboratory', '') = '') And
        (ReadString('Image Association', 'Radiology', '') = '')) Then ConvertSpecToAssoc(Tini);
      Erasesection('Specialty');
      If ReadString('Image Association', 'Laboratory', '') = '' Then
        Writestring('Image Association', 'Laboratory', 'FALSE');
      If ReadString('Image Association', 'Medicine', '') = '' Then
        Writestring('Image Association', 'Medicine', 'FALSE');
      If ReadString('Image Association', 'Radiology', '') = '' Then
        Writestring('Image Association', 'Radiology', 'FALSE');
      If ReadString('Image Association', 'Surgery', '') = '' Then
        Writestring('Image Association', 'Surgery', 'FALSE');
      If ReadString('Image Association', 'Progress Notes', '') = '' Then
        Writestring('Image Association', 'Progress Notes', 'FALSE');
      //CLINPROCMOD
      If ReadString('Image Association', 'Clinical Procedures', '') = '' Then
        Writestring('Image Association', 'Clinical Procedures', 'FALSE');
      If ReadString('Image Association', 'TeleReader Consult', '') = '' Then
        Writestring('Image Association', 'TeleReader Consult', 'FALSE');
      If ReadString('Image Association', 'PhotoID', '') = '' Then
        Writestring('Image Association', 'PhotoID', 'FALSE');
      If ReadString('Image Association', 'Clinical Image', '') = '' Then
        Writestring('Image Association', 'Clinical Image', 'FALSE');
      //ADMINDOC
      If ReadString('Image Association', 'Admin Documents', '') = '' Then
        Writestring('Image Association', 'Admin Documents', 'FALSE');
      //   writestring('Specialty','None','');
      //9/10/02      writestring('Specialty', 'Other', '');
      If ReadString('Image Association', 'Default', '') = '' Then
        Writestring('Image Association', 'Default', 'ClinImage');
      { DONE : change to new Assoc values }
      Erasesection('Choice_Specialty_Default'); // old section
      Erasesection('Choice_Image Association_Default');
      Writestring('Choice_Image Association_Default', '1', 'LAB');
      Writestring('Choice_Image Association_Default', '2', 'MED');
      Writestring('Choice_Image Association_Default', '3', 'RAD');
      Writestring('Choice_Image Association_Default', '4', 'SUR');
      Writestring('Choice_Image Association_Default', '5', 'NOTES');
      Writestring('Choice_Image Association_Default', '6', 'CLINPROC');
      Writestring('Choice_Image Association_Default', '7', 'PHOTOID');
      Writestring('Choice_Image Association_Default', '8', 'CLINIMAGE');
      //ADMINDOC  12/04/2001
      Writestring('Choice_Image Association_Default', '9', 'ADMINDOC');
      Writestring('Choice_Image Association_Default', '10', 'TRCONSULT');

      If ReadString('Button/Field Options', 'CreateDefaultImageDesc', '') = '' Then
        Writestring('Button/Field Options', 'CreateDefaultImageDesc', 'TRUE');
      If ReadString('Button/Field Options', 'ImageDesc', '') = '' Then
        Writestring('Button/Field Options', 'ImageDesc', 'Selected (Windows default)');

      Erasesection('Choice_Button/Field Options_ImageDesc');
      Writestring('Choice_Button/Field Options_ImageDesc', '1', 'Selected (Windows default)');
      Writestring('Choice_Button/Field Options_ImageDesc', '2', 'NoSelectCursorEnd');
      Writestring('Choice_Button/Field Options_ImageDesc', '3', 'NoSelectCursorHome');

      If ReadString('Medicine Options', 'Create New/List Existing', '') = '' Then
        Writestring('Medicine Options', 'Create New/List Existing', 'Create New');
      If ReadString('Medicine Options', 'Create Procedure stub first', '') = '' Then
        Writestring('Medicine Options', 'Create Procedure stub first', 'FALSE');
      Erasesection('Choice_Medicine Options_Create New/List Existing');
      Writestring('Choice_Medicine Options_Create New/List Existing', '1', 'Create New');
      Writestring('Choice_Medicine Options_Create New/List Existing', '2', 'List Existing');

      If ReadString('SaveOptions', 'Default', '') = '' Then
        Writestring('SaveOptions', 'Default', 'GROUP');

      Erasesection('choice_SaveOptions_default');
      Writestring('choice_SaveOptions_default', '1', 'GROUP');
      Writestring('choice_SaveOptions_default', '2', 'SINGLE');

      s := ReadString('Import Options', 'Type', '');
      If (s = '') Then s := 'Copy to Server';
      S1 := ReadString('Import Options', 'DefaultImportDir', '');
      If (S1 = '') Then S1 := ExtractFilePath(Application.ExeName) + 'import';
      S2 := ReadString('Import Options', 'DefaultMask', '');
      If (S2 = '') Then S2 := '*.*';
      Erasesection('Import Options');
      Writestring('Import Options', 'Type', s);
      Writestring('Import Options', 'DefaultImportDir', S1);
      Writestring('Import Options', 'DefaultMask', S2);

      Erasesection('Choice_Import Options_Type');
      Writestring('Choice_Import Options_Type', '1', 'Copy to Server');
      Writestring('Choice_Import Options_Type', '2', 'Convert to TGA');
      Writestring('Choice_Import Options_Type', '3', 'Convert File Format to Default');

      If ReadString('Input Source Options', '256 Color Enabled', '') = '' Then
        Writestring('Input Source Options', '256 Color Enabled', 'FALSE');

      If ReadString('Workstation Settings', 'ID', '') = '' Then
        Writestring('Workstation Settings', 'ID', 'UNKnown');
      If ReadString('Workstation Settings', 'Location', '') = '' Then
        Writestring('Workstation Settings', 'Location', 'UNKnown');

      If ReadString('Workstation Settings', 'Abstracts created', '') = '' Then
        Writestring('Workstation Settings', 'Abstracts created', 'TRUE');
      If ReadString('Workstation Settings', 'Save Radiology BIG File', '') = '' Then
        Writestring('Workstation Settings', 'Save Radiology BIG File', 'FALSE');
      //IF ReadString('Workstation Settings','ABBREV','')='' THEN
      //   writestring('Workstation Settings','ABBREV','I2');
        // P8T14  STOP showing Jukebox abstracts "." (Period)
      //if ReadString('Workstation Settings', 'Display JukeBox Abstracts', '') = '' then  // P8T14  //p14 take out
      Writestring('Workstation Settings', 'Display JukeBox Abstracts', 'FALSE'); // P8T14 //p14 take out
      If ReadString('Workstation Settings', 'Log Session Actions', '') = '' Then
        Writestring('Workstation Settings', 'Log Session Actions', 'FALSE');
      If ReadString('Workstation Settings', 'VistaRad test mode', '') = '' Then //p14 take out
        Writestring('Workstation Settings', 'VistaRad test mode', 'FALSE'); //p14 take out
      If ReadString('Workstation Settings', 'CacheLocationID', '') = '' Then //p14 take out
        Writestring('Workstation Settings', 'CacheLocationID', ''); //p14 take out
      If ReadString('Workstation Settings', 'MUSE Enabled', '') = '' Then
        Writestring('Workstation Settings', 'MUSE Enabled', 'TRUE');
      If ReadString('Workstation Settings', 'MUSE Demo Mode', '') = '' Then
        Writestring('Workstation Settings', 'MUSE Demo Mode', 'FALSE');
      If ReadString('Workstation Settings', 'Allow Image SaveAs', '') = '' Then
        Writestring('Workstation Settings', 'Allow Image SaveAs', 'FALSE');
      If ReadString('Workstation Settings', 'Fake Name', '') = '' Then
        Writestring('Workstation Settings', 'Fake Name', 'Fake,PatientName');
      If ReadString('Workstation Settings', 'Allow Fake Name', '') = '' Then
        Writestring('Workstation Settings', 'Allow Fake Name', 'FALSE');
      s := ReadString('Workstation Settings', 'WorkStation TimeOut minutes', '');
      If ((s = '') Or (s = '0')) Then
        Writestring('Workstation Settings', 'WorkStation TimeOut minutes', '0');
      //  if no default veiwer then we will just use the windows associated viewer;
      {IF ReadString('Workstation settings','Alternate Video Viewer','')=''
         THEN  writestring('Workstation settings','Alternate Video Viewer','C:\WINNT\SYSTEM32\MPlay32.exe');}

      If ReadString('SYS_AUTOUPDATE', 'DIRECTORY', '') = '' Then
        Writestring('SYS_AUTOUPDATE', 'DIRECTORY', 'NONE');

      Erasesection('choice_Input Source_Lumisys100 FilmSize');
      Erasesection('SYS_FilmSize_Lumisys100');
      Erasesection('choice_InputType_Meteor settings');
      (* Meteor settings are now being done by Matrox Defaults program*)
      Erasesection('SYS_FilmSize_Meteor');

      //Set interactive mode for meteor as default - clean up old stuff
      s := ReadString('SYS_Meteor', 'INTERACTIVE', 'TRUE');
      If (s = '') Then s := 'TRUE';
      Erasesection('SYS_Meteor');
        // We are erasing the whole section and only setting the One entry
      Writestring('SYS_Meteor', 'INTERACTIVE', s);
    End; {WITH TINI}

  Finally
    Tini.Free;
  End; {TRY}
End;

Procedure ConvertTypeToFormat(Tempini: TIniFile);
Begin
  With Tempini Do
  Begin
    Writestring('Image Format', 'True Color TGA', ReadString('ImageType', 'True Color TGA', 'FALSE'));
    Writestring('Image Format', 'True Color JPG', ReadString('ImageType', 'True Color JPG', 'FALSE'));
    Writestring('Image Format', '256 Color', ReadString('ImageType', '256 Color', 'FALSE'));
    Writestring('Image Format', 'Xray', ReadString('ImageType', 'Xray', 'FALSE'));
    Writestring('Image Format', 'Xray JPG', ReadString('ImageType', 'Xray JPG', 'FALSE'));
    Writestring('Image Format', 'Black and White', ReadString('ImageType', 'Black and White', 'FALSE'));
    Writestring('Image Format', 'Document TIF Uncompressed', ReadString('ImageType', 'Document TIF Uncompressed', 'FALSE'));
    Writestring('Image Format', 'Document TIF G4 FAX', ReadString('ImageType', 'Document TIF G4 FAX', 'FALSE'));
    Writestring('Image Format', 'Bitmap', ReadString('ImageType', 'Bitmap', 'FALSE'));
    Writestring('Image Format', 'Motion Video', ReadString('ImageType', 'Motion Video', 'FALSE'));
    Writestring('Image Format', 'Audio', ReadString('ImageType', 'Audio', 'FALSE'));
    Writestring('Image Format', 'Default', ReadString('ImageType', 'Default', 'FALSE'));

    Erasesection('ImageType');
  End;

End;

Procedure ConvertSpecToAssoc(Tempini: TIniFile);
Var
  s: String;
Begin
  With Tempini Do
  Begin
    Writestring('Image Association', 'Laboratory', ReadString('Specialty', 'Laboratory', 'FALSE'));
    Writestring('Image Association', 'Medicine', ReadString('Specialty', 'Medicine', 'FALSE'));
    Writestring('Image Association', 'Radiology', ReadString('Specialty', 'Radiology', 'FALSE'));
    Writestring('Image Association', 'Surgery', ReadString('Specialty', 'Surgery', 'FALSE'));
    Writestring('Image Association', 'Progress Notes', ReadString('Specialty', 'Progress Notes', 'FALSE'));
    Writestring('Image Association', 'Clinical Procedures', ReadString('Specialty', 'Clinical Procedures', 'FALSE'));
    Writestring('Image Association', 'TeleReader Consult', ReadString('Specialty', 'TeleReader Consult', 'FALSE'));
    Writestring('Image Association', 'PhotoID', ReadString('Specialty', 'PhotoID', 'FALSE'));
    //     'None;
    Writestring('Image Association', 'Clinical Image', ReadString('Specialty', 'NONE', 'FALSE'));
    //     'Admin Documents'
    Writestring('Image Association', 'Admin Documents', ReadString('Specialty', 'Admin Documents', 'FALSE'));
    s := ReadString('Specialty', 'Default', 'CLINIMAGE');
    If (Uppercase(s) = 'NONE') Then s := 'CLINIMAGE';
    Writestring('Image Association', 'Default', s); //HERE
    //   writestring('Specialty','None','');
    //9/10/02      writestring('Specialty', 'Other', '');

    Erasesection('Specialty');
  End;

End;

Procedure ConvertInputTypeToInputSource(Tempini: TIniFile);
Begin
  With Tempini Do
  Begin
   //P8 writestring('Input Source', 'ScanJetXray', ReadString('InputType', 'ScanJetXray', 'FALSE'));
    Writestring('Input Source', 'Lumisys75', ReadString('InputType', 'Lumisys75', 'FALSE'));
   //P8 writestring('Input Source', 'Lumisys100', ReadString('InputType', 'Lumisys100', 'FALSE'));
    Writestring('Input Source', 'Lumisys150', ReadString('InputType', 'Lumisys150', 'FALSE'));
   //P8 writestring('Input Source', 'Vista', ReadString('InputType', 'Vista', 'FALSE'));
    Writestring('Input Source', 'Meteor', ReadString('InputType', 'Meteor', 'FALSE'));
    Writestring('Input Source', 'TWAIN', ReadString('InputType', 'TWAIN', 'FALSE'));
    Writestring('Input Source', 'Import', ReadString('InputType', 'Import', 'FALSE'));
   //P8 writestring('Input Source', 'SCANECG', ReadString('InputType', 'SCANECG', 'FALSE'));
    Writestring('Input Source', 'ClipBoard', ReadString('InputType', 'ClipBoard', 'FALSE'));
    Writestring('Input Source', 'ScannedDocument', ReadString('InputType', 'ScannedDocument', 'FALSE'));
    //P8writestring('Input Source', 'VistaInteractive', ReadString('InputType', 'VistaInteractive', 'FALSE'));
    Writestring('Input Source', 'Default', ReadString('InputType', 'Default', 'Import'));
   //P8 writestring('Input Source', 'ScanJetXray', ReadString('InputType', 'ScanJetXray', 'FALSE'));
   //P8 writestring('Input Source', 'Lumisys100 FilmSize', ReadString('InputType', 'Lumisys100 FilmSize', '14" x 17"'));
    Erasesection('InputType');
  End;
End;

End.
