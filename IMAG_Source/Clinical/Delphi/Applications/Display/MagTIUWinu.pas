Unit MagTIUWinu;
   {
   Package: MAG - VistA Imaging
   WARNING: Per VHA Directive 10-93-142 this unit should not be modified.
   Date Created:     1996
   Site Name: Silver Spring, OIFO
   Developers: Garrett Kirin
   Description: Displays a list of TIU Documents for a Patient, and allows the
        previewing of the report.
   Note:
   }
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
  Classes,
  ComCtrls,
  Controls,
  Dialogs,
  ExtCtrls,
  Forms,
  Menus,
  Stdctrls,
  UMagClasses,
  ImgList,
  ToolWin ,
  imaginterfaces
  ;

//Uses Vetted 20090929:cMagDBBroker, maggut1, ImgList, ToolWin, Graphics, Messages, umagdefinitions, magpositions, uMagTIUutil, umagutils, SysUtils, Windows

Type
  TMagTIUWinf = Class(TForm)
    MainMenu1: TMainMenu;
    Options1: TMenuItem;
    MPreview: TMenuItem;
    Refreshthelist1: TMenuItem;
    N3: TMenuItem;
    SelectAuthor1: TMenuItem;
    View1: TMenuItem;
    DCSummaries1: TMenuItem;
    Consults1: TMenuItem;
    N1: TMenuItem;
    SignedNotes1: TMenuItem;
    UnSignedNotes1: TMenuItem;
    UnCosignedNotes1: TMenuItem;
    SignedNotesbyAuthor1: TMenuItem;
    N2: TMenuItem;
    Mtoolbar: TMenuItem;
    PListNotes: Tpanel;
    StatusBar1: TStatusBar;
    Pmemo: Tpanel;
    Lbpreview: Tlabel;
    Memo1: TMemo;
    Splitter1: TSplitter;
    ListView1: TListView;
    LbList: Tlabel;
    ToolBar1: TToolBar;
    TbImage: TToolButton;
    TbReport: TToolButton;
    ToolButton3: TToolButton;
    ImageList1: TImageList;
    ToolButton1: TToolButton;
    N4: TMenuItem;
    MListCount: TMenuItem;
    M50: TMenuItem;
    M100: TMenuItem;
    MAll: TMenuItem;
    MFont: TMenuItem;
    FontDialog1: TFontDialog;
    ClinicalProcedures1: TMenuItem;
    ProgressNotes1: TMenuItem;
    N5: TMenuItem;
    MnuListAddendums: TMenuItem;
    Help1: TMenuItem;
    ProgressNotelisting1: TMenuItem;
    ActiveForms1: TMenuItem;
    MnuFile: TMenuItem;
    MnuOpenImage: TMenuItem;
    MnuOpenReport: TMenuItem;
    N6: TMenuItem;
    Exit1: TMenuItem;
    Procedure FormCreate(Sender: Tobject);
    Procedure MPreviewClick(Sender: Tobject);
    Procedure Refreshthelist1Click(Sender: Tobject);
    Procedure NotesFromTAG(Sender: Tobject); // our call,
    Procedure SelectAuthor1Click(Sender: Tobject);
    Procedure ListView1Click(Sender: Tobject);
    Procedure MtoolbarClick(Sender: Tobject);
    Procedure FormDestroy(Sender: Tobject);
    Procedure FormShow(Sender: Tobject);
    Procedure FormResize(Sender: Tobject);
    Procedure ListView1ColumnClick(Sender: Tobject; Column: TListColumn);
    Procedure ListView1Compare(Sender: Tobject; Item1, Item2: TListItem;
      Data: Integer; Var Compare: Integer);
    Procedure ToolButton3Click(Sender: Tobject);
    Procedure TbImageClick(Sender: Tobject);
    Procedure TbReportClick(Sender: Tobject);
    Procedure ListView1DblClick(Sender: Tobject);
    Procedure MFontClick(Sender: Tobject);
    Procedure M50Click(Sender: Tobject);
    Procedure M100Click(Sender: Tobject);
    Procedure MAllClick(Sender: Tobject);
    Procedure ListView1Change(Sender: Tobject; Item: TListItem;
      Change: TItemChange);
    Procedure Consults1Click(Sender: Tobject);
    Procedure ClinicalProcedures1Click(Sender: Tobject);
    Procedure ProgressNotes1Click(Sender: Tobject);
    Procedure DCSummaries1Click(Sender: Tobject);
    Procedure SignedNotesbyAuthor1Click(Sender: Tobject);
    Procedure MnuListAddendumsClick(Sender: Tobject);
    Procedure ProgressNotelisting1Click(Sender: Tobject);
    Procedure ActiveForms1Click(Sender: Tobject);
    Procedure ListView1KeyDown(Sender: Tobject; Var Key: Word;
      Shift: TShiftState);
    Procedure MnuFileClick(Sender: Tobject);
    Procedure Exit1Click(Sender: Tobject);
    Procedure MnuOpenImageClick(Sender: Tobject);
    Procedure MnuOpenReportClick(Sender: Tobject);
  Private
    FshowAddendums: Boolean;
    Fcount: Integer;
    FAuthor: String;
    FAuthorDuz: String;
    FDefaultheight: Integer;
    Ftypeoflist: Integer; // 1-4 notes
    FDocClass: Integer; // 3- notes, xx - Clinical Proc  x2 - Consults.
    FDocClassDesc: String;
    FClinProcClass: Integer;
    FConsultClass: Integer; // function to return Class

    FDFN: String[15];
    FPatientName: String[30];
    Procedure ResizeColumns;
    Procedure ClearPreviewNote;
    Procedure SetPreviewNote(Tf: Boolean);
    Procedure SelectAuthor;
    Procedure GetSignedNotesByAuthor;
    Procedure PreviewSelectedNote;
    Function ShowNoteTitle(TiuObjx: TMagTIUData): String;
    Function Showlistinfo(s: String): String;
    Procedure SortDateTime(Var Lic: String);
    Procedure ImagesForNote;
    Procedure ReportForNote;
    Procedure NotesByContext;
    Procedure OpenSelectedNoteImage;

  Public
    Finverse: Boolean;
    Fcurcolumnindex: Integer;

    Procedure SetPatientName(Xdfn, XName: String);

    Procedure GetSelectedlist;

    Procedure Getnotes;
    Procedure GetDischargeSummaries;
    Procedure GetConsults;
    Procedure GetClinicalProcedures;

    Procedure ClearTIUWin;
    Procedure Refresh;
    Procedure SetDocClass(Docclass: Integer; Docclassdesc: String);
    Function GetDocClass: Integer;
    Procedure EnableCP(Value: Boolean);
  End;

