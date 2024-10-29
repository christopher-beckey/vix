unit Maggut1;
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
 {ws18}
interface

uses StdCtrls, SysUtils, Controls,
  WinTypes, WinProcs, Messages, Classes, Graphics,
  Forms, Dialogs, Grids, Menus, ExtCtrls, inifiles
  ;
type
  userpreferences = record
    AppSaveOnClose : boolean;
    showabswindow: boolean; { make it visible on patient selection}
    showgrpwindow: boolean; // Not used.
    abstoolbar: boolean;
    absCols: integer;
    AbsMaxLoad: integer;
    AbsRows: integer;
    AbsLockSize: boolean;

    Fulltoolbar: boolean;
    FullCols: integer;
    FullMaxLoad: integer;
    FullRows: integer;
    FullLockSize: boolean;

    Doctoolbar: boolean;
    DocCols: integer;
    DocMaxLoad: integer;
    DocRows: integer;
    DocLockSize: boolean;

    Grptoolbar: boolean;
    GrpCols: integer;
    GrpMaxLoad: integer;
    GrpRows: integer;
    GrpLockSize: boolean;

    showmuse: boolean;
    shownotes: boolean;
    showImageListWin: boolean; { make it visible on patient selection}
    showRadListWin: boolean; { run the call to get rad exam list}
    //TeleLkp : boolean ;
    absViewJBox: boolean;
    absRevOrder: boolean;
    {accessed : boolean;}
    getmain: boolean;
    getabs: boolean;
    getnotes: boolean;
    getmuse: boolean;
    getdicom: boolean;
    getfull: boolean;
    getgroup: boolean;
    getdoc: boolean;
    getreport: boolean;
    getImageListWin: boolean;
    getRadListWin: boolean;

    mainstyle: byte; { 0 - MDIChild, 1 - MDIForm   2 - Normal 3 - StayOnTop}
    mainpos: trect; { top,  left , width, height  }
    maintoolbar: boolean; {0 False, 1 - true}
    absstyle: byte; { 0 - MDIChild, 1 - MDIForm   2 - Normal 3 - StayOnTop}
    abspos: trect; { top,  left , width, height  }
    abswidth: integer;
    absheight: integer;
    musestyle: byte;
    musepos: Trect;
    notesstyle: byte;
    notespos: Trect;
    dicomstyle: byte;
    dicompos: Trect;
    grpstyle: byte;
    grppos: trect;
    grpabswidth: integer;
    grpabsheight: integer;
    ImageListWinstyle: byte;
    ImageListWinpos: trect;
    ImageListWincolwidths: string;
    ImageListPrevAbs : boolean;
    ImageListPrevReport : boolean;
    RadListWinstyle: byte;
    RadListWinpos: trect;
    reportstyle: byte;
    reportpos: trect;
    reportfont: tfont;
    docstyle: byte;
    docpos: trect;
    docfitwidth: byte;
    docfitheight: byte;
    fullstyle: byte; { 0 - MDIChild      1 = seperate window }
    fullpos: trect;
    fullimagewidth: integer;
    fullimageheight: integer;

  end;

type
  ConsultInfo = record
    cRemHost: string[40];
    cPatdemog: string;
    cPatSSN: string[9];
    cPatLiL4: string[5];
    cPatName: string[30];
    cPatDOB: string[20];
    cDUZ: string[10];
  end;

  //gekP8  PMyList = ^TMagRecord;
  // Variable PMyList was only used by medtest1.  it was moved to that form.
  MagRecordPtr = ^TMagRecord;

  TMagRecord = record
    Mag0: string[10];
    AFile: string[130];
    FFile: string[130];
    BigFile: string;
    QAMsg: string; //Patch 5
    ImgDes: string[70];
    ImgType: byte; { a byte is 0 .. 255 }
    PtName: string[40];
    Date: string[20];
    Proc: string[30];
    AbsLocation: string[1];
    FullLocation: string[1];
    DicomImageNumber: integer;
    DicomSequenceNumber: integer;
    baseindex: integer;
  end;

type msgcode = set of char;

function magStrToInt(str: string): longint;
function magStripspaces(str: string): string;
function MAGLENGTH(STR, DEL: string): INTEGER;
function MAGPIECE(STR, DEL: string; PIECE: INTEGER): string;
function USERHAVEKEY(FORM: TFORM; DUZ, KEY: string): string;
procedure showimagelist(stmp: Tlistbox; lstControl: TlistBox);
function FMtoDispDt(fmdt: string): string;

procedure showopenforms;
function GetIniEntry(section, entry: string): string;
procedure SetIniEntry(section, entry, value: string);
procedure SendWindowsMessage(txt: string);
procedure FormToNormalSize(xForm: Tform);
procedure GetStringGridFont(name: string; xstringgrid: TStringGrid);

//

var Upreff2: UserPreferences;
  upref: userpreferences;
  DemobaseImagelist: Tstringlist;
  AppPath: string;
  WmX: Word;
  MDIReportmemo: Tmemo;
const MUSESite: byte = 1;
const DemoMode: boolean = false;
const WrksCacheOn: boolean = false;
const nilpanel: Tpanel = nil;
implementation
 uses magguini ;
procedure SendWindowsMessage(txt: string);
var
  Buffer: array[0..255] of Char;
  Atom: TAtom;
begin
  Atom := GlobalAddAtom(StrPCopy(Buffer, txt));
  SendMessage(HWND_Broadcast, WmX, Application.Handle, Atom);
  GlobalDeleteAtom(Atom);
end;

