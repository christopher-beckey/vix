Unit cMagPublishSubscribe;

Interface

Uses
  Classes,
  ImagInterfaces
  ;

//Uses Vetted 20090929:umagclasses, Dialogs, SysUtils

 //========================  **************************** ===================//

Type
  TMagPublisher = Class(TComponent, ImagPublish)
  Private
    FSubscriberList: Array Of IMagSubscribe;
    FNewsObject: TMagNewsObject;
    Procedure I_Notify(NewsObj: TMagNewsObject);

  Public
    Constructor Create(AOwner: TComponent); Override;
    Destructor Destroy; Override;
    Procedure I_Attach(Subscriber: IMagSubscribe);
    Procedure I_Detach(Subscriber: IMagSubscribe);
    Function I_GetNews(): TMagNewsObject;
    Procedure I_SetNews(NewsObj: TMagNewsObject);
  End;

 //========================  **************************** ===================//

Type
  TMagSubscriber = Class;
          {       The Update event : The MagSubscriber Component can have an Event Assigned
                  so that when an I_Update event occurs, relevant code to the form (or whatever)
                  can be called.}
  TSubscriberUpdateEvent = Procedure(NewsObj: TMagNewsObject) Of Object;
  TMagSubscriber = Class(TComponent, IMagSubscribe)
  Private
    FPublisher: ImagPublish;

    FSubscriberUpdate: TSubscriberUpdateEvent;

    Procedure SetPublisher(Const Value: ImagPublish);
  Protected
    { Protected declarations }
  Public
    Procedure Detach;

    Procedure I_Update(NewsObj: TMagNewsObject);

    {   At Runtime the Application can attach this subscriber to any publisher.
        Then the App writes an OnSubscriberUpdate Event Handler.}
    Procedure AttachToPublisher(Publisher: ImagPublish);

    Constructor Create(AOwner: TComponent); Override;
    Destructor Destroy; Override;

  Published
    Property OnSubscriberUpdate: TSubscriberUpdateEvent Read FSubscriberUpdate Write FSubscriberUpdate;
    Property Publisher: ImagPublish Read FPublisher Write SetPublisher;
  End;

Procedure Register;

Implementation
Uses
  Dialogs,
  SysUtils
  ;

Procedure Register;
Begin
  RegisterComponents('Imaging', [TMagSubscriber]);
  RegisterComponents('Imaging', [TMagPublisher]);

End;

{ TMagSubscriber }

Procedure TMagSubscriber.AttachToPublisher(Publisher: ImagPublish);
Begin
  If FPublisher <> Nil Then FPublisher.I_Detach(Self);
  FPublisher := Publisher;
  If Publisher <> Nil Then FPublisher.I_Attach(Self);
End;

Constructor TMagSubscriber.Create(AOwner: TComponent);
Begin
  Inherited;
//from custommemo  FLines := TMemoStrings.Create;

  //
End;

Destructor TMagSubscriber.Destroy;
Begin
  If Assigned(FPublisher) And (FPublisher <> Nil) Then
  Begin
    FPublisher.I_Detach(Self);
    FPublisher := Nil;
  End;
  Inherited Destroy;
End;

Procedure TMagSubscriber.Detach;
Begin
  If Assigned(FPublisher) And (FPublisher <> Nil) Then
  Begin
    FPublisher.I_Detach(Self);
    FPublisher := Nil;
  End;
End;

Procedure TMagSubscriber.SetPublisher(Const Value: ImagPublish);
Begin
  FPublisher := Value;
  AttachToPublisher(FPublisher);
End;

(*procedure TMagObserver.SetSubjectNames(Value: TStrings);
begin
  FMySubjectNames.Assign(Value);
end;
 *)

