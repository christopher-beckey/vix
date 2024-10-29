Unit FmagDateTimeDialog;

Interface

Uses
  Buttons,
  ComCtrls,
  ExtCtrls,
  Forms,
  Stdctrls,
  Windows,
  Graphics,
  Controls,
  Classes
  ;

  //p106 rlm CR 531 Numerous modifications were made to this unit to address 508 navigation issues

Type
  TfrmDateTimeDialog = Class(TForm)
    btncancel: TBitBtn;
    btnHelp: TBitBtn;
    btnOK: TBitBtn;
    cal: TMonthCalendar;
    edtTime: TEdit;
    Image1: TImage;
    Image2: TImage;
    Label2: TLabel;
    lbampm: TLabel;
    lbampm2: TLabel;
    lbDate: TLabel;
    lbTime: TLabel;
    lstHour: TListBox;
    lstMin: TListBox;
    pnlBase: TPanel;
    pnlBaseBot: TPanel;
    pnlBaseBotButtons: TPanel;
    pnlBaseTop: TPanel;
    pnlCalTop: TPanel;
    pnlMonthBase: TPanel;
    pnlMonthLeft: TPanel;
    pnlMonthRight: TPanel;
    pnlNewDate: TPanel;
    pnlNewDateBase: TPanel;
    pnlTime: TPanel;
    pnlTimeAmPm: TPanel;
    pnlTimeBotBase: TPanel;
    trckbarHour: TTrackBar;
    trckbarMin: TTrackBar;
    procedure btnHelpClick(Sender: TObject);
    Procedure CalClick(Sender: Tobject);
    Procedure EdtTimeChange(Sender: Tobject);
    procedure FormKeyDown(Sender: TObject; var Key: Word; Shift: TShiftState);
    Procedure Image1Click(Sender: Tobject);
    Procedure Image2Click(Sender: Tobject);
    Procedure LstHourClick(Sender: Tobject);
    Procedure LstMinClick(Sender: Tobject);
    procedure pnlNewDateBaseResize(Sender: TObject);
    Procedure TrckbarHourChange(Sender: Tobject);
    Procedure TrckbarMinChange(Sender: Tobject);
    procedure FormCreate(Sender: TObject);
  Protected
    FDateTime: TDateTime;
    FHrMove  : Boolean;
    FignHour : Boolean;
    FignMin  : Boolean;
    FMinMove : Boolean;
    Procedure SetDate(Vdate: String);
    Procedure SetTime(VTime: String);
  Public
    Function Execute(Pt: TPoint; Var VDateTime: String; Var DDateTime: Tdatetime): Boolean; Overload;
    Function Execute(Var VDateTime: String; Var DDateTime: Tdatetime): Boolean; Overload;
    Function ParseDate(Str, Del: String; Piece: Integer): String;
    Function NextMonth(Date: TDateTime): TDateTime;
    Function NextYear(Date: TDateTime): TDateTime;
    Function PriorMonth(Date: TDateTime): TDateTime;
    Function PriorYear(Date: TDateTime): TDateTime;
  End;

Var
  FrmDateTimeDialog: TfrmDateTimeDialog;

Implementation
Uses
  Dialogs,
  SysUtils;

{$R *.DFM}

Function TfrmDateTimeDialog.Execute(Var VDateTime: String; Var DDateTime: Tdatetime): Boolean;
Var
  Vpt: TPoint;
Begin
  Vpt.x := 0;
  Vpt.y := 0;
  Result := Execute(Vpt, VDateTime, DDateTime);
End;

