unit MagImportImpl1;

interface

uses
  Windows, ActiveX, Classes, Controls, Graphics, Menus, Forms, StdCtrls,
  ComServ, StdVCL, AXCtrls, MagImportXControl1_TLB, cMagImport, SysUtils,
  variants, dialogs;

type
  TMagImportX = class(TActiveXControl, IMagImportX)
  private
  FsoAccess,
  FsoVerify,
  FsoServer,
  FsoPort,
  FsoDivision : string;
  FDelayConnectUntilImport : boolean;
    { Private declarations }
    FDelphiControl: TMagImport;
    FEvents: IMagImportXEvents;

   // function Get_GroupIEN: WideString; safecall;
  //  procedure Set_GroupIEN(const Value: WideString); safecall;
  protected
    { Protected declarations }
    procedure DefinePropertyPages(DefinePropertyPage: TDefinePropertyPage); override;
    procedure EventSinkChanged(const EventSink: IUnknown); override;
    procedure InitializeControl; override;
    function DrawTextBiDiModeFlagsReadingOnly: Integer; safecall;
    function Get_AcqDev: WideString; safecall;
    function Get_AcqLocation: WideString; safecall;
    function Get_AcqSite: WideString; safecall;
    function Get_CapDt: WideString; safecall;
    function Get_Cursor: Smallint; safecall;
    function Get_DeleteFlag: WordBool; safecall;
    function Get_DFN: WideString; safecall;
    function Get_DocCategory: WideString; safecall;
    function Get_DocDate: WideString; safecall;
    function Get_DoubleBuffered: WordBool; safecall;
    function Get_Enabled: WordBool; safecall;
    function Get_ExcpHandler: WideString; safecall;
    function Get_GroupDesc: WideString; safecall;
    function Get_GroupLongDesc: OleVariant; safecall;
    function Get_Images: OleVariant; safecall;
    function Get_ImgType: WideString; safecall;
    function Get_Method: WideString; safecall;
    function Get_Password: WideString; safecall;
    function Get_ProcDesc: WideString; safecall;
    function Get_ProcDt: WideString; safecall;
    function Get_ProcIEN: WideString; safecall;
    function Get_ProcPKG: WideString; safecall;
    function Get_ProcType: WideString; safecall;
    function Get_TransType: WideString; safecall;
    function Get_TrkID: WideString; safecall;
    function Get_Username: WideString; safecall;
    function Get_Visible: WordBool; safecall;
    function Get_VisibleDockClientCount: Integer; safecall;
    function IsRightToLeft: WordBool; safecall;
    function UseRightToLeftReading: WordBool; safecall;
    function UseRightToLeftScrollBar: WordBool; safecall;
    procedure AboutBox; safecall;
    procedure InitiateAction; safecall;
    {/p121 gek 3/9/11  the ImportQueue is a call we need to surface for 121.  It isn't available
                       in the AcitveX prior to 121.}
    procedure ImportQueue(var status: WordBool; const Qnum: WideString; var reslist: OleVariant; var StatusCB: WideString); safecall;
    procedure SaveDirect(var status: WordBool; var xmsglist: OleVariant);  safecall;
    procedure Set_AcqDev(const Value: WideString); safecall;
    procedure Set_AcqLocation(const Value: WideString); safecall;
    procedure Set_AcqSite(const Value: WideString); safecall;
    procedure Set_CapDt(const Value: WideString); safecall;
    procedure Set_Cursor(Value: Smallint); safecall;
    procedure Set_DeleteFlag(Value: WordBool); safecall;
    procedure Set_DFN(const Value: WideString); safecall;
    procedure Set_DocCategory(const Value: WideString); safecall;
    procedure Set_DocDate(const Value: WideString); safecall;
    procedure Set_DoubleBuffered(Value: WordBool); safecall;
    procedure Set_Enabled(Value: WordBool); safecall;
    procedure Set_ExcpHandler(const Value: WideString); safecall;
    procedure Set_GroupDesc(const Value: WideString); safecall;
    procedure Set_GroupLongDesc(Value: OleVariant); safecall;
    procedure Set_Images(Value: OleVariant); safecall;
    procedure Set_ImgType(const Value: WideString); safecall;
    procedure Set_Method(const Value: WideString); safecall;
    procedure Set_Password(const Value: WideString); safecall;
    procedure Set_ProcDesc(const Value: WideString); safecall;
    procedure Set_ProcDt(const Value: WideString); safecall;
    procedure Set_ProcIEN(const Value: WideString); safecall;
    procedure Set_ProcPKG(const Value: WideString); safecall;
    procedure Set_ProcType(const Value: WideString); safecall;
    procedure Set_TransType(const Value: WideString); safecall;
    procedure Set_TrkID(const Value: WideString); safecall;
    procedure Set_Username(const Value: WideString); safecall;
    procedure Set_Visible(Value: WordBool); safecall;
    procedure VistaInit(var zstat: WordBool; var zmsg, zserver, zport: WideString; const zaccess, zverify, zdivision: WideString); safecall;
    procedure ImageAdd(const imagefile: WideString); safecall;
    procedure ShowProperties; safecall;
    procedure ClearProperties; safecall;
    function Get_IndexProc: WideString; safecall;
    function Get_IndexSpec: WideString; safecall;
    function Get_IndexType: WideString; safecall;
    procedure Set_IndexProc(const Value: WideString); safecall;
    procedure Set_IndexSpec(const Value: WideString); safecall;
    procedure Set_IndexType(const Value: WideString); safecall;
    procedure IMagImportX_VistAInit(var status: WordBool; var xmsg, zserver,
      zport: WideString; const zaccess, zverify: WideString); safecall;
    function Get_IndexOrigin: WideString; safecall;
    procedure Set_IndexOrigin(const Value: WideString); safecall;