Var
  MagTIUWinf: TMagTIUWinf;

Implementation

Uses
  ImagDMinterface, //RCA  DmSingle,DmSingle,
  FmagMain,
  FmagVistALookup,
//RCA  Maggmsgu,
  Magpositions,
  SysUtils,
  uMagDefinitions,
  umagdisplaymgr,
  //uMagDisplayUtils,
  uMagTIUutil,
  umagutils8,
  umagUtils8A,
  Windows
  ;

{$R *.DFM}

Procedure TMagTIUWinf.FormCreate(Sender: Tobject);
Begin
  FshowAddendums := False;
  GetFormPosition(Self As TForm);
  PListNotes.Align := alClient;
  Finverse := True;
  FDefaultheight := Height;
  Ftypeoflist := 1;
  Fcount := 50;
  FDocClass := 3;
  FDocClassDesc := 'Progress Notes';

  FClinProcClass := 0;
  FConsultClass := 0;

End;

Procedure TMagTIUWinf.SetDocClass(Docclass: Integer; Docclassdesc: String);
Begin
  FDocClass := Docclass;
  FDocClassDesc := Docclassdesc;
//caption := Fdocclassdesc +': '+FpatientName;
End;

Function TMagTIUWinf.GetDocClass;
Begin
  Result := FDocClass;
End;

Procedure TMagTIUWinf.MPreviewClick(Sender: Tobject);
Begin
  MPreview.Checked := Not MPreview.Checked;
  SetPreviewNote(MPreview.Checked);
  If MPreview.Checked Then PreviewSelectedNote;
End;

Procedure TMagTIUWinf.ClearPreviewNote;
Begin
  Lbpreview.caption := '';
  Memo1.Lines.Clear;
