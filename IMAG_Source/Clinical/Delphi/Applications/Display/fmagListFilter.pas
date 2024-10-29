Unit FmagListFilter;
   {
   Package: MAG - VistA Imaging
   WARNING: Per VHA Directive 10-93-142 this unit should not be modified.
   Date Created:   Patch 8 Version 3  (7/1/2003)
   Site Name: Silver Spring, OIFO
   Developers: Garrett Kirin
   [==
   Description: Allows User to Add/Edit an Image Filter.
      Designed to be a Dialog window that can be executed. Other forms, objects
       of the application will 'exeucte' this form sending the current filter, and
       user id (DUZ) as parameters.  The result of the 'execute' will be a TImageFilter Object.
      ==]
   Note:
   }
(*
        ;; +------------------------------------------------------------------+
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
        ;; +------------------------------------------------------------------+

*)
//{$define debug}
Interface

Uses
  Buttons,
  Classes,
  cMagDBBroker,
  cMagListView,
  ComCtrls,
  Controls,
  ExtCtrls,
  Forms,
  Graphics,
  Menus,
  Stdctrls,
  UMagDefinitions,
  ImgList  ,
  imaginterfaces
  ;

//Uses Vetted 20090929:ActnColorMaps, ActnMan, ImgList, Calendar, Grids, uMagClasses, cMagMenu, ToolWin, fmagVistaLookup, umagdisplaymgr, fmagFilterSaveAS, fmagDateRange, umagKeyMgr, magpositions, umagutils, Dialogs, SysUtils, Messages, Windows

Type
  TfrmListFilter = Class(TForm)
    MainMenu1: TMainMenu;
    MnuFile: TMenuItem;
    Exit2: TMenuItem;
    N0: TMenuItem;
    MnuSaveAs: TMenuItem;
    MnuSave: TMenuItem;
    New2: TMenuItem;
    N1: TMenuItem;
    Options1: TMenuItem;
    SelectAll1: TMenuItem;
    ClearAll1: TMenuItem;
    Refresh1: TMenuItem;
    N2: TMenuItem;
    Help1: TMenuItem;
    Help2: TMenuItem;
    PnlBottom: Tpanel;
    btnOK: TBitBtn;
    btnCancel: TBitBtn;
    btnSave: TBitBtn;
    StrictlyCLINorADMIN1: TMenuItem;
    StatbarWinMsg: TStatusBar;
    btnSaveAs: TBitBtn;
    ImageList1: TImageList;
    MnuRefreshFilterlists: TMenuItem;
    MnuSaveAsPublic: TMenuItem;
    N3: TMenuItem;
    MnuDeleteCurrentFilter: TMenuItem;
    Edit1: TMenuItem;
    MnuPrivatePopup: TPopupMenu;
    MnuDeletePrivateFilter: TMenuItem;
    Other1: TMenuItem;
    MnuAddTypes: TMenuItem;
    MnuRemoveTypes: TMenuItem;
    MnuRemoveAllTypes: TMenuItem;
    PnlTop: Tpanel;
    PgctrlFltList: TPageControl;
    PgctrlFltListPrivate: TTabSheet;
    LstFltListPrivate: TListBox;
    PgctrlFltListPublic: TTabSheet;
    LstFltListPublic: TListBox;
    Splitter1: TSplitter;
    RefreshDetails1: TMenuItem;
    Panel1: Tpanel;
    PgctrlProps: TPageControl;
    TsGeneral: TTabSheet;
    TsAdmin: TTabSheet;
    TsClin: TTabSheet;
    PnlFilterstatus: Tpanel;
    TsAdvanced: TTabSheet;
    cbCaptureDate: TCheckBox;
    Bevel12: TBevel;
    LbStaus: Tlabel;
    LbShortDescHas: Tlabel;
    EdtShortDescHas: TEdit;
    Label17: Tlabel;
    Bevel15: TBevel;
    LbStatusValue: Tlabel;
    LbStatusValueDefault: Tlabel;
    LbSavedByValue: Tlabel;
    LbSavedByValueDefault: Tlabel;
    cbAdminAll: TCheckBox;
    Label6: Tlabel;
    LstAdminTypes: TListBox;
    SpeedButton1: TSpeedButton;
    SpeedButton2: TSpeedButton;
    SpeedButton3: TSpeedButton;
    LstAdminTypesSel: TListBox;
    LbSelectedTypes: Tlabel;
    Panel3: Tpanel;
    LbClinProperty: Tlabel;
    cbClinAll: TCheckBox;
    LstSpecs: TListBox;
    LstSpecsSel: TListBox;
    LstProcs: TListBox;
    LstProcsSel: TListBox;
    LstClinTypes: TListBox;
    LstClinTypesSel: TListBox;
    PnlPkgs: Tpanel;
    cbRad: TCheckBox;
    cbNote: TCheckBox;
    cbMed: TCheckBox;
    cbCP: TCheckBox;
    cbCnslt: TCheckBox;
    cbLab: TCheckBox;
    cbNone: TCheckBox;
    cbSur: TCheckBox;
    Label7: Tlabel;
    Bevel9: TBevel;
    PnlDetails: Tpanel;
    LvDetails: TMagListView;
    LstDetails: TListBox;
    PnlMoveBtns: Tpanel;
    SbtnClinSelOne: TSpeedButton;
    SbtnClinUnSelOne: TSpeedButton;
    SbtnClinSelAll: TSpeedButton;
    SbtnClinUnSelAll: TSpeedButton;
    btnStatusSelect: TBitBtn;
    btnStatusAny: TBitBtn;
    btnSavedby: TBitBtn;
    btnSavedAny: TBitBtn;
    Bevel1: TBevel;
    LbOriginValueDefault: Tlabel;
    cmboxDateRange: TComboBox;
    PnlDateRangeLb: Tpanel;
    SpeedButton4: TSpeedButton;
    PnlDateStuff1: Tpanel;
    PnlDateRange: Tpanel;
    LbRelativeRange: Tlabel;
    PnlDateSelect: Tpanel;
    Label2: Tlabel;
    Label3: Tlabel;
    LbValDtFrom: Tlabel;
    LbValDtTo: Tlabel;
    LbOriginValue: Tlabel;
    LbOrigin: Tlabel;
    btnSelect: TBitBtn;
    Bevel8: TBevel;
    LbClass: Tlabel;
    btnClassClin: TBitBtn;
    btnClassAdmin: TBitBtn;
    btnClassAny: TBitBtn;
    LbCurFltClass: Tlabel;
    TabControl1: TTabControl;
    Procedure ToolButton4Click(Sender: Tobject);
    Procedure btnSaveAsClick(Sender: Tobject);
    Procedure FormCreate(Sender: Tobject);
    Procedure New2Click(Sender: Tobject);
    Procedure MnuSaveAsClick(Sender: Tobject);
    Procedure SelectAll1Click(Sender: Tobject);
    Procedure ClearAll1Click(Sender: Tobject);
    Procedure Refresh1Click(Sender: Tobject);
    Procedure MagMenuPublicNewItemClick(Sender: Tobject);
    Procedure btnOKClick(Sender: Tobject);
    Procedure btnCancelClick(Sender: Tobject);
    Procedure MagMenuPrivateNewItemClick(Sender: Tobject);
    Procedure cbClinClick(Sender: Tobject);
    Procedure cbPackageClick(Sender: Tobject);
    Procedure FormDestroy(Sender: Tobject);
    Procedure Exit2Click(Sender: Tobject);
    Procedure Help2Click(Sender: Tobject);
    Procedure Label2Click(Sender: Tobject);
    Procedure btnSaveClick(Sender: Tobject);
    Procedure MnuSaveClick(Sender: Tobject);
    Procedure PgctrlFltListChange(Sender: Tobject);
    Procedure LstFltListPublicClick(Sender: Tobject);
    Procedure LstFltListPrivateClick(Sender: Tobject);
    Procedure MnuRefreshFilterlistsClick(Sender: Tobject);
    Procedure MnuSaveAsPublicClick(Sender: Tobject);
    Procedure MnuDeleteCurrentFilterClick(Sender: Tobject);
    Procedure Edit1Click(Sender: Tobject);
    Procedure MnuFileClick(Sender: Tobject);
    Procedure PgctrlFltListChanging(Sender: Tobject;
      Var AllowChange: Boolean);
    Procedure LstAdminTypesDblClick(Sender: Tobject);
    Procedure SpeedButton3Click(Sender: Tobject);
    Procedure SpeedButton1Click(Sender: Tobject);
    Procedure SpeedButton2Click(Sender: Tobject);
    Procedure LstAdminTypesSelDblClick(Sender: Tobject);
    Procedure SpeedButton4Click(Sender: Tobject);
    Procedure cmboxDateRangeChange(Sender: Tobject);
    Procedure PnlDateRangeClick(Sender: Tobject);
    Procedure LbRelativeRangeClick(Sender: Tobject);
    Procedure LbValDtFromClick(Sender: Tobject);
    Procedure Label3Click(Sender: Tobject);
    Procedure LbValDtToClick(Sender: Tobject);
    Procedure PnlDateSelectClick(Sender: Tobject);
    Procedure cbClinAllClick(Sender: Tobject);
    Procedure cbAdminAllClick(Sender: Tobject);
    Procedure LstFltListPrivateDblClick(Sender: Tobject);
    Procedure LstFltListPublicDblClick(Sender: Tobject);
    Procedure FormShow(Sender: Tobject);
    Procedure MnuDeletePrivateFilterClick(Sender: Tobject);
    Procedure MnuPrivatePopupPopup(Sender: Tobject);
    Procedure MnuAddTypesClick(Sender: Tobject);
    Procedure MnuRemoveTypesClick(Sender: Tobject);
    Procedure MnuRemoveAllTypesClick(Sender: Tobject);
    Procedure LstAdminTypesKeyDown(Sender: Tobject; Var Key: Word; Shift: TShiftState);
    Procedure LstAdminTypesSelKeyDown(Sender: Tobject; Var Key: Word; Shift: TShiftState);
    Procedure LstClinTypesKeyDown(Sender: Tobject; Var Key: Word; Shift: TShiftState);
    Procedure LstClinTypesDblClick(Sender: Tobject);
    Procedure LstSpecsDblClick(Sender: Tobject);
    Procedure LstSpecsKeyDown(Sender: Tobject; Var Key: Word; Shift: TShiftState);
    Procedure LstProcsDblClick(Sender: Tobject);
    Procedure LstProcsKeyDown(Sender: Tobject; Var Key: Word; Shift: TShiftState);
    Procedure LstClinTypesSelKeyDown(Sender: Tobject; Var Key: Word; Shift: TShiftState);
    Procedure LstClinTypesSelDblClick(Sender: Tobject);
    Procedure LstSpecsSelDblClick(Sender: Tobject);
    Procedure LstSpecsSelKeyDown(Sender: Tobject; Var Key: Word; Shift: TShiftState);
    Procedure LstProcsSelDblClick(Sender: Tobject);
    Procedure LstProcsSelKeyDown(Sender: Tobject; Var Key: Word; Shift: TShiftState);
    Procedure RefreshDetails1Click(Sender: Tobject);
    Procedure PgctrlClassChange(Sender: Tobject);
    Procedure PgctrlClassChanging(Sender: Tobject; Var AllowChange: Boolean);
    Procedure cbProcDateClick(Sender: Tobject);
    Procedure LstDetailsClick(Sender: Tobject);
    Procedure Label1MouseEnter(Sender: Tobject);
    Procedure Label1MouseLeave(Sender: Tobject);
    //
    Procedure LabelButtonMouseEnter(Sender: Tobject);
    Procedure LabelbuttonMouseLeave(Sender: Tobject);
    Procedure cbCaptureDateClick(Sender: Tobject);
    Procedure EdtShortDescHasChange(Sender: Tobject);
    Procedure EdtShortDescHasExit(Sender: Tobject);
    Procedure EdtShortDescHasKeyDown(Sender: Tobject; Var Key: Word; Shift: TShiftState);
    Procedure FormClose(Sender: Tobject; Var action: TCloseAction);
    Procedure SbtnClinSelOneClick(Sender: Tobject);
    Procedure SbtnClinUnSelAllClick(Sender: Tobject);
    Procedure SbtnClinSelAllClick(Sender: Tobject);
    Procedure SbtnClinUnSelOneClick(Sender: Tobject);
    Procedure btnSelectClick(Sender: Tobject);
    Procedure btnClassClinClick(Sender: Tobject);
    Procedure btnClassAdminClick(Sender: Tobject);
    Procedure btnClassAnyClick(Sender: Tobject);
    Procedure btnStatusSelectClick(Sender: Tobject);
    Procedure btnStatusAnyClick(Sender: Tobject);
    Procedure btnSavedbyClick(Sender: Tobject);
    Procedure btnSavedAnyClick(Sender: Tobject);
    Procedure TabControl1Change(Sender: Tobject);
    Procedure cmboxDateRangeKeyDown(Sender: Tobject; Var Key: Word;
      Shift: TShiftState);

  Private
    {93   Jerry's new design of removing selected items from the left list box
           caused side effect of losing the items on the right from ever being selected again.}
    FBaseClinTypes,
      FBaseAdminTypes,
      FBaseSpecSubSpec,
      FBaseProcEvent: TStrings;

        {       We set this to stop refreshing multiple times within  a function.}
    FHoldRefresh: Boolean;
    FClinLstFrom: TListBox;
    FClinLstTo: TListBox;
    FImageCapturedByDUZName: String;
    FFilterModified: Boolean;
    FcurFltName: String;
    FcurFltIEN: String;
    FcurFltPub: Boolean;
    FCurFltClass: TmagImageClasses; {set of (mclsCLIN, mclsADMIN);}
    FDuz: String;
    FCanDoPublic: Boolean;
    FMonthRange: Integer;
    FTestOldStyleClasses: Boolean;

    FFilterClassClin, FFilterClassAdmin, FFilterClassANY: Boolean; //93
    {   FEnabled.... are determined by User Keys. MAGDISP CLIN and MAGDISP ADMIN.
                     if a user has MAG SYSTEM then ClassANY will be enabled}
    FUserClassClin, FUserClassAdmin, FUserClassANY, FUserAdvTab: Boolean; //93

    FAllClinAndAdmin: Boolean; // ??

    FMagBroker: TMagDBBroker;
