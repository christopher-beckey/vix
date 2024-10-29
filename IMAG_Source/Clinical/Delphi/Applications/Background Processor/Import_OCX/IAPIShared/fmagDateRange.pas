Unit FmagDateRange;
   {
   Package: MAG - VistA Imaging
   WARNING: Per VHA Directive 10-93-142 this unit should not be modified.
   Date Created:
   Site Name: Silver Spring, OIFO
   Developers: Garrett Kirin
   Description: Prompts User to select a From date and To Date.  This Date Range
      can be used by any form.
      It is being used by Add/Edit Image Filter
   Note:
   }
(*
        ;; +------------------------------------------------------------------+
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
        ;; +------------------------------------------------------------------+

*)
Interface

Uses
  Buttons,
  ComCtrls,
  Controls,
  ExtCtrls,
  Forms,
  Stdctrls,
  Classes
  ,
  DateUtils
  ;

//Uses Vetted 20090929:Dialogs, Graphics, Classes, Messages, Windows, SysUtils

Type
  TfrmDateRange = Class(TForm)
    LbDtFrom: Tlabel;
    LbDtTo: Tlabel;
    CalDtFrom: TDateTimePicker;
    CalDtTo: TDateTimePicker;
    PnlBottom: Tpanel;
    BitBtn1: TBitBtn;
    BitBtn2: TBitBtn;
    lbMaxRange: Tlabel;
    lbCurrentRange: Tlabel;
    Procedure calDtFromChange(Sender: Tobject);
    Procedure calDtToChange(Sender: Tobject);
    Procedure FormShow(Sender: Tobject);
  Private
    FRangeLimit: Integer;
    Function CheckFromDate: Boolean;
    Function CheckToDate: Boolean;
    Procedure CalDateToEditBoxes;
    Procedure CheckRangeLimit;
    Procedure ShowRanges;
    Function GetCurrentRange: Integer;
    Procedure FixRange(dtField: Integer);
    { Private declarations }
  Public
    Function Execute(Var Dtfrom, Dtto: String; rangelimit: Integer = 0): Boolean; { Public declarations }
    Procedure SetRangeLimit(Value: Integer);
  End;

Var
  FrmDateRange: TfrmDateRange;
Const
  dtfieldFROM = 1;
Const
  dtfieldTO = 2;

Implementation
Uses
  SysUtils
  ;

{$R *.DFM}

{ TfrmDateRange }

Function TfrmDateRange.Execute(Var Dtfrom, Dtto: String; rangelimit: Integer = 0): Boolean;
Begin
  FrmDateRange := TfrmDateRange.Create(Nil);
  FrmDateRange.SetRangeLimit(rangelimit);
  Try
    With FrmDateRange Do
    Begin
      If Dtfrom = '' Then
        Dtfrom := Formatdatetime('mm/dd/yyyy', Now);
      If Dtto = '' Then
        Dtto := Dtfrom;
      CalDtFrom.Date := Strtodate(Dtfrom);
      CalDtTo.Date := Strtodate(Dtto);

      Showmodal;
      If ModalResult = MrOK Then
      Begin
        Result := True;
        Dtfrom := Formatdatetime('mm/dd/yyyy', CalDtFrom.Date);
        Dtto := Formatdatetime('mm/dd/yyyy', CalDtTo.Date);
      End
      Else
        Result := False;
    End;
  Finally
    FrmDateRange.Free;
  End;
End;

Function TfrmDateRange.GetCurrentRange(): Integer;
Var
  Range: Integer;
  tdtfrom: TDate;
  tdtto: TDate;
Begin
  Result := 0;
  showranges;
  If Self.FRangeLimit = 0 Then
    Exit;
  tdtfrom := dateof(CalDtFrom.Date);
  tdtto := dateof(CalDtTo.Date);

  If tdtfrom = tdtto Then
    Range := 1
  Else
  Begin
    Range := daysBetween(tdtfrom, tdtto);
    Range := Range + 1;
  End;
  Result := Range;
End;

Procedure TfrmDateRange.FixRange(dtField: Integer);
Var
  tdtfrom, tdtto: TDate;
Begin
  tdtfrom := DateOf(Self.CalDtFrom.Date);
  tdtto := DateOf(Self.CalDtTo.Date);

  If Self.FRangeLimit = 0 Then Exit;
  If dtField = dtfieldFROM Then
  Begin
    If FRangeLimit = 1 Then
      CalDtTo.Date := tdtfrom
    Else
      CalDtTo.Date := Dateof(Incday(tdtfrom, FrangeLimit - 1));

  End;
  If dtField = dtfieldTO Then
  Begin
    If FRangeLimit = 1 Then
      CalDtFrom.Date := tdtTo
    Else
      CalDtFrom.Date := Dateof(Incday(tdtTo, -(FrangeLimit - 1)));
  End;
End;

Procedure TfrmDateRange.CalDateToEditBoxes;
Begin
End;

Function TfrmDateRange.CheckFromDate: Boolean;
Begin

End;

Function TfrmDateRange.CheckToDate: Boolean;
Begin
End;

Procedure TfrmDateRange.calDtFromChange(Sender: Tobject);
Begin
  If Self.FRangeLimit = 0 Then Exit;
  If GetCurrentRange > FRangeLimit Then
    Self.FixRange(dtfieldFROM);
  Self.ShowRanges;
End;

Procedure TfrmDateRange.calDtToChange(Sender: Tobject);
Begin
  If Self.FRangeLimit = 0 Then Exit;
  If GetCurrentRange > FRangeLimit Then
    Self.FixRange(dtfieldTO);
  ShowRanges;
End;

Procedure TfrmDateRange.SetRangeLimit(Value: Integer);
Var
  currange: Integer;
Begin
  Self.FRangeLimit := Value;
  showranges;
End;

Procedure TfrmDateRange.ShowRanges;
Var
  currange: Integer;
  tdtfrom: TDate;
  tdtto: TDate;
  dayval: String;
Begin
  lbMaxRange.Update;
  lbCurrentRange.Update;
  tdtfrom := dateof(CalDtFrom.Date);
  tdtto := dateof(CalDtTo.Date);
  If FRangeLimit = 0 Then
  Begin
    Self.lbMaxRange.caption := '';
    Self.lbCurrentRange.caption := '';
  End
  Else
  Begin
    If FRangeLimit = 1 Then
      dayval := ' Day.'
    Else
      dayval := ' Days.';
    Self.lbMaxRange.caption := 'Maximum Selectable Range: ' + Inttostr(FRangeLimit) + dayval;

    If tdtfrom = tdtto Then
      currange := 1
    Else
    Begin
      currange := daysBetween(tdtfrom, tdtto);
      currange := currange + 1;
    End;
    If currange = 1 Then
      dayval := ' Day.'
    Else
      dayval := ' Days.';
    Self.lbCurrentRange.caption := 'Selected Range: ' + Inttostr(currange) + dayval;
  End;
  lbMaxRange.Update;
  lbCurrentRange.Update;
End;

Procedure TfrmDateRange.CheckRangeLimit;
Begin

End;

Procedure TfrmDateRange.FormShow(Sender: Tobject);
Begin
  If Self.FRangeLimit = 0 Then
    Height := Height - 20
  Else
    If Self.GetCurrentRange > Self.FRangeLimit Then Self.FixRange(dtfieldFROM);
  ShowRanges;

End;

End.
