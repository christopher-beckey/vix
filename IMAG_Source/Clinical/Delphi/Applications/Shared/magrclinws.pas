Unit Magrclinws;
{DEFINE MAKEABS}
Interface

(*  refactor, get rid of unused.  P93
Function GetPatSSN: String;
Function GetPatName: String;
Function GetPatDFN: string;
Procedure LogAction(Mode: boolean);
Function DCMOpenSecurity(filenm1: widestring; message1: string): boolean;
*)
Procedure LogWarning(Mode: Boolean; WarnMsg: String);

Implementation
Uses
  UMagClasses,
  ImagDMinterface // DmSingle
  ;

Procedure LogWarning(Mode: Boolean; WarnMsg: String);
Var
  IObj: TImageData;
Begin
// JMW 4/21/2005 p45
  IObj := TImageData.Create();
  IObj.ServerName := idmodobj.GetMagDBBroker1.GetServer;
  IObj.ServerPort := idmodobj.GetMagDBBroker1.GetListenerPort;
  If Not Mode Then idmodobj.GetMagDBBroker1.RPMag3Logaction(WarnMsg, IObj);

End;
(*

Function GetPatSSN: string;
begin
result := dmod.MagPat1.M_SSN;
end;

Function GetPatName: string;
begin
result := dmod.MagPat1.M_NameDisplay;
end;

Function GetPatDFN: string;
begin
result := dmod.MagPat1.M_DFN;
end;

//Function SetARecord: integer;
//begin

//end;

Procedure LogAction(Mode: boolean);
begin

end;

Function DCMOpenSecurity(filenm1: widestring; message1: string): boolean;
begin
{$IFDEF MAKEABS}exit;{$ENDIF}
DCMOpenSecurity := false;
exit; // JMW 6/17/2005 THIS SHOULD PROBABLY NOT BE HERE, testing to be sure we don't need security here anymore!

end;
*)
End.
