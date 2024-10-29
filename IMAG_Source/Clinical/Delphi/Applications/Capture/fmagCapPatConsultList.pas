Unit FmagCapPatConsultList;

Interface

Uses
  Buttons,
  Classes,
  cMagListView,
  ComCtrls,
  Forms,
  Stdctrls,
  Controls
  ;

//Uses Vetted 20090929:Dialogs, Controls, Graphics, SysUtils, Messages, Windows,

Type
  TfrmCapPatConsultList = Class(TForm)
    Label1: Tlabel;
    Label2: Tlabel;
    Label3: Tlabel;
    LbPatient: Tlabel;
    LbTitle: Tlabel;
    MagListView1: TMagListView;
    btnOK: TBitBtn;
    btnCancel: TBitBtn;
    StatusBar1: TStatusBar;
    Procedure MagListView1SelectItem(Sender: Tobject; Item: TListItem;
      Selected: Boolean);
  Private
    { Private declarations }
  Public
    {   True if user selects a Consult and the selected consultDA is returned
        in consDA}
    Function Execute(Var ConsDA: String; ConsList: Tstringlist; Parmtitle, Parmpatient: String): Boolean;
    { Public declarations }
  End;

Var
  FrmCapPatConsultList: TfrmCapPatConsultList;

Implementation

{$R *.DFM}

{ TfrmCapPatConsultList }

Function TfrmCapPatConsultList.Execute(Var ConsDA: String; ConsList: Tstringlist; Parmtitle, Parmpatient: String): Boolean;
Var
  Li: TListItem;
Begin
//
  Application.CreateForm(TfrmCapPatConsultList, FrmCapPatConsultList);
  With FrmCapPatConsultList Do
  Begin
    If (ConsList.Count > 0) Then
    Begin
      MagListView1.LoadListFromStrings(ConsList);
      MagListView1.FitColumnsToText;
    End;
    btnOK.Enabled := False;
    btnCancel.Enabled := True;
    LbTitle.caption := Parmtitle;
    LbPatient.caption := Parmpatient;
    FrmCapPatConsultList.Showmodal;
    Li := MagListView1.Selected;
    If Li <> Nil Then
    Begin
      Result := True;
      ConsDA := TMagListViewData(Li.Data).Data;
    End
    Else
    Begin
      Result := False;
      ConsDA := '';
    End;
  End;
End;

Procedure TfrmCapPatConsultList.MagListView1SelectItem(Sender: Tobject;
  Item: TListItem; Selected: Boolean);
Begin
  btnOK.Enabled := Selected;
End;

End.
