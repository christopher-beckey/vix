Unit MagRemoteToolbar;
(*
        ;; +---------------------------------------------------------------------------------------------------+
        ;;  MAG - IMAGING
        ;;  Property of the US Government.
        ;;  WARNING: Pe VHA Directive xxxxxx, this unit should not be modified.
        ;;  No permission to copy or redistribute this software is given.
        ;;  Use of unreleased versions of this software requires the user
        ;;  to execute a written test agreement with the VistA Imaging
        ;;  Development Office of the Department of Veterans Affairs,
        ;;  telephone (301) 734-0100.
        ;;
        ;; The Food and Drug Administration classifies this software as
        ;; a Class II medical device.  As such, it may not be changed
        ;; in any way.  Modifications to this software may result in an
        ;; adulterated medical device under 21CFR820, the use of which
        ;; is considered to be a violation of US Federal Statutes.
        ;;
        ;;  Date created: May 2005
        ;;  Site Name:  Washington OI Field Office, Silver Spring, MD
        ;;  Developer:  Julian Werfel
        ;;  Description: This is a toolbar object displayed on the main Display
        ;;  window which shows the status of the sites the current patient has
        ;;  visited.
        ;;
        ;;+---------------------------------------------------------------------------------------------------+
*)

Interface

Uses
  Buttons,
  Classes,
  ComCtrls,
  Controls,
  ExtCtrls,
  Forms,
  Graphics,
  Magremoteinterface,
  MagRemotesite,
  ToolWin,
  Stdctrls
  ;

//Uses Vetted 20090929:StdCtrls, ToolWin, Dialogs, Variants, Messages, Windows, fMagRIVUserConfig, umagutils, SysUtils

Type
  TfMagRemoteToolbar = Class(TFrame, IMagRemoteinterface)
    PnlConfig: Tpanel;
    btnConfigure: TBitBtn;
    PToolbar: Tpanel;
    ToolBar1: TToolBar;
    Procedure btnConfigureClick(Sender: Tobject);
  Private
    FPrefstrings: TStrings; // p93 was userpreferences : Tstrings;

    RemoteSites: Array Of cMagRemoteToolbarSite;
    FForTeleReader: Boolean;

    Procedure DeactivateAll();
    Procedure AddOrSetActive(Value: String);
    Procedure AddOrSetInactive(Value: String);
    Procedure AddOrSetDisconnected(Value: String);

    Procedure RemoveAllPanels();
    Procedure RemoveSite(Value: String);

    Procedure DisconnectLocalSite();

    Procedure CreateButton(ButtonCaption: String; ButtonIndex: Integer; IsDisconnected: Boolean = False; btnLeft: Integer = 0);
    Procedure SetImageCount(Value: String);
    Procedure AddSite(Value: String);
    //procedure updateButtonCaption(SiteCode : String; NewCaption : String);
    Procedure UpdateButtonCaption(ButtonIndex: Integer; NewCaption: String; IsDisconnected: Boolean = False);
    Function RemoveSiteButton(Sitecode: String): Integer;

    Function GetButtonIndex(Sitecode: String): Integer;

    Procedure DisplayVisitedDisconnectedSites();
    Procedure DisplaySiteServiceFailure(ServiceURL: String);
    Procedure DisplaySiteServiceDisabled(); // occurs when the service has been marked disabled
    Procedure PanelClick(Sender: Tobject);
    Procedure SiteServiceDisabledClick(Sender: Tobject); //46
    Procedure AddAllButton();
    Procedure PanelAllClick(Sender: Tobject);
    Procedure PanelCancelClick(Sender: Tobject); //46
    Procedure DisconnectAll();
    Procedure CreateCancelButton(); //46
    Procedure RemoveCancelButton(); //46
    Procedure SetDisconnectedAndUpdate(Value: String); //72
    Procedure RemoveSitePanel(ButtonIndex: Integer); // 72
    Procedure SetSiteTimeoutException(Value: String); // 72
  Public
    Constructor Create(AOwner: TComponent); Override; //46
    Procedure RIVRecieveUpdate_(action: String; Value: String); // recieve updates from everyone
    Property ForTeleReader: Boolean Read FForTeleReader Write FForTeleReader; //46

    Procedure SetUserPreferences(VPrefstrings: TStrings); // p93 was tUserPreferences : Tstrings);

  End;

Procedure Register;
Function MagPiece(Str, Delim: String; Piece: Integer): String; // $Piece

Const
  COLOR_ACTIVE = clGreen;
Const
  COLOR_INACTIVE = clYellow; // $004080FF;
Const
  COLOR_DISCONNECTED = clRed;

