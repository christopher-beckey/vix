Unit FmagDirectoryDialog;

Interface

Uses
  Buttons,
  Classes,
  ComCtrls,
  ExtCtrls,
  Forms,
  Menus,
  ShellCtrls,
  Stdctrls,
  Controls
  ;

//Uses Vetted 20090929:filectrl, Dialogs, Graphics, Variants, Messages, magpositions, Controls, SysUtils, Windows

Type
  TfrmDirectoryDialog = Class(TForm)
    ShellChangeNotifier1: TShellChangeNotifier;
    Panel1: Tpanel;
    ShellTreeView1: TShellTreeView;
    ShellComboBox1: TShellComboBox;
    Splitter1: TSplitter;
    PnlShellList: Tpanel;
    ShellListView1: TShellListView;
    PopupMenu1: TPopupMenu;
    List1: TMenuItem;
    Icon1: TMenuItem;
    Report1: TMenuItem;
    SmallIcon1: TMenuItem;
    Panel2: Tpanel;
    btnAdd: TBitBtn;
    BitBtn2: TBitBtn;
    Label1: Tlabel;
    LbSelectedDir: Tlabel;
    StatusBar1: TStatusBar;
    Procedure FormCreate(Sender: Tobject);
    Procedure Icon1Click(Sender: Tobject);
    Procedure List1Click(Sender: Tobject);
    Procedure Report1Click(Sender: Tobject);
    Procedure SmallIcon1Click(Sender: Tobject);
    Procedure btnAddClick(Sender: Tobject);
    Procedure FormDestroy(Sender: Tobject);
    Procedure ShellTreeView1Change(Sender: Tobject; Node: TTreeNode);
    Procedure ShellListView1Click(Sender: Tobject);
  Private
    FdirList: TStrings;
    Procedure WinMsg(Value: String); { Private declarations }
  Public
    Procedure Execute(Dirlist: TStrings = Nil); { Public declarations }
  End;

Var
  FrmDirectoryDialog: TfrmDirectoryDialog;

Implementation
Uses
  Magpositions,
  SysUtils,
  Windows
  ;

{$R *.dfm}

Procedure TfrmDirectoryDialog.FormCreate(Sender: Tobject);
Begin
  PnlShellList.Align := alClient;
  GetFormPosition(Self As TForm);
End;

Procedure TfrmDirectoryDialog.Icon1Click(Sender: Tobject);
Begin
  ShellListView1.ViewStyle := VsIcon;
End;

Procedure TfrmDirectoryDialog.List1Click(Sender: Tobject);
Begin
  ShellListView1.ViewStyle := Vslist;
End;

Procedure TfrmDirectoryDialog.Report1Click(Sender: Tobject);
Begin
  ShellListView1.ViewStyle := Vsreport;
End;

Procedure TfrmDirectoryDialog.SmallIcon1Click(Sender: Tobject);
Begin
  ShellListView1.ViewStyle := VsSmallIcon;
End;

Procedure TfrmDirectoryDialog.btnAddClick(Sender: Tobject);
Var
  VDir: String;
Begin
  VDir := ShellTreeView1.Path + '\';
  If Directoryexists(VDir) Then
    FdirList.Add(VDir)
  Else
    Messagebeep(2);
(*
tnode := shelltreeview1.Selected;
s := tnode.Text + '\';
while tnode.Level <> 0 do
  begin
  tnode := tnode.Parent;
  s := tnode.Text + '\' + s;
  end;
FdirList.Add(s);
*)
End;

Procedure TfrmDirectoryDialog.Execute(Dirlist: TStrings);
Begin
//
  Application.CreateForm(TfrmDirectoryDialog, FrmDirectoryDialog);
  FrmDirectoryDialog.FdirList := Dirlist;
  FrmDirectoryDialog.Showmodal;
  FrmDirectoryDialog.Free;
End;

Procedure TfrmDirectoryDialog.FormDestroy(Sender: Tobject);
Begin
  SaveFormPosition(Self As TForm);
End;

Procedure TfrmDirectoryDialog.ShellTreeView1Change(Sender: Tobject;
  Node: TTreeNode);
Begin
  If ShellTreeView1.SelectionCount <> 0 Then btnAdd.Enabled := True;
  If Directoryexists(ShellTreeView1.Path) Then
    LbSelectedDir.caption := ShellTreeView1.Path
  Else
    LbSelectedDir.caption := '';
End;

Procedure TfrmDirectoryDialog.ShellListView1Click(Sender: Tobject);
Var
  s, S0: String;
  Li: TListItem;
Begin
  Li := ShellListView1.Selected;
  s := Li.caption;
  S0 := Li.SubItems.Text;
  S0 := Li.SubItems[0];
  WinMsg(s);
End;

Procedure TfrmDirectoryDialog.WinMsg(Value: String);
Begin
  StatusBar1.Panels[1].Text := Value;
End;

End.
