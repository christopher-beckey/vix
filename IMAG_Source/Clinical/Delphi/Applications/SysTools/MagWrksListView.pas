Unit MagWrksListView;

Interface

Uses
  Windows,
  Messages,
  SysUtils,
  Classes,
  Graphics,
  Controls,
  Forms,
  Dialogs,
  Umagutils8,
  ExtCtrls,
  ComCtrls,
  ToolWin,
  Menus,
  Trpcb,
  Stdctrls,
  ImgList,
  Buttons, cMagListViewLite,
  fmagconfiglist ,
  magbroker   ,
  inifiles ,
  dateutils
  ;

Type
  TMagWrksListForm = Class(TForm)
    ListView1: TListView;
    ImageList1: TImageList;
    ImageList2: TImageList;
    PopupMenu1: TPopupMenu;
    Listview2: TMenuItem;
    Detailview1: TMenuItem;
    Iconview1: TMenuItem;
    FontDialog1: TFontDialog;
    Panel2: Tpanel;
    Panel3: Tpanel;
    Splitter1: TSplitter;
    Splitter2: TSplitter;
    CoolBar1: TCoolBar;
    Panel4: Tpanel;
    ToolBar1: TToolBar;
    ToolButton1: TToolButton;
    ToolButton2: TToolButton;
    ToolButton3: TToolButton;
    ToolButton4: TToolButton;
    ToolButton7: TToolButton;
    ToolButton6: TToolButton;
    sdtfr: TDateTimePicker;
    Sdtto: TDateTimePicker;
    Label2: Tlabel;
    Label3: Tlabel;
    tbtnHelp: TToolButton;
    tbutDock: TToolButton;
    StatusBar1: TStatusBar;
    editsdtfr: TEdit;
    editsdtto: TEdit;
    Panel1: Tpanel;
    dtpwdtfr: TDateTimePicker;
    dtpwdtto: TDateTimePicker;
    lblwdtfr: Tlabel;
    lblwdtto: Tlabel;
    editwdtfr: TEdit;
    editwdtto: TEdit;
    rblast: TRadioButton;
    rbany: TRadioButton;
    Panel6: TPanel;
    Splitter3: TSplitter;
    Panel7: TPanel;
    mlvl1: TMagListViewLite;
    btnConfigurations: TButton;
    PopupMenu2: TPopupMenu;
    ShowColumns1: TMenuItem;
    btnApplyWrksConfigs: TButton;
    Procedure ToolButton1Click(Sender: Tobject);
    Procedure ToolButton2Click(Sender: Tobject);
    Procedure ToolButton3Click(Sender: Tobject);
    Procedure Listview2Click(Sender: Tobject);
    Procedure Iconview1Click(Sender: Tobject);
    Procedure Detailview1Click(Sender: Tobject);
    Procedure ToolButton4Click(Sender: Tobject);
    Procedure ToolButton6Click(Sender: Tobject);
    Procedure ListView1ColumnClick(Sender: Tobject; Column: TListColumn);
    Procedure ListView1Compare(Sender: Tobject; Item1, Item2: TListItem;
      Data: Integer; Var Compare: Integer);
    Procedure FormDockOver(Sender: Tobject; Source: TDragDockObject; x,
      y: Integer; State: TDragState; Var Accept: Boolean);
    Procedure Panel2DockOver(Sender: Tobject; Source: TDragDockObject; x,
      y: Integer; State: TDragState; Var Accept: Boolean);
    Procedure Panel2DockDrop(Sender: Tobject; Source: TDragDockObject; x,
      y: Integer);
    Procedure Panel3DockDrop(Sender: Tobject; Source: TDragDockObject; x,
      y: Integer);
    Procedure ListView1Click(Sender: Tobject);
    Procedure FormCreate(Sender: Tobject);
    Procedure tbtnHelpClick(Sender: Tobject);
    Procedure Panel2UnDock(Sender: Tobject; Client: TControl;
      NewTarget: TWinControl; Var Allow: Boolean);
    Procedure Panel3UnDock(Sender: Tobject; Client: TControl;
      NewTarget: TWinControl; Var Allow: Boolean);
    Procedure tbutDockClick(Sender: Tobject);
    Procedure sdtfrChange(Sender: Tobject);
    Procedure sdttoChange(Sender: Tobject);
    Procedure dtpwdttoChange(Sender: Tobject);
    Procedure dtpwdtfrChange(Sender: Tobject);
    Procedure LastOrAny(Sender: Tobject);
    procedure btnConfigurationsClick(Sender: TObject);
    procedure btnApplyWrksConfigsClick(Sender: TObject);
    procedure FormPaint(Sender: TObject);
  Private
    Procedure GetSessionDates(Var Dtfr, Dtto: String);
    Procedure DockUnDock;
    procedure LoadListView(Vconfiglist: TStrings);
    procedure loadWrksConfigs;

  Public
    IsInitialized : boolean;
    procedure MaggSysSessionDisplay(var t: Tstringlist; Sess: Integer);
    Procedure DataToListView(Var DataL: Tstringlist; Var LV: TListView; Desc: String);
    { Public declarations }
  End;