Implementation
Uses
  FMagRIVUserConfig,
  SysUtils,
  UMagDefinitions,
  Umagutils8
  ;

{$R *.dfm}

Function MagPiece(Str, Delim: String; Piece: Integer): String;
Var
  i, k: Integer;
  s: String;
Begin
  i := Pos(Delim, Str);
  If (i = 0) And (Piece = 1) Then
  Begin
    Result := Str;
    Exit;
  End;
  For k := 1 To Piece Do
  Begin
    i := Pos(Delim, Str);
    If (i = 0) Then i := Length(Str) + 1;
    s := Copy(Str, 1, i - 1);
    Str := Copy(Str, i + 1, Length(Str));
  End;
  Result := s;
End;

Procedure Register;
Begin
  RegisterComponents('Imaging', [TfMagRemoteToolbar]);
End;

Constructor TfMagRemoteToolbar.Create(AOwner: TComponent);
Begin
  Inherited Create(AOwner);
  FForTeleReader := False;
End;

Procedure TfMagRemoteToolbar.SetUserPreferences(VPrefstrings: TStrings);
Begin
  FPrefstrings := VPrefstrings; // p93 was userpreferences := tUserPreferences;
End;

Procedure TfMagRemoteToolbar.RemoveAllPanels();
Begin
  While ToolBar1.ControlCount > 0 Do
  Begin
    ToolBar1.RemoveControl(ToolBar1.Controls[0]);
  End;
End;

Procedure TfMagRemoteToolbar.DisconnectLocalSite();
Var
  i, Count: Integer;
Begin
  RemoveAllPanels();
  Count := Length(RemoteSites);
  For i := 0 To Count - 1 Do
  Begin
    RemoteSites[i] := Nil;

  End;
  RemoteSites := Nil;
End;

Function TfMagRemoteToolbar.RemoveSiteButton(Sitecode: String): Integer;
Var
  i: Integer;
  NewButton: TBitBtn;
  ButtonIndex: Integer;
Begin
  If Sitecode = '' Then Exit;
  ButtonIndex := GetButtonIndex(Sitecode);
  If ButtonIndex = 0 Then Exit;
  For i := 0 To ToolBar1.ControlCount - 1 Do
  Begin
    NewButton := TBitBtn(ToolBar1.Controls[i]);
    If NewButton.Tag = ButtonIndex Then
//    if newButton.Tag = strtoint(SiteCode) then
    Begin
      Result := ToolBar1.Controls[i].Left;
      ToolBar1.RemoveControl(ToolBar1.Controls[i]);
      Exit;
    End;
  End;

End;

// no idea what this function really would be used for...?

Procedure TfMagRemoteToolbar.RemoveSite(Value: String);
Var
  i: Integer;
  NewButton: TBitBtn;
Begin
  For i := 0 To ToolBar1.ControlCount - 1 Do
  Begin
    NewButton := TBitBtn(ToolBar1.Controls[i]);
    If NewButton.caption = Value Then
    Begin
      ToolBar1.RemoveControl(ToolBar1.Controls[i]);
      Exit;
    End;

  End;

End;

Procedure TfMagRemoteToolbar.DeactivateAll();
Var
  i: Integer;
  Count: Integer;
Begin
  RemoveAllPanels(); // may not want to do this if it is slow, may want to only remove unused sites?
  Count := High(RemoteSites);
  For i := 0 To Count Do
  Begin
    RemoteSites[i].PatientVisited := False; // we always want to do this p45t2
    If RemoteSites[i].SiteStatus <> MagRemotesite.SITESTATUS_DISCONNECTED Then
    Begin
      RemoteSites[i].SiteStatus := SITESTATUS_INACTIVE;
      RemoteSites[i].ImageCount := 0;
    End;
  End;
  CreateCancelButton();
End;

Procedure TfMagRemoteToolbar.CreateCancelButton();
Var
  //newButton : TPanel;
  NewButton: TBitBtn;
  aSeparator: TToolButton;
Begin
  aSeparator := TToolButton.Create(Self);
  aSeparator.Style := TbsSeparator;
  aSeparator.Align := alLeft;
  aSeparator.Width := 1;
  aSeparator.Tag := -100;

  ToolBar1.InsertControl(aSeparator);

  //newButton := TPanel.Create(self);
  NewButton := TBitBtn.Create(Self);
  //newButton.BevelInner := bvlowered;
  NewButton.caption := 'Cancel Remote Connections';
  NewButton.ShowHint := True;
  NewButton.Font.Style := [Fsbold];
  NewButton.Onclick := PanelCancelClick;
  NewButton.Hint := 'Cancel further remote connections for current patient';
  NewButton.Width := Length(NewButton.caption) * 8;
  NewButton.Tag := -100;
  NewButton.Align := alLeft;
  NewButton.Height := ToolBar1.ClientHeight;
  ToolBar1.InsertControl(NewButton);
