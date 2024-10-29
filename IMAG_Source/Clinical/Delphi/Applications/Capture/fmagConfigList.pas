Unit FmagConfigList;
   {
   Package: MAG - VistA Imaging
   WARNING: Per VHA Directive 10-93-142 this unit should not be modified.
   Date Created:
   Site Name: Silver Spring, OIFO
   Developers: Garrett Kirin
   Description: Imaging Configuration List window.
   (lists all defined configurations) for this workstation.
   Patch 59.  Allows user to drag and drop list items to change order.
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

  ComCtrls,
  Controls,
  ExtCtrls,
  Forms,
  Menus,
  Messages,
  Stdctrls,
  ImgList,
  ToolWin,

  cMagListView,
  imaginterfaces,
  magbroker   ,
  trpcb ,
  dateutils ,
  umagdefinitions ,
  uMagCapDef



  ;

//Uses Vetted 20090929:maggut1, umagdefinitions, CheckLst, ToolWin, ImgList, Buttons, Grids, Graphics, umagkeymgr, umagutils, umagclasses, magguini, cmagLabelNoClear, magpositions, fmagCapConfig, fmagCapMain, inifiles, Dialogs, SysUtils, Windows

Type
  TfrmConfigList = Class(TForm)
    ImglstCfgList: TImageList;
    StatusBar1: TStatusBar;
    Panel2: Tpanel;
    MainMenu1: TMainMenu;
    File1: TMenuItem;
    Save1: TMenuItem;
    SaveAs1: TMenuItem;
    Delete2: TMenuItem;
    N1: TMenuItem;
    Exit1: TMenuItem;
    Options1: TMenuItem;
    Apply1: TMenuItem;
    SpltCfgList: TSplitter;
    HeaderControl1: THeaderControl;
    TlbrMain: TToolBar;
    btnSave: TToolButton;
    btnSaveAs: TToolButton;
    btnDelete: TToolButton;
    btnSettings: TToolButton;
    btnClose: TToolButton;
    Panel3: Tpanel;
    LblSource: Tlabel;
    LblSourceDesc: Tlabel;
    LblFormatDesc: Tlabel;
    LblAssociationDesc: Tlabel;
    LblSavingDesc: Tlabel;
    LblModeDesc: Tlabel;
    LblOtherDesc: Tlabel;
    LblOther: Tlabel;
    LblMode: Tlabel;
    LblSaving: Tlabel;
    LblAssociation: Tlabel;
    LblFormat: Tlabel;
    Settings2: TMenuItem;
    N2: TMenuItem;
    StayOnTop1: TMenuItem;
    btnOK: TToolButton;
    Help1: TMenuItem;
    Help2: TMenuItem;
    LvwCfgList: TMagListView;
    ResizeColumns1: TMenuItem;
    FitColumnstoForm1: TMenuItem;
    View1: TMenuItem;
    List1: TMenuItem;
    Details1: TMenuItem;
    MaglistviewFields: TMagListView;
    ColumnSelect1: TMenuItem;
    N3: TMenuItem;
    LblSelectedCfg: Tlabel;
    MnuCfgList: TPopupMenu;
    MnuApplylistitem: TMenuItem;
    Save2: TMenuItem;
    MnuDeleteListItem: TMenuItem;
    N4: TMenuItem;
    MnuToolbar: TMenuItem;
    ListBox1: TListBox;
    tbWorkstations: TToolButton;
    Panel1: TPanel;
    GroupBox1: TGroupBox;
    Label1: TLabel;
    Label3: TLabel;
    dDtfr: TDateTimePicker;
    dDtto: TDateTimePicker;
    tbDateRange: TToolButton;
    rbAnyLogon: TRadioButton;
    rbLastLogon: TRadioButton;
    pnlWrksName: TPanel;
    lbWrkslabel: TLabel;
    lbWrks: TLabel;
    ToolButton3: TToolButton;
    Workstationslist1: TMenuItem;
    DateRange1: TMenuItem;
    N5: TMenuItem;
    ApplythisWorkstationConfigurations1: TMenuItem;
    Procedure FormCreate(Sender: Tobject);
    Procedure FormDestroy(Sender: Tobject);
    Procedure LvwCfgListChange(Sender: Tobject; Item: TListItem;
      Change: TItemChange);
    Procedure MReSizeClick(Sender: Tobject);
    Procedure Delete1Click(Sender: Tobject);
    Procedure Settings1Click(Sender: Tobject);
    Procedure LvwCfgListEnter(Sender: Tobject);
    Procedure LvwCfgListExit(Sender: Tobject);
    Procedure FormClose(Sender: Tobject; Var action: TCloseAction);
    Procedure Apply1Click(Sender: Tobject);
    Procedure btnDeleteClick(Sender: Tobject);
    Procedure Delete2Click(Sender: Tobject);
    Procedure btnSettingsClick(Sender: Tobject);
    Procedure Settings2Click(Sender: Tobject);
    Procedure btnSaveClick(Sender: Tobject);
    Procedure Save1Click(Sender: Tobject);
    Procedure btnSaveAsClick(Sender: Tobject);
    Procedure SaveAs1Click(Sender: Tobject);
    Procedure btnCloseClick(Sender: Tobject);
    Procedure Exit1Click(Sender: Tobject);
    Procedure StayOnTop1Click(Sender: Tobject);
    Procedure btnOKClick(Sender: Tobject);
    Procedure LvwCfgListDblClick(Sender: Tobject);
    Procedure btnApplyClick(Sender: Tobject);
    Procedure FormShow(Sender: Tobject);
    Procedure File1Click(Sender: Tobject);
    Procedure Options1Click(Sender: Tobject);
    Procedure ResizeColumns1Click(Sender: Tobject);
    Procedure FitColumnstoForm1Click(Sender: Tobject);
    Procedure List1Click(Sender: Tobject);
    Procedure Details1Click(Sender: Tobject);
    Procedure ColumnSelect1Click(Sender: Tobject);
    Procedure Save2Click(Sender: Tobject);
    Procedure MnuDeleteListItemClick(Sender: Tobject);
    Procedure MnuApplylistitemClick(Sender: Tobject);
    Procedure LvwCfgListKeyDown(Sender: Tobject; Var Key: Word; Shift: TShiftState);
    Procedure MnuToolbarClick(Sender: Tobject);
    Procedure Help2Click(Sender: Tobject);
    Procedure LvwCfgListColumnClick(Sender: Tobject; Column: TListColumn);
    Procedure LvwCfgListDragOver(Sender, Source: Tobject; x, y: Integer; State: TDragState; Var Accept: Boolean);
    Procedure LvwCfgListDragDrop(Sender, Source: Tobject; x, y: Integer);
    procedure tbDateRangeClick(Sender: TObject);
    procedure tbWorkstationsClick(Sender: TObject);
    procedure dDtfrChange(Sender: TObject);
    procedure dDttoChange(Sender: TObject);
    procedure ApplythisWorkstationConfigurations1Click(Sender: TObject);
  Private
    Procedure ApplySelectedConfiguration;
    Procedure DeleteSelectedConfig;
    Procedure DisplaySelectedConfig(Li: TListItem);
    Procedure SelectConfig(Desc: String);
    Function DoesConfigurationExist(Desc: String): Boolean;

    Procedure EnableDisable;
    Procedure SaveConfigsToINI;
    Procedure ResizeColumns;
    Procedure WMGetMinMaxInfo(Var Message: TWMGetMinMaxInfo); Message WM_GetMinMaxInfo;
    Function GetCurrentLockedFields: String;
    Procedure LockedFldsToList(Li: TListItem);
    Procedure DisplaySettings(Li: TListItem);
    Procedure FieldValuesToList(Li: TListItem);

    Procedure WinMsg(s: String);
    Procedure ClearSettingsDisplayed;
    Function ItemsWereMoved: Boolean;
    procedure GetFromToDates(var Dtfr, Dtto, DisFrom, DisTo: String);


  Public
    FWinCaption : string;
    Fconfiglist: TStrings;
    //p140
    procedure NewUpdateTheWrksList;

    Function ApplyClearConfiguration(Var Rmsg: String): Boolean;
    Procedure LoadListView(Vconfiglist: TStrings);
    Procedure UnLockAllFields;
    Procedure SaveConfiguration(ConfigDesc: String); Overload;
    Procedure SaveConfiguration(ConfigIndex: Integer); Overload;
    Procedure SaveConfiguration(Li: TListItem = Nil); Overload;
    Procedure SaveSettingAs;
    Procedure SaveNewConfig(Desc: String);
    Procedure GetSavedConfigs(vINI : string = ''; wrks : string = '');
    Procedure ShowAsButtons(Ptabcontrol: TTabControl);
    Function ApplyConfiguration(Desc: String; Var Rmsg: String): Boolean;
 {	Get the Index of the item from the item description}
    Function CfgIndexFromDesc(Desc: String): Integer;

  End;

Var
  FrmConfigList: TfrmConfigList;

Implementation

Uses
  cMagLabelNoClear,
  Dialogs,
  FEdtLVlink,
  FmagCapConfig,
  FmagCapMain,
  Inifiles,
  Magguini,
  Magpositions,
  SysUtils,
  UMagClasses,
  Umagkeymgr,
  Umagutils8,
  Windows,
   MagWrksListView,
  MagSessionInfo,

  Maggut1

  ;

{$R *.DFM}

Function TfrmConfigList.CfgIndexFromDesc(Desc: String): Integer;
Var
  i: Integer;
Begin
  Result := -1;
  For i := 0 To Fconfiglist.Count - 1 Do
  Begin
    If MagPiece(Fconfiglist[i], '^', 1) = Desc Then
    Begin
      Result := i;
      Break;
    End;
  End;
End;

Procedure TfrmConfigList.WMGetMinMaxInfo(Var Message: TWMGetMinMaxInfo);
Var
  Hy, Wx: Integer;
Begin
  Hy := Trunc(270 * (Pixelsperinch / 96));
  Wx := Trunc(470 * (Pixelsperinch / 96));
  With Message.Minmaxinfo^ Do
  Begin
    PtMinTrackSize.x := Wx;
    PtMinTrackSize.y := Hy;
  End;
  Message.Result := 0;
  Inherited;

End;

Procedure TfrmConfigList.GetSavedConfigs(vINI : string = ''; wrks : string = '');
// replaces LoadHotButtons
Var
  i: Integer;
  Tempini: TIniFile;
  s: String;
  tWrks : string;
Begin
if (vINI <> '')
   then  Tempini := TiniFile.create(vINI)
  else
    begin
     Tempini := TIniFile.Create(GetConfigFileName);
       {  [SYS_AUTOUPDATE]
          ComputerName=ISW-KIRIN-LT}
     tWrks := GetINiEntry('SYS_AUTOUPDATE','ComputerName');
     self.Caption := self.FWinCaption + ': ' + tWrks;

    end;
  if wrks <> ''
    then
     begin
     lbWrks.caption := wrks;
      pnlWrksName.Visible := true;
      frmCapMain.pnlWrksCfg.caption := wrks;
      frmCapMain.pnlWrksCfg.Visible := true;
     end
     else
     begin
       lbWrks.Caption := '';
       pnlWrksName.visible := false;
       Caption := FWinCaption;
             frmCapMain.pnlWrksCfg.caption := '<workstation>';
      frmCapMain.pnlWrksCfg.Visible := false;
     end;


  Try
  // clear the current list of configurations.
    Fconfiglist.Clear;
    ListBox1.Clear;
    ListBox1.Sorted := False;
    i := 1;
    While Tempini.ReadString('SYS_CONFIGURATIONS', Inttostr(i), 'NOBUTTON') <> 'NOBUTTON' Do
    Begin
     // p59t14    Fconfiglist.add(tempini.readstring('SYS_CONFIGURATIONS', inttostr(i), 'NOBUTTON'));
      s := Tempini.ReadString('SYS_CONFIGURATIONS', Inttostr(i), 'NOBUTTON');
      Fconfiglist.Add(s);
      Inc(i);
    End;
 //////////////  TESTING TEST TEST    GET THIS OUT OF CODE !!! AFTER tEST
//Fconfiglist.SaveToFile('c:\temp\configlist9.txt');


  (*listbox1.Items.AddStrings(configlist);
  configlist.Clear;
  //listbox1.Sorted := true;
  configlist.AddStrings(listbox1.Items); // Assign(listbox1.Items);
    *)
    LoadListView(Fconfiglist);
  Finally
    Tempini.Free;
        ShowAsButtons(Frmcapmain.TabCtr);
  End;
End;

Procedure TfrmConfigList.LoadListView(Vconfiglist: TStrings);
//var i, j: integer;
//  Li: Tlistitem;
Begin
  Vconfiglist.Insert(0, 'Configuration^Source^Format^Association^Single/Group^Mode^Other');
  LvwCfgList.LoadListFromStrings(Vconfiglist);
  Vconfiglist.Delete(0);
  Exit;
(*  lvwCfgList.Items.clear;
  lvwCfgList.AllocBy := configlist.count;
  for I := 0 to configlist.count - 1 do
    begin

      Li := lvwCfgList.Items.Add;
    // we start from $p 2 because 1 is always '';
      Li.Caption := magpiece(configlist[i], '^', 1);
    // below is where we were adding extra subitems to existing LI
      for J := 2 to 7 do // 00t 6/1/02 8 ->  11, 8 for LockedFlds, 9-11 for indexFlds
      // 9/28/02    12 for image desc
        begin
          Li.SubItems.Add(magpiece(configlist[i], '^', j));
        end;
    end;
  StatusBar1.panels[0].text := inttostr(configlist.count) + ' stored Configurations';
  lvwCfgList.visible := true;
*)
End;

Procedure TfrmConfigList.ShowAsButtons(Ptabcontrol: TTabControl);
Var
//  tbut          : tbutton;
  i: Integer;
  //bw, bh, cl : integer;
//li : Tlistitem;
Begin
  Ptabcontrol.Tabs.Clear;
  If LvwCfgList.Items.Count = 0 Then Exit;
  For i := 0 To LvwCfgList.Items.Count - 1 Do
  Begin
    Ptabcontrol.Tabs.Add(LvwCfgList.Items[i].caption);
  End;
  Ptabcontrol.TabIndex := -1;
  Frmcapmain.RedisplayMultiline;

  (*
 ptabcontrol.Tabs.Clear;
  if configlist.count = 0 then EXIT;
  for i := 0 to configlist.count - 1 do
    begin
      ptabcontrol.Tabs.Add(magpiece(configlist[i], '^', 1));
    end;
  ptabcontrol.TabIndex := -1;
  frmCapMain.RedisplayMultiline;*)
End;

Function TfrmConfigList.ApplyConfiguration(Desc: String; Var Rmsg: String): Boolean;
Var
  ConfigIndex: Integer;
//valres : boolean;
  Valmsg: String;
  magtag : integer;

  Function ValidateConfiguration(bindex: Integer; Var Disabledmsg: String; ApplyConfig: Boolean): Boolean;
  Var
    i: Integer;
    Hbgroup, Hbsource, Hbtype, Hbspec, Hbfilmsize, Hbmode: String;
    Hktype, HkSpecSubSpec, HkProcEvent, HkImageDesc, Hkorigin: String;
    HkMultipleCapture, HkPDFconvert : string; //p140t1
    Lockedflds: String;
    ConfigName: String;
    Templist: Tstringlist;
    ClinDataStr: String;
  Begin
              //NNConfig
                  {       Apply a saved configuration.}
    Result := True; {patch 59, allow testing configuration before applying
                              it, this way we will stop 'Partial Applying of configurations'}
           // configname := lvwCfgList.Items[bindex].Caption;
    ConfigName := MagPiece(Fconfiglist[bindex], '^', 1);
    Disabledmsg := '';
    Frmcapmain.FLastSelectedConfig := ConfigName;
    Hbsource := MagPiece(Fconfiglist[bindex], '^', 2);
    Hbtype := MagPiece(Fconfiglist[bindex], '^', 3);
    Hbspec := MagPiece(Fconfiglist[bindex], '^', 4);
            {TODO: Here variables for NewNote and NewStatus if they exist.
                    Have to load the TClinicalData object:   FCapClinDataObj later}
    Hbgroup := MagPiece(Fconfiglist[bindex], '^', 5);
    Hbmode := MagPiece(Fconfiglist[bindex], '^', 6);
    Hbfilmsize := MagPiece(Fconfiglist[bindex], '^', 7);
    Lockedflds := MagPiece(Fconfiglist[bindex], '^', 8); // oot 7/1/02
    Hktype := MagPiece(Fconfiglist[bindex], '^', 9);
    HkSpecSubSpec := MagPiece(Fconfiglist[bindex], '^', 10);
    HkProcEvent := MagPiece(Fconfiglist[bindex], '^', 11);
    HkImageDesc := MagPiece(Fconfiglist[bindex], '^', 12);
    Hkorigin := MagPiece(Fconfiglist[bindex], '^', 13);
    If Hkorigin = '' Then Hkorigin := '0';
//140 get to field.  Never Apply this,  Always set to False
//    HkMultipleCapture := MagPiece(Fconfiglist[bindex], '^', 14);
    HkMultipleCapture := 'FALSE';
    HkPDFconvert := MagPiece(Fconfiglist[bindex], '^', 15);

    ClinDataStr := MagPiece(Fconfiglist[bindex], '|', 2); //NNconfig

    If ((Not Userhaskey('MAG NOTE EFILE')) And (MagPiece(ClinDataStr, '^', 6) = '1')) Then
    Begin
      Result := False;
      Messagebeep(2);
      //maggmsgf.magmsg('e', 'Configuration ' + configname + ' Not Applied. EFile Security Key is needed.', frmCapMain.pmsg);
      MagAppMsg('e', 'Configuration ' + ConfigName + ' Not Applied. EFile Security Key is needed.');
      Frmcapmain.Pmsg.Caption  := 'Configuration ' + ConfigName + ' Not Applied. EFile Security Key is needed.';
      Exit;
    End;

    Templist := Tstringlist.Create;
    Try // oot 7/1/02
      For i := 1 To Maglength(Lockedflds, ',') Do
        Templist.Add(MagPiece(Lockedflds, ',', i));

    frmCapConfig.cbMultipleCapture.Checked := UPPERCASE(HkMultipleCapture) = 'TRUE' ;
    frmCapConfig.cbPDFconvert.Checked := UPPERCASE(HkPDFconvert) = 'TRUE'   ;

      With FrmCapConfig Do
      Begin
        If Not GAssociation.Enabled Then
        Begin
          For i := 0 To GAssociation.ControlCount - 1 Do
            If (GAssociation.Controls[i].Name = Hbspec)
              And (TRadioButton(GAssociation.Controls[i]).Checked = False) Then
            Begin
              Disabledmsg := Disabledmsg + #13 + #13
                + 'Association ''' + Frmcapmain.ReadableShortAssocRBName(Hbspec) + ''' is Disabled for this Workstation/User'
                + #13 + '     switching Association can not be applied.';
              Result := False;
            End;
        End;
        If GAssociation.Enabled Then
        Begin
          For i := 0 To GAssociation.ControlCount - 1 Do
          Begin
            If Not (GAssociation.Controls[i] Is TRadioButton) Then Continue;
            If TRadioButton(GAssociation.Controls[i]).Name = Hbspec Then
            Begin
              If TRadioButton(GAssociation.Controls[i]).Enabled = False Then
              Begin
                Disabledmsg := Disabledmsg + #13 + #13
                  + 'Association ''' + Frmcapmain.ReadableShortAssocRBName(Hbspec) + ''' is Disabled for this Workstation/User'
                  + #13 + '     switching Association can not be applied.';
                Result := False;
                Break;
              End;
                                 { force a Radiobutton click to init the photo ID.{}
              If TRadioButton(GAssociation.Controls[i]).Name = 'PhotoID' Then
                If ApplyConfig Then TRadioButton(GAssociation.Controls[i]).Checked := False;
              If ApplyConfig Then TRadioButton(GAssociation.Controls[i]).Checked := True;
                              {TODO: above, we just checked NOTE, (maybe), if we did
                                     then we need to apply NewNote Title and NewNote Status
                                     if they exist.}
              If ((Hbspec = 'TIU') And ApplyConfig) Then
              Begin
                Frmcapmain.FCapClinDataObj.Free;
                Frmcapmain.FCapClinDataObj := TClinicalData.Create;
                Frmcapmain.FCapClinDataObj.Pkg := '8925';
                If (ClinDataStr <> '') {//NNconfig} Then Frmcapmain.LoadClinicalDataFromConfiguration(ClinDataStr);
                Frmcapmain.LoadFieldsFromClinicalData(Frmcapmain.FCapClinDataObj);
                TRadioButton(GAssociation.Controls[i]).Checked := True;
              End;
            End;
          End;
        End;
                   frmCapMain.Update; {p129 debug}
                    {IF gImageGroup.enabled then
                     begin}
        For i := 0 To GImageGroup.ControlCount - 1 Do
        Begin
          If Not (GImageGroup.Controls[i] Is TRadioButton) Then Continue;
          If TRadioButton(GImageGroup.Controls[i]).Name = Hbgroup Then
          Begin
            If TRadioButton(GImageGroup.Controls[i]).Enabled = False Then
            Begin
              Disabledmsg := Disabledmsg + #13 + #13
                + 'Group/Single :''' + Hbgroup + ''' is Disabled for this Workstation/User'
                + #13 + '     Switching Group/Single can not be applied.';
              Result := False;
              Break;
            End;
            If ApplyConfig Then TRadioButton(GImageGroup.Controls[i]).Checked := True;
          End;
        End;
        frmCapMain.Update; {p129 debug}
        magtag := magcfgSource;
        For i := 0 To ComponentCount - 1 Do
        Begin
          if Components[i].Tag <> magtag then  continue;

          //If Not (GInputSource.Controls[i] Is TRadioButton) Then Continue;
          If TRadioButton(Components[i]).Name = Hbsource Then
          Begin
            If TRadioButton(Components[i]).Enabled = False Then
            Begin
              Disabledmsg := Disabledmsg + #13 + #13
                + 'Input Source ''' + Hbsource + ''' is Disabled for this Workstation/User'
                + #13 + '     switching Input Source can not be applied.';
              Result := False;
              Break;
            End;
            If ApplyConfig Then
            Begin
              TRadioButton(Components[i]).Checked := True;
              If Uppercase(Hbsource) = 'METEOR' Then
              Begin
                cbMeteorInt.Checked := (Uppercase(Hbfilmsize) = 'INTERACTIVE');
              End;
              If Uppercase(Hbsource) = 'IMPORT' Then
              Begin
                Frmcapmain.cbBatch.Checked := (Pos('BATCH', Uppercase(Hbfilmsize)) > 0);
                If MagPiece(Hbfilmsize, ';', 2) <> '' Then
                  Frmcapmain.SelectImportDirectory4(MagPiece(Hbfilmsize, ';', 2), True);
              End;
              If (Uppercase(Hbfilmsize) = 'MULTI PAGE') Then
              Begin
                If Not Frmcapmain.cbALLPages.Enabled Then Frmcapmain.cbALLPages.Enabled := True;
                frmCapMain.AllPagesChecked(true);
              End
              Else
                 frmCapmain.AllPagesChecked(false);
                //Frmcapmain.cb ALLPages.Checked := False;
            End;
          End;
        End;
                    frmCapMain.Update; {p129 debug}
        magtag := magcfgFormat;
        //For i := 0 To GImageFormat.ControlCount - 1 Do
        For i := 0 To ComponentCount - 1 Do
        Begin
                    frmCapMain.Update; {p129 debug}
          {Pre 117 we stopped if Import, because no other Hbtype are (were) allowed.}
          //p117 gek out in 117 to allow DicomFormat
          //If Uppercase(Hbsource) = 'IMPORT' Then Break;

          //If Not (GImageFormat.Controls[i] Is TRadioButton) Then Continue;
          If (components[i].Tag <> magtag) Then Continue;
          If TRadioButton(components[i]).Name = Hbtype Then
          Begin
            If TRadioButton(components[i]).Enabled = False Then
            Begin
              Disabledmsg := Disabledmsg + #13 + #13
                + 'Image Format ''' + Hbtype + ''' is Disabled for this Workstation/User'
                + #13 + '     switching Image Format can not be applied.';
              Result := False;
              Break;
            End;

            If ApplyConfig Then TRadioButton(components[i]).Checked := True;
          End;
        End;

                  { moved to be first , other dependencies 'single, group' need this first
                  if not gAssociation.enabled then
                    begin
                      etc, etc, etc,
                    end;
                   }
            frmCapMain.Update; {p129 debug}
        For i := 0 To GMode.ControlCount - 1 Do
        Begin
          If Not (GMode.Controls[i] Is TRadioButton) Then Continue;
          If TRadioButton(GMode.Controls[i]).Name = Hbmode Then
          Begin
            If TRadioButton(GMode.Controls[i]).Enabled = False Then
            Begin
              Disabledmsg := Disabledmsg + #13 + #13
                + 'Mode ''' + Hbmode + ''' is Disabled for this Workstation/User'
                + #13 + '     switching Mode can not be applied.';
              Result := False;
              Break;
            End;

            If ApplyConfig Then TRadioButton(GMode.Controls[i]).Checked := True;
          End;
        End;

        If Not ApplyConfig Then Exit;
                    frmCapMain.Update; {p129 debug}
        If Hbfilmsize <> '' Then
        Begin
          If Hbfilmsize = '0' Then cbMeteorInt.Checked := False;
          If Hbfilmsize = '1' Then cbMeteorInt.Checked := True;
          If Lum100choice.Items.Indexof(Hbfilmsize) > -1 Then
          Begin
            Lum100choice.ItemIndex := Lum100choice.Items.Indexof(Hbfilmsize);
            Lum100choiceChange(Self);
          End;
        End;
      End;
            frmCapMain.Update; {p129 debug}
              // { DONE : HAVE TO Clear all NoClears first URGENT }
      UnLockAllFields;
      For i := 0 To Frmcapmain.SbxEditFields.ControlCount - 1 Do
      Begin
        If (Frmcapmain.SbxEditFields.Controls[i] Is TmagLabelNoClear) Then
        Begin
          If (Templist.Indexof(TmagLabelNoClear(Frmcapmain.SbxEditFields.Controls[i]).caption) > -1) Then
            TmagLabelNoClear(Frmcapmain.SbxEditFields.Controls[i]).NoClear := True
          Else
            TmagLabelNoClear(Frmcapmain.SbxEditFields.Controls[i]).NoClear := False;
        End;
      End;
            frmCapMain.Update; {p129 debug}
              // oot 7/12/02  have to apply saved Values for Type, Spec, Proc
      Frmcapmain.RefreshIndexLists; // 02/25/03   Index lists weren't being updated because
                // the current filtered list(Spec, and Proc) might not have the new values
                //  listed.  so Refresh Index Lists first, then
      Frmcapmain.EdtType.Text := Hktype;
      Frmcapmain.LvType.Selected := Nil;
      If Not FEdtLV.GenOldTextInNewLV(Hktype, Frmcapmain.LvType) Then Frmcapmain.EdtType.Text := '';
      Frmcapmain.LOOKUPIndexType;
               { DONE :   HAVE to refresh INDEX Lists first URGENT}
      Frmcapmain.EdtSpecSubSpec.Text := HkSpecSubSpec;
      Frmcapmain.LvSpecSubSpec.Selected := Nil;
      If Not FEdtLV.GenOldTextInNewLV(HkSpecSubSpec, Frmcapmain.LvSpecSubSpec) Then Frmcapmain.EdtSpecSubSpec.Text := '';
      Frmcapmain.UpdateProcFromSpec; // 02/25/03

      Frmcapmain.EdtProcEvent.Text := HkProcEvent;
      Frmcapmain.LvProcEvent.Selected := Nil;
      If Not FEdtLV.GenOldTextInNewLV(HkProcEvent, Frmcapmain.LvProcEvent) Then Frmcapmain.EdtProcEvent.Text := '';
      Frmcapmain.UpdateSpecFromProc; // 02/25/03

      Frmcapmain.cbOrigin.ItemIndex := Strtoint(Hkorigin);
      Frmcapmain.ShowNoteGlyphs(Frmcapmain.FCapClinDataObj);
      If ClinDataStr <> '' Then Frmcapmain.LoadFieldsFromClinicalData(Frmcapmain.FCapClinDataObj);

             {       moved from above.  The Default of using Note Title for Image Desc
                     was overwriting the ImageDesc that was saved with Config.}
      Frmcapmain.EdtImageDesc.Text := HkImageDesc;
    Finally
      Templist.Free;
    End;
    //If Frmcapmain.cb ALLPages.Checked And

    If CapX.mMultipage  then
         if (UPPERCASE(hkPDFConvert) <> 'TRUE') And
      Not ((Hbtype = 'ColorScan') Or (Hbtype = 'Document') Or (Hbtype = 'DocumentG4')) Then
    Begin
       frmCapMain.AllPagesChecked(false);
      //Frmcapmain.cb ALLPages.Checked := False;
      Disabledmsg := Disabledmsg + 'Multi-Page setting was turned Off. (unChecked)'
        + #13 + 'It can only be used with "Scanned Document" - "TIF G4".';

    End;

    frmCapConfig.cbMultipleCapture.Checked := UPPERCASE(HkMultipleCapture) = 'TRUE' ;
    frmCapConfig.cbPDFconvert.Checked := UPPERCASE(HkPDFconvert) = 'TRUE'   ;


    If Disabledmsg = '' Then
    Begin
      Rmsg := 'Configuration ' + '"' + ConfigName + '"' + ' has been applied.';
      WinMsg(Rmsg)
    End
    Else
    Begin
      Rmsg := Disabledmsg;
              //maggmsgf.magmsg('d', 'Configuration ' + '"' + configname + '"' + ' was only Partially applied.' + #13 + disabledmsg, nil);
      MagAppMsg('d', 'Configuration ' + '"' + ConfigName + '"' + ' was only Partially applied.' + #13 + Disabledmsg);
      WinMsg('Configuration ' + '"' + ConfigName + '"' + ' was only Partially applied.');
    End;
  End;
{ This is the Begin of the function: TfrmConfigList.ApplyConfiguration(desc : string): boolean;}
Begin
  Rmsg := '';
  ConfigIndex := FrmConfigList.CfgIndexFromDesc(Desc);
  If Not ValidateConfiguration(ConfigIndex, Valmsg, True) Then
  Begin

     //maggmsgf.magmsg('','Validate Configuration Failed.');
    MagAppMsg('', 'Validate Configuration Failed.'); 

  End;
{  Below was a good try, testing all changes before applying any,
   but the Input device must be applied before we
   can test for Image Format being valid for the configuration }
(*
if ValidateConfiguration(bindex,valmsg,false)
  then ValidateConfiguration(bindex,valmsg,true)
  else
    begin
    {Here we give a MessageDlg, saying Configuration cannont be fully applied,
      show why, and let user decide.}
    if messagedlg('Configuration can only be Partially Applied.' + #13
               + valmsg + #13 + 'Cancel the configuration change ? ',mtconfirmation, [mbYes, mbNo],0) = mrYes
    then maggmsgf.MagMsg('','Configuration change Canceled.')
    else ValidateConfiguration(bindex,valmsg,true)

    end;*)
End;

Function TfrmConfigList.ApplyClearConfiguration(Var Rmsg: String): Boolean;
Begin
  Result := True;
  With FrmCapConfig Do
  Begin
    frmCapMain.FCapClinDataObj.Free;
    frmCapMain.FCapClinDataObj := TClinicalData.Create;
    frmCapMain.FCapClinDataObj.Pkg := '8925';
    frmCapMain.LoadFieldsFromClinicalData(frmCapMain.FCapClinDataObj);
  End;
    { DONE : HAVE TO Clear all NoClears first URGENT }
  UnLockAllFields;
    { oot 7/12/02  have to apply saved Values for Type, Spec, Proc}
  frmCapMain.RefreshIndexLists; { 02/25/03   Index lists weren't being updated because}
                { the current filtered list(Spec, and Proc) might not have the new values
                  listed.  so Refresh Index Lists first, then}
  frmCapMain.EdtDocImageDate.Text := '';
  frmCapMain.EdtType.Text := '';
  frmCapMain.LvType.Selected := Nil;
  frmCapMain.LOOKUPIndexType;
    { DONE :   HAVE to refresh INDEX Lists first URGENT}
  frmCapMain.EdtSpecSubSpec.Text := '';
  frmCapMain.LvSpecSubSpec.Selected := Nil;
  frmCapMain.UpdateProcFromSpec;
  frmCapMain.EdtProcEvent.Text := '';
  frmCapMain.LvProcEvent.Selected := Nil;
  frmCapMain.UpdateSpecFromProc;
  frmCapMain.cbOrigin.ItemIndex := frmCapMain.GetDefaultOriginIndex;
  frmCapMain.ShowNoteGlyphs(frmCapMain.FCapClinDataObj);
  frmCapMain.EdtImageDesc.Text := '';
  frmCapMain.edtDicomByUser.Text := '';  //p117 new field to display Dicom Values to user.
  frmCapMain.AllPagesChecked(false);
  //frmCapMain.cb ALLPages.Checked := false;
End;

Procedure TfrmConfigList.WinMsg(s: String);
Begin
  StatusBar1.Panels[0].Text := s;
  If Doesformexist('maggmsgf') Then
    //maggmsgf.magmsg('', s, frmCapMain.pmsg);
    MagAppMsg('', s); 
    frmcapmain.Pmsg.Caption := s ;
End;

Procedure TfrmConfigList.FormCreate(Sender: Tobject);
Begin
   tbWorkstations.visible := FCapDevTest;
   tbDateRange.Visible := FCapDevTest;


FWinCaption := 'Imaging Workstation: Capture configurations';
Caption := FWinCaption;
  LvwCfgList.Align := alClient;
  MaglistviewFields.Align := alClient;
  GetFormPosition(Self As TForm);
  Fconfiglist := Tstringlist.Create;
End;

Procedure TfrmConfigList.FormDestroy(Sender: Tobject);
Begin
  SaveFormPosition(Self As TForm);
  If Hotlistchanged Then SaveConfigsToINI;
  If Frmcapmain.FConfigButtonsMoved Then Frmcapmain.SaveButtonConfigsToINI;
  Fconfiglist.Free;
End;

Procedure TfrmConfigList.SaveConfigsToINI;
Var
  i: Integer;
  Tini: TIniFile;
//  li : Tlistitem;
//  configlistb : Tstrings;
Begin
        {       Save all defined configs to INI}
  If Not Hotlistchanged Then Exit; //WPR CONFIG
  Tini := TIniFile.Create(GetConfigFileName);
  Try
    Tini.Erasesection('SYS_CONFIGURATIONS');
    For i := 0 To LvwCfgList.Items.Count - 1 Do
    Begin
      Tini.Writestring('SYS_CONFIGURATIONS', Inttostr(i + 1), Fconfiglist[CfgIndexFromDesc(LvwCfgList.Items[i].caption)]);
    End;
  Finally
    Tini.Free;
  End;
End;

Procedure TfrmConfigList.ApplySelectedConfiguration;
Var
  Rmsg: String;
Begin
  If LvwCfgList.Selected <> Nil Then
  Begin
    ApplyConfiguration(LvwCfgList.Selected.caption, Rmsg);
    WinMsg(Rmsg);
  End;
  EnableDisable;
End;

procedure TfrmConfigList.ApplythisWorkstationConfigurations1Click(Sender: TObject);
begin
GetSavedConfigs;      //

end;

Procedure TfrmConfigList.LvwCfgListChange(Sender: Tobject; Item: TListItem;
  Change: TItemChange);
Begin
  WinMsg('');
  If (Change = ctState) And (Item.Selected) Then DisplaySelectedConfig(Item);
  EnableDisable;
End;

Procedure TfrmConfigList.EnableDisable;
Begin
  btnOK.Enabled := (LvwCfgList.Selected <> Nil);
  btnDelete.Enabled := (LvwCfgList.Selected <> Nil);
  btnSave.Enabled := (LvwCfgList.Selected <> Nil);
End;

Procedure TfrmConfigList.SaveSettingAs;
Var
  s, Desc: String;
Begin
  Desc := 'as a New Configuration: ';
  s := '';
  If InputQuery('Save the Main Capture Window settings', Desc, s) Then SaveNewConfig(s);
End;

Function TfrmConfigList.DoesConfigurationExist(Desc: String): Boolean;
Var
  Li: TListItem;
Begin
  Result := False;
  Li := LvwCfgList.FindCaption(0, Desc, False, True, True);
  If Li <> Nil Then
  Begin
    If Messagedlg('Configuration - "' + Desc + '" Already Exists.'
      + #13 + #13 + ' Overwrite "' + Desc + '" with the settings from the Main Capture Window ? ',
      Mtconfirmation, [Mbok, Mbcancel], 0) = MrCancel Then
      Result := True
    Else
    Begin
      Fconfiglist.Delete(CfgIndexFromDesc(Desc));
      LvwCfgList.Items.Delete(LvwCfgList.Items.Indexof(Li));
    End;
  End;
End;

Procedure TfrmConfigList.DisplaySelectedConfig(Li: TListItem);
Begin
  LblSelectedCfg.caption := ' Configuration: ' + Li.caption;
  LvwCfgList.Items.BeginUpdate;
  Try
    LockedFldsToList(Li);
    DisplaySettings(Li);
    FieldValuesToList(Li);
  Finally
    LvwCfgList.Items.EndUpdate;
  End;
End;

Procedure TfrmConfigList.FieldValuesToList(Li: TListItem);
Var
  s, ClinDataStr: String;
  i: Integer;
  Lifield, Linew: TListItem;
  VClinDataobj: TClinicalData;
Begin
  VClinDataobj := TClinicalData.Create;
  Try
    If Li <> Nil Then
    Begin
      //i := lvwCfgList.Items.IndexOf(li);
      i := CfgIndexFromDesc(Li.caption);
      s := MagPiece(Fconfiglist[i], '^', 9);
      If s <> '' Then
      Begin
        Lifield := MaglistviewFields.FindCaption(0, '*Doc/ Image Type', False, True, True);
        If Lifield = Nil Then
        Begin
          Linew := MaglistviewFields.Items.Add;
          Linew.caption := '*Doc/ Image Type';
          Linew.ImageIndex := 99;
        End
        Else
          Linew := Lifield;
        Linew.SubItems.Add(s);
      End;
      s := MagPiece(Fconfiglist[i], '^', 10);
      If s <> '' Then
      Begin
        Lifield := MaglistviewFields.FindCaption(0, 'Specialty', False, True, True);
        If Lifield = Nil Then
        Begin
          Linew := MaglistviewFields.Items.Add;
          Linew.caption := 'Specialty';
          Linew.ImageIndex := 99;
        End
        Else
          Linew := Lifield;
        Linew.SubItems.Add(s);
      End;
      s := MagPiece(Fconfiglist[i], '^', 11);
      If s <> '' Then
      Begin
        Lifield := MaglistviewFields.FindCaption(0, 'Proc/Event', False, True, True);
        If Lifield = Nil Then
        Begin
          Linew := MaglistviewFields.Items.Add;
          Linew.caption := 'Proc/Event';
          Linew.ImageIndex := 99;
        End
        Else
          Linew := Lifield;
        Linew.SubItems.Add(s);
      End;
      s := MagPiece(Fconfiglist[i], '^', 12);
      If s <> '' Then
      Begin
        Lifield := MaglistviewFields.FindCaption(0, '*Image Desc', False, True, True);
        If Lifield = Nil Then
        Begin
          Linew := MaglistviewFields.Items.Add;
          Linew.caption := '*Image Desc';
          Linew.ImageIndex := 99;
        End
        Else
          Linew := Lifield;
        Linew.SubItems.Add(s);
      End;

      s := MagPiece(Fconfiglist[i], '^', 13);
    //if s <> '' then
      Begin
        If (s = '') Then s := '0';
        Lifield := MaglistviewFields.FindCaption(0, '*Origin', False, True, True);
        If Lifield = Nil Then
        Begin
          Linew := MaglistviewFields.Items.Add;
          Linew.caption := '*Origin';
          Linew.ImageIndex := 99;
        End
        Else
          Linew := Lifield;
      //    frmCapMain.cbOrigin.ItemIndex := strtoint(hkOrigin);
        Linew.SubItems.Add(Frmcapmain.cbOrigin.Items[Strtoint(s)]);
      End;

      //////////////
      ClinDataStr := MagPiece(Fconfiglist[i], '|', 2);
      If ClinDataStr <> '' Then
      Begin
        VClinDataobj.LoadFromClinDataStr(ClinDataStr);
        Begin
          Lifield := MaglistviewFields.FindCaption(0, 'Action-Status', False, True, True);
          If Lifield = Nil Then
          Begin
            Linew := MaglistviewFields.Items.Add;
            Linew.caption := 'Action-Status';
            Linew.ImageIndex := 99;
          End
          Else
            Linew := Lifield;
          Linew.SubItems.Add(VClinDataobj.GetActStatShort);
        End;
        If VClinDataobj.NewTitle <> '' Then
        Begin
          Lifield := MaglistviewFields.FindCaption(0, '*Note Title', False, True, True);
          If Lifield = Nil Then
          Begin
            Linew := MaglistviewFields.Items.Add;
            Linew.caption := '*Note Title';
            Linew.ImageIndex := 99;
          End
          Else
            Linew := Lifield;
          Linew.SubItems.Add(VClinDataobj.NewTitle);
        End;
      End;

      //////////////
    End;
  Finally
    VClinDataobj.Free;
  End;
End;

Procedure TfrmConfigList.DisplaySettings(Li: TListItem);
Var
  i: Integer;
Begin
  ClearSettingsDisplayed;
//  i := lvwCfgList.Items.IndexOf(li);
  i := CfgIndexFromDesc(Li.caption);
  //:= magpiece(configlist[i],'^',i);
  LblSourceDesc.caption := MagPiece(Fconfiglist[i], '^', 2);
  LblFormatDesc.caption := MagPiece(Fconfiglist[i], '^', 3);
  LblAssociationDesc.caption := MagPiece(Fconfiglist[i], '^', 4);
  LblSavingDesc.caption := MagPiece(Fconfiglist[i], '^', 5);
  LblModeDesc.caption := MagPiece(Fconfiglist[i], '^', 6);
  LblOtherDesc.caption := MagPiece(Fconfiglist[i], '^', 7);
End;

Procedure TfrmConfigList.LockedFldsToList(Li: TListItem);
Var
  i: Integer;
  Lockedflds: String;
  Linew: TListItem;
Begin
  //lvwCfgList.Items.BeginUpdate;
  Try
  //listLockedFlds.Clear;
    MaglistviewFields.Items.Clear;
    MaglistviewFields.Update;
    If Li <> Nil Then
    Begin
//      i := lvwCfgList.Items.IndexOf(li);
      i := CfgIndexFromDesc(Li.caption);
      Lockedflds := MagPiece(Fconfiglist[i], '^', 8);
      If Lockedflds = '' Then Exit;
      For i := 1 To Maglength(Lockedflds, ',') Do
      Begin
      //listlockedflds.items.add(magpiece(lockedflds, ',', i));
           // if a Date Field, don't show the Lock.
        Linew := MaglistviewFields.Items.Add;
        Linew.caption := (MagPiece(Lockedflds, ',', i));
        Linew.ImageIndex := 6;
      End;

    End;
  Finally
  //lvwCfgList.Items.EndUpdate;
  End;
End;

Procedure TfrmConfigList.UnLockAllFields;
Var
  i: Integer;
Begin
  With Frmcapmain Do
  Begin
    For i := 0 To SbxEditFields.ControlCount - 1 Do
      If (SbxEditFields.Controls[i] Is TmagLabelNoClear) Then TmagLabelNoClear(SbxEditFields.Controls[i]).NoClear := False;
  End;
End;

Function TfrmConfigList.GetCurrentLockedFields: String;
Var
  i: Integer;
Begin
  // list of fields that can be locked. :
  { TODO : Get With it, make this generic }
  Result := '';
  With Frmcapmain Do
    For i := 0 To SbxEditFields.ControlCount - 1 Do
      If (SbxEditFields.Controls[i] Is TmagLabelNoClear) Then
        If (TmagLabelNoClear(SbxEditFields.Controls[i]).NoClear
          And TmagLabelNoClear(SbxEditFields.Controls[i]).Visible) Then Result := Result + ',' + TmagLabelNoClear(SbxEditFields.Controls[i]).caption;

(*  begin
    if lbPatName.NoClear and lbPatName.visible then result := result + ',' + lbPatName.caption;
    if lbStudy.NoClear and lbStudy.visible then result := result + ',' + lbStudy.caption;
    if lbProcDate.NoClear and lbProcDate.visible then result := result + ',' + lbProcDate.caption;
    if lbAccessionNo.NoClear and lbAccessionNo.visible then result := result + ',' + lbAccessionNo.caption;
    if lbDayCaseNo.NoClear and lbDayCaseNo.visible then result := result + ',' + lbDayCaseNo.caption;
    if lbStain.NoClear and lbStain.visible then result := result + ',' + lbStain.caption;
    if lbMicro.NoClear and lbMicro.visible then result := result + ',' + lbMicro.caption;
    if lbIndexType.NoClear and lbIndexType.visible then result := result + ',' + lbIndexType.caption;
    if lbIndexSpecSubSpec.NoClear and lbIndexSpecSubSpec.visible then result := result + ',' + lbIndexSpecSubSpec.caption;
    if lbIndexProcEvent.NoClear and lbIndexProcEvent.visible then result := result + ',' + lbIndexProcEvent.caption;
    if lbImageDesc.NoClear and lbImageDesc.visible then result := result + ',' + lbImageDesc.caption;
  end; *)
  Result := Copy(Result, 2, Length(Result));

  (*
   lbStain
   lbMicro
   lbAccessionNo
   lbDayCaseNo

   lbIndexProcEvent    =
   lbIndexSpecSubSpec   =
   lbIndexType       =

   lbImageDesc      =
   lbProcDate      =
   lbStudy
   lbPatName

  *)
End;
(*
  TClinicalData = class(TObject)
  public
    NewAuthor: string;          {File 200 New Person: Author's Name}
    NewAuthorDUZ: string;       {File 200 New Person: Author's DUZ}
    NewDate: string;            {Date internal or external}
    NewLocation: string;        {Hospital Location File  44 Name}
    NewLocationDA: string;      {Hospital Location File  44 DA}
    NewStatus: string;          {un-signed,AdminClosuer,Signed}
    NewTitle: string;           {TIU DOCUMENT DEFINITION 8925.1   Name }
    NewTitleDA: string;         {TIU DOCUMENT DEFINITION 8925.1   DA}
    NewVisit: string;           { NOT USED, THE TIU CALL, computes Visit}
    New_Addendum: Boolean;      {}
    New_AddendumNote: string;   {TIU Doucment 8925 IEN}
    New_Note: Boolean;          {}
    NewText : Tstringlist;         { If user is adding text.}
    Pkg: string;                {8925 for TIU.}
    PkgData1: string;           {not used}
    PkgData2: string;           {not used}
    ReportData: TMagTIUData;    {if a selected note, this is the data}
    constructor Create;
    Destructor destroy; override;
    procedure Assign(vClinData : TClinicalData);
    function IsClear: boolean;  {tells if this object is void of data}
  end;
*)

Procedure TfrmConfigList.SaveNewConfig(Desc: String);
Var
  HkGroup, Hkspecialty, Hkinputtype: String;
  Hkimagetype, Hkfilmsize, HkMeteorInteractive, Hkmode: String[40];
  HkindexType, HkindexSpecSubSpec, HkindexProcEvent, HkImageDesc, Hkorigin: String;
//p140t1
    HkMultipleCapture, HKPDFConvert : string;
//  hkNNLoc,hkNNLocDA,hkNNStatus,hkNNTitle,hkNNTitleDA,hkNNPkg,hkNNPkgD1,hkNNPkgD2 : string;
  i: Integer;
  Lockedflds: String;
  ConfigStr: String;
  Li: TListItem;
Begin
  //NewNoteConfig
  If DoesConfigurationExist(Desc) Then Exit; //WPR CONFIG
  If Desc = '' Then Exit;
  Hkinputtype := '';        //source
  Hkimagetype := '';        // format
  //p124t1
  HkMultipleCapture := '';
  HKPDFConvert := '';
  Hkspecialty := '';
  HkGroup := '';
  Hkfilmsize := '';
  HkMeteorInteractive := '';
  Hkmode := '';
  HkindexType := '';
  HkImageDesc := '';
  HkindexSpecSubSpec := '';
  HkindexProcEvent := '';
  Hkorigin := '0'; //p8t21  0 is VA.   ItemIndex of list in ComboBox.
        {     Get list of all Locked Fields. }
  Lockedflds := GetCurrentLockedFields;
        {       Get values of certain fields.}
  If (Frmcapmain.EdtType.Text <> '') And (Frmcapmain.EdtType.Visible) Then HkindexType := Frmcapmain.EdtType.Text;

  If (Frmcapmain.EdtSpecSubSpec.Text <> '') And (Frmcapmain.EdtSpecSubSpec.Visible) Then HkindexSpecSubSpec := Frmcapmain.EdtSpecSubSpec.Text;

  If (Frmcapmain.EdtProcEvent.Text <> '') And (Frmcapmain.EdtProcEvent.Visible) Then HkindexProcEvent := Frmcapmain.EdtProcEvent.Text;

  If (Frmcapmain.EdtImageDesc.Text <> '') And (Frmcapmain.EdtImageDesc.Visible) Then HkImageDesc := Frmcapmain.EdtImageDesc.Text;

  Hkorigin := Inttostr(Frmcapmain.cbOrigin.ItemIndex);

        {       Get settings of Input Source, Image Format etc.}
  With FrmCapConfig Do
  Begin
  HkMultipleCapture := 'FALSE'; // 140 get to field.  Never Save this setting.

    (*
    if  cbMultipleCapture.Checked
       then HkMultipleCapture := 'TRUE'
       ELSE HkMultipleCapture := 'FALSE';
      *)
    if  cbPDFConvert.Checked
       then HKPDFConvert := 'TRUE'
       ELSE HKPDFConvert := 'FALSE';


    //For i := 0 To GInputSource.ControlCount - 1 Do
    For i := 0 To ComponentCount - 1 Do
    Begin
      If (Components[i].Tag <> magcfgSource) Then Continue;
      If TRadioButton(Components[i]).Checked Then Hkinputtype := Components[i].Name;
    End;
    For i := 0 To ComponentCount - 1 Do
    Begin
      If (Components[i].Tag <> magcfgFormat) Then Continue;
      If TRadioButton(Components[i]).Checked Then Hkimagetype := Components[i].Name;
    End;

(*  OLD way for reference
    Begin
      If Not (GInputSource.Controls[i] Is TRadioButton) Then Continue;
      If TRadioButton(GInputSource.Controls[i]).Checked Then Hkinputtype := GInputSource.Controls[i].Name;
    End;
    For i := 0 To GImageFormat.ControlCount - 1 Do
    Begin
      If Not (GImageFormat.Controls[i] Is TRadioButton) Then Continue;
      If TRadioButton(GImageFormat.Controls[i]).Checked Then Hkimagetype := GImageFormat.Controls[i].Name;
    End;
*)
    For i := 0 To GAssociation.ControlCount - 1 Do
    Begin
      If Not (GAssociation.Controls[i] Is TRadioButton) Then Continue;
      If TRadioButton(GAssociation.Controls[i]).Checked Then Hkspecialty := GAssociation.Controls[i].Name;
          {TODO: here Save if Note, the New Title and New Status}
    End;
    For i := 0 To GImageGroup.ControlCount - 1 Do
    Begin
      If Not (GImageGroup.Controls[i] Is TRadioButton) Then Continue;
      If TRadioButton(GImageGroup.Controls[i]).Checked Then HkGroup := GImageGroup.Controls[i].Name;
    End;
    For i := 0 To GMode.ControlCount - 1 Do
    Begin
      If Not (GMode.Controls[i] Is TRadioButton) Then Continue;
      If TRadioButton(GMode.Controls[i]).Checked Then Hkmode := GMode.Controls[i].Name;
    End;
        {       some validation for required settings.}
    If (HkGroup = '') Or (Hkspecialty = '') Or
      (Hkinputtype = '') Or (Hkmode = '') Then
    Begin
      Messagedlg('You need :' + #13 +
        'Input Source, Association, Group/Single and Mode ' + #13 +
        'To Create a Configuration Button.', Mtconfirmation, [Mbok], 0);
      Exit;
    End;
    If (Hkimagetype = '') And (Hkinputtype <> 'Import') Then
    Begin
      Messagedlg('You need : Image Format,' + #13 +
        'To Create a Configuration Button.', Mtconfirmation, [Mbok], 0);
      Exit;
    End;
        {       Save 'Other' settings depending on the Input Source.
                 - it says hkFilmSize, but it is means any Input Source.}
    If Hkinputtype = 'lumisys100' Then Hkfilmsize := Lum100choice.Items[Lum100choice.ItemIndex];
    If Uppercase(Hkinputtype) = 'METEOR' Then
      If cbMeteorInt.Checked Then
        Hkfilmsize := 'Interactive'
      Else
        Hkfilmsize := 'Non-Interactive';
    If Uppercase(Hkinputtype) = 'IMPORT' Then
    Begin
      If Frmcapmain.cbBatch.Checked Then
        Hkfilmsize := 'Batch'
      Else
        Hkfilmsize := '';
      If Frmcapmain.LbImport.caption <> '' Then Hkfilmsize := Hkfilmsize + ';' + Frmcapmain.LbImport.caption;
    End;
    If Frmcapmain.cbALLPages.Visible Then
       if CapX.mMultipage then  // If Frmcapmain.cb ALLPages.Checked Then
        Hkfilmsize := 'Multi Page'
      Else
        Hkfilmsize := '';

  End;
        {       create a string, save it to the INI}
  ConfigStr := Desc + '^' + Hkinputtype + '^' + Hkimagetype + '^' + Hkspecialty
    + '^' + HkGroup + '^' + Hkmode + '^' + Hkfilmsize + '^' + Lockedflds
    + '^' + HkindexType + '^' + HkindexSpecSubSpec + '^' + HkindexProcEvent
    + '^' + HkImageDesc + '^' + Hkorigin  //; //;
    + '^' + hkMultipleCapture + '^' + hkPDFconvert;   // hkMultipleCapture = $p 14     HKPDFConvert := $p 15
     {TODO: here add NewNote Title and Status}
  If Not Frmcapmain.FCapClinDataObj.IsClear Then
  Begin
       // take out for testing,  Test Saving config of existing note too.
       //if FCapClinDataObj.New_Note then             //NNconfig
    Begin
            //Create ClinDataStr
      ConfigStr := ConfigStr + '^|' + Frmcapmain.FCapClinDataObj.GetClinDataStr;

    End;
  End;

  Fconfiglist.Add(ConfigStr);
  Hotlistchanged := True;
  Li := LvwCfgList.Items.Add;
  Li.caption := Desc;
  SaveConfigsToINI;
  GetSavedConfigs; //new
  // out LoadListView(configlist);
  ShowAsButtons(Frmcapmain.TabCtr);
  ResizeColumns;
  SelectConfig(Desc);
End;

Procedure TfrmConfigList.DeleteSelectedConfig;
Var
  Li: TListItem;
  s: String;
Begin
  Li := LvwCfgList.Selected;
  s := Li.caption;
  If Li <> Nil Then
  Begin
    If Messagedlg('Delete the configuration: "' + s + '"', Mtconfirmation,
      [Mbok, Mbcancel], 0) = MrCancel Then Exit;
    MaglistviewFields.Items.Clear;
    Fconfiglist.Delete(CfgIndexFromDesc(Li.caption));
     // lvwCfgList.items.delete(lvwCfgList.items.indexof(li));
    LvwCfgList.DeleteSelected;
    Hotlistchanged := True;
    ClearSettingsDisplayed;
    ShowAsButtons(Frmcapmain.TabCtr);
    WinMsg('Configuration "' + s + '" has been deleted.');
      //maggmsgf.MagMsg('', 'Configuration "' + s + '" has been deleted.', frmCapMain.pmsg);
    MagAppMsg('', 'Configuration "' + s + '" has been deleted.'); 
    Frmcapmain.Pmsg.Caption := 'Configuration "' + s + '" has been deleted.';
  End;

End;

Procedure TfrmConfigList.ClearSettingsDisplayed;
Begin
  LblSourceDesc.caption := '';
  LblFormatDesc.caption := '';
  LblAssociationDesc.caption := '';
  LblSavingDesc.caption := '';
  LblModeDesc.caption := '';
  LblOtherDesc.caption := '';
End;

Procedure TfrmConfigList.MReSizeClick(Sender: Tobject);
Begin
  ResizeColumns;
End;

Procedure TfrmConfigList.ResizeColumns;
//var I, x, tw: integer;
Begin
  (*  tw := 0;
    with lvwCfgList do
    begin
      for I := 0 to columns.count - 1 do
      begin
        columns[i].width := columntextwidth;
        x := columns[i].width;
        columns[i].width := columnheaderwidth;
        if x > columns[i].width then columns[1].width := x;
        tw := tw + columns[i].width;
      end;
    end;
    clientwidth := tw + 5;*)
End;

Procedure TfrmConfigList.SaveConfiguration(ConfigDesc: String);
Var
  Li: TListItem;
Begin
  Li := LvwCfgList.FindCaption(0, ConfigDesc, False, True, True);
  If Li <> Nil Then SaveConfiguration(Li);
End;

Procedure TfrmConfigList.SaveConfiguration(ConfigIndex: Integer);
Var
  Li: TListItem;
Begin
  Li := LvwCfgList.Items[ConfigIndex];
  If Li <> Nil Then SaveConfiguration(Li);

End;

Procedure TfrmConfigList.SaveConfiguration(Li: TListItem = Nil);
Var
  Desc: String;
Begin
  If Li = Nil Then Li := LvwCfgList.Selected;
  If Li <> Nil Then
  Begin
    Desc := Li.caption;
    If Messagedlg('Save the settings from the Main Capture Window' + #13 +
      ' as configuration: "' + Desc + '"', Mtconfirmation
      , MbOKCancel, 0) = MrOK Then
    Begin
          //configlist.delete(lvwCfgList.items.indexof(li));
      Fconfiglist.Delete(CfgIndexFromDesc(Desc));
      LvwCfgList.Items.Delete(LvwCfgList.Items.Indexof(Li));
      SaveNewConfig(Desc);
          { this is done in SaveNewConfig.}
          //SelectConfig(desc);
    End;
  End;
End;

Procedure TfrmConfigList.SelectConfig(Desc: String);
//var licur: TListitem;
Begin
(*
  licur := lvwCfgList.FindCaption(0, desc, false, true, true);
  if licur <> nil then lvwCfgList.Selected := licur;
  *)
{above is out, try this instead of above.}
{FindCaption could return nil, then any selection will be unselected.}
{before, we only unselected if FindCaption didn't return nil}
  LvwCfgList.Selected := LvwCfgList.FindCaption(0, Desc, False, True, True);

End;

Procedure TfrmConfigList.Delete1Click(Sender: Tobject);
Begin
  DeleteSelectedConfig;
End;

Procedure TfrmConfigList.Settings1Click(Sender: Tobject);
Begin
  FrmCapConfig.Show;
End;

Procedure TfrmConfigList.LvwCfgListEnter(Sender: Tobject);
Begin

  EnableDisable;
End;

Procedure TfrmConfigList.LvwCfgListExit(Sender: Tobject);
Begin
  WinMsg('');
  EnableDisable;
End;

Procedure TfrmConfigList.FormClose(Sender: Tobject;
  Var action: TCloseAction);
Begin
  If ItemsWereMoved Then
  Begin
    If Messagedlg('The list of configurations has been reordered.' + #13 +
      'Save the new order? ', Mtconfirmation, [MbYes, MbNo], 0) = MrYes Then
    Begin
      ShowAsButtons(Frmcapmain.TabCtr);
      Hotlistchanged := True;
    End
    Else
          {This will reorder the ListView when it is reopened.}
      GetSavedConfigs;
  End;
  If Hotlistchanged Then
  Begin
    SaveConfigsToINI;
    Hotlistchanged := False;
  End;
End;

Function TfrmConfigList.ItemsWereMoved: Boolean;
Var
  i: Integer;
Begin
  Result := False;
  For i := 0 To LvwCfgList.Items.Count - 1 Do
  Begin
    If Frmcapmain.TabCtr.Tabs[i] <> LvwCfgList.Items[i].caption Then
    Begin
      Result := True;
      Break;
    End;
  End;
End;

Procedure TfrmConfigList.Apply1Click(Sender: Tobject);
Begin
  ApplySelectedConfiguration;
End;

Procedure TfrmConfigList.btnDeleteClick(Sender: Tobject);
Begin
  DeleteSelectedConfig;
End;

Procedure TfrmConfigList.Delete2Click(Sender: Tobject);
Begin
  DeleteSelectedConfig;
End;

Procedure TfrmConfigList.btnSettingsClick(Sender: Tobject);
Begin
  FrmCapConfig.Show;
End;

Procedure TfrmConfigList.Settings2Click(Sender: Tobject);
Begin
  FrmCapConfig.Show;
End;

Procedure TfrmConfigList.btnSaveClick(Sender: Tobject);
Begin
  SaveConfiguration();
End;

Procedure TfrmConfigList.Save1Click(Sender: Tobject);
Begin
  SaveConfiguration();
End;

Procedure TfrmConfigList.btnSaveAsClick(Sender: Tobject);
Begin
  SaveSettingAs;
End;

Procedure TfrmConfigList.SaveAs1Click(Sender: Tobject);
Begin
  SaveSettingAs;
End;

Procedure TfrmConfigList.btnCloseClick(Sender: Tobject);
Begin
  ModalResult := MrNone;
  Close;
End;

Procedure TfrmConfigList.Exit1Click(Sender: Tobject);
Begin
  ModalResult := MrNone;
  Close;
End;

Procedure TfrmConfigList.StayOnTop1Click(Sender: Tobject);
Begin
  StayOnTop1.Checked := Not StayOnTop1.Checked;
  If StayOnTop1.Checked Then
    FrmConfigList.Formstyle := Fsstayontop
  Else
    FrmConfigList.Formstyle := FsNormal;
End;

procedure TfrmConfigList.tbWorkstationsClick(Sender: TObject);
begin

  NewUpdateTheWrksList;
  With MagWrksListForm Do
  Begin
    sdtfr.Date := ddtfr.Date;
    {function IncDay(ADate: TDateTime; Days: Integer = 1) : TDateTime;}
    //sdtfr.Date := IncDay(ddtto.Date, -7);
    Sdtto.Date := ddtto.Date;
    dtpwdtfr.Date := ddtfr.Date;
    dtpwdtto.Date := ddtto.Date;
    sdtfrchange(Self);
    sdttochange(Self);
    dtpwdttochange(Self);
    dtpwdtfrchange(Self);
    Show;
  End;
Hide;
end;

Procedure TfrmConfigList.GetFromToDates(Var Dtfr, Dtto, DisFrom, DisTo: String);
Var
  s, S1: String;
Begin
  Dtfr := '0';
  Dtto := '0';
  DateTimeToString(s, 'yyyy', MagWrksListForm.dtpwdtfr.Date);
  DateTimeToString(S1, 'mmdd', MagWrksListForm.dtpwdtfr.Date);
  Dtfr := Inttostr(Strtoint(s) - 1700) + S1;
  DateTimeToString(DisFrom, 'ddd mmm, dd yyyy', MagWrksListForm.dtpwdtfr.Date);
  DateTimeToString(s, 'yyyy', MagWrksListForm.dtpwdtto.Date);
  DateTimeToString(S1, 'mmdd', MagWrksListForm.dtpwdtto.Date);
  Dtto := Inttostr(Strtoint(s) - 1700) + S1;
  DateTimeToString(DisTo, 'ddd mmm, dd yyyy', MagWrksListForm.dtpwdtto.Date);

End;

Procedure TfrmConfigList.NewUpdateTheWrksList;
Var
  t: Tstringlist;
  Magini: TIniFile;
  WrksCompName: Shortstring;
  Dtto, Dtfr, s, DisplayFrom, DisPlayto: String;
  listtype: shortstring;
Begin
  Magini := TIniFile.Create(GetConfigFileName);
  Try
    WrksCompName := Uppercase(Magini.ReadString('SYS_AUTOUPDATE', 'ComputerName', 'NoComputerName'));
  Finally
    Magini.Free;
  End; {TRY}
  GetFromToDates(Dtfr, Dtto, DisplayFrom, DisplayTo);
  If rbLastLogon.Checked Then
  Begin
    listtype := 'last';
    s := 'Workstations whose Last Logon occured between : ' + DisplayFrom + ' and ' + DisplayTo;
  End
  Else
  Begin
    listtype := 'any';
    s := 'Workstations where Any logon occured between : ' + DisplayFrom + ' ' + DisplayTo;
  End;

  XBrokerX.PARAM[0].Value := WrksCompName + '^' + Dtfr + '^' + Dtto + '^' + listtype;
  XBrokerX.PARAM[0].PTYPE := LITERAL;
  XBrokerX.REMOTEPROCEDURE := 'MAGG SYS WRKS DISPLAY';
  t := Tstringlist.Create;
  Try
    XBrokerX.LstCALL(t);
    If ((t.Count = 0) Or (MagPiece(t[0], '^', 1) = '0')) Then
      //p140 Dmsg(MagPiece(t[0], '^', 2))
    Else
    Begin
      t.Delete(0);
      MagWrksListForm.DataToListView(t, MagWrksListForm.ListView1, s);
    End;
  Finally
    t.Free;
  End;
End;

procedure TfrmConfigList.tbDateRangeClick(Sender: TObject);
begin
Panel1.visible := NOT panel1.visible;
end;

Procedure TfrmConfigList.btnOKClick(Sender: Tobject);
Begin
  ApplySelectedConfiguration;
  Close;
End;

Procedure TfrmConfigList.LvwCfgListDblClick(Sender: Tobject);
Begin
  ApplySelectedConfiguration;
End;

Procedure TfrmConfigList.btnApplyClick(Sender: Tobject);
Begin
  ApplySelectedConfiguration;
End;

Procedure TfrmConfigList.FormShow(Sender: Tobject);
Begin
  WinMsg('');
End;

Procedure TfrmConfigList.File1Click(Sender: Tobject);
Begin
  Delete2.Enabled := (LvwCfgList.Selcount > 0);
  Save1.Enabled := (LvwCfgList.Selcount > 0);
  SaveAs1.Enabled := (LvwCfgList.Selcount > 0);
End;

Procedure TfrmConfigList.Options1Click(Sender: Tobject);
Begin
  Apply1.Enabled := (LvwCfgList.Selcount > 0);
End;

Procedure TfrmConfigList.ResizeColumns1Click(Sender: Tobject);
Begin
  LvwCfgList.FitColumnsToText;
  //maglistviewFields.FitColumnsToText;
End;

Procedure TfrmConfigList.FitColumnstoForm1Click(Sender: Tobject);
Begin
  LvwCfgList.FitColumnsToForm;
  //maglistviewFields.FitColumnsToForm;
End;

Procedure TfrmConfigList.List1Click(Sender: Tobject);
Begin
  LvwCfgList.ViewStyle := Vslist;
  List1.Checked := True;
End;

Procedure TfrmConfigList.Details1Click(Sender: Tobject);
Begin
  LvwCfgList.ViewStyle := Vsreport;
  Details1.Checked := True;
End;

Procedure TfrmConfigList.ColumnSelect1Click(Sender: Tobject);
Begin
  LvwCfgList.SelectColumns;
End;

procedure TfrmConfigList.dDtfrChange(Sender: TObject);
begin
  MagWrksListForm.dtpwdtfr.Date := ddtfr.Date;
  MagWrksListForm.dtpwdtfrchange(Self);
end;

procedure TfrmConfigList.dDttoChange(Sender: TObject);
begin
  MagWrksListForm.dtpwdtto.Date := ddtto.Date;
  MagWrksListForm.dtpwdttochange(Self);
end;

Procedure TfrmConfigList.Save2Click(Sender: Tobject);
Begin
  SaveConfiguration();
End;

Procedure TfrmConfigList.MnuDeleteListItemClick(Sender: Tobject);
Begin
  DeleteSelectedConfig;
End;

Procedure TfrmConfigList.MnuApplylistitemClick(Sender: Tobject);
var s : string;
 i : integer;
Begin
i := lvwCfgList.ItemIndex;
s := '';
if pnlWrksName.Visible then s := pnlWrksName.Caption;
if (s <> '') then
   begin
   frmCapMain.pnlWrksCfg.visible := true;
   if i > -1  then s := s + '  ' + lvwCfgList.Items[i].Caption;
   frmCapMain.pnlWrksCfg.caption := s;

   end;

  ApplySelectedConfiguration;
End;

Procedure TfrmConfigList.LvwCfgListKeyDown(Sender: Tobject; Var Key: Word; Shift: TShiftState);
Begin
  If ((Key = VK_Return) And (LvwCfgList.Selected <> Nil)) Then
  Begin
    ApplySelectedConfiguration;
    Close;
  End;
End;

Procedure TfrmConfigList.MnuToolbarClick(Sender: Tobject);
Begin
  MnuToolbar.Checked := Not MnuToolbar.Checked;
  TlbrMain.Visible := MnuToolbar.Checked;
End;

Procedure TfrmConfigList.Help2Click(Sender: Tobject);
Begin
  Application.HelpContext(HelpContext);
End;

Procedure TfrmConfigList.LvwCfgListColumnClick(Sender: Tobject;
  Column: TListColumn);
Begin
  ShowAsButtons(Frmcapmain.TabCtr);
End;

Procedure TfrmConfigList.LvwCfgListDragOver(Sender, Source: Tobject; x,
  y: Integer; State: TDragState; Var Accept: Boolean);
Var
  Li: TListItem;
Begin
  If Source Is TListView Then
  Begin
    Accept := True;
    Li := TListView(Sender).GetItemAt(x, y);
    If Li <> Nil Then
      WinMsg('Insert ' + LvwCfgList.Selected.caption + ' after: ' + Li.caption);
  End
  Else
    Accept := False;

End;

Procedure TfrmConfigList.LvwCfgListDragDrop(Sender, Source: Tobject; x, y: Integer);
Var
  LiAT: TListItem;
  LiSel: TListItem;
  Linew: TListItem;
  j: Integer;
Begin
  LiAT := TListView(Sender).GetItemAt(x, y);
  If LiAT <> Nil Then
  Begin
    LiSel := TListView(Sender).Selected;
    LvwCfgList.Items.BeginUpdate;
    WinMsg('DROP ' + LiSel.caption + ' after: ' + LiAT.caption);
    j := LvwCfgList.Items.Indexof(LiAT);
    Linew := LvwCfgList.Items.Insert(j + 1);
    Linew.Assign(LiSel);
    LvwCfgList.DeleteSelected;
    Linew.Focused := True;
    Linew.Selected := True;
    LvwCfgList.Items.EndUpdate;
  End
  Else
    WinMsg('');

End;

End.
