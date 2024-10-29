Unit cMagUserSpecialty;
{
  Package: MAG - VistA Imaging
  WARNING: Per VHA Directive 2004-038, this routine should not be modified.
  Date created: December 2005
  Site Name:  Washington OI Field Office, Silver Spring, MD
  Developer:  Robert Graves, Julian Werfel
  Description: This is specialty object.
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
//Uses Vetted 20090930:cMagHashmap, DateUtils, cMagTRUtils, uMagDefinitions, uMagUtils, SysUtils
Type
  TMagUserSpecialty = Class(Tobject)
  Public
    SpecialtyIEN: String; // not being used at the moment
    Active: Boolean;
    UserWants: Boolean;
    SiteStationNumber: String;   //P127T1 NST 04/09/2012 Refactor name of the property
    SiteName: String;
    PrimaryDivisionStationNumber: String;     //P127T1 NST 04/09/2012 Refactor name of the property
    SpecialtyCode: Integer;
    SpecialtyName: String;
    ProcedureCode: Integer;
    ProcedureName: String;
    LastUpdate: String;
    ProcedureStrings: String;
    SiteTimeOut: Integer;

    Constructor Create(Serialized: String);
    Function getProcedureValue(): String;
  Private
  End;

Implementation
Uses
  SysUtils,
  Umagutils8,
  UMagDefinitions,
  cMagTRUtils
  ;

Constructor TMagUserSpecialty.Create(Serialized: String);
Var
  Temp: String;
  SiteActive, SpecialtyActive, ProcedureActive: Boolean;
Begin
  SiteStationNumber := MagPiece(Serialized, '|', 1);   //P127T1 NST 04/09/2012 Refactor name of the property
  SiteName := MagPiece(Serialized, '|', 2);
  PrimaryDivisionStationNumber := MagPiece(Serialized, '|', 3);   //P127T1 NST 04/09/2012 Refactor name of the property
  If PrimaryDivisionStationNumber = '' Then                       //P127T1 NST 04/09/2012 Refactor name of the property
    PrimaryDivisionStationNumber := SiteStationNumber;            //P127T1 NST 04/09/2012 Refactor name of the property

  SiteActive := Magstrtobool(MagPiece(Serialized, '|', 4));

  Temp := MagPiece(Serialized, '|', 5);
  If Temp = '' Then
    SiteTimeOut := 0
  Else
    SiteTimeOut := Strtoint(Temp);

  Temp := MagPiece(Serialized, '|', 6);
  If Temp = '' Then
    SpecialtyCode := -1
  Else
    SpecialtyCode := Strtoint(Temp);
  SpecialtyName := MagPiece(Serialized, '|', 7);
  SpecialtyActive := Magstrtobool(MagPiece(Serialized, '|', 8));

  Temp := MagPiece(Serialized, '|', 9);
  If Temp = '' Then
    ProcedureCode := -1
  Else
    ProcedureCode := Strtoint(Temp);
  ProcedureName := MagPiece(Serialized, '|', 10);
  ProcedureActive := Magstrtobool(MagPiece(Serialized, '|', 11));

  UserWants := Magstrtobool(MagPiece(Serialized, '|', 12));

  Active := True;
  If (Not SiteActive) Or (Not SpecialtyActive) Or (Not ProcedureActive) Then
    Active := False;

  ProcedureStrings := '';

  PrimaryDivisionMap.put(SiteStationNumber, PrimaryDivisionStationNumber);  //P127T1 NST 04/09/2012 Refactor name of the property

(*
  SpecialtyIEN := magpiece(Serialized, '|', 1);
  Active := magstrtobool(magpiece(Serialized, '|', 2));
  UserWants := magstrtobool(magpiece(Serialized, '|', 3));
  SiteCode := magpiece(Serialized, '|', 4);
  SiteName := magpiece(Serialized, '|', 5);
  temp := magpiece(Serialized, '|', 6);
  if temp <> '' then
  begin
    SpecialtyCode := StrToInt(temp);// StrToInt(magpiece(Serialized, '|', 6));
  end
  else
  begin
    SpecialtyCode := -1;
  end;
  SpecialtyName := magpiece(Serialized, '|', 7);
  temp := magpiece(Serialized, '|', 8);
  if temp <> '' then
  begin
    ProcedureCode := StrToInt(temp);  //StrToInt(magpiece(Serialized, '|', 8));
  end
  else
  begin
    ProcedureCode := -1;
  end;
  ProcedureName := magpiece(Serialized, '|', 9);
  LastUpdate := '';
  *)
End;

Function TMagUserSpecialty.getProcedureValue(): String;
Begin
  Result := '';
  If ProcedureCode <> -1 Then
    Result := Inttostr(ProcedureCode);
End;

End.