End;

Procedure TMagTIUWinf.ClearTIUWin;
Var //TIUInfoPtr: ptrTIUInfo;
  TiuObj: TMagTIUData;
  i: Integer;
Begin
  ClearPreviewNote;
  For i := 0 To ListView1.Items.Count - 1 Do
  Begin
    TiuObj := ListView1.Items[i].Data;
//    dispose(tiuinfoptr);
    TiuObj.Free;
  End;
  ListView1.Items.Clear;
  MagTIUWinf.caption := 'TIU Document Listing';
  LbList.caption := '';
  FDFN := '';
  FPatientName := '';
End;

Procedure TMagTIUWinf.PreviewSelectedNote;
Var
  Li: TListItem;
  s: String;
  t: Tstringlist;
//  TIUinfoptr: ptrTIUinfo;
  TiuObj: TMagTIUData;
Begin
  t := Tstringlist.Create;
  Try
    If (ListView1.Selected = Nil) Then Exit;
    Li := ListView1.Selected;
    TiuObj := Li.Data;
    idmodobj.GetMagDBBroker1.RPGetNoteText(TiuObj.TiuDA, t);
    s := ShowNoteTitle(TiuObj);
    If idmodobj.GetMagPat1.M_UseFakeName Then
    Begin
      MagReplaceStrings(idmodobj.GetMagPat1.M_PatName, idmodobj.GetMagPat1.M_NameDisplay, t);

      {/ P122 with P123 patient ID additions - JK 8/11/2011 /}
      if GSess.Agency.IHS then
      begin
        MagReplaceStrings(idmodobj.GetMagPat1.M_SSN, '000000', t);
        MagReplaceStrings(idmodobj.GetMagPat1.M_SSNdisplay, '000000', t);
        MagReplaceString(idmodobj.GetMagPat1.M_PatName, idmodobj.GetMagPat1.M_NameDisplay, s);
        MagReplaceString(idmodobj.GetMagPat1.M_SSN, '000000', s);
        MagReplaceString(idmodobj.GetMagPat1.M_SSNdisplay, '000000', s);
      end
      else
      begin
        MagReplaceStrings(idmodobj.GetMagPat1.M_SSN, '000000000', t);
        MagReplaceStrings(idmodobj.GetMagPat1.M_SSNdisplay, '000-00-0000', t);
        MagReplaceString(idmodobj.GetMagPat1.M_PatName, idmodobj.GetMagPat1.M_NameDisplay, s);
        MagReplaceString(idmodobj.GetMagPat1.M_SSN, '000000000', s);
        MagReplaceString(idmodobj.GetMagPat1.M_SSNdisplay, '000-00-0000', s);
      end;
    End;
    Lbpreview.caption := s;
    Memo1.Lines.Assign(t);

  Finally
    t.Free;
  End;
End;

Function TMagTIUWinf.ShowNoteTitle(TiuObjx: TMagTIUData): String;
Begin
  Try
    Result := TiuObjx.Title + '  ' + TiuObjx.DispDT + '  ' +
      TiuObjx.PatientName + '  Auth: ' + TiuObjx.AuthorName;
  Except
    On e: Exception Do Result := '';
  End;
End;

Procedure TMagTIUWinf.Refreshthelist1Click(Sender: Tobject);
Begin
  Refresh;
End;

Procedure TMagTIUWinf.Refresh;
Begin
  ClearPreviewNote;
  GetSelectedlist;
End;

Procedure TMagTIUWinf.NotesFromTAG(Sender: Tobject);

Begin
  ClearPreviewNote;
  Ftypeoflist := (Sender As TMenuItem).Tag;
  SignedNotes1.Checked := (SignedNotes1.Tag = Ftypeoflist);
  UnSignedNotes1.Checked := (UnSignedNotes1.Tag = Ftypeoflist);
  UnCosignedNotes1.Checked := (UnCosignedNotes1.Tag = Ftypeoflist);
  SignedNotesbyAuthor1.Checked := (SignedNotesbyAuthor1.Tag = Ftypeoflist);
  GetSelectedlist;
End;

Procedure TMagTIUWinf.Getnotes;
Begin
  ProgressNotes1.Checked := True;
  ClearPreviewNote;
  SetDocClass(3, 'Progress Notes');
  GetSelectedlist;
