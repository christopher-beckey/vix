Unit FMagRIVUserConfig;
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
        ;;  Description: This is a configuration dialog for the user to see
        ;;  the status of each remote site they have connected to. It also
        ;;  provides functions to connect and disconnect remote sites.
        ;;
        ;;+---------------------------------------------------------------------------------------------------+
*)

Interface

Uses
  Buttons,
  ComCtrls,
  Controls,
  Forms,
  Magremoteinterface,
  MagRemotesite,
  Stdctrls,
  Windows,
  Classes
  ;

//Uses Vetted 20090929:Dialogs, Graphics, Classes, Variants, Messages, MagPositions, SysUtils

Type
  TfrmMagRIVUserConfig = Class(TForm, IMagRemoteinterface)
    GrpStatus: TGroupBox;
    LstSites: TListView;
    btnDisconnectAll: TButton;
    btnConnect: TButton;
    btnDisconnect: TButton;
    GrpUserPreferences: TGroupBox;
    chkEnableRIVAuto: TCheckBox;
    chkVISNOnly: TCheckBox;
    btnClose: TBitBtn;
    btnSave: TBitBtn;
    chkHideEmptySites: TCheckBox;
    chkHideDisconnectedSites: TCheckBox;
    Procedure LstSitesClick(Sender: Tobject);
    Procedure btnDisconnectClick(Sender: Tobject);
    Procedure btnConnectClick(Sender: Tobject);
    Procedure btnDisconnectAllClick(Sender: Tobject);
    Procedure btnSaveClick(Sender: Tobject);
    Procedure FormCreate(Sender: Tobject);
    Procedure FormClose(Sender: Tobject; Var action: TCloseAction);
    Procedure BitBtn1Click(Sender: Tobject);
    Procedure chkEnableRIVAutoClick(Sender: Tobject);
    Procedure LstSitesColumnClick(Sender: Tobject; Column: TListColumn);
    Procedure LstSitesCompare(Sender: Tobject; Item1, Item2: TListItem;
      Data: Integer; Var Compare: Integer);

  Private
    ColumnToSort: Integer;
    SortAscending: Bool;

    Procedure SetImageCount(Value: String);
    Procedure SetDisconnected(Sitecode: String);
    Procedure SetInactive(Sitecode: String);
    Procedure SetActive(Sitecode: String);
    Procedure DeactivateAll();
  Public
    Procedure Execute(RSites: Array Of cMagRemoteToolbarSite);

    Procedure RIVRecieveUpdate_(action: String; Value: String); // recieve updates from everyone
  End;

Function MagPiece(Str, Delim: String; Piece: Integer): String; // $Piece

Var
  FrmMagRIVUserConfig: TfrmMagRIVUserConfig;
  IsFormClosing: Boolean; {JK 2/16/2009 - fixes D81}

Implementation
Uses
  Magpositions,
  SysUtils
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

Procedure TfrmMagRIVUserConfig.Execute(RSites: Array Of cMagRemoteToolbarSite);
Var
  i: Integer;
  Count: Integer;
  LstItem: TListItem;
Begin
//  RemoteSites := rSites;
  ColumnToSort := 0;
  SortAscending := True;
  Count := Length(RSites);
  For i := 0 To Count - 1 Do
  Begin
    LstItem := TListItem.Create(LstSites.Items);
    LstItem := LstSites.Items.Add();
    LstItem.caption := RSites[i].SiteName;
    LstItem.SubItems.Add(RSites[i].Sitecode); //1

    LstItem.SubItems.Add(MagRemotesite.GetStatusCode(RSites[i].SiteStatus)); //2
    LstItem.SubItems.Add(Inttostr(RSites[i].SiteStatus)); //3
    If RSites[i].ImageCount = -1 Then
      LstItem.SubItems.Add(' ') //4
    Else
      LstItem.SubItems.Add(Inttostr(RSites[i].ImageCount)); //4

  End;

  btnDisconnect.Enabled := False;
  btnConnect.Enabled := False;

  RIVAttachListener(Self);
  Showmodal();
  IsFormClosing := True; {JK 2/16/2009  - fixes D81}
  RIVDetachListener(Self);
  IsFormClosing := False; {JK 2/16/2009  - fixes D81}

