Unit cMagDBBroker;
   {
   Package: MAG - VistA Imaging
   WARNING: Per VHA Directive 10-93-142 this unit should not be modified.
   Date Created:
   Site Name: Silver Spring, OIFO
   Developers: Garrett Kirin
  [==    unit cMagDBBroker;
   Description: Imaging Database connection unit: An Abstract ancestor Class.
    Designed to represent all calls to VistA DB.
     Other classes will surface (redeclare, override and implement) the Abstract
     methods and members to make DataBase Calls.
     The units, components etc., of the application will reference MagDBBroker, not
     the descendant class (TmagDBMVista, or TMagDBDemo)
     This design enables the application to function the same way
     regardless of which database is connected.  M, (Oracle), Demo TXT files
     As of Patch 8 : cMagDBMVista overrides all calls and connects to M.
                     cMagDBDemo overrides all calls and displays demo files.
     The Application doesn't know, or care, if it is running a demo or actual
     M DB Connection.  ==]
     (? transform into an Interface)
        Inheritance vs Polymorphism

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
  Trpcb,
  UMagClasses,
  UMagDefinitions,
  VERGENCECONTEXTORLib_TLB
  ;

//Uses Vetted 20090929:magfileversion, fmxutils, maggmsgu, uMagUtils, RPCconf1, hash, Dialogs, Forms, Controls, Graphics, SysUtils, Messages, Windows,

Type
  TMagDBBroker = Class
  Private

  Protected
    { Protected declarations }
  Public

    Procedure RPMagsVerifyReport(StartDate, EndDate, Options: String; t: Tstringlist); Virtual; Abstract; {JK 6/1/2009 for ImageVerify Reporting}

    Procedure RPMag4ImageList(Var Fstat: Boolean; Var Rpcmsg: String; DFN: String; Var Flist: TStrings; Filter: TImageFilter = Nil); Virtual; Abstract;

    Procedure RPMaggReasonList(Var Rstat: Boolean; Var Rmsg: String; Var Rlist: TStrings; Data: String); Virtual; Abstract;
      {   Returns the Properties (field values) of an Image}
    Procedure RPMaggImageGetProperties(Var Rstat: Boolean; Var Rmsg: String; Var Rlist: TStrings; Ien, Params: String); Virtual; Abstract;
      {   Sets  the Properties (field values) of an Image}
    Procedure RPMaggImageSetProperties(Var Rstat: Boolean; Var Rmsg: String; Var Rlist: TStrings; Fieldlist: TStrings; Ien, Params: String); Virtual; Abstract;
      {  Returns True if the ien of fmfile (8925 or 8925.1 is of Doc Class <classname>}
    Function RPMaggIsDocClass(Ien, Fmfile, ClassName: String; Var Stat: Boolean; Var Fmsg: String): Boolean; Virtual; Abstract;

    Function GetSilentCodes(Vserver, Vport: String; Var SilentAccess: String; Var SilentVerify: String): Boolean; Virtual; Abstract;
        {True if connected to Database, returns error message}
    Function CheckDBConnection(Var Xmsg: String): Boolean; Virtual; Abstract;

      {  Returns status of DataBase Connection.}
    Function IsConnected: Boolean; Virtual; Abstract;

      {  Connect or Disconnect from DataBase }
    Procedure SetConnected(Const Value: Boolean); Virtual; Abstract;

      {  Returns the Broker property: ListenerPort}
    Function GetListenerPort: Integer; Virtual; Abstract;

      {  Returns the Broker property: Server}
    Function GetServer: String; Virtual; Abstract;

      {  Sets the Broker property: ListenerPort}
    Procedure SetListenerPort(Const Value: Integer); Virtual; Abstract;

      {  Returns the Broker property: Server}
    Procedure SetServer(Const Value: String); Virtual; Abstract;

      {  Returns the TRPCBroker object associated with this object}
    Function GetBroker: TRPCBroker; Virtual; Abstract;

      {  Associates this TMagDBBroker object with a TRPCBroker object }
    Procedure SetBroker(Const Value: TRPCBroker); Virtual; Abstract;

      {  Creates a TRPCBroker object and associates with this TMagDBBroker object}
    Procedure CreateBroker; Virtual; Abstract;

          {  Associates the broker with the contextor control }//46
    Procedure SetContextor(Contextor: TContextorControl); Virtual; Abstract; //46

     {  Return a Date in FM Format
        xmsg         : Error string if result is false.
        dateinput    : Users input.
        dateoutput   : '^' delimited string.  piece 1 - external value.
                                              piece 2 - internal FM value.                                              {}
    Function RPFileManDate(Var Xmsg: String; DateInput: String; Var DateOutput: String; NoFuture: Boolean): Boolean; Virtual; Abstract;

      {  future patch}
    Procedure RPXMultiProcList(Lit: TStrings; DFN: String); Virtual; Abstract;

      {  Checks the version of the Client against the version installed on the server.
 Server code determines if Client should be warned or aborted
 first piece of T[0] is 0,1,2.  T[1..n] are lines of the message to display
  0 : Display Warning and let continue
  1 : Okay, No warning, continue.
  2 : Version is too old, Display message then Application must abort}
    Procedure RPMagVersionCheck(t: TStrings; Version: String); Virtual; Abstract;

      {  Checks the Status of the version of the Client
     first piece of status is 0,1,2,3.
 ;                0^There is No KIDs Install record
 ;                1^Unknown Release Status
 ;                2^Alpha/Beta Version
 ;                3^Released Version  }
    Procedure RPMagVersionStatus(Var Status: String; Version: String); Virtual; Abstract;

      {   --------- Clinical Procedures -----------}
      {  Get a list of CP Requests for the patient}
    Procedure RPGetClinProcReq(DFN: String; Var t: TStrings); Virtual; Abstract;

       {  Convert the Consult# fConsIEN into a TIUDA so we can associate the Image with a TIUDA.
 The result of this call could show that a Visit is needed:
  - If visit is needed Then display the visit selection window.
       - the Visit Selection window returns an existing visit or new visit in
          a vString structure (vString structure is used by TIU )
 Then this call is made again with the vString value from the visit seletion window.
 Complete : this is set when user selects what type of report it is.
  Three choices are displayed for user to select, if user selects the choice :
    'This report will not be receiving any additional images from another instrument'
      then this Consult will be considered 'Complete'.
        dfn : internal entry of patient entry in PATIENT File.
   fConsIEN : Internal entry number of Consult Request (VistA Consults file)
   vString  : data string used by TIU. Is a string of information relevant to TIU .
   Complete : '0' or '2'.  '2' means this Consult is complete.
      }
    Procedure RPGetTIUDAfromClinProcReq(DFN, FConsIEN, Vstring, Complete: String; Var t: TStrings); Virtual; Abstract;

      {  Get a list of Visits for a patient.  The CP Request sometimes needs a visit to
 complete the association with an Image.}
    Procedure RPGetVisitListForReq(DFN: String; Var t: TStrings); Virtual; Abstract;

      {  Update Consults with the Complete Flag. Consults will update
  it's status to 'pr' partial results. It can then be signed.
 This Call is made after successfully capturing the Image.}
    Procedure RPUpdateConsult(Consult, TiuIen, cmpFlag: String; Var Status: String); Virtual; Abstract;

      {  --------------------}

      {  Send Message to Mail Group when Patient Accesses an Offline image
 Site Manager has made an entry in the file ^MAGQUEUE(2006.033,0) = OFFLINE IMAGES
 In Delphi,  Offline images are determined by the property in TImageData
 if TImageData(IObj).fulllocation[1]) = 'O') }
    Procedure RPMaggOffLineImageAccessed(IObj: TImageData); Virtual; Abstract;

      {   ------------ Set Queues ----------}
      {  Set JBTOHD Queues for Abstract and Full.}
    Procedure RPMaggQueImage(IObj: TImageData); Virtual; Abstract;

      {  Set JBTOHD Queues for BIG file.}
    Procedure RPMaggQueBigImage(IObj: TImageData); Virtual; Abstract;

      {  Set JBTOHD Queues for all Images for patient.
     whichimage : [A|F|B]  A(bs) F(ull) B(ig) or combination }
    Procedure RPMaggQuePatient(Whichimages, DFN: String); Virtual; Abstract;

      {  Set JBTOHD Queues for all Images in a Group.
     whichimage : [A|F|B]  A(bs) F(ull) B(ig) or combination }
    Procedure RPMaggQueImageGroup(Whichimages: String; IObj: TImageData); Virtual; Abstract;

      {  --------------------}

      {  Call to log actions into IMAGING WINDOWS SESSIONS File from Delphi
  Actions -view and -capture are automatically logged into IMAGE ACCESS LOG File
   also.  Action -View will update LAST ACCESS DATE in IMAGE File also.}
    Procedure RPMag3Logaction(ActionString: String; IObj: TImageData = Nil); Virtual; Abstract;

      {  Return a list of all images in an Image Group}
    {/ P117 - JK 9/13/2010 /}
    Procedure RPMaggGroupImages(IObj: TImageData; Var t: Tstringlist; NoQAcheck: Boolean = False; DeletedImages: String = ''); Virtual; Abstract;

      {  Gets all images for a patient.  Groups are returned as one item.
  Single images are returned as one item.}
//prior to P8  procedure RPMaggPatImages(DFN: string; var t: tstringlist); virtual ; abstract;

      {  Gets MAX (count) of the latest images for a patient.  Each Image of a Group
is returned as a one list item, and Single images are returned as one list item.}
    Procedure RPMaggPatEachImage(DFN, Max: String; Var t: Tstringlist); Virtual; Abstract;

      {  Call to Logoff of VistA.  Imaging Workstation and Session files are updated
 with logoff Date Time.}
    Procedure RPMaggLogOff; Virtual; Abstract;

      {  Call to send information to VistA about Current Session.
 Information is stored in IMAGING WINDOWS WORKSTATION and IMAGING WINDOWS
 SESSION Files.
          Apppath:      Full path to the application executable.
          DispAppName:  Name of Imaging Display executable.
          CapAppName:   Name of Imaging Capture executable.
          Compname:     The workstation Network Computer Name.
          Location:     Free text description of where the Workstation is located.
          LastUpdate:   Date/Time when MagSetup.exe (MagInstall.exe) was run.
          startmode:    [1|2]  1 = Started standalone,  2 = Started by CPRS. }
    Procedure RPMaggWrksUpdate(AppPath, DispAppName, CapAppName, Compname, Location, LastUpdate: String; Startmode: Integer); Virtual; Abstract;

      {  Call to return a list of SECURITY KEYS help by the user
 example result
t[0]="CAPTURE KEYS OFF"   t[0] = CAPTURE KEYS ON or CAPTURE KEYS OFF
t[1]="MAG CAPTURE"
t[2]="MAG DELETE"
t[3]="MAG SYSTEM"
t[4]="MAGCAP LAB"
t[5]="MAGDISP ADMIN"
t[6]="MAGDISP CLIN"}
    Procedure RPMaggUserKeys(Var t: Tstringlist); Virtual; Abstract;

      {  Gets the value of the TIMEOUT field from the IMAGING SITE PARAMETERS file.
 Application must timeout if inactive for that number of minutes.}
    Procedure RPMaggGetTimeout(app: String; Var Minutes: String); Virtual; Abstract;

      {   ---------------------  TIU CALLS ----------------}
//TIU Calls.
      {  Gets the TIU Report by calling RPC              'TIU GET RECORD TEXT';}
    Procedure RPGetNoteText(TiuDA: String; t: TStrings); Virtual; Abstract;

      {  Gets list of  TIU Note titles by calling RPC    'TIU GET PN TITLES';}
    Procedure RPGetNoteTitles(t, Tint: Tstringlist); Virtual; Abstract;

//  not creating  TIU Entries in P8
      {  Create a New TIU Note by calling RPC            'TIU CREATE RECORD';}
    Function RPCreateRecord(Var Msg: String; DFN, Notetitle, Notedate: String; Notetext: TStrings): Boolean; Virtual; Abstract;
//  not signing  TIU Entries in P8
      {  Sets a TIU Note Status to Signed, by  RPC          'TIU SIGN RECORD';}
    Function RPSignRecord(TiuDA, Hashesign: String; Var Msg: String): Boolean; Virtual; Abstract;

      {  Gets list of  TIU Discharge Summaries for patient by  RPC  'TIU SUMMARIES';}
    Procedure RPGetDischargeSummaries(DFN: String; Var t: Tstringlist); Virtual; Abstract;

      {  Gets list of  TIU Notes for patient by  RPC         'TIU DOCUMENTS BY CONTEXT';}
    Procedure RPGetNotesByContext(DFN: String; Var t: Tstringlist; Context: Integer; Author, Count: String; Docclass: Integer; Seq: String; Showadd: Integer; Incund: Integer; Mthsback: Integer = 0;
      Dtfrom: String = ''; Dtto: String = ''); Virtual; Abstract;

      {  Gets data about Note from TIUDA. TIUPTR =     TIUDA^Document Type ^Document Date^DFN}
    Function RPGetTIUData(TiuDA: String; Var TiuPTR: String): Boolean; Virtual; Abstract;

      {  Get a list of All Images for a TIU Note (prompted by Windows message from CPRS}
    Procedure RPGetCPRSTIUNotes(TiuDA: String; t: Tstringlist; Var Success: Boolean; Var RPmsg: String); Virtual; Abstract;

      {  Get the TIU value for Document Class :CP          RPC : 'TIU IDENTIFY CLINPROC CLASS';}
    Function RPTIUCPClass: Integer; Virtual; Abstract;

      {  Get the TIU value for Document Class :CONSULT          RPC : 'TIU IDENTIFY CONSULTS CLASS';}
    Function RPTIUConsultsClass: Integer; Virtual; Abstract;

      {   ---------------------- }

      {  Return DateTime in VA FileMan format
  datestr : Date in string format
  DisDt   : Date in OutPut format
  IntDt   : Date in Internal Fileman Format}
    Function RPGetFileManDateTime(DateStr: String; Var DisDt, IntDT: String; NoFuture: Boolean): Boolean; Virtual; Abstract;

//prior to P8    procedure RPMagCategories(t: tstrings); virtual ; abstract;
      {  }
    Function RPMagEkgOnline: Integer; Virtual; Abstract;
      {  }
    Procedure RPMagGetNetLoc(Var Success: Boolean; Var RPmsg: String; Var Shares: Tstringlist; NetLocType: String); Virtual; Abstract;

      {  Call to stuff error information from Delphi app into the Session file.
  save the first COUNT items in T to the IMAGING WINDOWS SESSION file.}
    Procedure RPMagLogErrorText(t: TStrings; Count: Integer); Virtual; Abstract;

      {         Get a list of Supported file Extensions from IMAGE FILE TYPES file.
        Each item in the result TStrings : t  is a '^' delimited string
        in the format:
           piece 1:     3 character File Extension
           piece 2:     Readable Description of image format
           piece 3:     1|0  is an Imaging Viewer available for this image fomat.
           piece 4:     name of the Canned Bitmap to use for abstract Or Null
           piece 5:     are abstracts created for images with this extension.}
    Procedure RPGetFileExtensions(Var t: TStrings); Virtual; Abstract;

      {  Delete a Users private Filter from IMAGE LIST FILTERS File }
    Procedure RPFilterDelete(Var Rstat: Boolean; Var Rmsg: String; Fltien: String); Virtual; Abstract;

      {  Save Changes to an Image Filter in IMAGE LIST FILTERS File
  t : is the filter String.  The function FilterToString (defined in uMagDefinitions.pas)
   converts a Tfilter object into a string representation for calls to VistA}
    Procedure RPFilterSave(Var Rstat: Boolean; Var Rmsg: String; t: TStrings); Virtual; Abstract;

      {  Get a list of Filters, Private Public or Both
     if 'duz' = '' we get public.
     if 'duz' = Valid DUZ we get that users filters
     if 'duz' = Valid DUZ and 'getall' = TRUE, then return Public and Private.}
    Procedure RPFilterListGet(Var Rstat: Boolean; Var Rmsg: String; Var Tlist: TStrings; Duz: String = ''; Getall: Boolean = False); Virtual; Abstract;

      {  Get details of a filter from FM File   IMAGE LIST FILTERS
 filter: is a string.  the function StringToFilter (defined in uMagDefinitions.pas)
 will convert the string to a TImageFilter object
        i.e.  FilterObject := StringToFilter(filter);}
    Procedure RPFilterDetailsGet(Var Rstat: Boolean; Var Rmsg, Filter: String; Fltien: String; Fltname: String = ''; Duz: String = ''); Virtual; Abstract;

      {  Return a list of CTPresets for the site from IMAGING SITE PARAMETERS File}
    Procedure RPCTPresetsGet(Var Rstat: Boolean; Var Rmsg: String; Var Value: String); Virtual; Abstract;

      {  Save values for a list of CTPresets for the site in IMAGING SITE PARAMETERS File}
    Procedure RPCTPresetsSave(Var Rstat: Boolean; Var Rmsg: String; Value: String); Virtual; Abstract;

      {  Get a list of Health Summaries for the Site}
    Procedure RPMaggHSList(Var Rstat: Boolean; Var Rmsg: String; Var Tlist: Tstringlist; Value: String); Virtual; Abstract;

      {  Get the Health Summary report}
    Procedure RPMaggHS(Var Rstat: Boolean; Var Rmsg: String; Var Tlist: Tstringlist; Value: String); Virtual; Abstract;

      {  Get the Radiology Report from RARPT IEN}
    Procedure RPMaggRadReport(Var Rstat: Boolean; Var Rmsg: String; Var Tlist: Tstringlist; Rarpt: String); Virtual; Abstract;

      {  Get list of Images for a selected Rad Exam}
    Procedure RPMaggRadImage(Var Rstat: Boolean; Var Rmsg: String; Var Tlist: Tstringlist; Radstring: String); Virtual; Abstract;

      {  Return the Patient Profile Report for a patient}
    Procedure RPMaggDGRPD(Var Rstat: Boolean; Var Rmsg: String; Var Rlist: Tstringlist; DFN: String); Virtual; Abstract;

      {  Return User Information and site information
         rlist[0] = 1|0  ^ message   1 = Okay   0 = Error.
         rlist[1] : from NEW PERSON FILE
                = DUZ ^ Full User NameName  ^ Initials
              2,3,4  from IMAGING SITE PARAMETERS FILE.
         rlist[2] = Network UserName ^ Encrypted PassWord.
         rlist[3] = MUSE Site number. ( default = 1)
         rlist[4] =  IEN ^ SITE CODE ^ DUZ(2) partition varialbe^ Institution (.01)
                                                  ^ Consolidated ?

         rlist[5] = +<CP Version>|0 ^ Version of CP installed on Server
         rlist[6] = Warning msg if we can't resolve which Site Parameter entry to use.
         rlist[7] = Warning message  <reserverd for future>
         }
    Procedure RPMaggUser2(Var Rstat: Boolean; Var Rmsg: String; Var Rlist: TStrings; Wsid: String; pSess: TSession = Nil); Virtual; Abstract;

      {  Get list of Images for a Rad Exam selected in CPRS, prompted by Window message}
    Procedure RPMaggCPRSRadExam(Var Rstat: Boolean; Var Rmsg: String; Var Rlist: TStrings; CprsString: String); Virtual; Abstract;

      {  Get a list of Radiology Exams for a Patient}
    Procedure RPMaggRadExams(Var Rstat: Boolean; Var Rmsg: String; Var Rlist: TStrings; DFN: String); Virtual; Abstract;

      {  Get Image information for 1 image}
    Procedure RPMaggImageInfo(Var Rstat: Boolean; Var Rmsg: String; Var Rlist: TStrings; Ien: String; NoQAcheck: Boolean = False); Virtual; Abstract;

      {  Get list of Filtered images for a Patient}
    Procedure RPMag4PatGetImages(Var Fstat: Boolean; Var Rpcmsg: String; DFN: String; Var Flist: TStrings; Filter: TImageFilter = Nil); Virtual; Abstract;

      {  Get list of all User Preferences from DB, (IMAGING USER PREFERENCES File) or 1 node
 of preferences. Set fields of the UserPreferences record. (upref)
 if parameter -code is not null, then only the node represented by -code will be
 retrieved from DB .
  When a form is open, a call is made to the relevant procedure to set the preferences
  of the window, and the variable upref (upref : record of userprefernces) is sent as paremeter.
  i.e. procedure UprefToFullView(var upref: userpreferences);}
    Procedure RPMagGetUserPreferences(Var Fstat: Boolean; Var Rpcmsg: String; Xlist: Tstringlist; Code: String = ''); Virtual; Abstract;

      {  Called with a  TStrings list of properties from Open forms, checked menu's etc.
 and saved to the IMAGING USER PREFERENCES File.
 The TStrings parameter xList could be All preferences, or only a few or one.
    Called from SaveUserSettings in frmMain.pas (Image Display main window)
    and SetUserCapPref in frmCapMain.pas (Image Capture main window)}
    Procedure RPMagSetUserPreferences(Var Fstat: Boolean; Var Rpcmsg: String; Xlist: TStrings); Virtual; Abstract;

      {  Old Get list of IndexTypes, not based on Class}
   // procedure RPMagIndexType(var Fstat: boolean; var Flist: tstringlist; MagDFN: string); virtual ; abstract;

      {  ImportAPI call. Queues data to be imported by BP
  The parameter DataArray is a list of  dataCode^dataValue as defined by the
  import API.
  i.e. DataArray(2)='AQD^ComputerName'
  The Call to DB could return error if Required fields are missing or
  data is invalid.  Usually returns Success and QueueNumber}
    Procedure RPMag4RemoteImport(Var Fstat: Boolean; Var Flist: Tstringlist; DataArray: Tstringlist); Virtual; Abstract;
         {/117 Get Patient Info based on DFN. called by anyone,  has no 'Remote Reprocussions'}
   procedure RPMagPatInfoQuiet(var Fstat: boolean; var Fstring: string; MagDFN: string; isicn: boolean = false); virtual ; abstract;

      {  Get Patient Info based on DFN.  Called by TMag4Pat object.  the data returned is
 used to populate the properties of the TMag4Pat Object.}
    {/ P117 - JK 10/5/2010 - Added 5th Parameter to support Deleted Image Placeholder counts/}
//    Procedure RPMagPatInfo(Var Fstat: Boolean; Var Fstring: String; MagDFN: String; IsIcn: Boolean = False); Virtual; Abstract;
    Procedure RPMagPatInfo(Var Fstat: Boolean; Var Fstring: String; MagDFN: String; IsIcn: Boolean = False; IncDeletedCount: Boolean = False); Virtual; Abstract;

      {  Prior to Patch 8}
//    procedure RPMag4PostProcessing(var Fstat: boolean; var Flist: tstringlist; Magien: string); virtual ; abstract;

      {  Called after successful Image save.  Any Post processing actions defined for the
 TYPE INDEX of the newly saved image will be executed. (Copy to HEC is the only
 one so far)}
    Procedure RPMag4PostProcessActions(Var Fstat: Boolean; Var Flist: Tstringlist; Magien: String); Virtual; Abstract;

      {  Generic Lookup call using FIND^DIC(, , ,  ,) }
    Procedure RPMag3LookupAny(Var Fstat: Boolean; Var Fmsg: String; Var Flist: Tstringlist; InputString: String; Data: String = ''); Virtual; Abstract;

          {  Generic Lookup call using LIST^DIC(, , ,  ,) }
    Procedure RPMag3ListAny(Var Fstat: Boolean; Var Fmsg: String; Var Flist: TStrings; VFile, VStart, VFlags: String; VNum: String = '50'; VCR: String = 'B'; VData: String = ''); Virtual; Abstract;

      {  Future call.  probably move to cMagDBSysUtils}
    Procedure RPMag4IAPIStats(Var Fstat: Boolean; Var Flist: TStrings; DtStart, DtEnd: String); Virtual; Abstract;

      {  Call to Delete a single Image. User needs MAG DELETE Key
        Flist      : messages returned.  Displayed if Fstat = false.
        IEN        : Image IEN
        ForceDel   : [1|0]  1 = Delete Image even if user doesn't have MAG DELETE key
                            0 = Normal.  User needs the MAG DELETE KEY
        reason     : Reason for Deletion. User picked from list or entered free text.
        GrpDelOK   : Future.  To Allow deleting groups from GUI.
          {  }
    Procedure RPMaggImageDelete(Var Fstat: Boolean; Var Rmsg: String; Var Flist: TStrings; Ien, ForceDel: String; Reason: String = ''; GrpDelOK: Boolean = False); Virtual; Abstract;

      {  Call to get a Report associated with the Image.  Only IEN is sent, M code determines
 the associated Lab,Rad,Med,Sur,CP,Note attacthed to the Image and returns it
 as a list. If a Long Description is defined for the Image, it is Inserted at the
 Top of the listing, before the Report.}
   // prior to 8 procedure RPMagGetImageReport(var Fstat: boolean; var Fmsg: string; Flist: tstrings; magien: string); virtual ; abstract;
      {   RPImageReport is called from cMagUtilsDB .  All calls from application to get
  a report from DB, go through cMagUtilsDB.}
    Procedure RPImageReport(Var Fstat: Boolean; Var Fmsg: String; Flist: TStrings; IObj: TImageData; NoQAcheck: Boolean = False); Virtual; Abstract;

      {  Get a list of Images associated with a TIU Report.
 If multiple Groups or Groups and Images.  We put all images (abstracts) in one
 list and display them in the Group Abstract Viewer.}
    Procedure RPMag3TIUImage(Var Fstat: Boolean; Var Flist: Tstringlist; Magien, TiuDA: String); Virtual; Abstract;

      {  ImportAPI  Call.  When BP calls IAPI with a Queue Number,  this call is made by IAPI
 to get the DataArray from VistA.  IMPORT QUEUE File.}
    Procedure RPMag4DataFromImportQueue(Var Fstat: Boolean; Var Flist: Tstringlist; QueueNum: String); Virtual; Abstract;

      {  ImportAPI Call.  The IAPI creates a DataArray from it's properties and makes
 this DB call to assure the Data is valid before making the call to save the
 data to the IMAGE File.}
    Procedure RPMag4ValidateData(Var Fstat: Boolean; Var Flist: Tstringlist; t: Tstringlist; Rettype: String); Virtual; Abstract;
        { Call to get a list of TIU Titles, that user will select to create a new note}
    Procedure RPTIULongListOfTitles(Var Fstat: Boolean; Var Fmsg: String; Var Flist: TStrings; NoteClass, InputString: String; Mylist: Boolean = False); Virtual; Abstract;

        {  Call to create a new Note. Title is the IEN Of 8995.1, adminclose is 1 if true}
    Procedure RPTIUCreateNote(Var Fstat: Boolean; Var Fmsg: String;
      DFN, Title, AdminClose, Mode, Esighash, Esigduz, Loc, Notedate, ConsltDA: String; Notetext: Tstringlist = Nil); Virtual; Abstract;

        { Call to create an Addendum. Tiuda is the IEN Of 8995, adminclose is 1 if true}
    Procedure RPTIUCreateAddendum(Var Fstat: Boolean; Var Fmsg: String;
      DFN, TiuDA, AdminClose, Mode, Esighash, Esigduz, Notedate: String; Notetext: Tstringlist = Nil); Virtual; Abstract;

        {       }
    Procedure RPTIUModifyNote(Var Fstat: Boolean; Var Fmsg: String;
      DFN, TiuDA, AdminClose, Mode, Esighash, Esigduz: String; Notetext: Tstringlist = Nil); Virtual; Abstract;
        {       This call determines if the TIU Title is a Consult.  That will
                require an existing Consult to be attached to this note during
                creation.}
    Procedure RPTIUisThisaConsult(Var Fstat: Boolean; Var Fmsg: String; Titleda: String); Virtual; Abstract;
    Procedure RPTeleReaderConsultListRequests(Var Fstat: Boolean; Var Fmsg: String; Var Flist: Tstringlist; DFN: String); Virtual; Abstract;
        {       Get a List of Consults for this patient.}
    Procedure RPGMRCListConsultRequests(Var Fstat: Boolean; Var Fmsg: String; Var Flist: Tstringlist; DFN: String); Virtual; Abstract;
        {       Get the BoilerPlated Text for a TIU Title and Patient.}
    Procedure RPTIULoadBoilerplateText(Var Fstat: Boolean; Var Fmsg: String; Var Flist: Tstringlist; Titleda, DFN: String); Virtual; Abstract;

    Procedure RPTIUAuthorization(Var Fstat: Boolean; Var Fmsg: String; TiuDA, action: String); Virtual; Abstract;

           {Call to Electronically Sign a TIU Note.  tiuda is IEN of 8995.  HashEsign is the e-signature
             hashed, using Broker function: Hash}
    Function RPTIUSignRecord(Var Fmsg: String; DFN, TiuDA, Hashesign: String): Boolean; Virtual; Abstract;

    Function GETTHIS(Val: String): Boolean; Virtual; Abstract;

      {  ImportAPI Call.  After Validating the data, the IAPI makes this call to save the
 image to the IMAGE File.}
    Procedure RPMag4AddImage(Var Fstat: Boolean; Var Flist: Tstringlist; t: Tstringlist); Virtual; Abstract;

      {  After a successful Image save. The IAPI and Capture Workstation make this call
 to set the Queues for Copy to the JukeBox Queues. And Optionally, to create an
  abstract.}
    Procedure RPMagABSJB(Var Fstat: Boolean; Var Flist: Tstringlist; CreatAbsIEN, JBCopyIEN: String); Virtual; Abstract;

      {  Call DB to get a list of Versions of Imaging that have been installed on the Server.
 The About box uses this to display that list.}
    Procedure RPMaggInstall(Var Fstat: Boolean; Var Flist: Tstringlist); Virtual; Abstract;

      {  Future.  Information about a supported file format based on it's extension.}
    Function RPMag4GetFileFormatInfo(Ext: String; Var Xmsg: String): Boolean; Virtual; Abstract;

      {  This call will validate a Users' Electronic Signature.}
    Function RPVerifyEsig(Esig: String; Var Xmsg: String): Boolean; Virtual; Abstract;

      {  Here we log an action in the IMAGING ACCESS LOG File ^MAG(2006.95
  parameter is '^' delimited string
   copy code^ duz ^ magien ^ actioin ^ dfn ^ 1
   i.e.  'A|B|C|D|E' ^^ MAGIEN ^ 'Copy/Download' ^ DFN ^ '1';
   DUZ is inserted as 2nd piece by the M routine.
   example : s = "C^^103660^Copy To Clipboard^1033^1"}
    Procedure RPLogCopyAccess(s: String; IObj: TImageData; EventType: TMagImageAccessEventType); Virtual; Abstract;

      {  Get a list of Image Types from the IMAGE INDEX FOR TYPES File
  cls: a ',' seperated list of Classes.
  ignorestatus : flag to ignore the Status field of the TYPE entry.  1=Ignore   }
    Procedure RPIndexGetType(Lit: TStrings; Cls: String;
      IgnoreStatus: Boolean = False;
      IncClass: Boolean = False;
      IncStatus: Boolean = False); Virtual; Abstract;

      {  Get a list of Image Proceure/Events from the IMAGE INDEX FOR PROCEDURE/EVENT File
  cls: a ',' seperated list of Classes.
  spec : a ',' seperated list of Specialties
  ignorestatus : flag to ignore the Status field of the Procedure entry.  1=Ignore    }
    Procedure RPIndexGetEvent(Lit: TStrings; Cls: String = ''; Spec: String = '';
      IgnoreStatus: Boolean = False;
      IncClass: Boolean = False;
      IncStatus: Boolean = False); Virtual; Abstract;

      {  Get a list of Image Specialties/SubSpecialties from the IMAGE INDEX FOR SPECIALTY/SUBSPECIALTY File
  cls: a ',' seperated list of Classes.
  proc : a ',' seperated list of Procedure/Events
  ignorestatus : flag to ignore the Status field of the Specialty entry.  1=Ignore}
    Procedure RPIndexGetSpecSubSpec(Lit: TStrings; Cls: String = ''; Proc: String = '';
      IgnoreStatus: Boolean = False;
      IncClass: Boolean = False;
      IncStatus: Boolean = False;
      IncSpec: Boolean = False); Virtual; Abstract;
 {/ JK 11/24/2009 - P108 New method to get the list of Origin values /}
  procedure RPIndexGetOrigin(lit: TStrings); virtual; abstract;
  
  {/ JK 11/24/2009 - P108 New method to determine if a patient photo is associated with the input DFN/}
  function RPPatientHasPhoto(DFN: String;
                             var Stat: Boolean;
                             var FMsg: String): String; virtual; abstract;

    Function RPXWBGetVariableValue(Value: String): String; Virtual; Abstract;

        {Sends new values for index fields for a single or multiple Image IENs
         Old Values are saved in IMAGE ACCESS LOG File 2006.95}
    Procedure RPMag4FieldValueSet(Var Fstat: Boolean; Var Fmsg: String; Var Flist: Tstringlist; t: Tstringlist); Virtual; Abstract;

      {  Call to Do a Patient lookup using FIND^DIC
 STR is parameter in the format   FILE NUM ^ NUM TO RETURN ^ TEXT TO MATCH }
    Function RPMagPatLookup(Str: String; t: TStrings; Var Xmsg: String): Boolean; Virtual; Abstract;

      {    ----------------   DG RPC Calls. ------------------  }
      {    Checks if More than one patient has Same Last Name and Last 4 of SSN
  It calls the Patient API  GUIBS5A^DPTLK6 to figure it out.
  Returns 1 in 1st string (t[0]) if more than 1 exist, Otherwise 0 }
    Function RPMaggPatBS5Chk(DFN: String; Var t: Tstringlist): Boolean; Virtual; Abstract;

      {   Calls the RPC  'DG SENSITIVE RECORD ACCESS';
  Code :  is the action code returned.
           -1 = RPC/API failed
           0 = No display or action required
           1 = Display warning message
           2 = Display warning message - require OK to continue
           3 = Display warning message - do not continue
  t :  Warning message is returned from DG package. (if needed.)
           If the output value is 1 (display warning message) entry in
           DG SECURITY LOG file is automatically made; GUI application does not
            need to take action to log access}
    Procedure RPDGSensitiveRecordAccess(DFN: String; Var Code: Integer; Var t: Tstringlist); Virtual; Abstract;

      {   Calls the RPC   DG SENSITIVITY RECORD BULLETIN
  If the return of   RPDGSensitiveRecordAccess is 2 then display dialog.
     If user elects to continue.
     The RPC logs access to sensitive patient by user.
     and sends bulletin to Mail Group (Mail group determined by site)    }
    Procedure RPDGSensitiveRecordBulletin(DFN: String); Virtual; Abstract;

      {   Calls the RPC 'DG CHK PAT/DIV MEANS TEST';
  to check if means test is required for this patient and checks if means test
  display required for  user's division.
  Code is returned as 1 if Both true,   Otherwise 0
  If Both true, then display the text returned in t   }
    Procedure RPDGChkPatDivMeansTest(DFN: String; Var Code: Integer; Var t: Tstringlist); Virtual; Abstract;
      {    ----------------                 ------------------  }

      {  Get image information for one image.  result is a list in readable format.  Caller
 just displays the list.  no need to match '^'pieces to output fields.}
    Procedure RPMag4GetImageInfo(VIobj: TImageData; Var Flist: TStrings; DeletedImagePlaceholders: Boolean = False); Virtual; Abstract;  {/ P117 - JK 9/20/2010 - added last parameter /}

        { Get data from any field in the Image File.  pass a list of ',' delimited Field NUmbers.}
    Procedure RPMag4FieldValueGet(Var Fstat: Boolean; Var Fmsg: String; Var Flist: Tstringlist; Ien: String; Flags: String = ''; Flds: String = ''); Virtual; Abstract;

      {  Call returns a list of all Photo ID's on file for a patient.
 The Images are returned in Rev Chronological Order, latest image
 first, oldest image last. Data in the list is in format to be converted to
 TImageData object}
    Function RPMaggGetPhotoIDs(Xdfn: String; t: Tstringlist): Boolean; Virtual; Abstract;

      {  Import API Call : Report Status to calling application
 P8T32 10/29/03 The BP No Longer makes this call The Import Component
 (and OCX) call this RPC
t(0)= "0^message" or "1^message"
t(1)=TRKID,
t(2)=QNUM
t(3..N)=warnings
cb  : The TAG^RTN to call with Status Array
DoStatusCB : Flag (1|0) to supress the execution of the Status Callback
Note : Old Import API and BP that make this call, will function as before
because DOCB defaults to 1}
    Procedure RPMag4StatusCallback(t: TStrings; cb: String; DoStatusCB: Boolean = True); Virtual; Abstract;

      {  DBSelect : This call uses Kernel API to display a list of Servers defined on the
 workstation for the User to select form.  If user selects one, it is returned in
 parameters vserver, vport }
    Function DBSelect(Var Vserver, Vport: String; Context: String = 'MAG WINDOWS'): Boolean; Virtual; Abstract;

      {  Use Kernel Broker to connect to the Server Port defined by the parameters
vserver, vport
if parameters accesscode and verifycode are defined, user will not be prompted
to enter them again. Silent Login}
    Function DBConnect(Vserver, Vport: String; Context: String = 'MAG WINDOWS'; AccessCode: String = ''; Verifycode: String = '';division : string = ''): Boolean; Virtual; Abstract;

    //start 46 JMW 1/24/2006 p46
    {Get the current users SSN from VistA}
    Function GetUserSSN(): String; Virtual; Abstract;
    {Retrieve the sites/specialties/procedures for the user}
    Function RPMagGetTeleReader(Var t: TStrings; Var Xmsg: String): Boolean; Virtual; Abstract;
    {Set the preferences for site/specialty/procedure for the user}
    Function RPMagSetTeleReader(Var Xmsg: String; Sitecode: String; SpecialtyCode: String; ProcedureCode: String; UserWants: String): Boolean; Virtual; Abstract;
    {Retrieve the read/unread list}
    Function RPMagTeleReaderUnreadlistGet(Var t: TStrings; Var Xmsg: String; AcquisitionPrimaryDivision, Sitecode, SpecialtyCode, ProcedureStrings, LastUpdate, UserDUZ, LocalSiteCode, SiteTimeOut, StatusOptions: String): Boolean; Virtual; Abstract;
    {Lock items in the unread list}
    Function RPMagTeleReaderUnreadlistLock(Var Xmsg: String; AcquisitionPrimaryDivision, AcquisitionSiteCode, ItemID, LockUnlockValue, UserFullName, UserInitials, LocalDUZ, LocalSiteCode: String): Boolean; Virtual; Abstract;

    Function RPMagGetPatientDFNFromICN(Var Xmsg: String; PatientICN: String): Boolean; Virtual; Abstract;
     //end 46

    {JMW 3/18/2007 P72 - function to enable/disable the keep broker alive ability during long image transfers}
    Procedure KeepBrokerAlive(Enabled: Boolean); Virtual; Abstract;

    Procedure RPMagImageStatisticsUsers(Var Fstat: Boolean; Var Fmsg: String; Var Flist: Tstringlist; Inputparams: Tstringlist); Virtual; Abstract;
    Procedure RPMaggCaptureUsers(Var Fstat: Boolean; Var Fmsg: String; Var Flist: Tstringlist; Inputparams: Tstringlist); Virtual; Abstract;

    {JMW 10/1/2009 P94 - method to get a new security token (BSE)}
    Function RPMagSecurityToken(): String; Virtual; Abstract;

    {/ P94 JMW 10/20/2009 - log using CAPRI for remote login /}
    Procedure RPMagLogCapriRemoteLogin(Application: TMagRemoteLoginApplication; SiteNumber: String); Virtual; Abstract;

    {BB P106 04/21/2010 - check kernel settings thin client allowed in telereader}
    {p117 gek reanamed from UserHasRightToThinClient to be consistent with sop. RPMag...}
    Function RPMag3TRThinClientAllowed: Boolean; Virtual; Abstract;

    {BB P117 08/24/2010 - write multi image print sesion results to #2006.961}
    {p117 gek reanamed from MagROIMultiPagePrint to be consistent with sop. RPMag...}
    procedure  RPMaggMultiImagePrint(DFN, Reason: String; Images: TStringList); virtual; abstract;

    {/ P117 JK 8/5/2010 - Supports Taskman queuing /}
    procedure RPMagImageStatisticsQue(var Fstat: Boolean; var Fmsg: String; var Flist: TStringList; InputParams: TStringList); virtual; abstract;

    {/ P117 JK 8/5/2010 - Supports Taskman queuing /}
    procedure RPMagImageStatisticsByUser(var Fstat: Boolean; var Fmsg: String; var Flist: TStringList; UserDUZ: String); virtual; abstract;

    {/P117 GEK 11/23/2010  Get Juke Box path to an Image.}
    procedure RPMagJukeBoxPath(var Fstat: Boolean; var Fmsg: String; ImageIEN: String); virtual; abstract;
  Published

  End;

Implementation

End.
