{*******************************************************}
{       VA FileMan Delphi Components                    }
{                                                       }
{       San Francisco CIOFO                             }
{                                                       }
{       Revision Date: 11/25/97                         }
{                                                       }
{       Distribution Date: 02/28/98                     }
{                                                       }
{       Version: 1.0                                    }
{                                                       }
{*******************************************************}

Unit Diaccess;

Interface

Uses
  SysUtils,
  WinTypes,
  WinProcs,
  Messages,
  Classes,
  Graphics,
  Controls,
  Forms,
  Dialogs,
  {FileMan Units}
  Dityplib,
  {Broker Units}
  MFunStr,
  Trpcb,
  Xwbut1;

Const
  BEGINDATA = '[BEGIN_diDATA]';
  ENDDATA = '[END_diDATA]';
  BEGINERRORS = '[BEGIN_diERRORS]';
  ENDERRORS = '[END_diERRORS]';
  BEGINHELP = '[BEGIN_diHELP]';
  ENDHELP = '[END_diHELP]';
  Fi = ' File Number';
  Fl = ' Field Number';
  ie = ' Record Number (IENS)';
  VA = ' Value';

Type
  ENoBrokerLink = Class(Exception);
  EMissingProp = Class(Exception);
  ENullParam = Class(Exception);

  TFMAccess = Class(TComponent)
  Private
  Protected
    // Variables and procedures moved from private -----------------------------
    FErrorList: Tlist;
    FHelpList: Tlist;
    FHelpBtn: Boolean;
    FRPCBroker: TRPCBroker;
    Procedure LoadErrors(RPCBroker: TRPCBroker; Var Item: Integer); Virtual;
    Procedure AddError(AError: TFMErrorObj); Virtual;
    Procedure LoadHelp(RPCBroker: TRPCBroker; Var Item: Integer); Virtual;
    Procedure AddHelp(AHelp: TFMHelpObj); Virtual;
    Procedure ClearHelp; Virtual;
    // End of variables and procedures moved from private ------------------------
  Public
    Property ErrorList: Tlist Read FErrorList Write FErrorList;
    Property HelpList: Tlist Read FHelpList Write FHelpList; //d0
    Property HelpBtn: Boolean Read FHelpBtn Write FHelpBtn Default False; //d0
    Constructor Create(AOwner: TComponent); Override;
    Destructor Destroy; Override;
    Procedure DisplayErrors; Virtual;
    Procedure ClearErrors; Virtual;
    Procedure ParseHelpErrors(RPCBroker: TRPCBroker); Virtual; //d0
    Function LoadOneHelp(Source: TStrings; Var Item: Integer; x: String): TFMHelpObj; Virtual; //d0
  Published
    Property RPCBroker: TRPCBroker Read FRPCBRoker Write FRPCBroker;
  End;

Function BrokerOK(Sender: Tobject): Boolean;
Function PropertyOK(Sender: Tobject): Boolean;
Function Null(Val: String): Boolean;
Function ParamOK(PARAM: String): Boolean;

Implementation

Uses Fmcmpnts;

Function BrokerOK(Sender: Tobject): Boolean;
Var
  RPCBroker: TRPCBroker;
Begin
  RPCBroker := TFMAccess(Sender).RPCBroker;
  If RPCBroker <> Nil Then
  Begin
    RPCBroker.ClearResults := True;
    RPCBroker.ClearParameters := True;
    RPCBroker.RPCVersion := '1';
    Result := True;
  End
  Else
    Raise ENoBrokerLink.Create('"' + TComponent(Sender).Name +
      '" is not associated with a Broker link.'
      + #13#10 +
      'Please contact developer for assistance');
End;

Procedure TFMGetsCheck(Var Obj: TFMGets; Var Msg: String); Forward;
Procedure TFMValidatorCheck(Var Obj: TFMValidator; Var Msg: String); Forward;
Procedure TFMListerCheck(Var Obj: TFMLister; Var Msg: String); Forward;
Procedure TFMFindOneCheck(Var Obj: TFMFindOne; Var Msg: String); Forward;
Procedure TFMHelpCheck(Var Obj: TFMHelp; Var Msg: String); Forward;
Procedure TFMFinderCheck(Var Obj: TFMFinder; Var Msg: String); Forward;

