unit uMagAnnotRADConverters;
   {
   Package: MAG - VistA Imaging
   WARNING: Per VHA Directive 10-93-142 this unit should not be modified.
   Date Created:   June 2011
   Site Name: Silver Spring, OIFO
   Developers: Duc MM Nguyen
   [==     unit uMagRADConverters;
   This is a helper unit to fMagAnnotationIGX to convert annotation from VistARAD
   to a format that can be redrawn using Accusoft ImageGear 16.2 ArtX
    ==]
   Note:
   //P122 DMMN Uses a 3rd party created inteface to interact with the graphics
   library of windows GDI+
   }
(*
        ;; +------------------------------------------------------------------+
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
        ;; +------------------------------------------------------------------+

*)
interface

uses
  Math,Types,Dialogs,SysUtils,Classes,

  imaginterfaces,
  Windows,
  IGDIPlus;

type
  TPoints = array of TPoint;

  RGBQuad = packed record
    rgbBlue     : Byte;
    rgbGreen    : Byte;
    rgbRed      : Byte;
    rgbReserved : Byte;
  end;
  PRGBQuad = ^RGBQuad;

  function ConvertRADEllipse(InArr: TPoints) : string;
  function ConvertRADFreehand(InArr: TPoints) : string;

//  function GetQuadrantPoints(gPath : IGPGraphicsPath; quad : Integer) : string;
//  function GetPath(gPath : IGPGraphicsPath) : string;
  procedure GDIMeasureString(radText : string; var w,h : integer);
  
implementation

const
  U_PI = 3.141592653589;

var
  leftMost : Integer;
  rightMost : Integer;
  firstDblRow : integer;
  pointList : string;

function Scanline(BitmapData : TGPBitmapData; Row : integer) : PRGBQuad;
begin
  Result := bitmapData.Scan0;
  Inc(PByte(Result), Row * BitmapData.Stride);
end;

function getLeftSide(gPath : IGPGraphicsPath) : string;
var
  Row, Col : integer;
  theRow  : PRGBQuad;
  BitmapData : TGPBitmapData;
  bmp : IGPBitmap;
  tGraphics : IGPGraphics;
  enArr : TGPImageCodecInfoArray;
  rect : TGPRect;
  foundLPath : boolean;
  LPen : IGPPen;
  clonePath : IGPGraphicsPath;
  cloneArea : TGPRect;
  mat : IGPMatrix;
  leftList : TStringList;
  I : integer;
begin
  Result := '';  {JK}

  mat := TGPMatrix.Create;
  LPen := TGPPen.Create(aclWhite,1);
  leftList := TStringList.Create;
  try
    try
      {/p122 dmmn 8/3 - get all the points of the left side of a graphicspath /}

      // make a copy of the path and the area surrounding it
      clonePath := gPath.Clone;
      cloneArea := gPath.GetBounds();
      cloneArea.X := cloneArea.X - 10;
      cloneArea.Y := cloneArea.Y - 10;
      cloneArea.Width := cloneArea.Width + 10;
      cloneArea.Height := cloneArea.Height + 10;

      mat.Translate(-cloneArea.X,-cloneArea.Y);
      clonePath.Transform(mat);

      bmp := TGPBitmap.Create(cloneArea.Width,cloneArea.Height);
      tGraphics := TGPGraphics.FromImage(bmp);

      tGraphics.DrawPath(LPen,clonePath);

      // copy the shape over smaller image
      rect.X := 0;
      rect.Y := 0;
      rect.Width := cloneArea.Width;
      rect.Height := cloneArea.Height;

      BitmapData := bmp.LockBits(rect,ImageLockModeRead,bmp.PixelFormat);

      for Row := 0 to bitmapdata.Height - 1 do
      begin
        theRow := ScanLine(bitmapData,Row);
        for col := 0 to bitmapData.Width - 1 do
        begin
          foundLPath := (theRow^.rgbBlue = 255) and (theRow^.rgbGreen = 255) and (theRow^.rgbRed = 255);
          theRow^.rgbBlue := 255;
          if foundLPath then
          begin
            leftList.Add(IntToStr(col + cloneArea.X + 10) + '^' + IntToStr(row + cloneArea.Y + 10));
            break;
          end;
          inc(theRow);
        end;
      end;

      bmp.UnlockBits(bitmapdata);

