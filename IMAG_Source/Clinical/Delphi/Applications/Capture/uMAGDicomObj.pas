Unit uMAGDicomObj;

Interface

Uses
  Classes,
  ExtCtrls,
  Controls,
  Forms,
  SysUtils,
  Stdctrls,
  Trpcb;

Type

  TDicomDataType = (
    ddtCS, //Code String
    ddtSH, //Short String
    ddtLO, //Long String
    ddtST, //Short Text
    ddtLT, //Long Text
    ddtUT, //Unlimited Text
    ddtAE, //Application Entity
    ddtPN, //Person Name
    ddtUI, //Unique Identifier
    ddtDA, //Date
    ddtTM, //Time
    ddtDT, //Date Time
    ddtAS, //Age String
    ddtIS, //Integer String
    ddtDS, //Decimal String
    ddtSS, //Signed Short
    ddtUS, //Unsigned Short
    ddtSL, //Signed Long
    ddtUL, //Unsigned Long
    ddtAT, //Attribute Tag
    ddtFL, //Floating Point Single
    ddtFD, //Floating Point Double
    ddtOB, //Other Byte String
    ddtOW, //Other Word String
    ddtOF, //Other Float String
    ddtSQ, //Sequence of Items
    ddtUN //Unknown
    );

  //objects used to store methods to be used for TDicomEdit OnKeyPress Event Handlers
  TDummyObj = Class(Tobject)
  Private
  Public
    Procedure ValidateCS(Sender: Tobject; Var Key: Char);
    Procedure ValidateUI(Sender: Tobject; Var Key: Char);
    Procedure ValidateDA(Sender: Tobject; Var Key: Char);
    Procedure ValidateDT(Sender: Tobject; Var Key: Char);
    Procedure ValidateAS(Sender: Tobject; Var Key: Char);
    Procedure ValidateIS(Sender: Tobject; Var Key: Char);
    Procedure ValidateDS(Sender: Tobject; Var Key: Char);
    Procedure ValidateNumeric(Sender: Tobject; Var Key: Char);
  End;

  TDicomEdit = Class(TLabeledEdit)
  Private
    FDataType: TDicomDataType;
    Procedure SetDataType(Value: TDicomDataType);
    //validation routines - set when data type assigned
    Procedure SetValidation;
    Procedure SetCase;
    Procedure SetMaxLength;
  Public
    Constructor Create(AOwner: TComponent; DataType: TDicomDataType; SName: String);
    Property DataType: TDicomDataType Read FDataType Write SetDataType;
    Procedure SetLabelCaption(sCaption: String; Mandatory: Boolean);
    Procedure SetDimensions(iTop, iLeft, IWidth: Integer);
    Function BldPairedStr: String;
  End;

Function StrToDicomDataType(s: String): TDicomDataType;

  //procedures to set Combo Boxes and Memo Boxes on the DICOM capture form
Procedure SetControlDimensions(Sender: TControl; iTop, iLeft, IWidth: Integer);
Procedure AddControlToDICOMForm(SB: TScrollBox; Sender: TControl; SName: String; bMandatory: Boolean);
Procedure LoadComboBox(cmb: TComboBox; Broker: TRPCBroker);

Implementation

Uses
  Graphics,
  MagFMComponents;

Const
  MND = '*** '; //Character to denote a mandatory field

Function StrToDicomDataType(s: String): TDicomDataType;
Begin
  Result := ddtUN;
  If s = 'CS' Then
    Result := ddtCS
  Else
    If s = 'SH' Then
      Result := ddtSH
    Else
      If s = 'LO' Then
        Result := ddtLO
      Else
        If s = 'ST' Then
          Result := ddtST
        Else
          If s = 'LT' Then
            Result := ddtLT
          Else
            If s = 'UT' Then
              Result := ddtUT
            Else
              If s = 'AE' Then
                Result := ddtAE
              Else
                If s = 'PN' Then
                  Result := ddtPN
                Else
                  If s = 'UI' Then
                    Result := ddtUI
                  Else
                    If s = 'DA' Then
                      Result := ddtDA
                    Else
                      If s = 'TM' Then
                        Result := ddtTM
                      Else
                        If s = 'DT' Then
                          Result := ddtDT
                        Else
                          If s = 'AS' Then
                            Result := ddtAS
                          Else
                            If s = 'IS' Then
                              Result := ddtIS
                            Else
                              If s = 'DS' Then
                                Result := ddtDS
                              Else
                                If s = 'SS' Then
                                  Result := ddtSS
                                Else
                                  If s = 'US' Then
                                    Result := ddtUS
                                  Else
                                    If s = 'SL' Then
                                      Result := ddtSL
                                    Else
                                      If s = 'UL' Then
                                        Result := ddtUL
                                      Else
                                        If s = 'AT' Then
                                          Result := ddtAT
                                        Else
                                          If s = 'FL' Then
                                            Result := ddtFL
                                          Else
                                            If s = 'FD' Then
                                              Result := ddtFD
                                            Else
                                              If s = 'OB' Then
                                                Result := ddtOB
                                              Else
                                                If s = 'OW' Then
                                                  Result := ddtOW
                                                Else
                                                  If s = 'OF' Then
                                                    Result := ddtOF
                                                  Else
                                                    If s = 'SQ' Then
                                                      Result := ddtSQ
                                                    Else
                                                      If s = 'UN' Then Result := ddtUN;
