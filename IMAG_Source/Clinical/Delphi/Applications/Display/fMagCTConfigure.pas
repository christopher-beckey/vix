Unit FMagCTConfigure;

Interface

Uses
  Classes,
  cMagDBBroker,
  FmagRadViewer,
  Forms,
  Stdctrls,
  Controls
  ;

//Uses Vetted 20090929:Controls, Graphics, Variants, Messages, Windows, umagutils, Dialogs, SysUtils

Type
  TfrmCTConfigure = Class(TForm)
    GrpPresetsConfig: TGroupBox;
    LblStandardPresets: Tlabel;
    LblPresetName: Tlabel;
    LblWindow: Tlabel;
    LblLevel: Tlabel;
    LblCustomPresets: Tlabel;
    LblCustomName: Tlabel;
    LblCustomWindow: Tlabel;
    LblCustomLevel: Tlabel;
    EdtName1: TEdit;
    EdtName2: TEdit;
    EdtName3: TEdit;
    EdtName4: TEdit;
    EdtName5: TEdit;
    EdtWindow1: TEdit;
    EdtWindow2: TEdit;
    EdtWindow3: TEdit;
    EdtWindow4: TEdit;
    EdtWindow5: TEdit;
    EdtLevel1: TEdit;
    EdtLevel2: TEdit;
    EdtLevel3: TEdit;
    EdtLevel4: TEdit;
    EdtLevel5: TEdit;
    EdtName6: TEdit;
    EdtWindow6: TEdit;
    EdtLevel6: TEdit;
    EdtName7: TEdit;
    EdtName8: TEdit;
    EdtName9: TEdit;
    EdtWindow7: TEdit;
    EdtLevel7: TEdit;
    EdtWindow8: TEdit;
    EdtLevel8: TEdit;
    EdtWindow9: TEdit;
    EdtLevel9: TEdit;
    btnTestAbdomen: TButton;
    btnTestBone: TButton;
    btnTestDisk: TButton;
    btnTestHead: TButton;
    btnTestLung: TButton;
    btnTestMediastinum: TButton;
    btnTestCustom1: TButton;
    btnTestCustom2: TButton;
    btnTestCustom3: TButton;
    GrpButtons: TGroupBox;
    btnPreview: TButton;
    btnSaveForSite: TButton;
    btnDefaultValues: TButton;
    btnCancel: TButton;
    btnClearDatabase: TButton;
    Procedure btnTestAbdomenClick(Sender: Tobject);
    Procedure btnSaveForSiteClick(Sender: Tobject);
    Procedure btnCancelClick(Sender: Tobject);
    Procedure btnTestBoneClick(Sender: Tobject);
    Procedure btnTestDiskClick(Sender: Tobject);
    Procedure btnTestHeadClick(Sender: Tobject);
    Procedure btnTestLungClick(Sender: Tobject);
    Procedure btnTestMediastinumClick(Sender: Tobject);
    Procedure btnPreviewClick(Sender: Tobject);
    Procedure btnTestCustom1Click(Sender: Tobject);
    Procedure btnTestCustom2Click(Sender: Tobject);
    Procedure btnTestCustom3Click(Sender: Tobject);
    Procedure btnDefaultValuesClick(Sender: Tobject);
  Private
    FRadViewer: TfrmRadViewer;
    FBroker: TMagDBBroker;

    Function ValidateAllFields(Var CTData: String): Boolean;
    Function ValidateField(Window, Level: String): Boolean;
    Function ValidateCustomField(Name, Window, Level: String): Boolean;
    Function ConvertCTDataToStringList(CTData: String): TStrings;
    Function GetErrorMsg(): String;
  Public
    Procedure Execute(RadViewer: TfrmRadViewer; CTPresets: TStrings);
    Property Broker: TMagDBBroker Write FBroker;
    { Public declarations }
  End;

Const
  //MAX_VALUE = 4095;
  MAX_VALUE = 65536;
  MIN_LEVEL_VALUE = -1200;

Var
  FrmCTConfigure: TfrmCTConfigure;

Implementation
Uses
  Dialogs,
  SysUtils,
  Umagutils8
  ;

