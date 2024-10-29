{*------------------------------------------------------------------------------
  Utility functions for TeleReader application.

  @author Julian Werfel
  @version 1/10/2006 VistA Imaging Version 3.0 Patch 46
-------------------------------------------------------------------------------}
Unit cMagTRUtils;
{
  Package: MAG - VistA Imaging
  WARNING: Per VHA Directive 2004-038, this routine should not be modified.
  Date created: January 2006
  Site Name:  Washington OI Field Office, Silver Spring, MD
  Developer:  Julian Werfel
  Description: Utility functions for the TeleReader application
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
        ;; a Class II medical device.  As such, it may not be changed
        ;; in any way.  Modifications to this software may result in an
        ;; adulterated medical device under 21CFR820, the use of which
        ;; is considered to be a violation of US Federal Statutes.
        ;;+---------------------------------------------------------------------------------------------------+
*)

Interface

Uses
  cMagHashmap,
  Windows,
  Forms
  ;

//Uses Vetted 20090930:Windows, Registry, DateUtils, strutils, sysutils, uMagUtils

Function BuildMDate(NumDaysBack: Integer): String;
Function addUniquePiece(Value, Piece, Delimiter: String): String;
Function convertDateMonth(v: Integer): String;
Function convertYearTo2Digit(y: Integer): String;
Function getParentDir(inputDirectory: String): String;
Function getCPRSLocationFromRegistry(): String;
Function getPrimaryDivision(Sitecode: String): String;

Procedure ShowMessage508(Const Msg: String; Handle: Hwnd);

Var
//  PrimaryDivisonMap : IStrStrMap;
  PrimaryDivisionMap: TMagHashmap;

Implementation
Uses
  DateUtils,
  Registry,
  StrUtils,
  SysUtils,
  Umagutils8
  ;

Function getPrimaryDivision(Sitecode: String): String;
Begin
  Result := '';
  If Sitecode = '' Then Exit;
  If PrimaryDivisionMap = Nil Then Exit;
  Result := PrimaryDivisionMap.Get(Sitecode);
End;

{*------------------------------------------------------------------------------
  Checks the registry to find the location where CPRS exists. Finds the
    executable using the Type GUID.

  @author Julian Werfel
  @return The full path to CPRS
-------------------------------------------------------------------------------}

Function getCPRSLocationFromRegistry(): String;
Var
  Registry: TRegistry;
  KeyName: String;
Begin
  Result := '';
  KeyName := 'SOFTWARE\Classes\TypeLib\{0A4A6086-6504-11D5-82DE-00C04F72C274}\1.0\0\win32';
  Registry := TRegistry.Create(KEY_READ);
  Try
    Registry.RootKey := HKEY_LOCAL_MACHINE;
    // False because we do not want to create it if it doesn't exist
    Registry.OpenKey(KeyName, False);
    Result := Registry.ReadString('');
  Finally
    Registry.Free;
  End;
End;

{*------------------------------------------------------------------------------
  Builds a valid M Date based on the current date minus the number of days back
    desired

  @author Julian Werfel
  @param NumDaysBack The number of days in the past to go back to create the date for
  @return The M date as a String
-------------------------------------------------------------------------------}

Function BuildMDate(NumDaysBack: Integer): String;
Var
  daysback: Integer;
  Res: String;
  Day, Month, Year, Hour, Min, Sec: Integer;
  dateToUse: Tdatetime;
  yearDifference: Integer;
  secondValue: String;
Begin
  dateToUse := Now - NumDaysBack;
  Day := DayOfTheMonth(dateToUse);
  Month := MonthOfTheYear(dateToUse);
  Year := YearOf(dateToUse);
  Hour := HourOfTheDay(DateToUse);
  Min := MinuteOf(DateToUse);
  Sec := SecondOf(DateToUse);
  yearDifference := Trunc((Year - 1700) / 100);
  If Sec > 0 Then
  Begin
    If ((Sec Mod 10) = 0) Then
      secondValue := Inttostr(Trunc(Sec / 10))
    Else
      secondValue := Inttostr(Sec);
  End
  Else
    secondValue := '';
  Res := Inttostr(yearDifference) + convertYearTo2Digit(Year) + convertDateMonth(Month) + convertDateMonth(Day) + '.' + convertDateMonth(Hour) + convertDateMonth(Min) + secondValue;
  Result := Res;
End;

{*------------------------------------------------------------------------------
  Converts the input value to show 2 digits.  If the value is less than 10 it
    will prepend a 0 to the front

  @author Julian Werfel
  @param v The day to check
  @return The value in 2 digits
-------------------------------------------------------------------------------}

Function convertDateMonth(v: Integer): String;
Begin
  If v < 10 Then
    Result := '0' + Inttostr(v)
  Else
    Result := Inttostr(v);
End;

{*------------------------------------------------------------------------------
  Converts the year to the 2 digit value

  @author Julian Werfel
  @param y The year value
  @return The value in 2 digits
-------------------------------------------------------------------------------}

Function convertYearTo2Digit(y: Integer): String;
Var
  yearValue: String;
Begin
  yearValue := Inttostr(y);
  Result := MidStr(yearValue, 3, 2);
End;

{*------------------------------------------------------------------------------
  Adds the Piece to the value if the piece is unique

  @author Julian Werfel
  @param Value The string to check
  @param Piece The piece to add to value
  @param delimiter The delimiter to use
  @return The string with the piece added if it is unique
-------------------------------------------------------------------------------}

Function addUniquePiece(Value, Piece, Delimiter: String): String;
Var
  Len: Integer;
  i: Integer;
  Res, Item: String;
Begin
  Result := Value;
  Len := Maglength(Value, Delimiter);
  If Len = 0 Then Exit;
  For i := 0 To Len Do
  Begin
    Item := MagPiece(Value, Delimiter, i);
    If Item = Piece Then Exit;
  End;
  Res := Value + Delimiter + Piece;
  Result := Res;
End;

Function getParentDir(inputDirectory: String): String;
Var
  i, pieces: Integer;
  Str: String;

Begin
  pieces := Maglength(inputDirectory, '\');
  Str := '';
  Str := MagPiece(inputDirectory, '\', 1);
  For i := 2 To pieces - 1 Do
  Begin
    Str := Str + '\' + MagPiece(inputDirectory, '\', i);
  End;
  Result := Str;
End;

Procedure ShowMessage508(Const Msg: String; Handle: Hwnd);
Var
  Text, Cap: PAnsichar;
Begin
  Text := PAnsiChar(Msg);
  Cap := PAnsiChar(Application.Title);
  MessageBox(Handle, Text, Cap, MB_OK);
End;

End.
