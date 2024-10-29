Unit cMagUtils;
  {
   Package: MAG - VistA Imaging
 WARNING: Per VHA Directive 10-93-142 this unit should not be modified.
 Date Created:     Version 2.0
 Site Name: Silver Spring, OIFO
 Developers: Garrett Kirin
 [==     unit cMagUtils;
 Description:     Imaging Utilities.
  Some functions and methods are used by many Forms (windows) and components of
 the application.  Utility components are designed to be a repository of such
 utility functions used throughout the application.
 Other Compontents that need the methods contained in the utililty components
 can declare a property of that type and have the utility object set at design time.

    This utility class has M functions that are recreated for Delphi use.  String
    functions like $P, $L.
    Also has INI functions to Get and Set an INI entry.
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
Interface

Uses
  Classes,
  Forms
  ;

//Uses Vetted 20090929:Dialogs, Controls, Graphics, Messages, Windows, strutils, magguini, inifiles, SysUtils

Type
  TMagUtils = Class(TComponent)
  Private

    { Private declarations }
  Protected
    { Protected declarations }
  Public
    {   parse characters out of the Site Code}
    Function ParseSiteCode(Input: String): String;

        {       Mumps $TR function: return a string that
                changes all 'frchar' to 'tochar' in string 'str'}
    Function Transpose(Str: String; Frchar, Tochar: Char): String;

        {       If form is minimized, hidden, or behind other forms, use this}
    Procedure FormToNormalSize(XForm: TForm);

        {       Application path.}
    Function GetAppPath(): String;

        {       full path name to the blank.bmp file.  Used to Clear a TGear control.}
    Function BlankImage(): String;

        {       Strips spaces ' ' from front and back}
    Function Stripspaces(Str: String): String;

     {   MagSetPiece - Set a certain piece of a string);}
    Function MagSetPiece(InString: String; Delimiter: String; Piece: Integer; ReplacePiece: String): String;
        {       Mumps $P function: return the 'piece' piece delimited by 'delim'}
    Function MagPiece(Str, Delim: String; Piece: Integer): String; // $Piece

        {       Mumps $P function: return the 'piece' piece delimited by 'delim'}
    Function DP(Str, Delim: String; Piece: Integer): String; // $Piece

        {       Mumps $L function: return number of 'delim' delimited pieces}
    Function Maglength(Str, Delim: String): Integer; //$length

        {       Mumps $L function: return number of 'delim' delimited pieces}
    Function DL(Str, Delim: String): Integer; // $Length

        {       Gets the 'section:entry' value from INI file.
                INI file name is retrieved by the 'GetConfigFileName' method}
    Function GetIniEntry(Section, Entry: String): String;

        {       Sets the 'section:entry' value in the INI File
                INI file name is retrieved by the 'GetConfigFileName' method}
    Procedure SetIniEntry(Section, Entry, Value: String);

    { Insert a value into a string JMW 6/22/2005 p45}
    Function MagInsertPiece(InString: String; Delimiter: String; Location: Integer; InsertValue: String): String;

  Published
  End;

Procedure Register;

Implementation
Uses
  Inifiles,
  Magguini,
  StrUtils,
  SysUtils
  ;

Procedure Register;
Begin
  RegisterComponents('Imaging', [TMagUtils]);
End;

{ TMagUtils }

Procedure TMagUtils.FormToNormalSize(XForm: TForm);
Begin
  If (XForm.WindowState = Wsminimized) Then XForm.WindowState := Wsnormal;
  XForm.Update;
  If XForm.Visible = False Then XForm.Visible := True;
  XForm.BringToFront;
  XForm.Update;
  Application.Processmessages;
End;

Function TMagUtils.GetIniEntry(Section, Entry: String): String;
Var
  Magini: TIniFile;
Begin
  Magini := TIniFile.Create(GetConfigFileName);
  Result := Magini.ReadString(Section, Entry, '');
  Magini.Free;
End;

Procedure TMagUtils.SetIniEntry(Section, Entry, Value: String);
Var
  Magini: TIniFile;
Begin
  Magini := TIniFile.Create(GetConfigFileName);
  Magini.Writestring(Section, Entry, Value);
  Magini.Free;
End;

Function TMagUtils.Transpose(Str: String; Frchar, Tochar: Char): String;
Var
  i: Integer;
Begin
  Result := '';
  For i := 1 To Maglength(Str, Frchar) Do
    Result := Result + MagPiece(Str, Frchar, i) + Tochar;
  Result := Copy(Result, 1, Length(Result) - 1);
End;

Function TMagUtils.GetAppPath(): String;
Begin
  Result := Copy(ExtractFilePath(Application.ExeName), 1, Length(ExtractFilePath(Application.ExeName)) - 1);
End;

Function TMagUtils.BlankImage: String;
Begin
  Result := GetAppPath + '\bmp\blank.bmp';
End;

{ $Length (same as MagLength function)}

Function TMagUtils.DL(Str, Delim: String): Integer;
Var
  i, j: Integer;
  EndStr: Boolean;
Begin
  EndStr := False;
  i := 0;
  While Not EndStr Do
  Begin
    i := i + 1;
    If (Pos(Delim, Str) = 0) Then EndStr := True;
    j := Pos(Delim, Str);
    Str := Copy(Str, j + 1, Length(Str));
  End;
  Result := i;
End;

{   $Piece (same as MagPiece function)}

Function TMagUtils.DP(Str, Delim: String; Piece: Integer): String;
Var
  i, k: Integer;
  s: String;
Begin
  i := Pos(Delim, Str);
  If (i = 0) And (Piece = 1) Then
  Begin
    Result := Str;
    Exit;
  End;
  For k := 1 To Piece Do
  Begin
    i := Pos(Delim, Str);
    If (i = 0) Then i := Length(Str) + 1;
    s := Copy(Str, 1, i - 1);
    Str := Copy(Str, i + 1, Length(Str));
  End;
  Result := s;
End;

Function TMagUtils.Stripspaces(Str: String): String;
Var
  Done: Boolean;
  s: String;
Begin
  If Str = '' Then
  Begin
    Result := '';
    Exit;
  End; {fix for hang}
  Done := False;
  Repeat
    s := Str[1];
    If (s = ' ') Then Str := Copy(Str, 2, Length(Str));
    If Not (Str[1] = ' ') Then Done := True;
    If Str = '' Then Done := True; {fix for hang}
  Until Done;
  Done := False;
  Repeat
    s := Str[Length(Str)];
    If (s = ' ') Then Str := Copy(Str, 1, Length(Str) - 1);
    If Not (Str[Length(Str)] = ' ') Then Done := True;
    If Str = '' Then Done := True; {fix for hang}
  Until Done;
  Result := Str;
End;

Function TMagUtils.Maglength(Str, Delim: String): Integer;
Var
  i, j: Integer;
  Estr: Boolean;
Begin
  Estr := False;
  i := 0;
  While Not Estr Do
  Begin
    i := i + 1;
    If (Pos(Delim, Str) = 0) Then Estr := True;
    j := Pos(Delim, Str);
    Str := Copy(Str, j + 1, Length(Str));
  End;
  Maglength := i;
End;

Function TMagUtils.MagPiece(Str, Delim: String; Piece: Integer): String;
Var
  i, k: Integer;
  s: String;
Begin
  i := Pos(Delim, Str);
  If (i = 0) And (Piece = 1) Then
  Begin
    Result := Str;
    Exit;
  End;
  For k := 1 To Piece Do
  Begin
    i := Pos(Delim, Str);
    If (i = 0) Then i := Length(Str) + 1;
    s := Copy(Str, 1, i - 1);
    Str := Copy(Str, i + 1, Length(Str));
  End;
  Result := s;
End;

Function TMagUtils.MagInsertPiece(InString: String; Delimiter: String; Location: Integer; InsertValue: String): String;
Var
  i, k: Integer;
  FirstPart: String;
Begin
  i := Pos(Delimiter, InString);
  If (i = 0) And (Location = 1) Then
  Begin
    Result := InsertValue;
    Exit;
  End;
  If (Location = 1) Then
  Begin
    Result := InsertValue + Delimiter + InString;
    Exit;
  End;
  If (Maglength(InString, Delimiter) + 1) = Location Then
  Begin
    Result := InString + Delimiter + InsertValue;
    Exit;
  End;
  If (Maglength(InString, Delimiter) < (Location - 1)) Then
  Begin
    Result := InString;
    Exit;
  End;
  For k := 1 To Location - 1 Do
  Begin
    i := Pos(Delimiter, InString);
    If (i = 0) Then i := Length(InString) + 1;

    If FirstPart = '' Then
    Begin
      FirstPart := Copy(InString, 1, i - 1);
    End
    Else
    Begin
      FirstPart := FirstPart + Delimiter + Copy(InString, 1, i - 1);
    End;
    InString := Copy(InString, i + 1, Length(InString));

  End;
  Result := FirstPart + Delimiter + InsertValue + Delimiter + InString;
End;

Function TMagUtils.MagSetPiece(InString: String; Delimiter: String; Piece: Integer; ReplacePiece: String): String;
Var
  i, k, K2: Integer;
Begin
  While (Maglength(InString, Delimiter) < Piece) Do
    InString := InString + Delimiter;
  If Piece = 1 Then
  Begin
    Result := ReplacePiece + Copy(InString, Pos(Delimiter, InString), 9999);
    Exit;
  End;
  k := 1;
  For i := 1 To Piece - 1 Do
    k := PosEx(Delimiter, InString, k) + 1;
  If Piece = Maglength(InString, Delimiter) Then
    K2 := 99999
  Else
    K2 := PosEx(Delimiter, InString, k);
  Result := Copy(InString, 1, k - 1) + ReplacePiece + Copy(InString, K2, 99999);
End;

Function TMagUtils.ParseSiteCode(Input: String): String;
Var
  i: Integer;
  Abbr, Res: String;
  OrdValue: Integer;
Begin
  Abbr := Uppercase(Input);
  Res := '';
  // 48-57
  For i := 1 To Length(Abbr) Do
  Begin
    OrdValue := Ord(Abbr[i]);
    // 48-57 are numbers
    // 9/9/2005 p45t8 Fix bug with Station Numbers that end with numbers after letters
    If (OrdValue < 48) Or (OrdValue > 57) Then
    Begin

      If Res <> '' Then
      Begin
        Result := Res;
        Exit;
      End;
    End
    Else
    Begin
      Res := Res + Abbr[i];
    End;
    {
    if (ordValue > 47) and (ordValue < 58) then
    begin
      res := res + abbr[i];
    end;
    }
  End;
  Result := Res;
End;
End.
