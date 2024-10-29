Unit MagFMComponents;

Interface
Uses
  Classes,
  Diaccess,
  DiTypLib,
  Fmcmpnts,
  Trpcb;
(*******************************************************
  Vista Imaging FileMan Components
  Description:
  These components are descendents of the standard VA
  FileMan components.  They behave exactly the same
  as the standard components.

  Objective:
  Reduce the need to recompile delphi client applications
  when the Vista database changes.

  The new components have a new property
  REMOTEPROCEDURE:
    name of the RPC that will be called.  This defaults
    to a "MAG" version of the standard RPC called by the
    delphi FileMan equivalent component.

    With this property the developer can change the RPC.
    The objective is to insulate the client application
    from Vista database changes.

    Normally, the non standard RPC would pass requests
    through to the standard RPC and return the standard
    result to the delphi client.

    If the database changes, the client continues to
    make the same request to the non-standard RPC and
    the RPC modifies the request to correct for
    schema changes.  This adds a level of indirection
    that eliminates the need for the client application
    to be updated every time the database changes.
    Most database changes can be resolved by modifying
    the non-standard RPC.
  Each class has 2 new methods:
    Function SetRPCToDDR(): String;
      This method sets the RPC to the FileMan default.
    Function SetRPCToMag(): String;
      This method sets the RPC to a Vista Imaging
      default.
  With the exception of these minor changes, all other
  delphi FileMan component features should be in tact.

  Required RPCs
    TMagFMLister    assumes the presence of an RPC called 'MAGDDR LISTER'
    TMAGFMGets      assumes the presence of an RPC called 'MAGDDR GETS ENTRY DATA'
    TMAGFMValidator assumes the presence of an RPC called 'MAGDDR VALIDATOR'
    TMAGFMFiler     assumes the presence of an RPC called 'MAGDDR FILER'
    TMAGFMHelp      assumes the presence of an RPC called 'MAGDDR GET DD HELP'
    TMAGFMFinder    assumes the presence of an RPC called 'MAGDDR FINDER'
    TMAGFMFindOne   assumes the presence of an RPC called 'MAGDDR FIND1'

*******************************************************)
Type
  TMagFMLister = Class(TFMLister)
  Protected
    FFMRPC: String;
    FMagRpc: String;
    FRemoteProcedure: String;
    Function GetRemoteProcedure: String;
    Procedure SetRemoteProcedure(Const Value: String);
  Public
    Constructor Create(AOwner: TComponent); Override;
    Destructor Destroy; Override;
    Function SetRPCToDDR(): String;
    Function SetRPCToMag(): String;
    Procedure GoGetList(Target: TStrings); Override;
    Procedure Retrieve(sFileNumber, sFieldList: string; Target: TStrings = nil);
  Published
    Property REMOTEPROCEDURE: String Read GetRemoteProcedure Write SetRemoteProcedure;
  End;

  TMAGFMGets = Class(TFMGets)
  Protected
    FFMRPC: String;
    FMagRpc: String;
    FRemoteProcedure: String;
    Function GetRemoteProcedure: String;
    Procedure SetRemoteProcedure(Const Value: String);
  Public
    Constructor Create(AOwner: TComponent); Override;
    Destructor Destroy; Override;
    Function SetRPCToDDR(): String;
    Function SetRPCToMag(): String;
    Procedure GetData(); Override;
  Published
    Property REMOTEPROCEDURE: String Read GetRemoteProcedure Write SetRemoteProcedure;
  End;

  TMAGFMValidator = Class(TFMValidator)
  Protected
    FFMRPC: String;
    FMagRpc: String;
    FRemoteProcedure: String;
    Function GetRemoteProcedure: String;
    Procedure SetRemoteProcedure(Const Value: String);
  Public
    Constructor Create(AOwner: TComponent); Override;
    Destructor Destroy; Override;
    Function SetRPCToDDR(): String;
    Function SetRPCToMag(): String;
    Function Validate: Boolean; Override;
  Published
    Property REMOTEPROCEDURE: String Read GetRemoteProcedure Write SetRemoteProcedure;
  End;

  TMAGFMFiler = Class(TFMFiler)
  Protected
    FFMRPC: String;
    FMagRpc: String;
    FRemoteProcedure: String;
    Function GetRemoteProcedure: String;
    Procedure SetRemoteProcedure(Const Value: String);
  Public
    Constructor Create(AOwner: TComponent); Override;
    Destructor Destroy; Override;
    Function SetRPCToDDR(): String;
    Function SetRPCToMag(): String;
    Function Update: Boolean; Override;
  Published
    Property REMOTEPROCEDURE: String Read GetRemoteProcedure Write SetRemoteProcedure;
  End;

  TMAGFMHelp = Class(TFMHelp)
  Protected
    FFMRPC: String;
    FMagRpc: String;
    FRemoteProcedure: String;
    Function GetRemoteProcedure: String;
    Procedure SetRemoteProcedure(Const Value: String);
  Public
    Constructor Create(AOwner: TComponent); Override;
    Destructor Destroy; Override;
    Function GetHelp: TFMHelpObj; Override;
    Function SetRPCToDDR(): String;
    Function SetRPCToMag(): String;
  Published
    Property REMOTEPROCEDURE: String Read GetRemoteProcedure Write SetRemoteProcedure;
  End;

  TMAGFMFinder = Class(TFMFinder)
  Protected
    FFMRPC: String;
    FMagRpc: String;
    FRemoteProcedure: String;
    Function GetRemoteProcedure: String;
    Procedure SetRemoteProcedure(Const Value: String);
  Public
    Constructor Create(AOwner: TComponent); Override;
    Destructor Destroy; Override;
    Function SetRPCToDDR(): String;
    Function SetRPCToMag(): String;
    Procedure GoGetList(Target: TStrings); Override;
  Published
    Property REMOTEPROCEDURE: String Read GetRemoteProcedure Write SetRemoteProcedure;
  End;

  TMAGFMFindOne = Class(TFMFindOne)
  Protected
    FFMRPC: String;
    FMagRpc: String;
    FRemoteProcedure: String;
    Function GetRemoteProcedure: String;
    Procedure SetRemoteProcedure(Const Value: String);
  Public
    Constructor Create(AOwner: TComponent); Override;
    Destructor Destroy; Override;
    Function GetIEN(): String; Override;
    Function SetRPCToDDR(): String;
    Function SetRPCToMag(): String;
  Published
    Property REMOTEPROCEDURE: String Read GetRemoteProcedure Write SetRemoteProcedure;
  End;

  TMAGFMLookup = Class(TComponent)
  Protected
    Function StrTo255(s: String): String;
    Function DlgLookup(
      out sgReturn        : String;
      out sgDisplay       : String;
      sgCaption           : String;
      sgDisplayList       : String;
      sgReturnList        : String;
      sgDefaultDisplay    : String;
      inHeight            : Integer;
      inWidth             : Integer
      ): Boolean;
    Function DialogList(
      sgCaption           : String;
      sgDisplayList       : String;
      sgReturnList        : String;
      sgSelectedList      : String;
      boMultiSelect       : Boolean;
      inHeight            : Integer;
      inWidth             : Integer;
      out sgDisplay         : String;
      out sgStore           : String
      ): Boolean;
  Public
    Constructor Create(AOwner: TComponent); Override;
    Destructor Destroy; Override;
    Function FMLookupGetLists(Broker: TRPCBroker; FileNumber,FieldNumber: String; Out IENList, DisplayList: String;out Count: Integer;FilterField,Filter:String;  ScreenSTR: string  = ''): Boolean; //BB
    Function Lookup(Broker: TRPCBroker; FileNumber,DisplayFieldNumber, Caption: String;var DisplayValue, IENValue: String;FilterField,Filter:String): Boolean;
    Class Function Execute(Broker: TRPCBroker; FileNumber,DisplayFieldNumber, Caption: String;var DisplayValue, IENValue: String;FilterField,Filter:String): Boolean;
  End;

