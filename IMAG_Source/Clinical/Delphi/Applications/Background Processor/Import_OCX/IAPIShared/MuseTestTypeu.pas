Unit MuseTestTypeu;
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
  Windows,
  Messages,
  SysUtils,
  Classes,
  Graphics,
  Controls,
  Forms,
  Dialogs,
  Stdctrls,
  ExtCtrls,
  Buttons,
  Mask,
  ComCtrls,
  Spin,
  Maggmsgu,
  EKGdlgU;

Type
  TMuseTestType = Class(TForm)
    GroupBox1: TGroupBox;
    RadioButton1: TRadioButton;
    RadioButton2: TRadioButton;
    RadioButton3: TRadioButton;
    RadioButton4: TRadioButton;
    RadioButton5: TRadioButton;
    RadioButton6: TRadioButton;
    RadioButton7: TRadioButton;
    RadioButton8: TRadioButton;
    RadioButton9: TRadioButton;
    RadioButton10: TRadioButton;
    RadioButton11: TRadioButton;
    RadioButton12: TRadioButton;
    RadioButton13: TRadioButton;
    RadioButton14: TRadioButton;
    RadioButton15: TRadioButton;
    RadioButton16: TRadioButton;
    Panel1: Tpanel;
    MeDate: TMaskEdit;
    MeTime: TMaskEdit;
    Label3: Tlabel;
    RbFrom: TRadioButton;
    Label2: Tlabel;
    Label4: Tlabel;
    RbRecent: TRadioButton;
    Label1: Tlabel;
    Label6: Tlabel;
    SpinEdit2: TSpinEdit;
    TrackBar1: TTrackBar;
    LbZoom: Tlabel;
    BitBtn1: TBitBtn;
    Forceanexit: TCheckBox;
    BitBtn2: TBitBtn;
    bbZoomin: TBitBtn;
    bbZoomOut: TBitBtn;
    cbShowDottedGridDlg: TCheckBox;
    RgGridPrintType: TRadioGroup;
    RbSolid: TRadioButton;
    RbDotted: TRadioButton;
    Procedure RbFromClick(Sender: Tobject);
    Procedure RbRecentClick(Sender: Tobject);
    Procedure TrackBar1Change(Sender: Tobject);
    Procedure BitBtn2Click(Sender: Tobject);
    Procedure bbZoominClick(Sender: Tobject);
    Procedure bbZoomOutClick(Sender: Tobject);
    Procedure cbShowDottedGridDlgClick(Sender: Tobject);
    Procedure FormShow(Sender: Tobject);
    Procedure RbSolidClick(Sender: Tobject);
    Procedure RbDottedClick(Sender: Tobject);
  Private
    { Private declarations }
  Public
    { Public declarations }
  End;

Var
  MuseTestType: TMuseTestType;

Implementation

Uses Musetstu;

{$R *.DFM}

Procedure TMuseTestType.RbFromClick(Sender: Tobject);
Begin
  If RbFrom.Checked Then
  Begin
    MeDate.Enabled := True;
    MeTime.Enabled := True;
  End
  Else
  Begin
    MeDate.Enabled := False;
    MeTime.Enabled := False;
  End;

End;

Procedure TMuseTestType.RbRecentClick(Sender: Tobject);
Begin
  If RbRecent.Checked Then
  Begin
    MeDate.Enabled := False;
    MeTime.Enabled := False;
  End
  Else
  Begin
    MeDate.Enabled := True;
    MeTime.Enabled := True;
  End;

End;

Procedure TMuseTestType.TrackBar1Change(Sender: Tobject);
Begin
  LbZoom.caption := Inttostr(TrackBar1.Position) + '0%';
End;

Procedure TMuseTestType.BitBtn2Click(Sender: Tobject);
Begin
//if messagedlg('FORCE The VistA Imaging MUSE EKG Display to close the next time a ''Close'' is '+
//' attempted',mtconfirmation,[mbok,mbcancel],0) = mrok
//then forceanexit.checked := true
//ELSE forceanexit.checked := FALSE;
End;

Procedure TMuseTestType.bbZoominClick(Sender: Tobject);
Begin
  EKGWin.bbZoominClick(Self);
End;

Procedure TMuseTestType.bbZoomOutClick(Sender: Tobject);
Begin
  EKGWin.bbZoomOutClick(Self);
End;

Procedure TMuseTestType.cbShowDottedGridDlgClick(Sender: Tobject);
Begin
  Begin
    If cbShowDottedGridDlg.Checked Then
      EKGdlgU.ShowDottedGridDlg := True
    Else
      EKGdlgU.ShowDottedGridDlg := False
  End;
End;

Procedure TMuseTestType.FormShow(Sender: Tobject);
Begin
  If ShowDottedGridDlg = True Then
    cbShowDottedGridDlg.Checked := True
  Else
    cbShowDottedGridDlg.Checked := False;
  If PrintDottedGrid = True Then
    RbDotted.Checked := True
  Else
    RbSolid.Checked := True;
End;

Procedure TMuseTestType.RbSolidClick(Sender: Tobject);
Begin
  PrintDottedGrid := False;
End;

Procedure TMuseTestType.RbDottedClick(Sender: Tobject);
Begin
  PrintDottedGrid := True;
End;

End.
