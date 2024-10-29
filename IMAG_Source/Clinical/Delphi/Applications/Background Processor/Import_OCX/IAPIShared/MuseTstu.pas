Unit Musetstu;
(*
        ;; +---------------------------------------------------------------------------------------------------+
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
        ;; +---------------------------------------------------------------------------------------------------+
 
*)

Interface

Uses
  Windows,
  Messages,
  SysUtils,
  Classes,
  Graphics,
  Controls,
  Forms,
  Dialogs,
  ExtCtrls,
  Stdctrls,
  Buttons,
  Spin,
  Mask,
  DBCtrls,
  Grids,
  Menus,
  Fmxutils,
  ComCtrls,
  Maggut1,
  MuseListOfPatientsu,
  MuseTestTypeu
  ,
  Inifiles,
  Printers,
  FileCtrl,
  Maggmsgu, {MsgWinu,}
  Maggut4,
  Magpositions,
  MuseDeclarations,
  cMagDBBroker, {magbroker,}
  DmSingle,
  EKGdlgU,
  Magguini;

Type
  ZoomFactor = Packed Record
    ZoomIn: String;
    ZoomOut: String;
  End; (* Zoom Factor *)

Type
  TSizingActions = (Zoom, Fitwidth, Fitheight);
Type
  SizingAction = Set Of TSizingActions;
Type
  TEKGWin = Class(TForm)
    Panel1: Tpanel;
    Panel2: Tpanel;
    ScrollBox1: TScrollBox;
    ECGDisplay: TImage;
    bbSettings: TBitBtn;
    bbHelp: TBitBtn;
    LbTestDesc: Tlabel;
    PrintDialog1: TPrintDialog;
    bbWidth: TBitBtn;
    bbHeight: TBitBtn;
    bbGrid: TBitBtn;
    bbPrevPage: TBitBtn;
    bbNextPage: TBitBtn;
    bbPrint: TBitBtn;
    PHide: Tpanel;
    Oldpaste: TEdit;
    PPagelist: Tpanel;
    cbPagelist: TComboBox;
    bPatient: TBitBtn;
    Lbpagehd: Tlabel;
    Lbpage: Tlabel;
    SaveDialog1: TSaveDialog;
    OpenDialog1: TOpenDialog;
    Memo1: TMemo;
    bOpenDemo: TBitBtn;
    bSaveEKG: TBitBtn;
    FileListBox1: TFileListBox;
    LbName: Tlabel;
    LbSSN: Tlabel;
    LbSSNdisp: Tlabel;
    PTestList: Tpanel;
    cbDemoTests: TComboBox;
    Lbtestcount: Tlabel;
    cbListOfTests: TComboBox;
    BitBtn1: TBitBtn;
    UbbNext14: TBitBtn;
    UbbALL: TBitBtn;
    PopupMenu1: TPopupMenu;
    Showmessages: TMenuItem;
    ClearMessages: TMenuItem;
    MPanel: Tpanel;
    MsgListBox: TListBox;
    Pmusemsg: Tpanel;
    ZoomTrack: TTrackBar;
    LbZoom: Tlabel;
    Panel3: Tpanel;
    PopupMenu2: TPopupMenu;
    Menableall: TMenuItem;
    cbSite: TComboBox;
    LbSite: Tlabel;

    Procedure FormClose(Sender: Tobject; Var action: TCloseAction);
    Procedure bbHelpClick(Sender: Tobject);
    Procedure SelectTestType(Aux: Integer);
    Procedure FormCreate(Sender: Tobject);
    Procedure bbSettingsClick(Sender: Tobject);
    Procedure bbZoominClick(Sender: Tobject);
    Procedure bbZoomOutClick(Sender: Tobject);
    Procedure bbWidthClick(Sender: Tobject);
    Procedure bbHeightClick(Sender: Tobject);
    Procedure bbGridClick(Sender: Tobject);
    Procedure bbPrevPageClick(Sender: Tobject);
    Procedure bbNextPageClick(Sender: Tobject);
    Procedure bbPrintClick(Sender: Tobject);
    Procedure cbPagelistClick(Sender: Tobject);
    Procedure UbbNext14Click(Sender: Tobject);
    Procedure UbbALLClick(Sender: Tobject);
    Procedure bPatientClick(Sender: Tobject);
    Procedure cbListOfTestsClick(Sender: Tobject);
    Procedure bOpenDemoClick(Sender: Tobject);
    Procedure cbDemoTestsClick(Sender: Tobject);
    Procedure bSaveEKGClick(Sender: Tobject);
    Procedure FormResize(Sender: Tobject);
    Procedure Panel2DragOver(Sender, Source: Tobject; x, y: Integer;
      State: TDragState; Var Accept: Boolean);
    Procedure FormDragOver(Sender, Source: Tobject; x, y: Integer;
      State: TDragState; Var Accept: Boolean);
    Procedure BitBtn1Click(Sender: Tobject);
    Procedure ShowmessagesClick(Sender: Tobject);
    Procedure ClearMessagesClick(Sender: Tobject);
    Procedure ZoomTrackChange(Sender: Tobject);
    Procedure MenableallClick(Sender: Tobject);
    Procedure FormDestroy(Sender: Tobject);

  Private { Private declarations }
    Procedure Debugmessage(s: String);

  Public { Public declarations }
    Procedure ChangeMuseSettings;
    Procedure WarningColor(Warn: Boolean);
    Procedure ClearCurPatient;
    Procedure SwitchListDisplay;
    Procedure OpenEKGPatient(s: String);
    Procedure Showmsgwin(s: String);
    Procedure Hidemsgwin;
    Procedure SetPage(i: Integer);
    Procedure ClearImage;
    Procedure ClearPage;
    Function Dispcsetype(Itype: Shortint): String;
    Procedure Displayimage(Desc, Name, SSN, TempEKG: String);
    Function CreateImage(Ttestinfoptr: MUSE_TEST_INFORMATION_PTR; TempEKG: String): Boolean;
    Procedure TestsForPatientclose;
    Procedure AddGridToMetaFile(Var GridMF: TMetaFile; Filename: String);
    Procedure DisplayImageAPI; {Procedure MuseListofPatientsclose;}

    Function Museconnect: Boolean;
    //function MuseConnectQuiet: boolean;   - not used anymore SAF 2/25/2000
    Procedure Musedisconnect;
    Function GetNameFromSSN(PatientID: String; Var PatientName: String): Boolean;
    Procedure FitToWidth;
    Procedure FitToHeight;
    Procedure ShowPagelist;
    Procedure ShowPage(Page: Integer);
    Procedure UShowTestsForPatient(PatientID, PatientName: String; Var TN, Tssn, Tssnd: Tlabel);
    Procedure UClearTestsList;
    Function Outformat(i: Integer): String;
    Procedure UDisableMore;
    Procedure UMoreTests;
    Procedure Showtestcount;
    Procedure TypeOfTestToShow(Var Test: Integer; Var Testdesc: String);
    Procedure LoadDemoFromDir(Tdir: String);
    Procedure HidePatientName;
    Procedure EnableButtonsforDemoEKG;
    Procedure OpenEKGDemo(Demodir: String);
    Procedure OpenImage(d: String; i: Integer);
    Procedure UInitList(Nomore: Boolean);
  End; (* TTopLevel *)

Var
  MUSESiteINI: byte;
  ImageWidth: Longint;
  ImageHeight: Longint;
  Utemptestinfoptr: MUSE_TEST_INFORMATION_PTR;

  {uTestsForPatient: TTestsForPatient;}
  UTestsList: Tlist;
  EKGWin: TEKGWin;
  CurrentPage, j, Global, Global2, Global3: Integer; (* variable to reference the current page     *)
  GridOn, DdeConn: Boolean;
  Printing: Boolean = False;
  Counter: Smallint;
  DaySave, Monthsave, Hundrethssave, Secondsave: Shortint;
  Yearsave, Minutesave, Hoursave: Smallint;
  MUSEConStatus: Integer;
  Lpnetresource1, Lpnetresource2, Lpnetresource3: TNetResourceA;
  LpszPassword1, LpszPassword2, LpszPassword3: LPSTR;
  LpszUsername1, LpszUsername2, LpszUsername3: LPSTR;
  DwFlags: DWORD;
  Msg: DWORD;
  Size: Integer;
  POutputFileName: PChar; (* Output filename                            *)
  TEKGfile: String;

  HMUSE: Pointer;
  FileHeader: ImgPage;
  {testInfoBuffer : array [1..100] of MUSE_TEST_INFORMATION ;}
  UtestInfoBuffer: Array[1..100] Of MUSE_TEST_INFORMATION;
  DemoBuffer: Array[1..100] Of MUSE_DEMOGRAPHIC;
  MuseTime: MUSE_TIME;
  MuseDate: MUSE_DATE;
  MusePID: MUSE_PID;
  MuseName: MUSE_NAME;
  Factor: ZoomFactor;

  (* Added the following for dynamic muse dll loading  SAF 1/24/2000 *)
  LibHandle: THandle;
  Mei_OpenMUSE: Tmei_OpenMUSE;
  Mei_CloseMuse: Tmei_CloseMUSE;
  Mei_TestsForPatient: Tmei_TestsForPatient;
  Mei_CreateOutputForTestInfo: Tmei_CreateOutputForTestInfo;
  Mei_CreateOutputForID: Tmei_CreateOutputForID;
  Mei_PatientNameFromID: Tmei_PatientNameFromID;
//  mei_PatientIDFromName: Tmei_PatientIDFromName;  - this one is in MuseListOfPatientsu

 (* end of changes for muse dll loading SAF 1/24/2000 *)

