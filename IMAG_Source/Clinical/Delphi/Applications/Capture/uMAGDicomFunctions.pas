Unit uMAGDicomFunctions;

Interface

Uses
  SysUtils,
  Classes,
  Forms,
  Inifiles,
  cMagPat,
  Trpcb,
  Fmcmpnts,
  MagFMComponents,
  cmag4VGear ,
   GearFORMATSlib_TLB,
 GearCORElib_TLB
//  GEARLib_TLB

;

//SOP Common Module
Function Get_Instance_Creation_Date(ImageFileName: string): String;
Function Get_Instance_Creation_Time(ImageFileName: string): String;
Function Get_SOP_Class_UID(SOP: String): String;
Function Get_SOP_Instance_UID(StudyUID, Series: String; ImageCTR: Integer): String;

//Patient Module
Function Get_Patients_Name(Patient: TMag4Pat): String;
Function Get_Patient_ID(Patient: TMag4Pat): String;
Function Get_Patients_Birth_Date(Patient: TMag4Pat; Broker: TRPCBroker): String;
Function Get_Patients_Sex(Patient: TMag4Pat): String;
//Function Get_Other_Patient_IDs(Patient: TMag4Pat): String;
Function Get_Other_Patient_IDs(Patient: TMag4Pat; Broker: TRPCBroker): String;

//General Study Module
Function Get_Study_Date(ConsultStr: String): String;
Function Get_Study_Time(ConsultStr: String): String;
Function Get_Accession_Number(ConsultStr: String): String;
Function Get_Referring_Physicians_Name(ConsultStr: String): String;
Function Get_Study_ID(ConsultStr: String): String;

//General Series Module
Function Get_Series_Date: String;
Function Get_Series_Time: String;

//General Equiptment Module
Function Get_Manufacturer: String;
Function Get_Institution_Name: String;
Function Get_Station_Name: String;
Function Get_Manufacturers_Model_Name: String;
Function Get_Software_Version: String;

//Acquisition Context Module
Function Get_Acquisition_Context_Description(SOP: String): String;

//General Image Module
Function Get_Acquisition_Date(ImageFileName: string): String;
Function Get_Acquisition_Time(ImageFileName: string): String;
Function GetPatientOrientation(SOP: string): string;

//Image Pixel Module
Function Get_Rows(mg1x: TMag4VGear): String;
Function Get_Columns(mg1x: TMag4VGear): String;
Function Get_Pixel_Spacing(mg1x: TMag4VGear): String;
Function Get_Pixel_Aspect_Ratio: String;

//VL Image Module
Function Get_Image_Type: String;
Function Get_Content_Time(ImageFileName: string): String;
Function Get_Samples_Per_Pixel(mg1x: TMag4VGear): String;
Function Get_Photometric_Interpretation(mg1x: TMag4VGear): String;
Function Get_Planar_Configuration: String;
Function Get_Bits_Allocated(mg1x: TMag4VGear): String;
Function Get_Bits_Stored(mg1x: TMag4VGear): String;
Function Get_High_Bit(mg1x: TMag4VGear): String;
Function Get_Pixel_Representation(mg1x: TMag4VGear): String;
Function Get_Lossy_Image_Compression(mg1x: TMag4VGear): String;

//Misc
Function Get_Modality(SOP: string): String;
Function Get_Acquisition_Context_Sequence: String;

Function GenerateStudyUIDAndSeriesNum(Broker: TRPCBroker; DFN, ConsultIEN: String; Out StudyUID, SeriesNum: String): String;

Implementation

Uses
  Umagutils8,
  Magfileversion,
  UMagDefinitions,
  Magguini;

Const
  MMperInch = 0.393700787402;

Function RemoveLeadZerosWithNonZeroTrail(s: String): String;
Begin
  Result := s;
  If Length(Result) < 2 Then Exit;
  If (Result[1] = '0') And (Result[2] <> '0') Then
    Result := Copy(Result, 2, Length(Result) - 1);
End;