End;

// Value = SiteCode^ImageCount

Procedure TfrmMagRIVUserConfig.SetImageCount(Value: String);
Var
  i: Integer;
  SCode, ImageCount: String;
Begin
  SCode := MagPiece(Value, '^', 1);
  ImageCount := MagPiece(Value, '^', 2);
  If ImageCount = '' Then ImageCount := '0';
  If ImageCount = '-1' Then ImageCount := ' ';
  For i := 0 To LstSites.Items.Count - 1 Do
  Begin
    If LstSites.Items[i].SubItems[0] = SCode Then
    Begin
      LstSites.Items[i].SubItems[3] := ImageCount;
      Exit;
    End;
  End;
End;

Procedure TfrmMagRIVUserConfig.SetDisconnected(Sitecode: String);
Var
  i: Integer;
Begin
  For i := 0 To LstSites.Items.Count - 1 Do
  Begin
    If LstSites.Items[i].SubItems[0] = Sitecode Then
    Begin
      LstSites.Items[i].SubItems[1] := MagRemotesite.GetStatusCode(MagRemotesite.SITESTATUS_DISCONNECTED);
      LstSites.Items[i].SubItems[2] := Inttostr(MagRemotesite.SITESTATUS_DISCONNECTED);
      // JMW 4/1/07 - set the number of images to 0
      If LstSites.Items[i].SubItems.Count >= 4 Then
        LstSites.Items[i].SubItems[3] := '0';
      Exit;
    End;
  End;
End;

Procedure TfrmMagRIVUserConfig.SetInactive(Sitecode: String);
Var
  i: Integer;
Begin
  For i := 0 To LstSites.Items.Count - 1 Do
  Begin
    If LstSites.Items[i].SubItems[0] = Sitecode Then
    Begin
      LstSites.Items[i].SubItems[1] := MagRemotesite.GetStatusCode(MagRemotesite.SITESTATUS_INACTIVE);
      LstSites.Items[i].SubItems[2] := Inttostr(MagRemotesite.SITESTATUS_INACTIVE);
      Exit;
    End;
  End;
End;

Procedure TfrmMagRIVUserConfig.SetActive(Sitecode: String);
Var
  i: Integer;
Begin
  For i := 0 To LstSites.Items.Count - 1 Do
  Begin
    If LstSites.Items[i].SubItems[0] = Sitecode Then
    Begin
      LstSites.Items[i].SubItems[1] := MagRemotesite.GetStatusCode(MagRemotesite.SITESTATUS_ACTIVE);
      LstSites.Items[i].SubItems[2] := Inttostr(MagRemotesite.SITESTATUS_ACTIVE);
      Exit;
    End;
  End;
End;

Procedure TfrmMagRIVUserConfig.DeactivateAll();
Var
  i: Integer;
Begin
  For i := 0 To LstSites.Items.Count - 1 Do
  Begin
    If LstSites.Items[i].SubItems[2] <> Inttostr(MagRemotesite.SITESTATUS_DISCONNECTED) Then
    Begin
      LstSites.Items[i].SubItems[1] := MagRemotesite.GetStatusCode(MagRemotesite.SITESTATUS_INACTIVE);
      LstSites.Items[i].SubItems[2] := Inttostr(MagRemotesite.SITESTATUS_INACTIVE);
    // This is only change to this routine in 46.
      LstSites.Items[i].SubItems[3] := '0'; // JMW 3/17/2006 P46T10 set image count to 0
    End;
  End;
End;

Procedure TfrmMagRIVUserConfig.RIVRecieveUpdate_(action: String; Value: String); // recieve updates from everyone
Begin
  If (action = 'AddDisconnected') Or (action = 'SetDisconnected') Or (action = 'SetDisconnectedAndUpdate') Then
  Begin
    SetDisconnected(Value);
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
        If action = 'SetInactive' Then
        Begin
          SetInactive(Value);
        End
        Else
          If (action = 'SetActive') Or (action = 'AddActive') Then
          Begin
            SetActive(Value);
          End
          Else
            If action = 'DeactivateAll' Then
            Begin
              DeactivateAll();
            End;

