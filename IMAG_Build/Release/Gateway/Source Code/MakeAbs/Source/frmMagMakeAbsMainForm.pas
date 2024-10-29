unit frmMagMakeAbsMainForm;

{$DEFINE DISPLAY}

interface

uses
  Windows, Messages, SysUtils, Classes, Graphics, Controls, Forms,
  Dialogs, Menus, GearFORMATSLib_TLB, AxCtrls, GearVIEWLib_TLB,
  GearDISPLAYLib_TLB, GearPROCESSINGLib_TLB, OleCtrls, GearCORELib_TLB,
  GearDIALOGSLib_TLB, comobj, GearMEDLib_TLB, uMagrMakeAbsR2, uMagRMakeAbsError,
  StdCtrls;
  // ,Variants

type
  TfrmMagMakeAbsMain = class(TForm)
    MainMenu1: TMainMenu;
    mnuFileLoad: TMenuItem;
    mnuFileSave: TMenuItem;
    mnuExit: TMenuItem;
    IGFormatsCtl1: TIGFormatsCtl;
    IGProcessingCtl1: TIGProcessingCtl;
    IGDisplayCtl1: TIGDisplayCtl;
    IGPageViewCtl1: TIGPageViewCtl;
    IGDlgsCtl1: TIGDlgsCtl;
    N1: TMenuItem;
    mnuFileInfo: TMenuItem;
    N2: TMenuItem;
    Help1: TMenuItem;
    About1: TMenuItem;
    mnuView: TMenuItem;
    ZoomIn1: TMenuItem;
    ZoomOut1: TMenuItem;
    ZoomReset1: TMenuItem;
    Settings1: TMenuItem;
    mnuComponents1: TMenuItem;
    File1: TMenuItem;
    mnuMakeAbs1: TMenuItem;
    mnuAdjust1: TMenuItem;
    mnuAutoWinLev1: TMenuItem;
    mnuMaxMin1: TMenuItem;
    menuReduceTo8Bits1: TMenuItem;
    mnuColor1: TMenuItem;
    mnuGreenOnly1: TMenuItem;
    mnuBlueOnly: TMenuItem;
    mnuRedOnly1: TMenuItem;
    mnuSwapRedandBlue1: TMenuItem;
    mnuDataSet: TMenuItem;
    MnuCheck: TMenuItem;
    IGMedCtl1: TIGMedCtl;
    IGCoreCtl1: TIGCoreCtl;
    File2: TMenuItem;
    procedure FormCreate(Sender: TObject);
    procedure CreatePage();
    procedure resetSampleGlobals();
    procedure FormResize(Sender: TObject);
    procedure mnuFileInfoClick(Sender: TObject);
    procedure ZoomIn1Click(Sender: TObject);
    procedure ZoomOut1Click(Sender: TObject);
    procedure ZoomReset1Click(Sender: TObject);
    procedure mnuComponents1Click(Sender: TObject);
    procedure About1Click(Sender: TObject);
    procedure mnuExitClick(Sender: TObject);
    procedure mnuFileLoadClick(Sender: TObject);
    procedure mnuFileSaveClick(Sender: TObject);
//    Procedure MakeAbsEntry;
    procedure mnuMakeAbs1Click(Sender: TObject);
    Procedure MakeAbsCloseForm;
    procedure FormActivate(Sender: TObject);
    procedure mnuGreenOnly1Click(Sender: TObject);
    procedure mnuSwapRedandBlue1Click(Sender: TObject);
    procedure mnuMaxMin1Click(Sender: TObject);
    procedure mnuAutoWinLev1Click(Sender: TObject);
    procedure MnuCheckClick(Sender: TObject);
    procedure File2Click(Sender: TObject);

  private
    { Private declarations }
  public
    { Public declarations }

    igFileDialog: IGFileDlg;

    // currently active igPage object
    currentPage: IIGPage;
    currentMedPage: IIGMedPage;
    // display for the currently active igPage object
    currentPageDisp: IIGPageDisplay;
    MedPageDisp:  IIGMedDisplay;
    MedDataDict: IGMedDataDict;


    loadOptions: IIGLoadOptions;
    saveOptions: IIGSaveOptions;

    // this object represents the current ioLocation. it could be equal to ioMemoryLocation below!
    ioLocation: IIGIOLocation;
    ioFile: IIGIOFile; //SHD_TEST
    // here is a global ioMemoryLocation object, because we need to save this!!
    ioMemoryLocation: IIGIOMemory;

    currentPageNumber: Integer; // in document mode, this is the current page index in document not file that was last loaded!!!
    totalLocationPageCount: Integer; // in document mode, this is just the number of pages in the file last loaded!!! no other meaning!!!

    procedure CheckErrors();
    procedure SetMenus();

  end;

var
  frmMagMakeAbsMain: TfrmMagMakeAbsMain;

implementation

