unit fmagVerify;
{
 Package: MAG - VistA Imaging
WARNING: Per VHA Directive 10-93-142 this unit should not be modified.
Date Created:   Nov 10, 2008
Site Name: Silver Spring, OIFO
Developers: Garrett Kirin
[==   unit fmagVerify;
Description: Imaging QA Review Form.
      The Imaging QA Review Form is designed as a Utility for users to Validate the Data for an Image.
      It's main funtions are
      - Have an asy way to list images scanned/captured by a certain user in a certain data range.
      - Display the Image and relevant data for the user to view.
        Relevant Data for the image is the Patient, and Index Field values.  The values for these fields are
        displayed in easy to view area of the form.

      - Easy for user to mark the Image as 'Verified' or 'QA Reviewed' if the image data is correct
      or to mark the Image as 'Needs Review' if the data for the image is not correct.
      Images marked as 'Needs Review' will not be viewable by users of VistA Imaging
      Display, unless a certain Security Key is held by the user (currently the Key : MAG EDIT, is needed)


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
interface

uses
  Buttons,
  Classes,
  cMag4Viewer,
  cMagImageList,
  cMagListView,
  cMagPat,
  cMagViewerTB8,
  ComCtrls,
  Controls,
  ExtCtrls,
  fmagfocus,
  Forms,
  Graphics,
  imaginterfaces,
  Menus,
  StdCtrls,
  umagclasses,
  umagDefinitions, ImgList
  ,   cmagdbbroker    //117 frmVerify needs to get Pat info from Local DB
  ;



//Uses Vetted 20090929:ImgList, TypInfo, inifiles, ToolWin, Variants, Messages, maggut9, fmagdaterange, umagkeymgr, umagdisplaymgr, umagutils, magpositions, dateutils, Dialogs, SysUtils, Windows

type
    TfrmVerify = class(TForm, ImagObserver)
        magImageList1: TmagImageList;
        pnlViewer: TPanel;
        StatusBar1: TStatusBar;
        Mag4Pat1: TMag4Pat;
        MainMenu1: TMainMenu;
        File1: TMenuItem;
        mnuExit1: TMenuItem;
        Help1: TMenuItem;
        Help2: TMenuItem;
        Mag4Viewer1: TMag4Viewer;
        Options1: TMenuItem;
        mnuSelectColumns: TMenuItem;
        pnlLeft: TPanel;
        pnlAllPatMessage: TPanel;
        pnlQuickFilter: TPanel;
        pnlSelectedImageInfo: TPanel;
        lbSelectedImageInfo: TLabel;
        pnlInfo: TPanel;
        cmbUsers: TComboBox;
        lbCapBy: TLabel;
        magViewerTB1: TmagViewerTB8;
        mnuImageStatusToNeedsReview: TMenuItem;
        mnuImageStatusToVerified: TMenuItem;
        lvInfoImageVerify: TListView;
        splpnlinfo: TSplitter;
        mnuSingleImageinViewer: TMenuItem;
        mnuRefreshImageList: TMenuItem;
        mnuFilterDetails: TMenuItem;
        splLeft: TSplitter;
        pnlReport: TPanel;
        splpnlreport: TSplitter;
        mnuPreviewReport22: TMenuItem;
        memReport: TMemo;
        pnlProcessImage: TPanel;
        lbSyncedPatName: TLabel;
        lbSyncStatus: TLabel;
        lbSyncType: TLabel;
        lbSyncSpec: TLabel;
        lbSyncProc: TLabel;
        lbStatus: TLabel;
        lbType: TLabel;
        lbSpec: TLabel;
        lbProc: TLabel;
        lbPatient: TLabel;
        mnuPreviewInfo: TMenuItem;
        Bevel1: TBevel;
        Bevel3: TBevel;
        Bevel4: TBevel;
        mnuQAImageIndexEdit: TMenuItem;
        mnuQAImageInfoAdv: TMenuItem;
        imgInfoBar: TImage;
        lbInfoHeader: TLabel;
        imgRptBar: TImage;
        lbReportHeader: TLabel;
        imgSelectedImageInfo: TImage;
        mnuFitcolumnstotext: TMenuItem;
        mnuFitcolumnstowindow: TMenuItem;
        Bevel2: TBevel;
        pnlVerify: TPanel;
        Bevel6: TBevel;
        mnuMainFilter1: TMenuItem;
        mnuSelectFilter1: TMenuItem;
        lbDateRange: TLabel;
        lbWithStatus: TLabel;
        lbVerifyStatus: TLabel;
        btnStatusSelect: TBitBtn;
        btnSearch: TBitBtn;
        cmbDateRange: TComboBox;
        imgAllPatMessage: TImage;
        lbAllPatMessage: TLabel;
        ImgFilterDesc: TImage;
        imgDownButton: TImage;
        imgUpButton: TImage;
        lbFilterDesc: TLabel;
        N8: TMenuItem;
        mnupopVerifyImage: TPopupMenu;
        mnuImageStatusToVerified1: TMenuItem;
        mnuNext1: TMenuItem;
        mnuPrevious1: TMenuItem;
        N9: TMenuItem;
        mnuImageStatusToNeedsReview1: TMenuItem;
        ImageList1: TImageList;
        pnlimgPrev: TPanel;
        imgPrev: TImage;
        lbimgPrev: TLabel;
        pnlimgNext: TPanel;
        imgNext: TImage;
        lbimgNext: TLabel;
        imgNextoutline: TImage;
        imgPrevOutline: TImage;
        pnlimgVerify: TPanel;
        imgVerify: TImage;
        imgVerifyOutline: TImage;
        lbimgVerify: TLabel;
        imgRptDownButton: TImage;
        imgRptUpButton: TImage;
        imgInfoDownButton: TImage;
        imgInfoUpButton: TImage;
        mnuAction: TMenuItem;
        mnuNext2: TMenuItem;
        mnuPrev2: TMenuItem;
        N11: TMenuItem;
        mnuQuickFilter1: TMenuItem;
        lbNoRad: TLabel;
        btnVerify: TButton;
        btnNext: TButton;
        btnPrev: TButton;
        Bevel7: TBevel;
        Timer1: TTimer;
        mnuOverlayImageInfo1: TMenuItem;
        mnuClearWindow1: TMenuItem;
        SaveColumns1: TMenuItem;
        GetColumnset1: TMenuItem;
        N2: TMenuItem;
        MagListViewVerify: TMagListView;
        N3: TMenuItem;
        ilMain16n: TImageList;
        Image1: TImage;
        lbSyncStatusReason: TLabel;
        lbReason: TLabel;
        N1: TMenuItem;
        cmbPercent: TComboBox;
        cmbMaxNum: TComboBox;
        Label1: TLabel;
        Label2: TLabel;
        N4: TMenuItem;
        mnuCapAppVICap: TMenuItem;
        mnuCapAppIAPI: TMenuItem;
        N5: TMenuItem;
        mnuImageStatusReport: TMenuItem;
        bvFilter: TBevel;
        mnuImage: TMenuItem;
        mnuZoom1: TMenuItem;
        mnuMouse1: TMenuItem;
        mnuRotate1: TMenuItem;
        mnuContrastBrightness1: TMenuItem;
        mnuInvert1: TMenuItem;
        mnuReset1: TMenuItem;
        mnuScroll1: TMenuItem;
        mnuMaximizeImage1: TMenuItem;
        mnuPreviousImage1: TMenuItem;
        mnuNextImage1: TMenuItem;
        N7: TMenuItem;
        ZoomIn1: TMenuItem;
        ZoomOut1: TMenuItem;
        FitToWidth1: TMenuItem;
        FitToHeight1: TMenuItem;
        FitToWindow1: TMenuItem;
        ActualSize1: TMenuItem;
        Pan1: TMenuItem;
        Magnify1: TMenuItem;
        Zoom2: TMenuItem;
        Pointer1: TMenuItem;
        Right1: TMenuItem;
        Left1: TMenuItem;
        N1801: TMenuItem;
        FlipHorizontal1: TMenuItem;
        FlipVertical1: TMenuItem;
        Contrast1: TMenuItem;
        Contrast2: TMenuItem;
        Brightness1: TMenuItem;
        Brightness2: TMenuItem;
        opLeft1: TMenuItem;
        opRight1: TMenuItem;
        BottomLeft1: TMenuItem;
        BottomRight1: TMenuItem;
        Left2: TMenuItem;
        Right2: TMenuItem;
        Up1: TMenuItem;
        Down1: TMenuItem;
        ShortcutKeylegend1: TMenuItem;
        N12: TMenuItem;
        mnuHideToolbar: TMenuItem;
        hiddenShortCutMenu1: TMenuItem;
        N13: TMenuItem;
        mnuQAImageDelete: TMenuItem;
        N14: TMenuItem;
        N15: TMenuItem;
        ImageDelete2: TMenuItem;
        ImageInformationAdvanced1: TMenuItem;
        N10: TMenuItem;
        ImageIndexEdit1: TMenuItem;
        mnuVerifyTestMenu: TMenuItem;
        GenNextControl1: TMenuItem;
        oggleMemo1: TMenuItem;
        lbedtDateRange: TLabel;
        btnCapBy: TButton;
        FocusRect1: TMenuItem;
        TimerFade: TTimer;
        mnuTestAutoFocusRect: TMenuItem;
    mnuOptionsMessageWindow: TMenuItem;
    {/gek 117  controls for 117 functions.}
    pnlGroupAbs: TPanel;
    VerifyWinGrpAbsViewer: TMag4Viewer;
    magImageList2: TmagImageList;
    lbShortDesc: TLabel;
    lbSyncShortDesc: TLabel;
    lbSSN: TLabel;
    lbSyncSSN: TLabel;
    mnuGroupViewer: TPopupMenu;
    mnuAbsRefresh: TMenuItem;
    mnuAbsResize: TMenuItem;
    mnuAbsToolbar: TMenuItem;
        procedure FormCreate(Sender: TObject);
        procedure mnuSelectColumnsClick(Sender: TObject);
        procedure FormClose(Sender: TObject; var Action: TCloseAction);
        procedure Mag4Viewer1ViewerImageClick(sender: TObject);
        procedure FormPaint(Sender: TObject);
        procedure mnuImageStatusToNeedsReviewClick(Sender: TObject);
        procedure mnuImageStatusToVerifiedClick(Sender: TObject);
        procedure FormDestroy(Sender: TObject);
        procedure MagListViewVerifySelectItem(Sender: TObject; Item: TListItem;
            Selected: Boolean);
        procedure mnuSingleImageinViewerClick(Sender: TObject);
        procedure mnuRefreshImageListClick(Sender: TObject);
        procedure mnuFilterDetailsClick(Sender: TObject);
        procedure mnuPreviewReport22Click(Sender: TObject);
        procedure mnuPreviewInfoClick(Sender: TObject);
        procedure pnlReportResize(Sender: TObject);
        procedure pnlInfoResize(Sender: TObject);
        procedure Options1Click(Sender: TObject);
        procedure mnuFitcolumnstotextClick(Sender: TObject);
        procedure mnuFitcolumnstowindowClick(Sender: TObject);
        procedure mnuSelectFilter1Click(Sender: TObject);
        procedure imgDownButtonClick(Sender: TObject);
        procedure imgUpButtonClick(Sender: TObject);
        procedure btnStatusSelectClick(Sender: TObject);
        procedure Label4MouseEnter(Sender: TObject);
        procedure Label4MouseLeave(Sender: TObject);
        procedure btnSearchClick(Sender: TObject);
        procedure mnuImageStatusToVerified1Click(Sender: TObject);
        procedure mnuNext1Click(Sender: TObject);
        procedure mnuPrevious1Click(Sender: TObject);
        procedure mnuImageStatusToNeedsReview1Click(Sender: TObject);
        procedure lbimgNextMouseEnter(Sender: TObject);
        procedure lbimgNextMouseLeave(Sender: TObject);
        procedure lbimgNextClick(Sender: TObject);
        procedure lbimgPrevClick(Sender: TObject);
        procedure lbimgPrevMouseEnter(Sender: TObject);
        procedure lbimgPrevMouseLeave(Sender: TObject);
        procedure imgVerifyClick(Sender: TObject);
        procedure lbimgVerifyClick(Sender: TObject);
        procedure lbimgVerifyMouseEnter(Sender: TObject);
        procedure lbimgVerifyMouseLeave(Sender: TObject);
        procedure imgRptUpButtonClick(Sender: TObject);
        procedure imgRptDownButtonClick(Sender: TObject);
        procedure imgInfoDownButtonClick(Sender: TObject);
        procedure imgInfoUpButtonClick(Sender: TObject);
        procedure mnuNext2Click(Sender: TObject);
        procedure mnuPrev2Click(Sender: TObject);
        procedure VerifyAndNext;
        procedure btnVerifyClick(Sender: TObject);
        procedure btnNextClick(Sender: TObject);
        procedure btnPrevClick(Sender: TObject);
        procedure Timer1Timer(Sender: TObject);
        procedure mnuOverlayImageInfo1Click(Sender: TObject);
        procedure mnuClearWindow1Click(Sender: TObject);
        procedure mnuQuickFilter1Click(Sender: TObject);
        procedure SaveColumns1Click(Sender: TObject);
        procedure GetColumnset1Click(Sender: TObject);
        procedure mnuExit1Click(Sender: TObject);
        procedure mnuQAImageIndexEditClick(Sender: TObject);
        procedure mnuMainFilter1Click(Sender: TObject);
        procedure MagListViewVerifyChanging(Sender: TObject; Item: TListItem;
            Change: TItemChange; var AllowChange: Boolean);
        procedure mnuActionClick(Sender: TObject);
        procedure cmbPercentChange(Sender: TObject);
        procedure cmbMaxNumChange(Sender: TObject);
        procedure FormShow(Sender: TObject);
        procedure ZoomIn1Click(Sender: TObject);
        procedure ZoomOut1Click(Sender: TObject);
        procedure FitToWidth1Click(Sender: TObject);
        procedure FitToHeight1Click(Sender: TObject);
        procedure FitToWindow1Click(Sender: TObject);
        procedure ActualSize1Click(Sender: TObject);
        procedure Pan1Click(Sender: TObject);
        procedure Magnify1Click(Sender: TObject);
        procedure Zoom2Click(Sender: TObject);
        procedure Pointer1Click(Sender: TObject);
        procedure Right1Click(Sender: TObject);
        procedure Left1Click(Sender: TObject);
        procedure N1801Click(Sender: TObject);
        procedure FlipHorizontal1Click(Sender: TObject);
        procedure FlipVertical1Click(Sender: TObject);
        procedure Contrast1Click(Sender: TObject);
        procedure Contrast2Click(Sender: TObject);
        procedure Brightness1Click(Sender: TObject);
        procedure Brightness2Click(Sender: TObject);
        procedure mnuInvert1Click(Sender: TObject);
        procedure mnuReset1Click(Sender: TObject);
        procedure opLeft1Click(Sender: TObject);
        procedure opRight1Click(Sender: TObject);
        procedure BottomLeft1Click(Sender: TObject);
        procedure BottomRight1Click(Sender: TObject);
        procedure Left2Click(Sender: TObject);
        procedure Right2Click(Sender: TObject);
        procedure Up1Click(Sender: TObject);
        procedure Down1Click(Sender: TObject);
        procedure mnuMaximizeImage1Click(Sender: TObject);
        procedure mnuPreviousImage1Click(Sender: TObject);
        procedure mnuNextImage1Click(Sender: TObject);
        procedure mnuImageClick(Sender: TObject);
        procedure ShortcutKeylegend1Click(Sender: TObject);
        procedure mnuHideToolbarClick(Sender: TObject);
        procedure hiddenShortCutMenu1Click(Sender: TObject);
        procedure mnuImageStatusReportClick(Sender: TObject);
        procedure mnuQAImageInfoAdvClick(Sender: TObject);
        procedure mnuQAImageDeleteClick(Sender: TObject);
        procedure ImageDelete2Click(Sender: TObject);
        procedure ImageInformationAdvanced1Click(Sender: TObject);
        procedure mnuCapAppVICapClick(Sender: TObject);
        procedure mnuCapAppIAPIClick(Sender: TObject);
        procedure ImageIndexEdit1Click(Sender: TObject);
        procedure MagListViewVerifyEnter(Sender: TObject);
        procedure cmbDateRangeExit(Sender: TObject);
        procedure cmbUsersClick(Sender: TObject);
        procedure cmbDateRangeKeyDown(Sender: TObject; var Key: Word;
            Shift: TShiftState);
        procedure cmbDateRangeEnter(Sender: TObject);
        procedure cmbDateRangeSelect(Sender: TObject);
        procedure MagListViewVerifyKeyDown(Sender: TObject; var Key: Word;
            Shift: TShiftState);
        procedure GenNextControl1Click(Sender: TObject);
        procedure btnCapByClick(Sender: TObject);
        procedure cmbUsersSelect(Sender: TObject);
        procedure File1Click(Sender: TObject);
        procedure btnVerifyEnter(Sender: TObject);
        procedure btnVerifyExit(Sender: TObject);
        procedure btnNextEnter(Sender: TObject);
        procedure btnNextExit(Sender: TObject);
        procedure btnPrevEnter(Sender: TObject);
        procedure btnPrevExit(Sender: TObject);
        procedure FocusRect1Click(Sender: TObject);
        procedure TimerFadeTimer(Sender: TObject);
        procedure mnuTestAutoFocusRectClick(Sender: TObject);
        procedure btnCapByEnter(Sender: TObject);
        procedure cmbUsersEnter(Sender: TObject);
        procedure cmbPercentEnter(Sender: TObject);
        procedure cmbMaxNumEnter(Sender: TObject);
        procedure Help2Click(Sender: TObject);
    procedure mnuOptionsMessageWindowClick(Sender: TObject);
    {/gek //117}
    procedure VerifyWinGrpAbsViewerViewerImageClick(sender: TObject);
    procedure mnuGroupViewerPopup(Sender: TObject);
    procedure mnuAbsToolbarClick(Sender: TObject);
    procedure mnuAbsRefreshClick(Sender: TObject);
    procedure mnupopVerifyImagePopup(Sender: TObject);
    private

        xImageObj: TimageData;      {/gek 117}
        FMagDBBroker: TMagDBBroker; {/gek 117}
        FMyFocusWin: TfrmFocus;
        FLastActiveControl: Twincontrol;
        FUseFocusRectangle: boolean;
        FlstDisplayDateRange: Tstrings;
        FPreviousDateRange: string;
        FlvVerifyInfoTopIndex: integer;
        FDuz: string; {JK 1/2/2009 - fixed defect #36. Added fduz variable.
        gek 5/5  made it private, form now opens with Execute method
        and Duz is a Parameter.}
        FVerifyHideQFonSearch: boolean;
        FQuickFilterUsed: boolean;
        FImageList: TImageList; // icons for list.
        FoldCursor: TCursor;
        FDisplaying: boolean;
        FDateFrom,
            FDateTo: string;

        FfirstPaintIsDone: boolean;
        FCurrentFilterVerifyWin: TImageFilter;
        FCurrentImageObjectVerify: TImageData;
        FCurrentImageProp: Tstrings;
        FDeletedThisSession : Tstrings;
        //
        procedure RefreshGroupVerify();  //117  update the status's on the group images in abs viewer
        function  IsDeletedThisSession(FCurrentImageObjectVerify : TImageData) : boolean;
        procedure Update_(subjectstate: string; sender: TObject);
        procedure ClearWindow;
        procedure GetFilter;
        procedure winmsg(pnl: integer; pnlmsg: string = '');
        procedure MarkImageAsVerified;
        procedure MarkImageAsNeedsReview();
        procedure SelectNextImage;
        procedure SelectPrevImage;
        function AreSelectionsSynced(): boolean;
        procedure FilterDetailsInInfoWindow2;

        procedure QFConvertSelectedDateRangeToDates(var dtfrom, dtto: string);
        procedure QFConvertSelectedUserToDUZ(var duz: string);
        procedure QFGetSelectedStatus(var status: string);
        procedure QFGetImagesforSelectProperties(dtfrom, dtto, user, status: string);
        procedure ShowQuickFilterPanel(value: boolean);
        procedure ShowImageReport(value: boolean);
        procedure ShowImageInfo(value: boolean);
        procedure QFGetCaptureUsersInDateRange(dtfrom, dtto: string);
        //        procedure ClearCaptureUsers;
        procedure SetProcessButtons();
        procedure CursorGetHG;
        procedure CursorGetOld;
        procedure DateRangeChange(var rangetext: string);
        function GetImageInfoForHeader(vIobj: TImageData): string;
		{/117  modify so we can get internal or external.}
        function GetImageProperty(prop: string; internal : boolean = false): string;
        procedure ClearAllPropertyFields;
        procedure SetAllPropertyFields;
        procedure ClearImageHeader;
        procedure ClearImageOverlay;
        procedure ClearImageProperties;
        procedure ClearImageReport;
        procedure ToggleOverlay;
        procedure SetImageHeader;
        procedure SetImageInformation;
        procedure SetImageOverlay;
        procedure SetImageProperties;
        procedure SetImageReport;
        procedure SetCurrentImageData(Iobj: TimageData);
        procedure QFFillDateRangeDropDown;
        procedure WinMsgClear;
        procedure PreviewInfo(value: boolean);
        procedure PreviewReport(value: boolean);
        procedure ViewSelectedListItem(Sender: TObject; Item: TListItem; Selected: Boolean);
        function IsQuickPanelOpen: boolean;
        procedure UpdateVerifyFilteredImageList;
        function HaveValidCurrentImageObject: boolean;
        procedure CurrentVerifyImageIndexEdit;
        procedure ClearImageInfoControlVerify;
        procedure ReSetTopIndexVerify;
        procedure SaveTopIndexVerify;
        procedure CurrentImageDeleteVerify;
        procedure AlertSearchPropertyChange(value: boolean);
        procedure StatusSelect;
        procedure GetDateRange;
        procedure GenGoToNextControl(edt: TWinControl = nil);

        procedure CaptureUsersNone;

        procedure CaptureUsersRefreshNeeded;
        procedure ToggleEnableQFButtons(val: boolean);
        procedure MoveRectangleToFocusControl;
        procedure ShowFocusControlRect;
{	//p94 local function.}
    function DetailedDescStringGen(filter: TImagefilter): string;
{/117   Group abs so user can verify each image in group.}
    procedure ShowGroupAbs(xIobj : TImageData) ;  //117
    function AreViewingGroup: boolean;            //117
    procedure SetDefaultFullViewerAlignment;      //117
    procedure SetDefaultThumbNailAlignment;       //117

        //    procedure ColumnSetApply(lv : Tmaglistview; value: string);
          //  procedure ColumnSetSave(lv: Tmaglistview);
          //  function ColumnSetGet(): string;

            { Private declarations }
    public
        FPreviewInfoVerify,
            FPreviewReportVerify,
            FViewSingleImage: boolean;

        FSyncInProgress: boolean;
{/117 decouple from dmsingle, so magDBBroker is sent.}
        procedure execute(upref: TUserpreferences; duz: string; vMagDBBroker : TMagDBBroker);
        function IsQuickFilterOpen(): boolean;
        procedure UserPrefUpdate;
        procedure UserPrefsApply(upref: Tuserpreferences);

        {JK 4/6/2009 - 508 work}
        procedure ActiveControlChanged(Sender: TObject);
        procedure EnterColor(Sender: TWinControl);
        procedure ExitColor(Sender: TWinControl);
        procedure SetInitialFocus;
    end;

var
    frmVerify: TfrmVerify;
const
{/117  constants for status panel bar.  which status panel to display message}
    stpnlct: integer = 0;
    stpnlmid : integer = 1;
    stpnlmsg: integer = 2;

implementation

uses
  dateutils,
  Dialogs,
  dmSingle,
  fmagdaterange,
  fMagFMSetSelect,
  fmagGenOverlay,
  fmagindexedit,
  fmagListFilter,
  fmagReasonSelect,
  MaggMsgu,
// p94t3 gek        maggut9,
  magpositions,
  SysUtils,
 // umagdisplaymgr,
  fmagimageinfosys,
  umagkeymgr,
  umagutils8,
  umagutils8B,
  fmagIconLegend,
  Windows
  , fmagVerifyStats,
    fMagReportMgr {P117 - JK 8/30/2010 /};



//Uses Vetted 20090929:fMagImageInfoSys, fmagImageList, fmagDialogSelection, fmagDialogSaveAs,

{$R *.dfm}
var
    lastFocused: TWinControl;
    dtfrom, dtto: string; {JK 6/1/2009 - need to see this globally for the verification report}

procedure TfrmVerify.SetInitialFocus;
begin
    cmbDateRange.SetFocus;
end;

procedure TfrmVerify.ActiveControlChanged(Sender: TObject);
var
    doEnter, doExit: boolean;
    previousActiveControl: TWinControl;
begin

    if FLastActiveControl <> nil then
        if FLastActiveControl.Name = screen.ActiveControl.Name then
            exit;
    FLastActiveControl := screen.activecontrol;
    try
        if screen.ActiveControl.Name <> '' then
        begin
            winmsg(stpnlmsg, 'Active Control : ' + screen.ActiveControl.Name);
            //

            if screen.ActiveControl.Name = 'PageScroller1' then
            begin
                cmbDateRange.SetFocus;
                //winmsg(stpnlmsg,' cmbDateRange.SetFocus' ) ;
                exit;
            end;

            if not FUseFocusRectangle then
                exit;
{$IFDEF DEBUG}
            MoveRectangleToFocusControl;
            FMyFocusWin.Visible := true;
            TimerFade.Enabled := true;
{$ENDIF}            
        end
        else
        begin
            winmsg(stpnlmsg, 'Active Control :  No Name');
        end;

    except
        //
    end;


    (*  try
          if Screen.ActiveControl = nil then
          begin
              lastFocused := nil;
              Exit;
          end;

          doEnter := true;
          doExit := true;

          previousActiveControl := lastFocused;

          lastFocused := Screen.ActiveControl;

          if doExit then
              ExitColor(previousActiveControl);
          if doEnter then
              EnterColor(lastFocused);
      except
          on E: Exception do
              DebugFile('TfrmVerify.ActiveControlChanged error = ' + E.Message);
      end;
      *)
end;

procedure TfrmVerify.EnterColor(Sender: TWinControl);
begin
    {JK 4/16/2009 - added csDesigning to quiet an exception condition}
    try
        if Sender <> nil then
        begin
            //if csDesigning in Sender.ComponentState then
            if (Sender is TButton) then
                if TButton(Sender).Name = 'btnVerify' then
                    imgVerifyOutline.Visible := not imgVerifyOutline.Visible
                else if TButton(Sender).Name = 'btnPrev' then
                    imgPrevOutline.Visible := not imgPrevOutline.Visible
                else if TButton(Sender).Name = 'btnNext' then
                    imgNextOutline.Visible := not imgNextOutline.Visible;

        end;
    except
        on E: Exception do
            DebugFile('TfrmVerify.EnterColor error = ' + E.Message);
    end;
end;

procedure TfrmVerify.ExitColor(Sender: TWinControl);
begin
    {JK 4/16/2009 - added csDesigning to quiet an exception condition}
    try
        if Sender <> nil then
        begin
            //if csDesigning in Sender.ComponentState then
            if (Sender is TButton) then
                if TButton(Sender).Name = 'btnVerify' then
                    imgVerifyOutline.Visible := not imgVerifyOutline.Visible
                else if TButton(Sender).Name = 'btnPrev' then
                    imgPrevOutline.Visible := not imgPrevOutline.Visible
                else if TButton(Sender).Name = 'btnNext' then
                    imgNextOutline.Visible := not imgNextOutline.Visible
        end;
    except
        on E: Exception do
            DebugFile('TfrmVerify.ExitColor error = ' + E.Message + ' name = ' +
                Sender.ClassName);
    end;
end;

procedure TfrmVerify.Update_(subjectstate: string; sender: TObject);
var
    i: integer;
    Iobj: Timagedata;
    premsg: string;
    //  vCCOWState : byte;
begin
    premsg := '';
    if application.Terminated then
        exit;
{/gek p117  get rid of dependency .  No need to know of a DMOD component.}
    if (sender <> self.magImageList1) then exit;

(*   /117 get rid of dependency on dmsingle.
 if (sender = dmod.CCOWManager) then
    begin
        exit;
    end;
*)
    {   Subject is being destroyed}
    if (SubjectState = '-1') then
        exit;
    if (SubjectState = '') then
    begin
        self.MagListViewVerify.ClearItems;
        {/p117 // next 3 lines to clear Abs Window and Image Viewer when list is cleared.}
        self.Mag4Viewer1.ClearViewer;
        self.VerifyWinGrpAbsViewer.ClearViewer;
        self.pnlGroupAbs.Enabled := false;
        {/ end}
        winmsg(stpnlct, '');
        exit;
    end;
    if copy(SubjectState, 1, 1) = '0' then
    begin
        premsg := '0 Images: ';
        if FCurrentFilterVerifyWin = nil then
        begin
            lbFilterDesc.Caption := 'No Filter selected.';
            winmsg(stpnlct, '');
            winmsg(stpnlmid, '');
            exit;
        end;
{	//p94 local function.}
        if Self.FQuickFilterUsed then
            lbFilterDesc.Caption := premsg + self.DetailedDescStringGen(FCurrentFilterVerifyWin)
        else
            lbFilterDesc.Caption := Premsg + ' Filter in use: ' +
                FCurrentFilterVerifyWin.Name;
        {JK 1/6/2009 - Simplifies display of filter information}
        winmsg(stpnlct, inttostr(magimagelist1.Objlist.Count));
        winmsg(stpnlmsg, magImageList1.ListName); //magImageList1. ListDesc;
        exit;
    end;
    { update MagListView1 with the new image list}
    { Change the 'site' column and data to 'Patient' column and data will be patient name.}
    magimagelist1.SiteToPatName;

    {JK 6/5/2009 - Only load the listview if the date and a captured by user are selected first}
    if (cmbUsers.Text <> '<select a user>') and (cmbUsers.Text <> '') and (FCurrentFilterVerifyWin <> nil)
        then
    begin
        maglistviewVerify.LoadListFromMagImageList(magimagelist1.BaseList, magimagelist1.Objlist);
        maglistviewVerify.SetFocus;
    end;
    if FCurrentFilterVerifyWin <> nil then
        if self.FQuickFilterUsed then
            lbFilterDesc.Caption := inttostr(maglistviewverify.Items.Count) +
                ' Image(s): ' + self.DetailedDescStringGen(FCurrentFilterVerifyWin)
        else
            lbFilterDesc.Caption := IntToStr(maglistviewverify.Items.Count) +
                ' Image(s). Filter in use: ' + FCurrentFilterVerifyWin.Name;
    {JK 1/6/2009 - Simplifies display of filter information}

    lbFilterDesc.Update;
end;


{/gek p117  new param to decouple from dmsingle.}
procedure TfrmVerify.Execute(upref: TUserpreferences; duz: string; vMagDBBroker : TMagDBBroker);
begin
    Application.CreateForm(TfrmVerify, frmVerify);
{	//p94 local function.}
    frmVerify.UserPrefsApply(upref); //p94t3  gek   upreftoVerifywin(upref);
    frmVerify.FMagDBBroker := vMagDBBroker;  //117
    Application.ProcessMessages;
    frmVerify.fduz := duz; {JK 1/2/2009 - fixed defect #36}
    frmVerify.ShowModal;
    frmVerify.UserPrefUpdate;
    frmVerify.Free;
    screen.Cursor := crdefault;
    application.ProcessMessages;
end;

procedure TfrmVerify.FormCreate(Sender: TObject);
var
    txt: string;
begin
    application.createform(TfrmFocus, FMyFocusWin);
    FMyFocusWin.Parent := self;
    FMyFocusWin.TransparentColor := true;
    FMyFocusWin.TransparentColorValue := clFuchsia;
    FMyFocusWin.AlphaBlend := true;
    FMyFocusWin.AlphaBlendValue := 255;
{/p117  gek  117 controls }
    pnlGroupAbs.align := albottom;
    VerifyWinGrpAbsViewer.Align := alclient;
    VerifyWinGrpAbsViewer.FRightClickOpen := true;         //117 test
    SetDefaultFullViewerAlignment;
    SetDefaultThumbNailAlignment;
    VerifyWinGrpAbsViewer.SetShowImageStatus(true);  {/117 gek, User needs to see status.}
    {SET the FIgnoreBlock field to true, so we see abstracts.}
    VerifyWinGrpAbsViewer.FIgnoreBlock := true;  {/117 gek allows blocked Abstracts to be viewed.}
    { show the Full value as the Hint.  So if value is too long to be seen, user
      can move mouse over to see it.}
    pnlProcessImage.ShowHint := true;
//117 end
    FLastActiveControl := nil;
    FUseFocusRectangle := false;
    mnuVerifyTestMenu.Visible := false;
{$IFDEF debug}
    //mnuVerifyTestMenu.Visible := true;
{$ENDIF}
    FlstDisplayDateRange := Tstringlist.Create;
    FlvVerifyInfoTopIndex := 0;
    GetFormPosition(self as Tform);
    {JK 4/6/2009 - 508 work}
//    Screen.OnActiveControlChange := ActiveControlChanged;

    FQuickFilterUsed := false;
    QFFillDateRangeDropDown;
    FCurrentImageObjectVerify := TImageData.Create;
    FCurrentImageProp := tstringlist.Create;
    FDeletedThisSession:= tstringlist.Create;
    {   This will hide the buttons, but enable the 'Alt- ' shortcut to work.}
    btnPrev.Width := 0;
    btnNext.Width := 0;
    btnVerify.Width := 0;

    FoldCursor := crdefault;
    mnuImageStatusToVerified.ShortCut := shortcut(ord('Q'), [ssCtrl, ssAlt]);
    mnuImageStatusToNeedsReview.ShortCut := shortcut(ord('R'), [ssCtrl, ssAlt]);
    mnuQAImageIndexEdit.ShortCut := shortcut(ord('E'), [ssCtrl, ssAlt]);
    {  Need a new Short Cut, Shift-Ctrl - N is brightness...  ?
        for now, we'll leave off.
        Because on this window.  Alt - N, and Alt - P work. }
    //mnuNext2.ShortCut := shortcut(ord('N'),[ssShift,ssCtrl]);
    //mnuPrev2.ShortCut := shortcut(ord('P'),[ssShift,ssCtrl]);

    color := FSAppBackGroundColor;
    pnlverify.Color := FSAppBackGroundColor;
    pnlimgVerify.ParentColor := true;
    pnlimgNext.ParentColor := true;
    pnlimgPrev.ParentColor := true;

    FPreviewInfoVerify := true;
    FPreviewReportVerify := true;
    ShowImageInfo(False);
    ShowImageReport(false);
    FViewSingleImage := true;
    mag4Viewer1.ClearBeforeAddDrop := true;
    memReport.Align := alclient;

    DebugUseOldImageListCall := false;
    FCurrentFilterVerifyWin := nil;

    lvInfoImageVerify.Align := alclient;

    mag4pat1.M_DBBroker := dmod.MagDBBroker1;
    magImageList1.MagDBBroker := dmod.MagDBBroker1;
    magimagelist1.Attach_(self as ImagObserver);
    magimagelist1.MagPat := mag4pat1;
//117
//    magimagelist1.FExpandGroups := true;
    magviewerTB1.MagViewer := mag4viewer1;
    maglistviewVerify.Align := alclient;
    mag4viewer1.Align := alclient;
    pnlviewer.align := alclient;
    mag4Viewer1.MagSecurity := dmod.MagFileSecurity;
    mag4Viewer1.MagUtilsDB := dmod.MagUtilsDB1;

    setProcessButtons();
    // Now in paint...     DateRangeChange(txt);  {This will populate the User List for the Date. (Today)}
     // Application.CreateForm(TfrmGenOverlay, frmGenOverlay);

    self.magViewerTB1.PageScroller1.TabStop := false;
    self.magViewerTB1.PageScroller2.TabStop := false;
end;

procedure TfrmVerify.GetFilter;
var
    vfilter, oldfilter: TImageFilter;
    //-duz : string;  {JK 1/2/2009 - fixed defect #36. Removed local duz variable.}
begin
    with frmVerify do
    begin
        lbFilterDesc.Caption := ' Waiting for Filter...';
        lbFilterDesc.Update;
        //-duz := '';  {JK 1/2/2009 - fixed defect #36. Removed local duz variable.}

        oldFilter := FCurrentFilterVerifyWin;

        {JK 1/2/2009 - fixed defect #36. Added fduz variable.}
        vfilter := frmListFilter.Execute(magImageList1.ImageFilter, fduz, True);

        if vfilter <> nil then
        begin
            MagImageList1.ImageFilter := vfilter;
            FQuickFilterUsed := false;
            FCurrentFilterVerifyWin := vfilter;
            lbFilterDesc.Caption := ' Loading images...';
            //   vfilter has '' name and ID from the frmListFilter window.
            //  and SetCurrentFilter stops when this is true.  So no list is updated.
            {TImageList gets an Update Call from here, when a filter changes.
             TImageList then calls notify which calls update on the GenImageList window.}
            UpdateVerifyFilteredImageList;
        end;
    end;
end;

procedure TfrmVerify.ClearWindow;
begin
 winmsg(stpnlmsg,'');
    self.Mag4Viewer1.ClearViewer;
    maglistviewVerify.ClearItems;

   self.VerifyWinGrpAbsViewer.ClearViewer  ;
   self.pnlGroupAbs.Enabled := false;


    lbFilterDesc.Update;
    lbFilterDesc.caption := '';
    winmsg(stpnlmid, '');
    winmsg(stpnlct, '');
    ClearAllPropertyFields;
end;

procedure TfrmVerify.winmsg(pnl: integer; pnlmsg: string = '');
begin
    statusbar1.Panels[pnl].Text := pnlmsg;
end;

procedure TfrmVerify.mnuSelectColumnsClick(Sender: TObject);
begin
    maglistviewVerify.SelectColumns;
end;

procedure TfrmVerify.FormClose(Sender: TObject;
    var Action: TCloseAction);
begin
    screen.Cursor := crdefault;
    magimagelist1.Detach_(self as ImagObserver);
    //  frmGenOverlay.ClearAllFields;
    //  frmGenOverlay.Hide;
    UserPrefUpdate;
    action := caFree;

    {JK 4/6/2009 - 508 work}
    Screen.OnActiveControlChange := nil;
end;

////////////////////////////////////////////////////////
 ////////////////////////////////////////////////////////

procedure TfrmVerify.Mag4Viewer1ViewerImageClick(sender: TObject);
var
    Iobj: TImageData;
begin
    {   do actions dependent on the 'click' of an image first, then see if sync
        is needed.}
    MagViewerTB1.UpdateImageState;
    iobj := mag4viewer1.GetCurrentImageObject;
    if Iobj = nil then
    begin
        //
    end
    else
    begin
        if (Iobj.Mag0 <> FCurrentImageObjectVerify.Mag0) then
        begin
            {   clear all Display fields.}
            ClearAllPropertyFields;
            {   Set All Window Display fields.}
            SetCurrentImageData(Iobj);
            SetAllPropertyFields;
            {   Sync ListView with new current image;}
            if maglistviewverify.Selected <> nil then
                if (MagListViewVerify.GetSelectedImageObj.Mag0 <>
                    self.FCurrentImageObjectVerify.Mag0) then
                    MagListviewVerify.SyncWithImage(FCurrentImageObjectVerify);
        end;
       if Iobj.IsInImageGroup then
          begin
            self.VerifyWinGrpAbsViewer.SyncWithIMage(Iobj,false);
          end;
    end;
end;

procedure TfrmVerify.MagListViewVerifySelectItem(Sender: TObject; Item:
    TListItem; Selected: Boolean);
var
    ocurs: TCursor;
begin
    CursorChange(ocurs, crHourGlass); //
    {       Reset the Timer.}
    timer1.Enabled := false;
    timer1.Enabled := true;

    //ViewSelectedListItem(Sender, Item, Selected);
end;



procedure TfrmVerify.ViewSelectedListItem(Sender: TObject; Item:  TListItem; Selected: Boolean);
var
    Iobj: TImageData;
    objlist: Tlist;
    li: Tlistitem;
    updateviewer: boolean;
begin
WinMsgClear ; //117
self.VerifyWinGrpAbsViewer.ClearViewer;  //117
self.pnlGroupAbs.Enabled := false;       //117
    if not selected then
        exit;
    {JK 1/23/2009}
    try
        {JK 1/14/2009 - fixes D49 - Removed this section because it was reseting the MagListViewVerify
         ItemIndex to zero at times (screwy behavior).  Was this section really needed if an
         item was not selected????  Also look at the new method TfrmVerify.MagListViewVerifyChanging
         which works on this same defect.}
        //if not Selected then
        //begin
        //  ClearAllPropertyFields;
        //  mag4viewer1.ClearViewer;
        //  Exit;
        //end;
        //  (*  if Fdisplaying then
        //      begin
        //      messagebeep(MB_OK);
        //      exit;
        //      end;
        //  *)
        try
            Fdisplaying := True;   //117  moved up 
            CursorGetHG;
            objlist := TList.Create;
            Update;
            frmVerify.Enabled := False;
            {Do actions dependent on the 'selected' status of the list, then see if sync
             is needed.}
            SetProcessButtons(); //(maglistviewVerify.Selected <> nil);

            (* li := ITEM; //maglistviewverify.Selected;
            (* if li = nil then
                begin
                //
                exit;
                end;
                *)
           //  Iobj := maglistviewverify.GetSelectedImageObj;
            Iobj := TMagListViewData(item.Data).Iobj;
            if (Iobj = nil) then
            begin
                winmsg(stpnlmsg, 'Data for selected Image is null');
            end
            else
            begin
                if (Iobj.Mag0 <> FCurrentImageObjectVerify.Mag0) then
                begin
                    {   clear all Display fields.}
                    ClearAllPropertyFields;
                    {   Set All Window Display fields.}
                    SetCurrentImageData(Iobj);
                    SetAllPropertyFields;
                    {   Sync ListView with new current image;}
                    if Mag4Viewer1.GetCurrentImageObject = nil then
                        UpdateViewer := true
                    else if (mag4viewer1.GetCurrentImageObject.Mag0 <>
                        self.FCurrentImageObjectVerify.Mag0) then
                        UpdateViewer := true;
                    if UpdateViewer then
                    begin
                        if not Iobj.IsImageGroup then  //117 check for groups
                        begin
                        {/117 start  - hiding Grp Abs Viewer... might not, this is a test.}
                        {VerifyWinGrpAbsViewer is alreay cleared.}
                              pnlGroupabs.visible := false;
                              pnlgroupabs.Enabled := false;
                              pnlgroupabs.Update;
                              Update;
                        objList.Add(IObj);
                        Mag4Viewer1.ImagesToMagView(objlist, false);

                        end;

                        {/gekp117  }
                              if Iobj.IsImageGroup then
                              begin
                              pnlGroupabs.visible := true;
                              pnlgroupabs.Enabled := true;
                              pnlgroupabs.Update;
                              ShowGroupAbs(Iobj) ;
                              //self.cle
                              VerifyWinGrpAbsViewer.Enabled := true;
                              //VerifyWinGrpAbsViewer.ColumnCount := 3;
                              //VerifyWinGrpAbsViewer.RowCount := 1;
                              //VerifyWinGrpAbsViewer.SetRowColCount(1,3);
                              VerifyWinGrpAbsViewer.SelectNextImage(0);
                              VerifyWinGrpAbsViewerViewerImageClick(self);
                              end;
                        {/gekp117  }

                    end;
                end;
            end;
        finally
            Fdisplaying := false;             //117 moved up from after self.cursorgetold
            frmVerify.enabled := true;
            self.CursorGetOld;
            MagListViewVerify.SetFocus;
            objlist.free;
        end;
    except
        on E: Exception do
            DebugFile('TfrmVerify.ViewSelectedListItem error = ' + E.message);
    end;
end;

procedure TfrmVerify.SetCurrentImageData(Iobj: TimageData);
var
    rstat: boolean;
    rmsg: string;

    fieldlist: string;

    stat : boolean;               //117
    patinfo, IDFN, SSN : string;  //117
begin
    FCurrentImageObjectVerify.magAssign(Iobj);
    FCurrentImageProp.Clear;
    if iobj = nil then
    begin
        //
    end
    else
    begin
        try
            fieldlist := '*';
            dmod.MagDBBroker1.RPMaggImageGetProperties(rstat, rmsg,
                FCurrentImageProp,
                FCurrentImageObjectVerify.Mag0, fieldlist);
            {   Now all display fields will load values from FCurrent...}

         {/gek //p117  we'll tag on to this, and add SSN as an Image Property.}
         IDFN := GetImageProperty('IDFN',true);
         {gek 5/18/10  117  This is the new Pat info call withOut Remote side effects.}
         FMagDBBroker.RPMagPatInfoQuiet(stat, patinfo, IDFN);
         ssn := magpiece(patinfo, '^', 6);     //Pt SSN
         FcurrentImageProp.Add('TEMPSSN^^' + ssn + '^' + ssn);
         {//117 end} 
        except
            //
        end;
    end;
end;

procedure TfrmVerify.ClearAllPropertyFields;
begin
    ClearImageHeader;
    //  ClearImageOverlay;
    ClearImageProperties;
    ClearImageReport;
    ClearImageInfoControlVerify;
end;

procedure TfrmVerify.SetAllPropertyFields;
begin
    SetImageHeader;
    //  SetImageOverlay;
    SetImageProperties;
    SetImageReport;
    SetImageInformation;
end;

procedure TfrmVerify.SetImageHeader;
begin
    if not HaveValidCurrentImageObject() then
        exit;
    lbSelectedImageInfo.Caption := FCurrentImageObjectVerify.PtName

        + ' -- ' + GetImageProperty('TEMPSSN')       //117 new property to display
        + ' -- ' + GetImageProperty('GDESC')        //117 new property to display   

        + ' -- ' + GetImageProperty('IXTYPE')
        + ' -- ' + GetImageProperty('IXSPEC')
        + ' -- ' + GetImageProperty('IXPROC')
        + ' -- ' + FCurrentImageObjectVerify.Mag0;
end;

procedure TfrmVerify.SetImageOverlay;
begin
    if not HaveValidCurrentImageObject() then
        exit;
    if frmGenOverlay.Visible then
    begin

        frmGenOverlay.SetAllFields(FCurrentImageObjectVerify.PtName,
            GetImageProperty('IXTYPE'),
            GetImageProperty('IXSPEC'),
            GetImageProperty('IXPROC'));
    end;
end;

procedure TfrmVerify.SetImageProperties;
begin
    if not HaveValidCurrentImageObject() then
        exit;

    lbSYncedPatName.Caption := FCurrentImageObjectVerify.PtName;
    lbSYncedPatName.Hint := FCurrentImageObjectVerify.PtName;

    lbSyncSSN.Caption := GetImageProperty('TEMPSSN');   //117
    lbSyncSSN.Hint := lbSyncSSN.Caption;   //117   

    lbSyncStatusReason.Caption := GetImageProperty('ISTATRSN');
    lbSyncStatusReason.hint := lbSyncStatusReason.Caption;
    lbSyncStatus.Caption := GetImageProperty('ISTAT');
    lbSyncStatus.Hint := lbSyncStatus.Caption;
    lbSynctype.Caption := GetImageProperty('IXTYPE');
    lbSynctype.Hint := lbSynctype.Caption;

    lbSyncShortDesc.Caption := GetImageProperty('GDESC');   //117   
    lbSyncShortDesc.Hint := lbSyncShortDesc.Caption;   //117   

    lbSyncSpec.Caption := GetImageProperty('IXSPEC');
    lbSyncSpec.Hint := lbSyncSpec.Caption;
    lbSyncProc.Caption := GetImageProperty('IXPROC');
    lbSyncProc.Hint := lbSyncProc.Caption;
end;

procedure TfrmVerify.SetImageReport;
var
    rstat: boolean;
    rmsg: string;
begin
    if not HaveValidCurrentImageObject() then
        exit;
    dmod.MagUtilsDB1.ImageReport(FCurrentImageObjectVerify, rstat, rmsg, memReport)
end;

function TfrmVerify.HaveValidCurrentImageObject(): boolean;
begin
    result := false;
    if (FCurrentImageObjectVerify = nil) then
        exit;
    if (FCurrentImageObjectVerify.Mag0 = '') then
        exit;
    result := true;
end;

procedure TfrmVerify.SetImageInformation;
var
    t: tstrings;
    i, lvtopidx, scrollct: integer;
    lit: TListItem;
begin
    if not HaveValidCurrentImageObject() then
        exit;
    t := tstringlist.create;
    try
        dmod.MagDBBroker1.RPMag4GetImageInfo(FCurrentImageObjectVerify, t);
        if lvinfoimageverify.Items.Count > 0 then
            lvInfoImageVerify.Items.BeginUpdate;
        ClearImageInfoControlVerify;

        for i := 0 to t.Count - 1 do
        begin
            lit := lvInfoImageVerify.Items.Add;
            lit.Caption := magpiece(t[i], ':', 1) + ':';
            lit.SubItems.Add(trim(magpiece(t[i], ':', 2) + ':' + magpiece(t[i], ':',
                3)));
        end;
        lvInfoImageVerify.Items.EndUpdate;
        ReSetTopIndexVerify;
    finally
        t.free;
    end;
end;

procedure TfrmVerify.ClearImageHeader;
begin
    lbSelectedImageInfo.Caption := '';
    lbSelectedImageInfo.Hint := '';
end;

procedure TfrmVerify.ClearImageOverlay;
begin
    //  frmGenOverlay.ClearAllFields;
end;

procedure TfrmVerify.ClearImageProperties;
begin
    if application.terminated then
        exit;
    FCurrentImageObjectVerify.Clear;
    FCurrentImageProp.Clear;

    lbSyncedPatName.Caption := '';
    lbSyncedPatName.Hint := '';

    lbSyncSSN.Caption := '';   //117   
    lbSyncSSN.Hint := '';   //117   

    lbSyncType.Caption := '';
    lbSyncType.Hint := '';

    lbSyncShortDesc.Caption := '';   //117   
    lbSyncShortDesc.Hint := '';   //117   

    lbSyncSpec.Caption := '';
    lbSyncSpec.Hint := '';

    lbSyncProc.Caption := '';
    lbSyncProc.Hint := '';

    lbSyncStatus.Caption := '';
    lbSyncStatus.Hint := '';

    lbSyncStatusReason.Caption := '';
    lbSyncStatusReason.Hint := '';
end;

procedure TfrmVerify.ClearImageReport;
begin
    memReport.Clear;
end;

///////////////////////////////////////////////////////////
///////////////////////////////////////////////////////////

function TfrmVerify.GetImageInfoForHeader(vIobj: TImageData): string;
begin

end;


{p117  added internal. But we still default to external.}
function TfrmVerify.GetImageProperty(prop: string; internal : boolean = false): string;
var
    i: integer;
begin

    result := '';
    for i := 0 to FCurrentImageProp.Count - 1 do
    begin
        if magpiece(FCurrentImageProp[i], '^', 1) = prop then
        begin
            if internal       //117   
                then result := magpiece(FCurrentImageProp[i], '^', 3)
                else result := magpiece(FCurrentImageProp[i], '^', 4);
            break;
        end;
    end;
    //
end;

{/gek 117  new function}
function TfrmVerify.AreViewingGroup(): boolean;
begin
//
if self.pnlGroupAbs.Enabled
   then
   begin
   if self.VerifyWinGrpAbsViewer.GetImageCount > 0
       then result := true
       else result := false;
   end
   else
   begin
   result := false;
   end;
end;

procedure TfrmVerify.SelectNextImage;
var
    i, j: Integer;
    li: TListItem;
    ln: TListItem;
    vIobj : TImageData;
    imgcount, imgindex : integer;
begin
    if FDisplaying then
        Exit;
    try
        if MagListViewVerify.Items.Count = 0 then
            Exit;
{/gek 117   groups are new}
if AreViewingGroup then
  begin
  try
  imgcount := verifyWinGrpAbsViewer.GetImageCount;
  imgindex := verifyWinGrpAbsViewer.getCurrentImageIndex;
  if imgindex < (imgcount -1) then
    begin
    FDisplaying := true;
    VerifyWinGrpAbsViewer.SelectNextImage();
    vIobj := VerifyWinGrpAbsViewer.GetCurrentImageObject;
    VerifyWinGrpAbsViewer.ScrollToImage(vIobj);
    VerifyWinGrpAbsViewerViewerImageClick(self);
    exit;
    end
    else
    begin
    //
    end;
  finally
  FDisplaying := false;
  end; {try.. finally}
  end;
{/117 end}

        if MagListViewVerify.Items.Count = 1 then
        begin
            i := 0;
            ln := maglistviewverify.Items[i];
            Self.MagListViewVerify.ItemIndex := i;
            ln.Focused := True;
            exit;
        end;
        i := MagListViewVerify.ItemIndex + 1;
        if i > (MagListViewVerify.Items.Count - 1) then
            i := i - 1;
        MagListViewVerify.ItemIndex := i;
        li := MagListViewVerify.Items[i];
        self.MagListViewVerify.ItemIndex := i;
        li.Focused := true;
        {JK 1/6/208 - makes sure that the selected item is visible if the list is long.Self}
        li.MakeVisible(False);
    finally
        SetProcessButtons;
    end;
end;

procedure TfrmVerify.SelectPrevImage;
var
    i: Integer;
    ln: TListItem;
    vIobj : TImageData;
    imgcount, imgindex : integer;
begin
    if FDisplaying then
        Exit;
    try
        if MagListViewVerify.Items.Count = 0 then
            Exit;
{/gek 117   groups are new}
if AreViewingGroup then
  begin
//    imgcount, imgindex : integer;
  imgcount := verifyWinGrpAbsViewer.GetImageCount;
  imgindex := verifyWinGrpAbsViewer.getCurrentImageIndex;
  if imgindex > 0 then
    begin
    VerifyWinGrpAbsViewer.SelectNextImage(-1);
    vIobj := VerifyWinGrpAbsViewer.GetCurrentImageObject;
    VerifyWinGrpAbsViewer.ScrollToImage(vIobj);
    VerifyWinGrpAbsViewerViewerImageClick(self);
    exit;
    end
    else;
    begin;
    //
    end;
  end;
{/117 end}





        if MagListViewVerify.Items.Count = 1 then
        begin
            i := 0;
            ln := maglistviewverify.Items[i];
            Self.MagListViewVerify.ItemIndex := i;
            ln.Focused := True;
            exit;
        end;

        i := MagListViewVerify.ItemIndex - 1;
        if i = -1 then
            i := 0;
        MagListViewVerify.ItemIndex := i;
        ln := MagListViewVerify.Items[i];
        self.MagListViewVerify.ItemIndex := i;
        ln.Focused := true;
        {JK 1/6/208 - makes sure that the selected item is visible if the list is long.Self}
        ln.MakeVisible(False);
    finally
        SetProcessButtons;
    end;

end;

procedure TfrmVerify.MarkImageAsNeedsReview();
var
    Iobj: TimageData;
    miscparams: Tstrings;
    rstat: boolean;
    resmsg, rmsg: string;
    rlist: tStrings;
    fieldlist: tstrings;
    reason: string;
begin
    try
        resmsg := '';

        winmsg(stpnlmsg, 'Opening Status Reason selection...');
        reason := '';
        reason := frmReasonSelect.execute('S', dmod.MagDBBroker1,
            'Reason for Status Change:', 'Select Reason for ''Needs Review''',
            resmsg);
        if reason = '' then
            raise exception.Create(resmsg);
        rlist := Tstringlist.create;
        fieldlist := Tstringlist.create;
        fieldlist.Add('ISTAT^^Needs Review');
        fieldlist.Add('ISTATRSN^^' + reason);
        if not AreSelectionsSynced then
            exit;

        Iobj := mag4viewer1.GetCurrentImageObject;
        {     ^DD(2005,113,0)=STATUS^S^1:Viewable;2:QA Reviewed;10:In Progress;11:Needs Review;^100;8^Q}
        dmod.MagDBBroker1.RPMaggImageSetProperties(rstat, rmsg, rlist, fieldlist, Iobj.Mag0, '');
        winmsg(stpnlmsg, rmsg);
        if rstat then
        begin
            maglistviewVerify.ImageStateChange(Iobj, umagdefinitions.mistateNeedsRefresh);
            maglistviewVerify.ImageStatusChange(Iobj, umagdefinitions.mistNeedsReview);
        end;

        winmsg(stpnlmsg, 'Reason selected : ' + reason);
    except
        on e: exception do
            winmsg(stpnlmsg, e.message);
    end;

end;

procedure TfrmVerify.MarkImageAsVerified;
var
    miscparams: Tstrings;
    rstat: boolean;
    rmsg: string;
    rlist: tStrings;
    fieldlist: tstrings;
    Iobj: TImageData;

begin
    try
        WinMsgClear;
        if (self.MagListViewVerify.SelCount < 1) then
            exit;
        screen.Cursor := crhourglass;

        rlist := Tstringlist.create;
        fieldlist := Tstringlist.create;
        fieldlist.Add('ISTAT^^QA Reviewed');

        Iobj := mag4viewer1.GetCurrentImageObject;
        if not AreSelectionsSynced then
            exit;
        dmod.MagDBBroker1.RPMaggImageSetProperties(rstat, rmsg, rlist, fieldlist, Iobj.Mag0, '');
        WinMsgClear;
        winmsg(stpnlmsg, rmsg);
        if rstat then
        begin
            maglistviewVerify.ImageStateChange(Iobj, umagdefinitions.mistateNeedsRefresh);
            maglistviewVerify.ImageStatusChange(Iobj, umagdefinitions.mistVerified);
        end;

    finally
        screen.Cursor := crDefault;
    end;
end;

function TfrmVerify.AreSelectionsSynced(): boolean;
var
    vIobj: TimageData;
    lIobj: TImageData;

begin
    winmsgclear;
//117 start
     vIobj := mag4viewer1.GetCurrentImageObject;
     if vIobj.Mag0 = self.FCurrentImageObjectVerify.Mag0 then
       begin
         result := true;
         exit;
         //okay
       end
       else
       begin
         raise exception.create('Displayed Image does not match Displayed properites.' );
       end;
//117 end change.
//117 todo    here we need to sync to Grp abs, or Image LIst.

//if pnlgroupabs.Enabled then
//   begin
//    lIobj := self.VerifyWinGrpAbsViewer.GetCurrentImageObject;
//   end;

// this is existing way.
    try
        vIobj := mag4viewer1.GetCurrentImageObject;
        lIobj := self.MagListViewVerify.GetSelectedImageObj;
        if (vIObj = nil) or (lIobj = nil) then
            raise exception.Create('Image or List selection is invalid');
        if (vIobj.Mag0 <> lIobj.Mag0) then
            raise exception.create('Image does not match List selection');
        result := true;
    except
        on e: exception do
        begin
            result := false;
            winmsg(stpnlmsg, e.Message);
        end;
    end;
end;

procedure TfrmVerify.WinMsgClear;
var
    i: integer;
begin
    for i := 0 to statusbar1.Panels.Count-1 do
        statusbar1.Panels[i].Text := '';
end;

procedure TfrmVerify.FormPaint(Sender: TObject);
var
    vlocksize: boolean;
    dttxt: string;
begin

    {JK 4/6/2009 - make bevel width and postion match the ImgFilterDesc dimensions}
    bvFilter.Left := ImgFilterDesc.Left;
    bvFilter.Width := ImgFilterDesc.Width;
    bvFilter.Height := 177;
    bvFilter.Top := 36;

    vLocksize := self.mag4viewer1.LockSize;
    if not FfirstPaintIsDone then
    begin
        FfirstPaintIsDone := true;

        if self.Mag4Viewer1.LockSize then
            self.Mag4Viewer1.LockSize := false;
        try
            self.Mag4Viewer1.MaxCount := 4;
            self.mag4viewer1.SetRowColCount(1, 1);
            //    Mag4Viewer1.ReAlignImages;
            if self.mag4viewer1.LockSize <> vLocksize then
                self.mag4viewer1.LockSize := vLocksize;

            {This will populate the User List for the Date. (Today)}
            self.cmbDateRange.ItemIndex := 0;
            DateRangeChange(dttxt);
            QFGetCaptureUsersInDateRange(dtfrom, dtto);

        except
            //
        end;
    end;
end;

procedure TfrmVerify.mnuImageStatusToNeedsReviewClick(Sender: TObject);
begin
    MarkImageAsNeedsReview();
    SelectNextImage;
end;

procedure TfrmVerify.mnuImageStatusToVerifiedClick(Sender: TObject);
begin
    VerifyAndNext;
end;

procedure TfrmVerify.FormDestroy(Sender: TObject);
begin
    screen.Cursor := crdefault;
    SaveFormPosition(self as Tform);
    FCurrentImageObjectVerify.Free;
    FCurrentImageProp.Free;
    FDeletedThisSession.Free;
    FlstDisplayDateRange.Free;
    Screen.OnActiveControlChange := nil;
end;

// *****  All enabling /  disabling of Next/Prev buttons and menu options, goes through here.
// *****  gek.  4/24/09  Fix the enable disable synchronization of buttons and menu options.

procedure TfrmVerify.SetProcessButtons();
var
    v, a, n, p: boolean;
    isel, ict: integer;
    grpimgcount, grpimgindex : integer;
    lvIobj : TImageData;
begin
    v := true;
    a := true;
    n := true;
    p := true;
    try
        lvIobj := self.MagListViewVerify.GetSelectedImageObj;
        ict := self.MagListViewVerify.Items.Count;
        if ict = 0 then
        begin
            v := false;
            a := false;
            n := false;
            p := false;
            exit;
        end;
        if (ict = 1) and (self.MagListViewVerify.SelCount = 0) then
        begin
            v := false;
            exit;
        end;
        if (ict = 1) and (self.MagListViewVerify.SelCount = 1) then
        begin
            n := false;
            p := false;
            exit
        end;
        if (self.MagListViewVerify.SelCount = 0) and (ict > 1) then
        begin
            v := false;
            exit;
        end;
        isel := self.MagListViewVerify.ItemIndex;
 //****
      //if AreViewingGroup then
      if lvIobj.IsImageGroup then
      begin
      if (isel = 0)  or (isel = (ict - 1)) then
        begin
        grpimgcount := verifyWinGrpAbsViewer.GetImageCount;
        grpimgindex := verifyWinGrpAbsViewer.getCurrentImageIndex;
        if (isel = (ict - 1)) and (grpimgindex = (grpimgcount -1)) then
          begin
          n := false;
          exit;
          end;
        if (isel = 0) and (grpimgindex = 0) then
          begin
          p := false;
          exit;
          end;
        exit;
        end;
      end;

 //****

        if isel = (ict - 1) then
        begin
            n := false;
            exit;
        end;
        if isel = 0 then
        begin
            p := false;
            exit;
        end;

    finally
        lbimgVerify.Enabled := v;
        btnVerify.Enabled := v; // 508
        mnuAction.Enabled := a;
        lbimgNext.Enabled := n;
        btnNext.Enabled := n; //508
        mnuNext2.Enabled := n;
        mnuNextImage1.Enabled := n;
        lbimgPrev.Enabled := p;
        btnPrev.Enabled := p;
        mnuPrev2.Enabled := p;
        mnuPreviousImage1.Enabled := p;
    end;
end;

procedure TfrmVerify.mnuSingleImageinViewerClick(Sender: TObject);
begin
    //not in 93 FViewSingleImage :=   mnuSingleImageinViewer.Checked;
    //not in 93   Mag4Viewer1.ClearBeforeAddDrop := FViewSingleImage;
    // in 93 we force single image.
    if not Mag4Viewer1.ClearBeforeAddDrop then
        Mag4Viewer1.ClearBeforeAddDrop := true;
end;

procedure TfrmVerify.UpdateVerifyFilteredImageList;
var oldRPCTimeLimit : integer;
begin
    ClearWindow;
    if not FQuickFilterUsed then
    begin
        cmbPercent.Text := '';
        magimagelist1.ImageFilter.FReturnPercent := false;
    end;
    if cmbPercent.Text <> '' then
    begin
        magimagelist1.ImageFilter.MaximumNumber := cmbPercent.Text;
        magimagelist1.ImageFilter.FReturnPercent := true;
    end
    else
    begin
        if cmbMaxNum.Text <> '' then
            magimagelist1.ImageFilter.MaximumNumber := cmbMaxNum.Text
        else
            magimagelist1.ImageFilter.MaximumNumber := '2000'; {  we'll stop at 2000}
    end;

    if (mnuCapAppVICap.checked and mnuCapAppIAPI.checked) then
        magimagelist1.ImageFilter.FCaptureDevice := 'C^I'
    else if mnuCapAppVICap.checked then
        magimagelist1.ImageFilter.FCaptureDevice := 'C'
    else if mnuCapAppIAPI.checked then
        magimagelist1.ImageFilter.FCaptureDevice := 'I';

    magImageList1.ImageFilter.FLocalImagesOnly := true;
    magImageList1.ImageFilter.FGroupImageStatus := '1'; //117  user FLAGS in RPC to send this info
//HERE   ABOVE

    maglogger.MagMsg('s','--**-- FQuickFilter   : ' + magbooltostr(FQuickFilterUsed));
    maglogger.MagMsg('s','--**-- MaximumNumber  : ' + magimagelist1.ImageFilter.MaximumNumber);
    maglogger.MagMsg('s','--**-- FReturnPercent : ' + magbooltostr(magimagelist1.ImageFilter.FReturnPercent));
    maglogger.MagMsg('s','--**-- FCaptureDevice : ' + magimagelist1.ImageFilter.FCaptureDevice);
    maglogger.MagMsg('s','--**-- FLocalImagesOnly : ' + magbooltostr(magImageList1.ImageFilter.FLocalImagesOnly));
    {/117 added FGroupImageStatus.}
    maglogger.MagMsg('s','--**-- FGroupImageStatus : ' +magImageList1.ImageFilter.FGroupImageStatus);
    maglogger.MagMsg('s','--**-- Verify Win : magImageList1.update_  ');

    //gek -" magImageList1.Update_('1', self);"
    // This is what the Notify (of a Subject) would call.  In other situations the Notify of cMagPat object calls update_ of it's
    // observers  (magImageList1 is an observer of the cMagPat)  because of a patient Change.
    // then the magImageList1  will
    try
    {/p93t13 gek 11/4/09  we don't want to change the time limit in all calls, so we do it here
        before MagImageList1.update_   in update_ the image list is refreshed from the database.
        This image list could take long time. : we have a limit on number of Images returned (2000) so
        it shouldn't take longer than 30 seconds.  But this is just in case. }
    oldRPCTimeLimit := dmod.RPCBroker1.RPCTimeLimit;
    dmod.RPCBroker1.RPCTimeLimit := 300;
    {this forces the magImageList to get new listing of images.
      and magImageList1 will 'Notify' all of it's subscribers.}
    magImageList1.Update_('1', self);
    SetProcessButtons();
    finally
    dmod.RPCBroker1.RPCTimeLimit := oldRPCTimeLimit;
    end;
end;

procedure TfrmVerify.mnuRefreshImageListClick(Sender: TObject);
begin
    {JK 6/5/2009 - ensure that a user and a date has been set before updating the list and be sure the filter has the minimal info to proceed.}
    if (cmbUsers.Text <> '<select a user>') and (cmbUsers.Text <> '') and (FCurrentFilterVerifyWin <> nil)
        then
    begin
        UpdateVerifyFilteredImageList;
        SetProcessButtons();
    end
    else
        MagListViewVerify.Clear;
end;

procedure TfrmVerify.mnuFilterDetailsClick(Sender: TObject);
begin
    FilterDetailsInInfoWindow2;
end;

{This is copy of the menuitem code from frmImageList.  temporary.}

procedure TfrmVerify.FilterDetailsInInfoWindow2;
var
    t: Tstrings;
    s: string;
    i: integer;
begin
    if FCurrentFilterVerifyWin = nil then
    begin
        lbFilterDesc.Caption := 'No Filter selected.';
        winmsg(stpnlmid, '');
        exit;
    end;
    s := '';
    t := Tstringlist.create;
    //t := DetailedDesc2(FCurrentFilterVerifyWin);
//p94t2 gek, moved to umagdbbroker
//    t := DetailedDescGen(FCurrentFilterVerifyWin);
	//p94 umagutils8b is new to 94, for refactoring.
    t := umagutils8B.GetFilterDesc(FCurrentFilterVerifyWin,dmod.MagDBBroker1);
    for i := 0 to t.count - 1 do
    begin
        s := s + #13 + t[i]
    end;
    messagedlg(s, mtinformation, [mbok], 0);
end;

procedure TfrmVerify.mnuPreviewInfoClick(Sender: TObject);
begin
    ShowImageInfo(mnuPreviewInfo.checked);
end;

procedure TfrmVerify.PreviewInfo(value: boolean);
begin
    if FPreviewInfoVerify <> value then
        FPreviewInfoVerify := value;
    if mnuPreviewInfo.checked <> value then
        mnuPreviewInfo.checked := value;

    ClearImageInfoControlVerify;
    if self.FPreviewInfoVerify then
    begin
        SetImageInformation;
        if pnlInfo.Height < 120 then
            pnlInfo.Height := 120;
        splpnlinfo.Top := pnlinfo.Top + 1;
    end
    else
        self.pnlInfo.Height := 21;

end;

procedure TfrmVerify.mnuPreviewReport22Click(Sender: TObject);
begin
    ShowImageReport(mnuPreviewReport22.Checked);
end;

procedure TfrmVerify.PreviewReport(value: boolean);
begin
    if FPreviewReportVerify <> value then
        FPreviewReportVerify := value;
    if mnuPreviewReport22.checked <> value then
        mnuPreviewReport22.checked := value;

    ClearImageReport;
    if FPreviewReportVerify then
    begin
        SetImageReport;
        if pnlReport.Height < 120 then
            pnlReport.Height := 120;
        splpnlreport.Top := pnlreport.Top + 1;
    end
    else
        pnlReport.Height := 21;
end;

procedure TfrmVerify.pnlReportResize(Sender: TObject);
var
    oldpreviewReport: boolean;
begin
    oldpreviewReport := self.FPreviewReportVerify;
    FPreviewReportVerify := (TPanel(sender).Height > 21);
    if (oldpreviewReport <> FPreviewReportVerify) then
    begin
        ClearImageReport;
        imgRptUpButton.Visible := not FPreviewReportVerify;
        imgRptDownButton.Visible := FPreviewReportVerify;
        if FPreviewReportVerify then
        begin
            SetImageReport;
            memReport.TabStop := true;
        end
        else
            memreport.TabStop := false;

    end;
end;

procedure TfrmVerify.pnlInfoResize(Sender: TObject);
var
    oldprevInfo: boolean;
begin
    oldPrevInfo := self.FPreviewInfoVerify;
    FPreviewInfoVerify := (TPanel(sender).Height > 21);
    if (oldPrevInfo <> FPreviewInfoVerify) then
    begin
        imgInfoUpButton.Visible := not FPreviewInfoVerify;
        imgInfoDownButton.Visible := FPreviewInfoVerify;
        ClearImageInfoControlVerify;
        if FPreviewInfoVerify then
        begin
            SetImageInformation;
            lvInfoImageVerify.TabStop := true;
        end
        else
            lvInfoImageVerify.TabStop := false;
    end;
end;

procedure TfrmVerify.Options1Click(Sender: TObject);
var
    lstloaded: boolean;
begin
    lstloaded := (self.MagListViewVerify.Items.Count > 0);
    mnuPreviewInfo.Checked := FPreviewInfoVerify;
    mnuPreviewReport22.Checked := FPreviewReportVerify;
    //not in 93 mnuSingleImageinViewer.Checked := FViewSingleImage ;
    // in 93, force only 1 image.
    mnuSingleImageinViewer.Checked := true;
    FViewSingleImage := true;

    mnuSelectColumns.Enabled := lstloaded;
    mnuFitcolumnstotext.Enabled := lstloaded;
    mnuFitcolumnstowindow.Enabled := lstloaded;

    //mnuOverlayImageInfo1.Checked := frmGenOverlay.Visible;
end;

procedure TfrmVerify.mnuFitcolumnstotextClick(Sender: TObject);
begin
    MagListViewVerify.FitColumnsToText;
end;

procedure TfrmVerify.mnuFitcolumnstowindowClick(Sender: TObject);
begin
    MagListViewVerify.FitColumnsToForm;
end;

procedure TfrmVerify.mnuSelectFilter1Click(Sender: TObject);
begin
    ShowQuickFilterPanel(false);
    GetFilter;
end;

procedure TfrmVerify.imgDownButtonClick(Sender: TObject);
begin
    ShowQuickFilterPanel(True);
end;

procedure TfrmVerify.imgUpButtonClick(Sender: TObject);
begin
    ShowQuickFilterPanel(False);
end;

procedure TfrmVerify.ShowQuickFilterPanel(value: boolean);
begin
    imgUpButton.Visible := value;
    imgDownButton.Visible := not value;
    if value then
    begin
        pnlQuickFilter.Height := 218;
        ToggleEnableQFButtons(true); //508
    end
    else
    begin
        pnlQuickFilter.Height := 35;
        ToggleEnableQFButtons(false); //508
    end;
end;

procedure TfrmVerify.ToggleEnableQFButtons(val: boolean);
begin
    cmbDateRange.enabled := val;
    btnCapBy.enabled := val;
    cmbUsers.enabled := val;
    btnStatusSelect.enabled := val;
    cmbPercent.enabled := val;
    cmbMaxNum.enabled := val;
    btnSearch.enabled := val;
end;

function TfrmVerify.IsQuickPanelOpen: boolean;
begin
    result := imgUpButton.Visible; //pnlQuickFilter.height = 184;
end;

procedure TfrmVerify.GetDateRange;
var
    dttxt: string;
begin
    dttxt := '';
    DateRangeChange(dttxt);
    if dttxt <> '' then
    begin
        lbedtDateRange.Caption := dttxt;
        AlertSearchPropertyChange(true);
    end;
end;

procedure TfrmVerify.DateRangeChange(var rangetext: string);
var
    //-dtfrom, dtto: string;  {JK 6/1/2009 - moved to global variable section to keep for use with the verication report}
    oldcursor: TCursor;
begin
    try
        oldcursor := Screen.Cursor;
        Screen.Cursor := crHourGlass;
        FDateFrom := '';
        FDateTo := '';

        QFConvertSelectedDateRangeToDates(dtfrom, dtto);

        FdateFrom := dtfrom;
        FDateTo := dtto;

        if FDateFrom = '' then
        begin
            self.CaptureUsersRefreshNeeded;
            lbedtDateRange.Caption := '';
        end
        else
        begin
            if cmbdaterange.ItemIndex = 8 then
            begin
                rangetext := FormatDateTime('mmm dd, yyyy', strtodatetime(dtfrom)) +
                    '  thru  ' +
                    FormatDateTime('mmm dd, yyyy', strtodatetime(dtto));
                lbedtDateRange.Caption := rangetext;
            end
            else
            begin
                lbedtDateRange.Caption := self.FlstDisplayDateRange[cmbDateRange.Itemindex];
            end;

        end;
        //        lbedtDateRange.Caption := cmbdaterange.Text;
    finally
        screen.Cursor := oldcursor;
    end;
end;

procedure TfrmVerify.QFGetCaptureUsersInDateRange(dtfrom, dtto: string);
var
    i: integer;
    rmsg, s1, s2: string;
    rlist, paramlist: Tstringlist;
    rstat: boolean;
    ocurs: TCursor;
    capapp: string;
    oldRPCtimeLimit : integer;
begin
 winmsg(stpnlmsg,'');
    CursorChange(ocurs, crHourGlass); //

    rlist := tstringlist.Create();
    paramlist := tStringlist.Create();
    try
        oldRPCTimeLimit := dmod.RPCBroker1.RPCTimeLimit;
        dmod.RPCBroker1.RPCTimeLimit := 300;
        capapp := '';
        paramlist.Add(dtfrom);
        paramlist.Add(dtto);
        if mnuCapAppVICap.Checked then capapp := capapp + 'C';
        if mnuCapAppIAPI.Checked then capapp := capapp + 'I';
        paramlist.Add(capapp);
        // below was MagDBMVista1...
        //dmod.MagDBBroker1.RPMagImageStatisticsUsers(rstat, rmsg, rlist, paramlist);
        maglogger.MagMsg('s','In QA Form : calling RPMagImageStatisticsUsers : dtfrom - ' + dtfrom + '  dtto - ' + dtto);
        //94t13 dmod.MagDBMVista1.RPMagImageStatisticsUsers(rstat, rmsg, rlist, paramlist);
        {/p94t13 gek 11/4/2009  New call to get Users in Date Range that've captured images.  }
        //94t13 dmod.MagDBMVista1.RPMagImageStatisticsUsers(rstat, rmsg, rlist, paramlist);
        dmod.MagDBMVista1.RPMaggCaptureUsers(rstat, rmsg, rlist, paramlist);
        if not rstat then
        begin
            if  pos('NO USERS',UPPERCASE(rmsg)) = 0
                THEN  maglogger.MagMsg('d','Error listing users : ' + rmsg);
            winmsg(stpnlmsg,rmsg);
            CaptureUsersNone;
        end
        else
        begin
            cmbUsers.Clear;
            cmbUsers.Items.Assign(rlist);
            if cmbUsers.Items.Count = 0 then
            begin
                messagedlg('There are no Images captured in the selected date range.'
                    + #13 + 'Please change your date range selection.', mtconfirmation,
                    [mbok], 0);
                CaptureUsersNone;
            end
            else {we have some users.}
            begin
                for i := 0 to cmbusers.Items.Count - 1 do
                begin
                    s1 := magpiece(cmbusers.Items[i], '^', 1);
                    s2 := magpiece(cmbusers.Items[i], '^', 2);
                    //          cmbusers.Items[i]:= s1 + #9 + #9 + #9 + #9 + #9 + #9 + #9 + #9 + #9 + #9 + '|' + s2;
                    cmbusers.Items[i] := s1 +
                        '                                                                  '
                        + '                                                                  '
                        + '|' + s2;
                end;
                cmbUsers.Items.Insert(0, '<select a user>');
                cmbUsers.ItemIndex := 0;
                cmbUsers.DroppedDown := true;
                cmbUsers.SetFocus;
                btnSearch.Enabled := false;
            end;
        end;

    finally
        dmod.RPCBroker1.RPCTimeLimit := oldRPCTimeLimit;
        paramlist.Free;
        rlist.free;
        cursorRestore(ocurs);

    end;
    if cmbUsers.Items.Count > 1 then
    begin
        // 7-12        cmbUsers.DroppedDown := true;
        //7-12        cmbUsers.SetFocus;
    end;
end;

procedure TfrmVerify.CaptureUsersNone;
begin
    cmbUsers.Clear;
    cmbUsers.Items.Insert(0, '<No users for Date Range>');
    cmbUsers.ItemIndex := 0;
    btnSearch.Enabled := false;
end;

procedure TfrmVerify.CaptureUsersRefreshNeeded;
begin
    cmbUsers.Clear;
    cmbUsers.Items.Insert(0, '<Refresh needed for Date Range change>');
    cmbUsers.ItemIndex := 0;
    btnSearch.Enabled := false;
end;

procedure TfrmVerify.QFFillDateRangeDropDown;
var
    dt: TDateTime;
    dow: integer;
    st, sy, s2, s3, s, d1, d7: string;
begin
    {cmbDateRange}

    {JK 1/6/2009 - added YYYY}
    st := FormatDateTime('mmm dd, yyyy', today);
    sy := FormatDateTime('mmm dd, yyyy', incday(today, -1));
    s2 := FormatDateTime('mmm dd, yyyy', incday(today, -2));
    s3 := FormatDateTime('mmm dd, yyyy', incday(today, -3));

    cmbDateRange.Clear;
    FlstDisplayDateRange.Clear;

    //cmbDateRange.Items.Add('Today: ' + st);
    cmbDateRange.Items.Add('Today: ');
    FlstDisplayDateRange.Add(st);
    //cmbDateRange.Items.Add('Yesterday: ' + sy);
    cmbDateRange.Items.Add('Yesterday: ');
    FlstDisplayDateRange.add(sy);
    //cmbDateRange.Items.Add('2 days ago: ' + s2);
    cmbDateRange.Items.Add('2 days ago: ');
    FlstDisplayDateRange.Add(s2);
    //cmbDateRange.Items.Add('3 days ago: ' + s3);
    cmbDateRange.Items.Add('3 days ago: ');
    FlstDisplayDateRange.Add(s3);

    //cmbDateRange.Items.Add('Last 2 days: ' + sy + ' thru Today'); //' + st);
    cmbDateRange.Items.Add('Last 2 days: '); //' + st);
    FlstDisplayDateRange.add(sy + ' thru Today');
    //cmbDateRange.Items.Add('Last 3 days: ' + s2 + ' thru Today'); //' + st);
    cmbDateRange.Items.Add('Last 3 days: '); //' + st);
    FlstDisplayDateRange.Add(s2 + ' thru Today');

    dow := DayOfWeek(today);

    d7 := FormatDateTime('mmm dd, yyyy', incday(today, -(dow)));
    d1 := FormatDateTime('mmm dd, yyyy', incday(today, -(dow + 6)));
    //cmbDateRange.Items.Add('Last full week: ' + d1 + ' thru ' + d7);
    cmbDateRange.Items.Add('Last full week: ');
    FlstDisplayDateRange.Add(d1 + ' thru ' + d7);

    d7 := FormatDateTime('mmm dd, yyyy', incday(today, -(dow - 1)));
    //cmbDateRange.Items.Add('Current week: ' + d7 + ' thru Today'); //' + st);
    cmbDateRange.Items.Add('Current week: '); //' + st);
    FlstDisplayDateRange.add(d7 + ' thru Today');

    cmbDateRange.Items.Add('<select date range>');
    FlstDisplayDateRange.Add('<select date range>');
    cmbDateRange.ItemIndex := 0;

    {Today
    Yesterday ()
    2 days ago ()
    3 days ago ()
    Last 2 days :
    Last 3 days :
    Last Full week ()
    Current week
    <select date range>  }
end;

procedure TfrmVerify.QFConvertSelectedDateRangeToDates(var dtfrom: string;
    var dtto: string);
var
    dow: integer;
    d1, d7, dttoday: string;
    dtINIrange: string;
    maxDateRange : integer;
begin
 winmsg(stpnlmsg,'');
    try
        CursorGetHG;
        dttoday := formatdatetime('mm/dd/yyyy', now);
        case cmbDateRange.ItemIndex of
            -1: {   default to today}
                begin
                    dtfrom := dttoday;
                    dtto := dttoday;
                end;
            0: // GetTodaysImages;
                begin
                    dtfrom := dttoday;
                    dtto := dttoday;
                end;
            1: //GetYesterdaysImages;
                begin
                    dtfrom := formatdatetime('mm/dd/yyyy', incday(now, -1));
                    dtto := dtfrom;
                end;
            2: //Two days ago ()
                begin
                    dtfrom := formatdatetime('mm/dd/yyyy', incday(now, -2));
                    dtto := dtfrom;
                end;
            3: //Three days ago ()
                begin
                    dtfrom := formatdatetime('mm/dd/yyyy', incday(now, -3));
                    dtto := dtfrom;
                end;
            4: //Last 2 days from () to today
                begin
                    dtfrom := formatdatetime('mm/dd/yyyy', incday(now, -1));
                    dtto := dttoday;
                end;

            5: //Last 3 days :
                begin
                    dtfrom := formatdatetime('mm/dd/yyyy', incday(now, -2));
                    dtto := dttoday;
                end;

            6: //Last work week ()
                begin
                    dow := DayOfWeek(today);
                    dtto := formatdatetime('mm/dd/yyyy', incday(today, -(dow)));
                    dtfrom := formatdatetime('mm/dd/yyyy', incday(today, -(dow + 6)));
                end;
            7: //Current Week
                begin
                    dow := DayOfWeek(today);
                    dtfrom := formatdatetime('mm/dd/yyyy', incday(today, -(dow - 1)));
                    dtto := dttoday
                end;
            8: //<select date range>
                begin
                        dtINIRange := GetIniEntry('Workstation Settings','MaximumQADateRange');
                        {/p117 gek:  patch 117 had this defaulting to '0' (all dates
                         but Timeout problem on Select images for  a user,
                         so 117 T8, is putting back in the MAx of 7... so no change.}
                         //if dtINIRange = '' then dtINIRange := '7'; // out again in 122
                        (*if dtINIRange = '' then dtINIRange := '0';  {/ P117 - JK 8/4/2010 - if the ini setting is null, then the range is unlimited. Use 0 to denote this /}*)
                        {gek/ 122 putting back the defalut to "all dates"
                          M change in 122 code should have fixed the timeout problem.   }
                        if dtINIRange = '' then dtINIRange := '0';
                        try
                        maxDateRange := strtoint(dtINIRange);
                        except
                          //on e:exception do  maxDateRange := 7;
                          on e:exception do maxDateRange := 90;  {/ P117 - JK 8/4/2010 - Change default from 7 to 90 days /}
                        end;
                   try
                   frmdaterange.Execute(dtfrom, dtto, maxDateRange);
                    except
                            //    cmbDateRange.ItemIndex := -1;
                            dtfrom := '';
                            dtto := '';
                        end;
                    end;

        end; {end Case}
    finally
        screen.Cursor := crdefault;
    end;
end;

procedure TfrmVerify.btnStatusSelectClick(Sender: TObject);
begin
 winmsg(stpnlmsg,'');
    StatusSelect;
end;

procedure TfrmVerify.StatusSelect;
var
    fmset: TImageFMSet;
    s, s1: string;
    oldVerifyStatus: string;
begin
 winmsg(stpnlmsg,'');
    try
        oldverifystatus := lbverifystatus.Caption;
        fmset := TImageFMSet.Create;
        S := dmod.MagDBBroker1.RPXWBGetVariableValue('$P($G(^DD(2005,113,0)),U,3)');
        fmset.DBSetDefinition := s;
        fmset.DBSetName := 'Status';
        s1 := frmFMSetSelect.Execute(fmset, lbVerifyStatus.Caption, true,
            'Deleted,In Progress');

        if s1 = '' then {JK 1/13/2009 - replaces the "any" button}
            s1 := '<any status>';
        lbVerifyStatus.Caption := s1;
    finally
        if oldverifystatus <> lbVerifyStatus.Caption then
            AlertSearchPropertyChange(true);
    end;
end;

procedure TfrmVerify.Label4MouseEnter(Sender: TObject);
begin
    statusbar1.Panels[1].Text := 'mouse enter';
end;

procedure TfrmVerify.Label4MouseLeave(Sender: TObject);
begin
    statusbar1.Panels[1].Text := 'mouse leave';
end;

procedure TfrmVerify.btnSearchClick(Sender: TObject);
var
    sdtfrom, sdtto: string;
    scapbyDUZ: string;
    sstatus: string;
begin
 winmsg(stpnlmsg,'');
    try
        if self.cmbUsers.ItemIndex = 0 then
        begin
            if cmbUsers.Text = '<select a user>' then
                messagedlg('You must select a user that has captured images in the'
                    + #13 + 'selected date range.'
                    + #13 + #13 + 'Select an entry in ''Captured By '' user.',
                    mtinformation, [mbok], 0)
            else
                messagedlg('You must select a date range that has Captured Images.'
                    + #13 + #13 + 'Select a new Date Range.',
                    mtinformation, [mbok], 0);
            exit;
        end;
        screen.Cursor := crHourGlass;
        btnSearch.Enabled := false;
        btnSearch.Update;
        {   Set the filter properties from the DateRange,Captured by and Status fields
            this is for All Patients.}
        if (FDateFrom = '') then
            Exit
        else
        begin
            sdtfrom := FDateFrom;
            sdtto := FDateTo;
        end;
        QFConvertSelectedUsertoDUZ(scapbyDUZ);
        QFGetSelectedStatus(sstatus);

        QFGetImagesforSelectProperties(sdtfrom, sdtto, scapbyduz, sstatus);
        AlertSearchPropertyChange(false);
    finally
        screen.Cursor := crdefault;
        btnSearch.Enabled := true;
        btnSearch.Update;
        self.SetProcessButtons;
    end;
end;

procedure TfrmVerify.AlertSearchPropertyChange(value: boolean);
begin
    if value then
        btnSearch.Caption := '* Quick Search'
    else
        btnSearch.Caption := 'Quick Search';
end;

procedure TfrmVerify.QFGetImagesforSelectProperties(dtfrom, dtto, user,   status: string);
var
    vfilter: TimageFilter;
    xmsg: string;
    outdate: string;
    oldCursor: TCursor;
begin
 winmsg(stpnlmsg,'');
    vfilter := TImageFilter.Create;
    vfilter.FromDate := dtfrom;
    vfilter.ToDate := dtto;
    vfilter.UseCapDt := true;
    vfilter.Classes := [mclsAdmin, mclsClin];
    vfilter.Status := status;
    vfilter.ImageCapturedBy := user;

    MagImageList1.ImageFilter := vfilter;
    FCurrentFilterVerifyWin := vfilter;
    FQuickFilterUsed := true;
    //   vfilter has '' name and ID from the frmListFilter window.
    //  and SetCurrentFilter stops when this is true.  So no list is upatged.

    {   TMagImageList gets an Update Call from here, when a filter changes.
      TmagImageList then calls notify which calls update on the GenImageList window.}
    Application.ProcessMessages; //94 debug gek.

    UpdateVerifyFilteredImageList;

end;

procedure TfrmVerify.QFGetSelectedStatus(var status: string);
begin
 winmsg(stpnlmsg,'');
    if UPPERCASE(lbVerifyStatus.Caption) = '<ANY STATUS>' then
        status := ''
    else
        status := lbverifystatus.Caption;
end;

procedure TfrmVerify.QFConvertSelectedUserToDUZ(var duz: string);
begin
 winmsg(stpnlmsg,'');
    if cmbusers.ItemIndex = -1 then
        duz := ''
    else
        duz := magpiece(cmbusers.items[cmbusers.Itemindex], '|', 2);
end;

procedure TfrmVerify.mnuImageStatusToVerified1Click(Sender: TObject);
begin
    MarkImageAsVerified;
    self.RefreshGroupVerify;
    SelectNextImage;
end;

procedure TfrmVerify.mnuNext1Click(Sender: TObject);
begin
    SelectNextImage;
end;

procedure TfrmVerify.mnuPrevious1Click(Sender: TObject);
begin
    SelectPrevImage;
end;

procedure TfrmVerify.mnuImageStatusToNeedsReview1Click(Sender: TObject);
begin
    MarkImageAsNeedsReview;
    self.RefreshGroupVerify;
    SelectNextImage;
end;

procedure TfrmVerify.lbimgNextMouseEnter(Sender: TObject);
begin
    if lbimgNext.Enabled then
    begin
        if not imgNextOutline.Visible then
            imgNextOutline.Visible := true;
    end
    else
    begin
        if imgNextOutline.Visible then
            imgNextOutline.Visible := false;
    end;
end;

procedure TfrmVerify.lbimgNextMouseLeave(Sender: TObject);
begin
    if imgNextOutline.Visible then
        imgNextOutline.Visible := false;
end;

procedure TfrmVerify.lbimgNextClick(Sender: TObject);
begin
    SelectNextImage;
end;

procedure TfrmVerify.lbimgPrevClick(Sender: TObject);
begin
    SelectPrevImage;
end;

procedure TfrmVerify.lbimgPrevMouseEnter(Sender: TObject);
begin
    if lbimgPrev.Enabled then
    begin
        if not imgPrevOutline.Visible then
            imgPrevOutline.Visible := true;
    end
    else
    begin
        if imgPrevOutline.Visible then
            imgPrevOutline.Visible := false;
    end;
end;

procedure TfrmVerify.lbimgPrevMouseLeave(Sender: TObject);
begin
    if imgPrevOutline.Visible then
        imgPrevOutline.Visible := false;
end;

procedure TfrmVerify.imgVerifyClick(Sender: TObject);
begin
    if (maglistviewverify.SelCount = 0) then
        exit;
    MarkImageAsVerified;
    SelectNextImage;
end;

procedure TfrmVerify.lbimgVerifyClick(Sender: TObject);
begin
    VerifyAndNext;
end;

procedure TfrmVerify.VerifyAndNext;
begin
    try
        winmsg(stpnlmid, '');
        if (self.MagListViewVerify.SelCount < 1) then
            exit;
        screen.Cursor := crhourglass;
        MarkImageAsVerified;
        SelectNextImage;
        if FCurrentImageObjectVerify.isInImageGroup then
               RefreshGroupVerify;

        
    finally
        screen.Cursor := crDefault;
    end;
end;

procedure TfrmVerify.lbimgVerifyMouseEnter(Sender: TObject);
begin
    if lbimgVerify.Enabled then
    begin
        if not imgVerifyOutline.Visible then
            imgVerifyOutline.Visible := true;
    end
    else
    begin
        if imgVerifyOutline.Visible then
            imgVerifyOutline.Visible := false;
    end;
end;

procedure TfrmVerify.lbimgVerifyMouseLeave(Sender: TObject);
begin
    if imgVerifyOutline.Visible then
        imgVerifyOutline.Visible := false;
end;

procedure TfrmVerify.imgRptUpButtonClick(Sender: TObject);
begin
    ShowImageReport(False);
end;

procedure TfrmVerify.imgRptDownButtonClick(Sender: TObject);
begin
    ShowImageReport(True);
end;

procedure TfrmVerify.ShowImageReport(value: boolean);
begin
    ClearImageReport;
    FPreviewReportVerify := value;

    imgRptUpButton.Visible := FPreviewReportVerify;
    imgRptDownButton.Visible := not FPreviewReportVerify;
    {JK 1/6/2009 - Fixed button up/down logic}
    memReport.TabStop := FPreviewReportVerify;
    if FPreviewReportVerify then
    begin
        SetImageReport;
        //    pnlReport.Height := 120;
        splpnlreport.Visible := false;
        splpnlreport.Align := alnone;
        pnlReport.Align := alnone;
        pnlReport.top := self.splpnlinfo.Top - 120;
        pnlReport.Height := 120;
        pnlReport.Align := albottom;

        update;
        splpnlreport.Align := albottom;
        self.splpnlreport.Top := pnlReport.Top + 10;
        self.splpnlreport.Visible := true;
    end
    else
    begin
        self.pnlReport.Height := 21;
        update;
        self.splpnlreport.Top := pnlReport.Top + 10;
    end;
end;

procedure TfrmVerify.imgInfoDownButtonClick(Sender: TObject);
begin
    ShowImageInfo(True);
end;

procedure TfrmVerify.imgInfoUpButtonClick(Sender: TObject);
begin
    ShowImageInfo(False);
end;

procedure TfrmVerify.ShowImageInfo(value: boolean);
begin
    ClearImageInfoControlVerify;
    FPreviewInfoVerify := value;

    imgInfoUpButton.Visible := FPreviewInfoVerify;
    imgInfoDownButton.Visible := not FPreviewInfoVerify;
    {JK 1/6/2009 - Fixed button up/down logic}
    lvInfoImageVerify.TabStop := FPreviewInfoVerify;
    if FPreviewInfoVerify then
    begin
        SetImageInformation;
        pnlInfo.Height := 120;
        update;
        self.splpnlInfo.Top := pnlInfo.Top + 10;
    end
    else
    begin

        self.pnlinfo.Height := 21;
        update;
        self.splpnlInfo.Top := pnlInfo.Top + 10;
    end;
end;

procedure TfrmVerify.mnuNext2Click(Sender: TObject);
begin
    SelectNextImage;
end;

procedure TfrmVerify.mnuPrev2Click(Sender: TObject);
begin
    SelectPrevImage;
end;

procedure TfrmVerify.btnVerifyClick(Sender: TObject);
begin
    VerifyAndNext;
end;

procedure TfrmVerify.CursorGetHG;
begin
    FoldCursor := screen.cursor;
    screen.Cursor := crHourGlass;
end;

procedure TfrmVerify.CursorGetOld;
begin
    screen.Cursor := FoldCursor
end;

procedure TfrmVerify.btnNextClick(Sender: TObject);
begin
    SelectNextImage;
end;

procedure TfrmVerify.btnPrevClick(Sender: TObject);
begin
    SelectPrevImage;
end;

procedure TfrmVerify.ToggleOverlay;
begin
    if frmGenOverlay.Visible then
    begin
        timer1.Enabled := false;
        frmGenOverlay.Hide;
    end
    else
    begin
        timer1.Enabled := true;
        frmGenOverlay.show;
        //  frmGenOverlay.Top :=
    end;
end;
procedure TfrmVerify.Timer1Timer(Sender: TObject);
var
    item: Tlistitem;
    selected: boolean;
begin
    timer1.Enabled := false;
    item := maglistviewverify.Selected;
    WinMsgClear;
    if item <> nil then
        ViewSelectedListItem(maglistviewverify, Item, true);
    cursorRestore(crDefault);
end;


procedure TfrmVerify.mnuOverlayImageInfo1Click(Sender: TObject);
begin
    ToggleOverlay;
end;

procedure TfrmVerify.mnupopVerifyImagePopup(Sender: TObject);
var hasimage : boolean;
isdeleted : boolean;
begin
ImageInformationAdvanced1.visible := userhaskey('MAG SYSTEM');
//

isdeleted := false;
    {/p117 gek   Added checks for the different key, to enable/disable menu items.
                  Added checks for deleted Image.}
    hasimage := (FCurrentImageObjectVerify.Mag0 <> '');
    if hasimage then isdeleted := FCurrentImageObjectVerify.IsImageDeleted
                                  or IsDeletedThisSession(FCurrentImageObjectVerify);                                 ;
    
    ImageDelete2.Enabled := hasimage
                            and (userhaskey('MAG DELETE') or userhaskey('MAG SYSTEM'))
                            and (not isdeleted);
    ImageInformationAdvanced1.Enabled := hasimage and userhaskey('MAG SYSTEM');
    {/p117 gek add MAG SYSTEM to check for enable this item.       }
    ImageIndexEdit1.enabled := hasimage
                               and (UserHasKey('MAG EDIT') or userhaskey('MAG SYSTEM'))
                               and (not isdeleted) ; //P117 mag edit check.


mnuImageStatusToVerified1.Enabled := (not isdeleted);

mnuImageStatusToNeedsReview1.Enabled := (not isdeleted);

end;

procedure TfrmVerify.mnuClearWindow1Click(Sender: TObject);
begin
    ClearWindow;
end;

procedure TfrmVerify.mnuQuickFilter1Click(Sender: TObject);
begin
    ShowQuickFilterPanel(mnuQuickFilter1.checked);
end;

procedure TfrmVerify.SaveColumns1Click(Sender: TObject);
begin
(* p94t2   we'll leave these calls for COlumnSets in here, maybe use later
    ColumnSetSave(self.MagListViewVerify);
    *)
end;

procedure TfrmVerify.GetColumnset1Click(Sender: TObject);
var
    value, curcolsetvalue: string;
begin
(* p94t2   we'll leave these calls for COlumnSets in here, maybe use later
    curcolsetvalue := self.maglistviewverify.ColumnSetGetCurrentValue;

    value := uMagDisplayMgr.ColumnSetGet(self.MagListViewVerify);
    if value <> '' then
        ColumnSetApply(self.MagListViewVerify, value)
    else
        ColumnSetApply(self.MagListViewVerify, curcolsetvalue);
    MagListViewVerify.FitColumnsToForm;
*)
end;

procedure TfrmVerify.mnuExit1Click(Sender: TObject);
begin
    Close; {JK 1/6/2009 - Fixes D6}
end;

procedure TfrmVerify.mnuQAImageIndexEditClick(Sender: TObject);

begin

    CurrentVerifyImageIndexEdit;
    (*
         {JK 1/23/2009 - fixed D64 to refresh the property fields after the edit terms are edited}
           try
               ITmpObj := TMagListViewData(MagListViewVerify.Selected.Data).Iobj;
               if (ITmpObj = nil) then
               begin
                   winmsg(stpnlmsg, 'Data for selected Image is null');
               end
               else
               begin
                   if (ITmpObj.Mag0 = FCurrentImageObjectVerify.Mag0) then
                   begin
                       {Clear all Display fields.}
                       ClearAllPropertyFields;
                       {Set All Window Display fields.}
                       SetCurrentImageData(ITmpObj);
                       SetAllPropertyFields;
                   end;
               end;
           finally
               if Assigned(ITmpObj) then
                   ITmpObj := nil;
           end;
         *)

end;

////////////////

procedure TfrmVerify.CurrentVerifyImageIndexEdit;
var
    vresult: boolean;
    i: integer;
    ITmpObj: TImageData;
    magienlist: Tstrings;
    rmsg: string;

begin

    if MagListViewVerify.Items.Count = 0 then
        messagedlg('There are no images to edit. Please make a selection first.',
            mtWarning, [mbOK], 0)
    else if MagListViewVerify.Selected = nil then
        MessageDlg('To edit, first select an image from the list.', mtInformation,
            [mbOK], 0)
    else

    try
        ITmpObj := nil;
        try
            if not Dmod.MagDBBroker1.IsConnected then
                raise exception.Create('You need to Login to VistA.');
            if FCurrentImageObjectVerify = nil then
                raise exception.Create('You need to select an Image.');
            if FCurrentImageObjectVerify.Mag0 = '' then
                raise exception.Create('Image IEN is invalid');

            if not utilIsThisImageLocaltoDB(FCurrentImageObjectVerify, dmod.MagDBBroker1, rmsg) then
                raise exception.Create('You cannot edit an Image from a Remote Site.');

            ITmpObj := TMagListViewData(MagListViewVerify.Selected.Data).Iobj;
            if (ITmpObj = nil) then
                raise exception.Create('You need to select an Image.');
            {    Make sure everything on screen is the same image.  FCur.., ImageListView..  ImageViewer.}

            {/GEK 5/17/2010 P117   FCurretn....  doesn't need to match MagListView, Because the selected 
            image now could be from the Group.   so compare it to The image displayed in the image viewer/}
//            if not (ITmpObj.Mag0 = FCurrentImageObjectVerify.Mag0) then
//                raise exception.Create('You need to select an Image from the List.');

//            if not (ITmpObj.Mag0 = self.Mag4Viewer1.GetCurrentImageObject.Mag0) then
//                raise exception.Create('You need to select an Image in the Viewer.');

            if not (FCurrentImageObjectVerify.Mag0 = self.Mag4Viewer1.GetCurrentImageObject.Mag0) then
                raise exception.Create('The Displayed Image does not match the Information Displayed.  ReSelect an Image.');
//117 end


            magienlist := tstringlist.create;
            magienlist.Add(FCurrentImageObjectVerify.Mag0);
            if frmIndexEdit.Execute(dmod.MagDBBroker1, FCurrentImageObjectVerify, rmsg) then
            begin
                MagListViewVerify.ImageStateChange(FCurrentImageObjectVerify,
                    umagdefinitions.mistateNeedsRefresh);
                {Clear all Display fields.}
                ClearAllPropertyFields;
                {Set All Window Display fields.}
                SetCurrentImageData(ITmpObj);
                SetAllPropertyFields;
            end;
            winmsg(stpnlmsg, rmsg);
            //maggmsgf.MagMsg('', rmsg);
            MagLogger.MagMsg('', rmsg); {JK 10/5/2009 - Maggmsgu refactoring}
        except
            on e: exception do
            begin
                //maggmsgf.MagMsg('', e.Message);
                MagLogger.MagMsg('', E.Message); {JK 10/5/2009 - Maggmsgu refactoring}
            end;
        end;
    finally
        if Assigned(ITmpObj) then
            ITmpObj := nil;
    end;
end;
/////////////////
      {/p117 gek  added this test to see if the image was deleted this session...
        When image is deleted, we don't update the individual TimageData of the image.
        We show a 'Refresh' icon, to the user as an indication that the image needs refreshed.
        we'll keep a local list of images deltedd, to stop the possibility of modifying data
        of a delted imagee. }
function TfrmVerify.IsDeletedThisSession(FCurrentImageObjectVerify: TImageData): boolean;
begin
result :=  (self.FDeletedThisSession.IndexOf(FCurrentImageObjectVerify.Mag0) > -1);
end;

function TfrmVerify.IsQuickFilterOpen: boolean;
begin
    Result := pnlQuickFilter.height > 35;
end;

procedure TfrmVerify.UserPrefUpdate;
var
    scol: string;
begin
    upref.VerifyStyle := 2;
    upref.VerifyPos.left := self.left;
    upref.VerifyPos.top := self.top; { top,  left , right, bottom  }
    upref.VerifyPos.right := self.width;
    upref.VerifyPos.BOTTOM := self.height;

    upref.VerifyShowReport := self.pnlReport.Height > 21;
    upref.VerifyShowInfo := self.pnlinfo.Height > 21;
    upref.VerifyHideQFonSearch := not IsQuickFilterOpen;
    upref.VerifySingleView := self.FViewSingleImage;

    scol := self.MagListViewVerify.GetColumnWidths;
    if scol <> '' then
        upref.VerifyColWidths := scol;
    upref.VerifyControlPos := inttostr(pnlLeft.Width) + ',' +
        magbooltostrint(magViewerTB1.CoolBar1.Bands[0].Break) + ',' +
        magbooltostrint(magViewerTB1.CoolBar1.Bands[1].Break) + ',' +
        magbooltostrint(magViewerTB1.CoolBar1.Bands[2].Break) + ',';
end;

procedure TfrmVerify.UserPrefsApply(upref: Tuserpreferences);
begin
    if upref = nil then
        exit;
    magsetbounds(frmVerify, upref.VerifyPos);

    ShowImageReport(upref.VerifyShowReport);
    ShowImageInfo(upref.VerifyShowInfo);
    FVerifyHideQFonSearch := upref.VerifyHideQFonSearch; //not used 93
    FViewSingleImage := upref.VerifySingleView;
    //not in 93    Mag4Viewer1.ClearBeforeAddDrop := FViewSingleImage;
    //in 93 we force 1 image
    Mag4Viewer1.ClearBeforeAddDrop := true;
    self.MagListViewVerify.SetColumnWidths(upref.VerifyColWidths);
    try
        if upref.VerifyControlPos <> '' then
        begin
            pnlleft.Width := strtoint(magpiece(upref.VerifyControlPos, ',', 1));
            magViewerTB1.CoolBar1.Bands[0].Break := magstrtobool(magpiece(upref.VerifyControlPos, ',', 2));
            magViewerTB1.CoolBar1.Bands[1].Break := magstrtobool(magpiece(upref.VerifyControlPos, ',', 3));
            magViewerTB1.CoolBar1.Bands[2].Break := magstrtobool(magpiece(upref.VerifyControlPos, ',', 4));

        end;
    except
        on e: exception do
        begin
            //
        end;
    end;
    ;
end;

procedure TfrmVerify.mnuMainFilter1Click(Sender: TObject);
begin
    {	JK 1/13/2009 - fixes D51. If the quick filter panel is open then disable the Quick Filter
      menu item and vice versa}
    mnuQuickFilter1.checked := IsQuickPanelOpen;
end;

{	JK 1/14/2009 - Fixes D49.  Slows down list advancement.  Also look at
  TfrmVerify.MagListViewVerifySelectItem for this defect fix.}

procedure TfrmVerify.MagListViewVerifyChanging(Sender: TObject;
    Item: TListItem; Change: TItemChange; var AllowChange: Boolean);
begin
    ////   gek   this doesn't do anything, the list is called 1 time for each item when it is being destroyed.
    ////     if csDestroying in self.ComponentState then exit;

    //next four out temporary, need a better way.  gek
    //  if Screen.Cursor = crDefault then
    //    AllowChange := True
    //  else
    //    AllowChange := False;
end;

procedure TfrmVerify.mnuActionClick(Sender: TObject);
var hasimage : boolean;
isdeleted : boolean;
begin
isdeleted := false;
    {/p117 gek   Added checks for the different key, to enable/disable menu items.}
    hasimage := (FCurrentImageObjectVerify.Mag0 <> '');
    if hasimage then isdeleted := FCurrentImageObjectVerify.IsImageDeleted
                               or IsDeletedThisSession(FCurrentImageObjectVerify); ;



  //117  value: boolean;
   //117    value := (self.MagListViewVerify.Items.Count > 0) and (self.MagListViewVerify.SelCount > 0);

    mnuImageStatusToVerified.Enabled := hasimage and (not isdeleted) ; // := value;
    mnuImageStatusToNeedsReview.Enabled := hasimage and (not isdeleted) ; //:= value;


    SetProcessButtons;
end;

procedure TfrmVerify.cmbPercentChange(Sender: TObject);
begin
    cmbMaxNum.itemindex := -1;
    cmbMaxNum.text := '';
    AlertSearchPropertyChange(true);
end;

procedure TfrmVerify.cmbMaxNumChange(Sender: TObject);
begin
    cmbPercent.itemindex := -1;
    cmbPercent.text := '';
    AlertSearchPropertyChange(true);
end;

procedure TfrmVerify.FormShow(Sender: TObject);
begin
    try
        {JK 4/6/2009 - 508 work}
        SetInitialFocus;

        {Adjust the coolbar's content and size for the Verify function}
        MagViewerTB1.tbApplyToAll.Visible := False;
        MagViewerTB1.tbTile.Visible := False;
        MagViewerTB1.tbMaximize.Visible := False;
        MagViewerTB1.tbtnRemoveSelected.Visible := False;
        MagViewerTB1.tbtnRemoveAll.Visible := False;
        MagViewerTB1.tbReportmnu.Visible := False;
        MagViewerTB1.ToolBar1.AutoSize := False;
        MagViewerTB1.ToolBar1.Width := 10;
        MagViewerTB1.ToolBar2.AutoSize := False;
        MagViewerTB1.ToolBar2.Width := 10;

        MagViewerTB1.CoolBar1.Bands[0].Width := 7 * MagViewerTB1.tbtnZoomPlus.Width;
        MagViewerTB1.CoolBar1.Bands[1].Width := 7 * MagViewerTB1.tbtnZoomPlus.Width;
        MagViewerTB1.CoolBar1.Bands[2].Width := 7 * MagViewerTB1.tbtnZoomPlus.Width;
    except
        on E: Exception do
            DebugFile('TfrmVerify.FormShow error = ' + E.Message);
    end;
end;

procedure TfrmVerify.ZoomIn1Click(Sender: TObject);
begin
    MagViewerTB1.tbicZoom.Position := MagViewerTB1.tbicZoom.Position + 20;
end;

procedure TfrmVerify.ZoomOut1Click(Sender: TObject);
begin
    MagViewerTB1.tbicZoom.Position := MagViewerTB1.tbicZoom.Position - 20;
    MagViewerTB1.UpdateImageState;
end;

procedure TfrmVerify.FitToWidth1Click(Sender: TObject);
begin
    Mag4Viewer1.FitToWidth;
end;

procedure TfrmVerify.FitToHeight1Click(Sender: TObject);
begin
    Mag4Viewer1.FitToHeight;
end;

procedure TfrmVerify.FitToWindow1Click(Sender: TObject);
begin
    Mag4Viewer1.fittowindow;
end;

procedure TfrmVerify.ActualSize1Click(Sender: TObject);
begin
    Mag4Viewer1.Fit1to1;
end;

procedure TfrmVerify.Pan1Click(Sender: TObject);
begin
    Mag4Viewer1.MousePan;
end;

procedure TfrmVerify.Magnify1Click(Sender: TObject);
begin
    Mag4Viewer1.MouseMagnify;
end;

procedure TfrmVerify.Zoom2Click(Sender: TObject);
begin
    Mag4Viewer1.MouseZoomRect;
end;

procedure TfrmVerify.Pointer1Click(Sender: TObject);
begin
    Mag4Viewer1.MouseReset;
end;

procedure TfrmVerify.Right1Click(Sender: TObject);
begin
    Mag4Viewer1.Rotate(90);
end;

procedure TfrmVerify.Left1Click(Sender: TObject);
begin
    Mag4Viewer1.Rotate(270);
end;

procedure TfrmVerify.N1801Click(Sender: TObject);
begin
    Mag4Viewer1.rotate(180);
end;

procedure TfrmVerify.FlipHorizontal1Click(Sender: TObject);
begin
    Mag4Viewer1.FlipHoriz;
end;

procedure TfrmVerify.FlipVertical1Click(Sender: TObject);
begin
    Mag4Viewer1.FlipVert;
end;

procedure TfrmVerify.Contrast1Click(Sender: TObject);
begin
    with MagviewerTB1 do
    begin
        if ((tbicContrast.Position + 5) > tbicContrast.Max) then
            tbicContrast.Position := tbicContrast.Max
        else
            tbicContrast.Position := tbicContrast.Position + 5;

    end;
end;

procedure TfrmVerify.Contrast2Click(Sender: TObject);
begin
    with MagviewerTB1 do
    begin
        if ((tbicContrast.Position - 5) < tbicContrast.Min) then
            tbicContrast.Position := tbicContrast.Min
        else
            tbicContrast.Position := tbicContrast.Position - 5;
    end;
end;

procedure TfrmVerify.Brightness1Click(Sender: TObject);
begin
    with MagviewerTB1 do
    begin
        if ((tbicBrightness.Position + 15) > tbicBrightness.Max) then
            tbicBrightness.Position := tbicBrightness.Max
        else
            tbicBrightness.Position := tbicBrightness.Position + 15;
    end;
end;

procedure TfrmVerify.Brightness2Click(Sender: TObject);
begin
    with MagviewerTB1 do
    begin
        if ((tbicBrightness.Position - 15) < tbicBrightness.Min) then
            tbicBrightness.Position := tbicBrightness.Min
        else
            tbicBrightness.Position := tbicBrightness.Position - 15;
    end;
end;

procedure TfrmVerify.mnuInvert1Click(Sender: TObject);
begin
    Mag4Viewer1.Inverse;
end;

procedure TfrmVerify.mnuReset1Click(Sender: TObject);
begin
    Mag4Viewer1.ResetImages;
end;

procedure TfrmVerify.opLeft1Click(Sender: TObject);
begin
    mag4Viewer1.ScrollCornerTL;
end;

procedure TfrmVerify.opRight1Click(Sender: TObject);
begin
    Mag4Viewer1.ScrollCornerTR
end;

procedure TfrmVerify.BottomLeft1Click(Sender: TObject);
begin
    Mag4Viewer1.ScrollCornerBL;
end;

procedure TfrmVerify.BottomRight1Click(Sender: TObject);
begin
    Mag4Viewer1.ScrollCornerBR;
end;

procedure TfrmVerify.Left2Click(Sender: TObject);
begin
    Mag4Viewer1.ScrollLeft
end;

procedure TfrmVerify.Right2Click(Sender: TObject);
begin
    Mag4Viewer1.ScrollRight;
end;

procedure TfrmVerify.Up1Click(Sender: TObject);
begin
    Mag4Viewer1.ScrollUP;
end;

procedure TfrmVerify.Down1Click(Sender: TObject);
begin
    Mag4Viewer1.ScrollDown;
end;

procedure TfrmVerify.mnuMaximizeImage1Click(Sender: TObject);
begin
    Mag4Viewer1.MaximizeImage := true;
end;

procedure TfrmVerify.mnuPreviousImage1Click(Sender: TObject);
begin
    Self.SelectPrevImage;
end;

procedure TfrmVerify.mnuNextImage1Click(Sender: TObject);
begin
    self.SelectNextImage;
end;

procedure TfrmVerify.mnuImageClick(Sender: TObject);
var
    lstloaded: boolean;
    i: Integer;
begin
    lstloaded := (self.MagListViewVerify.Items.Count > 0);

    for i := 0 to mnuImage.Count - 1 do
        mnuImage[i].Enabled := lstloaded and (mag4viewer1.GetCurrentImage <> nil);
    SetProcessButtons();
end;

procedure TfrmVerify.ShortcutKeylegend1Click(Sender: TObject);
begin
    {JK - 4/20/2009}
    //IconShortCutLegend;
  {p94t2 gek Call form directly, not use umagdisplaymgr}
       frmIconLegend.Execute;
end;

procedure TfrmVerify.mnuHideToolbarClick(Sender: TObject);
begin
    {JK 4/21/2009 - needed to hide/unhide the toolbar}
    mnuHideToolbar.Checked := not mnuHideToolbar.Checked;
    MagViewerTB1.Visible := mnuHideToolbar.Checked;
    MagViewerTB1.Update;
end;

procedure TfrmVerify.hiddenShortCutMenu1Click(Sender: TObject);
var
    pt: Tpoint;
begin
    pt.x := Mag4Viewer1.left;
    pt.y := Mag4Viewer1.Top;
    pt := Mag4Viewer1.ClientToScreen(pt);
    mnupopVerifyImage.PopupComponent := Mag4Viewer1;
    mnupopVerifyImage.popup(pt.x, pt.y);
end;

{JK 6/1/2009 - Runs Sergey's Image Verify Report}

procedure TfrmVerify.mnuImageStatusReportClick(Sender: TObject);
begin
{p94t2 gek Call form directly, not use umagdisplaymgr}

//    frmVerifyStats.Execute(dtfrom,dtto,lbedtDateRange.Caption);  {/ P117 - JK - Removed /}

  {/ P117 - JK 8/30/2010 - If the frmMagReportMgr screen is already open before reaching it from this
   modal form, close it before opening it.  Otherwise the frmMagReportMgr screen
   shows but is frozen. /}
  if DoesFormExist('frmMagReportMgr') then
    frmMagReportMgr.Free;

  {/ P117 - JK 8/10/2010 - Bring up the report manager.  The DtFrom and DtTo come from
     the currently selected date range of QA Review form (lbedtDateRange).  I populate
     the flag variable with an arbitrary choice of CDEU. /}
  frmMagReportMgr.Execute(Self, 'QASTATS', DtFrom, DtTo, 'CDEU');

    //OpenVerifyReport(dtfrom, dtto, lbedtDateRange.Caption);

    (* with TfrmVerifyStats.Create(nil) do begin
      StartDate := dtfrom;
      EndDate   := dtto;
      ReportTitle := edtDateRange.Text;
      ShowModal;
    end;  *)
end;

procedure TfrmVerify.ClearImageInfoControlVerify;
begin
    SaveTopIndexVerify;
    lvInfoImageVerify.Items.Clear;
end;

procedure TfrmVerify.ReSetTopIndexVerify;
var
    scrollct: integer;
begin
    scrollct := 0;
    while lvInfoImageVerify.TopItem.Index <> FlvVerifyInfoTopIndex do
    begin
        if lvInfoImageVerify.topitem.Index > FlvVerifyInfoTopIndex then
            break;
        lvInfoImageVerify.Scroll(0, 20);
        lvInfoImageVerify.Update;
        inc(scrollct);
        if scrollct > 500 then
            break;
    end;
end;

procedure TfrmVerify.SaveTopIndexVerify;
begin
    if lvInfoImageVerify.TopItem = nil then
        exit;
    if (lvInfoImageVerify.TopItem.Index = -1) then
        exit;
    if lvInfoImageVerify.TopItem = nil then
        FlvVerifyInfoTopIndex := 0
    else
    begin
        FlvVerifyInfoTopIndex := lvInfoImageVerify.TopItem.Index;
        if FlvVerifyInfoTopIndex = -1 then
            FlvVerifyInfoTopIndex := 0;
    end;
end;

procedure TfrmVerify.mnuQAImageInfoAdvClick(Sender: TObject);
begin
    if FCurrentImageObjectVerify <> nil then
{p94t2 gek Call form directly, not use umagdisplaymgr}
        frmMagImageInfoSys.execute(FCurrentImageObjectVerify);
        {}//OpenImageInfoSys(FCurrentImageObjectVerify);
end;

procedure TfrmVerify.CurrentImageDeleteVerify;
var
    rstat: boolean;
    rmsg: string;
    vIobj : TimageData;
begin
    if FCurrentImageObjectVerify <> nil then
    begin
        if (FCurrentImageObjectVerify.ServerName <> dmod.MagDBBroker1.GetServer) or
            (FCurrentImageObjectVerify.ServerPort <> dmod.MagDBBroker1.GetListenerPort) then
        begin
            //maggmsgf.MagMsg('DI', 'You cannot delete an image from a remote site');
            MagLogger.MagMsg('DI', 'You cannot delete an image from a remote site'); {JK 10/5/2009 - Maggmsgu refactoring}
            exit;
        end;
        //logmsg('s', 'Attempting deletion of ' + FCurrentImageObjectVerify.ffile +
        //    '  IEN ' + FCurrentImageObjectVerify.Mag0);
        MagLogger.LogMsg('s', 'Attempting deletion of ' + FCurrentImageObjectVerify.ffile +
            '  IEN ' + FCurrentImageObjectVerify.Mag0); {JK 10/6/2009 - Maggmsgu refactoring}
        {/p94t2 gek getting rid of dependency on uMagDisplayMgr}
        //if MgrImageDelete(FCurrentImageObjectVerify, rmsg) then
        if utilImageDelete(FCurrentImageObjectVerify, dmod.MagDBBroker1, rmsg) then
        begin
            FDeletedThisSession.Add(self.FCurrentImageObjectVerify.Mag0) ;
            utilLogActions('IMAGELIST', 'DELETE', FCurrentImageObjectVerify.Mag0, dmod.MagDBBroker1);
            { TODO -cSynchronize Status : NEED TO REFRESH THE ICONS IN THE IMAGE TREE VIEW
              ListView, TreeView, FullRes Local, Full Res Window  etc.... AbsLocal, Abs Window
            need to use the Publish Subscribe for changing status, state, etc.}
            { TODO -cSynchronize Status : NEED TO DO SOMETHING WHEN THE ABSTRACT IS DELETED.  }

            if MagListViewVerify.visible then
                begin
                if not FcurrentImageObjectVerify.IsInImageGroup then
                begin

                MagListViewVerify.ImageStatusChange(FCurrentImageObjectVerify,  umagdefinitions.mistDeleted);
                MagListViewVerify.ImageStateChange(FCurrentImageObjectVerify, umagdefinitions.mistateNeedsRefresh);
                end;

                if FcurrentImageObjectVerify.IsInImageGroup then
                    begin
                    MagListViewVerify.ImageStateChange(MagListViewVerify.GetSelectedImageObj,  umagdefinitions.mistateNeedsRefresh);
                    //p117 gek   the removeFromList works if ViewStyle is not magvsVirtual.  ....
                    // abs is removed, but then nothing is selected, and error when 'Next' is clicked.
                    {gek the 'zz' worked but remove one from list always deselects the current....
                        currently in Display,  when an image is deleted, it is NOT removed from the absviewer.
                          user has to refresh ... we'll stay that way for now.  or 'yyy' below}
                    //zz//  vIobj := self.VerifyWinGrpAbsViewer.GetCurrentImageObject;
                    //zz//  self.SelectNextImage;
                    //zz//  self.VerifyWinGrpAbsViewer.RemoveOneFromList(vIobj);
                    {removes current from list, and leave none selected.}
                    //lll// self.VerifyWinGrpAbsViewer.RemoveFromList;


                    {this will refresh the GroupAbsViewer, taking out the deleted image and select the first image  }
                    timer1.Enabled := true;
                    end;
                end;

            // self.MagTreeView1.
            mag4viewer1.ClearViewer;
            //// abs window, full window... need to use the Publish Subscribe for changing status, state, etc.
        end;
    end
    else
     winmsg(stpnlmsg, 'Select an Image, then select the ''Delete'' option');
end;

procedure TfrmVerify.mnuQAImageDeleteClick(Sender: TObject);
begin
    CurrentImageDeleteVerify;
end;

procedure TfrmVerify.ImageDelete2Click(Sender: TObject);
begin
    CurrentImageDeleteVerify;
end;

procedure TfrmVerify.ImageInformationAdvanced1Click(Sender: TObject);
begin
    if FCurrentImageObjectVerify <> nil then
        frmMagImageInfoSys.execute(FCurrentImageObjectVerify);
        {}//OpenImageInfoSys(FCurrentImageObjectVerify);
end;

procedure TfrmVerify.mnuCapAppVICapClick(Sender: TObject);
begin
    if not mnuCapAppVICap.Checked then
        mnuCapAppIAPI.Checked := true;
    AlertSearchPropertyChange(true);
end;

procedure TfrmVerify.mnuCapAppIAPIClick(Sender: TObject);
begin
    if not mnuCapAppIAPI.Checked then
        mnuCapAppVICap.Checked := true;
    AlertSearchPropertyChange(true);
end;

procedure TfrmVerify.ImageIndexEdit1Click(Sender: TObject);
begin

    CurrentVerifyImageIndexEdit;
end;

procedure TfrmVerify.MagListViewVerifyEnter(Sender: TObject);
begin
    if self.MagListViewVerify.Items.Count = 0 then
        exit;
    if self.MagListViewVerify.ItemIndex = -1 then
        MagListViewVerify.ItemIndex := 0;
end;

procedure TfrmVerify.cmbDateRangeExit(Sender: TObject);
begin
    { Design change : Now this only gets date range from selected entry in Date
       combo.  It doesn't automatically get users and force a drop down. }
   // GetDateRange;
    if ((lbedtDateRange.Caption <> '') and (FPreviousDateRange <> lbedtDateRange.Caption)) then
    begin
        AlertSearchPropertyChange(true);
        //  QFGetCaptureUsersInDateRange(dtfrom, dtto);  //7/13/  moved here
          //btnSearch.Enabled := True;          //7/13/
    end;
    FPreviousDateRange := lbedtDateRange.Caption;

end;

procedure TfrmVerify.cmbUsersClick(Sender: TObject);
begin
    AlertSearchPropertyChange(true);
end;

procedure TfrmVerify.cmbDateRangeKeyDown(Sender: TObject; var Key: Word; Shift: TShiftState);
begin
    exit;
    if (KEY = VK_RETURN) then
    begin
        GetDateRange;
        self.CaptureUsersRefreshNeeded;
    end;
end;

procedure TfrmVerify.GenGoToNextControl(edt: TWinControl = nil);
var
    tl: Tlist;
    i: integer;
    smsg, s: string;
    nextctrlok: boolean;
begin
    //cap  if not FAutoTab then Exit;      //WPR AUTO
    //FindNextControl(edt, true, true, true).setfocus;
    tl := Tlist.create;
    smsg := '';
    try
        if edt = nil then
        begin
            self.GetTabOrderList(tl);
            (* testing see ctrls in list *)
                     (*
                     memo1.Lines.Add('Gen Control List     -------------------- ') ;
                     for i := 0 to tl.count-1 do
                     begin
                     s :=  TWincontrol(tl[i]).name;

                           if TWincontrol(tl[i]).enabled then s := s + ' --Enbld';
                           if TWincontrol(tl[i]).visible then s := s + ' --Vsble';
                           if TWincontrol(tl[i]).TabStop then s := s + ' -- TabStop';

                     memo1.lines.Add(s);
                     end;
                     *)
               //smsg := smsg+(TWincontrol(tl[i]).name)+#13;
               //showmessage(smsg);
            exit;
        end;

        i := tl.indexof(edt);
        nextctrlok := false;
        while not nextctrlok do
        begin
            i := i + 1;
            if (i > (tl.count - 1)) then
                break; // don't want to go around
            // testing see ctrls in list     showmessage(TWincontrol(tl[i]).name);
            if TWincontrol(tl[i]).enabled
                and TWincontrol(tl[i]).visible
                and TWincontrol(tl[i]).TabStop then
            begin
                nextctrlok := true;
                TWincontrol(tl[i]).setfocus;
            end;
        end;
    finally
        tl.free;
    end;
end;

procedure TfrmVerify.cmbDateRangeEnter(Sender: TObject);
begin
    //ShowFocusControlRect;
end;

procedure TfrmVerify.ShowFocusControlRect;
begin
    exit;

    TimerFade.Enabled := false;
    MoveRectangleToFocusControl;
    FMyFocusWin.Visible := true;
    TimerFade.Enabled := true;
end;

procedure TfrmVerify.cmbDateRangeSelect(Sender: TObject);
begin
    GetDateRange;
    self.CaptureUsersRefreshNeeded;
end;

procedure TfrmVerify.MagListViewVerifyKeyDown(Sender: TObject;
    var Key: Word; Shift: TShiftState);
begin
    if key = 9 then
        self.cmbDateRange.SetFocus;
end;

procedure TfrmVerify.GenNextControl1Click(Sender: TObject);
begin
    self.GenGoToNextControl();
end;

procedure TfrmVerify.btnCapByClick(Sender: TObject);
begin
 winmsg(stpnlmsg,'');
    QFGetCaptureUsersInDateRange(dtfrom, dtto); //7/13/  moved here
    //btnSearch.Enabled := True;          //7/13/
end;

procedure TfrmVerify.cmbUsersSelect(Sender: TObject);
begin
    if (copy(cmbUsers.Text, 1, 1) <> '<') then
        btnSearch.Enabled := true;
end;

procedure TfrmVerify.File1Click(Sender: TObject);
var hasimage : boolean;
isdeleted : boolean;
begin
 mnuQAImageInfoAdv.visible := userhaskey('MAG SYSTEM');
 //
isdeleted := false;
    {/p117 gek   Added checks for the different key, to enable/disable menu items.}
    hasimage := (FCurrentImageObjectVerify.Mag0 <> '');
    if hasimage then isdeleted := FCurrentImageObjectVerify.IsImageDeleted
                                  or IsDeletedThisSession(FCurrentImageObjectVerify);

    mnuQAImageDelete.Enabled := hasimage
                                and (userhaskey('MAG DELETE') or userhaskey('MAG SYSTEM'))
                                and (not isdeleted);
    mnuQAImageIndexEdit.Enabled := hasimage
                                   and UserHasKey('MAG EDIT')
                                   and (not isdeleted); //P117 mag edit check.
    mnuQAImageInfoAdv.Enabled := hasimage and userhaskey('MAG SYSTEM');

end;

procedure TfrmVerify.btnVerifyEnter(Sender: TObject);
begin
    imgVerifyOutline.Visible := true;
end;

procedure TfrmVerify.btnVerifyExit(Sender: TObject);
begin
    imgVerifyOutline.Visible := false;
end;

procedure TfrmVerify.btnNextEnter(Sender: TObject);
begin
    imgNextOutline.Visible := true;
end;

procedure TfrmVerify.btnNextExit(Sender: TObject);
begin
    imgNextOutline.Visible := false;
end;

procedure TfrmVerify.btnPrevEnter(Sender: TObject);
begin
    imgPrevOutline.Visible := true;
end;

procedure TfrmVerify.btnPrevExit(Sender: TObject);
begin
    imgPrevOutline.Visible := false;
end;

procedure TfrmVerify.FocusRect1Click(Sender: TObject);
begin
    ShowFocusControlRect;
end;

procedure TfrmVerify.MoveRectangleToFocusControl;
var
    x, l, t, l1, l2, l3, adj, l4, t1, t2, t3, t4: integer;
    w3, h3: integer;
    tp1, tp2, tp3: Tpoint;
    twc, pwc, awc: Twincontrol;

begin
    adj := 4;
    twc := self.activecontrol;
    awc := self.ActiveControl;
    l3 := 0;
    t3 := 0;
    l := 0;
    t := 0;

    repeat
        pwc := awc.Parent;
        l3 := l3 + awc.Left;
        t3 := t3 + awc.Top;

        awc := pwc;
    until pwc = frmVerify;
    l := pwc.Left;
    t := pwc.Top;

    x := height - self.ClientHeight;
    t := t + x;

    //FMyFocusWin.Top := (t+ t3 - adj)  -4   ;
    //FMyFocusWin.Left := (l + l3 + adj) -4  ;
    //FMyFocusWin.Height := (twc.Height) +8  ;
    //FMyFocusWin.Width := (twc.Width)  +8   ;

    FMyFocusWin.Top := (t3 - adj) - 4;
    FMyFocusWin.Left := (l3 + adj) - 4;
    FMyFocusWin.Height := (twc.Height) + 8;
    FMyFocusWin.Width := (twc.Width) + 8;

end;

procedure TfrmVerify.TimerFadeTimer(Sender: TObject);
var
    ab: integer;
begin
    //if FShowFade then
    //  begin
    //    frmFocus.AlphaBlendvalue := frmFocus.AlphaBlendvalue +20;
    //  end
    //  else

    begin
        ab := FMyFocusWin.AlphaBlendValue - 80;
        if ab < 0 then
        begin
            timerFade.Enabled := false;
            FMyFocusWin.AlphaBlendValue := 255;
            FMyFocusWin.Visible := false;
        end
        else
            FMyFocusWin.AlphaBlendValue := ab;

    end;

end;

procedure TfrmVerify.mnuTestAutoFocusRectClick(Sender: TObject);
begin
    mnuTestAutoFocusRect.Checked := not mnuTestAutoFocusRect.Checked;
    FUseFocusRectangle := mnuTestAutoFocusRect.Checked;

end;

procedure TfrmVerify.btnCapByEnter(Sender: TObject);
begin
    ShowFocusControlRect;
end;

procedure TfrmVerify.cmbUsersEnter(Sender: TObject);
begin
    ShowFocusControlRect;
end;

procedure TfrmVerify.cmbPercentEnter(Sender: TObject);
begin
    ShowFocusControlRect;
end;

procedure TfrmVerify.cmbMaxNumEnter(Sender: TObject);
begin
    ShowFocusControlRect;
end;

procedure TfrmVerify.Help2Click(Sender: TObject);
//begin
//    application.HelpContext(10225);
var whatsnew : string;
begin
whatsnew := apppath + '\MagWhats New in Patch 93.pdf';
    {      the file is named : 'MagWhats New in Patch 93.pdf'}
    if fileexists(whatsnew) then
      begin
      MagExecuteFile(whatsnew, '', '', SW_SHOW);
      end
    else messagedlg('Help file for Patch 93 is missing.',mtconfirmation, [mbok],0);
end;


procedure TfrmVerify.mnuOptionsMessageWindowClick(Sender: TObject);
begin
    maglogger.show;
    maglogger.BringToFront;
end;

function TfrmVerify.DetailedDescStringGen(filter : TImagefilter) : string;
var
  sm, s, stype, sspec, sproc: String;
  ixien: String;
  i, ixp, ixl, ixi: Integer;
begin

  result := '';

  s := ClassesToStringGen(filter.Classes);

  if s <> '' then
    result := result + ('Class: '+s+'. ');
  s := filter.Origin;
  if s <> '' then
  begin
    if pos(',',s) =1 then
      s := copy(s,2,999);
    result := result + ('Origin: '+s+'. ');
   end;

  // we have a few if, rather that if then else for a reason
  //  we want to make sure the date properties are getting cleared when
  //  they should.  Only one of the IF's below, should be TRUE.
  //   If not, then we'll see it and know of a problem.
  if ((filter.FromDate <> '') or (filter.ToDate <> '')) then
  begin
  ;
  //result := result + ('From: '+filter.FromDate+' -> '+filter.ToDate+'. ');
  result := result + (formatdatetime('mmm dd,yyyy',strtodatetime(filter.FromDate))+' -> '
                   + formatdatetime('mmm dd,yyyy',strtodatetime(filter.ToDate)) +'. ');
     if filter.UseCapDt then
       result := result + ('(Capture Date) ');
  end;

  if (filter.MonthRange <> 0) then
  begin
    if abs(filter.MonthRange) = 1 then
      sm := ' month. '
    else
      sm := ' months. ';

    result := result + ('for the last '+inttostr(abs(filter.MonthRange))+ sm);
    if filter.UseCapDt then
      result := result + ('(Capture Date) ');
  end;

  if (filter.MonthRange = 0) and (filter.FromDate ='') and (filter.ToDate = '') then
  begin
    result := result + ('All Dates. ');
    if filter.UseCapDt then
      result := result + ('(Capture Date) ');
  end;

  s := PackagesToString(filter.Packages);
  if s <> '' then
    result := result + ('Pkg: '+s+'. ');


  stype := filter.Types;
  s := '';
  if stype <> '' then
  begin
    ixl := maglength(stype,',');
    for ixi := 1 to ixl do
    begin
      ixien := magpiece(stype,',',ixi);
      if ixien <> '' then
        S := S + ',' +   dmod.MagDBBroker1.RPXWBGetVariableValue('$P($G(^MAG(2005.83,'+ixien+',0)),U,1)') ;
    end;
  end;

  if s <> '' then result := result + (s)+'. ';

  sspec := filter.SpecSubSpec;
  s := '';
  if sspec <> '' then
  begin
    ixl := maglength(sspec,',');
    for ixi := 1 to ixl do
    begin
      ixien := magpiece(sspec,',',ixi);
      if ixien <> '' then
        S := S + ',' +  dmod.MagDBBroker1.RPXWBGetVariableValue('$P($G(^MAG(2005.84,'+ixien+',0)),U,1)') ;
    end;
  end;
  if s <> '' then
    result := result + (s)+'. ';

  sproc := filter.ProcEvent;
  s := '';
  if sproc <> '' then
  begin
    ixl := maglength(sproc,',');
    for ixi := 1 to ixl do
    begin
      ixien := magpiece(sproc,',',ixi);
      if ixien <> '' then
        S := S + ',' +  dmod.MagDBBroker1.RPXWBGetVariableValue('$P($G(^MAG(2005.85,'+ixien+',0)),U,1)');
    end;
  end;
  if s <> '' then result := result + (s)+'. ';

  {  s := filter.Origin;
  if s='' then s := 'Any';
  if pos(',',s) =1 then s := copy(s,2,999);
  result.add('Origin :       '+s);}

  s := filter.Status;
  if s <> '' then
    result := result + ('Status: '+s)+'. ';

  ixien := filter.ImageCapturedBy;
  if ixien <> '' then
    s := 'Saved by: ' + dmod.MagDBBroker1.RPXWBGetVariableValue('$P($G(^VA(200,'+ixien+',0)),U,1)')
   else
     s := '';
   if s <> '' then
     result := result + (s)+'. ';

   //result.Add('Short Description has:');
   s := filter.ShortDescHas;
   if s <> '' then
     result := result + ('Short Desc: ' + s)+'. ';
end;
{/gek p117   new for 117 showing groups}
procedure TfrmVerify.ShowGroupAbs(xIobj : TImageData) ;
var
  temp: Tstringlist;
begin
  (*if pnlviewer.Height < 5 then
    begin
      height := height + 150;
      pnlviewer.height := 150; // := true;
    end; *)
  temp := TSTringlist.create;
if not VerifyWinGrpAbsViewer.Visible then
  begin
    VerifyWinGrpAbsViewer.Visible := true;
  end;
  try
    dmod.MagDBBroker1.RPMaggGroupImages(xIObj, temp, true, '');  {/ P117 - JK 9/2/2010 /}
    winmsg(stpnlmsg, 'Image Group selected, accessing Group Images...');
    if temp.count = 1 then winmsg(stpnlmsg, magpiece(temp.strings[0], '^', 2));
    dmod.MagDBBroker1.RPMaggQueImageGroup('A', xIObj);
    if (temp.Count = 0) or (temp.Count = 1) then
      begin
        winmsg(stpnlmsg, 'ERROR: Accessing Group Images.  See VistA Error Log.');
        Screen.cursor := crDefault;
        exit;
      end;
    temp.delete(0);
    winmsg(stpnlmsg, 'Loading Abstracts to Viewer');
    try
      magImageList2.LoadGroupList(temp, '', ''); //oot
      application.processmessages;

    except
      on e: exception do
        begin
          showmessage('exception : ' + e.message);
        end;
    end;
    winmsg(stpnlmsg, '');
    VerifyWinGrpAbsViewer.ReAlignImages;
  finally
    temp.free;
  end;
end;

procedure TfrmVerify.VerifyWinGrpAbsViewerViewerImageClick( sender: TObject);
var vIobj : TimageData;
objlist: Tlist;
begin
try
FDisplaying := true;
           objlist := TList.Create;
// testing.
//winmsg(stpnlmsg,'IMAGE SELECTED FROM GROUP: ___');
vIobj := verifyWinGrpAbsViewer.GetCurrentImageObject;
if vIobj = nil then exit;
winmsg(stpnlmsg,'Image selected from Group: ' + vIobj.Mag0);

                        if not vIobj.IsImageGroup then
                        begin
                        objList.Add(vIObj);
                        Mag4Viewer1.ImagesToMagView(objlist, false);
                        end;



finally
           objlist.free;
           FDisplaying := false;
end;
end;

procedure TfrmVerify.mnuGroupViewerPopup(Sender: TObject);
begin
  mnuAbsToolbar.Checked := VerifyWinGrpAbsViewer.tbViewer.Visible;

end;

procedure TfrmVerify.mnuAbsToolbarClick(Sender: TObject);
begin
  VerifyWinGrpAbsViewer.tbViewer.Visible := mnuAbsToolbar.Checked;
end;

procedure TfrmVerify.mnuAbsRefreshClick(Sender: TObject);
begin
   RefreshGroupVerify;
end;

procedure TfrmVerify.RefreshGroupVerify();  //117  update the status's on the group images in abs viewer
var Iobj, grpIobj : TimageData;
begin
grpIobj := mag4viewer1.GetCurrentImageObject;
Iobj := maglistviewverify.GetSelectedImageObj;
ShowGroupAbs(Iobj) ;  //
self.VerifyWinGrpAbsViewer.SyncWithIMage(grpIobj, false);
//SelectNextImage;

end;


procedure TfrmVerify.SetDefaultThumbNailAlignment;
begin
  VerifyWinGrpAbsViewer.ReSizeAndAlign(150, 115);
  VerifyWinGrpAbsViewer.ReFreshImages;
end;

procedure TfrmVerify.SetDefaultFullViewerAlignment;     
begin
  Mag4Viewer1.SetRowColCount(1, 1);
  Mag4Viewer1.ReFreshImages;
end;

end.

