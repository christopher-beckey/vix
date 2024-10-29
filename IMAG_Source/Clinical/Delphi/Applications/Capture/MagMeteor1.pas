{'''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''
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
'
' MGrabContinuous:
'   This examples demonstrates how to start and stop a live video steam
'   in an ActiveMIL display.
'
'   The following properties were set at design-time:
'       Buffer.CanGrab := True
'       Buffer.CanDisplay := True
'
'''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''}
Unit MagMeteor1;

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
  OleCtrls,
  ComCtrls,
  Registry,
  MIL_TLB,
  ToolWin,
  Maggut1;

Type
  TMagMeteorForm1 = Class(TForm)
    bSizing: TButton;
    Display: TDisplay;
    Digitizer: TDigitizer;
    CommentText: TMemo;
    CommentFrame: Tlabel;
    System: TSystem;
    ToolBar1: TToolBar;
    TbFreeze: TToolButton;
    TbOK: TToolButton;
    TbExit: TToolButton;
    ToolButton1: TToolButton;
    NextButton: TButton;
    MilImage1: TMilImage;
    Procedure FormActivate(Sender: Tobject);
    Procedure NextButtonClick(Sender: Tobject);
    Procedure TbFreezeClick(Sender: Tobject);
    Procedure TbOKClick(Sender: Tobject);
    Procedure TbExitClick(Sender: Tobject);
    Procedure FormCreate(Sender: Tobject);
    Procedure FormClose(Sender: Tobject; Var action: TCloseAction);
    Procedure NextButtonKeyDown(Sender: Tobject; Var Key: Word;
      Shift: TShiftState);
    Procedure DisplayClick(Sender: Tobject);
  Private
    Procedure AcceptTheImage;
    //function GetRegistryValue: string;
    Procedure GetRegistryValues(Var MilSystype, MilSysDeviceNumber,
      MilSizeX, MilSizeY, MilNumberofBands,
      MilDeviceNumber, MilFormat: String);
  Public
    Procedure AdjustForm;

    Function GetPath: String;
  End;

Var
  MagMeteorForm1: TMagMeteorForm1;
  StepNumber: Integer = 0;
  Meteorfilename: String;
  Tempdir: String;
Implementation

Uses FmagCapMain
  ;
{$R *.DFM}

Procedure TMagMeteorForm1.FormActivate(Sender: Tobject);
Var
  MilSystype, MilSysDeviceNumber: String;
  MilSizeX, MilSizeY, MilNumberofBands: String;
  MilDeviceNumber, MilFormat: String;
Begin
  TbFreeze.Down := False;

   //only do this stuff if the driver is not allocated.
  If System.IsAllocated = False Then
  Begin

    Display.Visible := False;
    MilImage1.Visible := False;
    Digitizer.Visible := False;
    System.Visible := False;
    NextButton.Visible := False;

//     ShowWindow(Handle, SW_SHOW);  //force window to show
    GetRegistryValues(MilSystype, MilSysDeviceNumber,
      MilSizeX, MilSizeY, MilNumberofBands,
      MilDeviceNumber, MilFormat);

     // Check values from registry to determine if data was read (JMW 1124/2003)
    If (MilSystype <> '') And (MilSizeX <> '') And (MilSizeY <> '') And (MilNumberofBands <> '') And (MilDeviceNumber <> '') And (MilFormat <> '') Then
    Begin

      System.SystemType := MilSystype;
      System.DeviceNumber := Strtoint(MilSysDeviceNumber);
      MilImage1.NumberOfBands := Strtoint(MilNumberofBands);
      MilImage1.SizeX := Strtoint(MilSizeX);
      MilImage1.SizeY := Strtoint(MilSizeY);
      Digitizer.DeviceNumber := Strtoint(MilDeviceNumber);
      Digitizer.Format := MilFormat;

      Screen.Cursor := crHourGlass;
      Frmcapmain.WinMsg('', 'Loading Capture Window... Please Wait...');
      System.Allocate;
      Frmcapmain.WinMsg('', 'Loading Capture Window... Please Wait.......');
      MilImage1.Allocate;
      Frmcapmain.WinMsg('', 'Loading Capture Window... Please Wait.............');
      Digitizer.Allocate;
      Frmcapmain.WinMsg('', 'Loading Capture Window... Please Wait..................');
      Display.Allocate;
      Display.Visible := True;
      NextButton.Visible := True;
      MagMeteorForm1.caption := 'VistA Imaging Capture';
      Screen.Cursor := crDefault;
    End
    Else
     // if a value wasn't read from the registry, output an error message (JMW 11/24/2003)
    Begin
      Showmessage('A null ActiveMIL value was read from the registry');
       // something should be added here to gracefully close the meteor capture window
    End;

  End;

  // Adjust the form and display sizes.
  AdjustForm;

  // Step 1: grab continuously.
  Digitizer.GrabContinuous;

  // Adjust the step number and associated text.
  StepNumber := 1;
  CommentFrame.caption := 'Step ' + Inttostr(StepNumber) + ':';
  CommentText.Lines[0] := 'Continuous grab in progress.  Adjust your camera ' +
    'and click Freeze or Next to stop grabbing.';
