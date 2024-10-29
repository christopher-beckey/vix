Unit cMagKeepAliveThread;

Interface

Uses
  Classes,
  Trpcb
  ;


Type
  TMagKeepAliveThread = Class(TThread)
  Private
    FBroker: TRPCBroker;
//    constructor Create(CreateSuspended : boolean; Broker : TrpcBroker);
    Procedure Execute; Override;
  Public
    Property Broker: TRPCBroker Write FBroker;
  End;

Implementation
Uses
  SysUtils
  ;

  {
constructor TMagKeepAliveThread.Create(CreateSuspended : boolean; Broker : TrpcBroker);
begin
  inherited create(CreateSuspended);
  fbroker := broker;
end;
}

Procedure TMagKeepAliveThread.Execute;
Begin
  Self.FreeOnTerminate := True;
  While Not Self.Terminated Do
  Begin
    Try
      // JMW 10/31/2008 p72t28 - sleep for 2 seconds here then make RPC call
      // most likely for quick requests this thread will be terminated when
      // it wakes up, if not it likely won't have timed out the connection to
      // Vista yet after only 2 seconds.
      Sleep(2 * 900);

//      sleep(15 * 900);
      If Not Self.Terminated Then
      Begin
//        LogMsg('s','About to run keep alive RPC on local broker', MagLogINFO);
        FBroker.REMOTEPROCEDURE := 'XWB IM HERE';
        FBroker.Call;
        // JMW 10/31/2008 - p72t28 - move sleep after Call so first time
        // after thread is created, will do keep alive in case most recent
        // keep alive call was a while ago (near timeout

        // JMW 10/31/2008 - p72t28
        // the fbroker.rpctimelimit property is not the property that holds
        // the VistA timeout, its the timeout for connection property, so
        // we don't actually know the VistA timeout. 14 seconds is the lowest
        // allowed value, so using 90% of that value - should work...
        Sleep(14 * 900);
        //sleep(fbroker.RPCTimeLimit * 900);
      End;
    Except
      On e: Exception Do
      Begin
//        LogMsg('s','Exception running keep alive RPC [XWB IM HERE], [' + e.Message + ']', MagLogERROR);
      End;
    End;
  End;

End;

End.
