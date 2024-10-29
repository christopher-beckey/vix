Unit Magfileversion;
   {
   Package: MAG - VistA Imaging
   WARNING: Per VHA Directive 10-93-142 this unit should not be modified.
   Date Created:
   Site Name: Silver Spring, OIFO
   Developers: Garrett Kirin
   [==   unit MagFileVersion;
   Description: Imaging File Version utilities
    This unit is intended to hold the function/procedure calls needed to querry
    the Application executable for Version information.
    Mainly used by the About Box to display information about the compiled executable
    It can be called from anywhere.
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
  Classes
  ;

//Uses Vetted 20090929:StdCtrls, Dialogs, Forms, Controls, Graphics, Messages, uMagUtils, SysUtils, Windows
Procedure MagGetDisplayProperties(Const Filename: String; Var t: TStrings);
Function MagGetFileVersionInfo(Filename: String; Vistaformat: Boolean = True): String;
Function MagGetOSVersion: String;
Function MagGetFileDescription(Const Filename: String): String;
Function MagGetProductName(Const Filename: String): String;
Implementation
Uses
  SysUtils,
  Umagutils8,
  Windows
  ;

{ -------------------------------- }
{ Returns the 'FileVersion' property for a given executable 'filename'
  The Actual Version number in Delphi is stored in a 'Released Sequencing Version'
  format.  This format makes it possible to sort the Delphi clients in Released
  order by this number. i.e. 30.5.8.45 will sort after 30.4.33.15 even though
  8 is before 33.
  if vistaformat = TRUE the number is returned in normal format 3.0.8.45  }

Function MagGetFileVersionInfo(Filename: String; Vistaformat: Boolean = True): String;
Var
  Buf: PChar;
  LpData: Pointer;
  LpdwHandle, Dwlen: DWORD;
  Magver, MagSeq, MagPatch, MagTver: String;
  MagVerMaj, MagVerMin: String;
Begin
  Dwlen := GetFileVersionInfoSize(PChar(Filename), LpdwHandle);
  GetMem(LpData, Dwlen);
  Try
    If Not GetFileVersionInfo(PChar(Filename), 0, Dwlen, LpData) Then Exit;
    VerQueryValue(LpData, '\\StringFileInfo\\040904e4\\FileVersion', Pointer(Buf), Dwlen);
    Result := Strpas(Buf);
  Finally
    FreeMem(LpData);
  End;
  If Not Vistaformat Then Exit;
  Magver := MagPiece(Result, '.', 1);
  MagSeq := MagPiece(Result, '.', 2);
  MagPatch := MagPiece(Result, '.', 3);
  MagTver := MagPiece(Result, '.', 4);
  If (Length(Magver) > 1) Then
  Begin
  {The new versioning scheme  30.5.8.39
    30 is Major Version and Minor Version   ie  3.0
    5 (2nd '.' piece) is the release sequence number
    which we won't show to end user
    8 (3rd) is the Patch       39 (4th) is the Tversion.}
    MagVerMaj := Copy(Magver, 1, 1);
    MagVerMin := Copy(Magver, 2, 99);
  End
  Else
  Begin
    {The Old versioning scheme  3.0.8.39
    3 (1st) is Major Version   0 (2nd) is Minor Version
    8 (3rd) is the Patch       39 (4th) is the Tversion.}
    MagVerMaj := Magver;
    MagVerMin := MagSeq;
  End;
  {  this is just numbers    3.0.8.39}
  Result := MagVerMaj + '.' + MagVerMin + '.' + MagPatch + '.' + MagTver;
  {  this is easily readable foramt  Version: 3.0 (patch 8, T version 39)
     result := 'Version: '+magvermaj+'.'+magvermin+' (patch '+magPatch+'T'+magtver+')';{}
End;

{ Return the Operating System version. i.e. Windows XP}
{TODO -clowPriority: create a common utility object to be used by BP, Display and other Delphi clients.
  This code is copied/pasted from Richards BP utility}

Function MagGetOSVersion: String;
Var
  VersionInfo: TOSVersionInfo;
  Platform: String;
Begin
  VersionInfo.DwOSVersionInfoSize := SizeOf(VersionInfo);
  GetVersionEx(VersionInfo);
  With VersionInfo Do
  Begin
    Case DwPlatformId Of
      VER_PLATFORM_WIN32s {0}: Platform := 'Win32s';
      VER_PLATFORM_WIN32_WINDOWS {1}:
        Case DwMinorVersion Of
          0: Platform := 'Win 95';
          10: Platform := 'Win 98';
          90: Platform := 'Win Me';
        End; //  case dwMinorVersion of
      VER_PLATFORM_WIN32_NT {2}:
        Case DwMajorVersion Of
          4: Platform := 'Win NT';
          5:
            Begin
              If DwMinorVersion = 0 Then
                Platform := 'Win 2000 ';
              If DwMinorVersion = 1 Then
                Platform := 'Win XP';
              If DwMinorVersion = 2 Then
                Platform := 'Win Server';
            End; // Case of 5
        End; //  case dwMajorVersion
    End; //case dwPlatformId
    Result := Platform + '.' + Inttostr(DwMajorVersion) + '.' + Inttostr(DwMinorVersion) + '.' +
      Inttostr(DwBuildNumber);
  End;
End;

{ Return the common properties from the Version Information in a list }

Procedure MagGetDisplayProperties(Const Filename: String; Var t: TStrings);
Var
  Buf: PChar;
  LpData: Pointer;
  LpdwHandle, Dwlen: DWORD;
Begin

  t.Clear;
  Dwlen := GetFileVersionInfoSize(PChar(Filename), LpdwHandle);
  GetMem(LpData, Dwlen);
  Try
    If Not GetFileVersionInfo(PChar(Filename), 0, Dwlen, LpData) Then Exit;
    VerQueryValue(LpData, '\\StringFileInfo\\040904e4\\CompanyName', Pointer(Buf), Dwlen);
    t.Add('Company Name     : ' + Strpas(Buf));
    VerQueryValue(LpData, '\\StringFileInfo\\040904e4\\ProductName', Pointer(Buf), Dwlen);
    t.Add('Product Name     : ' + Strpas(Buf));
    VerQueryValue(LpData, '\\StringFileInfo\\040904e4\\ProductVersion', Pointer(Buf), Dwlen);
    t.Add('Product Version  : ' + Strpas(Buf));
    VerQueryValue(LpData, '\\StringFileInfo\\040904e4\\FileDescription', Pointer(Buf), Dwlen);
    t.Add('File Description : ' + Strpas(Buf));
    VerQueryValue(LpData, '\\StringFileInfo\\040904e4\\FileVersion', Pointer(Buf), Dwlen);
    t.Add('File Version     : ' + Strpas(Buf));
    t.Add('Operating System : ' + MagGetOSVersion);
  Finally
    FreeMem(LpData);
  End;
End;

{return the 'File Description' property from the executable.}

Function MagGetFileDescription(Const Filename: String): String;
Var
  Buf: PChar;
  LpData: Pointer;
  LpdwHandle, Dwlen: DWORD;
Begin

  Dwlen := GetFileVersionInfoSize(PChar(Filename), LpdwHandle);
  GetMem(LpData, Dwlen);
  Try
    If Not GetFileVersionInfo(PChar(Filename), 0, Dwlen, LpData) Then Exit;
    VerQueryValue(LpData, '\\StringFileInfo\\040904e4\\FileDescription', Pointer(Buf), Dwlen);
    Result := Strpas(Buf);
  Finally
    FreeMem(LpData);
  End;
End;

{return the 'Product Name' property from the executable.}

Function MagGetProductName(Const Filename: String): String;
Var
  Buf: PChar;
  LpData: Pointer;
  LpdwHandle, Dwlen: DWORD;
Begin

  Dwlen := GetFileVersionInfoSize(PChar(Filename), LpdwHandle);
  GetMem(LpData, Dwlen);
  Try
    If Not GetFileVersionInfo(PChar(Filename), 0, Dwlen, LpData) Then Exit;
    VerQueryValue(LpData, '\\StringFileInfo\\040904e4\\ProductName', Pointer(Buf), Dwlen);
    Result := Strpas(Buf);
  Finally
    FreeMem(LpData);
  End;
End;
End.