Var
  MagWrksListForm: TMagWrksListForm;
Const
  curColumnindex: Integer = 0;
Const
  Inverse: Boolean = False;
Implementation

Uses //Magsysu,
  MagSessionInfo,
  MagProgress;

{$R *.DFM}

Procedure TMagWrksListForm.DataToListView(Var DataL: Tstringlist; Var LV: TListView; Desc: String);
Var
  i, j: Integer;
  s: String;
Begin
  s := DataL[0];
//lv.AllocBy:=DataL.count;
  StatusBar1.Panels[0].Text := Inttostr(DataL.Count - 1);
  StatusBar1.Panels[1].Text := Desc;
//lbCount.caption := '  '+inttostr(DataL.count-1)+ ' Workstations.'  ;
  LV.Items.Clear;
  If (LV.Columns.Count < 2) Then
  Begin
    LV.Columns.Clear;
    LV.Items.Clear;

    LV.Columns.Add;
    LV.Columns[0].caption := 'Workstation  [ Current User ]';
    LV.Columns[0].Width := -1;

    For i := 1 To Maglength(s, '^') - 1 Do
    Begin
      LV.Columns.Add;
      LV.Columns[i].caption := MagPiece(s, '^', i + 1);
      LV.Columns[i].Width := -2;
    End;
  End;
  DataL.Delete(0);
  MagProgressform.gauge1.minvalue := 0;
  MagProgressform.gauge1.maxvalue := Datal.Count - 1;
  MagProgressform.Show;
  Try
    For i := 0 To DataL.Count - 1 Do
    Begin
      s := DataL[i];
      MagProgressform.gauge1.progress := i;
      LV.Items.Add;
      If (Uppercase(MagPiece(s, '^', 4)) = 'ACTIVE') Then
      Begin
        LV.Items[i].StateIndex := 4;
        LV.Items[i].caption := MagPiece(s, '^', 1) + ' [' + MagPiece(s, '^', 3) + ']';
      End
      Else
        LV.Items[i].caption := MagPiece(s, '^', 1);

    //lv.items[i].caption := magpiece(s,'^',1);
      LV.Items[i].ImageIndex := 0;

      For j := 2 To Maglength(s, '^') Do
        LV.Items[i].SubItems.Add(MagPiece(s, '^', j));
    End;
  Finally
    MagProgressform.Hide;
  End;
End;

Procedure TMagWrksListForm.ToolButton1Click(Sender: Tobject);
Begin
  ListView1.ViewStyle := VsIcon;
End;

Procedure TMagWrksListForm.ToolButton2Click(Sender: Tobject);
Begin
  ListView1.ViewStyle := Vsreport;
End;

Procedure TMagWrksListForm.ToolButton3Click(Sender: Tobject);
Begin
  ListView1.ViewStyle := Vslist;
End;

Procedure TMagWrksListForm.Listview2Click(Sender: Tobject);
Begin
  ListView1.ViewStyle := Vslist;
End;

Procedure TMagWrksListForm.Iconview1Click(Sender: Tobject);
Begin
  ListView1.ViewStyle := VsIcon;
End;

Procedure TMagWrksListForm.Detailview1Click(Sender: Tobject);
Begin
  ListView1.ViewStyle := Vsreport;
End;

Procedure TMagWrksListForm.ToolButton4Click(Sender: Tobject);
Begin
  If FontDialog1.Execute Then ListView1.Font := FontDialog1.Font;
End;