End;

//procedure TfMagRemoteToolbar.CreateButton(ColorType : integer; SiteName : String; SiteCode : String; ButtonIndex : integer);

Procedure TfMagRemoteToolbar.CreateButton(ButtonCaption: String; ButtonIndex: Integer; IsDisconnected: Boolean = False; btnLeft: Integer = 0);
Var
  NewButton: TBitBtn;
  NewPanel: Tpanel;
  //newButton : TPanel;
  aSeparator: TToolButton;
Begin
  aSeparator := TToolButton.Create(Self);
  aSeparator.Style := TbsSeparator;
  aSeparator.Align := alLeft;
  aSeparator.Width := 1;
  ToolBar1.InsertControl(aSeparator);

  //newButton.ShowHint := true;

  If IsDisconnected Then
  Begin
    NewButton := TBitBtn.Create(Self);
    NewButton.caption := ButtonCaption;
    NewButton.ShowHint := True;
    NewButton.Font.Color := COLOR_DISCONNECTED;
    NewButton.Onclick := PanelClick;
    NewButton.Font.Style := [FsStrikeOut, Fsbold];
    If FForTeleReader Then
      NewButton.Hint := 'User has selected this site but there is no connection to this site.'
    Else
      NewButton.Hint := 'Patient has been seen at this site but there is no connection.';
    NewButton.Width := Length(ButtonCaption) * 8;
    NewButton.Tag := ButtonIndex;
    NewButton.Align := alLeft;
    NewButton.Height := ToolBar1.ClientHeight;
    NewButton.TabStop := True;
    If btnLeft > 0 Then
      NewButton.Left := btnLeft;
    ToolBar1.InsertControl(NewButton);
  End
  Else
  Begin
    NewPanel := Tpanel.Create(Self);
    NewPanel.BevelInner := bvLowered;
    NewPanel.caption := ButtonCaption;
    NewPanel.ShowHint := True;
    NewPanel.Font.Color := COLOR_ACTIVE;
    NewPanel.Font.Style := [Fsbold];
    If FForTeleReader Then
      NewPanel.Hint := 'Active connection to this site'
    Else
      NewPanel.Hint := 'Patient has been seen at this site';
    NewPanel.Width := Length(ButtonCaption) * 8;
    NewPanel.Tag := ButtonIndex;
    NewPanel.Align := alLeft;
    NewPanel.Height := ToolBar1.ClientHeight;
    NewPanel.TabStop := True;
    If btnLeft > 0 Then
      NewPanel.Left := btnLeft;
    ToolBar1.InsertControl(NewPanel);
  End;
End;

Procedure TfMagRemoteToolbar.PanelCancelClick(Sender: Tobject);
Begin
  RIVNotifyAllListeners(Self, 'StopRemoteConnections', '');
End;

Procedure TfMagRemoteToolbar.SiteServiceDisabledClick(Sender: Tobject);
Begin
  RIVNotifyAllListeners(Self, 'RetrySiteService', '');
  RIVNotifyAllListeners(Self, 'RefreshPatient', '');
End;

Procedure TfMagRemoteToolbar.PanelClick(Sender: Tobject);
Var
  i: Integer;
  Sitecode: String;
  SiteCount: Integer;
  ButtonIndex: Integer;
Begin
  Sitecode := '';
  SiteCount := High(RemoteSites);

  With Sender As TBitBtn Do                        {brkpt 1}
  Begin
    ButtonIndex := Tag;
    For i := 0 To SiteCount Do
    Begin
      If RemoteSites[i].ButtonIndex = ButtonIndex Then
      Begin
        RIVNotifyAllListeners(Self, 'ReconnectSite', RemoteSites[i].Sitecode);
        RIVNotifyAllListeners(Self, 'RefreshPatient', '');
        Exit;
      End;
    End;
  End;
End;

//procedure TfMagRemoteToolbar.updateButtonCaption(SiteCode : String; NewCaption : String);

Procedure TfMagRemoteToolbar.UpdateButtonCaption(ButtonIndex: Integer; NewCaption: String; IsDisconnected: Boolean = False);
Var
  i: Integer;
  TempButton: TBitBtn;
  TempPanel: Tpanel;
