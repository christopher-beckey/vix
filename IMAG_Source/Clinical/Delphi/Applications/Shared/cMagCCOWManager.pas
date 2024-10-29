
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
    FContextor: TContextorControl;
    FCCOWState: byte;
    FJoinStatus: Boolean;
    FObserversList: Array Of IMagObserver;
    UseUserContext: Boolean;
//p129T5 made public    Function GetContextValue(Key: String): String;
//p129t13 made public    Function GetPatientIdentifier(Out IsIcn: Boolean): String;
    Procedure SetCCOWState(i: byte);      {SetCCOWState  :  0-NO CCow, 1-In Contxt, 2-Changing, 3- Broken}
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
    Procedure ContextorCommitted(Sender: Tobject);
    Procedure ContextorPending(Sender: Tobject; Const aContextItemCollection: IDispatch);
    Procedure Detach_(Observer: IMagObserver);
    Procedure GetState_(Var State: String);
    Procedure Notify_(SubjectState: String);
    {new for 129t14 for CCOW changes in Capture.  This will only Resume.  No Get or Set}
    procedure ResumeContextOnly;
    Procedure ResumeGetContext;
    Procedure ResumeSetContext;
    Procedure RIVRecieveUpdate_(action: String; Value: String);
    Procedure SetState_(State: String);
    Procedure ShowContextData;
    Procedure ShutDownCCOWObject; {Added by JK 3/11/2009}
    Procedure SuspendContextLink;
    Procedure UpDate_(SubjectState: String; Sender: Tobject);
    Property JoinStatus: Boolean Read FJoinStatus Write FJoinStatus; {JK 3/11/2009}
    Function GetContextValue(Key: String): String;
    Function GetPatientIdentifier(Out IsIcn: Boolean): String;

  End;

Implementation

Uses
  CCOWRPCBroker,
  cMagPat,
  ComObj,
  Dialogs,
  ImagDMinterface, // DmSingle,
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
    FContextor := TContextorControl.Create(Nil);
    FContextor.OnCommitted := ContextorCommitted;
    FContextor.OnCanceled := ContextorCanceled;
    FContextor.OnPending := ContextorPending;
(*  // RCA  THIS WAS CAUSING ERROR IN CAPTURE, BUT NOT IN DISPLAY
     in display, the 0npaint event of display form, was being called before this 'create'
     event, and idmodobj was defined.  In Capture... everything looks same, but the
     idmodobj isn't created...  this is called before the OnPaint.... OnPaint being
     called second seems the correct way.
     ...so,  took this out, and in Dmod..  attached the MagPat1 to CCOWManager
     in teh dmod, without referencing the idmodobj.

    idmodobj.GetMagPat1.Attach_(Self);

    *)
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