Procedure Register;

Implementation
Uses
  Buttons,
  Controls,
  Dialogs,
  ExtCtrls, 
  Fmcntrls,
  Forms,
  Graphics,
  MFunStr,
  StdCtrls,
  SysUtils,
  Windows;

{ TMagFMLister }

Constructor TMagFMLister.Create(AOwner: TComponent);
Begin
  Inherited;
  FFMRPC := 'DDR LISTER';
  FMagRpc := 'MAG' + FFMRPC;
  FRemoteProcedure := FMagRpc;
  FListerOptions := [loPackedResults]; //*** BB
End;

Destructor TMagFMLister.Destroy;
Begin

  Inherited;
End;

Function TMagFMLister.GetRemoteProcedure: String;
Begin
  Result := FRemoteProcedure;
End;

Procedure TMagFMLister.GoGetList(Target: TStrings);
Begin
  FMore := False;
  ErrorList.Clear;
  Try
    If BrokerOK(Self) And SetBrokerInfo Then
    Begin
      RPCBroker.REMOTEPROCEDURE := FRemoteProcedure;
      RPCBroker.Call;
      ParseResults(RPCBroker.Results, Target);
      ParseHelpErrors(RPCBroker);
    End
    Else
      RPCBroker.ClearParameters := True;
  Except
    Raise;
  End;
End;

Procedure TMagFMLister.SetRemoteProcedure(Const Value: String);
Begin
  FRemoteProcedure := Value;
End;

Function TMagFMLister.SetRPCToDDR: String;
Begin
  FRemoteProcedure := FFMRPC;
  Result := FRemoteProcedure;
End;

Function TMagFMLister.SetRPCToMag: String;
Begin
  FRemoteProcedure := FMagRpc;
  Result := FRemoteProcedure;
End;

Procedure TMagFMLister.Retrieve(sFileNumber, sFieldList: string; Target: TStrings = nil);
begin
  FileNumber := sFileNumber;
  FieldNumbers.SetText(PAnsiChar(sFieldList));
  DisplayFields.SetText(PAnsiChar(sFieldList));
  GetList(Target);
end;

{ TFMGets }

Constructor TMAGFMGets.Create(AOwner: TComponent);
Begin
  Inherited;
  FFMRPC := 'DDR GETS ENTRY DATA';
  FMagRpc := 'MAG' + FFMRPC;
  FRemoteProcedure := FMagRpc;
End;

Destructor TMAGFMGets.Destroy;
Begin

  Inherited;
End;

Procedure TMAGFMGets.GetData();
Begin
  ErrorList.Clear;
  Try
    If BrokerOK(Self) And SetBrokerInfo Then
    Begin
      RPCBroker.REMOTEPROCEDURE := FRemoteProcedure;
      RPCBroker.Call;
      ParseResults(RPCBroker.Results);
      ParseHelpErrors(RPCBroker);
      If (goDDHelp In FGetsOptions) Then FillHelp(RPCBroker.Results);
    End
    Else
      RPCBroker.ClearParameters := True;
  Except
    Raise;
  End;
End;

{ TMAGFMValidator }

Constructor TMAGFMValidator.Create(AOwner: TComponent);
Begin
  Inherited;
  FFMRPC := 'DDR VALIDATOR';
  FMagRpc := 'MAG' + FFMRPC;
  FRemoteProcedure := FMagRpc;
End;

Destructor TMAGFMValidator.Destroy;
Begin

  Inherited;
End;

Function TMAGFMValidator.GetRemoteProcedure: String;
Begin
  Result := FRemoteProcedure;
End;

Procedure TMAGFMValidator.SetRemoteProcedure(Const Value: String);
Begin
  FRemoteProcedure := Value;