//      enArr := GetImageEncoders;
//      bmp.Save('C:\leftside.jpg',enArr[0].clsid,nil);
//      Result := leftList.CommaText;

      if leftList[0] <> '' then
        Result:= leftList[0];
      for I := 0 to leftList.Count - 1 do
        if leftList[I] <> '' then
          Result := result + ',' + leftList[I];
    except
      on E : Exception do
      begin
        MagAppMsg('s','uMagAnnotRADConverter: Error generating list of points from the left side');
        MagAppMsg('s', E.ClassName + 'error raised, with message: '+ E.Message);
      end;
    end;
  finally
    FreeAndNil(leftlist);
    mat := nil;
    lpen := nil;
  end;

end;

function getRightSide(gPath : IGPGraphicsPath) : string;
var
  Row, Col : integer;
  theRow  : PRGBQuad;
  BitmapData : TGPBitmapData;
  bmp : IGPBitmap;
  tGraphics : IGPGraphics;
//  enArr : TGPImageCodecInfoArray;
  rect : TGPRect;
  foundRPath : boolean;
  LPen : IGPPen;
  clonePath : IGPGraphicsPath;
  cloneArea : TGPRect;
  mat : IGPMatrix;
  rightList : TStringList;
  I: Integer;
begin

  mat := TGPMatrix.Create;
  LPen := TGPPen.Create(aclWhite,1);
  rightList := TStringList.Create;
  try
    try
      clonePath := gPath.Clone;
      cloneArea := gPath.GetBounds();
      cloneArea.X := cloneArea.X - 10;
      cloneArea.Y := cloneArea.Y - 10;
      cloneArea.Width := cloneArea.Width + 10;
      cloneArea.Height := cloneArea.Height + 10;

      mat.Translate(-cloneArea.X,-cloneArea.Y);
      clonePath.Transform(mat);

      bmp := TGPBitmap.Create(cloneArea.Width,cloneArea.Height);
      tGraphics := TGPGraphics.FromImage(bmp);

      tGraphics.DrawPath(LPen,clonePath);

      // copy the shape over smaller image
      rect.X := 0;
      rect.Y := 0;
      rect.Width := cloneArea.Width;
      rect.Height := cloneArea.Height;

      BitmapData := bmp.LockBits(rect,ImageLockModeRead,bmp.PixelFormat);

      for Row := bitmapData.Height-1 downto 0 do
      begin
        theRow := ScanLine(bitmapData,Row);
        inc(theRow,bitmapData.Width-1);
        for col := bitmapdata.Width-1 downto 0 do
        begin
          foundRPath := (theRow^.rgbBlue = 255) and (theRow^.rgbGreen = 255) and (theRow^.rgbRed = 255);
          theRow^.rgbBlue := 255;
          if foundRPath then
          begin
            rightList.Add(IntToStr(col + cloneArea.X + 10) + '^' + IntToStr(row + cloneArea.Y + 10));
            break;
          end;
          dec(theRow);
        end;
      end;
      bmp.UnlockBits(bitmapdata);

    //  enArr := GetImageEncoders;
    //  bmp.Save('C:\rightside.jpg',enArr[0].clsid,nil);
//      Result := rightList.CommaText;
      if rightList[0] <> '' then
        Result:= rightList[0];
      for I := 0 to rightlist.Count - 1 do
        if rightlist[I] <> '' then
          Result := result + ',' + rightlist[I];
    except
      on E : Exception do
      begin
        MagAppMsg('s','uMagAnnotRADConverter: Error generating list of points from the right side');
        MagAppMsg('s', E.ClassName + 'error raised, with message: '+ E.Message);
      end;
    end;
  finally
    FreeAndNil(RightList);
    lPen := nil;
    mat := nil;
  end;
