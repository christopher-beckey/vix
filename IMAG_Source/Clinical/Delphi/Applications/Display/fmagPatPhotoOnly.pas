Unit FmagPatPhotoOnly;
   {
   Package: MAG - VistA Imaging
   WARNING: Per VHA Directive 10-93-142 this unit should not be modified.
   Date Created: Version 2.0
   Site Name: Silver Spring, OIFO
   Developers: Garrett Kirin
   [==
   Description:    unit Maggplku;
        This form handles the Patient Lookup functionality.  It is created and
        called from the TMag4Pat object.
    - RPC calls to get and display a list of patients from the DB that match
      the users imput.
    - allows user to select one patient only.
    - Patient information is querried from the database for selected patient.
    - The RPC's for Patient Sensitivity are called.
    - Patient Sensitivity warnings are displayed.
    - Sensitive Patient Logging is done when needed.
    - Means Test warnings are displayed if appropriate.
    ==]
   Note: }
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
  cMagDBBroker,
  cMagListView,
  cMagObserverLabel,
  cMagPat,
  cMagPatPhoto,
  cMagSecurity,
  ComCtrls,
  Controls,
  Dialogs,
  ExtCtrls,
  Forms,
  Menus,
  Stdctrls

  ;

//Uses Vetted 20090929:dmsingle, uMagclasses, Trpcb, xwbut1, Graphics, Messages, WinProcs, magpositions, uMagUtils, WinTypes, SysUtils

Type
  TfrmPatPhotoOnly = Class(TForm)
    FontDialog1: TFontDialog;
    StatusBar1: TStatusBar;
    Panel4: Tpanel;
    MainMenu1: TMainMenu;
    File1: TMenuItem;
    Help1: TMenuItem;
    PatientPhotoOnlyHelp1: TMenuItem;
    Exit1: TMenuItem;
    Panel1: Tpanel;
    MagPatPhoto1: TMagPatPhoto;
    Mag4PatPhotoOnly: TMag4Pat;
    MagObserverLabel1: TMagObserverLabel;
    Label2: Tlabel;
    Label3: Tlabel;
    MnuOptions: TMenuItem;
    PhotowInfo1: TMenuItem;
    PhotoOnly1: TMenuItem;
    PhotowName1: TMenuItem;
    PhotoTop1: TMenuItem;
    PhotoLeft1: TMenuItem;
    Panel5: Tpanel;
    Panel3: Tpanel;
    Label1: Tlabel;
    EPatient: TEdit;
    Panel2: Tpanel;
    bbClose: TBitBtn;
    Splitter1: TSplitter;
    lvPat: TMagListView;
    PopupMenu1: TPopupMenu;
    FitColumnstoForm1: TMenuItem;
    FitColumnstoText1: TMenuItem;
    Procedure EPatientKeyDown(Sender: Tobject; Var Key: Word; Shift: TShiftState);
    Procedure LPatClick(Sender: Tobject);
    Procedure FormClose(Sender: Tobject; Var action: TCloseAction);
    Procedure bbCloseClick(Sender: Tobject);
    Procedure LPatKeyDown(Sender: Tobject; Var Key: Word; Shift: TShiftState);
    Procedure FormShow(Sender: Tobject);
    Procedure FormCreate(Sender: Tobject);
    Procedure bbHelpClick(Sender: Tobject);
    Procedure FormDestroy(Sender: Tobject);
    Procedure LPatEnter(Sender: Tobject);
    Procedure EPatientEnter(Sender: Tobject);
    Procedure bbokEnter(Sender: Tobject);
    Procedure bbCloseEnter(Sender: Tobject);
    Procedure bbHelpEnter(Sender: Tobject);
    Procedure bbFontEnter(Sender: Tobject);
    Procedure EPatientDblClick(Sender: Tobject);
    Procedure PatientPhotoOnlyHelp1Click(Sender: Tobject);
    Procedure Exit1Click(Sender: Tobject);
    Procedure PhotowInfo1Click(Sender: Tobject);
    Procedure PhotoOnly1Click(Sender: Tobject);
    Procedure lvPatKeyDown(Sender: Tobject; Var Key: Word;
      Shift: TShiftState);
    Procedure lvPatEnter(Sender: Tobject);
    Procedure FitColumnstoText1Click(Sender: Tobject);
    Procedure FitColumnstoForm1Click(Sender: Tobject);
    Procedure lvPatChange(Sender: Tobject; Item: TListItem;
      Change: TItemChange);

  Private
    Tdfn: Tstringlist;

    Procedure WinMsg(s: String);
    Procedure SaveSelectedDFN;
    Procedure EntryIsSelected;
    Procedure DoPatLookup;
    Procedure ClearPatient;

  Public
        {       DataBase connection. }
    FDBBroker: TMagDBBroker;
        {       Old version set this public value when a patient was selected
                Newer design 'Select' method.  returns DFN on success.}
    FSelectedDFN: String;
        {       Not Implemented}
    FScreen: String;
        {       Now, this is not changed.  It is always true.
                If TRUE, selection window will not be shown when only one
                patient matches user input.
                If FALSE, selection window will always be shown.}
    FExitOnOneHit: Boolean;
        {       makes RPC to search for 'patstr'.  Shows selection window
                if there are multiple matches. This method performs
                all Sensitivity and Means Test checking.}
    Function Patlookup(Patstr: String; Var Xmsg: String): Boolean;
        {       same as PatLookup, but it returns DFN in Variable Param
                Note: this is called by TMag4Pat object. This method performs
                all Sensitivity and Means Test checking.}
    Function Select(Input: String; Var Selectmsg: String; Var DFNx: String): Boolean;
        {       Makes RPC to see if user can access this patient.}
    Function AccessAllowed(DFNx: String; Var Xmsg: String): Boolean;
        {       Clears all patient information from this window}
    Procedure Execute(UserNameDuz: String; PDBBroker: TMagDBBroker; PMagSecurity: TMag4Security);
    Procedure ClearAll;
  End;

