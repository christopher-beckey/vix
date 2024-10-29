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

   RCA  the different config file names are not applicable anymore. Patch 7 , 8 ,  33,
      We can reduce code.

   Patch 129, 127, 130
      removed a lot of old unused code.  Copied old Magguini to MagguiniOLD129t10.ini

   Patch 8 changed from mag.ini to  mag308.ini for Patch 8 ini file.
   Patch 129, 127, 130  We  now return back to using MAG.INI

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
// GetDebugMode: moved here 140 refactoring
function GetDebugMode: boolean; //P106 BB debug added to capture, value kept in .ini

function IsOSwin7(): boolean;
function GetWin7AlternateVideoViewer(): string;

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
//RCA now always use GetConfigFileName
//RCA OUT Function FindConfigFile(): String;
Function IsUpdateNeeded(AppVersion: String): Boolean;
Procedure UpdateIfNeeded(AppVersion: String);
Function MagGetWindowsDirectory: String;
Implementation
Uses
  Forms,
  SysUtils,
  WinTypes
  ;

 // GetDebugMode: moved here 140 refactoring
function GetDebugMode: boolean;
var Magini: TIniFile; s: string;
Begin
  result := false;
  Magini := TIniFile.Create(GetConfigFileName);
  Try
    s := Magini.ReadString('Workstation Settings', 'DebugUser', 'FALSE');
    result := UpperCase(s) = 'TRUE';
  Finally
    Magini.Free;
  End;
End;

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
          {p129 T 16 Force an Update with 16}
        if appVersion = '3.0.129.16'
           then result := true
           else Result := (AppVersion <> ReadString('SYS_AUTOUPDATE', 'LASTINIUPDATE', ''));
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
      {p129 T 16 Force an Update with 16}
      If ((Updversion <> AppVersion) or (AppVersion = '3.0.129.16')) Then
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
var oldINI, newINI : string;
Begin
oldINI := ExtractFilePath(Application.ExeName) + 'mag308.ini';
newINI := GetConfigFileName;
  If FileExists(newINI) Then
    begin
    Result := False;
    exit;
    end;
{p129t11 gek  We get here if the AppData ini does not exist yet.}
{If old mag308.ini exists,   copy it, and Done.}
 if FileExists(oldINI) then
    begin
     copyfile(pchar(oldINI),pchar(newINI),true);
     application.ProcessMessages;
     setfileattributes(pchar(newINI),0);   {change attributes to allow writing.}
     result := false;
     exit;
    end;

    Result := True;
    CreateMagINI;
End;

