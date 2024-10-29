Unit MagTimeout;
   {
   Package: MAG - VistA Imaging
   WARNING: Per VHA Directive 10-93-142 this unit should not be modified.
   Date Created:      2000
   Site Name: Silver Spring, OIFO
   Developers: Garrett Kirin
   Description: Imaging Capture TimeOut Form.
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
  SysUtils,
  Windows,
  Messages,
  Classes,
  Graphics,
  Controls,
  Stdctrls,
  ExtCtrls,
  Forms,
  ComCtrls,
  ToolWin,
  Buttons,
  Dialogs,
  ImgList,
  UMagDefinitions,
  Umagutils8,
  imaginterfaces
  ;
(*type
  AppTypes = (appDisplay, appCapture);*)
Type
  TMagTimeoutform = Class(TForm)
    bOK: TButton;
    bCancel: TButton;
    LbDisplay: Tlabel;
    ImageDisplay: TImage;
    Label2: Tlabel;
    LbSeconds: Tlabel;
    Timer1: TTimer;
    ImageList1: TImageList;
    ImageCapture: TImage;
    LbCapture: Tlabel;
    Image1: TImage;
    ImageTeleReader: TImage;
    LblTeleReader: Tlabel;
    Procedure Timer1Timer(Sender: Tobject);
    Procedure FormPaint(Sender: Tobject);
    Procedure bCancelClick(Sender: Tobject);
    Procedure bOKClick(Sender: Tobject);
    Procedure FormActivate(Sender: Tobject);
    Procedure ToolButton1Click(Sender: Tobject);
    Procedure FormCreate(Sender: Tobject);
    Procedure FormDestroy(Sender: Tobject);

  Private
    Seconds: byte;
    Xbitmap: TBitmap;

    Procedure Setseconds(Sec: byte);
    procedure checkform;

  Public

    Procedure Setapplication(AppType: TMagApplicationTypes);
    Procedure SetApplicationTimeOut(Minutes: String; AppTimer: TTimer);

  End;

Var
  MagTimeoutform: TMagTimeoutform;
Const
  Timeout: byte = 31; // 31
Implementation

Uses
  Maggut1;

{$R *.DFM}

procedure TMagTimeOutForm.checkform();
begin
  if not doesformexist('MagTimeoutform') then application.CreateForm(TMagTimeoutform,MagTimeoutform);
end;

Procedure TMagTimeoutform.Setapplication(AppType: TMagApplicationTypes);
Begin
CheckForm();


  Case AppType Of
    MagappDisplay:
      Begin
        LbDisplay.BringToFront;
        ImageDisplay.BringToFront;
      End;
    MagappCapture:
      Begin
        LbCapture.BringToFront;
        ImageCapture.BringToFront;
      End;
    MagappTeleReader:
      Begin
        LblTeleReader.BringToFront;
        ImageTeleReader.BringToFront;
      End;
  Else
    Begin
      LbDisplay.BringToFront;
      ImageDisplay.BringToFront;
    End;

  End;
End;

Procedure TMagTimeoutform.Timer1Timer(Sender: Tobject);
Begin
  Dec(Seconds);
  MagAppMsg('s', 'SECONDS  : ' + Inttostr(Seconds));
  If Seconds = 0 Then
  Begin
    Timer1.Enabled := False;
    ModalResult := MrOK
  End
  Else
  Begin
    LbSeconds.caption := Inttostr(Seconds) + '  seconds';
    ImageList1.GetBitmap(Seconds, Xbitmap);
    Image1.Picture.Bitmap := Xbitmap;
    If Seconds < 10 Then Messagebeep(0);
    If ((Seconds >= 10) And ((Seconds Mod 5) = 0)) Then Messagebeep(0);
  End;
  Application.BringToFront;
End;

Procedure TMagTimeoutform.FormPaint(Sender: Tobject);
Begin
  Timer1.Enabled := True;
End;

Procedure TMagTimeoutform.bCancelClick(Sender: Tobject);
Begin
  Timer1.Enabled := False;
  Setseconds(Timeout);
End;

Procedure TMagTimeoutform.bOKClick(Sender: Tobject);
Begin
  Timer1.Enabled := False;
  Setseconds(Timeout);
End;

Procedure TMagTimeoutform.Setseconds(Sec: byte);
Begin
  Seconds := Sec;
  LbSeconds.caption := Inttostr(Sec) + '  seconds';
  ImageList1.GetBitmap(Seconds, Xbitmap);
  Image1.Picture.Bitmap := Xbitmap;
End;

Procedure TMagTimeoutform.FormActivate(Sender: Tobject);
Begin
  Setseconds(Timeout);
  bCancel.SetFocus;
End;

Procedure TMagTimeoutform.ToolButton1Click(Sender: Tobject);
Begin
  Setseconds(Timeout);
End;

Procedure TMagTimeoutform.FormCreate(Sender: Tobject);
Begin
  Xbitmap := TBitmap.Create;
End;

Procedure TMagTimeoutform.FormDestroy(Sender: Tobject);
Begin
  Xbitmap.Free;
End;

Procedure TMagTimeoutform.SetApplicationTimeOut(Minutes: String; AppTimer: TTimer);
Var
  s: String;
  Int: Longint;
  r: Real;
Begin
CheckForm();
  r := ((AppTimer.Interval / 1000) / 60);
  If Minutes = '' Then
    s := InputBox('Change TimeOut Value', 'Enter # of Minutes : ', Copy(FloatTostr(r), 1, 4))
  Else
    s := Minutes;
  Try
    r := Strtofloat(s);
    Int := Trunc(r * 60 * 1000);
    If (Int < 5000) Then Int := 5000;
    AppTimer.Enabled := False;
    AppTimer.Interval := Int;
    AppTimer.Enabled := True;
  Except
    Messagedlg('InValid entry : ' + s, Mtconfirmation, [Mbok], 0);
  End;

End;

End.
