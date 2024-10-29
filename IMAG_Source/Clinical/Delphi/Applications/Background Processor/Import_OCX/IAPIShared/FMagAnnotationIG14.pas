{
  Package: MAG - VistA Imaging
  WARNING: Per VHA Directive 2004-038, this routine should not be modified.
  Date Created: September, 2006
  Site Name:  Washington OI Field Office, Silver Spring, MD
  Developer:  Julian Werfel
  Description:
    ImageGear implementation of the Annotation component.

        ;; +--------------------------------------------------------------------+
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
        ;; +--------------------------------------------------------------------+
}
Unit FMagAnnotationIG14;

Interface

Uses
  AxCtrls,
  Classes,
  FmagAnnotation,
  {$IFDEF ARTX}GearARTXLib_TLB,
  {$ELSE}GearARTLib_TLB,
  {$ENDIF}
  GearCORELib_TLB,
  GearDISPLAYLib_TLB,
  Graphics,
  UMagClassesAnnot
  ;

Type
  TMagAnnotationIG14 = Class(TMagAnnotation)
  Private
    ArtPage: {$IFDEF ARTX}IGArtXPage{$ELSE}IGArtPage{$ENDIF};
    Bold: Boolean;
    CurrentAnnotationColor: TColor;
    CurrentArrowLength: TMagAnnotationArrowSize;
    CurrentArrowPointer: TMagAnnotationArrowType;
    CurrentPage: IIGPage;
    CurrentPageDisp: IIGPageDisplay;
    CurrentTool: TMagAnnotationToolType;
    FLastMarkIndex: Integer;
    FontName: String;
    FontSize: Integer;
    FPage: Integer;
    FPageCount: Integer;
    IGArtCtrl: {$IFDEF ARTX}TIGArtXCtl{$ELSE}TIGArtCtl{$ENDIF};
    IgCurPoint: IGPoint;
    IsInitialized: Boolean;
    Italic: Boolean;
    LineWidth: TMagAnnotationLineWidth;
    Opaque: Boolean;
    PageViewHwnd: Integer;
    Function IsValid(): Boolean;
    Procedure SetPage(Value: Integer);
    {$IFDEF ARTX}
    Procedure OnPreCreateNotify(ASender: Tobject; Const Params: IIGArtXPreCreateMarkEventParams);
    {$ELSE}
    Function GetAnnotationStyle(): TMagAnnotationStyle;
    Function GetAnnotationType(annType: TMagAnnotationToolType): EnumIGArtMarkType;
    Function GetCurrentMarkIndex(): Integer;
    Function GetIG14ArrowPointer(aPointer: TMagAnnotationArrowType): EnumIGArtArrowType;
    Function GetMarkElement(MarkIndex: Integer): TMagAnnotationElement;
    Function GetMarkElementType(MarkType: EnumIGArtMarkType): TMagAnnotationElementType;
    Function GetMarkElementTypeIG(MarkType: TMagAnnotationElementType): EnumIGArtMarkType;
    Procedure OnCreateNotify(ASender: Tobject; Const PPage: IIGArtPage; MarkIndex: Integer;MarkType: Integer; Const CreateFlag: IIGArtEventParams);
    Procedure OnPreCreateNotify(ASender: Tobject; Const PPage: IIGArtPage; MarkIndex: Integer; MarkType: Integer; Const CreateFlag: IIGArtEventParams);
    {$ENDIF}
  Public
    Constructor Create(AOwner: TComponent); Override;
    Destructor Destroy(); Override;
    Function GetArtComponentInterface(): IIGComponent;
    Function GetMarkCount(): Integer; Override;
    Procedure Initialize(CurPoint: IIGPoint; CurPage: IIGPage; CurPageDisp: IIGPageDisplay; PageViewHwnd: Integer; ForDiagramAnnotation: Boolean {; aPageViewCtl : TIGPageViewCtl});
    Procedure InitializeVariables(); Override;
    Procedure RemoveOrientationLabel(); Override;
    Procedure SetArrowPointer(aPointer: TMagAnnotationArrowType); Override;
    {$IFNDEF ARTX}
    Function GetAnnotationData(): TStrings; Override;
    Function GetAnnotationState(): TMagAnnotationState; Override;
    Function GetColor(): TColor; Override;
    Function GetFont(): TFont; Override;
    Function GetMarkElements(): Tlist; Override;
    Procedure ClearAllAnnotations(); Override;
    Procedure ClearLastAnnotation(); Override;
    Procedure ClearSelectedAnnotations(); Override;
    Procedure Copy(); Override;
    Procedure CreateMarkElement(Element: TMagAnnotationElement); Override;
    Procedure Cut(); Override;
    Procedure DisplayCurrentMarkProperties(); Override;
    Procedure DrawText(Left, Right, Top, Bottom, Red, Green, Blue: Integer; Text: String; FontSize: Integer); Override;
    Procedure EnableMeasurements(); Override;
    Procedure LoadAnnotationData(Data: TStrings); Override;
    Procedure MouseDownEvent(Button, x, y: Integer); Override;
    Procedure MouseUpEvent(Button, x, y: Integer); Override;
    Procedure Paste(); Override;
    Procedure SelectAll(); Override;
    Procedure SetAnnotationColor(aColor: TColor); Override;
    Procedure SetAnnotationStyle(Value: TMagAnnotationStyle); Override;
    Procedure SetAnnotationStyles(); Override;
    Procedure SetArrowLength(ArrowLength: TMagAnnotationArrowSize); Override;
    Procedure SetFont(TheFontName: String; TheFontSize: Integer; IsBold: Boolean; IsItalic: Boolean); Override;
    Procedure SetLineWidth(Width: TMagAnnotationLineWidth); Override;
    Procedure SetOpaque(IsOpaque: Boolean); Override;
    Procedure SetTool(NewTool: TMagAnnotationToolType); Override;
    Procedure Undo(); Override;
    Procedure UnselectAllMarks(); Override;
    {$ENDIF}
    Property Page: Integer Write SetPage;
    Property PageCount: Integer Read FPageCount Write FPageCount;
  End;

Const
  ANNOTATION_SEPERATOR_CHAR = ',';
  ARROW_LONG = 60;
  ARROW_MEDIUM = 40;
  ARROW_SMALL = 20;
  ART_INVALID_ID = -1;
  MEDIUM_LINE_WIDTH = 5;
  THICK_LINE_WIDTH = 10;
  THIN_LINE_WIDTH = 2;
  {
  TOOL_POINTER = 1;
  TOOL_FREEHAND_LINE = 2;
  TOOL_STRAIGHT_LINE = 3;
  TOOL_FIllED_RECTANGLE = 4;
  TOOL_HOLLOW_RECTANGLE = 5;
  TOOL_FILLED_ELLIPSE = 6;
  TOOL_HOLLOW_ELLIPSE = 7;
  TOOL_TYPED_TEXT = 8;
  TOOL_ARROW = 9;
  TOOL_PROTRACTOR = 10;
  TOOL_RULER = 11;
  TOOL_PLUS = 12;
  TOOL_MINUS = 13;
  }

