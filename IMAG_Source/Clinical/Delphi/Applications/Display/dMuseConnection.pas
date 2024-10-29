Unit DMuseConnection;
{
  Package: EKG Display
  Date Created: 06/10/2003
  Site Name: Silver Spring
  Developers: Robert Graves
  Description: This is a wrapper for the MUSE com component.  This wrapper
                is needed for several reasons:
                1.  The MUSE component automatially attempts to connect
                to the server when the component is created.  We need
                to do a pre-authentication step before the MUSE component
                does this connection.
                2.  There are at least 2 versions of the MUSE dll that have
                been used in the past.  By dynamically loading the dll at
                runtime, we can connect to different versions of the dll.
                As of now, however we are only connecting to the latest
                MUSE dll (MUSEAPI5A.DLL).  If we do run into a case of needing
                to connect to the older dll, this can be updated easily to
                do so.
                3.  Connecting to multiple muse servers is not as simple a
                problem as it sounds.   Each time you connect to a muse server,
                the MUSE dll gets it's connection info from the win.ini.  You
                can not have multiple instances of the MUSE dll in memory with
                different connection info.  Each time you connect, you have to
                update the ini file with the correct connection info.  Then you
                create the instance of the dll in memory.  If you want to open
                up a second connection, you have to close and unload the first
                one.  The burden of calling the close method before opening a
                second connection is on the code that calls the open method.
                4.  The MUSE dll can not return all the tests for a patient
                on a particular server.  It requires the use of an array that is
                instantiated with a fixed lenght and passed to the dll for it to
                fill.  The GetTestList method takes care of this problem and
                gets all tests with a single call.
}
Interface

Uses
  Classes,
  cMagSecurity,
  MuseDeclarations
  ;

//Uses Vetted 20090929:FileCtrl, maggut1, Graphics, ExtCtrls, Forms, IniFiles, SysUtils, Dialogs, Windows

Type
  // Begin DEMO Mode Change
  TMagMuseBaseConnection = Class(TComponent)
  Public
    Connected: Boolean;
    Accessible: Boolean;
    Site: String;
    SiteID: Integer;
    Server: String;
    Volume: String;
    OutputFolder: String;
    ErrorMessage: String;

    Constructor Create(AOwner: TComponent); Override;
    Function GetTestList(PatientID: String; TestType: Integer): Tlist; Virtual; Abstract;
    Function GetTest(TestInfo: MUSE_TEST_INFORMATION_PTR; PatientID: String): ImgPage; Virtual; Abstract;
    Function ConstructFileName(TestInfo: MUSE_TEST_INFORMATION_PTR): String;
  Protected
    Function CreatePages(TestInfoPtr: MUSE_TEST_INFORMATION_PTR): ImgPage; Virtual; Abstract;
  End;
  // End DEMO Mode Change

  TMuseConnection = Class(TMagMuseBaseConnection)
  Private { Private declarations }
    LibHandle: THandle;
    HMUSE: Pointer;

    Mei_OpenMUSE: Tmei_OpenMUSE;
    Mei_CloseMuse: Tmei_CloseMUSE;
    Mei_TestsForPatient: Tmei_TestsForPatient;
    Mei_CreateOutputForTestInfo: Tmei_CreateOutputForTestInfo;
    Mei_CreateOutputForID: Tmei_CreateOutputForID;
    Mei_PatientNameFromID: Tmei_PatientNameFromID;

    Function LoadMuseDll(): Boolean;
    Procedure UpdateMuseINISettings();
    Function PreAuthenticate(): Boolean;
    Function CreatePages(TestInfoPtr: MUSE_TEST_INFORMATION_PTR): ImgPage; Override;

  Public { Public declarations }
{  //95
    Connected: boolean;
    Accessible: boolean;
    Site: String;
    SiteID: integer;
    Server: String;
    Volume: String;
    OutputFolder: String;
    ErrorMessage: String;
}//95
    MagFileSecurity: TMag4Security; // used for pre-authentication
  //95  ErrorMessage: String;
    Version: String;

    Constructor Create(AOwner: TComponent); Override;
    Destructor Destroy(); Override;
    Function Open(): Boolean;
    Procedure Close();
    Function GetTestList(PatientID: String; TestType: Integer): Tlist; Override;
    Function GetTest(TestInfo: MUSE_TEST_INFORMATION_PTR; PatientID: String): ImgPage; Override;
  //95 function ConstructFileName(TestInfo: MUSE_TEST_INFORMATION_PTR): string;
  End;
