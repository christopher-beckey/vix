Unit cMagCCOWManager;

Interface

Uses
  Classes,
  Controls,
  ImagInterfaces,
  Magremoteinterface,
  VERGENCECONTEXTORLib_TLB
  ;

Type
  TMagCCOWManager = Class(TComponent, IMagObserver, IMagSubject, IMagRemoteinterface)
  Private
    Contextor: TContextorControl;
    FCCOWState: byte;
    FJoinStatus: Boolean;
    FObserversList: Array Of IMagObserver;
    UseUserContext: Boolean;
    Function GetContextValue(Key: String): String;
    Function GetPatientIdentifier(Out IsIcn: Boolean): String;
    Procedure SetCCOWState(i: byte);
    Procedure SetPatientContext;
  Public
    CCOWEnabled: Boolean;
    CCOWTempSuspended: Boolean;
    IsProdAccount: Boolean;
    LoginComplete: Boolean;
    Constructor Create(AOwner: TComponent); Override;
    Destructor Destroy(); Override;
    Function IsCCOWConnected(): Boolean;
    Function JoinContext(): Boolean;
    Procedure Attach_(Observer: IMagObserver);
    Procedure ContextorCanceled(Sender: Tobject);
    Procedure ContextOrCommitted(Sender: Tobject);
    Procedure ContextOrPending(Sender: Tobject; Const aContextItemCollection: IDispatch);
    Procedure Detach_(Observer: IMagObserver);
    Procedure GetState_(Var State: String);
    Procedure Notify_(SubjectState: String);
    Procedure ResumeGetContext;
    Procedure ResumeSetContext;
    Procedure RIVRecieveUpdate_(action: String; Value: String);
    Procedure SetState_(State: String);
    Procedure ShowContextData;
    Procedure ShutDownCCOWObject; {Added by JK 3/11/2009}
    Procedure SuspendContextLink;
    Procedure UpDate_(SubjectState: String; Sender: Tobject);
    Property JoinStatus: Boolean Read FJoinStatus Write FJoinStatus; {JK 3/11/2009}
  End;

Implementation

Uses
  CCOWRPCBroker,
  cMagPat,
  ComObj,
  Dialogs,
  DmSingle,
  ExtCtrls,
  //fmagMain,
  Forms,
  Inifiles,
  Magguini,
  SysUtils,
  UMagDefinitions,
  Umagutils8
  ;

Const
  ITF_E_CONTEXT_MANAGER_ERROR = HRESULT($80040206);

Constructor TMagCCOWManager.Create(AOwner: TComponent);
Begin
  Inherited Create(AOwner);
  CCOWTempSuspended := False;
  Try
    Contextor := TContextorControl.Create(Nil);
    Contextor.OnCommitted := ContextOrCommitted;
    Contextor.OnCanceled := ContextorCanceled;
    Contextor.OnPending := ContextOrPending;
    Dmod.MagPat1.Attach_(Self);
    RIVAttachListener(Self);
//  RIV Attach_();
  Except
    On Exc: Exception Do
      CCOWEnabled := False;
  End;
  IsProdAccount := False;
  CCOWEnabled := False;
  LoginComplete := False;
  FJoinStatus := False; {JK 3/11/2009}
  DebugFile('TMagCCOWManager.Create - CCOW Object created');

End;

(* Removed by JK 3/11/2009 and replaced with the ShutdownCCOWObject method
destructor TMagCCOWManager.Destroy();
begin
  dmod.MagPat1.Detach_(self);
  RIVDetachListener(self);
  {JK 1/26/2009 - Fixes D60. Also moved Inherited Destroy to end of this method}
  try
    Contextor.Free();
  except
    on E:EOleException do
      ; // do nothing if Contextor.Free throws an exception
    on E:Exception do
      ; // do nothing if an exception occurs
  end;
  inherited Destroy;
end;
*)

