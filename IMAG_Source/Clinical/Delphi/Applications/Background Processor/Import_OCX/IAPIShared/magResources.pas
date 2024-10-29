Unit MagResources; {3.0_P8}
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
        ;; a Class I medical device.  As such, it may not be changed
        ;; in any way.  Modifications to this software may result in an
        ;; adulterated medical device under 21CFR820, the use of which
        ;; is considered to be a violation of US Federal Statutes.
        ;; +---------------------------------------------------------------------------------------------------+

*)
{$DEFINE NOVIEW} // returns flag to Clinical Workstation to block viewing
{DEFINE VIEW}// allows image viewing, but presents message where clinician acknowledges quality problem
{DEFINE NORESTRICT}// if defined, code doesn't block viewing of images
{DEFINE NOCHECK}// if defined, code doesn't do check for resources
{$DEFINE CW} // if defined, check results are logged (clinical workstation operation - VistA available)

Interface

Uses
  Windows,
  Messages,
  SysUtils,
  Classes,
  Graphics,
  Controls,
  Forms,
  Dialogs,
  Stdctrls,
  UMagClasses{$IFDEF CW},
  Magrclinws{$ENDIF};
Type
  TDisplayResources = Record
    ScrBitDepth: Integer;
    ScrPixelWidth: Integer;
    ScrPixelHeight: Integer;
    ThinClient: String;
    Grayscale: Boolean;
    GrayscaleChecked: Boolean;
  End;
Procedure GetColorDepth(Var CurResource: TDisplayResources); //(var bits : integer; var horzpixel : integer; var vertpixel : integer);
Procedure WarnResources(Magien: String);
Function RestrictView(IObj: TImageData): Integer;
Function CheckTerminalServer(Var CurResource: TDisplayResources): Integer;
Procedure CheckGrayscale(Var CurResource: TDisplayResources);
Function CreateWarning(Bits, ScrH, ScrV: Integer; WS, Mode: String): String;

Type
  TDGetNumScreens = Function(HDC: Integer; LpNumScreen: Integer): Integer;
  Stdcall;

// RAG P48T5 1024 > 1000 and 768 > 700
Const
  MinHorizontalRes = 1000;
  MinVerticalRes = 700;

Var
  SysResources: TDisplayResources;
  DGetNumScreens: TDGetNumScreens;

Implementation
Uses Math;

{function CheckTerminalServer: integer;}
{ func to get the current color depth of the video card. }

Procedure GetColorDepth(Var CurResource: TDisplayResources); //var bits : integer; var horzpixel : integer; var vertpixel : integer);
Var
  DeviceContents: HDC;
//  ColorDepth: Extended;
Begin
        {retrieves a handle of a display device context (DC) for the client area of the specified window}
  DeviceContents := GetDC(0);
        {retrieves device-specific information about a specified device}
           {BITSPIXEL = Number of adjacent color bits for each pixel.}
           {HORZRES = Width, in pixels, of the screen}
           {VERTRES = Height, in raster lines, of the screen}
  CurResource.ScrBitDepth := GetDeviceCaps(DeviceContents, BitsPixel) * GetDeviceCaps(DeviceContents, Planes);
  CurResource.ScrPixelWidth := GetDeviceCaps(DeviceContents, HORZRES);
  CurResource.ScrPixelHeight := GetDeviceCaps(DeviceContents, VERTRES);
//  ColorDepth := Power(2, bits);
  ReleaseDC(0, DeviceContents);
//  tmpstr := Format('%d Colors ', [Trunc(ColorDepth)]);
      (*  case bits of
          0: tmpstr := tmpstr + 'Unknown' + '(' + inttostr(horzpixel) + ',' + inttostr(vertpixel) + ')';
          1: tmpstr := tmpstr + 'MonoChrome' + '(' + inttostr(horzpixel) + ',' + inttostr(vertpixel) + ')';
          8: tmpstr := tmpstr + '256 Colors (8 bit)' + '(' + inttostr(horzpixel) + ',' + inttostr(vertpixel) + ')';
          16: tmpstr := tmpstr + 'HiColor (16 Bit)' + '(' + inttostr(horzpixel) + ',' + inttostr(vertpixel) + ')';
          24: tmpstr := tmpstr + 'TrueColor (24 Bit)' + '(' + inttostr(horzpixel) + ',' + inttostr(vertpixel) + ')';
          32: tmpstr := tmpstr + 'TrueColor (32 Bit)' + '(' + inttostr(horzpixel) + ',' + inttostr(vertpixel) + ')';
          64: tmpstr := tmpstr + 'UltraColor (64 Bit)' + '(' + inttostr(horzpixel) + ',' + inttostr(vertpixel) + ')';
        end;           *)
  If CurResource.ScrBitDepth = 0 Then CurResource.ScrBitDepth := 32;
