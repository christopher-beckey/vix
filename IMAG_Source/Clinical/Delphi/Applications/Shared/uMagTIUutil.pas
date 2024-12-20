Unit UMagTIUutil;
   {
   Package: MAG - VistA Imaging
   WARNING: Per VHA Directive 10-93-142 this unit should not be modified.
   Date Created:   1996
   Site Name: Silver Spring, OIFO
   Developers: Garrett Kirin
   Description: Imaging TIU utilities.
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
  ComCtrls,
  Controls,
  UMagClasses,
  imaginterfaces
  ;



(*t
from uMagClasses
  TMagTIUData = Class(Tobject)
  Public
    AuthorDUZ: String; {File 200 New Person: Author's DUZ}
    AuthorName: String; {File 200 New Person: Author's Name}
    DFN: String; {Patient DFN}
    DispDT: String; {Date of Report External format}
    IntDT: String; {Date of Report FM internal format}
    PatientName: String; {Patient NAME}
    Status: String; {status of Note}
    Title: String; {Title of Note: Free Text (8925.1) }
    TiuDA: String; {TIU DOCUMENT File 8925 DA}
    TiuParDA : string ;{TIU Parent DA, if this is Addendum}
    IsAddendum : boolean;  {/p129 gek/dmmn 12/17/12 TIU Type: normal or addendum}
    HasAddendums : boolean ; {129p18  }
    Procedure Assign(VTIUdata: TMagTIUData);
  End;
 *)


Procedure TiuListToListView(t: Tstringlist; LV: TListView);
Procedure SetCPRSSyncDefaults(Xsync: CprsSyncOptions);
(* function SelectNewNoteData(vClinDataObj : TClinicalData;rmsg : string): boolean;*)
 { ResolvTIUNote will make all DB calls necessary to Create Note, Addendem, Sign etc
      based on values of TClinicalData Obj.  Don't need seperate Functions here. }
//RCA xxx
Function xxxRCAxxxResolveTIUNote(ClinDataObj: TClinicalData; Var Xmsg: String): String;
//function CreateNewNote(var vtiuda,rmsg : string): boolean;
//function CreateAddendum(var vtiuda,vmsg: string; tiuda,adminclose: string):boolean;
//function SignNote(var vmsg : string; tiuda: string): boolean;
Function xxxRCAxxxCheckEsig(Author: String; Var Xmsg: String; Var Esig: String; Var ContUnsign: Boolean): Boolean;

Function UpdateStatus(DFN, TiuDA, Status, Esig: String; Var Xmsg: String): Boolean;

Implementation
Uses
  Dialogs,
  ImagDMinterface,  // DmSingle
 //RCA-2 FmagCapPatConsultList,
  FmagEsigDialog,

  UMagDefinitions,
  Umagutils8
  ;

(* rca test *)
Function xxxRCAxxxCheckEsig(Author: String; Var Xmsg: String; Var Esig: String; Var ContUnsign: Boolean): Boolean;
Var
  VfailReason: TEsigFailReason;
  Failstring: String;
Begin
  ContUnsign := False;
      { if a new Note or Addendum has Status 'Create & Sign'}
  Begin
         {get hashed Esig. If fails, or Canceled, prompt to save it as Un-Signed.}
    If Not FrmEsigDialog.Execute(Author, Esig, idmodobj.GetMagDBBroker1, VfailReason) Then
    Begin
      Result := False;
      Case VfailReason Of
        MagesfailCancel: Failstring := 'Canceled.';
        MagesfailInvalid: Failstring := 'Error: Invalid Electronic Signature';
      End;
            //maggmsgf.magmsg('','Electronic Signature ' + failstring);
      MagAppMsg('', 'Electronic Signature ' + Failstring); 
      If Messagedlg('Electronic Signature ' + Failstring + #13 + #13 +
        'Save the Note as Un-Signed and Continue ? '
        , Mtconfirmation, [MbYes, MbNo], 0) = MrYes Then
      Begin
        ContUnsign := True;
      End
    End
    Else
      Result := True;
  End;
End;

Function UpdateStatus(DFN, TiuDA, Status, Esig: String; Var Xmsg: String): Boolean;
Var
  Rstat: Boolean;
  Rmsg: String;
Begin
  Rstat := False;
  Rmsg := '';
  idmodobj.GetMagDBBroker1.RPTIUModifyNote(Rstat, Rmsg,
    DFN, TiuDA, Status, 'S', Esig, ''); //,rtext); // memo1:Tstrings ); - later.
  If Rstat Then
  Begin
    Xmsg := 'Status Changed.';
    Result := True;
  End
  Else
  Begin
    Xmsg := 'Failed to change status of Note: ' + TiuDA; //maggmsgf.magmsg('de',xmsg);
              //maggmsgf.magmsg('s',rmsg);
    MagAppMsg('s', Rmsg); 
    Result := False;
  End;
End;

Function xxxRCAxxxResolveTIUNote(ClinDataObj: TClinicalData; Var Xmsg: String): String;
Var
  Rstat: Boolean;
  Rmsg, DFN, Esig, VConsDA: String;
  Rtext, t: Tstringlist;
  ClinDataDisplay: String;

Const
  TmpUnsigned: String = '0';
Const
  TmpEsig: String = '';

Begin
  ClinDataDisplay := ClinDataObj.GetClinDataStrAll;
  //maggmsgf.magmsg('s',' *** Get Clinical Data All : from Resolve TIU Note. ***');
  MagAppMsg('s', ' *** Get Clinical Data All : from Resolve TIU Note. ***'); 
  //maggmsgf.magmsg('s',clindatadisplay);
  MagAppMsg('s', ClinDataDisplay); 
  //maggmsgf.magmsg('s',' ***  ***');
  MagAppMsg('s', ' ***  ***'); 
  Result := '';
  Rtext := Tstringlist.Create;
  DFN := idmodobj.GetMagPat1.M_DFN;
  Esig := '';
  { We'll handle the most common first}
  If ClinDataObj.AttachToSigned
    Or ClinDataObj.AttachToUnSigned
    Or ClinDataObj.AttachOnly Then
  Begin
    If ClinDataObj.ReportData = Nil Then
    Begin
      Xmsg := 'Failed to Resolve Selected Note. "Report Data Object" is nil';
      Result := '';
      Exit;
    End
    Else
    Begin {here}
      Result := ClinDataObj.ReportData.TiuDA;
      Exit;
    End;
  End;
  Try
    With ClinDataObj Do
    Begin
      If ClinDataObj.NewText <> Nil Then Rtext.Assign(ClinDataObj.NewText);

      If NewAddendum Then
      Begin { Create Addendum , return the TIUDA }
       //maggmsgf.MagMsg('s','NewAddendum:    NewAuthorDuz : ' + clindataobj.NewAuthorDUZ);
        MagAppMsg('s', 'NewAddendum:    NewAuthorDuz : ' + ClinDataObj.NewAuthorDUZ);

        idmodobj.GetMagDBBroker1.RPTIUCreateAddendum(Rstat, Rmsg,
          DFN, ReportData.TiuDA, TmpUnsigned, 'S', TmpEsig, ClinDataObj.NewAuthorDUZ, NewDate, Rtext); // memo1:Tstrings ); - later.
        If Not Rstat Then
        Begin
          Xmsg := 'Failed to Create Addendum: ' + MagPiece(Rmsg, '^', 2);
            //maggmsgf.magmsg('s',rmsg);
          MagAppMsg('s', Rmsg); 
        End
        Else
          Result := Rmsg;
        Exit;
      End; { if  NewAddendum}

      If NewNote Then
      Begin
        {    Create the New Note. Return the TIUDA }

        {DONE:  pre 129 - Add possible NewNoteConsultDA}
        ////
        If NewTitleConsultDA = '' Then
        Begin
          idmodobj.GetMagDBBroker1.RPTIUisThisaConsult(Rstat, Rmsg, NewTitleDA);
          If Rstat Then { this is a Consult Title}
          Begin
            t := Tstringlist.Create;
            Try
                    {Get a List of Patient Consults to select from}
              idmodobj.GetMagDBBroker1.RPGMRCListConsultRequests(Rstat, Rmsg, t, DFN);
              If Rstat Then { There are Consults for Patient}
              Begin { Let user select a Consult }
  {this is the only line that uses CapPatConsult List,  so we can copy/move this function
    to a capture util.}
//RCA                Rstat := FrmCapPatConsultList.Execute(VConsDA, t, NewTitle, idmodobj.GetMagPat1.M_NameDisplay);
                If Not Rstat Then {User didn't select a consult.}
                Begin
                  Xmsg := 'Consult wasn''t selected.';
                                 //maggmsgf.MagMsg('','Consult wasn''t selected.');
                  MagAppMsg('', 'Consult wasn''t selected.'); 
                  Result := '';
                  Exit;
                End
                Else
                Begin {Title is a Consult and User has Selected a Patient Consult}
                  NewTitleConsultDA := VConsDA;
                End;
              End
              Else { No Consults for Patient.  }
              Begin
                Xmsg := 'No Consults available for Patient';
                           //maggmsgf.MagMsg('D','There are No Consults available for Patient: '+ dmod.MagPat1.M_NameDisplay + #13 +
                           //                              'This Title requires an associated consult request');
                MagAppMsg('D', 'There are No Consults available for Patient: ' + idmodobj.GetMagPat1.M_NameDisplay + #13 +
                  'This Title requires an associated consult request'); 
                           //statusbar1.Panels[0].text := FPatient + ' has No Consults available for selection.';
                Result := '';
                Exit;
              End;
            Finally
              t.Free();
            End;
          End; { this is a Consult Title}
        End; { if NewTitleConsultDA = '' }

        ////
        {HERE    - we are creating a New Note even though the Esig didn't work.
                    User was asked, and answered Okay to saving as Unsigned.}
         //maggmsgf.MagMsg('s','NewNote:    NewAuthorDuz : ' + clindataobj.NewAuthorDUZ);
        MagAppMsg('s', 'NewNote:    NewAuthorDuz : ' + ClinDataObj.NewAuthorDUZ); 
        idmodobj.GetMagDBBroker1.RPTIUCreateNote(Rstat, Rmsg,
          DFN, NewTitleDA, TmpUnsigned, 'S', TmpEsig, ClinDataObj.NewAuthorDUZ, NewLocationDA,
          NewDate, NewTitleConsultDA, Rtext); // memo1:Tstrings ); - later.
         {  if New Note attempted, regardless of result, Clear ClinDataObj.NewConsultDA}
        NewTitleConsultDA := '';
        If Not Rstat Then
        Begin
          Xmsg := 'Failed to Create New Note.';
             //maggmsgf.magmsg('de',xmsg + #13 + rmsg);
          MagAppMsg('de', Xmsg + #13 + Rmsg); 
             //maggmsgf.magmsg('s',rmsg);
          MagAppMsg('s', Rmsg); 
        End
        Else
          Result := Rmsg; {HERE}
        Exit;
      End; {if NewNote}

  {TODO: ERROR STATUS HANDLER FOR MOD NOTES.}
    End; {with ClinDataObj do}
  Finally
    Rtext.Free;
  End;

(*
  TMagTIUData = Class(Tobject)
  Public
    AuthorDUZ: String; {File 200 New Person: Author's DUZ}
    AuthorName: String; {File 200 New Person: Author's Name}
    DFN: String; {Patient DFN}
    DispDT: String; {Date of Report External format}
    IntDT: String; {Date of Report FM internal format}
    PatientName: String; {Patient NAME}
    Status: String; {status of Note}
    Title: String; {Title of Note: Free Text (8925.1) }
    TiuDA: String; {TIU DOCUMENT File 8925 DA}
    TiuParDA : string ;{TIU Parent DA, if this is Addendum}
    IsAddendum : boolean;  {/p129 gek/dmmn 12/17/12 TIU Type: normal or addendum}
    HasAddendums : boolean ; {129p18  }
    Procedure Assign(VTIUdata: TMagTIUData);
  End;

 {	New Object returned from the TIU Window.  Tells properties of the New Note
  or New Addendum or Selected Note.  Replaces 'tiuprtstr' as the mechanism to
                pass TIU Note Data.
  After Image is created, this object is querried to determine what needs to
                be done with TIU Note or if one needs created.}
  TClinicalData = class(TObject)
  public
    NewAuthor: string;          {File 200 New Person: Author's Name}
    NewAuthorDUZ: string;       {File 200 New Person: Author's DUZ}
    NewDate: string;            {Date internal or external}
    NewLocation: string;        {Hospital Location File  44 Name}
    NewLocationDA: string;      {Hospital Location File  44 DA}
    NewStatus: string;          {un-signed,AdminClosuer,Signed}
    NewTitle: string;           {TIU DOCUMENT DEFINITION 8925.1   Name }
    NewTitleDA: string;         {TIU DOCUMENT DEFINITION 8925.1   DA}
    NewTitleIsConsult: boolean; {Title is a Consult, must have Consult DA}
    NewTitleConsultDA : string; {The Patient Consult DA, we link to the Note.}
    NewVisit: string;           { NOT USED, THE TIU CALL, computes Visit}
    NewAddendum: Boolean;      {}
    NewAddendumNote: string;   {TIU Doucment 8925 IEN}
    NewNote: Boolean;          {}
    NewNoteDate: string;        {}
    NewText : Tstringlist;      { If user is adding text.}
    Pkg: string;                {8925 for TIU.}
    PkgData1: string;           {not used}
    PkgData2: string;           {not used}
    AttachOnly : boolean;       {if locked for Editing,Prompt to attach image}
    ReportData: TMagTIUData;    {if a selected note, this is the data}
    constructor Create;
    Destructor destroy; override;
    procedure Assign(vClinData : TClinicalData);
    function IsClear: boolean;  {tells if this object is void of data}
    procedure Clear;            {Clear all data from object}
    function GetClinDataStr : string;
    function GetActStatLong : string;
    function GetActStatShort : string;
    procedure LoadFromString(value : string);
    function GetCDSActStataLong(vClinDataStr : string): string;
    function GetCDSActStatShort(vClinDataStr : string): string;

  end;*)
End;

(*function CreateNewNote(var vtiuda,rmsg : string): boolean;
var rstat : boolean;
    rlist : Tstringlist;
    title,status,author,visit,location : string;
begin
  dmod.MagDBBroker1.RPTIULongListOfTitles(result,rmsg,rlist,'CP,NOTE,SUR,DS,CONS');
  maggmsgf.MagMsg('',rmsg);
  if not result then exit;
  //(var rmsg: string;t: tstrings;dfn : string; var vtitle,vstatus,vauthor,vvisit: string): boolean;
  //result := frmCapTIUNew.execute(rmsg,rlist,dmod.MagPat1.M_DFN,title,status,visit,author,location);
  if result then
    begin
      maggmsgf.MagMsg('', 'Creating New Note ...');
      {TODO:  have to add more parameters , author, location, visit}
      dmod.MagDBBroker1.RPTIUCreateNote(result,rmsg,dmod.MagPat1.M_DFN,title,status);
      if result
        then maggmsgf.MagMsg('','New Note Created: '+rmsg)
        else maggmsgf.MagMsg('','New Note Not Created: '+rmsg);
    end
    else maggmsgf.MagMsg('',rmsg);
end; *)

(*function SelectNewNoteData(vClinDataObj : TClinicalData;rmsg : string): boolean;
var rstat : boolean;
    rlist : Tstringlist;
    visit : string;
    title,status : string;
    author,loc : string;
    Fdfn : string;  {Need to pass this from other window.}
begin

//dmod.MagDBBroker1.RPTIULongListOfTitles(result,rmsg,rlist,'CP,NOTE,SUR,DS,CONS');
dmod.MagDBBroker1.RPTIULongListOfTitles(result,rmsg,rlist,'NOTE','');
maggmsgf.MagMsg('',rmsg);
if not result then exit;
//result := frmCapTIUNew.execute(rmsg,rlist,Fdfn,title,status,author,visit,loc);
if result then
  begin
    vClinDataObj := TClinicalData.create;
    vClinDataObj.NewTitle := title;
    vClinDataObj.NewStatus := status;
    vClinDataObj.NewAuthor := author;
    //vClinDataObj.NewDate
    vClinDataObj.NewVisit := visit;
    vClinDataObj.ReportData.Free;
    vClinDataObj.NewLocation := loc
  end;
end;

*)

(* function CreateAddendum(var vtiuda,vmsg: string; tiuda,adminclose: string):boolean;
var brkres :string;
   rstat : boolean;
   rmsg : string;
begin

  maggmsgf.MagMsg('', 'Creating New ADDENDUM ...');
  dmod.MagDBBroker1.RPTIUCreateAddendum(result,vmsg,vtiuda, tiuda,adminclose);
  if result
    then  maggmsgf.MagMsg('','Addendum Created: ' +  vmsg)
    else  maggmsgf.MagMsg('', 'Error: Addendum not created: ' + vmsg);

end;*)

(* //Out to test if compile
function SignNote(var vmsg : string; tiuda: string): boolean;
var res,esig :string;
begin
  result :=  frmEsigDialog.execute('Author',esig,dmod.MagDBBroker1);
  if result
    then vmsg := 'Signature is valid.'
    else
      begin
        vmsg := 'Invalid Signature';
        maggmsgf.MagMsg('d','Invalid Signature');
        exit;
    end;
  esig := encrypt(esig);
  result := dmod.MagDBBroker1.RPTIUSignRecord(res, dmod.MagPat1.M_DFN, tiuda,esig);
  if result
    then maggmsgf.MagMsg('','Note was siged.')
    else maggmsgf.MagMsg('d','Error Signing Note : '+res);
end;
*)


(* *******************   NOTE - cMagListView also has a Procedure that loads a TmagListView with TIU Data
   *******************          from the Results of teh TIU RPC Call.
                                Procedure TMagListView.LoadListFromoTIUList(t: Tstringlist);

   *******************   BUT    - they are different now.  Change in Capture 129t18 was needed.
   *******************           and not appropriate for Display. So Display still uses this call.
*)
Procedure TiuListToListView(t: Tstringlist; LV: TListView);
Var
  i: Integer;
  s: String;
  Li: TListItem;
//  TIUInfoPtr: ptrTIUInfo;
  TiuObj: TMagTIUData;
  CurViewStyle: Tviewstyle;
Begin

  LV.Visible := False;
  CurViewStyle := LV.ViewStyle;
  LV.ViewStyle := Vslist;

  //IF (lv.columns.count = 0 ) then LoadListViewColumns(lvPatientExams,t[0]);

  With LV Do
  Begin
    Try

      //while (lv.items.count > 0) do
      For i := 0 To LV.Items.Count - 1 Do
      Begin
        TiuObj := LV.Items[i].Data;
        //dispose(tiuinfoptr);
        TiuObj.Free;
      End;
      Items.Clear;
      If (t.Count = 0) Then Exit;

      AllocBy := t.Count + 3;

      For i := 0 To t.Count - 1 Do
      Begin
        Li := Items.Add;
        //StatusBar2.panels[0].text := inttostr(i+1)+' of '+ inttostr(t.count);
        //StatusBar2.update;
  // 162)=2452^General Note^2910528.1533^HOOD, ROBIN  (H2591)^
  //  10;MELANIE BUECHLER^^completed^Visit: 05/28/91^        ^^0
        If (Maglength(t[i], '^') < 14) Then //p8t38
        Begin
             //p8t38
          Li.caption := 'CORRUPT ENTRY';
             //maggmsgf.MagMsg('','Corrupt entry in Note Listing.');
          MagAppMsg('', 'Corrupt entry in Note Listing.'); 
             //maggmsgf.magmsg('s','*** entry = '+t[i]);
          MagAppMsg('s', '*** entry = ' + t[i]); 
//             TIUInfoPtr := NEW(ptrTIUInfo);
          TiuObj := TMagTIUData.Create;
          TiuObj.TiuDA := '0'; //strtoint(magpiece(t[i], '^', 1));
          TiuObj.IntDT := MagPiece(t[i], '^', 3);
          TiuObj.DispDT := FmtoDispDt(MagPiece(t[i], '^', 3));
          TiuObj.Title := MagPiece(t[i], '^', 2);
          TiuObj.AuthorDUZ := MagPiece(MagPiece(t[i], '^', 5), ';', 1);
          TiuObj.AuthorName := MagPiece(MagPiece(t[i], '^', 5), ';', 2);
             // Patch 7 t6 Added status of TIU Docuemnt ( for CP undictated)
          TiuObj.Status := MagPiece(t[i], '^', 7);

              // TIUInfoPtr.DFN :=  strtoint(             );
          TiuObj.PatientName := MagPiece(t[i], '^', 4);
        End
        Else
        Begin
          Li.caption := MagPiece(t[i], '^', 2);

        //TIUInfoPtr := NEW(ptrTIUInfo);
          TiuObj := TMagTIUData.Create;
          TiuObj.TiuDA := MagPiece(t[i], '^', 1);
          TiuObj.IntDT := MagPiece(t[i], '^', 3);
          TiuObj.DispDT := FmtoDispDt(MagPiece(t[i], '^', 3));
          TiuObj.Title := MagPiece(t[i], '^', 2);
          TiuObj.AuthorDUZ := MagPiece(MagPiece(t[i], '^', 5), ';', 1);
          TiuObj.AuthorName := MagPiece(MagPiece(t[i], '^', 5), ';', 2);
        // Patch 7 t6 Added status of TIU Docuemnt ( for CP undictated)
          TiuObj.Status := MagPiece(t[i], '^', 7);

 //cantDo/// The RPC that returns the data is not ours...   so this won't be a possibility
 //cantDo/////         TiuObj.IsAddendum := (MagPiece(t[i],'^',8) = '1');
        //      TIUInfoPtr.DFN :=  strtoint(             );
          TiuObj.PatientName := MagPiece(t[i], '^', 4);

          If idmodobj.GetMagPat1.M_UseFakeName Then
          Begin
            s := TiuObj.PatientName;
            MagReplaceString(', ', ',', s);
            TiuObj.PatientName := s;
          End;
        End; {else}
        Li.SubItems.Add(TiuObj.DispDT);
        //Li.SubItems.Add(magpiece(t[i],'^',4));
          // Patch 7 t6 Added status of TIU Docuemnt ( for CP undictated)
        Li.SubItems.Add(TiuObj.Status);
        Li.SubItems.Add(TiuObj.AuthorName);
        Li.SubItems.Add(MagPiece(t[i], '^', 11));
        Li.Data := TiuObj;
      End;
      //StatusBar2.panels[0].text := inttostr(t.count)+' Notes';
    Finally
      If LV.ViewStyle <> CurViewStyle Then LV.ViewStyle := CurViewStyle;
      LV.Visible := True;
    End;
  End;
End;

Procedure SetCPRSSyncDefaults(Xsync: CprsSyncOptions);
Begin

  Xsync.Queried := False;
  Xsync.SyncOn := True;
    Xsync.CprsHandle := 0;
  {129 Note:  these next aren't used. This is from early, early version of Interoperating with CPRS...
      never went to sites.}
  Xsync.PatSync := True;
  Xsync.PatSyncPrompt := False;
  Xsync.PatRejected := '';
  Xsync.ProcSync := True;
  Xsync.ProcSyncPrompt := False;
  Xsync.HandleSync := False;
  Xsync.HandleSyncPrompt := False;
  Xsync.HandleRejected := 0;
End;

End.