//uses {FormatInfo,} {Components, About;

{$R *.dfm}

procedure TfrmMagMakeAbsMain.FormCreate(Sender: TObject);
var
OEMLicenseKey : String;

LicenseKey : string;
begin

    // make sure that the ole error mode is enabled
    IGCoreCtl1.Result.NotificationFlags := IG_ERR_OLE_ERROR;

    // licensing stuffs
    {

igcorectl1.License.SetSolutionName('Vista');

  igcorectl1.License.SetSolutionKey(3187320571,2640663994,3596556560,2787111168);

  OEMLicenseKey := '1.0.EIBbMz1IMPR7woRzlABJ4ocvSr4PcHS3BvMvdA4r1JuIpr4Iiz4zSf0oBe43loNIBrMPirpzdriJwINrlvRo1IiJwHNfCopfiququru34owzR';

  OEMLicenseKey := OEMLicenseKey + 'b1bNvRrNJlHwzpf1bcHlHpfSH4rN3irwHc70JiP4q1PcnS7wzlrBHpAl3dIuzdoNHirII134AuH4J1vSH0rcHl70zdIMP0ble4z1PNJweMrivRPNz';

  OEMLicenseKey := OEMLicenseKey + 'N3lrRvuPNriJcbcv1IMH0zBfNeBeR3Ce1I1rCPRvcHuec3RbSrlvMowIN3cqunBruA4qS30rcJpr1IlbMzMowrMJCzizln17uqp7SelJBAMzBfdzd';

  OEMLicenseKey := OEMLicenseKey + 'qCJ0oNIcrwvC30b0TlNA';

igcorectl1.License.SetOEMLicenseKey(OEMLicenseKey);
}

// IG 15
  LicenseKey := '1.0.RiRL10JLtjbIJZt2E9k2cLRmRvcsw9EmPIwmJFEvwswFE4wstD69b4wsPmPX727DC91Zn0CFkmz4JjwDt9b0PsJFn0CjCIzLR2zZtvwgbXc2zmCDA9';
  LicenseKey := LicenseKey + 'tsc0tmA9zX6g7vnjcXnDJ9zj10Aj7mksEiw2AmcFbXJIALt4bI6mzFPinXcmngEDtR1ZzIkF1D1XnIcFwF6sw9zgbD64Cmzics6mkIcsw';
  LicenseKey := LicenseKey + 'Fnm72c9Rgzj7ikD1gk26L1ZAZJI7vnDcsk0EZCXAZ7Lk4nF1InIn4P0wjCj19nDnZJD7sEXzscv7I7ZzZtX70ni6DnvAiz9EmzjPv6gCZ';
  LicenseKey := LicenseKey + 'CF1jCLzgw2JDkXE2tDc01FAj1itIz4626Un24';


  IGCoreCtl1.License.SetSolutionName('Vista');
  IGCoreCtl1.License.SetSolutionKey(3187320571,2640663994,3596556560,2787111168);
  IGCoreCtl1.License.SetOEMLicenseKey(LicenseKey);


    // associate imagegear controls with the core control
    IGCoreCtl1.AssociateComponent (IGFormatsCtl1.ComponentInterface);
    IGCoreCtl1.AssociateComponent (IGDisplayCtl1.ComponentInterface);
    IGCoreCtl1.AssociateComponent (IGProcessingCtl1.ComponentInterface); // processing control just used for creating alphas (resize,etc)
    IGCoreCtl1.AssociateComponent (IGMedCtl1.ComponentInterface); {RED 02/15/05}
    //IGMedCtl1.AssociateComponent (IGcoreCtl1.ComponentInterface);
    // associate gear and formats controls with file dialog
    IGDlgsCtl1.GearCore := IGCoreCtl1.ComponentInterface;
    IGDlgsCtl1.GearFormats := IGFormatsCtl1.ComponentInterface;
    IGDlgsCtl1.GearDisplay := IGDisplayCtl1.ComponentInterface;
    //  create a global load/save file dialog that will be used in the sample
    igFileDialog := IGDlgsCtl1.CreateFileDlg;
    IGDlgsCtl1.Visible := false;


    //  create a global load/save file dialog that will be used in the sample
    igFileDialog := IGDlgsCtl1.CreateFileDlg; // RED added 2/17/07

    // default sample to page mode
    CreatePage();



//mnuAdjust1.visible := false;
//mnuColor1.visible := false;

//look at the command line arguments here and decide what to do
If PARAMSTR(1) <> '' then  // parameters are present, make abstract and terminate
begin
MakeAbsEntry;
frmMagMakeAbsMain.close;
Application.Terminate();
end;
// 2/7/07

    // meta data stuff
    // Load frmMetadata

//MakeAbsEntry;
//frmMagMakeAbsMain.close;


end;