End;

Procedure WarnResources(Magien: String);
Var
  Errmsg: String;
Begin
{$IFDEF NOCHECK}Exit;
{$ENDIF}
  GetColorDepth(SysResources);
  CheckTerminalServer(SysResources);

//CHECK FOR THINCLIENT
//IF SO, THEN DISPLAY WARNING AND LOG PARAMETERS
  If (((SysResources.ScrPixelWidth < MinHorizontalRes) Or (SysResources.ScrPixelHeight < MinVerticalRes)) Or (SysResources.ScrBitDepth < 24) Or (SysResources.ThinClient = 'TC')) Then
  Begin
    Errmsg := CreateWarning(SysResources.ScrBitDepth, SysResources.ScrPixelWidth, SysResources.ScrPixelHeight, SysResources.ThinClient, 'WARN');
    If (SysResources.ThinClient) = 'TC' Then // Only warn thin client users RAG 09/03/2003
      Messagedlg(Errmsg, MtWarning, [Mbok], 0); // +'^^'+MAGIEN);
{$IFDEF CW}LogWarning(False, 'SC_BAD^^' + Magien + '^^^^^^^' + Inttostr(SysResources.ScrPixelWidth) + '^' + Inttostr(SysResources.ScrPixelHeight) + '^' + Inttostr(SysResources.ScrBitDepth) + '^' +
      SysResources.ThinClient);
{$ENDIF}
    Exit;
  End; //+ '^^' + MAGIEN)
{$IFDEF CW}LogWarning(False, 'SCR_OK^^' + Magien + '^^^^^^^' + Inttostr(SysResources.ScrPixelWidth) + '^' + Inttostr(SysResources.ScrPixelHeight) + '^' + Inttostr(SysResources.ScrBitDepth) + '^' +
    SysResources.ThinClient);
{$ENDIF}
                                                                                                                                                                                                              //+ '^^' + MAGIEN)
End;

Function RestrictView(IObj: TImageData): Integer;
Var
  Message1 {, message2, message3, message4}, Temp: String;
  TC: Integer;
Begin
  Result := 0;
{$IFDEF NOCHECK}Exit;
{$ENDIF}
{$IFDEF NORESTRICT}Exit;
{$ENDIF}
{
  message1 := 'Not enough colors displayed on this workstation. Change your screen properties (see Screen Settings under Help Option) or call IRM.';
  message2 := 'Screen size is too small on this workstation. Change your screen properties (see Screen Settings under Help Option) or call IRM.';
  message3 := 'Only EKGs and documents can be viewed.';
  message4 := 'If you continue, you acknowledge that images are not full quality and will not be relied on for patient care decisions.  You may go to a full quality workstation or contact IRM to access one.';
}
{$IFDEF NOVIEW}
{
message1 := message1 + #10 + #13 + #10 + #13 + message3;
message2 := message2 + #10 + #13 + #10 + #13 + message3;
}
  Message1 := 'Attention: Set your display to a minimum of ' +
    '24 bit color and 1024 by 768 resolution to display ' +
    'this type of image.' +
    #10 + #13 + #10 + #13 +
    'Only EKGs and documents can be viewed with your ' +
    'current display setting.';
{$ENDIF}