End;

function TMAGFMValidator.SetRPCToDDR: String;
begin
  FRemoteProcedure := FFMRPC;
  Result := FRemoteProcedure;
end;

function TMAGFMValidator.SetRPCToMag: String;
begin
  FRemoteProcedure := FMagRpc;
  Result := FRemoteProcedure;
end;

Function TMAGFMValidator.Validate: Boolean;
Begin
  Result := False;
  ErrorList.Clear;
  If BrokerOK(Self) And PropertyOK(Self) Then
  Begin
    RPCBroker.REMOTEPROCEDURE := FRemoteProcedure;
    RPCBroker.RPCVersion := '1';
    With RPCBroker.PARAM[0] Do
    Begin
      Value := '.DDR';
      PTYPE := List;
      Mult['"FILE"'] := FFile;
      Mult['"IENS"'] := FIENS;
      Mult['"FIELD"'] := FField;
      Mult['"VALUE"'] := FValue;
    End;
    RPCBroker.Call;
    ParseResults(RPCBroker.Results);
    ParseHelpErrors(RPCBroker);
    Result := (FResults[0] <> u);
  End
End;

{ TMAGFMFiler }
Procedure TFMEditUpdate(Fld: TFMEdit; RPCBroker: TRPCBroker; subcnt: Integer); Forward;
Procedure TFMCheckBoxUpdate(Fld: TFMCheckBox; RPCBroker: TRPCBroker; subcnt: Integer); Forward;
Procedure TFMComboBoxUpdate(Fld: TFMComboBox; RPCBroker: TRPCBroker; subcnt: Integer); Forward;
Procedure TFMLabelUpdate(Fld: TFMLabel; RPCBroker: TRPCBroker; subcnt: Integer); Forward;
Procedure TFMListBoxUpdate(Fld: TFMListBox; RPCBroker: TRPCBroker; subcnt: Integer); Forward;
Procedure TFMMemoUpdate(Fld: TFMMemo; RPCBroker: TRPCBroker; subcnt: Integer); Forward;
Procedure TFMRadioButtonUpdate(Fld: TFMRadioButton; RPCBroker: TRPCBroker; subcnt: Integer); Forward;
Procedure TFMRadioGroupUpdate(Fld: TFMRadioGroup; RPCBroker: TRPCBroker; subcnt: Integer); Forward;

Constructor TMAGFMFiler.Create(AOwner: TComponent);
Begin
  Inherited;
  FFMRPC := 'DDR FILER';
  FMagRpc := 'MAG' + FFMRPC;
  FRemoteProcedure := FMagRpc;
End;

Destructor TMAGFMFiler.Destroy;
Begin

  Inherited;
End;

Function TMAGFMFiler.GetRemoteProcedure: String;
Begin
  Result := FRemoteProcedure;
End;

Procedure TMAGFMFiler.SetRemoteProcedure(Const Value: String);
Begin
  FRemoteProcedure := Value;
End;

function TMAGFMFiler.SetRPCToDDR: String;
begin
  FRemoteProcedure := FFMRPC;
  Result := FRemoteProcedure;
end;

function TMAGFMFiler.SetRPCToMag: String;
begin
  FRemoteProcedure := FMagRpc;
  Result := FRemoteProcedure;
end;

Function TMAGFMFiler.Update: Boolean;
Var
  i, Index, subcnt: Integer;
  Fld: Tobject;
  Cls, x: String;
  datatype: String;
  fda: TFMFDAObj;
  Source: TStrings;
  Obj: Tobject;
  iens: String;
