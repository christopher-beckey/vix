program MagThumbnailMaker;

uses
  Forms,
  fmagThumbnailMaker in 'fmagThumbnailMaker.pas' {frmThumbnailMaker},
  umagThumbmgr in 'umagThumbmgr.pas',
  umagAbsUtil in 'umagAbsUtil.pas';

{$R *.res}

begin
  Application.Initialize;
 // Application.ShowMainForm:=False;
  Application.MainFormOnTaskbar := True;
  Application.Title := 'Imaging Thumbnail Maker';
  Application.CreateForm(TfrmThumbnailMaker, frmThumbnailMaker);
  Application.Run;
end.