{$IFNDEF ARTX}
Function GetMarkDetails(MarkIndex: Integer; CurArtPage: IGArtPage): String;
Function GetMarks(CurArtPage: IGArtPage): TStrings;
Procedure CreateMark(MarkDetails: String; CurArtPage: IGArtPage);
Procedure OutputMarks(OutputFileName: String; CurArtPage: IGArtPage);
{$ENDIF}
Procedure Register;

Implementation
Uses
  Dialogs,
  Math,
  SysUtils,
  UMagDefinitions,
  Umagutils8
  ;
{$R *.dfm}

Procedure Register;
Begin
  RegisterComponents('Imaging', [TMagAnnotationIG14]);
End;

Destructor TMagAnnotationIG14.Destroy();
Begin
  IGArtCtrl.Free();
  Inherited;
End;

Procedure TMagAnnotationIG14.Initialize(CurPoint: IIGPoint; CurPage: IIGPage; CurPageDisp: IIGPageDisplay; PageViewHwnd: Integer; ForDiagramAnnotation: Boolean);
Begin
  IgCurPoint := CurPoint;
  If ArtPage <> Nil Then
  Begin
    ArtPage := Nil;
  End;
{$IFDEF ARTX}
  ArtPage := IGArtCtrl.CreatePage;
  { TODO -oDick Maley -cArtX : ? }
{$ELSE}
  ArtPage := IGArtCtrl.CreateArtPage(CurPage, CurPageDisp, PageViewHwnd);
  ArtPage.SetControlOption(CtrlArtLockViewing, 0); // turns off stupid lock icon when locking annotations
{$ENDIF}
  Self.PageViewHwnd := PageViewHwnd;
  CurrentPageDisp := CurPageDisp;
  CurrentPage := CurPage;
End;



Function TMagAnnotationIG14.IsValid(): Boolean;
Var
  Res: Boolean;
Begin
  Res := False;
  If (ArtPage <> Nil) And (CurrentPage.IsValid = True) Then
  Begin
    Res := True;
  End;
  Result := Res;
End;


Procedure TMagAnnotationIG14.SetPage(Value: Integer);
Var
  i: Integer;
Begin
  FPage := Value;
{$IFDEF ARTX}
  { TODO -oDick Maley -cArtX : Provide SetPage code for ArtX }
{$ELSE}
  For i := 1 To FPageCount Do
  Begin
    If i = Value Then
      ArtPage.GroupVisible(Inttostr(i), True)
    Else
      ArtPage.GroupVisible(Inttostr(i), False);
  End;
  ArtPage.GlobalAttrGroup := Inttostr(Value);
{$ENDIF}
End;

Function TMagAnnotationIG14.GetMarkCount(): Integer;
Begin
  Result := 0;
  If ArtPage = Nil Then
    Exit;
  If IsValid() Then
    Result := ArtPage.MarkCount;
End;

Constructor TMagAnnotationIG14.Create(AOwner: TComponent);
Begin
  Inherited;
  IsInitialized := False;
  IGArtCtrl := {$IFDEF ARTX}TIGArtXCtl{$ELSE}TIGArtCtl{$ENDIF}.Create(Self);
  IGArtCtrl.{$IFDEF ARTX}OnPreCreateMarkNotify{$ELSE}OnPreCreateNotify{$ENDIF} := OnPreCreateNotify;
  FLastMarkIndex := -1;
End;

Function TMagAnnotationIG14.GetArtComponentInterface(): IIGComponent;
Begin
  Result := IGArtCtrl.ComponentInterface;
End;

{$IFDEF ARTX}
Procedure TMagAnnotationIG14.OnPreCreateNotify(ASender: Tobject; Const Params: IIGArtXPreCreateMarkEventParams);
{$ELSE}
Procedure TMagAnnotationIG14.OnPreCreateNotify(ASender: Tobject; Const PPage: IIGArtPage;
  MarkIndex: Integer; MarkType: Integer;
  Const CreateFlag: IIGArtEventParams);
{$ENDIF}
Begin
  Inherited;
{$IFDEF ARTX}
{$ELSE}
  FLastMarkIndex := MarkIndex;
{$ENDIF}
  If ArtPage = Nil Then
  Begin
    Showmessage('art page is null!');
  End;
  If Self.CurrentPage = Nil Then
  Begin
    Showmessage('current page is nil');
  End;
End;

Procedure TMagAnnotationIG14.RemoveOrientationLabel();
{$IFDEF ARTX}
Var
  ArtXGroup: IIGArtXGroup;
Begin
  ArtXGroup := ArtPage.GroupGet('RADCODE');
  If ArtXGroup = Nil Then Exit;
  ArtPage.GroupDelete(ArtXGroup);
{$ELSE}
Begin
  ArtPage.GroupDelete('RADCODE');
{$ENDIF}
End;

Procedure TMagAnnotationIG14.InitializeVariables();
Begin
  If IsInitialized = False Then
  Begin
    CurrentArrowPointer := MagAnnArrowPointer;
    CurrentArrowLength := MagAnnArrowSizeMedium;
    LineWidth := MagAnnLineWidthMedium;
    IsInitialized := True;
    FontSize := 8;
    CurrentAnnotationColor := clBlue;
    Italic := False;
    Bold := False;
    FontName := 'MS Sans Serif';
    Opaque := True;
    SetAnnotationStyle(FAnnotationStyle);
  End;
End;

Procedure TMagAnnotationIG14.SetArrowPointer(aPointer: TMagAnnotationArrowType);
Begin
  If IsValid = False Then Exit;
  CurrentArrowPointer := aPointer;
{$IFNDEF ARTX}
  ArtPage.GlobalAttrArrowType := GetIG14ArrowPointer(aPointer);
{$ENDIF}
End;

{$IFNDEF ARTX}
Function TMagAnnotationIG14.GetIG14ArrowPointer(aPointer: TMagAnnotationArrowType): EnumIGArtArrowType;
Begin
  Result := ArrowPointer;
  Case aPointer Of
    MagAnnArrowPointer:
      Begin
        Result := ArrowPointer;
      End;
    MagAnnArrowSolid:
      Begin
        Result := ArrowSolid;
      End;
    MagAnnArrowOpen:
      Begin
        Result := ArrowOpen;
      End;
    MagAnnArrowPointerSolid:
      Begin
        Result := ArrowPointerSolid;
      End;
  End;