Begin
  If ButtonIndex = 0 Then Exit;
  For i := 0 To ToolBar1.ControlCount - 1 Do
  Begin
    If ToolBar1.Controls[i] Is TBitBtn Then
    Begin
      TempButton := TBitBtn(ToolBar1.Controls[i]);
      If TempButton.Tag = ButtonIndex Then
      Begin
        TempButton.caption := NewCaption;
        If IsDisconnected Then
        Begin
          TempButton.Font.Style := [FsStrikeOut, Fsbold];
          TempButton.Font.Color := COLOR_DISCONNECTED;
          If FForTeleReader Then
            TempButton.Hint := 'User has selected this site but there is no connection to this site.'
          Else
            TempButton.Hint := 'Patient has been seen at this site but there is no connection.'
        End
        Else
        Begin
          TempButton.Font.Color := COLOR_ACTIVE;
          TempButton.Font.Style := [Fsbold];
          If FForTeleReader Then
            TempButton.Hint := 'Active connection to this site'
          Else
            TempButton.Hint := 'Patient has been seen at this site';
        End;

        TempButton.Width := Length(TempButton.caption) * 8;
        Exit;
      End;
    End
    Else
      If ToolBar1.Controls[i] Is Tpanel Then
      Begin
        TempPanel := Tpanel(ToolBar1.Controls[i]);
        If TempPanel.Tag = ButtonIndex Then
        Begin
          TempPanel.caption := NewCaption;
          If IsDisconnected Then
          Begin
            TempPanel.Font.Style := [FsStrikeOut, Fsbold];
            TempPanel.Font.Color := COLOR_DISCONNECTED;
            If FForTeleReader Then
              TempPanel.Hint := 'User has selected this site but there is no connection to this site.'
            Else
              TempPanel.Hint := 'Patient has been seen at this site but there is no connection.'
          End
          Else
          Begin
            TempPanel.Font.Color := COLOR_ACTIVE;
            TempPanel.Font.Style := [Fsbold];
            If FForTeleReader Then
              TempPanel.Hint := 'Active connection to this site'
            Else
              TempPanel.Hint := 'Patient has been seen at this site';
          End;
          TempPanel.Width := Length(TempPanel.caption) * 8;
          Exit;
        End;
      End;
    //tempButton := TStaticText(Toolbar1.Controls[i]);
  End;
  CreateButton(NewCaption, ButtonIndex, IsDisconnected);
End;

// Value = SiteCode^ImageCount

Procedure TfMagRemoteToolbar.SetImageCount(Value: String);
Var
  i, ImageCount: Integer;
  Sitecode: String;
  SiteCount: Integer;
  PartialResult: String; {/ P117 NCAT - JK 12/2/2010 /}
Begin
  Sitecode := MagPiece(Value, '^', 1);
  ImageCount := Strtoint(MagPiece(Value, '^', 2));
  PartialResult := MagPiece(Value, '^', 3);  {/ P117 NCAT - JK 12/2/2010 /}
  SiteCount := High(RemoteSites);

  For i := 0 To SiteCount Do
  Begin //--
    If RemoteSites[i].Sitecode = Sitecode Then
    Begin //0
      RemoteSites[i].ImageCount := ImageCount;

      // JMW 8/13/08 P72t26 - if image count is <= 0 and the user is hiding
      // empty remote sites, need to remove the button from the toolbar (if it
      // is there)
      If (ImageCount > 0) Or (Not Upref.RIVHideEmptySites) Or (ImageCount = -1) Then
      Begin //1
        If FForTeleReader Then
        Begin
          UpdateButtonCaption(RemoteSites[i].ButtonIndex,
            RemoteSites[i].SiteName);
        End
        Else
        Begin

          If ImageCount = -1 Then
            UpdateButtonCaption(RemoteSites[i].ButtonIndex,
              RemoteSites[i].SiteName + '(??)')
          Else
              UpdateButtonCaption(RemoteSites[i].ButtonIndex,
                RemoteSites[i].SiteName + '(' + Inttostr(ImageCount) + ')' + PartialResult); {/ P117 NCAT - JK 12/2/2010 /}
        End;
      End
      // JMW 8/13/08 p72 - if the image count is 0 and hiding empty sites,
      // remove the button (if it is on the toolbar).
      Else
        If (Upref.RIVHideEmptySites) And (ImageCount = 0) Then
        Begin
          RemoveSitePanel(RemoteSites[i].ButtonIndex);
        End; //1
      Exit;
    End; //0
  End; //--
End;

// Value = SiteCode

Procedure TfMagRemoteToolbar.AddOrSetActive(Value: String);
Var
  i: Integer;
  Count: Integer;
  SiteName, Sitecode: String;
