unit uMagrMakeAbsR2;
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
interface
uses
Windows, Messages, SysUtils, Classes, Graphics, Controls,
Forms, Dialogs, comctrls, GearFORMATSLib_TLB, AxCtrls, GearVIEWLib_TLB,
GearDISPLAYLib_TLB, GearPROCESSINGLib_TLB, OleCtrls, GearCORELib_TLB,
GearDIALOGSLib_TLB, comobj, GearMEDLib_TLB, uMagRMakeAbsError;{MEDXLib_TLB,}
{GEARLib_TLB,} {DataDict, dcm, geardef, geardef7,}  {magriimage, magrgeartrans}

procedure MakeAbs(gearnum: integer; FileName: string; DestFile: string; Format: string; Quality: integer; ErrFileName: string);
Procedure MakeAbsEntry;

type
  TDisplayRecord = record
    NumColumns: integer;
    NumRows: integer;
//    FirstIndexonpage: integer;{ImageIndex of first image on page currently showing}
//    displaymode: string; {STACK, LAYOUT}
//    loadmode: string; {HOLDSETTINGS, STACK, LAYOUT}
//    LayoutLoadMode: string; {WIN1, OWN}
    initmode: string;
//    StackPageMode: string;{DIFF, SAME}
//    LayoutPageMode: string; {WIN1, OWN}
//    LastIndexLoaded: integer;
//    LastCtrlUsed: integer; {used when ctrls are not all used}
//    LoadFromWhere: string; {DISPLAYAPP, RELOAD}
    winset: array [1..2] of integer;
    levset: array [1..2] of integer;
    zoomset: array [1..2] of integer;
//    rotateset: array [1..2] of integer;
//    flipHset: array [1..2] of integer;
//    flipVset: array [1..2] of integer;
//    CTUnits: string; {Houns, Pixel}
//    PrevStudy: string; {RED 11/20/03}
//    CurrentStudy: string; {RED 11/20/03}
      MakeAbsError: string;
      Image_Handle: longint;
      Filename: string;
    end;
//type TDisplayRecArray = array[1..12] of TDisplayRecord;


var
ViewerRec: TDisplayRecord;
//CTPreset: array [1..9] of string;

implementation

uses frmMagMakeAbsMainForm{, mainform}; //medtest1, DICOMData3;

procedure MakeAbs(gearnum: integer; FileName: string; DestFile: string; Format: string; Quality: integer; ErrFileName: string);
var
ImgWidth, ImgHeight: longint;
NewWidth, NewHeight: longint;
Factor1 : real;
File1, SaveFile: string;
vaLUT: OleVariant;
vaEntries: OleVariant;
nErrcount: integer;
pageInfo: IGFormatPageInfo;
formatIOLocation: IIGIOLocation;
formatCurrentPageNumber: Integer;
formatTotalPageCount: Integer;
resInfo: IGImageResolution;
SaveFormat, SaveQuality, gearFormat, ImgBitDepth: integer;
//currentMedPage: IGMedPage;
//pContrast: IGMedContrast;
MedContrast: IGMedContrast;
MedDataDict: IGMedDataDict;
MinMax: IGMedMinMax;
ConstLongInt: longint;
windowcenter: longint;
currentFormat: IGFormatParams;
currentParameter: IGControlParameter;
SaveMode: enumIGPageSaveModes;
SaveJpegQuality: longint;
FileExt: string;
begin
try

// NEED TO LOAD IMAGE
FileExt :=  copy(ExtractFileExt(FileName),2,3);
{need to check proportions now first}

pageInfo := frmMagMakeAbsMain.IGFormatsCtl1.GetPageInfo(formatIOLocation, formatCurrentPageNumber, IG_FORMAT_UNKNOWN);

//nErrcount := IG_image_dimensions_get( frmmain.currentpage, OriginalWidth, OriginalHeight, &nBpp ); {Sample code from HELP file}

