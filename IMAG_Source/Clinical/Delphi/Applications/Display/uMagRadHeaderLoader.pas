unit uMagRadHeaderLoader;
(*
        ;; +---------------------------------------------------------------------------------------------------+
        ;;  MAG - IMAGING
        ;;  Property of the US Government.
        ;;  WARNING: Per VHA Directive 10-93-142 this unit should not be modified.
        ;;  No permission to copy or redistribute this software is given.
        ;;  Use of unreleased versions of this software requires the user
        ;;  to execute a written test agreement with the VistA Imaging
        ;;  Development Office of the Department of Veterans Affairs,
        ;;  telephone (301) 734-0100.
        ;;
        ;; The Food and Drug Administration classifies this software as
        ;; a Class II medical device.  As such, it may not be changed
        ;; in any way.  Modifications to this software may result in an
        ;; adulterated medical device under 21CFR820, the use of which
        ;; is considered to be a violation of US Federal Statutes.
        ;;
        ;;  Date created: April 2013
        ;;  Site Name:  Washington OI Field Office, Silver Spring, MD
        ;;  Developer:  Julian Werfel
        ;;  Description: New classes to hold radiology image information and
        ;;    methods for retrieving scout information using the XRefUtils
        ;;
        ;;+---------------------------------------------------------------------------------------------------+
*)

interface

uses XRefUtilsLib_TLB, sysutils, classes, uMagClasses,
  MagImageManager, uMagTextFileLoader;

Type
  TMagImageHeaderLoadedEvent = Procedure(Current, Total : integer) of object;

type
  TMagRadiologyImage = class
  public
    Img : TImageData;
    RadiologyImage : TRadiologyImage;
    DicomData : TDicomData;
    Index : Integer;

    Constructor Create(Img : TImageData; DicomData : TDicomData;
      RadiologyImage : TRadiologyImage; Index : Integer);
    Destructor Destroy; Override;
  end;

type
  TMagRadiologyStudy = class
  public
    RootImg : TImageData;
    Images : TList;

    Constructor Create(RootImg : TImageData; Images : TList);
    Destructor Destroy; Override;
    function FindRadiologyImage(IObj : TImageData) : TMagRadiologyImage;
  end;

type
  TMagRadiologyStudyHolder = class
  public
    RadiologyStudies : TList;

    Constructor Create();
    procedure AddUniqueStudy(Study : TMagRadiologyStudy);
    function getStudy(RootImg : TImageData): TMagRadiologyStudy;
    function GetStatus() : String;
  end;
         {
type
  TMagScoutLine = class
  public
    X1, Y1, X2, Y2 : integer;
  end;
  }

procedure Initialize();
procedure Destroy();
procedure ClearPatient();
function LoadStudyImages(RootImg : TImageData; Images : TList;
  ImageHeaderLoadedEvent : TMagImageHeaderLoadedEvent = nil) : TMagRadiologyStudy;
function LoadStudyImage(IObj : TImageData; keepConnectionAlive : boolean;
  Index : Integer) : TMagRadiologyImage;
function GetStudyHolder() : TMagRadiologyStudyHolder;
function FindNearestImage(ScoutImage : TMagRadiologyImage;
  Study : TMagRadiologyStudy; x, y : integer;
  HeaderSeriesNumber : real; DatabaseSeriesNumber : String) : TMagRadiologyImage;
function GetXRefLine(sliceImage, scoutImage : TMagRadiologyImage;
  sliceStudy : TMagRadiologyStudy) : TMagScoutLine; overload;
function GetXRefLine(SelectedImage, SelectedRootImage, CurrentImage, CurrentRootImage : TImageData) : TMagScoutLine; overload;
procedure CancelHeaderLoading();

implementation

uses
  iMagInterfaces, iMagDicomHeaderLoader, cMagIGDicomHeaderLoader;

