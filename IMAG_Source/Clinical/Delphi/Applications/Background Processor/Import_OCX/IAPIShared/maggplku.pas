Unit Maggplku;
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
  ComCtrls,
  Controls,
  ExtCtrls,
  Forms,
  Jpeg,
  Menus,
  Messages,
  Stdctrls,
  Graphics
  ;

//Uses Vetted 20090929:variants, uMagclasses, Trpcb, xwbut1, Dialogs, Graphics, WinProcs, umagdefinitions, magimagemanager, uMagUtils, WinTypes, SysUtils

Type
  TMaggplkf = Class(TForm)
    StatusBar1: TStatusBar;
    Panel4: Tpanel;
    Panel3: Tpanel;
    Label1: Tlabel;
    EPatient: TEdit;
    LPat: TListBox;
    Panel2: Tpanel;
    bbOK: TBitBtn;
    bbCancel: TBitBtn;
    PnlPhoto: Tpanel;
    TimPhoto: TImage;
    PnlVgear: Tpanel;
    LbPatName: Tlabel;
    Bevel1: TBevel;
    MainMenu1: TMainMenu;
    File1: TMenuItem;
    MnuOk: TMenuItem;
    N1: TMenuItem;
    Exit1: TMenuItem;
    Help1: TMenuItem;
    PatientLookuphelp1: TMenuItem;
    Procedure EPatientKeyDown(Sender: Tobject; Var Key: Word; Shift: TShiftState);
    Procedure LPatClick(Sender: Tobject);
    Procedure bbOKClick(Sender: Tobject);
    Procedure FormClose(Sender: Tobject; Var action: TCloseAction);
    Procedure LPatDblClick(Sender: Tobject);
    Procedure bbCancelClick(Sender: Tobject);
    Procedure LPatKeyDown(Sender: Tobject; Var Key: Word; Shift: TShiftState);
    Procedure FormShow(Sender: Tobject);
    Procedure FormCreate(Sender: Tobject);
    Procedure bbHelpClick(Sender: Tobject);
    Procedure FormDestroy(Sender: Tobject);
    Procedure LPatEnter(Sender: Tobject);
    Procedure EPatientEnter(Sender: Tobject);
    Procedure bbokEnter(Sender: Tobject);
    Procedure bbCancelEnter(Sender: Tobject);
    Procedure bbHelpEnter(Sender: Tobject);
    Procedure bbFontEnter(Sender: Tobject);
    Procedure EPatientDblClick(Sender: Tobject);
    Procedure File1Click(Sender: Tobject);
    Procedure MnuOkClick(Sender: Tobject);
    Procedure Exit1Click(Sender: Tobject);
    Procedure PatientLookuphelp1Click(Sender: Tobject);

  Private
    VvGear: Variant;
    Tdfn: Tstringlist;
    Procedure WMGetMinMaxInfo(Var Message: TWMGetMinMaxInfo); Message WM_GetMinMaxInfo;
    Procedure WinMsg(s: String);
    Procedure SaveSelectedDFN;
    Procedure EntryIsSelected;
    Procedure DoPatLookup;
    Procedure GetMyPatientPhoto(FSelectedDFN: String; PatName: String = '');
    Procedure ClearPatPhoto;
    Procedure InitPhoto;
    Procedure OpenJPegImage(Filename: String);
    Procedure OpenInMagVGear(Filename: String; PatName: String = '<patient name>');
    Procedure CreateVGear;
    Procedure GetNoPatientPhoto(PatName: String = '');
    Procedure ShowPatName(PatName: String);
    Procedure showPatProfile;

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
    Procedure ClearAll;
  End;

Var
  Maggplkf: TMaggplkf;

Implementation

Uses
  cMag4Vgear,
  FMagPatAccess,
  MagImageManager,
  SysUtils,
  UMagDefinitions,
  Umagutils8,
  WinTypes
  ;

{$R *.DFM}

Procedure TMaggplkf.EPatientKeyDown(Sender: Tobject; Var Key: Word; Shift: TShiftState);
Begin
  If ((Key <> VK_Return) Or (EPatient.Text = '')) Then Exit;
  DoPatLookup;
End;

Procedure TMaggplkf.DoPatLookup;
Var
  Xmsg: String;
Begin
  Xmsg := '';
  If Not Patlookup(EPatient.Text, Xmsg) Then
  Begin
    WinMsg(Xmsg);
    Exit;
  End;
  If (LPat.Items.Count = 1) And (FExitOnOneHit) Then ModalResult := MrOK;
  If (LPat.Items.Count > 0) Then
  Begin
    LPat.SetFocus;
    bbOK.Enabled := True;
  End;