//    function Get_PatientHasPhoto: OleVariant; safecall;
    function GetOriginList(out Status: EXCEPINFO): OleVariant; safecall;
    function GetProcList(const ClassChoice, SpecChoice: WideString;
      out Status: EXCEPINFO): OleVariant; safecall;
    function GetSpecList(const ClassChoice, ProcChoice: WideString;
      out Status: EXCEPINFO): OleVariant; safecall;
    function GetTypeList(const ClassChoice: WideString;
      out Status: EXCEPINFO): OleVariant; safecall;
    function Get_ProcNew: WideString; safecall;
    function Get_TIUSignType: WideString; safecall;
    function Get_TIUTitle: WideString; safecall;
    procedure Set_ProcNew(const Value: WideString); safecall;
    procedure Set_TIUSignType(const Value: WideString); safecall;
    procedure Set_TIUTitle(const Value: WideString); safecall;
    procedure SetTIUText(TIUText: OleVariant); safecall;
    function GetPatientHasPhoto(const DFN: WideString;
      out Status: EXCEPINFO): OleVariant; safecall;
    function Get_NetSecurity: WordBool; safecall;
    procedure Set_NetSecurity(Value: WordBool); safecall;
    function Get_DelayConnectUntilImport: WordBool; safecall;
    procedure Set_DelayConnectUntilImport(Value: WordBool); safecall;

  public
    function MagPiece(str, delim: string; piece: INTEGER): string;
    {/p135}
    function ResetStayAlive(value : boolean): string;

  end;

implementation

uses ComObj, About1;

{ TMagImportX }

procedure TMagImportX.DefinePropertyPages(DefinePropertyPage: TDefinePropertyPage);
begin
  {TODO: Define property pages here.  Property pages are defined by calling
    DefinePropertyPage with the class id of the page.  For example,
      DefinePropertyPage(Class_MagImportXPage); }
end;

procedure TMagImportX.EventSinkChanged(const EventSink: IUnknown);
begin
  FEvents := EventSink as IMagImportXEvents;
end;

procedure TMagImportX.InitializeControl;
begin
  FDelphiControl := Control as TMagImport;
end;

function TMagImportX.DrawTextBiDiModeFlagsReadingOnly: Integer;
begin
  Result := FDelphiControl.DrawTextBiDiModeFlagsReadingOnly;
end;

function TMagImportX.Get_AcqDev: WideString;
begin
  Result := WideString(FDelphiControl.AcqDev);
end;

function TMagImportX.Get_AcqLocation: WideString;
begin
  Result := WideString(FDelphiControl.AcqLocation);
end;

function TMagImportX.Get_AcqSite: WideString;
begin
  Result := WideString(FDelphiControl.AcqSite);
end;

function TMagImportX.Get_CapDt: WideString;
begin
  Result := WideString(FDelphiControl.CapDt);
end;

function TMagImportX.Get_Cursor: Smallint;
begin
  Result := Smallint(FDelphiControl.Cursor);
end;

function TMagImportX.Get_DeleteFlag: WordBool;
begin
  Result := FDelphiControl.DeleteFlag;
end;

function TMagImportX.Get_DFN: WideString;
begin
  Result := WideString(FDelphiControl.DFN);
end;

function TMagImportX.Get_DocCategory: WideString;
begin
  Result := WideString(FDelphiControl.DocCategory);
end;

function TMagImportX.Get_DocDate: WideString;
begin
  Result := WideString(FDelphiControl.DocDate);
end;

function TMagImportX.Get_DoubleBuffered: WordBool;
begin
  Result := FDelphiControl.DoubleBuffered;
end;

