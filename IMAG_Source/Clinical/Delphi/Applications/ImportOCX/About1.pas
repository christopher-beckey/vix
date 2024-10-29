unit About1;

interface

uses
  Windows, Messages, SysUtils, Classes, Graphics, Controls, Forms, Dialogs,
  StdCtrls, ExtCtrls, Buttons;

type
  TMagImportXAbout = class(TForm)
    CtlImage: TSpeedButton;
    OkBtn: TButton;
    CopyrightLbl: TLabel;
    DescLbl: TLabel;
    Label1: TLabel;
  end;

procedure ShowMagImportXAbout;

implementation

{$R *.DFM}

procedure ShowMagImportXAbout;
begin
  with TMagImportXAbout.Create(nil) do
    try
      ShowModal;
    finally
      Free;
    end;
end;

end.
