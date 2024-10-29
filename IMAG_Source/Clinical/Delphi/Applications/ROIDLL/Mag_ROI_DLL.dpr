library Mag_ROI_DLL;

{
Package: MAG - VistA Imaging
WARNING: Per VHA Directive 10-93-142 this unit should not be modified.
Date Created:   March, 2012
Site Name: Silver Spring, OIFO
Developers: Jerry Kashtan
[==   library MAG_ROI_DLL.dpr;

  Description: Stand-alone DLL to wrap Accusoft functions.
      This DLL contains logic to:
      
      (1) Delphi_MakePDFDoc: This method creates a Release of Information (ROI)
          disclosure folder containing copies of VistA Imaging files corresponding
          to a patient request for their medical information.  The disclosure
          folder will contain a manifest file, a disclosure file (the disclosure
          file is a bookmarked PDF file called the "disclosure PDF"),
          and possibly other files copied from VistA that were requested by the
          patient.  If the VistA Imaging file type is PDF, BMP, TIF, or JPG, it
          will be included (appended) into the "disclosure PDF" file.
          If there is a problem appending any input file into the disclosure PDF, a copy of
          the file will be added to the disclosure folder and the file is disclosed "as is".
          A disclosure manifest is created that summarizes the disclosure files being released.

      (2) Delphi_MakeAnnotatedFile: This method creates a copy of the image file with
          it annotation layer burned into the image. Image annotations are kept in
          VistA as a separate overlay file associated to the image.  The annotations
          are in Accusoft XML format (ArtX). If a file is found to have annotations,
          this method will create a combined image that can be viewed in any commercial
          image viewer program.  Otherwise, the user would need to have an Accusoft-licensed
          viewer from the VA to view the image with the annotation overlay layer.
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


{ Important note about DLL memory management: ShareMem must be the
  first unit in your library's USES clause AND your project's (select
  Project-View Source) USES clause if your DLL exports any procedures or
  functions that pass strings as parameters or function results. This
  applies to all strings passed to and from your DLL--even those that
  are nested in records and classes. ShareMem is the interface unit to
  the BORLNDMM.DLL shared memory manager, which must be deployed along
  with your DLL. To avoid using BORLNDMM.DLL, pass string information
  using PChar or ShortString parameters. }

uses
  SysUtils,
  Classes,
  ComCtrls,
  StrUtils,
  GearCORELib_TLB,
  GearDISPLAYLib_TLB,
  GearFORMATSLib_TLB,
  GearMEDLib_TLB,
  GearVIEWLib_TLB,
  GearDIALOGSLib_TLB,
  GearPDFLib_TLB,
  GearArtXGUILib_TLB,
  GearArtXLib_TLB,
  GearProcessingLib_TLB,    {JK 6/6/2012}
  IGGUIWinLib_TLB,
  Dialogs,
  Contnrs,
  MagROIpdfImage in 'MagROIpdfImage.pas',
  cMag_ROI_IGManager in 'cMag_ROI_IGManager.pas',
  MagROIGlobals in 'MagROIGlobals.pas',
  MagROIPDFPage in 'MagROIPDFPage.pas',
  MagROILogger in 'MagROILogger.pas',
  MagROIUtils in 'MagROIUtils.pas',
  fmxutils,
  XmlDoc,
  XmlDom,
  XmlIntf,
  Variants;

{$R *.res}

type

  TParseType = (ptStudies, ptFiles, ptFileGroups, ptFilesAndGroups, ptBookmarks);

  TDocType = (dtPDF, dtJPG, dtTIF, dtBMP, dtRTF, dtDOC, dtDOCX, dtTGA, dtWAV, dtHTM, dtHTML, dtMOV, dtMPG, dtAVI, dtOther);

  TAddType = (atAddToDisclosureFolder, atAddToDisclosurePDF, atError, atTesting);

  TPictureResolution = (psLowRes, psMedRes, psLargeRes);

  {The TDocument class contains information about source PDF files}
  TDocument = class
  private
    FDocName: String;
    FPageCount: Integer;
    FDocType: TDocType;
    FBookmark: String;
    FDocAccessedAt: TDateTime;
    FDocProcessingMsgs: TStringList;

    FTitle: String;
    FAuthor: String;
    FSubject: String;
    FKeywords: String;
    FCreatedOn: String;
    FModifiedOn: String;
    FCreator: String;
    FProducer: String;

    FSec_SecurityMethod: String;
		FSec_Revision: String;
		FSec_DocOpenPW: String;
		FSec_PermPW: String;
		FSec_Printing: String;
		FSec_ChangingDoc: String;
		FSec_DocAssembly: String;
		FSec_ContentCopy: String;
		FSec_ContentExtract: String;
		FSec_Commenting: String;
		FSec_FormFilling: String;
		FSec_Signing: String;
		FSec_CreationTemplatePages: String;
		FSec_SubmittingForms: String;
		FSec_EncLevel: String;
  public
    property DocName: String read FDocName write FDocName;
    property PageCount: Integer read FPageCount write FPageCount;
    property DocType: TDocType read FDocType write FDocType;
    property Bookmark: String read FBookmark write FBookmark;
    property DocAccessedAt: TDateTime read FDocAccessedAt write FDocAccessedAt;
    property DocProcessingMsgs: TStringList read FDocProcessingMsgs write FDocProcessingMsgs;

    property Title: String read FTitle write FTitle;
    property Author: String read FAuthor write FAuthor;
    property Subject: String read FSubject write FSubject;
    property Keywords: String read FKeywords write FKeywords;
    property CreatedOn: String read FCreatedOn write FCreatedOn;
    property ModifiedOn: String read FModifiedOn write FModifiedOn;
    property Creator: String read FCreator write FCreator;
    property Producer: String read FProducer write FProducer;

    property Sec_SecurityMethod: String read FSec_SecurityMethod write FSec_SecurityMethod;
		property Sec_Revision: String read FSec_Revision write FSec_Revision;
		property Sec_DocOpenPW: String read FSec_DocOpenPW write FSec_DocOpenPW;
		property Sec_PermPW: String read FSec_PermPW write FSec_PermPW;
		property Sec_Printing:  String read FSec_Printing write FSec_Printing;
		property Sec_ChangingDoc: String read FSec_ChangingDoc write FSec_ChangingDoc;
		property Sec_DocAssembly: String read FSec_DocAssembly write FSec_DocAssembly;
		property Sec_ContentCopy: String read FSec_ContentCopy write FSec_ContentCopy;
		property Sec_ContentExtract: String read FSec_ContentExtract write FSec_ContentExtract;
		property Sec_Commenting: String read FSec_Commenting write FSec_Commenting;
		property Sec_FormFilling: String read FSec_FormFilling write FSec_FormFilling;
		property Sec_Signing: String read FSec_Signing write FSec_Signing;
		property Sec_CreationTemplatePages: String read FSec_CreationTemplatePages write FSec_CreationTemplatePages;
		property Sec_SubmittingForms: String read FSec_SubmittingForms write FSec_SubmittingForms;
		property Sec_EncLevel: String read FSec_EncLevel write FSec_EncLevel;
  end;

  {The TDocumentList class is a list of TDocuments}
  TDocumentList = class(TObjectList)
  private
    FOwnsObjects: Boolean;
    FManifestLog: TStringList;
  protected
    function GetItem(Index: Integer): TDocument;
    procedure SetItem(Index: Integer; AObject: TDocument);
  public
    function Add(AObject: TDocument): Integer;
    function Remove(AObject: TDocument): Integer;
    function IndexOf(AObject: TDocument): Integer;
    procedure Insert(Index: Integer; AObject: TDocument);
    property OwnsObjects: Boolean read FOwnsObjects write FOwnsObjects;
    property Items[Index: Integer]: TDocument read GetItem write SetItem; default;
    property ManifestLog: TStringList read FManifestLog write FManifestLog;
  end;

  {The TAccusoft class encapsulates the Accusoft ImageGear SDK along with
   licensing. A singleton is required and it is called IGManager. IGManager
   is accessed by calling GetIGManager. This DLL re-implements the
   cMagIGManager developed for clinical apps.}
  TAccusoft = class
  private
    FCurDoc: IIGDocument;
    FCurPDFDoc: IGPdfDoc;
    FCurFormat: enumIGFormats;
    FCurPage: IGPage;
  	FCurrentParameter: IGGlobalParameter;
    FCurrentPageNumber: SmallInt;
    FIGManager: TMagIGManager;
    FIOInputLocation: IIGIOLocation;
    FIOSaveLocation: IIGIOLocation;
    FSaveOptions: IGSaveOptions;
    FTotalLocationPageCount: Smallint;
  public
    function CreateNewPDFDoc(PropertyKeywords: String): Boolean;
    property CurDoc: IIGDocument read FCurDoc write FCurDoc;
    property CurFormat: enumIGFormats read FCurFormat write FCurFormat;
    property CurPDFDoc: IGPdfDoc read FCurPdfDoc write FCurPdfDoc;
    property CurPage: IGPage read FCurPage write FCurPage;
    property CurrentPageNumber: SmallInt read FCurrentPageNumber write FCurrentPageNumber;
    property CurrentParameter: IGGlobalParameter read FCurrentParameter write FCurrentParameter;
    property IGManager: TMagIGManager read FIGManager write FIGManager;
    function InitializeIG: String;
    property IOInputLocation: IIGIOLocation read FIOInputLocation write FIOInputLocation;
    property IOSaveLocation: IIGIOLocation read FIOSaveLocation write FIOSaveLocation;
    property SaveOptions: IGSaveOptions read FSaveOptions write FSaveOptions;
    property TotalLocationPageCount: SmallInt read FTotalLocationPageCount write FTotalLocationPageCount;
  var
	  m_FixedPoint: IGPDFFixedPoint;
  end;

  {The TPdfMaker class builds the disclosure PDF file and handles the construction of the
   patient disclosure folder and all files in it. It also builds the manifest file.}
  TPdfMaker = class
  private
    FSrcFiles: TextFile;
    FAccusoft: TAccusoft;
    FDocList: TDocumentList;
    FPDFSaveToDir: String;
    Fm_hRoot: IGPDFBookmark;
    Fm_nNewCount: Longint;
    FBM: IIGPDFBookmark;

    FROI_Office_Name: String;
    FManiRoot: String;
    FManiPatDir: String;
    FPatName: String;
    FPatICN: String;
    FPatSSN: String;
    FPatDOB: String;

    FSiteCode: String;
    FNoteTitle: String;
    FMedProc: String;
    FMedProcDate: String;
    FShortDesc: String;
    FImageType: String;
    FSpecialty: String;
    FEvent: String;
    FOrigin: String;

    FDisclosureDate: String;
    FDisclosureTime: String;

    FManiFullPath: String;
    FManiFullName: String;
    FSrcFileList: String;

    FJobID: String;
    FDebugMode: Boolean;

    FPDFFilePageCount: Integer;

    function Build_Manifest_Path: String;
    function GetDocType(Ext: String): TDocType;
    function DocTypeToStr(dt: TDocType): String;
    procedure NewBookmark(BMTitle: String; BMPage: IGPage);
    function AddAPDFFile(DisclNum: Integer; PDFFilename: String; Bookmark: String): Boolean;
    function InsertFromPDF(DisclNum: Integer; PDFFilename: String; InputDoc: TDocument; Bookmark: String): Boolean;
    procedure AddSummaryToManifest(DisclNum: Integer; AddType: TAddType; InputFilename: String; InputDoc: TDocument; DestFileName: String);
    procedure GetDocSecurityInfo(PDFDoc: IGPDFDoc; InputDoc: TDocument);
    function UpdateAcrobat3(SecData: IGPDFSecurityData; InputDoc: TDocument): Boolean;
    function UpdateAcrobat5(SecData: IGPDFSecurityData; InputDoc: TDocument): Boolean;
    function UpdateAcrobat6(SecData: IGPDFSecurityData; InputDoc: TDocument): Boolean;
    function UpdateNoSecurity(InputDoc: TDocument): Boolean;
    procedure GetDocInfo(PDFDoc: IGPDFDoc; InputDoc: TDocument);
    function ValidateInput: String;
  public
    procedure MakePDF(ROI_Office_Name: String; InputSrcFile: String;
                      PatientName: String; PatientICN: String;
                      ManifestLocation: String; var sRetCode: String);
    procedure StartDisclosureSession(var RetCode: String);
    procedure SavePDFDocToFile(SaveFN: String; var RetCode: Boolean);
    function AddAFile(Filename: String; Bookmark: String): Boolean;
    function AddAPage(PageNum: Integer): Boolean;
    property Accusoft: TAccusoft read FAccusoft write FAccusoft;
    procedure InitDocList;
    property DocList: TDocumentList read FDocList write FDocList;
    property PDFSaveToLocation: String read FPDFSaveToDir write FPDFSaveToDir;
    property SrcFiles: TextFile read FSrcFiles write FSrcFiles;
    property m_hRoot: IGPDFBookmark read Fm_hRoot write Fm_hRoot;
    property m_nNewCount: Longint read Fm_nNewCount write Fm_nNewCount;
    property BM: IIGPDFBookmark read FBM write FBM;
    property ROI_Office_Name: String read FROI_Office_Name write FROI_Office_Name;
    property ManiRoot: String read FManiRoot write FManiRoot;
    property ManiPatDir: String read FManiPatDir write FManiPatDir;
    property PatName: String read FPatName write FPatName;
    property PatICN: String read FPatICN write FPatICN;
    property PatSSN: String read FPatSSN write FPatSSN;
    property PatDOB: String read FPatDOB write FPatDOB;
    property DisclosureDate: String read FDisclosureDate write FDisclosureDate;
    property DisclosureTime: String read FDisclosureTime write FDisclosureTime;
    property ManiFullPath: String read FManiFullPath write FManiFullPath;
    property ManiFullName: String read FManiFullName write FManiFullName;
    property SrcFileList: String read FSrcFileList write FSrcFileList;
    property JobID: String read FJobID write FJobID;
    property DebugMode: Boolean read FDebugMode write FDebugMode;
    property PDFFilePageCount: Integer read FPDFFilePageCount write FPDFFilePageCount;
  end;

  {The TXMLCtl class controls the ArtX XML in memory}
  TXMLCtl = class
    DocCurrentSession : IXMLDocument;
    DocHistoryView : IXMLDocument;
    TmpView: IXMLDocument;
  private
    FAnnotationDir: String;
    FTmpPath: String;
    procedure SaveXMLToFile(fileName : String; XMLDoc : IXMLDocument);
  public
    constructor Create(Dir : string);
    destructor Destroy;
    function SelectNodes(xnRoot: IXmlNode; const nodePath: WideString): IXMLNodeList;
    function SelectNode(xmlRoot: IXmlNode; const nodePath: WideString): IXmlNode;
    procedure LoadCurrentHistoryLayer(xmlLayer : string);        
    procedure LoadHistoryToArtPage(pageNum : Integer);
    procedure LoadCurrentHistoryToArtPage(PN : string; pageNum: Integer);  overload; //p122t4 dmmn 9/29
  end;

  {The TMakeAnnotatedFile class creates a disclosure file from an input file source
   and the latest XML overlay file associated with the input file source.}
  TMakeAnnotatedFile = class
  private
    FAccusoft: TAccusoft;
    FDocList: TDocumentList;
    FPDFSaveToDir: String;

    FCurFormat: enumIGFormats;

    FXMLFileFullPath: String;
    FImageFileFullPath: String;
    FOutputBurnedImageFullPath: String;

    FJobID: String;
    FDebugMode: Boolean;

    FArtPage: IIGArtXPage;
    FCurrentPage: IIGPage;
    FArtPages: array of IIGArtXPage;

    FCurrentDocument : IIGDocument;
    FCurrentPageNumber : Integer;
    FTotalLocationPageCount : Integer;
    FPageCount: Integer;
    FPage: Integer;

    FCurrentPageDisp: IIGPageDisplay;
    FIGArtDrawParams: IIGArtXDrawParams;
    FIgCurPoint: IGPoint;
    PageViewHwnd: Integer;

    FXMLCtl: TXMLCtl;

    FBurnPDFDoc: IGPDFDoc;

    function GetCurrentPage: IIGPage;
    procedure SetCurrentPage(Const Value: IIGPage);
    procedure SetCurrentPageDisp(Const Value: IIGPageDisplay);
    function CreateArtPage: IIGArtXPage; Overload;
    function CreateArtPage(CurrentPage_: IIGPage; CurrentPageDisp_: IIGPageDisplay): IIGArtXPage; Overload;
    function GetIGArtXCtl: TIGArtXCtl;

    function ValidateInput: String;
    procedure BurnImage(var RetCode: String);
    procedure Initialize(CurDoc : IIGDocument; CurPoint: IIGPoint; CurPageDisp: IIGPageDisplay; PageViewHwnd: Integer; ForDiagramAnnotation: Boolean);
    function CreateNewDocument(FN: string): Boolean;
    procedure LoadAllArtPages;
    function ValidateXML(const xmlFile: TFileName): boolean;
    function RemoveTabCharacters(XML: TStringList): String;
    function MakeStampFile(PictureSize: TPictureResolution; StampFile: String; TotalAnnots: Integer; OffsetFromTopOfImage: Integer): Boolean;
    procedure GetAnnotTotals(PN: String; var TotAnnots: Integer);
    function AddAPage(PageNum: Integer; newPage: IGPage; curDoc: IGDocument; curPDFDoc: IGPdfDoc): Boolean;
    function SavePDFPage(SaveName: String;  SaveFormat: enumIGSaveFormats; newPage: IGPage): Boolean;
    procedure AddHeader(PageRes: TPictureResolution; curPageDisp: IIGPageDisplay; var curPage: IGPage; TopOffset: Integer);
  public
    procedure StartAnnotationSession(var RetCode: String);
    property Accusoft: TAccusoft read FAccusoft write FAccusoft;
    property XMLFileFullPath: String read FXMLFileFullPath write FXMLFileFullPath;
    property ImageFileFullPath: String read FImageFileFullPath write FImageFileFullPath;
    property OutputBurnedImageFullPath: String read FOutputBurnedImageFullPath write FOutputBurnedImageFullPath;
    property JobID: String read FJobID write FJobID;
    property DebugMode: Boolean read FDebugMode write FDebugMode;
    property ArtPage: IIGArtXPage Read FArtPage Write FArtPage;
    property CurrentPage: IIGPage Read GetCurrentPage Write SetCurrentPage;
    property CurrentPageDisp: IIGPageDisplay Read FCurrentPageDisp Write SetCurrentPageDisp;
    property IGArtXCtl: TIGArtXCtl Read GetIGArtXCtl;
    property IgCurPoint: IGPoint read FIgCurPoint write FIgCurPoint;
    property IGArtDrawParams: IIGArtXDrawParams read FIGArtDrawParams write FIGArtDrawParams;

    property CurrentDocument: IIGDocument read FCurrentDocument write FCurrentDocument;
    property TotalLocationPageCount: Integer read FTotalLocationPageCount write FTotalLocationPageCount;
    property PageCount: Integer read FPageCount write FPageCount;
    property Page: Integer read FPage write FPage;
    property CurrentPageNumber: Integer read FCurrentPageNumber write FCurrentPageNumber;

    property XMLCtl: TXMLCtl read FXMLCtl write FXMLCtl;

    property BurnPDFDoc: IGPDFDoc read FBurnPDFDoc write FBurnPDFDoc;

    property CurFormat: enumIGFormats read FCurFormat write FCurFormat;
  end;

var
  Make_PDF: TPdfMaker;   {Instance variable}
  Make_AnnotatedFile: TMakeAnnotatedFile; {Instance variable}
  DisclosureNumber: Integer; {Tracks the disclosure file being processed}

function Delphi_TestConnection: Boolean; stdcall;
begin
  Result := True; 
end;

procedure Delphi_MakePDFDoc(
                 JobID: String;
                 DebugMode: String;
                 ROI_Office_Name: String;
                 InputSrcFileList: String;
                 ManifestRoot: String;
                 ManifestPatDir: String;
                 PatientName: String;
                 PatientICN: String;
                 PatientSSN: String;
                 PatientDOB: String;
                 DisclosureDate: String;
                 DisclosureTime: String;
                 var RetCode: String); stdcall;
var
  CalledFrom: String;
begin
  Make_PDF := TPdfMaker.Create;

  try

    Make_PDF.JobID := JobID;

    if DebugMode <> 'T' then
      Make_PDF.DebugMode := False
    else
      Make_PDF.DebugMode := True;

    Make_PDF.ROI_Office_Name := ROI_Office_Name;
    Make_PDF.SrcFileList     := InputSrcFileList;
    Make_PDF.ManiRoot        := ManifestRoot;
    Make_PDF.ManiPatDir      := ManifestPatDir;
    Make_PDF.PatName         := PatientName;
    Make_PDF.PatICN          := PatientICN;
    Make_PDF.PatSSN          := PatientSSN;
    Make_PDF.PatDOB          := PatientDOB;

    Make_PDF.DisclosureDate  := DisclosureDate;
    Make_PDF.DisclosureTime  := DisclosureTime;

    Make_PDF.ManiFullPath    := Make_PDF.Build_Manifest_Path;

    Make_PDF.ManiFullName    := Make_PDF.ManiFullPath   + '\' +
                                Make_PDF.PatName        + '_' +
                                Make_PDF.PatICN         + '_' +
                                Make_PDF.DisclosureDate + '_' +
                                Make_PDF.DisclosureTime +
                                '.txt';

    Make_PDF.PDFSaveToLocation := Make_PDF.ManiFullPath   + '\' +
                                  Make_PDF.PatName        + '_' +
                                  Make_PDF.PatICN         + '_' +
                                  Make_PDF.DisclosureDate + '_' +
                                  Make_PDF.DisclosureTime +
                                  '.pdf';

    CalledFrom := 'CONSOLE_APP';

    if Uppercase(CalledFrom) = 'CONSOLE_APP' then
      TLogger.OpenManifest(Make_PDF.ManiFullName, Make_PDF.DebugMode, rtConsoleApp)
    else
      TLogger.OpenManifest(Make_PDF.ManiFullName, Make_PDF.DebugMode, rtGuiApp);

    TLogger.Log(TraceIn, 'Entered Delphi_MakePDFDoc');

    RetCode := '';

    {Call the main routine to start a disclosure session}
    Make_PDF.StartDisclosureSession(RetCode);

    TLogger.Log(Debug, 'Make_PDF.StartDisclosureSession RetCode = ' + RetCode);

    if RetCode <> '0' then
      TLogger.Log(Error, 'From Delphi (-99): Delphi_Make_PDF.StartDisclosureSession: ' + RetCode);

    TLogger.Log(TraceOut, 'From Delphi: Delphi_MakePDFDoc');

  except
    on E:Exception do
    begin
      RetCode := 'Delphi error -100';
      E.Message := 'From Delphi (-100): Delphi_MakePDFDoc exception: ' + E.Message;
      TLogger.Log(Error, E.Message);
    end;
  end;
end;

procedure Delphi_PDFJobCompleted; stdcall;
var
  i: Integer;
begin
  TLogger.Log(Info, 'Disclosure Request Completed for JobID: ' + Make_PDF.JobID);
  TLogger.CloseManifest;

  GetIGManager.Free;

  for i := Make_PDF.FDocList.Count - 1 downto 0 do
    Make_PDF.FDocList.Remove(Make_PDF.FDocList.Items[i]);

  Make_PDF.Doclist.Free;

  Make_PDF.Accusoft.IGManager.Free;

  Make_PDF.Accusoft.Free;

  FreeAndNil(Make_PDF);

end;


procedure Delphi_MakeAnnotatedFile(
                     JobID: String;
                     DebugMode: String;
                     ImageFileFullPath: String;
                     XMLFileFullPath: String;
                     OutputBurnedImageFullPath: String;
                     var RetCode: String); stdcall;
var
  Excp: Exception;
  CalledFrom: String;
  AnnotateLog: String;
begin
  RetCode := '-1';

  if Make_AnnotatedFile <> nil then
    FreeAndNil(Make_AnnotatedFile);

  Make_AnnotatedFile := TMakeAnnotatedFile.Create;

  try

    Make_AnnotatedFile.XMLFileFullPath           := XMLFileFullPath;
    Make_AnnotatedFile.ImageFileFullPath         := ImageFileFullPath;
    Make_AnnotatedFile.OutputBurnedImageFullPath := OutputBurnedImageFullPath;
    Make_AnnotatedFile.JobID                     := JobID;

    if DebugMode <> 'T' then
      Make_AnnotatedFile.DebugMode := False
    else
      Make_AnnotatedFile.DebugMode := True;

    CalledFrom := 'CONSOLE_APP';
    AnnotateLog := ExtractFileDir(Make_AnnotatedFile.OutputBurnedImageFullPath) + '\AnnotateLog.txt';

    if Uppercase(CalledFrom) = 'CONSOLE_APP' then
      TLogger.OpenManifest(AnnotateLog, Make_AnnotatedFile.DebugMode, rtConsoleApp)
    else
      TLogger.OpenManifest(AnnotateLog, Make_AnnotatedFile.DebugMode, rtGuiApp);

    TLogger.Log(TraceIn, 'Delphi_MakeAnnotatedFile');

    RetCode := '-1';

    Make_AnnotatedFile.StartAnnotationSession(RetCode);
    TLogger.Log(Debug, 'Make_AnnotatedFile.StartAnnotationSession: ' + RetCode);

    TLogger.Log(TraceOut, 'From Delphi: Delphi_MakeAnnotatedFile');
  except
    on E:Exception do
    begin
      RetCode := 'Delphi Error -102';
      E.Message := 'From Delphi (-102): Delphi_MakeAnnotatedFile exception: ' + E.Message;
      TLogger.Log(Error, E.Message);
    end;
  end;
end;

procedure Delphi_AnnotatedJobCompleted; stdcall;
var
  i: Integer;
begin
  TLogger.Log(Info, 'Burn Annotation Request Completed for JobID: ' + Make_AnnotatedFile.JobID);
  TLogger.CloseManifest;

  GetIGManager.Free;

  Make_AnnotatedFile.Accusoft.IGManager.Free;

  Make_AnnotatedFile.Accusoft.Free;

  FreeAndNil(Make_AnnotatedFile);
end;

procedure TPdfMaker.StartDisclosureSession(var RetCode: String);
var
  sRetCode: String;
begin
  try
    TLogger.Log(TraceIn, 'TPdfMaker.StartDisclosureSession');

    sRetCode := Make_PDF.ValidateInput;
    if sRetCode <> '' then
    begin
      RetCode := sRetCode;
      Exit;
    end;

    TLogger.Log(Info, 'Disclosure Version = ' + GetDLLVersion);

    TLogger.Log(Debug, 'ManiFullPath = '      + Make_PDF.ManiFullPath);
    TLogger.Log(Debug, 'ManiFullName = '      + Make_PDF.ManiFullName);
    TLogger.Log(Debug, 'PDFSaveToLocation = ' + Make_PDF.PDFSaveToLocation);
    TLogger.Log(Debug, 'SrcFileList = '       + Make_PDF.SrcFileList);

    Make_PDF.Accusoft := TAccusoft.Create;

    Make_PDF.InitDocList;

    RetCode := Make_PDF.Accusoft.InitializeIG;

    if RetCode <> '0' then
    begin
      RetCode := 'TPdfMaker.StartDisclosureSession: InitializeIG ReturnCode = ' + RetCode;
      TLogger.Log(Error, 'TPdfMaker.StartDisclosureSession: ' + RetCode);
      Exit;
    end;

    sRetCode := '';

    Make_PDF.MakePDF(Make_PDF.ROI_Office_Name,
                     Make_PDF.SrcFileList,
                     Make_PDF.PatName,
                     Make_PDF.PatICN,
                     Make_PDF.ManiFullPath,
                     sRetCode);

    RetCode := sRetCode;

    if AnsiContainsStr(Uppercase(RetCode), 'ERROR') then
    begin
      TLogger.Log(Error, 'TPdfMaker.StartDisclosureSession: Error = ' + RetCode);
      RetCode := 'TPdfMaker.StartDisclosureSession: Error = ' + RetCode;
      TLogger.Log(Error, 'TPdfMaker.StartDisclosureSession: ' + RetCode);
      Exit;
    end;

    TLogger.Log(TraceOut, 'TPdfMaker.StartDisclosureSession');
  except
    on E:Exception do
    begin
     TLogger.Log(Debug, 'TPdfMaker.StartDisclosureSession: Exception (-105) = ' + E.Message);
     RetCode := '-105';
    end;
  end;
end;

procedure TPdfMaker.MakePDF(ROI_Office_Name: String;
                            InputSrcFile: String;
                            PatientName: String;
                            PatientICN: String;
                            ManifestLocation: String;
                            var sRetCode: String);
var
  S: String;
  i: Integer;
  FileName: String;
  FileExtension: String;
  InputDoc: TDocument;
  InputFile: String;
  Bookmark: String;
  bRetCode: Boolean;
  PropertyKeywords: String;
begin
  TLogger.Log(TraceIn, 'TPdfMaker.MakePDF');

  try
    PDFFilePageCount := 0;

    i := 1;

    PropertyKeywords := '';
    AssignFile(SrcFiles, InputSrcFile);
    try
      Reset(SrcFiles);
      while not eof(SrcFiles) do
      begin
        Readln(SrcFiles,S);
        PropertyKeywords := PropertyKeywords + S;
      end;
    finally
      CloseFile(SrcFiles);
    end;


    if not Accusoft.CreateNewPDFDoc(PropertyKeywords) then
    begin
      sRetCode := 'DELPHI_ERROR-16 Accusoft.CreateNewPDFDoc: Cannot create a new PDF Document';  {-16 = TAccusoft: Cannot create a new PDF in ImageGear}
      Exit;
    end;

    if FileExists(InputSrcFile) = False then
    begin
      sRetCode := 'DELPHI_ERROR-15 on InputSrcFile = ' + InputSrcFile;  {-15 = MakePDF: InputSrcFile - file does not exist}
      Exit;
    end
    else
    begin

      {Create the manifest and build the manifest header}
      AssignFile(SrcFiles, InputSrcFile);
      Reset(SrcFiles);

      try
        TLogger.Log(Info, '***********************************************************************');
        TLogger.Log(Info, '***');
        TLogger.Log(Info, '*** Veterans Administration Patient Release of Information');
        TLogger.Log(Info, '*** ' + Make_PDF.ROI_Office_Name );
        TLogger.Log(Info, '***');
        TLogger.Log(Info, '*** Disclosure for Patient:');
        TLogger.Log(Info, '*** Patient Name: ' + PatientName + ', Patient ID: ' + Make_PDF.PatICN);
        TLogger.Log(Info, '*** Patient SSN: ' + Make_PDF.PatSSN + ', Patient DOB: ' + Make_PDF.PatDOB);
        TLogger.Log(Info, '*** Disclosure Created on: ' + Make_PDF.DisclosureDate + ' at ' + Make_PDF.DisclosureTime);
        TLogger.Log(Info, '*** Job ID: ' + Make_PDF.JobID);
        TLogger.Log(Info, '***');
        TLogger.Log(Info, '***********************************************************************');
        TLogger.Log(Info, '');

        m_hRoot := Accusoft.curPDFDoc.GetBookmark;

        DisclosureNumber := 1;

        while not eof(SrcFiles) do
        begin
          Readln(SrcFiles,S);

          if AnsiContainsStr(S, '^') then
          begin
            InputFile := MagPiece(S, '^', 1);
            Bookmark  := MagPiece(S, '^', 2);
          end
          else
          begin
            InputFile := S;
            Bookmark  := ExtractFilename(S);
          end;

          FileName      := Uppercase(ExtractFilename(InputFile));
          FileExtension := UpperCase(ExtractFileExt(InputFile));

          TLogger.Log(Info, 'DISCLOSURE #' + IntToStr(i) + '. Releasing a copy of file: ' + Filename + ' with bookmark: ' + Bookmark);

          if (FileExtension = '.JPG')  or
             (FileExtension = '.JPEG') or
             (FileExtension = '.TIF')  or
             (FileExtension = '.TIFF') or
             (FileExtension = '.BMP')  then
            AddAFile(InputFile, Bookmark)

          else if FileExtension = '.PDF' then
            AddAPDFFile(i, InputFile, Bookmark)

          else
          begin
            {Files other than BMP, TIF, JPG, and PDF will be copied to the disclosure
             location and an entry added to the manifest. The design of P130 states that
             DCM and TGA files will be routed to the DICOM Gateway and queued to produce
             a DICOM CD.  This DLL should not have to worry about DCM or TGA types. However,
             if they do show up in the input list, they will get copied to the user's
             disclosure folder along with the other types like MPG, AVI, etc.}
            InputDoc := TDocument.Create;
            DocList.Add(InputDoc);
            InputDoc.DocType  := GetDocType(FileExtension);
            InputDoc.DocName  := FileName;
            InputDoc.Bookmark := Bookmark;
            Copyfile(InputFile, Make_PDF.ManiFullPath + '\' + Filename);
            AddSummaryToManifest(DisclosureNumber, atAddToDisclosureFolder, InputFile, InputDoc, Make_PDF.ManiFullPath);
          end;

          inc(i);
          inc(DisclosureNumber);
        end;

        if PDFFilePageCount > 0 then
        begin
          SavePDFDocToFile(PDFSaveToLocation, bRetCode);
          if bRetCode then
            sRetCode := '0'
          else
            sRetCode := 'DELPHI ERROR-17: TPdfMaker.MakePDF'; {-17 = MakePDF: SavePDFDocToFile failed}
        end
        else
          sRetCode := '0';

      finally
        CloseFile(SrcFiles);
      end;
    end;
    TLogger.Log(TraceOut, 'TPdfMaker.MakePDF');
  except
    on E:Exception do
    begin
      sRetCode := 'DELPHI ERROR-2, Exception = ' + E.Message + ', Input File = ' + S;  {-2 = MakePDF: Exception occured in MakePDF}
    end;
  end;
end;

procedure TPdfMaker.SavePDFDocToFile(SaveFN: String; var RetCode: Boolean);
begin
  RetCode := False;
	try
		Accusoft.IOSaveLocation := nil;
		Accusoft.IOSaveLocation := GetIGManager.IGFormatsCtrl.CreateObject(IG_FORMATS_OBJ_IOFILE) as IIGIOLocation;

    if FileExists(SaveFN) then
      if not DeleteFile(SaveFN) then
      begin
        TLogger.Log(ERROR, 'Cannot create a new PDF file because the old PDF file [ ' + SaveFN + ' ] cannot be deleted' + #13#10 +
                      'Please manually delete before doing this action again.');
        Exit;
      end;

		(Accusoft.ioSaveLocation as IIGIOFile).FileName := SaveFN;
   	Accusoft.SaveOptions.Format := IG_SAVE_PDF_UNCOMP;

		{Save/overwrite document to specified location}
		GetIGManager.IGFormatsCtrl.SaveDocument(
          Accusoft.CurDoc,
          Accusoft.ioSaveLocation,
          0,
          0,
          Accusoft.CurDoc.PageCount,
          IG_DOCSAVEMODE_OVERWRITE,
          Accusoft.SaveOptions);

    RetCode := True;

	except
    on E:Exception do
    begin
      RetCode := False;
  		TLogger.Log(Error, 'TPdfMaker.SavePDFDocToFile to location =[' + SaveFN + '], Exception message = ' + E.Message + ', ' + GetIGManager.CheckErrors);
    end;
	end;
end;

function TPdfMaker.ValidateInput: String;
begin
  Result := '';
  try
    if Trim(Make_PDF.JobID) = '' then
    begin
      TLogger.Log(Error, 'TPdfMaker.ValidateInput: Result = -1');
      Result := 'DELPHI_ERROR-1';  {-1 = ValidateInput: JobID is blank}
      Exit;
    end;

    if Trim(Make_PDF.PatName) = '' then
    begin
      TLogger.Log(Error, 'TPdfMaker.ValidateInput: Result = -2');
      Result := 'DELPHI_ERROR-2';  {-2 = ValidateInput: Patient Name is blank}
      Exit;
    end;

    if Trim(Make_PDF.PatSSN) = '' then
    begin
      TLogger.Log(Error, 'TPdfMaker.ValidateInput: Result = -3');
      Result := 'DELPHI_ERROR-3';  {-3 = ValidateInput: PatSSN is blank}
      Exit;
    end;

    if Trim(Make_PDF.PatDOB) = '' then
    begin
      TLogger.Log(Error, 'TPdfMaker.ValidateInput: Result = -4');
      Result := 'DELPHI_ERROR-4';  {-4 = ValidateInput: PatDOB is blank}
      Exit;
    end;

    if Trim(Make_PDF.PatICN) = '' then
    begin
      TLogger.Log(Error, 'TPdfMaker.ValidateInput: Result = -5');
      Result := 'DELPHI_ERROR-5';  {-5 = ValidateInput: PatICN is blank}
      Exit;
    end;

    if Trim(Make_PDF.ManiRoot) = '' then
    begin
      TLogger.Log(Error, 'TPdfMaker.ValidateInput: Result = -6');
      Result := 'DELPHI_ERROR-6';  {-6 = ValidateInput: ManifestRoot is blank}
      Exit;
    end;

    if Trim(Make_PDF.ManiPatDir) = '' then
    begin
      TLogger.Log(Error, 'TPdfMaker.ValidateInput: Result = -7');
      Result := 'DELPHI_ERROR-7';  {-7 = ValidateInput: Manifest Patient Dir is blank}
      Exit;
    end;

    if Trim(Make_PDF.ROI_Office_Name) = '' then
    begin
      TLogger.Log(Error, 'TPdfMaker.ValidateInput: Result = -8');
      Result := 'DELPHI_ERROR-8';  {-8 = ValidateInput: ROI Office Name is blank}
      Exit;
    end;

    if Trim(Make_PDF.DisclosureDate) = '' then
    begin
      TLogger.Log(Error, 'TPdfMaker.ValidateInput: Result = -9');
      Result := 'DELPHI_ERROR-9';  {-9 = ValidateInput: DisclosureDate is blank}
      Exit;
    end;

    if Trim(Make_PDF.DisclosureTime) = '' then
    begin
      TLogger.Log(Error, 'TPdfMaker.ValidateInput: Result = -10');
      Result := 'DELPHI_ERROR-10';  {-10 = ValidateInput: DisclosureTime is blank}
      Exit;
    end;

  except
    on E:Exception do
    begin
      Result := 'DELPHI_ERROR-11 Validate Input [' + E.Message + ']';  {-11 = ValidateInput: exception raised}
      TLogger.Log(Error, 'TPdfMaker.ValidateInput: Result = DELPHI_ERROR-11');
    end;
  end;
end;

function TPdfMaker.Build_Manifest_Path: String;
begin
  try
    if not DirectoryExists(Make_PDF.ManiRoot) then
      if not ForceDirectories(Make_PDF.ManiRoot) then
      begin
        TLogger.Log(Error, 'TPdfMaker.Initialize_Manifest: Result = ERROR-12, ManifestRoot = ' + Make_PDF.ManiRoot);
        Result := 'DELPHI_ERROR-12 Cannot create Manifest Root folder: ' + Make_PDF.ManiRoot;  {-12 = Build_Manifest_Path: cannot create Manifest Root folder}
        Exit;
      end;

    Result := Make_PDF.ManiRoot + '\' + Make_PDF.FManiPatDir;

    if not DirectoryExists(Result) then
      if not ForceDirectories(Result) then
      begin
        TLogger.Log(Error, 'TPdfMaker.Initialize_Manifest: Result = ERROR-13, Manifest Patient Directory = ' + Result);
        Result := 'DELPHI_ERROR-13 Cannot create folder: ' + Result;  {-13 = Build_Manifest_Path: cannot create directory}
        Exit;
      end;

  except
    on E:Exception do
    begin
      Result := 'DELPHI_ERROR-14 TPdfMaker.Build_Manifest_Path [' + E.Message + ']'; {-14 = Build_Manifest_Path: cannot create directory}
      TLogger.Log(Error, 'TPdfMaker.Initialize_Manifest: Result = DELPHI_ERROR-14 TPdfMaker.Build_Manifest_Path [' + E.Message + ']');
    end;
  end;
end;

function TAccusoft.InitializeIG: String;
begin
  TLogger.Log(TraceIn, 'TAccusoft.InitializeIG');

  if IGManager <> nil then
    IGManager.Free;

  IGManager := TMagIGManager.Create;
  TLogger.Log(Debug, 'InitializeIG: IGManager created');

	try
		{Associate controls with CORE}
		GetIGManager.IGCoreCtrl.AssociateComponent(GetIGManager.IGFormatsCtrl.ComponentInterface);
    TLogger.Log(Debug, 'InitializeIG: IGManager.IGFormatsCtrl associated');

		GetIGManager.IGCoreCtrl.AssociateComponent(GetIGManager.IGProcessingCtrl.ComponentInterface);
    TLogger.Log(Debug, 'InitializeIG: IGManager.IGProcessingCtrl associated');

    GetIGManager.IGCoreCtrl.AssociateComponent(GetIGManager.IGArtXCtrl.ComponentInterface);
    TLogger.Log(Debug, 'InitializeIG: IGManager.IGArtXCtrl associated');

		GetIGManager.IGCoreCtrl.AssociateComponent(GetIGManager.IGPdfCtrl.ComponentInterface);
    TLogger.Log(Debug, 'InitializeIG: IGManager.IGPdfCtrl associated');

		{Create new save and load options}
		saveOptions := GetIGManager.IGFormatsCtrl.CreateObject(IG_FORMATS_OBJ_SAVEOPTIONS) as IIGSaveOptions;
		saveOptions.Format := IG_SAVE_UNKNOWN;

    TLogger.Log(Debug, 'InitializeIG: saveOptions object created');

    {JK - the following lines are necessary to maintain color fidelity. Otherwise without it
     the image has a blue cast.  Don't yet know why.}
		currentParameter := GetIGManager.IGCoreCtrl.CreateObject(IG_OBJ_GLOBAL_PARAM) as IIGGlobalParameter;
		currentParameter.Value.ChangeType(IG_DATA_LONG);
		currentParameter.info := 'Use legacy mode for pixel access.';
		currentParameter.name := 'DIB.PIX_ACCESS_USE_LEGACY_MODE';
		currentParameter.Value.Long := 1;
		GetIGManager.IGCoreCtrl.Settings.UpdateParamFrom(currentParameter);
    TLogger.Log(Debug, 'InitializeIG: currentParameter object created');

		{Turn on ERRINFO notification mode: ImageGear calls will throw errors.}
		GetIGManager.IGCoreCtrl.Result.NotificationFlags := IG_ERR_OLE_ERROR;

    Result := '0';

    TLogger.Log(TraceOut, 'TAccusoft.InitializeIG');
	except
    on E:Exception do
    begin
      TLogger.Log(Error, 'TAccusoft.InitializeIG exception = ' + E.Message);
      Result := GetIGManager.checkErrors;
    end;
	end;
end;

function TAccusoft.CreateNewPDFDoc(PropertyKeywords: String): Boolean;
var
  PDFDisclDate: String;
begin
  Result := False;
  try
    TLogger.Log(TraceIn, 'TAccusoft.CreateNewPDFDoc');

		if curDoc <> nil then
      curDoc.Clear
    else
  		curDoc := GetIGManager.IGCoreCtrl.CreateDocument(0);

	  {Create new PDF document from the current document}
    if curPDFDoc <> nil then
      curPDFDoc.Document.Clear
    else
  	  curPDFDoc := GetIGManager.IGPdfCtrl.CreatePDFDoc(curDoc);

	  curFormat := IG_FORMAT_PDF;

    curPDFDoc.SetInfo('Title', 'Disclosure for ' + Make_PDF.PatName + ' made on ' + Make_PDF.DisclosureDate);
    curPDFDoc.SetInfo('Author', Make_PDF.ROI_Office_Name);
    curPDFDoc.SetInfo('Subject', 'VA Disclosure - Release of Information - Private and Confidential');
    curPDFDoc.SetInfo('Keywords', PropertyKeywords);

    PDFDisclDate := 'D:' + Make_PDF.DisclosureDate + Make_PDF.DisclosureTime;
    curPDFDoc.SetInfo('CreationDate', PDFDisclDate);

    Result := True;
    TLogger.Log(TraceOut, 'TAccusoft.CreateNewPDFDoc');
  except
    on E:Exception do
      TLogger.Log(Error, 'TAccusoft.CreateNewPDFDoc: ' + GetIGManager.checkErrors);
  end;
end;

procedure TPDFMaker.InitDocList;
begin
  TLogger.Log(TraceIn, 'TPDFMaker.InitDocList');
  if DocList = nil then
  begin
    DocList := TDocumentList.Create;
    DocList.OwnsObjects := True;
    TLogger.Log(TraceOut, 'TPDFMaker.InitDocList');
  end;
end;

function TPDFMaker.AddAPage(PageNum: Integer): Boolean;
var
	MediaBox: IGPDFFixedRect;
	newPDFPage: IGPDFPage;
	pdeContent: IGPDEContent;
	pdeImage: IGPDEImage;
	xy: IGPDFFixedPoint;

  PageCnt: Integer;
  i: Integer;
  rasterPage: IGPage;

  PgWidth, PgHeight: Integer;
begin
	try
    TLogger.Log(TraceIn, 'TPDFMaker.AddAPage: PageNum = ' + IntToStr(PageNum));
    Result := False;

    rasterPage := GetIGManager.IGCoreCtrl.CreatePage;

    GetIGManager.IGFormatsCtrl.LoadPageFromFile(rasterPage, (Accusoft.IOInputLocation as IIGIOFile).FileName, PageNum);

    if GetIGManager.IGCoreCtrl.Result.RecordsTotal <> 0 then
      TLogger.Log(Error, 'TPDFMaker.AddAPage: I should be showing the error stack now - JK');

    PgWidth := rasterPage.GetDIBInfo.Width;
    PgHeight := rasterPage.GetDIBInfo.Height;

		{Create a blank page}
		MediaBox := GetIGManager.IGPDFCtrl.CreateObject(IG_PDF_FIXEDRECT) as IIGPDFFixedRect;
		MediaBox.Left := 0;
		MediaBox.Bottom := 0;
		MediaBox.Right := GetIGManager.IGPDFCtrl.LongToFixed(PgWidth);
		MediaBox.Top := GetIGManager.IGPDFCtrl.LongToFixed(PgHeight);

		{Create a new page right after the last page}
		Accusoft.curPDFDoc.CreateNewPage(Accusoft.curDoc.PageCount-1, MediaBox);

		{Set the current page to the last one}
		AccuSoft.CurrentPageNumber := Accusoft.curDoc.PageCount-1;

		{Set the total page count}
		Accusoft.TotalLocationPageCount := Accusoft.curDoc.PageCount;

		if  Accusoft.CurPage <> nil then begin
			// curPage.Clear
		end;

		Accusoft.CurPage := Accusoft.curDoc.Page[Accusoft.CurrentPageNumber];

		{Create an empty PDF page}
		newPDFPage := GetIGManager.IGPDFCtrl.CreatePDFPage(Accusoft.CurPage);

		{Get the PDF page content}
		pdeContent := newPDFPage.GetContent;

    {Create the PDF page image from the image raster}
    xy := GetIGManager.IGPDFCtrl.CreateObject(IG_PDF_FIXEDPOINT) as IIGPDFFixedPoint;
    xy.H := 0;
    xy.V := 0;
    pdeImage := CreateImage(xy, True, rasterPage);      

    {Add the PDF image to the content}
    pdeContent.AddElement(IG_PDE_AFTER_LAST, pdeImage);

    {Set the PDF page content}
    newPDFPage.SetContent();

    newPDFPage.ReleaseContent();

    Result := True;
    TLogger.Log(TraceOut, 'TPDFMaker.AddAPage');
	except
    on E:Exception do
    begin
  		TLogger.Log(Error, 'TPDFMaker.AddAPage(' + IntToStr(PageNum) + '): ' + GetIGManager.checkErrors + ', Exception = ' + E.Message);
    end;
	end;
end;

procedure TPDFMaker.NewBookmark(BMTitle: String; BMPage: IGPage);
var
	title: AnsiString;
	hBM: IGPDFBookmark;
  hDest: IGPDFDestination;
  hFitType: IGPDFAtom;
	Rect: IGPDFFixedRect;
	hAction: IGPDFAction;
begin
  TLogger.Log(TraceIn, 'TPDFMaker.NewBookmark: BMTitle = ' + BMTitle);
	try

		m_nNewCount := m_nNewCount + 1;
		title := 'Untitled ' + IntToStr(m_nNewCount);
		title := BMTitle;

		if title <> '' then
    begin
      hBM := m_hRoot.FindTitle(title, -1);
      if hBM = nil then
      begin
        m_hRoot.AddNewChild(title);
        hBM := m_hRoot.FindTitle(title, -1);

        hFitType := GetIGManager.IGPDFCtrl.CreateObject(IG_PDF_ATOM) as IIGPDFAtom;
        hFitType.String_ := 'Fit';
        Rect := GetIGManager.IGPDFCtrl.CreateObject(IG_PDF_FIXEDRECT) as IIGPDFFixedRect;
        Rect.Left := 0;
        Rect.Top := 0;
        Rect.Right := 612;
        Rect.Bottom := 792;

        hDest := GetIGManager.IGPDFCtrl.CreateDestination(Accusoft.curPDFDoc, GetIGManager.IGPDFCtrl.CreatePDFPage(BMPage), hFitType, Rect, 1);

        if  hDest <> nil then
        begin
    			hAction := GetIGManager.IGPDFCtrl.CreateActionFromDestination(Accusoft.curPDFDoc, hDest);
		      if hAction <> nil then
            hBM.SetAction(hAction);
        end;
      end
      else
			  hBM.AddNewSibling((title));
		end;

    TLogger.Log(TraceOut, 'TPDFMaker.NewBookmark');

	except
		TLogger.Log(Error, 'TPDFMaker.NewBookmark [' + BMTitle + '] ' + GetIGManager.checkErrors);
	end;
end;

function TPDFMaker.AddAFile(Filename: String; Bookmark: String): Boolean;
var
  i: Integer;
  curInputFilePageCnt: Integer;
  InputDoc: TDocument;
  FN: String;
begin
  try
    TLogger.Log(TraceIn, 'TPDFMaker.AddAFile: Adding ' + Filename);

    FN := ExtractFilename(Filename);

    InputDoc := TDocument.Create;
    DocList.Add(InputDoc);

    InputDoc.FDocProcessingMsgs.Add('Retrieved Disclosure Item from VistA: ' + Filename);
    InputDoc.DocName := Filename;

    InputDoc.DocType := GetDocType(ExtractFileExt(InputDoc.DocName));
    InputDoc.FDocProcessingMsgs.Add('Adding ' + InputDoc.DocName + ' to Disclosures');

    Accusoft.IOInputLocation := nil;
    Accusoft.IOInputLocation := GetIGManager.IGFormatsCtrl.CreateObject(IG_FORMATS_OBJ_IOFILE) as IIGIOLocation;
    (Accusoft.IOInputLocation as IIGIOFile).FileName  := FileName;

    curInputFilePageCnt := GetIGManager.IGFormatsCtrl.GetPageCount(Accusoft.IOInputLocation, IG_FORMAT_UNKNOWN);
    InputDoc.PageCount := curInputFilePageCnt;

    Result := True;

    for i := 0 to curInputFilePageCnt - 1 do
    begin
      if not AddAPage(i) then
      begin
        InputDoc.FDocProcessingMsgs.Add('Could not add page [ ' + IntToStr(i) + ' ] of ' + Filename + ' to the disclosure file');
        Result := False;
      end;

      if (i = 0) and (Result = True) then
        NewBookmark(Bookmark, Accusoft.curPage);

    end;

    if Result = False then
    begin
      Copyfile(Filename, Make_PDF.ManiFullPath + '\' + FN);
      AddSummaryToManifest(DisclosureNumber, atAddToDisclosureFolder, Filename, InputDoc, Make_PDF.ManiFullPath);
      TLogger.Log(TraceOut, 'TPDFMaker.AddAFile (' + Filename + '): Result = False')
    end
    else
    begin
      PDFFilePageCount := PDFFilePageCount + 1;
      AddSummaryToManifest(DisclosureNumber, atAddToDisclosurePDF, Filename, InputDoc, Make_PDF.ManiFullPath);
      TLogger.Log(TraceOut, 'TPDFMaker.AddAFile (' + Filename + '): Result = True')
    end;
  except
    on E:Exception do
      TLogger.Log(Debug, 'TPDFMaker.AddAFile Exception (' + Filename + '): ' + E.Message);
  end;

end;

function TPDFMaker.AddAPDFFile(DisclNum: Integer; PDFFilename: String; Bookmark: String): Boolean;
var
  InputDoc: TDocument;
  FN: String;
begin
  TLogger.Log(TraceIn, 'TPDFMaker.AddAPDFFile: ' + PDFFilename + ', Bookmark: ' + Bookmark);

  FN := ExtractFilename(PDFFilename);

  InputDoc := TDocument.Create;
  DocList.Add(InputDoc);
  InputDoc.DocName := PDFFilename;

  InputDoc.FDocProcessingMsgs.Add('Adding ' + InputDoc.DocName + ' to Disclosures');

  InputDoc.DocType := GetDocType(ExtractFileExt(InputDoc.DocName));
  InputDoc.FDocProcessingMsgs.Add('Adding PDF Document: ' + InputDoc.DocName);

  Result := True;

  if not InsertFromPDF(DisclNum, PDFFilename, InputDoc, Bookmark) then
  begin
    InputDoc.FDocProcessingMsgs.Add('<EXCEPT>: Could not add ' + PDFFilename);
    TLogger.Log(Excpt, 'Could not add PDF File: ' + ExtractFileName(PDFFilename) + ' to Disclosure PDF. Providing it as is.');
    Result := False;
  end;

  if Result = False then
  begin
    Copyfile(PDFFilename, Make_PDF.ManiFullPath + '\' + FN);
    AddSummaryToManifest(DisclNum, atAddToDisclosureFolder, PDFFilename, InputDoc, Make_PDF.ManiFullPath);
    TLogger.Log(TraceOut, 'TPDFMaker.AddAPDFFile (' + PDFFilename + '): Result = False')
  end
  else
  begin
    PDFFilePageCount := PDFFilePageCount + 1;
    AddSummaryToManifest(DisclNum, atAddToDisclosurePDF, PDFFilename, InputDoc, Make_PDF.ManiFullPath);
    TLogger.Log(TraceOut, 'TPDFMaker.AddAPDFFile (' + PDFFilename + '): Result = True')
  end;

end;

function TPDFMaker.InsertFromPDF(DisclNum: Integer; PDFFilename: String; InputDoc: TDocument; Bookmark: String): Boolean;
var
	newLoc: IIGIOLocation;
	newDoc: IGDocument;
  newPDFDoc: IGPDFDoc;
	i: Smallint;
	j: Integer;
	nPageNumToDisplay: Smallint;
  BMPgNum: Integer;
  FirstTimeThrough: Boolean;
begin
	try
    Result := False;

    FirstTimeThrough := True;

		newLoc := GetIGManager.IGFormatsCtrl.CreateObject(IG_FORMATS_OBJ_IOFILE) as IIGIOLocation;
		(newLoc as IGIOFile).FileName := PDFFilename;

		newDoc := GetIGManager.IGCoreCtrl.CreateDocument(0);
		GetIGManager.IGFormatsCtrl.OpenDocument(newDoc, newLoc, IG_ACCESSMODE_READONLY);
    InputDoc.PageCount := newDoc.PageCount;

    newPDFDoc := GetIGManager.IGPDFCtrl.CreatePDFDoc(newDoc);
    GetDocInfo(newPDFDoc, InputDoc);
    GetDocSecurityInfo(newPDFDoc, InputDoc);

    BMPgNum := Accusoft.totalLocationPageCount;
    Accusoft.curPDFDoc.InsertPages(Accusoft.currentPageNumber, newPDFDoc, 0, newDoc.PageCount, IG_PDF_INSERT_BOOKMARKS);
    if newPDFDoc.GetBookmark.Count = 0 then
      NewBookmark(Bookmark, Accusoft.curDoc.Page[BMPgNum])
    else
    begin

      BM := newPDFDoc.GetBookmark;

      repeat
        if BM.HasChildren then
        begin
          if FirstTimeThrough then
          begin
            FirstTimeThrough := False;
            if BM.Title = '' then
              BM.Title := Bookmark;
            BM := BM.GetPrev;
          end
          else
            BM := BM.GetPrev;
        end
        else
          BM := BM.GetNext;

      until BM = nil;

    end;

    Accusoft.currentPageNumber      := Accusoft.curDoc.PageCount-1;
 		Accusoft.totalLocationPageCount := Accusoft.curDoc.PageCount;

		newDoc.Clear();
		newDoc := nil;

    newPDFDoc := nil;
    newLoc := nil;

    Result := True;

	except
    on E:Exception do
    begin
      TLogger.Log(Error, 'TPDFMaker.InsertFromPDF: ' + E.Message);
      Result := False;
    end;
	end;
end;

procedure TPDFMaker.AddSummaryToManifest(DisclNum: Integer; AddType: TAddType; InputFileName: String; InputDoc: TDocument; DestFileName: String);
const
  CRLF = #13#10;
var
  i: Integer;
  S: String;
  strDocType: String;
  strDocAccessedAt: String;
  strAddType: String;
begin

  case AddType of
    atAddToDisclosureFolder: S := '<Added to Disclosure Folder>' + CRLF;
    atAddToDisclosurePDF:    S := '<Added to Disclosure PDF>' + CRLF;
    atError:                 S := '< ERROR >' + CRLF;
    atTesting:               S := '< TESTING >' + CRLF;
  end;

  strDocType := DocTypeToStr(InputDoc.DocType);

  try
    strDocAccessedAt := FormatDateTime('mmm dd, yyyy', InputDoc.DocAccessedAt);
  except
    strDocAccessedAt := 'n/a';
  end;

  S := S +
       'InputFileName:                          ' + ExtractFilename(InputFileName) + CRLF +
       'PageCnt:                                ' + IntToStr(InputDoc.PageCount) + CRLF +
       'DocType:                                ' + strDocType + CRLF +
       'Doc Accessed At:                        ' + strDocAccessedAt + CRLF +
       'Title:                                  ' + InputDoc.Title + CRLF +
       'Author:                                 ' + InputDoc.Author + CRLF;

//  if strDocType = 'PDF' then
//    S := S +
//       'SOURCE PDF PROPERTIES...              ' + CRLF +
//       '  Subject:                              ' + InputDoc.Subject + CRLF +
//       '  Keywords:                             ' + InputDoc.Keywords + CRLF +
//       '  CreatedOn:                            ' + InputDoc.CreatedOn + CRLF +
//       '  ModifiedOn:                           ' + InputDoc.ModifiedOn + CRLF +
//       '  Creator:                              ' + InputDoc.Creator + CRLF +
//       '  Producer:                             ' + InputDoc.Producer + CRLF +
//       'SOURCE PDF SECURITY PROPERTIES...     ' + CRLF +
//       '  Security Method:                      ' + InputDoc.Sec_SecurityMethod + CRLF +
//       '  Can be opened by:                     ' + InputDoc.Sec_Revision + CRLF +
//       '  Document open password:               ' + InputDoc.Sec_DocOpenPW + CRLF +
//       '  Permission password:                  ' + InputDoc.Sec_PermPW + CRLF +
//       '  Printing:                             ' + InputDoc.Sec_Printing + CRLF +
//       '  Changing the document:                ' + InputDoc.Sec_ChangingDoc + CRLF +
//       '  Document assembly:                    ' + InputDoc.Sec_DocAssembly + CRLF +
//       '  Content copying or extraction:        ' + InputDoc.Sec_ContentCopy + CRLF +
//       '  Content extraction for accessibility: ' + InputDoc.Sec_ContentExtract + CRLF +
//       '  Commenting:                           ' + InputDoc.Sec_Commenting + CRLF +
//       '  Filling of form fields:               ' + InputDoc.Sec_FormFilling + CRLF +
//       '  Signing:                              ' + InputDoc.Sec_Signing + CRLF +
//       '  Creation of template pages:           ' + InputDoc.Sec_CreationTemplatePages + CRLF +
//       '  Submitting forms:                     ' + InputDoc.Sec_SubmittingForms + CRLF +
//       '  Encryption level:                     ' + InputDoc.Sec_EncLevel;

		TLogger.Log(Info, CRLF + S + CRLF);
    TLogger.Log(Info, '------------------ End Disclosure #' + IntToStr(DisclNum) + '----------------------' + CRLF);
end;

function TPDFMaker.GetDocType(Ext: String): TDocType;
var
  _Ext: String;
begin
  _Ext := UpperCase(Ext);
  if      _Ext = '.PDF'  then Result := dtPDF
  else if _Ext = '.JPG'  then Result := dtJPG
  else if _Ext = '.JPEG' then Result := dtJPG
  else if _Ext = '.TIF'  then Result := dtTIF
  else if _Ext = '.TIFF' then Result := dtTIF
  else if _Ext = '.BMP'  then Result := dtBMP
  else if _Ext = '.RTF'  then Result := dtRTF
  else if _Ext = '.DOC'  then Result := dtDOC
  else if _Ext = '.DOCX' then Result := dtDOCX
  else if _Ext = '.TGA'  then Result := dtTGA
  else if _Ext = '.WAV'  then Result := dtWAV
  else if _Ext = '.HTM'  then Result := dtHTM
  else if _Ext = '.HTML' then Result := dtHTML
  else if _Ext = '.MOV'  then Result := dtMOV
  else if _Ext = '.MPG'  then Result := dtMPG
  else if _Ext = '.MPEG' then Result := dtMPG
  else if _Ext = '.AVI'  then Result := dtAVI
  else Result := dtOther
end;

function TPDFMaker.DocTypeToStr(dt: TDocType): String;
begin
  case dt of
    dtPDF:   Result := 'PDF';
    dtJPG:   Result := 'JPG';
    dtTIF:   Result := 'TIF';
    dtBMP:   Result := 'BMP';
    dtRTF:   Result := 'RTF';
    dtDOC:   Result := 'DOC';
    dtDOCX:  Result := 'DOCX';
    dtTGA:   Result := 'TGA';
    dtWAV:   Result := 'WAV';
    dtHTM:   Result := 'HTM';
    dtHTML:  Result := 'MTML';
    dtMOV:   Result := 'MOV';
    dtMPG:   Result := 'MPG';
    dtAVI:   Result := 'AVI';
    dtOther: Result := 'OTHER';
  end;
end;

{ TDocumentList }

function TDocumentList.Add(AObject: TDocument): Integer;
begin
  Result := inherited Add(AObject);
  AObject.FDocAccessedAt := Now;
  AObject.FDocProcessingMsgs := TStringList.Create;
end;

function TDocumentList.GetItem(Index: Integer): TDocument;
begin
  Result := TDocument(inherited Items[Index]);
end;

function TDocumentList.IndexOf(AObject: TDocument): Integer;
begin
  Result := inherited IndexOf(AObject);
end;

procedure TDocumentList.Insert(Index: Integer; AObject: TDocument);
begin
  Inherited Insert(Index, AObject);
end;

function TDocumentList.Remove(AObject: TDocument): Integer;
begin
  AObject.FDocProcessingMsgs.Free;
  Result := inherited Remove(AObject);
end;

procedure TDocumentList.SetItem(Index: Integer; AObject: TDocument);
begin
  Inherited Items[Index] := AObject;
end;

procedure TPDFMaker.GetDocInfo(PDFDoc: IGPDFDoc; InputDoc: TDocument);
var
  S: String;
begin
  InputDoc.Title := Trim(PDFDoc.GetInfo('Title'));
  if InputDoc.Title = '' then
    InputDoc.Title := 'This document is not titled';

  InputDoc.Author := Trim(PDFDoc.GetInfo('Author'));
  if InputDoc.Author = '' then
    InputDoc.Author := 'The document author is not given';

  InputDoc.Subject := Trim(PDFDoc.GetInfo('Subject'));
  if InputDoc.Subject = '' then
    InputDoc.Subject := 'The document subject is not given';

  InputDoc.Keywords := Trim(PDFDoc.GetInfo('Keywords'));
  if InputDoc.Keywords = '' then
    InputDoc.Keywords := 'There are no specified document keywords';

  InputDoc.Creator := Trim(PDFDoc.GetInfo('Creator'));
  if InputDoc.Creator = '' then
    InputDoc.Creator := 'Document creator is not specified';

  InputDoc.Producer := Trim(PDFDoc.GetInfo('Producer'));
  if InputDoc.Producer = '' then
    InputDoc.Producer := 'Document producer is not specified';

  InputDoc.CreatedOn := Trim(PDFDoc.GetInfo('CreationDate'));
  if (InputDoc.CreatedOn = '') or (InputDoc.CreatedOn = '//') or (InputDoc.CreatedOn = ' / / ') then
    InputDoc.CreatedOn := 'Document creation date is not known';

  InputDoc.ModifiedOn := Trim(PDFDoc.GetInfo('ModDate'));
  if (InputDoc.ModifiedOn = '') or (InputDoc.ModifiedOn = '//') or (InputDoc.ModifiedOn = ' / / ') then
    InputDoc.ModifiedOn := 'Document modification date is not known';

end;

procedure TPDFMaker.GetDocSecurityInfo(PDFDoc: IGPDFDoc; InputDoc: TDocument);
var
	SecData: IGPDFSecurityData;
  m_bEncryptMetadata, m_bInitDialog: Boolean;
begin
	try

		m_bInitDialog := true;

		SecData := PDFDoc.GetNewSecurityData;

		if SecData = nil then
			m_bEncryptMetadata := UpdateNoSecurity(InputDoc)
    else
    begin
			if (SecData.Revision) = IG_PDF_REVISION_2 then
      begin
				UpdateAcrobat3(SecData, InputDoc);
			end

			else if (SecData.Revision) = IG_PDF_REVISION_3 then
      begin
				UpdateAcrobat5(SecData, InputDoc);
			end

			else if (SecData.Revision) = IG_PDF_REVISION_4 then
      begin
				UpdateAcrobat6(SecData, InputDoc);
			end;
		end;

		m_bInitDialog := false;

	except
    InputDoc.FDocProcessingMsgs.Add(GetIGManager.checkErrors);
	end;
end;

function TPDFMaker.UpdateNoSecurity(InputDoc: TDocument): Boolean;
begin
  InputDoc.Sec_SecurityMethod        := 'None';
  InputDoc.Sec_Revision              := 'All versions of Acrobat';
  InputDoc.Sec_DocOpenPW             := 'No';
  InputDoc.Sec_PermPW                := 'No';
  InputDoc.Sec_Printing              := 'Allowed';
  InputDoc.Sec_ChangingDoc           := 'Allowed';
  InputDoc.Sec_DocAssembly           := 'Allowed';
  InputDoc.Sec_ContentCopy           := 'Allowed';
  InputDoc.Sec_ContentExtract        := 'Allowed';
  InputDoc.Sec_Commenting            := 'Allowed';
  InputDoc.Sec_FormFilling           := 'Allowed';
  InputDoc.Sec_Signing               := 'Allowed';
  InputDoc.Sec_CreationTemplatePages := 'Allowed';
  InputDoc.Sec_SubmittingForms       := 'Allowed';
  InputDoc.Sec_EncLevel              := 'No Encryption';

  Result := False;
end;

function TPDFMaker.UpdateAcrobat3(SecData: IGPDFSecurityData; InputDoc: TDocument): Boolean;
begin
	try

		InputDoc.Sec_SecurityMethod := 'Password';

		// Revision.
		InputDoc.Sec_Revision := 'Acrobat 3.0 and later';

		// Passwords.
		InputDoc.Sec_DocOpenPW := IIf(SecData.HasUserPW, 'Yes', 'No');
		InputDoc.Sec_PermPW := IIf(SecData.HasOwnerPW, 'Yes', 'No');

		// Printing.
		if (SecData.Perms and IG_PDF_PERM_PRINT)>0 then begin
			InputDoc.Sec_Printing := 'High Resolution';
		end else begin
			InputDoc.Sec_Printing := 'Not Allowed';
		end;

		// Changing the Document.
		if (SecData.Perms and IG_PDF_PERM_EDIT)>0 then begin
			InputDoc.Sec_ChangingDoc := 'Allowed';
		end else begin
			InputDoc.Sec_ChangingDoc := 'Not Allowed';
		end;

		// Document Assembly.
		if (SecData.Perms and IG_PDF_PERM_EDIT)>0 then begin
			InputDoc.Sec_DocAssembly := 'Allowed';
		end else begin
			InputDoc.Sec_DocAssembly := 'Not Allowed';
		end;

		// Content Copying or Extraction.
		if (SecData.Perms and IG_PDF_PERM_COPY)>0 then begin
			InputDoc.Sec_ContentCopy := 'Allowed';
		end else begin
			InputDoc.Sec_ContentCopy := 'Not Allowed';
		end;

		// Content Extraction for Accessibility.
		if (SecData.Perms and IG_PDF_PERM_COPY)>0 then begin
			InputDoc.Sec_ContentExtract := 'Allowed';
		end else begin
			InputDoc.Sec_ContentExtract := 'Not Allowed';
		end;

		// Commenting.
		if (SecData.Perms and IG_PDF_PERM_EDIT_NOTES)>0 then begin
			InputDoc.Sec_Commenting := 'Allowed';
		end else begin
			InputDoc.Sec_Commenting := 'Not Allowed';
		end;

		// Filling of Form Fields.
		if (((SecData.Perms and IG_PDF_PERM_EDIT)>0) or ((SecData.Perms and IG_PDF_PERM_EDIT_NOTES)>0)) then begin
			InputDoc.Sec_FormFilling := 'Allowed';
		end else begin
			InputDoc.Sec_FormFilling := 'Not Allowed';
		end;

		// Signing.
		if (((SecData.Perms and IG_PDF_PERM_EDIT)>0) or ((SecData.Perms and IG_PDF_PERM_EDIT_NOTES)>0)) then begin
			InputDoc.Sec_Signing := 'Allowed';
		end else begin
			InputDoc.Sec_Signing := 'Not Allowed';
		end;

		// Creation of Template Pages.
		if (SecData.Perms and IG_PDF_PERM_EDIT)>0 then begin
			InputDoc.Sec_CreationTemplatePages := 'Allowed';
		end else begin
			InputDoc.Sec_CreationTemplatePages := 'Not Allowed';
		end;

		// Submitting Forms.
		if (SecData.Perms and IG_PDF_PERM_EDIT)>0 then begin
			InputDoc.Sec_SubmittingForms := 'Allowed';
		end else begin
			InputDoc.Sec_SubmittingForms := 'Not Allowed';
		end;

		// Encription Level.
		if (SecData.EncryptMethod)=IG_PDF_STD_SECURITY_METHOD_RC4_V2 then begin

			InputDoc.Sec_EncLevel := mStr(8*SecData.KeyLength)+'-bit RC4';
		end
		else if (SecData.EncryptMethod)=IG_PDF_STD_SECURITY_METHOD_AES_V1 then begin
			InputDoc.Sec_EncLevel := mStr(8*SecData.KeyLength)+'-bit AES with zero initialized iv';
		end
		else if (SecData.EncryptMethod)=IG_PDF_STD_SECURITY_METHOD_AES_V2 then begin
			InputDoc.Sec_EncLevel := mStr(8*SecData.KeyLength)+'-bit AES with random initialized iv';
		end
		else begin
			InputDoc.Sec_EncLevel := mStr(8*SecData.KeyLength)+'-bit RC4';
		end;

		Result := true;
	except
    InputDoc.FDocProcessingMsgs.Add(GetIGManager.checkErrors);
	end;
end;

function TPDFMaker.UpdateAcrobat5(SecData: IGPDFSecurityData; InputDoc: TDocument): Boolean;
begin
	try

		// Secirity Method.
		InputDoc.Sec_SecurityMethod := 'Password';

		// Revision.
		InputDoc.Sec_Revision := 'Acrobat 5.0 and later';

		// Passwords.
		InputDoc.Sec_DocOpenPW := IIf(SecData.HasUserPW, 'Yes', 'No');
		InputDoc.Sec_PermPW := IIf(SecData.HasOwnerPW, 'Yes', 'No');

		// Printing.
		if (SecData.Perms and IG_PDF_PERM_PRINT)>0 then begin
      if IG_PDF_PRIV_PERM_HIGH_PRINT in [SecData.Perms] then
        InputDoc.Sec_Printing := 'High Resolution'
      else
        InputDoc.Sec_Printing := 'Low Resolution (150 dpi)';

//			Sec_Printing := IIf((SecData.Perms and IG_PDF_PRIV_PERM_HIGH_PRINT), 'High Resolution', 'Low Resolution (150 dpi)');

		end else begin
			InputDoc.Sec_Printing := 'Not Allowed';
		end;

		// Changing the Document.
		if (SecData.Perms and IG_PDF_PERM_EDIT)>0 then begin
			InputDoc.Sec_ChangingDoc := 'Allowed';
		end else begin
			InputDoc.Sec_ChangingDoc := 'Not Allowed';
		end;

		// Document Assembly.
		if (((SecData.Perms and IG_PDF_PERM_EDIT)>0) or ((SecData.Perms and IG_PDF_PRIV_PERM_DOC_ASSEMBLY)>0)) then begin
			InputDoc.Sec_DocAssembly := 'Allowed';
		end else begin
			InputDoc.Sec_DocAssembly := 'Not Allowed';
		end;

		// Content Copying or Extraction.
		if (SecData.Perms and IG_PDF_PERM_COPY)>0 then begin
			InputDoc.Sec_ContentCopy := 'Allowed';
		end else begin
			InputDoc.Sec_ContentCopy := 'Not Allowed';
		end;

		// Content Extraction for Accessibility.
		if (SecData.Perms and IG_PDF_PRIV_PERM_ACCESSIBLE)>0 then begin
			InputDoc.Sec_ContentExtract := 'Allowed';
		end else begin
			InputDoc.Sec_ContentExtract := 'Not Allowed';
		end;

		// Commenting.
		if (SecData.Perms and IG_PDF_PERM_EDIT_NOTES)>0 then begin
			InputDoc.Sec_Commenting := 'Allowed';
		end else begin
			InputDoc.Sec_Commenting := 'Not Allowed';
		end;

		// Filling of Form Fields.
		if (SecData.Perms and IG_PDF_PRIV_PERM_FILL_AND_SIGN)>0 then begin
			InputDoc.Sec_FormFilling := 'Allowed';
		end else begin
			InputDoc.Sec_FormFilling := 'Not Allowed';
		end;

		// Signing.
		if (SecData.Perms and IG_PDF_PRIV_PERM_FILL_AND_SIGN)>0 then begin
			InputDoc.Sec_Signing := 'Allowed';
		end else begin
			InputDoc.Sec_Signing := 'Not Allowed';
		end;

		// Creation of Template Pages.
		if (((SecData.Perms and IG_PDF_PRIV_PERM_FILL_AND_SIGN)>0) and ((SecData.Perms and IG_PDF_PRIV_PERM_FORM_SPAWN_TEMPL)>0)) then begin
			InputDoc.Sec_CreationTemplatePages := 'Allowed';
		end else begin
			InputDoc.Sec_CreationTemplatePages := 'Not Allowed';
		end;

		// Submitting Forms.
		if (((SecData.Perms and IG_PDF_PRIV_PERM_FILL_AND_SIGN)>0) and ((SecData.Perms and IG_PDF_PRIV_PERM_FORM_SUBMIT)>0)) then begin
			InputDoc.Sec_SubmittingForms := 'Allowed';
		end else begin
			InputDoc.Sec_SubmittingForms := 'Not Allowed';
		end;

		// Encription Level.
		if (SecData.EncryptMethod)=IG_PDF_STD_SECURITY_METHOD_RC4_V2 then begin

			InputDoc.Sec_EncLevel := mStr(8*SecData.KeyLength)+'-bit RC4';
		end
		else if (SecData.EncryptMethod)=IG_PDF_STD_SECURITY_METHOD_AES_V1 then begin
			InputDoc.Sec_EncLevel := mStr(8*SecData.KeyLength)+'-bit AES with zero initialized iv';
		end
		else if (SecData.EncryptMethod)=IG_PDF_STD_SECURITY_METHOD_AES_V2 then begin
			InputDoc.Sec_EncLevel := mStr(8*SecData.KeyLength)+'-bit AES with random initialized iv';
		end
		else begin
			InputDoc.Sec_EncLevel := mStr(8*SecData.KeyLength)+'-bit RC4';
		end;

		Result := true;

	except
		InputDoc.FDocProcessingMsgs.Add(GetIGManager.checkErrors);
	end;
end;

function TPDFMaker.UpdateAcrobat6(SecData: IGPDFSecurityData; InputDoc: TDocument): Boolean;
begin
	try
		{Security Method}
		InputDoc.Sec_SecurityMethod := 'Password';

		{Revision}
		if SecData.EncryptMethod=IG_PDF_STD_SECURITY_METHOD_RC4_V2 then begin
			InputDoc.Sec_Revision := 'Acrobat 6.0 and later';
		end else begin
			InputDoc.Sec_Revision := 'Acrobat 7.0 and later';
		end;

		{Passwords}
		InputDoc.Sec_DocOpenPW := IIf(SecData.HasUserPW, 'Yes', 'No');
		InputDoc.Sec_PermPW := IIf(SecData.HasOwnerPW, 'Yes', 'No');

		{Printing}
		if (SecData.Perms and IG_PDF_PERM_PRINT)>0 then begin
      if SecData.Perms = IG_PDF_PRIV_PERM_HIGH_PRINT then
        InputDoc.Sec_Printing := 'High Resolution'
      else
      begin
        if IG_PDF_PRIV_PERM_HIGH_PRINT in [SecData.Perms] then
          InputDoc.Sec_Printing := 'High Resolution'
        else
          InputDoc.Sec_Printing := 'Low Resolution (150 dpi)';
      end;

//  			InputDoc.Sec_Printing := IIf(SecData.Perms and IG_PDF_PRIV_PERM_HIGH_PRINT, 'High Resolution', 'Low Resolution (150 dpi)');

		end else begin
			InputDoc.Sec_Printing := 'Not Allowed';
		end;

		{Changing the Document}
		if (SecData.Perms and IG_PDF_PERM_EDIT)>0 then begin
			InputDoc.Sec_ChangingDoc := 'Allowed';
		end else begin
			InputDoc.Sec_ChangingDoc := 'Not Allowed';
		end;

		{Document Assembly}
		if (((SecData.Perms and IG_PDF_PERM_EDIT)>0) or ((SecData.Perms and IG_PDF_PRIV_PERM_DOC_ASSEMBLY)>0)) then begin
			InputDoc.Sec_DocAssembly := 'Allowed';
		end else begin
			InputDoc.Sec_DocAssembly := 'Not Allowed';
		end;

		{Content Copying or Extraction}
		if (SecData.Perms and IG_PDF_PERM_COPY)>0 then begin
			InputDoc.Sec_ContentCopy := 'Allowed';
		end else begin
			InputDoc.Sec_ContentCopy := 'Not Allowed';
		end;

		{Content Extraction for Accessibility}
		if (SecData.Perms and IG_PDF_PRIV_PERM_ACCESSIBLE)>0 then begin
			InputDoc.Sec_ContentExtract := 'Allowed';
		end else begin
			InputDoc.Sec_ContentExtract := 'Not Allowed';
		end;

		{Commenting}
		if (SecData.Perms and IG_PDF_PERM_EDIT_NOTES)>0 then begin
			InputDoc.Sec_Commenting := 'Allowed';
		end else begin
			InputDoc.Sec_Commenting := 'Not Allowed';
		end;

		{Filling of Form Fields}
		if (SecData.Perms and IG_PDF_PRIV_PERM_FILL_AND_SIGN)>0 then begin
			InputDoc.Sec_FormFilling := 'Allowed';
		end else begin
			InputDoc.Sec_FormFilling := 'Not Allowed';
		end;

		{Signing}
		if (SecData.Perms and IG_PDF_PRIV_PERM_FILL_AND_SIGN)>0 then begin
			InputDoc.Sec_Signing := 'Allowed';
		end else begin
			InputDoc.Sec_Signing := 'Not Allowed';
		end;

		{Creation of Template Pages}
		if (((SecData.Perms and IG_PDF_PRIV_PERM_FILL_AND_SIGN)>0) and ((SecData.Perms and IG_PDF_PRIV_PERM_FORM_SPAWN_TEMPL)>0)) then begin
			InputDoc.Sec_CreationTemplatePages := 'Allowed';
		end else begin
			InputDoc.Sec_CreationTemplatePages := 'Not Allowed';
		end;

		{Submitting Forms}
		if (((SecData.Perms and IG_PDF_PRIV_PERM_FILL_AND_SIGN)>0) and ((SecData.Perms and IG_PDF_PRIV_PERM_FORM_SUBMIT)>0)) then begin
			InputDoc.Sec_SubmittingForms := 'Allowed';
		end else begin
			InputDoc.Sec_SubmittingForms := 'Not Allowed';
		end;

		{Encryption Level}
		if (SecData.EncryptMethod)=IG_PDF_STD_SECURITY_METHOD_RC4_V2 then begin

			InputDoc.Sec_EncLevel := mStr(8*SecData.KeyLength)+'-bit RC4';
		end
		else if (SecData.EncryptMethod)=IG_PDF_STD_SECURITY_METHOD_AES_V1 then begin
			InputDoc.Sec_EncLevel := mStr(8*SecData.KeyLength)+'-bit AES with zero initialized iv';
		end
		else if (SecData.EncryptMethod)=IG_PDF_STD_SECURITY_METHOD_AES_V2 then begin
			InputDoc.Sec_EncLevel := mStr(8*SecData.KeyLength)+'-bit AES with random initialized iv';
		end
		else begin
			InputDoc.Sec_EncLevel := mStr(8*SecData.KeyLength)+'-bit RC4';
		end;

		Result := SecData.EncryptMetadata;

	except
		InputDoc.FDocProcessingMsgs.Add(GetIGManager.checkErrors);
	end;
end;

{ TMakeAnnotatedFile }

procedure TMakeAnnotatedFile.SetCurrentPageDisp(const Value: IIGPageDisplay);
begin
  if FCurrentPageDisp <> Value then
    FCurrentPageDisp := Value;
  if FCurrentPageDisp <> nil then
    FIGArtDrawParams.IGPageDisplay := FCurrentPageDisp;
end;

procedure TMakeAnnotatedFile.StartAnnotationSession(var RetCode: String);
var
  sRetCode: String;
begin
  try
    TLogger.Log(TraceIn, 'TMakeAnnotatedFile.StartAnnotationSession');

    sRetCode := Make_AnnotatedFile.ValidateInput;
    if sRetCode <> '' then
    begin
      RetCode := sRetCode;
      Exit;
    end;

    TLogger.Log(Info, 'Delphi DLL Version = ' + GetDLLVersion);

    Make_AnnotatedFile.Accusoft := TAccusoft.Create;

    RetCode := Make_AnnotatedFile.Accusoft.InitializeIG;

    if RetCode <> '0' then
    begin
      RetCode := 'TMakeAnnotatedFile.StartAnnotationSession: InitializeIG Error ReturnCode = ' + RetCode;
      Exit;
    end;

    Make_AnnotatedFile.BurnImage(RetCode);

    if AnsiContainsStr(Uppercase(RetCode), 'ERROR') then
    begin
      TLogger.Log(Error, 'TMakeAnnotatedFile.StartAnnotationSession: Error = ' + RetCode);
      RetCode := 'TMakeAnnotatedFile.StartAnnotationSession: Error = ' + RetCode;
      Exit;
    end;

    TLogger.Log(TraceOut, 'TMakeAnnotatedFile.StartAnnotationSession');

  except
    on E:Exception do
    begin
     TLogger.Log(Debug, 'TMakeAnnotatedFile.StartAnnotationSession: Exception = ' + E.Message);
    end;
  end;
end;

function TMakeAnnotatedFile.ValidateInput: String;
begin
  Result := '';
  try
    if Trim(Make_AnnotatedFile.JobID) = '' then
    begin
      TLogger.Log(Error, 'Make_AnnotatedFile.ValidateInput: Result = -51');
      Result := 'DELPHI_ERROR-51';  {-51 = ValidateInput: JobID is blank}
      Exit;
    end;

    if Trim(Make_AnnotatedFile.ImageFileFullPath) = '' then
    begin
      TLogger.Log(Error, 'TMakeAnnotatedFile.ValidateInput: Result = -52');
      Result := 'DELPHI_ERROR-52';  {-52 = ValidateInput: Patient Name is blank}
      Exit;
    end;

    if Trim(Make_AnnotatedFile.XMLFileFullPath) = '' then
    begin
      TLogger.Log(Error, 'TMakeAnnotatedFile.ValidateInput: Result = -53');
      Result := 'DELPHI_ERROR-53';  {-53 = ValidateInput: PatSSN is blank}
      Exit;
    end;

    if Trim(Make_AnnotatedFile.OutputBurnedImageFullPath) = '' then
    begin
      TLogger.Log(Error, 'TMakeAnnotatedFile.ValidateInput: Result = -54');
      Result := 'DELPHI_ERROR-54';  {-54 = ValidateInput: PatDOB is blank}
      Exit;
    end;
  except
    on E:Exception do
    begin
      Result := 'DELPHI_ERROR-55 Validate Input [' + E.Message + ']';  {-55 = ValidateInput: exception raised}
      TLogger.Log(Error, 'TMakeAnnotatedFile.ValidateInput: Result = DELPHI_ERROR-55');
    end;
  end;

end;

procedure TMakeAnnotatedFile.Initialize(CurDoc: IIGDocument; CurPoint: IIGPoint; CurPageDisp: IIGPageDisplay; PageViewHwnd: Integer; ForDiagramAnnotation: Boolean);
var
  ind : integer;
  PgNum: Integer;
begin
  TLogger.Log(TraceIn, 'TMakeAnnotatedFile.Initialize');
  try
    // the current document, either singlepage or multipage image
    FCurrentDocument := CurDoc;
    PageCount := FCurrentDocument.PageCount;    // total pages for the image
    Page := 0;                                  // starting page
    CurrentPageNumber := 0;

    IgCurPoint := CurPoint;
    if ArtPage <> nil then
      ArtPage := nil;
    Self.PageViewHwnd := PageViewHwnd;

    CurrentPageDisp := CurPageDisp;
    CurrentPageDisp.OffScreenDrawing := True;

    CurrentPage := FCurrentDocument.Page[Page]; // current page is first page in the image

    // Generate a record of artpages for every page available in the image
    SetLength(FArtPages, PageCount);
    for ind := 0 to PageCount - 1 do
    begin
      FArtPages[ind] := IGArtXCtl.CreatePage;
  //    FArtPages[ind].SetAttr(IG_ARTX_ATTR_PAGE_DISABLE_PPM_FOR_FONTS,1);
    end;

    CreateArtPage(CurrentPage,CurrentPageDisp); // create active art page

    // Assign the active artpage to the first artpage in the array
    ArtPage := FArtPages[Page];
    ArtPage.AssociatePageDisplay(CurrentPageDisp);
    GetIGManager.IGArtXGUICtrl.ArtXPage := ArtPage;
  finally
    TLogger.Log(TraceOut, 'TMakeAnnotatedFile.Initialize');
  end;
end;

procedure TMakeAnnotatedFile.LoadAllArtPages;
{ Load all the artpages with annotation from a history file }
var
  i : Integer;
  APTemp : IIGArtXPage;
  fName : string;
begin
  ArtPage.RemoveMarks;

  for i := 0 to PageCount - 1 do
  begin
    APTemp := FArtPages[i];
    APTemp.RemoveMarks;
    APTemp.LoadFile(fName, 1, False);
    FArtPages[i] := APTemp;
  end;
end;

function TMakeAnnotatedFile.CreateArtPage: IIGArtXPage;
begin
  FArtPage := GetIGManager.IGArtXCtrl.CreatePage;
  GetIGManager.IGArtXGUICtrl.ArtXPage := FArtPage;
  Result := FArtPage;
end;

function TMakeAnnotatedFile.CreateArtPage(CurrentPage_: IIGPage; CurrentPageDisp_: IIGPageDisplay): IIGArtXPage;
begin
  TLogger.Log(TraceIn, 'TMakeAnnotatedFile.CreateArtPage');

  Result := nil;
  CurrentPage := CurrentPage_;
  CurrentPageDisp := CurrentPageDisp_;

  if (CurrentPage <> nil) and CurrentPage.IsValid then
  begin
    Result := CreateArtPage;
    FArtPage.Load(CurrentPage, False);
    FArtPage.UndoEnabled := True;
    if CurrentPageDisp <> nil then
    begin
      CurrentPageDisp.AntiAliasing.Method := IG_DSPL_ANTIALIAS_NONE;
      FArtPage.AssociatePageDisplay(CurrentPageDisp);
    end;
    Result := FArtPage;
  end;
  TLogger.Log(TraceOut, 'TMakeAnnotatedFile.CreateArtPage');
end;

function TMakeAnnotatedFile.GetCurrentPage: IIGPage;
begin
  Result := FCurrentPage;
end;

procedure TMakeAnnotatedFile.SetCurrentPage(const Value: IIGPage);
begin
  FCurrentPage := Value;
end;

function TMakeAnnotatedFile.GetIGArtXCtl: TIGArtXCtl;
begin
  Result := GetIGManager.IGArtXCtrl;
end;

function TMakeAnnotatedFile.ValidateXML(const xmlFile : TFileName): Boolean;
var
  xmlDoc: TXMLDocument;
begin
  result := False;
  xmlDoc := TXMLDocument.Create(nil);
  try
    xmlDoc.ParseOptions := [poResolveExternals, poValidateOnParse];
    try
      xmlDoc.LoadFromFile(xmlFile) ;
      xmlDoc.Active := true; //this will validate
      result := true;
   except
    on E:EDOMParseError do
    begin
      TLogger.Log(Error, 'ValidateXML ERROR: Invalid XML for: ' + xmlFile + ' Error: ' + E.Message);
    end;
  end;
  finally
    xmlDoc.Free;
  end;
end;

function TMakeAnnotatedFile.CreateNewDocument(FN: string): Boolean;
var
  tempPage: IIGPage;
  currentPageNew: IIGPage;
  curParameterX: IGControlParameter;
  curParameterY: IGControlParameter;
  tmp: IGFormatParams;
  curFormatParams: IGFormatParams;
  PDFRevision: Cardinal;
  DocAssemblyAllowed: Boolean;
	SecData: IGPDFSecurityData;
  i,j: Integer;
begin
  Result := False;
  try
    {/P122 DMMN Create artpages for Source=Import, type=DCM or PDF /}
    ioLocation := nil;

    totalLocationPageCount := 0;

    Accusoft.IOInputLocation := nil;
    Accusoft.IOInputLocation := GetIGManager.IGFormatsCtrl.CreateObject(IG_FORMATS_OBJ_IOFILE) As IIGIOLocation;
    (Accusoft.IOInputLocation As IGIOFile).FileName := FN;

    totalLocationPageCount := GetIGManager.IGFormatsCtrl.GetPageCount(Accusoft.IOInputLocation, IG_FORMAT_UNKNOWN);
    currentDocument := GetIGManager.IGCoreCtrl.CreateDocument(0);

    //p122 dmmn 8/11 - fix for hanging while opening pdf
    curFormat := GetIGManager.IGFormatsCtrl.DetectImageFormat(Accusoft.IOInputLocation);
    GetIGManager.IGFormatsCtrl.OpenDocument(currentDocument, Accusoft.IOInputLocation, IG_ACCESSMODE_READWRITE);


    {Prepare to rasterize the pages of the PDF document. Set the raster resolution}
    if (curFormat = IG_FORMAT_PDF) or (curFormat = IG_FORMAT_POSTSCRIPT) then
      for j := 0 to GetIGManager.IGFormatsCtrl.Settings.FormatCount - 1 do
      begin
        tmp := GetIGManager.IGFormatsCtrl.Settings.Format[j];

        if tmp.ID = IG_FORMAT_PDF then
        begin
          curParameterX := tmp.GetParamCopy('RESOLUTION_X');
          curParameterY := tmp.GetParamCopy('RESOLUTION_Y');
          curParameterX.Value.Long := 72; {Set to 72. Otherwise, the annotations will not overlay proportionally}
          curParameterY.Value.Long := 72; {Set to 72. Otherwise, the annotations will not overlay proportionally}
          GetIGManager.IGFormatsCtrl.Settings.Format[j].UpdateParamFrom(curParameterX);
          GetIGManager.IGFormatsCtrl.Settings.Format[j].UpdateParamFrom(curParameterY);
          Break;
        end;
      end;

    if (curFormat = IG_FORMAT_PDF) or (curFormat = IG_FORMAT_POSTSCRIPT) then
    begin
      //
    end
    else
    begin
      GetIGManager.IGFormatsCtrl.ReadPagesToDocument(currentDocument, 0, totalLocationPageCount);
      TLogger.Log(Debug, 'TMakeAnnotatedFile.CreateNewDocument: curFormat is reg. ' + IntToStr(totalLocationPageCount) + ' pages read to into doc');
    end;

    CurrentPage := currentDocument.Page[0];

    TLogger.Log(Debug, 'TMakeAnnotatedFile.CreateNewDocument: Page Count = ' + Inttostr(totallocationpagecount));

    currentPageDisp := GetIGManager.IGDisplayCtrl.CreatePageDisplay(CurrentPage);

    if CurrentPageDisp = nil then
      CurrentPageNumber := 0;

    Result := True;
  except
    on E:Exception do
    begin
      TLogger.Log(Error, 'TMakeAnnotatedFile.CreateNewDocument [' + FN + '] Exception = ' + E.Message);
      Result := False;
    end;
  end;
end;

function TMakeAnnotatedFile.AddAPage(PageNum: Integer; newPage: IGPage; curDoc: IGDocument; curPDFDoc: IGPdfDoc): Boolean;
var
	MediaBox: IGPDFFixedRect;
	newPDFPage: IGPDFPage;
	pdeContent: IGPDEContent;
	pdeImage: IGPDEImage;
	xy: IGPDFFixedPoint;

  PageCnt: Integer;
  i: Integer;

  PgWidth, PgHeight: Integer;
  tstPage: IGPage;

  CurPage: IGPage;

begin
	try
    TLogger.Log(TraceIn, 'TMakeAnnotatedFile.AddAPage: PageNum = ' + IntToStr(PageNum));
    Result := False;

//    GetIGManager.IGFormatsCtrl.LoadPageFromFile(rasterPage, (Accusoft.IOInputLocation as IIGIOFile).FileName, PageNum);

//    if GetIGManager.IGCoreCtrl.Result.RecordsTotal <> 0 then
//      TLogger.Log(Error, 'TMakeAnnotatedFile.AddAPage: I should be showing the error stack now - JK');

    PgWidth := newPage.GetDIBInfo.Width;
    PgHeight := newPage.GetDIBInfo.Height;
//--    tstPage := GetIGManager.IGCoreCtrl.CreatePage;
//--    PgWidth := 400;
//--    PgHeight := 600;

		{Create a blank page}
		MediaBox := GetIGManager.IGPDFCtrl.CreateObject(IG_PDF_FIXEDRECT) as IIGPDFFixedRect;
		MediaBox.Left := 0;
		MediaBox.Bottom := 0;
		MediaBox.Right := GetIGManager.IGPDFCtrl.LongToFixed(PgWidth);
		MediaBox.Top := GetIGManager.IGPDFCtrl.LongToFixed(PgHeight);

//    curPDFDoc.Document.Clear;
    newPage.DuplicateTo(curPDFDoc.Document.Page[1]);
		{Create a new page right after the last page}
		curPDFDoc.CreateNewPage(curDoc.PageCount-1, MediaBox);

		{Set the current page to the last one}
		CurrentPageNumber := curDoc.PageCount-1;

		{Set the total page count}
		TotalLocationPageCount := curDoc.PageCount;

//--		CurPage := curDoc.Page[CurrentPageNumber];
    CurPage := newPage;
//--		tstPage := curDoc.Page[CurrentPageNumber];

		{Create an empty PDF page}
		newPDFPage := GetIGManager.IGPDFCtrl.CreatePDFPage(curPage);
//--		newPDFPage := GetIGManager.IGPDFCtrl.CreatePDFPage(tstPage);

		{Get the PDF page content}
		pdeContent := newPDFPage.GetContent;

    {Create the PDF page image from the image raster}
    xy := GetIGManager.IGPDFCtrl.CreateObject(IG_PDF_FIXEDPOINT) as IIGPDFFixedPoint;
    xy.H := 0;
    xy.V := 0;
    pdeImage := CreateImage(xy, True, newPage);
//--    pdeImage := CreateImage(xy, True, tstPage);

    {Add the PDF image to the content}
    pdeContent.AddElement(IG_PDE_AFTER_LAST, pdeImage);

    {Set the PDF page content}
    newPDFPage.SetContent();

    newPDFPage.ReleaseContent();

    Result := True;
    TLogger.Log(TraceOut, 'TMakeAnnotatedFile.AddAPage');
	except
    on E:Exception do
    begin
  		TLogger.Log(Error, 'TMakeAnnotatedFile.AddAPage(' + IntToStr(PageNum) + '): ' + GetIGManager.checkErrors + ', Exception = ' + E.Message);
    end;
	end;
end;


procedure TMakeAnnotatedFile.AddHeader(PageRes: TPictureResolution; curPageDisp: IIGPageDisplay; var curPage: IGPage; TopOffset: Integer);
var
  myRect: IGRectangle;
  newPage: IGPage;
  curTmpPageDisp: IGPageDisplay;
  TmpIGPageViewCtl: TIGPageViewCtl;
  HeaderHeight: Integer;
begin
  TmpIGPageViewCtl := TIGPageViewCtl.Create(nil);

  newPage := GetIGManager.IGCoreCtrl.CreatePage;
  curPage.DuplicateTo(newPage);

  case PageRes of
    psLowRes:   HeaderHeight := curPage.ImageHeight + TopOffset;
    psMedRes:   HeaderHeight := curPage.ImageHeight + Round(1.3 * TopOffset);
    psLargeRes: HeaderHeight := curPage.ImageHeight + Round(1.8 * TopOffset);
  end;

  GetIGManager.IGProcessingCtrl.ResizeCanvas(newPage, curPage.ImageWidth, HeaderHeight, 0, TopOffset+1, IG_RESIZE_ACTUAL);

	TmpIGPageViewCtl.PageDisplay := GetIGManager.IGDisplayCtrl.CreatePageDisplay(newPage);

  myRect := GetIGManager.IGCoreCtrl.CreateObject(IG_OBJ_RECTANGLE) as IGRectangle;

  myRect.Top    := 0;
  myRect.Left   := 0;
  myRect.Right  := curPage.ImageWidth;
  myRect.Bottom := curPage.ImageHeight;

  TmpIGPageViewCtl.PageDisplay.CutToClipboard(myRect);

  TmpIGPageViewCtl.PageDisplay.PasteMergeFromClipboard(0, TopOffset+1, IG_ARITH_OVER);

  GetIGManager.IGProcessingCtrl.ResizeCanvas(curPage, newPage.ImageWidth, newPage.ImageHeight, 0, 0, IG_RESIZE_ACTUAL);

  TmpIGPageViewCtl.PageDisplay.CutToClipboard(myRect);

  myRect.Top    := 0;
  myRect.Left   := 0;
  myRect.Right  := TmpIGPageViewCtl.PageDisplay.Page.ImageWidth;
  myRect.Bottom := TmpIGPageViewCtl.PageDisplay.Page.ImageHeight + TopOffset;

//  curPageDisp.CutToClipboard(myRect);

//  curPageDisp.PasteMergeFromClipboard(0, TopOffset+1, IG_ARITH_OVER);

//  curPageDisp.Page.DuplicateTo(curPage);


  myRect := nil;
  TmpIGPageViewCtl.Free;
  curTmpPageDisp := nil;
end;

procedure TMakeAnnotatedFile.BurnImage(var RetCode: String);
var
  ImageFilename: String;
  XMLFilename: String;
  SaveFilename: String;
  i: Integer;
  FileExt: String;
  SaveFormat: Cardinal;
  PN: String;
  XmlString : TStringList;
  XMLPath: String;
  ValidateXMLFilename: String;
  tmpXML: TStringlist;
  SaveFlag: Boolean;
  SaveFilenamePart, SaveFilenameExtPart, SaveFileFolderPart: String;
  TitleLineXML: String;
  ObjectNumber: String;
  TotAnnots, HiddenAnnots: Integer;
  StampFilename: String;

  newPage: IIGPage;
  newPageDIB: IGDIBInfo;
  newPageAreaSize: Integer;
  newPageRes: TPictureResolution;

  tmpPage: IGPage;
  err: String;

  tmpPDFDoc: IGPDFDoc;
  tmpDocument: IGDocument;
begin
  TLogger.Log(TraceIn, 'TMakeAnnotatedFile.BurnImage');

  try
    RetCode := 'ERROR';

    XMLPath := ExtractFileDir(Make_AnnotatedFile.ImageFileFullPath);
    TLogger.Log(Debug, 'XML path = ' + xmlpath);
    XMLCtl := TXMLCtl.Create(XMLPath);

    {Open the page}

    ImageFileName       := Make_AnnotatedFile.ImageFileFullPath;
    XMLFileName         := Make_AnnotatedFile.XMLFileFullPath;
    ValidateXMLFilename := XMLPath + '\BurnTmp.xml';

    if AnsiContainsStr(ExtractFilename(ImageFileName), '.') then
      SaveFilenamePart := MagPiece(ExtractFilename(ImageFileName), '.', 1)
    else
      SaveFilenamePart := ExtractFilename(ImageFileName);

    SaveFilenameExtPart := ExtractFileExt(ImageFileName);
    SaveFileFolderPart  := ExtractFileDir(ImageFileName);
    SaveFilename        := SaveFileFolderPart + '\' + SaveFilenamePart + '_Annotated' + SaveFilenameExtPart;

    if FileExists(SaveFilename) then
      if not DeleteFile(SaveFilename) then
      begin
        TLogger.Log(Debug, 'TMakeAnnotatedFile.BurnImage: ERROR - ' + SaveFilename + ' exists prior to this job. Cannot delete it');
        Exit;
      end;

    IGArtDrawParams := GetIGManager.IGArtXCtrl.CreateObject(IG_ARTX_OBJ_DRAWPARAMS) As IIGArtXDrawParams;

    if CreateNewDocument(ImageFileName) = False then
    begin
      TLogger.Log(Info, 'TMakeAnnotatedFile.BurnImage: Cannot burn annotations into this document.');
      RetCode := 'ERROR: Cannot burn annotations into this document';
      Exit;
    end;

    case curFormat of
      IG_FORMAT_PDF:        SaveFormat := IG_SAVE_PDF_UNCOMP;
      IG_FORMAT_POSTSCRIPT: SaveFormat := IG_SAVE_PDF_UNCOMP;
      IG_FORMAT_TIF:        SaveFormat := IG_SAVE_TIF_PACKED;
      IG_FORMAT_JPG:        SaveFormat := IG_SAVE_JPG;
      IG_FORMAT_TXT:        SaveFormat := IG_SAVE_JPG;
      IG_FORMAT_DCM:        SaveFormat := IG_SAVE_DCM;
      IG_FORMAT_G3:         SaveFormat := IG_SAVE_TIF_G3;
      IG_FORMAT_G4:         SaveFormat := IG_SAVE_TIF_G4;
      IG_FORMAT_GIF:        SaveFormat := IG_SAVE_GIF;
      IG_FORMAT_PNG:        SaveFormat := IG_SAVE_PNG;
      IG_FORMAT_TGA:        SaveFormat := IG_SAVE_TGA;
      IG_FORMAT_JBIG:       SaveFormat := IG_SAVE_JBIG;
      IG_FORMAT_JB2:        SaveFormat := IG_SAVE_JB2;
      IG_FORMAT_EXIF_JPEG:  SaveFormat := IG_SAVE_JPG;
      IG_FORMAT_EXIF_TIFF:  SaveFormat := IG_SAVE_TIF_PACKED;
      IG_FORMAT_JPEG2K:     SaveFormat := IG_SAVE_JPEG2K;
    end;

    {/P122 - DMMN - Create annotation component based on IG16.2 ArtX /}
    if (CurrentPage <> nil) and (CurrentPage.IsValid) then
    begin
      if CurrentPageDisp = nil then
        CurrentPageDisp.Layout.UseImageResolution := True; {/p122t2 dmmn 9/7/}

      igCurPoint := GetIGManager.IGCoreCtrl.CreateObject(IG_OBJ_POINT) As IIGPoint;

      Initialize(currentDocument, igCurPoint, CurrentPageDisp, 0, True);

      TLogger.Log(Debug, 'ValidateXMLFilename = ' + ValidateXMLFilename);

      if FileExists(ValidateXMLFilename) then
        DeleteFile(ValidateXMLFilename);

      tmpXML := TStringlist.Create;
      tmpXML.LoadFromFile(XMLFilename);

      {Format the XML}
      XmlString := TStringList.Create;

      XmlString.Add(RemoveTabCharacters(tmpXML));
      XmlString.SaveToFile(ValidateXMLFilename);  // save the formatted XML layer to the cache folder

       {If the XML is well-formatted then proceed to load else false}
      if ValidateXML(ValidateXMLFilename) then
      begin

        {Go through all the pages and load the art page accordingly}
        for i := 0 to PageCount - 1 do
        begin

          {Load the XML layer into XMLControl}
          XmlString.Clear;
          XmlString.Add(RemoveTabCharacters(tmpXML));
          XMLCtl.LoadCurrentHistoryLayer(XMLString[0]);


          // name of the file contain the extracted XML page in the
          PN := XMLPath + '\^PXML.xml';

          if FileExists(PN) then
            DeleteFile(PN);

          XMLCtl.LoadCurrentHistoryToArtPage(PN,i);

          XMLString.Clear;
          XmlString.LoadFromFile(PN);
          if AnsiContainsStr(XMLString.Text, '<Objects>') then
          begin
            TLogger.Log(Debug, 'XML Layer for Page [' + IntToStr(i) + '] = ' + XmlString.Text);

            ArtPage := FArtPages[i];

            CurrentPageDisp := GetIGManager.IGDisplayCtrl.CreatePageDisplay(CurrentDocument.Page[i]);

            if (curFormat = IG_FORMAT_PDF) or (curFormat = IG_FORMAT_POSTSCRIPT) then
            begin
              newPage := GetIGManager.IGCoreCtrl.CreatePage;
              CurrentDocument.Page[i].DuplicateTo(newPage);
              newPage.Rasterize;
              CurrentPageDisp := GetIGManager.IGDisplayCtrl.CreatePageDisplay(newPage);
            end
            else
            begin
              newPage := GetIGManager.IGCoreCtrl.CreatePage;
              CurrentDocument.Page[i].DuplicateTo(newPage);
              CurrentPageDisp := GetIGManager.IGDisplayCtrl.CreatePageDisplay(NewPage);
            end;

            GetIGManager.IGArtXGUICtrl.ArtXPage := ArtPage;
            ArtPage.LoadFile(PN, 1, False);  // load the page annotations

            ArtPage.AssociatePageDisplay(CurrentPageDisp);
            currentPageDisp.AntiAliasing.Method := IG_DSPL_ANTIALIAS_NONE;

            {Burn in the annotations}
            ArtPage.BurnIn(IGArtDrawParams, IG_ARTX_BURN_IN_ALL);

//
//            {Burn in the info banner annotation (stamp) at the top of the image}
//            ArtPage.BurnIn(IGArtDrawParams, IG_ARTX_BURN_IN_ALL);


            try

              newPageDIB := newPage.GetDIBInfo;
              newPageAreaSize := newPageDIB.Width * newPageDIB.Height;
              if newPageAreaSize < 160000 then
                newPageRes := psLowRes
              else if (newPageAreaSize >= 160000) and (newPageAreaSize <= 1638400) then
                newPageRes := psMedRes
              else
                newPageRes := psLargeRes;

              AddHeader(newPageRes, currentPageDisp, newPage, 50);

              {Make the banner information as a "stamp" to add to the top of the image}
              GetAnnotTotals(XMLString.Text, TotAnnots);
              StampFilename := XmlPath + '\Stamp.xml';
              MakeStampFile(newPageRes, StampFilename, TotAnnots, CurrentDocument.Page[i].ImageHeight+1);

              IGArtDrawParams.IGPageDisplay := currentPageDisp;
              IGArtDrawParams.nOffLeft := 0;
              IGArtDrawParams.nOffTop := 300;

              ArtPage.LoadFile(StampFilename, 1, True);  {Load the annot info line}

              ArtPage.BurnIn(IGArtDrawParams, IG_ARTX_BURN_IN_ALL);

              SavePDFPage(SaveFilename, SaveFormat, newPage);

              newPage := nil;
            except
              on E:Exception do
              begin
                err := GetIGManager.checkErrors;
                TLogger.Log(Error, 'TMakeAnnotatedFile.BurnImage: Error saving rasterized PDF page - ' + err + ', ' + e.message);
              end;
            end;
            TLogger.Log(Debug, 'burned [' + PN + '] into image page [' + IntToStr(i+1) + ']');

          end
          else
          begin
            TLogger.Log(Debug, 'No annotations for image page [' + IntToStr(i+1) + ']');
//            if (curFormat = IG_FORMAT_PDF) or (curFormat = IG_FORMAT_POSTSCRIPT) then
            begin
              newPage := GetIGManager.IGCoreCtrl.CreatePage;
              CurrentDocument.Page[i].DuplicateTo(newPage);
              newPage.Rasterize;
              CurrentPageDisp := GetIGManager.IGDisplayCtrl.CreatePageDisplay(newPage);
              SavePDFPage(SaveFilename, SaveFormat, newPage);
                newPage := nil;
            end;
          end;
        end;  {for i = 0 to pagecount-1}
      end
      else
      begin
        TLogger.Log(Error, 'TMakeAnnotatedFile.BurnImage: Cannot load the current ' +
                   'annotation layer. There is a ' +
                   'problem with the annotation XML. Contact IRM');
        Exit;
      end;

      {Save document to specified location}
//      Accusoft.IOSaveLocation := nil;
//      Accusoft.IOSaveLocation := GetIGManager.IGFormatsCtrl.CreateObject(IG_FORMATS_OBJ_IOFILE) as IIGIOLocation;
//
//        (Accusoft.ioSaveLocation as IIGIOFile).FileName := SaveFilename;
//
//        SaveFlag := False;
//        FileExt := UpperCase(ExtractFileExt(SaveFilename));
//
//        if FileExt = '.PDF' then
//        begin
//          SaveFormat := IG_SAVE_PDF_UNCOMP;
//          SaveFlag := True;
//        end
//        else
//        if FileExt = '.BMP' then
//        begin
//          SaveFormat := IG_SAVE_BMP_UNCOMP;
//          SaveFlag := True;
//        end
//        else
//        if (FileExt = '.TIF') or (FileExt = '.TIFF') then
//        begin
//          SaveFormat := IG_SAVE_TIF_PACKED;
//          SaveFlag := True;
//        end
//        else
//        if (FileExt = '.DICOM') or (FileExt = '.DCM') then
//        begin
//          SaveFormat := IG_SAVE_DCM;
//          SaveFlag := True;
//        end
//        else
//        if (FileExt = '.JPG') or (FileExt = '.JPEG') then
//        begin
//          SaveFormat := IG_SAVE_JPG;
//          SaveFlag := True;
//        end
//        else
//          TLogger.Log(Error, 'SaveName = ' + SaveFilename + ' file extension [ ' + FileExt + ' ] is not supported. Cannot save annotated file');
//
//        if SaveFlag and not ((curFormat = IG_FORMAT_PDF) or (curFormat = IG_FORMAT_POSTSCRIPT) or (curFormat = IG_FORMAT_TIF)) then
//        begin
//          try
//            TLogger.Log(Debug, 'SaveName = ' + SaveFilename + ', FileExt = ' + FileExt);
////            GetIGManager.IGFormatsCtrl.SaveDocumentToFile(currentDocument, SaveFilename, 0, 0, PageCount, IG_DOCSAVEMODE_DEFAULT, SaveFormat);
//            GetIGManager.IGFormatsCtrl.SavePageToFile(newPage, savefilename, 1, IG_PageSaveMode_Default, saveformat);
//          except
//            on E:Exception do
//              writeln('TMakeAnnotatedFile.BurnImage: SaveDocumentToFile error = ' + E.Message);
//          end;
//        end;
        RetCode := '0';
    end
    else
      TLogger.Log(Error, 'TMakeAnnotatedFile.BurnImage: Current Page is nil or invalid');

  finally
    XMLCtl.Free;
    XmlString.Free;
    tmpXML.Free;

    DeleteFile(PN);
    DeleteFile(StampFilename);
    DeleteFile(ValidateXMLFilename);

    currentDocument := nil;
    igCurPoint := nil;
    CurrentPageDisp := nil;
    Accusoft.IOSaveLocation := nil;
  end;

  TLogger.Log(TraceOut, 'TMakeAnnotatedFile.BurnImage');
end;

function TMakeAnnotatedFile.SavePDFPage(SaveName: String; SaveFormat: enumIGSaveFormats; newPage: IGPage): Boolean;
begin
  {Save document to specified location}
  Accusoft.IOSaveLocation := nil;
  Accusoft.IOSaveLocation := GetIGManager.IGFormatsCtrl.CreateObject(IG_FORMATS_OBJ_IOFILE) as IIGIOLocation;

  (Accusoft.ioSaveLocation as IIGIOFile).FileName := Savename;

  try
    TLogger.Log(Debug, 'TMakeAnnotatedFile.SavePDFPage: SaveName = ' + Savename);
    GetIGManager.IGFormatsCtrl.SavePageToFile(newPage, SaveName, 1, IG_PAGESAVEMODE_APPEND, SaveFormat);
  except
    on E:Exception do
      writeln('TMakeAnnotatedFile.BurnImage: SavePDFPage error = ' + E.Message);
  end;

end;

procedure TMakeAnnotatedFile.GetAnnotTotals(PN: String; var TotAnnots: Integer);
var
  i: Integer;

  { Returns a count of the number of occurences of SubText in Text }
  function CountOccurences( const SubText: string;
                            const Text: string): Integer;
  begin
    if (SubText = '') or (Text = '') or (Pos(SubText, Text) = 0) then
      Result := 0
    else
      Result := (Length(Text) - Length(StringReplace(Text, SubText, '', [rfReplaceAll]))) div  Length(subtext);
  end;  { CountOccurences }

begin
  TotAnnots := CountOccurences('<Visible>true</Visible>', PN);
end;

function TMakeAnnotatedFile.MakeStampFile(PictureSize: TPictureResolution; StampFile: String; TotalAnnots: Integer; OffsetFromTopOfImage: Integer): Boolean;
var
  S: String;
  F: TextFile;
  FontSize: String;
  AnnotText: String;
begin
  try

    case PictureSize of
      psLowRes:    FontSize := '8.000';
      psMedRes:    FontSize := '14.000';
      psLargeRes:  FontSize := '20.000';
      else         FontSize := '8.000';
    end;

    AnnotText := 'Annotation';
    if TotalAnnots > 1 then
      AnnotText := 'Annotations';

    Result := False;
    DeleteFile(StampFile);

    S :=  '<?xml version="1.0"?>' +
          '<ARTPage>' +
            '<Orientation>1</Orientation>' +
            '<ZOrder></ZOrder>' +
            '<ARTGroup>' +
              '<Name>[Untitiled]</Name>' +
              '<Description></Description>' +
              '<Objects>' +
                '<CoordinatesType>1</CoordinatesType>' +
                '<ID>0</ID>' +
                '<RECTANGLE>' +
                  '<Mark>' +
                    '<Type>600</Type>' +
                    '<Visible>true</Visible>' +
                    '<Tooltip></Tooltip>' +
                    '<UserData></UserData>' +
                  '</Mark>' +
                  '<Bounds>' +
                    '<X>0</X>' +
                    '<Y>' + IntToStr(OffsetFromTopOfImage) + '</Y>' +
                    '<Width>2000</Width>' +
                    '<Height>40</Height>' +
                  '</Bounds>' +
                  '<Opacity>255</Opacity>' +
                  '<Border>' +
                    '<Width>1</Width>' +
                    '<Style>0</Style>' +
                    '<Color>' +
                      '<Red>0</Red>' +
                      '<Green>0</Green>' +
                      '<Blue>0</Blue>' +
                      '<Reserved>0</Reserved>' +
                    '</Color>' +
                  '</Border>' +
                  '<FillColor>' +
                    '<Red>0</Red>' +
                    '<Green>0</Green>' +
                    '<Blue>0</Blue>' +
                    '<Reserved>5</Reserved>' +
                  '</FillColor>' +
                '</RECTANGLE>' +
              '</Objects>' +
              '<Objects>' +
                '<CoordinatesType>1</CoordinatesType>' +
                '<ID>1</ID>' +
                '<TEXT>' +
                  '<Mark>' +
                    '<Type>605</Type>' +
                    '<Visible>true</Visible>' +
                    '<Tooltip></Tooltip>' +
                    '<UserData></UserData>' +
                  '</Mark>' +
                  '<Bounds>' +
                    '<X>2</X>' +
                    '<Y>' + IntToStr(OffsetFromTopOfImage + 2) + '</Y>' +
                    '<Width>200</Width>' +
                    '<Height>40</Height>' +
                  '</Bounds>' +
                  '<Opacity>255</Opacity>' +
                  '<TextType>0</TextType>' +
                  '<TextColor>' +
                    '<Red>255</Red>' +
                    '<Green>255</Green>' +
                    '<Blue>0</Blue>' +
                    '<Reserved>5</Reserved>' +
                  '</TextColor>' +
                  '<BorderShading>0</BorderShading>' +
                  '<Text> ' + IntToStr(TotalAnnots) + ' ' + AnnotText + '</Text>' +
                  '<Font>' +
                    '<Name>Arial</Name>' +
                    '<Size>' + FontSize + '</Size>' +
                    '<Style>1</Style>' +
                    '<DisablePPM>false</DisablePPM>' +
                  '</Font>' +
                  '<Orientation>1</Orientation>' +
                  '<BoundsWrap>3</BoundsWrap>' +
                  '<Alignment>0</Alignment>' +
                '</TEXT>' +
              '</Objects>' +
            '</ARTGroup>' +
          '</ARTPage>';

    AssignFile(F, StampFile);
    try
      Rewrite(F);
      Writeln(F,S);
      Result := True;
    finally
      CloseFile(F);
    end;
  except
    on E:Exception do
    begin
      TLogger.Log(Error, 'TMakeAnnotatedFile.MakeStampFile: Error = ' + E.Message);
      Result := False;
    end;
  end;
end;

function TMakeAnnotatedFile.RemoveTabCharacters(XML: TStringList): String;
var
  i: Integer;
  temp : string;
begin
  Result := '';
  for i := 0 to XML.Count - 1 do
  begin
    //p122t5 dmmn - avoid accidently remove the correct new line characters 
    temp := SysUtils.StringReplace(XML[i], '|TAB|', '', [rfReplaceAll]);
    temp := SysUtils.StringReplace(temp, #10, '', [rfReplaceAll]);
    temp := SysUtils.StringReplace(temp, #13, '', [rfReplaceAll]);
    Result := Result + temp;
//    Result := Result + SysUtils.StringReplace(XML[i], '|TAB|', '', [rfReplaceAll]);
//    Result := SysUtils.StringReplace(Result, #10, '', [rfReplaceAll]);
//    Result := SysUtils.StringReplace(Result, #13, '', [rfReplaceAll]);
//    Result := SysUtils.StringReplace(Result, '^\r\n^',#13#10, [rfReplaceAll]);   //p122T1 dmmn - new line delim
  end;

  //p122t5 make sure that all the non standard control characters are out of the xml
  Result := SysUtils.StringReplace(Result, '^\r\n^',#13#10, [rfReplaceAll]);
end;

{ TXMLCtl }

constructor TXMLCtl.Create(Dir: string);
begin
  {/P122 DMMN 6/21/2011 Create the controler for manipulating XML files /}
  FAnnotationDir := Dir;

  DocCurrentSession := TXMLDocument.Create(nil);
  DocHistoryView := TXMLDocument.Create(nil);
  TmpView := TXMLDocument.Create(nil);
end;

destructor TXMLCtl.Destroy;
begin
  DocCurrentSession := nil;
  DocHistoryView := nil;
  TmpView := nil;
end;

procedure TXMLCtl.LoadCurrentHistoryLayer(xmlLayer: string);
begin
  if DocCurrentSession <> nil then
    DocCurrentSession := nil;

  DocCurrentSession := TXMLDocument.Create(nil);

  DocCurrentSession.Active := True;
  DocCurrentSession.loadFromXML(xmlLayer);
end;

procedure TXMLCtl.LoadCurrentHistoryToArtPage(PN: string; pageNum: Integer);
var
  tempXML : IXMLDocument;
  PNode : IXMLNode;
  ANode : IXMLNode;
begin
  {/p122t4 dmmn 9/29 - overloaded method load the xml page into predetermined file /}
  tempXML := TXMLDocument.Create(nil);
  try
    // Grab the artpage XML in the history file
    Anode := SelectNode(DocCurrentSession.DocumentElement, '/History/Page[@number=' + IntToStr(pageNum) + ']');

    if Anode = nil then
    begin
      SaveXMLToFile(PN, nil);
    end
    else
    begin
      if Anode.HasChildNodes then
      begin
        Anode := Anode.ChildNodes[0];
      end;

      tempXML.Active := False;
      tempXML.Active := True;
      tempXML.ChildNodes.Insert(0, ANode);

      SaveXMLToFile(PN, tempXML);
    end;
  finally
    tempXML := nil;
  end;
end;

procedure TXMLCtl.LoadHistoryToArtPage(pageNum: Integer);
{/P122 This method will load a page in the history file to the corresponding artpage }
var
  tempXML : IXMLDocument;
  PNode : IXMLNode;
  ANode : IXMLNode;
  fName : string;
begin
  tempXML := TXMLDocument.Create(nil);
  try
    // Grab the artpage XML in the history file
    Anode := SelectNode(DocHistoryView.DocumentElement,
                        '/History/Page[@number=' + IntToStr(pageNum) + ']/ARTDocument');
    tempXML.Active := True;
    tempXML.ChildNodes.Insert(0, ANode);

    fName := FTmpPath + '^PXML.xml';
    SaveXMLToFile(fName, tempXML);
  finally
    tempXML := nil;
  end;
end;

procedure TXMLCtl.SaveXMLToFile(fileName: String; XMLDoc: IXMLDocument);
{ Save and XML Document with proper format to the directory for annotations }
var
  pList : TStringList;
begin
  pList := TStringList.Create;
  try
    if XMLDoc = nil then
    begin
      pList.Add('');
      pList.SaveToFile(fileName);
    end
    else
    begin
      pList.Assign(XMLDoc.XML);
      pList.Insert(0, '<?xml version="1.0"?>');

      // fileName must not contain the path, just the name of the file
      pList.SaveToFile(fileName);
    end;
  finally
    pList.Free;
  end;
end;

function TXMLCtl.SelectNodes(xnRoot: IXmlNode; const nodePath: WideString): IXMLNodeList;
var
  intfSelect : IDomNodeSelect;
  intfAccess : IXmlNodeAccess;
  dnlResult  : IDomNodeList;
  intfDocAccess : IXmlDocumentAccess;
  doc: TXmlDocument;
  i : Integer;
  dn : IDomNode;
begin
  Result := nil;
  if not Assigned(xnRoot)
    or not Supports(xnRoot, IXmlNodeAccess, intfAccess)
    or not Supports(xnRoot.DOMNode, IDomNodeSelect, intfSelect) then
    Exit;

  dnlResult := intfSelect.selectNodes(nodePath);
  if Assigned(dnlResult) then
  begin
    Result := TXmlNodeList.Create(intfAccess.GetNodeObject, '', nil);
    if Supports(xnRoot.OwnerDocument, IXmlDocumentAccess, intfDocAccess) then
      doc := intfDocAccess.DocumentObject
    else
      doc := nil;

    for i := 0 to dnlResult.length - 1 do
    begin
      dn := dnlResult.item[i];
      Result.Add(TXmlNode.Create(dn, nil, doc));
    end;
  end;
end;

function TXMLCtl.SelectNode(xmlRoot: IXmlNode;
  const nodePath: WideString): IXmlNode;
var
  nodeSelect : IDomNodeSelect;
  nodeResult : IDomNode;
  docAccess : IXmlDocumentAccess;
  xmlDoc: TXmlDocument;
begin
  Result := nil;
  if not Assigned(xmlRoot) or not Supports(xmlRoot.DOMNode, IDomNodeSelect, nodeSelect) then
    Exit;
  nodeResult := nodeSelect.selectNode(nodePath);

  if Assigned(nodeResult) then
  begin
    if Supports(xmlRoot.OwnerDocument, IXmlDocumentAccess, docAccess) then
      xmlDoc := docAccess.DocumentObject
    else
      xmlDoc := nil;
    Result := TXmlNode.Create(nodeResult, nil, xmlDoc);
  end;
end;

  exports Delphi_MakeAnnotatedFile;
  exports Delphi_MakePDFDoc;
  exports Delphi_PDFJobCompleted;
  exports Delphi_AnnotatedJobCompleted;
  exports Delphi_TestConnection;
  
begin

end.

