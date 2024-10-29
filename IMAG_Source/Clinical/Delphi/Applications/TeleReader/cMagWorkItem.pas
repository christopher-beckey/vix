Unit cMagWorkItem;
{
  Package: MAG - VistA Imaging
  WARNING: Per VHA Directive 2004-038, this routine should not be modified.
  Date created: December 2005
  Site Name:  Washington OI Field Office, Silver Spring, MD
  Developer:  Robert Graves, Julian Werfel, NST
  Description: This is the work item object.
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
  cMagDBBroker
  ;

//Uses Vetted 20090930:TRPCB, cMagTRUtils, StrUtils, MagRemoteBrokerManager, uMagUtils, SysUtils

Type
  TMagWorkItem = Class(Tobject)
  Private
    SourceBroker: TMagDBBroker;
    Function GetStatusName(): String;
    Function ConvertDateTime(MDateTime: String): String;
    {/ P127T1 NST 04/06/2012 - To support Reading getting Primary Division Station Number /}
    Function GetReadingSitePrimaryDivisionStationNumber() : String;
    Function GetAcquisitionSitePrimaryDivisionStationNumber() : String;
  Public
    ID: Integer;
    AcquisitionSiteStationNumber: String;  {/ P127T1 NST 04/06/2012 Refactor variable name to reflect the meaning /}
    AcquisitionSiteShort: String;
    AcquisitionSiteConsultNumber: Integer;
    ReadingSiteCode: String;
    ReadingSiteStationNumber: String;   // P127T1 NST 04/06/2012 We will use Reading Site Station Number instead of Site IEN
    ReadingSiteShort: String;
    PatientName: String;
    PatientShortID: String;
    PatientICN: String;
    LocalPatientDFN: String;
    PatientSSN: String;
    Status: String;
    ImageAcquisitionStartTime: String;
    MImageAcquisitionStartTime: String;
    LastImageAcquiredTime: String;
    MLastImageAcquiredTime: String;
    DataReceivedTime: String;
    NumberOfImages: Integer;
    Urgency: String;
    IFCAccepted: Boolean;
    IFCConsultNumber: Integer;
    ReaderName: String;
    ReaderInitials: String;
    ReaderDUZ: String;
    ReaderRemoteDUZ: String;
    StartReadingTime: String;
    MStartReadingTime: String;
    EndReadingTime: String;
    MEndReadingTime: String;

    SpecialtyName: String;
    SpecialtyAbbr: String;
    ProcedureName: String;
    ProcedureAbbr: String;

    Property StatusName: String Read GetStatusName;
    Property ReadingSitePrimaryDivisionStationNumber : String Read GetReadingSitePrimaryDivisionStationNumber;  //P127T1 NST 04/09/2012  Use public property
    Property AcquisitionSitePrimaryDivisionStationNumber : String read GetAcquisitionSitePrimaryDivisionStationNumber;   //P127T1 NST 04/09/2012  Use public property
    Constructor Create(Serialized: String; Broker: TMagDBBroker);
    Function Lock(): String;
  End;

Implementation
Uses
  cMagTRUtils,
  MagRemoteBrokerManager,
  StrUtils,
  SysUtils,
  Umagutils8
  ;

Constructor TMagWorkItem.Create(Serialized: String; Broker: TMagDBBroker);
Var
  Temp: String;
Begin
  LocalPatientDFN := '';
  SourceBroker := Broker;
  //Id := StrToInt(magpiece(Serialized, '|', 1));

  Temp := MagPiece(Serialized, '|', 1);
  If Temp <> '' Then
    ID := Strtoint(Temp)
  Else
    ID := 0;

  //AcquisitionSiteConsultNumber := StrToInt(magpiece(Serialized, '|', 2));
  //TODO: maybe if work item id is empty, kill this instance?

  Temp := MagPiece(Serialized, '|', 2);
  If Temp <> '' Then
    AcquisitionSiteConsultNumber := Strtoint(Temp)
  Else
    AcquisitionSiteConsultNumber := 0;

  AcquisitionSiteStationNumber := MagPiece(Serialized, '|', 3);
  AcquisitionSiteShort := MagPiece(Serialized, '|', 4);
  PatientName := MagPiece(Serialized, '|', 5);
  PatientSSN := MagPiece(Serialized, '|', 6);
  Temp := MagPiece(Serialized, '|', 7);
  PatientICN := MagPiece(Temp, 'V', 1);
  PatientShortID := MagPiece(Serialized, '|', 8);
  // part 9 is the VIP status
  SpecialtyName := MagPiece(Serialized, '|', 10);
  SpecialtyAbbr := MagPiece(Serialized, '|', 11);
  ProcedureName := MagPiece(Serialized, '|', 12);
  ProcedureAbbr := MagPiece(Serialized, '|', 13);

  MImageAcquisitionStartTime := MagPiece(Serialized, '|', 14);
  ImageAcquisitionStartTime := ConvertDateTime(MImageAcquisitionStartTime);
  MLastImageAcquiredTime := MagPiece(Serialized, '|', 15);
  LastImageAcquiredTime := ConvertDateTime(MLastImageAcquiredTime);
  DataReceivedTime := MagPiece(Serialized, '|', 16);
  Temp := MagPiece(Serialized, '|', 17);
  If (Temp <> '') Then
    NumberOfImages := Strtoint(Temp)
  Else
    NumberOfImages := 0;
//  NumberOfImages := StrToInt(magpiece(Serialized, '|', 17));
  Status := MagPiece(Serialized, '|', 18);
  Urgency := MagPiece(Serialized, '|', 20);
  ReadingSiteCode := MagPiece(Serialized, '|', 21);
  ReadingSiteShort := MagPiece(Serialized, '|', 22);
  Temp := MagPiece(Serialized, '|', 23);
  If (Temp <> '') Then
    IFCConsultNumber := Strtoint(Temp)
  Else
    IFCConsultNumber := 0;
  ReaderName := MagPiece(Serialized, '|', 27);
  ReaderInitials := MagPiece(Serialized, '|', 28);

  ReaderRemoteDUZ := MagPiece(Serialized, '|', 29); // this might not be the right place...

  ReaderDUZ := MagPiece(Serialized, '|', 30);
  MStartReadingTime := MagPiece(Serialized, '|', 32);
  StartReadingTime := ConvertDateTime(MStartReadingTime);
  MEndReadingTime := MagPiece(Serialized, '|', 33);
  EndReadingTime := ConvertDateTime(MEndReadingTime);
  //P127T1 NST - Set the Reader Site Station Number. (IFC Routing site)
  ReadingSiteStationNumber := MagPiece(Serialized, '|', 34);
End;

Function TMagWorkItem.Lock(): String;
Var
  LockValue: String;
Begin
  If (Status = 'U') Then
    LockValue := '1'
  Else
    LockValue := '0';
  If Not SourceBroker.RPMagTeleReaderUnreadlistLock(Result, AcquisitionSitePrimaryDivisionStationNumber, AcquisitionSiteStationNumber, Inttostr(ID), LockValue, MagRemoteBrokerManager1.GetUserFullName(),
    MagRemoteBrokerManager1.GetUserInitials(), MagRemoteBrokerManager1.GetUserLocalDUZ(), MagRemoteBrokerManager1.LocalSiteCode, MagRemoteBrokerManager1.LocalSiteStationNumber) Then  //P127T1 -  NST 04/06/2012 - Send Reader Site Station Number
  Begin
    // not sure what to do here... never did anything before
    Exit;
  End;
  Status := MagPiece(Result, '|', 3);

  If (Status = 'U') Then
  Begin
    ReaderName := '';
    ReaderInitials := '';
    ReaderDUZ := '';
  End
  Else
  Begin
    ReaderName := MagRemoteBrokerManager1.GetUserFullName();
    ReaderInitials := MagRemoteBrokerManager1.GetUserInitials();
    ReaderDUZ := MagRemoteBrokerManager1.GetUserLocalDUZ();
  End;
End;

Function TMagWorkItem.GetStatusName: String;
Begin
  If Status = 'U' Then
    Result := 'Unread'
  Else
    If Status = 'L' Then
      Result := 'Locked'
    Else
      If Status = 'R' Then
        Result := 'Read'
      Else
        If Status = 'W' Then
          Result := 'Waiting'
        Else
          If Status = 'C' Then
            Result := 'Cancelled';
End;

Function TMagWorkItem.ConvertDateTime(MDateTime: String): String;
Begin
  Result := '';
  If (MDateTime = '') Then Exit;
  Result := MidStr(MDateTime, 4, 2) + '/' + MidStr(MDateTime, 6, 2) + ' '
    + MidStr(MDateTime, 9, 2) + ':' + MidStr(MDateTime, 11, 2);
End;

{/ P127T1 NST - 04/06/2012
  If reading Site Station number is defined  use it to get Primary division
  Otherwise use Site IEN/}
Function TMagWorkItem.GetReadingSitePrimaryDivisionStationNumber: String;
begin
  if ReadingSiteStationNumber <> '' then
  begin
    Result := getPrimaryDivision(ReadingSiteStationNumber);
  end
  else
  begin
    Result := getPrimaryDivision(ReadingSiteCode);
  end;
end;

// P127T1 NST 04/06/2012 Get Primary Division  for Acquisition Site
function TMagWorkItem.GetAcquisitionSitePrimaryDivisionStationNumber: String;
begin
  Result := getPrimaryDivision(AcquisitionSiteStationNumber);
end;

End.