{$R *.dfm}

Procedure TfrmCTConfigure.Execute(RadViewer: TfrmRadViewer; CTPresets: TStrings);
Begin
  Self.Formstyle := Fsstayontop;
  FRadViewer := RadViewer;

  EdtWindow1.Text := MagPiece(CTPresets[0], '|', 2);
  EdtLevel1.Text := MagPiece(CTPresets[0], '|', 3);

  EdtWindow2.Text := MagPiece(CTPresets[1], '|', 2);
  EdtLevel2.Text := MagPiece(CTPresets[1], '|', 3);

  EdtWindow3.Text := MagPiece(CTPresets[2], '|', 2);
  EdtLevel3.Text := MagPiece(CTPresets[2], '|', 3);

  EdtWindow4.Text := MagPiece(CTPresets[3], '|', 2);
  EdtLevel4.Text := MagPiece(CTPresets[3], '|', 3);

  EdtWindow5.Text := MagPiece(CTPresets[4], '|', 2);
  EdtLevel5.Text := MagPiece(CTPresets[4], '|', 3);

  EdtWindow6.Text := MagPiece(CTPresets[5], '|', 2);
  EdtLevel6.Text := MagPiece(CTPresets[5], '|', 3);

  If CTPresets[6] <> '' Then
  Begin
    EdtName7.Text := MagPiece(CTPresets[6], '|', 1);
    EdtWindow7.Text := MagPiece(CTPresets[6], '|', 2);
    EdtLevel7.Text := MagPiece(CTPresets[6], '|', 3);
  End
  Else
  Begin
    EdtName7.Text := '';
    EdtWindow7.Text := '';
    EdtLevel7.Text := '';
  End;
  If CTPresets[7] <> '' Then
  Begin
    EdtName8.Text := MagPiece(CTPresets[7], '|', 1);
    EdtWindow8.Text := MagPiece(CTPresets[7], '|', 2);
    EdtLevel8.Text := MagPiece(CTPresets[7], '|', 3);
  End
  Else
  Begin
    EdtName8.Text := '';
    EdtWindow8.Text := '';
    EdtLevel8.Text := '';
  End;
  If CTPresets[8] <> '' Then
  Begin
    EdtName9.Text := MagPiece(CTPresets[8], '|', 1);
    EdtWindow9.Text := MagPiece(CTPresets[8], '|', 2);
    EdtLevel9.Text := MagPiece(CTPresets[8], '|', 3);
  End
  Else
  Begin
    EdtName9.Text := '';
    EdtWindow9.Text := '';
    EdtLevel9.Text := '';
  End;

  Show();
End;

Procedure TfrmCTConfigure.btnTestAbdomenClick(Sender: Tobject);
Begin
  If ValidateField(EdtWindow1.Text, EdtLevel1.Text) Then
    FRadViewer.SetWindowLevel(EdtWindow1.Text, EdtLevel1.Text)
  Else
    Showmessage(GetErrorMsg());
End;

Procedure TfrmCTConfigure.btnSaveForSiteClick(Sender: Tobject);
Var
  CTData, Rmsg: String;
  Rstat: Boolean;
Begin
  If FBroker = Nil Then
  Begin
    Showmessage('Broker not assigned, cannot save to VistA');
    Exit;
  End;

  If Not ValidateAllFields(CTData) Then
  Begin
    Showmessage(GetErrorMsg());
    Exit;
  End;
  Rstat := False;
  FBroker.RPCTPresetsSave(Rstat, Rmsg, CTData); //JMW 7/16/2003 p8

  If Rstat = False Then // if there was an error
  Begin
  // output an error message
    Messagedlg('Error saving values to database: ' + Rmsg, Mtconfirmation, [Mbok], 0);
    Exit;
  End;
  FRadViewer.CTPresets := ConvertCTDataToStringList(CTData);
  Self.Close();

End;

Function TfrmCTConfigure.ConvertCTDataToStringList(CTData: String): TStrings;
Var
  CTPresets: TStrings;
