unit cMagIGDicomHeaderLoader;
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
        ;;  Date created: May 2013
        ;;  Site Name:  Washington OI Field Office, Silver Spring, MD
        ;;  Developer:  Julian Werfel
        ;;  Description: AccuSoft ImageGear implementation to load DICOM header
        ;;    information.
        ;;
        ;;+---------------------------------------------------------------------------------------------------+
*)

interface

uses
  IMagDicomHeaderLoader, uMagClasses;

type
  TMagIGDicomHeaderLoader = class(TMagDicomHeaderLoader)
    Function LoadDicomHeader(Filename : String) : TDicomData; Override;

  end;

implementation

uses GearCORELib_TLB, GearMEDLib_TLB, sysUtils, iMagInterfaces, cMagIGManager;

{ For now this only loads the fields that are necessary for scout lines}
Function TMagIGDicomHeaderLoader.LoadDicomHeader(Filename : String) : TDicomData;
var
  CurrentPage: IGPage;
  CurrentMedPage: IGMedPage;
  len, i : integer;
  elem : IIGMedDataElem;
  curTag, temp : String;
begin
  result := nil;
  currentPage := nil;
  currentMedPage := nil;
  if not FileExists(filename) then
  begin
    MagAppMsg('', 'File [' + filename + '] does not exist, cannot load DICOM header from this file', magmsgDebug);
    exit;
  end;
  result := TDicomData.Create();
  result.DicomDataSource := filename;
  try
    try
      curTag := '';
      GetIGManager().IncrementComponentCount();
      CurrentPage := GetIGManager.IGCoreCtrl.CreatePage;
      CurrentMedPage := GetIGManager.IGMedCtrl.CreateMedPage(CurrentPage);

      GetIGManager.IGFormatsCtrl.LoadPageFromFile(CurrentPage, Filename, 0);

      If CurrentMedPage.IsDICOMStructurePresent(MED_STRUCTURE_TYPE_DATASET) Then
      Begin
        //0020,0032 - image position
        If CurrentMedPage.DataSet.MoveFind(MED_DCM_MOVE_LEVEL_FIXED, DCM_TAG_ImagePositionPatient) Then
        Begin
          curTag := '0020,0032';
          elem := CurrentMedPage.DataSet.CurrentElem;
          len := length(result.ImagePosition);
          if len > elem.ItemCount then
            len := elem.ItemCount;

          for i := 0 to len - 1 do
          begin
            result.ImagePosition[i + 1] := elem.String_[i];
          end;
        End;

        //0020,0037 - image orientation
        If CurrentMedPage.DataSet.MoveFind(MED_DCM_MOVE_LEVEL_FIXED, DCM_TAG_ImageOrientationPatient) Then
        Begin
          curTag := '0020,0037';
          elem := CurrentMedPage.DataSet.CurrentElem;
          len := length(result.ImageOrientation);
          if len > elem.ItemCount then
            len := elem.ItemCount;

          for i := 0 to len - 1 do
          begin
            result.ImageOrientation[i + 1] := elem.String_[i];
          end;
        End;

        //0028,0030 - pixel spacing
        If CurrentMedPage.DataSet.MoveFind(MED_DCM_MOVE_LEVEL_FIXED, DCM_TAG_PixelSpacing) Then
        Begin
          curTag := '0028,0030';
          elem := CurrentMedPage.DataSet.CurrentElem;
          len := length(result.PixelSpacing);
          if len > elem.ItemCount then
            len := elem.ItemCount;

          for i := 0 to len - 1 do
          begin
            result.PixelSpacing[i + 1] := elem.String_[i];
          end;
        End;

        //0020,0052 - Frame of reference UID
        If CurrentMedPage.DataSet.MoveFind(MED_DCM_MOVE_LEVEL_FIXED, DCM_TAG_FrameOfReferenceUID) Then
        Begin
          curTag := '0020,0052';
          result.FrameOfReferenceUid := CurrentMedPage.DataSet.CurrentElem.String_[0];
        End;

        //0028,0010 - rows
        If CurrentMedPage.DataSet.MoveFind(MED_DCM_MOVE_LEVEL_FIXED, DCM_TAG_Rows) Then
        Begin
          curTag := '0028,0010';
          result.Rows := CurrentMedPage.DataSet.CurrentElem.Long[0];
        End;

        //0028,0011 - cols
        If CurrentMedPage.DataSet.MoveFind(MED_DCM_MOVE_LEVEL_FIXED, DCM_TAG_Columns) Then
        Begin
          curTag := '0028,0011';
          result.Columns := CurrentMedPage.DataSet.CurrentElem.Long[0];
        End;

        If CurrentMedPage.DataSet.MoveFind(MED_DCM_MOVE_LEVEL_FIXED, DCM_TAG_ImageType) Then
        Begin
          curTag := '0008,0008';
          Temp := CurrentMedPage.DataSet.CurrentElem.OutputDataToString(0, -1, '\', 100);
          if Pos('LOCALIZER', temp) > 0 then
            result.IsImageTypeLocalizer := true;
        End;
      End;
    except
      on e : exception do
      begin
        MagAppMsg('', 'Exception reading from DICOM header for file [' + filename + '], Failed on tag [' + curTag + '], ' + e.Message, magmsgDebug);
        result := nil;
      end;
    end;
  finally
    if CurrentMedPage <> nil then
      FreeAndNil(currentMedPage);
    if CurrentPage <> nil then
      FreeAndNil(CurrentPage);
    GetIGManager().DecrementComponentCount();
  end;
end;

end.
