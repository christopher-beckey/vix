unit fMagAnnotationMarkProperty;

interface

uses
  Windows, Messages, SysUtils, Variants, Classes, Graphics, Controls, Forms,
  Dialogs, ComCtrls, ExtCtrls, StdCtrls, Buttons, StrUtils,

  // ImageGear Units
  GearCORELib_TLB, GearViewLib_TLB, GearArtXGUILib_TLB, GearArtXLib_TLB;

type
  TfrmMagAnnotationMarkProperty = class(TForm)
    Panel1: TPanel;
    Panel2: TPanel;
    PageControl1: TPageControl;
    pageShape: TTabSheet;
    ShapeStartLbl: TLabel;
    ShapeStartLengthLbl: TLabel;
    ShapeStartAngleLbl: TLabel;
    ShapeWidthUpDown: TUpDown;
    ShapeClosed : TCheckBox;
    ShapeStartArrowStyle: TComboBox;
    pageColor: TTabSheet;
    Label3: TLabel;
    Label1: TLabel;
    Label2: TLabel;
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
    Opacity: TTrackBar;
    pageFont: TTabSheet;
    pageMeasure: TTabSheet;
    ShapeWidthLbl: TLabel;
    ShapeWidth: TEdit;
    editPrecision: TLabeledEdit;
    editStartLineLength: TLabeledEdit;
    editEndLineLength: TLabeledEdit;
    pageText: TTabSheet;
    ShapeStartArrowLength: TEdit;
    ShapeStartArrowAngle: TEdit;
    ShapeStartArrowLengthUpDown: TUpDown;
    ShapeStartArrowAngleUpDown: TUpDown;
    ShapeArrowPanel: TPanel;
    OpacityPanel: TPanel;
    PrecisionUpDown: TUpDown;
    RulerStartLengthUpDown: TUpDown;
    RulerEndLengthUpDown: TUpDown;
    Label4: TLabel;
    ShapeEndArrowStyle: TComboBox;
    ShapeEndLengthLbl: TLabel;
    ShapeEndArrowLength: TEdit;
    ShapeEndArrowAngleUpDown: TUpDown;
    ShapeEndAngleLbl: TLabel;
    ShapeEndArrowAngle: TEdit;
    ShapeEndArrowLengthUpDown: TUpDown;
    NoFillColor: TCheckBox;
    Memo1: TMemo;
    TextWordWrap: TCheckBox;
    TextAlignmentLbl: TLabel;
    TextBoundsWrapLbl: TLabel;
    TextAlignment: TComboBox;
    TextBoundsWrap: TComboBox;
    FontList: TListBox;
    FontLbl: TLabel;
    StyleLbl: TLabel;
    FontSizeLbl: TLabel;
    FontStyles: TListBox;
    FontSizes: TListBox;
    FontSample: TPanel;
    Label5: TLabel;
    Panel4: TPanel;
    btnClose: TButton;
    procedure FormShow(Sender: TObject);

    procedure btnLineColor01Click(Sender: TObject);
    procedure btnLineColor02Click(Sender: TObject);
    procedure btnLineColor03Click(Sender: TObject);
    procedure btnLineColor04Click(Sender: TObject);
    procedure btnLineColor05Click(Sender: TObject);
    procedure btnLineColor06Click(Sender: TObject);
    procedure btnLineColor07Click(Sender: TObject);
    procedure btnLineColor08Click(Sender: TObject);
    procedure btnLineColor09Click(Sender: TObject);
    procedure btnLineColor10Click(Sender: TObject);
    procedure btnLineColor11Click(Sender: TObject);
    procedure btnLineColor12Click(Sender: TObject);
    procedure btnLineColor13Click(Sender: TObject);
    procedure btnLineColor14Click(Sender: TObject);
    procedure btnLineColor15Click(Sender: TObject);
    procedure btnLineColor16Click(Sender: TObject);

    procedure ShapeWidthUpDownClick(Sender: TObject; Button: TUDBtnType);
    procedure OpacityChange(Sender: TObject);
    procedure btnFontClick(Sender: TObject);
    procedure PrecisionUpDownClick(Sender: TObject; Button: TUDBtnType);
    procedure RulerStartLengthUpDownClick(Sender: TObject; Button: TUDBtnType);
    procedure RulerEndLengthUpDownClick(Sender: TObject; Button: TUDBtnType);
    procedure ShapeStartArrowStyleChange(Sender: TObject);
    procedure ShapeEndArrowStyleChange(Sender: TObject);
    procedure ShapeStartArrowLengthUpDownClick(Sender: TObject;Button: TUDBtnType);
    procedure ShapeStartArrowAngleUpDownClick(Sender: TObject;Button: TUDBtnType);
    procedure ShapeEndArrowLengthUpDownClick(Sender: TObject;Button: TUDBtnType);
    procedure ShapeEndArrowAngleUpDownClick(Sender: TObject;Button: TUDBtnType);
    procedure NoFillColorClick(Sender: TObject);
    procedure TextAlignmentChange(Sender: TObject);
    procedure Memo1Change(Sender: TObject);
    procedure TextBoundsWrapChange(Sender: TObject);
    procedure FormCreate(Sender: TObject);
    procedure FontListClick(Sender: TObject);
    procedure FontStylesClick(Sender: TObject);
    procedure FontSizesClick(Sender: TObject);
    procedure ShapeClosedClick(Sender: TObject);
    procedure btnCloseClick(Sender: TObject);
    procedure FormClose(Sender: TObject; var Action: TCloseAction);
    procedure TextWordWrapClick(Sender: TObject);

  private
    { Private declarations }
    FIGPageViewCtl : TIGPageViewCtl;
    FIGCoreCtl : TIGCoreCtl;
    
    FArtPage : IIGArtXPage;
    CurrentMark : IIGArtXMark;

    FIGLineColor : IIGPixel;
    FIGFillColor : IIGPixel;
    FIGTextColor : IIGPixel;

    FFillColor : TColor;
    FTextColor : TColor;

    AnnotLineColor : TColor;
    AnnotFillColor : TColor;

    FResultedText : boolean; //p122 dmmn 7/27/11 - flag for resulted text

    {/p122 dmmn 8/26/11 - prestates of the mark, to be compared when user click ok or closed /}
    FPreFontName : string;
    FPreFontStyle : integer;
    FPreFontSize : double;
    FPreText : string;
    FPreAlign : integer;
    FPreBoundWrap : integer;
    FPreWidth : integer;
    FPreClosed : boolean;
    FPreArrowStyle : integer;
    FPreArrowLength : integer;
    FPreArrowAngle : integer;
    FPreColor : TColor;
    FPreFill : boolean;
    FPreOpacity : integer;
    FPreMeasStartLineLength : integer;
    FPreMeasEndLineLength : integer;
    // post states
    FPostFontName : string;
    FPostFontStyle : integer;
    FPostFontSize : double;
    FPostText : string;
    FPostAlign : integer;
    FPostBoundWrap : integer;
    FPostWidth : integer;
    FPostClosed : boolean;
    FPostArrowStyle : integer;
    FPostArrowLength : integer;
    FPostArrowAngle : integer;
    FPostColor : TColor;
    FPostFill : boolean;
    FPostOpacity : integer;
    FPostMeasStartLineLength : integer;
    FPostMeasEndLineLength : integer;

    FChanged : boolean;

    Procedure ConfigureLine;
    Procedure ConfigureRect;
    Procedure ConfigureEllipse;
    Procedure ConfigureFreehand;
    Procedure ConfigureText;
    Procedure ConfigurePolyline;
    Procedure ConfigureRuler;
    Procedure ConfigureProtractor;

    Procedure InitLineProps;
    Procedure InitEllipseProps;
    Procedure InitRectProps;
    Procedure InitFreehandProps;
    Procedure InitTextProps;
    Procedure InitPolylineProps;
    Procedure InitRulerProps;
    Procedure InitProtractorProps;

    Function ConvertRGBToColor(R,G,B : Byte) : TColor;
    Procedure ConvertColorToRGB(c: TColor; Out r, g, b: Integer);

    procedure ChangeAnnotLineColor;
    procedure SetAnnotLineColor(const Value: TColor);
    Procedure LineColorButtonSetByColor(const color : TColor);
    Procedure LineColorButtonsDeSelectAll;
//    procedure ShowMultipleSeletectWarning(const Value: boolean);
  public
    { Public declarations }
    procedure SetCurrentMark(Value: IIGArtXMark);
  published
    Property IGPageViewCtl : TIGPageViewCtl read FIGPageViewCtl write FIGPageViewCtl;
    Property IGCoreCtl : TIGCoreCtl read FIGCoreCtl write FIGCoreCtl;
//    Property MultWarn : boolean write ShowMultipleSeletectWarning;
    Property AnnotationChanged : boolean read FChanged write FChanged;
  end;

var
  frmMagAnnotationMarkProperty: TfrmMagAnnotationMarkProperty;

implementation

{$R *.dfm}

procedure TfrmMagAnnotationMarkProperty.SetCurrentMark(Value: IIGArtXMark);
begin
  CurrentMark := Value;
end;

procedure TfrmMagAnnotationMarkProperty.FormClose(Sender: TObject;
  var Action: TCloseAction);