End;
        {       makes RPC to search for 'patstr'.  Shows selection window
                if there are multiple matches. This method performs
                all Sensitivity and Means Test checking.}

Function TMaggplkf.Patlookup(Patstr: String; Var Xmsg: String): Boolean;
Var
  i: Longint;
  Str: String;
  t: Tstringlist;
  PatName: String;
Begin
  ClearPatPhoto;
  Result := False;
  WinMsg('Searching for "' + Patstr + '"');

  {  str := patient file + number to return + user input ; }
  Str := '100^' + Uppercase(Patstr) + '^';
  {  if certain fields are wanted, make a string of ';' delimited field numbers and make
      that the third piece.   4th piece is unused, 5th..n pieces are the 'Screen' if any.
      if (screen.caption <> '') then str := str +'^^'+screen.caption; {}
  EPatient.Text := Patstr;
  EPatient.Update;
  t := Tstringlist.Create;
  Tdfn.Clear;
  LPat.Clear;
  bbOK.Enabled := False;
  Try
    If Not FDBBroker.RPMagPatLookup(Str, t, Xmsg) Then
    Begin
      WinMsg(Xmsg);
      Exit;
    End;
    Result := True;
    WinMsg('');
    For i := 0 To t.Count - 1 Do
    Begin
      LPat.Items.Add(MagPiece(t[i], '^', 1));
      Tdfn.Add(MagPiece(t[i], '^', 2));
    End;
    LPat.ItemIndex := 0; {templistbox.sorted := true;}
    SaveSelectedDFN;
    PatName := LPat.Items[LPat.ItemIndex];
    If FSelectedDFN <> '0' Then GetMyPatientPhoto(FSelectedDFN, PatName);
  Finally
    t.Free;
  End;
End;

Procedure TMaggplkf.LPatClick(Sender: Tobject);
Var
  PatName: String;
Begin
  If (LPat.Items.Count = 0) And (EPatient.Text <> '') Then
  Begin
    DoPatLookup;
    Exit;
  End;

  bbOK.Enabled := LPat.ItemIndex <> -1;
  //here get photo.
  SaveSelectedDFN;
  PatName := LPat.Items[LPat.ItemIndex];
  If FSelectedDFN <> '0' Then GetMyPatientPhoto(FSelectedDFN, PatName);
End;

Procedure TMaggplkf.SaveSelectedDFN;
Begin
  If LPat.ItemIndex = -1 Then
    FSelectedDFN := '0'
  Else
  Begin
    FSelectedDFN := Magstripspaces(Tdfn[LPat.ItemIndex]);
    ShowPatName(LPat.Items[LPat.ItemIndex]);
  End;
End;

Procedure TMaggplkf.ShowPatName(PatName: String);
Begin
  LbPatName.caption := ' ' + MagPiece(PatName, ' ', 1);

  {JK 1/4/2008 - Fixes D5}
  If Pos('<patient', LbPatName.caption) > 0 Then
  Begin
    LbPatName.caption := '';
    LbPatName.Hint := '';
  End
  Else
    LbPatName.Hint := ' ' + PatName;

  LbPatName.Update;
  WinMsg(' ' + PatName);
End;

Procedure TMaggplkf.bbOKClick(Sender: Tobject);
Begin
  EntryIsSelected;
End;

Procedure TMaggplkf.EntryIsSelected;
Var
  t: Tstringlist;
  Notused: Boolean; //45
{TODO: checkinto variable notused}
Begin
  t := Tstringlist.Create;
  Try
    If LPat.ItemIndex = -1 Then
      WinMsg('You must Select a list entry !!')
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

Procedure TMaggplkf.FormClose(Sender: Tobject; Var action: TCloseAction);
Begin
{HERE SHOULD BE CLEANUP}
  ClearAll;
  EPatient.SetFocus;
  ClearPatPhoto;
End;

Procedure TMaggplkf.showPatProfile;
Begin
  If PnlVgear.Visible Then PnlVgear.Visible := False;
  TimPhoto.Visible := True;
End;

Procedure TMaggplkf.GetNoPatientPhoto(PatName: String = '');
Begin
  ClearPatPhoto;
  If PnlVgear.Visible Then PnlVgear.Visible := False;
  TimPhoto.Visible := True;
  ShowPatName(PatName);
End;

Procedure TMaggplkf.ClearPatPhoto;
Var
  VGear: TMag4VGear;
Begin
(* this worked, when we were using the timphoto for the JPG.
timphoto.Picture.Bitmap := nil;
timphoto.Invalidate;*)
  ShowPatName('<patient name>');
  TMag4VGear(PnlVgear.Controls[0]).ClearImage;

End;

        {       Clears all patient information from this window}

Procedure TMaggplkf.ClearAll;
Begin
  WinMsg('');
  EPatient.Clear;
  LPat.Clear;
  caption := 'Patient Lookup';
End;

Procedure TMaggplkf.WinMsg(s: String);
Begin
  StatusBar1.Panels[0].Text := s;
  StatusBar1.Update;
End;

Procedure TMaggplkf.LPatDblClick(Sender: Tobject);
Begin
  EntryIsSelected;
End;

Procedure TMaggplkf.bbCancelClick(Sender: Tobject);
Begin
  ModalResult := MrCancel;
End;

Procedure TMaggplkf.LPatKeyDown(Sender: Tobject; Var Key: Word;
  Shift: TShiftState);
Begin
  If (Key = VK_Return) Then EntryIsSelected;
End;

Procedure TMaggplkf.FormShow(Sender: Tobject);
Begin
  WinMsg('');
  bbOK.Enabled := LPat.Items.Count > 0;
  If LPat.Items.Count > 0 Then
    LPat.SetFocus
  //else epatient.setfocus
  Else
  Begin
    {JK 1/4/2008 - Fixes D5}
    EPatient.SetFocus;
    EPatientEnter(Self);
    Self.showPatProfile;
  End;
End;

Procedure TMaggplkf.FormCreate(Sender: Tobject);
Begin
{ form position is Screen Center}
  Tdfn := Tstringlist.Create;
  {default to this.  changing this value isn't implemented}
  FExitOnOneHit := True;
  Panel4.Align := alClient;
  PnlVgear.Align := alClient;
  //  InitPhoto;
  CreateVGear;
End;

Procedure TMaggplkf.InitPhoto;
Begin
  Exit; //not using timPhoto now.
  TimPhoto.Visible := True;
  PnlPhoto.Align := alClient;
  TimPhoto.Align := alClient;
//timphoto.Stretch := false;

  ClearPatPhoto;
End;

Procedure TMaggplkf.FormDestroy(Sender: Tobject);
Begin
{ form position is Screen Center}
  Tdfn.Free;
End;

Procedure TMaggplkf.bbHelpClick(Sender: Tobject);
Begin

End;

{procedure WMGetMinMaxInfo( var message : TWMGetMinMaxInfo); message WM_GETMINMAXINFO;}

Procedure TMaggplkf.WMGetMinMaxInfo(Var Message: TWMGetMinMaxInfo);
Var
  Hy, Wx: Integer;
Begin
  Hy := Trunc(245 * (Pixelsperinch / 96));
  Wx := Trunc(525 * (Pixelsperinch / 96));
  With Message.Minmaxinfo^ Do
  Begin
    PtMinTrackSize.x := Wx;
    PtMinTrackSize.y := Hy;
  End;
  Message.Result := 0;
  Inherited;

End;

        {       same as PatLookup, but it returns DFN in Variable Param
                Note: this is called by TMag4Pat object. This method performs
                all Sensitivity and Means Test checking.}

Function TMaggplkf.Select(Input: String; Var Selectmsg: String; Var DFNx: String): Boolean;
Begin
  Result := False;
  DFNx := '';
        {       If no text to search for, open the Patient Lookup window.}
  If Input = '' Then
  Begin
    Self.Color := FSAppBackGroundColor;
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
    If Self.LPat.Items.Count > 1 Then

    Begin
      Self.Color := FSAppBackGroundColor;
      bbOK.Enabled := True;
      Self.Showmodal;
      bbOK.Enabled := False;
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

Function TMaggplkf.AccessAllowed(DFNx: String; Var Xmsg: String): Boolean;
Var
  t: Tstringlist;
  SensitiveCode: Integer;
  Notused: Boolean;
Begin
  Result := False;
  t := Tstringlist.Create;
  Try
    Try
      FDBBroker.RPDGSensitiveRecordAccess(DFNx, SensitiveCode, t);
(*         DG SENSITIVE RECORD ACCESS
           Output value line 1 of RESULT will be made less granular

    Possible sensitivecode's returned  =  action required

           -1 = RPC/API failed
           0 = No display or action required
           1 = Display warning message
           2 = Display warning message - require OK to continue
           3 = Display warning message - do not continue
           If the output value is 1 (display warning message) entry in DG SECURITY LOG file is automatically made; GUI application does not need to take action to log access   *)

(*         DG SENSITIVITY RECORD BULLETIN
           Input parameter ACTION (send bulletin, set log, or both) will be made optional with 'both' being the default value
           Input parameter DG1 (inpatient/outpatient status) will be removed     *)

      Case SensitiveCode Of
        -1:
          Begin
            Result := False;
            Xmsg := t[0];
            FCurrentPatientSensitiveLevel := -1;
          End;
        0:
          Begin
            Result := True;
            Xmsg := 'Access is Allowed';
            FCurrentPatientSensitiveLevel := 0;
          End;
        1:
          Begin
            Result := True;
                {       frmPatAccess just displays the warning message}
            FrmPatAccess.Execute(Self, t, 1, Notused);
            Xmsg := 'Access to this restricted patient has been logged.';
            FCurrentPatientSensitiveLevel := 1;
          End;

        2:
          Begin
            If FrmPatAccess.Execute(Self, t, 2, Notused) Then
            Begin
              Result := True;
              Xmsg := 'Access to this restricted patient has been logged.';
              FDBBroker.RPDGSensitiveRecordBulletin(DFNx);
              FCurrentPatientSensitiveLevel := 2;
            End
            Else
            Begin
              Result := False;
              Xmsg := 'User has Canceled access to the patient.';
              FCurrentPatientSensitiveLevel := 0;
            End;
          End;

        3:
          Begin
            Result := False;
            FrmPatAccess.Execute(Self, t, 3, Notused);
            FCurrentPatientSensitiveLevel := 3;
            Xmsg := 'Access to this restricted patient is Not Allowed';
          End;

      End; {CASE }

      If Result Then
        {    if access is allowed, we'll check if a Means Test is required.}
      Begin
        WinMsg(Xmsg);
        FDBBroker.RPDGChkPatDivMeansTest(DFNx, SensitiveCode, t);
        If (SensitiveCode = 1) Then FrmPatAccess.Execute(Self, t, 4, Notused);
      End;

    Except
      On e: Exception Do
      Begin
        Result := False;
        If (Pos('<SUBSCRIPT>', e.Message) > 0) Then
          Xmsg := '' //Demotest 'The Remote Procedure Call ' + FDBBroker.broker.remoteprocedure + ' doesn''t exist on VISTA.  Please Call IRM'
        Else
          Xmsg := e.Message;
      End;
    End;
  Finally
    t.Free;
    Cursor := crDefault;
  End;
End;

Procedure TMaggplkf.LPatEnter(Sender: Tobject);
Begin
  If LPat.Items.Count > 0 Then
    WinMsg('<click> or <arrow-key> to highlight an entry. <Dbl-Click> or <Enter> to select.') {JK 1/4/2009 - spelling/capitalization}
  Else
  Begin
    WinMsg('');
    bbOK.Enabled := False;
  End;
  If (LPat.ItemIndex > -1) Then bbOK.Enabled := True;
End;

Procedure TMaggplkf.EPatientEnter(Sender: Tobject);
Begin
  WinMsg('Type patient name (partial is OK), or full SSN, or last initial, or last 4 of SSN. Then press <Enter>.'); {JK 1/4/2009 - spelling/capitalization}
End;

Procedure TMaggplkf.bbokEnter(Sender: Tobject);
Begin
  WinMsg('Press <Enter> to select highlighted entry.'); {JK 1/4/2009 - spelling/capitalization}
End;

Procedure TMaggplkf.bbCancelEnter(Sender: Tobject);
Begin
  WinMsg('Press <Enter> to cancel patient lookup.'); {JK 1/4/2009 - spelling/capitalization}
End;

Procedure TMaggplkf.bbHelpEnter(Sender: Tobject);
Begin
  WinMsg('Press <Enter> for help on patient lookup.'); {JK 1/4/2009 - spelling/capitalization}
End;

Procedure TMaggplkf.bbFontEnter(Sender: Tobject);
Begin
  WinMsg('Press <Enter> to select a new font.'); {JK 1/4/2009 - spelling/capitalization}
End;

Procedure TMaggplkf.EPatientDblClick(Sender: Tobject);
Begin
  DoPatLookup;
End;

Procedure TMaggplkf.GetMyPatientPhoto(FSelectedDFN: String; PatName: String = '');
Var
  t: Tstringlist;
  Xmsg, PhotoImage: String;
  SiteAbbr, Vhint: String;
Begin
  Self.ClearPatPhoto;
  Try
    t := Tstringlist.Create;

    FDBBroker.RPMaggGetPhotoIDs(FSelectedDFN, t);
    PhotoImage := MagPiece(t[0], '^', 3); // 3 is full, 4 is abstract;
    SiteAbbr := MagPiece(t[0], '^', 17);
    If PhotoImage = '' Then GetNoPatientPhoto(PatName);
    If PhotoImage <> '' Then
    Begin
      Try
        Screen.Cursor := crHourGlass;
        PhotoImage := MagImageManager1.GetImageFile(PhotoImage, SiteAbbr, Xmsg);
         {  Load the image}
        If Not FileExists(PhotoImage) Then GetNoPatientPhoto(PatName);
        If FileExists(PhotoImage) Then
        Begin
//           OpenJPegImage(photoImage);
          OpenInMagVGear(PhotoImage, PatName);

        End;
     //////    timPhoto.Picture.LoadFromFile(photoimage);
        (*  vhint := FMagPat.M_NameDisplay + #13
                  + Fmagpat.M_SSNdisplay + '   ' + Fmagpat.M_Sex + #13
                  + Fmagpat.M_DOB + '(' + Fmagpat.M_Age+')';*)

         {  Hint for the Image}
         (* Mag4VGear1.ImageHint(vHint);  *)
      Finally
        Screen.Cursor := crDefault;
      End;
    End;

  Finally
    t.Free;
  End;

End;

Procedure TMaggplkf.OpenJPegImage(Filename: String);
Var
  Jbi: TJpegImage;

  Procedure CargaJPGProporcionado(Fichero: String;
    Const QueImage: TImage);
  Var
    ElJPG: TJpegImage;
    Rectangulo: Trect;

    EscalaX,
      EscalaY,
      Escala: Single;

  Begin
    ElJPG := TJpegImage.Create;

    Try

      ElJPG.LoadFromFile(Fichero);

      //Por defecto, escala 1:1
      EscalaX := 1.0;
      EscalaY := 1.0;

      //Hallamos la escala de reducción Horizontal
      If QueImage.Width < ElJPG.Width Then
        EscalaX := QueImage.Width / ElJPG.Width;

      //La escala vertical
      If QueImage.Height < ElJPG.Height Then
        EscalaY := QueImage.Height / ElJPG.Height;

      //Escogemos la menor de las 2
      If EscalaY < EscalaX Then
        Escala := EscalaY
      Else
        Escala := EscalaX;

      //Y la usamos para reducir el rectangulo destino
      With Rectangulo Do
      Begin
        Right := Trunc(ElJPG.Width * Escala);
        Bottom := Trunc(ElJPG.Height * Escala);
        Left := 0;
        Top := 0;
      End;

      //Dibujamos el bitmap con el nuevo tamaño en el TImage destino
      With QueImage.Picture.Bitmap Do
      Begin
        Width := Rectangulo.Right;
        Height := Rectangulo.Bottom;
        Canvas.StretchDraw(Rectangulo, ElJPG);
      End;

    Finally
      ElJPG.Free;
    End;

  End; {De CargaJPGProporcionado}

Begin
  CargaJPGProporcionado(Filename, TimPhoto);
End;

Procedure TMaggplkf.CreateVGear;
Var
  VGear: TMag4VGear;
  i: Integer;
Begin
  VGear := TMag4VGear.Create(Self, '', MagGearAbilityClinical);
  VGear.Parent := PnlVgear;
  VGear.Show;

  VGear.Align := alClient;
//vGear.LoadTheImage('c:\testimages\aaaad5.jpg');
//vGear.updatePageView;
//vvGear := (vGear as Variant)
  TimPhoto.BringToFront;
  TimPhoto.Visible := True;
  VGear.btnCloseImage.Visible := False;
  VGear.LblImage.caption := '';
End;

Procedure TMaggplkf.OpenInMagVGear(Filename: String; PatName: String = '<patient name>');
Var
  VGear: TMag4VGear;
  i, j: Integer;
Begin
  If TimPhoto.Visible Then TimPhoto.Visible := False;
  If Not PnlVgear.Visible Then PnlVgear.Visible := True;
  TMag4VGear(PnlVgear.Controls[0]).LoadTheImage(Filename);
  ShowPatName(PatName);
End;

Procedure TMaggplkf.File1Click(Sender: Tobject);
Begin
  MnuOk.Enabled := bbOK.Enabled;
End;

Procedure TMaggplkf.MnuOkClick(Sender: Tobject);
Begin
  EntryIsSelected;
End;

Procedure TMaggplkf.Exit1Click(Sender: Tobject);
Begin
  ModalResult := MrCancel;
End;

Procedure TMaggplkf.PatientLookuphelp1Click(Sender: Tobject);
Begin
  Application.HelpContext(10145);
End;

End.

End.