{Description: Added by JK 3/11/2009 to replace the object shutdown operations
 previously called in the object's destructor}

Procedure TMagCCOWManager.ShutDownCCOWObject;
Begin
  Try
    DebugFile('TMagCCOWManager.ShutDownCCOWObject Entered');
    Dmod.MagPat1.Detach_(Self);
    RIVDetachListener(Self);

    If JoinStatus Then
    Try
    {/p121 gek Free then FreeAndNil (in destroy) was
    causing invalid pointer operation exception       }
       // Contextor.Free();
    Except
      On e: EOleException Do
        DebugFile('TMagCCOWManager.ShutDownCCOWObject: EOleException = ' + e.Message);
      On e: Exception Do
        DebugFile('TMagCCOWManager.ShutDownCCOWObject: EException = ' + e.Message);
    End;
    DebugFile('TMagCCOWManager.ShutDownCCOWObject Exited. JoinStatus was ' + Magbooltostr(JoinStatus));
  Except
    On e: Exception Do
      DebugFile('TMagCCOWManager.ShutDownCCOWObject UNHANDLED EXCEPTION = ' + e.Message + ' => JoinStatus was ' + Magbooltostr(JoinStatus));
  End;
End;

Procedure TMagCCOWManager.RIVRecieveUpdate_(action: String; Value: String);
Begin
  If action = 'PatientChangeProcessComplete' Then
  Begin
    If (CCOWTempSuspended Or CCOWEnabled) And (Not IsCCOWConnected()) Then
    Begin
      ResumeGetContext();
    End;
  End;
  DebugFile('TMagCCOWManager.RIVRecieveUpdate_: Action = ' + action + ', Value = ' + Value); {JK 3/11/2009}
End;

// Event Handlers

Procedure TMagCCOWManager.UpDate_(SubjectState: String; Sender: Tobject);
Var
  MagPat: TMag4Pat;
  ICN, Xdfn, Key, KeySuffix: String;
Begin
 {debug94} If (ImsgObj <> Nil) Then ImsgObj.LogMsg('s', '** -- **-- -- -- TMagCCOWManager.Update_  state ' + SubjectState);
  If Contextor = Nil Then Exit;
  If Contextor.State = csNotRunning Then Exit;
  If (SubjectState <> '') Then
  Begin
    If (SubjectState <> '-1') Then
    Begin
      MagPat := TMag4Pat(Sender);
      KeySuffix := '';
      If (Not IsProdAccount) Then
        KeySuffix := '_test';
      ICN := GetContextValue('patient.id.mrn.nationalidnumber' + KeySuffix);
      If (ICN <> '') Then
      Begin
        If (MagPat.M_ICN <> ICN) Then
        Begin
          IMsgObj.MagMsg('s', 'CCOWManager - Setting patient context with patient ICN');
          SetPatientContext();
        End;
      End
      Else
      Begin
        Xdfn := GetContextValue('patient.id.mrn.dfn_'
          + PrimarySiteStationNumber + KeySuffix); // JMW 1/24/2007 P46T27
//          + magpiece(WrksInst, '^', 1) + keySuffix);
        If (MagPat.M_DFN <> Xdfn) Then
        Begin
          IMsgObj.MagMsg('s', 'CCOWManager - Setting patient context with patient DFN');
          SetPatientContext();
        End;
      End;
    End;
  End;
  DebugFile('TMagCCOWManager.Update_: SubjectState = ' + SubjectState); {JK 3/11/2009}
End;

Procedure TMagCCOWManager.Attach_(Observer: IMagObserver);
Begin
  SetLength(FObserversList, Length(FObserversList) + 1);
  FObserversList[High(FObserversList)] := Observer;
  DebugFile('TMagCCOWManager.Attach_'); {JK 3/11/2009}
End;

{An observer can detach from the Subject at any time.}

Procedure TMagCCOWManager.Detach_(Observer: IMagObserver);
Var
  i: Integer;
Begin
  For i := 0 To (High(FObserversList)) Do
  Begin
    If (Observer = FObserversList[i]) Then
    Begin
      FObserversList[i] := Nil;
    End;
  End;
  DebugFile('TMagCCOWManager.Detach_'); {JK 3/11/2009}
End;

Procedure TMagCCOWManager.GetState_(Var State: String);
Begin
  State := Inttostr(FCCOWState);
  DebugFile('TMagCCOWManager.GetState_'); {JK 3/11/2009}
End;

Procedure TMagCCOWManager.SetState_(State: String);
Begin
  SetCCOWState(byte(Strtoint(State)));
  DebugFile('TMagCCOWManager.SetState_'); {JK 3/11/2009}
End;

Procedure TMagCCOWManager.Notify_(SubjectState: String);
Var
  i: Integer;
  IvObserver: IMagObserver;
Begin
  For i := 0 To (High(FObserversList)) Do
  Begin
    If FObserversList[i] <> Nil Then
    Begin
      IvObserver := (FObserversList[i]);
      IvObserver.UpDate_(SubjectState, Self);
    End;
  End;
  DebugFile('TMagCCOWManager.Notify_'); {JK 3/11/2009}
End;

Function TMagCCOWManager.GetPatientIdentifier(Out IsIcn: Boolean): String;
Var
  PatientID, Key, KeySuffix: String;
Begin
  DebugFile('TMagCCOWManager.GetPatientIdentifier: Entered'); {JK 3/11/2009}
//  IMsgObj.MagMsg('s','DEBUG--- GetPatientIdentifier()');
  If Not (Contextor.State = csParticipating) Then
    Exit;

  KeySuffix := '';
  If (Not IsProdAccount) Then
    KeySuffix := '_test';
  Key := 'patient.id.mrn.nationalidnumber' + KeySuffix;
//  IMsgObj.MagMsg('s','DEBUG--- Key = [' + key + ']');

  PatientID := GetContextValue(Key);
//  IMsgObj.MagMsg('s','DEBUG--- PatientID=[' + PatientID + ']');
  If ((PatientID <> '') And (PatientID <> '-1')) Then
  Begin
//    IMsgObj.MagMsg('s','DEBUG--- IsICN = true');
    IsIcn := True;
  End
  Else
  Begin
//    key := 'patient.id.mrn.dfn_' + magpiece(WrksInst,'^',1) + keySuffix;
    Key := 'patient.id.mrn.dfn_' + PrimarySiteStationNumber + KeySuffix; // JMW 1/24/2007 P46T27
//    IMsgObj.MagMsg('s','DEBUG--- Key=[' + key + ']');
    PatientID := GetContextValue(Key);
//    IMsgObj.MagMsg('s','DEBUG--- PatientID=[' + PatientID + ']');
    IsIcn := False;
//    IMsgObj.MagMsg('s','DEBUG--- IsICN = false');
  End;
  Result := PatientID;
  IMsgObj.MagMsg('s', 'DEBUG--- GotPatientIdentifier [' + Result + '], isICN=[' + Magbooltostr(IsIcn) + ']');
  DebugFile('TMagCCOWManager.GetPatientIdentifier: Result = ' + Result + ', isICN=[' + Magbooltostr(IsIcn) + ']'); {JK 3/11/2009}
End;

Procedure TMagCCOWManager.ContextOrCommitted(Sender: Tobject);
Var
  CCOWBroker: TCCOWRPCBroker;
  NewPatientId, CurrentPatientId, Xmsg: String;
  IsIcn: Boolean;
  i: Integer;
  Timer: TTimer;
  PatDFN: String;
  Res: Boolean;
  WarningMsg: String;
Begin
  DebugFile('TMagCCOWManager.ContextorCommitted: Entered'); {JK 3/11/2009}
  IMsgObj.MagMsg('s', ' ========= Contextor Committed Event ');
//  IMsgObj.MagMsg('s','DEBUG--- ContextorCommitted()');
  IMsgObj.MagMsg('s', 'DEBUG--- LoginComplete = [' + Magbooltostr(LoginComplete) + ']');
  // if the login process has not completed (not all RPC's run), we don't want to do this commit event
  If Not LoginComplete Then Exit;
  CCOWTempSuspended := False; // not sure if this should go here or somewhere else...
  CCOWBroker := TCCOWRPCBroker(Dmod.MagDBBroker1.GetBroker());
  SetCCOWState(1);
  ShowContextData;
  NewPatientId := GetPatientIdentifier(IsIcn);
  ExternalPatientChange := True;
  If (IsIcn) Then
    CurrentPatientId := Dmod.MagPat1.M_ICN
  Else
    CurrentPatientId := Dmod.MagPat1.M_DFN;

  Application.Processmessages();

  // warning message to display if CPRS launches Display and CPRS is not in context
  WarningMsg := 'WARNING - VistA Imaging Display CANNOT RUN' + #13 +
    #13 +
    'The CPRS from which you just launched VistA Imaging Display is not participating in patient synchronization.' + #13 +
    #13 +
    'For patient safety reasons, VistA Imaging Display cannot run in this mode.' + #13 +
    #13 +
    'To use VistA Imaging Display, please make CPRS join patient synchronization, and then relaunch VistA Imaging Display from the Tools menu' + #13 +
    #13 +
    'To make CPRS join patient synchronization: in CPRS, chose File/Rejoin patient link.' + #13 +
    #13 +
    'Note: if you have more than one CPRS running, this action may cause other CPRS windows to try to match your patient' + #13 +
    #13 +
    'Please contact your local IRM help desk for further assistance';

  IMsgObj.MagMsg('s', 'New PatientID=[' + NewPatientId + '], CPRSDFN=[' + Dmod.MagPat1.M_CPRSDFN + ']');
  // if no patient in context and patient received from CPRS
  If (NewPatientId = '') And (Dmod.MagPat1.M_CPRSDFN <> '') Then
  Begin
//    IMsgObj.MagMsg('s','DEBUG--- No CCOW patient but CPRS has a patient, closing');

    // close application, we got a patient from CPRS but there is nothing in
    // context, therefore the CPRS that sent the patient is not in context
    DebugFile('TMagCCOWManager.ContextorCommitted: ' + WarningMsg); {JK 3/11/2009}
    Showmessage(WarningMsg);
    Application.Terminate();
    {/p94t2  decouple from Main Form.}
    //frmmain.Close();
    Exit;

  End
  Else
    If (NewPatientId <> '') Then
    Begin

      IMsgObj.MagMsg('s', 'CCOWManager - CurrentPatientId=[' + CurrentPatientId + '], NewPatientId=[' + NewPatientId + ']');
      IMsgObj.MagMsg('s', 'CCOWManager - CurrentlySwitchingPatientId=[' + Dmod.MagPat1.M_CurrentlySwithingPatientId + ']');

      If (CurrentPatientId <> NewPatientId) Then
      Begin
        If Dmod.MagPat1.M_CPRSDFN <> '' Then
        Begin
          If (IsIcn) Then
          Begin
            Res := Dmod.MagDBBroker1.RPMagGetPatientDFNFromICN(PatDFN, NewPatientId);
            If Not Res Then
            Begin
              DebugFile('TMagCCOWManager.ContextorCommitted: Error retrieving DFN from ICN, Exception=[' + PatDFN + ']');
              PatDFN := '';
          // do what?
          // got error from making RPC call, do what now?
            End;
          End
          Else // if patient ID is a DFN
            PatDFN := NewPatientId;

          If PatDFN <> Dmod.MagPat1.M_CPRSDFN Then
          Begin
          // the patient in context is not the same as what CPRS sent Display, close Display
            DebugFile('TMagCCOWManager.ContextorCommitted: ' + WarningMsg); {JK 3/11/2009}
            IMsgObj.MagMsg('s', 'patDFN=[' + PatDFN + '], CPRSDFN=[' + Dmod.MagPat1.M_CPRSDFN + ']');
            Showmessage(WarningMsg);
            Application.Terminate();
    {/p94t2  decouple from Main Form.}
    //frmmain.Close();
            Exit;
          End;
        End;
      {TODO: might want to move this so it only happens if currentlyswitchingpatient=true}
        i := 0;
        While Length(Screen.Forms[i].Name) > 0 Do
        Begin
          If FsModal In Screen.Forms[i].FormState Then
          Begin
            Screen.Forms[i].ModalResult := MrCancel;
            i := i + 1;
          End
          Else // the fsModal forms always sequenced prior to the none-fsModal forms
            Break;
        End;

      // JMW p46T20 9/13/2006
      // check to see if the client is currently switching patients (making connections and such) and is the same patient as this new one
      // if they are the same then this patient change request can be ignored.
      // the CurrentlySwitchingPatientId is cleared when the patient is finished loading (in SetPatientInfo)
      // this is fine because in SetPatientInfo, M_DFN and M_ICN are set properly and the same patient will then be caught properly
        If NewPatientId = Dmod.MagPat1.M_CurrentlySwithingPatientId Then
        Begin
          IMsgObj.MagMsg('s', 'CCOWManager - NewPatientId equals CurrentlySwitchingPatientId');
          Exit;
        End;

        IMsgObj.MagMsg('s', 'CCOWManager - CurrentlySwitchingPatient = [' + Magbooltostr(Dmod.MagPat1.CurrentlySwitchingPatient) + ']');
        If Dmod.MagPat1.CurrentlySwitchingPatient Then
        Begin
          IMsgObj.MagMsg('s', 'CCOWManager - CurrentlySwitchingPatient = true');

          RIVNotifyAllListeners(Self, 'NewPatientSelected', '');
        //MagRemoteInterface.RIVNotify_(nil, 'NewPatientSelected','');
          CCOWTempSuspended := True;
        // JMW 3/2/2006 p46t10
        // suspend context but set it as temporary so Display will rejoin
          SuspendContextLink();
        End
        Else
        Begin
          IMsgObj.MagMsg('s', 'CCOWManager - About to SwitchToPatient');
          FCurrentPatientSensitiveLevel := 0;
          Dmod.MagPat1.SwitchTopatient(NewPatientId, Xmsg, True, IsIcn);
        End;
//      Dmod.MagPat1.SwitchTopatient(NewPatientId, xmsg, true, IsIcn);
      End;
    End
    Else
      If (CurrentPatientId <> '') Then
        Dmod.MagPat1.Clear();
  If (UseUserContext And CCOWBroker.IsUserCleared And CCOWBroker.WasUserDefined) Then
  Begin
    Application.Terminate(); // this added, instead of frmMain.close.  other methods in this unit, do this.
    {/p94t2  decouple from Main Form.}
    //frmmain.Close();
    Exit;
  End;
  DebugFile('TMagCCOWManager.ContextorCommitted: Exited'); {JK 3/11/2009}
End;

Procedure TMagCCOWManager.ContextorCanceled(Sender: Tobject);
Begin
  IMsgObj.MagMsg('s', ' ========= Contextor Canceled Event ');
  ShowContextData();
  // Application should maintain its state as the current (existing) context.
  SetCCOWState(1);
  DebugFile('TMagCCOWManager.ContextorCanceled'); {JK 3/11/2009}
End;

Procedure TMagCCOWManager.ContextOrPending(Sender: Tobject;
  Const aContextItemCollection: IDispatch);
Begin
  IMsgObj.MagMsg('s', ' ========= Contextor Pending Event ');
  ShowContextData();
  SetCCOWState(2);
  DebugFile('TMagCCOWManager.ContextorPending'); {JK 3/11/2009}
End;

// methods

Function TMagCCOWManager.JoinContext: Boolean;
Var
  Magini: TIniFile;
  CCOWFailed: Boolean;
   //03  APP_PASSCODE : AnsiString;
  // APP_PASSCODE : STRING;
Begin
  Magini := TIniFile.Create(GetConfigFileName());
  UseUserContext := Uppercase(Magini.ReadString('Context', 'User', 'TRUE')) = 'TRUE';
  JoinContext := False;
  CCOWFailed := True;
  Try
    // Start the Contextor which will join the context.  Indicate desire to
    // be surveyed and notified of all subjects.

    // JMW 6/23/2006 p46t17
    // if no CCOW, don't show CCOW icon at all
    If (Contextor = Nil) Or (Contextor.State <> csNotRunning) Then
    Begin
      IMsgObj.MagMsg('s', 'Contextor nil or not running, CCOW client not installed');
      SetCCOWState(0);
      Exit;
    End;
//    if Contextor.State <> csNotRunning then exit;

    // JMW 6/16/2006 p46t17
    // now try to join context twice, incase of a failed client (closed without
    // properly leaving context)

    // JMW 6/19/2006 p46t17
    // attempting twice didn't work, 2nd attempt wouldn't throw exception if
    // failed (if observer not running on client)
    Contextor.Run(Application.Title + '#' //'SampleApp1#'
      , '' //   no security, we can send own name APP_PASSCODE
      , True // VARIANT_TRUE == -1 in COM
      , '*');
    FJoinStatus := True; {JK 3/11/2009}
    If (UseUserContext) Then
      Dmod.MagDBBroker1.SetContextor(Contextor);
    // Display the current context (if any).
    IMsgObj.MagMsg('s', 'Context : Joining context');
    ShowContextData;
    SetCCOWState(1);
    CCOWEnabled := True;
    JoinContext := True;
    CCOWFailed := False;
  Except
    On OleExc: EOleException Do
    Begin
      IMsgObj.MagMsg('s', 'Exception on 1st attempt to join context. Exception=[' + OleExc.Message + ']');

      SetCCOWState(0);
      JoinContext := False;
    End;
  End;
  {
  if(CCOWfailed) then
  begin
        try
          Contextor.Run(application.Title + '#'  //'SampleApp1#'
                    , '' //   no security, we can send own name APP_PASSCODE
                      , TRUE  // VARIANT_TRUE == -1 in COM
                     , '*');
          if (UseUserContext) then
            dmod.MagDBBroker1.SetContextor(Contextor);
          // Display the current context (if any).
          IMsgObj.MagMsg('s','Context : Joining context');
          ShowContextData;
          SetCCOWState(1);
          CCOWEnabled := true;
          JoinContext := true;
        except
          //on OleExc : EOleException do
          on E : Exception do
          begin
            IMsgObj.MagMsg('','Problem joining context (On 2nd attempt) - Exception=[' + e.message + ']');
            SetCCOWState(0);
            JoinContext := false;
          end;
        end;

//    end;
  end;
  }
  Magini.Free();
  DebugFile('TMagCCOWManager.JoinContext: JoinStatus was ' + Magbooltostr(JoinStatus) + ', Result = ' + Magbooltostr(Result)); {JK 3/11/2009}
End;

Procedure TMagCCOWManager.SetCCOWState(i: byte);
Begin
  FCCOWState := i;
  Notify_(Inttostr(i));
  DebugFile('TMagCCOWManager.SetCCOWState: CCOWState = ' + Inttostr(i)); {JK 3/11/2009}
End;

Function TMagCCOWManager.GetContextValue(Key: String): String;
Var
  ItemCollection: IContextItemCollection;
  ContextItem: IContextItem;
Begin
  Result := '';
  ItemCollection := Contextor.CurrentContext;
  ContextItem := ItemCollection.Present(Key);
  If (ContextItem <> Nil) Then
    Result := ContextItem.Get_Value();
  DebugFile('TMagCCOWManager.GetContextValue: key = ' + Key + ', Result = ' + Result); {JK 3/11/2009}
End;

Procedure TMagCCOWManager.ShowContextData;
Var
  Data: IContextItemCollection;
  anItem: IContextItem;
  TVar: Variant;
  Count: Integer;
  DataIndex: Integer;
  ItemName, ItemValue, Str: String;
Begin
  Try
    // ContextDataView.lstItems.clear();

    // Get an item collection of the current context
    Data := Contextor.CurrentContext;

    // Iterate through the context, selecting the item by number
    // Set variant initially to 1 (1 based collection, not 0).
    // Use the Count method to get the number of items in the collection
    Count := Data.Count();

    IMsgObj.MagMsg('s', '======== Context data =========');
    For DataIndex := 1 To Count Do
    Begin
      // Use a variant index to get the specified ContextItem
      TVar := DataIndex;
      anItem := Data.Item(TVar);

      // Retrieve the ContextItem name and value as strings
      ItemName := anItem.Get_Name();
      ItemValue := anItem.Get_Value();

      // Display the ContextItem name and value
      Str := ItemName + ' = ' + ItemValue;
      IMsgObj.MagMsg('s', 'Context : ' + Str);
    End;
    IMsgObj.MagMsg('s', '========   end   data =========');
    Data := Nil;
    anItem := Nil;
  Finally
    DebugFile('TMagCCOWManager.ShowContextData'); {JK 3/11/2009}
  End;
End;
{
procedure TMagCCOWManager.GetPatientFromContext;
var
  PatientId, xmsg : string;
  IsIcn: boolean;
begin
  if not(Contextor.State = csparticipating) then
    exit;
  PatientId := GetPatientIdentifier(IsIcn);

  if (not IsProdAccount) then
    key := key + '_test';
  icn := GetContextValue(key);
  if ((icn <> '') and (icn <> '-1')) then
  begin
    if (icn <> dmod.MagPat1.M_ICN) then
      Dmod.MagPat1.SwitchTopatient(icn, xmsg, true, true);
  end
  else
  begin
    key := 'patient.id.mrn.dfn_' + magpiece(dmod.MagDBMVista1.GetBroker().User.Division,'^',1);
    if (not self.IsProdAccount) then
      key := key + '_test';
    xdfn := GetContextValue(key);
    if ((xdfn <> '') and (xdfn <> dmod.MagPat1.M_DFN)) then
      Dmod.MagPat1.SwitchTopatient(xDFN, xmsg);
  end;
  ShowContextData;
end;
}

Procedure TMagCCOWManager.SetPatientContext;
Var
  Data: IContextItemCollection;
  DataItem: IContextItem;
  Response: UserResponse;
  i: Integer;
Begin
  If Not (Contextor.State = csParticipating) Then
    Exit;
  Try
    // Start a context change transaction
    Contextor.StartContextChange();

    // Set the new proposed context data.
    Data := CoContextItemCollection.Create();

    DataItem := CoContextItem.Create();
    DataItem.Set_Name('patient.co.patientname');
    DataItem.Set_Value(Dmod.MagPat1.M_PatName);
    Data.Add(DataItem);

    DataItem := CoContextItem.Create();
    If (Dmod.MagPat1.M_ProdAcct) Then
      //dataItem.Set_Name('patient.id.mrn.dfn_' + magpiece(WrksInst,'^',1))
      DataItem.Set_Name('patient.id.mrn.dfn_' + PrimarySiteStationNumber) // JMW 1/24/2007 P46T27
    Else
      //dataItem.Set_Name('patient.id.mrn.dfn_' + magpiece(WrksInst,'^',1) + '_test');
      DataItem.Set_Name('patient.id.mrn.dfn_' + PrimarySiteStationNumber + '_test'); // JMW 1/24/2007 P46T27
    DataItem.Set_Value(Dmod.MagPat1.M_DFN);
    Data.Add(DataItem);

    If (Dmod.MagPat1.M_ICN <> '-1') Then
    Begin
      DataItem := CoContextItem.Create();
      If (Dmod.MagPat1.M_ProdAcct) Then
        DataItem.Set_Name('patient.id.mrn.nationalidnumber')
      Else
        DataItem.Set_Name('patient.id.mrn.nationalidnumber_test');
      DataItem.Set_Value(Dmod.MagPat1.M_ICN);
      Data.Add(DataItem);
    End;
                   {
    i := 0;
    while Length(Screen.Forms[i].Name) > 0 do
    begin
    if fsModal in Screen.Forms[i].FormState then
    begin
      Screen.Forms[i].ModalResult := mrCancel;
      i := i + 1;
    end else  // the fsModal forms always sequenced prior to the none-fsModal forms
      Break;
    end;
                    }

    // End the context change transaction.
    Response := Contextor.EndContextChange(True, Data);
    If (Response = UrCommit) Then
    Begin
      // New context is committed.
      IMsgObj.MagMsg('s', 'Context ' + 'Response was Commit');
      ShowContextData;
    End
    Else
      If (Response = UrCancel) Then
      Begin
      // Proposed context change is canceled. Return to the current context.
      // JMW 2/21/2006 p46t9
      // the change patient process has been interrupted, no longer loading current patient data
        Dmod.MagPat1.CurrentlySwitchingPatient := False;
        ShowContextData;
        IMsgObj.MagMsg('s', 'Context ' + 'Response was Cancel');
        ContextOrCommitted(Self);
      End
      Else
        If (Response = UrBreak) Then
        Begin
      // The contextor has broken the link by suspending.  This app should
      // update the Clinical Link icon, enable the Resume menu item, and
      // disable the Suspend menu item.
          IMsgObj.MagMsg('s', 'Context ' + 'Response was Break');
          CCOWEnabled := False; // JMW 2/17/2006 p46t9
          SetCCOWState(3);
        End;
  Except
    On Exc: EOleException Do
    Begin
      //msg('s','Context '+'EOleException: ' + exc.Message + ' - ' + string(exc.ErrorCode) );
      IMsgObj.MagMsg('s', 'Context ' + 'EOleException: ' + Exc.Message);
      DebugFile('TMagCCOWManager.SetPatientContext: Exception = ' + Exc.Message); {JK 3/11/2009}
    End;
  End;
  DebugFile('TMagCCOWManager.SetPatientContext'); {JK 3/11/2009}
End;

Procedure TMagCCOWManager.SuspendContextLink;
Begin
  Try
    SetCCOWState(3);
    Contextor.Suspend();
    CCOWEnabled := False;
    // This app will not receive notifications of context changes until it
    // rejoins the common context.
  Except
    On Exc: EOleException Do
    Begin
      IMsgObj.MagMsg('s', 'Context ' + 'EOleException: ' + Exc.Message);
      DebugFile('TMagCCOWManager.SuspendContextLink: Exception = ' + Exc.Message); {JK 3/11/2009}
    End;
  End;
  DebugFile('TMagCCOWManager.SuspendContextLink'); {JK 3/11/2009}
End;

Procedure TMagCCOWManager.ResumeGetContext();
Begin
  Try
    If Contextor = Nil Then Exit;
    If (Contextor.State = csNotRunning) Then Exit;
    If (Contextor.State <> csParticipating) Then
      Contextor.Resume();
    CCOWEnabled := True;
    // Upon resuming participation, update state to the current context
    IMsgObj.MagMsg('s', ' ========= Resuming : Getting Context ');
    ShowContextData;
    SetCCOWState(1);
    ContextOrCommitted(Self);
  Except
    On Exc: EOleException Do
    Begin
      IMsgObj.MagMsg('s', 'Context ' + 'EOleException: ' + Exc.Message);
      DebugFile('TMagCCOWManager.ResumeGetContext: Exception = ' + Exc.Message); {JK 3/11/2009}
    End;
  End;
  DebugFile('TMagCCOWManager.ResumeGetContext'); {JK 3/11/2009}
End;

Procedure TMagCCOWManager.ResumeSetContext();
Begin
  Try
    If Contextor = Nil Then Exit;
    If (Contextor.State = csNotRunning) Then Exit;
    If (Contextor.State <> csParticipating) Then
      Contextor.Resume();
    CCOWEnabled := True;
    // Upon resuming participation, update state to the current context
    IMsgObj.MagMsg('s', ' ========= Resuming : Setting Context ');
    ShowContextData;
    SetCCOWState(1);
    SetPatientContext;
    IMsgObj.MagMsg('s', ' ========= Resuming : After SetPatientContext ');
    ShowContextData;
  Except
    On Exc: EOleException Do
    Begin
      IMsgObj.MagMsg('s', 'Context ' + 'EOleException: ' + Exc.Message);
      DebugFile('TMagCCOWManager.ResumeSetContext: Exception = ' + Exc.Message); {JK 3/11/2009}
    End;
  End;
  DebugFile('TMagCCOWManager.ResumeSetContext'); {JK 3/11/2009}
End;

Function TMagCCOWManager.IsCCOWConnected(): Boolean;
Begin
  Result := False;
  If Contextor = Nil Then Exit;
  If (Contextor.State = csNotRunning) Then Exit;
  If (Contextor.State = csParticipating) Then
  Begin
    Result := True;
    DebugFile('TMagCCOWManager.isCCOWConnected, Result = ' + Magbooltostr(Result)); {JK 3/11/2009}
    Exit;
  End;
  DebugFile('TMagCCOWManager.isCCOWConnected, Result = ' + Magbooltostr(Result)); {JK 3/11/2009}
End;

Destructor TMagCCOWManager.Destroy;
Begin
  FreeAndNil(Contextor);
  Inherited;
End;

End.
