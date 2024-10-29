Unit fMagAnnotOptions;

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

  TfrmAnnotOptions = Class(TForm)
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
  Protected
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
    FFontStrikeOut: Boolean;
    FFontUnderline: Boolean;
    FHighlightLine: Boolean;
    FLineWidth: Integer;
    FOpacity: Integer;
    FRulerLabel: String;
    Function GetArrowPointerLength: Integer;
    Function GetArrowPointerStyle: Integer;
    Function GetArrowPointerAngle: Integer;
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
    Procedure SetFontStrikeOut(Const Value: Boolean);
    Procedure SetFontUnderline(Const Value: Boolean);
    Procedure SetHighlightLine(Const Value: Boolean);
    Procedure SetLineWidth(Const Value: Integer);
    Procedure SetOpacity(Const Value: Integer);
    Procedure SetRulerLabel(Const Value: String);
  Public
    Function RGBToColor(r, g, b: Double): TColor;
    Procedure BorderColorButtonsDeSelectAll();
    Procedure BorderColorButtonSetByColor(c: TColor);
    Procedure ColorToRGB(c: TColor; Out r, g, b: Integer);
    Procedure FillColorButtonsDeSelectAll();
    Procedure FillColorButtonSetByColor(c: TColor);
    Procedure Init();
  Published
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
    Property FontStrikeOut: Boolean Read FFontStrikeOut Write SetFontStrikeOut;
    Property FontUnderline: Boolean Read FFontUnderline Write SetFontUnderline;
    Property HighlightLine: Boolean Read FHighlightLine Write SetHighlightLine;
    Property LineWidth: Integer Read FLineWidth Write SetLineWidth;
    Property Opacity: Integer Read FOpacity Write SetOpacity;
    Property RulerLabel: String Read FRulerLabel Write SetRulerLabel;
  End;

Var
  frmAnnotOptionsx: TfrmAnnotOptions;
  MagAnnotDefaults: TMagAnnotDefaults;

Implementation
Uses
  fMagAnnot,
  Math;
{$R *.dfm}

Procedure TfrmAnnotOptions.FormClose(Sender: Tobject; Var action: TCloseAction);
Begin
  MagAnnotDefaults.Persist('frmAnnotOptions.Top', Top);
  MagAnnotDefaults.Persist('frmAnnotOptions.Left', Left);
End;

Procedure TfrmAnnotOptions.FormCreate(Sender: Tobject);
Begin
  MagAnnotDefaults.Restore();
  Init();
End;

Procedure TfrmAnnotOptions.btnFillColor01Click(Sender: Tobject);
Begin
  AnnotFillColor := clBlack;
End;

Procedure TfrmAnnotOptions.btnFillColor02Click(Sender: Tobject);
Begin
  AnnotFillColor := clMedGray;
End;

Procedure TfrmAnnotOptions.btnFillColor03Click(Sender: Tobject);
Begin
  AnnotFillColor := clMaroon;
End;

Procedure TfrmAnnotOptions.btnFillColor04Click(Sender: Tobject);
Begin
  AnnotFillColor := clOlive;
End;

Procedure TfrmAnnotOptions.btnFillColor05Click(Sender: Tobject);
Begin
  AnnotFillColor := clGreen;
End;

Procedure TfrmAnnotOptions.btnFillColor06Click(Sender: Tobject);
Begin
  AnnotFillColor := clTeal;
End;

Procedure TfrmAnnotOptions.btnFillColor07Click(Sender: Tobject);
Begin
  AnnotFillColor := clNavy;
End;

Procedure TfrmAnnotOptions.btnFillColor08Click(Sender: Tobject);
Begin
  AnnotFillColor := clPurple;
End;

Procedure TfrmAnnotOptions.btnFillColor09Click(Sender: Tobject);
Begin
  AnnotFillColor := clFuchsia;
End;

Procedure TfrmAnnotOptions.btnFillColor10Click(Sender: Tobject);
Begin
  AnnotFillColor := clBlue;
End;

Procedure TfrmAnnotOptions.btnFillColor11Click(Sender: Tobject);
Begin
  AnnotFillColor := clAqua;
End;

Procedure TfrmAnnotOptions.btnFillColor12Click(Sender: Tobject);
Begin
  AnnotFillColor := cllime;
End;

Procedure TfrmAnnotOptions.btnFillColor13Click(Sender: Tobject);
Begin
  AnnotFillColor := clYellow;
End;

Procedure TfrmAnnotOptions.btnFillColor14Click(Sender: Tobject);
Begin
  AnnotFillColor := clRed;
End;