var
  FLut : TXRefLUT;
  FStudyHolder : TMagRadiologyStudyHolder;
  FStopLoadingHeaders : Boolean;
  FDicomHeaderLoader : TMagDicomHeaderLoader;

procedure Initialize();
begin
  if FLut = nil then
  begin
    FLut := TXRefLUT.Create(nil);
  end;
  if FStudyHolder = nil then
  begin
    FStudyHolder := TMagRadiologyStudyHolder.Create();
  end;
  if FDicomHeaderLoader = nil then
    FDicomHeaderLoader := TMagIGDicomHeaderLoader.Create();
end;

function GetStudyHolder() : TMagRadiologyStudyHolder;
begin
  result := FStudyHolder;
end;

procedure ClearPatient();
begin
  Destroy();
end;

procedure CancelHeaderLoading();
begin
  FStopLoadingHeaders := true;
end;

{Load the text files for the images in the TList}
function LoadStudyImages(RootImg : TImageData; Images : TList;
  ImageHeaderLoadedEvent : TMagImageHeaderLoadedEvent = nil) : TMagRadiologyStudy;
var
  i : integer;
  newRootImg, IObj : TImageData;

  keepConnectionAlive : boolean;
  magRadiologyImage : TMagRadiologyImage;
  radiologyImages, loadedList : TList;
  count : integer;                  
begin
  result := nil;
  FStopLoadingHeaders := false;
  radiologyImages := TList.Create;
  keepConnectionAlive := true;
  count := Images.Count;
  for i := 0 to count - 1 do
  begin
    if assigned(ImageHeaderLoadedEvent) then
      ImageHeaderLoadedEvent(i, count);
    IObj := Images[i];
    if i = Images.Count - 1 then
      keepConnectionAlive := false;
    magRadiologyImage := LoadStudyImage(IObj, keepConnectionAlive, i);
    if magRadiologyImage <> nil then
      radiologyImages.Add(magRadiologyImage);
    if FStopLoadingHeaders then
      break;
  end;

  if FStopLoadingHeaders then
  begin
    MagAppMsg('', 'Header loading for study [' + RootImg.Mag0 + '] cancelled by user, scout lines will not be available.', MAGMSGDebug);
    result := nil;
    for i := 0 to radiologyImages.Count - 1 do
    begin
      magradiologyImage := radiologyImages[i];
      FreeAndNil(magRadiologyImage);
    end;
    FreeAndNil(radiologyImages);

    // calling this will cause the loader dialog to close even though the load did not finish
    if assigned(ImageHeaderLoadedEvent) then
      ImageHeaderLoadedEvent(count, count);
    exit;
  end;
  loadedList := TList.Create;

  // we loaded all the data, still continuing now add to LUT
  for i := 0 to radiologyImages.Count - 1 do
  begin
    magRadiologyImage := radiologyImages[i];
    try
      FLut.RegisterImage(magRadiologyImage.RadiologyImage.DefaultInterface);
      loadedList.add(magRadiologyImage); // put into new list of "good" loaded images
    except
      on e : Exception do
      begin
        MagAppMsg('', 'Exception loading image [' + magRadiologyImage.Img.Mag0 + '] into LUT, ' + e.Message, MAGMSGDebug);
      end;
    end;
  end;
  FreeAndNil(radiologyImages); // this list is no longer contains all the objects

  // call the image header loaded event to clear the dialog since all headers are loaded
  if assigned(ImageHeaderLoadedEvent) then
      ImageHeaderLoadedEvent(count, count);
  newRootImg := TImageData.Create;
  newRootImg.MagAssign(RootImg); // make a copy of the RootImg since that object seems to be reused elsewhere          
  result := TMagRadiologyStudy.Create(newRootImg, loadedList);
end;

function LoadStudyImage(IObj : TImageData; keepConnectionAlive : boolean;
  Index : Integer) : TMagRadiologyImage;
var
  TxtFilename : String;
  txtResult : TMagImageTransferResult;
  DicomData : TDicomData;
  radiologyImage : TRadiologyImage;
  newIObj : TImageData;
  usingTxtFile : boolean;