End;

Function TMagAnnotationIG14.GetAnnotationType(annType: TMagAnnotationToolType): EnumIGArtMarkType;
Begin
  Result := MarkSelect;
  Case annType Of
    MagAnnToolPointer:
      Begin
        Result := MarkSelect;
      End;
    MagAnnToolFreehandLine:
      Begin
        Result := MarkFreehandLine;
      End;
    MagAnnToolStraightLine:
      Begin
        Result := MarkStraightLine;
      End;
    MagAnnToolFilledRectangle:
      Begin
        Result := MarkFilledRectangle;
      End;
    MagAnnToolHollowRectangle:
      Begin
        Result := MarkHollowRectangle;
      End;
    MagAnnToolFilledEllipse:
      Begin
        Result := MarkFilledEllipse;
      End;
    MagAnnToolHollowEllipse:
      Begin
        Result := MarkHollowEllipse;
      End;
    MagAnnToolTypedText:
      Begin
        Result := MarkTypedText;
      End;
    MagAnnToolArrow:
      Begin
        Result := MarkArrow;
      End;
    MagAnnToolProtractor:
      Begin
        Result := MarkProtractor;
      End;
    MagAnnToolRuler:
      Begin
        Result := MarkRuler;
      End;
    MagAnnToolPlus:
      Begin
        Result := MarkStraightLine;
      End;
    MagAnnToolMinus:
      Begin
        Result := MarkStraightLine;
      End;
  End;
End;

Function TMagAnnotationIG14.GetMarkElementType(MarkType: EnumIGArtMarkType): TMagAnnotationElementType;
Begin
  Result := MagAnnotationETannot_polygon;
  Case MarkType Of
    MarkHollowRectangle: Result := MagAnnotationETannot_rect;
    MarkHollowEllipse: Result := MagAnnotationETannot_ellipse;
    MarkTypedText: Result := MagAnnotationETannot_text;
    MarkStraightLine: Result := MagAnnotationETannot_line;
    MarkRuler: Result := MagAnnotationETlength;
    MarkFreehandLine: Result := MagAnnotationETannot_polygon;
  End;
End;

Function TMagAnnotationIG14.GetMarkElementTypeIG(MarkType: TMagAnnotationElementType): EnumIGArtMarkType;
Begin
  Result := MarkFreehandLine;
  Case MarkType Of
    MagAnnotationETannot_rect: Result := MarkHollowRectangle;
    MagAnnotationETannot_ellipse: Result := MarkHollowEllipse;
    MagAnnotationETannot_text: Result := MarkTypedText;
    MagAnnotationETannot_line: Result := MarkStraightLine;
    MagAnnotationETlength: Result := MarkRuler;
    MagAnnotationETannot_polygon: Result := MarkFreehandLine;
  End;
End;

Procedure CreateMark(MarkDetails: String; CurArtPage: IGArtPage);
Var
  Length: Integer;
  NumPoints: Integer;
  i, j: Integer;
  LMark: Longint;
  aX, aY: Integer;
  InText: String;
  Val: String;
Begin

  CurArtPage.GlobalAttrBounds.Left := Strtoint(MagPiece(MarkDetails, ANNOTATION_SEPERATOR_CHAR, 2));
  CurArtPage.GlobalAttrBounds.Top := Strtoint(MagPiece(MarkDetails, ANNOTATION_SEPERATOR_CHAR, 3));
  CurArtPage.GlobalAttrBounds.Right := Strtoint(MagPiece(MarkDetails, ANNOTATION_SEPERATOR_CHAR, 4));
  CurArtPage.GlobalAttrBounds.Bottom := Strtoint(MagPiece(MarkDetails, ANNOTATION_SEPERATOR_CHAR, 5));
  CurArtPage.GlobalAttrBackColor.RGB_R := Strtoint(MagPiece(MarkDetails, ANNOTATION_SEPERATOR_CHAR, 6));
  CurArtPage.GlobalAttrBackColor.RGB_G := Strtoint(MagPiece(MarkDetails, ANNOTATION_SEPERATOR_CHAR, 7));
  CurArtPage.GlobalAttrBackColor.RGB_B := Strtoint(MagPiece(MarkDetails, ANNOTATION_SEPERATOR_CHAR, 8));
  CurArtPage.GlobalAttrForeColor.RGB_R := Strtoint(MagPiece(MarkDetails, ANNOTATION_SEPERATOR_CHAR, 9));
  CurArtPage.GlobalAttrForeColor.RGB_G := Strtoint(MagPiece(MarkDetails, ANNOTATION_SEPERATOR_CHAR, 10));
  CurArtPage.GlobalAttrForeColor.RGB_B := Strtoint(MagPiece(MarkDetails, ANNOTATION_SEPERATOR_CHAR, 11));
  CurArtPage.GlobalAttrHighlight := Maginttobool(Strtoint(MagPiece(MarkDetails, ANNOTATION_SEPERATOR_CHAR, 12)));
  CurArtPage.GlobalAttrLineSize := Strtoint(MagPiece(MarkDetails, ANNOTATION_SEPERATOR_CHAR, 13));
  CurArtPage.GlobalAttrPenStyle := Strtoint(MagPiece(MarkDetails, ANNOTATION_SEPERATOR_CHAR, 14));
  CurArtPage.GlobalAttrArcRadius := Strtoint(MagPiece(MarkDetails, ANNOTATION_SEPERATOR_CHAR, 15));
  CurArtPage.GlobalAttrPrecision := Strtoint(MagPiece(MarkDetails, ANNOTATION_SEPERATOR_CHAR, 16));
  CurArtPage.GlobalAttrArrowLength := Strtoint(MagPiece(MarkDetails, ANNOTATION_SEPERATOR_CHAR, 17));
  CurArtPage.GlobalAttrArrowType := Strtoint(MagPiece(MarkDetails, ANNOTATION_SEPERATOR_CHAR, 18));
  CurArtPage.GlobalAttrMeasurementUnits := Strtoint(MagPiece(MarkDetails, ANNOTATION_SEPERATOR_CHAR, 19));
  CurArtPage.GlobalAttrTextAlign := Strtoint(MagPiece(MarkDetails, ANNOTATION_SEPERATOR_CHAR, 20));