End;

Procedure TMagTIUWinf.GetDischargeSummaries;
Var
  t: Tstringlist;
Begin
  DCSummaries1.Checked := True;
  ClearPreviewNote;
  SetDocClass(0, 'Discharge Summaries');
  { hide the Image CT column when not applicable }
  caption := FDocClassDesc + ': ' + FPatientName;
  Update;
  ListView1.Columns[3].Width := 0;
  TbImage.Enabled := False;
  t := Tstringlist.Create;
  Try
    idmodobj.GetMagDBBroker1.RPGetDischargeSummaries(FDFN, t);
    TiuListToListView(t, ListView1);
    LbList.caption := Showlistinfo('Discharge Summaries');
  Finally
    t.Free;
  End;
End;

Procedure TMagTIUWinf.GetClinicalProcedures;
Begin

  If (FClinProcClass = 0) Then FClinProcClass := idmodobj.GetMagDBBroker1.RPTIUCPClass;
  If FClinProcClass = 0 Then
  Begin
      //maggmsgf.MagMsg('DE','Error: Clinical Procedures Class is undefined in TIU',nilpanel);
    MagAppMsg('DE', 'Error: Clinical Procedures Class is undefined in TIU'); {JK 10/5/2009 - Maggmsgu refactoring}
    ClinicalProcedures1.Checked := True;
    Exit;
  End;
  ClinicalProcedures1.Checked := True;
  ClearPreviewNote;
  FDocClass := FClinProcClass;
  If FDocClass = 0 Then Exit;
  SetDocClass(FDocClass, 'Clinical Procedures');
  GetSelectedlist;
End;

Procedure TMagTIUWinf.GetConsults;
Begin

  If (FConsultClass = 0) Then FConsultClass := idmodobj.GetMagDBBroker1.RPTIUConsultsClass;
  Consults1.Checked := True;
  ClearPreviewNote;
  FDocClass := FConsultClass; // function to return Class
  If FDocClass = 0 Then Exit;
  SetDocClass(FDocClass, 'Consults');
  GetSelectedlist;
End;

Procedure TMagTIUWinf.GetSelectedlist;
Begin
  caption := FDocClassDesc + ': ' + FPatientName;
  LbList.caption := Showlistinfo(FDocClassDesc);
  Case Ftypeoflist Of
    1..4:
      Begin
            { hide the Image CT column when not applicable }
        ListView1.Columns[3].Width := 60;
        TbImage.Enabled := True;
        NotesByContext;
      End;
  End;
End;

Procedure TMagTIUWinf.NotesByContext;
Var
  t: Tstringlist;
  s: String;
  XDuz: String;
  Incund: Integer;
  Showaddendum: Integer;
Begin
  Showaddendum := MagBoolToInt(FshowAddendums);
{ hide the Image CT column when not applicable }
  If Ftypeoflist = 0 Then Exit;
  t := Tstringlist.Create;

  If (Ftypeoflist = 4) Then
    XDuz := FAuthorDuz
  Else
    XDuz := Duz;
  Try
    //if (fDocClass = FClinProcClass) and ((FtypeofList = 2) or (FtypeofList = 3))
    If (FDocClass = FClinProcClass) And (Ftypeoflist = 2) Then
      Incund := 1
    Else
      Incund := 0;
{  Patch 59 changed the 'ShowAddendum' parameter from '0' to '1' }
    idmodobj.GetMagDBBroker1.RPGetNotesByContext(FDFN, t, Ftypeoflist, XDuz, Inttostr(Fcount), FDocClass, 'D', Showaddendum, Incund);
    TiuListToListView(t, ListView1);

    Case Ftypeoflist Of
      1: s := ' Signed';
      2: s := ' UnSigned';
      3: s := ' UnCosigned';
      4: s := ' Signed by : ' + FAuthor;
    End;
    If (Incund = 1) Then s := s + ',Undictated,Untranscribed';
    LbList.caption := Showlistinfo(FDocClassDesc + s);

  Finally
    t.Free;
  End;
End;

Function TMagTIUWinf.Showlistinfo(s: String): String;
Begin
  Try
    Result := Inttostr(ListView1.Items.Count) + '  ' + s;
  Except
    On e: Exception Do Result := '';
  End;