function TMagImportX.Get_Enabled: WordBool;
begin
  Result := FDelphiControl.Enabled;
end;

function TMagImportX.Get_ExcpHandler: WideString;
begin
  Result := WideString(FDelphiControl.ExcpHandler);
end;

function TMagImportX.Get_GroupDesc: WideString;
begin
  Result := WideString(FDelphiControl.GroupDesc);
end;

(*function TMagImportX.Get_GroupIEN: WideString;
begin
  Result := WideString(FDelphiControl.GroupIEN);
end;
 *)
function TMagImportX.Get_GroupLongDesc: OleVariant;
var v : variant;
 i : integer;
begin
 // GetOleStrings(FDelphiControl.GroupLongDesc, Result);
v := vararraycreate([0,FDelphiControl.GroupLongDesc.Count-1],varolestr);
for i := 0 to FDelphiControl.GroupLongDesc.Count-1 do
        v[i] := FDelphiControl.GroupLongDesc[i];
result := v;
end;

function TMagImportX.Get_Images: OleVariant;
var v : variant;
 i : integer;
begin
//  GetOleStrings(FDelphiControl.Images, Result);
v := vararraycreate([0,FDelphiControl.Images.Count-1],varolestr);
for i := 0 to FDelphiControl.Images.Count-1 do
        v[i] := FDelphiControl.Images[i];
result := v;

   {}
end;

function TMagImportX.Get_ImgType: WideString;
begin
  Result := WideString(FDelphiControl.ImgType);
end;

function TMagImportX.Get_Method: WideString;
begin
  Result := WideString(FDelphiControl.Method);
end;

function TMagImportX.Get_Password: WideString;
begin
  Result := WideString(FDelphiControl.Password);
end;

function TMagImportX.Get_ProcDesc: WideString;
begin
  Result := WideString(FDelphiControl.ProcDesc);
end;

function TMagImportX.Get_ProcDt: WideString;
begin
  Result := WideString(FDelphiControl.ProcDt);
end;

function TMagImportX.Get_ProcIEN: WideString;
begin
  Result := WideString(FDelphiControl.ProcIEN);
end;

function TMagImportX.Get_ProcPKG: WideString;
begin
  Result := WideString(FDelphiControl.ProcPKG);
end;

function TMagImportX.Get_ProcType: WideString;
begin
  Result := WideString(FDelphiControl.ProcType);
end;

function TMagImportX.Get_TransType: WideString;
begin
  Result := WideString(FDelphiControl.TransType);
end;

function TMagImportX.Get_TrkID: WideString;
begin
  Result := WideString(FDelphiControl.TrkNum);
end;

function TMagImportX.Get_Username: WideString;
begin
  Result := WideString(FDelphiControl.Username);
end;

function TMagImportX.Get_Visible: WordBool;
begin
  Result := FDelphiControl.Visible;
end;

function TMagImportX.Get_VisibleDockClientCount: Integer;
begin
  Result := FDelphiControl.VisibleDockClientCount;
end;

function TMagImportX.IsRightToLeft: WordBool;
begin
  Result := FDelphiControl.IsRightToLeft;
end;

function TMagImportX.UseRightToLeftReading: WordBool;
begin
  Result := FDelphiControl.UseRightToLeftReading;
end;

function TMagImportX.UseRightToLeftScrollBar: WordBool;
begin
  Result := FDelphiControl.UseRightToLeftScrollBar;
end;

procedure TMagImportX.AboutBox;
begin
  ShowMagImportXAbout;
end;

//test procedure TMagImportX.ImportQueue(var status: WordBool;
//test  const Qnum: WideString; var reslist: IStrings; var StatusCB: WideString);

//test {The code in ImportQueue is new.}
 procedure TMagImportX.ImportQueue(var status: WordBool; const Qnum: WideString; var reslist: OleVariant; var StatusCB: WideString);
var
  i : integer;
  xstat : boolean;
  xStatCB, xQnum : string;
  t : tstrings;
  s : string; //testing
  pStat : boolean;
  pMsg : string;
  rstayalive: string;
begin
(* {121 dummy patch}
  {121  dummy ocx} {Dont show any dialogs, unless processing an Import.  We Don't want this
 machine processing Imports, so we show the Dialog Box.
 .. The big change is that we do NOT CONNECT to VISTA , so any VistA Connections issues will not Affect
   This DUMMY API. }


messagedlg('This is a NON-Functioning  Version of the Import API Active X Control'  + #13 +
            'The Import- ' + Qnum + ', Was NOT attempted.  You cannot process the IMPORT QUEUE on a Workstation' + #13 +
            'with this Debug Version of the Import API Active X control. '  + #13 +
            'You will see this Dialog 3 times for each Import attempted.'
            , mtconfirmation, [mbok],0 );


   t := tstringlist.create;                           //sim to SaveDirect
/////////////////////  FDelphiControl.ImportQueue(xstat,qnum,t,xStatCB);  //sim to SaveDirect
  status := false;                                   //sim to SaveDirect
  StatusCB := 'ERROR^MAGGSIUI';


EXIT; { end of test code for 121 dummy Active X}
 {121 dummy patch}              *)

