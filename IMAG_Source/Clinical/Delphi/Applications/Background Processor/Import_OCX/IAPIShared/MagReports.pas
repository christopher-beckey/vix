Unit MagReports;
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
Uses Stdctrls,
  SysUtils,
  Controls,
  WinTypes,
  WinProcs,
  Messages,
  Classes,
  Graphics,
  Forms,
  Dialogs,
  Grids,
  Menus,
  ExtCtrls

  ,
  Maggut1,
  Maggmsgu,
  cMagDBBroker, {magbroker,}
  Trpcb,
  Maggut4,
  Maggrpcu,
  DmSingle;

Procedure StripControlCharacters(t: Tstringlist);
Procedure BuildReport(Ien, Reportdesc, Title: String; Rptmemo: TMemo = Nil);
Procedure ShowReport(Var Upref: Tuserpreferences; Var t: Tstringlist; Reportdesc, Reporttitle: String; Rptmemo: TMemo = Nil);
Procedure DemoReport(Ien: String; Var t: Tstringlist);
Procedure UprefToReport(Var Upref: Tuserpreferences; Reportwin: TMaggrpcf);

Implementation

Procedure UprefToReport(Var Upref: Tuserpreferences; Reportwin: TMaggrpcf);
Begin
//with frmMain do
//begin
  If Not Upref.Getreport Then
  Begin
    Reportwin.Show;
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
  Reportwin.SetBounds(Upref.Reportpos.Left, Upref.Reportpos.Top, Upref.Reportpos.Right, Upref.Reportpos.Bottom);
  Reportwin.Memo1.Font := Upref.Reportfont;
  Reportwin.Show;
//end;
End;

Procedure BuildReport(Ien, Reportdesc, Title: String; Rptmemo: TMemo = Nil);
Var
  t: Tstringlist;

  Pat: String;

Var
  Rmsg: String;
  Rlist: TStrings;
  Rstat: Boolean;
Begin
  Rlist := Tstringlist.Create;
  t := Tstringlist.Create;
  Try

    Maggmsgf.MagMsg('s', 'Building report for IEN : ' + Ien + '  ' + Reportdesc, Nilpanel);

    Dmod.MagDBBroker1.RPMagGetImageReport(Rstat, Rmsg, Rlist, Ien);
(* P8T21  I commented this out,  I think this was done when RPC went to MagDBBroker
  if not rstat then
   begin
   maggmsgf.magmsg('DE',rmsg);
   exit;
   end;  *)