Const
  { File Output type definitions }
  OT_FAX = 1; { Group 3 Compliant Fax stored in an MEI bitmap dir    }
  OT_CDL = 2; { MEI commom display list                              }
  OT_PCX = 3; { not currently supported                              }
  OT_TIFF = 4; { TIFF Level 4 (B/W) only                              }
  OT_PCL5 = 5; { PCL5 bitmap - not currently operational              }
  OT_POSTSCRIPT = 6; { Level 2 Adobe Postscript                             }
  OT_WMF = 7; { Windows Metafiles stored in an MEI bitmap directory  }
  OT_JPEG = 8; { JPEG compressed images in MEI bitmap directory       }
  OT_BMP = 9; { Windows BMP images in MEI bitmap directory           }
  OT_EWMF = 10; { Windows enhanced metafile stored in MEI bitmap dir   }
  OT_PWMF = 11; { Aldus placeable metafile in MEI bitmap dir           }
  OT_PDF = 12; { Adobe Acrobat PDF format                             }
  OT_TEXT = 13; { ASCII output for MUSE Forms only                     }
  OT_HTML = 14; { HTML output for MUSE Forms only                      }
  OT_HTOP = 15; { Raw MMS Hilltop format                               }

 { Index definitions for signal record types }
  CSE_RESTING = 1;
  CSE_PACE = 2;
  CSE_HIRES = 3;
  CSE_STRESS = 4;
  CSE_HOLTER = 5;
  CSE_CATH = 6; { Cardiac CATH, includes PTCA, cardiac angio           }
  CSE_ECHO = 7; { Cardiac Ultrasound                                   }
  CSE_DEFIB = 8;
  CSE_DISCHARGE = 9; { Discharge Summary                                    }
  CSE_HISTORY = 10; { History and Physicals                                }
  CSE_EVR = 11; { Event Recorder Information                           }
  CSE_NUCLEAR = 12; { Nuclear Imaging                                      }
  CSE_STS = 13; { Society of Thoracic Surgeons                         }
  CSE_EP = 14; { Electrophysiology                                    }
  CSE_CPM = 15; { Chest Pain assessMent                                }
  CSE_ALLTESTS = -1;

Implementation
Uses
  Dialogs,
  Forms,
  Inifiles,
  SysUtils,
  Windows
  ;

Constructor TMagMuseBaseConnection.Create(AOwner: TComponent);
// initialize some internal stuff
Begin
  Inherited Create(AOwner);
  Accessible := True;
End;

Constructor TMuseConnection.Create(AOwner: TComponent);
// initialize some internal stuff
Begin
  Inherited Create(AOwner);
  MagFileSecurity := TMag4Security.Create(Self);
  Accessible := True;
End;

Destructor TMuseConnection.Destroy();
// clean up before destruction
Begin
  Close();
  MagFileSecurity.Free();
  FreeLibrary(LibHandle);
  Inherited Destroy();
End;

Function TMuseConnection.Open(): Boolean;
// pre-authenticate and open a connection to the server
Var
  Status: Smallint;