{Description: Added by JK 3/11/2009 to replace the object shutdown operations
 previously called in the object's destructor}

Procedure TMagCCOWManager.ShutDownCCOWObject;
Begin
  Try
    DebugFile('TMagCCOWManager.ShutDownCCOWObject Entered');
    if idmodobj <> nil then 
    idmodobj.GetMagPat1.Detach_(Self);
    RIVDetachListener(Self);

    If FJoinStatus Then
    Try
      {/ P122 - JK 9/14/2011 P117 T6->T8 merged code. /}
      {/ P122 - gek Free then FreeAndNil (in Destroy) was
         causing invalid pointer operation exception /}
//      FContextor.Free();
    Except
      On e: EOleException Do
        DebugFile('TMagCCOWManager.ShutDownCCOWObject: EOleException = ' + e.Message);
      On e: Exception Do
        DebugFile('TMagCCOWManager.ShutDownCCOWObject: EException = ' + e.Message);
    End;
    DebugFile('TMagCCOWManager.ShutDownCCOWObject Exited. JoinStatus was ' + Magbooltostr(FJoinStatus));
  Except
    On e: Exception Do
      DebugFile('TMagCCOWManager.ShutDownCCOWObject UNHANDLED EXCEPTION = ' + e.Message + ' => JoinStatus was ' + Magbooltostr(FJoinStatus));
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
(*
//FContextor.State
 type
  __MIDL___MIDL_itf_VergenceContextor_0000_0002 = TOleEnum;
const
  CsNotRunning = $00000001;
  CsParticipating = $00000002;
  CsSuspended = $00000003;
*)
 {debug94}
 magAppMsg('s','IN CCOW Manager.UPdate_  subjectstate= ' + subjectstate);
  If FContextor = Nil Then Exit;
  If FContextor.State = csNotRunning Then Exit;
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
          MagAppMsg('s', 'CCOWManager - Setting patient context with patient ICN');
          SetPatientContext();
        End;
      End
      Else   {here so,  ICN = ''}
      Begin
        Xdfn := GetContextValue('patient.id.mrn.dfn_'
          + PrimarySiteStationNumber + KeySuffix); // JMW 1/24/2007 P46T27
//          + magpiece(WrksInst, '^', 1) + keySuffix);
        If (MagPat.M_DFN <> Xdfn) Then
        Begin
          MagAppMsg('s', 'CCOWManager - Setting patient context with patient DFN');
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
  ICCOWObserver: IMagObserver;
  vNewsCode : integer;

Begin
  magAppMsg('s', '(CCOW) START MagCCOWManager.Notify_ : ' + 'subjectstate : ' + SubjectState);
 if SubjectState <> '' then
       begin
       try
       vNewsCode := 7010 + strtoint(subjectstate);
       magappmsg('s','Calling MagAppPublish : ' + subjectState);
       magAppPublish(vNewsCode);
          except
          on e:exception do  magappmsg('',e.Message);
          end;
       end;

  For i := 0 To (High(FObserversList)) Do
  Begin
    If FObserversList[i] <> Nil Then
    Begin
      ICCOWObserver := (FObserversList[i]);
    {debug129} magAppMsg('s', '**--** TMagCCOWManager.Notify_ Observer[' + Inttostr(i) + ']   state ' + SubjectState);
      ICCOWObserver.UpDate_(SubjectState, Self);

    End;
  End;
  magAppMsg('s', '(CCOW) END MagCCOWManager.Notify_ : ' + 'subjectstate : ' + SubjectState);
End;

Function TMagCCOWManager.GetPatientIdentifier(Out IsIcn: Boolean): String;
Var
  PatientID, Key, KeySuffix: String;
Begin
  DebugFile('TMagCCOWManager.GetPatientIdentifier: Entered'); {JK 3/11/2009}
//  MagAppMsg('s','DEBUG--- GetPatientIdentifier()');
  If Not (FContextor.State = csParticipating) Then
    Exit;

  KeySuffix := '';
  If (Not IsProdAccount) Then
    KeySuffix := '_test';
  Key := 'patient.id.mrn.nationalidnumber' + KeySuffix;
//  MagAppMsg('s','DEBUG--- Key = [' + key + ']');

  PatientID := GetContextValue(Key);
//  MagAppMsg('s','DEBUG--- PatientID=[' + PatientID + ']');
  If ((PatientID <> '') And (PatientID <> '-1')) Then
  Begin
//    MagAppMsg('s','DEBUG--- IsICN = true');
    IsIcn := True;
  End
  Else
  Begin
//    key := 'patient.id.mrn.dfn_' + magpiece(WrksInst,'^',1) + keySuffix;
    Key := 'patient.id.mrn.dfn_' + PrimarySiteStationNumber + KeySuffix; // JMW 1/24/2007 P46T27
//    MagAppMsg('s','DEBUG--- Key=[' + key + ']');
    PatientID := GetContextValue(Key);
//    MagAppMsg('s','DEBUG--- PatientID=[' + PatientID + ']');
    IsIcn := False;
//    MagAppMsg('s','DEBUG--- IsICN = false');
  End;
  Result := PatientID;
  MagAppMsg('s', 'DEBUG--- GotPatientIdentifier [' + Result + '], isICN=[' + Magbooltostr(IsIcn) + ']');
  DebugFile('TMagCCOWManager.GetPatientIdentifier: Result = ' + Result + ', isICN=[' + Magbooltostr(IsIcn) + ']'); {JK 3/11/2009}
End;

Procedure TMagCCOWManager.ContextorCommitted(Sender: Tobject);
Var
  CCOWBroker: TCCOWRPCBroker;
  CCOWPatientId, CurrentPatientId, Xmsg: String;
  IsIcn: Boolean;
  i: Integer;
  Timer: TTimer;
  PatDFN: String;
  Res: Boolean;
  WarningMsg: String;
Begin
try
  MagAppMsg('s', '(CCOW) 2=== START Contextor Committed Event ');
//  MagAppMsg('s','DEBUG--- ContextorCommitted()');
  MagAppMsg('s', '    --- LoginComplete = [' + Magbooltostr(LoginComplete) + ']');
  // if the login process has not completed (not all RPC's run), we don't want to do this commit event
  If Not LoginComplete Then Exit;
  CCOWTempSuspended := False; // not sure if this should go here or somewhere else...
  CCOWBroker := TCCOWRPCBroker(idmodobj.GetMagDBBroker1.GetBroker());
  SetCCOWState(1);             {1 = We are In Context } {Notify_ is called in SetCCOWState}

  CCOWPatientId := GetPatientIdentifier(IsIcn);
  ExternalPatientChange := True;
  If (IsIcn) Then
    CurrentPatientId := idmodobj.GetMagPat1.M_ICN
  Else
    CurrentPatientId := idmodobj.GetMagPat1.M_DFN;

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

  MagAppMsg('s', '    2=== New PatientID=[' + CCOWPatientId + '], CPRSDFN=[' + idmodobj.GetMagPat1.M_CPRSDFN + ']');
  // if no patient in context and patient received from CPRS     CAPTURE won't get here,  Capture doesn't set the M_CPRSDFN property
  If (CCOWPatientId = '') And (idmodobj.GetMagPat1.M_CPRSDFN <> '') Then
  Begin
    MagAppMsg('s','    2=== No CCOW patient but CPRS has a patient, Application Terminating.');

    // close application, we got a patient from CPRS but there is nothing in
    // context, therefore the CPRS that sent the patient is not in context
    Showmessage(WarningMsg);

    Application.Terminate();
    {/p94t2  decouple from Main Form.}
    //frmmain.Close();
    Exit;

  End
  Else
    If (CCOWPatientId <> '') Then
    Begin

      MagAppMsg('s', '    2===  - CurrentPatientId=[' + CurrentPatientId + '], CCOWPatientId=[' + CCOWPatientId + ']');
      MagAppMsg('s', '    2===  - CurrentlySwitchingPatientId=[' + idmodobj.GetMagPat1.M_CurrentlySwithingPatientId + ']');

      If (CurrentPatientId <> CCOWPatientId) Then
      Begin
        If idmodobj.GetMagPat1.M_CPRSDFN <> '' Then
        Begin
          If (IsIcn) Then
          Begin
            Res := idmodobj.GetMagDBBroker1.RPMagGetPatientDFNFromICN(PatDFN, CCOWPatientId);
            If Not Res Then
            Begin
              Magappmsg('s','    2===  Error retrieving DFN from ICN.  CCOW ID =' + CCOWPatientId );
              PatDFN := '';
          // do what?
          // got error from making RPC call, do what now?
            End;
          End
          Else // if patient ID is a DFN
            PatDFN := CCOWPatientId;

          If PatDFN <> idmodobj.GetMagPat1.M_CPRSDFN Then
          Begin
          // the patient in context is not the same as what CPRS sent Display, close Display
            MagAppMsg('s','    2=== CCOW Patient is different than CPRS patient, Application Terminating.');
            MagAppMsg('s', '    2===  patDFN=[' + PatDFN + '], CPRSDFN=[' + idmodobj.GetMagPat1.M_CPRSDFN + ']');
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
        If CCOWPatientId = idmodobj.GetMagPat1.M_CurrentlySwithingPatientId Then
        Begin
          MagAppMsg('s', '    2=== CCOWPatientId equals CurrentlySwitchingPatientId');
          Exit;
        End;

        MagAppMsg('s', '    2=== CurrentlySwitchingPatient = [' + Magbooltostr(idmodobj.GetMagPat1.CurrentlySwitchingPatient) + ']');
        If idmodobj.GetMagPat1.CurrentlySwitchingPatient Then
        Begin
          MagAppMsg('s', '    2=== CurrentlySwitchingPatient = true');

          RIVNotifyAllListeners(Self, 'NewPatientSelected', '');
        //MagRemoteInterface.RIVNotify_(nil, 'NewPatientSelected','');
          CCOWTempSuspended := True;
        // JMW 3/2/2006 p46t10
        // suspend context but set it as temporary so Display will rejoin
          SuspendContextLink();
        End
        Else
        Begin
          MagAppMsg('s', '    2=== About to SwitchToPatient');
          FCurrentPatientSensitiveLevel := 0;
          idmodobj.GetMagPat1.SwitchTopatient(CCOWPatientId, Xmsg, True, IsIcn);
          //  Display calling SwitchToPatient in ContextorCOmmited Event...
          //  Capture App itself Calls SwitchToPatient... Okay. Now Capture has it accounted for..
        End;
      End;
    End
    Else
      If (CurrentPatientId <> '') Then
        idmodobj.GetMagPat1.Clear();
  If (UseUserContext And CCOWBroker.IsUserCleared And CCOWBroker.WasUserDefined) Then
  Begin
    Application.Terminate(); // this added, instead of frmMain.close.  other methods in this unit, do this.
    {/p94t2  decouple from Main Form.}
    //frmmain.Close();
    Exit;
  End;
finally
    MagAppMsg('s', '(CCOW) 2=== END Contextor Committed Event ');
end;
End;

Procedure TMagCCOWManager.ContextorCanceled(Sender: Tobject);
Begin
  MagAppMsg('s', '(CCOW) 3===START Contextor Canceled Event ');
  ShowContextData();
  // Application should maintain its state as the current (existing) context.
  SetCCOWState(1);             {1 = We are In Context }  {Notify_ called in SetCCOWState}
  MagAppMsg('s', '(CCOW) 3===END Contextor Canceled Event ');
End;

Procedure TMagCCOWManager.ContextorPending(Sender: Tobject; Const aContextItemCollection: IDispatch);
var reason : widestring;
    //for ccow call.
    msg: string; // merged in gek 9/7/12
    status : boolean;
Begin
  MagAppMsg('s', '(CCOW) 1=== START Contextor Pending Event ');
msg := '';
status := true;
//  FContextor.
{BreakSet CCOW-1}
{HERE HERE may be the place to check... is this a Change Patient, and are we changing to a Different
  patient than we currently have.... then see if we CanChangePatient..  if no send Message to Contextor. }
  if assigned(IsOkayToChangePatient) then IsOkayToChangePatient(msg,status);// merged in gek 9/7/12
  if not status then
               begin
                reason :=  msg; //'cant change, because I dont want to' ;
                magappmsg('s','    1== FContextor.SetSurveyResponse :'  + reason);
                FContextor.SetSurveyResponse(reason);
                MagAppMsg('s', ' (CCOW) == EXIT - Response was sent. Can''t Change.');
                exit;
               end;
  ShowContextData();
  SetCCOWState(2);     {2 = CCOW Context is changing.}  {Notify_  called in SetCCOWState}
  MagAppMsg('s', ' (CCOW) === END - Contextor Pending Event ');
End;

// methods


(*
F Contextor.State
 type
  __MIDL___MIDL_itf_VergenceContextor_0000_0002 = TOleEnum;
const
  CsNotRunning = $00000001;
  CsParticipating = $00000002;
  CsSuspended = $00000003;
*)

{gek - JoinContext is only called at startup of the application.
          Display called from magUtilFormf.  magUtilFormF is the last form created in Display App
          Capture called from CHCCCOW - which is called once from magCapMain OnPaint .

       In JoinContext,  FContextor.Run is called

}

Function TMagCCOWManager.JoinContext: Boolean;
Var
  Magini: TIniFile;

   //03  APP_PASSCODE : AnsiString;
  // APP_PASSCODE : STRING;
DontUseCCOW : boolean;
Begin
try
  MagAppMsg('s', '(CCOW) 0=== START JoinContext ');
  Magini := TIniFile.Create(GetConfigFileName());
  // P122 had   the [Context] user=false
  UseUserContext := Uppercase(Magini.ReadString('DEV-CONTEXT', 'User', 'TRUE')) = 'TRUE';
  DontUseCCOW := GDontUseCCOW;
  Result := False;

  Try
    // Start the Contextor which will join the context.  Indicate desire to
    // be surveyed and notified of all subjects.


   If (FContextor = Nil) Or (FContextor.State <> csNotRunning) or (DontUseCCOW) Then
    Begin
      // JMW 6/23/2006 p46t17      if no CCOW, don't show CCOW icon at all
      MagAppMsg('s', '   0== Contextor nil or not running, CCOW client not installed');
      SetCCOWState(0);   {0 = No CCOW Context running.  }
      Exit;
    End;

    (* JMW 6/16/2006 p46t17
        now try to join context twice, incase of a failed client (closed without properly leaving context)
       Result : attempting twice didn't work, 2nd attempt wouldn't throw exception if
       failed (if observer not running on client)  *)

    magappmsg('s','  0== calling FContextor.Run');
    FContextor.Run(Application.Title + '#' //'SampleApp1#'
      , '' //   no security, we can send own name APP_PASSCODE
      , True // VARIANT_TRUE == -1 in COM
      , '*');
      magappmsg('s','  0== FContextor.Run End');
    FJoinStatus := True; {JK 3/11/2009}
    If (UseUserContext) Then
      idmodobj.GetMagDBBroker1.SetContextor(FContextor);
    // Display the current context (if any).
    MagAppMsg('s', '  0== Context : Joining context');
    ShowContextData;
    SetCCOWState(1); {1 = We are In Context }
    CCOWEnabled := True;
    Result := True;

  Except
    On OleExc: EOleException Do
    Begin
      MagAppMsg('s', '  0== Exception on 1st attempt to join context. Exception=[' + OleExc.Message + ']');

      SetCCOWState(0);         {0 = No CCOW Context running.  }
      Result := False;
    End;
  End;
  {
  //if( ..attempt Failed ) then
  begin
  .... JW at one time tried to Connect a second time if the first attemt failed.
       see notes above  }

  Magini.Free();
  MagAppMsg('s','   0== JoinStatus was ' + Magbooltostr(FJoinStatus) + ', Result = ' + Magbooltostr(Result)); {JK 3/11/2009}
finally
      MagAppMsg('s', '(CCOW) 0=== END JoinContext ');
end;
End;

Procedure TMagCCOWManager.SetCCOWState(i: byte);
Begin

 {SetCCOWState  :  0-NO CCow, 1-In Contxt, 2-Changing, 3- Broken
      SetCCOWState calls all Observers with State 0,1,2,3
   0 =  No CCOW Context running.
   1 =  We are In CCOW Context
   2 =  CCOW Context is changing.
   3 =  CCOW Link has been Broken. }

  FCCOWState := i;    {BreakSet CCOW-1}
  Notify_(Inttostr(i));
  magappmsg('','CCOW Manager SetCCOWState: = ' + Inttostr(i)); {JK 3/11/2009}
End;

Function TMagCCOWManager.GetContextValue(Key: String): String;
Var
  ItemCollection: IContextItemCollection;
  ContextItem: IContextItem;
Begin
  Result := '';
  magappmsg('s','CCOW Manager - START GetContextValue.   Key=' + key);
  ItemCollection := FContextor.CurrentContext;
  ContextItem := ItemCollection.Present(Key);
  magappmsg('s','    - ContextItem NIL ? '+ magbooltostr(contextItem = nil));
  If (ContextItem <> Nil) Then
    begin
    Result := ContextItem.Get_Value();
    magappmsg('s','    -  Result='+ result);
    end;
  magappmsg('s','CCOW Manager - END GetContextValue');
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
    magappmsg('s','FContextor.CurrentContext');
    Data := FContextor.CurrentContext;

    // Iterate through the context, selecting the item by number
    // Set variant initially to 1 (1 based collection, not 0).
    // Use the Count method to get the number of items in the collection
    Count := Data.Count();

    MagAppMsg('s', '======== Context data =========');
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
      MagAppMsg('s', 'Context : ' + Str);
    End;
    MagAppMsg('s', '========   end   data =========');
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
  if not(FContextor.State = csparticipating) then
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
  magappmsg('s','FContextor.State check');
  If Not (FContextor.State = csParticipating) Then
    Exit;
  Try
    // Start a context change transaction
    magappmsg('s','FContextor.StartContext Change');
    FContextor.StartContextChange();

    // Set the new proposed context data.
    Data := CoContextItemCollection.Create();

    DataItem := CoContextItem.Create();
    DataItem.Set_Name('patient.co.patientname');
    DataItem.Set_Value(idmodobj.GetMagPat1.M_PatName);
    Data.Add(DataItem);

    DataItem := CoContextItem.Create();
    If (idmodobj.GetMagPat1.M_ProdAcct) Then
      //dataItem.Set_Name('patient.id.mrn.dfn_' + magpiece(WrksInst,'^',1))
      DataItem.Set_Name('patient.id.mrn.dfn_' + PrimarySiteStationNumber) // JMW 1/24/2007 P46T27
    Else
      //dataItem.Set_Name('patient.id.mrn.dfn_' + magpiece(WrksInst,'^',1) + '_test');
      DataItem.Set_Name('patient.id.mrn.dfn_' + PrimarySiteStationNumber + '_test'); // JMW 1/24/2007 P46T27
    DataItem.Set_Value(idmodobj.GetMagPat1.M_DFN);
    Data.Add(DataItem);

    If (idmodobj.GetMagPat1.M_ICN <> '-1') Then
    Begin
      DataItem := CoContextItem.Create();
      If (idmodobj.GetMagPat1.M_ProdAcct) Then
        DataItem.Set_Name('patient.id.mrn.nationalidnumber')
      Else
        DataItem.Set_Name('patient.id.mrn.nationalidnumber_test');
      DataItem.Set_Value(idmodobj.GetMagPat1.M_ICN);
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
    Response := FContextor.EndContextChange(True, Data);
    // This is where the 'Problem Changing Clinical Data...'    Dialog will show
    magappmsg('s','FContextor.EndContextChange');
// merged in gek 9/7/12
{  
   If Dialog Box is displayed,   … it is being displayed Now..
  Response’  is the users’ answer to the Dialog 
               ‘OK’,    ‘Cancel’,    or  ‘Break Link’
}
    If (Response = UrCommit) Then
    Begin
      // New context is committed.
      MagAppMsg('s', 'Context ' + 'Response was Commit');
      ShowContextData;
    End
    Else
      If (Response = UrCancel) Then
      Begin
      // Proposed context change is canceled. Return to the current context.
      // JMW 2/21/2006 p46t9
      // the change patient process has been interrupted, no longer loading current patient data
        idmodobj.GetMagPat1.CurrentlySwitchingPatient := False;
        ShowContextData;
        MagAppMsg('s', 'Context ' + 'Response was Cancel');
        ContextorCommitted(Self);
      End
      Else
        If (Response = UrBreak) Then
        Begin
      // The contextor has broken the link by suspending.  This app should
      // update the Clinical Link icon, enable the Resume menu item, and
      // disable the Suspend menu item.
          MagAppMsg('s', 'Context ' + 'Response was Break');
          CCOWEnabled := False; // JMW 2/17/2006 p46t9
          SetCCOWState(3); {3 =  Link has been Broken. }
        End;
  Except
    On Exc: EOleException Do
    Begin
      //msg('s','Context '+'EOleException: ' + exc.Message + ' - ' + string(exc.ErrorCode) );
      MagAppMsg('ds', 'Context ' + 'EOleException: ' + Exc.Message);
      DebugFile('TMagCCOWManager.SetPatientContext: Exception = ' + Exc.Message); {JK 3/11/2009}
    End;
  End;
  DebugFile('TMagCCOWManager.SetPatientContext'); {JK 3/11/2009}
End;

Procedure TMagCCOWManager.SuspendContextLink;
Begin
  Try
    SetCCOWState(3);      {3 =  Link has been Broken. }
    magappmsg('s','FContextor.Suspend');
    FContextor.Suspend();
    CCOWEnabled := False;
    // This app will not receive notifications of context changes until it
    // rejoins the common context.
  Except
    On Exc: EOleException Do
    Begin
      MagAppMsg('s', 'Context ' + 'EOleException: ' + Exc.Message);
      DebugFile('TMagCCOWManager.SuspendContextLink: Exception = ' + Exc.Message); {JK 3/11/2009}
    End;
  End;
  DebugFile('TMagCCOWManager.SuspendContextLink'); {JK 3/11/2009}
End;

{Patch 129  Resume only  to solve the issue with TMagPat In Capture }
procedure TMagCCOWManager.ResumeContextOnly;
begin
    If FContextor = Nil Then Exit;
    magappmsg('s','FContextor.State check');
    If (FContextor.State = csNotRunning) Then Exit;
    If (FContextor.State <> csParticipating) Then
      begin
      magappmsg('s','ResumeContextOnly');
      FContextor.Resume();
      end;
   CCOWEnabled := True;
   SetCCOWState(1);             {1 = We are In Context }
  {The Calling application 'Capture' will now ChangeToPatient}
end;

Procedure TMagCCOWManager.ResumeGetContext();
Begin
  Try
    If FContextor = Nil Then Exit;
    magappmsg('s','FContextor.State  check');
    If (FContextor.State = csNotRunning) Then Exit;
    If (FContextor.State <> csParticipating) Then
      begin
      magappmsg('s','FContextor.Resume');
      FContextor.Resume();
      end;
    CCOWEnabled := True;
    // Upon resuming participation, update state to the current context
    MagAppMsg('s', ' ========= Resuming : Getting Context ');
    ShowContextData;
    SetCCOWState(1);             {1 = We are In Context }
    ContextorCommitted(Self);
  Except
    On Exc: EOleException Do
    Begin
      MagAppMsg('s', 'Context ' + 'EOleException: ' + Exc.Message);
      DebugFile('TMagCCOWManager.ResumeGetContext: Exception = ' + Exc.Message); {JK 3/11/2009}
    End;
  End;
  DebugFile('TMagCCOWManager.ResumeGetContext'); {JK 3/11/2009}
End;

Procedure TMagCCOWManager.ResumeSetContext();
Begin
  Try
    If FContextor = Nil Then Exit;
    magappmsg('s','FContextor.State check');
    If (FContextor.State = csNotRunning) Then Exit;
    If (FContextor.State <> csParticipating) Then
      begin
      magappmsg('s','FContextor.Resume');
      FContextor.Resume();
      magappmsg('s','FContextor.Resume end');
      end;

    CCOWEnabled := True;
    // Upon resuming participation, update state to the current context
    MagAppMsg('s', ' ========= Resuming : Setting Context ');
    ShowContextData;
    SetCCOWState(1);          {1 = We are In Context }
    SetPatientContext;
    MagAppMsg('s', ' ========= Resuming : After SetPatientContext ');
    ShowContextData;
  Except
    On Exc: EOleException Do
    Begin
      MagAppMsg('s', 'Context ' + 'EOleException: ' + Exc.Message);
      DebugFile('TMagCCOWManager.ResumeSetContext: Exception = ' + Exc.Message); {JK 3/11/2009}
    End;
  End;
  DebugFile('TMagCCOWManager.ResumeSetContext'); {JK 3/11/2009}
End;

Function TMagCCOWManager.IsCCOWConnected(): Boolean;
Begin
  Result := False;
  If FContextor = Nil Then Exit;
  If (FContextor.State = csNotRunning) Then Exit;
  If (FContextor.State = csParticipating) Then
  Begin
    Result := True;
    DebugFile('TMagCCOWManager.isCCOWConnected, Result = ' + Magbooltostr(Result)); {JK 3/11/2009}
    Exit;
  End;
  DebugFile('TMagCCOWManager.isCCOWConnected, Result = ' + Magbooltostr(Result)); {JK 3/11/2009}
End;

Destructor TMagCCOWManager.Destroy;
Begin
  FreeAndNil(FContextor);
  Inherited;
End;

End.
