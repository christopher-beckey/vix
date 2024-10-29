Unit DMagMuseDemoConnection;

Interface

Uses
  Classes,
  DMuseConnection,
  MuseDeclarations
  ;

//Uses Vetted 20090929:FileCtrl, Dialogs, SysUtils, Forms

Type
  TMagMuseDemoConnection = Class(TMagMuseBaseConnection)
  Public
    Function GetTestList(PatientID: String; TestType: Integer): Tlist; Override;
    Function GetTest(TestInfo: MUSE_TEST_INFORMATION_PTR; PatientID: String): ImgPage; Override;
    Function CreatePages(TestInfoPtr: MUSE_TEST_INFORMATION_PTR): ImgPage; Override;
  End;

Implementation
Uses
  Forms,
  SysUtils
  ;

Procedure FileCopy(Const Sourcefilename, TargetFilename: String);
Var
  s, t: TFileStream;
Begin
  s := TFileStream.Create(Sourcefilename, FmOpenRead);
  Try
    t := TFileStream.Create(TargetFilename,
      FmOpenWrite Or FmCreate);
    Try
      t.CopyFrom(s, s.Size);
    Finally
      t.Free;
    End;
  Finally
    s.Free;
  End;
End;

Function TMagMuseDemoConnection.GetTestList(PatientID: String; TestType: Integer): Tlist;
Var
  TestList: Tlist;
  AppDirectory: String;
  EKGStudyListFileName: String;
  EKGStudyListFile: File Of MUSE_TEST_INFORMATION;
  EKGStudyInfo: MUSE_TEST_INFORMATION;
  EKGStudyInfoPtr: MUSE_TEST_INFORMATION_PTR;
Begin
  TestList := Tlist.Create();
  AppDirectory := ExtractFilePath(Application.ExeName);

  EKGStudyListFileName := AppDirectory + 'image\' + PatientID + '.MuseTestList';
  If (Not FileExists(EKGStudyListFileName)) Then
    EKGStudyListFileName := AppDirectory + 'image\500505000.MuseTestList';
  AssignFile(EKGStudyListFile, EKGStudyListFileName);
  Reset(EKGStudyListFile);
  While (Not Eof(EKGStudyListFile)) Do
  Begin
    Read(EKGStudyListFile, EKGStudyInfo);
    New(EKGStudyInfoPtr);
    EKGStudyInfoPtr^ := EKGStudyInfo;
    TestList.Add(EKGStudyInfoPtr);
  End;
  CloseFile(EKGStudyListFile);

  GetTestList := TestList;
End;

Function TMagMuseDemoConnection.GetTest(TestInfo: MUSE_TEST_INFORMATION_PTR; PatientID: String): ImgPage;
Var
  AppDirectory, OutputFileName: String;
  TestFileInfo: ImgPage;
Begin
  AppDirectory := ExtractFilePath(Application.ExeName);
  If (Not Directoryexists(OutputFolder)) Then
    Forcedirectories(OutputFolder);
  If (TestInfo.MeiPSIG <> 0) Then
    OutputFileName := Inttostr(TestInfo.MeiPSIG)
  Else
    OutputFileName := ChangeFileExt(ExtractFileName(TestInfo.EdtFile.Name), '');
  OutputFileName := OutputFileName + '.muse';
  FileCopy(AppDirectory + 'image\' + OutputFileName, OutputFolder + OutputFileName);
  OutputFileName := OutputFolder + OutputFileName;

  TestFileInfo := CreatePages(TestInfo);
  Result := TestFileInfo
End;

Function TMagMuseDemoConnection.CreatePages(TestInfoPtr: MUSE_TEST_INFORMATION_PTR): ImgPage;
Var
  RecFile: File Of ImgPage; (* variable to reference file as an ImgPage   *)
                                (* record structure                           *)
  ByteFile: File; (* variable to reference the file as a series *)
                                (* bytes--redundant and slow, but it works    *)
  OutFile: File; (* temporary output file for storage of       *)
                                (* metafile so that delphi will load it easily*)
  Rec: ImgRecord; (* structure holding first image record       *)
  PImageBits: Pointer; (* pointer to our metafile bits               *)
  FileHeader: ImgPage;
  i: Integer;
  BaseFileName, InputFileName, OutputFileName, AppDirectory: String;
Begin
  AppDirectory := ExtractFilePath(Application.ExeName);
  BaseFileName := ConstructFileName(TestInfoPtr);
  InputFileName := OutputFolder + BaseFileName + '.muse';

  AssignFile(RecFile, InputFileName);
  Reset(RecFile);
  Read(RecFile, FileHeader);
  CloseFile(RecFile);
  For i := 1 To FileHeader.Pages Do
  Begin
    OutputFileName := BaseFileName + '-' + Inttostr(i) + '.emf';
    FileCopy(AppDirectory + 'image\' + OutputFileName, OutputFolder + OutputFileName);
  End;
  Result := FileHeader;
End;

End.