(*      xBrokerx.Param[0].Value := ien + '^';
      xBrokerx.Param[0].PType := literal;
      xBrokerx.re moteprocedure := 'MAGGRPT';
      maggmsgf.magmsg('', 'Building Image Report...', nilpanel);
      xBrokerx.lstcall(t);

    if t.count = 0 then
    begin
      maggmsgf.magmsg('DE', ': The Attempt to build the Image report Failed. Check VISTA Error Log.', nilpanel);
      maggmsgf.magmsg('s', ' Report Failed for Image IEN: '+ien,nilpanel);
      maggmsgf.magmsg('', '', nilpanel);
      exit;
    end;
*)
    ;
    Pat := MagPiece(Rlist[0], '^', 3);
    If (MagPiece(Rlist[0], '^', 1) = '0') Then
    Begin
      //if (MDIReportmemo <> nil) then
      //begin
      //  t.clear;
      //  showreport(upref, t, s, title + ' - ' + Pat,rptmemo);
      //end
      //else
      //begin
      If (Rptmemo <> Nil) Then
      Begin
        Rptmemo.Lines.Add(' - - - - Report not recieved for Image # ' + Ien + ' - - - - ');
        Rptmemo.Lines.Add(Rmsg);
        Maggmsgf.MagMsg('s', ' Report Failed for Image IEN: ' + Ien, Nilpanel);
      End
      Else
      Begin
        Maggmsgf.MagMsg('D', Rmsg, Nilpanel);
        Maggmsgf.MagMsg('s', ' Report Failed for Image IEN: ' + Ien, Nilpanel);
      End;
       //end;
    End
    Else
      If (MagPiece(Rlist[0], '^', 1) = '-2') {//Patch 5    (*} Then
      Begin
        Maggmsgf.MagMsg('DEQA', MagPiece(Rlist[0], '^', 2), Nilpanel);
        Maggmsgf.MagMsg('s', 'Image IEN in Question: ' + Ien, Nilpanel);
       //
      End //Patch 5  *)
      Else
      Begin
        Rlist.Delete(0);
        t.Assign(Rlist);
        If Dmod.MagPat1.M_UseFakeName Then
        Begin
          MagReplaceStrings(Pat, Dmod.MagPat1.M_FakePatientName, t);
          Pat := Dmod.MagPat1.M_FakePatientName;
        End;

        ShowReport(Upref, t, Rmsg, Title + ' - ' + Pat, Rptmemo);
      End;
  Finally
    t.Free;
    Rlist.Free;
   // maggmsgf.magmsg('', '', nilpanel);
  End;
End;

Procedure ShowReport(Var Upref: Tuserpreferences; Var t: Tstringlist;
  Reportdesc, Reporttitle: String; Rptmemo: TMemo = Nil);
Var
  Usingrprwin: Boolean;
Begin
  Usingrprwin := False;

  If (Rptmemo = Nil) Then
    If Not Doesformexist('maggrpcf') Then
    Begin
      Maggrpcf := TMaggrpcf.Create(Application);
      UprefToReport(Upref, Maggrpcf);
    End;
  StripControlCharacters(t);
  If Rptmemo = Nil Then
  Begin
    Rptmemo := Maggrpcf.Memo1;
    Usingrprwin := True;
  End;
  Rptmemo.Lines.Clear;
  Rptmemo.Lines := t;
  If Usingrprwin Then
  Begin
    Maggrpcf.PDesc.caption := Reportdesc;
    Maggrpcf.caption := Reporttitle; //+ ' ' + reportdesc;
    FormToNormalSize(Maggrpcf);
  End;
End;

Procedure DemoReport(Ien: String; Var t: Tstringlist);
Var
  Rpt, Test: String;
Begin
  Try
    Rpt := MagPiece(Demobaseimagelist[Strtoint(Ien) - 1], '^', 10);
    Test := Demobaseimagelist[Strtoint(Ien) - 1];
    If Rpt = '' Then
      t.Insert(0, '0^No report for this Demo Image')
    Else
    Begin
      If FileExists(Rpt) Then
      Begin
        t.LoadFromFile(Rpt);
        t.Insert(0, '1^Demonstration: Report for Demo image^');
        Exit;
      End;
      If Not FileExists(AppPath + '\' + Rpt) Then
        t.Insert(0, '0^Report for this Demo Image NOT FOUND : ' + Rpt)
      Else
      Begin
        t.LoadFromFile(AppPath + '\' + Rpt);
        t.Insert(0, '1^Demonstration: Report for Demo image^');
      End;
    End;
  Except
    On Exception Do Maggmsgf.MagMsg('', 'Error trying to build report', Nilpanel);
  End;
End;

Procedure StripControlCharacters(t: Tstringlist);
Var
  i, j: Integer;
  s: String;
  Ul: Boolean;
Begin
  For i := 1 To t.Count - 1 Do
  Begin
    Ul := False;
    While (Pos(#8, t[i]) > 0) Do
    Begin
      Ul := True;
      s := t[i];
      j := Pos(#8, t[i]);
      Delete(s, j, 2);
      t[i] := s;
    End;
    If Ul Then
      While (Pos(#95, s) > 0) Do
      Begin
        j := Pos(#95, s);
        Delete(s, j, 2);
        t[i] := s;
      End;

  End;
End;

End.
