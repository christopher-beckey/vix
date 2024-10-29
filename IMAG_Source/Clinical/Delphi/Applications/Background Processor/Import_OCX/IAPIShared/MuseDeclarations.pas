Unit MuseDeclarations;
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
        ;; a Class II medical device.  As such, it may not be changed
        ;; in any way.  Modifications to this software may result in an
        ;; adulterated medical device under 21CFR820, the use of which
        ;; is considered to be a violation of US Federal Statutes.
        ;; +---------------------------------------------------------------------------------------------------+
 
*)

Interface

Uses
  SysUtils,
  Windows
  ;

//Uses Vetted 20090929:Classes, Messages

(* Define some data types specific to the MUSEAPI *)

Type
  MUSE_NAME_PTR = ^MUSE_NAME;
  MUSE_NAME = Packed Record
    Last: Array[1..17] Of Char;
    First: Array[1..11] Of Char;
  End; (* MUSE_NAME *)

Type
  MUSE_PID_PTR = ^MUSE_PID;
  MUSE_PID = Packed Record
    ID: Array[1..17] Of Char;
  End; (* MUSE_PID *)

Type
  MUSE_DATE_PTR = ^MUSE_DATE;
  MUSE_DATE = Packed Record
    Day: Shortint;
    Month: Shortint;
    Year: Smallint;
  End; (* MUSE_DATE *)

Type
  MUSE_FILENAME = Packed Record
    Name: Array[1..124] Of Char;
    Pad2: Word;
    Pad1: byte;
    Volume: byte;
  End; (* MUSE_FILENAME *)

Type
  Pointer_ptr = ^Pointer;
  MUSE_TIME_PTR = ^MUSE_TIME;
  MUSE_TIME = Packed Record
    Hundreths: Shortint;
    Second: Shortint;
    Minute: Shortint;
    Hour: Shortint;
  End; (* MUSE_TIME *)
Type
  MUSE_TEST_INFORMATION_PTR = ^MUSE_TEST_INFORMATION;
  MUSE_TEST_INFORMATION = Packed Record
    AcqDate: MUSE_DATE;
    AcqTime: MUSE_TIME;
    EditTime: MUSE_TIME;
    EditDate: MUSE_DATE;
    InjuryClass: Word;
    Location: Word;
    Status: byte;
    Priority: byte;
    cseType: byte;
    SubType: byte;
    DataTypeQual: byte;
    FormatFlag: byte;
    HISStatus: byte;
    NumImages: byte;
    Ordering_md_id: Word;
    Ordering_md_name: MUSE_NAME;
    Referring_md_id: Word;
    Referrining_md_name: MUSE_NAME;
    Overreading_md_id: Word;
    Overreading_md_name: MUSE_NAME;
    Editor_id: Word;
    Editor_name: MUSE_NAME;
    Acquiring_Tech_Id: Word;
    Acquiring_Tech_Name: MUSE_NAME;
    EdtFile: MUSE_FILENAME;
    Pad1: Array[1..2] Of byte;
    MeiPSIG: LongWord;
    Order_number: Array[1..11] Of Char;
    Pad2: Array[1..5] Of byte;
  End; (* MUSE_TEST_INFORMATION *)

Type
  WORD_PTR = ^Smallint;
  MUSE_DEMOGRAPHIC_PTR = ^MUSE_DEMOGRAPHIC;
  MUSE_DEMOGRAPHIC = Packed Record
    Patient: MUSE_PID;
    Fam_rel: byte;
    Name: MUSE_NAME;
    Age: Word;
    Age_Units: byte;
    Has_suppl: byte;
    Dob: MUSE_DATE;
    Gender: byte;
    Race: byte;
    Eng_height: Word;
    Height: Word;
    Eng_weight: Word;
    Weight: Word;
    KanjiName: Array[1..21] Of Char;
    Spare: Array[1..75] Of byte;
  End; (* MUSE_DEMOGRAPHIC *)

Type
  ImgRecord = Packed Record
    Loffset: Longint;
    LSize: Longint;
    Pid: String[16];
    cseType: Shortint;
    Date: Longint;
    Time: Longint;
    NPage: Smallint;
    MPage: Smallint;
    ImgType: Shortint;
    Site: Shortint;
    Name: String[27];
    HPixels: Smallint;
    VPixels: Smallint;
    Orient: Shortint;
    Which: Shortint;
    Retrive: Shortint;
    Pad: Shortint;
    Title: String[31];
  End; (* ImgRecord *)

Type
  ImgPage = Packed Record
    Ident: String[5];
    Pages: Smallint;
    Recs: Array[1..90] Of ImgRecord;
  End; (* ImgPage *)

(* added the following for dynamic dll loading of museapi.dll   SAF 1/24/2000 *)
  Tmei_OpenMUSE = Function(MUSEAPI_HANDLE: Pointer; HWndCaller: THandle;
    WNodeID: Word; WTaskID: Word; bBinding: Bool; Site: byte):
    Word; cdecl;

  Tmei_CloseMUSE = Function(MUSEAPI_HANDLE: Pointer;
    bCancelMainDrive: Bool): Word; cdecl;

  Tmei_PatientIDFromName = Function(MuseHandle: Pointer;
    Name: MUSE_NAME_PTR; DemoBuffer: MUSE_DEMOGRAPHIC_PTR;
    Numentries: WORD_PTR; Pid: MUSE_PID_PTR): Word; cdecl;

  Tmei_TestsForPatient = Function(MuseHandle: Pointer; PPID: MUSE_PID_PTR;
    cseType: Shortint; PDate: MUSE_DATE_PTR; PTime: MUSE_TIME_PTR;
    PTestInfo: MUSE_TEST_INFORMATION_PTR; PNumEntries: WORD_PTR): Word; cdecl;

  Tmei_CreateOutputForTestInfo = Function(MuseHandle: Pointer; PPID: MUSE_PID_PTR;
    PTestInfo: MUSE_TEST_INFORMATION_PTR; OutputType: Shortint;
    OutputFileName: PChar): Word; cdecl;

  Tmei_CreateOutputForID = Function(MuseHandle: Pointer; PPID: MUSE_PID_PTR;
    PDate: MUSE_DATE_PTR; PTime: MUSE_TIME_PTR; cseType: Shortint;
    OutputType: Shortint; OutputName: PChar): Word; cdecl;

  Tmei_PatientNameFromID = Function(MuseHandle: Pointer; Name: MUSE_NAME_PTR;
    Pid: MUSE_PID_PTR): Word; cdecl;

  EDLLLoadError = Class(Exception);

(* End of dynamic dll loading SAF 1/24/2000*)

Implementation

End.