// Optional Values
  Val := MagPiece(MarkDetails, ANNOTATION_SEPERATOR_CHAR, 21);
  If Val <> '' Then CurArtPage.GlobalAttrFontName := Val;
  Val := MagPiece(MarkDetails, ANNOTATION_SEPERATOR_CHAR, 22);
  If Val <> '' Then CurArtPage.GlobalAttrFontSize := Strtoint(Val);
  Val := MagPiece(MarkDetails, ANNOTATION_SEPERATOR_CHAR, 23);
  If Val <> '' Then CurArtPage.GlobalAttrFontbold := Strtoint(Val);
  Val := MagPiece(MarkDetails, ANNOTATION_SEPERATOR_CHAR, 24);
  If Val <> '' Then CurArtPage.Globalattrfontitalic := Strtoint(Val);

  InText := MagPiece(MarkDetails, ANNOTATION_SEPERATOR_CHAR, 25);

  If InText = '' Then
  Begin

  End
  Else
  Begin
    CurArtPage.GlobalAttrText := InText;
  End;

  Length := Maglength(MarkDetails, ANNOTATION_SEPERATOR_CHAR);

  NumPoints := ceil((Length - 25) / 2);

  CurArtPage.GlobalAttrPointArray.Resize(NumPoints);

  For i := 0 To NumPoints - 1 Do
  Begin
    j := (i * 2) + 26;
    aX := Strtoint(MagPiece(MarkDetails, ANNOTATION_SEPERATOR_CHAR, j));
    aY := Strtoint(MagPiece(MarkDetails, ANNOTATION_SEPERATOR_CHAR, j + 1));
    CurArtPage.GlobalAttrPointArray.XPos[i] := aX;
    CurArtPage.GlobalAttrPointArray.YPos[i] := aY;
  End;

  LMark := CurArtPage.MarkCreate(Strtoint(MagPiece(MarkDetails, ANNOTATION_SEPERATOR_CHAR, 1)));
  CurArtPage.MarkPaint(LMark);
End;

Function GetMarks(CurArtPage: IGArtPage): TStrings;
Var
  i: Integer;
  NextMark: Longint;
  Marks: TStrings;
Begin
  Marks := Tstringlist.Create();
  i := CurArtPage.MarkFirst();
  While i >= 0 Do
  Begin
    NextMark := CurArtPage.Marknext(i);
    Marks.Add(GetMarkDetails(i, CurArtPage));
    i := NextMark;
  End;
  Result := Marks;
End;

Procedure OutputMarks(OutputFileName: String; CurArtPage: IGArtPage);
Var
  AnnotationFile: Textfile;
  i: Integer;
  NextMark: Longint;
Begin

  AssignFile(AnnotationFile, OutputFileName);
  Rewrite(AnnotationFile);
  i := CurArtPage.MarkFirst();
  While i >= 0 Do
  Begin
    NextMark := CurArtPage.Marknext(i);
    Writeln(AnnotationFile, GetMarkDetails(i, CurArtPage));
    i := NextMark;
  End;
  CloseFile(AnnotationFile);
End;

Function GetMarkDetails(MarkIndex: Integer; CurArtPage: IGArtPage): String;
Var
  Res: String;
  i: Integer;
  FFFont: TFont;
  IsBold, IsItalic: Boolean;
Begin
  CurArtPage.MarkQuery(MarkIndex);
  FFFont := TFont.Create;
  SetOleFont(FFFont, CurArtPage.AttrFont);
  If Fsbold In FFFont.Style Then
    IsBold := True
  Else
    IsBold := False;
  If Fsitalic In FFFont.Style Then
    IsItalic := True
  Else
    IsItalic := False; 
  Res := '';

  Res := Inttostr(CurArtPage.AttrMarkType) + ANNOTATION_SEPERATOR_CHAR + Inttostr(CurArtPage.AttrBounds.Left) + ANNOTATION_SEPERATOR_CHAR +
    Inttostr(CurArtPage.AttrBounds.Top) + ANNOTATION_SEPERATOR_CHAR + Inttostr(CurArtPage.AttrBounds.Right) + ANNOTATION_SEPERATOR_CHAR +
    Inttostr(CurArtPage.AttrBounds.Bottom) + ANNOTATION_SEPERATOR_CHAR + Inttostr(CurArtPage.AttrBackColor.RGB_R) + ANNOTATION_SEPERATOR_CHAR +
    Inttostr(CurArtPage.AttrBackColor.RGB_G) + ANNOTATION_SEPERATOR_CHAR + Inttostr(CurArtPage.AttrBackColor.RGB_B) + ANNOTATION_SEPERATOR_CHAR +
    Inttostr(CurArtPage.AttrForeColor.RGB_R) + ANNOTATION_SEPERATOR_CHAR + Inttostr(CurArtPage.AttrForeColor.RGB_G) + ANNOTATION_SEPERATOR_CHAR +
    Inttostr(CurArtPage.AttrForeColor.RGB_B) + ANNOTATION_SEPERATOR_CHAR + Inttostr(MagBoolToInt(CurArtPage.AttrHighlight)) +
    ANNOTATION_SEPERATOR_CHAR + Inttostr(CurArtPage.AttrLineSize) + ANNOTATION_SEPERATOR_CHAR + Inttostr(CurArtPage.AttrPenStyle) +
    ANNOTATION_SEPERATOR_CHAR + Inttostr(CurArtPage.AttrArcRadius) + ANNOTATION_SEPERATOR_CHAR + Inttostr(CurArtPage.AttrPrecision) + ANNOTATION_SEPERATOR_CHAR +
    Inttostr(CurArtPage.AttrArrowLength) + ANNOTATION_SEPERATOR_CHAR + Inttostr(CurArtPage.AttrArrowType) + ANNOTATION_SEPERATOR_CHAR +
    Inttostr(CurArtPage.AttrMeasurementUnits) + ANNOTATION_SEPERATOR_CHAR + Inttostr(CurArtPage.AttrTextAlign) + ANNOTATION_SEPERATOR_CHAR +
    FFFont.Name + ANNOTATION_SEPERATOR_CHAR + Inttostr(FFFont.Size) + ANNOTATION_SEPERATOR_CHAR + Inttostr(MagBoolToInt(IsBold)) + ANNOTATION_SEPERATOR_CHAR + Inttostr(MagBoolToInt(IsItalic))
    + ANNOTATION_SEPERATOR_CHAR + CurArtPage.AttrText;

  For i := 0 To CurArtPage.AttrPointCount - 1 Do
  Begin
    Res := Res + ANNOTATION_SEPERATOR_CHAR + Inttostr(CurArtPage.AttrPointArray.XPos[i]) + ANNOTATION_SEPERATOR_CHAR + Inttostr(CurArtPage.AttrPointArray.YPos[i]);
  End;
  Result := Res;