End;

Procedure TMagMeteorForm1.NextButtonClick(Sender: Tobject);
Begin
  // Adjust the step number and associated text.
  StepNumber := StepNumber + 1;
  CommentFrame.caption := 'Step ' + Inttostr(StepNumber) + ':';

  Case StepNumber Of
    // Step 2: stop the digitizer.
    2:
      Begin
        Digitizer.Halt;
        CommentText.Lines[0] := 'Displaying the last grabbed image.  ' +
          'Click Next or Image OK to end.  Click Freeze to resume.';
        TbFreeze.Down := True;
      End;

    // Step 3: end the application.
    3:
      TbOKClick(Self);
  End;
End;

Procedure TMagMeteorForm1.TbFreezeClick(Sender: Tobject);
Begin
  If TbFreeze.Down Then
  Begin
    Digitizer.Halt;
    StepNumber := 2;
    CommentFrame.caption := 'Step ' + Inttostr(StepNumber) + ':';
    CommentText.Lines[0] := 'Displaying the last grabbed image.  ' +
      'Click Image OK or Next button to end.  Click Freeze to resume.';
  End
  Else
  Begin
    Digitizer.GrabContinuous;
    StepNumber := 1;
    CommentFrame.caption := 'Step ' + Inttostr(StepNumber) + ':';
        //tbFreeze.Caption := '&Freeze';
    CommentText.Lines[0] := 'Continuous grab in progress.  Adjust your camera ' +
      'and click Freeze or Next stop grabbing.';
  End;
End;

Procedure TMagMeteorForm1.TbOKClick(Sender: Tobject);
Begin
  If TbFreeze.Down = False Then
  Begin
    TbFreeze.Down := True;
    TbFreezeClick(Self);
      //tbFreeze.Caption := '&Freeze';
    TbFreeze.Down := False;
  End;
  MilImage1.Save(Meteorfilename);
  AcceptTheImage;
End;

Procedure TMagMeteorForm1.TbExitClick(Sender: Tobject);
Begin
  Frmcapmain.WinMsg('', '');
  Close;
End;

Procedure TMagMeteorForm1.AcceptTheImage;
Begin
  Frmcapmain.LoadGear(Meteorfilename, Meteorfilename);
  Frmcapmain.CaptureIsValid;
  TbFreezeClick(Self);
End;

Procedure TMagMeteorForm1.FormCreate(Sender: Tobject);
Begin
     // gek 04/13/00  changed .tif to .jpg  We show the Doc controls if the image is .tif.
  Meteorfilename := Tempdir + 'scantemp.tga';
End;

Procedure TMagMeteorForm1.AdjustForm;
Var
  MaxDisplayWidth, MaxNextStepWidth: Integer;
  Display: TDisplay;
  Digitizer: TDigitizer;
  NextButton: TButton;
  CommentText: TMemo;
Begin
  // Position the form in the top left corner
  //
  Top := 0;
  Left := 0;

  // Find the necessary components
  Display := TDisplay(FindComponent('Display'));
  Digitizer := TDigitizer(FindComponent('Digitizer'));
  NextButton := TButton(FindComponent('NextButton'));
  CommentText := TMemo(FindComponent('CommentText'));

  If (Display = Nil) Or
    (Digitizer = Nil) Or
    (NextButton = Nil) Or
    (CommentText = Nil) Then Exit;

  Display.Width := Round(Digitizer.SizeX * Digitizer.ScaleX);
  Display.Height := Round(Digitizer.SizeY * Digitizer.ScaleY);

  MaxDisplayWidth := Display.Width + (2 * Display.Left);
  MaxNextStepWidth := NextButton.Left + NextButton.Width + CommentText.Left;

  If MaxNextStepWidth > MaxDisplayWidth Then
    ClientWidth := MaxNextStepWidth
  Else
    ClientWidth := MaxDisplayWidth;

  ClientHeight := Display.Left + Display.Height + Display.Top;

  // Force Delphi to show the window before the allocation of displayable Buffer.
  //
  ShowWindow(Handle, SW_SHOW);

  NextButton.SetFocus;
End;

Function TMagMeteorForm1.GetPath: String;
Var
  Temp: Array[0..511] Of Char;
  Slash: PChar;