//ButtonIndex : integer;
Begin
// JMW 6/14/2006 p46
// the value could be either a SiteCode or SiteCode^SiteName
// if includes site name, set site name for this connection (in case a
// connection was needed for 2nd division of site - (TeleReader))

  If Maglength(Value, '^') = 2 Then
  Begin
    Sitecode := MagPiece(Value, '^', 1);
    SiteName := MagPiece(Value, '^', 2);
  End
  Else
  Begin
    Sitecode := Value;
    SiteName := '';
  End;
  Count := High(RemoteSites);
  For i := 0 To Count Do
  Begin
    If RemoteSites[i].Sitecode = Sitecode Then
    Begin
      RemoteSites[i].SiteStatus := SITESTATUS_ACTIVE;
      RemoteSites[i].PatientVisited := True;
      If SiteName <> '' Then
        RemoteSites[i].SiteName := SiteName;
      {

      ButtonIndex := RemoteSites[i].ButtonIndex;
      for j := 0 to Toolbar1.ControlCount - 1 do
      begin
        newButton := TBitBtn(Toolbar1.Controls[j]);
        if newButton.tag = ButtonIndex then
        begin
          newButton.Font.color := COLOR_ACTIVE;
          exit;
        end;
      end;
      CreateButton(COLOR_ACTIVE, RemoteSites[i].SiteName, RemoteSites[i].SiteCode, RemoteSites[i].ButtonIndex);
      }
      Exit;
    End;
  End;
End;

Function TfMagRemoteToolbar.GetButtonIndex(Sitecode: String): Integer;
Var
  i, Count: Integer;
Begin
  Count := High(RemoteSites);
  //for i := 0 to count - 1 do
  // JMW 8/22/08 p72t26 - iterate through count (not count -1) since
  // high gets the highest value of the array, not the size of the array
  For i := 0 To Count Do
  Begin
    If RemoteSites[i].Sitecode = Sitecode Then
    Begin
      Result := RemoteSites[i].ButtonIndex;
      Exit;
    End;
  End;
  Result := 0;
End;

// Value = SiteCode

Procedure TfMagRemoteToolbar.AddOrSetInactive(Value: String);
Var
  i: Integer;
  Count: Integer;
Begin
  Self.RemoveSiteButton(Value);
  Count := High(RemoteSites);
  For i := 0 To Count Do
  Begin
    If RemoteSites[i].Sitecode = Value Then
    Begin
      RemoteSites[i].SiteStatus := SITESTATUS_INACTIVE;
      RemoteSites[i].PatientVisited := False;
      Exit;
    End;
  End;
End;

// Value = SiteCode

Procedure TfMagRemoteToolbar.AddOrSetDisconnected(Value: String);
Var
  i, Count: Integer;
Begin
  Self.RemoveSiteButton(Value);
  Count := High(RemoteSites);
  For i := 0 To Count Do
  Begin
    If RemoteSites[i].Sitecode = Value Then
    Begin
      RemoteSites[i].SiteStatus := SITESTATUS_DISCONNECTED;
      RemoteSites[i].PatientVisited := True;
      RemoteSites[i].ImageCount := 0;
      Exit;
    End;
  End;
End;

Procedure TfMagRemoteToolbar.RIVRecieveUpdate_(action: String; Value: String);
Begin

  If action = 'AddActive' Then
  Begin
    AddOrSetActive(Value);                         {brkpt 1}
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
          If action = 'SetInactive' Then // this is only used if the remote dfn wasn't found
          Begin
            AddOrSetInactive(Value);

          End
          Else
            If action = 'SetActive' Then
            Begin
              AddOrSetActive(Value);
            End
            Else
              If action = 'RemoveAll' Then // this happens when the local site is disconnected, should remove everything and reset.
              Begin
                Self.DisconnectLocalSite();
//    RemoveAllPanels();
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
                  End
                  Else
                    If action = 'UpdateImageCount' Then
                    Begin
                      SetImageCount(Value);
                    End
                    Else
                      If action = 'AddSite' Then
                      Begin
                        AddSite(Value);
                      End
                      Else
                        If action = 'RIVAutoOFF' Then
                        Begin
//    DeactivateAll(); // do we really want to do this?
// i think it should be off since we don't need to remove things since we are already connected, turning RIV off doesn't disconnect anything
//    RIVAutoConnectEnabled := false;
                          Upref.RIVAutoConnectEnabled := False;
                        End
                        Else
                          If action = 'RIVAutoON' Then
                          Begin
                            Upref.RIVAutoConnectEnabled := True;
//    RIVAutoConnectEnabled := true;
                          End
                          Else
                            If action = 'VISNOnlyOn' Then
                            Begin
                              Upref.RIVAutoConnectVISNOnly := True;
//    ConnectVISNOnly := true;
                            End
                            Else
                              If action = 'VISNOnlyOff' Then
                              Begin
                                Upref.RIVAutoConnectVISNOnly := False;