end;

function getTopSide(gPath : IGPGraphicsPath) : string;
var
  Row, Col : integer;
  theRow  : PRGBQuad;
  BitmapData : TGPBitmapData;
  bmp : IGPBitmap;
  tGraphics : IGPGraphics;
//  enArr : TGPImageCodecInfoArray;
  rect : TGPRect;
  foundTPath : boolean;
  LPen : IGPPen;
  clonePath : IGPGraphicsPath;
  cloneArea : TGPRect;
  mat : IGPMatrix;
  topList : TStringList;
begin
  clonePath := gPath.Clone;
  cloneArea := gPath.GetBounds();
  cloneArea.X := cloneArea.X - 10;
  cloneArea.Y := cloneArea.Y - 10;
  cloneArea.Width := cloneArea.Width + 10;
  cloneArea.Height := cloneArea.Height + 10;

  mat := TGPMatrix.Create;
  mat.Translate(-cloneArea.X,-cloneArea.Y);
  clonePath.Transform(mat);

  bmp := TGPBitmap.Create(cloneArea.Width,cloneArea.Height);
  tGraphics := TGPGraphics.FromImage(bmp);
  LPen := TGPPen.Create(aclWhite,1);
  tGraphics.DrawPath(LPen,clonePath);

  // copy the shape over smaller image
  rect.X := 0;
  rect.Y := 0;
  rect.Width := cloneArea.Width;
  rect.Height := cloneArea.Height;

  BitmapData := bmp.LockBits(rect,ImageLockModeRead,bmp.PixelFormat);
  
  topList := TStringList.Create;
  for Col := bitmapData.Width-1 downto 0 do
  begin
    for Row := 0 to bitmapData.Height-1 do
    begin
      theRow := ScanLine(bitmapData,Row);
      inc(theRow,col);
      foundTPath := (theRow^.rgbBlue = 255) and (theRow^.rgbGreen = 255) and (theRow^.rgbRed = 255);
      theRow^.rgbBlue := 255;
      if foundTPath then
      begin
        topList.Add(IntToStr(col + cloneArea.X + 10) + '^' + IntToStr(row + cloneArea.Y + 10));
        break;
      end;
    end;
  end;
  bmp.UnlockBits(bitmapdata);

//  enArr := GetImageEncoders;
//  bmp.Save('C:\topside.jpg',enArr[0].clsid,nil);
  Result := topList.CommaText;
  FreeAndNil(topList);
end;

function getBottomSide(gPath : IGPGraphicsPath) : string;
var
  Row, Col : integer;
  theRow  : PRGBQuad;
  BitmapData : TGPBitmapData;
  bmp : IGPBitmap;
  tGraphics : IGPGraphics;
//  enArr : TGPImageCodecInfoArray;
  rect : TGPRect;
  foundBPath : boolean;
  LPen : IGPPen;
  clonePath : IGPGraphicsPath;
  cloneArea : TGPRect;
  mat : IGPMatrix;
  bottomList : TStringList;
