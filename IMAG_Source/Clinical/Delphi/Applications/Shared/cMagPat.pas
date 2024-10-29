Unit cMagPat;
   {
   Package: MAG - VistA Imaging
   WARNING: Per VHA Directive 10-93-142 this unit should not be modified.
   Date Created:
   Site Name: Silver Spring, OIFO
   Developers: Garrett Kirin
   [==  unit cMagPat;
   Description:  Imaging Patient Class
     Implements the IMagSubject Interface that allows the component to operate oblivious of what
     Type of Object is attached to it.  It simply notifies IMagObservers.
     Has all functions for Patient Lookup, Sensitivity checks, and logging.

   In Patch 8, we consolidated all Patient functions and procedures into the
    TMag4Pat Class.
    An Object of type TMag4Pat has the following functionality:
    - The Patient Lookup window is created and opened.
      (only Tmag4pat uses, or knows about,  the Patient lookup window. Application
       no longer needs to know the details of Patient Lookup window. Maggplku.dfm)
    - Patient information is querried from the database for selected patient.
    - The RPC's for Patient Sensitivity are called.
    - Patient Sensitivity warnings are displayed.
    - Sensitive Patient Logging is done when needed.
    - Means Test warnings are displayed if appropriate.
    - When the Patient changes,  All Attached Observers are Notified
      by calling the Update_ method of each Observer.
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
{ TODO : search for //oo Caption   This is probable place to Notify Observers }
Uses
  Classes,
  cMagDBBroker,
  ImagInterfaces,
  cMagPatLookup
  ;

//Uses Vetted 20090929:StdCtrls, Dialogs, Controls, Graphics, Messages, Windows, MagRemoteInterface, umagdefinitions, uMagUtils, Forms, SysUtils

Type
  TMag4Pat = Class(TComponent, IMagSubject)
  Private
    FMyPatLookupWin: TMaggplkf;
    FDBBroker: TMagDBBroker;
    FObserversList: Array Of IMagObserver;
    FPatName: String;
    FSSN: String;
    FSSNForIHS : String; //p130t11 dmmn 4/18/13 - the real SSN for IHS sites since the usual location has been used for HRN and we don't want to break any dependancy
    FDFN: String;
    FICN: String;
    FSite: String;
    FProdAcct: Boolean;
    FDOB: String;
    // JMW 10/22/2010 P106/P117 - need to keep VIX and non VIX counts seperate
    //    FTotalImageCount: string;
    FTotalRPCImageCount : String; // this is the number of images that came from RPC brokers
    FTotalVIXImageCount : String; // this is the number of images that came from the VIX
    FDemog: String;
    FCachePhotoID: String;
    FSSNDisplay: String;
    FDOBDisplay: String;
    FNameDisplay: String;
    FFakePatientName: String;
    FServiceConnected: String;
    FType: String;
    FVeteran: String;
    FSex: String;
    FAge: String;
    //FRestricted   : boolean;
    //FEmployee     : boolean;
    //FMeansTestReq : boolean;
    FUseFakeName: Boolean;
    FLastResult: String;
    FCPRSDFN: String; //46

    FIncDeletedImageCount: Boolean; {/ P117 - JK 10/5/2010 /}

    // JMW P46 - determines if a patient is currently being set
    FCurrentlySwitchingPatient: Boolean; //46

    // JMW p46T20 9/13/2006
    // keeps current patient Id during a switch (before Id is put into M_DFN or M_ICN
    FCurrentlySwithingPatientId: String; //46

     //procedure UseFakeName(value :boolean);
    Procedure SetFakePatientName(Value: String);
    Procedure SetUseFakeName(Value: Boolean);
    Function GetPatientInformation(Xdfn: String; Var Resultmsg: String; IsIcn: Boolean = False): Boolean;
    Procedure SetPatientInfo(Str: String);
    function getTotalImageCount() : string;
  Protected
    { Protected declarations }
  Public
    Constructor Create(AOwner: TComponent); Override;
    Destructor Destroy; Override;

    {   object that implements the ImagObserver interface calls this method
        to attach itself to the ImagSubject.}
    Procedure Attach_(Observer: IMagObserver);

    {   Observers can Detach and Attach any time they want}
    Procedure Detach_(Observer: IMagObserver);

    {   TMag4Pat objects will call the Update_ method of all observers from
        this Notify_ method.  (The Notify_ method is public on purpose.  Other
        objects, components can call Notify_ to force an update of all observers.}
    Procedure Notify_(SubjectState: String);

    {GetState and SetState aren't really used.  State is sent as parameter to
     observers. when patient changes,  (state = 1 )
                when patient is cleared  (state = '')
                or Mag4Pat object is being destroyed (state = -1 )
     The way this is designed, the Observer has to 'Know' the structure of the
     subject to get some information.  Observers query the published properties
     M_PatName, M_DFN etc.
     If we used a more detailed state object, the objserver wouldn't need to
     know the properties of cMag4Pat. Both ways are acceptable, used in different
     situations.

    We don't send the DFN as the value of State when a patient changes. We just send
    a '1'.  The Observer then has to Query the Subject for the information.}
    {GetState_ will returmn DFN as the var State : string}
    Procedure GetState_(Var State: String);

    {SetState_ assumes the State : string is the DFN, and uses it at such}
    Procedure SetState_(State: String);
    Procedure Clear;

    {   Copy one Tmag4Pat object to another.}
    Procedure Assign(Source: TPersistent); Override;

    Procedure SetDemoPatName(Value: String);

    {   overloaded to support older classes that don't send 'Var xmsg: string'
        SelectPatient will open the patient selection window with all patients
        that match the user input.
        If only one patient matches user input. SelectPatient window is not
        displayed.}
    Function SelectPatient(Input: String; Var Xmsg: String): Boolean; Overload;
    Function SelectPatient(Input: String = ''): Boolean; Overload;

    {   Called in 3 situations.
         - User has selected a Patient from the Patient History menu items.
         - CPRS has sent a Windows message, saying change patient
           (CCOW Change of patient context in the future
        - TMag4Pat object has validated a new patient selection, calls this method itself}
    Function SwitchTopatient(DFN: String; Var Xmsg: String; Doclear: Boolean = True; IsIcn: Boolean = False): Boolean;
     {JMW 1/8/2007 P72 Add images to count late (if coming from ViX}
    Procedure AddImagesToCount(ImgCount: Integer);
    { JMW 10/22/2010 P106/P117 clear the image count from the VIX}
     procedure clearVIXImageCount();
  Published

    { Most of these properties are Read Only.  Ther aren't and 'write' operations
        on the property}
    {   This is needed to make any calls to the DataBase.}
    Property M_DBBroker: TMagDBBroker Read FDBBroker Write FDBBroker;

    {   Full Name of Patient.}
    Property M_PatName: String Read FPatName;

    {   Total number of Images on file for this patient.}
    Property M_Sex: String Read FSex;

    {   Patient Age}
    Property M_Age: String Read FAge;
    Property M_TotalImageCount: String Read getTotalImageCount; //JMW 10/22/2010 P106/P117

    {   SSN of patient.  in  9N format.}
    Property M_SSN: String Read FSSN;

    {   p130t11 dmmn 4/18/13 - SSN of patient of IHS sites in 9digit format}
    Property M_ISSN : String Read FSSNForIHS;

    {   DFN: internal entry number Patient in the PATIENT File.}
    Property M_DFN: String Read FDFN;

     {  ICN number of patient computed by : $$GETICN^MPIF001}
    Property M_ICN: String Read FICN;
     {  LOCAL STATION NUMBER. $p(3,"^") of $$SITE^VASITE}
    Property M_Site: String Read FSite;
     {  Is this a Production account :  by $$PROD^XUPROD}
    Property M_ProdAcct: Boolean Read FProdAcct;

    {   Date of Birth of Patient.   Internal FileMan format.}
    Property M_DOB: String Read FDOB;

    {   Patient demographics.}
    Property M_Demog: String Read FDemog;

    //property M_CachePhotoID : String read FCachePhotoID; //write FCachePhotoID;

    {   Last result of a Patient Lookup.}
    Property M_LastResult: String Read FLastResult;

    {   SSN in the format 3N - 2N - 4N.  If using fake name it is '000-00-0000'}
    Property M_SSNdisplay: String Read FSSNDisplay;

    {   Date of Birth in readable format.}
    Property M_DOBdisplay: String Read FDOBDisplay;

    {   Normally the same as M_PatName property.  When Using a fake name for
         demo purposes.  This is changed to 'LightYear, Buzz'}
    Property M_NameDisplay: String Read FNameDisplay;

    //property M_Restricted : boolean read FRestricted;
    //property M_Employee    : boolean read FEmployee;
    //property M_MeansTestReq : boolean read FMeansTestReq;

    {   Set to 'LightYear, Buzz' by the system.}
    Property M_FakePatientName: String Read FFakePatientName Write SetFakePatientName;

    {   If TRUE, the real patient name will be hidden, and fake patient name is used.}
    Property M_UseFakeName: Boolean Read FUseFakeName Write SetUseFakeName;

    {   Is patient service connected or not   Field # ___ from PATIENT File.}
    Property M_ServiceConnected: String Read FServiceConnected;

    {   Type of Patient.    Field # ___ from PATIENT File.}
    Property M_Type: String Read FType;

    {   Is patient a veteran or not   Field # ___ from PATIENT File.}
    Property M_Veteran: String Read FVeteran;

    // JMW p46
    Property CurrentlySwitchingPatient: Boolean Read FCurrentlySwitchingPatient Write FCurrentlySwitchingPatient;

    // JMW 2/23/2006 p46 This contains the DFN received from CPRS when display is launched from CPRS
    Property M_CPRSDFN: String Read FCPRSDFN Write FCPRSDFN;
    //46
    Property M_CurrentlySwithingPatientId: String Read FCurrentlySwithingPatientId;

    Property M_IncDeletedImageCount: Boolean Read FIncDeletedImageCount write FIncDeletedImageCount default False; {/ P117 - JK 10/5/2010 /}
  End;

Procedure Register;

Implementation
Uses
  Forms,
  Magremoteinterface,
  SysUtils,
  UMagDefinitions,
  Umagutils8
  ;

//Uses Vetted 20090929:dmsingle, uMagClasses

{str is the result of the RPC Broker call to get patient information.
  here we set values for the Patient Properties.}

Procedure TMag4Pat.SetPatientInfo(Str: String);
Begin
    (* !!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!
     ANY CHANGE TO THIS FUNCTION NEEDS COORESPONGING CHANGE IN
                FUNCTION     ASSIGN
                        and
               FUNCTION      CLEAR
     !!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!*)
  //                 1        2      3     4     5     6     7     8        9                     10
  //format str:   status ^   DFN ^ name ^ sex ^ DOB ^ SSN ^ S/C ^ TYPE ^ Veteran(y/n)  ^ Patient Image Count
  //DPT field :                    .01   .02   .03   .09   .301   391    1901
  //
  //                11      12          13            14        15        16
  //               ICN  ^ SITE # ^ Prod Account?  ^ Not Use ^   Age   ^ SSN (IHS)
  //

  FDFN := MagPiece(Str, '^', 2);
  FPatName := MagPiece(Str, '^', 3);
  FSex := Copy(MagPiece(Str, '^', 4), 1, 1);
  FDOB := MagPiece(Str, '^', 5);
  FSSN := MagPiece(Str, '^', 6);
  FServiceConnected := MagPiece(Str, '^', 7);
  FType := MagPiece(Str, '^', 8);
  FVeteran := MagPiece(Str, '^', 9);
  FTotalRPCImageCount := MagPiece(Str, '^', 10);  //JMW 10/22/2010 P106/P117
  //FICN := magpiece(str,'^',11);
  // JMW 12/1/2005 only use first part of ICN, after V is checksum
  FICN := MagPiece(MagPiece(Str, '^', 11), 'V', 1);

  FSite := MagPiece(Str, '^', 12);
  FProdAcct := (MagPiece(Str, '^', 13) = '1');
  FCachePhotoID := '';

  {/ P122/P123 JK 8/18/2011 /}
  if assigned(Gsess) then
    if GSess.Agency.IHS then
      FSSNDisplay := FSSN
    else
    FSSNDisplay := Copy(FSSN, 1, 3) + '-' + Copy(FSSN, 4, 2) + '-' + Copy(FSSN, 6, 4);

  FDOBDisplay := FDOB;
  FNameDisplay := FPatName;
  FAge := MagPiece(Str, '^', 15);
  FSSNForIHS := MagPiece(Str, '^', 16);            //p130t11 dmmn 4/18/13 add new piece for IHS SSN used for MUSE

  //FRestricted   := false;
  //FEmployee     := false;
  //FMeansTestReq := false ;

  FDemog := FDOBDisplay + '   ' + FSSNDisplay + '   ' + FServiceConnected + '   ' + FType;

  FCurrentlySwithingPatientId := ''; // JMW p46t20 9/13/2006
  SetUseFakeName(FUseFakeName);
End;

{Used to assign the values of one cMag4Pat object into another cMag4Pat object.}

Procedure TMag4Pat.Assign(Source: TPersistent);
Begin
    (* !!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!
     ANY CHANGE TO THIS FUNCTION NEEDS COORESPONGING CHANGE IN
                FUNCTION     SetPatientInfo
     AND
                FUNCTION      CLEAR
     !!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!*)
  Clear;
  FTotalRPCImageCount := (source as TMag4Pat).FTotalRPCImageCount; //JMW 10/22/2010 P106/P117
  FTotalVIXImageCount := (source as TMag4Pat).FTotalVIXImageCount; //JMW 10/22/2010 P106/P117
  FDFN := (Source As TMag4Pat).M_DFN;
  FICN := (Source As TMag4Pat).M_ICN;
  FSite := (Source As TMag4Pat).M_Site;
  FProdAcct := (Source As TMag4Pat).M_ProdAcct;
  FPatName := (Source As TMag4Pat).M_PatName;
  FDOB := (Source As TMag4Pat).M_DOB;
  FSSN := (Source As TMag4Pat).M_SSN;
  FAge := (Source As TMag4Pat).M_Age;
  FSex := (Source As TMag4Pat).M_Sex;
  FServiceConnected := (Source As TMag4Pat).M_ServiceConnected;
  FType := (Source As TMag4Pat).M_Type;
  FVeteran := (Source As TMag4Pat).M_Veteran;
   //117 out FTotalImageCount := (Source As TMag4Pat).M_TotalImageCount; //JMW 10/22/2010 P106/P117
  //FCachePhotoID    := (source as TMag4Pat).M_CachePhotoID;
  FCachePhotoID := '';
  FSSNDisplay := (Source As TMag4Pat).M_SSNdisplay;
  FDOBDisplay := (Source As TMag4Pat).M_DOBdisplay;
  FNameDisplay := (Source As TMag4Pat).M_NameDisplay;

  //FRestricted   := (source as TMag4Pat).M_Restricted;
  //FEmployee     := (source as TMag4Pat).M_Employee;
  //FMeansTestReq := (source as TMag4Pat).M_MeansTestReq;

  FDemog := (Source As TMag4Pat).M_Demog;

  FUseFakeName := (Source As TMag4Pat).M_UseFakeName;
  FFakePatientName := (Source As TMag4Pat).M_FakePatientName;

  Notify_(FDFN);
End;

{Clear the patient object,  Notify all observers of a change of State.}

Procedure TMag4Pat.Clear;
Begin
    (* !!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!
     ANY CHANGE TO THIS FUNCTION NEEDS COORESPONGING CHANGE IN
                FUNCTION:     ASSIGN
                        AND
                FUNCTION:      SetPatientInfo
     !!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!*)
  FDFN := '';
  FICN := '';
  FSite := '';
  FProdAcct := False;
  FPatName := '';
  FDOB := '';
  FSSN := '';
  FServiceConnected := '';
  FType := '';
  ;
  FVeteran := '';
  //117 out FTotalImageCount := '';
  FTotalRPCImageCount := '0'; //JMW 10/22/2010 P106/P117
  FTotalVIXImageCount := '0';//JMW 10/22/2010 P106/P117
  FCachePhotoID := '';
  FSSNDisplay := '';
  FDOBDisplay := '';
  FNameDisplay := '';
  FDemog := '';
        {       Notify all observers.  Send a clear patient event.}
  Notify_('');
  // JMW 3/17/2006 p46t10 Make sure the RIV toolbar and components are cleared
  // when the patient is cleared (especially in case the patient doesn't exist at the local site
  Magremoteinterface.RIVNotifyAllListeners(Nil, 'DeactivateAll', ''); //46
  Magremoteinterface.RIVNotifyAllListeners(Nil, 'ServerConnectionsComplete', ''); //46
End;

{When we set UseFakeName to TRUE, we change the FNameDisplay to use the FakePatient Name value
 and use fake values for the SSN,Date of Birth, Service Connected and Type of patient.}

Procedure TMag4Pat.SetUseFakeName(Value: Boolean);
Begin
  FUseFakeName := Value;
  If Value Then
  Begin
    FNameDisplay := FFakePatientName;

    {/ P122/P123 - JK 8/18/2011 /}
    if GSess.Agency.IHS then
      FDemog := '01/01/1910' + '   ' + '00000' + '   ' + 'Yes' + '   ' + 'Hero'
    else
      FDemog := '01/01/1910' + '   ' + '000-00-0000' + '   ' + 'Yes' + '   ' + 'Hero';
  End
  Else
  Begin
    FNameDisplay := FPatName;
    FDemog := FDOBDisplay + '   ' + FSSNDisplay + '   ' + FServiceConnected + '   ' + FType;
  End;
End;

Procedure TMag4Pat.SetFakePatientName(Value: String);
Begin
  FFakePatientName := Value;
End;
{We also Create the Patient Lookup window when this object is created.}

Constructor TMag4Pat.Create(AOwner: TComponent);
Begin
  Inherited Create(AOwner);
//p59  memory leak   maggplkf := TMaggplkf.create(nil);
  FMyPatLookupWin := TMaggplkf.Create(Self);
  FMyPatLookupWin.FDBBroker := M_DBBroker;
  Self.M_FakePatientName := 'LightYear,Buzz';
End;

{Have to Noify_ the Observers, so they can set their pointers (pointer to the
 cMag4Pat object to nil}

Destructor TMag4Pat.Destroy;
Begin
(*p59  memory leak when create with (nil) and
 release like this

  maggplkf.Release; *)
  Notify_('-1');
  Inherited;
End;

Procedure TMag4Pat.SetDemoPatName(Value: String);
Begin
  FPatName := Value;
  If Not FUseFakeName Then FNameDisplay := Value;
End;

Procedure Register;
Begin
  RegisterComponents('Imaging', [TMag4Pat]);
End;

{Observers call this method.  They are then Notified of any change of State.
     Change of Patient  (State = 1 )
 or  Clear Patient (state = '')
 or  TMag4Pat object is being destroyed.  (state = -1) }

Procedure TMag4Pat.Attach_(Observer: IMagObserver);
Begin
  SetLength(FObserversList, Length(FObserversList) + 1);
  FObserversList[High(FObserversList)] := Observer;
End;

{An observer can detach from the Subject at any time.}

Procedure TMag4Pat.Detach_(Observer: IMagObserver);
Var
  i: Integer;
Begin
  For i := 0 To (High(FObserversList)) Do
  Begin
    If (Observer = FObserversList[i]) Then
    Begin
      FObserversList[i] := Nil;
    End;
  End;
End;

Procedure TMag4Pat.GetState_(Var State: String);
Begin
  State := FDFN;
End;

Procedure TMag4Pat.Notify_(SubjectState: String);
Var
  i: Integer;
  IMagPatObserver: IMagObserver;
Begin
   {debug94} magAppMsg('s', '**--**  START + TMag4Pat.Notify_(' + SubjectState + ')');
  For i := 0 To (High(FObserversList)) Do
  Begin
    If FObserversList[i] <> Nil Then
    Begin
      IMagPatObserver := (FObserversList[i]);
    {debug94} magAppMsg('s', '**--** TMag4Pat.Notify_ Observer[' + Inttostr(i) + ']   state ' + SubjectState);
      IMagPatObserver.UpDate_(SubjectState, Self);
    End;
  End;
   {debug94} magAppMsg('s', '**--**  END + TMag4Pat.Notify_(' + SubjectState + ')');  
End;

Procedure TMag4Pat.SetState_(State: String);
Begin
  magAppMsg('s','** TMag4Pat.SetState_(' + state + ')');
  FDFN := State;
  { TODO -chigh : Look into this, could be Notifying Twice.}
  Notify_(State);
End;

Function TMag4Pat.SelectPatient(Input: String = ''): Boolean;
Var
  Xmsg: String;
Begin
  Result := SelectPatient(Input, Xmsg);
  FLastResult := Xmsg; //
End;

Function TMag4Pat.SelectPatient(Input: String; Var Xmsg: String): Boolean;
Var
  Xdfn, Vserver, Vport: String;
Begin

  FCurrentlySwitchingPatient := True;
  FCurrentPatientSensitiveLevel := 0;
        { If not logged in, we exit;}
  Try
    Result := False;
    If Not Assigned(FDBBroker) Then
    Begin
      Xmsg := 'Error : DB Broker UnAssigned in TMag4Pat.';
      Exit;
    End;
    If Not FDBBroker.IsConnected Then
      If Not FDBBroker.DBSelect(Vserver, Vport, 'MAG WINDOWS') Then
      Begin
        Xmsg := 'No Connection to VISTA.';
        Exit;
      End;
    {  To assure Patient lookup form, is connected to same database as Patient Component }
    FMyPatLookupWin.FDBBroker := M_DBBroker;
//ExternalPatientChange := false;
    If Not FMyPatLookupWin.Select(Input, Xmsg, Xdfn) Then
    Begin
      { DONE: -oGarrett :
        need a message log component. All components have a property of this
        component, and if assigned send messages to it.
        It tracks in VistA, makes Log File if needed. }//maggmsgf.MagMsg('', xmsg, pmsg);
      Exit;
    End;
        {       A new patient has been selected, Clear current and switch to new.}
    Clear;
    Result := SwitchTopatient(Xdfn, Xmsg, False);
  Finally
        {       store the last result}
    FLastResult := Xmsg;
    FCurrentlySwitchingPatient := False; //46
  End;
End;

{Called in 3 situations.
 - User has selected a Patient from the Patient History menu items.
 - CPRS has sent a Windows message, saying change patient
   (CCOW Change of patient context in the future
 - TMag4Pat object has validated a new patient selection, calls this method itself}

Function TMag4Pat.SwitchTopatient(DFN: String; Var Xmsg: String; Doclear: Boolean = True; IsIcn: Boolean = False): Boolean;
Begin
        {       doClear is set to false, if this function is called internally, and patient
                has already been cleared.  }
  If Doclear Then Clear;
  Application.Processmessages;
  FCurrentlySwitchingPatient := True; //46
  FCurrentlySwithingPatientId := DFN; //46

  // put thing in here to see if first time, if multiple times then kill first
  // move this code, CCOW does this on its own, processvista should do this too

        {       If GetPatientInformation is successful, Notify all Observers.}
  Result := GetPatientInformation(DFN, Xmsg, IsIcn);
  If Result Then Notify_(DFN);
  FCurrentlySwitchingPatient := False; //46
                   //if (dmod.CCOWManager.CCOWEnabled) and (not dmod.CCOWManager.isCCOWConnected) then
                   // JMW 3/2/2006 p46t10 - check if CCOW was temporarily suspended

  Magremoteinterface.RIVNotifyAllListeners(Nil, 'PatientChangeProcessComplete', ''); //46
                {
                 if (dmod.CCOWManager.CCOWTempSuspended or dmod.CCOWManager.CCOWEnabled) and (not dmod.CCOWManager.isCCOWConnected) then
                  begin
                   dmod.CCOWManager.ResumeGetContext();
                  end;
                 }
End;

Function TMag4Pat.GetPatientInformation(Xdfn: String; Var Resultmsg: String; IsIcn: Boolean = False): Boolean;
Begin
  FDBBroker.RPMagPatInfo(Result, Resultmsg, Xdfn, IsIcn, FIncDeletedImageCount);  {/ P117 - JK 10/5/2010 - Added 5th parameter/}
  If Result Then SetPatientInfo(Resultmsg);
End;

Procedure TMag4Pat.AddImagesToCount(ImgCount: Integer);
Var
  c: Integer;
Begin
  c := StrToInt(FTotalVIXImageCount);//JMW 10/22/2010 P106/P117
  c := c + ImgCount;
  FTotalVIXImageCount := inttostr(c);//JMW 10/22/2010 P106/P117
End;

procedure TMag4Pat.clearVIXImageCount();
begin
  FTotalVIXImageCount := '0';
end;

function TMag4Pat.getTotalImageCount() : string;
var
  count : integer;
begin
  count := 0;
  result := '';
  if FTotalRPCImageCount <> '' then
    count := strtoint(FTotalRPCImageCount);
  if FTotalVIXImageCount <> '' then
    count := count + strtoint(FTotalVIXImageCount);
  result := inttostr(count);
end;

End.