End;

Procedure TMagTIUWinf.SetPreviewNote(Tf: Boolean);
Begin
  Memo1.Clear;
  Pmemo.Visible := Tf;
  MPreview.Checked := Tf;
  If Tf Then
  Begin
    Pmemo.Height := PListNotes.Height Div 2;
    Splitter1.Top := Pmemo.Top - 3;
  End;
End;

Procedure TMagTIUWinf.SelectAuthor1Click(Sender: Tobject);
Begin
  SelectAuthor;
End;

Procedure TMagTIUWinf.SelectAuthor;
Var
  Retstr: String;
  Authorx: String;
Begin
    { TODO -cdemo :
make the options in the TIU window that call this function Disabled.
for the demo }
  Authorx := MagPiece(FAuthor, ' ', 1);
  If SearchVistAFile('200', 'Author', 'enter at least 3 characters of the Last Name', 'Lookup Author', Authorx, False, Retstr) Then
  Begin
    FAuthorDuz := MagPiece(Retstr, '^', 1);
    FAuthor := MagPiece(Retstr, '^', 2);
    GetSignedNotesByAuthor;
  End;

End;

Procedure TMagTIUWinf.SetPatientName(Xdfn, XName: String);
Begin
  FDFN := Xdfn;
  FPatientName := XName;
End;

Procedure TMagTIUWinf.ListView1Click(Sender: Tobject);
Begin
  If MPreview.Checked Then PreviewSelectedNote;
End;

Procedure TMagTIUWinf.ImagesForNote;
Var
  Tmpstr: String;
//  TIUInfoPtr: ptrTIUInfo;
  TiuObj: TMagTIUData;
  Li: TListItem;
Begin

  If (ListView1.Selected = Nil) Then Exit;
  Li := ListView1.Selected;
  TiuObj := Li.Data;
  Tmpstr := '^^^^' + TiuObj.TiuDA + '^ :' + TiuObj.Title + '-' + TiuObj.DispDT;
  Frmmain.ImagesForCPRSTIUNote(Tmpstr);
End;

Procedure TMagTIUWinf.ReportForNote;
Var
  Li: TListItem;
  //TIUinfoptr: ptrTIUinfo;
  TiuObj: TMagTIUData;
  t: Tstringlist;
  Desc: String;
Begin
  If (ListView1.Selected = Nil) Then Exit;
  t := Tstringlist.Create;
  Try
    Li := ListView1.Selected;
    TiuObj := Li.Data;
    idmodobj.GetMagDBBroker1.RPGetNoteText(TiuObj.TiuDA, t);
    Desc := ShowNoteTitle(TiuObj);
    If idmodobj.GetMagPat1.M_UseFakeName Then
    Begin
      {/ P122 with P123 patient ID additions - JK 8/11/2011 /}
      if GSess.Agency.IHS then
      begin
        MagReplaceStrings(idmodobj.GetMagPat1.M_PatName, idmodobj.GetMagPat1.M_NameDisplay, t);
        MagReplaceStrings(idmodobj.GetMagPat1.M_SSN, '000000', t);
        MagReplaceStrings(idmodobj.GetMagPat1.M_SSNdisplay, '000000', t);
        MagReplaceString(idmodobj.GetMagPat1.M_PatName, idmodobj.GetMagPat1.M_NameDisplay, Desc);
        MagReplaceString(idmodobj.GetMagPat1.M_SSN, '000000', Desc);
        MagReplaceString(idmodobj.GetMagPat1.M_SSNdisplay, '000000', Desc);
      end
      else
      begin
        MagReplaceStrings(idmodobj.GetMagPat1.M_PatName, idmodobj.GetMagPat1.M_NameDisplay, t);
        MagReplaceStrings(idmodobj.GetMagPat1.M_SSN, '000000000', t);
        MagReplaceStrings(idmodobj.GetMagPat1.M_SSNdisplay, '000-00-0000', t);
        MagReplaceString(idmodobj.GetMagPat1.M_PatName, idmodobj.GetMagPat1.M_NameDisplay, Desc);
        MagReplaceString(idmodobj.GetMagPat1.M_SSN, '000000000', Desc);
        MagReplaceString(idmodobj.GetMagPat1.M_SSNdisplay, '000-00-0000', Desc);
      end;
    End;
    idmodobj.GetMagUtilsDB1.ShowReport(t, Desc, Desc);
  Finally
    t.Free;
  End;