Procedure TMagWrksListForm.ToolButton6Click(Sender: Tobject);
Begin
  FrmConfigList.NewUpdateTheWrksList;
End;

Procedure TMagWrksListForm.ListView1ColumnClick(Sender: Tobject;
  Column: TListColumn);
Begin
  Inverse := Not Inverse;
  curcolumnindex := Column.Index;
  ListView1.CustomSort(Nil, 0);
End;

Procedure TMagWrksListForm.ListView1Compare(Sender: Tobject; Item1,
  Item2: TListItem; Data: Integer; Var Compare: Integer);

Var
  Lic1, Lic2: String;
Begin
  If curcolumnindex = 0 Then
  Begin
    Lic1 := Item1.caption;
    Lic2 := Item2.caption;
  End
  Else
  Begin
    Lic1 := Item1.SubItems[curcolumnindex - 1];
    Lic2 := Item2.SubItems[curcolumnindex - 1];
  End;

(*Result := -lstrcmp(PChar(TListItem(Item1).Caption),
                     PChar(TListItem(Item2).Caption));*)
  If Inverse Then
    Compare := -Lstrcmp(PChar(Lic1), PChar(Lic2))
  Else
    Compare := Lstrcmp(PChar(Lic1), PChar(Lic2));
  Exit;
End;

Procedure TMagWrksListForm.FormDockOver(Sender: Tobject;
  Source: TDragDockObject; x, y: Integer; State: TDragState;
  Var Accept: Boolean);
Begin
  Accept := True;
End;

procedure TMagWrksListForm.FormPaint(Sender: TObject);
begin
if IsInitialized then exit;
IsInitialized := true;
loadWrksConfigs;
end;

Procedure TMagWrksListForm.Panel2DockOver(Sender: Tobject;
  Source: TDragDockObject; x, y: Integer; State: TDragState;
  Var Accept: Boolean);
Begin
  Accept := True;
End;

Procedure TMagWrksListForm.Panel2DockDrop(Sender: Tobject;
  Source: TDragDockObject; x, y: Integer);
Begin
  Panel2.Height := Trunc(2 / 3 * (MagWrksListForm.ClientHeight));
//panel3.width := 10;
End;

Procedure TMagWrksListForm.Panel3DockDrop(Sender: Tobject;
  Source: TDragDockObject; x, y: Integer);
Begin
  Panel3.Width := Trunc(2 / 3 * (MagWrksListForm.ClientWidth));
//panel2.height := 10;
End;

Procedure TMagWrksListForm.GetSessionDates(Var Dtfr, Dtto: String);
Var
  s, S1: String;
Begin
  Dtfr := '0';
  Dtto := '0';
  DateTimeToString(s, 'yyyy', sdtfr.Date);
  DateTimeToString(S1, 'mmdd', sdtfr.Date);
  Dtfr := Inttostr(Strtoint(s) - 1700) + S1;

  DateTimeToString(s, 'yyyy', Sdtto.Date);
  DateTimeToString(S1, 'mmdd', Sdtto.Date);
  Dtto := Inttostr(Strtoint(s) - 1700) + S1;

End;

Procedure TMagWrksListForm.ListView1Click(Sender: Tobject);
Var
  Wrksien: String;
  Dtto, Dtfr, s: String;
  t: Tstringlist;
  i: Integer;
  TLI: TListItem;
Begin
  GetSessionDates(Dtfr, Dtto);
  TLI := ListView1.Selected;
  If (TLI = Nil) Then Exit;
  i := TLI.SubItems.Count;
  Wrksien := TLI.SubItems[i - 1];

  t := Tstringlist.Create;
  Try
    // if not broker.connected then exit;
    xBrokerx.PARAM[0].Value := Wrksien + '^' + Dtfr + '^' + Dtto;
    xBrokerx.PARAM[0].PTYPE := LITERAL;
    xBrokerx.REMOTEPROCEDURE := 'MAGG SYS WRKS SESSIONS';

    xBrokerx.LstCALL(t);
    If ((t.Count = 0) Or (MagPiece(t[0], '^', 1) = '0')) Then
      StatusBar1.Panels[2].Text := 'No session info to display'
    Else
    Begin
      s := ' from ' + editsdtfr.Text + ' to ' + editsdtto.Text;
      MagSessionInfoForm.DataToSessionView(t, s);
    End;
  Finally
    t.Free;
  End;
  loadWrksConfigs;