Begin
  Fflags := ''; // need to evaluate this further jli 3-16-99
  //before starting, autovalidate activecontrol
  If (Owner Is TForm) And (TForm(Owner).ActiveControl <> Nil) Then
  Begin
    Obj := TForm(Owner).ActiveControl;
    If (Obj Is TFMEdit) Then
      TFMEdit(Obj).AutoValidate
    Else
      If (Obj Is TFMMemo) Then
        TFMMemo(Obj).AutoValidate
      Else
        If (Obj Is TFMListBox) Then
          TFMListBox(Obj).AutoValidate
        Else
          If (Obj Is TFMComboBox) Then
            TFMComboBox(Obj).AutoValidate
          Else
            If (Obj Is TFMRadioButton) Then
              TFMRadioButton(Obj).AutoValidate
            Else
              If (Obj Is TFMRadioGroup) Then
                TFMRadioGroup(Obj).AutoValidate
              Else
                If (Obj Is TFMCheckBox) Then TFMCheckBox(Obj).AutoValidate;
  End;
  {Before starting check if filing is appropriate.}
  If (Not AnythingToFile) Or (foNotEditable In FFilerOptions) Then
  Begin
    Result := True; {No error in filing, Update returns True}
    Exit;
  End;
  Result := False;
  ErrorList.Clear;
  Try
    If BrokerOK(Self) Then
    Begin
      Source := Tstringlist.Create;
      Screen.Cursor := crHourGlass;
      FNewIENs.Clear;
      FPlaceHolder.Clear;
      RPCBroker.REMOTEPROCEDURE := FRemoteProcedure;
      RPCBroker.RPCVersion := '1';
      {set up edited fields array}
      With RPCBroker.PARAM[1] Do
        PTYPE := List;
      subcnt := 0;
      For Index := 0 To (FChangedCtrlsList.Count - 1) Do
      Begin
        Fld := FChangedCtrlsList[Index];
        If Fld <> Nil Then
        Begin
          Inc(subcnt);
          Cls := Tobject(Fld).ClassName;
          If Fld Is TFMEdit Then
            TFMEditUpdate(TFMEdit(Fld), RPCBroker, subcnt)
          Else
            If Fld Is TFMCheckBox Then
              TFMCheckBoxUpdate(TFMCheckBox(Fld), RPCBroker, subcnt)
            Else
              If (Fld Is TFMComboBox) Or (Fld Is TFMComboBoxLookUp) Then
                TFMComboBoxUpdate(TFMComboBox(Fld), RPCBroker, subcnt)
              Else
                If Fld Is TFMLabel Then
                  TFMLabelUpdate(TFMLabel(Fld), RPCBroker, subcnt)
                Else
                  If Fld Is TFMListBox Then
                    TFMListBoxUpdate(TFMListBox(Fld), RPCBroker, subcnt)
                  Else
                    If Fld Is TFMMemo Then
                      TFMMemoUpdate(TFMMemo(Fld), RPCBroker, subcnt)
                    Else
                      If Fld Is TFMRadioButton Then
                        TFMRadioButtonUpdate(TFMRadioButton(Fld), RPCBroker, subcnt)
                      Else
                        If Fld Is TFMRadioGroup Then
                          TFMRadioGroupUpdate(TFMRadioGroup(Fld), RPCBroker, subcnt)
                        Else
                          Dec(subcnt);
        End;
        iens := Piece(RPCBroker.PARAM[1].Mult[Inttostr(subcnt)], u, 3);
        SetMode(IENS);
      End;
      {Add any required/key values to fda array scheme}
      For Index := 0 To (FFDAList.Count - 1) Do
      Begin
        {$WARNINGS OFF}
        fda := TFMFDAObj(FFDAList.Items[Index]);
        {$WARNINGS ON}
        If fda.FMFileNumber <> '' Then
        Begin
          Inc(subcnt);
          RPCBroker.PARAM[1].Mult[Inttostr(subcnt)] :=
            fda.FMFileNumber
            + u + fda.FMFieldNumber
            + u + fda.IENS
            + u + fda.FMInternal;
        End;
        iens := Piece(RPCBroker.PARAM[1].Mult[Inttostr(subcnt)], u, 3);
        SetMode(IENS);
      End;

      {set up edit-mode parameter}
      With RPCBroker.PARAM[0] Do
      Begin
        If FMode = 'AddEntry' Then
          Value := 'ADD'
        Else
          If FMode = 'EditEntry' Then Value := 'EDIT';
        PTYPE := LITERAL;
      End;

      {send loc'K' flag}
      With RPCBroker.PARAM[2] Do
      Begin
        PTYPE := LITERAL;
        If (FMode = 'EditEntry') And (ffLock In FFilerFlags) Then
          Value := Fflags + 'K';
      End;

      {send IENs array}
      If FIENsList.Count > 0 Then
        With RPCBroker.PARAM[1] Do
        Begin
          PTYPE := List;
          For i := 0 To FIENsList.Count - 1 Do
            Mult['"IENs",' + '"' + Piece(FIENsList[i], u, 1) + '"'] := Piece(FIENsList[i], u, 2);
        End;

      {Make call to broker}
      RPCBroker.Call;
      Source.Assign(RPCBroker.Results);
      datatype := '';
      For i := 0 To Source.Count - 1 Do
      Begin
        x := Source[i];
        If x = BEGINERRORS Then
          Break
        Else
          If x = '[Data]' Then
            datatype := 'Data'
          Else
            If datatype = 'Data' Then
            Begin
              FNewIENs.Add(x);
              FPlaceHolder.Add(Piece(x, u, 1));
            End
      End;
      Source.Free;
      ParseHelpErrors(RPCBroker);
      Result := (ErrorList.Count = 0);
      {Clean up processing}
      Self.Clear;
      Screen.Cursor := crDefault;
    End;
  Except
    Raise;
  End;
End;

Procedure TFMEditUpdate(Fld: TFMEdit; RPCBroker: TRPCBroker; subcnt: Integer);
Begin
  With RPCBroker.PARAM[1] Do
  Begin
    Mult[Inttostr(subcnt)] :=
      Fld.Fmfile
      + u + Fld.FMField
      + u + Fld.IENS
      + u + Fld.FMCtrlInternal;
  End;
End;

Procedure TFMCheckBoxUpdate(Fld: TFMCheckBox; RPCBroker: TRPCBroker; subcnt: Integer);
Begin
  With RPCBroker.PARAM[1] Do
  Begin
    Mult[Inttostr(subcnt)] :=
      Fld.Fmfile
      + u + Fld.FMField
      + u + Fld.IENS
      + u + Fld.FMCtrlInternal;
  End;
End;

Procedure TFMComboBoxUpdate(Fld: TFMComboBox; RPCBroker: TRPCBroker; subcnt: Integer);
Begin
  With RPCBroker.PARAM[1] Do
  Begin
    Mult[Inttostr(subcnt)] :=
      Fld.Fmfile
      + u + Fld.FMField
      + u + Fld.IENS
      + u + Fld.FMCtrlInternal;
  End;
End;

Procedure TFMLabelUpdate(Fld: TFMLabel; RPCBroker: TRPCBroker; subcnt: Integer);
Begin
  With RPCBroker.PARAM[1] Do
  Begin
    Mult[Inttostr(subcnt)] :=
      Fld.Fmfile
      + u + Fld.FMField
      + u + Fld.IENS
      + u + Fld.FMCtrlInternal;
  End;
End;

Procedure TFMListBoxUpdate(Fld: TFMListBox; RPCBroker: TRPCBroker; subcnt: Integer);
Begin
  With RPCBroker.PARAM[1] Do
  Begin
    Mult[Inttostr(subcnt)] :=
      Fld.Fmfile
      + u + Fld.FMField
      + u + Fld.IENS
      + u + Fld.FMCtrlInternal;
  End;
End;

Procedure TFMMemoUpdate(Fld: TFMMemo; RPCBroker: TRPCBroker; subcnt: Integer);
Var
  i, Last: Integer;