{/p135,  start.  This p135 code, is put in front of the code to process the import.}

  {/p135  Connect using the Global  "Private" variables Fso...}
 {
 FsoServer
  FsoPort
  FsoAccess
  FsoVerify
  FsoDivision
  }

try
if  FDelayConnectUntilImport then
  begin
  IF Not FDelphiControl.MagBroker.Connected then
      begin
        FDelphiControl.VistAInit(pstat, pmsg, FsoServer, FsoPort, FsoAccess, FsoVerify, FsoDivision);
        xstat := pstat;
        if not xstat  then
          begin
            vararrayRedim(reslist,0);
            reslist[0] := pmsg;
            exit;
          end;

      end;
  end;
except
  on e:exception do
    begin
      reslist[0] := 'Error Connection to VistA : ' + e.Message;
      xstat := false;
      exit;
    end;
end;
 {/p135, end. This p135 code, is put in front of the code to process the import.}
 {/p135 Code for Stay Alive call.  We decided to use same logic as BP.
       Timer will call Broker to get SystemTimeout each time it reaches it's interval
       We will implement the StayAlive Timer if the FDelayConnectUntilImport is being used. }


  rstayalive := ResetStayAlive(FDelayConnectUntilImport);

  // FOLLOWING THIS LINE IS THE FULL AND CORRECT CODE
  t := tstringlist.create;                           //sim to SaveDirect
  FDelphiControl.ImportQueue(xstat,qnum,t,xStatCB);  //sim to SaveDirect
  status := xstat;                                   //sim to SaveDirect
  StatusCB := xStatCB;

// now convert the data that needs conversion to the format of the passed parameters.
    try
  vararrayRedim(reslist,t.count-1);
  for i := 0 to t.count-1 do
     reslist[i] := t[i];
  finally
    //
  end;

end;

Function TMagImportX.ResetStayAlive(value : boolean) : string;
var
  rstr : string;
begin
rstr :=  FDelphiControl.StayAlive(value);
end;


procedure TMagImportX.InitiateAction;
begin
  FDelphiControl.InitiateAction;
end;

procedure TMagImportX.SaveDirect(var status: WordBool;  var xmsglist: OleVariant);
var i : integer;
t: Tstrings;
  xstat: boolean;
begin
  //status := false;
  t := tstringlist.create;
  FDelphiControl.SaveDirect(xstat,t);          {variant test}
  status := xstat;
//exit;
  //t.add('lskdjfsldkfj');
  //t.add('lsdkjfsldfkj2');
  try
    //GetOleStrings(t, xmsglist);
  //qtest  vararrayRedim(xmsglist,t.count-1);
  //qtest  for i := 0 to t.count-1 do
  //qtest    xmsglist[i] := t[i];

  vararrayRedim(xmsglist,t.count);
  for i := 0 to t.count-1 do
     xmsglist[i] := t[i];
  xmsglist[t.Count] := 'test change';

  finally
  end;
end;

procedure TMagImportX.Set_AcqDev(const Value: WideString);
begin
  FDelphiControl.AcqDev := string(Value);
end;

procedure TMagImportX.Set_AcqLocation(const Value: WideString);
begin
  FDelphiControl.AcqLocation := string(Value);
end;

procedure TMagImportX.Set_AcqSite(const Value: WideString);
begin
  FDelphiControl.AcqSite := string(Value);
end;

procedure TMagImportX.Set_CapDt(const Value: WideString);
begin
  FDelphiControl.CapDt := string(Value);
end;

procedure TMagImportX.Set_Cursor(Value: Smallint);
begin
  FDelphiControl.Cursor := TCursor(Value);
end;

procedure TMagImportX.Set_DeleteFlag(Value: WordBool);
begin
  FDelphiControl.DeleteFlag := Value;
end;

procedure TMagImportX.Set_DFN(const Value: WideString);
begin
  FDelphiControl.DFN := string(Value);
end;

procedure TMagImportX.Set_DocCategory(const Value: WideString);
begin
  FDelphiControl.DocCategory := string(Value);
end;

procedure TMagImportX.Set_DocDate(const Value: WideString);
begin
  FDelphiControl.DocDate := string(Value);
end;

procedure TMagImportX.Set_DoubleBuffered(Value: WordBool);
begin
  FDelphiControl.DoubleBuffered := Value;