begin
  //p122t11 another check for illegal characters
  if (AnsiPos('&', Memo1.Text) > 0) or
     (AnsiPos('>', Memo1.Text) > 0) or
     (AnsiPos('<', Memo1.Text) > 0) then
  begin
    Action := caNone;
    ShowMessage('The following characters && < > are not supported. Please modify your input.');
    Exit;
  end;
  Action := caHide;
  AnnotationChanged := False;
  {/p122 dmmn 8/26 - check to see if the prestates and poststates are different /}
  if FPreFontName <> FPostFontName then
  begin
    AnnotationChanged := True;
    Exit;
  end;
  if FPreFontStyle <> FPostFontStyle then
  begin
    AnnotationChanged := True;
    Exit;
  end;
  if FPreFontSize <> FPostFontSize then
  begin
    AnnotationChanged := True;
    Exit;
  end;
  if FPreText <> FPostText then
  begin
    AnnotationChanged := True;
    {/p122t3 9/19 /}
    if (CurrentMark as IIGArtXText).Text = '' then
    begin
      (CurrentMark as IIGArtXText).Text := 'Enter Text Here';
      IGPageViewCtl.UpdateView;
    end;
    Exit;
  end;
  if FPreAlign <> FPostAlign then
  begin
    AnnotationChanged := True;
    Exit;
  end;
  if FPreBoundWrap <> FPostBoundWrap then
  begin
    AnnotationChanged := True;
    Exit;
  end;
  if FPreWidth <> FPostWidth then
  begin
    AnnotationChanged := True;
    Exit;
  end;
  if FPreClosed <> FPostClosed then
  begin
    AnnotationChanged := True;
    Exit;
  end;
  if FPreArrowStyle <> FPostArrowStyle then
  begin
    AnnotationChanged := True;
    Exit;
  end;
  if (FPreArrowStyle <> 4) and (FPreArrowLength <> FPostArrowLength) then
  begin
    AnnotationChanged := True;
    Exit;
  end;
  if (FPreArrowStyle <> 4) and (FPreArrowAngle <> FPostArrowAngle) then
  begin
    AnnotationChanged := True;
    Exit;
  end;
  if FPreColor <> FPostColor then
  begin
    AnnotationChanged := True;
    Exit;
  end;
  if FPreFill <> FPostFill then
  begin
    AnnotationChanged := True;
    Exit;
  end;
  if FPreOpacity <> FPostOpacity then
  begin
    AnnotationChanged := True;
    Exit;
  end;
  if FPreMeasStartLineLength <> FPostMeasStartLineLength then
  begin
    AnnotationChanged := True;
    Exit;
  end;
  if FPreMeasEndLineLength <> FPostMeasEndLineLength then
  begin
    AnnotationChanged := True;
    Exit;
  end;
end;

procedure TfrmMagAnnotationMarkProperty.FormCreate(Sender: TObject);
begin
//  FontList.Items.Assign(Screen.Fonts);   //p122 dmmn 7/12/11 limited the font choices
  {/p122 dmmn 8/26 - preset value for the prestates /}
  FPreFontName := '';
  FPreFontStyle := -1;
  FPreFontSize := -1;
  FPreText := '';
  FPreAlign := -1;
  FPreBoundWrap := -1;
  FPreWidth := -1;
  FPreClosed := false;
  FPreArrowStyle := -1;
  FPreArrowLength := -1;
  FPreArrowAngle := -1;
  FPreColor := clNone;
  FPreFill := false;
  FPreOpacity := -1;
  FPreMeasStartLineLength := -1;
  FPreMeasEndLineLength := -1;
  //post states will be compared later
  FPostFontName := '';
  FPostFontStyle := -1;
  FPostFontSize := -1;
  FPostText := '';
  FPostAlign := -1;
  FPostBoundWrap := -1;
  FPostWidth := -1;
  FPostClosed := false;
  FPostArrowStyle := -1;
  FPostArrowLength := -1;
  FPostArrowAngle := -1;
  FPostColor := clNone;
  FPostFill := false;
  FPostOpacity := -1;
  FPostMeasStartLineLength := -1;
  FPostMeasEndLineLength := -1;

  FChanged := False;
end;

procedure TfrmMagAnnotationMarkProperty.FormShow(Sender: TObject);
begin
  case CurrentMark.type_ of
    IG_ARTX_MARK_LINE  :
      ConfigureLine;
    IG_ARTX_MARK_RECTANGLE :
      ConfigureRect;
    IG_ARTX_MARK_ELLIPSE :
      ConfigureEllipse;
    IG_ARTX_MARK_FREEHAND_LINE:
      ConfigureFreehand;
    IG_ARTX_MARK_TEXT:
      ConfigureText;
    IG_ARTX_MARK_POLYLINE:
      ConfigurePolyline;
    IG_ARTX_MARK_RULER:
      ConfigureRuler;
    IG_ARTX_MARK_PROTRACTOR:
      ConfigureProtractor;
  end;
end;

{$REGION 'Configuring Property Box'}
procedure TfrmMagAnnotationMarkProperty.ConfigureEllipse;
begin
  Caption := 'Ellipse Property Editor';    //p122 dmmn 7/18

  PageControl1.ActivePage := pageShape;
  PageControl1.Pages[0].TabVisible := False;      // font tab
  PageControl1.Pages[1].TabVisible := False;      // text tab
  PageControl1.Pages[2].TabVisible := True;       // shape tab
  PageControl1.Pages[3].TabVisible := True;       // color tab
  PageControl1.Pages[4].TabVisible := False;      // measure tab

  // Shape Tab
  ShapeClosed.Visible := False;
  ShapeArrowPanel.Visible := False;

  // Color Tab
  NoFillColor.Visible := True;

  InitEllipseProps;

end;

procedure TfrmMagAnnotationMarkProperty.ConfigureFreehand;
begin
  Caption := 'Freehand Property Editor';     //p122 dmmn 7/18

  PageControl1.ActivePage := pageShape;
  PageControl1.Pages[0].TabVisible := False;      // font tab
  PageControl1.Pages[1].TabVisible := False;      // text tab
  PageControl1.Pages[2].TabVisible := True;       // shape tab
  PageControl1.Pages[3].TabVisible := True;       // color tab
  PageControl1.Pages[4].TabVisible := False;      // measure tab

  // Shape Tab
  ShapeClosed.Visible := True;
  ShapeArrowPanel.Visible := False;

  // Color Tab
  NoFillColor.Visible := False;

  InitFreehandProps;
end;

procedure TfrmMagAnnotationMarkProperty.ConfigureLine;
begin
  Caption := 'Line/Arrow Property Editor';       //p122 dmmn 7/18

  PageControl1.ActivePage := pageShape;
  PageControl1.Pages[0].TabVisible := False;      // font tab
  PageControl1.Pages[1].TabVisible := False;      // text tab
  PageControl1.Pages[2].TabVisible := True;       // shape tab
  PageControl1.Pages[3].TabVisible := True;       // color tab
  PageControl1.Pages[4].TabVisible := False;      // measure tab

  // Shape Tab
  ShapeClosed.Visible := False;

  // Color Tab
  NoFillColor.Visible := False;
  
  InitLineProps;
end;

procedure TfrmMagAnnotationMarkProperty.ConfigurePolyline;
begin
  Caption := 'Freehand Property Editor';

  PageControl1.ActivePage := pageShape;
  PageControl1.Pages[0].TabVisible := False;      // font tab
  PageControl1.Pages[1].TabVisible := False;      // text tab
  PageControl1.Pages[2].TabVisible := True;       // shape tab
  PageControl1.Pages[3].TabVisible := True;       // color tab
  PageControl1.Pages[4].TabVisible := False;      // measure tab

  // Shape Tab
  ShapeClosed.Visible := True;   //p122 7/12/11
  ShapeArrowPanel.Visible := False;

  // Color Tab
  NoFillColor.Visible := False;
  
  InitPolylineProps;
end;

procedure TfrmMagAnnotationMarkProperty.ConfigureProtractor;
begin
  Caption := 'Protractor Property Editor';        //p122 dmmn 7/18

  PageControl1.ActivePage := pageFont;       // show first
  PageControl1.Pages[0].TabVisible := True;      // font tab
  PageControl1.Pages[1].TabVisible := False;      // text tab
  PageControl1.Pages[2].TabVisible := True;       // shape tab
  PageControl1.Pages[3].TabVisible := True;       // color tab
  PageControl1.Pages[4].TabVisible := False;      // measure tab

  // Shape Tab
  ShapeClosed.Visible := False;
  ShapeArrowPanel.Visible := False;

  // Color Tab
  NoFillColor.Visible := False;
  
  // Measure Tab
  editStartLineLength.Visible := False;
  RulerStartLengthUpDown.Visible := False;
  editEndLineLength.Visible := False;
  RulerEndLengthUpDown.Visible := False;

  InitProtractorProps;
end;

procedure TfrmMagAnnotationMarkProperty.ConfigureRect;
begin
  Caption := 'Rectangle/Highlighter Property Editor';        //p122 dmmn 7/18

  PageControl1.ActivePage := pageShape;
  PageControl1.Pages[0].TabVisible := False;      // font tab
  PageControl1.Pages[1].TabVisible := False;      // text tab
  PageControl1.Pages[2].TabVisible := True;       // shape tab
  PageControl1.Pages[3].TabVisible := True;       // color tab
  PageControl1.Pages[4].TabVisible := False;      // measure tab

  // Shape Tab
  ShapeClosed.Visible := False;
  ShapeArrowPanel.Visible := False;

  // Color Tab
  NoFillColor.Visible := True;

  InitRectProps;
end;

