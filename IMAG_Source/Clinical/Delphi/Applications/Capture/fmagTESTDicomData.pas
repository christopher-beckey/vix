unit fmagTESTDicomData;

interface

uses
  Windows, Messages, SysUtils, Variants, Classes, Graphics, Controls, Forms,
  Dialogs, StdCtrls, ExtCtrls
  //va
,   fmagCapMain
;

type
  TfrmTESTDicomData = class(TForm)
    pnlDicomTestingData: TPanel;
    memDicomTest: TMemo;
    Panel1: TPanel;
    Splitter1: TSplitter;
    Panel2: TPanel;
    btnDicomFieldsGetUserData: TButton;
    btnDicomMemoClear: TButton;
    btnDicomGetGeneratedData: TButton;
    memDicom106: TMemo;
    Label1: TLabel;
    procedure FormCreate(Sender: TObject);
    procedure btnDicomMemoClearClick(Sender: TObject);
    procedure btnDicomFieldsGetUserDataClick(Sender: TObject);
    procedure btnDicomGetGeneratedDataClick(Sender: TObject);
  private

    { Private declarations }
  public
    { Public declarations }
  end;

var
  frmTESTDicomData: TfrmTESTDicomData;

implementation

uses fmagCapConfig ;

{$R *.dfm}

procedure TfrmTESTDicomData.btnDicomFieldsGetUserDataClick(Sender: TObject);
begin
frmCapMain.TESTDicomGetUserData;   {//Mychng}
end;

procedure TfrmTESTDicomData.btnDicomGetGeneratedDataClick(Sender: TObject);
begin
frmCapMain.TESTDicomGetGeneratedData;   {//Mychng}
end;

procedure TfrmTESTDicomData.btnDicomMemoClearClick(Sender: TObject);
begin
memDicomTest.clear;   {//Mychng}
end;

procedure TfrmTESTDicomData.FormCreate(Sender: TObject);
begin
pnlDicomTestingData.Align := alclient;
pnlDicomTestingData.Caption := '';

memDicom106.Align := alclient;
memDicomTest.Align := alclient;
end;




end.