End;

Procedure TMagAnnotationIG14.OnCreateNotify(ASender: Tobject; Const PPage: IIGArtPage; MarkIndex: Integer;
  MarkType: Integer; Const CreateFlag: IIGArtEventParams);
Begin
  Inherited;
  FLastMarkIndex := MarkIndex;
End;

Function TMagAnnotationIG14.GetAnnotationData(): TStrings;
Begin
  Result := GetMarks(ArtPage);
End;

Function TMagAnnotationIG14.GetAnnotationState(): TMagAnnotationState;
Var
  AnnotationState: TMagAnnotationState;
Begin
  AnnotationState := TMagAnnotationState.Create();
  AnnotationState.ArrowType := CurrentArrowPointer;
  AnnotationState.ToolType := CurrentTool;
  AnnotationState.LineWidth := LineWidth;
  AnnotationState.ArrowSize := CurrentArrowLength;
  AnnotationState.FontSize := FontSize;
  AnnotationState.FontName := FontName;
  AnnotationState.Fontbold := Bold;
  AnnotationState.FontItalic := Italic;
  AnnotationState.AnnotationColor := CurrentAnnotationColor;
  AnnotationState.IsOpaque := Opaque;
  AnnotationState.Font := GetFont();
  Result := AnnotationState;
End;

Function TMagAnnotationIG14.GetColor(): TColor;
Begin
  Result := CurrentAnnotationColor;
End;

Procedure TMagAnnotationIG14.SetFont(TheFontName: String; TheFontSize: Integer; IsBold: Boolean; IsItalic: Boolean);
Begin
  If IsValid() = False Then Exit;
  Bold := IsBold;
  Italic := IsItalic;
  FontName := TheFontName;
  FontSize := TheFontSize;
  ArtPage.GlobalAttrFontbold := MagBoolToInt(IsBold);
  ArtPage.Globalattrfontitalic := MagBoolToInt(IsItalic);
  ArtPage.GlobalAttrFontName := TheFontName;
  ArtPage.GlobalAttrFontSize := TheFontSize;
End;

Function TMagAnnotationIG14.GetMarkElements(): Tlist;
Var
  List: Tlist;
  i: Integer;
  NextMark: Longint;
Begin
  List := Tlist.Create();
  i := ArtPage.MarkFirst();
  While i >= 0 Do
  Begin
    NextMark := ArtPage.Marknext(i);
    List.Add(GetMarkElement(i));
    i := NextMark;
  End;
  Result := List;
End;

Procedure TMagAnnotationIG14.SetAnnotationColor(aColor: TColor);
Begin
  If IsValid() = False Then Exit;
  CurrentAnnotationColor := aColor;
  ArtPage.GlobalAttrForeColor.Set_RGB_R(ColorToRGB(aColor));
  ArtPage.GlobalAttrForeColor.Set_RGB_G(ColorToRGB(aColor) Shr 8);
  ArtPage.GlobalAttrForeColor.Set_RGB_B(ColorToRGB(aColor) Shr 16);
End;

Procedure TMagAnnotationIG14.SetOpaque(IsOpaque: Boolean);
Begin
  If IsValid() = False Then Exit;
  Opaque := IsOpaque;
  ArtPage.GlobalAttrHighlight := Not IsOpaque;
End;

Procedure TMagAnnotationIG14.Undo();
Begin
  FHasBeenModified := True;
  ArtPage.EditUndo();
End;

Procedure TMagAnnotationIG14.Cut();
Begin
  FHasBeenModified := True;
  ArtPage.EditCut();
End;

Procedure TMagAnnotationIG14.Copy();
Begin
  FHasBeenModified := True;
  ArtPage.EditCopy();
End;

Procedure TMagAnnotationIG14.Paste();
Begin
  FHasBeenModified := True;
  ArtPage.EditPaste();
End;

Procedure TMagAnnotationIG14.SelectAll();
Var
  i: Longint;
  NextMark: Longint;
Begin
  FHasBeenModified := True;
  If IsValid() Then
  Begin
    ArtPage.EditUndoRecord(False);
    i := ArtPage.MarkFirst();
    While i >= 0 Do
    Begin
      NextMark := ArtPage.Marknext(i);
      ArtPage.MarkSelect(i, True);
      i := NextMark;
    End;
    ArtPage.EditUndoRecord(True);
  End;
End;

Procedure TMagAnnotationIG14.ClearAllAnnotations();
Var
  i: Longint;
  NextMark: Longint;
Begin
  FLastMarkIndex := -1;
  FHasBeenModified := True;
  If IsValid() Then
  Begin
    ArtPage.EditUndoRecord(True);
    i := ArtPage.MarkFirst();
    While i >= 0 Do
    Begin
      NextMark := ArtPage.Marknext(i);
      ArtPage.Markdelete(i);
      i := NextMark;
    End;
    ArtPage.EditUndoRecord(False);
    FHasBeenModified := False;
  End;
End;

Procedure TMagAnnotationIG14.ClearLastAnnotation();
Begin
  Try
    Self.MouseUpEvent(1, 1, 1);
  Except
    On e: Exception Do
    Begin
      Showmessage('Exception clearing last Annotation: ' + e.Message);
    End;
  End;
End;

Procedure TMagAnnotationIG14.ClearSelectedAnnotations();
Var
  i: Longint;
  Selected: Boolean;
  NextMark: Longint;
Begin
  If IsValid() Then
  Begin
    ArtPage.EditUndoRecord(True);
    i := ArtPage.MarkFirst();
    While i >= 0 Do
    Begin
      Selected := ArtPage.Markisselected(i);
      NextMark := ArtPage.Marknext(i);
      If Selected Then
      Begin
        ArtPage.Markvisible(i, True);
        ArtPage.Markdelete(i);
      End;
      i := NextMark;
    End;
    ArtPage.EditUndoRecord(False);
  End;
End;

Procedure TMagAnnotationIG14.DisplayCurrentMarkProperties();
Var
  MarkIndex: Longint;
Begin
  If IsValid() Then
  Begin
    MarkIndex := GetCurrentMarkIndex();
    If MarkIndex <> ART_INVALID_ID Then
    Begin
      ArtPage.MarkAttributesShow(MarkIndex);
    End;
  End;
End;

Procedure TMagAnnotationIG14.DrawText(Left, Right, Top, Bottom, Red, Green, Blue: Integer; Text: String; FontSize: Integer);
Var
  LMark: Longint;
  Rect: IGRectangle;
  Color: IIGPixel;
  MeasureUnits: EnumIGArtMeasurementUnits;