end;

procedure TMagImportX.Set_Enabled(Value: WordBool);
begin
  FDelphiControl.Enabled := Value;
end;

procedure TMagImportX.Set_ExcpHandler(const Value: WideString);
begin
  FDelphiControl.ExcpHandler := string(Value);
end;

procedure TMagImportX.Set_GroupDesc(const Value: WideString);
begin
  FDelphiControl.GroupDesc := string(Value);
end;

(*procedure TMagImportX.Set_GroupIEN(const Value: WideString);
begin
  FDelphiControl.GroupIEN := string(Value);
end;
 *)

procedure TMagImportX.Set_GroupLongDesc(Value: OleVariant);
var lowb,highb, i : integer;
begin
//  SetOleStrings(FDelphiControl.GroupLongDesc, Value);
lowb := vararraylowbound(value,1);
highb := vararrayhighbound(value,1);
FDelphiControl.GroupLongDesc.Clear;
for I := lowb to highb do
   FDelphiControl.GroupLongDesc.Add(value[i]);
end;

procedure TMagImportX.Set_Images(Value: OleVariant);
var lowb,highb, i : integer;
begin
//  SetOleStrings(FDelphiControl.Images, Value);
lowb := vararraylowbound(value,1);
highb := vararrayhighbound(value,1);
FDelphiControl.images.Clear;
for I := lowb to highb do
   FDelphiControl.Images.Add(value[i]);
end;

procedure TMagImportX.Set_ImgType(const Value: WideString);
begin
  FDelphiControl.ImgType := string(Value);
end;

procedure TMagImportX.Set_Method(const Value: WideString);
begin
  FDelphiControl.Method := string(Value);
end;

procedure TMagImportX.Set_Password(const Value: WideString);
begin
  FDelphiControl.Password := string(Value);
end;

procedure TMagImportX.Set_ProcDesc(const Value: WideString);
begin
  FDelphiControl.ProcDesc := string(Value);
end;

procedure TMagImportX.Set_ProcDt(const Value: WideString);
begin
  FDelphiControl.ProcDt := string(Value);
end;

procedure TMagImportX.Set_ProcIEN(const Value: WideString);
begin
  FDelphiControl.ProcIEN := string(Value);
end;

procedure TMagImportX.Set_ProcPKG(const Value: WideString);
begin
  FDelphiControl.ProcPKG := string(Value);
end;

procedure TMagImportX.Set_ProcType(const Value: WideString);
begin
  FDelphiControl.ProcType := string(Value);
end;

procedure TMagImportX.Set_TransType(const Value: WideString);
begin
  FDelphiControl.TransType := string(Value);
end;

procedure TMagImportX.Set_TrkID(const Value: WideString);
begin
  FDelphiControl.TrkNum := string(Value);
end;

procedure TMagImportX.Set_Username(const Value: WideString);
begin
  FDelphiControl.Username := string(Value);
end;

procedure TMagImportX.Set_Visible(Value: WordBool);
begin
  FDelphiControl.Visible := Value;
end;

procedure TMagImportX.VistaInit(var zstat: WordBool; var zmsg, zserver, zport: WideString; const zaccess, zverify, zdivision: WideString);
var
  xstat: boolean;
  xmsg : string; //xserver, xport, xaccess,xverify,xdivision : string;

begin
     {121 dummy patch}
(*//messagedlg('connecting to VistA',mtconfirmation, [mbok],0);
//  FDelphiControl.VistAInit(xstat, xmsg, xserver, xport, xaccess, xverify, xdivision);
zstat := true;                                     //  zstat := xstat;
zmsg := 'Import API OCX Connection Not Attempted'; //  zmsg   := xmsg;

  *)

//  THIS IS THE FULL AND COMPLETE CODE
  { there is nothing here, just the method declaration }

  xstat := zstat;
  xmsg := zmsg;
  {/p135  change local variables to Global  "Private" variables Fso...}
  FsoServer :=  zserver;
  FsoPort   := zport;
  FsoAccess := zaccess;
  FsoVerify := zverify;
  FsoDivision := zdivision;

   { Review this later...  default to the new FDelayConnectUntilImport when FsoDivision has a value
   , see if this will work. }
  //if FsoDivision <> '' then FDelayConnectUntilImport := true;
  

  FDelphiControl.VistAInit(xstat, xmsg, FsoServer, FsoPort, FsoAccess, FsoVerify, FsoDivision);
  zstat := xstat;
  zmsg   := xmsg;

{/p135, above is the working code.  We add this code below.
    A) we always try to connect, to make sure the passed variables are valid and a
     connection is possible.
     But (NEW) if FDelayConnectUntilImport, then we will save the connection parameters, and
     Disconnect, and only ReConnect if we are doing an Import.}
