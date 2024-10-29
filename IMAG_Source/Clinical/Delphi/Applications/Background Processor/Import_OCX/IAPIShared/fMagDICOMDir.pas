Unit FMagDICOMDir;

Interface

Uses
  ExtCtrls,
  FileCtrl,
  Forms,
  Stdctrls,
  UMagClasses,
  Controls,
  Classes
  ;

//Uses Vetted 20090929:cmag4Viewer, Dialogs, Controls, Graphics, Classes, Variants, SysUtils, Messages, Windows,

Type
  TfrmDICOMDir = Class;

  TMagChangeViewEvent = Procedure(Sender: Tobject; StackView: Boolean) Of Object;
  TMagOpenImageEvent = Procedure(Sender: Tobject; IObj: TImageData; ViewerNum: Integer = 1) Of Object;

  TfrmDICOMDir = Class(TForm)
    btnClose: TButton;
    PnlLeft: Tpanel;
    DriveComboBox1: TDriveComboBox;
    DirectoryListBox1: TDirectoryListBox;
    FileListBox1: TFileListBox;
    FilterComboBox1: TFilterComboBox;
    PnlRight: Tpanel;
    DriveComboBox2: TDriveComboBox;
    DirectoryListBox2: TDirectoryListBox;
    FileListBox2: TFileListBox;
    FilterComboBox2: TFilterComboBox;
    TimerReSize: TTimer;
    Procedure DriveComboBox1Change(Sender: Tobject);
    Procedure DirectoryListBox1Change(Sender: Tobject);
    Procedure DriveComboBox2Change(Sender: Tobject);
    Procedure DirectoryListBox2Change(Sender: Tobject);
    Procedure FileListBox1Click(Sender: Tobject);
    Procedure FileListBox2Click(Sender: Tobject);
    Procedure btnCloseClick(Sender: Tobject);
    Procedure FormCreate(Sender: Tobject);
    Procedure FormDestroy(Sender: Tobject);
    Procedure FormResize(Sender: Tobject);
    Procedure TimerReSizeTimer(Sender: Tobject);
  Private
    FChangeViewEvent: TMagChangeViewEvent;
    FOpenImageEvent: TMagOpenImageEvent;

  Public
    Procedure Execute();
    Property OnChangeViewEvent: TMagChangeViewEvent Read FChangeViewEvent Write FChangeViewEvent;
    Property OnOpenImageEvent: TMagOpenImageEvent Read FOpenImageEvent Write FOpenImageEvent;
  End;

Var
  FrmDICOMDir: TfrmDICOMDir;

Implementation

{$R *.dfm}

Procedure TfrmDICOMDir.Execute();
Begin

  Self.Show();
End;

Procedure TfrmDICOMDir.DriveComboBox1Change(Sender: Tobject);
Begin
  // be sure drive is not empty (why would it be?)
  // solves I/O 123 error
  If DriveComboBox1.Drive <> '' Then
    DirectoryListBox1.Drive := DriveComboBox1.Drive;
End;

Procedure TfrmDICOMDir.DirectoryListBox1Change(Sender: Tobject);
Begin
  FileListBox1.Directory := DirectoryListBox1.Directory;
End;

Procedure TfrmDICOMDir.DriveComboBox2Change(Sender: Tobject);
Begin
  If DriveComboBox2.Drive <> '' Then
    DirectoryListBox2.Drive := DriveComboBox2.Drive;
End;

Procedure TfrmDICOMDir.DirectoryListBox2Change(Sender: Tobject);
Begin
  FileListBox2.Directory := DirectoryListBox2.Directory;
End;

Procedure TfrmDICOMDir.FileListBox1Click(Sender: Tobject);
Var
  IObj: TImageData;
Begin
  IObj := TImageData.Create();
  IObj.FFile := FileListBox1.Filename;
  IObj.Mag0 := FileListBox1.Filename;
  IObj.ImgDes := FileListBox1.Filename;
  If Assigned(FOpenImageEvent) Then
    FOpenImageEvent(Self, IObj, 1);
  Self.SetFocus(); // JMW 12/1/06 - give the focus back to the dir dialog
End;

Procedure TfrmDICOMDir.FileListBox2Click(Sender: Tobject);
Var
  IObj: TImageData;
Begin
  If Assigned(OnChangeViewEvent) Then
    OnChangeViewEvent(Self, True);

  IObj := TImageData.Create();
  IObj.FFile := FileListBox2.Filename;
  IObj.Mag0 := FileListBox2.Filename;
  IObj.ImgDes := FileListBox2.Filename;
  If Assigned(FOpenImageEvent) Then
    FOpenImageEvent(Self, IObj, 2);
  Self.SetFocus(); // JMW 12/1/06 - give the focus back to the dir dialog
End;

Procedure TfrmDICOMDir.btnCloseClick(Sender: Tobject);
Begin
  Self.Close();
End;

Procedure TfrmDICOMDir.FormCreate(Sender: Tobject);
//var
//  drive, appPath : String;
Begin
  FileListBox1.Mask := FilterComboBox1.Mask;
  FileListBox2.Mask := FilterComboBox2.Mask;

//  appPath := copy(extractfilepath(application.exename), 1, length(extractfilepath(application.exename)) - 1);
//  drive := ExtractFileDrive(appPath);
//  DriveComboBox1.Drive := drive;

End;

Procedure TfrmDICOMDir.FormDestroy(Sender: Tobject);
Begin
  TimerReSize.Enabled := False;
//  self.Caption := 'destroy!';
End;

Procedure TfrmDICOMDir.FormResize(Sender: Tobject);
Begin
  If Application.Terminated Then Exit;
  TimerReSize.Enabled := False;
  Application.Processmessages;
  TimerReSize.Enabled := True;

End;

Procedure TfrmDICOMDir.TimerReSizeTimer(Sender: Tobject);
Begin
  If Application.Terminated Then Exit;
  TimerReSize.Enabled := False;
  PnlLeft.Width := Trunc(Self.ClientWidth / 2) - 16;
  PnlRight.Width := PnlLeft.Width;
  PnlRight.Left := PnlLeft.Left + PnlLeft.Width + 16;

End;

End.
