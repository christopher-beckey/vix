unit uMagAnnotDisplayRAD;
   {
   Package: MAG - VistA Imaging
   WARNING: Per VHA Directive 10-93-142 this unit should not be modified.
   Date Created:   August 2011
   Site Name: Silver Spring, OIFO
   Developers: Duc MM Nguyen
   [==     unit uMagDisplayRAD;
   This unit will handle the conversion and display annotation created from VistA
   RAD to Clinical Display RAD Viewer
    ==]
   Note:
   8/2/2011 - this unit is orginally created for p122 annotations

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

interface

uses
  // Accusoft
  GearCORELib_TLB, GearDISPLAYLib_TLB, GearPROCESSINGLib_TLB, GearVIEWLib_TLB,
  GearArtXGUILib_TLB, GearArtXLib_TLB,

  // VistA
  cMagIGManager, cMagAnnotXMLControlsDisplay, uMagDefinitions,

  imaginterfaces,
  uMagAnnotRADConverters,
  fMagAnnotationOptionsX, // RCA put this here instead of umagdefinitions.

  // Delphi
  SysUtils, Classes, Graphics, Dialogs;

  Procedure LoadRADAnnotation(var XMLCtl : TXMLCtl; radXML : string);
//  procedure ConvertRADAnnotations(StrictConversion : string; ArtPage : IIGArtXPage; var XMLCtl : TXMLCtl; XFact,YFact : double);
  Function ConvertRADAnnotations(StrictConversion : string; ArtPage : IIGArtXPage; var XMLCtl : TXMLCtl; XFact,YFact : double) : integer;
//  Procedure ConvertRADElementType17(ArtPage : IIGArtXPage; radNode: IXMLNode);
//  procedure ConvertRADElementType18(ArtPage : IIGArtXPage; radNode: IXMLNode);
//  Procedure ConvertRADElementType19(ArtPage : IIGArtXPage; radNode: IXMLNode);
//  Procedure ConvertRADElementType20(ArtPage : IIGArtXPage; radNode: IXMLNode);
//  Procedure ConvertRADElementType21(ArtPage : IIGArtXPage; radNode: IXMLNode);
//  Procedure ConvertRADElementType23(ArtPage : IIGArtXPage; radNode: IXMLNode);
//  Procedure ConvertRADElementType24(ArtPage : IIGArtXPage; radNode: IXMLNode);
//  Procedure ConvertRADElementType25(ArtPage : IIGArtXPage; radNode: IXMLNode);
//  Procedure ConvertRADElementType27(ArtPage : IIGArtXPage; radNode: IXMLNode);
//  Procedure ConvertRADElementType28(ArtPage : IIGArtXPage; radNode: IXMLNode);
//  Procedure ConvertRADElementType29(ArtPage : IIGArtXPage; radNode: IXMLNode);
//  Procedure ConvertRADElementType31(ArtPage : IIGArtXPage; radNode: IXMLNode);
//  Procedure ConvertRADElementType32(ArtPage : IIGArtXPage; radNode: IXMLNode);

  Procedure ConvertRADElementType17(ArtPage : IIGArtXPage; radNode : TRADElement);
  procedure ConvertRADElementType18(ArtPage : IIGArtXPage; radNode : TRADElement);
  Procedure ConvertRADElementType19(ArtPage : IIGArtXPage; radNode : TRADElement);
  Procedure ConvertRADElementType20(ArtPage : IIGArtXPage; radNode : TRADElement);
  Procedure ConvertRADElementType21(ArtPage : IIGArtXPage; radNode : TRADElement);
  Procedure ConvertRADElementType23(ArtPage : IIGArtXPage; radNode : TRADElement);
  Procedure ConvertRADElementType24(ArtPage : IIGArtXPage; radNode : TRADElement);
  Procedure ConvertRADElementType25(ArtPage : IIGArtXPage; radNode : TRADElement);
  Procedure ConvertRADElementType27(ArtPage : IIGArtXPage; radNode : TRADElement);
  Procedure ConvertRADElementType28(ArtPage : IIGArtXPage; radNode : TRADElement);
  Procedure ConvertRADElementType29(ArtPage : IIGArtXPage; radNode : TRADElement);
  Procedure ConvertRADElementType31(ArtPage : IIGArtXPage; radNode : TRADElement);
  Procedure ConvertRADElementType32(ArtPage : IIGArtXPage; radNode : TRADElement);

  function ConvertRADPoints(pointString: string): IIGPointArray;
  function ScaleRADPoint(inPointArr: IIGPointArray) : IIGPointArray;
  function GetClosestPointOnRectangle(anchorPoint : IIGPoint; igRect : IIGRectangle) : IIGPoint;
  function GetClosestPoint(anchorPoint: IIGPoint; pointArr: IIGPointArray): IIGPoint;
  function GetDistance(StartPoint,EndPoint : IIGPoint) : integer;
  function GetPointsFromString(pointString: string): IIGPointArray; //p122 8/4
  procedure GetTextBounds(radText : string; var w,h : integer);

  // Drawing tools
  Procedure DrawStraightLine(var ArtPage : IIGArtXPage; StartPoint,EndPoint : IIGPoint; uid : string; dash : boolean);
  function DrawRADText(var ArtPage : IIGArtXPage; text, uid: string; igrect : IIGRectangle; border : IIGArtXBorder) : IIGRectangle;
  function ConvertRADTextDegree(radText: string): string;
  procedure DrawArrow(ArtPage : IIGArtXPage; StartPoint,EndPoint: IIGPoint; uid: string);
  Procedure DrawRectangle(ArtPage : IIGArtXPage; StartPoint, EndPoint: IIGPoint; uid: string);
  procedure DrawFreeline(ArtPage : IIGArtXPage; pointArray : IIGPointArray; uid: string);  //p122 8/4
  
implementation

var
  FRADOpacity : Integer;
  FRADColor : TColor;
  FRADFontName : string;
  FRADFontStyle : Integer;
  FRADFontSize : Integer;
  FRADLineWidth : Integer;

  FRADFont : IIGArtXFont;
  FRADPixelColor : IIGPixel;  //p122 dmmn 8/9 - for normal shapes
  FRADPixelColor2 : IIGPixel; //p122 dmmn 8/8 - for odd shapes
  XFactor : double;
  YFactor : double;

  StrictConvert : boolean;
  oddShape : boolean;

  FRADIGcount : integer; //p122t3 dmmn 9/15 - this will keep track of how many IGmarks are created to map VistaRAD annotations

Procedure LoadRADAnnotation(var XMLCtl : TXMLCtl; radXML : string);
var
  r,g,b : integer;
begin
  // load the radiology annotation xml in
  XMLCtl.LoadRADAnnotation(radXML);

  // initialize the annotation settings;
  FRADOpacity := 255;
  FRADLineWidth := 1;
  FRADColor := clWhite;
  FRADFontName := magAnnotationFont; // 'Arial';
  FRADFontStyle := 0;
  FRADFontSize := 20;

  FRADFont := GetIGManager.IGArtXCtl.CreateObject(IG_ARTX_OBJ_FONT) as IIGArtXFont;
  FRADFont.Size := FRADFontSize;
  FRADFont.Style := FRADFontStyle;
  FRADFont.Name := FRADFontName;
  FRADFont.DisablePPM := false;
//  FRADFont.DisablePPM := True;

  // lime for normal shapes
  FRADPixelColor := GetIGManager.IGCoreCtrl.CreateObject(IG_OBJ_PIXEL) As IIGPixel;
  FRADPixelColor.ChangeType(IG_PIXEL_RGB);
  frmAnnotOptionsX.AnnotColorToRGB(clLime,r,g,b);
  // RCA  OUT AnnotationOptionsX.AnnotColorToRGB(clLime,r,g,b);
  FRADPixelColor.RGB_R := r;
  FRADPixelColor.RGB_G := g;
  FRADPixelColor.RGB_B := b;

  // yellow for odd shapes
  FRADPixelColor2 := GetIGManager.IGCoreCtrl.CreateObject(IG_OBJ_PIXEL) As IIGPixel;
  FRADPixelColor2.ChangeType(IG_PIXEL_RGB);
  frmAnnotOptionsX.AnnotColorToRGB(clLime,r,g,b);
//RCA  OUT AnnotationOptionsX.AnnotColorToRGB(clYellow,r,g,b);
  FRADPixelColor2.RGB_R := r;
  FRADPixelColor2.RGB_G := g;
  FRADPixelColor2.RGB_B := b;

  XFactor := 1.0;
  YFactor := 1.0;

  StrictConvert := false;
  oddshape := false;
end;

//procedure ConvertRADAnnotations(StrictConversion : string; ArtPage : IIGArtXPage; var XMLCtl : TXMLCtl; XFact,YFact : double);
function ConvertRADAnnotations(StrictConversion : string; ArtPage : IIGArtXPage; var XMLCtl : TXMLCtl; XFact,YFact : double) : integer;
var
  I: Integer;
  ArtPage2 : IIGArtXPage;
begin
  try
    // check the scaling factor
    if XFactor <> XFact then
      XFactor := XFact;
    if YFactor <> YFact then
      YFactor := YFact;

    // convert all or some marks
    if StrictConversion = '1' then
      StrictConvert := True
    else
      StrictConvert := False;

    ArtPage.RemoveMarks;
    ArtPage.SetAttr(IG_ARTX_ATTR_PAGE_SHADOW_FONTS, 1);
//    ArtPage.SetAttr(IG_ARTX_ATTR_PAGE_DISABLE_PPM_FOR_FONTS, 1);

//    ArtPage2 := GetIGManager.IGArtXCtl.CreatePage;
//
    ArtPage.SetCoordType(IG_ARTX_COORD_IMAGE );

    FRADIGcount := 0;
    for I := 0 to XMLCtl.RADelems.Count - 1 do
    begin
        case StrToInt(XMLCtl.RADelems.Items[I].RADElementType) of
        17:
            ConvertRADElementType17(ArtPage, XMLCtl.RADelems.Items[I]);     // ruler
        18:
          ConvertRADElementType18(ArtPage, XMLCtl.RADelems.Items[I]);       // houndsfield ellipse
        19:
          ConvertRADElementType19(ArtPage, XMLCtl.RADelems.Items[I]);       // protractor
        20:
          ConvertRADElementType20(ArtPage, XMLCtl.RADelems.Items[I]);     // houndsfield freehand
        21:
          ConvertRADElementType21(ArtPage, XMLCtl.RADelems.Items[I]);       // houndsfield rectangle
        23:
          ConvertRADElementType23(ArtPage, XMLCtl.RADelems.Items[I]);       // text
        24:
          ConvertRADElementType24(ArtPage, XMLCtl.RADelems.Items[I]);       // arrow
        25:
          ConvertRADElementType25(ArtPage, XMLCtl.RADelems.Items[I]);       // automatic text
        27:
          ConvertRADElementType27(ArtPage, XMLCtl.RADelems.Items[I]);       // line
        28:
          ConvertRADElementType28(ArtPage, XMLCtl.RADelems.Items[I]);       // rectangle
        29:
          ConvertRADElementType29(ArtPage, XMLCtl.RADelems.Items[I]);       // ellipse
        31:
          ConvertRADElementType31(ArtPage, XMLCtl.RADelems.Items[I]);     // freehand
        32:
          ConvertRADElementType32(ArtPage, XMLCtl.RADelems.Items[I]);       // cobb angle
      end;
    end;
  Result := FRADIGcount;
  except
    on E:Exception do
      Showmessage('ConvertRADAnnotations: ' + e.message);
  end;
end;

Procedure ConvertRADElementType17(ArtPage : IIGArtXPage; radNode : TRADElement);
var
  pointArray : IIGPointArray;
  radText : string;
  igrect : IGRectangle;
begin
  {/p122 dmmn 8/1 - converting RAD ruler /}
  oddshape := false;

  // generate a list of points
  pointArray := ConvertRADPoints(radNode.RADElementPoints);

  // scale the point if not full res
  if (XFactor <> 1) or (YFactor <> 1) then
    pointArray := ScaleRADPoint(pointArray);

  // make combination of 1 solid line, 1 dash line, 1 text
  DrawStraightLine(ArtPage,
                   pointArray.GetItemCopy(0),
                   pointArray.GetItemCopy(1),
                   '',
                   false);

  // generate boundary
  igrect := GetIGManager.IGCoreCtrl.CreateObject(IG_OBJ_RECTANGLE) As IIGRectangle;
  igrect.Top := pointArray.YPos[3] - Round(25*YFactor);
  igrect.Left := pointArray.XPos[3] - Round(100*XFactor);
  igrect.Right := pointArray.XPos[3] + Round(100*XFactor);
  igrect.Bottom := pointArray.YPos[3] + Round(25*YFactor);

  radText := radNode.RADElementText;
  igrect := DrawRADText(ArtPage,
                        radText,                            // text
                        '',
                        igrect,                          // boudary
                        nil);                            // border

  // connector line
  DrawStraightLine(ArtPage,
                   pointArray.GetItemCopy(2),
                   GetClosestPointOnRectangle(pointArray.GetItemCopy(2),igrect),
                   '',
                   true);
end;

Procedure ConvertRADElementType18(ArtPage : IIGArtXPage; radNode : TRADElement);
var
  pointArray : IIGPointArray;
  igrect : IGRectangle;
  I : Integer;
  textPoint : IIGPoint;
  conPt1, conPt2 : IIGPoint;
  inArr : TPoints;
  newPoints : string;
  radText : string;
  textW, textH : Integer;
begin
  {/p122 dmmn 8/4 - converting RAD houndsfield ellipse /}
  oddshape := true;

  // generate a list of points
  pointArray := ConvertRADPoints(radNode.RADElementPoints);

  // scale the point if not full res
  if (XFactor <> 1) or (YFactor <> 1) then
    pointArray := ScaleRADPoint(pointArray);

  // ellispe, dashline, text

  // text part
  // generate boundary
  radText := radNode.RADElementText;
  GetTextBounds(radText,textW,textH);

  igrect := GetIGmanager.IGCoreCtrl.CreateObject(IG_OBJ_RECTANGLE) As IGRectangle;
  //p122t12 dmmn - switch back to use a solid size for text box instead of
  //rendered size because the calculation is not perfect
  igrect.Top := pointArray.YPos[5]-Round(10*YFactor);
  igrect.Left := pointArray.XPos[5]-Round(5*XFactor);
  igrect.Right := pointArray.XPos[5]+Round(5*XFactor);
  igrect.Bottom := pointArray.YPos[5]+Round(10*YFactor);
//  igrect.Top := pointArray.YPos[5]-Round(textH/2);
//  igrect.Left := pointArray.XPos[5]-Round(textW/2);
//  igrect.Right := pointArray.XPos[5]+Round(textW/2);
//  igrect.Bottom := pointArray.YPos[5]+Round(textH/2);

  textPoint := pointArray.GetItemCopy(5);

  igrect := DrawRADText(ArtPage,
                        radText,
                        '',
                        igrect,
                        nil);

  // ellipse part
  SetLength(inArr,5);
  inArr[0].X := pointArray.XPos[0];
  inArr[0].Y := pointArray.YPos[0];
  inArr[1].X := pointArray.XPos[1];
  inArr[1].Y := pointArray.YPos[1];
  inArr[2].X := pointArray.XPos[2];
  inArr[2].Y := pointArray.YPos[2];
  inArr[3].X := pointArray.XPos[3];
  inArr[3].Y := pointArray.YPos[3];
  inArr[4].X := pointArray.XPos[4];
  inArr[4].Y := pointArray.YPos[4];

  newPoints := ConvertRADEllipse(inArr);
  pointArray.Resize(0);
  pointArray := GetPointsFromString(newPoints);

  // make a freehand
  DrawFreeline(ArtPage,
               pointArray,
               '');

  // dash line connector
  conPt1 := GetClosestPoint(textPoint,pointArray);
  conPt2 := GetClosestPointOnRectangle(conPt1,igRect);
  DrawStraightLine(ArtPage,
                   conPt1,
                   conPt2,
                   '',
                   true);

end;

Procedure ConvertRADElementType19(ArtPage : IIGArtXPage; radNode : TRADElement);
var
  pointArray : IIGPointArray;
  radText : string;
  igrect : IIGRectangle;
begin
  {/p122 dmmn 8/3 - converting RAD protractor /}
  oddshape := false;
  // generate a list of points
  pointArray := ConvertRADPoints(radNode.RADElementPoints);

  // scale the point if not full res
  if (XFactor <> 1) or (YFactor <> 1) then
    pointArray := ScaleRADPoint(pointArray);

  // make a combination of 2 solid line, 1 dash line, 1 text
  DrawStraightLine(ArtPage,
                   pointArray.GetItemCopy(0),
                   pointArray.GetItemCopy(1),
                    '',
                   false);

  DrawStraightLine(ArtPage,
                   pointArray.GetItemCopy(0),
                   pointArray.GetItemCopy(2),
                   '',
                   false);


  // generate boundary
  igrect := GetIGManager.IGCoreCtrl.CreateObject(IG_OBJ_RECTANGLE) As IGRectangle;
  igrect.Top := pointArray.YPos[4] - Round(25*YFactor);
  igrect.Left := pointArray.XPos[4] - Round(100*XFactor);
  igrect.Right := pointArray.XPos[4] + Round(100*XFactor);
  igrect.Bottom := pointArray.YPos[4] + Round(25*YFactor);

  radText := radNode.RADElementText;
  radText := ConvertRADTextDegree(radText);

  DrawRADText(ArtPage,
              radText,
              '',
              igrect,
              nil);

  DrawStraightLine(ArtPage,
                   pointArray.GetItemCopy(3),
                   GetClosestPointOnRectangle(pointArray.GetItemCopy(3),igRect),
                   '',
                   true);
end;

Procedure ConvertRADElementType20(ArtPage : IIGArtXPage; radNode : TRADElement);
var
  pointArray : IIGPointArray;
  freelinePtArr : IIGPointArray;
  igrect : IGRectangle;
  I : Integer;
  textPoint : IIGPoint;
  conPt1, conpt2 : IIGPoint;
  radText : string;
  inArr : TPoints;
  newPoints : string;
  textW,textH : integer;
begin
  {/p122 dmmn 8/3 - converting RAD houndsfield freehand /}
  oddshape := true;

  // generate a list of points
  pointArray := ConvertRADPoints(radNode.RADElementPoints);

  // scale the point if not full res
  if (XFactor <> 1) or (YFactor <> 1) then
    pointArray := ScaleRADPoint(pointArray);

  // freehand, dashline, text
  // text part
  // generate boundary
  radText := radNode.RADElementText;
//  GetTextBounds(radText,textW,textH);

  textPoint := pointArray.GetItemCopy(0);
  igrect := GetIGManager.IGCoreCtrl.CreateObject(IG_OBJ_RECTANGLE) As IGRectangle;
  //p122t12 dmmn - switch back to use a solid size for text box instead of
  //rendered size because the calculation is not perfect
  igrect.Top := pointArray.YPos[0]-Round(10*YFactor);
  igrect.Left := pointArray.XPos[0]-Round(5*XFactor);
  igrect.Right := pointArray.XPos[0]+Round(5*XFactor);
  igrect.Bottom := pointArray.YPos[0]+Round(10*YFactor);
//  igrect.Top := pointArray.YPos[0]-Round(textH/2);
//  igrect.Left := pointArray.XPos[0]-Round(textW/2);
//  igrect.Right := pointArray.XPos[0]+Round(textW/2);
//  igrect.Bottom := pointArray.YPos[0]+Round(textH/2);

  radText := radNode.RADElementText;
  igrect := DrawRADText(ArtPage,
                        radText,
                        '',
                        igrect,
                        nil);

  SetLength(inArr,pointArray.Size-1);
  for I := 0 to pointArray.Size - 2 do
  begin
    inArr[I].X := pointArray.XPos[I+1];
    inArr[I].Y := pointArray.YPos[I+1];
  end;

  newPoints := ConvertRADFreeHand(inArr);
  pointArray.Resize(0);
  pointArray := GetPointsFromString(newPoints);

  // make a freehand
  DrawFreeline(ArtPage,
               pointArray,
               '');

  // dash line connector
  conPt1 := GetClosestPoint(textPoint,pointArray);
  conPt2 := GetClosestPointOnRectangle(conPt1, igRect);
  DrawStraightLine(ArtPage,
                   conPt1,
                   conPt2,
                   '',
                   true);
end;

Procedure ConvertRADElementType21(ArtPage : IIGArtXPage; radNode: TRADElement);
var
  pointArray : IIGPointArray;
  rectPtArray : IIGPointArray;
  igrect : IGRectangle;
  I : Integer;
  textPoint : IIGPoint;
  conPt1, conpt2 : IIGPoint;
  tp0,tp1,tp2,tp3 : IIGPoint;
  connectPt1, connectPt2 : IIGPoint;
  radText : string;
//  textW,textH : integer;
begin
  {/p122 dmmn 8/3 - converting RAD houndsfield rectangle /}
  oddshape := false;

  // generate a list of points
    pointArray := ConvertRADPoints(radNode.RADElementPoints);

  // scale the point if not full res
  if (XFactor <> 1) or (YFactor <> 1) then
    pointArray := ScaleRADPoint(pointArray);

  // make 1 rectangle, 1 dash line, and 1 text box

  // rect
  tp0 := GetIGManager.IGCoreCtrl.CreateObject(IG_OBJ_POINT) As IIGPoint;
  tp1 := GetIGManager.IGCoreCtrl.CreateObject(IG_OBJ_POINT) As IIGPoint;
  tp2 := GetIGManager.IGCoreCtrl.CreateObject(IG_OBJ_POINT) As IIGPoint;
  tp3 := GetIGManager.IGCoreCtrl.CreateObject(IG_OBJ_POINT) As IIGPoint;

  tp0 := pointArray.GetItemCopy(0);
  tp3 := pointArray.GetItemCopy(1);
  tp1.XPos := pointArray.XPos[1];
  tp1.YPos := pointArray.YPos[0];
  tp2.XPos := pointArray.XPos[0];
  tp2.YPos := pointArray.YPos[1];

  DrawRectangle(ArtPage,
                pointArray.GetItemCopy(0),
                pointArray.GetItemCopy(1),
                '');

  rectPtArray :=  TIGPointArray.Create(nil).DefaultInterface;
  rectPtArray.Resize(4);
  rectPtArray.UpdateItemFrom(0,tp0);
  rectPtArray.UpdateItemFrom(1,tp1);
  rectPtArray.UpdateItemFrom(2,tp2);
  rectPtArray.UpdateItemFrom(3,tp3);


  // text part
  // generate boundary
  radText := radNode.RADElementText;
//  GetTextBounds(radText,textW,textH);
  textPoint := pointArray.GetItemCopy(2);
  igrect := GetIGManager.IGCoreCtrl.CreateObject(IG_OBJ_RECTANGLE) As IGRectangle;
  //p122t12 dmmn - switch back to use a solid size for text box instead of
  //rendered size because the calculation is not perfect
  igrect.Top := pointArray.YPos[2]-Round(10*YFactor);
  igrect.Left := pointArray.XPos[2]-Round(5*XFactor);
  igrect.Right := pointArray.XPos[2]+Round(5*XFactor);
  igrect.Bottom := pointArray.YPos[2]+Round(10*YFactor);
//  igrect.Top := pointArray.YPos[2]-Round(textH/2);
//  igrect.Left := pointArray.XPos[2]-Round(textW/2);
//  igrect.Right := pointArray.XPos[2]+Round(textW/2);
//  igrect.Bottom := pointArray.YPos[2]+Round(textH/2);



  // make a text
  igrect := DrawRADText(ArtPage,
                        radText,
                        '',
                        igrect,
                        nil);

  // dash line connector
  conPt1 := GetClosestPoint(textPoint,rectPtArray);
  conPt2 := GetClosestPointOnRectangle(conPt1, igRect);
  DrawStraightLine(ArtPage,
                   conPt1,
                   conPt2,
                   '',true);
end;

Procedure ConvertRADElementType23(ArtPage : IIGArtXPage; radNode: TRADElement);
var
  pointArray : IIGPointArray;
  igrect : IGRectangle;
  Border : IIGArtXBorder;
  I: Integer;
  radText : string;
begin
  {/p122 dmmn 8/3 - converting RAD text /}
   oddshape := false;

  // generate a list of points
  pointArray := ConvertRADPoints(radNode.RADElementPoints);

  // scale the point if not full res
  if (XFactor <> 1) or (YFactor <> 1) then
    pointArray := ScaleRADPoint(pointArray);

  // generate boundary
  radText := radNode.RADElementText;
  igrect := GetIGManager.IGCoreCtrl.CreateObject(IG_OBJ_RECTANGLE) As IGRectangle;
  igrect.Top := pointArray.YPos[0];
  igrect.Left := pointArray.XPos[0];
  igrect.Right := pointArray.XPos[1];
  igrect.Bottom := pointArray.YPos[1];


  // make a text
  DrawRADText(ArtPage,
              radText,
              '',
              igrect,
              nil);
end;

Procedure ConvertRADElementType24(ArtPage : IIGArtXPage; radNode: TRADElement);
var
  pointArray : IIGPointArray;
begin
  {/p122 dmmn 8/3 - converting RAD arrow /}
  oddshape := false;

  // generate a list of points
  pointArray := ConvertRADPoints(radNode.RADElementPoints);

  // scale the point if not full res
  if (XFactor <> 1) or (YFactor <> 1) then
    pointArray := ScaleRADPoint(pointArray);

  // make an arrow with solid head
  DrawArrow(ArtPage,
            pointArray.GetItemCopy(0),
            pointArray.GetItemCopy(1),
            '');
end;

Procedure ConvertRADElementType25(ArtPage : IIGArtXPage; radNode: TRADElement);
var
  pointArray : IIGPointArray;
  text : string;
  igrect : IIGRectangle;
//  textW, textH : integer;
begin
  {/p122 dmmn 8/3 - converting RAD automatic text label /}
   oddshape := false;

  // generate a list of points
  pointArray := ConvertRADPoints(radNode.RADElementPoints);

  // scale the point if not full res
  if (XFactor <> 1) or (YFactor <> 1) then
    pointArray := ScaleRADPoint(pointArray);

  // generate boundary
  text := radNode.RADElementText;
//  GetTextBounds(text,textW,textH);

  igrect := GetIGManager.IGCoreCtrl.CreateObject(IG_OBJ_RECTANGLE) As IGRectangle;
  // p122t12 dmmn - better way to calculate location of the text
  igrect.Top := pointArray.YPos[0]-Round(10*YFactor);
  igrect.Left := pointArray.XPos[0]-Round(10*XFactor);
  igrect.Right := pointArray.XPos[0]+Round(10*XFactor);
  igrect.Bottom := pointArray.YPos[0]+Round(10*YFactor);
//  igrect.Top := pointArray.YPos[0]-Round(textH/2);
//  igrect.Left := pointArray.XPos[0]-Round(textW/2);
//  igrect.Right := pointArray.XPos[0]+Round(textW/2);
//  igrect.Bottom := pointArray.YPos[0]+Round(textH/2);


  // make a text
  DrawRADText(ArtPage,
              text,
              '',
              igrect,
              nil);
end;

Procedure ConvertRADElementType27(ArtPage : IIGArtXPage; radNode: TRADElement);
var
  pointArray : IIGPointArray;
begin
  {/p122 dmmn 8/3 - converting RAD line /}
   oddshape := false;

  // generate a list of points
  pointArray := ConvertRADPoints(radNode.RADElementPoints);

  // scale the point if not full res
  if (XFactor <> 1) or (YFactor <> 1) then
    pointArray := ScaleRADPoint(pointArray);

  // make a solid line
  DrawStraightLine(ArtPage,
                   pointArray.GetItemCopy(0),
                   pointArray.GetItemCopy(1),
                   '',
                   false);
end;

Procedure ConvertRADElementType28(ArtPage : IIGArtXPage; radNode: TRADElement);
var
  pointArray : IIGPointArray;
begin
  {/p122 dmmn 8/3 - converting RAD rectangle /}
   oddshape := false;

  // generate a list of points
  pointArray := ConvertRADPoints(radNode.RADElementPoints);

  // scale the point if not full res
  if (XFactor <> 1) or (YFactor <> 1) then
    pointArray := ScaleRADPoint(pointArray);

  // make a rectangle
  DrawRectangle(ArtPage,
                pointArray.GetItemCopy(0),
                pointArray.GetItemCopy(1),
                '');
end;

Procedure ConvertRADElementType29(ArtPage : IIGArtXPage; radNode: TRADElement);
var
  inArr : TPoints; //array of TPoint;
  pointArray : IIGPointArray;
  newPoints : string;
begin
  {/p122 dmmn 8/4 - converting RAD ellipse /}
  oddshape := true;

  // generate a list of points
  pointArray := ConvertRADPoints(radNode.RADElementPoints);

  // scale the point if not full res
  if (XFactor <> 1) or (YFactor <> 1) then
    pointArray := ScaleRADPoint(pointArray);

  // copy to TPoints
  SetLength(inArr,5);
  inArr[0].X := pointArray.XPos[0];
  inArr[0].Y := pointArray.YPos[0];
  inArr[1].X := pointArray.XPos[1];
  inArr[1].Y := pointArray.YPos[1];
  inArr[2].X := pointArray.XPos[2];
  inArr[2].Y := pointArray.YPos[2];
  inArr[3].X := pointArray.XPos[3];
  inArr[3].Y := pointArray.YPos[3];
  inArr[4].X := pointArray.XPos[4];
  inArr[4].Y := pointArray.YPos[4];

  // given a 5 points array, use gdi+ to draw a bitmap and return the points
  // on the path of the mark
  newPoints := ConvertRADEllipse(inArr);
  pointArray.Resize(0);
  pointArray := GetPointsFromString(newPoints);

  // make a freehand
  DrawFreeline(ArtPage,
               pointArray,
              '');
end;

Procedure ConvertRADElementType31(ArtPage : IIGArtXPage; radNode : TRADElement);
var
  pointArray : IIGPointArray;
  inArr : TPoints;
  I: Integer;
  newPoints : string;
begin
  {/p122 dmmn 8/3 - converting RAD freehand /}
  oddshape := true;

  // generate a list of points
  pointArray := ConvertRADPoints(radNode.RADElementPoints);

  // scale the point if not full res
  if (XFactor <> 1) or (YFactor <> 1) then
    pointArray := ScaleRADPoint(pointArray);

  // p122 dmmn 8/4 drop the first point to draw correctly
  SetLength(inArr,pointArray.Size-1);
  for I := 0 to pointArray.Size - 2 do
  begin
    inArr[I].X := pointArray.XPos[I+1];
    inArr[I].Y := pointArray.YPos[I+1];
  end;

  newPoints := ConvertRADFreeHand(inArr);
  pointArray.Resize(0);
  pointArray := GetPointsFromString(newPoints);

  // make a freehand
  DrawFreeline(ArtPage,
               pointArray,
               radNode.RADElementText);
end;

Procedure ConvertRADElementType32(ArtPage : IIGArtXPage; radNode: TRADElement);
var
  pointArray : IIGPointArray;
  p1,p2 : IIGPoint;
  text : string;
  igrect : IIGRectangle;
begin
  {/p122 dmmn 8/3 - converting RAD cobb angle /}
  oddshape := false;
  
  // generate a list of points
  pointArray := ConvertRADPoints(radNode.RADElementPoints);

  // scale the point if not full res
  if (XFactor <> 1) or (YFactor <> 1) then
    pointArray := ScaleRADPoint(pointArray);

  // make 2 solid lines, 2 dash lines, 1 text
  DrawStraightLine(ArtPage,
                   pointArray.GetItemCopy(0),
                   pointArray.GetItemCopy(1),
                   '',
                   false);
  DrawStraightLine(ArtPage,
                   pointArray.GetItemCopy(2),
                   pointArray.GetItemCopy(3),
                   '',
                   false);

  P1 := GetIGManager.IGCoreCtrl.CreateObject(IG_OBJ_POINT) As IIGPoint;
  P2 := GetIGManager.IGCoreCtrl.CreateObject(IG_OBJ_POINT) As IIGPoint;

  P1.XPos := (pointArray.XPos[0]+pointArray.XPos[1]) div 2;
  P1.YPos := (pointArray.YPos[0]+pointArray.YPos[1]) div 2;
  P2.XPos := (pointArray.XPos[2]+pointArray.XPos[3]) div 2;
  P2.YPos := (pointArray.YPos[2]+pointArray.YPos[3]) div 2;

  DrawStraightLine(ArtPage,
                   P1,
                   P2,
                   '',true);

  // generate boundary
  igrect := GetIGManager.IGCoreCtrl.CreateObject(IG_OBJ_RECTANGLE) As IGRectangle;
  igrect.Top := pointArray.YPos[5]-Round(25*YFactor);
  igrect.Left := pointArray.XPos[5]-Round(100*XFactor);
  igrect.Right := pointArray.XPos[5]+Round(100*XFactor);
  igrect.Bottom := pointArray.YPos[5]+Round(25*YFactor);

  text := radNode.RADElementText;
  text := ConvertRADTextDegree(text);
  igrect := DrawRADText(ArtPage,
                        text,
                        '',
                        igrect,
                        nil);

  // text connector line
  DrawStraightLine(ArtPage,
                   pointArray.GetItemCopy(4),
                   GetClosestPointOnRectangle(pointArray.GetItemCopy(4),igRect),
                   '',
                   true);
end;

{$REGION 'Convert utils'}
function ConvertRADPoints(pointString: string): IIGPointArray;
var
  pointsList : TStringList;
  x,y : Integer;
  lstInd,arrInd: Integer;
  errorPos : Integer;
begin
  {/p122 dmmn 8/2/11 - converting a string of points got from VistaRAD annotation
  xml to Accusoft array of points /}
  pointsList := TStringList.Create;
  Result := TIGPointArray.Create(nil).DefaultInterface;
  try
    try
      begin
        // parse in the string
        pointsList.StrictDelimiter := True;
        pointsList.Delimiter := ',';
        pointsList.DelimitedText := pointString;

        if (pointsList.Count Mod 2 <> 0) then
          pointsList.Delete(pointsList.Count-1);

        // go through the list and make a list of points
        lstInd := 0;
        arrInd := 0;
        Result.Resize(pointsList.Count div 2);
        while (lstInd<pointsList.Count) do
        begin
          // get x,y
//          Val(pointsList[lstInd],x,errorPos);
//          Val(pointsList[lstInd+1],y,errorPos);
          x := Round(StrToFloat(pointsList[lstInd]));
          y := Round(StrToFloat(pointsList[lstInd+1]));

          // put in array
          Result.XPos[arrInd] := x;
          Result.YPos[arrInd] := y;

          lstInd := lstInd + 2;
          arrInd := arrInd+1;
        end;
      end;
    except
      on E : Exception do
      begin
        MagAppMsg('s','Error converting points array');
        MagAppMsg('s', E.ClassName + 'error raised, with message: '+ E.Message);
      end;
    end;
  finally
    pointsList.Free;
  end;
end;

function ScaleRADPoint(inPointArr: IIGPointArray) : IIGPointArray;
var
  tempPoint : IIGPoint;
  I: Integer;
begin
  {/p122 dmmn 8/3/11 - scale the points got from the RAD xml to fit with downsample
  and full res images /}
  Result := TIGPointArray.Create(nil).DefaultInterface;
  Result.Resize(inPointArr.Size);
  for I := 0 to inPointArr.Size - 1 do
  begin
    tempPoint := GetIGmanager.IGCoreCtrl.CreateObject(IG_OBJ_POINT) As IIGPoint;
    tempPoint.XPos := Round(inPointArr.XPos[I]*XFactor);
    tempPoint.YPos := Round(inPointArr.YPos[I]*YFactor);
    Result.UpdateItemFrom(I,tempPoint);
  end;

  //Jerry
  tempPoint := nil;
end;

function GetDistance(StartPoint,EndPoint : IIGPoint) : integer;
begin
  // a^2 + b^2 = c^2
  Result := Round(Sqrt(Sqr(StartPoint.XPos - EndPoint.XPos) +
                       Sqr(StartPoint.YPos - EndPoint.YPos)));
end;

function GetClosestPointOnRectangle(anchorPoint : IIGPoint; igRect : IIGRectangle) : IIGPoint;
var
  tp0,tp1,tp2,tp3 : IIGPoint;
  ptArr : IIGPointArray;
begin
  {/p122 dmmn 8/1 - get the closet point on the rectangle to the desired point.
  Given a rectangle and a point, it will compare the 4 corner points of the rectangle
  and return the point at a corner with least distance to the desired point  /}
  try
    tp0 := GetIGmanager.IGCoreCtrl.CreateObject(IG_OBJ_POINT) As IIGPoint;  // top left
    tp1 := GetIGmanager.IGCoreCtrl.CreateObject(IG_OBJ_POINT) As IIGPoint;  // top right
    tp2 := GetIGmanager.IGCoreCtrl.CreateObject(IG_OBJ_POINT) As IIGPoint;  // bottom left
    tp3 := GetIGmanager.IGCoreCtrl.CreateObject(IG_OBJ_POINT) As IIGPoint;  // ottom right
    try
      tp0.XPos := igRect.Left;
      tp0.YPos := igRect.Top;
      tp1.XPos := igRect.Right;
      tp1.YPos := igRect.Top;
      tp2.XPos := igRect.Left;
      tp2.YPos := igRect.Bottom;
      tp3.XPos := igRect.Right;
      tp3.YPos := igRect.Bottom;

      ptArr := TIGPointArray.Create(nil).DefaultInterface;
      ptArr.Resize(4);
      ptArr.UpdateItemFrom(0,tp0);
      ptArr.UpdateItemFrom(1,tp1);
      ptArr.UpdateItemFrom(2,tp2);
      ptArr.UpdateItemFrom(3,tp3);

      Result := GetClosestPoint(anchorPoint,ptArr);
    except
      on E : Exception do
      begin
        MagAppMsg('s','Failed to get the closest point on rectangle');
        MagAppMsg('s', E.ClassName + 'error raised, with message: '+ E.Message);
      end;
    end;
  finally
    tp0 := nil;
    tp1 := nil;
    tp2 := nil;
    tp3 := nil;
    ptArr := nil;
  end;
end;

function GetClosestPoint(anchorPoint: IIGPoint; pointArr: IIGPointArray): IIGPoint;
var
  distance : double;
  shortest : double;
  I: Integer;
begin
  {/p122 dmmn 8/2 - go through an array of points and get the point with the
  least distance to the anchorpoint/}
  shortest := 99999;
  distance := 0.0;

  for I := 0 to pointArr.Size - 1 do
  begin
    distance := GetDistance(anchorPoint, pointArr.GetItemCopy(I));
    if distance <= shortest then
    begin
      shortest := distance;
      Result := pointArr.GetItemCopy(I);
    end;
  end;
end;

function ConvertRADTextDegree(radText: string): string;
begin
  {/p122 dmmn 8/3/11 - convert the degree symbol /}
  Result := StringReplace(radText, '[<DEG>]',Chr(176),[rfReplaceAll, rfIgnoreCase]);
end;

function GetPointsFromString(pointString: string): IIGPointArray;
var
  pList : TStringList;
  coord : TStringList;

  x,y : Integer;
  lstInd,arrInd : Integer;
  point : string;
begin
  pList := TStringList.Create;
  coord := TStringList.Create;
  Result := TIGPointArray.Create(nil).DefaultInterface;
  try
    // parse in the string
    pList.StrictDelimiter := True;
    pList.Delimiter := ',';
    pList.DelimitedText := pointString;

    Result.Resize(pList.Count-1);

    // go through the list and make a list of points
    lstInd := 0;
    arrInd := 0;
    while (lstInd<pList.Count-1) do
    begin
      point := pList[lstInd];
      coord.StrictDelimiter := True;
      coord.Delimiter := '^';
      coord.DelimitedText := point;

      // put in array
      Result.XPos[arrInd] := StrToInt(coord[0]);
      Result.YPos[arrInd] := StrToInt(coord[1]);

      lstInd := lstInd+1;
      arrInd := arrInd+1;
    end;
  finally
    coord.Free;
    pList.Free;
  end;
end;

procedure GetTextBounds(radText : string; var w,h : integer);
begin
  //p122t3 dmmn 9/21 - get the size of the text drawn by GDI+
  //with 11 regular Arial font
  GDIMeasureString(radText,w,h);
end;

{$ENDREGION}

{$REGION 'Drawing utils'}
Procedure DrawStraightLine(var ArtPage : IIGArtXPage; StartPoint,EndPoint : IIGPoint; uid : string; dash : boolean);
var
  Border : IIGArtXBorder;
  ArrowHead : IIGArtXArrowHead;
  igMark : IIGArtXLine;
begin
  {/p122 dmmn 8/3/11 - common function to draw a straight line /}
  Border := GetIGManager.IGArtXCtl.CreateObject(IG_ARTX_OBJ_BORDER ) as IIGArtXBorder ;

  // if the mark is part of an odd shape then color is lime, else yellow
  if oddshape then
    Border.SetColor(FRADPixelColor2)
  else
    Border.SetColor(FRADPixelColor);

  Border.Width := FRADLineWidth;

  if dash then
    Border.Style := IG_ARTX_PEN_DASH
  else
    Border.Style := IG_ARTX_PEN_SOLID;

  igMark := GetIGManager.IGArtXCtl.CreateLine(StartPoint,
                                              EndPoint,
                                              Border,
                                              FRADOpacity,
                                              FRADPixelColor,
                                              nil,             // start arrow head
                                              nil);            // end arrow head
//  igMark.Tooltip := uid + '|VistARAD|NA';
  if oddshape then            //p122 dmm 8/9  show approximate
    igMark.Tooltip := 'Approximate';

  ArtPage.AddMark(igMark,IG_ARTX_COORD_IMAGE);
  inc(FRADIGcount);    //9/15
end;

function DrawRADText(var ArtPage : IIGArtXPage; text, uid: string; igrect : IIGRectangle; border : IIGArtXBorder) : IIGRectangle;
var
  igMark : IIGArtXText;
  color : IIGPixel;
  textW, textH : integer; //p122t3 9/21
begin
  //p122t3 calculate the size of the text
  GetTextBounds(text,textW,textH);

//  showmessage(inttostr(textw) + ' ' + inttostr(textH));
//  igrect.Left := round(((igrect.Left + igrect.Width)/2) - (textW/2));
//  igrect.Top := round(((igrect.Top + igrect.Height)/2) - (textH/2));
//  igrect.Width := textW;
//  igrect.Height:= textH;

  // if the mark is part of an odd shape then color is lime, else yellow
  if oddshape then
    color := FRADPixelColor2
  else
    color := FRADPixelColor;

  {/p122 dmmn 8/3/11 - common function to draw a text mark /}

  igMark := GetIGManager.IGArtXCtl.CreateText(igrect,                   // location of the text
                                              text,                     // text to be created
                                              color         ,           // color
                                              IG_ARTX_TEXT_DIRECT_TEXT, // text type
                                              nil,                      // background color
                                              nil,                      // border
                                              false,                    // border shading
                                              FRADOpacity,              // opacity
                                              FRADFont,                 // Font
                                              nil,                      // pinout
                                              nil);                     // callout

  //  igMark.Tooltip := uid + '|VistARAD|NA';
  if oddShape then       //p122 dmm 8/9  show approximate
    igMark.Tooltip := 'Approximate';

  igMark.TextAlignment := IG_DSPL_ALIGN_X_LEFT + IG_DSPL_ALIGN_Y_TOP;
  igMark.BoundsWrap := IG_ARTX_WRAP_HORIZONTAL + IG_ARTX_WRAP_VERTICAL;

  ArtPage.AddMark(igMark,IG_ARTX_COORD_IMAGE);
  Result := igMark.GetBounds;
  inc(FRADIGcount);  // 9/15
end;

procedure DrawArrow(ArtPage : IIGArtXPage; StartPoint,EndPoint: IIGPoint; uid: string);
var
  Border : IIGArtXBorder;
  ArrowHead : IIGArtXArrowHead;
  igMark : IIGArtXLine;
  FRADArrowLength : Integer;  // calculate at runtime
  FRADArrowAngle : Integer;
begin
  {/p122 dmmn 8/3/11 - common function to draw an arrow /}

  Border := GetIGManager.IGArtXCtl.CreateObject(IG_ARTX_OBJ_BORDER ) as IIGArtXBorder ;
  Border.SetColor(FRADPixelColor);
  Border.Width := FRADLineWidth;
  Border.Style := IG_ARTX_PEN_SOLID;

  if (XFactor <> 1) and (YFactor <> 1) then
    FRADArrowLength := 20
  else
    FRADArrowLength := 40;
  FRADArrowAngle := 20;

  ArrowHead := GetIGManager.IGArtXCtl.CreateObject(IG_ARTX_OBJ_ARROWHEAD ) as IIGArtXArrowHead ;
  ArrowHead.Length := FRADArrowLength;
  ArrowHead.Angle := FRADArrowAngle;
  ArrowHead.Style := IG_ARTX_ARROW_SOLID;

  igMark := GetIGManager.IGArtXCtl.CreateLine(StartPoint,
                                              EndPoint,
                                              Border,
                                              FRADOpacity,
                                              FRADPixelColor,
                                              ArrowHead,
                                              nil);
//  igMark.Tooltip := uid + '|VistARAD|NA';   //p122 dmmn 8/9
  ArtPage.AddMark(igMark,IG_ARTX_COORD_IMAGE);
  inc(FRADIGcount);  // 9/15
end;

Procedure DrawRectangle(ArtPage : IIGArtXPage; StartPoint, EndPoint: IIGPoint; uid: string);
var
  Border : IIGArtXBorder;
  igrect : IGRectangle;
  igMark : IIGArtXRectangle;
begin
  {/p122 dmmn 8/3/11 - common function to draw a rectangle/}

  igrect := GetIGManager.IGCoreCtrl.CreateObject(IG_OBJ_RECTANGLE) As IGRectangle;
  igrect.Top := StartPoint.YPos;
  igrect.Left := StartPoint.XPos;
  igrect.Right := EndPoint.XPos;
  igrect.Bottom := EndPoint.YPos;

  Border := GetIGManager.IGArtXCtl.CreateObject(IG_ARTX_OBJ_BORDER ) as IGArtXBorder ;
  Border.SetColor(FRADPixelColor);
  Border.Width := FRADLineWidth;
  Border.Style := IG_ARTX_PEN_SOLID;

  igMark := GetIGManager.IGArtXCtl.CreateRectangle(igrect,
                                                   nil,
                                                   Border,
                                                   FRADOpacity);

//  igMark.Tooltip := uid + '|VistARAD|NA';    //p122 dmmn 8/9
  ArtPage.AddMark(igMark,IG_ARTX_COORD_IMAGE);
  inc(FRADIGcount);  // 9/15
end;

procedure DrawFreeline(ArtPage : IIGArtXPage; pointArray : IIGPointArray; uid: string);
var
  Border : IIGArtXBorder;
  igMark : IIGArtXFreeline;
begin
  Border := GetIGManager.IGArtXCtl.CreateObject(IG_ARTX_OBJ_BORDER ) as IGArtXBorder ;

  // if the mark is part of an odd shape then color is lime, else yellow
  if oddshape then
    Border.SetColor(FRADPixelColor2)
  else
    Border.SetColor(FRADPixelColor);

  Border.Width := FRADLineWidth;
  Border.Style := IG_ARTX_PEN_SOLID;

  igMark := GetIGManager.IGArtXCtl.CreateFreeline(pointArray,
                                                  Border,
                                                  False);
//  igMark.Tooltip := uid + '|VistARAD|NA';
  igMark.Tooltip := 'Approximate';        //p122 dmmn 8/9
  igMark.IsClosed := True;
  ArtPage.AddMark(igMark,IG_ARTX_COORD_IMAGE);
  inc(FRADIGcount);  // 9/15
end;
{$ENDREGION}

end.