//    ConnectVISNOnly := false;
                              End
                              Else
                                If action = 'ShowConfiguration' Then
                                Begin
                                  If FMagRIVUserConfig.IsFormClosing = False Then {JK 2/16/2009  - fixes D81}
                                    btnConfigureClick(Self)
                                  Else
                                    FMagRIVUserConfig.IsFormClosing := False;
                                End
                                Else
                                  If action = 'CloseConfiguration' Then {JK 2/16/2009  - fixes D81}
                                  Begin
                                    IsFormClosing := True;
                                  End
                                  Else
                                    If action = 'HideEmptySites' Then
                                    Begin
                                      If Value = 'On' Then
                                      Begin
                                        Upref.RIVHideEmptySites := True;
//      FHideEmptySites := true;
                                      End
                                      Else
                                      Begin
                                        Upref.RIVHideEmptySites := False;
//      FHideEmptySites := false;
                                      End;
                                    End
                                    Else
                                      If action = 'HideDisconnectedSites' Then
                                      Begin
                                        If Value = 'On' Then
                                        Begin
                                          Upref.RIVHideDisconnectedSites := True;
//      FHideDisconnectedSites := true;
                                        End
                                        Else
                                        Begin
                                          Upref.RIVHideDisconnectedSites := False;
//      FHideDisconnectedSites := false;
                                        End;
                                      End
                                      Else
                                        If action = 'RemoteConnectionsComplete' Then
                                        Begin
                                          DisplayVisitedDisconnectedSites();
                                        End
                                        Else
                                          If action = 'SiteServiceFailed' Then
                                          Begin
    // JMW 7/1/2005 p45t4 Recieves message if there was an error connecting to the remote site service server
                                            DisplaySiteServiceFailure(Value);
                                          End
                                          Else
                                            If action = 'SiteServiceDisabled' Then
                                            Begin
    // JMW 7/5/2005 p45t5 Add feature to disable RIV Site Service if it isn't working properly
                                              DisplaySiteServiceDisabled();
                                            End
                                            Else
                                              If action = 'DisconnectAll' Then
                                              Begin
                                                DisconnectAll();
                                              End
                                              Else
                                                If action = 'ServerConnectionsComplete' Then
                                                Begin
                                                  AddAllButton();
                                                End
  {JMW 4/1/07
  In this case, the remote site has had a problem after being connected and is now disconnected but should still show up.
  }
                                                Else
                                                  If action = 'SetDisconnectedAndUpdate' Then
                                                  Begin
                                                    SetDisconnectedAndUpdate(Value);
                                                  End
                                                  Else
                                                    If action = 'SetSiteTimeoutException' Then
                                                    Begin
                                                      SetSiteTimeoutException(Value);
                                                    End;

End;

Procedure TfMagRemoteToolbar.DisconnectAll();
// just set all to disconnected

Var
  i: Integer;
  SiteCount: Integer;
Begin
  SiteCount := High(RemoteSites);
  For i := 0 To SiteCount Do
  Begin
    RemoteSites[i].SiteStatus := MagRemotesite.SITESTATUS_DISCONNECTED;
    RemoteSites[i].PatientVisited := True;
    RemoteSites[i].ImageCount := 0;
  End;
End;

Procedure TfMagRemoteToolbar.DisplaySiteServiceDisabled();
Var
  NewButton: Tpanel;
  aSeparator: TToolButton;
Begin
  RemoveAllPanels();

  aSeparator := TToolButton.Create(Self);
  aSeparator.Style := TbsSeparator;
  aSeparator.Align := alLeft;
  aSeparator.Width := 1;
  ToolBar1.InsertControl(aSeparator);

  NewButton := Tpanel.Create(Self);
  NewButton.BevelInner := bvLowered;
  NewButton.BevelOuter := bvRaised;
  NewButton.caption := 'Remote Site Services Server Disabled';
  NewButton.ShowHint := True;
  NewButton.Font.Color := COLOR_DISCONNECTED;
  NewButton.Font.Style := [Fsbold];
  NewButton.Hint := 'The Site Service has been disabled, remote image views will not work without this service. Please contact your IRM.';
  NewButton.Width := Length(NewButton.caption) * 8;
  NewButton.Align := alLeft;
  NewButton.Height := ToolBar1.ClientHeight;

  ToolBar1.InsertControl(NewButton);
End;

Procedure TfMagRemoteToolbar.DisplaySiteServiceFailure(ServiceURL: String);
Var
//newButton : TPanel;
  NewButton: TBitBtn;
  aSeparator: TToolButton;