Begin
  Strpcopy(Temp, Forms.Application.ExeName);
  Slash := StrRScan(Temp, '\');
  StrLCopy(Temp, Temp, (Slash - Temp));
  Result := Strpas(Temp);
End;

Procedure TMagMeteorForm1.FormClose(Sender: Tobject;
  Var action: TCloseAction);
Begin
  If Digitizer.IsAllocated Then Digitizer.Halt;
  Forms.Application.Processmessages;

// GEK 4/13/00 delete the temporary file : meteorfilename
  If FileExists(Meteorfilename) Then DeleteFile(PChar(Meteorfilename));
  action := caFree;
End;

Procedure TMagMeteorForm1.GetRegistryValues(Var MilSystype, MilSysDeviceNumber,
  MilSizeX, MilSizeY, MilNumberofBands,
  MilDeviceNumber, MilFormat: String);
Var
  Registry: TRegistry;

Begin
  Registry := TRegistry.Create;

  Registry.RootKey := HKEY_LOCAL_MACHINE;

  // Added checks to find the data in the registry locations for ActiveMIL 7.5 (JMW 11/24/2003)
  {False because we do not want to create it if it doesn’t exist}
  If Registry.OpenKey('\SOFTWARE\Matrox\ActiveMIL\2.1.263\Default\System', False) = False Then
    Registry.OpenKey('\SOFTWARE\Matrox\ActiveMIL\7.50.384\Default\System', False);
  MilSystype := Registry.ReadString('SystemType');

  If Registry.OpenKey('\SOFTWARE\Matrox\ActiveMIL\2.1.263\Default\System', False) = False Then
    Registry.OpenKey('\SOFTWARE\Matrox\ActiveMIL\7.50.384\Default\System', False);
  MilSysDeviceNumber := Registry.ReadString('DeviceNumber');

  If Registry.OpenKey('\SOFTWARE\Matrox\ActiveMIL\2.1.263\Default\Image', False) = False Then
    If Registry.OpenKey('\SOFTWARE\Matrox\ActiveMIL\2.1.263\Default\Buffer', False) = False Then
      Registry.OpenKey('\SOFTWARE\Matrox\ActiveMIL\7.50.384\Default\Image', False);
  MilSizeX := Registry.ReadString('SizeX');

  If Registry.OpenKey('\SOFTWARE\Matrox\ActiveMIL\2.1.263\Default\Image', False) = False Then
    If Registry.OpenKey('\SOFTWARE\Matrox\ActiveMIL\2.1.263\Default\Buffer', False) = False Then
      Registry.OpenKey('\SOFTWARE\Matrox\ActiveMIL\7.50.384\Default\Image', False);
  MilSizeY := Registry.ReadString('SizeY');

  If Registry.OpenKey('\SOFTWARE\Matrox\ActiveMIL\2.1.263\Default\Image', False) = False Then
    If Registry.OpenKey('\SOFTWARE\Matrox\ActiveMIL\2.1.263\Default\Buffer', False) = False Then
      Registry.OpenKey('\SOFTWARE\Matrox\ActiveMIL\7.50.384\Default\Image', False);
  MilNumberofBands := Registry.ReadString('NumberOfBands');

  If Registry.OpenKey('\SOFTWARE\Matrox\ActiveMIL\2.1.263\Default\Digitizer', False) = False Then
    Registry.OpenKey('\SOFTWARE\Matrox\ActiveMIL\7.50.384\Default\Digitizer', False);
  MilDeviceNumber := Registry.ReadString('DeviceNumber');

  If Registry.OpenKey('\SOFTWARE\Matrox\ActiveMIL\2.1.263\Default\Digitizer', False) = False Then
    Registry.OpenKey('\SOFTWARE\Matrox\ActiveMIL\7.50.384\Default\Digitizer', False);
  MilFormat := Registry.ReadString('Format');

  Registry.Free;
End;

Procedure TMagMeteorForm1.NextButtonKeyDown(Sender: Tobject; Var Key: Word;
  Shift: TShiftState);
Begin
     //UnFreeze with backspace or escape key
  If (Key = VK_BACK) Or (Key = VK_ESCAPE) Then
    If TbFreeze.Down Then
    Begin
      TbFreeze.Down := False;
      TbFreezeClick(Self);
    End;

     //freeze or unfreeze with "F" key
  If (Key = 70) Or (Key = 20) Then
  Begin
    TbFreeze.Down := Not TbFreeze.Down;
    TbFreezeClick(Self);
  End;
     // ok with "O" key
  If (Key = 79) Then
  Begin
    TbOK.Down := Not TbOK.Down;
    TbOKClick(Self);
    TbOK.Down := Not TbOK.Down
  End;

End;

Procedure TMagMeteorForm1.DisplayClick(Sender: Tobject);
Begin
  NextButton.SetFocus;
End;

End.