Begin
  i := 0;
  With RPCBroker.PARAM[1] Do
  Begin
    {place file, field & entry info in parent node}
    Mult[Inttostr(subcnt)] :=
      Fld.Fmfile
      + u + Fld.FMField
      + u + Fld.IENS
      + u + 'DDRROOT(' + Inttostr(subcnt) + ')';
      {add memo field data}
    If Fld.Lines.Count > 0 Then
    Begin
      Last := Fld.Lines.Count - 1;
      For i := 0 To Last Do
      Begin
        Mult[Inttostr(subcnt) + ',' + Inttostr(i + 1)] := Fld.Lines[i];
      End;
    End
    Else
      Mult[Inttostr(subcnt) + ',' + Inttostr(i + 1)] := '';
  End;
End;

Procedure TFMRadioButtonUpdate(Fld: TFMRadioButton; RPCBroker: TRPCBroker; subcnt: Integer);
Begin
  With RPCBroker.PARAM[1] Do
  Begin
    Mult[Inttostr(subcnt)] :=
      Fld.Fmfile
      + u + Fld.FMField
      + u + Fld.IENS
      + u + Fld.FMCtrlInternal;
  End;
End;

Procedure TFMRadioGroupUpdate(Fld: TFMRadioGroup; RPCBroker: TRPCBroker; subcnt: Integer);
Begin
  With RPCBroker.PARAM[1] Do
  Begin
    Mult[Inttostr(subcnt)] :=
      Fld.Fmfile
      + u + Fld.FMField
      + u + Fld.IENS
      + u + Fld.FMCtrlInternal;
  End;
End;

{ TMAGFMHelp }

Constructor TMAGFMHelp.Create(AOwner: TComponent);
Begin
  Inherited;
  FFMRPC := 'DDR GET DD HELP';
  FMagRpc := 'MAG' + FFMRPC;
  FRemoteProcedure := FMagRpc;
End;

Destructor TMAGFMHelp.Destroy;
Begin

  Inherited;
End;

Function TMAGFMHelp.GetHelp: TFMHelpObj;
Var
  x: String;
  Item: Integer;
  Hlp: TFMHelpObj;
Begin
  Try
    Result := Nil;
    Hlp := Nil;
    Item := 0;
    If SetBrokerInfo Then
    Begin
      RPCBroker.REMOTEPROCEDURE := FRemoteProcedure;
      RPCBroker.Call;
      While (x <> ENDHELP) And (Item < RPCBroker.Results.Count - 1) Do
      Begin
        Inc(Item);
        x := RPCBroker.Results[Item];
        If x = ENDHELP Then Break;
        Hlp := LoadOneHelp(RPCBroker.Results, Item, x);
      End;
      Result := Hlp;
    End;
  Except
    Raise;
  End;
End;

Function TMAGFMHelp.GetRemoteProcedure: String;
Begin
  Result := FRemoteProcedure;
End;

Procedure TMAGFMHelp.SetRemoteProcedure(Const Value: String);
Begin
  FRemoteProcedure := Value;
End;

function TMAGFMHelp.SetRPCToDDR: String;
begin
  FRemoteProcedure := FFMRPC;
  Result := FRemoteProcedure;
end;

function TMAGFMHelp.SetRPCToMag: String;
begin
  FRemoteProcedure := FMagRpc;
  Result := FRemoteProcedure;
end;

{ TMAGFMFinder }

Constructor TMAGFMFinder.Create(AOwner: TComponent);
Begin
  Inherited;
  FFMRPC := 'DDR FINDER';
  FMagRpc := 'MAG' + FFMRPC;
  FRemoteProcedure := FMagRpc;
End;

Destructor TMAGFMFinder.Destroy;
Begin

  Inherited;
End;

Function TMAGFMFinder.GetRemoteProcedure: String;
Begin
  Result := FRemoteProcedure;
End;

Procedure TMAGFMFinder.GoGetList(Target: TStrings);
Begin
  FMore := False;
  ErrorList.Clear;
  Try
    If BrokerOK(Self) And SetBrokerInfo Then
    Begin
      RPCBroker.REMOTEPROCEDURE := FRemoteProcedure;
      RPCBroker.Call;
      ParseResults(RPCBroker.Results, Target);
      ParseHelpErrors(RPCBroker);
    End
    Else
      RPCBroker.ClearParameters := True;
  Except
    Raise;
  End;
End;

Procedure TMAGFMFinder.SetRemoteProcedure(Const Value: String);
Begin
  FRemoteProcedure := Value;
End;

function TMAGFMFinder.SetRPCToDDR: String;
begin
  FRemoteProcedure := FFMRPC;
  Result := FRemoteProcedure;
end;

function TMAGFMFinder.SetRPCToMag: String;
begin
  FRemoteProcedure := FMagRpc;
  Result := FRemoteProcedure;
end;

{ TMAGFMFindOne }

Constructor TMAGFMFindOne.Create(AOwner: TComponent);
Begin
  Inherited;
  FFMRPC := 'DDR FIND1';
  FMagRpc := 'MAG' + FFMRPC;
  FRemoteProcedure := FMagRpc;
End;

Destructor TMAGFMFindOne.Destroy;
Begin

  Inherited;
End;

Function TMAGFMFindOne.GetIEN: String;
Begin
  Result := '';
  Errorlist.Clear;
  Try
    If SetBrokerInfo Then
    Begin
      RPCBroker.REMOTEPROCEDURE := FRemoteProcedure;
      RPCBroker.Call;
      Result := RPCBroker.Results[0];
      ParseHelpErrors(RPCBroker);
    End;
  Except
    Result := ''; {error condition outside of M}
    Raise;
  End;
End;

Function TMAGFMFindOne.GetRemoteProcedure: String;
Begin
  Result := FRemoteProcedure;
End;

Procedure TMAGFMFindOne.SetRemoteProcedure(Const Value: String);
Begin
  FRemoteProcedure := Value;