//1^1.2.840.113754.1.106.660.123.321^20090922.171851.0

Function GenerateStudyUIDAndSeriesNum(Broker: TRPCBroker; DFN, ConsultIEN: String; Out StudyUID, SeriesNum: String): String;
Var
  sResult: String;
Begin
  StudyUID := emptystr;
  SeriesNum := emptystr;
  Broker.REMOTEPROCEDURE := 'MAG3 TELEREADER DICOM UID';
  Broker.PARAM[0].PTYPE := List;
  Broker.PARAM[0].Value := '.x';
  Broker.PARAM[0].Mult['"DFN"'] := DFN;
  Broker.PARAM[0].Mult['"ACNUM"'] := ConsultIEN;
  sResult := Broker.STRCALL;
  If sResult[1] = '0' Then Exit; //error during rpc call
  StudyUID := MagPiece(sResult, '^', 2);
  SeriesNum := MagPiece(sResult, '^', 3);
  SeriesNum := Copy(StringReplace(SeriesNum, '.', '', [RfReplaceAll]), 1, 16);
End;

Function GetFieldValueByIEN(Broker: TRPCBroker; FileNumber, FieldNumber, Ien: String; bExternal: Boolean): String;
Var
  FMGets: TMagFMGets;
Begin
  FMGets := TMagFMGets.Create(Nil);
  Try
    FMGets.RPCBroker := Broker;
    FMGets.FileNumber := FileNumber;
    FMGets.AddField(FieldNumber);
    FMGets.IENS := Ien + ',';
    FMGets.GetsFlags := [gfExternal, gfInternal];
    FMGets.GetData;
    If bExternal Then
      Result := FMGets.GetField(FieldNumber).FMDBExternal
    Else
      Result := FMGets.GetField(FieldNumber).FMDBInternal;
  Finally
    FreeAndNil(FMGets);
  End;
End;

Function GetImageDate(ImageFileName: string): Tdatetime;
Var
  FAge: Integer;
Begin
  FAge := FileAge(ImageFileName);
  Result := FileDateToDateTime(FAge);
End;

{* SOP Common Module *}

Function Get_Instance_Creation_Date(ImageFileName: string): String;
Begin
  Result := Formatdatetime('YYYYMMDD', GetImageDate(ImageFileName));
End;

Function Get_Instance_Creation_Time(ImageFileName: string): String;
Begin
  Result := Formatdatetime('HHNNSS"."ZZ', GetImageDate(ImageFileName));
End;

Function Get_SOP_Class_UID(SOP: String): String;
Begin
  If SOP = 'TELEDERM' Then
    Result := '1.2.840.10008.5.1.4.1.1.77.1.4'
  Else
    Result := 'unknown';
End;

Function Get_SOP_Instance_UID(StudyUID, Series: String; ImageCTR: Integer): String;
Begin
  Result := StudyUID + '.' + Series + '.' + Inttostr(ImageCTR);
End;

{* Patient Module *}

Function Get_Patients_Name(Patient: TMag4Pat): String;
Var
  s, sLast, sRest: String;
  iPos: Integer;
Begin
  s := Patient.M_PatName;
  iPos := Pos(',', s);
  sLast := Copy(s, 1, iPos - 1);
  sRest := Copy(s, iPos + 1, Length(s) - iPos);
  Result := sLast + '^' + StringReplace(sRest, ' ', '^', [RfReplaceAll]);
End;

Function Get_Patient_ID(Patient: TMag4Pat): String;
Begin
  Result := Patient.M_SSN;
End;

Function Get_Patients_Birth_Date(Patient: TMag4Pat; Broker: TRPCBroker): String;
Var
  sDOB, sMonth, sDay, sYear: String;
Begin
  sDOB := GetFieldValueByIEN(Broker, '2', '.03', Patient.M_DFN, True); //DOB needs to requeried because RPC call used to load patient object has 2 year date
  sMonth := Copy(sDOB, 1, 2);
  sDay := Copy(sDOB, 4, 2);
  sYear := Copy(sDOB, 7, 4);
  Result := sYear + sMonth + sDay;
