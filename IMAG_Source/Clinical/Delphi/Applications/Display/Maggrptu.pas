Unit Maggrptu;
   {
   Package: MAG - VistA Imaging
   WARNING: Per VHA Directive 10-93-142 this unit should not be modified.
   Date Created:    1996
   Site Name: Silver Spring, OIFO
   Developers: Garrett Kirin
   [== unit Maggrptu;
   Description:  VistA Health Summary window :
     -  User can select from a list of Health Summary Reports defined at the Site.
     -  Reports are opened in the Report Window (TMaggrpcf : Maggrpcu.dfm)
      ==]
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
  Buttons,
  Classes,
  ExtCtrls,
  Forms,
  Messages,
  Stdctrls,
  Controls
  , imaginterfaces
  ;

//Uses Vetted 20090929:cMagDBBroker, Outline, Grids, Tabs, Menus, Dialogs, Controls, Graphics, WinProcs, WinTypes, SysUtils, maggrpcu, umagutils, dmSingle, magpositions, maggmsgu

Type
  TMaggrptf = Class(TForm)
    Msg: Tpanel;
    Notebook1: TNotebook;
    HsNameList: TListBox;
    SbHS: TSpeedButton;
    Panel1: Tpanel;
    PatName: Tlabel;
    PatDemog: Tlabel;
    PatDFN: Tlabel;
    HsTypeList: TListBox;
    Edemo: TEdit;
    Demodir: TEdit;
    Panel2: Tpanel;
    Procedure FormCreate(Sender: Tobject);
    Procedure SbHSClick(Sender: Tobject);
    Procedure FormDestroy(Sender: Tobject);
  Private
    {  Maintain a minimum and Maximum size for the window}
    Procedure WMGetMinMaxInfo(Var Message: TWMGetMinMaxInfo); Message WM_GetMinMaxInfo;
  Public
        {       Creates instance of Tmaggrpcf and displays the report in it}
    Procedure LocShowreport(Var t: Tstringlist; Reportdesc, Reporttitle: String);
        {       Load the Sites' list of Health Summary reports}
    Procedure LoadHsTypeList;
  End;

Var
  Maggrptf: TMaggrptf;
  DFN: Integer;

Implementation
Uses
ImagDMinterface, //RCA  DmSingle,  DmSingle,
//RCA  Maggmsgu,
  Maggrpcu,
  Magpositions,
  Umagutils8,
  uMagDefinitions  {/ P122 with P123 patient ID additions - JK 8/11/2011 /}
  ;

//Uses Vetted 20090929:fmagMain
{$R *.DFM}

{     Maintain a minimum and Maximum size for the window}

Procedure TMaggrptf.WMGetMinMaxInfo(Var Message: TWMGetMinMaxInfo);
Var
  Hy, Wx: Integer;
Begin
  Hy := Trunc(255 * (Pixelsperinch / 96));
  Wx := Trunc(355 * (Pixelsperinch / 96));
  With Message.Minmaxinfo^ Do
  Begin
    PtMinTrackSize.x := Wx;
    PtMinTrackSize.y := Hy;
  End;
  Message.Result := 0;
  Inherited;

End;

Procedure TMaggrptf.FormCreate(Sender: Tobject);
Begin
  If (Edemo.Text = 'demo') Then Exit;
  GetFormPosition(Self As TForm);
End;

Procedure TMaggrptf.LoadHsTypeList;
Var
  i: Integer;
  St: String;
  Rmsg: String;
  Tlist: Tstringlist;
  Rstat: Boolean;
Begin
  Tlist := Tstringlist.Create;
  Try
{ TODO -cdemo :make the Health Summary Options in the main menu Disabled for Demo }
    idmodobj.GetMagDBBroker1.RPMaggHSList(Rstat, Rmsg, Tlist, 'hs');
    If Not Rstat Then
    Begin
    //maggmsgf.MagMsg('','ERROR Compiling Health Summary list.');
      MagAppMsg('', 'ERROR Compiling Health Summary list.'); {JK 10/5/2009 - Maggmsgu refactoring}
    //maggmsgf.MagMsg('s',rmsg);
      MagAppMsg('s', Rmsg); {JK 10/5/2009 - Maggmsgu refactoring}
    End
    Else
    Begin
      HsTypeList.Items.Clear;
      HsTypeList.Items.Assign(Tlist);

      HsNameList.Clear;
      For i := 0 To HsTypeList.Items.Count - 1 Do
      Begin
        St := MagPiece(HsTypeList.Items[i], '^', 1);
        HsNameList.Items.Add(St);
      End;
      HsNameList.ItemIndex := 0;
    End;
  Finally
    Tlist.Free;
  End;
End;

Procedure TMaggrptf.SbHSClick(Sender: Tobject);
Var
  Xst, Xst1, Rmsg: String;
  Tlist: Tstringlist;
  Rstat: Boolean;
Begin
  Tlist := Tstringlist.Create;
  Try
    If (HsNameList.ItemIndex = -1) Then
    Begin
    //MaggMsgf.magmsg('', 'Select a Health Summary Type', msg);
      MagAppMsg('', 'Select a Health Summary Type'); {JK 10/5/2009 - Maggmsgu refactoring}
      Exit;
    End;
  //MaggMsgf.magmsg('', 'Building Health Summary', msg);
    MagAppMsg('', 'Building Health Summary'); {JK 10/5/2009 - Maggmsgu refactoring}
    msg.Caption := 'Building Health Summary';
    Msg.Update;
    Xst := MagPiece(HsTypeList.Items[HsNameList.ItemIndex], '^', 2);
    Xst1 := MagPiece(HsTypeList.Items[HsNameList.ItemIndex], '^', 1);
    While Xst1[Length(Xst1)] = ' ' Do
      Xst1 := Copy(Xst1, 1, Length(Xst1) - 1);
  {frmMain.LOGACTIONS('DHCPREPORTS','RPT-HSUMM-'+XST1,PATDFN.CAPTION);}
  { TODO -cdemo : make the Health Summary Options in the main menu Disabled for Demo}
    idmodobj.GetMagDBBroker1.RPMaggHS(Rstat, Rmsg, Tlist, PatDFN.caption + '^' + Xst);
    LocShowreport(Tlist, PatDemog.caption, 'Health Summary   ' + Xst1 + '   ' + PatName.caption);
  //Maggmsgf.MagMsg('', 'Health Summary Complete.', msg);
    MagAppMsg('', 'Health Summary Complete.'); {JK 10/5/2009 - Maggmsgu refactoring}
    Msg.Caption := 'Health Summary Complete.';
    Msg.Update;
  Finally
    Tlist.Free;
  End;
End;

Procedure TMaggrptf.LocShowreport(Var t: Tstringlist; Reportdesc, Reporttitle: String);
Begin
  If Not Doesformexist('maggrpcf') Then Maggrpcf := TMaggrpcf.Create(Self);
  If idmodobj.GetMagPat1.M_UseFakeName Then
  Begin
    MagReplaceStrings(idmodobj.GetMagPat1.M_PatName, idmodobj.GetMagPat1.M_FakePatientName, t);

    {/ P122 with P123 patient ID additions - JK 8/11/2011 /}
    if GSess.Agency.IHS then
    begin
      MagReplaceStrings(idmodobj.GetMagPat1.M_SSN, '000000', t);
      MagReplaceStrings(idmodobj.GetMagPat1.M_SSNdisplay, '000000', t);
      MagReplaceString(idmodobj.GetMagPat1.M_PatName, idmodobj.GetMagPat1.M_FakePatientName, Reporttitle);
    end
    else
    begin
      MagReplaceStrings(idmodobj.GetMagPat1.M_SSN, '000000000', t);
      MagReplaceStrings(idmodobj.GetMagPat1.M_SSNdisplay, '000-00-0000', t);
      MagReplaceString(idmodobj.GetMagPat1.M_PatName, idmodobj.GetMagPat1.M_FakePatientName, Reporttitle);
    end;
  End;
  Maggrpcf.Memo1.Lines.Clear;
  Maggrpcf.Memo1.Lines := t;
  Maggrpcf.PDesc.caption := Reportdesc;
  Maggrpcf.caption := Reporttitle;
  FormToNormalSize(Maggrpcf);
  Maggrpcf.Show;
End;

Procedure TMaggrptf.FormDestroy(Sender: Tobject);
Begin
  SaveFormPosition(Self As TForm);
End;

End.