Var
  FrmPatPhotoOnly: TfrmPatPhotoOnly;

Implementation

Uses
  FMagPatAccess,
  Magpositions,
  SysUtils,
  Umagutils8,
  WinTypes,
  UMagDefinitions,
  Umagdisplaymgr
  ;

{$R *.DFM}

Procedure TfrmPatPhotoOnly.EPatientKeyDown(Sender: Tobject; Var Key: Word; Shift: TShiftState);
Begin
  If ((Key <> VK_Return) Or (EPatient.Text = '')) Then Exit;
  DoPatLookup;
End;

{JK 3/27/2009 - Fixes IR dated 3-11-2009.  This is a new procedure that clears
 the patient photo and list of patients when a patient lookup fails.}

Procedure TfrmPatPhotoOnly.ClearPatient;
Begin
  //p93t10 lPat.Clear;                           {Clear the patient list box}
  lvPat.Clear;
  MagObserverLabel1.UpDate_('', Self); {Clear the observer label}
  MagPatPhoto1.Mag4Vgear1.ClearImage; {Clear the underlying image from a previous search}
  MagPatPhoto1.PnlProfilePhoto.BringToFront; {Bring the chess piece to the forefront}
  If EPatient.CanFocus Then
    EPatient.SetFocus; {Put the cursor in the ePatient entry box}
End;

Procedure TfrmPatPhotoOnly.DoPatLookup;
Var
  Xmsg: String;
Begin
  Xmsg := '';
  If Not Patlookup(EPatient.Text, Xmsg) Then
  Begin
    ClearPatient; {JK 3/27/2009 - fixes IR dated 3-11-2009}
    WinMsg(Xmsg);
    Exit;
  End;
  If (lvpat.Items.Count = 1) And (FExitOnOneHit) Then
    ModalResult := MrOK;
  //p93t10   if (lpat.items.count = 1) and (FExitOnOneHit) then
  //p93t10     ModalResult := mrOK;
  If lvPat.Items.Count > 0 Then
  Begin
    lvPat.SetFocus;
  End;
  //p93t10   if (lpat.items.count > 0) then
  //p93t10   begin
  //p93t10     lpat.setfocus;
  //p93t10    // bbOK.Enabled := true;
  //p93t10   end;