Begin
  If Text = '' Then Exit;
  ArtPage.GlobalAttrGroup := 'RADCODE';

  ArtPage.GlobalAttrMeasurementUnits := UnitCentimeters;

  ArtPage.GlobalAttrFontName := 'Microsoft Sans Serif';
  ArtPage.GlobalAttrFontSize := FontSize;
  ArtPage.GlobalAttrLineSize := 5;
  ArtPage.GlobalAttrTextAlign := 0;

  LMark := ArtPage.MarkCreate(MarkTypedText);

  ArtPage.MarkQuery(LMark);
  Rect := ArtPage.AttrBounds;
  Rect.Left := Left;
  Rect.Top := Top;
  Rect.Width := (Right - Left);
  Rect.Height := (Bottom - Top);

  ArtPage.AttrBounds := Rect;

  ArtPage.AttrText := Text;
  Color := ArtPage.AttrForeColor;
  Color.RGB_R := Red;
  Color.RGB_G := Green;
  Color.RGB_B := Blue;
  ArtPage.AttrForeColor := Color;

  ArtPage.MarkModify(LMark);
  ArtPage.MarkPaint(LMark);

  ArtPage.GroupAccess('RADCODE', False);

  ArtPage.GlobalAttrGroup := Inttostr(FPage);
End;

Procedure TMagAnnotationIG14.EnableMeasurements();
Begin
  If FAnnotationStyle = Nil Then
  Begin
    SetAnnotationColor(clYellow);
    SetLineWidth(MagAnnLineWidthThin);
    ArtPage.GlobalAttrText := '%d cm';
    ArtPage.GlobalAttrMeasurementUnits := UnitCentimeters;
  End
  Else
  Begin
    SetAnnotationStyle(FAnnotationStyle);
  End;
  SetTool(MagAnnToolRuler);
  SetFont('Microsoft Sans Serif', 36, False, False);
End;

Function TMagAnnotationIG14.GetFont(): TFont;
Var
  aFont: TFont;
  aFontStyle: TFontStyles;
Begin
  aFont := TFont.Create();
  aFont.Size := FontSize;
  aFont.Name := FontName;
  If Bold = True And Italic = True Then
  Begin
    aFont.Style := [Fsbold, Fsitalic];
  End
  Else
    If Bold = True And Italic = False Then
    Begin
      aFont.Style := [Fsbold];
    End
    Else
      If Bold = False And Italic = True Then
      Begin
        aFont.Style := [Fsitalic];
      End;
  Result := aFont;
End;

Procedure TMagAnnotationIG14.LoadAnnotationData(Data: TStrings);
Var
  i: Integer;
Begin
  If Data = Nil Then Exit;
  If Not IsValid() Then Exit;

  For i := 0 To Data.Count - 1 Do
  Begin
    CreateMark(Data.Strings[i], ArtPage);
  End;

End;

Procedure TMagAnnotationIG14.MouseDownEvent(Button, x, y: Integer);
Var
  HMarkIndex: Longint;
  HMarkSelected: Longint;
  FSelected: Boolean;
  DwSelectCount: Longint;
  LMark: Longint;
Begin
  IgCurPoint.XPos := x;
  IgCurPoint.YPos := y;

  If IsValid() Then
  Begin

    If Button = 1 Then
    Begin
      If CurrentTool = MagAnnToolPlus Then
      Begin
        CurrentPageDisp.ConvertPointCoordinates(PageViewHwnd, 0, IgCurPoint, IG_DSPL_CONV_DEVICE_TO_IMAGE);
        ArtPage.GlobalAttrBounds.Left := IgCurPoint.XPos - 50;
        ArtPage.GlobalAttrBounds.Top := IgCurPoint.YPos - 50;
        ArtPage.GlobalAttrBounds.Right := IgCurPoint.XPos + 50;
        ArtPage.GlobalAttrBounds.Bottom := IgCurPoint.YPos + 50;

        ArtPage.GlobalAttrPointArray.Resize(2);
        ArtPage.GlobalAttrPointArray.XPos[0] := 0;
        ArtPage.GlobalAttrPointArray.YPos[0] := 50;
        ArtPage.GlobalAttrPointArray.XPos[1] := 100;
        ArtPage.GlobalAttrPointArray.YPos[1] := 50;

        LMark := ArtPage.MarkCreate(MarkStraightLine);
        ArtPage.MarkPaint(LMark);

        ArtPage.GlobalAttrBounds.Left := IgCurPoint.XPos - 50;
        ArtPage.GlobalAttrBounds.Top := IgCurPoint.YPos - 50;
        ArtPage.GlobalAttrBounds.Right := IgCurPoint.XPos + 50;
        ArtPage.GlobalAttrBounds.Bottom := IgCurPoint.YPos + 50;

        ArtPage.GlobalAttrPointArray.Resize(2);
        ArtPage.GlobalAttrPointArray.XPos[0] := 50;
        ArtPage.GlobalAttrPointArray.YPos[0] := 0;
        ArtPage.GlobalAttrPointArray.XPos[1] := 50;
        ArtPage.GlobalAttrPointArray.YPos[1] := 100;

        LMark := ArtPage.MarkCreate(MarkStraightLine);
        ArtPage.MarkPaint(LMark);
        FHasBeenModified := True;
      End
      Else
        If CurrentTool = MagAnnToolMinus Then
        Begin
          CurrentPageDisp.ConvertPointCoordinates(PageViewHwnd, 0, IgCurPoint, IG_DSPL_CONV_DEVICE_TO_IMAGE);
          ArtPage.GlobalAttrBounds.Left := IgCurPoint.XPos - 50;
          ArtPage.GlobalAttrBounds.Top := IgCurPoint.YPos - 50;
          ArtPage.GlobalAttrBounds.Right := IgCurPoint.XPos + 50;
          ArtPage.GlobalAttrBounds.Bottom := IgCurPoint.YPos + 50;

          ArtPage.GlobalAttrPointArray.Resize(2);
          ArtPage.GlobalAttrPointArray.XPos[0] := 0;
          ArtPage.GlobalAttrPointArray.YPos[0] := 50;
          ArtPage.GlobalAttrPointArray.XPos[1] := 100;
          ArtPage.GlobalAttrPointArray.YPos[1] := 50;

          LMark := ArtPage.MarkCreate(MarkStraightLine);
          ArtPage.MarkPaint(LMark);
          FHasBeenModified := True;
        End
        Else
        Begin
          ArtPage.InteractionProcess(Button, 1, IgCurPoint);
          FHasBeenModified := True;
        End;
    End
    Else
    Begin //#1
      HMarkIndex := ArtPage.MarkHitTest(x, y);
      If (HMarkIndex >= 0) And (ArtPage.UserMode = UserEditMode) Then
      Begin //#2
        FSelected := ArtPage.Markisselected(HMarkIndex);
        DwSelectCount := ArtPage.MarkSelectCount;
        If (DwSelectCount > 1) Or ((1 = DwSelectCount) And (Not FSelected)) Then
        Begin //#3
          ArtPage.EditUndoRecord(True);
          HMarkSelected := ArtPage.MarkSelectedFirst;

          While HMarkSelected <> ART_INVALID_ID Do
          Begin //#4
            If HMarkSelected = HMarkIndex Then
              HMarkSelected := ArtPage.MarkSelectedNext(HMarkSelected)
            Else
            Begin //#5
              ArtPage.MarkSelect(HMarkSelected, False);
              HMarkSelected := ArtPage.MarkSelectedFirst;
            End; //#5
          End; //#4

          If (Not FSelected) Then
            ArtPage.MarkSelect(HMarkIndex, True);

          ArtPage.EditUndoRecord(False);
        End //#3
        Else
        Begin //#6
          If (Not FSelected) Then
            ArtPage.MarkSelect(HMarkIndex, True);
        End; //#6
        If DwSelectCount = 1 Then
          ArtPage.MarkQuery(HMarkIndex);
        HMarkIndex := ArtPage.MarkSelectedFirst();
        If HMarkIndex <> ART_INVALID_ID Then
        Begin
          ArtPage.MarkAttributesShow(HMarkIndex);
        End
        Else
        Begin
          SetTool(MagAnnToolPointer);
          UnselectAllMarks();
        End;
      End
      Else
      Begin
        SetTool(MagAnnToolPointer);
        UnselectAllMarks();
      End; //#2
    End; //#1
  End;