begin
  clonePath := gPath.Clone;
  cloneArea := gPath.GetBounds();
  cloneArea.X := cloneArea.X - 10;
  cloneArea.Y := cloneArea.Y - 10;
  cloneArea.Width := cloneArea.Width + 10;
  cloneArea.Height := cloneArea.Height + 10;

  mat := TGPMatrix.Create;
  mat.Translate(-cloneArea.X,-cloneArea.Y);
  clonePath.Transform(mat);

  bmp := TGPBitmap.Create(cloneArea.Width,cloneArea.Height);
  tGraphics := TGPGraphics.FromImage(bmp);
  LPen := TGPPen.Create(aclWhite,1);
  tGraphics.DrawPath(LPen,clonePath);

  // copy the shape over smaller image
  rect.X := 0;
  rect.Y := 0;
  rect.Width := cloneArea.Width;
  rect.Height := cloneArea.Height;

  BitmapData := bmp.LockBits(rect,ImageLockModeRead,bmp.PixelFormat);
  
  bottomList := TStringList.Create;
  for Col := 0 to bitmapData.Width-1 do
  begin
    for Row := bitmapData.Height-1 downto 0 do
    begin
      theRow := ScanLine(bitmapData,Row);
      inc(theRow,col);
      foundBPath := (theRow^.rgbBlue = 255) and (theRow^.rgbGreen = 255) and (theRow^.rgbRed = 255);
      theRow^.rgbBlue := 255;
      if foundBPath then
      begin
        bottomList.Add(IntToStr(col + cloneArea.X + 10) + '^' + IntToStr(row + cloneArea.Y + 10));
        break;
      end;
    end;
  end;
  bmp.UnlockBits(bitmapdata);

//  enArr := GetImageEncoders;
//  bmp.Save('C:\bottomside.jpg',enArr[0].clsid,nil);
  Result := bottomList.CommaText;
  FreeAndNil(bottomList);
end;

function MergeSides(sidePoints : TStringList) : string;
var
  finalPoints : TStringList;
  pList : TStringList;
  I : Integer;
  side : string;
  point : string;
begin
  finalPoints := TStringList.Create;
  pList := TStringList.Create;
  try
    try
      for side in sidePoints do
      begin
        if side <> '' then
        begin
          pList.Clear;
          pList.StrictDelimiter := True;
          pList.Delimiter := ',';
          pList.DelimitedText := side;

          I := 0;
          while I < pList.Count do
          begin
            point := pList[I];
            if finalPoints.IndexOf(point) = -1 then
              finalPoints.Add(point);
            inc(I,1);
          end;
        end;
      end;
      Result := finalPoints.CommaText;
    except
      on E : Exception do
      begin
        MagAppMsg('s','uMagAnnotRADConverter: merging the sides');
        MagAppMsg('s', E.ClassName + 'error raised, with message: '+ E.Message);
      end;
    end;
  finally
    FreeAndNil(pList);
    FreeAndNil(finalPoints);
  end;
end;

function MergeSidess(Side1, Side2 : string) : string;
var
  finalPoints : TStringList;
  pList : TStringList;
  I : Integer;
  side : string;
  point : string;
begin
  finalPoints := TStringList.Create;
  pList := TStringList.Create;
  try
    try
        if side1 <> '' then
        begin
          pList.Clear;
          pList.StrictDelimiter := True;
          pList.Delimiter := ',';
          pList.DelimitedText := side1;

          I := 0;
          while I < pList.Count do
          begin
            point := pList[I];
            if finalPoints.IndexOf(point) = -1 then
              finalPoints.Add(point);
            inc(I,1);
          end;
        end;
        if side2 <> '' then
        begin
          pList.Clear;
          pList.StrictDelimiter := True;
          pList.Delimiter := ',';
          pList.DelimitedText := side2;

          I := 0;
          while I < pList.Count do
          begin
            point := pList[I];
            if finalPoints.IndexOf(point) = -1 then
              finalPoints.Add(point);
            inc(I,1);
          end;
        end;
      Result := finalPoints.CommaText;

    except
      on E : Exception do
      begin
        MagAppMsg('s','uMagAnnotRADConverter: merging the sides');
        MagAppMsg('s', E.ClassName + 'error raised, with message: '+ E.Message);
      end;
    end;
  finally
    FreeAndNil(pList);
    FreeAndNil(finalPoints);
  end;
end;

function Length(pt0,pt1 : TGPPoint): Single;
begin
	Result := Sqrt(Sqr(pt1.x - pt0.x) + Sqr(pt1.y - pt0.y));
end;