if  FDelayConnectUntilImport then
  begin
  IF FDelphiControl.MagBroker.Connected then
      FDelphiControl.MagBroker.Connected := false;
      zstat := true;
      zmsg := 'Connection to VistA delayed until Import is processed';
  end;
end;

procedure TMagImportX.ImageAdd(const imagefile: WideString);
begin
  FDelphiControl.ImageAdd(string(imagefile));
end;

(*function TMagImportX.Get_GroupIEN: WideString;
begin
  Result := WideString(FDelphiControl.GroupIEN);
end;  *)

(*procedure TMagImportX.Set_GroupIEN(const Value: WideString);
begin
  FDelphiControl.GroupIEN := String(Value);
end; *)

procedure TMagImportX.ShowProperties;
begin
  FDelphiControl.ShowProperties;
end;

procedure TMagImportX.ClearProperties;
begin
   FDelphiControl.ClearProperties;
end;

function TMagImportX.Get_IndexProc: WideString;
begin
  Result := Widestring(FDelphiControl.IndexProc);
end;

function TMagImportX.Get_IndexSpec: WideString;
begin
  Result := Widestring(FDelphiControl.IndexSpec);
end;

function TMagImportX.Get_IndexType: WideString;
begin
  Result := Widestring(FDelphiControl.IndexType);
end;

procedure TMagImportX.Set_IndexProc(const Value: WideString);
begin
  FDelphiControl.IndexProc := string(Value);
end;

procedure TMagImportX.Set_IndexSpec(const Value: WideString);
begin
  FDelphiControl.IndexSpec := string(Value);
end;

procedure TMagImportX.Set_IndexType(const Value: WideString);
begin
  FDelphiControl.IndexType := string(Value);
end;

procedure TMagImportX.IMagImportX_VistAInit(var status: WordBool; var xmsg,
  zserver, zport: WideString; const zaccess, zverify: WideString);
begin

end;

function TMagImportX.Get_IndexOrigin: WideString;
begin
    Result := Widestring(FDelphiControl.IndexOrigin);
end;

procedure TMagImportX.Set_IndexOrigin(const Value: WideString);
begin
   FDelphiControl.IndexOrigin := string(Value);
end;

//function TMagImportX.Get_PatientHasPhoto: OleVariant;
//var
//  stat: Boolean;
//  msg: String;
//  DFN: String;
//begin
//  DFN := Get_DFN;
//  if DFN = '' then
//    Result := '0'
//  else
//    Result := FDelphiControl.RPPatientHasPhoto(DFN, stat, msg);
//end;

{/ JK 12/1/2009 - P108 - New function GetOriginList /}
function TMagImportX.GetOriginList(out Status: EXCEPINFO): OleVariant;
var
  v: Variant;
  i: Integer;
  slOriginList: TStringList;
  ZeroNode: String;
begin
  slOriginList := TStringList.Create;
  try

    FDelphiControl.IndexOriginList(slOriginList);

    {Load the variant array with the origin values}
    if slOriginList.Count <= 0 then
    begin
      {In case FileMan returns nothing, send back an empty variant array.}
      v := VarArrayCreate([0, 0], VarOleStr);
      v[0] := '';
      Status.wCode := 0;
      Status.bstrDescription := 'Zero node not defined';
    end else
    begin

      ZeroNode := slOriginList[0];
      slOriginList.Delete(0);
      try
        Status.wCode := StrToInt(MagPiece(ZeroNode, '^', 1));
        Status.bstrDescription := MagPiece(ZeroNode, '^', 2);
      except
        Status.wCode := 0;
        Status.bstrDescription := 'Zero node not defined';
      end;
          
      v := VarArrayCreate([0, slOriginList.Count-1], VarOleStr);
      for i := 0 to slOriginList.Count - 1 do
        v[i] := slOriginList[i];
    end;
  finally
    slOriginList.Free;
  end;

  Result := v;
end;

{/ JK 12/1/2009 - P108 - New function GetProcList /}
function TMagImportX.GetProcList(const ClassChoice, SpecChoice: WideString;
  out Status: EXCEPINFO): OleVariant;
var
  v: Variant;
  i: Integer;
  slProcList: TStringList;
//  Ignore_Status, inc_Class, inc_Status: Boolean;
  ZeroNode: String;
begin
//  Ignore_Status := IgnoreStatus;
//  inc_Class     := incClass;
//  inc_Status    := incStatus;

  slProcList := TStringList.Create;

  try