End;

Procedure TMagAnnotationIG14.MouseUpEvent(Button, x, y: Integer);
Begin
  If IsValid() Then
  Begin
    IgCurPoint.XPos := x;
    IgCurPoint.YPos := y;
    ArtPage.InteractionProcess(Button, 2, IgCurPoint);
  End;
End;

Procedure TMagAnnotationIG14.SetAnnotationStyles();
Begin
  If IsValid() = False Then Exit;
  SetArrowPointer(CurrentArrowPointer);
  SetArrowLength(CurrentArrowLength);
  SetFont(FontName, FontSize, Bold, Italic);
  SetAnnotationColor(CurrentAnnotationColor);
  SetLineWidth(LineWidth);
  SetOpaque(Opaque);
  SetAnnotationStyle(FAnnotationStyle);
End;

Procedure TMagAnnotationIG14.SetArrowLength(ArrowLength: TMagAnnotationArrowSize);
Begin
  If IsValid = False Then Exit;
  CurrentArrowLength := ArrowLength;
  Case ArrowLength Of
    MagAnnArrowSizeSmall: ArtPage.GlobalAttrArrowLength := ARROW_SMALL;
    MagAnnArrowSizeMedium: ArtPage.GlobalAttrArrowLength := ARROW_MEDIUM;
    MagAnnArrowSizeLarge: ArtPage.GlobalAttrArrowLength := ARROW_LONG;
  End;
End;

Procedure TMagAnnotationIG14.SetLineWidth(Width: TMagAnnotationLineWidth);
Begin
  If IsValid() = False Then Exit;
  LineWidth := Width;
  Case Width Of
    MagAnnLineWidthThin: ArtPage.GlobalAttrLineSize := THIN_LINE_WIDTH;
    MagAnnLineWidthMedium: ArtPage.GlobalAttrLineSize := MEDIUM_LINE_WIDTH;
    MagAnnLineWidthThick: ArtPage.GlobalAttrLineSize := THICK_LINE_WIDTH;
  End;
End;

Procedure TMagAnnotationIG14.SetTool(NewTool: TMagAnnotationToolType);
Begin
  CurrentTool := NewTool;
  If IsValid() Then
  Begin
    ArtPage.GlobalAttrMarkType := GetAnnotationType(CurrentTool);
    IGArtCtrl.ToolBarButtonCheck(ArtPage.GlobalAttrMarkType, True);
  End;
End;

Procedure TMagAnnotationIG14.UnselectAllMarks();
Var
  i: Longint;
  Selected: Boolean;
  NextMark: Longint;
Begin
  If IsValid() Then
  Begin
    ArtPage.EditUndoRecord(True);
    i := ArtPage.MarkFirst();
    While i >= 0 Do
    Begin
      Selected := ArtPage.Markisselected(i);
      NextMark := ArtPage.Marknext(i);
      If Selected Then
      Begin
        ArtPage.MarkSelect(i, False);
      End;
      i := NextMark;
    End;
    ArtPage.EditUndoRecord(False);
  End;
End;

Function TMagAnnotationIG14.GetMarkElement(MarkIndex: Integer): TMagAnnotationElement;
Var
  Element: TMagAnnotationElement;
  i: Integer;
  FFFont: TFont;
  IsBold, IsItalic: Boolean;
  Cood: TMagAnnotationCood;
  PreChar: String;

  annTop, annLeft, annBottom, annRight: Integer;
  Point: TMagAnnotationPoint;
  PointList: Tlist;
Begin
  Result := Nil;
  ArtPage.MarkQuery(MarkIndex);
  annTop := ArtPage.AttrBounds.Top;
  annLeft := ArtPage.AttrBounds.Left;
  annBottom := ArtPage.AttrBounds.Bottom;
  annRight := ArtPage.AttrBounds.Right;

  Case ArtPage.AttrMarkType Of
    MarkHollowRectangle: Result := CreateRectangleElement(annLeft, annTop, annRight, annBottom);
    MarkHollowEllipse: Result := CreateEllipseElement(annLeft, annTop, annRight, annBottom);
    MarkTypedText: Result := CreateTextElement(annLeft, annTop, annRight, annBottom, ArtPage.AttrText, -1);
    MarkStraightLine: Result := CreateLineElement(annLeft, annTop, annRight, annBottom);
    MarkFreehandLine:
      Begin
        PointList := Tlist.Create();
        For i := 0 To ArtPage.AttrPointCount - 1 Do
        Begin
          Point := TMagAnnotationPoint.Create();
          Point.x := ArtPage.AttrPointArray.XPos[i];
          Point.y := ArtPage.AttrPointArray.YPos[i];
          PointList.Add(Point);
        End;
        Result := CreatePolygonElement(PointList);
      End;
  End;
End;