//    Ffilter: TImageFilter;

    Procedure EnableUserClassAbilities;
    Procedure GetFilterList(Lst: TListBox; PDuz: String = '');
    Procedure ClearAll;
    Procedure SaveFilterAs(AsPub: Boolean = False);
    Procedure SelectAll;
    Procedure RefreshLists;
    Procedure ApplyChoicesToFilter(Filter: TImageFilter);
    Procedure DisplayFilter(Filter: TImageFilter);
//    procedure RefreshProcEvent;
    Procedure HideIEN(t: TStrings);
    Procedure DropDownHeight(cbox: TComboBox);
    Procedure EnableDateRange;
    Procedure EnableRelativeRange(Range: Integer; Desc: String = '');
    Function CreateRelativeDesc(Range: Integer): String;
    Procedure ClearDates;
    Procedure SelectDateRange;
    Procedure GetSelectedFilter(Lst: TListBox);
    Procedure WinMsg(s: String);
    Procedure SaveFilter;
    Procedure RefreshFilterLists;
    Procedure EnableSave(Val: Boolean = True);
    Procedure SetModifiedFlag(Value: Boolean; Fltname: String = ''; Fltien: String = '');
    Procedure SelectFilterListItem;
    Procedure ClearListBoxSelections(Lstbox: TListBox);
    Procedure AddToSelectedTypes;
    Procedure AddToAdminSelectedTypes;
    Procedure RemoveFromAdminSelectedTypes;
    Procedure GetFiltersToList(Xlist: TStrings; Lstbox: TListBox);
    Procedure ToggleDropDownDate;
    Procedure ConfirmSaveChange(Var AllowChange: Boolean);
    Procedure ClearSelectedOrigins;
    Procedure UpdateOriginAll;
    Procedure UpdateClinAll;
    Procedure DeleteCurrentFilter;
    Procedure RemoveAllAdminSelectedTypes;
    Procedure ShowClinTypes;
    Procedure ShowProcs;
    Procedure ShowSpecs;
    Procedure HideAllClinLists;
    Procedure ClearAllClinLists;
    Procedure AddToClinSelectedTypes;
    Procedure AddToSpecsSel;
    Procedure AddToProcsSel;
    Procedure ClearSelectedAdminTypes;
    Procedure ClearSelectedClinTypes;
    Procedure ClearSelectedProcs;
    Procedure ClearSelectedSpecs;
    Procedure RemoveFromClinSelectedTypes;
    Procedure RemoveFromProcsSelected;
    Procedure RemoveFromSpecsSelected;
    Procedure ShowPackages;
    Procedure RefreshDetails;
    Procedure SelectedChoicesToSelected;

    Procedure FilterOriginClear;
    Procedure FilterOriginEdit;
    Procedure FilterStatusEdit;
    Procedure FilterStatusClear;
    Procedure FilterSavedByEdit;
    Procedure FilterSavedByClear;
    Procedure ChangeFilterClassToAdmin;
    Procedure ChangeFilterClassToClin;
    Procedure ChangeFilterClassToANY(Forcechange: Boolean = False);
    Procedure LoadLVDetails(Filter: TImageFilter);

    //    procedure RefreshSpecSubSpec;

    Procedure SetTabs(LB: TListBox); {JK 12/30/2008}
    Procedure DisplayCurFilterClass;
    Procedure SetDefaultClass;
    Procedure ActiveControlChanged(Sender: Tobject);

  Public

    Pkgs: String;
    Classes: String; { Public declarations }
    Function Execute(Filter: TImageFilter; PDuz: String; AdvTab: Boolean = False): TImageFilter;
    Procedure UseOldStyleClasses(Value: Boolean);
    Procedure RefreshIndexLists;
  End;

Var
  FrmListFilter: TfrmListFilter;

Implementation

Uses
  Dialogs,
  ImagDMinterface, //RCA  DmSingle,DmSingle,
  FmagDateRange,
  FmagFilterSaveAs,
  FMagFMSetSelect,
  FmagVistALookup,
//RCA  Maggmsgu,
  Magpositions,
  Messages,
  SysUtils,
//umagdisplaymgr,

  Umagkeymgr,
  Umagutils8,
  umagutils8B,
  Windows
  ;

{$R *.DFM}

Procedure TfrmListFilter.SelectAll;
Begin
(*
  cbOriginAll.Checked := true;
  cbOriginVA.checked := false;
  cbOriginNonVA.checked := false;
  cbOriginDOD.checked := false;
  cbOriginFEE.checked := false;
  *)
  cbAdminAll.Checked := True;
  ClearSelectedAdminTypes;

  cbClinAll.Checked := True;
  cbMed.Checked := False;
  cbRad.Checked := False;
  cbSur.Checked := False;
  cbCP.Checked := False;
  cbNote.Checked := False;
  cbLab.Checked := False;
  cbCnslt.Checked := False;
  cbNone.Checked := False;

//93out  cmbClinTypes.itemindex := -1;
  Self.ClearSelectedClinTypes;
//93out       cmbSubSpec.ItemIndex := -1;
  Self.ClearSelectedSpecs;
//93out       cmbProcEvent.itemindex := -1;
  Self.ClearSelectedProcs;

End;

Procedure TfrmListFilter.ClearAll;
Begin
    {   DONE -oGarrett -c93 : NEED to check to see if new fields
            are being Cleared in this call, and origin fields also }
  FcurFltName := '';
  FcurFltIEN := '';
  FCurFltClass := [];
  LbCurFltClass.caption := MagclsAllShow;
  WinMsg('Controls cleared');

  EnableRelativeRange(0);
  LbValDtFrom.caption := '';
  LbValDtTo.caption := '';

  LbOriginValue.caption := '';
  LbStatusValue.caption := '';
  EdtShortDescHas.Text := '';
  LbSavedByValue.caption := '';
  Self.cbCaptureDate.Checked := False;

  cbAdminAll.Checked := False;
  ClearSelectedAdminTypes;

  cbClinAll.Checked := False;
  Self.ClearSelectedClinTypes;
  Self.ClearSelectedProcs;
  Self.ClearSelectedSpecs;
  cbMed.Checked := False;
  cbRad.Checked := False;
  cbSur.Checked := False;
  cbCP.Checked := False;
  cbNote.Checked := False;
  cbLab.Checked := False;
  cbCnslt.Checked := False;
  cbNone.Checked := False;
//93out    cmbClinTypes.ItemIndex := -1;
  ClearSelectedClinTypes;
//93out       cmbSubSpec.ItemIndex := -1;
  ClearSelectedSpecs;
//93out       cmbProcEvent.itemindex := -1;
  ClearSelectedProcs;
  SetModifiedFlag(False, 'Custom', '0'); //ClearAll()

  TsAdmin.TabVisible := False;
  TsClin.TabVisible := False;
End;

Procedure TfrmListFilter.ToolButton4Click(Sender: Tobject);
Begin
  RefreshLists;
End;

(*procedure TfrmListFilter.RefreshProcEvent;
var t: Tstrings;
  spec: string;
begin
  exit;
  // Do we want this to change.
  t := Tstringlist.create;
  try
    spec := magpiece(cmbSubSpec.items[cmbSubSpec.itemindex], '|', 2);
    FMagBroker.RPIndexGetEvent(t, 'CLIN', spec);
    cmbProcEvent.items := t;
  finally
    t.free;
  end;
end;
  *)

Procedure TfrmListFilter.RefreshLists;
Var
  t: TStrings;
  ClinCls, AdminCls: String;
Begin
  If FTestOldStyleClasses Then
  Begin
    ClinCls := 'CLIN';
    AdminCls := 'ADMIN';
  End
  Else
  Begin
    ClinCls := MagdisclsClin;
    AdminCls := MagdisclsAdmin;
  End;
  t := Tstringlist.Create;
  Try
    FMagBroker.RPIndexGetType(t, ClinCls, True);
    t.Delete(0);
    HideIEN(t);
//93out      cmbClinTypes.items := t;
    FBaseClinTypes.Assign(t);
    LstClinTypes.Items.Assign(t);
    ClearSelectedClinTypes;

    t.Clear;
    FMagBroker.RPIndexGetSpecSubSpec(t, ClinCls, '', True);
    t.Delete(0);
    HideIEN(t);
//93out         cmbSubSpec.items := t;
    FBaseSpecSubSpec.Assign(t);
    LstSpecs.Items.Assign(t);
    ClearSelectedSpecs;

    t.Clear;
    FMagBroker.RPIndexGetEvent(t, ClinCls, '', True);
    t.Delete(0);
    HideIEN(t);
//93out    cmbProcEvent.items := t;
    FBaseProcEvent.Assign(t);
    LstProcs.Items.Assign(t);
    ClearSelectedProcs;

    t.Clear;
    FMagBroker.RPIndexGetType(t, AdminCls, True);
    t.Delete(0);
    HideIEN(t);
    FBaseAdminTypes.Assign(t);
    LstAdminTypes.Items := t;
    ClearSelectedAdminTypes;

  Finally
    WinMsg('Lists refreshed');
    t.Free;
  End;
End;

Procedure TfrmListFilter.HideIEN(t: TStrings);
Var
  i: Integer;
  Sp: String;
  Vl: String;
Begin
  Sp := '                                    ';
  For i := 0 To t.Count - 1 Do
  Begin
    Vl := MagPiece(MagPiece(t[i], '|', 1), '^', 1) + Sp + Sp + Sp + '|' + MagPiece(t[i], '|', 2);
    t[i] := Vl;
  End;
End;

Procedure TfrmListFilter.btnSaveAsClick(Sender: Tobject);
Begin
  SaveFilterAs;
  RefreshFilterLists;
End;

Procedure TfrmListFilter.SaveFilterAs(AsPub: Boolean = False);
Var
  s: String;
  Filter: TImageFilter;
  Rstat: Boolean;
  Rmsg: String;
  t: TStrings;
  Fltname, VFltIen, User: String;
  XCap, Xprompt: String;
  Xlist: TStrings;
Begin

  WinMsg('Saving Filter...');
  Fltname := '';
  VFltIen := '';
  Xlist := Tstringlist.Create;
  t := Tstringlist.Create;
  Filter := TImageFilter.Create;
  Try
    If AsPub Then
    Begin
      XCap := 'Save As Public Filter';
      Xprompt := 'Public Filter Name:';
      GetFiltersToList(Xlist, LstFltListPublic);
    End
    Else
    Begin
      XCap := 'Save As Private Filter';
      Xprompt := 'Private Filter Name:';
      GetFiltersToList(Xlist, LstFltListPrivate);
    End;
    If FrmFilterSaveAs.Execute(Xlist, XCap, Xprompt, AsPub, Fltname, VFltIen, Self) Then
    Begin
      ApplyChoicesToFilter(Filter);
      Filter.Name := Fltname;
      Filter.FilterID := VFltIen;
      If AsPub Then
        User := ''
      Else
        User := FDuz;
      FilterToFieldList(Filter, t, User);
      idmodobj.GetMagDBBroker1.RPFilterSave(Rstat, Rmsg, t);
      If Not Rstat Then
        WinMsg(MagPiece(Rmsg, '^', 2))
      Else
      Begin
        WinMsg('Filter Saved As "' + MagPiece(Rmsg, '^', 2) + '"');
            //maggmsgf.magmsg('s', rmsg);
        MagAppMsg('s', Rmsg); {JK 10/5/2009 - Maggmsgu refactoring}
        SetModifiedFlag(False, Fltname, MagPiece(Rmsg, '^', 1)); //SaveFilterAs()
      End;
    End
    Else
      WinMsg('Filter not saved.');
  Finally
    Filter.Free;
    t.Free;
    Xlist.Free;
  End;
End;

Procedure TfrmListFilter.GetFiltersToList(Xlist: TStrings; Lstbox: TListBox);
Var
  i: Integer;