End;

        {       makes RPC to search for 'patstr'.  Shows selection window
                if there are multiple matches. This method performs
                all Sensitivity and Means Test checking.}

Function TfrmPatPhotoOnly.Patlookup(Patstr: String; Var Xmsg: String): Boolean;
Var
  i: Longint;
  lvpatStr, Str: String;
  t, t2: Tstringlist;
  j: Integer;
Begin
  Result := False;
  WinMsg('Searching for "' + Patstr + '"');

  {  str := patient file + number to return + user input ; }
  Str := '100^' + Uppercase(Patstr) + '^';
  lvpatstr := '300^' + Uppercase(Patstr) + '^^2^';
  {  if certain fields are wanted, make a string of ';' delimited field numbers and make
      that the third piece.   4th piece is unused, 5th..n pieces are the 'Screen' if any.
      if (screen.caption <> '') then str := str +'^^'+screen.caption; {}
  EPatient.Text := Patstr;
  EPatient.Update;
  t := Tstringlist.Create;
  t2 := Tstringlist.Create;
  Tdfn.Clear;
  //p93t10   lpat.clear;
  lvPat.Clear;
//  bbok.enabled := false;
  Try
    If Not FDBBroker.RPMagPatLookup(Str, t, Xmsg) Then
    Begin
      WinMsg(Xmsg);
      Exit;
    End;
    If Not FDBBroker.RPMagPatLookup(lvPatSTR, t2, Xmsg) Then
    Begin
      WinMsg(Xmsg);
      Exit;
    End;
    Result := True;
    WinMsg('');
    lvpat.LoadListFromStrings(t2);
    lvPat.Update;
    lvpat.FitColumnsToText;
 //   lvpat.SetColumnWidths('280,80,80,120');
    lvPat.Update;
  //p93t10     for I := 0 to t.count - 1 do
  //p93t10     begin
  //p93t10
  //p93t10       lpat.items.add(magpiece(t[i], '^', 1));
  //p93t10       tdfn.Add(magpiece(t[i], '^', 2));
  //p93t10     end;
  //p93t10     lPat.itemindex := 0; {templistbox.sorted := true;}
    SaveSelectedDFN;
  Finally
    t.Free;
  End;
End;

Procedure TfrmPatPhotoOnly.LPatClick(Sender: Tobject);
Begin
 (*
  //p93t10
    if (lpat.Items.Count = 0) and (epatient.Text <> '') then
    begin
      DoPatLookup;
      exit;
    end;

//  bbok.enabled := lpat.ItemIndex <> -1;
  SaveSelectedDFN;
  *)
End;

Procedure TfrmPatPhotoOnly.SaveSelectedDFN;
Var
  Xmsg: String;
  Li: TListItem;
Begin
  Li := lvPat.ItemFocused;
  If Li = Nil Then
    FSelectedDFN := '0'
  Else
    FSelectedDFN := MagPiece(TMagListViewData(Li.Data).Data, '^', 1);
  //p93t10   if lpat.ItemIndex = -1
  //p93t10     then FselectedDFN := '0'
  //p93t10     else FSelectedDFN := MagStripSpaces(tdfn[lpat.itemindex]);
  //HERE, USE FSelectedDFN to load Photo and Patient Name Info.

  Self.Mag4PatPhotoOnly.SwitchTopatient(FSelectedDFN, Xmsg);
End;

Procedure TfrmPatPhotoOnly.EntryIsSelected;
Var
  t: Tstringlist;
  Notused: Boolean; //45
{TODO: checkinto variable notused}
Begin
  t := Tstringlist.Create;
  Try
    If lvPat.ItemFocused = Nil Then
    Begin
      WinMsg('You must Select a list entry !!');
      Exit;
    End
  //p93t10     if lPat.itemindex = -1
  //p93t10       then WinMsg('You must Select a list entry !!')
    Else
    Begin
      If FDBBroker.RPMaggPatBS5Chk(FSelectedDFN, t) Then
        ModalResult := MrOK
      Else
        If FrmPatAccess.Execute(Self, t, 5, Notused) {// JMW THIS LAST PARAMETER SHOULD BE INVESTIGATED...} Then
          ModalResult := MrOK
        Else
          WinMsg('User has Canceled Selection.');
    End;
  Finally
    t.Free;
  End;
End;

Procedure TfrmPatPhotoOnly.FormClose(Sender: Tobject; Var action: TCloseAction);
Begin
{HERE SHOULD BE CLEANUP}
  ClearAll;
  EPatient.SetFocus;
End;

        {       Clears all patient information from this window}

Procedure TfrmPatPhotoOnly.ClearAll;
Begin
  WinMsg('');
  EPatient.Clear;
  lvPat.Clear;
  //p93t10   lPat.clear;
  caption := 'Patient Lookup';
End;

Procedure TfrmPatPhotoOnly.WinMsg(s: String);
Begin
  StatusBar1.Panels[0].Text := s;
  StatusBar1.Update;
End;

Procedure TfrmPatPhotoOnly.bbCloseClick(Sender: Tobject);
Begin
  ModalResult := MrCancel;
End;

Procedure TfrmPatPhotoOnly.LPatKeyDown(Sender: Tobject; Var Key: Word;
  Shift: TShiftState);
Begin
  //p93t10
  (*
  if (key = vk_return) then EntryIsSelected;
  *)
End;

Procedure TfrmPatPhotoOnly.FormShow(Sender: Tobject);
Begin
  WinMsg('');
//  bbok.Enabled := lpat.items.count > 0;
  If lvPat.Items.Count > 0 Then
  Begin
    lvPat.SetFocus;
    lvPat.FitColumnsToText;
  End
  Else
    EPatient.SetFocus;
  //p93t10   if lpat.items.count > 0 then lpat.setfocus
  //p93t10     else epatient.setfocus;
End;

Procedure TfrmPatPhotoOnly.FormCreate(Sender: Tobject);
Begin
{ form position is Screen Center}
  Tdfn := Tstringlist.Create;
    {   For Patient PHOTO Only, we don't exit on One Hit, we show the Photo.}
  FExitOnOneHit := False;
  lvPat.Align := alClient;
  //p93t10   lPat.Align := alclient;
  Panel5.Align := alClient;
  MagPatPhoto1.Align := alClient;
//MagPatPhoto1.Mag4Vgear1.Align := alclient;
//MagPatPhoto1.Mag4Vgear1.ClearImage;
  MagPatPhoto1.UpDate_('', Self);
  GetFormPosition(Self As TForm);
  lvPat.SetColumnZeroWidth(-1);
End;

Procedure TfrmPatPhotoOnly.FormDestroy(Sender: Tobject);
Begin
{ form position is Screen Center}
  Tdfn.Free;

  SaveFormPosition(Self As TForm);
End;

Procedure TfrmPatPhotoOnly.bbHelpClick(Sender: Tobject);
Begin

End;

        {       same as PatLookup, but it returns DFN in Variable Param
                Note: this is called by TMag4Pat object. This method performs
                all Sensitivity and Means Test checking.}

Function TfrmPatPhotoOnly.Select(Input: String; Var Selectmsg: String; Var DFNx: String): Boolean;
Begin
  Result := False;
  DFNx := '';
        {       If no text to search for, open the Patient Lookup window.}
  If Input = '' Then
  Begin
    Self.Showmodal;
    If Self.ModalResult = MrCancel Then
    Begin
      Selectmsg := 'Patient Lookup : ' + Input + '  Canceled';
      Exit;
    End;
  End
  Else
  Begin
    If Not Patlookup(Input, Selectmsg) Then
    Begin
      // maggmsgf.MagMsg('de', selectmsg, nilpanel);
      Exit;
    End;
        { if count is 1 then we got exact hit, so skip the modal window.}
  //p93t10       if self.lpat.items.count > 1 then
    If Self.lvPat.Items.Count > 1 Then
    Begin
//      bbok.enabled := true;
      Self.Showmodal;
//      bbok.enabled := false;
      If Self.ModalResult = MrCancel Then
      Begin
        Selectmsg := 'Patient Lookup : ' + Input + '  Canceled';
        Exit;
      End;
    End;
  End;
{ modal result is OK ( user must have selected a patient for modal window to return OK )
  or only one hit on lookup.  In this case 0 entry is selected and FSelectedDFN has been set. {}

{ Check the BS5 cross reference. To make sure this is the desired patient.
  This has been done on the Mouse Click or <Enter> in the list box, calling  EntryIsSelected Procedure {}

{ Now we'll test for Accesss allowed to sensitive patient, and display the Means test required
  message if needed. {}
{95gek This is Local Patient}
  If AccessAllowed(FSelectedDFN, Selectmsg) Then
  Begin
    Result := True;
    DFNx := FSelectedDFN;
  End;

End;

        {       Makes RPC to see if user can access this patient.}

Function TfrmPatPhotoOnly.AccessAllowed(DFNx: String; Var Xmsg: String): Boolean;
Var
  t: Tstringlist;
  SensitiveCode: Integer;
  Notused: Boolean;
Begin
(*
    This isn't called in Patient Photo Only.  We are only showing the Patient Photo
    and are not accessing any patient information
 *)

  Result := True;
  Exit;
(*
  result := false;
  t := tstringlist.create;
  try
    try
      FDBBroker.RPDGSensitiveRecordAccess(DFNx, sensitivecode, t);
{         DG SENSITIVE RECORD ACCESS
           Output value line 1 of RESULT will be made less granular

    Possible sensitivecode's returned  =  action required

           -1 = RPC/API failed
           0 = No display or action required
           1 = Display warning message
           2 = Display warning message - require OK to continue
           3 = Display warning message - do not continue
           If the output value is 1 (display warning message) entry in DG SECURITY LOG file is automatically made; GUI application does not need to take action to log access
           }

{         DG SENSITIVITY RECORD BULLETIN
           Input parameter ACTION (send bulletin, set log, or both) will be made optional with 'both' being the default value
           Input parameter DG1 (inpatient/outpatient status) will be removed
           }

      case SensitiveCode of
        -1: begin
            result := false;
            xmsg := t[0];
          end;
        0: begin
            result := true;
            xmsg := 'Access is Allowed';
          end;
        1: begin
            result := true;
                {       frmPatAccess just displays the warning message}
            frmPatAccess.execute(self, t, 1, notused);
            xmsg := 'Access to this restricted patient has been logged.';
          end;

        2: begin
            if frmPatAccess.execute(self, t, 2, notused)
              then
            begin
              result := true;
              xmsg := 'Access to this restricted patient has been logged.';
              FDBBroker.RPDGSensitiveRecordBulletin(DFNx);
            end
            else
            begin
              result := false;
              xmsg := 'User has Canceled access to the patient.'
            end;
          end;

        3: begin
            result := false;
            frmPatAccess.execute(self, t, 3, notused);
            xmsg := 'Access to this restricted patient is Not Allowed';
          end;

      end; {CASE }

      if result then
        {    if access is allowed, we'll check if a Means Test is required.}
      begin
        winmsg(xmsg);
        FDBBroker.RPDGChkPatDivMeansTest(DFNx, sensitivecode, t);
        if (sensitivecode = 1) then frmPatAccess.execute(self, t, 4, notused);
      end;

    except
      on E: EXCEPTION do
      begin
        result := false;
        if (POS('<SUBSCRIPT>', E.MESSAGE) > 0) then xmsg := '' //Demotest 'The Remote Procedure Call ' + FDBBroker.broker.remoteprocedure + ' doesn''t exist on VISTA.  Please Call IRM'
        else xmsg := E.message;
      end;
    end;
  finally
    t.free;
    cursor := crDefault;
  end;
*)
End;

Procedure TfrmPatPhotoOnly.LPatEnter(Sender: Tobject);
Begin
  //p93t10
  (*
  if lpat.items.count > 0 then WinMsg('Use mouse or <arrow keys> to highlite an entry.  Click ''Close'' button to exit.')
  else begin
    WinMsg('');
//    bbok.enabled := false;
  end;
  if (lpat.itemindex > -1) then //bbok.enabled := TRUE;
  *)
End;

Procedure TfrmPatPhotoOnly.EPatientEnter(Sender: Tobject);
Begin
  {/ P122 with P123 patient ID additions - JK 8/11/2011 /}
  if GSess.Agency.IHS then
    WinMsg('type Patient HRN (partial is ok) or full HRN.   Press <Enter>.')
  else
    WinMsg('type Patient Name (partial is ok), or full SSN, or Last Initial Last 4 of SSN.   Press <Enter>.');
End;

Procedure TfrmPatPhotoOnly.bbokEnter(Sender: Tobject);
Begin
  WinMsg('Press Enter to select highlited entry.');
End;

Procedure TfrmPatPhotoOnly.bbCloseEnter(Sender: Tobject);
Begin
  WinMsg('Press Enter to Cancel Patient Photo View.');
End;

Procedure TfrmPatPhotoOnly.bbHelpEnter(Sender: Tobject);
Begin
  WinMsg('Press Enter for Help on Patient Photo View.');
End;

Procedure TfrmPatPhotoOnly.bbFontEnter(Sender: Tobject);
Begin
  WinMsg('Press Enter to select a new Font.');
End;

Procedure TfrmPatPhotoOnly.EPatientDblClick(Sender: Tobject);
Begin
  DoPatLookup;
End;

Procedure TfrmPatPhotoOnly.Execute(UserNameDuz: String; PDBBroker: TMagDBBroker; PMagSecurity: TMag4Security);
Begin
  Application.CreateForm(TfrmPatPhotoOnly, FrmPatPhotoOnly);

  FrmPatPhotoOnly.FDBBroker := PDBBroker;
  FrmPatPhotoOnly.Mag4PatPhotoOnly.M_DBBroker := PDBBroker;
  FrmPatPhotoOnly.MagPatPhoto1.MagDBBroker := PDBBroker;
  FrmPatPhotoOnly.MagPatPhoto1.MagSecurity := PMagSecurity;
  FrmPatPhotoOnly.Showmodal;
End;

Procedure TfrmPatPhotoOnly.PatientPhotoOnlyHelp1Click(Sender: Tobject);
Var
  whatsnew: String;
Begin
  whatsnew := AppPath + '\MagWhats New in Patch 93.pdf';
    {      the file is named : 'MagWhats New in Patch 93.pdf'}
  If FileExists(whatsnew) Then
  Begin
    Magexecutefile(whatsnew, '', '', SW_SHOW);
  End;
End;

Procedure TfrmPatPhotoOnly.Exit1Click(Sender: Tobject);
Begin
  Close;
End;

Procedure TfrmPatPhotoOnly.PhotowInfo1Click(Sender: Tobject);
Begin
  MagPatPhoto1.PhotoInfo1Click(Self);
End;

Procedure TfrmPatPhotoOnly.PhotoOnly1Click(Sender: Tobject);
Begin
  MagPatPhoto1.PhotoOnly1Click(Self);
End;

Procedure TfrmPatPhotoOnly.lvPatKeyDown(Sender: Tobject; Var Key: Word;
  Shift: TShiftState);
Begin
  If (Key = VK_Return) Then EntryIsSelected;
End;

Procedure TfrmPatPhotoOnly.lvPatEnter(Sender: Tobject);
Begin
  If lvpat.Items.Count > 0 Then
    WinMsg('Use mouse or <arrow keys> to highlite an entry.  Click ''Close'' button to exit.')
  Else
  Begin
    WinMsg('');
//    bbok.enabled := false;
  End;
  If (lvpat.ItemIndex > -1) Then //bbok.enabled := TRUE;

End;

Procedure TfrmPatPhotoOnly.FitColumnstoText1Click(Sender: Tobject);
Begin
  Self.lvPat.FitColumnsToText;
End;

Procedure TfrmPatPhotoOnly.FitColumnstoForm1Click(Sender: Tobject);
Begin
  lvpat.FitColumnsToForm;
End;

Procedure TfrmPatPhotoOnly.lvPatChange(Sender: Tobject; Item: TListItem; Change: TItemChange);
Begin
  If Not Item.Selected Then Exit;
  If (lvpat.Items.Count = 0) And (EPatient.Text <> '') Then
  Begin
    DoPatLookup;
    Exit;
  End;

//  bbok.enabled := lpat.ItemIndex <> -1;
  SaveSelectedDFN;
End;

End.
