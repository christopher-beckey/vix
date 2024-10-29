Unit FmagCapSettings;
   {
   Package: MAG - VistA Imaging
   WARNING: Per VHA Directive 10-93-142 this unit should not be modified.
   Date Created:
   Site Name: Silver Spring, OIFO
   Developers: Garrett Kirin
   Description: Imaging Capture Settings Dialog - Auto, Scroll, Zoom settings.
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
  Classes,
  cMagDBBroker,
  cMagListView,
  ComCtrls,
  Controls,
  Dialogs,
  ExtCtrls,
  Forms,
  Menus,
  Stdctrls,
  UMagClasses,
  Umagutils8,
  UMagDefinitions ,
  imaginterfaces
  ;

//Uses Vetted 20090929:umagCapUtil, ShellCtrls, cmagLabelNoClear, CheckLst, Graphics, umagkeymgr, fmagDirectoryDialog, SysUtils, Windows

Type
  TfrmCapSettings = Class(TForm)
    Panel1: Tpanel;
    Panel2: Tpanel;
    PgctrlSettings: TPageControl;
    TbshtAutoSettings: TTabSheet;
    TbshtZoomScrollSettings: TTabSheet;
    OKBtn: TButton;
    CancelBtn: TButton;
    HelpBtn: TButton;
    chkAutoSelect: TCheckBox;
    chkAutoTab: TCheckBox;
    chkAutoOpen: TCheckBox;
    LbAutoSelect: Tlabel;
    LbAutoOpen: Tlabel;
    chkAutoExpand: TCheckBox;
    Label6: Tlabel;
    LblHoriz: Tlabel;
    LblVert: Tlabel;
    chkSaveOnCapture: TRadioButton;
    chkUseStatic: TRadioButton;
    btnGetCurrentSettings: TButton;
    chkFitToWin: TRadioButton;
    LblHorizD: Tlabel;
    LblVertD: Tlabel;
    chkPositional: TRadioButton;
    LblZoom: Tlabel;
    LblZoomD: Tlabel;
    LblZoompos: Tlabel;
    LblZoomposD: Tlabel;
    btnGetCurrentZoom: TButton;
    PnlPositional: Tpanel;
    LblPositional: Tlabel;
    LbAutoTab: Tlabel;
    Bevel1: TBevel;
    LblArea: Tlabel;
    Panel3: Tpanel;
    chkPosTL: TRadioButton;
    chkPosTR: TRadioButton;
    chkPosC: TRadioButton;
    chkPosBR: TRadioButton;
    chkPosBL: TRadioButton;
    Lblmove: Tlabel;
    btnApplySettings: TButton;
    PnlAutoSettings2: Tpanel;
    chkAutoDeskew: TCheckBox;
    chkAutoDeSpeckle: TCheckBox;
    chkAutoPreviewNote: TCheckBox;
    LbAutoDeskew: Tlabel;
    LbAutoDeSpeckle: Tlabel;
    LbAutoPreviewNote: Tlabel;
    TbshImport: TTabSheet;
    Pnloptlstboximport: TListBox;
    Pnloptimport: Tpanel;
    btnOptDelete: TBitBtn;
    BitBtn2: TBitBtn;
    btnOptSetAsDefault: TBitBtn;
    Lbdefaultdesc: Tlabel;
    Lbdefault: Tlabel;
    cbAddDirONSelect: TCheckBox;
    Label1: Tlabel;
    OpendialogOption: TOpenDialog;
    Label2: Tlabel;
    Mnupnloptlst: TPopupMenu;
    Remove1: TMenuItem;
    SetasDefault1: TMenuItem;
    Applydblclick1: TMenuItem;
    btnOptApply: TBitBtn;
    TbshNotes: TTabSheet;
    EdtVLMy: TEdit;
    MlvVLMy: TMagListView;
    btnVLMy: TBitBtn;
    Timerlkp: TTimer;
    LbVLWrks: Tlabel;
    LbVLMy: Tlabel;
    Label7: Tlabel;
    LbVLConfig: Tlabel;
    Label10: Tlabel;
    Label11: Tlabel;
    Label12: Tlabel;
    EdtVLWrks: TEdit;
    btnVLWrks: TBitBtn;
    MlvVLWrks: TMagListView;
    RbUseDefaults: TRadioButton;
    RbNotUseDefaults: TRadioButton;
    Label3: Tlabel;
    Bevel2: TBevel;
    Bevel3: TBevel;
    LbVLwrksNoKey1: Tlabel;
    btnTL: TBitBtn;
    btnTR: TBitBtn;
    btnCenter: TBitBtn;
    btnBL: TBitBtn;
    btnBR: TBitBtn;
    Procedure btnGetCurrentSettingsClick(Sender: Tobject);
    Procedure chkFitToWinClick(Sender: Tobject);
    Procedure btnGetCurrentZoomClick(Sender: Tobject);
    Procedure chkSaveOnCaptureClick(Sender: Tobject);
    Procedure chkUseStaticClick(Sender: Tobject);
    Procedure chkPositionalClick(Sender: Tobject);
    Procedure chkPosTLClick(Sender: Tobject);
    Procedure chkPosTRClick(Sender: Tobject);
    Procedure chkPosBRClick(Sender: Tobject);
    Procedure chkPosBLClick(Sender: Tobject);
    Procedure chkPosCClick(Sender: Tobject);
    Procedure PnlPositionalMouseDown(Sender: Tobject; Button: TMouseButton;
      Shift: TShiftState; x, y: Integer);
    Procedure PnlPositionalMouseMove(Sender: Tobject; Shift: TShiftState;
      x, y: Integer);
    Procedure TbshtZoomScrollSettingsMouseMove(Sender: Tobject;
      Shift: TShiftState; x, y: Integer);
    Procedure LblmoveMouseDown(Sender: Tobject; Button: TMouseButton;
      Shift: TShiftState; x, y: Integer);
    Procedure btnApplySettingsClick(Sender: Tobject);
    Procedure FormClose(Sender: Tobject; Var action: TCloseAction);
    Procedure btnOptDeleteClick(Sender: Tobject);
    Procedure btnOptSetAsDefaultClick(Sender: Tobject);
    Procedure BitBtn2Click(Sender: Tobject);
    Procedure PnloptlstboximportClick(Sender: Tobject);
    Procedure PgctrlSettingsChange(Sender: Tobject);
    Procedure FormShow(Sender: Tobject);
    Procedure PnloptlstboximportDblClick(Sender: Tobject);
    Procedure Remove1Click(Sender: Tobject);
    Procedure SetasDefault1Click(Sender: Tobject);
    Procedure Applydblclick1Click(Sender: Tobject);
    Procedure btnOptApplyClick(Sender: Tobject);
    Procedure EdtVLMyKeyUp(Sender: Tobject; Var Key: Word;
      Shift: TShiftState);
    Procedure MlvVLMyClick(Sender: Tobject);
    Procedure MlvVLMyExit(Sender: Tobject);
    Procedure MlvVLMySelectItem(Sender: Tobject; Item: TListItem;
      Selected: Boolean);
    Procedure TimerlkpTimer(Sender: Tobject);
    Procedure btnVLMyClick(Sender: Tobject);
    Procedure RbUseDefaultsClick(Sender: Tobject);
    Procedure MlvVLWrksExit(Sender: Tobject);
    Procedure MlvVLWrksSelectItem(Sender: Tobject; Item: TListItem;
      Selected: Boolean);
    Procedure EdtVLWrksKeyUp(Sender: Tobject; Var Key: Word;
      Shift: TShiftState);
    Procedure btnVLWrksClick(Sender: Tobject);
    Procedure MlvVLWrksClick(Sender: Tobject);
    Procedure RbNotUseDefaultsClick(Sender: Tobject);
    Procedure btnTLClick(Sender: Tobject);
    Procedure btnTRClick(Sender: Tobject);
    Procedure btnCenterClick(Sender: Tobject);
    Procedure btnBLClick(Sender: Tobject);
    Procedure btnBRClick(Sender: Tobject);
    procedure FormCreate(Sender: TObject);
  Private
    HasSYSKey: Boolean;

    FDBBroker: TMagDBBroker;

    FDelOneMoreLoc: Boolean;

    Procedure DisableAll;
    Procedure MoveSelectedArea(Button: TMouseButton; x, y: Integer);
    Procedure ApplySettingsToMain;
    Procedure RemoveSelected;
    Procedure SetAsDefault;
    Procedure ApplySelectedDirectory;
    Procedure ResolveButtonsEnabled;

    Procedure ComputeHeight(LV: TMagListView; Edt: TEdit);

    Procedure HideShowSYSFields;
    Procedure EnableDisableDefaultFields;
  Public
    FMyVisitLocName, FMyVisitLocDA: String;
    FWrksVisitLocName, FWrksVisitLocDA: String;

    FtimLV: TMagListView;
    FtimEDT: TEdit;
    FtimBTN: TBitBtn;

    FCurHoriz: Integer;
    FCurVert: Integer;
    FCurZoom: Integer;
    FCurPositional: Integer;
    Procedure SetBroker(VDBBroker: TMagDBBroker);

    Function GetLocationsFromVista(Starttext: String; Dir: Integer = 1): TStrings;
    Function GenKeyUp(Edt: TEdit; Var Txt: String; Var Fulltext: String; LV: TMagListView; Delchar: Boolean = False): Integer;
    Procedure Gen2KeyUp(Sender: Tobject; Var Key: Word; Shift: TShiftState);
    Procedure GetSelectedLoc(Var TmpLocName, TmpLocDA: String);
    Procedure SetWrksVisitLocation(VMsetWrks: TMagSettingsWrks);
    Procedure SetUserTIUDefaults(VUprefCapTIU: TuprefCapTIU);
  End;

Var
  FrmCapSettings: TfrmCapSettings;
Const
  MagstUser: Integer = 0;
Const
  MagstWrks: Integer = 1;
Implementation

{$R *.DFM}

{ TPagesDlg }
Uses
  FmagCapMain,
  FmagDirectoryDialog,
  SysUtils,
  Umagkeymgr,
  Windows
  ;

Procedure TfrmCapSettings.btnGetCurrentSettingsClick(Sender: Tobject);
Begin
(* p129
  FCurHoriz := Frmcapmain.Gear 1.GetScrollPos(SB_HORZ);
  FCurVert := Frmcapmain.Gear 1.GetScrollPos(SB_VERT);
  FCurZoom := Frmcapmain.Gear 1.ZoomLevel; *)

    FCurHoriz := Frmcapmain.mg1.GetScrollInfo.H_Pos; //Gear 1.GetScrollPos(SB_HORZ);
    FCurVert := Frmcapmain.mg1.GetScrollInfo.V_Pos ;//Gear 1.GetScrollPos(SB_VERT);
    FCurZoom := Frmcapmain.mg1.GetZoomValue; //Gear 1.ZoomLevel;

  LblHorizD.caption := Inttostr(FCurHoriz);
  LblVertD.caption := Inttostr(FCurVert);
  LblZoomD.caption := Inttostr(FCurZoom);

End;

Procedure TfrmCapSettings.chkFitToWinClick(Sender: Tobject);
Begin
  DisableAll;
  (* IN  TfrmCapSettings.Form Close
      FLockScrollBarsFitToWin := chkFitToWin.Checked;


  *)
End;

Procedure TfrmCapSettings.DisableAll;
Begin
  btnGetCurrentSettings.Enabled := False;
  LblHorizD.Enabled := False;
  LblVertD.Enabled := False;
  LblZoomD.Enabled := False;
  LblHoriz.Enabled := False;
  LblVert.Enabled := False;
  LblZoom.Enabled := False;

  btnGetCurrentZoom.Enabled := False;
  LblZoomposD.Enabled := False;
  LblZoompos.Enabled := False;
  LblPositional.Enabled := False;
  PnlPositional.Enabled := False;

  chkPosTL.Checked := False;
  chkPosTL.Enabled := False;

  chkPosTR.Checked := False;
  chkPosTR.Enabled := False;

  chkPosC.Checked := False;
  chkPosC.Enabled := False;

  chkPosBR.Checked := False;
  chkPosBR.Enabled := False;

  chkPosBL.Checked := False;
  chkPosBL.Enabled := False;

  btnTL.Enabled := False;
  btnTR.Enabled := False;
  btnCenter.Enabled := False;
  btnBR.Enabled := False;
  btnBL.Enabled := False;

End;

Procedure TfrmCapSettings.btnGetCurrentZoomClick(Sender: Tobject);
Begin
  LblZoomposD.caption := Inttostr(FCurZoom);
End;

Procedure TfrmCapSettings.chkSaveOnCaptureClick(Sender: Tobject);
Begin
  DisableAll;
    (* IN Form Close
  
    FLockScrollBarsAlways := chkSaveOnCapture.Checked;


  *)
End;

Procedure TfrmCapSettings.chkUseStaticClick(Sender: Tobject);
Begin
  DisableAll;
  (* IN Form Close

    FLockScrollBarsStatic := chkUseStatic.Checked;


  *)
  btnGetCurrentSettings.Enabled := True;
  LblHorizD.Enabled := True;
  LblVertD.Enabled := True;
  LblZoomD.Enabled := True;
  LblHoriz.Enabled := True;
  LblVert.Enabled := True;
  LblZoom.Enabled := True;
End;

Procedure TfrmCapSettings.chkPositionalClick(Sender: Tobject);
Begin
  DisableAll;
    (* IN Form Close
    FLockScrollBarsPositional := chkPositional.Checked;

  *)
  btnGetCurrentZoom.Enabled := True;
  LblPositional.Enabled := True;
  PnlPositional.Enabled := True;
  LblZoomposD.Enabled := True;
  LblZoompos.Enabled := True;

  chkPosTL.Enabled := True;
  chkPosTR.Enabled := True;
  chkPosC.Enabled := True;
  chkPosBR.Enabled := True;
  chkPosBL.Enabled := True;

  btnTL.Enabled := True;
  btnTR.Enabled := True;
  btnCenter.Enabled := True;
  btnBR.Enabled := True;
  btnBL.Enabled := True;

  If ((chkPosTL.Checked = False) And (chkPosTR.Checked = False) And
    (chkPosBR.Checked = False) And (chkPosBL.Checked = False) And
    (chkPosC.Checked = False)) Then chkPosC.Checked := True;

End;

Procedure TfrmCapSettings.chkPosTLClick(Sender: Tobject);
Begin
  LblArea.Top := 1;
  LblArea.Left := 1;
  LblArea.caption := 'Top Left';
End;

Procedure TfrmCapSettings.chkPosTRClick(Sender: Tobject);
Begin
  LblArea.Top := 1;
  LblArea.Left := PnlPositional.Width - LblArea.Width;
  LblArea.caption := 'Top Right';
End;

Procedure TfrmCapSettings.chkPosBRClick(Sender: Tobject);
Begin
  LblArea.Top := PnlPositional.Height - LblArea.Height;
  LblArea.Left := PnlPositional.Width - LblArea.Width;
  LblArea.caption := 'Bottom Right';
End;

Procedure TfrmCapSettings.chkPosBLClick(Sender: Tobject);
Begin
  LblArea.Top := PnlPositional.Height - LblArea.Height;
  LblArea.Left := 1;
  LblArea.caption := 'Bottom Left';
End;

Procedure TfrmCapSettings.chkPosCClick(Sender: Tobject);
Begin
  If Not chkPosC.Checked Then
  MagAppMsg('', 'in chkPosCClick, NOT CHECKED');
  LblArea.Top := Trunc((PnlPositional.Height - LblArea.Height) Div 2);
  LblArea.Left := Trunc((PnlPositional.Width - LblArea.Width) Div 2);
  LblArea.caption := 'Center';

End;

Procedure TfrmCapSettings.PnlPositionalMouseDown(Sender: Tobject;
  Button: TMouseButton; Shift: TShiftState; x, y: Integer);
Begin
  MoveSelectedArea(Button, x, y);
End;

Procedure TfrmCapSettings.MoveSelectedArea(Button: TMouseButton; x, y: Integer);
Var
  Zy, Zx: Integer;
Begin
  If (Button = Mbleft) Then
  Begin
    Zy := (PnlPositional.Height Div 3); // y
    Zx := (PnlPositional.Width Div 3); // x

    If (x < Zx) And (y < Zy) Then
      chkPosTL.Checked := True
    Else
      If (x > (2 * Zx)) And (y < Zy) Then
        chkPosTR.Checked := True
      Else
        If (x < Zx) And (y > (2 * Zy)) Then
          chkPosBL.Checked := True
        Else
          If (x > (2 * Zx)) And (y > (2 * Zy)) Then
            chkPosBR.Checked := True
          Else
            chkPosC.Checked := True;
    ApplySettingsToMain;
  End;
End;

Procedure TfrmCapSettings.PnlPositionalMouseMove(Sender: Tobject;
  Shift: TShiftState; x, y: Integer);
Var
  Zy, Zx: Integer;
Begin
  If Not Lblmove.Visible Then Lblmove.Visible := True;
  Zy := (PnlPositional.Height Div 3); // y
  Zx := (PnlPositional.Width Div 3); // x
  //chkPosC.checked := true;
  If (x < Zx) And (y < Zy) Then
  Begin
    Lblmove.Top := 2;
    Lblmove.Left := 2;
    Lblmove.alignment := TaLeftJustify;
    Lblmove.Layout := TlTop;
    Lblmove.caption := ' Top' + #13 + ' Left';
    Exit;
  End; // chkPosTL.checked := true;
  If (x > (2 * Zx)) And (y < Zy) Then
  Begin
    Lblmove.Top := 2;
    Lblmove.Left := PnlPositional.Width - Lblmove.Width;
    Lblmove.alignment := TaRightJustify;
    Lblmove.Layout := TlTop;
    Lblmove.caption := 'Top ' + #13 + 'Right ';
    Exit;
  End; //chkPosTR.checked := true;
  If (x < Zx) And (y > (2 * Zy)) Then
  Begin
    Lblmove.Top := PnlPositional.Height - Lblmove.Height;
    Lblmove.Left := 2;
    Lblmove.alignment := TaLeftJustify;
    Lblmove.Layout := TlBottom;
    Lblmove.caption := ' Bottom' + #13 + ' Left';
    Exit;
  End; //ChkPosBL.checked := true;
  If (x > (2 * Zx)) And (y > (2 * Zy)) Then
  Begin
    Lblmove.Top := PnlPositional.Height - Lblmove.Height;
    Lblmove.Left := PnlPositional.Width - Lblmove.Width;
    Lblmove.alignment := TaRightJustify;
    Lblmove.Layout := TlBottom;
    Lblmove.caption := 'Bottom ' + #13 + 'Right ';
    Exit;
  End;
  Lblmove.Top := Trunc((PnlPositional.Height - Lblmove.Height) Div 2);
  Lblmove.Left := Trunc((PnlPositional.Width - Lblmove.Width) Div 2);
  Lblmove.alignment := TaCenter;
  Lblmove.Layout := TlCenter;
  Lblmove.caption := 'Center';
  // ChkPosBR.checked := true;
End;

Procedure TfrmCapSettings.TbshtZoomScrollSettingsMouseMove(Sender: Tobject;
  Shift: TShiftState; x, y: Integer);
Begin
  If Lblmove.Visible Then Lblmove.Visible := False;
End;

Procedure TfrmCapSettings.LblmoveMouseDown(Sender: Tobject;
  Button: TMouseButton; Shift: TShiftState; x, y: Integer);
Begin
  If (Button = Mbleft) Then MoveSelectedArea(Button, x, y);
End;

Procedure TfrmCapSettings.btnApplySettingsClick(Sender: Tobject);
Begin
  ApplySettingsToMain;
End;

Procedure TfrmCapSettings.ApplySettingsToMain;
Begin
  With Frmcapmain Do
  Begin
    OptionWindowGetSettings;
    ZoomScrollApply;


    if mg1.PanWindow then
       begin
         mg1.PanWindow := false;
         mg1.panwindow := true;
       end;

    { DONE -o129 : Refresh PanWindow. }
    (*    If Gear 1.PanWindow Then
    Begin
      Gear 1.ZoomLevel := Gear 1.ZoomLevel + 1;
      Gear 1.ZoomLevel := Gear 1.ZoomLevel - 1;
    End;
    *)

  End;
End;

Procedure TfrmCapSettings.FormClose(Sender: Tobject;
  Var action: TCloseAction);
Begin
  ApplySettingsToMain;
  Timerlkp.Enabled := False;
End;

procedure TfrmCapSettings.FormCreate(Sender: TObject);
begin
panel1.Align := alclient;
end;

Procedure TfrmCapSettings.btnOptDeleteClick(Sender: Tobject);
Begin
  RemoveSelected;
End;

Procedure TfrmCapSettings.RemoveSelected;
Begin
  If Pnloptlstboximport.ItemIndex <> -1 Then
    Pnloptlstboximport.Items.Delete(Pnloptlstboximport.ItemIndex);
  ResolveButtonsEnabled;
End;

Procedure TfrmCapSettings.ResolveButtonsEnabled;
Var
  Value: Boolean;
Begin
  Value := Pnloptlstboximport.ItemIndex <> -1;
  btnOptDelete.Enabled := Value;
  btnOptSetAsDefault.Enabled := Value;
  btnOptApply.Enabled := Value;
End;

Procedure TfrmCapSettings.btnOptSetAsDefaultClick(Sender: Tobject);
Begin
  SetAsDefault;
End;

Procedure TfrmCapSettings.SetAsDefault;
Begin
  If Pnloptlstboximport.ItemIndex <> -1 Then
    Lbdefault.caption := Pnloptlstboximport.Items[Pnloptlstboximport.ItemIndex];
  Update;
End;

Procedure TfrmCapSettings.BitBtn2Click(Sender: Tobject);
//var dirtree : TdirectoryTreeView;
Begin
  FrmDirectoryDialog.Execute(Pnloptlstboximport.Items);
  Exit;
  If OpendialogOption.Execute Then
  Begin
    If Pnloptlstboximport.Items.Indexof(ExtractFilePath(OpendialogOption.Filename)) = -1 Then Pnloptlstboximport.Items.Add(ExtractFilePath(OpendialogOption.Filename));
  End;

  ChDir(AppPath); // needed this before to set current directory to Appath.
     //  Now  The OpenDialog Options: ofNoChangeDir = True. should do the same thing.

End;

Procedure TfrmCapSettings.PnloptlstboximportClick(Sender: Tobject);
Begin
  ResolveButtonsEnabled;
End;

Procedure TfrmCapSettings.PgctrlSettingsChange(Sender: Tobject);
Begin
  With PgctrlSettings.ActivePage Do
    Case Tag Of
      0: FrmCapSettings.caption := 'User Session settings';
      1: FrmCapSettings.caption := 'Workstation settings';
      3:
        Begin
          FrmCapSettings.caption := 'User Session settings';
          If ((Not RbNotUseDefaults.Checked) And (Not RbUseDefaults.Checked)) Then RbUseDefaults.Checked := True;
        End;
    End;

End;

Procedure TfrmCapSettings.FormShow(Sender: Tobject);
Begin
  PgctrlSettingsChange(Self);
  MlvVLMy.Visible := False;
  HasSYSKey := Userhaskey('MAG SYSTEM');
  HideShowSYSFields;
End;

Procedure TfrmCapSettings.HideShowSYSFields;
Begin
  LbVLwrksNoKey1.Visible := Not HasSYSKey;
  btnVLWrks.Enabled := HasSYSKey And RbUseDefaults.Checked;
  EdtVLWrks.Enabled := HasSYSKey And RbUseDefaults.Checked;
End;

Procedure TfrmCapSettings.PnloptlstboximportDblClick(Sender: Tobject);
Begin
  ApplySelectedDirectory;
End;

Procedure TfrmCapSettings.ApplySelectedDirectory;
Var
  s: String;
Begin

  If Pnloptlstboximport.ItemIndex = -1 Then Exit;
  s := Pnloptlstboximport.Items[Pnloptlstboximport.ItemIndex];

  If Frmcapmain.LbImport.caption <> s Then Frmcapmain.OpenAllFilesX(s);
End;

Procedure TfrmCapSettings.Remove1Click(Sender: Tobject);
Begin
  RemoveSelected;
End;

Procedure TfrmCapSettings.SetasDefault1Click(Sender: Tobject);
Begin
  SetAsDefault;
End;

Procedure TfrmCapSettings.Applydblclick1Click(Sender: Tobject);
Begin
  ApplySelectedDirectory;
End;

Procedure TfrmCapSettings.btnOptApplyClick(Sender: Tobject);
Begin
  ApplySelectedDirectory;
End;

Procedure TfrmCapSettings.EdtVLMyKeyUp(Sender: Tobject; Var Key: Word; Shift: TShiftState);
Begin
  FtimLV := MlvVLMy;
  FtimEDT := EdtVLMy;
  FtimBTN := btnVLMy;
  If EdtVLMy.Text = '' Then
  Begin
    Self.FMyVisitLocDA := '';
    Self.FMyVisitLocName := '';
  End
  Else
    Gen2KeyUp(Sender, Key, Shift);
End;

Procedure TfrmCapSettings.Gen2KeyUp(Sender: Tobject; Var Key: Word; Shift: TShiftState);
Var
//txt, s ,fulltext: string;
//  hits, indx: integer;
//  searchinglist: boolean;
//  starttxt : string;
  Dir: Integer;
 // rlist : Tstrings;
Begin
  If ((Key = 38) Or (Key = 40)) Then
  Begin
    If (Key = 38) And (FtimLV.ItemIndex = 0) Then Exit;
    If (Key = 40) And (FtimLV.ItemIndex = FtimLV.Items.Count - 1) Then Exit;
    Case Key Of
      38:
        Begin {up}
          If FtimLV.ItemIndex = -1 Then
            FtimLV.ItemIndex := FtimLV.Items.Count - 1
          Else
            FtimLV.ItemIndex := FtimLV.ItemIndex - 1;
          FtimLV.ItemFocused := FtimLV.Items[FtimLV.ItemIndex];
          Dir := -1;
        End;
      40:
        Begin {down}
          FtimLV.ItemIndex := FtimLV.ItemIndex + 1;
          FtimLV.ItemFocused := FtimLV.Items[FtimLV.ItemIndex + 1];
          Dir := 1;
        End;
    End;
    FtimLV.Visible := True;
    If FtimLV.Selcount > 0 Then FtimLV.ScrollToItem(FtimLV.Selected);
    FtimEDT.SelectAll;
    Exit;
  End;
  If (Key = VK_Return) And (FtimLV.Selcount > 0) Then
  Begin
    If FtimEDT.Text = Copy(FtimLV.Selected.caption, 1, Length(FtimEDT.Text)) Then
    Begin
      If FtimLV.Visible Then FtimLV.Visible := False;
      FtimEDT.Text := FtimLV.Selected.caption;
      FtimEDT.Hint := FtimEDT.Text;
      //59default// edtTitle.SetFocus;
      Exit;
    End;
  End;
  If (SsAlt In Shift) And (Key = 40) Then
  Begin
    If FtimLV.Items.Count = 0 Then
    Begin
      Messagedlg('Enter a few characters of the Location.' +
        #13 + 'all matching entries will be listed.', Mtconfirmation, [Mbok], 0);
      Exit;
    End;
    If Not FtimLV.Visible Then FtimLV.Visible := True;
    Exit;
  End;

  If (Key = 8) And FDelOneMoreLoc Then
  Begin
    FDelOneMoreLoc := False;
    If Length(FtimEDT.Text) = 1 Then FtimEDT.Text := '';
    If FtimEDT.Text <> '' Then FtimEDT.Text := Copy(FtimEDT.Text, 1, Length(FtimEDT.Text) - 1);
    FtimEDT.Update;
    FtimEDT.Hint := FtimEDT.Text;
  End;
  If (((Key > 31) And (Key < 127)) Or (Key = 8) Or (Key = VK_Return)) Then Timerlkp.Enabled := True;
End;

Procedure TfrmCapSettings.MlvVLMyClick(Sender: Tobject);
Begin
  If MlvVLMy.Selcount > 0 Then
  Begin
    EdtVLMy.SetFocus;
    MlvVLMy.Visible := False;
  End;
End;

Procedure TfrmCapSettings.MlvVLMyExit(Sender: Tobject);
Begin
  MlvVLMy.Visible := False;
End;

Procedure TfrmCapSettings.MlvVLMySelectItem(Sender: Tobject;
  Item: TListItem; Selected: Boolean);
Begin
  FtimLV := MlvVLMy;
  FtimEDT := EdtVLMy;
  FtimBTN := btnVLMy;
  GetSelectedLoc(FMyVisitLocName, FMyVisitLocDA);
End;

Procedure TfrmCapSettings.GetSelectedLoc(Var TmpLocName, TmpLocDA: String);
Var
  Li: TListItem;
  //rstat : boolean;
 // rmsg : string;
//  t : tstringlist;
//  vConsDA : string;
Begin

  If FtimLV.Selected = Nil Then
  Begin
    Exit;
  End;
  Li := FtimLV.Selected;
  FtimEDT.Text := Li.caption;
  TmpLocName := Li.caption;
  TmpLocDA := TMagListViewData(Li.Data).Data;

  TmpLocName := Trim(TmpLocName);
  TmpLocName := StringReplace(TmpLocName, '<', '', [RfReplaceAll]);
  TmpLocName := StringReplace(TmpLocName, '>', '', [RfReplaceAll]);

  FtimEDT.Text := TmpLocName;
  FtimEDT.Hint := FtimEDT.Text;

End;

Procedure TfrmCapSettings.TimerlkpTimer(Sender: Tobject);
Var //fl,sl : string;
// fi,si : integer;
  ALPH: String;
//r0,
  Str: String;
  Rlist: TStrings;
//li : tlistitem;
  VShift: TShiftState;
  VKey: Word;
  Hits: Integer;
  Fulltext: String;
  Indexsel, Thumbpos: Integer;
Begin
  Indexsel := -1;
  Thumbpos := 99999;
  VShift := [Ssctrl];
  VKey := 35;
  Begin
    Timerlkp.Enabled := False;
    Try
      ALPH := 'ABCDEFGHIJKLMNOPQRSTUVWXYZ';
      If (FtimEDT.Seltext <> '') Then
      Begin
        Str := Copy(FtimEDT.Text, 1, Pos(FtimEDT.Seltext, FtimEDT.Text) - 1);
      End
      Else
        Str := FtimEDT.Text;
      FtimLV.ClearItems;
      If (Str = '') Then Exit;
      FtimLV.SortType := StText;
      Rlist := GetLocationsFromVista(Str, 1);
      If Rlist = Nil Then Exit;
      FtimLV.LoadListFromStrings(Rlist);
      FtimLV.FitColumnsToText;
      ComputeHeight(FtimLV, FtimEDT);
      FtimLV.Visible := True;
         {  edtAuthorKeyUp(self,vKey,vshift); //  (Sender: TObject; var Key: Word; Shift: TShiftState);}
         {  full text is of the Matching List entry, '' if 0 hits.}
      Hits := GenKeyUp(FtimEDT, Str, Fulltext, FtimLV, False);
      If Hits = 0 Then Exit;
      If Fulltext <> '' Then
      Begin
        FtimEDT.SELSTART := Length(Str);
        FtimEDT.SelLength := 999;
      End;
    Finally
      Rlist.Free;
    End;
  End;

End;

Procedure TfrmCapSettings.SetBroker(VDBBroker: TMagDBBroker);
Begin
  FDBBroker := VDBBroker;
End;

Function TfrmCapSettings.GenKeyUp(Edt: TEdit; Var Txt: String; Var Fulltext: String; LV: TMagListView; Delchar: Boolean = False): Integer;
Var
//  i: integer;
  Li: TListItem;
Begin
  Li := LV.FindCaption(0, Txt, True, True, True);
  If Li = Nil Then
    Result := 0
  Else
  Begin
    Li.Selected := True;
    Fulltext := Li.caption;
    LV.ScrollToItem(Li);
    Frmcapmain.Testmsg('3- ' + Edt.Text);
    Result := 1;
  End;
End;

Function TfrmCapSettings.GetLocationsFromVista(Starttext: String; Dir: Integer = 1): TStrings;
Var
  Rstat: Boolean;
  Rmsg: String;
//rlist : Tstrings;
  Rlist1: Tstringlist;
//dirFlag : string;
  i: Integer;
Begin
  Result := Tstringlist.Create;
  Rlist1 := Tstringlist.Create;
  FDBBroker.RPMag3LookupAny(Rstat, Rmsg, Rlist1, '44^50^' + Starttext + '^.01^', '1^');
  If Not Rstat Then
  Begin
    Result := Nil;
    MagAppMsg('', Rmsg);
  End
  Else
  Begin
    For i := 1 To Rlist1.Count - 1 Do
      Result.Add(Rlist1[i]);
  End;
End;

Procedure TfrmCapSettings.ComputeHeight(LV: TMagListView; Edt: TEdit);
Var
  L, t, h, w: Integer;
Begin
  ;
  w := LV.Width;
  t := LV.Top;
  L := Edt.Left + 20;
  h := (LV.Items.Count * 18) + 20;
  If h + LV.Top > FrmCapSettings.ClientHeight Then h := FrmCapSettings.ClientHeight - LV.Top - 10;
  If h < 100 Then h := 100;
  If LV.Tag > 0 Then
    If h > LV.Tag Then h := LV.Tag;
  LV.SetBounds(L, t, w, h);
End;

Procedure TfrmCapSettings.btnVLMyClick(Sender: Tobject);
Begin
  If MlvVLMy.Items.Count = 0 Then
  Begin
    Messagedlg('Enter a few characters of the Location.' +
      #13 + 'all matching entries will be listed.', Mtconfirmation, [Mbok], 0);
    EdtVLMy.SetFocus;
    EdtVLMy.SelectAll;
    Exit;
  End;
  MlvVLMy.Visible := Not MlvVLMy.Visible;
End;

Procedure TfrmCapSettings.RbUseDefaultsClick(Sender: Tobject);
Begin
  EnableDisableDefaultFields;
End;

Procedure TfrmCapSettings.EnableDisableDefaultFields;
Begin
  LbVLConfig.Enabled := RbUseDefaults.Checked;

  LbVLMy.Enabled := RbUseDefaults.Checked;
  If MlvVLMy.Visible Then MlvVLMy.Hide;
  EdtVLMy.Enabled := RbUseDefaults.Checked;
  btnVLMy.Enabled := RbUseDefaults.Checked;

  LbVLWrks.Enabled := RbUseDefaults.Checked;
  If MlvVLWrks.Visible Then MlvVLWrks.Hide;
  EdtVLWrks.Enabled := (RbUseDefaults.Checked And HasSYSKey);
  btnVLWrks.Enabled := (RbUseDefaults.Checked And HasSYSKey);

  LbVLwrksNoKey1.Visible := Not HasSYSKey;
End;

Procedure TfrmCapSettings.MlvVLWrksExit(Sender: Tobject);
Begin
  MlvVLWrks.Visible := False;
End;

Procedure TfrmCapSettings.MlvVLWrksSelectItem(Sender: Tobject;
  Item: TListItem; Selected: Boolean);
Begin
  FtimLV := MlvVLWrks;
  FtimEDT := EdtVLWrks;
  FtimBTN := btnVLWrks;
  GetSelectedLoc(FWrksVisitLocName, FWrksVisitLocDA);
End;

Procedure TfrmCapSettings.EdtVLWrksKeyUp(Sender: Tobject; Var Key: Word;
  Shift: TShiftState);
Begin
  FtimLV := MlvVLWrks;
  FtimEDT := EdtVLWrks;
  FtimBTN := btnVLWrks;
  If EdtVLWrks.Text = '' Then
  Begin
    FWrksVisitLocDA := '';
    FWrksVisitLocName := '';
  End
  Else
    Gen2KeyUp(Sender, Key, Shift);
End;

Procedure TfrmCapSettings.btnVLWrksClick(Sender: Tobject);
Begin
  If MlvVLWrks.Items.Count = 0 Then
  Begin
    Messagedlg('Enter a few characters of the Location.' +
      #13 + 'all matching entries will be listed.', Mtconfirmation, [Mbok], 0);
    EdtVLWrks.SetFocus;
    EdtVLWrks.SelectAll;
    Exit;
  End;
  MlvVLWrks.Visible := Not MlvVLWrks.Visible;
End;

Procedure TfrmCapSettings.MlvVLWrksClick(Sender: Tobject);
Begin
  If MlvVLWrks.Selcount > 0 Then
  Begin
    EdtVLWrks.SetFocus;
    MlvVLWrks.Visible := False;
  End;
End;

Procedure TfrmCapSettings.RbNotUseDefaultsClick(Sender: Tobject);
Begin
  EnableDisableDefaultFields;
End;

Procedure TfrmCapSettings.SetUserTIUDefaults(VUprefCapTIU: TuprefCapTIU);
Begin
  Self.FMyVisitLocDA := VUprefCapTIU.DefaultLocDA;
  Self.FMyVisitLocName := VUprefCapTIU.DefaultLocName;
  EdtVLMy.Text := FMyVisitLocName;
  RbUseDefaults.Checked := VUprefCapTIU.UseDefaultLoc;
  RbNotUseDefaults.Checked := Not RbUseDefaults.Checked;
End;

Procedure TfrmCapSettings.SetWrksVisitLocation(VMsetWrks: TMagSettingsWrks);
Begin
  FWrksVisitLocDA := VMsetWrks.VLocDA;
  FWrksVisitLocName := VMsetWrks.VLocName;
  EdtVLWrks.Text := FWrksVisitLocName;
End;

Procedure TfrmCapSettings.btnTLClick(Sender: Tobject);
Begin
  chkPosTL.Checked := True;
End;

Procedure TfrmCapSettings.btnTRClick(Sender: Tobject);
Begin
  chkPosTR.Checked := True;
End;

Procedure TfrmCapSettings.btnCenterClick(Sender: Tobject);
Begin
  chkPosC.Checked := True;
End;

Procedure TfrmCapSettings.btnBLClick(Sender: Tobject);
Begin
  chkPosBL.Checked := True;
End;

Procedure TfrmCapSettings.btnBRClick(Sender: Tobject);
Begin
  chkPosBR.Checked := True;
End;

End.