procedure TfrmMagAnnotationMarkProperty.ConfigureRuler;
begin
  Caption := 'Ruler Property Editor';         //p122 dmmn 7/18

  PageControl1.ActivePage := pageFont;
  PageControl1.Pages[0].TabVisible := True;      // font tab
  PageControl1.Pages[1].TabVisible := False;      // text tab
  PageControl1.Pages[2].TabVisible := True;       // shape tab
  PageControl1.Pages[3].TabVisible := True;       // color tab
  PageControl1.Pages[4].TabVisible := True;      // measure tab

  // Shape Tab
  ShapeClosed.Visible := False;
  ShapeArrowPanel.Visible := False;

  // Color Tab
  NoFillColor.Visible := False;

  InitRulerProps;
end;

procedure TfrmMagAnnotationMarkProperty.ConfigureText;
begin
  Caption := 'Text Property Editor';       //p122 dmmn 7/18

  PageControl1.ActivePage := pageFont;
  PageControl1.Pages[0].TabVisible := True;         // font tab
  PageControl1.Pages[1].TabVisible := True;         // text tab
  PageControl1.Pages[2].TabVisible := False;        // shape tab
  PageControl1.Pages[3].TabVisible := True;         // color tab
  PageControl1.Pages[4].TabVisible := False;        // measure tab

  // Color Tab
  OpacityPanel.Visible := True;
  NoFillColor.Visible := False;
  
  InitTextProps;
end;

{$ENDREGION}

{$REGION 'Initilize the Property Box'}

procedure TfrmMagAnnotationMarkProperty.InitEllipseProps;
var
  IGBorder : IGArtXBorder;
  r,g,b : byte;
begin
  IGBorder := (CurrentMark as IIGArtXEllipse).GetBorder;

  ShapeWidth.Text := IntToStr(IGBorder.Width);    // width
  ShapeWidthUpDown.Position := IGBorder.Width;
  FPreWidth := IGBorder.Width;
  FPostWidth := FPreWidth;

  R := IGBorder.GetColor.RGB_R;                   // color
  G := IGBorder.GetColor.RGB_G;
  B := IGBorder.GetColor.RGB_B;
  AnnotLineColor := ConvertRGBToColor(R,G,B);
  SetAnnotLineColor(AnnotLineColor);
  FPreColor := AnnotLineColor;
  FPostColor := FPreColor;

  if (currentMark as IIGArtXEllipse).GetFillColor = nil then  // filed shape
    NoFillColor.Checked := True
  else
    NoFillColor.Checked := False;
  FPreFill := NoFillColor.Checked;
  FPostFill := FPreFill;

//  Opacity.SetTick((CurrentMark as IIGArtXEllipse).Opacity); // opacity
  Opacity.Position := (CurrentMark as IIGArtXEllipse).Opacity;
  FPreOpacity := Opacity.Position;
  FPostOpacity := FPreOpacity;
end;

procedure TfrmMagAnnotationMarkProperty.InitFreehandProps;
var
  IGBorder: IGArtXBorder;
  r,g,b : byte;
begin
  IGBorder := (CurrentMark as IIGArtXFreeline).GetBorder;

  ShapeWidth.Text := IntToStr(IGBorder.Width);    // width
  ShapeWidthUpDown.Position := IGBorder.Width;
  FPreWidth := IGBorder.Width;
  FPostWidth := FPreWidth;

  ShapeClosed.Checked := (CurrentMark as IIGArtXFreeline).IsClosed; // closed     //p122 7/12/11
  FPreClosed := ShapeClosed.Checked;
  FPostClosed := FPreClosed;

  R := IGBorder.GetColor.RGB_R;                   // color
  G := IGBorder.GetColor.RGB_G;
  B := IGBorder.GetColor.RGB_B;
  AnnotLineColor := ConvertRGBToColor(R,G,B);
  SetAnnotLineColor(AnnotLineColor);
  FPreColor := AnnotLineColor;
  FPostColor := FPreColor;

  if (CurrentMark as IIGArtXFreeline).Highlight then    // opacity
//      Opacity.SetTick(Opacity.Min)
    Opacity.Position := Opacity.Min    //p122 7/12/11 correct way to set the tick
  else
//    Opacity.SetTick(Opacity.Max);
    Opacity.Position := Opacity.Max;
  FPreOpacity := Opacity.Position;
  FPostOpacity := FPreOpacity;
end;

procedure TfrmMagAnnotationMarkProperty.InitLineProps;
var
  IGBorder: IGArtXBorder;
  r,g,b : byte;
begin
  IGBorder := (CurrentMark as IIGArtXLine).GetBorder;

  ShapeWidth.Text := IntToStr(IGBorder.Width);    // width
  ShapeWidthUpDown.Position := IGBorder.Width;
  FPreWidth := IGBorder.Width;
  FPostWidth := FPreWidth;

  // Arrow Start Head
  ShapeStartArrowStyle.ItemIndex := (CurrentMark as IIGArtXLine).GetStartHead.Style;
  if ShapeStartArrowStyle.ItemIndex = 4 then  // no head
  begin
    ShapeStartArrowLength.Enabled := False;
    ShapeStartArrowAngle.Enabled := False;
    ShapeStartArrowLengthUpDown.Enabled := False;
    ShapeStartArrowLengthUpDown.Enabled := False;
  end
  else
  begin
    ShapeStartArrowLength.Text := IntToStr(ShapeStartArrowLengthUpDown.Position);
    ShapeStartArrowAngle.Text := IntToStr(ShapeStartArrowAngleUpDown.Position);
    ShapeStartArrowLengthUpDown.Position := (CurrentMark as IIGArtXLine).GetStartHead.Length;
    ShapeStartArrowAngleUpDown.Position := (CurrentMark as IIGArtXLine).GetStartHead.Angle;
    ShapeStartArrowLength.Enabled := True;
    ShapeStartArrowAngle.Enabled := True;
    ShapeStartArrowLengthUpDown.Enabled := true;
    ShapeStartArrowLengthUpDown.Enabled := true;
  end;

  // Arrow End Head
  ShapeEndArrowStyle.ItemIndex := (CurrentMark as IIGArtXLine).GetEndHead.Style;
  FPreArrowStyle := ShapeEndArrowStyle.ItemIndex;
  FPostArrowStyle := FPreArrowStyle;

  if ShapeEndArrowStyle.ItemIndex = 4 then  // no head
  begin
    ShapeEndArrowLength.Enabled := False;
    ShapeEndArrowAngle.Enabled := False;
    ShapeEndArrowLengthUpDown.Enabled := False;
    ShapeEndArrowLengthUpDown.Enabled := False;
  end
  else
  begin
    ShapeEndArrowLength.Text := IntToStr(ShapeEndArrowLengthUpDown.Position);
    ShapeEndArrowAngle.Text := IntToStr(ShapeEndArrowAngleUpDown.Position);
    ShapeEndArrowLengthUpDown.Position := (CurrentMark as IIGArtXLine).GetEndHead.Length;
    ShapeEndArrowAngleUpDown.Position := (CurrentMark as IIGArtXLine).GetEndHead.Angle;
    ShapeEndArrowLength.Enabled := True;
    ShapeEndArrowAngle.Enabled := True;
    ShapeEndArrowLengthUpDown.Enabled := true;
    ShapeEndArrowLengthUpDown.Enabled := true;

    FPreArrowLength := ShapeEndArrowLengthUpDown.Position;
    FPostArrowLength := FPreArrowLength;
    FPreArrowAngle := ShapeEndArrowAngleUpDown.Position;
    FPostArrowAngle := FPreArrowAngle;
  end;

  R := IGBorder.GetColor.RGB_R;                   // color
  G := IGBorder.GetColor.RGB_G;
  B := IGBorder.GetColor.RGB_B;
  AnnotLineColor := ConvertRGBToColor(R,G,B);
  SetAnnotLineColor(AnnotLineColor);
  FPreColor := AnnotLineColor;
  FPostColor := FPreColor;

//  Opacity.SetTick((CurrentMark as IIGArtXLine).Opacity);   // opacity
  Opacity.Position := (CurrentMark as IIGArtXLine).Opacity;  //p122 7/12/11
  FPreOpacity := Opacity.Position;
  FPostOpacity := FPreOpacity;
end;

procedure TfrmMagAnnotationMarkProperty.InitPolylineProps;
var
  IGBorder: IGArtXBorder;
  r,g,b : byte;
begin
  //p122 dmmn 7/12/11 - init polyline as freeline
  IGBorder := (CurrentMark as IIGArtXPolyline).GetBorder;

  ShapeWidth.Text := IntToStr(IGBorder.Width);    // width
  ShapeWidthUpDown.Position := IGBorder.Width;
  FPreWidth := IGBorder.Width;
  FPostWidth := FPreWidth;

  ShapeClosed.Checked := (CurrentMark as IIGArtXPolyline).IsClosed; // closed     //p122 7/12/11
  FPreClosed := ShapeClosed.Checked;
  FPostClosed := FPreClosed;

  R := IGBorder.GetColor.RGB_R;                   // color
  G := IGBorder.GetColor.RGB_G;
  B := IGBorder.GetColor.RGB_B;
  AnnotLineColor := ConvertRGBToColor(R,G,B);
  SetAnnotLineColor(AnnotLineColor);
  FPreColor := AnnotLineColor;
  FPostColor := FPreColor;

  if (CurrentMark as IIGArtXPolyline).Opacity <= 159 then    // opacity