{ Patch 8:  we now use mag308.ini for Patch 8 ini file.
  Patch 129, 127, 130  We  now return back to using MAG.INI

{RCA  the different config file names are not applicable anymore. Patch 7 , 8 ,  33,
      We can reduce code.  Patch 129  removed a lot of old unused code.
      Copied old Magguini to MagguiniOLD129t10.ini }
Function GetConfigFileName(XDirectory: String = ''): String;
Var
  dir : string;
Begin
 {p129t11 win7 change to ALLUSERSPROFILE Directory.  Mag.INI is one for all users.
   Note : in Win 7 '\Application Data\'  is a junction point.  and not parsed to be an actual
          directory.  so:
       Win7 PC will write to:    \ProgramData\Vista\Imaging\
       XP   PC will Write to:    \Documents and Settings\All Users\Application Data\VistA\Imaging\' }
  dir :=  GetEnvironmentVariable('ALLUSERSPROFILE') +'\Application Data\VistA\Imaging\' ;
  if (Xdirectory <> '') then  dir :=   Xdirectory;
  if Not Directoryexists(dir) then  Forcedirectories(dir);
  result := dir + 'mag.ini';
 end;


Procedure CreateMagINI;
Var
  s: String;
Begin
  DeleteFile(PChar(GetConfigFileName));
  With TIniFile.Create(GetConfigFileName) Do
  Begin
    Try
      { Research has shown that INI file functions, sections, and entries are not case sensitive
       BUT of course the VALUES of the entries are. }

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
      Writestring('choice_Input Source_Default', '3', 'Lumisys150');
      Writestring('choice_Input Source_Default', '6', 'Meteor');
      Writestring('choice_Input Source_Default', '7', 'Import');
      Writestring('choice_Input Source_Default', '8', 'TWAIN');
      Writestring('choice_Input Source_Default', '11', 'ScannedDocument');
      Writestring('choice_Input Source_Default', '12', 'ClipBoard');

      Writestring('Input Source', 'Lumisys75', 'FALSE');
      Writestring('Input Source', 'Lumisys150', 'FALSE');
      Writestring('Input Source', 'Meteor', 'FALSE');
      Writestring('Input Source', 'TWAIN', 'FALSE');
      Writestring('Input Source', 'Import', 'FALSE');
      Writestring('Input Source', 'ClipBoard', 'FALSE');
      Writestring('Input Source', 'ScannedDocument', 'FALSE');
      Writestring('Input Source', 'Default', 'NONE');

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
      { ? Do  we create the defalut Video Viewer for XP.}
      {   No, we don't create a Default Video Viewer on New INI's
          We don't 'Force' the application to use a viewer.  we
          depend on the OS Association to that file format.}
      Writestring('SYS_AUTOUPDATE', 'DIRECTORY', 'NONE');

      Writestring('SYS_Meteor', 'INTERACTIVE', 'TRUE');

    Finally
      Free;
    End; {TRY}
  End; {WITH}
End;


Procedure CheckMagINI;
Var
  Tini: TIniFile;
  s, S1, S2: String;
Begin
  Tini := TIniFile.Create(GetConfigFileName);

  Try
    With Tini Do
    Begin
    {p151        }
    if not ValueExists('Copy Options','CopyMode') then
      begin
      writestring('Copy Options','CopyMode','Thread Stream');
      writestring('Choice_Copy Options_CopyMode','1','Normal');
      writestring('Choice_Copy Options_CopyMode','2','Thread');
      writestring('Choice_Copy Options_CopyMode','3','Thread Stream');
      end;
      //106 Change  DICOM format.
      If Not ValueExists('IMAGE FORMAT', 'DICOM') Then Writestring('IMAGE FORMAT', 'DICOM', 'FALSE');//p106 rlm 8/25/2010

      { Research has shown that INI file functions, sections, and entries are not case sensitive
       BUT of course the VALUES of the entries are.}
      s := Uppercase(ReadString('demo options', 'IMAGE DEMO ENABLED', ''));
      If (s = '') Then (Writestring('demo options', 'IMAGE DEMO ENABLED', 'FALSE'));
      { Note:  If the INI has ENTRY=     then the Readstring will be defined as '' , not as the
        default in the function call  i.e. if 'TRUE' is the default, the result will be '' not 'TRUE'
        so that is why the logic is used.   s := ... if s = '' then  ' set the default' }

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
      {gek 93  5/18/2009  defalut Origin to VA.  IHS can change to IHS.}
      s := Uppercase(ReadString('Workstation settings', 'DefaultOriginIndexValue', ''));
      If (s = '') Then Writestring('Workstation settings', 'DefaultOriginIndexValue', 'VA');

      { JMW 6/16/2005 p45t3 Caching abstracts on by default   }
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
      Writestring('choice_Input Source_Default', '3', 'Lumisys150');
      Writestring('choice_Input Source_Default', '6', 'Meteor');
      { 10/5/00  Take Vidar out of choices.  User will no longer be able to select it.
       Vidar is TWAIN so still possible to use the device. }

      Writestring('choice_Input Source_Default', '7', 'Import');
      Writestring('choice_Input Source_Default', '8', 'TWAIN');
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

      {p129t16  Previous to Win7,  we Were not setting a Default Video Viewer.  We would just
         depend on the OS's video player associated with the Video Extensions.
      For 129 t16 and the Win 7 environment. If we find the WinXP default Viewer in the INI,
      Then We'll change it to the Win 7 Defalut Viewer.}
      s :=  ReadString('Workstation settings','Alternate Video Viewer','');
      if s <> '' then
        if NOT fileexists(s) then
          Tini.DeleteKey('Workstation settings','Alternate Video Viewer');


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


{Not calling this yet.  maybe future...  need better way to determine Win 7 OS}
function IsOSwin7() : boolean;
var vHomepath : string;
begin
result := false;
{I can't find an Environment Variable that Tells me that this is a Win 7 OS}
  vHomepath :=  GetEnvironmentVariable('HOMEPATH') ;
  if (pos('\USERS\',UPPERCASE(vHomepath)) > 0 ) then result := true;

  //result := false;
  //if directoryexists('C:\Program Files (x86)') then  result := true;

end;
{129T 16 Here, but Not Used.  After reviewing the design of the 'default Video Viewer'
    I went with the current design of NOT forcing a default viewer in the INI.
    So if the Existing 'Alternate Video Viewer' doesn't exist on this Workstation , we
    just delete the entry and go back to the default of the OS Association for the file type.,}
function GetWin7AlternateVideoViewer(): string;
var vHomeDrive : string;
begin
vHomeDrive :=  GetEnvironmentVariable('HOMEDRIVE') ;
  result := vHomeDrive + '\Program Files (x86)\Windows Media Player\wmplayer.exe';
  if not fileexists(result)  then result := '';
  
end;


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
    Writestring('Input Source', 'Lumisys75', ReadString('InputType', 'Lumisys75', 'FALSE'));
    Writestring('Input Source', 'Lumisys150', ReadString('InputType', 'Lumisys150', 'FALSE'));
    Writestring('Input Source', 'Meteor', ReadString('InputType', 'Meteor', 'FALSE'));
    Writestring('Input Source', 'TWAIN', ReadString('InputType', 'TWAIN', 'FALSE'));
    Writestring('Input Source', 'Import', ReadString('InputType', 'Import', 'FALSE'));
    Writestring('Input Source', 'ClipBoard', ReadString('InputType', 'ClipBoard', 'FALSE'));
    Writestring('Input Source', 'ScannedDocument', ReadString('InputType', 'ScannedDocument', 'FALSE'));
    Writestring('Input Source', 'Default', ReadString('InputType', 'Default', 'Import'));
    Erasesection('InputType');
  End;
End;

End.