End;

Procedure TMagWrksListForm.MaggSysSessionDisplay(Var t: Tstringlist; Sess: Integer);
Begin
  xBrokerx.PARAM[0].Value := Inttostr(Sess);
  xBrokerx.PARAM[0].PTYPE := LITERAL;
  xBrokerx.REMOTEPROCEDURE := 'MAGG SYS SESSION DISPLAY';
  xBrokerx.LstCALL(t);
End;

Procedure TMagWrksListForm.FormCreate(Sender: Tobject);
Begin
IsInitialized := false;
mlvl1.Align := alclient;
  ListView1.Align := alClient;
     // sdtfr.Date := IncDay(FrmConfigList.dDtto.Date, -7);
  sdtfr.Date :=    FrmConfigList.dDtfr.Date;
  Sdtto.Date := FrmConfigList.dDtto.Date;
  DockUnDock;
End;

Procedure TMagWrksListForm.tbtnHelpClick(Sender: Tobject);
Begin
//  Application.helpjump('Imaging_Workstation_Tracking');
 magexecutefile('magsys.hlp', '', '', SW_SHOW);
End;

Procedure TMagWrksListForm.DockUnDock;
Var
  Size: Trect;
  fw, w3 : integer;
Begin
  Size.Left := 100;
  Size.Right := 500;
  Size.Bottom := 400;
  Size.Top := 100;

  If ((MagWrksListForm.Panel3.DockClientCount = 0) And
    (MagWrksListForm.Panel2.DockClientCount = 0)) Then
  Begin
    MagSessionInfoForm.ManualDock(Panel3, Nil, alClient);
    MagSessioninfoForm.Visible := True;
     fw := magWrksListForm.width;
     w3 := trunc(fw div 3);
     panel3.Width := w3; //.Width := w3;
     panel6.Width := w3;
     magWrksListForm.Width := magwrkslistform.Width + 1;
     magWrksListForm.Update;

    Exit;
  End;
  If (MagWrksListForm.Panel3.DockClientCount > 0) Then
  Begin
    MagSessionInfoForm.ManualDock(Panel2, Nil, alClient);
    MagSessioninfoForm.Visible := True;
    Exit;
  End;
  MagSessionInfoform.ManualFloat(Size);
//Panel3.Width := 10;
//Panel2.height := 10;
End;

Procedure TMagWrksListForm.Panel2UnDock(Sender: Tobject; Client: TControl;
  NewTarget: TWinControl; Var Allow: Boolean);
Begin
  Panel2.Height := 10;
End;

Procedure TMagWrksListForm.Panel3UnDock(Sender: Tobject; Client: TControl;
  NewTarget: TWinControl; Var Allow: Boolean);
Begin
  Panel3.Width := 10;
End;

Procedure TMagWrksListForm.tbutDockClick(Sender: Tobject);
Begin
  DockUnDock;
End;

Procedure TMagWrksListForm.sdtfrChange(Sender: Tobject);
Var
  s: String;
Begin
  DateTimeToString(s, 'ddd mmm dd, yyyy', sdtfr.Date);
  editsdtfr.Text := s;
End;

Procedure TMagWrksListForm.sdttoChange(Sender: Tobject);
Var
  s: String;
Begin
  DateTimeToString(s, 'ddd mmm dd, yyyy', Sdtto.Date);
  editsdtto.Text := s;
End;

Procedure TMagWrksListForm.dtpwdttoChange(Sender: Tobject);
Var
  s: String;
Begin
  DateTimeToString(s, 'ddd mmm dd, yyyy', dtpwdtto.Date);
  editwdtto.Text := s;
End;

Procedure TMagWrksListForm.dtpwdtfrChange(Sender: Tobject);
Var
  s: String;
Begin
  DateTimeToString(s, 'ddd mmm dd, yyyy', dtpwdtfr.Date);
  editwdtfr.Text := s;
End;

procedure TMagWrksListForm.loadWrksConfigs();
 Var
  i: Integer;
  Tempini: TIniFile;
  s: String;
  vini : string;
  configlist : Tstrings;
