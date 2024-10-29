unit ComponentsAttach;

interface

uses
  Windows, Messages, SysUtils, Classes, Graphics, Controls, Forms, Dialogs,
  StdCtrls, SharedGlobals, GearCORELib_TLB, comobj;

type
  TfrmComponentsAttach = class(TForm)
    lstComponents: TListBox;
    btnOK: TButton;
    btnCancel: TButton;
    procedure RefreshComponentList();
    procedure btnOKClick(Sender: TObject);
    procedure btnCancelClick(Sender: TObject);
    procedure lstComponentsDoubleClick(Sender: TObject);
    procedure FormActivate(Sender: TObject);
  private
    { Private declarations }
    function isAttached(component: attachableComponent; attachedComponents: array of attachableComponent): Boolean;
    procedure addComponent(componentName: String);
  public
    { Public declarations }
  end;

type TCompData = class(TObject)
    CompIndex: Integer;
    end;

var
  frmComponentsAttach: TfrmComponentsAttach;

implementation

uses MainForm, Components;

{$R *.DFM}

// create list of currently attached components

procedure TfrmComponentsAttach.RefreshComponentList();
var
    attachedComponents: array [0..19] of attachableComponent;
    tempComponent: attachableComponent;
    i: Integer;
    NewItemIndex: Integer;
begin

    // TODO can possibly improve the way filtering of attached components is done here
    //  currently it builds a list of attached components and uses a helper function
    //  isAttached() to see if a given progid is in that list
    For i := 0 To frmMain.IGCoreCtl1.ComponentCount - 1 do
    begin
        // TODO replace line below with: tempComponent.programID := frmMain.IGCoreCtl1.GetComponentInfo(j).ProgId
        tempComponent.displayName := frmMain.IGCoreCtl1.GetComponentInfo(i).Name;
        attachedComponents[i] := tempComponent;
    end;

    lstComponents.Clear;
    For i := 0 To Length(attachableComponents)-1 do
    begin
        If (Not isAttached(attachableComponents[i], attachedComponents)) Then
        begin
            NewItemIndex := lstComponents.Items.Add (attachableComponents[i].displayName);
            // save index into attachableComponents array
            lstComponents.Items.Objects[NewItemIndex] := TCompData.Create;
            (lstComponents.Items.Objects[NewItemIndex] As TCompData).CompIndex := i;
        End
    End

end;

procedure TfrmComponentsAttach.btnOKClick(Sender: TObject);
var
    CompIndex: Integer;
begin

    If (lstComponents.ItemIndex  <> -1) Then
    begin
        CompIndex := (lstComponents.Items.Objects[lstComponents.ItemIndex] As TCompData).CompIndex;
        addComponent (attachableComponents[CompIndex].programID);
    end;

    Close;

end;

procedure TfrmComponentsAttach.btnCancelClick(Sender: TObject);
begin

    Close;

end;

procedure TfrmComponentsAttach.lstComponentsDoubleClick(Sender: TObject);
var
    CompIndex: Integer;
begin

    If (lstComponents.ItemIndex  <> -1) Then
    begin
        CompIndex := (lstComponents.Items.Objects[lstComponents.ItemIndex] As TCompData).CompIndex;
        addComponent (attachableComponents[CompIndex].programID);
        refreshComponentList;
    end;

end;

procedure TfrmComponentsAttach.addComponent(componentName: String);
var
    tempComponent: IIGComponent;
begin

try
    tempComponent := frmMain.IGCoreCtl1.CreateComponent(componentName);

    frmMain.IGCoreCtl1.AssociateComponent (tempComponent.ComponentInterface);
    frmComponents.updateComponentList;
except
    On EOleException do frmMain.CheckErrors;
end;

End;

function TfrmComponentsAttach.isAttached(component: attachableComponent; attachedComponents: array of attachableComponent): Boolean;
var
    i: Integer;
    bFound: boolean;
begin

    isAttached := False;
    bFound := False;

    i := 0;
    while ((i < frmMain.IGCoreCtl1.ComponentCount) and (Not bFound)) do
    begin
        // TODO replace line below with: If component.programID = attachedComponents(i).programID Then
        If (UpperCase(component.displayName) = UpperCase(attachedComponents[i].displayName)) then
        begin
            isAttached := True;
            bFound := true;
        end;
        i := i+1;
    end;
End;

procedure TfrmComponentsAttach.FormActivate(Sender: TObject);
begin
    refreshComponentList;
end;

end.