Begin
  If ((Not Connected) And (Accessible)) Then
  Begin
    Accessible := PreAuthenticate();
    If (Accessible) Then
    Begin
      UpdateMuseINISettings();
      If Not LoadMuseDll() Then
        Status := -1
      Else
        Status := Mei_OpenMUSE(@HMUSE, 0, 999, 9999, True, SiteID);
      If (Status = 0) Then
        Connected := True
      Else
      Begin
        If (Status = -1) And ((Version = '4A') Or (Version = '5A') Or (Version = '5B')) Then
          ErrorMessage := 'MUSE servers below version 5C are not supported.  MUSE Version is: ' + Version
        Else
          If (Status = -1) Then
            ErrorMessage := 'Invalid File : MUSEAPI.DLL  Call IRM to get an updated file.'
          Else
            ErrorMessage := 'Error connecting to MUSE Server \\' + Server + '\' + Volume + ': status =' + Inttostr(Status);
        Accessible := False;
      End;
    End;
  End;
  Result := Connected;
End;

Procedure TMuseConnection.Close();
// close the connection to the server and free the dll
Var
  Xmsg: String;
Begin
  If (Connected) Then
  Begin
    Mei_CloseMuse(@HMUSE, True);
    MagFileSecurity.MagCloseSecurity(Xmsg);
    Connected := False;
  End;
  FreeLibrary(LibHandle);
End;

Function TMuseConnection.GetTestList(PatientID: String; TestType: Integer): Tlist;
{
  Get the list of tests for this patient.  If you get the tests and the array is
  full, try to get the next set of tests in case there are more.
}
Var
  Numentries, Status: Smallint;
  TestList: Tlist;
  // MUSE API Maxes out at 19, so use a 19 element array
  UtestInfoBuffer: Array[1..19] Of MUSE_TEST_INFORMATION;
  MuseTime: MUSE_TIME;
  MuseDate: MUSE_DATE;
  MusePID: MUSE_PID;
  i: Integer;
  TestInfo: MUSE_TEST_INFORMATION_PTR;
  LowerBound: Integer;
  RecFile: File Of MUSE_TEST_INFORMATION; // DEMO Mode Change
  ApplicationDataFolder, ImgCacheDirectory: String;
Begin
  TestList := Nil;
  // Begin DEMO Mode Change
  ApplicationDataFolder := GetEnvironmentVariable('AppData');
  ImgCacheDirectory := ExtractFilePath(Application.ExeName) + 'Cache\';
  If ApplicationDataFolder <> '' Then
    ImgCacheDirectory := ApplicationDataFolder + '\icache\';
  AssignFile(RecFile, ImgCacheDirectory + PatientID + '.MuseTestList');
  Rewrite(RecFile);
  // End DEMO Mode Change
  // default these to -1 so we can get all tests for this patient
  MuseDate.Day := -1;
  MuseDate.Month := -1;
  MuseDate.Year := -1;
  MuseTime.Hundreths := -1;
  MuseTime.Second := -1;
  MuseTime.Minute := -1;
  MuseTime.Hour := -1;
  // initialize variables
  Numentries := 19;
  Status := 0;
  Strpcopy(@MusePID.ID, PatientID);
  LowerBound := 1;
