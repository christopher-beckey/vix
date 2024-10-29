unit cMagImport;

{
   Package: MAG - VistA Imaging
 WARNING: Per VHA Directive 10-93-142 this unit should not be modified.
 Date Created:
 Site Name: Silver spring, OIFO
 Developers: Garrett Kirin
        [==
 Description: Imaging Import API Delphi component

        ==]
 Note:
   p135 p158 overall we are saving more details during each function or procedure.  these details are
        stored in FLogList and returned to the calling app in the  var parameter that defined the
        result list .
        For example :
            procedure ImportQueue(var resStatus: boolean; Qnum: String; var reslist: Tstrings;
                          var StatusCB: String; NoCallBackOnError: boolean = FALSE);
        the parameter : var reslist,   is the mechanism to return an array of details back
        to the calling app.
        
  DebugMode is in Patch 158 
   the Function 
       lgdm(    is used to send extra message as debug messages..
  also


      FDebugON : boolean;
      FDebugToFileON : boolean;
      FDebugToFileName : string;
  

   are used for DebugMode.

   
   THIS Version of Cmagimport is from 158...  it isn't used in Display
   but we're moving it here, to stay in Sync

  }

interface

uses
inifiles, // 121 debug
registry,
fmxutils,
Windows,
SysUtils,
Classes,
//va
Trpcb,
//imaging
cMagSecurity,
cMagUtils,
cMagDBBroker,
StdCtrls  ,
extctrls  ,
forms
, MaggMsgu
//121
, cmagigmanager
  ,  GearCORELib_TLB,
  GearDIALOGSLib_TLB,
  GearDISPLAYLib_TLB,
  GearEFFECTSLib_TLB,
  GearFORMATSLib_TLB,
  GearMEDLib_TLB,
  GearPDFLib_TLB,
  GearPROCESSINGLib_TLB,
  IGGUIDlgLib_TLB,
  IGGUIWinLib_TLB,
  VECTLib_TLB,
  OleCtrls,
  GearVIEWLib_TLB
// 135
, umagutils8   
;

//Uses Vetted 20090929:FileCtrl, Controls, Graphics, Messages, uMagClasses, umagdefinitions, cmagdbmvista, hash, Dialogs, Forms

type
  EInvalidData = class(Exception)
    ErrorCode: integer;
  end;

  TMytest4Event = procedure(I: integer; s: String) of object;

  TMagImport = class(TCustomListbox)
  private
     {p135 p158 gek debugging controls.}
    
{: 
      FDebugMode is True/False to turn debugging on or off.
      If FDebugMode = True
        then debug messages will be logged to IMAGING WINDOWS SESSION FILE.
      If FDebugTOFileON,  debug messages will be saved to a DOS File, 
      DOS file name is set by Application, and Displayed in the FDebugToFileName.

         }
    	FDebugON : boolean;
    	FDebugToFileON : boolean;
    	FDebugToFileName : string;
    	Findent : string;
     
     {: 
      FGmsg is a Glolbal list that can be populated by any function/procedure.
                          This way, we can conditionally add to list without changing parameter list in all functions and procedure to
                           pass and return a variable Tlist}
     //	FGmsg :  tstrings;
    	FRegIniFile : TRegIniFile; 


    FUnStrings: Tstrings;

    FLogStrs: Tstrings;
    FMyTest4Event: TMytest4Event;
    FImageAdd: string;
    {each image (listItem in FImages) can have 2nd '^' piece as Short Description.}
    FImages: Tstrings;
    FDFN: string;

    {/ JK 11/30/2009 - P108 /}
    FProcNew : String;
    FProcTIUTitle : String;
    FProcTIUText: TStrings;
    FProcTIUSignatureType: String;
    //-FProcTIUSignature: String;

    FProcPKG: string;
    FProcIEN: string;
    FProcDt: string;
    {   tracking number is a ';' delimited string.  2 pieces
        1 = the package ID    i.e. 8924 (tiu)  'DSS' (DSS)
        2 = some unique number in relation to the package. }
    FTrkNum: string;
    FAcqDev: string;
    FAcqSite: string;
    FAcqLoc: string;
    FExcpHandler: string;
    {  Above are required by the 'M' Import API Call.{}
    FImgType: string;
    FMethod: string;
    FCapBy: string;
    FUsername: string;
    FPassword: string;
    FGroupDesc: string;
    FDeleteFlag: boolean;
    FTransType: string;
    FDOCCTG: string;
    FixType: string;
    FixSpec: string;
    FixProc: string;
    FixOrigin: string;
    FDocDT: string;
    {   rest of fields are not Implemented in 'M' ImportAPI Call. {}
    FProcType: string;
    FProcDesc: string;
    FCapDt: string;
    FGroupIEN: string;
    FGroupLongDesc: Tstrings;
    {   other processing fields {}
    Flist: Tstringlist;
    rlist: Tstrings;
    Fstat: boolean;
    FBroker: TRPCBroker;
    FDBBroker: TMagDBBroker;
    FMagSecurity: TMag4Security;
    FMagSecurityNOTCreated : Tmag4Security;
    FCaptureKeys: Tstringlist;
    { --- FLogList is a record of events during the Import Process.  This may be warnings, etc. that are
          listed in the 3..n nodes.  After the 0,1,2 nodes, because the 0, 1, 2 nodes have specific info.}
    FLogList: Tstringlist;
    FMagUtils: TMagUtils;
    //121
    FImportActionValue : string;
    FImportIsRescind : boolean;
    FIoLocation : IIGIOLocation;
    FWaterMarkBitmap : string;
    FDirTemp : string;
    FDirCache : string;
    FDirImport : string;
    FDirImage : string;
    {/p135  Timer for BP's way to sync Timeout with VistA}
    { TODO : Re Evaluate Stay Alive Timer
       is it needed, now that OnPulseError is handled
       if IAPI isn't connected... then }
    FTimerStayAlive : TTimer;

    FSAvserver,
    FSAvport,
    FSAaccesscode,
    FSAverifycode,
    FSAdivision : string;
    FSALastLogon  : boolean;
    //
    function GetTrkNum : String;
    function GetImages : Tstrings;
    function GetAcqSite : String;
    function GetAcqLoc : String;
    function GetCapBy : String;
    function GetCapDt : String;
    function GetDFN : String;
    function GetImgType : String;
    function GetMethod : String;
    function GetProcDesc : String;
    function GetProcDt : String;
    function GetProcPKG : String;
    function GetProcIEN : String;
    function GetProcType : String;
    function GetAcqDev : String;
    function GetGroupIEN : String;
    function GetGroupDesc : String;
    function GetGroupLongDesc : Tstrings;
    function GetExcpHandler : String;
    function GetPassword : String;
    function GetUsername : String;
    function GetDeleteFlag : boolean;
    function GetTransType : String;
    function GetDOCCTG : String;
    function GetDocDt : String;
    function GetIndexProc : String;
    function GetIndexSpec : String;
    function GetIndexType : String;
    function GetIndexOrigin : String;
    procedure SetTrkNum(const Value: String);
    procedure SetImages(const Value: Tstrings);
    procedure SetAcqSite(const Value: String);
    procedure SetAcqLoc(const Value: String);
    procedure SetCapBy(const Value: String);
    procedure SetCapDt(const Value: String);
    procedure SetDFN(const Value: String);
    procedure SetImgType(const Value: String);
    procedure SetMethod(const Value: String);
    procedure SetProcDesc(const Value: String);
    procedure SetProcDt(const Value: String);

    {/ JK 11/30/2009 - P108 /}
//    function GetProcTIUSignature : String;
    function GetProcTIUSignatureType : String;
    function GetProcNew : String;
    function GetProcTIUTitle : String;
    function GetProcTIUText : TStrings;

    procedure SetProcPKG(const Value: String);
    procedure SetProcIEN(const Value: String);
    procedure SetProcType(const Value: String);
    procedure SetAcqDev(const Value: String);
    procedure SetGroupIEN(const Value: String);

    {/ JK 11/30/2009 - P108 /}
//    procedure SetProcTIUSignature(const Value: String);
    procedure SetProcTIUSignatureType(const Value: String);
    procedure SetProcNew(const Value: String);
    procedure SetProcTIUTitle(const Value: String);
    procedure SetProcTIUText(const Value: TStrings);
    procedure SetInsertProcTIUText(const Value: String);

    procedure SetGroupDesc(const Value: String);
    procedure SetGroupLongDesc(const Value: Tstrings);
    procedure SetExcpHandler(const Value: String);
    procedure SetPassword(const Value: String);
    procedure SetUsername(const Value: String);
    procedure SetDeleteFlag(const Value: boolean);
    procedure SetTransType(const Value: String);
    procedure SetDOCCTG(const Value: String);
    procedure SetDocDt(const Value: String);
    procedure SetIndexProc(const Value: String);
    procedure SetIndexSpec(const Value: String);
    procedure SetIndexType(const Value: String);
    procedure SetIndexOrigin(const Value: String);
    function GetBroker : TRPCBroker;
    function GetMag4Security : TMag4Security;
    function GetDBBroker : TMagDBBroker;
    procedure SetBroker(const Value: TRPCBroker);
    procedure SetMag4Security(const Value: TMag4Security);
    procedure SetDBBroker(const Value: TMagDBBroker);
    function Validate(var vrmsg0: String) : boolean;
    function CreateGroup(var ienresult0: String) : boolean;
    function CreateImageEntry(var xmsg: String; var imageID: String; imagefile: String) : boolean;
    function CopyImageToServer(var xmsg: String; imageID, imagefile: String) :  boolean;
    function ValidInteger(s: String) : boolean;
    function SAVEtoVistA(var vmsg0: String) : boolean;
    function ImageArrayToFields(var xmsg: String; imgarray: Tstringlist) : boolean;
    function CopyTheFile(var xmsg: String; FromFile, ToFile: String; MakeTXT : boolean = true) : boolean;
    procedure FileSpecialtyPointers(imageID: String);
    procedure CreateTheQueues(imageID: String);
    function DelimitedParam(s: String) : boolean;
    function SetNetUsernamePassword(user, pass: String; var MagSec: TMag4Security;
                                    var xmsg: String) : boolean;
    procedure DeleteImageEntry(var xmsg: String; ien: String; NoImage : string = '');  // 135t7 NoImage Fix.
    procedure CreateNewlog;
    procedure lgm(s: String); //LogTheMsg
    procedure lgl(t: Tstringlist);  overload; //LogTheList
    procedure lgl(t: Tstrings);    overload;  //LogTheList
    function ImageTypeAllowAbs(fileext: String) : boolean;
    function CreateAndSaveImageTextFile(imageToFile: String; var xmsg: String) : boolean;
    procedure InitIfNeeded;
    procedure ConnectIfNeeded(var vserver: String; var vport: String; accesscode:
                                             String = ''; verifycode: String = '';division : string = '');
    procedure ImageArrayFromFields(var t: Tstringlist);
    procedure lgdm(s: String);  overload;  //LogDebugMsg
    procedure lgdm(t: Tstrings) ;overload; //; pf : string = ''); overload;
    function BoolToStr(val: boolean): string;

    {/p121 methods }
   Function  CreateAccusoftControls(var rmsg: string): boolean; //135t6 made a Function to return Status
       procedure PreProcessRESCINDArray(var rstat : boolean; var rmsg : string; var rescindimage : string; var Flist: TStringlist);
         function  WaterMarkTheImage(var rvmsgs : string; filetomark : String; var NewFilename : string): boolean;
           procedure LoadImage1(filename: string);
           procedure LoadImage2WMK;
               function  GetWaterMarkBitmap(): string;
           function  GetWaterMarkFileName(filename: string; fileext : string=''): string;
    function SetIAPIDirectories(var Rmsg: String): Boolean;
    procedure WaterMarkConvertToGray;
    procedure WaterMarkResizeRescind;
    function GetArrayValue(value : String; imgarray: Tstringlist) : string;
    function GetNetSecurityOn: boolean;
    procedure SetNetSecurityOn(const Value: boolean);

  {121 end.}
   {/p135}
    function MagGetSystemTimeout(data : string): string;
    procedure StayAliveTimer(Sender: TObject);
    {p135t6 the function DBConnect from TmagDBBroker (TmagDBMVista), doesn't return a detailed
            string of 'why' the connection failed.  DBConnect2 is a copy of that function
            with extra parameter to pass that detailed error description back to the Import API.      }
// -> from cMagDBMVista ->   function DBConnect( Vserver, Vport, Context, AccessCode, Verifycode, division: string): Boolean;
    function DBConnect2(var xmsg: string; Vserver, Vport: String; Context: String = 'MAG WINDOWS';
                                 AccessCode: String = ''; Verifycode: String = '';division : string = ''): Boolean;
    procedure IndentDec;  {For DebugMode}
    procedure IndentInc;  {For DebugMode}
(*  switched to use Registry
    function XXGetConfigFileNameIAPI(xDirectory : string = ''): string;    {For DebugMode}
    procedure XXCheckDebugFromINI;      {For DebugMode}
    procedure XXCreateDefaultINI(inifilename : string);    {For DebugMode}
*)
    function GetRegistryFileNameIAPI(): string;
    procedure CheckDebugFromRegistry;
    function DefaultDebugFileName(logDir : string) : string;


    procedure LogFileInit(fn: string);    {For DebugMode}
    function GetFormatDesc(value: integer): string;

    {Used for Display of Access Verify,  Username Password.
       It displays * in place of First 4 characters of the value.  ..  }
    function halfDisplay(value: string): string;
    procedure RegistryUpdateStr(sec,ident,value : string);
    procedure RegistryUpdateBool(sec,ident : string; value : boolean);



  protected
    property height default 30;
    property width default 30;
  public
     FOnPulseErrorText : string;
    {/p121  start }
    vIGPage1, vIGPage2 : IGPage;
    vIGPageDisplay1, vIGPageDisplay2 : IGPageDisplay;

    // not needed in Import.  No Display GUI.   vIGPageViewCtl1, vIGPageViewCtl2, vIGPageViewCtl3 : TIGPageViewCtl;
    //vIoLocation: IIGIOLocation;
    vIGLoadOptions: IGLoadOptions;
    //vMedContrast: IGMedContrast;
    //vMedDataDict: IGMedDataDict;
    vIGSaveOptions: IGSaveOptions;
    {/121 end}
    constructor Create(AOwner: TComponent); override;
    destructor Destroy; override;
    procedure ClearProperties;
    procedure showproperties;
    function StayAlive(value : boolean): string;

    procedure SaveDirect(var status: boolean; var xmsglist: Tstrings);
    procedure VistAInit(var rstat: boolean; var xmsg: String; var vserver: String;
                        var vport: String; accesscode: String =''
                        ; verifycode: String = ''
                        ; division: String = '');
    function ImportDataArray(var xmsglist: Tstringlist; InArray: Tstringlist) :
             boolean;
    procedure ImportQueue(var resStatus: boolean; Qnum: String; var reslist: Tstrings;
                          var StatusCB: String; NoCallBackOnError: boolean = FALSE);
    procedure ImageAdd(imagefile: String);

    {/ JK 11/24/2009 - P108 Add in new procedure IndexTypeList /}
    procedure IndexTypeList(var slType: TStringList;
                            ClassChoice: String = '';
                            IgnoreStatus: Boolean = False;
                            incClass: Boolean = False;
                            incStatus: Boolean = False);

    {/ JK 11/24/2009 - P108 Add in new procedure IndexSpecSubSpecList /}
    procedure IndexSpecSubSpecList(var slSubSpec: TStringList;
                                   ClassChoice: String = '';
                                   ProcsChoice: String = '';
                                   ignoreStatus: Boolean = False;
                                   incClass: Boolean = False;
                                   incStatus: Boolean = False;
                                   incSpec: Boolean = False);

    {/ JK 11/24/2009 - P108 Add in new procedure IndexEventList /}
    procedure IndexEventList(var slEvent: TStringList;
                             ClassChoice: String = '';
                             SpecChoice: String = '';
                             ignoreStatus: Boolean = False;
                             incClass : Boolean = False;
                             incStatus : Boolean = False);

    {/ JK 11/24/2009 - P108 Add in new procedure IndexOriginList /}
    procedure IndexOriginList(var slOrigin: TStringList);

    {/ JK 11/24/2009 - P108 Add in new procedure RPPatientHasPhoto /}
    function RPPatientHasPhoto(DFN: String;
                               var Stat: Boolean;
                               var FMsg: String): String;

   {... is there a reason this is Public, not Private ? }
  procedure IAPIOnPulseError(peBroker : TRPCBroker ; peErr : string);


  published
    property OnMyTest4Event : TMytest4Event read FMyTest4Event write  FMyTest4Event;
    property TrkNum : String read GetTrkNum write SetTrkNum;
    property Images : TStrings read GetImages write SetImages;
    property DFN : String read GetDFN write SetDFN;
    property CapBy : String read GetCapBy write SetCapBy;
    property AcqDev : String read GetAcqDev write SetAcqDev;
    property ExcpHandler : String read GetExcpHandler write SetExcpHandler;
    property ProcPKG : String read GetProcPKG write SetProcPKG;
    property ProcIEN : String read GetProcIEN write SetProcIEN;

    {/ JK 11/30/2009 - P108 /}
    property ProcNew: String read GetProcNew write SetProcNew;
    property ProcTIUTitle: String read GetProcTIUTitle write SetProcTIUTitle;
//    property ProcTIUSignature: String read GetProcTIUSignature write SetProcTIUSignature;
    property ProcTIUSignatureType: String read GetProcTIUSignatureType write SetProcTIUSignatureType;
    property ProcTIUText: TStrings read GetProcTIUText write SetProcTIUText;

    property ProcType : String read GetProcType write SetProcType;
    property Username : String read GetUsername write SetUsername;
    property Password : String read GetPassword write SetPassword;
    property ProcDt : String read GetProcDt write SetProcDt;
    property ProcDesc : String read GetProcDesc write SetProcDesc;
    property CapDt : String read GetCapDt write SetCapDt;
    property ImgType : String read GetImgType write SetImgType;
    property AcqSite : String read GetAcqSite write SetAcqSite;
    property Method : String read GetMethod write SetMethod;
    property GroupIEN : String read GetGroupIEN write SetGroupIEN;
    property GroupDesc : String read GetGroupDesc write SetGroupDesc;
    property GroupLongDesc : Tstrings read GetGroupLongDesc write SetGroupLongDesc;
    property DeleteFlag : boolean read GetDeleteFlag write SetDeleteFlag;
    property TransType : String read GetTransType write SetTransType;
    property AcqLocation : String read GetAcqLoc write SetAcqLoc;
    property DocCategory : String read GetDOCCTG write SetDOCCTG;
    property DocDate : String read GetDocDt write SetDocDt;
    property IndexType : String read GetIndexType write SetIndexType;
    property IndexSpec : String read GetIndexSpec write SetIndexSpec;
    property IndexProc : String read GetIndexProc write SetIndexProc;
    property IndexOrigin : String read GetIndexOrigin write SetIndexOrigin;
    property MagBroker : TRPCBroker read GetBroker write SetBroker;
    property MagSecurity : TMag4Security read GetMag4Security write SetMag4Security;
    property MagDBBroker : TMagDBBroker read GetDBBroker write SetDBBroker;
    {/p121 gek , surface a method to Turn security ON or OFF.  This is used by BP.}
    property NetSecurityOn : boolean read GetNetSecurityOn write SetNetSecurityOn;
  end;

procedure Register;

implementation

uses
  cMagDBMVista,
  Dialogs,

  hash,
  uMagClasses,
  umagdefinitions
  ;

procedure Register;
begin
  RegisterComponents('Imaging', [TMagImport])
end;


{ TMagImport }



constructor TMagImport.Create(AOwner: TComponent);
var vApppath : string;
begin
  inherited Create(AOwner);

  Flist := Tstringlist.Create;
  rlist := Tstringlist.Create;
  FImages := Tstringlist.Create;
  FGroupLongDesc := Tstringlist.Create;
  FMagUtils := TMagUtils.Create(Self);
  FCaptureKeys := Tstringlist.Create;
  FLogList := Tstringlist.Create;
  height := 30;
  width := 30;
  FLogStrs := Tstringlist.Create;
 // 'Global' variable to handle passing messages back from multiple levels
 //  of function procedure calls, without changing all parameter lists to pass a variable string parameter.
 // FGmsg := Tstringlist.create; {future.  Not used now}
  FDebugON := false;
  Findent := '';
  //CheckDebugFromINI;
  CheckDebugFromRegistry;
  {$ifdef magdebug}
  FDebugON := true;
  {$endif}
  ///////////////frmMagBMP.Image1.Picture.SaveToFile('c:\temp\myrescind.bmp');

  {/ JK 12/1/2009 - P108 /}
  FProcTIUText := TStringList.Create;
  {/p121 gek 3/18/11 }
  MagIGManager := TMagIGManager.Create();
  { TODO -cRefactor :
    carry rescinded bmp as a resource.  not a bitmap file.
    create file from resource, use that for Accusoft Watermark function. }
   {p135  for now,  we will put it in the BP directory.  i.e. Application directory}
  //FWaterMarkBitmap := 'c:\program files\vista\imaging\bmp\MagRescinded.bmp';
  vApppath := extractfilepath(application.ExeName);
  lgdm('Application path: ' + vApppath);
  FWaterMarkBitmap :=  vApppath + 'MagRescinded.bmp';
  if not FileExists(FWaterMarkBitmap) then
     begin
      lgdm('WaterMark Bitmap file: ' + FWaterMarkBitmap + ' does not exist. Watermark Process will Fail.');
     end;

    FDirTemp := '' ;
    FDirCache := '' ;
    FDirImport := '' ;
    FDirImage := '' ;
  FTimerStayAlive := TTimer.Create(self);
  FTimerStayAlive.Enabled := false;
  FTimerStayAlive.OnTimer := StayAliveTimer;
end;


destructor TMagImport.Destroy;
begin
  Application.processmessages;
  Flist.Free;
  rlist.Free;
  FImages.Free;
  FGroupLongDesc.Free;
  FMagUtils.Free;
  FCaptureKeys.Free;
  FLogList.Free;

  {/ JK 12/1/2009 - P108 /}
  FProcTIUText.Free;
  //FGmsg.free;

  inherited Destroy
end;





function TMagImport.ValidInteger(s: String) : boolean;
begin
  Result := true;
  try
    strtoint(s)
  except
    on E : Exception do
      Result := FALSE;
  end;
end;


function TMagImport.DelimitedParam(s: String) : boolean;
begin
  Result := true;
  if (FMagUtils.maglength(s, ';')<>2) then
  begin
    Result := FALSE
  end;
end;

{  ***   Function SAVE. }
   { vmsg0 : result message in '0^...'   '1^... ' format.}
function TMagImport.SAVEtoVistA(var vmsg0: String) : boolean;
var
  I: integer;
  ImageCopyErrors,
  ImageCopyOK: Tstrings;
  rmsgs,
  dmsg,
  imageID,
  imagefile: string;
  allornone: boolean;
  xien,
  xfile,
  x: string;
  IObj : TImageData;
  oserror : integer;
  osmsg : string;
  magfilesize : longint;
  imagename : string;
begin
  // FUnstrings.add(inttostr(FUnstrings.count));
  indentinc;
  lgdm('4- << ENTER : function SAVE>>');
  try
  rlist.clear;
  Flist.clear;
  allornone := true;
  Result := FALSE;
  {We try to close all connections.  But if not we continue anyway.}
  FMagSecurity.MagCloseSecurity(rmsgs);
  rmsgs := '';
  ImageCopyErrors := Tstringlist.Create;
  ImageCopyOK := Tstringlist.Create;
  try
  try
    {vmsg0 is of format '0^...'  '1^...)'}
    if not Validate(vmsg0) then   // etrap ok.
    begin
      lgdm('4- Failed Validate');
      lgm('Validate Failed: ' + vmsg0);
      Result := FALSE;
      exit
    end;
    {--------------------------------}
    if FImages.Count=0 then
    begin
      vmsg0 := '0^Error: The list of Images to be imported is Empty.';
      Result := FALSE;
      exit
    end;
    //fUnStrings.Add(Inttostr(Funstrings.count)); // force error
    {--------------------------------}
    if ((FImages.Count>1) and (FGroupIEN='')) then
    begin
      {CreateGroup procedure, sets the FGroupIEN}
      if CreateGroup(vmsg0) then        //etrap ok
      begin
        {error in FileSpecialtyPointers doesn't stop the process
               but the error is logged in LogTheMsg, which is returned to
               the calling App {}
        lgdm('4- Group Creating Image Group  OK');
        lgdm('4- Filing Package Pointers.');
        {No Result for FileSpecialtyPointers.   any errors, exceptions are put
             in the FlogList, if Fails, we want to continue.}
        {p143>>   11/28/13 P143 Group Pointer issue  vmsg0 in,  rmsgs out }
        FileSpecialtyPointers(vmsg0);          //etrap ok.
        lgdm('4- --- ' + vmsg0);
      end
      else
      begin
        lgdm('4- Error Creating Group.  Exiting Save.');
        {p143>>   11/28/13 P143 Group Pointer issue  vmsg0 in,  rmsgs out }
        lgm('Error Creating Group : ' + vmsg0);
        Result := FALSE;
        exit //Can't Create the Group entry, so Stop here EXIT
      end;
    end;
    {--------------------------------}
    {  Here , we don't care if multiple images exist.
      IF FGroupIEN exists, we add each image to the Group.
      ELSE Each Image points to the Specialty(Procedure).{}
    //    if (FImages.Count > 0) then
    //    begin
    lgdm('4- Starting Save  Images.');
    for I := 0 to FImages.Count - 1 do
    begin
      // we stop if one image fails, we wait untill
      // we have tried them all.  Unless AllorNone is True


      if not CreateImageEntry(rmsgs, imageID, FImages[I]) then    // etrap ok
            begin
              lgm('Error creating VistA Image Entry:');
              //lgm('    '+FImages[i]+'|'+imsg);
              lgm('    ' + rmsgs);
              ImageCopyErrors.Add('|' + FImages[I] + '|' + rmsgs);
                    if allornone then
                    begin
                      lgdm('4- Breaking from Save Loop ');
                      vmsg0 := rmsgs;
                      Result := FALSE;
                      break
                    end
                    else
                    begin
                      continue
                    end;
            end;
         { - - - - - - - - - }
        if FGroupIEN='' then
        begin
          FileSpecialtyPointers(imageID)        //etrap ok
        end;
      //FUnstrings.add(inttostr(FUnstrings.count));
      imagefile := FMagUtils.magpiece(FImages[I], '^', 1);
      // we don't stop if one copy fails, we wait untill
      // we have tried them all. Unless AllorNone is True
         { - - - - }
   {copy return 0 format ? }
            if not CopyImageToServer(rmsgs, imageID, imagefile) then   //
            begin
              ImageCopyErrors.Add(imageID + '|' + FImages[I] + '|' + rmsgs);
              lgm('Error copying ' + imagefile + ' to Server : ' + imageID);
              lgm('   :' + rmsgs);
              // special return code, the Connection to the network failed.
              // so we stop processing.
              if ((FMagUtils.magpiece(rmsgs, '^', 1)='-1')
                   or
                  allornone) then
              begin
                vmsg0 := rmsgs;
                Result := FALSE;
                break
                //exit;
              end;
              continue
            end
            else    // success copying to server.
            begin
                 lgdm('4- Copy To Server OK '+imagefile);
            end;
         { - - - - }
      ImageCopyOK.Add(imageID + '|' + FImages[I] + '|' + 'OK')
    end; //for I := 0 to Fimages.count - 1 do

    { TODO : if FMethod then CallMethodHandler(GenImages) }

    { We delete bad image entries now, that way only if all images were bad,
    will the group be deleted.{}
    if (ImageCopyErrors.Count>0) then
    begin
      for I := 0 to ImageCopyErrors.Count - 1 do
      begin
        xien := FMagUtils.magpiece(FMagUtils.magpiece(ImageCopyErrors[I], '|', 1), '^', 1);
        DeleteImageEntry(dmsg, xien,'NoImage');
        lgm(dmsg)
      end;
      if (allornone and (ImageCopyOK.Count>0)) then
      begin
        for I := ImageCopyOK.Count - 1 downto 0 do
        begin
          x := FMagUtils.magpiece(ImageCopyOK[I], '|', 1);
          xien := FMagUtils.magpiece(x, '^', 1);
          xfile := FMagUtils.magpiece(x, '^', 2) + FMagUtils.magpiece(x,'^', 3);
          // These Deletes are for Successful copies that need to be deleted because of the AllOrNothing Group design.
          //   so we don't want 'NoImage' here.
          DeleteImageEntry(dmsg, xien);
          lgm(dmsg + '  Delete Queue set for: ' + xfile);
          // have to delete the Images from this list.  Because
          // the delete flag tests this list, for deleting images from import directory
          ImageCopyOK.Delete(I)
        end;
      end;
    end;
    //
    // HERE if things worked OK we have entries in ImageCopyOK list.
    //    ( we have things in ImageCopyOK list if some failed, and
    //      the allornothing flag wasn't set.
    //  So for all images in ImageCopyOK list,
    //           we should set the Queue's Here
    if (ImageCopyOK.Count>0) then
    begin
      for I := 0 to ImageCopyOK.Count - 1 do
      begin
        //CPMOD, ADMINMOD  12/6/2001
        //ImageCopyOK.add(imageID + '|' + FImages[i] + '|' + 'OK');
        {we LogTheMsg if CreateQueues fails. }
        CreateTheQueues(FMagUtils.magpiece(ImageCopyOK[I], '|', 1));
        // JMW 4/21/2005 p45
        IObj := TImageData.Create();
        IObj.ServerName := MagDBBroker.GetServer();
        IObj.ServerPort := MagDBBroker.GetListenerPort();
        MagDBBroker.RPMag3Logaction('CAP-IMPORT^' + FDFN + '^'
                   + FMagUtils.magpiece(ImageCopyOK[I], '^', 1) + '$$' + FTrkNum, IObj)
      end;
    end;
    if (ImageCopyOK.Count=0) then
    begin
      vmsg0 := '0^ERROR: 0 Images copied';
      Result := FALSE
    end
    else
    begin
      Result := true;
      vmsg0 := '1^' + IntToStr(ImageCopyOK.Count) + ' Image(s) Copied OK. ' +
              IntToStr(ImageCopyErrors.Count) + ' Errors.'
    end;
    // If this was a group, we have at least One image that was successful.
    {/P121  If this is a 'RESCIND' we force delete, because the files to delete are the New temporary  file
      that has the Watermark  i.e.   'WMK_ files.
      The Delete Queue will be set in the Status Callback, that will delete the old (rescinded) image from the Image Share}
    if (FDeleteFlag or FImportIsRescind) then
    begin
      // iterate through the ImageCopyOK array and delete all the
      //  2nd '|' pieces.
      for I := 0 to ImageCopyOK.Count - 1 do
      begin
        {$I-}
        DeleteFile(FMagUtils.magpiece(FMagUtils.magpiece(ImageCopyOK[I],  '|', 2),'^',1));
        {$I+}
        oserror := GetLastError; // check for errors
        osmsg := SysErrorMessage(oserror);
        if oserror <> 0 then 
        //if not deletefile(FMagUtils.magpiece(FMagUtils.magpiece(ImageCopyOK[I],  '|', 2),'^',1))
        begin
          lgm('0^Warning: Couldn''t Delete file: ');
          lgm('File: ' + FMagUtils.magpiece(FMagUtils.magpiece(ImageCopyOK[I],'|', 2), '^', 1));
          lgm('GetLastError : ' + inttostr(oserror) );
          lgm('System Message: ' + osmsg);
        end
        else
        begin
          lgm('1^Deleted the Imported File: ');
          lgm(FMagUtils.magpiece(FMagUtils.magpiece(ImageCopyOK[I], '|',2), '^', 1));
        end;
      end;
    end;

  except
  on E:exception do
        begin

          result := false;
          vmsg0 := '0^EXCEPTION: Function SAVE';
          lgm(vmsg0);
          lgm('msg: ' + e.message);
          end;
   end;
finally
ImageCopyErrors.Free;
ImageCopyOK.Free
end;
  finally
  lgdm('4- << EXIT : function SAVE>>');
  indentdec;
  end;
end;


procedure TMagImport.CreateTheQueues(imageID: String);
var
  CreatAbsIEN,
  JBCopyIEN,
  imagefile,
  ext: string;
  xStat: boolean;
  xList: Tstringlist;
begin
indentinc;
lgdm('<< ENTER : CreateTheQueues >>');
try
  xList := Tstringlist.Create;
  try
    CreatAbsIEN := '';
    JBCopyIEN := FMagUtils.magpiece(imageID, '^', 1);
    imagefile := FMagUtils.magpiece(imageID, '^', 3);
    ext := FMagUtils.magpiece(imagefile, '.', 2);
    {Set Queues :  ABSTRACT, CopyToJukeBox
    First '^' piece is  CreateAbstract Queue
     2nd '^' piece is CopyToJukeBox }
    if ImageTypeAllowAbs(ext) then           // HERE HERE  - ARE WE CREATING XML abstracts  ?
    begin
      CreatAbsIEN := JBCopyIEN
    end;
    {RPMagABSJB(var Fstat: boolean; var Flist: tstringlist; CreatAbsIEN, JBCopyIEN: string)}
    FDBBroker.RPMagABSJB(Fstat, Flist, CreatAbsIEN, JBCopyIEN);
    if not Fstat then
    begin
       lgdm('FAILED : CreateTheQueues');
       lgdm('CreateAbsIEN : ' +  CreatAbsIEN + '  JBCopyIEN: ' + JBCopyIEN);
       lgdm(Flist);
      lgl(Flist)
    end;
    FDBBroker.RPMag4PostProcessActions(xStat, xList, JBCopyIEN)
  finally
    xList.Free
  end;
except
  on e:exception do
    begin
      lgm('EXCEPTION : CreateTheQueues');
      lgm('msg : ' + e.message);
    end;
end;
lgdm('<< EXIT : CreateTheQueues >>');
indentdec;
end;


function TMagImport.ImageTypeAllowAbs(fileext: String) : boolean;
var
  E: string;
begin
  E := ',' + UPPERCASE(fileext) + ',';
  Result := NOT (pos(E, ',MPG,ASC,AVI,DOC,HTM,PDF,RTF,WAV,TXT,MPEG,MHT,MHTML,HTML,MP3,MP4,XML,')>0)
end;


{   Create a New Image Entry in the Image File, and Get IEN and FullPath  }
function TMagImport.CreateImageEntry(var xmsg: String; var imageID: String;
                                     imagefile: String) : boolean;
var
  t: Tstringlist;
  tmpext: string;
begin
try
  xmsg := '0^Error. Calling Remote Procedure.';
  t := Tstringlist.Create;
  try
    t.Add('5^' + FDFN);
    if (FGroupIEN='') then
    begin
      if (FProcPKG<>'') then
      begin
        t.Add('16^' + FProcPKG)
      end;
      if (FProcIEN<>'') then
      begin
        t.Add('17^' + FProcIEN)
      end;
    end
    else
    begin
      t.Add('14^' + FGroupIEN)
    end;
    if (FProcDt<>'') then
    begin
      t.Add('15^' + FProcDt)
    end;
    if (FDOCCTG<>'') then
    begin
      t.Add('100^' + FDOCCTG)
    end;
    if (FDocDT<>'') then
    begin
      t.Add('110^' + FDocDT)
    end;
    if (FixType<>'') then
    begin
      t.Add('42^' + FixType)
    end;
    if (FixSpec<>'') then
    begin
      t.Add('44^' + FixSpec)
    end;
    if (FixProc<>'') then
    begin
      t.Add('43^' + FixProc)
    end;
    if (FixOrigin<>'') then
    begin
      t.Add('45^' + FixOrigin)
    end;
    {tracking number is a ';' delimited  string.  2 pieces
        1 = the package ID    i.e. 8924 (tiu)  'DSS' (DSS)
        2 = some unique number in relation to the package. }
    { DONE : Do we want these with each image, or only the group?. A: YES }
    if (FTrkNum<>'') then
    begin
      t.Add('108^' + FTrkNum)
    end;
    if (FAcqDev<>'') then
    begin
      t.Add('ACQD^' + FAcqDev)
    end;
    if (FAcqSite<>'') then
    begin
      t.Add('ACQS^' + FAcqSite)
    end;
    if (FAcqLoc<>'') then
    begin
      t.Add('ACQL^' + FAcqLoc)
    end;
    //t.add...(FExcpHandler)
    { We don't care about the Status handler from this call
    The BP will send any error message to the calling package.
      It has the Exception handler }
    { The next fields are NOT Required}
    // The Image Type (OBJECT TYPE) can be internal number or free text
    if (FImgType<>'') then
    begin
      t.Add('3^' + FImgType)
    end;
    //ResolveImageType);
    if (FMethod<>'') then
    begin
      t.Add('109^' + FMethod)
    end; begin

      { TODO -ogarrett -cFields : Stuarts Component to Generate Images. }
      (*TImageMethodComponent.ResolveImages(FMethod,FImages);
        if (FImages.count = 0)
          then
            begin
              result := false;
              xmsg := 'Call to Generate Images returned ''0'' Images.');
              exit;
            end
         *)
    end;
    { example imagefile:= "c:\import\consent.tif^image description"
     P48 Fix to allow "." in image description
         Fix to allow "." in fullpath\filename
         Fix to allow extensions greater than 3 characters  i.e. ".HTML"}
    tmpext := UPPERCASE(copy(ExtractFileExt(FMagUtils.MagPiece(imagefile,'^',1)), 2, 99));
    if (tmpext='TXT') then
    begin
      tmpext := 'ASC'
    end;
    t.Add('EXT^' + tmpext);
    { CapturedBy is Not Implemented, we get from DUZ in VistA}
    if (FCapBy<>'') then
    begin
      t.Add('8^' + FCapBy)
    end;
    { FUsernamePassword not validated here}
    if (FGroupDesc<>'') then
    begin
      t.Add('10^' + FGroupDesc)
    end;
    { If image has own description, use that. {}
    if (FMagUtils.magpiece(imagefile, '^', 2)<>'') then
    begin
      t.Add('10^' + FMagUtils.magpiece(imagefile, '^', 2))
    end;
    { FDeleteFlag not used here.  It is queried later, after image has been copied.}
    { FTransType  not validated here, used in the 'Save' Call.    }
    { This is end of Fields that are sent as parameters }
    // FProcType
    if (FProcDesc<>'') then
    begin
      t.Add('6^' + FProcDesc)
    end;
    if (FCapDt<>'') then
    begin
      t.Add('7^' + FCapDt)
    end;
    { FGroupLongDesc not validated, it is sent as is ( if it exists)}
    FDBBroker.RPMag4AddImage(Fstat, Flist, t);
    //in procedure CreateImageEntry
    xmsg := Flist[0];
    Result := Fstat;
    if not Fstat then
    begin
      lgdm('RPMag4AddImage - Error:');
      lgdm(''+xmsg);
      exit
    end;
   imageID := xmsg;
   lgdm('Image IEN: '+ imageID);
  finally
    t.Free
  end;
except
  on e:exception do
     begin
       Result := false;
       xmsg := '0^EXCEPTION: CreateImageEntry.';
       lgm(xmsg);
       lgm('msg: ' + e.Message);
     end;

end;
end;

{The GroupIEN is the first '^' piece of vrmsgS}
function TMagImport.CreateGroup(var ienresult0: String) : boolean;
var
  t: Tstringlist;
begin
try
  { here we Create a New Group in the Image File  {}
  t := Tstringlist.Create;
  try
    { Add the fields that say, this is a group}
    t.Add('2005.04^0');
    // A group with no children
    t.Add('3^11');
    //  11 says this is group; OBJECT TYPE
    t.Add('5^' + FDFN);
    if (FProcPKG<>'') then
    begin
      t.Add('16^' + FProcPKG)
    end;
    if (FProcIEN<>'') then
    begin
      t.Add('17^' + FProcIEN)
    end;
    if (FProcDt<>'') then
    begin
      t.Add('15^' + FProcDt)
    end;
    if (FDOCCTG<>'') then
    begin
      t.Add('100^' + FDOCCTG)
    end;
    if (FDocDT<>'') then
    begin
      t.Add('110^' + FDocDT)
    end;
    if (FixType<>'') then
    begin
      t.Add('42^' + FixType)
    end;
    if (FixSpec<>'') then
    begin
      t.Add('44^' + FixSpec)
    end;
    if (FixProc<>'') then
    begin
      t.Add('43^' + FixProc)
    end;
    if (FixOrigin<>'') then
    begin
      t.Add('45^' + FixOrigin)
    end;
    { Tracking number is a ';' delimited string.  2 pieces
        1 = the package ID    i.e. 8924 (tiu)  'DSS' (DSS)
        2 = some unique number in relation to the package. }
    if (FTrkNum<>'') then
    begin
      t.Add('108^' + FTrkNum)
    end;
    if (FAcqDev<>'') then
    begin
      t.Add('ACQD^' + FAcqDev)
    end;
    if (FAcqSite<>'') then
    begin
      t.Add('ACQS^' + FAcqSite)
    end;
    if (FAcqLoc<>'') then
    begin
      t.Add('ACQL^' + FAcqLoc)
    end;
    //t.add...(FExcpHandler)
    { We don't care about the exception handler. From this call
    The BP will send any error message to the calling package.
      It has the Exception handler }
    { The next fields are NOT Required}
    // The Image Type is already set by default for groups to '3^11';
    //if (FImgType <> '') then  t.add('3^'+FImgType); //ResolveImageType);
    if (FMethod<>'') then
    begin
      t.Add('109^' + FMethod)
    end;
    begin

      { TODO -ogarrett -cFields : Stuarts Component to Generate Images. }
      (*TImageMethodComponent.ResolveImages(FMethod,FImages);
        if (FImages.count = 0)
          then
            begin
              result := false;
              xmsg := 'Call to Generate Images returned ''0'' Images.');
              exit;
            end
         *)
    end;

    if (FCapBy<>'') then
    begin
      t.Add('8^' + FCapBy)
    end;
    // FUsernamePassword not validated here
    if (FGroupDesc<>'') then
    begin
      t.Add('10^' + FGroupDesc)
    end;
    // FDeleteFlag not used here.  It is queried later, after image has been copied.
    // FTransType  not validated here, used in the 'Save' Call.
    { This is end of Fields that are sent as parameters }
    // FProcType
    // FProcDesc
    // if (FCapDt <> '') then t.add('7^' + FCapDt);
    // FGroupIEN
    // FGroupLongDesc not validated, it is sent as is ( if it exists)
    // TESTING  Test sending a write directory ... did it work ?
    //t.add('WRITE^4');
    FDBBroker.RPMag4AddImage(Fstat, Flist, t);
    //procedure CreateGroup
    ienresult0 := Flist[0];
    Result := Fstat;
    if not Fstat then
    begin
      lgl(flist);
      lgdm('Error Creating Group Image entry');
      exit ;
    end;

    FGroupIEN := FMagUtils.magpiece(ienresult0, '^', 1);
      lgdm('Group IEN: '+FGroupIEN);
  finally
    t.Free
  end;
  except
  on e:exception do
    begin
        result := false;
        ienresult0 := '0^EXCEPTION : Create Group Entry';
        lgm(ienresult0);
        lgm('msg: ' + e.Message);
    end;
end;
end;


(*
Procedure TMagImport.FormatData;
//var
//  SS: string;
//  FileEXT: string;
//  tempimagetype: shortint;
begin
// Here we take the data and make the ImageArray
//   in the format Field^Data  or ActionCode^Data

// this is copy of FileImage from Tele19nu.pas
//   we following it to make sure we have all data we need.
//  to make a new call to Save Image Data.

// If this is a group, File the Group entry, then Loop through the Images
//  and file each one.
//  If one Image is successfully saved to VistA and Image Network Server.
//  then call will be successful.  EVEN if other Images fail.
//  other Images will be saved locally, or to network and somehow flagged ,
//  as a failed copy.  A File (.inf) or something will be saved along side the
//  image file.  This file will have pertinant information.  i.e. the info that
//  was in this component when the attempt to save the image failed.

  tempimagetype := 0;
  msg('', 'Filing the Image data...');
  if not xBrokerx.Connected then
  begin
    imagefiled := false;
    msg('d', 'No VistA Connection. Cannot Save Image.');
    exit;
  end;
  screen.cursor := crHourGlass;
  Memo2.Clear;
  xBrokerx.Param[0].Value := '.X';
  xBrokerx.Param[0].PType := list;
  LoadStaticFields;
  LoadSpecialtyFields;
  ss := uppercase(extractfileext(filenmx));
  if (uppercase(extractfileext(filenmx)) = '.AVI') and (imagetype <> 21)
    then if messagedlg('Importing Motion Video  (*.AVI) File ' + ss,
      mtconfirmation, [mbok, mbcancel], 0) <> mrOK then
    begin
      imagefiled := false;
      exit;
    end
    else
    begin
      tempimagetype := imagetype;
      imagetype := 21;
    end;
  if MagConfig.PhotoID.checked then
  begin
    tempimagetype := imagetype;
    imagetype := 18;
  end;
  if MagConfig.imagegroup.checked then
  begin
    xBrokerx.Param[0].Mult['"GROUP"'] := '14^' + GrpPtr;
    if DoesFormExist('DicomNumbers')
      then
    begin
      xBrokerx.Param[0].Mult['"DICOMSN"'] := 'DICOMSN^' + DicomNumbers.eDSN.TEXT;
      xBrokerx.Param[0].Mult['"DICOMIN"'] := 'DICOMIN^' + DicomNumbers.eDIN.TEXT;
    end;
  end;
  xBrokerx.Param[0].Mult['"OBJTYPE"'] := '3^' + IntToStr(ImageType);
  Memo2.Lines.Add('OBJTYPE^' + '3^' + IntToStr(ImageType));
  if tempimagetype <> 0 then
  begin
    imagetype := tempimagetype;
  end;
  FileEXT := Copy(Format, 2, 3);
  if Scanmode = 'Import' then
  begin
    if ImportIni = 'COPY' then FileEXT := Copy(ExtractFileExt(FileNmx), 2, 3);
    if ImportIni = 'TGA' then FileEXT := 'TGA';
  end;
  xBrokerx.Param[0].Mult['"FileExt"'] := 'EXT^' + FileExt;
//  gek 2/18/97 { TEST PETE'S "WRITE^PACS"  }
{--  xBrokerx.Param[0].Mult['"PACSWRITE"']:='WRITE^PACS';   gek 2/18/97}
{-- the TEST worked OK, but DON'T uncomment these lines}
{ test the BIG File flag  }

// If importing w/copy all and big file exists, set fbig node in 2005 saf 12/8/98
  if (MagBatchAdv.CopyAll.Checked and FileExists(lbImport.caption + '\' + FMagUtils.magpiece(FileNmx, '.', 1) + '.big')) then
    SaveBig := True;

  if SaveBig then xBrokerx.Param[0].Mult['"bigfile"'] := 'BIG^1';
  Memo2.Lines.Add('FileExt^EXT^' + FileEXT);
{ABS created on ws}
  if (ABSCreated and ABSforImage) then xBrokerx.Param[0].Mult['"NETLOCABS"'] := 'ABS^STUFFONLY';
   {GEK 4/16/97 STOP ABS ON 1 BIT TIF.}

  if (AbsCreated and MagBatchAdv.CopyAll.Checked) then xBrokerx.Param[0].Mult['"NETLOCABS"'] := 'ABS^STUFFONLY';
   // if copying abs on import, set abs pointer saf 12/8/98

  if (Writedir <> '') then xBrokerx.Param[0].Mult['"WRITEDIR"'] := '2^' + WRITEDIR;
  screen.cursor := crHourglass;
  //oldcopy  xBrokerx.remoteprocedure := 'MAGGADDIMAGE';
  ss := xBrokerx.STRcall;
  screen.cursor := crDefault;
  msg('s', ss);
  ImgPtr := FMagUtils.magpiece(sS, '^', 1);
  magien := ImgPtr;
  if ((ImgPtr = '0') or (ImgPtr = '')) then
  begin
    msg('', 'Image data NOT FILED : ' + FMagUtils.magpiece(sS, '^', 2));
    messagebeep(0);
    imagefiled := false;
    magien := '';
    exit;
  end;
  msg('', 'The Image data was filed OK');
  dirx := FMagUtils.magpiece(sS, '^', 2);
  FileSave := FMagUtils.magpiece(sS, '^', 3);
  MagImageFullPathAndName := dirx + filesave;
  FileSave := FMagUtils.magpiece(FileSave, '.', 1);
  if MagConfig.imagegroup.checked then ImagePtrLst.Items.Add(ImgPtr + '^' + FileSave);
  Memo2.Lines.Add('FILENAME^1^' + FileSave + Format);

//If not(UpperCase(Remote)='NONE') then
//      begin
//      Memo2.Lines.SaveToFile(tempdir + FileSave + '.txt');
//      Memo2.Clear;
//      end;
  imagefiled := true;

end;  *)
procedure TMagImport.ClearProperties;
begin
  FDFN := '';
  FImages.clear;
  FProcPKG := '';
  FProcIEN := '';
  FProcDt := '';

  {/ JK 11/30/2009 - P108 /}
  FProcNew := '';
  FProcTIUTitle := '';
  //-FProcTIUSignature := '';
  FProcTIUSignatureType := '';

  FTrkNum := '';
  FAcqDev := '';
  FAcqSite := '';
  FExcpHandler := '';

  FImgType := '';
  FMethod := '';
  FCapBy := '';
  FUsername := '';
  FPassword := '';
  FAcqLoc := '';
  FDOCCTG := '';
  FDocDT := '';
  FixType := '';
  FixSpec := '';
  FixProc := '';
  FixOrigin := '';

  FGroupDesc := '';
  FDeleteFlag := FALSE;
  FTransType := 'NEW';

  FCapDt := '';
  FProcType := '';
  FProcDesc := '';
  FGroupIEN := '';
  FGroupLongDesc.clear
end;


procedure TMagImport.ImageArrayFromFields(var t: Tstringlist);
var
  ict: integer;
  i: Integer;
begin
  { here we reformat the Imaging Fields from the component into an array
  and call The RPValidate function. {}
  t.clear;
  t := Tstringlist.Create;

  t.Add('IDFN^' + FDFN);

  {/ JK 11/30/2009 - P108 /}
  if (FProcNEW <> '') then
  begin
    t.Add('PXNEW^' + FProcNEW)
  end;

  if (FProcTIUTitle <> '') then
  begin
    t.Add('PXTIUTTL^' + FProcTIUTitle)
  end;

//  if (FProcTIUSignature <> '') then
//  begin
//    t.Add('PXTIUSGN^' + FProcTIUSignature)
//  end;

  if (FProcTIUSignatureType <> '') then
  begin
    t.Add('PXSGNTYP^' + FProcTIUSignatureType)
  end;

  t.add('PXTIUTCNT^' + IntToStr(FProcTIUText.Count));

  for i := 0 to FProcTIUText.Count - 1 do
  begin
    t.Add('PXTIUTXT' + IntToStr(i) + '^' + FProcTIUText[i])
  end;



  if (FProcPKG<>'') then
  begin
    t.Add('PXPKG^' + FProcPKG)
  end;
  if (FProcIEN<>'') then
  begin
    t.Add('PXIEN^' + FProcIEN)
  end;
  if (FProcDt<>'') then
  begin
    t.Add('PXDT^' + FProcDt)
  end;
  { Tracking Number is ';' delimited string.  2 pieces
        1 = the package ID    i.e. 8924 (tiu)  'DSS' (DSS)
        2 = some unique number in relation to the package. }
  if (FTrkNum<>'') then
  begin
    t.Add('TRKID^' + FTrkNum)
  end;
  { Acq Dev Field = Computer Name}
  if (FAcqDev<>'') then
  begin
    t.Add('ACQD^' + FAcqDev)
  end;
  if (FAcqSite<>'') then
  begin
    t.Add('ACQS^' + FAcqSite)
  end;
  if (FAcqLoc<>'') then
  begin
    t.Add('ACQL^' + FAcqLoc)
  end;
  t.Add('STSCB^' + FExcpHandler);

  { The next fields are NOT Required, so test for ''}
  if (FImgType<>'') then
  begin
    // t.add(ResolveImageType);
    {TODO: make an RPC so other vendors can get list of
         image types and image type IENS, then this field will
         valildate just like any other.
        HERE we assume the image type is from our list.}
    t.Add('ITYPE^' + FImgType)
  end;
  { TODO -ogarrett -cFields : create Function ResloveImageType }
  if (FMethod<>'') then
  begin

    { TODO -ogarrett -cFields : Stuarts Component to Generate Images. }
    (*TImageMethodComponent.ResolveImages(FMethod,FImages);
        if (FImages.count = 0)
          then
            begin
              result := false;
              xmsg := 'Call to Generate Images returned ''0'' Images.');
              exit;
            end
         *)
  end;
  if (FCapBy<>'') then
  begin
    t.Add('CDUZ^' + FCapBy)
  end;
  { DONE :  FDOCCTG and FDocDt. DocDt and PXDT could both have values.
           DocDT is field 110 in image file.  DOCUMENT DATE}
  if (FDOCCTG<>'') then
  begin
    t.Add('DOCCTG^' + FDOCCTG)
  end;
  if (FDocDT<>'') then
  begin
    t.Add('DOCDT^' + FDocDT)
  end;
  if (FixType<>'') then
  begin
    t.Add('IXTYPE^' + FixType)
  end;
  if (FixSpec<>'') then
  begin
    t.Add('IXSPEC^' + FixSpec)
  end;
  if (FixProc<>'') then
  begin
    t.Add('IXPROC^' + FixProc)
  end;
  if (FixOrigin<>'') then
  begin
    t.Add('IXORIGIN^' + FixOrigin)
  end;
  // FUsername
  // FPassword not validated here
  if (FGroupDesc<>'') then
  begin
    t.Add('GDESC^' + FGroupDesc)
  end;
  // FDeleteFlag not used here.  It is queried later, after image has been copied.
  // FTransType  not validated here, used in the 'Save' Call.
  { This is end of Fields that are implemented }
  // FProcType
  // FProcDesc
  // if (FCapDt <> '') then t.add('7^' + FCapDt);
  // FGroupIEN
  // FGroupLongDesc not validated, it is sent as is ( if it exists)
  if (FImages.Count>0) then
  begin
    for ict := 0 to FImages.Count - 1 do
    begin
      t.Add('IMAGE^' + FImages[ict])
    end;
  end;
end;


function TMagImport.Validate(var vrmsg0: String) : boolean;
var
  t: Tstringlist;
begin
  { here we reformat the Imaging Fields from the component into an array
  and call The RPValidate function. }
  {p135  -  New.  We also check the Image Size BEFORE we copy.  File size 0 we fail it.}
try

indentinc;
lgdm('<< ENTER : Validate >>');
  t := Tstringlist.Create;
  try
    t.Add('5^' + FDFN);
    if (FProcPKG<>'') then
    begin
      t.Add('16^' + FProcPKG)
    end;
    if (FProcIEN<>'') then
    begin
      t.Add('17^' + FProcIEN)
    end;
    if (FProcDt<>'') then
    begin
      t.Add('15^' + FProcDt)
    end;
    { Field for Tracking Number is a delimited string.  2 pieces
        1 = the package ID    i.e. 8924 (tiu)  'DSS' (DSS)
        2 = some unique number in relation to the package. }
    t.Add('108^' + FTrkNum);
    { Acq Dev Field = Computer Name}
    //10-23-03 GEK p8t31 Changed 107 to ACQD  We add new entries to the
    //   Acquisition Device File, if they don't exist.  BUT the Action Code
    //    ACQD does this, not Field 107
    //10-23-03 gek p8t31 t.add('107^' + FAcqDev);
    // THIS WORKED it added the new Acquisition Device FM entry.
    //   but not
    t.Add('ACQD^' + FAcqDev);
    //p8t21 t.add('.05^' + FacqSite);
    t.Add('ACQS^' + FAcqSite);
    //P8T21 if (FAcqLoc <> '') then t.add('101^' + FacqLoc);
    if (FAcqLoc<>'') then
    begin
      t.Add('ACQL^' + FAcqLoc)
    end;
    { DONE : We need to send ACQS and ACQL instead of the field #'s to populate
the Acquisition Device file.}
    //t.add...(FExcpHandler)
    { We don't care about the exception handler. From this call
    The BP will send any error message to the calling package.
      It needs the Exception handler }
    { The next fields are NOT Required, so  need to test for ''}
    if (FImgType<>'') then
    begin

      // t.add(ResolveImageType);
      // WE might make an RPC so other vendors can get list of
      //  image types and image type IENS, then this field will
      //  valildate just like any other.
    end;
    { TODO -ogarrett -cFields : create Function ResloveImageType }
    if (FMethod<>'') then
    begin

      { TODO -ogarrett -cFields : Stuarts Component to Generate Images. }
      (*TImageMethodComponent.ResolveImages(FMethod,FImages);
        if (FImages.count = 0)
          then
            begin
              result := false;
              xmsg := 'Call to Generate Images returned ''0'' Images.');
              exit;
            end
         *)
    end;
    if (FCapBy<>'') then
    begin
      t.Add('8^' + FCapBy)
    end;
    { DONE :  FDOCCTG and FDocDt. DocDt and PXDT could both have values.
           DocDT is field 110 in image file.  DOCUMENT DATE}
    if (FDOCCTG<>'') then
    begin
      t.Add('100^' + FDOCCTG)
    end;
    if (FDocDT<>'') then
    begin
      t.Add('110^' + FDocDT)
    end;
    if (FixType<>'') then
    begin
      t.Add('42^' + FixType)
    end;
    if (FixSpec<>'') then
    begin
      t.Add('44^' + FixSpec)
    end;
    if (FixProc<>'') then
    begin
      t.Add('43^' + FixProc)
    end;
    if (FixOrigin<>'') then
    begin
      t.Add('45^' + FixOrigin)
    end;
    // FUsername
    // FPassword not validated here
    if (FGroupDesc<>'') then
    begin
      t.Add('10^' + FGroupDesc)
    end;
    // FDeleteFlag not used here.  It is queried later, after image has been copied.
    // FTransType  not validated here, used in the 'Save' Call.
    { This is end of Fields that are sent as parameters }
    // FProcType
    // FProcDesc
    // if (FCapDt <> '') then t.add('7^' + FCapDt);
    // FGroupIEN
    // FGroupLongDesc not validated, it is sent as is ( if it exists)
    try
    {RPC Broker calls for Imaging Import all return as '0^...'  '1^...'}
    FDBBroker.RPMag4ValidateData(Fstat, Flist, t, '1');
    vrmsg0 := Flist[0];
    Result := Fstat;
    if not Fstat then
    begin
      lgl(Flist)
    end
    except
      on e:exception do
        begin
          vrmsg0 := '0^EXCEPTION: RPC Mag4Validate';
          lgm(vrmsg0);
          lgm('msg: ' + e.message);
          lgl(flist);
          result := false;
        end;
    end;
  finally
    t.Free  ;
    lgdm('<< EXIT - Validate >>');
    indentdec;
  end;
  except
   on e:exception do
     begin
       result := false;
       vrmsg0 := '0^EXCEPTION: RPC Mag4Validate';
       lgm(vrmsg0);
       lgm('msg: '  + e.Message) ;
     end;
  end;
end;


function TMagImport.ImportDataArray(var xmsglist: Tstringlist; InArray: Tstringlist) :
boolean;
var
  stat: boolean;
begin
  Maglogger.Log(Trace, 'Entered TMagImport.ImportDataArray');
  Maglogger.LogList(Info, InArray);
  FDBBroker.RPMag4RemoteImport(stat, xmsglist, InArray);
  Result := stat;
  //Maglogger.Log(Trace, 'Exited TMagImport.ImportDataArray');
end;

procedure TMagImport.IndentInc();
begin
if FDebugON then
  Findent := Findent + '--';
end;

procedure TMagImport.IndentDec();
begin
if FDebugON then
  Findent :=  copy(Findent,3,99);
end;


procedure TMagImport.ImportQueue(var resStatus: boolean; Qnum: String; var reslist:  Tstrings; var StatusCB: String;  NoCallBackOnError: boolean = FALSE);
var
  xmsg: string;
  ok, DoStatusCB, success, rstat: boolean;
 rmsg,  vserver,  vport, RPmsg,  savestat,
              rescindImage, RescindImageRaw: string;
    shares: tstringlist;
begin
{p135  When processing starts for an ImportQueue, we first check the Registry values for Debug Status.}
{ this call will set the Debug flags: FDebugON, FDebugToFileON, and FDebugFileName}
  //CheckDebugFromINI;
  CheckDebugFromRegistry;


  FImportActionValue := ''   ;
  FImportIsRescind := false;
  rescindImage := '';
  IndentInc;
  lgdm('1- << ENTER - ImportQueue >>');
  try  {TRY - 1}
  //FGmsg.Clear;
  lgdm('1- Log cleared.');
  FLogList.clear;
  { ---- If problem with VistA connection, we stop. ---- }
  {p135 overall we are saving more details during each function or procedure.  these details are
        stored in FLogList and returned to the calling app in the result list (var parameter: resList).
  {p135  in the VistAInit procedure, we are now saving more details about the connection
        So, when ImportQueue is called, if the VistAInit fails,  we are able to return information
        to the user that will enable them to track the issue much easier.}
  {Calling VistAInit before each Import.  VistAInit has been modified to check for a connection, and if a connection
      doesn't exist, the procedure will check for a Initial Login Values.   FSA* variables.
      and it will attempt silenct connect with those values if needed. }
  {135t6  we're adding more details about errors, so when a failure.  the BP or other Calling App, can display msg's.
     in their interface and the result array will have more info for debugging
     Because of this, we use the FLogList:Tstrings, but calling Function lgm()
     previous to 135t6, reslist was populated and returned.  FLogList was only used after SAVE further in this
     function.  So now we always assume FLogList could exist, and we Set the [0,1,2] nodes each time, then
     assign reslist.assign(FLogList).  This is how the messages in FLogList that are set from any function,
     are returned to the caller. }
  VistAInit(ok, xmsg, vserver, vport);
  if not FBroker.Connected then
  begin
    resStatus := FALSE;
    Qnum := '0';
    lgdm('1- After VistAInit: FBroker.connected = FALSE');
    lgdm('1- ' + xmsg);
    FLogList.insert(0,'0^No Connection to VISTA.');
    FLogList.insert(1, 'Queue Number : ' + Qnum);
    reslist.assign(FLogList);
    exit
  end;
  // reslist.Add('Connected: ' + vserver + ',' + vport);

  try  {TRY - 2}

  {  ----  if we can't create directories, (unlikely) we'll have to stop ---- }
  If Not SetIAPIDirectories(Rmsg) Then
     begin
     resStatus := false;
            lgdm('1- '+ Rmsg);
     FLogList.insert(0,'0^'+rmsg);
     FLogList.insert(1, 'Queue Number : ' + Qnum);
     reslist.assign(FLogList);
     exit;
     end;
    lgm('NetSecurity On = ' + magbooltostr(GetNetSecurityOn));
    {Create a New array for logging events/actions/warnings.;}
    if FDebugON
        then  lgdm('1- In Debug mode : Not Clearing LogList') //FLogList.clear;
        else
          begin
          FLogList.clear;
          lgdm('1- Log cleared.');
          end;
    lgdm('1- MagSecurity.NetSecurityON= ' + magbooltostr(GetNetSecurityOn));
    lgdm('1- Param: Qnum= '+Qnum);
    lgdm('1- Param: NoCallBckErr= '+BoolToStr(NoCallBackOnError));

    {Initialize the results list, and default the result status to False.}
    reslist.clear;
    resStatus := FALSE;

    {Now get the data from VistA that was saved in the Import Queue File IMPORT QUEUE(#2006.34)
      for this Qnum.   FTrkID is undefined until here.}
    lgdm('1- Data from Import Queue...');
    FDBBroker.RPMag4DataFromImportQueue(Fstat, Flist, Qnum);
    if not Fstat then
    begin
      lgdm('1- ERROR: RPC Mag4DataFromImportQueue.');
      {does flist[0] have '0^ format.... Yes }
      reslist.assign(Flist);
      reslist.AddStrings(FLogList);   { TODO -c135 : is this a Type Mismatch  }
      exit
    end;
    lgdm('1- Data from Import Queue.  OK.');

    {p/121 or VLER,  get list of shares, and set MagSecurityProperty, to handle UserName Password.}
    Shares := tstringlist.create;
    FDBBroker.RPMagGetNetLoc(success, RPmsg, Shares, 'ALL');
    try  {TRY - 3}
      FMagSecurity.ShareList := Shares;
      except {TRY - 3}
      on e:exception do
        begin
          lgm('EXCEPTION:  Setting list of shares.');
          lgm(' msg: ' + e.Message);
          lgm(' process is continuing.');
        end;
    end;
    Shares.Free;
    {/p121 VLER  end.}

  //121
  {  ---- first, in 121, we need to get data for Tracking ID, StatusCB, so we can process
          and RPC to send the results back.  New function to Get data Value from Array.}

  //FTrkNum
  FtrkNum := GetArrayValue('108',flist);
  //FExcpHandler
  FExcpHandler := GetArrayValue('STATUSCB',flist);
  StatusCB := FExcpHandler ;

    try  {TRY - 4}
// *********   121 start

    { TODO -c121 :
[  ] A) IF Action = Rescind
[  ] B) call RPC to get Data from MAGIEN
       > Chnge - modified Rescind MAGGSIU4 M rtns to set Import Queue with data from
        the image entry.  so B can wait or not needed. later.
[  ] C) create an FList array in the expected format.... like this was a normal Import
[  ] D) Copy the Image From the Share to the wrkstation
        rename it on Wrks.
        What directory to put it in.

[  ] E) Watermark the Image.
        New filename  = filename_Rescind.*
        Add it to Flist.items[i]="IMAGE^....
       Set the delete Flag, to delete on successful import.
[  ] F) then just continue

[  ] G) BUT at end, the Results that are sent to STATCB need to have extra items
        n... n+1  etc have ACTION^     IMAGE^<full path to image>
        so we can set the Delete Queue.}

//**********    121  end
{/p121 if ACTION=RESCIND, then Pre-Process array first.}


 // new 121 ACTION property
FImportActionValue :=  GetArrayValue('ACTION',flist);


//if GetImportACTION(Flist)='RESCIND' then
if FImportActionValue = 'RESCIND' then
               begin
                 lgdm('1- ACTION = RESCIND') ;
                 FImportISRescind := true;
                 try {TRY - 5}
                 if not CreateAccusoftControls(rmsg) then
                    begin
                     resStatus := false;
                     Floglist.insert(0,'0^' + rmsg)  ;
                     Floglist.insert(1,FtrkNum);
                     Floglist.Insert(2,Qnum);
                     reslist.Assign(FLogList);
                     exit;
                    end;
                 except     {TRY - 5}
                 on e:exception do
                   begin
                     lgdm('R- EXCEPTION : CreateAccusoftControls.');
                     lgdm('R- msg: ' + e.Message);
                     resStatus := false;
                     FLogList.insert(0,'0^EXCEPTION : CreateAccusoftControls.')  ;
                     FLogList.insert(1,FtrkNum);
                     FLogList.Insert(2,Qnum);
                     reslist.assign(FLogList);
                     exit;
                   end;

                 end; {exception}
                 {Here we create the WaterMarked Image, and Put it in  Flist[]',
                   rescindImage will be returned.  It's the Actual (existing) Image that is being Rescinded.  ...  }
                 PreProcessRESCINDArray(rstat, rmsg, rescindimage, Flist);
                 if not rstat  then
                   begin
                     resStatus := false;
                     FLogList.insert(0,'0^'+rmsg);
                     FLogList.insert(1,FtrkNum);
                     FLogList.Insert(2,Qnum);
                     reslist.assign(FLogList);
                     exit;
                   end;
               end;


      // all Properties are defined in the next call, FtrkNUM is one of them
      if ImageArrayToFields(xmsg, Flist) then
      begin
        lgdm('1- Image Array To Fields. OK.');

// Calling *******                   SAVE
        resStatus := SAVEToVistA(xmsg);
// Save  *******   has been called.

        savestat := booltostr(resStatus);
        lgdm('1- SAVE Status :  ' + savestat)
      end
      else
      begin
        lgdm('1- Image Array To Fields. ERROR.');
        lgdm('1- ' + xmsg);
        if (FMagUtils.magpiece(xmsg, '^', 1)<>'0') then
        begin
          lgdm('1-  ERROR Status and 0 node mismatch')
        end;
      end;

    except              {TRY - 4}
      on E : Exception do
        begin
          lgdm('1- Exception:  ' + E.Message);
          resStatus := FALSE;
          xmsg := '0^' + E.Message
          //lgdm('Exception : ' + E.message);
        end;
    end;
    { Status Callback : our M routine will call their Status Callback{}
    {Patch P8T32  IMport API will call the Status Callback routine.}
    {  if success, but warnings, then change the '1^' to a '2^'.{}
    if ((FMagUtils.magpiece(xmsg, '^', 1)='1') and (FLogList.Count > 0)) then
    begin
      xmsg := '2' + copy(xmsg, 2, 999)
    end;
    FLogList.insert(0, xmsg);
    FLogList.insert(1, FTrkNum);
    FLogList.insert(2, Qnum);
    lgdm('1-End- NoCallBackOnError: '+booltostr(NoCallBackOnError));
    lgdm('1-End- Status Callback:  '+FexcpHandler);
    reslist.assign(FLogList);
    StatusCB := FExcpHandler
  finally   {TRY - 2}
    { Patch P8T32  IMport API will call the Status Callback routine.
      based on new param NoCallBackOnError    {}
    DoStatusCB := ((resStatus) or ((not resStatus) and (not NoCallBackOnError)));

    { DONE -c121 : Need to return (to VistA) the fullpathtoFile for delete Queue to process .
              This data is beign kept in Session file.  We return full file here, but it
              isn't used.  Okay.}
    if FImportIsRescind then
       reslist.Add('RESCINDED IMAGE FILE^' + rescindimage)  ;
    MagDBBroker.RPMag4StatusCallback(reslist, FExcpHandler, DoStatusCB);

  end;
  finally      {TRY - 1}
    lgdm('1- << EXIT - ImportQueue >>');
  Indentdec;
  end;
end;

{/p121 functions for Watermarking}
{Function GetImportACTION(Flist: Tstringlist): string;   was deleted.  This call is generic for any value}

function TMagImport.GetArrayValue(value : String; imgarray: Tstringlist) : string;
var
  I: integer;
  fld,
  data: string;
begin
result := '';
  for I := 0 to imgarray.Count - 1 do
  begin
      fld := FMagUtils.magpiece(imgarray[I], '^', 1);
      data := copy(imgarray[I], pos('^', imgarray[I]) + 1, 999);
      if fld = value then
         begin
         result := data;
         break;
         end;
  end;
end;




Function  TMagimport.CreateAccusoftControls(var rmsg: string): boolean;  //AssociateControls();
//var
// force Error to test  //Tob : TEdit;
var
 createobjs : string;
begin
// force error to test //tob.SetFocus;
{code base :   from FMag4VGear14}
      // create new save and load options
   { DONE -c121 : [Okay.] Only create, if not already created. }
Try
createobjs := '';
result := false;
rmsg := 'Error Creating accusoft Controls';

if not assigned(vIGSaveOptions) then
  begin
  vIGSaveOptions := MagIGManager.IGFormatsCtrl.CreateObject(IG_FORMATS_OBJ_SAVEOPTIONS) As IIGSaveOptions;
  vIGSaveOptions.Format := IG_SAVE_UNKNOWN;
  createobjs := createobjs + 'IIGSaveOptions,';
  end;

if not assigned(vIGLoadOptions) then
  begin
  vIGLoadOptions := MagIGManager.IGFormatsCtrl.CreateObject(IG_FORMATS_OBJ_LOADOPTIONS) As IIGLoadOptions;
  vIGLoadOptions.Format := IG_FORMAT_UNKNOWN;
  createobjs := createobjs + 'IIGLoadOptions,';
  end;
    // create new page and page display objects , associate with page view control
if not assigned(vIGPage1) then
  begin
  vIGPage1 := MagIGManager.IGCoreCtrl.CreatePage;
  vIGPageDisplay1 := MagIGManager.IGDisplayCtrl.CreatePageDisplay(vIGPage1);
  createobjs := createobjs + 'IGPage1,IGPageDisplay1,';
  end;
if not assigned(vIGPage2) then
  begin
  vIGPage2 := MagIGManager.IGCoreCtrl.CreatePage;
  vIGPageDisplay2 := MagIGManager.IGDisplayCtrl.CreatePageDisplay(vIGPage2);
  createobjs := createobjs + 'IGPage2,IGPageDisplay2,';
  end;

Result := true;
if (createobjs = '')  then rmsg := 'Accusoft Controls Okay.'
                      else
                      begin
                        rmsg := 'Accusoft Controls Created.';
                        lgdm(createobjs);
                      end;


except
  on e:exception do
    begin
      result := false;
      rmsg := 'EXCEPTION Creating Accusoft Controls.';
      lgm('msg: ' + e.message);
      lgdm(rmsg);
      lgdm('msg: ' + e.Message);
    end;
End;
end;


procedure TMagimport.LoadImage1(filename : string);
//var IoLocation : IIGIOLocation;
begin
  vIGPageDisplay1.Layout.alignment := IG_DSPL_ALIGN_X_CENTER Or IG_DSPL_ALIGN_Y_CENTER;
      vIGPageDisplay1.Layout.UseImageResolution := True; // JMW p72 12/8/2006 - use image resolution for aspect ratio

  //    IoLocation := GetIGManager.IGFormatsCtrl.CreateObject(IG_FORMATS_OBJ_IOFILE) As IIGIOLocation;
  //    (IoLocation As IGIOFile).Filename := Filename;
      MagIGManager.IGFormatsCtrl.LoadPageFromFile(vIGPage1, Filename, 0); //dialogLoadOptions.PageNum);

////if assigned(vIGPageViewCtl1) then   vIGPageViewCtl1.UpdateView;
end;

function TMagImport.GetWaterMarkBitmap(): string;
begin
  result := FWaterMarkBitmap;
end;

procedure TMagimport.LoadImage2WMK();
var IoLocation : IIGIOLocation;
filename : string;
begin
filename := GetWaterMarkBitmap;

  vIGPageDisplay2.Layout.alignment := IG_DSPL_ALIGN_X_CENTER Or IG_DSPL_ALIGN_Y_CENTER;
      vIGPageDisplay2.Layout.UseImageResolution := True; // JMW p72 12/8/2006 - use image resolution for aspect ratio

      IoLocation := GetIGManager.IGFormatsCtrl.CreateObject(IG_FORMATS_OBJ_IOFILE) As IIGIOLocation;
      (IoLocation As IGIOFile).Filename := Filename;
      MagIGManager.IGFormatsCtrl.LoadPageFromFile(vIGPage2, Filename, 0); //dialogLoadOptions.PageNum);

////if assigned(vIGPageViewCtl2) then   vIGPageViewCtl2.UpdateView;
end;



{/p121  PreProcessRESCINDArray
        In this procedure the IMAGE item of the input data array, is changed to the name of the newly created
         Watermarked Image... format 'WMK_imageIEN.Ext' .   later we need to delete this WMK_ file.  Regardless of DELFLAG. }


procedure TMagimport.PreProcessRESCINDArray(var rstat : boolean; var rmsg : string; var rescindimage : string; var Flist: TStringlist);
var I : integer;
    s : string;
    magien : string;
    xmsg : string;
    tmpImage, tmpExt, tmpDir ,tmpFileName, WMKfilename: string;
    ImageItem : integer;
    oserror : integer;
begin
try
  rstat := false;
  rmsg := 'Pre-Processing for Rescind action...';
  rescindImage := '';
  {/p121 rethink the DelFlag... the BP will be deleting the image
    later.  We'll leave for now.... magSecurity won't be open...let BP do it.}
  {/p121  gek.  We set the DelFlag here}
  /// Flist.Add('DELFLAG^1');
  for i := 0 to fList.Count - 1 do
    begin
      s :=  fmagutils.MagPiece(flist[i],'^',1);
      if s = 'IMAGE' then
        begin
          imageItem := i;
          magien :=  fmagutils.MagPiece(flist[i],'^',2);
          rescindimage := fmagutils.MagPiece(flist[i],'^',3);
          break;
        end;
    end;
  if rescindimage = '' then
    begin
      rmsg := 'Image is missing from input data.';
      exit;
    end;

    { DONE  -c121 :
      use, users's directory and 'force temp directory in that' copy to that,
      watermark, rename, return new name, and that'll be imported.
      New function SetIAPIDirectories - create the variables if needed.}

{/p121 we need a temp file name.  for now prototype use C:\temp <- now FDirTemp 5/9/11}
if FDirTemp = '' then  FDirTemp := 'C:\temp\';

tmpImage := 'magtemp'+magien;
tmpExt := extractfileext(rescindimage);
tmpFileName := FDirTemp + tmpImage + tmpExt;

{/p121  if the file exists.  Delete it. (CopyTheFile doesn't delete it.)   We don't want to require User Interaction.}
if FileExists(tmpFileName) then
  begin
   {$I+}
   deleteFile(tmpfilename);
   {$I-}
   oserror := getlasterror;
   if (oserror <> 0) then
     begin
         rmsg := 'ERROR: DeleteFile - ' + tmpfilename;
         lgm('Delete File error : '+ inttostr(osError) + syserrormessage(oserror));
         rstat := false;
        exit;
     end;
   
  end;

{the TXT File is created in the CopyTheFile function, unless we send False as 4th param
   so we send False now, because it will get created later in the actual Import.}
rstat := CopyTheFile(xmsg,rescindimage,tmpFileName,false);
if not rstat then
  begin
    rmsg := xmsg;
    exit;
  end;
      { DONE -c121 : need to return array for reason for failure... }
rstat := WaterMarkTheImage(xmsg,tmpFilename,WMKfilename);
if not rstat then
  begin
    rmsg := xmsg;
    exit;
  end;
(*if not CreateAndSaveImageTextFile(WMKFilename, xmsg) then
  begin
   rstat := false;
   rmsg := xmsg;
   exit;
  end; *)
{now delete the temp file names.  }
DeleteFile(tmpfilename);
//DeleteFile(changefileext(tmpfilename,'.txt'));
{/p121 here the Image is watermarked and now we just substitue the
   watermarked image as the 'new' image and continue.  sure... it's that easy.}
 { DONE -c121 : Should we Create TXT file here, with WMK name ? not before this. Don't want to change and Break anything though...
    NO, the CopyTheFile function will make the TXT file, unless we tell it not to .}
flist[imageitem] := 'IMAGE^' + WMKfileName
except
  on e:exception do
    begin
      rstat := false;
      rmsg := 'EXCEPTION : PreProcessRescindArray';
      lgm(rmsg);
      lgm('msg: ' + e.Message);
      lgdm('msg: ' + e.message);
    end;
end;
end;

function TMagImport.WaterMarkTheImage( var rvmsgs : string; filetomark : String; var Newfilename : string): boolean;
var i : integer;
rmsg : string;
//////////
pg ,pgct,h,w ,bits: integer;
 pImageFormat : enumIGformats;
 pIntegerformat : integer;
 pgInfo: IGFormatPageInfo;
WMKfilename : string;
fileExt : string;
WMKbitmap : string;
begin
try
indentinc;
try
lgdm('<< ENTER - WaterMarkTheImage>>');
rvmsgs := 'Starting Watermarking process...';
result := false;
WMKbitmap := GetWaterMarkBitmap;
if not fileexists(WMKBitmap) then
  begin
    lgm('WaterMark Process Failure.');
    rmsg := 'WaterMark Bitmap File NOT Found : ' + WMKBitmap;
    rvmsgs :=   rmsg;
    lgm(rmsg);
    exit;
  end;
lgdm('filetoMark: ' + filetomark);

 LoadImage1(filetomark);
 { after multiple 'resizings' the watermark bitmap will get grainy, so load again for each image.  This is safe.  }
 LoadImage2WMK;
  { DONE -c121 :   Promote 8, 24 ....   ConvertToGray....    Resize.... }

  { DONE -c121 : PDF to JPG.... not automatically,  the logic determines what FileFormat to use.}
  { DONE -c121 : ConvertToGray....}
  { DONE -c121 : Resize....}
(*  WaterMarkConvertToGray;
    WaterMarkResizeRescind;
    MagIGManager.IGEffectsCtl.AddWatermark(vIGPage1,vIGPage2);
*)

////////////////////////  from watermark1   ////////


{note:  ExtractFileExt(filename);   the result contains the '.'  i.e. ".pdf"}

              { TODO -c121 : (not urgent, only create, if not already created.
                             and/or destroy when done.    DOES Accusoft IGFormatsCtrl have a DestroyObject ? }
  FIoLocation := MagIGManager.IGFormatsCtrl.CreateObject(IG_FORMATS_OBJ_IOFILE) As IIGIOLocation;
  (FIoLocation As IGIOFile).Filename := filetomark;
 pImageFormat :=  MagIGManager.IGFormatsCtrl.DetectImageFormat(FioLocation);
 lgdm('ImageFormat: ' + inttostr(pImageFormat) + ' - ' + GetFormatDesc(pImageFormat));

// MagIGmanager.IGFormatsCtrl.des...
//FIoLocation._Release;
 pintegerformat := pImageFormat;
//na msg1('Image format: ' + inttostr(pImageFormat) + GetIGFormatName(pImageFormat)  );

(* //na    if pImageFormat =  IG_FORMAT_PDF  then   msg1('pImageFormat : IG_FORMAT_PDF')
    else if pImageFormat =  IG_FORMAT_TIF   then   msg1('pImageFormat : IG_FORMAT_TIF ')
     else   if pImageFormat =  IG_FORMAT_JPG   then   msg1('pImageFormat : IG_FORMAT_JPG')
        else   if pImageFormat =  IG_FORMAT_POSTSCRIPT   then   msg1('pImageFormat : IG_FORMAT_POSTSCRIPT ')

       else msg1('unknown format')    ; *)

   PgInfo := MagIGManager.IGFormatsCtrl.GetPageInfo(FIoLocation, 0, IG_FORMAT_UNKNOWN);
   pgct := MagIGManager.IGFormatsCtrl.GetPageCount(FIoLocation,IG_FORMAT_UNKNOWN);
 lgdm('PageCount: ' + inttostr(pgct));
 lgdm('BitDepth : ' + inttostr(pginfo.BitDepth));
//na   scrollInit1(pgct);

(*  msg1('loading Page From File ' + filename);
  msg1('size: ' + Inttostr((Getfilesize(filename) Div 1024) + 1) + ' KB');
  msg1('pages :   ' + inttostr(pgct) + ' Pages.');
  msg1('bitdepth ' + inttostr(pginfo.BitDepth));
  msg1('compression ' + inttostr(pginfo.Compression));
  msg1('format ' + inttostr(pginfo.Format));
*)
//  h := vIGPage1.ImageHeight;
//  w := vIGPage1.ImageWidth;
//na  msg1('Resizing vIGPage2 (watermark).');
//moved below, for each page    MagIGManager.IGProcessingCtrl.ResizeImage(vIGPage2, w,h,IG_INTERPOLATION_GRAYSCALE);  //this is the Watermark.


{before we start the Multipage process, we need to get the filename, and delete any existing files of that name.}
           case pIntegerFormat  of
           IG_FORMAT_PDF, IG_FORMAT_TIF, IG_FORMAT_JPG,IG_FORMAT_EXIF_JPEG  :
               begin
                WMKFilename := GetWaterMarkFileName(filetomark);
               end;
            ELSE
               begin
                WMKFilename := GetWaterMarkFileName(filetomark,'.tif');
               end;
            end;
 NewFileName := WMKFilename;
lgdm('NewFileName: ' + NewFileName);
for pg := 0 to pgct-1 do
     begin
     MagIGManager.IGFormatsCtrl.LoadPageFromFile(vIGPage1, filetomark, pg); //dialogLoadOptions.PageNum);
//na     vIGPageViewCtl1.UpdateView;
//na     msg1('Loaded page '+ inttostr(pg) + '  of  ' + inttostr(pgct-1));

     //if this is pdf, then we rasterize the IGPage, Convert to Gray, then watermark. then

     if pImageformat = IG_FORMAT_PDF then
       begin
//na       msg1('...PDF Rasterizing');
       VIGPage1.Rasterize;
       lgdm('IG Method: Rasterized');
//na       msg1('...PDF ConvertToGray');
       {/gek.   Without ConverttoGray,  a PDF color image, when Watermarked, has 'colored' Rescind, and inverted colors.
                and the 'RESCIND' isn't always easily visible.  Convert to gray, then watermark is viewable.
                ....  and we won't have JPG Advance Directives.  So this won't be an issue for 'RESCIND' watermark.  Maybe
                other watermarks in future need to revisit this issue. }
       MagIGManager.IGProcessingCtrl.ConvertToGray(vIGPage1);
       lgdm('IG Method : ConvertToGray');
       end
     else
     begin
      case pginfo.BitDepth of
      1:  begin
            //na  msg1('...bit depth 1 or 4,  ConvertToGray');
             MagIGManager.IGProcessingCtrl.ConvertToGray(vIGPage1);
       lgdm('IG Method : ConvertToGray');
          end;
      4:  begin
            //na msg1('...bit depth 1 or 4,  ConvertToGray');
            MagIGManager.IGProcessingCtrl.ConvertToGray(vIGPage1);
       lgdm('IG Method : ConvertToGray');
          end;
      8:  begin
            {was only converting TIF's to gray, if they weren't gray already.  Testing showed
              no need for this, converting all 8 bit worked okay., less complex.}
            //nc/  if pImageformat <> IG_FORMAT_TIF then
            //nc/       MagIGManager1.IGProcessingCtrl.ConvertToGray(vIGPage1);
            //nc/  else {format = IG_FORMAT_TIF}
            //nc/  if not vIGPage1.ImageIsGray then
            MagIGManager.IGProcessingCtrl.ConvertToGray(vIGPage1);
       lgdm('IG Method : ConvertToGray');
          end;
      10:  begin
             {We shouldn't have any Advance Directives 10 bit}
             {performing Watermark on 10,12,16  .. the invert changes pixels to white
               image looks washed out. Later Patch look into this for 10,12,16}
       lgdm('IG Method : PromteTo24');
            MagIGManager.IGProcessingCtrl.Promote(vIGPage1,IG_PROMOTE_TO_24);
          end;
      12:  begin
               {even if Gray and 12,  the Watermark inverts and destroys the visible Image.
                     By Promoting,  then watermarking, the image is visible with watermark in inverted colors. }
            MagIGManager.IGProcessingCtrl.Promote(vIGPage1,IG_PROMOTE_TO_24);
                   lgdm('IG Method : PromteTo24');
          end;
      16:  begin
            MagIGManager.IGProcessingCtrl.Promote(vIGPage1,IG_PROMOTE_TO_24);
                   lgdm('IG Method : PromteTo24');
          end;
      24:  begin
              { do nothing, the convert to Gray is a possibility, for now, No.}
            // MagIGManager1.IGProcessingCtrl.ConvertToGray(vIGPage1);
          end;
      else  begin
              { do nothing, the convert to Gray is a possibility, for now, No.}
             // MagIGManager1.IGProcessingCtrl.ConvertToGray(vIGPage1);
          end;
      end; {case}
      end;
       {each page of a PDF can be different size}
         h := vIGPage1.ImageHeight;
         w := vIGPage1.ImageWidth;
       MagIGManager.IGProcessingCtrl.ResizeImage(vIGPage2, w,h,IG_INTERPOLATION_GRAYSCALE);  //this is the Watermark.
         lgdm('IG Method : ResizeImage - IG_Interpolation_GrayScale');


//na   msg1('...adding watermark');
   MagIGManager.IGEffectsCtl.AddWatermark(vIGPage1,vIGPage2);
          lgdm('IG Method : AddWaterMark');
(* ONE of these RadioButtons has to be checked in the Test App, so there is no ELSE (except in the rbSaveSame) rbSaveSame is what OCX will have*)
     if true  //rbSaveSAME.Checked
         then
          begin
          {save same is deceptive, because we promote 1 bit to 8 bit, and if 'Same' format (and compression)
             a ONE BIT 6 Page TIF goes from 308 KB to  48M !!!!!!!!!!!!!!!!!!!!    so we NEED  to use compression !!!!!!!!!}
           ///msg1('SavePageToFile  Append,  APPEND, UNKNOWN ');                                     // this will save as existing file type
           ///MagIGManager1.IGFormatsCtrl.SavePageToFile(vIGPage1,edtSaveAs.Text + FileExt,pg,IG_PAGESAVEMODE_APPEND,IG_SAVE_UNKNOWN)
           case pIntegerFormat  of
           IG_FORMAT_PDF  :
              begin                                                            //IG_SAVE_PDF_JPG    //IG_SAVE_PDF_RLE
              MagIGManager.IGFormatsCtrl.SavePageToFile(vIGPage1,WMKFilename,pg,IG_PAGESAVEMODE_APPEND,IG_SAVE_PDF_JPG);
              end;
           IG_FORMAT_TIF :
              begin
              MagIGManager.IGFormatsCtrl.SavePageToFile(vIGPage1,WMKFilename,pg,IG_PAGESAVEMODE_APPEND,IG_SAVE_TIF_PACKED);
              end;
           IG_FORMAT_JPG :
               begin
              // MagIGManager.IGFormatsCtrl.SavePageToFile(vIGPage1,edtSaveAs.Text + '.JPG',pg,IG_PAGESAVEMODE_APPEND,IG_SAVE_JPG);
               MagIGManager.IGFormatsCtrl.SavePageToFile(vIGPage1,WMKFilename,pg,IG_PAGESAVEMODE_APPEND,IG_SAVE_JPG);
               end;
           IG_FORMAT_EXIF_JPEG :
               begin
               MagIGManager.IGFormatsCtrl.SavePageToFile(vIGPage1,WMKFilename,pg,IG_PAGESAVEMODE_APPEND,IG_SAVE_JPG);
               end;
            ELSE
               begin
               MagIGManager.IGFormatsCtrl.SavePageToFile(vIGPage1,WMKFilename,pg,IG_PAGESAVEMODE_APPEND,IG_SAVE_TIF_PACKED);
               end;
           end; {case}
           lgdm('IG Method : SavePageToFile');
          end;
(* na    if rbSaveTIF.Checked then
         begin
            msg1('SavePageToFile  Append,  APPEND, IG_SAVE_TIF_PACKED');
           MagIGManager1.IGFormatsCtrl.SavePageToFile(vIGPage1,edtSaveAs.Text + '.TIF',pg,IG_PAGESAVEMODE_APPEND,IG_SAVE_TIF_PACKED);
          end;
    if rbSavePDF.Checked then
         begin
            msg1('SavePageToFile  Append,  APPEND, IG_SAVE_PDF_JPG');
           MagIGManager1.IGFormatsCtrl.SavePageToFile(vIGPage1,edtSaveAs.Text + '.PDF',pg,IG_PAGESAVEMODE_APPEND,IG_SAVE_PDF_JPG);
          end;
    *)
  (* RLE not used.  issues when testing in Watermark1
      if rbSavePDFRLE.Checked then
         begin
            msg1('SavePageToFile  Append,  APPEND, IG_SAVE_PDF_JPG');
           MagIGManager1.IGFormatsCtrl.SavePageToFile(vIGPage1,edtSaveAs.Text + '.PDF',pg,IG_PAGESAVEMODE_APPEND,IG_SAVE_PDF_RLE);
          end;*)

     end;



/////////////////////////////
 // MOVED ABOVE in loop for pages.   NewFileName := GetWaterMarkFileName(filetomark);
// not here, now done in multipage loop.    SaveImage1(Newfilename);
result := true;

except
   on E:Exception do
      begin
      result := false;
      rvmsgs := 'EXCEPTION : WaterMarkTheImage';
      lgm(rvmsgs);
      lgm('msg: ' + e.Message);
      if NewFileName <> '' then
         begin
         lgdm('EXECPTION : WaterMarkTheImage ' + NewFileName);
         copythefile(rmsg,GetWaterMarkBitmap,NewFileName,false);
         lgm('Exception processing : Copy the Watermark bitmap as the new file.');
         lgm('Result : ' + rmsg);
         end;
      rvmsgs := rvmsgs + ' ' + rmsg;
      end;
end;
finally
  indentdec;
end;
lgdm('<< EXIT - WaterMarkTheImage >>');

end;


function TMagimport.GetWaterMarkFileName(filename : string; fileext : string=''): string;
var
vname, vSaveAs : string;
begin
if fileext <> ''  then filename := ChangeFileExt(filename,fileext);

vname :=  'WMK_' + ExtractFilename(filename);
vSaveAs := FdirTemp + vname ;

if FileExists(vSaveAs) then deleteFile(vSaveAs);
if FileExists(vSaveAs)
   then
   begin
   self.lgm('FAILED to clear file: ' + vSaveAs + ' ' + SysErrorMessage(Getlasterror));
   result := '';
   exit;
   end;
result := vSaveAs;


(*var
vPath, vname, vExt, vSaveAs : string;
begin

vPath :=ExtractFilePath(filename);
vname := 'WMK_' + ExtractFilename(filename);
vExt := extractFileExt(filename);

vSaveAs := vPath +  changefileext(vname,'.jpg');
result := vSaveAs; *)
end;


Function TMagImport.SetIAPIDirectories( Var Rmsg: String): Boolean;
var BaseDir: String;
vAppPath : string;
vAppDataFolder : string;
vIAPIFolder : string;
oserror: integer;
Begin
  try
  Result := True;
  vAppPath := Copy(ExtractFilePath(Application.ExeName), 1,  Length(ExtractFilePath(Application.ExeName)) - 1);
  vAppDataFolder := GetEnvironmentVariable('AppData');
  If vAppDataFolder <> ''
    then vIAPIFolder := vAppDataFolder + '\VistA\Imaging\'
    else vIAPIFolder := vAppPath + '\VistA\Imaging\' ;

  FDirTemp := vIAPIFolder + 'temp\';
  FDirImage := vIAPIFolder + 'image\';
  FDirCache := vIAPIFolder + 'cache\';
  FDirImport := vIAPIFolder + 'import\';
    Try
      If Not Directoryexists(FDirTemp) Then
         begin
         {$I-}
         Forcedirectories(FDirTemp);
         {$I+}
         oserror := GetLastError;
         if ((oserror <> 0)  and (Not Directoryexists(FDirTemp)))  then
              begin
              lgm('FAILED to Create Directory: ' + FDirTemp);
              lgm('GetLastError: ' + inttostr(osError) + ' - ' + SysErrorMessage(Getlasterror));
              end;
         end;

      If Not Directoryexists(FDirImage) Then
         begin
         {$I-}
         Forcedirectories(FDirImage);
         {$I+}
         oserror := GetLastError;
         if ((oserror <> 0)  and (Not Directoryexists(FDirImage)))  then
              begin
              lgm('FAILED to Create Directory: ' + FDirImage);
              lgm('GetLastError: ' + inttostr(osError) + ' - ' + SysErrorMessage(Getlasterror));
              end;
         end;

      If Not Directoryexists(FDirCache) Then
         begin
         {$I-}
         Forcedirectories(FDirCache);
         {$I+}
         oserror := GetLastError;
         if ((oserror <> 0)  and (Not Directoryexists(FDirCache)))  then
              begin
              lgm('FAILED to Create Directory: ' + FDirCache);
              lgm('GetLastError: ' + inttostr(osError) + ' - ' + SysErrorMessage(Getlasterror));
              end;
         end;

      If Not Directoryexists(FDirImport) Then
         begin
         {$I-}
         Forcedirectories(FDirImport);
         {$I+}
         oserror := GetLastError;
         if ((oserror <> 0)  and (Not Directoryexists(FDirImport)))  then
              begin
              lgm('FAILED to Create Directory: ' + FDirImport);
              lgm('GetLastError: ' + inttostr(osError) + ' - ' + SysErrorMessage(Getlasterror));
              end;
         end;
    Except
      on e:exception do
      begin
      Rmsg := 'EXCEPTION:  creating IAPIDirectories: ';
      lgm(rmsg);
      lgm('msg: ' + e.Message);
      Result := False;
      exit;
      end;
    End;
   if (( Not Directoryexists(FDirTemp)) or (Not Directoryexists(FDirImage))
        or ( Not Directoryexists(FDirCache))  or ( Not Directoryexists(FDirImport)))
        then
        begin
          rmsg := 'Error: Function SetIAPIDirectories';
          lgm(rmsg);
          lgm('one or more IAPI directores was not Created.');
          result := false;
        end;

  except
  on E:exception do
    begin
    result := false;
    rmsg := 'EXCEPTION : Function SetIAPIDirectories.';
    lgm(rmsg);
    lgm('msg: ' + e.Message);

    end;
  end;
End;


procedure TMagImport.WaterMarkConvertToGray;
begin
  MagIGManager.IGProcessingCtrl.ConvertToGray(vIGPage1); //

end;


procedure TMagImport.WaterMarkResizeRescind;
var h,w : integer;
ioloc : IIGiolocation;
begin


//   ioloc := IGFormatsCtl1.CreateObject(IG_FORMATS_OBJ_IOFILE) As IIGIOLocation;
//        (ioloc As IGIOFile).FileName :=  image;//   dialogLoadOptions.FileName;
//  IGFormatsCtl1.GetPageCount(FglioLocation,IG_FORMAT_UNKNOWN);

  h := vIGPage1.ImageHeight;
  w := vIGPage1.ImageWidth;


MagIGManager.IGProcessingCtrl.ResizeImage(vIGPage2, w,h,IG_INTERPOLATION_GRAYSCALE);

end;


procedure TMagImport.CreateNewlog;
begin
  FLogList.clear
  //FLogList.add(FormatDateTime('hh:mm ', now) + 'Start Session.');
end;


procedure TMagImport.lgm(s: String);
var afile : TextFile;
ct : string;
begin
  FLogList.Add(s);
  If FDebugON Then
    if FDebugToFileON then
        begin
        ct := formatdatetime('hh:nn:ss ',now);
        assignfile(aFile, FDebugToFileName);
        append(aFile);
        writeln(afile, ct + Findent + s);
        closefile(afile);
        end;
end;


function TMagImport.RPPatientHasPhoto(DFN: String; var Stat: Boolean; var FMsg: String): String;
begin
  Result := FDBBroker.RPPatientHasPhoto(DFN, Stat, FMsg);
end;

procedure TMagImport.lgl(t: Tstringlist);
var
  I: integer;
begin
  for I := 0 to t.Count - 1 do
  begin
    lgm(t[I])
  end;
end;


procedure TMagImport.lgl(t: Tstrings);
var
  I: integer;
begin
  for I := 0 to t.Count - 1 do
  begin
    lgm(t[I])
  end;
end;


function TMagImport.ImageArrayToFields(var xmsg: String; imgarray: Tstringlist) :
boolean;
var
  I: integer;
  fld,
  data: string;
// TEMPORARILY WE WILL PUT THE Acqs;Acql TOGETHER TO FORM ACQS
begin
  ClearProperties;
  Result := true;
  xmsg := '1^Image Array to Component fields. OK.';
  for I := 0 to imgarray.Count - 1 do
  begin
    try
      fld := FMagUtils.magpiece(imgarray[I], '^', 1);
      data := copy(imgarray[I], pos('^', imgarray[I]) + 1, 999);
      //data := FMagUtils.magpiece(imgarray[i], '^', 2);
      //if (FMagUtils.magpiece(imgarray[i], '^', 3) <> '') then data := data + '^' + FMagUtils.magpiece(imgarray[i], '^', 3);
      if fld='IMAGE' then
      begin
        FImages.Add(data)
      end;
      if fld='101' then
      begin
        SetAcqLoc(data)
      end;
      //ACQL
      if fld='.05' then
      begin
        SetAcqSite(data)
      end;
      //ACQS
      if fld='5' then
      begin
        SetDFN(data)
      end;
      if fld='16' then
      begin
        SetProcPKG(data)
      end;
      if fld='17' then
      begin
        SetProcIEN(data)
      end;
      if fld='15' then
      begin
        SetProcDt(data)
      end;
      if fld='108' then
      begin
        SetTrkNum(data)
      end;
      if fld='ACQD' then
      begin
        SetAcqDev(data)
      end;
      if fld='107' then
      begin
        SetAcqDev(data)
      end;
      if fld='ACQL' then
      begin
        SetAcqLoc(data)
      end;
      if fld='101' then
      begin
        SetAcqLoc(data)
      end;
      if fld='ACQS' then
      begin
        SetAcqSite(data)
      end;
      if fld='.05' then
      begin
        SetAcqSite(data)
      end;
      if fld='STATUSCB' then
      begin
        SetExcpHandler(data)
      end;
      { The next fields are NOT Required}
      if fld='ITYPE' then
      begin
        SetImgType(data)
      end;
      (*if (FImgType <> '')
    then
      begin
       // t.add(ResolveImageType);
      end;
    { TODO -ogarrett -cFields : create Function ResloveImageType }
    *)
      if fld='CALLMTH' then
      begin
        SetMethod(data)
      end;
      if fld='8' then
      begin
        SetCapBy(data)
      end;
      if fld='USERNAME' then
      begin
        SetUsername(data)
      end;
      if fld='PASSWORD' then
      begin
        SetPassword(data)
      end;
      if fld='10' then
      begin
        SetGroupDesc(data)
      end;
      if fld='DELFLAG' then
      begin
        SetDeleteFlag(magstrtobool(data))
      end;
      if fld='TRNSTYP' then
      begin
        SetTransType(data)
      end;
      if fld='100' then
      begin
        SetDOCCTG(data)
      end;
      if fld='110' then
      begin
        SetDocDt(data)
      end;
      { This is end of Fields that are sent as parameters }
      // FProcType
      // FProcDesc
      if fld='7' then
      begin
        SetCapDt(data)
      end;
      if fld='IEN' then
      begin
        SetGroupIEN(data)
      end;
      if fld='42' then
      begin
        SetIndexType(data)
      end;
      if fld='43' then
      begin
        SetIndexProc(data)
      end;
      if fld='44' then
      begin
        SetIndexSpec(data)
      end;
      if fld='45' then
      begin
        SetIndexOrigin(data)
      end

    { TODO : Have to account for ANY Image Field NUMBER.  here }
    // FGroupLongDesc not validated, it is sent as is ( if it exists)
    except
      on E : Exception do
        begin
          lgm(E.Message);
          xmsg := '0^Invalid Data.';
          Result := FALSE
        end;
    end;
  end;
  { DONE : ACQSite used to be Site;HospLOC, we now have two fields. ACQS and ACQL }
end;


procedure TMagImport.SetDFN(const Value: String);
begin
  FDFN := Value
end;


procedure TMagImport.SetImages(const Value: Tstrings);
var
  I: integer;
begin
  for I := 0 to Value.Count - 1 do
  begin
    if Value[I]='' then
    begin
      continue
    end;
    if Value[I]=' ' then
    begin
      continue
    end;
  end;
  FImages.assign(Value)
end;


procedure TMagImport.SetProcPKG(const Value: String);
begin
  FProcPKG := Value;
end;


procedure TMagImport.SetProcIEN(const Value: String);
begin
  FProcIEN := Value;
end;


procedure TMagImport.SetProcNew(const Value: String);
begin
  FProcNew := Value;
end;

procedure TMagImport.SetProcDt(const Value: String);
begin
  FProcDt := Value;
end;


procedure TMagImport.SetTrkNum(const Value: String);
begin
  if not DelimitedParam(Value) then
  begin
    raise EInvalidData.Create('Invalid format for Tracking ID: ' + Value)
  end;
  FTrkNum := Value
end;


procedure TMagImport.SetAcqDev(const Value: String);
begin
  FAcqDev := Value
end;


procedure TMagImport.SetAcqSite(const Value: String);
begin
  FAcqSite := Value
end;


procedure TMagImport.SetExcpHandler(const Value: String);
begin
  FExcpHandler := Value
end;


{ the Above are documented as required in the "M" API Call' }
procedure TMagImport.SetImgType(const Value: String);
begin
  FImgType := Value
end;


procedure TMagImport.SetMethod(const Value: String);
begin
  FMethod := Value
end;


procedure TMagImport.SetCapBy(const Value: String);
begin
  if ((Value<>'') and (not ValidInteger(Value))) then
  begin
    raise EInvalidData.Create('Invalid format for DUZ: ' + Value)
  end;
  FCapBy := Value
end;


procedure TMagImport.SetGroupDesc(const Value: String);
begin
  FGroupDesc := Value
end;


procedure TMagImport.SetDeleteFlag(const Value: boolean);
begin
  FDeleteFlag := Value
end;


procedure TMagImport.SetTransType(const Value: String);
begin
  { Possible values are  NEW.   Later we may implement MOD or DEL{}
  FTransType := Value
end;


{ The fields below aren't in the Parameters passed .. Yet}
procedure TMagImport.SetProcTIUSignatureType(const Value: String);
begin
  FProcTIUSignatureType := Value;
end;

procedure TMagImport.SetProcTIUText(const Value: TStrings);
begin
  FProcTIUText.Assign(Value);
end;

procedure TMagImport.SetProcTIUTitle(const Value: String);
begin
  FProcTIUTitle := Value;
end;

procedure TMagImport.SetProcType(const Value: String);
begin
  FProcType := Value
end;


procedure TMagImport.SetProcDesc(const Value: String);
begin
  FProcDesc := Value
end;


procedure TMagImport.SetCapDt(const Value: String);
begin
  FCapDt := Value
end;


procedure TMagImport.SetGroupIEN(const Value: String);
begin
  FGroupIEN := Value
end;


procedure TMagImport.SetGroupLongDesc(const Value: Tstrings);
begin
  FGroupLongDesc.assign(Value)
end;


procedure TMagImport.SetBroker(const Value: TRPCBroker);
begin
  FBroker := Value
end;


function TMagImport.GetDeleteFlag : boolean;
begin
  Result := FDeleteFlag
end;


function TMagImport.GetTransType : String;
begin
  Result := FTransType
end;


function TMagImport.GetGroupIEN : String;
begin
  Result := FGroupIEN
end;


function TMagImport.GetAcqDev : String;
begin
  Result := FAcqDev
end;


function TMagImport.GetAcqSite : String;
begin
  Result := FAcqSite
end;


function TMagImport.GetBroker : TRPCBroker;
begin
  Result := FBroker
end;


function TMagImport.GetCapBy : String;
begin
  Result := FCapBy
end;


function TMagImport.GetCapDt : String;
begin
  Result := FCapDt
end;


function TMagImport.GetDFN : String;
begin
  Result := FDFN
end;


function TMagImport.GetImages : Tstrings;
begin
  Result := FImages
end;


function TMagImport.GetImgType : String;
begin
  Result := FImgType
end;


function TMagImport.GetMethod : String;
begin
  Result := FMethod
end;




function TMagImport.GetProcDesc : String;
begin
  Result := FProcDesc
end;


function TMagImport.GetProcDt : String;
begin
  Result := FProcDt
end;


function TMagImport.GetProcPKG : String;
begin
  Result := FProcPKG
end;


function TMagImport.GetProcIEN : String;
begin
  Result := FProcIEN
end;


function TMagImport.GetProcNew: String;
begin
  Result := FProcNew;
end;

//function TMagImport.GetProcTIUSignature: String;
//begin
//  Result := FProcTIUSignature;
//end;

function TMagImport.GetProcTIUSignatureType: String;
begin
  Result := FProcTIUSignatureType;
end;

function TMagImport.GetProcTIUText: TStrings;
begin
  Result := FProcTIUText;
end;

function TMagImport.GetProcTIUTitle: String;
begin
  Result := FProcTIUTitle;
end;

function TMagImport.GetProcType : String;
begin
  Result := FProcType;
end;


function TMagImport.GetTrkNum : String;
begin
  Result := FTrkNum
end;


function TMagImport.GetExcpHandler : String;
begin
  Result := FExcpHandler
end;


function TMagImport.GetGroupDesc : String;
begin
  Result := FGroupDesc
end;


function TMagImport.GetGroupLongDesc : Tstrings;
begin
  Result := FGroupLongDesc
end;


function TMagImport.GetMag4Security : TMag4Security;
begin
  Result := FMagSecurity
end;


procedure TMagImport.SetMag4Security(const Value: TMag4Security);
begin
  FMagSecurity := Value
end;


function TMagImport.CopyImageToServer(var xmsg: String; imageID, imagefile: String) : boolean;
var
  nFullName,
  oFullName: string;
begin
  try
  try
    lgdm('5- << ENTER - CopyImageToServer>>');
    indentinc;
    lgdm('5-     imageID='+imageID);
    lgdm('5-     imagefile=' + imagefile);
    nFullName := FMagUtils.magpiece(imageID, '^', 2) + FMagUtils.magpiece(imageID, '^', 3);
    oFullName := imagefile;

    //fUnStrings.Add(Inttostr(Funstrings.count)); // force error
    Result := CopyTheFile(xmsg, oFullName, nFullName)

  except
  on E:Exception do
   begin
   Result := false;
   xmsg := '0^EXCEPTION: CopyImageToServer';
   lgm(xmsg);
   lgm('msg: ' + e.message);
   end;
  end;
  finally
    indentdec;
    lgdm('5- << EXIT - CopyImageToServer >>');
  end;
end;


function TMagImport.CopyTheFile(var xmsg: String; FromFile, ToFile: String; MakeTXT : boolean = true) : boolean;
var
  ndir: string;
  tmpUser,
  tmpPass,
  zmsg,
  textmsg: string;
  displayUser, displayPass : string;
  osError : integer;
  osErrMsg : String;
  osCopyOK : boolean;
  magfilesize : longint;
  imagename : string;
begin
 try
 indentinc;
  lgdm('5a- << ENTER - function CopyTheFile>>');
  tmpUser := '';
  tmpPass := '';
  xmsg := 'Start Copying File...';
  Result := FALSE;
  { Here we copy the File to the Image Write Directory ( Image Network Server )}
  try

    { Quit if we can't connect to the Image Network Server }
    if ((FUsername<>'') and (FPassword<>'')) then
    begin
      try
       tmpUser := FUsername   ;
       tmpPass := decrypt(FPassword);      //p121 VLER gek uncomment this line.
       lgdm('5a-  Fusername: ' + Fusername + ' FPassword: ' + Fpassword);
      except
        on E : Exception do
          begin
            lgdm('5a-  Error Decrypting Password : ' + FPassword);
            xmsg := '-1^Error: Invalid Password.';
            FMagSecurity.MagCloseSecurity(zmsg);
            exit
          end;
      end;
    end;
    { TODO : Passed Username and Password is for FROM directory }
  displayUser := tmpuser; displayPass := tmpPass;
  if tmpuser = '' then displayUser := '<null>';
  if tmpPass = '' then displayPass := '<null>';

    lgdm('5a- Attempting OpenSecurePath: FromFile='+FromFile);
    lgdm('5a- tmpUser='+DisplayUser + '   tmpPass='+DisplayPass);
    if not FMagSecurity.MagOpenSecurePath(FromFile, xmsg, tmpUser, tmpPass) then
    begin
      lgdm('5a- Attempt OpenSecurePath - FAILED. '+ xmsg);
      Floglist.AddStrings(FMagSecurity.msglist);
      exit
    end;
    lgdm('5a- Attempt OpenSecurePath.    Success. ');
    lgdm('5a- FlogList from MagSecurity');
    lgdm(Fmagsecurity.Msglist);
    Floglist.AddStrings(FMagSecurity.msglist);
    { DONE : Test if File Exists : }
    if not FileExists(FromFile) then
    begin
      lgdm('5a- File doesn''t exist : FromFile:  '+ FromFile);
      xmsg := 'File doesn''t exist : ' + FromFile;
      exit
    end;
    magfilesize := (fmxutils.GetFileSize(FromFile));
    if magfilesize < 1 then
            begin
            lgdm('5a- File Size 0: ' + FromFile);
            xmsg := '0^File Size 0: ' + FromFile;
            exit
            end;
    try
    lgdm('5a- Attempting OpenSecurePath: ToFile='+ToFile);
    lgdm('5a- tmpUser = null    tmpPass = null.');
    if not FMagSecurity.MagOpenSecurePath(ToFile, xmsg, '', '', true) then
    begin

    lgdm('5a- Attempt  OpenSecurePath: FAILED: ' + xmsg);
    {p135  This FLogList was commented out.  135 Uncommented it}
    FLogList.AddStrings(FMagSecurity.msglist); {p135 more detail to result array}
      result := false;
      exit
    end;
    except
    on E:exception do
      begin
        result := false;
        xmsg := '0^EXCEPTION:  during Open Network Connection';
        lgm(xmsg);
        lgm('msg: ' + e.message);
      end;
    end;
    { Quit if we need to create the directory, but can't.
                             ( mainly for Hashed Directories )}
    if not DIRECTORYEXISTS(ExtractFileDir(ToFile)) then
    begin
      ndir := ExtractFileDir(ToFile);
{HERE : use getlasterror....}
      forcedirectories(ndir);
      if not DIRECTORYEXISTS(ndir) then
      begin
        lgdm('5a- Create Directory: FAILED - ' + ndir);
        xmsg := '0^Can''t create directory: ' + ExtractFileDir(ToFile);
        {HERE return getlasterror code and text to FLogList}
        exit
      end;
        lgdm('5a- Create Directory: Success -  ' + ndir);
    end;
    try
        lgdm('5a- Attempting to "CopyFile" :  fromFile: ' + FromFile);
        lgdm('5a- Attempting to "CopyFile" :    ToFile: ' + ToFile);
      // THIS Is the windows Call :
      {$I-}
      osCopyOK := Copyfile(pchar(FromFile), pchar(ToFile), true);
      {$I+}
      osError := GetLastError;
      if osError <> 0 then lgdm('cp-2 GetLastError = ' + inttostr(osError));
      if osCopyOK then
       begin
        lgdm('5a- Attempting to "CopyFile" :   SUCCESS');
        Result := true;
        // CPMOD  make the text file.
       lgdm('5a- CreateAndSaveImageTextFile');
       if MakeTXT then  CreateAndSaveImageTextFile(ToFile, textmsg); // etrap ok
       end
       else
       begin
         osErrMsg := SysErrorMessage(OSError);
        lgdm('5a- Attempt to "CopyFile" :  FAILED ');
        lgdm('5a- GetLastError: ' + inttostr(osError) + ' - ' + SysErrorMessage(Getlasterror));
        Result := FALSE;
        xmsg := '0^FAILED to Copy File: ' + FromFile + ' to: ' + ToFile ;
        lgm('GetLastError: ' + inttostr(osError));
        lgm('SysErrorMessage: ' + osErrmsg);
       end;
      { TODO : Test for existance and Size > 0 }
 if Result then
   begin
        magfilesize := (fmxutils.GetFileSize(ToFile));
        if magfilesize < 1  then
          begin
           result := false;
           lgm('Error:  FileSize 0 after copy: ' + ToFile);
           lgdm('5a- Attempt to "CopyFile" :  FAILED ');
           lgdm('5a- ' + ' Error:  FileSize 0 after copy: ' + ToFile);
           xmsg := '0^Error: After copy -  FileSize 0 : ' + FromFile + ' to: ' + ToFile ;
          end;
   end;


      FMagSecurity.MagCloseSecurity(zmsg)

    except
      on E : Exception do
        begin
          xmsg := '0^Exception CopyFile: ' + E.Message;
          FMagSecurity.MagCloseSecurity(zmsg)
        end;
    end;
  lgdm('5a- Logging MagSecurity log:');
  lgdm(Fmagsecurity.Msglist); // in for debug

  except
   on E: exception do
    begin
      xmsg := '0^Exception -  during CopyTheFile function';
      lgm(e.message);
    end;
  end;
 finally
  lgdm('5a - << EXIT - function CopyTheFile >>');
   indentdec;
 end;
end;


procedure TMagImport.FileSpecialtyPointers(imageID: String);
var
  magien: string;
begin
lgdm('<< ENTER - FileSpecialtyPointers >>');
  { Were only doing TIU documents for now, so this code will have to be
     modified later to enable importing images via this API to other packages.{}
  magien := FMagUtils.magpiece(imageID, '^', 1);
  if (UPPERCASE(FProcPKG)='TIU')
      or
     (FProcPKG='8925') then
  begin
    if (FProcIEN='') then
    begin
      lgdm('FileSpecPointers:  Procedure IEN is Null.');
      exit
    end;
    {Flist[0] is in '0^...' format}
    lgdm('magien: ' + magien + ' PKG: ' + FProcPKG + '  DA: ' +FProcIEN);
    FDBBroker.RPMag3TIUImage(Fstat, Flist, magien, FProcIEN);
    if not Fstat then
    begin
    lgdm('FileSpecialtyPointers Failed');
      lgm('FileSpecialtyPointers Failed');
      lgm('ImageIEN: ' + magien + 'TIU DA: ' + FProcIEN);
      lgl(Flist);
    end
    else
      begin
       lgdm('FileSpecialtyPointers OK.');
       lgdm('Image IEN: '+magien+ 'Procedure IEN: '+ Fprocien);
     end;
  end;
lgdm('<< EXIT - FileSpecialtyPointers >>');
end;


{ VistAInit assures we can connect, and get UserName password from Site.{}
procedure TMagImport.IndexEventList(var slEvent: TStringList;
                                    ClassChoice: String = '';
                                    SpecChoice: String = '';
                                    ignoreStatus: Boolean = False;
                                    incClass : Boolean = False;
                                    incStatus : Boolean = False);
begin
  slEvent.Clear;
  FDBBroker.RPIndexGetEvent(slEvent, ClassChoice, SpecChoice,
                            ignoreStatus, incClass, incStatus);
end;

procedure TMagImport.IndexOriginList(var slOrigin: TStringList);
begin
  slOrigin.Clear;
  FDBBroker.RPIndexGetOrigin(slOrigin);
end;

procedure TMagImport.IndexSpecSubSpecList(var slSubSpec: TStringList;
                                          ClassChoice: String = '';
                                          ProcsChoice: String = '';
                                          ignoreStatus: Boolean = False;
                                          incClass: Boolean = False;
                                          incStatus: Boolean = False;
                                          incSpec: Boolean = False);
begin
  slSubSpec.Clear;
  FDBBroker.RPIndexGetSpecSubSpec(slSubSpec, ClassChoice, ProcsChoice,
                                  ignoreStatus, incClass, incStatus, incSpec);
end;

procedure TMagImport.IndexTypeList(var slType: TStringList;
                                   ClassChoice: String = '';
                                   IgnoreStatus: Boolean = False;
                                   incClass: Boolean = False;
                                   incStatus: Boolean = False);
begin
  slType.Clear;
  FDBBroker.RPIndexGetType(slType, ClassChoice, IgnoreStatus, incClass, incStatus);
end;

procedure TMagImport.InitIfNeeded;
var  toInt : integer;
 toStr : string;
 ini : Tinifile;
 initsneeded : string;
 imsg : string;
begin
try
indentinc;
initsneeded := '';
  try
  lgdm('2b- << ENTER - InitIfNeeded>>');

  if not assigned(FBroker) then
  begin
    FBroker := TRPCBroker.Create(Self) ;
    FBroker.OnPulseError := IAPIOnPulseError;
    initsneeded := initsneeded + ', FBroker';
  end;

  if not assigned(FDBBroker) then
  begin
    FDBBroker := TMagDBMVista.Create();
    FDBBroker.SetBroker(FBroker);
    initsneeded := initsneeded + ', DBBroker';
  end;

  if not assigned(FMagSecurity) then
  begin
    FMagSecurity := TMag4Security.Create(Self);
        initsneeded := initsneeded + ', FMagSecurity';
  end;

  finally
  if (initsneeded <> '')  then
    begin
    lgdm('2b- Components Initialized : ' + initsneeded);
    end;

  lgdm('2b- << EXIT - InitIfNeeded >>');
  indentdec;
  end;
except
 on e:exception do
   begin
     imsg := 'EXCEPTION: Function InitIfNeeded';
     lgdm('2b- ' + imsg);
     lgdm('msg: ' + e.Message);
     lgm(imsg);
     lgm('msg: ' + e.message);
   end;
end;
end;


procedure TMagImport.ConnectIfNeeded(var vserver: String; var vport: String;
                                     accesscode: String = '';
                                     verifycode: String = '';
                                     division : string = '');
var
connectparams : string;
Connectmsg : string;
begin
try
  indentinc;
  try
  lgdm('2a- << ENTER ConnectIfNeeded >>');
  InitIfNeeded;
  if FSALastLogon then
  begin
    lgdm('2a- Using PRIOR login values. ');
    vserver := FSAvserver ;
    vport := FSAvport ;
    accesscode := FSAaccesscode ;
    verifycode := FSAverifycode ;
    division := FSAdivision ;
    lgdm('2a- ' + vserver + ' ' + vport + ' ' + halfdisplay(accesscode) + ' ' + halfdisplay(verifycode) + ' ' + division);
  end;
        connectparams := 'IAPI login values:' +#13
              + 'vserver: ' + vserver + #13
              + 'vport: ' + vport + #13
              + 'accesscode: ' + halfdisplay(accesscode) + #13
              + 'verifycode: ' + halfdisplay(verifycode) + #13
              + 'division: ' + division ;

  if not FDBBroker.IsConnected then
  begin
  lgdm('2a- VistA Connection is needed...');
    if (vserver='') or (vport='') then
      begin
        lgm('Prompting for Server, Port.');
        FDBBroker.DBSelect(vserver, vport, 'MAG WINDOWS')
      end
      else
      begin
      if FDebugON then  {... for now if Debug On,  we Prompt.  it's not built to run continuously}
        begin
          messagedlg(connectparams,mtconfirmation,[mbok],0);
        end;
      {  the old DBConnect function didn't return result.  it wasn't needed.
          but now, for the silent connect  we need a result returned.
          so we created a DBConnect2 }
      // FDBBroker.DBConnect(vserver, vport, 'MAG WINDOWS', accesscode, verifycode,division) ;
      lgdm('2a- Attempting DBConnect2 to VistA... ' );
      lgm('Attempting DBConnect2 to VistA ' );
      lgm('Login Params : ' + vserver + ' ' + vport + ' ' + halfdisplay(accesscode) + ' ' + halfdisplay(verifycode) + ' ' + division);
      {we are in function ConnectIfNeeded. This is Only place DBConnect2 is called.}
      DBConnect2(connectMsg,vserver, vport, 'MAG WINDOWS', accesscode, verifycode,division) ;
      if FDBBroker.IsConnected then
        begin
            lgdm('2a- DBConnect2 Successful. Saving login values for AutoLogin');
            lgdm('2a- Result= ' + connectMsg);
            lgm('DBConnect2 Successful: ' + connectMsg);
            FSAvserver := vserver;
            FSAvport := vport;
            FSAaccesscode := accesscode;
            FSAverifycode := verifycode;
            FSAdivision := division;
            FSALastLogon := true;
         end
         else
         begin
           lgdm('2a- DBConnect2 FAILURE');
           lgdm('2a- Result : ' + connectMsg);
           lgm('Connection FAILED : ' + connectmsg);
         end;
      end;
  end
  else
  begin
    lgm('Vista Connection Exists. Not AutoConnecting');
  end;

  except
   on e:exception do
     begin
       lgdm('EXCEPTION:  msg: ' + e.Message);
       lgm('EXCEPTION: Funtion ConnectIfNeeded.');
       lgm('msg: ' + e.Message);
     end;

  end;
finally
  lgdm('2a- << EXIT - ConnectIfNeeded >>');
  indentdec;
end;
end;

{ Procedure VistAInit :
    Called from External App (BP, others..)  the boolean : Status and String : xmsg are returned to the
    calling App.
    Called Internally, we will populate the FLogList with more details of the procedure.
    Called with Debug On, Externally or Internally, the Debug messages will be added to LogList,
    and if called exteranlly, the debug messages can be seen in the DOS File Log. if SaveDOSFile = True.
}
procedure TMagImport.VistAInit(var rstat: boolean;
                               var xmsg: String;
                               var vserver: String;
                               var vport: String;
                               accesscode: String = '';
                               verifycode: String = '';
                               division: String = '');
var
  DUZ,
  Username: string;
  rlist: TStrings;
  forceError : tstrings;
  forceerrorstring : string;
  rmsg: string;
  dbgmsg : string;

begin   { VistAInit }
try
  IndentInc;
  try
  lgdm('2- << ENTER - VistaInit >>');

  rstat := False;
  rlist := TStringlist.Create;
  xmsg := '';


  try
    {ConnectIfNeeded is a Private procedure.  This is only place normally called.
      But is also called in the StayAlive Function that will attempt silent AutoReconnect }
    ConnectIfNeeded(vserver, vport, accesscode, verifycode,division);  {from VistAInit}

    if not FDBBroker.IsConnected then
    begin
      xmsg := '0^No Connection to VISTA.';
              lgdm('2- ' + xmsg);
              lgm(xmsg);
              lgm('Input Values : Server=' +vserver + ' Port=' + vport );
              lgm('               Access=' + halfdisplay(accesscode) + ' Verify=' + halfdisplay(verifycode) + ' Division=' + division);
      Exit;
    end;

    FDBBroker.RPMaggUser2(Fstat, rmsg, rlist, 'Import API');
    if not Fstat then
    begin
      lgdm('2- RPMaggUser2 FAILED : ' + rlist[0]) ;
      xmsg := rlist[0];
      lgdm(rlist);
      Exit;
    end;

    DUZ := FMagUtils.magpiece(rlist[1], '^', 1);

    if not SetNetUsernamePassword(FMagUtils.magpiece(rlist[2],'^',1),
                                  FMagUtils.magpiece(rlist[2],'^',2),
                                  FMagSecurity,
                                  xmsg) then
    begin
      Exit;
    end;

    (*MagFileSecurity.Username := magpiece(xBrokerx.RESULTS[2],'^',1);
   MagFileSecurity.Password := decrypt(magpiece(xBrokerx.RESULTS[2],'^',2));*)
    if DUZ = '0' then
    begin
      xmsg := FMagUtils.magpiece(rlist[1], '^', 2) + ' Disconnecting from VistA';
      FBroker.Connected := False;
    end
    else
    begin
      rstat := True;
      Username := FMagUtils.magpiece(rlist[1], '^', 2);
      xmsg := Username + ': ' + vserver + ' connection OK. ';
      FCaptureKeys.Clear
    end;

  finally
    rlist.Free;
  end;

  finally
    lgdm('2- << EXIT - VistaInit >>');
    indentdec;
  end;
except
  on e:exception do
    begin
      lgm('EXCEPTION: Function VistaInit');
      lgm('msg: ' + e.Message);
    end;

end;
end;








{/p121}
function TMagImport.GetNetSecurityOn: boolean;
begin
try
//FmagSecurityNOTCreated   will force an error
if FDebugON then
  begin
  //  result := FMagSecurityNOTCreated.SecurityOn;
  //  exit;
  end;

 result := false;
 if assigned(self.MagSecurity) then
   if self.MagSecurity <> nil then
      result := self.FMagSecurity.SecurityOn;
except
 on e:exception do
   begin
   lgm('EXCEPTION : GetNetSecurity ');
   lgm('msg: '  + e.Message);
   result := false
   end;
end;
end;

 {/p121}
procedure TMagImport.SetNetSecurityOn(const Value: boolean);
begin
try
  // FmagSecurityNOTCreated will force error.     (if lines are uncommented.
if FDebugON then
   begin
   // FMagSecurityNOTCreated.SecurityOn := value;
   end;
   if assigned(self.MagSecurity) then
   if self.MagSecurity <> nil then self.MagSecurity.SecurityOn := value;
except
   // testing////

  on e:exception do
   begin
   lgm('EXCEPTION: SetNetSecurity' );
   lgm('msg: ' + e.message);
   lgm('setting SecurityON to : ' + magbooltostr(value));
   end;
end;
end;

function TMagImport.SetNetUsernamePassword(user, pass: String; var MagSec:
              TMag4Security; var xmsg: String) : boolean;
begin

  Result := FALSE;
  if (user='')
      or
     (pass='') then
  begin
    xmsg := '0^Invalid Imaging Network Username or Password.';
    lgm('Function : SetNetUserNamePassword' ) ;
    lgm(xmsg);
    lgm('Username: ' + user + '  Password: ' + '******');

  end
  else
  begin
    try
      MagSec.Username := user;
      MagSec.Password := decrypt(pass);
      Result := true
    except
      on E : Exception do
        begin
          xmsg := '0^EXCEPTION: attempting password decryption.'  ;
          lgm('Function : SetNetUserNamePassword' ) ;
          lgm(xmsg);
          lgm('Username: ' + user + '  Password: ' + '******');
        end;
    end;
  end;
end;

{p135t7  add NoImage Flag for non existant image fix }
procedure TMagImport.DeleteImageEntry(var xmsg: String; ien: String; NoImage : string = '');
var
  s: string;
  rmsg: string;
  rlist: Tstrings;
  ienstr : string;  //p135t7
begin
lgdm('<< ENTER - DeleteImageEntry >>');
lgdm('input IEN: ' + ien);
 try     {try-1}
   rlist := Tstringlist.Create;
   try  {try-2}
     s := '';
     if (ien='') then
     begin
       exit
     end;
     s := '';
     ienstr := Ien + '^' + '1'; { the '1' says to force delete, don't test for MAG DELETE KEY }    //135t7 mimic Capture App
     if UPPERCASE(NoImage) = 'NOIMAGE'  then ienstr := ienstr + '^' + 'NOIMAGE';  // 135t7  mimic Capture App
     {135T7 took out the force deleted '1'.  the ienstr now has ien^1^NOIMAGE}
     FDBBroker.RPMaggImageDelete(Fstat, rmsg, rlist, ienstr,'');
     xmsg := rlist[0];
     lgdm('RPC MaggImageDelete Status: ' + magbooltostr(fstat));
     lgdm(rlist);
     if not Fstat then
     begin
       lgl(rlist)
     end

   finally   {try- 2}
    rlist.Free
  end;
 except    {try-1}
  on e:exception do
    begin
       xmsg := '0^EXCEPTION : DeleteImageEntry';
       lgm(xmsg);
       lgm('msg: ' + e.Message);
    end;

 end;
lgdm('<< EXIT - DeleteImageEntry >>');
 end;


function TMagImport.GetDBBroker : TMagDBBroker;
begin
  Result := FDBBroker
end;


procedure TMagImport.SetDBBroker(const Value: TMagDBBroker);
begin
  FDBBroker := Value
end;


function TMagImport.GetAcqLoc : String;
begin
  Result := FAcqLoc
end;


function TMagImport.GetDOCCTG : String;
begin
  Result := FDOCCTG
end;


function TMagImport.GetDocDt : String;
begin
  Result := FDocDT
end;


function TMagImport.GetPassword : String;
begin
  Result := FPassword
end;


function TMagImport.GetUsername : String;
begin
  Result := FUsername
end;


procedure TMagImport.SetAcqLoc(const Value: String);
begin
  FAcqLoc := Value
end;


procedure TMagImport.SetDOCCTG(const Value: String);
begin
  FDOCCTG := Value
end;


procedure TMagImport.SetDocDt(const Value: String);
begin
  FDocDT := Value
end;


procedure TMagImport.SetPassword(const Value: String);
begin
  FPassword := Value
end;


procedure TMagImport.SetUsername(const Value: String);
begin
  FUsername := Value
end;


function TMagImport.CreateAndSaveImageTextFile(imageToFile: String; var xmsg: String) : boolean;
var
  imageTextfile: string;
  t,
  t1: Tstringlist;
  stat: boolean;
  patinfo: string;
begin
  Result := FALSE;
  xmsg := 'Attempting to save .txt file...';
  t := Tstringlist.Create;
  t1 := Tstringlist.Create;
  try
 {/p121 gek : fix future problem where multiple "."s in file name,  use ChangeExt function}
//    imageTextfile := FMagUtils.magpiece(imageToFile, '.', 1) + '.txt';
    imageTextfile := ChangeFileExt(imageToFile,'.txt');
    t.Add('$$BEGIN IMAGE DATA');
    t.Add('TRANSACTION_ID=' + FTrkNum);

    FDBBroker.RPMagPatInfo(stat, patinfo, FDFN);
    t.Add('PATIENTS_NAME=' + FMagUtils.magpiece(patinfo, '^',
                  3));
    //Pt Name );
    t.Add('PATIENTS_ID=' + FMagUtils.magpiece(patinfo, '^', 6));
    //Pt SSN );
    t.Add('PATIENTS_BIRTH_DATE=' + FMagUtils.magpiece(patinfo,
                    '^', 5));
    //Pt DOB );
    t.Add('PATIENTS_SEX=' + FMagUtils.magpiece(patinfo, '^',
                  4));
    // PT SEX );
    t.Add('IMAGE_DATE=' + CapDt);
    t.Add('CAPTURED BY=' + CapBy);
    t.Add('ACQ_DEVICE=' + FAcqDev);
    // t.Add('SHORT DESCRIPTION=' + (FMagUtils.magpiece(FMagUtils.magpiece(imageID,'|',2),'^',2)));    (*
    (*if imagelongdesc.lines.count > 0 then
    begin
      t.add('LONG DESCRIPTION');
      for i := 0 to imagelongdesc.lines.count - 1 do
      begin
        t.Add(imagelongdesc.lines[i]);
      end;
    end;   *)
    t.Add('$$END IMAGE DATA');
    try
      t.SaveToFile(imageTextfile);
      xmsg := 'Notes saved to .txt file: ' + imageTextfile;
      Result := true
    except
      xmsg := 'Failed to copy .txt File to Imaging Network';
      {135 GetLastError needed here.}
      exit
    end;

  finally
    t.Free;
    t1.Free
  end;
end;


procedure TMagImport.SaveDirect(var status: boolean; var xmsglist: Tstrings);
var
  xmsg: string;
  vserver,
  vport: string;
  t: Tstringlist;
  relist: Tstringlist;
  stat: boolean;
begin
  //Maglogger.Log(Trace, 'Entered TMagImport.SaveDirect');

  VistAInit(stat, xmsg, vserver, vport);
  if not stat then
  begin
    status := stat;
    xmsglist.insert(0, xmsg);
    exit
  end;
  //  ConnectIfNeeded(vserver ,vport );
  if not FBroker.Connected then
  begin
    status := FALSE;
    xmsglist.insert(0, 'No Connection to VISTA');
    exit
  end;
  t := Tstringlist.Create;
  try
    relist := Tstringlist.Create;
    FLogList.clear;
    ImageArrayFromFields(t);
    // new
    t.Add('TRTYPE^NOQUEUE');
    stat := ImportDataArray(relist, t);
    // with transaction type = NOQUEUE, it'll do Req Field check
    //  and validate, then stop. without creating the queue.

    if stat then    
      //Maglogger.Log(Info, 'Stat = True')
    else
      //Maglogger.Log(Info, 'Stat = False');

    if not stat then
    begin
      status := stat;
      xmsglist.assign(relist);
      exit
    end;
    status := SAVEtoVistA(xmsg);

    if ((FMagUtils.magpiece(xmsg, '^', 1)='1') and (FLogList.Count>
                                                                   0)) then
    begin
      xmsg := '2' + copy(xmsg, 2, 999)
    end;
    //^' + FMagUtils.magpiece(xmsg, '^', 2);
    FLogList.insert(0, xmsg);
    FLogList.insert(1, FTrkNum);
    xmsglist.assign(FLogList)
  finally
    // P8t32  Weren't we calling the Status Callback Routine.
    MagDBBroker.RPMag4StatusCallback(xmsglist, FExcpHandler);

    { TODO : take out the // testing }
    ClearProperties;
    t.Free;
    relist.Free;
    //Maglogger.Log(Trace, 'Exited TMagImport.SaveDirect');
  end;
end;


procedure TMagImport.IAPIOnPulseError(peBroker: TRPCBroker; peErr: string);
begin
{ We want to log the error... but not stop application with dialog box.
  We are here in the code because the RPCBroker tried to call VistA
  with it's onPulseTimer, .. and had a problem.
  So we will now catch the error here.  This was one reason we were
  getting Access Violation, because if this error isn't handled,
  the code in trpcb.pas  shows the Exception in Dialog Box (i.e. the Access Violation)
  When This error happens, the Broker.connected property is set to false by Kernel code.
  In Our app,  this will cause an AutoReconnect to be attempted. }

FOnPulseErrorText := peErr;
lgm('Broker OnPulseError: ' + peErr);
lgdm('** << ENTER - IAPIOnPulseError>>') ;
lgdm('** PULSE Error : ' + FOnPulseErrorText) ;
lgdm('** << EXIT - IAPIOnPulseError >>') ;


end;

procedure TMagImport.ImageAdd(imagefile: String);
begin
  Images.Add(imagefile)
end;


procedure TMagImport.showproperties;
var
  s: string;
begin
  s := '';
  s := s + ('IDFN: ' + FDFN) + ' [' + IntToStr(length(FDFN)) +
       ']' + #13#10;
  s := s + ('PXPKG: ' + FProcPKG) + ' [' + IntToStr(length(FProcPKG)) +
       ']' + #13#10;
  s := s + ('PXIEN: ' + FProcIEN) + ' [' + IntToStr(length(FProcIEN)) +
       ']' + #13#10;
  s := s + ('PXDT: ' + FProcDt) + ' [' + IntToStr(length(FProcDt)) +
       ']' + #13#10;
  s := s + ('TRKID: ' + FTrkNum) + ' [' + IntToStr(length(FTrkNum)) +
       ']' + #13#10;
  s := s + ('ACQD: ' + FAcqDev) + ' [' + IntToStr(length(FAcqDev)) +
       ']' + #13#10;
  s := s + ('ACQS: ' + FAcqSite) + ' [' + IntToStr(length(FAcqSite)) +
       ']' + #13#10;
  s := s + ('ACQL: ' + FAcqLoc) + ' [' + IntToStr(length(FAcqLoc)) +
       ']' + #13#10;
  s := s + ('STSCB: ' + FExcpHandler) + ' [' + IntToStr(length(FExcpHandler)) +
       ']' + #13#10;
  s := s + ('ITYPE: ' + FImgType) + ' [' + IntToStr(length(FImgType)) +
       ']' + #13#10;
  s := s + ('CDUZ: ' + FCapBy) + ' [' + IntToStr(length(FCapBy)) +
       ']' + #13#10;
  s := s + ('DOCCTG: ' + FDOCCTG) + ' [' + IntToStr(length(FDOCCTG)) +
       ']' + #13#10;
  s := s + ('DOCDT: ' + FDocDT) + ' [' + IntToStr(length(FDocDT)) +
       ']' + #13#10;

  s := s + ('IXTYPE: ' + FixType) + ' [' + IntToStr(length(FixType)) +
       ']' + #13#10;
  s := s + ('IXSPEC: ' + FixSpec) + ' [' + IntToStr(length(FixSpec)) +
       ']' + #13#10;
  s := s + ('IXPROC: ' + FixProc) + ' [' + IntToStr(length(FixProc)) +
       ']' + #13#10;
  s := s + ('IXORIGIN: ' + FixOrigin) + ' [' + IntToStr(length(FixOrigin)) +
       ']' + #13#10;

  s := s + ('GDESC: ' + FGroupDesc) + ' [' + IntToStr(length(FGroupDesc)) +
       ']' + #13#10;
  ShowMessage(s)
end;


procedure TMagImport.StayAliveTimer(Sender: TObject);
var rTimeout : string;
  dummystr : string;
  rInt : integer;
begin
lgdm('in Stay Alive Timer Testing Patch 135');
dummystr := 'dummy string';
FTimerStayAlive.Enabled := false;
StayAlive(true);
end;

function TMagImport.StayAlive(value : boolean): string;
var dummystr, rtimeout : string;
brkint: integer;

begin

try
brkint := FDBBroker.GetBroker.RPCTimeLimit;

if value then
  begin
    FTimerStayAlive.Enabled := false;
{135 t3  accesss violation is showing after job is killed, and we wait.... if we send another Import Queue, the
     connection is reestablished....  if not, we get OnPulseTimer Trpcb error.}
   if self.FSALastLogon
   then
   ConnectIfNeeded(FSAvserver, FSAvport, FSAaccesscode, FSAverifycode,FSAdivision);

    rtimeout := MagGetSystemTimeout(dummystr); // any call will do here.  It's resets the RPCBroker timer.

    if (FMagUtils.MagPiece(rtimeout,'^',1) = '0') then raise exception.Create(FMagUtils.magpiece(rtimeout,'^',2));

    FTimerStayAlive.Interval := (900 * brkint)  ; ///(9000) this was 9 secs for testing //    (900 * rint);
    result := '1^Interval set to : 90 % of ' + inttostr(brkint);
    FTimerStayAlive.Enabled := true;
     //bp xxxGetSystemTimeOut(TimeOut);
     //bp xxxif StrToInt(TimeOut)< 30 then TimeOut := '30';
     //bp xxxTimer2.Interval := (StrToInt(Timeout)*900);

   { MabBroker.RCPTimeLimit    from Help :
      The RPCTimeLimit property is a public integer property that is available at run-time only.
      It specifies the length of time a client will wait for a response from an RPC.
      The default and minimum value of this property is 30 seconds. If an RPC is expected
      to take more than 30 seconds to complete, adjust the RPCTimeLimit property accordingly.
      However, it is not advisable to have an RPCTimeLimit that is too long.
      Otherwise, the client-end of the application will appear to "hang",
      if the VistA M Server doesn’t respond in a timely fashion. }
   (* MagBroker.RPCTimeLimit :=  rint; *)

  end
  else
  begin
    FTimerStayAlive.Enabled := false;
    result := '1^Stay Alive Timer:  Disabled' ;
  end;
except
   on e:exception do
     begin
     FTimerStayAlive.Enabled := false;
     result := '0^EXCEPTION:  in IAPI StayAlive: ';
     lgm(result);
     lgm('msg: ' + e.message);
     end;
end;

end;


function TMagImport.MagGetSystemTimeout(data : string): string;
var rstr : string;
mstr: string;
rtimeout : string;
timeout9 : integer;
begin
TRY
{/p135   - data is a string passed from app.  Not sure what will or needs to be in it yet.}

mstr :=   '$G(^XTV(8989.3,1' + ',"XWB"))';
  if FDBBroker.IsConnected then
     begin

       MagBroker.RemoteProcedure := 'XWB GET VARIABLE VALUE';
       MagBroker.Param[0].Value := mstr ;
       MagBroker.Param[0].PType := reference;

       rstr := MagBroker.strCall;

       rtimeout := FMagUtils.MagPiece(rstr,'^',1);
       lgdm('IAPI GetSysTimeOut - Mstr: ' + mstr + '   Result String: ' + rstr + '  piece 1: ' + rtimeout);
      {value in VistA is seconds.  We'll default to 5 mintes}
       if rtimeout = '' then rtimeout := '300';

        result := rtimeout;

     end;  {if connected}
EXCEPT
  ON E:exception do
     begin
       //
       result := '0^EXCEPTION: IAPI GetSystemTimeout  ' ;
       lgm(result);
       lgm('msg: ' + e.message);
     end;
END;  {try except}
end;

{135 t5  DBconnect needs to return an xmsg if fail.}
Function TMagImport.DBConnect2(var xmsg: string; Vserver, Vport: String; Context: String = 'MAG WINDOWS';
                                 AccessCode: String = ''; Verifycode: String = '';division : string = ''): Boolean;
var
  {silent login }
  slFlag : boolean;
Begin
  slFlag := false;
  indentinc;
  try
  try
  lgdm('3- << ENTER - DBConnect2 >>');
  If Not Assigned(FBroker) Then
  Begin
    xmsg := 'Kernel Broker is undefined';
    lgm('ERROR: Function DBConnect2');
    lgm(xmsg);
    Result := False;
    lgdm('3- BROKER UNDEFINED in DBConnect2 ?');
    Exit;
  End;

 (* before 121
  If ((AccessCode <> '') And (Verifycode <> '')) Then
  Begin
    FBroker.AccessVerifyCodes := AccessCode + ';' + Verifycode;
  End *)
{/p121  silent login, fixed with division.
    Tested example from  Kernel code in \vista\brk32\samples 2006\silentlogin}

      {If Division is '', and the user is MultiDivisional,  then they will be prompted
      to enter their division...  this will put stop to BP.
      BP manual and Sites should know that the BP User has to be Single Divisional}

  If ((AccessCode <> '') And (Verifycode <> '')) Then
  Begin
     Fbroker.Login.AccessCode := AccessCode;
     Fbroker.Login.VerifyCode := Verifycode;
     Fbroker.KernelLogin := False;
     Fbroker.Login.Mode := lmAVCodes;
     //ORIGINAL// Login.PromptDivision := True;
      Fbroker.login.PromptDivision := (division  = '');
      if division  <> '' then Fbroker.login.Division := Division;
      slFlag := true;
  End  ;

  FBroker.Server := Vserver;
  FBroker.ListenerPort := Strtoint(Vport);
    if slflag
      then
        begin
        lgdm('3- Attempt SILENT Connection, Division = '+ division);
        lgm('Attempt SILENT Connection, Division = '+ division);
        end
      else lgdm('3- Attempt Broker.Connect...');
    FBroker.Connected := True;
    Result := FBroker.Connected;

    If Result Then
    Begin
      xmsg := 'Connect Success: Sever -' + vserver + ' Port -' + vport;
      lgdm('3- ' + xmsg);
      lgdm('3- ' + 'Access: ' + halfDisplay(AccessCode) + ' Verify: ' + halfDisplay(Verifycode) + ' Division: ' + Division);
      lgdm('3- Set Context : ' + context);
      FBroker.CreateContext(Context);
    End
    else
      begin
      xmsg := 'FAILED Connection  : Sever -' + vserver + ' Port -' + vport;
      lgm(xmsg);
      lgm('Access: ' + halfDisplay(AccessCode) + ' Verify: ' + halfDisplay(Verifycode) + ' Division: ' + Division);
      lgdm('3- ' + xmsg);
      lgdm('3- ' + 'Access: ' + halfDisplay(AccessCode) + ' Verify: ' + halfDisplay(Verifycode) + ' Division: ' + Division);
      end;

  except
   on e:exception do
    Begin
      xmsg := 'Exception: DBConnect2' + e.Message;
      lgdm('3- ' + xmsg);
      Result := False;
    End;
  end;
  finally
  lgdm('3- << EXIT - DBConnect2 >>');
  indentdec;
  end;
End;

function TmagImport.halfDisplay(value : string): string;
begin
result := '****'+copy(value,5,99);
end;

function TMagImport.GetIndexProc : String;
begin
  Result := FixProc
end;


function TMagImport.GetIndexSpec : String;
begin
  Result := FixSpec
end;


function TMagImport.GetIndexType : String;
begin
  Result := FixType
end;


function TMagImport.GetIndexOrigin : String;
begin
  Result := FixOrigin
end;


procedure TMagImport.SetIndexProc(const Value: String);
begin
  FixProc := Value
end;


procedure TMagImport.SetIndexSpec(const Value: String);
begin
  FixSpec := Value
end;


procedure TMagImport.SetIndexType(const Value: String);
begin
  FixType := Value
end;


procedure TMagImport.SetInsertProcTIUText(const Value: string);
begin

end;

procedure TMagImport.SetIndexOrigin(const Value: String);
begin
  FixOrigin := Value
end;


procedure TmagImport.LogFileInit(fn : string);
var
  vDebugLogFile :  TextFile;
   filesize : integer;
   dir : string;
begin
   dir := ExtractFileDir(fn);
//   dir := ExtractFilePath(fn);
   if not directoryexists(dir)  then  forcedirectories(dir);
   if not DirectoryExists(dir) then
     begin
       showmessage('Failed to Create Directory : ' + dir + #13
                      + 'Debug To Log File is off.');
       self.FDebugToFileON := false;
       Exit;
     end;

  AssignFile(vDebugLogFile,fn);


//   Lbfilesize.caption := Inttostr((Getfilesize(AppName) Div 1024) + 1) + ' KB';

  if not FileExists(fn)
    then ReWrite(vDebugLogFile)
    else Append(vDebugLogFile);
    writeln(vDebugLogFile, '-----------------------------------------------------------');
    writeln(vDebugLogFile, 'Initialize Debug Log: ' + formatdatetime('mmm dd yyyy hh:nn am/pm',now));

  close(vDebugLogFile);  {gek added this.}
end;




procedure TMagImport.lgdm(s: String);
var afile : TextFile;
ct : string;
begin
ct := formatdatetime('hh:nn:ss ',now);
If FDebugON Then
    begin
    FLogList.Add(ct+' -debug- '+Findent + s)  ;


    if FDebugToFileON then
        begin
        assignfile(aFile, FDebugToFileName);
        append(aFile);
        writeln(afile, ct + Findent + s);
        closefile(afile);
        end;
    end;
end;


procedure TMagImport.lgdm(t: Tstrings) ; //; pf : string = '');
var
  I: integer;
begin
If FDebugON then
  for I := 0 to t.Count - 1 do
  begin
      lgdm(t[i]) ;
  end;

end;

function TMagImport.BoolToStr(val: boolean): string;
begin
if val then result := 'True'
  else result := 'False';
end;



(*
function TMagImport.XXGetConfigFileNameIAPI(xDirectory : string = ''): string;
var
   dir : string;
begin
  {copied from p129 win7/xp function to return file name in 'AllUser's directory}
  dir :=  GetEnvironmentVariable('ALLUSERSPROFILE') + '\Application Data\vista\imaging\' ;
  if Not Directoryexists(dir) then  Forcedirectories(dir);
  result := dir + 'MagImportX.ini';

end;
*)

function TMagImport.GetRegistryFileNameIAPI(): string;
begin
{this isn't a true full path to a file name,  this result is used
   by Delphi RegistryINI functions to read/write to Registry like the
      read / write to an INI file.
   This is in \HKEY_CURRENT_USER\    }
     result :=  'software\vista\imaging\ImportOCX';
 {Registry entries that will be checked later are :

    value := reg.ReadBool('DebugOptions','DebugON',value);
    FDebugON := value;

    value := Reg.Readbool('DebugOptions','DebugToLogFileON',value);
    FDebugToFileON := value;

    valdir := reg.ReadString('DebugOptions','LogFileDirectory',valdir) ;
 }

end;


(*procedure TMagImport.XXCheckDebugFromINI;
var IAPIini : Tinifile;
debug,debugtofile : string;
secOn: string;
inifilename : string;
begin
exit;
   inifilename := XXGetConfigFileNameIAPI ;
//////  not creating by default    if not fileexists(inifilename) then CreateDefaultINI(inifilename);

  if not fileexists(inifilename) then exit;
  {Only if an INI exists, will check it for debug mode.}

  IAPIini := Tinifile.Create(XXGetConfigFileNameIAPI);
  debug := IAPIini.ReadString('Debug Options','DebugON','FALSE');
  FDebugON := (UpperCase(debug)= 'TRUE');

  debugtoFile := IAPIini.ReadString('Debug Options','DebugToLogFileON','FALSE');
  FDebugToFileON := (UpperCase(debugtoFile)= 'TRUE');

  FDebugToFileName := IAPIini.ReadString('Debug Options','LogFile Name','c:\temp\IAPIDebugLog.txt') ;


  {logfileinit could turn debugging off  'FDebugON=False' , if any problems initializing the Log file}
  If FDebugOn and FDebugToFileON then logfileinit(FDebugToFileName);

  if FDebugON then
     begin
     IAPIini.WriteString('OCX Last Debug','RunTime',formatdatetime('mm/dd/yyyy hh:nn:ss',now));
     showmessage('Import API OCX - Debug ON= ' + magbooltostr(FDebugON)
                 + #13 + #13 + '.  Debug Controled by INI File : ' + inifilename
                 + #13 + #13 + '.  Debug DOS File ON= ' + magbooltostr(FDebugToFileON)
                 + #13 + #13 + '.  Debug DOS File Name= ' + FDebugToFileName);

     end;
end;
*)
function TmagImport.DefaultDebugFileName(logDir : string) : string;
var
       dir : string;
       filesize : integer;
begin
result := '';
if FDebugToFileName <> '' then
  if fileexists(FDebugToFileName) then
    begin
     filesize := (fmxutils.GetFileSize(FDebugToFileName) Div 1024) + 1 ;
     if filesize < 100 then
     begin
      result := FDebugToFileName;
       exit;
     end
     else
     begin
       FDebugToFileName := '';
     end;
    end;
  

result := '';
  {copied from p129 win7/xp function to return file name in 'AllUser's directory}
 if (logdir = '')  then
     begin
       logdir :=  GetEnvironmentVariable('ALLUSERSPROFILE') + '\Application Data\vista\imaging\ImportOCX' ;
       if Not Directoryexists(logdir) then  Forcedirectories(logdir);
       if not DirectoryExists(logdir) then
         begin
         showmessage('Failed to Create Directory : ' + logdir + #13
                      + 'Debug To File is disabled.');
         FDebugToFileON := false;
         exit;
         end;
     end ;



     begin

       if Not Directoryexists(logdir) then  Forcedirectories(logdir);
       if not DirectoryExists(logdir) then
         begin
         showmessage('Failed to Create Directory : ' + logdir + #13
                      + 'Debug To File is disabled.');
         FDebugToFileON := false;
         exit;
         end;
       result := Logdir + '\MagOCX_'+FormatDateTime('yymmdd_hhnnss', NOW)+'.log';
     end;
end;



procedure Tmagimport.RegistryUpdateStr(sec,ident,value : string);
var
    reg : TRegINiFile;
begin
{  this is created in }
   reg := TRegIniFile.create(GetRegistryFileNameIAPI);
   reg.WriteString(sec,ident,value);
   reg.Free;

end;

procedure Tmagimport.RegistryUpdateBool(sec,ident: string;  value : boolean);
var
    reg : TRegINiFile;
begin
{  this is created in }
   reg := TRegIniFile.create(GetRegistryFileNameIAPI);
   reg.WriteBool(sec,ident,value);
   reg.Free;

end;

procedure TMagImport.CheckDebugFromRegistry;
var
  valdir: string;
  value : boolean;
  secOn: string;
  reg : TRegINiFile;
begin
{  this is created in }
   reg := TRegIniFile.create(GetRegistryFileNameIAPI);

  value := false;
  value := reg.ReadBool('DebugOptions','DebugON',value);
  FDebugON := value;

  value := false;
  value := Reg.Readbool('DebugOptions','DebugToLogFileON',value);
  FDebugToFileON := value;

  valdir := '';
  valdir := reg.ReadString('DebugOptions','LogFileDirectory',valdir) ;
     {If only DebugON, still write the other values to Registry. So User
        now knows the options they have.}
  reg.Free;
 if FDebugON  then
   begin
     registryUpdateBool('DebugOptions','DebugON' ,FDebugON);
     registryUpdateBool('DebugOptions','DebugToLogFileON',FDebugToFileON);
     registryUpdateStr('DebugOptions','LogFileDirectory',valdir);
   end;

  FDebugToFileName := DefaultDebugFileName(valdir);
//HERE
if FDebugToFileName = '' then
   begin
     FDebugToFileON := false;
   end;

  {logfileinit could turn debugging off  'FDebugToFile=False' , if any problems initializing the Log file}
  If FDebugOn and FDebugToFileON then logfileinit(FDebugToFileName);

  if FDebugON then
     begin
     registryUpdateStr('DebugOptions','LastDebugRunTime' ,formatdatetime('mm/dd/yyyy hh:nn:ss',now));
//     reg.WriteString('DebugOptions','LastDebugRunTime', formatdatetime('mm/dd/yyyy hh:nn:ss',now));
    // showmessage('Import API OCX - Debug ON= ' + magbooltostr(FDebugON)
    //             + #13 + #13 + '.  Debug to Log File ON= ' + magbooltostr(FDebugToFileON)
    //             + #13 + #13 + '.  Debug File Name= ' + FDebugToFileName);

     end;
end;

(*
procedure TMagImport.xxCreateDefaultINI(inifilename : string);
var t : Tstrings;
logfilename : string;
begin
  t:= Tstringlist.create;
  try
t.Add('[Debug Options]');
t.add(';  ---- Import API OCX, configuration File for debugging ----');
t.add(';  ----  Debugging ON:  each Import processed will first display a Message Dialog to the User ----');
t.add(';');
t.Add(';  --when DebugON=TRUE, detailed debug messages will be saved to VistA');
t.Add(';  --when DebugON=FALSE, the ususal data will be saved to VistA') ;
t.add('DebugON=FALSE');
t.add(';');
t.add(';  --when DebugON=TRUE and DebugToLogFileON = TRUE, ') ;
t.add(';  --   then detailed debug messages will also be save to the LogFile Name');
t.Add('DebugToLogFileON=FALSE');
t.add(';');
t.add(';debug messages will be saved to this File if DebugON=TRUE and DebugToLogFileON=TRUE');
logfilename := extractfilepath(application.ExeName) + 'log\IAPIDebugLog.txt';

t.add('LogFile Name=' + logfilename);
t.SaveToFile(inifilename);

  finally
  t.free;
  end;
end;
*)

function  TMagImport.GetFormatDesc(value : integer ):string;    //enumIGFormats
begin
case value of
  IG_FORMAT_UNKNOWN : result := 'IG_FORMAT_UNKNOWN';
  IG_FORMAT_ATT : result := 'IG_FORMAT_ATT';
  IG_FORMAT_BMP : result := 'IG_FORMAT_BMP';
  IG_FORMAT_BRK : result := 'IG_FORMAT_BRK';
  IG_FORMAT_CAL : result := 'IG_FORMAT_CAL';
  IG_FORMAT_CLP : result := 'IG_FORMAT_CLP';
  IG_FORMAT_CUT : result := 'IG_FORMAT_CUT';
  IG_FORMAT_DCX : result := 'IG_FORMAT_DCX';
  IG_FORMAT_DIB : result := 'IG_FORMAT_DIB';
  IG_FORMAT_EPS : result := 'IG_FORMAT_EPS';
  IG_FORMAT_G3 : result := 'IG_FORMAT_G3';
  IG_FORMAT_G4 : result := 'IG_FORMAT_G4';
  IG_FORMAT_GEM : result := 'IG_FORMAT_GEM';
  IG_FORMAT_GIF : result := 'IG_FORMAT_GIF';
  IG_FORMAT_ICA : result := 'IG_FORMAT_ICA';
  IG_FORMAT_ICO : result := 'IG_FORMAT_ICO';
  IG_FORMAT_IFF : result := 'IG_FORMAT_IFF';
  IG_FORMAT_IMT : result := 'IG_FORMAT_IMT';
  IG_FORMAT_JPG : result := 'IG_FORMAT_JPG';
  IG_FORMAT_KFX : result := 'IG_FORMAT_KFX';
  IG_FORMAT_LV : result := 'IG_FORMAT_LV';
  IG_FORMAT_MAC : result := 'IG_FORMAT_MAC';
  IG_FORMAT_MSP : result := 'IG_FORMAT_MSP';
  IG_FORMAT_MOD : result := 'IG_FORMAT_MOD';
  IG_FORMAT_NCR : result := 'IG_FORMAT_NCR';
  IG_FORMAT_PBM : result := 'IG_FORMAT_PBM';
  IG_FORMAT_PCD : result := 'IG_FORMAT_PCD';
  IG_FORMAT_PCT : result := 'IG_FORMAT_PCT';
  IG_FORMAT_PCX : result := 'IG_FORMAT_PCX';
  IG_FORMAT_PGM : result := 'IG_FORMAT_PGM';
  IG_FORMAT_PNG : result := 'IG_FORMAT_PNG';
  IG_FORMAT_PNM : result := 'IG_FORMAT_PNM';
  IG_FORMAT_PPM : result := 'IG_FORMAT_PPM';
  IG_FORMAT_PSD : result := 'IG_FORMAT_PSD';
  IG_FORMAT_RAS : result := 'IG_FORMAT_RAS';
  IG_FORMAT_SGI : result := 'IG_FORMAT_SGI';
  IG_FORMAT_TGA : result := 'IG_FORMAT_TGA';
  IG_FORMAT_TIF : result := 'IG_FORMAT_TIF';
  IG_FORMAT_TXT : result := 'IG_FORMAT_TXT';
  IG_FORMAT_WPG : result := 'IG_FORMAT_WPG';
  IG_FORMAT_XBM : result := 'IG_FORMAT_XBM';
  IG_FORMAT_WMF : result := 'IG_FORMAT_WMF';
  IG_FORMAT_XPM : result := 'IG_FORMAT_XPM';
  IG_FORMAT_XRX : result := 'IG_FORMAT_XRX';
  IG_FORMAT_XWD : result := 'IG_FORMAT_XWD';
  IG_FORMAT_DCM : result := 'IG_FORMAT_DCM';
  IG_FORMAT_AFX : result := 'IG_FORMAT_AFX';
  IG_FORMAT_FPX : result := 'IG_FORMAT_FPX';
  //IG_FORMAT_PJPEG : result := 'IG_FORMAT_PJPEG';
  IG_FORMAT_AVI : result := 'IG_FORMAT_AVI';
  IG_FORMAT_G32D : result := 'IG_FORMAT_G32D';
  IG_FORMAT_ABIC_BILEVEL : result := 'IG_FORMAT_ABIC_BILEVEL';
  IG_FORMAT_ABIC_CONCAT : result := 'IG_FORMAT_ABIC_CONCAT';
  IG_FORMAT_PDF : result := 'IG_FORMAT_PDF';
  IG_FORMAT_JBIG : result := 'IG_FORMAT_JBIG';
  IG_FORMAT_RAW : result := 'IG_FORMAT_RAW';
  IG_FORMAT_IMR : result := 'IG_FORMAT_IMR';
  IG_FORMAT_WLT : result := 'IG_FORMAT_WLT';
  IG_FORMAT_JB2 : result := 'IG_FORMAT_JB2';
  IG_FORMAT_WL16 : result := 'IG_FORMAT_WL16';
  IG_FORMAT_MODCA : result := 'IG_FORMAT_MODCA';
  IG_FORMAT_PTOCA : result := 'IG_FORMAT_PTOCA';
  IG_FORMAT_WBMP : result := 'IG_FORMAT_WBMP';
  IG_FORMAT_MUL : result := 'IG_FORMAT_MUL';
  IG_FORMAT_CAD : result := 'IG_FORMAT_CAD';
  IG_FORMAT_DWG : result := 'IG_FORMAT_DWG';
  IG_FORMAT_DXF : result := 'IG_FORMAT_DXF';
  IG_FORMAT_EXIF_JPEG : result := 'IG_FORMAT_EXIF_JPEG';
  IG_FORMAT_HPGL : result := 'IG_FORMAT_HPGL';
  IG_FORMAT_DGN : result := 'IG_FORMAT_DGN';
  IG_FORMAT_EXIF_TIFF : result := 'IG_FORMAT_EXIF_TIFF';
  IG_FORMAT_CGM : result := 'IG_FORMAT_CGM';
  IG_FORMAT_QUICKTIMEJPEG : result := 'IG_FORMAT_QUICKTIMEJPEG';
  IG_FORMAT_SVG : result := 'IG_FORMAT_SVG';
  IG_FORMAT_DWF : result := 'IG_FORMAT_DWF';
  IG_FORMAT_U3D : result := 'IG_FORMAT_U3D';
  IG_FORMAT_XPS : result := 'IG_FORMAT_XPS';
  IG_FORMAT_SCI_CT : result := 'IG_FORMAT_SCI_CT';
  IG_FORMAT_CUR : result := 'IG_FORMAT_CUR';
  IG_FORMAT_LURADOC : result := 'IG_FORMAT_LURADOC';
  IG_FORMAT_LURAWAVE : result := 'IG_FORMAT_LURAWAVE';
  IG_FORMAT_LURAJP2 : result := 'IG_FORMAT_LURAJP2';
  IG_FORMAT_JPEG2K : result := 'IG_FORMAT_JPEG2K';
  IG_FORMAT_JPX : result := 'IG_FORMAT_JPX';
  IG_FORMAT_POSTSCRIPT : result := 'IG_FORMAT_POSTSCRIPT';
  IG_FORMAT_MJ2 : result := 'IG_FORMAT_MJ2';
  IG_FORMAT_DCRAW : result := 'IG_FORMAT_DCRAW';
  IG_FORMAT_QUICKTIME : result := 'IG_FORMAT_QUICKTIME';
  IG_FORMAT_AFP : result := 'IG_FORMAT_AFP';
  IG_FORMAT_CIFF : result := 'IG_FORMAT_CIFF';
  IG_FORMAT_DNG : result := 'IG_FORMAT_DNG';
  IG_FORMAT_LZW : result := 'IG_FORMAT_LZW';
  IG_FORMAT_HDP : result := 'IG_FORMAT_HDP';
  IG_FORMAT_DIRECTSHOW : result := 'IG_FORMAT_DIRECTSHOW';
  IG_FORMAT_PSB : result := 'IG_FORMAT_PSB';
  IG_FORMAT_XMP : result := 'IG_FORMAT_XMP';
  IG_FORMAT_HLDCRAW : result := 'IG_FORMAT_HLDCRAW';
  else result := 'NOT Recognized by ImageGear';
  end; {case}
end;



end.
