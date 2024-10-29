unit Components;

interface

uses
  Windows, Messages, SysUtils, Classes, Graphics, Controls, Forms, Dialogs,
  StdCtrls, AxCtrls, GearCORELib_TLB, comobj;

type
  TfrmComponents = class(TForm)
    Label1: TLabel;
    Label2: TLabel;
    lstAttachedComponents: TListBox;
    btnAttach: TButton;
    btnClose: TButton;
    txtComponentInfo: TMemo;
    procedure FormActivate(Sender: TObject);
    procedure btnCloseClick(Sender: TObject);
    procedure lstAttachedComponentsClick(Sender: TObject);
    procedure btnAttachClick(Sender: TObject);
  private
    { Private declarations }
  public
    { Public declarations }
    procedure updateComponentList();
  end;

var
  frmComponents: TfrmComponents;

implementation

uses MainForm, ComponentsAttach;

{$R *.DFM}

procedure TfrmComponents.FormActivate(Sender: TObject);
begin

    updateComponentList;

end;

procedure TfrmComponents.updateComponentList();
var
    i: Integer;
begin

    // repopulate the list of components that are currently attached to the core
    lstAttachedComponents.Clear;
    For i := 0 To (frmMain.IGCoreCtl1.ComponentCount - 1) do
        lstAttachedComponents.Items.Add (frmMain.IGCoreCtl1.GetComponentInfo(i).Name);

    // select the first component
    lstAttachedComponents.ItemIndex := 0;
    lstAttachedComponentsClick(nil);

end;


procedure TfrmComponents.btnCloseClick(Sender: TObject);
begin

   Close;

end;

procedure TfrmComponents.lstAttachedComponentsClick(Sender: TObject);
var
    ci: IGComponentInfo;
begin

try
    ci := frmMain.IGCoreCtl1.GetComponentInfo(lstAttachedComponents.ItemIndex);

    txtComponentInfo.Lines.Clear;
    txtComponentInfo.Lines.Add('Component: ' + Chr(9) + ci.Name);
    txtComponentInfo.Lines.Add('Version: ' + Chr(9) + Chr(9) + IntToStr(ci.VersionMajor) + '.' + IntToStr(ci.VersionMinor) + '.' + IntToStr(ci.VersionUpdate));
    txtComponentInfo.Lines.Add('Build Date: '  + Chr(9) + ci.BuildDateInfo);
    txtComponentInfo.Lines.Add('Info: '  + Chr(9) + Chr(9) + ci.Info);
except
    On EOleException do frmMain.CheckErrors;
end;

end;

procedure TfrmComponents.btnAttachClick(Sender: TObject);
begin

    frmComponentsAttach.Show;
    updateComponentList;

end;

end.
