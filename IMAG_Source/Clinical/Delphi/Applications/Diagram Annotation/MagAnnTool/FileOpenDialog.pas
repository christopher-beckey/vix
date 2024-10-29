unit FileOpenDialog;

interface

uses
  Windows, Messages, SysUtils, Classes, Graphics, Controls, Forms, Dialogs,
  StdCtrls, FileCtrl;//, fmagcapannotate;

type
  TfrmOpenDialog = class(TForm)
    lstFile: TFileListBox;
    btnOpen: TButton;
    btnCancel: TButton;
    edtFilename: TEdit;
    lstDir: TDirectoryListBox;
    Edit1: TEdit;
    procedure FormCreate(Sender: TObject);
    procedure lstFileChange(Sender: TObject);
    procedure btnCancelClick(Sender: TObject);
    procedure lstDirChange(Sender: TObject);
    procedure btnOpenClick(Sender: TObject);
    procedure lstFileDblClick(Sender: TObject);
  private
    { Private declarations }
  public

        function ShowDialog(dir : string; rootDir : string) : string;
    { Public declarations }

  end;

var
  frmOpenDialog: TfrmOpenDialog; // the open file form
  InitDir : string; // the initial selected directory
  RootDirectory : string; // the root directory
implementation

{$R *.DFM}

function tfrmopendialog.ShowDialog(dir : string; rootDir : string) : string;
begin

  lstfile.Directory := dir; // set the file list box
  lstdir.Directory := dir; // set the directory list box
  rootdirectory := rootdir; // set the root directory
  showmodal; // show the form as modal
  if modalresult = mrok then // if the result is ok
  begin
    result := lstfile.FileName; // return the selected filename
    exit; // exit the form
  end;
  result := ''; // result is nothing
  exit; // exit the form
end;

procedure TfrmOpenDialog.FormCreate(Sender: TObject);
begin
lstfile.Mask := '*.tif';// set the filter
self.Caption := 'Open Image for Annotation'; // set the caption of the form
end;

procedure TfrmOpenDialog.lstFileChange(Sender: TObject);
begin
edtfilename.text := extractfilename(lstfile.filename); // set the filename edit text
end;

procedure TfrmOpenDialog.btnCancelClick(Sender: TObject);
begin
modalresult := mrcancel; // set the result as cancel
self.Release; // release the form
end;

procedure TfrmOpenDialog.lstDirChange(Sender: TObject);
var
d1 : PChar;
d2 : PChar;
begin
d1 := PChar(AnsiUpperCase(lstdir.directory)); // get the directory
d2 := PChar(AnsiUpperCase(rootDirectory)); // get the directory
if StrPos(d1, d2) <> nil then // if d1 is in d2
begin
  lstfile.Directory := lstdir.Directory; // set the directory
  lstfile.Refresh; // refresh the file list
  exit; // exit this procedure
end;

  lstdir.Directory := rootdirectory; // set the directory to the root
  lstfile.Directory := lstdir.directory; // set the file list to the directory list
  lstfile.Refresh; // refresh the file list
end;

procedure TfrmOpenDialog.btnOpenClick(Sender: TObject);
begin
// check to make sure the selected file exists
if fileexists(lstfile.filename) then // if the file exists
begin
  modalresult := mrOK; // set the result to true
  exit; // exit this form
end;
modalresult := mrcancel; // set the result to false
exit; // exit this form

end;

procedure TfrmOpenDialog.lstFileDblClick(Sender: TObject);
begin
btnOpenClick(self); // call the open button click event
end;

end.
