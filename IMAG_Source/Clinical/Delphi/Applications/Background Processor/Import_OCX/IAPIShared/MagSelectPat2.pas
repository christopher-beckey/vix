Unit MagSelectPat2;
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
  SysUtils,
  WinTypes,
  WinProcs,
  Messages,
  Classes,
  Graphics,
  Controls,
  Forms,
  Dialogs,
  Stdctrls,
  Buttons,
  ExtCtrls;

Type
  TMagPat = Class(TForm)
    Label1: Tlabel;
    PatientSelect: TEdit;
    BitBtn2: TBitBtn;
    LbAlign: Tlabel;
    bbOK: TBitBtn;
    BitBtn4: TBitBtn;
    OptionPanel: Tpanel;
    Label2: Tlabel;
    Label3: Tlabel;
    Bevel1: TBevel;
    Bevel2: TBevel;
    Label4: Tlabel;
    Label6: Tlabel;
    Label5: Tlabel;
    Bevel3: TBevel;
    CheckBox1: TCheckBox;
    CheckBox2: TCheckBox;
    CheckBox3: TCheckBox;
    CheckBox4: TCheckBox;
    CheckBox5: TCheckBox;
    CheckBox6: TCheckBox;
    CheckBox7: TCheckBox;
    CheckBox8: TCheckBox;
    CheckBox9: TCheckBox;
    Edit1: TEdit;
    ComboBox1: TComboBox;
    Edit2: TEdit;
    Edit3: TEdit;
    CheckBox10: TCheckBox;
    Label7: Tlabel;
    Magpatdfn: Tlabel;
    Procedure PatientSelectKeyDown(Sender: Tobject; Var Key: Word;
      Shift: TShiftState);
    Procedure BitBtn2Click(Sender: Tobject);
    Procedure FormCreate(Sender: Tobject);
    Procedure BitBtn4Click(Sender: Tobject);
    Procedure bbOKClick(Sender: Tobject);
  Private
    { Private declarations }
  Public
    Procedure PatSearch(Pattext);
    { Public declarations }
  End;

Var
  MagPat: TMagPat;

Implementation
Uses TELE19NU;
{$R *.DFM}

Procedure TMagPat.PatientSelectKeyDown(Sender: Tobject; Var Key: Word;
  Shift: TShiftState);
Begin
  If Key <> VK_Return Then Exit;
  bbOK.Click;
End;

Procedure TMagPat.BitBtn2Click(Sender: Tobject);
Begin
  If OptionPanel.Enabled = False Then
  Begin
    OptionPanel.Enabled := True;
    MagPat.ClientHeight := OptionPanel.Height + LbAlign.Top + LbAlign.Height + 5;
  End
  Else
  Begin
    OptionPanel.Enabled := False;
    MagPat.ClientHeight := LbAlign.Top + LbAlign.Height + 5;
  End

End;

Procedure TMagPat.FormCreate(Sender: Tobject);
Begin
  ClientHeight := LbAlign.Top + LbAlign.Height;
  ClientWidth := LbAlign.Left + LbAlign.Width;
End;

Procedure TMagPat.BitBtn4Click(Sender: Tobject);
Begin
  PatientSelect.Text := '';
  Close;
End;

Procedure TMagPat.bbOKClick(Sender: Tobject);
Begin
  If PatientSelect.Text = '' Then
  Begin
    Messagebeep(0);
    Exit;
  End;
  PatSearch(PatientSelect.Text);
  PatientSelect.Text := '';
  Close;
End;

Procedure TMagPat.PatSearch(Pattext);
Begin
  Msg('', 'Searching for Patient ''' + Pattext + '''...');
  Maggplkf.Patlookup(Pat.Text);
  If Maggplkf.LPat.Items.Count <> 1 Then
  Begin
    Maggplkf.Dhcpfile.caption := '2';
    Maggplkf.Lcsmsg.caption := 'Type Patient Name (partial is ok), or full SSN, or Last Initial + last 4 digits SSN';
    Maggplkf.Label1.caption := 'Patient:';
    Maggplkf.caption := 'Patient Lookup';
    Maggplkf.Showmodal;
    If ModalResult = MrCancel Then Exit;
  End;
  TTeleradi.ClearCurrentPatient;
  TTeleradi.MagDFN := Maggplkf.PatDFN.caption;
  Getpatinf(MagDFN);
  If PatName1 = '' Then Exit; { call had error  gek 6/25/96}
  PtSSN.Text := SSN;
  PtName.Text := PatName1;
  Pat.Text := PatName1;
  Msg('', Pdemog);
  AddToMenu;
  RPCBroker1.PARAM[0].Value := MagDFN;
  RPCBroker1.PARAM[0].PTYPE := LITERAL;
  RPCBroker1.REMOTEPROCEDURE := 'MAGGPATINTINF';
  Patintinf := RPCBroker1.STRCALL;
End;

End.
