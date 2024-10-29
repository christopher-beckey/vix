Unit cMagDBMVista;
{
Package: MAG - VistA Imaging
WARNING: Per VHA Directive 10-93-142 this unit should not be modified.
Date Created:
Site Name: Silver Spring, OIFO
Developers: Garrett Kirin
[==    unit cMagDBMVista;
Description:
  Imaging M-Vista database calls. Desecndant of Abstract Class TMagDBBroker
  This Class will surface (redeclare, override and implement) the Abstract
  methods and members of the ancestor abstract class to make DataBase Calls.
  This design enables the application to function the same way
  regardless of which database is connected.  M, (Oracle), Demo TXT files
==]
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

//{$DEFINE DEMO CREATE}
Interface

Uses
  Classes,
  cMagDBBroker,
  cMagKeepAliveThread,
  Controls,
  Trpcb,
  UMagClasses,
  UMagDefinitions,
  Maggmsgu,
  VERGENCECONTEXTORLib_TLB
  ;

//Uses Vetted 20090929:CCOWRPCBroker, extctrls, magRemoteInterface, IMagRemoteBrokerInterface, MagRemoteBrokerManager, magfileversion, fmxutils, uMagUtils, RPCconf1, hash, Dialogs, Forms, SysUtils, Messages, Windows

Type
  TMagDBMVista = Class(TMagDBBroker)
  Private
    FBroker: TRPCBroker;
    FKeepAliveEnabled: Boolean;
    FKeepAliveThread: TMagKeepAliveThread;
    Function AddCreationDateToResultItem(Value: String; Col: Integer): String;
    Procedure AddCreationDateToResultsList(Flist: TStrings);
    Procedure CreateMessageHistory;
    Procedure LogRPCException(Errstring: String);
    Procedure LogRPCParams;
    Procedure LogRPCResult(s: String); Overload;
    Procedure LogRPCResult(t: TStrings); Overload;
    Procedure LogRPCResult; Overload;
    Procedure SetGSession(plist: TStrings; pSess: TSession);
    procedure ReserializeRemoteList(var Stat: Boolean; var RS: TStrings; PatName: String);
  Public
    Constructor Create();//RLM Fixing MemoryLeak 6/18/2010
    Destructor Destroy(); Override;//RLM Fixing MemoryLeak 6/18/2010
    Function CheckDBConnection(Var Xmsg: String): Boolean; Override;
    Function DBConnect(Vserver, Vport: String; Context: String = 'MAG WINDOWS'; AccessCode: String = ''; Verifycode: String = '';division : string = ''): Boolean; Override;
    Function DBSelect(Var Vserver, Vport: String; Context: String = 'MAG WINDOWS'): Boolean; Override;
    Function GetBroker: TRPCBroker; Override;
    Function GetListenerPort: Integer; Override;
    Function GetServer: String; Override;
    Function GetSilentCodes(Vserver, Vport: String; Var SilentAccess: String; Var SilentVerify: String): Boolean; Override;
    Function GetUserSSN(): String; Override;
    Function IENtoTImageData(Ien: String; Var Rstat: Boolean; Var Rmsg: String): TImageData;
    Function IsConnected: Boolean; Override;
    Function RPCreateRecord(Var Msg: String; DFN, Notetitle, Notedate: String; Notetext: TStrings): Boolean; Override;
    Function RPFileManDate(Var Xmsg: String; DateInput: String; Var DateOutput: String; NoFuture: Boolean = False): Boolean; Override;
    Function RPGetFileManDateTime(DateStr: String; Var DisDt, IntDT: String; NoFuture: Boolean): Boolean; Override;
    Function RPGetTIUData(TiuDA: String; Var TiuPTR: String): Boolean; Override;
    Function RPMag4GetFileFormatInfo(Ext: String; Var Xmsg: String): Boolean; Override;
    function RPMagEkgOnline: integer; override;
    Function RPMagGetPatientDFNFromICN(Var Xmsg: String; PatientICN: String): Boolean; Override;
    Function RPMagGetTeleReader(Var t: TStrings; Var Xmsg: String): Boolean; Override;
    Function RPMaggGetPhotoIDs(Xdfn: String; t: Tstringlist): Boolean; Override;
    Function RPMaggIsDocClass(Ien, Fmfile, ClassName: String; Var Stat: Boolean; Var Fmsg: String): Boolean; Override;
    Function RPMaggPatBS5Chk(DFN: String; Var t: Tstringlist): Boolean; Override;
    Function RPMagPatLookup(Str: String; t: TStrings; Var Xmsg: String): Boolean; Override;
    Function RPMagSecurityToken(): String; Override;
    Function RPMagSetTeleReader(Var Xmsg: String; Sitecode: String; SpecialtyCode: String; ProcedureCode: String; UserWants: String): Boolean; Override;
    Function RPMagTeleReaderUnreadlistGet(Var t: TStrings; Var Xmsg: String; AcquisitionPrimaryDivision, Sitecode, SpecialtyCode, ProcedureStrings, LastUpdate, UserDUZ, LocalSiteCode, SiteTimeOut,
      StatusOptions: String): Boolean; Override;
    Function RPMagTeleReaderUnreadlistLock(Var Xmsg: String; AcquisitionPrimaryDivision, AcquisitionSiteCode, ItemID, LockUnlockValue, UserFullName, UserInitials, LocalDUZ, LocalSiteCode: String):
      Boolean; Override;
    Function RPSignRecord(TiuDA, Hashesign: String; Var Msg: String): Boolean; Override;
    Function RPTIUConsultsClass: Integer; Override;
    Function RPTIUCPClass: Integer; Override;
    Function RPTIUSignRecord(Var Fmsg: String; DFN, TiuDA, Hashesign: String): Boolean; Override;
    Function RPVerifyEsig(Esig: String; Var Xmsg: String): Boolean; Override;
    Function RPXWBGetVariableValue(Value: String): String; Override;
    {p117  reanamed from UserHasRightToThinClient to be consistent with sop. RPMag...}
    Function RPMag3TRThinClientAllowed: Boolean; Override;
    Procedure CreateBroker; Override;
    Procedure KeepBrokerAlive(Enabled: Boolean); Override;
    Procedure RPCTPresetsGet(Var Rstat: Boolean; Var Rmsg: String; Var Value: String); Override;
    Procedure RPCTPresetsSave(Var Rstat: Boolean; Var Rmsg: String; Value: String); Override;
    Procedure RPDGChkPatDivMeansTest(DFN: String; Var Code: Integer; Var t: Tstringlist); Override;
    Procedure RPDGSensitiveRecordAccess(DFN: String; Var Code: Integer; Var t: Tstringlist); Override;
    Procedure RPDGSensitiveRecordBulletin(DFN: String); Override;
    Procedure RPFilterDelete(Var Rstat: Boolean; Var Rmsg: String; Fltien: String); Override;
    Procedure RPFilterDetailsGet(Var Rstat: Boolean; Var Rmsg, Filter: String; Fltien: String; Fltname: String = ''; Duz: String = ''); Override;
    Procedure RPFilterListGet(Var Rstat: Boolean; Var Rmsg: String; Var Tlist: TStrings; Duz: String = ''; Getall: Boolean = False); Override;
    Procedure RPFilterSave(Var Rstat: Boolean; Var Rmsg: String; t: TStrings); Override;
    Procedure RPGetClinProcReq(DFN: String; Var t: TStrings); Override;
    Procedure RPGetCPRSTIUNotes(TiuDA: String; t: Tstringlist; Var Success: Boolean; Var RPmsg: String); Override;
    Procedure RPGetDischargeSummaries(DFN: String; Var t: Tstringlist); Override;
    Procedure RPGetFileExtensions(Var t: TStrings); Override;
    Procedure RPGetNotesByContext(DFN: String; Var t: Tstringlist; Context: Integer; Author, Count: String; Docclass: Integer; Seq: String; Showadd: Integer; Incund: Integer; Mthsback: Integer = 0;
      Dtfrom: String = ''; Dtto: String = ''); Override;
    Procedure RPGetNoteText(TiuDA: String; t: TStrings); Override;
    Procedure RPGetNoteTitles(t, Tint: Tstringlist); Override;
    Procedure RPGetTIUDAfromClinProcReq(DFN, FConsIEN, Vstring, Complete: String; Var t: TStrings); Override;
    Procedure RPGetVisitListForReq(DFN: String; Var t: TStrings); Override;
    Procedure RPGMRCListConsultRequests(Var Fstat: Boolean; Var Fmsg: String; Var Flist: Tstringlist; DFN: String); Override;
    Procedure RPImageReport(Var Fstat: Boolean; Var Fmsg: String; Flist: TStrings; IObj: TImageData; NoQAcheck: Boolean = False); Override;
    Procedure RPIndexGetEvent(Lit: TStrings; Cls: String = ''; Spec: String = ''; IgnoreStatus: Boolean = False; IncClass: Boolean = False; IncStatus: Boolean = False); Override;
    Procedure RPIndexGetSpecSubSpec(Lit: TStrings; Cls: String = ''; Proc: String = ''; IgnoreStatus: Boolean = False; IncClass: Boolean = False; IncStatus: Boolean = False; IncSpec: Boolean =  False); Override;
    Procedure RPIndexGetType(Lit: TStrings; Cls: String; IgnoreStatus: Boolean = False; IncClass: Boolean = False; IncStatus: Boolean = False); Override;
    Procedure RPLogCopyAccess(s: String; IObj: TImageData; EventType: TMagImageAccessEventType); Override;
    Procedure RPMag3ListAny(Var Fstat: Boolean; Var Fmsg: String; Var Flist: TStrings; VFile, VStart, VFlags: String; VNum: String = '50'; VCR: String = 'B'; VData: String = ''); Override;
    Procedure RPMag3Logaction(ActionString: String; IObj: TImageData = Nil); Override;
    Procedure RPMag3LookupAny(Var Fstat: Boolean; Var Fmsg: String; Var Flist: Tstringlist; InputString: String; Data: String = ''); Override;
    Procedure RPMag3TIUImage(Var Fstat: Boolean; Var Flist: Tstringlist; Magien, TiuDA: String); Override;
    Procedure RPMag4AddImage(Var Fstat: Boolean; Var Flist: Tstringlist; t: Tstringlist); Override;
    Procedure RPMag4DataFromImportQueue(Var Fstat: Boolean; Var Flist: Tstringlist; QueueNum: String); Override;
    Procedure RPMag4FieldValueGet(Var Fstat: Boolean; Var Fmsg: String; Var Flist: Tstringlist; Ien: String; Flags: String = ''; Flds: String = ''); Override;
    Procedure RPMag4FieldValueSet(Var Fstat: Boolean; Var Fmsg: String; Var Flist: Tstringlist; t: Tstringlist); Override;
    Procedure RPMag4GetImageInfo(VIobj: TImageData; Var Flist: TStrings; DeletedImagePlaceholders: Boolean = False); Override;  {/ P117 - JK 9/20/2010 - added last parameter /}
    Procedure RPMag4IAPIStats(Var Fstat: Boolean; Var Flist: TStrings; DtStart, DtEnd: String); Override;
    Procedure RPMag4PatGetImages(Var Fstat: Boolean; Var Rpcmsg: String; DFN: String; Var Flist: TStrings; Filter: TImageFilter = Nil); Override;
    Procedure RPMag4PostProcessActions(Var Fstat: Boolean; Var Flist: Tstringlist; Magien: String); Override;
    Procedure RPMag4RemoteImport(Var Fstat: Boolean; Var Flist: Tstringlist; DataArray: Tstringlist); Override;
    Procedure RPMag4StatusCallback(t: TStrings; cb: String; DoStatusCB: Boolean = True); Override;
    Procedure RPMag4ValidateData(Var Fstat: Boolean; Var Flist: Tstringlist; t: Tstringlist; Rettype: String); Override;
    Procedure RPMagABSJB(Var Fstat: Boolean; Var Flist: Tstringlist; CreatAbsIEN, JBCopyIEN: String); Override;
    Procedure RPMaggCaptureUsers(Var Fstat: Boolean; Var Fmsg: String; Var Flist: Tstringlist; Inputparams: Tstringlist); Override;
    Procedure RPMaggCPRSRadExam(Var Rstat: Boolean; Var Rmsg: String; Var Rlist: TStrings; CprsString: String); Override;
    Procedure RPMaggDGRPD(Var Rstat: Boolean; Var Rmsg: String; Var Rlist: Tstringlist; DFN: String); Override;
    Procedure RPMagGetNetLoc(Var Success: Boolean; Var RPmsg: String; Var Shares: Tstringlist; NetLocType: String); Override;
    Procedure RPMagGetUserPreferences(Var Fstat: Boolean; Var Rpcmsg: String; Xlist: Tstringlist; Code: String = ''); Override;
    Procedure RPMaggGetTimeout(app: String; Var Minutes: String); Override;
    Procedure RPMaggGroupImages(IObj: TImageData; Var t: Tstringlist; NoQAcheck: Boolean = False; DeletedImages: String = ''); Override;  {/p117 }
    Procedure RPMaggHS(Var Rstat: Boolean; Var Rmsg: String; Var Tlist: Tstringlist; Value: String); Override;
    Procedure RPMaggHSList(Var Rstat: Boolean; Var Rmsg: String; Var Tlist: Tstringlist; Value: String); Override;
    Procedure RPMaggImageDelete(Var Fstat: Boolean; Var Rmsg: String; Var Flist: TStrings; Ien, ForceDel: String; Reason: String = ''; GrpDelOK: Boolean = False); Override;
    Procedure RPMaggImageGetProperties(Var Rstat: Boolean; Var Rmsg: String; Var Rlist: TStrings; Ien, Params: String); Override;
    Procedure RPMaggImageInfo(Var Rstat: Boolean; Var Rmsg: String; Var Rlist: TStrings; Ien: String; NoQAcheck: Boolean = False); Override;
    Procedure RPMaggImageSetProperties(Var Rstat: Boolean; Var Rmsg: String; Var Rlist: TStrings; Fieldlist: TStrings; Ien, Params: String); Override;
    Procedure RPMaggInstall(Var Fstat: Boolean; Var Flist: Tstringlist); Override;
    Procedure RPMaggLogOff; Override;
    Procedure RPMaggOffLineImageAccessed(IObj: TImageData); Override;
    Procedure RPMaggPatEachImage(DFN, Max: String; Var t: Tstringlist); Override;
    Procedure RPMaggQueBigImage(IObj: TImageData); Override;
    Procedure RPMaggQueImage(IObj: TImageData); Override;
    Procedure RPMaggQueImageGroup(Whichimages: String; IObj: TImageData); Override;
    Procedure RPMaggQuePatient(Whichimages, DFN: String); Override;
    Procedure RPMaggRadExams(Var Rstat: Boolean; Var Rmsg: String; Var Rlist: TStrings; DFN: String); Override;
    Procedure RPMaggRadImage(Var Rstat: Boolean; Var Rmsg: String; Var Tlist: Tstringlist; Radstring: String); Override;
    Procedure RPMaggRadReport(Var Rstat: Boolean; Var Rmsg: String; Var Tlist: Tstringlist; Rarpt: String); Override;
    Procedure RPMaggReasonList(Var Rstat: Boolean; Var Rmsg: String; Var Rlist: TStrings; Data: String); Override;
    Procedure RPMaggUser2(Var Rstat: Boolean; Var Rmsg: String; Var Rlist: TStrings; Wsid: String; pSess: TSession = Nil); Override;
    Procedure RPMaggUserKeys(Var t: Tstringlist); Override;
    Procedure RPMaggWrksUpdate(AppPath, DispAppName, CapAppName, Compname, Location, LastUpdate: String; Startmode: Integer); Override;
        procedure RPIndexGetOrigin(lit: TStrings); override;   {/ JK 11/24/2009 - P108 New method /}
        function RPPatientHasPhoto(DFN: String; var Stat: Boolean; var FMsg: String): String; override;  {/ JK 11/24/2009 - P108 New method /}
    Procedure RPMagImageStatisticsUsers(Var Fstat: Boolean; Var Fmsg: String; Var Flist: Tstringlist; Inputparams: Tstringlist); Override;
    Procedure RPMagImageStatisticsQue(var Fstat: Boolean; var Fmsg: String; var Flist: TStringList; InputParams: TStringList); override;  {/ JK 8/5/2010 - P117 /}
    Procedure RPMagImageStatisticsByUser(var Fstat: Boolean; var Fmsg: String; var Flist: TStringList; UserDUZ: String); override; {/ JK 8/5/2010 - P117 /}
    Procedure RPMagLogCapriRemoteLogin(Application: TMagRemoteLoginApplication; SiteNumber: String); Override;
    Procedure RPMagLogErrorText(t: TStrings; Count: Integer); Override;

    {/ P117 - JK 10/5/2010 - Added 5th Parameter to support Deleted Image Placeholder counts/}
//    Procedure RPMagPatInfo(Var Fstat: Boolean; Var Fstring: String; MagDFN: String; IsIcn: Boolean = False); Override;
    Procedure RPMagPatInfo(Var Fstat: Boolean; Var Fstring: String; MagDFN: String; IsIcn: Boolean = False; IncDeletedCount: Boolean = False); Override;

    Procedure RPMagSetUserPreferences(Var Fstat: Boolean; Var Rpcmsg: String; Xlist: TStrings); Override;
    Procedure RPMagsVerifyReport(StartDate, EndDate, Options: String; t: Tstringlist); Override; {JK 6/1/2009}
    Procedure RPMagVersionCheck(t: TStrings; Version: String); Override;
    Procedure RPMagVersionStatus(Var Status: String; Version: String); Override;
    Procedure RPTeleReaderConsultListRequests(Var Fstat: Boolean; Var Fmsg: String; Var Flist: Tstringlist; DFN: String); Override;
    Procedure RPTIUAuthorization(Var Fstat: Boolean; Var Fmsg: String; TiuDA, action: String); Override;
    Procedure RPTIUCreateAddendum(Var Fstat: Boolean; Var Fmsg: String; DFN, TiuDA, AdminClose, Mode, Esighash, Esigduz, Notedate: String; Notetext: Tstringlist = Nil); Override;
    Procedure RPTIUCreateNote(Var Fstat: Boolean; Var Fmsg: String; DFN, Title, AdminClose, Mode, Esighash, Esigduz, Loc, Notedate, ConsltDA: String; Notetext: Tstringlist = Nil); Override;
    Procedure RPTIUisThisaConsult(Var Fstat: Boolean; Var Fmsg: String; Titleda: String); Override;
    Procedure RPTIULoadBoilerplateText(Var Fstat: Boolean; Var Fmsg: String; Var Flist: Tstringlist; Titleda: String; DFN: String); Override;
    Procedure RPTIULongListOfTitles(Var Fstat: Boolean; Var Fmsg: String; Var Flist: TStrings; NoteClass, InputString: String; Mylist: Boolean = False); Override;
    Procedure RPTIUModifyNote(Var Fstat: Boolean; Var Fmsg: String; DFN, TiuDA, AdminClose, Mode, Esighash, Esigduz: String; Notetext: Tstringlist = Nil); Override;
    Procedure RPUpdateConsult(Consult, TiuIen, cmpFlag: String; Var Status: String); Override;
    Procedure RPXMultiProcList(Lit: TStrings; DFN: String); Override;
    Procedure SetBroker(Const Value: TRPCBroker); Override;
    Procedure SetConnected(Const Value: Boolean); Override;
    Procedure SetContextor(Contextor: TContextorControl); Override;
    Procedure SetListenerPort(Const Value: Integer); Override;
    Procedure SetServer(Const Value: String); Override;
    {/117 gek,  moved from private to public.}
        procedure RPMag4ImageList(var Fstat: boolean; var rpcmsg: string; DFN: string; var Flist: tstrings; filter: TImageFilter = nil); override;
	{/117 gek  a call that doesn't call all remote sites.}    
		procedure RPMagPatInfoQuiet(var Fstat: boolean; var Fstring: string; MagDFN: string; isicn: boolean = false); override;
    {BB P117 08/24/2010 - write multi image print sesion results to #2006.961}
    {p117 gek reanamed from MagROIMultiPagePrint to be consistent with sop. RPMag...}
    procedure  RPMaggMultiImagePrint(DFN, Reason: String; Images: TStringList); override;
    procedure RPMagJukeBoxPath(var Fstat: Boolean; var Fmsg: String; ImageIEN: String); override;

  End;

Implementation
Uses
  CCOWRPCBroker,
  Dialogs,
  Fmxutils,
  Hash,
  IMagRemoteBrokerInterface,
  Magfileversion,
  MagRemoteBrokerManager,
  Magremoteinterface,
  RPCconf1,
  SysUtils,
  Umagutils8,
  Windows
  ;
//Uses Vetted 20090929:Messages, Forms, extctrls,umagclasses

Procedure TMagDBMVista.RPMagsVerifyReport(StartDate, EndDate, Options: String; t: Tstringlist); {JK 6/1/2009 for ImageVerify Reporting}
Begin
  Try
    FBroker.PARAM[0].PTYPE := LITERAL;
    FBroker.PARAM[0].Value := Options;
    FBroker.PARAM[1].PTYPE := LITERAL;
    FBroker.PARAM[1].Value := StartDate;
    FBroker.PARAM[2].PTYPE := LITERAL;
    FBroker.PARAM[2].Value := EndDate;
    FBroker.REMOTEPROCEDURE := 'MAGG IMAGE STATISTICS';
        //Call;
    FBroker.LstCALL(t);

  Except
    On e: Exception Do
      LogRPCException('TMagDBMVista.RPMagsVerifyReport: ' + e.Message);
  End;
End;

{JK 10/5/2009 - Maggmsgu refactoring - removed old method}
//procedure TMagDBMVista.LogMsg(MsgType: string; Msg: string; Priority: TMagLogPriority = MagLogINFO);
//begin
//    if assigned(OnLogEvent) then
//        OnLogEvent(self, MsgType, Msg, Priority);
//end;

{JK 10/5/2009 - Maggmsgu refactoring - removed old method}
//procedure TMagDBMVista.LogMsg(MsgType: string; Msgs: TStrings; Priority: TMagLogPriority = MagLogINFO);
//var
//    i: integer;
//begin
//    if assigned(OnLogEvent) then
//    begin
//        for i := 0 to Msgs.Count - 1 do
//        begin
//            OnLogEvent(self, MsgType, Msgs.Strings[i], Priority);
//        end;
//    end;
//    (*  else
//      begin
//      with maggmsgf do
//       begin
//        magmsg('s','' -----msg- Params --------- ' ' + Fbroker.remoteprocedure);
//        for i := 0 to Msgs.Count -1 do
//          begin
//          magmsg('s','['+inttostr(i) + '] = '+Msgs.Strings[i]);
//          end;
//       end;
//      end; *)
//end;

Procedure TMagDBMVista.RPDGChkPatDivMeansTest(DFN: String; Var Code: Integer; Var t: Tstringlist);
Begin
  FBroker.PARAM[0].Value := DFN;
  FBroker.PARAM[0].PTYPE := LITERAL;
  FBroker.REMOTEPROCEDURE := 'DG CHK PAT/DIV MEANS TEST';
    {         Checks if means test required for patient and checks if means test
               display required for
               user's division.
               Returns 1 in 1st string if Both true :
               Otherwise 0
               If Both true, returns test in 2nd and 3rd string ( if any)
               }
  Try
    FBroker.LstCALL(t);
    If t.Count = 0 Then
    Begin
      Code := -1;
      t[0] := 'The Attempt to determine Patient Means Test Status failed. Check VistA Error Log.';
      Exit;
    End;
    Code := Strtoint(t[0]);
    t.Delete(0);
  Except
    On e: Exception Do
    Begin
      Code := -1;
      t[0] := 'The Attempt to determine Patient Means Test Status failed. Failed. Check VistA Error Log.';
    End;
  End;
End;

Procedure TMagDBMVista.RPDGSensitiveRecordBulletin(DFN: String);
Begin
    {         DG SENSITIVITY RECORD BULLETIN
               Input parameter ACTION (send bulletin, set log, or both) will be
                       made optional with 'both' being the default value
               Input parameter DG1 (inpatient/outpatient status) will be removed

    PARAMETERS ARE 3 ? ( MIGHT HAVE CHANGED )
       1 = DFN   2 = Option name^Menu text (Optional)  3 =  Action (Optional)
                 ACTION CODE 1  SET LOG
                             2  SEND BULLETIN
                             3  BOTH  ( DEFAULT )      }

  FBroker.PARAM[0].Value := DFN;
  FBroker.PARAM[0].PTYPE := LITERAL;
  FBroker.REMOTEPROCEDURE := 'DG SENSITIVE RECORD BULLETIN';
  FBroker.STRCALL;
    {TODO: who do we notify, if the attempt to log the access fails ? }
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

End;

{ TODO: Changed style of Broker Calls to be similiar in paramters.
  stat, xmsg, list, etc.  It will make it easier to have a single method that
  makes the Broker call and handles exceptions.  This would be much preferred
  over the current way, that has each Procedure or Function having it's own
  exception handler (or having none) }

Procedure TMagDBMVista.RPDGSensitiveRecordAccess(DFN: String; Var Code: Integer; Var t: Tstringlist);
Begin
    {
      if RemoteAccess = nil then
      begin
        RemoteAccess := TList.Create();
      end;
      MagRemoteBrokerManager1.checkPatientSensitive(RemoteAccess);
      }

  FBroker.PARAM[0].Value := DFN;
  FBroker.PARAM[0].PTYPE := LITERAL;
  FBroker.REMOTEPROCEDURE := 'DG SENSITIVE RECORD ACCESS';
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
  Try
    FBroker.LstCALL(t);
    If t.Count = 0 Then
    Begin
      Code := -1;
      t[0] := 'The Attempt to determine Patient sensitivity Failed. Check VistA Error Log.';
      Exit;
    End;

    Code := Strtoint(t[0]);
    t.Delete(0);
  Except
    On e: Exception Do
    Begin
      Code := -1;
      t[0] := 'The Attempt to determine Patient sensitivity Failed. Check VistA Error Log.';
    End;
  End;
End;

{ TODO : This needs changed to style of Broker Calls in magDBBroker. }

Function TMagDBMVista.RPMaggPatBS5Chk(DFN: String; Var t: Tstringlist): Boolean;
Begin
  FBroker.PARAM[0].Value := DFN;
  FBroker.PARAM[0].PTYPE := LITERAL;
  FBroker.REMOTEPROCEDURE := 'MAGG PAT BS5 CHECK';
    {         Checks if More than one patient has Same Last Name and Last 4 of SSN
               It calls the Patient API  GUIBS5A^DPTLK6 to figure it out.
               Returns 1 in 1st string if more than 1 exist
               Otherwise 0
               }
  Try
    FBroker.LstCALL(t);
    If t.Count = 0 Then
    Begin
      Result := True;
      Exit;
    End;

    If t[0] = '0' Then
    Begin
      Result := True;
      Exit;
    End;

    t.Delete(0);
    Result := False;
  Except
    On e: Exception Do
      Result := True
  End;
  ;

End;

{ TODO : This needs changed to style of Broker Calls in magDBBroker. }

Function TMagDBMVista.RPMagPatLookup(Str: String; t: TStrings; Var Xmsg: String): Boolean;
Begin
  Result := False;

  FBroker.PARAM[0].Value := Str;
  FBroker.PARAM[0].PTYPE := LITERAL;
  FBroker.REMOTEPROCEDURE := 'MAGG PAT FIND';
  Try
    FBroker.LstCALL(t);
        {SAHO,F 10/10/1920 123456789   NON-VETERAN(OTHER)^959}
         //i:= t.count     ;
    Case t.Count Of
      0: Xmsg := 'ERROR: Searching for ''' + Str + ''' No response from VISTA.';
      1: Xmsg := t[0];
    Else
      Begin
        Xmsg := t[0];
        t.Delete(0);
        Result := True;
      End;
    End;
  Except
    On e: Exception Do
    Begin
      Result := False;
      If (Pos('<SUBSCRIPT>', e.Message) > 0) Then
        Xmsg := 'The Remote Procedure Call ' + FBroker.REMOTEPROCEDURE + ' doesn''t exist on VISTA.  Please Call IRM'
      Else
        Xmsg := e.Message;
    End;
  End;
End;

{== RPMag4PatGetImages
 New Patch 8 call to return patient images based on filter.
 Filter : TImageFilter  ==}

Procedure TMagDBMVista.RPMag4PatGetImages(Var Fstat: Boolean; Var Rpcmsg: String; DFN: String; Var Flist: TStrings; Filter: TImageFilter = Nil);
Var
  Cls, Pkg, Types, Spec, Event: String;
  FrDt: String;
  ToDt: String;
  MthRange: Integer;
  Origin: String;
  i, j: Integer;
  ImageResult: Boolean;
  Loc: Integer;
  SortList: Tstringlist;
  FinalList: TStrings;
  Tempstr3: String;
  RemoteList: TStrings;
  PartialResult: Boolean; {/ P117 NCAT - JK 11/30/2010 /}
  PartialMsg: String;  {/ P117 NCAT - JK 1/17/2011 /}
    {RemoteStatus,} RemoteColumns, RemoteData, RemoteDFN: String;
  RemoteBroker: IMagRemoteBroker;
  RBrokerResult: TMagPatientStudyResponse;
  PR: String; {/ P117 NCAT - JK 12/2/2010 - partial result string variable /}
Begin
  ImageResult := False;
  Cls := '';
  Pkg := '';
  Types := '';
  Spec := '';
  Event := '';
  FrDt := '';
  ToDt := '';
  Origin := '';
  If Filter <> Nil Then
  Begin
    Cls := ClassesToString(Filter.Classes);
    Pkg := PackagesToString(Filter.Packages);
    Types := Filter.Types;
    Spec := Filter.SpecSubSpec;
    Event := Filter.ProcEvent;
    FrDt := Filter.FromDate;
    ToDt := Filter.ToDate;
    MthRange := Filter.MonthRange;
    If MthRange < 0 Then
    Begin
      FrDt := Formatdatetime('mm/dd/yyyy', IncMonth(Date, MthRange));
      ToDt := '';
    End;
    Origin := Filter.Origin;
  End;
  With FBroker Do
  Begin
    PARAM[0].Value := DFN;
    PARAM[0].PTYPE := LITERAL;
    PARAM[1].Value := Pkg;
    PARAM[1].PTYPE := LITERAL;
    PARAM[2].Value := Cls;
    PARAM[2].PTYPE := LITERAL;
    PARAM[3].Value := Types;
    PARAM[3].PTYPE := LITERAL;
    PARAM[4].Value := Event;
    PARAM[4].PTYPE := LITERAL;
    PARAM[5].Value := Spec;
    PARAM[5].PTYPE := LITERAL;
    PARAM[6].Value := FrDt;
    PARAM[6].PTYPE := LITERAL;
    PARAM[7].Value := ToDt;
    PARAM[7].PTYPE := LITERAL;
    PARAM[8].Value := Origin;
    PARAM[8].PTYPE := LITERAL;
    FBroker.REMOTEPROCEDURE := 'MAG4 PAT GET IMAGES';
  End;
  Try
    LogRPCParams;
    FBroker.LstCALL(Flist);

{$IFDEF DEMO CREATE}
    Flist.SaveToFile(ExtractFilePath(Application.ExeName) + '\image\xMagDemoImageList' + DFN + '.TXT');
{$ENDIF}
    LogRPCResult(Flist);
    If (MagPiece(Flist[0], '^', 1) = '0') Then
    Begin
      Rpcmsg := MagPiece(Flist[0], '^', 2);
            //        exit; // no longer want to exit since we need to check remote brokers // JMW 3/2/2005 p45
                    // add useless line so it can be removed KLUDGE!
            //        Flist.Add('useless');
      Flist.Delete(0);
    End //;
    Else
    Begin
      ImageResult := True;

      Rpcmsg := MagPiece(Flist[0], '^', 2);
      Flist.Delete(0);
    End;
  Except
    On e: Exception Do
    Begin
      LogRPCException(e.Message);
      Flist.Insert(0, '0^ERROR Accessing Patient Image list.');
      ImageResult := False;
      Rpcmsg := 'ERROR Accessing Patient Image list: ' + e.Message;
      Flist.Insert(1, '0^' + MagPiece(e.Message, #$A, 2));
    End;
  End;

  If Flist.Count > 0 Then
    If Not IsServerPortInString(Flist[1], 'MAG4 PAT GET IMAGES') Then
      ResolveServerPort(Flist, FBroker.Server, FBroker.ListenerPort, 1);

    {   check to see that the RemoteBrokerManager was initialized, 
        in Capture it is not so the RIV items should not be executed.}
  If MagRemoteBrokerManager1 = Nil Then
  Begin
    Fstat := ImageResult;
    Exit;
  End;

  If MagRemoteBrokerManager1.NewPatientSelected Then
  Begin
    Fstat := ImageResult;
    MagRemoteBrokerManager1.NewPatientSelected := False;
        //LogMsg('s', 'cMagDBMVistA - a new patient has been selected, will not load remote images for patient');
    MagLogger.LogMsg('s', 'cMagDBMVistA - a new patient has been selected, will not load remote images for patient'); {JK 10/5/2009 - Maggmsgu refactoring}
    Exit;
  End;
    {HERE, TRY LOOPING THROUGH THIS REMOTE BROKER LIST TO CALL THE KEEP ALIVE CALL.}
  RemoteList := Tstringlist.Create();
  For j := 0 To MagRemoteBrokerManager1.GetBrokerCount() - 1 Do
  Begin
    RemoteList.Clear(); // JMW 2/25/08 P72 - clear the list before each remote call, was holding onto old data, not sure why not a problem before
        // make sure the broker is active and also be sure the patient has at least 1 image at that site
    If (MagRemoteBrokerManager1.IsRemoteBrokerActive(j)) And ((MagRemoteBrokerManager1.RemoteBrokerArray[j].GetImageCount() > 0) Or
      (MagRemoteBrokerManager1.RemoteBrokerArray[j].GetImageCount() = -1)) Then
    Begin
      RemoteBroker := MagRemoteBrokerManager1.RemoteBrokerArray[j];
            //      TRemoteBroker := MagRemoteBrokerManager1.RemoteBrokerArray[j].getBroker();
      RemoteDFN := MagRemoteBrokerManager1.GetRemoteDFN(j);
      Try
                //LogMsg('s', 'DFN:' + RemoteDFN + ' Start RPC MAG4 PAT GET IMAGES on ' + remoteBroker.getServerDescription + ' ' +
                //    formatdatetime('mm/dd/yy@hh:nn:ss.zzz', now));
        MagLogger.LogMsg('s', 'DFN:' + RemoteDFN + ' Start RPC MAG4 PAT GET IMAGES on ' + RemoteBroker.GetServerDescription + ' ' +
          Formatdatetime('mm/dd/yy@hh:nn:ss.zzz', Now)); {JK 10/5/2009 - Maggmsgu refactoring}
                // if this returns false then there was an error getting studies
                // if one site fails, is this how we should indicate, by failing all?
                {JMW 4/1/07 Patch 72
                  Changing the way this works, now if the getpatientStudies returns false and the remote site is RPC, then it fails all (maybe still not correct but is consistent with before (patch 45)).
                  If remote site is WS, then this likely means the ViX had a problem communicating with the remote site (VA or BIA).
                  In this case we will disconnect the remote site and log the error but allow the client to continue. Perhaps in the future we should indicate a different error to the user (color or text)
                }
        RBrokerResult := RemoteBroker.GetPatientStudies(Pkg, Cls, Types, Event, Spec, FrDt, ToDt, Origin, RemoteList, PartialResult, PartialMsg);  {/ P117 NCAT - JK 11/30/2010 /}


        If Not (RBrokerResult = MagStudyResponseOk) Then
        Begin
          If RemoteBroker.GetRemoteBrokerType = MagRemoteRPCBroker Then
          Begin
            Flist.Insert(0, RemoteList.Strings[0]);
            Fstat := False;
            Flist.Insert(1, RemoteList.Strings[1]);
            Exit;
          End
          Else
          Begin // if WS broker, disconnect and show disconnected
            RemoteBroker.Disconnect;
                        // JMW 11/3/2008 p72t28 - if the response is a normal exception
                        // then update the site as disconnected. If the exception is
                        // a socket timeout, then mark disconnected with try again (special
                        // case since DoD sometimes takes too long for study graphs).
            If RBrokerResult = MagStudyResponseException Then
              Magremoteinterface.RIVNotifyAllListeners(Nil, 'SetDisconnectedAndUpdate', RemoteBroker.GetSiteCode())
            Else
              If RBrokerResult = MagStudyResponseTimeout Then
                Magremoteinterface.RIVNotifyAllListeners(Nil, 'SetSiteTimeoutException', RemoteBroker.GetSiteCode())
          End;
        End;
                {JMW 4/1/07 Patch 72
                only continue if remote broker result was good}
        If RBrokerResult = MagStudyResponseOk Then
        Begin
          If RemoteBroker.IsBrokerLateCountUpdate Then
          Begin
            {/ P117 NCAT - JK 12/2/2010 /}
            if PartialResult then
            begin
              PR := '^Partial';
              MagLogger.LogMsg('', 'Partial Result Message = [ ' + PartialMsg + ']'); {/ P117 NCAT - JK 1/17/2011 /}
            end
            else
              PR := '';
            Magremoteinterface.RIVNotifyAllListeners(Nil, 'UpdateImageCount', RemoteBroker.GetSiteCode + '^' +
              Inttostr(RemoteBroker.GetImageCount()) + PR);
          End;

{$IFDEF DEMO CREATE}
{$ENDIF}

                    //LogMsg('s', 'DFN:' + RemoteDFN + ' Done RPC MAG4 PAT GET IMAGES on ' + remoteBroker.getServerDescription + ' ' +
                    //    formatdatetime('mm/dd/yy@hh:nn:ss.zzz', now));
          MagLogger.LogMsg('s', 'DFN:' + RemoteDFN + ' Done RPC MAG4 PAT GET IMAGES on ' + RemoteBroker.GetServerDescription + ' ' +
            Formatdatetime('mm/dd/yy@hh:nn:ss.zzz', Now)); {JK 10/5/2009 - Maggmsgu refactoring}
          If (MagPiece(RemoteList[0], '^', 1) = '0') Then
          Begin
            Rpcmsg := MagPiece(RemoteList[0], '^', 2);
            RemoteList.Delete(0);
          End
          Else
          Begin
            ImageResult := True;
            Rpcmsg := MagPiece(RemoteList[0], '^', 2);
            RemoteList.Delete(0);
            RemoteColumns := RemoteList.Strings[0];
            If Flist.Count = 0 Then
            Begin
              Flist.Add(RemoteColumns);
            End
            Else
            Begin
              If MagRemoteBrokerManager.IsMergeColumnHeadersNeeded(Flist.Strings[0], RemoteColumns) Then
              Begin
                MagRemoteBrokerManager.MergeColumnHeaders(Flist, RemoteList);
              End;
            End;
            RemoteList.Delete(0);
          End;
          If RemoteList.Count > 0 Then
            If Not IsServerPortInString(RemoteList.Strings[0], 'RIV: MAG4 PAT GET IMAGES') Then
              ResolveServerPort(RemoteList, RemoteBroker.GetServerName(), RemoteBroker.GetServerPort());
          For i := 0 To RemoteList.Count - 1 Do
          Begin
            Loc := Pos('^', RemoteList.Strings[i]);
            RemoteData := Copy(RemoteList.Strings[i], Loc, Length(RemoteList.Strings[i])); // - loc);

                        //RemoteList.Strings[i] := RemoteList.Strings[i] + '^' + TRemoteBroker.server + '^' + inttostr(TRemoteBroker.listenerport);
            RemoteList.Strings[i] := Inttostr(Flist.Count + i) + RemoteData + '^';
                        // + remoteBroker.getServerName() + '^' + inttostr(remoteBroker.getServerPort());
          End;
          Flist.AddStrings(RemoteList);
        End; {End of if rBrokerResult - ok connection to remote site}
      Except
        On e: Exception Do
        Begin
          Flist.Insert(0, '0^ERROR Accessing Patient Image list.');
          ImageResult := False;
          Rpcmsg := 'ERROR Accessing Patient Image list: ' + e.Message;
          Flist.Insert(1, '0^' + MagPiece(e.Message, #$A, 2));
          Fstat := ImageResult;
          Exit;
        End;
      End; {except}
    End; {if}
  End; {for}

  Fstat := ImageResult;

  If Flist.Count <= 0 Then
    Flist.Add(Rpcmsg);

    // put all the image data into a list to be sorted

  SortList := Tstringlist.Create();
  For i := 1 To Flist.Count - 1 Do
  Begin

        // JMW 6/17/2005 p45t3 wasn't loading the date from the correct location, caused problem with p59
    //    SortList.Add(formatdatetime('yyyymmddhhmmnn', strtodatetime(magpiece(magpiece(flist.Strings[i], '|', 2), '^', 8))) + '^' + magpiece(flist.strings[i], '^', 1));
        // JMW 12/7/2005 p46t1 Fixed bug so that if the date is invalid it won't crash
    //was in 72     SortList.Add(MagRemoteBrokerManager.convertAndFormatDateTime(magpiece(magpiece(flist.Strings[i], '|', 2), '^', 8)) + '^' + magpiece(flist.strings[i], '^', 1));

       (* p59   SortList.Add(MagConvertAndFormatDateTime(magpiece(magpiece(flist.Strings[i], '|', 2), '^', 8)) + '^' + magpiece(flist.strings[i], '^', 1)); *)
        {The list is by Reverse Date, and all with same date, need reverse order of item # because of the SortList.Sort comming up.}
    Tempstr3 := (MagConvertAndFormatDateTime(MagPiece(Flist.Strings[i], '^', 4)) + '^' + Inttostr(10000 - Strtoint(MagPiece(Flist.Strings[i], '^', 1))));
    SortList.Add(Tempstr3); //MagConvertAndFormatDateTime(magpiece(flist.Strings[i],'^', 4)) + '^' +    magpiece(flist.strings[i], '^', 1));;

  End;

  SortList.Sort(); // sort the list

  FinalList := Tstringlist.Create(); // create a list to put the sorted data into
  FinalList.Add(Flist.Strings[0]);

  For i := 0 To SortList.Count - 1 Do
  Begin
        // use insert instead of add because Delphi sorts it ascending instaed of descending
        {p59 convert back to original item #, by 10000 - }
    FinalList.Insert(1, Flist.Strings[10000 - Strtoint(MagPiece(SortList.Strings[i], '^', 2))]);
  End;

  FreeAndNil(SortList); // JMW 7/19/2005 p45t5

    // need to re-number the images
  For i := 1 To FinalList.Count - 1 Do
  Begin
    Loc := Pos('^', FinalList.Strings[i]);
    RemoteData := Copy(FinalList.Strings[i], Loc, Length(FinalList.Strings[i])); // - loc);

    FinalList.Strings[i] := Inttostr(i) + RemoteData; // + '^' + TRemoteBroker.server + '^' + inttostr(TRemoteBroker.listenerport);
  End;

    {
      RemoteStatus := '';
      for i := 0 to FinalList.Count -1 do
      begin
         RemoteStatus := RemoteStatus + #13 + FinalList.Strings[i];
      end;

      showmessage(RemoteStatus);
      }
  Flist := FinalList;
End;

Function TMagDBMVista.RPMaggGetPhotoIDs(Xdfn: String; t: Tstringlist): Boolean;
Begin
  Try
    With FBroker Do
    Begin
      PARAM[0].Value := Xdfn;
      PARAM[0].PTYPE := LITERAL;
      FBroker.REMOTEPROCEDURE := 'MAGG PAT PHOTOS';
      LstCALL(t);
    End;
    If (t.Count < 2) Then
      Result := False
    Else
    Begin
      Result := True;
      t.Delete(0);
    End;
  Except
    Result := False;
  End;
  If Result Then
    If Not IsServerPortInString(t[0], 'MAGG PAT PHOTOS') Then
      ResolveServerPort(t, FBroker.Server, FBroker.ListenerPort);
    //if (magpiece(t[0],'^',1) = 0 ) then result := false;
    //if (magpiece(t[0],'^',2) = 0 ) then result := false;
End;
{'B2^618^\\isw-imggold\image1$\DM\00\06\DM000618.JPG^\\isw-imggold\image1$\DM\00\06\DM000618.ABS^PHOTO ID Apr 06, 2000^
                                     3000406.1701^18^PHOTO ID^04/06/2000^^M^A^^^1^.04^Unk^^^1023^GREEN,DEAN^ADMIN/CLIN^^^^'}
(*function TMagDBMVista.Connected : boolean;
begin
 if assigned(Fbroker) then
   result := Fbroker.Connected
 else result := false;
end; *)

Function TMagDBMVista.DBConnect(Vserver, Vport: String; Context: String = 'MAG WINDOWS';
                                 AccessCode: String = ''; Verifycode: String = '';division : string = ''): Boolean;
Var
  SilentAccess, SilentVerify: String;
Begin
  If Not Assigned(FBroker) Then
  Begin
    Result := False;
    Exit;
  End;

 (* before 121
  If ((AccessCode <> '') And (Verifycode <> '')) Then
  Begin
    FBroker.AccessVerifyCodes := AccessCode + ';' + Verifycode;
  End *)
{/p121  silent login, fixed with division.
    Tested example from  Kernel code in \vista\brk32\samples 2006\silentlogin}
  If ((AccessCode <> '') And (Verifycode <> '')) Then
  Begin
  //   showmessage('cmagDBMVista: , silent login');
     Fbroker.Login.AccessCode := AccessCode;
     Fbroker.Login.VerifyCode := Verifycode;
     //   Server := edtServer.Text;
     //   ListenerPort := StrToInt(edtListenerPort.Text);
     Fbroker.KernelLogin := False;
     Fbroker.Login.Mode := lmAVCodes;
        //ORIGINAL// Login.PromptDivision := True;
      Fbroker.login.PromptDivision := (division  = '');
      if division  <> '' then Fbroker.login.Division := Division;
  End
  Else
    If GetSilentCodes(Vserver, Vport, SilentAccess, SilentVerify) Then
    Begin
      FBroker.KernelLogIn := False;
      FBroker.LogIn.Mode := LmAVCodes;
      FBroker.LogIn.AccessCode := SilentAccess;
      FBroker.LogIn.Verifycode := SilentVerify;
        //Fbroker.AccessVerifyCodes := SilentAccess + ';' + SilentVerify;
    End;

  FBroker.Server := Vserver;
  FBroker.ListenerPort := Strtoint(Vport);
  Try
    FBroker.Connected := True;
    Result := FBroker.Connected;

    If Result Then
    Begin
      FBroker.CreateContext(Context);
    End;
  Except
    On e: Exception Do
    Begin
            //LogMsg('', e.Message);
      MagLogger.LogMsg('', e.Message); {JK 10/5/2009 - Maggmsgu refactoring}
      Result := False;
    End;
  End;
End;

Procedure TMagDBMVista.CreateMessageHistory;
Begin
    //maggmsgf := Tmaggmsgf.create(nil);
End;

Function TMagDBMVista.DBSelect(Var Vserver, Vport: String; Context: String = 'MAG WINDOWS'): Boolean;
Var
  SilentAccess, SilentVerify: String;
Begin
  If Not Assigned(FBroker) Then
  Begin
    Result := False;
    Exit;
  End;
  Try
    If Not Doesformexist('MAGGMSGF') Then
      CreateMessageHistory;
    If (GetServerInfo(Vserver, Vport) = MrOK) Then
    Begin
      If GetSilentCodes(Vserver, Vport, SilentAccess, SilentVerify) Then
      Begin
        FBroker.AccessVerifyCodes := SilentAccess + ';' + SilentVerify;
      End;

      FBroker.Server := Vserver;
      FBroker.ListenerPort := Strtoint(Vport);
      FBroker.Connected := True;
      Result := FBroker.Connected;
    End
    Else
      Result := False;
    If Result Then
    Begin
      FBroker.CreateContext(Context);
    End;

  Except
    On e: Exception Do
    Begin
            //LogMsg('', e.Message);
      MagLogger.LogMsg('', e.Message); {JK 10/5/2009 - Maggmsgu refactoring}
      Result := False;
    End;
  End;
End;

Destructor TMagDBMVista.Destroy;
Begin
  FreeAndNil(FBroker); //RLM Fixing MemoryLeak 6/18/2010
  Inherited;
End;

Procedure TMagDBMVista.RPMaggImageDelete(Var Fstat: Boolean; Var Rmsg: String; Var Flist: TStrings;
                                          Ien, ForceDel: String; Reason: String = ''; GrpDelOK: Boolean = False);
var ienstr : string; // 135t7 for NoImage as 3rd piece.
Begin
  Fstat := False;
  Rmsg := '';
  Flist.Clear;
  ienstr := ien;
  //p135t7  new Magpiece, will handle cases when Ien already has 3 pieces example 444^^NOIMAGE
  { if ForceDel = '1', then force delete, don't test for MAG DELETE KEY }
  if (ForceDel <> '') then Ienstr := MagSetPiece(Ienstr,'^',2,ForceDel) ;
  FBroker.PARAM[0].Value := ienstr;
  FBroker.PARAM[0].PTYPE := LITERAL;
  FBroker.PARAM[1].Value := Magbooltostrint(GrpDelOK);
  FBroker.PARAM[1].PTYPE := LITERAL;
  FBroker.PARAM[2].Value := Reason;
  FBroker.PARAM[2].PTYPE := LITERAL;
  FBroker.REMOTEPROCEDURE := 'MAGG IMAGE DELETE';
  Try
    FBroker.LstCALL(Flist);

    If ((Flist[0] = '') Or (Flist.Count = 0)) Then
    Begin
      Rmsg := 'Attempt to Delete Image Entry Failed. Broker Error on Vista System';
      Flist.Insert(0, '0^' + Rmsg);
      Exit;
    End;
    If (MagPiece(Flist[0], '^', 1) = '0') Then
    Begin
      Rmsg := 'Attempt to Delete Image Entry Failed.';
      Flist.Insert(0, '0^' + Rmsg);
      Exit;
    End;
    Rmsg := 'Image Entry deleted: ' + Ien;
    Flist.Insert(0, '1^VistA Image Entry deleted: ' + Ien);
    Fstat := True;
  Except
    On e: Exception Do
    Begin
      Rmsg := MagPiece(e.Message, #$A, 2);
      Flist.Insert(0, '0^' + MagPiece(e.Message, #$A, 2));
    End;
  End; // try

End;

Procedure TMagDBMVista.RPMag3TIUImage(Var Fstat: Boolean; Var Flist: Tstringlist; Magien, TiuDA: String);
Begin
  Flist.Clear;
  Fstat := False;
  FBroker.REMOTEPROCEDURE := 'MAG3 TIU IMAGE';
  FBroker.PARAM[0].Value := Magien;
  FBroker.PARAM[0].PTYPE := LITERAL;
  FBroker.PARAM[1].Value := TiuDA;
  FBroker.PARAM[1].PTYPE := LITERAL;
  Try
    FBroker.Call;

    Flist.Assign(FBroker.Results);
    If ((MagPiece(Flist[0], '^', 1) = '') Or (MagPiece(Flist[0], '^', 1) = '0')) Then
    Begin
      Flist.Insert(0, '0^ERROR linking Image to TIU: ');
      Exit;
    End;
    Fstat := True;
  Except
    On e: Exception Do
    Begin
      Flist.Insert(0, '0^EXCEPTION:  linking Image to TIU:');
      Flist.Insert(1, '0^' + MagPiece(e.Message, #$A, 2));
    End;
  End;

End;

Procedure TMagDBMVista.RPMag4DataFromImportQueue(Var Fstat: Boolean; Var Flist: Tstringlist; QueueNum: String);
Begin
  Flist.Clear;
  Fstat := False;
  FBroker.PARAM[0].PTYPE := LITERAL;
  FBroker.PARAM[0].Value := QueueNum;
  FBroker.REMOTEPROCEDURE := 'MAG4 DATA FROM IMPORT QUEUE';
    // GETARR^MAGGSIUI
  Try
    FBroker.LstCALL(Flist);
    If (MagPiece(Flist[0], '^', 1) = '0') Then
      Exit;
    Fstat := True;
  Except
    On e: Exception Do
    Begin
            // magpiece(E.message, #$A, 3)
      Flist.Insert(0, '0^EXCEPTION: RPC RPMag4DataFromImportQueue.');
      Flist.Insert(1, MagPiece(e.Message, #$A, 1));
      Flist.Insert(2, MagPiece(e.Message, #$A, 2));
    End;
  End;
End;

Procedure TMagDBMVista.RPMag4RemoteImport(Var Fstat: Boolean; Var Flist: Tstringlist; DataArray: Tstringlist);
Var
  i: Integer;
Begin
  Fstat := False;
  FBroker.PARAM[0].PTYPE := List;
  FBroker.PARAM[0].Value := '.x';
  For i := 0 To DataArray.Count - 1 Do
    FBroker.PARAM[0].Mult['' + Inttostr(i) + ''] := DataArray[i];
  FBroker.REMOTEPROCEDURE := 'MAG4 REMOTE IMPORT';
  Try
    FBroker.LstCALL(Flist);
    If (MagPiece(Flist[0], '^', 1) = '0') Then
      Exit;
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

Procedure TMagDBMVista.RPMag4ValidateData(Var Fstat: Boolean;
  Var Flist: Tstringlist; t: Tstringlist; Rettype: String);
Var
  i: Integer;
Begin
  Fstat := False;
  FBroker.PARAM[0].PTYPE := List;
  FBroker.PARAM[0].Value := '.x';
  For i := 0 To t.Count - 1 Do
    FBroker.PARAM[0].Mult['' + Inttostr(i) + ''] := t[i];
  FBroker.PARAM[1].PTYPE := LITERAL;
  FBroker.PARAM[1].Value := Rettype;
  FBroker.REMOTEPROCEDURE := 'MAG4 VALIDATE DATA';
  Try
    FBroker.LstCALL(Flist);
    If (MagPiece(Flist[0], '^', 1) = '0') Then
      Exit;
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

Procedure TMagDBMVista.RPTIULongListOfTitles(Var Fstat: Boolean; Var Fmsg: String;
  Var Flist: TStrings; NoteClass, InputString: String; Mylist: Boolean = False);
Begin
  Fstat := False;
    //flist := Tstringlist.create;
    //inputstring := 'CP,NOTE,SUR,DS,CONS';
  FBroker.PARAM[0].Value := NoteClass + '|' + Uppercase(InputString);
  FBroker.PARAM[0].PTYPE := LITERAL;
  If Mylist Then
  Begin
    FBroker.PARAM[1].Value := '1';
    FBroker.PARAM[1].PTYPE := LITERAL;
  End;
  FBroker.REMOTEPROCEDURE := 'MAG3 TIU LONG LIST OF TITLES';
  Try
    FBroker.LstCALL(Flist); //          CallBrokerX;
    Fmsg := MagPiece(Flist[0], '^', 2);
    Fstat := Magstrtobool(MagPiece(Flist[0], '^', 1));
    Flist.Delete(0);
    If Fstat Then
      Fmsg := 'List of Note Titles received.';
  Except
    On e: Exception Do
    Begin
            // magpiece(E.message, #$A, 3)
             // winmsg(        Flist.insert(0, '0^' + magpiece(e.message, #$A, 2));
      Fmsg := 'Error: ' + MagPiece(e.Message, #$A, 2)
    End;
  End;
End;

Procedure TMagDBMVista.RPTIUCreateNote(Var Fstat: Boolean; Var Fmsg: String;
  DFN, Title, AdminClose, Mode, Esighash, Esigduz, Loc, Notedate, ConsltDA: String; Notetext: Tstringlist = Nil);
Var
  BrkRes: String;
  i: Integer;
Begin
    {       fmsg : string  =>  The new TIUDA is returned as a String }
  Fstat := False;
    //      winmsg('', 'Creating New Note ...');

  FBroker.PARAM[0].Value := DFN;
  FBroker.PARAM[0].PTYPE := LITERAL;
  FBroker.PARAM[1].Value := Title;
  FBroker.PARAM[1].PTYPE := LITERAL;
  FBroker.PARAM[2].Value := AdminClose;
  FBroker.PARAM[2].PTYPE := LITERAL;
    //////////////
  FBroker.PARAM[3].Value := Mode;
  FBroker.PARAM[3].PTYPE := LITERAL;
  FBroker.PARAM[4].Value := Esighash;
  FBroker.PARAM[4].PTYPE := LITERAL;
  FBroker.PARAM[5].Value := Esigduz;
  FBroker.PARAM[5].PTYPE := LITERAL;
  FBroker.PARAM[6].Value := Loc;
  FBroker.PARAM[6].PTYPE := LITERAL;
  FBroker.PARAM[7].Value := Notedate;
  FBroker.PARAM[7].PTYPE := LITERAL;
  FBroker.PARAM[8].Value := ConsltDA;
  FBroker.PARAM[8].PTYPE := LITERAL;
  If (Notetext <> Nil) And (Notetext.Count > 0) Then
  Begin
    For i := 0 To Notetext.Count - 1 Do
    Begin
            //dec(i);
      FBroker.PARAM[9].Mult[('"TEXT' + Copy('00000000', 1, 8 - Length(Inttostr(i))) + Inttostr(i) + '"')] := Notetext[i];
    End;
    FBroker.PARAM[9].PTYPE := List;
  End;

    //////////////
  FBroker.REMOTEPROCEDURE := 'MAG3 TIU NEW';
  LogRPCParams;
  Try
    BrkRes := FBroker.STRCALL; //          CallBrokerX; //xBrokerx.Call;
    LogRPCResult(BrkRes);
    If Strtoint(MagPiece(BrkRes, '^', 1)) > 0 Then
    Begin
      Fstat := True;
      Fmsg := MagPiece(BrkRes, '^', 1);
    End
    Else
      Fmsg := MagPiece(BrkRes, '^', 2);
        // winmsg('', 'New Note Created: '+title);
  Except
    On e: Exception Do
    Begin
            // magpiece(E.message, #$A, 3)
             // winmsg(        Flist.insert(0, '0^' + magpiece(e.message, #$A, 2));
      Fmsg := 'Error: ' + MagPiece(e.Message, #$A, 2)
    End;
  End;
End;

Function TMagDBMVista.RPTIUSignRecord(Var Fmsg: String; DFN, TiuDA, Hashesign: String): Boolean;
Begin
  Result := False;
    //winmsg('', 'Signing Note ...');
  FBroker.REMOTEPROCEDURE := 'MAG3 TIU SIGN RECORD';
  FBroker.PARAM[0].Value := DFN;
  FBroker.PARAM[0].PTYPE := LITERAL;
  FBroker.PARAM[1].Value := TiuDA;
  FBroker.PARAM[1].PTYPE := LITERAL;
  FBroker.PARAM[2].Value := Hashesign;
  FBroker.PARAM[2].PTYPE := LITERAL;
  Try
    Fmsg := FBroker.STRCALL; //          CallBrokerX;

    If Strtoint(MagPiece(Fmsg, '^', 1)) > 0 Then
    Begin
      Result := True;
      Fmsg := 'Note was Signed.';
    End
    Else
    Begin
      Fmsg := 'Error signing note : ' + MagPiece(Fmsg, '^', 2);
    End;
  Except
    On e: Exception Do
    Begin
            // magpiece(E.message, #$A, 3)
             // winmsg(        Flist.insert(0, '0^' + magpiece(e.message, #$A, 2));
      Fmsg := 'Error: ' + MagPiece(e.Message, #$A, 2)
    End;
  End;

End;

Procedure TMagDBMVista.RPTIUCreateAddendum(Var Fstat: Boolean; Var Fmsg: String;
  DFN, TiuDA, AdminClose, Mode, Esighash, Esigduz, Notedate: String; Notetext: Tstringlist = Nil);
Var
  BrkRes: String;
  i: Integer;
Begin
  Fstat := False;
  Fmsg := 'Attempting to Create an Addendum for : ' + TiuDA;
  FBroker.PARAM[0].Value := DFN;
  FBroker.PARAM[0].PTYPE := LITERAL;
  FBroker.PARAM[1].Value := TiuDA;
  FBroker.PARAM[1].PTYPE := LITERAL;
  FBroker.PARAM[2].Value := AdminClose;
  FBroker.PARAM[2].PTYPE := LITERAL;
    //////////////
  FBroker.PARAM[3].Value := Mode;
  FBroker.PARAM[3].PTYPE := LITERAL;
  FBroker.PARAM[4].Value := Esighash;
  FBroker.PARAM[4].PTYPE := LITERAL;
  FBroker.PARAM[5].Value := Esigduz;
  FBroker.PARAM[5].PTYPE := LITERAL;
  FBroker.PARAM[6].Value := Notedate;
  FBroker.PARAM[6].PTYPE := LITERAL;

  If (Notetext <> Nil) And (Notetext.Count > 0) Then
  Begin
    For i := 0 To Notetext.Count - 1 Do
    Begin
            //dec(i);
      FBroker.PARAM[7].Mult[('"TEXT' + Copy('00000000', 1, 8 - Length(Inttostr(i))) + Inttostr(i) + '"')] := Notetext[i];
    End;
    FBroker.PARAM[7].PTYPE := List;
  End;
    //////////////
  FBroker.REMOTEPROCEDURE := 'MAG3 TIU CREATE ADDENDUM';
  Try
    BrkRes := FBroker.STRCALL; //          CallBrokerX;
    Fmsg := MagPiece(BrkRes, '^', 2);
    If Strtoint(MagPiece(BrkRes, '^', 1)) > 0 Then
    Begin
      Fmsg := MagPiece(BrkRes, '^', 1); // the new TIUDA of the Addendum
      Fstat := True;
    End
    Else
    Begin
      Fmsg := 'ADDENDUM NOT Created. ' + BrkRes;
    End;
  Except
    On e: Exception Do
    Begin
            // magpiece(E.message, #$A, 3)
             // winmsg(        Flist.insert(0, '0^' + magpiece(e.message, #$A, 2));
      Fmsg := 'Error: ' + MagPiece(e.Message, #$A, 2)
    End;
  End;
End;

Procedure TMagDBMVista.RPTIUModifyNote(Var Fstat: Boolean; Var Fmsg: String;
  DFN, TiuDA, AdminClose, Mode, Esighash, Esigduz: String; Notetext: Tstringlist = Nil);
Var
  BrkRes: String;
  i: Integer;
Begin
  Fstat := False;
  Fmsg := 'Attempting to Modify Data for : ' + TiuDA;
  FBroker.PARAM[0].Value := DFN;
  FBroker.PARAM[0].PTYPE := LITERAL;
  FBroker.PARAM[1].Value := TiuDA;
  FBroker.PARAM[1].PTYPE := LITERAL;
  FBroker.PARAM[2].Value := AdminClose;
  FBroker.PARAM[2].PTYPE := LITERAL;
    //////////////
  FBroker.PARAM[3].Value := Mode;
  FBroker.PARAM[3].PTYPE := LITERAL;
  FBroker.PARAM[4].Value := Esighash;
  FBroker.PARAM[4].PTYPE := LITERAL;
  FBroker.PARAM[5].Value := Esigduz;
  FBroker.PARAM[5].PTYPE := LITERAL;
  If (Notetext <> Nil) And (Notetext.Count > 0) Then
  Begin
    For i := 0 To Notetext.Count - 1 Do
    Begin
            //dec(i);
      FBroker.PARAM[6].Mult[('"TEXT' + Copy('00000000', 1, 8 - Length(Inttostr(i))) + Inttostr(i) + '"')] := Notetext[i];
    End;
    FBroker.PARAM[6].PTYPE := List;
  End;
    //////////////
  FBroker.REMOTEPROCEDURE := 'MAG3 TIU MODIFY NOTE';
  Try
    BrkRes := FBroker.STRCALL; //          CallBrokerX;
    Fmsg := MagPiece(BrkRes, '^', 2);
    If Strtoint(MagPiece(BrkRes, '^', 1)) > 0 Then
    Begin
      Fmsg := MagPiece(BrkRes, '^', 1); // the new TIUDA of the Addendum
      Fstat := True;
    End
    Else
    Begin
      Fmsg := 'Error modifying status of Note. ' + BrkRes;
    End;
  Except
    On e: Exception Do
    Begin
            // magpiece(E.message, #$A, 3)
             // winmsg(        Flist.insert(0, '0^' + magpiece(e.message, #$A, 2));
      Fmsg := 'Error: ' + MagPiece(e.Message, #$A, 2)
    End;
  End;
End;

Procedure TMagDBMVista.RPMag4StatusCallback(t: TStrings; cb: String; DoStatusCB: Boolean = True);
Var
  i: Integer;
Begin
  If (cb = '') Then
    Exit;
  FBroker.PARAM[0].PTYPE := List;
  FBroker.PARAM[0].Value := '.X';
    //FLoglist.insert(0,xmsg);
    //FLogList.insert(1,FTrkNum);
    //FLogList.insert(2,Qnum);
  For i := 0 To t.Count - 1 Do
    FBroker.PARAM[0].Mult['' + Inttostr(i) + ''] := t[i];
  FBroker.PARAM[1].PTYPE := LITERAL;
  FBroker.PARAM[1].Value := cb;
  FBroker.PARAM[2].PTYPE := LITERAL;
  FBroker.PARAM[2].Value := Magbooltostrint(DoStatusCB);
  FBroker.REMOTEPROCEDURE := 'MAG4 STATUS CALLBACK';
    //MAG4 STATUS CALLBACK          STATUSCB^MAGGSIUI
    //STATUSCB(MAGRY,STATARR,TAGRTN)
    //        D @(TAGRTN_"(.STATARR)")
  Try
    FBroker.Call;
  Except
        //
  End;
End;

Procedure TMagDBMVista.RPMag4AddImage(Var Fstat: Boolean; Var Flist: Tstringlist; t: Tstringlist);
Var
  i: Integer;
Begin
  Flist.Clear;
  Fstat := False;
  FBroker.PARAM[0].PTYPE := List;
  FBroker.PARAM[0].Value := '.x';
  For i := 0 To t.Count - 1 Do
    FBroker.PARAM[0].Mult['' + Inttostr(i) + ''] := t[i];
    //Fbroker.Param[1].Ptype := literal;
    //Fbroker.Param[1].value := '1';
  FBroker.REMOTEPROCEDURE := 'MAG4 ADD IMAGE';
  Try
    FBroker.LstCALL(Flist);
    If (MagPiece(Flist[0], '^', 1) = '0') Then
      Exit;
    Fstat := True;
  Except
    On e: Exception Do
    Begin
      Flist.Insert(0, '0^' + MagPiece(e.Message, #$A, 2));
    End;
  End;
End;

Procedure TMagDBMVista.RPMagABSJB(Var Fstat: Boolean; Var Flist: Tstringlist; CreatAbsIEN, JBCopyIEN: String);
Begin
  FBroker.PARAM[0].Value := CreatAbsIEN + '^' + JBCopyIEN;
  FBroker.PARAM[0].PTYPE := LITERAL;
  FBroker.REMOTEPROCEDURE := 'MAG ABSJB';
  Try
    FBroker.Call;
    Fstat := True;
  Except
    On e: Exception Do
    Begin
      Flist.Add('0^' + MagPiece(e.Message, #$A, 2));
      Fstat := False;
    End;
  End;
End;

Function TMagDBMVista.GetBroker: TRPCBroker;
Begin
  Result := FBroker;
End;

Procedure TMagDBMVista.SetBroker(Const Value: TRPCBroker);
Begin
  FBroker := Value;
End;

Function TMagDBMVista.GetSilentCodes(Vserver, Vport: String; Var SilentAccess: String; Var SilentVerify: String): Boolean;
Var
  t: TStrings;
Var
  i: Integer;
  VFile: String;
Begin
  VFile := 'c:\dev\MySAVC.avc';
  Result := False;
    ////exit; {doesn't work with RIV}
  If Not FileExists(VFile) Then
    Exit;
  t := Tstringlist.Create;
  Try
    t.LoadFromFile(VFile);
    For i := 0 To t.Count - 1 Do
    Begin
      If (Pos(Vserver + ',' + Vport, t[i]) > 0) Then
      Begin
        SilentAccess := MagPiece(t[i], '^', 2);
        SilentVerify := MagPiece(t[i], '^', 3);
        Result := True;
      End;
    End;
  Finally
    t.Free;
  End;
End;

Procedure TMagDBMVista.RPMag4IAPIStats(Var Fstat: Boolean;
  Var Flist: TStrings; DtStart, DtEnd: String);
Begin
  Fstat := False;
  FBroker.PARAM[0].PTYPE := LITERAL;
  FBroker.PARAM[0].Value := DtStart;
  FBroker.PARAM[1].PTYPE := LITERAL;
  FBroker.PARAM[1].Value := DtEnd;
    //Fbroker.Param[2].Ptype := literal;
    //Fbroker.Param[2].value := rettype;
  FBroker.REMOTEPROCEDURE := 'MAG4 IAPI STATS';
  Try
    FBroker.LstCALL(Flist);
    If (MagPiece(Flist[0], '^', 1) = '0') Then
      Exit;
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

(*procedure TMagDBMVista.RPMag4PostProcessing(var Fstat: boolean;
  var Flist: tstringlist; Magien: string);
begin
  Fstat := false;
  Fbroker.Param[0].PType := literal;
  Fbroker.Param[0].Value := Magien;
  Fbroker.remoteprocedure := 'MAG4 POST PROCESSING';
  try
    Fbroker.lstCall(Flist);
    if (magpiece(Flist[0], '^', 1) = '0') then exit;
    Fstat := true;
  except
    on E: EXCEPTION do
      begin
      // magpiece(E.message, #$A, 3)
        Flist.insert(0, '0^' + magpiece(e.message, #$A, 2));
        exit;
      end;
  end;

end;
  *)

Procedure TMagDBMVista.RPMag3LookupAny(Var Fstat: Boolean; Var Fmsg: String; Var Flist: Tstringlist; InputString: String; Data: String = '');
Begin
  Fstat := False;
  FBroker.PARAM[0].PTYPE := LITERAL;
  FBroker.PARAM[0].Value := InputString;
  If Data <> '' Then
    FBroker.PARAM[1].PTYPE := LITERAL;
  FBroker.PARAM[1].Value := Data;
  FBroker.REMOTEPROCEDURE := 'MAG3 LOOKUP ANY';
  Try
    LogRPCParams;
    FBroker.LstCALL(Flist);
    LogRPCResult(Flist);
    If (MagPiece(Flist[0], '^', 1) = '0') Then
    Begin
      Fmsg := MagPiece(Flist[0], '^', 2);
      Exit;
    End;
    Fstat := True;
        //  flist.delete(0);
  Except
    On e: Exception Do
    Begin
      LogRPCException(e.Message);
            // magpiece(E.message, #$A, 3)
      Flist.Insert(0, e.Message);
      Fmsg := e.Message;
      Exit;
    End;
  End;

End;

{  Generic Lookup call using LIST^DIC(, , ,  ,) }
{     LIST(MAGRY,FILE,START,NUM,CR,FLAGS,DATA)	;RPC [MAG3 LIST ANY]}

Procedure TMagDBMVista.RPMag3ListAny(Var Fstat: Boolean; Var Fmsg: String; Var Flist: TStrings;
  VFile, VStart, VFlags: String; VNum: String = '50';
  VCR: String = 'B';
  VData: String = '');
Begin
  Fstat := False;
  FBroker.PARAM[0].PTYPE := LITERAL;
  FBroker.PARAM[0].Value := VFile;
  FBroker.PARAM[1].PTYPE := LITERAL;
  FBroker.PARAM[1].Value := VStart;
  FBroker.PARAM[2].PTYPE := LITERAL;
  FBroker.PARAM[2].Value := VFlags;
  FBroker.PARAM[3].PTYPE := LITERAL;
    {
    Fbroker.Param[3].Value := vNum;
    Fbroker.Param[4].PType := literal;
    Fbroker.Param[4].Value := vCr;
    Fbroker.Param[5].PType := literal;
    Fbroker.Param[5].Value := vData;
     }

  FBroker.REMOTEPROCEDURE := 'MAG3 LIST ANY';
  Try
    FBroker.LstCALL(Flist);
    If (MagPiece(Flist[0], '^', 1) = '0') Then
    Begin
      Fmsg := MagPiece(Flist[0], '^', 2);
      Exit;
    End;
    Fstat := True;
        //  flist.delete(0);
  Except
    On e: Exception Do
    Begin
            // magpiece(E.message, #$A, 3)
      Flist.Insert(0, e.Message);
      Fmsg := e.Message;
      Exit;
    End;
  End;

End;

Procedure TMagDBMVista.RPMag4PostProcessActions(Var Fstat: Boolean;
  Var Flist: Tstringlist; Magien: String);
Begin
  Fstat := False;
  FBroker.PARAM[0].PTYPE := LITERAL;
  FBroker.PARAM[0].Value := Magien;
  FBroker.REMOTEPROCEDURE := 'MAG4 POST PROCESS ACTIONS';
  Try
    FBroker.LstCALL(Flist);
    If (MagPiece(Flist[0], '^', 1) = '0') Then
      Exit;
    Fstat := True;
  Except
    On e: Exception Do
    Begin
            // magpiece(E.message, #$A, 3)
      Flist.Insert(0, e.Message);
      Exit;
    End;
  End;

End;

{/ P117 - JK 10/5/2010 - Added 5th Parameter to support Deleted Image Placeholder counts/}
Procedure TMagDBMVista.RPMagPatInfo(Var Fstat: Boolean; Var Fstring: String; MagDFN: String; IsIcn: Boolean = False; IncDeletedCount: Boolean = False);
Var
  Data: String;
    //  RemoteDUZ : String;
    //  RemoteMAGWINDOWS : String;
  UserSSN: String;
  RemoteResult: Boolean;
  SiteCodes: String;
  i: Integer;
  RemoteCount: Integer;
  PatientData: String;
  LocalCount: Integer;
  TreatingList: Tstringlist;
  RemoteSiteCount: Integer;
  RemoteStatus: Boolean;
  IncludeDeletedImagesFlag: String;  {/ P117 - JK 10/5/2010 /}
Begin
    {RIV all Image Site}
    {
      ;   DATA:  MAGDFN ^ NOLOG ^ ISICN
      ;      MAGDFN -- Patient DFN
      ;      NOLOG  -- 0/1; if 1, then do NOT update the Session log
      ;      ISICN  -- 0/1  if 1, then this is an ICN, if 0 (default) this is a DFN ; Patch 41
      ;  MAGRY is a string, we return the following :
      ; //$P     1        2      3     4     5     6     7     8        9                     10
      ; //    status ^   DFN ^ name ^ sex ^ DOB ^ SSN ^ S/C ^ TYPE ^ Veteran(y/n)  ^ Patient Image Count
      ; //$P    11            12              13
      ;        ICN       SITE Number   ^ Production Account 1/0
    }

  {/ P117 - JK 10/5/2010 /}
  if IncDeletedCount then
    IncludeDeletedImagesFlag := 'D'
  else
    IncludeDeletedImagesFlag := '';

  Data := MagDFN + '^^' + Magbooltostrint(IsIcn) + '^' + IncludeDeletedImagesFlag;  {/ P117 - JK 10/5/2010 /}
  Fstat := False;
  FBroker.PARAM[0].PTYPE := LITERAL;
  FBroker.PARAM[0].Value := Data;
  FBroker.REMOTEPROCEDURE := 'MAGG PAT INFO';
  Try
    Fstring := FBroker.STRCALL;
    If (MagPiece(Fstring, '^', 1) = '0') Then
      Exit;
    Fstat := True;
  Except
    On e: Exception Do
    Begin
            // magpiece(E.message, #$A, 3)
      Fstring := '0^' + MagPiece(e.Message, #$A, 2);
      Exit;
    End;
  End;

    // JMW 4/18/2005 p45
    // check to see that the RemoteBrokerManager was initialized, in Capture it is not so the RIV items should not be executed.
  If MagRemoteBrokerManager1 = Nil Then
  Begin
    Exit;
  End;

  If (IsIcn) Then //46
    MagDFN := MagPiece(Fstring, '^', 2); //46
  MagRemoteBrokerManager1.SetPatientLocalDFN(MagDFN); //46
    // JMW 2/23/2005 p45
  If MagRemoteBrokerManager1.GetUserSSN() = '' Then
  Begin
    FBroker.REMOTEPROCEDURE := 'XWB GET VARIABLE VALUE';
    FBroker.PARAM[0].Value := '^VA(200,' + FBroker.User.Duz + ',1)';
    FBroker.PARAM[0].PTYPE := Reference;
    UserSSN := FBroker.STRCALL;
    UserSSN := MagPiece(UserSSN, '^', 9);
    MagRemoteBrokerManager1.SetUserSSN(UserSSN);
  End;

  If MagRemoteBrokerManager1.GetUserLocalDUZ() = '' Then
    MagRemoteBrokerManager1.SetUserLocalDUZ(FBroker.User.Duz);
  If MagRemoteBrokerManager1.GetUserFullName() = '' Then
    MagRemoteBrokerManager1.SetUserFullName(FBroker.User.Name);

  FBroker.REMOTEPROCEDURE := 'VAFCTFU GET TREATING LIST';
  FBroker.PARAM[0].Value := MagDFN;
  FBroker.PARAM[0].PTYPE := LITERAL;
  FBroker.Call;

  If MagPiece(FBroker.Results.Strings[0], '^', 1) = '-1' Then
  Begin
        //LogMsg('s', 'DFN:' + MagDFN + ' Patient does not have any images at any remote sites ' + formatdatetime('mm/dd/yy@hh:nn:ss.zzz', now));
    MagLogger.LogMsg('s', 'DFN:' + MagDFN + ' Patient does not have any images at any remote sites ' +
      Formatdatetime('mm/dd/yy@hh:nn:ss.zzz', Now)); {JK 10/5/2009 - Maggmsgu refactoring}
    MagRemoteBrokerManager1.ClearActiveRemoteBrokers();
        // this patient doesn't have any remote sites visited, nothing to do!
  End
  Else
  Begin
        // this patient has at least 1 remote site visited.

        //LogMsg('s', 'Patient has been seen at the following facilities [' + fbroker.Results.Text + ']', MagLogInfo);
    MagLogger.LogMsg('s', 'Patient has been seen at the following facilities [' + FBroker.Results.Text + ']', MagLogINFO); {JK 10/5/2009 - Maggmsgu refactoring}
        // convert the list to a string list (if the TREATING FACILITY RPC has wordwrap off it is one long string instead of a proper list)
    MagRemoteBrokerManager.ConvertTreatingFacilityList(FBroker.Results, TreatingList);

    RemoteSiteCount := 0;
        //    LogMsg('s', 'DFN:' + MagDFN + ' Patient has images at [' + inttostr(TreatingList.count) + '] remote site(s) ' + formatdatetime('mm/dd/yy@hh:nn:ss.zzz', now));
    For i := 0 To TreatingList.Count - 1 Do
    Begin
            //LocalUserStationNumber put in 46
            // JMW 1/22/2010 P94T6 - also compare to primary site station number incase
            // the user logged into a non primary division
      If (MagPiece(TreatingList.Strings[i], '^', 1) <> LocalUserStationNumber)
        And (MagPiece(TreatingList.Strings[i], '^', 1) <> PrimarySiteStationNumber) Then
                // JMW 7/22/2005 p45t5 Changed to compare on station number, not IEN (for Anchorage)
                //      if magpiece(TreatingList.Strings[i], '^', 1) <> MagPiece(wrksInst, '^', 1) then
      Begin
        RemoteSiteCount := RemoteSiteCount + 1;
        SiteCodes := '^' + MagPiece(TreatingList.Strings[i], '^', 1) + SiteCodes;
      End;
    End;
        //LogMsg('s', 'DFN:' + MagDFN + ' Patient has images at [' + inttostr(RemoteSiteCount) + '] remote site(s) ' + formatdatetime('mm/dd/yy@hh:nn:ss.zzz',
        //    now));
    MagLogger.LogMsg('s', 'DFN:' + MagDFN + ' Patient has images at [' + Inttostr(RemoteSiteCount) + '] remote site(s) ' +
      Formatdatetime('mm/dd/yy@hh:nn:ss.zzz', Now)); {JK 10/5/2009 - Maggmsgu refactoring}
    If RemoteSiteCount > 0 Then
    Begin

      RemoteResult := MagRemoteBrokerManager1.CreateBrokerFromSiteCodes(SiteCodes, TreatingList);
      If Not RemoteResult Then
      Begin
                //      showMessage('there was an error connecting to the remote broker');
      End;
    End
    Else
    Begin
            //LogMsg('s', 'DFN:' + MagDFN + ' Patient does not have any images at any remote sites ' + formatdatetime('mm/dd/yy@hh:nn:ss.zzz', now));
      MagLogger.LogMsg('s', 'DFN:' + MagDFN + ' Patient does not have any images at any remote sites ' +
        Formatdatetime('mm/dd/yy@hh:nn:ss.zzz', Now)); {JK 10/5/2009 - Maggmsgu refactoring}
      MagRemoteBrokerManager1.ClearActiveRemoteBrokers();
    End;
  End;

  FreeAndNil(TreatingList);

    // add code to get the ICN from the DFN

  FBroker.REMOTEPROCEDURE := 'VAFCTFU CONVERT DFN TO ICN';
  FBroker.PARAM[0].Value := MagDFN;
  FBroker.PARAM[0].PTYPE := LITERAL;
  FBroker.Call;

  MagRemoteBrokerManager1.SetPatientICN(FBroker.Results[0]);

    //LogMsg('', 'Determining DFN at each Remote Site... ' + formatdatetime('mm/dd/yy@hh:nn:ss.zzz', now));
  MagLogger.LogMsg('', 'Determining DFN at each Remote Site... ' + Formatdatetime('mm/dd/yy@hh:nn:ss.zzz', Now)); {JK 10/5/2009 - Maggmsgu refactoring}
  MagRemoteBrokerManager1.SetRemoteDFN();

    // Determine here if the patient is marked sensitive at any remote site

  MagRemoteBrokerManager1.CheckPatientSensitive();

    //LogMsg('', 'Counting images at each Remote Site... ' + formatdatetime('mm/dd/yy@hh:nn:ss.zzz', now));
  MagLogger.LogMsg('', 'Counting images at each Remote Site... ' +
    Formatdatetime('mm/dd/yy@hh:nn:ss.zzz', Now)); {JK 10/5/2009 - Maggmsgu refactoring}

  RemoteCount := MagRemoteBrokerManager1.GetRemoteActiveImageCount(); //46
    // call RPC to set the local DFN from the ICN
  LocalCount := Strtoint(MagPiece(Fstring, '^', 10));
  If RemoteCount > 0 Then
  Begin
        {   JMW 6/22/2005 p45 update code to correctly change the image count.
            p59 adds new data to this result so we have to be sure to change the 10th field}
    Fstring := MagSetPiece(Fstring, '^', 10, Inttostr(LocalCount + RemoteCount));
  End;

  RemoteStatus := MagRemoteBrokerManager1.DoneMakingConnections(MagDFN); //46
End;

(*procedure TMagDBMVista.RPMagIndexType(var Fstat: boolean; var Flist: tstringlist; MagDFN: string);
begin
  Fstat := false;
  Fbroker.Param[0].PType := literal;
  Fbroker.Param[0].Value := MagDFN;
  Fbroker.remoteprocedure := 'MAG4 INDEX GET TYPE';
  try
    Fbroker.lstCall(Flist);
    if (magpiece(Flist[0], '^', 1) = '0') then exit;
    Fstat := true;
  except
    on E: EXCEPTION do
      begin
      // magpiece(E.message, #$A, 3)
        Flist.insert(0, '0^' + magpiece(e.message, #$A, 2));
        exit;
      end;
  end;

end;
  *)

Procedure TMagDBMVista.RPIndexGetSpecSubSpec(Lit: TStrings; Cls: String = ''; Proc: String = '';
  IgnoreStatus: Boolean = False;
  IncClass: Boolean = False;
  IncStatus: Boolean = False;
  IncSpec: Boolean = False);
Var
  t: TStrings;
  Flags: String;
Begin
  Lit.Clear;
  t := Tstringlist.Create;
    // We changed the value of the Constants magiclAdmin, and magiclClin
    // so this isn't needed. (we'll see)
    //if cls = magiclAdmin then cls :="ADMIN,ADMIN/CLIN";
    //if cls = magiclClin then cls :="CLIN,CLIN/ADMIN";
  FBroker.REMOTEPROCEDURE := 'MAG4 INDEX GET SPECIALTY';
  FBroker.PARAM[0].PTYPE := LITERAL;
  FBroker.PARAM[0].Value := Cls;
  FBroker.PARAM[1].PTYPE := LITERAL;
  FBroker.PARAM[1].Value := Proc;
    { for P45 we make this call to older Versions of KIDS. That will cause a
    problem because they won't be able to handle more parameters in the RPC Call}
    { So we send one parameter (old clients expect one, and parse it in M for the
      new parameters.}

  (*  FBroker.Param[2].PType := literal;
    FBroker.Param[2].Value := magbooltostrint(ignorestatus);
    FBroker.Param[3].PType := literal;
    FBroker.Param[3].Value := magbooltostrint(incClass);
    FBroker.Param[4].PType := literal;
    FBroker.Param[4].Value := magbooltostrint(incStatus);
    FBroker.Param[5].PType := literal;
    FBroker.Param[5].Value := magbooltostrint(incSpec);
    *)
  Flags := Magbooltostrint(IgnoreStatus) + '^'
    + Magbooltostrint(IncClass) + '^'
    + Magbooltostrint(IncStatus) + '^'
    + Magbooltostrint(IncSpec) + '^';
  FBroker.PARAM[2].PTYPE := LITERAL;
  FBroker.PARAM[2].Value := Flags;

  Try
    FBroker.LstCALL(t);
{$IFDEF DEMO CREATE}
        //MagDemoIndexSpec
    t.SaveToFile(ExtractFilePath(Application.ExeName) + '\image\MagDemoIndexSpec.txt');
{$ENDIF}

    If (t.Count = 0) Then
    Begin
      Lit.Add('<Error loading ''Specialty'' list>');
            //oot 6/18/02 LogMsg('', 'Error loading Index Specialty', nullpanel);
      Exit;
    End;

  Except
    On e: Exception Do
    Begin
      Lit.Add('<Exception loading ''Specialty'' list>');
            //oot 6/18/02      LogMsg('', 'Exception loading Index Specialty', nullpanel);
      Exit;
    End;
  End;
  t.Delete(0);
  Lit.AddStrings(t);
  t.Free;
End;

Procedure TMagDBMVista.RPIndexGetEvent(Lit: TStrings; Cls: String = ''; Spec: String = '';
  IgnoreStatus: Boolean = False;
  IncClass: Boolean = False;
  IncStatus: Boolean = False);
Var
  t: TStrings;
  Flags: String;
Begin
  Lit.Clear;
  t := Tstringlist.Create;
    // We changed the value of the Constants magiclAdmin, and magiclClin
    // so this isn't needed. (we'll see)
    //if cls = magiclAdmin then cls :="ADMIN,ADMIN/CLIN";
    //if cls = magiclClin then cls :="CLIN,CLIN/ADMIN";

  FBroker.REMOTEPROCEDURE := 'MAG4 INDEX GET EVENT';

  FBroker.PARAM[0].PTYPE := LITERAL;
  FBroker.PARAM[0].Value := Cls;
  FBroker.PARAM[1].PTYPE := LITERAL;
  FBroker.PARAM[1].Value := Spec;

    { for P45 we make this call to older Versions of KIDS. That will cause a
    problem because they won't be able to handle more parameters in the RPC Call}
    { So we send one parameter (old clients expect one, and parse it in M for the
      new parameters.}

  (*  FBroker.Param[2].PType := literal;
    FBroker.Param[2].Value := magbooltostrint(ignorestatus);
    FBroker.Param[3].PType := literal;
    FBroker.Param[3].Value := magbooltostrint(incClass);
    FBroker.Param[4].PType := literal;
    FBroker.Param[4].Value := magbooltostrint(incStatus); *)

  Flags := Magbooltostrint(IgnoreStatus) + '^'
    + Magbooltostrint(IncClass) + '^'
    + Magbooltostrint(IncStatus) + '^';
  FBroker.PARAM[2].PTYPE := LITERAL;
  FBroker.PARAM[2].Value := Flags;

  Try
    FBroker.LstCALL(t);
{$IFDEF DEMO CREATE}
        //    MagDemoIndexEvent
    t.SaveToFile(ExtractFilePath(Application.ExeName) + '\image\MagDemoIndexEvent.txt');
{$ENDIF}
    If (t.Count = 0) Then
    Begin
      Lit.Add('<Error loading ''Events'' list>');
            //oot 6/18/02    LogMsg('', 'Error loading Index Events', nullpanel);
      Exit;
    End;

  Except
    On e: Exception Do
    Begin
      Lit.Add('<Exception loading ''Events'' list>');
            //oot 6/18/02 LogMsg('', 'Exception loading Index Events', nullpanel);
      Exit;
    End;
  End;
  t.Delete(0);
  Lit.AddStrings(t);
  t.Free;
End;

{/ JK 11/24/2009 - P108 New Method to retrieve the list of Origins /}
procedure TMagDBMVista.RPIndexGetOrigin(Lit: TStrings);
var
  T: TStrings;
  XMsg: String;
  Flags: String;
begin
  if not CheckDBConnection(XMsg) then
    raise Exception.Create(XMsg);
  Lit.Clear;
  T := TStringlist.Create;

  FBroker.RemoteProcedure := 'MAG4 INDEX GET ORIGIN';
  try
    FBroker.LstCall(T);
    {$IFDEF DEMO CREATE}
      T.SaveToFile(ExtractFilepath(Application.Exename) + '\image\MagDemoIndexOrigin.txt');
    {$ENDIF}

    if (T.Count = 0) then
    begin
      Lit.add('0^Error loading ''Origin'' list');
      //-Lit.Add('<Error loading ''Origin'' list>');
      Exit;
    end;

  except
    on E:Exception do
    begin
      lit.Add('0^Exception loading ''Origin'' list. Msg = ' + E.Message);
      //-Lit.Add('<Exception loading ''Origin'' list>');
      Exit;
    end;
  end;

//  T.Delete(0);
  Lit.AddStrings(T);
  T.Free;
end;


Procedure TMagDBMVista.RPIndexGetType(Lit: TStrings; Cls: String;
  IgnoreStatus: Boolean = False;
  IncClass: Boolean = False;
  IncStatus: Boolean = False);
Var
  t: TStrings;
  Xmsg: String;
  Flags: String;
Begin
  If Not CheckDBConnection(Xmsg) Then
    Raise Exception.Create(Xmsg);
  Lit.Clear;
  t := Tstringlist.Create;
    // We changed the value of the Constants magiclAdmin, and magiclClin
    // so this isn't needed. (we'll see)
    //if cls = magiclAdmin then cls :="ADMIN,ADMIN/CLIN";
    //if cls = magiclClin then cls :="CLIN,CLIN/ADMIN";
  FBroker.REMOTEPROCEDURE := 'MAG4 INDEX GET TYPE';
  FBroker.PARAM[0].PTYPE := LITERAL;
  FBroker.PARAM[0].Value := Uppercase(Cls);
    { for P45 we make this call to older Versions of KIDS. That will cause a
    problem because they won't be able to handle more parameters in the RPC Call}
    { So we send one parameter (old clients expect one, and parse it in M for the
      new parameters.}
    (*FBroker.Param[1].PType := literal;
    FBroker.Param[1].Value := magbooltostrint(ignorestatus);
    FBroker.Param[2].PType := literal;
    FBroker.Param[2].Value := magbooltostrint(incClass);
    FBroker.Param[3].PType := literal;
    FBroker.Param[3].Value := magbooltostrint(incStatus);*)

  Flags := Magbooltostrint(IgnoreStatus) + '^'
    + Magbooltostrint(IncClass) + '^'
    + Magbooltostrint(IncStatus) + '^';
  FBroker.PARAM[1].PTYPE := LITERAL;
  FBroker.PARAM[1].Value := Flags;
  Try
    FBroker.LstCALL(t);
{$IFDEF DEMO CREATE}
        //MagDemoIndexType+(class)
    t.SaveToFile(ExtractFilePath(Application.ExeName) + '\image\MagDemoIndexType' + MagPiece(Cls, ',', 1) + '.txt');
{$ENDIF}
    If (t.Count = 0) Then
    Begin
      Lit.Add('<Error loading ''Type'' list>');
            //oot 6/18/02       LogMsg('', 'Error loading Index Types', nullpanel);
      Exit;
    End;

  Except
    On e: Exception Do
    Begin
      Lit.Add('<Exception loading ''Type'' list>');
            //oot 6/18/02       LogMsg('', 'Exception loading Index Types', nullpanel);
      Exit;
    End;
  End;
  t.Delete(0);
  Lit.AddStrings(t);
  t.Free;
End;

Procedure TMagDBMVista.RPLogCopyAccess(s: String; IObj: TImageData;
  EventType: TMagImageAccessEventType);
Var
  Ret: String;
  RemoteBroker: IMagRemoteBroker;
  NewParameter, RemoteDFN: String;
Begin
  If ((IObj.ServerName = '') Or (IObj.ServerPort = 0) Or ((IObj.ServerName = FBroker.Server) And (IObj.ServerPort = FBroker.ListenerPort))) Then
  Begin

    FBroker.PARAM[0].PTYPE := LITERAL;
    FBroker.PARAM[0].Value := s;
    FBroker.REMOTEPROCEDURE := 'MAGGACTION LOG';
    Ret := FBroker.STRCALL;
        { TODO : This and other functions have to be able to log messages. }
        // if copy(ret, 1, 1) <> '1' then LogMsg('', 'Error logging action ' + magpiece(st, '^', 2), nilpanel);
  End
  Else
  Begin
        // get the remote DFN of the patient and set it in the paramter
    NewParameter := s;
    RemoteBroker := MagRemoteBrokerManager1.GetBroker(IObj.ServerName, IObj.ServerPort);
    If RemoteBroker = Nil Then
    Begin
      MagRemoteBrokerManager1.LogBrokerNotFoundError(IObj.ServerName, IObj.ServerPort, 'RPLogCopyAccess');
      Exit;
    End;
    RemoteDFN := MagRemoteBrokerManager1.GetRemoteDFN(IObj.ServerName, IObj.ServerPort);
        //   if magpiece(s, '^', 5) <> '' then NewParameter := magreplacestring(s, '^', 5, RemoteDFN);
    If MagPiece(s, '^', 5) <> '' Then
      NewParameter := MagSetPiece(s, '^', 5, RemoteDFN);

    RemoteBroker.LogCopyAccess(IObj, NewParameter, EventType);
        //    TRemoteBroker.param[0].ptype := literal;
        //    TRemoteBroker.param[0].value := NewParameter;
        //    TRemoteBroker.remoteprocedure := 'MAGGACTION LOG';
        //    ret := TRemoteBroker.STRCALL;
            { TODO : This and other functions have to be able to log messages. }
            // if copy(ret, 1, 1) <> '1' then LogMsg('', 'Error logging action ' + magpiece(st, '^', 2), nilpanel);

  End;
End;
// 01/21/03   msg => changed to xmsg  (msg is a function)

Function TMagDBMVista.RPXWBGetVariableValue(Value: String): String;
Begin
  FBroker.REMOTEPROCEDURE := 'XWB GET VARIABLE VALUE';
  FBroker.PARAM[0].Value := Value; // '^VA(200,' + Fbroker.User.DUZ + ',1)';
  FBroker.PARAM[0].PTYPE := Reference;
  Try
    Result := FBroker.STRCALL;
  Except
    Result := '';
  End;
End;

Function TMagDBMVista.RPVerifyEsig(Esig: String; Var Xmsg: String): Boolean;
Var
  s: String;
Begin
  Esig := Encrypt(Esig);
  FBroker.PARAM[0].PTYPE := LITERAL;
  FBroker.PARAM[0].Value := Esig;
  FBroker.REMOTEPROCEDURE := 'MAGG VERIFY ESIG';
  s := FBroker.STRCALL;
  Xmsg := MagPiece(s, '^', 2);
  Result := (Copy(s, 1, 1) <> '0');
End;

Procedure TMagDBMVista.RPMagGetUserPreferences(Var Fstat: Boolean;
  Var Rpcmsg: String; Xlist: Tstringlist; Code: String = '');
Begin
  Fstat := True;
  FBroker.REMOTEPROCEDURE := 'MAGGUPREFGET';
    //WinMsg('', 'Applying View preferences...');
  If Code <> '' Then
  Begin
    FBroker.PARAM[0].PTYPE := LITERAL;
    FBroker.PARAM[0].Value := Code;
  End;
  Try
    LogRPCParams;
    FBroker.LstCALL(Xlist);
{$IFDEF DEMO CREATE}
        //xMagDemoPref+(node)
    Xlist.SaveToFile(ExtractFilePath(Application.ExeName) + '\image\xMagDemoPref' + Code + '.txt');
{$ENDIF}
    LogRPCResult(Xlist);
    If Xlist.Count < 2 Then
    Begin
      Fstat := False;
      Rpcmsg := 'Can''t Access User Preferences. Using defaults.';
            //WinMsg('', 'Can''t Access View Preferences, using System defaults.');
            //messagebeep(0);
      Exit;
    End;
    Xlist.Delete(0);
  Except
    On e: Exception Do
    Begin
            // magpiece(E.message, #$A, 3)
      Rpcmsg := e.Message;
      Fstat := False;
    End;
  End;
End;

Procedure TMagDBMVista.RPMagSetUserPreferences(Var Fstat: Boolean; Var Rpcmsg: String; Xlist: TStrings);
Var
  i: Integer;
  Fld: String;
  Data: String;
Begin
  Fstat := True;
  If Not FBroker.Connected Then
  Begin

    Rpcmsg := 'Save User preferences canceled.  No connection to VistA.';
    Messagebeep(0);
    Exit;
  End;
    //LOGACTIONS('MAIN', 'SAVESETTINGS', DUZ);
  For i := 0 To Xlist.Count - 1 Do
  Begin
    Fld := MagPiece(Xlist[i], '|', 1);
    Data := MagPiece(Xlist[i], '|', 2);
    FBroker.PARAM[0].Mult['' + Fld + ''] := Data;
  End;
  FBroker.REMOTEPROCEDURE := 'MAGGUPREFSAVE';
  FBroker.PARAM[0].Value := '.X';
  FBroker.PARAM[0].PTYPE := List;

  Try
    LogRPCParams;
    FBroker.Call;
    LogRPCResult;
    If FBroker.Results[0] = '' Then
    Begin
      Fstat := False;
      Rpcmsg := 'The Attempt to save User Preferences Failed. Check VistA Error Log.';

      Exit;
    End;
    Rpcmsg := MagPiece(FBroker.Results[0], '^', 2);
  Except
    On e: EBrokerError Do
      //Showmessage('Error Communicating with VistA : ' + e.Message);
      //p106 rlm 20101229 CR640 "Title of Dialog box"
      MagLogger.MagMsg(
        'de',
        'Error Communicating with VistA : ' + e.Message,
        Nil);
    On e: Exception Do
      //Showmessage('An Error occured while connecting to VistA' + #13 + 'Setting were not saved.' + #13 + e.Message);
      //p106 rlm 20101229 CR640 "Title of Dialog box"
      MagLogger.MagMsg(
        'de',
        'An Error occured while connecting to VistA' + #13 + 'Setting were not saved.' + #13 + e.Message,
        Nil);
  Else
    //Showmessage('UnKnown Error while Saving Settings.');
    //p106 rlm 20101229 CR640 "Title of Dialog box"
    MagLogger.MagMsg(
      'de',
      'UnKnown Error while Saving Settings.',
      Nil);
  End;

End;

Procedure TMagDBMVista.RPMag4GetImageInfo(VIobj: TImageData; Var Flist: TStrings; DeletedImagePlaceholders: Boolean = False);
Var
  RemoteBroker: IMagRemoteBroker;
Begin
    // JMW p45
  If (VIobj.ServerName = FBroker.Server) And (VIobj.ServerPort = FBroker.ListenerPort) Then
  Begin
    FBroker.REMOTEPROCEDURE := 'MAG4 GET IMAGE INFO';
    FBroker.PARAM[0].PTYPE := LITERAL;
    FBroker.PARAM[0].Value := VIobj.Mag0;

    {/ P117 - JK 9/20/2010 /}

    if DeletedImagePlaceholders then
    begin
      FBroker.PARAM[1].ptype := literal;
      FBroker.PARAM[1].value := 'D';
    end
    else
    begin
      FBroker.PARAM[1].ptype := literal;
      FBroker.PARAM[1].value := '';
    end;
    Try
      FBroker.LstCALL(Flist);
      If Flist.Count = 0 Then
      Begin
        Flist.Add('Error: Accessing Image Information');
        Flist.Add('    for Image ID# ' + VIobj.Mag0);
        Exit;
      End;
    Except
      On e: Exception Do
      Begin
                // magpiece(E.message, #$A, 3)
        Flist.Insert(0, e.Message);
      End;
    End;
  End
  Else
  Begin
    RemoteBroker := MagRemoteBrokerManager1.GetBroker(VIobj.ServerName, VIobj.ServerPort);
    If RemoteBroker = Nil Then
    Begin
      MagRemoteBrokerManager1.LogBrokerNotFoundError(VIobj.ServerName, VIobj.ServerPort, 'RPMag4GetImageInfo');
      Flist.Insert(0, 'Error: Unable to access remote broker [' + VIobj.ServerName + ', ' + Inttostr(VIobj.ServerPort) + ']');
      Exit;
    End;
    Try
      RemoteBroker.GetImageInformation(VIobj, Flist);
      If Flist.Count = 0 Then
      Begin
        Flist.Add('Error: Accessing Image Information');
        Flist.Add('    for Image ID# ' + VIobj.Mag0);
        Exit;
      End;
    Except
      On e: Exception Do
      Begin
                // magpiece(E.message, #$A, 3)
        Flist.Insert(0, e.Message);
      End;
    End;
  End;

End;

Procedure TMagDBMVista.RPImageReport(Var Fstat: Boolean; Var Fmsg: String; Flist: TStrings; IObj: TImageData; NoQAcheck: Boolean = False);
Var
  RemoteBroker: IMagRemoteBroker;
  Res: TStrings;
Begin
  Flist.Clear;
  Fstat := False;

    // JMW p45
  If (IObj.ServerName = FBroker.Server) And (IObj.ServerPort = FBroker.ListenerPort) Then
  Begin

    FBroker.PARAM[0].Value := IObj.Mag0 + '^';
    FBroker.PARAM[0].PTYPE := LITERAL;
    FBroker.PARAM[1].Value := Magbooltostrint(NoQAcheck);
    FBroker.PARAM[1].PTYPE := LITERAL;
    FBroker.REMOTEPROCEDURE := 'MAGGRPT';
    Try
      FBroker.Call;
      If FBroker.Results.Count = 0 Then
      Begin
        Fmsg := 'Report Failed for Image ID #: ' + IObj.Mag0;
        Flist.Insert(0, '0^ERROR Building Image Report: ');
        Flist.Add(' Report Failed for Image ID #: ' + IObj.Mag0);
        Flist.Add('Check VISTA Error Log.');
        Exit;
      End;

      Flist.Assign(FBroker.Results);
      If (MagPiece(Flist[0], '^', 1) = '') Then
      Begin
        Fmsg := 'Report Failed for Image ID #: ' + IObj.Mag0;
        Flist.Insert(0, '0^ERROR Building Image Report: ');
        Exit;
      End;
      If (MagPiece(Flist[0], '^', 1) = '0') Then
      Begin
        Fmsg := MagPiece(Flist[0], '^', 2);
        Exit;
      End;
      Fmsg := MagPiece(Flist[0], '^', 2);
      Fstat := True;
    Except
      On e: Exception Do
      Begin
        Flist.Insert(0, '0^EXCEPTION Building Image Report:');
        Flist.Insert(1, '0^' + MagPiece(e.Message, #$A, 2));
      End;
    End;

  End {end of broker check}
  Else
  Begin
    RemoteBroker := MagRemoteBrokerManager1.GetBroker(IObj.ServerName, IObj.ServerPort);
    If RemoteBroker = Nil Then
    Begin
      MagRemoteBrokerManager1.LogBrokerNotFoundError(IObj.ServerName, IObj.ServerPort, 'RPImageReport');
      Fmsg := 'Report Failed for Image ID #: ' + IObj.Mag0;
      Flist.Insert(0, '0^ERROR: Unable to access remote broker [' + IObj.ServerName + ', ' + Inttostr(IObj.ServerPort) + ']');
      Exit;
    End;

    Try
      Res := RemoteBroker.Getreport(IObj);
      If Res.Count = 0 Then
      Begin
        Fmsg := 'Report Failed for Image ID #: ' + IObj.Mag0;
        Flist.Insert(0, '0^ERROR Building Image Report: ');
        Flist.Add(' Report Failed for Image ID #: ' + IObj.Mag0);
        Flist.Add('Check VISTA Error Log.');
        Exit;
      End;

      Flist.Assign(Res);
      If (MagPiece(Flist[0], '^', 1) = '') Then
      Begin
        Fmsg := 'Report Failed for Image ID #: ' + IObj.Mag0;
        Flist.Insert(0, '0^ERROR Building Image Report: ');
        Exit;
      End;
      If (MagPiece(Flist[0], '^', 1) = '0') Then
      Begin
        Fmsg := MagPiece(Flist[0], '^', 2);
        Exit;
      End;
      Fmsg := MagPiece(Flist[0], '^', 2);
      Fstat := True;
    Except
      On e: Exception Do
      Begin
        Flist.Insert(0, '0^EXCEPTION Building Image Report:');
        Flist.Insert(1, '0^' + MagPiece(e.Message, #$A, 2));
      End;
    End;
  End;

End;

(*procedure TMagDBMVista.RPMagGetImageReport(var Fstat: boolean; var Fmsg: string; Flist: tstrings; magien: string);
begin
  Flist.clear;
  Fstat := false;
  FBroker.Param[0].Value := magien + '^';
  FBroker.Param[0].PType := literal;
  Fbroker.remoteprocedure := 'MAGGRPT';
  //LogMsg('', 'Building Image Report...', nilpanel);
  //FBroker.lstcall(t);

  //Fbroker.remoteprocedure := 'MAG3 TIU IMAGE';
  //FBroker.Param[0].Value := magien;
  //FBroker.Param[0].PType := literal;
  //FBroker.Param[1].Value := TIUDA;
  //FBroker.Param[1].PType := literal;
  try
    FBroker.Call;
    if FBroker.Results.count = 0 then
      begin
        fmsg := 'Report Failed for Image ID #: ' + magien;
        Flist.insert(0, '0^ERROR Building Image Report: ');
        Flist.add(' Report Failed for Image ID #: ' + magien);
        Flist.Add('Check VISTA Error Log.');
      //LogMsg('DE', ': The Attempt to build the Image report Failed. Check VISTA Error Log.', nilpanel);
      //LogMsg('s', ' Report Failed for Image IEN: '+ien,nilpanel);
      //LogMsg('', '', nilpanel);
        exit;
      end;

    Flist.assign(FBroker.Results);
    if (magpiece(Flist[0], '^', 1) = '')
      then
      begin
        fmsg := 'Report Failed for Image ID #: ' + magien;
        Flist.insert(0, '0^ERROR Building Image Report: ');
        exit;
      end;
    if (magpiece(Flist[0], '^', 1) = '0')
      then
      begin
        fmsg := magpiece(Flist[0], '^', 2);
        exit;
      end;
    fmsg := magpiece(Flist[0], '^', 2);
    Fstat := true;
  except
    on E: EXCEPTION do
      begin
        Flist.insert(0, '0^EXCEPTION Building Image Report:');
        Flist.insert(1, '0^' + magpiece(e.message, #$A, 2));
      end;
  end;

end;  *)

Function TMagDBMVista.CheckDBConnection(Var Xmsg: String): Boolean;
Begin
  Result := True;
  If Not Assigned(FBroker) Then
  Begin
    Xmsg := 'You must Login to VistA to proceed.';
        // xmsg := 'DataBase Component isn''t assigned to a DataBase.'+#13+
        //            'An error in software has occured. Call IRM.';
    Result := False;
  End;
  If (Assigned(FBroker)) And (Not FBroker.Connected) Then
  Begin
    Xmsg := 'You must Login to VistA to proceed.';
    Result := False;
  End;
  If Not Result Then
    Messagedlg(Xmsg, MtWarning, [Mbok], 0);

End;

Function TMagDBMVista.RPMag4GetFileFormatInfo(Ext: String; Var Xmsg: String): Boolean;
Var
  t: TStrings;
Begin
  t := Tstringlist.Create;
  FBroker.REMOTEPROCEDURE := 'MAG4 GET FILE FORMAT INFO';
  FBroker.PARAM[0].PTYPE := LITERAL;
  FBroker.PARAM[0].Value := Ext;

  Try
    FBroker.LstCALL(t);
    If (t.Count = 0) Then
    Begin
      Result := False;
      Xmsg := 'Error Getting File Type info for ' + Ext;
      Exit;
    End;
    Xmsg := t[1];
    Result := True;
  Except
    On e: Exception Do
    Begin
      Result := False;
      Xmsg := 'Exception Getting File Type info for ' + Ext;
    End;
  End;

End;
///////////// started converting remainder of calls in frmMain
////////////  that called xBrokerx, to call MagDBBroker.

Procedure TMagDBMVista.RPMaggImageInfo(Var Rstat: Boolean; Var Rmsg: String; Var Rlist: TStrings; Ien: String; NoQAcheck: Boolean = False);
Begin
  Rstat := False;
  With FBroker Do
  Begin
    PARAM[0].Value := Ien;
    PARAM[0].PTYPE := LITERAL;
    PARAM[1].Value := Magbooltostrint(NoQAcheck);
    PARAM[1].PTYPE := LITERAL;
    FBroker.REMOTEPROCEDURE := 'MAGG IMAGE INFO';
  End;
  Try
    FBroker.LstCALL(Rlist);
    If (MagPiece(Rlist[0], '^', 1) = '0') Or (Rlist.Count = 0) Then
    Begin
      Rstat := False;
      If Rlist.Count > 0 Then
        Rmsg := MagPiece(Rlist[0], '^', 2)
      Else
        Rmsg := 'ERROR in VistA operation canceled.';
      Exit;
    End;
    Rstat := True;
    Rmsg := Rlist[0];
    Rlist.Delete(0);
    If Rlist.Count > 0 Then
      If Not IsServerPortInString(Rlist[0], 'MAGG IMAGE INFO') Then
        ResolveServerPort(Rlist, FBroker.Server, FBroker.ListenerPort);
  Except
    On e: Exception Do
    Begin
      Rlist.Insert(0, '0^ERROR (EXCEPTION) in VistA function.');
      Rstat := False;
      Rmsg := 'ERROR (EXCEPTION) in VistA function:' + e.Message;
      Rlist.Insert(1, '0^' + MagPiece(e.Message, #$A, 2));
    End;
  End;

End;

Procedure TMagDBMVista.RPMaggRadExams(Var Rstat: Boolean; Var Rmsg: String; Var Rlist: TStrings; DFN: String);
Begin
  Rstat := False;
  With FBroker Do
  Begin
    PARAM[0].Value := DFN + '^1';
    PARAM[0].PTYPE := LITERAL;
    FBroker.REMOTEPROCEDURE := 'MAGGRADLIST';
  End;
  Try
    FBroker.LstCALL(Rlist);
    If (MagPiece(Rlist[0], '^', 1) = '0') Or (Rlist.Count = 0) Then
    Begin
      If Rlist.Count > 0 Then
        Rmsg := MagPiece(Rlist[0], '^', 2)
      Else
        Rmsg := 'ERROR Compiling Rad Exam list.';
      Exit;
    End;
    Rstat := True;
    Rmsg := MagPiece(Rlist[0], '^', 2);
        // rlist.delete(0);
    If Strtoint(MagPiece(Rlist[0], '^', 1)) > 0 Then
      Rmsg := MagPiece(Rlist[0], '^', 1) + ' ' + Rmsg;

  Except
    On e: Exception Do
    Begin
      Rlist.Insert(0, '0^ERROR (EXCEPTION) in VistA function.');
      Rstat := False;
      Rmsg := 'ERROR (EXCEPTION) in VistA function:' + e.Message;
      Rlist.Insert(1, '0^' + MagPiece(e.Message, #$A, 2));
    End;
  End;
End;

//RPMaggCPRSRadExam(rstat,rmsg,rlist,cprsstring);

Procedure TMagDBMVista.RPMaggCPRSRadExam(Var Rstat: Boolean; Var Rmsg: String; Var Rlist: TStrings; CprsString: String);
Begin
  Rstat := False;
  With FBroker Do
  Begin
    PARAM[0].Value := CprsString;
    PARAM[0].PTYPE := LITERAL;
    FBroker.REMOTEPROCEDURE := 'MAGG CPRS RAD EXAM';
  End;
  Try
    FBroker.LstCALL(Rlist);
    If (MagPiece(Rlist[0], '^', 1) = '0') Or (Rlist.Count = 0) Then
    Begin
      Rstat := False;
      If Rlist.Count > 0 Then
        Rmsg := MagPiece(Rlist[0], '^', 2)
      Else
        Rmsg := 'ERROR in VistA operation canceled.';
      Exit;
    End;
    Rstat := True;
    Rmsg := MagPiece(Rlist[0], '^', 2);
        //rlist.delete(0);
    If Rlist.Count > 1 Then
      If Not IsServerPortInString(Rlist[1], 'MAGG CPRS RAD EXAM') Then
        ResolveServerPort(Rlist, FBroker.Server, FBroker.ListenerPort, 1);
  Except
    On e: Exception Do
    Begin
      Rlist.Insert(0, '0^ERROR (EXCEPTION) in VistA function.');
      Rstat := False;
      Rmsg := 'ERROR (EXCEPTION) in VistA function:' + e.Message;
      Rlist.Insert(1, '0^' + MagPiece(e.Message, #$A, 2));
    End;
  End;

End;

//RPMaggUser2(rstat,rmsg,rlist,WSID);

Procedure TMagDBMVista.RPMaggUser2(Var Rstat: Boolean; Var Rmsg: String; Var Rlist: TStrings; Wsid: String; pSess: TSession = Nil);
Begin
  Rstat := False;
  With FBroker Do
  Begin
    PARAM[0].Value := Wsid;
    PARAM[0].PTYPE := LITERAL;
    FBroker.REMOTEPROCEDURE := 'MAGGUSER2';
  End;
  Try
    LogRPCParams;
    FBroker.LstCALL(Rlist);
    LogRPCResult(Rlist);
{$IFDEF DEMO CREATE}

        //xMagDemoUser2
    Rlist.SaveToFile(ExtractFilePath(Application.ExeName) + '\image\xMagDemoUser2.txt');
{$ENDIF}

    If (MagPiece(Rlist[0], '^', 1) = '0') Or (Rlist.Count = 0) Then
    Begin
      Rstat := False;
      If Rlist.Count > 0 Then
        Rmsg := MagPiece(Rlist[0], '^', 2)
      Else
        Rmsg := 'ERROR in VistA operation canceled.';
      Exit;
    End;
    Rstat := True;
    Rmsg := MagPiece(Rlist[0], '^', 2);
    If pSess <> Nil Then
      SetGSession(Rlist, pSess);
        ////////rlist.delete(0);
  Except
    On e: Exception Do
    Begin
      Rlist.Insert(0, '0^ERROR (EXCEPTION) in VistA function.');
      Rstat := False;
      Rmsg := 'ERROR (EXCEPTION) in VistA function:' + e.Message;
      Rlist.Insert(1, '0^' + MagPiece(e.Message, #$A, 2));
    End;
  End;
End;

(*
xBrokerx.param[0].ptype := literal;
xBrokerx.param[0].value := WSID;
//RPMaggUser2(var Fstat: boolean; var Flist: tstringlist; CompName: string; var vServer: string; tPort: string);

xBrokerx.remoteprocedure := 'MAGGUSER2';
xBrokerx.call;
*)

Procedure TMagDBMVista.SetGSession(plist: TStrings; pSess: TSession);
Begin
    //
            {
            *  --------- Params --------- MAGGUSER2
            * literal	UNKNOWN_UNKnown
            *  --------- Results ---------
            0 * 1^
            1 * 1216^KIRIN,GARRETT EDWARD^GEK
            2 * vhamaster\vhaiswIU^'bAAj&&0+&
            3 * 1
            4 * 1^SLC^660^SALT LAKE CITY^1^660
            5 * 1^1.0T22
            6 * 0
            7 * IMGDEM01.MED.VA.GOV
            8 * 660
            9 * 660
            *  --------- End Results  --------- MAGGUSER2
            }

  pSess.WrksPlaceIEN := MagPiece(plist[4], '^', 1);
  pSess.WrksPlaceCODE := MagPiece(plist[4], '^', 2);
    { WrksInstID  was an '^' delimited 2 piece string. It was ID and Name,  so I made it a TmagIDName Type. }

  pSess.Wrksinst.ID := MagPiece(plist[4], '^', 3);
  pSess.Wrksinst.Name := MagPiece(plist[4], '^', 4);
  psess.WrksConsolidated := Magstrtobool(MagPiece(plist[4], '^', 5));
  pSess.WrksInstStationNumber := MagPiece(plist[4], '^', 6);
    {
    Display     GSess.WrksPlaceIEN := magpiece(rlist[4], '^', 1);
                GSess.WrksPlaceCode := magpiece(rlist[4], '^', 2);
                GSess.WrksInst := magpiece(rlist[4], '^', 3) + '^' + magpiece(rlist[4], '^', 4);
                //GSess.WrksConsolidated := magstrtobool(magpiece(rlist[4], '^', 5));

    Capture     GSess.WrksInstStationNumber := magpiece(loginrslt[4], '^', 6) ;
    }
End;

Procedure TMagDBMVista.RPMaggDGRPD(Var Rstat: Boolean; Var Rmsg: String; Var Rlist: Tstringlist; DFN: String);
Begin
  Rstat := False;
  With FBroker Do
  Begin
    PARAM[0].Value := DFN;
    PARAM[0].PTYPE := LITERAL;
    FBroker.REMOTEPROCEDURE := 'MAGGDGRPD';
  End;
  Try
    FBroker.LstCALL(Rlist);
{$IFDEF DEMO CREATE}
    Rlist.SaveToFile(ExtractFilePath(Application.ExeName) + '\image\MagDemoPatientProfile' + DFN + '.TXT');
{$ENDIF}

    If (MagPiece(Rlist[0], '^', 1) = '0') Or (Rlist.Count = 0) Then
    Begin
      Rstat := False;
      If Rlist.Count > 0 Then
        Rmsg := MagPiece(Rlist[0], '^', 2)
      Else
        Rmsg := 'ERROR in VistA operation canceled.';
      Exit;
    End;
    Rstat := True;
    Rmsg := MagPiece(Rlist[0], '^', 2);
    Rlist.Delete(0);
  Except
    On e: Exception Do
    Begin
      Rlist.Insert(0, '0^ERROR (EXCEPTION) in VistA function.');
      Rstat := False;
      Rmsg := 'ERROR (EXCEPTION) in VistA function:' + e.Message;
      Rlist.Insert(1, '0^' + MagPiece(e.Message, #$A, 2));
    End;
  End;

End;

//RPMaggRadImage(rstat,rmsg,t,radstring);

Procedure TMagDBMVista.RPMaggRadImage(Var Rstat: Boolean; Var Rmsg: String; Var Tlist: Tstringlist; Radstring: String);
Begin
  Rstat := False;
  With FBroker Do
  Begin
    PARAM[0].Value := Radstring;
    PARAM[0].PTYPE := LITERAL;
    FBroker.REMOTEPROCEDURE := 'MAGGRADIMAGE';
  End;
  Try
    FBroker.LstCALL(Tlist);
    If (MagPiece(Tlist[0], '^', 1) = '0') Or (Tlist.Count = 0) Or
      (MagPiece(Tlist[0], '^', 1) = '-2') Then
    Begin
      Rstat := False;
      If Tlist.Count > 0 Then
        Rmsg := MagPiece(Tlist[0], '^', 2)
      Else
        Rmsg := 'ERROR in VistA operation canceled.';
      Exit;
    End;
    Rstat := True;
    Rmsg := MagPiece(Tlist[0], '^', 2);

        (* 45 startchange
        JMW 3/8/2005 Requirred for RIV p45
        for i := 1 to tlist.Count -1 do
        tlist.Strings[i] := tlist.strings[i] + '^' + fbroker.Server + '^' + inttostr(fbroker.ListenerPort);  //FIX THIS
        *)
        {   Can't put new pieces at end, We could never add new pieces in the M code.}
        {    Fix for above.  }
        {    Starting with Patch 59, Server and Port are inserted in the M code.}
    If Tlist.Count > 1 Then
      If Not IsServerPortInString(Tlist[1], 'MAGGRADIMAGE') Then
        ResolveServerPort(Tlist, FBroker.Server, FBroker.ListenerPort, 1);
  Except
    On e: Exception Do
    Begin
      Tlist.Insert(0, '0^ERROR (EXCEPTION) in VistA function.');
      Rstat := False;
      Rmsg := 'ERROR (EXCEPTION) in VistA function:' + e.Message;
      Tlist.Insert(1, '0^' + MagPiece(e.Message, #$A, 2));
    End;
  End;

    (*
        xBrokerx.param[0].value := radstring;
        xBrokerx.param[0].ptype := literal;
        xBrokerx.rem oteprocedure := 'MAGGRADIMAGE';
        xBrokerx.LSTCALL(t);
        if t.count = 0 then
        begin
          WinMsg('DE', ': The Attempt to access the Image list for selected exam Failed.' +
            '  Check VistA Error Log.');
          WinMsg('s', 'Rad Report info: ' + sysradstring);
          exit;
        end;
        if magpiece(t[0], '^', 1) = '0' then
        begin
          WinMsg('DE', magpiece(t[0], '^', 2));
          WinMsg('s', 'Rad Report info: ' + sysradstring);
          exit;
        end;
        if magpiece(t[0], '^', 1) = '-2' then //Patch 5
        begin
          WinMsg('DEQA', magpiece(t[0], '^', 2));
          WinMsg('s', 'Rad Report info: ' + sysradstring);
          exit;
        end;
    *)

End;
//dmod.MagDBBroker1.RPMaggRadReport(rstat,rmsg,t,RARPT);

Procedure TMagDBMVista.RPMaggRadReport(Var Rstat: Boolean; Var Rmsg: String; Var Tlist: Tstringlist; Rarpt: String);
Begin
  Rstat := False;
  With FBroker Do
  Begin
    PARAM[0].Value := Rarpt;
    PARAM[0].PTYPE := LITERAL;
    FBroker.REMOTEPROCEDURE := 'MAGGRADREPORT';
  End;
  Try
    FBroker.LstCALL(Tlist);
    If (MagPiece(Tlist[0], '^', 1) = '0') Or (Tlist.Count = 0) Or
      (MagPiece(Tlist[0], '^', 1) = '-2') Then
    Begin
      Rstat := False;
      If Tlist.Count > 0 Then
        Rmsg := MagPiece(Tlist[0], '^', 2)
      Else
        Rmsg := 'ERROR in VistA. Operation canceled.';
      Exit;
    End;
    Rstat := True;
    Rmsg := MagPiece(Tlist[0], '^', 2);
        // tlist.delete(0);
  Except
    On e: Exception Do
    Begin
      Tlist.Insert(0, '0^ERROR (EXCEPTION) in VistA function.');
      Rstat := False;
      Rmsg := 'ERROR (EXCEPTION) in VistA function:' + e.Message;
      Tlist.Insert(1, '0^' + MagPiece(e.Message, #$A, 2));
    End;
  End;

    (*    xBrokerx.Param[0].Value := RARPT;
        xBrokerx.Param[0].PType := literal;
        xBrokerx.remoteprocedure := 'MAGGRADREPORT';
        WinMsg('', 'Building Radiology Exam Report...');
        xBrokerx.lstcall(t);
        if t.count = 0 then
        begin
          WinMsg('DE', ': The Attempt to build Radiology Exam report Failed. Check VistA Error Log.');
          Winmsg('s', 'Failed RARPT : ' + RARPT);
          WinMsg('', '');
          exit;
        end;
        if (magpiece(t[0], '^', 1) = '-2') then //Patch 5
        begin
          WinMsg('DEQA', magpiece(t[0], '^', 2) + '   ' + daycase);
          Winmsg('s', 'Failed RARPT : ' + RARPT);
          exit;
        end;
        if (magpiece(t[0], '^', 1) = '0') then
        begin
          WinMsg('DE', magpiece(t[0], '^', 2) + '   ' + daycase);
          Winmsg('s', 'Failed RARPT : ' + RARPT);
          exit;
        end
        else
      *)

End;

Procedure TMagDBMVista.RPMaggHSList(Var Rstat: Boolean; Var Rmsg: String; Var Tlist: Tstringlist; Value: String);
Begin
  Rstat := False;
  With FBroker Do
  Begin
    PARAM[0].Value := Value;
    PARAM[0].PTYPE := LITERAL;
    FBroker.REMOTEPROCEDURE := 'MAGGHSLIST';
  End;
  Try
    FBroker.LstCALL(Tlist);
{$IFDEF DEMO CREATE}
    Tlist.SaveToFile(ExtractFilePath(Application.ExeName) + '\image\MagDemoHSList.TXT');
{$ENDIF}

    If (MagPiece(Tlist[0], '^', 1) = '0') Or (Tlist.Count = 0) Then
    Begin
      Rstat := False;
      If Tlist.Count > 0 Then
        Rmsg := MagPiece(Tlist[0], '^', 2)
      Else
        Rmsg := 'ERROR in VistA operation canceled.';
      Exit;
    End;
    Rstat := True;
    Rmsg := MagPiece(Tlist[0], '^', 2);
    Tlist.Delete(0);
  Except
    On e: Exception Do
    Begin
      Tlist.Insert(0, '0^ERROR (EXCEPTION) in VistA function.');
      Rstat := False;
      Rmsg := 'ERROR (EXCEPTION) in VistA function:' + e.Message;
      Tlist.Insert(1, '0^' + MagPiece(e.Message, #$A, 2));
    End;
  End;
End;

Procedure TMagDBMVista.RPMaggHS(Var Rstat: Boolean; Var Rmsg: String; Var Tlist: Tstringlist; Value: String);
Begin
  Rstat := False;
  With FBroker Do
  Begin
    PARAM[0].Value := Value;
    PARAM[0].PTYPE := LITERAL;
    FBroker.REMOTEPROCEDURE := 'MAGGHS';
  End;
  Try
    FBroker.LstCALL(Tlist);
{$IFDEF DEMO CREATE}
    Tlist.SaveToFile(ExtractFilePath(Application.ExeName) + '\image\MagDemoHSReport-' + MagPiece(Value, '^', 2) + '.TXT');
{$ENDIF}

    If (MagPiece(Tlist[0], '^', 1) = '0') Or (Tlist.Count = 0) Then
    Begin
      Rstat := False;
      If Tlist.Count > 0 Then
        Rmsg := MagPiece(Tlist[0], '^', 2)
      Else
        Rmsg := 'ERROR: Health Summary Failed. Check VISTA Error Log.';
      Exit;
    End;
    Rstat := True;
    Rmsg := MagPiece(Tlist[0], '^', 2);
    Tlist.Delete(0);
  Except
    On e: Exception Do
    Begin
      Tlist.Insert(0, '0^ERROR (EXCEPTION) in VistA function.');
      Rstat := False;
      Rmsg := 'ERROR (EXCEPTION) in VistA function:' + e.Message;
      Tlist.Insert(1, '0^' + MagPiece(e.Message, #$A, 2));
    End;
  End;
    (*
      try
        xBrokerx.PARAM[0].VALUE := PATDFN.CAPTION + '^' + XST;
        xBrokerx.PARAM[0].PTYPE := LITERAL;
        xBrokerx.remoteprocedure := 'MAGGHS';
        xBrokerx.lstcall(t);
        if t.count = 0 then
        begin
          LogMsg('de', 'Failed to build Patient Health Summary. Check VISTA Error Log.', msg);
          LogMsg('e', 'ERROR: Health Summary Failed. Check VISTA Error Log.', msg);
          exit;
        end;
        if magpiece(t[0], '^', 1) = '0' then LogMsg('', magpiece(t[0], '^', 2), msg);
        if magpiece(t[0], '^', 1) <> '0' then begin
          t.delete(0);
    *)
End;

(*
procedure TMagDBMVista.RPMag...(var rstat: boolean; var rmsg: string; var rlist: tstrings; xxx : string);
var yyy : string;
begin
 rstat := false;
  with FBroker do
  begin
    Param[0].PType := list;
    Param[0].Value := '.x';

    param[0].Value := ;
    param[0].PType := ;
    param[1].value := ;
    param[1].ptype := ;

   Fbroker.remoteprocedure := 'MAG......';
  end;
  try
    Fbroker.lstCall(rlist);
    if (magpiece(rlist[0], '^', 1) = '0') or (rlist.count = 0) then
    begin
      rstat := false;
      if rlist.count > 0 then rmsg := magpiece(rlist[0], '^', 2)
                         else rmsg := 'ERROR in VistA operation canceled.';
      exit;
    end;
    rstat := true;
    rmsg := magpiece(rlist[0], '^', 2);
    rlist.delete(0);
  except
    on E: EXCEPTION do
    begin
      rlist.insert(0, '0^ERROR (EXCEPTION) in VistA function.');
      rstat := false;
      rmsg := 'ERROR (EXCEPTION) in VistA function:' + e.Message;
      rlist.insert(1, '0^' + magpiece(e.message, #$A, 2));
    end;
  end;

end;
*)

Procedure TMagDBMVista.RPGetFileExtensions(Var t: TStrings);
Begin
  FBroker.REMOTEPROCEDURE := 'MAG4 GET SUPPORTED EXTENSIONS';
  Try
    FBroker.LstCALL(t);
  Except
    On e: Exception Do
    Begin
      t.Insert(0, '0^Error: Getting supported Extensions.');
            //LogMsg('de', 'VistA Error: ' + magpiece(e.message, #$A, 2));
      MagLogger.LogMsg('de', 'VistA Error: ' + MagPiece(e.Message, #$A, 2)); {JK 10/5/2009 - Maggmsgu refactoring}
    End;
  End;
End;

Procedure TMagDBMVista.RPUpdateConsult(Consult, TiuIen, cmpFlag: String; Var Status: String);
Begin
  FBroker.REMOTEPROCEDURE := 'MAG4 CP UPDATE CONSULT';
  FBroker.PARAM[0].PTYPE := LITERAL;
  FBroker.PARAM[0].Value := Consult;

  FBroker.PARAM[1].PTYPE := LITERAL;
  FBroker.PARAM[1].Value := TiuIen;
  FBroker.PARAM[2].PTYPE := LITERAL;
  FBroker.PARAM[2].Value := cmpFlag;
  Try
    Status := FBroker.STRCALL;
  Except
    On e: Exception Do
    Begin
      Status := '0^VistA Error';
            //LogMsg('de', 'VistA Error: ' + magpiece(e.message, #$A, 2));
      MagLogger.LogMsg('de', 'VistA Error: ' + MagPiece(e.Message, #$A, 2)); {JK 10/5/2009 - Maggmsgu refactoring}
    End;
  End;
End;

Function TMagDBMVista.RPTIUCPClass: Integer;
Var
  s: String;
Begin
  FBroker.REMOTEPROCEDURE := 'TIU IDENTIFY CLINPROC CLASS';
  Try
    s := FBroker.STRCALL;
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

Function TMagDBMVista.RPTIUConsultsClass: Integer;
Var
  s: String;
Begin
  FBroker.REMOTEPROCEDURE := 'TIU IDENTIFY CONSULTS CLASS';
  Try
    s := FBroker.STRCALL;
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

Procedure TMagDBMVista.RPMagLogErrorText(t: TStrings; Count: Integer);
Var
  i, j: Integer;

Begin
  i := t.Count;
  If (i < Count) Then
    Count := i;
  FBroker.REMOTEPROCEDURE := 'MAGG LOG ERROR TEXT';
  FBroker.PARAM[0].Value := '.X';
  FBroker.PARAM[0].PTYPE := List;

  For j := 1 To Count Do
  Begin
    Dec(i);
        //xBrokerx.Param[3].Mult['"TEXT'+','+INTTOSTR(I+1)+',0"']:=NOTETEXT[I];
    FBroker.PARAM[0].Mult[('"TEXT' + Copy('000', 1, 3 - Length(Inttostr(i))) + Inttostr(i) + '"')] := t[i];
  End;

  FBroker.Call;

End;

Procedure TMagDBMVista.RPMagGetNetLoc(Var Success: Boolean; Var RPmsg: String; Var Shares: Tstringlist; NetLocType: String);
Begin
    (* Get all network locations and their properties *)
  Success := False;
  Try
    FBroker.PARAM[0].Value := NetLocType;
    FBroker.PARAM[0].PTYPE := LITERAL;
    FBroker.REMOTEPROCEDURE := 'MAG GET NETLOC';
    FBroker.LstCALL(Shares);
    If (MagPiece(Shares[0], '^', 1) = '0') Then
    Begin
            //LogMsg('', magpiece(Shares[0], '^', 2));
      MagLogger.LogMsg('', MagPiece(Shares[0], '^', 2)); {JK 10/5/2009 - Maggmsgu refactoring}
      RPmsg := Shares[0];
      Exit;
    End;
    If (Shares.Count = 0) Then
    Begin
            //LogMsg('', 'Error accessing Network Locations');
      MagLogger.LogMsg('', 'Error accessing Network Locations'); {JK 10/5/2009 - Maggmsgu refactoring}
      RPmsg := 'Error accessing Network Locations ';
      Exit;
    End;
    Success := True;
    RPmsg := Shares[0];
    Shares.Delete(0);

  Except
    On e: Exception Do
    Begin
      //Showmessage(e.Message);
      //p106 rlm 20101229 CR640 "Title of Dialog box"
      MagLogger.MagMsg(
        'de',
        e.Message,
        Nil);
      Shares[0] := 'The Attempt to get network locations. Check VistA Error Log.';
    End;
  End;

End;

Function TMagDBMVista.RPMagEkgOnline: Integer;
Begin
    (* get the status of the first EKG server 0=offline 1=online - if no server exists 0 is returned *)
  FBroker.REMOTEPROCEDURE := 'MAG EKG ONLINE';
  Result := Strtoint(FBroker.STRCALL);

End;

Procedure TMagDBMVista.RPMaggOffLineImageAccessed(IObj: TImageData);
Var
  RemoteBroker: IMagRemoteBroker;
Begin
    // JMW p45 4/18/2005
  If (IObj.ServerName = FBroker.Server) And (IObj.ServerPort = FBroker.ListenerPort) Then
  Begin
    With FBroker Do
    Begin
      If Not Connected Then
        Exit;
      FBroker.REMOTEPROCEDURE := 'MAGG OFFLINE IMAGE ACCESSED';
      PARAM[0].PTYPE := LITERAL;
      PARAM[0].Value := IObj.FFile;
      PARAM[1].PTYPE := LITERAL;
      PARAM[1].Value := IObj.Mag0;
      Call;
    End;
  End
  Else
  Begin
    RemoteBroker := MagRemoteBrokerManager1.GetBroker(IObj.ServerName, IObj.ServerPort);
    If RemoteBroker = Nil Then
    Begin
      MagRemoteBrokerManager1.LogBrokerNotFoundError(IObj.ServerName, IObj.ServerPort, 'RPMaggOffLineImageAccessed');
      Exit;
    End;
    RemoteBroker.LogOfflineImageAccess(IObj);
  End;
End;

(*
procedure ___________(magrecord : MagRecordPtr) ;
begin
with xBrokerx do
     begin
     If NOT CONNECTED THEN EXIT;
    Fbroker.remoteprocedure :=       ;
     PARAM[0].PTYPE :=   ----;
     PARAM[0].VALUE := -------;
     PARAM[1].PTYPE := -------;
     PARAM[1].VALUE := -----------  ;
     CALL;
     end;
END ;
*)

Procedure TMagDBMVista.RPMag3Logaction(ActionString: String; IObj: TImageData = Nil);
Var
  RemoteBroker: IMagRemoteBroker;
Begin
    // JMW 4/21/2005 p45
  If ((IObj = Nil) Or (IObj.ServerName = '') Or (IObj.ServerPort = 0) Or ((IObj.ServerName = FBroker.Server) And (IObj.ServerPort = FBroker.ListenerPort))) Then
        //  if ((Iobj.ServerName = '') or (IObj.ServerPort = 0) or ((IObj.ServerName = FBroker.Server) and (IObj.ServerPort = Fbroker.ListenerPort))) then
  Begin
    With FBroker Do
    Begin
      PARAM[0].Value := ActionString;
      PARAM[0].PTYPE := LITERAL;
      FBroker.REMOTEPROCEDURE := 'MAG3 LOGACTION';
      Call;
    End;
  End
  Else
  Begin
    RemoteBroker := MagRemoteBrokerManager1.GetBroker(IObj.ServerName, IObj.ServerPort);
    If RemoteBroker = Nil Then
    Begin
      MagRemoteBrokerManager1.LogBrokerNotFoundError(IObj.ServerName, IObj.ServerPort, 'RPMag3Logaction');
      Exit;
    End;
    RemoteBroker.LogAction(ActionString);
  End;
End;

Procedure TMagDBMVista.RPMaggQueImage(IObj: TImageData);
Var
  RemoteBroker: IMagRemoteBroker;
  Res: TStrings;
Begin
    // JMW p45
  If (FBroker.Server = IObj.ServerName) And (FBroker.ListenerPort = IObj.ServerPort) Then
  Begin
    With FBroker Do
    Begin
      PARAM[0].Value := 'AF';
      PARAM[0].PTYPE := LITERAL;
      PARAM[1].Value := IObj.Mag0;
      PARAM[1].PTYPE := LITERAL;
      FBroker.REMOTEPROCEDURE := 'MAGG QUE IMAGE';
            //LogMsg('s', '--RPC : MAGG QUE IMAGE ^AF^' + IObj.mag0);
      MagLogger.LogMsg('s', '--RPC : MAGG QUE IMAGE ^AF^' + IObj.Mag0); {JK 10/5/2009 - Maggmsgu refactoring}
      Try
        Call;
                //LogMsg('S', '--' + FBroker.RESULTS[0]);
        MagLogger.LogMsg('S', '--' + FBroker.Results[0]); {JK 10/5/2009 - Maggmsgu refactoring}
      Except
        Messagedlg('Error attempting to set the Queue ' + #13 + 'to copy an Image from the Juke Box.'
          + #13 + 'Not Fatal, Process will continue.', MtWarning, [Mbok], 0);
      End;
    End;
  End
  Else
  Begin
    RemoteBroker := MagRemoteBrokerManager1.GetBroker(IObj.ServerName, IObj.ServerPort);
    If RemoteBroker = Nil Then
    Begin
      MagRemoteBrokerManager1.LogBrokerNotFoundError(IObj.ServerName, IObj.ServerPort, 'RPMaggQueImage');
      Exit;
    End;
    With RemoteBroker Do
    Begin
            //LogMsg('s', '--RPC : MAGG QUE IMAGE ^AF^' + IObj.mag0);
      MagLogger.LogMsg('s', '--RPC : MAGG QUE IMAGE ^AF^' + IObj.Mag0); {JK 10/5/2009 - Maggmsgu refactoring}
      Try
        Res := RemoteBroker.QueImage('AF', IObj);
                //LogMsg('S', '--' + res[0]);
        MagLogger.LogMsg('S', '--' + Res[0]); {JK 10/5/2009 - Maggmsgu refactoring}
      Except
        Messagedlg('Error attempting to set the Queue ' + #13 + 'to copy an Image from the Juke Box.'
          + #13 + 'Not Fatal, Process will continue.', MtWarning, [Mbok], 0);
      End;
    End;

  End;
End;

// I don't think this is ever used

Procedure TMagDBMVista.RPMaggQueBigImage(IObj: TImageData);
Var
  RemoteBroker: IMagRemoteBroker;
  Res: TStrings;
Begin
    // JMW p45
  If (IObj.ServerName = FBroker.Server) And (IObj.ServerPort = FBroker.ListenerPort) Then
  Begin
    With FBroker Do
    Begin
      PARAM[0].Value := 'B';
      PARAM[0].PTYPE := LITERAL;
      PARAM[1].Value := IObj.Mag0;
      PARAM[1].PTYPE := LITERAL;
      FBroker.REMOTEPROCEDURE := 'MAGG QUE IMAGE';
            //LogMsg('s', '--RPC : MAGG QUE IMAGE ^B^' + IObj.mag0);
      MagLogger.LogMsg('s', '--RPC : MAGG QUE IMAGE ^B^' + IObj.Mag0); {JK 10/5/2009 - Maggmsgu refactoring}
      Try
        Call;
                //LogMsg('S', '--' + FBroker.RESULTS[0]);
        MagLogger.LogMsg('S', '--' + FBroker.Results[0]); {JK 10/5/2009 - Maggmsgu refactoring}
      Except
        Messagedlg('Error attempting to set the Queue ' + #13 + 'to copy a BIG Image from the Juke Box.'
          + #13 + 'Not Fatal, Process will continue.', MtWarning, [Mbok], 0);
      End;
    End;
  End
  Else
  Begin
    RemoteBroker := MagRemoteBrokerManager1.GetBroker(IObj.ServerName, IObj.ServerPort);
    If RemoteBroker = Nil Then
    Begin
      MagRemoteBrokerManager1.LogBrokerNotFoundError(IObj.ServerName, IObj.ServerPort, 'RPMaggQueBigImage');
      Exit;
    End;
        //LogMsg('s', '--RPC : MAGG QUE IMAGE ^B^' + IObj.mag0);
    MagLogger.LogMsg('s', '--RPC : MAGG QUE IMAGE ^B^' + IObj.Mag0); {JK 10/5/2009 - Maggmsgu refactoring}
    Try
      Res := RemoteBroker.QueImage('B', IObj);
            //LogMsg('S', '--' + res[0]);
      MagLogger.LogMsg('S', '--' + Res[0]); {JK 10/5/2009 - Maggmsgu refactoring}
    Except
      Messagedlg('Error attempting to set the Queue ' + #13 + 'to copy a BIG Image from the Juke Box.'
        + #13 + 'Not Fatal, Process will continue.', MtWarning, [Mbok], 0);
    End;
  End;
End;
// Queue all images for a Patient to be copied from JukeBox to HD.

Procedure TMagDBMVista.RPMaggQuePatient(Whichimages, DFN: String);
Var
  s: String;
Begin
    { whichimages is a code of 'A' for abstract
                               'F' for Full }
  With FBroker Do
  Begin
    PARAM[0].Value := Whichimages;
    PARAM[0].PTYPE := LITERAL;
    PARAM[1].Value := DFN;
    PARAM[1].PTYPE := LITERAL;
    FBroker.REMOTEPROCEDURE := 'MAGG QUE PATIENT';
        //LogMsg('s', '--RPC : MAGG QUE PATIENT ^' + whichimages + '^' + dfn);
    MagLogger.LogMsg('s', '--RPC : MAGG QUE PATIENT ^' + Whichimages + '^' + DFN); {JK 10/5/2009 - Maggmsgu refactoring}
    s := STRCALL;
        //LogMsg('s', '--' + s);
    MagLogger.LogMsg('s', '--' + s); {JK 10/5/2009 - Maggmsgu refactoring}
  End;
End;
// Queue images to be Copied from JukeBox.
//  The RPC Call "M" code, determines if the iamges need to be queued.
//  and if true.  Makes the call to set the JBtoHD Queue.

//procedure TMagDBMVista.RPMaggQueImageGroup(whichimages, MAGIEN: string);

Procedure TMagDBMVista.RPMaggQueImageGroup(Whichimages: String; IObj: TImageData);
Var
  s: String;
  RemoteBroker: IMagRemoteBroker;
Begin
    { whichimages is a code of 'A' for abstract
                               'F' for Full }
  If (IObj.ServerName = FBroker.Server) And (IObj.ServerPort = FBroker.ListenerPort) Then
  Begin
    Try
      With FBroker Do
      Begin
        PARAM[0].Value := Whichimages;
        PARAM[0].PTYPE := LITERAL;
        PARAM[1].Value := IObj.Mag0;
        PARAM[1].PTYPE := LITERAL;
        FBroker.REMOTEPROCEDURE := 'MAGG QUE IMAGE GROUP';
                //LogMsg('s', '--RPC : MAGG QUE IMAGE GROUP^' + whichimages + '^' + IObj.Mag0);
        MagLogger.LogMsg('s', '--RPC : MAGG QUE IMAGE GROUP^' + Whichimages + '^' + IObj.Mag0); {JK 10/5/2009 - Maggmsgu refactoring}
        s := STRCALL;
                //LogMsg('s', '--' + s);
        magLogger.LogMsg('s', '--' + s); {JK 10/5/2009 - Maggmsgu refactoring}
      End;
    Except
            //
    End;
  End
  Else
  Begin
    RemoteBroker := MagRemoteBrokerManager1.GetBroker(IObj.ServerName, IObj.ServerPort);
    If RemoteBroker = Nil Then
    Begin
      MagRemoteBrokerManager1.LogBrokerNotFoundError(IObj.ServerName, IObj.ServerPort, 'RPMaggQueImageGroup');
      Exit;
    End;
    Try
            //LogMsg('s', '--RPC : MAGG QUE IMAGE GROUP^' + whichimages + '^' + IObj.Mag0);
      MagLogger.LogMsg('s', '--RPC : MAGG QUE IMAGE GROUP^' + Whichimages + '^' + IObj.Mag0); {JK 10/5/2009 - Maggmsgu refactoring}
      s := RemoteBroker.QueImageGroup(Whichimages, IObj);
            //LogMsg('s', '--' + s);
      MagLogger.LogMsg('s', '--' + s); {JK 10/5/2009 - Maggmsgu refactoring}
    Except
            //
    End;
  End;
End;
// Returns all images for an Image Group.

Procedure TMagDBMVista.RPMaggGroupImages(IObj: TImageData; Var t: Tstringlist; NoQAcheck: Boolean = False; DeletedImages: String = '');
Var
  RemoteBroker: IMagRemoteBroker;
Begin

  {/ P117 - JK 9/2/2010 - value must be blank (no deleted images) or D (include deleted images with existing images) /}
  if Uppercase(DeletedImages) <> 'D' then
    DeletedImages := '';
  
    // JMW p45
  If (IObj.ServerName = FBroker.Server) And (IObj.ServerPort = FBroker.ListenerPort) Then
  Begin
    With FBroker Do
    Begin
      PARAM[0].Value := IObj.Mag0;
      PARAM[0].PTYPE := LITERAL;
      PARAM[1].Value := Magbooltostrint(NoQAcheck);
      PARAM[1].PTYPE := LITERAL;
      PARAM[2].Value := DeletedImages; {/ P117 - JK 9/2/2010 - value must be blank or D /}   //!!! check version to see if this param can be passed !!!
      PARAM[2].PTYPE := LITERAL;

      FBroker.REMOTEPROCEDURE := 'MAGG GROUP IMAGES'; //MAGOGLU';
      LstCALL(t);
            //    for i := 0 to t.count -1 do
            //        t.strings[i] := t.strings[i] + '^' + Fbroker.Server + '^' + inttostr(Fbroker.ListenerPort); //FIX THIS
      If t.Count > 1 Then
        If Not IsServerPortInString(t[1], 'MAGG GROUP IMAGES') Then
          ResolveServerPort(t, FBroker.Server, FBroker.ListenerPort, 1);
    End;
  End
  Else
  Begin
    RemoteBroker := MagRemoteBrokerManager1.GetBroker(IObj.ServerName, IObj.ServerPort);
    If RemoteBroker = Nil Then
    Begin
      MagRemoteBrokerManager1.LogBrokerNotFoundError(IObj.ServerName, IObj.ServerPort, 'RPMaggGroupImages');
      Exit;
    End;
    RemoteBroker.GetImageGroup(IObj, NoQAcheck, t);
        //    for i := 0 to t.count -1 do
        //   t.strings[i] := t.strings[i] + '^' + TRemoteBroker.Server + '^' + inttostr(TRemoteBroker.ListenerPort); //FIX THIS
    If t.Count > 1 Then
      If Not IsServerPortInString(t[1], 'RIV: MAGG GROUP IMAGES') Then
        ResolveServerPort(t, IObj.ServerName, IObj.ServerPort, 1);

  End;
End;

// Gets all images for a patient.  Groups are returned as one item.
//   Single images are returned as one item.
(*
procedure TMagDBMVista.RPMaggPatImages(DFN: string; var t: tstringlist);
begin
  with FBroker do
    begin
      param[0].Value := DFN;
      param[0].PType := literal;
      Fbroker.remoteprocedure := 'MAGG PAT IMAGES';
      lstCall(t);
    end;
end; *)

// This call returns all images, it returns the images of a group, instead
// of returning the Group.

Procedure TMagDBMVista.RPMaggPatEachImage(DFN, Max: String; Var t: Tstringlist);
Begin
  With FBroker Do
  Begin
    PARAM[0].Value := DFN;
    PARAM[0].PTYPE := LITERAL;
    PARAM[1].Value := Max;
    PARAM[1].PTYPE := LITERAL;
    FBroker.REMOTEPROCEDURE := 'MAGG PAT EACH IMAGE';
    LstCALL(t);
  End;
End;

Constructor TMagDBMVista.Create;
Begin
  Inherited;
  FBroker := TCCOWRPCBroker.Create(Nil); //RLM Fixing MemoryLeak 6/18/2010
End;

Procedure TMagDBMVista.CreateBroker;
Begin
  If Not Assigned(FBroker) Then
  Begin
    FBroker := TCCOWRPCBroker.Create(Nil);
  End;
End;

Procedure TMagDBMVista.SetContextor(Contextor: TContextorControl);
Begin
  TCCOWRPCBroker(FBroker).Contextor := Contextor;
End;

Procedure TMagDBMVista.RPMaggLogOff;
Begin
  If Not FBroker.Connected Then
    Exit;

  FBroker.REMOTEPROCEDURE := 'MAGG LOGOFF';
  Try
    FBroker.Call;
  Except
    On e: EBrokerError Do
            //LogMsg('de', 'Error Connecting to VISTA.' + #13 + #13 + E.MESSAGE + #13 + #13 + 'Shutdown will continue.');
      MagLogger.LogMsg('de', 'Error Connecting to VISTA.' + #13 + #13 + e.Message + #13 + #13 + 'Shutdown will continue.'); {JK 10/5/2009 - Maggmsgu refactoring}
    On e: Exception Do
            //LogMsg('de', 'Error During Log Off : ' + e.message);
      MagLogger.LogMsg('de', 'Error During Log Off : ' + e.Message); {JK 10/5/2009 - Maggmsgu refactoring}
  Else
        //LogMsg('de', 'Unknown Error during Log Off');
    MagLogger.LogMsg('de', 'Unknown Error during Log Off'); {JK 10/5/2009 - Maggmsgu refactoring}
  End;
  FBroker.Connected := False;
    // JMW 3/15/2005 p45
  If MagRemoteBrokerManager1 <> Nil Then
    MagRemoteBrokerManager1.LogoffRemoteBrokers();
End;

Procedure TMagDBMVista.RPMaggWrksUpdate(AppPath, DispAppName, CapAppName, Compname, Location, LastUpdate: String; Startmode: Integer);
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
    {
   In VistA, DATA is the Input parameter.
  ; DATA is '^' delimited piece
  ; 1 Workstation name            2 Date/Time of capture app.
  ; 3 Date/Time of Display App.
  ; 4 Location of workstation      5 Date/Time of MAGSETUP
  ; 6 Version of Display          7 Version of Capture
  ; 8  1=Normal startup 2=Started by CPRS 3=Import API
  ; 9 OS Version                 10 VistaRad Version
  ; 11 RPCBroker Server                 12 RPCBroker Port
  }
  FBroker.REMOTEPROCEDURE := 'MAGG WRKS UPDATES';
  FBroker.PARAM[0].PTYPE := LITERAL;
  FBroker.PARAM[0].Value := Compname //1
    + '^' + DtCapture //2
    + '^' + DtDisplay //3
    + '^' + Location //4
    + '^' + LastUpdate //5
    + '^' + MagGetFileVersionInfo(DispAppName) //6
    + '^' + MagGetFileVersionInfo(CapAppName) //7
    + '^' + Inttostr(Startmode) //8
    + '^' + MagGetOSVersion //9
    + '^' //VistaRadVersion                        //10
    + '^' + FBroker.Server //11
    + '^' + Inttostr(FBroker.ListenerPort) //12
    + '^';
  FBroker.Call;
    //LogMsg('s', 'Workstation Information sent to VistA:');
  MagLogger.LogMsg('s', 'Workstation Information sent to VistA:'); {JK 10/5/2009 - Maggmsgu refactoring}
    //LogMsg('s', '  -> Result = ' + FBroker.results[0]);
  MagLogger.LogMsg('s', 'Workstation Information sent to VistA:'); {JK 10/5/2009 - Maggmsgu refactoring}

End;

Procedure TMagDBMVista.RPMaggUserKeys(Var t: Tstringlist);
Begin
  FBroker.REMOTEPROCEDURE := 'MAGGUSERKEYS';
  FBroker.LstCALL(t);
    //LogMsg('', t);
  MagLogger.LogMsgs('', t); {JK 10/5/2009 - Maggmsgu refactoring}
End;

Procedure TMagDBMVista.RPMaggGetTimeout(app: String; Var Minutes: String);
Begin
  FBroker.REMOTEPROCEDURE := 'MAGG GET TIMEOUT';
  FBroker.PARAM[0].PTYPE := LITERAL;
  FBroker.PARAM[0].Value := app;
  Minutes := FBroker.STRCALL;

End;

Procedure TMagDBMVista.RPGetDischargeSummaries(DFN: String; Var t: Tstringlist);
Begin
  FBroker.REMOTEPROCEDURE := 'TIU SUMMARIES';
  FBroker.PARAM[0].PTYPE := LITERAL;
  FBroker.PARAM[0].Value := DFN;
  FBroker.LstCALL(t);
End;

Procedure TMagDBMVista.RPGetNoteText(TiuDA: String; t: TStrings);
Begin
  FBroker.REMOTEPROCEDURE := 'TIU GET RECORD TEXT';
  FBroker.PARAM[0].PTYPE := LITERAL;
  FBroker.PARAM[0].Value := TiuDA;
  FBroker.LstCALL(t);
End;

Procedure TMagDBMVista.RPGetNoteTitles(t, Tint: Tstringlist);
Var
  i: Integer;
Begin
  t.Sorted := False;
  Tint.Sorted := False;
  Tint.Clear;
  FBroker.REMOTEPROCEDURE := 'TIU GET PN TITLES';
    //xbrokerx.Param[0].ptype := literal;
    //xbrokerx.param[0].value := dfn  ;
  FBroker.LstCALL(t);
  For i := 0 To t.Count - 1 Do
  Begin
    Tint.Add('');
    Tint[i] := Copy(t[i], 2, Pos('^', t[i]) - 2);
    t[i] := MagPiece(t[i], '^', 2)
  End;
End;

//  Not Creating New TIU Records(*

Function TMagDBMVista.RPCreateRecord(Var Msg: String; DFN, Notetitle, Notedate: String; Notetext: TStrings): Boolean;
Var
  i: Integer;
  s: String;
Begin
  If DFN = '' Then
  Begin
    Result := False;
    Msg := 'You need to Select a Patient';
    Exit;
  End;
  FBroker.REMOTEPROCEDURE := 'TIU CREATE RECORD';
  FBroker.PARAM[0].PTYPE := LITERAL;
  FBroker.PARAM[0].Value := DFN;
  FBroker.PARAM[1].PTYPE := LITERAL;
  FBroker.PARAM[1].Value := Notetitle;

  FBroker.PARAM[2].PTYPE := LITERAL;
  FBroker.PARAM[2].Value := '';
  FBroker.PARAM[3].PTYPE := LITERAL;
  FBroker.PARAM[3].Value := '';
  FBroker.PARAM[4].PTYPE := LITERAL;
  FBroker.PARAM[4].Value := '';

  FBroker.PARAM[5].Value := '.X';
  FBroker.PARAM[5].PTYPE := List;
  For i := 0 To Notetext.Count Do
  Begin
        //xBrokerx.Param[3].Mult['"TEXT'+','+INTTOSTR(I+1)+',0"']:=NOTETEXT[I];
    FBroker.PARAM[5].Mult['"TEXT"' + ',' + Inttostr(i + 1) + ',0'] := Notetext[i];
  End;

  s := FBroker.STRCALL;
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

Function TMagDBMVista.RPGetFileManDateTime(DateStr: String; Var DisDt, IntDT: String; NoFuture: Boolean): Boolean;
Var
  Dt: String;
    { this returns 1 ^ Display Date ^ internal date
              or   0 ^ error msg     }
Begin
  FBroker.PARAM[0].PTYPE := LITERAL;
  FBroker.PARAM[0].Value := DateStr;
  If NoFuture Then
  Begin
    FBroker.PARAM[1].PTYPE := LITERAL;
    FBroker.PARAM[1].Value := '1';
  End;
  FBroker.REMOTEPROCEDURE := 'MAGG DTTM';
  FBroker.Call;
  Dt := FBroker.Results[0];
  If (Dt = '') Or (Copy(Dt, 1, 1) = '0') Then
  Begin
    Result := False;
    Messagedlg(MagPiece(Dt, '^', 2), Mtconfirmation, [Mbok], 0);
    Exit;
  End;
  DisDt := MagPiece(Dt, '^', 2);

  If Maglength(DisDt, ':') > 2 Then
    DisDt := MagPiece(DisDt, ':', 1) + ':' + MagPiece(DisDt, ':', 2);

  IntDT := MagPiece(Dt, '^', 3);
  Result := True;
End;

Function TMagDBMVista.RPSignRecord(TiuDA, Hashesign: String; Var Msg: String): Boolean;
Var
  s: String;
Begin
  FBroker.PARAM[0].PTYPE := LITERAL;
  FBroker.PARAM[0].Value := TiuDA;
  FBroker.PARAM[1].PTYPE := LITERAL;
  FBroker.PARAM[1].Value := Hashesign;
  FBroker.REMOTEPROCEDURE := 'TIU SIGN RECORD';
  s := FBroker.STRCALL;
  If (s = '0') Then
    Result := True
  Else
  Begin
    Result := False;
    Msg := s;
  End;
End;

Procedure TMagDBMVista.RPGetNotesByContext(DFN: String; Var t: Tstringlist; Context: Integer; Author, Count: String; Docclass: Integer; Seq: String; Showadd:
  Integer; Incund: Integer; Mthsback: Integer = 0; Dtfrom: String = ''; Dtto: String = '');
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
  If (Mthsback < 0) And (Mthsback > -99) Then
  Begin
    Dtto := DateToStr(Now);
    Dtfrom := DateToStr(IncMonth(Now, Mthsback));
    Context := 5;
  End;
  Dtto := DispDttoFM(Dtto);
  Dtfrom := DispDttoFM(Dtfrom);
  FBroker.REMOTEPROCEDURE := 'TIU DOCUMENTS BY CONTEXT';
  FBroker.PARAM[0].PTYPE := LITERAL;
  FBroker.PARAM[0].Value := Inttostr(Docclass); // CPMOD was just '3'
  FBroker.PARAM[1].PTYPE := LITERAL;
  FBroker.PARAM[1].Value := Inttostr(Context);
  FBroker.PARAM[2].PTYPE := LITERAL;
  FBroker.PARAM[2].Value := DFN;
  FBroker.PARAM[3].PTYPE := LITERAL;
  FBroker.PARAM[3].Value := Dtfrom; //[Early] FM date/time to begin search
  FBroker.PARAM[4].PTYPE := LITERAL;
  FBroker.PARAM[4].Value := Dtto; //[Late] FM date/time to end search
  FBroker.PARAM[5].PTYPE := LITERAL;
  FBroker.PARAM[5].Value := Author;
  FBroker.PARAM[6].PTYPE := LITERAL;
  FBroker.PARAM[6].Value := Count;

  FBroker.PARAM[7].PTYPE := LITERAL;
  FBroker.PARAM[7].Value := Seq;
  FBroker.PARAM[8].PTYPE := LITERAL;
  FBroker.PARAM[8].Value := Inttostr(Showadd);
  FBroker.PARAM[9].PTYPE := LITERAL;
  FBroker.PARAM[9].Value := Inttostr(Incund);
  LogRPCParams;
  FBroker.LstCALL(t);
  LogRPCResult(t);
End;

Function TMagDBMVista.RPGetTIUData(TiuDA: String; Var TiuPTR: String): Boolean;
Var
  s: String;
Begin
  FBroker.REMOTEPROCEDURE := 'MAG3 TIU DATA FROM DA';
  FBroker.PARAM[0].PTYPE := LITERAL;
  FBroker.PARAM[0].Value := TiuDA;
  Try
    s := FBroker.STRCALL;
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

Procedure TMagDBMVista.RPGetCPRSTIUNotes(TiuDA: String; t: Tstringlist; Var Success: Boolean; Var RPmsg: String);
Begin
  Success := False;
  Try
    FBroker.REMOTEPROCEDURE := 'MAG3 CPRS TIU NOTE';
    FBroker.PARAM[0].PTYPE := LITERAL;
    FBroker.PARAM[0].Value := TiuDA;
    Self.LogRPCParams;
    FBroker.LstCALL(t);
    Self.LogRPCResult(t);
    If (MagPiece(t[0], '^', 1) = '0') Then
    Begin
            //LogMsg('', magpiece(t[0], '^', 2));
      MagLogger.LogMsg('', MagPiece(t[0], '^', 2)); {JK 10/5/2009 - Maggmsgu refactoring}
      RPmsg := t[0];
      Exit;
    End;
    If (t.Count = 0) Then
    Begin
            //LogMsg('', 'Error accessing Images for TIU Note ');
      MagLogger.LogMsg('', 'Error accessing Images for TIU Note '); {JK 10/5/2009 - Maggmsgu refactoring}
      RPmsg := 'Error accessing Images for TIU Note ';
      Exit;
    End;
    Success := True;
    RPmsg := t[0];
    t.Delete(0);
    If Not IsServerPortInString(t[0], 'MAG3 CPRS TIU NOTE') Then
      ResolveServerPort(t, FBroker.Server, FBroker.ListenerPort);
  Except
    On e: Exception Do
    Begin
      Self.LogRPCException(e.Message); //gek p94t7
            //LogMsg('', 'Exception accessing Images for TIU Note ');
      MagLogger.LogMsg('', 'Exception accessing Images for TIU Note '); {JK 10/5/2009 - Maggmsgu refactoring}
      RPmsg := 'Exception accessing Images for TIU Note ';
    End;
  End;
End;

//procedure RPMagCategories(var t, tien: tstrings);

(*procedure TMagDBMVista.RPMagCategories(t: tstrings);
begin
  //ADMINDOC
  try
    t.clear;
    //tien.clear;
    Fbroker.remoteprocedure := 'MAGGDESCCAT';
    FBroker.lstcall(t);
    if (t.count = 0) then
      begin
        LogMsg('', 'Error loading Image Cagetories.');
        exit;
      end;
    if (t.count = 1) then LogMsg('de', magpiece(t[0], '^', 2));
    t.delete(0);

  except
    on e: exception do LogMsg('de', 'Exception ' + e.message);
  end;
end;  *)

Procedure TMagDBMVista.RPGetClinProcReq(DFN: String; Var t: TStrings);
Begin
    //  success := false;
  Try
    FBroker.REMOTEPROCEDURE := 'MAG4 CP GET REQUESTS';
    FBroker.PARAM[0].PTYPE := LITERAL;
    FBroker.PARAM[0].Value := DFN;
    FBroker.LstCALL(t);
    If (MagPiece(t[0], '^', 1) = '0') Then
    Begin
            //LogMsg('', magpiece(t[0], '^', 2));
      MagLogger.LogMsg('', MagPiece(t[0], '^', 2)); {JK 10/5/2009 - Maggmsgu refactoring}
      Exit;
    End;
    If (t.Count = 0) Then
    Begin
            //LogMsg('', 'Error while listing CP Requests. ');
      MagLogger.LogMsg('', 'Error while listing CP Requests. '); {JK 10/5/2009 - Maggmsgu refactoring}
      t.Add('0^Error while listing CP Requests. ');
      Exit;
    End;
        //    success := true;
    t.Delete(0);
  Except
    On e: Exception Do
    Begin
            //LogMsg('', 'Exception while listing CP Requests. ');
      MagLogger.LogMsg('', 'Exception while listing CP Requests. '); {JK 10/5/2009 - Maggmsgu refactoring}
      t.Insert(0, '0^Exception while listing CP Requests. ');
    End;
  End;
End;

Procedure TMagDBMVista.RPGetTIUDAfromClinProcReq(DFN, FConsIEN, Vstring, Complete: String; Var t: TStrings);
Begin
    //  success := false;
  Try
    FBroker.REMOTEPROCEDURE := 'MAG4 CP CONSULT TO TIUDA';
    FBroker.PARAM[0].PTYPE := LITERAL;
    FBroker.PARAM[0].Value := DFN;
    FBroker.PARAM[1].PTYPE := LITERAL;
    FBroker.PARAM[1].Value := FConsIEN;
    FBroker.PARAM[3].PTYPE := LITERAL;
    FBroker.PARAM[3].Value := Complete;
    FBroker.PARAM[2].PTYPE := LITERAL;
    FBroker.PARAM[2].Value := Vstring;
    FBroker.LstCALL(t);
    If (MagPiece(t[0], '^', 1) = '0') Then
    Begin
            //LogMsg('', magpiece(t[0], '^', 2));
      MagLogger.LogMsg('', MagPiece(t[0], '^', 2)); {JK 10/5/2009 - Maggmsgu refactoring}
      Exit;
    End;
    If (t.Count = 0) Then
    Begin
            //LogMsg('', 'Error (#34) in VistA');
      MagLogger.LogMsg('', 'Error (#34) in VistA'); {JK 10/5/2009 - Maggmsgu refactoring}
      t.Add('0^Error (#34) in VistA');
      Exit;
    End;
        //    success := true;
        //     t.delete(0);
  Except
    On e: Exception Do
    Begin
            //LogMsg('', 'Exception (#34) in VistA');
      MagLogger.LogMsg('', 'Exception (#34) in VistA'); {JK 10/5/2009 - Maggmsgu refactoring}
      t.Insert(0, '0^Exception (#34) in VistA');
    End;
  End;

End;

Procedure TMagDBMVista.RPGetVisitListForReq(DFN: String; Var t: TStrings);
Begin
    //  success := false;
  Try
    FBroker.REMOTEPROCEDURE := 'MAG4 CP GET VISITS';
    FBroker.PARAM[0].PTYPE := LITERAL;
    FBroker.PARAM[0].Value := DFN;
    FBroker.LstCALL(t);
    If (MagPiece(t[0], '^', 1) = '0') Then
    Begin
            //LogMsg('', magpiece(t[0], '^', 2));
      MagLogger.LogMsg('', MagPiece(t[0], '^', 2)); {JK 10/5/2009 - Maggmsgu refactoring}
      Exit;
    End;
    If (t.Count = 0) Then
    Begin
            //LogMsg('', 'Error Listing Patient visits.');
      MagLogger.LogMsg('', 'Error Listing Patient visits.'); {JK 10/5/2009 - Maggmsgu refactoring}
      t.Add('0^Error Listing Patient visits.');
      Exit;
    End;
        //    success := true;

    t.Delete(0);
  Except
    On e: Exception Do
    Begin
            //LogMsg('', 'Exception Listing Patient visits.');
      MagLogger.LogMsg('', 'Exception Listing Patient visits.'); {JK 10/5/2009 - Maggmsgu refactoring}
      t.Insert(0, '0^Exception Listing Patient visits.');
    End;
  End;
End;

Procedure TMagDBMVista.RPMagVersionCheck(t: TStrings; Version: String);
Begin
  FBroker.REMOTEPROCEDURE := 'MAG4 VERSION CHECK';
  FBroker.PARAM[0].PTYPE := LITERAL;
  FBroker.PARAM[0].Value := Version;

  Try
    FBroker.LstCALL(t);
    If (t.Count = 0) Then
    Begin
      t.Insert(0, '1^continue');
            //LogMsg('', 'Error Checking Version on Server');
      MagLogger.LogMsg('', 'Error Checking Version on Server'); {JK 10/5/2009 - Maggmsgu refactoring}
      Exit;
    End;

  Except
    On e: Exception Do
    Begin
      t.Insert(0, '1^continue');
            //LogMsg('de', 'Exception ' + e.message);
      MagLogger.LogMsg('de', 'Exception ' + e.Message); {JK 10/5/2009 - Maggmsgu refactoring}
    End;
  End;
End;

Function TMagDBMVista.RPFileManDate(Var Xmsg: String; DateInput: String; Var DateOutput: String; NoFuture: Boolean = False): Boolean;
Var
  s: String;
Var
  X2, X3: String;
Begin
  Result := False;
  If Not FBroker.Connected Then
  Begin
    Xmsg := 'You must be connected to VistA to enable Date functions';
    Exit;
  End;
  DateOutput := '';
  s := DateInput;
  If Uppercase(s) = 'T' Then
    s := 'N';
  With FBroker Do
  Begin
    PARAM[0].PTYPE := LITERAL;
    PARAM[0].Value := s;
    If NoFuture Then
    Begin
      PARAM[1].PTYPE := LITERAL;
      PARAM[1].Value := '1';
    End;
    FBroker.REMOTEPROCEDURE := 'MAGG DTTM';
    Call;
    s := Results[0];
  End;
  If (s = '') Then
    s := '0^Error converting input to Date/Time';
  If (Copy(s, 1, 1) = '0') Then
  Begin
    DateOutput := '';
    Xmsg := MagPiece(s, '^', 2);
    Exit;
  End;
    // take out the seconds
  X2 := MagPiece(s, '^', 2);
  X3 := MagPiece(s, '^', 3);
  X2 := MagPiece(X2, ':', 1) + ':' + MagPiece(X2, ':', 2);
  X3 := Copy(X3, 1, 12);

  DateOutput := X2 + '^' + X3;
  Result := True;
End;

Procedure TMagDBMVista.RPXMultiProcList(Lit: TStrings; DFN: String); // proclist: Tstrings);
Var
  t: TStrings;
Begin
  Lit.Clear;
  t := Tstringlist.Create;
  FBroker.REMOTEPROCEDURE := 'MAG4 MULTI PROCEDURE LIST';
    // for now we get all
  FBroker.PARAM[0].PTYPE := List;
  FBroker.PARAM[0].Value := '.x';
  FBroker.PARAM[0].Mult['1'] := 'MED^ALL';
  FBroker.PARAM[0].Mult['2'] := 'LAB^ALL';
  FBroker.PARAM[0].Mult['3'] := 'RAD^ALL';
  FBroker.PARAM[0].Mult['4'] := 'SUR^ALL';
  FBroker.PARAM[0].Mult['5'] := 'TIU^ALL';
  FBroker.PARAM[1].PTYPE := LITERAL;
  FBroker.PARAM[1].Value := DFN;

  Try
    FBroker.LstCALL(t);
    If (t.Count = 0) Then
    Begin
      Lit.Add('<Error loading ''Procedure'' list>');
            //LogMsg('', 'Error loading Procedure listing.');
      MagLogger.LogMsg('', 'Error loading Procedure listing.'); {JK 10/5/2009 - Maggmsgu refactoring}
      Exit;
    End;

  Except
    On e: Exception Do
    Begin
      Lit.Add('<Exception loading ''Procedure'' list>');
            //LogMsg('', 'Exception loading Procedure listing');
      MagLogger.LogMsg('', 'Exception loading Procedure listing'); {JK 10/5/2009 - Maggmsgu refactoring}
      Exit;
    End;
  End;
  t.Delete(0);
  Lit.AddStrings(t);
  t.Free;
End;

Procedure TMagDBMVista.RPCTPresetsGet(Var Rstat: Boolean; Var Rmsg: String; Var Value: String);
Var
  Xmsg: String;
Begin
  Rstat := False;
  With FBroker Do
  Begin
    FBroker.REMOTEPROCEDURE := 'MAG4 CT PRESETS GET';
    FBroker.PARAM[0].PTYPE := LITERAL;
    FBroker.PARAM[0].Value := '2';
  End;
  Try
    Xmsg := FBroker.STRCALL;
    If (MagPiece(Xmsg, '^', 1) = '0') Or (Xmsg = '') Then
    Begin
      Rstat := False;
      If Xmsg <> '' Then
        Rmsg := MagPiece(Xmsg, '^', 2)
      Else
        Rmsg := 'VistA ERROR: Operation canceled.';
      Exit;
    End;
    Rstat := True;
    Rmsg := 'Success.';
    Value := MagPiece(Xmsg, '^', 2);
  Except
    On e: Exception Do
    Begin
      Rmsg := '0^ERROR (EXCEPTION) in VistA function.' + MagPiece(e.Message, #$A, 2);
      Rstat := False;
            //LogMsg('s', e.message);
      MagLogger.LogMsg('s', e.Message); {JK 10/5/2009 - Maggmsgu refactoring}
    End;
  End;
End;

Procedure TMagDBMVista.RPCTPresetsSave(Var Rstat: Boolean; Var Rmsg: String; Value: String);
Var
  Xmsg: String;
Begin
  Rstat := False;
  With FBroker Do
  Begin
    PARAM[0].PTYPE := LITERAL;
    PARAM[0].Value := Value;
    PARAM[1].PTYPE := LITERAL;
    PARAM[1].Value := '2';
    FBroker.REMOTEPROCEDURE := 'MAG4 CT PRESETS SAVE';
  End;
  Try
    Xmsg := FBroker.STRCALL;
    If (MagPiece(Xmsg, '^', 1) = '0') Or (Xmsg = '') Then
    Begin
      Rstat := False;
      If Xmsg <> '' Then
        Rmsg := MagPiece(Xmsg, '^', 2)
      Else
        Rmsg := 'VistA ERROR: Operation canceled.';
      Exit;
    End;
    Rstat := True;
    Rmsg := MagPiece(Xmsg, '^', 2);
  Except
    On e: Exception Do
    Begin
      Rmsg := '0^ERROR (EXCEPTION) in VistA function.' + MagPiece(e.Message, #$A, 2);
      Rstat := False;
            //LogMsg('s', e.message);
      MagLogger.LogMsg('s', e.Message); {JK 10/5/2009 - Maggmsgu refactoring}
    End;
  End;

End;

Procedure TMagDBMVista.RPFilterListGet(Var Rstat: Boolean; Var Rmsg: String; Var Tlist: TStrings; Duz: String = ''; Getall: Boolean = False);
Begin
  Rstat := False;
  With FBroker Do
  Begin
    PARAM[0].Value := Duz;
    PARAM[0].PTYPE := LITERAL;
    PARAM[1].Value := Magbooltostrint(Getall);
    PARAM[1].PTYPE := LITERAL;
    FBroker.REMOTEPROCEDURE := 'MAG4 FILTER GET LIST';
  End;
  Try
    FBroker.LstCALL(Tlist);
{$IFDEF DEMO CREATE}
    Tlist.SaveToFile(ExtractFilePath(Application.ExeName) + '\image\MagDemoFilterList' + Duz + '-' + Magbooltostrint(Getall) + '.txt');
{$ENDIF}

    If (MagPiece(Tlist[0], '^', 1) = '0') Or (Tlist.Count = 0) Then
    Begin
      Rstat := False;
      If Tlist.Count > 0 Then
        Rmsg := MagPiece(Tlist[0], '^', 2)
      Else
        Rmsg := 'ERROR: Health Summary Failed. Check VISTA Error Log.';
      Exit;
    End;
    Rstat := True;
    Rmsg := MagPiece(Tlist[0], '^', 2);
        //tlist.delete(0); now the default filter is returned in 0 node.
  Except
    On e: Exception Do
    Begin
      Tlist.Insert(0, '0^ERROR (EXCEPTION) in VistA function.');
      Rstat := False;
      Rmsg := 'ERROR (EXCEPTION) in VistA function:' + e.Message;
      Tlist.Insert(1, '0^' + MagPiece(e.Message, #$A, 2));
    End;
  End;
End;

Procedure TMagDBMVista.RPFilterDetailsGet(Var Rstat: Boolean; Var Rmsg, Filter: String; Fltien: String; Fltname: String = ''; Duz: String = '');
Var
  Vlist: TStrings;
Begin
  Vlist := Tstringlist.Create;
  Try
    Rstat := False;
    With FBroker Do
    Begin
      PARAM[0].Value := Fltien;
      PARAM[0].PTYPE := LITERAL;
      PARAM[1].Value := Fltname;
      PARAM[1].PTYPE := LITERAL;
      PARAM[2].Value := Duz;
      PARAM[2].PTYPE := LITERAL;
      FBroker.REMOTEPROCEDURE := 'MAG4 FILTER DETAILS';
    End;
    Try
      FBroker.LstCALL(Vlist);
{$IFDEF DEMO CREATE}
      Vlist.SaveToFile(ExtractFilePath(Application.ExeName) + '\image\MagDemoFilter' + Fltien + '.txt');
{$ENDIF}

      If (Vlist.Count = 0) Or (MagPiece(Vlist[0], '^', 1) = '0') Then
      Begin
        Rstat := False;
        If Vlist.Count > 0 Then
          Rmsg := MagPiece(Vlist[0], '^', 2)
        Else
          Rmsg := 'ERROR: Retrieving Filter Details Failed. Check VISTA Error Log.';
        Exit;
      End;
      Rstat := True;
      Rmsg := MagPiece(Vlist[0], '^', 2);
      Filter := Vlist[1];
            //vlist.delete(0);
    Except
      On e: Exception Do
      Begin
        Rmsg := 'ERROR (EXCEPTION) in VistA function.';
        Rstat := False;
                //LogMsg('s', 'ERROR (EXCEPTION) in VistA function:' + e.Message);
        MagLogger.LogMsg('s', 'ERROR (EXCEPTION) in VistA function:' + e.Message); {JK 10/5/2009 - Maggmsgu refactoring}
      End;
    End;
  Finally
    Vlist.Free;
  End;
End;

Procedure TMagDBMVista.RPFilterSave(Var Rstat: Boolean; Var Rmsg: String; t: TStrings);
Var
  i: Integer;
Begin
  Rstat := False;
  With FBroker Do
  Begin
    PARAM[0].PTYPE := List;
    PARAM[0].Value := '.x';
    For i := 0 To t.Count - 1 Do
      PARAM[0].Mult['' + Inttostr(i) + ''] := t[i];
    FBroker.REMOTEPROCEDURE := 'MAG4 FILTER SAVE';
  End;
  Try
    Rmsg := FBroker.STRCALL;
    If (MagPiece(Rmsg, '^', 1) = '0') Or (Rmsg = '') Then
    Begin
      Rstat := False;
      If (Rmsg = '') Then
        Rmsg := 'ERROR: Retrieving Filter Details Failed. Check VISTA Error Log.';
      Exit;
    End;
    Rstat := True;
        //rmsg := magpiece(rmsg, '^', 2);
        //vlist.delete(0);
  Except
    On e: Exception Do
    Begin
      Rmsg := 'ERROR (EXCEPTION) in VistA function.';
      Rstat := False;
            //LogMsg('s', 'ERROR (EXCEPTION) in VistA function:' + e.Message);
      MagLogger.LogMsg('s', 'ERROR (EXCEPTION) in VistA function:' + e.Message); {JK 10/5/2009 - Maggmsgu refactoring}
    End;
  End;
End;

Procedure TMagDBMVista.RPFilterDelete(Var Rstat: Boolean; Var Rmsg: String; Fltien: String);
Begin
    //  if not CheckDBConnection(xmsg) then
  Rstat := False;
  With FBroker Do
  Begin
    PARAM[0].PTYPE := LITERAL;
    PARAM[0].Value := Fltien;
    FBroker.REMOTEPROCEDURE := 'MAG4 FILTER DELETE';
  End;
  Try
    Rmsg := FBroker.STRCALL;
    If (MagPiece(Rmsg, '^', 1) = '0') Or (Rmsg = '') Then
    Begin
      Rstat := False;
      If (Rmsg <> '') Then
        Rmsg := MagPiece(Rmsg, '^', 2)
      Else
        Rmsg := 'ERROR: Deleting Image Filter. Check VISTA Error Log.';
      Exit;
    End;
    Rstat := True;
    Rmsg := MagPiece(Rmsg, '^', 2);
        //vlist.delete(0);
  Except
    On e: Exception Do
    Begin
      Rmsg := 'ERROR (EXCEPTION) in VistA function.';
      Rstat := False;
            //LogMsg('s', 'ERROR (EXCEPTION) in VistA function:' + e.Message);
      MagLogger.LogMsg('s', 'ERROR (EXCEPTION) in VistA function:' + e.Message); {JK 10/5/2009 - Maggmsgu refactoring}
    End;
  End;
End;

Function TMagDBMVista.IsConnected: Boolean;
Begin
  If Assigned(FBroker) Then
    Result := FBroker.Connected
  Else
    Result := False;
End;

Procedure TMagDBMVista.SetConnected(Const Value: Boolean);
Begin
  If Assigned(FBroker) Then
    FBroker.Connected := Value;
End;

Function TMagDBMVista.GetListenerPort: Integer;
Begin
  If Assigned(FBroker) Then
    Result := FBroker.ListenerPort
  Else
    Result := 0;
End;

Function TMagDBMVista.GetServer: String;
Begin
  If Assigned(FBroker) Then
    Result := FBroker.Server
  Else
    Result := '';
End;

Procedure TMagDBMVista.SetListenerPort(Const Value: Integer);
Begin
  If Assigned(FBroker) Then
    FBroker.ListenerPort := Value;
End;

Procedure TMagDBMVista.SetServer(Const Value: String);
Begin
  If Assigned(FBroker) Then
    FBroker.Server := Value;
End;

Procedure TMagDBMVista.RPMaggInstall(Var Fstat: Boolean; Var Flist: Tstringlist);
Begin
  If (FBroker = Nil) Or (Not FBroker.Connected) Then
  Begin
    Flist.Add('0^No connection to the Server');
    Exit;
  End;
  Flist.Clear;
  Fstat := False;
  FBroker.REMOTEPROCEDURE := 'MAGG INSTALL';
  Try
    FBroker.LstCALL(Flist);
    If (Flist.Count = 0) Or (MagPiece(Flist[0], '^', 1) = '0') Then
      Exit;
    Fstat := True;
    If Maglength(Flist[0], '~') = 1 Then // This is old M code, not returning '~' codes for columns;
      Flist[0] := 'Server Versions  ^Install Date     ~S1'; // this sort code 'S1' says that this column is Dates.
  Except
    On e: Exception Do
    Begin
      Flist.Insert(0, '0^' + MagPiece(e.Message, #$A, 2));
    End;
  End;
End;
//46

Procedure TMagDBMVista.RPMag4FieldValueGet(Var Fstat: Boolean; Var Fmsg: String;
  Var Flist: Tstringlist; Ien: String; Flags: String = ''; Flds: String = '');
// var I: integer;
Begin
  If (FBroker = Nil) Or (Not FBroker.Connected) Then
  Begin
    Fstat := False;
    Fmsg := 'No connection to the Server';
    Exit;
  End;
  Flist.Clear;
  Fstat := False;
  FBroker.REMOTEPROCEDURE := 'MAG4 FIELD VALUE GET';
  Try
    FBroker.PARAM[0].Value := '2005';
    FBroker.PARAM[0].PTYPE := LITERAL;
    FBroker.PARAM[1].Value := Ien;
    FBroker.PARAM[1].PTYPE := LITERAL;
    FBroker.PARAM[2].Value := Flds;
    FBroker.PARAM[2].PTYPE := LITERAL;
    FBroker.PARAM[3].Value := Flags;
    FBroker.PARAM[3].PTYPE := LITERAL;
    FBroker.LstCALL(Flist);
    If (Flist.Count = 0) Or (MagPiece(Flist[0], '^', 1) = '0') Then
      Exit;
    Fstat := True;
    Fmsg := MagPiece(Flist[0], '^', 2);
    Flist.Delete(0);

  Except
    On e: Exception Do
    Begin
      Fstat := False;
      Fmsg := MagPiece(e.Message, #$A, 2);
            //Flist.Insert(0, '0^' + magpiece(e.message, #$A, 2));
    End;
  End;
End;

Procedure TMagDBMVista.RPMag4FieldValueSet(Var Fstat: Boolean; Var Fmsg: String; Var Flist: Tstringlist; t: Tstringlist);
Var
  i: Integer;
Begin
  Fstat := False;
  FBroker.PARAM[0].Value := '.X';
  FBroker.PARAM[0].PTYPE := List;
  FBroker.REMOTEPROCEDURE := 'MAG4 FIELD VALUE SET';
  For i := 0 To t.Count - 1 Do
  Begin
        //dec(i);
    FBroker.PARAM[0].Mult[('"TEXT' + Copy('00000000', 1, 8 - Length(Inttostr(i))) + Inttostr(i) + '"')] := t[i];
  End;
  Try
    FBroker.LstCALL(Flist);
    If MagPiece(Flist[0], '^', 1) = '2' Then
    Begin
      Flist.Delete(0);
      Flist[0] := MagInsertPiece(Flist[0], '^', 1, '0');
    End;
    If (MagPiece(Flist[0], '^', 1) = '0') Or (Flist.Count = 0) Then
    Begin
      Fstat := False;
      If Flist.Count > 0 Then
        Fmsg := MagPiece(Flist[0], '^', 2)
      Else
        Fmsg := 'ERROR in VistA operation canceled.';
      Exit;
    End;
    Fstat := True;
    Fmsg := MagPiece(Flist[0], '^', 2);
        //tlist.delete(0);
  Except
    On e: Exception Do
    Begin
      Flist.Insert(0, '0^ERROR (EXCEPTION) in VistA function.');
      Fstat := False;
      Fmsg := 'ERROR (EXCEPTION) in VistA function:' + e.Message;
      Flist.Insert(1, '0^' + MagPiece(e.Message, #$A, 2));
    End;
  End;
End;
//RPMag4FieldValueSet(rstat,rlist,t);

(*
  for j := 1 to count do
    begin
      dec(i);
    //xBrokerx.Param[3].Mult['"TEXT'+','+INTTOSTR(I+1)+',0"']:=NOTETEXT[I];
      FBroker.Param[0].Mult[('"TEXT' + COPY('000', 1, 3 - LENGTH(INTTOSTR(I))) + IntToStr(i) + '"')] := t[i];
    end;
*)

Procedure TMagDBMVista.RPTIUisThisaConsult(Var Fstat: Boolean; Var Fmsg: String; Titleda: String);
Var //I: integer;
  Resstr: String;
Begin
  If (FBroker = Nil) Or (Not FBroker.Connected) Then
  Begin
    Fstat := False;
    Fmsg := 'No connection to the Server';
    Exit;
  End;
    // Flist.clear;
  Fstat := False;
  FBroker.REMOTEPROCEDURE := 'TIU IS THIS A CONSULT?';
  Try
    FBroker.PARAM[0].Value := Titleda;
    FBroker.PARAM[0].PTYPE := LITERAL;
        //        Fbroker.param[1].Value := flds;
        //        Fbroker.param[1].PType := literal;
        //        Fbroker.param[2].Value := flags;
        //        Fbroker.param[2].PType := literal;

    LogRPCParams;
        //    resstr := Fbroker.strCall;
    FBroker.Call;
    LogRPCResult;
    Resstr := FBroker.Results[0];
    If Resstr = '0' Then
      Exit;
    Fstat := True;
    Fmsg := 'it is a Consult Title';

  Except
    On e: Exception Do
    Begin
      Fstat := False;
      Fmsg := MagPiece(e.Message, #$A, 2);
            //Flist.Insert(0, '0^' + magpiece(e.message, #$A, 2));
    End;
  End;
End;

Procedure TMagDBMVista.LogRPCParams;
Var
  t: Tstringlist;
  i, j: Integer;
  x, y: String;
Begin
    (* with maggmsgf do
       begin
        magmsg('s','RPC Params: ' + Fbroker.remoteprocedure);
        for i := 0 to fbroker.Param.Count -1 do
          begin
          magmsg('s','['+inttostr(i) + '] = '+fbroker.Param[i].value);
          end;
       end;
     *)

  t := Tstringlist.Create;
  Try //RLM Fixing MemoryLeak 6/18/2010
    t.Add(' ');
    t.Add(' --------- Params ------- for RPC : -- ' + FBroker.REMOTEPROCEDURE);
    t.Add(' --------- Broker.clearParams  =  ' + Magbooltostr(FBroker.ClearParameters));
    t.Add(' --------- Broker.clearResults =  ' + Magbooltostr(FBroker.ClearResults));
    With FBroker Do
      For i := 0 To PARAM.Count - 1 Do
      Begin
        Case PARAM[i].PTYPE Of
                  //global:    x := 'global';
          List: x := 'list';
          LITERAL: x := 'literal';
                  //null:      x := 'null';
          Reference: x := 'reference';
          Undefined: x := 'undefined';
                  //wordproc:  x := 'wordproc';
        End;
        t.Add(x + #9 + PARAM[i].Value);
        If PARAM[i].PTYPE = List Then
        Begin
          For j := 0 To PARAM[i].Mult.Count - 1 Do
          Begin
            x := PARAM[i].Mult.Subscript(j);
            y := PARAM[i].Mult[x];
            t.Add(#9 + '(' + x + ')=' + y);
          End;
        End;
      End;
      //LogMsg('s', t);
    MagLogger.LogMsgs('s', t); {JK 10/5/2009 - Maggmsgu refactoring}
  Finally //RLM Fixing MemoryLeak 6/18/2010
    FreeAndNil(t); //RLM Fixing MemoryLeak 6/18/2010
  End; //RLM Fixing MemoryLeak 6/18/2010
End;

Procedure TMagDBMVista.LogRPCResult(s: String);
Begin
  MagLogger.LogMsg('s', ' --------- Results --------- string ');
  MagLogger.LogMsg('s', s);
  MagLogger.LogMsg('s', ' --------- End Results  -------- RPC : ' + FBroker.REMOTEPROCEDURE);

(*    94T1 - 94t13 changes above,
    //LogMsg('s', ' --------- Results --------- ');
    MagLogger.LogMsg('s', ' --------- Results --------- '); {JK 10/5/2009 - Maggmsgu refactoring}
    //LogMsg('s', s);
    MagLogger.LogMsg('s', s); {JK 10/5/2009 - Maggmsgu refactoring}
    //Logmsg('s', ' --------- End Results  --------- ' + Fbroker.RemoteProcedure);
    MagLogger.Logmsg('s', ' --------- End Results  --------- ' + Fbroker.RemoteProcedure); {JK 10/5/2009 - Maggmsgu refactoring}
    *)
End;

Procedure TMagDBMVista.LogRPCResult(t: TStrings);
Var
  i: Integer;
Begin

    //Logmsg('s', ' --------- Results --------- ');
  MagLogger.LogMsg('s', ' --------- Results --------- tstrings'); {JK 10/5/2009 - Maggmsgu refactoring}
  For i := 0 To t.Count - 1 Do
  Begin
        //LogMsg('s', t[i]);
    MagLogger.LogMsg('s', t[i]); {JK 10/5/2009 - Maggmsgu refactoring}
  End;
    //Logmsg('s', ' --------- End Results  --------- ' + Fbroker.RemoteProcedure);
  MagLogger.LogMsg('s', ' --------- End Results  --------- ' + FBroker.REMOTEPROCEDURE); {JK 10/5/2009 - Maggmsgu refactoring}
End;

Procedure TMagDBMVista.LogRPCResult;
Var
  i: Integer;
Begin
    //Logmsg('s', ' --------- Results --------- ');
  MagLogger.LogMsg('s', ' --------- Results --------- .Results[] '); {JK 10/5/2009 - Maggmsgu refactoring}

    //  maggmsgf.magmsgs('s', Fbroker.Results.strings);

  For i := 0 To FBroker.Results.Count - 1 Do
  Begin
        //Logmsg('s', Fbroker.Results[i]);
    MagLogger.LogMsg('s', FBroker.Results[i]); {JK 10/5/2009 - Maggmsgu refactoring}
  End;
    //Logmsg('s', ' --------- End Results  --------- ' + Fbroker.RemoteProcedure);
  MagLogger.LogMsg('s', ' --------- End Results  --------- ' + FBroker.REMOTEPROCEDURE); {JK 10/5/2009 - Maggmsgu refactoring}

    {  AStringList.Add(' ');
     AStringList.Add('Results -----------------------------------------------------------------');
     AStringList.AddStrings(RPCBrokerV.Results);}

End;

Procedure TMagDBMVista.LogRPCException(Errstring: String);
Begin
    //Logmsg('s', ' --------- RPC Exception ---- ' + Fbroker.RemoteProcedure + ' ---- ');
  MagLogger.LogMsg('s', ' --------- RPC Exception ---- ' + FBroker.REMOTEPROCEDURE + ' ---- '); {JK 10/5/2009 - Maggmsgu refactoring}
    //Logmsg('s', 'Error: ' + errstring);
  MagLogger.LogMsg('s', 'Error: ' + Errstring); {JK 10/5/2009 - Maggmsgu refactoring}
    //Logmsg('s', ' --------- End Exception --------- ');
  MagLogger.LogMsg('s', ' --------- End Exception --------- '); {JK 10/5/2009 - Maggmsgu refactoring}

End;

Procedure TMagDBMVista.RPGMRCListConsultRequests(Var Fstat: Boolean; Var Fmsg: String; Var Flist: Tstringlist; DFN: String);
Var
  i: Integer;
  s, Tmps: String;
Begin
  If (FBroker = Nil) Or (Not FBroker.Connected) Then
  Begin
    Fstat := False;
    Fmsg := 'No connection to the Server';
    Exit;
  End;
  Flist.Clear;
  Fstat := False;
  FBroker.REMOTEPROCEDURE := 'GMRC LIST CONSULT REQUESTS';
  Try
    FBroker.PARAM[0].Value := DFN;
    FBroker.PARAM[0].PTYPE := LITERAL;
        //  Fbroker.param[1].Value := flds;
        //  Fbroker.param[1].PType := literal;
         // Fbroker.param[2].Value := flags;
        //  Fbroker.param[2].PType := literal;
      //Fbroker.lstCall(Flist);
    LogRPCParams;
    FBroker.Call;
    LogRPCResult;
    Flist.Assign(FBroker.Results);
    If (Flist.Count = 0) Or (MagPiece(Flist[0], '^', 1) = '0') Then
      Exit;
    Fstat := True;
    Fmsg := 'List of Consults'; //magpiece(Flist[0],'^',2);
    Flist.Delete(0);
    Flist.Insert(0, 'Consult Request Date^Service^Procedure^Status^#Notes^');
    For i := 1 To Flist.Count - 1 Do
    Begin
            {reformat the list into " ^^^ | ien "   format}
      s := Flist[i];
      Tmps := FmtoDispDt(MagPiece(s, '^', 2)) + '^' +
        MagPiece(s, '^', 3) + '^' +
        MagPiece(s, '^', 4) + '^' +
        MagPiece(s, '^', 5) + '^' +
        MagPiece(s, '^', 6) + '|' +
        MagPiece(s, '^', 1);
      Flist[i] := Tmps;

    End;
  Except
    On e: Exception Do
    Begin
      Fstat := False;
      Fmsg := MagPiece(e.Message, #$A, 2);
            //Flist.Insert(0, '0^' + magpiece(e.message, #$A, 2));
    End;
  End;
End;

Procedure TMagDBMVista.RPTIULoadBoilerplateText(Var Fstat: Boolean;
  Var Fmsg: String; Var Flist: Tstringlist; Titleda, DFN: String);
// var I: integer;
Begin
  If (FBroker = Nil) Or (Not FBroker.Connected) Then
  Begin
    Fstat := False;
    Fmsg := 'No connection to the Server';
    Exit;
  End;
  Flist.Clear;
  Fstat := False;
  FBroker.REMOTEPROCEDURE := 'TIU LOAD BOILERPLATE TEXT';
  Try
    FBroker.PARAM[0].Value := Titleda;
    FBroker.PARAM[0].PTYPE := LITERAL;
    FBroker.PARAM[1].Value := DFN;
    FBroker.PARAM[1].PTYPE := LITERAL;
    FBroker.LstCALL(Flist);
        //  if (Flist.Count = 0) or (magpiece(Flist[0], '^', 1) = '0') then exit;
    If (Flist.Count = 0) Then
    Begin
      Fmsg := 'No BoilerPlate Text for Title : ' + Titleda;
      Exit;
    End;
    Fstat := True;

    Fmsg := 'BoilerPlate Text loaded.';
        //    Flist.delete(0);

  Except
    On e: Exception Do
    Begin
      Fstat := False;
      Fmsg := MagPiece(e.Message, #$A, 2);
            //Flist.Insert(0, '0^' + magpiece(e.message, #$A, 2));
    End;
  End;
End;

Procedure TMagDBMVista.RPTIUAuthorization(Var Fstat: Boolean;
  Var Fmsg: String; TiuDA, action: String);
Var //I: integer;
  Resstr: String;
Begin
  If (FBroker = Nil) Or (Not FBroker.Connected) Then
  Begin
    Fstat := False;
    Fmsg := 'No connection to the Server';
    Exit;
  End;
  Fstat := False;
  FBroker.REMOTEPROCEDURE := 'TIU AUTHORIZATION';
  Try
    FBroker.PARAM[0].Value := TiuDA;
    FBroker.PARAM[0].PTYPE := LITERAL;
    FBroker.PARAM[1].Value := action;
    FBroker.PARAM[1].PTYPE := LITERAL;

        //  resstr := Fbroker.strcall;
    LogRPCParams;
    FBroker.Call;
    LogRPCResult;
    Resstr := FBroker.Results[0];
    If MagPiece(Resstr, '^', 1) = '0' Then
    Begin
      Fmsg := MagPiece(Resstr, '^', 2);
      Fstat := False;
      Exit;
    End;
    Fstat := True;

    Fmsg := 'Action: ' + action + ' is Authorized';
        //    Flist.delete(0);

  Except
    On e: Exception Do
    Begin
      Fstat := False;
      Fmsg := MagPiece(e.Message, #$A, 2);
            //Flist.Insert(0, '0^' + magpiece(e.message, #$A, 2));
    End;
  End;

End;

Procedure TMagDBMVista.RPMagVersionStatus(Var Status: String; Version: String);
Begin
  If (FBroker = Nil) Or (Not FBroker.Connected) Then
  Begin
    Status := '1^Status is unavailable.';
    Exit;
  End;
  FBroker.REMOTEPROCEDURE := 'MAG4 VERSION STATUS';
  FBroker.PARAM[0].PTYPE := LITERAL;
  FBroker.PARAM[0].Value := Version;

  Try
    Status := FBroker.STRCALL;
    If (Status = '') Then
    Begin
      Status := '1^Error trying to determine status';
            //LogMsg('', 'Error Checking Status of Version: ' + version);
      MagLogger.LogMsg('', 'Error Checking Status of Version: ' + Version); {JK 10/5/2009 - Maggmsgu refactoring}
      Exit;
    End;

  Except
    On e: Exception Do
    Begin
      Status := '1^Error trying to determine status';
            //LogMsg('de', 'Exception ' + e.message);
      MagLogger.LogMsg('de', 'Exception ' + e.Message); {JK 10/5/2009 - Maggmsgu refactoring}
    End;
  End;
End;
{================ =====================}
function TMagDBMVista.RPPatientHasPhoto(DFN: String; var Stat: Boolean; var FMsg: String): String;
var
  ResStr: String;
begin
  Result := '0';
  Stat   := False;
  FMsg   := '';

  if (FBroker = nil) or (not FBroker.Connected) then
  begin
      FMsg   := 'No connection to the server';
      Stat   := False;
      Result := '0';
      Exit;
  end;

  Result := '0';
  FBroker.RemoteProcedure := 'MAGN PATIENT HAS PHOTO';

  FBroker.Param[0].Value := DFN;
  FBroker.Param[0].PType := Literal;

  try
    FBroker.Call;
    ResStr := MagPiece(FBroker.Results[0], '^', 1);
    Result := ResStr;
    Stat   := True;
  except
    on E:Exception do
    begin
      Result := '0';
      Stat   := False;
      FMsg   := E.Message;
    end;
  end;
end;
{
procedure CallBrokerInContext;
var
 AStringList: TStringList;
 i, j: Integer;
 x, y: string;
begin

 AStringList := TStringList.Create;
 AStringList.Add(RPCBrokerV.RemoteProcedure);

 AStringList.Add(' ');
 AStringList.Add('Params ------------------------------------------------------------------');
 with RPCBrokerV do for i := 0 to Param.Count - 1 do
 begin
   case Param[i].PType of
   //global:    x := 'global';
   list:      x := 'list';
   literal:   x := 'literal';
   //null:      x := 'null';
   reference: x := 'reference';
   undefined: x := 'undefined';
   //wordproc:  x := 'wordproc';
   end;
   AStringList.Add(x + #9 + Param[i].Value);
   if Param[i].PType = list then
   begin
     for j := 0 to Param[i].Mult.Count - 1 do
     begin
       x := Param[i].Mult.Subscript(j);
       y := Param[i].Mult[x];
       AStringList.Add(#9 + '(' + x + ')=' + y);
     end;
   end;
 end; //with...for
 //RPCBrokerV.Call;

 AStringList.Add(' ');
 AStringList.Add('Results -----------------------------------------------------------------');
 AStringList.AddStrings(RPCBrokerV.Results);
end;
}
{================ =====================}

{================ =====================}

{
procedure CallBrokerInContext;
var
 AStringList: TStringList;
 i, j: Integer;
 x, y: string;
begin
 RPCLastCall := RPCBrokerV.RemoteProcedure + ' (CallBroker begin)';
 if uShowRPCs then StatusText(RPCBrokerV.RemoteProcedure);
 with RPCBrokerV do if not Connected then  // Happens if broker connection is lost.
 begin
   ClearResults := True;
   Exit;
 end;
 if uCallList.Count = uMaxCalls then
 begin
   AStringList := uCallList.Items[0];
   AStringList.Free;
   uCallList.Delete(0);
 end;
 AStringList := TStringList.Create;
 AStringList.Add(RPCBrokerV.RemoteProcedure);
 if uCurrentContext <> uBaseContext then
   AStringList.Add('Context: ' + uCurrentContext);
 AStringList.Add(' ');
 AStringList.Add('Params ------------------------------------------------------------------');
 with RPCBrokerV do for i := 0 to Param.Count - 1 do
 begin
   case Param[i].PType of
   //global:    x := 'global';
   list:      x := 'list';
   literal:   x := 'literal';
   //null:      x := 'null';
   reference: x := 'reference';
   undefined: x := 'undefined';
   //wordproc:  x := 'wordproc';
   end;
   AStringList.Add(x + #9 + Param[i].Value);
   if Param[i].PType = list then
   begin
     for j := 0 to Param[i].Mult.Count - 1 do
     begin
       x := Param[i].Mult.Subscript(j);
       y := Param[i].Mult[x];
       AStringList.Add(#9 + '(' + x + ')=' + y);
     end;
   end;
 end; //with...for
 //RPCBrokerV.Call;
 try
   RPCBrokerV.Call;
 except
   // The broker erroneously sets connected to false if there is any error (including an
   // error on the M side). It should only set connection to false if there is no connection.
   on E:EBrokerError do
   begin
     if E.Code = XWB_M_REJECT then
     begin
       x := 'An error occurred on the server.' + CRLF + CRLF + E.Action;
       Application.MessageBox(PChar(x), 'Server Error', MB_OK);
     end
     else raise;
   (*
     case E.Code of
     XWB_M_REJECT:  begin
                      x := 'An error occurred on the server.' + CRLF + CRLF + E.Action;
                      Application.MessageBox(PChar(x), 'Server Error', MB_OK);
                    end;
     else           begin
                      x := 'An error occurred with the network connection.' + CRLF +
                           'Action was: ' + E.Action + CRLF + 'Code was: ' + E.Mnemonic +
                           CRLF + CRLF + 'Application cannot continue.';
                      Application.MessageBox(PChar(x), 'Network Error', MB_OK);
                    end;
     end;
     *)
     // make optional later...
     if not RPCBrokerV.Connected then Application.Terminate;
   end;
 end;
 AStringList.Add(' ');
 AStringList.Add('Results -----------------------------------------------------------------');
 AStringList.AddStrings(RPCBrokerV.Results);
 uCallList.Add(AStringList);
 if uShowRPCs then StatusText('');
 RPCLastCall := RPCBrokerV.RemoteProcedure + ' (completed)';
end;
}

Function TMagDBMVista.RPMaggIsDocClass(Ien, Fmfile, ClassName: String; Var Stat: Boolean; Var Fmsg: String): Boolean;
Var
  Resstr: String;
Begin
  Result := False;
  Stat := False;
  If (FBroker = Nil) Or (Not FBroker.Connected) Then
  Begin
    Fmsg := 'No connection to the Server';
    Exit;
  End;

  FBroker.REMOTEPROCEDURE := 'MAGG IS DOC CLASS';
  Try
    FBroker.PARAM[0].Value := Ien;
    FBroker.PARAM[0].PTYPE := LITERAL;
    FBroker.PARAM[1].Value := Fmfile;
    FBroker.PARAM[1].PTYPE := LITERAL;
    FBroker.PARAM[2].Value := ClassName;
    FBroker.PARAM[2].PTYPE := LITERAL;

    LogRPCParams;
        //    resstr := Fbroker.strCall;

    FBroker.Call;
    Stat := True;
    LogRPCResult;
    Resstr := MagPiece(FBroker.Results[0], '^', 1);
    Fmsg := MagPiece(FBroker.Results[0], '^', 2);
    If Resstr = '0' Then
      Exit;
    Result := True;
    Stat := True;
    Fmsg := 'is a ' + ClassName + ' title';

  Except
    On e: Exception Do
    Begin
      Result := False;
      Stat := False;
      Fmsg := e.Message;
    End;
  End;
End;

Function TMagDBMVista.GetUserSSN(): String;
Var
  SSN: String;
Begin
  FBroker.REMOTEPROCEDURE := 'XWB GET VARIABLE VALUE';
  FBroker.PARAM[0].Value := '^VA(200,' + FBroker.User.Duz + ',1)';
  FBroker.PARAM[0].PTYPE := Reference;
  SSN := FBroker.STRCALL;
  Result := MagPiece(SSN, '^', 9);
End;
//46

Function TMagDBMVista.RPMagGetTeleReader(Var t: TStrings; Var Xmsg: String): Boolean;
Begin
  Result := True;
  Xmsg := '';
  FBroker.REMOTEPROCEDURE := 'MAG DICOM CON GET TELE READER';
  Try
    FBroker.LstCALL(t);
  Except
    On e: Exception Do
    Begin
      Xmsg := e.Message;
      Result := False;
    End;
  End;
End;
//46

Function TMagDBMVista.RPMagSetTeleReader(Var Xmsg: String; Sitecode: String; SpecialtyCode: String; ProcedureCode: String;
  UserWants: String): Boolean;
Begin
  Result := True;
  FBroker.REMOTEPROCEDURE := 'MAG DICOM CON SET TELE READER';
  FBroker.PARAM[0].PTYPE := LITERAL;
  FBroker.PARAM[0].Value := Sitecode; //  MagRemoteBrokerManager1.LocalSiteCode;// Specialty.SpecialtyIEN;
  FBroker.PARAM[1].PTYPE := LITERAL;
  FBroker.PARAM[1].Value := SpecialtyCode;
  FBroker.PARAM[2].PTYPE := LITERAL;
  FBroker.PARAM[2].Value := ProcedureCode;
  FBroker.PARAM[3].PTYPE := LITERAL;
  FBroker.PARAM[3].Value := UserWants;
  Try
    Xmsg := FBroker.STRCALL();
  Except
    On e: Exception Do
    Begin
      Result := False;
      Xmsg := e.Message;
    End;
  End; {try}

End;
//46

Function TMagDBMVista.RPMagTeleReaderUnreadlistGet(Var t: TStrings; Var Xmsg: String; AcquisitionPrimaryDivision, Sitecode, SpecialtyCode, ProcedureStrings,
  LastUpdate, UserDUZ, LocalSiteCode, SiteTimeOut, StatusOptions: String): Boolean;
Var
  RemoteBroker: IMagRemoteBroker;
  s: String;
  p: Integer;
Begin
  Result := True;
  Xmsg := '';
    //  if SiteCode = MagRemoteBrokerManager1.LocalSiteCode then
  Try
    If AcquisitionPrimaryDivision = MagRemoteBrokerManager1.LocalPrimaryDivision Then
    Begin
      s := FBroker.Server;
      p := FBroker.ListenerPort;
      FBroker.REMOTEPROCEDURE := 'MAG DICOM CON UNREADLIST GET';
      FBroker.PARAM[0].PTYPE := LITERAL;
      FBroker.PARAM[0].Value := Sitecode;
      FBroker.PARAM[1].PTYPE := LITERAL;
      FBroker.PARAM[1].Value := SpecialtyCode;
      FBroker.PARAM[2].PTYPE := LITERAL;
      FBroker.PARAM[2].Value := ProcedureStrings;
      FBroker.PARAM[3].PTYPE := LITERAL;
      FBroker.PARAM[3].Value := LastUpdate;
            // New method to only show work items the user can do something with
      FBroker.PARAM[4].PTYPE := LITERAL;
      FBroker.PARAM[4].Value := UserDUZ;
      FBroker.PARAM[5].PTYPE := LITERAL;
      FBroker.PARAM[5].Value := LocalSiteCode;
            // Timeout stuff, to remove old locked items that have been locked for too long
      FBroker.PARAM[6].PTYPE := LITERAL;
      FBroker.PARAM[6].Value := SiteTimeOut;
            // status options
      FBroker.PARAM[7].PTYPE := LITERAL;
      FBroker.PARAM[7].Value := StatusOptions;
      FBroker.LstCALL(t);
    End
    Else
    Begin
      RemoteBroker := MagRemoteBrokerManager1.GetBroker(AcquisitionPrimaryDivision);
      If RemoteBroker = Nil Then
      Begin
        Result := False;
        Xmsg := 'Remote connection for site [' + Sitecode + '] is disconnected, will not load reading list from this site.';
        Exit;
      End;
      s := RemoteBroker.GetServerName;
      p := RemoteBroker.GetServerPort;
      RemoteBroker.RPMagTeleReaderUnreadlistGet(t, AcquisitionPrimaryDivision,
        Sitecode, SpecialtyCode, ProcedureStrings, LastUpdate, UserDUZ,
        LocalSiteCode, SiteTimeOut, StatusOptions);
    End;

        (*
          //tempBroker := MagRemoteBrokerManager1.getBroker(SiteCode);
          tempBroker := MagRemoteBrokerManager1.getRPCBroker(AcquisitionPrimaryDivision);
          if tempBroker = nil then
          begin
            result := false;
            xmsg := 'Remote connection for site [' + SiteCode + '] is disconnected, will not load reading list from this site.';
            exit;
          end;
        end;

        *)

  Except
    On e: Exception Do
    Begin
      //Showmessage(e.Message + ' Error at site [' + Sitecode + ']');
      //p106 rlm 20101229 CR640 "Title of Dialog box"
      MagLogger.MagMsg(
        'de',
        e.Message + ' Error at site [' + Sitecode + ']',
        Nil);
      Xmsg := 'Error getting read/unread list from site (' + s + ',' + Inttostr(p) + ') Exception=[' + e.Message + ']';
      If Sitecode <> MagRemoteBrokerManager1.LocalSiteCode Then
      Begin
                //LogMsg('s', 'Disconnecting remote site [' + SiteCode + ']');
        MagLogger.LogMsg('s', 'Disconnecting remote site [' + Sitecode + ']'); {JK 10/5/2009 - Maggmsgu refactoring}
        MagRemoteBrokerManager1.DisconnectRemoteBroker(Sitecode);
      End;
      Result := False;
      Exit;
    End;
  End; {try}
End;
//46

Function TMagDBMVista.RPMagTeleReaderUnreadlistLock(Var Xmsg: String; AcquisitionPrimaryDivision, AcquisitionSiteCode, ItemID, LockUnlockValue, UserFullName,
  UserInitials, LocalDUZ, LocalSiteCode: String): Boolean;
Var
  RemoteDUZ: String;
  RemoteBroker: IMagRemoteBroker;
Begin
  Result := True;
  Xmsg := '';
  Try
    If AcquisitionPrimaryDivision = MagRemoteBrokerManager1.LocalPrimaryDivision Then
    Begin
      RemoteDUZ := FBroker.User.Duz;
            //LogMsg('s', 'Locking/Unlocking work item [' + ItemID + '] at Acq Site [' + AcquisitionSiteCode + '], Primary division [' +
            //    AcquisitionPrimaryDivision + ']');
      MagLogger.LogMsg('s', 'Locking/Unlocking work item [' + ItemID + '] at Acq Site [' + AcquisitionSiteCode + '], Primary division [' +
        AcquisitionPrimaryDivision + ']'); {JK 10/5/2009 - Maggmsgu refactoring}
            //LogMsg('s', 'User local DUZ [' + LocalDUZ + '], Acq Site DUZ [' + RemoteDUZ + ']');
      MagLogger.LogMsg('s', 'User local DUZ [' + LocalDUZ + '], Acq Site DUZ [' + RemoteDUZ + ']'); {JK 10/5/2009 - Maggmsgu refactoring}
      FBroker.REMOTEPROCEDURE := 'MAG DICOM CON UNREADLIST LOCK';
      FBroker.PARAM[0].Value := ItemID;
      FBroker.PARAM[0].PTYPE := LITERAL;

      FBroker.PARAM[1].Value := LockUnlockValue;
      FBroker.PARAM[1].PTYPE := LITERAL;

      FBroker.PARAM[2].Value := UserFullName;
      FBroker.PARAM[2].PTYPE := LITERAL;

      FBroker.PARAM[3].Value := UserInitials;
      FBroker.PARAM[3].PTYPE := LITERAL;

      FBroker.PARAM[4].Value := RemoteDUZ;
      FBroker.PARAM[4].PTYPE := LITERAL;

      FBroker.PARAM[5].Value := LocalDUZ;
      FBroker.PARAM[5].PTYPE := LITERAL;

      FBroker.PARAM[6].Value := LocalSiteCode;
      FBroker.PARAM[6].PTYPE := LITERAL;
      Xmsg := FBroker.STRCALL;
    End
    Else
    Begin
            // JMW P46T28 2/16/2007
            // Use the acquisition sites primary division to find the DUZ
      RemoteDUZ := MagRemoteBrokerManager1.GetRemoteUserDUZ(AcquisitionPrimaryDivision);

            //LogMsg('s', 'Locking/Unlocking work item [' + ItemID + '] at Acq Site [' + AcquisitionSiteCode + '], Primary division [' +
            //    AcquisitionPrimaryDivision + ']');
      MagLogger.LogMsg('s', 'Locking/Unlocking work item [' + ItemID + '] at Acq Site [' + AcquisitionSiteCode + '], Primary division [' +
        AcquisitionPrimaryDivision + ']'); {JK 10/5/2009 - Maggmsgu refactoring}
            //LogMsg('s', 'User local DUZ [' + LocalDUZ + '], Acq Site DUZ [' + RemoteDUZ + ']');
      MagLogger.LogMsg('s', 'User local DUZ [' + LocalDUZ + '], Acq Site DUZ [' + RemoteDUZ + ']'); {JK 10/5/2009 - Maggmsgu refactoring}
      RemoteBroker := MagRemoteBrokerManager1.GetBroker(AcquisitionPrimaryDivision);
      If RemoteBroker = Nil Then
      Begin
        Result := False;
        Xmsg := 'Remote connection for site [' + AcquisitionPrimaryDivision + '] is disconnected, cannot lock items from this site.';
        Exit;
      End;
      RemoteBroker.RPMagTeleReaderUnreadlistLock(Xmsg, AcquisitionPrimaryDivision,
        AcquisitionSiteCode, ItemID, LockUnlockValue, UserFullName, UserInitials,
        LocalDUZ, LocalSiteCode);
    End;
  Except
    On e: Exception Do
    Begin
      //Showmessage(e.Message);
      //p106 rlm 20101229 CR640 "Title of Dialog box"
      MagLogger.MagMsg(
        'de',
        e.Message,
        Nil);
      Xmsg := '-100|' + e.Message;
      Result := False;
    End;
  End;

End;
//46

Function TMagDBMVista.RPMagGetPatientDFNFromICN(Var Xmsg: String; PatientICN: String): Boolean;
Begin
  FBroker.REMOTEPROCEDURE := 'VAFCTFU CONVERT ICN TO DFN';
  FBroker.PARAM[0].PTYPE := LITERAL;
  FBroker.PARAM[0].Value := PatientICN;
  Try
    Xmsg := FBroker.STRCALL;
    Result := True;
  Except
    On e: Exception Do
    Begin
      Xmsg := e.Message;
      Result := False;
    End;
  End;

End;

Procedure TMagDBMVista.KeepBrokerAlive(Enabled: Boolean);
Begin
  FKeepAliveEnabled := Enabled;
  If FKeepAliveEnabled Then
  Begin
    Try
      FKeepAliveThread := TMagKeepAliveThread.Create(True);
            //FKeepAliveThread.OnLogEvent := OnLogEvent;  {JK 10/6/2009 - Maggmsgu refactoring}
      FKeepAliveThread.Broker := FBroker;
      FKeepAliveThread.Resume();
    Except
      On e: Exception Do
      Begin
                //LogMsg('s', 'Exception creating keep alive thread in cMagDBMVista, [' + e.Message + ']');
        MagLogger.LogMsg('s', 'Exception creating keep alive thread in cMagDBMVista, [' + e.Message + ']'); {JK 10/5/2009 - Maggmsgu refactoring}
      End;
    End;
  End
  Else
  Begin
    If FKeepAliveThread <> Nil Then
    Begin
      Try
        FKeepAliveThread.Terminate;
        FKeepAliveThread := Nil;
      Except
        On e: Exception Do
        Begin
                    //LogMsg('s', 'Exception terminating keep alive thread in cMagDBMVista, [' + e.Message + ']');
          MagLogger.LogMsg('s', 'Exception terminating keep alive thread in cMagDBMVista, [' + e.Message + ']'); {JK 10/5/2009 - Maggmsgu refactoring}
        End;
      End;
    End;
  End;
End;

Procedure TMagDBMVista.RPMaggImageGetProperties(Var Rstat: Boolean;
  Var Rmsg: String; Var Rlist: TStrings; Ien, Params: String);
Var
  Resstr: String;
Begin
    //inherited;
  If (FBroker = Nil) Or (Not FBroker.Connected) Then
    Raise Exception.Create('No connection to the Server');
  FBroker.REMOTEPROCEDURE := 'MAGG IMAGE GET PROPERTIES';
  Try
    FBroker.PARAM[0].Value := Ien;
    FBroker.PARAM[0].PTYPE := LITERAL;
    FBroker.PARAM[1].Value := Params;
    FBroker.PARAM[1].PTYPE := LITERAL;

    FBroker.PARAM[2].Value := 'EI';
    FBroker.PARAM[2].PTYPE := LITERAL;
    LogRPCParams;
    FBroker.LstCALL(Rlist);
    Resstr := MagPiece(Rlist[0], '^', 1);
    Rstat := (Resstr <> '0');
    Rmsg := MagPiece(Rlist[0], '^', 2);
    LogRPCResult(Rlist);
  Except
    On e: Exception Do
    Begin
      Rmsg := e.Message;
      Rstat := False;
    End;
  End;
End;

Procedure TMagDBMVista.RPMaggReasonList(Var Rstat: Boolean; Var Rmsg: String; Var Rlist: TStrings; Data: String);
Var
  Resstr: String;
Begin
    //inherited;
    {     Data is '^' delimited
  $p1  =  This parameter defines the type(s) of reasons that are returned by the remote procedure.
         Its value should consist of one or more of the following characters:
          C  Reasons for copying images
          D  Reasons for deleting images
          P  Reasons for printing images
          S  Reasons for changing image status
      For example, if the "CD" value is assigned to the parameter, the RPC
      returns the reasons for copying and deleting images.

  $p 2 = Flags that control execution (can be combined):
            F  Include full details (description text, etc.)
            I  Include inactivated reasons
      If this parameter is not defined or empty, only the summary data for
      currently active reasons is returned.

  $p 3 =  The partial match restriction (case sensitive). For example, a PART value of "ZZ"
          would restrict the list to those entries starting with the letters "ZZ".
          If this parameter is not defined or empty, no text restrictions are applied.}
  If (FBroker = Nil) Or (Not FBroker.Connected) Then
    Raise Exception.Create('No connection to the Server');
  FBroker.REMOTEPROCEDURE := 'MAGG REASON LIST';
  Try

    If MagPiece(Data, '^', 1) = '' Then
      Data := 'PCDS^';
    FBroker.PARAM[0].Value := MagPiece(Data, '^', 1);
    FBroker.PARAM[0].PTYPE := LITERAL;
    If MagPiece(Data, '^', 2) <> '' Then
    Begin
      FBroker.PARAM[1].Value := MagPiece(Data, '^', 2);
      FBroker.PARAM[1].PTYPE := LITERAL;
    End;
    If MagPiece(Data, '^', 3) <> '' Then
    Begin
      FBroker.PARAM[2].Value := MagPiece(Data, '^', 3);
      FBroker.PARAM[2].PTYPE := LITERAL;
    End;
    LogRPCParams;
    FBroker.LstCALL(Rlist);
    Resstr := MagPiece(Rlist[0], '^', 1);
    Rstat := (Resstr <> '0');
    Rmsg := MagPiece(Rlist[0], '^', 2);
    LogRPCResult(Rlist);
  Except
    On e: Exception Do
    Begin
      Rmsg := e.Message;
      Rstat := False;
    End;
  End;
End;

{/ P117 NCAT - JK 12/2010 /}
procedure TMagDBMVista.ReserializeRemoteList(var Stat: Boolean; var RS: TStrings; PatName: String);
const
  Delim = '^';
var
  S: TStrings;
  StudyPart1, StudyPart2: String;
  i, j: Integer;
  SList: TStringList;
  Display: String;
//  F: Textfile;
  Sensitive, ViewStatus, Status: String;

  function GetSerialMapping(i: Integer): String;
  begin
    case i of
      1:  Result := 'LengthInfo';
      2:  Result := 'Mag0';
      3:  Result := 'FFile';
      4:  Result := 'AFile';
      5:  Result := 'ImgDes';
      6:  Result := 'not defined';
      7:  Result := 'ImgType';
      8:  Result := 'Proc';
      9:  Result := 'Date';
      10: Result := 'not defined';
      11: Result := 'AbsLocation';
      12: Result := 'FullLocation';
      13: Result := 'DicomSequenceNumber';
      14: Result := 'DicomImageNumber';
      15: Result := 'GroupCount';
      16: Result := 'PlaceIEN';
      17: Result := 'PlaceCode';
      18: Result := 'QAMsg';
      19: Result := 'BigFile';
      20: Result := 'DFN';
      21: Result := 'PtName';
      22: Result := 'MagClass';
      23: Result := 'CaptureDate';
      24: Result := 'DocumentDate';
      25: Result := 'IGroupIEN';
      26: Result := 'ICh1IEN:ICh1Type';
      27: Result := 'ServerName';
      28: Result := 'ServerPort';
      29: Result := 'MagSensitive';
      30: Result := 'MagViewStatus';
      31: Result := 'MagStatus';
    end;
  end;

begin

//  AssignFile(F, 'c:\studylist.txt');
//  rewrite(F);

  SList := TStringList.Create;
  S := TStringList.Create;

  try
    S.AddStrings(RS);
    RS.Clear;

    {Iterate through the Studylist stringlist. Each stringlist is a study element}
    for j := 0 to S.Count - 1 do
    begin
//      writeln(f, '------ Study ' + IntToStr(j) + ' ------');

      StudyPart1 := MagPiece(S[j], '|', 1);
      StudyPart2 := MagPiece(S[j], '|', 2);

      {Stuff in a lead element to make the alignment correct}
      StudyPart2 := '^' + StudyPart2;

      StudyPart2 := MagSetPiece(StudyPart2, '^', 21, PatName);

      Sensitive := MagPiece(StudyPart2, '^', 29);
      ViewStatus := MagPiece(StudyPart2, '^', 30);
      Status := MagPiece(StudyPart2, '^', 31);

      {Get the pieces}
      for i := 1 to MagLength(StudyPart2, '^') do
      begin
        SList.Add('Piece ' + IntToStr(i) + ' [' + GetSerialMapping(i) + '] ' + MagPiece(StudyPart2, Delim, i));
      end;

      Display := '';
      for i := 0 to SList.Count - 1 do
        Display := Display + SList[i] + #13#10;

//      writeln(f, Display);
//      writeln(f, ' ');

      RS.Add(StudyPart1 + '|' + Copy(StudyPart2, 2, Length(StudyPart2)));

    end;
  finally
    SList.Free;
    S.Free;
//    closefile(f);
    Stat := True;
  end;
end;

Procedure TMagDBMVista.RPMag4ImageList(Var Fstat: Boolean; Var Rpcmsg: String; DFN: String; Var Flist: TStrings; Filter: TImageFilter = Nil);
Var
  Cls, Pkg, Types, Spec, Event: String;
  FrDt, ToDt, Maxnum: String;
  MthRange: Integer;
  Origin: String;
  i, j: Integer;
  ImageResult: Boolean;
  Loc: Integer;
  SortList: Tstringlist;
  FinalList: TStrings;
  Tempstr3: String;
  RemoteList: TStrings;
  PartialResult: Boolean; {/ P117 NCAT - JK 11/30/2010 /}
  PartialMsg: String; {/ P117 NCAT - JK 1/17/2011 /}
  RemoteStatus, RemoteData, RemoteDFN: String;
  RemoteBroker: IMagRemoteBroker;
  RBrokerResult: TMagPatientStudyResponse;
    //93
  Miscparams: TStrings;
  RFlags: String;
  PR: String;          {/ P117 NCAT - JK 12/2/2010 - partial result string variable /}
  PatInfoStr: String;  {/ P117 NCAT - JK 12/7/2010 /}
  Stat: Boolean;       {/ P117 NCAT - JK 12/7/2010 /}
  PatName: String;     {/ P117 NCAT - JK 12/7/2010 /}
Begin
  Try {   This try will encompase the whole procedure, and at the end, if we have some images for a patient, we
           will add Creation Date to the final results list.  for Local and Remote Images.}
    Try
        {   filter should never be nil... if it is, we should default to all ? }
      If Filter = Nil Then
        Raise Exception.Create('Image Filter is undefined.');
        {   We set the variables because the call to a Remote Site does not have new RPC Call.
            so we call remote sites the old way, until all sites have New RPC Call i.e. all Sites have installed 93 KIDS.}

      Cls := '';
      Pkg := '';
      Types := '';
      Spec := '';
      Event := '';
      FrDt := '';
      ToDt := '';
      Origin := '';
      If Filter <> Nil Then
      Begin
        Cls := ClassesToString(Filter.Classes);
        Pkg := PackagesToString(Filter.Packages);
        Types := Filter.Types;
        Spec := Filter.SpecSubSpec;
        Event := Filter.ProcEvent;
        Origin := Filter.Origin;
      End;
      Miscparams := Filter.GetParamList;
        {   in 93 DFN isn't required.  We can get lists that have multiple  patients. }
      If (DFN <> '') Then
        Miscparams.Add('IDFN^^' + DFN);
        {   initialize some variables.}
      ImageResult := False;
      FrDt := Filter.FromDate;
      ToDt := Filter.ToDate;
      MthRange := Filter.MonthRange;
      If MthRange < 0 Then
      Begin
        FrDt := Formatdatetime('mm/dd/yyyy', IncMonth(Date, MthRange));
        ToDt := '';
      End;
        { TODO -c93 : Need to modify Filter to have DayRange. }
        { TODO -c93 : Need Filter to have function that will return FromDate and ToDate.  So we don't have to do this 'if mthrange < 0.... each time. }

      {/ P117 - JK 8/30/2010 - Added the ability to see and use the 'D' flag value /}
      if Filter.ShowDeletedImageInfo then
        RFlags := 'DE'
      else
        RFlags := 'E';

      If Filter.UseCapDt Then
        RFlags := RFlags + 'C';
      If Filter.FReturnPercent Then
        RFlags := RFlags + 'S';
      {/p117 gek  ADDED AGAIN the 'G' Flag......}
      if Filter.FGroupImageStatus <> ''  then
        RFlags := RFlags + 'G';
      
      Maxnum := Filter.MaximumNumber;
      If Maxnum = '' Then
        Maxnum := '2000';
        { TODO -c93 : Filter has a Maximum number field.  How do we want to use MaxNumber ? }
      With FBroker Do
      Begin
        PARAM[0].Value := RFlags;
        PARAM[0].PTYPE := LITERAL;
        PARAM[1].Value := FrDt;
        PARAM[1].PTYPE := LITERAL;
        PARAM[2].Value := ToDt;
        PARAM[2].PTYPE := LITERAL;
        PARAM[3].Value := Maxnum;
        PARAM[3].PTYPE := LITERAL;
        PARAM[4].Value := '.x';
        PARAM[4].PTYPE := List;
        For i := 0 To Miscparams.Count - 1 Do
          PARAM[4].Mult['' + Inttostr(i) + ''] := Miscparams[i];
        FBroker.REMOTEPROCEDURE := 'MAG4 IMAGE LIST';   // Newer call for Getting Patient Image List
      End;
      LogRPCParams;
      FBroker.LstCALL(Flist); { example documentation and result at end.}
{$IFDEF DEMOCREATE}
      Flist.SaveToFile(ExtractFilePath(Application.ExeName) + '\image\xMagDemoImageList' + DFN + '.TXT');
{$ENDIF}
      Miscparams.Free; // done with this now.
      LogRPCResult(Flist);
      If Flist.Count = 0 Then
        Raise Exception.Create('Error: Empty results Array !.');
      If (MagPiece(Flist[0], '^', 1) = '0') Then
      Begin
        Rpcmsg := MagPiece(Flist[0], '^', 2);
            {   //exit;  no longer want to exit since we need to check remote brokers // JMW 3/2/2005 p45}
        Tempstr3 := Flist[0];
            {   Sergey's call sends a second node of error info, it confuses the program.}
        Flist.Clear;
            { JMW 6/2/2009 P93T8 - need to keep list clear at this point will re-add the first line
              if no remote sites add any data
              this fixes bug where column header in image list has error message merged in  }
      End
      Else
      Begin
        ImageResult := True;
        Rpcmsg := MagPiece(Flist[0], '^', 2);
        Flist.Delete(0);
      End;
      Tempstr3 := '';
    Except
      On e: Exception Do
      Begin
        Miscparams.Free;
        LogRPCException(e.Message);
        Flist.Clear;
        Flist.Insert(0, '0^Error retrieving Image list from VistA.');
        ImageResult := False;
        Rpcmsg := 'Error retrieving Image list from VistA.' + e.Message;
            //93 out, no need -  Flist.insert(1, '0^' + magpiece(e.message, #$A, 2));
      End;
    End;

    If (ImageResult And (Flist.Count > 1)) Then
      If Not IsServerPortInString(Flist[1], 'MAG4 IMAGE LIST') Then
        ResolveServerPort(Flist, FBroker.Server, FBroker.ListenerPort, 1);

    // JMW 4/18/2005 p45
    // check to see that the RemoteBrokerManager was initialized, in Capture it is not so the RIV items should not be executed.

    Fstat := ImageResult;

   {   This worked fine for Local Images.   Now moved to the last 'finally' so we get remotes as well.}
   // if (FSTAT and (Flist.Count > 1)) then   AddCreationDateToResultsList(flist);
    {   we Don't want Remote Images always... Verify window for One.}
    If Filter.FLocalImagesOnly Then
      Exit;

    //EXIT;  // NOT USING THIS CALL FOR REMOTE IMAGES.       ??? need finished.
    // not using this same RPC call for remote sites however we still need to call
    // the remote broker to get the study list (uses the old RPC call)
    If MagRemoteBrokerManager1 = Nil Then
      Exit;

    If MagRemoteBrokerManager1.NewPatientSelected Then
    Begin
      Fstat := ImageResult;
      MagRemoteBrokerManager1.NewPatientSelected := False;
        // maggmsgf.MagMsg('s', 'cMagDBMVistA - a new patient has been selected, will not load remote images for patient');
        //LogMsg('s', 'cMagDBMVistA - a new patient has been selected, will not load remote images for patient');
      MagLogger.LogMsg('s', 'cMagDBMVistA - a new patient has been selected, will not load remote images for patient'); {JK 10/5/2009 - Maggmsgu refactoring}
      Exit;
    End;
    {HERE, TRY LOOPING THROUGH THIS REMOTE BROKER LIST TO CALL THE KEEP ALIVE CALL.}
    RemoteList := Tstringlist.Create();
    For j := 0 To MagRemoteBrokerManager1.GetBrokerCount() - 1 Do
    Begin
      RemoteList.Clear(); { JMW 2/25/08 P72 - clear the list before each remote call, was holding onto old data, not sure why not a problem before}
        {       make sure the broker is active and also be sure the patient has at least 1 image at that site  }
      If (MagRemoteBrokerManager1.IsRemoteBrokerActive(j)) And ((MagRemoteBrokerManager1.RemoteBrokerArray[j].GetImageCount() > 0) Or
        (MagRemoteBrokerManager1.RemoteBrokerArray[j].GetImageCount() = -1)) Then
      Begin
        RemoteBroker := MagRemoteBrokerManager1.RemoteBrokerArray[j];
            //      TRemoteBroker := MagRemoteBrokerManager1.RemoteBrokerArray[j].getBroker();
        RemoteDFN := MagRemoteBrokerManager1.GetRemoteDFN(j);
        Try
                //LogMsg('s', 'DFN:' + RemoteDFN + ' Start RPC MAG4 PAT GET IMAGES on ' + remoteBroker.getServerDescription + ' ' +
                //    formatdatetime('mm/dd/yy@hh:nn:ss.zzz', now));
          MagLogger.LogMsg('s', 'DFN:' + RemoteDFN + ' Start RPC MAG4 PAT GET IMAGES on ' + RemoteBroker.GetServerDescription + ' ' +
            Formatdatetime('mm/dd/yy@hh:nn:ss.zzz', Now)); {JK 10/5/2009 - Maggmsgu refactoring}
                // if this returns false then there was an error getting studies
                // if one site fails, is this how we should indicate, by failing all?
                {JMW 4/1/07 Patch 72
                  Changing the way this works, now if the getpatientStudies returns false and the remote site is RPC,
                  then it fails all (maybe still not correct but is consistent with before (patch 45)).
                  If remote site is WS (web Service ? ), then this likely means the ViX had a problem communicating with the
                  remote site (VA or BIA).
                  In this case we will disconnect the remote site and log the error but allow the client to continue.
                   Perhaps in the future we should indicate a different error to the user (color or text)
                }
          RBrokerResult := RemoteBroker.GetPatientStudies(Pkg, Cls, Types, Event, Spec, FrDt, ToDt, Origin, RemoteList, PartialResult, PartialMsg);   {/ P117 NCAT - JK 11/30/2010 /}

          {/ P117 NCAT - JK 12/7/2010 - fetch the patient name so it can be used to populate the results
             from a call to get images from the DoD /}
          RPMagPatInfoQuiet(Stat, PatInfoStr, DFN);    { TODO : /p117 gek.  Look into this,  we should already have patient name ? }
          if Stat then
            PatName := MagPiece(PatInfoStr, '^', 3)
          else
            PatName := 'Patient Name Missing';

          If Not (RBrokerResult = MagStudyResponseOk) Then
          Begin
            If RemoteBroker.GetRemoteBrokerType = MagRemoteRPCBroker Then
            Begin
              Flist.Insert(0, RemoteList.Strings[0]);
              Fstat := False;
              Flist.Insert(1, RemoteList.Strings[1]);
              Exit;
            End
            Else
            Begin // if WS (Web Service ? ) broker, disconnect and show disconnected
              RemoteBroker.Disconnect;
                        // JMW 11/3/2008 p72t28 - if the response is a normal exception
                        // then update the site as disconnected. If the exception is
                        // a socket timeout, then mark disconnected with try again (special
                        // case since DoD sometimes takes too long for study graphs).
              If RBrokerResult = MagStudyResponseException Then
                Magremoteinterface.RIVNotifyAllListeners(Nil,
                  'SetDisconnectedAndUpdate',
                  RemoteBroker.GetSiteCode())
              Else
                If RBrokerResult = MagStudyResponseTimeout Then
                  Magremoteinterface.RIVNotifyAllListeners(Nil,
                    'SetSiteTimeoutException',
                    RemoteBroker.GetSiteCode())
            End;
          End;
                {JMW 4/1/07 Patch 72
                only continue if remote broker result was good}
          If RBrokerResult = MagStudyResponseOk Then
          Begin
            If RemoteBroker.IsBrokerLateCountUpdate Then
            Begin
              {/ P117 NCAT - JK 12/2/2010 /}
              if PartialResult then
              begin
                PR := '^Partial';
                MagLogger.LogMsg('', 'Partial Result Message = [ ' + PartialMsg + ']'); {/ P117 NCAT - JK 1/17/2011 /}
              end
              else
                PR := '';
              Magremoteinterface.RIVNotifyAllListeners(Nil, 'UpdateImageCount', RemoteBroker.GetSiteCode + '^' +
                Inttostr(RemoteBroker.GetImageCount()) + PR);
            End;

{$IFDEF DEMO CREATE}
{$ENDIF}
                    //LogMsg('s', 'DFN:' + RemoteDFN + ' Done RPC MAG4 PAT GET IMAGES on ' + remoteBroker.getServerDescription + ' ' +
                    //    formatdatetime('mm/dd/yy@hh:nn:ss.zzz', now));
            MagLogger.LogMsg('s', 'DFN:' + RemoteDFN + ' Done RPC MAG4 PAT GET IMAGES on ' + RemoteBroker.GetServerDescription + ' ' +
              Formatdatetime('mm/dd/yy@hh:nn:ss.zzz', Now)); {JK 10/5/2009 - Maggmsgu refactoring}
            If (MagPiece(RemoteList[0], '^', 1) = '0') Then
            Begin
              Rpcmsg := MagPiece(RemoteList[0], '^', 2);
              RemoteList.Delete(0);
            End
            Else
            Begin
              ImageResult := True;
              Rpcmsg := MagPiece(RemoteList[0], '^', 2);
              RemoteList.Delete(0);
              RemoteStatus := RemoteList.Strings[0];
              If Flist.Count = 0 Then
              Begin
                Flist.Add(RemoteStatus);
              End
              Else
              Begin
                If MagRemoteBrokerManager.IsMergeColumnHeadersNeeded(Flist.Strings[0], RemoteStatus) Then
                Begin
                  MagRemoteBrokerManager.MergeColumnHeaders(Flist, RemoteList);
                End;
              End;
              RemoteList.Delete(0);
            End;
            If RemoteList.Count > 0 Then
              If Not IsServerPortInString(RemoteList.Strings[0], 'RIV: MAG4 PAT GET IMAGES') Then
                ResolveServerPort(RemoteList, RemoteBroker.GetServerName(), RemoteBroker.GetServerPort());

ReserializeRemoteList(Stat, RemoteList, PatName);  {/ P117 NCAT - JK 12/7/2010 - need to reorient the end of the string /}

            For i := 0 To RemoteList.Count - 1 Do
            Begin
              Loc := Pos('^', RemoteList.Strings[i]);
              RemoteData := Copy(RemoteList.Strings[i], Loc, Length(RemoteList.Strings[i])); // - loc);

                        //RemoteList.Strings[i] := RemoteList.Strings[i] + '^' + TRemoteBroker.server + '^' + inttostr(TRemoteBroker.listenerport);
              RemoteList.Strings[i] := Inttostr(Flist.Count + i) + RemoteData + '^';
                        // + remoteBroker.getServerName() + '^' + inttostr(remoteBroker.getServerPort());
            End;
            Flist.AddStrings(RemoteList);
          End; {End of if rBrokerResult - ok connection to remote site}
        Except
          On e: Exception Do
          Begin
            Flist.Insert(0, '0^ERROR Accessing Patient Image list.');
            ImageResult := False;
            Rpcmsg := 'ERROR Accessing Patient Image list: ' + e.Message;
            Flist.Insert(1, '0^' + MagPiece(e.Message, #$A, 2));
            Fstat := ImageResult;
            Exit;
          End;
        End; {except}
      End; {if  this broker is active}
    End; {for all active remotebrokers.}

    Fstat := ImageResult;

    If Flist.Count <= 0 Then
      Flist.Add(Rpcmsg);

    // put all the image data into a list to be sorted

    SortList := Tstringlist.Create();
    For i := 1 To Flist.Count - 1 Do
    Begin

        // JMW 6/17/2005 p45t3 wasn't loading the date from the correct location, caused problem with p59
        //    SortList.Add(formatdatetime('yyyymmddhhmmnn', strtodatetime(magpiece(magpiece(flist.Strings[i], '|', 2), '^', 8))) + '^' + magpiece(flist.strings[i], '^', 1));
        // JMW 12/7/2005 p46t1 Fixed bug so that if the date is invalid it won't crash
        //was in 72     SortList.Add(MagRemoteBrokerManager.convertAndFormatDateTime(magpiece(magpiece(flist.Strings[i], '|', 2), '^', 8)) + '^' + magpiece(flist.strings[i], '^', 1));
       (* p59   SortList.Add(MagConvertAndFormatDateTime(magpiece(magpiece(flist.Strings[i], '|', 2), '^', 8)) + '^' + magpiece(flist.strings[i], '^', 1)); *)

        {The list is by Reverse Date, and all with same date, need reverse order of item # because of the SortList.Sort comming up.}
      Tempstr3 := (MagConvertAndFormatDateTime(MagPiece(Flist.Strings[i], '^', 4)) + '^' + Inttostr(10000 - Strtoint(MagPiece(Flist.Strings[i], '^', 1))));
      SortList.Add(Tempstr3); //MagConvertAndFormatDateTime(magpiece(flist.Strings[i],'^', 4)) + '^' +    magpiece(flist.strings[i], '^', 1));;

    End;

    SortList.Sort(); // sort the list

    FinalList := Tstringlist.Create(); // create a list to put the sorted data into
    FinalList.Add(Flist.Strings[0]);

    For i := 0 To SortList.Count - 1 Do
    Begin
        // use insert instead of add because Delphi sorts it ascending instaed of descending
        {p59 convert back to original item #, by 10000 - }
      FinalList.Insert(1, Flist.Strings[10000 - Strtoint(MagPiece(SortList.Strings[i], '^', 2))]);
    End;

    FreeAndNil(SortList); // JMW 7/19/2005 p45t5

    // need to re-number the images
    For i := 1 To FinalList.Count - 1 Do
    Begin
      Loc := Pos('^', FinalList.Strings[i]);
      RemoteData := Copy(FinalList.Strings[i], Loc, Length(FinalList.Strings[i])); // - loc);

      FinalList.Strings[i] := Inttostr(i) + RemoteData;
    End;

    Flist := FinalList;

  Finally
    If (Fstat And (Flist.Count > 1)) Then AddCreationDateToResultsList(Flist);
  End;
End;
(*
Items of this list define new values of image properties. Each item has
3 pieces separated by '^':

 ^01: Parameter name
 ^02: "" (empty)
 ^03: Value

The following parameters are supported by this remote procedure:

 CRTNDT^^{Date/time}
   Internal or external value for the CREATION DATE field (110)
   of the IMAGE file #2005.

 GDESC^^{Text}
   Text for the SHORT DESCRIPTION field (10) of the file #2005.

 ISTAT^^{Name or Code}
   Internal or external value for the STATUS field (113)
   of the file #2005.

 ISTATRSN^^{Name or IEN}
   Name or IEN of a reason for image status change
   (see the STATUS REASON field (113.3) of the file #2005
   for details).

 IXORIGIN^^{Name or Code}
   Internal or external value for the ORIGIN INDEX field (45)
   of the file #2005.

 IXPKG^^{Name or Code}
   Internal or external value for the PACKAGE INDEX field (40)
   of the file #2005.

 IXPROC^^{Name or IEN}
   Procedure/Event name or IEN (see the PROC/EVENT INDEX
   field (43) of the file #2005 for details).

 IXSPEC^^{Name or IEN}
   Specialty/SubSpecialty name or IEN (see the SPEC/SUBSPEC
   INDEX field (44) of the file #2005 for details).

 IXTYPE^^{Name or IEN}
   Image type name or IEN (see the TYPE INDEX field (42) of
   the file #2005 for details).

 PARDF^^{File Number}
   Value for the PARENT DATA FILE# field (16) of
   the file #2005.

 PARGRD0^^{IEN}
   Value for the PARENT GLOBAL ROOT D0 field (17) of
   the file #2005.

 PARGRD1^^{IEN}
   Value for the PARENT GLOBAL ROOT D1 field (63) of
   the file #2005.

 PARIPTR^^{IEN}
   Value for the PARENT DATA FILE IMAGE POINTER field (18)
   of the file #2005.

 SENSIMG^^{Name or Code}
   Internal or external value for the 'Controlled' SENSITIVE IMAGE field
   (112) of the file #2005.

For pointer type parameters, pure numeric values are always treated as
internal entry numbers (IEN).

For sets of codes, the API checks for internal values first. So, if there
is an ambiguity between internal and external values, the parameter value
will be treated as the internal one.

Parameters can be added to the list in any order. See comments preceding
the SETPROPS^MAGGA02 for more details.

*)

Procedure TMagDBMVista.RPMaggImageSetProperties(Var Rstat: Boolean; Var Rmsg: String; Var Rlist: TStrings; Fieldlist: TStrings; Ien, Params: String);
Var
  Resstr: String;
  i: Integer;
Begin
    //inherited;
  If (FBroker = Nil) Or (Not FBroker.Connected) Then
    Raise Exception.Create('No connection to the Server');
  FBroker.REMOTEPROCEDURE := 'MAGG IMAGE SET PROPERTIES';
  Try
    FBroker.PARAM[0].Value := Ien;
    FBroker.PARAM[0].PTYPE := LITERAL;
    FBroker.PARAM[1].Value := Params;
    FBroker.PARAM[1].PTYPE := LITERAL;

    FBroker.PARAM[2].Value := '.x';
    FBroker.PARAM[2].PTYPE := List;
    For i := 0 To Fieldlist.Count - 1 Do
    Begin
      FBroker.PARAM[2].Mult['' + Inttostr(i) + ''] := Fieldlist[i];
    End;

    LogRPCParams;
    FBroker.LstCALL(Rlist);
    Resstr := MagPiece(Rlist[0], '^', 1);
    Rstat := (Resstr <> '0');
    Rmsg := MagPiece(Rlist[0], '^', 2);
    LogRPCResult(Rlist);
  Except
    On e: Exception Do
    Begin
      Rmsg := e.Message;
      Rstat := False;
    End;
  End;
End;

Procedure TMagDBMVista.RPMaggCaptureUsers(Var Fstat: Boolean; Var Fmsg: String; Var Flist: Tstringlist; Inputparams: Tstringlist);
Var
  Resstr: String;
  i: Integer;
  Flags: String;
  Rlist: Tstringlist;
  TmpMagPiece: String; {JK 1/22/2009 - D10}
Begin
  Rlist := Tstringlist.Create;
    //inherited;
  If (FBroker = Nil) Or (Not FBroker.Connected) Then
    Raise Exception.Create('No connection to the Server');

  FBroker.REMOTEPROCEDURE := 'MAGG CAPTURE USERS';

  Try
    FBroker.PARAM[0].Value := Inputparams[0]; {FromDate}
    FBroker.PARAM[0].PTYPE := LITERAL;
    FBroker.PARAM[1].Value := Inputparams[1]; {ToDate}
    FBroker.PARAM[1].PTYPE := LITERAL;
    FBroker.PARAM[2].Value := Inputparams[2]; {Flags C and/or I}
    FBroker.PARAM[2].PTYPE := LITERAL;

    LogRPCParams;
    FBroker.LstCALL(Rlist);
    Resstr := MagPiece(Rlist[0], '^', 1);
    Fstat := (Resstr <> '0');
    Fmsg := MagPiece(Rlist[0], '^', 2);
    LogRPCResult(Rlist);
    If Fstat Then Rlist.Delete(0);

  Except
    On e: Exception Do
    Begin
      Self.LogRPCException(e.Message);
      Fmsg := e.Message;
      Fstat := False;
    End;
  End;
  Flist.Assign(Rlist);
  Rlist.Free;

End;

Procedure TMagDBMVista.RPMagImageStatisticsUsers(Var Fstat: Boolean;
  Var Fmsg: String;
  Var Flist: Tstringlist;
  Inputparams: Tstringlist);
Var
  Resstr: String;
  i: Integer;
  Flags: String;
  Rlist: Tstringlist;
  TmpMagPiece: String; {JK 1/22/2009 - D10}
Begin
  Rlist := Tstringlist.Create;
    //inherited;
  If (FBroker = Nil) Or (Not FBroker.Connected) Then
    Raise Exception.Create('No connection to the Server');

  FBroker.REMOTEPROCEDURE := 'MAGG IMAGE STATISTICS';

  Try
    FBroker.PARAM[0].Value := 'CEU';
    FBroker.PARAM[0].PTYPE := LITERAL;
    FBroker.PARAM[1].Value := Inputparams[0];
    FBroker.PARAM[1].PTYPE := LITERAL;
    FBroker.PARAM[2].Value := Inputparams[1];
    FBroker.PARAM[2].PTYPE := LITERAL;

    LogRPCParams;
    FBroker.LstCALL(Rlist);
    Resstr := MagPiece(Rlist[0], '^', 1);
    Fstat := (Resstr <> '0');
    Fmsg := MagPiece(Rlist[0], '^', 2);
    LogRPCResult(Rlist);

        (* JK 1/22/2009 - Removed this for loop and replaced it with the loop below fixing D10
        for i := 2 to rlist.count-1 do
          begin
          flist.add(magpiece(rlist[i],'^',4) + ' |' + magpiece(rlist[i],'^',3))
          end;
        *)

        {JK 1/22/2009 - D10}
    For i := 2 To Rlist.Count - 1 Do
    Begin
      If MagPiece(Rlist[i], '^', 1) = 'U' Then
        If MagPiece(Rlist[i], '^', 4) <> '' Then
        Begin
                    {This rlist item is not a summary of images which don't have a user name assigned.
                     Ignore rlist summaries "by user name" if a user name is not assigned so the
                     drop down list caller only has proper entries.}
          TmpMagPiece := MagPiece(Rlist[i], '^', 5) + ' |' + MagPiece(Rlist[i], '^', 4);
          If Trim(TmpMagPiece) <> '|' Then
            Flist.Add(TmpMagPiece);
        End;
    End; {for}

  Except
    On e: Exception Do
    Begin
      Self.LogRPCException(e.Message); //gek 93t12 debug
      Fmsg := e.Message;
      Fstat := False;
    End;
  End;
  Rlist.Free;

End;

{/ JK 8/5/2010 - P117 - Added in procedure to call MAGG IMAGE STATISTICS QUE /}
procedure TMagDBMVista.RPMagImageStatisticsQue(
             var FStat: Boolean;
             var FMsg: String;
             var FList: TStringList;
             InputParams: TStringList);
var
  ResStr: String;
  i: Integer;
  Flags: String;
  RList: TStringList;
  TmpMagPiece: String; {JK 1/22/2009 - D10}
begin
  RList := TStringList.Create;

  if (FBroker = nil) or (not FBroker.Connected) Then
    Raise Exception.Create('No connection to the Server');

  FBroker.REMOTEPROCEDURE := 'MAGG IMAGE STATISTICS QUE';

  try
    FBroker.PARAM[0].Value := Inputparams[0];  {Param[0] = FLAGS}
    FBroker.PARAM[0].PTYPE := LITERAL;
    FBroker.PARAM[1].Value := Inputparams[1];  {Param[1] = FROMDATE}
    FBroker.PARAM[1].PTYPE := LITERAL;
    FBroker.PARAM[2].Value := Inputparams[2];  {Param[2] = TODATE}
    FBroker.PARAM[2].PTYPE := LITERAL;
    FBroker.PARAM[3].Value := Inputparams[3];  {Param[3] = MQUE}
    FBroker.PARAM[3].PTYPE := LITERAL;

    LogRPCParams;

    FBroker.LstCALL(RList);
    ResStr := MagPiece(RList[0], '^', 1);
    FStat := (ResStr <> '0');
    FMsg := MagPiece(RList[0], '^', 2);

    LogRPCResult(RList);

//    {JK 1/22/2009 - D10}
//    for i := 2 To RList.Count - 1 Do
//    begin
//      if MagPiece(RList[i], '^', 1) = 'U' then
//        if MagPiece(RList[i], '^', 4) <> '' then
//        begin
//          {This rlist item is not a summary of images which don't have a user name assigned.
//           Ignore rlist summaries "by user name" if a user name is not assigned so the
//           drop down list caller only has proper entries.}
//          TmpMagPiece := MagPiece(RList[i], '^', 5) + ' |' + MagPiece(RList[i], '^', 4);
//          If Trim(TmpMagPiece) <> '|' Then
//            Flist.Add(TmpMagPiece);
//        end;
//    end; {for}

    for i := 1 To RList.Count - 1 Do
    begin

      FList.Add(RList[i]);
    end; {for}

  except
    on E:Exception do
    begin
      Self.LogRPCException(E.Message); //gek 93t12 debug
      FMsg := E.Message;
      FStat := False;
    end;
  end;
  RList.Free;

end;

Procedure TMagDBMVista.RPMagImageStatisticsByUser(var Fstat: Boolean; var Fmsg: String; var Flist: TStringList; UserDUZ: String); {/ JK 8/5/2010 - P117 /}
var
  ResStr: String;
  i: Integer;
  Flags: String;
  RList: TStringList;
  TmpMagPiece: String; {JK 1/22/2009 - D10}
begin
  RList := TStringList.Create;

  if (FBroker = nil) or (not FBroker.Connected) Then
    Raise Exception.Create('No connection to the Server');

  FBroker.REMOTEPROCEDURE := 'MAGG IMAGE STATISTICS BY USER';

  try
    FBroker.PARAM[0].Value := UserDUZ;
    FBroker.PARAM[0].PTYPE := LITERAL;

    LogRPCParams;

    FBroker.LstCALL(RList);
    ResStr := MagPiece(RList[0], '^', 1);
    FStat := (ResStr <> '0');
    FMsg := MagPiece(RList[0], '^', 2);
    LogRPCResult(RList);

    for i := 0 To RList.Count - 1 Do
    begin
      Flist.Add(RList[i]);
    end; {for}

  except
    on E:Exception do
    begin
      Self.LogRPCException(E.Message); //gek 93t12 debug
      FMsg := E.Message;
      FStat := False;
    end;
  end;
  RList.Free;

end;

Procedure TMagDBMVista.AddCreationDateToResultsList(Flist: TStrings);
Var
  s, S1, S2, sdt, sres: String;
  i, j, dtpiece: Integer;
Begin
  Try
       // first try, but not generic
       // dtpiece := 17;
    dtpiece := Maglength(Flist[0], '^') + 1;
    S1 := MagPiece(Flist[0], '|', 1);
        // columns don't have 2nd '|' piece
        // s2 := magpiece(flist[0], '|', 2);
    sres := MagSetPiece(S1, '^', dtpiece, 'Creation Date~S1~W0');
    Flist[0] := sres; // + '|' + s2;
    sres := '';
    For i := 1 To Flist.Count - 1 Do
    Begin
      Flist[i] := AddCreationDateToResultItem(Flist[i], dtpiece);
      Continue;
      S1 := MagPiece(Flist[i], '|', 1);
      S2 := MagPiece(Flist[i], '|', 2);
      sdt := MagPiece(S2, '^', 23);
      sres := MagSetPiece(S1, '^', dtpiece, sdt);
      Flist[i] := sres + '|' + S2;
    End;
  Except
        //  flow control.
  End;
End;

Function TMagDBMVista.AddCreationDateToResultItem(Value: String; Col: Integer): String;
Var
  s, S1, S2, sdt, sres: String;
  i, j: Integer;
Begin

  S1 := MagPiece(Value, '|', 1);
  S2 := MagPiece(Value, '|', 2);
  sdt := MagPiece(S2, '^', 23);
  sres := MagSetPiece(S1, '^', Col, sdt);
  Result := sres + '|' + S2;
End;

{/ P94 JMW 10/1/2009 - method to get a new security token (BSE) /}

Function TMagDBMVista.RPMagSecurityToken(): String;
Begin
  Result := '';
  Try
    If (FBroker = Nil) Or (Not FBroker.Connected) Then
      Raise Exception.Create('No connection to the Server');

    FBroker.REMOTEPROCEDURE := 'MAG BROKER SECURITY';
    LogRPCParams;
    Result := FBroker.STRCALL;
    LogRPCResult(Result);
  Except
    On e: Exception Do
    Begin
      //LogMsg('s', 'Error retrieving security token, ' + e.Message, MagLogERROR);
      MagLogger.LogMsg('s', 'Error retrieving security token, ' + e.Message, MagLogERROR); {JK 10/5/2009 - Maggmsgu refactoring}
      Result := '';
    End;
  End;
End;

{/ P94 JMW 10/20/2009 - log using CAPRI for remote login, only logged at local site /}

Procedure TMagDBMVista.RPMagLogCapriRemoteLogin(Application: TMagRemoteLoginApplication;
  SiteNumber: String);
Var
  s: String;
Begin
  s := '';
  If Application = magRemoteAppTeleReader Then
    s := 'RTR'
  Else
    s := 'RCD';
  s := s + '^^^CAPRI Login^^1^' + SiteNumber;
  Try
    // only logged to the local site
    FBroker.PARAM[0].PTYPE := LITERAL;
    FBroker.PARAM[0].Value := s;
    FBroker.REMOTEPROCEDURE := 'MAGGACTION LOG';
    FBroker.STRCALL;
  Except
    On e: Exception Do
    Begin
      MagLogger.LogMsg('s', 'Error logging capri remote login, ' + e.Message, MagLogERROR); {JK 10/5/2009 - Maggmsgu refactoring}
    End;
  End;

End;

Function TMagDBMVista.IENtoTImageData(Ien: String; Var Rstat: Boolean; Var Rmsg: String): TImageData;
Var
  i: Integer;
  s: String;
  t: TStrings;
Begin
  Try
    t := Tstringlist.Create;
    Result := TImageData.Create;
    Result := Nil;

    // new/different ImageInfo call - 4/21/2005
    RPMaggImageInfo(Rstat, Rmsg, t, Ien, True);
    If Not Rstat Then Exit;
    Result := Result.StringToTImageData(Rmsg, GetServer, GetListenerPort);
  Finally
  End;
End;

Procedure TMagDBMVista.RPTeleReaderConsultListRequests(Var Fstat: Boolean; Var Fmsg: String; Var Flist: Tstringlist; DFN: String);
Var
  i: Integer;
  inPos: Integer;
  j: Integer;
  s: String;
  sgFldName: String;
  sgFldValue: String;
  sgTime: String;
  Tmps: String;
Begin
  If (FBroker = Nil) Or (Not FBroker.Connected) Then
  Begin
    Fstat := False;
    Fmsg := 'No connection to the Server';
    Exit;
  End;
  Flist.Clear;
  Fstat := False;
  FBroker.REMOTEPROCEDURE := 'MAG3 TELEREADER CONSULT LIST';
  Try
    FBroker.PARAM[0].Value := DFN;
    FBroker.PARAM[0].PTYPE := LITERAL;
    LogRPCParams;
    FBroker.Call;
    LogRPCResult;
    Flist.Assign(FBroker.Results);
    If (Flist.Count = 0) Or (MagPiece(Flist[0], '^', 1) = '0') Then Exit;
    Fstat := True;
    Fmsg := 'List of Consults'; //magpiece(Flist[0],'^',2);
    Flist.Delete(0);
    Flist[0] := StringReplace(Flist[0], '^Service', '^Consult Time^Service', []);
    For i := 1 To Flist.Count - 1 Do
    Begin
        {reformat the list into " ^^^ | ien "   format}
      s := Flist[i];
      sgTime := MagPiece(s, '^', 2);
      inPos := Pos('.', sgTime);
      If inPos <> 0 Then
      Begin
        sgTime := FmtoDispDt(sgTime, True, '.');
        sgTime := MagPiece(sgTime, '.', 2);
      End
      Else
      Begin
        sgTime := '';
      End;
      Tmps :=
        MagPiece(s, '^', 1) + '^' +
        FmtoDispDt(MagPiece(s, '^', 2)) + '^' +
        sgTime + '^' +
        MagPiece(s, '^', 3) + '^' +
        MagPiece(s, '^', 4) + '^' +
        MagPiece(s, '^', 5) + '|' +
        MagPiece(s, '^', 1);
      Flist[i] := Tmps;
    End;
  Except
    On e: Exception Do
    Begin
      Fstat := False;
      Fmsg := MagPiece(e.Message, #$A, 2);
    End;
  End;
End;

{p117 gek reanamed from UserHasRightToThinClient to be consistent with sop. RPMag...}
Function TMagDBMVista.RPMag3TRThinClientAllowed: Boolean;
Var
  s: String;
Begin
  Result := False;
  FBroker.REMOTEPROCEDURE := 'MAG3 TR THIN CLIENT ALLOWED';
  s := FBroker.STRCALL;
  If Copy(s, 1, 1) = '0' Then Exit; //error occurred during call
  If Copy(s, 3, 1) = '1' Then Result := True;
End;


{/117  we need a pat info that Doesn't call all remote sites !!!!!}
procedure TMagDBMVista.RPMagPatInfoQuiet(var Fstat: boolean; var Fstring: string; MagDFN: string; isicn: boolean = false);
var
    data: string;
    //  RemoteDUZ : String;
    //  RemoteMAGWINDOWS : String;
    UserSSN: string;
    RemoteResult: boolean;
    SiteCodes: string;
    i: integer;
    RemoteCount: integer;
    PatientData: string;
    LocalCount: integer;
    TreatingList: TStringList;
    RemoteSiteCount: integer;
    remotestatus: boolean;
begin
    {We need Patient Information without connecting to all remote sites like JW made the first Patient Info work.}
    {
      ;   DATA:  MAGDFN ^ NOLOG ^ ISICN
      ;      MAGDFN -- Patient DFN
      ;      NOLOG  -- 0/1; if 1, then do NOT update the Session log
      ;      ISICN  -- 0/1  if 1, then this is an ICN, if 0 (default) this is a DFN ; Patch 41
      ;  MAGRY is a string, we return the following :
      ; //$P     1        2      3     4     5     6     7     8        9                     10
      ; //    status ^   DFN ^ name ^ sex ^ DOB ^ SSN ^ S/C ^ TYPE ^ Veteran(y/n)  ^ Patient Image Count
      ; //$P    11            12              13
      ;        ICN       SITE Number   ^ Production Account 1/0
    }

    data := MagDFN + '^^' + magbooltostrint(isicn);
    Fstat := false;
    Fbroker.Param[0].PType := literal;
    Fbroker.Param[0].Value := data;
    Fbroker.remoteprocedure := 'MAGG PAT INFO';
    try
        Fstring := Fbroker.strCall;
        if (magpiece(Fstring, '^', 1) = '0') then
            exit;
        Fstat := true;
    except
        on E: EXCEPTION do
        begin
            // magpiece(E.message, #$A, 3)
            Fstring := '0^' + magpiece(e.message, #$A, 2);
            exit;
        end;
    end;
end;

{p117 gek reanamed from MagROIMultiPagePrint to be consistent with sop. RPMag...}
procedure  TMagDBMVista.RPMaggMultiImagePrint(DFN, Reason: String; Images: TStringList);
var sResult: string; i: integer;
begin
  FBroker.RemoteProcedure := 'MAGG MULTI IMAGE PRINT';
  FBroker.param[0].PType := literal;
  Fbroker.param[0].Value := DFN + '^' + MagPiece(Reason, '^', 2);
  FBroker.param[1].PType := list;
  FBroker.param[1].Value := '.x';
  for i := 0 to Images.Count - 1 do
    Fbroker.param[1].Mult['' + IntToStr(i) + ''] := Images.Strings[i];
  sResult := FBroker.strCall;
end;


procedure TMagDBMVista.RPMagJukeBoxPath(var Fstat: Boolean; var Fmsg: String; ImageIEN: String);
var s : string;
begin

  FBroker.REMOTEPROCEDURE := 'MAGG JUKE BOX PATH';
  FBroker.param[0].PType := literal;
  Fbroker.param[0].Value := ImageIEN;
  try
  Fmsg := FBroker.STRCALL;
  if (magpiece(Fmsg,'^',1) <> '1')
     then fstat := false
     else fstat := true;

  except
  on e:exception do
    begin
      fstat := false;
      Fmsg := '0^Exception : ' + e.Message;
    end;
  end;
end;

End.
(*  Fbroker.remoteprocedure := 'MAG4 IMAGE LIST';  {documentation and example result at end.}
    Fbroker.lstCall(Flist);      *)

(*
Flist[0]='1^Existing images captured by Garrett Edward Kirin BS from Dec 22, 2008 to Dec 22, 2008 (capture date range)^0'
Flist[1]='Item~S2^Site^Note Title~~W0^Proc DT~S1^Procedure^# Img~S2^Short Desc^Pkg^Class^Type^Specialty^Event^Origin^Cap Dt~S1~W0^Cap by~~W0^Image ID~S2~W0'
Flist[2]='1^SLC^   ^12/22/2008 00:01^CLIN^1^RELEASE OF INFORMATION^NONE^CLIN^MISCELLANEOUS DOCUMENT^^^VA^12/22/2008 08:34:13^KIRIN,GARRETT EDWARD^19465^|19465^c:\image\GVB0\00\00\01\94\GVB00000019465.TIF^c:\image\GVB0\00\00\01\94\GVB00000019465.ABS^RELEASE OF INFORMATION^3081222^15^CLIN^12/22/2008^^M^A^^^1^1^SLC^^^1033^IMAGPATIENT1033,1033^CLIN^12/22/2008 08:34:13^12/22/2008^0^^127.0.0.1^9400^0^^^'
..... a different Image....
Flist[2]='1^SLC^   ^12/23/2008 00:01^CLIN^3^DEATH DISPOSITION/ARRANGEMENTS^NONE^ADMIN/CLIN^DEATH DISPOSITION/ARRANGEMENTS^CHIROPRACTIC^^VA^12/23/2008 11:02:02^KIRIN,GARRETT EDWARD^19468^|19468^c:\image\GVB0\00\00\01\94\GVB00000019469.JPG^c:\image\GVB0\00\00\01\94\GVB00000019469.ABS^DEATH DISPOSITION/ARRANGEMENTS^3081223^11^CLIN^12/23/2008^^M^A^^^3^1^SLC^^^1033^IMAGPATIENT1033,1033^ADMIN/CLIN^12/23/2008 11:02:02^12/23/2008^0^19469:1^127.0.0.1^9400^0^^^'

*)
(*
            <0  Error descriptor (see the $$ERROR^MAGUERR)
           >0  Image descriptor
                 ^01: Image IEN
                 ^02: Image full path and name
                 ^03: Abstract full path and name
                 ^04: SHORT DESCRIPTION field and description of
                      offline JukeBox
                 ^05: PROCEDURE/EXAM DATE/TIME field
                 ^06: OBJECT TYPE
                 ^07: PROCEDURE field
                 ^08: display date
                 ^09: PARENT DATA FILE image pointer
                 ^10: ABSTYPE: 'M' magnetic, 'W' worm, 'O' offline
                 ^11: 'A' accessible, 'O' offline
                 ^12: DICOM Series Number
                 ^13: DICOM Image Number
                 ^14: Count of images in group; 1 if single image
                      VISN15
                 ^15: Site parameter IEN
                 ^16: Site parameter CODE
                 ^17: Error description of Integrity Check
                 ^18: Image BIGPath and name
                 ^19: Patient DFN
                 ^19: Patient Name
                 ^21: Image Class: Clin,Admin,Clin/Admin,Admin/Clin
                 ^22: Date Time Image Saved (7)
                 ^23: Document Date (110)
                 ^24: Group IEN
                 ^25: IEN of the 1s child of the group and child's
                      type separated by colon
                 ^26: RPC Broker server
                 ^27: RPC Broker port
                 ^28: Internal value of CONTROLLED IMAGE field (112)
                 ^29: Viewable Status ($$VIEWSTAT^MAGGI12)
                 ^30: Internal value of STATUS field (113)

 *)
