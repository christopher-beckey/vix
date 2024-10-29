unit fMagAnnotationOptionsX;

Interface

Uses
  Windows,
  Buttons,
  Classes,
  ComCtrls,
  Controls,
  Dialogs,
  ExtCtrls,
  Forms,
  Graphics,
  Messages,
  Stdctrls,
  SysUtils,
  Variants;

Type

  TMagAnnotDefaults = Class
  Protected
    ExeName: String;
    ExePath: String;
    FileIni: String;
    FUndoEnabled: Boolean;
    FUndoPoint: String;
    IniData: Tstringlist;
  Public
    Constructor Create();
    Destructor Destroy(); Override;
    Function Value(Name: String): String;
    Procedure Persist(); Overload;
    Procedure Persist(Name, Value: String); Overload;
    Procedure Persist(Name: String; Value: Boolean); Overload;
    Procedure Persist(Name: String; Value: Integer); Overload;
    Procedure Restore();
    Procedure SetUndoPoint();
    Procedure Undo();
  End;

  TfrmAnnotOptionsX = Class(TForm)
    btnBorderColor01: TSpeedButton;
    btnBorderColor02: TSpeedButton;
    btnBorderColor03: TSpeedButton;
    btnBorderColor04: TSpeedButton;
    btnBorderColor05: TSpeedButton;
    btnBorderColor06: TSpeedButton;
    btnBorderColor07: TSpeedButton;
    btnBorderColor08: TSpeedButton;
    btnBorderColor09: TSpeedButton;
    btnBorderColor10: TSpeedButton;
    btnBorderColor11: TSpeedButton;
    btnBorderColor12: TSpeedButton;
    btnBorderColor13: TSpeedButton;
    btnBorderColor14: TSpeedButton;
    btnBorderColor15: TSpeedButton;
    btnBorderColor16: TSpeedButton;
    btnCancel: TBitBtn;
    btnFillColor01: TSpeedButton;
    btnFillColor02: TSpeedButton;
    btnFillColor03: TSpeedButton;
    btnFillColor04: TSpeedButton;
    btnFillColor05: TSpeedButton;
    btnFillColor06: TSpeedButton;
    btnFillColor07: TSpeedButton;
    btnFillColor08: TSpeedButton;
    btnFillColor09: TSpeedButton;
    btnFillColor10: TSpeedButton;
    btnFillColor11: TSpeedButton;
    btnFillColor12: TSpeedButton;
    btnFillColor13: TSpeedButton;
    btnFillColor14: TSpeedButton;
    btnFillColor15: TSpeedButton;
    btnFillColor16: TSpeedButton;
    btnOK: TBitBtn;
    Button1: TButton;
    cbHighlightLine: TCheckBox;
    cmboArrowPointerStyle: TComboBox;
    edtArrowPointerLength: TLabeledEdit;
    edtLineSize: TLabeledEdit;
    edtOpacity: TLabeledEdit;
    FontDialog: TFontDialog;
    gbPrimaryColor: TGroupBox;
    GroupBox1: TGroupBox;
    Label1: Tlabel;
    Panel1: Tpanel;
    Panel2: Tpanel;
    Panel3: Tpanel;
    Panel4: Tpanel;
    Panel6: Tpanel;
    pnlFontChangeAttributes: Tpanel;
    TabSheet_Color_Border: TTabSheet;
    TabSheet_Color_Fill: TTabSheet;
    TabSheet_Font: TTabSheet;
    TabSheet_Line_Attributes: TTabSheet;
    TabSheet_Opacity: TTabSheet;
    TabSheet_Special: TPageControl;
    TabSheet1: TTabSheet;
    tbOpacity: TTrackBar;
    udArrowPointerLength: TUpDown;
    udLineSize: TUpDown;
    udOpacity: TUpDown;
    TabSheet2: TTabSheet;
    edtTextRulerLabel: TLabeledEdit;
    edtArrowPointerAngle: TLabeledEdit;
    udArrowPointerAngle: TUpDown;
    Label2: Tlabel;
    Label3: Tlabel;
    TabSheet3: TTabSheet;

    {/P122 - DN - 6/16/2011 - New simplified color options /}
    LineColorBox: TGroupBox;
    btnLineColor01: TSpeedButton;
    btnLineColor02: TSpeedButton;
    btnLineColor03: TSpeedButton;
    btnLineColor04: TSpeedButton;
    btnLineColor05: TSpeedButton;
    btnLineColor06: TSpeedButton;
    btnLineColor07: TSpeedButton;
    btnLineColor08: TSpeedButton;
    btnLineColor09: TSpeedButton;
    btnLineColor10: TSpeedButton;
    btnLineColor11: TSpeedButton;
    btnLineColor12: TSpeedButton;
    btnLineColor13: TSpeedButton;
    btnLineColor14: TSpeedButton;
    btnLineColor15: TSpeedButton;
    btnLineColor16: TSpeedButton;
    fontList: TListBox;
    fontNameLbl: TLabel;
    Label4: TLabel;
    FontStyles: TListBox;
    Label5: TLabel;
    fontSizes: TListBox;
    FontSample: TPanel;
    Label6: TLabel;
    lblFontSizeWarning: TLabel;


    Procedure btnBorderColor01Click(Sender: Tobject);
    Procedure btnBorderColor02Click(Sender: Tobject);
    Procedure btnBorderColor03Click(Sender: Tobject);
    Procedure btnBorderColor04Click(Sender: Tobject);
    Procedure btnBorderColor05Click(Sender: Tobject);
    Procedure btnBorderColor06Click(Sender: Tobject);
    Procedure btnBorderColor07Click(Sender: Tobject);
    Procedure btnBorderColor08Click(Sender: Tobject);
    Procedure btnBorderColor09Click(Sender: Tobject);
    Procedure btnBorderColor10Click(Sender: Tobject);
    Procedure btnBorderColor11Click(Sender: Tobject);
    Procedure btnBorderColor12Click(Sender: Tobject);
    Procedure btnBorderColor13Click(Sender: Tobject);
    Procedure btnBorderColor14Click(Sender: Tobject);
    Procedure btnBorderColor15Click(Sender: Tobject);
    Procedure btnBorderColor16Click(Sender: Tobject);
    Procedure btnCancelClick(Sender: Tobject);
    Procedure btnFillColor01Click(Sender: Tobject);
    Procedure btnFillColor02Click(Sender: Tobject);
    Procedure btnFillColor03Click(Sender: Tobject);
    Procedure btnFillColor04Click(Sender: Tobject);
    Procedure btnFillColor05Click(Sender: Tobject);
    Procedure btnFillColor06Click(Sender: Tobject);
    Procedure btnFillColor07Click(Sender: Tobject);
    Procedure btnFillColor08Click(Sender: Tobject);
    Procedure btnFillColor09Click(Sender: Tobject);
    Procedure btnFillColor10Click(Sender: Tobject);
    Procedure btnFillColor11Click(Sender: Tobject);
    Procedure btnFillColor12Click(Sender: Tobject);
    Procedure btnFillColor13Click(Sender: Tobject);
    Procedure btnFillColor14Click(Sender: Tobject);
    Procedure btnFillColor15Click(Sender: Tobject);
    Procedure btnFillColor16Click(Sender: Tobject);
    Procedure Button1Click(Sender: Tobject);
    Procedure cbHighlightLineClick(Sender: Tobject);
    Procedure cmboArrowPointerStyleChange(Sender: Tobject);
    Procedure edtLineSizeChange(Sender: Tobject);
    Procedure edtOpacityChange(Sender: Tobject);
    Procedure FormActivate(Sender: Tobject);
    Procedure FormClose(Sender: Tobject; Var action: TCloseAction);
    Procedure FormCreate(Sender: Tobject);
    Procedure tbOpacityChange(Sender: Tobject);
    Procedure udArrowPointerLengthClick(Sender: Tobject; Button: TUDBtnType);
    Procedure edtTextRulerLabelChange(Sender: Tobject);
    Procedure udArrowPointerAngleClick(Sender: Tobject; Button: TUDBtnType);

    {/P122 - DN - 6/16/2011 - /}
    procedure btnLineColor01Click(Sender: TObject);
    Procedure btnLineColor02Click(Sender: Tobject);
    Procedure btnLineColor03Click(Sender: Tobject);
    Procedure btnLineColor04Click(Sender: Tobject);
    Procedure btnLineColor05Click(Sender: Tobject);
    Procedure btnLineColor06Click(Sender: Tobject);
    Procedure btnLineColor07Click(Sender: Tobject);
    Procedure btnLineColor08Click(Sender: Tobject);
    Procedure btnLineColor09Click(Sender: Tobject);
    Procedure btnLineColor10Click(Sender: Tobject);
    Procedure btnLineColor11Click(Sender: Tobject);
    Procedure btnLineColor12Click(Sender: Tobject);
    Procedure btnLineColor13Click(Sender: Tobject);
    Procedure btnLineColor14Click(Sender: Tobject);
    Procedure btnLineColor15Click(Sender: Tobject);
    Procedure btnLineColor16Click(Sender: Tobject);
    procedure fontListClick(Sender: TObject);
    procedure FontStylesClick(Sender: TObject);
    procedure fontSizesClick(Sender: TObject);
  private
    function GetUserPreferences: string;
    procedure SetUserPreferences(const Value: string);

    //p122 dmmn 8/2
    procedure SetShowStrictRAD(const Value: String);
    procedure SetRADFontName(const Value: string);
    procedure SetRADFontSize(const Value: integer);
    procedure SetRADFontStyle(const Value: integer);
    procedure SetRADLineWidth(const Value: integer);
    procedure SetRADOpacity(const Value: integer);
    procedure SetRADColor(const Value: TColor);

  Protected
    FAnnotLineColor : TColor;   {/P122 - DN - 6/16/2011 - /}
    FAnnotBorderColor: TColor;
    FAnnotFillColor: TColor;
    FArrowPointerLength: Integer;
    FArrowPointerStyle: Integer;
    FArrowPointerAngle: Integer;
    FDefaultsWere: String;
    FFontBold: Boolean;
    FFontColor: TColor;
    FFontItalic: Boolean;
    FFontName: String;
    FFontSize: Integer;
    FFontStyle : Integer;
    FFontStrikeOut: Boolean;
    FFontUnderline: Boolean;
    FHighlightLine: Boolean;
    FLineWidth: Integer;
    FOpacity: Integer;
    FRulerLabel: String;
    FAutoShowAnnots: String;  {/ P122 - JK 7/14/2011 - '0' = don't show annotations on images; '1' = show annots /}

    FShowStrictRAD : string; //p122 dmmn 8/2
    FRADFontName : string;
    FRADFontStyle : integer;
    FRADFontSize : integer;
    FRADLineWidth : integer;
    FRADColor : TColor;
    FRADOpacity : integer;

    VistASettings : TStringList;       //p122 dmmn 7/5/11 - for storing user prefenreces
    TempSettings : TStringList;

    Function GetArrowPointerLength: Integer;
    Function GetArrowPointerStyle: Integer;
    Function GetArrowPointerAngle: Integer;
    procedure SetAnnotLineColor(const Value: TColor);
    Procedure SetAnnotBorderColor(Const Value: TColor);
    Procedure SetAnnotFillColor(Const Value: TColor);
    Procedure SetArrowPointerLength(Const Value: Integer);
    Procedure SetArrowPointerStyle(Const Value: Integer);
    Procedure SetArrowPointerAngle(Const Value: Integer);
    Procedure SetFontBold(Const Value: Boolean);
    Procedure SetFontColor(Const Value: TColor);
    Procedure SetFontItalic(Const Value: Boolean);
    Procedure SetFontName(Const Value: String);
    Procedure SetFontSize(Const Value: Integer);
    procedure SetFontStyle(const Value: Integer);
    Procedure SetFontStrikeOut(Const Value: Boolean);
    Procedure SetFontUnderline(Const Value: Boolean);
    Procedure SetHighlightLine(Const Value: Boolean);
    Procedure SetLineWidth(Const Value: Integer);
    Procedure SetOpacity(Const Value: Integer);
    Procedure SetRulerLabel(Const Value: String);
    Procedure SetAutoShowAnnots(Const Value: String);
  published
  Public
    Function RGBToColor(r, g, b: Double): TColor;

    Procedure BorderColorButtonsDeSelectAll();
    Procedure BorderColorButtonSetByColor(c: TColor);
    Procedure AnnotColorToRGB(c: TColor; Out r, g, b: Integer);
    Procedure FillColorButtonsDeSelectAll();
    Procedure FillColorButtonSetByColor(c: TColor);
    Procedure LineColorButtonSetByColor(c: TColor);
    Procedure LineColorButtonsDeSelectAll();
    Procedure Init();
  Published
    Property AnnotLineColor : TColor Read FAnnotLineColor Write SetAnnotLineColor;
    Property AnnotBorderColor: TColor Read FAnnotBorderColor Write SetAnnotBorderColor;
    Property AnnotFillColor: TColor Read FAnnotFillColor Write SetAnnotFillColor;
    Property ArrowPointerLength: Integer Read GetArrowPointerLength Write SetArrowPointerLength;
    Property ArrowPointerStyle: Integer Read GetArrowPointerStyle Write SetArrowPointerStyle;
    Property ArrowPointerAngle: Integer Read GetArrowPointerAngle Write SetArrowPointerAngle;
    Property Fontbold: Boolean Read FFontBold Write SetFontBold;
    Property FontColor: TColor Read FFontColor Write SetFontColor;
    Property FontItalic: Boolean Read FFontItalic Write SetFontItalic;
    Property FontName: String Read FFontName Write SetFontName;
    Property FontSize: Integer Read FFontSize Write SetFontSize;
    Property FontStyle : Integer Read FFontStyle write SetFontStyle; //p122 7/5/11
    Property FontStrikeOut: Boolean Read FFontStrikeOut Write SetFontStrikeOut;
    Property FontUnderline: Boolean Read FFontUnderline Write SetFontUnderline;
    Property HighlightLine: Boolean Read FHighlightLine Write SetHighlightLine;
    Property LineWidth: Integer Read FLineWidth Write SetLineWidth;
    Property Opacity: Integer Read FOpacity Write SetOpacity;
    Property RulerLabel: String Read FRulerLabel Write SetRulerLabel;
    Property AutoShowAnnots: String read FAutoShowAnnots write SetAutoShowAnnots;

    //p122 dmmn 8/2
    Property StrictRAD : String read FShowStrictRAD write SetShowStrictRAD;
    Property RADFontName : string read FRADFontName write SetRADFontName;
    Property RADFontSize : integer read FRADFontSize write SetRADFontSize;
    Property RADFontStyle : integer read FRADFontStyle write SetRADFontStyle;
    Property RADLineWidth : integer read FRADLineWidth write SetRADLineWidth;
    Property RADOpacity : integer read FRADOpacity write SetRADOpacity;
    Property RADColor : TColor read FRADColor write SetRADColor;

    {/P122 dmmn 7/5/11 - set and retrieve user preferences from and to VistA/}
    Property UserPreferences : string read GetUserPreferences write SetUserPreferences;

  End;

Var
  frmAnnotOptionsX: TfrmAnnotOptionsX;      //RCA...  Annotations uses a  variable defined in umagDefinitions.  ?
//  MagAnnotDefaults: TMagAnnotDefaults;


Implementation
Uses
//  fMagAnnotationX,
  Math,
  uMagDefinitions; {JK 8/30/2011}
{$R *.dfm}

Procedure TfrmAnnotOptionsX.FormClose(Sender: Tobject; Var action: TCloseAction);
Begin
//  MagAnnotDefaults.Persist('frmAnnotOptions.Top', Top);
//  MagAnnotDefaults.Persist('frmAnnotOptions.Left', Left);

  action := caHide;
End;

Procedure TfrmAnnotOptionsX.FormCreate(Sender: Tobject);
var
  fontInd : Integer;
//  I : Integer;
Begin
//  MagAnnotDefaults.Restore();
  {/p122 dmmn 7/5/11 - user preferences/}

  // set default settings
//  FontList.Items.Assign(Screen.Fonts);        // font    //p122 7/12/11 - limited down the number of font user can choose
  FontName := magAnnotationFont;  //'Arial';
  FontSize := 11;
  FontStyle := 0;
  fontInd := FontList.Items.IndexOf(FontName);
  FontList.Selected[fontInd] := True;
  FontList.TopIndex := fontInd;
  FontStyles.Selected[FontStyle] := True;
  FontSizes.Selected[FontSizes.Items.IndexOf(IntToStr(FontSize))] := True;
  FontSizes.TopIndex:= FontSizes.Items.IndexOf(IntToStr(FontSize));
  FontSample.Font.Name := FontName;
  FontSample.Font.Size := FontSize;
  FontSample.Font.Style := [];

  udLineSize.Position := 5;                   // line size
  edtLineSize.Text := '5';
  LineWidth := 5;       //p122 dmmn 7/8/11

  AnnotLineColor := clGreen;                    // color

  tbOpacity.Position := 159;                  // opacity
  udOpacity.Position := 159;
  edtOpacity.Text := '159';
  Opacity := 159 ;            //p122 dmmn 7/8/11

  ArrowPointerStyle := cmboArrowPointerStyle.ItemIndex;
  ArrowPointerLength := udArrowPointerLength.Position;
  ArrowPointerAngle := udArrowPointerAngle.Position;

  AutoShowAnnots := '1';

  //p122 dmmn 8/3/11
  StrictRAD := '0';
  RADFontName := magAnnotationFont; // 'Arial';
  RADFontStyle := 0;
  RADFontSize := 11;
  RADLineWidth := 1;
  RADColor := clWhite;
  RADOpacity := 255;

  VistASettings := TStringList.Create;
//  tempSettings := TStringList.Create;


//  VistASettings.Add('FontName=Arial');
//  VistASettings.Add('FontStyle=0');
//  VistASettings.Add('FontSize=11');
//  VistASettings.Add('LineSize=1');
//  VistASettings.Add('LineColor=255');
//  VistASettings.Add('Opacity=127');
//  VistASettings.Add('ArrowStyle=0');
//  VistASettings.Add('ArrowLength=40');
//  VistASettings.Add('ArrowAngle=40');
//  for I := 0 to VistASettings.Count - 1 do
//    tempSettings.Add(VistASettings[I]);

  //p122 dmmn show from middle of the main form
  Position := poMainFormCenter;

  Init();
End;

Procedure TfrmAnnotOptionsX.btnFillColor01Click(Sender: Tobject);
Begin
  AnnotFillColor := clBlack;
End;

Procedure TfrmAnnotOptionsX.btnFillColor02Click(Sender: Tobject);
Begin
  AnnotFillColor := clMedGray;
End;

Procedure TfrmAnnotOptionsX.btnFillColor03Click(Sender: Tobject);
Begin
  AnnotFillColor := clMaroon;
End;

Procedure TfrmAnnotOptionsX.btnFillColor04Click(Sender: Tobject);
Begin
  AnnotFillColor := clOlive;
End;

Procedure TfrmAnnotOptionsX.btnFillColor05Click(Sender: Tobject);
Begin
  AnnotFillColor := clGreen;
End;

Procedure TfrmAnnotOptionsX.btnFillColor06Click(Sender: Tobject);
Begin
  AnnotFillColor := clTeal;
End;

Procedure TfrmAnnotOptionsX.btnFillColor07Click(Sender: Tobject);
Begin
  AnnotFillColor := clNavy;
End;

Procedure TfrmAnnotOptionsX.btnFillColor08Click(Sender: Tobject);
Begin
  AnnotFillColor := clPurple;
End;

Procedure TfrmAnnotOptionsX.btnFillColor09Click(Sender: Tobject);
Begin
  AnnotFillColor := clFuchsia;
End;

Procedure TfrmAnnotOptionsX.btnFillColor10Click(Sender: Tobject);
Begin
  AnnotFillColor := clBlue;
End;

Procedure TfrmAnnotOptionsX.btnFillColor11Click(Sender: Tobject);
Begin
  AnnotFillColor := clAqua;
End;

Procedure TfrmAnnotOptionsX.btnFillColor12Click(Sender: Tobject);
Begin
  AnnotFillColor := cllime;
End;

Procedure TfrmAnnotOptionsX.btnFillColor13Click(Sender: Tobject);
Begin
  AnnotFillColor := clYellow;
End;

Procedure TfrmAnnotOptionsX.btnFillColor14Click(Sender: Tobject);
Begin
  AnnotFillColor := clRed;
End;

Procedure TfrmAnnotOptionsX.btnFillColor15Click(Sender: Tobject);
Begin
  AnnotFillColor := clSilver;
End;

Procedure TfrmAnnotOptionsX.btnFillColor16Click(Sender: Tobject);
Begin
  AnnotFillColor := clWhite;
End;

Procedure TfrmAnnotOptionsX.Button1Click(Sender: Tobject);
Begin
  If FontDialog.Execute Then
  Begin
    Fontbold := (Fsbold In FontDialog.Font.Style);
    {/P122 - DN - 6/16/2011 - Set the color in the font dialog to match the color
    in the color tab /}
    FontColor := FontDialog.Font.Color;
    SetAnnotLineColor(FontColor);
    
    FontItalic := (Fsitalic In FontDialog.Font.Style);
    FontName := FontDialog.Font.Name;
    FontSize := FontDialog.Font.Size;
    FontStrikeOut := (FsStrikeOut In FontDialog.Font.Style);
    FontUnderline := (fsUnderline In FontDialog.Font.Style);
  End;
End;

Procedure TfrmAnnotOptionsX.SetAnnotFillColor(Const Value: TColor);
Begin
  If FAnnotFillColor <> Value Then FAnnotFillColor := Value;
  FillColorButtonSetByColor(FAnnotFillColor);
//  MagAnnotDefaults.Persist('AnnotFillColor', FAnnotFillColor);
End;

Procedure TfrmAnnotOptionsX.SetFontBold(Const Value: Boolean);
Begin
  If FFontBold <> Value Then FFontBold := Value;
  If FFontBold And (Not (Fsbold In FontDialog.Font.Style)) Then FontDialog.Font.Style := FontDialog.Font.Style + [Fsbold];
  If (Not FFontBold) And (Fsbold In FontDialog.Font.Style) Then FontDialog.Font.Style := FontDialog.Font.Style - [Fsbold];
//  MagAnnotDefaults.Persist('FontBold', FFontBold);
End;

Procedure TfrmAnnotOptionsX.SetFontColor(Const Value: TColor);
Begin
  If FFontColor <> Value Then FFontColor := Value;
  If FontDialog.Font.Color <> FFontColor Then FontDialog.Font.Color := FFontColor;
//  MagAnnotDefaults.Persist('FontColor', FFontColor);
End;

Procedure TfrmAnnotOptionsX.SetFontItalic(Const Value: Boolean);
Begin
  If FFontItalic <> Value Then FFontItalic := Value;
  If FFontItalic And (Not (Fsitalic In FontDialog.Font.Style)) Then FontDialog.Font.Style := FontDialog.Font.Style + [Fsitalic];
  If (Not FFontItalic) And (Fsitalic In FontDialog.Font.Style) Then FontDialog.Font.Style := FontDialog.Font.Style - [Fsitalic];
//  MagAnnotDefaults.Persist('FontItalic', FFontItalic);
End;

Procedure TfrmAnnotOptionsX.SetFontName(Const Value: String);
var
  fontInd : Integer;
Begin
  If FFontName <> Value Then
    FFontName := Value;
//  If FontDialog.Font.Name <> FFontName Then FontDialog.Font.Name := FFontName; not used
//  MagAnnotDefaults.Persist('FontName', FFontName);

  fontInd := FontList.Items.IndexOf(Value);   // p122 7/6/2011
  if fontInd < 0 then     //p122 7/13 - in case the font in not in the list
    fontInd := 0;
  FFontName := FontList.Items[fontInd]; //p122 dmmn 8/1 - get the value in the available options

  FontList.Selected[fontInd] := True;
  FontList.TopIndex := fontInd;
  FontSample.Font.Name := FFontName;  //p122 8/1
End;

Procedure TfrmAnnotOptionsX.SetFontSize(Const Value: Integer);
var
  sizeInd : Integer;
Begin
  If FFontSize <> Value Then
    FFontSize := Value;
//  If FontDialog.Font.Size <> FFontSize Then FontDialog.Font.Size := FFontSize;
//  MagAnnotDefaults.Persist('FontSize', FFontSize);

  sizeInd := FontSizes.Items.IndexOf(IntToStr(Value));  // p122 7/6/2011
  if sizeInd < 0 then          //p122 7/13
    sizeInd := 0;
  FFontSize := StrToInt(FontSizes.Items[sizeInd]); //p122 dmmn 8/1 - get the available value

  FontSizes.Selected[sizeInd] := True;
  FontSizes.TopIndex := sizeInd;
  FontSample.Font.Size := Value;
End;

Procedure TfrmAnnotOptionsX.SetFontStrikeOut(Const Value: Boolean);
Begin
  If FFontStrikeOut <> Value Then FFontStrikeOut := Value;
  If FFontStrikeOut And (Not (FsStrikeOut In FontDialog.Font.Style)) Then FontDialog.Font.Style := FontDialog.Font.Style + [FsStrikeOut];
  If (Not FFontStrikeOut) And (FsStrikeOut In FontDialog.Font.Style) Then FontDialog.Font.Style := FontDialog.Font.Style - [FsStrikeOut];
//  MagAnnotDefaults.Persist('FontStrikeOut', FFontStrikeOut);
End;

procedure TfrmAnnotOptionsX.SetFontStyle(const Value: Integer);
begin
  // p122 7/6/11
  if FFontStyle <> Value Then
    FFontStyle := Value;

  if (FFontStyle < 0) or (FFontStyle > 3) then   //p122 7/13
    FFontStyle := 0;


  FontStyles.Selected[FFontStyle] := True;

  if FontStyle = 0 then
    FontSample.Font.Style := []
  else if FontStyle = 1 then
    FontSample.Font.Style := [fsBold]
  else if FontStyle = 2 then
    FontSample.Font.Style := [fsItalic]
  else if FontStyle = 3 then
    FontSample.Font.Style := [fsBold,fsItalic];
end;

Procedure TfrmAnnotOptionsX.SetFontUnderline(Const Value: Boolean);
Begin
  If FFontUnderline <> Value Then FFontUnderline := Value;
  If FFontUnderline And (Not (fsUnderline In FontDialog.Font.Style)) Then FontDialog.Font.Style := FontDialog.Font.Style + [fsUnderline];
  If (Not FFontUnderline) And (fsUnderline In FontDialog.Font.Style) Then FontDialog.Font.Style := FontDialog.Font.Style - [fsUnderline];
//  MagAnnotDefaults.Persist('FontUnderline', FFontUnderline);
End;

Procedure TfrmAnnotOptionsX.AnnotColorToRGB(c: TColor; Out r, g, b: Integer);
Begin
  r := c And $FF;
  g := (c And $FF00) Shr 8;
  b := (c And $FF0000) Shr 16;
End;

Procedure TfrmAnnotOptionsX.btnBorderColor01Click(Sender: Tobject);
Begin
  AnnotBorderColor := clBlack;
End;

Procedure TfrmAnnotOptionsX.btnBorderColor02Click(Sender: Tobject);
Begin
  AnnotBorderColor := clMedGray;
End;

Procedure TfrmAnnotOptionsX.btnBorderColor03Click(Sender: Tobject);
Begin
  AnnotBorderColor := clMaroon;
End;

Procedure TfrmAnnotOptionsX.btnBorderColor04Click(Sender: Tobject);
Begin
  AnnotBorderColor := clOlive;
End;

Procedure TfrmAnnotOptionsX.btnBorderColor05Click(Sender: Tobject);
Begin
  AnnotBorderColor := clGreen;
End;

Procedure TfrmAnnotOptionsX.btnBorderColor06Click(Sender: Tobject);
Begin
  AnnotBorderColor := clTeal;
End;

Procedure TfrmAnnotOptionsX.btnBorderColor07Click(Sender: Tobject);
Begin
  AnnotBorderColor := clNavy;
End;

Procedure TfrmAnnotOptionsX.btnBorderColor08Click(Sender: Tobject);
Begin
  AnnotBorderColor := clPurple;
End;

Procedure TfrmAnnotOptionsX.btnBorderColor09Click(Sender: Tobject);
Begin
  AnnotBorderColor := clFuchsia;
End;

Procedure TfrmAnnotOptionsX.btnBorderColor10Click(Sender: Tobject);
Begin
  AnnotBorderColor := clBlue;
End;

Procedure TfrmAnnotOptionsX.btnBorderColor11Click(Sender: Tobject);
Begin
  AnnotBorderColor := clAqua;
End;

Procedure TfrmAnnotOptionsX.btnBorderColor12Click(Sender: Tobject);
Begin
  AnnotBorderColor := cllime;
End;

Procedure TfrmAnnotOptionsX.btnBorderColor13Click(Sender: Tobject);
Begin
  AnnotBorderColor := clYellow;
End;

Procedure TfrmAnnotOptionsX.btnBorderColor14Click(Sender: Tobject);
Begin
  AnnotBorderColor := clRed;
End;

Procedure TfrmAnnotOptionsX.btnBorderColor15Click(Sender: Tobject);
Begin
  AnnotBorderColor := clSilver;
End;

Procedure TfrmAnnotOptionsX.btnBorderColor16Click(Sender: Tobject);
Begin
  AnnotBorderColor := clWhite;
End;

Procedure TfrmAnnotOptionsX.SetAnnotBorderColor(Const Value: TColor);
Begin
  If FAnnotBorderColor <> Value Then FAnnotBorderColor := Value;
  BorderColorButtonSetByColor(FAnnotBorderColor);
//  MagAnnotDefaults.Persist('AnnotBorderColor', FAnnotBorderColor);
End;

Procedure TfrmAnnotOptionsX.BorderColorButtonsDeSelectAll;
Begin
  btnBorderColor01.Flat := False;
  btnBorderColor02.flat := False;
  btnBorderColor03.flat := False;
  btnBorderColor04.flat := False;
  btnBorderColor05.flat := False;
  btnBorderColor06.flat := False;
  btnBorderColor07.flat := False;
  btnBorderColor08.flat := False;
  btnBorderColor09.flat := False;
  btnBorderColor10.flat := False;
  btnBorderColor11.flat := False;
  btnBorderColor12.flat := False;
  btnBorderColor13.flat := False;
  btnBorderColor14.flat := False;
  btnBorderColor15.flat := False;
  btnBorderColor16.flat := False;
End;

Procedure TfrmAnnotOptionsX.BorderColorButtonSetByColor(c: TColor);
Begin
  BorderColorButtonsDeSelectAll();
  Case c Of
    clBlack: btnBorderColor01.Flat := True;
    clMedGray: btnBorderColor02.flat := True;
    clMaroon: btnBorderColor03.flat := True;
    clOlive: btnBorderColor04.flat := True;
    clGreen: btnBorderColor05.flat := True;
    clTeal: btnBorderColor06.flat := True;
    clNavy: btnBorderColor07.flat := True;
    clPurple: btnBorderColor08.flat := True;
    clFuchsia: btnBorderColor09.flat := True;
    clBlue: btnBorderColor10.flat := True;
    clAqua: btnBorderColor11.flat := True;
    cllime: btnBorderColor12.flat := True;
    clYellow: btnBorderColor13.flat := True;
    clRed: btnBorderColor14.flat := True;
    clSilver: btnBorderColor15.flat := True;
    clWhite: btnBorderColor16.flat := True;
  Else
    btnBorderColor14.flat := True;
  End;
End;

Procedure TfrmAnnotOptionsX.FillColorButtonsDeSelectAll;
Begin
  btnFillColor01.Flat := False;
  btnFillColor02.flat := False;
  btnFillColor03.flat := False;
  btnFillColor04.flat := False;
  btnFillColor05.flat := False;
  btnFillColor06.flat := False;
  btnFillColor07.flat := False;
  btnFillColor08.flat := False;
  btnFillColor09.flat := False;
  btnFillColor10.flat := False;
  btnFillColor11.flat := False;
  btnFillColor12.flat := False;
  btnFillColor13.flat := False;
  btnFillColor14.flat := False;
  btnFillColor15.flat := False;
  btnFillColor16.flat := False;
End;

Procedure TfrmAnnotOptionsX.FillColorButtonSetByColor(c: TColor);
Begin
  FillColorButtonsDeSelectAll();
  Case c Of
    clBlack: btnFillColor01.Flat := True;
    clMedGray: btnFillColor02.flat := True;
    clMaroon: btnFillColor03.flat := True;
    clOlive: btnFillColor04.flat := True;
    clGreen: btnFillColor05.flat := True;
    clTeal: btnFillColor06.flat := True;
    clNavy: btnFillColor07.flat := True;
    clPurple: btnFillColor08.flat := True;
    clFuchsia: btnFillColor09.flat := True;
    clBlue: btnFillColor10.flat := True;
    clAqua: btnFillColor11.flat := True;
    cllime: btnFillColor12.flat := True;
    clYellow: btnFillColor13.flat := True;
    clRed: btnFillColor14.flat := True;
    clSilver: btnFillColor15.flat := True;
    clWhite: btnFillColor16.flat := True;
  Else
    btnFillColor14.flat := True;
  End;
End;

procedure TfrmAnnotOptionsX.fontListClick(Sender: TObject);
begin
  FontName := FontList.Items[FontList.ItemIndex];
  FontSample.Font.Name := FontName;
end;

procedure TfrmAnnotOptionsX.fontSizesClick(Sender: TObject);
begin
  FontSize := StrToInt(FontSizes.Items[FontSizes.ItemIndex]);
  FontSample.Font.Size := FontSize;
end;

Procedure TfrmAnnotOptionsX.SetLineWidth(Const Value: Integer);
Begin
  If FLineWidth <> Value Then
    FLineWidth := Value;

  If udLineSize.Position <> FLineWidth Then
    udLineSize.Position := FLineWidth;

  If edtLineSize.Text <> Inttostr(FLineWidth) Then
    edtLineSize.Text := Inttostr(FLineWidth);
    
//  MagAnnotDefaults.Persist('LineWidth', FLineWidth);
End;

Procedure TfrmAnnotOptionsX.edtLineSizeChange(Sender: Tobject);
Begin
  If LineWidth <> udLineSize.Position Then LineWidth := udLineSize.Position;
End;

Procedure TfrmAnnotOptionsX.SetHighlightLine(Const Value: Boolean);
Begin
  If FHighlightLine <> Value Then FHighlightLine := Value;
  If cbHighlightLine.Checked <> FHighlightLine Then cbHighlightLine.Checked := FHighlightLine;
//  MagAnnotDefaults.Persist('HighlightLine', FHighlightLine);
End;

Procedure TfrmAnnotOptionsX.cbHighlightLineClick(Sender: Tobject);
Begin
  HighlightLine := cbHighlightLine.Checked;
End;

Procedure TfrmAnnotOptionsX.SetOpacity(Const Value: Integer);
Begin
  If FOpacity <> Value Then FOpacity := Value;
  If udOpacity.Position <> FOpacity Then udOpacity.Position := FOpacity;
  If tbOpacity.Position <> FOpacity Then tbOpacity.Position := FOpacity;
//  MagAnnotDefaults.Persist('Opacity', FOpacity);
End;

Procedure TfrmAnnotOptionsX.edtOpacityChange(Sender: Tobject);
Begin
  Opacity := udOpacity.Position;
End;

Procedure TfrmAnnotOptionsX.tbOpacityChange(Sender: Tobject);
Begin
  Opacity := tbOpacity.Position;
End;

procedure TfrmAnnotOptionsX.SetRADColor(const Value: TColor);
begin
  //p122 dmmn 8/2
  if Value = clWhite then
    FRADColor := clWhite
  else
    FRADColor := clWhite;
end;

procedure TfrmAnnotOptionsX.SetRADFontName(const Value: string);
begin
  //p122 dmmn 8/2
  if Value = magAnnotationFont then // 'Arial' then
    FRADFontName := Value
  else
    FRADFontName := magAnnotationFont; //'Arial';
end;

procedure TfrmAnnotOptionsX.SetRADFontSize(const Value: integer);
begin
  //p122 dmmn 8/2
  if Value > 0 then
    FRADFontSize := Value
  else
    FRADFontSize := 11;
end;

procedure TfrmAnnotOptionsX.SetRADFontStyle(const Value: integer);
begin
  //p122 dmmn 8/2
  if (Value >= 0) and (Value < 4)then
    FRADFontStyle := Value
  else
    FRADFontStyle := 0;
end;

procedure TfrmAnnotOptionsX.SetRADLineWidth(const Value: integer);
begin
  //p122 dmmn 8/2
  if Value > 0 then
    FRADLineWidth := Value
  else
    FRADLineWidth := 1;
end;

procedure TfrmAnnotOptionsX.SetRADOpacity(const Value: integer);
begin
  if (Value > 63) and (Value < 256) then
    FRADOpacity := Value
  else
    FRADOpacity := 255;
end;

Procedure TfrmAnnotOptionsX.SetRulerLabel(Const Value: String);
Begin
  If FRulerLabel <> Value Then FRulerLabel := Value;
  If edtTextRulerLabel.Text <> FRulerLabel Then edtTextRulerLabel.Text := FRulerLabel;
//  MagAnnotDefaults.Persist('RulerLabel', FRulerLabel);
End;

procedure TfrmAnnotOptionsX.SetShowStrictRAD(const Value: string);
begin
  {/p122 dmmn 8/2/ - options to show strict radiology conversion /}
  if Value = '1' then
    FShowStrictRAD := Value
  else if Value = '0' then
    FShowStrictRAD := Value
  else     // if value is not right then default to false or 0
    FShowStrictRAD := '0';
end;

procedure TfrmAnnotOptionsX.FontStylesClick(Sender: TObject);
begin
  FontStyle := FontStyles.ItemIndex;
  if FontStyle = 0 then
    FontSample.Font.Style := []
  else if FontStyle = 1 then
    FontSample.Font.Style := [fsBold]
  else if FontStyle = 2 then
    FontSample.Font.Style := [fsItalic]
  else if FontStyle = 3 then
    FontSample.Font.Style := [fsBold,fsItalic];
end;

Procedure TfrmAnnotOptionsX.FormActivate(Sender: Tobject);
Begin
  //p122 7/5
//  MagAnnotDefaults.Restore();
  Init();
//  MagAnnotDefaults.SetUndoPoint();
End;

Procedure TfrmAnnotOptionsX.btnCancelClick(Sender: Tobject);
Begin
//  MagAnnotDefaults.Undo();
End;

Procedure TfrmAnnotOptionsX.Init();
//Var
//  inTemp: Integer;
//  I: Integer;
//  fontInd : integer;
Begin
  {/P122 dmmn 7/18/11 - always selects first tab which is font /}
  TabSheet_Special.ActivePage := TabSheet_Font;
  {/P122 - DN - 6/16/2011 - text label for ruler is not used /}
  cbHighlightLine.Visible := False;
  TabSheet_Special.Pages[2].TabVisible := False;   // hide fill color
  TabSheet_Special.Pages[3].TabVisible := False;   // hide border color
  TabSheet_Special.Pages[7].TabVisible := False;   // hide text

  (*

  //frmAnnotOptions.Top
  If MagAnnotDefaults.Value('frmAnnotOptions.Top') <> '' Then
  Begin
    Try
      inTemp := Strtoint(MagAnnotDefaults.Value('frmAnnotOptions.Top'));
      If inTemp < 0 Then inTemp := 0;
      If inTemp > (Screen.Height - Height - 30) Then inTemp := Screen.Height - Height - 30;
      Top := inTemp;
    Except
    End;
  End;
  MagAnnotDefaults.Persist('frmAnnotOptions.Top', Top);

  //frmAnnotOptions.Left
  If MagAnnotDefaults.Value('frmAnnotOptions.Left') <> '' Then
  Begin
    Try
      inTemp := Strtoint(MagAnnotDefaults.Value('frmAnnotOptions.Left'));
      If inTemp < 0 Then inTemp := 0;
      If inTemp > (Screen.Width - Width) Then inTemp := Screen.Width - Width;
      Left := inTemp;
    Except
    End;
  End;
  MagAnnotDefaults.Persist('frmAnnotOptions.Left', Left);

  {/P122 - DN - 6/16/2011 - LineColor /}
  FAnnotLineColor := clYellow;
  if MagAnnotDefaults.Value('AnnotLineColor') <> '' then
  begin
    FAnnotLineColor := StrToInt(MagAnnotDefaults.Value('AnnotLineColor'));
  end;
  MagAnnotDefaults.Persist('AnnotLineColor',FAnnotLineColor);
  LineColorButtonSetByColor(FAnnotLineColor);

  //FillColor
  FAnnotFillColor := clYellow;
  If MagAnnotDefaults.Value('AnnotFillColor') <> '' Then
  Begin
    FAnnotFillColor := Strtoint(MagAnnotDefaults.Value('AnnotFillColor'));
  End;
  MagAnnotDefaults.Persist('AnnotFillColor', FAnnotFillColor);
  FillColorButtonSetByColor(FAnnotFillColor);

  //FontBold
  FFontBold := False;
  If MagAnnotDefaults.Value('FontBold') <> '' Then
  Begin
    FFontBold := StrToBool(MagAnnotDefaults.Value('FontBold'));
  End;
  Fontbold := FFontBold;

  //FontColor
  FFontColor := clBlack;
  If MagAnnotDefaults.Value('FontColor') <> '' Then
  Begin
    FFontColor := Strtoint(MagAnnotDefaults.Value('FontColor'));
  End;
  FontColor := FFontColor;

  //FontItalic
  FFontItalic := False;
  If MagAnnotDefaults.Value('FontItalic') <> '' Then
  Begin
    FFontItalic := StrToBool(MagAnnotDefaults.Value('FontItalic'));
  End;
  FontItalic := FFontItalic;

  //FontName
  FFontName := 'Arial';
  If MagAnnotDefaults.Value('FontName') <> '' Then
  Begin
    FFontName := MagAnnotDefaults.Value('FontName');
  End;
  FontName := FFontName;
  FontDialog.Font.Name := FFontName;

  //FontSize
  FFontSize := 72;
  If MagAnnotDefaults.Value('FontSize') <> '' Then
  Begin
    FFontSize := Strtoint(MagAnnotDefaults.Value('FontSize'));
  End;
  FontSize := FFontSize;

  //FontStrikeOut
  FFontStrikeOut := False;
  If MagAnnotDefaults.Value('FontStrikeOut') <> '' Then
  Begin
    FFontStrikeOut := StrToBool(MagAnnotDefaults.Value('FontStrikeOut'));
  End;
  FontStrikeOut := FFontStrikeOut;

  //FontUnderline
  FFontUnderline := False;
  If MagAnnotDefaults.Value('FontUnderline') <> '' Then
  Begin
    FFontUnderline := StrToBool(MagAnnotDefaults.Value('FontUnderline'));
  End;
  FontUnderline := FFontUnderline;

  //BorderColor
  FAnnotBorderColor := clRed;
  If MagAnnotDefaults.Value('AnnotBorderColor') <> '' Then
  Begin
    FAnnotBorderColor := Strtoint(MagAnnotDefaults.Value('AnnotBorderColor'));
  End;
  MagAnnotDefaults.Persist('AnnotBorderColor', FAnnotBorderColor);
  BorderColorButtonSetByColor(FAnnotBorderColor);

  //LineWidth
  FLineWidth := 1;
  If MagAnnotDefaults.Value('LineWidth') <> '' Then
  Begin
    FLineWidth := Strtoint(MagAnnotDefaults.Value('LineWidth'));
  End;
  LineWidth := FLineWidth;

  //HighlightLine
  FHighlightLine := False;
  If MagAnnotDefaults.Value('HighlightLine') <> '' Then
  Begin
    FHighlightLine := StrToBool(MagAnnotDefaults.Value('HighlightLine'));
  End;
  HighlightLine := FHighlightLine;

  //Opacity
  FOpacity := 127;
  If MagAnnotDefaults.Value('Opacity') <> '' Then
  Begin
    FOpacity := Strtoint(MagAnnotDefaults.Value('Opacity'));
  End;
  Opacity := FOpacity;

  //RulerLabel
  FRulerLabel := '';
  If MagAnnotDefaults.Value('RulerLabel') <> '' Then
  Begin
    FRulerLabel := MagAnnotDefaults.Value('RulerLabel');
  End;
  RulerLabel := FRulerLabel;

  //ArrowPointerStyle
  FArrowPointerStyle := 0;
  If MagAnnotDefaults.Value('ArrowPointerStyle') <> '' Then
  Begin
    FArrowPointerStyle := Strtoint(MagAnnotDefaults.Value('ArrowPointerStyle'));
  End;
  MagAnnotDefaults.Persist('ArrowPointerStyle', FArrowPointerStyle);
  cmboArrowPointerStyle.ItemIndex := FArrowPointerStyle;

  //ArrowPointerLength
  FArrowPointerLength := 40;
  If MagAnnotDefaults.Value('ArrowPointerLength') <> '' Then
  Begin
    FArrowPointerLength := Strtoint(MagAnnotDefaults.Value('ArrowPointerLength'));
  End;
  MagAnnotDefaults.Persist('ArrowPointerLength', FArrowPointerLength);
  If udArrowPointerLength.Position <> FArrowPointerLength Then udArrowPointerLength.Position := FArrowPointerLength;
  If edtArrowPointerLength.Text <> Inttostr(FArrowPointerLength) Then edtArrowPointerLength.Text := Inttostr(FArrowPointerLength);

  //ArrowPointerAngle
  FArrowPointerAngle := 40;
  If MagAnnotDefaults.Value('ArrowPointerAngle') <> '' Then
  Begin
    FArrowPointerAngle := Strtoint(MagAnnotDefaults.Value('ArrowPointerAngle'));
  End;
  MagAnnotDefaults.Persist('ArrowPointerAngle', FArrowPointerAngle);
  If udArrowPointerAngle.Position <> FArrowPointerAngle Then udArrowPointerAngle.Position := FArrowPointerAngle;
  If edtArrowPointerAngle.Text <> Inttostr(FArrowPointerAngle) Then edtArrowPointerAngle.Text := Inttostr(FArrowPointerAngle);

  cbHighlightLine.Checked := FHighlightLine;

  MagAnnotDefaults.Persist();     *)
End;


Function TfrmAnnotOptionsX.RGBToColor(r, g, b: Double): TColor;
Begin
  Result := TColor((Floor(r) * 65536) + (Floor(g) * 256) + Floor(b));
End;

Function TfrmAnnotOptionsX.GetArrowPointerStyle: Integer;
Begin
  Result := FArrowPointerStyle;
End;

Procedure TfrmAnnotOptionsX.SetArrowPointerStyle(Const Value: Integer);
Begin
  If FArrowPointerStyle <> Value Then FArrowPointerStyle := Value;
  If cmboArrowPointerStyle.ItemIndex <> FArrowPointerStyle Then cmboArrowPointerStyle.ItemIndex := FArrowPointerStyle;
//  MagAnnotDefaults.Persist('ArrowPointerStyle', FArrowPointerStyle);
End;

procedure TfrmAnnotOptionsX.SetAutoShowAnnots(const Value: String);
begin
  if Value = '' then
    FAutoShowAnnots := '1'
  else
    FAutoShowAnnots := Value;
end;

Procedure TfrmAnnotOptionsX.cmboArrowPointerStyleChange(Sender: Tobject);
Begin
  ArrowPointerStyle := cmboArrowPointerStyle.ItemIndex;
End;

Function TfrmAnnotOptionsX.GetArrowPointerLength: Integer;
Begin
  Result := FArrowPointerLength;
End;

Procedure TfrmAnnotOptionsX.SetArrowPointerLength(Const Value: Integer);
Begin
  If FArrowPointerLength <> Value Then FArrowPointerLength := Value;
  If udArrowPointerLength.Position <> ArrowPointerLength Then udArrowPointerLength.Position := ArrowPointerLength;
//  MagAnnotDefaults.Persist('ArrowPointerLength', FArrowPointerLength);
End;

Procedure TfrmAnnotOptionsX.udArrowPointerAngleClick(Sender: Tobject;
  Button: TUDBtnType);
Begin
  If ArrowPointerAngle <> udArrowPointerAngle.Position Then ArrowPointerAngle := udArrowPointerAngle.Position;
End;

Procedure TfrmAnnotOptionsX.udArrowPointerLengthClick(Sender: Tobject;
  Button: TUDBtnType);
Begin
  If ArrowPointerLength <> udArrowPointerLength.Position Then ArrowPointerLength := udArrowPointerLength.Position;
End;

Procedure TfrmAnnotOptionsX.edtTextRulerLabelChange(Sender: Tobject);
Begin
  RulerLabel := edtTextRulerLabel.Text;
End;

Function TfrmAnnotOptionsX.GetArrowPointerAngle: Integer;
Begin
  Result := FArrowPointerAngle;
End;

Procedure TfrmAnnotOptionsX.SetArrowPointerAngle(Const Value: Integer);
Begin
  If FArrowPointerAngle <> Value Then FArrowPointerAngle := Value;
  If udArrowPointerAngle.Position <> ArrowPointerAngle Then udArrowPointerAngle.Position := ArrowPointerAngle;
//  MagAnnotDefaults.Persist('ArrowPointerAngle', FArrowPointerAngle);
End;

{ TMagAnnotDefaults }

Constructor TMagAnnotDefaults.Create;
Begin
  IniData := Tstringlist.Create();
  ExeName := ExtractFileName(ParamStr(0));
  ExeName := Lowercase(ExeName);
  ExeName := Uppercase(Copy(ExeName, 1, 1)) + Copy(ExeName, 2, Length(ExeName) - 5);
  ExePath := ExtractFilePath(ParamStr(0));
  FileIni := ExePath + ExeName + '.annots.ini';
  FUndoEnabled := False;
  FUndoPoint := '';
End;

Procedure TMagAnnotDefaults.Persist();
Begin
  IniData.SaveToFile(FileIni);
End;

Procedure TMagAnnotDefaults.Persist(Name: String; Value: Boolean);
Var
  sgValue: String;
Begin
  sgValue := BoolToStr(Value, True);
  If IniData.Values[Name] = sgValue Then Exit;
  IniData.Values[Name] := sgValue;
  Persist();
End;

Procedure TMagAnnotDefaults.Persist(Name: String; Value: Integer);
Var
  sgValue: String;
Begin
  sgValue := Inttostr(Value);
  If IniData.Values[Name] = sgValue Then Exit;
  IniData.Values[Name] := sgValue;
  Persist();
End;

Procedure TMagAnnotDefaults.Restore;
Begin
  If Not FileExists(FileIni) Then IniData.SaveToFile(FileIni);
  IniData.LoadFromFile(FileIni);
  IniData.Sort();
End;

Procedure TMagAnnotDefaults.SetUndoPoint;
Begin
  FUndoPoint := IniData.Text;
  FUndoEnabled := True;
End;

Procedure TMagAnnotDefaults.Undo();
Begin
  If FUndoEnabled Then IniData.SetText(PAnsiChar(FUndoPoint));
  FUndoPoint := '';
  FUndoEnabled := False;
End;

Function TMagAnnotDefaults.Value(Name: String): String;
Begin
  Result := IniData.Values[Name];
End;

Destructor TMagAnnotDefaults.Destroy;
Begin
  Persist();
  FreeAndNil(IniData);
  Inherited;
End;

Procedure TMagAnnotDefaults.Persist(Name, Value: String);
Begin
  IniData.SaveToFile(FileIni);
End;

{$REGION 'New stuff for P122'}
{/P122 - DN - 6/16/2011 /}
procedure TfrmAnnotOptionsX.btnLineColor01Click(Sender: TObject);
begin
  AnnotLineColor := clBlack;
end;

procedure TfrmAnnotOptionsX.btnLineColor02Click(Sender: Tobject);
begin
  AnnotLineColor := clMedGray;
end;

procedure TfrmAnnotOptionsX.btnLineColor03Click(Sender: Tobject);
begin
  AnnotLineColor := clMaroon;
end;

procedure TfrmAnnotOptionsX.btnLineColor04Click(Sender: Tobject);
begin
  AnnotLineColor := clOlive;
end;

procedure TfrmAnnotOptionsX.btnLineColor05Click(Sender: Tobject);
begin
  AnnotLineColor := clGreen;
end;

procedure TfrmAnnotOptionsX.btnLineColor06Click(Sender: Tobject);
begin
  AnnotLineColor := clTeal;
end;

procedure TfrmAnnotOptionsX.btnLineColor07Click(Sender: Tobject);
begin
  AnnotLineColor := clNavy;
end;

procedure TfrmAnnotOptionsX.btnLineColor08Click(Sender: Tobject);
begin
  AnnotLineColor := clPurple;
end;

procedure TfrmAnnotOptionsX.btnLineColor09Click(Sender: Tobject);
begin
  AnnotLineColor := clWhite;
end;

procedure TfrmAnnotOptionsX.btnLineColor10Click(Sender: Tobject);
begin
  AnnotLineColor := clSilver;
end;

procedure TfrmAnnotOptionsX.btnLineColor11Click(Sender: Tobject);
begin
  AnnotLineColor := clRed;
end;

procedure TfrmAnnotOptionsX.btnLineColor12Click(Sender: Tobject);
begin
  AnnotLineColor := clYellow;
end;

procedure TfrmAnnotOptionsX.btnLineColor13Click(Sender: Tobject);
begin
  AnnotLineColor := clLime;
end;

procedure TfrmAnnotOptionsX.btnLineColor14Click(Sender: Tobject);
begin
  AnnotLineColor := clAqua;
end;

procedure TfrmAnnotOptionsX.btnLineColor15Click(Sender: Tobject);
begin
  AnnotLineColor := clBlue;
end;

procedure TfrmAnnotOptionsX.btnLineColor16Click(Sender: Tobject);
begin
  AnnotLineColor := clFuchsia;
end;

procedure TfrmAnnotOptionsX.SetAnnotLineColor(const Value: TColor);
{/P122 - DN - 6/16/2011 /}
begin
  if FAnnotLineColor <> Value Then
    FAnnotLineColor := Value;
  FontDialog.Font.Color := FAnnotLineColor;
  LineColorButtonSetByColor(FAnnotLineColor);
//  MagAnnotDefaults.Persist('AnnotLineColor', FAnnotLineColor);
end;

procedure TfrmAnnotOptionsX.LineColorButtonsDeSelectAll;
{/P122 - DN - 6/16/2011 /}
begin
  btnLineColor01.Flat := False;
  btnLineColor02.flat := False;
  btnLineColor03.flat := False;
  btnLineColor04.flat := False;
  btnLineColor05.flat := False;
  btnLineColor06.flat := False;
  btnLineColor07.flat := False;
  btnLineColor08.flat := False;
  btnLineColor09.flat := False;
  btnLineColor10.flat := False;
  btnLineColor11.flat := False;
  btnLineColor12.flat := False;
  btnLineColor13.flat := False;
  btnLineColor14.flat := False;
  btnLineColor15.flat := False;
  btnLineColor16.flat := False;
end;

procedure TfrmAnnotOptionsX.LineColorButtonSetByColor(c: TColor);
{/P122 - DN - 6/16/2011 /}
begin
  LineColorButtonsDeSelectAll();
  Case c Of
    clBlack:
    begin
      btnLineColor01.Flat := True;
      Label6.Caption := 'Color selected: Black';
    end;
    clMedGray:
    begin
      btnLineColor02.Flat := True;
      Label6.Caption := 'Color selected: Gray';
    end;
    clMaroon:
    begin
      btnLineColor03.Flat := True;
      Label6.Caption := 'Color selected: Maroon';
    end;
    clOlive:
    begin
      btnLineColor04.Flat := True;
      Label6.Caption := 'Color selected: Olive';
    end;
    clGreen:
    begin
      btnLineColor05.Flat := True;
      Label6.Caption := 'Color selected: Green';
    end;
    clTeal:
    begin
      btnLineColor06.Flat := True;
      Label6.Caption := 'Color selected: Teal';
    end;
    clNavy:
    begin
      btnLineColor07.Flat := True;
      Label6.Caption := 'Color selected: Navy';
    end;
    clPurple:
    begin
      btnLineColor08.Flat := True;
      Label6.Caption := 'Color selected: Purple';
    end;
    clWhite:
    begin
      btnLineColor09.Flat := True;
      Label6.Caption := 'Color selected: White';
    end;
    clSilver:
    begin
      btnLineColor10.Flat := True;
      Label6.Caption := 'Color selected: Silver';
    end;
    clRed:
    begin
      btnLineColor11.Flat := True;
      Label6.Caption := 'Color selected: Red';
    end;
    clYellow:
    begin
      btnLineColor12.Flat := True;
      Label6.Caption := 'Color selected: Yellow';
    end;
    cllime:
    begin
      btnLineColor13.Flat := True;
      Label6.Caption := 'Color selected: Lime';
    end;
    clAqua:
    begin
      btnLineColor14.Flat := True;
      Label6.Caption := 'Color selected: Aqua';
    end;
    clBlue:
    begin
      btnLineColor15.Flat := True;
      Label6.Caption := 'Color selected: Blue';
    end;
    clFuchsia:
    begin
      btnLineColor16.Flat := True;
      Label6.Caption := 'Color selected: Fuchsia';
    end;
  Else
  begin
    btnLineColor05.Flat := True;
    Label6.Caption := 'Color selected: Green';
  end;
  End;
end;

procedure TfrmAnnotOptionsX.SetUserPreferences(const Value: string);

  function IsANumber(S: String): Boolean;
  var
    IntVal: Integer;
  begin
    try
      IntVal := StrToInt(S);
      Result := True;
    except
        Result := False;
    end;
  end;

begin
  VistASettings.Clear;      // clear old settings
  VistASettings.StrictDelimiter := True;    // parse the settings
  VistASettings.Delimiter := '^';
  VistASettings.DelimitedText := Value;

  // p122 7/5/11 - apply the settings
  if Trim(VistASettings[1]) <> '' then
    FontName := VistASettings[1];

  if IsANumber(VistASettings[2]) then
    FontStyle := StrToInt(VistASettings[2]);

  if IsANumber(VistASettings[3]) then
    FontSize := StrToInt(VistASettings[3]);

  if IsANumber(VistASettings[4]) then   
    LineWidth := StrToInt(VistASettings[4]);

  if IsANumber(VistASettings[5]) then
    AnnotLineColor := StrToInt(VistASettings[5]);

  if IsANumber(VistASettings[6]) then   
    Opacity := StrToInt(VistASettings[6]);

  if IsANumber(VistASettings[7]) then   
    ArrowPointerStyle := StrToInt(VistASettings[7]);

  if IsANumber(VistASettings[8]) then
    ArrowPointerLength := StrToInt(VistASettings[8]);

  if IsANumber(VistASettings[9]) then
    ArrowPointerAngle := StrToInt(VistASettings[9]);

  if IsANumber(VistASettings[10]) then
    Top := StrToInt(VistASettings[10]);

  if IsANumber(VistASettings[11]) then
    Left := StrToInt(VistASettings[11]);

  if VistASettings[0] = 'ANNOTDISPLAY' then
  begin
    if VistASettings.Count >= 13 then
      AutoShowAnnots := VistASettings[12]
    else
      AutoShowAnnots := '';
  end;
end;

function TfrmAnnotOptionsX.GetUserPreferences: string;
begin
  Result := FontName + '^' + IntToStr(FontStyle) + '^' + IntToStr(FontSize) + '^' +
            IntToStr(LineWidth) + '^' + IntToStr(AnnotLineColor) + '^' + IntToStr(Opacity) + '^' +
            IntToStr(ArrowPointerStyle) + '^' + IntToStr(ArrowPointerLength) + '^' +
            IntToStr(ArrowPointerAngle) + '^' + IntToStr(Top) + '^' + IntToStr(Left) + '^' + AutoShowAnnots;
end;

{$ENDREGION}

Initialization
//  MagAnnotDefaults := TMagAnnotDefaults.Create();
Finalization
//  FreeAndNil(MagAnnotDefaults);
End.
