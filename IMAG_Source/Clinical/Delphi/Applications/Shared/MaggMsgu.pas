Unit Maggmsgu;

{/
  <unit> MaggMsgu

  <package> MAG - VistA Imaging

  <warning> WARNING: Per VHA Directive 10-93-142 this unit should not be modified.

  <date created> Unknown

  <site name> Silver Spring, OIFO

  <developers>  Garrett Kirin
                Jerry Kashtan October 2009 - Refactored for Patch 94

  <description>
   From Patch 94 - MaggMsgu was refactored for Patch 94 and new features added to make
   this unit consistent.  Prior to P94 there were a number of methods to log a message.
   Because MaggMsgu has to be backwards compatible it maintains the old methods
   and introduces new ones to eventually replace old methods when this unit is
   used in future patches.

   From Patch 93 - Imaging Message History Window, and Advanced Image information
   window. (for System managers)
   Long term design is to have a central message dispatcher object.  Which will do
   various funtions with the message text.  Main funtion is to maintain a message
   history (message log).
   This Utility window keeps a User defined number of the last number messages
   that were displayed in the application.  It is mainly for debugging purposes.
   User with the MAG SYSTEM key will see more messages that average user.  The
   extra messages usually contain DataBase, Network, OS specific information.

   Other controls in the application can call methods to display messages to
   a specific TPanel Object and have the message logged at the same time.

   Future  : Method to save the message history to a log file.
             Method to save to VistA (IMAGING WINDOWS SESSION file)
             Method to save specific coded messages to VistA Log File
             IMAGE ACCESS LOG, IMAGING WINDOWS SESSION Files
             Method to 'Send' history to Customer support/Selected mail recipient

  <dependencies> 3rd Party Delphi Zip Code in VCLZip_Pro

  <note>

  <history>
    Patch 94 10/2009 JK - refactoring

  <VA/FDA Statement>
      ;; +---------------------------------------------------------------------------------------------------+
      ;; Property of the US Government.
      ;; No permission to copy or redistribute this software is given.
      ;; Use of unreleased versions of this software requires the user
      ;;  to execute a written test agreement with the VistA Imaging
      ;;  Development Office of the Department of Veterans Affairs,
      ;;  telephone (301) 734-0100.
      ;;
      ;; The Food and Drug Administration classifies this software as
      ;; a medical device.  As such, it may not be changed
      ;; in any way.  Modifications to this software may result in an
      ;; adulterated medical device under 21CFR820, the use of which
      ;; is considered to be a violation of US Federal Statutes.
      ;; +---------------------------------------------------------------------------------------------------+
/}

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
  ComCtrls,
  ToolWin,
  FileCtrl,
  Menus,
  Clipbrd,
  kpSFXCfg,
  VCLUnZip,
  VCLZip,
  AppEvnts;

Const
  DEFAULT_PASSWORD = 'VA%'; {This password is used to open the zip file on disk
                                    unless it is specifically set in the open method.}

  MAX_IN_MEMORY_LINE_COUNT = 2000; {This is the maximum number of in-memory log lines allowed
                                    at any given time. When the limit is reached the in-memory
                                    lines are flushed to a zip archive and the in-memory list
                                    cleared to zero lines.}

Type
  TPrivLevel = (plAdmin, plUser, plUnknown);

  {TMagLogPriority is for backwards compatibility with P93}
  TMagLogPriority = (MagLogDebug, MagLogINFO, MagLogWARN, MagLogERROR, MagLogFATAL);

  {LOGGER is for logger internal messages to the user - do not use in the host application}
  TMagLoggerLevel = (DEBUG, TRACE, Marker, LOGGER, Warn, ERROR, Info, FATAL, COMM, COMMERR, CCOW, SYS, NONSYS);

  TExtraDisplayInfo = Class
  Private
    FSerialNumber: String;
    FFormattedStr: String;
  Public
    Property SerialNumber: String Read FSerialNumber;
    Property FormattedStr: String Read FFormattedStr;
    Constructor Create(Const SerialNum, FormattedStr: String);
  End;

  {*
     The MagLogger class provides the public methods for log management and
     log messaging.
  }
  MagLogger = Class
  Private
    FWriteImmediate: Boolean;
    Class Function isOKToLogFile(Const AFileName: String): Boolean;
    Class Function GetLevelString(Level: TMagLoggerLevel): String;
    Class Procedure AdjustLogFileSize(ALogFileName: String);
    Class Function GetPrivLevel: TPrivLevel;
    Class Function GetWriteImmediate: Boolean;
    Class Procedure SetWriteImmediate(Const Value: Boolean);
  Public
    Class Procedure Open(PrivLevel: TPrivLevel;
                          LogFileName: String;
                          AutoLogToFile: Boolean;
                          ZipPassword: String;
                          ZipDaysToKeep: Integer;
                          MaxFileSizeBytes: Cardinal;
                          AppTitle: String;
                          pWriteImmediate: Boolean;
                          RetroStyle: Boolean = True);
    Class Procedure Close;
    Class Procedure Show;
    Class Procedure BringToFront;

    {Class methods for for backward compatibility with P93}
    Class Procedure Log(Level: TMagLoggerLevel; s: String);
    Class Procedure LogList(Level: TMagLoggerLevel; L: Tstringlist);
    Class Procedure MagMsg(c, s: String; Pmsg: Tpanel = Nil);
    Class Procedure MagMsgs(c: String; t: Tstringlist);
    Class Procedure LogMsg(MsgType: String; Msg: String; Priority: TMagLogPriority = MagLogINFO);
    Class Procedure LogMsgs(MsgType: String; Msgs: Tstringlist; Priority: TMagLogPriority = MagLogINFO);
    Class Function GetLogEventPriorityString(Priority: TMagLogPriority): String;

    Class Procedure WriteImmediate(Value: Boolean);
    Class Procedure SetPrivLevel(Value: TPrivLevel);

    Class Procedure SnapshotToZipFile(Password: String = DEFAULT_PASSWORD);
  End;

  {*
     The TMaggMsgf class is used by the logger to manage the log strings and
     format them for display
  }
  TMaggMsgf = Class(TForm)
    MsgMemo: TMemo;
    FontDialog1: TFontDialog;
    FileListBox1: TFileListBox;
    cd1: TColorDialog;
    PopupMenu1: TPopupMenu;
    MMsgcount: TMenuItem;
    SaveMessagehistorylisttofile1: TMenuItem;
    SaveDialog1: TSaveDialog;
    SaveSystemMessagetoFile1: TMenuItem;
    DirectoryListBox1: TDirectoryListBox;
    StatusBar1: TStatusBar;
    MainMenu1: TMainMenu;
    MnuFile: TMenuItem;
    MnuOptions: TMenuItem;
    MnuHelp: TMenuItem;
    MnuExit: TMenuItem;
    MnuFont: TMenuItem;
    MnuStayOnTop: TMenuItem;
    MnuClearhistory: TMenuItem;
    MnuColor: TMenuItem;
    MnuMessageHistoryHelp: TMenuItem;
    MnuWordWrap: TMenuItem;
    MnuiSystemmessages: TMenuItem;
    N2: TMenuItem;
    Pnlhidden: Tpanel;
    TbSysMemo: TCheckBox;
    TbWrap: TCheckBox;
    mnuFilter: TMenuItem;
    mnuFilter_AllMessages: TMenuItem;
    N3: TMenuItem;
    mnuFilter_OnlyComm: TMenuItem;
    mnuFilter_NoComm: TMenuItem;
    mnuFilter_AllComm: TMenuItem;
    mnuFilter_SuppressInfoMsgs: TMenuItem;
    mnuFilter_HighlightErrors: TMenuItem;
    mnuFilter_SuppressDebugMsgs: TMenuItem;
    reMemo: TRichEdit;
    Refresh1: TMenuItem;
    pmuClipboard: TPopupMenu;
    itemUndo: TMenuItem;
    N4: TMenuItem;
    itemCut: TMenuItem;
    itemCopy: TMenuItem;
    itemPaste: TMenuItem;
    itemDelete: TMenuItem;
    N6: TMenuItem;
    itemSelectAll: TMenuItem;
    SaveLogToFile1: TMenuItem;
    N7: TMenuItem;
    Timer1: TTimer;
    mnuFilter_NoCCOW: TMenuItem;
    N1: TMenuItem;
    mnuFilter_AllCCOW: TMenuItem;
    mnuFilter_OnlyCCOW: TMenuItem;
    N8: TMenuItem;
    FindDialog1: TFindDialog;
    FindText1: TMenuItem;
    N5: TMenuItem;
    FindText2: TMenuItem;
    N9: TMenuItem;
    FindText3: TMenuItem;
    PrintTheLogFile1: TMenuItem;
    VCLZip1: TVCLZip;
    ApplicationEvents1: TApplicationEvents;
    DebugHALT1: TMenuItem;
    RunError1: TMenuItem;
    AddMarkerToText1: TMenuItem;
    ListBox1: TListBox;
    VCLZip2: TVCLZip;
    SaveDialog2: TSaveDialog;
    mnuSnapshot: TMenuItem;
    mnuShowLogLevels: TMenuItem;
    RefreshDisplay1: TMenuItem;
    RefreshDisplay2: TMenuItem;
    AutoUpdate1: TMenuItem; //45
    Procedure TbWrapClick(Sender: Tobject);
    Procedure FormCreate(Sender: Tobject);
    Procedure TbSysMemoClick(Sender: Tobject);
    Procedure PopupMenu1Popup(Sender: Tobject);
    Procedure FormActivate(Sender: Tobject);
    Procedure FormShow(Sender: Tobject);
    Procedure MnuExitClick(Sender: Tobject);
    Procedure MnuStayOnTopClick(Sender: Tobject);
    Procedure Retainthelastxxxmessages1Click(Sender: Tobject);
    Procedure MnuSaveMessagehistorytofileClick(Sender: Tobject);
    Procedure MnuFontClick(Sender: Tobject);
    Procedure MnuClearhistoryClick(Sender: Tobject);
    Procedure MnuColorClick(Sender: Tobject);
    Procedure MnuOptionsClick(Sender: Tobject);
    Procedure MnuWordWrapClick(Sender: Tobject);
    Procedure MnuiSystemmessagesClick(Sender: Tobject);
    Procedure MnuMessageHistoryHelpClick(Sender: Tobject);
    Procedure mnuFilter_AllMessagesClick(Sender: Tobject);
    Procedure mnuFilter_AllCommClick(Sender: Tobject);
    Procedure mnuFilter_OnlyCommClick(Sender: Tobject);
    Procedure mnuFilter_NoCommClick(Sender: Tobject);
    Procedure mnuFilter_SuppressDebugMsgsClick(Sender: Tobject);
    Procedure mnuFilter_SuppressInfoMsgsClick(Sender: Tobject);
    Procedure mnuFilter_HighlightErrorsClick(Sender: Tobject);
    Procedure pmuClipboardPopup(Sender: Tobject);
    Procedure itemUndoClick(Sender: Tobject);
    Procedure itemCutClick(Sender: Tobject);
    Procedure itemCopyClick(Sender: Tobject);
    Procedure itemPasteClick(Sender: Tobject);
    Procedure itemDeleteClick(Sender: Tobject);
    Procedure itemSelectAllClick(Sender: Tobject);
    Procedure SaveLogToFile1Click(Sender: Tobject);
    Procedure Timer1Timer(Sender: Tobject);
    Procedure mnuFilter_AllCCOWClick(Sender: Tobject);
    Procedure mnuFilter_NoCCOWClick(Sender: Tobject);
    Procedure mnuFilter_OnlyCCOWClick(Sender: Tobject);
    Procedure FindText1Click(Sender: Tobject);
    Procedure FindText2Click(Sender: Tobject);
    Procedure FindDialog1Find(Sender: Tobject);
    Procedure FindText3Click(Sender: Tobject);
    Procedure FormClose(Sender: Tobject; Var action: TCloseAction);
    Procedure PrintTheLogFile1Click(Sender: Tobject);
    Procedure reMemoKeyDown(Sender: Tobject; Var Key: Word; Shift: TShiftState);
    Procedure FindDialog1Show(Sender: Tobject);
    Procedure ApplicationEvents1Exception(Sender: Tobject; e: Exception);
    Procedure DebugHALT1Click(Sender: Tobject);
    Procedure RunError1Click(Sender: Tobject);
    Procedure AddMarkerToText1Click(Sender: Tobject);
    Procedure reMemoClick(Sender: Tobject);
    Procedure reMemoKeyUp(Sender: Tobject; Var Key: Word; Shift: TShiftState);
    Procedure mnuSnapshotClick(Sender: Tobject);
    Procedure mnuShowLogLevelsClick(Sender: Tobject);
    Procedure RefreshDisplay1Click(Sender: Tobject);
    Procedure RefreshDisplay2Click(Sender: Tobject);
  Private

    FPrivLevel: TPrivLevel;
    FZipFileName: String;
    FAutoLogToFile: Boolean;
    FZipPassword: String;
    FAppTitle: String;
    FWriteImmediate: Boolean;
    FZipDaysToKeep: Integer;
    FMaxFileSizeBytes: Cardinal;
    FRetroStyle: Boolean; {/ JK 10/26/2009 - tells the display to make the menu bar hide the filter option (P93/P94 style) /}

    FFontSize: Integer;
    FFontStyle: TFontStyles;
    FFontName: TFontName;
    FFontColor: TColor;

    FMsgCount: Integer;
    FSysMsgCount: Integer; { Private declarations }
    Function CurTime: String;
    Procedure LogMessage(Sender: Tobject; MsgType: String; Msg: String; Priority: TMagLogPriority);
    Function Maglength(Str, Delim: String): Integer;
    Function MagPiece(Str, Delim: String; Piece: Integer): String;
    Function MagLastPieceAfter(Str, Delim: String; Piece: Integer): String;
    Function MagSetPiece(InString: String; Delimiter: String; Piece: Integer; ReplacePiece: String): String;
    Function GetRichEditFromPopup: TRichEdit;
    Procedure RenumberSerialNums;
    Procedure FreeObjects(Const Strings: TStrings);
    Function OpenZip: Boolean;
    Function CompressStream(StreamToCompress: TMemoryStream; Filename: String): TMemoryStream;
    Function ZipFromBuffer: Boolean;
    Function ZipFromStream(AStream: TMemoryStream): Boolean;
    Procedure SetRichEditMargins(Const mLeft, mRight, mTop, mBottom: Extended; Const re: TRichEdit);
    Procedure HighlightLine;
    Procedure PruneZipFile;
    Procedure Snapshot(Const APassword: String);
    Function CurrentMemoryUsage: String;
    Function GetTotalSystemMemory: String;
    Function GetComputerName: String;
    Function GetOSVersion: String;
    Function MiniSaveMemoryToZipFile(Var sList: Tstringlist): Boolean;
    procedure SetRetroStyle(const Value: Boolean); {/ JK 12/17/2009 - P94 /}
  Public
    {   Set to TRUE if user has MAG SYSTEM key}
    Syskey: Boolean;
    Constructor Create(Owner: Tobject);
    {   Display a message to a TPanel object and log it in the history
        c : is a code sting containing any combinaton of the defined codes.
                The codes determine how to display the message.
          's' - system message, add to sysmemo.
          'd' - display in a dialog window.
          ''  - add to msgmemo, (and sysmemo)
          'e' - Error message, display 'Error' text with message and dialog
          'QA' - Integrity Error.  Display 'QUESTIONABLE INTEGRITY' in message
          }
    Procedure MagMsg(c, s: String; Pmsg: Tpanel = Nil; LogLevel: TMagLoggerLevel = Info);

    {   Display a Stringlist, and Log in in the history}
    Procedure MagMsgs(c: String; t: Tstringlist);
    {   if SysKey=TRUE the system memo is visible.}
    Procedure Enable_reMemo(Value: Boolean);
    {DONE:  get this out of here, move to unit with related functions }
    //{   Erase all files in the \cache directory.  Usually called when application
    //    is being destroyed }
    //procedure EraseCacheFiles;
    {  Specific message for debugging, stores a free text message and the Image IEN
       to the History file.}
    Procedure IENCheck(WhatImDoing: String; Ien: String);
    {  Specific message for debugging, stores all Image IENS from the Tlist object
       to the History file.}
