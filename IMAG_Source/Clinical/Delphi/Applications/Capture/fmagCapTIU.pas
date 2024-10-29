Unit FmagCapTIU;
   {
   Package: MAG - VistA Imaging
   WARNING: Per VHA Directive 10-93-142 this unit should not be modified.
   Date Created:
   Site Name: Silver Spring, OIFO
   Developers: Garrett Kirin
   Description: Imaging TIU Document selection window.  Notes, CP, Discharge Summaries
      ( and later, whatever package converts to TIU.)
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
  Buttons,
  Classes,  Windows,
  ImgList,
  Graphics,
  ToolWin,
  ComCtrls,
  Controls,
  Dialogs,
  ExtCtrls,
  Forms,
  Menus,
  Messages,
  Stdctrls,

//RCA     cmag4viewer,
//RCA  cMagImageList,
  cMagListView,
  cMagPat,
  UMagClasses,
  UMagDefinitions,

  imaginterfaces
//RCA   , cmagimagelist,  cmag4viewer
  ;

 {Type to define what type of selected note.}
Type
  TMagNoteTypes = Set Of (MagntSigned, MagntUnSigned, MagntUnCoSigned, MagntMine);
 {Type to define the State of the TIU list window.  Method code is conditional based
     on the State of the TIU Window.}
Type
  TMagNoteWinState = (NwsList, NwsComplete, NwsUnsigned, NwsAddendum, NwsNew);
Type
  TfrmCapTIU = Class(TForm)
    MnuFitToWindow: TMenuItem;
    FontDialog1: TFontDialog;
    MainMenu1: TMainMenu;
    MnuAuthor: TMenuItem;
    MnuClearAuthor: TMenuItem;
    MnuConsults: TMenuItem;
    MnuExit: TMenuItem;
    MnuFile: TMenuItem;
    MnuFont: TMenuItem;
    MnuHelp: TMenuItem;
    MnuHelpSelectProgressNote: TMenuItem;
    MnuMine: TMenuItem;
    MnuNewAddendum: TMenuItem; {Start a New Addendum }
    MnuNewNote: TMenuItem; {Start a New Note}
    MnuOptionsSelect: TMenuItem;
    MnuPreviewNote: TMenuItem;
    MnuRefresh: TMenuItem; {Refresh Titles/Note Listing}
    MnuFitToText: TMenuItem;
    MnuSave: TMenuItem; {Save all selections}
    MnuSelectNote: TMenuItem; {Process the selected Note}
    MnuSigned: TMenuItem;
    MnuSignNote: TMenuItem;
    MnuSummaries: TMenuItem;
    MnuUnCosigned: TMenuItem;
    MnuUnSigned: TMenuItem;
    MnuView: TMenuItem;
    N1: TMenuItem;
    N2: TMenuItem;
    N3: TMenuItem;
    N4: TMenuItem;
    N5: TMenuItem;
    N6: TMenuItem;
    SelectColumns1: TMenuItem;
    StatusBar1: TStatusBar;
    MnuClearText: TMenuItem; {Clear text from New Note text memo field}
    MnuEnableTextEntry: TMenuItem;
    N9: TMenuItem;
    MnuOptionsCreate: TMenuItem; {Create the Options dialog}
    ClearText1: TMenuItem;
    N8: TMenuItem;
    Font1: TMenuItem;
    Tabbingseq1: TMenuItem;
    MnuShowAddendums: TMenuItem; {Show Addendums and Notes in same list}
    N11: TMenuItem;
    Imglst16w: TImageList;
    ResetPanelsize1: TMenuItem;
    ResetPanelsize2: TMenuItem;
    Timerlkp: TTimer; {Timer Component for background lookups}
    MnuListOptions: TMenuItem; {Create the Options dialog}
    UserBoilerplateifexist1: TMenuItem; {Flag to determine if Boiler Plate is used.}
    PageControl: TPageControl; {has 'New' and 'Select' pages.}
    TabshSelect: TTabSheet; {Tab sheet for selection existing Notes}
    TabshNew: TTabSheet; {Tab sheet for creating New Notes}
    StatusBar2: TStatusBar;
    TbarMain: TToolBar;
    TbPreview: TToolButton;
    TbtnDivider1: TToolButton;
    TbtnMine: TToolButton;
    TbtnSigned: TToolButton;
    Tbtndivider2: TToolButton;
    TbtnUnSigned: TToolButton;
    TbtnUnCosigned: TToolButton;
    TbrnDivider3: TToolButton;
    TbtnAuthor: TToolButton;
    ToolButton1: TToolButton;
    TbtnNoteOptions: TToolButton; {Button will open Options window}
    ToolButton2: TToolButton;
    TbtnSignNote: TToolButton; {E-Sign the selected note}
    PnlListNotes: Tpanel; {Hold Note List, preview memo}
    PnlNotes: Tpanel; {Hold Note List and radio group}
    MlvNotes: TMagListView; {list of Notes}
    PnlOkCancel: Tpanel; {Panel holds Ok and Cancel buttons}
    LbNoteTitle: Tlabel; {label for Note Title Prompt}
    SpltTitle: TSplitter;
    PnlNewText: Tpanel; {panel hold new text memo component}
    LbActionDesc: Tlabel; {label for Action Description prompt}
    Label5: Tlabel;
    MemNewNoteText: TMemo; {memo for text and/or bolier plate for new note}
    N12: TMenuItem;
    MlvAuthor: TMagListView; {Author list}
    MlvLoc: TMagListView; {Visit Location list}
    btnVisit: TButton; {Visit Location button to load the list}
    LbVisit: Tlabel; {label for 'Visit Location'}
    Label4: Tlabel;
    LbNewNote: Tlabel; {label for New Note Title}
    MnuAddendum: TMenuItem; {Create Addeneum for selected Note}
    PnlAddendum: Tpanel; {holds addendum radio group of status}
    LbAddendum: Tlabel; {label ' Addendum'}
    MemAddNoteText: TMemo; {memo for new text}
    Rgrp2Addendum: TRadioGroup; {addendum status radio group}
    PnlPreview: Tpanel;
    Lbpreview: Tlabel;
    Splitter2: TSplitter;
//RCA    Mag4Viewer1: TMag4Viewer;
    MemNoteText: TMemo; {memo for display (read only) of note text }
    SpltList: TSplitter;
    Rgrp2NoteStatus: TRadioGroup;
    btnOK: TBitBtn;
    btnCancel: TBitBtn;
    PnlcbAddendum: Tpanel; {panel holds Addendum controls}
    ImageAddendum: TImage; {icon for Addenedum}
    cbAddendum: TCheckBox; {check box to say if an Addendum is being created}
    Pnltitles: Tpanel; {panel holds components for Title processing}
    Label2: Tlabel;
    Label3: Tlabel;
    LbNewNoteTitle: Tlabel; {label 'New Note' title}
    Panel3: Tpanel;
    MlvTitles: TMagListView; {list of titles}
    PnlScrollTxt: Tpanel;
    ScbarTitles: TScrollBar;
    btnNewNoteOK: TBitBtn; {Approve selection of New Note}
    btnNewNoteCancel: TBitBtn; {Cancel selection of New Note}
    EdtAuthor: TEdit; {Edit field for author selection}
    EdtLoc: TEdit; {edit field for Visit Location selection}
    Rgrp2NewNoteStatus: TRadioGroup; {for Status options for New Note}
    EdtTitle: TEdit; {edit field for Title }
    btnAuthor: TBitBtn; {button to open author selection}
    btnLoc: TBitBtn; {button to open Visit Location selection}
    ImglstWide: TImageList;
    Button2: TButton;
    N10: TMenuItem;
    MnuFitToTextm2: TMenuItem;
    MnuFitToWindowm2: TMenuItem;
    ImglstWide2: TImageList;
    ListOptions1: TMenuItem; {Open the List Options Dialog window}
    N7: TMenuItem;
    mnuTest: TMenuItem;
    mnuTestShowColumnWidths: TMenuItem;
    mlvUnSigned: TMagListView;
    splUnsigned: TSplitter;
    tbtnMore: TToolButton;
    Procedure btnOKClick(Sender: Tobject);
    Procedure btnVisitClick(Sender: Tobject);
    Procedure MnuFitToWindowClick(Sender: Tobject);
    Procedure FontDialog1Apply(Sender: Tobject; Wnd: Hwnd);
    Procedure FormCreate(Sender: Tobject);
    Procedure FormDestroy(Sender: Tobject);
    Procedure FormShow(Sender: Tobject);
    Procedure ListView1DblClick(Sender: Tobject);
    Procedure MlvGenericDblClick(Sender: Tobject);
    Procedure MlvGenericSelectItem(Sender: Tobject; Item: TListItem; Selected: Boolean);
    Procedure MlvTitlesDblClick(Sender: Tobject);
    Procedure MlvTitlesSelectItem(Sender: Tobject; Item: TListItem; Selected: Boolean);
    Procedure MnuAuthorClick(Sender: Tobject);
    Procedure MnuClearAuthorClick(Sender: Tobject);
    Procedure MnuExitClick(Sender: Tobject);
    Procedure MnuFontClick(Sender: Tobject);
    Procedure MnuHelpSelectProgressNoteClick(Sender: Tobject);
    Procedure MnuMineClick(Sender: Tobject);
//////////////////////
    Procedure MnuNewNoteClick(Sender: Tobject);
    Procedure MnuPreviewNoteClick(Sender: Tobject);
    Procedure MnuRefresh2Click(Sender: Tobject);
    Procedure MnuRefreshClick(Sender: Tobject);
    Procedure MnuFitToTextClick(Sender: Tobject);
    Procedure MnuSelectNoteClick(Sender: Tobject);
    Procedure MnuSignedClick(Sender: Tobject);
    Procedure MnuUnCosignedClick(Sender: Tobject);
    Procedure MnuUnSignedClick(Sender: Tobject);
    Procedure MnuViewClick(Sender: Tobject); {View menu item is clicked}
    Procedure SelectColumns1Click(Sender: Tobject);
    Procedure TbPreviewClick(Sender: Tobject);
    Procedure TbtnAuthorClick(Sender: Tobject);
    Procedure TbtnMineClick(Sender: Tobject);
    Procedure TbtnMyNotesClick(Sender: Tobject);
    Procedure TbtnNoteOptionsClick(Sender: Tobject); {ToolButton list options clicked}
    Procedure TbtnSignedClick(Sender: Tobject);
    Procedure TbtnUnCosignedClick(Sender: Tobject);
    Procedure TbtnUnSignedClick(Sender: Tobject);
    Procedure TbtnSignNoteClick(Sender: Tobject); {Toolbutton, Sign a note is clicked}
    Procedure MnuClearTextClick(Sender: Tobject);
    Procedure ClearText1Click(Sender: Tobject);
    Procedure Tabbingseq1Click(Sender: Tobject);
    Procedure MnuShowAddendumsClick(Sender: Tobject); {Menu item 'show related items' is clicked}
    Procedure ResetPanelsize2Click(Sender: Tobject); {panel is resized, it's components need resized also}
    Procedure EdtTitleKeyDown(Sender: Tobject; Var Key: Word; Shift: TShiftState); {Key pressed while in the Title edit box}
    Procedure TimerlkpTimer(Sender: Tobject); {Timer delay expires, code is executed}
    Procedure EdtTitleKeyUp(Sender: Tobject; Var Key: Word; Shift: TShiftState); {A Key's state is now Up, not pressed.}
    Procedure ScbarTitlesScroll(Sender: Tobject; ScrollCode: TScrollCode; Var ScrollPos: Integer); {List of Titles is scrolled}
    Procedure MlvTitlesKeyUp(Sender: Tobject; Var Key: Word; Shift: TShiftState); {Key up in Title List}
    Procedure MlvTitlesKeyDown(Sender: Tobject; Var Key: Word; Shift: TShiftState); {Key down in Title List}
    Procedure MlvTitlesChange(Sender: Tobject; Item: TListItem; Change: TItemChange); {Selection change in Title List}
    Procedure MnuListOptionsClick(Sender: Tobject); {Menu option to open Options dialog is clicked}
    Procedure UserBoilerplateifexist1Click(Sender: Tobject); {Check Menu.  Tells if user wants to use BoilerPlate Text}
    Procedure btnNewNoteOKClick(Sender: Tobject); {Start a New Note Toolbutton is clicked}
    Procedure PageControlChange(Sender: Tobject); {User has switched from New Note to Select Existing}
    Procedure EdtAuthorKeyUp(Sender: Tobject; Var Key: Word; Shift: TShiftState); {Key up in Author Edit box}
    Procedure EdtAuthorEnter(Sender: Tobject); {Focus has been changed to Author edit box}
    Procedure MlvTitlesEnter(Sender: Tobject); {Focus has been changed to Titles List}
    Procedure EdtTitleEnter(Sender: Tobject); {Focus has been changed to Title Edit box}
    Procedure ScbarTitlesEnter(Sender: Tobject); {Focus has changed to Scroll Bar}
    Procedure EdtAuthorKeyDown(Sender: Tobject; Var Key: Word; Shift: TShiftState); {Key down in Author Edit box}
    Procedure MlvAuthorSelectItem(Sender: Tobject; Item: TListItem; Selected: Boolean); {Menu item Author Select is clicked}
    Procedure MlvAuthorEnter(Sender: Tobject); {List of Authors now has focus}
    Procedure MlvAuthorClick(Sender: Tobject); {Click in the List of Authors}
    Procedure MlvAuthorExit(Sender: Tobject); {Focus leaves the List of Authors}
    Procedure btnAuthorClick(Sender: Tobject); {Button : Author, is clicked}
    Procedure EdtLocEnter(Sender: Tobject); {Focus changed to Visit Location Edit Box}
    Procedure EdtLocKeyDown(Sender: Tobject; Var Key: Word; Shift: TShiftState); {Key pressed in Visit Location edit box}
    Procedure EdtLocKeyUp(Sender: Tobject; Var Key: Word; Shift: TShiftState); {Key state change to UP, in Visit Location edit box}
    Procedure MlvLocClick(Sender: Tobject); {Click in Visit Location list}
    Procedure MlvLocEnter(Sender: Tobject); {Focus changed to Visit Location list}
    Procedure MlvLocExit(Sender: Tobject); {Focus leaves Visit Location list}
    Procedure MlvLocSelectItem(Sender: Tobject; Item: TListItem; Selected: Boolean); {Item is selected in Visit Location list}
    Procedure btnLocClick(Sender: Tobject); {Visit Location Button is clicked.}
    Procedure Rgrp2NewNoteStatusEnter(Sender: Tobject); {Focus changed to New Note Status Radio Group }
    Procedure EdtTitleExit(Sender: Tobject); {Focus leaves Title edit box}
    Procedure ResetPanelsize1Click(Sender: Tobject);
    Procedure Font1Click(Sender: Tobject);
    Procedure FormClose(Sender: Tobject; Var action: TCloseAction);
    Procedure MnuAddendumClick(Sender: Tobject); {Menu Item 'Addendum' is clicked}
    Procedure cbAddendumClick(Sender: Tobject); {CheckBox 'Addendum' is clicked}
    Procedure Rgrp2NoteStatusClick(Sender: Tobject); {Note Status Radio Group clicked}
    Procedure Rgrp2AddendumClick(Sender: Tobject); {Addendum Status Radio Group clicked}
    Procedure Rgrp2NewNoteStatusClick(Sender: Tobject); {Note Status Radio Group clicked}
    Procedure FormPaint(Sender: Tobject);
    Procedure MlvNotesDrawItem(Sender: TCustomListView; Item: TListItem; Rect: Trect; State: TOwnerDrawState);
    Procedure MlvNotesGetSubItemImage(Sender: Tobject; Item: TListItem; SubItem: Integer; Var ImageIndex: Integer);
    Procedure ScbarTitlesKeyDown(Sender: Tobject; Var Key: Word; Shift: TShiftState); {Key down in Scroll Bar for titles}
    Procedure Button2Click(Sender: Tobject);
    Procedure MnuSignNoteClick(Sender: Tobject); {Menu item 'Sign Note' clicked}
    Procedure SpltListCanResize(Sender: Tobject; Var NewSize: Integer; Var Accept: Boolean);
    Procedure SpltTitleCanResize(Sender: Tobject; Var NewSize: Integer; Var Accept: Boolean);
    Procedure ListOptions1Click(Sender: Tobject);
    Procedure PnlPreviewResize(Sender: Tobject);
    Procedure PnlNewTextResize(Sender: Tobject);
    Procedure mlvGenericKeyUp(Sender: Tobject; Var Key: Word; Shift: TShiftState);
    procedure mnuHelpClick(Sender: TObject);
    procedure mnuTestShowColumnWidthsClick(Sender: TObject);
    procedure btnMoreClick(Sender: TObject);

    procedure mlvGenericClick(Sender: TObject);
    procedure tbtnMoreClick(Sender: TObject);
///////
  Private
    FUPcount : integer;
    // for testing
    FCurMlv : TMagListView;
    Row0HeadersSigned : string;
    Row0HeadersUnSigned : string;
    MagAddnd : Tmaglistview;
    FilePreInc : integer;


    FLastItem : TlistItem;
    FAreAddingToNotesListing  : boolean;  //p129 t 15  flag to tell to keep existing base list.

    FBaseNoteList : Tstringlist;
    DidUseAuthorSearch : boolean;

    ctAuth : integer;
    FTestingColumnWidths : string;
    FCanEfile: Boolean; {Can this user E-file a Note based on Security Key}
    FStatusUnSigned, {Temp variable for Status of Note}
      FStatusAddendum, {Temp variable for Status of Note}
      FStatusNewNote: Integer; {Temp variable for Status of Note}
    FAddendumToSignedNote, {Are we creating an Addendum to Signed Note}
      FUseBoilerPlate: Boolean; {We are using BoilerPlate Text}
    FDelOneMore: Boolean; {In edit field when backspace is entered}
    FDelOneMoreAuth: Boolean; {In edit field when backspace is entered}
    FDelOneMoreLoc: Boolean; {In edit field when backspace is entered}
    FClick: Integer; {Temp variable tells which list was clicked for Timer lookup}

    FtstringsMyList, FtstringsStartList, {The list of Titles, Personnal, Last 44 and First 44}
      FtstringsEndList: TStrings; {Last 44 Titles.}
    FtstringColumn: String;
    FOnScroll: Boolean; {If list scrolled, the Timer Lookup needs to know}
    ///FshowAddendums: Boolean; {Flag, to tell if Addendums are also shown in Note List}
    {p129t17   name change to assure we don't confuse the way it used to work, with the way
              it works in P129t17}
    FlagToShowAddendums : boolean;
    FTIUClinDataObj: TClinicalData; {Object to hold all information that user selected in TIU Note window}
    FfitUnSignedoncetotext : boolean;
    Ffitoncetotext: Boolean;
    FAuthor: String;
    FAuthorDuz: String;
    FNoteReturnCount,
      Fmthsback: Integer; {part of User Prefs, how many months back to start the Note List}
    FdtFrom, FdtTo: String;
    FInitialFROMDate, FinitialToDate : string;
    FUseStatusIcons: Boolean; {Show/Not Show the icons in the Note List}
    FUseNoteGlyphs: Boolean; {Use Glyphs or Text on Main Window for Note Action Status}
    FDefaultheight: Integer;
    FDFN: String;
    FPatient: String;
    FeSignTrys: Integer;
    FNewAuthor: String; {Author for the New Note}
    FNewAuthorDuz: String; {DUZ of Author}
    FNewlocation: String; {Visit Location for New Note}
    FNewLocationDA: String; {DA for Location}
    FNewTitle: String; {Title for New Note}
    FNewTitleDA: String; {DA of Title}
    FNewTitleIsConsult: Boolean; {Tells if we need a Consult with Note}
    FNewTitleConsultDA: String; {DA of Consult}
    FNoteTypes: TMagNoteTypes; {Holds the Type of Note to create}
    FPreviewImages: Boolean;
    FPreviewNote: Boolean;
    FTitleIEN: Tstringlist;
    Ftypeoflist: Integer; {Tells which list was clicked, used for Timer Lookup}
    FUseAuthorSearch: Boolean;
    FVisitstring: String; {V-String construct to pass to TIU API for creating New Note.}
    FNoteLVColWidths : string; //p129 dmmn 12/20/12
    FUseNoteColWidthPref : boolean;   //p129 dmmn 12/20/12

    Procedure ClearPreview;
    Procedure ClearTheList;
    Procedure DisableAllButtons;
    Procedure InitializePatient(xMagPat: TMag4Pat);
    Function LookupAuthor: Boolean;
    Procedure NotesByContext;
    Procedure PreviewImagesForNote(VTIUObj: TMagTIUData);
    Procedure PreviewSelectedNote;
    Procedure ResizeColumns;
    Procedure SetAuthor(XDuz, XName: String);
    Procedure SetMine(Value: Boolean);
    Procedure SetPreviewNote(Value: Boolean);
    Procedure SetSigned(Value: Boolean);
    Function ShowNoteTitle(TiuObj: TMagTIUData): String;
    Procedure ShowStatus(Xpanel: Integer; Value: String);

    Procedure ToggleAuthorSearch;
    Procedure WinMsg(s: String);
    Procedure WMGetMinMaxInfo(Var Message: TWMGetMinMaxInfo); Message WM_GetMinMaxInfo;
    Procedure SetAbleToOK(Value: Boolean); {OK Button and other controls are enabled. Other are disabled}
    Procedure Showtabbingseq;
    Procedure ReWorkTheNoteListing(rbase : Tstringlist; mlv : Tmaglistview ); {A Refresh that Adds Addendums into the Listing}
    Function MatchingPiece(Str: String; t: Tstringlist; Piece: Integer): Boolean;

    Procedure SetPrefs(VUprefCapTIU: TuprefCapTIU); {Sets user preferences for the window.}
    Procedure ResetPanelSize;
    Function GenKeyUp(Edt: TEdit; Var Txt: String; Var Fulltext: String; LV: TMagListView; Delchar: Boolean = False): Integer; {Called from Timer Lookup. 'Gen'eric for any lookup}

    (*    procedure ScrollItemInView(lv: TListView; li: Tlistitem);  *)
    Function GetTitlesFromVista(Starttext: String; Dir: Integer = 1; Mylist: Boolean = False): TStrings; {Calls to get list of Note Titles}
    Function GetAuthorsFromVista(Starttext: String; Dir: Integer = 1): TStrings; {Call to get list of Authors from VistA}
    Function GetLocationsFromVista(Starttext: String; Dir: Integer = 1): TStrings; {Call to get list of Visit Locations from VistA}
    Procedure GetPersonnalTitleList; {Gets this users personnal title list}
    Procedure SetDefaultUserPrefs(VUprefCapTIU: TuprefCapTIU); {User the Object to Set preferences.}
    (*    procedure SetCount(value: integer; vdtfrom: string = ''; vdtto: string = ''); *)
    Procedure GetListOptions; {Opens Option dialog window}
    Procedure SetStatusBarListOptions;
    Procedure ComputeHeight(LV: TMagListView; Edt: TEdit);
    Procedure SaveAndClose; {Saves all selected information into the TClinicalData object.  This object is passed back to calling window}
    Procedure HideLists; {Used to update the lists}
    Procedure GetSelectedLoc; {Gets Visit Location selection from listing.}
    Procedure ChangeState(State: TMagNoteWinState; vTiuObj: TMagTIUData = nil); {Change the listing of Notes based on state.}
    Procedure SetAbleToSignNote(Value: Boolean); {Based on Call to TIU AUTHORIZED, we allow user to Sign Notes.}
    Procedure SetAbleToMakeAddendum(Value: Boolean); {Based on Call to TIU Authorized, we allow user to create Addendum to this note}
    Procedure SetAreMakingAddendum(Value: Boolean); {Flag used in upcomming processing.}
    Function ConvertStatus(Value: Integer): Integer; {Status number is converted to number system used by main window}
    Function GetTIUObject(mlv :Tmaglistview; li : Tlistitem = nil) : TMagTIUData; {Gets Data for a Selected Note.  TmagTIUData holds data for 1 TIU Note}
    Procedure ApplyEFile(Value: Boolean); {If user can E-File a note, we enabled controls.}
    Procedure SetDefaults;
    Procedure SyncButtonsToNoteTypes(Notetype: TMagNoteTypes); {Depending on Types of Notes listed, enable certain buttons}
    Procedure SetUseStatusIcons(Value: Boolean); {Set list properties to use/not use icons}
    Procedure InvertTStrings(Rlist2: TStrings);
    Procedure CheckOverLapStart(MlvTitles: TMagListView; Rlist: TStrings); {Check the return list of titles to see if any overlap in starting list.}
    Procedure CheckOverLapEnd(MlvTitles: TMagListView; Rlist: TStrings); {Check the return list of titles to see if any overlap in Ending list.}
    Function IsAtListBeginning: Boolean; {Flag used for list processing}
    Function IsAtListEnd: Boolean; {Flag used for list processing}
    Procedure SignUnsignedNote; {Called when user wants to sign a note.}
     {Certain controls are enabled/disabled depending on signed status of Note}
     Procedure SetUnSigned(Value: Boolean);
    procedure EnableMoreButton(value :boolean; count : integer = 50);
    procedure InitializeDatesFlagsForMore;
    procedure GetSetStatusCounts(tt : tstringlist; var ctSigned,ctUnSigned,ctUnCosigned,CtAddendum : integer);
    procedure ClearDuplicates(tbase: Tstringlist);
    procedure ShowHideAddendums;
    procedure RePosAddendums(mlv : Tmaglistview);
    procedure InsertAddnd(Addnd, Notes : Tmaglistview);
    procedure SetSignedBtnCaption;
    procedure NotesByContextUnsigned;
    procedure SetUnCoSigned(Value: Boolean);
    procedure ShowUnsigned(value: boolean);
    procedure GetSignedNotes(value : boolean);
    procedure GetMoreNotes;
    procedure UnSelectOtherListItem;
    procedure RefreshNotesListing;
  Public
    Function Execute(VMagPat: TMag4Pat; Var VClinDataobj: TClinicalData; Var VUprefCapTIU: TuprefCapTIU; VEFile: Boolean = False): Boolean;
      {This dialog window is called by this method, the Variable paramaters  vClinDataObj and vUprefCapTIU will have all info pertaining to user's selections }

  End;

Var
  FrmCapTIU: TfrmCapTIU;

Implementation

Uses
  ImagDMinterface, //DmSingle,
  FmagCapMain,
  FmagCapPatConsultList,
  FmagCapTIUoptions,
  FmagEsigDialog,
  FmagPatVisits,
  FmagVistALookup,
  Magpositions,
  SysUtils,
  Umagutils8
  ;

{$R *.DFM}

{procedure WMGetMinMaxInfo( var message : TWMGetMinMaxInfo); message WM_GETMINMAXINFO;}

{
********************************** TfrmCapTIU **********************************
}

Procedure TfrmCapTIU.btnOKClick(Sender: Tobject);
Begin
  If (MlvNotes.Selected = Nil) and (mlvUnsigned.selected = nil)  Then Exit;
  MlvTitles.Selected := Nil;
  ModalResult := MrOK;
End;

Procedure TfrmCapTIU.btnVisitClick(Sender: Tobject);
Var
  Xvisit: String;
//  dispdt: string;
Begin
  PatVisitsform.GetVisits;

  If Not PatVisitsform.Selectvisit(Xvisit) Then Exit;
  FVisitstring := Xvisit;
  If Maglength(Xvisit, ';') = 1 Then
    LbVisit.caption := FmtoDispDt(MagPiece(Xvisit, ';', 1))
  Else
    LbVisit.caption := FmtoDispDt(MagPiece(Xvisit, ';', 2));

End;

Procedure TfrmCapTIU.ClearPreview;
Begin
  MemNoteText.Clear;
  Lbpreview.caption := '';
  //  mag4Viewer1.ClearViewer;
End;

Procedure TfrmCapTIU.SetAbleToOK(Value: Boolean);
Begin
  if (mlvNotes.Selected = nil) and (mlvUnsigned.Selected = nil) then  value := false;

  btnOK.Enabled := Value;
  MnuSave.Enabled := Value;
End;

Procedure TfrmCapTIU.ClearTheList;
Var
  i: Integer;
  TiuObj: TMagTIUData;
Begin
  SetAbleToOK(False);
  For i := 0 To MlvNotes.Items.Count - 1 Do
  Begin
    TiuObj := MlvNotes.Items[i].Data;
  //    dispose(tiuinfoptr);
    TiuObj.Free;
  End;
  MlvNotes.Items.Clear;
  FBaseNoteList.Clear;
  InitializeDatesFlagsForMore;
  WinMsg('');
End;

Procedure TfrmCapTIU.DisableAllButtons;
Begin
  SetAbleToSignNote(False);
  SetAbleToMakeAddendum(False);
  SetAbleToOK(False);
  LbActionDesc.caption := '<select a Progress Note>';
  Rgrp2NoteStatus.Visible := False;
  LbNoteTitle.caption := '<Note Title>';
  lbNoteTitle.Hint :=  LbNoteTitle.caption;
  WinMsg('');
End;

Procedure TfrmCapTIU.SetSignedBtnCaption;
begin
  tbtnSigned.Caption := 'Signed(' + inttostr(FNoteReturnCount) + ')';
end;


Function TfrmCapTIU.Execute(VMagPat: TMag4Pat; Var VClinDataobj: TClinicalData;
  Var VUprefCapTIU: TuprefCapTIU; VEFile: Boolean = False): Boolean;
Var
//  rmsg,s : string;
  Rlist: Tstringlist;
//  rstat : boolean;
Begin

  Rlist := Tstringlist.Create;
  Try
    If Not Doesformexist('frmCapTIU') Then
    Begin
      Application.CreateForm(TfrmCapTIU, FrmCapTIU);
      FrmCapTIU.SetPrefs(VUprefCapTIU);
    End;

    With FrmCapTIU Do
    Begin
      SetPrefs(VUprefCapTIU); {/p117 gek  see if this fixes Upref apply problem.}
          {First If User can not Electronically File a Note
             i.e. Close without Signature, we remove those Status properties}
          {     FCanEFile is set in ApplyEFile, we need this property later.}
      SetSignedBtnCaption;
      ApplyEFile(VEFile);

          {    We set properties from vMagPat, and get Patient Notes}
      InitializePatient(VMagPat);
      MemNewNoteText.Clear;
      MemNewNoteText.Modified := False;
      MemAddNoteText.Clear;
      MemAddNoteText.Modified := False;

      FTIUClinDataObj := VClinDataobj;
          {   If Location DA and NAME are null, set from Upref}
      SetDefaultUserPrefs(VUprefCapTIU);

      GetPersonnalTitleList;
           { window has OnShow event code.}
      If Showmodal = MrOK Then
      Begin
        {NEW 129t18  Get Selected TIUOBject from mlvNotes or mlvUnsigned.}
        {FCurMlv is set whenever mlvNotes or mlvUnSigned is selected)}
        Result := True;
              {     Clear all data from ClinDataObj. Populate with User Selections }
        VClinDataobj.Clear;
        VClinDataobj.Pkg := '8925';
              {     A note has been selected, or a New Title has been selected.
                    If Note, it is Unsigned or Signed
                         If Signed, Create Addendum may have been selected.}
        if FCurMlv <> nil then
        If FCurMlv.Selected <> Nil Then { an Existing Note has been selected.}
        Begin
          MemNewNoteText.Clear; {Clear, New Note Text (if any) to stop mixups.}
          VClinDataobj.ReportData := TMagTIUData.Create;
          VClinDataobj.ReportData.Assign(FrmCapTIU.GetTIUObject(FCurMlv));
          If VClinDataobj.ReportData.Status <> 'completed' Then

          Begin {   Existing Unsigned note is selected}
            MemAddNoteText.Clear;
                      {  Get Status change of Note or No Change. }
            If Rgrp2NoteStatus.ItemIndex = -1 Then Rgrp2NoteStatus.ItemIndex := 0;
            VClinDataobj.NewStatus := Inttostr(FStatusUnSigned);
            VClinDataobj.AttachToUnSigned := True;
          End

          Else
          Begin {      Selected a Signed Note   }
            If FAddendumToSignedNote Then
            Begin {      Signed Note with  Addendum}
              If MemAddNoteText.Lines.Count > 0 Then
              Begin
                VClinDataobj.NewText.Assign(MemAddNoteText.Lines);
                MemAddNoteText.Clear; {closing window, always clear,}
              End;
              VClinDataobj.NewStatus := Inttostr(FStatusAddendum);
              VClinDataobj.NewAddendumNote := VClinDataobj.ReportData.TiuDA;
              VClinDataobj.NewAddendum := True;
            End

            Else
            Begin {       Signed Note, but No Addendum.}
              VClinDataobj.NewStatus := '2'; {2 = signed in frmCapMain}
              VClinDataobj.AttachToSigned := True;
            End;
          End;
          Exit;
        End; { if mlvNotes.Selected <> nil}

        If MlvTitles.Selected <> Nil Then
        Begin
                  { Save text of New Note if there is any.}
          If MemNewNoteText.Lines.Count > 0 Then
          Begin
            VClinDataobj.NewText.Assign(MemNewNoteText.Lines);
          End;
          MemNewNoteText.Clear; {closing window, always clear,}
          MemAddNoteText.Clear; {closing window, always clear,}
          VClinDataobj.NewNote := True;
                 (* if self.FAuthorDuz <> Duz then
                    begin
                    FNewAuthorDUZ := FAuthorDUZ;
                    FNewAuthor := FAuthor;
                    end;
                    *)

          VClinDataobj.NewAuthor := FNewAuthor;
          VClinDataobj.NewAuthorDUZ := FNewAuthorDuz;
          VClinDataobj.NewLocation := FNewlocation;
          VClinDataobj.NewLocationDA := FNewLocationDA;
          VClinDataobj.NewStatus := Inttostr(FStatusNewNote);
          VClinDataobj.NewTitle := FNewTitle;
          VClinDataobj.NewTitleDA := FNewTitleDA;
          VClinDataobj.NewVisit := FVisitstring; // always null for now
          VClinDataobj.NewTitleConsultDA := FNewTitleConsultDA;
          VClinDataobj.NewTitleIsConsult := FNewTitleIsConsult;
          Exit;
        End; {mlvTitles.Selected <> nil }
              { we have mrOK, but nothing Selected. - Shouldn't ever get here.}
        Result := False;
        MagAppMsg('', 'Progress Note is invalid.  No Selection has been made.');
        MagAppMsg('s', 'TIU window was mrOK, but nothing selected.');
      End {   if frmCapTIU.showmodal = mrOK}
      Else
      Begin {   modalresult must be mrCancel}
        Result := False;
      End;
    End; {with frmCapTIU do}
  Finally
    With FrmCapTIU Do {Save preferences.}
    Begin
      VUprefCapTIU.Top := Top;
      VUprefCapTIU.Left := Left;
      VUprefCapTIU.Height := Height;
      VUprefCapTIU.Width := Width;
      VUprefCapTIU.PanelTitleHeight := Pnltitles.Height; // we don't use this.
      VUprefCapTIU.PanelPreviewHeight := PnlPreview.Height;
      VUprefCapTIU.PreviewON := FPreviewNote;           {Here the value is correct}
      VUprefCapTIU.ShowRelatedNotes := FlagToShowAddendums;
      VUprefCapTIU.UseStatusIcons := FUseStatusIcons;
      VUprefCapTIU.UseNoteGlyphs := FUseNoteGlyphs;
     //vUprefCapTIU.DefaultLoc := vCLinDataObj.NewLocationDA + '~' + vClinDataObj.NewLocation ;
      VUprefCapTIU.Listcount := FNoteReturnCount;
      If (Fmthsback < 0) Then VUprefCapTIU.Listmonthsback := Fmthsback;

      //p129 dmmn 12/20/12 - store TIU notes list view column width
      FNoteLVColWidths := MlvNotes.GetColumnWidths;  //p129 duc
      VUprefCapTIU.NoteColumnWidths := MlvNotes.GetColumnWidths(); //p129 duc

     //vuprefCapTiu.listDateFrom := ''; //p59t20  FdtFrom;
     //vuprefCapTiu.listDateTo := ''; //p59t20  FdtTo;
      { Clear Stuff}
      LbNewNoteTitle.caption := '';
      LbNoteTitle.caption := '<Note Title>';
        lbNoteTitle.Hint :=  LbNoteTitle.caption;
      LbActionDesc.caption := '<select a Progress Note>';
    End;
    Rlist.Free;
  End;
End;

Procedure TfrmCapTIU.ApplyEFile(Value: Boolean);
Begin
  FCanEfile := Value;
  If Not Value Then
  Begin
    If Rgrp2NewNoteStatus.Items.Count = 3 Then Rgrp2NewNoteStatus.Items.Delete(2);
    If Rgrp2Addendum.Items.Count = 3 Then Rgrp2Addendum.Items.Delete(2);
    If Rgrp2NoteStatus.Items.Count = 3 Then Rgrp2NoteStatus.Items.Delete(2);
  End
  Else
  Begin
    If Rgrp2NewNoteStatus.Items.Count = 2 Then Rgrp2NewNoteStatus.Items.Add('Electronically Filed.');
    If Rgrp2Addendum.Items.Count = 2 Then Rgrp2Addendum.Items.Add('Electronically Filed.');
    If Rgrp2NoteStatus.Items.Count = 2 Then Rgrp2NoteStatus.Items.Add('Electronically Filed.');
  End;
End;

Procedure TfrmCapTIU.SetUseStatusIcons(Value: Boolean);
Begin
  FUseStatusIcons := Value;
  If Value Then
    MlvNotes.SmallImages := Imglst16w
  Else
    MlvNotes.SmallImages := Nil;

End;

Procedure TfrmCapTIU.SetDefaultUserPrefs(VUprefCapTIU: TuprefCapTIU);
Begin
  //SetPreviewNote(vUprefCapTIU.PreviewON);
 // SetUseStatusIcons(vUprefCapTIU.UseStatusIcons);

 {  Not doing this default anymore, it is determined before we get here.}

 (*
  if (FTIUClinDataObj.NewLocation = '') and (vUPrefCapTiu.DefaultLoc <> '')
      then
      begin
      FTIUClinDataObj.NewLocation := vUPrefCapTiu.DefaultLocName;
      FTIUClinDataObj.NewLocationDA := vUPrefCapTiu.DefaultLocDA;
      end;
 *)
End;

Procedure TfrmCapTIU.SetPrefs(VUprefCapTIU: TuprefCapTIU);
Begin
  {     first, do we have any values in this user preference object.
        if not, then just quit. {}
  If VUprefCapTIU.Height = 0 Then Exit;
  If VUprefCapTIU.Width = 0 Then Exit;
  Top := VUprefCapTIU.Top;
  Left := VUprefCapTIU.Left;
  PnlPreview.Height := VUprefCapTIU.PanelPreviewHeight;
  If PnlPreview.Height < 10 Then PnlPreview.Height := 100;
  PnlNewText.Height := PnlPreview.Height;
  Height := VUprefCapTIU.Height;
  Width := VUprefCapTIU.Width;
  If Top > Screen.Height Then Top := Screen.Height - 600;
  If Left > Screen.Width Then Left := Screen.Width - 600;
  If Top < 0 Then Top := 0;
  If Left < 0 Then Left := 0;

  FlagToShowAddendums := VUprefCapTIU.ShowRelatedNotes;
  FUseStatusIcons := VUprefCapTIU.UseStatusIcons;
  FUseNoteGlyphs := VUprefCapTIU.UseNoteGlyphs;
  MnuShowAddendums.Checked := FlagToShowAddendums;   /// will this force the menuSelect Event ?
  FNoteReturnCount := VUprefCapTIU.Listcount;
  if (FNoteReturnCount > 100)  then  FNoteReturnCount := 100;

  
  Fmthsback := VUprefCapTIU.Listmonthsback;
  FdtFrom := ''; //p59t20  vuprefCapTiu.listDateFrom;
  FdtTo := ''; //p59t20  vuprefCapTiu.listDateTo;

  SetPreviewNote(VUprefCapTIU.PreviewON);
  SetUseStatusIcons(VUprefCapTIU.UseStatusIcons);
//  SetDefaultUserPrefs(vuprefCapTiu);  //today here , from below (in what called here)


  //p129 dmmn
  FNoteLVColWidths := VUprefCapTIU.NoteColumnWidths;
  FUseNoteColWidthPref := true;
End;

Procedure TfrmCapTIU.MnuFitToWindowClick(Sender: Tobject);
Begin
  If PnlNotes.Visible Then
    begin
    MlvNotes.FitColumnsToForm ;
    if MlvUnsigned.Visible  then MlvUnsigned.FitColumnsToForm;

    end
  Else
    begin
    MlvTitles.FitColumnsToForm;
    end;
End;

Procedure TfrmCapTIU.FontDialog1Apply(Sender: Tobject; Wnd: Hwnd);
Begin
  ModalResult := MrOK;
End;

Procedure TfrmCapTIU.FormCreate(Sender: Tobject);
Begin
FUpcount := 1;
{seperate TMagListview to store Addendums .  Addendums will be inserted into
            MlvNotes when user clicks menu options ' Show Related Notes Addendums'}
Row0HeadersSigned := 'Title  (Signed Notes) ^Date~S1^Status^Author^# Img~S2';
Row0HeadersUnSigned := 'Title  (Unsigned,UnCoSigned) ^Date~S1^Status^Author^# Img~S2';
if FCapDevTest then
  begin
   Row0HeadersSigned := 'Title  (Signed Notes) ^Date~S1^Status^Author^# Img~S2^TiuDA~S2^ParentDA~S2';
   Row0HeadersUnSigned := 'Title  (Unsigned,UnCoSigned) ^Date~S1^Status^Author^# Img~S2^TiuDA~S2^ParentDA~S2';
  end;


FilePreInc := 0;
MagAddnd:= TMaglistview.Create(self);
MagAddnd.Parent := self;
MagAddnd.visible := false;

FCurMlv := nil;


FLastItem := nil;
    InitializeDatesFlagsForMore;
    FBaseNoteList := Tstringlist.create;
  FtstringsMyList := Tstringlist.Create;
  FtstringsStartList := Tstringlist.Create;
  FtstringsEndList := Tstringlist.Create;
  MemNewNoteText.Align := alClient;
  FClick := 3;
/////129t17  FshowAddendums := True;
  FTIUClinDataObj := Nil;
  FNoteReturnCount := 100;
  FNoteTypes := [MagntSigned];
  Fmthsback := -99;
  Ftypeoflist := 1;
  GetFormPosition(Self As TForm);
  FeSignTrys := 0;
  FTitleIEN := Tstringlist.Create;
    { if no author has been selected, default to user }
  FDefaultheight := Height;
//RCA     MagImageList1.MagDBBroker := idmodobj.GetMagDBBroker1;
//RCA     Mag4Viewer1.MagImageList := MagImageList1;
//RCA     Mag4Viewer1.MagSecurity := idmodobj.GetMagFileSecurity;
//RCA     Mag4Viewer1.MagUtilsDB := idmodobj.GetMagUtilsDB1;
  PageControl.Align := alClient;
  MemNoteText.Align := alClient;
  Pnltitles.Align := alClient;
  FStatusUnSigned := 0; //unsigned;
  FStatusAddendum := 0; //unsigned;
  FStatusNewNote := 0; //unsigned;

  MlvNotes.SetColumnZeroWidth(-1);
  MlvAuthor.SetColumnZeroWidth(-1);
  MlvTitles.SetColumnZeroWidth(-1);
  MlvLoc.SetColumnZeroWidth(-1);

End;

procedure TfrmCapTIU.EnableMoreButton(value :boolean; count : integer = 50);
begin
    tbtnMore.enabled := value;
end;

Procedure TfrmCapTIU.FormDestroy(Sender: Tobject);
Begin
  SaveFormPosition(Self As TForm);
  FTitleIEN.Free;
  FtstringsMyList.Free;
  FtstringsStartList.Free;
  FtstringsEndList.Free;
  FBaseNoteList.Free;
//  MagAddnd.Free;
End;

Procedure TfrmCapTIU.FormShow(Sender: Tobject);
Begin
  SetDefaults;
End;

Procedure TfrmCapTIU.SetDefaults;
Var
  Li: TListItem;
  Vtiuda: String;
  //i : integer;
  TiuObj: TMagTIUData;
  Rlist: TStrings;
   {Nested in procedure TfrmCapTIU.SetDefaults;}

  Procedure SetDefaultAuthor; {Nested in procedure TfrmCapTIU.SetDefaults;}
  Begin
    If FTIUClinDataObj.NewAuthorDUZ = '' Then
    Begin
      FNewAuthorDuz := UserCapDUZ;
      FNewAuthor := UserCapname;
    End
    Else
    Begin
      FNewAuthorDuz := FTIUClinDataObj.NewAuthorDUZ;
      FNewAuthor := FTIUClinDataObj.NewAuthor;
    End;
    EdtAuthor.Text := FNewAuthor;
  End;
   {  Nested in procedure TfrmCapTIU.SetDefaults; }

  Procedure SetDefaultLocation; {Nested in procedure TfrmCapTIU.SetDefaults;}
  Begin
   // No conditional anymore.  It can be '' comming in.
   //if FTIUClinDataOBj.NewLocationDA <> '' then
    Begin
        {Only if location isn't null we set it.  We don't want to overwrite
         userprefernece with ''}
      FNewLocationDA := FTIUClinDataObj.NewLocationDA;
      FNewlocation := FTIUClinDataObj.NewLocation;
    End;
    EdtLoc.Text := FNewlocation;
  End;
   {  Nested in procedure TfrmCapTIU.SetDefaults; }

  Procedure SetSelectedTitle; {Nested in procedure TfrmCapTIU.SetDefaults;}
  Begin
    Li := MlvTitles.FindCaption(0, FTIUClinDataObj.NewTitle, False, True, True);
    If Li <> Nil Then
    Begin
      MlvTitles.Selected := Li;
      Li.MakeVisible(False);
    End
    Else
    Begin
      Try
        EdtTitle.Text := FTIUClinDataObj.NewTitle;
           //FMyList := false;
           //SyncListButtons;
        Rlist := GetTitlesFromVista(Copy(EdtTitle.Text, 1, Length(EdtTitle.Text) - 1), 1);
        If Rlist = Nil Then Exit;
        MlvTitles.LoadListFromStrings(Rlist);
        Li := MlvTitles.FindCaption(0, FTIUClinDataObj.NewTitle, False, True, True);
        If Li <> Nil Then
        Begin
                     { }
          MlvTitles.Selected := Li;
          Li.MakeVisible(False);
        End;
      Finally
        Rlist.Free;
      End;
    End;
  End;
   {  Nested in procedure TfrmCapTIU.SetDefaults; }

  Procedure SetNewStatus; {Nested in procedure TfrmCapTIU.SetDefaults;}
  Begin
    If FTIUClinDataObj.NewStatus <> '' Then
      Rgrp2NewNoteStatus.ItemIndex := ConvertStatus(Strtoint(FTIUClinDataObj.NewStatus))
    Else
      Rgrp2NewNoteStatus.ItemIndex := 0; //default to Unsigned.
  End;
   {  Nested in procedure TfrmCapTIU.SetDefaults; }

  Procedure SetNewText; {Nested in procedure TfrmCapTIU.SetDefaults;}
  Begin
       {  on the Startup, if we had text, in the vClinDataobj we will put it back.}
    If FTIUClinDataObj.NewText.Count > 0 Then
    Begin
      MemNewNoteText.Clear; {This is in SetDefaults.}
      MemNewNoteText.Lines.AddStrings(FTIUClinDataObj.NewText);
    End;
  End;
   {  Nested in procedure TfrmCapTIU.SetDefaults; }

  Procedure SetNoteStatus; {Nested in procedure TfrmCapTIU.SetDefaults;}
  Begin
    SetAbleToMakeAddendum(False);
    If (FTIUClinDataObj.ReportData.Status = '') Or (FTIUClinDataObj.ReportData.TiuDA = '') Then Exit;
    If FTIUClinDataObj.ReportData.Status = 'completed' Then
    Begin
      SetAbleToMakeAddendum(True);
      SetSigned(True);
      SetAreMakingAddendum(FTIUClinDataObj.NewAddendum);
    End
    Else
    Begin { stats <> 'complete'}
      If FTIUClinDataObj.NewStatus <> '' Then
        Rgrp2NoteStatus.ItemIndex := ConvertStatus(Strtoint(FTIUClinDataObj.NewStatus))
      Else
        Rgrp2NoteStatus.ItemIndex := 0;
      SetAbleToMakeAddendum(False);
      SetSigned(False);
      //uns// FNoteTypes := [MagntUnSigned, MagntUnCoSigned];
    End;
  End;
   {  Nested in procedure TfrmCapTIU.SetDefaults; }

  Procedure SetSelectedNote; {Nested in procedure TfrmCapTIU.SetDefaults;}
  Var
    i: Integer;
  Begin
    Vtiuda := FTIUClinDataObj.ReportData.TiuDA;
    If Vtiuda = '' Then Exit;
    For i := 0 To MlvNotes.Items.Count - 1 Do
    Begin
      Li := MlvNotes.Items[i];
      TiuObj := Li.Data;
      If TiuObj.TiuDA = Vtiuda Then
      Begin
        MlvNotes.Selected := Li;
        Li.MakeVisible(False);
           {So here, we are back in with a previous Selected
           Note, Lets put back the text if there was any.
           }
        If FTIUClinDataObj.NewAddendum Then
        Begin
          SetAbleToMakeAddendum(True);
          SetAreMakingAddendum(True);  { TODO : 129t17 addendums }

          If FTIUClinDataObj.NewText.Count > 0 Then
          Begin
                   //CopyToClip(memAddNoteText);
            MemAddNoteText.Clear;
            MemAddNoteText.Lines.AddStrings(FTIUClinDataObj.NewText);
          End;
          If FTIUClinDataObj.NewStatus <> '' Then
            Rgrp2Addendum.ItemIndex := ConvertStatus(Strtoint(FTIUClinDataObj.NewStatus))
          Else
            Rgrp2Addendum.ItemIndex := 0;

        End;
      End;
    End;
  End;
{  ****      -----------------------------------------                ****
          **** beginning of procedure TfrmCapTIU.SetDefaults; ****
   ****      -----------------------------------------                ****}
Begin
  If FTIUClinDataObj = Nil Then Exit;
  SetDefaultAuthor;
  SetDefaultLocation;
  If FTIUClinDataObj.NewNote Then
  Begin 
    ChangeState(NwsNew);
    SetSelectedTitle;
    SetNewStatus;
    If EdtAuthor.Text = '' Then
      EdtAuthor.SetFocus
    Else
      If EdtLoc.Text = '' Then
        EdtLoc.SetFocus
      Else
        EdtTitle.SetFocus;
    SetNewText;
  End {(nwsNew)}
  Else
  Begin 
    ChangeState(NwsList);
    If FTIUClinDataObj.ReportData <> Nil Then
      SetNoteStatus
    Else
   //uns//   If FTIUClinDataObj.NewStatus = '0' Then FNoteTypes := FNoteTypes + [MagntUnSigned, MagntUnCoSigned];
    If FNoteTypes = [] Then SetSigned(True); {Get List of Signed Notes by default}
    If FTIUClinDataObj.AttachToSigned Then
       begin
       FNoteTypes :=  [MagntSigned];
       InitializeDatesFlagsForMore;
       NotesByContext;
       end;
    If FTIUClinDataObj.AttachToUnSigned Then
       begin
         ShowUnSigned(true);
         notesByContextUnsigned;
       end;



    if FNoteLVColWidths = '' then  // duc p129
    begin
    MlvNotes.FitColumnsToText;
    if mlvUnsigned.Visible then mlvUnsigned.FitColumnsToText;

    If ((MlvNotes.Items.Count > 1) And (Not Ffitoncetotext)) Then
      Begin
        MlvNotes.FitColumnsToText;
        Ffitoncetotext := True;
      End;

    If ((MlvUnsigned.Items.Count > 1) And (Not FfitUnSignedoncetotext)) Then
      Begin
        MlvUnsigned.FitColumnsToText;
        FfitUnSignedoncetotext := True;
      End;




    end;

    If FTIUClinDataObj.ReportData <> Nil Then SetSelectedNote;
  End;
  // ? call notes by context if List count = 0 ?
  if (mlvNotes.Items.Count = 0) then
     begin
      GetSignedNotes(true);
     end;
End;


Function TfrmCapTIU.ConvertStatus(Value: Integer): Integer;
Begin
  If (Not FCanEfile) And (Value = 1) Then Value := 0;
  Case Value Of
    -1: Result := -1; {No status}
    0: Result := 0; {UnSigned}
    1: Result := 2; {Electronically Files (old Admin Closure) }
    2: Result := 1; {Signed}
  End;
End;

Function TfrmCapTIU.GetTIUObject(mlv :Tmaglistview; li : Tlistitem = nil):  TMagTIUData;
Begin
  Result := Nil;
  if (li = nil) then Li := mlv.Selected;
  If Li = Nil Then
  Begin
    SetAbleToOK(False);
    Exit;
  End;
  If Not btnOK.Enabled Then SetAbleToOK(True);
  Result := Li.Data;
  If (Result.TiuDA = '0') Then
  Begin
    MagAppMsg('de', 'Corrupt Progress Note entry');
    SetAbleToOK(False);
    mlv.Selected := Nil;
    Exit;
  End;
End;

Procedure TfrmCapTIU.InitializePatient(xMagPat: TMag4Pat);
Begin
  If FDFN <> xMagPat.M_DFN Then
  Begin
    FDFN := xMagPat.M_DFN;
    FPatient := xMagPat.M_NameDisplay;
    ClearTheList;
    DisableAllButtons;
  End
  else
    begin
     {Patient is same...  refresh if needed.}
      {p129t18...   if same patient,  we will refresh list.  because New Notes And
             Addendums wern't being seen. }

     if (TbtnSigned.Down) then RefreshNotesListing;

     if (TbtnUnSigned.Down) or (tbtnUnCosigned.Down) then  NotesByContextUnsigned;


    end;
   //NotesByContext;
  caption := 'Progress Notes : ' + xMagPat.M_NameDisplay;
End;

Procedure TfrmCapTIU.ListView1DblClick(Sender: Tobject);
Begin
  ModalResult := MrOK;
End;

Function TfrmCapTIU.LookupAuthor: Boolean;
Var
  Return: String;
  Authorx: String;
Begin
  Authorx := MagPiece(FAuthor, ' ', 1);
  If SearchVistAFile('200', ' Author ', ' Enter a few characters of the Last Name then Press Enter.', 'Search for Author : ', '', False, Return) Then
  Begin
    SetAuthor(MagPiece(Return, '^', 1), MagPiece(Return, '^', 2));
    Result := True;
  End
  Else
  Begin
    WinMsg(Return);
    Result := False;
  End;
End;

Procedure TfrmCapTIU.MlvGenericDblClick(Sender: Tobject);
Begin
   FCurMlv := (Sender as TMagListView);
  UnSelectOtherListItem;
  MlvTitles.Selected := Nil;
  ModalResult := MrOK;
End;

Procedure TfrmCapTIU.MlvGenericSelectItem(Sender: Tobject; Item: TListItem; Selected: Boolean);
Var
  TiuObj: TMagTIUData;
  datastring : string;
Begin
  If Not Selected Then
  Begin
    ClearPreview;
    Exit;
  End;
  FCurMlv := (Sender as TMagListView);
  UnSelectOtherListItem;
  TiuObj := GetTIUObject(FCurMlv);
  If (TiuObj = Nil) Or (TiuObj.TiuDA = '0') Then Exit;
        {       Show selected Note Title on window.}
  LbNoteTitle.caption := TiuObj.Title;
    lbNoteTitle.Hint :=  LbNoteTitle.caption;
  If FPreviewNote Or FPreviewImages Then
  Begin
    If FPreviewNote Then PreviewSelectedNote;
    If FPreviewImages Then PreviewImagesForNote(TiuObj);
  End;

{P129T17 GEK - IsAddendum is now determined when the list is loaded.}
            {  Function TMagDBMVista.RPGetTIUData(TiuDA: String; Var TiuPTR: String): Boolean;}
            //if idmodobj.GetMagDBBroker1.RPGetTIUData(TIUobj.TiuDA,datastring)
            //         then
            //         begin
            //         TiuObj.IsAddendum := MagStrToBool(MagPiece(datastring, '^', 8));
            //         end;
  If TiuObj.Status = 'completed' Then
    ChangeState(NwsComplete,tiuobj)  {gek  Send whole tiuObj object, may need other data in future.}
  Else
    ChangeState(NwsUnsigned);
End;

Procedure TfrmCapTIU.Showtabbingseq;
Var
  Tl: Tlist;
  i: Integer;
  Smsg: String;
  Nextctrlok: Boolean;
  Edt: TWinControl;
Begin
  Edt := EdtAuthor;
  {     FindNextControl(edt, true, true, true).setfocus; {}
  Tl := Tlist.Create;
  Smsg := '';
  Try
    PnlListNotes.GetTabOrderList(Tl);
    For i := 0 To Tl.Count - 1 Do
      Smsg := Smsg + (TWinControl(Tl[i]).Name) + #13;
    MemNoteText.Lines.Add(Smsg);
    Exit;
    i := Tl.Indexof(Edt);
    Nextctrlok := False;
    While Not Nextctrlok Do
    Begin
      i := i + 1;
      If (i > (Tl.Count - 1)) Then Break; { don't want to go around}
             //maggmsgf.MagMsg('',TWincontrol(tl[i]).name);
      MagAppMsg('', TWinControl(Tl[i]).Name); 
      If TWinControl(Tl[i]).Enabled
        And TWinControl(Tl[i]).Visible
        And TWinControl(Tl[i]).TabStop Then
      Begin
        Nextctrlok := True;
        TWinControl(Tl[i]).SetFocus;
      End;
    End;
  Finally
    Tl.Free;
  End;
End;

Procedure TfrmCapTIU.MlvTitlesDblClick(Sender: Tobject);
Begin
  SaveAndClose;
End;

Procedure TfrmCapTIU.MlvTitlesSelectItem(Sender: Tobject; Item: TListItem;
  Selected: Boolean);
Var
  Li: TListItem;
  TmpNewTitleDA: String;
  TmpNewTitle: String;
  Rstat: Boolean;
  Rmsg: String;
  t: Tstringlist;
//  vConsDA : string;
Begin
  {       Initialize New Note}
  FNewTitle := '';
  FNewTitleDA := '';
  FNewTitleIsConsult := False;
  FNewTitleConsultDA := '';
  WinMsg('');
  ClearPreview;
  //DisableAllButtons;
  If MlvTitles.Selected = Nil Then
  Begin

    FUseBoilerPlate := False;
    Exit;
  End;

  Li := MlvTitles.Selected;
  EdtTitle.Text := Li.caption;

  TmpNewTitleDA := TMagListViewData(Li.Data).Data;
  If Li.SubItems[0] = '' Then
    TmpNewTitle := Li.caption
  Else
    TmpNewTitle := Li.SubItems[0];
  TmpNewTitle := Trim(TmpNewTitle);
  TmpNewTitle := StringReplace(TmpNewTitle, '<', '', [RfReplaceAll]);
  TmpNewTitle := StringReplace(TmpNewTitle, '>', '', [RfReplaceAll]);

  t := Tstringlist.Create;
  {     Here So we may have NewTitleIsConsult, and NewTitleConsultDA}

        {If User hasn't entered any text, we erase any that is in there, i.e.
           BoilerPlate text from a previous selected Title}
  If Not MemNewNoteText.Modified Then
    If MemNewNoteText.Lines.Count > 0 Then MemNewNoteText.Lines.Clear;
  If MemNoteText.Modified Then
    If MemNewNoteText.Lines.Count = 0 Then MemNewNoteText.Modified := False;

  If MemNewNoteText.Modified Then
    If Messagedlg('Text for the Previous Title had been modified.' + #13 + 'Erase Changes ? ', Mtconfirmation, [MbYes, MbNo], 0) = MrYes Then
    Begin
      MemNewNoteText.Clear;
      MemNewNoteText.Modified := False;
    End;

  idmodobj.GetMagDBBroker1.RPTIULoadBoilerplateText(Rstat, Rmsg, t, TmpNewTitleDA, FDFN);
  If Rstat Then
  Begin
    If MemNewNoteText.Lines.Count > 0 Then
    Begin
      If Messagedlg('Add BoilerPlate Text for ' + TmpNewTitle + ' ?', Mtconfirmation, [MbYes, MbNo], 0) = MrYes Then
      Begin
        MemNewNoteText.Lines.Add('-------------------------------------');
        MemNewNoteText.Lines.AddStrings(t)
      End;
    End
    Else
    Begin
      MemNewNoteText.Lines.AddStrings(t);
      MemNewNoteText.Modified := False;
    End;
  End;

  SetAbleToOK(True);
  FNewTitleDA := TmpNewTitleDA;
  FNewTitle := TmpNewTitle;
  LbNewNoteTitle.caption := FNewTitle;
  EdtTitle.SelectAll;
End;

(*procedure TfrmCapTIU.CopyToClip(mem : Tmemo);
begin
mem.SelectAll;
mem.CopyToClipboard;
end;
 *)

Procedure TfrmCapTIU.MnuAuthorClick(Sender: Tobject);
Begin
  ToggleAuthorSearch;
End;

Procedure TfrmCapTIU.MnuClearAuthorClick(Sender: Tobject);
Begin
  FAuthor := '';
  FAuthorDuz := '';
End;

Procedure TfrmCapTIU.MnuExitClick(Sender: Tobject);
Begin
  ModalResult := MrCancel;
End;

Procedure TfrmCapTIU.MnuFontClick(Sender: Tobject);
Begin
  FontDialog1.Font := Font;
  If FontDialog1.Execute Then
  Begin
    Font := FontDialog1.Font;
    ResizeColumns;
  End;
End;

procedure TfrmCapTIU.mnuHelpClick(Sender: TObject);
begin
mnuTest.Visible := FCapDevTest;

end;

Procedure TfrmCapTIU.MnuHelpSelectProgressNoteClick(Sender: Tobject);
Begin
  Application.HelpContext(10156);
End;

Procedure TfrmCapTIU.MnuMineClick(Sender: Tobject);
Begin
  MnuMine.Checked := Not MnuMine.Checked;
  SetMine(MnuMine.Checked);
      InitializeDatesFlagsForMore;
  NotesByContext;
End;

Procedure TfrmCapTIU.MnuNewNoteClick(Sender: Tobject);
Begin
  ChangeState(NwsNew);
End;

Procedure TfrmCapTIU.MnuPreviewNoteClick(Sender: Tobject);
Begin
  MnuPreviewNote.Checked := Not MnuPreviewNote.Checked;
  SetPreviewNote(MnuPreviewNote.Checked);
End;

Procedure TfrmCapTIU.MnuRefresh2Click(Sender: Tobject);
Begin
    InitializeDatesFlagsForMore;
  NotesByContext;
End;

Procedure TfrmCapTIU.ShowHideAddendums;
 var tBase : tstringlist;
 ctSigned,ctUnSigned,ctUnCosigned , ctAddendum : integer;
begin
try
tbase := Tstringlist.create;
 tBase.Assign(FBaseNoteList);
 //////////////   tBase.Insert(0,Row0Headers);
    {  129t17  HERE HERE.   now the Notes Listing will have Addendums in it.
      when user Selectes or Unselects  Show Related Notes/Addendums, then we will show or not show the Addendums.
      we won't have to make the call to get the new list, and won't have to start from first 100,  then next... etc.
      if current list has 400,  we'll show all addendums related to those 400      }
    ReWorkTheNoteListing(tBase, mlvNotes);

    GetSetStatusCounts(tBase,ctSigned,ctUnSigned,ctUnCosigned, ctAddendum);

   {for now, don't worry about scroll to an item}
   { if ScrolltoItem > -1  then
       begin
         MlvNotes.Selected := MlvNotes.items[scrollToItem];
         FLastItem := MlvNotes.Selected ;
         mlvNotes.ScrollToItem(FlastItem);
       end;
    }
    ShowStatus(0, Inttostr(MlvNotes.Items.Count) + ' Notes');
    SetStatusBarListOptions;

    //  BringtotheTOPtheSelectedNoteFromBefore;


  //old   If ((MlvNotes.Items.Count > 0) And (Not Ffitoncetotext)) Then
  // p129 below. duc.
  If ((MlvNotes.Items.Count > 0) And (Not Ffitoncetotext) And (FNoteLVColWidths = '')) Then
    Begin
      MlvNotes.FitColumnsToText;
      Ffitoncetotext := True;
    End;
  Finally
    FAreAddingToNotesListing  := false;
    //t.Free;
    tBase.Free;
  End;
End;



Procedure TfrmCapTIU.NotesByContext;
Var
  tIncResults: Tstringlist;   {results of Each individual RPC Call made in this function.  these incremental Results are
                                merged into the tNewResults list.}
  tNewResults : Tstringlist;  {all results from all RPC calls made .  Multiple RPC Calls can be made depending on which
                               options selected by the user. }
  s: String;
  Li: TListItem;
  GetAddendums : integer; {This is always '1' now.   Variable used for Clarity of RPC Parameter}
  SelectedTIUDA: String;

  TiuObj: TMagTIUData;
  VContext : Integer;
  TempMonthsBack: Integer;
  signedCount : integer;
  ctSigned,ctUnSigned,ctUnCosigned,ctAddendum  : integer;
  scrollToItem : integer;
testdir : string;
Begin

ctAuth := 0;
DidUseAuthorSearch := false;
scrolltoitem := -1;
signedcount := 0;

  If (FdtFrom <> '') And (FdtTo <> '') Then
  Begin
    TempMonthsBack := 0;
  End
  Else
  Begin
    FdtFrom := '';   FInitialFROMDate := '';
    FdtTo := '';     FInitialTODate := '';
    If Fmthsback = 0 Then Fmthsback := -24;
    TempMonthsBack := Fmthsback;
  End;
 //pre 129 if FNoteTypes = [] then FnoteTypes := [magntSigned];
  GetAddendums := 1;   //129t17  always get Addendums.     Showaddendum := MagBoolToInt(FshowAddendums);
  ClearPreview;
   ShowStatus(-1, '');  {clear statusBar panels.}
  WinMsg('');
  tIncResults := Tstringlist.Create;
  tNewResults := Tstringlist.Create;

  Li := MlvNotes.Selected;
  If Li <> Nil Then
  Begin
    TiuObj := Li.Data;
       { Keep the selected note, and reselect it when new list is loaded.}
    SelectedTIUDA := TiuObj.TiuDA;
  End;
   {    TMagNoteTypes = Set Of (MagntSigned, MagntUnSigned, MagntUnCoSigned, MagntMine);}
   {    depending on which types of notes are selected, either by user or progrmatically, we will synchronize the 'Check' buttons }
  SyncButtonsToNoteTypes(FNoteTypes);
   {    for now only using other author when Signed notes by author.{}
  {Okay, p129t17  We always get Addendums,  but then decide to show or not, based on FlagToShowAddendums.}
  Try
    If FUseAuthorSearch Then
    {This can only be 'Signed Notes by Author' }
    Begin
      idmodobj.GetMagDBBroker1.RPGetNotesByContext(FDFN, tIncResults, 4, FAuthorDuz, Inttostr(FNoteReturnCount), 3, 'D', GetAddendums, 0, TempMonthsBack, FdtFrom, FdtTo);
      ctAuth := tIncResults.Count;
      tNewResults.assign(tIncResults);
      FUseAuthorSearch := False;
      DidUseAuthorSearch := true;
        {VeHU : put count of authors Note, in seperate}
      s := s + Inttostr(tIncResults.Count) + '-' + FAuthor + '(' + Inttostr(ctAuth) + ')' + '.';
      ShowStatus(1, Inttostr(tIncResults.Count) + ' - ' + FAuthor + '(' + Inttostr(ctAuth) + ')' + '.');
      //??  Should we Quit here...  129t17
    End;

    if Not DidUseAuthorSearch then
    If MagntMine In FNoteTypes Then
    Begin
      idmodobj.GetMagDBBroker1.RPGetNotesByContext(FDFN, tIncResults, 4, UserCapDUZ, Inttostr(FNoteReturnCount), 3, 'D', GetAddendums, 0, TempMonthsBack, FdtFrom, FdtTo);
      tNewResults.Assign(tIncResults);
      ShowStatus(1, Inttostr(tIncResults.Count) + ' - ' + UserCapname + '.');
      //??   shouuld we Quit Here 129t17
    End;

    if Not DidUseAuthorSearch then
    If MagntSigned In FNoteTypes Then
    Begin
        {      CONTEXT  - 1=All Signed (by PT),
 ;               - 2="Unsigned (by PT&(AUTHOR!TANSCRIBER))
 ;               - 3="Uncosigned (by PT&EXPECTED COSIGNER
 ;               - 4="Signed notes (by PT&selected author)
 ;               - 5="Signed notes (by PT&date range)
        }
        //if (FmthsBack < 0) or (Fdtfrom <> '')
      If (FdtFrom <> '') Or (Fmthsback > -99) Then
        VContext := 5
      Else
        VContext := 1;
        //if FmthsBack = -99 then vContext := 1;  { -99 special case of Months Back (All) }

      {the '0' as 9th param is the OCClimit.  only used on CONTEXT of 1 or 5 in TIU.  but the Get 44 MORE capability
        is not in the TIU RPC Call. }
      idmodobj.GetMagDBBroker1.RPGetNotesByContext(FDFN, tIncResults, VContext, UserCapDuz, Inttostr(FNoteReturnCount), 3, 'D', GetAddendums, 0, TempMonthsBack, FdtFrom, FdtTo);
      tNewResults.Assign(tIncResults);
      // NEed to keep signed count.. to add to NEXT...
      signedCount := tIncResults.count;
      If VContext = 5 Then s := s + '  ' + Inttostr(signedCount) + '-' + 'Signed' + '.';
      s := s + '   ' + Inttostr(signedCount) + '-' + 'Signed Notes' + '.';
      ShowStatus(1, Inttostr(signedCount) + ' - ' + 'Signed Notes' + '.');
    End;
     if Not DidUseAuthorSearch then
    If MagntUnSigned In FNoteTypes Then
    Begin
      idmodobj.GetMagDBBroker1.RPGetNotesByContext(FDFN, tIncResults, 2, UserCapDuz, Inttostr(FNoteReturnCount), 3, 'D', GetAddendums, 0, -99, '', ''); //Fmthsback,FdtFrom,FdtTo);
      tNewResults.AddStrings(tIncResults);
      s := s + '   ' + Inttostr(tIncResults.Count) + '-' + 'Unsigned.';
      ShowStatus(2, Inttostr(tIncResults.Count) + ' - ' + 'Unsigned.');
    End;
     if Not DidUseAuthorSearch then
    If MagntUnCoSigned In FNoteTypes Then
    Begin
      idmodobj.GetMagDBBroker1.RPGetNotesByContext(FDFN, tIncResults, 3, UserCapDuz, Inttostr(FNoteReturnCount), 3, 'D', GetAddendums, 0, -99, '', ''); //Fmthsback,FdtFrom,FdtTo);
      tNewResults.AddStrings(tIncResults);
      s := s + '   ' + Inttostr(tIncResults.Count) + '-' + 'Uncosigned.';
      ShowStatus(3, Inttostr(tIncResults.Count) + ' - ' + 'Uncosigned.');
    End;

    {  ****  129 t15,t17  *********************
      if we have an Existing List that we add to, then
           add to it, and use the combined list. then  Rework it for display }


    self.EnableMoreButton((signedcount >= FNoteReturnCount),FNoteReturnCount);
    SetAbleToMakeAddendum(false);

    if  FAreAddingToNotesListing  then
      begin
        scrollToItem := mlvNotes.items.count-1;
        FBaseNoteList.AddStrings(tNewResults);
      end
      else
      begin
         {if we're not 'Adding to the Notes Listing'  then we need to set the Base with the first 100
           so if User wants to Add to it,  we have it. }
         FBaseNoteList.Clear;
         FBaseNoteList.assign(tNewResults);

      end;

    {   Patch 129t16   We need to be sure that the same TIUDA isn't listed twice. }



    //**************   TEST TEST TESTING  ************************
    if FCapDevTest then
       begin
        testdir := 'c:\temp\captest';
        if not DirectoryExists(testdir)  then
             begin
              forcedirectories(testdir);
              magappmsg('d','Directory for Testing Created : ' + testdir);
             end;
        inc(filePreInc);
        tNewResults.Insert(0,'From Date: ' + FdtFrom) ;
        tNewResults.savetofile(testdir + '\'+inttostr(filepreinc)+'.1-AtNewResults.txt');

        
        FBaseNoteList.savetofile('c:\temp\CapTest\'+inttostr(filepreinc)+'.2-FBaseNoteListFull.txt');
       end;
    //**************   TEST TEST TESTING  ************************

    ClearDuplicates(FBaseNoteList);   // in for A1

    //**************   TEST TEST TESTING  ************************
    IF FCapDevTest then
         FBaseNoteList.savetofile('c:\temp\CapTest\'+inttostr(filepreinc)+'.3-FBaseNoteListFullNoDupes.txt');
    //**************   TEST TEST TESTING  ************************

    tNewResults.assign(FBaseNoteList);  // in for A1 out

 ///////////////////////  tNewResults.Insert(0,Row0Headers );
    {  129t17  HERE HERE.   now the Notes Listing will have Addendums in it.
      when user Selectes or Unselects  Show Related Notes/Addendums, then we will show or not show the Addendums.
      we won't have to make the call to get the new list, and won't have to start from first 100,  then next... etc.
      if current list has 400,  we'll show all addendums related to those 400      }
    ReWorkTheNoteListing(tNewResults, mlvNotes);

    //**************   TEST TEST TESTING  ************************
    if FCapDevTest then
        tNewResults.savetofile('c:\temp\CapTest\'+inttostr(filepreinc)+'.7-FBaseNoteListTNewReworked.txt');
    //**************   TEST TEST TESTING  ************************

    GetSetStatusCounts(tNewResults,ctSigned,ctUnSigned,ctUnCosigned,ctAddendum);
    if ScrolltoItem > -1  then
       begin
         // NO NO  do not Select an Entry //// out for good. MlvNotes.Selected := MlvNotes.items[scrollToItem];
         scrolltoitem := scrolltoitem + mlvNotes.VisibleRowCount - FupCount ; // new.
         if (scrolltoitem > (mlvNotes.Items.Count-1)) then scrolltoitem := mlvNotes.Items.Count-1;  //new
         Flastitem := mlvNotes.Items[scrolltoitem  ]; // new
         //out for new in //FLastItem := MlvNotes.Selected ;
         mlvNotes.ScrollToItem(FlastItem);
// TopItem is Readonly         mlvNotes.TopItem := FlastItem;


       end;
    ShowStatus(0, Inttostr(MlvNotes.Items.Count) + ' Notes');
    SetStatusBarListOptions;

//  BringtotheTOPtheSelectedNoteFromBefore;


 //old   If ((MlvNotes.Items.Count > 0) And (Not Ffitoncetotext)) Then
// p129 below. duc.
  If ((MlvNotes.Items.Count > 0) And (Not Ffitoncetotext)) Then
    Begin
      if (FNoteLVColWidths = '')
      then MlvNotes.FitColumnsToText
      else  MlvNotes.SetColumnWidths(FNoteLVColWidths);
      Ffitoncetotext := True;
    End;
  Finally
    FAreAddingToNotesListing  := false;
    tIncResults.Free;
    tNewResults.Free;
  End;
End;



procedure TfrmCapTIU.ShowUnsigned(value : boolean);
begin
  if not value then
    begin
    ShowStatus(2, '');
    ShowStatus(3, '');
    mlvUnsigned.Selected := nil;
    end;
  mlvUnsigned.visible := value;
  splUnsigned.visible := value;
  if value then  splUnsigned.Top := mlvUnsigned.height + 10;
end;


Procedure TfrmCapTIU.NotesByContextUnsigned;
Var
  tUnsResults: Tstringlist;   {results of Each individual RPC Call made in this function.  these incremental Results are
                                merged into the tNewResults list.}
  tUnCosResults: Tstringlist;
  s: String;
  Li: TListItem;
  GetAddendums : integer; {This is always '1' now.   Variable used for Clarity of RPC Parameter}

  TiuObj: TMagTIUData;
  VContext : Integer;
  TempMonthsBack: Integer;
  signedCount : integer;
  ctSigned,ctUnSigned,ctUnCosigned,ctAddendum  : integer;
  scrollToItem : integer;

Begin


//uns//  Begin
//uns//    FdtFrom := '';   FInitialFROMDate := '';
//uns//    FdtTo := '';     FInitialTODate := '';
//uns//    If Fmthsback = 0 Then Fmthsback := -24;
//uns//    TempMonthsBack := Fmthsback;
//uns//  End;


 //pre 129 if FNoteTypes = [] then FnoteTypes := [magntSigned];

 if (mlvUnsigned.SelCount > 0 ) then DisableAllButtons;

  mlvUnsigned.Clear;  // new for Unsigned.
if ((not tbtnUnSigned.Down) and (not self.TbtnUnCosigned.Down)) then
     begin
       ShowUnsigned(false);
       exit;
     end;
  ShowUnsigned(true);

  GetAddendums := 1;   //129t17  always get Addendums.     Showaddendum := MagBoolToInt(FshowAddendums);
  ClearPreview;
  ShowStatus(-1, '');  {clear statusBar panels.}
  WinMsg('');
  tUnsResults := Tstringlist.Create;
  tUnCosResults  := Tstringlist.Create;

  {p129t17  We always get Addendums for unsigned Notes.}
  Try

    if tbtnUnSigned.Down then
       begin
      idmodobj.GetMagDBBroker1.RPGetNotesByContext(FDFN, tUnsResults, 2, UserCapDuz, '', 3, 'D', GetAddendums, 0, -99, '', ''); //Fmthsback,FdtFrom,FdtTo);
      s := s + '   ' + Inttostr(tUnsResults.Count) + '-' + 'Unsigned.';
      ShowStatus(2, Inttostr(tUnsResults.Count) + ' - ' + 'Unsigned.');
      end;

    if tbtnUnCoSigned.Down then
       begin
      idmodobj.GetMagDBBroker1.RPGetNotesByContext(FDFN, tUnCosResults, 3, UserCapDuz, '', 3, 'D', GetAddendums, 0, -99, '', ''); //Fmthsback,FdtFrom,FdtTo);
      tUnsResults.AddStrings(tUnCosResults);
      s := s + '   ' + Inttostr(tUnCosResults.Count) + '-' + 'Uncosigned.';
      ShowStatus(3, Inttostr(tUnCosResults.Count) + ' - ' + 'Uncosigned.');
      end;




    {   Patch 129t16   We need to be sure that the same TIUDA isn't listed twice. }



    //**************   TEST TEST TESTING  ************************
    if FCapDevTest then
       begin
        inc(filePreInc);
        tUnsResults.savetofile('c:\temp\CapTest\'+inttostr(filepreinc)+'.1-UnSigCosigResults.txt');
       end;
    //**************   TEST TEST TESTING  ************************

 //uns//   ClearDuplicates(tUnsResults); {do we need this for Unsigned, Uncosigned. }

//uns//    GetSetStatusCounts(tNewResults,ctSigned,ctUnSigned,ctUnCosigned,ctAddendum);

    ReWorkTheNoteListing(tUnsResults, mlvUnSigned);

 //old   If ((MlvNotes.Items.Count > 0) And (Not Ffitoncetotext)) Then
// p129 below. duc.
  If ((mlvUnSigned.Items.Count > 0) And (Not FfitUnSignedoncetotext)) Then
    Begin
      if FNoteLVColWidths = ''
        then  mlvUnSigned.FitColumnsToText
        else   mlvUnSigned.SetColumnWidths(FNoteLVColWidths);
    FfitUnSignedoncetotext := True;
    End;
  Finally
    tUnsResults.Free;
    tUnCosResults.Free;
  End;
End;



procedure TfrmCapTIU.ClearDuplicates(tbase : Tstringlist);
var I : integer;
tiuda : String;
  TIUDAList : Tstringlist;
  dupcount : integer;
  dupIENs : string;
Begin
try
dupcount := 0;
dupIENs := '' ;
  TIUDAList := Tstringlist.create;
  for I := tbase.Count-1 downto 1 do
    begin
       TIUDA := magpiece(tbase[i],'^',1);
       if (TIUDAlist.IndexOf(TIUDA) > -1)  then
          BEGIN
          inc(dupcount);
          dupIENs := dupIENs + TIUDA + ', ';
          tbase.Delete(I);
          continue;
          END;
      TIUDAlist.Add(TIUDA);
    end;
finally
TIUDAlist.Free;
magappmsg('s','Duplicates: ' + inttostr(dupcount)+ #13 + ' IENs ' + dupIENS);
end;
end;

procedure TfrmCapTIU.GetSetStatusCounts(tt : tstringlist; var ctSigned,ctUnSigned,ctUnCosigned,CtAddendum : integer);
var i : integer;
stat : string;
parda : integer;
begin
  ctSigned := 0; ctUnSigned := 0; ctUnCosigned := 0; CtAddendum := 0;
  for i := 0 to tt.Count - 1 do
    begin
      stat := Uppercase(magpiece(tt[i],'^',7));
      parda := strtoint(magpiece(tt[i],'^',14));
      if (parda > 5) then
         begin
          inc(ctAddendum);
          continue;
         end;

      if stat = 'COMPLETED'  then  inc(ctSigned);
   //129T17   if stat = 'UNSIGNED'  then inc(ctUnSigned);
   //129T17   if stat = 'UNCOSIGNED'  then inc(ctUnCosigned);
    end;
(*

    If MagntMine In FNoteTypes Then
    Begin
      idmodobj.GetMagDBBroker1.RPGetNotesByContext(FDFN, t, 4, UserCapDUZ, Inttostr(FNoteReturnCount), 3, 'D', GetAddendums, 0, TempMonthsBack, FdtFrom, FdtTo);
      Tt.Assign(t);
      ShowStatus(1, Inttostr(t.Count) + ' - ' + UserCapname + '.');
*)
  if (not tbtnSigned.Down) and (not tbtnMine.down) and (not DidUseAuthorSearch) then
    begin
      showstatus(0,'');
      showstatus(1,'');
    end
    else
    begin
      ShowStatus(0, Inttostr(tt.Count -1) + ' Notes');
      ShowStatus(1, Inttostr(ctSigned) + ' - ' + 'Signed Notes.');
      If MagntMine In FNoteTypes Then
         ShowStatus(1, Inttostr(ctSigned) + ' - ' + UserCapname + '.');
      if DidUseAuthorSearch then
        ShowStatus(1, Inttostr(ctSigned) + ' - ' + FAuthor + '(' + Inttostr(ctAuth) + ')' + '.');
    end;
 //nOT NOW,  COMPUTED SEPERATELY  ShowStatus(2, Inttostr(ctUnSigned) + ' - ' + 'Unsigned.');
 //nOT NOW,  COMPUTED SEPERATELY   ShowStatus(3, Inttostr(ctUnCosigned) + ' - ' + 'Uncosigned.');




end;

Procedure TfrmCapTIU.MnuRefreshClick(Sender: Tobject);
begin
  RefreshNotesListing;
end;

procedure TfrmCapTIU.RefreshNotesListing();
Begin
 InitializeDatesFlagsForMore;
  NotesByContext;
End;

Procedure TfrmCapTIU.MnuFitToTextClick(Sender: Tobject);
Begin
  If PnlNotes.Visible Then
    MlvNotes.FitColumnsToText
  Else
    MlvTitles.FitColumnsToText;
End;

Procedure TfrmCapTIU.MnuSelectNoteClick(Sender: Tobject);
Begin
  If FNoteTypes = [] Then FNoteTypes := [MagntSigned];
  ChangeState(NwsList);
      InitializeDatesFlagsForMore;
  NotesByContext;
End;

Procedure TfrmCapTIU.MnuSignedClick(Sender: Tobject);
Begin
  MnuSigned.Checked := Not MnuSigned.Checked;
  SetSigned(MnuSigned.Checked);
      InitializeDatesFlagsForMore;
  NotesByContext;
End;

Procedure TfrmCapTIU.MnuUnCosignedClick(Sender: Tobject);
Begin
  MnuUnCosigned.Checked := Not MnuUnCosigned.Checked;
  SetUnCosigned(MnuUnCosigned.Checked);
  NotesByContextUnsigned;
End;

Procedure TfrmCapTIU.MnuUnSignedClick(Sender: Tobject);
Begin
  MnuUnSigned.Checked := Not MnuUnSigned.Checked;
  SetUnSigned(MnuUnSigned.Checked);
  NotesByContextUnsigned;
End;

Procedure TfrmCapTIU.MnuViewClick(Sender: Tobject);
Begin
  MnuMine.Checked := TbtnMine.Down;
  MnuSigned.Checked := TbtnSigned.Down;
  MnuUnSigned.Checked := TbtnUnSigned.Down;
  MnuUnCosigned.Checked := TbtnUnCosigned.Down;

End;

Procedure TfrmCapTIU.SyncButtonsToNoteTypes(Notetype: TMagNoteTypes);
Begin
  TbtnSigned.Down := MagntSigned In Notetype;
  //129t17 out.  Signed < not dependent on Unsigened>  TbtnUnSigned.Down := MagntUnSigned In Notetype;
  //129t17 out.  Signed < not dependent on Unsigened>  TbtnUnCosigned.Down := MagntUnCoSigned In Notetype;
  TbtnMine.Down := MagntMine In Notetype;
{type TmagNoteTypes = set of (magntSigned,magntUnSigned,magntUnCoSigned,magntMine);}
End;

Procedure TfrmCapTIU.ReWorkTheNoteListing(rBase: Tstringlist; mlv : Tmaglistview );
Var
  T1                : Tstringlist;
  Lastcount, i, j, Par, p14, Upos    : Integer;
  TIUDA, Str  , p13      : String;
  Adden : Boolean;
  tmpFlagToShowAddendums : boolean;
 begin
 tmpFlagToShowAddendums :=  FlagToShowAddendums;
{p129t17,  Duplicates are taken out of the list first.  No need to check for them in this function.
           New.  List comming here in rBase will always have Addendums in the list, but based
           on the FlagToShowAddendums, is if we show them or not. IF this is mlvNOtes.
           If not MlvNotes, we always show addeneums.
           Also The list DOES Not HAVE Row 0 Headers
           Row0Headers := 'Title^Date~S1^Status^Author^# Img~S2^TiuDA~S2^ParentDA~S2';}

  T1 := Tstringlist.Create;
  T1.Assign(rBase);
if ( mlv = mlvUnsigned)  then   tmpFlagToShowAddendums :=  true;

  Try
      {     **********   sort by Date needed here .. Try.   *******}
      {     .... won't work here, it's not in cMagListView yet, and that sort is later.}

      {     Take Addendums out of the List.  not FBaseNoteList, just The list going to MlvNotes.}
      if Not tmpFlagToShowAddendums then

      for i  := T1.count-1 downto 0 do
        Begin
          Par := Strtoint(MagPiece(T1[i], '^', 14));
          if (par > 5) then
            begin
             T1.Delete(i);
             continue;
             end;
        if FCapDevTest then
                    t1.savetofile('c:\temp\CapTest\'+inttostr(filepreinc)+'.4-FBaseNoteListAddnsOUT.txt');
        End;
      for i  := T1.count-1 downto 0 do
        Begin
           Upos := Pos('^', T1[i]);
           p13 := magpiece(T1[i],'^',13);    // Piece 13 is the '+' to indicate the Note Has Addendums.
           Str := Copy(T1[i], 1, Upos) + p13 + Copy(T1[i], Upos + 1, 9999);
         T1[i] := Str;
        End;

    //p129 dmmn - apply column width from user preference or use existing value
    // p129t17... this will undo any changes to column width the user may have made
    //           since first Loading the list of TIU Notes.   Okay.
    if FUseNoteColWidthPref then
    begin
      Mlv.SetColumnWidths(FNoteLVColWidths);
      FUseNoteColWidthPref := false;
    end
    else
      Mlv.SetColumnWidths('');
//end p129 additions for columns widths from duc.


{ DONE :   the Addendums are having multiple '+' in front of name...NEED Quick Fix to get
    rid of that.. This is just the Display name, won't affect other processing. }
    if mlv = self.MlvNotes then  t1.Insert(0,Row0HeadersSigned);
    if mlv = self.mlvUnSigned then  t1.Insert(0,Row0HeadersUnSigned);
    Mlv.LoadListFromoTIUList(T1);
    // new next.
    Mlv.LockSort := false;
    Mlv.SortByColumn(1,true);
    //  Now whole listView is sorted,  if it has Addendums; in it, we LockSort, and Reposition the Addendums.

  if tmpFlagToShowAddendums then
       begin
       Mlv.LockSort := true;
       RePosAddendums(mlv);
       end;

  Finally
    T1.Free;
  End;
end;

Procedure TfrmCapTIU.RePosAddendums(mlv : Tmaglistview);
var
 i : integer;
 li,liAddnd : Tlistitem;
 t : tstringlist;
 tiuda : string;
 tiuObj : TMagTIUData;

begin   ;
MagAddnd.Items.Clear;


//t := tstringlist.create;

  for i := mlv.Items.Count -1 downto 0 do
     begin
       li := mlv.Items[i];
       tiuObj := li.Data;
       if (strtoint(tiuObj.TiuParDA) > 5)  then
         begin
           LiAddnd := magAddnd.Items.Add;
           liAddnd.Assign(li);
           liAddnd.Caption := '       ' + liAddnd.Caption;
           mlv.Items.Delete(i);

         end;
     end;
  if FCapDevTest then
        begin
        t := Tstringlist.create;
        for i := 0 to magaddnd.Items.Count - 1 do
             begin
             li := magaddnd.Items[i];
             tiuObj := li.Data;
             t.Add(magaddnd.items[i].Caption + '  ' + magaddnd.Items[i].subitems[0] +'  DA: ' +  tiuobj.TiuDA + '  ParDA: ' + tiuobj.TiuParDA);
             end;
        t.SaveToFile('c:\temp\CapTest\'+inttostr(filepreinc)+'.5-AddendumList.txt');
        t.Clear;
        {   now for testing, lets save the Notes Listing to File.}
        for i := 0 to MlvNotes.Items.Count - 1 do
             begin
             li := MlvNotes.Items[i];
             //if i = 0  then
             //           begin
             //           t.add(MlvNotes.items[i].Caption + '  ' + MlvNotes.Items[i].subitems[0]);
             //           continue;
             //           end;

             tiuObj := li.Data;
             t.Add(MlvNotes.items[i].Caption + '  ' + MlvNotes.Items[i].subitems[0] +'  DA: ' +  tiuobj.TiuDA + '  ParDA: ' + tiuobj.TiuParDA);
             end;
        t.SaveToFile('c:\temp\CapTest\'+inttostr(filepreinc)+'.6-JustNOTEList.txt');
        t.Free;
        end;

InsertAddnd(magAddnd,mlv)
end;

procedure TfrmCapTiu.InsertAddnd(Addnd, Notes : Tmaglistview);
var j,i , repeatcount: integer;
tiuda, par : string;
liAdd, liNote : Tlistitem;
tiuObj : TmagTIUData;
begin
repeatcount := 0;

repeat
inc(repeatcount);
for I := Addnd.items.count-1 downto 0 do
  begin
    liAdd := Addnd.Items[i];
    tiuObj := liAdd.Data;
    par := tiuObj.TiuParDA;
    for J := 0 to Notes.items.Count -1 do
      begin
        tiuObj := Notes.items[j].Data;
        tiuda := tiuObj.TiuDA;
        if tiuda = par then
          begin
          LiNote := Notes.Items.Insert(j+1);
          liNote.Assign(liAdd);
          Addnd.Items.Delete(i);
          end;
      end;
  end;
until (addnd.Items.Count = 0 ) or (repeatcount > 4);

end;


Function TfrmCapTIU.MatchingPiece(Str: String; t: Tstringlist; Piece: Integer): Boolean;
Var
  j: Integer;
  s, S1: String;
Begin
  s := MagPiece(Str, '^', Piece);
  Result := False;
  For j := 1 To t.Count - 1 Do
  Begin
    S1 := MagPiece(t[j], '^', Piece);
    If s = S1 Then
    Begin
      Result := True;
      Break;
    End;
  End;
End;

Procedure TfrmCapTIU.PreviewImagesForNote(VTIUObj: TMagTIUData);
Begin
//
End;

Procedure TfrmCapTIU.PreviewSelectedNote;
Var
  Li: TListItem;
  TiuObj: TMagTIUData;
Begin
if FCurMlv = nil then exit;
if FCurMlv.Items.Count = 0 Then Exit;
if FCurMlv.Selected = nil Then  exit;

  FCurMlv.Updateitems(0, 0);
  Li := FCurMlv.Selected;
  TiuObj := Li.Data;
  idmodobj.GetMagDBBroker1.RPGetNoteText(TiuObj.TiuDA, MemNoteText.Lines);
  Lbpreview.caption := ShowNoteTitle(TiuObj);


(*
  If MlvNotes.Items.Count = 0 Then Exit;
/// out for 129 t17.... If (MlvNotes.Selected = Nil) Then MlvNotes.Selected := MlvNotes.Items[0];
   If (MlvNotes.Selected = Nil) then exit;
  MlvNotes.Updateitems(0, 0);
  Li := MlvNotes.Selected;
  TiuObj := Li.Data;
  idmodobj.GetMagDBBroker1.RPGetNoteText(TiuObj.TiuDA, MemNoteText.Lines);
  Lbpreview.caption := ShowNoteTitle(TiuObj);
  *)
End;

Procedure TfrmCapTIU.ResizeColumns;
Begin

End;

Procedure TfrmCapTIU.SelectColumns1Click(Sender: Tobject);
Begin
  If PnlNotes.Visible Then
    MlvNotes.SelectColumns
  Else
    MlvTitles.SelectColumns;
End;

Procedure TfrmCapTIU.SetAuthor(XDuz, XName: String);
Begin
  ;
  FAuthor := XName;
  FAuthorDuz := XDuz;
End;

Procedure TfrmCapTIU.SetMine(Value: Boolean);
Begin
  TbtnMine.Down := Value;
  MnuMine.Checked := Value;
  If Value Then
  Begin
    FNoteTypes := FNoteTypes + [MagntMine];
    FNoteTypes := FNoteTypes - [MagntSigned];
    FUseAuthorSearch := False;
    TbtnSigned.Down := Not Value;
    MnuSigned.Checked := Not Value;
  End
  Else
  Begin
    FNoteTypes := FNoteTypes - [MagntMine];
  End;
End;

Procedure TfrmCapTIU.SetPreviewNote(Value: Boolean);
Var
  Wasvis: Boolean;
Begin
//p93t12 out  wasvis := pnlPreview.visible;
  FPreviewNote := Value;
  ClearPreview;
  If Not TbPreview.Down = Value Then TbPreview.Down := Value;
  MnuPreviewNote.Checked := Value;
  PnlPreview.Visible := Value;
  SpltList.Visible := Value;
  If Value Then SpltList.Top := PnlPreview.Top - SpltList.Height - 1;
//p93t12 out    if (not wasvis) and value then
  If Value Then
  Begin
    PreviewSelectedNote;
  End;
End;


Procedure TfrmCapTIU.SetUnCoSigned(Value: Boolean);
Begin
  TbtnUnCosigned.Down := Value;
  MnuUnCoSigned.Checked := Value;
End;


Procedure TfrmCapTIU.SetUnSigned(Value: Boolean);
Begin
  TbtnUnSigned.Down := Value;
  MnuUnSigned.Checked := Value;
End;

Procedure TfrmCapTIU.SetSigned(Value: Boolean);
Begin
  TbtnSigned.Down := Value;
  MnuSigned.Checked := Value;
  If Value Then
  Begin
    If FLagToshowAddendums Then
      FNoteTypes := [MagntSigned]
    Else
    Begin
      FNoteTypes := FNoteTypes + [MagntSigned];
      FNoteTypes := FNoteTypes - [MagntMine];
      FUseAuthorSearch := False;
      TbtnMine.Down := Not Value;
      MnuMine.Checked := Not Value;
    End;
  End
  Else
  Begin
    FNoteTypes := FNoteTypes - [MagntSigned];
    if (mlvNotes.SelCount > 0)  then DisableAllButtons;
    
    mlvNotes.Selected := nil;
  End;
End;

Function TfrmCapTIU.ShowNoteTitle(TiuObj: TMagTIUData): String;
Begin
  Try
    Result := TiuObj.Title + '  ' + TiuObj.DispDT + '  ' +
      TiuObj.PatientName + '  Auth: ' + TiuObj.AuthorName;
  Except
    On e: Exception Do Result := '';
  End;
End;

Procedure TfrmCapTIU.ShowStatus(Xpanel: Integer; Value: String);
Var
  i: Integer;
Begin
  If Xpanel = -1 Then
      BEGIN
      if (not tbtnMine.Down) and (not tbtnSigned.Down)  then  StatusBar2.Panels[1].Text := '' ;
      if (not tbtnUnSigned.Down) then StatusBar2.Panels[2].Text := '' ;
      if (not tbtnUnCoSigned.Down) then StatusBar2.Panels[3].Text := '' ;
      END
  Else
    StatusBar2.Panels[Xpanel].Text := Value;

End;

(*procedure TfrmCapTIU.SortDateTime(var lic: string);
begin
  lic := copy(lic, 7, 4) + copy(lic, 1, 2) + copy(lic, 4, 2)
    + copy(lic, 12, 2) + copy(lic, 15, 2) + copy(lic, 18, 2);
end;
   *)
(*procedure TfrmCapTIU.SwitchToNoteSelection;
begin
  if pagecontrol.ActivePage <> tabshSelect then pagecontrol.ActivePage := tabshSelect;
  winmsg('');
  mnuOptionsSelect.Visible := true;
  mnuOptionsCreate.Visible := false;
  mnuView.Enabled := true;
  SetStatusEnabled(True,0);
  SetAbleToOK(false);
end;
  *)
(*procedure TfrmCapTIU.SwitchToTitleSelection;
var
  rmsg, rtiuda: string;
  vClinDataObj: TClinicalData;
begin
  if pagecontrol.ActivePage <> tabshNew then pagecontrol.ActivePage := tabshNew;
  winmsg('');
  mnuOptionsSelect.Visible := false;
  mnuOptionsCreate.Visible := true;
  mnuView.Enabled := false;
  SetStatusEnabled(True,0);
  SetAbleToOK(false);
  {   FmyList is initially set in the OnShow}
  IF FmyList then mlvTitles.ItemIndex := mlvtitles.Items.Count -1;
  {Out, this is done in OnShow
  if FNewAuthor = '' then
    begin
      FNewAuthor := Username;
      FNewAuthorDuz := DUZ;
    end;
  if edtAuthor.Text = ''
    then edtAuthor.text := FNewAuthor; }

 {  OUT, this is done in OnShow.
 if edtLoc.Text = ''
      then
      begin
      if FNewlocation <> ''
          then  edtLoc.Text := FNewLocation
          else
             begin
             edtLoc.SetFocus;
             exit;
             end;
      end;}
  if edtLoc.text = '' then
        begin
        edtLoc.SetFocus;
        exit;
        end;
  edtTitle.SetFocus();
  edtTitle.SelectAll;

end;

*)

Procedure TfrmCapTIU.TbPreviewClick(Sender: Tobject);
Begin
  SetPreviewNote(TbPreview.Down);
End;

Procedure TfrmCapTIU.TbtnAuthorClick(Sender: Tobject);
Begin
  ToggleAuthorSearch;
End;

Procedure TfrmCapTIU.TbtnMineClick(Sender: Tobject);
Begin
  SetMine(TbtnMine.Down);
      InitializeDatesFlagsForMore;
  NotesByContext;
End;

procedure TfrmCapTIU.tbtnMoreClick(Sender: TObject);
begin
  GetMoreNotes;
end;

Procedure TfrmCapTIU.TbtnMyNotesClick(Sender: Tobject);
Begin
  SetAuthor(UserCapDUZ, UserCapName);
End;

Procedure TfrmCapTIU.TbtnNoteOptionsClick(Sender: Tobject);
Begin
  GetListOptions;
End;

Procedure TfrmCapTIU.GetListOptions;
Var
  Vdtfrom, Vdtto: String;
  Vcount, Vmthsback, Voldmthsback: Integer;
  Vusestatusicons: Boolean;
  Vusenoteglyphs: Boolean;

Begin

  Vdtfrom := FdtFrom;
  Vdtto := FdtTo;
  Vcount := FNoteReturnCount;
  Vmthsback := Fmthsback;
  Voldmthsback := Fmthsback;
  Vusestatusicons := FUseStatusIcons;
  Vusenoteglyphs := FUseNoteGlyphs;

  If FrmCapTIUOptions.Execute(Vcount, Vdtfrom, Vdtto, Vmthsback, Vusestatusicons, Vusenoteglyphs) Then
  Begin
    FdtFrom := Vdtfrom;   FInitialFROMDate := FdtFrom;
    FdtTo := Vdtto;       FInitialTODate := FdtTo;
    FNoteReturnCount := Vcount;
    if (FNoteReturnCount > 100)  then  FNoteReturnCount := 100;
    SetSignedBtnCaption;
    Fmthsback := Vmthsback;
    FUseStatusIcons := Vusestatusicons;
    FUseNoteGlyphs := Vusenoteglyphs;
  //p59t16  if Fdtfrom <> '' then FmthsBack := 0;
  //Setstatusbarlistoptions; // NotesByContext calls this
    SetUseStatusIcons(FUseStatusIcons);
        InitializeDatesFlagsForMore;
    NotesByContext;
    If Fmthsback = 0 Then Fmthsback := Voldmthsback;
    FdtFrom := ''; //p59t20
    FdtTo := ''; //p59t20
  End;
End;

Procedure TfrmCapTIU.SetStatusBarListOptions;
Var
  s, Mth: String;
Begin
  s := 'get ' + Inttostr(FNoteReturnCount) + ' signed Notes';
  Case Fmthsback Of
    -99: s := s + ' for All Dates'; //
    -98.. - 1:
      Begin
        Case Abs(Fmthsback) Of
          1: Mth := '1 month';
          2: Mth := '2 months';
          6: Mth := '6 months';
          12: Mth := '1 year';
          24: Mth := '2 years';
        Else
          Mth := Inttostr(Abs(Fmthsback)) + ' months';
        End;
        s := s + ' for the last ' + Mth + ' ' + ' [from ' + Formatdatetime('mmm dd,yy', IncMonth(Now, Fmthsback)) + ']'; //
      End;
    0: s := s + ' from ' + Formatdatetime('mmm dd,yy', Strtodatetime(FdtFrom)) + ' to ' + Formatdatetime('mmm dd,yy', Strtodatetime(FdtTo));
  End;
//    dtfrom :=  datetostr(IncMonth(now, mthsback));
  StatusBar2.Panels[4].Text := s;

(*s := 'Last ' +  inttostr(Fcount) + ' Signed Notes.  ';
Case FmthsBack of
   -99 :  s := s + 'All Dates' ;//
   -98..-1 : s := s + 'from ' + Fdtfrom + ' Thru Today ' + inttostr(abs(FmthsBack)) + ' months'; //
    0 :   s := s + 'from ' + Fdtfrom + ' to ' + Fdtto
  end;
//    dtfrom :=  datetostr(IncMonth(now, mthsback));
statusbar2.Panels[4].Text := s;*)
End;

Procedure TfrmCapTIU.TbtnSignedClick(Sender: Tobject);
begin
  GetSignedNotes(TbtnSigned.Down);
end;

procedure TfrmCapTIU.GetSignedNotes(value : boolean);
Begin
  SetSigned(value);
  InitializeDatesFlagsForMore;

  NotesByContext;
End;

procedure TfrmCapTIU.InitializeDatesFlagsForMore;
begin
 {any time a Button is changed.  the previous list is cleared,  any lookup now
   is the first lookup for the New Base List.}
      IF FbaseNoteList <> nil then FBaseNoteList.Clear;
      FAreAddingToNotesListing  := false;
      FdtFrom := FinitialFromDate;
      FdtTO := FinitialTODate;
end;
Procedure TfrmCapTIU.TbtnUnCosignedClick(Sender: Tobject);
Begin
  SetUnCosigned(TbtnUnCosigned.Down);
  NotesByContextUnsigned;
End;

Procedure TfrmCapTIU.TbtnUnSignedClick(Sender: Tobject);
Begin
  SetUnSigned(TbtnUnSigned.Down);
//uns//      InitializeDatesFlagsForMore;
  NotesByContextUnsigned;
End;




Procedure TfrmCapTIU.ToggleAuthorSearch;
Begin
  FUseAuthorSearch := LookupAuthor();
  If FUseAuthorSearch Then
  Begin
    MnuMine.Checked := False;
    MnuSigned.Checked := False;
    {  TMagNoteTypes = Set Of (MagntSigned, MagntUnSigned, MagntUnCoSigned, MagntMine);}
    FNoteTypes := [MagntSigned]; //changed in 129 t16 FNoteTypes - [MagntMine] - [MagntSigned];
    TbtnSigned.Down := true; // changed in 129 t16 false;
    TbtnMine.Down := False;
      SyncButtonsToNoteTypes(FNoteTypes); //129 t 16
  End;
      InitializeDatesFlagsForMore;
  NotesByContext;
End;

Procedure TfrmCapTIU.WinMsg(s: String);
Begin
  StatusBar1.Panels[0].Text := s;
End;

Procedure TfrmCapTIU.WMGetMinMaxInfo(Var Message: TWMGetMinMaxInfo);
Var
  Hy, Wx: Integer;
Begin
  Exit;
  Hy := Trunc(290 * (Pixelsperinch / 96));
  Wx := Trunc(470 * (Pixelsperinch / 96));
  With Message.Minmaxinfo^ Do
  Begin
    PtMinTrackSize.x := Wx;
    PtMinTrackSize.y := Hy;
  End;
  Message.Result := 0;
  Inherited;

End;

Procedure TfrmCapTIU.TbtnSignNoteClick(Sender: Tobject);
Begin
  SignUnsignedNote;
End;

Procedure TfrmCapTIU.SignUnsignedNote;
Var
  TiuObj: TMagTIUData;
  Esig: String;
  Fmsg, Rmsg: String;
  Vstat: Boolean;
  VfailReason: TEsigFailReason;
  Failstring: String;
Begin
  WinMsg('');
  Esig := '';
  if FcurMlv = nil then FcurMlv := mlvNotes;

  If FcurMlv.Selected = Nil Then
  Begin
    WinMsg('Before Signing a Note, you need to select a Note.');
    Exit;
  End;
  TiuObj := GetTIUObject(FcurMlv);
  If (TiuObj = Nil) Or (TiuObj.TiuDA = '0') Then
  Begin
    WinMsg('Selected Note has Invalid TIU Object.');
    Exit;
  End;

  If TiuObj.Status = 'completed' Then
  Begin
    WinMsg('You cannot sign a Completed Note.');
    Exit;
  End
  Else
  Begin
       {from ButtonClick or Menu Item}
    idmodobj.GetMagDBBroker1.RPTIUAuthorization(Vstat, Rmsg, TiuObj.TiuDA, 'EDIT RECORD');
    If Not Vstat Then
    Begin
      Messagedlg('TIU Document:  ' + TiuObj.Title + #13
        + 'Status:         ' + Rmsg + #13 + #13
        + 'You cannot sign this Document.' + #13, MtWarning, [Mbok]
        , 0);
             //maggmsgf.MagMsg('s','Status: '+rmsg);
      MagAppMsg('s', 'Status: ' + Rmsg); 
             //maggmsgf.magmsg('s','You cannot sign this Document.');
      MagAppMsg('s', 'You cannot sign this Document.'); 
      Exit;
    End;
    WinMsg('Signing Selected Note: ' + TiuObj.Title);
    If Not FrmEsigDialog.Execute(UserCapname, Esig, idmodobj.GetMagDBBroker1, VfailReason) Then
    Begin
      Case VfailReason Of
        MagesfailCancel: Failstring := 'Canceled.';
        MagesfailInvalid:
          Begin
            Failstring := 'Error: Invalid Electronic Signature';
                  //maggmsgf.MagMsg('de','Electronic Signature ' + failstring);
            MagAppMsg('de', 'Electronic Signature ' + Failstring); 
          End;
      End;

      WinMsg('Electronic Signature ' + Failstring);
    End
    Else
    Begin
      If idmodobj.GetMagDBBroker1.RPTIUSignRecord(Fmsg, idmodobj.GetMagPat1.M_DFN, TiuObj.TiuDA, Esig) Then
      Begin
        WinMsg('Note: ' + TiuObj.Title + ' is signed.');
            InitializeDatesFlagsForMore;
       if FcurMlv = mlvUnSigned then NotesByContextUnsigned
         else  NotesByContext;
      End
      Else
      Begin
        WinMsg('Failed to Sign Note: ' + Fmsg);
                 //maggmsgf.MagMsg('de','Failed to Sign Note: ' + fmsg);
        MagAppMsg('de', 'Failed to Sign Note: ' + Fmsg); 
      End;
    End;
  End;
End;

Procedure TfrmCapTIU.MnuClearTextClick(Sender: Tobject);
Begin
//CopyToClip(memAddNoteText);
  MemAddNoteText.Clear;
End;

Procedure TfrmCapTIU.ClearText1Click(Sender: Tobject);
Begin
//CopyToClip(memAddNoteText);
  MemAddNoteText.Clear;
End;

Procedure TfrmCapTIU.Tabbingseq1Click(Sender: Tobject);
Begin
  Showtabbingseq;
End;

Procedure TfrmCapTIU.MnuShowAddendumsClick(Sender: Tobject);
Begin
 {auto check for this menu item is now True.}
 // MnuShowAddendums.Checked := Not MnuShowAddendums.Checked;
  FlagToShowAddendums := MnuShowAddendums.Checked;
  ShowHideAddendums;


(*  If FlagToShowAddendums Then
  Begin
    {129t17    below is always true... ???}
    If (MagntSigned In FNoteTypes) And (MagntSigned In FNoteTypes) Then FNoteTypes := [MagntSigned];
  End;
  InitializeDatesFlagsForMore;
  NotesByContext;
*)
End;

Procedure TfrmCapTIU.ResetPanelsize2Click(Sender: Tobject);
Begin
  ResetPanelSize;
End;

Procedure TfrmCapTIU.ResetPanelSize;
Begin
  FrmCapTIU.Width := FrmCapTIU.Width + 1;
  FrmCapTIU.Update;
  FrmCapTIU.Width := FrmCapTIU.Width - 1;
  FrmCapTIU.Update;

End;

Procedure TfrmCapTIU.EdtTitleKeyDown(Sender: Tobject; Var Key: Word; Shift: TShiftState);
Begin
  FClick := 3;
  If (Key = 8) And (EdtTitle.Seltext <> '') Then
  Begin
    FDelOneMore := True;
  End;
End;

Procedure TfrmCapTIU.TimerlkpTimer(Sender: Tobject);
Var
  Fl, Sl: String;
  Fi, Si: Integer;
  ALPH: String;
//r0,
  Str: String;
  Rlist: TStrings;
  Li: TListItem;
  VShift: TShiftState;
  VKey: Word;
  Hits: Integer;
  Fulltext: String;
  Indexsel, Thumbpos: Integer;
Begin
//indexsel := -1;
  Thumbpos := 99999;
  VShift := [Ssctrl];
//vKey := 35;
  Case FClick Of
    1:
      Begin
        Timerlkp.Enabled := False;
        Try
          ALPH := 'ABCDEFGHIJKLMNOPQRSTUVWXYZ';
          If (EdtAuthor.Seltext <> '') Then
          Begin
            Str := Copy(EdtAuthor.Text, 1, Pos(EdtAuthor.Seltext, EdtAuthor.Text) - 1);
          End
          Else
            Str := EdtAuthor.Text;

          MlvAuthor.ClearItems;
          If (Str = '') Then Exit;
          MlvAuthor.SortType := StText;
          Rlist := GetAuthorsFromVista(Str, 1);
          If Rlist = Nil Then Exit;
          MlvAuthor.LoadListFromStrings(Rlist);
          MlvAuthor.FitColumnsToText;
          ComputeHeight(MlvAuthor, EdtAuthor);
          MlvAuthor.Visible := True;
         {    edtAuthorKeyUp(self,vKey,vshift);   (Sender: TObject; var Key: Word; Shift: TShiftState);}
         {    full text is of the Matching List entry, '' if 0 hits.}
          Hits := GenKeyUp(EdtAuthor, Str, Fulltext, MlvAuthor, False);
          If Hits = 0 Then Exit;
          If Fulltext <> '' Then
          Begin
            EdtAuthor.SELSTART := Length(Str);
            EdtAuthor.SelLength := 999;
          End;
        Finally
          Rlist.Free;
        End;
      End;
    2:
      Begin
        Timerlkp.Enabled := False;
        Try
          ALPH := 'ABCDEFGHIJKLMNOPQRSTUVWXYZ';
          If (EdtLoc.Seltext <> '') Then
          Begin
            Str := Copy(EdtLoc.Text, 1, Pos(EdtLoc.Seltext, EdtLoc.Text) - 1);
          End
          Else
            Str := EdtLoc.Text;
          MlvLoc.ClearItems;
          If (Str = '') Then Exit;
          MlvLoc.SortType := StText;
          Rlist := GetLocationsFromVista(Str, 1);
          If Rlist = Nil Then Exit;
          MlvLoc.LoadListFromStrings(Rlist);
          MlvLoc.FitColumnsToText;
          ComputeHeight(MlvLoc, EdtLoc);
          MlvLoc.Visible := True;
         {  edtAuthorKeyUp(self,vKey,vshift); //  (Sender: TObject; var Key: Word; Shift: TShiftState);}
         {  full text is of the Matching List entry, '' if 0 hits.}
          Hits := GenKeyUp(EdtLoc, Str, Fulltext, MlvLoc, False);
          If Hits = 0 Then Exit;
          If Fulltext <> '' Then
          Begin
            EdtLoc.SELSTART := Length(Str);
            EdtLoc.SelLength := 999;
          End;
        Finally
          Rlist.Free;
        End;
      End;
    3:
      Begin
        Timerlkp.Enabled := False;
        PnlScrollTxt.caption := '';
        PnlScrollTxt.Visible := False;
        Try
          ALPH := 'ABCDEFGHIJKLMNOPQRSTUVWXYZ';
          If FOnScroll Then
          Begin
            EdtTitle.Text := '';
            Fi := ScbarTitles.Position Div 26;
            Thumbpos := ScbarTitles.Position;
            Fl := Copy(ALPH, Fi, 1);
            Si := ScbarTitles.Position Mod 26;
            Sl := Copy(ALPH, Si, 1);
            Str := Fl + Sl;
            If (Fi = 0) And (Si < 3) Then Str := ' ';
          End
          Else
            Str := EdtTitle.Text;
          If (Str = '') And (MlvTitles.Items.Count > 0) Then Exit;
          MlvTitles.ClearItems;
          Rlist := GetTitlesFromVista(Str, 1);
          If (Rlist = Nil) Or ((Rlist <> Nil) And (Rlist.Count < 42)) Then
          Begin
            If Rlist = Nil Then
            Begin
              Indexsel := 0;
              Rlist := Tstringlist.Create;
            End
            Else
              Indexsel := Rlist.Count;
            Rlist.Assign(FtstringsEndList);
            Rlist.Insert(0, FtstringColumn);
            //mlvTitles.Items.BeginUpdate;
            MlvTitles.LoadListFromStrings(Rlist);
            MlvTitles.ItemIndex := MlvTitles.Items.Count - 1 - Indexsel;
            MlvTitles.Selected := MlvTitles.Items[MlvTitles.ItemIndex];
            MlvTitles.ItemFocused := MlvTitles.Items[MlvTitles.ItemIndex];
            MlvTitles.ScrollToItem(MlvTitles.ItemIndex);
            //mlvTitles.FitColumnsToText;
            //mlvTitles.Items.endUpdate;
          End
          Else
          Begin
            //mlvTitles.Items.BeginUpdate;
            MlvTitles.LoadListFromStrings(Rlist);
            Str := MlvTitles.Items[0].caption;
            Rlist.Delete(0);
            CheckOverLapStart(MlvTitles, Rlist);
            If Thumbpos < 3 Then
              Li := MlvTitles.Items[0]
            Else
              Li := MlvTitles.FindCaption(0, Str, True, True, False);
            MlvTitles.Selected := MlvTitles.Items[Li.Index];
            MlvTitles.ItemFocused := MlvTitles.Items[Li.Index];
            MlvTitles.ScrollToItem(Li.Index);
            //mlvTitles.Items.EndUpdate;
          End;

          If Rlist = Nil Then Exit;
      //if str <> '' then mlvTitles.ItemIndex := mlvTitles.GetClosestIndex(str);
        Finally
          Rlist.Free;
          If FOnScroll Then
          Begin
            FOnScroll := False;
            MlvTitles.SetFocus;
          End;
        End;
      End;
  End; {END CASE}
End;

Procedure TfrmCapTIU.ComputeHeight(LV: TMagListView; Edt: TEdit);
Var
  L, t, h, w: Integer;
Begin
  ;
  w := LV.Width;
  t := LV.Top;
  L := Edt.Left + 20;
  h := (LV.Items.Count * 18) + 20;
  If h + LV.Top > FrmCapTIU.ClientHeight Then h := FrmCapTIU.ClientHeight - LV.Top - StatusBar1.Height - 10;
  If h < 100 Then h := 100;
  LV.SetBounds(L, t, w, h);
End;

Procedure TfrmCapTIU.GetPersonnalTitleList;
Var
  Deftitle: Integer;
  Rlist: TStrings;
  i: Integer;
//r0 : string;
Begin
  Deftitle := -1;
  If FtstringsMyList <> Nil Then FtstringsMyList.Clear;
  FtstringsStartList.Clear;
  FtstringsEndList.Clear;
  MlvTitles.ClearItems;
  EdtTitle.Text := '';
  LbNewNoteTitle.caption := '';

  Application.Processmessages;
  Try

    Rlist := GetTitlesFromVista('', 1, True);
    If Rlist = Nil Then
    Begin
      FtstringsMyList := Nil;
    End
    Else
    Begin
      FtstringsMyList.Assign(Rlist);
      FtstringsMyList.Delete(0);
      FtstringsMyList.Add('-----------^-------------------^');
      Deftitle := FtstringsMyList.Count - 2;
    End;

    Rlist.Free;
    Rlist := GetTitlesFromVista('', 1, False);
    FtstringsStartList.Assign(Rlist);
    FtstringColumn := FtstringsStartList[0];
    FtstringsStartList.Delete(0);

    Rlist.Free;
    Rlist := GetTitlesFromVista('', -1, False);
    Rlist.Delete(0);
    InvertTStrings(Rlist);
    FtstringsEndList.Assign(Rlist);

{       Add starting titles.}
    Rlist.Clear;
    Rlist.AddStrings(FtstringsStartList);
{       If Personnal titles, add to front.}
    If FtstringsMyList <> Nil Then
      For i := FtstringsMyList.Count - 1 Downto 0 Do
        Rlist.Insert(0, FtstringsMyList[i]);
    Rlist.Insert(0, FtstringColumn);
    MlvTitles.LoadListFromStrings(Rlist);
    MlvTitles.Update;
    MlvTitles.Column[2].Width := 0;
    MlvTitles.FitColumnsToForm;
    If Deftitle > -1 Then
      MlvTitles.ItemIndex := Deftitle
    Else
      MlvTitles.ItemIndex := 0;

  Finally
    Rlist.Free;
  End;

End;

Procedure TfrmCapTIU.InvertTStrings(Rlist2: TStrings);
Var
  t: TStrings;
  i: Integer;
Begin
  Try
    t := Tstringlist.Create;
    t.Assign(Rlist2);
    Rlist2.Clear;
    For i := t.Count - 1 Downto 0 Do
      Rlist2.Add(t[i]);
    //rlist2.Insert(0,t[0]);
  Finally
    t.Free;
  End;
End;

Function TfrmCapTIU.GetTitlesFromVista(Starttext: String; Dir: Integer = 1; Mylist: Boolean = False): TStrings;
Var
  Rstat: Boolean;
  Rmsg: String;
Begin
  Result := Tstringlist.Create;
  Starttext := Starttext + '|' + Inttostr(Dir);
  idmodobj.GetMagDBBroker1.RPTIULongListOfTitles(Rstat, Rmsg, Result, 'NOTE', Starttext, Mylist);
  If Not Rstat Then
  Begin
    Result := Nil;
    //maggmsgf.magmsg('',rmsg);
    MagAppMsg('', Rmsg); 
  End
  Else
  Begin
    Exit;
  End;
End;

Function TfrmCapTIU.GetAuthorsFromVista(Starttext: String; Dir: Integer = 1): TStrings;
Var
  Rstat: Boolean;
  Rmsg: String;
//rlist : Tstrings;
  Rlist1: Tstringlist;
//dirFlag : string;
  i: Integer;
Begin
  Result := Tstringlist.Create;
  Rlist1 := Tstringlist.Create;
  idmodobj.GetMagDBBroker1.RPMag3LookupAny(Rstat, Rmsg, Rlist1, '200^50^' + Starttext + '^.01;29', '1^');
  If Not Rstat Then
  Begin
    Result := Nil;
   //maggmsgf.magmsg('',rmsg);
    MagAppMsg('', Rmsg); 
  End
  Else
  Begin
    For i := 1 To Rlist1.Count - 1 Do
      Result.Add(Rlist1[i]);
  End;
End;

Function TfrmCapTIU.GetLocationsFromVista(Starttext: String; Dir: Integer = 1): TStrings;
Var
  Rstat: Boolean;
  Rmsg: String;
//rlist : Tstrings;
  Rlist1: Tstringlist;
//dirFlag : string;
  i: Integer;
Begin
  Result := Tstringlist.Create;
  Rlist1 := Tstringlist.Create;
  idmodobj.GetMagDBBroker1.RPMag3LookupAny(Rstat, Rmsg, Rlist1, '44^50^' + Starttext + '^.01^', '1^');
  If Not Rstat Then
  Begin
    WinMsg(Rmsg);
    Result := Nil;
   //maggmsgf.magmsg('',rmsg);
    MagAppMsg('', Rmsg); 
  End
  Else
  Begin
    For i := 1 To Rlist1.Count - 1 Do
      Result.Add(Rlist1[i]);
  End;
End;

Procedure TfrmCapTIU.EdtTitleKeyUp(Sender: Tobject; Var Key: Word; Shift: TShiftState);
Var
  Txt, s, Fulltext: String;
  Hits: Integer;
//  searchinglist: boolean;
  Starttxt: String;
  Dir: Integer;
  Rlist: TStrings;
Begin
  If Key = 9 Then Exit;
  FClick := 3;
  Timerlkp.Enabled := False;

  Try
    If (Key = VK_Return) And (MlvTitles.Selcount > 0) Then
    Begin
      btnNewNoteOK.SetFocus;
      Exit;
    End;
    s := Chr(Key);
    If (Key = 8) And FDelOneMore Then
    Begin
      FDelOneMore := False;
      If Length(EdtTitle.Text) = 1 Then EdtTitle.Text := '';
      If EdtTitle.Text <> '' Then EdtTitle.Text := Copy(EdtTitle.Text, 1, Length(EdtTitle.Text) - 1);

    End;
    Starttxt := EdtTitle.Text;
    If ((Key = 38) Or (Key = 40)) Then
    Begin
      If (Key = 38) And (MlvTitles.ItemIndex = 0) Then
      Begin
          //IF FMyList then exit;
        Starttxt := Trim(MlvTitles.Selected.caption) + 'Z';
        Rlist := GetTitlesFromVista(Starttxt, -1);
          {TODO: AdditemsTOList}
        If Rlist = Nil Then Exit;
        Rlist.Delete(0); // delete column Headers.
        InvertTStrings(Rlist);
        MlvTitles.AddListToList(Rlist, 0);
            {if FtstringsStart has entry in rlist, then all to list, and insert My list.     }
        CheckOverLapStart(MlvTitles, Rlist);
        EdtTitle.SetFocus;
        EdtTitle.SelectAll;
        Exit;
      End;
      If (Key = 40) And (MlvTitles.ItemIndex = MlvTitles.Items.Count - 1) Then
      Begin
          //IF FMyList then exit;
        Starttxt := Copy(MlvTitles.Selected.caption, 0, Length(MlvTitles.Selected.caption) - 1);
        Rlist := GetTitlesFromVista(Starttxt, 1);
          {TODO: ADD TO LIST }
        If Rlist = Nil Then Exit;
        Rlist.Delete(0); // delete column Headers.
        MlvTitles.AddListToList(Rlist);
        CheckOverLapEnd(MlvTitles, Rlist);
        EdtTitle.SetFocus;
        EdtTitle.SelectAll;
        Exit;
      End;
      Case Key Of
        38:
          Begin {up}
            If MlvTitles.ItemIndex = -1 Then
              MlvTitles.ItemIndex := MlvTitles.Items.Count - 1
            Else
              MlvTitles.ItemIndex := MlvTitles.ItemIndex - 1;
            MlvTitles.ItemFocused := MlvTitles.Items[MlvTitles.ItemIndex];
            Dir := -1;
          End;
        40:
          Begin {down}
            MlvTitles.ItemIndex := MlvTitles.ItemIndex + 1;
            MlvTitles.ItemFocused := MlvTitles.Items[MlvTitles.ItemIndex + 1];
            Dir := 1;
          End;
      End;
      MlvTitles.ScrollToItem(MlvTitles.Selected);
      EdtTitle.SelectAll;
      Exit;
    End;
    If (Key = 37) Or (Key = 39) Then Exit;
    Txt := EdtTitle.Text;
    Fulltext := '';
  // not on key up...  not always
    If (Key = 8) And (EdtTitle.Seltext <> '') Then
    Begin
      Txt := Copy(Txt, 1, Length(Txt) - 1);
    End;

    If ((Key > 31) And (Key < 256)) Or (Key = 8) Then
    Begin
      If (EdtTitle.Seltext <> '') Then
      Begin
        Txt := Copy(EdtTitle.Text, 1, Pos(EdtTitle.Seltext, EdtTitle.Text) - 1);
      End;
      Hits := GenKeyUp(EdtTitle, Txt, Fulltext, MlvTitles, False);
        {       full text is of the Matching List entry, '' if 0 hits.}
      If Fulltext <> '' Then EdtTitle.Text := Fulltext;
      EdtTitle.SELSTART := Length(Txt);
      EdtTitle.SelLength := 999;
    End;

    If Hits = 0 Then
    Begin
  //FMyList := false;
      Timerlkp.Enabled := True;
    End;

  Finally
    Rlist.Free;
  End;
End;

Function TfrmCapTIU.GenKeyUp(Edt: TEdit; Var Txt: String; Var Fulltext: String; LV: TMagListView; Delchar: Boolean = False): Integer;
Var
//  i: integer;
  Li: TListItem;
Begin
  Li := LV.FindCaption(0, Txt, True, True, True);
  If Li = Nil Then
    Result := 0
  Else
  Begin
    Li.Selected := True;
    Fulltext := Li.caption;
    LV.ScrollToItem(Li);
    Frmcapmain.Testmsg('3- ' + Edt.Text);
    Result := 1;
  End;
End;

Procedure TfrmCapTIU.ScbarTitlesScroll(Sender: Tobject; ScrollCode: TScrollCode; Var ScrollPos: Integer);
Var
  ALPH, Str: String;
  Fi, Si, i: Integer;
  Fl, Sl: String;
Begin
  FClick := 3;
//   maggmsgf.MagMsg('',' on scroll ' + inttostr(scbarTitles.Position));
   //FMyList := false;
  FOnScroll := True;
  Timerlkp.Enabled := False;
  Timerlkp.Enabled := True;
  PnlScrollTxt.Visible := True;
  ALPH := 'ABCDEFGHIJKLMNOPQRSTUVWXYZ';
  Fi := ScbarTitles.Position Div 26;
  Fl := Copy(ALPH, Fi, 1);
  Si := ScbarTitles.Position Mod 26;
  Sl := Copy(ALPH, Si, 1);
  Str := Fl + Sl;
  PnlScrollTxt.caption := Str + '...';
  i := (ScbarTitles.Position * MlvTitles.Height) Div ScbarTitles.Max;
  If i < 15 Then i := 15;
  If (i + PnlScrollTxt.Height) > ScbarTitles.Height Then i := ScbarTitles.Height - PnlScrollTxt.Height;
  PnlScrollTxt.Top := i;
End;

Procedure TfrmCapTIU.MlvTitlesKeyUp(Sender: Tobject; Var Key: Word; Shift: TShiftState);
Begin
  If (Key = VK_Return) And (MlvTitles.Selcount > 0) Then
  Begin
    btnNewNoteOK.SetFocus;
    Exit;
  End;
End;

Procedure TfrmCapTIU.CheckOverLapStart(MlvTitles: TMagListView; Rlist: TStrings);
Begin
        // try to build a big list, piece by piece.

        // this way works okay.
        {       rlist has just been added to front of mlvTitles.
        If FtstringsStartList has entry in rlist, then add FtstringsStartList
        to list, and then insert FtstringsMyList     }
  If IsAtListBeginning Then Exit;
  If FtstringsStartList.Indexof(Rlist[0]) > -1 Then
  Begin
           //FtstringsStartList.Delete(0);     //
    MlvTitles.AddListToList(FtstringsStartList, 0);
    If FtstringsMyList <> Nil Then MlvTitles.AddListToList(FtstringsMyList, 0, True);
  End;

End;

Procedure TfrmCapTIU.CheckOverLapEnd(MlvTitles: TMagListView; Rlist: TStrings);
Begin
{       rlist has just been added to end of mlvTitles.
        If FtstringsEndList has entry in rlist, then add FtstringsEndList
        to list }
  If IsAtListEnd Then Exit;
  If FtstringsEndList.Indexof(Rlist[Rlist.Count - 1]) > -1 Then
  Begin
    MlvTitles.AddListToList(FtstringsEndList);
  End;

End;

Function TfrmCapTIU.IsAtListBeginning(): Boolean;
Var
  Lvdata, Sdata: String;
Begin
  Result := False;
  Sdata := MagPiece(FtstringsStartList[0], '|', 2);
  Lvdata := TMagListViewData(MlvTitles.Items[0].Data).Data;
  {     is the fist item in the list, the first item in StartList, or MyList }
  If Lvdata = Sdata Then Result := True;
  If FtstringsMyList = Nil Then Exit;
  Sdata := MagPiece(FtstringsMyList[0], '|', 2);
  Result := (Lvdata = Sdata);

End;

Function TfrmCapTIU.IsAtListEnd(): Boolean;
Var
  Lvdata, Sdata: String;
Begin
  {     is the Last item in the list, the last item in EndList}
  Result := False;
  Lvdata := TMagListViewData(MlvTitles.Items[MlvTitles.Items.Count - 1].Data).Data;
  Sdata := MagPiece(FtstringsEndList[FtstringsEndList.Count - 1], '|', 2);
  If Lvdata = Sdata Then Result := True;

End;

Procedure TfrmCapTIU.MlvTitlesKeyDown(Sender: Tobject; Var Key: Word; Shift: TShiftState);
Var
  Starttxt: String;
  Rlist: TStrings;
Begin
//if FMyList then exit;
  If ((Key = 38) Or (Key = 33) Or (Key = 40) Or (Key = 34)) Then
  Begin
    If ((Key = 38) Or (Key = 33)) And (MlvTitles.ItemIndex = 0) Then
    Begin
      If IsAtListBeginning Then Exit;
      Rlist := Tstringlist.Create;
      Try
        Starttxt := Trim(MlvTitles.Selected.caption) + 'Z';
        Rlist := GetTitlesFromVista(Starttxt, -1);
          {TODO: ADDLISTTOLSIT}
        If Rlist = Nil Then Exit;
        Rlist.Delete(0); // delete column Headers.
        InvertTStrings(Rlist);
        MlvTitles.AddListToList(Rlist, 0);
            {if FtstringsStart has entry in rlist, then all to list, and insert My list.     }
        CheckOverLapStart(MlvTitles, Rlist);
      Finally
        Rlist.Free;
      End;
      Exit;
    End;
    If ((Key = 40) Or (Key = 34)) And (MlvTitles.ItemIndex = MlvTitles.Items.Count - 1) Then
    Begin
      If IsAtListEnd Then Exit;
      Rlist := Tstringlist.Create;
      Try
        Starttxt := Copy(MlvTitles.Selected.caption, 0, Length(MlvTitles.Selected.caption) - 1);
         // starttxt := trim(mlvtitles.Selected.Caption);
        Rlist := GetTitlesFromVista(Starttxt, 1);
        If Rlist = Nil Then Exit;
        Rlist.Delete(0); // delete column Headers.
        MlvTitles.AddListToList(Rlist);
        CheckOverLapEnd(MlvTitles, Rlist);
          {TODO: here   set focus to the new item }
          //x- mlvTitles.SetFocus;
      Finally
        Rlist.Free;
      End;
      Exit;
    End;
  End;
End;

Procedure TfrmCapTIU.MlvTitlesChange(Sender: Tobject; Item: TListItem; Change: TItemChange);
Var
  Str, ALPH: String;
  i: Integer;
Begin
  btnNewNoteOK.Enabled := (MlvTitles.Selected <> Nil);
  ALPH := 'ABCDEFGHIJKLMNOPQRSTUVWXYZ';
   { fi := scbarTitles.Position div 26;
    fl := copy(ALPH,fi,1);
    si := scbarTitles.Position mod 26;
    sl := copy(ALPH,si,1);
    str := fl + sl;
    pnlScrollTxt.Caption := str;}

  If MlvTitles.TopItem <> Nil Then
  Begin
    Str := Copy(MlvTitles.TopItem.caption, 1, 1);
    i := Pos(Str, ALPH) * 26;
    ScbarTitles.Position := i;
  End;

End;

Procedure TfrmCapTIU.MnuListOptionsClick(Sender: Tobject);
Begin
  GetListOptions;
End;

Procedure TfrmCapTIU.UserBoilerplateifexist1Click(Sender: Tobject);
Begin
  FUseBoilerPlate := True;
End;

Procedure TfrmCapTIU.btnNewNoteOKClick(Sender: Tobject);
Begin
  If Pos('-----', MlvTitles.Selected.caption) > 0 Then
  Begin
  //maggmsgf.MagMsg('d','Invalid Title ' +  mlvtitles.Selected.Caption);
    MagAppMsg('d', 'Invalid Title ' + MlvTitles.Selected.caption); 
    Exit;
  End;
  SaveAndClose;
End;

Procedure TfrmCapTIU.SaveAndClose;
Var
  Li: TListItem;
  TmpNewTitleDA: String;
  TmpNewTitle: String;
  Rstat: Boolean;
  Rmsg: String;
  t: Tstringlist;
  VConsDA: String;
Begin
  { here, from a New Note, we get
     Title, TitleDA    ,and trim the title,
     Location, LocationDA
     Consult, ConsultDA (if the title needs one)}

  If MlvTitles.Selected = Nil Then
  Begin
    EdtTitle.SetFocus;
    Exit;
  End;
  MlvNotes.Selected := Nil;

  Li := MlvTitles.Selected;
  TmpNewTitleDA := TMagListViewData(Li.Data).Data;
  If Li.SubItems[0] = '' Then
    TmpNewTitle := Li.caption
  Else
    TmpNewTitle := Li.SubItems[0];
  TmpNewTitle := Trim(TmpNewTitle);
  TmpNewTitle := StringReplace(TmpNewTitle, '<', '', [RfReplaceAll]);
  TmpNewTitle := StringReplace(TmpNewTitle, '>', '', [RfReplaceAll]);
    {   If no Location, Don't allow exiting. }
  If (FNewlocation = '') Or (FNewLocationDA = '') Then
  Begin
        //maggmsgf.MagMsg('d','You must select a Visit Location.');
    MagAppMsg('d', 'You must select a Visit Location.'); 
    EdtLoc.SetFocus;
    Exit;
  End;
    {more P59t6  if this in consult and patient has no consults
                  or user doesn't select one, then we can't enable the OK button}
  idmodobj.GetMagDBBroker1.RPTIUisThisaConsult(Rstat, Rmsg, TmpNewTitleDA);
  t := Tstringlist.Create;
  Try
    If Rstat Then {It is a CONSULT Title}
    Begin
          {Show list of consults to select from}
      idmodobj.GetMagDBBroker1.RPGMRCListConsultRequests(Rstat, Rmsg, t, FDFN);
      If Rstat Then { There are Consults for Patient}
      Begin
        Rstat := FrmCapPatConsultList.Execute(VConsDA, t, TmpNewTitle, FPatient);
        If Not Rstat Then
        Begin
                     {User didn't select a consult.}
                     //maggmsgf.MagMsg('','Consult wasn''t selected.');
          MagAppMsg('', 'Consult wasn''t selected.'); 
          Exit;
        End
        Else
        Begin
                    {Title is a Consult and User has Selected a Patient Consult}
          FNewTitleIsConsult := True;
          FNewTitleConsultDA := VConsDA;
        End;
      End
      Else
      Begin
               { No Consults for Patient.  }
               //maggmsgf.MagMsg('D','There are No Consults available for Patient: ' + FPatient + #13 +
               //                     'This Title requires an associated consult request');
        MagAppMsg('D', 'There are No Consults available for Patient: ' + FPatient + #13 +
          'This Title requires an associated consult request'); 
        StatusBar1.Panels[0].Text := FPatient + ' has No Consults available for selection.';
        Exit;
      End;

    End;
  Finally
    t.Free();
  End;
  //  GetSelectedData;
  ModalResult := MrOK;
End;

Procedure TfrmCapTIU.PageControlChange(Sender: Tobject);
Begin
  HideLists;
  StatusBar1.Panels[0].Text := '';
  If PageControl.ActivePage = TabshNew Then
    ChangeState(NwsNew)
  Else
  Begin
    If FNoteTypes = [] Then FNoteTypes := [MagntSigned];
    ChangeState(NwsList);
        InitializeDatesFlagsForMore;
    NotesByContext;
  End;

End;
///////////////////////////////////////

Procedure TfrmCapTIU.EdtAuthorKeyUp(Sender: Tobject; Var Key: Word; Shift: TShiftState);
//var //txt, s ,fulltext: string;
 // hits, indx: integer;
 // searchinglist: boolean;
 // starttxt : string;
 // dir : integer;
 // rlist : Tstrings;
Begin
  Timerlkp.Enabled := False;
  FClick := 1;
  If ((Key = 38) Or (Key = 40)) Then
  Begin
    If (Key = 38) And (MlvAuthor.ItemIndex = 0) Then Exit;
    If (Key = 40) And (MlvAuthor.ItemIndex = MlvAuthor.Items.Count - 1) Then Exit;
    Case Key Of
      38:
        Begin {up}
          If MlvAuthor.ItemIndex = -1 Then
            MlvAuthor.ItemIndex := MlvAuthor.Items.Count - 1
          Else
            MlvAuthor.ItemIndex := MlvAuthor.ItemIndex - 1;
          MlvAuthor.ItemFocused := MlvAuthor.Items[MlvAuthor.ItemIndex];
          // dir := -1;
        End;
      40:
        Begin {down}
          MlvAuthor.ItemIndex := MlvAuthor.ItemIndex + 1;
          MlvAuthor.ItemFocused := MlvAuthor.Items[MlvAuthor.ItemIndex]; //+1
       //    dir := 1;
        End;
    End;
    MlvAuthor.Visible := True;
    If MlvAuthor.Selcount > 0 Then MlvAuthor.ScrollToItem(MlvAuthor.Selected);
    EdtAuthor.SelectAll;
    Exit;
  End;
  If (Key = VK_Return) And (MlvAuthor.Selcount > 0) Then
  Begin
    If EdtAuthor.Text = Copy(MlvAuthor.Selected.caption, 1, Length(EdtAuthor.Text)) Then
    Begin
      If MlvAuthor.Visible Then MlvAuthor.Visible := False;
      EdtAuthor.Text := MlvAuthor.Selected.caption;
      EdtLoc.SetFocus;
      Exit;
    End;
  End;
  If (SsAlt In Shift) And (Key = 40) Then
  Begin
    If MlvAuthor.Items.Count = 0 Then
    Begin
      Messagedlg('Enter a few characters of the Authors last name.' +
        #13 + 'all matching entries will be listed.', Mtconfirmation, [Mbok], 0);
      Exit;
    End;
    If Not MlvAuthor.Visible Then MlvAuthor.Visible := True;
    Exit;
  End;

  If (Key = 8) And FDelOneMoreAuth Then
  Begin
    FDelOneMoreAuth := False;
    If Length(EdtAuthor.Text) = 1 Then EdtAuthor.Text := '';
    If EdtAuthor.Text <> '' Then EdtAuthor.Text := Copy(EdtAuthor.Text, 1, Length(EdtAuthor.Text) - 1);
    EdtAuthor.Update;
  End;
  If (((Key > 31) And (Key < 127)) Or (Key = 8) Or (Key = VK_Return)) Then Timerlkp.Enabled := True;
End;

Procedure TfrmCapTIU.EdtAuthorEnter(Sender: Tobject);
Begin
  btnNewNoteOK.Default := False;
  FClick := 1;
  If MlvLoc.Visible Then MlvLoc.Visible := False;
End;

Procedure TfrmCapTIU.MlvTitlesEnter(Sender: Tobject);
Begin
  FClick := 3;
  HideLists;
End;

Procedure TfrmCapTIU.EdtTitleEnter(Sender: Tobject);
Begin
  btnNewNoteOK.Default := False;
  FClick := 3;
  HideLists;
  EdtTitle.SelectAll;
End;

Procedure TfrmCapTIU.HideLists;
Begin
  If MlvAuthor.Visible Then MlvAuthor.Visible := False;
  If MlvLoc.Visible Then MlvLoc.Visible := False;
End;

Procedure TfrmCapTIU.ScbarTitlesEnter(Sender: Tobject);
Begin
  FClick := 3;
End;

Procedure TfrmCapTIU.EdtAuthorKeyDown(Sender: Tobject; Var Key: Word;
  Shift: TShiftState);
Begin
  FClick := 1;
  If (Key = 8) And (EdtAuthor.Seltext <> '') Then
  Begin
    FDelOneMoreAuth := True;
  End;
End;

Procedure TfrmCapTIU.MlvAuthorSelectItem(Sender: Tobject; Item: TListItem; Selected: Boolean);
Var
  Li: TListItem;
  TmpAuthor: String;
  TmpAuthorDuz: String;
  Rstat: Boolean;
//  rmsg : string;
//  t : tstringlist;
//  vConsDA : string;
Begin
 // FAuthor := '';
 // FAuthorDuz := '';
  WinMsg('');
  ClearPreview;
  If MlvAuthor.Selected = Nil Then
  Begin
    Exit;
  End;

  Li := MlvAuthor.Selected;
  EdtAuthor.Text := Li.caption;
  TmpAuthor := Li.caption;
  TmpAuthorDuz := TMagListViewData(Li.Data).Data;
  //if li.SubItems[0] = '' then tmpAuthor := li.caption
  //else tmpAuthor := li.subitems[0];
  TmpAuthor := Trim(TmpAuthor);
  TmpAuthor := StringReplace(TmpAuthor, '<', '', [RfReplaceAll]);
  TmpAuthor := StringReplace(TmpAuthor, '>', '', [RfReplaceAll]);

  FAuthorDuz := TmpAuthorDuz;
  FAuthor := TmpAuthor;
  FNewAuthorDuz := TmpAuthorDuz;
  FNewAuthor := TmpAuthor;
  EdtAuthor.Text := FNewAuthor;

End;

Procedure TfrmCapTIU.MlvAuthorEnter(Sender: Tobject);
Begin
  FClick := 1;
  If MlvLoc.Visible Then MlvLoc.Visible := False;
End;

Procedure TfrmCapTIU.MlvAuthorClick(Sender: Tobject);
Begin
  If MlvAuthor.Selcount > 0 Then
  Begin
    EdtTitle.SetFocus;
    MlvAuthor.Visible := False;
  End;
End;

Procedure TfrmCapTIU.MlvAuthorExit(Sender: Tobject);
Begin
  MlvAuthor.Visible := False;

End;

Procedure TfrmCapTIU.btnAuthorClick(Sender: Tobject);
Begin
  If MlvAuthor.Items.Count = 0 Then
  Begin
    Messagedlg('Enter a few characters of the Authors last name.' +
      #13 + 'all matching entries will be listed.', Mtconfirmation, [Mbok], 0);

    EdtAuthor.SetFocus;
    MlvAuthor.Visible := False;
    Exit;
  End;
  MlvAuthor.Visible := Not MlvAuthor.Visible;
End;

Procedure TfrmCapTIU.btnLocClick(Sender: Tobject);
Begin
  If MlvLoc.Items.Count = 0 Then
  Begin
    Messagedlg('Enter a few characters of the Visit Location.' +
      #13 + 'all matching entries will be listed.', Mtconfirmation, [Mbok], 0);
    EdtLoc.SetFocus;
    MlvLoc.Visible := False;
    Exit;
  End;
  MlvLoc.Visible := Not MlvLoc.Visible;
End;

Procedure TfrmCapTIU.EdtLocEnter(Sender: Tobject);
Begin
  FClick := 2;
  btnNewNoteOK.Default := False;
  If MlvAuthor.Visible Then MlvAuthor.Visible := False;
//edtLoc.SelectAll;
///
{btnNewNoteOK.Default := false;
FClick := 1;
if mlvLoc.Visible then mlvLoc.Visible := false;}
End;

Procedure TfrmCapTIU.EdtLocKeyDown(Sender: Tobject; Var Key: Word;
  Shift: TShiftState);
Begin
  FClick := 2;
  If (Key = 8) And (EdtLoc.Seltext <> '') Then
  Begin
    FDelOneMoreLoc := True;
  End;
End;

Procedure TfrmCapTIU.EdtLocKeyUp(Sender: Tobject; Var Key: Word; Shift: TShiftState);
//var
// txt, s ,fulltext: string;
 // hits, indx: integer;
//  searchinglist: boolean;
//  starttxt : string;
 // dir : integer;
 // rlist : Tstrings;
 // li : Tlistitem;
Begin
  Timerlkp.Enabled := False;
  FClick := 2;
  If ((Key = 38) Or (Key = 40)) Then
  Begin
    If (Key = 38) And (MlvLoc.ItemIndex = 0) Then Exit;
    If (Key = 40) And (MlvLoc.ItemIndex = MlvLoc.Items.Count - 1) Then Exit;
    Case Key Of
      38:
        Begin {up}
          If MlvLoc.ItemIndex = -1 Then
            MlvLoc.ItemIndex := MlvLoc.Items.Count - 1
          Else
            MlvLoc.ItemIndex := MlvLoc.ItemIndex - 1;
          MlvLoc.ItemFocused := MlvLoc.Items[MlvLoc.ItemIndex];
//           dir := -1;
        End;
      40:
        Begin {down}
          MlvLoc.ItemIndex := MlvLoc.ItemIndex + 1;
          MlvLoc.ItemFocused := MlvLoc.Items[MlvLoc.ItemIndex + 1];
//           dir := 1;
        End;
    End;
    MlvLoc.Visible := True;
    If MlvLoc.Selcount > 0 Then MlvLoc.ScrollToItem(MlvLoc.Selected);
    EdtLoc.SelectAll;
    Exit;
  End;
  If (Key = VK_Return) And (MlvLoc.Selcount > 0) Then
  Begin
    If EdtLoc.Text = Copy(MlvLoc.Selected.caption, 1, Length(EdtLoc.Text)) Then
    Begin
      If MlvLoc.Visible Then MlvLoc.Visible := False;
      EdtLoc.Text := MlvLoc.Selected.caption;
      EdtTitle.SetFocus;
      Exit;
    End;
  End;
  If (SsAlt In Shift) And (Key = 40) Then
  Begin
    If MlvLoc.Items.Count = 0 Then
    Begin
      Messagedlg('Enter a few characters of the Location.' +
        #13 + 'all matching entries will be listed.', Mtconfirmation, [Mbok], 0);
      Exit;
    End;
    If Not MlvLoc.Visible Then MlvLoc.Visible := True;
    Exit;
  End;

  If (Key = 8) And FDelOneMoreLoc Then
  Begin
    FDelOneMoreLoc := False;
    If Length(EdtLoc.Text) = 1 Then EdtLoc.Text := '';
    If EdtLoc.Text <> '' Then EdtLoc.Text := Copy(EdtLoc.Text, 1, Length(EdtLoc.Text) - 1);
    EdtLoc.Update;
  End;
  If (((Key > 31) And (Key < 127)) Or (Key = 8) Or (Key = VK_Return)) Then Timerlkp.Enabled := True;
End;

Procedure TfrmCapTIU.MlvLocClick(Sender: Tobject);
Begin
  If MlvLoc.Selcount > 0 Then
  Begin
    EdtLoc.SetFocus;
    MlvLoc.Visible := False;
  End;
End;

Procedure TfrmCapTIU.MlvLocEnter(Sender: Tobject);
Begin
  btnNewNoteOK.Default := False;
  FClick := 2;
  If MlvAuthor.Visible Then MlvAuthor.Visible := False;
End;

Procedure TfrmCapTIU.MlvLocExit(Sender: Tobject);
Begin
  MlvLoc.Visible := False;
End;

Procedure TfrmCapTIU.MlvLocSelectItem(Sender: Tobject; Item: TListItem; Selected: Boolean);
Begin
  GetSelectedLoc;
End;


procedure TfrmCapTIU.UnSelectOtherListItem;
begin
  if FCurMLv = mlvNotes
     then mlvUnSigned.Selected := nil
     else mlvNotes.Selected := nil;
end;



procedure TfrmCapTIU.mlvGenericClick(Sender: TObject);
Var
  TiuObj: TMagTIUData;

Begin

  FCurMlv := (Sender as TMagListView);
  UnSelectOtherListItem;

  TiuObj := GetTIUObject(FCurMlv);
  If (TiuObj = Nil) Or (TiuObj.TiuDA = '0') Then Exit;
        {       Show selected Note Title on window.}
  LbNoteTitle.caption := TiuObj.Title;
    lbNoteTitle.Hint :=  LbNoteTitle.caption;
  If FPreviewNote Or FPreviewImages Then
  Begin
    If FPreviewNote Then PreviewSelectedNote;
    If FPreviewImages Then PreviewImagesForNote(TiuObj);
  End;

{P129T17 GEK - IsAddendum is now determined when the list is loaded.}
            {  Function TMagDBMVista.RPGetTIUData(TiuDA: String; Var TiuPTR: String): Boolean;}
            //if idmodobj.GetMagDBBroker1.RPGetTIUData(TIUobj.TiuDA,datastring)
            //         then
            //         begin
            //         TiuObj.IsAddendum := MagStrToBool(MagPiece(datastring, '^', 8));
            //         end;
  If TiuObj.Status = 'completed' Then
    ChangeState(NwsComplete,tiuobj)  {gek  Send whole tiuObj object, may need other data in future.}
  Else
    ChangeState(NwsUnsigned);
End;

Procedure TfrmCapTIU.GetSelectedLoc;
Var
  Li: TListItem;
  TmpLoc: String;
  TmpLocDA: String;
//  rstat : boolean;
//  rmsg : string;
//  t : tstringlist;
//  vConsDA : string;
Begin
  FNewlocation := '';
  FNewLocationDA := '';
  WinMsg('');
  If MlvLoc.Selected = Nil Then
  Begin
    Exit;
  End;
  Li := MlvLoc.Selected;
  EdtLoc.Text := Li.caption;
  TmpLoc := Li.caption;
  TmpLocDA := TMagListViewData(Li.Data).Data;
  //if li.SubItems[0] = '' then tmpAuthor := li.caption
  //else tmpAuthor := li.subitems[0];
  TmpLoc := Trim(TmpLoc);
  TmpLoc := StringReplace(TmpLoc, '<', '', [RfReplaceAll]);
  TmpLoc := StringReplace(TmpLoc, '>', '', [RfReplaceAll]);

  FNewLocationDA := TmpLocDA;
  FNewlocation := TmpLoc;
  EdtLoc.Text := FNewlocation;

End;

Procedure TfrmCapTIU.Rgrp2NewNoteStatusEnter(Sender: Tobject);
Begin
  btnNewNoteOK.Default := False;
  HideLists;
End;

Procedure TfrmCapTIU.EdtTitleExit(Sender: Tobject);
Begin
  btnNewNoteOK.Default := False;
End;

Procedure TfrmCapTIU.ResetPanelsize1Click(Sender: Tobject);
Begin
  ResetPanelSize;
End;

Procedure TfrmCapTIU.Font1Click(Sender: Tobject);
Begin
  FontDialog1.Font := MemNewNoteText.Font;
  If FontDialog1.Execute Then
  Begin
    MemNewNoteText.Font := FontDialog1.Font;
    ResizeColumns;
  End;
End;

Procedure TfrmCapTIU.FormClose(Sender: Tobject; Var action: TCloseAction);
Begin
  MlvAuthor.Hide;
  MlvLoc.Hide;
//  InitializeDatesFlagsForMore;
End;

{p129 gek/duc  added new param vTiuObj }
Procedure TfrmCapTIU.ChangeState(State: TMagNoteWinState;  vTiuObj : TMagTIUData = nil);
//var
//rmsg, rtiuda: string;
//vClinDataObj: TClinicalData;
Begin

  Case State Of
    NwsNew:
      Begin {This is the old SwitchtoTitle call}
        SetAbleToMakeAddendum(False);
        If PageControl.ActivePage <> TabshNew Then PageControl.ActivePage := TabshNew;
        WinMsg('');
        MnuOptionsSelect.Visible := False;
        MnuOptionsCreate.Visible := True;
        MnuView.Enabled := False;
        SetAbleToOK(False);
       {   FmyList is initially set in the OnShow}
       //IF FMyList then mlvTitles.ItemIndex := mlvtitles.Items.Count -1;
        If EdtLoc.Text = '' Then
        Begin
          EdtLoc.SetFocus;
          Exit;
        End;
        EdtTitle.SetFocus();
        EdtTitle.SelectAll;
      End;
    NwsList:
      Begin {This is the old SwitchtoNote call}
        If PageControl.ActivePage <> TabshSelect Then PageControl.ActivePage := TabshSelect;
        WinMsg('');
        MnuOptionsSelect.Visible := True;
        MnuOptionsCreate.Visible := False;
        MnuView.Enabled := True;
       //if Fnotetypes  = [] then FnoteTypes := [magntSigned];
        SetAbleToOK(False); {They will have to select an item to Enable OK button}
       //notesbycontext;
      End;
    NwsComplete:
      Begin
       {       Initialize Addendum for Signed 'completed' Note}
        SetAbleToSignNote(False);
        SetAbleToOK(True);
//        SetAbleToMakeAddendum(True);
         {next use this if stmt  instead of Above}
         if vTiuobj <> nil then  SetAbleToMakeAddendum(NOT vtiuobj.IsAddendum)
                            else  SetAbleToMakeAddendum(True);
        LbActionDesc.caption := 'Attach Images to Signed Note.';
        Rgrp2NoteStatus.Visible := False;
        Rgrp2NoteStatus.ItemIndex := 0;
        WinMsg(' Images will be Attached to the Signed Note.');
      End;
    NwsUnsigned:
      Begin
        {       Initialize Existing UnSigned Un-Signed Note}
        SetAbleToSignNote(True);
        SetAbleToMakeAddendum(False);
        SetAbleToOK(True);
        If Not Rgrp2NoteStatus.Visible Then Rgrp2NoteStatus.Visible := True;
        If Rgrp2NoteStatus.ItemIndex = -1 Then Rgrp2NoteStatus.ItemIndex := 0;
        LbActionDesc.caption := 'Attach Images to Selected Note:';

        WinMsg(' Images will be attached to the Selected Note.');
      End;
    NwsAddendum:
      Begin
       {       Initialize Addendum for Signed 'completed' Note}
        {Note: p129 dmmn 12/18/12 - did a search and see that this condition is never
        set nor executed.}
        SetAbleToMakeAddendum(True);
        SetAbleToSignNote(False);
        SetAbleToOK(True);
        LbActionDesc.caption := 'Create Addendum for Signed Note:';
        WinMsg(' Images will be attached to the New Addendum.');
      End;

  End;

    //
End;

Procedure TfrmCapTIU.SetAbleToSignNote(Value: Boolean);
Begin
  MnuSignNote.Enabled := Value;
  TbtnSignNote.Enabled := Value;
End;

Procedure TfrmCapTIU.SetAbleToMakeAddendum(Value: Boolean);
Begin {A signed Note is selected.}
  if value then if (FCurMlv.SelCount = 0)  then value := false;

  If PnlcbAddendum.Visible <> Value Then PnlcbAddendum.Visible := Value;
  If MnuAddendum.Enabled <> Value Then MnuAddendum.Enabled := Value;
  If Value Then
  Begin
        // anything here ?
  End
  Else
  Begin
    SetAreMakingAddendum(False);
  End;
End;

Procedure TfrmCapTIU.SetAreMakingAddendum(Value: Boolean);
//var h,h1 : integer;
Begin
    { we get here if the Menu Item Or Check Box is checked or Unchecked.
     We are still able to make Addendum, if not checked,  we just aren't.}
  If cbAddendum.Checked <> Value Then cbAddendum.Checked := Value;
  If MnuAddendum.Checked <> Value Then MnuAddendum.Checked := Value;
  If Value Then
  Begin
    If PnlListNotes.Height < 230 Then
          (* begin
           h := 230  - pnlListNotes.Height;
           if pnlPreview.Visible then
              begin
              if pnlpreview.Height - h < 40 then frmCapTiu.Height := frmCapTIU.Height + 40;
              pnlPreview.Height :=  pnlPreview.Height - h;
              end;

           end; *)
      If Rgrp2Addendum.ItemIndex = -1 Then Rgrp2Addendum.ItemIndex := 0;
  End
  Else
  Begin
    Rgrp2Addendum.ItemIndex := -1;
  End;
  PnlAddendum.Visible := Value;
  FAddendumToSignedNote := Value;

End;

Procedure TfrmCapTIU.cbAddendumClick(Sender: Tobject);
Begin
  SetAreMakingAddendum(cbAddendum.Checked);
End;

Procedure TfrmCapTIU.MnuAddendumClick(Sender: Tobject);
Begin
  MnuAddendum.Checked := Not MnuAddendum.Checked;
  SetAreMakingAddendum(MnuAddendum.Checked);
End;

Procedure TfrmCapTIU.Rgrp2NoteStatusClick(Sender: Tobject);
Begin
  Case Rgrp2NoteStatus.ItemIndex Of
    -1: FStatusUnSigned := 0;
    0: FStatusUnSigned := 0;
    1: FStatusUnSigned := 2;
    2: FStatusUnSigned := 1;
  End;
End;

Procedure TfrmCapTIU.Rgrp2AddendumClick(Sender: Tobject);
Begin
  Case Rgrp2Addendum.ItemIndex Of
    -1: FStatusAddendum := 0;
    0: FStatusAddendum := 0;
    1: FStatusAddendum := 2;
    2: FStatusAddendum := 1;
  End;
End;

Procedure TfrmCapTIU.Rgrp2NewNoteStatusClick(Sender: Tobject);
Begin
  Case Rgrp2NewNoteStatus.ItemIndex Of
    -1: FStatusNewNote := 0;
    0: FStatusNewNote := 0;
    1: FStatusNewNote := 2;
    2: FStatusNewNote := 1;
  End;
End;

Procedure TfrmCapTIU.FormPaint(Sender: Tobject);
Begin
  If btnOK.Top <> PnlOkCancel.Height - 27 Then btnOK.Top := PnlOkCancel.Height - 27;
  If btnCancel.Top <> PnlOkCancel.Height - 27 Then btnCancel.Top := PnlOkCancel.Height - 27;
End;

Procedure TfrmCapTIU.MlvNotesDrawItem(Sender: TCustomListView;
  Item: TListItem; Rect: Trect; State: TOwnerDrawState);

//var tbmp : Tbitmap;
//   arect : Trect;
Begin
(*  {This copied the arect from tbmp.canvas into the List view item.
    worked okay.}
arect.Top := 0;
arect.Left := 0;
arect.Right := 50;
arect.Bottom := 16;
tbmp := Tbitmap.Create;
tbmp.LoadFromFile('c:\temp\1.bmp');
image1.Picture.LoadFromFile('c:\temp\1.bmp');
mlvNotes.canvas.CopyRect(rect,tbmp.Canvas,arect);  *)
End;

Procedure TfrmCapTIU.MlvNotesGetSubItemImage(Sender: Tobject;
  Item: TListItem; SubItem: Integer; Var ImageIndex: Integer);
Var
  Stat: String;
Begin
//TESTING HERE WIDE GLYPHS IN LIST
// Can't have wide glyphs, then switch to text, the wide glyph space remains.
  Exit;

  If SubItem = 1 Then
  Begin
    Stat := Item.SubItems[SubItem];
  //item.SubItems[subitem] := '';
    If Lowercase(Stat) = 'completed' Then
      ImageIndex := 0
    Else
      If Lowercase(Stat) = 'unsigned' Then
        ImageIndex := 1
      Else
        If Lowercase(Stat) = 'uncosigned' Then
          ImageIndex := 2
  //else item.SubItems[subitem] := stat;
//  need a way to determine Efiled vs Signed
// if lowercase(stat) = 'completed'  and signed then  imageindex := 3;
// if lowercase(stat) = 'completed' and Efiled then  imageindex := 4;

  End;
 //item.SubItemImages[3] := 2;
End;

(*
Select TIU DOCUMENT DOCUMENT TYPE:    EYE OPTHALMOLOGY CONSULT
DOCUMENT TYPE: EYE OPTHALMOLOGY CONSULT//
PATIENT: IMAGING,PATIENT1031//
STATUS: COMPLETED// ?
 Do you want the entire 14-Entry TIU STATUS List? Y  (Yes)
   Choose from:
   ACTIVE
   AMENDED
   COMPLETED
   DELETED
   INACTIVE
   PURGED
   RETRACTED
   TEST
   UNCOSIGNED
   UNDICTATED
   UNRELEASED
   UNSIGNED
   UNTRANSCRIBED
   UNVERIFIED
 *)

Procedure TfrmCapTIU.ScbarTitlesKeyDown(Sender: Tobject; Var Key: Word;
  Shift: TShiftState);
Begin
//maggmsgf.MagMsg('','ScrollBar key ' + inttostr(key));
End;

procedure TfrmCapTIU.btnMoreClick(Sender: TObject);
begin
  GetMoreNotes;
end;

procedure TfrmCapTIU.GetMoreNotes();
Var
  TiuObj: TMagTIUData;
  i : integer;
  datastring : string;
  NextDtFrom, NextDtTo : string;
  XMSG : STRING ;
  FMDTTM : STRING;
begin
  try
  fdtfrom := '';
  mlvNotes.selected := nil;
  mlvUnSigned.Selected := nil;
  DisableAllButtons;
  Fupcount := 0;

  for i := mlvNotes.Items.Count-1 downto 0 do
    begin
    Fupcount := Fupcount +1;
    TiuObj := GetTIUObject(mlvNotes, mlvNotes.Items[i]);
    if FCapDevTest  then  showmessage('Dev TESTING ON' + #13 + #13 + ' TIUDA: ' + tiuobj.TiuDA);
    If (TiuObj = Nil) Or (TiuObj.TiuDA = '0') Then continue;
    if ((tiuobj.HasAddendums) or (tiuobj.IsAddendum)) then continue;

    fdtfrom := tiuobj.DispDT;

    if ( maglength(fdtfrom,' ') > 1)  then
      begin
        fdtfrom := magpiece(fdtfrom,' ',1) + '@' + magpiece(fdtfrom,' ',2);
        if Idmodobj.GetMagDBBroker1.RPFileManDate(Xmsg, fdtfrom, fmdttm, TRUE)
          {p129t17   also, the RPC needs to test for '^', and use 2nd piece if it exists }
          then fdtfrom := fmdttm   //magpiece(fmdttm,'^',2)
          else fdtFrom := tiuobj.DispDT;
      end;
    //NO NO MlvNotes.Selected := MlvNotes.items[i];
    //NO NO mlvNotes.ItemIndex := i;
    //NO NO  FLastItem := MlvNotes.Selected ;
    //NO NO mlvNotes.ScrollToItem(FlastItem);
    break;
  end; {for i   ... downto 0 do }
  if fdtfrom = '' then Raise Exception.Create('A valid Date could not be found.');

  fdtto :=   '01/01/1910';
  FAreAddingToNotesListing  := true;
  NotesByContext;
  except
  on e:exception do
    begin
      magappmsg('','Exception TIU List Data: ' + e.Message);
    end;
  end;
end;

Procedure TfrmCapTIU.Button2Click(Sender: Tobject);
Begin
  MlvTitles.Selected := MlvTitles.Items[3];
  MlvTitles.ItemFocused := MlvTitles.Items[3];
  MlvTitles.ScrollToItem(3);
  MlvTitles.SetFocus;
End;

Procedure TfrmCapTIU.MnuSignNoteClick(Sender: Tobject);
Begin
  SignUnsignedNote;
End;

procedure TfrmCapTIU.mnuTestShowColumnWidthsClick(Sender: TObject);
var
  i,tot,lstwidth : integer;
  s : string;

begin
tot := 0;
FTestingColumnWidths :=  FTestingColumnWidths +#13 + '--------------------------';
  for I := 0 to mlvNotes.columns.Count - 1 do
  begin
    s := '('+ inttostr(i) + ')' + inttostr(mlvnotes.Columns[i].Width);
    tot := tot + mlvnotes.Columns[i].Width;
    FTestingColumnWidths :=  FTestingColumnWidths + #13 + s ;
  end;
FTestingColumnWidths :=  FTestingColumnWidths + #13 + 'Total= ' + inttostr(tot) + '  List Width= ' + inttostr(mlvnotes.Width);
showmessage(FTestingColumnWidths);
end;

Procedure TfrmCapTIU.SpltListCanResize(Sender: Tobject;
  Var NewSize: Integer; Var Accept: Boolean);
Begin
(*
memnotetext.Lines.Add('----------------------');
memnotetext.Lines.Add('Client Ht    ' + inttostr(clientheight));
memnotetext.Lines.Add('list top     ' + inttostr(pnllistnotes.Top));
memnotetext.Lines.Add('list height  ' + inttostr(pnllistnotes.Height));
memnotetext.Lines.Add('top + ht     ' + inttostr(pnllistnotes.Top + pnllistnotes.Height ));
memnotetext.Lines.Add('Preview  top ' + inttostr(pnlpreview.top));
memnotetext.Lines.Add('Preview   Ht ' + inttostr(pnlpreview.height));
memnotetext.Lines.Add('top + ht     ' + inttostr(pnlpreview.Top + pnlpreview.Height ));
memnotetext.Lines.Add('new size     ' + inttostr(newsize));
memnotetext.Lines.Add('Cli Ht-49    ' + inttostr(clientheight - 49 ));
memnotetext.Lines.Add('NewSz + (tp+ht) ' + inttostr(newsize  + pnllistnotes.Top + pnllistnotes.Height ));
memnotetext.Lines.Add('CliHT-49-44-newsize - 250 - SplHeight - MinSize' + inttostr(clientheight - 49 - 44 - newsize - splitter1.Height -  250));
*)
  Accept := (ClientHeight - (ClientHeight - PnlPreview.Top - PnlPreview.Height) - PnlListNotes.Top - NewSize - SpltList.Height - PnlListNotes.Constraints.MinHeight) > 0;

//if accept then pnlNewText.Height := pnlpreview.Height;
End;

Procedure TfrmCapTIU.SpltTitleCanResize(Sender: Tobject;
  Var NewSize: Integer; Var Accept: Boolean);
Begin
(*
memNewNoteText.Lines.Add('----------------------');
memNewNoteText.Lines.Add('Client Ht    ' + inttostr(clientheight));
memNewNoteText.Lines.Add('list top     ' + inttostr(pnltitles.Top));
memNewNoteText.Lines.Add('list height  ' + inttostr(pnltitles.Height));
memNewNoteText.Lines.Add('top + ht     ' + inttostr(pnltitles.Top + pnltitles.Height ));
memNewNoteText.Lines.Add('Preview  top ' + inttostr(Panel5.top));
memNewNoteText.Lines.Add('Preview   Ht ' + inttostr(Panel5.height));
memNewNoteText.Lines.Add('top + ht     ' + inttostr(Panel5.Top + Panel5.Height ));
memNewNoteText.Lines.Add('new size     ' + inttostr(newsize));
memNewNoteText.Lines.Add('Cli Ht-49    ' + inttostr(clientheight - 49 ));
memNewNoteText.Lines.Add('NewSz + (tp+ht) ' + inttostr(newsize  + pnltitles.Top + pnltitles.Height ));
memNewNoteText.lines.add('CliHT-(h-t-h)-titletop-newsize - SplHeight - MinSize ' + inttostr(clientheight - (clientheight - Panel5.Top - panel5.Height) - pnltitles.Top - newsize - splitter4.Height - pnltitles.constraints.MinHeight));
*)
  Accept := (ClientHeight - (ClientHeight - PnlNewText.Top - PnlNewText.Height) - Pnltitles.Top - NewSize - SpltTitle.Height - Pnltitles.Constraints.MinHeight) > 0;
//if accept then pnlpreview.Height := pnlNewText.Height;
End;

Procedure TfrmCapTIU.ListOptions1Click(Sender: Tobject);
Begin
  GetListOptions;
End;

Procedure TfrmCapTIU.PnlPreviewResize(Sender: Tobject);
Begin
  PnlNewText.Height := PnlPreview.Height;
End;

Procedure TfrmCapTIU.PnlNewTextResize(Sender: Tobject);
Begin
  PnlPreview.Height := PnlNewText.Height;
End;

Procedure TfrmCapTIU.mlvGenericKeyUp(Sender: Tobject; Var Key: Word;
  Shift: TShiftState);
Begin
   FCurMlv := (Sender as TMagListView);
  If (Key = VK_Return) And (FCurMlv.Selcount > 0) Then
  Begin
    UnSelectOtherListItem;
    btnOK.SetFocus;
    Exit;
  End;
End;

End.