//      Opacity.SetTick(Opacity.Min)
    Opacity.Position := Opacity.Min    //p122 force polyline opacity to binary choice
  else
//    Opacity.SetTick(Opacity.Max);
    Opacity.Position := Opacity.Max;
  FPreOpacity := Opacity.Position;
  FPostOpacity := FPreOpacity;
end;

procedure TfrmMagAnnotationMarkProperty.InitProtractorProps;
var
  r,g,b : byte;
  IGFont : IIGArtXFont;
  fontInd: integer;
  fontSizeInd : integer;
  IGBorder : IIGArtXBorder;
begin
  // fonts
  IGFont := (CurrentMark as IIGArtXProtractor).GetFont;
  fontInd := FontList.Items.IndexOf(IGFont.Name);
  FontList.Selected[fontInd] := True;
  FontList.TopIndex := fontInd;
  FPreFontName := IGFont.Name;
  FPostFontName := FPreFontName;

  fontSizeInd := FontSizes.Items.IndexOf(FloatToStr(IGFont.Size));
  FontSizes.Selected[fontSizeInd] := True;
  fontSizes.TopIndex := fontSizeInd;
  FPreFontSize := IGFont.Size;
  FPostFontSize := FPreFontSize;

  FPreFontStyle := IGFont.Style;
  FPostFontStyle := FPreFontStyle;

  //p122 dmmn 7/27/11 - check for resulted text
  if IGFont.Style > 3 then
  begin
    FResultedText := True;
    IGFont.Style := IGFont.Style - IG_ARTX_FONT_UNDERLINE;
  end;
  FontStyles.Selected[IGFont.Style] := True;

  FontSample.Font.Name := IGFont.Name;        // show sample
  FontSample.Font.Size := Round(IGFont.Size);
  if FontStyles.ItemIndex = 0 then
    FontSample.Font.Style := []
  else if FontStyles.ItemIndex = 1 then
    FontSample.Font.Style := [fsBold]
  else if FontStyles.ItemIndex = 2 then
    FontSample.Font.Style := [fsItalic]
  else if FontStyles.ItemIndex = 3 then
    FontSample.Font.Style := [fsBold,fsItalic];

  // line width
  IGBorder := (CurrentMark as IIGArtXProtractor).GetBorder;
  ShapeWidth.Text := IntToStr(IGBorder.Width);
  ShapeWidthUpDown.Position := IGBorder.Width;
  FPreWidth := IGBorder.Width;
  FPostWidth := FPreWidth;

  // color
  r := IGBorder.GetColor.RGB_R;
  g := IGBorder.GetColor.RGB_G;
  b := IGBorder.GetColor.RGB_B;
  AnnotLineColor := ConvertRGBToColor(R,G,B);
  SetAnnotLineColor(AnnotLineColor);
  FPreColor := AnnotLineColor;
  FPostColor := FPreColor;

  // opacity
  Opacity.Position := (CurrentMark as IIGArtXProtractor).Opacity;
  FPreOpacity := Opacity.Position;
  FPostOpacity := FPreOpacity;

  // measurement
  PrecisionUpDown.Position := (CurrentMark as IIGArtXProtractor).Precision;
  editPrecision.Text := IntToStr(PrecisionUpDown.Position);
end;

procedure TfrmMagAnnotationMarkProperty.InitRectProps;
var
  IGBorder : IIGArtXBorder;
  r,g,b : byte;
begin
  IGBorder := (CurrentMark as IIGArtXRectangle).GetBorder;

  ShapeWidth.Text := IntToStr(IGBorder.Width);    // width
  ShapeWidthUpDown.Position := IGBorder.Width;
  FPreWidth := IGBorder.Width;
  FPostWidth := FPreWidth;

  R := IGBorder.GetColor.RGB_R;                   // color
  G := IGBorder.GetColor.RGB_G;
  B := IGBorder.GetColor.RGB_B;
  AnnotLineColor := ConvertRGBToColor(R,G,B);
  SetAnnotLineColor(AnnotLineColor);
  FPreColor := AnnotLineColor;
  FPostColor := FPreColor;

  if (currentMark as IIGArtXRectangle).GetFillColor = nil then  // filed shape
    NoFillColor.Checked := True
  else
    NoFillColor.Checked := False;
  FPreFill := NoFillColor.Checked;
  FPostFill := FPreFill;

//  Opacity.SetTick((CurrentMark as IIGArtXrectangle).Opacity); // opacity
  Opacity.Position := (CurrentMark as IIGArtXrectangle).Opacity;
  FPreOpacity := Opacity.Position;
  FPostOpacity := FPreOpacity;
end;

procedure TfrmMagAnnotationMarkProperty.InitRulerProps;
var
  r,g,b : byte;
  IGFont : IIGArtXFont;
  fontInd: integer;
  fontSizeInd : integer;
  IGBorder : IIGArtXBorder;
begin
  // fonts
  IGFont := (CurrentMark as IIGArtXRuler).GetFont;
  fontInd := FontList.Items.IndexOf(IGFont.Name);
  if fontInd < 0 then     //p122 7/13 - in case the font in not in the list
    fontInd := 0;
  FontList.Selected[fontInd] := True;
  FontList.TopIndex := fontInd;
  FPreFontName := IGFont.Name;
  FPostFontName := FPreFontName;

  fontSizeInd := FontSizes.Items.IndexOf(FloatToStr(IGFont.Size));
  if fontsizeInd < 0 then          //p122 7/13
    fontsizeInd := 0;
  FontSizes.Selected[fontSizeInd] := True;
  fontSizes.TopIndex := fontSizeInd;
  FPreFontSize := IGFont.Size;
  FPostFontSize := FPreFontSize;

  //p122 dmmn 7/27/11 - check for resulted text
  FPreFontStyle := IGFont.Style;
  FPostFontStyle := FPreFontStyle;
  if IGFont.Style > 3 then
  begin
    FResultedText := True;
    IGFont.Style := IGFont.Style - IG_ARTX_FONT_UNDERLINE;
  end;

  FontStyles.Selected[IGFont.Style] := True;

  FontSample.Font.Name := IGFont.Name;        // show sample
  FontSample.Font.Size := Round(IGFont.Size);
  if FontStyles.ItemIndex = 0 then
    FontSample.Font.Style := []
  else if FontStyles.ItemIndex = 1 then
    FontSample.Font.Style := [fsBold]
  else if FontStyles.ItemIndex = 2 then
    FontSample.Font.Style := [fsItalic]
  else if FontStyles.ItemIndex = 3 then
    FontSample.Font.Style := [fsBold,fsItalic];

  // line width
  IGBorder := (CurrentMark as IIGArtXRuler).GetBorder;
  ShapeWidth.Text := IntToStr(IGBorder.Width);
  ShapeWidthUpDown.Position := IGBorder.Width;
  FPreWidth := IGBorder.Width;
  FPostWidth := FPreWidth;

  // color
  r := IGBorder.GetColor.RGB_R;
  g := IGBorder.GetColor.RGB_G;
  b := IGBorder.GetColor.RGB_B;
  AnnotLineColor := ConvertRGBToColor(R,G,B);
  SetAnnotLineColor(AnnotLineColor);
  FPreColor := AnnotLineColor;
  FPostColor := FPreColor;

  // opacity
  Opacity.Position := (CurrentMark as IIGArtXRuler).Opacity;
  FPreOpacity := Opacity.Position;
  FPostOpacity := FPreOpacity;

  // measurement
  PrecisionUpDown.Position := (CurrentMark as IIGArtXRuler).Precision;
  editPrecision.Text := IntToStr(PrecisionUpDown.Position);
  RulerStartLengthUpDown.Position := (CurrentMark as IIGArtXRuler).StartlineLength;
  RulerEndLengthUpDown.Position := (CurrentMark as IIGArtXRuler).EndlineLength;
  editStartLineLength.Text := IntToStr(RulerStartLengthUpDown.Position);
  editEndLineLength.Text := IntToStr(RulerEndLengthUpDown.Position);

  FPreMeasStartLineLength := RulerStartLengthUpDown.Position;
  FPreMeasEndLineLength := RulerEndLengthUpDown.Position;
  FPostMeasStartLineLength := FPreMeasStartLineLength;
  FPostMeasEndLineLength := FPreMeasEndLineLength;
end;

procedure TfrmMagAnnotationMarkProperty.InitTextProps;
var
  r,g,b : byte;
  IGFont : IIGArtXFont;
  fontInd : integer;
  fontSizeInd : integer;
