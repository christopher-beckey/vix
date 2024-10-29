unit MagFileVersion;
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

interface
uses Windows, Messages, SysUtils, Classes, Graphics, Controls, Forms, Dialogs,
  StdCtrls//, uMagUtils
  ;
procedure MagGetDisplayProperties(const filename: string; var t: Tstrings);
function MagGetFileVersionInfo(filename: string; vistaformat : boolean = true): string;
function MagGetOSVersion: string;
function MagGetFileDescription(const filename: string): string;
function MagGetProductName(const filename: string): string;
function MagSTRPiece(str, del: string; Piece: Integer): string;
function GetExeFileSize(FileName: string): DWord;
implementation

function MagSTRPiece(str, del: string; Piece: Integer): string;
var I, K: INTEGER;
  s: string;
begin
  I := Pos(del, str);
  if (I = 0) and (PIECE = 1) then begin result := STR; EXIT; end;
  for K := 1 to PIECE do
  begin
    I := POS(DEL, STR);
    if (I = 0) then I := LENGTH(STR) + 1;
    S := COPY(STR, 1, I - 1);
    STR := COPY(STR, I + 1, LENGTH(STR));
  end;
  result := S;
end;

function GetExeFileSize(FileName: string): DWord;
var Handle: DWord;
begin
  result := GetFileVersionInfoSize(PAnsiChar(FileName), Handle);
end;

{ -------------------------------- }
{ Returns the 'FileVersion' property for a given executable 'filename'
  The Actual Version number in Delphi is stored in a 'Released Sequencing Version'
  format.  This format makes it possible to sort the Delphi clients in Released
  order by this number. i.e. 30.5.8.45 will sort after 30.4.33.15 even though
  8 is before 33.
  if vistaformat = TRUE the number is returned in normal format 3.0.8.45  }
function MagGetFileVersionInfo(filename: string; vistaformat : boolean = true): string;
var
  buf: Pchar;
  lpdata: pointer;
  lpdwHandle, dwlen: Dword;
  magVer,magSeq,magPatch,magTver : string;
  magVerMaj,MagVerMin : string;
begin
  dwlen := GetFileVersionInfoSize(pchar(filename), lpdwHandle);
  GetMem(lpdata, dwlen);
  try
    if not GetFileVersionInfo(pchar(Filename), 0, dwlen, lpdata) then exit;
    VerQueryValue(lpdata, '\\StringFileInfo\\040904e4\\FileVersion', pointer(buf), dwlen);
    result := strpas(buf);
   finally
    freemem(lpdata);
  end;
  if not vistaformat then exit;
  magVer := magSTRpiece(result,'.',1); //Bill B.
  magSeq := magSTRpiece(result,'.',2); //Bill B.
  magPatch := magSTRpiece(result,'.',3); //Bill B.
  magTver := magSTRpiece(result,'.',4); //Bill B.
