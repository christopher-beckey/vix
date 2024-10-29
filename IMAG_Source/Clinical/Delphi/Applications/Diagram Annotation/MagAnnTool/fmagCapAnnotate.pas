unit fmagCapAnnotate;

interface

uses
  Windows, Messages, SysUtils, Classes, Graphics, Controls, Forms, Dialogs,
  StdCtrls, OleCtrls, AnnotationOCX_TLB, Menus, Buttons, AxCtrls, DbOleCtl,
  ComCtrls, ToolWin, Maggut1, About1, fileOpenDialog, MagAnnOCX_TLB, magpositions;

type
  TfrmCapAnnotate = class(TForm)
    OpenDialog1: TOpenDialog;
    SaveDialog1: TSaveDialog;
    MainMenu1: TMainMenu;
    mnuFile: TMenuItem;
    mnuFileOpen: TMenuItem;
    mnuView: TMenuItem;
    mnuViewToWidth: TMenuItem;
    mnuViewToHeight: TMenuItem;
    mnuViewBestFit: TMenuItem;
    mnuViewZoomStandard: TMenuItem;
    mnuAnnotations: TMenuItem;
    mnuAnnotationsPointer: TMenuItem;
    mnuAnnotationsFreehandLine: TMenuItem;
    mnuAnnotationsStraightLine: TMenuItem;
    mnuAnnotationsFilledRectangle: TMenuItem;
    mnuAnnotationsHollowRectangle: TMenuItem;
    mnuAnnotationsTypedText: TMenuItem;
    mnuAnnotationsArrow: TMenuItem;
    mnuAnnotationsPlus: TMenuItem;
    mnuAnnotationsMinus: TMenuItem;
    N2: TMenuItem;
    mnuAnnotationsDeleteAnnotation: TMenuItem;
    mnuAnnotationsClearAnnotations: TMenuItem;
    mnuOptions: TMenuItem;
    mnuOptionsClearDisplay: TMenuItem;
    FontDialog1: TFontDialog;
    ColorDialog1: TColorDialog;
    mnuOptionsBar2: TMenuItem;
    mnuOptionsTextFont: TMenuItem;
    mnuOptionsTextColor: TMenuItem;
    mnuOptionsLineColor: TMenuItem;
    mnuOptionsBar3: TMenuItem;
    mnuOptionsFillColor: TMenuItem;
    mnuLineWidth: TMenuItem;
    mnuOptionsBar4: TMenuItem;
    mnuOptionsAnnotationsOpaque: TMenuItem;
    mnuOptionsAnnotationsTranslucent: TMenuItem;
    mnuHelp: TMenuItem;
    mnuHelpContents: TMenuItem;
    AnnTool1: TAnnTool;
    mnuLineWidthThin: TMenuItem;
    mnuLineWidthMedium: TMenuItem;
    mnuLineWidthThick: TMenuItem;
    StatusBar1: TStatusBar;
    ToolBar1: TToolBar;
    btnOpen: TBitBtn;
    ToolButton1: TToolButton;
    btnPointer: TBitBtn;
    btnfreeline: TBitBtn;
    btnStraightLine: TBitBtn;
    btnFilledRectangle: TBitBtn;
    btnHollowRectangle: TBitBtn;
    btnTypedText: TBitBtn;
    btnArrow: TBitBtn;
    btnPlus: TBitBtn;
    btnMinus: TBitBtn;
    btnSpace1: TToolButton;
    btnToWidth: TBitBtn;
    btnToHeight: TBitBtn;
    btnZoomStandard: TBitBtn;
    btnBestFit: TBitBtn;
    lblZoomLabel: TLabel;
    lblZoom: TLabel;
    sbrZoom: TScrollBar;
    btnSave: TBitBtn;
    mnuFileImageComplete: TMenuItem;
    mnuFileCancelImage: TMenuItem;
    N6: TMenuItem;
    btnSpace2: TToolButton;
    mnuEdit: TMenuItem;
    mnuEditSelectAll: TMenuItem;
    N7: TMenuItem;
    mnuClearSelectedAnnotations: TMenuItem;
    mnuClearAllAnnotations: TMenuItem;
    mnuHelpAbout: TMenuItem;
    mnuOptionsBar1: TMenuItem;
    mnuOptionsColor: TMenuItem;
    mnuOptionsBlackWhite: TMenuItem;
    N1: TMenuItem;
    mnuFileClearImage: TMenuItem;
    procedure sbrZoomChange(Sender: TObject);
    procedure FormResize(Sender: TObject);
    procedure mnuFileOpenClick(Sender: TObject);

    procedure mnuViewToWidthClick(Sender: TObject);
    procedure mnuViewBestFitClick(Sender: TObject);
    procedure mnuViewToHeightClick(Sender: TObject);
    procedure mnuViewZoomStandardClick(Sender: TObject);
    procedure mnuAnnotationsDeleteAnnotationClick(Sender: TObject);
    procedure mnuAnnotationsClearAnnotationsClick(Sender: TObject);
    procedure mnuAnnotationsPointerClick(Sender: TObject);
    procedure mnuAnnotationsFreehandLineClick(Sender: TObject);
    procedure mnuAnnotationsStraightLineClick(Sender: TObject);
    procedure mnuAnnotationsArrowClick(Sender: TObject);
    procedure mnuAnnotationsMinusClick(Sender: TObject);
    procedure mnuAnnotationsFilledRectangleClick(Sender: TObject);
    procedure mnuAnnotationsHollowRectangleClick(Sender: TObject);
    procedure mnuAnnotationsTypedTextClick(Sender: TObject);
    procedure mnuAnnotationsPlusClick(Sender: TObject);
    procedure mnuOptionsTextFontClick(Sender: TObject);
    procedure mnuOptionsTextColorClick(Sender: TObject);
    procedure mnuOptionsLineColorClick(Sender: TObject);
    procedure mnuOptionsFillColorClick(Sender: TObject);
    procedure mnuOptionsAnnotationsOpaqueClick(Sender: TObject);
    procedure mnuOptionsAnnotationsTranslucentClick(Sender: TObject);
    procedure FormCreate(Sender: TObject);
    procedure ClearChecks();
    procedure ClearViews();
    procedure ClearWidths();
    procedure SetColorOptions(value : boolean);
    procedure mnuHelpContentsClick(Sender: TObject);
    procedure FormClose(Sender: TObject; var Action: TCloseAction);
    procedure mnuLineWidthThinClick(Sender: TObject);
    procedure mnuLineWidthMediumClick(Sender: TObject);
    procedure mnuLineWidthThickClick(Sender: TObject);
    procedure btnOpenClick(Sender: TObject);
    procedure btnPointerClick(Sender: TObject);
    procedure btnfreelineClick(Sender: TObject);
    procedure btnStraightLineClick(Sender: TObject);
    procedure btnFilledRectangleClick(Sender: TObject);
    procedure btnHollowRectangleClick(Sender: TObject);
    procedure btnTypedTextClick(Sender: TObject);
    procedure btnArrowClick(Sender: TObject);
    procedure btnPlusClick(Sender: TObject);
    procedure btnMinusClick(Sender: TObject);
    procedure btnToWidthClick(Sender: TObject);
    procedure btnToHeightClick(Sender: TObject);
    procedure btnBestFitClick(Sender: TObject);
    procedure btnZoomStandardClick(Sender: TObject);
    procedure mnuFileImageCompleteClick(Sender: TObject);
    procedure mnuFileCancelImageClick(Sender: TObject);
    procedure mnuClearSelectedAnnotationsClick(Sender: TObject);
    procedure mnuClearAllAnnotationsClick(Sender: TObject);
    procedure btnSaveClick(Sender: TObject);
    procedure mnuHelpAboutClick(Sender: TObject);
    procedure mnuOptionsColorClick(Sender: TObject);
    procedure mnuOptionsBlackWhiteClick(Sender: TObject);
    procedure AnnTool1KeyDown(Sender: TObject; var KeyCode,
      Shift: Smallint);
    procedure mnuFileClearImageClick(Sender: TObject);
    function MagIsXP: boolean;

  private