End;

function TMAGFMFindOne.SetRPCToDDR: String;
begin
  FRemoteProcedure := FFMRPC;
  Result := FRemoteProcedure;
end;

function TMAGFMFindOne.SetRPCToMag: String;
begin
  FRemoteProcedure := FMagRpc;
  Result := FRemoteProcedure;
end;

Function TMAGFMGets.GetRemoteProcedure: String;
Begin
  Result := FRemoteProcedure;
End;

Procedure TMAGFMGets.SetRemoteProcedure(Const Value: String);
Begin
  FRemoteProcedure := Value;
End;

Function TMAGFMGets.SetRPCToDDR: String;
Begin
  FRemoteProcedure := FFMRPC;
  Result := FRemoteProcedure;
End;

Function TMAGFMGets.SetRPCToMag: String;
Begin
  FRemoteProcedure := FMagRpc;
  Result := FRemoteProcedure;
End;

Procedure Register;
Begin
  RegisterComponents('MagFileMan', [TMAGFMLister]);
  RegisterComponents('MagFileMan', [TMAGFMGets]);
  RegisterComponents('MagFileMan', [TMAGFMValidator]);
  RegisterComponents('MagFileMan', [TMAGFMFiler]);
  RegisterComponents('MagFileMan', [TMAGFMHelp]);
  RegisterComponents('MagFileMan', [TMAGFMFinder]);
  RegisterComponents('MagFileMan', [TMAGFMFindOne]);
  RegisterComponents('MagFileMan', [TMAGFMLookup]);
End;

{ TMAGFMLookup }

constructor TMAGFMLookup.Create(AOwner: TComponent);
begin
  inherited;

end;

destructor TMAGFMLookup.Destroy;
begin

  inherited;
end;

function TMAGFMLookup.DialogList(sgCaption, sgDisplayList, sgReturnList,
  sgSelectedList: String; boMultiSelect: Boolean; inHeight,
  inWidth: Integer; out sgDisplay, sgStore: String): Boolean;
Var
  inSelected          : Integer;
  inCounter           : Integer;
  frm                 : TForm;
  pnlBase             : TPanel;
  pnlButtons          : TPanel;
  btnOK               : TBitBtn;
  btnCancel           : TBitBtn;
  lstReturnList       : TListBox;
  lstDisplayList      : TListBox;
  lstSReturnList      : TStringList;
  lstSDisplayList     : TStringList;
  lstSelected         : TStringList;
  lstSelectedExist    : TStringList;