if (length(magVer)> 1) then
  begin
  {The new versioning scheme  30.5.8.39
    30 is Major Version and Minor Version   ie  3.0
    5 (2nd '.' piece) is the release sequence number
    which we won't show to end user
    8 (3rd) is the Patch       39 (4th) is the Tversion.}
    magVerMaj := copy(magVer,1,1);
    magVerMin := Copy(magver,2,99);
  end
  else
  begin
    {The Old versioning scheme  3.0.8.39
    3 (1st) is Major Version   0 (2nd) is Minor Version
    8 (3rd) is the Patch       39 (4th) is the Tversion.}
    magVerMaj := magVer;
    magVerMin := magSeq;
  end;
  {  this is just numbers    3.0.8.39}
  result := MagVerMaj + '.' + MagVerMin + '.' + MagPatch + '.' + MagTVer;
  {  this is easily readable foramt  Version: 3.0 (patch 8, T version 39)
     result := 'Version: '+magvermaj+'.'+magvermin+' (patch '+magPatch+'T'+magtver+')';{}
end;

{ Return the Operating System version. i.e. Windows XP}
{TODO: create a common utility object to be used by BP, Display and other Delphi clients.
  This code is copied/pasted from Richards BP utility}
function MagGetOSVersion: string;
var
   VersionInfo: TOSVersionInfo;
   Platform: string;
begin
  VersionInfo.dwOSVersionInfoSize := SizeOf(VersionInfo);
  GetVersionEx(VersionInfo);
  with VersionInfo do begin
    case dwPlatformId of
      VER_PLATFORM_WIN32s       {0} : Platform := 'Win32s';
      VER_PLATFORM_WIN32_WINDOWS{1} :
        case dwMinorVersion of
          0  : Platform := 'Win 95';
          10 : Platform := 'Win 98';
          90 : Platform := 'Win Me';
          end; //  case dwMinorVersion of
      VER_PLATFORM_WIN32_NT     {2} :
        case dwMajorVersion of
          4 : Platform := 'Win NT' ;
          5 : begin
            if dwMinorVersion = 0 then
                Platform := 'Win 2000 ';
            if dwMinorVersion = 1 then
                Platform := 'Win XP';
            if dwMinorVersion = 2 then
                Platform := 'Win Server';
              end; // Case of 5
          end; //  case dwMajorVersion
     end; //case dwPlatformId
    result := platform+ '.'+inttostr(dwMajorVersion)+'.'+inttostr(dwMinorVersion)+'.'+
    inttostr(dwBuildNumber);
    end;
end;

{ Return the common properties from the Version Information in a list }
procedure MagGetDisplayProperties(const filename: string; var t: Tstrings);
var
  buf: Pchar;
  lpdata: pointer;
  lpdwHandle, dwlen: Dword;
begin

  t.clear;
  dwlen := GetFileVersionInfoSize(pchar(filename), lpdwHandle);
  GetMem(lpdata, dwlen);
  try
    if not GetFileVersionInfo(pchar(Filename), 0, dwlen, lpdata) then exit;
    VerQueryValue(lpdata, '\\StringFileInfo\\040904e4\\CompanyName', pointer(buf), dwlen);
    t.add('Company Name     : ' + strPas(buf));
    VerQueryValue(lpdata, '\\StringFileInfo\\040904e4\\ProductName', pointer(buf), dwlen);
    t.add('Product Name     : ' + strPas(buf));
    VerQueryValue(lpdata, '\\StringFileInfo\\040904e4\\ProductVersion', pointer(buf), dwlen);
    t.add('Product Version  : ' + strPas(buf));
    VerQueryValue(lpdata, '\\StringFileInfo\\040904e4\\FileDescription', pointer(buf), dwlen);
    t.add('File Description : ' + strPas(buf));
    VerQueryValue(lpdata, '\\StringFileInfo\\040904e4\\FileVersion', pointer(buf), dwlen);
    t.add('File Version     : ' + strPas(buf));
    t.add('Operating System : ' + MagGetOSVersion);
  finally
    freemem(lpdata);
  end;
end;

{return the 'File Description' property from the executable.}
function MagGetFileDescription(const filename: string): string;
var
  buf: Pchar;
  lpdata: pointer;
  lpdwHandle, dwlen: Dword;
begin

  dwlen := GetFileVersionInfoSize(pchar(filename), lpdwHandle);
  GetMem(lpdata, dwlen);
  try
    if not GetFileVersionInfo(pchar(Filename), 0, dwlen, lpdata) then exit;
    VerQueryValue(lpdata, '\\StringFileInfo\\040904e4\\FileDescription', pointer(buf), dwlen);
    result :=  strPas(buf);
  finally
    freemem(lpdata);
  end;
end;


{return the 'Product Name' property from the executable.}
function MagGetProductName(const filename: string): string;
var
  buf: Pchar;
  lpdata: pointer;
  lpdwHandle, dwlen: Dword;
begin

  dwlen := GetFileVersionInfoSize(pchar(filename), lpdwHandle);
  GetMem(lpdata, dwlen);
  try
    if not GetFileVersionInfo(pchar(Filename), 0, dwlen, lpdata) then exit;
    VerQueryValue(lpdata, '\\StringFileInfo\\040904e4\\ProductName', pointer(buf), dwlen);
    result :=  strPas(buf);
  finally
    freemem(lpdata);
  end;
end;
end.