Begin
  RemoveAllPanels();

  aSeparator := TToolButton.Create(Self);
  aSeparator.Style := TbsSeparator;
  aSeparator.Align := alLeft;
  aSeparator.Width := 1;
  ToolBar1.InsertControl(aSeparator);

  //newButton := TPanel.Create(self);
  NewButton := TBitBtn.Create(Self);
//  newButton.BevelInner := bvLowered;
//  newButton.BevelOuter := bvRaised;
  NewButton.Onclick := SiteServiceDisabledClick;
  NewButton.caption := 'Remote Site Services Server Failed';
  NewButton.ShowHint := True;
  NewButton.Font.Color := COLOR_DISCONNECTED;
  NewButton.Font.Style := [Fsbold];
  NewButton.Hint := 'There was an error connecting to the remote site services server [' + ServiceURL + '], remote image views will not work without this service. Please contact your IRM.';
  NewButton.Width := Length(NewButton.caption) * 8;
  NewButton.Align := alLeft;
  NewButton.Height := ToolBar1.ClientHeight;

  ToolBar1.InsertControl(NewButton);
End;

Procedure TfMagRemoteToolbar.AddSite(Value: String);
Var
  NewRemoteSite: cMagRemoteToolbarSite;
  SName, SCode: String;
  Count: Integer;
Begin
  SName := MagPiece(Value, '^', 1);
  SCode := MagPiece(Value, '^', 2);

  Count := Length(RemoteSites) + 1;
  NewRemoteSite := cMagRemoteToolbarSite.Create(SName, SCode, Count);

  SetLength(RemoteSites, Count);
  RemoteSites[High(RemoteSites)] := NewRemoteSite;
End;

Procedure TfMagRemoteToolbar.btnConfigureClick(Sender: Tobject);
Var
  ConfigForm: TfrmMagRIVUserConfig;
Begin
  ConfigForm := TfrmMagRIVUserConfig.Create(Self);
  If FMagRIVUserConfig.IsFormClosing <> True Then {JK 2/16/2009  - fixes D81}
    ConfigForm.Execute(RemoteSites); //, RIVAutoConnectEnabled, ConnectVISNOnly, FHideEmptySites, FHideDisconnectedSites);
  FreeAndNil(ConfigForm);
{
  configForm.Destroy();
  configForm := nil;
  }
End;

Procedure TfMagRemoteToolbar.DisplayVisitedDisconnectedSites();
Var
  i, Count: Integer;
  AllPanel: Tpanel;
Begin
//  if FHideDisconnectedSites then exit;
  If Upref.RIVHideDisconnectedSites Then Exit;

  Count := High(RemoteSites);
  For i := 0 To Count Do
  Begin
    If (RemoteSites[i].SiteStatus = SITESTATUS_DISCONNECTED) And (RemoteSites[i].PatientVisited) Then
    Begin
      UpdateButtonCaption(RemoteSites[i].ButtonIndex, RemoteSites[i].SiteName + '(X)', True);
    End;
  End;

End;

Procedure TfMagRemoteToolbar.RemoveCancelButton();
Var
//cPanel : TPanel;
  cPanel: TBitBtn;
  i: Integer;
Begin
  i := 0;
  While i < ToolBar1.ControlCount Do
  Begin
    //cPanel := TPanel(toolbar1.Controls[i]);
    If ToolBar1.Controls[i] Is TBitBtn Then
    Begin
      cPanel := TBitBtn(ToolBar1.Controls[i]);
      If cPanel.Tag = -100 Then
      Begin
        ToolBar1.RemoveControl(ToolBar1.Controls[i]);
      End
      Else
      Begin
        i := i + 1;
      End;
    End
    Else
    Begin
      i := i + 1;
    End;
  End;
End;

Procedure TfMagRemoteToolbar.AddAllButton();
Var
  NewButton, TempButton: TBitBtn;
//newButton, tempButton : TPanel;
  aSeparator: TToolButton;
  i, Count: Integer;
  DisplayAllButton: Boolean;
