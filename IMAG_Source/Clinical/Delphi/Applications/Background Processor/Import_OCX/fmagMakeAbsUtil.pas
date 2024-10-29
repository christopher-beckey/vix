unit fmagMakeAbsUtil;

interface

uses
 // Windows, Messages, SysUtils, Variants, Classes, Graphics, Controls,
 // Dialogs,

forms,
fmagMagMakeAbs
;

type
  TfrmMakeAbsUtil = class(TForm)
    procedure FormCreate(Sender: TObject);
  private
    { Private declarations }
  public
    { Public declarations }
  end;

var
  frmMakeAbsUtil: TfrmMakeAbsUtil;

implementation

{$R *.dfm}

procedure TfrmMakeAbsUtil.FormCreate(Sender: TObject);
begin
frmMakeAbs.InitSetup;
end;

end.