Procedure TMagAnnotationIG14.CreateMarkElement(Element: TMagAnnotationElement);
Var
  MarkType: EnumIGArtMarkType;
  LMark: Longint;
  annLeft, annTop, annBottom, annRight: Integer;
  TextFormat: Integer;
  TextData: String;
  Points: Tlist;
  i: Integer;
  Point: TMagAnnotationPoint;
Begin
  MarkType := GetMarkElementTypeIG(Element.ElementType);
  Case Element.ElementType Of
    MagAnnotationETannot_polygon:
      Begin
        Points := Tlist.Create();
        ArtPage.GlobalAttrBounds.Left := 0;
        ArtPage.GlobalAttrBounds.Top := 0;
        ArtPage.GlobalAttrBounds.Right := CurrentPage.ImageWidth;
        ArtPage.GlobalAttrBounds.Bottom := CurrentPage.ImageHeight;
        ParsePolygonElement(Element, Points);
        ArtPage.GlobalAttrPointArray.Resize(Points.Count);
        For i := 0 To Points.Count - 1 Do
        Begin
          Point := Points.Items[i];
          ArtPage.GlobalAttrPointArray.XPos[i] := Point.x;
          ArtPage.GlobalAttrPointArray.YPos[i] := Point.y;
        End;
      End; 
    MagAnnotationETannot_rect:
      Begin
        ParseRectangleElement(Element, annLeft, annTop, annRight, annBottom);
        ArtPage.GlobalAttrBounds.Left := annLeft;
        ArtPage.GlobalAttrBounds.Top := annTop;
        ArtPage.GlobalAttrBounds.Right := annRight;
        ArtPage.GlobalAttrBounds.Bottom := annBottom;
      End; 
    MagAnnotationETannot_ellipse:
      Begin
        ParseEllipseElement(Element, annLeft, annTop, annRight, annBottom);
        ArtPage.GlobalAttrBounds.Left := annLeft;
        ArtPage.GlobalAttrBounds.Top := annTop;
        ArtPage.GlobalAttrBounds.Right := annRight;
        ArtPage.GlobalAttrBounds.Bottom := annBottom;
      End; 
    MagAnnotationETannot_line:
      Begin
        ParseLineElement(Element, annLeft, annTop, annRight, annBottom);
        ArtPage.GlobalAttrBounds.Left := annLeft;
        ArtPage.GlobalAttrBounds.Top := annTop;
        ArtPage.GlobalAttrBounds.Right := annRight;
        ArtPage.GlobalAttrBounds.Bottom := annBottom;
      End; 
    MagAnnotationETannot_text:
      Begin
        ParseTextElement(Element, annLeft, annTop, annRight, annBottom, TextData, TextFormat);
        ArtPage.GlobalAttrBounds.Left := annLeft;
        ArtPage.GlobalAttrBounds.Top := annTop;
        ArtPage.GlobalAttrBounds.Right := annRight;
        ArtPage.GlobalAttrBounds.Bottom := annBottom;
        ArtPage.GlobalAttrFontName := 'MS Sans Serif';
        ArtPage.GlobalAttrFontSize := 8;
        ArtPage.GlobalAttrLineSize := 5;
        ArtPage.GlobalAttrTextAlign := 0;
        If TextData <> '' Then
          ArtPage.GlobalAttrText := TextData;
      End;
  End;

  LMark := ArtPage.MarkCreate(MarkType);
  ArtPage.MarkPaint(LMark);

End;

Procedure TMagAnnotationIG14.SetAnnotationStyle(Value: TMagAnnotationStyle);
Begin
  Inherited;
  If Not IsValid() Then Exit;
  If Value = Nil Then Exit;

  SetAnnotationColor(Value.AnnotationColor);
  ArtPage.GlobalAttrLineSize := Value.LineWidth;

  Case Value.MeasurementUnits Of
    0:
      Begin
        ArtPage.GlobalAttrMeasurementUnits := UnitInches;
        ArtPage.GlobalAttrText := '%d ''''';
      End;
    1:
      Begin
        ArtPage.GlobalAttrMeasurementUnits := UnitFeet;
        ArtPage.GlobalAttrText := '%d ''';
      End;
    2:
      Begin
        ArtPage.GlobalAttrMeasurementUnits := UnitYards;
        ArtPage.GlobalAttrText := '%d yards';
      End;
    3:
      Begin
        ArtPage.GlobalAttrMeasurementUnits := UnitMiles;
        ArtPage.GlobalAttrText := '%d miles';
      End;
    4:
      Begin
        ArtPage.GlobalAttrMeasurementUnits := UnitMicrometers;
        ArtPage.GlobalAttrText := '%d micrometers';
      End;
    5:
      Begin
        ArtPage.GlobalAttrMeasurementUnits := UnitMillimeters;
        ArtPage.GlobalAttrText := '%d mm';
      End;
    6:
      Begin
        ArtPage.GlobalAttrMeasurementUnits := UnitCentimeters;
        ArtPage.GlobalAttrText := '%d cm';
      End;
    7:
      Begin
        ArtPage.GlobalAttrMeasurementUnits := UnitDecimeters;
        ArtPage.GlobalAttrText := '%d dm';
      End;
    8:
      Begin
        ArtPage.GlobalAttrMeasurementUnits := UnitMeters;
        ArtPage.GlobalAttrText := '%d m';
      End;
    9:
      Begin
        ArtPage.GlobalAttrMeasurementUnits := UnitKilometers;
        ArtPage.GlobalAttrText := '%d km';
      End;
    10:
      Begin
        ArtPage.GlobalAttrMeasurementUnits := UnitDekameter;
        ArtPage.GlobalAttrText := '%d dk';
      End;
  End;

End;

Function TMagAnnotationIG14.GetAnnotationStyle(): TMagAnnotationStyle;
Begin
  Result := TMagAnnotationStyle.Create();
  Result.AnnotationColor := GetColor();
  Result.LineWidth := ArtPage.GlobalAttrLineSize;
  Result.MeasurementUnits := ArtPage.GlobalAttrMeasurementUnits;
End;

Function TMagAnnotationIG14.GetCurrentMarkIndex(): Integer;
Var
  i: Longint;
  Selected: Boolean;
  NextMark: Longint;
Begin
  Result := ART_INVALID_ID;
  If IsValid() Then
  Begin
    i := ArtPage.MarkFirst();
    While i >= 0 Do
    Begin
      Selected := ArtPage.Markisselected(i);
      NextMark := ArtPage.Marknext(i);
      If Selected Then
      Begin
        Result := i;
        Exit;
      End;
      i := NextMark;
    End;
  End;
End;
{$ENDIF}

End.
