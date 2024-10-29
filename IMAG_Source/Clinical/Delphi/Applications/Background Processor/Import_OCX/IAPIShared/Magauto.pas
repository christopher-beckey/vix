Unit Magauto;
   {
   Package: MAG - VistA Imaging
   WARNING: Per VHA Directive 10-93-142 this unit should not be modified.
   Date Created:
   Site Name: Silver Spring, OIFO
   Developers: Garrett Kirin
   Description: Imaging AutoUpdate functions, and settings.
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
  Controls
  ;

//Uses Vetted 20090929:filectrl, StdCtrls, Graphics, Messages, WinProcs, magguini, inifiles, FMXUTILS, Dialogs, Forms, WinTypes, SysUtils

Function RUNTHEUPDATE(Runfile: String): Integer;
Function IsUpdateing(APPTEXT, INIENTRY: String; Var Ts: TStrings): Boolean;
Procedure Fillerrorcodes(Var t: Tstringlist);
Procedure SetAutoUpdateDirectory;

Implementation
Uses
  Dialogs,
  Fmxutils,
  Forms,
  Inifiles,
  Magguini,
  SysUtils,
  WinTypes
  ;

// Called from Display and Capture FormPaint( methods.

Function IsUpdateing(APPTEXT, INIENTRY: String; Var Ts: TStrings): Boolean;
Var
  Magini: TIniFile;
  NetINI: TIniFile;
  x: Integer;

  UPDIR, DATEINI, DATEUPDIR, Installfile: String;

  Errorcodes: Tstringlist;
  VWrksID, VWrksCompName: String;

  FORCEDUPDATE: Boolean;
  { this is where we change to MAGSETUP.EXE'}
  {const updatefile : String = 'MAGSETUP.EXE';}
Begin
  FORCEDUPDATE := False;
  SetAutoUpdateDirectory;
  //result := false;
  Magini := TIniFile.Create(GetConfigFileName);
  UPDIR := Magini.ReadString('SYS_AUTOUPDATE', 'DIRECTORY', 'ERROR');
  If Copy(UPDIR, Length(UPDIR), 1) = '\' Then UPDIR := Copy(UPDIR, 1, Length(UPDIR) - 1);
  Ts.Add('UpDate Directory : ' + UPDIR);
  If (UPDIR = 'ERROR') Or (Uppercase(UPDIR) = 'NONE') Then
  Begin
    //'No Update directory in the ConfigFile File 'SYS_AUTOUPDATE', 'DIRECTORY',';
    Ts.Add('This Workstation isn''t configured for Auto-Updating.');
    Result := False;
    Magini.Free;
    Exit;
  End;

  If Not Directoryexists(UPDIR) Then
  Begin
    {Can't connect to the directory or it doesn't exist}
    Ts.Add('AutoUpdating disabled:');
    Ts.Add('  -> The Network Update Directory doesn''t exist.');
    Ts.Add('  -> Directory -> ' + UPDIR);
    Result := False;
    Magini.Free;
    Exit;
  End;

  If Not FileExists(UPDIR + '\' + 'MAGNET.INI') Then
  Begin
    {'No MAGNET.INI is defined in the Network update directory';}
    Ts.Add('MAGNET.INI doesn''t exist in : ' + UPDIR);
    Ts.Add('AutoUpdating disabled. Network Configuration file doesn''t exist.');
    Result := False;
    Magini.Free;
    Exit;
  End;

  NetINI := TIniFile.Create(UPDIR + '\' + 'magnet.ini');
  Try

    Errorcodes := Tstringlist.Create;
    Fillerrorcodes(Errorcodes);

    {NetINI := TINIFILE.create(updir+'\'+'magnet.ini');}
    DATEINI := Magini.ReadString('SYS_AUTOUPDATE', INIENTRY, '0');
    Ts.Add('Date From ConfigFile : SYS_AUTOUPDATE - ' + INIENTRY);
    Ts.Add('   value = ' + DATEINI);
    If DATEINI = '' Then DATEINI := '0';
    VWrksID := Magini.ReadString('Workstation Settings', 'ID', 'UNKnown') + '-' +
      Magini.ReadString('Workstation Settings', 'Location', 'UNKnown');
    VWrksCompName := Magini.ReadString('SYS_AUTOUPDATE', 'ComputerName', 'NoComputerName');
    If ((VWrksCompName = 'NoComputerName') Or (VWrksCompName = '')) Then
    Begin
      { 'No ComputerName is defined for this workstation 'SYS_AUTOUPDATE','ComputerName';}
      Ts.Add('AutoUpdating is disabled. No ComputerName is defined.');
      Result := False;
      Exit;
    End;

    If (NetINI.ReadString('update_mode', 'ForceUpdateAll', 'FALSE') = 'TRUE')
      Or (NetINI.ReadString('update_mode', VWrksCompName, 'FALSE') = 'TRUE') Then FORCEDUPDATE := True;

    Installfile := UPDIR + '\' + NetINI.ReadString('update_mode', 'InstallFile', 'UNKnown');
    If Not FileExists(Installfile) Then
    Begin
      {MAGSETUP doesn't exist in the Network update Directory';}
      Ts.Add('File doesn''t exist  : ' + Installfile);
      Ts.Add('AutoUpdating canceled. No Updates available.');
      Result := False;
      Exit;
    End;

    DATEUPDIR := Formatdatetime('yyyymmdd.hhnn', FILEDATETIME(Installfile));
    DATEUPDIR := FloatTostr(Strtofloat(DATEUPDIR) - 17000000.0000);

    Ts.Add('Date of ' + Installfile + ' : ');
    Ts.Add('     ' + DATEUPDIR);
    If Strtofloat(DATEUPDIR) = Strtofloat(DATEINI) Then
    Begin
      Ts.Add('Your Workstation has the current version of ' + APPTEXT);
      Result := False;
      Exit;
    End;

    If FORCEDUPDATE Then
    Begin
      x := RUNTHEUPDATE(Installfile);
      If x < 32 Then
      Begin
        Result := False;
        Ts.Add('AutoUpdating canceled. ' + Errorcodes[x]);
        Exit;
      End
      Else
      Begin
        {MAGini.WRITEString('SYS_AUTOUPDATE', 'LASTUPDATE', DATEUPDIR);}
        { the above line is now done by the MAGSETUP.EXE routine.}
        {NETINI.WRITESTRING('WORKSTATION_UPDATES',WrksID,DATEUPDIR);}
        { the above line isn't done now, we'll allow the MAGNET.INI file or
          directory to be readonly by the general user}

        Result := True;
        Exit;
      End;
    End;

    If Strtofloat(DATEUPDIR) < Strtofloat(DATEINI) Then
    Begin
      Ts.Add('Your Workstation has a newer version of ' + APPTEXT);
      Result := False;
      Exit;
    End;

    If Strtofloat(DATEUPDIR) > Strtofloat(DATEINI) Then
    Begin
      If Messagedlg('An Update to the ' + APPTEXT + ' exists.' + #13 + #13 +
        'UPDATE your Workstation Now ?', Mtconfirmation, [Mbok, Mbcancel], 0) = MrCancel Then
      Begin
        Ts.Add('User canceled the update to ' + APPTEXT);
        Result := False;
        Exit;
      End;
    End;
    Ts.Add('Running the Update... ');
    x := RUNTHEUPDATE(Installfile);
    If x < 32 Then
    Begin
      Result := False;
      Ts.Add('AutoUpdating canceled. ' + Errorcodes[x]);
      Exit;
    End;
    {magini.WRITEString('SYS_AUTOUPDATE', 'LASTUPDATE', DATEUPDIR);}
             { the above line is now done by the MAGSETUP.EXE routine.}
    {NETINI.WRITESTRING('WORKSTATION_UPDATES',WrksID,DATEUPDIR);}
             { the above line isn't done now, we'll allow the MAGNET.INI file or
               directory to be readonly by the general user}

    Result := True;
  Finally
    Magini.Free;
    NetINI.Free;
    Errorcodes.Free;
  End; {TRY}
End;

Function RUNTHEUPDATE(Runfile: String): Integer; //PRIVATE
Var
  EXEVALUE: Integer;
Begin
  EXEVALUE := EXECUTEfile(Runfile, '', '', SW_SHOW);
  Result := EXEVALUE;
End;

Procedure SetAutoUpdateDirectory; //PRIVATE
Var
  Magini: TIniFile;
  Dir: String;
  t: Tstringlist;
Begin
//  dir := 'c:\program files\vista\imaging\updatedirectory.dat'; //02/11/03
  Dir := ExtractFilePath(Application.ExeName) + 'updatedirectory.dat';
  If Not FileExists(Dir) Then Exit;
  t := Tstringlist.Create;
  Magini := TIniFile.Create(GetConfigFileName);
  Try
    t.LoadFromFile(Dir);
    Magini.Writestring('SYS_AUTOUPDATE', 'DIRECTORY', t[0]);
    DeleteFile(PChar(Dir));
  Finally
    Magini.Free;
    t.Free;

  End;
End;
 { TODO : Get rid of this list, add the Function to GetLastError }

Procedure Fillerrorcodes(Var t: Tstringlist); // PRIVATE
Begin
  t.Add('#0    System was out of memory, executable file was corrupt, or relocations were invalid.');
  t.Add('#1    No Text for This Error Code');
  t.Add('#2    File was not found.');
  t.Add('#3    Path was not found.');
  t.Add('#4    No Text for This Error Code');
  t.Add('#5    Attempt was made to dynamically link to a task, or there was a sharing or network-protection error.');
  t.Add('#6    Library required separate data segments for each task.');
  t.Add('#7    No Text for This Error Code');
  t.Add('#8    There was insufficient memory to start the application.');
  t.Add('#9    No Text for This Error Code');
  t.Add('#10   Windows version was incorrect.');
  t.Add('#11   Executable file was invalid. Either it was not a Windows application or there was an error in the .EXE image.');
  t.Add('#12   Application was designed for a different operating system.');
  t.Add('#13   Application was designed for MS-DOS 4.0.');
  t.Add('#14   Type of executable file was unknown.');
  t.Add('#15   Attempt was made to load a real-mode application (developed for an earlier version of Windows).');
  t.Add('#16   Attempt was made to load a second instance of an executable'
    + ' file containing multiple data segments that were not marked read-only.');
  t.Add('#17   No Text for This Error Code');
  t.Add('#18   No Text for This Error Code');
  t.Add('#19   Attempt was made to load a compressed executable file. The file must be decompressed before it can be loaded.');
  t.Add('#20   Dynamic-link library (DLL) file was invalid. One of the DLLs required to run this application was corrupt.');
  t.Add('#21   Application requires Windows 32-bit extensions.');
  t.Add('#22   No Text for This Error Code');
  t.Add('#23   No Text for This Error Code');
  t.Add('#24   No Text for This Error Code');
  t.Add('#25   No Text for This Error Code');
  t.Add('#26   No Text for This Error Code');
  t.Add('#27   No Text for This Error Code');
  t.Add('#28   No Text for This Error Code');
  t.Add('#29   No Text for This Error Code');
  t.Add('#30   No Text for This Error Code');
  t.Add('#31   there is no association for the specified file type');
End;

End.
