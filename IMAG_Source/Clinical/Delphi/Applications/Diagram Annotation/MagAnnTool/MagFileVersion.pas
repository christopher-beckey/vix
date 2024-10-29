unit MagFileVersion;
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
        ;; a Class II medical device.  As such, it may not be changed
        ;; in any way.  Modifications to this software may result in an
        ;; adulterated medical device under 21CFR820, the use of which
        ;; is considered to be a violation of US Federal Statutes.
        ;; +---------------------------------------------------------------------------------------------------+

*)

interface
uses Windows, Messages, SysUtils, Classes, Graphics, Controls, Forms, Dialogs,
  StdCtrls;
procedure MagGetDisplayProperties(const filename: string; var t: Tstrings);
function MagGetFileVersionInfo(filename: string): string;
function MagGetOSVersion: string;

implementation

function MagGetFileVersionInfo(filename: string): string;
var
  buf: Pchar;
  lpdata: pointer;
  lpdwHandle, dwlen: Dword;
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
end;

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
        if ((dwMajorVersion > 4) or ((dwMajorVersion = 4) and (dwMinorVersion > 0))) then
           Platform := 'Win 98'
        else Platform := 'Win 95';
      VER_PLATFORM_WIN32_NT     {2} : begin
        if dwMajorVersion <=4 then Platform := 'Win NT';
        if dwMajorVersion = 5 then Platform := 'Win 2000 ';
        end; //NT
      end; //case
    result := platform+ '.'+inttostr(dwMajorVersion)+'.'+inttostr(dwMinorVersion)+'.'+
    inttostr(dwBuildNumber);
    end;
end;

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
  finally
    freemem(lpdata);
  end;
end;
end.