End;

Procedure TfrmMagRIVUserConfig.LstSitesClick(Sender: Tobject);
Begin
  If LstSites.Selected = Nil Then Exit;
  If LstSites.Selected.SubItems.Strings[2] = Inttostr(MagRemotesite.SITESTATUS_DISCONNECTED) Then
  Begin
    btnConnect.Enabled := True;
    btnDisconnect.Enabled := False;
  End
  Else
  Begin
    btnConnect.Enabled := False;
    btnDisconnect.Enabled := True;
  End;
End;

Procedure TfrmMagRIVUserConfig.btnDisconnectClick(Sender: Tobject);
Begin
  If LstSites.Selected = Nil Then Exit;
  RIVNotifyAllListeners(Self, 'SetDisconnected', LstSites.Selected.SubItems.Strings[0]);
  LstSites.Selected.SubItems.Strings[1] := MagRemotesite.GetStatusCode(MagRemotesite.SITESTATUS_DISCONNECTED);
  LstSites.Selected.SubItems.Strings[2] := Inttostr(MagRemotesite.SITESTATUS_DISCONNECTED);
  LstSites.Selected.SubItems.Strings[3] := '0';
  RIVNotifyAllListeners(Self, 'RefreshPatient', ''); // definately need this here to refresh the patient list and remove images from disconnected sites
  Self.SetFocus();
End;

Procedure TfrmMagRIVUserConfig.btnConnectClick(Sender: Tobject);
Begin
  If LstSites.Selected = Nil Then Exit;
//  RIVNotifyAllListeners(self,'SetActive', lstsites.Selected.SubItems.Strings[0]);
  RIVNotifyAllListeners(Self, 'ReconnectSite', LstSites.Selected.SubItems.Strings[0]);
//  lstsites.Selected.SubItems.Strings[1] := MagRemoteSite.getStatusCode(MagRemoteSite.SITESTATUS_ACTIVE);
//  lstSites.Selected.SubItems.Strings[2] := inttostr(MagRemoteSite.SITESTATUS_ACTIVE);
  RIVNotifyAllListeners(Self, 'RefreshPatient', '');
  Self.SetFocus();
End;

Procedure TfrmMagRIVUserConfig.btnDisconnectAllClick(Sender: Tobject);
Var
  i: Integer;
Begin
//showmessage('does nothing');
  RIVNotifyAllListeners(Self, 'DisconnectAll', '');
  RIVNotifyAllListeners(Self, 'RefreshPatient', '');

  For i := 0 To LstSites.Items.Count - 1 Do
  Begin
    LstSites.Items[i].SubItems.Strings[1] := MagRemotesite.GetStatusCode(MagRemotesite.SITESTATUS_DISCONNECTED);
    LstSites.Items[i].SubItems.Strings[2] := Inttostr(MagRemotesite.SITESTATUS_DISCONNECTED);
    LstSites.Items[i].SubItems.Strings[3] := '0';
  End;

  Self.SetFocus();
End;

Procedure TfrmMagRIVUserConfig.btnSaveClick(Sender: Tobject);
Var
  RefreshPatientNeeded: Boolean;