begin
  // fonts
  IGFont := (CurrentMark as IIGArtXText).GetFont;
  fontInd := FontList.Items.IndexOf(IGFont.Name);
  FontList.Selected[fontInd] := True;
  FontList.TopIndex := fontInd;
  fontSizeInd := FontSizes.Items.IndexOf(FloatToStr(IGFont.Size));
  FontSizes.Selected[fontSizeInd] := True;
  fontSizes.TopIndex := fontSizeInd;

  FPreFontName := IGFont.Name;
  FPreFontSize := IGFont.Size;
  FPreFontStyle := IGFont.Style;
  FPostFontName := FPreFontName;
  FPostFontSize := FPreFontSize;
  FPostFontStyle := FPreFontStyle;

  //p122 dmmn 7/27/11 - check for resulted text
  if IGFont.Style > 3 then
  begin
    FResultedText := True;
    IGFont.Style := IGFont.Style - IG_ARTX_FONT_UNDERLINE;
  end;

  FontStyles.Selected[IGFont.Style] := True;
  FontSample.Font.Name := IGFont.Name;
  FontSample.Font.Size := Round(IGFont.Size);

  if FontStyles.ItemIndex = 0 then
    FontSample.Font.Style := []
  else if FontStyles.ItemIndex = 1 then
    FontSample.Font.Style := [fsBold]
  else if FontStyles.ItemIndex = 2 then
    FontSample.Font.Style := [fsItalic]
  else if FontStyles.ItemIndex = 3 then
    FontSample.Font.Style := [fsBold,fsItalic];

  // text
  TextWordWrap.Checked := Memo1.WordWrap;
  Memo1.Clear;
  Memo1.Text := (CurrentMark as IIGArtXText).Text;
  FPreText := Memo1.Text;
  FPostText := FPreText;

  // color
  r := (CurrentMark as IIGArtXText).GetTextColor.RGB_R;
  g := (CurrentMark as IIGArtXText).GetTextColor.RGB_G;
  b := (CurrentMark as IIGArtXText).GetTextColor.RGB_B;
  AnnotLineColor := ConvertRGBToColor(R,G,B);
  SetAnnotLineColor(AnnotLineColor);
  FPreColor := AnnotLineColor;
  FPostColor := FPreColor;

//  Opacity.SetTick((CurrentMark as IIGArtXText).Opacity);
  Opacity.Position := (CurrentMark as IIGArtXText).Opacity;
  FPreOpacity := Opacity.Position;
  FPostOpacity := FPreOpacity;

  case (CurrentMark as IIGArtXText).TextAlignment of
  0:
    TextAlignment.ItemIndex := 0;
  1:
    TextAlignment.ItemIndex := 3;
  2:
    TextAlignment.ItemIndex := 6;
  16:
    TextAlignment.ItemIndex := 1;
  17:
    TextAlignment.ItemIndex := 4;
  18:
    TextAlignment.ItemIndex := 7;
  32:
    TextAlignment.ItemIndex := 2;
  33:
    TextAlignment.ItemIndex := 5;
  34:
    TextAlignment.ItemIndex := 8;
  end;
  FPreAlign := (CurrentMark as IIGArtXText).TextAlignment;
  FPostAlign := FPreAlign;

  TextBoundsWrap.ItemIndex := (CurrentMark as IIGArtXText).BoundsWrap;
  FPreBoundWrap := (CurrentMark as IIGArtXText).BoundsWrap;
  FPostBoundWrap := FPreBoundWrap;
end;

{$ENDREGION}

{$REGION 'Changing Mark Properties'}
procedure TfrmMagAnnotationMarkProperty.FontListClick(Sender: TObject);
var
  IGFont : IIGArtXFont;
  fontName : string;
begin
  fontName := FontList.Items[FontList.ItemIndex];
  FontSample.Font.Name := fontName;
  FPostFontName := FontName;

  case CurrentMark.type_ of
    IG_ARTX_MARK_TEXT:
    begin
      IGFont := (CurrentMark as IIGArtXText).GetFont;
      IGFont.Name := fontName;
      (CurrentMark as IIGArtXText).SetFont(IGFont);
    end;
    IG_ARTX_MARK_RULER:
    begin
      IGFont := (CurrentMark as IIGArtXRuler).GetFont;
      IGFont.Name := fontName;
      (CurrentMark as IIGArtXRuler).SetFont(IGFont);
    end;
    IG_ARTX_MARK_PROTRACTOR:
    begin
      IGFont := (CurrentMark as IIGArtXProtractor).GetFont;
      IGFont.Name := fontName;
      (CurrentMark as IIGArtXProtractor).SetFont(IGFont);
    end;
  end;
  IGPageViewCtl.UpdateView;
end;

procedure TfrmMagAnnotationMarkProperty.ShapeWidthUpDownClick(Sender: TObject;Button: TUDBtnType);
var
  IGBorder : IIGArtXBorder;
begin
  FPostWidth := ShapeWidthUpDown.Position;

  case CurrentMark.type_ of
    IG_ARTX_MARK_LINE  :
    begin
      IGBorder := (CurrentMark as IIGArtXLine).GetBorder;
      IGBorder.Width := ShapeWidthUpDown.Position;
      (CurrentMark as IIGArtXLine).SetBorder(IGBorder);
    end;
    IG_ARTX_MARK_ELLIPSE :
    begin
      IGBorder := (CurrentMark as IIGArtXEllipse).GetBorder;
      IGBorder.Width := ShapeWidthUpDown.Position;
      (CurrentMark as IIGArtXEllipse).SetBorder(IGBorder);
    end;
    IG_ARTX_MARK_RECTANGLE :
    begin
      IGBorder := (CurrentMark as IIGArtXRectangle).GetBorder;
      IGBorder.Width := ShapeWidthUpDown.Position;
      (CurrentMark as IIGArtXRectangle).SetBorder(IGBorder);
    end;
    IG_ARTX_MARK_FREEHAND_LINE:
    begin
      IGBorder := (CurrentMark as IIGArtXFreeline).GetBorder;
      IGBorder.Width := ShapeWidthUpDown.Position;
      (CurrentMark as IIGArtXFreeline).SetBorder(IGBorder);
    end;
    IG_ARTX_MARK_POLYLINE:
    begin
      IGBorder := (CurrentMark as IIGArtXPolyLine).GetBorder;
      IGBorder.Width := ShapeWidthUpDown.Position;
      (CurrentMark as IIGArtXPolyline).SetBorder(IGBorder);
    end;
    IG_ARTX_MARK_RULER:
    begin
      IGBorder := (CurrentMark as IIGArtXRuler).GetBorder;
      IGBorder.Width := ShapeWidthUpDown.Position;
      (CurrentMark as IIGArtXRuler).SetBorder(IGBorder);
      {/p122 dmmn 8/17 - adjust the end line lengths to width /}
      (CurrentMark as IIGArtXRuler).StartlineLength := IGBorder.Width*4;
      (CurrentMark as IIGArtXRuler).EndlineLength := IGBorder.Width*4;
      RulerStartLengthUpDown.Position := IGBorder.Width*4;
      RulerEndLengthUpDown.Position := IGBorder.Width*4;
    end;
    IG_ARTX_MARK_PROTRACTOR:
    begin
      IGBorder := (CurrentMark as IIGArtXProtractor).GetBorder;
      IGBorder.Width := ShapeWidthUpDown.Position;
      (CurrentMark as IIGArtXProtractor).SetBorder(IGBorder);
    end;
  end;

  IGPageViewCtl.UpdateView;
end;

//procedure TfrmMagAnnotationMarkProperty.ShowMultipleSeletectWarning(
//  const Value: boolean);
//begin
//  {/p122 dmmn 7/14/11 - warning on user selected multiple marks /}
//  Panel3.Visible := Value;
//end;

procedure TfrmMagAnnotationMarkProperty.TextAlignmentChange(Sender: TObject);
begin
  case TextAlignment.ItemIndex of
  0:
    (CurrentMark as IIGArtXText).TextAlignment := 0;
  3:
    (CurrentMark as IIGArtXText).TextAlignment := 1;
  6:
    (CurrentMark as IIGArtXText).TextAlignment := 2;
  1:
    (CurrentMark as IIGArtXText).TextAlignment := 16;
  4:
    (CurrentMark as IIGArtXText).TextAlignment := 17;
  7:
    (CurrentMark as IIGArtXText).TextAlignment := 18;
  2:
    (CurrentMark as IIGArtXText).TextAlignment := 32;
  5:
    (CurrentMark as IIGArtXText).TextAlignment := 33;
  8:
    (CurrentMark as IIGArtXText).TextAlignment := 34;
  end;
  FPostAlign := (CurrentMark as IIGArtXText).TextAlignment;

  IGPageViewCtl.UpdateView;
end;

procedure TfrmMagAnnotationMarkProperty.TextBoundsWrapChange(Sender: TObject);
begin
  case TextBoundsWrap.ItemIndex of
  0:
    (CurrentMark as IIGArtXText).BoundsWrap := 0;
  1:
    (CurrentMark as IIGArtXText).BoundsWrap := 1;
  2:
    (CurrentMark as IIGArtXText).BoundsWrap := 2;
  3:
    (CurrentMark as IIGArtXText).BoundsWrap := 3;
  end;
  FPostBoundWrap := (CurrentMark as IIGArtXText).BoundsWrap;
  
  IGPageViewCtl.UpdateView;
end;

procedure TfrmMagAnnotationMarkProperty.TextWordWrapClick(Sender: TObject);
begin
  Memo1.WordWrap := TextWordWrap.Checked;
  if Memo1.WordWrap then      //p122t6 dmmn add scrollbars if not wrap
    Memo1.ScrollBars := ssNone
  else
    Memo1.ScrollBars := ssBoth;
end;

procedure TfrmMagAnnotationMarkProperty.ShapeEndArrowAngleUpDownClick(Sender: TObject; Button: TUDBtnType);
var
  IGArrowHead : IIGArtXArrowHead;
begin
  IGArrowHead := (CurrentMark as IIGArtXLine).GetEndHead;
  IGArrowHead.Angle := ShapeEndArrowAngleUpDown.Position;
  (CurrentMark as IIGArtXLine).SetEndHead(IGArrowHead);

  FPostArrowAngle := IGArrowHead.Angle;

  IGPageViewCtl.UpdateView;
