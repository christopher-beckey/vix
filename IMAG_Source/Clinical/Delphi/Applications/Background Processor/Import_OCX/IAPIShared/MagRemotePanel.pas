Unit MagRemotePanel;

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
  ExtCtrls,
  Magremoteinterface,
  Stdctrls,
  FMagRIVConfig,
  Menus,
  cMagUtils;

Type
  TfMagRemotePanel = Class(TFrame, cMagRemoteInterface)
    PRIV: Tpanel;
    Button1: TButton;
    PopupMenu1: TPopupMenu;
    MnuCloseConnection: TMenuItem;
    MnuOpenConnection: TMenuItem;
    MnuSiteName: TMenuItem;
    MnuBar1: TMenuItem;
    Procedure Button1Click(Sender: Tobject);
    Procedure MnuCloseConnectionClick(Sender: Tobject);
    Procedure MnuOpenConnectionClick(Sender: Tobject);
  Private
    { Private declarations }
    SitePreferences: TStrings;

    Procedure DeactivateAll();
    Procedure AddOrSetActive(Value: String);
    Procedure AddOrSetInactive(Value: String);
    Procedure AddOrSetDisconnected(Value: String);

    Procedure RemoveAll();
    Procedure RemoveSite(Value: String);

    Procedure CreatePanel(ColorType: Integer; Value: String);
    Procedure SetImageCount(Value: String);

    Procedure PanelClick(Sender: Tobject);
    Procedure MouseUp(Sender: Tobject; Button: TMouseButton; Shift: TShiftState; x, y: Integer);

  Public
    Procedure RIVRecieveUpdate_(action: String; Value: String); // recieve updates from everyone

    Procedure SetSitePreferences(TSitePreferences: TStrings);
    { Public declarations }
  End;

Const
  COLOR_ACTIVE = clGreen;
Const
  COLOR_INACTIVE = clYellow; // $004080FF;
Const
  COLOR_DISCONNECTED = clRed;

Procedure Register;

Var
  MagUtilities: TMagUtils;

Implementation

{$R *.dfm}

Procedure Register;
Begin
  RegisterComponents('Imaging', [TfMagRemotePanel]);
End;

Procedure TfMagRemotePanel.SetSitePreferences(TSitePreferences: TStrings);
Begin
  SitePreferences := TSitePreferences;
End;

Procedure TfMagRemotePanel.RemoveAll();
Begin
  While PRIV.ControlCount > 0 Do
  Begin
    PRIV.RemoveControl(PRIV.Controls[0]);
  End;
End;

Procedure TfMagRemotePanel.RemoveSite(Value: String);
Var
  i: Integer;
  NewPanel: Tpanel;
Begin
  For i := 0 To PRIV.ControlCount - 1 Do
  Begin
    NewPanel := Tpanel(PRIV.Controls[i]);
    If NewPanel.caption = Value Then
    Begin
      PRIV.RemoveControl(PRIV.Controls[i]);
      Exit;
    End;

  End;

End;

Procedure TfMagRemotePanel.DeactivateAll();
Var
  i: Integer;
  NewPanel: Tpanel;
Begin
  For i := 0 To PRIV.ControlCount - 1 Do
  Begin
    NewPanel := Tpanel(PRIV.Controls[i]);
    If NewPanel.Font.Color <> COLOR_DISCONNECTED Then
    Begin
      NewPanel.Font.Color := COLOR_INACTIVE;
    End;
  End;
End;

Procedure TfMagRemotePanel.CreatePanel(ColorType: Integer; Value: String);
Var
  NewPanel: Tpanel;
Begin
  NewPanel := Tpanel.Create(Self);
  NewPanel.caption := Value;
  NewPanel.Width := Length(Value) * 8;
  NewPanel.Font.Color := ColorType;
  NewPanel.Font.Style := [Fsbold];

  NewPanel.Align := alLeft;
//  newPanel.OnClick := PanelClick;
  NewPanel.OnMouseUp := MouseUp;
  PRIV.InsertControl(NewPanel);
//  newpanel.PopupMenu := popupmenu1;