//    procedure IENsToMsgWindow(t: Tlist);

    Procedure WriteOneLine(Const s: String);
    Function GetLogType(Level: TMagLoggerLevel): String;

    Function StampASerialNumber: String;
    Procedure RefreshMemo;
    Procedure InsertMarkerAtCursor(ALine: String; ARichEdit: TRichEdit);

    Procedure PrintLogFile;

    Procedure SearchFor;

    {/ JK 1/18/2010 - P94 - Added Bill Balshem MessageDlg and ShowMessage routines
       designed to work in a 508 environment. /}
    Procedure ShowMessage508(Const Msg: String);
    Function MessageDlg508(Const Msg: String; DlgType: TmsgDlgType; Buttons: TMsgDlgButtons; HelpCtx: Integer): Integer;

    Property PrivLevel: TPrivLevel Read FPrivLevel Write FPrivLevel;
    Property ZipFileName: String Read FZipFileName Write FZipFileName;
    Property AutoLogToFile: Boolean Read FAutoLogToFile Write FAutoLogToFile;
    Property ZipPassword: String Read FZipPassword Write FZipPassword;
    Property ZipDaysToKeep: Integer Read FZipDaysToKeep Write FZipDaysToKeep;
    Property MaxFileSizeBytes: Cardinal Read FMaxFileSizeBytes Write FMaxFileSizeBytes;
    Property AppTitle: String Read FAppTitle Write FAppTitle;
    Property WriteImmediate: Boolean Read FWriteImmediate Write FWriteImmediate;
    Property RetroStyle: Boolean Read FRetroStyle Write SetRetroStyle;

  End;

Implementation

{$R *.DFM}

Uses
  Printers,
  kpZipObj,
  StrUtils,
  PsAPI,
  Shellapi;

Var
  frmMaggMsg: TMaggMsgf;

  ShowAllMessages: Boolean;
  ShowAllComm: Boolean;
  ShowOnlyComm: Boolean;
  ShowAllCCOW: Boolean;
  ShowOnlyCCOW: Boolean;
  SuppressComm: Boolean;
  SuppressDebug: Boolean;
  SuppressInfo: Boolean;
  SuppressCCOW: Boolean;
  SuppressLogger: Boolean;
  HighlightErrors: Boolean;

  ShowLogLevels: Boolean;

  CritSect: TRTLCriticalSection;

  RawInfo: Tstringlist;
  SerialNum: Integer;
  FullLogFileName: String;
  LogToDisk: Boolean;
  FDiskFile: Textfile;
  LoggerStarted: Boolean;
  LogInfoChanged: Boolean;
  WriteImmediateFilename: String;

  FirstTimeRefresh: Boolean;