{$IFDEF VIEW}Message1 := Message1 + #13 + #10 + #13 + #10 + Message4;
  Message2 := Message2 + #10 + #13 + #10 + #13 + Message4;
{$ENDIF}
  GetColorDepth(SysResources); // recheck this in case they're messing with their resolution
  TC := CheckTerminalServer(SysResources);

  If ((SysResources.ScrBitDepth < 24) Or (SysResources.ScrPixelWidth < MinHorizontalRes) Or (SysResources.ScrPixelHeight < MinVerticalRes)) Then
  Begin
    If (((IObj.ImgType <> 15) And (IObj.ImgType <> 11)) And (IObj.ImgType < 101)) Then
    Begin
      If (SysResources.ScrBitDepth < 24) Then
      Begin
        If (Not SysResources.GrayscaleChecked) Then
          CheckGrayscale(SysResources);
        If (SysResources.Grayscale = False) Then
        Begin
          Temp := Application.HelpFile;
          Application.HelpFile := ExtractFilePath(Application.ExeName) + 'MAGSCREEN.HLP';
          Messagedlg(Message1, MtWarning, [Mbok, MbHelp], 1);
          Application.HelpFile := Temp;
{$IFDEF NOVIEW}Result := 1;
{$ENDIF}
          Exit;
        End;
      End;
      If ((SysResources.ScrPixelWidth < MinHorizontalRes) Or (SysResources.ScrPixelHeight < MinVerticalRes)) Then
      Begin
        Temp := Application.HelpFile;
        Application.HelpFile := ExtractFilePath(Application.ExeName) + 'MAGSCREEN.HLP';
        Messagedlg(Message1, MtWarning, [Mbok, MbHelp], 1);
        Application.HelpFile := Temp;
{$IFDEF NOVIEW}Result := 1;
{$ENDIF}
        Exit;
      End;
    End;
        {quit if not a document or group}
  End;
End;

Function CreateWarning(Bits, ScrH, ScrV: Integer; WS, Mode: String): String;
{
var
ToDo, Bits1, Bits2, ScrRes1, ScrRes2 , TC1, TC2, PC1, DX1, Warn1, Warn2, Block1, Continue1, General1, DispProp: string;
bad: boolean;
}
Begin
  Result := 'Attention: This workstation uses a thin client configuration.' +
    #10 + #13 + #10 + #13 +
    'A thin client may not allow proper display of significant ' +
    'findings during window/level, brightness/contrast or zoom/pan ' +
    'image manipulation operations.' +
    #10 + #13 + #10 + #13 +
    'If you experience any of these problems, please go to a nearby ' +
    'non-thin client workstation or contact IRM to find one.';
End;

Function CheckTerminalServer(Var CurResource: TDisplayResources): Integer;
     // NOTE: need to add the following constant declaration in Windows.pas:

Const
  SM_REMOTESESSION = $1000;
Begin
  Result := 1; {not running on terminal server}
{     if (GetSystemMetrics(SM_REMOTESESSION)) <> 0 then result := 0;  keep}
  If (GetSystemMetrics(SM_REMOTESESSION)) <> 0 Then
    Result := 1
   //showmessage('Running on a terminal server')
    // App is running on a remote session, not a terminal server.
  Else
    Result := 0;
  CurResource.ThinClient := 'PC';
  If Result = 1 Then CurResource.ThinClient := 'TC';
    // App is running on the console.
End;

Procedure CheckGrayscale(Var CurResource: TDisplayResources);
Var
  DC: HDC;
  BMP: TBitmap;
  i, j: Integer;
  Color: TColor;
Begin
  CurResource.Grayscale := True;
  Application.MainForm.SetFocus();
  DC := GetDC(GetForegroundWindow);
  Try
    BMP := TBitmap.Create();
    BMP.Width := Application.MainForm.Width;
    BMP.Height := Application.MainForm.Height;
    BitBlt(BMP.Canvas.Handle, 0, 0, BMP.Width,
      BMP.Height, DC, 0, 0, SRCCOPY);
    For i := 0 To BMP.Width - 1 Do
    Begin
      For j := 0 To BMP.Height - 1 Do
      Begin
        Color := BMP.Canvas.Pixels[i, j];
        If ((GetRValue(Color) <> GetGValue(Color))
          Or (GetGValue(Color) <> GetBValue(Color))) Then
        Begin
          CurResource.Grayscale := False;
          Break;
        End;
      End;
      If (CurResource.Grayscale = False) Then
        Break;
    End;
    CurResource.GrayscaleChecked := True;
  Finally
    ReleaseDC(GetDesktopWindow, DC);
  End;
End;

End.