function LineAngle(pt0,pt1 : TGPPoint) : Single;
var
  dCosAlpha : Single;
  dx : Single;
  dy : Single;
  dLength : Single;
begin
	dx := pt1.x - pt0.x;
  dy := pt1.y - pt0.y;
  dLength  := sqrt(dx*dx + dy*dy);
  dCosAlpha := dx / dLength;

	if (dy / dLength < 0) then
		Result := (U_PI * 2 - ArcCos(dCosAlpha))
	else
		Result := ArcCos(dCosAlpha);
end;

function LineAngleDeg(pt0,pt1 : TGPPoint) : Single;
begin
	Result := 360 - ((LineAngle(pt0, pt1) * 180) / U_PI);
end;

procedure DrawArc(pointA,pointB,pointC : TGPPoint; nQuadrant : Integer;var a_pGPath : IGPGraphicsPath); overload;
var
  dWidth : Single;
  dHeight : Single;
  dAngle : Single;
  mat : IGPMatrix;
  pt : TGPPointF;
  gpath : IGPGraphicsPath;
begin
  {/p122 dmmn 8/2 - adapted from C++ version used to draw an arc of an ellipse
  using gdi+ /}

  dWidth := Length(pointA, pointC);
  dHeight := Length(pointB, pointC);

  dAngle := 360.0 - LineAngleDeg(pointA, pointC);

  if ((nQuadrant = 0) or (nQuadrant = 3)) then
    dAngle := dAngle + 180.0;

  pt.X := dWidth;
  pt.Y := dHeight;
  mat := TGPMatrix.Create;
  gpath := TGPGraphicsPath.Create;
  mat.RotateAt(dAngle, pt);
  mat.Translate(pointC.x - dWidth, pointC.y - dHeight,MatrixOrderAppend);
  gpath.AddArcF(0.0, 0.0, dWidth * 2.0, dHeight * 2.0,nQuadrant * 90.0, 90.0);
  gpath.Transform(mat);
  a_pGPath.AddPath(gpath, TRUE);
end;

function ConvertRADEllipse(InArr: TPoints) : string;
var
  gPath : IGPGraphicsPath;
//  LSide,BSide,RSide,TSide : string;
  allSides : TStringList;
//  quad0,quad1,quad2,quad3 : string;
begin
  {/p122 dmmn 8/4 - draw an elliptical shape using GDI+ from 5 given points /}

  allSides := TStringList.Create;
  gPath := TGPGraphicsPath.Create();
  try
    try
      DrawArc(inArr[1], inArr[2], inArr[4], 0, gPath);
      DrawArc(inArr[0], inArr[2], inArr[4], 1, gPath);
      DrawArc(inArr[0], inArr[3], inArr[4], 2, gPath);
      DrawArc(inArr[1], inArr[3], inArr[4], 3, gPath);

      allSides.Add(getLeftSide(gPath));
      allSides.Add(getRightSide(gPath));
      Result := MergeSides(allsides);
    except
      on E : Exception do
      begin
        MagAppMsg('s','uMagAnnotRADConverter: Error converting ellipse');
        MagAppMsg('s', E.ClassName + 'error raised, with message: '+ E.Message);
      end;
    end;
  finally
    FreeAndNil(allSides);
    gPath := nil;
  end;
end;

function ConvertRADFreehand(InArr: TPoints) : string;
var
  gPath : IGPGraphicsPath;
  LSide,BSide,RSide,TSide : string;
  allSides : TStringList;
begin
  allSides := TStringList.Create;
  gPath := TGPGraphicsPath.Create();
  try
    try
      gPath.AddClosedCurve(InArr);

      LSide := getLeftSide(gPath);
      RSide := getRightSide(gPath);
      Result := MergeSidess(lside,rside);
//      Result := LSide;
    except
      on E : Exception do
      begin
        MagAppMsg('s','uMagAnnotRADConverter: Error converting freehand');
        MagAppMsg('s', E.ClassName + 'error raised, with message: '+ E.Message);
      end;
    end;
  finally