procedure GetStringGridFont(Name: string; xstringgrid: Tstringgrid);
var
  stFont: string;
  xFont: Tfont;
begin
  xFont := TFont.create;
  try

    stFont := GetINIEntry('SYS_Fonts', name);
    if (stFont = '') then exit;
    // xFont in the format FontName^Size^[B|U|I]
    xfont.name := magpiece(stFont, '^', 1);
    xfont.size := strtoint(magpiece(stFont, '^', 2));
    if (pos('B', magpiece(stfont, '^', 3)) > 0) then xfont.style := [fsBold];
    if (pos('I', magpiece(stfont, '^', 3)) > 0) then xfont.style := xfont.style + [fsitalic];
    xstringgrid.font := xfont;
  finally;
    xfont.Free;
  end;
end;

procedure FormToNormalSize(xForm: Tform);
begin
  if (xForm.WindowState = wsminimized) then xForm.windowstate := wsnormal;
  xform.update;
  if xform.Visible = false then xForm.visible := true;
  xform.bringtofront;
  xform.update;
  application.processmessages;
end;

function MagPiece(str, del: string; Piece: Integer): string;
var I, K: INTEGER;
  s: string;
begin
  I := Pos(del, str);
  if (I = 0) and (PIECE = 1) then begin MAGPIECE := STR; EXIT; end;
  for K := 1 to PIECE do
  begin
    I := POS(DEL, STR);
    if (I = 0) then I := LENGTH(STR) + 1;
    S := COPY(STR, 1, I - 1);
    STR := COPY(STR, I + 1, LENGTH(STR));
  end;
  MAGPIECE := S;
end;

function MAGLENGTH(STR, DEL: string): INTEGER;
var I, J: INTEGER;
  ESTR: BOOLEAN;
begin
  ESTR := FALSE;
  I := 0;
  while not ESTR do
  begin
    I := I + 1;
    if (POS(DEL, STR) = 0) then ESTR := TRUE;
    J := POS(DEL, STR); STR := COPY(STR, J + 1, LENGTH(STR));
  end;
  MAGLENGTH := I;
end;

procedure showimagelist(stmp: Tlistbox; lstControl: TlistBox);
var
  i, j: integer;
  s, t: string;
begin
  i := stmp.items.count - 1;
  lstcontrol.clear;
  for j := 0 to i do
  begin
    s := stmp.items[j];
    { our s is set up like :
         Desc Cat  ^  Object Type  ^  Doc Date  ^  short desc.}
    t := magpiece(s, '^', 1) + '   ' + magpiece(s, '^', 2) + '   '
      + magpiece(s, '^', 3) + '   ' + magpiece(s, '^', 4);
    lstcontrol.items.add(t);
  end;
end;

function magStrToInt(str: string): longint;
var done: boolean;
var s, t: string;
  x: integer;
begin
  done := false;
  repeat
    x := pos(' ', str);
    if x > 0 then
    begin
      s := copy(str, 1, X - 1); T := copy(str, x + 1, length(str));
      str := s + t;
    end;
    if x = 0 then done := true;
  until done;
  magStrToInt := strtoint(str);
end;

function magStripspaces(str: string): string;
var done: boolean;
var s: string;
begin
  if STR = '' then begin magstripspaces := ''; exit; end; {fix for hang}
  done := false;
  repeat
    s := str[1];
    if (s = ' ') then str := copy(str, 2, length(str));
    if not (str[1] = ' ') then done := true;
    if str = '' then done := true; {fix for hang}
  until done;
  done := false;
  repeat
    s := str[length(str)]; if (s = ' ') then str := copy(str, 1, length(str) - 1);
    if not (str[length(str)] = ' ') then done := true;
    if str = '' then done := true; {fix for hang}
  until done;
  magStripspaces := str;
end;

function USERHAVEKEY(FORM: TFORM; DUZ, KEY: string): string;
begin

end;

procedure showopenforms;
var i: integer;
  tempform: Tform;
  templist: Tlistbox;
begin
  tempform := Tform.create(application.mainform);
  Templist := Tlistbox.create(application.mainform);
  Templist.align := alclient;
  Templist.parent := Tempform;
  Tempform.show;
  try
    with application do
    begin
      Templist.items.add('[COMPONENTS[I]]');
      for i := 0 to componentcount - 1 do
      begin
        if (components[i] is tform) then
        begin
          templist.items.add(Tform(components[i]).name);
        end;
      end;
    end;
    templist.items.add('--------------------');
    templist.items.add('SCREEN.CUSTOMFORMCOUNT[I]');
    for I := screen.CustomFormCount - 1 downto 0 do
    begin
      templist.items.add(screen.customforms[i].name)
    end;

  finally
  end;

end;

function GetIniEntry(section, entry: string): string;
var magini: Tinifile;
begin
  magini := Tinifile.create(GetConfigFileName);
  result := magini.readstring(section, entry, '');
  magini.free;
end;

procedure SetIniEntry(section, entry, value: string);
var magini: Tinifile;
begin
  magini := Tinifile.create(GetConfigFileName);
  magini.writestring(section, entry, value);
  magini.free;
end;

function FMtoDispDt(fmdt: string): string;
var
  xdt: string;
  xTM: string;
begin
  xdt := magpiece(fmdt, '.', 1);
  xtm := magpiece(fmdt, '.', 2);
  result := copy(xdt, 4, 2) + '/' + COPY(xdt, 6, 2) + '/'
    + inttostr(1700 + strtoint(copy(xdt, 1, 3)));
end;

end.
