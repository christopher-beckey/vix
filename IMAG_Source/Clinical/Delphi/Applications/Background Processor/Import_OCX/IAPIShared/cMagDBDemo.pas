Unit cMagDBDemo;
   {
   Package: MAG - VistA Imaging
 WARNING: Per VHA Directive 10-93-142 this unit should not be modified.
 Date Created:
 Site Name: Silver Spring, OIFO
 Developers: Garrett Kirin
 [==  unit cMagDBDemo;
 Description:  Imaging Demo DataBase RPC Calls.
   Desecndant of Abstract Class TMagDBBroker
     This Class will surface (redeclare, override and implement) the Abstract
     methods and members of the ancestor abstract class to make Demo
     DataBase Calls.
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
Interface

Uses
  Classes,
  cMagDBBroker,
  cMagDBDemoUtils,
  Controls,
  Trpcb,
  UMagClasses,
  UMagDefinitions,
  VERGENCECONTEXTORLib_TLB
  ;

Type
  TMagDBDemo = Class(TMagDBBroker)
  Protected
    FBroker: TRPCBroker;
    FDemoConnected: Boolean;
    FDemoUtils: TMagDemoUtils;
    FDuz: String;
    FPatientList: TStrings;
    Procedure DemoMessage(s: String);
  Public
    Constructor Create();
    Destructor Destroy(); Override;//RLM Fixing MemoryLeak 6/18/2010
    Function CheckDBConnection(Var Xmsg: String): Boolean; Override;
    Function DBConnect(Vserver, Vport: String; Context: String = 'MAG WINDOWS'; AccessCode: String = ''; Verifycode: String = '';division : string = ''): Boolean; Override;
    Function DBSelect(Var Vserver, Vport: String; Context: String = 'MAG WINDOWS'): Boolean; Override;
    Function GetBroker: TRPCBroker; Override;
    Function GetListenerPort: Integer; Override;
    Function GetServer: String; Override;
    Function GetSilentCodes(Vserver, Vport: String; Var SilentAccess: String; Var SilentVerify: String): Boolean; Override;
    Function IsConnected: Boolean; Override;
    Function RPCreateRecord(Var Msg: String; DFN, Notetitle, Notedate: String; Notetext: TStrings): Boolean; Override;
    Function RPFileManDate(Var Xmsg: String; DateInput: String; Var DateOutput: String; NoFuture: Boolean = False): Boolean; Override;
    Function RPGetFileManDateTime(DateStr: String; Var DisDt, IntDT: String; NoFuture: Boolean = False): Boolean; Override;
    Function RPGetTIUData(TiuDA: String; Var TiuPTR: String): Boolean; Override;
    Function RPMag4GetFileFormatInfo(Ext: String; Var Xmsg: String): Boolean; Override;
    Function RPMagEkgOnline: Integer; Override;
    Function RPMaggGetPhotoIDs(Xdfn: String; t: Tstringlist): Boolean; Override;
    Function RPMaggIsDocClass(Ien, Fmfile, ClassName: String; Var Stat: Boolean; Var Fmsg: String): Boolean;
    Function RPMaggPatBS5Chk(DFN: String; Var t: Tstringlist): Boolean; Override;
    Function RPMagPatLookup(Str: String; t: TStrings; Var Xmsg: String): Boolean; Override;
    Function RPSignRecord(TiuDA, Hashesign: String; Var Msg: String): Boolean; Override;
    Function RPTIUConsultsClass: Integer; Override;
    Function RPTIUCPClass: Integer; Override;
    Function RPTIUSignRecord(Var Fmsg: String; DFN, TiuDA, Hashesign: String): Boolean; Override;
    Function RPVerifyEsig(Esig: String; Var Xmsg: String): Boolean; Override;
    Function RPXWBGetVariableValue(Value: String): String; Override;
    Function RPMag3TRThinClientAllowed: Boolean; Override;
    Procedure CreateBroker; Override;
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
    Procedure RPImageReport(Var Fstat: Boolean; Var Fmsg: String; Flist: TStrings; IObj: TImageData; NoQAcheck: Boolean = False); Override;
    Procedure RPIndexGetEvent(Lit: TStrings; Cls: String = ''; Spec: String = ''; IgnoreStatus: Boolean = False; IncClass: Boolean = False; IncStatus: Boolean = False); Override;
    Procedure RPIndexGetSpecSubSpec(Lit: TStrings; Cls: String = ''; Proc: String = ''; IgnoreStatus: Boolean = False; IncClass: Boolean = False; IncStatus: Boolean = False; IncSpec: Boolean =
      False);
      Override;
    Procedure RPIndexGetType(Lit: TStrings; Cls: String; IgnoreStatus: Boolean = False; IncClass: Boolean = False; IncStatus: Boolean = False); Override;
    Procedure RPLogCopyAccess(s: String; IObj: TImageData; EventType: TMagImageAccessEventType); Override;
    Procedure RPMag3Logaction(ActionString: String; IObj: TImageData); Override;
    Procedure RPMag3LookupAny(Var Fstat: Boolean; Var Fmsg: String; Var Flist: Tstringlist; InputString: String; Data: String = ''); Override;
    Procedure RPMag3TIUImage(Var Fstat: Boolean; Var Flist: Tstringlist; Magien, TiuDA: String); Override;
    Procedure RPMag4AddImage(Var Fstat: Boolean; Var Flist: Tstringlist; t: Tstringlist); Override;
    Procedure RPMag4DataFromImportQueue(Var Fstat: Boolean; Var Flist: Tstringlist; QueueNum: String); Override;
    function RPPatientHasPhoto(DFN: String; var Stat: Boolean; var FMsg: String): String; override;  {/ JK 11/24/2009 - P108 New method /}
    procedure RPIndexGetOrigin(Lit: TStrings); override;  {/ JK 11/24/2009 - P108 New Method to retrieve the list of Origins /}
    Procedure RPMag4FieldValueGet(Var Fstat: Boolean; Var Fmsg: String; Var Flist: Tstringlist; Ien: String; Flags: String = ''; Flds: String = ''); Override;
    Procedure RPMag4FieldValueSet(Var Fstat: Boolean; Var Fmsg: String; Var Flist: Tstringlist; t: Tstringlist); Override;
    Procedure RPMag4GetImageInfo(VIobj: TImageData; Var Flist: TStrings; DeletedImagePlaceholders: Boolean = False); Override;  {/ P117 - JK 9/20/2010 - added last parameter /}
    Procedure RPMag4IAPIStats(Var Fstat: Boolean; Var Flist: TStrings; DtStart, DtEnd: String); Override;
    Procedure RPMag4ImageList(Var Fstat: Boolean; Var Rpcmsg: String; DFN: String; Var Flist: TStrings; Filter: TImageFilter = Nil); Override;
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
    Procedure RPMaggGroupImages(IObj: TImageData; Var t: Tstringlist; NoQAcheck: Boolean = False; DeletedImages: String = ''); Override;
    Procedure RPMaggHS(Var Rstat: Boolean; Var Rmsg: String; Var Tlist: Tstringlist; Value: String); Override;
    Procedure RPMaggHSList(Var Rstat: Boolean; Var Rmsg: String; Var Tlist: Tstringlist; Value: String); Override;
    Procedure RPMaggImageDelete(Var Fstat: Boolean; Var Rmsg: String; Var Flist: TStrings; Ien, ForceDel: String; Reason: String = ''; GrpDelOK: Boolean = False); Override;
    Procedure RPMaggImageGetProperties(Var Rstat: Boolean; Var Rmsg: String; Var Rlist: TStrings; Ien, Params: String); Override;
    Procedure RPMaggImageInfo(Var Rstat: Boolean; Var Rmsg: String; Var Rlist: TStrings; Ien: String; NoQAcheck: Boolean = False); Override;
    Procedure RPMaggImageSetProperties(Var Rstat: Boolean; Var Rmsg: String; Var Rlist: TStrings; Fieldlist: TStrings; Ien, Params: String); Override;
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
    Procedure RPMagImageStatisticsUsers(Var Fstat: Boolean; Var Fmsg: String; Var Flist: Tstringlist; Inputparams: Tstringlist); Override;
    Procedure RPMagImageStatisticsQue(var Fstat: Boolean; var Fmsg: String; var Flist: TStringList; InputParams: TStringList); override;  {/ JK 8/5/2010 - P117 /}
    Procedure RPMagImageStatisticsByUser(var Fstat: Boolean; var Fmsg: String; var Flist: TStringList; UserDUZ: String); override; {/ JK 8/5/2010 - P117 /}
    Procedure RPMagLogErrorText(t: TStrings; Count: Integer); Override;
	{/117 gek }
    procedure RPMagPatInfoQuiet(var Fstat: boolean; var Fstring: string; MagDFN: string; isicn: boolean = false); override;
    {/ P117 - JK 10/5/2010 - Added 5th Parameter to support Deleted Image Placeholder counts/}
//    Procedure RPMagPatInfo(Var Fstat: Boolean; Var Fstring: String; MagDFN: String; IsIcn: Boolean = False); Override;
    Procedure RPMagPatInfo(Var Fstat: Boolean; Var Fstring: String; MagDFN: String; IsIcn: Boolean = False; IncDeletedCount: Boolean = False); Override;
    Procedure RPMagSetUserPreferences(Var Fstat: Boolean; Var Rpcmsg: String; Xlist: TStrings); Override;
    Procedure RPMagsVerifyReport(StartDate, EndDate, Options: String; t: Tstringlist); Override; {JK 6/1/2009 for ImageVerify Reporting}
    Procedure RPMagVersionCheck(t: TStrings; Version: String); Override;
    Procedure RPMagVersionStatus(Var Status: String; Version: String); Override;
    Procedure RPTIUCreateAddendum(Var Fstat: Boolean; Var Fmsg: String; DFN, TiuDA, AdminClose, Mode, Esighash, Esigduz, Notedate: String; Notetext: Tstringlist = Nil); Override;
    Procedure RPTIUCreateNote(Var Fstat: Boolean; Var Fmsg: String; DFN, Title, AdminClose, Mode, Esighash, Esigduz, Loc, Notedate, ConsltDA: String; Notetext: Tstringlist = Nil); Override;
    Procedure RPTIUisThisaConsult(Var Fstat: Boolean; Var Fmsg: String; Titleda: String); Override;
    Procedure RPTIULongListOfTitles(Var Fstat: Boolean; Var Fmsg: String; Var Flist: TStrings; NoteClass, InputString: String; Mylist: Boolean = False);
    Procedure RPUpdateConsult(Consult, TiuIen, cmpFlag: String; Var Status: String); Override;
    Procedure RPXMultiProcList(Lit: TStrings; DFN: String); Override;
    Procedure SetBroker(Const Value: TRPCBroker); Override;
    Procedure SetConnected(Const Value: Boolean); Override;
    Procedure SetContextor(Contextor: TContextorControl); Override;
    Procedure SetListenerPort(Const Value: Integer); Override;
    Procedure SetServer(Const Value: String); Override;
    procedure  RPMaggMultiImagePrint(DFN, Reason: String; Images: TStringList); override;
        {/P117 GEK 11/23/2010  Get Juke Box path to an Image.}
    procedure RPMagJukeBoxPath(var Fstat: Boolean; var Fmsg: String; ImageIEN: String); override;

  Published
    //property Broker: TRPCBroker read GetBroker write SetBroker;
    //property Connected : boolean read IsConnected write SetConnected;
    //property listenerport : integer read GetListenerPort write SetListenerPort;
    //property server : string read GetServer write SetServer;
  End;

Implementation
Uses
  CCOWRPCBroker,
  Dialogs,
  Fmxutils,
  Forms,
  Hash,
  Magfileversion,
  Maggmsgu,
  RPCconf1,
  SysUtils,
  Umagutils8,
  Windows
  ;

Procedure TMagDBDemo.RPMagsVerifyReport(StartDate, EndDate, Options: String; t: Tstringlist); {JK 6/1/2009 for ImageVerify Reporting}
Begin

  FBroker.PARAM[0].PTYPE := LITERAL;
  FBroker.PARAM[0].Value := Options;
  FBroker.PARAM[1].PTYPE := LITERAL;
  FBroker.PARAM[1].Value := StartDate;
  FBroker.PARAM[2].PTYPE := LITERAL;
  FBroker.PARAM[2].Value := EndDate;
  FBroker.REMOTEPROCEDURE := 'MAGG IMAGE STATISTICS';
    //Call;
  FBroker.LstCALL(t);

End;

Procedure TMagDBDemo.RPDGChkPatDivMeansTest(DFN: String; Var Code: Integer; Var t: Tstringlist);
Begin
//demo
  Code := 0;
  Exit;
  FBroker.PARAM[0].Value := DFN;
  FBroker.PARAM[0].PTYPE := LITERAL;
  FBroker.REMOTEPROCEDURE := 'DG CHK PAT/DIV MEANS TEST';
  {         Checks if means test required for patient and checks if means test display required for
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
      t[0] := 'The Attempt to determine Patient sensitivity Failed. Check VistA Error Log.';
    End;
  End;

End;

Procedure TMagDBDemo.RPDGSensitiveRecordBulletin(DFN: String);
Begin
//demo
  Exit;
  {         DG SENSITIVITY RECORD BULLETIN
             Input parameter ACTION (send bulletin, set log, or both) will be made optional with 'both' being the default value
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

Procedure TMagDBDemo.RPDGSensitiveRecordAccess(DFN: String; Var Code: Integer; Var t: Tstringlist);
Begin
//demo
  Code := 0;
  Exit;
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

Function TMagDBDemo.RPMaggPatBS5Chk(DFN: String; Var t: Tstringlist): Boolean;
Begin
//demo
  Result := True;
  Exit;
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

Function TMagDBDemo.RPMagPatLookup(Str: String; t: TStrings; Var Xmsg: String): Boolean;
Var
  i: Integer;
Begin
 {'M' t[1] = SAHO,F 10/10/1920 123456789   NON-VETERAN(OTHER)^959}
 {Demo,Patient^c:\Program Files\vista\imaging\image\patient1^Various types of Images.}
  FPatientList.LoadFromFile(ExtractFilePath(Application.ExeName) + 'image\MagDemoPatients.TXT');

  For i := 0 To FPatientList.Count - 1 Do
  Begin
    t.Add(MagPiece(FPatientList[i], '^', 1) + '^' + MagPiece(FPatientList[i], '^', 2));
  End;
  Result := True;
//demo
End;

// New Patch 8 call to return patient images based on filters of
//   package, Class, date range.

Procedure TMagDBDemo.RPMag4PatGetImages(Var Fstat: Boolean; Var Rpcmsg: String; DFN: String; Var Flist: TStrings; Filter: TImageFilter = Nil);
Var
  Cls, Pkg, Types, Spec, Event: String;
  FrDt: String;
  ToDt: String;
  MthRange: Integer;
  Origin: String;
  OldRpcTimeLimit: Integer;
  Demolist: TStrings;
  Patdir: String;
Begin
  Demolist := Tstringlist.Create;
  Try
    Fstat := True; //fstat := false;
    Rpcmsg := 'List of demo images'; //'No images for filter Demo.'  ;
(*
'2^02/12/2002^CP HOLTER^11^HOLTER^^^IMAGE^^^|
     1966^\\ISW-IMGQADB\IMAGE1$\QA\00\19\QA001967.ASC^.\BMP\magtext.bmp^HOLTER^3020212^11^
       CP HOLTER^02/12/2002^107^^A^^^11^^^^^1023^GREEN,DEAN^^^^^'

'2^09/10/2003^CLIN^1^CONSENT^NONE^CLIN^CONSENT^ALLERGY & IMMUNOLOGY^DISCHARGE SUMMARY^|
     3044^C:\IMAGE\GK00\00\00\00\30\GK000000003044.TIF^C:\IMAGE\GK00\00\00\00\30\GK000000003044.ABS^
        CONSENT^3030910.1229^15^CLIN^09/10/2003^^M^A^^^1^^^^^1068^KIRIN,NEW^CLIN^^^^'
*)
    Patdir := MagPiece(FPatientList[Strtoint(DFN) - 1], '^', 3);
//demolist.LoadFromFile(demodir+'\magdemoimagelist.txt');
    Demolist.LoadFromFile(ExtractFilePath(Application.ExeName) + Patdir + '\magdemoimagelist.txt');

    If Filter <> Nil Then FDemoUtils.FilterTheList(Filter, Demolist);
    Flist.Assign(Demolist);
  Finally
    Demolist.Free;
  End;
  Exit;
//demo
 {TODO -cDemo: needs activated for demo}

  Cls := '';
  Pkg := '';
  Types := '';
  Spec := '';
  Event := '';
  FrDt := '';
  ToDt := '';
 // MthRange := 0;
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
  Exit;
//for Filters to work in Demo.
(* we have a complete image list for demo patients. MagDemoImageList (in each patients demo dir)
   and we load it above (Flist)
loop through all properties of filter. if not null
see if appropriate '^' piece of Image entry is contained in property.
i.e. pkg = 'MED,RAD'   substr := $p(6)  if ((substr <> '') and (pos(substr,pkg)> 0))
                                            then okay
                                            else delete this item.

*)
//demo

  With FBroker Do
  Begin
    OldRpcTimeLimit := RPCtimelimit;
//      maggmsgf.magmsg('s', 'Increasing RPCTimeLimit to ' + inttostr(oldRPCTimelimit * 2));
    MagLogger.MagMsg('s', 'Increasing RPCTimeLimit to ' + Inttostr(OldRpcTimeLimit * 2)); {JK 10/5/2009 - Maggmsgu refactoring}
    RPCtimelimit := OldRpcTimeLimit * 2;
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
    REMOTEPROCEDURE := 'MAG4 PAT GET IMAGES';
  End;
  Try
    //maggmsgf.MagMsg('s', 'DFN:' + DFN + ' Start RPC MAG4 PAT GET IMAGES' + formatdatetime('mm/dd/yy@hh:nn:ss.zzz', now));
    MagLogger.MagMsg('s', 'DFN:' + DFN + ' Start RPC MAG4 PAT GET IMAGES' + Formatdatetime('mm/dd/yy@hh:nn:ss.zzz', Now)); {JK 10/5/2009 - Maggmsgu refactoring}
    FBroker.LstCALL(Flist);
    //maggmsgf.MagMsg('s', 'DFN:' + DFN + ' Done RPC MAG4 PAT GET IMAGES' + formatdatetime('mm/dd/yy@hh:nn:ss.zzz', now));
    MagLogger.MagMsg('s', 'DFN:' + DFN + ' Done RPC MAG4 PAT GET IMAGES' + Formatdatetime('mm/dd/yy@hh:nn:ss.zzz', Now)); {JK 10/5/2009 - Maggmsgu refactoring}
    If (MagPiece(Flist[0], '^', 1) = '0') Then
    Begin
      Fstat := False;
      Rpcmsg := MagPiece(Flist[0], '^', 2);
      Exit;
    End;
    Fstat := True;
    Rpcmsg := MagPiece(Flist[0], '^', 2);
    Flist.Delete(0);
  Except
    On e: Exception Do
    Begin
      Flist.Insert(0, '0^ERROR Accessing Patient Image list.');
      Fstat := False;
      Rpcmsg := 'ERROR Accessing Patient Image list: ' + e.Message;
      Flist.Insert(1, '0^' + MagPiece(e.Message, #$A, 2));
    End;
  End;
  //maggmsgf.magmsg('s', 'Restoring RPCTimeLimit to ' + inttostr(oldRPCTimelimit));
  MagLogger.MagMsg('s', 'Restoring RPCTimeLimit to ' + Inttostr(OldRpcTimeLimit)); {JK 10/5/2009 - Maggmsgu refactoring}
  FBroker.RPCtimelimit := OldRpcTimeLimit;
End;

Function TMagDBDemo.RPMaggGetPhotoIDs(Xdfn: String; t: Tstringlist): Boolean;
Var
  Flist: TStrings;
  Patdir: String;
  i: Integer;
  Photoi: Integer;
Begin
  Photoi := -1;
  Flist := Tstringlist.Create;

  Patdir := MagPiece(FPatientList[Strtoint(Xdfn) - 1], '^', 3);
  Flist.LoadFromFile(ExtractFilePath(Application.ExeName) + Patdir + '\magdemoimagelist.txt');

  For i := 0 To Flist.Count - 1 Do
  Begin
    If MagPiece(MagPiece(Flist[i], '|', 2), '^', 6) = '18' Then
    Begin
      Photoi := i;
      Break;
    End;

  End;
  If Photoi > -1 Then
  Begin
    Result := True;
    t.Add(MagPiece(Flist[Photoi], '|', 2));
  End
  Else
    Result := False;
  Exit;
//demo
  Try
    With FBroker Do
    Begin
      PARAM[0].Value := Xdfn;
      PARAM[0].PTYPE := LITERAL;
      REMOTEPROCEDURE := 'MAGG PAT PHOTOS';
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
  //if (magpiece(t[0],'^',1) = 0 ) then result := false;
  //if (magpiece(t[0],'^',2) = 0 ) then result := false;
End;

(*function TMagDBDemo.Connected : boolean;
begin
  if assigned(Fbroker) then
    result := Fbroker.Connected
  else result := false;
end; *)

Function TMagDBDemo.DBConnect(Vserver, Vport: String; Context: String = 'MAG WINDOWS';
                               AccessCode: String = ''; Verifycode: String = '';division : string = ''): Boolean;
Var
  SilentAccess, SilentVerify: String;
Begin
//demo
  FDemoConnected := True;
  Result := True;
  Exit;
  If Not Assigned(FBroker) Then
  Begin
    Result := False;
    Exit;
  End;

  If ((AccessCode <> '') And (Verifycode <> '')) Then
  Begin
    FBroker.AccessVerifyCodes := AccessCode + ';' + Verifycode;
  End
  Else
    If GetSilentCodes(Vserver, Vport, SilentAccess, SilentVerify) Then
    Begin
      FBroker.AccessVerifyCodes := SilentAccess + ';' + SilentVerify;
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
      Result := False;
    End;
  End;
End;

Function TMagDBDemo.DBSelect(Var Vserver, Vport: String; Context: String = 'MAG WINDOWS'): Boolean;
Var
  SilentAccess, SilentVerify: String;
Begin
  Result := True;
  FDemoConnected := True;
  Exit;
//demo
  If Not Assigned(FBroker) Then
  Begin
    Result := False;
    Exit;
  End;
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
    Try
      FBroker.CreateContext(Context);
    Except
      On e: Exception Do
      Begin
        Result := False;
      End;
    End;
  End;
End;

Procedure TMagDBDemo.RPMaggImageDelete(Var Fstat: Boolean; Var Rmsg: String; Var Flist: TStrings; Ien, ForceDel: String; Reason: String = ''; GrpDelOK: Boolean = False);
Begin
  Fstat := True;
  Messagedlg('Demo Image NOT deleted', Mtconfirmation, [Mbok], 0);
  Exit;
  Fstat := False;
  Rmsg := '';
  Flist.Clear;
  FBroker.PARAM[0].Value := Ien + '^' + ForceDel; { if ForceDel = '^1', then force delete, don't test for MAG DELETE KEY }
  FBroker.PARAM[0].PTYPE := LITERAL;
  FBroker.PARAM[1].Value := Magbooltostr(GrpDelOK);
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

Procedure TMagDBDemo.RPMag3TIUImage(Var Fstat: Boolean; Var Flist: Tstringlist; Magien, TiuDA: String);
Begin
  DemoMessage('  RPMag3TIUImage needs activated for demo');
  Exit;
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
      Flist.Insert(0, '0^ERROR linking Image to TIU:');
      Flist.Insert(1, '0^' + MagPiece(e.Message, #$A, 2));
    End;
  End;

End;

Procedure TMagDBDemo.RPMag4DataFromImportQueue(Var Fstat: Boolean; Var Flist: Tstringlist; QueueNum: String);
Begin
// not needed for demo
  Exit;
  Flist.Clear;
  Fstat := False;
  FBroker.PARAM[0].PTYPE := LITERAL;
  FBroker.PARAM[0].Value := QueueNum;
  FBroker.REMOTEPROCEDURE := 'MAG4 DATA FROM IMPORT QUEUE';
  // GETARR^MAGGSIUI
  Try
    FBroker.LstCALL(Flist);
    If (MagPiece(Flist[0], '^', 1) = '0') Then Exit;
    Fstat := True;
  Except
    On e: Exception Do
    Begin
      // magpiece(E.message, #$A, 3)
      Flist.Insert(0, '0^' + MagPiece(e.Message, #$A, 2));
    End;
  End;
End;

Procedure TMagDBDemo.RPMag4RemoteImport(Var Fstat: Boolean; Var Flist: Tstringlist; DataArray: Tstringlist);
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

Procedure TMagDBDemo.RPMag4ValidateData(Var Fstat: Boolean;
  Var Flist: Tstringlist; t: Tstringlist; Rettype: String);
Var
  i: Integer;
Begin
//not needed for demo
  Exit;
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

Procedure TMagDBDemo.RPTIULongListOfTitles(Var Fstat: Boolean; Var Fmsg: String; Var Flist: TStrings; NoteClass, InputString: String; Mylist: Boolean = False);
Begin
//
End;

Procedure TMagDBDemo.RPMag4StatusCallback(t: TStrings; cb: String; DoStatusCB: Boolean = True);
Var
  i: Integer;
Begin
//not needed for demo
  Exit;
  If (cb = '') Then Exit;
  FBroker.PARAM[0].PTYPE := List;
  FBroker.PARAM[0].Value := '.X';
  //FLoglist.insert(0,xmsg);
  //FLogList.insert(1,FTrkNum);
  //FLogList.insert(2,Qnum);
  For i := 0 To t.Count - 1 Do
    FBroker.PARAM[0].Mult['' + Inttostr(i) + ''] := t[i];
  FBroker.PARAM[1].PTYPE := LITERAL;
  FBroker.PARAM[1].Value := cb;
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

Procedure TMagDBDemo.RPMag4AddImage(Var Fstat: Boolean; Var Flist: Tstringlist; t: Tstringlist);
Var
  i: Integer;
Begin
// not needed for demo
  Exit;
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
    If (MagPiece(Flist[0], '^', 1) = '0') Then Exit;
    Fstat := True;
  Except
    On e: Exception Do
    Begin
      Flist.Insert(0, '0^' + MagPiece(e.Message, #$A, 2));
    End;
  End;
End;

Procedure TMagDBDemo.RPMagABSJB(Var Fstat: Boolean; Var Flist: Tstringlist; CreatAbsIEN, JBCopyIEN: String);
Begin
//not needed for demo
  Exit;
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

Function TMagDBDemo.GetBroker: TRPCBroker;
Begin
//showmessage('  function GetBroker needs activated for demo'); exit;
  Result := FBroker;
End;

Procedure TMagDBDemo.SetBroker(Const Value: TRPCBroker);
Begin
  DemoMessage('  procedure SetBroker needs activated for demo');
  Exit;
  FBroker := Value;
End;

Function TMagDBDemo.GetSilentCodes(Vserver, Vport: String; Var SilentAccess: String; Var SilentVerify: String): Boolean;
Var
  t: TStrings;
Var
  i: Integer;
Begin
// not needed for Demo
  Result := True;
  Exit;
  Result := False;
  If Not FileExists('c:\MySAVC.avc') Then Exit;
  t := Tstringlist.Create;
  Try
    t.LoadFromFile('c:\MySAVC.avc');
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

Procedure TMagDBDemo.RPMag4IAPIStats(Var Fstat: Boolean;
  Var Flist: TStrings; DtStart, DtEnd: String);
Begin
//not needed for Demo
  Exit;
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

(*procedure TMagDBDemo.RPMag4PostProcessing(var Fstat: boolean;
  var Flist: tstringlist; Magien: string);
begin
//not needed for demo
exit;
  Fstat := false;
  Fbroker.Param[0].PType := literal;
  Fbroker.Param[0].Value := Magien;
  Fbroker.RemoteProcedure := 'MAG4 POST PROCESSING';
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

end;   *)

Procedure TMagDBDemo.RPMag3LookupAny(Var Fstat: Boolean; Var Fmsg: String; Var Flist: Tstringlist; InputString: String; Data: String = '');
Begin
  DemoMessage(' ? ? is this called by demo');
  Exit;
  Fstat := False;
  FBroker.PARAM[0].PTYPE := LITERAL;
  FBroker.PARAM[0].Value := InputString;
  FBroker.REMOTEPROCEDURE := 'MAG3 LOOKUP ANY';
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

Procedure TMagDBDemo.RPMag4PostProcessActions(Var Fstat: Boolean;
  Var Flist: Tstringlist; Magien: String);
Begin
//not needed for demo
  Exit;
  Fstat := False;
  FBroker.PARAM[0].PTYPE := LITERAL;
  FBroker.PARAM[0].Value := Magien;
  FBroker.REMOTEPROCEDURE := 'MAG4 POST PROCESS ACTIONS';
  Try
    FBroker.LstCALL(Flist);
    If (MagPiece(Flist[0], '^', 1) = '0') Then Exit;
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

Procedure TMagDBDemo.RPMagPatInfo(Var Fstat: Boolean; Var Fstring: String; MagDFN: String; IsIcn: Boolean = False; IncDeletedCount: Boolean = False);
Var
  Info: String;
Begin
//showmessage(' RPMagPatInfo   '+magdfn+'   needs activated for demo'); exit;
{info =  '1^959^SAHO,F^MALE^00/00/20^821283241^^NON-VETERAN (OTHER)^^0^'}
  Fstat := True;
  Fstring := MagPiece(FPatientList[Strtoint(MagDFN) - 1], '|', 2);
  Exit;

//demo
  Fstat := False;
  FBroker.PARAM[0].PTYPE := LITERAL;
  FBroker.PARAM[0].Value := MagDFN;
  FBroker.REMOTEPROCEDURE := 'MAGG PAT INFO';
  Try
    Info := FBroker.STRCALL;
    If (MagPiece(Info, '^', 1) = '0') Then Exit;
    Fstring := Info;
    Fstat := True;
  Except
    On e: Exception Do
    Begin
      // magpiece(E.message, #$A, 3)
      Fstring := '0^' + MagPiece(e.Message, #$A, 2);
      Exit;
    End;
  End;

End;

(*procedure TMagDBDemo.RPMagIndexType(var Fstat: boolean; var Flist: tstringlist; MagDFN: string);
begin
showmessage(' RPMagIndexType   needs activated for demo'); exit;
  Fstat := false;
  Fbroker.Param[0].PType := literal;
  Fbroker.Param[0].Value := MagDFN;
  Fbroker.RemoteProcedure := 'MAG4 INDEX GET TYPE';
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

Procedure TMagDBDemo.RPIndexGetSpecSubSpec(Lit: TStrings; Cls: String = ''; Proc: String = '';
  IgnoreStatus: Boolean = False;
  IncClass: Boolean = False;
  IncStatus: Boolean = False;
  IncSpec: Boolean = False);
Var
  t: TStrings;
  Ign: String;
Begin
  Lit.LoadFromFile(ExtractFilePath(Application.ExeName) + '\image\MagDemoIndexSpec.txt');
  Lit.Delete(0);
  Exit;
 //demo
  If IgnoreStatus Then
    Ign := '1'
  Else
    Ign := '';
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
  FBroker.PARAM[2].PTYPE := LITERAL;
  FBroker.PARAM[2].Value := Ign;

  Try
    FBroker.LstCALL(t);
    If (t.Count = 0) Then
    Begin
      Lit.Add('<Error loading ''Specialty'' list>');
      //oot 6/18/02 maggmsgf.magmsg('', 'Error loading Index Specialty', nullpanel);
      Exit;
    End;

  Except
    On e: Exception Do
    Begin
      Lit.Add('<Exception loading ''Specialty'' list>');
      //oot 6/18/02      maggmsgf.magmsg('', 'Exception loading Index Specialty', nullpanel);
      Exit;
    End;
  End;
  t.Delete(0);
  Lit.AddStrings(t);
  t.Free;
End;

Procedure TMagDBDemo.RPIndexGetEvent(Lit: TStrings; Cls: String = ''; Spec: String = '';
  IgnoreStatus: Boolean = False;
  IncClass: Boolean = False;
  IncStatus: Boolean = False);
Var
  t: TStrings;
  Ign: String;
Begin
  Lit.LoadFromFile(ExtractFilePath(Application.ExeName) + '\image\MagDemoIndexEvent.txt');
  Lit.Delete(0);
  Exit;
 //demo
  If IgnoreStatus Then
    Ign := '1'
  Else
    Ign := '';
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
  FBroker.PARAM[2].PTYPE := LITERAL;
  FBroker.PARAM[2].Value := Ign;

  Try
    FBroker.LstCALL(t);
    If (t.Count = 0) Then
    Begin
      Lit.Add('<Error loading ''Events'' list>');
      //oot 6/18/02    maggmsgf.magmsg('', 'Error loading Index Events', nullpanel);
      Exit;
    End;

  Except
    On e: Exception Do
    Begin
      Lit.Add('<Exception loading ''Events'' list>');
      //oot 6/18/02 maggmsgf.magmsg('', 'Exception loading Index Events', nullpanel);
      Exit;
    End;
  End;
  t.Delete(0);
  Lit.AddStrings(t);
  t.Free;
End;


{/ JK 11/24/2009 - P108 New Method to retrieve the list of Origins /}
procedure TMagDBDemo.RPIndexGetOrigin(Lit: TStrings);
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
      lit.Add('0^Exception loading ''Origin'' list');
//      Lit.Add('<Error loading ''Origin'' list>');
      Exit;
    end;

  except
    on E:Exception do
    begin
      lit.Add('0^Exception loading ''Origin'' list');
//      Lit.Add('<Exception loading ''Origin'' list>');
      Exit;
    end;
  end;

//  T.Delete(0);
  Lit.AddStrings(T);
  T.Free;
end;


Procedure TMagDBDemo.RPIndexGetType(Lit: TStrings; Cls: String;
  IgnoreStatus: Boolean = False;
  IncClass: Boolean = False;
  IncStatus: Boolean = False);
Var
  t: TStrings;
  Xmsg: String;
  Ign: String;
Begin
  Lit.LoadFromFile(ExtractFilePath(Application.ExeName) + '\image\MagDemoIndexType' + MagPiece(Cls, ',', 1) + '.txt');
  Lit.Delete(0);
  Exit;
 //demo
  If IgnoreStatus Then
    Ign := '1'
  Else
    Ign := '';
  If Not CheckDBConnection(Xmsg) Then Raise Exception.Create(Xmsg);
  Lit.Clear;
  t := Tstringlist.Create;
  // We changed the value of the Constants magiclAdmin, and magiclClin
  // so this isn't needed. (we'll see)
  //if cls = magiclAdmin then cls :="ADMIN,ADMIN/CLIN";
  //if cls = magiclClin then cls :="CLIN,CLIN/ADMIN";
  FBroker.REMOTEPROCEDURE := 'MAG4 INDEX GET TYPE';
  FBroker.PARAM[0].PTYPE := LITERAL;
  FBroker.PARAM[0].Value := Uppercase(Cls);
  FBroker.PARAM[1].PTYPE := LITERAL;
  FBroker.PARAM[1].Value := Ign;

  Try
    FBroker.LstCALL(t);
    If (t.Count = 0) Then
    Begin
      Lit.Add('<Error loading ''Type'' list>');
      //oot 6/18/02       maggmsgf.magmsg('', 'Error loading Index Types', nullpanel);
      Exit;
    End;

  Except
    On e: Exception Do
    Begin
      Lit.Add('<Exception loading ''Type'' list>');
      //oot 6/18/02       maggmsgf.magmsg('', 'Exception loading Index Types', nullpanel);
      Exit;
    End;
  End;
  t.Delete(0);
  Lit.AddStrings(t);
  t.Free;
End;

Procedure TMagDBDemo.RPLogCopyAccess(s: String; IObj: TImageData;
  EventType: TMagImageAccessEventType);
Var
  Ret: String;
Begin
//not needed for demo
  Exit;
  FBroker.PARAM[0].PTYPE := LITERAL;
  FBroker.PARAM[0].Value := s;
  FBroker.REMOTEPROCEDURE := 'MAGGACTION LOG';
  Ret := FBroker.STRCALL;

End;
// 01/21/03   msg => changed to xmsg  (msg is a function)

Function TMagDBDemo.RPVerifyEsig(Esig: String; Var Xmsg: String): Boolean;
Var
  s: String;
Begin
//demo.
  Result := True;
  Xmsg := 'Demo - any signature is okay';
  Exit;

  Esig := Encrypt(Esig);
  FBroker.PARAM[0].PTYPE := LITERAL;
  FBroker.PARAM[0].Value := Esig;
  FBroker.REMOTEPROCEDURE := 'MAGG VERIFY ESIG';
  s := FBroker.STRCALL;
  Xmsg := MagPiece(s, '^', 2);
  Result := (Copy(s, 1, 1) <> '0');
End;

Procedure TMagDBDemo.RPMagGetUserPreferences(Var Fstat: Boolean;
  Var Rpcmsg: String; Xlist: Tstringlist; Code: String = '');
Begin
//showmessage(' RPMagGetUserPreferences   needs activated for demo');
  Fstat := True;
  Xlist.LoadFromFile(ExtractFilePath(Application.ExeName) + '\image\MagDemoPref' + Code + '.txt');
  Xlist.Delete(0);
  Exit;
//demo
  Fstat := True;
  FBroker.REMOTEPROCEDURE := 'MAGGUPREFGET';
  //WinMsg('', 'Applying View preferences...');
  If Code <> '' Then
  Begin
    FBroker.PARAM[0].PTYPE := LITERAL;
    FBroker.PARAM[0].Value := Code;
  End;
  Try
    FBroker.LstCALL(Xlist);
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

Procedure TMagDBDemo.RPMagSetUserPreferences(Var Fstat: Boolean; Var Rpcmsg: String; Xlist: TStrings);
Var
  i: Integer;
  Fld: String;
  Data: String;
Begin
  Fstat := True;
  Rpcmsg := 'Not saved for Demo';
  Exit;
//demo
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
    FBroker.Call;
    If FBroker.Results[0] = '' Then
    Begin
      Fstat := False;
      Rpcmsg := 'The Attempt to save User Preferences Failed. Check VistA Error Log.';

      Exit;
    End;
    Rpcmsg := MagPiece(FBroker.Results[0], '^', 2);
  Except
    On e: EBrokerError Do DemoMessage('Error Communicating with VistA : ' + e.Message);
    On e: Exception Do DemoMessage('An Error occured while connecting to VistA' + #13 + 'Setting were not saved.' + #13 + e.Message);

  Else
    DemoMessage('UnKnown Error while Saving Settings.');
  End;

End;

Procedure TMagDBDemo.RPMag4GetImageInfo(VIobj: TImageData; Var Flist: TStrings; DeletedImagePlaceholders: Boolean = False); {/ P117 - JK 9/20/2010 - added last parameter /}
Begin
//showmessage(' RPMag4GetImageInfo   needs activated for demo');
  Exit;
//demo
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
End;

Procedure TMagDBDemo.RPImageReport(Var Fstat: Boolean; Var Fmsg: String; Flist: TStrings; IObj: TImageData; NoQAcheck: Boolean = False);
Var
  Rptfile: String;
Begin
//showmessage(' RPMagGetImageReport   needs activated for demo');
  Rptfile := MagPiece(IObj.FFile, '.', 1) + '.rpt';
  If FileExists(Rptfile) Then
  Begin
    Flist.LoadFromFile(Rptfile);
    Fstat := True;
    Fmsg := IObj.ImgDes;
  End
  Else
  Begin
    Fstat := False;
    Fmsg := 'Demo Image, report not available';
    Flist.Add('0^Demo Image, report not available');
  End;

  Exit;
//demo

  Flist.Clear;
  Fstat := False;
  FBroker.PARAM[0].Value := IObj.Mag0 + '^';
  FBroker.PARAM[0].PTYPE := LITERAL;
  FBroker.REMOTEPROCEDURE := 'MAGGRPT';
  //maggmsgf.magmsg('', 'Building Image Report...', nilpanel);
  //FBroker.lstcall(t);

  //FBroker.RemoteProcedure := 'MAG3 TIU IMAGE';
  //FBroker.Param[0].Value := magien;
  //FBroker.Param[0].PType := literal;
  //FBroker.Param[1].Value := TIUDA;
  //FBroker.Param[1].PType := literal;
  Try
    FBroker.Call;
    If FBroker.Results.Count = 0 Then
    Begin
      Fmsg := 'Report Failed for Image ID #: ' + IObj.Mag0;
      Flist.Insert(0, '0^ERROR Building Image Report: ');
      Flist.Add(' Report Failed for Image ID #: ' + IObj.Mag0);
      Flist.Add('Check VISTA Error Log.');
      //maggmsgf.magmsg('DE', ': The Attempt to build the Image report Failed. Check VISTA Error Log.', nilpanel);
      //maggmsgf.magmsg('s', ' Report Failed for Image IEN: '+ien,nilpanel);
      //maggmsgf.magmsg('', '', nilpanel);
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

End;

(*procedure TMagDBDemo.RPMagGetImageReport(var Fstat: boolean; var Fmsg: string; Flist: tstrings; magien: string);
begin
//showmessage(' RPMagGetImageReport   needs activated for demo');
fstat := false;
fmsg := 'Demo Image, report not available "GetImageReport"';
Flist.add('0^Demo Image, report not available "GetImageReport"');
exit;
//demo

  Flist.clear;
  Fstat := false;
  FBroker.Param[0].Value := magien + '^';
  FBroker.Param[0].PType := literal;
  FBroker.remoteprocedure := 'MAGGRPT';
  //maggmsgf.magmsg('', 'Building Image Report...', nilpanel);
  //FBroker.lstcall(t);

  //FBroker.RemoteProcedure := 'MAG3 TIU IMAGE';
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
      //maggmsgf.magmsg('DE', ': The Attempt to build the Image report Failed. Check VISTA Error Log.', nilpanel);
      //maggmsgf.magmsg('s', ' Report Failed for Image IEN: '+ien,nilpanel);
      //maggmsgf.magmsg('', '', nilpanel);
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

Function TMagDBDemo.CheckDBConnection(Var Xmsg: String): Boolean;
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

Function TMagDBDemo.RPMag4GetFileFormatInfo(Ext: String; Var Xmsg: String): Boolean;
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

Procedure TMagDBDemo.RPMaggImageInfo(Var Rstat: Boolean; Var Rmsg: String; Var Rlist: TStrings; Ien: String; NoQAcheck: Boolean = False);
Begin
  Rstat := False;
  With FBroker Do
  Begin
    PARAM[0].Value := Ien;
    PARAM[0].PTYPE := LITERAL;
    REMOTEPROCEDURE := 'MAGG IMAGE INFO';
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

Procedure TMagDBDemo.RPMaggRadExams(Var Rstat: Boolean; Var Rmsg: String; Var Rlist: TStrings; DFN: String);
Begin
{ TODO : Get a list of Rad Exams for one of the demo patients. }
  Rlist.Add('0^No Radiology Exams for demo.');
  Rstat := False;
  Rmsg := ' RPMaggRadExams   needs activated for demo';
  Exit;
  Rstat := False;
  With FBroker Do
  Begin
    PARAM[0].Value := DFN + '^1';
    PARAM[0].PTYPE := LITERAL;
    REMOTEPROCEDURE := 'MAGGRADLIST';
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
    If Strtoint(MagPiece(Rlist[0], '^', 1)) > 0 Then Rmsg := MagPiece(Rlist[0], '^', 1) + ' ' + Rmsg;

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

Procedure TMagDBDemo.RPMaggCPRSRadExam(Var Rstat: Boolean; Var Rmsg: String; Var Rlist: TStrings; CprsString: String);
Begin
  Rstat := False;
  With FBroker Do
  Begin
    PARAM[0].Value := CprsString;
    PARAM[0].PTYPE := LITERAL;
    REMOTEPROCEDURE := 'MAGG CPRS RAD EXAM';
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

Procedure TMagDBDemo.RPMaggUser2(Var Rstat: Boolean; Var Rmsg: String; Var Rlist: TStrings; Wsid: String; pSess: TSession = Nil);
Begin
  Rstat := True;
  Rlist.LoadFromFile(ExtractFilePath(Application.ExeName) + '\image\MagDemoUser2.txt');
  Exit;
//demo;
  Rstat := False;
  With FBroker Do
  Begin
    PARAM[0].Value := Wsid;
    PARAM[0].PTYPE := LITERAL;
    REMOTEPROCEDURE := 'MAGGUSER2';
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

Procedure TMagDBDemo.RPMaggDGRPD(Var Rstat: Boolean; Var Rmsg: String; Var Rlist: Tstringlist; DFN: String);
Begin
  Rmsg := ' RPMaggDGRPD  is activated for demo';

  Rstat := True;
  Rlist.LoadFromFile(ExtractFilePath(Application.ExeName) + '\image\MagDemoPatientProfile' + DFN + '.TXT');
  Rlist.Delete(0);
  Exit;
//demo
  Rstat := False;
  With FBroker Do
  Begin
    PARAM[0].Value := DFN;
    PARAM[0].PTYPE := LITERAL;
    REMOTEPROCEDURE := 'MAGGDGRPD';
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

Procedure TMagDBDemo.RPMaggRadImage(Var Rstat: Boolean; Var Rmsg: String; Var Tlist: Tstringlist; Radstring: String);
Begin
  Rstat := False;
  With FBroker Do
  Begin
    PARAM[0].Value := Radstring;
    PARAM[0].PTYPE := LITERAL;
    REMOTEPROCEDURE := 'MAGGRADIMAGE';
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

Procedure TMagDBDemo.RPMaggRadReport(Var Rstat: Boolean; Var Rmsg: String; Var Tlist: Tstringlist; Rarpt: String);
Begin
  Rstat := False;
  With FBroker Do
  Begin
    PARAM[0].Value := Rarpt;
    PARAM[0].PTYPE := LITERAL;
    REMOTEPROCEDURE := 'MAGGRADREPORT';
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

Procedure TMagDBDemo.RPMaggHSList(Var Rstat: Boolean; Var Rmsg: String; Var Tlist: Tstringlist; Value: String);
Begin
  Rmsg := ' RPMaggHSList  activated for demo';

  Rstat := True;
  Tlist.LoadFromFile(ExtractFilePath(Application.ExeName) + '\image\MagDemoHSList.TXT');
  Tlist.Delete(0);
  Exit;
//demo
  Rstat := False;
  With FBroker Do
  Begin
    PARAM[0].Value := Value;
    PARAM[0].PTYPE := LITERAL;
    REMOTEPROCEDURE := 'MAGGHSLIST';
  End;
  Try
    FBroker.LstCALL(Tlist);
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
  (*
  xBrokerx.param[0].value := 'hs';
  xBrokerx.param[0].ptype := literal;
  xBrokerx.remoteprocedure := 'MAGGHSLIST';
  xBrokerx.call;
  st := magpiece(xBrokerx.results[0], '^', 1);
  if (st = '0') then
  begin MaggMsgf.magmsg('', magpiece(xBrokerx.results[0], '^', 2), msg);
    exit;
  end;
  xBrokerx.results.delete(0);
  *)
End;

Procedure TMagDBDemo.RPMaggHS(Var Rstat: Boolean; Var Rmsg: String; Var Tlist: Tstringlist; Value: String);
Begin
  Rstat := True;
  Rmsg := 'Demo HealthSummary Report';
  Tlist.LoadFromFile(ExtractFilePath(Application.ExeName) + 'image\MagDemoHSReport-' + MagPiece(Value, '^', 2) + '.TXT');
  Tlist.Delete(0);
//FPatientlist.LoadFromFile(ExtractFilePath(application.exename)+'image\MagDemoHSReport-'+magpiece(value,'^',2)+'.TXT');
  Exit;
//demo
  Rstat := False;
  With FBroker Do
  Begin
    PARAM[0].Value := Value;
    PARAM[0].PTYPE := LITERAL;
    REMOTEPROCEDURE := 'MAGGHS';
  End;
  Try
    FBroker.LstCALL(Tlist);
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
      Maggmsgf.MagMsg('de', 'Failed to build Patient Health Summary. Check VISTA Error Log.', msg);
      MaggMsgf.magmsg('e', 'ERROR: Health Summary Failed. Check VISTA Error Log.', msg);
      exit;
    end;
    if magpiece(t[0], '^', 1) = '0' then Maggmsgf.MagMsg('', magpiece(t[0], '^', 2), msg);
    if magpiece(t[0], '^', 1) <> '0' then begin
      t.delete(0);
*)
End;

(*
procedure TMagDBDemo.RPMag...(var rstat: boolean; var rmsg: string; var rlist: tstrings; xxx : string);
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

    remoteprocedure := 'MAG......';
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

Procedure TMagDBDemo.RPGetFileExtensions(Var t: TStrings);
Begin
  FBroker.REMOTEPROCEDURE := 'MAG4 GET SUPPORTED EXTENSIONS';
  Try
    FBroker.LstCALL(t);
  Except
    On e: Exception Do
    Begin
      t.Insert(0, '0^Error: Getting supported Extensions.');
        //maggmsgf.magmsg('de', 'VistA Error: ' + magpiece(e.message, #$A, 2));
      MagLogger.MagMsg('de', 'VistA Error: ' + MagPiece(e.Message, #$A, 2)); {JK 10/5/2009 - Maggmsgu refactoring}
    End;
  End;
End;

Procedure TMagDBDemo.RPUpdateConsult(Consult, TiuIen, cmpFlag: String; Var Status: String);
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
        //maggmsgf.magmsg('de', 'VistA Error: ' + magpiece(e.message, #$A, 2));
      MagLogger.MagMsg('de', 'VistA Error: ' + MagPiece(e.Message, #$A, 2)); {JK 10/5/2009 - Maggmsgu refactoring}
    End;
  End;
End;

Function TMagDBDemo.RPTIUCPClass: Integer;
Var
  s: String;
Begin
  Result := 4;
  DemoMessage(' RPTIUCPClass   needs activated for demo');
  Exit;
//demo
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

Function TMagDBDemo.RPTIUConsultsClass: Integer;
Var
  s: String;
Begin
  Result := 5;
  DemoMessage(' RPTIUConsultsClass   needs activated for demo');
  Exit;
//demo

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

Procedure TMagDBDemo.RPMagLogErrorText(t: TStrings; Count: Integer);
Var
  i, j: Integer;

Begin
  i := t.Count;
  If (i < Count) Then Count := i;
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

Procedure TMagDBDemo.RPMagGetNetLoc(Var Success: Boolean; Var RPmsg: String; Var Shares: Tstringlist; NetLocType: String);
Begin
  Success := True;
  RPmsg := 'Demo DataBase';
  Exit;
//demo
  (* Get all network locations and their properties *)
  Success := False;
  Try
    FBroker.PARAM[0].Value := NetLocType;
    FBroker.PARAM[0].PTYPE := LITERAL;
    FBroker.REMOTEPROCEDURE := 'MAG GET NETLOC';
    FBroker.LstCALL(Shares);
    If (MagPiece(Shares[0], '^', 1) = '0') Then
    Begin
        //maggmsgf.MagMsg('', magpiece(Shares[0], '^', 2));
      MagLogger.MagMsg('', MagPiece(Shares[0], '^', 2)); {JK 10/5/2009 - Maggmsgu refactoring}
      RPmsg := Shares[0];
      Exit;
    End;
    If (Shares.Count = 0) Then
    Begin
        //maggmsgf.MagMsg('', 'Error accessing Network Locations');
      MagLogger.MagMsg('', 'Error accessing Network Locations'); {JK 10/5/2009 - Maggmsgu refactoring}
      RPmsg := 'Error accessing Network Locations ';
      Exit;
    End;
    Success := True;
    RPmsg := Shares[0];
    Shares.Delete(0);

  Except
    On e: Exception Do
    Begin
      DemoMessage(e.Message);
      Shares[0] := 'The Attempt to get network locations. Check VistA Error Log.';
    End;
  End;

End;

Function TMagDBDemo.RPMagEkgOnline: Integer;
Begin
  Result := 0;
  Exit;
//demo
  (* get the status of the first EKG server 0=offline 1=online - if no server exists 0 is returned *)
  FBroker.REMOTEPROCEDURE := 'MAG EKG ONLINE';
  Result := Strtoint(FBroker.STRCALL);

End;

Procedure TMagDBDemo.RPMaggOffLineImageAccessed(IObj: TImageData);
Begin
  With FBroker Do
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

Procedure TMagDBDemo.RPMag3Logaction(ActionString: String; IObj: TImageData);
Begin
//not needed for demo
  Exit;
  With FBroker Do
  Begin
    PARAM[0].Value := ActionString;
    PARAM[0].PTYPE := LITERAL;
    REMOTEPROCEDURE := 'MAG3 LOGACTION';
    Call;
  End;
End;

Procedure TMagDBDemo.RPMaggQueImage(IObj: TImageData);
Begin
//not needed for demo
  Exit;

  With FBroker Do
  Begin
    PARAM[0].Value := 'AF';
    PARAM[0].PTYPE := LITERAL;
    PARAM[1].Value := IObj.Mag0;
    PARAM[1].PTYPE := LITERAL;
    REMOTEPROCEDURE := 'MAGG QUE IMAGE';
      //maggmsgf.magmsg('s', '--RPC : MAGG QUE IMAGE ^AF^' + IObj.mag0);
    MagLogger.MagMsg('s', '--RPC : MAGG QUE IMAGE ^AF^' + IObj.Mag0); {JK 10/5/2009 - Maggmsgu refactoring}
    Try
      Call;
        //maggmsgf.MagMsg('S', '--' + FBroker.RESULTS[0]);
      MagLogger.MagMsg('S', '--' + FBroker.Results[0]); {JK 10/5/2009 - Maggmsgu refactoring}
    Except
      Messagedlg('Error attempting to set the Queue ' + #13 + 'to copy an Image from the Juke Box.'
        + #13 + 'Not Fatal, Process will continue.', MtWarning, [Mbok], 0);
    End;
  End;
End;

Procedure TMagDBDemo.RPMaggQueBigImage(IObj: TImageData);
Begin
//not needed for demo
  Exit;
  With FBroker Do
  Begin
    PARAM[0].Value := 'B';
    PARAM[0].PTYPE := LITERAL;
    PARAM[1].Value := IObj.Mag0;
    PARAM[1].PTYPE := LITERAL;
    REMOTEPROCEDURE := 'MAGG QUE IMAGE';
      //maggmsgf.magmsg('s', '--RPC : MAGG QUE IMAGE ^B^' + IObj.mag0);
    MagLogger.MagMsg('s', '--RPC : MAGG QUE IMAGE ^B^' + IObj.Mag0); {JK 10/5/2009 - Maggmsgu refactoring}
    Try
      Call;
        //maggmsgf.MagMsg('S', '--' + FBroker.RESULTS[0]);
      MagLogger.MagMsg('S', '--' + FBroker.Results[0]); {JK 10/5/2009 - Maggmsgu refactoring}
    Except
      Messagedlg('Error attempting to set the Queue ' + #13 + 'to copy a BIG Image from the Juke Box.'
        + #13 + 'Not Fatal, Process will continue.', MtWarning, [Mbok], 0);
    End;
  End;
End;
// Queue all images for a Patient to be copied from JukeBox to HD.

Procedure TMagDBDemo.RPMaggQuePatient(Whichimages, DFN: String);
Var
  s: String;
Begin
//not needed for demo
  Exit;
  { whichimages is a code of 'A' for abstract
                             'F' for Full }
  With FBroker Do
  Begin
    PARAM[0].Value := Whichimages;
    PARAM[0].PTYPE := LITERAL;
    PARAM[1].Value := DFN;
    PARAM[1].PTYPE := LITERAL;
    REMOTEPROCEDURE := 'MAGG QUE PATIENT';
      //maggmsgf.magmsg('s', '--RPC : MAGG QUE PATIENT ^' + whichimages + '^' + dfn);
    MagLogger.MagMsg('s', '--RPC : MAGG QUE PATIENT ^' + Whichimages + '^' + DFN); {JK 10/5/2009 - Maggmsgu refactoring}
    s := STRCALL;
      //maggmsgf.MagMsg('s', '--' + s);
    MagLogger.MagMsg('s', '--' + s); {JK 10/5/2009 - Maggmsgu refactoring}
  End;
End;
// Queue images to be Copied from JukeBox.
//  The RPC Call "M" code, determines if the iamges need to be queued.
//  and if true.  Makes the call to set the JBtoHD Queue.

Procedure TMagDBDemo.RPMaggQueImageGroup(Whichimages: String; IObj: TImageData);
Var
  s: String;
Begin
//not needed for demo
  Exit;
  { whichimages is a code of 'A' for abstract
                             'F' for Full }
  Try
    With FBroker Do
    Begin
      PARAM[0].Value := Whichimages;
      PARAM[0].PTYPE := LITERAL;
      PARAM[1].Value := IObj.Mag0;
      PARAM[1].PTYPE := LITERAL;
      REMOTEPROCEDURE := 'MAGG QUE IMAGE GROUP';
        //maggmsgf.magmsg('s', '--RPC : MAGG QUE IMAGE GROUP^' + whichimages + '^' + Iobj.Mag0);
      MagLogger.MagMsg('s', '--RPC : MAGG QUE IMAGE GROUP^' + Whichimages + '^' + IObj.Mag0); {JK 10/5/2009 - Maggmsgu refactoring}
      s := STRCALL;
        //maggmsgf.MagMsg('s', '--' + s);
      MagLogger.MagMsg('s', '--' + s); {JK 10/5/2009 - Maggmsgu refactoring}
    End;
  Except
    //
  End;
End;
// Returns all images for an Image Group.

Procedure TMagDBDemo.RPMaggGroupImages(IObj: TImageData; Var t: Tstringlist; NoQAcheck: Boolean = False; DeletedImages: String = '');
Begin
  t.LoadFromFile(ExtractFilePath(IObj.FFile) + '\MagdemoImageList.txt');

  Exit;
//demo
  With FBroker Do
  Begin
    PARAM[0].Value := IObj.Mag0;
    PARAM[0].PTYPE := LITERAL;
    REMOTEPROCEDURE := 'MAGG GROUP IMAGES'; //MAGOGLU';
    LstCALL(t);
  End;
End;

// Gets all images for a patient.  Groups are returned as one item.
//   Single images are returned as one item.

(*procedure TMagDBDemo.RPMaggPatImages(DFN: string; var t: tstringlist);
begin
  with FBroker do
    begin
      param[0].Value := DFN;
      param[0].PType := literal;
      remoteprocedure := 'MAGG PAT IMAGES';
      lstCall(t);
    end;
end; *)
// This call returns all images, it returns the images of a group, instead
// of returning the Group.

Procedure TMagDBDemo.RPMaggPatEachImage(DFN, Max: String; Var t: Tstringlist);
Begin
//not needed for demo
  Exit;
  With FBroker Do
  Begin
    PARAM[0].Value := DFN;
    PARAM[0].PTYPE := LITERAL;
    PARAM[1].Value := Max;
    PARAM[1].PTYPE := LITERAL;
    REMOTEPROCEDURE := 'MAGG PAT EACH IMAGE';
    LstCALL(t);
  End;
End;

Procedure TMagDBDemo.CreateBroker;
Begin
//not needed for demo
  Exit;
  If Not Assigned(FBroker) Then
  Begin
    FBroker := TCCOWRPCBroker.Create(Nil);
  End;
End;

Procedure TMagDBDemo.SetContextor(Contextor: TContextorControl);
Begin
  TCCOWRPCBroker(FBroker).Contextor := Contextor;
End;

Procedure TMagDBDemo.RPMaggLogOff;
Begin
  FDemoConnected := False;
  Exit;
//demo
  If Not FBroker.Connected Then Exit;

  FBroker.REMOTEPROCEDURE := 'MAGG LOGOFF';
  Try
    FBroker.Call;
  Except
    On e: EBrokerError Do
      //maggmsgf.magmsg('de', 'Error Connecting to VISTA.' + #13 + #13 + E.MESSAGE + #13 + #13 + 'Shutdown will continue.');
      MagLogger.MagMsg('de', 'Error Connecting to VISTA.' + #13 + #13 + e.Message + #13 + #13 + 'Shutdown will continue.'); {JK 10/5/2009 - Maggmsgu refactoring}
    On e: Exception Do
      //maggmsgf.magmsg('de', 'Error During Log Off : ' + e.message);
      MagLogger.MagMsg('de', 'Error During Log Off : ' + e.Message); {JK 10/5/2009 - Maggmsgu refactoring}
  Else
    //maggmsgf.magmsg('de', 'Unknown Error during Log Off');
    MagLogger.MagMsg('de', 'Unknown Error during Log Off'); {JK 10/5/2009 - Maggmsgu refactoring}
  End;
  FBroker.Connected := False;
End;

Procedure TMagDBDemo.RPMaggWrksUpdate(AppPath, DispAppName, CapAppName, Compname, Location, LastUpdate: String; Startmode: Integer);
Var
  DtCapture, DtDisplay: String;
Begin
//not needed for demo
  Exit;
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

  FBroker.REMOTEPROCEDURE := 'MAGG WRKS UPDATES';
  FBroker.PARAM[0].PTYPE := LITERAL;
  FBroker.PARAM[0].Value := Compname
    + '^' + DtCapture
    + '^' + DtDisplay
    + '^' + Location
    + '^' + LastUpdate
    + '^' + MagGetFileVersionInfo(DispAppName)
    + '^' + MagGetFileVersionInfo(CapAppName)
    + '^' + Inttostr(Startmode)
    + '^' + MagGetOSVersion
    + '^';
  FBroker.Call;
  //maggmsgf.magmsg('s', 'Workstation Information sent to VistA:');
  MagLogger.MagMsg('s', 'Workstation Information sent to VistA:'); {JK 10/5/2009 - Maggmsgu refactoring}
  //maggmsgf.magmsg('s', '  -> Result = ' + FBroker.results[0]);
  MagLogger.MagMsg('s', '  -> Result = ' + FBroker.Results[0]); {JK 10/5/2009 - Maggmsgu refactoring}

End;

Procedure TMagDBDemo.RPMaggUserKeys(Var t: Tstringlist);
Begin
  t.LoadFromFile(ExtractFilePath(Application.ExeName) + 'image\magdemokeys.txt');
  Exit;
  //demo
  FBroker.REMOTEPROCEDURE := 'MAGGUSERKEYS';
  FBroker.LstCALL(t);
  //maggmsgf.MagMsgs('', t);
  MagLogger.MagMsgs('', t); {JK 10/5/2009 - Maggmsgu refactoring}
End;

Procedure TMagDBDemo.RPMaggGetTimeout(app: String; Var Minutes: String);
Begin
//not needed for demo
  Exit;
  FBroker.REMOTEPROCEDURE := 'MAGG GET TIMEOUT';
  FBroker.PARAM[0].PTYPE := LITERAL;
  FBroker.PARAM[0].Value := app;
  Minutes := FBroker.STRCALL;

End;

Procedure TMagDBDemo.RPGetDischargeSummaries(DFN: String; Var t: Tstringlist);
Begin
  DemoMessage(' RPGetDischargeSummaries   needs activated for demo');
  Exit;
//demo

  FBroker.REMOTEPROCEDURE := 'TIU SUMMARIES';
  FBroker.PARAM[0].PTYPE := LITERAL;
  FBroker.PARAM[0].Value := DFN;
  FBroker.LstCALL(t);
End;

Procedure TMagDBDemo.RPGetNoteText(TiuDA: String; t: TStrings);
Begin
  FBroker.REMOTEPROCEDURE := 'TIU GET RECORD TEXT';
  FBroker.PARAM[0].PTYPE := LITERAL;
  FBroker.PARAM[0].Value := TiuDA;
  FBroker.LstCALL(t);
End;

Procedure TMagDBDemo.RPGetNoteTitles(t, Tint: Tstringlist);
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

Function TMagDBDemo.RPCreateRecord(Var Msg: String; DFN, Notetitle, Notedate: String; Notetext: TStrings): Boolean;
Var
  i: Integer;
  s: String;
Begin
//not needed for demo
  Result := True;
  Exit;
  If DFN = '' Then
  Begin
    Result := False;
    Msg := 'Need to Select a Patient';
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

Function TMagDBDemo.RPGetFileManDateTime(DateStr: String; Var DisDt, IntDT: String; NoFuture: Boolean = False): Boolean;
Var
  Dt: String;
  { this returns 1 ^ Display Date ^ internal date
            or   0 ^ error msg     }
Begin
//not needed for demo
  Result := True;
  Exit;
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

  If Maglength(DisDt, ':') > 2 Then DisDt := MagPiece(DisDt, ':', 1) + ':' + MagPiece(DisDt, ':', 2);

  IntDT := MagPiece(Dt, '^', 3);
  Result := True;
End;

Function TMagDBDemo.RPSignRecord(TiuDA, Hashesign: String; Var Msg: String): Boolean;
Var
  s: String;
Begin
//not needed for demo
  Result := True;
  Exit;
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

Procedure TMagDBDemo.RPGetNotesByContext(DFN: String; Var t: Tstringlist; Context: Integer; Author, Count: String; Docclass: Integer; Seq: String; Showadd: Integer; Incund: Integer; Mthsback: Integer
  = 0; Dtfrom: String = ''; Dtto: String = '');
Begin
  DemoMessage('  procedure RPGetNotesByContext needs activated for demo');
  Exit;
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
  FBroker.REMOTEPROCEDURE := 'TIU DOCUMENTS BY CONTEXT';
  FBroker.PARAM[0].PTYPE := LITERAL;
  FBroker.PARAM[0].Value := Inttostr(Docclass); // CPMOD was just '3'
  FBroker.PARAM[1].PTYPE := LITERAL;
  FBroker.PARAM[1].Value := Inttostr(Context);
  FBroker.PARAM[2].PTYPE := LITERAL;
  FBroker.PARAM[2].Value := DFN;
  FBroker.PARAM[3].PTYPE := LITERAL;
  FBroker.PARAM[3].Value := '';
  FBroker.PARAM[4].PTYPE := LITERAL;
  FBroker.PARAM[4].Value := '';
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
  FBroker.LstCALL(t);
End;

Function TMagDBDemo.RPGetTIUData(TiuDA: String; Var TiuPTR: String): Boolean;
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

Procedure TMagDBDemo.RPGetCPRSTIUNotes(TiuDA: String; t: Tstringlist; Var Success: Boolean; Var RPmsg: String);
Begin
  Success := False;
  Try
    FBroker.REMOTEPROCEDURE := 'MAG3 CPRS TIU NOTE';
    FBroker.PARAM[0].PTYPE := LITERAL;
    FBroker.PARAM[0].Value := TiuDA;
    FBroker.LstCALL(t);
    If (MagPiece(t[0], '^', 1) = '0') Then
    Begin
        //maggmsgf.MagMsg('', magpiece(t[0], '^', 2));
      MagLogger.MagMsg('', MagPiece(t[0], '^', 2)); {JK 10/5/2009 - Maggmsgu refactoring}
      RPmsg := t[0];
      Exit;
    End;
    If (t.Count = 0) Then
    Begin
        //maggmsgf.MagMsg('', 'Error accessing Images for TIU Note ');
      MagLogger.MagMsg('', 'Error accessing Images for TIU Note '); {JK 10/5/2009 - Maggmsgu refactoring}
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
      MagLogger.MagMsg('', 'Exception accessing Images for TIU Note '); {JK 10/5/2009 - Maggmsgu refactoring}
      RPmsg := 'Exception accessing Images for TIU Note ';
    End;
  End;
End;

//procedure RPMagCategories(var t, tien: tstrings);

(*procedure TMagDBDemo.RPMagCategories(t: tstrings);
begin
  //ADMINDOC
  try
    t.clear;
    //tien.clear;
    FBroker.remoteprocedure := 'MAGGDESCCAT';
    FBroker.lstcall(t);
    if (t.count = 0) then
      begin
        maggmsgf.magmsg('', 'Error loading Image Cagetories.');
        exit;
      end;
    if (t.count = 1) then maggmsgf.magmsg('de', magpiece(t[0], '^', 2));
    t.delete(0);

  except
    on e: exception do maggmsgf.magmsg('de', 'Exception ' + e.message);
  end;
end;
  *)

Procedure TMagDBDemo.RPGetClinProcReq(DFN: String; Var t: TStrings);
Begin
  //  success := false;
  Try
    FBroker.REMOTEPROCEDURE := 'MAG4 CP GET REQUESTS';
    FBroker.PARAM[0].PTYPE := LITERAL;
    FBroker.PARAM[0].Value := DFN;
    FBroker.LstCALL(t);
    If (MagPiece(t[0], '^', 1) = '0') Then
    Begin
        //maggmsgf.MagMsg('', magpiece(t[0], '^', 2));
      MagLogger.MagMsg('', MagPiece(t[0], '^', 2)); {JK 10/5/2009 - Maggmsgu refactoring}
      Exit;
    End;
    If (t.Count = 0) Then
    Begin
        //maggmsgf.MagMsg('', 'Error while listing CP Requests. ');
      MagLogger.MagMsg('', 'Error while listing CP Requests. '); {JK 10/5/2009 - Maggmsgu refactoring}
      t.Add('0^Error while listing CP Requests. ');
      Exit;
    End;
    //    success := true;
    t.Delete(0);
  Except
    On e: Exception Do
    Begin
        //maggmsgf.MagMsg('', 'Exception while listing CP Requests. ');
      MagLogger.MagMsg('', 'Exception while listing CP Requests. '); {JK 10/5/2009 - Maggmsgu refactoring}
      t.Insert(0, '0^Exception while listing CP Requests. ');
    End;
  End;
End;

Procedure TMagDBDemo.RPGetTIUDAfromClinProcReq(DFN, FConsIEN, Vstring, Complete: String; Var t: TStrings);
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
        //maggmsgf.MagMsg('', magpiece(t[0], '^', 2));
      MagLogger.MagMsg('', MagPiece(t[0], '^', 2)); {JK 10/5/2009 - Maggmsgu refactoring}
      Exit;
    End;
    If (t.Count = 0) Then
    Begin
        //maggmsgf.MagMsg('', 'Error (#34) in VistA');
      MagLogger.MagMsg('', 'Error (#34) in VistA'); {JK 10/5/2009 - Maggmsgu refactoring}
      t.Add('0^Error (#34) in VistA');
      Exit;
    End;
    //    success := true;
    //     t.delete(0);
  Except
    On e: Exception Do
    Begin
        //maggmsgf.MagMsg('', 'Exception (#34) in VistA');
      MagLogger.MagMsg('', 'Exception (#34) in VistA'); {JK 10/5/2009 - Maggmsgu refactoring}
      t.Insert(0, '0^Exception (#34) in VistA');
    End;
  End;

End;

Procedure TMagDBDemo.RPGetVisitListForReq(DFN: String; Var t: TStrings);
Begin
  //  success := false;
  Try
    FBroker.REMOTEPROCEDURE := 'MAG4 CP GET VISITS';
    FBroker.PARAM[0].PTYPE := LITERAL;
    FBroker.PARAM[0].Value := DFN;
    FBroker.LstCALL(t);
    If (MagPiece(t[0], '^', 1) = '0') Then
    Begin
        //maggmsgf.MagMsg('', magpiece(t[0], '^', 2));
      MagLogger.MagMsg('', MagPiece(t[0], '^', 2)); {JK 10/5/2009 - Maggmsgu refactoring}
      Exit;
    End;
    If (t.Count = 0) Then
    Begin
        //maggmsgf.MagMsg('', 'Error Listing Patient visits.');
      MagLogger.MagMsg('', 'Error Listing Patient visits.'); {JK 10/5/2009 - Maggmsgu refactoring}
      t.Add('0^Error Listing Patient visits.');
      Exit;
    End;
    //    success := true;

    t.Delete(0);
  Except
    On e: Exception Do
    Begin
        //maggmsgf.MagMsg('', 'Exception Listing Patient visits.');
      MagLogger.MagMsg('', 'Exception Listing Patient visits.'); {JK 10/5/2009 - Maggmsgu refactoring}
      t.Insert(0, '0^Exception Listing Patient visits.');
    End;
  End;
End;

Procedure TMagDBDemo.RPMagVersionCheck(t: TStrings; Version: String);
Begin
  t.Add('1^Demo Version 1.1');
  Exit;
//demo;
  FBroker.REMOTEPROCEDURE := 'MAG4 VERSION CHECK';
  FBroker.PARAM[0].PTYPE := LITERAL;
  FBroker.PARAM[0].Value := Version;

  Try
    FBroker.LstCALL(t);
    If (t.Count = 0) Then
    Begin
      t.Insert(0, '1^continue');
        //maggmsgf.magmsg('', 'Error Checking Version on Server');
      MagLogger.MagMsg('', 'Error Checking Version on Server'); {JK 10/5/2009 - Maggmsgu refactoring}
      Exit;
    End;

  Except
    On e: Exception Do
    Begin
      t.Insert(0, '1^continue');
        //maggmsgf.magmsg('de', 'Exception ' + e.message);
      MagLogger.MagMsg('de', 'Exception ' + e.Message); {JK 10/5/2009 - Maggmsgu refactoring}
    End;
  End;
End;

Function TMagDBDemo.RPFileManDate(Var Xmsg: String; DateInput: String; Var DateOutput: String; NoFuture: Boolean = False): Boolean;
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
  If Uppercase(s) = 'T' Then s := 'N';
  With FBroker Do
  Begin
    PARAM[0].PTYPE := LITERAL;
    PARAM[0].Value := s;
    If NoFuture Then
    Begin
      PARAM[1].PTYPE := LITERAL;
      PARAM[1].Value := '1';
    End;
    REMOTEPROCEDURE := 'MAGG DTTM';
    Call;
    s := Results[0];
  End;
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
  X2 := MagPiece(X2, ':', 1) + ':' + MagPiece(X2, ':', 2);
  X3 := Copy(X3, 1, 12);

  DateOutput := X2 + '^' + X3;
  Result := True;
End;

Procedure TMagDBDemo.RPXMultiProcList(Lit: TStrings; DFN: String); // proclist: Tstrings);
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
        //maggmsgf.magmsg('', 'Error loading Procedure listing.');
      MagLogger.MagMsg('', 'Error loading Procedure listing.'); {JK 10/5/2009 - Maggmsgu refactoring}
      Exit;
    End;

  Except
    On e: Exception Do
    Begin
      Lit.Add('<Exception loading ''Procedure'' list>');
        //maggmsgf.magmsg('', 'Exception loading Procedure listing');
      MagLogger.MagMsg('', 'Exception loading Procedure listing'); {JK 10/5/2009 - Maggmsgu refactoring}
      Exit;
    End;
  End;
  t.Delete(0);
  Lit.AddStrings(t);
  t.Free;
End;

Procedure TMagDBDemo.RPCTPresetsGet(Var Rstat: Boolean; Var Rmsg: String; Var Value: String);
Var
  Xmsg: String;
Begin
  Rstat := False;
  Exit;
//demo
  Rstat := False;
  With FBroker Do
  Begin
    REMOTEPROCEDURE := 'MAG4 CT PRESETS GET';
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
        //maggmsgf.MagMsg('s', e.message);
      MagLogger.MagMsg('s', e.Message); {JK 10/5/2009 - Maggmsgu refactoring}
    End;
  End;
End;

Procedure TMagDBDemo.RPCTPresetsSave(Var Rstat: Boolean; Var Rmsg: String; Value: String);
Var
  Xmsg: String;
Begin
  Rstat := False;
  Exit;
//demo
  Rstat := False;
  With FBroker Do
  Begin
    PARAM[0].PTYPE := LITERAL;
    PARAM[0].Value := Value;
    REMOTEPROCEDURE := 'MAG4 CT PRESETS SAVE';
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
        //maggmsgf.MagMsg('s', e.message);
      MagLogger.MagMsg('s', e.Message); {JK 10/5/2009 - Maggmsgu refactoring}
    End;
  End;

End;

Procedure TMagDBDemo.RPFilterListGet(Var Rstat: Boolean; Var Rmsg: String; Var Tlist: TStrings; Duz: String = ''; Getall: Boolean = False);
Begin
  Tlist.LoadFromFile(ExtractFilePath(Application.ExeName) + '\image\MagDemoFilterList' + Duz + '-' + Magbooltostrint(Getall) + '.txt');
  Tlist.Delete(0);
  Rstat := True;
  Rmsg := '';
  Exit;
//demo
  Rstat := False;
  With FBroker Do
  Begin
    PARAM[0].Value := Duz;
    PARAM[0].PTYPE := LITERAL;
    PARAM[1].Value := Magbooltostrint(Getall);
    PARAM[1].PTYPE := LITERAL;
    REMOTEPROCEDURE := 'MAG4 FILTER GET LIST';
  End;
  Try
    FBroker.LstCALL(Tlist);
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
End;

Procedure TMagDBDemo.RPFilterDetailsGet(Var Rstat: Boolean; Var Rmsg, Filter: String; Fltien: String; Fltname: String = ''; Duz: String = '');
Var
  Vlist: TStrings;
  Fltlist: TStrings;
  i: Integer;
Begin
  Vlist := Tstringlist.Create;
  Try
    If Fltien = '' Then
    Begin
      Fltlist := Tstringlist.Create;
      Fltlist.LoadFromFile(ExtractFilePath(Application.ExeName) + '\image\MagDemoFilterList' + FDuz + '-1.txt');
      Fltlist.Delete(0);
      For i := 0 To Fltlist.Count - 1 Do
        If MagPiece(Fltlist[i], '^', 2) = Fltname Then
        Begin
          Fltien := MagPiece(Fltlist[i], '^', 1);
          Break;
        End;
    End;
    If Fltien = '' Then
    Begin
      Rmsg := 'Resolving Filter name failed.';
      Rstat := False;
      Exit;
    End;

    Vlist.LoadFromFile(ExtractFilePath(Application.ExeName) + '\image\MagDemoFilter' + Fltien + '.txt');
    Filter := Vlist[1];
    Rstat := True;
    Rmsg := '';
  Finally
    Vlist.Free;
  End;
  Exit;
//demo
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
      REMOTEPROCEDURE := 'MAG4 FILTER DETAILS';
    End;
    Try
      FBroker.LstCALL(Vlist);
      If (MagPiece(Vlist[0], '^', 1) = '0') Or (Vlist.Count = 0) Then
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
          //maggmsgf.MagMsg('s', 'ERROR (EXCEPTION) in VistA function:' + e.Message);
        MagLogger.MagMsg('s', 'ERROR (EXCEPTION) in VistA function:' + e.Message); {JK 10/5/2009 - Maggmsgu refactoring}
      End;
    End;
  Finally
    Vlist.Free;
  End;
End;

Procedure TMagDBDemo.RPFilterSave(Var Rstat: Boolean; Var Rmsg: String; t: TStrings);
Var
  i: Integer;
Begin
  Rmsg := 'Saving Filters is disabled in Demo mode.';
  DemoMessage(Rmsg);
  Rstat := False;
  Exit;
//demo
  Rstat := False;
  With FBroker Do
  Begin
    PARAM[0].PTYPE := List;
    PARAM[0].Value := '.x';
    For i := 0 To t.Count - 1 Do
      PARAM[0].Mult['' + Inttostr(i) + ''] := t[i];
    REMOTEPROCEDURE := 'MAG4 FILTER SAVE';
  End;
  Try
    Rmsg := FBroker.STRCALL;
    If (MagPiece(Rmsg, '^', 1) = '0') Or (Rmsg = '') Then
    Begin
      Rstat := False;
      If (Rmsg = '') Then Rmsg := 'ERROR: Retrieving Filter Details Failed. Check VISTA Error Log.';
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
        //maggmsgf.MagMsg('s', 'ERROR (EXCEPTION) in VistA function:' + e.Message);
      MagLogger.MagMsg('s', 'ERROR (EXCEPTION) in VistA function:' + e.Message); {JK 10/5/2009 - Maggmsgu refactoring}
    End;
  End;
End;

Procedure TMagDBDemo.RPFilterDelete(Var Rstat: Boolean; Var Rmsg: String; Fltien: String);
Begin
  Rmsg := 'Deleting Filters is disabled in Demo mode.';
//showmessage(rmsg);
  Rstat := False;
  Exit;
//demo
//  if not CheckDBConnection(xmsg) then
  Rstat := False;
  With FBroker Do
  Begin
    PARAM[0].PTYPE := LITERAL;
    PARAM[0].Value := Fltien;
    REMOTEPROCEDURE := 'MAG4 FILTER DELETE';
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
        //maggmsgf.MagMsg('s', 'ERROR (EXCEPTION) in VistA function:' + e.Message);
      MagLogger.MagMsg('s', 'ERROR (EXCEPTION) in VistA function:' + e.Message); {JK 10/5/2009 - Maggmsgu refactoring}
    End;
  End;
End;

Function TMagDBDemo.IsConnected: Boolean;
Begin
  Result := FDemoConnected;
  Exit;
  If Assigned(FBroker) Then
    Result := FBroker.Connected
  Else
    Result := False;
End;

Procedure TMagDBDemo.SetConnected(Const Value: Boolean);
Begin
  FDemoConnected := Value;
  Exit;
//demo
  If Assigned(FBroker) Then FBroker.Connected := Value;
End;

Function TMagDBDemo.GetListenerPort: Integer;
Begin
  If Assigned(FBroker) Then
    Result := FBroker.ListenerPort
  Else
    Result := 0;
End;

Function TMagDBDemo.GetServer: String;
Begin
  Result := 'Demo Images';
  Exit;
//demo
  If Assigned(FBroker) Then
    Result := FBroker.Server
  Else
    Result := '';
End;

Procedure TMagDBDemo.SetListenerPort(Const Value: Integer);
Begin
  If Assigned(FBroker) Then FBroker.ListenerPort := Value;
End;

Procedure TMagDBDemo.SetServer(Const Value: String);
Begin
  If Assigned(FBroker) Then FBroker.Server := Value;
End;

Constructor TMagDBDemo.Create;
Begin
  FPatientList := Tstringlist.Create;
  FDuz := '999';
End;

Procedure TMagDBDemo.RPTIUCreateNote(Var Fstat: Boolean; Var Fmsg: String;
  DFN, Title, AdminClose, Mode, Esighash, Esigduz, Loc, Notedate, ConsltDA: String; Notetext: Tstringlist = Nil);
Begin
//
End;

Procedure TMagDBDemo.RPTIUCreateAddendum(Var Fstat: Boolean; Var Fmsg: String;
  DFN, TiuDA, AdminClose, Mode, Esighash, Esigduz, Notedate: String; Notetext: Tstringlist = Nil);
Begin

//
End;

Function TMagDBDemo.RPTIUSignRecord(Var Fmsg: String; DFN, TiuDA, Hashesign: String): Boolean;
Begin
 //
End;

Procedure TMagDBDemo.RPMag4FieldValueGet(Var Fstat: Boolean;
  Var Fmsg: String; Var Flist: Tstringlist; Ien: String; Flags: String = ''; Flds: String = '');
Begin
  Fstat := False;
  Fmsg := 'Not implemented in Demo';
//
End;

Procedure TMagDBDemo.RPMag4FieldValueSet(Var Fstat: Boolean; Var Fmsg: String; Var Flist: Tstringlist; t: Tstringlist);
Begin
  Fstat := False;
  Fmsg := 'Not implemented in Demo';
  Flist.Add('not implemented in demo');
//
End;

Procedure TMagDBDemo.RPTIUisThisaConsult(Var Fstat: Boolean;
  Var Fmsg: String; Titleda: String);
Begin
//  inherited;

End;

Procedure TMagDBDemo.RPMagVersionStatus(Var Status: String;
  Version: String);
Begin
  Inherited;
//
End;
{/ JK 11/24/2009 - P108 New method to determine if a DFN has an associated patient photo on file.
   If a patient photo for the DFN is not found then return "0" for false. Otherwise
   the RPC will return a Fileman date/time for the most recent photo on file.
/}
function TMagDBDemo.RPPatientHasPhoto(DFN: String; var Stat: Boolean; var FMsg: String): String;
var
  ResStr: String;
begin
  Result := '0';
  Stat := False;
  FMsg := '';

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
    Stat := True;
  except
    on E:Exception do
    begin
      Result := '0';
      Stat   := False;
      FMsg   := E.Message;
    end;
  end;
end;

Function TMagDBDemo.RPMaggIsDocClass(Ien, Fmfile, ClassName: String; Var Stat: Boolean; Var Fmsg: String): Boolean;
Begin
//
  Result := True;
End;

Procedure TMagDBDemo.DemoMessage(s: String);
Begin
  //Showmessage(s);
  //p106 rlm 20101229 CR640 "Title of Dialog box"
  MagLogger.MagMsg(
    'd',
    s,
    Nil);
End;

Procedure TMagDBDemo.RPMaggImageGetProperties(Var Rstat: Boolean;
  Var Rmsg: String; Var Rlist: TStrings; Ien, Params: String);
Begin
//  inherited;
//
End;

Procedure TMagDBDemo.RPMaggImageSetProperties(Var Rstat: Boolean; Var Rmsg: String; Var Rlist: TStrings; Fieldlist: TStrings; Ien, Params: String);
Begin
//
End;

Procedure TMagDBDemo.RPMaggReasonList(Var Rstat: Boolean; Var Rmsg: String;
  Var Rlist: TStrings; Data: String);
Begin
//  inherited;
//
End;

Procedure TMagDBDemo.RPMag4ImageList(Var Fstat: Boolean; Var Rpcmsg: String; DFN: String; Var Flist: TStrings; Filter: TImageFilter = Nil);
Begin
//  inherited;
End;

Function TMagDBDemo.RPXWBGetVariableValue(Value: String): String;
Begin
//
  Result := '';
End;

Procedure TMagDBDemo.RPMagImageStatisticsUsers(Var Fstat: Boolean;
  Var Fmsg: String; Var Flist: Tstringlist; Inputparams: Tstringlist);
Begin
  Inherited;
// nothing needed yet.
End;

procedure TMagDBDemo.RPMagJukeBoxPath(var Fstat: Boolean; var Fmsg: String; ImageIEN: String);
begin
  inherited;
//
end;

{/ JK 8/5/2010 - P117 - Added in procedure to call MAGG IMAGE STATISTICS QUE /}
procedure TMagDBDemo.RPMagImageStatisticsQue(
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

    //LogRPCParams;

    FBroker.LstCALL(RList);
    ResStr := MagPiece(RList[0], '^', 1);
    FStat := (ResStr <> '0');
    FMsg := MagPiece(RList[0], '^', 2);

    //LogRPCResult(RList);

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

    for i := 2 To RList.Count - 1 Do
    begin

      FList.Add(RList[i]);
    end; {for}

  except
    on E:Exception do
    begin
      //Self.LogRPCException(E.Message); //gek 93t12 debug
      FMsg := E.Message;
      FStat := False;
    end;
  end;
  RList.Free;

end;

Procedure TMagDBDemo.RPMagImageStatisticsByUser(var Fstat: Boolean; var Fmsg: String; var Flist: TStringList; UserDUZ: String); {/ JK 8/5/2010 - P117 /}
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

    //LogRPCParams;

    FBroker.LstCALL(RList);
    ResStr := MagPiece(RList[0], '^', 1);
    FStat := (ResStr <> '0');
    FMsg := MagPiece(RList[0], '^', 2);
    //LogRPCResult(RList);

    for i := 0 To RList.Count - 1 Do
    begin
      Flist.Add(RList[i]);
    end; {for}

  except
    on E:Exception do
    begin
      //Self.LogRPCException(E.Message); //gek 93t12 debug
      FMsg := E.Message;
      FStat := False;
    end;
  end;
  RList.Free;

end;

Procedure TMagDBDemo.RPMaggCaptureUsers(Var Fstat: Boolean; Var Fmsg: String; Var Flist: Tstringlist; Inputparams: Tstringlist);
Begin
  Inherited;
// nothing needed yet.
End;

Destructor TMagDBDemo.Destroy;
Begin
  FreeAndNil(FPatientList);//RLM Fixing MemoryLeak 6/18/2010
  Inherited;
End;


{//117}
procedure TMagDBDemo.RPMagPatInfoQuiet(var Fstat: boolean;  var Fstring: string; MagDFN: string; isicn: boolean);
begin
  inherited;
exit;
end;

Function TMagDBDemo.RPMag3TRThinClientAllowed: Boolean;
Var
  s: String;
Begin
  Result := False;            
  FBroker.REMOTEPROCEDURE := 'MAG3 TR THIN CLIENT ALLOWED';
  s := FBroker.STRCALL;
  If Copy(s, 1, 1) = '0' Then Exit; //error occurred during call
  If Copy(s, 3, 1) = '1' Then Result := True;
End;

procedure  TMagDBDemo.RPMaggMultiImagePrint(DFN, Reason: String; Images: TStringList);
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


End.