Const
  StartupFlag: Boolean = False;
  CloseFromMag: Boolean = False;
  Startfrommag: Boolean = False;
  Forceclose: Boolean = False;
  LastSizingAction: SizingAction = [Zoom];
    { Success and Error codes returned by API functions }
  MUSE_SUCCESS = 0;
  MUSE_MEMORY_ALLOCATION_ERROR = 100;
  MUSE_APIHANDLE_NOT_INITIALIZED = 101;
  MUSE_APIHANDLE_NOT_VALID = 102;
  MUSE_INVALID_FILENAME = 103;

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

  { Output type definitions }
  (*OT_POSTSCRIPT = 1;    { Level 2 Adobe Postscript                            }
  OT_WMF        = 2;    { Windows Metafiles stored in an MEI bitmap directory }
  OT_CDL        = 3;    { MEI commom display list                             }
  OT_FAX        = 4;    { Group 3 Compliant Fax stored in an MEI bitmap dir   }
  OT_PCL5       = 5;    { PCL5 bitmap - not currently operational             }
  OT_BMP        = 6;    { Windows BMP images in MEI bitmap directory          }
  OT_PCX        = 7;    { not currently supported                             }
  OT_JPEG       = 8;    { JPEG compressed images in MEI bitmap directory      }
  OT_TEXT       = 9;    { ASCII output for MUSE Forms only                    }
  OT_HTML       = 10;   { HTML output for MUSE Forms only                     }
  OT_EWMF       = 11 ;  { Windows enhanced metafile stored in MEI bitmap dir  }*)
  OT_FAX = 1; { Group 3 Compliant Fax stored in an MEI bitmap dir   }
  OT_CDL = 2; { MEI commom display list                             }
  OT_PCX = 3; { not currently supported                             }
  OT_TIFF = 4; { TIFF Level 4 (B/W) only                             }
  OT_PCL5 = 5; { PCL5 bitmap - not currently operational             }
  OT_POSTSCRIPT = 6; { Level 2 Adobe Postscript                            }
  OT_WMF = 7; { Windows Metafiles stored in an MEI bitmap directory }
  OT_JPEG = 8; { JPEG compressed images in MEI bitmap directory      }
  OT_BMP = 9; { Windows BMP images in MEI bitmap directory          }
  OT_EWMF = 10; { Windows enhanced metafile stored in MEI bitmap dir  }
  OT_PWMF = 11; { Aldus placeable metafile in MEI bitmap dir          }
  OT_PDF = 12; { Adobe Acrobat PDF format                            }
  OT_TEXT = 13; { ASCII output for MUSE Forms only                    }
  OT_HTML = 14; { HTML output for MUSE Forms only                     }
  OT_HTOP = 15; { Raw MMS Hilltop format                              }

Implementation

Uses {patientlist, testspatients,}  MuseTestsForPatientu, {demodiru,} {MusePassword,}
  //fmagMain,
  Maggut9;

{$R *.DFM}

Function TEKGWin.Dispcsetype(Itype: Shortint): String;
Begin
  Case Itype Of
    1: Result := 'Resting';
    2: Result := 'PACE';
    3: Result := 'HIRES';
    4: Result := 'STRESS';
    5: Result := 'HOLTER';
    6: Result := 'CATH';
    7: Result := 'ECHO';
    8: Result := 'DEFIB';
    9: Result := 'DISCHARGE';
    10: Result := 'HISTORY';
    11: Result := 'EVR';
    12: Result := 'NUCLEAR';
    13: Result := 'STS';
    14: Result := 'EP';
    15: Result := 'CPM';
  Else
    Result := 'ALLTESTS';
  End; {case}
End;

Procedure TEKGWin.AddGridToMetaFile(Var GridMF: TMetaFile; Filename: String);
Var
  aMFC: TMetafileCanvas;
  aPen: TPen;
  Red, Green, Blue, PalIndex: byte;
 { status : word ;}
  {aRect : TRect ;}
  xx, Yy, Zz: Longint;
  aPalette: PLogPalette;
  CleanMF: TMetaFile;
  GridWidth, GridHeight: Integer;
