Unit MagBroker;
   {
   Package: MAG - VistA Imaging
   WARNING: Per VHA Directive 10-93-142 this unit should not be modified.
   Date Created:
   Site Name: Silver Spring, OIFO
   Developers: Garrett Kirin
   Description: Imaging RPC Calls (OLD Design : See cMagDBBroker, cMagDBMVista)
   Note:
   }
(*
   ;; +---------------------------------------------------------------------------------------------------+
   ;; Property of the US Government.
   ;; No permission to copy or redistribute this software is given.
   ;; Use of unreleased versions of this software requires the user
   ;;  to execute a written test agreement with the VistA Imaging
   ;;  Development Office of the Department of Veterans Affairs,
   ;;  telephone (301) 734-0100.
   ;;
   ;; The Food and Drug Administration classifies this software as
   ;; a medical device.  As such, it may not be changed
   ;; in any way.  Modifications to this software may result in an
   ;; adulterated medical device under 21CFR820, the use of which
   ;; is considered to be a violation of US Federal Statutes.
   ;; +---------------------------------------------------------------------------------------------------+
*)

Interface
Uses
  Classes,
  ExtCtrls,
  Trpcb,
  UMagDefinitions,
  UMagClasses ,
  imaginterfaces
  ;


{ TODO : MOVE all of these calls to DBBroker components. }
//procedure RPMag4PatGetImages(DFN: string; var t: tstringlist;pkg: string = '';cls : string = '');
Procedure CreateBroker(Sender: Tobject);
Function BrokerConnect(Vserver, Vport: String; Remotechoice: Boolean; Var ConnectMsg: String; Msgpanel: Tpanel = Nil): Boolean;
Procedure RPCall(p: String; x: Integer);
Procedure RPMag4PostProcessingX(Var Fstat: Boolean; Var Flist: Tstringlist; Magien: String);
/////////////////
Function RPFileManDate(Var Xmsg: String; DateInput: String; Var DateOutput: String; NoFuture: Boolean = False): Boolean;
Procedure RPMultiProcList(Lit: TStrings; DFN: String); //; proclist: Tstrings);

//ADMINDOC
Procedure RPMagVersionCheck(t: TStrings; Version: String);

Procedure RPUpdateConsult(Consult, TiuIen, cmpFlag: String; Var Status: String);
Procedure RPGetClinProcReq(DFN: String; Var t: TStrings);
Procedure RPGetTIUDAfromClinProcReq(DFN, FConsIEN, Vstring, Complete: String; Var t: TStrings);
Procedure RPGetVisitListForReq(DFN: String; Var t: TStrings);

Procedure RPMaggOffLineImageAccessed(IObj: TImageData);
Procedure RPMaggQueImage(IObj: TImageData);
Procedure RPMaggQueBigImage(IObj: TImageData);
Procedure RPMag3Logaction(ActionString: String);
Procedure RPMaggQuePatient(Whichimages, DFN: String);
Procedure RPMaggQueImageGroup(Whichimages, Magien: String);
Procedure RPMaggGroupImages(Magien: String; Var t: Tstringlist);
Procedure RPMaggPatImages(DFN: String; Var t: Tstringlist);
Procedure RPMaggPatEachImage(DFN, Max: String; Var t: Tstringlist);
Procedure RPMaggLogOff(Var TempBroker: TRPCBroker);
Procedure RPMaggWrksUpdate(AppPath, DispAppName, CapAppName, Compname, Location, LastUpdate: String; Startmode: Integer);
Procedure RPMaggUserKeys(Var t: Tstringlist);
Procedure RPMaggGetTimeout(app: String; Var Minutes: String);
Procedure RPGetNoteText(DFN: String; t: TStrings);
Procedure RPGetNoteTitles(t, Tint: Tstringlist);
//  not creating  TIU Entries.
Function RPCreateRecord(Var Msg: String; DFN, Notetitle, Notedate: String; Notetext: TStrings): Boolean;
Function RPGetFileManDateTime(s: String; Var DisDt, IntDT: String): Boolean;
Function RPSignRecord(TiuDA, Hashesign: String; Var Msg: String): Boolean;
//procedure RPGetNotesByContext(dfn:string;var t:tstringlist; context:integer);
Procedure RPGetDischargeSummaries(DFN: String; Var t: Tstringlist);
Procedure RPGetNotesByContext(DFN: String; Var t: Tstringlist; Context: Integer; Author, Count: String; Docclass: Integer; Seq: String; Showadd: Integer; Incund: Integer);
Function RPGetTIUData(TiuDA: String; Var TiuPTR: String): Boolean;
Procedure RPGetCPRSTIUNotes(TiuDA: String; t: Tstringlist; Var Success: Boolean; Var RPmsg: String);
Procedure RPMagCategories(t: TStrings);
Function RPMagPatInfo(DFN: String; Var Retstr: String): Boolean;
//oot moved to magDBBroker
//function RPMagPatLookup(STR: string; t: tstrings; var xmsg: string): boolean;
//oot magDBBroker procedure RPDGSensitiveRecordAccess(DFN: string; var code: INTEGER; var t: TSTRINGLIST);
//oot magDBBroker procedure RPDGSensitiveRecordBulletin(DFN: string);
//oot magDBBroker procedure RPDGChkPatDivMeansTest(DFN: string; var code: INTEGER; var t: TSTRINGLIST);
//oot magDBBroker function RPMaggPatBS5Chk(DFN: string; var t: tstringlist): boolean;
Function RPMagEkgOnline: Integer;
Procedure RPMagGetNetLoc(Var Success: Boolean; Var RPmsg: String; Var Shares: Tstringlist; NetLocType: String);
Procedure RPMagLogErrorText(t: TStrings; Count: Integer);

Function RPTIUCPClass: Integer;
Function RPTIUConsultsClass: Integer;
Procedure RPGetFileExtensions(Var t: TStrings);
Var
  XBROKERX: TRPCBroker;
Var
  BrokerList: Tlist;
Var
  Nullpanel: Tpanel;

Implementation
Uses
  Controls,
  Dialogs,
  Fmxutils,
  Forms,
  Magfileversion,
  RPCconf1,
  SysUtils,
  Umagutils8
  ;