Function TfrmDateTimeDialog.Execute(Pt: TPoint; Var VDateTime: String; Var DDateTime: Tdatetime): Boolean;
Begin
  Application.CreateForm(TfrmDateTimeDialog, FrmDateTimeDialog);
  If Pt.x > 0 Then
  Begin
    With FrmDateTimeDialog Do
    Begin
      Left := Pt.x + 5;
      If Left > Screen.Width Then Left := Screen.Width - Width;
      Top := Pt.y - (Height Div 2);
      If Top < 0 Then Top := 5;
    End;
  End;
  With FrmDateTimeDialog Do
  Begin
    If VDateTime = '' Then
    Begin
      FDateTime := Now;
      SetDate(Formatdatetime('mm/dd/yyyy', FDateTime));
      SetTime(Formatdatetime('hh:mm', FDateTime));
    End
    Else
    Begin
      SetDate(ParseDate(VDateTime, '@', 1));
      SetTime(ParseDate(VDateTime, '@', 2));
      Try
        FDateTime:=Strtodatetime(LbDate.caption + ' ' + LbTime.caption);
      Except
        FDateTime:=now();
        SetDate(Formatdatetime('mm/dd/yyyy', FDateTime));
        SetTime(Formatdatetime('hh:mm', FDateTime));
      End;
    End;
    Showmodal;
    If LbTime.caption = '00:00' Then
      VDateTime := LbDate.caption
    Else
      VDateTime := LbDate.caption + '@' + LbTime.caption;
    DDateTime := Strtodatetime(LbDate.caption + ' ' + LbTime.caption);
    Result := ModalResult = MrOK;
  End;
End;

procedure TfrmDateTimeDialog.FormKeyDown(Sender: TObject; var Key: Word;
  Shift: TShiftState);
