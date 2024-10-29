Unit FMagRIVConfig;

Interface

Uses
  Windows,
  Messages,
  SysUtils,
  Variants,
  Classes,
  Graphics,
  Controls,
  Forms,
  Dialogs,
  Stdctrls,
  Magremoteinterface,
  ComCtrls,
  VHASites;

Type
  TfrmRIVConfig = Class(TForm, cMagRemoteInterface)
    GrpConnected: TGroupBox;
    LstConnected: TListBox;
    btnDisconnect: TButton;
    btnClose: TButton;
    GrpDisconnected: TGroupBox;
    LstDisconnected: TListBox;
    btnConnect: TButton;
    GrpSiteDetails: TGroupBox;
    LstSites: TListView;
    GrpNeverConnectSites: TGroupBox;
    Label1: Tlabel;
    EdtSiteCode: TEdit;
    EdtSiteName: TEdit;
    btnLookupSiteName: TButton;
    btnAddNeverConnectSite: TButton;
    Procedure btnDisconnectClick(Sender: Tobject);
    Procedure btnCloseClick(Sender: Tobject);
    Procedure btnConnectClick(Sender: Tobject);
    Procedure btnLookupSiteNameClick(Sender: Tobject);
  Private
    Procedure RemoveDisconnected(SiteName: String);
    Procedure AddSiteToList(SiteName, Sitecode, Status, AlwaysConnect, NeverConnect: String);
    { Private declarations }
  Public

    Procedure Execute(ConnectedSites: TStrings; DisconnectedSites: TStrings);

    Procedure RIVRecieveUpdate_(action: String; Value: String); // recieve updates from everyone
    { Public declarations }
  End;

Var
  FrmRIVConfig: TfrmRIVConfig;

Implementation

{$R *.dfm}

Procedure TfrmRIVConfig.Execute(ConnectedSites: TStrings; DisconnectedSites: TStrings);
Var
  i: Integer;
Begin

  LstConnected.Items := ConnectedSites;
  LstDisconnected.Items := DisconnectedSites;

  For i := 0 To ConnectedSites.Count - 1 Do
  Begin
    AddSiteToList(ConnectedSites.Strings[i], 'Code', 'Connected', 'No', 'No');
  End;
  For i := 0 To DisconnectedSites.Count - 1 Do
  Begin
    AddSiteToList(DisconnectedSites.Strings[i], 'Code', 'Disconnected', 'No', 'No');
  End;

  RIVAttachListener(Self);
 // RIV Attach_();
  Showmodal();
  RIVDetachListener(Self);

End;

Procedure TfrmRIVConfig.RIVRecieveUpdate_(action: String; Value: String); // recieve updates from everyone
Begin

  If action = 'SetActive' Then
  Begin
    RemoveDisconnected(Value);
    LstConnected.Items.Add(Value);

  End;
End;

Procedure TfrmRIVConfig.RemoveDisconnected(SiteName: String);
Var
  i: Integer;
Begin
  For i := 0 To LstDisconnected.Items.Count - 1 Do
  Begin
    If LstDisconnected.Items[i] = SiteName Then
    Begin
      LstDisconnected.Items.Delete(i);
      Exit;
    End;
  End;
End;

Procedure TfrmRIVConfig.btnDisconnectClick(Sender: Tobject);
Begin
//  if listbox1.ItemIndex <= 0 then exit;
  RIVNotifyAllListeners(Self, 'SetDisconnected', LstConnected.Items[LstConnected.ItemIndex]);
  LstDisconnected.Items.Add(LstConnected.Items[LstConnected.ItemIndex]);
  LstConnected.Items.Delete(LstConnected.ItemIndex);

End;

Procedure TfrmRIVConfig.btnCloseClick(Sender: Tobject);
Begin
  ModalResult := MrOK;
End;

Procedure TfrmRIVConfig.btnConnectClick(Sender: Tobject);
Begin
  RIVNotifyAllListeners(Self, 'SetConnected', LstDisconnected.Items[LstDisconnected.ItemIndex]); //  SiteName);
//  showmessage('Right now this does nothing...' + #13 + 'This should update the panel and tell the BrokerManager to connect and if that works, then update the panel, if there is a problem connected it should again update the panel.');
End;

Procedure TfrmRIVConfig.AddSiteToList(SiteName, Sitecode, Status, AlwaysConnect, NeverConnect: String);
Var
  LstItem: TListItem;

Begin
  LstItem := TListItem.Create(LstSites.Items);
  LstItem := LstSites.Items.Add();
  LstItem.caption := Sitecode;
  LstItem.SubItems.Add(SiteName);
  LstItem.SubItems.Add(Status);
  LstItem.SubItems.Add(AlwaysConnect);
  LstItem.SubItems.Add(NeverConnect);

  If Status <> 'Disconnected' Then
  Begin

  End;

//
End;

Procedure TfrmRIVConfig.btnLookupSiteNameClick(Sender: Tobject);
Var
  SiteData: SiteTO;
  SiteService: SiteServiceSoap;
Begin
  SiteService := GetSiteServiceSoap;
  SiteData := SiteService.GetSite(EdtSiteCode.Text);

  EdtSiteName.Text := SiteData.Name;

End;

End.
