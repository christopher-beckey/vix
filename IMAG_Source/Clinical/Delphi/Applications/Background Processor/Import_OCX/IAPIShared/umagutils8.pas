Unit Umagutils8;
  {
   Package: MAG - VistA Imaging
 WARNING: Per VHA Directive 10-93-142 this unit should not be modified.
 Date Created:       2002
 Site Name: Silver Spring, OIFO
 Developers: Garrett Kirin
        [==     unit uMagUtils;
 Description: Image utilities
          Some functions and methods are used by many Forms (windows) and components of
          the application.  Utility units are designed to be a repository of such
          utility functions used throughout the application.

          This utility unit has M functions that are recreated for Delphi use.
          String functions like $P, $L.
                                     ==]
 Note:
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
{TODO: these functions are duplicates of cMagUtils object.  Have to decide
which is better.  Or have the Object 'use' this routine }
Interface

Uses
  Classes,
  Types,
  ExtCtrls,
  Forms,
  Graphics,
  Controls,  {/ P117 - JK 9/20/2010 - needed for FormatDateRange function /}
  DateUtils, {/ P117 - JK 9/20/2010 - needed for FormatDateRange function /}
  UMagDefinitions
  ;

//Uses Vetted 20090929:Menus, Grids, Dialogs, Messages, WinProcs, WinTypes, Controls, StdCtrls, magguini, inifiles, strutils, shellapi, SysUtils

Type
  TMagScreenArea = Class
    Left: Integer;
    Top: Integer;
    Right: Integer;
    Bottom: Integer;
    Width: Integer;
    Height: Integer;
  End;
Procedure Magsetbounds(Formx: TForm; Rectx: Trect);
Function Magexecutefile(Const Filename, Params, DefaultDir: String; ShowCmd: Integer; Oper: String = 'open'): THandle;
Function ParseSiteCode(Input: String): String;
Procedure ConfigFix59;
{  utiltity that takes into account the taskbar (whereever it is : bottom, left etc)}
Function GetScreenArea: TMagScreenArea;
Function StripCrLf(s: String): String;
Function StripFirstLastComma(Value: String): String;
Function Magstripspaces(Str: String): String;
Function Maglength(Str, Del: String): Integer;
Function MagPiece(Str, Del: String; Piece: Integer): String;
        {       return a string changing every frchar in str to tochar}
Function MagTranspose(Str: String; Frchar, Tochar: Char): String;
        {       if minimized, behind other forms or invisible then use this to show at normal size}
Procedure FormToNormalSize(XForm: TForm);
        {       Change from FM Date to displayable Date}
Function FmtoDispDt(Fmdt: String; Showtime: Boolean = False; TimeDelim: String = ' '): String;
        {       Change from String Date mm/dd/yyyy to Fileman Date}
Function DispDttoFM(Dt: String): String;
        {       Replaces a single item in a string JMW 4/12/2005 p45}
        {       JW made a MagReplaceString function - this name was already used in MAGGTU4.}
     {       gek: Changed MagReplace string to MagSetPiece, and modified it to work in all cases.}
Function MagSetPiece(InString: String; Delimiter: String; Piece: Integer; ReplacePiece: String): String;
        {       Insert a value into a string JMW 6/22/2005 p45}
Function MagInsertPiece(InString: String; Delimiter: String; Location: Integer; InsertValue: String): String;
        {       get the width of the screen including all monitors JMW 12/28/2005 p46}
Function GetScreenWidth(): Integer;
        {       converts value to datetime and formats it for sorting JMW}
Function MagConvertAndFormatDateTime(Value: String): String;
// from maggut4
  {     Call here to check,  before creating an unwanted second copy of a form.}
Function Doesformexist(s: String): Boolean;
  {     Replace all sfrom to sto in the entire TStringlist}
Procedure MagReplaceStrings(Sfrom, Sto: String; Var t: Tstringlist);
  {     Replace all sfrom to sto in the string str}
Procedure MagReplaceString(Sfrom, Sto: String; Var St: String);
  {     Set focus to a specific form}
Procedure SetFocusToForm(s: String);
  {     Return the length in Pixels of the longest string in the list. }
Function GetPixelLengthLongestEntry(t: TStrings; Can: TCanvas): Integer;
    {}
Function GetIniEntry(Section, Entry: String): String;
    {}
Function IsServerPortInString(Str: String; Rpc: String = ''): Boolean;
    {}
Function ResolveServerPort(Str, Server: String; Port: Integer): String; OverLoad;
Function ResolveServerPort(t: Tstringlist; Server: String; Port: Integer; Startnode: Integer = 0): String; OverLoad;
Function ResolveServerPort(t: TStrings; Server: String; Port: Integer; Startnode: Integer = 0): String; OverLoad;

Procedure DebugFile(s: String); {JK 3/11/2009}

function FormatDateRange(FromDate, ToDate: TDate): String; {/ P117 - JK 9/20/2010 /}

(* var
  DemobaseImagelist: Tstringlist;
  AppPath: string;
  WMIdentifier: Word;

 MUSESite: byte;// = 1;

const nilpanel: Tpanel = nil;
*)
Implementation
Uses
  Inifiles,
  Magguini,
  Shellapi,
  StrUtils,
  SysUtils
  ;

Procedure ConfigFix59;
Begin

End;

Function StripCrLf(s: String): String;
Var
  Del: String;
Begin
  Del := #13;
  While Pos(Del, s) > 0 Do
    s := Copy(s, 1, Pos(Del, s) - 1) + Copy(s, Pos(Del, s) + 1, 99999);
  Del := #10;
  While Pos(Del, s) > 0 Do
    s := Copy(s, 1, Pos(Del, s) - 1) + ' ' + Copy(s, Pos(Del, s) + 1, 99999);
  Result := s;
End;

Function StripFirstLastComma(Value: String): String;
Begin
  While Copy(Value, 1, 1) = ',' Do
    Value := Copy(Value, 2, 9999999);
  While Copy(Value, Length(Value), 1) = ',' Do
    Value := Copy(Value, 1, Length(Value) - 1);
  Result := Value;
End;

Function GetIniEntry(Section, Entry: String): String;
Var
  Magini: TIniFile;
Begin
  Magini := TIniFile.Create(FindConfigFile);
  Result := Magini.ReadString(Section, Entry, '');
  Magini.Free;
End;

Function IsServerPortInString(Str: String; Rpc: String = ''): Boolean;
Var
  Data2: String;
  Lnth: String;
Begin
  Try
    Result := True;
    Lnth := Inttostr(Maglength(Str, '|') - 1);
    If Maglength(Str, '|') = 2 Then
    Begin
      Data2 := MagPiece(Str, '|', 2);
      If ((MagPiece(Data2, '^', 26) = '') Or (MagPiece(Data2, '^', 27) = '')) Then Result := False;
      Exit;
    End;
    If Maglength(Str, '|') = 1 Then
    Begin
      If ((MagPiece(Str, '^', 26 + 1) = '') Or (MagPiece(Str, '^', 27 + 1) = '')) Then Result := False;
      Exit;
    End;
  Finally
{
  // JMW 10/17/2008 (see note in ResolveServerPort)
if result then maggmsgf.MagMsg('s','ServerPort in str : TRUE  '  + rpc + '  ' + str)
          else maggmsgf.MagMsg('s','ServerPort in str : FALSE  '  + rpc + '  ' + str);

          }
  End;
End;

Function ResolveServerPort(t: TStrings; Server: String; Port: Integer; Startnode: Integer = 0): String; Overload;
Var
  i: Integer;
Begin
  For i := Startnode To t.Count - 1 Do
    t[i] := ResolveServerPort(t[i], Server, Port);
End;

Function ResolveServerPort(t: Tstringlist; Server: String; Port: Integer; Startnode: Integer = 0): String; Overload;
Var
  i: Integer;
Begin
  For i := Startnode To t.Count - 1 Do
    t[i] := ResolveServerPort(t[i], Server, Port);
End;

Function ResolveServerPort(Str, Server: String; Port: Integer): String;
Var
  OldResultFrom45, Data1, Data2: String;
Begin
  Result := Str;
  If IsServerPortInString(Str) Then Exit;
  { JMW 10/17/2008 p72t27 - When viewing extremely large sets of images (600+ from DOD)
   this function gets called lots of times and generates lots of log output.
   This means that there are too many entries in the log and they need to be
   cleaned up which is extremely slow. This causes timeouts and exceptions.
   As a result, I am removing all of this log output to make image display
   faster.
  }
//   maggmsgf.MagMsg('s','Warning: Resolve Server Port');
//   maggmsgf.MagMsg('s',str );
    // str is Flist.String[i], 45 was doing this, which made Piece 26 the server and 27 the port.
  OldResultFrom45 := Str + '^' + Server + '^' + Inttostr(Port);
  If Maglength(Str, '|') = 2 Then
  Begin
      {When we have 2 '|' pieces M code puts MAGFILE string as 2nd piece
       i.e. ,@RESULT@(N+1)=N_"^"_FLTX_"|"_MAGFILE }
    Data1 := MagPiece(Str, '|', 1);
    Data2 := MagPiece(Str, '|', 2);
    Data2 := MagSetPiece(Data2, '^', 26, Server);
    Data2 := MagSetPiece(Data2, '^', 27, Inttostr(Port));
    Result := Data1 + '|' + Data2;
  End;
  If Maglength(Str, '|') = 1 Then
      {M Code adds B2 to begginning of MAGFILE string i.e. MAGRY(TCT)="B2^"_MAGFILE }
  Begin
    Str := MagSetPiece(Str, '^', 26 + 1, Server);
    Str := MagSetPiece(Str, '^', 27 + 1, Inttostr(Port));
    Result := Str
  End;

      {
      // JMW 10/17/2008 (see above)
   if result <> oldResultFrom45 then
     BEGIN
      maggmsgf.MagMsg('s','TImageData String conversion NOT Equal.'  );
      maggmsgf.MagMsg('s','Old ' + oldResultFrom45  );
     END;
       maggmsgf.MagMsg('s',result + '    <<< Server & Port were added.' );
       }
End;

Function GetPixelLengthLongestEntry(t: TStrings; Can: TCanvas): Integer;
Var
  i, Wid: Integer;
Begin
  Result := 0;
  For i := 0 To t.Count - 1 Do
  Begin
    Wid := Can.Textwidth(t[i]);
    If Wid > Result Then Result := Wid;
  End;
End;

Function MagConvertAndFormatDateTime(Value: String): String;
Begin
  Try
    Result := Formatdatetime('yyyymmddhhmmnn', Strtodatetime(Value));
  Except
    On e: Exception Do
    Begin
     // MaggMsgf.MagMsg('s', 'Error converting value [' + value + '] to date, Exception=[' + e.Message + ']');
      Result := Value;
    End
  End;
End;

Function DispDttoFM(Dt: String): String;
Var
  Mth, Day, Year: String;
  Intyr: Integer;
Begin
  Mth := MagPiece(Dt, '/', 1);
  If Length(Mth) = 1 Then Mth := '0' + Mth;

  Day := MagPiece(Dt, '/', 2);
  If Length(Day) = 1 Then Day := '0' + Day;

  Year := MagPiece(Dt, '/', 3);
  If Length(Year) <> 4 Then
  Begin
    Result := '';
    Exit;
  End
  Else
  Begin
    Try
      Intyr := Strtoint(Year);
      Intyr := Intyr - 1700;
      Year := Inttostr(Intyr);
    Except
      Result := '';
      Exit;
    End;
  End;
  Result := Year + Mth + Day;
End;

Function FmtoDispDt(Fmdt: String; Showtime: Boolean = False; TimeDelim: String = ' '): String;
Var
  Xdt: String;
  XTM: String;
  DisplayDate: String;
Begin
  Try
  // if not in FM Format, but Display format, return same date/time
    If Maglength(Fmdt, '/') > 1 Then
    Begin
      Result := Fmdt;
      Exit;
    End;
    Xdt := MagPiece(Fmdt, '.', 1);
    XTM := MagPiece(Fmdt, '.', 2);
    Result := Copy(Xdt, 4, 2) + '/' + Copy(Xdt, 6, 2) + '/'
      + Inttostr(1700 + Strtoint(Copy(Xdt, 1, 3)));
    DisplayDate := Result;
  Except //p8t38
    On e: EConvertError Do
    Begin
   // ignoring it
      Result := '00/00/0000';
    End;
  Else
    Result := '00/00/0000';
  End;
  Try
               {HERE  put in xtm <> '' }
    If (Showtime And (XTM <> '')) Then
    Begin
      XTM := XTM + '00000';
      XTM := Copy(XTM, 1, 2) + ':' + Copy(XTM, 3, 2);
      Result := DisplayDate + TimeDelim + XTM;
    End;
  Except
    On e: Exception Do
    Begin
      Result := DisplayDate;
    End;
  End;

End;

Function GetScreenArea: TMagScreenArea;
Var
  Wrkbar: APPBARDATA;
  Wrkspos: TMagScreenArea;
Begin
  Wrkspos := TMagScreenArea.Create;
  Wrkbar.cbSize := 36;
  SHAppBarMessage(ABM_GETTASKBARPOS, Wrkbar);

// get the left and right positions of the workstation area.
  If (Wrkbar.Rc.Left <= 0) And (Wrkbar.Rc.Right >= Screen.Width) Then
   // taskbar is at top or bottom
  Begin
    Wrkspos.Left := 0;
    Wrkspos.Right := GetScreenWidth(); // screen.width;
  End
  Else
    If (Wrkbar.Rc.Left <= 0) Then
     //taskbar is at left
    Begin
      Wrkspos.Left := Wrkbar.Rc.Right;
      Wrkspos.Right := GetScreenWidth(); // screen.width;
    End
    Else
      If (Wrkbar.Rc.Right >= Screen.Width) Then
     // taskbar is at right
      Begin
        Wrkspos.Left := 0;
        Wrkspos.Right := GetScreenWidth(); // wrkbar.rc.Left;
      End;

  If (Wrkbar.Rc.Top <= 0) And (Wrkbar.Rc.Bottom >= Screen.Height) Then
   // taskbar is at top or bottom
  Begin
    Wrkspos.Top := 0;
    Wrkspos.Bottom := Screen.Height;
  End
  Else
    If (Wrkbar.Rc.Top <= 0) Then
     //taskbar is at top
    Begin
      Wrkspos.Top := Wrkbar.Rc.Bottom;
      Wrkspos.Bottom := Screen.Height;
    End
    Else
      If (Wrkbar.Rc.Bottom >= Screen.Height) Then
     // taskbar is at bottom
      Begin
        Wrkspos.Top := 0;
        Wrkspos.Bottom := Wrkbar.Rc.Top;
      End;
  Wrkspos.Width := Wrkspos.Right - Wrkspos.Left;
  Wrkspos.Height := Wrkspos.Bottom - Wrkspos.Top;

  Result := Wrkspos;
End;

Function GetScreenWidth(): Integer;
Var
  i: Integer;
  Width: Integer;
Begin
  Width := 0;
  For i := 0 To Screen.MonitorCount - 1 Do
  Begin
    Width := Width + Screen.Monitors[i].Width;
  End;
  Result := Width;
End;

Procedure FormToNormalSize(XForm: TForm);
Var
  OldLeft: Integer;
Begin
//testing.  the Access violations seemed to happen here at when frmFullRes is
//     accessed.  Delphi ? seems to have lost the pointer to frmFullRes. ?
//     we freed the fullres on close, and close it now between patients.
  If (XForm.WindowState = Wsminimized) Then XForm.WindowState := Wsnormal;
  XForm.Update;
  OldLeft := XForm.Left;
  If XForm.Visible = False Then XForm.Visible := True;
  If OldLeft <> XForm.Left Then XForm.Left := OldLeft;
  XForm.BringToFront;
  XForm.Update;
  Application.Processmessages;
End;

{	MagReplaceString   //45//Fixed in p59, wasn't setting pieces at end of string }

Function MagSetPiece(InString: String; Delimiter: String; Piece: Integer; ReplacePiece: String): String;
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

Function MagPiece(Str, Del: String; Piece: Integer): String;
Var
  i, k: Integer;
  s: String;
Begin
  i := Pos(Del, Str);
  If (i = 0) And (Piece = 1) Then
  Begin
    Result := Str;
    Exit;
  End;
  For k := 1 To Piece Do
  Begin
    i := Pos(Del, Str);
    If (i = 0) Then i := Length(Str) + 1;
    s := Copy(Str, 1, i - 1);
    Str := Copy(Str, i + 1, Length(Str));
  End;
  Result := s;
End;

Function Maglength(Str, Del: String): Integer;
Var
  i, j: Integer;
  Estr: Boolean;
Begin
  Estr := False;
  i := 0;
  While Not Estr Do
  Begin
    i := i + 1;
    If (Pos(Del, Str) = 0) Then Estr := True;
    j := Pos(Del, Str);
    Str := Copy(Str, j + 1, Length(Str));
  End;
  Result := i;
End;

Function MagTranspose(Str: String; Frchar, Tochar: Char): String;
Var
  i: Integer;
Begin
  Result := '';
  For i := 1 To Maglength(Str, Frchar) Do
    Result := Result + MagPiece(Str, Frchar, i) + Tochar;
  Result := Copy(Result, 1, Length(Result) - 1);
End;

Function Magstripspaces(Str: String): String;
Var
  Done: Boolean;
Var
  s: String;
Begin
  If Str = '' Then
  Begin
    Magstripspaces := '';
    Exit;
  End; {fix for hang}
  Done := False;
  Repeat
    s := Str[1];
    If (s = ' ') Then Str := Copy(Str, 2, Length(Str));
    If Not (Str[1] = ' ') Then Done := True;
    If Str = '' Then Done := True; {fix for hang}
  Until Done;
  Done := False;
  Repeat
    s := Str[Length(Str)];
    If (s = ' ') Then Str := Copy(Str, 1, Length(Str) - 1);
    If Not (Str[Length(Str)] = ' ') Then Done := True;
    If Str = '' Then Done := True; {fix for hang}
  Until Done;
  Result := Str;
End;

{	MagInsertPiece   //45  //Fixed in p59, wasn't inserting pieces at end. }

Function MagInsertPiece(InString: String; Delimiter: String; Location: Integer; InsertValue: String): String;
Var
  i, k: Integer;
  AddToEnd: Boolean;
Begin
  AddToEnd := False;
  While (Maglength(InString, Delimiter) < Location) Do
    InString := InString + Delimiter;
  If Location = 1 Then
  Begin
    Result := InsertValue + Delimiter + InString;
    Exit;
  End;
  If (Location = Maglength(InString, Delimiter)) And (MagPiece(InString, Delimiter, Location) = '') Then AddToEnd := True;
  k := 1;
  For i := 1 To Location - 1 Do
    k := PosEx(Delimiter, InString, k) + 1;
  If Not AddToEnd Then Result := Copy(InString, 1, k - 1) + InsertValue + Copy(InString, k - 1, 9999);
  If AddToEnd Then Result := Copy(InString, 1, k - 1) + InsertValue;
End;

//////////  from MAGGUT4.PAS

Procedure MagReplaceString(Sfrom, Sto: String; Var St: String);
Var
  j, k: Integer;
  s: String;
Begin
  { this procedure will
    switching the string - sfrom to the string - sto  }
    { we use it here for the FakePatientName function, a user can display a real
      patient for a demo, but the FakePatientName will be displayed in all delphi
      windows and in all VistA and Imaging Reports }
  If (Pos(Sfrom, St) > 0) Then
  Begin
    j := Pos(Sfrom, St);
    s := St;
    k := Length(Sfrom);
    Delete(s, j, k);
    Insert(Sto, s, j);
    St := s;
  End;
End;

Procedure MagReplaceStrings(Sfrom, Sto: String; Var t: Tstringlist);
Var
  i: Integer;
  s: String;
Begin
  { this procedure will to through all lines of 't'
    switching the sting - sfrom to the string - sto  }
    { we use it here for the FakePatientName function, a user can display a real
      patient for a demo, but the FakePatientName will be displayed in all delphi
      windows and in all VistA and Imaging Reports }
  For i := 0 To t.Count - 1 Do
  Begin
    If (Pos(Sfrom, t[i]) > 0) Then
    Begin
      // 7/17/00  New procedure to switch one string, we'll call that now
      s := t[i];
      MagReplaceString(Sfrom, Sto, s);
      t[i] := s;
      (* j := pos(sfrom,t[i]);
       s := t[i];
       k := length(sfrom);
       delete(s,j,k);
       insert(sto,s,j);
       t[i] := s; *)
    End;
  End;
End;

Function Doesformexist(s: String): Boolean;
{Called with the Tform.name value of a form, to see if it exists, if we have to create it or not}
Var
  i: Integer;
Begin
  Result := False;
  For i := Screen.CustomFormCount - 1 Downto 0 Do
  Begin
    If (Uppercase(Screen.CustomForms[i].Name) = Uppercase(s)) Then
    Begin
      Result := True;
      Break;
    End;
  End;
End;

Procedure SetFocusToForm(s: String);
Var
  i: Integer;
Begin
  {Called with the Tform.name value of a form. }
  For i := Screen.CustomFormCount - 1 Downto 0 Do
  Begin
    If (Uppercase(Screen.CustomForms[i].Name) = Uppercase(s)) Then
    Begin
      (Screen.CustomForms[i] As TForm).SetFocus;
      Break;
    End;
  End;
End;

Function ParseSiteCode(Input: String): String;
Var
  i: Integer;
  Abbr, Res: String;
  OrdValue: Integer;
Begin
  Abbr := Uppercase(Input);
  Res := '';
  // 48-57
  For i := 1 To Length(Abbr) Do
  Begin
    OrdValue := Ord(Abbr[i]);
    // 48-57 are numbers
    // 9/9/2005 p45t8 Fix bug with Station Numbers that end with numbers after letters
    If (OrdValue < 48) Or (OrdValue > 57) Then
    Begin

      If Res <> '' Then
      Begin
        Result := Res;
        Exit;
      End;
    End
    Else
    Begin
      Res := Res + Abbr[i];
    End;
    {
    if (ordValue > 47) and (ordValue < 58) then
    begin
      res := res + abbr[i];
    end;
    }
  End;
  Result := Res;
End;

///////////
{ Description: Debug utility that takes an arbitrary string parameter and writes
  it to a local disk file.  The file is opened and closed each time this method
  is called.  To enable this method you must add a compiler directive DEBUGTOFILE
  and rebuild the project
  JK 3/11/2009
}

Procedure DebugFile(s: String); {JK 3/11/2009}
Const
  DebugDirectory = 'C:\VIDebug';
  DebugFile = 'DebugFile.Txt';
Var
  f: Textfile;
  NewFile: Boolean;
Begin
{$IFDEF DEBUGTOFILE}
  If Not Directoryexists(DebugDirectory) Then
  Begin
    CreateDir(DebugDirectory);
    NewFile := True;
  End
  Else
    If FileExists(DebugDirectory + '\' + DebugFile) Then
      NewFile := False
    Else
      NewFile := True;

  AssignFile(f, DebugDirectory + '\' + DebugFile);
  Try
    Try
      If NewFile Then
        Rewrite(f)
      Else
        Append(f);

      Writeln(f, Formatdatetime('mmm dd hh:nn:ss.zzz', Now) + ' => ' + s);

    Finally
      CloseFile(f);
    End;
  Except
    On e: Exception Do
      Showmessage('IO Error: ' + e.Message);
  End;
{$ELSE}
  ;
{$ENDIF}
End;

Function Magexecutefile(Const Filename, Params, DefaultDir: String; ShowCmd: Integer; Oper: String = 'open'): THandle;
Var
  ZOper, ZFileName, ZParams, ZDir: Array[0..279] Of Char;
  myfilename, myparams: String;
Begin
  myfilename := Filename;
  myparams := Params;
  If Copy(myfilename, 1, 1) <> '"' Then myfilename := '"' + myfilename + '"';
  If Copy(myparams, 1, 1) <> '"' Then myparams := '"' + myparams + '"';

 //                              HWND                lpOperation
  Result := ShellExecute(Application.MainForm.Handle, Strpcopy(ZOper, Oper),
  //      lpFile                      lpParameters
    Strpcopy(ZFileName, myFileName), Strpcopy(ZParams, myParams),
  //      lpDirectory          nShowCmd
    Strpcopy(ZDir, DefaultDir), ShowCmd);
End;

Procedure Magsetbounds(Formx: TForm; Rectx: Trect);
Var
  Wrksarea: TMagScreenArea;
Begin
    {Rectx  =  the saved coordinates of a form from Upref object.
            Rectx.left
            Rectx.top
            Rectx.Right (THIS is actuall the WIDTH) of the window.
            Rectx.Bottom (This is actually the HEIGHT of the window.
    i.e. example saving user preferences.
     *********** upref.mainpos.right := frmMain.width;
     *********** upref.mainpos.bottom := frmMain.height;
       and when it is called....
     ***********     MagSetBounds(frmMain, Upref.mainpos);

    Formx   = the form that we want to apply the saved settings too.
    }
    {We don't want to display a form off of the screen...}
  Try
    Wrksarea := GetScreenArea;
    If (Rectx.Right > Wrksarea.Width) Then
      Rectx.Right := Wrksarea.Width;
    If (Rectx.Bottom > Wrksarea.Height) Then
      Rectx.Bottom := Wrksarea.Height;
    If (Rectx.Left < Wrksarea.Left) Then
      Rectx.Left := Wrksarea.Left;
    If (Rectx.Top < Wrksarea.Top) Then
      Rectx.Top := Wrksarea.Top;
        //                      width
    If ((Rectx.Left + Rectx.Right) > Wrksarea.Right)
            {//                                          width}Then
      Rectx.Left := Wrksarea.Right - Rectx.Right;
        //                       height
    If ((Rectx.Top + Rectx.Bottom) > Wrksarea.Bottom)
            {//                                        height}Then
      Rectx.Top := Wrksarea.Bottom - Rectx.Bottom;

        ///////////////////
        (*  wrksarea := GetScreenArea;
          //if (form.left < wrksarea.left) then form.left := wrksarea.left;
          //if (form.top < wrksarea.top) then form.top := wrksarea.top;
          if (form.Left + form.Width) > wrksarea.right then form.left := wrksarea.right - form.Width;
          if (form.top + form.height) > wrksarea.bottom then form.top := wrksarea.bottom - form.height;
          if (form.top < wrksarea.top) then form.top := wrksarea.top;
          if (form.left < wrksarea.left) then form.left := wrksarea.left;*)
        //////////////////
  Finally
    Wrksarea.Free;
  End;

    //unit controls
    //procedure TControl.SetBounds(ALeft, ATop, AWidth, AHeight: Integer);

      // setbounds was commented out, and 5 lines after were used
      // don't know why, so I'm using setbounds.  and commented out the next 5 lines.
  Formx.SetBounds(Rectx.Left, Rectx.Top, Rectx.Right, Rectx.Bottom);
    (*  Formx.Left := Rectx.Left;
      Formx.Top := Rectx.top;
      Formx.Width := Rectx.Right;
      Formx.update;
      Formx.Height := Rectx.Bottom;*)
End;

{/ P117 - JK 9/20/2010 - Returns formatted date range from a day span.
   Put in a "from" and "to" date and get back "yyy years, mmm months,
   ddd days" or a part of the yyy,mmm,ddd based on what is not zero,
   or "Today" /}
function FormatDateRange(FromDate, ToDate: TDate): String;
var
  Temp: TDateTime;
  i: Integer;
  Years, Months, Days: Integer;
  strDays, strMonths, strYears: String;
begin
  Years  := 0;
  Months := 0;
  Days   := 0;
  i      := 0;
  Temp   := FromDate;

  while Temp <= ToDate do
  begin
    Inc(i);
    Temp := IncMonth(FromDate, i);
  end;

  Years := i div 12;

  if i mod 12 = 0 then
   begin
     Dec(Years);
     Months := 11;
   end
 else
   Months := i mod 12-1;

  // This will return number of whole days counting from time part of DateFrom + the current day
  Days := Trunc(ToDate - IncMonth(Temp, -1)) + 1;

  if Days = 1 then
    strDays := ', ' + IntToStr(Days) + ' day'
  else
    strDays := ', ' + IntToStr(Days) + ' days';

  if Months = 0 then
    strMonths := ''
  else if Months = 1 then
    strMonths := ', ' + IntToStr(Months) + ' mth'
  else
    strMonths := ', ' + IntToStr(Months) + ' mths';

  if Years = 0 then
    strYears := ''
  else if Years = 1 then
    strYears := IntToStr(Years) + ' yr'
  else
    strYears := IntToStr(Years) + ' yrs';

  if IsToday(FromDate) and IsToday(ToDate) then
    Result := 'Today'
  else
  begin
    Result := Trim(strYears + strMonths + strDays);

    if Pos(',', Result) = 1 then
      Result := Copy(Result, 2, Length(Result));
    if Pos(',', Result) = 1 then
      Result := Copy(Result, 2, Length(Result));

  end;

end;

End.