Begin
{
  RefreshPatientNeeded := false;
  if chkEnableRIVAuto.Checked <> RIVAutoOn then
  begin
    if chkEnableRIVAuto.Checked = true then
    begin
      RIVNotifyAllListeners(self,'RIVAutoON', '');
      RefreshPatientNeeded := true;
    end
    else
    begin
      RIVNotifyAllListeners(self,'RIVAutoOFF', '');
    end;
  end;

  if chkVISNOnly.Checked <> VISNOnlyOn then
  begin

    if chkvisnonly.Checked = true then
    begin
      RIVNotifyAllListeners(self,'VISNOnlyOn','');
    end
    else
    begin
      RIVNotifyAllListeners(self,'VISNOnlyOff','');
      RefreshPatientNeeded := true;
    end;
  end;

  if chkHideEmptySites.Checked <> HideEmptySitesOn then
  begin
    if chkHideEmptySites.Checked = true then
    begin
      RIVNotifyAllListeners(self,'HideEmptySites','On');
    end
    else
    begin
      RIVNotifyAllListeners(self,'HideEmptySites','Off');
    end;
  end;
  if chkHideDisconnectedSites.Checked <> HideDisconnectedSitesOn then
  begin
    if chkHideDisconnectedSites.Checked = true then
    begin
      RIVNotifyAllListeners(self,'HideDisconnectedSites','On');
    end
    else
    begin
      RIVNotifyAllListeners(self,'HideDisconnectedSites','Off');
    end;
  end;

  if RefreshPatientNeeded then
  begin
    // do we ever wnat a patient refresh?  it won't do anything since we won't automatically connect to those sites
//    RIVNotifyAllListeners(self,'RefreshPatient', '');// don't ever need a refresh since turning these on/off doesn't close connections
  end;

  // we might want to do a refresh if RIV ON or VISN only=false but if we are restricting then do we really need a refresh?
//  RIVNotifyAllListeners(self,'RefreshPatient', ''); // do we really need to refresh the patient?  any connections are not going to change, right?
  modalresult := mrok;
  }
End;

Procedure TfrmMagRIVUserConfig.FormCreate(Sender: Tobject);
Begin
  Magpositions.GetFormPosition(Self);
End;

Procedure TfrmMagRIVUserConfig.FormClose(Sender: Tobject;
  Var action: TCloseAction);
Begin
  Magpositions.SaveFormPosition(Self);
  RIVNotifyAllListeners(Self, 'CloseConfiguration', ''); {JK 2/16/2009  - fixes D81}
End;

Procedure TfrmMagRIVUserConfig.BitBtn1Click(Sender: Tobject);
Begin
  ModalResult := MrOK;
End;

Procedure TfrmMagRIVUserConfig.chkEnableRIVAutoClick(Sender: Tobject);
Begin
  If Not chkEnableRIVAuto.Checked Then
  Begin
    chkVISNOnly.Checked := False;
    chkVISNOnly.Enabled := False;
  End
  Else
  Begin
    chkVISNOnly.Enabled := True;
  End;
End;

Procedure TfrmMagRIVUserConfig.LstSitesColumnClick(Sender: Tobject;
  Column: TListColumn);
Begin
  If ColumnToSort = Column.Index Then
    SortAscending := Not SortAscending
  Else
    SortAscending := True;
  ColumnToSort := Column.Index;
  (Sender As TCustomListView).AlphaSort();
End;

Procedure TfrmMagRIVUserConfig.LstSitesCompare(Sender: Tobject; Item1,
  Item2: TListItem; Data: Integer; Var Compare: Integer);
Var
  ItemNumber1, ItemNumber2: Integer;
  Val: String;
Begin
  If (ColumnToSort = 1) Or (ColumnToSort = 4) Then
  Begin
    Val := Item1.SubItems[ColumnToSort - 1];
    If Val = ' ' Then Val := '0';
    ItemNumber1 := Strtoint(Val);
    Val := Item2.SubItems[ColumnToSort - 1];
    If Val = ' ' Then Val := '0';
    ItemNumber2 := Strtoint(Val);
    If (ItemNumber1 > ItemNumber2) Then
      Compare := 1
    Else
      If ItemNumber1 < ItemNumber2 Then
        Compare := -1
      Else
        Compare := 0;
  End
  Else
    If ColumnToSort = 0 Then
    Begin
      Compare := CompareText(Item1.caption, Item2.caption)
    End
    Else
    Begin
      Compare := CompareText(Item1.SubItems[ColumnToSort - 1], Item2.SubItems[ColumnToSort - 1])
    End;
  If Not SortAscending Then
    Compare := Compare * -1;
End;

End.