Procedure TMaggMsgf.IENCheck(WhatImDoing: String; Ien: String);
Begin
  Try
    WriteOneLine(WhatImDoing + '  ' + Ien);
  Except
    //messagedlg('--- Invalid IEN' + #13 + 'Queing Images to Copy from JukeBox', mtconfirmation, [mbok], 0);
    MessageDlg508('--- Invalid IEN' + #13 + 'Queing Images to Copy from JukeBox', Mtconfirmation, [Mbok], 0);
    MsgMemo.Lines.Add(CurTime + WhatImDoing + '---  Error with IEN');
    WriteOneLine(WhatImDoing + '---  Error with IEN');
    WriteOneLine('IEN is :' + Ien);
  End;

End;

Procedure TMaggMsgf.itemCopyClick(Sender: Tobject);
Begin
  GetRichEditFromPopup.CopyToClipboard;
End;

Procedure TMaggMsgf.itemCutClick(Sender: Tobject);
Begin
  GetRichEditFromPopup.CutToClipboard;
End;

Procedure TMaggMsgf.itemDeleteClick(Sender: Tobject);
Begin
  GetRichEditFromPopup.ClearSelection;
End;

Procedure TMaggMsgf.itemPasteClick(Sender: Tobject);
Begin
  GetRichEditFromPopup.PasteFromClipboard;
End;

Procedure TMaggMsgf.itemSelectAllClick(Sender: Tobject);
Begin
  GetRichEditFromPopup.SelectAll;
End;

Procedure TMaggMsgf.itemUndoClick(Sender: Tobject);
Begin
  GetRichEditFromPopup.Undo;
End;

Procedure TMaggMsgf.MagMsg(c, s: String; Pmsg: Tpanel = Nil; LogLevel: TMagLoggerLevel = Info);
Var
  t: String;
  i: Integer;
  Msgdlgtype: TmsgDlgType;
Begin
  If Application.Terminated Then Exit; {debug94}
  {Display a message to a TPanel object and log it in the history
     c: is a code sting containing any combinaton of the defined codes.
     The codes determine how to display the message.
       's' - system message, add to sysmemo.
       'd' - display in a dialog window.
       ''  - add to msgmemo, (and sysmemo)
       'e' - Error message, display 'Error' text with message and dialog
       'QA' - Integrity Error.  Display 'QUESTIONABLE INTEGRITY' in message
  }

  c := Uppercase(c);

  If (Pos('S', c) = 0) And (Pmsg <> Nil) Then
    Pmsg.Font.Color := clBlack;

  If (Pos('QA', c) > 0) Then
    s := 'QUESTIONABLE INTEGRITY' + #13 + #13 +
      s + #13 + #13 + 'Report this problem to Imaging Support.';

  If Pos('D', c) > 0 Then
  Begin
    Msgdlgtype := Mtconfirmation;

    If (Pos('E', c) > 0) Then
      Msgdlgtype := Mterror;

    If (Pos('I', c) > 0) Then
      Msgdlgtype := Mtinformation;

    //MessageDlg(s, MsgDlgType, [mbok], 0);
    MessageDlg508(s, Msgdlgtype, [Mbok], 0);
  End;

  If Pmsg.caption = s Then
  Begin
    If Pos('E', c) > 0 Then
    Begin
      Messagebeep(0);
      Pmsg.Font.Color := clRed;
    End;

    Exit; { gek 4/1/97 stop multiple lines of 'processing...'}
  End;

  {If this is a system message and user doesn't have a system key, we quit}
  //  if SysKey then
  If frmMaggMsg <> Nil Then
    If frmMaggMsg.PrivLevel <> plUser
     Then
       if reMemo <> nil then reMemo.BringToFront;  {129t10 gek Qfix.  stop access violations. }

  If Pos('S', c) > 0 Then
  Begin
    If Pos(#13, s) > 0 Then
      While Length(s) > 0 Do
      Begin
        If Pos(#13, s) = 0 Then
        Begin
          MagLogger.Log(SYS, s);
          s := '';
        End
        Else
        Begin
          MagLogger.Log(SYS, Copy(s, 1, Pos(#13, s)));
          s := Copy(s, Pos(#13, s) + 1, 99999);
        End;
      End;
    {all are displayed except for 'S' (System)(Silent) types}
    MagLogger.Log(SYS, ' * ' + s);
    Exit;
  End
  Else
    MagLogger.Log(NONSYS, s);

  If Pmsg <> Nil Then
    If Pos('E', c) > 0 Then
      Pmsg.Font.Color := clRed;

  While Pos(#13, s) > 0 Do
  Begin
    i := Pos(#13, s);
    t := s;
    t := Copy(s, 1, i - 1) + ' ' + Copy(s, i + 1, 240);
    s := t;
  End;
 {P94T4  T5  GEK 1/5/10   PUT MESSAGE BACK IN.  Out by Jerry, In by Garrett.}
  If Pmsg <> Nil Then
  Begin
    Pmsg.caption := s;
    Pmsg.Update;
    //MagLogger.Log(SYS, s);  {/ JK 2/15/2010 - removed. Does not belong here /}
  End;

End;

Function TMaggMsgf.GetLogType(Level: TMagLoggerLevel): String;
Begin
  Case Level Of
    DEBUG: Result := 'DEBUG:';
    TRACE: Result := 'TRACE:';
    Marker: Result := 'MARKER:';
    LOGGER: Result := 'LOGGER:';
    Warn: Result := 'WARN:';
    ERROR: Result := 'ERROR:';
    Info: Result := 'INFO:';
    FATAL: Result := 'FATAL:';
    COMM: Result := 'COMM:';
    COMMERR: Result := 'COMMERR:';
    CCOW: Result := 'CCOW:';
    SYS: Result := 'SYS:'; {/ JK 10/27/2009 - For Backwards compatibility with P93/P94 /}
    NONSYS: Result := 'NONSYS:'; {/ JK 10/27/2009 - For Backwards compatibility with P93/P94 /}
  Else
    Result := '???:';
  End;
End;

Procedure TMaggMsgf.SaveLogToFile1Click(Sender: Tobject);
Begin
  If Self.SaveLogToFile1.Checked Then
  Begin
    LogToDisk := True;
    //StatusBar1.Panels[1].Text :=  'Logging captured to:' + FullLogFileName;  {JK 3/24/2010 - removed in T8}
    StatusBar1.Panels[1].Text := ''; {JK 3/24/2010 - added for T8}
  End
  Else
  Begin
    LogToDisk := False;
    StatusBar1.Panels[1].Text := 'Logging to disk file is disabled';
  End;
End;

Procedure TMaggMsgf.SearchFor;
Begin
  FindDialog1.Execute;
End;

Function TMaggMsgf.StampASerialNumber: String;
Begin
  SerialNum := SerialNum + 1;
  Result := Inttostr(SerialNum);
End;

Function TMaggMsgf.CurTime: String;
Begin
  Result := Formatdatetime('hh.nn.ss.zzz', Now) + '  ';
End;

Procedure TMaggMsgf.DebugHALT1Click(Sender: Tobject);
Begin
  Halt; //for debugging crash dump mode.
End;

Procedure TMaggMsgf.TbWrapClick(Sender: Tobject);
Begin
  If TbWrap.Checked Then
  Begin
    MsgMemo.Wordwrap := True;
    MsgMemo.ScrollBars := SsVertical;
    reMemo.Wordwrap := True;
    reMemo.ScrollBars := SsVertical;
  End
  Else
  Begin
    MsgMemo.Wordwrap := False;
    MsgMemo.ScrollBars := SsBoth;
    reMemo.Wordwrap := False;
    reMemo.ScrollBars := SsBoth;
  End;
End;

Procedure TMaggMsgf.Timer1Timer(Sender: Tobject);
Begin
  If AutoUpdate1.Checked Then
    If Self.Visible Then
      If LogInfoChanged Then
        RefreshMemo;
End;

Procedure TMaggMsgf.FormClose(Sender: Tobject; Var action: TCloseAction);
Begin
  FindDialog1.CloseDialog;
End;

Procedure TMaggMsgf.FormCreate(Sender: Tobject);
Begin
  Syskey := False;
  FMsgCount := 2000;
  FSysMsgCount := 3000;
  SerialNum := 0;
  FFontColor := clBlack;
  msgmemo.Align := alclient;
  rememo.Align := alclient;
End;

Procedure TMaggMsgf.LogMessage(Sender: Tobject; MsgType: String; Msg: String; Priority: TMagLogPriority);
Begin
  MagMsg(MsgType, Msg);
End;

Procedure TMaggMsgf.Enable_reMemo(Value: Boolean);
Begin
  Syskey := Value;
  If Syskey Then
  Begin
    reMemo.BringToFront;
    TbSysMemo.Visible := True;
    TbSysMemo.Checked := True;

    MnuColor.Visible := True;
  End
  Else
  Begin
    reMemo.SendToBack;
    TbSysMemo.Visible := False;
    MnuColor.Visible := False;
  End;
  Update;
End;

Procedure TMaggMsgf.TbSysMemoClick(Sender: Tobject);
Begin
  //if tbSysMemo.Checked then
  //  reMemo.BringToFront
  //else
  //  reMemo.SendToBack;
End;

{JK 10/6/2009 - This function was moved to FMagMain in P94 for the time being}
//procedure Tmaggmsgf.EraseCacheFiles;
//var
//  i, j: integer; //45 j
//  xfile: string;
//  d1, d2 : PChar;  //45
//  CurrentDir : String;  //45
//begin
//{TODO -clowPriority:  We get error if Video File is opened}
//{file won't be erased if the mPlay32.exe is still open with a file.}
//  for i := filelistbox1.Items.Count - 1 downto 0 do
//  begin
//    xfile := filelistbox1.Items[i];
//    deletefile(xfile);
//  end;
//  application.processmessages;
////45 startchanges
//  // JMW 6/17/2005 p45 delete all files in subdirectories
//  d2 := PChar(AnsiUpperCase(directorylistbox1.Directory));
//  for i := directorylistbox1.Items.count -1 downto 1 do
//  begin
//    d1 := PChar(AnsiUpperCase(directorylistbox1.items[i]));
//    if strpos(d2, d1) = nil then
//    begin
//      CurrentDir := directorylistbox1.Directory + '\' + directorylistbox1.Items[i];
//      //filelistbox1.Directory := directorylistbox1.Directory + '\' + directorylistbox1.Items[i];
//      filelistbox1.Directory := currentdir;
//      for j := filelistbox1.Items.count -1  downto 0 do
//      begin
//        deletefile(filelistbox1.Items[j]);
//      end;
//      filelistbox1.Directory := directorylistbox1.Directory;
//      removedir(currentDir); // delete the directory the images were in
//    end;
//  end;
//  application.ProcessMessages();
////45 endchanges
//end;

Procedure TMaggMsgf.PopupMenu1Popup(Sender: Tobject);
Begin
  MMsgcount.caption := 'Retain the last ' + Inttostr(FMsgCount) + ' messages...';
End;

Procedure TMaggMsgf.PrintLogFile;
Var
  SaveFileName: String;
  LogFileSize: Longint;
  LogLines: Integer;
Begin

  LogLines := reMemo.Lines.Count;

  If LogLines > 500 Then
    //if MessageDlg('The print job has ' + IntToStr(LogLines) + ' in it. Click YES to ' +
    //              'print it or click CANCEL to quit', mtConfirmation, [mbYes, mbCancel], 0) = mrCancel then
    If MessageDlg508('The print job has ' + Inttostr(LogLines) + ' in it. Click YES to ' +
      'print it or click CANCEL to quit', Mtconfirmation, [MbYes, Mbcancel], 0) = MrCancel Then
      Exit;

  SetRichEditMargins(1, 1, 0.5, 0.5, reMemo);
  reMemo.Print(frmMaggMsg.AppTitle + ' Log File');

End;

Procedure TMaggMsgf.PrintTheLogFile1Click(Sender: Tobject);
Begin
  PrintLogFile;
End;

Procedure TMaggMsgf.MagMsgs(c: String; t: Tstringlist);
Var
  i: Integer;
Begin
  For i := 0 To t.Count - 1 Do
  Begin
    MagMsg(c, t[i]);
  End;
End;

Procedure TMaggMsgf.FindDialog1Find(Sender: Tobject);
Var
  FoundAt: Longint;
  StartPos, ToEnd: Integer;
  Oldcursor: TCursor;

  FindTextOptions: TFindOptions;
  SearchOptions: TSearchTypes;

Begin
  Oldcursor := Screen.Cursor;
  Screen.Cursor := crHourGlass;

  FindTextOptions := FindDialog1.Options;

  SearchOptions := [];
  If frMatchCase In FindTextOptions Then
    SearchOptions := [stMatchCase];
  If frWholeWord In FindTextOptions Then
    SearchOptions := SearchOptions + [stWholeWord];

  Try

    With reMemo Do
    Begin

      { begin the search after the current selection if there is one }
      { otherwise, begin at the start of the text }
      If SelLength <> 0 Then
        StartPos := SELSTART + SelLength
      Else
        StartPos := 0;

      { ToEnd is the length from StartPos to the end of the text in the rich edit control }
      ToEnd := Length(Text) - StartPos;

      FoundAt := FindText(FindDialog1.FindText, StartPos, ToEnd, SearchOptions);

      If FoundAt <> -1 Then
      Begin
        SetFocus;
        SELSTART := FoundAt;
        SelLength := Length(FindDialog1.FindText);

        SendMessage(reMemo.Handle, EM_SCROLLCARET, 0, 0);
      End
      Else
        //MessageDlg(FindDialog1.FindText + ' not found or at the end of the text block.', mtInformation, [mbOK], 0);
        MessageDlg508(FindDialog1.FindText + ' not found or at the end of the text block.', Mtinformation, [Mbok], 0);
    End;

  Finally
    Screen.Cursor := Oldcursor;
  End;
End;

Procedure TMaggMsgf.FindDialog1Show(Sender: Tobject);
Begin
  FindDialog1.Position := Point(Self.Width Div 2, Self.Height Div 2);
End;

Procedure TMaggMsgf.FindText1Click(Sender: Tobject);
Begin
  SearchFor;
End;

Procedure TMaggMsgf.FindText2Click(Sender: Tobject);
Begin
  SearchFor;
End;

Procedure TMaggMsgf.FindText3Click(Sender: Tobject);
Begin
  SearchFor;
End;

{JK 12/17/2009 - P94 - If the in-memory line count exceeds the max allowed, a mini-save to
 the zip file as its own archive will occur and the in-memory string list cleared. This
 saves main memory form getting overwhelmed if a log line is in a loop and other scenarios. /}

Function TMaggMsgf.MiniSaveMemoryToZipFile(Var sList: Tstringlist): Boolean;
Var
  RawStream: TMemoryStream;
  MiniSaveTime: String;
  TempStringList: Tstringlist;
Begin
(*  Jk 3/24/2010 - removed for T8
  MiniSaveTime := FormatDateTime('mmm dd yyyy hh.nn.ss.zzz', Now);

  with VCLZip2 do
  begin
    ZipName         := Self.ZipFilename;
    Password        := Self.ZipPassword;
    Recurse         := True;
    StorePaths      := True;
    PackLevel       := 9;
    EncryptStrength := esAES128;   {JK 3/16/2010 - AES 128 bit encryption}
  end;

  TempStringList := TStringList.Create;
  try
    TempStringList.Add('*** MINI-SAVE TAKEN @ ' + MiniSaveTime + ' ***');
    TempStringList.AddStrings(sList);

    RawStream := TMemoryStream.Create;
    try
      RenumberSerialNums;
      RawInfo.SaveToStream(RawStream);
      RawStream.Position := 0;
      VCLZip2.ZipFromStream(RawStream, 'Mini-Save_' + MiniSaveTime + '.log');
      sList.Clear;  {Clear the in-memory stringlist now that it is written to the zip as a mini-save archive}
    finally
      RawStream.Free;
    end;

  finally
    TempStringList.Free;
  end;
  *)
  Result := True; {JK 3/24/2010 - added for T8}
End;

Procedure TMaggMsgf.FormActivate(Sender: Tobject);
Begin
  reMemo.ScrollBy(9, 9);
End;

Procedure TMaggMsgf.FormShow(Sender: Tobject);
Var
  i: Integer;
Begin
  ListBox1.Visible := False; {ListBox1 holds the serial number (index) into the rawinfo (unfiltered) stringlist needed for inserting markers}

{$IFDEF VER150} //If Delphi 7 don't provide the Marker functionality since the OnClick handler was not a part of the RichEdit component at that time
  AddMarkerToText1.Visible := False;
{$ELSE}
  AddMarkerToText1.Visible := True;
{$ENDIF}

  reMemo.ScrollBy(0, -999999);

  ShowAllMessages := False;
  mnuFilter_AllMessages.Checked := False;

  ShowAllComm := True;
  mnuFilter_AllComm.Checked := True;

  ShowOnlyComm := False;
  mnuFilter_OnlyComm.Checked := False;

  SuppressComm := False;
  mnuFilter_NoComm.Checked := False;

  ShowOnlyCCOW := False;
  mnuFilter_OnlyCCOW.Checked := False;

  SuppressCCOW := False;
  mnuFilter_NoCCOW.Checked := False;

  SuppressDebug := True;
  mnuFilter_SuppressDebugMsgs.Checked := True;

  SuppressInfo := False;
  mnuFilter_SuppressInfoMsgs.Checked := False;

  HighlightErrors := True;
  mnuFilter_HighlightErrors.Checked := True;

  SuppressLogger := True;

  ShowLogLevels := False;
  mnuShowLogLevels.Checked := False;

  //mnuiSystemmessagesClick(self); {/JK 1/19/2010 - P94T5 - IR P94-T5-1 - Removed this line/}
End;

Procedure TMaggMsgf.RefreshMemo;
Var
  i: Integer;
Begin
  Screen.Cursor := crHourGlass;
  Try
    reMemo.Lines.BeginUpdate;

    reMemo.Clear;

    RenumberSerialNums;

    For i := 0 To RawInfo.Count - 1 Do
      WriteOneLine(RawInfo[i]);

    SendMessage(reMemo.Handle, EM_SCROLLCARET, 0, 0); {/ JK 10/26/2009 - make the memo position itself at the end of the memo /}

    reMemo.Lines.EndUpdate;

    StatusBar1.Panels[0].Text := 'Log Cnt = ' + Inttostr(reMemo.Lines.Count);

    LogInfoChanged := False;

  Finally
    Screen.Cursor := crDefault;
  End;
End;

Procedure TMaggMsgf.AddMarkerToText1Click(Sender: Tobject);
Var
  MarkerMsg: String;
Begin
  MarkerMsg := '';
  MarkerMsg := InputBox('Logger', 'Enter marker message', '');

  If MarkerMsg <> '' Then
    InsertMarkerAtCursor(MarkerMsg, reMemo);

End;

Procedure TMaggMsgf.InsertMarkerAtCursor(ALine: String; ARichEdit: TRichEdit);
Var
  cci: Integer; //CurrentCharIndex
  cli: Integer; //CurrentLineIndex
  nlci: Integer; //NextLineCharIndex
  RawData: String;
  Insertat: Integer;
Begin
  cci := ARichEdit.SELSTART; //determine the cursor (carat) position in a line
  cli := ARichEdit.Perform(EM_LINEFROMCHAR, cci, 0); //determine Currentline
  nlci := ARichEdit.Perform(EM_LINEINDEX, cli + 2, 0); //determine CharacterIndex of next Line

  If cli >= 0 Then
  Begin
    EnterCriticalSection(CritSect);
    Try

      RawData := '>>>>' + '|' + Formatdatetime('hh.nn.ss.zzz', Now) + '|' + 'MARKER' + '|' + ALine;

      Try
        Insertat := Strtoint(StatusBar1.Panels[2].Text) + 1;
        RawInfo.Insert(Insertat, RawData);
        LogInfoChanged := True;
        RefreshMemo;
      Except
        On e: EConvertError Do
        Begin
          //MessageDlg('Cannot insert the marker line. ' +
          //  'Click a line in the list to indicate where to insert the mark.',
          //  mtWarning, [mbOK], 0);
          MessageDlg508('Cannot insert the marker line. ' +
            'Click a line in the list to indicate where to insert the mark.',
            MtWarning, [Mbok], 0);
          MagLogger.Log(LOGGER, 'Cannot insert the marker line. ' +
            'Click a line in the list to indicate where to insert the mark.');
        End;
      End;

    Finally
      LeaveCriticalSection(CritSect);
    End;
  End
  Else
    //MessageDlg('Cannot add a marker line at this time', mtConfirmation, [mbOK], 0);
    MessageDlg508('Cannot add a marker line at this time', Mtconfirmation, [Mbok], 0);

End;

Procedure TMaggMsgf.RenumberSerialNums;
Var
  i: Integer;
Begin
  FreeObjects(ListBox1.Items);
  ListBox1.Items.Clear;
  For i := 0 To RawInfo.Count - 1 Do
    RawInfo[i] := MagSetPiece(RawInfo[i], '|', 1, Inttostr(i));
End;

Procedure TMaggMsgf.ApplicationEvents1Exception(Sender: Tobject; e: Exception);
Begin
  MagLogger.Close;
End;

Procedure TMaggMsgf.MnuExitClick(Sender: Tobject);
Begin
  Close;
End;

Procedure TMaggMsgf.MnuStayOnTopClick(Sender: Tobject);
Begin
  MnuStayOnTop.Checked := Not MnuStayOnTop.Checked;

  If frmMaggMsg <> Nil Then
    If MnuStayOnTop.Checked Then
      frmMaggMsg.Formstyle := Fsstayontop //   maggmsgf.FormStyle := fsStayOnTop
    Else
      frmMaggMsg.Formstyle := FsNormal; //  maggmsgf.FormStyle := fsNormal;
End;

Procedure TMaggMsgf.reMemoClick(Sender: Tobject);
Begin
  HighlightLine;
End;

Procedure TMaggMsgf.HighlightLine;
Var
  cci: Integer; //CurrentCharIndex
  cli: Integer; //CurrentLineIndex
  clci: Integer; //CurrentLineCharIndex
  nlci: Integer; //NextLineCharIndex
  ObjStuff: TExtraDisplayInfo;
Begin
  cci := reMemo.SELSTART; //determine the cursor (carat) position in a line
  cli := reMemo.Perform(EM_LINEFROMCHAR, cci, 0); //determine Currentline
  clci := reMemo.Perform(EM_LINEINDEX, cli, 0); //determine CharacterIndex of next Line
  nlci := reMemo.Perform(EM_LINEINDEX, cli + 1, 0); //determine CharacterIndex of next Line

  reMemo.SELSTART := clci;
  reMemo.SelLength := (nlci - 1) - clci;

  Try
    If ListBox1.Items.Objects[cli] <> Nil Then
    Begin
      ObjStuff := ListBox1.Items.Objects[cli] As TExtraDisplayInfo;
      If objstuff <> Nil Then
        StatusBar1.Panels[2].Text := ObjStuff.SerialNumber;
    End;
  Except
    On e: Exception Do
      StatusBar1.Panels[2].Text := '';
  End;
End;

Procedure TMaggMsgf.reMemoKeyDown(Sender: Tobject; Var Key: Word;
  Shift: TShiftState);
Begin
  If (Shift = [Ssctrl]) And ((Inttostr(Key) = '70') Or (Inttostr(Key) = '102')) Then
    SearchFor;
End;

Procedure TMaggMsgf.reMemoKeyUp(Sender: Tobject; Var Key: Word;
  Shift: TShiftState);
Begin
  If (Key = VK_UP) Or (Key = VK_DOWN) Then
    HighlightLine;
End;

Procedure TMaggMsgf.Retainthelastxxxmessages1Click(Sender: Tobject);
Begin
  Try
    FMsgCount := Strtoint(InputBox('Number of messages to keep in memory', 'Number of messages to keep in memory', Inttostr(FMsgCount)));
    FSysMsgCount := FMsgCount;
  Finally
  End;
End;

Procedure TMaggMsgf.RunError1Click(Sender: Tobject);
Begin
  RunError(204); {Debugging purposes only}
End;

Procedure TMaggMsgf.MnuSaveMessagehistorytofileClick(Sender: Tobject);
Begin
  If SaveDialog1.Execute Then
    reMemo.Lines.SaveToFile(SaveDialog1.Filename);
End;

Procedure TMaggMsgf.mnuSnapshotClick(Sender: Tobject);
Begin
  MagLogger.SnapshotToZipFile;
End;

Procedure TMaggMsgf.mnuFilter_AllCommClick(Sender: Tobject);
Begin
  ShowAllComm := mnuFilter_AllComm.Checked;
  If ShowAllComm Then
  Begin
    mnuFilter_OnlyComm.Checked := False;
    mnuFilter_NoComm.Checked := False;
    ShowOnlyComm := False;
    SuppressComm := False;
  End;
  RefreshMemo;
End;

Procedure TMaggMsgf.mnuFilter_AllMessagesClick(Sender: Tobject);
Begin
  ShowAllMessages := mnuFilter_AllMessages.Checked;
  If ShowAllMessages Then
  Begin
    mnuFilter_AllComm.Checked := True;
    ShowAllComm := True;

    mnuFilter_AllCCOW.Checked := True;
    ShowAllCCOW := True;

    mnuFilter_OnlyComm.Checked := False;
    ShowOnlyComm := False;

    mnuFilter_NoComm.Checked := False;
    SuppressComm := False;

    mnuFilter_NoCCOW.Checked := False;
    SuppressCCOW := False;

    mnuFilter_SuppressDebugMsgs.Checked := False;
    SuppressDebug := False;

    mnuFilter_SuppressInfoMsgs.Checked := False;
    SuppressInfo := False;

    SuppressLogger := False;
  End
  Else
    SuppressLogger := True;

  RefreshMemo;
End;

Procedure TMaggMsgf.mnuFilter_HighlightErrorsClick(Sender: Tobject);
Begin
  HighlightErrors := mnuFilter_HighlightErrors.Checked;
  RefreshMemo;
End;

Procedure TMaggMsgf.mnuFilter_NoCommClick(Sender: Tobject);
Begin
  SuppressComm := mnuFilter_NoComm.Checked;

  If SuppressComm Then
  Begin
    mnuFilter_AllMessages.Checked := False;
    ShowAllMessages := False;

    mnuFilter_AllComm.Checked := False;
    ShowAllComm := False;

    mnuFilter_OnlyComm.Checked := False;
    ShowOnlyComm := False;
  End;
  RefreshMemo;
End;

Procedure TMaggMsgf.mnuFilter_OnlyCommClick(Sender: Tobject);
Begin
  ShowOnlyComm := mnuFilter_OnlyComm.Checked;

  If ShowOnlyComm Then
  Begin
    mnuFilter_AllMessages.Checked := False;
    ShowAllMessages := False;

    mnuFilter_AllComm.Checked := False;
    ShowAllComm := False;

    mnuFilter_NoComm.Checked := False;
    SuppressComm := False;
  End;
  RefreshMemo;
End;

Procedure TMaggMsgf.mnuFilter_SuppressDebugMsgsClick(Sender: Tobject);
Begin
  SuppressDebug := mnuFilter_SuppressDebugMsgs.Checked;

  If SuppressDebug Then
  Begin
    mnuFilter_AllMessages.Checked := False;
    ShowAllMessages := False;
  End;
  RefreshMemo;
End;

Procedure TMaggMsgf.mnuFilter_SuppressInfoMsgsClick(Sender: Tobject);
Begin
  SuppressInfo := mnuFilter_SuppressInfoMsgs.Checked;

  If SuppressInfo Then
  Begin
    mnuFilter_AllMessages.Checked := False;
    ShowAllMessages := False;
  End;
  RefreshMemo;
End;

Procedure TMaggMsgf.MnuFontClick(Sender: Tobject);
Begin
  FontDialog1.Font := MsgMemo.Font;
  If FontDialog1.Execute Then
  Begin
    MsgMemo.Font := FontDialog1.Font;
    FFontSize := FontDialog1.Font.Size;
    FFontName := FontDialog1.Font.Name;
    FFontColor := FontDialog1.Font.Color;
    RefreshMemo;
  End;
End;

Procedure TMaggMsgf.MnuClearhistoryClick(Sender: Tobject);
Begin
  RawInfo.Clear; {/ JK 10/26/2009 TODO - Need to add a "flush to zip" here to preserve the history but just clear the screen /}
  MagLogger.Log(Logger, 'Clear History Called. Prior messages from this session have been erased');
  reMemo.Clear;
End;

Procedure TMaggMsgf.MnuColorClick(Sender: Tobject);
Begin
  If cd1.Execute Then
    reMemo.Color := cd1.Color;
End;

Procedure TMaggMsgf.MnuOptionsClick(Sender: Tobject);
Begin
  //mnuiSystemmessages.Checked := tbsysmemo.Checked;  {/JK 1/19/2010 - P94T5 - IR P94-T5-1 - Removed this line/}
  MnuWordWrap.Checked := TbWrap.Checked;
End;

Procedure TMaggMsgf.MnuWordWrapClick(Sender: Tobject);
Begin
  MnuWordWrap.Checked := Not MnuWordWrap.Checked;
  TbWrap.Checked := MnuWordWrap.Checked;
End;

Procedure TMaggMsgf.pmuClipboardPopup(Sender: Tobject);
Var
  re: TRichEdit;
Begin
  re := GetRichEditFromPopup;

  itemUndo.Enabled := re.CanUndo;
  itemCut.Enabled := re.Seltext <> '';
  itemCopy.Enabled := re.Seltext <> '';
  itemDelete.Enabled := re.Seltext <> '';
  itemPaste.Enabled := Clipboard.HasFormat(CF_TEXT);
End;

Function TMaggMsgf.GetRichEditFromPopup: TRichEdit;
Begin
  //should add some checking (if richEditContextMenu.PopupComponent is TRichEdit)
  Result := TRichEdit(pmuClipboard.PopupComponent);
End;

Procedure TMaggMsgf.MnuiSystemmessagesClick(Sender: Tobject);
Begin
  MnuiSystemmessages.Checked := Not MnuiSystemmessages.Checked;
  TbSysMemo.Checked := MnuiSystemmessages.Checked;

  If MnuiSystemmessages.Checked Then
    reMemo.Color := $00A7FCEF
  Else
    reMemo.Color := clWhite;

  RefreshMemo;
End;

Procedure TMaggMsgf.MnuMessageHistoryHelpClick(Sender: Tobject);
Var
  MagLoggerHelp: String;
  lAppPath: String;

  Function Magexecutefile(Const Filename, Params, DefaultDir: String; ShowCmd: Integer; Oper: String = 'open'): THandle;
  Var
    ZOper, ZFileName, ZParams, ZDir: Array[0..279] Of Char;
  Begin
    Result := ShellExecute(Application.MainForm.Handle, Strpcopy(ZOper, Oper),
      Strpcopy(ZFileName, Filename), Strpcopy(ZParams, Params),
      Strpcopy(ZDir, DefaultDir), ShowCmd);
  End;

Begin
  lAppPath := Copy(ExtractFilePath(Application.ExeName), 1, Length(ExtractFilePath(Application.ExeName)) - 1);
  MagLoggerHelp := lAppPath + '\MaggMsgu_Help.pdf';
  If FileExists(MagLoggerHelp) Then
  Begin
    Magexecutefile(MagLoggerHelp, '', '', SW_SHOW);
  End
  Else
    MessageDlg508('Mag Logger Help not available', Mtinformation, [Mbok], 0);
End;

Procedure TMaggMsgf.WriteOneLine(Const s: String);
Var
  SerNum, TimeStmp, Lev, Msg: String;
  FmtStr: String;
Begin
  If Pos('|', s) <> 0 Then
  Begin
    SerNum := MagPiece(s, '|', 1);
    TimeStmp := MagPiece(s, '|', 2);
    Lev := Uppercase(MagPiece(s, '|', 3));
    Msg := MagLastPieceAfter(s, '|', 3);
  End
  Else
  Begin
    SerNum := '*';
    TimeStmp := Formatdatetime('hh.nn.ss.zzz', Now);
    Lev := 'WinMsg';
    Msg := s;
  End;

  reMemo.SelAttributes.Size := FFontSize;
  reMemo.SelAttributes.Name := FFontName;

  If (SuppressLogger And (Lev = 'LOGGER')) And Not frmMaggMsg.RetroStyle Then
    Exit;

  If SuppressDebug And ((Lev = 'DEBUG') Or (Lev = 'TRACE')) Then
    Exit;

  If SuppressComm And ((Lev = 'COMM') Or (Lev = 'COMMERR')) Then
    Exit;

  If SuppressInfo And (Lev = 'INFO') Then
    Exit;

  If SuppressCCOW And (Lev = 'CCOW') Then
    Exit;

  If ShowOnlyComm And ((Lev <> 'COMM') And (Lev <> 'COMMERR')) Then
    Exit;

  If ShowOnlyCCOW And (Lev <> 'CCOW') Then
    Exit;

  If (frmMaggMsg.PrivLevel = plUser) And (Lev = 'SYS') Then
    Exit;

  {/ JK 10/26/2009 - added for P93/94 backwards compatibility /}
  If (Not MnuiSystemmessages.Checked) Then
  Begin
    If Lev = 'SYS' Then
      Exit;
  End;

  reMemo.SelAttributes.Color := FFontColor;
  reMemo.SelAttributes.Style := frmMaggMsg.FFontStyle;

  If HighlightErrors And ((Lev = 'ERROR') Or (Lev = 'COMMERR') Or (Lev = 'FATAL')) Then
  Begin
    reMemo.SelAttributes.Color := clRed;
    reMemo.SelAttributes.Style := [fsUnderline];
  End;

  If Lev = 'MARKER' Then
  Begin
    reMemo.SelAttributes.Color := clGreen;
    reMemo.SelAttributes.Style := [];
  End;

  If Lev = 'LOGGER' Then
  Begin
    reMemo.SelAttributes.Color := clPurple;
    reMemo.SelAttributes.Style := [];
  End;

  {Set tab stops}
  reMemo.Paragraph.Tab[0] := 1;
  reMemo.Paragraph.Tab[1] := 61;
  reMemo.Paragraph.Tab[2] := 111;
  reMemo.Paragraph.Tab[3] := 131;
  reMemo.Paragraph.Tab[4] := 161;

  If ShowLogLevels Then
    FmtStr := #9 + TimeStmp + #9 + Lev + #9 + Msg
  Else
    FmtStr := #9 + TimeStmp + #9 + Msg;

  reMemo.Lines.Add(FmtStr);
  ListBox1.Items.AddObject(SerNum, TExtraDisplayInfo.Create(SerNum, FmtStr));

End;

Procedure TMaggMsgf.FreeObjects(Const Strings: TStrings);
Var
  Idx: Integer;
Begin
  For Idx := 0 To Pred(Strings.Count) Do
  Begin
    Strings.Objects[Idx].Free;
    Strings.Objects[Idx] := Nil;
  End;
End;

Function TMaggMsgf.Maglength(Str, Delim: String): Integer;
Var
  i, j: Integer;
  Estr: Boolean;
Begin
  Estr := False;
  i := 0;
  While Not Estr Do
  Begin
    i := i + 1;
    If (Pos(Delim, Str) = 0) Then
      Estr := True;
    j := Pos(Delim, Str);
    Str := Copy(Str, j + 1, Length(Str));
  End;
  Maglength := i;
End;

Function TMaggMsgf.MagSetPiece(InString: String; Delimiter: String; Piece: Integer; ReplacePiece: String): String;
Var
  i, k, K2: Integer;
Begin
  While (Maglength(InString, Delimiter) < Piece) Do
    InString := InString + Delimiter;

  If Piece = 1 Then
  Begin
    Result := ReplacePiece + Copy(InString, Pos(Delimiter, InString), 9999);
    Exit;
  End;

  k := 1;
  For i := 1 To Piece - 1 Do
    k := PosEx(Delimiter, InString, k) + 1;
  If Piece = Maglength(InString, Delimiter) Then
    K2 := 99999
  Else
    K2 := PosEx(Delimiter, InString, k);

  Result := Copy(InString, 1, k - 1) + ReplacePiece + Copy(InString, K2, 99999);
End;

Function TMaggMsgf.MagPiece(Str, Delim: String; Piece: Integer): String;
Var
  i, k: Integer;
  s: String;
Begin
  i := Pos(Delim, Str);
  If (i = 0) And (Piece = 1) Then
  Begin
    Result := Str;
    Exit;
  End;

  For k := 1 To Piece Do
  Begin
    i := Pos(Delim, Str);
    If (i = 0) Then
      i := Length(Str) + 1;
    s := Copy(Str, 1, i - 1);
    Str := Copy(Str, i + 1, Length(Str));
  End;
  Result := s;
End;

{Gets an untruncated string starting from the piece # to the end of the string (str).
 This was written because sometimes the string has the delimiter piece in it which
 causes unanticipated truncation. For the logger I want to return the message in
 entirety after piece #3.}

Function TMaggMsgf.MagLastPieceAfter(Str, Delim: String; Piece: Integer): String;
Var
  i, k: Integer;
  s: String;
Begin
  i := Pos(Delim, Str);

  If (i = 0) And (Piece = 1) Then
  Begin
    Result := Str;
    Exit;
  End;

  For k := 1 To Piece Do
  Begin
    If k = Piece Then
    Begin
      i := Pos(Delim, Str);
      Result := Copy(Str, i + 1, Length(Str));
      Exit;
    End;
    i := Pos(Delim, Str);
    If (i = 0) Then
      i := Length(Str) + 1;
    s := Copy(Str, 1, i - 1);
    Str := Copy(Str, i + 1, Length(Str));
  End;

End;

Procedure TMaggMsgf.mnuFilter_AllCCOWClick(Sender: Tobject);
Begin
  ShowAllCCOW := mnuFilter_AllCCOW.Checked;
  If ShowAllCCOW Then
  Begin
    mnuFilter_OnlyCCOW.Checked := False;
    mnuFilter_NoCCOW.Checked := False;
    ShowOnlyCCOW := False;
    SuppressCCOW := False;
  End;
  RefreshMemo;
End;

Procedure TMaggMsgf.mnuFilter_NoCCOWClick(Sender: Tobject);
Begin
  SuppressCCOW := mnuFilter_NoCCOW.Checked;

  If SuppressCCOW Then
  Begin
    mnuFilter_AllMessages.Checked := False;
    ShowAllMessages := False;

    mnuFilter_AllCCOW.Checked := False;
    ShowAllCCOW := False;

    mnuFilter_OnlyCCOW.Checked := False;
    ShowOnlyCCOW := False;
  End;
  RefreshMemo;
End;

Procedure TMaggMsgf.mnuFilter_OnlyCCOWClick(Sender: Tobject);
Begin
  ShowOnlyCCOW := mnuFilter_OnlyCCOW.Checked;

  If ShowOnlyCCOW Then
  Begin
    mnuFilter_AllMessages.Checked := False;
    ShowAllMessages := False;

    mnuFilter_AllCCOW.Checked := False;
    ShowAllCCOW := False;

    mnuFilter_NoCCOW.Checked := False;
    SuppressCCOW := False;
  End;
  RefreshMemo;
End;

(* Set RichEdit margins in Inches (1 in = 2.54 cm)
   for the active printer *)

procedure TMaggMsgf.SetRetroStyle(const Value: Boolean);
begin
 if frmMaggMsg <> Nil then
   begin
    FRetroStyle := Value;
    frmMaggMsg.mnuFilter.Visible := Not FRetroStyle;
    if frmMaggMsg.Visible then frmMaggMsg.RefreshMemo;
   end;
end;

Procedure TMaggMsgf.SetRichEditMargins(Const mLeft, mRight, mTop, mBottom: Extended; Const re: TRichEdit);
Var
  ppiX, ppiY: Integer;
  spaceLeft, spaceTop: Integer;
  r: Trect;
Begin
  // pixels per inch
  ppiX := GetDeviceCaps(Printer.Handle, LOGPIXELSX);
  ppiY := GetDeviceCaps(Printer.Handle, LOGPIXELSY);

  // non-printable margins
  spaceLeft := GetDeviceCaps(Printer.Handle, PHYSICALOFFSETX);
  spaceTop := GetDeviceCaps(Printer.Handle, PHYSICALOFFSETY);

  //calc margins
  r.Left := Round(ppiX * mLeft) - spaceLeft;
  r.Right := Printer.PageWidth - Round(ppiX * mRight) - spaceLeft;
  r.Top := Round(ppiY * mTop) - spaceTop;
  r.Bottom := Printer.PageHeight - Round(ppiY * mBottom) - spaceTop;

  // set margins
  re.PageRect := r;
End;

Procedure TMaggMsgf.Snapshot(Const APassword: String);
Var
  RawStream: TMemoryStream;
  //ZipName: String;
  SnapTime: String;
Begin
  {put up the save file dialog}
  SaveDialog2.InitialDir := ExtractFilePath(frmMaggMsg.ZipFileName);
  SaveDialog2.Filename := 'Snapshot_' + Formatdatetime('mmm dd yyyy hh.nn.ss.zzz', Now) + '.zip';
  If SaveDialog2.Execute Then
  Begin
    With VCLZip2 Do
    Begin
      ZipName := SaveDialog2.Filename;
      Password := APassword;
      Recurse := True;
      StorePaths := True;
      PackLevel := 9;
      EncryptStrength := esAES128; {JK 3/16/2010 - AES 128 bit encryption}
    End;

    RawStream := TMemoryStream.Create;
    Try
      SnapTime := Formatdatetime('mmm dd yyyy hh.nn.ss.zzz', Now);
      MagLogger.Log(Logger, '*** SNAPSHOT TAKEN @ ' + SnapTime + ' ***');
      RenumberSerialNums;
      RawInfo.SaveToStream(RawStream);
      RawStream.Position := 0;
      VCLZip2.ZipFromStream(RawStream, 'Snapshot_' + SnapTime + '.log');
    Finally
      RawStream.Free;
    End;
  End;
End;

/////////////////////

Class Procedure MagLogger.Open(PrivLevel: TPrivLevel;
  LogFileName: String;
  AutoLogToFile: Boolean;
  ZipPassword: String;
  ZipDaysToKeep: Integer;
  MaxFileSizeBytes: Cardinal;
  AppTitle: String;
  pWriteImmediate: Boolean;
  RetroStyle: Boolean = True);
Var
  DiskOK: Boolean;
Begin

  If Not LoggerStarted Then
  Begin
    LoggerStarted := True;

    FullLogFileName := GetEnvironmentVariable('AppData') + '\ilog\' + LogFileName;

    If Not Directoryexists(FullLogFileName) Then
      CreateDir(ExtractFileDir(FullLogFileName));

    If RawInfo = Nil Then
    Begin
      Try
        frmMaggMsg := TMaggMsgf.Create(Nil);
      Except
        On e: Exception Do
        Begin
          //Showmessage('cannot create frmMaggMsg because: ' + E.message);
          Exit;
        End;
      End;

      frmMaggMsg.StatusBar1.Hint := 'The log file is at: ' + FullLogFileName;

      RawInfo := Tstringlist.Create;
      SerialNum := 0;

      frmMaggMsg.PrivLevel := PrivLevel;

      frmMaggMsg.RetroStyle := RetroStyle;

      If LogFileName = '' Then
        frmMaggMsg.ZipFileName := ExtractFilePath(Application.ExeName) + '\Log.zip'
      Else
        frmMaggMsg.ZipFileName := FullLogFileName;

      frmMaggMsg.AutoLogToFile := AutoLogToFile;

      If ZipPassword = '' Then
        frmMaggMsg.ZipPassword := DEFAULT_PASSWORD
      Else
        frmMaggMsg.ZipPassword := ZipPassword;

      frmMaggMsg.ZipDaysToKeep := ZipDaysToKeep;
      frmMaggMsg.MaxFileSizeBytes := MaxFileSizeBytes;

      If AppTitle = '' Then
        frmMaggMsg.AppTitle := 'VistA Imaging'
      Else
        frmMaggMsg.AppTitle := AppTitle;

      If pWriteImmediate <> True Then
        pWriteImmediate := False;

      frmMaggMsg.WriteImmediate := pWriteImmediate;

      frmMaggMsg.PruneZipFile;

      If AutoLogToFile = False Then
      Begin
        LogToDisk := False;
        //frmMaggMsg.StatusBar1.Panels[1].Text :=  'Logging to disk is disabled';    {JK 3/24/2010 - Removed for T8}
        frmMaggMsg.StatusBar1.Panels[1].Text := ''; {JK 3/24/2010 - Added for T8}
      End
      Else
      Begin
        DiskOK := MagLogger.isOKToLogFile(FullLogFileName);
        If DiskOK Then
        Begin
          LogToDisk := True;
          //frmMaggMsg.StatusBar1.Panels[1].Text :=  'Logging captured to: ' + FullLogFileName;  {JK 3/24/2010 - removed in T8}
          frmMaggMsg.StatusBar1.Panels[1].Text := ''; {JK 3/24/2010 - added for T8}
        End
        Else
        Begin
          LogToDisk := False;
          //frmMaggMsg.StatusBar1.Panels[1].Text :=  'Problem Logging to disk - Logging to disk is disabled';
          //frmMaggMsg.StatusBar1.Hint           :=  'Problem logging to disk at location: ' + FullLogFileName;
          frmMaggMsg.StatusBar1.Panels[1].Text := ''; {JK 3/24/2010 - Added for T8}
        End;
      End;

      If LogToDisk Then
        frmMaggMsg.SaveLogToFile1.Checked := True
      Else
        frmMaggMsg.SaveLogToFile1.Checked := False;

      If FullLogFileName = '' Then
        frmMaggMsg.SaveLogToFile1.Visible := False;

      Case frmMaggMsg.PrivLevel Of
        plUser:
          Begin
            frmMaggMsg.mnuFilter_SuppressDebugMsgs.Checked := True;
            frmMaggMsg.mnuFilter_SuppressDebugMsgs.Visible := False;
          End;
      Else
        Begin
          frmMaggMsg.mnuFilter_SuppressDebugMsgs.Checked := False;
          frmMaggMsg.mnuFilter_SuppressDebugMsgs.Visible := True;
        End;
      End;

      MagLogger.Log(Logger, '*** ' + AppTitle + ' LOG JOB STARTED *** Date [' +
        Formatdatetime('mmm dd, yyyy', Now) + '] Time [' +
        Formatdatetime('hh.nn.ss.zzz', Now) + ']');
      MagLogger.Log(Logger, '*** Application Memory Usage: ' + frmMaggMsg.CurrentMemoryUsage);
      MagLogger.Log(Logger, '*** ' + frmMaggMsg.GetTotalSystemMemory);
      MagLogger.Log(Logger, '*** Local Computer Name: ' + frmMaggMsg.GetComputerName);
      MagLogger.Log(Logger, '*** Operating System: ' + frmMaggMsg.GetOSVersion);
      MagLogger.Log(Logger, '----------------------------------------------------');
    End; {if RawInfo = nil}
  End;
End;

Class Procedure MagLogger.Close;
Var
  RawStream: TMemoryStream;
Begin

  {If the WriteImmediate mode is true and it is OK to log to disk (LogToDisk=True) then do a Writeln to the disk file before closing}
  If frmMaggMsg.WriteImmediate Then
  Begin

    If LogToDisk Then
    Begin

      {Check the IOResult function to see how the last I/O operation resulted. If zero (no prior disk I/O error), then proceed.}
      If IOResult = 0 Then
      Begin

        Writeln(FDiskFile, '##########################################################');
        Writeln(FDiskFile, '### "WRITE IMMEDIATE" MODE');
        Writeln(FDiskFile, '### LOG JOB ENDED');
        Writeln(FDiskFile, '### Date [' + Formatdatetime('mmm dd, yyyy', Now) + '] Time [' +
          Formatdatetime('hh.nn.ss.zzz', Now) + ']');
        Writeln(FDiskFile, '##########################################################');
      End;

{$I-}
      If LogToDisk Then
        CloseFile(FDiskFile);
{$I+}

    End;
  End;

  {If it is Ok to log to disk (LogToDisk=True) then write the contents of the RawInfo TStringList to the zip file}
  If LogToDisk Then
  Begin
    MagLogger.Log(Logger, '### LOG JOB ENDED ### Date [' +
      Formatdatetime('mmm dd, yyyy', Now) + '] Time [' +
      Formatdatetime('hh.nn.ss.zzz', Now) + ']');

    frmMaggMsg.OpenZip;
    RawStream := TMemoryStream.Create;
    frmMaggMsg.RenumberSerialNums;
    RawInfo.SaveToStream(RawStream);
    RawStream.Position := 0;

    frmMaggMsg.ZipFromStream(RawStream);
    RawStream.Free;
  End;

  If RawInfo <> Nil Then
    RawInfo.Free;

  frmMaggMsg.Free;
  LoggerStarted := False;
End;

Function TMaggMsgf.ZipFromBuffer: Boolean;
Var
  ZipName: String;
Begin
  ZipName := Formatdatetime('mmm dd yyyy hh.nn.ss.zzz', Now) + '.log';
  VCLZip1.ZipFromBuffer(PChar(reMemo.Lines.Text), Length(reMemo.Lines.Text), ZipName);
End;

Function TMaggMsgf.ZipFromStream(AStream: TMemoryStream): Boolean;
Var
  ZipName: String;
Begin
  ZipName := Formatdatetime('mmm dd yyyy hh.nn.ss.zzz', Now) + '.log';
  VCLZip1.ZipFromStream(AStream, ZipName);
End;

Function TMaggMsgf.OpenZip: Boolean;
Begin
  Result := False;

  With VCLZip1 Do
  Begin
    ZipName := Self.ZipFileName;
    Password := Self.ZipPassword;
    Recurse := True;
    StorePaths := True;
    PackLevel := 9;
    Result := True;
    EncryptStrength := esAES128; {JK 3/16/2010 - AES 128 bit encryption}
  End;
End;

Function TMaggMsgf.CompressStream(StreamToCompress: TMemoryStream; Filename: String): TMemoryStream;

Begin

  Result := TMemoryStream.Create;

  // Creating new compressed stream
  VCLZip1.ArchiveStream := TMemoryStream.Create;

  // Compress the data from uncompressed stream into the ArchiveStream;
  VCLZip1.ZipFromStream(StreamToCompress, Filename);

  // Retrieve the resulting compressed stream
  // Result := VCLZip1.ArchiveStream;

  // Detach the compressed stream from VCLZip
  VCLZip1.ArchiveStream := Nil;

End;

Procedure TMaggMsgf.PruneZipFile;
Var
  i, NumDeleted_1, NumDeleted_2: Integer;
  CompressedTotal, BytesDeleted: Integer;
Begin
  If ZipDaysToKeep > -1 Then
  Begin
    If FileExists(ZipFileName) Then
    Try

      VCLZip1.ZipName := ZipFileName;
      VCLZip1.ReadZip;

        {First, delete older archives with dates beyond ZipDaysToKeep}
      For i := 0 To VCLZip1.Count - 1 Do
        If VCLZip1.DateTime[i] < Now - ZipDaysToKeep Then
          VCLZip1.Selected[i] := True;

      NumDeleted_1 := VCLZip1.DeleteEntries;

        {Second, delete archives to try and get the entire zip down below the MaxFileSizeBytes}
      CompressedTotal := 0;
      For i := 0 To VCLZip1.Count - 1 Do
        CompressedTotal := CompressedTotal + VCLZip1.CompressedSize[i];

      BytesDeleted := 0;
      For i := 0 To VCLZip1.Count - 1 Do
        If CompressedTotal > MaxFileSizeBytes Then
        Begin
          BytesDeleted := BytesDeleted + VCLZip1.CompressedSize[i];
          VCLZip1.Selected[i] := True;
          If (CompressedTotal - BytesDeleted) <= MaxFileSizeBytes Then
            Break;
        End;

      NumDeleted_2 := VCLZip1.DeleteEntries;

      If NumDeleted_1 + NumDeleted_2 > 0 Then
        MagLogger.Log(Logger, Inttostr(NumDeleted_1 + NumDeleted_2) + ' of the oldest/largest log entries have been pruned from the zip container.');

    Except
      On e: Exception Do
      Begin
        MessageDlg508('Mag Logger Error: cannot prune the log entries in file: ' + ZipFileName +
          '  Recommend that you close this program and manually delete the log file. A new ' +
          'log file will be created in its place when you start the application again.', MtWarning, [Mbok], 0);
        MagLogger.Log(LOGGER, 'Mag Logger Error: cannot prune the log entries in file: ' + ZipFileName +
          '  Recommend that you close this program and manually delete the log file. A new ' +
          'log file will be created in its place when you start the application again.');
      End;
    End;
  End;
End;

Constructor TMaggMsgf.Create(Owner: Tobject);
Begin
  Inherited Create(Nil);
  FirstTimeRefresh := True;

  FFontSize := 9;
  FFontStyle := [];
  FFontName := 'MS Sans Serif';
End;

Class Procedure MagLogger.SetPrivLevel(Value: TPrivLevel);
Begin
  If frmMaggMsg <> Nil Then
  Begin
    frmMaggMsg.PrivLevel := Value;
    If Value = plAdmin Then
    Begin
      MagLogger.Log(Logger, 'Logger: "Admin" rights have been granted');
      frmMaggMsg.MnuiSystemmessages.Checked := True; {/JK 1/19/2010 - P94T5 - IR P94-T5-1 - Added this line/}
      frmMaggMsg.MnuiSystemmessages.Enabled := True; {/JK 1/19/2010 - P94T5 - IR P94-T5-1 - Added this line/}
	  frmMaggMsg.reMemo.Color := $00A7FCEF;  {/JK 4/5/2010 - P94T8 - IR P94-T8-24 - Added this line/}
    End
    Else
    Begin
      MagLogger.Log(Logger, 'Logger: "User" rights have been granted');
      frmMaggMsg.MnuiSystemmessages.Checked := False; {/JK 1/19/2010 - P94T5 - IR P94-T5-1 - Added this line/}
      frmMaggMsg.MnuiSystemmessages.Enabled := False; {/JK 1/19/2010 - P94T5 - IR P94-T5-1 - Added this line/}
	  frmMaggMsg.reMemo.Color := clWhite;  {/JK 4/5/2010 - P94T8 - IR P94-T8-24 - Added this line/}
    End;

    frmMaggMsg.RefreshMemo;
  End;
End;

Class Procedure MagLogger.SetWriteImmediate(Const Value: Boolean);
Begin

End;

Class Procedure MagLogger.BringToFront;
Begin
  Show;
  frmMaggMsg.BringToFront;
End;

Class Procedure MagLogger.Show;
Begin
  If frmMaggMsg.RetroStyle Then
    frmMaggMsg.mnuFilter.Visible := False;
  frmMaggMsg.Show;
  frmMaggMsg.RefreshMemo;
  If FirstTimeRefresh Then
    frmMaggMsg.RefreshMemo;
  FirstTimeRefresh := False;
End;

Class Procedure MagLogger.SnapshotToZipFile(Password: String = DEFAULT_PASSWORD);
Begin
  If frmMaggMsg <> Nil Then
    frmMaggMsg.Snapshot(Password);
End;

Class Procedure MagLogger.AdjustLogFileSize(ALogFileName: String);
Var
  hFile: THandle;
  Filesize: Integer;
Begin
  Filesize := 0;

  Try
    hFile := Windows.CreateFile(PChar(ALogFileName), GENERIC_READ, 0, Nil,
      OPEN_EXISTING, FILE_ATTRIBUTE_NORMAL, 0);
    Try
      If hFile = INVALID_HANDLE_VALUE Then
        Filesize := 0
      Else
        Filesize := Windows.Getfilesize(hFile, Nil);
      If DWORD(Filesize) = INVALID_FILE_SIZE Then
        Filesize := 0;
    Finally
      CloseHandle(hFile);
    End;
  Except
    ;
  End;

  If Filesize > 0 Then
  Begin
    If Filesize > frmMaggMsg.MaxFileSizeBytes Then
    Begin
      DeleteFile(ALogFileName);
    End;
  End;
End;

Class Procedure MagLogger.WriteImmediate(Value: Boolean);
Begin
  If frmMaggMsg <> Nil Then
    frmMaggMsg.WriteImmediate := Value;
End;

Class Function MagLogger.isOKToLogFile(Const AFileName: String): Boolean;
Begin

(* JK 3/24/2010 - removed for T8
  Result := True;

  FullLogFileName := Trim(AFileName);

  if FullLogFileName = '' then
  begin
    Result := False;
    Exit;
  end;

  try
    if not DirectoryExists(ExtractFileDir(frmMaggMsg.ZipFileName)) then
    begin
      if not CreateDir(ExtractFileDir(frmMaggMsg.ZipFileName)) then
      begin
        Result := False;
        Exit;
      end
    end;

    if FileExists(frmMaggMsg.ZipFileName) then
      AdjustLogFileSize(frmMaggMsg.ZipFileName);

    if frmMaggMsg.WriteImmediate then begin

      WriteImmediateFilename := ChangeFileExt(frmMaggMsg.ZipFileName, '.UNENCRYPTED.DELETE.WHEN.DONE.log');

      AssignFile(FDiskFile, WriteImmediateFilename);
      {$I-}
      if FileExists(WriteImmediateFilename) then
        Append(FDiskFile)
      else
        Rewrite(FDiskFile);
      {$I+}

      if IOResult = 0 then begin
        {$I-}
        Writeln(FDiskFile, '**********************************************************');
        Writeln(FDiskFile, '*** "WRITE IMMEDIATE" MODE');
        Writeln(FDiskFile, '*** LOG JOB STARTED');
        Writeln(FDiskFile, '*** Date [' + FormatDateTime('mmm dd, yyyy', Now) + '] Time [' +
                                  FormatDateTime('hh.nn.ss.zzz', Now) + ']');
        Writeln(FDiskFile, '*** Application Memory Usage: ' + frmMaggMsg.CurrentMemoryUsage);
        Writeln(FDiskFile, '*** ' + frmMaggMsg.GetTotalSystemMemory);
        Writeln(FDiskFile, '*** Local Computer Name: ' + frmMaggMsg.GetComputerName);
        Writeln(FDiskFile, '*** Operating System: ' + frmMaggMsg.GetOSVersion);
        Writeln(FDiskFile, '**********************************************************');
        {$I+}
      end;
    end;

  except
    Result := False;
  end;
  *)
  Result := False; {JK 3/24/2010 - added for T8}
End;

{MagMsg is for backwards compatibility}

Class Procedure MagLogger.MagMsg(c, s: String; Pmsg: Tpanel);
Begin
  frmMaggMsg.MagMsg(c, s, Pmsg);
End;

{MagMsgs is for backwards compatibility}

Class Procedure MagLogger.MagMsgs(c: String; t: Tstringlist);
Begin
  frmMaggMsg.MagMsgs(c, t);
End;

{LogMsg is for backwards compatibility.}

Class Procedure MagLogger.LogMsg(MsgType: String; Msg: String; Priority: TMagLogPriority = MagLogINFO);
Begin

  {Display a message to a TPanel object and log it in the history
     MsgType: is a code sting containing any combinaton of the defined codes.
     The codes determine how to display the message.
       's' - system message, add to sysmemo.
       'd' - display in a dialog window.
       ''  - add to msgmemo, (and sysmemo)
       'e' - Error message, display 'Error' text with message and dialog
       'QA' - Integrity Error.  Display 'QUESTIONABLE INTEGRITY' in message
  }
  try
  If Priority = MagLogWARN Then
    frmMaggMsg.MagMsg(MsgType, Msg, Nil, Warn);

  If Priority = MagLogINFO Then
    frmMaggMsg.MagMsg(MsgType, Msg, Nil, Info);

  If Priority = MagLogERROR Then
    frmMaggMsg.MagMsg(MsgType, Msg, Nil, ERROR);

  If Priority = MagLogDebug Then
    frmMaggMsg.MagMsg(MsgType, Msg, Nil, DEBUG);
  except
   ///  trap the exception..... What to do with it.. ? 
  end;
End;

{LogMsg is for backwards compatibility. Note that this is a new method since I can't create an overloaded class procedure for LogMsg}

Class Procedure MagLogger.LogMsgs(MsgType: String; Msgs: Tstringlist; Priority: TMagLogPriority = MagLogINFO);
Begin
  If Priority = MagLogWARN Then
    frmMaggMsg.MagMsgs(MsgType, Msgs);

  If Priority = MagLogINFO Then
    frmMaggMsg.MagMsgs(MsgType, Msgs);

  If Priority = MagLogERROR Then
    frmMaggMsg.MagMsgs(MsgType, Msgs);

  If Priority = MagLogDebug Then
    frmMaggMsg.MagMsgs(MsgType, Msgs);

End;

{For backwards compatibility}

Class Function MagLogger.GetLogEventPriorityString(Priority: TMagLogPriority): String;
Begin
  Case Priority Of
    MagLogWARN: Result := 'Warn';
    MagLogDebug: Result := 'Debug';
    MagLogINFO: Result := 'Info';
    MagLogERROR: Result := 'Error';
    MagLogFATAL: Result := 'Fatal';
  End;
End;

Class Function MagLogger.GetPrivLevel: TPrivLevel;
Begin
  If frmMaggMsg <> Nil Then
    Result := frmMaggMsg.FPrivLevel
  Else
    Result := plUnknown;
End;

Class Function MagLogger.GetWriteImmediate: Boolean;
Begin
  If frmMaggMsg <> Nil Then
    Result := frmMaggMsg.FWriteImmediate
  Else
    Result := False;
End;

Class Procedure MagLogger.Log(Level: TMagLoggerLevel; s: String);
Var
  Lev: String;
  RawData: String;
Begin
  EnterCriticalSection(CritSect); {Sequentialize access to the following code to make it thread safe}

  Try
    Try

      Inc(SerialNum);

      Lev := GetLevelString(Level);

      RawData := Inttostr(SerialNum) + '|' + Formatdatetime('hh.nn.ss.zzz', Now) + '|' + Lev + '|' + s;

      If RawInfo <> Nil Then
      Begin
        If RawInfo.Count > MAX_IN_MEMORY_LINE_COUNT Then
          If frmMaggMsg <> Nil Then
            frmMaggMsg.MiniSaveMemoryToZipFile(RawInfo); {Flush the in-memory string list to the zip as a new time-stamped archive}

        RawInfo.Add(RawData); {Add the log line to the in-memory string list}
        LogInfoChanged := True;
      End
      Else
      Begin
        LogInfoChanged := False; {There was a problem...RawInfo was not instantiated or was blown away somehow.}
        Exit;
      End;

      (* JK 3/24/2010 - removed for T8
      try
        if frmMaggMsg.WriteImmediate then
          if IOResult = 0 then
            {$I-}
            Writeln(FDiskFile, RawData);
            {$I+}
      except
        on E:Exception do
          LogToDisk := False;
       end;
      *)
    Except
      On e: Exception Do
      Begin
        //Showmessage('MagLogger.Log Oh my my! MaggMsgu error. S = ' + S + ' / Error = ' + E.Message);
      End;
    End;

  Finally
    LeaveCriticalSection(CritSect); {End thread safe section}
  End;

End;

Class Procedure MagLogger.LogList(Level: TMagLoggerLevel; L: Tstringlist);
Var
  Lev: String;
  RawData: String;
  i: Integer;
Begin
  EnterCriticalSection(CritSect); {Sequentialize access to the following code to make it thread safe}

  Lev := GetLevelString(Level);

  Try
    Try
      For i := 0 To L.Count - 1 Do
      Begin

        Inc(SerialNum);

        RawData := Inttostr(SerialNum) + '|' + Formatdatetime('hh.nn.ss.zzz', Now) + '|' + Lev + '|' + L[i];

        If RawInfo <> Nil Then
          RawInfo.Add(RawData);

        If RawInfo <> Nil Then
        Begin
          If RawInfo.Count > MAX_IN_MEMORY_LINE_COUNT Then
            If frmMaggMsg <> Nil Then
              frmMaggMsg.MiniSaveMemoryToZipFile(RawInfo); {Flush the in-memory string list to the zip as a new time-stamped archive}

          RawInfo.Add(RawData); {Add the log line to the in-memory string list}
          LogInfoChanged := True;
        End
        Else
        Begin
          LogInfoChanged := False; {There was a problem...RawInfo was not instantiated or was blown away somehow.}
          Exit;
        End;

        (* JK 3/24/2010 - removed for T8
        try
          if frmMaggMsg.WriteImmediate then
            if IOResult = 0 then
            {$I-}
            Writeln(FDiskFile, RawData);
            {$I+}
        except
          on E:Exception do
          begin
            LogToDisk := False;
            Raise;
          end;
        end;
        *)
      End; {Loop}

    Except
      On e: Exception Do
      Begin
        //MagLogger.Log(LOGGER, 'MagLogger (LogList) error: Cannot write the log to disk.' +
        //               'Msg = ' + E.Message);
      End;
    End;

  Finally
    LeaveCriticalSection(CritSect); {End thread safe section}
  End;
End;

Class Function MagLogger.GetLevelString(Level: TMagLoggerLevel): String;
Begin
  Case Level Of
    Warn: Result := 'WARN';
    Info: Result := 'INFO';
    ERROR: Result := 'ERROR';
    DEBUG: Result := 'DEBUG';
    TRACE: Result := 'TRACE';
    LOGGER: Result := 'LOGGER';
    Marker: Result := 'MARKER';
    COMM: Result := 'COMM';
    COMMERR: Result := 'COMMERR';
    CCOW: Result := 'CCOW';
    SYS: Result := 'SYS'; {/ JK 10/27/2009 - For Backwards compatibility with P93/P94 /}
    NONSYS: Result := 'NONSYS'; {/ JK 10/27/2009 - For Backwards compatibility with P93/P94 /}
    FATAL: Result := 'FATAL';
  Else
    Result := '???';
  End;
End;

{ TExtraDisplayInfo }

Constructor TExtraDisplayInfo.Create(Const SerialNum, FormattedStr: String);
Begin
  Inherited Create;
  FSerialNumber := SerialNum;
  FFormattedStr := FormattedStr;
End;

{Get Memory Info}

Function TMaggMsgf.CurrentMemoryUsage: String;
Var
  pmc: TProcessMemoryCounters;
Begin
  Result := 'Cannot Determine';
  Try
    pmc.cb := SizeOf(pmc);
    If GetProcessMemoryInfo(GetCurrentProcess, @pmc, SizeOf(pmc)) Then
      Result := Format('%14.0n', [Strtofloat(Inttostr(pmc.WorkingSetSize))]) + ' bytes';
  Except
    On e: Exception Do
      Result := 'Cannot Determine: ' + e.Message;
  End;
End;

Function TMaggMsgf.GetTotalSystemMemory: String;
Var
  Memory: TMemoryStatus;
Begin
  Result := 'Cannot Determine System Memory';
  Try
    Memory.dwLength := SizeOf(Memory);
    GlobalMemoryStatus(Memory);
    Result := 'Total Computer Memory: ' +
      Format('%14.0n', [Strtofloat(Inttostr(Memory.dwTotalPhys))]) + ' bytes / ' +
    'Available Computer Memory: ' +
      Format('%14.0n', [Strtofloat(Inttostr(Memory.dwAvailPhys))]) + ' bytes';
  Except
    On e: Exception Do
      Result := 'Cannot Determine System Memory: ' + e.Message;
  End;
End;

Function TMaggMsgf.GetComputerName: String;
Var
  Buffer: Array[0..MAX_COMPUTERNAME_LENGTH + 1] Of Char;
  Size: Cardinal;
Begin
  Result := 'Cannot Determine Local Computer Name';
  Try
    Size := MAX_COMPUTERNAME_LENGTH + 1;
    Windows.GetComputerName(@Buffer, Size);
    Result := Strpas(Buffer);
  Except
    On e: Exception Do
      Result := 'Cannot Determine Local Computer Name: ' + e.Message;
  End;
End;

Function TMaggMsgf.GetOSVersion: String;
Const
  { Operating system constants reference:
    http://msdn.microsoft.com/en-us/library/ms724834%28VS.85%29.aspx
  }
  cOsUnknown = 'CANNOT DETERMINE OPERATING SYSTEM TYPE';
  cOsWin95 = 'WINDOWS 95';
  cOsWin98 = 'WINDOWS 98';
  cOsWin98SE = 'WINDOWS 98SE';
  cOsWinME = 'WINDOWS ME';
  cOsWinNT = 'WINDOWS NT';
  cOsWin2000 = 'WINDOWS 2000';
  cOsXP = 'WINDOWS XP';
  cOsWinVista = 'WINDOWS VISTA';
  cOsWin7 = 'WINDOWS 7';
Var
  osVerInfo: TOSVersionInfo;
  majorVer, minorVer: Integer;
Begin
  Result := cOsUnknown;
  Try
    { set operating system type flag }
    osVerInfo.DwOSVersionInfoSize := SizeOf(TOSVersionInfo);
    If GetVersionEx(osVerInfo) Then
    Begin
      majorVer := osVerInfo.DwMajorVersion;
      minorVer := osVerInfo.DwMinorVersion;
      Case osVerInfo.DwPlatformId Of
        VER_PLATFORM_WIN32_NT: { Windows NT/2000 }
          Begin
            If majorVer <= 4 Then
              Result := cOsWinNT
            Else
              If (majorVer = 5) And (minorVer = 0) Then
                Result := cOsWin2000
              Else
                If (majorVer = 5) And (minorVer = 1) Then
                  Result := cOsXP
                Else
                  If (majorVer = 6) And (minorVer = 0) Then
                    Result := cOsWinVista
                  Else
                    If (majorVer = 6) And (minorVer = 1) Then
                      Result := cOsWin7
                    Else
                      Result := cOsUnknown;
          End;
        VER_PLATFORM_WIN32_WINDOWS: { Windows 9x/ME }
          Begin
            If (majorVer = 4) And (minorVer = 0) Then
              Result := cOsWin95
            Else
              If (majorVer = 4) And (minorVer = 10) Then
              Begin
                If osVerInfo.szCSDVersion[1] = 'A' Then
                  Result := cOsWin98SE
                Else
                  Result := cOsWin98;
              End
              Else
                If (majorVer = 4) And (minorVer = 90) Then
                  Result := cOsWinME
                Else
                  Result := cOsUnknown;
          End;
      Else
        Result := cOsUnknown;
      End;
    End
    Else
      Result := cOsUnknown;
  Except
    On e: Exception Do
      Result := cOsUnknown + ': ' + e.Message;
  End;
End;

Procedure TMaggMsgf.mnuShowLogLevelsClick(Sender: Tobject);
Begin
  mnuShowLogLevels.Checked := Not mnuShowLogLevels.Checked;
  ShowLogLevels := mnuShowLogLevels.Checked;
  RefreshMemo;
End;

Procedure TMaggMsgf.RefreshDisplay1Click(Sender: Tobject);
Begin
  RefreshMemo;
End;

Procedure TMaggMsgf.RefreshDisplay2Click(Sender: Tobject);
Begin
  RefreshMemo;
End;

Procedure TMaggMsgf.ShowMessage508(Const Msg: String);
Var
  Text, Cap: PAnsichar;
Begin
  Text := PAnsiChar(Msg);
  Cap := PAnsiChar(Application.Title);
  MessageBox(Application.Handle, Text, Cap, MB_OK);
End;

Function TMaggMsgf.MessageDlg508(Const Msg: String; DlgType: TmsgDlgType; Buttons: TMsgDlgButtons; HelpCtx: Integer): Integer;
Var
  Text, Cap: PAnsichar;
Begin
  Result := 0;
  Text := PAnsiChar(Msg);

  Case DlgType Of
    Mtinformation: Cap := PAnsiChar('Information');
    Mtconfirmation: Cap := PAnsiChar('Confirmation');
    Mterror: Cap := PAnsiChar('Error');
  End;

  If DlgType = Mterror Then
    Result := MessageBox(Application.Handle, Text, Cap, MB_ICONERROR)

  Else
    If DlgType = Mtinformation Then
      Result := MessageBox(Application.Handle, Text, Cap, MB_ICONINFORMATION)

    Else
      If (DlgType = Mtconfirmation) And (Buttons = [MbYes, MbNo]) Then
        Result := MessageBox(Application.Handle, Text, Cap, MB_ICONQUESTION + MB_YESNO)

      Else
        If (DlgType = Mtconfirmation) And (Buttons = [Mbok, Mbcancel]) Then
          Result := MessageBox(Application.Handle, Text, Cap, MB_ICONQUESTION + MB_OKCANCEL)

        Else
          If (DlgType = Mtconfirmation) And (Buttons = [Mbok]) Then
            Result := MessageBox(Application.Handle, Text, Cap, MB_ICONQUESTION + MB_OK);

End;

Initialization
  InitializeCriticalSection(CritSect);

Finalization
  DeleteCriticalSection(CritSect);

End.