//    FDelphiControl.IndexEventList(slProcList,
//                                  ClassChoice,
//                                  SpecChoice,
//                                  Ignore_Status,
//                                  inc_Class,
//                                  inc_Status);

    FDelphiControl.IndexEventList(slProcList,
                                  ClassChoice,
                                  SpecChoice);

    {Load the variant array with the Procedure/Event values}
    if slProcList.Count <= 0 then
    begin
      {In case FileMan returns nothing, send back an empty variant array.}
      v := VarArrayCreate([0, 0], VarOleStr);
      v[0] := '';
      Status.wCode := 0;
      Status.bstrDescription := 'Zero node not defined';
    end else
    begin

      ZeroNode := slProcList[0];
      slProcList.Delete(0);
      try
        Status.wCode := StrToInt(MagPiece(ZeroNode, '^', 1));
        Status.bstrDescription := MagPiece(ZeroNode, '^', 2);
      except
        Status.wCode := 0;
        Status.bstrDescription := 'Zero node not defined';
      end;

      v := VarArrayCreate([0, slProcList.Count-1], VarOleStr);
      for i := 0 to slProcList.Count - 1 do
        v[i] := slProcList[i];
    end;
  finally
    slProcList.Free;
  end;

  Result := v;
end;

{/ JK 12/1/2009 - P108 - New function GetSpecList /}
function TMagImportX.GetSpecList(const ClassChoice, ProcChoice: WideString;
  out Status: EXCEPINFO): OleVariant;
var
  v: Variant;
  i: Integer;
  slSpecList: TStringList;
//  Ignore_Status, inc_Class, inc_Status, inc_Spec: Boolean;
  ZeroNode: String;
begin
//  Ignore_Status := IgnoreStatus;
//  inc_Class     := incClass;
//  inc_Status    := incStatus;
//  inc_Spec      := incSpec;

  slSpecList := TStringList.Create;

  try
//    FDelphiControl.IndexSpecSubSpecList(slSpecList,
//                                        ClassChoice,
//                                        ProcChoice,
//                                        Ignore_Status,
//                                        inc_Class,
//                                        inc_Status,
//                                        inc_Spec);

    FDelphiControl.IndexSpecSubSpecList(slSpecList,
                                        ClassChoice,
                                        ProcChoice);

    {Load the variant array with the Procedure/Event values}
    if slSpecList.Count <= 0 then
    begin
      {In case FileMan returns nothing, send back an empty variant array.}
      v := VarArrayCreate([0, 0], VarOleStr);
      v[0] := '';
      Status.wCode := 0;
      Status.bstrDescription := 'Zero node not defined';
    end else
    begin

      ZeroNode := slSpecList[0];
      slSpecList.Delete(0);
      try
        Status.wCode := StrToInt(MagPiece(ZeroNode, '^', 1));
        Status.bstrDescription := MagPiece(ZeroNode, '^', 2);
      except
        Status.wCode := 0;
        Status.bstrDescription := 'Zero node not defined';
      end;

      v := VarArrayCreate([0, slSpecList.Count-1], VarOleStr);
      for i := 0 to slSpecList.Count - 1 do
        v[i] := slSpecList[i];
    end;
  finally
    slSpecList.Free;
  end;

  Result := v;
end;

{/ JK 12/1/2009 - P108 - New function GetTypeList /}
function TMagImportX.GetTypeList(const ClassChoice: WideString;
  out Status: EXCEPINFO): OleVariant;
var
  v: Variant;
  i: Integer;
  slTypeList: TStringList;
//  Ignore_Status, inc_Class, inc_Status: Boolean;
  ZeroNode: String;
begin
//  Ignore_Status := IgnoreStatus;
//  inc_Class     := incClass;
//  inc_Status    := incStatus;

  slTypeList := TStringList.Create;

  try
//    FDelphiControl.IndexTypeList(slTypeList,
//                                 ClassChoice,
//                                 Ignore_Status,
//                                 inc_Class,
//                                 inc_Status);

    FDelphiControl.IndexTypeList(slTypeList,
                                 ClassChoice);

    {Load the variant array with the Type values}
    if slTypeList.Count <= 0 then
    begin
      {In case FileMan returns nothing, send back an empty variant array.}
      v := VarArrayCreate([0, 0], VarOleStr);
      v[0] := '';
      Status.wCode := 0;
      Status.bstrDescription := 'Zero node not defined';
    end else
    begin

      ZeroNode := slTypeList[0];
      slTypeList.Delete(0);
      try
        Status.wCode := StrToInt(MagPiece(ZeroNode, '^', 1));
        Status.bstrDescription := MagPiece(ZeroNode, '^', 2);
      except
        Status.wCode := 0;
        Status.bstrDescription := 'Zero node not defined';
      end;

      v := VarArrayCreate([0, slTypeList.Count-1], VarOleStr);

      for i := 0 to slTypeList.Count - 1 do
        v[i] := slTypeList[i];
    end;
  finally
    slTypeList.Free;
  end;

  Result := v;
