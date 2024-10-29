Unit FmagUserPref;
   {
   Package: MAG - VistA Imaging
   WARNING: Per VHA Directive 10-93-142 this unit should not be modified.
   Date Created:  1996
   Site Name: Silver Spring, OIFO
   Developers: Garrett Kirin
   Description: User Preferences for when a Patient is selected.
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
  Buttons,
  ComCtrls,
  Controls,
  ExtCtrls,
  Forms,
  Stdctrls,
  UMagClasses,
  Classes, ActnList
  ;

//Uses Vetted 20090929:umagDefinitions, Dialogs, Graphics, Classes, Messages, WinProcs, WinTypes, SysUtils, uMagKeyMgr, magpositions, umagutils

Type
  TfrmUserPref = Class(TForm)
    cbViewJBox: TCheckBox;
    btnClose: TBitBtn;
    btnHelp: TBitBtn;
    btnSave: TBitBtn;
    PageControl1: TPageControl;
    TabSheet1: TTabSheet;
    tbshViewers: TTabSheet;
    TabSheet3: TTabSheet;
    GrpPatientSelected: TGroupBox;
    cbShowAbsWindow: TCheckBox;
    cbShowImageListWin: TCheckBox;
    GrpClin: TGroupBox;
    cbShowRadListwin: TCheckBox;
    cbShowMUSE: TCheckBox;
    cbShowNotes: TCheckBox;
    TbshAltViewerOptions: TTabSheet;
    GroupBox1: TGroupBox;
    GrpbxPDFfiles: TGroupBox;
    cbPlayVideoOnOpen: TCheckBox;
    RbUseMagVideoViewer: TRadioButton;
    RbUseAltVideoViewer: TRadioButton;
    cbUseAltPDFViewer: TRadioButton;
    cbUseFullResForPDF: TRadioButton;
    cbShowThumbs: TCheckBox;
    RgrpThumbs: TRadioGroup;
    LbShowImages: Tlabel;
    RgrpImages: TRadioGroup;
    TbshtLayoutStyle: TTabSheet;
    cbShowList: TCheckBox;
    GroupBox2: TGroupBox;
    cbPreviewThumbnail: TCheckBox;
    cbPreviewReport: TCheckBox;
    cbShowTree: TCheckBox;
    RgrpAutoSpeed: TRadioGroup;
    Label1: Tlabel;
    cbViewRemote: TCheckBox;
    GrpRIV: TGroupBox;
    Bevel1: TBevel;
    chkEnableRIVAuto: TCheckBox;
    chkVISNOnly: TCheckBox;
    chkHideEmptySites: TCheckBox;
    chkHideDisconnectedSites: TCheckBox;
    Label2: Tlabel;
    Label3: Tlabel;
    Label4: Tlabel;
    Label5: Tlabel;
    pnlItemClick: Tpanel;
    cbNotAutoSelect: TRadioButton;
    cbAutoSelect: TRadioButton;
    lbActCtrl: Tlabel;
    GroupBox3: TGroupBox;
    Bevel2: TBevel;
    chkRIVDoD: TCheckBox;
    tbshtAnnotation: TTabSheet;  {/p122 dmmn 7/11/11 - annotation settings /}
    lblAnnotMess: TLabel; {/p122 dmmn 7/11/11 /}
    annotShowWithImage: TCheckBox;    {/p122 dmmn 7/11/11 /}
    btnChangeGlobalSetting: TButton;
    actConfigSettings: TActionList;
    actAnnotAutoShow: TAction;    {/p122 dmmn 7/11/11 /}
    annotShowStrictRAD: TCheckBox; {/p122 dmmn 8/2/11 /}

    //procedure cbRevOrderClick(Sender: TObject);
    Procedure cbViewJBoxClick(Sender: Tobject);
    Procedure FormCreate(Sender: Tobject);
    Procedure cbShowAbsWindowClick(Sender: Tobject);
    Procedure cbShowImageListWinClick(Sender: Tobject);
    Procedure cbShowRadListwinClick(Sender: Tobject);
    Procedure btnCloseClick(Sender: Tobject);
    Procedure btnSaveClick(Sender: Tobject);
    Procedure cbShowMUSEClick(Sender: Tobject);
    Procedure FormDestroy(Sender: Tobject);
    Procedure cbShowNotesClick(Sender: Tobject);
    Procedure btnHelpClick(Sender: Tobject);
    Procedure cbViewRemoteClick(Sender: Tobject);
    Procedure chkEnableRIVAutoClick(Sender: Tobject);
    Procedure chkVISNOnlyClick(Sender: Tobject);
    Procedure chkHideEmptySitesClick(Sender: Tobject);
    Procedure chkHideDisconnectedSitesClick(Sender: Tobject);
    Procedure RbUseMagVideoViewerClick(Sender: Tobject);
    Procedure RbUseAltVideoViewerClick(Sender: Tobject);
    Procedure cbShowThumbsClick(Sender: Tobject);
    Procedure RgrpThumbsClick(Sender: Tobject);
    Procedure FormClose(Sender: Tobject; Var action: TCloseAction);
    procedure chkRIVDoDClick(Sender: TObject); {/ P117 NCAT  JK 12/2010 /}
    procedure btnChangeGlobalSettingClick(Sender: TObject);
    procedure actAnnotAutoShowExecute(Sender: TObject);
    procedure FormShow(Sender: TObject);   {/p122 dmmn 7/11/11 /}
    procedure annotShowStrictRADClick(Sender: TObject);
    procedure cbUseAltPDFViewerClick(Sender: TObject); {/p122 dmmn 8/3 /}

  Private
    { Private declarations }
    FAdminOnly: Boolean;
    Procedure ActiveControlChanged(Sender: Tobject);
  Public
    Procedure UpreftoUprefwindow(Upref: Tuserpreferences);
    Procedure UprefWindowSettingsToUpref(Var VUpref: Tuserpreferences);

  End;

Var
  FrmUserPref: TfrmUserPref;

Implementation
Uses
  FMagAbstracts,
  FMagImageList,
  FmagMain,
  Magpositions,
  Umagkeymgr,
  UMagDefinitions,
  Umagutils8,
//RCA  MaggMsgu
  imaginterfaces
  , fMagAnnotationOptionsX;

{$R *.DFM}

Procedure TfrmUserPref.cbViewJBoxClick(Sender: Tobject);
Begin
  //p72 IniViewJbox := FALSE; //cbViewJBox.checked;    // P8T14
  Upref.AbsViewJBox := False; //cbViewJBox.checked; // P8T14
End;

Procedure TfrmUserPref.FormCreate(Sender: Tobject);
Begin
//    Screen.OnActiveControlChange := self.ActiveControlChanged;
//p8t21  cbRevOrder.checked := IniRevorder;
  cbViewJBox.Checked := False; // IniViewJbox;   // p8t14
  GetFormPosition(Self As TForm);
  {
  // no longer check to see if consolidated to view remote images
  // JMW 6/20/2005 p45
  if WrksConsolidated then
    begin
      height := 400 ;
      //width := lbalign.Width;
      pnlViewRemote.Visible := true;
    end
    else
    begin
      height := 310;
      //width := lbalign.Width;
      pnlViewRemote.Visible := false;
    end;
    }
End;

Procedure TfrmUserPref.cbShowAbsWindowClick(Sender: Tobject);
Begin
  If cbShowAbsWindow.Checked Then
  Begin
    cbShowThumbs.Checked := True;
    RgrpThumbs.ItemIndex := 1;
  End
  Else
  Begin
    If cbShowThumbs.Checked Then RgrpThumbs.ItemIndex := 0;
  End;
End;

Procedure TfrmUserPref.cbShowMUSEClick(Sender: Tobject);
Begin
  Upref.Showmuse := cbShowMUSE.Checked;
End;

Procedure TfrmUserPref.cbShowImageListWinClick(Sender: Tobject);
Begin
  Upref.ShowImageListWin := cbShowImageListWin.Checked;
End;

Procedure TfrmUserPref.cbShowRadListwinClick(Sender: Tobject);
Begin
  Upref.ShowRadListWin := cbShowRadListwin.Checked;
End;

procedure TfrmUserPref.btnChangeGlobalSettingClick(Sender: TObject);
begin
  frmAnnotOptionsX.ShowModal;  {/p122 dmmn 7/11/11 /}
end;

Procedure TfrmUserPref.btnCloseClick(Sender: Tobject);
Begin
  Close;
End;

Procedure TfrmUserPref.btnSaveClick(Sender: Tobject);
Begin
  UprefWindowSettingsToUpref(Upref);
  Frmmain.Saveusersettings;
  ModalResult := MrOK; //p93  in
//p93 out  CLOSE;
End;

Procedure TfrmUserPref.FormDestroy(Sender: Tobject);
Begin
  SaveFormPosition(Self As TForm);
End;

procedure TfrmUserPref.FormShow(Sender: TObject);
begin
  if frmAnnotOptionsX.AutoShowAnnots = '0' then
    AnnotShowWithImage.Checked := False
  else
    AnnotShowWithImage.Checked := True;

  //p122 dmmn 8/2/11
//  if AnnotationOptionsX.StrictRAD = '0' then
//    annotShowStrictRAD.Checked := False
//  else
//    annotShowStrictRAD.Checked := True;
end;

Procedure TfrmUserPref.cbShowNotesClick(Sender: Tobject);
Begin
  Upref.Shownotes := cbShowNotes.Checked;
End;

Procedure TfrmUserPref.btnHelpClick(Sender: Tobject);
Begin
  Application.HelpContext(FrmUserPref.HelpContext);
End;

Procedure TfrmUserPref.UpreftoUprefwindow(Upref: Tuserpreferences);
Var
///.  li: Tlistitem;
  Vautoselect: Boolean;
  IsAbsWindowOpen: Boolean;
  IsAbsWindowVisible: Boolean;
  FAdminOnly: Boolean;
Begin
 {      First, put in the new settings.}
  IsAbsWindowVisible := False;
  IsAbsWindowOpen := Doesformexist('frmMagAbstracts');
  If IsAbsWindowOpen Then IsAbsWindowVisible := FrmMagAbstracts.Visible;

{Abstract & Image Viewers TAB}
  Self.cbShowThumbs.Checked := FrmImageList.PnlAbs.Visible Or IsAbsWindowVisible; {UprefToUprefWindow}
  {if abs is visible somewhere then }
  If cbShowThumbs.Checked Then
  Begin
    If FrmImageList.PnlAbs.Visible Then
      Self.RgrpThumbs.ItemIndex := 0 {UprefToUprefWindow}
    Else
      Self.RgrpThumbs.ItemIndex := 1; {UprefToUprefWindow}
  End
  Else {not cbShowThumbs.checked }
  Begin
     {  neither is visible, defalut to userpref.}
     {  0 Left, 1 bottom, 2 in Tree. 3 = Seperate Window (3 is new)}
    Case Upref.StylePositionOfAbs Of
      3: Self.RgrpThumbs.ItemIndex := 1;
    Else
      Self.RgrpThumbs.ItemIndex := 0;
    End; {case}
  End;

  If FrmImageList.Pnlfullres.Visible Then
    RgrpImages.ItemIndex := 0
  Else
    RgrpImages.ItemIndex := 1;

{Layout/ Style TAB}
  cbShowTree.Checked := FrmImageList.PnlTree.Visible;
  Upref.StyleShowTree := cbShowTree.Checked;
  cbShowList.Checked := FrmImageList.PnlMagListView.Visible;
  Upref.StyleShowList := cbShowList.Checked;
  cbAutoSelect.Checked := Upref.StyleAutoSelect;
  cbNotAutoSelect.Checked := Not cbAutoSelect.Checked;
  RgrpAutoSpeed.ItemIndex := Upref.StyleAutoSelectSpeed;
  cbPreviewThumbnail.Checked := FrmImageList.GetAbsPreview; //upref.ImageListPrevAbs;
  cbPreviewReport.Checked := FrmImageList.GetRptPreview; //upref.ImageListPrevReport;

  {      Done, Putting in the new settings.}
  Self.RbUseAltVideoViewer.Checked := Upref.UseAltViewerForVideo;
  {     if above isn't checked, we need this to force the checking of other }
  Self.RbUseMagVideoViewer.Checked := Not Upref.UseAltViewerForVideo;
  Self.cbPlayVideoOnOpen.Enabled := Self.RbUseMagVideoViewer.Checked;
  Self.cbPlayVideoOnOpen.Checked := Upref.PlayVideoOnOpen;
  Self.cbUseAltPDFViewer.Checked := Upref.UseAltViewerForPDF;

  chkEnableRIVAuto.Checked := Upref.RIVAutoConnectEnabled;
  chkVISNOnly.Checked := Upref.RIVAutoConnectVISNOnly;
  chkRIVDoD.Checked   := Upref.RIVAutoConnectDoD;   {/ P117 NCAT - JK 12/15/2010 /}
  chkHideDisconnectedSites.Checked := Upref.RIVHideDisconnectedSites;
  chkHideEmptySites.Checked := Upref.RIVHideEmptySites;

  GrpPatientSelected.Visible := True;
  GrpClin.Visible := True;

  cbShowAbsWindow.Checked := IsAbsWindowVisible; {UprefToUprefWindow}

   //93   cbshowImageListWin.checked := frmImageList.Visible;
   cbshowImageListWin.checked := upref.showImageListWin  ;  {UprefToUprefWindow}

  // if Admin ONLY we can stop here
  If (Not Userhaskey('MAGDISP CLIN')) Then
  Begin
    GrpClin.Visible := False;
    FAdminOnly := True;
    Exit;
  End;
  FAdminOnly := False;
  If Upref.GetRadListWin Then
  Begin
    cbShowRadListwin.Checked := Upref.ShowRadListWin;
  End;
  If Upref.Getmuse Then
  Begin
    cbShowMUSE.Checked := Upref.Showmuse;
  End;
  If Upref.Getnotes Then
  Begin
    cbShowNotes.Checked := Upref.Shownotes;
  End;
  cbViewRemote.Checked := Upref.AbsViewRemote;
End;

Procedure TfrmUserPref.UprefWindowSettingsToUpref(Var VUpref: Tuserpreferences);
Begin
 { TODO : All Settings should be set right here, depending on the Check status of the fields in the Window. }
  Upref.UseAltViewerForVideo := Self.RbUseAltVideoViewer.Checked;
  Upref.PlayVideoOnOpen := Self.cbPlayVideoOnOpen.Checked;
  Upref.UseAltViewerForPDF := Self.cbUseAltPDFViewer.Checked;

//p93 Gek.  Set User prefs with settings from this window.

  Upref.StyleAutoSelect := cbAutoSelect.Checked;
  Upref.StyleAutoSelectSpeed := RgrpAutoSpeed.ItemIndex;

  Upref.StyleShowTree := cbShowTree.Checked;
  Upref.StyleShowList := Self.cbShowList.Checked;

  Upref.StyleWhereToShowImage := Self.RgrpImages.ItemIndex; {UprefWindowSettingsToUpref}

  If cbShowThumbs.Checked Then
  Begin
    Upref.StyleWhetherToShowAbs := 1; {0 no show,  1 show}
    Case RgrpThumbs.ItemIndex Of
      0:
        Begin
          Upref.AbsShowWindow := False;
                  { it now says Abs Window, we need to change to List Win}
                  {we'll default to 0; 0 Left, 1 bottom, 2 in Tree, 3 Abs Window }
          If Upref.StylePositionOfAbs = 3 Then Upref.StylePositionOfAbs := 0;
        End;
      1:
        Begin
          Upref.AbsShowWindow := True;
          Upref.StylePositionOfAbs := 3;
        End;
    End; {case}
  End
  Else
  Begin
    Upref.StyleWhetherToShowAbs := 0; {0 no show,  1 show}
    Upref.AbsShowWindow := False;
  End;

  {/P122 dmmn 7/11/11 - annotation preferences /}
  // Store globalsetting
  Upref.ArtXSettingsDisplay := frmAnnotOptionsX.UserPreferences;

End;

Procedure TfrmUserPref.cbViewRemoteClick(Sender: Tobject);
Begin
//  P72     IniViewRemoteAbs := cbViewRemote.checked;
  Upref.AbsViewRemote := cbViewRemote.Checked;
End;

{/ P117 NCAT - JK 12/2010 /}
procedure TfrmUserPref.chkRIVDoDClick(Sender: TObject);
begin
  Upref.RIVAutoConnectDod := chkRIVDod.Checked;
end;

Procedure TfrmUserPref.chkEnableRIVAutoClick(Sender: Tobject);
Begin
  Upref.RIVAutoConnectEnabled := chkEnableRIVAuto.Checked;
  If Not chkEnableRIVAuto.Checked Then
  Begin
    chkVISNOnly.Checked := False;
    chkVISNOnly.Enabled := False;
    Upref.RIVAutoConnectVISNOnly := False;
  End
  Else
  Begin
    chkVISNOnly.Enabled := True;
  End;
End;

Procedure TfrmUserPref.chkVISNOnlyClick(Sender: Tobject);
Begin
  Upref.RIVAutoConnectVISNOnly := chkVISNOnly.Checked;
End;

Procedure TfrmUserPref.chkHideEmptySitesClick(Sender: Tobject);
Begin
  Upref.RIVHideEmptySites := chkHideEmptySites.Checked;
End;

Procedure TfrmUserPref.chkHideDisconnectedSitesClick(Sender: Tobject);
Begin
  Upref.RIVHideDisconnectedSites := chkHideDisconnectedSites.Checked;
End;

Procedure TfrmUserPref.RbUseMagVideoViewerClick(Sender: Tobject);
Begin
  cbPlayVideoOnOpen.Enabled := True;
End;

Procedure TfrmUserPref.RbUseAltVideoViewerClick(Sender: Tobject);
Begin
  cbPlayVideoOnOpen.Enabled := False;

  {/ P122 - JK 9/7/2011 per Larry Carlson request at the P122 PD WPR. /}
  if rbUseAltVideoViewer.Checked and Self.Showing then
    MagAppMsg('d', 'Warning: if a video contains ' + GSess.Agency.AgencyDBName + ' annotations they will not be displayed in an external video viewer');

  if rbUseAltVideoViewer.Checked then
    label3.Caption := 'Choose what viewer to use for the following image file formats.' + #13#10 +
                      'Warning: external viewers do not display ' + GSess.Agency.AgencyDBName + ' annotations.'
  else
    label3.Caption := 'Choose what viewer to use for the following image file formats.';
End;

Procedure TfrmUserPref.cbShowThumbsClick(Sender: Tobject);
Begin
  If cbShowThumbs.Checked Then
  Begin
    cbShowAbsWindow.Checked := (RgrpThumbs.ItemIndex = 1);
  End
  Else
    cbShowAbsWindow.Checked := False;
End;

procedure TfrmUserPref.cbUseAltPDFViewerClick(Sender: TObject);
begin
  {/ P122 - JK 9/7/2011 per Larry Carlson request at the P122 PD WPR. /}
  if cbUseAltPDFViewer.Checked and Self.Showing then
    MagAppMsg('d', 'Warning: if a PDF file contains ' + GSess.Agency.AgencyDBName + ' annotations they will not be displayed in an external PDF viewer');

  if cbUseAltPDFViewer.Checked then
    label3.Caption := 'Choose what viewer to use for the following image file formats.' + #13#10 +
                      'Warning: external viewers do not display ' + GSess.Agency.AgencyDBName + ' annotations.'
  else
    label3.Caption := 'Choose what viewer to use for the following image file formats.';

end;

Procedure TfrmUserPref.RgrpThumbsClick(Sender: Tobject);
Begin
  If cbShowThumbs.Checked Then
  Begin
    If RgrpThumbs.ItemIndex = 1 Then cbShowAbsWindow.Checked := True;
    If RgrpThumbs.ItemIndex = 0 Then cbShowAbsWindow.Checked := False;
  End;
End;

procedure TfrmUserPref.actAnnotAutoShowExecute(Sender: TObject);
begin
  if AnnotShowWithImage.Checked then
    frmAnnotOptionsX.AutoShowAnnots := '1'
  else
    frmAnnotOptionsX.AutoShowAnnots := '0';
end;

Procedure TfrmUserPref.ActiveControlChanged(Sender: Tobject);
Var
  doEnter, doExit: Boolean;
  previousActiveControl: TWinControl;
Begin
  Try
    If Screen.ActiveControl = Nil Then
    Begin
      Exit;
    End;
    Try
      If Screen.ActiveControl.Name <> '' Then

        lbActCtrl.caption := 'Active Control : ' + Screen.ActiveControl.Name
      Else
        lbActCtrl.caption := 'Active Control :  No Name';
    Except
        //
    End;

  Except

  End;
End;

procedure TfrmUserPref.annotShowStrictRADClick(Sender: TObject);
begin
  //p122 dmmn 8/3
//  if annotShowStrictRAD.Checked then
//    AnnotationOptionsX.StrictRAD := '1'
//  else
//    AnnotationOptionsX.StrictRAD := '0';
end;

Procedure TfrmUserPref.FormClose(Sender: Tobject;
  Var action: TCloseAction);
Begin
  Screen.OnActiveControlChange := Nil;
End;

End.