//nErrcount := IG_image_dimensions_get( hIGear, &nWidth, &nHeight, &nBPP); {RED}
Imgwidth := frmMagMakeAbsMain.currentPage.Get_ImageWidth;
ImgHeight := frmMagMakeAbsMain.currentPage.Get_ImageHeight;
ImgBitDepth := frmMagMakeAbsMain.currentPage.Get_bitdepth;

If ImgWidth/189 > ImgHeight/121 then
   Factor1 := ImgWidth / 189
   else Factor1 := ImgHeight / 121;
if factor1=0 then factor1 := 1; {gek 2/13/97}

//If uppercase(copy(Filename, pos('.', FileName), 3)) = 'DCM' then
If FileExt = 'DCM' then
begin

//check bitdepth

end;

//GearFormat := frmMain.IGFormatsCtl1.DetectImageFormat(formatIOlocation);
//showmessage('Format: ' + inttostr(gearformat));
//if gearformat = IG_FORMAT_JPG then showmessage('JPG format');
//GearFormat := frmMain.IGFormatsCtl1.DetectImageFormat;
//gearformat := frmMain.IGformatsctl1.IGFormatPageInfo.format;
//gearbitdepth := frmMain.IGformatsctl1.IGFormatPageInfo.bitdepth;
//IG_LOC_FILE

//
//IG_FORMAT_TGA
//IG_FORMAT_JPG
//IG_FORMAT_TIF
//IG_FORMAT_BMP
//

NewWidth := Trunc(ImgWidth / Factor1); {RED 6/14/96}
NewHeight := Trunc(ImgHeight / Factor1); {RED 6/14/96}

//HIGEAR hIGear;    /* Handle of image to be resized  */
(*AT_DIMENSION nNewWid,   /* New width the image is to be   */
nNewHi;    /* New height   */
AT_DIMENSION nOldWid,   /* Old width of image  */
nOldHi,    /* Old height    */
nBpp;/* Bits per pixel (not used below) */
AT_ERRCOUNT	 	nErrcount; /* Returned count of errors  */
AT_RGB		rgb;       /* color of background; RGB value  */
/* Enlarge image to 1.5 times its present width, but same
height, padding with the green color up to right: */
/* First, obtain current dimensions:
    */
nErrcount = IG_image_dimensions_get ( hIGear1, &nOldWid,
&nOldHi, &nBpp );

if ( nErrcount == 0 )    /* If no errors doing that:  */  *)