Procedure TfrmAnnotOptions.btnFillColor15Click(Sender: Tobject);
Begin
  AnnotFillColor := clSilver;
End;

Procedure TfrmAnnotOptions.btnFillColor16Click(Sender: Tobject);
Begin
  AnnotFillColor := clWhite;
End;

Procedure TfrmAnnotOptions.Button1Click(Sender: Tobject);
Begin
  If FontDialog.Execute Then
  Begin
    Fontbold := (Fsbold In FontDialog.Font.Style);
    FontColor := FontDialog.Font.Color;
    FontItalic := (Fsitalic In FontDialog.Font.Style);
    FontName := FontDialog.Font.Name;
    FontSize := FontDialog.Font.Size;
    FontStrikeOut := (FsStrikeOut In FontDialog.Font.Style);
    FontUnderline := (fsUnderline In FontDialog.Font.Style);
  End;
End;

Procedure TfrmAnnotOptions.SetAnnotFillColor(Const Value: TColor);
Begin
  If FAnnotFillColor <> Value Then FAnnotFillColor := Value;
  FillColorButtonSetByColor(FAnnotFillColor);
  MagAnnotDefaults.Persist('AnnotFillColor', FAnnotFillColor);
End;

Procedure TfrmAnnotOptions.SetFontBold(Const Value: Boolean);
Begin
  If FFontBold <> Value Then FFontBold := Value;
  If FFontBold And (Not (Fsbold In FontDialog.Font.Style)) Then FontDialog.Font.Style := FontDialog.Font.Style + [Fsbold];
  If (Not FFontBold) And (Fsbold In FontDialog.Font.Style) Then FontDialog.Font.Style := FontDialog.Font.Style - [Fsbold];
  MagAnnotDefaults.Persist('FontBold', FFontBold);
End;

Procedure TfrmAnnotOptions.SetFontColor(Const Value: TColor);
Begin
  If FFontColor <> Value Then FFontColor := Value;
  If FontDialog.Font.Color <> FFontColor Then FontDialog.Font.Color := FFontColor;
  MagAnnotDefaults.Persist('FontColor', FFontColor);
End;

Procedure TfrmAnnotOptions.SetFontItalic(Const Value: Boolean);
Begin
  If FFontItalic <> Value Then FFontItalic := Value;
  If FFontItalic And (Not (Fsitalic In FontDialog.Font.Style)) Then FontDialog.Font.Style := FontDialog.Font.Style + [Fsitalic];
  If (Not FFontItalic) And (Fsitalic In FontDialog.Font.Style) Then FontDialog.Font.Style := FontDialog.Font.Style - [Fsitalic];
  MagAnnotDefaults.Persist('FontItalic', FFontItalic);
End;

Procedure TfrmAnnotOptions.SetFontName(Const Value: String);
Begin
  If FFontName <> Value Then FFontName := Value;
  If FontDialog.Font.Name <> FFontName Then FontDialog.Font.Name := FFontName;
  MagAnnotDefaults.Persist('FontName', FFontName);
End;

Procedure TfrmAnnotOptions.SetFontSize(Const Value: Integer);
Begin
  If FFontSize <> Value Then FFontSize := Value;
  If FontDialog.Font.Size <> FFontSize Then FontDialog.Font.Size := FFontSize;
  MagAnnotDefaults.Persist('FontSize', FFontSize);
End;

Procedure TfrmAnnotOptions.SetFontStrikeOut(Const Value: Boolean);
Begin
  If FFontStrikeOut <> Value Then FFontStrikeOut := Value;
  If FFontStrikeOut And (Not (FsStrikeOut In FontDialog.Font.Style)) Then FontDialog.Font.Style := FontDialog.Font.Style + [FsStrikeOut];
  If (Not FFontStrikeOut) And (FsStrikeOut In FontDialog.Font.Style) Then FontDialog.Font.Style := FontDialog.Font.Style - [FsStrikeOut];
  MagAnnotDefaults.Persist('FontStrikeOut', FFontStrikeOut);
End;

Procedure TfrmAnnotOptions.SetFontUnderline(Const Value: Boolean);
Begin
  If FFontUnderline <> Value Then FFontUnderline := Value;
  If FFontUnderline And (Not (fsUnderline In FontDialog.Font.Style)) Then FontDialog.Font.Style := FontDialog.Font.Style + [fsUnderline];
  If (Not FFontUnderline) And (fsUnderline In FontDialog.Font.Style) Then FontDialog.Font.Style := FontDialog.Font.Style - [fsUnderline];
  MagAnnotDefaults.Persist('FontUnderline', FFontUnderline);
End;

