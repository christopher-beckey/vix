Unit fMagASet;

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
  Inifiles,
  Registry;

Type
  TfrmMagASet = Class(TForm)
    lblInfo: Tlabel;
    lblUpdatePath: Tlabel;
    btnClose: TButton;
    Label1: Tlabel;
    Label2: Tlabel;
    btnOK: TButton;
    lblDone: Tlabel;
    Procedure SetUpdateDirectory();
    Procedure btnCloseClick(Sender: Tobject);
    Procedure UpdateIni(Filename: String);
    Procedure btnOKClick(Sender: Tobject);
    Procedure FormActivate(Sender: Tobject);
  Private
    Procedure DetermineUpdateDirectory();
    Function GetWindowsDir: Tfilename;
    Function GetProgramFilesDir: Tfilename;
    Function GetRegistryData(RootKey: HKEY; Key, Value: String): Variant;
    Function ConvertToUNCPath(MappedDrive: String): String;
  Public
    { Public declarations }
  End;

Var
  frmMagASet: TfrmMagASet;

Implementation

{$R *.DFM}

Procedure TfrmMagASet.DetermineUpdateDirectory();
Var
  arg1, Drive: String;
  targetWidth: Integer;
Begin
  If (ParamCount > 0) Then
  Begin
    arg1 := ParamStr(1);
    If (Lowercase(arg1) = '/c') Then
      lblUpdatePath.caption := ExtractFilePath(Application.ExeName)
    Else
      lblUpdatePath.caption := arg1;
  End
  Else
    lblUpdatePath.caption := ExtractFilePath(Application.ExeName);
  If (Pos(':', lblUpdatePath.caption) = 2) Then
  Begin
    Drive := Copy(lblUpdatePath.caption, 0, 2);
    Drive := ConvertToUNCPath(Drive);
    If (Pos('\\', Drive) = 1) Then
      lblUpdatePath.caption := Drive + Copy(lblUpdatePath.caption, 3, Length(lblUpdatePath.caption))
  End;
  targetWidth := lblUpdatePath.Left + lblUpdatePath.Width + 20;
  If (targetWidth > lblInfo.Width + 40) Then
    frmMagASet.Width := targetWidth;
End;

Procedure TfrmMagASet.SetUpdateDirectory();
Var
  ProgramFilesDir: String;
Begin
  DetermineUpdateDirectory();
  UpdateIni(GetWindowsDir() + '\Mag.ini');
  ProgramFilesDir := GetProgramFilesDir();
  UpdateIni(ProgramFilesDir + '\VistA\Imaging\Mag.ini');
  UpdateIni(ProgramFilesDir + '\VistA\Imaging\Mag308.ini');
  lblDone.caption := 'Done. Automatic updating is enabled for this workstation.';
End;

Procedure TfrmMagASet.UpdateIni(Filename: String);
Var
  Inifile: TIniFile;
Begin
  If (FileExists(Filename)) Then
  Begin
    Inifile := TIniFile.Create(Filename);
    Inifile.Writestring('SYS_AUTOUPDATE', 'DIRECTORY', lblUpdatePath.caption);
    Inifile.Free();
  End;
End;

Function TfrmMagASet.GetWindowsDir: Tfilename;
Var
  Windir: Array[0..MAX_PATH - 1] Of Char;
Begin
  SetString(Result, Windir, GetWindowsDirectory(Windir, MAX_PATH));
  If Result = '' Then
    Raise Exception.Create(SysErrorMessage(Getlasterror));
End;

Function TfrmMagASet.GetProgramFilesDir: Tfilename;
Begin
  Result := GetRegistryData(HKEY_LOCAL_MACHINE,
    '\Software\Microsoft\Windows\CurrentVersion',
    'ProgramFilesDir'); // or 'ProgramFilesPath'
End;

Function TfrmMagASet.GetRegistryData(RootKey: HKEY; Key, Value: String): Variant;
Var
  Reg: TRegistry;
  RegDataType: TRegDataType;
  DataSize, Len: Integer;
  s: String;
Label
  cantread;
Begin
  Reg := Nil;
  Try
    Reg := TRegistry.Create(KEY_QUERY_VALUE);
    Reg.RootKey := RootKey;
    If Reg.OpenKeyReadOnly(Key) Then
    Begin
      Try
        RegDataType := Reg.GetDataType(Value);
        If (RegDataType = rdString) Or
          (RegDataType = rdExpandString) Then
          Result := Reg.ReadString(Value)
        Else
          If RegDataType = rdInteger Then
            Result := Reg.ReadInteger(Value)
          Else
            If RegDataType = rdBinary Then
            Begin
              DataSize := Reg.GetDataSize(Value);
              If DataSize = -1 Then Goto cantread;
              SetLength(s, DataSize);
              Len := Reg.ReadBinaryData(Value, PChar(s)^, DataSize);
              If Len <> DataSize Then Goto cantread;
              Result := s;
            End
            Else
              cantread:
              Raise Exception.Create(SysErrorMessage(ERROR_CANTREAD));
      Except
        s := ''; // Deallocates memory if allocated
        Reg.CloseKey;
        Raise;
      End;
      Reg.CloseKey;
    End
    Else
      Raise Exception.Create(SysErrorMessage(Getlasterror));
  Except
    Reg.Free;
    Raise;
  End;
  Reg.Free;
End;

Function TfrmMagASet.ConvertToUNCPath(MappedDrive: String): String;
Var
  RemoteString: Array[0..255] Of Char;
  lpRemote: PChar;
  StringLen: Cardinal;
Begin
  lpRemote := @RemoteString;
  StringLen := 255;
  WNetGetConnection(PChar(ExtractFileDrive(MappedDrive)), lpRemote, StringLen);
  Result := RemoteString;
End;

Procedure TfrmMagASet.btnCloseClick(Sender: Tobject);
Begin
  Application.Terminate();
End;

Procedure TfrmMagASet.btnOKClick(Sender: Tobject);
Begin
  SetUpdateDirectory();
  btnClose.SetFocus();
End;

Procedure TfrmMagASet.FormActivate(Sender: Tobject);
Begin
  DetermineUpdateDirectory();
  btnOK.SetFocus();
End;

End.
