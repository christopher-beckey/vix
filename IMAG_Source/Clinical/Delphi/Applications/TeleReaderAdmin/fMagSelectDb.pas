unit fMagSelectDb;

interface

uses
  Windows, Messages, SysUtils, Variants, Classes, Graphics, Controls, Forms,
  Dialogs, StdCtrls, ExtCtrls, VA508AccessibilityManager;

type
  TfrmSelectDB = class(TForm)
    amgrMain: TVA508AccessibilityManager;
    edtServer: TLabeledEdit;
    edtPort: TLabeledEdit;
    Label1: TLabel;
    btnOK: TButton;
    btnCancel: TButton;
    procedure btnOKClick(Sender: TObject);
    procedure edtPortKeyPress(Sender: TObject; var Key: Char);
    procedure EditChange(Sender: TObject);
  private
    FServer : String;
    FPort : integer;
    { Private declarations }
  public
    { Public declarations }
    function SelectDb(Server, Port : String) : TModalResult;

    property Server : String read FServer;
    property Port : integer read FPort;
  end;

implementation

{$R *.dfm}

function TfrmSelectDB.SelectDb(Server, Port : String) : TModalResult;
begin
  FServer := '';
  FPort := 0;
  edtServer.Text := server;
  if port <> '0' then edtPort.Text := port;
  ShowModal;
  result := ModalResult;
end;

procedure TfrmSelectDB.btnOKClick(Sender: TObject);
begin
  FPort := strtoint(edtPort.Text);
  FServer := edtServer.Text;
end;

procedure TfrmSelectDB.edtPortKeyPress(Sender: TObject; var Key: Char);
begin
  if (Key in ['0'..'9']) or (Key = #13) or (Key = #8) then Key := Key
  else Key := #0
end;

procedure TfrmSelectDB.EditChange(Sender: TObject);
begin
  btnOk.Enabled := (length(edtServer.Text) > 0) and (length(edtPort.Text) > 0)
end;

end.