begin
  result := nil;
  try
    newIObj := TImageData.Create;
    newIObj.MagAssign(IObj); // make a copy of the image since the object is reused elsewhere

    usingTxtFile := not newIObj.IsImageDOD;     

    txtResult := MagImageManager1.GetFile(newIObj.FFile, newIObj.PlaceCode,
      newIObj.ImgType, keepConnectionAlive, usingTxtFile);
    if txtResult.FTransferStatus = IMAGE_COPIED then
    begin
//      MagAppMsg('', 'Reading header for file [' + IObj.FFile +  '].', MAGMSGDebug);
      TxtFilename := TxtResult.FDestinationFilename;
      if usingTxtFile then
      begin
        DicomData := uMagTextFileLoader.LoadTGAText(txtFilename);
      end
      else
      begin
        // for the DoD we should get a DICOM object, load the header from that
        // object. The txtFilename should contain the locally cached filename
        // for the DICOM image
        DicomData := FDicomHeaderLoader.LoadDicomHeader(TxtFilename);
      end;
      if not dicomData.IsScoutInformationAvailable() then
      begin
        result := nil;
        MagAppMsg('', 'Text File for image [' + newIObj.FFile + '] does not contain all header information necessary for scout lines.', magmsgDebug);
        exit;
      end;

      radiologyImage := TRadiologyImage.Create(nil);
      radiologyImage.SetTag(StrToInt('$20'), StrToInt('$32'),
        dicomData.ToDelimitedString(dicomData.ImagePosition, '\'));
      radiologyImage.SetTag(StrToInt('$20'), StrToInt('$37'),
        dicomData.ToDelimitedString(dicomData.ImageOrientation, '\'));
      radiologyImage.SetTag(StrToInt('$28'), StrToInt('$30'),
        dicomData.ToDelimitedString(dicomData.PixelSpacing, '\'));
      radiologyImage.SetTag(StrToInt('$20'), StrToInt('$52'),
        dicomData.FrameOfReferenceUid);
      radiologyImage.SetTag(StrToInt('$28'), StrToInt('$10'),
        inttostr(dicomdata.Rows));
      radiologyImage.SetTag(StrToInt('$28'), StrToInt('$11'),
        inttostr(dicomdata.Columns));
      radiologyImage.UserData := dicomData.DicomDataSource;

      {
      // moved registering image to end of loading all image data in case the
      // user cancels the load we don't want the file sitting loaded in the LUT
      FLut.RegisterImage(radiologyImage.DefaultInterface);
      }

      result := TMagRadiologyImage.Create(newIObj, dicomData,
        radiologyImage, index);

    end;
  except
     on e : Exception do
     begin
      MagAppMsg('', 'Exception loading image [' + IObj.Mag0 + '], ' + e.Message, MAGMSGDebug);
     end;
  end;
end;

procedure Destroy();
var
 i, j : integer;
 study : TMagRadiologyStudy;
 image : TMagRadiologyImage;
begin
  if FStudyHolder <> nil then
  begin
    for i := 0 to FStudyHolder.RadiologyStudies.Count - 1 do
    begin
      study := FStudyHolder.RadiologyStudies[i];
      if study <> nil then
      {
      begin
        for j := 0 to study.Images.Count - 1 do
        begin
          image := study.images[j];
          (*
          FreeAndNil(image.RadiologyImage);
          FreeAndNil(image.DicomData);
          image.Img := nil; // set to nil, might be referenced elsewhere
          // don't free the TImageData since it might be used elsewhere
          *)
          FreeAndNil(image);
        end;
        FreeAndNil(study.Images); // free the list
        FreeAndNil(study.RootImg); // rootImg is being copied so free it
      end;
      }
        FreeAndNil(study);
    end;
    FreeAndNil(FStudyHolder);
  end;

  if FLut <> nil then
  begin
    FreeAndNil(FLut);
  end;
  if FDicomHeaderLoader <> nil then
  begin
    FreeAndNil(FDicomHeaderLoader);
  end;
end;

function FindNearestImage(ScoutImage : TMagRadiologyImage;
  Study : TMagRadiologyStudy; x, y : integer;
  HeaderSeriesNumber : real; DatabaseSeriesNumber : String) : TMagRadiologyImage;
var
  radiologyImages : array of IRadiologyImage;
  img : TMagRadiologyImage;
  i : integer;
  nearestImage : IRadiologyImage;
  userData : String;
  radiologyImage : TRadiologyImage;

  seriesImages : TList;

begin
  result := nil;

  // need to find only the images in the current series to include in searching
  // for the nearest image
  seriesImages := TList.Create;
  for i := 0 to study.Images.Count - 1 do
  begin
    img := study.Images[i];
    if img.Img.DicomSequenceNumber <> '' then
    begin
      if img.Img.DicomSequenceNumber = DatabaseSeriesNumber then
      begin
        seriesImages.add(img.RadiologyImage);
        continue;
      end
      else
      begin
        // do not include this image in the group
        continue;
      end;
    end;
    if img.DicomData.Seriesno > 0.0 then
    begin
      if img.DicomData.Seriesno = HeaderSeriesNumber then
      begin
        seriesImages.Add(img.RadiologyImage);
        continue;
      end
      else
      begin
        // do not include this image in the group
        continue;
      end;
    end;
    // if we get to here then no series is specified so include this image
    seriesImages.add(img.RadiologyImage);
  end;

  SetLength(radiologyImages, seriesImages.Count);
  for i := 0 to seriesImages.Count - 1 do
  begin
    radiologyImage := seriesImages[i];
    radiologyImages[i] := radiologyImage.DefaultInterface;
  end;
    

  {
  SetLength(radiologyImages, study.Images.Count);

  for i := 0 to study.Images.Count - 1 do
  begin
    img := study.Images[i];
    radiologyImages[i] := img.RadiologyImage.DefaultInterface;
  end;
  }
  MagAppMsg('', 'Finding nearest image close to points (' + inttostr(x) + ', ' +
    inttostr(y) + ') in study [' + study.RootImg.Mag0 + ']', MAGMSGDebug);

  FLut.GetNearestImage(ScoutImage.RadiologyImage.DefaultInterface,
    radiologyImages, x, y, nearestImage);
  if nearestImage = nil then
    exit;

  userData := nearestImage.UserData;

  for i := 0 to study.Images.Count - 1 do
  begin
    img := study.images[i];
    if img.DicomData.DicomDataSource = userData then
    begin
      result := img;
      exit;
    end;
  end;
end;

function GetXRefLine(sliceImage, scoutImage : TMagRadiologyImage;
  sliceStudy : TMagRadiologyStudy) : TMagScoutLine;
var
  planeId : integer;
  line : olevariant;
  success : integer;
  scoutLine, edge1, edge2 : TMagLinePoints;
  i : integer;
  img : TMagRadiologyImage;
  seriesImages : TList;
  dicomSequenceNumber : String;
  seriesNumber : real;
  firstSeriesImage, lastSeriesImage : TMagRadiologyImage;
begin
  result := nil;
  MagAppMsg('', 'Determining XRefLine for images [' + sliceImage.Img.Mag0 + '] and [' + scoutImage.Img.Mag0 + ']', MAGMSGDebug);

  FLut.GetXRefLine(sliceImage.RadiologyImage.DefaultInterface,
    scoutImage.RadiologyImage.DefaultInterface, success, planeId, line);

  // success <= 0 is an error, return null
  if success <= 0 then
    exit;

  // this is the scout line to draw
  scoutLine := TMagLinePoints.Create(TMagPoint.Create(line[0], line[1]), TMagPoint.Create(line[2], line[3]));
  edge1 := nil;
  edge2 := nil;

  // JMW 5/31/2013 P131 - now want to find the range of the scout lines in the
  // current series
  // Need to find the images in the sliceStudy that contains sliceImage and then
  // find the range for those images to draw the range lines
  if sliceStudy <> nil then
  begin
    seriesImages := TList.Create;
    dicomSequenceNumber := sliceImage.Img.DicomSequenceNumber;
    seriesNumber := sliceImage.DicomData.Seriesno;
    for i := 0 to sliceStudy.Images.Count - 1 do
    begin
      img := sliceStudy.Images[i];
      if dicomSequenceNumber <> ''  then
      begin
        if dicomSequenceNumber = img.Img.DicomSequenceNumber then
        begin
          seriesImages.add(img);
          continue;
        end
        else
        begin
          continue;
        end;
      end
      else if seriesNumber > 0.0 then
      begin
        if seriesNumber = img.DicomData.Seriesno then
        begin
          seriesImages.add(img);
          continue;
        end
        else
        begin
          continue;
        end;
      end
      else
      begin
        // both values for the series are missing, include this image
        seriesImages.Add(img);
      end;

    end; {end for}

    firstSeriesImage := nil;
    lastSeriesImage := nil;
    if seriesImages.Count > 0 then
    begin
      firstSeriesImage := seriesImages[0];
      lastSeriesImage := seriesImages[seriesImages.Count - 1];

      // need to figure out if the first or last is the same as the slice
      if firstSeriesImage.Img.IsSame(sliceImage.Img) then
        firstSeriesImage := nil;
      if lastSeriesImage.Img.IsSame(sliceImage.Img) then
        lastSeriesImage := nil;

      if firstSeriesImage <> nil then
      begin
        FLut.GetXRefLine(firstSeriesImage.RadiologyImage.DefaultInterface,
          scoutImage.RadiologyImage.DefaultInterface, success, planeId, line);
        if success > 0 then
        begin
          edge1 := TMagLinePoints.Create(TMagPoint.Create(line[0], line[1]), TMagPoint.Create(line[2], line[3]));
        end;
      end;
      if lastSeriesImage <> nil then
      begin
        FLut.GetXRefLine(lastSeriesImage.RadiologyImage.DefaultInterface,
          scoutImage.RadiologyImage.DefaultInterface, success, planeId, line);
        if success > 0 then
        begin
          edge2 := TMagLinePoints.Create(TMagPoint.Create(line[0], line[1]), TMagPoint.Create(line[2], line[3]));
        end;
      end;


    end;
  end;

  result := TMagScoutLine.Create(scoutLine, edge1, edge2);
end;

{
  A helper method to get the XRef line. The selected image should be the image
  the user clicked on. The CurrentImage is the image to try to draw the
  intersection on.
}
function GetXRefLine(SelectedImage, SelectedRootImage, CurrentImage,
  CurrentRootImage : TImageData) : TMagScoutLine;
var
  study, currentStudy : TMagRadiologyStudy;
  selectedRadiologyImage, scoutRadiologyImage : TMagRadiologyImage;
  currentScoutImage : TImageData;
begin
  result := nil;
  // find the study associated with the images in the scout window
  study := GetStudyHolder().getStudy(CurrentRootImage);
  currentStudy := GetStudyHolder().getStudy(SelectedRootImage);
  // find the radiology image objects in the study for the selected image and the scout image
  // they should be in the same study or these two are not really associated and we can stop

  currentScoutImage := CurrentImage;
  // don't want to draw if they are the same image
  if not selectedImage.IsSame(currentScoutImage) and
    (study <> nil) and
    (currentStudy <> nil) then
  begin
    selectedRadiologyImage := currentStudy.FindRadiologyImage(selectedImage);
    scoutRadiologyImage := study.FindRadiologyImage(currentScoutImage);
    if (selectedRadiologyImage <> nil) and (scoutRadiologyImage <> nil) then
    begin
      try
        // this might throw an exception if the images don't correspond
        result := GetXRefLine(selectedRadiologyImage,
          scoutRadiologyImage, currentStudy);
      except
        on E : Exception do
        begin
          MagAppMsg('', 'Exception calculating scout line, ' + e.Message, MAGMSGDebug);
        end;
      end;
    end;
  end;
end;

Constructor TMagRadiologyStudy.Create(RootImg : TImageData; Images : TList);
begin
  self.RootImg := RootImg;
  self.Images := Images;
end;

Destructor TMagRadiologyStudy.Destroy;
var
  j : integer;
  image : TMagRadiologyImage;
begin
  if self.Images <> nil then
  begin
    for j := 0 to self.Images.Count - 1 do
    begin
      image := self.images[j];
      FreeAndNil(image);
    end;
    FreeAndNil(self.Images); // free the list
  end;
  if self.RootImg <> nil then
    FreeAndNil(self.RootImg); // rootImg is being copied so free it
end;

function TMagRadiologyStudy.FindRadiologyImage(IObj : TImageData) : TMagRadiologyImage;
var
  i : integer;
  curImg : TMagRadiologyImage;
begin
  result := nil;
  for i := 0 to self.Images.Count - 1 do
  begin
    curImg := self.Images[i];
    if curImg.Img.IsSame(IObj) then
    begin
      result := curImg;
      exit;
    end;
  end;
end;

Constructor TMagRadiologyImage.Create(Img : TImageData; DicomData : TDicomData;
  RadiologyImage : TRadiologyImage; Index : Integer);
begin
  self.Img := Img;
  self.RadiologyImage := RadiologyImage;
  self.DicomData := DicomData;
  self.Index := index;
end;

Destructor TMagRadiologyImage.Destroy;
begin
  if self.RadiologyImage <> nil then
    FreeAndNil(self.RadiologyImage);
  if self.DicomData <> nil then
    FreeAndNil(self.DicomData);
  // img is now being copied so need to free it
  if self.Img <> nil then
    FreeAndNil(self.Img);
//  self.Img := nil; // set to nil, might be referenced elsewhere
end;

Constructor TMagRadiologyStudyHolder.Create();
begin
  self.RadiologyStudies := TList.Create;
end;

procedure TMagRadiologyStudyHolder.AddUniqueStudy(Study : TMagRadiologyStudy);
var
  i : integer;
  curStudy : TMagRadiologyStudy;
  newRootImg : TImageData;
  curRootImg : TImageData;
begin
  curStudy := nil;
  newRootImg := Study.RootImg;
  for i := 0 to RadiologyStudies.Count - 1 do
  begin
    curStudy := RadiologyStudies[i];
    curRootImg := curStudy.RootImg;
    if curRootImg.IsSame(newRootImg) then
    begin
       // study already in list, do nothing
      exit;
    end
    else
    begin
      curStudy := nil; // nil this out for the next loop
    end;
  end;

  if curStudy = nil then
  begin
    RadiologyStudies.Add(study);
  end;
end;

function TMagRadiologyStudyHolder.getStudy(RootImg : TImageData) : TMagRadiologyStudy;
var
  curStudy : TMagRadiologyStudy;
  i : integer;
begin
  result := nil;
  for i := 0 to RadiologyStudies.Count - 1 do
  begin
    curStudy := RadiologyStudies[i];
    if curStudy.RootImg.IsSame(RootImg) then
    begin
      result := curStudy;
      exit;
    end;
  end;  
end;

{ Helper method to get the current status of what has been loaded }
function TMagRadiologyStudyHolder.GetStatus() : String;
var
  curStudy : TMagRadiologyStudy;
  i : integer;
begin
  result := '';
  result := inttostr(RadiologyStudies.Count) + ' studies';
  for i := 0 to RadiologyStudies.Count - 1 do
  begin
    curStudy := RadiologyStudies[i];
    result := result + #13#10 + 'RootImage: ' + curStudy.RootImg.Mag0;
  end;
  curStudy := nil;
end;

end.