procedure TfrmMagMakeAbsMain.CreatePage();
begin

    // reset all the global sample variables, set them again in a moment
    resetSampleGlobals();

    // create new page and page display objects
    currentPage := IGCoreCtl1.CreatePage;
    currentMedPage := IGMedCtl1.CreateMedPage(currentPage); {RED 03/08/05}
//   MedPage := IGMedCtl1.CreateMedPage(currentPage);
    currentPageDisp := IGDisplayCtl1.CreatePageDisplay(currentPage);
//    currentMedDisp :=  IGMedCtl1.display.create.(MedPage);
////    MedPageDisp := IGMedCtl1.CreateMedDisplayDisp(currentPageDisp);
    // associate new active page display with page view control
    IGPageViewCtl1.PageDisplay := currentPageDisp;
    // IGPageViewCtl1.PageDisplay := nil;

    // update the view control to repaint the new page
    // IGPageViewCtl1.UpdateView;
    // reset menu and caption
    // frmMain.caption = getMainFrameCaption();


meddatadict := IGMedCtl1.DataDict;


    // create new save and load options
    saveOptions := IGFormatsCtl1.CreateObject(IG_FORMATS_OBJ_SAVEOPTIONS) as IIGSaveOptions;
    saveOptions.Format := IG_SAVE_UNKNOWN;
    loadOptions := IGFormatsCtl1.CreateObject(IG_FORMATS_OBJ_LOADOPTIONS) as IIGLoadOptions;
    loadOptions.Format := IG_FORMAT_UNKNOWN;

    SetMenus;

end;


procedure TfrmMagMakeAbsMain.resetSampleGlobals();
begin

    currentPage := nil;
    ioLocation := nil;

    currentPageNumber := -1;
    totalLocationPageCount := 0;

end;

procedure TfrmMagMakeAbsMain.FormResize(Sender: TObject);
begin

try

    //Resize the ImageGear control to track any changes in the main form
    If (frmMagMakeAbsMain.ClientHeight > 0) Then
        IGPageViewCtl1.Height := frmMagMakeAbsMain.ClientHeight;

    If (frmMagMakeAbsMain.ClientWidth > 0) Then
        IGPageViewCtl1.Width := frmMagMakeAbsMain.ClientWidth;

except
    On EOleException do CheckErrors;
end;

end;

procedure TfrmMagMakeAbsMain.mnuFileInfoClick(Sender: TObject);
begin


{
try
    frmFormatInfo.formatIOLocation := ioLocation;

    frmFormatInfo.formatCurrentPageNumber := currentPageNumber;
    frmFormatInfo.formatTotalPageCount := totalLocationPageCount;

    // display the format information dialog
    frmFormatInfo.Show;

    frmFormatInfo.formatIOLocation := nil;
except
    On EOleException do CheckErrors;
end;
           }
end;

procedure TfrmMagMakeAbsMain.ZoomIn1Click(Sender: TObject);
var
    zoomzoom: IGDisplayZoomInfo;
begin

try
    zoomzoom := currentPageDisp.GetZoomInfo(IGPageViewCtl1.hWnd);

    // update zoom object with new values
    zoomzoom.HZoom := zoomzoom.HZoom * 1.25;
    zoomzoom.VZoom := zoomzoom.VZoom * 1.25;
    zoomzoom.mode := IG_DSPL_ZOOM_H_FIXED Or IG_DSPL_ZOOM_V_FIXED;
    // set the zoom object
    currentPageDisp.UpdateZoomFrom (zoomzoom);

    // update the view control to repaint the page
    IGPageViewCtl1.UpdateView;
except
    On EOleException do CheckErrors;
end;

end;

procedure TfrmMagMakeAbsMain.ZoomOut1Click(Sender: TObject);
var
    zoomzoom: IGDisplayZoomInfo;
begin

try
    zoomzoom := currentPageDisp.GetZoomInfo(IGPageViewCtl1.hWnd);

    // update zoom object with new values
    zoomzoom.HZoom := zoomzoom.HZoom / 1.25;
    zoomzoom.VZoom := zoomzoom.VZoom / 1.25;
    zoomzoom.mode := IG_DSPL_ZOOM_H_FIXED Or IG_DSPL_ZOOM_V_FIXED;
    // set the zoom object
    currentPageDisp.UpdateZoomFrom (zoomzoom);

    // update the view control to repaint the page
    IGPageViewCtl1.UpdateView;
except
    On EOleException do CheckErrors;
end;


end;

procedure TfrmMagMakeAbsMain.ZoomReset1Click(Sender: TObject);
var
    zoomzoom: IGDisplayZoomInfo;
begin

try
    zoomzoom := currentPageDisp.GetZoomInfo(IGPageViewCtl1.hWnd);

    // update zoom object with new values
    zoomzoom.mode := IG_DSPL_ZOOM_H_NOT_FIXED Or IG_DSPL_ZOOM_V_NOT_FIXED;
    // set the zoom object
    currentPageDisp.UpdateZoomFrom (zoomzoom);

    // update the view control to repaint the page
    IGPageViewCtl1.UpdateView;