Begin
  Result              := False;
  If inWidth < 180 Then inWidth := 180;
  pnlBase             := nil;
  pnlButtons          := nil;
  btnOK               := nil;
  btnCancel           := nil;
  lstReturnList       := nil;
  lstDisplayList      := nil;
  frm                 := TForm.Create(nil);
  lstSReturnList      := TStringList.Create();
  lstSDisplayList     := TStringList.Create();
  lstSelected         := TStringList.Create();
  lstSelectedExist    := TStringList.Create();
  Try
    lstSReturnList   .Clear;
    lstSDisplayList  .Clear;
    lstSelected      .Clear;
    lstSelectedExist .Clear;

    {$IFDEF LOOKUPUSEREDITABLE}
    {The user can edit the Display and Return lists by editing the following files:
    C:\Documents and Settings\<userid>\Local Settings\Application Data\<ExeName>\Lookups\<Dialog Caption>.Display.txt
    C:\Documents and Settings\<userid>\Local Settings\Application Data\<ExeName>\Lookups\<Dialog Caption>.Return.txt}
    DlgLookupEditable_ads(sgCaption,sgDisplayList,sgReturnList);
    {$ENDIF}
    {$WARNINGS OFF}
    lstSReturnList   .SetText(PChar(sgReturnList));
    lstSDisplayList  .SetText(PChar(sgDisplayList));
    lstSelected      .SetText(PChar(sgSelectedList));
    {$WARNINGS ON}
    If lstSDisplayList.Count <> lstSReturnList.Count Then
    Begin
      ShowMessage('DialogList Error: Display and Return lists must be the same size.');
      Exit;
    End;
    With frm Do
    Begin
      Left           := 477;
      Top            := 327;
      BorderIcons    := [];
      BorderStyle    := bsDialog;
      Caption        := sgCaption;
      ClientHeight   := inHeight;
      ClientWidth    := inWidth;
      Color          := clBtnFace;
      Font.Charset   := DEFAULT_CHARSET;
      Font.Color     := clWindowText;
      Font.Height    := -11;
      Font.Name      := 'MS Sans Serif';
      Font.Style     := [];
      OldCreateOrder := False;
      Position       := poScreenCenter;
      PixelsPerInch  := 96;
      ShowHint       := True;
      FormStyle      := fsStayOnTop;
    End;
    pnlBase := TPanel.Create(frm);
    With pnlBase Do
    Begin
      Parent      := frm;
      Left        := 0;
      Top         := 0;
      Width       := frm.ClientWidth;
      Height      := frm.ClientHeight;
      Align       := alClient;
      BevelOuter  := bvNone;
      BorderWidth := 10;
      Caption     := '  ';
      TabOrder    := 0;
    End;
    pnlButtons    := TPanel.Create(frm);
    With pnlButtons Do
    Begin
      Parent      := pnlBase;
      Left        := 10;
      Top         := 270;
      Width       := pnlBase.Width - 20;
      Height      := 43;
      Align       := alBottom;
      BevelOuter  := bvNone;
      Caption     := '  ';
      TabOrder    := 0;
    End;
    btnOK         := TBitBtn.Create(frm);
    With btnOK Do
    Begin
      Parent      := pnlButtons;
      Top         := 16;
      Width       := 75;
      Height      := 25;
      Enabled     := True;
      TabOrder    := 0;
      Kind        := bkOK;
      Left        := pnlButtons.Width - 160;
      Hint        := 'Close and return selection.';
    End;
    btnCancel     := TBitBtn.Create(frm);
    With btnCancel Do
    Begin
      Parent      := pnlButtons;
      Top         := 16;
      Width       := 75;
      Height      := 25;
      TabOrder    := 1;
      Kind        := bkCancel;
      Left        := pnlButtons.Width - 75;
      Hint        := 'Close and make no selection.';
    End;

    lstReturnList := TListBox.Create(frm);
    With lstReturnList Do
    Begin
      Parent       := pnlBase;
      Left         := 10;
      Top          := 10;
      Width        := 272;
      Height       := 260;
      Align        := alClient;
      ItemHeight   := 13;
      TabOrder     := 3;
      {$WARNINGS OFF}
      Items.SetText(PChar(sgReturnList));
      {$WARNINGS ON}
    End;
    lstDisplayList := TListBox.Create(frm);
    With lstDisplayList Do
    Begin
      Parent       := pnlBase;
      MultiSelect  := boMultiSelect;
      Left         := 10;
      Top          := 10;
      Width        := 272;
      Font.Name    := 'QuickType II Mono';
      Height       := 260;
      Align        := alClient;
      ItemHeight   := 13;
      TabOrder     := 1;
      {$WARNINGS OFF}
      Items.SetText(PChar(sgDisplayList));
      {$WARNINGS ON}
      If boMultiSelect Then
      Begin
        Hint := 'Ctrl-Click multiple items to select them.';
      End
      Else
      Begin
        Hint := 'Click an item to select it.';
      End;
    End;
    sgDisplay := '';
    sgStore   := '';
    For inCounter := 0 To lstSelected.Count - 1 Do
    Begin
      inSelected := lstDisplayList.Items.IndexOf(lstSelected[inCounter]);
      If inSelected <> -1 Then
      Begin
        lstSelectedExist.Add(lstSelected[inCounter]);
        If Not boMultiSelect Then
        Begin
          lstDisplayList.ItemIndex := inSelected;
          If sgDisplay = '' Then
            sgDisplay := lstDisplayList.Items[inSelected]
          Else
            sgDisplay := sgDisplay+#13+lstDisplayList.Items[inSelected];
          If sgStore = '' Then
            sgStore := lstSReturnList[inSelected]
          Else
            sgStore := sgStore+#13+lstSReturnList[inSelected];
          Break;
        End
        Else
        Begin
          lstDisplayList.Selected[inSelected] := True;
          If sgDisplay = '' Then
            sgDisplay := lstDisplayList.Items[inSelected]
          Else
            sgDisplay := sgDisplay+#13+lstDisplayList.Items[inSelected];
          If sgStore = '' Then
            sgStore := lstSReturnList[inSelected]
          Else
            sgStore := sgStore+#13+lstSReturnList[inSelected];
        End;
      End
    End;
    {$IFDEF LOOKUPINCLUDE}
    DlgLookupInclude_ads(sgCaption,sgDisplayList,sgReturnList);
    {$ENDIF}
    If frm.ShowModal = mrOK Then
    Begin
      sgDisplay := '';
      sgStore   := '';
      Result    := True;
      lstSReturnList.Clear;
      For inCounter := 0 To lstDisplayList.Items.Count - 1 Do
      Begin
        If lstDisplayList.Selected[inCounter] Then
        Begin
          lstSReturnList.Add(lstReturnList.Items[inCounter]);
          If Not boMultiSelect Then
          Begin
            sgStore          := lstSReturnList[0];
            sgDisplay        := lstDisplayList.Items[inCounter];
            Break;
          End
          Else
          Begin
            sgStore          := lstSReturnList.Text;
            If sgDisplay = '' Then
              sgDisplay := lstDisplayList.Items[inCounter]
            Else
              sgDisplay := sgDisplay+#13+lstDisplayList.Items[inCounter];
          End;
        End;
      End;
    End
    Else
    Begin
      Result := False;
    End;
  Finally
    lstDisplayList   .Free;
    lstReturnList    .Free;
    btnCancel        .Free;
    btnOK            .Free;
    pnlButtons       .Free;
    pnlBase          .Free;
    frm.Free;
    lstSReturnList   .Free;
    lstSDisplayList  .Free;
    lstSelected      .Free;
    lstSelectedExist .Free;
  End;
End;

function TMAGFMLookup.DlgLookup(out sgReturn, sgDisplay: String; sgCaption,
  sgDisplayList, sgReturnList, sgDefaultDisplay: String; inHeight,
  inWidth: Integer): Boolean;
Var
  boMultiSelect       : Boolean;
  sgReturnBefore      : String;
  sgDisplayBefore     : String;
  lstDisplayList      : TStringList;
  lstReturnList       : TStringList;
  inIndexBefore       : Integer;
Begin
  boMultiSelect       := False;
  lstDisplayList      := TStringList.Create();
  lstReturnList       := TStringList.Create();
  Try
    {$WARNINGS OFF}
    lstDisplayList.SetText(PChar(sgDisplayList));
    lstReturnList .SetText(PChar(sgReturnList));
    {$WARNINGS ON}
    inIndexBefore     := lstDisplayList.IndexOf(sgDefaultDisplay);
    If inIndexBefore <> -1 Then
    Begin
      sgDisplayBefore := lstDisplayList[inIndexBefore];
      sgReturnBefore  := lstReturnList [inIndexBefore];
    End
    Else
    Begin
      sgDisplayBefore := '';
      sgReturnBefore  := '';
    End;
    Result          :=
      DialogList(
        sgCaption       , //sgCaption         : String;
        sgDisplayList   , //sgDisplayList     : String;
        sgReturnList    , //sgReturnList      : String;
        sgDefaultDisplay, //sgSelectedList    : String;
        boMultiSelect   , //boMultiSelect     : Boolean;
        inHeight        , //inHeight          : Integer;
        inWidth         , //inWidth           : Integer
        sgDisplay       , //out sgDisplay     : String;
        sgReturn          //out sgStore       : String
                        );//): Boolean;
  Finally
    lstDisplayList    .Free;
    lstReturnList     .Free;
  End;