Procedure TfrmAnnotOptions.ColorToRGB(c: TColor; Out r, g, b: Integer);
Begin
  r := c And $FF;
  g := (c And $FF00) Shr 8;
  b := (c And $FF0000) Shr 16;
End;

Procedure TfrmAnnotOptions.btnBorderColor01Click(Sender: Tobject);
Begin
  AnnotBorderColor := clBlack;
End;

Procedure TfrmAnnotOptions.btnBorderColor02Click(Sender: Tobject);
Begin
  AnnotBorderColor := clMedGray;
End;

Procedure TfrmAnnotOptions.btnBorderColor03Click(Sender: Tobject);
Begin
  AnnotBorderColor := clMaroon;
End;

Procedure TfrmAnnotOptions.btnBorderColor04Click(Sender: Tobject);
Begin
  AnnotBorderColor := clOlive;
End;

Procedure TfrmAnnotOptions.btnBorderColor05Click(Sender: Tobject);
Begin
  AnnotBorderColor := clGreen;
End;

Procedure TfrmAnnotOptions.btnBorderColor06Click(Sender: Tobject);
Begin
  AnnotBorderColor := clTeal;
End;

Procedure TfrmAnnotOptions.btnBorderColor07Click(Sender: Tobject);
Begin
  AnnotBorderColor := clNavy;
End;

Procedure TfrmAnnotOptions.btnBorderColor08Click(Sender: Tobject);
Begin
  AnnotBorderColor := clPurple;
End;

Procedure TfrmAnnotOptions.btnBorderColor09Click(Sender: Tobject);
Begin
  AnnotBorderColor := clFuchsia;
End;

Procedure TfrmAnnotOptions.btnBorderColor10Click(Sender: Tobject);
Begin
  AnnotBorderColor := clBlue;
End;

Procedure TfrmAnnotOptions.btnBorderColor11Click(Sender: Tobject);
Begin
  AnnotBorderColor := clAqua;
End;

Procedure TfrmAnnotOptions.btnBorderColor12Click(Sender: Tobject);
Begin
  AnnotBorderColor := cllime;
End;

Procedure TfrmAnnotOptions.btnBorderColor13Click(Sender: Tobject);
Begin
  AnnotBorderColor := clYellow;
End;

Procedure TfrmAnnotOptions.btnBorderColor14Click(Sender: Tobject);
Begin
  AnnotBorderColor := clRed;
End;

Procedure TfrmAnnotOptions.btnBorderColor15Click(Sender: Tobject);
Begin
  AnnotBorderColor := clSilver;
End;

Procedure TfrmAnnotOptions.btnBorderColor16Click(Sender: Tobject);
Begin
  AnnotBorderColor := clWhite;
End;

Procedure TfrmAnnotOptions.SetAnnotBorderColor(Const Value: TColor);
Begin
  If FAnnotBorderColor <> Value Then FAnnotBorderColor := Value;
  BorderColorButtonSetByColor(FAnnotBorderColor);
  MagAnnotDefaults.Persist('AnnotBorderColor', FAnnotBorderColor);
End;

Procedure TfrmAnnotOptions.BorderColorButtonsDeSelectAll;
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

Procedure TfrmAnnotOptions.BorderColorButtonSetByColor(c: TColor);
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

Procedure TfrmAnnotOptions.FillColorButtonsDeSelectAll;
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

Procedure TfrmAnnotOptions.FillColorButtonSetByColor(c: TColor);
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

Procedure TfrmAnnotOptions.SetLineWidth(Const Value: Integer);
Begin
  If FLineWidth <> Value Then FLineWidth := Value;
  If udLineSize.Position <> FLineWidth Then udLineSize.Position := FLineWidth;
  If edtLineSize.Text <> Inttostr(FLineWidth) Then edtLineSize.Text := Inttostr(FLineWidth);
  MagAnnotDefaults.Persist('LineWidth', FLineWidth);
End;

Procedure TfrmAnnotOptions.edtLineSizeChange(Sender: Tobject);
Begin
  If LineWidth <> udLineSize.Position Then LineWidth := udLineSize.Position;
End;

Procedure TfrmAnnotOptions.SetHighlightLine(Const Value: Boolean);
Begin
  If FHighlightLine <> Value Then FHighlightLine := Value;
  If cbHighlightLine.Checked <> FHighlightLine Then cbHighlightLine.Checked := FHighlightLine;
  MagAnnotDefaults.Persist('HighlightLine', FHighlightLine);
End;

Procedure TfrmAnnotOptions.cbHighlightLineClick(Sender: Tobject);
Begin
  HighlightLine := cbHighlightLine.Checked;