end;

procedure TfrmMagAnnotationMarkProperty.ShapeEndArrowLengthUpDownClick(Sender: TObject; Button: TUDBtnType);
var
  IGArrowHead : IIGArtXArrowHead;
begin
  IGArrowHead := (CurrentMark as IIGArtXLine).GetEndHead;
  IGArrowHead.Length := ShapeEndArrowLengthUpDown.Position;
  (CurrentMark as IIGArtXLine).SetEndHead(IGArrowHead);

  FPostArrowLength := IGArrowHead.Length;

  IGPageViewCtl.UpdateView;
end;

procedure TfrmMagAnnotationMarkProperty.ShapeEndArrowStyleChange(Sender: TObject);
var
  IGArrowHead : IIGArtXArrowHead;
  IGBorder: IIGArtXBorder;
  IGArrowColor: IGPixel;
  RGB_B: Integer;
  RGB_G: Integer;
  RGB_R: Integer;
begin
  IGArrowHead := (CurrentMark as IIGArtXLine).GetEndHead;
  IGArrowHead.Style := ShapeEndArrowStyle.ItemIndex;
  FPostArrowStyle := IGArrowHead.Style;

  if ShapeEndArrowStyle.ItemIndex = 4 then
  begin
    ShapeEndArrowLength.Enabled := False;
    ShapeEndArrowAngle.Enabled := False;
    ShapeEndArrowLengthUpDown.Enabled := False;
    ShapeEndArrowAngleUpDown.Enabled := False;
  end
  else
  begin
    ShapeEndArrowLength.Enabled := True;
    ShapeEndArrowAngle.Enabled := True;
    ShapeEndArrowLengthUpDown.Enabled := True;
    ShapeEndArrowAngleUpDown.Enabled := True;

    IGArrowHead.Length := ShapeEndArrowLengthUpDown.Position;
    IGArrowHead.Angle := ShapeEndArrowAngleUpDown.Position;

    FPostArrowLength := IGArrowHead.Length;
    FPostArrowAngle := IGArrowHead.Angle;

    IGArrowColor := IGCoreCtl.CreateObject(IG_OBJ_PIXEL) As IIGPixel;
    ConvertColorToRGB(AnnotLineColor, RGB_R, RGB_G, RGB_B);
    IGArrowColor.RGB_R := RGB_R;
    IGArrowColor.RGB_G := RGB_G;
    IGArrowColor.RGB_B := RGB_B;
    (currentMark as IIGArtXLine).SetHeadFillColor(IGArrowColor);
  end;
  (CurrentMark as IIGArtXLine).SetEndHead(IGArrowHead);

  IGPageViewCtl.UpdateView;
end;

procedure TfrmMagAnnotationMarkProperty.ShapeStartArrowAngleUpDownClick(Sender: TObject; Button: TUDBtnType);
var
  IGArrowHead : IIGArtXArrowHead;
begin
  IGArrowHead := (CurrentMark as IIGArtXLine).GetStartHead;
  IGArrowHead.Angle := ShapeStartArrowAngleUpDown.Position;
  (CurrentMark as IIGArtXLine).SetStartHead(IGArrowHead);

  IGPageViewCtl.UpdateView;
end;

procedure TfrmMagAnnotationMarkProperty.ShapeStartArrowLengthUpDownClick(Sender: TObject; Button: TUDBtnType);
var
  IGArrowHead : IIGArtXArrowHead;
begin
  IGArrowHead := (CurrentMark as IIGArtXLine).GetStartHead;
  IGArrowHead.Length := ShapeStartArrowLengthUpDown.Position;
  (CurrentMark as IIGArtXLine).SetStartHead(IGArrowHead);

  IGPageViewCtl.UpdateView;
end;

procedure TfrmMagAnnotationMarkProperty.ShapeStartArrowStyleChange(Sender: TObject);
var
  IGArrowHead : IIGArtXArrowHead;
  IGBorder: IIGArtXBorder;
  IGArrowColor: IGPixel;
  RGB_B: Integer;
  RGB_G: Integer;
  RGB_R: Integer;
begin
  IGArrowHead := (CurrentMark as IIGArtXLine).GetStartHead;
  IGArrowHead.Style := ShapeStartArrowStyle.ItemIndex;
  if ShapeStartArrowStyle.ItemIndex = 4 then
  begin
    ShapeStartArrowLength.Enabled := False;
    ShapeStartArrowAngle.Enabled := False;
    ShapeStartArrowLengthUpDown.Enabled := False;
    ShapeStartArrowAngleUpDown.Enabled := False;
  end
  else
  begin
    ShapeStartArrowLength.Enabled := True;
    ShapeStartArrowAngle.Enabled := True;
    ShapeStartArrowLengthUpDown.Enabled := True;
    ShapeStartArrowAngleUpDown.Enabled := True;

    IGArrowHead.Length := ShapeStartArrowLengthUpDown.Position;
    IGArrowHead.Angle := ShapeStartArrowAngleUpDown.Position;

    IGArrowColor := IGCoreCtl.CreateObject(IG_OBJ_PIXEL) As IIGPixel;
    ConvertColorToRGB(AnnotLineColor, RGB_R, RGB_G, RGB_B);
    IGArrowColor.RGB_R := RGB_R;
    IGArrowColor.RGB_G := RGB_G;
    IGArrowColor.RGB_B := RGB_B;
    (currentMark as IIGArtXLine).SetHeadFillColor(IGArrowColor);
  end;
  (CurrentMark as IIGArtXLine).SetStartHead(IGArrowHead);

  IGPageViewCtl.UpdateView;
end;

procedure TfrmMagAnnotationMarkProperty.ShapeClosedClick(Sender: TObject);
begin
  case CurrentMark.type_ of
    IG_ARTX_MARK_FREEHAND_LINE:
      (CurrentMark as IIGArtXFreeline).IsClosed := ShapeClosed.Checked;
    IG_ARTX_MARK_POLYLINE:
      (CurrentMark as IIGArtXPolyline).IsClosed := ShapeClosed.Checked;
  end;
  FPostClosed := ShapeClosed.Checked;
  
  IGPageViewCtl.UpdateView;
end;

procedure TfrmMagAnnotationMarkProperty.ChangeAnnotLineColor;
var
  IGBorder: IIGArtXBorder;
  IGBorderColor: IGPixel;
  inLineColor: Integer;
  RGB_B: Integer;
  RGB_G: Integer;
  RGB_R: Integer;
begin
  SetAnnotLineColor(AnnotLineColor);
  FPostColor := AnnotLineColor;

  // change color of marks
  IGBorderColor := IGCoreCtl.CreateObject(IG_OBJ_PIXEL) As IIGPixel;
  IGBorderColor.ChangeType(IG_PIXEL_RGB);
  ConvertColorToRGB(AnnotLineColor, RGB_R, RGB_G, RGB_B); //<<<<<<<<<<<
  IGBorderColor.RGB_R := RGB_R;
  IGBorderColor.RGB_G := RGB_G;
  IGBorderColor.RGB_B := RGB_B;

  case CurrentMark.type_ of
    IG_ARTX_MARK_LINE  :
    begin
      IGBorder := (CurrentMark as IIGArtXLine).GetBorder;
      IGBorder.SetColor(IGBorderColor);
      (CurrentMark as IIGArtXLine).SetBorder(IGBorder);
      (CurrentMark as IIGArtXLine).SetHeadFillColor(IGBorderColor);
    end;
    IG_ARTX_MARK_ELLIPSE:
    begin
      IGBorder := (CurrentMark as IIGArtXEllipse).GetBorder;
      IGBorder.SetColor(IGBorderColor);
      (CurrentMark as IIGArtXEllipse).SetBorder(IGBorder);
      if (CurrentMark as IIGArtXEllipse).GetFillColor <> nil then
        (CurrentMark as IIGArtXEllipse).SetFillColor(IGBorderColor);
    end;
    IG_ARTX_MARK_RECTANGLE:
    begin
      IGBorder := (CurrentMark as IIGArtXRectangle).GetBorder;
      IGBorder.SetColor(IGBorderColor);
      (CurrentMark as IIGArtXRectangle).SetBorder(IGBorder);
      if (CurrentMark as IIGArtXRectangle).GetFillColor <> nil then
        (CurrentMark as IIGArtXRectangle).SetFillColor(IGBorderColor);
    end;
    IG_ARTX_MARK_FREEHAND_LINE:
    begin
      IGBorder := (CurrentMark as IIGArtXFreeline).GetBorder;
      IGBorder.SetColor(IGBorderColor);
      (CurrentMark as IIGArtXFreeline).SetBorder(IGBorder);
    end;
    IG_ARTX_MARK_TEXT:
    begin
      (CurrentMark as IIGArtXText).SetTextColor(IGBorderColor);
    end;
    IG_ARTX_MARK_POLYLINE:
    begin
      IGBorder := (CurrentMark as IIGArtXPolyLine).GetBorder;
      IGBorder.SetColor(IGBorderColor);
      (CurrentMark as IIGArtXPolyLine).SetBorder(IGBorder);
    end;
    IG_ARTX_MARK_RULER:
    begin
      IGBorder := (CurrentMark as IIGArtXRuler).GetBorder;
      IGBorder.SetColor(IGBorderColor);
      (CurrentMark as IIGArtXRuler).SetBorder(IGBorder);
    end;
    IG_ARTX_MARK_PROTRACTOR:
    begin
      IGBorder := (CurrentMark as IIGArtXProtractor).GetBorder;
      IGBorder.SetColor(IGBorderColor);
      (CurrentMark as IIGArtXProtractor).SetBorder(IGBorder);
    end;
  end;

  IGPageViewCtl.UpdateView;
