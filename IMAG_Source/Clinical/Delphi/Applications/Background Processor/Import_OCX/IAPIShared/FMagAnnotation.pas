{
  Package: MAG - VistA Imaging
  WARNING: Per VHA Directive 2004-038, this routine should not be modified.
  Date Created: September, 2006
  Site Name:  Washington OI Field Office, Silver Spring, MD
  Developer:  Julian Werfel
  Description:
    Base Annotation component for viewing and drawing annotations on images

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
Unit FmagAnnotation;

Interface

Uses
  Classes,
  Forms,
  Graphics,
  UMagClasses,
  UMagClassesAnnot
  ;

//Uses Vetted 20090929:Controls, Messages, Windows, umagutils, XMLIntf, XMLDoc, Dialogs, Variants, SysUtils
  {
{
  THIN_LINE_WIDTH = 2;
  MEDIUM_LINE_WIDTH = 5;
  THICK_LINE_WIDTH = 10;

  ARROW_SMALL = 20;
  ARROW_MEDIUM = 40;
  ARROW_LONG = 60;

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

Type
  TMagAnnotationArrowType = (MagAnnArrowPointer, MagAnnArrowSolid, MagAnnArrowOpen, MagAnnArrowPointerSolid);
Type
  TMagAnnotationToolType = (MagAnnToolPointer, MagAnnToolFreehandLine, MagAnnToolStraightLine, MagAnnToolFilledRectangle, MagAnnToolHollowRectangle, MagAnnToolFilledEllipse,
    MagAnnToolHollowEllipse, MagAnnToolTypedText, MagAnnToolArrow, MagAnnToolProtractor, MagAnnToolRuler, MagAnnToolPlus, MagAnnToolMinus);
Type
  TMagAnnotationLineWidth = (MagAnnLineWidthThin, MagAnnLineWidthMedium, MagAnnLineWidthThick);

Type
  TMagAnnotationArrowSize = (MagAnnArrowSizeSmall, MagAnnArrowSizeMedium, MagAnnArrowSizeLarge);

Type
  TMagAnnotationElementType = (MagAnnotationETangle, MagAnnotationETannot_ellipse, MagAnnotationETannot_line, MagAnnotationETannot_polygon, MagAnnotationETannot_rect, MagAnnotationETannot_text,
    MagAnnotationETharea, MagAnnotationETlength);

Type
  TMagAnnotationCoodType = (MagAnnotationCTempty, MagAnnotationCTline, MagAnnotationCTline1, MagAnnotationCTline2, MagAnnotationCTrect, MagAnnotationCTtext);

Type
  TMagAnnotationMeasurementType = (MagAnnotationInches, MagAnnotationFeet,
    MagAnnotationYards, MagAnnotationMiles, MagAnnotationMicrometers,
    MagAnnotationMillimeteres, MagAnnotationCentimeters, MagAnntoationDecimeters,
    MagAnnotationMeters, MagAnnotationKilometers, MagAnnotationDekatmeter);

Type
  TMagAnnotationPoint = Class
  Public
    x: Integer;
    y: Integer;
  End;

Type
  TMagAnnotationCood = Class
  Private

  Public
    CoodType: TMagAnnotationCoodType;
    Data: String;

  End;

Type
  TMagAnnotationElement = Class
  Private

  Public
    Coods: Tlist;
    Length: String;
    Angle: String;
    Data: String;
    Points: String;
    Format: String;
    ElementType: TMagAnnotationElementType;

  End;

Type
  TMagAnnotationState = Class
  Private

  Public
    ArrowType: TMagAnnotationArrowType;
    ToolType: TMagAnnotationToolType;
    LineWidth: TMagAnnotationLineWidth;
    ArrowSize: TMagAnnotationArrowSize;
    Font: TFont;
    FontSize: Integer;
    FontName: String;
    Fontbold: Boolean;
    FontItalic: Boolean;
    IsOpaque: Boolean;
    AnnotationColor: TColor;
  End;

Type
  TMagAnnotation = Class(TFrame)
  Private
    Function CreateBaseElement(Left, Top, Right, Bottom: Integer): TMagAnnotationElement;
    Function ParseBaseElement(Element: TMagAnnotationElement; Var Left, Top, Right, Bottom: Integer): Boolean;
    Function GetElementTypeString(ElementType: TMagAnnotationElementType): String;
    Function GetElementTypeValue(ElementType: String): TMagAnnotationElementType;
    Function GetCoodTypeValue(CoodType: String): TMagAnnotationCoodType;
  Protected
    FHasBeenModified: Boolean;
    MagAnnotationStyleChangeEvent: TMagAnnotationStyleChangeEvent;
    FAnnotationStyle: TMagAnnotationStyle;
    Function CreateLineElement(Left, Top, Right, Bottom: Integer): TMagAnnotationElement;
    Function CreatePolygonElement(Points: Tlist): TMagAnnotationElement;
    Function CreateRectangleElement(Left, Top, Right, Bottom: Integer): TMagAnnotationElement;
    Function CreateEllipseElement(Left, Top, Right, Bottom: Integer): TMagAnnotationElement;
    Function CreateTextElement(Left, Top, Right, Bottom: Integer; Data: String; Format: Integer): TMagAnnotationElement;

    Procedure CreateMarkElement(Element: TMagAnnotationElement); Virtual; Abstract;

    Function ParseLineElement(Element: TMagAnnotationElement; Var Left, Top, Right, Bottom: Integer): Boolean;
    Function ParsePolygonElement(Element: TMagAnnotationElement; Var Points: Tlist): Boolean;
    Function ParseRectangleElement(Element: TMagAnnotationElement; Var Left, Top, Right, Bottom: Integer): Boolean;
    Function ParseEllipseElement(Element: TMagAnnotationElement; Var Left, Top, Right, Bottom: Integer): Boolean;
    Function ParseTextElement(Element: TMagAnnotationElement; Var Left, Top, Right, Bottom: Integer; Var Data: String; Var Format: Integer): Boolean;

    Procedure SetAnnotationStyle(Value: TMagAnnotationStyle); Virtual;

  Public
    Constructor Create(AOwner: TComponent); Virtual; Abstract;
    Procedure SetFont(TheFontName: String; TheFontSize: Integer; IsBold: Boolean; IsItalic: Boolean); Virtual; Abstract;
    Procedure SetAnnotationColor(aColor: TColor); Virtual; Abstract;
    Procedure SetOpaque(IsOpaque: Boolean); Virtual; Abstract;
    Procedure SetAnnotationStyles(); Virtual; Abstract;
      //ArrowLength: longint; ArrowPointer : enumIGArtArrowType; FontName : string; FontSize : integer; isBold, isItalic, isOpaque: boolean; AnnotationColor : TColor; AnnotationLineWidth : integer);
    Procedure InitializeVariables(); Virtual; Abstract;
    Procedure Undo(); Virtual; Abstract;
    Procedure Cut(); Virtual; Abstract;
    Procedure Copy(); Virtual; Abstract;
    Procedure Paste(); Virtual; Abstract;
    Procedure SelectAll(); Virtual; Abstract;
    Procedure SetArrowPointer(aPointer: TMagAnnotationArrowType); Virtual; Abstract;
    Procedure SetArrowLength(ArrowLength: TMagAnnotationArrowSize); Virtual; Abstract;
    Procedure SetLineWidth(Width: TMagAnnotationLineWidth); Virtual; Abstract;
    Procedure SetTool(NewTool: TMagAnnotationToolType); Virtual; Abstract;

    Procedure ClearSelectedAnnotations(); Virtual; Abstract;
    Procedure ClearAllAnnotations(); Virtual; Abstract;
    Procedure ClearLastAnnotation(); Virtual; Abstract;

    Procedure MouseDownEvent(Button, x, y: Integer); Virtual; Abstract;
    Procedure MouseUpEvent(Button, x, y: Integer); Virtual; Abstract;

//    procedure EndUse();
    Function GetColor(): TColor; Virtual; Abstract;
    Function GetFont(): TFont; Virtual; Abstract;
    Procedure UnselectAllMarks(); Virtual; Abstract;
//    procedure SaveAnnotations(fName : String); virtual; abstract;
//    procedure LoadAnnotations(FName : String); virtual; abstract;

    Procedure LoadAnnotationData(Data: TStrings); Virtual; Abstract;
    Function GetAnnotationData(): TStrings; Virtual; Abstract;
    Function GetAnnotationState(): TMagAnnotationState; Virtual; Abstract;

    Procedure SaveAnnotationData(Filename: String);
    Procedure LoadAnnotations(Filename: String);
    Function GetMarkElements(): Tlist; Virtual; Abstract;
    Function GetMarkCount(): Integer; Virtual; Abstract;

    Procedure DrawText(Left, Right, Top, Bottom, Red, Green, Blue: Integer; Text: String; FontSize: Integer); Virtual; Abstract;
    Procedure EnableMeasurements(); Virtual; Abstract;

    Procedure RemoveOrientationLabel(); Virtual; Abstract;
    Procedure DisplayCurrentMarkProperties(); Virtual; Abstract;

    Property HasBeenModified: Boolean Read FHasBeenModified Write FHasBeenModified;
    Property OnMagAnnotationStyleChangeEvent: TMagAnnotationStyleChangeEvent Read MagAnnotationStyleChangeEvent Write MagAnnotationStyleChangeEvent;
    Property AnnotationStyle: TMagAnnotationStyle Read FAnnotationStyle Write SetAnnotationStyle;

  End;

Procedure Register;

Implementation
Uses
  Dialogs,
  SysUtils,
  Umagutils8,
  Variants,
  Xmldoc,
  Xmlintf
  ;

{$R *.dfm}

Procedure Register;
Begin
  RegisterComponents('Imaging', [TMagAnnotation]);
End;

Procedure TMagAnnotation.SaveAnnotationData(Filename: String);
Var
  Marks: Tlist;
  Xmldoc: TXMLDocument;
  i, j: Integer;
  Element: TMagAnnotationElement;
  Cood: TMagAnnotationCood;
  XNode, ElementNode, ElementsNode: IXMLNode;
  ElementType, CoodType: String;
Begin
  Marks := GetMarkElements();
  Xmldoc := TXMLDocument.Create(Self);
  Xmldoc.LoadFromXML('<PState />');
  Xmldoc.Active := True;
  ElementsNode := Xmldoc.DocumentElement.AddChild('Elements');

  For i := 0 To Marks.Count - 1 Do
  Begin
    Element := Marks.Items[i];
    ElementType := '';

    Case Element.ElementType Of
      MagAnnotationETangle: ElementType := 'angle';
      MagAnnotationETannot_ellipse: ElementType := 'annot_ellipse';
      MagAnnotationETannot_line: ElementType := 'annot_line';
      MagAnnotationETannot_polygon: ElementType := 'annot_polygon';
      MagAnnotationETannot_rect: ElementType := 'annot_rect';
      MagAnnotationETannot_text: ElementType := 'annot_text';
      MagAnnotationETharea: ElementType := 'harea';
      MagAnnotationETlength: ElementType := 'length';
    End;
    ElementNode := ElementsNode.AddChild('Element');
    ElementNode.SetAttributeNS('type', '', ElementType);
    For j := 0 To Element.Coods.Count - 1 Do
    Begin
      Cood := Element.Coods.Items[j];
      CoodType := '';
      Case Cood.CoodType Of
        MagAnnotationCTempty: CoodType := '';
        MagAnnotationCTline: CoodType := 'line';
        MagAnnotationCTline1: CoodType := 'line';
        MagAnnotationCTline2: CoodType := 'line';
        MagAnnotationCTrect: CoodType := 'rect';
        MagAnnotationCTtext: CoodType := 'text';
      End; {case}
      XNode := ElementNode.AddChild('Coods');
      XNode.NodeValue := Cood.Data;
      If CoodType <> '' Then
        XNode.SetAttributeNS('type', '', CoodType);
    End; {for}
    If Element.Data <> '' Then
    Begin
      XNode := ElementNode.AddChild('Data');
      XNode.NodeValue := Element.Data;
    End;
    If Element.Format <> '' Then
    Begin
      XNode := ElementNode.AddChild('Format');
      XNode.NodeValue := Element.Format;
    End;
  End;
  Xmldoc.SaveToFile(Filename);
//  showmessage(inttostr(marks.Count));
End;

Procedure TMagAnnotation.LoadAnnotations(Filename: String);
Var
  Xmldoc: TXMLDocument;
  Element: TMagAnnotationElement;
  Cood: TMagAnnotationCood;
  StartItemNode, aNode, ElementNode: IXMLNode;
  ElementType, ElementItem, ElementText: String;
Begin
  Xmldoc := TXMLDocument.Create(Self);
  Xmldoc.Filename := Filename;
  Xmldoc.Active := True;

  StartItemNode := Xmldoc.DocumentElement.ChildNodes.FindNode('Elements');
  aNode := StartItemNode.ChildNodes.FindNode('Element');
  Repeat
    ElementType := aNode.Attributes['type'];
    Element := TMagAnnotationElement.Create();
    Element.Coods := Tlist.Create();
    Element.ElementType := GetElementTypeValue(ElementType);
    ElementNode := aNode.ChildNodes.First;
    Repeat
      ElementItem := ElementNode.NodeName;
      ElementText := ElementNode.Text;
      If ElementItem = 'Coods' Then
      Begin
        Cood := TMagAnnotationCood.Create();
        If ElementNode.Attributes['type'] <> Null Then
          Cood.CoodType := GetCoodTypeValue(ElementNode.Attributes['type']);
        Cood.Data := ElementText;
        Element.Coods.Add(Cood);
      End
      Else
        If ElementItem = 'Length' Then
          Element.Length := ElementText
        Else
          If ElementItem = 'Angle' Then
            Element.Angle := ElementText
          Else
            If ElementItem = 'Data' Then
              Element.Data := ElementText
            Else
              If ElementItem = 'Points' Then
                Element.Points := ElementText;

      ElementNode := ElementNode.NextSibling;
    Until ElementNode = Nil;
    CreateMarkElement(Element);
    aNode := aNode.NextSibling;
  Until aNode = Nil;
End;

Function TMagAnnotation.GetCoodTypeValue(CoodType: String): TMagAnnotationCoodType;
Begin
  If CoodType = '' Then
    Result := MagAnnotationCTempty
  Else
    If CoodType = 'text' Then
      Result := MagAnnotationCTtext
    Else
      If CoodType = 'line' Then
        Result := MagAnnotationCTline
      Else
        If CoodType = 'line1' Then
          Result := MagAnnotationCTline1
        Else
          If CoodType = 'line2' Then
            Result := MagAnnotationCTline2
          Else
            If CoodType = 'rect' Then
              Result := MagAnnotationCTrect
            Else
              If CoodType = 'text' Then
                Result := MagAnnotationCTtext;

End;

Function TMagAnnotation.GetElementTypeString(ElementType: TMagAnnotationElementType): String;
Begin
  Case ElementType Of
    MagAnnotationETangle: Result := 'angle';
    MagAnnotationETannot_ellipse: Result := 'annot_ellipse';
    MagAnnotationETannot_line: Result := 'annot_line';
    MagAnnotationETannot_polygon: Result := 'annot_polygon';
    MagAnnotationETannot_rect: Result := 'annot_rect';
    MagAnnotationETannot_text: Result := 'annot_text';
    MagAnnotationETharea: Result := 'harea';
    MagAnnotationETlength: Result := 'length';
  End;
End;

Function TMagAnnotation.GetElementTypeValue(ElementType: String): TMagAnnotationElementType;
Begin
  If ElementType = 'angle' Then
    Result := MagAnnotationETangle
  Else
    If ElementType = 'annot_ellipse' Then
      Result := MagAnnotationETannot_ellipse
    Else
      If ElementType = 'annot_line' Then
        Result := MagAnnotationETannot_line
      Else
        If ElementType = 'annot_polygon' Then
          Result := MagAnnotationETannot_polygon
        Else
          If ElementType = 'annot_rect' Then
            Result := MagAnnotationETannot_rect
          Else
            If ElementType = 'annot_text' Then
              Result := MagAnnotationETannot_text
            Else
              If ElementType = 'harea' Then
                Result := MagAnnotationETharea
              Else
                If ElementType = 'length' Then
                  Result := MagAnnotationETlength;
End;

Function TMagAnnotation.CreateBaseElement(Left, Top, Right, Bottom: Integer): TMagAnnotationElement;
Var
  Cood: TMagAnnotationCood;
Begin
  Result := TMagAnnotationElement.Create();
  Cood := TMagAnnotationCood.Create();
  Cood.CoodType := MagAnnotationCTempty;
  Cood.Data := '2:' + Inttostr(Left) + ',' + Inttostr(Top) + ',' + Inttostr(Right) + ',' + Inttostr(Bottom);
  Result.Coods := Tlist.Create();
  Result.Coods.Add(Cood);
End;

Function TMagAnnotation.CreateLineElement(Left, Top, Right, Bottom: Integer): TMagAnnotationElement;
Begin
  Result := CreateBaseElement(Left, Top, Right, Bottom);
  Result.ElementType := MagAnnotationETannot_line;
End;

Function TMagAnnotation.CreatePolygonElement(Points: Tlist): TMagAnnotationElement;
Var
  Cood: TMagAnnotationCood;
  i: Integer;
  Point: TMagAnnotationPoint;
  PreChar: String;
Begin
  Result := TMagAnnotationElement.Create();
  Result.ElementType := MagAnnotationETannot_polygon;
  Cood := TMagAnnotationCood.Create();
  Cood.CoodType := MagAnnotationCTempty;
  Cood.Data := Inttostr(Points.Count);
  PreChar := ':';
  For i := 0 To Points.Count - 1 Do
  Begin
    Point := Points.Items[i];
    Cood.Data := Cood.Data + PreChar + Inttostr(Point.x) + ',' + Inttostr(Point.y);
    PreChar := ',';
  End;
  Result.Coods := Tlist.Create();
  Result.Coods.Add(Cood);
End;

Function TMagAnnotation.CreateRectangleElement(Left, Top, Right, Bottom: Integer): TMagAnnotationElement;
Begin
  Result := CreateBaseElement(Left, Top, Right, Bottom);
  Result.ElementType := MagAnnotationETannot_rect;
End;

Function TMagAnnotation.CreateEllipseElement(Left, Top, Right, Bottom: Integer): TMagAnnotationElement;
Begin
  Result := CreateBaseElement(Left, Top, Right, Bottom);
  Result.ElementType := MagAnnotationETannot_ellipse;
End;

Function TMagAnnotation.CreateTextElement(Left, Top, Right, Bottom: Integer; Data: String; Format: Integer): TMagAnnotationElement;
Begin
  Result := CreateBaseElement(Left, Top, Right, Bottom);
  Result.ElementType := MagAnnotationETannot_text;
  Result.Data := Data;
  Result.Format := Inttostr(Format);
End;

Function TMagAnnotation.ParseBaseElement(Element: TMagAnnotationElement; Var Left, Top, Right, Bottom: Integer): Boolean;
Var
  Locations: String;
  Cood: TMagAnnotationCood;
Begin
  Result := False;
  If Element.Coods.Count < 1 Then Exit;
  Cood := Element.Coods.Items[0];
  Locations := MagPiece(Cood.Data, ':', 2);
  Try
    Left := Strtoint(MagPiece(Locations, ',', 1));
    Top := Strtoint(MagPiece(Locations, ',', 2));
    Right := Strtoint(MagPiece(Locations, ',', 3));
    Bottom := Strtoint(MagPiece(Locations, ',', 4));
  Except
    On e: Exception Do
    Begin
      Showmessage(e.Message);
      Exit;
      // log this exception instead of outputting it
    End;
  End;
  Result := True;
End;

Function TMagAnnotation.ParseLineElement(Element: TMagAnnotationElement; Var Left, Top, Right, Bottom: Integer): Boolean;
Begin
  Result := ParseBaseElement(Element, Left, Top, Right, Bottom);
End;

Function TMagAnnotation.ParsePolygonElement(Element: TMagAnnotationElement; Var Points: Tlist): Boolean;
Var
  PointCount, i: Integer;
  PointData: String;
  Cood: TMagAnnotationCood;
  Point: TMagAnnotationPoint;
Begin
  Result := False;
  If Points = Nil Then Points := Tlist.Create();
  If Element.Coods.Count < 1 Then Exit;
  Try
    Cood := Element.Coods.Items[0];
    PointCount := Strtoint(MagPiece(Cood.Data, ':', 1));
    PointData := MagPiece(Cood.Data, ':', 2);
    For i := 1 To PointCount Do
    Begin
      Point := TMagAnnotationPoint.Create();
      Point.x := Strtoint(MagPiece(PointData, ',', (i + (i - 1))));
      Point.y := Strtoint(MagPiece(PointData, ',', (i * 2)));
      Points.Add(Point);
    End;
  Except
    On e: Exception Do
    Begin
      Showmessage(e.Message);
      Exit;
      // log message, don't display error message
    End;
  End;
End;

Function TMagAnnotation.ParseRectangleElement(Element: TMagAnnotationElement; Var Left, Top, Right, Bottom: Integer): Boolean;
Begin
  Result := ParseBaseElement(Element, Left, Top, Right, Bottom);
End;

Function TMagAnnotation.ParseEllipseElement(Element: TMagAnnotationElement; Var Left, Top, Right, Bottom: Integer): Boolean;
Begin
  Result := ParseBaseElement(Element, Left, Top, Right, Bottom);
End;

Function TMagAnnotation.ParseTextElement(Element: TMagAnnotationElement; Var Left, Top, Right, Bottom: Integer; Var Data: String; Var Format: Integer): Boolean;
Begin
  Result := ParseBaseElement(Element, Left, Top, Right, Bottom);
  Data := Element.Data;
  If Element.Format = '' Then
    Format := -1
  Else
    Format := Strtoint(Element.Format);
End;

Procedure TMagAnnotation.SetAnnotationStyle(Value: TMagAnnotationStyle);
Begin
  FAnnotationStyle := Value;
End;

End.
