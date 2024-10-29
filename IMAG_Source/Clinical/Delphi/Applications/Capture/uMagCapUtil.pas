Unit UMagCapUtil;
   {
   Package: MAG - VistA Imaging
   WARNING: Per VHA Directive 10-93-142 this unit should not be modified.
   Date Created:
   Site Name: Silver Spring, OIFO
   Developers: Garrett Kirin
   Description: Imaging Capture Application utilities.
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
Uses SysUtils,
  WinTypes,
  WinProcs,
  Messages,
  Classes,
  Graphics,
  Controls,
  Forms,
  Dialogs,
  Stdctrls,
  FileCtrl,
  Fmxutils,
  ExtCtrls
  ,
  Umagutils8,
  Maggut1,
  MagBroker,
  Geardef, {maggut4,}
  ComCtrls,
  cMagLVutils,
    ImagDMinterface, //DmSingle,
  cMagLabelNoClear,
  FmagDoNotClear,
  UMagClasses,
  // next are from Magguc3
  UMagDefinitions,
  FEdtLVlink,
 //RCA UMagTIUutil,
 imaginterfaces,
 fmagCapPatConsultList,
 fmagesigdialog,

 GearFORMATSlib_TLB,

  Trpcb  ,
  uMagCapDef
  ;
Type
  INIImageFormat = Record
    AUD: Boolean;
    BMP: Boolean;
    bw: Boolean;
    C256: Boolean;
    DICOM: Boolean;
    MV: Boolean;
    TCJPG: Boolean;
    TCTGA: Boolean;
    TIFG4: Boolean;
    TIFUN: Boolean;
    x: Boolean;
    XJPG: Boolean;
  End;

Function ConfirmSavingImage: Boolean;
//p117 not needed - Function ImportIniDesc(): String;  //106t10 p106 rlm 20101124 Fix Garrett's "Infinite loop dialogs"
Function OkToSaveImageAsIs: Boolean;
Function TookWarning: Boolean;
Function ValidAssociationFields: Boolean;
Function VALIDCategoryData: Boolean;
Function VALIDConsultData: Boolean;
Function ValidCPData: Boolean;
Function VALIDLabData: Boolean;
Function VALIDMedData: Boolean;
Function ValidPhotoIDData: Boolean;
Function VALIDRadData: Boolean;
 {/p117 add 'Flags' param.  Allow certain Static fields to be required, and display asterisk }
Function ValidStaticFields(Flags : string = ''): Boolean; 
Function VALIDSurData: Boolean;
Function VALIDTiuData: Boolean;
Function ValidTRCData: Boolean;
Function XwbGetVarValue2(Value: String): String;
Procedure CantDO;
Procedure CapTextCap;
Procedure CapTextPaste;
Procedure CapTextPrepare;
Procedure ClearAssociationFields(Ignorenoclear: Boolean = False);
Procedure ClearImageDescFields(Ignorenoclear: Boolean = False);
Procedure ClearIndexFields(Ignorenoclear: Boolean = False);
Procedure GetIndexPtrs(Var ProcEventPtr: String; Var SpecSubSpecPtr: String);
Procedure HideNoteInfoIcons;
Procedure INITAdminDoc;
Procedure INITClinImage;
Procedure INITClinProc;
Procedure InitClipboard;
Procedure INITimport;
Procedure INITlaboratory;
Procedure INITlumisys150;
Procedure INITlumisys75;
Procedure INITMedicine;
Procedure INITmeteor;
Procedure InitPhotoID;
Procedure INITradiology;
Procedure INITscanneddocument;
Procedure INITsurgery;
Procedure INITTeleReaderConsult();
Procedure INITtiu;
Procedure INITtwain;
Procedure LoadAssociationFields;
Procedure LoadGroupAssociationFields;
Procedure RefreshIndexType(cl: String);
Procedure ShowTagFields;
Procedure UnLockHiddenFields;
Procedure UnTagCleanHideAssocFields;
Function ResolveTIUNote(ClinDataObj: TClinicalData; Var Xmsg: String): String;
Function CheckEsig(Author: String; Var Xmsg: String; Var Esig: String; Var ContUnsign: Boolean): Boolean;
Var

    //140t1

//  F140MultSources : boolean;
//  F140PDFConvert  : boolean;
//
  FModeTest: Boolean;
  FTesting: Boolean;

 // FmIGSaveMode : integer; // enumIGPageSaveModes; // append, overwrite, etc.

//          SetCapGroup1(pFormat,   pPixelType,   pCompression,   pBitDepth: Integer);
//  MagTwain1.SetCapGroup1(mag_IG_FORMAT_BMP,mag_IG_TW_PT_RGB,mag_IG_COMPRESSION_NONE,8);

 { DONE -o129 : put the correct enums..  for the variables (not urgent) Low Priority}

//140/  FmIGSaveFormat: integer; //enumIGSaveFormats;
//140/  FmIGSaveJPEGQuality   : integer;

//140/  FmIGScanFormat : integer;
//140/  FmIGScanPixelType : integer;
//140/  FmIGScanCompression : integer;
//140/  FmIGScanBitDepth : integer;

Implementation
Uses
  FmagCapConfig,
  FmagCapMain;


Function ResolveTIUNote(ClinDataObj: TClinicalData; Var Xmsg: String): String;
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
  MagAppMsg('s', ' *** Get Clinical Data All : from Resolve TIU Note. ***');
  MagAppMsg('s', ClinDataDisplay);
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
        MagAppMsg('s', 'NewAddendum:    NewAuthorDuz : ' + ClinDataObj.NewAuthorDUZ);

        idmodobj.GetMagDBBroker1.RPTIUCreateAddendum(Rstat, Rmsg,
          DFN, ReportData.TiuDA, TmpUnsigned, 'S', TmpEsig, ClinDataObj.NewAuthorDUZ, NewDate, Rtext); // memo1:Tstrings ); - later.
        If Not Rstat Then
        Begin
          Xmsg := 'Failed to Create Addendum: ' + MagPiece(Rmsg, '^', 2);
          MagAppMsg('s', Rmsg);
        End
        Else
          Result := Rmsg;
        Exit;
      End; { if  NewAddendum}

      If NewNote Then
      Begin
        {    Create the New Note. Return the TIUDA }

        {TODO: Add possible NewNoteConsultDA}
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
                Rstat := FrmCapPatConsultList.Execute(VConsDA, t, NewTitle, idmodobj.GetMagPat1.M_NameDisplay);
                If Not Rstat Then {User didn't select a consult.}
                Begin
                  Xmsg := 'Consult wasn''t selected.';
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
        {   - we are creating a New Note even though the Esig didn't work.
              User was asked, and answered Okay to saving as Unsigned.}
        MagAppMsg('s', 'NewNote:    NewAuthorDuz : ' + ClinDataObj.NewAuthorDUZ); 
        idmodobj.GetMagDBBroker1.RPTIUCreateNote(Rstat, Rmsg,
          DFN, NewTitleDA, TmpUnsigned, 'S', TmpEsig, ClinDataObj.NewAuthorDUZ, NewLocationDA,
          NewDate, NewTitleConsultDA, Rtext); // memo1:Tstrings ); - later.
         {  if New Note attempted, regardless of result, Clear ClinDataObj.NewConsultDA}
        NewTitleConsultDA := '';
        If Not Rstat Then
        Begin
          Xmsg := 'Failed to Create New Note.';
          MagAppMsg('de', Xmsg + #13 + Rmsg);
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

(*  TmagTIUData = class(TObject)
  public
    AuthorDUZ: string;     {File 200 New Person: Author's DUZ}
    AuthorName: string;    {File 200 New Person: Author's Name}
    DFN: string;           {Patient DFN}
    DispDT: string;        {Date of Report External format}
    IntDT: string;         {Date of Report FM internal format}
    PatientName: string;   {Patient NAME}
    Status: string;        {status of Note}
    Title: string;         {Title of Note: Free Text (8925.1) }
    TIUDA: string;         {TIU DOCUMENT File 8925 DA}
    procedure Assign(vTIUdata : TmagTIUData);
  end;

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

Function CheckEsig(Author: String; Var Xmsg: String; Var Esig: String; Var ContUnsign: Boolean): Boolean;
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

Function XwbGetVarValue2(Value: String): String;
Begin
  idmodobj.GetMagDBBroker1.GetBroker.REMOTEPROCEDURE := 'XWB GET VARIABLE VALUE';
  idmodobj.GetMagDBBroker1.GetBroker.PARAM[0].PTYPE := Reference;
  idmodobj.GetMagDBBroker1.GetBroker.PARAM[0].Value := Value;
  Result := idmodobj.GetMagDBBroker1.GetBroker.STRCALL;
End;

Procedure INITlaboratory;
Begin
  With Frmcapmain Do
  Begin
    If Not OKToChangeSpec('LAB') Then Exit;
    UnTagCleanHideAssocFields;
    LbAssocDesc.caption := 'Laboratory';
    LbProcDate.caption := '*Specimen Date';
    EdtProcDate.Hint := 'Enter the Specimen Date';
    Magassoc := 'LAB';
    EdtStudy.Text := 'LAB';

    FmagAssoc := 'LAB';
    FClass := MagcapclsClin;

    btnLookupdata.caption := 'S&elect Laboratory Specimen';
    btnLookupdata.Onclick := LOOKUPlaboratory;
    LbProcDate.Tag := 1;

    cbOrigin.Tag := 1;
    btnLookupdata.Tag := 1;
    LbAccessionNo.Tag := 1;
    EAccessionNo.Tag := 1;
    cbStain.Tag := 1;
    cbMicro.Tag := 1;
    LbStain.Tag := 1;
    LbMicro.Tag := 1;

    RefreshIndexType(FClass);
    LbIndexType.Tag := 1;
    LbDocImageDate.Tag := 1;
    LbIndexProcEvent.Tag := 1;
    LbIndexSpecSubSpec.Tag := 1;

    ShowTagFields;
    MakeStudyReadOnly;


  End;
End;

Procedure INITMedicine;
Begin
  With Frmcapmain Do
  Begin
    If Not OKToChangeSpec('MED') Then Exit;
    UnTagCleanHideAssocFields;
    LbAssocDesc.caption := 'Medicine';
    LbProcDate.caption := '*Procedure Date';
    EdtProcDate.Hint := 'Enter the Procedure Date';
    Magassoc := 'MED';
    EdtStudy.Text := 'MED';
    FmagAssoc := 'MED';
    FClass := MagcapclsClin;

    btnLookupdata.caption := 'S&elect Medicine Procedure';
    btnLookupdata.Onclick := LOOKUPmedicine;
    LbProcDate.Tag := 1;
    cbOrigin.Tag := 1;
    btnLookupdata.Tag := 1;
    RefreshIndexType(FClass);
    LbIndexType.Tag := 1;
    LbDocImageDate.Tag := 1;
    LbIndexProcEvent.Tag := 1;
    LbIndexSpecSubSpec.Tag := 1;

    ShowTagFields;

    MakeStudyReadOnly;


  End; { with frmCapMain do }
End;

Procedure INITtiu;
Begin
  With Frmcapmain Do
  Begin
    If Not OKToChangeSpec('NOTES') Then Exit;
    UnTagCleanHideAssocFields;
    LbAssocDesc.caption := 'TIU';
    LbProcDate.caption := '*Note Date';
    EdtProcDate.Hint := 'Enter the Note Date';
    Magassoc := 'NOTES';
    LbStudy.caption := '*Note Title';
    EdtStudy.Text := '<Note Title>';

    FmagAssoc := 'NOTE';
    FClass := MagcapclsClin;

    btnLookupdata.caption := 'S&elect Progress Note';
    btnLookupdata.Onclick := LOOKUPtiu;
    LbNoteInfo.Tag := 1;
    LbNoteInfo.Visible := True;
    //btnVLDef.Visible := true;
    LbProcDate.Tag := 1;
    cbOrigin.Tag := 1;
    btnLookupdata.Tag := 1;

    RefreshIndexType(FClass);
    LbIndexType.Tag := 1;
    LbDocImageDate.Tag := 1;
    LbIndexProcEvent.Tag := 1;
    LbIndexSpecSubSpec.Tag := 1;

    ShowTagFields;

    MakeStudyReadOnly;


  End; { with frmCapMain do }
End;

Procedure INITClinProc;
Begin
  With Frmcapmain Do
  Begin
    If Not OKToChangeSpec('CP') Then Exit;
    UnTagCleanHideAssocFields;
    LbAssocDesc.caption := 'CP';
    LbProcDate.caption := '*Procedure Date';
    EdtProcDate.Hint := 'Enter the Procedure Date';
    Magassoc := 'CP';
    EdtStudy.Text := 'CP';

    FmagAssoc := 'CP';
    FClass := MagcapclsClin;

    btnLookupdata.caption := 'S&elect Clinical Procedure';
    btnLookupdata.Onclick := LOOKUPClinProc;
    LbProcDate.Tag := 1;
    cbOrigin.Tag := 1;
    btnLookupdata.Tag := 1;

    RefreshIndexType(FClass);
    LbIndexType.Tag := 1;
    LbDocImageDate.Tag := 1;
    LbIndexProcEvent.Tag := 1;
    LbIndexSpecSubSpec.Tag := 1;

    ShowTagFields;

    MakeStudyReadOnly;


  End; { with frmCapMain do }
End;

Procedure INITradiology;
Begin
  With Frmcapmain Do
  Begin
    If Not OKToChangeSpec('RAD') Then Exit;
    UnTagCleanHideAssocFields;
    LbAssocDesc.caption := 'Radiology';
    LbProcDate.caption := '*Exam Date';
    EdtProcDate.Hint := 'Enter the Exam Date';
    Magassoc := 'RAD';
    EdtStudy.Text := 'XRAY';

    FmagAssoc := 'RAD';
    FClass := MagcapclsClin;

    btnLookupdata.caption := 'S&elect Radiology Exam';
    btnLookupdata.Onclick := LOOKUPradiology;
    LbProcDate.Tag := 1;
    cbOrigin.Tag := 1;
    btnLookupdata.Tag := 1;

    EDayCaseNo.Tag := 1;
    LbDayCaseNo.Tag := 1;

    RefreshIndexType(FClass);
    LbIndexType.Tag := 1;
    LbDocImageDate.Tag := 1;
    LbIndexProcEvent.Tag := 1;
    LbIndexSpecSubSpec.Tag := 1;

    ShowTagFields;
    MakeStudyReadOnly;


  End;
End;

Procedure INITsurgery;
Begin
  With Frmcapmain Do
  Begin
    If Not OKToChangeSpec('SUR') Then Exit;
    UnTagCleanHideAssocFields;
    LbAssocDesc.caption := 'Surgery';
    LbProcDate.caption := '*Case Date';
    EdtProcDate.Hint := 'Enter the Case Date';
    Magassoc := 'SUR';
    EdtStudy.Text := 'SUR';

    FmagAssoc := 'SUR';
    FClass := MagcapclsClin;

    btnLookupdata.caption := 'S&elect Surgery Case';
    btnLookupdata.Onclick := LOOKUPSurgery;
    LbProcDate.Tag := 1;
    cbOrigin.Tag := 1;
    btnLookupdata.Tag := 1;

    RefreshIndexType(FClass);
    LbIndexType.Tag := 1;
    LbDocImageDate.Tag := 1;
    LbIndexProcEvent.Tag := 1;
    LbIndexSpecSubSpec.Tag := 1;

    ShowTagFields;
    MakeStudyReadOnly;

  End;
End;

Procedure INITTeleReaderConsult();
Begin
  With Frmcapmain Do
  Begin
    If Not OKToChangeSpec('TRC') Then Exit;
    UnTagCleanHideAssocFields;
        LbAssocDesc.caption := 'TRC';  //117 moved up for consistency.
    LbProcDate.caption := '*Consult Date';
    EdtProcDate.Hint := 'Enter the Consult Date';
    Magassoc := 'TRC';
    EdtStudy.Text := 'TRC';

{ TODO : 106 had 'TRC' commented out and 'CP' still used for FmagAssoc. need to look into this.}
    //FmagAssoc := 'TRC';
    FmagAssoc := 'CP';
    {/p117 gek 1/14/11 TeleReader is Clinical, need MagcapclsClin 106 T10}
    FClass := MagcapclsClin;  //FClass := MagclsAll;

    { TODO -oDick Maley -cPatch 106 : Add TRC (TeleReader Consult) to ini configuration. }

    btnLookupdata.caption := 'S&elect TeleReader Consult';

      LbIndexSpecSubSpec.caption := '*Specialty';
      LbIndexProcEvent.caption := '*Proc/Event';
    { TODO -oDick Maley -cPatch 106 : Replace LOOKUPClinProc with LookupTeleReaderConsult. }
    btnLookupdata.Onclick := LOOKUPTRConsult;
    LbProcDate.Tag := 1;
    cbOrigin.Tag := 1;
    btnLookupdata.Tag := 1;
    pnlDicomByUser.Tag := 1;  {/p117 gek, fix Design of data input}
    RefreshIndexType(FClass);
    LbIndexType.Tag := 1;
    LbDocImageDate.Tag := 1;
    LbIndexProcEvent.Tag := 1;
    LbIndexSpecSubSpec.Tag := 1;
(* //p117T3-CH1  Input Source doesn't depend on Association.
    INITimport;
    If FrmCapConfig.Import.Visible Then FrmCapConfig.Import.Visible := True;
    If FrmCapConfig.Import.Enabled Then FrmCapConfig.Import.Enabled := True;
    If FrmCapConfig.Import.Checked Then FrmCapConfig.Import.Checked := True;
    Application.Processmessages();
    FrmCapConfig.INITDICOMFormat;
   gek 117 took out the above two dependencies. *)
    ShowTagFields;
    { TODO -oDick Maley -cPatch 106 : Check if MakeStudyReadOnly is appropriate in this instance. }
    MakeStudyReadOnly;
//p117T3 gek 1/24/11 not needed.    LbAssocDesc.Visible := True;
//p117T3 gek 1/24/11 this is done above     LbAssocDesc.caption := 'TRC';


  End; { with frmCapMain do }

End;

Procedure InitPhotoID;
Var
  Xmsg: String;
  ResDateTime: String;
Begin
  With Frmcapmain Do
  Begin
    If Not OKToChangeSpec('PHOTOID') Then Exit;
    UnTagCleanHideAssocFields;

    LbAssocDesc.caption := 'Patient(Photo)';
    LbProcDate.caption := '*Photo ID Date';
    EdtProcDate.Hint := 'Enter the Date the Photo was taken';

    FrmCapConfig.SingleImage.Checked := True;
    Magassoc := 'PHOTOID';
    EdtStudy.Text := 'PHOTO ID';
    FLockStudy := True;
    EdtType.Text := 'PHOTO ID'; {59 }
    FmagAssoc := 'PHOTOID';

    FClass := MagcapclsAdmin;

    btnLookupdata.Onclick := btnLookupdataclick;
  //12/27/05    lbProcDate.tag := 1;
    LbDocImageDate.Tag := 1;
    cbOrigin.Tag := 1;

    ShowTagFields;

        {Just for Photo ID. We'll fill in the fields now}
    EdtStudy.Text := 'PHOTO ID'; //Patch 8, it was 'PHOTO ID';
    If RPFileManDate(Xmsg, 'T', ResDateTime) Then
    Begin
      DateTimeProc := MagPiece(ResDateTime, '^', 1);
      EdtProcDate.Text := MagPiece(DateTimeProc, '@', 1);
    End
    Else
    Begin
      EdtProcDate.Text := '';
      DateTimeProc := '';
    End;
      {2/20/02  Now that Short Desc can be saved in Config Button,
        We don't want a Date in it.  It'll stay and be put in
       when user clicks the ConfigButton, And it'll be wrong after today. }
    EdtImageDesc.Text := EdtStudy.Text; //+ ' ' + magpiece(edtProcDate.Text, '@', 1);

    //MakeStudyReadOnly;
     {    the call to MakeStudyReadOnly makes the Study and Study Date field read only
          we want the date field to be editable.  So we'll only make Study field read only}
    //edtStudy.Text := '';
    //10.16.2002 edtstudy.enabled := false;
    EdtStudy.TabStop := False;
    EdtStudy.ReadOnly := True;
  //testing out edtstudy.color := clBtnFace;

    EdtProcDate.TabStop := True;
    EdtProcDate.ReadOnly := False;
    EdtProcDate.Enabled := True; //5/16/2006  /p59
    btnProcDate.Enabled := True;
    EdtProcDate.Color := clWindow;


  End;
End;
//ADMINDOC

Procedure INITAdminDoc;
Begin

  With Frmcapmain Do
  Begin
    If Not OKToChangeSpec('ADMINDOC') Then Exit;
    UnTagCleanHideAssocFields;
    LbAssocDesc.caption := 'Patient(Admin)';
    LbProcDate.caption := '*Document Date';
    EdtProcDate.Hint := 'Enter the Form/Document Date';
    Magassoc := 'ADMINDOC';
    EdtStudy.Text := 'ADMIN';
    //haven't tried this> edtStudy.Text := 'Administrative Document';
    FLockStudy := True;
    FmagAssoc := 'ADMINDOC';
    FClass := MagcapclsAdmin;
    RefreshIndexType(FClass);
    LbIndexType.Tag := 1;
    LbDocImageDate.Tag := 1;
    btnLookupdata.Onclick := btnLookupdataclick;
  //12/27/05  lbProcDate.tag := 1; //  for categories.       9/24/99
    cbOrigin.Tag := 1;
    ShowTagFields;
    EdtProcDate.Text := '';
    EnableProcDate;

//MakeStudyReadOnly;
  End;

End;

Procedure INITClinImage;
Var
  t: TStrings;
Begin
  t := Tstringlist.Create;
  Try
    With Frmcapmain Do
    Begin
      If Not OKToChangeSpec('CLINIMAGE') Then Exit;
      UnTagCleanHideAssocFields;
      LbAssocDesc.caption := 'Patient(Clin)';
      LbProcDate.caption := '*Doc/Image Date';
      EdtProcDate.Hint := 'Enter the Document/Image Date';
      Magassoc := 'CLINIMAGE';
      EdtStudy.Text := 'CLIN';
   //haven't tried this>   edtStudy.Text := 'Clinical Image';
      FLockStudy := True;
      FmagAssoc := 'CLINIMAGE';
      FClass := MagcapclsClin;
      RefreshIndexType(FClass);
      LbIndexType.Tag := 1;
      LbDocImageDate.Tag := 1;
      LbIndexProcEvent.Tag := 1;
      LbIndexSpecSubSpec.Tag := 1;
      btnLookupdata.Onclick := btnLookupdataclick;
  //12/27/05    lbProcDate.tag := 1;
      cbOrigin.Tag := 1;
      ShowTagFields;
      EdtProcDate.Text := '';
      EnableProcDate;
//MakeStudyReadOnly;

    End;
  Finally
    t.Free;
  End;
End;

Procedure RefreshIndexType(cl: String);
Var
  t: Tstringlist;
  LastType: String;
Begin
  t := Tstringlist.Create;
  Try
    With Frmcapmain Do
    Begin
      LastType := EdtType.Text;
      EdtType.Text := '';
      ImgTypePtr := '';
      LvType.Selected := Nil;
      MagLvUtils1.ListView := LvType;
      Try
        idmodobj.GetMagDBBroker1.RPIndexGetType(t, cl);
        MagLvUtils1.LoadListFromStrings(t, False);

        // Now see if the lastSpec, is in the new list, and select it if it is.
        If (LastType <> '') And FEdtLV.GenOldTextInNewLV(LastType, LvType) Then
        Begin
          EdtType.Text := LvType.Selected.caption;
        End;
        If LvType.Selcount > 0 Then ImgTypePtr := MagPiece(TMagLVData(LvType.Selected.Data).Data, '^', 1);
     //////////////
      Except
    //
      End;
    End;
  Finally
    t.Free;
  End;
End;

Procedure INITlumisys75;
Begin
  MagTwain1.SourceClose;
  CapX.mSourceID :=  mcSrcLumisys75   ;
  frmCapconfig.DisplayCapX(CapX);
  With Frmcapmain Do
  Begin
    CapDeviceExecute.Onclick := Caplumisys75;

{btn Capture.Caption:='&Scan Film';}
    //Scanmode := 'Lumisys75';
    //LbInputSourceDesc.caption := 'Lumisys 75';
{showfields}
    HideImportDir;
    FrmCapConfig.DisableAllFormats;
    If IniFormat.x Then
    Begin
    FrmCapConfig.INITxray;
    //      FrmCapConfig.Xray.Enabled := True;
    //     FrmCapConfig.Xray.Checked := True;
    End;
  End;
  CapTextPrepare;
End;

Procedure INITlumisys150;
Begin
  MagTwain1.SourceClose;
  CapX.mSourceID :=  mcSrcLumisys150    ;
  frmCapconfig.DisplayCapX(CapX);
  With Frmcapmain Do
  Begin
    CapDeviceExecute.Onclick := Caplumisys150;

    //Scanmode := 'Lumisys150';
    {btn Capture.Caption:='&Scan Film';}
    //LbInputSourceDesc.caption := 'Lumisys150';
    HideImportDir;
    FrmCapConfig.DisableAllFormats;
    If IniFormat.x Then
    Begin
      FrmCapConfig.INITxray;
      //FrmCapConfig.Xray.Enabled := True;
      //FrmCapConfig.Xray.Checked := True;
    End;

  End;
  CapTextPrepare;
End;

Procedure INITmeteor;
Begin
  MagTwain1.SourceClose;
  CapX.mSourceID :=  mcSrcMeteor    ;
  frmCapconfig.DisplayCapX(CapX);

  With Frmcapmain Do
  Begin
    CapDeviceExecute.Onclick := CapMeteor;

    //Scanmode := 'Meteor';

    //LbInputSourceDesc.caption := 'Meteor/Orion';

    HideImportDir;
    FrmCapConfig.DisableAllFormats;

// CHANGED BECAUSE WE NO LONGER USE A LIST OF CHOICES FOR METEOR.
   (* frmCapConfig.cbMeteorInt.visible := true;
    frmCapConfig.bMetSettings.Visible := True;*)
//140t1 out    FrmCapConfig.PnlMeteorSource.Visible := True;
//140t1 changed    FrmCapConfig.PnlMeteorsettings.Visible := True;
    FrmCapConfig.PnlMeteorsettings.Enabled := True;
    //Otherdesc.caption := frmCapConfig.MeteorChoice.items[frmCapConfig.Meteorchoice.itemindex];
    If FrmCapConfig.cbMeteorInt.Checked Then
      Otherdesc.caption := 'Meteor Interactive mode'
    Else
      Otherdesc.caption := 'Meteor NON - Interactive mode';
    With IniFormat Do
    Begin
      If TCTGA Then FrmCapConfig.Color.Enabled := True;
      If TCJPG Then
      Begin
        FrmCapConfig.TrueColorJPG.Enabled := True;
        FrmCapConfig.TrueColorJPG.Checked := True;
      End;
      If bw Then FrmCapConfig.BlackAndWhite.Enabled := True;
    End;

  End;
  CapTextPrepare;
End;

Procedure INITtwain;
Begin
  CapX.mTwain := true;
  CapX.mTwainWindow := true;

  CapX.mSourceID :=  mcSrcTwain     ;
  frmCapconfig.DisplayCapX(CapX);
  With Frmcapmain Do
  Begin
    CapDeviceExecute.Onclick := CapTwain;

    //Scanmode := 'TWAIN';

    //LbInputSourceDesc.caption := 'TWAIN';

    HideImportDir;
    FrmCapConfig.DisableAllFormats;
    FrmCapConfig.PnlTwainSource.Visible := True;
    //frmCapConfig.DisableMultiPage;
    //EnableMultiPageScan;
    With IniFormat Do
    Begin
      If x Then FrmCapConfig.Xray.Enabled := True;
      If XJPG Then FrmCapConfig.XrayJPG.Enabled := True;
      If TCTGA Then FrmCapConfig.Color.Enabled := True;
      If bw Then FrmCapConfig.BlackAndWhite.Enabled := True;
      If TIFUN Then FrmCapConfig.Document.Enabled := True;
      If (C256 And IniColorscan256) Then FrmCapConfig.ColorScan.Enabled := True;
      If TCJPG Then FrmCapConfig.TrueColorJPG.Enabled := True;
      If TIFG4 Then
      Begin
        FrmCapConfig.DocumentG4.Enabled := True;
        FrmCapConfig.DocumentG4.Checked := True;
      End;
    End;
  End;
  FrmCapConfig.bTwainSource.Enabled := True;
  FrmCapConfig.btnTwainSettings.Enabled := true ; //p140t1
  {//p129t18 - we want to keep a Default Twain Source for this Workstation.}
  { Here, on INITTwain.  we will check to see if a Default exists in INI}
  { if no  Then Force a Select TWAIN source and save as Default}
  { If Yes, check the default from INI against Current Source.
      if different then Change to our Default Source if it still exists as a choice}


  CapTextPrepare;
End;

Procedure InitClipboard;
Begin
  MagTwain1.SourceClose;
  CapX.mSourceID :=  mcSrcClipboard      ;
  frmCapconfig.DisplayCapX(CapX);

  With Frmcapmain Do
  Begin
    CapDeviceExecute.Onclick := CapClipboard;

    //Scanmode := 'Clipboard';

    //LbInputSourceDesc.caption := 'Clipboard';

    HideImportDir;
    FrmCapConfig.DisableAllFormats;
    With IniFormat Do
    Begin
      If x Then FrmCapConfig.Xray.Enabled := True;
      If TCTGA Then FrmCapConfig.Color.Enabled := True;
      If bw Then FrmCapConfig.BlackAndWhite.Enabled := True;
      If TIFUN Then FrmCapConfig.Document.Enabled := True;
      If (C256 And IniColorscan256) Then FrmCapConfig.ColorScan.Enabled := True;
      //if BMP then frmCapConfig.bitmap.enabled := true;
      If TCJPG Then
      Begin
        FrmCapConfig.TrueColorJPG.Enabled := True;
        FrmCapConfig.TrueColorJPG.Checked := True;
      End;
      If TIFG4 Then FrmCapConfig.DocumentG4.Enabled := True;
    End;
  End;
  CapTextPaste;
End;


Procedure INITimport;
Begin
  MagTwain1.SourceClose;
  CapX.mSourceID :=  mcSrcImport  ;
  frmCapconfig.DisplayCapX(CapX);
  With Frmcapmain Do
  Begin

    CapDeviceExecute.Onclick := CapImport;
    //Scanmode := 'Import';
    //LbInputSourceDesc.caption := 'Import';
    ShowImportDir;
    Hidepanel.Hide;
    FrmCapConfig.DisableAllFormats;

    FrmCapConfig.PnlImportSource.Visible := True;

{3/10/97 gek make selection of imagetype mandatory on import also so comment
         out the checks on which type of import.  So object type gets set in
         IMaging file from click on ImageType  }
    If (ImportIni = '') Or (ImportIni = 'COPY') Then
    Begin
      //p106 rlm 20101117 Fix Garrett's "Infinite loop dialogs" Start
  {/p117 gek 1/24/11  taking off all 'hard coded' handling of Dicom TRC.  }
  (*  //P117 stop 'hard coded' handling of TRC.
       If FrmCapConfig.TeleReaderConsult.Checked Then
      Begin
        FrmCapConfig.INITDICOMFormat;
        If Not FrmCapConfig.Import.Checked Then FrmCapConfig.Import.Checked := True;
        FrmCapConfig.ImportFormat.Checked := False;
      End
      Else   *)
      Begin
        With IniFormat Do
        Begin
        If (ImportIni = 'COPY') Then
             //gek  ? DO I want this  next one.
             //  if frmCapConfig.ImportFormat.Checked then Otherdesc.caption := 'Copy to Server'
          FrmCapConfig.ImportFormat.Enabled := True;
          //  force a 'Click'
          if frmCapConfig.ImportFormat.Checked then frmCapConfig.ImportFormat.Checked := false;
          
          FrmCapConfig.ImportFormat.Checked := True;
          //
         If DICOM Then FrmCapConfig.DicomFormat.Enabled := True;
        End;
      End;
    End;
    (* 93 disabled TGA,
                {/p117 comment out the code} 
{TODO : delete the unused code after testing 117}
    If (Import_Ini = 'TGA') Then
    Begin
      FrmCapConfig.Color.Enabled := True;
      FrmCapConfig.Color.Checked := True;
    End;
    *)
    SetImportMaxHeight;
    SetImportBatchMaxHeight;
  End;
   {/p117 gek 1/24/11  taking off all 'hard coded' handling of Dicom TRC.  , comment out next line.}
  //117 out ImportIniDesc();//p106 rlm 20101124 Fix Fix Garrett's "Infinite loop dialogs" End
  CapTextCap;
End;

(*   this is 106 Pre T10....   
Procedure INITimport;
Begin
  With Frmcapmain Do
  Begin
    CapDeviceExecute.Onclick := CapImport;

  {}  Scanmode := 'Import';
    Lb InputSourceDesc.caption := 'Import';
    ShowImportDir;
    Hidepanel.Hide;
    FrmCapConfig.DisableAllFormats;

    FrmCapConfig.PnlImportSource.Visible := True;
{3/10/97 gek make selection of imagetype mandatory on import also so comment
         out the checks on which type of import.  So object type gets set in
         IMaging file from click on ImageType  }
    If (Import_Ini = '') Or (Import_Ini = 'COPY') Then
    Begin
      With IniFormat Do
      Begin
        If (Import_Ini = 'COPY') Then
          Otherdesc.caption := 'Copy to Server'
        Else
          Otherdesc.caption := 'Convert to ImageType';
        FrmCapConfig.ImportFormat.Enabled := True;
        FrmCapConfig.ImportFormat.Checked := True;
      End;
    End;
    If (Import_Ini = 'TGA') Then
    Begin
      Otherdesc.caption := 'Convert to TGA';
      FrmCapConfig.Color.Enabled := True;
      FrmCapConfig.Color.Checked := True;
    End;
    SetImportMaxHeight;
    SetImportBatchMaxHeight;
{ TODO : Here 106 is not using design of 'IMPORT' 'Copy to Server' or 'IMPORT' any selection
      as it was designed.   it simply does INITDicom regardless of what type of 'IMPORT' was
      seledcted......     .  need to FIX this.}
    If FrmCapConfig.TeleReaderConsult.Checked Then
    Begin
      FrmCapConfig.INITDICOMFormat;
      FrmCapConfig.Import.Checked := True;
    End;
  End;
  CapTextCap;
End;
   End of the old Procedure.  THIS NEEDS FIXED TO PRE 106.   The design is not to have INITImport do
   any thing other than INIT the Import... *)

Procedure INITscanneddocument;
Begin

  CapX.mTwain := true;
  CapX.mSourceID :=  mcSrcScanDoc   ;
  frmCapconfig.DisplayCapX(CapX);

  With Frmcapmain Do
  Begin
    CapDeviceExecute.Onclick := CapScannedDocument;

    //Scanmode := 'ScanDoc';

   // LbInputSourceDesc.caption := 'ScannedDocument';
    HideImportDir;

    FrmCapConfig.DisableAllFormats;
    FrmCapConfig.PnlTwainSource.Visible := True;
    EnableMultiPageScan;
    If IniFormat.TIFG4 Then
    Begin
      FrmCapConfig.DocumentG4.Enabled := True;
      FrmCapConfig.DocumentG4.Checked := True;
    End;
      {Patch 59, allow Scanned Doc to scan a Color Image}
    If IniFormat.TCJPG Then
    Begin
      FrmCapConfig.TrueColorJPG.Enabled := True;
    End;
   (* if (iniformat.C256 and iniColorscan256)
    then frmCapConfig.colorscan.enabled := true;*)

  End;
  FrmCapConfig.bTwainSource.Enabled := True;
  FrmCapConfig.btnTwainSettings.Enabled := true ; //p140t1
  CapTextCap;
End;

Procedure CapTextPrepare;
{var
tbmp : tbitmap;
begin
tbmp := tbitmap.create;
tbmp.loadfromfile(apppath+'\bmp\precap.bmp');}
Begin
   Frmcapmain.btnCapture.caption := '&Capture...';
   frmCapConfig.CapButtonCaption; 

{tbmp.free;}
End;

Procedure CapTextCap;
{var
tbmp : tbitmap;
begin
tbmp := tbitmap.create;
tbmp.loadfromfile(apppath+'\bmp\capture.bmp');}
Begin
  Frmcapmain.btnCapture.caption := '&Capture';
  frmCapConfig.CapButtonCaption;
  {tbmp.free;}
End;

Procedure CapTextPaste;
{var
tbmp : tbitmap;
begin
tbmp := tbitmap.create;
tbmp.loadfromfile(apppath+'\bmp\capture.bmp');}
Begin
  Frmcapmain.btnCapture.caption := 'Paste ';
    frmCapConfig.CapButtonCaption;
{tbmp.free;}
End;

//////////////////  magguc3 ^^ magguc1 VVV

Function VALIDLabData: Boolean;
Begin
  Result := False;
  If LabPtr = '' Then
  Begin
    Frmcapmain.WinMsg('d', 'You need to select a Lab Specimen.');
    Messagebeep(0);
    Frmcapmain.btnLookupdata.SetFocus;
    Exit;
  End;
  Result := True; {Scanned Docs VA and NonVA have the info in them.}
  Exit;
  { Patch 59 For Stain and Micro, only make it required if VA.
    When Scanning Outside Lab Reports a lot of times the information isn't
     known, or can't be found.}
  If (Frmcapmain.cbStain.ItemIndex = -1) And (Frmcapmain.cbOrigin.ItemIndex = 0) Then
  Begin
    Frmcapmain.cbStain.SetFocus;
    Frmcapmain.WinMsg('d', 'You need to select a Histological Stain.');
    Messagebeep(0);
    Exit;
  End;
  If (Frmcapmain.cbMicro.ItemIndex = -1) And (Frmcapmain.cbOrigin.ItemIndex = 0) Then
  Begin
    Frmcapmain.cbMicro.SetFocus;
    Frmcapmain.WinMsg('d', 'You need to select a Microscopic Objective.');
    Messagebeep(0);
    Exit;
  End;
  Result := True;
End;

Function VALIDRadData: Boolean;
Begin
  Result := False;
  If RadPtr = '' Then
  Begin
    Frmcapmain.WinMsg('d', 'You need to select a Radiology Exam.');
    Messagebeep(0);
    Frmcapmain.btnLookupdata.SetFocus;
    Exit;
  End;
  { the following shouldn't happen, when a Rad Exam is selected this field
     'eDayCaseNo'  is   filled .}
  If Frmcapmain.EDayCaseNo.Text = '' Then
  Begin
    Frmcapmain.WinMsg('d', 'You need to enter a Case Number.');
    Messagebeep(0);
    Frmcapmain.EDayCaseNo.SetFocus;
    Exit;
  End;
  // no longer worrying about teleconsult
  (*If (pos('Case No:',frmCapMain.imagelongdesc.Text)=0) and (frmCapConfig.teleconsult.checked) then
        begin
        frmCapMain.imagelongdesc.Lines.Add(' ');
        frmCapMain.imagelongdesc.Lines.Add('Case No: ' + frmCapMain.eDayCaseNo.text);
        end;*)
  Result := True;
End;

Function VALIDMedData: Boolean;
Begin
  Result := False;
  If MedPtr = '' Then
  Begin
    Frmcapmain.WinMsg('d', 'You need to select a Medicine Procedure.');
    Messagebeep(0);
    Frmcapmain.btnLookupdata.SetFocus;
    Exit;
  End;
  Result := True;
End;

Function VALIDTiuData: Boolean;
Var
  Retmsg, Vesig: String;
  ContUnsign: Boolean;
Begin
  Result := False;
  If Frmcapmain.FCapClinDataObj = Nil Then
  Begin
    Frmcapmain.WinMsg('d', 'You need to select a Note/Consult.');
    Messagebeep(0);
    Frmcapmain.btnLookupdata.SetFocus;
    Exit;
  End;
  If (Frmcapmain.FCapClinDataObj.NewNote = True) And (Frmcapmain.FCapClinDataObj.NewLocation = '') Then
  Begin
    Frmcapmain.WinMsg('d', 'You need to select a Visit Location.');
    Messagebeep(0);
    Frmcapmain.btnLookupdata.SetFocus;
    Exit;
  End;
  If (Not Frmcapmain.FCapClinDataObj.AttachToSigned)
    And (Frmcapmain.FCapClinDataObj.NewStatus = '2')
    And (Frmcapmain.FCapClinDataObj.EncryptedEsig = '') Then
  Begin
      {Need to get and encrypt a valid Esig.}
    If Not CheckEsig(Frmcapmain.FCapClinDataObj.NewAuthor, Retmsg, Vesig, ContUnsign) Then
    Begin
      If Not ContUnsign Then
      Begin
        Frmcapmain.WinMsg('', 'Image Save has been Canceled.');
        Exit;
      End
      Else
      Begin
        Frmcapmain.WinMsg('', 'Status changed Unsigned.  Continuing save...');
        Frmcapmain.FCapClinDataObj.NewStatus := '0';
        Frmcapmain.Edtnoteinfo.Text := Frmcapmain.FCapClinDataObj.GetActStatLong;
        Frmcapmain.Edtnoteinfo.Hint := Frmcapmain.Edtnoteinfo.Text;

        Frmcapmain.LoadNoteGlyphs(Frmcapmain.FCapClinDataObj);
      End;
    End
    Else
      Frmcapmain.FCapClinDataObj.EncryptedEsig := Vesig;
  End;
  Result := True;
End;

Function ValidCPData: Boolean;
Begin
  Result := False;
  If CPPtr = '' Then
  Begin
    Frmcapmain.WinMsg('d', 'You need to select a Clinical Procedure Request.');
    Messagebeep(0);
    Frmcapmain.btnLookupdata.SetFocus;
    Exit;
  End;
  Result := True;
End;



Function VALIDCategoryData: Boolean;
Begin
  // Was used for MAG DESC CTGs, Now a Call to see if TYPE has a value.
  // ImagTypePtr is a global variable that holds internal data for the Associated Package.
  If (Frmcapmain.EdtType.Text = '') Or (ImgTypePtr = '') Then
  Begin
    Result := False;
    Frmcapmain.WinMsg('d', 'You need to select a Document/Image Type.');
    Messagebeep(0);
    Frmcapmain.EdtType.SetFocus;
  End
  Else
    Result := True;
  { TODO : Proc/Event and Spec/SubSpec need defined here,
     have to assure a SpecSubSpec pointer exists, if SpecSubSpec Text has a value }

End;

Function VALIDSurData: Boolean;
Begin
  Result := False;
  If SurPtr = '' Then
  Begin
    Frmcapmain.WinMsg('d', 'You need to select a Surgery Case.');
    Messagebeep(0);
    Frmcapmain.btnLookupdata.SetFocus;
    Exit;
  End;
  Result := True;
End;

// we have this here to keep thing consistant.  There is no Association data to file.

Function ValidPhotoIDData: Boolean;
Var
  Fstat: Boolean;
  Rmsg: String;
  t: Tstringlist;
Begin
  t := Tstringlist.Create;
  Try
        {       Patch 8 Photo ID}
    If Magassoc = 'PHOTOID' Then
    Begin
        {       Get Internal Entry number for PHOTO ID from IMAGE INDEX FOR TYPES }
      idmodobj.GetMagDBBroker1.RPMag3LookupAny(Fstat, Rmsg, t, '2005.83^1^PHOTO ID^');
      If Fstat Then ImgTypePtr := MagPiece(t[1], '^', 2);
    End;
  {Result := false;
  if SurPtr = '' then
     begin
     frmCapMain.winmsg('','Need to ''Select Surgery Case'' !!'   );
     messagebeep(0);
     frmCapMain.btnLOOKUPdata.setfocus;
     exit;
     end; }
    Result := True;
  Finally
    t.Free;
  End;
End;

   { DONE :
We should change this funcion to also check for Proc/Event and Spec/Subspec
depending on a parameter sent.  That would keep the field checking in oue place,  
not only in the TRC Validity Check.  Proc/Event and Spec/Subspec may be 
required in the future by more than TRC. }
Function ValidStaticFields(Flags : string = '') : boolean ;
Begin
  Flags := uppercase(flags);
  Result := False;
  {validate the static fields, fields that are always required}
  If (idmodobj.GetMagPat1.M_DFN = '') Then
  Begin
    Frmcapmain.WinMsg('d', 'You need to Select a Patient.');
    Messagebeep(0);
    //MessageDlg('You must select a patient.', mtWarning, [mbOK], 0);
    Frmcapmain.btnPatient.SetFocus;
    Exit;
  End;
  If (Frmcapmain.EdtStudy.Text = '') Then
  Begin
    Frmcapmain.WinMsg('d', 'You need to select a ' + Frmcapmain.ReadableAssoc(Magassoc) + '.');
    Messagebeep(0);
    // MessageDlg('Study must be entered first', mtWarning, [mbOK], 0);
    If Frmcapmain.EdtStudy.Enabled Then Frmcapmain.EdtStudy.SetFocus;
    Exit;
  End;
  If Frmcapmain.EdtImageDesc.Text = '' Then
  Begin
    Frmcapmain.WinMsg('d', 'You need to enter an Image Description.');
    Messagebeep(0);
    //MessageDlg('Image Description must be entered first', mtWarning, [mbOK], 0);
    Frmcapmain.EdtImageDesc.SetFocus;
    Exit;
  End;
  {     Moved to ValidAssociationFields}
  (*  if DateTimeProc = '' then
  begin
    frmCapMain.winmsg('d', 'You need to enter a Study date.');
    messagebeep(0);
    //MessageDlg('You Must enter a Study Date !', mtWarning, [mbOK], 0);
    if (frmCapMain.edtProcDate.enabled and frmCapMain.edtProcDate.visible) then frmCapMain.edtProcDate.setfocus;
    exit;
  end;
*)
  //added check for type index - SAF 7/12/05
  If Frmcapmain.EdtType.Text = '' Then
  Begin
    If Magassoc = 'PHOTOID' Then
      Frmcapmain.EdtType.Text := 'PHOTO ID'
    Else
    Begin
      Frmcapmain.WinMsg('d', 'You need to select a Doc/Image Type.');
      Messagebeep(0);
      Frmcapmain.EdtType.SetFocus;
      Exit;
    End;
  End;

{/p117 moved the check for Proc/Event and Spec/Subspec here, out of TRC.  These are static fields
      not specific to TRC.}

  if (pos('S',FLAGS) > 0) then If Frmcapmain.EdtSpecSubSpec.Text = '' Then
  Begin
    Frmcapmain.WinMsg('d', 'You need to select a Specialty SubSpecialty Index.');
    Messagebeep(0);
    if Frmcapmain.EdtSpecSubSpec.Enabled then  Frmcapmain.EdtSpecSubSpec.SetFocus;
    Exit;
  End;
  if (pos('P',FLAGS) > 0) then if Frmcapmain.EdtProcEvent.Text = '' Then
  Begin
    Frmcapmain.WinMsg('d', 'You need to select a Procedure/Event index.');
    Messagebeep(0);
    if Frmcapmain.EdtProcEvent.Enabled then frmCapmain.EdtProcEvent.SetFocus;
    Exit;
  End;


  {     moved to ValidAssociationFields}
(*  if frmCapMain.edtDocImageDate.text = '' then
  begin
    frmCapMain.winmsg('d', 'You need to enter a Doc/Image Date.');
    messagebeep(0);
    frmCapMain.edtDocImageDate.setfocus;
    exit;
  end;
  *)
  Result := True;
End;

Function ValidAssociationFields: Boolean;
Begin
  Result := False;
  If Magassoc = '' Then
  Begin
    Frmcapmain.WinMsg('d', 'You need to select an Image Association.');
    Messagebeep(0);
  End;
  {     Everything needs a Doc/Image DateTime}
  If Frmcapmain.EdtDocImageDate.Text = '' Then
  Begin
    If FTesting Then
    Begin
      Frmcapmain.PnlReqMsg.Visible := True;
      Frmcapmain.PnlReqMsg.caption := '<<Required>>';
      Frmcapmain.WinMsg('e', 'You need to enter a Doc/Image Date.');
    End
    Else
      Frmcapmain.WinMsg('d', 'You need to enter a Doc/Image Date.');
    Messagebeep(0);
    Frmcapmain.EdtDocImageDate.SetFocus;

    Exit;
  End;
  If Magassoc = 'PHOTOID' Then
  Begin
    Result := ValidPhotoIDData;
    Exit;
  End;
  If Magassoc = 'ADMINDOC' Then
  Begin
    Result := VALIDCategoryData;
    Exit;
  End;
  If Magassoc = 'CLINIMAGE' Then
  Begin
    Result := VALIDCategoryData;
    Exit;
  End;

  {     Images Associated with a Proecure, need a Proc Date/Time}
  If DateTimeProc = '' Then
  Begin
    //Frmcapmain.WinMsg('d', 'You need to enter a Study date.');
    {/p117 change the generic message to be more specific.}
    Frmcapmain.WinMsg('d', 'You need to enter a ' +  frmCapMain.ReadableAssoc(magassoc)   + ' date.');
    Messagebeep(0);
    //MessageDlg('You Must enter a Study Date !', mtWarning, [mbOK], 0);
   if (frmCapMain.btnLookupdata.Visible and frmCapMain.btnLookupdata.Enabled) then
        Begin
        frmCapMain.btnLookupdata.SetFocus;
        exit;
        End;
    If (Frmcapmain.EdtProcDate.Enabled And Frmcapmain.EdtProcDate.Visible) Then Frmcapmain.EdtProcDate.SetFocus;
    Exit;
    end;

  If Magassoc = 'LAB' Then Result := VALIDLabData;
  If Magassoc = 'MED' Then Result := VALIDMedData;
  If Magassoc = 'RAD' Then Result := VALIDRadData;
  If Magassoc = 'SUR' Then Result := VALIDSurData;
  If Magassoc = 'NOTES' Then Result := VALIDTiuData;
  If Magassoc = 'CP' Then Result := ValidCPData;
  If Magassoc = 'TRC' Then Result := ValidTRCData;
End;

Function VALIDConsultData: Boolean;
Begin
  Result := False;
  // no longer worrying about teleconsult
  (*
  if Not frmCapConfig.teleconsult.checked then
     begin
     result := true;
     exit;
     end;
  If frmCapMain.ReqTel.Text='' then
     begin
     frmCapMain.winmsg('','Please enter telephone/contact info.');
     messagebeep(0);
     frmCapMain.ReqTel.setfocus;
     Exit;
     end;
  If frmCapMain.Urgency.Text='' then
     begin
     frmCapMain.winmsg('','Please select the Urgency of this Consult.');
     messagebeep(0);
     frmCapMain.Urgency.setfocus;
     Exit;
     end;
  result := true;
  *)
End;

Function OkToSaveImageAsIs: Boolean;
Var
  Bits : Integer;
Begin
    { we test Gear 1.imagebitspix,  and depending on the saveformat we can alert
     user to inconsistancey   or allow the save to procede}
    {//CPFIX 9/20/01 This is changed. We no longer care about the Image Format when
    doing an Import Copy. (long overdue )}
  If (CapX.mSourceID = mcSrcImport) And (ImportIni = 'COPY') Then
  Begin
    Result := True;
    Exit;
  End;

(*
    IG_SAVE_TIF_UNCOMP = $00000028;
  IG_SAVE_TIF_G3 = $00030028;
  IG_SAVE_TIF_G3_2D = $00050028;
  IG_SAVE_TIF_G4 = $00040028;
  IG_SAVE_TIF_HUFFMAN = $00020028;
  IG_SAVE_TIF_JPG = $00060028;
  IG_SAVE_TIF_LZW = $00080028;
  IG_SAVE_TIF_PACKED = $00010028;
  IG_SAVE_TIF_DEFLATE = $000E0028;

    IG_SAVE_TGA = $00000027;
*)

  (*
   IG_SAVE_PDF_UNCOMP = $00000038;
  IG_SAVE_PDF_JPG = $00060038;       **
  IG_SAVE_PDF_G3 = $00030038;
  IG_SAVE_PDF_G3_2D = $00050038;
  IG_SAVE_PDF_G4 = $00040038;        **
  IG_SAVE_PDF_RLE = $00070038;       **
  IG_SAVE_PDF_DEFLATE = $000E0038;
  IG_SAVE_PDF_LZW = $00080038;
  *)

  Result := False;
  Bits := Frmcapmain.mg1.GetBitsPerPixel;

  { Changed all savingformat = 8 to savingformat = IG_SAVE_TIF_G4
    and all savingformat = 0  to savingformat = IG_SAVE_TGA_UNCOMP,}
  Frmcapmain.WinMsg('s', 'In OkToSaveAsIs  Bits : ' + Inttostr(Bits));
  Frmcapmain.WinMsg('s', ' ****     savingformat: ' + Inttostr(CapX.mIGSaveFormat));
  Frmcapmain.WinMsg('s', ' ---IG_SAVE_TIF_UNCOMP: ' + Inttostr(IG_SAVE_TIF_UNCOMP));
  Frmcapmain.WinMsg('s', ' ---    IG_SAVE_TIF_G4: ' + Inttostr(IG_SAVE_TIF_G4));
  Frmcapmain.WinMsg('s', ' ---IG_SAVE_TIF_PACKED: ' + Inttostr(IG_SAVE_TIF_PACKED));
  Frmcapmain.WinMsg('s', ' ---        IG_SAVE_TGA: ' + Inttostr(IG_SAVE_TGA));

 //p140 quit if SaveTOPDF..  this is okey
if (CapX.mIGSaveFormat = IG_SAVE_PDF_JPG)
    or (CapX.mIGSaveFormat = IG_SAVE_PDF_G4)
    or (CapX.mIGSaveFormat = IG_SAVE_PDF_RLE)
    then
      begin
        result := true;
        exit;
      end;


// Patch 59.
  Case Bits Of                                               //IG_SAVE_PDF_JPG;   IG_SAVE_PDF_G4;
    24:
      If   (CapX.mIGSaveFormat <> IG_SAVE_TIF_PACKED)
            and (CapX.mIGSaveFormat <> IG_SAVE_TIF_UNCOMP)
            And (CapX.mIGSaveFormat <> IG_SAVE_TGA)
            And (CapX.mIGSaveFormat <> IG_SAVE_JPG)
            AND (CapX.mIGSaveFormat <> IG_SAVE_PDF_JPG)
            and (CapX.mIGSaveFormat <> IG_SAVE_PDF_G4)
            and (CapX.mIGSaveFormat <> IG_SAVE_PDF_RLE) Then
        Result := Not TookWarning //CantDO
      Else
        Result := True;

    8:
      Begin
        If (CapX.mIGSaveFormat <> IG_SAVE_TIF_PACKED)
        and (CapX.mIGSaveFormat <> IG_SAVE_TGA)
        And (CapX.mIGSaveFormat <> IG_SAVE_TIF_UNCOMP)
        And (CapX.mIGSaveFormat <> IG_SAVE_JPG) Then
        Begin
          (*CantDo;
          result := false;  *)
          Result := Not TookWarning;
        End
        Else
          Result := True;
      End;

    4:
      If (CapX.mIGSaveFormat = IG_SAVE_TIF_UNCOMP) Then
        Result := True
      Else
      Begin
        CantDO;
        Result := False;
      End;

    1:
      If (CapX.mIGSaveFormat = IG_SAVE_TIF_G4) Then
        Result := True
      Else
      Begin
        CantDO;
        Result := False;
      End;
  End;
(*  case bits of
    24: if (saveingformat = IG_SAVE_TIF_UNCOMP) or (saveingformat = IG_SAVE_TIF_G4)
      then result := not TookWarning //CantDO
      else result := true;

    8: begin
        if (saveingformat = IG_SAVE_TIF_G4) then
        begin
          {CantDo;
          result := false;  }
          result := not TookWarning;
          exit;
        end;
        if frmCapConfig.colorscan.checked or frmCapConfig.blackandwhite.checked or
          frmCapConfig.document.checked or frmCapConfig.xray.checked then result := true;
        if frmCapConfig.color.checked or frmCapConfig.truecolorJPG.checked then result := not TookWarning;
      end;

    4: if (saveingformat = IG_SAVE_TIF_G4) then result := not TookWarning //CantDo
      else result := not TookWarning;

    1: if (saveingformat = IG_SAVE_TIF_G4) or ((saveingformat = IG_SAVE_TIF_UNCOMP) and (not frmCapConfig.colorscan.checked)) then result := true
      else result := not TookWarning;
  end;  *)
End;

Function TookWarning: Boolean;
Var
  s: String;
Begin
  s := 'You are attempting to save a ' + Inttostr(frmCapMain.mg1.GetBitsPerPixel) + ' bit Image' + #13 +
    'as a ' + Frmcapmain.Lbformatdesc.caption + 'Image.' + #13 +
    'This is possible, but the Quality might not be as you expect.' + #13 + #13 +
    'You can ''Cancel'' and then  Re-Capture or change the Image Format.' + #13 + #13 +
    'OK to continue, Save as is ?';
  { if user clicks CANCEL then he took the warning}
  Result := (Messagedlg(s, MtWarning, [Mbok, Mbcancel], 0) = MrCancel);
End;

Procedure CantDO;
Var
  s: String;
Begin
  s := 'You are attempting to save a ' + Inttostr(frmCapMain.mg1.GetBitsPerPixel) + 'bit Image' + #13 +
    'as a ' + Frmcapmain.Lbformatdesc.caption + ' Image.' + #13 + #13 +
    'That type of Image Conversion is Not Allowed!!.';
  Messagedlg(s, Mterror, [Mbok], 0);
End;

Function ConfirmSavingImage: Boolean;
Var
  s, Suf: String;
  Xst: String[5];
  x: Integer;
  ImageInitialDFN, ImageInitialPatient: String;
Begin
  If (Frmcapmain.Lbformatdesc.caption = Nullsetting) Then
  Begin
    //
  End;
  ImageInitialDFN := idmodobj.GetMagPat1.M_DFN;
  ImageInitialPatient := idmodobj.GetMagPat1.M_NameDisplay;

  Suf := 'st,nd,rd,th,th,th,th,th,th,th,th,th,th,th,th,th,th,th,th,th';
  s := 'Saving...   ';
  x := Frmcapmain.Imageptrlst.Items.Count + 1;
  If x < 21 Then
    Xst := Inttostr(x) + MagPiece(Suf, ',', x Mod 20)
  Else
    Xst := Inttostr(x) + MagPiece(Suf, ',', x Mod 10);
  If FrmCapConfig.ImageGroup.Checked Then
    s := s + Xst + ' Image' + #13 +
      'Study Group   :  ' + Frmcapmain.EdtStudy.Text;
  s := s + #13 + 'Image desc      :  ' + Frmcapmain.EdtImageDesc.Text + #13 +
    'Image bits/pixel   :  ' + Inttostr(frmCapMain.mg1.GetBitsPerPixel) + ' bit' + #13 +
    'saving as ImageType   :  ' + Frmcapmain.Lbformatdesc.caption;

  If ((Frmcapmain.cbBatch.Checked) And (Frmcapmain.Lvbatch.Items.Count > 0)) Then
    s := 'Saving Batch...' + #13 +
      Inttostr(Frmcapmain.Lvbatch.Items.Count) + ' images.' + #13 +
      'Study Group   :  ' + Frmcapmain.EdtStudy.Text + #13 +
      'saving as ImageType   :  ' + Frmcapmain.Lbformatdesc.caption;
  Try
    Result := Messagedlg(s, Mtconfirmation, [Mbok, Mbcancel], 0) = MrOK;
    If Result And (idmodobj.GetMagPat1.M_DFN <> ImageInitialDFN) Then
    Begin
      Result := False;
      Messagebeep(MB_ICONEXCLAMATION);

      Flashwindow(Frmcapmain.Handle, True);
      Frmcapmain.WinMsg('e', 'Patient Changed, Saving the Image was CANCELED.');
    (*messagedlg('Saving this Image was CANCELED. The Patient has Changed ' +
               #13 +  #13 + 'From : ' + ImageInitialPatient +
               #13 + 'To    : ' + dmod.MagPat1.M_NameDisplay +
               #13 + #13 + '** Save was Canceled. Image was not saved ** ',mtconfirmation, [mbok],0);
               *)
    End;
  Finally
  //
  End;

End;

Procedure UnTagCleanHideAssocFields;
Begin
  With Frmcapmain Do
  Begin
//p106 start
  (*
    If FrmCapConfig.TeleReaderConsult.Checked Then
    Begin
      LbIndexSpecSubSpec.caption := '*Specialty';
      LbIndexProcEvent.caption := '*Proc/Event';
    End
    Else
    *)
    {/p117 when UnTagging ,and Cleaning up we'll put Caption back to normal.
      INITTeleConsult will put the "*" to show it is required.}
    Begin
      LbIndexSpecSubSpec.caption := 'Specialty';
      LbIndexProcEvent.caption := 'Proc/Event';
    End;
//p106 end....  
    {UnTagAssociationFields;}
    LbProcDate.Tag := 0;
    EdtProcDate.Tag := 0;
    LbDocImageDate.Tag := 0;
    EdtDocImageDate.Tag := 0;
    cbOrigin.Tag := 0;
    EDayCaseNo.Tag := 0;
    LbDayCaseNo.Tag := 0;
    pnlDicomByUser.Tag := 0; {/p117 gek}
    EAccessionNo.Tag := 0;
    LbAccessionNo.Tag := 0;
    btnLookupdata.Tag := 0;
    LbMicro.Tag := 0;
    cbMicro.Tag := 0;
    LbStain.Tag := 0;
    cbStain.Tag := 0;
    LbStudy.Tag := 1; // we'll always show study,
    LbStudy.caption := '*Study performed';
    EdtStudy.Tag := 1;
    LbNoteInfo.Tag := 0;
    LbNoteInfo.Visible := False;
    Edtnoteinfo.Hide;
    PnlNoteGlyph.Visible := False;
    btnVLDef.Visible := False;

    HideNoteInfoIcons;
    FLockStudy := False;
    // IndexFields Patch 8
    LbIndexType.Tag := 0;
    EdtType.Tag := 0;
    LbIndexProcEvent.Tag := 0;
    EdtProcEvent.Tag := 0;
    LbIndexSpecSubSpec.Tag := 0;
    EdtSpecSubSpec.Tag := 0;
    {HideAssociationFields;}
    LbStudy.Visible := False; //visible   2
    EdtStudy.Hide;
    LbProcDate.Visible := False; //visible     2
    btnProcDate.Hide;
    EdtProcDate.Hide;
//p59 Doc Image Date.
    LbDocImageDate.Visible := False;
    btnDocImageDate.Hide;
    EdtDocImageDate.Hide;
    cbOrigin.Hide;
    LbOrigin.Visible := False;
    EDayCaseNo.Hide;
    LbDayCaseNo.Visible := False; //visible     2
    pnlDicomByUser.Visible := false ; {/p117 gek}
    EAccessionNo.Hide;
    LbAccessionNo.Visible := False; //visible      2
    btnLookupdata.Hide;
    {   bvl is visible for Pkg Data.}
    bvlPkg.Hide;

    LbMicro.Visible := False; //visible      2
    cbMicro.Hide;
    LbStain.Visible := False; //visible       2
    cbStain.Hide;

    // IndexFields Patch 9
    LbIndexType.Visible := False; //visible    2
    EdtType.Hide;
    btnType.Hide;
    LvType.Hide;
    LbIndexProcEvent.Visible := False; //visible      2
    EdtProcEvent.Hide;
    btnProcEvent.Hide;
    LvProcEvent.Hide;
    LbIndexSpecSubSpec.Visible := False; //visible  2
    EdtSpecSubSpec.Hide;
    btnSpecSubSpec.Hide;
    LvSpecSubSpec.Hide;

    ClearAssociationFields(True); //{in UnTagCleanHideAssocFields}
    { TODO : Do We Clear the Index fields, when INITing an Association
      i.e. ClearIndexFields(true);
      or always user the NoClear Flag
      i.e. ClearIndexFields() ;    }

    ClearIndexFields;
    ClearImageDescFields; // 4/12/00

  End; {WITH frmCapMain DO}
End;

{procedure UnTagAssociationFields;
begin
PrDate.tag := 0;
eDayCaseNo.tag := 0;
lbDayCaseNo.tag := 0;
eAccessionNo.tag := 0;
lbAccessionNo.tag := 0;
btnLOOKUPdata.tag := 0;
lbMicro.tag := 0;
cbMicro.tag := 0;
lbStain.tag := 0;
cbStain.tag := 0;
end;}

{procedure HideAssociationFields;
begin
PrDate.hide;
eDayCaseNo.hide;
lbDayCaseNo.hide;
eAccessionNo.hide;
lbAccessionNo.hide;
btnLOOKUPdata.hide;
lbMicro.hide;
cbMicro.hide;
lbStain.hide;
cbStain.hide;
end;}

Procedure ClearIndexFields(Ignorenoclear: Boolean = False);
Begin

  With Frmcapmain Do
  Begin
    If (Ignorenoclear) Or (Not Frmcapmain.LbIndexType.NoClear) Then
    Begin
      ImgTypePtr := '';
      Frmcapmain.EdtType.Text := '';
      Frmcapmain.LvType.Selected := Nil;
      Frmcapmain.LvType.Visible := False;
      Frmcapmain.LvType.Update;
    End;
    ;
    If (Ignorenoclear) Or (Not Frmcapmain.LbIndexProcEvent.NoClear) Then
    Begin
      ImgProcEventPtr := '';
      Frmcapmain.EdtProcEvent.Text := '';
      Frmcapmain.LvProcEvent.Selected := Nil;
      Frmcapmain.LvProcEvent.Visible := False;
      Frmcapmain.LvProcEvent.Update;
      UpdateSpecFromProc;
      UpdateProcFromSpec;
    End;
    ;
    If (Ignorenoclear) Or (Not Frmcapmain.LbIndexSpecSubSpec.NoClear) Then
    Begin
      ImgSpecSubSpecPtr := '';
      Frmcapmain.EdtSpecSubSpec.Text := '';
      Frmcapmain.LvSpecSubSpec.Selected := Nil;
      Frmcapmain.LvSpecSubSpec.Visible := False;
      Frmcapmain.LvSpecSubSpec.Update;
      UpdateProcFromSpec;
      UpdateSpecFromProc;
    End;
    If (Ignorenoclear) Or (Not Frmcapmain.LbDocImageDate.NoClear) Then
    Begin
      //imgSpecSubSpecPtr := '';
      Frmcapmain.EdtDocImageDate.Text := '';
      //frmCapMain.lvSpecSubSpec.Selected := nil;
      //frmCapMain.lvSpecSubSpec.visible := false;
      //frmCapMain.lvSpecSubSpec.update;
      //UpdateProcFromSpec;
      //UpdateSpecFromProc;
    End;
    If (Ignorenoclear) Or (Not Frmcapmain.LbOrigin.NoClear) Then
    Begin
      cbOrigin.ItemIndex := GetDefaultOriginIndex;
    End;
  End;
End;

Procedure ClearAssociationFields(Ignorenoclear: Boolean = False);
//var hadassoc: boolean;
Begin
(*  if NOT((LABPTR = '') and (RADPTR = '') and (MEDPTR = '') and
    (tiuptr = '') and (cpptr = '') and (SURPTR = ''))
    then hadassoc := TRUE;*)

  With Frmcapmain Do
  Begin
//    edtDicomByUser.Text := ''; //p117 gek  always clear.  Not sure if want always ?  also cleared below.
    If (Ignorenoclear) Or (Not Frmcapmain.LbStudy.NoClear) Then
    Begin
      LabPtr := '';
      RadPtr := '';
      MedPtr := '';
      FCapClinDataObj.Free;
      FCapClinDataObj := TClinicalData.Create;
      CPPtr := '';
      SurPtr := '';
      LbDicom.caption := ''; {this is old field for Lucielles Test Dicom data fields.}

      {/p117 Question : there isn't any TRConsultPtr := null here... ? }
      TRConsultPtr := '' ; //p117 This wasn't here. Put in by gek.
      {/ What about other TRC Fields. TRC* ?}
      {/p117 new, clear the dicom data selected values. }
      {/p117 pnlDicomByUser  has edtDicomByUser. At moment edtDicom... doen't have a 'Hold' property. it will stay if Study stays}
       edtDicomByUser.Text :='';   //p117 gek , { TODO : this may need cleared other places.}
       FDicomDataUserArray.Clear;
       FDicomDataArray.clear;
       //p117  do we want to Clear Default array ?
       //  FDicomDefaultsArray.Clear;

      If Not FLockStudy Then
      Begin
        EdtStudy.Text := '';
        Edtnoteinfo.Text := '';
        btnVLDef.Visible := False; //5/24/06
        Edtnoteinfo.Hint := 'Type of Selected Note - Intended Status - Location';

        PnlNoteGlyph.Visible := False;

      End;
      HideNoteInfoIcons;
    End;

    ;
    // Patch 8  edtStudy.Text := '';
    If (Ignorenoclear) Or (Not Frmcapmain.LbProcDate.NoClear) Then
    Begin
      Frmcapmain.EdtProcDate.Text := '';
      DateTimeProc := '';
    End;
    If (Ignorenoclear) Or (Not Frmcapmain.LbDayCaseNo.NoClear) Then Frmcapmain.EDayCaseNo.Text := '';
    If (Ignorenoclear) Or (Not Frmcapmain.LbAccessionNo.NoClear) Then Frmcapmain.EAccessionNo.Text := '';

    If (Ignorenoclear) Or (Not Frmcapmain.LbMicro.NoClear) Then
    Begin
      Frmcapmain.cbMicro.Text := '';
      Frmcapmain.cbMicro.ItemIndex := -1;
    End;
    If (Ignorenoclear) Or (Not Frmcapmain.LbStain.NoClear) Then
    Begin
      Frmcapmain.cbStain.Text := '';
      Frmcapmain.cbStain.ItemIndex := -1;
    End;
   //  No longer consider the index fields as linked to the association.
   (* ClearIndexFields(ignorenoclear and hadassoc);
    ClearImageDescFields(ignorenoclear and hadassoc); // 4/14/00 *)
  End; {WITH frmCapMain DO}
End;

Procedure HideNoteInfoIcons;
Begin
  With Frmcapmain Do
  Begin
    PnlNoteBtns.Hide;
    ImgNoteNoText.Hide;
    ImgNoteText.Hide;
    ImgNoteBoiler.Hide;
  End;
End;

Procedure ClearImageDescFields(Ignorenoclear: Boolean = False);
Begin
  With Frmcapmain Do
  Begin
    If (Ignorenoclear) Or (Not Frmcapmain.LbImageDesc.NoClear) Then
    Begin
      EdtImageDesc.Text := '';
      Imagelongdesc.Lines.Clear;
    End;
  End;
End;

        {       Called each time we change Association.  We show/hide approiate fields.}

Procedure ShowTagFields;
Var
  i, j, y, Yinc, Tabs: Integer;
Begin
  Frmcapmain.SbxEditFields.VertScrollBar.Position := 0;
  y := 8;
  Tabs := 0;
  With Frmcapmain Do
  Begin
    Yinc := EdtPatName.Height + (EdtPatName.Height Div 4);
    If ((Frmcapmain.Height < 650) Or Fminimumseperation) Then
    Begin
      Yinc := EdtPatName.Height + 1;
      y := 1;
    End;
    If Doesformexist('frmDoNotClear') Then FrmDoNotClear.ClearItems; //WPR HOLD
    For i := 0 To TabSeqList.Count - 1 Do
    Begin
      j := Strtoint(MagPiece(TabSeqList[i], '_', 2));
      Case j Of
        100:
          Begin
            {capturebuttons_100.top := tmptop ;}
            btnCapture.Top := y;
            lbControlledImage.Top := y;
            cbBatch.Top := y;
            cbALLPages.Top := y;
            Inc(y, Yinc);
            btnCapture.TabOrder := Tabs;
            Inc(Tabs);
          End;
        200:
          Begin
            {PatientFields_200.top := tmptop ; }
            btnPatient.Top := y;
            pnlCCOW.top := y;
            pnlGearPat.Top := y;
            pnlGearPat.Height := btnPatient.Height + Yinc;
            Inc(y, Yinc);
            btnPatient.TabOrder := Tabs;
            Inc(Tabs);
            LbPatName.Top := y;
            ImgPatName.Top := y;
            FrmDoNotClear.AddItem(LbPatName); //WPR HOLD
            EdtPatName.Top := y;
            LbPtSSN.Top := y;
            PtSSN.Top := y;
            Inc(y, Yinc);
          End;
        300:
          Begin
            {DescField_300.top := tmptop ; }
            LbImageDesc.Top := y;
            ImgImageDesc.Top := y;
            FrmDoNotClear.AddItem(LbImageDesc);
            EdtImageDesc.Top := y;
            Inc(y, Yinc);
            If Yinc > 1 Then
              bvlImgDesc.Top := y - 1
            Else
              bvlImgDesc.Top := y;
            If Yinc > 1 Then y := y + 4;
            EdtImageDesc.TabOrder := Tabs;
            Inc(Tabs);
          End;
        400:
          Begin
            {SpecFields_400.top := tmptop ; }

            If btnLookupdata.Tag = 1 Then
            Begin
              If Yinc > 1 Then
                bvlPkg.Top := y - 1
              Else
                bvlPkg.Top := y;
              If Yinc > 1 Then y := y + 4;
              btnLookupdata.Top := y;
              PnlNoteBtns.Top := y;
              btnLookupdata.Show;
              bvlPkg.Show;
              Inc(y, Yinc);
              btnLookupdata.TabOrder := Tabs;
              Inc(Tabs);
            End;

            If LbStudy.Tag = 1 Then
            Begin
              LbStudy.Top := y;
              ImgStudy.Top := y;
              FrmDoNotClear.AddItem(LbStudy);
              EdtStudy.Top := y;
              LbStudy.Visible := True;
              EdtStudy.Show;
              Inc(y, Yinc);
              EdtStudy.TabOrder := Tabs;
              Inc(Tabs);
            End;
//===================== Patch 59 new Note Info.
            If LbNoteInfo.Tag = 1 Then
            Begin
              LbNoteInfo.Top := y;
              btnVLDef.Top := y + 2;
              ImgNoteInfo.Top := y;
              FrmDoNotClear.AddItem(LbNoteInfo);
              Edtnoteinfo.Top := y;
              PnlNoteGlyph.Top := y;
              LbNoteInfo.Visible := True;
              Edtnoteinfo.Show;
              //pnlNoteGlyph.visbile := true;
              PnlNoteBtns.Show;
               //btnVLDef.Visible := true;
              Inc(y, Yinc);
              Edtnoteinfo.TabOrder := Tabs;
              Inc(Tabs);
            End;
//====================

            If LbProcDate.Tag = 1 Then
            Begin

              LbProcDate.Top := y;
              ImgProcDate.Top := y;
              FrmDoNotClear.AddItem(LbProcDate);
              btnProcDate.Top := y + 2;
              EdtProcDate.Top := y;

              LbProcDate.Visible := True;
              btnProcDate.Show;
              EdtProcDate.Show;
              (* added for Origin 3.0.8.21  p8t21
                // moved to be on same line as DocImageDateTime
              lbOrigin.top := y;
              imgOrigin.top := y;
              frmDoNotClear.AddItem(lbOrigin);
              cbOrigin.top := y;
              cbOrigin.Show;
              lbOrigin.Visible := true;
              *)
              Inc(y, Yinc);
              {   bvl Height is moved to whatever is last visible}
              //bvlPkg.Height := y -2 - bvlPkg.top;
              EdtProcDate.TabOrder := Tabs;
              Inc(Tabs);
              //cbOrigin.TabOrder := tabs; inc(tabs);
            End;

            If LbDayCaseNo.Tag = 1 Then
            Begin
              LbDayCaseNo.Top := y;
              ImgDayCaseNo.Top := y;
              FrmDoNotClear.AddItem(LbDayCaseNo);
              EDayCaseNo.Top := y;
              LbDayCaseNo.Visible := True;
              EDayCaseNo.Show;
              Inc(y, Yinc);
              {   bvl Height is moved to whatever is last visible}
              //bvlPkg.Height := y -2 - bvlPkg.top;
              EDayCaseNo.TabOrder := Tabs;
              Inc(Tabs);
            End;

            if pnlDicomByUser.Tag = 1 then  {/p117 gek, fix data entry design, enable entry before 'ImageOK'}
            begin
              //
              pnlDicomByUser.Top := y;
              pnlDicomByUser.Visible := true;
              inc(y,Yinc);
              pnlDicomByUser.TabOrder := tabs;
              inc(tabs);
            end;



            If LbAccessionNo.Tag = 1 Then
            Begin
              LbAccessionNo.Top := y;
              ImgAccessionNo.Top := y;
              FrmDoNotClear.AddItem(LbAccessionNo);
              EAccessionNo.Top := y;
              LbAccessionNo.Visible := True;
              EAccessionNo.Show;
              Inc(y, Yinc);
              {   bvl Height is moved to whatever is last visible}
              //bvlPkg.Height := y -2 - bvlPkg.top;
              EAccessionNo.TabOrder := Tabs;
              Inc(Tabs);
            End;

            If LbMicro.Tag = 1 Then
            Begin
              LbMicro.Top := y;
              ImgMicro.Top := y;
              FrmDoNotClear.AddItem(LbMicro);
              cbMicro.Top := y;
              LbMicro.Visible := True;
              cbMicro.Show;
              Inc(y, Yinc);
              {   bvl Height is moved to whatever is last visible}
              //bvlPkg.Height := y -2 - bvlPkg.top;
              cbMicro.TabOrder := Tabs;
              Inc(Tabs);
            End;
            If LbStain.Tag = 1 Then
            Begin
              LbStain.Top := y;
              ImgStain.Top := y;
              FrmDoNotClear.AddItem(LbStain);
              cbStain.Top := y;
              LbStain.Visible := True;
              cbStain.Show;
              Inc(y, Yinc);
              {   bvl Height is moved to whatever is last visible}
              //bvlPkg.Height := y -2 - bvlPkg.top;
              cbStain.TabOrder := Tabs;
              Inc(Tabs);
            End;
            // Patch 9 New index fields.
(*
    lbIndexType.tag := 0;
    cbIndexType.tag := 0;
    lbIndexProcEvent.tag := 0;
    cbIndexProcEvent.tag := 0;
    lbIndexSpecSubSpec.tag := 0;
    cbIndexSpecSubSpec.tag := 0;
*)

//Patch 59 added DocImageDate
            If LbDocImageDate.Tag = 1 Then
            Begin
              If Yinc > 1 Then
                bvlDocImage.Top := y - 1
              Else
                bvlDocImage.Top := y;
              If Yinc > 1 Then y := y + 4;
              LbDocImageDate.Top := y;
              ImgDocImageDate.Top := y;
              FrmDoNotClear.AddItem(LbDocImageDate);
              EdtDocImageDate.Top := y;
              btnDocImageDate.Top := y + 2;
              LbDocImageDate.Visible := True;
              EdtDocImageDate.Show;
              btnDocImageDate.Show;
              // Moved Origin Here, Patch 59 when DocImageDatefield added.
              LbOrigin.Top := y;
              ImgOrigin.Top := y;
              FrmDoNotClear.AddItem(LbOrigin);
              cbOrigin.Top := y;
              cbOrigin.Show;
              LbOrigin.Visible := True;
              //
              Inc(y, Yinc);
              EdtDocImageDate.TabOrder := Tabs;
              Inc(Tabs);
              cbOrigin.TabOrder := Tabs;
              Inc(Tabs);
            End;

            If LbIndexType.Tag = 1 Then
            Begin
              LbIndexType.Top := y;
              ImgIndexType.Top := y;
              FrmDoNotClear.AddItem(LbIndexType);
              EdtType.Top := y;
              btnType.Top := y + 2;
              LvType.Top := EdtType.Top + EdtType.Height + Panel1.Top + 5;
              LvType.Left := EdtType.left + 20; //p140t1
              LbIndexType.Visible := True;
              EdtType.Show;
              btnType.Show;
              Inc(y, Yinc);
              EdtType.TabOrder := Tabs;
              Inc(Tabs);
            End;

            If LbIndexSpecSubSpec.Tag = 1 Then
            Begin
              LbIndexSpecSubSpec.Top := y;
              ImgIndexSpecSubSpec.Top := y;
              FrmDoNotClear.AddItem(LbIndexSpecSubSpec);
              EdtSpecSubSpec.Top := y;
              btnSpecSubSpec.Top := y + 2;
              LvSpecSubSpec.Top := EdtSpecSubSpec.Top + EdtSpecSubSpec.Height + Panel1.Top + 5;
              LvSpecSubSpec.Left := EdtSpecSubSpec.left + 30; //p140t1
              LbIndexSpecSubSpec.Visible := True;
              EdtSpecSubSpec.Show;
              btnSpecSubSpec.Show;
              Inc(y, Yinc);
              EdtSpecSubSpec.TabOrder := Tabs;
              Inc(Tabs);
            End;

            If LbIndexProcEvent.Tag = 1 Then
            Begin
              LbIndexProcEvent.Top := y;
              ImgIndexProcEvent.Top := y;
              FrmDoNotClear.AddItem(LbIndexProcEvent);
              EdtProcEvent.Top := y;
              btnProcEvent.Top := y + 2;
              LvProcEvent.Top := EdtProcEvent.Top + EdtProcEvent.Height + Panel1.Top + 5;
              LvProcEvent.Left := EdtProcEvent.left + 40; //p140t1
              LbIndexProcEvent.Visible := True;
              EdtProcEvent.Show;
              btnProcEvent.Show;
              Inc(y, Yinc);
              EdtProcEvent.TabOrder := Tabs;
              Inc(Tabs);
            End;

          End;
        500:
          Begin
            {OkCancel_500.top := tmptop ;    }
            btnReview.top := y;
            btnReview.TabOrder := Tabs;
            inc(tabs);

            btnImageOK.Top := y;
            btnImageOK.TabOrder := Tabs;
            Inc(Tabs);

            btnCancelScan.Top := y;
            btnCancelScan.TabOrder := Tabs;
            Inc(Tabs);

            btnStudyComplete.Top := y;
            btnStudyComplete.TabOrder := Tabs;
            Inc(Tabs);
            Inc(y, Yinc);
          End;

      End;

    End;
    //UnLockHiddenFields;
  End; {WITH frmCapMain DO}
  Frmcapmain.SbxEditFields.VertScrollBar.Range := y + 30;
End;

Procedure UnLockHiddenFields;
Var
  i: Integer;
Begin
  With Frmcapmain.SbxEditFields Do
  Begin
    For i := 0 To ControlCount - 1 Do
    Begin
      If Controls[i] Is TmagLabelNoClear Then
      Begin
        If Controls[i].Tag = 0 Then TmagLabelNoClear(Controls[i]).NoClear := False;
      End;
    End;
  End;
End;

Procedure LoadAssociationFields;
//var fstat : boolean;
//  t : tstringlist;
Begin
//  t := tstringlist.create;
  With Frmcapmain Do
  Begin
    { this call is made for the individule images of a group, or the single image itself.}
    If Magassoc = 'LAB' Then
    Begin
      XBROKERX.PARAM[0].Mult['"PATHACCNO"'] := '50^' + MagPiece(LabPtr, '^', 4);
      XBROKERX.PARAM[0].Mult['"PATHSPECDSC"'] := '51^' + MagPiece(LabPtr, '^', 6);
      XBROKERX.PARAM[0].Mult['"PATHSPECNO"'] := '52^' + MagPiece(LabPtr, '^', 11);
      If cbStain.ItemIndex <> -1 Then
        XBROKERX.PARAM[0].Mult['"PATHSTAIN"'] := '53^' + MagPiece(cbStain.Items[cbStain.ItemIndex], '^', 2);
      If cbMicro.ItemIndex <> -1 Then
        XBROKERX.PARAM[0].Mult['"PATHMICRO"'] := '54^' + MagPiece(cbMicro.Items[cbMicro.ItemIndex], '^', 2);
    End;

    { the other Association's don't have explicit data to store in the imaging file
       like lab's Stain, and Micro etc.}
    {
    IF magassoc = 'MED' THEN LoadMedData ;
    IF magassoc = 'RAD' THEN LoadRadData ;
    IF magassoc = 'SUR' THEN LoadSurData ;
    IF magassoc = 'NONE' THEN  ;}

    //Patch 8 Photo ID
    // CAN'T DO THIS HERE, IT CLEARS THE BROKER param[0].mult,
      (*    if magassoc = 'PHOTOID' then
                begin
                dmod.MagDBBroker1.RPMag3LookupAny(fstat,t,'2005.83^1^PHOTO ID^');
                if fstat then imgtypeptr := magpiece(t[1],'^',2);
                end;
      *)
    XBROKERX.PARAM[0].Mult['"INDEXTYPE"'] := '42^' + ImgTypePtr; //11/05/2002 All Images need Type
    GetIndexPtrs(ImgProcEventPtr, ImgSpecSubSpecPtr); //WPR INDEX
    If (ImgProcEventPtr <> '') Then
      XBROKERX.PARAM[0].Mult['"PROCEVENT"'] := '43^' + ImgProcEventPtr;
    If (ImgSpecSubSpecPtr <> '') Then
      XBROKERX.PARAM[0].Mult['"SPECSUBSPEC"'] := '44^' + ImgSpecSubSpecPtr;
  End; {WITH frmCapMain DO}
End;

Procedure LoadGroupAssociationFields;
Begin
  With Frmcapmain Do
  Begin
    { this call is made when filing the Group Image entry in the Image file }

    // Only  Groups with specialities of 'NONE' , where user selects a Categroy do we
    // have to store data in the Group Image Entry in the Image file.
    // Other specialites set the Pointers in the Image file in 'FileAssociationPointers' Call

    // The Pointer to the MAG DESCRIPTIVE Category file are stored in the Group, and in the
    // individule image entries,   Later there might be the possibility of Sub-categories or of
    // the categories being different amoung images in a group
     (* All Images have ImgTypePtr, so the If... is not needed  //11/05/2002 All Images need Type
    if (magassoc = 'CLINIMAGE') and (ImgTypePtr <> '') then
    begin
      xBrokerx.Param[0].Mult['"NONETYPE"'] := '42^' + ImgTypePtr;
    end;
    //ADMINDOC
    if (magassoc = 'ADMINDOC') and (ImgTypePtr <> '') then
    begin
      { TODO : Add other fields for Admin Doc  i.e. 'ADMIN' for new set of codes. }
      xBrokerx.Param[0].Mult['"ADMINTYPE"'] := '42^' + ImgTypePtr;
    end; *)
    XBROKERX.PARAM[0].Mult['"INDEXTYPE"'] := '42^' + ImgTypePtr; //11/05/2002 All Images need Type
    GetIndexPtrs(ImgProcEventPtr, ImgSpecSubSpecPtr);
    If (ImgProcEventPtr <> '') Then
      XBROKERX.PARAM[0].Mult['"PROCEVENT"'] := '43^' + ImgProcEventPtr;
    If (ImgSpecSubSpecPtr <> '') Then
      XBROKERX.PARAM[0].Mult['"SPECSUBSPEC"'] := '44^' + ImgSpecSubSpecPtr;

  End; {WITH frmCapMain DO}
End;

Procedure GetIndexPtrs(Var ProcEventPtr: String; Var SpecSubSpecPtr: String);
Var
  Li: TListItem;
Begin
  ProcEventPtr := ''; //WPR INDEX
  SpecSubSpecPtr := '';
  With Frmcapmain Do
  Begin
    If (EdtProcEvent.Text <> '') Then
    Begin
      // TMagLVData has 'data' property that is a string of Internal^External for list item.
      Li := LvProcEvent.Selected;
      If (Li <> Nil) Then
        ProcEventPtr := MagPiece(TMagLVData(Li.Data).Data, '^', 1)
      Else
        ; // Review if Test for: Text in Edit box, and No Entry selected, is needed here.
    End;
    If (EdtSpecSubSpec.Text <> '') Then
    Begin
      Li := LvSpecSubSpec.Selected;
      If (Li <> Nil) Then
        SpecSubSpecPtr := MagPiece(TMagLVData(Li.Data).Data, '^', 1)
      Else
        ; // Review if Test for: Text in Edit box, and No Entry selected, is needed here.
    End;

  End;
End;


Function ValidTRCData: Boolean;
Begin
  Result := False;
  If TRConsultPtr = '' Then
  Begin
    Frmcapmain.WinMsg('d', 'You need to select a TeleReader Consult.');
    Messagebeep(0);
    Frmcapmain.btnLookupdata.SetFocus;
    Exit;
  End;
  { DONE : /p117 gek 1/28/11 we should check the stringlist that holds the user supplied Dicom Values.}
  {  Clarified 2/1/11 :  we Don't  need Dicom Field data now.  }
{  if frmcapmain.edtDicomByUser.Text = '' then
  Begin
    Frmcapmain.WinMsg('d', 'You need to select values for Dicom properties.');
    Messagebeep(0);
    Frmcapmain.edtDicomByUser.SetFocus;
    Exit;
  End;   }

{/p117 gek  Index fields are 'Static' field. the check of those fields is moved to 
          the Function :  ValidStaticFields.  Index Fields are checked there.}
(*  If Frmcapmain.EdtSpecSubSpec.Text = '' Then
  Begin
    Frmcapmain.WinMsg('d', 'You need to select a Specialty SubSpecialty Index.');
    Messagebeep(0);
    Frmcapmain.EdtSpecSubSpec.SetFocus;
    Exit;
  End;
  If Frmcapmain.EdtProcEvent.Text = '' Then
  Begin
    Frmcapmain.WinMsg('d', 'You need to select a Procedure/Event index.');
    Messagebeep(0);
    Frmcapmain.EdtProcEvent.SetFocus;
    Exit;
  End;
  *)
  Result := True;
End;

(*  //p117 not needed -
Function ImportIniDesc(): String;//p106 rlm 20101124 Fix Garrett's "Infinite loop dialogs"
Begin
EXIT;
   {/p117 gek, stop special handling for TelereaderConsult.
  Result:='';
  If (Import_Ini = '') Or (Import_Ini = 'COPY') Then
  Begin
    If FrmCapConfig.TeleReaderConsult.Checked Then
        {This 'Association' is changing an Input Source,  Associations don't modify Input Sources.}
    Begin
      Result:='Convert to DICOM';
    End
    Else
    Begin
      With IniFormat Do
      Begin
        If (Import_Ini = 'COPY') Then
          Result := 'Copy to Server'
        Else
          Result := 'Convert to ImageType';
      End;
    End;
  End;
  If (Import_Ini = 'TGA') Then
  Begin
    Result := 'Convert to TGA';
  End;
  If Frmcapmain<> nil Then
    If Frmcapmain.Otherdesc.caption<>Result Then Frmcapmain.Otherdesc.caption := Result;
  If FrmCapConfig<>nil Then
    If FrmCapConfig.LbImportMode.caption<>Result Then FrmCapConfig.LbImportMode.caption := Result;

    }
End;
*)

(*

// Constants for enum enumIGSaveFormats
type
  enumIGSaveFormats = TOleEnum;
const
  IG_SAVE_UNKNOWN = $00000000;
  IG_SAVE_BRK_G3 = $00030003;
  IG_SAVE_BRK_G3_2D = $00050003;
  IG_SAVE_BMP_RLE = $00070002;
  IG_SAVE_BMP_UNCOMP = $00000002;
  IG_SAVE_CAL = $00000004;
  IG_SAVE_CLP = $00000005;
  IG_SAVE_DCX = $00000008;
  IG_SAVE_EPS_UNCOMP = $0000000A;
  IG_SAVE_EPS_JPG = $0006000A;
  IG_SAVE_EPS_G3 = $0003000A;
  IG_SAVE_EPS_G4 = $0004000A;
  IG_SAVE_GIF = $0000000E;
  IG_SAVE_ICA_G3 = $00030010;
  IG_SAVE_ICA_G4 = $00040010;
  IG_SAVE_ICA_IBM_MMR = $000F0010;
  IG_SAVE_ICO = $00000011;
  IG_SAVE_IMT = $00000014;
  IG_SAVE_IFF = $00000012;
  IG_SAVE_IFF_RLE = $00070012;
  IG_SAVE_JPG = $00000015;
  IG_SAVE_PJPEG = $00110015;
  IG_SAVE_MOD_G3 = $0003001A;
  IG_SAVE_MOD_G4 = $0004001A;
  IG_SAVE_MOD_IBM_MMR = $000F001A;
  IG_SAVE_NCR = $0000001B;
  IG_SAVE_NCR_G4 = $0004001B;
  IG_SAVE_PBM_ASCII = $0017001C;
  IG_SAVE_PBM_RAW = $0018001C;
  IG_SAVE_PCT = $0000001E;
  IG_SAVE_PCX = $0000001F;
  IG_SAVE_PDF_UNCOMP = $00000038;
  IG_SAVE_PDF_JPG = $00060038;
  IG_SAVE_PDF_G3 = $00030038;
  IG_SAVE_PDF_G3_2D = $00050038;
  IG_SAVE_PDF_G4 = $00040038;
  IG_SAVE_PDF_RLE = $00070038;
  IG_SAVE_PDF_DEFLATE = $000E0038;
  IG_SAVE_PDF_LZW = $00080038;
  IG_SAVE_PS_UNCOMP = $00000066;
  IG_SAVE_PS_JPG = $00060066;
  IG_SAVE_PS_G3 = $00030066;
  IG_SAVE_PS_G3_2D = $00050066;
  IG_SAVE_PS_G4 = $00040066;
  IG_SAVE_PS_RLE = $00070066;
  IG_SAVE_PS_DEFLATE = $000E0066;
  IG_SAVE_PS_LZW = $00080066;
  IG_SAVE_PNG = $00000021;
  IG_SAVE_PSD = $00000024;
  IG_SAVE_PSB = $00000070;
  IG_SAVE_PSD_PACKED = $00010024;
  IG_SAVE_PSB_PACKED = $00010070;
  IG_SAVE_RAS = $00000025;
  IG_SAVE_RAW_G3 = $0003000B;
  IG_SAVE_RAW_G4 = $0004000C;
  IG_SAVE_RAW_G32D = $00050035;
  IG_SAVE_RAW_LZW = $00080000;
  IG_SAVE_RAW_RLE = $00070000;
  IG_SAVE_SGI = $00000026;
  IG_SAVE_SGI_RLE = $00070026;
  IG_SAVE_TGA = $00000027;
  IG_SAVE_TGA_RLE = $00070027;
  IG_SAVE_TIF_UNCOMP = $00000028;
  IG_SAVE_TIF_G3 = $00030028;
  IG_SAVE_TIF_G3_2D = $00050028;
  IG_SAVE_TIF_G4 = $00040028;
  IG_SAVE_TIF_HUFFMAN = $00020028;
  IG_SAVE_TIF_JPG = $00060028;
  IG_SAVE_TIF_LZW = $00080028;
  IG_SAVE_TIF_PACKED = $00010028;
  IG_SAVE_TIF_DEFLATE = $000E0028;
  IG_SAVE_XBM = $0000002B;
  IG_SAVE_XPM = $0000002D;
  IG_SAVE_XWD = $0000002F;
  IG_SAVE_WMF = $0000002C;
  IG_SAVE_WLT = $0000003D;
  IG_SAVE_JB2 = $0000003E;
  IG_SAVE_WL16 = $0000003F;
  IG_SAVE_WBMP = $00000042;
  IG_SAVE_FPX_NOCHANGE = $000D0032;
  IG_SAVE_FPX_UNCOMP = $00000032;
  IG_SAVE_FPX_JPG = $00060032;
  IG_SAVE_FPX_SINCOLOR = $000C0032;
  IG_SAVE_DCM = $00000030;
  IG_SAVE_JBIG = $00000039;
  IG_SAVE_SCI_ST = $0000005B;
  IG_SAVE_LURAWAVE = $00000062;
  IG_SAVE_LURADOC = $00000061;
  IG_SAVE_LURAJP2 = $00000063;
  IG_SAVE_JPEG2K = $00000064;
  IG_SAVE_JPX = $00000065;
  IG_SAVE_HDP = $0000006E;
  IG_SAVE_EXIF_JPEG = $00000047;
  IG_SAVE_EXIF_TIFF = $0000004A;
  IG_SAVE_EXIF_TIFF_LZW = $0008004A;
  IG_SAVE_EXIF_TIFF_DEFLATE = $000E004A;
  IG_SAVE_CGM = $0000004B;
  IG_SAVE_SVG = $0000004D;
  IG_SAVE_DWG = $00000045;
  IG_SAVE_DXF = $00000046;
  IG_SAVE_U3D = $0000004F;
  IG_SAVE_DWF = $0000004E;
*)

End.