//    function GetINIDirectory() : String;
    function GetImagingDirectory() : String; //JMW 9/24/2004
    { Private declarations }

  public
    function Execute(dir : string; temp : string; var description: string; RootDir : string; var Extension : string) : boolean;
    { Public declarations }
  end;


var
  frmCapAnnotate: TfrmCapAnnotate; // the annotation form
  fname: string; // the file name of the image
  directory: string; // the start directory for the user
  RootDirectory : string; // the root directory where the user cannot go above for files
  XP : boolean;



implementation

//uses Unit2;

{$R *.DFM}


//function TfrmCapAnnotate.GetINIDirectory() : String;
// JMW 9/24/2004
function TfrmCapAnnotate.GetImagingDirectory() : String;
var
 Path : PChar;
 len, i : integer;
 directory : String;
begin
  GetMem(Path, 255); // get the filename
    if (Path <> nil) then // if its not nothing
  GetModuleFileName(hInstance, Path, 254); // get the module name
  len := MAGLENGTH(Path, '\');
  directory := '';
  for i := 1 to len - 2 do
  begin
    directory := directory + MAGPIECE(Path, '\', i) + '\';
  end;



  result := directory;
end;

// function is called to start the annotation editor
function TfrmCapAnnotate.Execute(dir : string; temp :  string; var description : string; RootDir : string; var Extension : string) : boolean;
var
DLLFileName: String; // variable for the filename
begin
  result := false; // set result to false for default
  directory := dir; // set the directory
  RootDirectory := rootdir; // set the rootdirectory
  fname := temp; // set the file name to the temp variable
  mnuFileOpenClick(self); // call the menu option to open the file


  anntool1.CurrColorType := 6;//5;// set the number of colors to 8 bit color
  // Check OPERATING SYSTEM VERSION HERE!!!
  XP := true;
//  XP := MagIsXP();
//  if XP = true then
//  begin
//    mnuOptionsBlackWhiteClick(self);
//    mnuoptionscolor.Visible := false;
//  end;

  DLLFileName := GetImagingDirectory();// GetINIDirectory();
  GetFormPosition(frmCapAnnotate, DLLFileName);
  ShowModal; // show the form as modal
  if modalresult = mrOK then  // if the image was annotated and completed for saving
  begin
    // determine the files extension
    if mnuOptionsColor.Checked = true then
    begin
      Extension := '.jpg';  // jpg for color images
    end
    else
    begin
      Extension := '.tif'; // tif for black and white images
    end;
    anntool1.BurnFile := true; // tell the annotation tool to burn in the annotations
    anntool1.SaveFile := fname + Extension; // save the file as fname
//    showmessage('File: ' + fname + ' Extension: ' + Extension);
    if not fileexists(fname + Extension) then // check to see if the file was actually saved
    begin
      // show an error message to inform the file did not save
      ShowMessage('ERROR: Your annotation was not saved!  Call IRM for VistA Imaging support if this continues');
      Exit; // exit the program
    end;

    // set the description of the file to the file the user selected to open initially
    description := magpiece(extractfilename(opendialog1.filename),'.',1);
    result := true; // set the result to true for success

  end;
  SaveFormPosition(frmCapAnnotate, DLLFileName);
end;

procedure TfrmCapAnnotate.sbrZoomChange(Sender: TObject);
begin
anntool1.ZoomLevel := sbrzoom.Position;      // set the zoom level of the image
lblzoom.Caption := inttostr(sbrzoom.position);       // set the zoom value
end;

procedure TfrmCapAnnotate.FormResize(Sender: TObject);
begin
toolbar1.Width := frmcapannotate.ClientWidth; // set the width to the toolbar to the forms width

if mnuViewtowidth.Checked then // if the view is set to width, then resize
begin
  mnuViewToWidthClick(Self); // call the menu option to zoom to width
end;
if mnuViewtoheight.checked then // if the view is set to height, then resize
begin
  mnuViewtoheightclick(self); // call the menu option to zoom to height
end;
if mnuViewbestfit.Checked then // if the view is set to best fit, then resize
begin
  mnuViewBestFitClick(self);    // call the menu option to zoom to best fit
end;
if mnuViewzoomstandard.Checked then // if the view is set to zoom standard, then resize
begin
  mnuViewZoomStandardClick(self); // call the menu option to zoom standard
end;

end;

procedure TfrmCapAnnotate.mnuFileOpenClick(Sender: TObject);
var
OpenForm: tfrmOpenDialog; // variable for open file form dialog
begin
if anntool1.ImageChanged = true then // check to see if the image has been changed
if application.MessageBox('Your image has been modified, are you sure you wish to open a new image without saving the current image?','Open New Image?',MB_YESNO) = IDNO then// ifthe image has been changed, output a message
exit; // if the user said no, then exit the function
openform := tfrmopendialog.Create(self); // create a new open form dialog
// call the function to show the form
opendialog1.filename := openform.ShowDialog(directory, rootdirectory);

if opendialog1.FileName = '' then exit; // if the user selects nothing

anntool1.OpenFile := opendialog1.filename;      // open the file from the dialog
statusbar1.Panels[0].Text := extractfilename(opendialog1.filename);
sbrzoom.Position := anntool1.zoomlevel;      // set the scroll bar position
anntool1.CurrTool := 1; // set the tool to the pointer
clearchecks();    // clears all the checked items in the annotation menu
mnuAnnotationspointer.Checked := true;       // set the pointer check to true

anntool1.CurrView := 3; // set the view
sbrzoom.Position := anntool1.zoomlevel;      // set the scroll bar position
ClearViews();   // clear all the views

mnuViewToWidthClick(self);    // set the zoom level to width
mnuLineWidthMediumClick(self);     // set the line width to medium
end;



procedure TfrmCapAnnotate.mnuViewToWidthClick(Sender: TObject);
begin
anntool1.CurrView := 1; // set the view to width
sbrzoom.Position := anntool1.zoomlevel;      // change the scroll position
ClearViews();   // clear the views
mnuViewtowidth.Checked := true;       // set the check for the towidth
end;

procedure TfrmCapAnnotate.mnuViewBestFitClick(Sender: TObject);
begin
anntool1.CurrView := 0; // set the view to best fit
sbrzoom.Position := anntool1.zoomlevel;      // change the scroll position
ClearViews();   // clear the views
mnuViewbestfit.Checked := true;       // set the check for best fit
end;

procedure TfrmCapAnnotate.mnuViewToHeightClick(Sender: TObject);
begin
anntool1.CurrView := 2; // set the view to height
sbrzoom.Position := anntool1.zoomlevel;      // change the scroll position
ClearViews();   // clear the views
mnuViewtoheight.Checked := true;      // set the check for the toheight
end;

procedure TfrmCapAnnotate.mnuViewZoomStandardClick(Sender: TObject);
begin
anntool1.CurrView := 3; // set the view to zoom standard
sbrzoom.Position := anntool1.zoomlevel;      // change the scroll position
ClearViews();   // clear the views
mnuViewzoomstandard.Checked := true;  // set the check for zoom standard
end;

procedure TfrmCapAnnotate.mnuAnnotationsDeleteAnnotationClick(Sender: TObject);
begin
anntool1.DeleteCurrAnnotation := true; // delete the currently selected annotations
end;

procedure TfrmCapAnnotate.mnuAnnotationsClearAnnotationsClick(Sender: TObject);
begin
if anntool1.ImageChanged = true then // check to see if the image has been changed
if application.MessageBox('Your image has been modified, are you sure you wish to clear all of your annotations?','Clear Annotations?',MB_YESNO) = IDNO then// ifthe image has been changed, output a message
exit; // if the user said no, then exit the function
anntool1.ClearAnnotations := true;      // clear all annotations
end;

procedure TfrmCapAnnotate.mnuAnnotationsPointerClick(Sender: TObject);
begin
anntool1.CurrTool := 1; // set the tool to the pointer
clearchecks();  // clear the tool checks
mnuAnnotationspointer.Checked := true;       // set the pointer check to true
end;

procedure TfrmCapAnnotate.mnuAnnotationsFreehandLineClick(Sender: TObject);
begin
anntool1.CurrTool := 2; // set the curr tool to freehand line
clearchecks();  // clear all the checks
mnuAnnotationsfreehandline.Checked := true;  // set the check mark for the freehand line
end;

procedure TfrmCapAnnotate.mnuAnnotationsStraightLineClick(Sender: TObject);
begin
anntool1.CurrTool := 4; // set the curr tool to straight line
clearchecks();  // clear all the checks
mnuAnnotationsstraightline.Checked := true;  // set the check mark for the straight line
end;

procedure TfrmCapAnnotate.mnuAnnotationsArrowClick(Sender: TObject);
begin
anntool1.CurrTool := 8; // set the tool to arrow
clearchecks();  // clear all the checks
mnuAnnotationsarrow.Checked := true; // set the check mark for the arrow
end;

procedure TfrmCapAnnotate.mnuAnnotationsMinusClick(Sender: TObject);
begin
anntool1.CurrTool := 10;        // set the tool for the minus sign
clearchecks();  // clear all the check marks
mnuAnnotationsminus.Checked := true; // set the check for the minus sign
end;

procedure TfrmCapAnnotate.mnuAnnotationsFilledRectangleClick(Sender: TObject);
begin
anntool1.CurrTool := 6;   // set the tool to the filled in rectangle
clearchecks();  // clear all the checks
mnuAnnotationsfilledrectangle.Checked := true;       // set the check mark for the filled rectangle
end;

procedure TfrmCapAnnotate.mnuAnnotationsHollowRectangleClick(Sender: TObject);
begin
anntool1.CurrTool := 5; // set the tool to the hollow rectangle
clearchecks();  // clear all the checks
mnuAnnotationshollowrectangle.Checked := true;       // set the check mark for the hollow rectangle
end;

procedure TfrmCapAnnotate.mnuAnnotationsTypedTextClick(Sender: TObject);
begin
anntool1.CurrTool := 7; // set the tool for the text
clearchecks();  // clear all the checks
mnuAnnotationstypedtext.Checked := true;     // set the check mark for the text
end;

procedure TfrmCapAnnotate.mnuAnnotationsPlusClick(Sender: TObject);
begin
anntool1.CurrTool := 9; // set the tool for the plus sign
clearchecks();  // clear all the checks
mnuAnnotationsplus.Checked := true;  // set the check for the plus sign
end;

procedure TfrmCapAnnotate.mnuOptionsTextFontClick(Sender: TObject);
begin
fontdialog1.Execute;    // open the font dialog
anntool1.FontSize := fontdialog1.Font.Size;     // set the font size
anntool1.FontName := fontdialog1.Font.Name;     // set the font name

// check to see if the user wants bold and or italic
// if true, bold was selected
if fsbold in fontdialog1.font.style then anntool1.bold := true
else
  anntool1.Bold := false; // bold was not selected
// if true, italic was selected
if fsitalic in fontdialog1.font.style then anntool1.italic := true
else
  anntool1.italic := false;       // italic was not selected
end;

procedure TfrmCapAnnotate.mnuOptionsTextColorClick(Sender: TObject);
begin
  colordialog1.color := anntool1.fontcolor;
  colordialog1.Execute;   // show the color dialog
  anntool1.FontColor := colordialog1.Color;       // set the color to the selected color
end;

procedure TfrmCapAnnotate.mnuOptionsLineColorClick(Sender: TObject);
begin
  colordialog1.Color := anntool1.linecolor;
  colordialog1.Execute; // show the color dialog
  anntool1.LineColor := colordialog1.Color;       // set the line color to the selected color
end;

procedure TfrmCapAnnotate.mnuOptionsFillColorClick(Sender: TObject);
begin
  colordialog1.color := anntool1.fillcolor;
  colordialog1.Execute;   // show the color dialog
  anntool1.FillColor := colordialog1.Color;       // set the fill color to the selected color
end;

procedure TfrmCapAnnotate.mnuOptionsAnnotationsOpaqueClick(Sender: TObject);
begin
// set the current style to opaque
anntool1.CurrStyle := 0;// 0 = opaque
mnuoptionsannotationsopaque.Checked := true;     // turn on the opaque check mark
mnuoptionsannotationstranslucent.Checked := false;       // turn off the translucent check mark
end;

procedure TfrmCapAnnotate.mnuOptionsAnnotationsTranslucentClick(Sender: TObject);
begin
// set the style to translucent
anntool1.CurrStyle := 1;// 1 = translucent
mnuoptionsannotationsopaque.Checked := false;    // turn off the opaque check mark
mnuoptionsannotationstranslucent.Checked := true;        // turn on the translucent check mark
end;

procedure TfrmCapAnnotate.FormCreate(Sender: TObject);
begin
// set the current style to opaqu
anntool1.CurrStyle := 0;// 0 = opaque
mnuoptionsannotationsopaque.Checked := true; // turn on the opaque check mark
mnuoptionsannotationstranslucent.Checked := false; // turn off the translucent check mark                            

anntool1.bold := false; // turn bold font off
anntool1.italic := false;       // turn italic font off
anntool1.FontName := 'MS Sans Serif';   // set the font to MS Sans Serif
anntool1.FontSize := 8; // set the font size to 8

// set the default colors to blue (default is for colors on)
anntool1.LineColor := clblue;   // set the line color to blue
anntool1.FillColor := clblue;   // set the fill color to blue
anntool1.FontColor := clblue;   // set the font color to blue

mnuLineWidthMediumClick(self); // set the line width to medium
end;

procedure TfrmCapAnnotate.ClearChecks();
begin
// clear all the annotation checks
mnuAnnotationspointer.Checked := false;
mnuAnnotationsfreehandline.Checked := false;
mnuAnnotationsstraightline.Checked := false;
mnuAnnotationsfilledrectangle.Checked := false;
mnuAnnotationshollowrectangle.Checked := false;
mnuAnnotationstypedtext.Checked := false;
mnuAnnotationsarrow.Checked := false;
mnuAnnotationsplus.Checked := false;
mnuAnnotationsminus.Checked := false;

end;

procedure TfrmCapAnnotate.ClearViews();
begin
// clear all the possible view checks
mnuViewtowidth.Checked := false;
mnuViewtoheight.checked := false;
mnuViewzoomstandard.Checked := false;
mnuViewbestfit.Checked := false;

end;

procedure tfrmCapAnnotate.ClearWidths();
begin
// clear all the possible width check marks
mnuLineWidththin.checked := false;
mnuLineWidthMedium.checked := false;
mnuLineWidththick.checked := false;

end;

procedure TfrmCapAnnotate.mnuHelpContentsClick(Sender: TObject);
Var
DLLFileName: PChar; // a pChar for the DLL name
ImagingDirectory: String;
begin
// show the applications help file
GetMem(DLLFileName, 255);
if (DLLFileName <> nil) then // if the help file is found
  GetModuleFileName(hInstance, DLLFileName, 254);
ImagingDirectory := GetImagingDirectory(); //JMW 9/24/2004
//application.HelpFile := DLLFileName + '\Annotation Editor Help.HLP';
application.HelpFile := ImagingDirectory + '\Annotation Editor Help.HLP';
Application.HelpCommand(HELP_FINDER, 0);
end;

procedure TfrmCapAnnotate.FormClose(Sender: TObject;
  var Action: TCloseAction);
begin
if modalresult = mrok then  // if the result was ok, then do nothing here!
begin
end
else
begin
  if anntool1.ImageChanged = true then // check to see if the image has been changed
  begin
  // ask the user if they want to lose all their changes
    if application.MessageBox('Your image has been modified, are you sure you wish to close the Annotation Editor without saving the current image?','Close Annotation Editor?',MB_YESNO) = IDNO then// ifthe image has been changed, output a message
        action := canone;  //cancel the close and allow the user to continue annotating or save the image
    exit; // exit
  end;
  modalresult := mrCancel; // set the result as a cancel without saving anything
end;
end;

procedure TfrmCapAnnotate.mnuLineWidthThinClick(Sender: TObject);
begin
anntool1.LineWidth := 2; // set the line width to 2 (thin)
ClearWidths(); // reset the check marks to false
mnuLineWidththin.Checked := true; // set the menu check for thin to true
end;

procedure TfrmCapAnnotate.mnuLineWidthMediumClick(Sender: TObject);
begin
anntool1.LineWidth := 5; // set the line width to 5 (medium)
ClearWidths(); // reset the check marks to false
mnuLineWidthmedium.Checked := true; // set the menu check for medium to true
end;

procedure TfrmCapAnnotate.mnuLineWidthThickClick(Sender: TObject);
begin
anntool1.LineWidth := 10; // set the line width to 10
ClearWidths(); // reset the check marks to false
mnuLineWidththick.Checked := true; // st the menu option for thick to true
end;

procedure TfrmCapAnnotate.btnOpenClick(Sender: TObject);
begin
mnuFileOpenClick(self); // call the menu option to open the file
end;

procedure TfrmCapAnnotate.btnPointerClick(Sender: TObject);
begin
mnuAnnotationsPointerClick(self); // call the menu option to set to pointer
end;

procedure TfrmCapAnnotate.btnfreelineClick(Sender: TObject);
begin
mnuAnnotationsFreehandLineClick(self); // call the menu option to set to freehand line
end;

procedure TfrmCapAnnotate.btnStraightLineClick(Sender: TObject);
begin
mnuAnnotationsStraightLineClick(self); // call the menu option to set to straight line
end;

procedure TfrmCapAnnotate.btnFilledRectangleClick(Sender: TObject);
begin
mnuAnnotationsFilledRectangleClick(self); // call the menu option to set to filled rectangle
end;

procedure TfrmCapAnnotate.btnHollowRectangleClick(Sender: TObject);
begin
mnuAnnotationsHollowRectangleClick(self); // call the menu option to set to hollow rectangle
end;

procedure TfrmCapAnnotate.btnTypedTextClick(Sender: TObject);
begin
mnuAnnotationsTypedTextClick(self); // call the menu option to set to typed text
end;

procedure TfrmCapAnnotate.btnArrowClick(Sender: TObject);
begin
mnuAnnotationsArrowClick(self); // call the menu option to set to arrow
end;

procedure TfrmCapAnnotate.btnPlusClick(Sender: TObject);
begin
mnuAnnotationsPlusClick(self); // call the menu option to set to plus
end;

procedure TfrmCapAnnotate.btnMinusClick(Sender: TObject);
begin
mnuAnnotationsMinusClick(self); // call the menu option to set to minus
end;

procedure TfrmCapAnnotate.btnToWidthClick(Sender: TObject);
begin
mnuViewToWidthClick(self); // call the menu option to view to width
end;

procedure TfrmCapAnnotate.btnToHeightClick(Sender: TObject);
begin
mnuViewToHeightClick(self); // call the menu option to view to height
end;

procedure TfrmCapAnnotate.btnBestFitClick(Sender: TObject);
begin
mnuViewBestFitClick(self); // call the menu option to view to best fit
end;

procedure TfrmCapAnnotate.btnZoomStandardClick(Sender: TObject);
begin
mnuViewZoomStandardClick(self); // call the menu option to zoom standard
end;

procedure TfrmCapAnnotate.mnuFileImageCompleteClick(Sender: TObject);
begin
modalresult := mrOK; // set modal result as OK
Exit;   // exit the program
end;

procedure TfrmCapAnnotate.mnuFileCancelImageClick(Sender: TObject);
begin
  modalresult := mrCancel; // set the result to cancel
end;

procedure TfrmCapAnnotate.mnuClearSelectedAnnotationsClick(Sender: TObject);
begin
anntool1.DeleteCurrAnnotation := true; // clear the selected annotations
end;

procedure TfrmCapAnnotate.mnuClearAllAnnotationsClick(Sender: TObject);
begin
if anntool1.ImageChanged = true then // check to see if the image has been changed
if application.MessageBox('Your image has been modified, are you sure you wish to clear all of your annotations?','Clear Annotations?',MB_YESNO) = IDNO then// ifthe image has been changed, output a message
  exit; // if the user said no, then exit the function
anntool1.ClearAnnotations := true;      // clear all annotations

end;

procedure TfrmCapAnnotate.btnSaveClick(Sender: TObject);
begin
mnuFileImageCompleteClick(self);  // call the menu option to complete the image
end;

procedure TfrmCapAnnotate.mnuHelpAboutClick(Sender: TObject);
var
AboutForm: TfrmAbout; // a about form variable
begin
  AboutForm := tfrmabout.Create(self); // create a new about form object
  AboutForm.show; // show the about form
end;

procedure TfrmCapAnnotate.mnuOptionsColorClick(Sender: TObject);
begin
mnuoptionscolor.Checked := true; // set the 256 color check to true
mnuoptionsblackwhite.Checked := false; // set the black and white check to false
anntool1.CurrColorType := 6;//5; // set the color type to 256 color
setcoloroptions(true); // turn on the color options
// set all the colors to blue
anntool1.LineColor := clblue;
anntool1.FillColor := clblue;
anntool1.FontColor := clblue;
end;

procedure TfrmCapAnnotate.mnuOptionsBlackWhiteClick(Sender: TObject);
begin
mnuoptionscolor.Checked := false; // set the 256 color check to false
mnuoptionsblackwhite.Checked := true; // set the black and white check to true
anntool1.CurrColorType := 1; // set the color type to black and white
setcoloroptions(false); // turn off the color options
// set all the colors to black
anntool1.LineColor := clblack;
anntool1.FillColor := clblack;
anntool1.FontColor := clblack;
end;
procedure tfrmcapannotate.SetColorOptions(value : boolean);
begin
// set all the color options visibility to the value
mnuoptionstextcolor.Visible := value;
mnuoptionslinecolor.Visible := value;
mnuoptionsfillcolor.Visible := value;
mnuOptionsAnnotationsOpaque.Visible := value;
mnuOptionsAnnotationstranslucent.Visible := value;
mnuOptionsBar3.Visible := value;
mnuOptionsBar4.Visible := value;
end;


procedure TfrmCapAnnotate.AnnTool1KeyDown(Sender: TObject; var KeyCode,
  Shift: Smallint);
begin
//statusbar1.Panels[0].Text := 'Key - ' + inttostr(keycode);
//if keycode = 1 then
//begin

//end;
end;

procedure TfrmCapAnnotate.mnuFileClearImageClick(Sender: TObject);
begin
if anntool1.ImageChanged = true then // check to see if the image has been changed
if application.MessageBox('Your image has been modified, are you sure you wish to clear the displayed image?','Clear Displayed Image?',MB_YESNO) = IDNO then// ifthe image has been changed, output a message
exit; // if the user said no, then exit the function

anntool1.ClearDisplay := true;  // clear the image and annotations from the window
statusbar1.Panels[0].Text := ''; // reset the file in the status bar to nothing

end;

function TfrmCapAnnotate.MagIsXP: boolean;
var
   VersionInfo: TOSVersionInfo;
   IsXP : boolean;
begin
  VersionInfo.dwOSVersionInfoSize := SizeOf(VersionInfo);
  GetVersionEx(VersionInfo);
  IsXP := false;
  with VersionInfo do begin
    case dwPlatformId of
      VER_PLATFORM_WIN32_NT     {2} : begin
        if ((dwMajorVersion = 5) and (dwMinorVersion = 1)) then IsXp := true;
        end; //NT
      end; //case
    result := IsXP;
    end;
end;






end.
