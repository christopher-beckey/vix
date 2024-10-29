Unit Maggut9;
{
Package: MAG - VistA Imaging
WARNING: Per VHA Directive 10-93-142 this unit should not be modified.
Date Created:
Site Name: Silver Spring, OIFO
Developers: Garrett Kirin
Description: Imaging  Utilities : Mostly User Preferences
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
{Modified in Patch 149 only with comments}

Interface
Uses
  Classes,
  Controls,
  Forms,
  Graphics,
  UMagClasses,
  WinTypes  ,
  imaginterfaces
  ;

//Uses Vetted 20090929:Magguini, Trpcb, Maggrptu, Maggut1, ExtCtrls, Menus, Grids, Dialogs, Messages, WinProcs, StdCtrls, umagutils, fmagGroupAbs, umagdefinitions, dmsingle, magtiuwinu, magradlistwinu, maggmsgu, fmagImageList, fMagAbstracts, fmagFullRes, Maggrpcu, SysUtils

//function FullWinExist: boolean;
//function GRPWINEXIST: boolean;
//function radlistwinEXIST: boolean;
//function RADWINEXIST: boolean;
//function ABSWINEXIST: boolean;
//function REPORTEXIST: boolean;
//function EKGWINEXIST: boolean;
Procedure GetSetUserPreferences;
{/p94t2  gek 11/23/09 moved MagSetBounds to umagutils8}
//procedure MagSetBounds(Formx: Tform; Rectx: Trect);
Procedure UpreftoAbsWindow(Var Upref: Tuserpreferences);
Procedure UprefToMuseWindow(Var Upref: Tuserpreferences);
//procedure UprefToMainwindow(var upref: tuserpreferences);
Procedure UprefToGroupWindow(Var Upref: Tuserpreferences);
Procedure UprefToFullView(Var Upref: Tuserpreferences);
Procedure UprefToImageListWin(Var Upref: Tuserpreferences);
Procedure UprefToRadListWin(Var Upref: Tuserpreferences);
Procedure UprefToDicomWin(Var Upref: Tuserpreferences);
Procedure UprefToReport(Var Upref: Tuserpreferences);
{p94t3 gek get rid of this. use ApplyUserPrefs method of the form}
//procedure UprefToVerifyWin(var upref: tuserpreferences);
Procedure UprefToEditWin(Var Upref: Tuserpreferences);

Implementation

Uses
  ImagDMinterface, //RCA  DmSingle,DmSingle,
  FEKGDisplay,
  FMagAbstracts,
  FmagFullRes,
  FMagGroupAbs,
  FMagImageList,
  Fmagindexedit,
  fmagVerify,
//RCA  Maggmsgu,
  Maggrpcu,
  Magradlistwinu,
  MagTIUWinu,
  SysUtils,
  UMagDefinitions,
  Umagutils8  ,
  fmagAnnotationOptionsX //RCA
  ;

Procedure UprefToReport(Var Upref: Tuserpreferences);
Begin
    //with frmMain do
    //begin
  If Not Doesformexist('maggrpcf') Then
    Application.CreateForm(TMaggrpcf, Maggrpcf);
    //Maggrpcf := tmaggrpcf.create(application);

  If Not Upref.Getreport Then
  Begin
    Maggrpcf.Show;
    Exit;
  End;
    //if upref.reportstyle = 0 then
    //   begin
    //   frmMain.formstyle := fsMDIForm;
    //   frmMain.window1.visible := true;
    //   frmMain.windowmenu := window1;
    //   maggrpcf.hide;
    //   maggrpcf.windowstate := wsMaximized;
    //   maggrpcf.update;
    //   maggrpcf.formstyle := fsMDIChild;
    //   maggrpcf.show;
    //   exit;
    //   end;
  Maggrpcf.SetBounds(Upref.Reportpos.Left, Upref.Reportpos.Top, Upref.Reportpos.Right,
    Upref.Reportpos.Bottom);
  Maggrpcf.Memo1.Font := Upref.Reportfont;
  Maggrpcf.Show;
    //end;
End;

Procedure UpreftoAbsWindow(Var Upref: Tuserpreferences);
Begin
  If Not Doesformexist('frmMagAbstracts') Then
  Begin
    Application.CreateForm(TfrmMagAbstracts, FrmMagAbstracts);
        {    we don't need to 'Attach'.  The Property setter 'SetMagImageList..', does that for us.}
    FrmMagAbstracts.Mag4Viewer1.MagImageList := FrmImageList.MagImageList1;
  End;
  If FrmMagAbstracts.Formstyle <> FsNormal Then
    FrmMagAbstracts.Formstyle := FsNormal;
  If Not Upref.Getabs Then
  Begin
    FrmMagAbstracts.Mag4Viewer1.ReAlignImages;
    Exit;
  End;
  Magsetbounds(FrmMagAbstracts, Upref.AbsPos);
  FrmMagAbstracts.Mag4Viewer1.TbViewer.Visible := Upref.AbsToolBar;
  FrmMagAbstracts.Mag4Viewer1.ColumnCount := Upref.AbsCols;
  FrmMagAbstracts.Mag4Viewer1.MaxCount := Upref.AbsMaxLoad;
  FrmMagAbstracts.Mag4Viewer1.RowCount := Upref.AbsRows;
  FrmMagAbstracts.Mag4Viewer1.LockHeight := Upref.AbsHeight;
  FrmMagAbstracts.Mag4Viewer1.LockWidth := Upref.AbsWidth;
  FrmMagAbstracts.Mag4Viewer1.ImageFontSize := Upref.AbsFontSize;
    {   Must unlock 'LockSize" so we can ReAlignImages, with new rows and columns, and then LockSize if needed.}
  If FrmMagAbstracts.Mag4Viewer1.LockSize Then
    FrmMagAbstracts.Mag4Viewer1.LockSize := False;
  Try
    FrmMagAbstracts.Mag4Viewer1.ReAlignImages;
  Except
        //
  End;
  FrmMagAbstracts.Mag4Viewer1.Update;
  Application.Processmessages;
  FrmMagAbstracts.Mag4Viewer1.LockSize := Upref.AbsLockSize;
  Case Upref.AbsToolBarPos Of
    0: FrmMagAbstracts.Mag4Viewer1.TbViewer.Align := altop;
    1: FrmMagAbstracts.Mag4Viewer1.TbViewer.Align := alLeft;
  End;
    { future : have multiple layouts possible.  for now just user default settings}
  FrmMagAbstracts.Mag4Viewer1.SetDefaultLayout(Upref.AbsRows, Upref.AbsCols, Upref.AbsMaxLoad, Upref.AbsLockSize);
    //frmMagAbstracts.OnLogEvent := idmodobj.GetMagLogManager.LogEvent;  {JK 10/6/2009 - Maggmsgu refactoring}
End;

Procedure UprefToMuseWindow(Var Upref: Tuserpreferences);
Begin

    // with frmMain do
   //   begin
  If Not Doesformexist('EKGDisplayForm') Then
    Application.CreateForm(TEKGDisplayForm, EKGDisplayForm);
  If Not Upref.Getmuse Then
  Begin
    Exit;
  End;
  Magsetbounds(EKGDisplayForm, Upref.Musepos);
  If EKGDisplayForm.Formstyle <> FsNormal Then
    EKGDisplayForm.Formstyle := FsNormal;
    //    end;

End;

Procedure UprefToNoteswindow(Var Upref: Tuserpreferences);
Begin

    //  with frmMain do
    //    begin
  If Not Doesformexist('MagTIUWinf') Then
    Application.CreateForm(TMagTIUWinf, MagTIUWinf); // MagTIUWinf := TMagTIUWinf.create(frmMain);
  If Not Upref.Getnotes Then
  Begin
    Exit;
  End;
  Magsetbounds(MagTIUWinf, Upref.Notespos);
  If MagTIUWinf.Formstyle <> FsNormal Then
    MagTIUWinf.Formstyle := FsNormal;
    //    end;

End;

Procedure UprefToGroupWindow(Var Upref: Tuserpreferences);
Begin
    // with frmMain do
  Begin
    If Doesformexist('frmGroupAbs') Then
    Begin
      If FrmGroupAbs.WindowState = Wsminimized Then
        FrmGroupAbs.WindowState := Wsnormal;
    End
    Else
      Application.CreateForm(TfrmGroupAbs, FrmGroupAbs); //frmGroupAbs := tfrmGroupAbs.create(frmMain);
    If Not Upref.Getgroup Then
    Begin
      Exit;
    End;

    Magsetbounds(FrmGroupAbs, Upref.Grppos);

    FrmGroupAbs.Mag4Viewer1.TbViewer.Visible := Upref.Grptoolbar;
    FrmGroupAbs.Mag4Viewer1.ColumnCount := Upref.GrpCols;
    FrmGroupAbs.Mag4Viewer1.MaxCount := Upref.GrpMaxLoad;
    FrmGroupAbs.Mag4Viewer1.RowCount := Upref.GrpRows;

    FrmGroupAbs.Mag4Viewer1.LockHeight := Upref.Grpabsheight;
    FrmGroupAbs.Mag4Viewer1.LockWidth := Upref.Grpabswidth;
    FrmGroupAbs.Mag4Viewer1.ImageFontSize := Upref.GrpFontsize;

        // A Way to ReAlignImages, with new rows and columns, and then LockSize if needed.
    FrmGroupAbs.Mag4Viewer1.LockSize := False;

    FrmGroupAbs.Mag4Viewer1.ReAlignImages;
    FrmGroupAbs.Mag4Viewer1.LockSize := Upref.GrpLockSize;
    Case Upref.GrpToolBarPos Of
      0: FrmGroupAbs.Mag4Viewer1.TbViewer.Align := altop;
      1: FrmGroupAbs.Mag4Viewer1.TbViewer.Align := alLeft;
    End;
        // 01/20/03   the Deault Layout is new;
    FrmGroupAbs.Mag4Viewer1.SetDefaultLayout(Upref.GrpRows, Upref.GrpCols, Upref.GrpMaxLoad, Upref.GrpLockSize);
  End;
End;

(* procedure UprefToMainwindow(var upref: tuserpreferences);
begin
  with frmMain do
    begin
      if not upref.getmain then exit;
      frmMain.ptoolbar.visible := Upref.maintoolbar;
      frmMain.mnuToolbar.Checked := Upref.maintoolbar;
      MagSetBounds(frmMain, Upref.mainpos);
      frmMain.mnuSaveSettingsOnExit.Checked := upref.SaveSettingsOnExit; //02/10/2003
      frmMain.mnuMainHint.checked := upref.mainshowhint;
    end;
end;
*)

Procedure UprefToFullView(Var Upref: Tuserpreferences);
Begin
    //with frmMain do
  Begin

    If Not Doesformexist('frmFullRes') Then
      Application.CreateForm(TfrmFullRes, FrmFullRes); // frmFullRes := TfrmFullRes.create(frmMain);
    If Not Upref.Getfull Then
    Begin
      Exit;
    End;
    Magsetbounds(FrmFullRes, Upref.Fullpos);
        //01/06/03   Not showing Viewer Toolbar on Full Res Viewer
    FrmFullRes.MagViewerTB1.Visible := Upref.Fulltoolbar;     //t
    FrmFullRes.Mag4Viewer1.ColumnCount := Upref.FullCols;    //1
    FrmFullRes.Mag4Viewer1.MaxCount := Upref.FullMaxLoad;    //2
    FrmFullRes.Mag4Viewer1.RowCount := Upref.FullRows;       //1
    FrmFullRes.Mag4Viewer1.FLastFit := Upref.FullFitMethod;    //1
    FrmFullRes.Mag4Viewer1.LockHeight := Upref.Fullimageheight;    //609
    FrmFullRes.Mag4Viewer1.LockWidth := Upref.Fullimagewidth;      //1428
        // A Way to ReAlignImages, with new rows and columns, and then LockSize if needed.
    FrmFullRes.Mag4Viewer1.LockSize := False;
    FrmFullRes.Mag4Viewer1.ImageFontSize := Upref.Fullfontsize;  //8

        //frmFullRes.OnLogEvent := idmodobj.GetMagLogManager.LogEvent;  {JK 10/6/2009 - Maggmsgu refactoring}

    FrmFullRes.Mag4Viewer1.ReAlignImages;
    FrmFullRes.Mag4Viewer1.LockSize := Upref.FullLockSize;   //f
        // 01/20/03   the Deault Layout is new;                                                      //false                1
    FrmFullRes.Mag4Viewer1.SetDefaultLayout(Upref.FullRows, Upref.FullCols, Upref.FullMaxLoad, Upref.FullLockSize, Upref.FullFitMethod);

            {   If Defaults are not defined for the Toolbar in M, then
             we defalut CoolBar Bands to Break = true (for 2nd two) }              //  0,1,1
    FrmFullRes.MagViewerTB1.CoolBar1.Bands[0].Break := Magstrtobool(MagPiece(Upref.FullControlPos, ',', 1), 'false');
    FrmFullRes.MagViewerTB1.CoolBar1.Bands[1].Break := Magstrtobool(MagPiece(Upref.FullControlPos, ',', 2), 'true');
    FrmFullRes.MagViewerTB1.CoolBar1.Bands[2].Break := Magstrtobool(MagPiece(Upref.FullControlPos, ',', 3), 'true');
  End;
End;

Procedure UprefToImageListWin(Var Upref: Tuserpreferences);
Begin
  If Not Doesformexist('frmImageList') Then
    Application.CreateForm(TfrmImageList, FrmImageList);
  If Upref.GetImageListWin Then
    FrmImageList.UserPrefsApply(Upref);
  FrmImageList.Update;
  Application.Processmessages;
  If FrmImageList.Visible Then FrmImageList.FixFullResPosition;
End;

(*procedure UprefToVerifyWin(var upref: tuserpreferences);
begin
    if not DoesFormExist('frmVerify') then
        Application.createform(TfrmVerify, frmVerify);
    frmVerify.UserPrefsApply(upref);
end;  *)

Procedure UprefToEditWin(Var Upref: Tuserpreferences);
Begin
  If Not Doesformexist('frmIndexEdit') Then
    Application.CreateForm(TfrmIndexEdit, FrmIndexEdit);
  FrmIndexEdit.UserPrefsApply(Upref);
End;

Procedure UprefToRadListWin(Var Upref: Tuserpreferences);
Begin
    // with frmMain do
  Begin
    If Not Upref.GetRadListWin Then
    Begin
      Exit;
    End;
    Radlistwin.Setcollength.Click;
    Magsetbounds(Radlistwin, Upref.RadListWinpos);
    Radlistwin.PToolbar.Visible := Upref.RadListWinToolbar;
  End;
End;

Procedure UprefToDicomWin(Var Upref: Tuserpreferences);
Begin
    //
End;

(* function GRPWINEXIST: boolean;
begin
 result := DoesFormExist('frmGroupAbs');
end;  *)

(* function radlistwinEXIST: boolean;
begin
 result := DoesFormExist('radlistwin');
end; *)

(*
function ABSWINEXIST: boolean;
begin
 result := DoesFormExist('frmMagAbstracts');
end; *)

(* function RADWINEXIST: boolean;
begin
 result := DoesFormExist('frmDCMViewer');
end;  *)

(*function EKGWINEXIST: boolean;
begin
 result := DoesFormExist('EKGDisplayForm');
end; *)

(*function FullWinExist: boolean;
begin
 result := DoesFormExist('frmFullRes');
end; *)

(* function REPORTexist: boolean;
begin
 result := DoesFormExist('maggrpcf');
end; *)

       {       Get user preferences from VistA and populate the upref: Trecord}

Procedure GetSetUserPreferences;
Var
  i: Integer;
  t: Tstringlist;
  Rpcstat: Boolean;
  Rpcmsg: String;
  s: String;
Begin
    { Set some defaults}
  Upref.Reportfont := TFont.Create;
  Upref.ShowImageListWin := True;
  Upref.AbsShowWindow := True;
  Upref.ShowRadListWin := False;
  Upref.Showmuse := False;
  Upref.Shownotes := False;
  Upref.AbsViewJBox := False; // IniViewJBox; // P8T14
  Upref.AbsRevOrder := True; // P8T21  IniRevOrder;
    //P48T2 DBI
  Upref.AbsViewRemote := False; //IniViewRemoteAbs;
  Upref.Getmain := False;
  Upref.Getabs := False;
  Upref.Getfull := False;
  Upref.Getgroup := False;
  Upref.Getdoc := False;
  Upref.Getnotes := False;
  Upref.Getmuse := False;
  Upref.Getreport := False;
  Upref.GetImageListWin := False;
  Upref.GetRadListWin := False;
  Upref.AbsFontSize := 7;
  Upref.GrpFontsize := 7;
  Upref.Fullfontsize := 10;

    // JMW 6/22/2005 p45 defaults for RIV user preferences
  Upref.RIVAutoConnectEnabled := True;
  Upref.RIVAutoConnectVISNOnly := False;
  Upref.RIVHideEmptySites := False;
  Upref.RIVHideDisconnectedSites := False;
  Upref.RIVHideEmptyToolbar := False; // this is not being used yet...

  // JMW 4/26/2013 P131 Scout Lines Preferences default values
  UPref.DicomDisplayScoutLines := true;
  UPref.DicomDisplayScoutWindow := true;

  t := Tstringlist.Create;
    // new for dynamic user preferences, new style of GetSet.
  idmodobj.GetMagDBBroker1.RPMagGetUserPreferences(Rpcstat, Rpcmsg, t, 'LISTWIN1');
  If Not Rpcstat Then
  Begin
    Upref.ImageListPrevAbs := False;
    Upref.ImageListPrevReport := False;
    Upref.ImageListDefautFilter := '';
    Upref.ImageListFilterAsTabs := True;
    Upref.Imagelistmultilinetabs := False;
  End
  Else
  Begin
    If MagPiece(t[0], '^', 1) = 'LISTWIN1' Then
    Begin
      Upref.ImageListPrevAbs := Magstrtobool(MagPiece(t[0], '^', 2));
      Upref.ImageListPrevReport := Magstrtobool(MagPiece(t[0], '^', 3));
      Upref.ImageListDefautFilter := MagPiece(t[0], '^', 4);
      Upref.ImageListFilterAsTabs := Magstrtobool(MagPiece(t[0], '^', 5));
      Upref.Imagelistmultilinetabs := Magstrtobool(MagPiece(t[0], '^', 6));
    End;
  End;
  t.Clear;
  idmodobj.GetMagDBBroker1.RPMagGetUserPreferences(Rpcstat, Rpcmsg, t, 'APPPREFS');
  If Not Rpcstat Then
    Upref.SaveSettingsOnExit := False
  Else
  Begin
    If MagPiece(t[0], '^', 1) = 'APPPREFS' Then
    Begin
      Upref.SaveSettingsOnExit := Magstrtobool(MagPiece(t[0], '^', 2));

      If (MagPiece(t[0], '^', 3) <> '') Then
        Upref.AbsFontSize := MagStrToInt(MagPiece(t[0], '^', 3));
      If (MagPiece(t[0], '^', 4) <> '') Then
        Upref.GrpFontsize := MagStrToInt(MagPiece(t[0], '^', 4));
      If (MagPiece(t[0], '^', 5) <> '') Then
        Upref.Fullfontsize := MagStrToInt(MagPiece(t[0], '^', 5));
      Upref.DispReleaseNotes := (MagPiece(t[0], '^', 6));

      Upref.UseAltViewerForVideo := Magstrtobool(MagPiece(t[0], '^', 7));
      Upref.PlayVideoOnOpen := Magstrtobool(MagPiece(t[0], '^', 8));
      Upref.UseAltViewerForPDF := Magstrtobool(MagPiece(t[0], '^', 9));
      {/p117  upref piece 9,10 in Global Node   (10 11 here)}
      Upref.UseDelImagePlaceHolder := Magstrtobool(MagPiece(t[0], '^', 10));
      Upref.SuppressPrintSummary := Magstrtobool(MagPiece(t[0], '^', 11));


    End
    Else
    Begin

    End;
  End;
    // now continue with old settings.
  t.Clear;
  idmodobj.GetMagDBBroker1.RPMagGetUserPreferences(Rpcstat, Rpcmsg, t);
  If Not Rpcstat Then
    Exit;
  For i := 0 To t.Count - 1 Do
  Begin
    Try
      If MagPiece(t[i], '^', 1) = '0' Then
      Begin
                //oot upref.absmax := strtoint(magpiece(t[i], '^', 4));
                //oot if upref.absmax < 24 then upref.absmax := 24;
                //oot upref.grpabsmax := strtoint(magpiece(t[i], '^', 5));
                //oot if upref.grpabsmax < 24 then upref.grpabsmax := 24;
               //upref.telelkp :=     ( magpiece(t[i],'^',6)='1');
        Upref.AbsViewJBox := False; //(magpiece(t[i], '^', 7) = '1'); // P8T14
                { 9/28/00 GEK : Reverse Order is no longer used. TRUE is the default.}
        Upref.AbsRevOrder := True; //P8T21 (magpiece(t[i], '^', 8) = '1'); // := true; // gek MAG2.5

                //P48T2 DBI
        Upref.AbsViewRemote := (MagPiece(t[i], '^', 9) = '1');
                // P72 iniViewRemoteAbs := upref.absViewRemote;

               //IniTeleLkp := upref.telelkp;
                 //p72 IniViewJBox := FALSE ; //upref.absviewjbox; // P8T14
                 //p72 IniRevOrder := TRUE ; // P8T21  upref.absrevorder;

               //  we no longer use these, 12/21/99, we sync or not sync depending on whether we
               //     were started by CPRS or not.
               {
               CPRSSync.Queried  := ( magpiece(t[i],'^',9)='1');
               CPRSSync.SyncOn := ( magpiece(t[i],'^',10)='1');
               CPRSSync.PatSync := ( magpiece(t[i],'^',11)='1');
               CPRSSync.PatSyncPrompt := ( magpiece(t[i],'^',12)='1');
                 }
        Continue;
      End;

      If MagPiece(t[i], '^', 1) = 'ISTYLE' Then
      Begin
        Upref.StyleShowTree := Magstrtobool(MagPiece(t[i], '^', 2));
        Upref.StyleAutoSelect := Magstrtobool(MagPiece(t[i], '^', 3));
        Upref.StyleAutoSelectSpeed := MagStrToInt(MagPiece(t[i], '^', 4));
        Upref.StyleSyncSelection := True; // we're always syncing the selection, not giving a choice.

        Upref.StyleWhetherToShowAbs := MagStrToInt(MagPiece(t[i], '^', 6));
        Upref.StylePositionOfAbs := MagStrToInt(MagPiece(t[i], '^', 7));
        Upref.StyleWhereToShowImage := MagStrToInt(MagPiece(t[i], '^', 8));
        Upref.StyleTreeSortButtonsShow := Magstrtobool(MagPiece(t[i], '^', 9));

        Upref.StyleTreeAutoExpand := Magstrtobool(MagPiece(t[i], '^', 10));
        Upref.StyleListAbsScrollHoriz := Magstrtobool(MagPiece(t[i], '^', 11));
        Upref.StyleListFullScrollHoriz := Magstrtobool(MagPiece(t[i], '^', 12));
        Upref.StyleShowList := Magstrtobool(MagPiece(t[i], '^', 13));
        Upref.StyleControlPos := MagPiece(t[i], '^', 14);
                (*  upref.styleControlPositions =
                    result := ',' +
                        inttostr(self.memReport.Height) + ',' +
                        inttostr(self.pnlAbs.Height) + ',' +
                        inttostr(self.pnlAbs.Width) + ',' +
                        inttostr(self.ListWinAbsViewer.RowCount) + ',' +
                        inttostr(self.ListWinAbsViewer.ColumnCount) + ',' +
                        inttostr(self.pnlTree.Width) + ',' +
                        inttostr(self.pnlMagListView.Height) + ',' +
                        inttostr(self.pnlAbsPreview.Width) + ',' +
                        inttostr(self.Mag4Vgear1.Height) + ',';
                *)
        Continue;
      End;

      If MagPiece(t[i], '^', 1) = 'IVERIFY' Then
      Begin
        Upref.VerifyStyle := MagStrToInt(MagPiece(t[i], '^', 2));
        Upref.VerifyPos.Left := MagStrToInt(MagPiece(t[i], '^', 3));
        Upref.VerifyPos.Top := MagStrToInt(MagPiece(t[i], '^', 4));
        Upref.VerifyPos.Right := MagStrToInt(MagPiece(t[i], '^', 5));
        Upref.VerifyPos.Bottom := MagStrToInt(MagPiece(t[i], '^', 6));
        Upref.VerifyShowReport := Magstrtobool(MagPiece(t[i], '^', 7));
        Upref.VerifyShowInfo := Magstrtobool(MagPiece(t[i], '^', 8));
        Upref.VerifyHideQFonSearch := Magstrtobool(MagPiece(t[i], '^', 9));
        Upref.VerifySingleView := Magstrtobool(MagPiece(t[i], '^', 10));
        s := MagPiece(t[i], '^', 11); //+ ',,,,,'; // This  "+',,,,,';" was here.  Took out in p93t8
        Upref.VerifyColWidths := s;
        Upref.VerifyControlPos := MagPiece(t[i], '^', 12);
//94t10 fix Abs Preveiw upref settings not staying
(*                GSess.Is93rookie := (UPREF.VerifyControlPos = '');
                if GSess.Is93rookie then
                  BEGIN
                  { here we know that the user is a first time user of 93 client.}

                  END;  *)
        Continue
      End;

      If MagPiece(t[i], '^', 1) = 'IEDIT' Then
      Begin
        Upref.EditStyle := MagStrToInt(MagPiece(t[i], '^', 2)); //         inttostr()
        Upref.EditPos.Left := MagStrToInt(MagPiece(t[i], '^', 3)); //          + '^' + inttostr()
        Upref.EditPos.Top := MagStrToInt(MagPiece(t[i], '^', 4)); //         + '^' + inttostr()
        Upref.EditPos.Right := MagStrToInt(MagPiece(t[i], '^', 5)); //         + '^' + inttostr()
        Upref.EditPos.Bottom := MagStrToInt(MagPiece(t[i], '^', 6)); //       + '^' + inttostr());
        Continue;
      End;

      If MagPiece(t[i], '^', 1) = 'MAIN' Then
      Begin
        Upref.Mainstyle := Strtoint(MagPiece(t[i], '^', 2));
        Upref.Mainpos.Left := Strtoint(MagPiece(t[i], '^', 3));
        Upref.Mainpos.Top := Strtoint(MagPiece(t[i], '^', 4));
        Upref.Mainpos.Right := Strtoint(MagPiece(t[i], '^', 5));
        Upref.Mainpos.Bottom := Strtoint(MagPiece(t[i], '^', 6));
        Upref.Maintoolbar := (MagPiece(t[i], '^', 7) = '1');
        Upref.Mainshowhint := (MagPiece(t[i], '^', 8) = '1');
        Upref.Getmain := True;
        Continue;
      End;
      If MagPiece(t[i], '^', 1) = 'ABS' Then
      Begin
        Upref.AbsStyle := Strtoint(MagPiece(t[i], '^', 2));
        Upref.AbsPos.Left := Strtoint(MagPiece(t[i], '^', 3));
        Upref.AbsPos.Top := Strtoint(MagPiece(t[i], '^', 4));
        Upref.AbsPos.Right := Strtoint(MagPiece(t[i], '^', 5));
        Upref.AbsPos.Bottom := Strtoint(MagPiece(t[i], '^', 6));
                {   abswidth ,height won't be used anymore, Row Col will
                    be saved and MaxLoad also.}
        Upref.AbsWidth := Strtoint(MagPiece(t[i], '^', 7));
        Upref.AbsHeight := Strtoint(MagPiece(t[i], '^', 8));
        Upref.AbsShowWindow := (MagPiece(t[i], '^', 9) = '1');
                {   ; $P9 = TOOLBAR^COLS^MAXLOAD^ ROWS^LOCKSIZE{}
        Upref.AbsToolBar := (MagPiece(t[i], '^', 10) = '1');
        Upref.AbsCols := Strtoint(MagPiece(t[i], '^', 11));
        Upref.AbsMaxLoad := Strtoint(MagPiece(t[i], '^', 12));
        If Upref.AbsMaxLoad < 24 Then
          Upref.AbsMaxLoad := 24;
        Upref.AbsRows := Strtoint(MagPiece(t[i], '^', 13));
        Upref.AbsLockSize := True; { Keeping LockSize always for abstracts }
                    //(magpiece(t[i], '^', 14) = '1');
        Upref.AbsToolBarPos := MagStrToInt(MagPiece(t[i], '^', 15));
        Upref.Getabs := True;
        Continue;
      End;
      If (MagPiece(t[i], '^', 1) = 'EKG') Then
      Begin
        Upref.Musestyle := Strtoint(MagPiece(t[i], '^', 2));
        Upref.Musepos.Left := Strtoint(MagPiece(t[i], '^', 3));
        Upref.Musepos.Top := Strtoint(MagPiece(t[i], '^', 4));
        Upref.Musepos.Right := Strtoint(MagPiece(t[i], '^', 5));
        Upref.Musepos.Bottom := Strtoint(MagPiece(t[i], '^', 6));
        Upref.Showmuse := (MagPiece(t[i], '^', 7) = '1');
        Upref.Getmuse := True;
        Continue;
      End;
      If (MagPiece(t[i], '^', 1) = 'NOTES') Then
      Begin
        Upref.Notesstyle := Strtoint(MagPiece(t[i], '^', 2));
        Upref.Notespos.Left := Strtoint(MagPiece(t[i], '^', 3));
        Upref.Notespos.Top := Strtoint(MagPiece(t[i], '^', 4));
        Upref.Notespos.Right := Strtoint(MagPiece(t[i], '^', 5));
        Upref.Notespos.Bottom := Strtoint(MagPiece(t[i], '^', 6));
        Upref.Shownotes := (MagPiece(t[i], '^', 7) = '1');
        Upref.Getnotes := True;
        Continue;
      End;
      If MagPiece(t[i], '^', 1) = 'GROUP' Then
      Begin
        Upref.Grpstyle := Strtoint(MagPiece(t[i], '^', 2));
        Upref.Grppos.Left := Strtoint(MagPiece(t[i], '^', 3));
        Upref.Grppos.Top := Strtoint(MagPiece(t[i], '^', 4));
        Upref.Grppos.Right := Strtoint(MagPiece(t[i], '^', 5));
        Upref.Grppos.Bottom := Strtoint(MagPiece(t[i], '^', 6));
        Upref.Grpabswidth := Strtoint(MagPiece(t[i], '^', 7));
        Upref.Grpabsheight := Strtoint(MagPiece(t[i], '^', 8));
        Upref.GrpShowWindow := (MagPiece(t[i], '^', 9) = '1');

                //; $P9 = TOOLBAR^COLS^MAXLOAD^ ROWS^LOCKSIZE
        Upref.Grptoolbar := (MagPiece(t[i], '^', 10) = '1');
        Upref.GrpCols := Strtoint(MagPiece(t[i], '^', 11));
        Upref.GrpMaxLoad := Strtoint(MagPiece(t[i], '^', 12));
        Upref.GrpRows := Strtoint(MagPiece(t[i], '^', 13));
        Upref.GrpLockSize := (MagPiece(t[i], '^', 14) = '1');
        Upref.GrpToolBarPos := MagStrToInt(MagPiece(t[i], '^', 15));

        Upref.Getgroup := True;
        Continue;
      End;
      If MagPiece(t[i], '^', 1) = 'FULL' Then
      Begin
        Upref.Fullstyle := Strtoint(MagPiece(t[i], '^', 2));
        Upref.Fullpos.Left := Strtoint(MagPiece(t[i], '^', 3));
        Upref.Fullpos.Top := Strtoint(MagPiece(t[i], '^', 4));
        Upref.Fullpos.Right := Strtoint(MagPiece(t[i], '^', 5));
        Upref.Fullpos.Bottom := Strtoint(MagPiece(t[i], '^', 6));

        Upref.Fullimagewidth := Strtoint(MagPiece(t[i], '^', 7));
        Upref.Fullimageheight := Strtoint(MagPiece(t[i], '^', 8));
                //; $P9 = TOOLBAR^COLS^MAXLOAD^ ROWS^LOCKSIZE
        Upref.Fulltoolbar := (MagPiece(t[i], '^', 10) = '1');
        Upref.FullCols := Strtoint(MagPiece(t[i], '^', 11));
        Upref.FullMaxLoad := Strtoint(MagPiece(t[i], '^', 12));
                {    In 93 we changed from a hardcoded minimum MaxLoad value of 9, to 2 }
        If Upref.FullMaxLoad < 2 Then
          Upref.FullMaxLoad := 2;

        Upref.FullRows := Strtoint(MagPiece(t[i], '^', 13));
        Upref.FullLockSize := (MagPiece(t[i], '^', 14) = '1');
        Upref.FullFitMethod := Strtoint(MagPiece(t[i], '^', 15));
        Upref.FullControlPos := MagPiece(t[i], '^', 16);
        Upref.Getfull := True;
        Continue;
      End;
      If MagPiece(t[i], '^', 1) = 'IMAGEGRID' Then
      Begin
        Upref.ImageListWinstyle := Strtoint(MagPiece(t[i], '^', 2));
        Upref.ImageListWinpos.Left := Strtoint(MagPiece(t[i], '^', 3));
        Upref.ImageListWinpos.Top := Strtoint(MagPiece(t[i], '^', 4));
        Upref.ImageListWinpos.Right := Strtoint(MagPiece(t[i], '^', 5));
        Upref.ImageListWinpos.Bottom := Strtoint(MagPiece(t[i], '^', 6));
        Upref.ShowImageListWin := (MagPiece(t[i], '^', 7) = '1');
                //s := magpiece(t[i], '^', 8) + ',,,,,';
        s := MagPiece(t[i], '^', 8); // + ',,,,,';  Took out ',,,,' in P93t13
        While Copy(s, Length(s), 1) = ',' Do
          s := Copy(s, 1, Length(s) - 1); // added this in p93t13.

        Upref.ImageListWincolwidths := s;
        Upref.ImageListToolbar := (MagPiece(t[i], '^', 9) = '1');
        Upref.GetImageListWin := True;
        Continue;
      End;
      If (MagPiece(t[i], '^', 1) = 'RADLISTWIN') Then
      Begin
        Upref.RadListWinstyle := Strtoint(MagPiece(t[i], '^', 2));
        Upref.RadListWinpos.Left := Strtoint(MagPiece(t[i], '^', 3));
        Upref.RadListWinpos.Top := Strtoint(MagPiece(t[i], '^', 4));
        Upref.RadListWinpos.Right := Strtoint(MagPiece(t[i], '^', 5));
        Upref.RadListWinpos.Bottom := Strtoint(MagPiece(t[i], '^', 6));
        Upref.ShowRadListWin := (MagPiece(t[i], '^', 7) = '1');
        Upref.GetRadListWin := True;
        Continue;
      End;

      If (MagPiece(t[i], '^', 1) = 'DICOMWIN') Then
      Begin
        Upref.Dicomstyle := MagStrToInt(MagPiece(t[i], '^', 2));
        Upref.Dicompos.Left := MagStrToInt(MagPiece(t[i], '^', 3));
        Upref.Dicompos.Top := MagStrToInt(MagPiece(t[i], '^', 4));
        Upref.Dicompos.Right := MagStrToInt(MagPiece(t[i], '^', 5));
        Upref.Dicompos.Bottom := MagStrToInt(MagPiece(t[i], '^', 6));
                {   Next are from Patch 72}
        If Maglength(t[i], '^') >= 17 Then
        Begin

          Upref.DicomScrollSpeed := MagStrToInt(MagPiece(t[i], '^', 7));
          Upref.DicomCineSpeed := MagStrToInt(MagPiece(t[i], '^', 8));
          Upref.DicomStackPaging := MagStrToInt(MagPiece(t[i], '^', 9));
          Upref.DicomLayoutSettings := MagStrToInt(MagPiece(t[i], '^', 10));
          Upref.DicomStackPageTogether := Magstrtobool(MagPiece(t[i], '^', 11));
          Upref.DicomShowOrientationLabels := Magstrtobool(MagPiece(t[i], '^', 12));
          Upref.DicomShowPixelValues := Magstrtobool(MagPiece(t[i], '^', 13));
          Upref.DicomMeasureColor := MagStrToInt(MagPiece(t[i], '^', 14)); {Hex String ? }
          Upref.DicomMeasureLineWidth := MagStrToInt(MagPiece(t[i], '^', 15));
          Upref.DicomMeasureUnits := MagPiece(t[i], '^', 16);
          Upref.DicomDeviceOptionsWinLev := MagStrToInt(MagPiece(t[i], '^', 17));

        End
        Else
        Begin
                    // JMW 4/28/08 P72 - default values if none are in database
          Upref.DicomStackPaging := 2;
          Upref.DicomLayoutSettings := 2;
          Upref.DicomStackPageTogether := True;
          Upref.DicomShowOrientationLabels := True;
          Upref.DicomShowPixelValues := False;
          Upref.DicomDeviceOptionsWinLev := 2;
        End;

        // JMW 4/26/2013 P131 User Preferences for Scout Lines
        If Maglength(t[i], '^') >= 19 Then
        begin
          Upref.DicomDisplayScoutLines := Magstrtobool(MagPiece(t[i], '^', 18));
          Upref.DicomDisplayScoutWindow := Magstrtobool(MagPiece(t[i], '^', 19));
        end
        else
        begin
          // JMW 4/26/2013 P131 Default Scout Line Preferences values
          Upref.DicomDisplayScoutLines := true;
          Upref.DicomDisplayScoutWindow := true;
        end;
        // JMW 5/22/2013 P131 - user preference for scout line color
        if Maglength(t[i], '^') >= 20 then
        begin
          Upref.DicomScoutLineColor := strtoint(MagPiece(t[i], '^', 20));
        end
        else
        begin
          Upref.DicomScoutLineColor := 0;
        end;
                {  end new properties for dicom win for Patch 72}
        Upref.Getdicom := True;
        Continue;
      End;

      If MagPiece(t[i], '^', 1) = 'REPORT' Then
      Begin

        Upref.Reportstyle := Strtoint(MagPiece(t[i], '^', 2));
        Upref.Reportpos.Left := Strtoint(MagPiece(t[i], '^', 3));
        Upref.Reportpos.Top := Strtoint(MagPiece(t[i], '^', 4));
        Upref.Reportpos.Right := Strtoint(MagPiece(t[i], '^', 5));
        Upref.Reportpos.Bottom := Strtoint(MagPiece(t[i], '^', 6));
        Upref.Reportfont.Name := MagPiece(t[i], '^', 7);
        Upref.Reportfont.Style := []; {strtoint(magpiece(t[i],'^',8));}
        Upref.Reportfont.Size := Strtoint(MagPiece(t[i], '^', 9));
        Upref.Getreport := True;
        Continue;
      End;

            // JMW 7/1/2005 p45 User Preferences for RIV
      If MagPiece(t[i], '^', 1) = 'RIVER' Then
      Begin
        Upref.RIVAutoConnectEnabled := Magstrtobool(MagPiece(t[i], '^', 2));
        Upref.RIVAutoConnectVISNOnly := Magstrtobool(MagPiece(t[i], '^', 3));
        Upref.RIVHideEmptySites := Magstrtobool(MagPiece(t[i], '^', 4));
        Upref.RIVHideDisconnectedSites := Magstrtobool(MagPiece(t[i], '^', 5));
        Upref.RIVAutoConnectDoD        := Magstrtobool(MagPiece(t[i], '^', 6)); {/ P117 NCAT - JK 12/15/2010 /}
      End;

      {/ P122 - JK 6/6/2011 /}
      If (MagPiece(t[i], '^', 1) = 'ANNOTDISPLAY') and (MagLength(t[i],'^') > 1 ) Then
      Begin
//        AnnotationOptionsX.UserPreferences := t[I];     // p122 dmmn 7/11/11 - add user preference for annotation
        Upref.ArtXSettingsDisplay := frmAnnotOptionsX.UserPreferences;
        //p122 dmmn 8/3/11 - new pref calls
        frmAnnotOptionsX.FontName := MagPiece(t[i], '^', 2);
        frmAnnotOptionsX.FontStyle := MagStrToInt(MagPiece(t[i], '^', 3));
        frmAnnotOptionsX.FontSize := MagStrToInt(MagPiece(t[i], '^', 4));
        frmAnnotOptionsX.LineWidth := MagStrToInt(MagPiece(t[i], '^', 5));
        frmAnnotOptionsX.AnnotLineColor := MagStrToInt(MagPiece(t[i], '^', 6));
        frmAnnotOptionsX.Opacity := MagStrToInt(MagPiece(t[i], '^', 7));
        frmAnnotOptionsX.ArrowPointerStyle := MagStrToInt(MagPiece(t[i], '^', 8));
        frmAnnotOptionsX.ArrowPointerLength := MagStrToInt(MagPiece(t[i], '^', 9));
        frmAnnotOptionsX.ArrowPointerAngle := MagStrToInt(MagPiece(t[i], '^', 10));
//        AnnotationOptionsX.Left := MagStrToInt(MagPiece(t[i], '^', 11));
//        AnnotationOptionsX.Top := MagStrToInt(MagPiece(t[i], '^', 12));
        frmAnnotOptionsX.AutoShowAnnots := MagPiece(t[i], '^', 13);
      End;

      {/p122 dmmn 8//3/11 - in case we want to let user change settings for showing rad annotations /}
//   These next are commented out in 122 T10. (gek)
//      if (MagPiece(t[i],'^',1) = 'ANNOTDISPLAYRAD') then
//      begin
//        AnnotationOptionsX.StrictRAD := MagPiece(t[i], '^',2);
//        AnnotationOptionsX.RADFontName := MagPiece(t[i], '^',3);
//        AnnotationOptionsX.RADFontStyle := MagStrToInt(MagPiece(t[i], '^',4));
//        AnnotationOptionsX.RADFontSize := MagStrToInt(MagPiece(t[i], '^',5));
//        AnnotationOptionsX.RADLineWidth := MagStrToInt(MagPiece(t[i], '^',6));
//        AnnotationOptionsX.RADColor := MagStrToInt(MagPiece(t[i], '^',7));
//        AnnotationOptionsX.RADOpacity := MagStrToInt(MagPiece(t[i], '^',8));
//      end;

    Except
      On e: Exception Do
      Begin
              //maggmsgf.MagMsg('s', 'Error Setting User Preferences: ' + ' ' + t[i] + ' ' + e.message, nilpanel);
        MagAppMsg('s', 'Error Setting User Preferences: ' + ' ' + t[i] + ' ' + e.Message); {JK 10/5/2009 - Maggmsgu refactoring}
      End;
    End; {except}
  End; {for loop}
//94t10 gek
(*    if GSess.Is93rookie  then
      begin
      {     height of Full Res panel in IListWin}
      maginsertpiece(upref.StyleControlPos,'^',10,'400');
      {     CoolBand 0 Break}
      maginsertpiece(upref.StyleControlPos,'^',11,'0');
      {     CoolBand 1 Break}
      maginsertpiece(upref.StyleControlPos,'^',12,'1');
      {     CoolBand 2 Break}
      maginsertpiece(upref.StyleControlPos,'^',13,'1');
      {     Image Toolbar visible}
      maginsertpiece(upref.StyleControlPos,'^',14,'1');
      {     For first time users, keep the window clear, un cluttered.}
      upref.ImageListPrevAbs := FALSE;
      upref.ImageListPrevReport := FALSE;
      upref.ImageListDefautFilter := '';
      upref.ImageListFilterAsTabs := TRUE;
      upref.ImageListMultiLineTabs := FALSE;

      end;  *)
End;

End.