end;

procedure TfrmMagAnnotationMarkProperty.NoFillColorClick(Sender: TObject);
var
  IGFillColor: IGPixel;
  RGB_B: Integer;
  RGB_G: Integer;
  RGB_R: Integer;
begin
  FPostFill := NoFillColor.Checked;
  
  case CurrentMark.type_ of
    IG_ARTX_MARK_ELLIPSE :
    begin
      if NoFillColor.Checked then
        (CurrentMark as IIGArtXEllipse).SetFillColor(nil)
      else
      begin
        IGFillColor := IGCoreCtl.CreateObject(IG_OBJ_PIXEL) As IIGPixel;
        ConvertColorToRGB(AnnotLineColor, RGB_R, RGB_G, RGB_B);
        IGFillColor.RGB_R := RGB_R;
        IGFillColor.RGB_G := RGB_G;
        IGFillColor.RGB_B := RGB_B;
        (CurrentMark as IIGArtXEllipse).SetFillColor(IGFillColor);
      end;
    end;
    IG_ARTX_MARK_RECTANGLE :
    begin
      if NoFillColor.Checked then
        (CurrentMark as IIGArtXRectangle).SetFillColor(nil)
      else
      begin
        IGFillColor := IGCoreCtl.CreateObject(IG_OBJ_PIXEL) As IIGPixel;
        ConvertColorToRGB(AnnotLineColor, RGB_R, RGB_G, RGB_B);
        IGFillColor.RGB_R := RGB_R;
        IGFillColor.RGB_G := RGB_G;
        IGFillColor.RGB_B := RGB_B;
        (CurrentMark as IIGArtXRectangle).SetFillColor(IGFillColor);
      end;
    end;  
  end;

  IGPageViewCtl.UpdateView;
end;

procedure TfrmMagAnnotationMarkProperty.OpacityChange(Sender: TObject);
begin
  FPostOpacity := Opacity.Position;
  
  case CurrentMark.type_ of
    IG_ARTX_MARK_LINE  :
    begin
      (CurrentMark as IIGArtXLine).Opacity := Opacity.Position;
    end;
    IG_ARTX_MARK_ELLIPSE:
    begin
      (CurrentMark as IIGArtXEllipse).Opacity := Opacity.Position;
    end;
    IG_ARTX_MARK_RECTANGLE:
    begin
      (CurrentMark as IIGArtXRectangle).Opacity := Opacity.Position;
    end;
    IG_ARTX_MARK_TEXT:
    begin
      (CurrentMark as IIGArtXText).Opacity := Opacity.Position;
    end;
    IG_ARTX_MARK_RULER:
    begin
      (CurrentMark as IIGArtXRuler).Opacity := Opacity.Position;
    end;
    IG_ARTX_MARK_PROTRACTOR:
    begin
      (CurrentMark as IIGArtXProtractor).Opacity := Opacity.Position;
    end;
    IG_ARTX_MARK_POLYLINE:    //p122 7/12/11 - force similar to freehand
    begin
//      (CurrentMark as IIGArtXPolyline).Opacity := Opacity.Position;
      if Opacity.Position <= 159 then   //p122 dmmn 8/15
      begin
        Opacity.Position := Opacity.Min;
        (CurrentMark as IIGArtXPolyline).Opacity := 108;
      end
      else
      begin
        Opacity.Position := Opacity.Max;
        (CurrentMark as IIGArtXPolyline).Opacity := 255;
      end;
    end;
    IG_ARTX_MARK_FREEHAND_LINE:
    begin
      if Opacity.Position <= 159 then    //p122 dmmn 8/15
      begin
        Opacity.Position := Opacity.Min;
        (CurrentMark as IIGArtXFreeline).Set_Highlight(True);
      end
      else
      begin
        Opacity.Position := Opacity.Max;
        (CurrentMark as IIGArtXFreeline).Set_Highlight(False);
      end;
    end;
  end;
  IGPageViewCtl.UpdateView;
end;

procedure TfrmMagAnnotationMarkProperty.RulerEndLengthUpDownClick(Sender: TObject; Button: TUDBtnType);
begin
  (CurrentMark as IIGArtXRuler).EndLineLength := RulerEndLengthUpDown.Position;
  FPostMeasEndLineLength := RulerEndLengthUpDown.Position;

  IGPageViewCtl.UpdateView;
end;

procedure TfrmMagAnnotationMarkProperty.PrecisionUpDownClick(Sender: TObject; Button: TUDBtnType);
begin
  case CurrentMark.type_ of
    IG_ARTX_MARK_RULER:
      (CurrentMark as IIGArtXRuler).Precision := PrecisionUpDown.Position;
    IG_ARTX_MARK_PROTRACTOR:
      (CurrentMark as IIGArtXProtractor).Precision := PrecisionUpDown.Position;
  end;
  IGPageViewCtl.UpdateView;
end;

procedure TfrmMagAnnotationMarkProperty.RulerStartLengthUpDownClick(Sender: TObject; Button: TUDBtnType);
begin
  (CurrentMark as IIGArtXRuler).StartlineLength := RulerStartLengthUpDown.Position;
  FPostMeasStartLineLength := RulerStartLengthUpDown.Position;

  IGPageViewCtl.UpdateView;
end;

{$ENDREGION}

{$REGION 'Utils'}
procedure TfrmMagAnnotationMarkProperty.ConvertColorToRGB(c: TColor; out r, g,b: Integer);
begin
  r := c And $FF;
  g := (c And $FF00) Shr 8;
  b := (c And $FF0000) Shr 16;
end;

function TfrmMagAnnotationMarkProperty.ConvertRGBToColor(R, G, B: Byte): TColor;
begin
  Result := RGB(R,G,B);
end;

procedure TfrmMagAnnotationMarkProperty.btnCloseClick(Sender: TObject);
begin
  Close;
end;

procedure TfrmMagAnnotationMarkProperty.btnFontClick(Sender: TObject);
var
  IGFont : IIGArtXFont;
  IGTextColor : IGPixel;
begin
  case CurrentMark.type_ of
    IG_ARTX_MARK_TEXT:
    begin
      IGFont := (CurrentMark as IIGArtXText).GetFont;
      IGTextColor := (CurrentMark as IIGArtXText).GetTextColor;
    end;
    IG_ARTX_MARK_RULER:
    begin
      IGFont := (CurrentMark as IIGArtXRuler).GetFont;
      IGTextColor := (CurrentMark as IIGArtXRuler).GetBorder.GetColor;
    end;
    IG_ARTX_MARK_PROTRACTOR:
    begin
      IGFont := (CurrentMark as IIGArtXProtractor).GetFont;
      IGTextColor := (CurrentMark as IIGArtXProtractor).GetBorder.GetColor;
    end;
  end;

//  FontDialog.Font.Name := IGFont.Name;
//  FontDialog.Font.Size := Round(IGFont.Size);
//  FontDialog.Font.Color := ConvertRGBToColor(IGTextColor.RGB_R,IGTextColor.RGB_G,IGTextColor.RGB_B);
//  FontDialog.Font.Style := IGFont.Style;
//  If FontDialog.Execute Then
//  Begin
//    IGFont.Name := FontDialog.Font.Name;
//    IGFont.Size := FontDialog.Font.Size;
//    ConvertColorToRGB(FontDialog.Font.Color,IGTextColor.RGB_R,IGTextColor.RGB_G,IGTextColor.RGB_B);
//  End;

  case CurrentMark.type_ of
    IG_ARTX_MARK_TEXT:
    begin
      (CurrentMark as IIGArtXText).SetFont(IGFont);
      (CurrentMark as IIGArtXText).SetTextColor(IGTextColor);
    end;
    IG_ARTX_MARK_RULER:
    begin
      (CurrentMark as IIGArtXRuler).SetFont(IGFont);
    end;
    IG_ARTX_MARK_PROTRACTOR:
    begin
      (CurrentMark as IIGArtXProtractor).SetFont(IGFont);
    end;
  end;

  IGPageViewCtl.UpdateView;
end;

procedure TfrmMagAnnotationMarkProperty.btnLineColor01Click(Sender: TObject);
begin
  AnnotLineColor := clBlack;
  ChangeAnnotLineColor;
end;

procedure TfrmMagAnnotationMarkProperty.btnLineColor02Click(Sender: Tobject);
begin
  AnnotLineColor := clMedGray;
  ChangeAnnotLineColor;
end;

procedure TfrmMagAnnotationMarkProperty.btnLineColor03Click(Sender: Tobject);
begin
  AnnotLineColor := clMaroon;
  ChangeAnnotLineColor;
end;

procedure TfrmMagAnnotationMarkProperty.btnLineColor04Click(Sender: Tobject);
begin
  AnnotLineColor := clOlive;
  ChangeAnnotLineColor;
end;

procedure TfrmMagAnnotationMarkProperty.btnLineColor05Click(Sender: Tobject);
begin
  AnnotLineColor := clGreen;
  ChangeAnnotLineColor;
end;

procedure TfrmMagAnnotationMarkProperty.btnLineColor06Click(Sender: Tobject);
begin
  AnnotLineColor := clTeal;
  ChangeAnnotLineColor;
end;