Begin
  For i := 0 To Lstbox.Items.Count - 1 Do
  Begin
    Xlist.Add(Magstripspaces(MagPiece(Lstbox.Items[i], '^', 1)) + '^' + MagPiece(Lstbox.Items[i], '^', 2));
  End;
    //
End;

Procedure TfrmListFilter.SaveFilter;
Var
  s: String;
  Filter: TImageFilter;
  Rstat: Boolean;
  Rmsg: String;
  t: TStrings;
  Fltname: String;
  User: String;
  XCap, Xprompt: String;
Begin
  // only Private Modified filters can be 'Saved'
  // Public filters Can't be Changed, so we Force A Save As Private
  If (FcurFltName = '') Or (FcurFltName = 'Custom') Or FcurFltPub Then
  Begin
    SaveFilterAs; // This is save as private.
    Exit;
  End;

  WinMsg('Saving Filter... ' + FcurFltName);
  Fltname := MagPiece(FcurFltName, '*', 1);
  t := Tstringlist.Create;
  Filter := TImageFilter.Create;
  Try
    ApplyChoicesToFilter(Filter);

    Filter.Name := Fltname;
    Filter.FilterID := FcurFltIEN;
    User := FDuz;
    FilterToFieldList(Filter, t, User);
    idmodobj.GetMagDBBroker1.RPFilterSave(Rstat, Rmsg, t);
    If Not Rstat Then
      WinMsg('Changes NOT saved : ' + MagPiece(Rmsg, '^', 2))
    Else
    Begin
      WinMsg('Changes saved for "' + MagPiece(Rmsg, '^', 2) + '"');
      SetModifiedFlag(False, Fltname, MagPiece(Rmsg, '^', 1)); //SaveFilter()
    End;
  Finally
    Filter.Free;
    t.Free;
  End;
End;

Procedure TfrmListFilter.WinMsg(s: String);
Begin
  StatbarWinMsg.Panels[0].Text := s;
  //maggmsgf.MagMsg('s', s);
  MagAppMsg('s', s); {JK 10/5/2009 - Maggmsgu refactoring}
End;

Procedure TfrmListFilter.FormCreate(Sender: Tobject);
Begin
//    Screen.OnActiveControlChange := ActiveControlChanged;
  PnlDateStuff1.ParentColor := True;
  PnlDateSelect.ParentColor := True;
  PnlDateRange.ParentColor := True;
  LbRelativeRange.ParentColor := True;
  LbValDtFrom.ParentColor := True;
  LbValDtTo.ParentColor := True;
  LbOriginValue.ParentColor := True;
  LbOriginValue.AutoSize := True;

  FBaseClinTypes := Tstringlist.Create;
  FBaseAdminTypes := Tstringlist.Create;
  FBaseSpecSubSpec := Tstringlist.Create;
  FBaseProcEvent := Tstringlist.Create;

  FHoldRefresh := False;
  LstDetails.Align := alClient;
  LbOriginValueDefault.Left := LbOriginValue.Left;
  LbOriginValue.ParentColor := True;
  FClinLstFrom := Nil;
  FClinlstTo := Nil;
  FImageCapturedByDUZName := '';
  Panel1.Align := alClient;
  PgctrlProps.Align := alClient;
  GetFormPosition(Self As TForm);
  EnableRelativeRange(0);
  PgctrlFltList.ActivePage := PgctrlFltListPrivate;
  PnlDetails.Align := alClient;
  ShowPackages;
//  tlbtnPkgs.Down := true;
  TabControl1.TabIndex := 0;
  LbStatusValue.Color := clBtnFace;
  LbSavedByValue.Color := clBtnFace;
End;

Procedure TfrmListFilter.ActiveControlChanged(Sender: Tobject);

Begin
{$IFDEF DEBUG}
  Try
    If Screen.ActiveControl.Name <> '' Then
    Begin
      WinMsg('Active Control : ' + Screen.ActiveControl.Name);
      If Screen.ActiveControl.Name = 'PageScroller1' Then
      Begin
                 //cmbDateRange.SetFocus;
                 //winmsg(pfm,' cmbDateRange.SetFocus' ) ;
      End;
    End
    Else
    Begin
      WinMsg('Active Control :  No Name');
    End;

  Except
        //
  End;
{$ENDIF}
End;

Procedure TfrmListFilter.New2Click(Sender: Tobject);
Var
  AllowChange: Boolean;
Begin
  AllowChange := True;
  If FFilterModified Then ConfirmSaveChange(AllowChange);
  If AllowChange Then
  Begin

    LstFltListPublic.ItemIndex := -1;
    LstFltListPrivate.ItemIndex := -1;
    ClearAll;
    Update;
    Application.Processmessages;
    EnableUserClassAbilities;
    Update;
    Application.Processmessages;
    DisplayCurFilterClass;
    Update;
    Application.Processmessages;
    If FCurFltClass = [] Then
    Begin
      SetDefaultClass;
      Update;
      Application.Processmessages;
    End;
  End;
End;

Procedure TfrmListFilter.MnuSaveAsClick(Sender: Tobject);
Begin
  SaveFilterAs;
  RefreshFilterLists;
End;

Procedure TfrmListFilter.SelectAll1Click(Sender: Tobject);
Begin
  SelectAll;
End;

Procedure TfrmListFilter.ClearAll1Click(Sender: Tobject);
Begin
  LstFltListPublic.ItemIndex := -1;
  LstFltListPrivate.ItemIndex := -1;
  ClearAll;
End;

Procedure TfrmListFilter.Refresh1Click(Sender: Tobject);
Begin
  RefreshLists;
End;

Procedure TfrmListFilter.MagMenuPublicNewItemClick(Sender: Tobject);
Begin
  //
End;

Procedure TfrmListFilter.btnOKClick(Sender: Tobject);
Begin
  //
End;

Procedure TfrmListFilter.btnCancelClick(Sender: Tobject);
Begin
  Close;
End;

Procedure TfrmListFilter.MagMenuPrivateNewItemClick(Sender: Tobject);
Begin
  //
End;