End;

Procedure TMagTIUWinf.MtoolbarClick(Sender: Tobject);
Begin
(*mtoolbar.checked := not mToolbar.checked;
toolbar1.visible := mtoolbar.checked;
*)
End;

Procedure TMagTIUWinf.FormDestroy(Sender: Tobject);
Var
  i: Integer;
  //tiuinfoptr: ptrTIUinfo;
  TiuObj: TMagTIUData;
Begin
  SaveFormPosition(Self As TForm);
  For i := 0 To ListView1.Items.Count - 1 Do
  Begin
    TiuObj := ListView1.Items[i].Data;
//    dispose(tiuinfoptr);
    TiuObj.Free;
  End;
End;

Procedure TMagTIUWinf.FormShow(Sender: Tobject);
Begin
  If (FAuthor = '') Then
  Begin
    FAuthor := MagPiece(DUZName, '^', 2);
    FAuthorDuz := Duz;
  End;
End;

Procedure TMagTIUWinf.FormResize(Sender: Tobject);
Begin

  If Not Pmemo.Visible Then Exit;

  If ((Pmemo.Height + 75) > PListNotes.Height) Then Pmemo.Height := PListNotes.Height - 75;
  Splitter1.Top := Pmemo.Top - 3;

End;

Procedure TMagTIUWinf.ListView1ColumnClick(Sender: Tobject;
  Column: TListColumn);
Begin
  Finverse := Not Finverse;
  Fcurcolumnindex := Column.Index;
  ListView1.CustomSort(Nil, 0);
End;

Procedure TMagTIUWinf.ListView1Compare(Sender: Tobject; Item1,
  Item2: TListItem; Data: Integer; Var Compare: Integer);
Var
  Lic1, Lic2: String;
Begin
  If Fcurcolumnindex = 0 Then
  Begin
    Lic1 := Item1.caption;
    Lic2 := Item2.caption;
  End
  Else
  Begin
    Lic1 := Item1.SubItems[Fcurcolumnindex - 1];
    Lic2 := Item2.SubItems[Fcurcolumnindex - 1];
  End;

  Case Fcurcolumnindex Of
     (*0: begin
        SortDayCase(lic1);
        SortDayCase(lic2);
        end; *)
    1:
      Begin
        SortDateTime(Lic1);
        SortDateTime(Lic2);
      End;
    (* 8: begin
        SortJustifystring(lic1);
        SortJustifystring(lic2);
        end;*)
  End;

(*Result := -lstrcmp(PChar(TListItem(Item1).Caption),
                     PChar(TListItem(Item2).Caption));*)
  If Finverse Then
    Compare := -Lstrcmp(PChar(Lic1), PChar(Lic2))
  Else
    Compare := Lstrcmp(PChar(Lic1), PChar(Lic2));

End;

Procedure TMagTIUWinf.SortDateTime(Var Lic: String);
Begin
//  02/05/1996@07:08
  Lic := Copy(Lic, 7, 4) + Copy(Lic, 1, 2) + Copy(Lic, 4, 2)
    + Copy(Lic, 12, 2) + Copy(Lic, 15, 2) + Copy(Lic, 18, 2);

End;

Procedure TMagTIUWinf.ToolButton3Click(Sender: Tobject);
Begin
  ResizeColumns;
End;

Procedure TMagTIUWinf.ResizeColumns;
Var
  i: Integer;
Var
  j: Integer;
Begin
  For i := 0 To ListView1.Columns.Count - 1 Do
  Begin
    ListView1.Columns[i].Width := ColumnTextWidth;
    j := ListView1.Columns[i].Width;
    ListView1.Columns[i].Width := ColumnHeaderWidth;
    If (j > ListView1.Columns[i].Width) Then ListView1.Columns[i].Width := j;
  End;
End;

Procedure TMagTIUWinf.TbImageClick(Sender: Tobject);
Begin
  ImagesForNote;
End;