//p149  //p122t14 4/26/12 Stuart Frank
//p149  UtestInfoBuffer[1].MeiPSIG := 0;   //initialize the first MeiPSIG so the API starts a fresh call (per GE 4/25/12)
  If Open() Then
  Begin
    TestList := Tlist.Create();
    While ((Numentries = 19) And (Status = 0)) Do // first time is always true
    Begin
      //p149 T 3,  moved to here from above.
      UtestInfoBuffer[1].MeiPSIG := 0;   //initialize the first MeiPSIG so the API starts a fresh call (per GE 4/25/12)
      Numentries := 19; // reset this to 19 in case we're on subsequent iterations
      Status := Mei_TestsForPatient(HMUSE, @MusePID, TestType, @MuseDate,
        @MuseTime, @UtestInfoBuffer, @Numentries);
      If (Status <> 0) Then
      Begin
        TestList := Nil;
        Self.ErrorMessage := 'MUSE Error: ' + Inttostr(Status);
      End
      Else
      Begin
        For i := LowerBound To Numentries Do
        Begin
          New(TestInfo);
          TestInfo^ := UtestInfoBuffer[i];
          Write(RecFile, UtestInfoBuffer[i]); // DEMO mode change
          TestList.Add(TestInfo);
        End;
        // if we got a full array of data, set the begin date to the date of the
        // last entry in the list.  The next iteration of the loop will use
        // this date/time so we can get the next set of data
        If (Numentries = 19) Then
        Begin
          // the first entry in the next list will be the last entry in this
          // list.  set the lower bound to 2 to skip that entry.
          LowerBound := 2;
          New(TestInfo);
          TestInfo^ := UtestInfoBuffer[19];
          MuseDate.Day := TestInfo.AcqDate.Day;
          MuseDate.Month := TestInfo.AcqDate.Month;
          MuseDate.Year := TestInfo.AcqDate.Year;
          MuseTime.Hundreths := TestInfo.AcqTime.Hundreths;
          MuseTime.Second := TestInfo.AcqTime.Second;
          MuseTime.Minute := TestInfo.AcqTime.Minute;
          MuseTime.Hour := TestInfo.AcqTime.Hour;
          FreeMem(TestInfo);
        End; // if
      End; // else
    End; // while
    Close();
  End; // if Open
  CloseFile(RecFile);
  Result := TestList;
End;

Function TMagMuseBaseConnection.ConstructFileName(TestInfo: MUSE_TEST_INFORMATION_PTR): String;
Var
  TempPtr: PChar;
  Temp: String;
Begin
  If (TestInfo.MeiPSIG <> 0) Then
    Result := Inttostr(TestInfo.MeiPSIG)
  Else
  Begin
    TempPtr := Addr(TestInfo.EdtFile.Name[1]);
    Temp := TempPtr;
    Temp := ChangeFileExt(ExtractFileName(Temp), '');
    Result := Temp;
  End;
End;

Function TMuseConnection.GetTest(TestInfo: MUSE_TEST_INFORMATION_PTR; PatientID: String): ImgPage;
// download the emf in their proprietary format and convert it into true
// metafiles
Var
  Status: Smallint;
  MusePID: MUSE_PID;
  OutputFileName: String;
  POutputFileName: PChar;
  TestFileInfo: ImgPage;
Begin
  If (Not Directoryexists(OutputFolder)) Then
    Forcedirectories(OutputFolder);
  OutputFileName := ConstructFileName(TestInfo);
  OutputFileName := OutputFolder + OutputFileName + '.muse';

  POutputFileName := Stralloc(Length(OutputFileName) + 1);
  Strpcopy(POutputFileName, OutputFileName);
  Strpcopy(@MusePID.ID, PatientID);
  Open();
  Status := Mei_CreateOutputForTestInfo(HMUSE, @MusePID, TestInfo,
    OT_EWMF, POutputFileName);
  Close();
  StrDispose(POutputFileName);
  If ((Status <> 0) And (Status <> 5006)) Then
    Showmessage(Inttostr(Status))
  Else
    TestFileInfo := CreatePages(TestInfo);
  Result := TestFileInfo
End;

Function TMuseConnection.PreAuthenticate(): Boolean;
// pre-authenticate before the MUSE dll attempts to make it's connection
Var
  PathtoOpen: String;
  Xmsg: String;
Begin
  (* open a connection to the muse share before loading the dll *)
  If Version = 'v7' Then
    Result := True //no need to preAuthenticate for MUSE v7
  Else
  Begin
    PathtoOpen := '\\' + Server + '\' + Volume;
    Result := MagFileSecurity.MagOpenSecurePath(PathtoOpen, Xmsg);
    If (Result = False) Then
      ErrorMessage := Xmsg;
  End;
End;