Begin
  RemoveCancelButton();
  DisplayAllButton := False;
  Count := High(RemoteSites);
  For i := 0 To Count Do
  Begin
    If (RemoteSites[i].SiteStatus = MagRemotesite.SITESTATUS_DISCONNECTED) And (RemoteSites[i].PatientVisited) Then
    Begin
      DisplayAllButton := True;
    End;
  End;
  If Not DisplayAllButton Then Exit;

  For i := 0 To ToolBar1.ControlCount - 1 Do
  Begin
    //if (toolbar1.Controls[i] is TPanel) then
    If (ToolBar1.Controls[i] Is TBitBtn) Then
    Begin
      //tempButton := toolbar1.controls[i] as TPanel;
      TempButton := ToolBar1.Controls[i] As TBitBtn;
      If TempButton.Tag = -1 Then Exit;
    End;

  End;

  aSeparator := TToolButton.Create(Self);
  aSeparator.Style := TbsSeparator;
  aSeparator.Align := alLeft;
  aSeparator.Width := 1;
  ToolBar1.InsertControl(aSeparator);

  //newButton := TPanel.Create(self);
  NewButton := TBitBtn.Create(Self);

  NewButton.caption := 'Connect All';

  NewButton.ShowHint := True;
  If FForTeleReader Then
    NewButton.Hint := 'Connect all disconnect sites the user has selected in the specialties dialog'
  Else
    NewButton.Hint := 'Connect all disconnect sites for the selected patient';
  NewButton.Font.Color := clBlack;
  NewButton.Font.Style := [Fsbold];
  NewButton.Onclick := PanelAllClick;

  NewButton.Width := Length(NewButton.caption) * 8;
  NewButton.Tag := -1;

  NewButton.Align := alLeft;
  NewButton.Height := ToolBar1.ClientHeight;

  ToolBar1.InsertControl(NewButton);

End;

Procedure TfMagRemoteToolbar.PanelAllClick(Sender: Tobject);
Var
  i: Integer;
  SiteCount: Integer;
  SiteConnected: Boolean;
Begin
  SiteCount := High(RemoteSites);
  SiteConnected := False;
  For i := 0 To SiteCount Do
  Begin
    If (RemoteSites[i].SiteStatus = MagRemotesite.SITESTATUS_DISCONNECTED) And (RemoteSites[i].PatientVisited) Then
    Begin
      RIVNotifyAllListeners(Self, 'ReconnectSite', RemoteSites[i].Sitecode);
      SiteConnected := True;

    End;
  End;
  If SiteConnected Then RIVNotifyAllListeners(Self, 'RefreshPatient', '');
End;

{Value = site number}

Procedure TfMagRemoteToolbar.SetDisconnectedAndUpdate(Value: String);
Var
  i, Count: Integer;
  btnLeft: Integer;
Begin

  Count := High(RemoteSites);
  For i := 0 To Count Do
  Begin
    If RemoteSites[i].Sitecode = Value Then
    Begin
      RemoteSites[i].SiteStatus := SITESTATUS_DISCONNECTED;
      RemoteSites[i].PatientVisited := True;
      RemoteSites[i].ImageCount := 0;

      // JMW P72 11/27/2007976|      // Remove the button from the toolbar but get its position
      btnLeft := RemoveSiteButton(Value);
      If Not Upref.RIVHideDisconnectedSites Then
      Begin
         // Create a new button for this site with the specific position
        CreateButton(RemoteSites[i].SiteName + '(X)', RemoteSites[i].ButtonIndex, True, btnLeft);                       {brkpt 1}
      End;

      Exit;
    End;
  End;

End;

{Value = site number}
{
  Removes the current button for the site specified by value and turns the
  site into a disconnected button that says try again. To indicate to the user
  they should retry the site to possibly get data.
}

Procedure TfMagRemoteToolbar.SetSiteTimeoutException(Value: String);
Var
  i, Count: Integer;
  btnLeft: Integer;
Begin

  Count := High(RemoteSites);
  For i := 0 To Count Do
  Begin
    If RemoteSites[i].Sitecode = Value Then
    Begin
      RemoteSites[i].SiteStatus := SITESTATUS_DISCONNECTED;
      RemoteSites[i].PatientVisited := True;
      RemoteSites[i].ImageCount := 0;

      // JMW P72 11/27/2007976|      // Remove the button from the toolbar but get its position
      btnLeft := RemoveSiteButton(Value);
      If Not Upref.RIVHideDisconnectedSites Then
      Begin
         // Create a new button for this site with the specific position
                         {brkpt 1}
        CreateButton(RemoteSites[i].SiteName + '(X) Try Again', RemoteSites[i].ButtonIndex, True, btnLeft);
      End;
      Exit;
    End;
  End;
End;

Procedure TfMagRemoteToolbar.RemoveSitePanel(ButtonIndex: Integer);
Var
  i: Integer;
  TempPanel: Tpanel;
Begin
  If ButtonIndex = 0 Then Exit;
  For i := 0 To ToolBar1.ControlCount - 1 Do
  Begin
    If ToolBar1.Controls[i] Is Tpanel Then
    Begin
      TempPanel := Tpanel(ToolBar1.Controls[i]);
      If TempPanel.Tag = ButtonIndex Then
      Begin
        ToolBar1.RemoveControl(ToolBar1.Controls[i]);
        Exit;
      End;
    End;
  End;
End;

End.