End;

Procedure TfMagRemotePanel.MouseUp(Sender: Tobject; Button: TMouseButton; Shift: TShiftState; x, y: Integer);
Begin
  If Button <> Mbright Then Exit;
  With Sender As Tpanel Do
  Begin
    //showmessage(caption);
    MnuSiteName.caption := caption;
    If Font.Color = COLOR_ACTIVE Then
    Begin
      MnuCloseConnection.Enabled := True; // allow user to close the connection
      MnuOpenConnection.Enabled := False; // don't allow the user to open the connection
    End
    Else
      If Font.Color = COLOR_INACTIVE Then
      Begin
        MnuCloseConnection.Enabled := True; // allow user to close the connection
        MnuOpenConnection.Enabled := False; // don't allow the user to open the connection

      End
      Else
        If Font.Color = COLOR_DISCONNECTED Then
        Begin
          MnuCloseConnection.Enabled := False; // don't allow user to close the connection
          MnuOpenConnection.Enabled := True; // allow the user to open the connection
        End;
    PopupMenu1.Popup(Left + x, Self.Top + y + PRIV.Height);
  End;

End;

Procedure TfMagRemotePanel.PanelClick(Sender: Tobject);
Begin
  With Sender As Tpanel Do
  Begin
    //showmessage(caption);
    MnuSiteName.caption := caption;
    MnuSiteName.Visible := True;
    If Font.Color = COLOR_ACTIVE Then
    Begin
      MnuCloseConnection.Enabled := True;
      MnuOpenConnection.Enabled := False;
    End
    Else
      If Font.Color = COLOR_INACTIVE Then
      Begin
        MnuCloseConnection.Enabled := False;
        MnuOpenConnection.Enabled := False;

      End
      Else
        If Font.Color = COLOR_DISCONNECTED Then
        Begin
          MnuCloseConnection.Enabled := False;
          MnuOpenConnection.Enabled := True;
        End;
  End;
End;

Procedure TfMagRemotePanel.AddOrSetActive(Value: String);
Var
  i: Integer;
  NewPanel: Tpanel;
Begin
  For i := 0 To PRIV.ControlCount - 1 Do
  Begin
    NewPanel := Tpanel(PRIV.Controls[i]);
    If NewPanel.caption = Value Then
    Begin
      NewPanel.Font.Color := COLOR_ACTIVE;
      Exit;
    End;
  End;
  CreatePanel(COLOR_ACTIVE, Value);
  {
  newPanel := TPanel.create(self);
  newPanel.Caption := Value;
  newPanel.align := alLeft;
  newPanel.Font.Color := COLOR_ACTIVE;
  newPanel.Font.Style := [fsBold];
  pRIV.InsertControl(newPanel);
  }
End;

Procedure TfMagRemotePanel.AddOrSetInactive(Value: String);
Var
  i: Integer;
  NewPanel: Tpanel;
Begin
  For i := 0 To PRIV.ControlCount - 1 Do
  Begin
    NewPanel := Tpanel(PRIV.Controls[i]);
    If NewPanel.caption = Value Then
    Begin
      NewPanel.Font.Color := COLOR_INACTIVE;
      Exit;
    End;
  End;
  CreatePanel(COLOR_INACTIVE, Value);
  {
  newPanel := TPanel.create(self);
  newPanel.Caption := Value;
  newPanel.align := alLeft;
  newPanel.Font.Color := COLOR_INACTIVE;
  newPanel.Font.Style := [fsBold];
  pRIV.InsertControl(newPanel);
  }
End;

Procedure TfMagRemotePanel.AddOrSetDisconnected(Value: String);
Var
  i: Integer;
  NewPanel: Tpanel;
Begin
  For i := 0 To PRIV.ControlCount - 1 Do
  Begin
    NewPanel := Tpanel(PRIV.Controls[i]);
    If NewPanel.caption = Value Then
    Begin
      NewPanel.Font.Color := COLOR_DISCONNECTED;
      Exit;
    End;
  End;

  CreatePanel(COLOR_DISCONNECTED, Value);
  {
  newPanel := TPanel.create(self);
  newPanel.Caption := Value;
  newPanel.align := alLeft;
  newPanel.Font.Color := clRed;
  newPanel.Font.Style := [fsBold];
  pRIV.InsertControl(newPanel);
  }