End;

Function Get_Patients_Sex(Patient: TMag4Pat): String;
Begin
  Result := Patient.M_Sex;
End;

{Function Get_Other_Patient_IDs(Patient: TMag4Pat): String;
Begin
  Result := Patient.M_ICN;
End;}

Function Get_Other_Patient_IDs(Patient: TMag4Pat; Broker: TRPCBroker): String;
Begin
  result := '';
  Broker.RemoteProcedure := 'VAFCTFU CONVERT DFN TO ICN';
  Broker.Param[0].Value := Patient.M_DFN;
  Broker.Param[0].PType := literal;
  result := Broker.strCall;
End;

{* General Study Module *}

//Consult ID^Consult Request Date^Consult Time^Service^Procedure^Sending Provider - ConsultStr Layout
//159^08/25/2009^02:55:58^AUDIOLOGY CLINIC^^IMAGEPROVIDERONETWOSIX,ONETWOSIX|159 - ConsultStr Example

Function Get_Study_Date(ConsultStr: String): String;
Var
  TempDate: Tdatetime;
Begin
  TempDate := Strtodatetime(MagPiece(ConsultStr, '^', 2));
  Result := Formatdatetime('YYYYMMDD', TempDate);
End;

Function Get_Study_Time(ConsultStr: String): String;
Var
  TempDate: Tdatetime;
Begin
  TempDate := Strtodatetime(MagPiece(ConsultStr, '^', 3));
  Result := Formatdatetime('HHNNSS"."ZZ', TempDate);
End;

Function Get_Accession_Number(ConsultStr: String): String;
Begin
  Result := 'GMRC-' + MagPiece(ConsultStr, '^', 1);
End;

Function Get_Referring_Physicians_Name(ConsultStr: String): String;
Var
  s, sLast, sRest: String;
  iPos: Integer;
Begin
  s := MagPiece(ConsultStr, '^', 6);
  s := Copy(s, 1, Pos('|', s) - 1);
  iPos := Pos(',', s);
  sLast := Copy(s, 1, iPos - 1);
  sRest := Copy(s, iPos + 1, Length(s) - iPos);
  Result := sLast + '^' + StringReplace(sRest, ' ', '^', [RfReplaceAll]);
End;

Function Get_Study_ID(ConsultStr: String): String;
Begin
  Result := MagPiece(ConsultStr, '^', 1);
End;

{* General Series Module *}

Function Get_Series_Date: String;
Begin
  Result := Formatdatetime('YYYYMMDD', Date);
End;

Function Get_Series_Time: String;
Begin
  Result := Formatdatetime('HHNNSS"."ZZ', Time);
End;

Function Get_Modality(SOP: string): String;
Begin
  if SOP = 'TELEDERM' then
    Result := UpperCase('XC');
End;

{* General Equiptment Module *}

Function Get_Manufacturer: String;
Begin
  Result := 'VA Vista Imaging';
End;

Function Get_Institution_Name: String;
Begin
  Result := 'U.S. Department of Veterans Affairs';
End;

Function Get_Station_Name: String;
Var
  Ini: TIniFile;
Begin
  Ini := TIniFile.Create(GetConfigFileName);
  Try
    Result := Ini.ReadString('Workstation Settings', 'ID', 'Unknown');
  Finally
    Ini.Free;
  End;
  Result := Copy(Result, 1, 16);
End;

Function Get_Manufacturers_Model_Name: String;
Begin
  Result := Application.Title;
End;

Function Get_Software_Version: String;
Begin
  Result := MagGetFileVersionInfo(Application.ExeName);
End;

{* General Image Module *}

Function Get_Acquisition_Date(ImageFileName: string): String;
Begin
  Result := Formatdatetime('YYYYMMDD', GetImageDate(ImageFileName));
  ;
End;

Function Get_Acquisition_Time(ImageFileName: string): String;
Begin
  Result := Formatdatetime('HHNNSS"."ZZ', GetImageDate(ImageFileName));