End;

Procedure TfrmAnnotOptions.SetOpacity(Const Value: Integer);
Begin
  If FOpacity <> Value Then FOpacity := Value;
  If udOpacity.Position <> FOpacity Then udOpacity.Position := FOpacity;
  If tbOpacity.Position <> FOpacity Then tbOpacity.Position := FOpacity;
  MagAnnotDefaults.Persist('Opacity', FOpacity);
End;

Procedure TfrmAnnotOptions.edtOpacityChange(Sender: Tobject);
Begin
  Opacity := udOpacity.Position;
End;

Procedure TfrmAnnotOptions.tbOpacityChange(Sender: Tobject);
Begin
  Opacity := tbOpacity.Position;
End;

Procedure TfrmAnnotOptions.SetRulerLabel(Const Value: String);
Begin
  If FRulerLabel <> Value Then FRulerLabel := Value;
  If edtTextRulerLabel.Text <> FRulerLabel Then edtTextRulerLabel.Text := FRulerLabel;
  MagAnnotDefaults.Persist('RulerLabel', FRulerLabel);
End;

Procedure TfrmAnnotOptions.FormActivate(Sender: Tobject);
Begin
  MagAnnotDefaults.Restore();
  Init();
  MagAnnotDefaults.SetUndoPoint();
End;

Procedure TfrmAnnotOptions.btnCancelClick(Sender: Tobject);
Begin
  MagAnnotDefaults.Undo();
End;

Procedure TfrmAnnotOptions.Init();
Var
  inTemp: Integer;
Begin
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

  MagAnnotDefaults.Persist();
End;

Function TfrmAnnotOptions.RGBToColor(r, g, b: Double): TColor;
Begin
  Result := TColor((Floor(r) * 65536) + (Floor(g) * 256) + Floor(b));
End;

Function TfrmAnnotOptions.GetArrowPointerStyle: Integer;
Begin
  Result := FArrowPointerStyle;
End;

Procedure TfrmAnnotOptions.SetArrowPointerStyle(Const Value: Integer);
Begin
  If FArrowPointerStyle <> Value Then FArrowPointerStyle := Value;
  If cmboArrowPointerStyle.ItemIndex <> FArrowPointerStyle Then cmboArrowPointerStyle.ItemIndex := FArrowPointerStyle;
  MagAnnotDefaults.Persist('ArrowPointerStyle', FArrowPointerStyle);
End;

Procedure TfrmAnnotOptions.cmboArrowPointerStyleChange(Sender: Tobject);
Begin
  ArrowPointerStyle := cmboArrowPointerStyle.ItemIndex;
End;

Function TfrmAnnotOptions.GetArrowPointerLength: Integer;
Begin
  Result := FArrowPointerLength;
End;

Procedure TfrmAnnotOptions.SetArrowPointerLength(Const Value: Integer);
Begin
  If FArrowPointerLength <> Value Then FArrowPointerLength := Value;
  If udArrowPointerLength.Position <> ArrowPointerLength Then udArrowPointerLength.Position := ArrowPointerLength;
  MagAnnotDefaults.Persist('ArrowPointerLength', FArrowPointerLength);
End;

Procedure TfrmAnnotOptions.udArrowPointerAngleClick(Sender: Tobject;
  Button: TUDBtnType);
Begin
  If ArrowPointerAngle <> udArrowPointerAngle.Position Then ArrowPointerAngle := udArrowPointerAngle.Position;
End;

Procedure TfrmAnnotOptions.udArrowPointerLengthClick(Sender: Tobject;
  Button: TUDBtnType);
Begin
  If ArrowPointerLength <> udArrowPointerLength.Position Then ArrowPointerLength := udArrowPointerLength.Position;
End;

Procedure TfrmAnnotOptions.edtTextRulerLabelChange(Sender: Tobject);
Begin
  RulerLabel := edtTextRulerLabel.Text;
End;

Function TfrmAnnotOptions.GetArrowPointerAngle: Integer;
Begin
  Result := FArrowPointerAngle;
End;

Procedure TfrmAnnotOptions.SetArrowPointerAngle(Const Value: Integer);
Begin
  If FArrowPointerAngle <> Value Then FArrowPointerAngle := Value;
  If udArrowPointerAngle.Position <> ArrowPointerAngle Then udArrowPointerAngle.Position := ArrowPointerAngle;
  MagAnnotDefaults.Persist('ArrowPointerAngle', FArrowPointerAngle);
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

Initialization
  MagAnnotDefaults := TMagAnnotDefaults.Create();
Finalization
  FreeAndNil(MagAnnotDefaults);
End.