Function TMuseConnection.LoadMuseDll(): Boolean;
// load the dll into memory and attach to it's functions
Begin

  LibHandle := 0;
  If Version = 'v5' Then
    LibHandle := LoadLibrary('MUSEAPI5E.DLL');

  If Version = 'v7' Then
    LibHandle := LoadLibrary('MUSEAPI7.DLL');

  If LibHandle = 0 Then
    Result := False
  Else
// load the Dll into memory
  Begin
    @Mei_OpenMUSE := GetProcAddress(LibHandle, 'mei_OpenMUSE');
    @Mei_CloseMuse := GetProcAddress(LibHandle, 'mei_CloseMUSE');
    @Mei_PatientNameFromID := GetProcAddress(LibHandle, 'mei_PatientNameFromID');
    @Mei_TestsForPatient := GetProcAddress(LibHandle, 'mei_TestsForPatient');
    @Mei_CreateOutputForTestInfo := GetProcAddress(LibHandle, 'mei_CreateOutputForTestInfo');
    @Mei_CreateOutputForID := GetProcAddress(LibHandle, 'mei_CreateOutputForID');

    If @Mei_OpenMUSE = Nil Then
      RaiseLastWin32Error;
    If @Mei_CloseMuse = Nil Then
      RaiseLastWin32Error;
    If @Mei_PatientNameFromID = Nil Then
      RaiseLastWin32Error;
    If @Mei_TestsForPatient = Nil Then
      RaiseLastWin32Error;
    If @Mei_CreateOutputForTestInfo = Nil Then
      RaiseLastWin32Error;
    If @Mei_CreateOutputForID = Nil Then
      RaiseLastWin32Error;
    Result := True;
  End;
End;

Procedure TMuseConnection.UpdateMuseINISettings();
// save the MUSE connection data to the win.ini before loading the MUSE dll
Var
  Winini: TIniFile;
Begin
  Winini := TIniFile.Create('WIN.INI');
  Winini.Writestring('MUSE', 'MainServerName', '\\' + Server);
  Winini.Writestring('MUSE', 'MainVolName', '\' + Volume);
  Winini.Free();
End;

Function TMuseConnection.CreatePages(TestInfoPtr: MUSE_TEST_INFORMATION_PTR): ImgPage;
(*
  The MUSE documentation contradicts itself about weather the API outputs EMF or
  WMF files. In reality it doesn't actually create either WMF or EMF
  files.  It outputs a file with proprietary header information
  that describes the one or more EMF files contained within it.  We have to
  extract those EMF files from the original file and create real EMF files
  for later use.
*)
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
  BaseFileName, InputFileName, OutputFileName: String;
Begin
  (* open the original file and grab the header information *)
  BaseFileName := ConstructFileName(TestInfoPtr);
  InputFileName := OutputFolder + BaseFileName + '.muse';

  AssignFile(RecFile, InputFileName);
  Reset(RecFile);
  Read(RecFile, FileHeader);
  CloseFile(RecFile);
  For i := 1 To FileHeader.Pages Do
  Begin
    Rec := FileHeader.Recs[i];
    OutputFileName := OutputFolder
      + BaseFileName + '-' + Inttostr(i) + '.emf';

    (* Allocate a block of memory to store our metafile bits in *)
    GetMem(PImageBits, Rec.LSize);

    (* Open the file now declaring it as nothing but a series of bytes *)
    AssignFile(ByteFile, InputFileName); {RED 2/12/97}
    Reset(ByteFile, 1);
    Seek(ByteFile, Rec.Loffset);
    BlockRead(ByteFile, PImageBits^, Rec.LSize);
    CloseFile(ByteFile);

    (* Now write out the metafile as a separate file so delphi will put it into
       our picture for us *)
    AssignFile(OutFile, OutputFileName);
    Rewrite(OutFile, 1);
    BlockWrite(OutFile, PImageBits^, Rec.LSize);
    CloseFile(OutFile);

    (* Free up that memory *)
    FreeMem(PImageBits);
  End;
  Result := FileHeader;
End;

End.