procedure TfrmMagAnnotationMarkProperty.btnLineColor07Click(Sender: Tobject);
begin
  AnnotLineColor := clNavy;
  ChangeAnnotLineColor;
end;

procedure TfrmMagAnnotationMarkProperty.btnLineColor08Click(Sender: Tobject);
begin
  AnnotLineColor := clPurple;
  ChangeAnnotLineColor;
end;

procedure TfrmMagAnnotationMarkProperty.btnLineColor09Click(Sender: Tobject);
begin
  AnnotLineColor := clWhite;
  ChangeAnnotLineColor;
end;

procedure TfrmMagAnnotationMarkProperty.btnLineColor10Click(Sender: Tobject);
begin
  AnnotLineColor := clSilver;
  ChangeAnnotLineColor;
end;

procedure TfrmMagAnnotationMarkProperty.btnLineColor11Click(Sender: Tobject);
begin
  AnnotLineColor := clRed;
  ChangeAnnotLineColor;
end;

procedure TfrmMagAnnotationMarkProperty.btnLineColor12Click(Sender: Tobject);
begin
  AnnotLineColor := clYellow;
  ChangeAnnotLineColor;
end;

procedure TfrmMagAnnotationMarkProperty.btnLineColor13Click(Sender: Tobject);
begin
  AnnotLineColor := clLime;
  ChangeAnnotLineColor;
end;

procedure TfrmMagAnnotationMarkProperty.btnLineColor14Click(Sender: Tobject);
begin
  AnnotLineColor := clAqua;
  ChangeAnnotLineColor;
end;

procedure TfrmMagAnnotationMarkProperty.btnLineColor15Click(Sender: Tobject);
begin
  AnnotLineColor := clBlue;
  ChangeAnnotLineColor;
end;

procedure TfrmMagAnnotationMarkProperty.btnLineColor16Click(Sender: Tobject);
begin
  AnnotLineColor := clFuchsia;
  ChangeAnnotLineColor;
end;

procedure TfrmMagAnnotationMarkProperty.LineColorButtonsDeSelectAll;
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

procedure TfrmMagAnnotationMarkProperty.LineColorButtonSetByColor(const color: TColor);
begin
  LineColorButtonsDeSelectAll();
  Case color Of
    clBlack:
    begin
      btnLineColor01.Flat := True;
      Label5.Caption := 'Color selected: Black';
    end;
    clMedGray:
    begin
      btnLineColor02.Flat := True;
      Label5.Caption := 'Color selected: Gray';
    end;
    clMaroon:
    begin
      btnLineColor03.Flat := True;
      Label5.Caption := 'Color selected: Maroon';
    end;
    clOlive:
    begin
      btnLineColor04.Flat := True;
      Label5.Caption := 'Color selected: Olive';
    end;
    clGreen:
    begin
      btnLineColor05.Flat := True;
      Label5.Caption := 'Color selected: Green';
    end;
    clTeal:
    begin
      btnLineColor06.Flat := True;
      Label5.Caption := 'Color selected: Teal';
    end;
    clNavy:
    begin
      btnLineColor07.Flat := True;
      Label5.Caption := 'Color selected: Navy';
    end;
    clPurple:
    begin
      btnLineColor08.Flat := True;
      Label5.Caption := 'Color selected: Purple';
    end;
    clWhite:
    begin
      btnLineColor09.Flat := True;
      Label5.Caption := 'Color selected: White';
    end;
    clSilver:
    begin
      btnLineColor10.Flat := True;
      Label5.Caption := 'Color selected: Silver';
    end;
    clRed:
    begin
      btnLineColor11.Flat := True;
      Label5.Caption := 'Color selected: Red';
    end;
    clYellow:
    begin
      btnLineColor12.Flat := True;
      Label5.Caption := 'Color selected: Yellow';
    end;
    cllime:
    begin
      btnLineColor13.Flat := True;
      Label5.Caption := 'Color selected: Lime';
    end;
    clAqua:
    begin
      btnLineColor14.Flat := True;
      Label5.Caption := 'Color selected: Aqua';
    end;
    clBlue:
    begin
      btnLineColor15.Flat := True;
      Label5.Caption := 'Color selected: Blue';
    end;
    clFuchsia:
    begin
      btnLineColor16.Flat := True;
      Label5.Caption := 'Color selected: Fuchsia';
    end;
  Else
  begin
    btnLineColor05.Flat := True;
    Label5.Caption := 'Color selected: Green';
  end;
  End;
end;

procedure TfrmMagAnnotationMarkProperty.FontSizesClick(Sender: TObject);
var
  IGFont : IIGArtXFont;
  fontSize : string;
begin
  fontSize := FontSizes.Items[FontSizes.ItemIndex];
  FPostFontSize := StrToInt(FontSize);

  FontSample.Font.Size := StrToInt(fontSize);
  case CurrentMark.type_ of
    IG_ARTX_MARK_TEXT:
    begin
      IGFont := (CurrentMark as IIGArtXText).GetFont;
      IGFont.Size := StrToInt(fontSize);
      (CurrentMark as IIGArtXText).SetFont(IGFont);
    end;
    IG_ARTX_MARK_RULER:
    begin
      IGFont := (CurrentMark as IIGArtXRuler).GetFont;
      IGFont.Size := StrToInt(fontSize);
      (CurrentMark as IIGArtXRuler).SetFont(IGFont);
    end;
    IG_ARTX_MARK_PROTRACTOR:
    begin
      IGFont := (CurrentMark as IIGArtXProtractor).GetFont;
      IGFont.Size := StrToInt(fontSize);
      (CurrentMark as IIGArtXProtractor).SetFont(IGFont);
    end;
  end;
  IGPageViewCtl.UpdateView;
end;

procedure TfrmMagAnnotationMarkProperty.FontStylesClick(Sender: TObject);
var
  IGFont : IIGArtXFont;
begin
  if FontStyles.ItemIndex = 0 then
    FontSample.Font.Style := []
  else if FontStyles.ItemIndex = 1 then
    FontSample.Font.Style := [fsBold]
  else if FontStyles.ItemIndex = 2 then
    FontSample.Font.Style := [fsItalic]
  else if FontStyles.ItemIndex = 3 then
    FontSample.Font.Style := [fsBold,fsItalic];

  case CurrentMark.type_ of
    IG_ARTX_MARK_TEXT:
    begin
      IGFont := (CurrentMark as IIGArtXText).GetFont;
      IGFont.Style := FontStyles.ItemIndex;
      if FResultedText then            // restore underline setting for resulted text
        IGFont.Style := IGFont.Style + IG_ARTX_FONT_UNDERLINE;

      FPostFontStyle := IGFont.Style;
      (CurrentMark as IIGArtXText).SetFont(IGFont);
    end;
    IG_ARTX_MARK_RULER:
    begin
      IGFont := (CurrentMark as IIGArtXRuler).GetFont;
      IGFont.Style := FontStyles.ItemIndex;
      if FResultedText then            // restore underline setting for resulted text
        IGFont.Style := IGFont.Style + IG_ARTX_FONT_UNDERLINE;

      FPostFontStyle := IGFont.Style;
      (CurrentMark as IIGArtXRuler).SetFont(IGFont);
    end;
    IG_ARTX_MARK_PROTRACTOR:
    begin
      IGFont := (CurrentMark as IIGArtXProtractor).GetFont;
      IGFont.Style := FontStyles.ItemIndex;
      if FResultedText then            // restore underline setting for resulted text
        IGFont.Style := IGFont.Style + IG_ARTX_FONT_UNDERLINE;

      FPostFontStyle := IGFont.Style;
      (CurrentMark as IIGArtXProtractor).SetFont(IGFont);
    end;
  end;
  IGPageViewCtl.UpdateView;
end;

procedure TfrmMagAnnotationMarkProperty.Memo1Change(Sender: TObject);
var
  selstart : integer;
  length : integer;
begin
(*
  //p122t11b dmmn - store the cursor position
  selstart := Memo1.SelStart;
  length := 0;  //length of the replacement

  //p122t11 dmmn - remove illegal character for the xml
  if AnsiPos('<', Memo1.Text) > 0 then
begin
    Memo1.Text := StringReplace(Memo1.Text, '<', 'less than',[rfReplaceAll, rfIgnoreCase]);
    length := 9;
    // move the cursor to end of the change
    Memo1.SelStart := selstart + length-1;
  end;
  if AnsiPos('>', Memo1.Text) > 0 then
  begin
    Memo1.Text := StringReplace(Memo1.Text, '>', 'greater than',[rfReplaceAll, rfIgnoreCase]);
    length := 12;
    // move the cursor to end of the change
    Memo1.SelStart := selstart + length-1;
  end;
  if AnsiPos('&', Memo1.Text) > 0 then
  begin
    Memo1.Text := StringReplace(Memo1.Text, '&', 'and',[rfReplaceAll, rfIgnoreCase]);
    length := 3;
    // move the cursor to end of the change
    Memo1.SelStart := selstart + length-1;
  end;
      *)
  (CurrentMark as IIGArtXText).Text := Memo1.Text;
  FPostText := Memo1.Text;
  
  IGPageViewCtl.UpdateView;
end;

procedure TfrmMagAnnotationMarkProperty.SetAnnotLineColor(const Value: TColor);
begin
  if AnnotLineColor <> Value Then
    AnnotLineColor := Value;
  LineColorButtonSetByColor(AnnotLineColor);
end;
{$ENDREGION}


end.
