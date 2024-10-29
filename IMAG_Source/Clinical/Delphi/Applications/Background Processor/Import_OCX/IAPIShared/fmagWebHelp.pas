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
  ;

//Uses Vetted 20090929:ExtCtrls, StdCtrls, ValEdit, Grids, OleCtrls, Dialogs, Graphics, Classes, Variants, SysUtils, Messages, Windows,

Type
  TfrmWebHelp = Class(TForm)
    WebBrowser1: TWebBrowser;
    MainMenu1: TMainMenu;
    StatusBar1: TStatusBar;
    Procedure FormCreate(Sender: Tobject);
  Private
    { Private declarations }
  Public
    { Public declarations }
  End;

Var
  FrmWebHelp: TfrmWebHelp;

Implementation

{$R *.dfm}

Procedure TfrmWebHelp.FormCreate(Sender: Tobject);
Begin
  WebBrowser1.Align := alClient;
End;

End.