// THIS IS COPIED FROM cMAGDBBROKER
{ TODO :
 HAVE TO REDO- MAGBROKER
//  INTO cMagDBBroker Style. }
//procedure TMagDBBroker.RPMag4PostProcessing(var Fstat: boolean;

Procedure RPMag4PostProcessingX(Var Fstat: Boolean;
  Var Flist: Tstringlist; Magien: String);
Begin
  Fstat := False;
  XBROKERX.PARAM[0].PTYPE := LITERAL;
  XBROKERX.PARAM[0].Value := Magien;
  XBROKERX.REMOTEPROCEDURE := 'MAG4 POST PROCESSING';
  Try
    XBROKERX.LstCALL(Flist);
    If (MagPiece(Flist[0], '^', 1) = '0') Then Exit;
    Fstat := True;
  Except
    On e: Exception Do
    Begin
      // magpiece(E.message, #$A, 3)
      Flist.Insert(0, '0^' + MagPiece(e.Message, #$A, 2));
      Exit;
    End;
  End;

End;
{ not use yet, this is the Idea for later, we call here, then
  we need only 1 try... except for all broker calls }

Procedure RPCall(p: String; x: Integer);
Begin
  With XBROKERX Do
  Begin
    REMOTEPROCEDURE := p;
    Call;

    If Results.Count = 0 Then
    Begin

    End;
    If (MagPiece(Results[0], '^', 1) = '0') Then
    Begin

    End;

  End;
End;

Procedure CreateBroker(Sender: Tobject);
Begin
  XBROKERX := TRPCBroker.Create(Sender As TComponent);
  XBROKERX.ClearParameters := True;
  XBROKERX.ClearResults := True;
  Nullpanel := Nil;
End;

Function BrokerConnect(Vserver, Vport: String; Remotechoice: Boolean; Var ConnectMsg: String; Msgpanel: Tpanel = Nil): Boolean;
Begin
  If ((Vserver = '') Or (Vport = '')) Then
  Begin
    ConnectMsg := 'Invalid Server and/or Port.  Connection canceled.';
    Result := False;
    Exit;
  End;
  If Remotechoice Then
  Begin
    //maggmsgf.magmsg('s', '-Before calling GetServerInfo  : Server - ' + Vserver + ' Port - ' + Vport, nilpanel);
    MagAppMsg('s', '-Before calling GetServerInfo  : Server - ' + Vserver + ' Port - ' + Vport); 
    If (GetServerInfo(Vserver, Vport) = MrCancel) Then
    Begin
      ConnectMsg := 'Login Canceled by User.';
      Result := False;
      Exit;
    End;
  End;
  XBROKERX.Server := Vserver;
  XBROKERX.ListenerPort := Strtoint(Vport);
  //maggmsgf.magmsg('', 'Connecting to '+ Vserver+'...',msgpanel);
  MagAppMsg('', 'Connecting to ' + Vserver + '...'); 
  Msgpanel.Caption := 'Connecting to ' + Vserver + '...';

  Application.Processmessages;
  Try
    XBROKERX.Connected := True;
  Except
    On e: EBrokerError Do
    Begin
      //maggmsgf.magmsg('s', 'ERROR connecting to ' + VServer + ' : ERROR - ' + E.message, nilpanel);
      MagAppMsg('s', 'ERROR connecting to ' + Vserver + ' : ERROR - ' + e.Message); 
      Result := False;
      ConnectMsg := Vserver + ' ERROR: ' + MagPiece(e.Message, #$A, 3);
      Exit;
    End;
  End;
  Result := XBROKERX.Connected;
End;

/////////////////

Procedure RPGetFileExtensions(Var t: TStrings);
Begin
  XBROKERX.REMOTEPROCEDURE := 'MAG4 GET SUPPORTED EXTENSIONS';
  Try
    XBROKERX.LstCALL(t);
  Except
    On e: Exception Do
    Begin
      t.Insert(0, '0^Error: Getting supported Extensions.');
      //maggmsgf.magmsg('de', 'VistA Error: ' + magpiece(e.message, #$A, 2), nilpanel);
      MagAppMsg('de', 'VistA Error: ' + MagPiece(e.Message, #$A, 2)); 
    End;
  End;
End;

Procedure RPUpdateConsult(Consult, TiuIen, cmpFlag: String; Var Status: String);
Begin
  XBROKERX.REMOTEPROCEDURE := 'MAG4 CP UPDATE CONSULT';
  XBROKERX.PARAM[0].PTYPE := LITERAL;
  XBROKERX.PARAM[0].Value := Consult;

  XBROKERX.PARAM[1].PTYPE := LITERAL;
  XBROKERX.PARAM[1].Value := TiuIen;
  XBROKERX.PARAM[2].PTYPE := LITERAL;
  XBROKERX.PARAM[2].Value := cmpFlag;
  Try
    Status := XBROKERX.STRCALL;
  Except
    On e: Exception Do
    Begin
      Status := '0^VistA Error';
      //maggmsgf.magmsg('de', 'VistA Error: ' + magpiece(e.message, #$A, 2), nilpanel);
      MagAppMsg('de', 'VistA Error: ' + MagPiece(e.Message, #$A, 2)); 
    End;
  End;
End;

Function RPTIUCPClass: Integer;
Var
  s: String;
Begin
  XBROKERX.REMOTEPROCEDURE := 'TIU IDENTIFY CLINPROC CLASS';
  Try
    s := XBROKERX.STRCALL;
    Result := Strtoint(s);
  Except
    On e: Exception Do
    Begin
      Messagedlg('VistA Error: ' + MagPiece(e.Message, #$A, 2), Mtconfirmation,
        [Mbok], 0);
      Result := 0;
    End;
  End;
End;

Function RPTIUConsultsClass: Integer;
Var
  s: String;
Begin
  XBROKERX.REMOTEPROCEDURE := 'TIU IDENTIFY CONSULTS CLASS';
  Try
    s := XBROKERX.STRCALL;
    Result := Strtoint(s);
  Except
    On e: Exception Do
    Begin
      Messagedlg('VistA Error: ' + MagPiece(e.Message, #$A, 2), Mtconfirmation,
        [Mbok], 0);
      Result := 0;
    End;
  End;
End;

Procedure RPMagLogErrorText(t: TStrings; Count: Integer);
Var
  i, j: Integer;

Begin
  i := t.Count;
  If (i < Count) Then Count := i;
  XBROKERX.REMOTEPROCEDURE := 'MAGG LOG ERROR TEXT';
  XBROKERX.PARAM[0].Value := '.X';
  XBROKERX.PARAM[0].PTYPE := List;

  For j := 1 To Count Do
  Begin
    Dec(i);
    //xBrokerx.Param[3].Mult['"TEXT'+','+INTTOSTR(I+1)+',0"']:=NOTETEXT[I];
    XBROKERX.PARAM[0].Mult[('"TEXT' + Copy('000', 1, 3 - Length(Inttostr(i))) + Inttostr(i) + '"')] := t[i];
  End;

  XBROKERX.Call;

End;

Procedure RPMagGetNetLoc(Var Success: Boolean; Var RPmsg: String; Var Shares: Tstringlist; NetLocType: String);
Begin
  (* Get all network locations and their properties *)
  Success := False;
  Try
    XBROKERX.PARAM[0].Value := NetLocType;
    XBROKERX.PARAM[0].PTYPE := LITERAL;
    XBROKERX.REMOTEPROCEDURE := 'MAG GET NETLOC';
    XBROKERX.LstCALL(Shares);
    If (MagPiece(Shares[0], '^', 1) = '0') Then
    Begin
      //maggmsgf.MagMsg('', magpiece(Shares[0], '^', 2));
      MagAppMsg('', MagPiece(Shares[0], '^', 2)); 
      RPmsg := Shares[0];
      Exit;
    End;
    If (Shares.Count = 0) Then
    Begin
      //maggmsgf.MagMsg('', 'Error accessing Network Locations');
      MagAppMsg('', 'Error accessing Network Locations'); 
      RPmsg := 'Error accessing Network Locations ';
      Exit;
    End;
    Success := True;
    RPmsg := Shares[0];
    Shares.Delete(0);

  Except
    On e: Exception Do
    Begin
     // Showmessage(e.Message);
      messagedlg(e.Message, Mtconfirmation, [Mbok], 0);
      Shares[0] := 'The Attempt to get network locations. Check VistA Error Log.';
    End;
  End;

End;

Function RPMagEkgOnline: Integer;
Begin
  (* get the status of the first EKG server 0=offline 1=online - if no server exists 0 is returned *)
  XBROKERX.REMOTEPROCEDURE := 'MAG EKG ONLINE';
  Result := Strtoint(XBROKERX.STRCALL);

End;
(* oot MagDBBroker.
function RPMaggPatBS5Chk(DFN: string; var t: tstringlist): boolean;
begin
xBrokerx.PARAM[0].VALUE := DFN;
xBrokerx.PARAM[0].PTYPE := LITERAL;
xBrokerx.REMOTEPROCEDURE := 'MAGG PAT BS5 CHECK';
{         Checks if More than one patient has Same Last Name and Last 4 of SSN
         It calls the Patient API  GUIBS5A^DPTLK6 to figure it out.
         Returns 1 in 1st string if more than 1 exist
         Otherwise 0
         }
try
  xBrokerx.lstCALL(t);
  if t.count = 0 then
  begin
    result := true;
    exit;
  end;

  if t[0] = '0' then
  begin
    result := true;
    exit;
  end;

  t.delete(0);
  result := false;
except
  on E: EXCEPTION do result := true
end; ;

end;
*)

(* oot MagDBBroker
procedure RPDGChkPatDivMeansTest(DFN: string; var code: INTEGER; var t: TSTRINGLIST);
begin
xBrokerx.PARAM[0].VALUE := DFN;
xBrokerx.PARAM[0].PTYPE := LITERAL;
xBrokerx.REMOTEPROCEDURE := 'DG CHK PAT/DIV MEANS TEST';
{         Checks if means test required for patient and checks if means test display required for
         user's division.
         Returns 1 in 1st string if Both true :
         Otherwise 0
         If Both true, returns test in 2nd and 3rd string ( if any)
         }
try
  xBrokerx.lstCALL(t);
  if t.count = 0 then
  begin
    code := -1;
    t[0] := 'The Attempt to determine Patient Means Test Status failed. Check VistA Error Log.';
    exit;
  end;

  code := strtoint(t[0]);
  t.delete(0);
except
  on E: EXCEPTION do
  begin
    code := -1;
    t[0] := 'The Attempt to determine Patient sensitivity Failed. Check VistA Error Log.';
  end;
end;

end;
*)

(* oot MagDBBroker
procedure RPDGSensitiveRecordBulletin(DFN: string);

begin
{         DG SENSITIVITY RECORD BULLETIN
         Input parameter ACTION (send bulletin, set log, or both) will be made optional with 'both' being the default value
         Input parameter DG1 (inpatient/outpatient status) will be removed

PARAMETERS ARE 3 ? ( MIGHT HAVE CHANGED )
 1 = DFN   2 = Option name^Menu text (Optional)  3 =  Action (Optional)
           ACTION CODE 1  SET LOG
                       2  SEND BULLETIN
                       3  BOTH  ( DEFAULT )      }

xBrokerx.PARAM[0].VALUE := DFN;
xBrokerx.PARAM[0].PTYPE := LITERAL;
xBrokerx.REMOTEPROCEDURE := 'DG SENSITIVE RECORD BULLETIN';
xBrokerx.STRCALL;
{
EXCEPT
ON E: EXCEPTION DO
 begin
 result := false;
 IF (POS('<SUBSCRIPT>',E.MESSAGE) > 0 ) THEN xmsg := 'The Remote Procedure Call '+xbrokerx.remoteprocedure+' doesn''t exist on VISTA.  Please Call IRM'
                                       else xmsg := E.message;
 end;
end;
}

end;
*)

(* oot MagDBBroker
procedure RPDGSensitiveRecordAccess(DFN: string; var code: INTEGER; var t: TSTRINGLIST);
begin
xBrokerx.PARAM[0].VALUE := DFN;
xBrokerx.PARAM[0].PTYPE := LITERAL;
xBrokerx.REMOTEPROCEDURE := 'DG SENSITIVE RECORD ACCESS';
{
         DG SENSITIVE RECORD ACCESS
         Output value line 1 of RESULT will be made less granular
         -1 = RPC/API failed
         0 = No display or action required
         1 = Display warning message
         2 = Display warning message - require OK to continue
         3 = Display warning message - do not continue
         If the output value is 1 (display warning message) entry in DG SECURITY LOG file is automatically made; GUI application does not need to take action to log access

         DG SENSITIVITY RECORD BULLETIN
         Input parameter ACTION (send bulletin, set log, or both) will be made optional with 'both' being the default value
         Input parameter DG1 (inpatient/outpatient status) will be removed
}
try
  xBrokerx.lstCALL(t);
  if t.count = 0 then
  begin
    code := -1;
    t[0] := 'The Attempt to determine Patient sensitivity Failed. Check VistA Error Log.';
    exit;
  end;

  code := strtoint(t[0]);
  t.delete(0);
except
  on E: EXCEPTION do
  begin
    code := -1;
    t[0] := 'The Attempt to determine Patient sensitivity Failed. Check VistA Error Log.';
  end;
end;
end;
*)

(* oot magDBBroker
function RPMagPatLookup(STR: string; t: tstrings; var xmsg: string): boolean;
begin
result := false;

xBrokerx.PARAM[0].VALUE := STR;
xBrokerx.PARAM[0].PTYPE := LITERAL;
xBrokerx.REMOTEPROCEDURE := 'MAGG PAT FIND';
try
  xBrokerx.LSTCALL(t);

//i:= t.count     ;
  case t.count of
    0: xmsg := 'ERROR: Searching for ''' + str + ''' No response from VISTA.';
    1: xMsg := t[0];
  else begin
      xMsg := t[0];
      t.delete(0);
      result := true;
    end;
  end;
except
  on E: EXCEPTION do
  begin
    result := false;
    if (POS('<SUBSCRIPT>', E.MESSAGE) > 0) then xmsg := 'The Remote Procedure Call ' + xbrokerx.remoteprocedure + ' doesn''t exist on VISTA.  Please Call IRM'
    else xmsg := E.message;
  end;
end;
end;
*)

Function RPMagPatInfo(DFN: String; Var Retstr: String): Boolean;
Begin
  XBROKERX.PARAM[0].Value := DFN;
  XBROKERX.PARAM[0].PTYPE := LITERAL;
  XBROKERX.REMOTEPROCEDURE := 'MAGG PAT INFO';
  Retstr := XBROKERX.STRCALL;

  If ((Retstr = '') Or (MagPiece(Retstr, '^', 1) = '0')) Then
  Begin
    Result := False;
    Retstr := 'ERROR Patient DFN ' + DFN + ':  ' + MagPiece(Retstr, '^', 2);
  End
  Else
    Result := True;
End;

Procedure RPMaggOffLineImageAccessed(IObj: TImageData);
Begin
  With XBROKERX Do
  Begin
    If Not Connected Then Exit;
    REMOTEPROCEDURE := 'MAGG OFFLINE IMAGE ACCESSED';
    PARAM[0].PTYPE := LITERAL;
    PARAM[0].Value := IObj.FFile;
    PARAM[1].PTYPE := LITERAL;
    PARAM[1].Value := IObj.Mag0;
    Call;
  End;
End;

(*
procedure ___________(magrecord : MagRecordPtr) ;
begin
with xBrokerx do
     begin
     If NOT CONNECTED THEN EXIT;
     REMOTEPROCEDURE :=       ;
     PARAM[0].PTYPE :=   ----;
     PARAM[0].VALUE := -------;
     PARAM[1].PTYPE := -------;
     PARAM[1].VALUE := -----------  ;
     CALL;
     end;
END ;
*)

Procedure RPMag3Logaction(ActionString: String);
Begin
  With XBROKERX Do
  Begin
    PARAM[0].Value := ActionString;
    PARAM[0].PTYPE := LITERAL;
    REMOTEPROCEDURE := 'MAG3 LOGACTION';
    Call;
  End;
End;

Procedure RPMaggQueImage(IObj: TImageData);
Begin
  With XBROKERX Do
  Begin
    PARAM[0].Value := 'AF';
    PARAM[0].PTYPE := LITERAL;
    PARAM[1].Value := IObj.Mag0;
    PARAM[1].PTYPE := LITERAL;
    REMOTEPROCEDURE := 'MAGG QUE IMAGE';
    //maggmsgf.magmsg('s', '--RPC : MAGG QUE IMAGE ^AF^' + IObj.mag0);
    MagAppMsg('s', '--RPC : MAGG QUE IMAGE ^AF^' + IObj.Mag0); 
    Try
      Call;
      //maggmsgf.MagMsg('S', '--' + xBrokerx.RESULTS[0]);
      MagAppMsg('S', '--' + XBROKERX.Results[0]); 
    Except
      Messagedlg('Error attempting to set the Queue ' + #13 + 'to copy an Image from the Juke Box.'
        + #13 + 'Not Fatal, Process will continue.', MtWarning, [Mbok], 0);
    End;
  End;
End;

Procedure RPMaggQueBigImage(IObj: TImageData);
Begin
  With XBROKERX Do
  Begin
    PARAM[0].Value := 'B';
    PARAM[0].PTYPE := LITERAL;
    PARAM[1].Value := IObj.Mag0;
    PARAM[1].PTYPE := LITERAL;
    REMOTEPROCEDURE := 'MAGG QUE IMAGE';
    //maggmsgf.magmsg('s', '--RPC : MAGG QUE IMAGE ^B^' + IObj.mag0);
    MagAppMsg('s', '--RPC : MAGG QUE IMAGE ^B^' + IObj.Mag0); 
    Try
      Call;
      //maggmsgf.MagMsg('S', '--' + xBrokerx.RESULTS[0]);
      MagAppMsg('S', '--' + XBROKERX.Results[0]); 
    Except
      Messagedlg('Error attempting to set the Queue ' + #13 + 'to copy a BIG Image from the Juke Box.'
        + #13 + 'Not Fatal, Process will continue.', MtWarning, [Mbok], 0);
    End;
  End;
End;
// Queue all images for a Patient to be copied from JukeBox to HD.

Procedure RPMaggQuePatient(Whichimages, DFN: String);
Var
  s: String;
Begin
  { whichimages is a code of 'A' for abstract
                             'F' for Full }
  With XBROKERX Do
  Begin
    PARAM[0].Value := Whichimages;
    PARAM[0].PTYPE := LITERAL;
    PARAM[1].Value := DFN;
    PARAM[1].PTYPE := LITERAL;
    REMOTEPROCEDURE := 'MAGG QUE PATIENT';
    //maggmsgf.magmsg('s', '--RPC : MAGG QUE PATIENT ^' + whichimages + '^' + dfn);
    MagAppMsg('s', '--RPC : MAGG QUE PATIENT ^' + Whichimages + '^' + DFN); 
    s := STRCALL;
    //maggmsgf.MagMsg('s', '--' + s, nilpanel);
    MagAppMsg('s', '--' + s); 
  End;
End;
// Queue images to be Copied from JukeBox.
//  The RPC Call "M" code, determines if the iamges need to be queued.
//  and if true.  Makes the call to set the JBtoHD Queue.

Procedure RPMaggQueImageGroup(Whichimages, Magien: String);
Var
  s: String;
Begin
  { whichimages is a code of 'A' for abstract
                             'F' for Full }
  Try
    With XBROKERX Do
    Begin
      PARAM[0].Value := Whichimages;
      PARAM[0].PTYPE := LITERAL;
      PARAM[1].Value := Magien;
      PARAM[1].PTYPE := LITERAL;
      REMOTEPROCEDURE := 'MAGG QUE IMAGE GROUP';
      //maggmsgf.magmsg('s', '--RPC : MAGG QUE IMAGE GROUP^' + whichimages + '^' + MAGIEN);
      MagAppMsg('s', '--RPC : MAGG QUE IMAGE GROUP^' + Whichimages + '^' + Magien); 
      s := STRCALL;
      //maggmsgf.MagMsg('s', '--' + s, nilpanel);
      MagAppMsg('s', '--' + s); 
    End;
  Except
    //
  End;
End;
// Returns all images for an Image Group.

Procedure RPMaggGroupImages(Magien: String; Var t: Tstringlist);
Begin
  With XBROKERX Do
  Begin
    PARAM[0].Value := Magien;
    PARAM[0].PTYPE := LITERAL;
    REMOTEPROCEDURE := 'MAGG GROUP IMAGES'; //MAGOGLU';
    LstCALL(t);
  End;
End;
// New Patch 8 call to return patient images based on filters of
//   package, Class, date range.
(*  moved to magDBBroker
procedure RPMag4PatGetImages(DFN: string; var t: tstringlist;pkg: string = '';cls : string = '');
begin
  with xBrokerx do
  begin
    param[0].Value := DFN;
    param[0].PType := literal;
    if (cls <> '') or (pkg <> '') then
      begin
       param[1].value := pkg;
       param[1].ptype := literal;
       param[2].value := cls;
       param[2].ptype := literal;
      end;
    remoteprocedure := 'MAG4 PAT GET IMAGES';
    lstCall(t);
  end;
end  ;               *)

// Gets all images for a patient.  Groups are returned as one item.
//   Single images are returned as one item.

Procedure RPMaggPatImages(DFN: String; Var t: Tstringlist);
Begin
  With XBROKERX Do
  Begin
    PARAM[0].Value := DFN;
    PARAM[0].PTYPE := LITERAL;
    REMOTEPROCEDURE := 'MAGG PAT IMAGES';
    LstCALL(t);
  End;
End;
// This call returns all images, it returns the images of a group, instead
// of returning the Group.

Procedure RPMaggPatEachImage(DFN, Max: String; Var t: Tstringlist);
Begin
  With XBROKERX Do
  Begin
    PARAM[0].Value := DFN;
    PARAM[0].PTYPE := LITERAL;
    PARAM[1].Value := Max;
    PARAM[1].PTYPE := LITERAL;
    REMOTEPROCEDURE := 'MAGG PAT EACH IMAGE';
    LstCALL(t);
  End;
End;

Procedure RPMaggLogOff(Var TempBroker: TRPCBroker);
Begin
  If Not TempBroker.Connected Then Exit;

  TempBroker.REMOTEPROCEDURE := 'MAGG LOGOFF';
  Try
    TempBroker.Call;
  Except
    On e: EBrokerError Do
      //maggmsgf.magmsg('de', 'Error Connecting to VISTA.' + #13 + #13 + E.MESSAGE + #13 + #13 + 'Shutdown will continue.', nilpanel);
      MagAppMsg('de', 'Error Connecting to VISTA.' + #13 + #13 + e.Message + #13 + #13 + 'Shutdown will continue.'); 
    On e: Exception Do
      //maggmsgf.magmsg('de', 'Error During Log Off : ' + e.message, nilpanel);
      MagAppMsg('de', 'Error During Log Off : ' + e.Message); 
  Else
    //maggmsgf.magmsg('de', 'Unknown Error during Log Off', nilpanel);
    MagAppMsg('de', 'Unknown Error during Log Off'); 
  End;
End;

Procedure RPMaggWrksUpdate(AppPath, DispAppName, CapAppName, Compname, Location, LastUpdate: String; Startmode: Integer);
Var
  DtCapture, DtDisplay: String;
Begin
  DtDisplay := '';
  DtCapture := '';

  If (CapAppName <> '') Then
  Begin
    Try
      DtCapture := Formatdatetime('mm/dd/yy@hh:mm', FILEDATETIME(CapAppName));
    Except
      DtCapture := '';
    End;
  End;
  If (DispAppName <> '') Then
  Begin
    Try
      DtDisplay := Formatdatetime('mm/dd/yy@hh:mm', FILEDATETIME(DispAppName));
    Except
      DtDisplay := '';
    End;
  End;

  XBROKERX.REMOTEPROCEDURE := 'MAGG WRKS UPDATES';
  XBROKERX.PARAM[0].PTYPE := LITERAL;
  XBROKERX.PARAM[0].Value := Compname //1
    + '^' + DtCapture //2
    + '^' + DtDisplay //3
    + '^' + Location //4
    + '^' + LastUpdate // 5
    + '^' + MagGetFileVersionInfo(DispAppName) //6
    + '^' + MagGetFileVersionInfo(CapAppName) //7
    + '^' + Inttostr(Startmode) //8
    + '^' + MagGetOSVersion //9
    + '^' //VistaRadVersion                        //10
    + '^' + XBROKERX.Server //11
    + '^' + Inttostr(XBROKERX.ListenerPort) //12
    + '^';
  XBROKERX.Call;
  //maggmsgf.magmsg('s', 'Workstation Information sent to VistA. Result = ' + xBrokerx.results[0], nilpanel);
  MagAppMsg('s', 'Workstation Information sent to VistA. Result = ' + XBROKERX.Results[0]); 

End;

Procedure RPMaggUserKeys(Var t: Tstringlist);
Begin
  XBROKERX.REMOTEPROCEDURE := 'MAGGUSERKEYS';
  XBROKERX.LstCALL(t);
End;

Procedure RPMaggGetTimeout(app: String; Var Minutes: String);
Begin
  XBROKERX.REMOTEPROCEDURE := 'MAGG GET TIMEOUT';
  XBROKERX.PARAM[0].PTYPE := LITERAL;
  XBROKERX.PARAM[0].Value := app;
  Minutes := XBROKERX.STRCALL;

End;

Procedure RPGetDischargeSummaries(DFN: String; Var t: Tstringlist);
Begin
  XBROKERX.REMOTEPROCEDURE := 'TIU SUMMARIES';
  XBROKERX.PARAM[0].PTYPE := LITERAL;
  XBROKERX.PARAM[0].Value := DFN;
  XBROKERX.LstCALL(t);
End;

Procedure RPGetNoteText(DFN: String; t: TStrings);
Begin
  XBROKERX.REMOTEPROCEDURE := 'TIU GET RECORD TEXT';
  XBROKERX.PARAM[0].PTYPE := LITERAL;
  XBROKERX.PARAM[0].Value := DFN;
  XBROKERX.LstCALL(t);
End;

Procedure RPGetNoteTitles(t, Tint: Tstringlist);
Var
  i: Integer;
Begin
  t.Sorted := False;
  Tint.Sorted := False;
  Tint.Clear;
  XBROKERX.REMOTEPROCEDURE := 'TIU GET PN TITLES';
  //xbrokerx.Param[0].ptype := literal;
  //xbrokerx.param[0].value := dfn  ;
  XBROKERX.LstCALL(t);
  For i := 0 To t.Count - 1 Do
  Begin
    Tint.Add('');
    Tint[i] := Copy(t[i], 2, Pos('^', t[i]) - 2);
    t[i] := MagPiece(t[i], '^', 2)
  End;
End;

//  Not Creating New TIU Records(*

Function RPCreateRecord(Var Msg: String; DFN, Notetitle, Notedate: String; Notetext: TStrings): Boolean;
Var
  i: Integer;
  s: String;
Begin
  If DFN = '' Then
  Begin
    Result := False;
    Msg := 'Need to Select a Patient';
    Exit;
  End;
  XBROKERX.REMOTEPROCEDURE := 'TIU CREATE RECORD';
  XBROKERX.PARAM[0].PTYPE := LITERAL;
  XBROKERX.PARAM[0].Value := DFN;
  XBROKERX.PARAM[1].PTYPE := LITERAL;
  XBROKERX.PARAM[1].Value := Notetitle;

  XBROKERX.PARAM[2].PTYPE := LITERAL;
  XBROKERX.PARAM[2].Value := '';
  XBROKERX.PARAM[3].PTYPE := LITERAL;
  XBROKERX.PARAM[3].Value := '';
  XBROKERX.PARAM[4].PTYPE := LITERAL;
  XBROKERX.PARAM[4].Value := '';

  XBROKERX.PARAM[5].Value := '.X';
  XBROKERX.PARAM[5].PTYPE := List;
  For i := 0 To Notetext.Count Do
  Begin
    //xBrokerx.Param[3].Mult['"TEXT'+','+INTTOSTR(I+1)+',0"']:=NOTETEXT[I];
    XBROKERX.PARAM[5].Mult['"TEXT"' + ',' + Inttostr(i + 1) + ',0'] := Notetext[i];
  End;

  s := XBROKERX.STRCALL;
  If MagPiece(s, '^', 1) = '0' Then
  Begin
    Result := False;
    Msg := MagPiece(s, '^', 2);
  End
  Else
  Begin
    Result := True;
    Msg := s;
  End;

End;

// *)

Function RPGetFileManDateTime(s: String; Var DisDt, IntDT: String): Boolean;
Var
  Dt: String;
  { this returns 1 ^ Display Date ^ internal date
            or   0 ^ error msg     }
Begin
  XBROKERX.PARAM[0].PTYPE := LITERAL;
  XBROKERX.PARAM[0].Value := s;
  XBROKERX.REMOTEPROCEDURE := 'MAGG DTTM';
  XBROKERX.Call;
  Dt := XBROKERX.Results[0];
  If (Dt = '') Or (Copy(Dt, 1, 1) = '0') Then
  Begin
    Result := False;
    Messagedlg(MagPiece(Dt, '^', 2), Mtconfirmation, [Mbok], 0);
    Exit;
  End;
  DisDt := MagPiece(Dt, '^', 2);

  If Maglength(DisDt, ':') > 2 Then DisDt := MagPiece(DisDt, ':', 1) + ':' + MagPiece(DisDt, ':', 2);

  IntDT := MagPiece(Dt, '^', 3);
  Result := True;
End;

Function RPSignRecord(TiuDA, Hashesign: String; Var Msg: String): Boolean;
Var
  s: String;
Begin
  XBROKERX.PARAM[0].PTYPE := LITERAL;
  XBROKERX.PARAM[0].Value := TiuDA;
  XBROKERX.PARAM[1].PTYPE := LITERAL;
  XBROKERX.PARAM[1].Value := Hashesign;
  XBROKERX.REMOTEPROCEDURE := 'TIU SIGN RECORD';
  s := XBROKERX.STRCALL;
  If (s = '0') Then
    Result := True
  Else
  Begin
    Result := False;
    Msg := s;
  End;
End;

Procedure RPGetNotesByContext(DFN: String; Var t: Tstringlist; Context: Integer; Author, Count: String; Docclass: Integer; Seq: String; Showadd: Integer; Incund: Integer);
Begin
  (*
                  CLIP OF CODE FROM THE CALL TO 'TIU DOCUMENTS BY CONTEXT'
  CONTEXT(TIUY,CLASS,CONTEXT,DFN,EARLY,LATE,PERSON,OCCLIM,SEQUENCE,SHOWADD,INCUND)
   ; main
           ; --- Call with:  TIUY     - RETURN ARRAY pass by reference
          0 ;                 CLASS    - Pointer to TIU DOCUMENT DEFINITION #8925.1
          1 ;                 CONTEXT  - 1=All Signed (by PT),
           ;                          - 2="Unsigned (by PT&(AUTHOR!TANSCRIBER))
           ;                          - 3="Uncosigned (by PT&EXPECTED COSIGNER
           ;                          - 4="Signed notes (by PT&selected author)
           ;                          - 5="Signed notes (by PT&date range)
          2 ;                 DFN      - Pointer to Patient (#2)
          3 ;                [EARLY]   - FM date/time to begin search
          4 ;                [LATE]    - FM date/time to end search
          5 ;                [PERSON]  - Pointer to file 200 (DUZ if not passed)
          6 ;                [OCCLIM]  - Occurrence Limit (optional)
          7 ;                [SEQUENCE]- "A"=ascending (Regular date/time)
           ;                          - "D"=descending (Reverse date/time) (dflt)
          8 = SHOWADD(wasn't documented in 'M' routine
              SHOWADD 0/1  means Show Addenda
          9 ;                [INCUND]  - Boolean: include undictated & untranscribe

  *)
  XBROKERX.REMOTEPROCEDURE := 'TIU DOCUMENTS BY CONTEXT';
  XBROKERX.PARAM[0].PTYPE := LITERAL;
  XBROKERX.PARAM[0].Value := Inttostr(Docclass); // CPMOD was just '3'
  XBROKERX.PARAM[1].PTYPE := LITERAL;
  XBROKERX.PARAM[1].Value := Inttostr(Context);
  XBROKERX.PARAM[2].PTYPE := LITERAL;
  XBROKERX.PARAM[2].Value := DFN;
  XBROKERX.PARAM[3].PTYPE := LITERAL;
  XBROKERX.PARAM[3].Value := '';
  XBROKERX.PARAM[4].PTYPE := LITERAL;
  XBROKERX.PARAM[4].Value := '';
  XBROKERX.PARAM[5].PTYPE := LITERAL;
  XBROKERX.PARAM[5].Value := Author;
  XBROKERX.PARAM[6].PTYPE := LITERAL;
  XBROKERX.PARAM[6].Value := Count;

  XBROKERX.PARAM[7].PTYPE := LITERAL;
  XBROKERX.PARAM[7].Value := Seq;
  XBROKERX.PARAM[8].PTYPE := LITERAL;
  XBROKERX.PARAM[8].Value := Inttostr(Showadd);
  XBROKERX.PARAM[9].PTYPE := LITERAL;
  XBROKERX.PARAM[9].Value := Inttostr(Incund);
  XBROKERX.LstCALL(t);
End;

Function RPGetTIUData(TiuDA: String; Var TiuPTR: String): Boolean;
Var
  s: String;
Begin
  XBROKERX.REMOTEPROCEDURE := 'MAG3 TIU DATA FROM DA';
  XBROKERX.PARAM[0].PTYPE := LITERAL;
  XBROKERX.PARAM[0].Value := TiuDA;
  Try
    s := XBROKERX.STRCALL;
    If ((s = '') Or (MagPiece(s, '^', 1) = '0')) Then
    Begin
      Result := False;
      TiuPTR := '';
      Exit;
    End;
    Result := True;
    TiuPTR := s;
  Except
    Result := False;
    TiuPTR := '';
  End;
End;

Procedure RPGetCPRSTIUNotes(TiuDA: String; t: Tstringlist; Var Success: Boolean; Var RPmsg: String);
Begin
  Success := False;
  Try
    XBROKERX.REMOTEPROCEDURE := 'MAG3 CPRS TIU NOTE';
    XBROKERX.PARAM[0].PTYPE := LITERAL;
    XBROKERX.PARAM[0].Value := TiuDA;
    XBROKERX.LstCALL(t);
    If (MagPiece(t[0], '^', 1) = '0') Then
    Begin
      //maggmsgf.MagMsg('', magpiece(t[0], '^', 2));
      MagAppMsg('', MagPiece(t[0], '^', 2)); 
      RPmsg := t[0];
      Exit;
    End;
    If (t.Count = 0) Then
    Begin
      //maggmsgf.MagMsg('', 'Error accessing Images for TIU Note ');
      MagAppMsg('', 'Error accessing Images for TIU Note '); 
      RPmsg := 'Error accessing Images for TIU Note ';
      Exit;
    End;
    Success := True;
    RPmsg := t[0];
    t.Delete(0);
  Except
    On e: Exception Do
    Begin
      //maggmsgf.MagMsg('', 'Exception accessing Images for TIU Note ');
      MagAppMsg('', 'Exception accessing Images for TIU Note '); 
      RPmsg := 'Exception accessing Images for TIU Note ';
    End;
  End;
End;

//procedure RPMagCategories(var t, tien: tstrings);

Procedure RPMagCategories(t: TStrings);
Begin
  //ADMINDOC
  Try
    t.Clear;
    //tien.clear;
    XBROKERX.REMOTEPROCEDURE := 'MAGGDESCCAT';
    XBROKERX.LstCALL(t);
    If (t.Count = 0) Then
    Begin
      //maggmsgf.magmsg('', 'Error loading Image Cagetories.');
      MagAppMsg('', 'Error loading Image Cagetories.'); 
      Exit;
    End;
    If (t.Count = 1) Then
      //maggmsgf.magmsg('de', magpiece(t[0], '^', 2));
      MagAppMsg('de', MagPiece(t[0], '^', 2)); 
    t.Delete(0);

  Except
    On e: Exception Do
      //maggmsgf.magmsg('de', 'Exception ' + e.message);
      MagAppMsg('de', 'Exception ' + e.Message); 
  End;
End;

Procedure RPGetClinProcReq(DFN: String; Var t: TStrings);
Begin
  //  success := false;
  Try
    XBROKERX.REMOTEPROCEDURE := 'MAG4 CP GET REQUESTS';
    XBROKERX.PARAM[0].PTYPE := LITERAL;
    XBROKERX.PARAM[0].Value := DFN;
    XBROKERX.LstCALL(t);
    If (MagPiece(t[0], '^', 1) = '0') Then
    Begin
      //maggmsgf.MagMsg('', magpiece(t[0], '^', 2));
      MagAppMsg('', MagPiece(t[0], '^', 2)); 
      Exit;
    End;
    If (t.Count = 0) Then
    Begin
      //maggmsgf.MagMsg('', 'Error while listing CP Requests. ');
      MagAppMsg('', 'Error while listing CP Requests. '); 
      t.Add('0^Error while listing CP Requests. ');
      Exit;
    End;
    //    success := true;
    t.Delete(0);
  Except
    On e: Exception Do
    Begin
      //maggmsgf.MagMsg('', 'Exception while listing CP Requests. ');
      MagAppMsg('', 'Exception while listing CP Requests. '); 
      t.Insert(0, '0^Exception while listing CP Requests. ');
    End;
  End;
End;

Procedure RPGetTIUDAfromClinProcReq(DFN, FConsIEN, Vstring, Complete: String; Var t: TStrings);
Begin
  //  success := false;
  Try
    XBROKERX.REMOTEPROCEDURE := 'MAG4 CP CONSULT TO TIUDA';
    XBROKERX.PARAM[0].PTYPE := LITERAL;
    XBROKERX.PARAM[0].Value := DFN;
    XBROKERX.PARAM[1].PTYPE := LITERAL;
    XBROKERX.PARAM[1].Value := FConsIEN;
    XBROKERX.PARAM[3].PTYPE := LITERAL;
    XBROKERX.PARAM[3].Value := Complete;
    XBROKERX.PARAM[2].PTYPE := LITERAL;
    XBROKERX.PARAM[2].Value := Vstring;
    XBROKERX.LstCALL(t);
    If (MagPiece(t[0], '^', 1) = '0') Then
    Begin
      //maggmsgf.MagMsg('', magpiece(t[0], '^', 2));
      MagAppMsg('', MagPiece(t[0], '^', 2)); 
      Exit;
    End;
    If (t.Count = 0) Then
    Begin
      //maggmsgf.MagMsg('', 'Error (#34) in VistA');
      MagAppMsg('', 'Error (#34) in VistA'); 
      t.Add('0^Error (#34) in VistA');
      Exit;
    End;
    //    success := true;
    //     t.delete(0);
  Except
    On e: Exception Do
    Begin
      //maggmsgf.MagMsg('', 'Exception (#34) in VistA');
      MagAppMsg('', 'Exception (#34) in VistA'); 
      t.Insert(0, '0^Exception (#34) in VistA');
    End;
  End;

End;

Procedure RPGetVisitListForReq(DFN: String; Var t: TStrings);
Begin
  //  success := false;
  Try
    XBROKERX.REMOTEPROCEDURE := 'MAG4 CP GET VISITS';
    XBROKERX.PARAM[0].PTYPE := LITERAL;
    XBROKERX.PARAM[0].Value := DFN;
    XBROKERX.LstCALL(t);
    If (MagPiece(t[0], '^', 1) = '0') Then
    Begin
      //maggmsgf.MagMsg('', magpiece(t[0], '^', 2));
      MagAppMsg('', MagPiece(t[0], '^', 2)); 
      Exit;
    End;
    If (t.Count = 0) Then
    Begin
      //maggmsgf.MagMsg('', 'Error Listing Patient visits.');
      MagAppMsg('', 'Error Listing Patient visits.'); 
      t.Add('0^Error Listing Patient visits.');
      Exit;
    End;
    //    success := true;

    t.Delete(0);
  Except
    On e: Exception Do
    Begin
      //maggmsgf.MagMsg('', 'Exception Listing Patient visits.');
      MagAppMsg('', 'Exception Listing Patient visits.'); 
      t.Insert(0, '0^Exception Listing Patient visits.');
    End;
  End;
End;

Procedure RPMagVersionCheck(t: TStrings; Version: String);
Begin
  XBROKERX.REMOTEPROCEDURE := 'MAG4 VERSION CHECK';
  XBROKERX.PARAM[0].PTYPE := LITERAL;
  XBROKERX.PARAM[0].Value := Version;

  Try
    XBROKERX.LstCALL(t);
    If (t.Count = 0) Then
    Begin
      t.Insert(0, '1^continue');
      //maggmsgf.magmsg('', 'Error Checking Version on Server');
      MagAppMsg('', 'Error Checking Version on Server'); 
      Exit;
    End;

  Except
    On e: Exception Do
    Begin
      t.Insert(0, '1^continue');
      //maggmsgf.magmsg('de', 'Exception ' + e.message);
      MagAppMsg('de', 'Exception ' + e.Message); 
    End;
  End;
End;

Function RPFileManDate(Var Xmsg: String; DateInput: String; Var DateOutput: String; NoFuture: Boolean = False): Boolean;
Var
  s: String;
Var
  X2, X3: String;
Begin
  Result := False;
  If Not XBROKERX.Connected Then
  Begin
    Xmsg := 'You must be connected to VistA to enable Date functions';
    Exit;
  End;
  DateOutput := '';
  s := DateInput;
  If Uppercase(s) = 'T' Then s := 'N';
  XBROKERX.PARAM[0].PTYPE := LITERAL;
  XBROKERX.PARAM[0].Value := s;
  {             Added flag to Stop Future Dates.}
  If NoFuture Then
  Begin
    XBROKERX.PARAM[1].PTYPE := LITERAL;
    XBROKERX.PARAM[1].Value := '1';
  End;
  XBROKERX.REMOTEPROCEDURE := 'MAGG DTTM';
  XBROKERX.Call;
  s := XBROKERX.Results[0];
  If (s = '') Then s := '0^Error converting input to Date/Time';
  If (Copy(s, 1, 1) = '0') Then
  Begin
    DateOutput := '';
    Xmsg := MagPiece(s, '^', 2);
    Exit;
  End;
  // take out the seconds
  X2 := MagPiece(s, '^', 2);
  X3 := MagPiece(s, '^', 3);
  If (Pos(':', X2) > 0) Then
    X2 := MagPiece(X2, ':', 1) + ':' + MagPiece(X2, ':', 2);
  X3 := Copy(X3, 1, 12);

  DateOutput := X2 + '^' + X3;
  Result := True;
End;

Procedure RPMultiProcList(Lit: TStrings; DFN: String); // proclist: Tstrings);
Var
  t: TStrings;
Begin
  Lit.Clear;
  t := Tstringlist.Create;
  XBROKERX.REMOTEPROCEDURE := 'MAG4 MULTI PROCEDURE LIST';
  // for now we get all
  XBROKERX.PARAM[0].PTYPE := List;
  XBROKERX.PARAM[0].Value := '.x';
  XBROKERX.PARAM[0].Mult['1'] := 'MED^ALL';
  XBROKERX.PARAM[0].Mult['2'] := 'LAB^ALL';
  XBROKERX.PARAM[0].Mult['3'] := 'RAD^ALL';
  XBROKERX.PARAM[0].Mult['4'] := 'SUR^ALL';
  XBROKERX.PARAM[0].Mult['5'] := 'TIU^ALL';
  XBROKERX.PARAM[1].PTYPE := LITERAL;
  XBROKERX.PARAM[1].Value := DFN;

  Try
    XBROKERX.LstCALL(t);
    If (t.Count = 0) Then
    Begin
      Lit.Add('<Error loading ''Procedure'' list>');
      //maggmsgf.magmsg('', 'Error loading Procedure listing.');
      MagAppMsg('', 'Error loading Procedure listing.'); 
      Exit;
    End;

  Except
    On e: Exception Do
    Begin
      Lit.Add('<Exception loading ''Procedure'' list>');
      //maggmsgf.magmsg('', 'Exception loading Procedure listing');
      MagAppMsg('', 'Exception loading Procedure listing'); 
      Exit;
    End;
  End;
  t.Delete(0);
  Lit.AddStrings(t);
  t.Free;
End;

End.