//    allSides.Free;
    FreeAndNil(allSides);
    gPath := nil;
  end;
end;

procedure GDIMeasureString(radText : string; var w,h : integer);
var
  font : IGPFont;
  point : TGPPointF;
  rect : TGPRectF;
  graphics : IGPGraphics;
  size : TGPSizeF;
begin
  graphics := TGPGraphics.Create(GetDC(0));
  font := TGPFont.Create('Arial',20,[]);
  point := MakePointF(20,20);
  rect := graphics.GetStringBoundingBoxF(radText, font, point);
  size := graphics.MeasureStringF(radtext,font);
  w := Round(rect.Width);
  h := Round(rect.Height);
end;


{$REGION 'prototype codes node used'}
(*
function GetQuadrantPoints(gPath : IGPGraphicsPath; quad : Integer) : string;
var
  Row, Col : integer;
  LRow  : PRGBQuad;
  RRow  : PRGBQuad;
  BitmapData : TGPBitmapData;
  bmp : IGPBitmap;
  tGraphics : IGPGraphics;
  rect : TGPRect;
  foundLPath : boolean;
  LPen : IGPPen;
  clonePath : IGPGraphicsPath;
  cloneArea : TGPRect;
  mat : IGPMatrix;
  leftList : TStringList;
  rightList : TStringList;
  I: Integer;
  point : string;

  enArr : TGPImageCodecInfoArray;
  firstDbl : boolean;
  foundRPath : boolean;
  rCol : integer;
  finalList : TStringList;
  listPos : integer;

  function SameRow(point : string) : boolean;
  var
    tList: tstringlist;
  begin
    tList := TStringList.Create;
    try
      tList.StrictDelimiter := True;
      tList.Delimiter := '^';
      tList.DelimitedText := point;
      if IntToStr(firstDblRow) = tList[1] then
        Result := True
      else
        Result := False;
    finally
      tList.Free;
    end;

  end;
begin
  // make a copy of the path
  clonePath := gPath.Clone;

  // calculate the area of the path with a buffer of 10px on each side
  cloneArea := gPath.GetBounds();
  cloneArea.X := cloneArea.X - 10;
  cloneArea.Y := cloneArea.Y - 10;
  cloneArea.Width := cloneArea.Width + 10;
  cloneArea.Height := cloneArea.Height + 10;

  mat := TGPMatrix.Create;
  mat.Translate(-cloneArea.X,-cloneArea.Y);
  clonePath.Transform(mat);

  // create a temporary bitmap to draw the path on
  bmp := TGPBitmap.Create(cloneArea.Width,cloneArea.Height);
  tGraphics := TGPGraphics.FromImage(bmp);
  LPen := TGPPen.Create(aclWhite,1);
  tGraphics.DrawPath(LPen,clonePath);

  // copy the shape over smaller image with new coordinates
  rect.X := 0;
  rect.Y := 0;
  rect.Width := cloneArea.Width;
  rect.Height := cloneArea.Height;

  BitmapData := bmp.LockBits(rect,ImageLockModeRead,bmp.PixelFormat);
  leftList := TStringList.Create;
  rightList := TStringList.Create;

  firstDbl := false;
  firstDblRow := -1;

  for Row := 0 to bitmapdata.Height - 1 do
  begin
    LRow := ScanLine(bitmapData,Row);   // start from the left edge
    RRow := ScanLine(bitmapData,Row);
    inc(RRow,bitmapData.Width-1);       // move count to start from the right edge

    foundLPath := false;
    foundRPath := false;
    // going down the path top to bottom
    for col := 0 to bitmapData.Width - 1 do
    begin
      // go from left to right, if find first white pixel
      // then start on the right for the same row until find
      // a white pixel from the right
      if (LRow^.rgbBlue = 255) and (LRow^.rgbGreen = 255) and (LRow^.rgbRed = 255) then
      begin
        foundLPath := true;

        // add the point to the left list
        leftList.Add(IntToStr(col + cloneArea.X + 10) + '^' + IntToStr(row + cloneArea.Y + 10));

        // go from the right to left until meet the location of the left path
        for rCol := bitMapData.Width-1 downto col do
        begin
          if ((RRow^.rgbBlue = 255) and (RRow^.rgbGreen = 255) and (RRow^.rgbRed = 255)) then
          begin
            foundRPath := true;

            // add the point to the right list
            if rCol > col + 5 then
              rightList.Add(IntToStr(rCol + cloneArea.X + 10) + '^' + IntToStr(row + cloneArea.Y + 10));
            break;
          end;
          rRow^.rgbred := 255;
          dec(RRow);
        end;

        // if the location of the first white pixel from the right is more than 5px away
        // from the first white pixel on the left and we haven't found the double point
        // yet, store the row number which contain 2 white pixels
        if (firstDbl = false) and (rCol > col + 5) then
        begin
          firstDbl := true;
          firstDblRow := row + cloneArea.Y + 10;
        end;

//        leftList.Add(IntToStr(col + cloneArea.X + 10) + '^' + IntToStr(row + cloneArea.Y + 10));
        break;
      end;
      LRow^.rgbBlue := 255;
      inc(LRow);
    end;
  end;

  bmp.UnlockBits(bitmapdata);

  // delete duplicate points on left or right side depends on the quadrant
  FinalList := TStringList.Create;
  listPos := 0;
  if quad = 0 then
  begin
    // combine top-down right list and bottom-up left list

    // if there's no double row then take invert left
    if firstDblRow = -1 then
      // full bottom-up left list
      for listPos := leftList.Count-1 downto 0 do
        FinalList.Add(leftList[listPos])
    else // if firstDblRow > -1 then
    begin
      // if there's row with double white pixel

      // full top-down right
      if rightList.Count > 0 then
      for listPos := 0 to rightList.Count - 1 do
        FinalList.Add(rightList[listPos]);

      // not full bottom-up lower left list
      listPos := leftList.Count-1;
      while not SameRow(leftList[listPos]) do
      begin
        FinalList.Add(leftList[listPos]);
        dec(listPos);
      end;
    end;
  end
  else if quad = 1 then
  begin
    // combine top-down right list and bottom-up left list
    // if there's no double row then take invert left
    if firstDblRow = -1 then
      // full bottom-up left list
      for listPos := leftList.Count-1 downto 0 do
        FinalList.Add(leftList[listPos])
    else
    begin
      if rightList.Count > 0 then
      begin
        // if there's row with double white pixel
        if firstDblRow > -1 then
        begin
          // not full top-down lower right list
          listPos := 0;
          while not SameRow(RightList[ListPos]) do
            inc(ListPos);

          while listPos < rightList.Count do
            FinalList.Add(rightList[listPos]);
        end;
      end;
      // full bottom-up left list
      for listPos := leftList.Count-1 downto 0 do
        FinalList.Add(leftList[listPos]);
    end;
  end
  else if quad = 2 then
  begin
    // combine bottom-up left list and top-down right list
    // if there's no double row then take invert left
    if firstDblRow = -1 then
      // full bottom-up left list
      for listPos := leftList.Count-1 downto 0 do
        FinalList.Add(leftList[listPos])
    else
    begin
      // full bottom-up left list
      for listPos := leftList.Count-1 downto 0 do
        FinalList.Add(leftList[listPos]);

      if rightList.Count > 0 then
      begin
        // if there's row with double white pixel
        if firstDblRow > -1 then
        begin
          // not full top-down upper right list
          listPos := 0;
          while not sameRow(RightList[listPos]) do
          begin
            FinalList.Add(rightList[listPos]);
            inc(listPos);
          end;
        end;
      end;
    end;
  end
  else if quad = 3 then
  begin
    // combine bottom-up upper left list and top-down right list
    // if there's no double row then take invert left
    if firstDblRow = -1 then
      // full bottom-up left list
      for listPos := leftList.Count-1 downto 0 do
        FinalList.Add(leftList[listPos])
    else
    begin
      // if there's row with double white pixel
      if firstDblRow > -1 then
      begin
        // not full bottom-up upper left list
        listPos := leftList.Count-1;
        while not SameRow(LeftList[listPos]) do
          dec(listPos);

        while listPos >= 0 do
          FinalList.Add(leftList[listPos]);
      end;

      // full top-down right list
      if rightList.Count > 0 then
        for listPos := 0 to rightList.Count - 1 do
          FinalList.Add(rightList[listPos]);
    end;
  end;

//  enArr := GetImageEncoders;
//  bmp.Save('C:\rows.jpg',enArr[0].clsid,nil);
  Result := finalList.CommaText;

  LeftList.Free;
  RightList.Free;
  finalList.Free;
end;

function GetPath(gPath : IGPGraphicsPath) : string;
var
  Matrix : array of array of string;

  Row, Col : integer;
  theRow  : PRGBQuad;
  BitmapData : TGPBitmapData;
  bmp : IGPBitmap;
  tGraphics : IGPGraphics;
  enArr : TGPImageCodecInfoArray;
  rect : TGPRect;
  foundLPath : boolean;
  LPen : IGPPen;
  clonePath : IGPGraphicsPath;
  cloneArea : TGPRect;
  mat : IGPMatrix;
  leftList : TStringList;
  I: Integer;
  J: Integer;

  s : string;
  SomeTxtFile : TextFile;
begin
  clonePath := gPath.Clone;
  cloneArea := gPath.GetBounds();
  cloneArea.X := cloneArea.X - 10;
  cloneArea.Y := cloneArea.Y - 10;
  cloneArea.Width := cloneArea.Width + 10;
  cloneArea.Height := cloneArea.Height + 10;

  mat := TGPMatrix.Create;
  mat.Translate(-cloneArea.X,-cloneArea.Y);
  clonePath.Transform(mat);

  bmp := TGPBitmap.Create(cloneArea.Width,cloneArea.Height);
  tGraphics := TGPGraphics.FromImage(bmp);
  LPen := TGPPen.Create(aclWhite,1);
  tGraphics.DrawPath(LPen,clonePath);

  // copy the shape over smaller image
  rect.X := 0;
  rect.Y := 0;
  rect.Width := cloneArea.Width;
  rect.Height := cloneArea.Height;

  SetLength(Matrix,rect.Height,rect.Width);

  BitmapData := bmp.LockBits(rect,ImageLockModeRead,bmp.PixelFormat);
  leftList := TStringList.Create;
  for Row := 0 to bitmapdata.Height - 1 do
  begin
    theRow := ScanLine(bitmapData,Row);
    for col := 0 to bitmapData.Width - 1 do
    begin
      if (theRow^.rgbBlue = 255) and (theRow^.rgbGreen = 255) and (theRow^.rgbRed = 255) then
        Matrix[row,col] := 'x';
      inc(theRow);
    end;
  end;

//  s:='';
//  for I := 0 to rect.Height - 1 do
//  begin
//    for J := 0 to rect.Width - 1 do
//      s := s + Matrix[I,J] + ',';
//    s := s + slinebreak;
//  end;
//  AssignFile(SomeTxtFile, 'c:\MyTextFile.txt') ;
//  Rewrite(SomeTxtFile) ;
//  WriteLn(SomeTxtFile, s) ;
//  CloseFile(SomeTxtFile);
//
//  bmp.UnlockBits(bitmapdata);
//
//  enArr := GetImageEncoders;
//  bmp.Save('C:\leftside.jpg',enArr[0].clsid,nil);
  Result := leftList.CommaText;
  FreeAndNil(leftList);

  matrix := nil
end;
        *)

{$ENDREGION}

end.