Begin
  CTPresets := Tstringlist.Create();
  CTPresets.Add(MagPiece(CTData, '~', 1));
  CTPresets.Add(MagPiece(CTData, '~', 2));
  CTPresets.Add(MagPiece(CTData, '~', 3));
  CTPresets.Add(MagPiece(CTData, '~', 4));
  CTPresets.Add(MagPiece(CTData, '~', 5));
  CTPresets.Add(MagPiece(CTData, '~', 6));
  CTPresets.Add(MagPiece(CTData, '~', 7));
  CTPresets.Add(MagPiece(CTData, '~', 8));
  CTPresets.Add(MagPiece(CTData, '~', 9));

  Result := CTPresets;

End;

Function TfrmCTConfigure.ValidateAllFields(Var CTData: String): Boolean;
Begin
  Result := False;
  If Not ValidateField(EdtWindow1.Text, EdtLevel1.Text) Then Exit;
  If Not ValidateField(EdtWindow2.Text, EdtLevel2.Text) Then Exit;
  If Not ValidateField(EdtWindow3.Text, EdtLevel3.Text) Then Exit;
  If Not ValidateField(EdtWindow4.Text, EdtLevel4.Text) Then Exit;
  If Not ValidateField(EdtWindow5.Text, EdtLevel5.Text) Then Exit;
  If Not ValidateField(EdtWindow6.Text, EdtLevel6.Text) Then Exit;

  If EdtName7.Text <> '' Then
    If Not ValidateCustomField(EdtName7.Text, EdtWindow7.Text, EdtLevel7.Text) Then Exit;
  If EdtName8.Text <> '' Then
    If Not ValidateCustomField(EdtName8.Text, EdtWindow8.Text, EdtLevel8.Text) Then Exit;
  If EdtName9.Text <> '' Then
    If Not ValidateCustomField(EdtName9.Text, EdtWindow9.Text, EdtLevel9.Text) Then Exit;

  Result := True;
  CTData := EdtName1.Text + '|' + EdtWindow1.Text + '|' + EdtLevel1.Text + '~';
  CTData := CTData + EdtName2.Text + '|' + EdtWindow2.Text + '|' + EdtLevel2.Text + '~';
  CTData := CTData + EdtName3.Text + '|' + EdtWindow3.Text + '|' + EdtLevel3.Text + '~';
  CTData := CTData + EdtName4.Text + '|' + EdtWindow4.Text + '|' + EdtLevel4.Text + '~';
  CTData := CTData + EdtName5.Text + '|' + EdtWindow5.Text + '|' + EdtLevel5.Text + '~';
  CTData := CTData + EdtName6.Text + '|' + EdtWindow6.Text + '|' + EdtLevel6.Text + '~';

  If EdtName7.Text <> '' Then
    CTData := CTData + EdtName7.Text + '|' + EdtWindow7.Text + '|' + EdtLevel7.Text;
  CTData := CTData + '~';

  If EdtName8.Text <> '' Then
    CTData := CTData + EdtName8.Text + '|' + EdtWindow8.Text + '|' + EdtLevel8.Text;
  CTData := CTData + '~';
  If EdtName9.Text <> '' Then
    CTData := CTData + EdtName9.Text + '|' + EdtWindow9.Text + '|' + EdtLevel9.Text;
End;

Function TfrmCTConfigure.ValidateField(Window, Level: String): Boolean;
Var
  Win, Lev: Integer;
Begin
  Result := False;
  Win := Strtointdef(Window, -1);
  If (Win < 0) Then Exit;
  Lev := Strtointdef(Level, -1);
  If (Lev < MIN_LEVEL_VALUE) Then Exit;
  If Win > MAX_VALUE Then Exit;
  If Lev > MAX_VALUE Then Exit;
  Result := True;
End;

Function TfrmCTConfigure.ValidateCustomField(Name, Window, Level: String): Boolean;
Begin
  Result := False;
  If Name = '' Then Exit;
  Result := ValidateField(Window, Level);
End;

Procedure TfrmCTConfigure.btnCancelClick(Sender: Tobject);
Begin
  Self.Close();
End;

