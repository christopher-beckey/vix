unit About;

interface

uses
  Windows, Messages, SysUtils, Classes, Graphics, Controls, Forms, Dialogs,
  StdCtrls;

type
  TfrmAbout = class(TForm)
    Label1: TLabel;
    Label2: TLabel;
    lblVersion: TLabel;
    btnOK: TButton;
    procedure FormActivate(Sender: TObject);
    procedure btnOKClick(Sender: TObject);
  private
    { Private declarations }
  public
    { Public declarations }
  end;

var
  frmAbout: TfrmAbout;

implementation

uses MainForm;

{$R *.DFM}

procedure TfrmAbout.FormActivate(Sender: TObject);
begin

    lblVersion.caption :=
        IntToStr(frmMain.IGCoreCtl1.ComponentInfo.VersionMajor) + '.' +
        IntToStr(frmMain.IGCoreCtl1.ComponentInfo.VersionMinor) + '.' +
        IntToStr(frmMain.IGCoreCtl1.ComponentInfo.VersionUpdate);

end;

procedure TfrmAbout.btnOKClick(Sender: TObject);
begin
    Close;
end;

end.
