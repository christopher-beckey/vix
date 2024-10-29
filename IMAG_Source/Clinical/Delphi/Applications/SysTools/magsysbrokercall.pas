Unit magsysbrokercall;

Interface
Uses Trpcb,
  SysUtils,
  WinTypes,
  WinProcs,
  Messages,
  Classes;

Procedure MaggSysSessionDisplay(Var t: Tstringlist; Sess: Integer);

Var
  Broker: TRPCBroker;
Implementation

Procedure MaggSysSessionDisplay(Var t: Tstringlist; Sess: Integer);
Begin
  Broker.PARAM[0].Value := Inttostr(Sess);
  Broker.PARAM[0].PTYPE := LITERAL;
  Broker.REMOTEPROCEDURE := 'MAGG SYS SESSION DISPLAY';
  Broker.LstCALL(t);
End;

End.