Function PropertyOK(Sender: Tobject): Boolean;
Var
  Msg: String;
Begin
  Msg := '';
  If Sender Is TFMValidator Then
    TFMValidatorCheck(TFMValidator(Sender), Msg)
  Else
    If Sender Is TFMLister Then
      TFMListerCheck(TFMLister(Sender), Msg)
    Else
      If Sender Is TFMGets Then
        TFMGetsCheck(TFMGets(Sender), Msg)
      Else
        If Sender Is TFMFindOne Then
          TFMFindOneCheck(TFMFindOne(Sender), Msg)
        Else
          If Sender Is TFMHelp Then
            TFMHelpCheck(TFMHelp(Sender), Msg)
          Else
            If Sender Is TFMFinder Then TFMFinderCheck(TFMFinder(Sender), Msg);
  If Msg <> '' Then
    Raise EMissingProp.Create(TComponent(Sender).Name +
      Msg + ' is not initialized');
  Result := True;
End;

Function Null(Val: String): Boolean;
Begin
  Result := False;
  If Val = '' Then Result := True;
End;

Function ParamOK(PARAM: String): Boolean;
Begin
  If Null(PARAM) Then
    Raise ENullParam.Create('"Required Parameter" is null')
  Else
    Result := True;
End;

Procedure TFMGetsCheck(Var Obj: TFMGets; Var Msg: String);
Begin
  If Null(TFMGets(Obj).FileNumber) Then Msg := Fi;
  If Null(TFMGets(Obj).IENS) Then Msg := ie;
End;

Procedure TFMValidatorCheck(Var Obj: TFMValidator; Var Msg: String);
Begin
  If Null(TFMValidator(Obj).FileNumber) Then Msg := Fi;
  If Null(TFMValidator(Obj).FieldNumber) Then Msg := Fl;
  If Null(TFMValidator(Obj).IENS) Then Msg := ie;
End;

Procedure TFMListerCheck(Var Obj: TFMLister; Var Msg: String);
Begin
  If Null(TFMLister(Obj).FileNumber) Then Msg := Fi;
End;

Procedure TFMFindOneCheck(Var Obj: TFMFindOne; Var Msg: String);
Begin
  If Null(TFMFindOne(Obj).FileNumber) Then Msg := Fi;
  If Null(TFMFindOne(Obj).Value) Then Msg := VA;
End;

Procedure TFMHelpCheck(Var Obj: TFMHelp; Var Msg: String);
Begin
  If Null(TFMHelp(Obj).FileNumber) Then Msg := Fi;
  If Null(TFMHelp(Obj).FieldNumber) Then Msg := Fi;
End;

Procedure TFMFinderCheck(Var Obj: TFMFinder; Var Msg: String);
Begin
  If Null(TFMFinder(Obj).FileNumber) Then Msg := Fi;
  If Null(TFMFinder(Obj).Value) Then Msg := VA;
End;

{**********TFMAccess methods**********}

Constructor TFMAccess.Create(AOwner: TComponent);
Begin
  Inherited Create(AOwner);
  FErrorList := Tlist.Create;
  FHelpList := Tlist.Create;
End;

Destructor TFMAccess.Destroy;
Begin
  FErrorList.Free;
  FHelpList.Free;
  Inherited Destroy;
End;

{Adds an error object to the FErrorList}

Procedure TFMAccess.AddError(AError: TFMErrorObj);
Begin
  FErrorList.Add(AError);
End;