except
    On EOleException do CheckErrors;
end;

end;

procedure TfrmMagMakeAbsMain.mnuComponents1Click(Sender: TObject);
begin
//    frmComponents.Show
end;

procedure TfrmMagMakeAbsMain.CheckErrors();
var
    igResult: IIGResult;
    errorRecord: IGResultRecord;
    errString: String;
begin

    // To prevent Delphi debugger from stopping on ImageGear exceptions,
    // add EOleException to the "Exception Types to Ignore" list
    // Main menu \ Tools \ Debugger Options

    igResult := frmMagMakeAbsMain.IGCoreCtl1.Result;

    If (Not igResult.IsOk) Then
    begin
        errorRecord := igResult.GetRecord(0);
        errString :=
            'ImageGear Error: ' +
            IntToStr(errorRecord.ErrCode) + ' ' +                      // error code
            '[' + IntToStr(errorRecord.Value1) + ', ' +
                  IntToStr(errorRecord.Value2) + ']' + Chr(13) +       // value
            errorRecord.FileName + '(' +                               // file name
            IntToStr(errorRecord.LineNumber) + ')' + Chr(13) +         // line number
            errorRecord.ExtraText;                                     // description
    end
    else
        errString := 'No ImageGear errors on the stack';

    Application.MessageBox(PChar(errString), 'Error has been reported', MB_ICONINFORMATION or MB_OK);

end;

procedure TfrmMagMakeAbsMain.About1Click(Sender: TObject);
begin

    //frmAbout.show;

end;

procedure TfrmMagMakeAbsMain.mnuExitClick(Sender: TObject);
begin
    Close;
end;

procedure TfrmMagMakeAbsMain.mnuFileLoadClick(Sender: TObject);
var
    dialogLoadOptions: IIGFileDlgPageLoadOptions;
begin

try

    dialogLoadOptions := IGDlgsCtl1.CreateFileDlgOptions(IG_FILEDLGOPTIONS_PAGELOADOBJ)
        As IIGFileDlgPageLoadOptions;

    // display the load file dialog
    //     igFileDialog.ParentWindow = Me.hWnd
    igFileDialog.ParentWindow := Handle;
    viewerrec.image_handle := Handle; {RED 03/06/05}
    If (igFileDialog.Show(dialogLoadOptions)) Then
    begin

        // load the page specified by dialog filename

        // reset some of the global sample variables, set them again in a moment
        currentPage.Clear;
        ioLocation := nil;
        currentPageNumber := -1;
        totalLocationPageCount := 0;

        // create io location object used to read in page count
        // if file read successful, it will be used elsewhere (format info dialog, goto page dialog)
        ioLocation := IGFormatsCtl1.CreateObject(IG_FORMATS_OBJ_IOFILE) As IIGIOLocation;
        (ioLocation As IGIOFile).FileName :=
            dialogLoadOptions.FileName;

        // frmMetadata.Init;
        // load the image (could use loadpage here but want to demonstrate loadpagefromfile instead)
        IGFormatsCtl1.LoadPageFromFile (currentPage,
             dialogLoadOptions.FileName,
             dialogLoadOptions.pageNum);
        // no need to create new display for the page since one already exists

        // set the current and total page numbers (sample global)
        currentPageNumber := dialogLoadOptions.pageNum;
        totalLocationPageCount := IGFormatsCtl1.GetPageCount(ioLocation, IG_FORMAT_UNKNOWN);

        // update the view control to repaint the new active page
        IGPageViewCtl1.UpdateView;
        // reset caption
        frmMagMakeAbsMain.caption := dialogloadoptions.filename;
        ViewerRec.Filename := dialogloadoptions.filename;
        // frmMain.caption := getMainFrameCaption();
//        showmessage(frmMain.caption + '    ' + dialogloadoptions.filename);
    End;

    SetMenus;

except
    On EOleException do CheckErrors;

end;

end;

procedure TfrmMagMakeAbsMain.mnuFileSaveClick(Sender: TObject);
var
   dialogSaveOptions: IIGFileDlgPageSaveOptions;
begin

try

    dialogSaveOptions := IGDlgsCtl1.CreateFileDlgOptions(IG_FILEDLGOPTIONS_PAGESAVEOBJ)
        As IIGFileDlgPageSaveOptions;
    dialogSaveOptions.Set_Page(currentPage);

    // display the save file dialog
    igFileDialog.ParentWindow := Handle;
    If (igFileDialog.Show(dialogSaveOptions)) Then
    begin

        // save the page to specified filename
        IGFormatsCtl1.SavePageToFile (currentPage,
            dialogSaveOptions.FileName,
            dialogSaveOptions.pageNum,
            IG_PAGESAVEMODE_DEFAULT,
            dialogSaveOptions.Format)

    End