Procedure TfrmCTConfigure.btnTestBoneClick(Sender: Tobject);
Begin
  If ValidateField(EdtWindow2.Text, EdtLevel2.Text) Then
    FRadViewer.SetWindowLevel(EdtWindow2.Text, EdtLevel2.Text)
  Else
    Showmessage(GetErrorMsg());
End;

Procedure TfrmCTConfigure.btnTestDiskClick(Sender: Tobject);
Begin
  If ValidateField(EdtWindow3.Text, EdtLevel3.Text) Then
    FRadViewer.SetWindowLevel(EdtWindow3.Text, EdtLevel3.Text)
  Else
    Showmessage(GetErrorMsg());
End;

Procedure TfrmCTConfigure.btnTestHeadClick(Sender: Tobject);
Begin
  If ValidateField(EdtWindow4.Text, EdtLevel4.Text) Then
    FRadViewer.SetWindowLevel(EdtWindow4.Text, EdtLevel4.Text)
  Else
    Showmessage(GetErrorMsg());
End;

Procedure TfrmCTConfigure.btnTestLungClick(Sender: Tobject);
Begin
  If ValidateField(EdtWindow5.Text, EdtLevel5.Text) Then
    FRadViewer.SetWindowLevel(EdtWindow5.Text, EdtLevel5.Text)
  Else
    Showmessage(GetErrorMsg());
End;

Procedure TfrmCTConfigure.btnTestMediastinumClick(Sender: Tobject);
Begin
  If ValidateField(EdtWindow6.Text, EdtLevel6.Text) Then
    FRadViewer.SetWindowLevel(EdtWindow6.Text, EdtLevel6.Text)
  Else
    Showmessage(GetErrorMsg());
End;

Procedure TfrmCTConfigure.btnPreviewClick(Sender: Tobject);
Var
  CTData: String;
Begin
  If Not ValidateAllFields(CTData) Then
  Begin
    Showmessage(GetErrorMsg());
    Exit;
  End;
  FRadViewer.CTPresets := ConvertCTDataToStringList(CTData);
  Self.Close();
End;

Procedure TfrmCTConfigure.btnTestCustom1Click(Sender: Tobject);
Begin
  If ValidateField(EdtWindow7.Text, EdtLevel7.Text) Then
    FRadViewer.SetWindowLevel(EdtWindow7.Text, EdtLevel7.Text)
  Else
    Showmessage(GetErrorMsg());
End;

Procedure TfrmCTConfigure.btnTestCustom2Click(Sender: Tobject);
Begin
  If ValidateField(EdtWindow8.Text, EdtLevel8.Text) Then
    FRadViewer.SetWindowLevel(EdtWindow8.Text, EdtLevel8.Text)
  Else
    Showmessage(GetErrorMsg());
End;

Procedure TfrmCTConfigure.btnTestCustom3Click(Sender: Tobject);
Begin
  If ValidateField(EdtWindow9.Text, EdtLevel9.Text) Then
    FRadViewer.SetWindowLevel(EdtWindow9.Text, EdtLevel9.Text)
  Else
    Showmessage(GetErrorMsg());
End;

Procedure TfrmCTConfigure.btnDefaultValuesClick(Sender: Tobject);
Begin
  EdtWindow1.Text := '350'; //'350';
  EdtWindow2.Text := '2000'; //'500';
  EdtWindow3.Text := '900'; //'950';
  EdtWindow4.Text := '80'; //'80';
  EdtWindow5.Text := '1500'; //'1000';
  EdtWindow6.Text := '500'; //'500';

  EdtLevel1.Text := '40'; //'1040';
  EdtLevel2.Text := '500'; //'1274';
  EdtLevel3.Text := '250'; //'1240';
  EdtLevel4.Text := '40'; //'1040';
  EdtLevel5.Text := '-700'; //'300';
  EdtLevel6.Text := '40'; //'1040';
End;

Function TfrmCTConfigure.GetErrorMsg(): String;
Begin
  Result := 'Invalid window/level values, window must be > 0, level must be more than ' + Inttostr(MIN_LEVEL_VALUE) + ' and both must be less than  and < ' + Inttostr(MAX_VALUE);
End;

End.