{Displays all error on the component's error list.}

Procedure TFMAccess.DisplayErrors;
Var
  i: Integer;
Begin
  If FErrorList.Count = 0 Then Exit;
  For i := 0 To FErrorList.Count - 1 Do
    {$WARNINGS OFF}
    TFMErrorObj(FErrorList.Items[i]).DisplayError(HelpBtn, FHelpList);
    {$WARNINGS ON}
End;

{frees TFMErrorObj objects attached to FErrorList}

Procedure TFMAccess.ClearErrors;
Var
  i: Integer;
Begin
  For i := 0 To FErrorList.Count - 1 Do
    {$WARNINGS OFF}TFMErrorObj(FErrorList.Items[i]).Free;{$WARNINGS ON}
  FErrorList.Clear;
  ClearHelp;
End;

Procedure TFMAccess.ParseHelpErrors(RPCBroker: TRPCBroker);
Var
  i: Integer;
Begin
  i := RPCBroker.Results.Indexof(BEGINHELP);
  If i > -1 Then LoadHelp(RPCBroker, i);
  i := RPCBroker.Results.Indexof(BEGINERRORS);
  If i > -1 Then LoadErrors(RPCBroker, i);
End;

{process all errors}

Procedure TFMAccess.LoadErrors(RPCBroker: TRPCBroker; Var Item: Integer);
Var
  Error: TFMErrorObj;
  x, w: String;
  y, z, txtlines, paramcnt: Integer;
Begin
  While (x <> ENDERRORS) And (Item <> RPCBroker.Results.Count - 1) Do
  Begin
    Inc(Item);
    x := RPCBroker.Results[Item];
    If x = ENDERRORS Then Break;
    {process one error}
    Error := TFMErrorObj.Create;
    y := 0;
    z := 0;
    txtlines := 0;
    paramcnt := 0;
    With Error Do
    Begin
      ErrorNumber := Piece(x, u, 1);
      Fmfile := Piece(x, u, 3);
      IENS := Piece(x, u, 4);
      FMField := Piece(x, u, 5);
    End;
    w := Piece(x, u, 2);
    If w <> '' Then txtlines := Strtoint(w);
    w := Piece(x, u, 6);
    If w <> '' Then paramcnt := Strtoint(w);
    If paramcnt > 0 Then
      Repeat
        Inc(Item);
        x := RPCBroker.Results[Item];
        Error.Params.Add(x);
        Inc(y);
      Until y = paramcnt;
    If txtlines > 0 Then
      Repeat
        Inc(Item);
        x := RPCBroker.Results[Item];
        Error.ErrorText.Add(x);
        Inc(z);
      Until z = txtlines;
    Adderror(Error);
  End;
End;

Procedure TFMAccess.LoadHelp(RPCBroker: TRPCBroker; Var Item: Integer);
Var
  Help: TFMHelpObj;
  x: String;
Begin
  While (x <> ENDHELP) And (Item <> RPCBroker.Results.Count - 1) Do
  Begin
    Inc(Item);
    x := RPCBroker.Results[Item];
    If x = ENDHELP Then Break;
    {process one help object}
    Help := LoadOneHelp(RPCBroker.Results, Item, x);
    AddHelp(Help);
  End;
  HelpBtn := (FHelpList.Count > -1);
End;

Function TFMAccess.LoadOneHelp(Source: TStrings; Var Item: Integer; x: String): TFMHelpObj;
Var
  Help: TFMHelpObj;
  w: String;
  z, txtlines: Integer;
Begin
  Help := TFMHelpObj.Create;
  z := 0;
  txtlines := 0;
  With Help Do
  Begin
    Fmfile := Piece(x, u, 1);
    FMField := Piece(x, u, 2);
  End;
  w := Piece(x, u, 4);
  If w <> '' Then txtlines := Strtoint(w);
  If txtlines > 0 Then
    Repeat
      Inc(Item);
      x := Source[Item];
      Help.HelpText.Add(x);
      Inc(z);
    Until z = txtlines;
  Result := Help;
End;

{Adds a Help object to the FHelpList}

Procedure TFMAccess.AddHelp(AHelp: TFMHelpObj);
Begin
  FHelpList.Add(AHelp);
End;

{frees TFMHelpObj objects attached to FHelpList}

Procedure TFMAccess.ClearHelp;
Var
  i: Integer;
Begin
  For i := 0 To FHelpList.Count - 1 Do
  {$WARNINGS OFF}TFMHelpObj(FHelpList.Items[i]).Free;{$WARNINGS ON}
  FHelpList.Clear;
End;

{**********End TFMAccess**********}

End.