except
    On EOleException do CheckErrors;
end;

end;


procedure TfrmMagMakeAbsMain.SetMenus();
var
   bEnable: Boolean;
begin

    If (Not (currentPage = nil)) Then
        bEnable := currentPage.IsValid
    Else
        bEnable := False;

    // mnuFile
    mnuFileInfo.Enabled := bEnable;
    mnuFileSave.Enabled := bEnable;

    mnuView.Enabled := bEnable;

end;
 (*
Procedure TfrmMain.MakeAbsEntry;
{entry point for MakeAbs functionality}
var
sourcefn, destfn: string;
errfile: string;
FileFormat: string;
Quality: integer;
begin
If ParamStr(1)='' then //input file name
  begin
  Application.Minimize;
  ViewerRec.MakeAbsError := '1^No Parameters Sent';  {RED 02/05/04}
  WriteErrorFile('c:\magabserror.txt', ViewerRec.MakeAbsError); {RED 02/05/04}
  frmMain.close;
  exit;
  end;
  ViewerRec.MakeAbsError := '0^Success - Abstract Created'; {RED 02/05/04}
If Uppercase(Paramstr(1)) = 'HELP' then
  begin
  showmessage('MAKEABS Parameters:' + #13#10 + #13#10 +
  'Source Files path/filename' + #13#10 +
  'Destination Files path/filename (null string if not supplied)' + #13#10 +
  'Output file format (currently support TGA, JPG, TIF -- JPG is default)' + #13#10 +
  'JPG Compression Quality (integer between 1-100, default=100) null if non-JPG output' + #13#10 +
  'Image Window/Level (HDR = use DICOM header info; HISTO = use Histogram; HDR is default)'
  + #13#10 +'Error File Name (default is c:\magabserror.txt)'
  + #13#10 + #13#10 + 'A space is used as delimiter -- be sure to include');
  MainForm.close;
  exit;
  end;
If Paramstr(1) <> '' then MainForm.AppMinimize;
sourcefn:=ParamStr(1);
destfn:=ParamStr(2); // destination file name for abstract
If destfn = '' then destfn := copy(sourcefn, 1, (pos('.', sourcefn)-1)) + '.abs';
FileFormat:=ParamStr(3); // FileFormat = TGA, JPG, etc
If FileFormat='' then FileFormat:='JPG';
If not((FileFormat='JPG') or (FileFormat='TIF') or (FileFormat='TGA')) then FileFormat := 'JPG';

{need to check for error file name before proceeding}
If ParamStr(6) <> '' then ErrFile := ParamStr(6) else
ErrFile := 'c:\magabserror.txt';
// Change to below for Patch 8
//AppPath := copy(extractfilepath(application.exename), 1, length(extractfilepath(application.exename)) - 1);
//ErrFile := AppPath + '\magabserror.txt';

Quality := 100; {RED 02/24/04}
try
If ParamStr(4) <> '' then
Quality := StrToInt(ParamStr(4)); // JPG Quality
except
  on EConvertError do
    begin
    If ViewerRec.MakeAbsError <> '' then
    WriteErrorFile(ErrFile,'1^Quality Parameter Illegal');
    application.processmessages;
    MainForm.close;
    exit;
    end;
  end;
If quality > 100 then quality := 100;
If quality < 1 then quality := 1;
If ParamStr(5) = 'HISTO' then // Load image using DICOM header or Max/Min pixels in file
  begin
  ViewerRec.InitMode := 'HISTO';
  application.processmessages;
{HDR is the default, so don't need to set it. {**** must be set to match MAKEABS}
end
else
  begin
  ViewerRec.InitMode := 'HDR';
  end;
//If ParamStr(6) <> '' then
//begin
//ErrFile := ParamStr(6);
//  end;
  //X := 0;
//Y := 0;
//If not(ParamStr(7) = '') then
//begin
//If StrToInt(ParamStr(7)) > 0 then X := StrToInt(ParamStr(7)) else X := 189;
//If StrToInt(ParamStr(8)) > 0 then Y := StrToInt(ParamStr(8)) else Y := 121;
//end;

//LOAD FILE HERE
//openanyfile1(frmDCMVIewer, frmDCMViewer.gear1, frmDCMViewer.med1, frmDCMVIewer.pnl1, sourcefn, 1, 0); {RED 04/17/04}

IGFormatsCtl1.LoadPageFromFile (1, sourcefn, 1);

If (copy(ViewerRec.MakeAbsError,1,1)) <> '1' then
  begin
  DICOMR2.MakeAbs(1, sourcefn, destfn, FileFormat, Quality, 0, 0); {RED 06/27/03}
  application.processmessages;
  end;
WriteErrorFile(ErrFile, ViewerRec.MakeAbsError);
MainForm.close;
exit;
{$ENDIF}
end;              *)



procedure TfrmMagMakeAbsMain.mnuMakeAbs1Click(Sender: TObject);
begin
//MakeAbs(1, 'd:\image\A0179068badkowa.dcm','d:\testabs.abs', 'JPG', 75);

//MakeAbs(1, ViewerRec.filename,'', uppercase(copy(ViewerRec.Filename, pos('.', ViewerRec.Filename)+1, 3)), 75, 'c:\magmakeabserror.txt')
try
MakeAbs(1, ViewerRec.filename,'', uppercase(copy(ExtractFileExt(ViewerRec.Filename), 2, 3)), 75, 'c:\magmakeabserror.txt');
except
WriteErrorFile('c:\magmakeabserror.txt', '1^Abstract Creation Failed - mnuMakeAbs exception');
//frmMain.MakeAbsCloseForm;
exit;
end;
end;

Procedure TfrmMagMakeAbsMain.MakeAbsCloseForm;
begin
frmMagMakeAbsMain.close;
exit;
end;
procedure TfrmMagMakeAbsMain.FormActivate(Sender: TObject);
Var
NewFileName: widestring;
begin

If PARAMSTR(1) <> '' then  // parameters are present, so don't show controls
begin
mnuAdjust1.visible := false;
mnuColor1.visible := false;
MakeAbsEntry;
frmMagMakeAbsMain.close;
end;



If ParamStr(1) <> '' then     // parameters are present so use passed filename
begin

NewFileName := ParamStr(1);
IGFormatsCtl1.LoadPageFromFile (currentPage, NewFileName, 0);
frmMagMakeAbsMain.caption := 'Mag_MakeAbs ' + Newfilename;
end;

end;

procedure TfrmMagMakeAbsMain.mnuGreenOnly1Click(Sender: TObject);
var
ct, pgindex: integer;
ch_num: integer;
AnotherPage0, AnotherPage1, ANotherPage2: IIGObject;
AnotherPageDisp: IIGPage;
begin
//IGProcessingctl1.ImageChannels;
IGProcessingctl1.SeparateImageChannels(currentPage, IG_COLOR_SPACE_RGB);
ch_num := IGProcessingctl1.ImageChannels.count;
Showmessage('Channel count: ' + IntToStr(ch_num));

AnotherPage0 := IGCoreCtl1.CreatePage;
AnotherPage0 := IGProcessingCtl1.ImageChannels.Item[0];

AnotherPage1 := IGCoreCtl1.CreatePage;
AnotherPage1 := IGProcessingCtl1.ImageChannels.Item[1];

AnotherPage2 := IGCoreCtl1.CreatePage;
AnotherPage2 := IGProcessingCtl1.ImageChannels.Item[2];

//AnotherPageDisp := IGDisplayCtl1.CreatePageDisplay(AnotherPage0);
//IGPageViewCtl1.PageDisplay := AnotherPageDisp;

//ct := IGProcessingctl1.ImageChannels.count; //(count, 1, 0);
//IGProcessingctl1.ImageChannels.item[1];
//IGProcessingctl1.ImageChannels.item[3];
//igprocessingctl1.update;
//IGProcessingctl1.BlendWithLUT(currentPage, currentpage, IG_COLOR_SPACE_RGB);
//IGFormatsCtl1.combineimagechannel(currentPage);//       (IGProcessingctl1.ImageChannels.item[1], 'c:\testimage.jpg', 1, IG_PAGESAVEMODE_DEFAULT, IG_SAVE_JPG);
//mousewheelhandler
//IGPageViewCtl1.UpdateView;
//IG_COLOR_COMP_G
end;

procedure TfrmMagMakeAbsMain.mnuSwapRedandBlue1Click(Sender: TObject);
begin
IGProcessingCtl1.SwapRedAndBlue(currentPage);
IGPageViewCtl1.UpdateView;
end;

procedure TfrmMagMakeAbsMain.mnuMaxMin1Click(Sender: TObject);
var
    StrMinMax: String;
    IntMin, IntMax: integer;
    windowcenter: integer;
    windowWidth: integer;
    MedContrast: IGMedContrast;
begin
    IntMin := frmMagMakeAbsMain.currentMedPage.Processing.GetMinMax.Min;
    IntMax := frmMagMakeAbsMain.currentMedPage.Processing.GetMinMax.Max;
    MedContrast := frmMagMakeAbsMain.IGMedCtl1.CreateObject(MED_OBJ_CONTRAST) as IGMedContrast;//*
    //    Showmessage('Max: ' + IntToStr(IntMax) + ' Min: ' + IntToSTr(IntMin));
//*    StrMinMax = "Min = " & MinMax.Min & " " & _
//                "Max = " & MinMax.Max & " " & _
//                "Pixels are "
//*ConstLongInt := 2;
   windowcenter := Round((IntMin + IntMax)/2);
//    IGMedDIsplay.MedContrast.set_WindowCenter := Round(windowcenter);
   windowWidth :=  Round(IntMax - IntMin);
//    IGMedDisplay.MedContrast.Set_windowWidth := Round(MinMax.Max - MinMax.Min);
//frmMagMakeAbsMain.currentmedpage.Display.MedContrast.Set_windowWidth := Round(MinMax.Max - MinMax.Min);
//medcontrast.Set_WindowWidth := windowwidth;
//medcontrast.Set_WindowCenter := windowcenter;
//*    showmessage('Min = ' + IntToStr(MinMax.Min) + 'Max =  ' + IntToStr(MinMax.Max));
//*    frmMagMakeAbsMain.currentMedPage.Display.AdjustContrastAutoFrom(MedContrast);
//---------------
//need to multiply by slope / intercept
//---------------
//    If (currentPage.Signed) Then
//        StrMinMax := StrMinMax & "Signed"
//    Else
//        StrMinMx = StrMinMax & "Unsigned"
//    End If

//    MsgBox StrMinMax, , "Min & Max"

//----------------------

//frmMagMakeAbsMain.IGMeddisplay.AdjustContrastAutoFrom(pContrast As IGMedContrast)
//pcontrast := frmMagMakeAbsMain.medpage.Display.GetContrastAttrs;
//pContrast.WindowCenter := 4096;
//pContrast.WindowWidth := 1024;
//frmMagMakeAbsMain.medpage.Display.AdjustContrastAutoFrom(pcontrast);
//frmMagMakeAbsMain.IGPageViewCtl1.UpdateView;

//frmMagMakeAbsMain.IGMeddisplay.AdjustContrastAuto(pContrast As IGMedContrast)
//frmMagMakeAbsMain.igmedctl1.createobject(currentMedPage);
end;

procedure TfrmMagMakeAbsMain.mnuAutoWinLev1Click(Sender: TObject);
begin
//    Dim StrMinMax As String

//*    MinMax := frmMagMakeAbsMain.currentMedPage.Processing.GetMinMax;

//    StrMinMax = "Min = " & MinMax.Min & " " & _
//                "Max = " & MinMax.Max & " " & _
//                "Pixels are "
//*ConstLongInt := 2;
//*windowcenter := Round((MinMax.Min + MinMax.Max)/ConstLongInt);
//*    MedContrast.windowcenter := Round(windowcenter);
//*    IGMedDisplay.MedContrast.windowwidth := Round(MinMax.Max - MinMax.Min);
//*    showmessage('Min = ' + IntToStr(MinMax.Min) + 'Max =  ' + IntToStr(MinMax.Max));
//*    frmMagMakeAbsMain.currentMedPage.Display.AdjustContrastAutoFrom(MedContrast);
//---------------
//need to multiply by slope / intercept
//---------------
//    If (currentPage.Signed) Then
//        StrMinMax := StrMinMax & "Signed"
//    Else
//        StrMinMax = StrMinMax & "Unsigned"
//    End If

//    MsgBox StrMinMax, , "Min & Max"

//----------------------

//frmMagMakeAbsMain.IGMeddisplay.AdjustContrastAutoFrom(pContrast As IGMedContrast)
//pcontrast := frmMagMakeAbsMain.medpage.Display.GetContrastAttrs;
//pContrast.WindowCenter := 4096;
//pContrast.WindowWidth := 1024;
//frmMagMakeAbsMain.medpage.Display.AdjustContrastAutoFrom(pcontrast);
//frmMagMakeAbsMain.IGPageViewCtl1.UpdateView;

//frmMagMakeAbsMain.IGMeddisplay.AdjustContrastAuto(pContrast As IGMedContrast)
//frmMagMakeAbsMain.igmedctl1.createobject(currentMedPage);
end;

procedure TfrmMagMakeAbsMain.MnuCheckClick(Sender: TObject);
var
DataSet: IGMedElemList;
CurrentElem: IGMedDataElem;
CurrentDataDict: IGMedDataDict;
ListStr: String;
TagIndex: Integer;
ItemIndex: Integer;
VRInfo: IGMedVRInfo;
IntArray: IGIntegerArray;
Status: boolean;
TagInfo: IGMedTagInfo;
i: integer;
CurrentTag: Longint;
WindowCenter: Longint;
WindowWidth: Longint;
RescaleIntercept, RescaleSlope: Real;
TagNum: integer;

begin
If (Not currentMedPage.IsDICOMStructurePresent(MED_STRUCTURE_TYPE_DATASET)) Then
begin
Showmessage('Current image does not contain a DataSet');
exit;
end;
DataSet := frmMAgMakeAbsMain.currentMedPage.DataSet;
showmessage('Dataset exists');
If dataset.elemcount < 1 then Showmessage('No dataset elements');
//TagIndex := $00281050;
//TagIndex := MedDataDict.MakeTag(28, 1050);
//TagIndex := $001C065A;
TagIndex := 0;
//TagInfo := frmMagMakeAbsMain.IGMedCtl1.CreateObject(MED_OBJ_TAG_INFO);

//TagInfo.Name = '1050';
//Group := '0028';
//Element := '0028';
//    Group = "&h" & txtGroup
//    Element = "&h" & txtElem
//TagInfo.Tag := MedDataDict.MakeTag(StrToInt(Group), StrToInt(Element));
Dataset.MoveFirst(MED_DCM_MOVE_LEVEL_FLOAT);
//Showmessage(IntToSTr(dataset.currentindex));
for i := 1 to 80 do
begin
//TagIndex := i;
Dataset.MoveNext(MED_DCM_MOVE_LEVEL_FLOAT);
//Status := Dataset.MoveFindFirst(MED_DCM_MOVE_LEVEL_FLOAT, TagIndex);
//If status = true then Showmessage('Tag = ' + IntToSTr(TagIndex));//frmMagMakeAbsMain.Label1.caption := IntToStr(i);
//Showmessage(IntToSTr(dataset.currentindex));
//IGMedElementList.currentelem.GetTag;

If ((DataSet.CurrentElem.ItemType <> AM_TID_META_DOUBLE) and (DataSet.CurrentElem.ItemType <> AM_TID_META_STRING) and (DataSet.CurrentElem.ItemType <> AM_TID_META_BOOL) and (DataSet.CurrentElem.ItemType <> AM_TID_META_DOUBLE) and (DataSet.CurrentElem.ItemType <> AM_TID_RAW_DATA) and (DataSet.CurrentElem.ItemType <> AM_TID_META_FLOAT)) then
begin
//ShowMessage(IntToSTr(DataSet.CurrentElem.tag));
//If Dataset.CurrentElem.tag = 2625616 then windowcenter := DataSet.CurrentElem.long;
If Dataset.CurrentElem.tag = 2625616 then
  begin
  Showmessage('This should be the value: ' + IntToSTr(DataSet.CurrentElem.Long[0])); //shows tag
//  TagNum := CurrentDataDict.GetTagElement(Dataset.CurrentElem.tag);
//  Showmessage('Tag Num: ' + IntToSTr(TagNum));
  end;
end;
//currentelem.tag
//CurrentTag := frmMagMakeAbsMain.MedDataDict.GetTagGroup(CurrentElem.tag);
end;
//If status = true then Showmessage('Found first') else SHowmessage('Did not find element');



end;
procedure TfrmMagMakeAbsMain.File2Click(Sender: TObject);  // RED 2/17/07 somehow was deleted; replaced with sample
//begin
{Loading file}
//procedure TfrmMain.File2Click(Sender: TObject);
var
    dialogLoadOptions: IIGFileDlgPageLoadOptions;
begin

showmessage('File2');
try

    dialogLoadOptions := IGDlgsCtl1.CreateFileDlgOptions(IG_FILEDLGOPTIONS_PAGELOADOBJ)
        As IIGFileDlgPageLoadOptions;

    // display the load file dialog
    //     igFileDialog.ParentWindow = Me.hWnd
    igFileDialog.ParentWindow := Handle;
    // viewerrec.image_handle := Handle; {RED 03/06/05}  might be needed RED 2/17/07
    If (igFileDialog.Show(dialogLoadOptions)) Then
    begin

        // load the page specified by dialog filename

        // reset some of the global sample variables, set them again in a moment
        currentPage.Clear;
        ioLocation := nil;
        currentPageNumber := -1;
        totalLocationPageCount := 0;

        // create io location object used to read in page count
        // if file read successful, it will be used elsewhere (format info dialog, goto page dialog)
        ioLocation := IGFormatsCtl1.CreateObject(IG_FORMATS_OBJ_IOFILE) As IIGIOLocation;
        (ioLocation As IGIOFile).FileName :=
            dialogLoadOptions.FileName;

        // frmMetadata.Init;
        // load the image (could use loadpage here but want to demonstrate loadpagefromfile instead)
        IGFormatsCtl1.LoadPageFromFile (currentPage, dialogLoadOptions.FileName, dialogLoadOptions.pageNum);
        // no need to create new display for the page since one already exists

        // set the current and total page numbers (sample global)
        currentPageNumber := dialogLoadOptions.pageNum;
        totalLocationPageCount := IGFormatsCtl1.GetPageCount(ioLocation, IG_FORMAT_UNKNOWN);
        frmMagMakeAbsMain.caption := dialogloadoptions.FileName;
        IGPageViewCtl1.UpdateView;
        ViewerRec.Filename := dialogloadoptions.filename;
        // update the view control to repaint the new active page
        IGPageViewCtl1.UpdateView;
//        GetMedContrast;  will need to fix this
    End;

    SetMenus;

  except
      On EOleException do CheckErrors;
   end;
end;

//end;

end.