Procedure TMagTIUWinf.TbReportClick(Sender: Tobject);
Begin
  ReportForNote;
End;

Procedure TMagTIUWinf.ListView1DblClick(Sender: Tobject);
Begin
  OpenSelectedNoteImage;
End;

Procedure TMagTIUWinf.OpenSelectedNoteImage;
Begin
  If Ftypeoflist = 5 Then
    ReportForNote
  Else
    ImagesForNote;
End;

Procedure TMagTIUWinf.MFontClick(Sender: Tobject);
Begin
  FontDialog1.Font := Font;
  If FontDialog1.Execute Then
  Begin
    Font := FontDialog1.Font;
    ResizeColumns;
  End;
End;

Procedure TMagTIUWinf.M50Click(Sender: Tobject);
Begin
  M50.Checked := True;
  Fcount := 50;
  Refresh;
End;

Procedure TMagTIUWinf.M100Click(Sender: Tobject);
Begin
  M100.Checked := True;
  Fcount := 100;
  Refresh;
End;

Procedure TMagTIUWinf.MAllClick(Sender: Tobject);
Begin
  MAll.Checked := True;
  Fcount := 99999;
  Refresh;
End;

Procedure TMagTIUWinf.ListView1Change(Sender: Tobject; Item: TListItem;
  Change: TItemChange);
Begin
  If MPreview.Checked Then PreviewSelectedNote;
End;

Procedure TMagTIUWinf.Consults1Click(Sender: Tobject);
Begin
  GetConsults;
End;

Procedure TMagTIUWinf.ClinicalProcedures1Click(Sender: Tobject);
Begin
  GetClinicalProcedures;
End;

Procedure TMagTIUWinf.ProgressNotes1Click(Sender: Tobject);
Begin
  Getnotes;
End;

Procedure TMagTIUWinf.DCSummaries1Click(Sender: Tobject);
Begin
  GetDischargeSummaries;
End;

Procedure TMagTIUWinf.SignedNotesbyAuthor1Click(Sender: Tobject);
Begin
  GetSignedNotesByAuthor;
End;

Procedure TMagTIUWinf.GetSignedNotesByAuthor;
Begin
  //SignedNotesbyAuthor1.checked := true;
  ClearPreviewNote;
  Ftypeoflist := 4;
  SignedNotes1.Checked := (SignedNotes1.Tag = Ftypeoflist);
  UnSignedNotes1.Checked := (UnSignedNotes1.Tag = Ftypeoflist);
  UnCosignedNotes1.Checked := (UnCosignedNotes1.Tag = Ftypeoflist);
  SignedNotesbyAuthor1.Checked := (SignedNotesbyAuthor1.Tag = Ftypeoflist);
  GetSelectedlist;
End;

Procedure TMagTIUWinf.EnableCP(Value: Boolean);
Begin
  ClinicalProcedures1.Visible := Value;
End;

Procedure TMagTIUWinf.MnuListAddendumsClick(Sender: Tobject);
Begin
  MnuListAddendums.Checked := Not MnuListAddendums.Checked;
  FshowAddendums := MnuListAddendums.Checked;
  Refresh;
End;

Procedure TMagTIUWinf.ProgressNotelisting1Click(Sender: Tobject);
Begin
  Application.HelpContext(10155);
End;

Procedure TMagTIUWinf.ActiveForms1Click(Sender: Tobject);
Begin
  SwitchToForm;
End;

Procedure TMagTIUWinf.ListView1KeyDown(Sender: Tobject; Var Key: Word;
  Shift: TShiftState);
Begin
  If Key = VK_Return Then OpenSelectedNoteImage;
End;

Procedure TMagTIUWinf.MnuFileClick(Sender: Tobject);
Begin
  MnuOpenImage.Enabled := (ListView1.ItemIndex <> -1);
  MnuOpenReport.Enabled := (ListView1.ItemIndex <> -1);
End;

Procedure TMagTIUWinf.Exit1Click(Sender: Tobject);
Begin
  Close
End;

Procedure TMagTIUWinf.MnuOpenImageClick(Sender: Tobject);
Begin
  ImagesForNote;
End;

Procedure TMagTIUWinf.MnuOpenReportClick(Sender: Tobject);
Begin
  ReportForNote;
End;

End.
