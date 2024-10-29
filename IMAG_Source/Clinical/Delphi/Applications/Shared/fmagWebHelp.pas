Unit FmagWebHelp;

Interface

Uses
  ComCtrls,
  Controls,
  Forms,
  Menus,
  SHDocVw,
  Classes,
  OleCtrls
  // imaging
,   umagutils8
  ;

//Uses Vetted 20090929:ExtCtrls, StdCtrls, ValEdit, Grids, OleCtrls, Dialogs, Graphics, Classes, Variants, SysUtils, Messages, Windows,

Type
  TfrmWebHelp = Class(TForm)
    WebBrowser1: TWebBrowser;
    MainMenu1: TMainMenu;
    StatusBar1: TStatusBar;
    Procedure FormCreate(Sender: Tobject);
  Private
    procedure checkform;
    { Private declarations }
  Public
  procedure Execute();
    { Public declarations }
  End;

Var
  FrmWebHelp: TfrmWebHelp;

Implementation

{$R *.dfm}

procedure TfrmWebHelp.Execute;
begin
CheckForm;
frmWebHelp.show;

end;
procedure TfrmWebHelp.checkform();
begin
  if not doesformexist('frmWebHelp') then application.CreateForm(TfrmWebHelp,frmWebHelp);
end;

Procedure TfrmWebHelp.FormCreate(Sender: Tobject);
Begin
  WebBrowser1.Align := alClient;
End;

End.
