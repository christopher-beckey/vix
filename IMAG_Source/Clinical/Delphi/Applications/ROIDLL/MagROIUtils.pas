unit MagROIUtils;

{
Package: MAG - VistA Imaging
WARNING: Per VHA Directive 10-93-142 this unit should not be modified.
Date Created:   March, 2012
Site Name: Silver Spring, OIFO
Developers: Jerry Kashtan
[==   unit MagROIUtils.pas
==]

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

uses
  SysUtils, Classes, Windows, Dialogs;

    function IIf(Expression: Boolean; TruePart, FalsePart: SmallInt): SmallInt; overload;
    function IIf(Expression: Boolean; TruePart, FalsePart: Integer): LongInt; overload;
    function IIf(Expression: Boolean; TruePart, FalsePart: Single): Single; overload;
    function IIf(Expression: Boolean; TruePart, FalsePart: ShortInt): ShortInt; overload;
    function IIf(Expression: Boolean; TruePart, FalsePart: Byte): Byte; overload;
    function IIf(Expression: Boolean; TruePart, FalsePart: Word): Word; overload;
    function IIf(Expression: Boolean; TruePart, FalsePart: LongWord): LongWord; overload;
    function IIf(Expression, TruePart, FalsePart: Boolean): Boolean; overload;
    function IIf(Expression: Boolean; TruePart, FalsePart: AnsiString): AnsiString; overload;
    function IIf(Expression: Boolean; TruePart, FalsePart: Double): Double; overload;
    function IIf(Expression: Boolean; TruePart, FalsePart: Currency): Currency; overload;
    function IIf(Expression: Boolean; TruePart, FalsePart: Extended): Extended; overload;

    function mStr(d: LongInt): AnsiString; overload;
    function mStr(d: Double): AnsiString;  overload;
    function mStr(b: Boolean): AnsiString;  overload;
    function mStr(s: AnsiString): AnsiString;  overload;
    function mStr(v: Variant): AnsiString;  overload;
    function mStr(obj: TObject): AnsiString;  overload;

  Function MagPiece(Str, Del: String; Piece: Integer): String;

  function GetDLLVersion: string;
  procedure VersionInformation(var VersionInfo: TStringList);

implementation

function IIf(Expression: Boolean; TruePart, FalsePart: Byte): Byte;
begin
	if Expression then Result := TruePart else Result := FalsePart;
end;
function IIf(Expression: Boolean; TruePart, FalsePart: Word): Word;
begin
	if Expression then Result := TruePart else Result := FalsePart;
end;
function IIf(Expression: Boolean; TruePart, FalsePart: LongWord): LongWord;
begin
	if Expression then Result := TruePart else Result := FalsePart;
end;
function IIf(Expression: Boolean; TruePart, FalsePart: ShortInt): ShortInt;
begin
	if Expression then Result := TruePart else Result := FalsePart;
end;
function IIf(Expression: Boolean; TruePart, FalsePart: SmallInt): SmallInt;
begin
	if Expression then Result := TruePart else Result := FalsePart;
end;
function IIf(Expression: Boolean; TruePart, FalsePart: LongInt): LongInt;
begin
	if Expression then Result := TruePart else Result := FalsePart;
end;
function IIf(Expression: Boolean; TruePart, FalsePart: Single): Single;
begin
	if Expression then Result := TruePart else Result := FalsePart;
end;
function IIf(Expression: Boolean; TruePart, FalsePart: Double): Double;
begin
	if Expression then Result := TruePart else Result := FalsePart;
end;
function IIf(Expression: Boolean; TruePart, FalsePart: Currency): Currency;
begin
	if Expression then Result := TruePart else Result := FalsePart;
end;
function IIf(Expression: Boolean; TruePart, FalsePart: Extended): Extended;
begin
	if Expression then Result := TruePart else Result := FalsePart;
end;
 function IIf(Expression: Boolean; TruePart, FalsePart: AnsiString): AnsiString;
begin
	if Expression then Result := TruePart else Result := FalsePart;
end;
 function IIf(Expression: Boolean; TruePart, FalsePart: Boolean): Boolean;
begin
	if Expression then Result := TruePart else Result := FalsePart;
end;

function mStr(d: LongInt): AnsiString;
begin
	Result := IntToStr(d);
	if (d>=0) then Result := ' ' + Result;
end;
function mStr(d: Double): AnsiString;
begin
	Result := FloatToStr(d);
	if (d>=0) then Result := ' ' + Result;
end;
function mStr(b: Boolean): AnsiString;
begin
	if (b) then Result := ' True'
	else	Result := ' False';
end;
function mStr(s: AnsiString): AnsiString;
begin
	Result := s;
end;
function mStr(v: Variant): AnsiString;
begin
	Result := v;
end;
function mStr(obj: TObject): AnsiString;
begin
	Result := '?';
end;

Function MagPiece(Str, Del: String; Piece: Integer): String;
Var
  i, k: Integer;
  s: String;
Begin
  i := Pos(Del, Str);
  If (i = 0) And (Piece = 1) Then
  Begin
    Result := Str;
    Exit;
  End;
  For k := 1 To Piece Do
  Begin
    i := Pos(Del, Str);
    If (i = 0) Then i := Length(Str) + 1;
    s := Copy(Str, 1, i - 1);
    Str := Copy(Str, i + 1, Length(Str));
  End;
  Result := s;
End;

function GetRealExeName: string;
var
  ExeName: array[0..MAX_PATH] of char;
begin
  fillchar(ExeName, SizeOf(ExeName), #0);
  GetModuleFileName(HInstance, ExeName, MAX_PATH);
  Result := ExeName;
end;

function GetDLLVersion: string;
var
  VerInfoSize: DWORD;
  VerInfo: Pointer;
  VerValueSize: DWORD;
  VerValue: PVSFixedFileInfo;
  Dummy: DWORD;
  FN: String;
begin
  try
    FN := GetRealExeName;
  VerInfoSize := GetFileVersionInfoSize(PChar(FN), Dummy);
  GetMem(VerInfo, VerInfoSize);
  GetFileVersionInfo(PChar(FN), 0, VerInfoSize, VerInfo);
  VerQueryValue(VerInfo, '\', Pointer(VerValue), VerValueSize);
  with VerValue^ do
  begin
    Result := IntToStr(dwFileVersionMS shr 16);
    Result := Result + '.' + IntToStr(dwFileVersionMS and $FFFF);
    Result := Result + '.' + IntToStr(dwFileVersionLS shr 16);
    Result := Result + '.' + IntToStr(dwFileVersionLS and $FFFF);
  end;
  FreeMem(VerInfo, VerInfoSize);
  except
    on E:Exception do
      Result := 'Cannot get dll version because: ' + E.Message;
  end;
end;

Function StringPad(
   InputStr,
   FillChar: String;
   StrLen: Integer;
   StrJustify: Boolean): String;
Var
   TempFill: String;
   Counter : Integer;
Begin
   If Not (Length(InputStr) = StrLen) Then
   Begin
     If Length(InputStr) > StrLen Then
     Begin
       InputStr := Copy(InputStr,1,StrLen) ;
     End
     Else
     Begin
       TempFill := '';
       For Counter := 1 To StrLen-Length(InputStr) Do
       Begin
         TempFill := TempFill + FillChar;
       End;
       If StrJustify Then
       Begin
         {Left Justified}
         InputStr := InputStr + TempFill;
       End
       Else
       Begin
         {Right Justified}
         InputStr := TempFill + InputStr ;
       End;
     End;
   End;
   Result := InputStr;
End;


procedure VersionInformation(var VersionInfo: TStringList);
const
   InfoNum = 11;
   InfoStr : array [1..InfoNum] of String =
     ('CompanyName', 'FileDescription', 'FileVersion',
      'InternalName', 'LegalCopyright', 'LegalTradeMarks',
      'OriginalFilename', 'ProductName', 'ProductVersion',
      'Comments', 'Author') ;
   LabelStr : array [1..InfoNum] of String =
     ('Company Name', 'Description', 'File Version',
      'Internal Name', 'Copyright', 'TradeMarks',
      'Original File Name', 'Product Name',
      'Product Version', 'Comments', 'Author') ;
var
   S : String;
   n, Len: Cardinal;
   j : Integer;
   Buf : PChar;
   Value : PChar;
begin
   Try
     VersionInfo.Clear;
     S := GetRealExeName;

     n := GetFileVersionInfoSize(PChar(S), n);

     If n > 0 Then Begin
       Buf := AllocMem(n) ;
       VersionInfo.Add (StringPad('Size',' ',20,True)+' = '+IntToStr(n)) ;
       GetFileVersionInfo(PChar(S),0,n,Buf) ;
       For j:=1 To InfoNum Do Begin
         If VerQueryValue(Buf,PChar('StringFileInfo\040904E4\' + InfoStr[j]),Pointer(Value),Len) Then
         Begin
           Value := PChar(Trim(Value)) ;
           If Length(Value) > 0 Then
           Begin
             VersionInfo.Add(StringPad(labelStr[j],' ',20,True) + ' = ' + Value) ;
           End;
         End;
       End;
       FreeMem(Buf,n) ;
     End
     Else Begin
       VersionInfo.Add('No FileVersionInfo found') ;
     End;
   Except
     on E:Exception do
       VersionInfo.Add('Get DLL Version Info exeception = ' + E.Message);
   End;

End;


end.