End;

class function TMAGFMLookup.Execute(Broker: TRPCBroker; FileNumber,
  DisplayFieldNumber, Caption: String; var DisplayValue, IENValue: String;
  FilterField, Filter: String): Boolean;
Var
  LU: TMAGFMLookup;
begin
  LU:= TMAGFMLookup.Create(nil);
  Try
    Result:=
      LU.Lookup(
        Broker,            //Broker            : TRPCBroker;
        FileNumber,        //FileNumber        : String
        DisplayFieldNumber,//DisplayFieldNumber: String
        Caption,           //Caption           : String
        DisplayValue,      //var DisplayValue  : String
        IENValue,          //IENValue          : String
        FilterField,       //FilterField       : String
        Filter             //Filter            : String
                         );//): Boolean;
  Finally
    FreeAndNil(LU);
  End;
end;

function TMAGFMLookup.FMLookupGetLists(Broker: TRPCBroker; FileNumber,
  FieldNumber: String; out IENList, DisplayList: String;
  out Count: Integer; FilterField, Filter: String; ScreenSTR: string  = ''): Boolean; //BB
Var
  f          : TFMFieldObj;
  fml        : TMAGFmLister;
  lstCombined: Tstringlist;
  lstDisplay : Tstringlist;
  lstIENS    : Tstringlist;
  r          : Integer;
  Rec        : TFMRecordObj;
  Results    : Tstringlist;
  sg01       : String;
  sgIENS     : String;
Begin
  fml        := TMAGFmLister.Create(Nil);
  lstCombined:= Tstringlist.Create();
  lstDisplay := Tstringlist.Create();
  lstIENS    := Tstringlist.Create();
  Result     := False;
  Results    := Tstringlist.Create();
  Try
    fml.RPCBroker  := Broker;
    fml.FileNumber := FileNumber;
    If Trim(Filter)<>'' Then
    Begin
      FilterField:=Trim(FilterField);
      //If FilterField<>'.01' Then
      //Begin
        //fml.FieldNumbers.Insert(0,FilterField);
      //End;
      If FilterField<>'.01' Then
      Begin
        fml.FieldNumbers.Insert(0,FilterField);
      End
      else
      begin
        fml.FieldNumbers.Insert(0,'@');
      end;
      fml.PartList.Clear();
      fml.PartList.Add(Filter);
    End;
    if ScreenSTR <> '' then fml.Screen := ScreenSTR;//BB
    fml.GetList(Results);
    lstCombined.Duplicates := DupIgnore;
    lstCombined.Sorted := True;
    For r := 0 To Results.Count - 1 Do
    Begin
      Rec := (Results.Objects[r] As TFMRecordObj);
      If Rec <> Nil Then
      Begin
        f := Rec.GetField(FieldNumber);
        If f <> Nil Then
        Begin
          sgIENS := StrTo255(Trim(f.IENS));
          sg01 := StrTo255(Trim(f.FMDBExternal));
          lstCombined.Add(sg01 + sgIENS)
        End;
      End;
    End;
    lstIENS.Clear();
    lstDisplay.Clear();
    For r := 0 To lstCombined.Count - 1 Do
    Begin
      lstIENS.Append(Trim(Copy(lstCombined[r], 256, Length(lstCombined[r]) - 256 + 1)));
      lstDisplay.Append(Trim(Copy(lstCombined[r], 1, 255)));
    End;
    IENList     := lstIENS.Text;
    DisplayList := lstDisplay.Text;
    Count       := lstDisplay.Count;
  Finally
    FreeAndNil(fml);
    FreeAndNil(lstCombined);
    FreeAndNil(lstDisplay);
    FreeAndNil(lstIENS);
    FreeAndNil(Results);
  End;
End;

function TMAGFMLookup.Lookup(Broker: TRPCBroker; FileNumber,
  DisplayFieldNumber, Caption: String; var DisplayValue, IENValue: String;
  FilterField, Filter: String): Boolean;
Var
  inCount         : Integer;
  inHeight        : Integer;
  inListHeight    : Integer;
  inWidth         : Integer;
  sgDefaultDisplay: String;
  sgDisplay       : String;
  sgDisplayList   : String;
  sgReturn        : String;
  sgReturnList    : String;
Begin
  sgReturn        := IENValue;
  sgDisplay       := DisplayValue;
  sgDefaultDisplay:= DisplayValue;
  FMLookupGetLists(Broker,FileNumber,DisplayFieldNumber,sgReturnList, sgDisplayList,inCount,FilterField,Filter);
  inHeight        := Screen.Height - 100;
  inListHeight    := (inCount*13)+50;
  If inListHeight<100 Then inListHeight:=100;
  If inListHeight<inHeight Then inHeight:=inListHeight;
  inWidth := 400;
  Result :=
    DlgLookup(
    sgReturn,
    sgDisplay,
    Caption,
    sgDisplayList,
    sgReturnList,
    sgDefaultDisplay,
    inHeight,
    inWidth
    );
  If Result Then
  Begin
    DisplayValue := Trim(sgDisplay);
    IENValue := Trim(sgReturn);
    IENValue := StringReplace(IENValue, ',', '', [RfReplaceAll]);
    If (DisplayValue='') Or (IENValue='') Then Result:= False;
  End;
End;

function TMAGFMLookup.StrTo255(s: String): String;
Var
  i: Integer;
  inLen: Integer;
Begin
  inLen := 255 - Length(s) - 1;
  For i := 0 To inLen Do
    s := s + ' ';
  Result := s;
End;

End.