Procedure TMagSubscriber.I_Update(NewsObj: TMagNewsObject);
   {    newscode can be any of the const's defined in ImagInterfaces }
   (*       pubstPublisherDestroyed = -1
            pubstImageSelected = 2000;
            pubstImageStateChange = 2001;
            pubstImageStatusChange = 2002;
            pubstRIVImage  =  3000;         *)
Begin
  Try
        {       if Publisher is being destroyed. Clear Pointer.}
    If (NewsObj.Newscode = -1) Then
      FPublisher := Nil
        {       Subject has value, fire the event.}
    Else
      If Assigned(OnSubscriberUpdate) Then OnSubscriberUpdate(NewsObj);

//   if assigned(FSubscriberUpdate) then  OnSubscriberUpdate(newscode,changeObj);
//   if FObserverUpdate <> nil then OnObserverUpdate(self,SubjectState);
  Except
    On e: Exception Do
      Showmessage('Exception in IMagSubscriber I_Update' + e.Message);
  End;
End;

{ TMagPublisher }

Constructor TMagPublisher.Create(AOwner: TComponent);
Begin
  Inherited;
  Self.FNewsObject := TMagNewsObject.Create();
///
End;

Destructor TMagPublisher.Destroy;
Var
  VnewsObj: TMagNewsObject;
Begin
  VnewsObj := TMagNewsObject.Create();
  VnewsObj.Newscode := -1;

  I_Notify(VnewsObj);
  Inherited;
  {   //JK 1/26/2009  - fixes D68}
  Try
    Self.FNewsObject.Free;
  Except
    On e: Exception Do
      ; // JK
  End;
End;

Procedure TMagPublisher.I_Attach(Subscriber: IMagSubscribe);
Begin
  SetLength(FSubscriberList, Length(FSubscriberList) + 1);
  FSubscriberList[High(FSubscriberList)] := Subscriber;
End;

Procedure TMagPublisher.I_Detach(Subscriber: IMagSubscribe);
Var
  i: Integer;
Begin
  For i := 0 To (High(FSubscriberList)) Do
  Begin
    If (Subscriber = FSubscriberList[i]) Then
    Begin
      FSubscriberList[i] := Nil;
    End;
  End;
End;

Function TMagPublisher.I_GetNews(): TMagNewsObject;
Begin
  Result := TMagNewsObject.Create;
  Result.NewsChangeObj := Self.FNewsObject.NewsChangeObj;
  Result.Newscode := Self.FNewsObject.Newscode;
  Result.NewsInitiater := Self.FNewsObject.NewsInitiater;
  Result.NewsStrValue := Self.FNewsObject.NewsStrValue;
  Result.NewsIntValue := Self.FNewsObject.NewsIntValue;
  Result.NewsTopic := Self.FNewsObject.NewsTopic;
End;

Procedure TMagPublisher.I_Notify(NewsObj: TMagNewsObject);
Var
  i: Integer;
  VSubscriber: IMagSubscribe;
Begin
  For i := 0 To (High(FSubscriberList)) Do
  Begin
    If FSubscriberList[i] <> Nil Then
    Begin
      VSubscriber := (FSubscriberList[i]);
      VSubscriber.I_Update(NewsObj);
    End;
  End;
End;

Procedure TMagPublisher.I_SetNews(NewsObj: TMagNewsObject);
Var
  Test: String;
  s, S1, S2, S3: String;
Begin
  Test := '';
  {     p93t8 Gek some published messages can have NewsChangeObj = nil }
  If NewsObj.NewsChangeObj = Nil Then
  Begin
    If NewsObj.Newscode = mpubImageUnSelectAll Then
    Begin
      I_Notify(NewsObj);
      Exit;
    End;

  End;

  {JK 2/12/2009 - Fixes D77}
  If NewsObj.NewsChangeObj <> Nil Then
  Begin
    If Self.FNewsObject.Newscode = NewsObj.Newscode Then
      If NewsObj.Newscode = MpubImageSelected Then
      Begin { TODO : IF CODE IS SAME, 2000, AND OLD iOBJ.MAGO = NEW iOBJ.MAGO WE WON'T MAKE THE CALL. }

        If FNewsObject.NewsStrValue = NewsObj.NewsStrValue Then
        Begin
          Test := 'ignored';
        End;
      End;

    If Test = 'ignored' Then
      Exit;

    Self.FNewsObject.Assign(NewsObj);
    I_Notify(FNewsObject);
  End;
End;

End.