Begin
configlist := Tstringlist.Create;
i := listview1.ItemIndex + 1;
vini := 'C:\Documents and Settings\All Users\Application Data\vista\imaging\mag' + inttostr(i) + '.ini';
 Tempini := TiniFile.create(vINI) ;
  Try
  // clear the current list of configurations.
    configlist.Clear;

    i := 1;
    While Tempini.ReadString('SYS_CONFIGURATIONS', Inttostr(i), 'NOBUTTON') <> 'NOBUTTON' Do
    Begin
     // p59t14    Fconfiglist.add(tempini.readstring('SYS_CONFIGURATIONS', inttostr(i), 'NOBUTTON'));
      s := Tempini.ReadString('SYS_CONFIGURATIONS', Inttostr(i), 'NOBUTTON');
      configlist.Add(s);
      Inc(i);
     end;
    LoadListView(configlist);
  Finally
    Tempini.Free;
  End;

(* Var
  Wrksien: String;
  Dtto, Dtfr, s: String;
  t: Tstringlist;
  i: Integer;
  TLI: TListItem;
  //
  WrksName : string;
    DATA : STRING;
Begin
MLVL1.ClearItems;
mlvl1.Update;
  GetSessionDates(Dtfr, Dtto);
  TLI := ListView1.Selected;
  If (TLI = Nil) Then Exit;
  i := TLI.SubItems.Count;
  Wrksien := TLI.SubItems[i - 1];
  WrksName := TLI.Caption;

  t := Tstringlist.Create;
  Try
    // if not broker.connected then exit;
    if uppercase(WrksName)='ISW-KIRIN-LT' then DATA := '1'
      ELSE DATA := '2';

    xBrokerx.PARAM[0].Value := DATA;
    xBrokerx.PARAM[0].PTYPE := LITERAL;
    xBrokerx.REMOTEPROCEDURE := 'MAGG SYS WRKS CONFIGS';

    xBrokerx.LstCALL(t);
    If ((t.Count = 0) Or (MagPiece(t[0], '^', 1) = '0')) Then
      StatusBar1.Panels[2].Text := 'No Configuration info to display'
    Else
    Begin
      s := ' from ' + editsdtfr.Text + ' to ' + editsdtto.Text;
//   MagSessionInfoForm.DataToSessionView(t, s);
    loadlistview(t);
    End;
  Finally
    t.Free;
  End;  *)
end;
Procedure TMagWrksListForm.LoadListView(Vconfiglist: TStrings);
//var i, j: integer;
//  Li: Tlistitem;
Begin
  Vconfiglist.Insert(0, 'Configuration^Source^Format^Association^Single/Group^Mode^Other');
  MLVL1.LoadListFromStrings(Vconfiglist);
  Vconfiglist.Delete(0);
  Exit;
(*  lvwCfgList.Items.clear;
  lvwCfgList.AllocBy := configlist.count;
  for I := 0 to configlist.count - 1 do
    begin

      Li := lvwCfgList.Items.Add;
    // we start from $p 2 because 1 is always '';
      Li.Caption := magpiece(configlist[i], '^', 1);
    // below is where we were adding extra subitems to existing LI
      for J := 2 to 7 do // 00t 6/1/02 8 ->  11, 8 for LockedFlds, 9-11 for indexFlds
      // 9/28/02    12 for image desc
        begin
          Li.SubItems.Add(magpiece(configlist[i], '^', j));
        end;
    end;
  StatusBar1.panels[0].text := inttostr(configlist.count) + ' stored Configurations';
  lvwCfgList.visible := true;
*)
End;

procedure TMagWrksListForm.btnApplyWrksConfigsClick(Sender: TObject);
var i : integer;
wrks : string;
begin
 i := listview1.ItemIndex;
 if i = -1 then
 begin
    showmessage('You must select a Workstation');
    exit;
 end;
wrks := listview1.Items[i].Caption;
i := i + 1;
frmConfigList.Show;
frmConfigList.GetSavedConfigs('C:\Documents and Settings\All Users\Application Data\vista\imaging\mag' + inttostr(i) + '.ini',wrks);
MagWrksListForm.Close;
end;

procedure TMagWrksListForm.btnConfigurationsClick(Sender: TObject);
begin
mlvl1.ClearItems;
loadWrksConfigs;
end;

Procedure TMagWrksListForm.LastOrAny(Sender: Tobject);
Begin
  FrmConfigList.rbanylogon.Checked := rbany.Checked;
  FrmConfigList.rblastlogon.Checked := rblast.Checked;
End;

End.
