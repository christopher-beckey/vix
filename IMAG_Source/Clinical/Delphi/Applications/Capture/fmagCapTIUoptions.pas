Unit FmagCapTIUoptions;

Interface

Uses
  Buttons,
  ComCtrls,
  ExtCtrls,
  Forms,
  Stdctrls,
  ToolWin,
  Graphics,
  Controls,
  Classes
  ;

//Uses Vetted 20090929:ToolWin, Dialogs, Graphics, Classes, Messages, Windows, Controls, SysUtils

Type
  TfrmCapTIUOptions = Class(TForm)
    BitBtn1: TBitBtn;
    BitBtn2: TBitBtn;
    btnSelectDates: TBitBtn;
    GroupBox1: TGroupBox;
    GroupBox2: TGroupBox;
    Label1: Tlabel;
    Label2: Tlabel;
    LbStaticDateFrom: Tlabel;
    LbStaticDateTo: Tlabel;
    RgrpMthsback: TRadioGroup;
    cmbnumber: TEdit;
    GroupBox3: TGroupBox;
    cbUseStatusIcons: TCheckBox;
    Image1: TImage;
    Image2: TImage;
    Label3: Tlabel;
    Label4: Tlabel;
    GroupBox4: TGroupBox;
    cbUseNoteStatusIcons: TCheckBox;
    Image3: TImage;
    Image4: TImage;
    Image5: TImage;
    ToolBar1: TToolBar;
    ToolButton1: TToolButton;
    ToolButton2: TToolButton;
    ToolButton3: TToolButton;
    ToolButton4: TToolButton;
    Procedure btnSelectDatesClick(Sender: Tobject);
    Procedure RgrpMthsbackClick(Sender: Tobject);
    Procedure ToolButton1Click(Sender: Tobject);
    Procedure ToolButton2Click(Sender: Tobject);
    Procedure ToolButton3Click(Sender: Tobject);
    Procedure ToolButton4Click(Sender: Tobject);
  Private
    FStaticDateFrom,
      FStaticDateTo: String;
    { Private declarations }
  Public
    Function Execute(Var Vcount: Integer; Var Dtfrom: String; Var Dtto: String;
      Var Dtmthsback: Integer; Var VUseIcons: Boolean; Var VUseGlyphs: Boolean): Boolean;

  End;

Var
  FrmCapTIUOptions: TfrmCapTIUOptions;

Implementation

Uses
  FmagDateRange,
  SysUtils
  ;

{$R *.DFM}

{ TfrmCapTIUOptions }

Function TfrmCapTIUOptions.Execute(Var Vcount: Integer; Var Dtfrom,
  Dtto: String; Var Dtmthsback: Integer; Var VUseIcons: Boolean; Var VUseGlyphs: Boolean): Boolean;
Begin
  Application.CreateForm(TfrmCapTIUOptions, FrmCapTIUOptions);
  Try

    Result := False;
    With FrmCapTIUOptions Do
    Begin
      LbStaticDateTo.caption := ''; //p59t20
      LbStaticDateFrom.caption := ''; //p59t20
      Dtfrom := ''; //p59t20
      Dtto := ''; //p59t20
      cbUseStatusIcons.Checked := VUseIcons;
      cbUseNoteStatusIcons.Checked := VUseGlyphs;
      cmbnumber.Text := Inttostr(Vcount);

 {      Static Dates were not used}
      If Dtmthsback < 0 Then
      Begin
        Dtfrom := '';
        Dtto := '';
        Case Dtmthsback Of
          -1: RgrpMthsback.ItemIndex := 0;
          -2: RgrpMthsback.ItemIndex := 1;
          -6: RgrpMthsback.ItemIndex := 2;
          -12: RgrpMthsback.ItemIndex := 3;
          -24: RgrpMthsback.ItemIndex := 4;
          -99: RgrpMthsback.ItemIndex := 5;

        Else
          RgrpMthsback.ItemIndex := -1;
        End; {case}
      End
      Else
      Begin {dtmthsback = 0}
        If (Dtfrom = '') Or (Dtto = '') Then
        Begin
        {this is error, if we don't have MOnthsBack, we should have date range}
        {  so if no date range, default to 1 year.}
          Dtfrom := '';
          Dtto := '';
          Dtmthsback := -12;
          RgrpMthsback.ItemIndex := 3;
        End
        Else
        Begin
          LbStaticDateFrom.caption := Dtfrom;
          LbStaticDateTo.caption := Dtto;
        End;
      End;

      Showmodal;
      If ModalResult = MrOK Then
      Begin
        Result := True;
        VUseIcons := cbUseStatusIcons.Checked;
        VUseGlyphs := cbUseNoteStatusIcons.Checked;
        Dtfrom := LbStaticDateFrom.caption;
        Dtto := LbStaticDateTo.caption;
        Try
          Vcount := Strtoint(cmbnumber.Text);
        Except
          Vcount := 0;
        End;
        If RgrpMthsback.ItemIndex > -1 Then
        Begin
          Case RgrpMthsback.ItemIndex Of
            0: Dtmthsback := -1;
            1: Dtmthsback := -2;
            2: Dtmthsback := -6;
            3: Dtmthsback := -12;
            4: Dtmthsback := -24;
            5: Dtmthsback := -99;
          End;
        End
        Else
          Dtmthsback := 0;

      End;
    End;
  Finally
    FrmCapTIUOptions.Release;
  End;
End;

Procedure TfrmCapTIUOptions.btnSelectDatesClick(Sender: Tobject);
Var
  Vdtfrom, Vdtto: String;
Begin
  Vdtfrom := LbStaticDateFrom.caption;
  Vdtto := LbStaticDateTo.caption;
  If FrmDateRange.Execute(Vdtfrom, Vdtto) Then
  Begin
    RgrpMthsback.ItemIndex := -1;
    LbStaticDateTo.caption := Vdtto;
    LbStaticDateFrom.caption := Vdtfrom;
  End;
End;

Procedure TfrmCapTIUOptions.RgrpMthsbackClick(Sender: Tobject);
Var
  Vmthsback: Integer;
Begin
  Case RgrpMthsback.ItemIndex Of
    0: Vmthsback := -1;
    1: Vmthsback := -2;
    2: Vmthsback := -6;
    3: Vmthsback := -12;
    4: Vmthsback := -24;
    5: Vmthsback := -99;
  End;
  If Vmthsback = -99 Then
  Begin
    LbStaticDateTo.caption := '';
    LbStaticDateFrom.caption := '';
  End
  Else
  Begin
    LbStaticDateTo.caption := DateToStr(Now);
    LbStaticDateFrom.caption := DateToStr(IncMonth(Now, Vmthsback));
  End;

End;

Procedure TfrmCapTIUOptions.ToolButton1Click(Sender: Tobject);
Begin
  cmbnumber.Text := '50';
End;

Procedure TfrmCapTIUOptions.ToolButton2Click(Sender: Tobject);
Begin
  cmbnumber.Text := '100';
End;

Procedure TfrmCapTIUOptions.ToolButton3Click(Sender: Tobject);
Begin
  cmbnumber.Text := '200';
End;

Procedure TfrmCapTIUOptions.ToolButton4Click(Sender: Tobject);
Begin
  cmbnumber.Text := '500';
End;

End.
