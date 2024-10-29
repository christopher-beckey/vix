Unit cMagUtilsDB;

{
   Package: MAG - VistA Imaging
 WARNING: Per VHA Directive 10-93-142 this unit should not be modified.
 Date Created:    Version 3.0.8
 Site Name: Silver Spring, OIFO
 Developers: Garrett Kirin
 [==  unit cMagUtilsDB;
 Description: Imaging DataBase Utilities
 Some functions and methods are used by many Forms (windows) and components of
 the application.  Utility components are designed to be a repository of such
 utility functions used throughout the application.
 Other Compontents that need the methods contained in the utililty components
 can declare a property of that type and have the utility object set at design time.

 TMagUtilsDB:   Designed to be a DataBase Utility component. Methods in this
 component access the DataBase.  example : The TMag4Viewer component does not have
  an association with the DataBase but it has a property MagUtilsDB : TMagUtilsDB,
  and uses the methods of MagUtilsDB object to access the ImageReport function.

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
        ;; a medical device.  As such, it may not be changed
        ;; in any way.  Modifications to this software may result in an
        ;; adulterated medical device under 21CFR820, the use of which
        ;; is considered to be a violation of US Federal Statutes.
        ;; +---------------------------------------------------------------------------------------------------+

*)
Interface

Uses
  Classes,
  cMagDBBroker,
//  cMagLogManager,  {JK 10/5/2009 - Maggmsgu refactoring - deprecated unit}
  Maggmsgu,
  cMagPat,
  cMagUtils,
  Controls,
  Graphics,
  Stdctrls,
  UMagClasses
  ;

//Uses Vetted 20090929:Messages, umagdefinitions, fmagGetEsigDialog, umagutils, maggrpcu, geardef, fmagCopyAgreement, printers, cMag4VGear, Dialogs, Forms, SysUtils, Windows

Type
  TMagUtilsDB = Class(TComponent)
  Private
    FDBBroker: TMagDBBroker;
    FMagUtils1: TMagUtils;
    FMagpat: TMag4Pat;
    //FOnLogEvent : TMagLogEvent;  {JK 10/5/2009 - Maggmsgu refactoring}
    Function Doesformexist(s: String): Boolean;
    Procedure PrintFooter;
    Procedure PrintHeader(HeaderL, HeaderR: String);
    Procedure PrintTopSpacing(Lines, Texth, HorzM: Integer; Var CurLine: Integer);
 //   function GetEsigDialog(var xmsg : string): boolean;
   // procedure LogMsg(MsgType : String; Msg : String; Priority : TMagLogPriority = MagLogINFO);  {JK 10/6/2009 - Maggmsgu refactoring - remove old method}

  Protected
  Public
    Constructor Create(AOwner: TComponent); Override;
    Destructor Destroy; Override;
    {       Displays the Reason Dialog Box, Returns True if reason is selected.}
    Function GetEsigDialog(Var Xmsg: String): Boolean;
    Function GetReason(Rcode: Integer; Var Reason: String): Boolean;
    {       Displays a dialog window to allow the user to enter a reason and Electronic signature.}
    Function GetEsig(Var Xmsg: String): Boolean;
    {       Prompts user for printer, Prints the Image to selected printer}
    Procedure ImagePrint(MagVGear: Tobject; Var Stat: Boolean; Var Xmsg: String);
    {       Copies Image to the Clipboard}
    Procedure ImageCopy(MagVGear: Tobject; Var Stat: Boolean; Var Xmsg: String; skiplog: Boolean = False);
    {       Retrieves Image report from DataBase and displays it in instance of Form: Maggrpcf
                Magien : Image IEN
                if rptmemo <> nil, the report will be inserted there instead.}
//    procedure ImageReport(magien: String; var stat: boolean; var xmsg: String; rptmemo: TMemo = nil; noQACheck : boolean = false); overload;
    {       Retrieves Image report from DataBase and displays it in instance of Form: Maggrpcf
                Iobj : has the Image IEN as a Property
                if rptmemo <> nil, the report will be inserted there instead.}
    Procedure ImageReport(IObj: TImageData; Var Stat: Boolean; Var Xmsg: String; Rptmemo: TMemo = Nil; NoQAcheck: Boolean = False); Overload;
    {       Prints a TEXT file to printer}
    Procedure ImageTextFilePrint(IObj: TImageData; Txt: TStrings; XHeader: String);
    {       Copies a TEXT file to the clipboard.}
    Procedure ImageTextFileCopy(IObj: TImageData; Memo: TMemo; XHeader: String);
    {       Displays the Patient profile report from VistA in instance of Form: Maggrpcf}
    Procedure OpenPatientProfile;
    {       Opens a Radiology report in instance of Form : Maggrpcf
                User has clicked on an entry in Radiology Exam List window
                str : string of radiology data that is returned by Radiology API when
                imaging builds the list of radiology reports.}
    Procedure RadiologyExamReport(Str: String);
    {       Opens the report in in instance of Form: Maggrpcf
                t: contains the report.
                if rptmemo <> nil, the report will be inserted there instead.}
    Procedure ShowReport(t: TStrings; Reportdesc, Reporttitle: String; Rptmemo: TMemo = Nil);
  Published
    {       DataBase broker.  All roads to the DataBase go through here.}
    Property MagBroker: TMagDBBroker Read FDBBroker Write FDBBroker;
    {       Patient Object}
    Property MagPat: TMag4Pat Read FMagpat Write FMagpat;

    //property OnLogEvent : TMagLogEvent read FOnLogEvent write FOnLogEvent;  {JK 10/5/2009 - Maggmsgu refactoring}
  End;

Procedure Register;

Implementation

Uses
  Dialogs,
  Forms,
  Printers,
  SysUtils,
  //imaging
  FmagCopyAgreement,
  FmagGetEsigDialog,
  cMag4Vgear,
  Geardef,
  Maggrpcu,
  UMagDefinitions,
  Umagkeymgr,
  Umagutils8,
  Windows
  ;

{JK 10/6/2009 - Maggmsgu refactoring - remove old method}
//procedure TMagUtilsDB.LogMsg(MsgType : String; Msg : String; Priority : TMagLogPriority = MagLogINFO);
//begin
//  if assigned(OnLogEvent) then
//    OnLogEvent(self, MsgType, Msg, Priority);
//end;

Procedure TMagUtilsDB.RadiologyExamReport(Str: String);
Var
  t: Tstringlist;
  DayCase: String[30];
  Raddesc: String;
  Rptdate: String[12];
  Rarpt: String;
  Rstat: Boolean;
  Rmsg: String;
Begin
  t := Tstringlist.Create;
  Try
    // TEMP := tradlist[strtoint(s)];
    DayCase := FMagUtils1.MagPiece(Str, '^', 2);
    Raddesc := FMagUtils1.MagPiece(Str, '^', 3);
    Rptdate := FMagUtils1.MagPiece(Str, '^', 4);
    Rarpt := FMagUtils1.MagPiece(Str, '^', 16);
    //LogActions('RADEXAM', 'REPORT', daycase);
    //LogMsg('', daycase + '   ' + raddesc + '   ' + rptdate);
    MagLogger.LogMsg('', DayCase + '   ' + Raddesc + '   ' + Rptdate); {JK 10/6/2009 - Maggmsgu refactoring}
    FDBBroker.RPMaggRadReport(Rstat, Rmsg, t, Rarpt);
    If Not Rstat Then
    Begin
      If FMagUtils1.MagPiece(t[0], '^', 1) = '-2' Then
        //LogMsg('DEQA', rmsg)
        MagLogger.LogMsg('DEQA', Rmsg) {JK 10/6/2009 - Maggmsgu refactoring}
      Else
        //LogMsg('de', rmsg);
        MagLogger.LogMsg('de', Rmsg); {JK 10/6/2009 - Maggmsgu refactoring}
      //LogMsg('s', 'RARPT: ' + RARPT + 'daycase: ' + daycase);
      MagLogger.LogMsg('s', 'RARPT: ' + Rarpt + 'daycase: ' + DayCase); {JK 10/6/2009 - Maggmsgu refactoring}
      Exit
    End;
    If FMagpat.M_UseFakeName Then
    Begin
      MagReplaceStrings(FMagpat.M_PatName, FMagpat.M_NameDisplay, t);
      MagReplaceStrings(FMagpat.M_SSN, '000000000', t);
      MagReplaceStrings(FMagpat.M_SSNdisplay, '000-00-0000', t);
      MagReplaceString(FMagpat.M_PatName, FMagpat.M_NameDisplay, Raddesc);
      MagReplaceString(FMagpat.M_SSN, '000000000', Raddesc);
      MagReplaceString(FMagpat.M_SSNdisplay, '000-00-0000', Raddesc)
    End;
    t.Delete(0);
    //LogMsg('', 'REPORT ' + daycase + '   ' + raddesc + '.  Done.');
    MagLogger.LogMsg('', 'REPORT ' + DayCase + '   ' + Raddesc + '.  Done.'); {JK 10/6/2009 - Maggmsgu refactoring}
    ShowReport(t, DayCase + '   ' + Raddesc + '   ' + Rptdate, 'Radiology Report' + ' - ' + FMagpat.M_NameDisplay)
  Finally
    t.Free
  End;
End;

Procedure TMagUtilsDB.OpenPatientProfile;
Var
  Rmsg: String;
  Rlist: Tstringlist;
  Rstat: Boolean;
Begin
  Rlist := Tstringlist.Create;

  Try
    If (FMagpat.M_DFN = '') Then
    Begin
      //LogMsg('d', 'You must first select a Patient ');
      MagLogger.LogMsg('d', 'You must first select a Patient '); {JK 10/6/2009 - Maggmsgu refactoring}
      Exit
    End;
    //LogMsg('', 'Building Patient Profile...');
    MagLogger.LogMsg('', 'Building Patient Profile...'); {JK 10/6/2009 - Maggmsgu refactoring}
    FDBBroker.RPMaggDGRPD(Rstat, Rmsg, Rlist, FMagpat.M_DFN);
    If Not Rstat Then
    Begin
      //LogMsg('de', rmsg);
      MagLogger.LogMsg('de', Rmsg); {JK 10/6/2009 - Maggmsgu refactoring}
      Exit
    End;
    If FMagpat.M_UseFakeName Then
    Begin
      MagReplaceStrings(FMagpat.M_PatName, FMagpat.M_FakePatientName, Rlist);
      MagReplaceStrings(FMagpat.M_SSN, '000000000', Rlist);
      MagReplaceStrings(FMagpat.M_SSNdisplay, '000-00-0000', Rlist)
    End;
    ShowReport(Rlist, FMagpat.M_Demog, 'Patient Profile - ' + FMagpat.M_NameDisplay);
    //LogMsg('', FMagPat.M_NameDisplay + ', Patient Profile Complete.')
    MagLogger.LogMsg('', FMagpat.M_NameDisplay + ', Patient Profile Complete.') {JK 10/6/2009 - Maggmsgu refactoring}
  Finally
    Rlist.Free
  End;
End;

// JMW 3/17/2005 p45 This function needs to be killed, it will not work with RIV
{
procedure TMagUtilsDB.ImageReport(magien: String; var stat: boolean; var xmsg: String; rptmemo: TMemo = nil; noQACheck : boolean = false);
var
  IObj: TImageData;
begin
  IObj := TImageData.Create;
  IObj.Mag0 := magien;
  ImageReport(IObj, stat, xmsg, rptmemo);
  IObj.Free
end;
 }

Procedure TMagUtilsDB.ImageReport(IObj: TImageData; Var Stat: Boolean; Var Xmsg: String; Rptmemo: TMemo = Nil; NoQAcheck: Boolean = False);
//procedure BuildReport(ien, reportdesc, title: string; rptmemo : TMemo = nil);
Var //t : tstringlist;
  Pat: String;
  Flist: TStrings;
  FFlist: Tstringlist;
Begin

  {/ P117 NCAT - JK 1/11/2011 /}
  if IObj.ImgType = 501 then
    if UserHasKey('MAG REVIEW NCAT') = False then
    begin
      MagLogger.LogMsg('DI', 'You are not authorized to view NCAT documents', MagLogINFO);
      Exit;
    end;

  //t := tstringlist.create;  need later when all report functionality is
  //                moved to this component
  Flist := Tstringlist.Create;
  FFlist := Tstringlist.Create;
  Try
    If Not FDBBroker.IsConnected Then
    Begin
      Stat := False;
      Xmsg := 'No Connection to VistA.'
    End;
    FDBBroker.RPImageReport(Stat, Xmsg, Flist, IObj, NoQAcheck);
    If Not Stat Then
    Begin
      If (Rptmemo <> Nil) Then
      Begin
        Rptmemo.Lines.Add(' ----- Report not received for Image # ' + IObj.Mag0 + ' ----- ');
        Rptmemo.Lines.Add(Xmsg);
        //LogMsg('s', ' Report Failed for Image IEN: ' + IObj.Mag0)
        MagLogger.LogMsg('s', ' Report Failed for Image IEN: ' + IObj.Mag0) {JK 10/6/2009 - Maggmsgu refactoring}
      End
      Else
        //LogMsg('d', xmsg);
        MagLogger.LogMsg('d', Xmsg); {JK 10/6/2009 - Maggmsgu refactoring}
      //LogMsg('s', '  Report Failed for Image IEN: ' + IObj.Mag0);
      MagLogger.LogMsg('s', '  Report Failed for Image IEN: ' + IObj.Mag0); {JK 10/6/2009 - Maggmsgu refactoring}
      Exit
    End;
    Pat := FMagUtils1.MagPiece(Flist[0], '^', 3);
    If (FMagUtils1.MagPiece(Flist[0], '^', 1) = '-2') {//Patch 5} Then
    Begin
      //LogMsg('DEQA', FMagUtils1.magpiece(Flist[0], '^', 2));
      MagLogger.LogMsg('DEQA', FMagUtils1.MagPiece(Flist[0], '^', 2)); {JK 10/6/2009 - Maggmsgu refactoring}
      //LogMsg('s', 'Image IEN in Question: ' + IObj.Mag0)
      MagLogger.LogMsg('s', 'Image IEN in Question: ' + IObj.Mag0) {JK 10/6/2009 - Maggmsgu refactoring}
    End
    Else
    Begin
      Flist.Delete(0);
      FFlist.Assign(Flist);
      If FMagpat.M_UseFakeName Then
      Begin
        MagReplaceStrings(FMagpat.M_PatName, FMagpat.M_NameDisplay, FFlist);
        MagReplaceStrings(FMagpat.M_SSN, '000000000', FFlist);
        MagReplaceStrings(FMagpat.M_SSNdisplay, '000-00-0000', FFlist);
        Pat := FMagpat.M_NameDisplay
      End;
      ShowReport(FFlist, Xmsg, 'Image Report' + ' - ' + Pat, Rptmemo)
    End;

  Finally
    Flist.Free;
    FFlist.Free
  End;
End;

Procedure TMagUtilsDB.ImagePrint(MagVGear: Tobject; Var Stat: Boolean; Var Xmsg: String);
Var
  VGear: TMag4VGear;
  Printmsg: String;
  Myprintdialog: TPrintDialog;
  Reason: String;
  i, y: Integer;
Begin
  Stat := False; //
  //if GetEsig(xmsg) then //TODO ESIG
  Begin
    Stat := True;
    VGear := TMag4VGear(MagVGear);
    (* Add SSN Take out Image IEN
    printmsg := vGear.PI_ptrData.PtName + ' ' + vGear.PI_ptrData.ExpandedIDDescription(false);*)
    Printmsg := VGear.PI_ptrData.PtName + ' ' + VGear.PI_ptrData.SSN + ' ' + VGear.PI_ptrData.ExpandedDescription(False);
    Myprintdialog := TPrintDialog.Create(Self);
    Screen.Cursor := crHourGlass;
    Try
      Myprintdialog.Options := [PoPageNums];
      Myprintdialog.MinPage := 1;
      Myprintdialog.MaxPage := VGear.PageCount; // vGear.Gear1.pagecount;
      Myprintdialog.FromPage := 1; //p48T3 vGear.Gear1.page;
      Myprintdialog.ToPage := VGear.PageCount; // vGear.Gear1.pagecount; //p48t3 page;
      Myprintdialog.PrintRange := PrPageNums;
      If Myprintdialog.Execute Then
      Begin
        Try
          Try
            If Myprintdialog.PrintRange = PrAllPages Then
            Begin
              Myprintdialog.FromPage := 1;
              Myprintdialog.ToPage := VGear.PageCount; // vGear.Gear1.pagecount
            End;
            {
            vGear.Gear1.SettingMode := MODE_PRINTDRIVER;
            vGear.Gear1.SettingValue := 1;
            vGear.Gear1.Printsize := IG_PRINT_FULL_PAGE;
            }
            VGear.SetSettingMode(MODE_PRINTDRIVER);
            VGear.SetSettingValue(1);
            VGear.SetPrintSize(IG_PRINT_FULL_PAGE);
            Printer.Title := Printmsg;
            Printer.BeginDoc;
            For i := Myprintdialog.FromPage To Myprintdialog.ToPage Do
            Begin
              // JMW 4/10/06 p72 moved up to display title properly
              //printer.Title := printmsg;
              //printer.canvas.textout(10, 0, printmsg + '    --- page ' + IntToStr(I) + ' of ' + IntToStr(vGear.Gear1.pagecount) + '  ---');
              Printer.Canvas.Textout(10, 0, Printmsg + '    --- page ' + Inttostr(i) + ' of ' + Inttostr(VGear.PageCount) + '  ---');
              //vGear.Gear1.page := I;
              //vGear.Gear1.printimage := printer.Handle;
              VGear.Page := i;
              VGear.PrintImage(Printer.Handle);
              If i < Myprintdialog.ToPage Then
                Printer.Newpage
            End;
            Stat := True;
            Xmsg := 'Image Printed.';
//            if FDBBroker<>nil then
//              FDBBroker.RPLogCopyAccess(reason + '^^' + Tmag4VGear(MagVGear).PI_ptrData.Mag0 + '^' + 'Print Image' + '^' + Tmag4VGear(MagVGear).PI_ptrData.DFN + '^' + '1')
          Except
            On e: Exception Do
            Begin
              Stat := False;
              Xmsg := 'ERROR Printing: ' + e.Message
            End;
          End;
        Finally
          Printer.Enddoc
        End;
      End;
    Finally
      Myprintdialog.Free;
      Screen.Cursor := crDefault
    End;
  End;
End;

Procedure TMagUtilsDB.ImageCopy(MagVGear: Tobject; Var Stat: Boolean; Var Xmsg: String; skiplog: Boolean = False);
Var
  Reason: String;
Begin
  Stat := False;
  //if GetEsig(xmsg) then
  Begin
    Stat := True;

    TMag4VGear(MagVGear).CopyToClipboard();
    If skiplog Then Exit;
    If FDBBroker <> Nil Then
      FDBBroker.RPLogCopyAccess(Reason + '^^'
        + TMag4VGear(MagVGear).PI_ptrData.Mag0 + '^' + 'Copy Image' + '^'
        + TMag4VGear(MagVGear).PI_ptrData.DFN + '^' + '1',
        TMag4VGear(MagVGear).PI_ptrData, COPY_TO_CLIPBOARD)

  End;
End;

Procedure TMagUtilsDB.ImageTextFileCopy(IObj: TImageData; Memo: TMemo; XHeader: String);
Var
  Xmsg,
    Reason: String;
Begin
//p48t5 if GetEsig(xmsg) then // TODO ESIG
  Begin
    Memo.SelectAll;
    Memo.CopyToClipboard;
    Memo.SelLength := 0;
//p48t5    if FDBBroker<>nil then
//p48t5      FDBBroker.RPLogCopyAccess(reason + '^^' + IObj.Mag0 + '^' + 'Copy To Clipboard' + '^' + IObj.DFN + '^' + '1')
  End;
End;

Function TMagUtilsDB.GetEsigDialog(Var Xmsg: String): Boolean;
Var
  ct: Integer;
  Esig: String;
Begin
  Result := False;
  ct := 3;
  While ct > 0 Do
  Begin
    If FrmGetEsigDialog.Execute(Esig) Then
    Begin
      If Not FDBBroker.RPVerifyEsig(Esig, Xmsg) Then
        ct := ct - 1
      Else
      Begin
        Result := True;
        ct := 0;
      End;
    End
    Else
    Begin
      Xmsg := 'Electronic Signature Canceled.';
      ct := 0;
    End;

  End;
End;

Function TMagUtilsDB.GetEsig(Var Xmsg: String): Boolean;
Var
  Esig: String;
Begin
  If Userhaskey('MAG ROI') Or Userhaskey('TMP MAG ESIG') Then
  Begin
    Result := True;
    Exit;
  End;
  Result := False;
  If FDBBroker <> Nil Then
  Begin
    If Not GetEsigDialog(Xmsg) Then
    Begin
          //LogMsg('d', xmsg);
      MagLogger.LogMsg('d', Xmsg); {JK 10/6/2009 - Maggmsgu refactoring}
      Exit;
    End
    Else
    Begin
      AddDelKey('TMP MAG ESIG', True); //gtc-9-4
          //gtc-9-4 SecurityKeyToggle('TMP MAG ESIG',TRUE);
      Result := True;
    End;
  End
  Else {if FDBBroker not assigned, we'll just copy. Demo Mode, Viewing a Directory}
    Result := True //Tmag4VGear(MagVGear).Gear1.ClipboardCopy := True;
End;

Function TMagUtilsDB.GetReason(Rcode: Integer; Var Reason: String): Boolean;
Var
  Rmsg: String;
  Rstat: Boolean;
  Rlist: TStrings;
  Data: String;
Begin
  Rlist := Tstringlist.Create;
  Try
    If Not Doesformexist('frmCopyAgreement') Then
    Begin
      Application.CreateForm(TfrmCopyAgreement, FrmCopyAgreement);
      FrmCopyAgreement.LstReasons.ItemIndex := -1;
      FDBBroker.RPMaggReasonList(Rstat, Rmsg, Rlist, Data);
      FrmCopyAgreement.SetReasonList(Rlist);

  //p93
  {    use this list to initialize the LIST IN THE frmCopyAgreement.
        frmCopyAgreement will need to get a parameter to say which list it should
        be showing,  then show that list,and allow user to select. It will return the
        selected list item.
        The ien from the Reasons FM File - should return the IEN^DESC of
        the selected reason.  use IEN as code for LogCopyAccess RPC Call. display Desc
        in message history.

        Modify all calls to get a reason, for print and copy to use the RPC Call to
        get the list.
        MagDelete form, has it's own selection list, so it will call MagUtilsDB to
        get the list, and display it in it's own selection drop down.  }

    End;
    {  //p93 added 'rcode' to the EXECUTE call.  it was always comming in as a parameter
       waiting for the time to use it.}
    FrmCopyAgreement.ShowTypesOfReasons(TMagReasonsCodes(Rcode));
    Result := FrmCopyAgreement.Execute(Rcode, Reason);
    If Not Result Then
    //LogMsg('','Copy Agreement Canceled.');
      MagLogger.LogMsg('', 'Copy Agreement Canceled.'); {JK 10/6/2009 - Maggmsgu refactoring}
  Finally
    Rlist.Free;
  End;
End;

Procedure Register;
Begin
  RegisterComponents('Imaging', [TMagUtilsDB])
End;

Constructor TMagUtilsDB.Create(AOwner: TComponent);
Begin
  Inherited;
  FMagUtils1 := TMagUtils.Create(Nil)
End;

Destructor TMagUtilsDB.Destroy;
Begin
  Inherited;
  FMagUtils1.Destroy //
End;

Procedure TMagUtilsDB.ShowReport(t: TStrings; Reportdesc, Reporttitle: String; Rptmemo: TMemo = Nil);
Begin
  If (Rptmemo = Nil)
    And
    (Not Doesformexist('maggrpcf')) Then
  Begin
    Maggrpcf := TMaggrpcf.Create(Application)
    {TODO: need to fix this, need access to Upref's}
    //     upreftoreport(upref);
  End;
  // StripControlCharacters(t);
  If Rptmemo = Nil Then
  Begin
    Maggrpcf.PDesc.caption := Reportdesc;
    Maggrpcf.caption := Reporttitle + ' ' + Reportdesc;
    FMagUtils1.FormToNormalSize(Maggrpcf);
    Rptmemo := Maggrpcf.Memo1
  End;
  Rptmemo.Lines.Clear;
  Rptmemo.Lines := t
End;

Function TMagUtilsDB.Doesformexist(s: String): Boolean;
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
      Break
    End;
  End;
End;

//////////////////////////

Procedure TMagUtilsDB.PrintHeader(HeaderL, HeaderR: String);
//var xFont : Tfont;
Begin
  //xFont := printer.canvas.Font;
  {change font to Bold, Italic : to be different than the report.}
  Printer.Canvas.Font.Style := [Fsbold, Fsitalic];
  Printer.Canvas.Textout(10, 0, HeaderL);
  SetTextAlign(Printer.Canvas.Handle, TA_RIGHT);
  Printer.Canvas.Textout(Printer.PageWidth, 0, HeaderR);
  {set font to normal.}
  SetTextAlign(Printer.Canvas.Handle, TA_LEFT);
  Printer.Canvas.Font.Style := []
  //  printer.canvas.font := xfont;
End;

Procedure TMagUtilsDB.PrintFooter;
Var
  XFont: TFont;
Begin
  XFont := Printer.Canvas.Font;
  {change font to Bold, Italic : to be different than the report.}
  Printer.Canvas.Font.Style := [Fsbold, Fsitalic];
  SetTextAlign(Printer.Canvas.Handle, TA_RIGHT);
  Printer.Canvas.Textout(Printer.PageWidth, Printer.PageHeight - Printer.Canvas.TextHeight('X'), 'Printed: ' + Formatdatetime('d mmmm yyyy', Date));
  SetTextAlign(Printer.Canvas.Handle, TA_LEFT);
  {set font to normal.}
  //printer.canvas.font.style := [];
  Printer.Canvas.Font := XFont
End;

Procedure TMagUtilsDB.PrintTopSpacing(Lines, Texth, HorzM: Integer; Var CurLine: Integer);
Var
  j: Integer;
Begin
  For j := 1 To Lines Do
  Begin
    Inc(CurLine);
    Printer.Canvas.Textout(HorzM, CurLine * Texth, ' ')
  End;
End;

Procedure TMagUtilsDB.ImageTextFilePrint(IObj: TImageData; Txt: TStrings; XHeader: String);
Var
  i,
    Texth,
    PageH,
    Lineperpage: Integer;
  HorzM: Integer;
  Linect,
    Pagect,
    Pagetot: Integer;
  Xmsg,
    Reason: String;
Begin
//p48t5  if GetEsig(xmsg) then // TODO ESIG
  Begin
    Linect := 0;
    Pagect := 1;
    If IObj <> Nil Then
      XHeader := IObj.ExpandedIDDescription
    Else
      XHeader := XHeader;
    Try
     // xHeader := IObj.ExpandedIDDescription;
      With Printer Do
      Begin
        BeginDoc;
        With Canvas Do
        Begin
          {Establish printer parameters}
          //Font := richedit1.Font;
          Texth := TextHeight('P'); {Height of current font in pixels}
          PageH := PageHeight; {Page Height (printable) in pixels}
          Lineperpage := PageH Div Texth; { lines per page }
          HorzM := 20;
          Pagetot := Txt.Count Div Lineperpage;
          If (Txt.Count Mod Lineperpage) > 0 Then
            Pagetot := Pagetot + 1;

          //            inc(linect);
          PrintHeader(XHeader, 'Page ' + Inttostr(Pagect) + ' of ' + Inttostr(Pagetot));
          PrintTopSpacing(3, Texth, HorzM, Linect);

          //            for j := 1 to 3 do
          //              begin
          //                inc(linect); textout(horzM, linect * texth, ' ');
          //              end;
          For i := 0 To Txt.Count - 1 Do
          Begin
            Inc(Linect);
            If (Linect +
              3) > Lineperpage Then
            Begin
              PrintFooter;
              Newpage;
              Linect := 1;
              Inc(Pagect);
              PrintHeader(XHeader, 'Page ' + Inttostr(Pagect) + ' of ' + Inttostr(Pagetot));
              PrintTopSpacing(3, Texth, HorzM, Linect);
              //                  for j := 1 to 3 do
              //                      begin
              //                        inc(linect); textout(horzm, linect * texth, ' ');
              //                      end;
              Continue
            End;
            Textout(HorzM, (Texth * Linect), Txt[i])
          End;
          //X Font.Name:='Book Antiqua';
          {Set font size and style, Print Heading}
          //X Font.Size:=14;
          //X Font.Style:=[fsBold];
          {Print right justified column}
          //X SetTextAlign(printer.canvas.handle,TA_RIGHT);
          //X textout(Hmar+100*mmx,15*ls,FormatDateTime('d mmmm yyyy',Date));
          //X textout(Hmar+100*mmx,16*ls,'$6,550,000.00');
          //X setTextAlign(printer.canvas.handle,TA_LEFT);
          {Print decorative heading}
          //X with brush do
          //X   begin
          //X     style:=bsSolid;
          //X     color:=clGreen;
          //X   end;
          //X Rectangle(HMar,ls*20,Printer.PageWidth,ls*23);
          //X Font.Size:=18;
          //X Font.Color:=clWhite;
          //X Font.Style:=[fsBold];
          //X TextOut(hmar+10*mmx,ls*21,'White heading in a green rectangle');
          //X brush.color:=clwhite;
          //X font.color:=clblack;
          //X font.style:=[];
          {Print large footer}
          // Font.Size:=24;
          // Font.Style:=[fsBold];
          // ls:=textheight('X');
          //x  TextOut(HMar, Printer.PageHeight - TextHeight('X'), 'This is the end, my friend!');
          //X Font.Size := 12;
          {Set font size and style, get line height for body}
          //X SetFontSize(12);
          //X Font.Style:=[];                     {restore font style to regular (no style)}
          {Print body}
        End;
      End;
      PrintFooter
    Finally
      Printer.Enddoc
    End;
//p48t5    if FDBBroker<>nil then
//p48t5      FDBBroker.RPLogCopyAccess(reason + '^^' + IObj.Mag0 + '^' + 'Print Image' + '^' + IObj.DFN + '^' + '1')
  End;
End;

End.