begin
  If Shift=[ssAlt] Then
  Begin
    If (Key=Ord('Y')) Or (Key=Ord('y')) Then
    Begin
      Cal.Date:=NextYear(Cal.Date);
      SetDate(Formatdatetime('mm/dd/yyyy', Cal.Date));
      Key:=Ord(#0);
    End
    Else
    If (Key=Ord('M')) Or (Key=Ord('m')) Then
    Begin
      Cal.Date:=NextMonth(Cal.Date);
      SetDate(Formatdatetime('mm/dd/yyyy', Cal.Date));
      Key:=Ord(#0);
    End
    Else
    If (Key=Ord('D')) Or (Key=Ord('d')) Then
    Begin
      Cal.Date:=Cal.Date+1;
      SetDate(Formatdatetime('mm/dd/yyyy', Cal.Date));
      Key:=Ord(#0);
    End
    Else
    If (Key=Ord('W')) Or (Key=Ord('w')) Then
    Begin
      Cal.Date:=Cal.Date+7;
      SetDate(Formatdatetime('mm/dd/yyyy', Cal.Date));
      Key:=Ord(#0);
    End
    Else
    If (Key=Ord('H')) Or (Key=Ord('h')) Then
    Begin
      FDateTime:=FDateTime+(1/24);
      SetDate(Formatdatetime('mm/dd/yyyy', FDateTime));
      SetTime(Formatdatetime('hh:mm', FDateTime));
      Key:=Ord(#0);
    End
    Else
    If (Key=Ord('N')) Or (Key=Ord('n')) Then
    Begin
      FDateTime:=FDateTime+((1/24)*(1/12));
      SetDate(Formatdatetime('mm/dd/yyyy', FDateTime));
      SetTime(Formatdatetime('hh:mm', FDateTime));
      Key:=Ord(#0);
    End;
  End;
  If Shift=[ssCtrl] Then
  Begin
    If (Key=Ord('Y')) Or (Key=Ord('y')) Then
    Begin
      Cal.Date:=PriorYear(Cal.Date);
      SetDate(Formatdatetime('mm/dd/yyyy', Cal.Date));
      Key:=Ord(#0);
    End
    Else
    If (Key=Ord('M')) Or (Key=Ord('m')) Then
    Begin
      Cal.Date:=PriorMonth(Cal.Date);
      SetDate(Formatdatetime('mm/dd/yyyy', Cal.Date));
      Key:=Ord(#0);
    End
    Else
    If (Key=Ord('D')) Or (Key=Ord('d')) Then
    Begin
      Cal.Date:=Cal.Date-1;
      SetDate(Formatdatetime('mm/dd/yyyy', Cal.Date));
      Key:=Ord(#0);
    End
    Else
    If (Key=Ord('W')) Or (Key=Ord('w')) Then
    Begin
      Cal.Date:=Cal.Date-7;
      SetDate(Formatdatetime('mm/dd/yyyy', Cal.Date));
      Key:=Ord(#0);
    End
    Else
    If (Key=Ord('H')) Or (Key=Ord('h')) Then
    Begin
      FDateTime:=FDateTime-(1/24);
      SetDate(Formatdatetime('mm/dd/yyyy', FDateTime));
      SetTime(Formatdatetime('hh:mm', FDateTime));
      Key:=Ord(#0);
    End
    Else
    If (Key=Ord('N')) Or (Key=Ord('n')) Then
    Begin
      FDateTime:=FDateTime-((1/24)*(1/12));
      SetDate(Formatdatetime('mm/dd/yyyy', FDateTime));
      SetTime(Formatdatetime('hh:mm', FDateTime));
      Key:=Ord(#0);
    End;
  End;
end;

Procedure TfrmDateTimeDialog.TrckbarHourChange(Sender: Tobject);
Var
  S1, S2: String;
  Hr: Integer;
Begin
  If FignHour Then
  Begin
    FignHour := False;
    Exit;
  End;
  If Not FMinMove Then
    FHrMove := True
  Else
    Exit;
  TrckbarMin.Position := TrckbarHour.Position Mod 12;
  LstMin.ItemIndex := TrckbarMin.Position;
  Hr := TrckbarHour.Position Div 12;
  LstHour.ItemIndex := Hr;
  S1 := Inttostr(TrckbarHour.Position Div 12);
  S2 := Inttostr(TrckbarMin.Position * 5);

  If Length(S1) = 1 Then S1 := '0' + S1;
  If Length(S2) = 1 Then S2 := '0' + S2;

  LbTime.caption := S1 + ':' + S2;
  FHrMove := False;
  LbTime.Update;
  EdtTime.Text := LbTime.caption;
End;

Procedure TfrmDateTimeDialog.TrckbarMinChange(Sender: Tobject);
Var
  S1, S2: String;
  I1, Hr: Integer;
Begin
  If FignMin Then
  Begin
    FignMin := False;
    Exit;
  End;
  If Not FHrMove Then
    FMinMove := True
  Else
    Exit;
  I1 := (TrckbarHour.Position Div 12) * 12;
  Hr := I1 Div 12;
  LstHour.ItemIndex := Hr;
  LstHour.Update;
  S1 := Inttostr(I1 Div 12);
  LstMin.ItemIndex := TrckbarMin.Position;
  TrckbarHour.Position := TrckbarMin.Position + I1;

  S2 := Inttostr(TrckbarMin.Position * 5);

  If Length(S1) = 1 Then S1 := '0' + S1;
  If Length(S2) = 1 Then S2 := '0' + S2;
  LbTime.caption := S1 + ':' + S2;
  FMinMove := False;
  LbTime.Update;
  EdtTime.Text := LbTime.caption;
End;

Procedure TfrmDateTimeDialog.Image2Click(Sender: Tobject);
Begin
  Cal.Date := Now;
  SetDate(Formatdatetime('mm/dd/yyyy', Now));
  SetTime(Formatdatetime('hh:mm', Now));
End;

procedure TfrmDateTimeDialog.btnHelpClick(Sender: TObject);
Var
  sgMsg: String;
begin
  sgMsg:=
    'The following keystrokes can'+#13+#10+
    'be used to navigate dates:'+#13+#10+
    ''+#13+#10+
    'Next Year   '+#9+': Alt-Y'+#13+#10+
    'Next Month  '+#9+': Alt-M'+#13+#10+
    'Next Day    '+#9+': Alt-D'+#13+#10+
    'Next Week   '+#9+': Alt-W'+#13+#10+
    'Next Hour   '+#9+': Alt-H'+#13+#10+
    'Next 5 Min  '+#9+': Alt-N'+#13+#10+
    'Prior Year  '+#9+': Ctrl-Y'+#13+#10+
    'Prior Month '+#9+': Ctrl-M'+#13+#10+
    'Prior Day   '+#9+': Ctrl-D'+#13+#10+
    'Prior Week  '+#9+': Ctrl-W'+#13+#10+
    'Prior Hour  '+#9+': Ctrl-H'+#13+#10+
    'Prior 5 Min '+#9+': Ctrl-N'+#13+#10;
   messagedlg(sgMsg, Mtconfirmation, [Mbok], 0);
end;

Procedure TfrmDateTimeDialog.CalClick(Sender: Tobject);
// works okay, not needed here
//var dtcmp : TValueRelationship;
Begin

//dtcmp := CompareDate(now,cal.date);

  SetDate(Formatdatetime('mm/dd/yyyy', Cal.Date));
//SetTime('00:00');
End;

Procedure TfrmDateTimeDialog.Image1Click(Sender: Tobject);
Begin
//cal.Date := now;
//SetDate(formatdatetime('mm/dd/yyyy',now));
  SetTime('23:59'); //formatDateTime('hh:mm',now);
End;

Procedure TfrmDateTimeDialog.SetDate(Vdate: String);
Begin
  LbDate.caption := Vdate;
  If Vdate <> '' Then Cal.Date := Strtodate(Vdate);
End;

Procedure TfrmDateTimeDialog.SetTime(VTime: String);
Var
  Hr, Min: String;
//hrii : string;
  Minii: Integer;
Begin
  If VTime = '' Then VTime := '00:00';
  LbTime.caption := VTime;
  EdtTime.Text := VTime;
  Hr := ParseDate(VTime, ':', 1);
  If Pos('0', Hr) = 1 Then Hr := Copy(Hr, 2, 99);
  If LstHour.Items.Indexof(Hr) = -1 Then Hr := '0';

  //hrii :=
  LstHour.ItemIndex := LstHour.Items.Indexof(Hr);
  FignHour := True;
  TrckbarHour.Position := LstHour.ItemIndex * 12;

  Min := ParseDate(VTime, ':', 2);
  If Pos('0', Min) = 1 Then Min := Copy(Min, 2, 99);
  Minii := Strtoint(Min) Div 5;

  If Minii <> TrckbarMin.Position Then
  Begin
    LstMin.ItemIndex := Minii;
    FignMin := True;
    TrckbarMin.Position := Minii;
  End;
 // if lstMin.Items.IndexOf(min) > -1 then
  //  begin
     ////hrii :=
  //   lstMin.ItemIndex := lstMin.Items.IndexOf(min);
  //   end;

End;

Procedure TfrmDateTimeDialog.LstHourClick(Sender: Tobject);
Var
  Hri: Integer;
//    hrs : string;
Begin
  Hri := LstHour.ItemIndex;
  TrckbarHour.Position := Hri * 12;
  TrckbarMin.Position := TrckbarMin.Min;

End;

Procedure TfrmDateTimeDialog.LstMinClick(Sender: Tobject);
Var
  Mini: Integer;
Begin
  Mini := LstMin.ItemIndex;
  TrckbarMin.Position := Mini;

End;

procedure TfrmDateTimeDialog.pnlNewDateBaseResize(Sender: TObject);
begin
  pnlNewDate.Align:=alNone;
  pnlNewDate.Left:=(pnlNewDateBase.Width-pnlNewDate.Width) div 2;
  pnlNewDate.Top:=2;
end;

Procedure TfrmDateTimeDialog.EdtTimeChange(Sender: Tobject);
Var
  ap, Hrs: String;
  Hri: Integer;
Begin
  Hrs := ParseDate(EdtTime.Text, ':', 1);
  Try
    Hri := Strtoint(Hrs);
  Except
    Hri := 0;
  End;

  If Hri > 12 Then
  Begin
    ap := ' pm';
    Hri := Hri Mod 12;
  End
  Else
    ap := ' am';

  Lbampm.caption := '( ' + Inttostr(Hri) + ':' + ParseDate(EdtTime.Text, ':', 2) + ap + ' )';
  Lbampm2.caption := Lbampm.caption;

End;

function TfrmDateTimeDialog.NextMonth(Date: TDateTime): TDateTime;
Var
  sgMM  : String;
  sgDD  : String;
  sgYYYY: String;
  inMM  : Integer;
begin
  Try
    sgMM  := FormatDateTime('MM',Date);
    sgDD  := FormatDateTime('DD',Date);
    sgYYYY:= FormatDateTime('YYYY',Date);
    inMM  := StrToInt(sgMM);
    inMM  := inMM+1;
    If inMM>12 Then inMM:=1;
    sgMM:= IntToStr(inMM);
    If inMM<10 Then sgMM:='0'+sgMM;
    Result:= StrToDateTime(sgMM+'/'+sgDD+'/'+sgYYYY);
  Except
    Result:=Date+30;
  End;
end;

function TfrmDateTimeDialog.NextYear(Date: TDateTime): TDateTime;
Var
  sgMM  : String;
  sgDD  : String;
  sgYYYY: String;
  inYYYY: Integer;
begin
  Try
    sgMM  := FormatDateTime('MM',Date);
    sgDD  := FormatDateTime('DD',Date);
    sgYYYY:= FormatDateTime('YYYY',Date);
    inYYYY:= StrToInt(sgYYYY);
    inYYYY:= inYYYY+1;
    sgYYYY:= IntToStr(inYYYY);
    Result:= StrToDateTime(sgMM+'/'+sgDD+'/'+sgYYYY);
  Except
    Result:=Date+365;
  End;
end;

function TfrmDateTimeDialog.PriorMonth(Date: TDateTime): TDateTime;
Var
  sgMM  : String;
  sgDD  : String;
  sgYYYY: String;
  inMM  : Integer;
begin
  Try
    sgMM  := FormatDateTime('MM',Date);
    sgDD  := FormatDateTime('DD',Date);
    sgYYYY:= FormatDateTime('YYYY',Date);
    inMM  := StrToInt(sgMM);
    inMM  := inMM-1;
    If inMM<1 Then inMM:=12;
    sgMM:= IntToStr(inMM);
    If inMM<10 Then sgMM:='0'+sgMM;
    Result:= StrToDateTime(sgMM+'/'+sgDD+'/'+sgYYYY);
  Except
    Result:=Date-30;
    If FormatDateTime('MM',Result)<>FormatDateTime('MM',Date) Then Exit;
    Result:=Result-1;
    If FormatDateTime('MM',Result)<>FormatDateTime('MM',Date) Then Exit;
    Result:=Result-1;
  End;
end;

function TfrmDateTimeDialog.PriorYear(Date: TDateTime): TDateTime;
Var
  sgMM  : String;
  sgDD  : String;
  sgYYYY: String;
  inYYYY: Integer;
begin
  Try
    sgMM  := FormatDateTime('MM',Date);
    sgDD  := FormatDateTime('DD',Date);
    sgYYYY:= FormatDateTime('YYYY',Date);
    inYYYY:= StrToInt(sgYYYY);
    inYYYY:= inYYYY-1;
    sgYYYY:= IntToStr(inYYYY);
    Result:= StrToDateTime(sgMM+'/'+sgDD+'/'+sgYYYY);
  Except
    Result:=Date-365;
  End;
end;

function TfrmDateTimeDialog.ParseDate(Str, Del: String; Piece: Integer): String;
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

procedure TfrmDateTimeDialog.FormCreate(Sender: TObject);
begin
  FDateTime:= now();
end;

End.