Begin
  (* Tell the picture what picture it should display (note properties in
     example program *)
  (*****Sample Grid Drawing Code****--This code leaks memory!******)
  (* Create a palette that contains the color we want the grid to be.
     This is the standard internet palette *)
  GetMem(aPalette, (SizeOf(TLogPalette) + SizeOf(TPaletteEntry) * 256));
  aPalette^.PalVersion := $300; (* This number doesn't change *)
  aPalette^.PalNumEntries := 256; (* 8-bit palette *)
  (* Extract the system palette entries.  To prevent scrambling the base colors,
     you always want to get the system entries for the first 10 and last 10
     palette entries. *)
       {status :=} GetSystemPaletteEntries(Canvas.Handle, 0, 256,
    aPalette^.PalPalEntry[0]);
  {if (status = 0) then
    showerror('GetSystemPaletteEntries Failed status=' + IntToStr(status),
               mtError,[mbOK],0); (* If the device is non-palette, you may
                                     get 0.  In that case, you don't need to
                                     try to set the palette.  Just select the
                                     RGB color you want *) }
  PalIndex := 11; (* The first 10 and last 10 palette entries are reserved for
                      windows *)
  For Red := 0 To 5 Do
    For Blue := 0 To 5 Do
      For Green := 0 To 5 Do
      Begin
        aPalette^.PalPalEntry[PalIndex].PeRed := Red * $33;
        aPalette^.PalPalEntry[PalIndex].PeGreen := Green * $33;
        aPalette^.PalPalEntry[PalIndex].PeBlue := Blue * $33;
        aPalette^.PalPalEntry[PalIndex].PeFlags := 0;
        PalIndex := PalIndex + 1;
      End;
  CleanMF := TMetaFile.Create;
  CleanMF.LoadFromFile(Filename);
  GridMF.Height := CleanMF.Height;
  GridMF.Width := CleanMF.Width;
  aMFC := TMetafileCanvas.Create(GridMF, 0);
  (* If you need a palette, select it into the metafile canvas *)
  SelectPalette(aMFC.Handle, CreatePalette(aPalette^), False);
  RealizePalette(aMFC.Handle);
  FreeMem(aPalette); (* We don't need the memory for the palette any longer*)

  aPen := TPen.Create;
  aPen.Color := $02FFCCFF; (* very light pinkish color for 1mm grid lines *)
  aMFC.Pen := aPen;
  (* Draw the 1mm grid lines in a bounding box of 21000x27000--better yet, get
     the bounding box from the metafile itself or the image header.  This code
     is sample code and inefficient. *)
  GridWidth := CleanMF.Width Div 100;
  GridHeight := CleanMF.Height Div 100;
  If Printing = False Then
  Begin
    For xx := 0 To GridWidth Do
    Begin
    (* Avoid unnecessary work, check to see if this is a 5mm line and don't
       draw it *)
      aMFC.MoveTo(xx * 100, 5500); // set 5500 for 3/4 grid vertical minor lines
      aMFC.LineTo(xx * 100, CleanMF.Height);
    End;
    // set yy to 55 for 3/4 grid horizontal lines
    For Yy := 55 To GridHeight Do
    Begin
       (* ToDO: Skip 5mm lines *)
      aMFC.MoveTo(0, Yy * 100);
      aMFC.LineTo(CleanMF.Width, Yy * 100);
    End;
  End;
  If (PrintDottedGrid = True) And (Printing = True) Then
  Begin
    For xx := 0 To GridWidth Do
      For Zz := 5500 To CleanMF.Height Do
      Begin
        If Zz Mod 100 = 0 Then
          If Zz Mod 500 <> 0 Then
          Begin
            aMFC.MoveTo(xx * 100, Zz);
            aMFC.LineTo(xx * 100, Zz + 22);
          End;
      End;
  End;
  aPen.Color := $02CC99FF; (*a slightly darker pinkish for the 5mm grid lines*)
    {always change by incs of 33hex}
  aMFC.Pen := aPen;
  For xx := 0 To ((CleanMF.Width Div 10) * 2) Do
  Begin
    aMFC.MoveTo(xx * 500, 5500); // 3/4 grid vertical major lines
    aMFC.LineTo(xx * 500, CleanMF.Height);
  End;
  // set yy to 11 for 3/4 grid horizontal lines
  For Yy := 11 To ((CleanMF.Height Div 10) * 2) Do
  Begin
    aMFC.MoveTo(0, Yy * 500);
    aMFC.LineTo(CleanMF.Width, Yy * 500);
  End;

  (* Once the grid is placed, play the original metafile onto the canvas.  Do
     this later so that the waveforms and the text are written over the grid
     lines (not grid lines over the waveforms *)
  aMFC.Draw(0, 0, CleanMF);
  aPen.Free; {deselect first?}
  aMFC.Free;
End;
{''''''''}

Function TEKGWin.CreateImage(Ttestinfoptr: MUSE_TEST_INFORMATION_PTR; TempEKG: String): Boolean;
Var
  Status: Smallint; (* Success/error status from MUSE             *)

  Size: Integer;
  Msg: String;
 { aMF :TMetafile ;}
Begin
  Debugmessage('in Create Image');
  Debugmessage('tempekg = ' + TempEKG);
  Debugmessage('in Create Image ');
  Result := False;

  If Not Museconnect Then Exit;
  Screen.Cursor := crHourGlass;
  //ShowMsgWin('Creating Image from MUSE Data.  Please Wait...');
  Try
    Size := Length(TempEKG);
    POutputFileName := Stralloc(Size + 1);

    Strpcopy(POutputFileName, TempEKG);
    Status := Mei_CreateOutputForTestInfo(HMUSE, @MusePID, Ttestinfoptr,
      OT_EWMF, POutputFileName);
       //p94t8  GEK/  put in parenthsis and 5006 condition for Stuart. EKG
    If ((Status <> MUSE_SUCCESS) And (Status <> 5006)) Then
    Begin
      Case Status Of
        100: Msg := 'Memory allocation Error.';
        101: Msg := 'MUSEAPI Handle not properly initialized';
        102: Msg := 'MUSEAPI Handle Invalid';
        103: Msg := 'Bad Filename';
        104: Msg := 'MUSEAPI not authorized for this installation';
        1000..2000: Msg := 'Btrieve Error ' + Inttostr(Status - 1000) + ' consult Btrieve manual.';
        5001: Msg := 'Error 5001 - MUSE Report generator: Bad print request';
        5002: Msg := 'Error 5002 - MUSE Report generator: Unsupported output format';
        5003: Msg := 'Error 5003 - MUSE Report generator: Memory Allocation Error';
        5004: Msg := 'Error 5004 - MUSE Report generator: Bad data file (corrupt database)';
        5005: Msg := 'Error 5005 - MUSE Report generator: Error generation forms report';
        5006: Msg := 'Error 5006 - MUSE Report generator: Error generation waveform report';
        5007: Msg := 'Error 5007 - MUSE Report generator: Unknown error within Print Library';
        5008: Msg := 'Error 5008 - MUSE Report generator: Error Opening Necessary files';
        5009: Msg := 'Error 5009 - MUSE Report generator: Error Writing Necessary files';
        5010: Msg := 'Error 5010 - MUSE Report generator: Error with resource DLL in Windows 95';
        5011: Msg := 'Error 5011 - MUSE Report generator: No output pages were requested';
      Else
        Msg := 'ERROR Creating EKG Image: Error Code = ' + Inttostr(Status);
      End; {end case}
      Maggmsgf.MagMsg('des', Msg, Pmusemsg);
      StrDispose(POutputFileName);
      Exit;
    End;

    Result := True;
  Finally
    //HideMsgWin;
    Screen.Cursor := crDefault;
    Musedisconnect;
  End;

End;

Procedure TEKGWin.Displayimage(Desc, Name, SSN, TempEKG: String); {here}
Var
  RecFile: File Of ImgPage; (* variable to reference file as an ImgPage   *)
                                (* record structure                           *)
  ByteFile: File; (* variable to reference the file as a series *)
                                (* bytes--redundant and slow, but it works    *)
  OutFile: File; (* temporary output file for storage of       *)
                                (* metafile so that delphi will load it easily*)
  Rec1: ImgRecord; (* structure holding first image record       *)
  PImageBits: Pointer; (* pointer to our metafile bits               *)
  Size: Integer;
{ aMF :TMetafile ;}
Begin
  Try
   { set tEKGfile as current image being displayed, this is used for showpage function}
    TEKGfile := TempEKG;
    Size := Length(TempEKG);
    POutputFileName := Stralloc(Size + 1);
    Debugmessage('in DisplayImage');
    Debugmessage('tempekg = ' + TempEKG);
    Debugmessage('in display image');
    Strpcopy(POutputFileName, TempEKG);
    AssignFile(RecFile, Strpas(POutputFileName)); {replaced delphi.emf}

    Reset(RecFile);
    Read(RecFile, FileHeader);
    CloseFile(RecFile);

  (* Store in a local variable just to save typing *)
    Debugmessage('before showpagelist');
    ShowPagelist; {(fileheader);}
    SetPage(1); { sets currentpage = 1 and displays info, disable,enable next, prev}

    Rec1 := FileHeader.Recs[CurrentPage];

  (* Allocate a block of memory to store our metafile bits in *)
    Debugmessage('before getmem');
    GetMem(PImageBits, Rec1.LSize);

  (* Open the file now declaring it as nothing but a series of bytes *)
    AssignFile(ByteFile, Strpas(POutputFileName)); {RED 2/12/97}
    Debugmessage('1');
    Reset(ByteFile, 1);
    Seek(ByteFile, 8192);
    Debugmessage('2');
    BlockRead(ByteFile, PImageBits^, Rec1.LSize);
    CloseFile(ByteFile);
    Debugmessage('3');
    StrDispose(POutputFileName);
    Application.Processmessages;
    Debugmessage('4');
  (* Now write out the metafile as a separate file so delphi will put it into
     our picture for us *)

    Size := Length(AppPath + '\temp\1.emf');
    Debugmessage('5');
    POutputFileName := Stralloc(Size + 1); {fix this---static alloc a big buffer}
    Strpcopy(POutputFileName, AppPath + '\temp\1.emf');
    Debugmessage('6');

    AssignFile(OutFile, Strpas(POutputFileName));
    Rewrite(OutFile, 1);
    Debugmessage('7');
    BlockWrite(OutFile, PImageBits^, Rec1.LSize);
    CloseFile(OutFile);
    Debugmessage('8');

  (* Free up that memory *)
    FreeMem(PImageBits);
    Debugmessage('9');

 { HideMsgWin;}{MAG32}

    DisplayImageAPI;
    LbTestDesc.caption := Desc;
    Debugmessage('10');
    LbName.caption := Name;
    SSN := Strpas(@MusePID.ID); //added this line so ssn is not null - SAF 3/9/1999
    LbSSN.caption := Copy(SSN, 1, 3) + '-' + Copy(SSN, 4, 2) + '-' + Copy(SSN, 6, 4);

  Finally
    Debugmessage('in finally');
    Hidemsgwin;
  End;
End; (* TForm1.Image1Click *)

Procedure TEKGWin.DisplayImageAPI;
Var
  aMF: TMetaFile;
Begin
(* Tell the picture what metafile it should display *)
  aMF := TMetaFile.Create;
  If GridOn Then
    AddGridToMetaFile(aMF, Strpas(POutputFileName))
  Else
    aMF.LoadFromFile(Strpas(POutputFileName));
  ECGDisplay.Picture.MetaFile := aMF;
//RPMag3Logaction('IMG^'+MagPat1.M_DFN+'^'+magrecord^.mag0);
(* 3.0.8 10/31/2002 Modify what is sent to LogAction, because of new fields.
  RPMag3Logaction('IMG^' + dMod.MagPat1.M_DFN + '^EKG'); *)
  Dmod.MagDBBroker1.RPMag3Logaction('IMG-MUSE^' + Dmod.MagPat1.M_DFN); //1b
End;

Procedure TEKGWin.FormClose(Sender: Tobject; Var action: TCloseAction);
Begin
  Musedisconnect;
End;

Procedure TEKGWin.Musedisconnect;
Begin
  Dmod.MagFileSecurity.MagCloseSecurity(Xmsg);
  Mei_CloseMuse(@HMUSE, True);
End;

Procedure TEKGWin.ClearImage;
Begin

  ECGDisplay.Picture.LoadFromFile(AppPath + '\bmp\blank.bmp');
  ECGDisplay.Update;

  LbTestDesc.caption := '';
  Lbpagehd.caption := '';

(* lbName.caption := '';
lbSSN.caption := '';
lbSSNdisp.caption := ''; *)
  SetPage(0);
End;

Procedure TEKGWin.bbHelpClick(Sender: Tobject);
Begin
  Application.HelpContext(EKGWin.HelpContext);
End;

Procedure TEKGWin.SelectTestType(Aux: Integer);
Begin
  Global3 := Aux;
End;

Procedure TEKGWin.FormCreate(Sender: Tobject);
Var
  x, PathtoOpen, MuseVersion: String;
  Magini, Winini: TIniFile;
  Shares: Tstringlist;
  RPmsg: String;
  Success: Boolean;
Begin

  Shares := Tstringlist.Create;
  Dmod.MagDBBroker1.RPMagGetNetLoc(Success, RPmsg, Shares, 'EKG');
  cbSite.Items := Shares;
  Shares.Free;

    (* check to see if MUSE exists and is online if 2005.2 - SAF 2/11/2000 *)
  If Dmod.MagDBBroker1.RPMagEkgOnline = 0 Then
  Begin
    MUSEOnline := False;
    LibHandle := LoadLibrary('MUSEAPIFAKE.DLL');
  End
  Else
  Begin
          (* open a connection to the muse share before loading the dll *)
    PathtoOpen := MagPiece(cbSite.Items[0], '^', 2) + '\';
          (* write the servername and sharename to the win.ini file before loading dll *)
    Winini := TIniFile.Create('WIN.INI');
    With Winini Do
    Begin
      Writestring('MUSE', 'MainServerName', '\\' + MagPiece(PathtoOpen, '\', 3));
      Writestring('MUSE', 'MainVolName', '\' + MagPiece(PathtoOpen, '\', 4));
    End;
    Winini.Free;

          (* set the muse version and load the appropriate dll *)
    MuseVersion := MagPiece(cbSite.Items[0], '^', 8);

    If MagPiece(cbSite.Items[0], '^', 7) <> '' Then
      MuseSite := Strtoint(MagPiece(cbSite.Items[0], '^', 7));
    Try // gek 3/34/03  We wern't getting HourGlass when connecting.  Sometimes takes awhile.
      Frmmain.WinMsg('s', 'Opening Path to MUSE : ' + PathtoOpen);
      Frmmain.WinMsg('', 'Opening Path to MUSE Server...');
      Frmmain.Update;
      Screen.Cursor := crHourGlass;
      If Not Dmod.MagFileSecurity.MagOpenSecurePath(PathtoOpen, Xmsg) Then
      Begin
        Frmmain.WinMsg('', Xmsg);
        Frmmain.WinMsg('de', 'MUSE Connection Error: status =' + Xmsg);
        MUSEconnectFailed := True;
        Frmmain.SecurityMsg;
        Screen.Cursor := crDefault;
      End;
      If MUSEconnectFailed Then
        LibHandle := LoadLibrary('MUSEAPIFAKE.DLL') //if can't connect, load fake dll and continue
      Else
      Begin
        If (MuseVersion = '4B') Or (MuseVersion = '5A') Then
          LibHandle := LoadLibrary('MUSEAPI5A.DLL') //works for 4b and 5a
        Else
          LibHandle := LoadLibrary('MUSEAPI.DLL');
        Dmod.MagFileSecurity.MagCloseSecurity(Xmsg);
      End;
      MUSEOnline := True;
    Finally
      Screen.Cursor := crDefault;
    End;
  End;
(*  Added the following to dynamically load the muse dll  SAF 1/24/2000 *)
      //LibHandle := LoadLibrary('MUSEAPI.DLL');
  If LibHandle = 0 Then
    Raise EDLLLoadError.Create('Unable to Load MUSE DLL');
         // if here, then DLL loaded sucessfully
  @Mei_OpenMUSE := GetProcAddress(LibHandle, 'mei_OpenMUSE');
  @Mei_CloseMuse := GetProcAddress(LibHandle, 'mei_CloseMUSE');
  @Mei_PatientNameFromID := GetProcAddress(LibHandle, 'mei_PatientNameFromID');
  @Mei_TestsForPatient := GetProcAddress(LibHandle, 'mei_TestsForPatient');
  @Mei_CreateOutputForTestInfo := GetProcAddress(LibHandle, 'mei_CreateOutputForTestInfo');
  @Mei_CreateOutputForID := GetProcAddress(LibHandle, 'mei_CreateOutputForID');
//       @mei_PatientIDFromName := GetProcAddress(LibHandle, 'mei_PatientIDFromName'); this one is in MuseListOfPatientsu
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
{         if @mei_PatientIDFromName = NIL then
             RaiseLastWin32Error;
}

(* End of changes for dynamically loading muse dll SAF 1/24/2000 *)

  GetFormPosition(Self As TForm);

  ImageWidth := ECGDisplay.Width;
  ImageHeight := ECGDisplay.Height;

  Magini := TIniFile.Create(GetConfigFileName);
  With Magini Do
  Begin
    bSaveEKG.Visible := (Uppercase(ReadString('VISTAMUSE', 'ALLOWSAVEAS1', 'FALSE')) = 'TRUE');
    bOpenDemo.Visible := ((bSaveEKG.Visible) Or (Uppercase(ReadString('VISTAMUSE', 'ALLOWOPEN', 'FALSE')) = 'TRUE'));

    x := Uppercase(ReadString('VISTAMUSE', 'IMAGESIZE', 'FALSE'));
    If (x <> 'FALSE') And (x <> '') Then
    Begin
      ECGDisplay.SetBounds(0, 0, Strtoint(MagPiece(x, ',', 1)), Strtoint(MagPiece(x, ',', 2)));
    End;
    GridOn := Uppercase(ReadString('VISTAMUSE', 'GRIDON', 'FALSE')) = 'TRUE';
    x := Uppercase(ReadString('VISTAMUSE', 'SiteNumber', '0'));
    ShowDottedGridDlg := Uppercase(ReadString('VISTAMUSE', 'ShowDottedGridDlg', 'TRUE')) = 'TRUE';
    PrintDottedGrid := Uppercase(ReadString('VISTAMUSE', 'PrintDottedGrid', 'TRUE')) = 'TRUE';
    Try
      MUSESiteINI := Strtoint(x);
    Except
      On Exception Do MUSESiteINI := 0;
    End;
  End;
  MUSEConStatus := 0;
//apppath := copy(extractfilepath(application.exename),1,  length(extractfilepath(application.exename))-1);

  TEKGfile := AppPath + '\temp\ekgfile.emf';
  SetPage(0);

  UTestsList := Tlist.Create;
  New(Utemptestinfoptr);
  UDisableMore;

End;

Procedure TEKGWin.TestsForPatientclose;
Begin
  cbListOfTests.Clear;
(* FOR J:=0 TO EKGWin.Componentcount-1 do
    begin
    if EKGWin.components[j] is TTestsForPatient then
       begin
       (EKGWin.components[j] as tform).close;
       end;
    end;  *)
End;

(* this function is not used anymore - SAF 2/25/2000
function TEKGWin.MuseConnectQuiet;
var  status          : smallint ;
begin
result := false;
if MUSEconnectFailed then
   begin
   MaggMsgf.magmsg('','MUSE Connection Failed',frmMain.pmsg);
   exit;
   end;
if MUSESiteINI > 0 then MUSEsite := MUSESiteINI;
status := mei_OpenMUSE(@hMUSE, 0, 999,9999,TRUE, MUSESite) ;
if (status <> MUSE_SUCCESS) then
  BEGIN
  MUSEconnectFailed := true;
  //if status = -1 then   frmMain.WinMsg('des','Invalid File: MUSEAPI capability is disabled.'+#13+'Call IRM for correct MUSEAPI.DLL File.'+#13+'Status = -1')
  //else frmMain.WinMsg('des','Connection Error: status =' + IntToStr(status));
  SCREEN.CURSOR := CRDEFAULT;
  EKGWin.caption := 'VISTA Imaging: MUSE EKG Display';
  EXIT; {GEK  quit if error connecting }
  END;
result:=true;
end;
*)

Function TEKGWin.Museconnect;
Var
  Status: Smallint;
  PathtoOpen: String;

Begin
  Result := False;
  If MUSEconnectFailed Then
  Begin
    Maggmsgf.MagMsg('', 'MUSE Connection Failed', Frmmain.Pmsg);
    Exit;
  End;
  If MUSESiteINI > 0 Then MuseSite := MUSESiteINI;

  PathtoOpen := MagPiece(cbSite.Items[0], '^', 2) + '\';
  If Not Dmod.MagFileSecurity.MagOpenSecurePath(PathtoOpen, Xmsg) Then
  Begin
    Frmmain.WinMsg('', Xmsg);
    Frmmain.WinMsg('de', 'MUSE Connection Error: status =' + Xmsg);
    MUSEconnectFailed := True;
    Frmmain.SecurityMsg;
    Screen.Cursor := crDefault;
    Exit;
  End;

  Status := Mei_OpenMUSE(@HMUSE, 0, 999, 9999, True, MuseSite);
  If (Status <> MUSE_SUCCESS) Then
  Begin

    If Status = -1 Then
    Begin
      Frmmain.WinMsg('des', 'Invalid File: MUSEAPI capability is disabled.' + #13 + 'Call IRM for correct MUSEAPI.DLL File.' + #13 + 'Status = -1');
      Frmmain.WinMsg('', 'Invalid File : MUSEAPI.DLL  Call IRM to get an updated file.');
    End

    Else
      Frmmain.WinMsg('de', 'MUSE Connection Error: status =' + Inttostr(Status));
    MUSEconnectFailed := True;
    Screen.Cursor := crDefault;
    EKGWin.caption := 'VISTA Imaging: MUSE EKG Display';
    Exit; {GEK  quit if error connecting }
  End;
  Result := True;
End;

Function TEKGWin.GetNameFromSSN(PatientID: String; Var PatientName: String): Boolean;
Var
  Status: Smallint;
Begin
  Result := False;
  While Pos('-', PatientID) <> 0 Do
    Delete(PatientID, Pos('-', PatientID), 1);

  Try

    Showmsgwin('Searching for Patient ID :' + PatientID + '  Please Wait...');
    Strpcopy(@MusePID.ID, PatientID);

    Status := Mei_PatientNameFromID(HMUSE, @MuseName, @MusePID);
    If (Status <> MUSE_SUCCESS) Then
    Begin
      If Status = 1004 Then
      Begin
        Frmmain.WinMsg('', 'No MUSE EKG''s on file for Patient. ' + Dmod.MagPat1.M_NameDisplay);
        Exit;
      End;
      Maggmsgf.MagMsg('des', 'PatientNameFromID Error: status=' + Inttostr(Status), Pmusemsg);
      Screen.Cursor := crDefault;
      EKGWin.caption := 'VISTA Imaging: MUSE EKG Display';
      Exit; {gek   quit if error }
    End;

    Result := True;
    PatientName := Strpas(@MuseName.Last) + ',' + Strpas(@MuseName.First);
  Finally
    Hidemsgwin;
  End;

End;

Procedure TEKGWin.ClearPage;
Begin
  ECGDisplay.Picture.LoadFromFile(AppPath + '\bmp\blank.bmp');
  ECGDisplay.Update;
  Lbpagehd.caption := '';
End;

Procedure TEKGWin.SetPage(i: Integer);
Begin
  CurrentPage := i;
  If CurrentPage = 0 Then
  Begin
    ZoomTrack.Enabled := False;
  // bbZoomin.enabled := false;
   //bbZoomout.enabled := false;
    bbWidth.Enabled := False;
    bbHeight.Enabled := False;
    bbPrevPage.Enabled := False;
    bbNextPage.Enabled := False;
    bbPrint.Enabled := False;
    bbGrid.Enabled := False;
    PPagelist.Visible := False;
    cbPagelist.Clear;
   (* uDisablemore;*)

    Exit;
  End;
  ZoomTrack.Enabled := True;
//bbZoomin.enabled := true;
//bbZoomout.enabled := true;
  bbWidth.Enabled := True;
  bbHeight.Enabled := True;
  bbPrint.Enabled := True;
  Lbpagehd.caption := 'of ' + Inttostr(FileHeader.Pages);
  cbPagelist.ItemIndex := CurrentPage - 1;
  bbPrevPage.Enabled := True;
  bbNextPage.Enabled := True;
  bbGrid.Enabled := True;
  If CurrentPage = FileHeader.Pages Then bbNextPage.Enabled := False;
  If CurrentPage = 1 Then bbPrevPage.Enabled := False;
End;

Procedure TEKGWin.bbSettingsClick(Sender: Tobject);
Begin
  ChangeMuseSettings;
End;

Procedure TEKGWin.ChangeMuseSettings;
Begin
  MuseTestType.Showmodal;
  If MuseTestType.Forceanexit.Checked Then Forceclose := True;
End;

Procedure TEKGWin.Showmsgwin(s: String);
Begin
  If Not Doesformexist('MsgWin') Then
  Begin
    MsgWin := TMsgWin.Create(Frmmain);
    Application.Processmessages;
  End;

  MsgWin.Label1.caption := s;
  MsgWin.Show;
  MsgWin.Update;
End;

Procedure TEKGWin.Hidemsgwin;
Begin
  Screen.Cursor := crDefault;
  MsgWin.Hide;
  MsgWin.Update;
End;

Procedure TEKGWin.ClearCurPatient;
Begin

  ECGDisplay.Picture.LoadFromFile(AppPath + '\bmp\blank.bmp');
  ECGDisplay.Update;

  LbTestDesc.caption := '';
  Lbpagehd.caption := '';

  LbName.caption := '';
  LbSSN.caption := '';
  LbSSNdisp.caption := '';
  SetPage(0);

  UClearTestsList;
End;

Procedure TEKGWin.OpenEKGPatient(s: String);
Var
  PatientName, PatientID: String;
Begin
  ClearCurPatient;
//         if EKGWin.windowstate = wsminimized then EKGWin.windowstate := wsnormal;
//         if EKGWin.visible = false then EKGWin.show;

  PatientID := Copy(MagPiece(s, '^', 4), 1, 9);
  If PatientID = '000000000' Then
  Begin
    If EKGWin.WindowState = Wsminimized Then EKGWin.WindowState := Wsnormal;
    If EKGWin.Visible = False Then EKGWin.Show;
    OpenEKGDemo(MagPiece(s, '^', 6));
    LbName.caption := MagPiece(s, '^', 2) + ',' + MagPiece(s, '^', 3);
    LbName.Update;
    LbSSNdisp.caption := PatientID;
    LbSSNdisp.Update;
    Maggmsgf.MagMsg('', 'Patient opened.', Pmusemsg);
    Exit;
  End;

  Try
    If Not Museconnect Then Exit;
    Debugmessage('getting name from ssn');
    Debugmessage('ssn =  [' + PatientID + ']');

    //removing call to GetNameFromSSN - this won't work if patients
    //only have unconfirmed EKGS (MUSE returns that patient doesn't exist)
    //will set PatientName manually instead
    PatientName := Dmod.MagPat1.M_PatName;
   { if not GetNameFromSSN(patientid, patientname) then
    begin
      MaggMsgf.magmsg('', 'Error : serching for SSN : ' + patientid, pmusemsg);
      EKGWin.visible := false;
      exit;
    end;
   }
        { lbName.caption:=patientname;
         lbSSN.caption := patientid;
         lbSSNdisp.caption := copy(patientid,1,3)+'-'+copy(patientid,4,2)+'-'+
                    copy(patientid,6,4);}

         (* Now we know we have patient information, so get list of patient tests  *)
    If EKGWin.WindowState = Wsminimized Then EKGWin.WindowState := Wsnormal;
    If EKGWin.Visible = False Then EKGWin.Show;
    If MuseTestsForPatient.Visible Then
    Begin
      PTestList.Visible := False;
      UShowTestsForPatient(PatientID, PatientName, MuseTestsForPatient.LbName, MuseTestsForPatient.LbSSN, MuseTestsForPatient.LbSSNdisp);
              (*EKGWin.lbname.caption :=  patientname;
              EKGWin.lbssn.caption := Patientid;
              EKGWin.lbssndisp.caption := copy(Patientid,1,3) +'-'+copy(Patientid,4,2)+'-'+copy(Patientid,6,4);
              *)
    End
    Else
    Begin
      PTestList.Visible := True;
      UShowTestsForPatient(PatientID, PatientName, EKGWin.LbName, EKGWin.LbSSN, EKGWin.LbSSNdisp);
    End;
  Finally
    Screen.Cursor := crDefault;
    Musedisconnect;
  End;
End;

Procedure TEKGWin.FitToWidth;
Var
  Factor: Real;
  w, h: Longint;
Begin
  Debugmessage('fit to width');
{factor := (EKGWin.clientwidth-20)/ecgdisplay.width;}
  Factor := (ScrollBox1.Width - 20) / ECGDisplay.Width;
{ecgdisplay.width := trunc(ecgdisplay.width * factor);
ecgdisplay.height := trunc(ecgdisplay.height * factor);}
  w := Trunc(ECGDisplay.Width * Factor);
  h := Trunc(ECGDisplay.Height * Factor);
  ECGDisplay.SetBounds(0, 0, w, h);
End;

Procedure TEKGWin.FitToHeight;
Var
  Factor: Real;
  w, h: Longint;
Begin
  Debugmessage('fit to height');
{factor := (EKGWin.clientheight-panel1.height-panel2.height-10)/ecgdisplay.height;}
  Factor := (ScrollBox1.Height - 20) / ECGDisplay.Height;
  w := Trunc(ECGDisplay.Width * Factor);
  h := Trunc(ECGDisplay.Height * Factor);
  ECGDisplay.SetBounds(0, 0, w, h);
End;

Procedure TEKGWin.bbZoominClick(Sender: Tobject);
Var
  w, h: Longint;
Begin
  LastSizingAction := [Zoom];
{ecgdisplay.width := trunc(ecgdisplay.width * (1+(MuseTestType.TrackBar1.position/10)));
ecgdisplay.height := trunc(ecgdisplay.height * (1+(MuseTestType.TrackBar1.position/10)));}
  w := Trunc(ECGDisplay.Width * (1 + (MuseTestType.TrackBar1.Position / 10)));
  h := Trunc(ECGDisplay.Height * (1 + (MuseTestType.TrackBar1.Position / 10)));
  ECGDisplay.SetBounds(0, 0, w, h);
End;

Procedure TEKGWin.bbZoomOutClick(Sender: Tobject);
Var
  w, h: Longint;
Begin
  LastSizingAction := [Zoom];
{ecgdisplay.width := trunc(ecgdisplay.width / (1+(MuseTestType.TrackBar1.position/10)));
ecgdisplay.height := trunc(ecgdisplay.height /(1+(MuseTestType.TrackBar1.position/10)));}
  w := Trunc(ECGDisplay.Width / (1 + (MuseTestType.TrackBar1.Position / 10)));
  h := Trunc(ECGDisplay.Height / (1 + (MuseTestType.TrackBar1.Position / 10)));
  ECGDisplay.SetBounds(0, 0, w, h);
End;

Procedure TEKGWin.bbWidthClick(Sender: Tobject);
Begin
  LastSizingAction := [Fitwidth];
  FitToWidth;
End;

Procedure TEKGWin.bbHeightClick(Sender: Tobject);
Begin
  LastSizingAction := [Fitheight];
  FitToHeight;
End;

Procedure TEKGWin.bbGridClick(Sender: Tobject);
Begin
  GridOn := Not GridOn;
  DisplayImageAPI;
End;

Procedure TEKGWin.bbPrevPageClick(Sender: Tobject);
Begin
  If CurrentPage <= 1 Then
  Begin
    Messagebeep(0);
    Exit;
  End
  Else
  Begin
    SetPage(CurrentPage - 1);
    ShowPage(CurrentPage);
  End;
End;

Procedure TEKGWin.ShowPage(Page: Integer);
Var
  RecFile: File Of ImgPage; (* variable to reference file as an ImgPage   *)
                                (* record structure                           *)
  ByteFile: File; (* variable to reference the file as a series *)
                                (* bytes--redundant and slow, but it works    *)
  OutFile: File; (* temporary output file for storage of       *)
                                (* metafile so that delphi will load it easily*)
  Rec1: ImgRecord; (* structure holding first image record       *)
  PImageBits: Pointer; (* pointer to our metafile bits               *)
Begin
  (* Open the file pretending its nothing but a large ImgPage record *)
  AssignFile(RecFile, TEKGfile);
  Reset(RecFile);
  Read(RecFile, FileHeader);
  CloseFile(RecFile);
  Rec1 := FileHeader.Recs[Page];

   (* Allocate a block of memory to store our metafile bits in *)
  GetMem(PImageBits, Rec1.LSize);

  (* Open the file now declaring it as nothing but a series of bytes *)
  AssignFile(ByteFile, TEKGfile);
  Reset(ByteFile, 1);
  Seek(ByteFile, Rec1.Loffset);
  BlockRead(ByteFile, PImageBits^, Rec1.LSize);
  CloseFile(ByteFile);

  (* Now write out the metafile as a separate file so delphi will put it into
     our picture for us *)
  AssignFile(OutFile, AppPath + '\temp\1.emf');
  Rewrite(OutFile, 1);
  BlockWrite(OutFile, PImageBits^, Rec1.LSize);
  CloseFile(OutFile);

  (* Free up that memory *)
  FreeMem(PImageBits);

  (* Tell the picture what picture it should display (note properties in
     example program *)
  ECGDisplay.Picture.LoadFromFile(AppPath + '\temp\1.emf');

End; (*  *)

Procedure TEKGWin.bbNextPageClick(Sender: Tobject);
Begin
  If ((CurrentPage + 1) > (FileHeader.Pages)) Then
  Begin
    Messagebeep(0);
    Exit;
  End
  Else
  Begin
    SetPage(CurrentPage + 1);
    ShowPage(CurrentPage);
  End;
End;

Procedure TEKGWin.bbPrintClick(Sender: Tobject);
Var
  Rect: Trect;
Begin
  EKGWin.Cursor := crHourGlass;
  ECGDisplay.Cursor := crHourGlass;
  Panel1.Cursor := crHourGlass;
  bbPrint.Enabled := False;
  If (GridOn = True) And (ShowDottedGridDlg = True) Then FEKGdlg.Showmodal;
  If Not PrintDialog1.Execute Then
  Begin
    EKGWin.Cursor := crDefault;
    ECGDisplay.Cursor := crDefault;
    Panel1.Cursor := crDefault;
    bbPrint.Enabled := True;
    Exit;
  End;
  Printing := True;
  If PrintDottedGrid = True Then DisplayImageAPI;
  Printer.Orientation := PoLandscape;
  //printer.orientation := poPortrait;
  Rect.Top := 0;
  Rect.Left := 0;
  Rect.Right := Printer.PageWidth;
  Rect.Bottom := Printer.PageHeight;
  With Printer Do
  Begin
    {    printer.canvas :=    ecgdisplay.canvas;}
    BeginDoc; { start printing }
    Canvas.StretchDraw(Rect, ECGDisplay.Picture.MetaFile);
    {   Canvas.Draw(0, 0, ecgdisplay.picture.metafile);	}{draw Image at top left corner of printed page }
    Enddoc; { finish printing }
  End;
  PrintDottedGrid := False;
  Printing := False;
  DisplayImageAPI;
  EKGWin.Cursor := crDefault;
  ECGDisplay.Cursor := crDefault;
  Panel1.Cursor := crDefault;
  bbPrint.Enabled := True;
End;

Procedure TEKGWin.ShowPagelist;
Var
  Trec: ImgRecord;
  i, j: Integer;
  s: String;
Begin
  If FileHeader.Pages = 1 Then
  Begin
    PPagelist.Hide;
    cbPagelist.Clear;
    Exit;
  End;
  cbPagelist.Clear;
  PPagelist.Visible := True;
  For i := 1 To FileHeader.Pages Do
  Begin
    Trec := FileHeader.Recs[i];
    s := '';
    For j := 0 To 30 Do
      s := s + Trec.Title[j];
    cbPagelist.Items.Add(Inttostr(i) + ': ' + s);
    (*  title   : string[31] ;   name    : string[27] ;  *)
  End;
End;

Procedure TEKGWin.cbPagelistClick(Sender: Tobject);
Begin
  ClearPage;
  SetPage(cbPagelist.ItemIndex + 1);
  ShowPage(CurrentPage);
End;

Procedure TEKGWin.UShowTestsForPatient(PatientID, PatientName: String; Var TN, Tssn, Tssnd: Tlabel);
Var
  Status, Numentries: Smallint;
  i, k, Test: Integer;
  Inf, Testdesc, Testmsg: String;
 {temptestinfoptr : MUSE_TEST_INFORMATION_PTR;  }
Begin
  UClearTestsList;
  MuseTestsForPatient.ClearTestList;
  cbListOfTests.Enabled := True;
  cbDemoTests.Clear;
  cbDemoTests.Visible := False;

  MuseTestsForPatient.LbName.caption := PatientName;
  MuseTestsForPatient.LbSSN.caption := PatientID;
  MuseTestsForPatient.LbSSNdisp.caption := Copy(PatientID, 1, 3) + '-' + Copy(PatientID, 4, 2) + '-' + Copy(PatientID, 6, 4);

  EKGWin.LbName.caption := PatientName;
  EKGWin.LbSSN.caption := PatientID;
  EKGWin.LbSSNdisp.caption := Copy(PatientID, 1, 3) + '-' + Copy(PatientID, 4, 2) + '-' + Copy(PatientID, 6, 4);

   (*tn.caption := patientname;
   tn.update;
   tssn.caption := patientid;
   tssn.update;
   tssnd.caption := copy(patientid,1,3) +'-'+copy(patientid,4,2)+'-'+copy(patientid,6,4);
   tssnd.update;  *)

{lbName.caption := patientname;
lbSSN.caption := patientid;
lbSSNdisp.caption := copy(patientid,1,3)+'-'+copy(patientid,4,2)+'-'+copy(patientid,6,4)  ;}

{bSSNdisp.left := lbName.left+lbName.width+10;}
  With MuseDate Do
  Begin
    Day := -1;
    Month := -1;
    Year := -1;
  End;
  If MuseTestType.MeDate.Text <> '' Then
  Begin
      {  }
  End;
  With MuseTime Do
  Begin
    Hundreths := -1;
    Second := -1;
    Minute := -1;
    Hour := -1;
  End;

  Numentries := 14; (* This is where we define ???? *)
  TypeOfTestToShow(Test, Testdesc);
  Strpcopy(@MusePID.ID, PatientID);

  Showmsgwin('Accessing "' + Testdesc + ' Tests" for ''' + PatientName + ''' Please Wait...');
  If Not Museconnect Then Exit;
  Try

    Status := Mei_TestsForPatient(HMUSE, @MusePID, Test, @MuseDate,
      @MuseTime, @UtestInfoBuffer, @Numentries);

    If (Status <> MUSE_SUCCESS) Then
    Begin
      ClearImage; (* This line doesn't seem to work properly... *)
      Maggmsgf.MagMsg('des', 'MUSE ERROR accessing "' + Testdesc + ' Tests" for : "' + PatientName + '" Status=' + Inttostr(Status), Pmusemsg);
      Screen.Cursor := crDefault;
      Exit; { gek exit if error }
    End;
    If Numentries < 1 Then
    Begin
      ClearImage;
      If Testdesc = 'All' Then
        Testmsg := 'EKG'
      Else
        Testmsg := Testdesc;
      Maggmsgf.MagMsg('sd', 'No ' + Testmsg + ' Tests on file for : ' + PatientName, Pmusemsg);
      Screen.Cursor := crDefault;
      Exit;
    End;

(* MuseTestsForPatient.show;
MuseTestsForPatient.windowstate := wsnormal; *)
    For i := 1 To Numentries Do
    Begin
      k := UTestsList.Count + 1;
      Inf := (Inttostr(k) + ': ' + EKGWin.Dispcsetype(UtestInfoBuffer[i].cseType) + ' - ' + Inttostr(UtestInfoBuffer[i].AcqDate.Month) +
        '/' + Inttostr(UtestInfoBuffer[i].AcqDate.Day) + '/' + Inttostr(UtestInfoBuffer[i].AcqDate.Year)
        + ' - ' + Outformat(UtestInfoBuffer[i].AcqTime.Hour) + ':' + Outformat(UtestInfoBuffer[i].AcqTime.Minute) + ':'
        + Outformat(UtestInfoBuffer[i].AcqTime.Second));

      If MuseTestsForPatient.Visible Then
      Begin
        MuseTestsForPatient.ListBox1.Items.Add(Inf);
        MuseTestsForPatient.Showtestcount;
      End
      Else
      Begin
        If Not cbListOfTests.Visible Then cbListOfTests.Show;
        cbListOfTests.Items.Add(Inf);
        Showtestcount;
      End;

      New(Utemptestinfoptr);
      Utemptestinfoptr^ := UtestInfoBuffer[i];
      UTestsList.Add(Utemptestinfoptr);
    { ShowTestCount;}
    End;
{cbListOfTests.UPDATE;}
    Screen.Cursor := crDefault;

  Finally
    EKGWin.Hidemsgwin;
    Musedisconnect;
  End;
  If MuseTestsForPatient.Visible Then
    MuseTestsForPatient.InitList(Numentries < 14)
  Else
    UInitList(Numentries < 14);
End;

Procedure TEKGWin.UInitList(Nomore: Boolean);
Begin
  Showtestcount;
  cbListOfTests.Update;
  cbListOfTests.SetFocus;
  UbbNext14.Enabled := True;
  UbbALL.Enabled := True;
  If Nomore Then UDisableMore;
  cbListOfTests.ItemIndex := 0;
  cbListOfTests.Update;
  If Uppercase(GetIniEntry('VISTAMUSE', 'DisplayFirstImage')) <> 'FALSE' Then
  Begin
    Debugmessage('before forcing a cblistoftestsclick');
    cbListOfTestsClick(Self);
  End;
End;

Procedure TEKGWin.UDisableMore;
Begin
  UbbNext14.Enabled := False;
  UbbALL.Enabled := False;
  UbbNext14.Update;
  UbbALL.Update;
  Lbtestcount.caption := Inttostr(cbListOfTests.Items.Count);
  Lbtestcount.Update;
End;

Procedure TEKGWin.UClearTestsList;
Var
  i: Integer;
{temptestinfoptr : MUSE_TEST_INFORMATION_PTR;  }
Begin
  For i := UTestsList.Count - 1 Downto 0 Do
  Begin
    Utemptestinfoptr := UTestsList[i];
    Dispose(Utemptestinfoptr);
  End;
  UTestsList.Clear;
  cbListOfTests.Clear; (* clear the data for the previous patient *)
  If Doesformexist('MuseTestsForPatient') Then MuseTestsForPatient.ClearTestList;
  UbbNext14.Enabled := False;
  UbbALL.Enabled := False;
  Lbtestcount.caption := '';
End;

Function TEKGWin.Outformat(i: Integer): String;
Begin
{turn a 1 digit number into a 2 character string with '0' as first;}

  Result := Inttostr(i);
  If Length(Inttostr(i)) = 1 Then Result := '0' + Inttostr(i);

End;

Procedure TEKGWin.UbbNext14Click(Sender: Tobject);
Begin
  Showmsgwin('Accessing Next 14 Tests for ''' + LbName.caption + ''' Please Wait...');
  UMoreTests;
  Hidemsgwin;
End;

Procedure TEKGWin.UbbALLClick(Sender: Tobject);
Begin
  Try
    Showmsgwin('Accessing ALL Tests for ''' + LbName.caption + ''' Please Wait...');
    Repeat UMoreTests Until (Not UbbNext14.Enabled)
  Except
    Hidemsgwin;
    Maggmsgf.MagMsg('des', 'Error accessing patient tests.', Pmusemsg);
  End;
  Hidemsgwin;

End;

Procedure TEKGWin.UMoreTests;
Var
  Status: Smallint; (* Success/error status from MUSE             *)
  Numentries: Smallint; (* Number of entries in buffers               *)
  i, k: Integer;
 { day1, month1,second1, minute1, hour1, test, cont: shortint;}
  Test: Integer;
{  aux : string;  }
  Inf, Tssn, Testdesc, Testmsg: String;
{  pch1: pchar;}
Begin
{StrCopy(@musePID.id, @demoBuffer[i].patient.id);}{gek 9/97}
{EKGWin.meSSN.text := magpiece(musePID.ID,'-',1)+magpiece(musePID.ID,'-',2)+
                magpiece(musePID.ID,'-',3);}{gek 9/97}

  Screen.Cursor := crHourGlass; { SHOW IT'S SEARCHING}

(* ???? is it already connected to MUSE *)

  Utemptestinfoptr := UTestsList[UTestsList.Count - 1];
  With MuseDate Do
  Begin
      {day   := testinfobuffer[14].acqDate.day;
      month := testinfobuffer[14].acqDate.month;
      year  := testinfobuffer[14].acqDate.year;}
    Day := Utemptestinfoptr^.AcqDate.Day;
    Month := Utemptestinfoptr^.AcqDate.Month;
    Year := Utemptestinfoptr^.AcqDate.Year;
  End;
  With MuseTime Do
  Begin
     {  hundreths  := testinfobuffer[14].acqTime.hundreths;
       second     := testinfobuffer[14].acqTime.second;
       minute     := testinfobuffer[14].acqTime.minute;
       hour       := testinfobuffer[14].acqTime.hour;}
    Hundreths := Utemptestinfoptr^.AcqTime.Hundreths;
    Second := Utemptestinfoptr^.AcqTime.Second;
    Minute := Utemptestinfoptr^.AcqTime.Minute;
    Hour := Utemptestinfoptr^.AcqTime.Hour;
  End;
  Numentries := 14; (* This is where we define ???? *)

  TypeOfTestToShow(Test, Testdesc);
  If Not EKGWin.Museconnect Then Exit;
  Try
    Tssn := LbSSN.caption; // this line can be commented out SAF 3/9/1999
    While (Pos('-', Tssn) <> 0) Do
      Delete(Tssn, Pos('-', Tssn), 1); //this line can be commented out SAF 3/9/1999
//StrPCopy(@Musepid.id,tssn);    commented out SAF 3/9/1999 Museapi.id is global
    Status := Mei_TestsForPatient(HMUSE, @MusePID, Test, @MuseDate,
      @MuseTime, @UtestInfoBuffer, @Numentries);
    If Numentries < 2 Then
    Begin
      UDisableMore;
      If Testdesc = 'All' Then
        Testmsg := 'EKG'
      Else
        Testmsg := Testdesc;
      Maggmsgf.MagMsg('des', 'No more ' + Testmsg + ' tests on file for ' + LbName.caption, Pmusemsg);
      Screen.Cursor := crDefault;
      Exit;
    End;
    If (Status <> MUSE_SUCCESS) Then
    Begin
      Maggmsgf.MagMsg('des', 'TestsForPatient Error: status=' + Inttostr(Status), Pmusemsg);
      Screen.Cursor := crDefault;
      Exit; { gek exit if error }
    End;
{top := cblistoftests.items.count;}
    For i := 2 To Numentries Do
    Begin
      k := UTestsList.Count + 1;
      Inf := (Inttostr(k) + ': ' + EKGWin.Dispcsetype(UtestInfoBuffer[i].cseType) + ' - ' + Inttostr(UtestInfoBuffer[i].AcqDate.Month) +
        '/' + Inttostr(UtestInfoBuffer[i].AcqDate.Day) + '/' + Inttostr(UtestInfoBuffer[i].AcqDate.Year)
        + ' - ' + Outformat(UtestInfoBuffer[i].AcqTime.Hour) + ':' + Outformat(UtestInfoBuffer[i].AcqTime.Minute) + ':'
        + Outformat(UtestInfoBuffer[i].AcqTime.Second));

      If MuseTestsForPatient.Visible Then
      Begin
        MuseTestsForPatient.ListBox1.Items.Add(Inf);
        MuseTestsForPatient.Showtestcount;
      End
      Else
      Begin
        If Not cbListOfTests.Visible Then cbListOfTests.Show;
        cbListOfTests.Items.Add(Inf);
        Showtestcount;
      End;
      New(Utemptestinfoptr);
      Utemptestinfoptr^ := UtestInfoBuffer[i];
      UTestsList.Add(Utemptestinfoptr);
    { ShowTestCount;}
    End;
{cblistoftests.itemindex := top; }
  Finally
    Musedisconnect;
    Screen.Cursor := crDefault;
  End;
  If MuseTestsForPatient.Visible Then
  Begin
    MuseTestsForPatient.Showtestcount;
    If Numentries < 14 Then MuseTestsForPatient.DisableMore;
  End
  Else
  Begin
    Showtestcount;
    If Numentries < 14 Then UDisableMore;
  End;
End;

Procedure TEKGWin.bPatientClick(Sender: Tobject);
Var
  Pname, SSN: String;
Begin
  MuseListofPatients.Showmodal;
  If MuseListofPatients.ModalResult = MrCancel Then Exit;
  WarningColor(True);
  ClearCurPatient;

  SSN := MuseListofPatients.SelPatID.caption;
  While (Pos('-', SSN) <> 0) Do
    Delete(SSN, Pos('-', SSN), 1);
  Pname := MuseListofPatients.SelPatName.caption;

  If MuseTestsForPatient.Visible Then
  Begin
    PTestList.Visible := False;
    UShowTestsForPatient(SSN, Pname, MuseTestsForPatient.LbName, MuseTestsForPatient.LbSSN, MuseTestsForPatient.LbSSNdisp);
(* EKGWin.lbname.caption :=  pname;
 EKGWin.lbssn.caption := ssn;
 EKGWin.lbssndisp.caption := copy(ssn,1,3) +'-'+copy(ssn,4,2)+'-'+copy(ssn,6,4);
*)
  End
  Else
  Begin
    PTestList.Visible := True;
    UShowTestsForPatient(SSN, Pname, EKGWin.LbName, EKGWin.LbSSN, EKGWin.LbSSNdisp);
  End;
End;

Procedure TEKGWin.cbListOfTestsClick(Sender: Tobject);

Begin
  If cbListOfTests.ItemIndex = -1 Then Exit;
  OpenImage(cbListOfTests.Items[cbListOfTests.ItemIndex], cbListOfTests.ItemIndex);
End;

Procedure TEKGWin.OpenImage(d: String; i: Integer);
Var
  s: String;
Begin
  ClearImage;
  If EKGWin.WindowState = Wsminimized Then EKGWin.WindowState := Wsnormal;
  If Not EKGWin.Visible Then EKGWin.Visible := True;
  Debugmessage('in openimage');
  Utemptestinfoptr := UTestsList[i];
  s := LbSSN.caption;
  While (Pos('-', s) <> 0) Do
    Delete(s, Pos('-', s), 1);

  If Not CreateImage(Utemptestinfoptr, TEKGfile) Then Exit;
  Debugmessage('calling displayimage from openimage');
  Displayimage(d, LbName.caption, s, TEKGfile);
End;

Procedure TEKGWin.Showtestcount;
Begin
  Lbtestcount.caption := Inttostr(cbListOfTests.Items.Count) + '+';
  Lbtestcount.Update;
End;

Procedure TEKGWin.TypeOfTestToShow(Var Test: Integer; Var Testdesc: String);
Begin
  Test := -1;
  If MuseTestType.RadioButton1.Checked Then
  Begin
    Test := 1;
    Testdesc := 'Resting ECG';
  End;
  If MuseTestType.RadioButton2.Checked Then
  Begin
    Test := 2;
    Testdesc := 'Pace';
  End;
  If MuseTestType.RadioButton3.Checked Then
  Begin
    Test := 3;
    Testdesc := 'Hires';
  End;
  If MuseTestType.RadioButton4.Checked Then
  Begin
    Test := 4;
    Testdesc := 'Stress';
  End;
  If MuseTestType.RadioButton5.Checked Then
  Begin
    Test := 5;
    Testdesc := 'Holter';
  End;
  If MuseTestType.RadioButton6.Checked Then
  Begin
    Test := 6;
    Testdesc := 'Cardiac Cath';
  End;
  If MuseTestType.RadioButton7.Checked Then
  Begin
    Test := 7;
    Testdesc := 'Cardiac Ultrassound';
  End;
  If MuseTestType.RadioButton8.Checked Then
  Begin
    Test := 8;
    Testdesc := 'Defib';
  End;
  If MuseTestType.RadioButton9.Checked Then
  Begin
    Test := 9;
    Testdesc := 'Discharge Summary';
  End;
  If MuseTestType.RadioButton10.Checked Then
  Begin
    Test := 10;
    Testdesc := 'History and Physicals';
  End;
  If MuseTestType.RadioButton11.Checked Then
  Begin
    Test := 11;
    Testdesc := 'Event Recorder Info';
  End;
  If MuseTestType.RadioButton12.Checked Then
  Begin
    Test := 12;
    Testdesc := 'Nuclear Imaging';
  End;
  If MuseTestType.RadioButton13.Checked Then
  Begin
    Test := 13;
    Testdesc := 'STC';
  End;
  If MuseTestType.RadioButton14.Checked Then
  Begin
    Test := 14;
    Testdesc := 'Electrophysiology';
  End;
  If MuseTestType.RadioButton15.Checked Then
  Begin
    Test := 15;
    Testdesc := 'Chest Pain assessM';
  End;
  If MuseTestType.RadioButton16.Checked Then
  Begin
    Test := -1;
    Testdesc := 'All';
  End;
    { }
End;

Procedure TEKGWin.bOpenDemoClick(Sender: Tobject);
Begin
  OpenEKGDemo('');
End;

Procedure TEKGWin.OpenEKGDemo(Demodir: String);
Begin
  If Demodir <> '' Then
  Begin
    LoadDemoFromDir(Demodir);
    Exit;
  End;

  If Not Directoryexists('c:\vista\imaging\demos\') Then CreateDir('c:\vista\imaging\demos\');
  If OpenDialog1.InitialDir = '' Then OpenDialog1.InitialDir := 'c:\vista\imaging\demos\';
  OpenDialog1.Title := 'Open EKG Demo images';
  OpenDialog1.Filename := 'All EKG files';

  If Not OpenDialog1.Execute Then Exit;
  Lbtestcount.caption := '0';
  FileListBox1.Directory := '';
  FileListBox1.Clear;
  FileListBox1.Update;
  cbDemoTests.Clear;
  OpenDialog1.InitialDir := ExtractFilePath(OpenDialog1.Filename);
  If ((Not FileExists(OpenDialog1.Filename)) Or (ExtractFileName(OpenDialog1.Filename) = 'All EKG files')) Then
    LoadDemoFromDir(ExtractFilePath(OpenDialog1.Filename))
  Else
  Begin
    ECGDisplay.Picture.LoadFromFile(OpenDialog1.Filename);
    LbTestDesc.caption := ExtractFileName(OpenDialog1.Filename);
    EnableButtonsforDemoEKG;
  End;
End;

Procedure TEKGWin.LoadDemoFromDir(Tdir: String);
Var
  i: Integer;
Begin
  PTestList.Visible := True;
  MuseTestsForPatient.Hide;
// here is where i'm dying//////
  FileListBox1.Directory := Tdir;
  UClearTestsList;
  ClearImage;
  cbListOfTests.Visible := False;
  cbDemoTests.Clear;
  cbDemoTests.Visible := True;
  For i := 0 To FileListBox1.Items.Count - 1 Do
  Begin
    If ExtractFileExt(FileListBox1.Items[i]) = '.emf' Then cbDemoTests.Items.Add(FileListBox1.Items[i]);
  End;
  Lbtestcount.caption := Inttostr(cbDemoTests.Items.Count);
  cbDemoTests.ItemIndex := 0;
  cbDemoTestsClick(Self);

End;

Procedure TEKGWin.cbDemoTestsClick(Sender: Tobject);
Begin
  ECGDisplay.Picture.LoadFromFile(cbDemoTests.Items[cbDemoTests.ItemIndex]);
  EnableButtonsforDemoEKG;
End;

Procedure TEKGWin.EnableButtonsforDemoEKG;
Begin
  ZoomTrack.Enabled := True;
//bbZoomin.enabled := true;
//bbZoomout.enabled := true;
  bbWidth.Enabled := True;
  bbHeight.Enabled := True;
  bbPrint.Enabled := True;
  UbbNext14.Enabled := False;
  UbbALL.Enabled := False;
End;

Procedure TEKGWin.HidePatientName;
Var
  NewRect: Trect;
  aMFC: TMetafileCanvas;
  Tmf: TMetaFile;
Begin

  Tmf := TMetaFile.Create;
  Tmf.Assign(ECGDisplay.Picture.MetaFile);
  aMFC := TMetafileCanvas.Create(ECGDisplay.Picture.MetaFile, 0);

{lbname.caption := inttostr(amfc.width)+' '+inttostr(amfc.height);}
  NewRect := Rect(0, 300, 10000, 650);
  aMFC.Brush.Style := bsSolid;
  aMFC.Brush.Color := clBlack;
  aMFC.Fillrect(NewRect);

  aMFC.Draw(0, 0, Tmf);
  aMFC.Fillrect(NewRect);
  Tmf.Free;

(* aMFC.font.assign(lbname.font);
amfc.font.color := clblack;
aMFC.TEXTOUT(100,600,'Demo,patient');  *)

  aMFC.Free;
End;

Procedure TEKGWin.bSaveEKGClick(Sender: Tobject);
Var
  Fn, Tdesc: String;
Begin
  If Not Directoryexists('c:\vista\imaging\demos\') Then CreateDir('c:\vista\imaging\demos\');
  If SaveDialog1.InitialDir = '' Then SaveDialog1.InitialDir := 'c:\vista\imaging\demos\';
  Fn := Copy(LbName.caption, 1, 4) + Copy('000', 1, 3 - Length(Inttostr(cbListOfTests.ItemIndex))) + Inttostr(cbListOfTests.ItemIndex + 1) + '.emf';
  Tdesc := cbListOfTests.Items[cbListOfTests.ItemIndex];
  SaveDialog1.Filename := Fn;
  If SaveDialog1.Execute Then
  Begin
    SaveDialog1.InitialDir := ExtractFilePath(SaveDialog1.Filename);
  { ECGDisplay.Picture.Savetofile(AppPath+'\temp\2.emf') ; }
    HidePatientName;
    ECGDisplay.Picture.SaveToFile(SaveDialog1.Filename);
    Memo1.Clear;
    If FileExists('ekgdemo.txt') Then Memo1.Lines.LoadFromFile('ekgdemo.txt');
    Memo1.Lines.Add(SaveDialog1.Filename + '^' + Tdesc);
    Memo1.Lines.SaveToFile('ekgdemo.txt');
  End;
End;

Procedure TEKGWin.FormResize(Sender: Tobject);
Begin
  Debugmessage('Resize EKGWin');
  If WindowState = Wsminimized Then Exit;
  If Fitwidth In LastSizingAction Then
  Begin
    FitToWidth;
    Exit;
  End;
  If Fitheight In LastSizingAction Then
  Begin
    FitToHeight;
    Exit;
  End;
  If ECGDisplay.Width < ScrollBox1.Width Then
  Begin
    FitToWidth;
    Exit;
  End;

End;

Procedure TEKGWin.Debugmessage(s: String);
Begin
{ We have problem when we try to step through the code using Delphi's debugger if MUSE is active
 so until we figure that one out.  we have to have debug messages, and run the application from
 the command line, not from inside delphi }
  MsgListBox.Items.Add(s);
  MsgListBox.Update;
  MsgListBox.Topindex := MsgListBox.Items.Count - 1;
End;

Procedure TEKGWin.Panel2DragOver(Sender, Source: Tobject; x,
  y: Integer; State: TDragState; Var Accept: Boolean);
Begin
{if ((source is tcombobox) and(( source as tcombobox).name = 'cblistoftests')) then label1.caption := 'listoftests';}
End;

Procedure TEKGWin.FormDragOver(Sender, Source: Tobject; x, y: Integer;
  State: TDragState; Var Accept: Boolean);
Begin
{if ((source is tcombobox) and(( source as tcombobox).name = 'cblistoftests')) then label1.caption := 'listoftests';}
End;

Procedure TEKGWin.BitBtn1Click(Sender: Tobject);
{VAR S,N : STRING;}
Begin
  SwitchListDisplay;
End;

Procedure TEKGWin.SwitchListDisplay;
Begin
  If MuseTestsForPatient.Visible Then
  Begin
    MuseTestsForPatient.Hide;
    EKGWin.PTestList.Show;
   //EKGWin.lbname.caption := MuseTestsForPatient.lbname.caption;
   //EKGWin.lbssn.caption := MuseTestsForPatient.lbssn.caption;
   //EKGWin.lbssndisp.caption := MuseTestsForPatient.lbssndisp.caption;
    EKGWin.UbbNext14.Enabled := MuseTestsForPatient.bbNext14.Enabled;
    EKGWin.UbbALL.Enabled := MuseTestsForPatient.bbALL.Enabled;
    EKGWin.Lbtestcount.caption := MuseTestsForPatient.LCount.caption;
    cbListOfTests.Items.Assign(MuseTestsForPatient.ListBox1.Items);
  End
  Else
  Begin
    EKGWin.PTestList.Hide;
    MuseTestsForPatient.Show;
    MuseTestsForPatient.LbName.caption := EKGWin.LbName.caption;
    MuseTestsForPatient.LbSSN.caption := EKGWin.LbSSN.caption;
    MuseTestsForPatient.LbSSNdisp.caption := EKGWin.LbSSNdisp.caption;
    MuseTestsForPatient.bbNext14.Enabled := EKGWin.UbbNext14.Enabled;
    MuseTestsForPatient.bbALL.Enabled := EKGWin.UbbALL.Enabled;
    MuseTestsForPatient.LCount.caption := EKGWin.Lbtestcount.caption;
    MuseTestsForPatient.ListBox1.Items.Assign(cbListOfTests.Items);
  End;

(*  IF MuseTestsForPatient.VISIBLE THEN
 BEGIN
 S := MuseTestsForPatient.LBSSN.CAPTION;
 while pos('-',S) <> 0 do delete(S,pos('-',S),1);
 N := MuseTestsForPatient.LBNAME.CAPTION;
 EKGWin.pTestList.show;
 MuseTestsForPatient.hide;
 uShowTestsForPatient(s,n,EKGWin.lbname,EKGWin.lbssn,EKGWin.lbssndisp);
 END
 ELSE
 BEGIN
 S := EKGWin.LBSSN.CAPTION;
 while pos('-',S) <> 0 do delete(S,pos('-',S),1);
 N := EKGWin.LBNAME.CAPTION;
 EKGWin.pTestList.hide;
 MuseTestsForPatient.show;
 uShowTestsForPatient(s,n,MuseTestsForPatient.lbname,MuseTestsForPatient.lbssn,MuseTestsForPatient.lbssndisp);
 END;   *)
End;

Procedure TEKGWin.ShowmessagesClick(Sender: Tobject);
Begin
  Showmessages.Checked := Not Showmessages.Checked;
  MPanel.Visible := Showmessages.Checked;
End;

Procedure TEKGWin.ClearMessagesClick(Sender: Tobject);
Begin
  MsgListBox.Clear;
End;

Procedure TEKGWin.ZoomTrackChange(Sender: Tobject);

Var
  w, h: Longint;
  z, Zf, Zx: byte;
Begin
  LbZoom.caption := Inttostr(100 + Strtoint(Inttostr(ZoomTrack.Position) + '0')) + ' %';
  LastSizingAction := [Zoom];
  If ZoomTrack.Position = 0 Then
  Begin
    ECGDisplay.Width := ImageWidth;
    ECGDisplay.Height := ImageHeight;
    Exit;
  End;
  If ZoomTrack.Position > 0 Then
  Begin
    z := ZoomTrack.Position;
    Zf := (z Div 10) + 1;
    Zx := (z Mod 10);
   {ecgdisplay.width := trunc(ecgdisplay.width * (1+(MuseTestType.TrackBar1.position/10)));
   ecgdisplay.height := trunc(ecgdisplay.height * (1+(MuseTestType.TrackBar1.position/10)));}
    w := Trunc(ImageWidth * (Zf + (Zx / 10)));
    h := Trunc(ImageHeight * (Zf + (Zx / 10)));
    ECGDisplay.SetBounds(0, 0, w, h);
    LastSizingAction := [Zoom];
  End;
  If ZoomTrack.Position < 0 Then
  Begin
    z := Abs(ZoomTrack.Position);
   {ecgdisplay.width := trunc(ecgdisplay.width / (1+(MuseTestType.TrackBar1.position/10)));
   ecgdisplay.height := trunc(ecgdisplay.height /(1+(MuseTestType.TrackBar1.position/10)));}
    w := Trunc(ImageWidth / (1 + (z / 10)));
    h := Trunc(ImageHeight / (1 + (z / 10)));
    ECGDisplay.SetBounds(0, 0, w, h);
  End;
End;

Procedure TEKGWin.MenableallClick(Sender: Tobject);
Begin
  UbbNext14.Enabled := True;
  UbbALL.Enabled := True;
  UbbALL.Update;
  UbbNext14.Update;
End;

Procedure TEKGWin.FormDestroy(Sender: Tobject);
Var
  Tini: TIniFile;
  x: String;
Begin
  SaveFormPosition(Self As TForm);

  Tini := TIniFile.Create(GetConfigFileName);
  Try

    With ECGDisplay Do
    Begin
      x := Inttostr(Width) + ',' + Inttostr(Height);
      Tini.Writestring('VISTAMUSE', 'IMAGESIZE', x);
    End;
    If GridOn = True Then
      x := 'TRUE'
    Else
      x := 'FALSE';
    Tini.Writestring('VISTAMUSE', 'GRIDON', x);
    If ShowDottedGridDlg = True Then
      x := 'TRUE'
    Else
      x := 'FALSE';
    Tini.Writestring('VISTAMUSE', 'ShowDottedGridDlg', x);
    If PrintDottedGrid = True Then
      x := 'TRUE'
    Else
      x := 'FALSE';
    Tini.Writestring('VISTAMUSE', 'PrintDottedGrid', x);

  Finally
    Tini.Free;
    FreeLibrary(LibHandle); //   Free muse dll when finished SAF 1/24/2000
  End;

End;

Procedure TEKGWin.WarningColor(Warn: Boolean);
Var
  Color: TColor;
Begin
  If Warn Then
    Color := clTeal
  Else
    Color := clBtnFace;
  Panel2.Color := Color;
  LbTestDesc.Color := Color;
  LbSSNdisp.Color := Color;
  LbName.Color := Color;
End;

Initialization

  MUSEConStatus := 0;

End.
