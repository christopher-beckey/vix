Unit cmag4viewer;
{
Package: MAG - VistA Imaging
WARNING: Per VHA Directive 10-93-142 this unit should not be modified.
Date Created:
Site Name: Silver Spring, OIFO
Developers: Garrett Kirin
[==   unit cMag4Viewer;
Description: Image Viewer.
     The Viewers function is just to manipulate Tmag4VGear objects.
     It handles the Creation, destruction,  Alignment, Resizing etc.
     of it's contained images.  The Viewer passes image operations like
     FitToWidth, Invert, Zoom etc to the selected Image Objects.
     By Itself it has no association with any database.   Any database
     operations are handled by the TMagUtilsDB component linked to the Viewer.

     TMag4VGear is a Wrapper around Accusoft's TGear control.

     Future:   The Viewer will implement the IMagImage Interface
     (yet to be created) and support the handling of any object that
      implements the IMagImage Interface.  We will be able to treat unrelated
      objects Polymorphically.  We we won't be limited to using
      Accusoft controls for all our Imaging needs.

      The Viewer makes use of the TImageProxy Class.  A TImageProxy is just a
      placeholder for a Tmag4VGear object.  In the method 'ImagesToMagView'
      ('ImagesToMagView() is the method to load images into a Viewer)
      a TImageProxy is created for each image and added to the FProxyList.
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
//{$DEFINE PROTOUNDO}
Interface

Uses
  Windows,
  ImgList,
  ToolWin,
  Menus,
  Classes,
  Stdctrls,
  ComCtrls,
  Controls,
  ExtCtrls,
  Forms,
  Graphics,

  cImageProxy,
  cMag4Vgear,
  cMagEventScrollBox,
  cMagImageList,
  //cMagLogManager,  {JK 10/5/2009 - Maggmsgu refactoring - deprecated unit}
  cMagSecurity,
  cMagUtilsDB,
  cMagVUtils,
  ImagInterfaces,
  IMagViewer,
  Magremoteinterface,
  UMagClasses,
  UMagClassesAnnot,
  UMagDefinitions
    , Maggmsgu   {//p117 out Gek  refactor, decouple.... not yet.}

  ;

//Uses Vetted 20090929:FMagAnnotation, ImgList, fMagLoadingImageMessage, umagappmgr, ToolWin, Buttons, Messages, cMagImageUtility, cMagImageAccessLogManager, MagImageManager, geardef, cmaglistview, Dialogs, SysUtils

// indicates how the VGear should look, how it should show the description and how it should be sized
Type
  TMagViewerViewStyle = (MagViewerViewAbs, MagViewerViewFull,
    MagViewerViewRadiology);

Type
  TMagViewerWinLevSettings = (MagWinLevImageSettings,
    MagWinLevFromCurrentImage);

Type
    {   Class to store the properties of a Viewer Layout style }
  TMagLayout = Class(Tobject)
  Public
    Rows: Integer;
    Columns: Integer;
    MaxNumberOfImages: Integer;
    LockImageState: Boolean;
    FitMethod: Integer;
  End;
    {  Not Implemented.}
  TMagUnDoAction = (MagundoAdd, MagundoRemove);
    {  Not Implemented.}
  TMagUnDoItem = Class(Tobject)
  Public
    MagCaption: String;
    MagUnDoGroup: Integer;
    MagIproxy: TImageProxy;
    MagUnDoAction: TMagUnDoAction;
  End;
    {different styles of displaying images and data}
  TMagDisplayStyles = (MagdsLine, MagdsData, MagdsDetails);
    {diff styles of Viewer, Virtual: is only one being used.}

  // moved to iMagViewer
  //  TMagViewerStyles = (magvsVirtual, magvsStaticPage, magvsDynamic, magvsLayout);

  TMag4Viewer = Class; // the ';' says forward declaration}
    {TMagVListChange is for OnListChangeEvent}
  TMagVListChange = Procedure(Sender: Tobject) Of Object;
    { TMagVClick is for OnViewerImageClick}
  TMagVClick = Procedure(Sender: Tobject) Of Object;
    {TMagViewerClickEvent  is for OnViewerClick}
  TMagViewerClickEvent = Procedure(Sender: Tobject; Viewer: TMag4Viewer;
    MagImage: TMag4VGear) Of Object;

  TMagImageDoubleClickEvent = Procedure(Sender: Tobject; MagImage: TMag4VGear)
    Of Object;
    {Returns pointers to Viewer Object, and ImageObject }
  //TMag4Image = TMag4VGear;

  TMagPageNextViewerEvent = Procedure(Sender: Tobject) Of Object;
  TMagPagePreviousViewerEvent = Procedure(Sender: Tobject) Of Object;
  TMagPageFirstViewerEvent = Procedure(Sender: Tobject) Of Object;
  TMagPageLastViewerEvent = Procedure(Sender: Tobject) Of Object;

  TMag4Viewer = Class(TFrame, IMagObserver, IMagRemoteinterface, IMag4Viewer)

    Scrlv: TMagEventScrollBox;
    LbScrlvSize: Tlabel;
    TimerViewer: TTimer;
    PnlTop: Tpanel;
    LbHideScroll: Tpanel;
    StsbarMsg: TStatusBar;
    ImlViewerBmps: TImageList;

    TbViewer: TToolBar;
    TbClear: TToolButton;
    TbRefresh: TToolButton;
    TbPageFirst: TToolButton;
    TbPagePrev: TToolButton;
    TbPageNext: TToolButton;
    TbPageLast: TToolButton;
    TbConfig: TToolButton;
    TbtnAbsPageNext: TToolButton;
    TbtnAbsPagePrev: TToolButton;
    TbtnAbsSmaller: TToolButton;
    TbtnAbsBigger: TToolButton;

    PopupViewer: TPopupMenu;
    MnuToolbar: TMenuItem;
    AlignonTop1: TMenuItem;
    AligntoLeft1: TMenuItem;
    N1: TMenuItem;
    N2: TMenuItem;
    MnuScrollVertical: TMenuItem;
    MnuScrollHorz: TMenuItem;
    LblScrollBlocker: Tpanel;
    cboSeries: TComboBox;
    ImgStudyStatus: TImage;
    TopPanel: Tpanel;
    Image1: TImage;
    LbPnlTop: Tlabel;
    IlViewer16n: TImageList;
    ToolButton1: TToolButton;
    ToolButton2: TToolButton;

    Procedure ScrlVClick(Sender: Tobject);
    Procedure PnlTopStartDrag(Sender: Tobject; Var DragObject: TDragObject);
    Procedure PnlTopStartDock(Sender: Tobject; Var DragObject:
      TDragDockObject);
    Procedure PnlTopClick(Sender: Tobject);
    Procedure PnlTopEndDrag(Sender, Target: Tobject; x, y: Integer);
    Procedure PnlTopMouseMove(Sender: Tobject; Shift: TShiftState; x, y:
      Integer);
    Procedure PnlTopMouseDown(Sender: Tobject; Button: TMouseButton; Shift:
      TShiftState; x, y: Integer);
    Procedure FrameEndDock(Sender, Target: Tobject; x, y: Integer);
    Procedure PnlTopDragOver(Sender, Source: Tobject; x, y: Integer; State:
      TDragState; Var Accept: Boolean);
    Procedure PnlTopDragDrop(Sender, Source: Tobject; x, y: Integer);
    Procedure TbClearClick(Sender: Tobject);
    Procedure TbRefreshClick(Sender: Tobject);
    Procedure TbPagePrevClick(Sender: Tobject);
    Procedure TbPageNextClick(Sender: Tobject);
    Procedure MnuToolbarClick(Sender: Tobject);
    Procedure TbConfigClick(Sender: Tobject);
    Procedure AlignonTop1Click(Sender: Tobject);
    Procedure AligntoLeft1Click(Sender: Tobject);
    Procedure TbPageLastClick(Sender: Tobject);
    Procedure TbPageFirstClick(Sender: Tobject);
    Procedure TbtnAbsPagePrevClick(Sender: Tobject);
    Procedure TbtnAbsPageNextClick(Sender: Tobject);
    Procedure TbtnAbsSmallerClick(Sender: Tobject);
    Procedure TbtnAbsBiggerClick(Sender: Tobject);
    Procedure PopupViewerPopup(Sender: Tobject);
    Procedure ScrlVDragOver(Sender, Source: Tobject; x, y: Integer; State:
      TDragState; Var Accept: Boolean);
    Procedure ScrlVDragDrop(Sender, Source: Tobject; x, y: Integer);
    Procedure ScrlvScrollHorz(Sender: Tobject);
    Procedure ScrlvScrollVert(Sender: Tobject);
    Procedure ScrlvEndScroll(Sender: Tobject);
    Procedure MnuScrollVerticalClick(Sender: Tobject);
    Procedure MnuScrollHorzClick(Sender: Tobject);
    Procedure TimerViewerTimer(Sender: Tobject);
    Procedure LblScrollBlockerMouseDown(Sender: Tobject;
      Button: TMouseButton; Shift: TShiftState; x, y: Integer);
    Procedure cboSeriesChange(Sender: Tobject);
    Procedure FrameMouseWheelDown(Sender: Tobject; Shift: TShiftState;
      MousePos: TPoint; Var Handled: Boolean);
    Procedure FrameMouseWheelUp(Sender: Tobject; Shift: TShiftState;
      MousePos: TPoint; Var Handled: Boolean);
  Private

        {---------- Fields of Imaging Types ---}
            //Cur4Image: TMag4Image;
    FCur4Image: TMag4VGear;
    FOnChangeCur4Image: TNotifyEvent;
    //117
    FShowImageStatus : boolean;  //117
        //59
    FDisableScrollEvent: Boolean;
        {Disable Scroll tracking while setting scroll}
    FMagImageList: TMagImageList;
    FMagUtilsDB: TMagUtilsDB;
    FUtils: TMagVUtils;
    FDisplayStyle: TMagDisplayStyles;
    FViewerStyle: TMagViewerStyles;
    FTMagVClick: TMagVClick;
    FTMagVlistchange: TMagVListChange;
    FMagSecurity: TMag4Security;
    FViewerClickEvent: TMagViewerClickEvent;
    FImageDoubleClickEvent: TMagImageDoubleClickEvent;

    FPageNextViewerEvent: TMagPageNextViewerEvent;
    FPagePreviousViewerEvent: TMagPagePreviousViewerEvent;
    FPageFirstViewerEvent: TMagPageFirstViewerEvent;
    FPageLastViewerEvent: TMagPageLastViewerEvent;

        //out to stop error vcl70.bpl    FLoadingMsgWin:     TfrmLoadingImageMessage;
        {--------------------------------------}
    FLastRemember: Boolean;
    FLastHScroll,
      FLastVScroll: Integer;
    FUnDoList: Tlist;
    FProxyList: Tlist;
    FGearPool: Tlist;
    FLoadedList: Tlist;

    FUseAutoReAlign: Boolean;
    FShowHints: Boolean;
    FImageDropped: Boolean;
    FShowToolbar: Boolean;
    FignoreMax: Boolean;
    FIgnoreLockSize: Boolean;
    FLockSizeSaved: Boolean;
    FScrollVertical: Boolean;
    FMaximizeImage: Boolean;
    FLockSize: Boolean;
    FScrollable: Boolean;
    FIsSizeAble: Boolean;
    FIsDragAble: Boolean;
    FApplytoall: Boolean;
    FAutoRedraw: Boolean;
    FPanWindow: Boolean;
    FAnnotationsEnabled: Boolean;
    FZoomWindow: Boolean;
        //    FAbsWindow:         Boolean;
    FViewStyle: TMagViewerViewStyle;
    FScrollUp: Boolean;
    FClearBeforeAdd: Boolean;

    FCurUnDoGroup: Integer;
    FRowcount: Integer;
    FRowCountSaved: Integer;
    FColcount: Integer;
    FColCountSaved: Integer;
    FHorizScrollSaved: Integer;
    FColsp: Integer;
    FRowsp: Integer;
    FMaxCount: Integer;
    FLockHeight: Integer;
    FLockWidth: Integer;
    FnextL: Integer;
    FnextT: Integer;
    FbaseW: Integer;
    FbaseH: Integer;
    FcurRow: Integer;
    FcurCol: Integer;
    FFontSize: Integer;

    FCaption: String;
    FviewerDesc: String;

    FPopupMenuImage: TPopupMenu;

        //FOnLogEvent: TMagLogEvent;  {JK 10/5/2009 - Maggmsgu refactoring}
    FMaxAutoLoad: Integer;

        // JMW 7/14/2006 p72
        // description of the study for the Radiology View
    FRadStudyDescription: String;

    FCurrentPatientSSN: String; // the SSN of the current patient
    FCurrentPatientICN: String; // the ICN of the current patient from VistA
    FWindowLevelSettings: TMagViewerWinLevSettings;
        // determines the current method for window/leveling an image

    // determines if Rad Viewer shows pixel values in the hint (only used in Rad Viewer)
    FShowPixelValues: Boolean;

        // determines if the default win/level should be from header/txt file or based on gear component
    FHistogramWindowLevel: Boolean;

    FShowLabels: Boolean;

        // set the current tool applied (hand pan, mouse zoom, annotation, ruler, etc)
    FCurrentTool: TMagImageMouse;

    FAnnotationStyle: TMagAnnotationStyle;

    FMagAnnotationStyleChangeEvent: TMagAnnotationStyleChangeEvent;

    FPatientIDMismatchEvent: TMagViewerPatientIDMismatchEvent;

    FPanWindowClose: TMagPanWindowCloseEvent;

    FMouseZoomShape: TMagMouseZoomShape;

    Procedure DragItOver(Sender, Source: Tobject; x, y: Integer; State:
      TDragState; Var Accept: Boolean);
    Procedure SetMaxCount(Value: Integer);
    Procedure SetLockSize(Value: Boolean);
    Procedure SetZoomWindow(Value: Boolean);

    Procedure SetMaximizeImage(Value: Boolean);
    Procedure DropItOn(Sender, Source: Tobject; x, y: Integer);
    Procedure SelectViewerImage(Sender: Tobject);
    Procedure CalcRowColusingHW;
    Procedure CalcHWusingRowCol;
    Procedure CalcNextLeftTop;
        //59	{		ImageScroll Event handler}
        //59    procedure ImageVScroll(sender : Tobject; vGear: TMag4VGear; hpos,vpos:integer);
    Procedure ImageVClick(Sender: Tobject; VGear: TMag4VGear);
    Procedure ImageVMouseDown(Sender: Tobject; Button: TMouseButton; Shift:
      TShiftState; x, y: Integer);
    Procedure ImageVMouseUp(Sender: Tobject; Button: TMouseButton; Shift:
      TShiftState; x, y: Integer);
    Procedure ImageVKeydown(Sender: Tobject; Var Key, Shift: Smallint);
        //  procedure ImageVKeydown(Sender: TObject; var Key: Word; Shift: TShiftState);
    Procedure AddImageToList(PI: TImageData; Insertat: Integer = -1);
        //    procedure AddImageStudyToList(PI: TImageData; ImageList : TMagImageList; insertat: integer = -1);
    Procedure InitLTHW;
        //    procedure SetAbsWindow(const Value: Boolean);
    Procedure RealignProxy(ImageToDisplayIndex: Integer = -1);
    Procedure SetProxyPosition(i: Integer);
    Procedure LoadProxyImages(Proxyindex: Integer = -1);
    Procedure LoadProxyImage(Index: Integer; CloseSecurity: Boolean =
      False);
    Function FirstVisProxy: Integer;
    Procedure OnProxyClicked(Sender: Tobject);
    Procedure SetRowSpacing(Const Value: Integer);
    Procedure SetColumnSpacing(Const Value: Integer);
    Procedure SetColumnCount(Const Value: Integer);
    Procedure SetRowCount(Const Value: Integer);
    Procedure SetMagImageList(Const Value: TMagImageList);
    Procedure AttachMyself;
    Procedure DeleteProxy(Proxyindex: Integer);
    Procedure SetPanWindow(Value: Boolean);
    Procedure SetViewerStyle(Const Value: TMagViewerStyles);
    Procedure SetMagUtilsDB(Const Value: TMagUtilsDB);
    Function GetImagePage: Integer;
    Function GetImagePageCount: Integer;
    Procedure SetImagePage(Const Value: Integer);
    Procedure SetImagePageUseApplyToAll(Const Value: Integer);
    Procedure SetImagePageCount(Const Value: Integer);
    Procedure SelectAnImage(XProxyindex: Integer);
    Function IsDuplicate(IObj: TImageData): Integer;
    Function Create_P(Proxy: TImageProxy): TMag4VGear;
    Procedure Destroy_p(Proxy: TImageProxy);
    Function GetDescVisible: Boolean;
    Procedure SetDescVisible(Const Value: Boolean);
    Procedure RefreshViewerDesc;
    Procedure PanCloseAll;
    Procedure SetShowToolbar(Const Value: Boolean);
    Function GetImageFontSize: Integer;
    Procedure SetImageFontSize(Const Value: Integer);
    Procedure UpdateToolButtons;
    Procedure UnDoGroupingNew;
    Function GetSelectedCount: Integer;
        //procedure UnDoListAddItem(txt: string; proxy: TImageProxy; undoaction: TMagundoAction);
    Procedure UnDoItemClear(Item: Integer);
    Procedure SetScrollAreaSize(ct: Integer; Vertscroll: Boolean);
    Function IsVisibleProxy(Proxy: TImageProxy): Boolean;
    Procedure AddToLoadedList(Proxy: TImageProxy);
        //59
    Function GetIndexAtDropPoint(x, y: Integer): Integer;
    Function GetVGearFromPool(IObj: TImageData): TMag4VGear;
    Function CreateVGear(IObj: TImageData): TMag4VGear;
        //procedure LogMsg(MsgType: string; Msg: string; Priority: TMagLogPriority = MagLogINFO); {JK 10/5/2009 - MaggMsgu refactoring - remove old method}
        //    procedure setRadiologyView(Value : boolean);
    Procedure SetViewStyle(Value: TMagViewerViewStyle);
    Procedure ApplyStateFromSelectedImage(State: TMagImageState);
    Procedure RIVRecieveUpdate_(action: String; Value: String);
        // recieve updates from everyone
    Procedure CheckStudyCached(FullFileName: String; StudyCount: Integer);
        // checks to see if next,prev,first,last buttons are enabled based on current image selected
    Procedure CheckButtons();

    Procedure ImageZoomScroll(Sender: Tobject; VertScrollPos: Integer;
      HorizScrollPos: Integer);
    Procedure ImageWinLevChange(Sender: Tobject; WindowValue: Integer;
      LevelValue: Integer);
    Procedure ImageBriConChange(Sender: Tobject; BrightnessValue: Integer;
      ContrastValue: Integer);
    Procedure ImageToolChange(Sender: Tobject; Tool: TMagImageMouse);
    Procedure ImageZoomChange(Sender: Tobject; ZoomValue: Integer);
    Procedure ImageUpdateImageState(Sender: Tobject);
    Procedure ExamineSeries(VGear: TMag4VGear);
    Procedure SetAnnotationStyleChangeEvent(Value:
      TMagAnnotationStyleChangeEvent);
    Procedure SetPanWindowClose(Value: TMagPanWindowCloseEvent);
    Procedure PanWindowCloseEvent(Sender: Tobject);
    Procedure RenumberIndexes();
    Function GetZoomValueofImage: Integer;

    Procedure ReorderProxyListIndexes(Proxyindex: Integer);
    Procedure CursorChange(Var oldcurs: TCursor; newcurs: TCursor);
    Procedure CursorRestore(oldcurs: TCursor);
    Function GetCur4Image: TMag4VGear;
    Procedure SetCur4Image(Const Value: TMag4VGear);

  Public
    FAbsWindow: Boolean; // property not used anymore ?
    FLastFit: Integer; // used with other FLast* variables.
    DefaultLayout: TMagLayout;
    StopLoadingImages: Boolean;
    {If FIgnoreBlock is true. then Abstracts will be displayed, even if the Image is Blocked from
      view.  This is used in MagDelete form, to show the abstracts before being deleted.}
    {To override the Block for Full Images.  Then give user the TEMP IGNORE BLOCK security key,
      and take key away when you want to quit overridding blocked images.  This is used in ROI Print Window }
    FIgnoreBlock : boolean;  //94T8
    FRightClickOpen : boolean;    //117 to allow right click in Grp Abs in QA Review

    Constructor Create(AOwner: TComponent); Override;
    Destructor Destroy; Override;

        ////////////////   93  //////////////

    Function GetLastFitDescription: String;
    Procedure RemoveOneFromList(VIobj: TImageData);
    Procedure ZoomIn;
    Procedure ZoomOut;

        ///////////////   93 end //////////////////

        ////////////////  59 start section ////////////////
    Procedure ScrollCornerBL; //Scroll the Image to Corner
    Procedure ScrollCornerBR; //Scroll the Image to Corner
    Procedure ScrollCornerTL; //Scroll the Image to Corner
    Procedure ScrollCornerTR; //Scroll the Image to Corner
    Procedure ScrollDown; //Scroll the Image by small scroll inc.
    Procedure ScrollLeft; //Scroll the Image by small scroll inc.
    Procedure ScrollRight; //Scroll the Image by small scroll inc.
    Procedure ScrollUp; //Scroll the Image by small scroll inc.
    Procedure SetScroll(Hval, Vval: Integer); // Set scroll at coordinates
        {   Next 4 are made for calls from outside the Viewer,
            for now, the two abstracts Windows.}
    Procedure PageNextViewerFocus; //Set focus on Viewer Page
    Procedure PagePrevViewerFocus; //Set focus on Viewer Page
    Procedure SetAbsSmaller; //size the Abstracts
    Procedure SetAbsBigger; // size the Abstracts
        {	Used by menu items, to send message to Viewer to move to next image.}
    Procedure SelectNextImage(Idxinc: Integer = 1); //set focus to an Image
        { 	Possible use for ImageByID.  Shows CrossHatch on viewer to mark
           this viewer for visual indication that is it not same patient}
    Procedure ShowHash;

        /////////////////59  end  Section /////////////////
        { ** UnDo functionality is Not implemented.
                   when it is, it will enable a list (history) of UnDo items, that will
                   redisplay the viewer in previous states. Main function will be
                   to UnDo a removed image or images.}
    Procedure SetRemember(Value: Boolean);
    Function UnDoActionGetText: String;
    Procedure UnDoListClear;
    Procedure UnDoActionExecute;

        {  ** Various Image Count methods  }
                {  opens the Image Viewer Settings window and allows user to choose
                   number of Rows, Columns, Maximum Image to Display and LockImageSize.}
    Procedure EditViewerSettings;
        {  Returns the Actual Number of Images that are visible. Not just Row * Col.
            If rows = 3 and columns = 4 but only 5 images are loaded, this function
            returns 5.}
    Function VisibleCountActual: Integer;
        {  Returns the number of Rows (row) and Columns (col) of the current
            viewer layout.}
    Procedure VisibleRowCol(Var Row, Col: Integer);
        {  Returns the possible visible count.  result := Row * Columns.}
    Function VisibleCount: Integer;
        {  DblClick on Image to Maximize it.  DblClick Again to UnDo Maximize and
            return to the Layout before the image was maximized.}
        // JMW P72 8/2/2006
        // updated to use the image object instead of the image data
    Procedure MaxImageToggle(VGear: TMag4VGear);
        //    procedure MaxImageToggle(Iobj: TImageData);

        { **  TMagLayout contains Row,Col,MaxImage,LockSize properties.}
                {  Default layout is the saved user preference.
                   Future: we can have multiple saved user layouts and
                   some distributed layouts for the user to select from.}
    Procedure ApplyDefaultLayout;
        {  returns a Text string that describes the Layout.}
    Function GetDefaultLayoutDesc: String;
        {  When applying user preferences, this call populates default TMagLayout object}
    Procedure SetDefaultLayout(Rows, Cols, MaxImages: Integer; LockSize: Boolean; FitMeth: Integer = 0);

        { ** Methods to return lists, single Images}
                {  Returns the list of TImageData Objects of all images in Viewer}
    Function GetImageObjectList: Tlist;
        {  Returns just a list of TImageData Objects of all Selected Images}
    Function GetSelectedImageList: Tlist;
        { count of images in viewer. All, proxies and loaded images.}
    Function GetImageCount: Integer;
        { returns the TGear Wrapper of the currently selected image.}
    Function GetCurrentImage: TMag4VGear;
        { returns the TImageData object of the currently selected image}
    Function GetCurrentImageObject: TImageData;

        { ** DataBase calls, passed through to TMagUtilsDB object.  TMagUtilsDB
                   has a connection to the DataBase.  The Viewer does not. }
                { Print and Copy will first force user to select reason and enter Electronic
                  signature before action can be performed.}
    Procedure ImagePrint;
    Procedure ImageCopy;
        { Display the report associated with the Image }
    Procedure ImageReport;

        { ** Methods that deal with the Scrolling of Images }
                { scroll to specific Image referenced from ProxyList index }
    Procedure ScrollToImage(ImageIndex: Integer); Overload;
        { scroll to specific Image referenced by the TImageData object of the Image }
    Procedure ScrollToImage(IObj: TImageData); Overload;
        { scroll to Image (calls ScrollToImage) and Load Image if it is proxy, and
          set as Selected Image}
    Procedure ScrollAndDisplayImage(Proxyindex: Integer);
        { returns TRUE if Scrollbar is at the End of Scroll Range.
          (used to enable/disable Viewer Paging buttons)   }
    Function ViewerScrollAtEnd: Boolean;
        { returns TRUE if Scrollbar is at the Begginning of Scroll Range.}
    Function ViewerScrollAtStart: Boolean;
        { scroll to Begginning of Scroll range}
    Procedure PageFirstViewer(SetSelected: Boolean = True);
        { scroll to End of Scroll range}
    Procedure PagePrevViewer(SetSelected: Boolean = True);
        { scroll to Next Page in Scroll range}
    Procedure PageNextViewer(SetSelected: Boolean = True);
        { scroll to Previous Page in Scroll range}
    Procedure PageLastViewer(SetSelected: Boolean = True);

        { ** Various calls to move, realign, show certain images }
                { resize all visible images to fit in Viewer }
    Procedure TileAll;
        { resize and align images to fit r: rows and c: columns in the viewer}
    Procedure SetRowColCount(r, c: Integer; ImageToDisplayIndex: Integer =
      -1);
        { remove selected images from list.  Also hides the image. does not
          realign the remaining images.}
    Procedure RemoveFromList;
        { called from many methods.  resizes and aligns the image to fit current rows
          and current columns of images in the viewer.  This function is called.
          When window is resized  }
    Procedure ReAlignImages(Ignmax: Boolean = False; Ignlocksize: Boolean =
      false; ImageToDisplayIndex: integer = -1);

        { force a resize of all images to h: height and w: width then ReAlign the
          Images.  This is called when abstracts are resized }
    Procedure ReSizeAndAlign(h, w: Integer);
        { Not implemented.  This will change the 'Selected' state of all Images.}
    Procedure ToggleSelected;
        { Remove all images from viewer.  There's no UnDoing this until
          undo functions are implemented.}
    Procedure ClearViewer;

        {  enable/disable the showing of Hints in the Viewer}
    Procedure ShowHints(Value: Boolean);
        {  The TStrings parameter is a list of images (full path to image)
           the items in the list are displayed in the Viewer.  }
    Procedure ViewDirectoryImages(t: TStrings);
        { Main call to view an Image/List of Images in the Viewer
          ObjList: is a list of TImageData objects.
          allowdup : if user wants to display the same image twice. }
    Procedure ImagesToMagView(ObjList: Tlist; AllowDUP: Boolean = False;  ImageToDisplayIndex: Integer = -1);

        //    procedure StudyToMagView(image : TImageData; StudyList : TStrings; allowdup : boolean = false);

                {  not implemented }
    Procedure SetViewerDesc(Desc: String; Descvis: Boolean);
        {  synchronize with selected images in other
           viewers, magListViews, MagTreeViews. }
    Procedure SyncWithIMage(IObj: TImageData; synconGroup: Boolean = True);

        { **  This in the Implementation of the IMagObserver interface.
                  The Viewer attaches to an ImagSubject object (in our case it
                  is a TMagImageList object).  When the ImagSubject object changes, it
                  notifies it's ImagObservers by calling their UpDate_ method.
                  ImagObservers then update them selves.
                  An example is the Tmag4Viewer in the Abstract window.  It updates itself
                  when user selects a new filtered list of images.}
    Procedure UpDate_(SubjectState: String; Sender: Tobject);

        { ** The following methods are operations on the Image, the Viewer simply
                  passes them through to the Image Object.
                  (In the Future: These methods will be methods of the ImagImage interface) }

    Procedure FitToWindow;
    Procedure Fit1to1;
    Procedure FitToWidth;
    Procedure FitToHeight;
    Procedure FlipVert;
    Procedure FlipHoriz;
        {  deg : the degree to rotate the image from its current view.
                 90, 180, 270}
    Procedure Rotate(Deg: Integer);
        {  Undo all rotate, brightness, zoom.  Fit the Image in Window.}
    Procedure ResetImages(ApplyToAll: Boolean = False);
    Procedure Inverse;
        {  DeSkew : to straighten.  Smooth: uses Accusoft scale to gray algorithm
           that makes the image easier to read.}
    Procedure DeSkewAndSmooth;
        {  performs a ReLoad of all images.}
    Procedure ReFreshImages();
        {  mouse will act as magnifier }
    Procedure MouseMagnify;
        {  mouse pointer }
    Procedure MouseReSet;
        {  mouse will pan the image }
    Procedure MousePan;
        {  mouse will select area.  That area will be zoomed to (as close as possible) }
    Procedure MouseZoomRect;
        {  change the zoom value of selected images.}
    Procedure ZoomValue(Value: Integer);
    Procedure ContrastValue(Value: Integer);
    Procedure BrightnessValue(Value: Integer);
        { Allow setting brightness and contrast together without doing a refresh between}
    Procedure BrightnessContrastValue(Bright, Contrast: Integer);
    Procedure WinLevValue(WinValue, LevelValue: Integer);
        {  for Multipage images }
        {  Future : These 'paging' methods will also work for Image Groups.}
    Procedure PageFirstImage;
    Procedure PageLastImage;
    Procedure PageNextImage;
    Procedure PagePrevImage;

    Procedure AutoWinLevel;

    Procedure OnImageMouseScrollDown(Sender: Tobject; Shift: TShiftState;
      MousePos: TPoint; Var Handled:
      Boolean);
    Procedure OnImageMouseScrollUp(Sender: Tobject; Shift: TShiftState;
      MousePos: TPoint; Var Handled: Boolean);
    Procedure OnImageDoubleClickEvent(Sender: Tobject);

    Procedure UnSelectAll;

    Procedure ViewFullResImage();

    Function IsStudyAlreadyLoaded(FirstImageIEN: String; Server: String;
      Port: Integer; StudyImgCount: Integer):
      Boolean;
    Procedure ShowImage(ImageIndex: Integer);

        // from iMagViewer
    Procedure SetApplyToAll(Value: Boolean);
    Function GetApplyToAll(): Boolean;
    Function GetPanWindow(): Boolean;
    Function GetMaximizeImage(): Boolean;
    Function GetViewerStyle(): TMagViewerStyles;
    Function GetLockSize(): Boolean;
    Function GetClearBeforeAdd(): Boolean;
    Procedure SetClearBeforeAdd(Value: Boolean);
    Function GetMaxCount(): Integer;
    Function GetAnnotationsEnabled(): Boolean;
    Function GetCurrentImageIndex(): Integer;

    Procedure ApplyImageState(State: TMagImageState; ApplyAll: Boolean =
      False);
    Procedure DisplayDICOMHeader();
    Procedure StopScrolling();
    Procedure SetShowPixelValues(Value: Boolean);
    Function GetShowPixelValues(): Boolean;

    Function GetHistogramWindowLevel(): Boolean;
    Procedure SetHistogramWindowLevel(Value: Boolean);

    Function GetShowLabels(): Boolean;
    Procedure SetShowLabels(Value: Boolean);

    Function GetCurrentTool(): TMagImageMouse;
    Procedure SetCurrentTool(Value: TMagImageMouse);

    Procedure Annotations();
    Procedure Measurements();
    Procedure Protractor();
    Procedure AnnotationPointer();
    Procedure ApplyViewerState(Viewer: IMag4Viewer); //jw 11/16/07
    Procedure SetAnnotationStyle(AnnotationStyle: TMagAnnotationStyle);
    Procedure SetPanWindowWithActivateOption(Value: Boolean; Activate:
      Boolean);

        // JMW 4/6/09 P93 - add options for changing mouse zoom shape
    Procedure SetMouseZoomShape(Value: TMagMouseZoomShape);
    Function getMouseZoomShape(): TMagMouseZoomShape;

    Property OnChangeCur4Image: TNotifyEvent Read FOnChangeCur4Image Write FOnChangeCur4Image;
    Property Cur4Image: TMag4VGear Read GetCur4Image Write SetCur4Image;


{/gek p117  added for the display of image status on the Abstracts}
    function GetShowImageStatus: boolean;           //117
    procedure SetShowImageStatus(value: boolean);   //117

  Published
    Property AbsWindow: Boolean Read FAbsWindow Write FAbsWindow;
        {  Display Styly, ViewerStyle are not implemented. }
    Property DisplayStyle: TMagDisplayStyles Read FDisplayStyle Write   FDisplayStyle;
    Property ViewerStyle: TMagViewerStyles Read FViewerStyle Write   SetViewerStyle;
        {  Events to attach callbacks.}
    Property OnViewerImageClick: TMagVClick Read FTMagVClick Write   FTMagVClick;
    Property OnViewerClick: TMagViewerClickEvent Read FViewerClickEvent Write   FViewerClickEvent;
        { anytime an image is added, or removed from the viewer }
    Property OnListChange: TMagVListChange Read FTMagVlistchange Write FTMagVlistchange;
        {  Popup menu when Right Click on the Image.}
    Property PopupMenuImage: TPopupMenu Read FPopupMenuImage Write  FPopupMenuImage;
        {  Imaging Components needed for total VistA Imaging Display functionality}
        {        Viewer will work without MagSecurity or MagUtilsDB but functionality
                  will be limited }
    Property MagSecurity: TMag4Security Read FMagSecurity Write FMagSecurity;
    Property MagImageList: TMagImageList Read FMagImageList Write SetMagImageList;
    Property MagUtilsDB: TMagUtilsDB Read FMagUtilsDB Write SetMagUtilsDB;
        {  If this is an Abstract window.  Some functions operate differently, and
              The Tmag4VGear objects also display text, captions differently.
              Some functions are not available for Abstracts.}
    //    property AbsWindow: Boolean read FAbsWindow write SetAbsWindow;
    Property ViewStyle: TMagViewerViewStyle Read FViewStyle Write   SetViewStyle;
    Property UseAutoReAlign: Boolean Read FUseAutoReAlign Write  FUseAutoReAlign;
        {  Not Implemented.}
    Property caption: String Read FCaption Write FCaption;
        {  Font size for TMag4VGear object.  Caption under/over the Image}
    Property ImageFontSize: Integer Read GetImageFontSize Write  SetImageFontSize;
        {  Show/Hide the Viewer Toolbar (Mainly for abstracts) }
    Property ShowToolbar: Boolean Read FShowToolbar Write SetShowToolbar;
        {  Abstracts have LockSize = true. When window is enlarged, abstracts stay
           same size and we see more of them.}
    Property LockSize: Boolean Read FLockSize Write SetLockSize;
        {   Open a Zoom Window for the Current Image }
    Property ZoomWindow: Boolean Read FZoomWindow Write SetZoomWindow;
        {   Open a Pan Window for the Current Image }
    Property PanWindow: Boolean Read FPanWindow Write SetPanWindow;
        {  not Implemented.  This is part of Future ViewerStyle functions.}
    Property Scrollable: Boolean Read FScrollable Write FScrollable;
        {  Direction of the ScrollBar.  (Viewer has only one.) }
    Property ScrollVertical: Boolean Read FScrollVertical Write
      FScrollVertical;
        {  Future : Prototype Drag and Drop }
    Property IsDragAble: Boolean Read FIsDragAble Write FIsDragAble;
        {  Future : Allow resizing images. (used sparingly in ReSizeAbstracts Function}
    Property IsSizeAble: Boolean Read FIsSizeAble Write FIsSizeAble;
        { operations on Images. will be applied to all loaded images }
    Property ApplyToAll: Boolean Read FApplytoall Write SetApplyToAll;
        {  Not Implemented:  -- actually it is set to true, not changeable }
    Property AutoRedraw: Boolean Read FAutoRedraw Write FAutoRedraw;
        {  To Add images to the viewer, this needs to be False.
           If true, the Viewer is cleared before any Drop, or AddImage function call}
    Property ClearBeforeAddDrop: Boolean Read FClearBeforeAdd Write
      SetClearBeforeAdd;
        {  RowCount,RowSpacing,ColumnCount,ColumnSpacing will set the Properties, but
           will not automatically force a ReAlignImages.}
    Property RowCount: Integer Read FRowcount Write SetRowCount;
    Property RowSpacing: Integer Read FRowsp Write SetRowSpacing;
    Property ColumnSpacing: Integer Read FColsp Write SetColumnSpacing;
    Property ColumnCount: Integer Read FColcount Write SetColumnCount;
        {  The current image (Selected Image) will be maximized.}
    Property MaximizeImage: Boolean Read FMaximizeImage Write  SetMaximizeImage;
        { reset the maximum number of Image to load into viewer. Does not do ReAlign }
    Property MaxCount: Integer Read FMaxCount Write SetMaxCount;
        {  LockWidth and LockHeight are used if FLockSize = TRUE.  Images are not
           resized, but the number of visible image changes when window is resized.}
    Property LockWidth: Integer Read FLockWidth Write FLockWidth;
    Property LockHeight: Integer Read FLockHeight Write FLockHeight;
        //   property Items: TStrings read FItems write SetItems;
           {  Not Implemented.}
    Property ShowDescription: Boolean Read GetDescVisible Write  SetDescVisible;
        {  ImagePageCount is a ReadOnly property.  i.e. SetImagePageCount does nothing}
    Property ImagePageCount: Integer Read GetImagePageCount Write SetImagePageCount;
        {  Get/Set the current page to view}
    Property ImagePage: Integer Read GetImagePage Write SetImagePage;
        //   procedure ApplyCurrentToAll;  {TODO: Implement ApplyCurrentToAll}

        //property OnLogEvent: TMagLogEvent read FOnLogEvent write FOnLogEvent; {JK 10/5/2009 - Maggmsgu refactoring}

    Property MaxAutoLoad: Integer Read FMaxAutoLoad Write FMaxAutoLoad;
    Property CurrentPatientSSN: String Read FCurrentPatientSSN Write FCurrentPatientSSN;
    Property CurrentPatientICN: String Read FCurrentPatientICN Write FCurrentPatientICN;
    Property WindowLevelSettings: TMagViewerWinLevSettings Read  FWindowLevelSettings Write FWindowLevelSettings;

    Property OnPageNextViewerClick: TMagPageNextViewerEvent Read FPageNextViewerEvent Write FPageNextViewerEvent;
    Property OnPagePreviousViewerClick: TMagPagePreviousViewerEvent Read FPagePreviousViewerEvent Write FPagePreviousViewerEvent;
    Property OnPageFirstViewerClick: TMagPageFirstViewerEvent Read  FPageFirstViewerEvent Write FPageFirstViewerEvent;
    Property OnPageLastViewerClick: TMagPageLastViewerEvent Read FPageLastViewerEvent Write FPageLastViewerEvent;

    Property OnImageDoubleClick: TMagImageDoubleClickEvent Read FImageDoubleClickEvent Write FImageDoubleClickEvent;
    Property OnMagAnnotationStyleChangeEvent: TMagAnnotationStyleChangeEvent Read FMagAnnotationStyleChangeEvent  Write SetAnnotationStyleChangeEvent;

    Property OnPatientIDMismatchEvent: TMagViewerPatientIDMismatchEvent Read FPatientIDMismatchEvent Write FPatientIDMismatchEvent;

        //    property RadiologyView : boolean read FRadiologyView write setRadiologyView;
    Property OnPanWindowClose: TMagPanWindowCloseEvent Read FPanWindowClose  Write FPanWindowClose;

  End;
Const
  MaximumUnDoActions: Integer = 5;

    (*NOTES. the old way, we knew we had an Accusoft TGear Control, and called its methods
       directly. We don't want to procede that way, and be tied to an Accusoft Control.
       So for now we'll call the methods of a TMag4VGear object, (a wrapper around
       a TGear control)
            (Later convert to an InterfacedObject ( yet to be defined) *)

Procedure Register;

Implementation

Uses
  cMagImageAccessLogManager,
  cMagImageUtility,
  cMagListView,
  Dialogs,
  Geardef,
  MagImageManager,
  MagRowColSize,
  FMag4VGear14,
  SysUtils
  ;

{$R *.DFM}

{ TMag4Viewer }

Constructor TMag4Viewer.Create(AOwner: TComponent);
Begin
  Inherited;
  Name := ''; //name := '' is a workaround for Delphi bug with Frames.
  FShowImageStatus := false;     //117
  FLastRemember := False;
  FLastFit := IG_DISPLAY_FIT_TO_WIDTH;
  FLastHScroll := 0;
  FLastVScroll := 0;
  FIgnoreBlock := false;  //p94t8  FIgnoreBlock missed in 106, putting it in 117 gek
  FRightClickOpen := false;               //117
  FFontSize := 8;
  StopLoadingImages := False;
  DefaultLayout := TMagLayout.Create;
  FProxyList := Tlist.Create;
  FGearPool := Tlist.Create;
  FLoadedList := Tlist.Create;
  FUtils := TMagVUtils.Create(Nil);
  FUnDoList := Tlist.Create;
  Scrlv.Align := alClient;
  LbScrlvSize.caption := '';
  Scrlv.HorzScrollBar.Tracking := True;
  Scrlv.VertScrollBar.Tracking := True;
  Height := 100;
  Width := 85;
  OnDragOver := DragItOver;
  OnDragDrop := DropItOn;
  FUseAutoReAlign := True;
  If FViewStyle = MagViewerViewAbs Then
    FLockSize := True;
    //out to stop error vcl70.bpl      self.FLoadingMsgWin := TfrmLoadingImageMessage.create(self);

    (*  //out to stop error vcl70.bpl
      if FViewStyle = MagViewerViewAbs then
          begin
          self.FLoadingMsgWin.SetDelay(2000);     // 1000
          self.FLoadingMsgWin.lbImageResolution.Caption := 'Loading a page of Abstracts...';
          end
          else
          begin
          self.FLoadingMsgWin.SetDelay(4000);   //3000
          self.FLoadingMsgWin.lbImageResolution.Caption := 'Loading a page of Images...';
          end;
    *)
  FMaxAutoLoad := -1;
  FRadStudyDescription := '';
  PnlTop.caption := '';
  LbPnlTop.caption := PnlTop.caption;
  FWindowLevelSettings := MagWinLevImageSettings;
    //  FRadiologyView := false;
  cboSeries.Align := alLeft;
  cboSeries.Visible := False;
  ImgStudyStatus.Visible := False;
  CheckButtons();
  FShowPixelValues := False;
  FHistogramWindowLevel := True;
  FShowLabels := True;
  FCurrentTool := MactPan;
  FMouseZoomShape := MagMouseZoomShapeRectangle;
End;

Destructor TMag4Viewer.Destroy;
Begin
    //  if application.Terminated then exit;
    // free memory of stuff we created.
    //  if application.Terminated then exit;
  While (FProxyList.Count > 0) Do
    DeleteProxy(0);
  FProxyList.Free;
  FGearPool.Free;
  FLoadedList.Free;
  FUtils.Free;
  FUnDoList.Free;
  If Assigned(FMagImageList) Then
  Begin
    FMagImageList.Detach_(IMagObserver(Self));
    FMagImageList := Nil;
  End;
  FreeAndNil(DefaultLayout);
  Inherited;

End;

{JK 10/5/2009 - MaggMsgu refactoring - remove old method}
//procedure TMag4Viewer.LogMsg(MsgType: string; Msg: string; Priority:
//    TMagLogPriority = MagLogINFO);
//begin
//    if assigned(OnLogEvent) then
//        OnLogEvent(self, MsgType, Msg, Priority);
//end;

Procedure Register;
Begin
  RegisterComponents('Imaging', [TMag4Viewer]);
End;

Procedure TMag4Viewer.ScrlVClick(Sender: Tobject);
Begin
  If Assigned(Onclick) Then
    Self.Onclick(Sender);
  If Assigned(OnViewerClick) Then
    Self.OnViewerClick(Self, Self, Cur4Image);
End;

Procedure TMag4Viewer.PnlTopStartDrag(Sender: Tobject;
  Var DragObject: TDragObject);
Begin
    //self.BeginDrag(true,3);
End;

Procedure TMag4Viewer.PnlTopStartDock(Sender: Tobject;
  Var DragObject: TDragDockObject);
Begin
    //self.BeginDrag(true,3);
End;

Procedure TMag4Viewer.PnlTopClick(Sender: Tobject);
Begin
    //
End;

Procedure TMag4Viewer.PnlTopEndDrag(Sender, Target: Tobject; x,
  y: Integer);
Begin
    (*  tr.Left := 100;
      tr.Top := 100;
      tr.Right := 300;
      tr.Bottom := 300;
      self.ManualFloat(tr);*)
End;

Procedure TMag4Viewer.PnlTopMouseMove(Sender: Tobject; Shift: TShiftState;
  x, y: Integer);
Begin
    //if (ssleft IN shift) then self.begindrag(false,5);
End;

Procedure TMag4Viewer.PnlTopMouseDown(Sender: Tobject;
  Button: TMouseButton; Shift: TShiftState; x, y: Integer);
Begin
    //  self.begindrag(false, 10);
End;

Procedure TMag4Viewer.DragItOver(Sender, Source: Tobject; x, y: Integer;
  State: TDragState; Var Accept: Boolean);
Begin
    { TODO -cDragDrop: Add test to see if this viewer is allowing Droping }
  Accept := True;
End;

Procedure TMag4Viewer.DropItOn(Sender, Source: Tobject; x, y: Integer);
Var
  i: Integer;
  PI: TImageData;
  TN, TNC: TTreeNode;
  TLI: TListItem;
  Listct: Integer;
Begin

  If FClearBeforeAdd Then
    ClearViewer;
  Listct := FProxyList.Count;
    (* //new
    if (source is   Tfilelistbox) then
       begin
      {  with (source as tfilelistbox) do
       begin
       if selcount > 1 then
          begin
          for I := 0 to items.count -1 do
              if selected[i] then
                             begin
                             xlist.add(items[i]);
                             LoadoneImage(xlist.Strings[xlist.count-1]);
                             end;
          end
          else
          begin
          xlist.add(items[itemindex]);
          LoadoneImage(xlist.Strings[xlist.count-1]);
          end;

      end;
      }
      {xlist.assign((source as tfilelistbox).items);}
     {  for i := 0 to xlist.count-1  do {(source as Tfilelistbox).items.count-1 do}
           begin
           LoadoneImage(xlist[i]); {(source as Tfilelistbox).items[i]);}
           end;
         }{ this is out, for drag drop }
       end;
    //end new *)

  If (Source Is TTreeView) Then
  Begin
    TN := (Source As TTreeView).Selected;
    If TN.HasChildren Then
      For i := 0 To TN.Count - 1 Do
      Begin
        TNC := TN.Item[i];
        PI := TNC.Data;
        AddImageToList(PI);
      End
    Else
    Begin
      PI := TN.Data;
      AddImageToList(PI);
    End;
  End; {if (source is TTreeView) then}
    {-----}
    { for below, we need a way to get PI without having to USE a form.}
  If (Source Is TMag4VGear) Then
  Begin
    PI := (Source As TMag4VGear).PI_ptrData;
    AddImageToList(PI);
  End;
    {---------}
  If (Source Is TListView) Then
  Begin
    If TListView(Source).Selcount > 1 Then
    Begin
      For i := 0 To TListView(Source).Items.Count - 1 Do
        If TListView(Source).Items[i].Selected Then
        Begin
          TLI := TMagListView(Source).Items[i];
          PI := TMagListViewData(TLI.Data).IObj;
          AddImageToList(PI);
        End;
    End
    Else
    Begin
      TLI := TMagListView(Source).Selected;
      PI := TMagListViewData(TLI.Data).IObj;
      AddImageToList(PI);
    End;
  End; { if source is TListView }
  ReAlignImages;
  If Listct < FProxyList.Count Then
  Begin
    ScrollToImage(Listct);
    ReAlignImages;
  End;
End; {DropItOn}

Procedure TMag4Viewer.SetProxyPosition(i: Integer);
Var
  Iproxy: TImageProxy;
Begin
  Iproxy := FProxyList[i];
  Iproxy.Loadindex := i;
  If FbaseH = 0 Then
    CalcHWusingRowCol;
  If Not FScrollVertical Then
    Iproxy.SetBounds(FnextL - Scrlv.HorzScrollBar.Position, FnextT, FbaseW,
      FbaseH)
  Else
    Iproxy.SetBounds(FnextL, FnextT - Scrlv.VertScrollBar.Position, FbaseW,
      FbaseH);
  If Iproxy.Image <> Nil Then
  Begin
    Iproxy.Image.SetBounds(Iproxy.Left, Iproxy.Top, Iproxy.Width,
      Iproxy.Height);
    If Iproxy.Visible Then
      Iproxy.Visible := False;
    Iproxy.Image.ReDrawImage;
    Iproxy.Image.Update;
    If Iproxy.Image.ListIndex <> Iproxy.Loadindex Then
    Begin
      Iproxy.Image.ListIndex := Iproxy.Loadindex;
      If FViewStyle = MagViewerViewRadiology Then
        Iproxy.Image.ImageDescription := '#' +
          Inttostr(Iproxy.Image.ListIndex + 1) + ' ' +
          Iproxy.ImageData.ExpandedDescription(False);
    End;
  End
  Else
    If Not Iproxy.Visible Then
      Iproxy.Visible := True;
  CalcNextLeftTop;
  Update;
End;
(*
procedure TMag4Viewer.StudyToMagView(image : TImageData; StudyList : TStrings; allowdup : boolean = false);
var
  xFirstProxyIndex: integer;
  Iobj: TImageData;
  i,  dupindex: integer;
  undotext: string;
  imgList : TMagImageList;
begin
  undotext := 'UnDo - Add Image';
  UnDoGroupingNew;
  try
    {  Add or Clear first, depending on setting. {}
    dupindex := -1;
    if FClearBeforeAdd then clearViewer;
        dupindex := IsDuplicate(image);
        if dupindex > -1 then
          begin
            {  If image is already displayed, scroll to it.  Quit if not add duplicate}
            ScrollAndDisplayImage(dupindex);
            if not allowdup then exit;
          end;
     {  first added image will have index of xFirstProxyIndex.}
    xFirstProxyIndex := FProxyList.Count;

{TODO:  HERE TRY TO speed up the display of large lists, by loading and displaying
                                        some, then the others. }

        Iobj := image;
        //iobj.StudyList := StudyList;
        imgList := TmagImageList.Create(self);
        imgList.LoadGroupList(StudyList, '','');
        AddImageStudyToList(IObj, imgList, dupIndex);
        //AddImageToList(Iobj, dupindex);    // adds to proxy list
    {   here we need a description of images in the viewer. Images have been
         added to list, display first FMaxcount of newly added Images.}
    if assigned(OnListChange) then OnListChange(self);
    ReAlignImages;   // calls RealignProxy
                        //   RealingProxy has:
                        //   for... loop for all proxies - calling SetProxyPosition
                        //   calls loadProxyImages
                                //  LoadProxyImages has :
                                //  for...Loop for all proxies - calling LoadProxyImage.
    ScrollAndDisplayImage(xFirstProxyIndex);
    application.processmessages;
    RefreshViewerDesc;
  finally
    FImageDropped := false;
  end;

end;
*)

Procedure TMag4Viewer.ImagesToMagView(ObjList: Tlist; AllowDUP: Boolean = False; ImageToDisplayIndex: Integer = -1);
Var
  XFirstProxyIndex: Integer;
  IObj: TImageData;
  i, Dupindex: Integer;
  Undotext: String;
  PrevSeriesObj, SeriesObj: TMagSeriesObject;
  PrevSeries: String;
  SeriesImgCount: Integer;
Begin
    //brk Load 1
  If ObjList.Count = 0 Then
    Exit;
  ImgStudyStatus.Visible := False;
  cboSeries.Clear();
  cboSeries.Hint := '';
  cboSeries.Visible := False;
  PrevSeries := '';
  SeriesImgCount := 0;
  cboSeries.AddItem('Series', Nil);
  If ObjList.Count > 1 Then
    Undotext := 'UnDo - Add Image(s)'
  Else
    Undotext := 'UnDo - Add Image';
  UnDoGroupingNew;
  Try
        {  Add or Clear first, depending on setting. {}
    Dupindex := -1;
    If FClearBeforeAdd Then
      ClearViewer;
    If ObjList.Count = 1 Then
    Begin
      Dupindex := IsDuplicate(ObjList[0]);
      If Dupindex > -1 Then
      Begin
                {  If image is already displayed, scroll to it.  Quit if not add duplicate}
                // JMW 11/30/06 P72 - If allowing dup then we don't want to scroll
                // to the image and then load another instance of the image
                // only scroll to image if not allowing dup
        If Not AllowDUP Then
        Begin
          ScrollAndDisplayImage(Dupindex);
          Exit;
        End;
                //            if not allowdup then exit;
      End;
    End;
        {  first added image will have index of xFirstProxyIndex.}
    XFirstProxyIndex := FProxyList.Count;

        {TODO -cLargeLists:  HERE TRY TO speed up the display of large lists, by loading and displaying
                                                some, then the others. }
    For i := 0 To ObjList.Count - 1 Do
    Begin
      IObj := ObjList[i];
            // if in Rad Viewer mode and allowing duplicate, then put the new (duplicate) image at the end, not with its other dup images
      If (FViewStyle = MagViewerViewRadiology) And (AllowdUp) Then
        Dupindex := -1;
            //Brk Load 2
      AddImageToList(IObj, Dupindex); // adds to proxy list

      If (PrevSeries <> IObj.DicomSequenceNumber) And (FViewStyle =
        MagViewerViewRadiology) Then
      Begin
        If PrevSeries <> '' Then
        Begin
          PrevSeriesObj :=
            (cboSeries.Items.Objects[cboSeries.Items.Count - 1] As
            TMagSeriesObject);
          PrevSeriesObj.SeriesImgCount := SeriesImgCount;
          cboSeries.Items[cboSeries.Items.Count - 1] :=
            PrevSeriesObj.SeriesName + '(' + Inttostr(SeriesImgCount)
            + ')';
          SeriesImgCount := 0;
        End;
        SeriesObj := TMagSeriesObject.Create();
        SeriesObj.SeriesName := IObj.DicomSequenceNumber;
        SeriesObj.ImageIndex := i;
        cboSeries.AddItem(SeriesObj.SeriesName, SeriesObj);
        PrevSeries := IObj.DicomSequenceNumber;
      End;
      SeriesImgCount := SeriesImgCount + 1;
    End;
    If cboSeries.Items.Count > 1 Then
    Begin
      PrevSeriesObj := (cboSeries.Items.Objects[cboSeries.Items.Count - 1]
        As TMagSeriesObject);
      PrevSeriesObj.SeriesImgCount := SeriesImgCount;
      cboSeries.Items[cboSeries.Items.Count - 1] :=
        PrevSeriesObj.SeriesName + '(' + Inttostr(SeriesImgCount) +
        ')';
    End; {looping through all images and adding to Proxy List.}
        {   here we need a description of images in the viewer. Images have been
             added to list, display first FMaxcount of newly added Images.}
    If Assigned(OnListChange) Then
      OnListChange(Self);
        //brk Load 3
    ReAlignImages(False, False, ImageToDisplayIndex); // calls RealignProxy
        //   RealingProxy has:
        //   for... loop for all proxies - calling SetProxyPosition
        //   calls loadProxyImages
                //  LoadProxyImages has :
                //  for...Loop for all proxies - calling LoadProxyImage.
    If ImageToDisplayIndex > -1 Then
      ScrollAndDisplayImage(ImageToDisplayIndex)
    Else
      ScrollAndDisplayImage(XFirstProxyIndex);
    Application.Processmessages;

    IObj := ObjList[0];
    CheckStudyCached(IObj.FFile, ObjList.Count);

    cboSeries.ItemIndex := 0;
    If cboSeries.Items.Count > 1 Then
      cboSeries.Visible := True
    Else
      cboSeries.Visible := False;

    RefreshViewerDesc;
  Finally
    FImageDropped := False;
    CheckButtons();
  End;
End;

Procedure TMag4Viewer.CheckStudyCached(FullFileName: String; StudyCount:
  Integer);
Begin
  If MagImageManager1.IsStudyCached(FullFileName, StudyCount) Then
  Begin
    ImlViewerBmps.GetIcon(22, ImgStudyStatus.Picture.Icon);
    ImgStudyStatus.Visible := True;
  End
  Else
  Begin
    ImgStudyStatus.Visible := False;
  End;
End;

Procedure TMag4Viewer.RefreshViewerDesc;
Var
  ct: Integer;
Begin
  ct := FProxyList.Count;
  Case FViewStyle Of
    MagViewerViewAbs:
      Begin
        If ct = 1 Then
          FviewerDesc := ' Abstract.'
        Else
          FviewerDesc := ' Abstracts.';
      End;
  Else
    Begin
      If ct = 1 Then
        FviewerDesc := ' Image.'
      Else
        FviewerDesc := ' Images.';

    End;
  End;

  If FRadStudyDescription <> '' Then
  Begin
    PnlTop.caption := FRadStudyDescription + '  - ' +
      Inttostr(FProxyList.Count) + '  Images';
    LbPnlTop.caption := PnlTop.caption;
  End
  Else
  Begin
    PnlTop.caption := ' ' + Inttostr(FProxyList.Count) + FviewerDesc;
    LbPnlTop.caption := PnlTop.caption;
  End;
    //out 93 pnltop.Caption := 'Displaying: ' + inttostr(VisibleCountActual) + ' of ' + inttostr(Fproxylist.Count) + FViewerDesc;
  If Assigned(OnListChange) Then
    OnListChange(Self);
End;

Function TMag4Viewer.IsDuplicate(IObj: TImageData): Integer;
Var
  i: Integer;
Begin
    { loop to find if this Iobj is already in the FProxyList{}
  Result := -1;
  For i := 0 To FProxyList.Count - 1 Do
  Begin
    If (TImageProxy(FProxyList[i]).ImageData.Mag0 = IObj.Mag0) Then
    Begin
      Result := i;
      Break;
    End;
  End;
End;

Procedure TMag4Viewer.ScrollAndDisplayImage(Proxyindex: Integer);
Begin
    //LogMsg('s', 'ScrollAndDisplayImage proxyindex=[' + inttostr(proxyindex) +
    //    ']');
  MagLogger.LogMsg('s', 'ScrollAndDisplayImage proxyindex=[' + Inttostr(Proxyindex) +
    ']'); {JK 10/5/2009 - MaggMsgu refactoring}
    // JMW 7/14/2006 p72 removed first ScrollToImage
    // doesn't seem needed and was causing image flashing
    // now load image and then scroll to it (eliminates flashing)

    // need to keep scrolltoImage here because if it is gone, won't load last image in large groups (>100)
    // don't know why...

  ScrollToImage(Proxyindex); // needthis?  we scroll below.
    // JMW p72 7/17/2006
    // check to see if image is nil or image not loaded yet
  If (TImageProxy(FProxyList[Proxyindex]).Image = Nil) Or (Not
    TImageProxy(FProxyList[Proxyindex]).Image.ImageLoaded) Then
    LoadProxyImage(Proxyindex, True);
  SelectAnImage(Proxyindex);
  Update;
  Application.Processmessages;
  ScrollToImage(Proxyindex);
End;

Procedure TMag4Viewer.SelectAnImage(XProxyindex: Integer);
Var
  XProxy: TImageProxy;
Begin
  If XProxyindex > FProxyList.Count - 1 Then
    Exit; //59
  If XProxyindex < 0 Then
    Exit; //59
  UnSelectAll;
  XProxy := TImageProxy(FProxyList[XProxyindex]);
  If Assigned(XProxy.Image) Then
  Begin
    XProxy.Image.Selected := True;
    Cur4Image := XProxy.Image;
    If (FViewStyle <> MagViewerViewAbs) Then
            //      if (not abswindow) then
    Begin
      If Assigned(OnViewerClick) Then
        OnViewerClick(Self, Self, Cur4Image);
      If Assigned(OnViewerImageClick) Then
        OnViewerImageClick(Cur4Image);
    End;
  End;
  UpdateToolButtons;
  CheckButtons();
  If Assigned(XProxy.Image) Then
    ExamineSeries(XProxy.Image);
    // JMW 7/14/08 p72t23 - set the pan window for the current image
  SetPanWindow(FPanWindow);
End;

(*
procedure TMag4Viewer.AddImageStudyToList(PI: TImageData; ImageList : TMagImageList; insertat: integer = -1);
var Iobj: TImageData;
  Iproxy: TImageProxy;
begin
  { DONE :
 Decide if we're creating a new copy of the list of objects (Iobj and MagAssign)
  or using the existing list, and referencing the existing objects. }
  {Here we are Creating a new copy of TImageData objeccts{}
  Iobj := TImageData.create;
  Iobj.magAssign(PI);
  Iproxy := TImageProxy.create(self);
  IProxy.ImageList := ImageList;
  // IProxy.transparent := true;  // testing
  Iproxy.parent := scrlv;
  Iproxy.color := scrlv.Color;
  Iproxy.imagedata := Iobj;
  IProxy.CurrentImageData := IObj;
  if FViewStyle = MagViewerViewAbs then
//  if FAbsWindow then
    begin
      Iproxy.font.Name := 'Small Fonts';
      Iproxy.Font.Size := 7;
    end;
  if insertat > -1 then
    begin
      FProxyList.Insert(insertat, IProxy);
      Iproxy.loadindex := insertat;
    end
  else
    begin
      FProxyList.add(Iproxy);
      Iproxy.loadindex := FProxyList.Count - 1;
      insertat := FProxyList.count;
    end;
  Iproxy.Caption := '#' + inttostr(insertat) + ' ' + Iobj.ExpandedDescription;
  Iproxy.OnClick := OnProxyClicked;

end;
*)

Procedure TMag4Viewer.AddImageToList(PI: TImageData; Insertat: Integer = -1);
Var
  IObj: TImageData;
  Iproxy: TImageProxy;
Begin
    //Brk Load 2
        { DONE :
       Decide if we're creating a new copy of the list of objects (Iobj and MagAssign)
        or using the existing list, and referencing the existing objects. }
        {Here we are Creating a new copy of TImageData objeccts... for good or bad.{}
  IObj := TImageData.Create;
  IObj.MagAssign(PI);
  Iproxy := TImageProxy.Create(Self);
    // IProxy.transparent := true;  // testing
  Iproxy.Parent := Scrlv;

  Iproxy.Color := Scrlv.Color;

  Iproxy.ImageData := IObj;
    //  IProxy.CurrentImageData := IObj;
    //  if FAbsWindow then
  If FViewStyle = MagViewerViewAbs Then
  Begin
    Iproxy.Font.Name := 'Small Fonts';
    Iproxy.Font.Size := 7;
  End;
  If Insertat > -1 Then
  Begin
    FProxyList.Insert(Insertat, Iproxy);
    Iproxy.Loadindex := Insertat;
  End
  Else
  Begin
    FProxyList.Add(Iproxy);
    Iproxy.Loadindex := FProxyList.Count - 1;
    Insertat := FProxyList.Count;
  End;
  Iproxy.caption := '#' + Inttostr(Insertat) + ' ' + IObj.ExpandedDescription;
  Iproxy.Onclick := OnProxyClicked;
End;

Procedure TMag4Viewer.OnProxyClicked(Sender: Tobject);
Begin
  LoadProxyImage(FProxyList.Indexof(Sender), True);
End;

Procedure TMag4Viewer.TileAll;
Var
  i: Integer;
Begin

  If FScrollVertical Then
    Scrlv.VertScrollBar.Position := 0
  Else
    Scrlv.HorzScrollBar.Position := 0;
  i := FProxyList.Count;
  Case i Of
    1: SetRowColCount(1, 1);
    2: SetRowColCount(1, 2);
    3, 4: SetRowColCount(2, 2);
    5, 6: SetRowColCount(2, 3);
    7, 8, 9: SetRowColCount(3, 3);
    10, 11, 12: SetRowColCount(3, 4);
    13, 14, 15, 16: SetRowColCount(4, 4);
    17, 18, 19, 20: SetRowColCount(4, 5);
    21, 22, 23, 24, 25: SetRowColCount(5, 5);
    26..30: SetRowColCount(5, 6);
    31..36: SetRowColCount(6, 6);
    37..42: SetRowColCount(6, 7);
    43..49: SetRowColCount(7, 7);
    50..56: SetRowColCount(7, 8);
    57..64: SetRowColCount(8, 8);
  Else
    SetRowColCount(10, 10);
  End; {case}
End;

Procedure TMag4Viewer.ReAlignImages(Ignmax: Boolean = False; Ignlocksize: Boolean
  = False; ImageToDisplayIndex:
  Integer = -1);
Var
  ApplyAll: Boolean;
    //  win, lev : integer;
Begin
    //Brk Load 3
        {
        // not sure what this was doing... hope it is being done in another way now... (JMW 11/30/06)
        if Cur4Image <> nil then
        begin
           win := Cur4Image.GetState.WinValue;
           lev := Cur4Image.GetState.LevValue;
        end;
        }
  FignoreMax := Ignmax;
  FIgnoreLockSize := Ignlocksize;
    //Brk Load 4
  Case FViewerStyle Of
    MagvsVirtual: RealignProxy(ImageToDisplayIndex);
    MagvsDynamic: RealignProxy(ImageToDisplayIndex);
    MagvsStaticPage: RealignProxy(ImageToDisplayIndex);
  End;

  If FViewStyle = MagViewerViewRadiology Then
  Begin
    ApplyAll := FApplytoall;
    FApplytoall := True;
    FitToWindow();

    FApplytoall := ApplyAll;
  End;

  RefreshViewerDesc;
  UpdateToolButtons;
End;

Procedure TMag4Viewer.ReSizeAndAlign(h, w: Integer);
Var
  LockSize, Ignorelocksize: Boolean;
Begin
  Ignorelocksize := FIgnoreLockSize;
  LockSize := FLockSize;
  Try
    FLockHeight := h;
    FLockWidth := w;
    ReAlignImages;
  Finally
    FIgnoreLockSize := Ignorelocksize;
    FLockSize := LockSize;
  End;
End;

Procedure TMag4Viewer.UpdateToolButtons;
Begin
  StopLoadingImages := True;
  If Not FScrollVertical Then
  Begin
    TbtnAbsPagePrev.Enabled := (Scrlv.HorzScrollBar.Visible) And
      (Scrlv.HorzScrollBar.Position > 0);
    TbtnAbsPageNext.Enabled := (Scrlv.HorzScrollBar.Visible) And
      ((Scrlv.HorzScrollBar.Position + Scrlv.Width) <
      Scrlv.HorzScrollBar.Range);
  End
  Else
  Begin
    TbtnAbsPagePrev.Enabled := (Scrlv.VertScrollBar.Visible) And
      (Scrlv.VertScrollBar.Position > 0);
    TbtnAbsPageNext.Enabled := (Scrlv.VertScrollBar.Visible) And
      ((Scrlv.VertScrollBar.Position + Scrlv.Height)
      < Scrlv.VertScrollBar.Range);
  End;
End;

Procedure TMag4Viewer.CursorChange(Var oldcurs: TCursor; newcurs: TCursor);
Begin
  oldcurs := Screen.Cursor;
  If Screen.Cursor <> newcurs Then
    Screen.Cursor := newcurs;
End;

Procedure TMag4Viewer.CursorRestore(oldcurs: TCursor);
Begin
  If Screen.Cursor <> oldcurs Then
    Screen.Cursor := oldcurs;
End;

Procedure TMag4Viewer.RealignProxy(ImageToDisplayIndex: Integer = -1);
//FViewerStyle = magvsVirtual (Proxy's)
Var
  i: Integer;
  VisProxy: Integer;
  ocurs: TCursor;
Begin
    //Brk Load 4
        {       Based on Row and Col count, we get obH and obW, with obH,obW we
                then calc the Height Width needed to hold all, and resize the
                Scrollbar. Then put proxy for each obImage and display visible ones.{}
  If Application.Terminated Then
    Exit;
  If FProxyList.Count = 0 Then
    Exit;
    //maggmsgf.MagMsg('s', '###Realign Proxy');
    //LogMsg('s', '###Realign Proxy');
    //p117  MagLogger.LogMsg('s', '###Realign Proxy'); {JK 10/5/2009 - MaggMsgu refactoring}
  IMsgObj.Log(msglvlDEBUG,'###Realign Proxy');
  If (FColCountSaved > 0) And (FignoreMax) Then
  Begin
    FIgnoreLockSize := True;
    FColcount := FColCountSaved;
    FColCountSaved := 0;
    FRowcount := FRowCountSaved;
    FRowCountSaved := 0;
    FLockSize := FLockSizeSaved;
    FignoreMax := False;
  End;
  InitLTHW;
    //GEK Test 72w59 slow maximizing image.  if Scrlv.Visible (update was always there);
  If Scrlv.Visible Then
    Update;
  SetScrollAreaSize(FProxyList.Count, FScrollVertical);
  CursorChange(ocurs, crHourGlass); //      screen.Cursor := crHourGlass;
  For i := 0 To FProxyList.Count - 1 Do
  Begin
    SetProxyPosition(i);
  End;
  cursorRestore(ocurs); //     screen.cursor := xcursor; // p8t35  was changing back to default too soon.
    // was intentional. to allow clicking on an abs as
    // other loaded.   Was an unknown feature, and
    // now could be causing access violations.
  //GEK Test 72w59 slow maximizing image.
  //scrlv.Visible := true;

  If ImageToDisplayIndex > -1 Then
  Begin
        // JMW P72 8/1/2006
        // this causes the app to load the images in view based on the selected image
        // and then select the desired image
    ScrollToImage(ImageToDisplayIndex);
    VisProxy := FirstVisProxy;
        //brk Load 5
    LoadProxyImages(VisProxy); {** ReAlignProxy **}
        //ShowImage(ImageToDisplayIndex); // jw 11/16/07 - make the selected image appear
        //LoadProxyImages(ImageToDisplayIndex);
  End
  Else
    LoadProxyImages(FirstVisProxy); {** ReAlignProxy **}
  LbScrlvSize.SetBounds(0, 0, 12, 12);
End;

{We know FBaseH, FBaseW, FcolCount, FRowCount, and 'ct' count of images}

Procedure TMag4Viewer.SetScrollAreaSize(ct: Integer; Vertscroll: Boolean);
Var
  h, w: Integer;
Begin
  If ct < 100 Then
    Exit;
  If Vertscroll Then // need height;
  Begin
    w := Scrlv.Width;
    h := Trunc(((ct Div FColcount) + 1) * (FbaseH + FRowsp));
  End
  Else // need width;
  Begin
    h := Scrlv.Height;
    w := Trunc(((ct Div FRowcount) + 1) * (FbaseW + FColsp));
  End;
  LbScrlvSize.SetBounds(w - 30, h - 30, 2, 2);
End;

Function TMag4Viewer.FirstVisProxy: Integer;
Var
  i: Integer;
  Muchvisible: Integer;
Begin
  If FScrollVertical Then
    Muchvisible := FbaseH - (FbaseH Div 2) // if  1/8 is showing
  Else
    Muchvisible := FbaseW - (FbaseW Div 2); // if  1/8 is showing

  For i := 0 To FProxyList.Count - 1 Do
  Begin
    If FScrollVertical Then
    Begin
      If ((TImageProxy(FProxyList[i]).Top + Muchvisible) > 0) Then
        Break;
    End
    Else
      If ((TImageProxy(FProxyList[i]).Left + Muchvisible) > 0) Then
        Break;
  End;
  Result := i;
End;

// Is this proxy, in the visible area on the ScroolBox (scrlv)

Function TMag4Viewer.IsVisibleProxy(Proxy: TImageProxy): Boolean;
Var
  Precentvisible: Integer;
Begin
  If FScrollVertical Then
    Precentvisible := FbaseH - (FbaseH Div 2) // if  1/8 is showing
  Else
    Precentvisible := FbaseW - (FbaseW Div 2); // if  1/8 is showing
  If FScrollVertical Then
    Result := ((Proxy.Top + Precentvisible) > 0)
      And ((Proxy.Top + Precentvisible) < (Scrlv.Height))
  Else
    Result := ((Proxy.Left + Precentvisible) > 0)
      And ((Proxy.Left + Precentvisible) < (Scrlv.Width));
End;

// Load the Images from the ProxyList starting with proxyindex

Procedure TMag4Viewer.LoadProxyImages(Proxyindex: Integer = -1);
Var
  i, j, Visct: Integer;
  Proxy: TImageProxy;
  cttoload: Integer;
  Xmsg: String;
  Curct: Integer;
  ocurs: TCursor;
    // p8t43  only show stop loading message window after 1st image.
Begin
    //brk Load 5
  Try
    CursorChange(ocurs, crHourGlass); //     screen.cursor := crHourglass;
    If FProxyList.Count = 0 Then
      Exit;
    If Proxyindex = -1 Then
      Proxyindex := FirstVisProxy;
    cttoload := FMaxCount; // The maximum to load : FMaxCount
        // JMW 5/26/2006 P72, able to load only 1 image in the study if desired
    If FMaxAutoLoad > 0 Then
      cttoload := FMaxAutoLoad;
    j := Proxyindex;
        //Start with this one j (probably computed by using FindFirstVisibleProxy
    If FScrollVertical Then
    Begin
      If ViewerStyle = MagvsStaticPage
                {//gek jw 11/16/07  implement the ViewerStyle properties.}Then
        Visct := (RowCount * ColumnCount)
                    {    This forces FMaxCount >= VisibleCount}
      Else
        Visct := (RowCount * ColumnCount) + ColumnCount;
    End
    Else {So, we are scrolling Horizontal.}
    Begin
      If ViewerStyle = MagvsStaticPage Then
        Visct := (RowCount * ColumnCount)
      Else
        Visct := (RowCount * ColumnCount) + RowCount;
    End;
    If (Visct > FMaxCount) Then
      cttoload := Visct;
        // we'll load more than MaxCount if more are visible.
    If (cttoload > (FProxyList.Count - j)) Then
      cttoload := FProxyList.Count - j; // but not more than are in list.
    If cttoload = 0 Then
      Exit;
    StopLoadingImages := False;

    If (FProxyList.Count > 0) And (FViewStyle = MagViewerViewAbs) Then
    Begin
            //out to stop error vcl70.bpl         self.FLoadingMsgWin.init(cttoload);
            //out to stop error vcl70.bpl         self.FLoadingMsgWin.RequestToStopLoading := FALSE;
    End;
    Curct := 0;

    For i := j To j + cttoload - 1 Do
    Begin
      If Self.StopLoadingImages Then
        Break;
            //out to stop error vcl70.bpl          self.FLoadingMsgWin.Update;
            //out to stop error vcl70.bpl          if self.FLoadingMsgWin.RequestToStopLoading then break;
      If (i > FProxyList.Count - 1) Then
        Break;
      Proxy := FProxyList[i];
      If (Proxy.Image <> Nil) And (Proxy.Image.ImageLoaded) Then
      Begin
        If (Not Proxy.Image.Visible) Then
          Proxy.Image.Visible := True;
        Continue;
      End;
      Inc(Curct);
            //out to stop error vcl70.bpl          if self.FLoadingMsgWin.RequestToStopLoading then break;
                   { TODO -oGarrett -c93LookAndFeel :
                        93 get rid of loading image message window.  maybe have a label and button on
                        the viewer that does what the loading window does. }
            //out to stop error vcl70.bpl          if (curct > 1 ) then self.FLoadingMsgWin.UpdStatus(proxy.imagedata.ImgDes, i, proxyindex, proxyindex + cttoload, FProxyList.count);
//brk Load 6
      LoadProxyImage(i);
      Application.Processmessages;
            //out to stop error vcl70.bpl          if self.FLoadingMsgWin.RequestToStopLoading then break;
    End;
    If Not MagImageManager1.IsImageCurrentlyCaching() Then
      If Assigned(MagSecurity) Then
        FMagSecurity.MagCloseSecurity(Xmsg);
        { frmLoadingImageMessage will be used for all vieweres, not just abstracts,
           full res window viewers will have a longer delay, before it comes visible.{}
  Finally
        //out to stop error vcl70.bpl       self.FLoadingMsgWin.close;
    cursorRestore(ocurs); //         screen.Cursor := previous cursor;
  End;
End;

Procedure TMag4Viewer.LoadProxyImage(Index: Integer; CloseSecurity: Boolean =
  False);
{ All loading of images into the Gear components goes through here.
  The call vGear.LoadTheImage(oneimage) does the actual Loading}
Var
  VGear: TMag4VGear;
  Oneimage, Errstr, Notfoundstr: String;
  Xmsg: String;
  Proxy: TImageProxy;
  CacheImage: String;
  ImgType: TMagImageType;
  IsAbs: Boolean;
  TxtFilename: String;
  TransferResult: TMagImageTransferResult;
  ocurs: TCursor;
Begin
    (* SLOW EVERYTHING DOWN.  FOR TESTING.
     FOR I := 0 TO 220000 DO
       BEGIN
       PNLTOP.CAPTION := INTTOSTR(I);
       PNLTOP.Update;
       // if visible then it is slower.
       IF GetDescVisible  AND (I > 5000) THEN BREAK
       END;                 *)
//brk Load 6
  Try
    TransferResult := Nil;
    Proxy := TImageProxy(FProxyList[Index]);
        {
        vGear := create_P(proxy); //possible change the create(scrlV)
        vGear.listindex := index;
        proxy.Image := vGear;
        vGear.Visible := false;
        }

    If Proxy.Image = Nil Then
    Begin
      VGear := Create_P(Proxy); //possible change the create(scrlV)
      VGear.ListIndex := Index;
      Proxy.Image := VGear;
    End
    Else
      VGear := Proxy.Image;

    If FbaseH = 0 Then
      CalcHWusingRowCol;

        // this must be up here (before image loads) or else the image loads very small (and still flashes)
    VGear.SetBounds(Proxy.Left, Proxy.Top, Proxy.Width, Proxy.Height);

    If FViewStyle = MagViewerViewAbs Then
      IsAbs := True
    Else
      IsAbs := False;
        //  if not FRadiologyView then

    If FViewStyle <> MagViewerViewRadiology Then
      VGear.ImageDescription :=
        Proxy.ImageData.ExpandedDescription(IsAbs);
        //{//59 next 2, but not use OnImageScroll, use JW's events.}
    VGear.ImageDescriptionHint(Proxy.ImageData.ExpandedIdDateDescription());
        //59  vGear.OnImageScroll := ImageVScroll;
    { gek 5/18/10  p117  Test the need to show Status;}
(*    if isAbs then
      begin
       vGear.ImageDescription :=
        proxy.ImageData.GetStatusDesc + ' ' +
        proxy.imagedata.ExpandedDescription(isAbs);
      end;
      *)
     // end 117 showing status Test. above is out in p117 

        //  update; // JMW 6/14/2006 moved below
    Cur4Image := VGear;
        { TODO -cRefactor: rethink the properties of vGear, ( Mag4VGear) do we need them all now. ?
             ien as tag. caused us problems in some sites,  to long.

        {-------- Switch image path to Cache directory, if it exists.---------}
        (*
        CacheImage := MagImageManager1.getCachedImage(oneimage, proxy.ImageData.PlaceCode);
        if CacheImage <> ''
          then
            begin
             oneimage := CacheImage;
             maggmsgf.MagMsg('s','Using Cached Image : '+ ExtractFileName(oneImage));
            end
          else
          begin { we get here because cached image doesn't exist}
            if FAbsWindow then
              begin
                errstr :=   '\bmp\AbsError.bmp';
                notfoundstr :=   '\bmp\NotExist.bmp';
              end
              else
              begin
                errstr := '\bmp\FullResFileOpenError.bmp';
                notfoundstr := '\BMP\FullResFileNotFound.BMP';
              end;

            if assigned(magsecurity) then
                begin
                  if (not FMagSecurity.MagOpenSecurePath(oneimage, xmsg))
                    then oneimage := Futils.AppPath + errstr
                end;
            if (not fileexists(oneimage)) then oneimage := FUtils.AppPath + notfoundstr;
          end;
          *)
    CursorChange(ocurs, crHourGlass); //            screen.cursor := crHourglass;
    If IsAbs Then
      ImgType := MagImageTypeAbs
    Else
      ImgType := MagImageTypeFull;
     { //117 gek we were missing FIgnoreBock  from 94}
    transferResult := MagImageManager1.getImageGuaranteed(proxy.ImageData, ImgType, not closesecurity, FIgnoreBlock);
    Oneimage := TransferResult.FDestinationFilename;

    VGear.AutoRedraw := False;

        // if the response says its diagnostic, load as diagnostic
    If TransferResult.FImageQuality = DIAGNOSTIC_IMG Then
      VGear.LoadTheImage(Oneimage, True)
    Else
            //brk Load 7

      {/ P117 - JK 8/31/2010 /}
      if Proxy.ImageData.IsImageDeleted then
      begin
        if Proxy.ImageData.GroupCount > 1 then
          VGear.LoadTheImage(MagImageManager1.GetCannedBMP(MagAbsDeletedGroup))
        else
          VGear.LoadTheImage(MagImageManager1.GetCannedBMP(MagAbsDeletedImage));
      end
      else
        VGear.LoadTheImage(Oneimage);

    cursorRestore(ocurs); //         screen.cursor := crDefault;
    VGear.ImageLoaded := True;
    VGear.Visible := True;
    Proxy.Visible := False;

        //  update;
    If FViewStyle = MagViewerViewRadiology Then
    Begin
      TxtFilename := '';
      If GetImageUtility().DetermineStorageProtocol(Proxy.ImageData.FFile)
        = MagStorageUNC Then
      Begin
        TxtFilename := ChangeFileExt(Proxy.ImageData.FFile, '.txt');
                //LogMsg('s', 'About to get text file for image [' +
                //    proxy.ImageData.Mag0 + ']');
        MagLogger.LogMsg('s', 'About to get text file for image [' +
          Proxy.ImageData.Mag0 + ']'); {JK 10/5/2009 - MaggMsgu refactoring}
        TransferResult := MagImageManager1.GetFile(TxtFilename,
          Proxy.ImageData.PlaceCode, Proxy.ImageData.ImgType, False);
        If (TransferResult.FTransferStatus = IMAGE_FAILED) Or
          (TransferResult.FTransferStatus = IMAGE_UNAVAILABLE) Then
          TxtFilename := ''
        Else
          TxtFilename := TransferResult.FDestinationFilename;
      End;
            //LogMsg('s', 'About to load DICOM header information for image [' +
            //    proxy.ImageData.Mag0 + ']');
      MagLogger.LogMsg('s', 'About to load DICOM header information for image [' +
        Proxy.ImageData.Mag0 + ']'); {JK 10/5/2009 - MaggMsgu refactoring}
      If Not VGear.LoadDICOMData(TxtFilename, FCurrentPatientSSN,
        FCurrentPatientICN, False) Then
      Begin

        VGear.ClearImage();
        VGear.ImageLoaded := True;
                //vGear.LoadTheImage('\bmp\ImageQA.bmp');
        VGear.LoadTheImage(MagImageManager1.GetCannedBMP(MagAbsQA));
        VGear.DisableWindowLevel();
        If Assigned(FPatientIDMismatchEvent) Then
          FPatientIDMismatchEvent(Self, VGear);

                //LogMsg('DEQA',
                //    'Patient identifier from VistA does not match patient identifier from image.');
        MagLogger.LogMsg('DEQA',
          'Patient identifier from VistA does not match patient identifier from image.'); {JK 10/5/2009 - MaggMsgu refactoring}
      End
      Else
      Begin
                {   check here to see if using current settings or whatever}
        VGear.WindowLevelEntireImage();
      End;
      VGear.AutoRedraw := True;
      VGear.UpdatePageView();
      VGear.ImageDescription := '#' + Inttostr(Index + 1) + ' ' +
        Proxy.ImageData.ExpandedDescription(IsAbs);
      VGear.DrawRadLetters();
      VGear.SetAnnotationStyle(FAnnotationStyle);
            // moved - not just for Radiology!
            //vGear.setCurrentTool(FCurrentTool);

      if TransferResult.FTransferStatus = IMAGE_COPIED then  {/ P117 JK 1/24/2011 - don't register a LogImageAccess event if the image wan not loaded /}
        If DMagImageAccessLogManager <> Nil Then
        Begin
          DMagImageAccessLogManager.LogImageAccess(Proxy.ImageData);
        End;

      ExamineSeries(VGear);
    End {EndIf for Rad Viewer}
            { JMW 5/12/08 P72 - If the viewer is in full res mode, then make sure
             the image loads fit to width (not fit to window) }
    Else
      If FViewStyle = MagViewerViewFull Then
      Begin
            {  JMW 5/12/08 P72
              must set auto redraw to true here so the fit to Width will properly
              update the zoom value within the component
              don't need an UpdatePageView since the FitToWidth will do it }
        VGear.AutoRedraw := True;
            {   JMW 4/6/09 - P93 moved here, needs to be called after image is loaded}
        If FLastRemember Then
          Case FLastFit Of
            IG_DISPLAY_FIT_TO_WINDOW: VGear.FitToWindow;
            IG_DISPLAY_FIT_TO_WIDTH:
              Begin
                VGear.FitToWidth; //pre 93
                VGear.UpdatePageView;
                VGear.Update;
                VGear.SetScrollPos(-9999, -9999);
              End;
            IG_DISPLAY_FIT_TO_HEIGHT: VGear.FitToHeight;
            IG_DISPLAY_FIT_1_TO_1:
              Begin
                VGear.Fit1to1;
              End;
          End;
      End
      Else
      Begin
        VGear.AutoRedraw := True;
        VGear.UpdatePageView();
      End;
        // needs to be done for both Rad and Full Res
    VGear.SetCurrentTool(FCurrentTool);
    Update;

  Finally
    If (Assigned(MagSecurity) And CloseSecurity) Then
      MagImageManager1.SafeCloseNetworkConnections();
        //   FMagSecurity.MagCloseSecurity(xmsg);
    If TransferResult <> Nil Then
      FreeAndNil(TransferResult);
  End;
End;

Function TMag4Viewer.Create_P(Proxy: TImageProxy): TMag4VGear;
Var
  Visct, i: Integer;
  TmpVGear: TMag4VGear;
  FileExt: String;
  Prox: TImageProxy;
Begin
  i := 0;
  Visct := VisibleCount;
  If FScrollVertical Then
    Visct := Visct + FColcount
  Else
    Visct := Visct + FRowcount;
    {  Here we will put one in the Gear Pool if max and visible counts are exceeded.}
  If (FLoadedList.Count > (FMaxCount - 1)) And (FLoadedList.Count > (Visct -
    1)) Then
  Begin
        { Don't want to destroy a Currently VISIBLE Proxy Image. {}
        { we might only need the top row, but this way, could cause the whole page
         to be incrementally updated, robbing a page to pay a page,
                                          lets just rob the unseen guy)}
    If FScrollUp Then
      For i := 0 To FLoadedList.Count - 1 Do
      Begin
        Prox := FLoadedList[i];
                //if not IsVisibleProxy(FloadedList[i]) then break;
        If (Not IsVisibleProxy(FLoadedList[i])) And (Not
          Prox.Image.UnsavedChanges) Then
          Break;
      End;
    If Not FScrollUp Then
      For i := FLoadedList.Count - 1 Downto 0 Do
      Begin
        Prox := FLoadedList[i];
        If (Not IsVisibleProxy(FLoadedList[i])) And (Not
          Prox.Image.UnsavedChanges) Then
          Break;
                //if not IsVisibleProxy(FloadedList[i]) then break;
      End;
        {   destroy_p adds the gear control to FGearPool}
        {   JMW 11/12/2008 - sometimes the location to destroy has already been
            moved or adjusted if the user is switching through images very quickly
            this causes exceptions, test to make sure the location can be changed. }
    If (i >= 0) And (i < FLoadedList.Count) Then
    Begin
      Destroy_p(TImageProxy(FLoadedList[i]));
      FLoadedList.Delete(i);
    End;
  End;
  Result := GetVGearFromPool(Proxy.ImageData);
    // I don't think this should ever happen...
  If (FGearPool.Count = 0) And (Result = Nil) Then
        //  if FGearPool.Count = 0 then
  Begin
    Result := CreateVGear(Proxy.ImageData);
  End;

  // need a call to set the image list in the TMag4VGear component

  AddToLoadedList(Proxy);
    {   Set Default properties }
  With Result Do
  Begin
    {/117}
    if self.FShowImageStatus then  result.SetShowImageStatus(self.FShowImageStatus);  //117
    PI_ptrData := Proxy.ImageData;
        //     if fabswindow then
    If FViewStyle = MagViewerViewAbs Then
      Result.ViewStyle := MagGearViewAbs
    Else
      If FViewStyle = MagViewerViewRadiology Then
            //     else if FRadiologyView then
        Result.ViewStyle := MagGearViewRadiology
      Else
        Result.ViewStyle := MagGearViewFull;
        //     AbstractImage :=FAbsWindow;
    FontSize := FFontSize;
    Parent := Scrlv;
    IsDragAble := FIsDragAble;
    If FIsDragAble Then
      DragMode := DmAutomatic;
    IsSizeAble := FIsSizeAble;

  End;
    //  if FRadiologyView then
  If FViewStyle = MagViewerViewRadiology Then
  Begin
        //result.ViewStyle := MagGearViewRadiology;
    Result.OnImageMouseScrollUpEvent := OnImageMouseScrollUp;
    Result.OnImageMouseScrollDownEvent := OnImageMouseScrollDown;
    Result.ShowPixelValues := FShowPixelValues;
    Result.HistogramWindowLevel := FHistogramWindowLevel;
    Result.ShowLabels := FShowLabels;
    Result.OnImageZoomScroll := ImageZoomScroll;
    Result.OnImageWinLevChange := ImageWinLevChange;
    Result.OnImageBriConChange := ImageBriConChange;
    Result.OnImageToolChange := ImageToolChange;
    Result.OnImageZoomChange := ImageZoomChange;
    Result.OnImageUpdateImageState := ImageUpdateImageState;
    Result.OnPanWindowClose := PanWindowCloseEvent;
    Result.setMouseZoomShape(FMouseZoomShape); // use last setting
        //    result.setCurrentTool(FCurrentTool);  // caused exceptions with annotations and image not being loaded yet

        //    result.ImageNumber := proxy.loadindex;
  End
  Else
    If FViewStyle = MagViewerViewFull Then
    Begin
      Result.OnImageZoomScroll := ImageZoomScroll;
      Result.OnPanWindowClose := PanWindowCloseEvent;
      Result.OnImageUpdateImageState := ImageUpdateImageState;
      Result.setMouseZoomShape(MagMouseZoomShapeRectangle); // always rectangle
    End;

End;

Function TMag4Viewer.CreateVGear(IObj: TImageData): TMag4VGear;
Var
  FileExtension: String;
  GearAbility: TMagGearAbilities;
Begin
    //Break Load 1
  Case FViewStyle Of
    MagViewerViewAbs:
      Begin
        FileExtension := ExtractFileExt(IObj.AFile);
        GearAbility := MagGearAbilityMinimal;
      End;
    MagViewerViewFull:
      Begin
        FileExtension := ExtractFileExt(IObj.FFile);
        GearAbility := MagGearAbilityClinical;
      End;
    MagViewerViewRadiology:
      Begin
        FileExtension := ExtractFileExt(IObj.FFile);
        GearAbility := MagGearAbilityRadiology;
      End;
  Else
    Begin
      FileExtension := ExtractFileExt(IObj.FFile);
      GearAbility := MagGearAbilityRadiology;
    End;

  End;

    //  if FAbsWindow then   // <<< this was the older way.  FAbsWindow was a property of the mag4VGear.
(*  reworked as Case Statement above.
    gearAbility := MagGearAbilityRadiology;
    if FViewStyle = MagViewerViewAbs then
    begin
        fileExtension := ExtractFileExt(IObj.AFile);
        gearAbility := MagGearAbilityMinimal;
    end
    else
        fileExtension := ExtractFileExt(Iobj.FFile);
    if FViewStyle = MagViewerViewFull then
        gearAbility := MagGearAbilityClinical
    else if FViewStyle = MagViewerViewRadiology then
        gearAbility := MagGearAbilityRadiology;
*)
  Result := TMag4VGear.Create(Self, FileExtension, GearAbility);
  Result.SmoothImage;
  Result.AutoRedraw := True;
  Result.OnImageClick := ImageVClick;
  Result.OnImageMouseDown := ImageVMouseDown;
  Result.OnImageMouseUp := ImageVMouseUp;
  Result.OnImageKeyDown := ImageVKeydown;
  Result.Height := 5;
  Result.Width := 5;
    //result.OnLogEvent := OnLogEvent;  {JK 10/6/2009 - Maggmsgu refactoring}
  If FViewStyle <> MagViewerViewAbs Then
    Result.OnImageDoubleClickEvent := OnImageDoubleClickEvent;

End;

Function TMag4Viewer.GetVGearFromPool(IObj: TImageData): TMag4VGear;
Var
  i: Integer;
  FileExtension: String;
Begin
    //  if FAbsWindow then
  If FViewStyle = MagViewerViewAbs Then
    FileExtension := ExtractFileExt(IObj.AFile)
  Else
    FileExtension := ExtractFileExt(IObj.FFile);
  For i := 0 To FGearPool.Count - 1 Do
  Begin
    Result := FGearPool[i];
        {   This always returns true, it was a IG99 IG14 manager.}
    If Result.CanUseForFile(FileExtension) Then
    Begin
      Result.ImageLoaded := False;
            // HERE, We're getting a 'used' VGear,   do we want to reset Here ?
      FGearPool.Delete(i);
      Exit;
    End;
  End;
  Result := CreateVGear(IObj);

  Result.ImageLoaded := False;

End;

{       keep it sorted by Proxy (left or right) so we can switch a VGear with
        an invisible one. {}

Procedure TMag4Viewer.AddToLoadedList(Proxy: TImageProxy);
Var
  i: Integer;
  CanInsert: Boolean;
Begin
  CanInsert := False;
  If FLoadedList.Count = 0 Then
    i := 0
  Else
    For i := 0 To FLoadedList.Count - 1 Do
    Begin
      If FScrollVertical And (Proxy.Top < TImageProxy(FLoadedList[i]).Top) Then
      Begin
        CanInsert := True;
        Break;
      End;
      If Not FScrollVertical And (Proxy.Left <
        TImageProxy(FLoadedList[i]).Left) Then
      Begin
        CanInsert := True;
        Break;
      End;
    End;
  If CanInsert Then
    FLoadedList.Insert(i, Proxy)
  Else
    FLoadedList.Add(Proxy);
End;
//oot 7/16/02
(*
procedure TMag4Viewer.ReAlignDynamic;
var i: integer;
begin
InitLTHW;        //commented out
update;
//HideAllImages;
for i := 0 to I3ptrList.count - 1 do
begin
 if I = FMaxcount then break;
 DisplayOneImage(i);
 //  PI := AllPIList[i];
 //  loadoneimage(AllPIList.count-1,PI);
end;
end;
*)

//oot 7/16/02
(*
procedure TMag4Viewer.ReAlignStatic;
var i: Integer;
begin
InitLTHW;   //commented out
update;
//HideAllImages;
for i := 0 to I3ptrList.count - 1 do
begin
 if I = FMaxcount then break;
 DisplayOneImage(i);
 //  PI := AllPIList[i];
 //  loadoneimage(AllPIList.count-1,PI);
end;
end;

*)

Procedure TMag4Viewer.SetLockSize(Value: Boolean);
Var
  Iproxy: TImageProxy;
Begin
  FLockSize := Value;
  If (FLockSize And (FLoadedList.Count > 0)) Then
  Begin
    Iproxy := FLoadedList[0];
    FLockHeight := Iproxy.Image.Height;
    FLockWidth := Iproxy.Image.Width;
  End;
End;

Procedure TMag4Viewer.SetZoomWindow(Value: Boolean);
Begin
  If Cur4Image = Nil Then
    Exit;
  Cur4Image.ZoomWindow := Value;
End;

Procedure TMag4Viewer.SetPanWindowWithActivateOption(Value: Boolean;
  Activate: Boolean);
Var
  x, y: Integer;
  Viewerpt, Imagept: TPoint;
  h, w: Integer;
Begin
  FPanWindow := Value;
    //  PanCloseAll;
      {    below, we are only appling PanWindow to the Current Image{}
  If Cur4Image = Nil Then
    Exit;
  Viewerpt := Parent.ClientOrigin;
  Imagept := Cur4Image.ClientOrigin;
  x := Imagept.x - 100 + Cur4Image.Width; // Cur4Image.Gear1.Width;
  y := Imagept.y;
  h := Trunc(Cur4Image.Height / 2.5);
  w := Trunc(Cur4Image.Width / 2);
  If (Value) And (Activate) Then
    Cur4Image.PanWindowSettings(h, w, x, y)
  Else
    Cur4Image.PanWindow := Value;

End;

Procedure TMag4Viewer.SetPanWindow(Value: Boolean);
Begin
  SetPanWindowWithActivateOption(Value, True);

  Exit;
    { Below was when we were doing ApplyToAll pan window.
         Not this easy, pan windows don't move with the images when they are
         scrolled, so easy to get all confused. {}

    (*
      if FApplyToall then
        for i := 0 to FProxyList.Count - 1 do
          begin
            Iproxy := FProxyList[i];
            if Iproxy.Image <> nil then
              begin
                imagept := Iproxy.Image.ClientOrigin;
                x := imagept.x - 100 + Iproxy.Image.Width;
                y := Imagept.y;
                if value then Iproxy.Image.PanWindowSettings(110, 85, x, y)
                else Iproxy.Image.PanWindow := false;
              end;
          end
      else //if (SelectedCount > 0) then
        for i := 0 to FProxyList.Count - 1 do
          begin
            Iproxy := FProxyList[i];
            if Iproxy.Image <> nil
              then if TMag4Vgear(Iproxy.Image).selected
              then
                begin
                  imagept := Iproxy.Image.ClientOrigin;
                  x := imagept.x - 100 + Iproxy.Image.Width;
                  y := Imagept.y;
                  if value then Iproxy.Image.PanWindowSettings(110, 85, x, y)
                  else Iproxy.Image.PanWindow := false;
                end;

          end;
    *)

    // below was when we were only appling PanWindow to the Current Image
    (*  if Cur4Image = nil then exit;
      viewerpt := Parent.ClientOrigin;
      imagept := Cur4Image.ClientOrigin;
      x := imagept.x -100 + Cur4Image.Gear1.Width;
      y := imagept.y -100 ;
      if value then  Cur4Image.PanWindowSettings(110,85,x,y)
               else  Cur4Image.panwindow := value;   *)

     (* this is from old versions
      Full1.GUIWINDOW := GUIPAN;
      Full1.GUIHeight := 100;
      Full1.GUIWIDTH := 100;
      Full1.GUIXPOS := x;
      Full1.GUIYPOS := y;
    *)
End;

Procedure TMag4Viewer.PanCloseAll;
Var
  i: Integer;
Begin
  For i := 0 To FProxyList.Count - 1 Do
  Begin
    If TImageProxy(FProxyList[i]).Image <> Nil Then
      TImageProxy(FProxyList[i]).Image.PanWindow := False;
  End;
End;

//procedure TMag4Viewer.MaxImageToggle(Iobj: TImageData);

Procedure TMag4Viewer.MaxImageToggle(VGear: TMag4VGear);
Var
  Lindex: Integer;
Begin
    // check for view style and act appropriately
  If ((FColcount = 1) And (FRowcount = 1)) And ((FColCountSaved > 0) And
    (FRowCountSaved > 0)) Then
  Begin
    Lindex := VGear.ListIndex;
    SetRowColCount(FRowCountSaved, FColCountSaved, Lindex);
    ShowImage(Lindex);
        //ScrollToImage(iobj);
    //      if FHorizScrollSaved > 0 then scrlv.HorzScrollBar.Position := FHorizScrollSaved;
  End
  Else
    SetMaximizeImage(True);
End;

Procedure TMag4Viewer.SetMaximizeImage(Value: Boolean);
Var
  Tcol, Trow, Thorizscroll: Integer;

Begin
  Try
    Self.Scrlv.Visible := False;
    Self.Scrlv.Update;
    Update;
    Application.Processmessages;

    If Cur4Image = Nil Then
      Exit;
    FMaximizeImage := Value;
    If Not Value Then
    Begin
      ReAlignImages;
      Exit;
    End;
    Tcol := FColcount;
    Trow := FRowcount;
    Thorizscroll := Scrlv.HorzScrollBar.Position;

        // here could grow the selected image to fill the screen.
        // GEK 72 p 59  sending Listindex...
    SetRowColCount(1, 1, Cur4Image.ListIndex);
        // gek redundant  SetRowColCount, calls RealingImages, which calls Scroll to Image if ListIndex is passed.
        // ReAlignImages;
        //  ScrolltoImage(TImageData(Cur4Image.PI_ptrData));
    FColCountSaved := Tcol;
    FRowCountSaved := Trow;
    FHorizScrollSaved := Thorizscroll;
    FLockSizeSaved := FLockSize;
    FLockSize := False;

  Finally
    Self.Scrlv.Visible := True;
  End;

End;

Procedure TMag4Viewer.SetMaxCount(Value: Integer);
Begin
  If (Value < 1) Then
    FMaxCount := 1
  Else
    FMaxCount := Value;
End;

Procedure TMag4Viewer.DeleteProxy(Proxyindex: Integer);
Var
  IObj: TImageData;
  Iproxy: TImageProxy;
  VGear: TMag4VGear;
Begin
  Iproxy := FProxyList[Proxyindex];
  IObj := Iproxy.ImageData;

    { DONE :  AccessViolations, if Iobj isn't a MagAssigned object,
              then we are deleting the Object out of magImageList ( objlist); }
  If IObj <> Nil Then
    FreeAndNil(IObj);

  VGear := Iproxy.Image;

    // JMW 7/17/08 p72t23 - when removing an image, disable the pan window for the
    // vGear component to hide the pan window
  If VGear <> Nil Then
    VGear.PanWindow := False;

  If (VGear <> Nil) Then
  Begin
    VGear.PI_ptrData := Nil;
        // JMW 1/26/2007 p72 freed above, setting to null to prevent access violations in vGear.destroy
    Destroy_p(Iproxy);
  End;

    //    .... brings back memories of old problems DESTROYING with Gear1.

  Application.Processmessages;

  If (FLoadedList.Indexof(Iproxy) > -1) Then
    FLoadedList.Delete(FLoadedList.Indexof(Iproxy));

  FProxyList.Delete(Proxyindex);

    {JK 2/13/2009 - Need to re-order the cur4Image list index values from the point where the
     deleted proxy occurred upwards.  This will bring them back into synch after the
     deletion operation.}
  ReorderProxyListIndexes(Proxyindex);

  Iproxy.Free;
End;

{JK 2/13/2009 - Fixes D79}

Procedure TMag4Viewer.ReorderProxyListIndexes(Proxyindex: Integer);
Var
  i: Integer;
Begin
  If Application.Terminated Then
    Exit;
  For i := Proxyindex To FProxyList.Count - 1 Do
        {gek 93T7 - added jerry's check for nil [if... ]}
    If (TImageProxy(FProxyList[i]).Image <> Nil) Then
      TImageProxy(FProxyList[i]).Image.ListIndex := i;
End;

Procedure TMag4Viewer.Destroy_p(Proxy: TImageProxy);
Var
  VGear: TMag4VGear;
Begin
  VGear := Proxy.Image;
  Proxy.Image := Nil;
  If VGear = Nil Then
    Exit;
  If VGear.PanWindow Then
    VGear.PanWindow := False;
  VGear.ResetImage;
  VGear.Visible := False;
  vGear.SetShowImageStatus(false);       //117
  VGear.ClearImage;
  VGear.Update;
  VGear.Dicomdata.ClearFields();
    // JMW 11/10/2008 - make sure this is nil, don't want to free it though
  VGear.PI_ptrData := Nil;
    //   vGear.Free;             //  in for test xx8 p8t35

   (* VGear.Free;   // in for P93t11 testing a redesign.
    exit;  *)

  FGearPool.Add(VGear); // out for test xx8 p8t35
    //  VGear.PI_V4Data.ClearData;   // out for test xx8 p8t35
  If Not Proxy.Visible Then
    Proxy.Visible := True;
End;

Procedure TMag4Viewer.ClearViewer;
Var
  i: Integer;
  { undoItem: TmagUnDoItem;}
Begin
{debug94} MagLogger.LogMsg('s', '**--** - in TMag4Viewer.ClearViewer.' + ' Fproxylist.count: ' + Inttostr(FProxyList.Count));
  If FProxyList.Count = 0 Then
    Exit;
  UnDoGroupingNew;
  PnlTop.caption := '';
  LbPnlTop.caption := PnlTop.caption;
  Application.Processmessages;
  Update;
  Try
    Scrlv.Visible := False; // in for testing p8t34
    For i := FProxyList.Count - 1 Downto 0 Do
    Begin
      DeleteProxy(i);
      (*
      UnDoListAddItem('UnDo - Close All', TImageProxy(FProxyList[i]), magundoRemove); //ClearViewer;
      TImageProxy(FProxyList[i]).Image.Visible := false;
      FProxyList.Delete(i);
      *)
    End;
    FLoadedList.Clear;
  Finally
    {TODO:  This might need checked.  if the form is closed, maybe error.}
    Scrlv.Visible := True;
  End;
  Cur4Image := Nil;
  If Assigned(OnViewerImageClick) Then
    OnViewerImageClick(Cur4Image); // 01/21/03
  ImgStudyStatus.Visible := False;
{debug94} MagLogger.LogMsg('s', '**--** - END TMag4Viewer.ClearViewer.' + ' Fproxylist.count: ' + Inttostr(FProxyList.Count));
End;

Procedure TMag4Viewer.CalcRowColusingHW;
Var
  w, h, Scrollbarw: Integer;
Begin
  h := Scrlv.Height;
  w := Scrlv.Width;
  Scrollbarw := 20; {TODO -c5: how to calculate the ScrollBar Thumb Width ? }
  If FScrollVertical Then
    w := w - Scrollbarw
  Else
    h := h - Scrollbarw;
  FColcount := Trunc((w - FColsp) / (FbaseW + FColsp));
  If FColcount = 0 Then
    FColcount := 1;
  FRowcount := Trunc((h - FRowsp) / (FbaseH + FRowsp));
  If (FRowcount = 0) Then
    FRowcount := 1;
End;

{ Calculate the Height and Width of the Image Obj, based on FColCount,
  FRowCount and the Height and Width of the Scroll Box (parent of the Image Obj}

Procedure TMag4Viewer.CalcHWusingRowCol;
Begin
  If (FColcount = 0) Then
    FColcount := 1;
  If (FRowcount = 0) Then
    FRowcount := 1;
  If FScrollVertical Then
  Begin
    FbaseH := (Scrlv.Height - (FRowsp * FRowcount)) Div FRowcount;
    FbaseW := (Scrlv.Width - (FColsp * FColcount) - 20) Div FColcount;
  End
  Else
  Begin
    FbaseH := (Scrlv.Height - (FRowsp * FRowcount) - 20) Div FRowcount;
    FbaseW := (Scrlv.Width - (FColcount * FColsp)) Div FColcount;
  End;
    //  if not FAbsWindow then
  If FViewStyle <> MagViewerViewAbs Then
  Begin
        //1/28/03   diff := scrlv.width - (fcolcount * (FBaseW + Fcolsp));
        //1/28/03   if diff > 0 then width := width + diff;
  End;
End;

{ Calcutate the next pixel location for an Image. Based on FcurRow,Col FbaseH,W etc}

Procedure TMag4Viewer.CalcNextLeftTop;
Begin
  If Not FScrollVertical Then
  Begin
    If FcurRow = FRowcount Then
    Begin
      FcurRow := 1;
      FcurCol := FcurCol + 1;
    End
    Else
      FcurRow := FcurRow + 1;
    FnextT := (FcurRow * (FbaseH + FRowsp) - (FbaseH));
    FnextL := (FcurCol * (FbaseW + FColsp) - (FbaseW));
  End
  Else // so Must be Horizontal Scroll.
  Begin
    If FcurCol = FColcount Then
    Begin
      FcurCol := 1;
      FcurRow := FcurRow + 1;
    End
    Else
      FcurCol := FcurCol + 1;
        // next two line wern't changed.
    FnextT := (FcurRow * (FbaseH + FRowsp) - (FbaseH));
    FnextL := (FcurCol * (FbaseW + FColsp) - (FbaseW));
  End;
End;

Procedure TMag4Viewer.InitLTHW;
Begin
  FcurRow := 1;
  FcurCol := 1;

  FnextT := FRowsp;
  FnextL := FColsp;
  Try
    If FLockSize And (Not FIgnoreLockSize) Then
    Begin
      FbaseH := FLockHeight;
      FbaseW := FLockWidth;

      If FbaseH < 55 Then
        FbaseH := 55;
      If FbaseW < 40 Then
        FbaseW := 40;
            //p8t25 if abswindow then FbaseW := trunc(FbaseH * 0.75);
      CalcRowColusingHW;
    End
    Else //if not Flocksize then
    Begin
      CalcHWusingRowCol;
      If FbaseH < 55 Then
        FbaseH := 55;
      If FbaseW < 40 Then
        FbaseW := 40;
            //p8t25 if abswindow then FbaseW := trunc(FbaseH * 0.75);
    End;
  Finally
    FIgnoreLockSize := False;
  End;
End;

Procedure TMag4Viewer.SetRowColCount(r, c: Integer; ImageToDisplayIndex: Integer
  = -1);
Begin
  FColCountSaved := 0;
  FRowCountSaved := 0;
  FRowcount := r;
  FColcount := c;
  FIgnoreLockSize := True;
  Try
    Scrlv.Visible := False;
    Scrlv.Update;
    Update;
    Application.Processmessages;
    ReAlignImages(True, True, ImageToDisplayIndex);
    If FLockSize Then
    Begin
      SetLockSize(True);
    End;
  Finally
    Scrlv.Visible := True;
  End;
End;

Procedure TMag4Viewer.SelectViewerImage(Sender: Tobject);
Begin
  Begin
    TMag4VGear(Sender).Selected := Not TMag4VGear(Sender).Selected;
    If (TMag4VGear(Sender) = Cur4Image) And (TMag4VGear(Sender).Selected =
      False) Then
    Begin
      Cur4Image := Nil;
    End;
  End;
End;

Procedure TMag4Viewer.ImageVMouseDown(Sender: Tobject; Button: TMouseButton;
  Shift: TShiftState; x, y: Integer);
Var
  clpt: TPoint;
Begin
  If FIsDragAble And (Shift = [Ssleft]) Then
  Begin
    If TMag4VGear(Sender).Selected Then
    Begin
      Cur4Image := TMag4VGear(Sender);
    End
    Else
    Begin
      UnSelectAll;
      SelectViewerImage(Sender);
      Cur4Image := TMag4VGear(Sender);
    End;
        //(Sender as TMag4VGear).Begindrag(false,20);  // Begindrag problem
    Exit;
  End;
  If Button = Mbleft Then
  Begin
    If (Ssctrl In Shift) Then
      SelectViewerImage(Sender);
    If (Shift = [Ssleft]) Then
    Begin
      ImageVClick(Sender, TMag4VGear(Sender));
    End;
  End;
  If Button = Mbright Then
  Begin
    If (Shift = [Ssright]) Then
    Begin
      If TMag4VGear(Sender).Selected Then
      Begin
        Cur4Image := TMag4VGear(Sender);
      End
      Else
      Begin
        UnSelectAll;
        SelectViewerImage(Sender);
        Cur4Image := TMag4VGear(Sender);
      End;
    End;
    clpt.x := x;
    clpt.y := y;
    clpt := (Sender As TMag4VGear).ClientToScreen(clpt);
        if self.FRightClickOpen then        //117 test
                 begin
                 ImageVClick(Sender, TMag4VGear(Sender));
                 update;
                 end;
    If Assigned(FPopupMenuImage) Then
    Begin
      FPopupMenuImage.PopupComponent := (TMag4VGear(Sender));
            //          if FAbswindow then FPopupMenuImage.popup(clpt.x + 3, clpt.y + 5)
      If FViewStyle = MagViewerViewAbs Then
        FPopupMenuImage.Popup(clpt.x + 3, clpt.y + 5)
      Else
        FPopupMenuImage.Popup(clpt.x + 3, clpt.y + 15);
    End;

  End;
End;

Procedure TMag4Viewer.ImageVKeydown(Sender: Tobject; Var Key, Shift: Smallint);
//procedure Tmag4Viewer.ImageVKeydown(Sender: TObject; var Key: Word; Shift: TShiftState);
Begin
  If Key = VK_Return Then
  Begin
    ImageVClick(Sender, TMag4VGear(Sender));
    Exit;
  End;
  If Key = 33 Then //PageUp
  Begin
    PagePrevViewer;
  End;
  If Key = 34 Then //PageUp
  Begin
    PageNextViewer;
  End;
End;

Procedure TMag4Viewer.ImageVMouseUp(Sender: Tobject; Button: TMouseButton;
  Shift: TShiftState; x, y: Integer);
Var
  clpt: TPoint;
Begin
  If FIsDragAble And (Shift = [Ssleft]) Then
  Begin
    ImageVClick(Sender, TMag4VGear(Sender));
  End;
  Exit;
  If FIsDragAble Then
    (Sender As TMag4VGear).BeginDrag(False, 20);
  If Button = Mbleft Then
  Begin
    If (Ssctrl In Shift) Then
      SelectViewerImage(Sender);
    If (Shift = [Ssleft]) Then
    Begin
      ImageVClick(Sender, TMag4VGear(Sender));
    End;
  End;
  If Button = Mbright Then
  Begin
    If (Shift = [Ssright]) Then
    Begin
      If TMag4VGear(Sender).Selected Then
      Begin
        Cur4Image := TMag4VGear(Sender);
      End
      Else
      Begin
        UnSelectAll;
        SelectViewerImage(Sender);
        Cur4Image := TMag4VGear(Sender);
      End;
    End;
    clpt.x := x;
    clpt.y := y;
    clpt := (Sender As TMag4VGear).ClientToScreen(clpt);
    If Assigned(FPopupMenuImage) Then
    Begin
      FPopupMenuImage.PopupComponent := (TMag4VGear(Sender));
            //          if FAbswindow then FPopupMenuImage.popup(clpt.x + 3, clpt.y + 5)
      If FViewStyle = MagViewerViewAbs Then
        FPopupMenuImage.Popup(clpt.x + 3, clpt.y + 5)

      Else
        FPopupMenuImage.Popup(clpt.x + 3, clpt.y + 15);
    End;
  End;

End;

Procedure TMag4Viewer.UnSelectAll;
Var
  i: Integer;
  Proxy: TImageProxy;
Begin
  For i := 0 To FLoadedList.Count - 1 Do
  Begin
    Proxy := FLoadedList[i];
    If (Proxy.Image <> Nil) Then
      If (Proxy.Image.Selected) Then
        Proxy.Image.Selected := False;
  End;
End;

Procedure TMag4Viewer.ImageVClick(Sender: Tobject; VGear: TMag4VGear);
Begin
  Cur4Image := VGear;
  Cur4Image.BringToFront;
  Update;
  UnSelectAll;
    { TODO -cRedundantly Called ?: This could be redundant, have to check flow after mouse down. }
  Cur4Image.Selected := True;

  If FPanWindow Then
    SetPanWindow(FPanWindow);
  If Assigned(OnViewerImageClick) Then
    OnViewerImageClick(Cur4Image);
  If Assigned(OnViewerClick) Then
    OnViewerClick(Self, Self, Cur4Image);
  CheckButtons();
End;

Procedure TMag4Viewer.TbPageLastClick(Sender: Tobject);
Begin
  PageLastViewer;
  If Assigned(OnPageLastViewerClick) Then
    OnPageLastViewerClick(Sender);
End;

Procedure TMag4Viewer.TbPageFirstClick(Sender: Tobject);
Begin
  PageFirstViewer;
  SelectAnImage(FirstVisProxy);
  If Assigned(OnPageFirstViewerClick) Then
    OnPageFirstViewerClick(Sender);
End;

Procedure TMag4Viewer.TbPagePrevClick(Sender: Tobject);
Begin
  PagePrevViewer;
  If Assigned(OnPagePreviousViewerClick) Then
    OnPagePreviousViewerClick(Sender);
End;

Procedure TMag4Viewer.TbPageNextClick(Sender: Tobject);
Begin
  PageNextViewer;
  If Assigned(OnPageNextViewerClick) Then
    OnPageNextViewerClick(Sender);
End;

{  JMW 7/15/08 p72t23

  This function renumbers the ListIndex values for the images associated with
  the proxies. This needs to be done when an image is removed so the internal
  index matches the index in the FProxyList
 }

Procedure TMag4Viewer.RenumberIndexes();
Var
  i: Integer;
  Iproxy: TImageProxy;
Begin
  For i := 0 To FProxyList.Count - 1 Do
  Begin
    Iproxy := FProxyList[i];
    If Iproxy.Image <> Nil Then
    Begin
      Iproxy.Image.ListIndex := i;
    End;
  End;
End;

Procedure TMag4Viewer.RemoveFromList;
Var
  i: Integer;
  Iproxy: TImageProxy;
  Undotext: String;
Begin
  If GetSelectedCount = 0 Then
    Exit;
  If GetSelectedCount > 1 Then
    Undotext := 'UnDo - Remove Image(s)'
  Else
    Undotext := 'UnDo - Remove Image';
  UnDoGroupingNew; //RemoveFromList
    { not doing => if FApplytoAll then..... for RemoveFromList.
       Intent is to remove the selected, not all.
       if (SelectedCount > 0) then {}

    (* FUnDoList.add(TMagCaptionedList.create);
       TList(FUnDoList(FUnDoList.Count-1)). *)
  For i := FProxyList.Count - 1 Downto 0 Do
  Begin
    Iproxy := FProxyList[i];
    If Iproxy.Image <> Nil Then
      If TMag4VGear(Iproxy.Image).Selected Then
      Begin
        Case FViewerStyle Of
          MagvsStaticPage:
            Begin
                            // JMW 5/14/08 P72t22 - delete the proxy, not sure why
                            // wasn't deleting before...
              DeleteProxy(i);
                            //  do nothing in staticpage style
            End;
          MagvsDynamic:
            Begin
              DeleteProxy(i);
                            (*
                             UnDoListAddItem(UnDotext, TImageProxy(FProxyList[i]), magundoRemove); //ClearViewer;
                             TImageProxy(FProxyList[i]).Image.Visible := false;
                             FProxyList.Delete(i);
                             *)
            End;
          MagvsVirtual:
            Begin
                            //do nothing in magvsVirtual style
                            //  ?? HideProxy(i);
            End;
        End;
                // TMag4Vgear(Iproxy.Image).MouseZoom;
      End;
  End;
    // JMW 7/15/08 p72t23 - After the images have been deleted, the images have
    // to be re-indexed to their new values
  RenumberIndexes();

  Cur4Image := Nil;

  If Assigned(OnViewerImageClick) Then
    OnViewerImageClick(Cur4Image);
  If Assigned(OnViewerClick) Then
    OnViewerClick(Self, Self, Cur4Image);
  RefreshViewerDesc;
  CheckButtons();
End;

Procedure TMag4Viewer.ScrollToImage(ImageIndex: Integer);
Begin
    //maggmsgf.MagMsg('s', '###ScrollToImage index ' + inttostr(imageindex));
    //LogMsg('s', '###ScrollToImage index ' + inttostr(imageindex));
//p117  MagLogger.LogMsg('s', '###ScrollToImage index ' + Inttostr(ImageIndex)); {JK 10/5/2009 - MaggMsgu refactoring}
IMsgObj.Log(msglvlDEBUG,'###ScrollToImage index ' + Inttostr(ImageIndex)); //p117
  Scrlv.ScrollInView(TImageProxy(FProxyList[ImageIndex]));
End;

Procedure TMag4Viewer.VisibleRowCol(Var Row, Col: Integer);
Begin
  Row := RowCount;
  Col := ColumnCount;
  Exit;
    (*    for now we'll return RowCount, and ColumnCount
          we will probably need the functionality below, if a user resizes a
          window, and doesn't ReAlignImages, they will *)
      (*
        if I3ptrList.count = 0 then
        begin
          row := 1;
          col := 1;
          exit;
        end;
        Limg := I3ptrList[0];
        tw := Limg.width;
        th := Limg.height;

        Col := trunc((width - FColsp) / (tw + FColsp));
        if (Col = 0) then Col := 1;
        Row := Trunc((height - FRowsp) / (th + FRowsp));
        if (Row = 0) then Row := 1;
      *)
End;

Function TMag4Viewer.VisibleCount: Integer;
Var
  across, Down: Integer;
Begin
  VisibleRowCol(Down, across);
  Result := across * Down;
End;

Function TMag4Viewer.VisibleCountActual: Integer;
Var
  Halfw, i: Integer;
Begin
  Halfw := FbaseW Div 2;
  Result := 0;
  For i := 0 To FProxyList.Count - 1 Do
  Begin
    If ((TImageProxy(FProxyList[i]).Left + Halfw) > Scrlv.Left)
      And ((TImageProxy(FProxyList[i]).Left + Halfw) < (Scrlv.Width)) Then
      Result := Result + 1;
        {TODO -cVertScroll: IF NOT FScrollVertical needs to be here }
  End;
End;

Procedure TMag4Viewer.FrameEndDock(Sender, Target: Tobject; x, y: Integer);
Begin
    // Still might consider this, but it happens each time a floating window is moved.
    //   The ReAlignImages does a realign also, ( maybe take out the realign features of the
    //   ReAlignImages function, make them two functions.  and this button could be a realign
    //    which does a ReAlignImages also.
    //ReAlignImages;
End;

{
procedure TMag4Viewer.SetAbsWindow(const Value: Boolean);
begin
  FAbsWindow := Value;
  if FAbsWindow then
    begin
      FViewerDesc := ' Abstracts.';
      tbColumnBigger.Visible := false;
      tbColumnSmaller.Visible := false;
      tbRowBigger.visible := false;
      tbRowSmaller.visible := false;
      tbPageLast.visible := false;
      tbpageFirst.visible := false;
      tbPageNext.visible := false;
      tbpagePrev.visible := false;
      tbClear.visible := false;
      //tbConfig.Visible := false;

      tbtnAbsPagePrev.visible := true;
      tbtnAbsPageNext.visible := true;
      tbtnAbsSmaller.visible := true;
      tbtnAbsBigger.visible := true;
    end
  else
    begin
      FViewerDesc := ' Images.';
      // 01/06/03 Patch 8   Ruth - simplify things, Don't show toolbar
      tbViewer.Visible := false;
    end;
end;
}

(*
procedure TMag4Viewer.ViewerInfo;
var s: string;
begin
  s := '';
  if scrlv.HorzScrollBar.Tracking then s := s + '  horiz track = true';
  if scrlv.VertScrollBar.Tracking then s := s + ' Vert track = true';
  if showhint then s := s + '  showhint = true';
  if cur4image = nil then s := s + '  cur4image = nil';
  if maxedImage = nil then s := s + '  maxedImage = nil';

  if FZoomWindow then s := s + ' FZoomWindow = true';
  if FPanWindow then s := s + '  FPanWindow = true';
  if showhint then s := s + '  showhint = true';
  if dragmode = dmautomatic then s := s + '  dragmode = dmAutomatic';
  //Cur4Image := nil;
 //maxedImage  := nil;
 //FZoomWindow := false;
 //FPanWindow := false;

// if FColsp < 5 then FColsp := 5;
// if FRowsp < 5 then FRowsp := 5;
// if FRowCount < 1 then FRowCount := 1;
// if FColCount < 1 then FColCount := 1;
// if FMaxCount < 1 then FMaxCount := 1;
  s := s + '  FColSp ' + inttostr(FColSp);
  s := s + '  FRowsp ' + inttostr(FRowsp);
  s := s + '  FRowCount ' + inttostr(FRowCount);
  s := s + '  FColCount ' + inttostr(FColCount);
  s := s + '  FMaxCount ' + inttostr(FMaxCount);

  showmessage(s);
end; *)

Procedure TMag4Viewer.SetRowSpacing(Const Value: Integer);
Begin
  FRowsp := Value;
  If FRowsp < 1 Then
    FRowsp := 1;
End;

Procedure TMag4Viewer.SetColumnSpacing(Const Value: Integer);
Begin
  FColsp := Value;
  If FColsp < 1 Then
    FColsp := 1;
End;

Procedure TMag4Viewer.SetColumnCount(Const Value: Integer);
Begin
  If Value < 1 Then
    FColcount := 1
  Else
    FColcount := Value;
End;

Procedure TMag4Viewer.SetRowCount(Const Value: Integer);
Begin
  If Value < 1 Then
    FRowcount := 1
  Else
    FRowcount := Value;
End;

Procedure TMag4Viewer.UpDate_(SubjectState: String; Sender: Tobject);
Var
  nm: String;
Begin
  nm := Self.Name;
{debug94}
  MagLogger.LogMsg('s', '**--** - in TMag4Viewer.UpDate_. ' + 'Name : ' + nm);
  MagLogger.LogMsg('s', '**--** - in TMag4Viewer.UpDate_. ' + ' SubjectState: ' + SubjectState);
  ClearViewer;
  If (SubjectState = '') Then
    Exit; //IMagSubject is cleared.
  If Copy(SubjectState, 1, 1) = '0' Then
    Exit; //workaround bug.
  If (SubjectState = '-1') Then
    FMagImageList := Nil; //IMagSubject is freed.
  {   TODO -cSpeed:   to Speed up the loading , displaying of abstracts , and images.  Load so many, then load the rest.}
  If FMagImageList <> Nil Then
    ImagesToMagView(FMagImageList.ObjList); //update
  CheckButtons();
{debug94} MagLogger.LogMsg('s', '**--** - END TMag4Viewer.UpDate_. ' + ' SubjectState: ' + SubjectState);
End;

Procedure TMag4Viewer.SetMagImageList(Const Value: TMagImageList);
Begin
  If (FMagImageList <> Nil) Then
    FMagImageList.Detach_(IMagObserver(Self));
  FMagImageList := Value;
  If Value <> Nil Then
    AttachMyself();
End;

Procedure TMag4Viewer.AttachMyself;
Begin
{debug94} MagLogger.LogMsg('s', '**--** - TMag4Viewer.AttachMyself ');
  If Assigned(FMagImageList) Then
  Begin
    FMagImageList.Attach_(IMagObserver(Self));
  End;
End;

Procedure TMag4Viewer.ViewDirectoryImages(t: TStrings);
Var
  Dirlist: Tlist;
Begin
  Dirlist := FUtils.DirImagesToObjList(t);
  Try
    ImagesToMagView(Dirlist);
  Finally
    Dirlist.Free;
  End;
End;

Procedure TMag4Viewer.PnlTopDragOver(Sender, Source: Tobject; x,
  y: Integer; State: TDragState; Var Accept: Boolean);
Begin
  DragItOver(Sender, Source, x, y, State, Accept);
End;

Procedure TMag4Viewer.PnlTopDragDrop(Sender, Source: Tobject; x, y: Integer);
Begin
  DropItOn(Sender, Source, x, y);
End;

Procedure TMag4Viewer.SetViewerStyle(Const Value: TMagViewerStyles);
Begin
  FViewerStyle := Value;
  Case FViewerStyle Of
    MagvsStaticPage:
      Begin
                {
                // JMW 5/14/08 p72t22 - don't want these to be visible in the Rad viewer
                lbHideScroll.visible := true;
                lbHideScroll.BringToFront;
                }
      End;
    MagvsDynamic:
      Begin

      End;
    MagvsVirtual:
      Begin
        LbHideScroll.Visible := False;
                // what if we were comming from a magvsDynamic.
        ReAlignImages; // will this do it.
      End;
  End;
End;

Procedure TMag4Viewer.ToggleSelected;
Var
  i: Integer;
  Iproxy: TImageProxy;
Begin
  For i := 0 To FProxyList.Count - 1 Do
  Begin
    Iproxy := FProxyList[i];
    If Iproxy.Image <> Nil Then
      TMag4VGear(Iproxy.Image).Selected := Not
        TMag4VGear(Iproxy.Image).Selected;
  End;
End;

Procedure TMag4Viewer.TbClearClick(Sender: Tobject);
Begin
  ClearViewer;
End;

Procedure TMag4Viewer.TbRefreshClick(Sender: Tobject);
Begin
  LoadProxyImages(FirstVisProxy); {**  tbRefreshClick **}
  ReFreshImages;
End;

(*procedure TMag4Viewer.tbRowSmallerClick(Sender: TObject);
begin
  SetRowColCount(FRowcount - 1, FColCount);
end;

procedure TMag4Viewer.tbRowBiggerClick(Sender: TObject);
begin
  SetRowColCount(FRowcount + 1, FColCount);
end;

procedure TMag4Viewer.tbColumnBiggerClick(Sender: TObject);
begin
  SetRowColCount(FRowcount, FColCount + 1);
end;

procedure TMag4Viewer.tbColumnSmallerClick(Sender: TObject);
begin
  SetRowColCount(FRowcount, FColCount - 1);
end;  *)

Procedure TMag4Viewer.TbConfigClick(Sender: Tobject);
Begin
  EditViewerSettings;
End;

Procedure TMag4Viewer.EditViewerSettings;
Begin
  RowColSize.Execute(Self);
End;

Procedure TMag4Viewer.ScrollToImage(IObj: TImageData);
Var
  i: Integer;
  Proxy: TImageProxy;
Begin
  For i := 0 To FProxyList.Count - 1 Do
  Begin
    Proxy := FProxyList[i];
    If Proxy.ImageData.Mag0 = IObj.Mag0 Then
    Begin
      Scrlv.ScrollInView(Proxy);
      Break;
    End;
  End;
End;

Function TMag4Viewer.GetCurrentImage: TMag4VGear;
Begin
  Result := Cur4Image;
End;

Function TMag4Viewer.GetCurrentImageObject: TImageData;
Begin
  If Cur4Image = Nil Then
    Result := Nil
  Else
    Result := Cur4Image.PI_ptrData;
End;

Procedure TMag4Viewer.ImageCopy;
Var
  Stat: Boolean;
  Xmsg: String;
Begin
  If Not Assigned(FMagUtilsDB) Then
  Begin
    Messagedlg('DataBase Utilities are not linked (cmagUtilsDB)', MtWarning,
      [Mbok], 0);
    Exit;
  End;
  If Not Assigned(Cur4Image) Then
  Begin
    Messagedlg('There are no selected images.', Mtconfirmation, [Mbok], 0);
    Exit;
  End;
  FMagUtilsDB.ImageCopy(Cur4Image, Stat, Xmsg);
End;

Procedure TMag4Viewer.ImagePrint;
Var
  Stat: Boolean;
  Xmsg: String;
Begin
  If Not Assigned(FMagUtilsDB) Then
  Begin
    Messagedlg('DataBase Utilities are not linked (cmagUtilsDB)', MtWarning,
      [Mbok], 0);
    Exit;
  End;
  If Not Assigned(Cur4Image) Then
  Begin
    Messagedlg('There are no selected images.', Mtconfirmation, [Mbok], 0);
    Exit;
  End;

  FMagUtilsDB.ImagePrint(Cur4Image, Stat, Xmsg);
End;

Procedure TMag4Viewer.ImageReport;
Var
  Stat: Boolean;
  Xmsg: String;
Begin
  If Not Assigned(FMagUtilsDB) Then
  Begin
    Messagedlg('DataBase Utilities are not linked (cmagUtilsDB)', MtWarning,
      [Mbok], 0);
    Exit;
  End;
  If Not Assigned(Cur4Image) Then
  Begin
    Messagedlg('There are no selected images.', Mtconfirmation, [Mbok], 0);
    Exit;
  End;
  FMagUtilsDB.ImageReport(Cur4Image.PI_ptrData, Stat, Xmsg);
End;

Procedure TMag4Viewer.SetMagUtilsDB(Const Value: TMagUtilsDB);
Begin
  FMagUtilsDB := Value;
End;

Procedure TMag4Viewer.MnuToolbarClick(Sender: Tobject);
Begin
  MnuToolbar.Checked := Not MnuToolbar.Checked;
  TbViewer.Visible := MnuToolbar.Checked;
End;

Procedure TMag4Viewer.AlignonTop1Click(Sender: Tobject);
Begin
  TbViewer.Align := altop;
End;

Procedure TMag4Viewer.AligntoLeft1Click(Sender: Tobject);
Begin
  TbViewer.Align := alLeft;
End;

Function TMag4Viewer.GetImagePage: Integer;
Begin
  If Cur4Image = Nil Then
    Result := 0
  Else
    Result := Cur4Image.Page;
End;

Function TMag4Viewer.GetImagePageCount: Integer;
Begin
  If Cur4Image = Nil Then
    Result := 0
  Else
    Result := Cur4Image.PageCount;
End;

Procedure TMag4Viewer.SetImagePage(Const Value: Integer);
Begin
  If Cur4Image = Nil Then
    Exit;
  If (Value > GetImagePageCount) Then
    Cur4Image.Page := GetImagePageCount
  Else
    If (Value < 1) Then
      Cur4Image.Page := 1
    Else
      Cur4Image.Page := Value;
End;

Procedure TMag4Viewer.SetImagePageUseApplyToAll(Const Value: Integer);
Var
  i: Integer;
  Iproxy: TImageProxy;
Begin
  If FApplytoall Then
    For i := 0 To FProxyList.Count - 1 Do
    Begin
      Iproxy := FProxyList[i];
      If Iproxy.Image <> Nil Then
        TMag4VGear(Iproxy.Image).Page := Value;
    End
  Else
    For i := 0 To FProxyList.Count - 1 Do
    Begin
      Iproxy := FProxyList[i];
      If Iproxy.Image <> Nil Then
        If TMag4VGear(Iproxy.Image).Selected Then
          TMag4VGear(Iproxy.Image).Page := Value;
    End;
End;

Procedure TMag4Viewer.SetImagePageCount(Const Value: Integer);
Begin
    //
End;

Function TMag4Viewer.GetImageCount: Integer;
Begin
  Result := FProxyList.Count;
End;

Function TMag4Viewer.GetImageObjectList: Tlist;
Var
  Objectlist: Tlist;
Var
  i: Integer;
Begin
  Objectlist := Tlist.Create;
  Try
    For i := 0 To FProxyList.Count - 1 Do
    Begin
      Objectlist.Add(TImageProxy(FProxyList[i]).ImageData);
    End;
    Result := Objectlist;
  Finally
        // can't free it here, dummy
        //  objectlist.free;
  End;
End;

Function TMag4Viewer.GetSelectedCount: Integer;
Var
  i: Integer;
Begin
  Result := 0;
  For i := 0 To FProxyList.Count - 1 Do
    If ((TMag4VGear(TImageProxy(FProxyList[i]).Image) <> Nil)
      And TMag4VGear(TImageProxy(FProxyList[i]).Image).Selected) Then
      Result := Result + 1;
End;

Function TMag4Viewer.GetSelectedImageList: Tlist;
Var
  Selectlist: Tlist;
Var
  i: Integer;
Begin
  Selectlist := Tlist.Create;
  Try
    For i := 0 To FProxyList.Count - 1 Do
      If (TMag4VGear(TImageProxy(FProxyList[i]).Image) <> Nil) Then
      Begin
        If TMag4VGear(TImageProxy(FProxyList[i]).Image).Selected Then
          Selectlist.Add(TImageProxy(FProxyList[i]).ImageData);
                //          if TMag4VGear(TImageProxy(Fproxylist[i]).image).selected then selectlist.add(TImageProxy(Fproxylist[i]).CurrentImageData);

                    //TMag4Vgear(Iproxy.Image).selected
      End;
    Result := Selectlist;
  Finally
        // can't free it here, dummy
        //  selectlist.free;
  End;
End;

Procedure TMag4Viewer.SetViewerDesc(Desc: String; Descvis: Boolean);
Begin
  If FViewStyle = MagViewerViewRadiology Then
  Begin
    FRadStudyDescription := Desc;
  End
  Else
  Begin
    PnlTop.caption := Desc;
    LbPnlTop.caption := PnlTop.caption;
        //if pnltop.Visible <> descvis then pnltop.visible := descvis;
    If TopPanel.Visible <> Descvis Then
      TopPanel.Visible := Descvis;

  End;
End;

Function TMag4Viewer.GetDescVisible: Boolean;
Begin
    //  result := pnltop.Visible;
  Result := TopPanel.Visible;
End;

Procedure TMag4Viewer.SetDescVisible(Const Value: Boolean);
Begin
    //  pnltop.visible := value;
  TopPanel.Visible := Value;
End;

Procedure TMag4Viewer.PageFirstViewer(SetSelected: Boolean = True);
Var
  State: TMagImageState;
Begin
    {
    scrlV.HorzScrollBar.position := 0;
    scrlv.VertScrollBar.Position := 0;
    LoadProxyImages(FirstVisProxy);             //is in a Comment
    SelectAnImage(firstVisProxy); // JMW 5/31/2006 p72 this was commented out, why?
    }
    // JMW 10/18/2006 p72
  State := Cur4Image.GetState;
    // JMW 7/14/2006 p72 - seems to work better, had problem viewing last image in study
  //  ScrollAndDisplayImage(0);
    // JMW 10/18/2006 - P72 changed to ShowImage() - loads surrounding images around selected image
  ShowImage(0);
  ApplyStateFromSelectedImage(State);
End;

Procedure TMag4Viewer.PageLastViewer(SetSelected: Boolean = True);
Var
  State: TMagImageState;
Begin
    {
      scrlV.HorzScrollBar.position := scrlV.HorzScrollBar.Range;
      scrlv.VertScrollBar.Position := scrlv.VertScrollBar.Range;
      LoadProxyImages(FirstVisProxy);    //is in a Comment
      SelectAnImage(firstVisProxy); // JMW 5/31/2006 p72 this was commented out, why?
      }

      // JMW 10/18/2006 p72
      // get/apply state based on user setting
  State := Cur4Image.GetState;
    // JMW 7/14/2006 p72 - seems to work better, had problem viewing last image in study
    //ScrollAndDisplayImage(FProxyList.Count - 1);
    // JMW 10/18/2006 - P72 changed to ShowImage() - loads surrounding images around selected image
  ShowImage(FProxyList.Count - 1);

  ApplyStateFromSelectedImage(State);
End;

Procedure TMag4Viewer.PageNextViewer(SetSelected: Boolean = True);
Var
  Trow, Tcol: Integer;
  VisProxy: Integer;
  Win, Lev: Integer;
  State: TMagImageState;
Begin
  Win := Cur4Image.GetState.WinValue;
  Lev := Cur4Image.GetState.LevValue;
  State := Cur4Image.GetState;

  VisibleRowCol(Trow, Tcol);

    (*

    if ((scrlV.HorzScrollBar.Range - Scrlv.width) > scrlV.HorzScrollBar.position) then
      begin
        scrlV.HorzScrollBar.position := scrlV.HorzScrollBar.position + (Tcol * (FbaseW + Fcolsp)); {width;}
      {HorzScrollBar.position := HorzScrollBar.position  + width;}
      end;
    if ((scrlV.VertScrollBar.Range - Scrlv.height) > scrlV.VertScrollBar.position) then
      begin
        scrlV.VertScrollBar.position := scrlV.VertScrollBar.position + scrlV.height; {width;}
      {HorzScrollBar.position := HorzScrollBar.position  + width;}
      end;
    *)
  VisProxy := Cur4Image.ListIndex; // FirstVisProxy();
  VisProxy := VisProxy + Tcol; //(trow * tcol);
  If (VisProxy >= FProxyList.Count) Then
    VisProxy := FProxyList.Count - 1;
  ShowImage(VisProxy);
  ApplyStateFromSelectedImage(State);
    //  WinLevFromSelectedImage(win, lev);
      (*

      LoadProxyImages(visProxy);       //is in a Comment
    //  LoadProxyImages(firstVisProxy);     //is in a Comment
    //  SelectAnImage(firstVisProxy); // JMW 5/31/2006 p72 this was commented out, why?
      SelectAnImage(visProxy);
      WinLevFromSelectedImage(win, lev);
      *)
      {
      // not as effective for scrolling, caused images to be skipped
      // JMW 7/14/2006 p72
      // use scrollandDisplayImage because it eliminates flashing when switching between images
      if (Cur4Image.ListIndex + 1) >= FProxyList.Count then exit;
      ScrollAndDisplayImage(Cur4Image.ListIndex + 1);
      }
End;

Procedure TMag4Viewer.PagePrevViewer(SetSelected: Boolean = True);
Var
  VisProxy: Integer;
  Win, Lev: Integer;
  State: TMagImageState;
Begin
    (*
    if (scrlV.HorzScrollBar.position <> 0) then
      begin
      //scrlV.HorzScrollBar.position := scrlV.HorzScrollBar.position + (Tcol * (FbaseW + Fcolsp)); {width;}
        scrlV.HorzScrollBar.position := scrlV.HorzScrollBar.position - scrlv.width;
      end;
    if (scrlV.VertScrollBar.position <> 0) then
      begin
      //scrlV.HorzScrollBar.position := scrlV.HorzScrollBar.position + (Tcol * (FbaseW + Fcolsp)); {width;}
        scrlV.VertScrollBar.position := scrlV.VertScrollBar.position - scrlv.height;
      end;
    visProxy := FirstVisProxy();
    LoadProxyImages(visProxy);          //is in a Comment
    //LoadProxyImages(FirstVisProxy);   //is in a Comment
    //SelectAnImage(firstVisProxy); // JMW 5/31/2006 p72 this was commented out, why?
    SelectAnImage(visProxy);
    {
    // not as effective for scrolling, caused images to be skipped
    // JMW 7/14/2006 p72
    // use scrollandDisplayImage because it eliminates flashing when switching between images
    if (Cur4Image.ListIndex - 1) < 0 then exit;
    ScrollAndDisplayImage(Cur4Image.ListIndex - 1);
    }
    *)

  Win := Cur4Image.GetState.WinValue;
  Lev := Cur4Image.GetState.LevValue;
  State := Cur4Image.GetState;
  VisProxy := Cur4Image.ListIndex; // FirstVisProxy();
  VisProxy := VisProxy - ColumnCount; //(RowCount * ColumnCount);
  If (VisProxy < 0) Then
    VisProxy := 0;
  ShowImage(VisProxy);
    //  WinLevFromSelectedImage(win, lev);
  ApplyStateFromSelectedImage(State);

End;

Procedure TMag4Viewer.ApplyStateFromSelectedImage(State: TMagImageState);
Var
  TmpApplyAll: Boolean;
Begin
  If (FViewStyle <> MagViewerViewRadiology)
    Or (FWindowLevelSettings <> MagWinLevFromCurrentImage) Then
    Exit;

  TmpApplyAll := FApplytoall;
  FApplytoall := True;
  If State.WinLevEnabled Then
  Begin
    WinLevValue(State.WinValue, State.LevValue);
  End
  Else
  Begin
    BrightnessContrastValue(State.BrightnessValue, State.ContrastValue);
  End;
  FApplytoall := TmpApplyAll;
End;

Procedure TMag4Viewer.TbtnAbsPagePrevClick(Sender: Tobject);
Begin
  PagePrevViewerFocus;
End;

Procedure TMag4Viewer.TbtnAbsPageNextClick(Sender: Tobject);
Begin
  PageNextViewerFocus;
End;

Procedure TMag4Viewer.PagePrevViewerFocus;
Begin
  PagePrevViewer;
  LoadProxyImages(FirstVisProxy); {*** PagePrevViewerFocus *}
  UpdateToolButtons;
    //    ReAlignImages;
  //  ReFreshImages;
End;

Procedure TMag4Viewer.PageNextViewerFocus;
Begin
  PageNextViewer;
  LoadProxyImages(FirstVisProxy); {*** PageNextViewerFocus **}
  UpdateToolButtons;
    //    ReAlignImages;
    //  ReFreshImages;
End;

Procedure TMag4Viewer.TbtnAbsSmallerClick(Sender: Tobject);
Begin
  SetAbsSmaller;
End;

Procedure TMag4Viewer.SetAbsSmaller;
Var
  h, w: Integer;
Begin
    //if FAbsWindow then
  If FViewStyle = MagViewerViewAbs Then
  Begin
    h := Trunc(FbaseH * 0.9);
    w := Trunc(FbaseW * 0.9);
    FLockHeight := h;
    FbaseH := h;
    FbaseW := w;
    FLockWidth := w;
    CalcRowColusingHW;
        {TODO: this needs changed to ReAlignImages}
    RealignProxy; // tbtnAbsSmallerClick
  End
  Else
    SetRowColCount(FRowcount + 1, FColcount + 1);
  UpdateToolButtons;
End;

Procedure TMag4Viewer.TbtnAbsBiggerClick(Sender: Tobject);
Begin
  SetAbsBigger;
End;

Procedure TMag4Viewer.SetAbsBigger;
Var
  h, w: Integer;
  Okay: Boolean;
Begin
    //  if FAbsWindow then
  If FViewStyle = MagViewerViewAbs Then
  Begin
    h := Trunc(FbaseH * 1.1);
    w := Trunc(FbaseW * 1.1);
        (*  don't restrict users '+' or '-'
        if FScrollVertical
          then Okay := ((H < (scrlv.Height)) and (w < scrlv.Width - 20))
        else Okay := ((H < (scrlv.Height - 20)) and (w < scrlv.Width)); *)
    Okay := True;

    If Okay Then
    Begin
      FLockHeight := h;
      FbaseH := h;
      FbaseW := w;
      FLockWidth := w;
      CalcRowColusingHW;
            {TODO: this needs changed to ReAlignImages}
      RealignProxy; // tbtnAbsBiggerClick
    End;
  End
  Else
    SetRowColCount(FRowcount - 1, FColcount - 1);
  UpdateToolButtons;
End;

Procedure TMag4Viewer.SetDefaultLayout(Rows, Cols, MaxImages: Integer; LockSize: Boolean; FitMeth: Integer = 0);
Begin
  DefaultLayout.Rows := Rows;
  DefaultLayout.Columns := Cols;
  DefaultLayout.MaxNumberOfImages := MaxImages;
  DefaultLayout.LockImageState := LockSize;
  DefaultLayout.FitMethod := FitMeth;
End;

Procedure TMag4Viewer.ApplyDefaultLayout;
Begin
    {ReAlignImages, with new rows and columns, and then LockSize if needed.}
  LockSize := False;

  RowCount := DefaultLayout.Rows;
  ColumnCount := DefaultLayout.Columns;
  MaxCount := DefaultLayout.MaxNumberOfImages;
  FLastFit := DefaultLayout.FitMethod;
  ReAlignImages;
  LockSize := DefaultLayout.LockImageState;
End;

Function TMag4Viewer.GetDefaultLayoutDesc(): String;
Begin
  Result := Inttostr(DefaultLayout.Rows) + 'x' +
    Inttostr(DefaultLayout.Columns)
    + ' max: ' + Inttostr(DefaultLayout.MaxNumberOfImages);
  If DefaultLayout.LockImageState Then
    Result := Result + ' size is locked';
End;

Procedure TMag4Viewer.SetShowToolbar(Const Value: Boolean);
Begin
  FShowToolbar := Value;
  TbViewer.Visible := FShowToolbar;
End;

Function TMag4Viewer.GetImageFontSize: Integer;
Begin
  Result := FFontSize;
End;

Procedure TMag4Viewer.SetImageFontSize(Const Value: Integer);
Var
  i: Integer;
  Iproxy: TImageProxy;
Begin
  FFontSize := Value;
  For i := 0 To FProxyList.Count - 1 Do
  Begin
    Iproxy := FProxyList[i];
    If Iproxy.Image <> Nil Then
      TMag4VGear(Iproxy.Image).FontSize := Value;
  End;

End;
(*
procedure TMag4Viewer.SyncWithIMage(Iobj: TimageData)
var
    pidx: integer;
begin
    pidx := IsDuplicate(Iobj);
    if pidx = -1 then
    begin
        UnSelectAll;
        Exit;
    end;
    ScrollAndDisplayImage(pidx);
    LoadProxyImages; {** SyncWithImage **}

end;
  *)

Procedure TMag4Viewer.SyncWithIMage(IObj: TImageData; synconGroup: Boolean = True);
Var
  proxyidx: Integer;
  sync1ien, sync2ien: String;
  Found: Boolean;
Begin
  Found := False;
  If synconGroup Then
    sync1ien := IObj.SyncIENG
  Else
    sync1ien := IObj.SyncIEN;
  For proxyidx := 0 To FProxyList.Count - 1 Do
  Begin
    sync2ien := TImageProxy(FProxyList[proxyidx]).ImageData.SyncIEN;
    If sync2ien = sync1ien Then
    Begin
      ScrollAndDisplayImage(proxyidx);
      LoadProxyImages; {** SyncWithImage **}
      Found := True;
      Break;
    End;

  End;
  If Not Found Then
    Self.UnSelectAll;
End;

Procedure TMag4Viewer.PopupViewerPopup(Sender: Tobject);
Begin
  MnuToolbar.Checked := TbViewer.Visible;
    //prototype ViewerScrollVert  mnuScrollVertical.Checked := FScrollVertical;
    //prototype ViewerScrollVert  mnuScrollHoriz.checked := Not FScrollVertical;
    //prototype ViewerScrollVert  - ALSO need to make the menu options visible. (toolbar menu)
End;

Procedure TMag4Viewer.ScrlVDragOver(Sender, Source: Tobject; x, y: Integer;
  State: TDragState; Var Accept: Boolean);
Begin
    //future
  If (IsDragObject(Source)) Or (Source Is TMag4VGear) Then
    Accept := True;
End;

Procedure TMag4Viewer.ScrlVDragDrop(Sender, Source: Tobject; x,
  y: Integer);
Var
  V4Viewer: TMag4Viewer;
Begin
    // showmessage('Sender : ' + (sender as TObject).ClassName + #13 + 'Source : ' +(source as TObject).ClassName);
  If IsDragObject(Source) Then
  Begin
    FImageDropped := True;
    ImagesToMagView((Source As TmagDragImageObject).DraggedImages);
        // onEndDrag isn't being fired.
        //Tmag4vgear(source).enddrag(true); this doesn't do it, and defeats the purpose.
    Exit;
  End;
  If Source Is TMag4VGear Then
    If TMag4VGear(Source).FParentViewer <> Nil Then
    Begin
      V4Viewer := TMag4Viewer(TMag4VGear(Source).FParentViewer);
      FImageDropped := True;
      ImagesToMagView(V4Viewer.GetSelectedImageList);
    End;

    //worked if source is TMag4VGear then
    //worked begin
    //worked t := tlist.create;
    //worked t.add((source as TMag4VGear).PI_ptrData);
    //worked FImageDropped := true;
    //worked ImagesToMagView(t);
    //worked t.free;
    //worked end;

End;

(*
procedure TMag4Viewer.LevelValue(Value: integer);
begin
//
end;
*)

Procedure TMag4Viewer.ShowHints(Value: Boolean);
Var
  i: Integer;
  Iproxy: TImageProxy;
Begin
    //if FApplytoAll then
  FShowHints := Value;
  For i := 0 To FProxyList.Count - 1 Do
  Begin
    Iproxy := FProxyList[i];
    If Iproxy.Image <> Nil Then
      TMag4VGear(Iproxy.Image).ShowHint(Value);
  End
End;

Procedure TMag4Viewer.ScrlvEndScroll(Sender: Tobject);
Begin
  StopLoadingImages := True;
  UpdateToolButtons; // updates the NextPrev page buttons.
  If GetDescVisible Then
    RefreshViewerDesc;
  If FUseAutoReAlign Then
    LoadProxyImages(FirstVisProxy); {*** ScrlvEndScroll ***}
End;

Procedure TMag4Viewer.ScrlvScrollHorz(Sender: Tobject); {   Event OnScrollHorz : }
Begin
  If (Scrlv.HorzDelta <> 0) Then
    FScrollUp := (Scrlv.HorzDelta > 0);
    //-- timerViewer.enabled := false;
  StopLoadingImages := True;
  Application.Processmessages;
    {   updates the NextPrev page buttons.}
  UpdateToolButtons;
  If GetDescVisible Then
    RefreshViewerDesc;
    //--  timerViewer.enabled := true;
    {// ReAlignImages  //ReFreshImages; - This is being done in the OnEndScroll Event. }
End;

Procedure TMag4Viewer.ScrlvScrollVert(Sender: Tobject); {   Event OnScrollVert : }
Begin
  If (Scrlv.VertDelta <> 0) Then
    FScrollUp := (Scrlv.VertDelta > 0);
    //--  timerViewer.enabled := false;
  StopLoadingImages := True;
  Application.Processmessages;
  UpdateToolButtons;
  If GetDescVisible Then
    RefreshViewerDesc;
    //--  timerViewer.enabled := true;
    {// ReAlignImages  //ReFreshImages;  - This is being done in the OnEndScroll Event. }
End;

Procedure TMag4Viewer.MnuScrollVerticalClick(Sender: Tobject);
Begin
  MnuScrollVertical.Checked := Not MnuScrollVertical.Checked;
  ScrollVertical := MnuScrollVertical.Checked;
  ReAlignImages;
End;

Procedure TMag4Viewer.MnuScrollHorzClick(Sender: Tobject);
Begin
  MnuScrollHorz.Checked := Not MnuScrollHorz.Checked;
  ScrollVertical := MnuScrollVertical.Checked;
  ReAlignImages;
End;

Procedure TMag4Viewer.TimerViewerTimer(Sender: Tobject);
Begin
    // In 93 we determined that this timer was never used.
    (*
    showmessage('Viewer Timer');

    { TimerViewerTimer is called when user scrolls with the
       MagEventScrool component.  (Robert's component) {}
    timerViewer.Enabled := false;
    application.processmessages;
    // UseAutoRealign is a global variable, needs to be a property
    //  of the Component.  Not Application.
     { TODO : Change UseAutoRealign into a property of the component }
    if FUseAutoRealign then
        LoadProxyImages(FirstVisProxy); {*** timerViewerTimer ***}
         *)
End;

Function TMag4Viewer.ViewerScrollAtEnd: Boolean;
Begin
  If Not FScrollVertical Then
    Result := Not ((Scrlv.HorzScrollBar.Visible) And
      ((Scrlv.HorzScrollBar.Position + Scrlv.Width) <
      Scrlv.HorzScrollBar.Range))
  Else
    Result := Not ((Scrlv.VertScrollBar.Visible) And
      ((Scrlv.VertScrollBar.Position + Scrlv.Height) <
      Scrlv.VertScrollBar.Range));
End;

Function TMag4Viewer.ViewerScrollAtStart: Boolean;
Begin
  If Not FScrollVertical Then
    Result := Not ((Scrlv.HorzScrollBar.Visible) And
      (Scrlv.HorzScrollBar.Position > 0))
  Else
    Result := Not ((Scrlv.VertScrollBar.Visible) And
      (Scrlv.VertScrollBar.Position > 0));
End;

Function TMag4Viewer.GetLastFitDescription(): String;
Begin
  Case Self.FLastFit Of
    IG_DISPLAY_FIT_TO_WINDOW: Result := 'Fit to Window'; // = 0;
    IG_DISPLAY_FIT_TO_WIDTH: Result := 'Fit to Width'; //= 1;
    IG_DISPLAY_FIT_TO_HEIGHT: Result := 'Fit to Height'; //= 2;
    IG_DISPLAY_FIT_1_TO_1: Result := 'Fit 1 to 1'; //= 3;
  Else
    Result := 'Unknown';
  End;
End;

(*    *********   Operations passed to TMag4VGear  *********      *)
(*    *********                                    *********      *)

{TODO: all the For... looping in each method, needs replaced with a
   call to a method with procedure parameters.  That way we only need
   to write the For...loop once. }

Procedure TMag4Viewer.FitToWindow;
Var
  i: Integer;
  Iproxy: TImageProxy;
Begin
    { TODO :
  Need to rethink this.  Could just do the currently opened (FLoadedList) images,
  then when a new image is opened, apply state of current image to the new image
  ( if ApplyToAll is still true }
  FLastFit := IG_DISPLAY_FIT_TO_WINDOW;
  If FApplytoall Then
    For i := 0 To FProxyList.Count - 1 Do
    Begin
      Iproxy := FProxyList[i];
      If Iproxy.Image <> Nil Then
        TMag4VGear(Iproxy.Image).FitToWindow
    End

  Else //if (SelectedCount > 0) then
    For i := 0 To FProxyList.Count - 1 Do
    Begin
      Iproxy := FProxyList[i];
      If Iproxy.Image <> Nil Then
        If TMag4VGear(Iproxy.Image).Selected Then
          TMag4VGear(Iproxy.Image).FitToWindow
    End;
    // else if Cur4Image <> nil then Cur4Image.fittoheight;
End;

Procedure TMag4Viewer.Fit1to1;
Var
  i: Integer;
  Iproxy: TImageProxy;
    //  vGear: TMag4vGear;
Begin
  FLastFit := IG_DISPLAY_FIT_1_TO_1;
  If FApplytoall Then
        // for i := 0 to I3ptrList.count - 1 do TMag4Vgear(I3PtrList[i]).fittoheight
    For i := 0 To FProxyList.Count - 1 Do
    Begin
      Iproxy := FProxyList[i];
      If Iproxy.Image <> Nil Then
        TMag4VGear(Iproxy.Image).Fit1to1
    End

  Else //if (SelectedCount > 0) then
    For i := 0 To FProxyList.Count - 1 Do
    Begin
      Iproxy := FProxyList[i];
      If Iproxy.Image <> Nil Then
        If TMag4VGear(Iproxy.Image).Selected Then
          TMag4VGear(Iproxy.Image).Fit1to1
    End;
    // else if Cur4Image <> nil then Cur4Image.fittoheight;
End;

Procedure TMag4Viewer.FitToWidth;
Var
  i: Integer;
  Iproxy: TImageProxy;
    //  vGear: TMag4vGear;
Begin
  FLastFit := IG_DISPLAY_FIT_TO_WIDTH;
  If FApplytoall Then
        // for i := 0 to I3ptrList.count - 1 do TMag4Vgear(I3PtrList[i]).FitToWidth
    For i := 0 To FProxyList.Count - 1 Do
    Begin
      Iproxy := FProxyList[i];
      If Iproxy.Image <> Nil Then
        TMag4VGear(Iproxy.Image).FitToWidth
    End

  Else //if (SelectedCount > 0) then
    For i := 0 To FProxyList.Count - 1 Do
    Begin
      Iproxy := FProxyList[i];
      If Iproxy.Image <> Nil Then
        If TMag4VGear(Iproxy.Image).Selected Then
          TMag4VGear(Iproxy.Image).FitToWidth
    End;
    // else if Cur4Image <> nil then Cur4Image.fittoheight;
End;

Procedure TMag4Viewer.FitToHeight;
Var
  i: Integer;
  Iproxy: TImageProxy;
    //  vGear: TMag4vGear;
Begin
  FLastFit := IG_DISPLAY_FIT_TO_HEIGHT;
  If FApplytoall Then
        // for i := 0 to I3ptrList.count - 1 do TMag4Vgear(I3PtrList[i]).fittoheight
    For i := 0 To FProxyList.Count - 1 Do
    Begin
      Iproxy := FProxyList[i];
      If Iproxy.Image <> Nil Then
        TMag4VGear(Iproxy.Image).FitToHeight
    End

  Else //if (SelectedCount > 0) then
    For i := 0 To FProxyList.Count - 1 Do
    Begin
      Iproxy := FProxyList[i];
      If Iproxy.Image <> Nil Then
        If TMag4VGear(Iproxy.Image).Selected Then
          TMag4VGear(Iproxy.Image).FitToHeight
    End;
    // else if Cur4Image <> nil then Cur4Image.fittoheight;
End;

Procedure TMag4Viewer.FlipVert;
Var
  i: Integer;
  Iproxy: TImageProxy;
    //  vGear: TMag4vGear;
Begin
  If FApplytoall Then
        // for i := 0 to I3ptrList.count - 1 do TMag4Vgear(I3PtrList[i]).fittoheight
    For i := 0 To FProxyList.Count - 1 Do
    Begin
      Iproxy := FProxyList[i];
      If Iproxy.Image <> Nil Then
        TMag4VGear(Iproxy.Image).FlipVert
    End
  Else //if (SelectedCount > 0) then
    For i := 0 To FProxyList.Count - 1 Do
    Begin
      Iproxy := FProxyList[i];
      If Iproxy.Image <> Nil Then
        If TMag4VGear(Iproxy.Image).Selected Then
          TMag4VGear(Iproxy.Image).FlipVert
    End;
End;

Procedure TMag4Viewer.FlipHoriz;
Var
  i: Integer;
  Iproxy: TImageProxy;
    //  vGear: TMag4vGear;
Begin
  If FApplytoall Then
        // for i := 0 to I3ptrList.count - 1 do TMag4Vgear(I3PtrList[i]).fittoheight
    For i := 0 To FProxyList.Count - 1 Do
    Begin
      Iproxy := FProxyList[i];
      If Iproxy.Image <> Nil Then
        TMag4VGear(Iproxy.Image).FlipHoriz
    End
  Else //if (SelectedCount > 0) then
    For i := 0 To FProxyList.Count - 1 Do
    Begin
      Iproxy := FProxyList[i];
      If Iproxy.Image <> Nil Then
        If TMag4VGear(Iproxy.Image).Selected Then
          TMag4VGear(Iproxy.Image).FlipHoriz
    End;

End;

Procedure TMag4Viewer.ResetImages(ApplyToAll: Boolean = False);
Var
  i: Integer;
  Iproxy: TImageProxy;
    //  vGear: TMag4vGear;
Begin
  If FApplytoall Or ApplyToAll Then
        // for i := 0 to I3ptrList.count - 1 do TMag4Vgear(I3PtrList[i]).fittoheight
    For i := 0 To FProxyList.Count - 1 Do
    Begin
      Iproxy := FProxyList[i];
      If Iproxy.Image <> Nil Then
        TMag4VGear(Iproxy.Image).ResetImage;
    End
  Else //if (SelectedCount > 0) then
    For i := 0 To FProxyList.Count - 1 Do
    Begin
      Iproxy := FProxyList[i];
      If Iproxy.Image <> Nil Then
        If TMag4VGear(Iproxy.Image).Selected Then
          TMag4VGear(Iproxy.Image).ResetImage;
    End;

End;

Procedure TMag4Viewer.Rotate(Deg: Integer);
Var
  i: Integer;
  Iproxy: TImageProxy;
Begin
  If FApplytoall Then
    For i := 0 To FProxyList.Count - 1 Do
    Begin
      Iproxy := FProxyList[i];
      If Iproxy.Image <> Nil Then
        TMag4VGear(Iproxy.Image).Rotate(Deg)
    End
  Else
    For i := 0 To FProxyList.Count - 1 Do
    Begin
      Iproxy := FProxyList[i];
      If Iproxy.Image <> Nil Then
        If TMag4VGear(Iproxy.Image).Selected Then
          TMag4VGear(Iproxy.Image).Rotate(Deg)
    End;
End;

Procedure TMag4Viewer.Inverse;
Var
  i: Integer;
  Iproxy: TImageProxy;
    //  vGear: TMag4vGear;
Begin
  If FApplytoall Then
        // for i := 0 to I3ptrList.count - 1 do TMag4Vgear(I3PtrList[i]).fittoheight
    For i := 0 To FProxyList.Count - 1 Do
    Begin
      Iproxy := FProxyList[i];
      If Iproxy.Image <> Nil Then
        TMag4VGear(Iproxy.Image).Inverse;
    End
  Else //if (SelectedCount > 0) then
    For i := 0 To FProxyList.Count - 1 Do
    Begin
      Iproxy := FProxyList[i];
      If Iproxy.Image <> Nil Then
        If TMag4VGear(Iproxy.Image).Selected Then
          TMag4VGear(Iproxy.Image).Inverse;
    End;

End;

{-------}

Procedure TMag4Viewer.MouseMagnify;
Var
  i: Integer;
  Iproxy: TImageProxy;
    //  vGear: TMag4vGear;
Begin
  FCurrentTool := MactMagnify;
  For i := 0 To FProxyList.Count - 1 Do
  Begin
    Iproxy := FProxyList[i];
    If Iproxy.Image <> Nil Then
      TMag4VGear(Iproxy.Image).MouseMagnify;
  End;
    {
    if FApplytoAll then
      for i := 0 to FProxyList.Count - 1 do
        begin
          Iproxy := FProxyList[i];
          if Iproxy.Image <> nil then TMag4Vgear(Iproxy.Image).MouseMagnify;
        end
    else //if (SelectedCount > 0) then
      for i := 0 to FProxyList.Count - 1 do
        begin
          Iproxy := FProxyList[i];
          if Iproxy.Image <> nil
            then if TMag4Vgear(Iproxy.Image).selected
            then TMag4Vgear(Iproxy.Image).MouseMagnify;
        end;
        }
End;

Procedure TMag4Viewer.MousePan;
Var
  i: Integer;
  Iproxy: TImageProxy;
Begin
  FCurrentTool := MactPan;
  For i := 0 To FProxyList.Count - 1 Do
  Begin
    Iproxy := FProxyList[i];
    If Iproxy.Image <> Nil Then
      TMag4VGear(Iproxy.Image).MousePan;
  End
        {
        if FApplytoAll then
          for i := 0 to FProxyList.Count - 1 do
            begin
              Iproxy := FProxyList[i];
              if Iproxy.Image <> nil then TMag4Vgear(Iproxy.Image).MousePan;
            end
        else
          for i := 0 to FProxyList.Count - 1 do
            begin
              Iproxy := FProxyList[i];
              if Iproxy.Image <> nil
                then if TMag4Vgear(Iproxy.Image).selected
                then TMag4Vgear(Iproxy.Image).MousePan;
            end;
            }
End;

Procedure TMag4Viewer.MouseZoomRect;
Var
  i: Integer;
  Iproxy: TImageProxy;
    //  vGear: TMag4vGear;
Begin
  FCurrentTool := MactZoomRect;
  For i := 0 To FProxyList.Count - 1 Do
  Begin
    Iproxy := FProxyList[i];
    If Iproxy.Image <> Nil Then
      TMag4VGear(Iproxy.Image).MouseZoomRect;
  End;
End;

Procedure TMag4Viewer.AutoWinLevel;
Var
  i: Integer;
  Iproxy: TImageProxy;
Begin
  FCurrentTool := MactWinLev;
  For i := 0 To FProxyList.Count - 1 Do
  Begin
    Iproxy := FProxyList[i];
    If Iproxy.Image <> Nil Then
      TMag4VGear(Iproxy.Image).AutoWinLevel;
  End;
    {
    if FApplytoAll then
      for i := 0 to FProxyList.Count - 1 do
        begin
          Iproxy := FProxyList[i];
          if Iproxy.Image <> nil then TMag4Vgear(Iproxy.Image).AutoWinLevel;
        end
    else //if (SelectedCount > 0) then
      for i := 0 to FProxyList.Count - 1 do
        begin
          Iproxy := FProxyList[i];
          if Iproxy.Image <> nil
            then if TMag4Vgear(Iproxy.Image).selected
            then TMag4Vgear(Iproxy.Image).AutoWinLevel;
        end;
        }
End;

Procedure TMag4Viewer.ZoomIn;
Begin

End;

Procedure TMag4Viewer.ZoomOut;
Begin
    //
End;

Function TMag4Viewer.GetZoomValueofImage(): Integer;
Var
  i: Integer;
  Iproxy: TImageProxy;
Begin
  Result := 100;
  For i := 0 To FProxyList.Count - 1 Do
  Begin
    Iproxy := FProxyList[i];
    If Iproxy.Image <> Nil Then
      If TMag4VGear(Iproxy.Image).Selected Then
        Result := 100; //trunc(TMag4Vgear(Iproxy.Image).
  End;

End;

Procedure TMag4Viewer.ZoomValue(Value: Integer);
Var
  i: Integer;
  Iproxy: TImageProxy;
    //  vGear: TMag4vGear;
Begin
  If FApplytoall Then
        // for i := 0 to I3ptrList.count - 1 do TMag4Vgear(I3PtrList[i]).fittoheight
    For i := 0 To FProxyList.Count - 1 Do
    Begin
      Iproxy := FProxyList[i];
      If Iproxy.Image <> Nil Then
        TMag4VGear(Iproxy.Image).ZoomValue(Value);
    End
  Else //if (SelectedCount > 0) then
    For i := 0 To FProxyList.Count - 1 Do
    Begin
      Iproxy := FProxyList[i];
      If Iproxy.Image <> Nil Then
        If TMag4VGear(Iproxy.Image).Selected Then
          TMag4VGear(Iproxy.Image).ZoomValue(Value);
    End;
End;

Procedure TMag4Viewer.BrightnessContrastValue(Bright, Contrast: Integer);
Var
  i: Integer;
  Iproxy: TImageProxy;
    //  vGear: TMag4vGear;
Begin
  If FApplytoall Then
        // for i := 0 to I3ptrList.count - 1 do TMag4Vgear(I3PtrList[i]).fittoheight
    For i := 0 To FProxyList.Count - 1 Do
    Begin
      Iproxy := FProxyList[i];
      If Iproxy.Image <> Nil Then
        TMag4VGear(Iproxy.Image).BrightnessContrastValue(Bright,
          Contrast);
    End
  Else //if (SelectedCount > 0) then
    For i := 0 To FProxyList.Count - 1 Do
    Begin
      Iproxy := FProxyList[i];
      If Iproxy.Image <> Nil Then
        If TMag4VGear(Iproxy.Image).Selected Then
          TMag4VGear(Iproxy.Image).BrightnessContrastValue(Bright,
            Contrast);
    End;

End;

Procedure TMag4Viewer.ContrastValue(Value: Integer);
Var
  i: Integer;
  Iproxy: TImageProxy;
    //  vGear: TMag4vGear;
Begin
  If FApplytoall Then
        // for i := 0 to I3ptrList.count - 1 do TMag4Vgear(I3PtrList[i]).fittoheight
    For i := 0 To FProxyList.Count - 1 Do
    Begin
      Iproxy := FProxyList[i];
      If Iproxy.Image <> Nil Then
        TMag4VGear(Iproxy.Image).ContrastValue(Value);
    End
  Else //if (SelectedCount > 0) then
    For i := 0 To FProxyList.Count - 1 Do
    Begin
      Iproxy := FProxyList[i];
      If Iproxy.Image <> Nil Then
        If TMag4VGear(Iproxy.Image).Selected Then
          TMag4VGear(Iproxy.Image).ContrastValue(Value);
    End;
End;

{ passthrough to Image Ojbect       }

Procedure TMag4Viewer.BrightnessValue(Value: Integer);
Var
  i: Integer;
  Iproxy: TImageProxy;
    //  vGear: TMag4vGear;
Begin
  If FApplytoall Then
        // for i := 0 to I3ptrList.count - 1 do TMag4Vgear(I3PtrList[i]).fittoheight
    For i := 0 To FProxyList.Count - 1 Do
    Begin
      Iproxy := FProxyList[i];
      If Iproxy.Image <> Nil Then
        TMag4VGear(Iproxy.Image).BrightnessValue(Value);
    End
  Else //if (SelectedCount > 0) then
    For i := 0 To FProxyList.Count - 1 Do
    Begin
      Iproxy := FProxyList[i];
      If Iproxy.Image <> Nil Then
        If TMag4VGear(Iproxy.Image).Selected Then
          TMag4VGear(Iproxy.Image).BrightnessValue(Value);
    End;
End;

(*
procedure TMag4Viewer.WindowValue(Value: integer);
var i: integer;
  Iproxy: TImageProxy;
//  vGear: TMag4vGear;
begin
  if FApplytoAll then
    // for i := 0 to I3ptrList.count - 1 do TMag4Vgear(I3PtrList[i]).fittoheight
    for i := 0 to FProxyList.Count - 1 do
      begin
        Iproxy := FProxyList[i];
        if Iproxy.Image <> nil then TMag4Vgear(Iproxy.Image).windowvalue(value);
      end
  else //if (SelectedCount > 0) then
    for i := 0 to FProxyList.Count - 1 do
      begin
        Iproxy := FProxyList[i];
        if Iproxy.Image <> nil
          then if TMag4Vgear(Iproxy.Image).selected
          then TMag4Vgear(Iproxy.Image).windowvalue(value);
      end;
end;
*)

Procedure TMag4Viewer.WinLevValue(WinValue, LevelValue: Integer);
Var
  i: Integer;
  Iproxy: TImageProxy;
    //  vGear: TMag4vGear;
Begin
  If FApplytoall Then
        // for i := 0 to I3ptrList.count - 1 do TMag4Vgear(I3PtrList[i]).fittoheight
    For i := 0 To FProxyList.Count - 1 Do
    Begin
      Iproxy := FProxyList[i];
      If Iproxy.Image <> Nil Then
        TMag4VGear(Iproxy.Image).WinLevValue(WinValue, LevelValue);
    End
  Else //if (SelectedCount > 0) then
    For i := 0 To FProxyList.Count - 1 Do
    Begin
      Iproxy := FProxyList[i];
      If Iproxy.Image <> Nil Then
        If TMag4VGear(Iproxy.Image).Selected Then
          TMag4VGear(Iproxy.Image).WinLevValue(WinValue, LevelValue);
    End;
End;

Procedure TMag4Viewer.PageFirstImage;
Var
  i: Integer;
  Iproxy: TImageProxy;
Begin
  If FApplytoall Then
    For i := 0 To FProxyList.Count - 1 Do
    Begin
      Iproxy := FProxyList[i];
      If Iproxy.Image <> Nil Then
        TMag4VGear(Iproxy.Image).PageFirst;
    End
  Else
    For i := 0 To FProxyList.Count - 1 Do
    Begin
      Iproxy := FProxyList[i];
      If Iproxy.Image <> Nil Then
        If TMag4VGear(Iproxy.Image).Selected Then
          TMag4VGear(Iproxy.Image).PageFirst;
    End;
End;

Procedure TMag4Viewer.PageLastImage;
Var
  i: Integer;
  Iproxy: TImageProxy;
Begin
  If FApplytoall Then
    For i := 0 To FProxyList.Count - 1 Do
    Begin
      Iproxy := FProxyList[i];
      If Iproxy.Image <> Nil Then
        TMag4VGear(Iproxy.Image).PageLast;
    End
  Else
    For i := 0 To FProxyList.Count - 1 Do
    Begin
      Iproxy := FProxyList[i];
      If Iproxy.Image <> Nil Then
        If TMag4VGear(Iproxy.Image).Selected Then
          TMag4VGear(Iproxy.Image).PageLast;
    End;
End;

Procedure TMag4Viewer.PageNextImage;
Var
  i: Integer;
  Iproxy: TImageProxy;
Begin
  If FApplytoall Then
    For i := 0 To FProxyList.Count - 1 Do
    Begin
      Iproxy := FProxyList[i];
      If Iproxy.Image <> Nil Then
        TMag4VGear(Iproxy.Image).PageNext;
    End
  Else
    For i := 0 To FProxyList.Count - 1 Do
    Begin
      Iproxy := FProxyList[i];
      If Iproxy.Image <> Nil Then
        If TMag4VGear(Iproxy.Image).Selected Then
          TMag4VGear(Iproxy.Image).PageNext;
    End;
End;

Procedure TMag4Viewer.PagePrevImage;
Var
  i: Integer;
  Iproxy: TImageProxy;
Begin
  If FApplytoall Then
    For i := 0 To FProxyList.Count - 1 Do
    Begin
      Iproxy := FProxyList[i];
      If Iproxy.Image <> Nil Then
        TMag4VGear(Iproxy.Image).PagePrev;
    End
  Else
    For i := 0 To FProxyList.Count - 1 Do
    Begin
      Iproxy := FProxyList[i];
      If Iproxy.Image <> Nil Then
        If TMag4VGear(Iproxy.Image).Selected Then
          TMag4VGear(Iproxy.Image).PagePrev;
    End;
End;

Procedure TMag4Viewer.MouseReSet;
Var
  i: Integer;
  Iproxy: TImageProxy;
Begin
  FCurrentTool := MactPointer;
  For i := 0 To FProxyList.Count - 1 Do
  Begin
    Iproxy := FProxyList[i];
    If Iproxy.Image <> Nil Then
      TMag4VGear(Iproxy.Image).MouseReSet;
  End;
End;

Procedure TMag4Viewer.ReFreshImages;
Var
  i: Integer;
Begin
{debug94} MagLogger.LogMsg('s', '**--** - in TMag4Viewer.ReFreshImages. ' + ' count: ' + Inttostr(FLoadedList.Count - 1));
  For i := 0 To FLoadedList.Count - 1 Do
  Begin
    TImageProxy(FLoadedList[i]).Image.RefreshImage;
  End;
{debug94} MagLogger.LogMsg('s', '**--** - END TMag4Viewer.ReFreshImages. ' + ' count: ' + Inttostr(FLoadedList.Count - 1));
End;

Procedure TMag4Viewer.DeSkewAndSmooth;
Var
  i: Integer;
  Iproxy: TImageProxy;
    //  vGear: TMag4vGear;
Begin
  If FApplytoall Then
        // for i := 0 to I3ptrList.count - 1 do TMag4Vgear(I3PtrList[i]).fittoheight
    For i := 0 To FProxyList.Count - 1 Do
    Begin
      Iproxy := FProxyList[i];
      If Iproxy.Image <> Nil Then
        TMag4VGear(Iproxy.Image).DeSkewAndSmooth;
    End
  Else //if (SelectedCount > 0) then
    For i := 0 To FProxyList.Count - 1 Do
    Begin
      Iproxy := FProxyList[i];
      If Iproxy.Image <> Nil Then
        If TMag4VGear(Iproxy.Image).Selected Then
          TMag4VGear(Iproxy.Image).DeSkewAndSmooth;
    End;
End;

(*
procedure TMag4Viewer.ApplyCurrentToAll;
//var i: integer;
 // zl: integer;
begin
  { TODO -oGarrett -cConversion :
  Apply current to All needs work.
  TheImage.  is gone, we need to be able to get the values from TMag4VGear
  and Not the Gear Component.  We can no longer see it.  because we
  don't want to know which component is displaying the Image. }
   *)
  (* new
  zl := Cur4Image.TheImage.zoomlevel;
     for i := 0 to I3ptrList.count-1 do
            begin

            Iptr := I3ptrList[i];
            //Iptr^.image.invert := Cur4Image.invert;
            Iptr^.image4.TheImage.fitmethod := Cur4Image.TheImage.fitmethod;
            Iptr^.image4.TheImage.selectevent := Cur4Image.TheImage.selectevent;
            Iptr^.image4.TheImage.magnifywindow := Cur4Image.TheImage.magnifywindow    ;
            Iptr^.image4.TheImage.HandPanning := Cur4Image.TheImage.HandPanning    ;
            Iptr^.image4.TheImage.zoomlevel := zl    ;
            Iptr^.image4.TheImage.displaybrightness := Cur4Image.TheImage.displaybrightness  ;
            Iptr^.image4.TheImage.displaycontrast := Cur4Image.TheImage.displaycontrast    ;
            Iptr^.image4.TheImage.redraw := true;
            application.processmessages;
            end;

end;*)

  (*   ****************   *)

Procedure TMag4Viewer.UnDoGroupingNew;
Begin
  If FUnDoList.Count = 0 Then
    FCurUnDoGroup := 1
  Else
    FCurUnDoGroup := TMagUnDoItem(FUnDoList[FUnDoList.Count -
      1]).MagUnDoGroup + 1;
End;

Procedure TMag4Viewer.UnDoListClear;
Var
  i: Integer;
Begin
  For i := FUnDoList.Count - 1 Downto 0 Do
  Begin
    UnDoItemClear(i);
  End;
End;

Procedure TMag4Viewer.UnDoItemClear(Item: Integer);
//var undoItem: TMagUnDoItem;
Begin
    // undoItem := FUndolist[item];
  FUnDoList.Delete(Item);
    {TODO: here (later when we use the UnDo Function we have to release memory
                                                          of the IProxies, and TGears}
End;

(*procedure Tmag4Viewer.UnDoListAddItem(txt: string; proxy: TImageProxy; undoaction: TMagundoAction);
var undoItem: TMagUnDoItem;
  //     vGear: TMag4VGear;
begin
  undoItem := TMagUnDoItem.create;
  undoItem.magCaption := txt;
  undoItem.magUnDoGroup := FCurUnDoGroup;
  undoItem.magIproxy := proxy;
       //vGear := undoitem.magIproxy.image;
       //undoitem.magIproxy.Image := nil;
       //Destroy_P(vGear);
  undoItem.magUnDoAction := undoAction;
  FUndoList.add(undoItem);
end;
*)

Function TMag4Viewer.UnDoActionGetText: String;
Begin
  If FUnDoList.Count = 0 Then
    Result := ''
  Else
    Result := TMagUnDoItem(FUnDoList[FUnDoList.Count - 1]).MagCaption;
End;

Procedure TMag4Viewer.UnDoActionExecute;
Var
  i: Integer;
  CurGrping: Integer;
  UndoItem: TMagUnDoItem;
    //  undoaction: TMagUnDoAction;
Begin
  If FUnDoList.Count = 0 Then
    Exit; // Shouldn't happen;
  CurGrping := TMagUnDoItem(FUnDoList[FUnDoList.Count - 1]).MagUnDoGroup;
    (*     undoaction := TMagUnDoItem(FundoList[Fundolist.count - 1]).magUndoAction; *)
  For i := FUnDoList.Count - 1 Downto 0 Do
  Begin
    UndoItem := FUnDoList[i];
    If UndoItem.MagUnDoGroup <> CurGrping Then
      Break;
    FUnDoList.Delete(i);
    Case UndoItem.MagUnDoAction Of
      MagundoRemove:
        Begin
          If FProxyList.Count < UndoItem.MagIproxy.Loadindex Then
            FProxyList.Add(UndoItem.MagIproxy)
          Else
            FProxyList.Insert(UndoItem.MagIproxy.Loadindex,
              UndoItem.MagIproxy);
        End;
      MagundoAdd:
        Begin
          ;
        End;
    End;
  End;
  ReAlignImages;
End;

Procedure TMag4Viewer.SetRemember(Value: Boolean);
Begin
  FLastRemember := Value;
End;

Procedure TMag4Viewer.OnImageMouseScrollDown(Sender: Tobject; Shift:
  TShiftState; MousePos: TPoint; Var Handled:
  Boolean);
Begin
  PageNextViewer;
  If Assigned(OnPageNextViewerClick) Then
    OnPageNextViewerClick(Sender); // //jw 11/16/07
  Handled := True; //  //jw 11/16/07
End;

Procedure TMag4Viewer.OnImageMouseScrollUp(Sender: Tobject; Shift: TShiftState;
  MousePos: TPoint; Var Handled:
  Boolean);
Begin
  PagePrevViewer;
  If Assigned(OnPagePreviousViewerClick) Then
    OnPagePreviousViewerClick(Sender); //jw 11/16/07
  Handled := True; //jw 11/16/07
End;

{
procedure TMag4Viewer.setRadiologyView(Value : boolean);
begin
  FRadiologyView := value;
  tbRowBigger.Visible := not FRadiologyView;
  tbRowSmaller.Visible := not FRadiologyView;
  tbColumnBigger.Visible := not FRadiologyView;
  tbColumnSmaller.Visible := not FRadiologyView;
  tbClear.Visible := not FRadiologyView;
  tbRefresh.Visible := not FRadiologyView;
end;
}

Procedure TMag4Viewer.ViewFullResImage();
Var
  Oneimage, TxtFilename: String;
  Iproxy: TImageProxy;
  i: Integer;
  VGear: TMag4VGear;
  TransferResult: TMagImageTransferResult;
  TxtTransferResult: TMagImageTransferResult;
  ocurs: TCursor;
Begin
  TransferResult := Nil;
  TxtTransferResult := Nil;
  For i := 0 To FProxyList.Count - 1 Do
  Begin
    Iproxy := FProxyList[i];
        // could also check to see if image already loaded, but that should be true if selected is true
    If (Iproxy.Image <> Nil) And (TMag4VGear(Iproxy.Image).Selected) Then
    Begin
      CursorChange(ocurs, crHourGlass); //     screen.cursor := crHourglass;
      TransferResult := MagImageManager1.GetFile(Iproxy.ImageData.BigFile,
        Iproxy.ImageData.PlaceCode, Iproxy.ImageData.ImgType, False);
      cursorRestore(ocurs); //             screen.cursor := crDefault;
      If (TransferResult.FTransferStatus = IMAGE_UNAVAILABLE) Or
        (TransferResult.FTransferStatus = IMAGE_FAILED) Then
      Begin
                // not logical, already changed back.   screen.cursor := crDefault;
        Showmessage('No Full Resolution Image Available.');
      End
      Else
      Begin
        Oneimage := TransferResult.FDestinationFilename;
        VGear := TMag4VGear(Iproxy.Image);
        VGear.LoadTheImage(Oneimage, True);
                // not logical, already changed back.     screen.cursor := crDefault;
        VGear.ImageLoaded := True;
        VGear.ImageDescription := '#' + Inttostr(i + 1) + ' ' +
          Iproxy.ImageData.ExpandedDescription(False);

                // i think we should load the dicom header info and stuff?
        TxtFilename := '';
        If
          GetImageUtility().DetermineStorageProtocol(Iproxy.ImageData.FFile) = MagStorageUNC Then
        Begin
          TxtFilename := ChangeFileExt(Iproxy.ImageData.FFile,
            '.txt');
          TxtTransferResult := MagImageManager1.GetFile(TxtFilename,
            Iproxy.ImageData.PlaceCode, Iproxy.ImageData.ImgType,
            False);
          If (TxtTransferResult.FTransferStatus = IMAGE_FAILED) Or
            (TxtTransferResult.FTransferStatus = IMAGE_UNAVAILABLE) Then
            TxtFilename := ''
          Else
            TxtFilename := TxtTransferResult.FDestinationFilename;
          If TxtTransferResult <> Nil Then
            FreeAndNil(TxtTransferResult);
        End;
        If VGear.LoadDICOMData(TxtFilename, FCurrentPatientSSN,
          FCurrentPatientICN, False) Then
        Begin
          VGear.WindowLevelEntireImage();
          VGear.DrawRadLetters();
          VGear.SetAnnotationStyle(FAnnotationStyle);
          VGear.SetCurrentTool(FCurrentTool);
                    // JMW 1/8/07 set to the current tool when viewing full res image
        End
        Else
        Begin
                    // the ICN or SSN did not match properly
          VGear.ClearImage();
          VGear.ImageLoaded := True;
          VGear.LoadTheImage(MagImageManager1.GetCannedBMP(MagAbsQA));
          VGear.DisableWindowLevel();
          If Assigned(FPatientIDMismatchEvent) Then
            FPatientIDMismatchEvent(Self, VGear);
                    //LogMsg('DEQA',
                    //    'Patient identifier from VistA does not match patient identifier from image.');
          MagLogger.LogMsg('DEQA',
            'Patient identifier from VistA does not match patient identifier from image.'); {JK 10/5/2009 - MaggMsgu refactoring}
        End;
      End;
      If TransferResult <> Nil Then
        FreeAndNil(TransferResult);
    End;
  End;

End;

Procedure TMag4Viewer.SetViewStyle(Value: TMagViewerViewStyle);
Begin
  FViewStyle := Value;
  Case FViewStyle Of
    MagViewerViewAbs:
      Begin
        FviewerDesc := ' Abstracts.';
        TbPageLast.Visible := False;
                // true; //93 made true, then went back, the code needs modified for Abs, to not set focus, not worry about win lev.
        TbPageFirst.Visible := False; //true; //93 made true
        TbPageNext.Visible := False;
        TbPagePrev.Visible := False;
        TbClear.Visible := False;
        TbConfig.Visible := False; //93 made true, then made false.

        TbtnAbsPagePrev.Visible := True;
        TbtnAbsPageNext.Visible := True;
        TbtnAbsSmaller.Visible := True;
        TbtnAbsBigger.Visible := True;
      End;
    MagViewerViewFull:
      Begin
        FviewerDesc := ' Images.';
                // 01/06/03 Patch 8   Ruth - simplify things, Don't show toolbar
        TbViewer.Visible := False;
      End;
    MagViewerViewRadiology:
      Begin
        TbClear.Visible := False;
        TbRefresh.Visible := False;
        TbPageFirst.Visible := True;
        TbPageLast.Visible := True;
        TbPageNext.Visible := True;
        TbPagePrev.Visible := True;
                //
        TbtnAbsPagePrev.Visible := False;
        TbtnAbsPageNext.Visible := False;
        TbtnAbsSmaller.Visible := False;
        TbtnAbsBigger.Visible := False;
                //
                // causes proxy images to not show up
                // JMW 7/14/2006 p72 - makes the viewer black
                //scrlv.Color := clblack;
        PnlTop.Font.Style := [Fsbold];
                // this makes the vertical scrollbar invisible
        LblScrollBlocker.Visible := True;
        RIVAttachListener(Self);
      End;
  End;
End;

Procedure TMag4Viewer.OnImageDoubleClickEvent(Sender: Tobject);
Begin
  If (Sender Is TMag4VGear) Then
  Begin
    If (FViewStyle = MagViewerViewRadiology) And
      (Assigned(OnImageDoubleClick)) Then
    Begin
      OnImageDoubleClick(Self, Sender As TMag4VGear);
    End
    Else
    Begin
            //MaxImageToggle((Sender as TMag4VGear).PI_ptrData);
      MaxImageToggle((Sender As TMag4VGear));
    End;

  End;
End;

Function TMag4Viewer.IsStudyAlreadyLoaded(FirstImageIEN: String; Server: String;
  Port: Integer; StudyImgCount:
  Integer): Boolean;
Var
  cProxy: TImageProxy;
Begin
  Result := False;
  If FProxyList = Nil Then
    Exit;
  If FProxyList.Count <= 0 Then
    Exit;
  cProxy := FProxyList.Items[0];
  If cProxy.ImageData = Nil Then
    Exit;
  If cProxy.ImageData.Mag0 <> FirstImageIEN Then
    Exit;
  If cProxy.ImageData.ServerName <> Server Then
    Exit;
  If cProxy.ImageData.ServerPort <> Port Then
    Exit;
  If FProxyList.Count <> StudyImgCount Then
    Exit;
  Result := True;
End;

// JMW p72 7/17/2006 scrolls to selected image and shows it
// also shows any other images that should be visible (loaded)

Procedure TMag4Viewer.ShowImage(ImageIndex: Integer);
Var
  VisProxy: Integer;
Begin
  ScrollToImage(ImageIndex);
  VisProxy := FirstVisProxy;
  LoadProxyImages(VisProxy); {*** ShowImage ***}
  SelectAnImage(ImageIndex);
End;

Procedure TMag4Viewer.LblScrollBlockerMouseDown(Sender: Tobject;
  Button: TMouseButton; Shift: TShiftState; x, y: Integer);
Begin
  If (Ssctrl In Shift) And (SsShift In Shift) Then
  Begin
    LblScrollBlocker.Visible := False;
  End;
End;

Procedure TMag4Viewer.SetApplyToAll(Value: Boolean);
Begin
  FApplytoall := Value;
  If (FViewStyle = MagViewerViewRadiology) And (FApplytoall) Then
  Begin
    If Cur4Image <> Nil Then
      ApplyImageState(Cur4Image.GetState(), True);
  End;
End;

Function TMag4Viewer.GetApplyToAll(): Boolean;
Begin
  Result := FApplytoall;
End;

Function TMag4Viewer.GetPanWindow(): Boolean;
Begin
  Result := FPanWindow;
End;

Function TMag4Viewer.GetMaximizeImage(): Boolean;
Begin
  Result := FMaximizeImage;
End;

Function TMag4Viewer.GetViewerStyle(): TMagViewerStyles;
Begin
  Result := FViewerStyle;
End;

Function TMag4Viewer.GetLockSize(): Boolean;
Begin
  Result := FLockSize
End;

Function TMag4Viewer.GetClearBeforeAdd(): Boolean;
Begin
  Result := FClearBeforeAdd;
End;

Procedure TMag4Viewer.SetClearBeforeAdd(Value: Boolean);
Begin
  FClearBeforeAdd := Value;
End;

Function TMag4Viewer.GetMaxCount(): Integer;
Begin
  Result := FMaxCount;
End;

Function TMag4Viewer.GetAnnotationsEnabled(): Boolean;
Begin
  Result := FAnnotationsEnabled;
End;

Function TMag4Viewer.GetCurrentImageIndex(): Integer;
Begin
  Result := 0;
  If Cur4Image = Nil Then
    Exit;
    //result := Cur4Image.ImageNumber;
  Result := Cur4Image.ListIndex;
End;

Procedure TMag4Viewer.ApplyImageState(State: TMagImageState; ApplyAll: Boolean =
  False);
Var
  i: Integer;
  Iproxy: TImageProxy;
  VGear: TMag4VGear;
Begin
    // apply image state to current image
  If (Cur4Image = Nil) And (Not ApplyAll) Then
    Exit;
  If State = Nil Then
    Exit;
  If ApplyAll Then
  Begin
        // don't set page here
    For i := 0 To FProxyList.Count - 1 Do
    Begin
      Iproxy := FProxyList[i];
      If Iproxy.Image <> Nil Then
      Begin
        VGear := TMag4VGear(Iproxy.Image);
                // only apply the window level if it is coming from an image with proper win/level
        If State.WinLevEnabled Then
          VGear.WinLevValue(State.WinValue, State.LevValue);
        VGear.BrightnessContrastValue(State.BrightnessValue,
          State.ContrastValue);
        VGear.ZoomValue(State.ZoomValue);
      End;
    End
  End
  Else
  Begin
        // only apply the window level if it is coming from an image with proper win/level
    If State.WinLevEnabled Then
      Cur4Image.WinLevValue(State.WinValue, State.LevValue);
    Cur4Image.BrightnessContrastValue(State.BrightnessValue,
      State.ContrastValue);
    Cur4Image.Page := State.Page;
        // not sure if this should set the zoom value... (was causing the image to be zoomed to this value and then changed
        // when the going from 1x1 to 3x2
        //Cur4Image.ZoomValue(state.zoomvalue);
  End;

End;

{
not used, remove
procedure TMag4Viewer.addImageNoShow(IObj : TImageData);
begin
  if IObj = nil then exit;
  AddImageToList(Iobj, -1);    // adds to proxy list

  SetProxyPosition(FProxyList.Count - 1);
end;
}

Procedure TMag4Viewer.DisplayDICOMHeader();
Begin
  If Cur4Image = Nil Then
    Exit;
  Cur4Image.DisplayDICOMHeader();
End;

Procedure TMag4Viewer.StopScrolling();
Begin
    // do nothing
End;

Procedure TMag4Viewer.RIVRecieveUpdate_(action: String; Value: String);
// recieve updates from everyone
Var
  NetworkFilename: String;
  IObj: TImageData;
  Iproxy: TImageProxy;
Begin
  If (FProxyList = Nil) Or (FProxyList.Count <= 0) Then
    Exit;
  Iproxy := FProxyList.Items[0];
  IObj := Iproxy.ImageData;
  If IObj = Nil Then
    Exit;
  NetworkFilename := Value;
  If action = 'ImageStart' Then
  Begin
    If IObj.FFile = NetworkFilename Then
    Begin
      ImlViewerBmps.GetIcon(21, ImgStudyStatus.Picture.Icon);
      ImgStudyStatus.Visible := True;
    End;
  End
  Else
    If action = 'ImageComplete' Then
    Begin
      If IObj.FFile = NetworkFilename Then
      Begin
        ImlViewerBmps.GetIcon(22, ImgStudyStatus.Picture.Icon);
        ImgStudyStatus.Visible := True;
      End;
    End;

End;

Procedure TMag4Viewer.cboSeriesChange(Sender: Tobject);
Var
  Index: Integer;
  Series: TMagSeriesObject;
Begin
  If cboSeries.Text = 'Series' Then
    Exit;
  Series := (cboSeries.Items.Objects[cboSeries.ItemIndex] As
    TMagSeriesObject);
  If Series = Nil Then
    Exit;
    //  LoadImage(series.ImageIndex);
  ShowImage(Series.ImageIndex);
End;

Procedure TMag4Viewer.CheckButtons();
Var
  CurIndex: Integer;
  Dicomdata: TDicomData;
  i: Integer;
  Series: TMagSeriesObject;
  IObj: TImageData;
Begin
  If (FProxyList.Count = 0) Or (Cur4Image = Nil) Then
  Begin
    TbPagePrev.Enabled := False;
    TbPageNext.Enabled := False;
    TbPageLast.Enabled := False;
    TbPageFirst.Enabled := False;
    Exit;
  End
  Else
  Begin
    CurIndex := Cur4Image.ListIndex;
    If CurIndex >= (FProxyList.Count - 1) Then
    Begin
      TbPageNext.Enabled := False;
      TbPageLast.Enabled := False;
    End
    Else
    Begin
      TbPageNext.Enabled := True;
      TbPageLast.Enabled := True;
    End;
    If CurIndex <= 0 Then
    Begin
      TbPageFirst.Enabled := False;
      TbPagePrev.Enabled := False;
    End
    Else
    Begin
      TbPageFirst.Enabled := True;
      TbPagePrev.Enabled := True;
    End;
  End;

  If Not cboSeries.Visible Then
    Exit;

  Dicomdata := Cur4Image.Dicomdata;
  IObj := Cur4Image.PI_ptrData;
  If Dicomdata = Nil Then
    Exit;
  For i := 0 To cboSeries.Items.Count - 1 Do
  Begin
    If cboSeries.Items[i] <> 'Series' Then
    Begin
      Series := (cboSeries.Items.Objects[i] As TMagSeriesObject);
      If (Series.SeriesName = IObj.DicomSequenceNumber) Then
      Begin
        cboSeries.ItemIndex := i;
        cboSeries.Hint := cboSeries.Items[i];
        Exit;
      End;
    End;
  End;

End;

Procedure TMag4Viewer.SetShowPixelValues(Value: Boolean);
Var
  i: Integer;
  Iproxy: TImageProxy;
    //  vGear: TMag4vGear;
Begin
  FShowPixelValues := Value;
  For i := 0 To FProxyList.Count - 1 Do
  Begin
    Iproxy := FProxyList[i];
    If Iproxy.Image <> Nil Then
      TMag4VGear(Iproxy.Image).ShowPixelValues := FShowPixelValues;
  End
End;

Function TMag4Viewer.GetShowPixelValues(): Boolean;
Begin
  Result := FShowPixelValues;
End;

Function TMag4Viewer.GetHistogramWindowLevel(): Boolean;
Begin
  Result := FHistogramWindowLevel;
End;

Procedure TMag4Viewer.SetHistogramWindowLevel(Value: Boolean);
Var
  i: Integer;
  Iproxy: TImageProxy;
Begin
  FHistogramWindowLevel := Value;
  FShowPixelValues := Value;
  For i := 0 To FProxyList.Count - 1 Do
  Begin
    Iproxy := FProxyList[i];
    If Iproxy.Image <> Nil Then
      TMag4VGear(Iproxy.Image).HistogramWindowLevel :=
        FHistogramWindowLevel;
  End
End;

Function TMag4Viewer.GetShowLabels(): Boolean;
Begin
  Result := FShowLabels;
End;

Procedure TMag4Viewer.SetShowLabels(Value: Boolean);
Var
  i: Integer;
  Iproxy: TImageProxy;
Begin
  FShowLabels := Value;
  For i := 0 To FProxyList.Count - 1 Do
  Begin
    Iproxy := FProxyList[i];
    If Iproxy.Image <> Nil Then
      TMag4VGear(Iproxy.Image).ShowLabels := FShowLabels;
  End

End;

Procedure TMag4Viewer.ImageZoomScroll(Sender: Tobject; VertScrollPos: Integer;
  HorizScrollPos: Integer);
Var
  i: Integer;
  Iproxy: TImageProxy;
Begin
  If FApplytoall Then
  Begin
    For i := 0 To FProxyList.Count - 1 Do
    Begin
      Iproxy := FProxyList[i];
      If (Iproxy.Image <> Nil) And (Iproxy.Image <> Sender) Then
      Begin
        Iproxy.Image.SetScrollPos(VertScrollPos, HorizScrollPos);
      End;
    End
  End;
End;

Procedure TMag4Viewer.ImageWinLevChange(Sender: Tobject; WindowValue: Integer;
  LevelValue: Integer);
Var
  i: Integer;
  Iproxy: TImageProxy;
Begin
  If FApplytoall Then
  Begin
    For i := 0 To FProxyList.Count - 1 Do
    Begin
      Iproxy := FProxyList[i];
      If (Iproxy.Image <> Nil) And (Iproxy.Image <> Sender) Then
      Begin
        Iproxy.Image.WinLevValue(WindowValue, LevelValue);
      End;
    End
  End;
End;

Procedure TMag4Viewer.ImageBriConChange(Sender: Tobject; BrightnessValue:
  Integer; ContrastValue: Integer);
Var
  i: Integer;
  Iproxy: TImageProxy;
Begin
  If FApplytoall Then
  Begin
    For i := 0 To FProxyList.Count - 1 Do
    Begin
      Iproxy := FProxyList[i];
      If (Iproxy.Image <> Nil) And (Iproxy.Image <> Sender) Then
      Begin
        Iproxy.Image.BrightnessContrastValue(BrightnessValue,
          ContrastValue);
      End;
    End
  End;
End;

Procedure TMag4Viewer.ImageZoomChange(Sender: Tobject; ZoomValue: Integer);
Var
  i: Integer;
  Iproxy: TImageProxy;
Begin
  If FApplytoall Then
  Begin
    For i := 0 To FProxyList.Count - 1 Do
    Begin
      Iproxy := FProxyList[i];
      If (Iproxy.Image <> Nil) And (Iproxy.Image <> Sender) Then
      Begin
        Iproxy.Image.ZoomValue(ZoomValue);
      End;
    End
  End;

End;

Procedure TMag4Viewer.ImageUpdateImageState(Sender: Tobject);
Var
  i: Integer;
  Iproxy: TImageProxy;
  Found: Boolean;
Begin
  If Cur4Image <> Sender Then
  Begin
    Found := False;
    UnSelectAll();
    For i := 0 To FProxyList.Count - 1 Do
    Begin
      Iproxy := FProxyList[i];
      If (Iproxy.Image <> Nil) And (Iproxy.Image = Sender) And (Not Found) Then
      Begin
        Cur4Image := Iproxy.Image;
        Cur4Image.Selected := True;
        Found := True;
      End;
    End
  End;
  If Assigned(OnViewerClick) Then
    OnViewerClick(Self, Self, Cur4Image);
End;

Function TMag4Viewer.GetCurrentTool(): TMagImageMouse;
Begin
  Result := FCurrentTool;

End;

Procedure TMag4Viewer.SetCurrentTool(Value: TMagImageMouse);
Begin
  FCurrentTool := Value;
  Case FCurrentTool Of
    MactPan:
      MousePan();
    MactMagnify:
      MouseMagnify();
    MactZoomRect:
      MouseZoomRect();
    MactWinLev:
      AutoWinLevel();
    MactAnnotation:
      Annotations();
    MactMeasure:
      Measurements();
    MactProtractor:
      Protractor();
    MactAnnotationPointer:
      AnnotationPointer();
  End; {case}
End;

Procedure TMag4Viewer.Annotations();
Begin
  FCurrentTool := MactAnnotation;
    // move the annotation toolbar to the right place
    // get the state of the current annotation image for the toolbar?
  FAnnotationsEnabled := True;
  If Cur4Image = Nil Then
    Exit;
  Cur4Image.Annotations();
End;

Procedure TMag4Viewer.Protractor();
Var
  i: Integer;
  Iproxy: TImageProxy;
Begin
  FCurrentTool := MactProtractor;
  For i := 0 To FProxyList.Count - 1 Do
  Begin
    Iproxy := FProxyList[i];
    If Iproxy.Image <> Nil Then
    Begin
      Iproxy.Image.Protractor();
    End;
  End;

End;

Procedure TMag4Viewer.Measurements();
Var
  i: Integer;
  Iproxy: TImageProxy;
Begin
  FCurrentTool := MactMeasure;
  For i := 0 To FProxyList.Count - 1 Do
  Begin
    Iproxy := FProxyList[i];
    If Iproxy.Image <> Nil Then
    Begin
      Iproxy.Image.Measurements();
    End;
  End;
End;

Procedure TMag4Viewer.AnnotationPointer();
Var
  i: Integer;
  Iproxy: TImageProxy;
Begin
  FCurrentTool := MactAnnotationPointer;
  For i := 0 To FProxyList.Count - 1 Do
  Begin
    Iproxy := FProxyList[i];
    If Iproxy.Image <> Nil Then
    Begin
      Iproxy.Image.AnnotationPointer();
    End;
  End;
End;

Procedure TMag4Viewer.ImageToolChange(Sender: Tobject; Tool: TMagImageMouse);
Var
  i: Integer;
  Iproxy: TImageProxy;
Begin
  If Assigned(OnViewerClick) And (Sender Is TMag4VGear) Then
    OnViewerClick(Self, Self, (Sender As TMag4VGear));
  FCurrentTool := Tool;
  For i := 0 To FProxyList.Count - 1 Do
  Begin
    Iproxy := FProxyList[i];
    If (Iproxy.Image <> Nil) And (Iproxy.Image <> Sender) Then
    Begin
      Iproxy.Image.SetCurrentTool(Tool);
    End;
  End;
End;

Procedure TMag4Viewer.ExamineSeries(VGear: TMag4VGear);
Var
  Dicomdata: TDicomData;
  i: Integer;
  Series: TMagSeriesObject;
  IObj: TImageData;
Begin
  If cboSeries.Items.Count <= 1 Then
    Exit;
  Dicomdata := VGear.Dicomdata;
  IObj := VGear.PI_ptrData;
  If Dicomdata = Nil Then
    Exit;

  For i := 0 To cboSeries.Items.Count - 1 Do
  Begin
    If cboSeries.Items[i] <> 'Series' Then
    Begin
      Series := (cboSeries.Items.Objects[i] As TMagSeriesObject);
      If (Series.SeriesName = IObj.DicomSequenceNumber) Then
      Begin
        If Not Series.SeriesNameUpdated Then
        Begin
          Series.SeriesNameUpdated := True;
          If Dicomdata.SeriesDescription <> '' Then
            cboSeries.Items[i] := IObj.DicomSequenceNumber + '-' +
              Dicomdata.SeriesDescription + '(' +
              Inttostr(Series.SeriesImgCount) + ')';
        End;
        cboSeries.ItemIndex := i;
        cboSeries.Hint := cboSeries.Items[i];
        Exit;
      End;
    End;
  End;
End;

Procedure TMag4Viewer.FrameMouseWheelDown(Sender: Tobject; Shift: TShiftState;
  MousePos: TPoint; Var Handled:
  Boolean);
Begin
  OnImageMouseScrollDown(Sender, Shift, MousePos, Handled);
End;

Procedure TMag4Viewer.FrameMouseWheelUp(Sender: Tobject; Shift: TShiftState;
  MousePos: TPoint; Var Handled:
  Boolean);
Begin
  OnImageMouseScrollUp(Sender, Shift, MousePos, Handled);
End;

Procedure TMag4Viewer.ApplyViewerState(Viewer: IMag4Viewer);
Begin
    //jw 11/16/07
    {TODO: state change subject.  Look into existing way of notifying subscribers of state change.}
    //self.FPanWindow := viewer.PanWindow;
    // JMW 7/14/08 p72t23 - set and apply the pan window state
  SetPanWindow(Viewer.GetPanWindow());
  Self.FApplytoall := Viewer.ApplyToAll;
End;

////////////////////// 59 start section
(*

-    ScrollCornerBL;  //Scroll the Image to Corner
-    ScrollCornerBR;  //Scroll the Image to Corner
-    ScrollCornerTL;  //Scroll the Image to Corner
-    ScrollCornerTR;  //Scroll the Image to Corner
-    ScrollDown;  //Scroll the Image by small scroll inc.
-    ScrollLeft;  //Scroll the Image by small scroll inc.
-    ScrollRight;  //Scroll the Image by small scroll inc.
-    ScrollUP;  //Scroll the Image by small scroll inc.
-    SetScroll(hval, vval : integer);// Set scroll at coordinates

   {   Next 4 are made for calls from outside the Viewer,
        for now, the two abstracts Windows.}

    PageNextViewerFocus; //Set focus on Viewer Page
    PagePrevViewerFocus; //Set focus on Viewer Page
    SetAbsSmaller; //size the Abstracts
    SetAbsBigger;  // size the Abstracts

    {	Used by menu items, to send message to Viewer to move to next image.}
-   SelectNextImage(idxinc : integer = 1); //set focus to an Image

    { 	Possible use for ImageByID.  Shows CrossHatch on viewer to mark
       this viewer for visual indication that is it not same patient}

-    ShowHash;
 *)

Procedure TMag4Viewer.SelectNextImage(Idxinc: Integer = 1);
Var
  VGear: TMag4VGear;
  Idx: Integer;
Begin
  VGear := GetCurrentImage;

  Idx := VGear.ListIndex;
  SelectAnImage(Idx + Idxinc);
  VGear := GetCurrentImage;
  VGear.SetFocus;
    // JMW 10/14/2008 p72t27 - need to set the panel focus so the screen reader
    // can read the description (for 508 compliance).
(*  try // setfocus above seems to be enough. (gek)
    vGear.pnlImage.SetFocus;
  except
    on E: Exception do
    begin
      // do nothing, just in case there was an error
    end;
  end;
  //59 otc  vGear.Gear1.SetFocus;
*)
End;

Procedure TMag4Viewer.ShowHash;
Var
  Dim: TImage;
  Rect: Trect;
Begin
  Rect.TopLeft.x := 0;
  Rect.TopLeft.y := 0;
  Rect.BottomRight.x := 1000;
  Rect.BottomRight.y := 1000;
  Dim := TImage.Create(Self);
  Dim.Parent := Scrlv;
  Dim.Align := alClient;
  Dim.Canvas.Brush.Style := bsDiagCross;
  Dim.Canvas.Fillrect(Rect);

End;

Procedure TMag4Viewer.SetScroll(Hval, Vval: Integer);
Var
  i: Integer;
  Iproxy: TImageProxy;
Begin
  Try
    FDisableScrollEvent := True;
    If FApplytoall Then
      For i := 0 To FProxyList.Count - 1 Do
      Begin
        Iproxy := FProxyList[i];
        If Iproxy.Image <> Nil Then
        Begin
                    //Logmsg('s', 'Proxy Image <> Nil: current - ' +
                    //    getcurrentImage.PI_ptrData.Mag0 + ' proxy - ' +
                    //    Iproxy.ImageData.Mag0);
          MagLogger.LogMsg('s', 'Proxy Image <> Nil: current - ' +
            GetCurrentImage.PI_ptrData.Mag0 + ' proxy - ' +
            Iproxy.ImageData.Mag0); {JK 10/5/2009 - MaggMsgu refactoring}
          If GetCurrentImage.PI_ptrData.Mag0 <> Iproxy.ImageData.Mag0 Then
                        //LogMsg('s', 'Setting Scroll ' + inttostr(hval) +
                        //    '   vert ' + inttostr(vval));
            MagLogger.LogMsg('s', 'Setting Scroll ' + Inttostr(Hval) +
              '   vert ' + Inttostr(Vval)); {JK 10/5/2009 - MaggMsgu refactoring}
          TMag4VGear(Iproxy.Image).SetScroll(Hval, Vval);
        End;
      End

    Else
      For i := 0 To FProxyList.Count - 1 Do
      Begin
        Iproxy := FProxyList[i];
        If Iproxy.Image <> Nil Then
          If TMag4VGear(Iproxy.Image).Selected Then
          Begin
            If GetCurrentImage.PI_ptrData.Mag0 <>
              Iproxy.ImageData.Mag0 Then
              TMag4VGear(Iproxy.Image).SetScroll(Hval, Vval);
          End;
      End;

        (*   //Horiz := Gear1.GetScrollPos(0);
          //Vert := Gear1.GetScrollPos(1);
          Gear1.SetScrollPos(0, 4, 0 );
          Gear1.SetScrollPos(1, 4, vert);  *)

          //  self.MagViewer.SetScrollHoriz(imagestate.ScrollHoriz);
          //  self.MagViewer.SetScrollVert(imagestate.ScrollVert);

          /////Gear1.SetScrollPos(0, 4, value);

  Finally
    FDisableScrollEvent := False;
  End;

End;

(*procedure TMag4Viewer.GearScroll(ASender: TObject; Scrolltype: Integer);
var vGear : Tmag4vgear;
begin
//

if FApplyToAll then
  begin
  maggmsgf.MagMsg('s','Handle : '+ inttostr(TGear(Asender).handle));
  maggmsgf.MagMsg('s','Handle : '+ inttostr(GetCurrentImage.Gear1.handle));
  if GetCurrentImage.Gear1 = (ASender as TGear) then
     begin
     maggmsgf.MagMsg('s','current image = ASender');
     //if GetCurrentImage.gear1.Handle = TGear(Asender).Handle then
     SetScroll(cur4image.Gear1.GetScrollPos(0),cur4image.Gear1.GetScrollPos(1));

     end;
  end;

end;  *)

Procedure TMag4Viewer.ScrollCornerTL;
Var
  i: Integer;
  Iproxy: TImageProxy;
Begin
  If FApplytoall Then
    For i := 0 To FProxyList.Count - 1 Do
    Begin
      Iproxy := FProxyList[i];
      If Iproxy.Image <> Nil Then
                //TMag4Vgear(Iproxy.Image).ScrollCornerTL;
      Begin
                //59             TMag4Vgear(Iproxy.Image).Gear1.SetScrollPos(0, 4, 0);
                //59             TMag4Vgear(Iproxy.Image).Gear1.SetScrollPos(1, 4, 0);
        TMag4VGear(Iproxy.Image).SetScrollPos(-9999, -9999);
      End;

    End
  Else
    For i := 0 To FProxyList.Count - 1 Do
    Begin
      Iproxy := FProxyList[i];
      If Iproxy.Image <> Nil Then
        If TMag4VGear(Iproxy.Image).Selected Then
                    //TMag4Vgear(Iproxy.Image).ScrollCornerTL;
        Begin
          TMag4VGear(Iproxy.Image).SetScrollPos(-9999, -9999)
        End;
    End;
End;

Procedure TMag4Viewer.ScrollCornerTR;
Var
  i: Integer;
  Iproxy: TImageProxy;
Begin
  If FApplytoall Then
    For i := 0 To FProxyList.Count - 1 Do
    Begin
      Iproxy := FProxyList[i];
      If Iproxy.Image <> Nil Then
                //TMag4Vgear(Iproxy.Image).ScrollCornerTR;
      Begin
        TMag4VGear(Iproxy.Image).SetScrollPos(-9999, 9999);
      End;
    End
  Else
    For i := 0 To FProxyList.Count - 1 Do
    Begin
      Iproxy := FProxyList[i];
      If Iproxy.Image <> Nil Then
        If TMag4VGear(Iproxy.Image).Selected Then
                    //TMag4Vgear(Iproxy.Image).ScrollCornerTR;
        Begin
          TMag4VGear(Iproxy.Image).SetScrollPos(-9999, 9999);
        End;
    End;
End;

Procedure TMag4Viewer.ScrollCornerBL;
Var
  i: Integer;
  Iproxy: TImageProxy;
Begin
  If FApplytoall Then
    For i := 0 To FProxyList.Count - 1 Do
    Begin
      Iproxy := FProxyList[i];
      If Iproxy.Image <> Nil Then
                //TMag4Vgear(Iproxy.Image).ScrollCornerBL;
      Begin
        TMag4VGear(Iproxy.Image).SetScrollPos(9999, -9999);
      End;
    End
  Else
    For i := 0 To FProxyList.Count - 1 Do
    Begin
      Iproxy := FProxyList[i];
      If Iproxy.Image <> Nil Then
        If TMag4VGear(Iproxy.Image).Selected Then
                    //TMag4Vgear(Iproxy.Image).ScrollCornerBL;
        Begin
          TMag4VGear(Iproxy.Image).SetScrollPos(9999, -9999);
        End;
    End;
End;

Procedure TMag4Viewer.ScrollCornerBR;
Var
  i: Integer;
  Iproxy: TImageProxy;
Begin
  If FApplytoall Then
    For i := 0 To FProxyList.Count - 1 Do
    Begin
      Iproxy := FProxyList[i];
      If Iproxy.Image <> Nil Then
                //TMag4Vgear(Iproxy.Image).ScrollCornerBR;
      Begin
        TMag4VGear(Iproxy.Image).SetScrollPos(9999, 9999);
      End;
    End
  Else
    For i := 0 To FProxyList.Count - 1 Do
    Begin
      Iproxy := FProxyList[i];
      If Iproxy.Image <> Nil Then
        If TMag4VGear(Iproxy.Image).Selected Then
                    //TMag4Vgear(Iproxy.Image).ScrollCornerBR;
        Begin
          TMag4VGear(Iproxy.Image).SetScrollPos(9999, 9999);
        End;

    End;
End;

Procedure TMag4Viewer.ScrollLeft;
Var
  i, Scr: Integer;
  Iproxy: TImageProxy;
Begin
  If FApplytoall Then
    For i := 0 To FProxyList.Count - 1 Do
    Begin
      Iproxy := FProxyList[i];
      If Iproxy.Image <> Nil Then //TMag4Vgear(Iproxy.Image).ScrollLeft;
      Begin
        TMag4VGear(Iproxy.Image).ScrollLeft();
                //59 otc  all of these Incremental Scroll Changes need a call to work.
                //              scr := TMag4Vgear(Iproxy.Image).Gear1.GetScrollPos(0);
                //              if scr < 10 then scr := 10;
                //              TMag4Vgear(Iproxy.Image).Gear1.SetScrollPos(0, 4, scr -10 );
      End;
    End
  Else
    For i := 0 To FProxyList.Count - 1 Do
    Begin
      Iproxy := FProxyList[i];
      If Iproxy.Image <> Nil Then
        If TMag4VGear(Iproxy.Image).Selected Then
                    //TMag4Vgear(Iproxy.Image).ScrollLeft;
        Begin
          TMag4VGear(Iproxy.Image).ScrollLeft();
                    //59 otc              scr := TMag4Vgear(Iproxy.Image).Gear1.GetScrollPos(0);
                    //              if scr < 10 then scr := 10;
                    //              TMag4Vgear(Iproxy.Image).Gear1.SetScrollPos(0, 4, scr -10 );
        End;

    End;
End;

Procedure TMag4Viewer.ScrollRight;
Var
  i, Scr: Integer;
  Iproxy: TImageProxy;
Begin
  If FApplytoall Then
    For i := 0 To FProxyList.Count - 1 Do
    Begin
      Iproxy := FProxyList[i];
      If Iproxy.Image <> Nil Then //TMag4Vgear(Iproxy.Image).ScrollRight;
      Begin
        TMag4VGear(Iproxy.Image).ScrollRight();
                //59   otc           scr := TMag4Vgear(Iproxy.Image).Gear1.GetScrollPos(0);
                //              TMag4Vgear(Iproxy.Image).Gear1.SetScrollPos(0, 4, scr + 10 );
      End;
    End
  Else
    For i := 0 To FProxyList.Count - 1 Do
    Begin
      Iproxy := FProxyList[i];
      If Iproxy.Image <> Nil Then
        If TMag4VGear(Iproxy.Image).Selected Then
                    //TMag4Vgear(Iproxy.Image).ScrollRight;
        Begin
          TMag4VGear(Iproxy.Image).ScrollRight();
                    //59 otc               scr := TMag4Vgear(Iproxy.Image).Gear1.GetScrollPos(0);
                    //              TMag4Vgear(Iproxy.Image).Gear1.SetScrollPos(0, 4, scr + 10 );
        End;

    End;
End;

Procedure TMag4Viewer.ScrollUp;
Var
  i, Scr: Integer;
  Iproxy: TImageProxy;
Begin
  If FApplytoall Then
    For i := 0 To FProxyList.Count - 1 Do
    Begin
      Iproxy := FProxyList[i];
      If Iproxy.Image <> Nil Then //TMag4Vgear(Iproxy.Image).ScrollUP;
      Begin
        TMag4VGear(Iproxy.Image).ScrollUp();
                //59 otc               scr := TMag4Vgear(Iproxy.Image).Gear1.GetScrollPos(1);
                //              if scr < 10 then scr := 10;
                //              TMag4Vgear(Iproxy.Image).Gear1.SetScrollPos(1, 4, scr - 10 );
      End;
    End
  Else
    For i := 0 To FProxyList.Count - 1 Do
    Begin
      Iproxy := FProxyList[i];
      If Iproxy.Image <> Nil Then
        If TMag4VGear(Iproxy.Image).Selected Then
                    //TMag4Vgear(Iproxy.Image).ScrollUP;
        Begin
          TMag4VGear(Iproxy.Image).ScrollUp();
                    //59 otc               scr := TMag4Vgear(Iproxy.Image).Gear1.GetScrollPos(1);
                    //              if scr < 10 then scr := 10;
                    //              TMag4Vgear(Iproxy.Image).Gear1.SetScrollPos(1, 4, scr - 10 );
        End;

    End;
End;

Procedure TMag4Viewer.ScrollDown;
Var
  i, Scr: Integer;
  Iproxy: TImageProxy;
Begin
  If FApplytoall Then
    For i := 0 To FProxyList.Count - 1 Do
    Begin
      Iproxy := FProxyList[i];
      If Iproxy.Image <> Nil Then //TMag4Vgear(Iproxy.Image).ScrollDown;
      Begin
        TMag4VGear(Iproxy.Image).ScrollDown();
                //59 otc               scr := TMag4Vgear(Iproxy.Image).Gear1.GetScrollPos(1);
                //              TMag4Vgear(Iproxy.Image).Gear1.SetScrollPos(1, 4, scr + 10 );
      End;
    End
  Else
    For i := 0 To FProxyList.Count - 1 Do
    Begin
      Iproxy := FProxyList[i];
      If Iproxy.Image <> Nil Then
        If TMag4VGear(Iproxy.Image).Selected Then
                    //TMag4Vgear(Iproxy.Image).ScrollDown;
        Begin
          TMag4VGear(Iproxy.Image).ScrollDown();
                    //59 otc               scr := TMag4Vgear(Iproxy.Image).Gear1.GetScrollPos(1);
                    //              TMag4Vgear(Iproxy.Image).Gear1.SetScrollPos(1, 4, scr + 10 );
        End;

    End;
End;

(*
//59 but out for now.
procedure TMag4Viewer.ImageVScroll(sender: Tobject; vGear: TMag4VGear; hpos, vpos: integer);
begin
 maggmsgf.MagMsg('s','ImageVScroll Event');
 maggmsgf.MagMsg('s','ScrollDisabled: ' +  magbooltostr(FDisableScrollEvent));
 if not FDisableScrollEvent then
   begin
   maggmsgf.MagMsg('s','Not disabled...  Cur: '+GetCurrentImage.PI_ptrData.Mag0 + '  sender: '+vGear.PI_ptrData.Mag0);

   if GetCurrentImage.PI_ptrData.Mag0 = vGear.PI_ptrData.Mag0
      then SetScroll(hpos,vpos);
   end
   else maggmsgf.MagMsg('s','Scrolling Disabled');

end;
*)

Function TMag4Viewer.GetIndexAtDropPoint(x, y: Integer): Integer;
Var
  r, Rct, c, cct: Integer;
  Rfind, cfind: Integer;
  Done: Boolean;
Begin
  Rfind := 0;
  cfind := 0;
  Done := False;
  If Self.GetImageCount = 0 Then
    Result := 0
  Else
  Begin
    r := 1; {row }
    c := 1; {column }
    While Not Done Do
    Begin
      If y < (r * (FbaseH + FRowsp)) Then
        Rfind := r
      Else
        r := r + 1;
      If x < (c * (FbaseW + FColsp)) Then
        cfind := c
      Else
        c := c + 1;
      If ((Rfind > 0) And (cfind > 0)) Then
        Done := True;
    End;
    Self.VisibleRowCol(Rct, cct);

    If FScrollVertical Then
    Begin
      r := r - 1;
      If r = 0 Then
        Result := c - 1
      Else
        Result := (r * cct) + c - 1;
    End
    Else
    Begin
      c := c - 1;
      If c = 0 Then
        Result := r - 1
      Else
        Result := (c * Rct) + r - 1;
    End;
  End;
End;

Procedure TMag4Viewer.SetAnnotationStyle(AnnotationStyle: TMagAnnotationStyle);
Var
  i: Integer;
  Iproxy: TImageProxy;
Begin
  FAnnotationStyle := AnnotationStyle;
  For i := 0 To FProxyList.Count - 1 Do
  Begin
    Iproxy := FProxyList[i];
    If Iproxy.Image <> Nil Then
    Begin
      Iproxy.Image.SetAnnotationStyle(FAnnotationStyle);
    End;
  End;
End;

Procedure TMag4Viewer.SetAnnotationStyleChangeEvent(Value:
  TMagAnnotationStyleChangeEvent);
Begin
  FMagAnnotationStyleChangeEvent := Value;
End;

Procedure TMag4Viewer.SetPanWindowClose(Value: TMagPanWindowCloseEvent);
Var
  i: Integer;
  Iproxy: TImageProxy;
Begin
  FPanWindowClose := Value;
  For i := 0 To FProxyList.Count - 1 Do
  Begin
    Iproxy := FProxyList[i];
    If Iproxy.Image <> Nil Then
    Begin
      Iproxy.Image.OnPanWindowClose := FPanWindowClose;
    End;
  End;
End;

Procedure TMag4Viewer.PanWindowCloseEvent(Sender: Tobject);
Begin
  If Assigned(FPanWindowClose) Then
    FPanWindowClose(Sender);
End;
/////////////////////////////

Procedure TMag4Viewer.RemoveOneFromList(VIobj: TImageData);
Var
  i: Integer;
  Iproxy: TImageProxy;
  Undotext: String;
Begin
  Undotext := 'UnDo - Remove Image';
  UnDoGroupingNew; //RemoveFromList
    { not doing => if FApplytoAll then..... for RemoveFromList.
       Intent is to remove the selected, not all.
       if (SelectedCount > 0) then {}

    (* FUnDoList.add(TMagCaptionedList.create);
       TList(FUnDoList(FUnDoList.Count-1)). *)
  For i := FProxyList.Count - 1 Downto 0 Do
  Begin
    Iproxy := FProxyList[i];
    If Iproxy.ImageData <> Nil Then
      If Iproxy.ImageData.Mag0 = VIobj.Mag0 Then
      Begin
        Case FViewerStyle Of
          MagvsStaticPage:
            Begin
                            //  do nothing in staticpage style
            End;
          MagvsDynamic:
            Begin
              DeleteProxy(i);
              Break;
                            (*
                             UnDoListAddItem(UnDotext, TImageProxy(FProxyList[i]), magundoRemove); //ClearViewer;
                             TImageProxy(FProxyList[i]).Image.Visible := false;
                             FProxyList.Delete(i);
                             *)
            End;
          MagvsVirtual:
            Begin
                            //do nothing in magvsVirtual style
                            //  ?? HideProxy(i);
            End;
        End;
                // TMag4Vgear(Iproxy.Image).MouseZoom;
      End;
  End;

  Cur4Image := Nil;

  If Assigned(OnViewerImageClick) Then
    OnViewerImageClick(Cur4Image);
  If Assigned(OnViewerClick) Then
    OnViewerClick(Self, Self, Cur4Image);
  RefreshViewerDesc;
End;

Procedure TMag4Viewer.SetMouseZoomShape(Value: TMagMouseZoomShape);
Var
  i: Integer;
  Iproxy: TImageProxy;
Begin
  FMouseZoomShape := Value;
  For i := 0 To FProxyList.Count - 1 Do
  Begin
    Iproxy := FProxyList[i];
    If Iproxy.Image <> Nil Then
      TMag4VGear(Iproxy.Image).setMouseZoomShape(FMouseZoomShape);
  End
End;

Function TMag4Viewer.getMouseZoomShape(): TMagMouseZoomShape;
Begin
  Result := FMouseZoomShape;
End;

Function TMag4Viewer.GetCur4Image: TMag4VGear;
Begin
  Result := FCur4Image;
End;

Procedure TMag4Viewer.SetCur4Image(Const Value: TMag4VGear);
Begin
  If FCur4Image = Value Then Exit;
  FCur4Image := Value;
End;



{/gek //117}
function TMag4Viewer.GetShowImageStatus: boolean;
begin
 result := FShowImageStatus;
end;
{/gek //117}
procedure TMag4Viewer.SetShowImageStatus(value: boolean);
begin
FShowImageStatus := value;
end;

End.