End;

Procedure TfMagRemotePanel.RIVRecieveUpdate_(action: String; Value: String);
Begin

  If action = 'AddActive' Then
  Begin
    AddOrSetActive(Value);
  End
  Else
    If action = 'AddDisconnected' Then
    Begin
      AddOrSetDisconnected(Value);
    End
    Else
      If action = 'SetDisconnected' Then
      Begin
        AddOrSetDisconnected(Value);
      End
      Else
        If action = 'DeactivateAll' Then
        Begin
    // consider adding logic so if the site is disconnected, then they are not reset, only connected sites are changed.
          DeactivateAll();
        End
        Else
          If action = 'SetInactive' Then
          Begin
            AddOrSetInactive(Value);

          End
          Else
            If action = 'SetActive' Then
            Begin
              AddOrSetActive(Value);
            End
            Else
              If action = 'RemoveAll' Then
              Begin
                RemoveAll();
              End
              Else
                If action = 'RemoveSite' Then
                Begin
                  RemoveSite(Value);
                End
                Else
                  If action = 'SetImageCount' Then
                  Begin
                    SetImageCount(Value);
                  End;
End;

Procedure TfMagRemotePanel.SetImageCount(Value: String);
Var
  i, ImageCount: Integer;
  SiteName: String;
  TempPanel: Tpanel;
Begin
  SiteName := MagUtilities.MagPiece(Value, '^', 1);
  ImageCount := Strtoint(MagUtilities.MagPiece(Value, '^', 2));

  For i := 0 To PRIV.ControlCount - 1 Do
  Begin
    TempPanel := Tpanel(PRIV.Controls[i]);
    If MagUtilities.MagPiece(TempPanel.caption, '(', 1) = SiteName Then
    Begin
      TempPanel.caption := SiteName + ' (' + Inttostr(ImageCount) + ')';
      TempPanel.Width := Length(TempPanel.caption) * 8;
      Exit;
    End;
  End;
//
End;

Procedure TfMagRemotePanel.Button1Click(Sender: Tobject);
Var
  ConfigForm: TfrmRIVConfig;
  ConnectedSites, DisconnectedSites: TStrings;
  i: Integer;
  TempPanel: Tpanel;
Begin
  ConnectedSites := Tstringlist.Create();
  DisconnectedSites := Tstringlist.Create();

  For i := 0 To PRIV.ControlCount - 1 Do
  Begin
    TempPanel := Tpanel(PRIV.Controls[i]);

    If TempPanel.Font.Color = COLOR_DISCONNECTED Then
    Begin
      DisconnectedSites.Add(TempPanel.caption);
    End
    Else
    Begin
      ConnectedSites.Add(TempPanel.caption);
    End;
  End;

  ConfigForm := TfrmRIVConfig.Create(Self);
  ConfigForm.Execute(ConnectedSites, DisconnectedSites);

End;

Procedure TfMagRemotePanel.MnuCloseConnectionClick(Sender: Tobject);
Var
  SiteName: String;
Begin
  SiteName := MnuSiteName.caption;
  If (Pos('&', SiteName) = 1) Then SiteName := Copy(MnuSiteName.caption, 2, Length(SiteName));
  RIVNotifyAllListeners(Self, 'SetDisconnected', SiteName);
  AddOrSetDisconnected(SiteName); // this maybe should not be here?  maybe brokerManager should send a message when it is disconnected to change this status?
End;

Procedure TfMagRemotePanel.MnuOpenConnectionClick(Sender: Tobject);
Var
  SiteName: String;
Begin
  SiteName := MnuSiteName.caption;
  If (Pos('&', SiteName) = 1) Then SiteName := Copy(MnuSiteName.caption, 2, Length(SiteName));
  RIVNotifyAllListeners(Self, 'SetConnected', SiteName);

End;

End.