Function TfrmListFilter.Execute(Filter: TImageFilter; PDuz: String; AdvTab: Boolean = False): TImageFilter;
Begin
  Result := TImageFilter.Create;
  With TfrmListFilter.Create(Nil) Do
  Begin
    FUserAdvTab := AdvTab;
    FDuz := PDuz;
      {         Set database connection }
    FMagBroker := idmodobj.GetMagDBBroker1;
    RefreshLists; { Type,Spec...}
    RefreshFilterLists; {User's filters and public filters}
    FCanDoPublic := Userhaskey('MAG SYSTEM');
    Application.Processmessages;
    EnableUserClassAbilities; //here
    DisplayFilter(Filter);
    RefreshDetails;
    Update;
      {         Open filter add/edit  as modal window }
    If Showmodal = MrOK Then
    Begin
          {     user made changes, selected a filter, created a new ... clicked OK}
      ApplyChoicesToFilter(Result);
    End
    Else
      Result := Nil;
    Free; //6/24/03
  End;
End;

Procedure TfrmListFilter.EnableUserClassAbilities;
Begin
  FUserClassClin := Userhaskey('MAGDISP CLIN');
  FUserClassAdmin := Userhaskey('MAGDISP ADMIN');
  FUserClassANY := Userhaskey('MAG SYSTEM');

  TsClin.Enabled := FUserClassClin;
  TsClin.TabVisible := FUserClassClin;
  btnClassClin.Visible := FUserClassClin;

  TsAdmin.Enabled := FUserClassAdmin;
  TsAdmin.TabVisible := FUserClassAdmin;
  btnClassAdmin.Visible := FUserClassAdmin;

  btnClassAny.Visible := FUserClassAdmin And FUserClassClin;

  TsAdvanced.Enabled := FUserAdvTab;
  TsAdvanced.TabVisible := FUserAdvTab;

//    lbClassClin.enabled  :=  FUserClassClin;
//    lbClassAdmin.enabled :=  FUserClassAdmin;
//    lbClassAny.enabled   :=  FUserClassANY;
End;

Procedure TfrmListFilter.ApplyChoicesToFilter(Filter: TImageFilter);
Var
  Cls: TmagImageClasses;
  Pkg: TMagPackages;
  Types: String;
  SpecSubSpec: String;
  ProcEvent: String;
  Origin: String;
  i: Integer;
Begin
  Cls := [];
  Pkg := [];
  Types := '';
  SpecSubSpec := '';
  ProcEvent := '';
  Origin := '';
   //93 gek  on NEW filter, the Class wasn't being set before here.
   //    If User didn't have ability to save as Any Class, then the filter
   //    would look like it was saved, but wouldn't be.
  If FCurFltClass = [] Then
  Begin
    If FUserClassAdmin And FUserClassClin Then
      Cls := []
    Else
      If FUserClassAdmin Then
        FCurFltClass := [MclsAdmin]
      Else
        FCurFltClass := [MclsClin];
  End;
    //  if pgctrlProps.activepage = tsClin then
    //  if self.cbClinical.Checked then
  If FCurFltClass = [MclsClin] Then
  Begin
    Cls := [MclsClin];
    Pkg := [];
    If Not cbClinAll.Checked Then
    Begin
      If cbMed.Checked Then
        Pkg := Pkg + [MpkgMED];
      If cbRad.Checked Then
        Pkg := Pkg + [MpkgRAD];
      If cbSur.Checked Then
        Pkg := Pkg + [MpkgSUR];
      If cbLab.Checked Then
        Pkg := Pkg + [MpkgLAB];
      If cbCP.Checked Then
        Pkg := Pkg + [MpkgCP];
      If cbNote.Checked Then
        Pkg := Pkg + [MpkgNOTE];
      If cbNone.Checked Then
        Pkg := Pkg + [MpkgNONE];
              (* if cmbClinTypes.ItemIndex <> -1 then
                types := magpiece(cmbclintypes.items[cmbClinTypes.ItemIndex], '|', 2);*)
      For i := 0 To LstClinTypesSel.Items.Count - 1 Do
        Types := Types + MagPiece(LstClinTypesSel.Items[i], '|', 2) + ',';

              (* if cmbSubSpec.ItemIndex <> -1 then
                specsubspec := magpiece(cmbSubSpec.items[cmbSubSpec.ItemIndex], '|', 2);*)
      For i := 0 To LstSpecsSel.Items.Count - 1 Do
        SpecSubSpec := SpecSubSpec + MagPiece(LstSpecsSel.Items[i], '|', 2) + ',';

              (* if cmbProcEvent.ItemIndex <> -1 then
                procevent := magpiece(cmbProcEvent.items[cmbProcEvent.ItemIndex], '|', 2);*)
      For i := 0 To LstProcsSel.Items.Count - 1 Do
        ProcEvent := ProcEvent + MagPiece(LstProcsSel.Items[i], '|', 2) + ',';

    End;
  End;
  If FCurFltClass = [MclsAdmin] Then
  Begin
    Cls := [MclsAdmin];
    Pkg := [];
    For i := 0 To LstAdminTypesSel.Items.Count - 1 Do
      Types := Types + MagPiece(LstAdminTypesSel.Items[i], '|', 2) + ','
  End;

  If FFilterModified Then
  Begin
    Filter.Name := 'Custom';
    Filter.FilterID := '0';
  End
  Else
  Begin
    Filter.Name := FcurFltName;
    Filter.FilterID := FcurFltIEN;
  End;
  Filter.Classes := Cls;
  Filter.Packages := Pkg;
  Filter.Types := Types;
  Filter.SpecSubSpec := SpecSubSpec;
  Filter.ProcEvent := ProcEvent;
  Filter.MonthRange := FMonthRange;
  Filter.ToDate := LbValDtTo.caption;
  Filter.FromDate := LbValDtFrom.caption;
   {changes in ApplyChoicesToFilter for p93}
  Filter.Status := LbStatusValue.caption;
  Filter.UseCapDt := cbCaptureDate.Checked;
  If FImageCapturedByDUZName <> '' Then Filter.ImageCapturedBy := MagPiece(FImageCapturedByDUZName, '^', 1);
  If EdtShortDescHas.Text <> '' Then Filter.ShortDescHas := EdtShortDescHas.Text;

  {}
  Filter.Origin := Self.LbOriginValue.caption;
  (* Origin uses new FM Set Selection component.
  if cbOriginVA.Checked then Filter.origin := Filter.origin + ',' + 'VA';
  if cbOriginNONVA.Checked then Filter.origin := Filter.origin + ',' + 'NON-VA';
  if cbOriginDOD.Checked then Filter.origin := Filter.origin + ',' + 'DOD';
  if cbOriginFEE.Checked then Filter.origin := Filter.origin + ',' + 'FEE';
  *)
End;

Procedure TfrmListFilter.DisplayFilter(Filter: TImageFilter);
Var
  Cls: TmagImageClasses;
  Pkg: TMagPackages;
  i, Ii, j: Integer;
  s: String;
  Lookingfor: String;
  CurVal: String;
Begin
  ClearAll;
  {     Jerry is deleting entries from List, so we need to refresh lists each time we display a filter.}
  //  RefreshLists;   This was first way of Refreshing lists, now we do it in each of the ClearListSel calls.
  Cls := Filter.Classes;
  Pkg := Filter.Packages;

  If (MclsClin In Cls) Then
  Begin
    If Not TsClin.TabVisible Then
      TsClin.TabVisible := True;
    TsAdmin.TabVisible := False;

    //cbClinical.Checked := true;
    FCurFltClass := Cls;
    LbCurFltClass.caption := MagdisclsClinShow;

    //pgctrlProps.ActivePage := tsClin;
    If (Pkg = []) And
      (Filter.Types = '') And
      (Filter.SpecSubSpec = '') And
      (Filter.ProcEvent = '') Then
      cbClinAll.Checked := True;

    cbMed.Checked := (MpkgMED In Pkg);
    cbRad.Checked := (MpkgRAD In Pkg);
    cbSur.Checked := (MpkgSUR In Pkg);
    cbLab.Checked := (MpkgLAB In Pkg);
    cbCP.Checked := (MpkgCP In Pkg);
    cbNote.Checked := (MpkgNOTE In Pkg);
    cbCnslt.Checked := (MpkgCNSLT In Pkg);
    cbNone.Checked := (MpkgNONE In Pkg);

    // here
    If Filter.Types <> '' Then
      For i := 1 To Maglength(Filter.Types, ',') Do
      Begin
          (*    for j := 0 to cmbClinTypes.Items.count - 1 do
          // although comboboxes are not multiselect, we'll be moving to that
          //  later, (list instead of Combobox)
              if magpiece(cmbClinTypes.items[j], '|', 2) = magpiece(filter.types, ',', i)
                then begin
                  cmbclintypes.itemindex := j;
                  break;
                end;  *)
        For j := 0 To LstClinTypes.Items.Count - 1 Do
            { we've moved to listboxes...}
          If MagPiece(LstClinTypes.Items[j], '|', 2) = MagPiece(Filter.Types, ',', i) Then
          Begin
            LstClinTypesSel.Items.Add(LstClinTypes.Items[j]);
          End;
      End;

          {JK 1/7/2009 - Remove items from the "from" list if in the "to" list}
    For Ii := 0 To LstClinTypesSel.Items.Count - 1 Do
      LstClinTypes.Items.Delete(LstClinTypes.Items.Indexof(LstClinTypesSel.Items[Ii]));

    If Filter.SpecSubSpec <> '' Then
      For i := 1 To Maglength(Filter.SpecSubSpec, ',') Do
      Begin
        Lookingfor := MagPiece(Filter.SpecSubSpec, ',', i);
        For j := 0 To LstSpecs.Items.Count - 1 Do
        Begin
          CurVal := MagPiece(LstSpecs.Items[j], '|', 2);
              { we've moved to listboxes...}
          If CurVal = Lookingfor Then
              //if magpiece(lstSpecs.items[j], '|', 2) = magpiece(filter.specsubspec, ',', i) then
          Begin
            LstSpecsSel.Items.Add(LstSpecs.Items[j]);
          End;
        End;
      End;

          {JK 1/7/2009 - Remove items from the "from" list if in the "to" list}
    For Ii := 0 To LstSpecsSel.Items.Count - 1 Do
      LstSpecs.Items.Delete(LstSpecs.Items.Indexof(LstSpecsSel.Items[Ii]));

    If Filter.ProcEvent <> '' Then
      For i := 1 To Maglength(Filter.ProcEvent, ',') Do
      Begin
          (*  for j := 0 to cmbprocevent.Items.count - 1 do
          // although comboboxes are not multiselect, we'll be moving to that
          //  later, (list instead of Combobox)
              if magpiece(cmbprocevent.items[j], '|', 2) = magpiece(filter.procevent, ',', i)
                then begin
                  cmbprocevent.itemindex := j;
                  break;
                end;  *)
        For j := 0 To LstProcs.Items.Count - 1 Do
            { we've moved to listboxes...}
          If MagPiece(LstProcs.Items[j], '|', 2) = MagPiece(Filter.ProcEvent, ',', i) Then
          Begin
            LstProcsSel.Items.Add(LstProcs.Items[j]);
          End;
      End;

        {JK 1/7/2009 - Remove items from the "from" list if in the "to" list}
    For Ii := 0 To LstProcsSel.Items.Count - 1 Do
      LstProcs.Items.Delete(LstProcs.Items.Indexof(LstProcsSel.Items[Ii]));

      {specsubspec}{procevent}
  End
  Else
    If (MclsAdmin In Cls) Then
    Begin
      If Not TsAdmin.TabVisible Then
        TsAdmin.TabVisible := True;

      TsClin.TabVisible := False;

       //cbAdministrative.Checked := true;
      FCurFltClass := Cls;
      LbCurFltClass.caption := MagdisclsAdminShow;
       //pgctrlProps.ActivePage := tsAdmin;
      If Filter.Types = '' Then
        cbAdminAll.Checked := True;

      If Filter.Types <> '' Then
        For i := 1 To Maglength(Filter.Types, ',') Do
        Begin
          For j := 0 To LstAdminTypes.Items.Count - 1 Do
           // although comboboxes are not multiselect, we'll be moving to that
           //  later, (list instead of Combobox)
            If MagPiece(LstAdminTypes.Items[j], '|', 2) = MagPiece(Filter.Types, ',', i) Then
            Begin
              LstAdminTypesSel.Items.Add(LstAdminTypes.Items[j]);
            End;
        End;

       {JK 1/7/2009 - Remove items from the "from" list if in the "to" list}
      For Ii := 0 To LstAdminTypesSel.Items.Count - 1 Do
        LstAdminTypes.Items.Delete(LstAdminTypes.Items.Indexof(LstAdminTypesSel.Items[Ii]));

    End;

  EnableRelativeRange(Filter.MonthRange);
  If Filter.ToDate <> '' Then
  Begin
    LbValDtTo.caption := Filter.ToDate;
    EnableDateRange;
  End;
  If Filter.FromDate <> '' Then
  Begin
    LbValDtFrom.caption := Filter.FromDate;
    EnableDateRange;
  End;

  (*
    Filter.origin := ',' + Filter.origin + ',';
    cbOriginVA.checked := (pos(',VA,', UPPERCASE(filter.origin)) > 0);
    cbOriginNONVA.checked := (pos(',NON-VA,', UPPERCASE(filter.origin)) > 0);
    cbOriginDOD.checked := (pos(',DOD,', UPPERCASE(filter.origin)) > 0);
    cbOriginFEE.checked := (pos(',FEE,', UPPERCASE(filter.origin)) > 0);
    UpdateOriginAll;
  *)

  {Start changes for P93}
  LbOriginValue.caption := Filter.Origin;
  EdtShortDescHas.Text := Filter.ShortDescHas;

  If Filter.ImageCapturedBy <> '' Then
  Begin
//    s := xwbGetVarValue2('$P($G(^VA(200,'+filter.ImageCapturedBy+',0)),U,1)');    //here problem, ImageCapturedBy = the name, should equal DUZ
{/p94t2 gek 11/19/09  decouple from magDisplaymgr, so use call below instead of above.}
    s := FMagBroker.RPXWBGetVariableValue('$P($G(^VA(200,' + Filter.ImageCapturedBy + ',0)),U,1)');
    LbSavedByValue.caption := s;
    FImageCapturedByDUZName := Filter.ImageCapturedBy + '^' + s;
  End
  Else
  Begin
    LbSavedByValue.caption := '';
    FImageCapturedByDUZName := '';
  End;

  {JK 1/13/2009 - Fixed D52}
  If Filter.ImageCapturedBy <> '' Then
  Begin
    LbSavedByValue.Visible := True;
    LbSavedByValueDefault.Visible := False;
  End
  Else
  Begin
    LbSavedByValue.Visible := False;
    LbSavedByValueDefault.Visible := True;
  End;

  cbCaptureDate.Checked := Filter.UseCapDt;
  LbStatusValue.caption := Filter.Status;

  {}
  SetModifiedFlag(False, Filter.Name, Filter.FilterID); // Procedure DisplayFilter
  SelectFilterListItem;
  RefreshDetails;
End;

Procedure TfrmListFilter.cbClinClick(Sender: Tobject);
Begin
  RefreshLists;
End;

Procedure TfrmListFilter.cbPackageClick(Sender: Tobject);
Begin
  SetModifiedFlag(True);
  UpdateClinAll;
End;

{ TODO -ogarrett -c93 :
Need to modify UpdateClinAll for the three new lists.
lstClinType lstSpecs  lstProcs }

Procedure TfrmListFilter.UpdateClinAll;
Var
  i: Integer;
  CheckAll: Boolean;
Begin
  If FHoldRefresh Then Exit;
  CheckAll := True;

  {if one of the checkboxes is checked, then we stop because 'Clin All' will be false}
  For i := 0 To PnlPkgs.ControlCount - 1 Do
    If (PnlPkgs.Controls[i] Is TCheckBox) And (TCheckBox(PnlPkgs.Controls[i]).Checked) Then
    Begin
      CheckAll := False;
      Break;
    End;

  If CheckAll Then
  Begin
    If LstClinTypesSel.Count > 0 Then
      CheckAll := False;
    If LstProcsSel.Count > 0 Then
      CheckAll := False;
    If LstSpecsSel.Count > 0 Then
      CheckAll := False;

  //93out     if cmbClinTypes.ItemIndex <> -1 then checkAll := false;
  //93out     if cmbSubSpec.ItemIndex <> -1 then checkAll := false;
  //93out     if cmbProcEvent.ItemIndex <> -1 then checkAll := false;

  End;

  cbClinAll.Checked := CheckAll;
  RefreshDetails;

End;

Procedure TfrmListFilter.ClearSelectedAdminTypes;
Var
  i: Integer;
Begin
(*  {JK 1/7/2009 - Add all items back into the other list before clearing this list}

  for i := 0 to lstAdminTypesSel.Items.Count-1 do
    lstAdminTypes.Items.Add(lstAdminTypesSel.Items[i]); *)

  LstAdminTypesSel.Clear;
  LstAdminTypes.Items.Assign(FBaseAdminTypes); //93 gek fill the removed items.
  ClearListBoxSelections(LstAdminTypes); // ItemIndex := -1;
End;

Procedure TfrmListFilter.ClearSelectedOrigins;
Begin

End;

Procedure TfrmListFilter.ClearListBoxSelections(Lstbox: TListBox);
Var
  i: Integer;
Begin
  If Lstbox.MultiSelect Then
  Begin
    For i := 0 To Lstbox.Items.Count - 1 Do
    Begin
      If Lstbox.Selected[i] Then Lstbox.Selected[i] := False;
    End;
  End
  Else
    Lstbox.ItemIndex := -1;

End;

Procedure TfrmListFilter.FormDestroy(Sender: Tobject);
Begin
  Screen.OnActiveControlChange := Nil;
  SaveFormPosition(Self As TForm);

  FBaseClinTypes.Free;
  FBaseAdminTypes.Free;
  FBaseSpecSubSpec.Free;
  FBaseProcEvent.Free;
End;

Procedure TfrmListFilter.Exit2Click(Sender: Tobject);
Begin
  ModalResult := MrCancel;
End;

Procedure TfrmListFilter.UseOldStyleClasses(Value: Boolean);
Begin
  FTestOldStyleClasses := Value;
End;

Procedure TfrmListFilter.RefreshIndexLists;
Begin
  RefreshLists;
End;

Procedure TfrmListFilter.DropDownHeight(cbox: TComboBox);
Var
  Avail: Integer;
Begin
  Avail := TsClin.Height - (cbox.Top + cbox.Height);
  Avail := Avail Div 15;
  If (Avail > 25) Then
    cbox.DropDownCount := Avail
  Else
    cbox.DropDownCount := 25;

End;

Procedure TfrmListFilter.Help2Click(Sender: Tobject);
Begin
  WinMsg('');
  Application.HelpContext(HelpContext);
End;

Procedure TfrmListFilter.SelectDateRange();
Var
  Vdtto, Vdtfrom: String;
Begin
  WinMsg('');
  Vdtto := LbValDtTo.caption;
  Vdtfrom := LbValDtFrom.caption;

  If FrmDateRange.Execute(Vdtfrom, Vdtto) Then
  Begin
    SetModifiedFlag(True);
    EnableDateRange;
    LbValDtFrom.caption := Vdtfrom;
    LbValDtTo.caption := Vdtto;
  End;

End;

Procedure TfrmListFilter.EnableDateRange;
Begin
  FMonthRange := 0;
  LbRelativeRange.caption := '';
  PnlDateSelect.Visible := True;
  PnlDateSelect.BringToFront;
  PnlDateRange.Visible := False;

End;

Procedure TfrmListFilter.EnableRelativeRange(Range: Integer; Desc: String = '');
Var
  s: String;
Begin
  SetModifiedFlag(True);
  ClearDates;
  FMonthRange := Range;
  PnlDateRange.Visible := True;
  PnlDateRange.BringToFront;
  PnlDateSelect.Visible := False;
  If Desc = '' Then
    LbRelativeRange.caption := CreateRelativeDesc(Range)
  Else
    LbRelativeRange.caption := Desc;
  WinMsg('');
End;

Procedure TfrmListFilter.ClearDates;
Begin
// dtpickerFrom.Date := '';
// dtpickerTo.Date := '';
  LbValDtFrom.caption := '';
  LbValDtTo.caption := '';

End;

Function TfrmListFilter.CreateRelativeDesc(Range: Integer): String;
Var
  s: String;
  Mthyr: String;
  Drange: Integer;
Begin
  Drange := Abs(Range);
  Case Drange Of
    1, 12: s := '';
  Else
    s := 's';
  End;
  If Drange > 11 Then
  Begin
    Mthyr := ' Year';
    Drange := Drange Div 12;
  End
  Else
    Mthyr := ' Month';
  Mthyr := Mthyr + s;

  If Range = 0 Then
    Result := 'All Dates.'
  Else
    Result := Inttostr(Drange) + Mthyr + '   (from ' + Formatdatetime('mm/dd/yyyy', IncMonth(Date, Range)) + ')';

End;

Procedure TfrmListFilter.Label2Click(Sender: Tobject);
Begin
  ToggleDropDownDate;
End;

Procedure TfrmListFilter.ToggleDropDownDate;
Begin
  cmboxDateRange.DroppedDown := Not cmboxDateRange.DroppedDown;
End;

Procedure TfrmListFilter.GetFilterList(Lst: TListBox; PDuz: String = '');
Var
  i: Integer;
  Rstat: Boolean;
  Rmsg, s: String;
  Rlist: TStrings;
Begin
  ;
  Lst.Clear;
//ClearAll;
  Rlist := Tstringlist.Create;
  Try
    idmodobj.GetMagDBBroker1.RPFilterListGet(Rstat, Rmsg, Rlist, PDuz);
    If Not Rstat Then
      //maggmsgf.MagMsg('', rmsg)
      MagAppMsg('', Rmsg) {JK 10/5/2009 - Maggmsgu refactoring}
    Else
    Begin
      Rlist.Delete(0);
      For i := 0 To Rlist.Count - 1 Do
      Begin
        s := MagPiece(Rlist[i], '^', 2)
          + '                                                            ' +
          '^' + MagPiece(Rlist[i], '^', 1) + '^' + PDuz;
        Lst.Items.Add(s);
      End;
    End;
  Finally
    Rlist.Free;
  End;
End;

Procedure TfrmListFilter.GetSelectedFilter(Lst: TListBox);
Var
  Fltien: String;
  Rmsg: String;
  Rstat: Boolean;
  Fltdetails: String;
  Filter: TImageFilter;
Begin
  ClearAll; {getting ready to display a filter's properties.}
  If Lst.ItemIndex = -1 Then Exit;
  Fltien := MagPiece(Lst.Items[Lst.ItemIndex], '^', 2);
  idmodobj.GetMagDBBroker1.RPFilterDetailsGet(Rstat, Rmsg, Fltdetails, Fltien);
  If Not Rstat Then Exit;
  Filter := StringToFilter(Fltdetails);
  DisplayFilter(Filter);
  { SetModifiedFlag... is called in DisplayFilter}
End;

Procedure TfrmListFilter.SetModifiedFlag(Value: Boolean; Fltname: String = ''; Fltien: String = '');
Var
  Dftcap: String;
Begin
  Dftcap := 'Image Filter Add/Edit: ';
  FFilterModified := Value;
  If Value Then
  Begin
    If FcurFltName <> 'Custom' Then
    Begin
      caption := Dftcap + FcurFltName + '*';
      PnlFilterstatus.caption := FcurFltName + '*';
    End;
  End
  Else
  Begin
    FcurFltName := Fltname;
    FcurFltIEN := Fltien;
    caption := 'Image Filter Add/Edit: ' + FcurFltName;
    PnlFilterstatus.caption := FcurFltName;
  End;
End;

Procedure TfrmListFilter.btnSaveClick(Sender: Tobject);
Begin
  SaveFilter;
  RefreshFilterLists;
End;

Procedure TfrmListFilter.MnuSaveClick(Sender: Tobject);
Begin
  SaveFilter;
  RefreshFilterLists;
End;

Procedure TfrmListFilter.PgctrlFltListChange(Sender: Tobject);
Begin
  ClearAll;
  ClearListBoxSelections(LstFltListPublic);
  ClearListBoxSelections(LstFltListPrivate);
  If PgctrlProps.ActivePage = TsAdmin Then cbAdminAll.Checked := True;
  If PgctrlProps.ActivePage = TsClin Then cbClinAll.Checked := True;
  UpdateOriginAll;
  SetModifiedFlag(False, 'Custom', '0');
  EnableUserClassAbilities;
  SetDefaultClass;
End;

Procedure TfrmListFilter.SetDefaultClass;
Begin
  If FUserClassAdmin And FUserClassClin Then
    ChangeFilterClassToANY(True)
  Else
    If FUserClassAdmin Then
      ChangeFilterClassToAdmin
    Else
      ChangeFilterClassToClin;

End;

Procedure TfrmListFilter.EnableSave(Val: Boolean = True);
Begin
  btnSave.Enabled := Val;
  MnuSave.Enabled := Val;
End;

Procedure TfrmListFilter.LstFltListPublicClick(Sender: Tobject);
Var
  AllowChange: Boolean;
Begin
  AllowChange := True;
  FcurFltPub := True;
  If FFilterModified Then ConfirmSaveChange(AllowChange);
  If AllowChange Then
    GetSelectedFilter(LstFltListPublic)
  Else
    SelectFilterListItem;
  RefreshDetails;
End;

Procedure TfrmListFilter.LstFltListPrivateClick(Sender: Tobject);
Var
  AllowChange: Boolean;
Begin
  FHoldRefresh := True;
  AllowChange := True;
  FcurFltPub := False;
  If FFilterModified Then ConfirmSaveChange(AllowChange);
  If AllowChange Then
    GetSelectedFilter(LstFltListPrivate)
         //begin
         //  GetSelectedFilter(lstFltListPrivate)
         //  SetModifiedFlag(false, Filter.name, Filter.FilterID);     // Procedure lstFltListPrivateClick
         //end;
  Else
    SelectFilterListItem;

  FHoldRefresh := False;
  UpdateClinAll; {UpdateClinAll calls RefreshDetails.}
//  RefreshDetails;
  SetModifiedFlag(False, Self.FcurFltName, Self.FcurFltIEN);
  RefreshDetails;
End;

Procedure TfrmListFilter.MnuRefreshFilterlistsClick(Sender: Tobject);
Begin
  RefreshFilterLists;
End;

Procedure TfrmListFilter.RefreshFilterLists;
Begin
  GetFilterList(LstFltListPrivate, FDuz);
  GetFilterList(LstFltListPublic);
  SelectFilterListItem;
End;

Procedure TfrmListFilter.SelectFilterListItem;
Var
  i: Integer;
  Found: Boolean;
Begin
  For i := 0 To LstFltListPrivate.Items.Count - 1 Do
    If MagPiece(LstFltListPrivate.Items[i], '^', 2) = FcurFltIEN Then
    Begin
      LstFltListPrivate.ItemIndex := i;
      Found := True;
      PgctrlFltList.ActivePage := PgctrlFltListPrivate;
      Break;
    End;
  If Found Then Exit;
  For i := 0 To LstFltListPublic.Items.Count - 1 Do
    If MagPiece(LstFltListPublic.Items[i], '^', 2) = FcurFltIEN Then
    Begin
      LstFltListPublic.ItemIndex := i;
      Found := True;
      PgctrlFltList.ActivePage := PgctrlFltListPublic;
      Break;
    End;

End;

Procedure TfrmListFilter.MnuSaveAsPublicClick(Sender: Tobject);
Begin
  SaveFilterAs(True);
  RefreshFilterLists;
End;

Procedure TfrmListFilter.MnuDeleteCurrentFilterClick(Sender: Tobject);
Begin
  DeleteCurrentFilter;
End;

Procedure TfrmListFilter.DeleteCurrentFilter;
Var
  Rstat: Boolean;
  s, Rmsg: String;
Begin
  If (FcurFltName = '') Or (FcurFltIEN = '') Then
  Begin
    Messagedlg('You must Select a filter', Mtconfirmation, [Mbok], 0);
    Exit;
  End;

  If FcurFltPub Then
  Begin
    //
    If Userhaskey('MAG SYSTEM') Then
    Begin
      s := 'You have selected a Public Filter for Deletion.' + #13 + #13 +
        'Public Filters are available to all Imaging Users.' + #13 + #13 +
        'Continue ? ';
   // etc, have to complete this, if deleting public filters is wanted.
      If Messagedlg(s, Mtconfirmation, [Mbok, Mbcancel], 0) <> MrOK Then Exit;
    End
    Else
    Begin

      Messagedlg('Deleting Public Filters is not allowed!', Mtconfirmation, [Mbok], 0);
      Exit;
    End;
  End;

  If Messagedlg('Delete Filter: ' + FcurFltName, Mtconfirmation, [Mbok, Mbcancel], 0) = MrOK Then
  Begin
    idmodobj.GetMagDBBroker1.RPFilterDelete(Rstat, Rmsg, FcurFltIEN);
    If Not Rstat Then
          //maggmsgf.MagMsg('ed', rmsg)
      MagAppMsg('ed', Rmsg) {JK 10/5/2009 - Maggmsgu refactoring}
    Else
    Begin
      WinMsg(Rmsg);
      ClearAll;
    End;
  End
  Else
    WinMsg('Delete was Canceled');
  RefreshFilterLists;
End;

Procedure TfrmListFilter.UpdateOriginAll;
Begin
(*  cbOriginAll.checked := not(cbOriginVA.checked or cbOriginNonVA.checked
                              or cbOriginFEE.checked or cbOriginDOD.checked);
RefreshDetails;*)
End;

Procedure TfrmListFilter.Edit1Click(Sender: Tobject);
Begin
  If FcurFltPub And (Not FCanDoPublic) Then
    MnuDeleteCurrentFilter.Enabled := False
  Else
    MnuDeleteCurrentFilter.Enabled := True;
  If (FcurFltName = '') Or (FcurFltName = 'Custom')
    Or (Pos('DEFAULT FILTER:', Uppercase(FcurFltName)) > 0) Then MnuDeleteCurrentFilter.Enabled := False;
End;

Procedure TfrmListFilter.MnuFileClick(Sender: Tobject);
Begin
  If FCanDoPublic Then
    MnuSaveAsPublic.Enabled := True
  Else
    MnuSaveAsPublic.Enabled := False;
End;

Procedure TfrmListFilter.PgctrlFltListChanging(Sender: Tobject; Var AllowChange: Boolean);
Begin
  If FFilterModified Then ConfirmSaveChange(AllowChange);
End;

Procedure TfrmListFilter.ConfirmSaveChange(Var AllowChange: Boolean);
Var
  CurPt: TPoint;
  Ret: Integer;
Begin
  CurPt := Mouse.CursorPos;
  Ret := Messagedlgpos('Do you want to save the changes you made to Filter: "' + FcurFltName + '"', Mtconfirmation, [MbNo, MbYes, Mbcancel], 0, CurPt.x + 20, CurPt.y);
  Case Ret Of
    IdYes:
      Begin
        SaveFilter;
        AllowChange := True;
      End;
    IdNo: AllowChange := True;

    IdCancel: AllowChange := False;
  End;

End;

Procedure TfrmListFilter.LstAdminTypesDblClick(Sender: Tobject);
Begin
  AddToAdminSelectedTypes;
End;

Procedure TfrmListFilter.AddToAdminSelectedTypes;
Begin
  If LstAdminTypes.ItemIndex <> -1 Then
    If LstAdminTypesSel.Items.Indexof(LstAdminTypes.Items[LstAdminTypes.ItemIndex]) = -1 Then
    Begin
      LstAdminTypesSel.Items.Add(LstAdminTypes.Items[LstAdminTypes.ItemIndex]);
      LstAdminTypes.DeleteSelected; {JK 1/7/2009 - remove from one list if added to other}
      SetModifiedFlag(True);
      cbAdminAll.Checked := False;
    End;

  RefreshDetails;
End;

Procedure TfrmListFilter.SpeedButton3Click(Sender: Tobject);
Begin
  RemoveAllAdminSelectedTypes;
End;

Procedure TfrmListFilter.RemoveAllAdminSelectedTypes;
Begin
  If LstAdminTypesSel.Items.Count = 0 Then
    Exit;

  SetModifiedFlag(True);
  ClearSelectedAdminTypes;
  cbAdminAll.Checked := True;
  RefreshDetails;
End;

Procedure TfrmListFilter.AddToSelectedTypes;
Begin

End;

Procedure TfrmListFilter.SpeedButton1Click(Sender: Tobject);
Begin
  AddToAdminSelectedTypes;
End;

Procedure TfrmListFilter.SpeedButton2Click(Sender: Tobject);
Begin
  RemoveFromAdminSelectedTypes;
End;

Procedure TfrmListFilter.RemoveFromAdminSelectedTypes;
Begin
  If LstAdminTypesSel.ItemIndex <> -1 Then
  Begin
    LstAdminTypes.Items.Add(LstAdminTypesSel.Items[LstAdminTypesSel.ItemIndex]); {JK 1/7/2009 - Add the item into the other list}
    LstAdminTypesSel.Items.Delete(LstAdminTypesSel.ItemIndex);
    SetModifiedFlag(True);
    cbAdminAll.Checked := (LstAdminTypesSel.Items.Count = 0);
  End;
  RefreshDetails;
End;

Procedure TfrmListFilter.LstAdminTypesSelDblClick(Sender: Tobject);
Begin
  RemoveFromAdminSelectedTypes;
End;

Procedure TfrmListFilter.SpeedButton4Click(Sender: Tobject);
Begin
  cmboxDateRange.DroppedDown := True;
End;

Procedure TfrmListFilter.cmboxDateRangeChange(Sender: Tobject);
Begin
  If cmboxDateRange.ItemIndex = -1 Then Exit;

  Case cmboxDateRange.ItemIndex Of
    0: EnableRelativeRange(-1);
    1: EnableRelativeRange(-3);
    2: EnableRelativeRange(-6);
    3: EnableRelativeRange(-12);
    4: EnableRelativeRange(-24);
    5: EnableRelativeRange(-60);
    6: EnableRelativeRange(0);
    7: SelectDateRange;
  End;
//cmboxDateRange.ItemIndex := -1 ;
  RefreshDetails;
End;

Procedure TfrmListFilter.PnlDateRangeClick(Sender: Tobject);
Begin
  ToggleDropDownDate;
End;

Procedure TfrmListFilter.LbRelativeRangeClick(Sender: Tobject);
Begin
  ToggleDropDownDate;
End;

Procedure TfrmListFilter.LbValDtFromClick(Sender: Tobject);
Begin
  ToggleDropDownDate;
End;

Procedure TfrmListFilter.Label3Click(Sender: Tobject);
Begin
  ToggleDropDownDate;
End;

Procedure TfrmListFilter.LbValDtToClick(Sender: Tobject);
Begin
  ToggleDropDownDate;
End;

Procedure TfrmListFilter.PnlDateSelectClick(Sender: Tobject);
Begin
  ToggleDropDownDate;
End;

Procedure TfrmListFilter.cbClinAllClick(Sender: Tobject);
Begin
  SetModifiedFlag(True);
  If cbClinAll.Checked Then
  Begin
    cbRad.Checked := False;
    cbMed.Checked := False;
    cbSur.Checked := False;
    cbLab.Checked := False;
    cbNote.Checked := False;
    cbCP.Checked := False;
    cbCnslt.Checked := False;
    cbNone.Checked := False;
    Self.ClearSelectedClinTypes;
    Self.ClearSelectedSpecs;
    Self.ClearSelectedProcs;
//93out      cmbClinTypes.ItemIndex := -1;
//93out      cmbSubSpec.ItemIndex := -1;
//93out      cmbProcEvent.ItemIndex := -1;
  End;
  RefreshDetails;
End;

Procedure TfrmListFilter.cbAdminAllClick(Sender: Tobject);
Begin
  SetModifiedFlag(True);
  If cbAdminAll.Checked Then ClearSelectedAdminTypes;
  RefreshDetails;
End;

Procedure TfrmListFilter.LstFltListPrivateDblClick(Sender: Tobject);
Begin
  If LstFltListPrivate.ItemIndex <> -1 Then ModalResult := MrOK;
End;

Procedure TfrmListFilter.LstFltListPublicDblClick(Sender: Tobject);
Begin
  If LstFltListPublic.ItemIndex <> -1 Then ModalResult := MrOK;
End;

Procedure TfrmListFilter.FormShow(Sender: Tobject);
Begin
  GetFormPosition(Self As TForm);
  If PgctrlFltList.ActivePage = PgctrlFltListPrivate Then
    LstFltListPrivate.SetFocus
  Else
    If PgctrlFltList.ActivePage = PgctrlFltListPublic Then
      LstFltListPublic.SetFocus;
End;

Procedure TfrmListFilter.MnuDeletePrivateFilterClick(Sender: Tobject);
Begin
// PrivatePopup delete
  DeleteCurrentFilter;
End;

Procedure TfrmListFilter.MnuPrivatePopupPopup(Sender: Tobject);
Begin
  If FcurFltPub And (Not FCanDoPublic) Then
    MnuDeletePrivateFilter.Enabled := False
  Else
    MnuDeletePrivateFilter.Enabled := True;
  If (FcurFltName = '') Or (FcurFltName = 'Custom')
    Or (Pos('DEFAULT FILTER:', Uppercase(FcurFltName)) > 0) Then MnuDeletePrivateFilter.Enabled := False;
End;

Procedure TfrmListFilter.MnuAddTypesClick(Sender: Tobject);
Begin
  AddToAdminSelectedTypes;
End;

Procedure TfrmListFilter.MnuRemoveTypesClick(Sender: Tobject);
Begin
  RemoveFromAdminSelectedTypes;
End;

Procedure TfrmListFilter.MnuRemoveAllTypesClick(Sender: Tobject);
Begin
  RemoveAllAdminSelectedTypes;
End;

Procedure TfrmListFilter.LstAdminTypesKeyDown(Sender: Tobject;
  Var Key: Word; Shift: TShiftState);
Begin
  Case Key Of
    39: AddToAdminSelectedTypes;
  End;
End;

{JK 12/30/2008.  Added this SetTabs procedure to set tab stops in the TListBox
 object for filters.}

Procedure TfrmListFilter.SetTabs(LB: TListBox);
Const
  MAX_TABS = 4;
Var
  Tabulators: Array[0..MAX_TABS] Of Integer;
Begin
  {Set the Tabulator Widths}
  Tabulators[0] := 90;
  Tabulators[1] := 120;
  Tabulators[2] := 100;
  Tabulators[3] := 80;

  LB.TabWidth := 1;

  {Set the Tabulators}
  SendMessage(LB.Handle, LB_SETTABSTOPS, MAX_TABS, Longint(@Tabulators));
End;

Procedure TfrmListFilter.LstAdminTypesSelKeyDown(Sender: Tobject;
  Var Key: Word; Shift: TShiftState);
Begin
  Case Key Of
    37: RemoveFromAdminSelectedTypes;
  End;
End;

Procedure TfrmListFilter.RefreshDetails;
Var
  t: TStrings;
  s: String;
  i: Integer;
  Filter: TImageFilter;
Begin
  If FHoldRefresh Then Exit;
  Filter := TImageFilter.Create;
  Try
    s := '';
    t := Tstringlist.Create;
    Self.ApplyChoicesToFilter(Filter);

    {JK 12/30/2008.  Set tabs here.  In the uMagDisplayMgr.DetailedDescGen method,
     set up the data using tabs.  Each tab (#9) corresponds to the preset tab stops.}
    SetTabs(LstDetails);

    t := GetFilterDesc(Filter, idmodobj.GetMagDBBroker1);
    LstDetails.Items.Assign(t);
    //LoadLVDetails(filter);
  Finally
    Filter.Free;
  End;
End;

Procedure TfrmListFilter.LoadLVDetails(Filter: TImageFilter);
Var
  s, Stype, Sspec, Sproc: String;
  Ixien: String;
  i, Ixp, Ixl, Ixi: Integer;
  Li: TListItem;
  t: TStrings;
Begin
  LvDetails.Items.BeginUpdate;
  LvDetails.Clear;
  t := Tstringlist.Create;
  Try
//  Result.add(' Filter Details:    ' +filter.Name);
//  result.add('*********************************');
    t.Add('Property^Value');
    s := ClassesToString(Filter.Classes);
    If s = '' Then s := 'Any';
    t.Add('Class^' + s);
//  result.add('');

    s := Filter.Origin;
    If s = '' Then s := 'Any';
    If Pos(',', s) = 1 Then s := Copy(s, 2, 999);
    t.Add('Origin^' + s);
//  result.add('');

  // we have a few if, rather that if then else for a reason
  //  we want to make sure the date properties are getting cleared when
  //  they should.  Only one of the IF's below, should be TRUE.
  //   If not, then we'll see it and know of a problem.
    If ((Filter.FromDate <> '') Or (Filter.ToDate <> '')) Then
    Begin
      t.Add('Dates^from: ' + Filter.FromDate + '  thru  ' + Filter.ToDate);
    End;
    If (Filter.MonthRange <> 0) Then
    Begin
      t.Add('Dates^for the last ' + Inttostr(Abs(Filter.MonthRange)) + ' months.');
    End;
    If (Filter.MonthRange = 0) And (Filter.FromDate = '') And (Filter.ToDate = '') Then
      t.Add('Dates^All Dates.');
//  result.add('');

    s := PackagesToString(Filter.Packages);
    If s = '' Then s := 'Any';
    t.Add('Packages^' + s);
    t.Add('Types^');
    Stype := Filter.Types;
    s := '';
    If Stype = '' Then
      s := 'Any'
    Else
    Begin
      Ixl := Maglength(Stype, ',');
      For Ixi := 1 To Ixl Do
      Begin
        Ixien := MagPiece(Stype, ',', Ixi);
        If Ixien <> '' Then t.Add(' --- ^' + idmodobj.GetMagDBBroker1.RPXWBGetVariableValue('$P($G(^MAG(2005.83,' + Ixien + ',0)),U,1)'));
      End;
    End;
 // t.add('Types^' + s);
//  result.add('');

    t.Add('Specialty/SubSpecialty^');
    Sspec := Filter.SpecSubSpec;
    s := '';
    If Sspec = '' Then
      s := 'Any'
    Else
    Begin
      Ixl := Maglength(Sspec, ',');
      For Ixi := 1 To Ixl Do
      Begin
        Ixien := MagPiece(Sspec, ',', Ixi);
        If Ixien <> '' Then s := s + idmodobj.GetMagDBBroker1.RPXWBGetVariableValue('$P($G(^MAG(2005.84,' + Ixien + ',0)),U,1)') + ',';
      End;
    End;
    t.Add('Specialty/SubSpecialty^' + s);

//  result.add('');

//  result.add('[Procedure/Event]:');
    Sproc := Filter.ProcEvent;
    s := '';
    If Sproc = '' Then
      s := '        Any'
    Else
    Begin
      Ixl := Maglength(Sproc, ',');
      For Ixi := 1 To Ixl Do
      Begin
        Ixien := MagPiece(Sproc, ',', Ixi);
        If Ixien <> '' Then s := s + idmodobj.GetMagDBBroker1.RPXWBGetVariableValue('$P($G(^MAG(2005.85,' + Ixien + ',0)),U,1)') + ',';
      End;
    End;
    t.Add('Procedure/Event^' + s);
//  result.add('');

  {  s := filter.Origin;
  if s='' then s := 'Any';
  if pos(',',s) =1 then s := copy(s,2,999);
  result.add('Origin :       '+s);}

    s := Filter.Status;
    If s = '' Then s := 'Any';
    t.Add('Status^' + s);

    Ixien := Filter.ImageCapturedBy;
    If Ixien <> '' Then
      s := idmodobj.GetMagDBBroker1.RPXWBGetVariableValue('$P($G(^VA(200,' + Ixien + ',0)),U,1)')
    Else
      s := 'Any';
    t.Add('Saved By^' + s);

    s := Magbooltostr(Filter.UseCapDt);
    t.Add('Search on Capture Date^' + s);

   //result.Add('Short Description has:');
    s := Filter.ShortDescHas;
    If s = '' Then s := 'Any';
    t.Add('Short Description has^' + s);

    LvDetails.LoadListFromStrings(t);
  Finally
    LvDetails.Items.EndUpdate;
  End;
End;

Procedure TfrmListFilter.ShowPackages;
Begin
  HideAllClinLists;
  Self.PnlPkgs.Show;
  LbClinProperty.caption := 'VistA Packages';
End;

Procedure TfrmListFilter.ShowClinTypes;
Begin
  HideAllClinLists;
  LstClinTypes.Visible := True;
  LstClinTypesSel.Visible := True;
  LbClinProperty.caption := 'Clinical Types';
  PnlMoveBtns.Visible := True;
  FClinLstFrom := LstClinTypes;
  FClinlstTo := LstClinTypesSel;
End;

Procedure TfrmListFilter.ShowSpecs;
Begin
  HideAllClinLists;
  LstSpecs.Visible := True;
  LstSpecsSel.Visible := True;
  LbClinProperty.caption := 'Specialty/Subspecialty';
  PnlMoveBtns.Visible := True;
  FClinLstFrom := LstSpecs;
  FClinlstTo := LstSpecsSel;
End;

Procedure TfrmListFilter.ShowProcs;
Begin
  HideAllClinLists;
  LstProcs.Visible := True;
  LstProcsSel.Visible := True;
  LbClinProperty.caption := 'Procedure/Event';
  PnlMoveBtns.Visible := True;
  FClinLstFrom := LstProcs;
  FClinlstTo := LstProcsSel;
End;

Procedure TfrmListFilter.HideAllClinLists;
Begin
  PnlMoveBtns.Visible := False;
  FClinLstFrom := Nil;
  FClinlstTo := Nil;
  PnlPkgs.Visible := False;
  LstClinTypes.Visible := False;
  LstClinTypesSel.Visible := False;
  LstSpecs.Visible := False;
  LstSpecsSel.Visible := False;
  LstProcs.Visible := False;
  LstProcsSel.Visible := False;
End;

Procedure TfrmListFilter.ClearAllClinLists;
Begin
  LstClinTypes.Clear;
  LstClinTypesSel.Clear;
  LstSpecs.Clear;
  LstSpecsSel.Clear;
  LstProcs.Clear;
  LstProcsSel.Clear;
End;

Procedure TfrmListFilter.LstClinTypesDblClick(Sender: Tobject);
Begin
  AddToClinSelectedTypes;
End;

Procedure TfrmListFilter.LstClinTypesKeyDown(Sender: Tobject;
  Var Key: Word; Shift: TShiftState);
Begin
  Case Key Of
    39: AddToClinSelectedTypes;
  End;
End;

Procedure TfrmListFilter.AddToClinSelectedTypes;
Begin
  If LstClinTypes.ItemIndex <> -1 Then
    If LstClinTypesSel.Items.Indexof(LstClinTypes.Items[LstClinTypes.ItemIndex]) = -1 Then
    Begin
      LstClinTypesSel.Items.Add(LstClinTypes.Items[LstClinTypes.ItemIndex]);
      LstClinTypes.DeleteSelected; {JK 1/7/2009 - Remove item from list}
      SetModifiedFlag(True);
      UpdateClinAll;
    End;
  RefreshDetails;
End;

Procedure TfrmListFilter.LstSpecsDblClick(Sender: Tobject);
Begin
  AddToSpecsSel;
End;

Procedure TfrmListFilter.LstSpecsKeyDown(Sender: Tobject; Var Key: Word;
  Shift: TShiftState);
Begin
  Case Key Of
    39: AddToSpecsSel;
  End;
End;

Procedure TfrmListFilter.AddToSpecsSel;
Begin
  If LstSpecs.ItemIndex <> -1 Then
    If LstSpecsSel.Items.Indexof(LstSpecs.Items[LstSpecs.ItemIndex]) = -1 Then
    Begin
      LstSpecsSel.Items.Add(LstSpecs.Items[LstSpecs.ItemIndex]);
      LstSpecs.DeleteSelected; {JK 1/7/2009 - Remove item from list}
      SetModifiedFlag(True);
      UpdateClinAll;
    End;
  RefreshDetails;
End;

Procedure TfrmListFilter.LstProcsDblClick(Sender: Tobject);
Begin
  AddToProcsSel;
End;

Procedure TfrmListFilter.LstProcsKeyDown(Sender: Tobject; Var Key: Word;
  Shift: TShiftState);
Begin
  Case Key Of
    39: AddToProcsSel;
  End;
End;

Procedure TfrmListFilter.AddToProcsSel;
Begin
  If LstProcs.ItemIndex <> -1 Then
    If LstProcsSel.Items.Indexof(LstProcs.Items[LstProcs.ItemIndex]) = -1 Then
    Begin
      LstProcsSel.Items.Add(LstProcs.Items[LstProcs.ItemIndex]);
      LstProcs.DeleteSelected; {JK 1/7/2009 - Remove item from list}
      SetModifiedFlag(True);
      UpdateClinAll;
    End;
  RefreshDetails;
End;

Procedure TfrmListFilter.ClearSelectedClinTypes;
Begin
  LstClinTypesSel.Clear;
  LstClinTypes.Items.Assign(FBaseClinTypes); //93 gek fill the removed items.
  ClearListBoxSelections(LstClinTypes); // ItemIndex := -1;
End;

Procedure TfrmListFilter.ClearSelectedSpecs;
Begin
  LstSpecsSel.Clear;
  LstSpecs.Items.Assign(FBaseSpecSubSpec); //93 gek fill the removed items.
  ClearListBoxSelections(LstSpecs); // ItemIndex := -1;
End;

Procedure TfrmListFilter.ClearSelectedProcs;
Begin
  LstProcsSel.Clear;
  LstProcs.Items.Assign(FBaseProcEvent); //93 gek fill the removed items.
  ClearListBoxSelections(LstProcs); // ItemIndex := -1;
End;

Procedure TfrmListFilter.LstClinTypesSelKeyDown(Sender: Tobject;
  Var Key: Word; Shift: TShiftState);
Begin
  Case Key Of
    37: RemoveFromClinSelectedTypes; //RemoveFromSpecsSelected;
  End;
End;

Procedure TfrmListFilter.LstClinTypesSelDblClick(Sender: Tobject);
Begin
  RemoveFromClinSelectedTypes;
  //cbClinAll.Checked := (lstClinTypesSel.Items.Count = 0) ;  {JK 1/5/2009 - Fixes D39}
End;

Procedure TfrmListFilter.RemoveFromClinSelectedTypes;
Begin
  If LstClinTypesSel.ItemIndex <> -1 Then
  Begin
    LstClinTypes.Items.Add(LstClinTypesSel.Items[LstClinTypesSel.ItemIndex]); {JK 1/7/2009 - Add the item into the other list}
    LstClinTypesSel.Items.Delete(LstClinTypesSel.ItemIndex);
    SetModifiedFlag(True);
    //cbClinAll.checked := (lstClinTypesSel.Items.Count = 0) ;
  End;
  RefreshDetails;
End;

Procedure TfrmListFilter.RemoveFromSpecsSelected;
Begin
  If LstSpecsSel.ItemIndex <> -1 Then
  Begin
    LstSpecs.Items.Add(LstSpecsSel.Items[LstSpecsSel.ItemIndex]); {JK 1/7/2009 - Add the item into the other list}
    LstSpecsSel.Items.Delete(LstSpecsSel.ItemIndex);
    SetModifiedFlag(True);
    //cbClinAll.checked := (lstSpecsSel.Items.Count = 0) ;
  End;
  RefreshDetails;
End;

Procedure TfrmListFilter.RemoveFromProcsSelected;
Begin
  If LstProcsSel.ItemIndex <> -1 Then
  Begin
    LstProcs.Items.Add(LstProcsSel.Items[LstProcsSel.ItemIndex]); {JK 1/7/2009 - Add the item into the other list}
    LstProcsSel.Items.Delete(LstProcsSel.ItemIndex);
    SetModifiedFlag(True);
    //cbClinAll.checked := (lstProcsSel.Items.Count = 0) ;
  End;
  RefreshDetails;
End;

Procedure TfrmListFilter.LstSpecsSelDblClick(Sender: Tobject);
Begin
  RemoveFromSpecsSelected;
End;

Procedure TfrmListFilter.LstSpecsSelKeyDown(Sender: Tobject; Var Key: Word;
  Shift: TShiftState);
Begin
  Case Key Of
    37: RemoveFromSpecsSelected;
  End;
End;

Procedure TfrmListFilter.LstProcsSelDblClick(Sender: Tobject);
Begin
  RemoveFromProcsSelected;
  //cbClinAll.Checked := (lstClinTypesSel.Items.Count = 0) ;  {JK 1/5/2009 - Fixes D39}
End;

Procedure TfrmListFilter.LstProcsSelKeyDown(Sender: Tobject; Var Key: Word;
  Shift: TShiftState);
Begin
  Case Key Of
    37: RemoveFromProcsSelected;
  End;
End;

Procedure TfrmListFilter.RefreshDetails1Click(Sender: Tobject);
Begin
  RefreshDetails;
End;

Procedure TfrmListFilter.PgctrlClassChange(Sender: Tobject);
Begin
(*  ClearAll;
  ClearListBoxSelections(lstFltListPublic);
  ClearListBoxSelections(lstFltListPrivate);
  if pgctrlClass.activePage =  tsAdmin then  cbAdminAll.Checked := true;
  if pgctrlClass.activePage =  tsClin then  cbClinAll.Checked := true;
  UpdateOriginAll;
  SetModifiedFlag(false, 'Custom', '0');
    RefreshDetails;*)
End;

Procedure TfrmListFilter.PgctrlClassChanging(Sender: Tobject;
  Var AllowChange: Boolean);
Begin
//allowchange defaults to true;
(*  if FFilterModified then
    AllowChange := messagedlg('Filter has been modified, Discard changes and continue ?', mtconfirmation, [mbok, mbcancel], 0) = mrok
  else
    AllowChange := true;*)
///// 93 now this is checked when Radio butons are checked.
/////if FFilterModified then ConfirmSaveChange(allowchange);
/////  RefreshDetails;
End;

Procedure TfrmListFilter.cbProcDateClick(Sender: Tobject);
Begin
  SetModifiedFlag(True);
  RefreshDetails;
End;

Procedure TfrmListFilter.FilterStatusEdit;
Var
  FMSet: TImageFMSet;
  s, S1: String;
Begin
  FMSet := TImageFMSet.Create;
  s := idmodobj.GetMagDBBroker1.RPXWBGetVariableValue('$P($G(^DD(2005,113,0)),U,3)');
  FMSet.DBSetDefinition := s;
  FMSet.DBSetName := 'Status';
  S1 := FrmFMSetSelect.Execute(FMSet, LbStatusValue.caption, False, 'Deleted');
  LbStatusValue.caption := S1;
  SetModifiedFlag(True);
  RefreshDetails;
End;

Procedure TfrmListFilter.FilterSavedByEdit;
Var
  s: String;
Begin
  If Not SearchVistAFile('200', 'User : ', 'Enter a few letters of the last name then press Enter.', 'Select the User', '', False, s) Then
    Exit;

  LbSavedByValue.caption := MagPiece(s, '^', 2);

  {JK 1/13/2009 - Fixed D52}
  If s <> '' Then
  Begin
    LbSavedByValue.Visible := True;
    LbSavedByValueDefault.Visible := False;
  End
  Else
  Begin
    LbSavedByValue.Visible := False;
    LbSavedByValueDefault.Visible := True;
  End;

  FImageCapturedByDUZName := s;
  SetModifiedFlag(True);
  RefreshDetails;
End;

Procedure TfrmListFilter.SelectedChoicesToSelected;
Var
  i: Integer;
Begin
  If FClinLstFrom.ItemIndex <> -1 Then

    If FClinLstFrom.Selected[FClinLstFrom.ItemIndex] Then
    Begin
      If FClinlstTo.Items.Indexof(FClinLstFrom.Items[FClinLstFrom.ItemIndex]) = -1 Then
      Begin
        FClinlstTo.Items.Add(FClinLstFrom.Items[FClinLstFrom.ItemIndex]);

          {gek 508 changed to Tab Control    Pkg, Type, Spec, Proc}
        Case TabControl1.TabIndex Of
          1: LstClinTypes.DeleteSelected;
          2: LstSpecs.DeleteSelected;
          3: LstProcs.DeleteSelected;
        End;
        SetModifiedFlag(True);
        Self.cbClinAll.Checked := False;
      End;
    End;

  RefreshDetails;
End;

Procedure TfrmListFilter.FilterOriginEdit;
Var
  FMSet: TImageFMSet;
  s, S1: String;
Begin
  FMSet := TImageFMSet.Create;
  s := idmodobj.GetMagDBBroker1.RPXWBGetVariableValue('$P($G(^DD(2005,45,0)),U,3)');
  FMSet.DBSetDefinition := s;
  FMSet.DBSetName := 'Origin';
  S1 := FrmFMSetSelect.Execute(FMSet, LbOriginValue.caption);

  LbOriginValue.caption := S1;
  //Self.lbOriginValueDefault.Visible := (s1 = '');

  {JK 1/13/2009 - Fixed D53}
  If S1 <> '' Then
  Begin
    LbOriginValue.Visible := True;
    LbOriginValueDefault.Visible := False;
  End
  Else
  Begin
    LbOriginValue.Visible := False;
    LbOriginValueDefault.Visible := True;
  End;

  SetModifiedFlag(True);
  RefreshDetails;
End;

Procedure TfrmListFilter.FilterSavedByClear;
Begin
  {JK 1/13/2009 - Fixed D52}
  LbSavedByValue.Visible := False;
  LbSavedByValueDefault.Visible := True;

  LbSavedByValue.caption := '';
  FImageCapturedByDUZName := '';
  SetModifiedFlag(True);
  RefreshDetails;
End;

Procedure TfrmListFilter.FilterStatusClear;
Begin
  LbStatusValue.caption := '';
  SetModifiedFlag(True);
  RefreshDetails;
End;

Procedure TfrmListFilter.FilterOriginClear;
Begin
  LbOriginValue.caption := '';
  Self.LbOriginValueDefault.Visible := True;
  SetModifiedFlag(True);
  RefreshDetails;
End;

Procedure TfrmListFilter.LstDetailsClick(Sender: Tobject);
Var
  s: String;
  i: Integer;
Begin
  s := LstDetails.Items[LstDetails.ItemIndex];
  If Pos(']', s) > 0 Then
  Begin
    If Pos('Class', s) > 0 Then
    Begin
      PgctrlProps.ActivePage := TsGeneral
    End;
    If Pos('Origin', s) > 0 Then
    Begin
      PgctrlProps.ActivePage := TsGeneral;
    End;
    If Pos('Dates', s) > 0 Then
    Begin
      PgctrlProps.ActivePage := TsGeneral;
    End;
    If Pos('Packages', s) > 0 Then
    Begin
      If Not TsClin.TabVisible Then Exit;
      PgctrlProps.ActivePage := TsClin;
      If PgctrlProps.ActivePage = TsClin Then
      Begin
        ShowPackages;
           //gek 508 tlbtnpkgs.Down := true;
        TabControl1.TabIndex := 0;
      End;
    End;
    If Pos('Types', s) > 0 Then
    Begin
      If TsClin.TabVisible Then
      Begin
        PgctrlProps.ActivePage := TsClin;
        If PgctrlProps.ActivePage = TsClin Then
        Begin
          ShowClinTypes;
              //508 tlbtnClinTypes.Down := true;
          TabControl1.TabIndex := 1;

        End;
      End
      Else
        If TsAdmin.TabVisible Then
        Begin
          PgctrlProps.ActivePage := TsAdmin;
        End;
    End;

    If Pos('Specialty', s) > 0 Then
    Begin
      If Not TsClin.TabVisible Then Exit;
      PgctrlProps.ActivePage := TsClin;
      If PgctrlProps.ActivePage = TsClin Then
      Begin
        ShowSpecs;
//508          tlbtnSpecs.Down := true;
        TabControl1.TabIndex := 2;

      End;
    End;
    If Pos('Procedure', s) > 0 Then
    Begin
      If Not TsClin.TabVisible Then Exit;
      PgctrlProps.ActivePage := TsClin;
      If PgctrlProps.ActivePage = TsClin Then
      Begin
        ShowProcs;
//508          tlbtnProcs.Down := true;
        TabControl1.TabIndex := 3;

      End;
    End;
    If Pos('Status', s) > 0 Then
    Begin
      If TsAdvanced.TabVisible Then
        PgctrlProps.ActivePage := TsAdvanced;
    End;
    If Pos('Saved By', s) > 0 Then
    Begin
      If TsAdvanced.TabVisible Then
        PgctrlProps.ActivePage := TsAdvanced;
    End;
    If Pos('Capture Date', s) > 0 Then
    Begin
      If TsAdvanced.TabVisible Then
        PgctrlProps.ActivePage := TsAdvanced;
    End;
    If Pos('Short Desc', s) > 0 Then
    Begin
      If TsAdvanced.TabVisible Then
        PgctrlProps.ActivePage := TsAdvanced;
    End;

  End;
End;

Procedure TfrmListFilter.ChangeFilterClassToClin;
Var
  AllowChange: Boolean;
Begin

  DisplayCurFilterClass;
  If FCurFltClass = [MclsClin] Then Exit;

  AllowChange := True;
  If FFilterModified Then ConfirmSaveChange(AllowChange);
  If AllowChange Then { Allow Changing to Clin }
  Begin
    ClearAll;
    ClearListBoxSelections(LstFltListPublic);
    ClearListBoxSelections(LstFltListPrivate);

    TsClin.Visible := True;
    TsClin.TabVisible := True;
    //pgctrlProps.activePage :=  tsClin;
    cbClinAll.Checked := True;
    //cbClinical.Checked := true;
    FCurFltClass := [MclsClin];
    LbCurFltClass.caption := MagdisclsClinShow;
    TsAdmin.Visible := False;
    TsAdmin.TabVisible := False;

    UpdateOriginAll;
    SetModifiedFlag(False, 'Custom', '0');
    RefreshDetails;
  End
  Else
  Begin
     // cbAdministrative.Checked := true;
    FCurFltClass := [MclsAdmin];
    LbCurFltClass.caption := MagdisclsAdminShow;
  End;
  RefreshDetails;
End;

Procedure TfrmListFilter.DisplayCurFilterClass;
Begin
  If FCurFltClass = [] Then LbCurFltClass.caption := MagclsAllShow;
  If FCurFltClass = [MclsClin] Then LbCurFltClass.caption := MagdisclsClinShow;
  If FCurFltClass = [MclsAdmin] Then LbCurFltClass.caption := MagdisclsAdminShow;
End;

Procedure TfrmListFilter.ChangeFilterClassToAdmin;
Var
  AllowChange: Boolean;
Begin
        {       if already are administrative, then exit}
  DisplayCurFilterClass;
  If FCurFltClass = [MclsAdmin] Then Exit;
  AllowChange := True;

  If FFilterModified Then ConfirmSaveChange(AllowChange);
  If AllowChange Then
  Begin
    ClearAll;
    ClearListBoxSelections(LstFltListPublic);
    ClearListBoxSelections(LstFltListPrivate);
    TsAdmin.Visible := True;
    TsAdmin.TabVisible := True;
    //pgctrlProps.activePage :=  tsAdmin;
    cbAdminAll.Checked := True;
    //cbAdministrative.Checked := true;
    FCurFltClass := [MclsAdmin];
    LbCurFltClass.caption := MagdisclsAdminShow;
    TsClin.Visible := False;
    TsClin.TabVisible := False;

    UpdateOriginAll;
    SetModifiedFlag(False, 'Custom', '0');
    RefreshDetails;
  End
  Else
  Begin
      //cbClinical.Checked := true;
    FCurFltClass := [MclsClin];
    LbCurFltClass.caption := MagdisclsClinShow;

  End;
  RefreshDetails;
End;

Procedure TfrmListFilter.ChangeFilterClassToANY(Forcechange: Boolean = False);
Var
  AllowChange: Boolean;
Begin
  AllowChange := True;
  DisplayCurFilterClass;

  If Not Forcechange Then
  Begin
    If (FCurFltClass = []) Then Exit;
    AllowChange := True;
    If FFilterModified Then ConfirmSaveChange(AllowChange);
  End;

  If AllowChange Then
  Begin
    ClearAll;
    ClearListBoxSelections(LstFltListPublic);
    ClearListBoxSelections(LstFltListPrivate);
    TsAdmin.TabVisible := False;
    TsClin.TabVisible := False;
    cbAdminAll.Checked := True;
    cbClinAll.Checked := True;
    FCurFltClass := [];
    LbCurFltClass.caption := MagclsAllShow;

    UpdateOriginAll;
    SetModifiedFlag(False, 'Custom', '0');
    RefreshDetails;
  End
  Else
  Begin
      //cbClinical.Checked := true;
    //FCurFltClass := [mclsClin];
    //lbCurFltClass.Caption :=  magdisclsClinShow ;

  End;
 //RefreshDetails;
End;

Procedure TfrmListFilter.Label1MouseEnter(Sender: Tobject);
Begin
  (Sender As Tlabel).Color := clSkyBlue;
  (Sender As Tlabel).Font.Color := clBlue;
  (Sender As Tlabel).Font.Style := (Sender As Tlabel).Font.Style + [Fsbold];
End;

Procedure TfrmListFilter.Label1MouseLeave(Sender: Tobject);
Begin
  (Sender As Tlabel).Color := clBtnFace;
  (Sender As Tlabel).Font.Color := clBlack;
  (Sender As Tlabel).Font.Style := (Sender As Tlabel).Font.Style - [Fsbold];
End;

Procedure TfrmListFilter.LabelButtonMouseEnter(Sender: Tobject);
Begin
//  (sender as tLabel).Color :=  clSkyBlue;
  (Sender As Tlabel).Font.Color := clBlue;
  (Sender As Tlabel).Font.Style := (Sender As Tlabel).Font.Style + [Fsbold];
End;

Procedure TfrmListFilter.LabelbuttonMouseLeave(Sender: Tobject);
Begin
//  (sender as tLabel).Color :=  clbtnFace;
  (Sender As Tlabel).Font.Color := clBlack;
  (Sender As Tlabel).Font.Style := (Sender As Tlabel).Font.Style - [Fsbold];
End;

Procedure TfrmListFilter.cbCaptureDateClick(Sender: Tobject);
Begin
  SetModifiedFlag(True);
  RefreshDetails;
End;

Procedure TfrmListFilter.EdtShortDescHasChange(Sender: Tobject);
Begin
  SetModifiedFlag(True);
  RefreshDetails;
End;

Procedure TfrmListFilter.EdtShortDescHasExit(Sender: Tobject);
Begin
  RefreshDetails;
End;

Procedure TfrmListFilter.EdtShortDescHasKeyDown(Sender: Tobject;
  Var Key: Word; Shift: TShiftState);
Begin
  If Key = VK_Return Then RefreshDetails;
End;

Procedure TfrmListFilter.FormClose(Sender: Tobject;
  Var action: TCloseAction);
Begin
  SaveFormPosition(Self As TForm);
End;

Procedure TfrmListFilter.SbtnClinSelOneClick(Sender: Tobject);
Begin
  SelectedChoicesToSelected;
End;

Procedure TfrmListFilter.SbtnClinUnSelAllClick(Sender: Tobject);
Var
  i: Integer;
Begin
  For i := 0 To FClinlstTo.Items.Count - 1 Do
    FClinLstFrom.Items.Add(FClinlstTo.Items[i]); {JK 1/7/2009 - move items back to the From list}

  FClinlstTo.Clear;
  SetModifiedFlag(True);
  RefreshDetails;

End;

Procedure TfrmListFilter.SbtnClinSelAllClick(Sender: Tobject);
Begin
  FClinlstTo.Clear;
  FClinlstTo.Items.Assign(FClinLstFrom.Items);
  SetModifiedFlag(True);
  RefreshDetails;
End;

Procedure TfrmListFilter.SbtnClinUnSelOneClick(Sender: Tobject);
Begin
  {JK 1/7/2009 - move items back to the From list}
(* gek 508
  if tlbtnClinTypes.Down then
    if lstClinTypesSel.ItemIndex = -1 then
      Exit
    else
      lstClinTypes.Items.Add(lstClinTypesSel.Items[lstClinTypesSel.ItemIndex])
  else if tlbtnSpecs.Down then
    if lstSpecsSel.ItemIndex = -1 then
      Exit
    else
      lstSpecs.Items.Add(lstSpecsSel.Items[lstSpecsSel.ItemIndex])
  else if tlbtnProcs.Down then
    if lstProcsSel.ItemIndex = -1 then
      Exit
    else
      lstProcs.Items.Add(lstProcsSel.Items[lstProcsSel.ItemIndex]);
*)

  Case TabControl1.TabIndex Of
    0:
      Begin
      // It'll not be 0,  Packages are handled different.
      End;
    1:
      Begin
        If LstClinTypesSel.ItemIndex <> -1 Then
          LstClinTypes.Items.Add(LstClinTypesSel.Items[LstClinTypesSel.ItemIndex])
      End;
    2:
      Begin
        If LstSpecsSel.ItemIndex <> -1 Then
          LstSpecs.Items.Add(LstSpecsSel.Items[LstSpecsSel.ItemIndex])
      End;
    3:
      Begin
        If LstProcsSel.ItemIndex <> -1 Then
          LstProcs.Items.Add(LstProcsSel.Items[LstProcsSel.ItemIndex]);
      End;
  End; {case}

  FClinlstTo.DeleteSelected;
  SetModifiedFlag(True);
  RefreshDetails;
End;

Procedure TfrmListFilter.btnSelectClick(Sender: Tobject);
Begin
  FilterOriginEdit;
End;

Procedure TfrmListFilter.btnClassClinClick(Sender: Tobject);
Begin
  ChangeFilterClassToClin;
End;

Procedure TfrmListFilter.btnClassAdminClick(Sender: Tobject);
Begin
  ChangeFilterClassToAdmin;
End;

Procedure TfrmListFilter.btnClassAnyClick(Sender: Tobject);
Begin
  ChangeFilterClassToANY;
End;

Procedure TfrmListFilter.btnStatusSelectClick(Sender: Tobject);
Begin
  FilterStatusEdit;
End;

Procedure TfrmListFilter.btnStatusAnyClick(Sender: Tobject);
Begin
  FilterStatusClear;
End;

Procedure TfrmListFilter.btnSavedbyClick(Sender: Tobject);
Begin
  FilterSavedByEdit;
End;

Procedure TfrmListFilter.btnSavedAnyClick(Sender: Tobject);
Begin
  FilterSavedByClear;
End;

Procedure TfrmListFilter.TabControl1Change(Sender: Tobject);
Begin

// example from IListWin
//  fltname := tabctrlFilters.Tabs[tabctrlFilters.tabindex];

  Case TabControl1.TabIndex Of
    0:
      Begin
//packages
        ShowPackages;
        RefreshDetails;
      End;
    1:
      Begin
  //
        ShowClinTypes;
        RefreshDetails;
 //
      End;
    2:
      Begin
        ShowSpecs;
        RefreshDetails;
      End;
    3:
      Begin

  //
        ShowProcs;
        RefreshDetails;
      End;
  End;
End;

Procedure TfrmListFilter.cmboxDateRangeKeyDown(Sender: Tobject;
  Var Key: Word; Shift: TShiftState);
Begin
  If (Key = VK_Return) And (Uppercase(Copy(cmboxDateRange.Text, 1, 7)) = '<SELECT') Then SelectDateRange;
End;

End.