end;

function TMagImportX.Get_ProcNew: WideString;
begin
  Result := WideString(FDelphiControl.ProcNew);
end;

function TMagImportX.Get_TIUSignType: WideString;
begin
  Result := WideString(FDelphiControl.ProcTIUSignatureType);
end;

function TMagImportX.Get_TIUTitle: WideString;
begin
  Result := WideString(FDelphiControl.ProcTIUTitle);
end;

procedure TMagImportX.Set_ProcNew(const Value: WideString);
begin
  FDelphiControl.ProcNew := string(Value);
end;

procedure TMagImportX.Set_TIUSignType(const Value: WideString);
begin
  FDelphiControl.ProcTIUSignatureType := String(Value);
end;

procedure TMagImportX.Set_TIUTitle(const Value: WideString);
begin
  FDelphiControl.ProcTIUTitle := String(Value);
end;

procedure TMagImportX.SetTIUText(TIUText: OleVariant);
var
  Min, Max, i: Integer;
begin
  FDelphiControl.ProcTIUText.Clear;
  if VarIsArray(TIUText) then begin
    Min := VarArrayLowBound(TIUText, 1);
    Max := VarArrayHighBound(TIUText, 1);
    for i := Min to Max do
      FDelphiControl.ProcTIUText.Add(VarToStr(TIUText[i]));
  end;
end;

function TMagImportX.MagPiece(str, delim: string; piece: INTEGER): string;
var I, K: INTEGER;
  s: string;
begin
  I := Pos(delim, str);
  if (I = 0) and (piece = 1) then begin result := str; EXIT; end;
  for K := 1 to piece do
    begin
      I := POS(delim, str);
      if (I = 0) then I := LENGTH(str) + 1;
      S := COPY(str, 1, I - 1);
      str := COPY(str, I + 1, LENGTH(str));
    end;
  result := S;
end;

{/ JK 12/1/2009 - P108 - New function GetPatientHasPhoto /}
function TMagImportX.GetPatientHasPhoto(const DFN: WideString;
  out Status: EXCEPINFO): OleVariant;
var
  stat: Boolean;
  msg: String;
begin
  if DFN = '' then
  begin
    Result := '0';
    Status.wCode := 0;
    Status.bstrDescription := 'Error: The DFN provided is an empty string';
  end
  else
  begin
    Result := FDelphiControl.RPPatientHasPhoto(DFN, stat, msg);
    if stat = True then
      Status.wCode := 1
    else
      Status.wCode := 0;
    Status.bstrDescription := 'DFN = ' + DFN + ' , msg: ' + msg;
  end;
end;


function TMagImportX.Get_NetSecurity: WordBool;
begin

//Result := true;   {121  dummy ocx}

// THIS IS CORRECT COMPLETE CODE FOR THIS FUNCTION
{ in 135 see if error trap is working here}

try
 Result := FDelphiControl.NetSecurityOn;
except
  on e:exception do showmessage('ImportImpl1 : Exception Get_NetSecurity - ' + e.message);
end;
end;

procedure TMagImportX.Set_NetSecurity(Value: WordBool);
begin
 {121  dummy ocx} {Dont show any dialogs, unless processing an Import.  We Don't want this
 machine processing Imports, so we show the Dialog Box.
 .. The big change is that we do NOT CONNECT to VISTA , so any VistA Connections issues will not Affect
   This DUMMY API. }
(*messagedlg('This is a NON-Functioning  Version of the Import API Active X Control'  + #13 +
             'Do NOT attempt to process the Import Queue on this Workstation.'  + #13 +
            'Any Import Will Fail, and A dialog Box will be Displayed', mtconfirmation, [mbok],0 );
            *)
// FOR  dummy ocx   Comment out the line,  do not set it  {121  dummy ocx}

// THIS IS CORRECT COMPLETE CODE FOR THIS FUNCTION
{ in 135 see if error trap is working here}
try
     FDelphiControl.NetSecurityOn := Value;
except
  on e:exception do showmessage('ImportImpl1 : Exception SET_NetSecurity - ' + e.message);
end;
end;


function TMagImportX.Get_DelayConnectUntilImport: WordBool;
begin
  {p135  connect only if we are importing .}
 result := FDelayConnectUntilImport;
end;

procedure TMagImportX.Set_DelayConnectUntilImport(Value: WordBool);
begin
  {if TRUE,  then we only connect to VistA if an ImportQueue is sent to be processed.}
   FDelayConnectUntilImport := value;
end;

initialization
  TActiveXControlFactory.Create(
    ComServer,
    TMagImportX,
    TMagImport,
    Class_MagImportX,
    1,
    '',
    0,
    tmApartment);
end.