End;

{TDummyObj - Validation Routines}

Procedure TDummyObj.ValidateCS(Sender: Tobject; Var Key: Char);
Begin
  If (Key In ['0'..'9', 'A'..'z', '_', ' ']) Or (Key = #13) Or (Key = #8) Then
    Key := Key
  Else
    Key := #0
End;

Procedure TDummyObj.ValidateUI(Sender: Tobject; Var Key: Char);
Begin
  If (Key In ['0'..'9', '.']) Or (Key = #13) Or (Key = #8) Then
    Key := Key
  Else
    Key := #0
End;

Procedure TDummyObj.ValidateDA(Sender: Tobject; Var Key: Char);
Begin
  If (Key In ['0'..'9']) Or (Key = #13) Or (Key = #8) Then
    Key := Key
  Else
    Key := #0
End;

Procedure TDummyObj.ValidateDT(Sender: Tobject; Var Key: Char);
Begin
  If (Key In ['0'..'9', '+', '-', '.']) Or (Key = #13) Or (Key = #8) Then
    Key := Key
  Else
    Key := #0
End;

Procedure TDummyObj.ValidateAS(Sender: Tobject; Var Key: Char);
Begin
  If (Key In ['0'..'9', 'D', 'W', 'M', 'Y', 'd', 'w', 'm', 'y']) Or (Key = #13) Or (Key = #8) Then
    Key := Key
  Else
    Key := #0
End;

Procedure TDummyObj.ValidateIS(Sender: Tobject; Var Key: Char);
Begin
  If (Key In ['0'..'9', '+', '-']) Or (Key = #13) Or (Key = #8) Then
    Key := Key
  Else
    Key := #0
End;

Procedure TDummyObj.ValidateDS(Sender: Tobject; Var Key: Char);
Begin
  If (Key In ['0'..'9', '+', '-', '.', 'E', 'e']) Or (Key = #13) Or (Key = #8) Then
    Key := Key
  Else
    Key := #0
End;

Procedure TDummyObj.ValidateNumeric(Sender: Tobject; Var Key: Char);
Begin
  If (Key In ['0'..'9']) Or (Key = #13) Or (Key = #8) Then
    Key := Key
  Else
    Key := #0
End;

{TDicomEdit}

Constructor TDicomEdit.Create(AOwner: TComponent; DataType: TDicomDataType; SName: String);
Begin
  Inherited Create(AOwner);
  Name := StringReplace(SName, ' ', '_', [RfReplaceAll]);
  SetDataType(DataType);
  TWinControl(AOwner).InsertControl(Self);
  TWinControl(AOwner).InsertControl(Self.EditLabel);
End;

Procedure TDicomEdit.SetDataType(Value: TDicomDataType);
Begin
  FDataType := Value;
  SetValidation;
  SetCase;
  SetMaxLength;
End;

Procedure TDicomEdit.SetValidation;
Var
  DummyObj: TDummyObj;
Begin
  DummyObj := TDummyObj.Create;
  Try
    Case FDataType Of
      ddtCS: OnKeyPress := DummyObj.ValidateCS;
      ddtUI, ddtTM: OnKeyPress := DummyObj.ValidateUI;
      ddtFL, ddtFD, ddtOF: OnKeyPress := DummyObj.ValidateUI; //float
      ddtDA: OnKeyPress := DummyObj.ValidateDA;
      ddtDT: OnKeyPress := DummyObj.ValidateDT;
      ddtAS: OnKeyPress := DummyObj.ValidateAS;
      ddtIS: OnKeyPress := DummyObj.ValidateIS;
      ddtDS: OnKeyPress := DummyObj.ValidateDS;
      ddtSS, ddtUS, ddtSL, ddtUL, ddtAT: OnKeyPress := DummyObj.ValidateNumeric;
    End;
  Finally
    DummyObj.Free;
  End;
End;

Procedure TDicomEdit.SetCase;
Begin
  If FDataType In [ddtCS, ddtAS] Then CharCase := ecUpperCase;
End;

Procedure TDicomEdit.SetMaxLength;
Begin
  Case FDataType Of
    ddtDA: MaxLength := 8;
    ddtCS, ddtSH, ddtAE, ddtTM: MaxLength := 16;
    ddtDT: MaxLength := 26;
    ddtLO, ddtPN, ddtUI: MaxLength := 64;
  End;
End;

Procedure TDicomEdit.SetLabelCaption(sCaption: String; Mandatory: Boolean);
Begin
  With EditLabel Do
  Begin
    caption := sCaption;
    If Mandatory Then
    Begin
      caption := MND + caption;
      Font.Color := clRed;
      Tag := 1;
    End; //if Mandatory...
  End; //with EditLabel...
End;

Procedure TDicomEdit.SetDimensions(iTop, iLeft, IWidth: Integer);
Begin
  Top := iTop;
  Left := iLeft;
  Width := IWidth;
End;

Function TDicomEdit.BldPairedStr: String;
Begin
  Result := Hint + ' ' + Name + '=' + Text
End;

{* Combo Box / Memo custom procedures*}

Procedure SetControlDimensions(Sender: TControl; iTop, iLeft, IWidth: Integer);
Begin
  Sender.Top := iTop;
  Sender.Left := iLeft;
  Sender.Width := IWidth;
End;

Procedure AddControlToDICOMForm(SB: TScrollBox; Sender: TControl; SName: String; bMandatory: Boolean);
Var
  Lbl: Tlabel;
Begin
  Sender.Name := StringReplace(SName, ' ', '_', [RfReplaceAll]);
  sender.Anchors := sender.Anchors + [akRight];  //gek 117 expand width of control, with form resizing
  SB.InsertControl(Sender);
  Lbl := Tlabel.Create(Nil);
  SB.InsertControl(Lbl);
  Lbl.Top := Sender.Top - 18;
  Lbl.Left := Sender.Left;
  Lbl.caption := SName;
  If bMandatory Then
  Begin
    Lbl.caption := MND + Lbl.caption;
    Lbl.Font.Color := clRed;
    Sender.Tag := 1;
  End;
  If Sender Is TComboBox Then TComboBox(Sender).Text := emptystr;
  If Sender Is TMemo Then TMemo(Sender).Clear;
End;

Procedure GetComboBoxValues(cmb: TComboBox; Broker: TRPCBroker; sFileNumber, sFieldNumber, sFilterFld, sFilter, sScreen: String);
Var
  Lookup: TMAGFMLookup;
  i, iCTR: Integer;
  sDisplay, sIEN: String;
  slDisplay: Tstringlist;
Begin
  slDisplay := Tstringlist.Create;
  Lookup := TMAGFMLookup.Create(Nil);
  Try
    Lookup.FMLookupGetLists(Broker, sFileNumber, sFieldNumber, sIEN, sDisplay, iCTR, sFilter, sFilterFld, sScreen);
    slDisplay.SetText(pAnsiChar(sDisplay));
    For i := 0 To slDisplay.Count - 1 Do
      cmb.Items.Add(slDisplay.Strings[i]);
  Finally
    slDisplay.Free;
    Lookup.Free;
  End;
End;

Procedure LoadComboBox(cmb: TComboBox; Broker: TRPCBroker);
Var
  i: Integer; 
Begin
  cmb.Items.Add('');
  If cmb.Hint = '0020,0060' Then // Laterality
  Begin
    cmb.Items.Add('Right');
    cmb.Items.Add('Left');
    cmb.Items.Add('Unpaired');
    cmb.Items.Add('Both Left and Right');
  End
  Else
    If cmb.Hint = '0018,0015' Then // Body Part Examined
    Begin
      GetComboBoxValues(cmb, Broker, '2005.99', '.01', '', '', 'I $P(^(0), "^",2) = "SKIN"');
      cmb.Sorted := true;
    End;
End;

End.
