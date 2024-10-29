unit fMagSetup;

interface

uses
  Windows, Messages, SysUtils, Classes, Graphics, Controls, Forms, Dialogs,
  StdCtrls, cRequestInstallThread;

type
  TfrmMagSetup = class(TForm)
    Label1: TLabel;
    Label2: TLabel;
    procedure FormCreate(Sender: TObject);
    procedure ThreadDone(Sender: TObject);
    procedure FormActivate(Sender: TObject);
  private
    InstallThread: TRequestInstallThread;
  public
 end;

var
  frmMagSetup: TfrmMagSetup;

implementation

{$R *.DFM}

procedure TfrmMagSetup.FormCreate(Sender: TObject);
begin
  InstallThread := TRequestInstallThread.Create(true);
  InstallThread.FreeOnTerminate := true;
  InstallThread.OnTerminate := ThreadDone;
end;

procedure TfrmMagSetup.ThreadDone(Sender: TObject);
begin
  Close();
end;

procedure TfrmMagSetup.FormActivate(Sender: TObject);
begin
  Application.ProcessMessages();
  InstallThread.Resume();
end;

end.