(* Multiply no. of pixels per row by 1.5:
	nNewWid = (nOldWid * 3) / 2;
	nNewHi  =  nOldHi;     /* Keep image the same height  */
	(* Resize, with padding:
	rgb.r = 0;
	rgb.g = 255;
	rgb.b = 0; *)

//frmMain.IGCorectl1.ResizeImage(ViewerRec.Image_Handle, NewWidth, NewHeight, IG_INTERPOLATION_NONE);
//frmMain.IGProcessingCtl1.ResizeImage(frmmain.currentpage, NewWidth, NewHeight, IG_INTERPOLATION_NONE);
//IG_IP_resize_bkgrnd ( hIGear, NewWidth, NewHeight, IG_INTERPOLATION_NONE);

//if ( nErrcount } { ... }     /* If errors anywhere above, process
//here  */

//exit;
// to check RGB/PHOTOMETRIC attributes:
//Dim CurrElem As IGMedDataElem
//Dim VRInfo As IGMedVRInfo
//medpage.DataSet.MoveFirst MED_DCM_MOVE_LEVEL_FLOAT
//Set CurrElem = medpage.DataSet.CurrElem
//Set VRInfo = MedDataDict.GetVRInfo(CurrElem.VR)
//
If ((ImgBitDepth > 8) and (ImgBitDepth < 17) {and (frmMain.IGMedCtl1.isgray = true)}) then
begin
//reduce to 8 bits
//currentMedPage := frmMain.igmedctl1.CreateMedPage(frmMain.currentpage);
//MedObj := frmMain.IGMedcontrast.createobject(MED_OBJ_CONTRAST) as IOcontrast;
//frmMain.IGMedDisplay.createobject();

//MedContrast.RescaleIntercept := 0#;
//MedContrast.RescaleSlope := 1#;
//MedContrast.Gamma := 1#;
MedDataDict :=frmMagMakeAbsMain.IGMedCtl1.DataDict;
MedContrast := frmMagMakeAbsMain.IGMedCtl1.CreateObject(MED_OBJ_CONTRAST) as IGMedContrast;//*
//    currentMedPage.Display.AdjustContrastAutoFrom(MedContrast);
// calculate window and level ---------------------------------------------------
If ViewerRec.InitMode = 'HISTO' then // HDR will automatically use DICOM Header information if it is available, then use min/max if not.
begin
    MedContrast.RescaleIntercept := 0.0;
    MedContrast.RescaleSlope := 1.0; {RED}
    MedContrast.Gamma := 1.0;
    frmMagMakeAbsMain.currentMedPage.Display.AdjustContrastAutoFrom(MedContrast);
//  update the view control to repaint the page
    frmMagMakeAbsMain.IGPageViewCtl1.UpdateView;
end;
//----------------------

//    Dim StrMinMax As String

//*    MinMax := frmMain.currentMedPage.Processing.GetMinMax;

//    StrMinMax = "Min = " & MinMax.Min & " " & _
//                "Max = " & MinMax.Max & " " & _
//                "Pixels are "
//*ConstLongInt := 2;
//*windowcenter := Round((MinMax.Min + MinMax.Max)/ConstLongInt);
//*    MedContrast.windowcenter := Round(windowcenter);
//*    IGMedDisplay.MedContrast.windowwidth := Round(MinMax.Max - MinMax.Min);
//*    showmessage('Min = ' + IntToStr(MinMax.Min) + 'Max =  ' + IntToStr(MinMax.Max));
//*    frmMain.currentMedPage.Display.AdjustContrastAutoFrom(MedContrast);
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

//frmMain.IGMeddisplay.AdjustContrastAutoFrom(pContrast As IGMedContrast)
//pcontrast := frmMain.medpage.Display.GetContrastAttrs;
//pContrast.WindowCenter := 4096;
//pContrast.WindowWidth := 1024;
//frmMain.medpage.Display.AdjustContrastAutoFrom(pcontrast);
//frmMain.IGPageViewCtl1.UpdateView;

//frmMain.IGMeddisplay.AdjustContrastAuto(pContrast As IGMedContrast)
//frmMain.igmedctl1.createobject(currentMedPage);
frmMagMakeAbsMain.currentMedpage.Processing.ReduceWithDisplayLUT();
end;
//AT_ERRCOUNT ACCUAPI
(* RUTH - come back to here
MED_IP_reduce_depth_with_LUT(ViewerRec.Image_Handle,
	const LPBYTE lpLUT,
	const DWORD dwEntries);
 *)

If Format='TGA' then SaveFormat:=IG_FORMAT_TGA; {TGA format}
If Format='TIF' then
  begin
  If ((ImgBitDepth > 0) and (ImgBitDepth < 24)) then
    begin
    frmMagMakeAbsMain.IGProcessingctl1.Promote(frmMagMakeAbsMain.currentPage, IG_PROMOTE_TO_24);
    Format := 'JPG';
    end;
// what do we do with bitdepth of 0 ???????
  end;

If Format='JPG' then
   begin
   SaveFormat := IG_FORMAT_JPG ; {IG_SAVE_JPG;}{MAG32}
   SaveJpegQuality := Quality;
   end;
   //--------------------Resize Image----------------------//
frmMagMakeAbsMain.IGProcessingCtl1.ResizeImage(frmMagMakeAbsmain.currentpage, NewWidth, NewHeight, IG_INTERPOLATION_NONE);
//CHOICES:
//IG_INTERPOLATION_BICUBIC
//IG_INTERPOLATION_GRAYSCALE
//IG_INTERPOLATION_NEAREST_NEIGHBOR
//IG_INTERPOLATION_BILINEAR
//IG_INTERPOLATION_AVERAGE
//IG_INTERPOLATION_NONE
//IG_INTERPOLATION_PADDING
//IG_INTERPOLATION_PRESERVE_WHITE
//IG_INTERPOLATION_PRESERVE_BLACK
frmMagMakeAbsMain.IGPageViewCtl1.UpdateView;
   //------------------Set JPG Parameters------------------//
currentFormat := frmMagMakeAbsMain.IGFormatsCtl1.Settings.GetFormatRef(IG_FORMAT_JPG);
currentParameter := currentFormat.GetParamCopy('QUALITY');
currentParameter.Value.Long := SaveJpegQuality;
currentFormat.UpdateParamFrom(currentParameter);
//---------------------------------

File1 :=  ExtractFileName(FileName);
If destfile = '' then DestFile := ChangeFileExt(File1, '.ABS')  // need to update
    else SaveFile := destfile;

frmMagMakeAbsMain.IGFormatsCtl1.SavePageToFile(frmMagMakeAbsmain.currentpage, DestFile, 1, IG_PAGESAVEMODE_DEFAULT, IG_SAVE_JPG);
//IG_SAVE_JPEG2K
except
WriteErrorFile(ErrFileName, '1^Abstract Creation Failed - MakeAbs exception');
frmMagMakeAbsMain.MakeAbsCloseForm;
exit;
end;

if not FileExists(DestFile) then
   begin
showmessage('Image Abstract Not Created');
   end;

exit;
end;

Procedure MakeAbsEntry;
{entry point for MakeAbs functionality}
var
sourcefn, destfn: string;
errfile: string;
FileFormat: string;
Quality: integer;
currentPage: IIGPage;
begin
try
Application.Minimize;
If ParamStr(1)='' then //input file name
  begin
  Application.Minimize;
  ViewerRec.MakeAbsError := '1^No Parameters Sent';  {RED 02/05/04}
  WriteErrorFile('c:\magabserror.txt', ViewerRec.MakeAbsError); {RED 02/05/04}
  frmMagMakeAbsMain.close;
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
  frmMagMakeAbsMain.close;
  exit;
  end;
If Paramstr(1) <> '' then Application.Minimize;  // parameters are present
sourcefn := ParamStr(1);
destfn:=ParamStr(2); // destination file name for abstract
//If destfn = '' then destfn := copy(sourcefn, 1, (pos('.', sourcefn)-1)) + '.abs';
If destfn = '' then destfn := changefileext(sourcefn, '.abs');
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
    frmMagMakeAbsMain.close;
    exit;
    end;
  end;
If quality > 100 then quality := 100;
If quality < 1 then quality := 1;
If ParamStr(5) = 'HISTO' then ViewerRec.InitMode := 'HISTO' else ViewerRec.Initmode := 'HDR'; // Load image using DICOM header or Max/Min pixels in file

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
frmMagMakeAbsMain.CreatePage();
//showmessage(sourcefn);
//----------------------------Load File-----------------------------------//

//need to test for TGA image, 8+ bits

frmMagMakeAbsMain.IGFormatsCtl1.LoadPageFromFile (frmMagMakeAbsMain.currentpage, sourcefn, 0);
//IIGLoadRawOptions  -- to load TGA files
// would like to load into memory so not visible - IIGIOMem

//LoadPageFromFile(Page As IGPage, FileName As String, PageNum As
//Long)

//-------------------------------End Load File----------------------------//
If (copy(ViewerRec.MakeAbsError,1,1)) <> '1' then {did not error out}
  begin
  MakeAbs(1, sourcefn, destfn, FileFormat, Quality, ErrFile); {RED 06/27/03}
  application.processmessages;
  end;
WriteErrorFile(ErrFile, ViewerRec.MakeAbsError);

exit;
except
WriteErrorFile(ErrFile, '1^Abstract Creation Failed - mnuMakeAbs exception');
//frmMain.MakeAbsCloseForm;
exit;
end;
//end;


end;
end.
