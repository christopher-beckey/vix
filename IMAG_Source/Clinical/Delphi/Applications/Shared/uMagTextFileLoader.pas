unit uMagTextFileLoader;
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
        ;;  Description: Utility to load DICOM header infromation from Text
        ;;    files. Put into a common place so it can be used from multiple
        ;;    locations in the code.
        ;;
        ;;+---------------------------------------------------------------------------------------------------+
*)

interface
uses sysutils, classes, uMagClasses, uMagUtils8, imaginterfaces;

function LoadTGAText(TxtFile: String) : TDicomData;

implementation

function LoadTGAText(TxtFile: String) : TDicomData;
Var
  LoadFile: Textfile;
  s: String;
  CurrentFile: String[130];
  Delim, LengthS: Integer;
  Desc, HdrData: String;
  Temp: String;
  Index: Integer;
  Data: Real;
  TXTfiletype: String;
  Delimiter: String;
  Tempsamples: Integer;
  strData : String;
Begin
  result := TDicomData.Create;
  result.ClearFields();

  If FileExists(TxtFile) Then
  Begin
    result.DicomDataSource := TxtFile;
    AssignFile(LoadFile, TxtFile);
    Reset(LoadFile);
    Tempsamples := 1;
    Try
      ReadLn(LoadFile, s);
      If Pos('Consult Information', s) > 0 Then
      Begin
        TXTfiletype := 'CLINICAL';
        Delimiter := ': ';
      End;
      If Pos('$$BEGIN DATA1', s) > 0 Then
      Begin
        TXTfiletype := 'DICOM';
        Delimiter := '=';
      End;
      Repeat
        ReadLn(LoadFile, s);
        Delim := Pos(Delimiter, s);
        Desc := Copy(s, 1, Delim - 1);
        LengthS := Length(s);
        HdrData := Copy(s, Delim + 1 + (Length(Delimiter) - 1), LengthS);
        If ((Pos('<unknown>', HdrData) = 0) And (Pos('<UNKNOWN>', HdrData) = 0)) Then
        Begin
          Try {protect against bad data}
            If Desc = 'Pt Name' Then result.PtName := HdrData; {CLINICAL}
            If Desc = 'Pt ID' Then result.PtID := HdrData; {CLINICAL}
            If Desc = 'PATIENTS_NAME' Then result.PtName := HdrData; {DICOM}
            If Desc = 'PATIENTS_ID' Then result.PtID := HdrData; {DICOM}
            If Desc = 'MODALITY' Then result.Modality := HdrData;
            If Desc = 'PIXEL_SPACING(1)' Then result.PixelSpace1 := Strtofloat(HdrData);
            If Desc = 'PIXEL_SPACING(2)' Then
            Begin
              result.PixelSpace2 := Strtofloat(HdrData);
            End;
            If Desc = 'PIXEL_SPACING(3)' Then result.PixelSpace3 := Strtofloat(HdrData);
            If Desc = 'HAUNSFIELD' Then result.Haunsfield := Strtoint(HdrData);
            If Desc = 'SLICE_THICKNESS' Then result.SliceThickness := Strtofloat(HdrData);
            If Desc = 'PATIENT_POSITION' Then result.Pt_Pos := HdrData;
            If Desc = 'LATERALITY' Then result.Laterality := HdrData;
            If Desc = 'STUDY_ID' Then
            Begin
              result.STUDY_ID := HdrData;
            End;
            If Desc = 'SLICE_LOCATION' Then
            Begin
              If Pos('<unknown>', s) = 0 Then result.SliceLoc := Strtofloat(HdrData);
            End;
            If Desc = 'RESCALE_INTERCEPT' Then result.Rescale_Int := Strtofloat(HdrData);
            If Desc = 'RESCALE_SLOPE' Then result.Rescale_Slope := Strtofloat(HdrData);
            If Desc = 'ROWS' Then result.Rows := Strtoint(HdrData);
            If Desc = 'COLUMNS' Then result.Columns := Strtoint(HdrData);
            If Desc = 'SERIES_NUMBER' Then result.Seriesno := Strtofloat(HdrData);
            If Desc = 'IMAGE_NUMBER' Then result.Imageno := HdrData;
            If Desc = 'BITS_STORED' Then result.Bits := Round(Strtofloat(HdrData)); {RED 10/24/01}
            If Desc = 'INSTANCE_NUMBER' Then result.Imageno := HdrData;
            If Desc = 'CONTRAST_BOLUS_AGENT' Then result.Contrast := HdrData;
            If Desc = 'PHOTOMETRIC_INTERPRETATION' Then result.Photometric := Trim(HdrData); {RED 03/21/04}
            If Desc = 'INTEGRATION_CONTROL_NUMBER' Then result.PatientICN := Trim(HdrData); {JMW 5/8/08}
            If Pos('0028,1050|Window Center', s) > 0 Then
            Begin
              Temp := MagPiece(s, '|1,1|', 2);
              result.Window_Center := Trunc(Strtofloat(MagPiece(s, '|', 4)));
            End;
            If Pos('0028,1051|Window Width', s) > 0 Then
            Begin
              result.Window_Width := Trunc(Strtofloat(MagPiece(s, '|', 4)));
            End;
            If Pos('0028,0106|Smallest Image Pixel Value', s) > 0 Then {RED 7/25/02}
            Begin
              result.Smallest_PixelVal := Trunc(Strtofloat(MagPiece(s, '|', 4)));
            End;
            If Pos('0028,0107|Largest Image Pixel Value', s) > 0 Then {RED 7/25/02}
            Begin
              result.Largest_PixelVal := Trunc(Strtofloat(MagPiece(s, '|', 4)));
            End;
            If Pos('0020,0020|Patient Orientation', s) > 0 Then
            Begin
              If Pos('|1,1|', s) > 0 Then result.PatOr1 := MagPiece(s, '|', 4);
              If Pos('|2,1|', s) > 0 Then result.PatOr2 := MagPiece(s, '|', 4);
            End;
            If Pos('0020,0037|Image Orientation (Patient)', s) > 0 Then
            Begin
              strData := MagPiece(s, '|', 4);
              Data := Strtofloat(strData);
              Temp := MagPiece(s, '|', 3);
              Index := Strtoint(MagPiece(Temp, ',', 1));
              result.ImageOr[Index] := Data;
              result.ImageOrientation[Index] := strdata;
            End; {end image orientation}
            If Pos('0018,1030|Protocol Name', s) > 0 Then
            Begin
              Temp := MagPiece(s, '|', 4);
              result.Protocol := Temp;
            End;
            If Pos('0020,1040|Position Reference Indicator', s) > 0 Then
            Begin
              Temp := MagPiece(s, '|', 4);
              result.Pos_Ref_Indicator := Temp;
            End;
            If Pos('0028,0002|Samples per Pixel', s) > 0 Then {RED 11-13-03}
            Begin {RED 11-13-03}
              Tempsamples := Strtoint(MagPiece(s, '|', 4)); {RED 11-13-03}
              result.Bits := (result.Bits * Tempsamples); {RED 11-13-03}
            End; {RED 11-13-03}
            If Pos('0008,1030|Study Description', s) > 0 Then {RED 11-13-03}
            Begin {RED 11-13-03}
              Temp := MagPiece(s, '^', 4); {RED 3-21-04}
              result.Studydesc := Temp;
            End;
            If Pos('0008,103E|Series Description', s) > 0 Then // JMW Patch 72 2/6/2007
            Begin
              Temp := MagPiece(s, '|', 4);
              result.SeriesDescription := Temp;
            End;
            If Pos('0008,2111|Derivation Description', s) > 0 Then
            Begin
              If Pos('Non-reversible compressed image', s) > 0 Then
              Begin
                Temp := MagPiece(s, '|', 4);
         // don't set ADICOMRec[winnum].Warning := 1 because this indicates FullRes option to be available
                result.Warning := 2; {if GE PACS irreversible compression has been used}
              End;
            End;

     // JMW 8/5/2009 P93T11 - look for the DICOM header key value instead
     // of specific string (might contain unimportant characters)
     // fixes remedy ticket #332548
            If Pos('0018,1164', s) > 0 Then
            Begin
              If Pos('1,1', MagPiece(s, '|', 3)) > 0 Then
              Begin
                Temp := MagPiece(s, '|', 4);
                result.ImagerPixelSpace1 := Strtofloat(Temp);
              End;
              If Pos('2,1', MagPiece(s, '|', 3)) > 0 Then
              Begin
                Temp := MagPiece(s, '|', 4);
                result.ImagerPixelSpace2 := Strtofloat(Temp);
              End;
            End;
            If Pos('0018,1110|Distance Source to Detector', s) > 0 Then
            Begin
              Temp := MagPiece(s, '|', 4);
              result.DistanceSourceToDetector := Strtofloat(Temp);
            End;
            If Pos('0018,1111|Distance Source to Patient', s) > 0 Then
            Begin
              Temp := MagPiece(s, '|', 4);
              result.DistancePatientToDetector := Strtofloat(Temp);
            End;
            If Pos('0018,1114|Magnification Factor', s) > 0 Then
            Begin
              Temp := MagPiece(s, '|', 4);
              result.MagnificationFactor := Strtofloat(Temp);
            End;
            If Pos('0008,0016|SOP Class UID', s) > 0 Then
            Begin
              Temp := MagPiece(s, '|', 4);
              result.SOPClassUid := Temp;
            End;

            // Patch 131, new fields for scout viewing
            If Pos('0020,0032|Image Position (Patient)', s) > 0 Then
            Begin
              strData := MagPiece(s, '|', 4);
              Temp := MagPiece(s, '|', 3);
              Index := Strtoint(MagPiece(Temp, ',', 1));
              result.ImagePosition[Index] := strData;
            End; {end image position}
            If Pos('0028,0030|Pixel Spacing', s) > 0 Then
            Begin
              strData := MagPiece(s, '|', 4);
              Temp := MagPiece(s, '|', 3);
              Index := Strtoint(MagPiece(Temp, ',', 1));
              result.PixelSpacing[Index] := strData;
            End;
            If Pos('0020,0052|Frame of Reference UID', s) > 0 Then
            Begin
              Temp := MagPiece(s, '|', 4);
              result.FrameOfReferenceUid := Temp;
            End; {end Frame of Reference UID}
            If Pos('0008,0008|Image Type', s) > 0 Then
            Begin
              strData := MagPiece(s, '|', 4);
              {
              Temp := MagPiece(s, '|', 3);
              Index := Strtoint(MagPiece(Temp, ',', 1));
              result.ImageType[Index] := strData;
              }
              if strData = 'LOCALIZER' then
                Result.IsImageTypeLocalizer := true;
            End;

          Except
            on e : Exception do
            begin
              MagAppMsg('', 'Exception loading TXT data from file [' +  TxtFile + '], ' + e.Message, MAGMSGDebug);
            end;
    {if an element can't be read, continue to the next}
          End; {end try}
        End; {end if doesn't contain ,<unknown>}
      Until Eof(LoadFile)
    Finally
      CloseFile(LoadFile);
  // JMW 2/3/2007 P72
  // the haunsfield and rescale intercept should only be used for CT images
      If Uppercase(result.Modality) <> 'CT' Then
      Begin
        result.Haunsfield := 0;
        result.Rescale_Int := 0.0;
      End;
//      end; {end try..finally}  {RED 03/17/03}

    End; {end try..finally}
  End
  Else
  Begin
    result.DicomDataSource := 'DOES NOT EXIST';
  End;

End;

end.
