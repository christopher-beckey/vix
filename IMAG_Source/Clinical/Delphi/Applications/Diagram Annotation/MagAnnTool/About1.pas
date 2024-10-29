unit About1;

interface

uses
  Windows, Messages, SysUtils, Classes, Graphics, Controls, Forms, Dialogs,
  StdCtrls, Buttons, ExtCtrls, MagFileVersion, FmxUtils;

type
  TfrmAbout = class(TForm)
    btnOK: TBitBtn;
    imgVistA: TImage;
    lblVA: TLabel;
    lblSilverSpring: TLabel;
    lblSDD: TLabel;
    lblAnnotation: TLabel;
    lblfilename: TLabel;
    lblVersion: TLabel;
    lblFilesize: TLabel;
    lblFileDate: TLabel;
    lbfilename: TLabel;
    lbversion: TLabel;
    lbfilesize: TLabel;
    lbfiledate: TLabel;
    procedure btnOKClick(Sender: TObject);
    procedure FormCreate(Sender: TObject);
  private
    { Private declarations }
  public
    { Public declarations }
  end;

var
  frmAbout: TfrmAbout;

implementation

{$R *.DFM}

procedure TfrmAbout.btnOKClick(Sender: TObject);
begin
self.Release; // release the form
end;

procedure TfrmAbout.FormCreate(Sender: TObject);
Var
  DLLFileName: Pchar; // variable for the filename
begin
  // set the captions to nothing
  lbVersion.caption := '';
  lbfilename.caption := '';
  lbfilesize.caption := '';
  lbfiledate.caption := '';

  GetMem(DLLFileName, 255); // get the filename
    if (DLLFileName <> nil) then // if its not nothing
  GetModuleFileName(hInstance, DLLFileName, 254); // get the module name
  lbVersion.caption := MagGetFileVersionInfo(DLLFileName); // set the file version
  lbfilename.caption := DLLFileName; // set the filename
  lbfilesize.caption := inttostr((getfilesize(DLLFileName) div 1024) + 1) + ' KB'; // set the filesize
  lbfiledate.caption := formatdatetime('mm/dd/yy  h:nn  am/pm', filedatetime(DLLFileName)); // set the file date

end;

end.

