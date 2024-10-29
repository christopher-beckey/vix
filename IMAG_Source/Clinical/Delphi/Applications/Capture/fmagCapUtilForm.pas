unit fmagCapUtilForm;

interface

uses
  Windows, Messages, SysUtils, Variants, Classes, Graphics, Controls, Forms,
  Dialogs, StdCtrls, FileCtrl
  //va
  , umagclasses
  ;

type
  TfrmCapUtilForm = class(TForm)
    Button1: TButton;
    magCapFileListBox1: TFileListBox;
    magCapDirectoryListBox1: TDirectoryListBox;
  private
    procedure EraseCapTempFiles2;

    { Private declarations }
  public
    procedure EraseCaptureTempFiles(dir : String);  
    { Public declarations }
  end;

var
  frmCapUtilForm: TfrmCapUtilForm;

implementation
uses fmagcapmain ;

{$R *.dfm}

Procedure TfrmCapUtilForm.EraseCaptureTempFiles(dir : string);
Begin
   //dir := frmCapMain.UserDir.Cache;

    magCapFileListBox1.Directory := dir;
    magCapDirectoryListBox1.Directory := dir;
//    If Doesformexist('frmVideoPlayer') Then  FrmVideoPlayer.Close;
    Application.Processmessages;
    EraseCapTempFiles2;
End;


Procedure TfrmCapUtilForm.EraseCapTempFiles2;
Var
  i, j: Integer;
  Xfile: String;
  D1, D2: PChar;
  CurrentDir: String;
Begin
  {TODO:  We get error if Video File is opened}
  {file won't be erased if the mPlay32.exe is still open with a file.}
  For i := magCapFileListBox1.Items.Count - 1 Downto 0 Do
  Begin
    Xfile := magCapFileListBox1.Items[i];
    SysUtils.DeleteFile(Xfile);
  End;
  Application.Processmessages;

  // JMW 6/17/2005 p45 delete all files in subdirectories

  D2 := PChar(AnsiUpperCase(magCapDirectoryListBox1.Directory));
  For i := magCapDirectoryListBox1.Items.Count - 1 Downto 1 Do
  Begin
    D1 := PChar(AnsiUpperCase(magCapDirectoryListBox1.Items[i]));
    If Strpos(D2, D1) = Nil Then
    Begin
      CurrentDir := magCapDirectoryListBox1.Directory + '\' + magCapDirectoryListBox1.Items[i];
      magCapFileListBox1.Directory := CurrentDir;
      For j := magCapFileListBox1.Items.Count - 1 Downto 0 Do
      Begin
        SysUtils.DeleteFile(magCapFileListBox1.Items[j]);
      End;
      magCapFileListBox1.Directory := magCapDirectoryListBox1.Directory;
      RemoveDir(CurrentDir); // delete the directory the images were in
    End;
  End;
  Application.Processmessages();
End;

end.
