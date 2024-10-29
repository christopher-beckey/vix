Unit cMagBrokerKeepAlive;

Interface

Uses
  cMagDBBroker,
  Magremoteinterface
  ;

//Uses Vetted 20090929:MagRemoteBrokerManager

Type
  TMagBrokerKeepAlive = Class(TInterfacedObject, IMagRemoteinterface)
  Private
    FBroker: TMagDBBroker;
  Public
    Property Broker: TMagDBBroker Read FBroker Write FBroker;

    Constructor Create();
    Destructor Destroy; Override;

    // for RIV context observation
    Procedure RIVRecieveUpdate_(action: String; Value: String);

  End;

Implementation
Uses
  MagRemoteBrokerManager
  ;

Constructor TMagBrokerKeepAlive.Create();
Begin
  Inherited;
End;

Destructor TMagBrokerKeepAlive.Destroy;
Begin
  Inherited;
End;

Procedure TMagBrokerKeepAlive.RIVRecieveUpdate_(action: String; Value: String);
Begin
  If action = 'IMAGE_COPY_STARTED' Then
  Begin
    If FBroker <> Nil Then
    Begin
      FBroker.KeepBrokerAlive(True);
    End;
    If MagRemoteBrokerManager1 <> Nil Then
    Begin
      MagRemoteBrokerManager1.KeepBrokersAlive(True);
    End;
  End
  Else
    If action = 'IMAGE_COPY_COMPLETE' Then
    Begin
      If FBroker <> Nil Then
      Begin
        FBroker.KeepBrokerAlive(False);
      End;
      If MagRemoteBrokerManager1 <> Nil Then
      Begin
        MagRemoteBrokerManager1.KeepBrokersAlive(False);
      End;
    End;
End;

End.