End;

Function GetPatientOrientation(SOP: string): string;
Begin
  if SOP = 'TELEDERM' then result := '';
End;

{* Acquisition Context Module *}

Function Get_Acquisition_Context_Description(SOP: String): String;
Begin
  If SOP = 'TELEDERM' Then
    Result := 'Teledermatology'
  Else
    Result := 'unknown';
End;

Function Get_Acquisition_Context_Sequence: String;
Begin
  Result := '';
End;

{* Image Pixel Module *}

Function Get_Rows(mg1x: TMag4VGear): String;
Begin
  //Result := Inttostr(GEAR.ImageWidth);
//p129   Result := Inttostr(GEAR.ImageHeight);
  Result := Inttostr(mg1x.GetImageHeight) ;
End;

Function Get_Columns(mg1x: TMag4VGear): String;
Begin
  //Result := Inttostr(GEAR.ImageHeight);
//p129   Result := Inttostr(GEAR.ImageWidth);
  Result := Inttostr(mg1x.GetImageWidth);
End;

Function Get_Pixel_Spacing(mg1x: TMag4VGear): String;
Var
  x, y: Real;
Begin
//p129   x := GEAR.ImageXdpi / MMperInch;
//p129   y := GEAR.ImageYdpi / MMperInch;


{ TODO -o129 : xDpi, yDpi }
////  x := mg1x.  ImageXdpi / MMperInch;
///   y := mg1x.   ImageYdpi / MMperInch;



  Result := FloatTostr(x) + '\' + FloatTostr(y);
End;

Function Get_Pixel_Aspect_Ratio: String;
Begin
  Result := '1\1';
End;

{* VL Image Module *}

Function Get_Image_Type: String;
Begin
  Result := UpperCase('Original\Secondary');
End;

Function Get_Content_Time(ImageFileName: string): String;
Begin
  Result := Formatdatetime('HHNNSS"."ZZ', GetImageDate(ImageFileName));
End;

Function Get_Samples_Per_Pixel(mg1x: TMag4VGear): String;
Var
  i: Integer;
Begin
//p129
//  i := GEAR.Imagebitsperpixel;
i := mg1x.GetBitsPerPixel;
  If i <= 8 Then
    Result := '3' //color
  Else
    Result := '1'; //grayscale
End;

Function Get_Photometric_Interpretation(mg1x: TMag4VGear): String;
Begin
//p129   If GEAR.ImageType = 'JPG' Then
if mg1x.GetFileFormatID = IG_FORMAT_JPG then

    Result := 'YBR_FULL_442'
  Else
    Result := 'RGB';
End;

Function Get_Planar_Configuration: String;
Begin
  Result := '0';
End;

Function Get_Bits_Allocated(mg1x: TMag4VGear): String;
Var
  i: Integer;
Begin
//p129
//P129   i := GEAR.Imagebitsperpixel;
i := mg1x.GetBitsPerPixel;
  If i <= 8 Then
    Result := '8' //color
  Else
    Result := '16'; //grayscale
End;

Function Get_Bits_Stored(mg1x: TMag4VGear): String;
Begin
//p129
  Result := Inttostr(mg1x.GetBitsPerPixel);    //GEAR.Imagebitsperpixel
End;

Function Get_High_Bit(mg1x: TMag4VGear): String;
Begin
//p129
  Result := Inttostr(mg1x.GetBitsPerPixel - 1);    //GEAR.Imagebitsperpixel
End;

Function Get_Pixel_Representation(mg1x: TMag4VGear): String;
Begin
//p129  Result := Inttostr(Integer(GEAR.IsSigned));
  Result := Inttostr(Integer(mg1x.IsSigned));End;

Function Get_Lossy_Image_Compression(mg1x: TMag4VGear): String;
Begin
//p129
//  If GEAR.ImageType = 'JPG' Then
  If mg1x.GetFileFormatID =  IG_FORMAT_JPG Then
    Result := '01'
  Else
    Result := '00';
End;

End.
