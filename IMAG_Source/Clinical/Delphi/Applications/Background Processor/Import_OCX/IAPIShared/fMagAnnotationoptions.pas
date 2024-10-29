{
  Package: MAG - VistA Imaging
  WARNING: Per VHA Directive 2004-038, this routine should not be modified.
  Date Created: May, 2008
  Site Name:  Washington OI Field Office, Silver Spring, MD
  Developer:  Julian Werfel
  Description:
    Form for allowing the user the ability to change the properties of
    the measurement annotations.

        ;; +--------------------------------------------------------------------+
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
        ;; +--------------------------------------------------------------------+
}
Unit FMagAnnotationOptions;

Interface

Uses
  Dialogs,
  ExtCtrls,
  Forms,
  Stdctrls,
  UMagClasses,
  UMagClassesAnnot,
  Controls,
  Classes
  ;

//Uses Vetted 20090929:Controls, Graphics, Classes, Variants, Messages, Windows, SysUtils

Type

  TfrmAnnotationOptions = Class(TForm)
    Label1: Tlabel;
    Label2: Tlabel;
    cboUnits: TComboBox;
    btnOK: TButton;
    btnCancel: TButton;
    btnApply: TButton;
    ColorBox1: TColorBox;
    cboLineWidth: TComboBox;
    Label3: Tlabel;
    Procedure FormCreate(Sender: Tobject);
    Procedure btnCancelClick(Sender: Tobject);
    Procedure btnOKClick(Sender: Tobject);
    Procedure btnApplyClick(Sender: Tobject);
    Procedure EdtLineWidthChange(Sender: Tobject);
    Procedure cboUnitsChange(Sender: Tobject);
  Private
    { Private declarations }
    FAnnotationStyle: TMagAnnotationStyle;

    FMagAnnotationStyleChangeEvent: TMagAnnotationStyleChangeEvent;
    FColorIntValue: Integer;

    Function SetAnnotationStyle(): Boolean;
  Public
    Procedure ShowAnnotationOptionsDialog(AnnotationStyle: TMagAnnotationStyle);

    Property OnMagAnnotationStyleChangeEvent: TMagAnnotationStyleChangeEvent Read FMagAnnotationStyleChangeEvent Write FMagAnnotationStyleChangeEvent;
    { Public declarations }
  End;

Var
  FrmAnnotationOptions: TfrmAnnotationOptions;

Const
  TOKButtonOnly = [Mbok];

Implementation
Uses
  SysUtils
  ;

{$R *.dfm}

Procedure TfrmAnnotationOptions.FormCreate(Sender: Tobject);
Begin
  {
    TMagAnnotationMeasurementType = (MagAnnotationInches, MagAnnotationFeet,
    MagAnnotationYards, MagAnnotationMiles, MagAnnotationMicrometers,
    MagAnnotationMillimeters, MagAnnotationCentimeters, MagAnntoationDecimeters,
    MagAnnotationMeters, MagAnnotationKilometers, MagAnnotationDekatmeter);
  }

  cboUnits.Items.Add('Inches'); // 0
  cboUnits.Items.Add('Feet'); // 1
 //  cboUnits.Items.Add('Yards');  // 2
 //  cboUnits.Items.Add('Miles'); // 3
  cboUnits.Items.Add('Micrometers'); // 4
  cboUnits.Items.Add('Millimeters'); // 5
  cboUnits.Items.Add('Centimeters'); // 6
 //  cboUnits.Items.Add('Decimeters'); // 7
 //  cboUnits.Items.Add('Meters'); // 8
 //  cboUnits.Items.Add('Kilometers'); // 9
 //  cboUnits.Items.Add('Dekameter'); // 10

  cboLineWidth.Items.Add('1');
  cboLineWidth.Items.Add('2');
  cboLineWidth.Items.Add('4');
  cboLineWidth.Items.Add('8');
  cboLineWidth.Items.Add('12');
  cboLineWidth.Items.Add('20');
End;

Procedure TfrmAnnotationOptions.ShowAnnotationOptionsDialog(AnnotationStyle: TMagAnnotationStyle);
Begin
  btnCancel.Enabled := True;
  FAnnotationStyle := AnnotationStyle;
  FColorIntValue := FAnnotationStyle.AnnotationColor;
  ColorBox1.Selected := FAnnotationStyle.AnnotationColor;
//  edtLineWidth.Text :=  inttostr(FAnnotationStyle.LineWidth);

  Show;
  Case FAnnotationStyle.MeasurementUnits Of

    0:
      cboUnits.ItemIndex := 0;
    1:
      cboUnits.ItemIndex := 1;
//    2:
//      cboUnits.ItemIndex := 2;
//    3:
//      cboUnits.ItemIndex := 3;
    4:
      //cboUnits.ItemIndex := 4;
      cboUnits.ItemIndex := 2;
//    5:
//      cboUnits.ItemIndex := 5;
    6:
      //cboUnits.ItemIndex := 6;
      cboUnits.ItemIndex := 4;
      {
    7:
      cboUnits.ItemIndex := 7;
    8:
      cboUnits.ItemIndex := 8;
    9:
      cboUnits.ItemIndex := 9;
    10:
      cboUnits.ItemIndex := 10;
      }
  Else
    cboUnits.ItemIndex := 3;
  End;

  Case FAnnotationStyle.LineWidth Of
    1:
      cboLineWidth.ItemIndex := 0;
    2:
      cboLineWidth.ItemIndex := 1;
    4:
      cboLineWidth.ItemIndex := 2;
    8:
      cboLineWidth.ItemIndex := 3;
    12:
      cboLineWidth.ItemIndex := 4;
    20:
      cboLineWidth.ItemIndex := 5;
  Else
    cboLineWidth.ItemIndex := 1;
  End;
End;

Procedure TfrmAnnotationOptions.btnCancelClick(Sender: Tobject);
Begin
  Self.Close;
End;

Procedure TfrmAnnotationOptions.btnOKClick(Sender: Tobject);
Begin
  If SetAnnotationStyle() Then
  Begin
    If Assigned(OnMagAnnotationStyleChangeEvent) Then
      OnMagAnnotationStyleChangeEvent(Self, FAnnotationStyle);
    Self.Close();
  End;
End;

Function TfrmAnnotationOptions.SetAnnotationStyle(): Boolean;
Begin
  Result := False;
  Try
    FAnnotationStyle.LineWidth := Strtoint(cboLineWidth.Text);
    FAnnotationStyle.AnnotationColor := ColorBox1.Selected;

    If cboUnits.Text = 'Inches' Then
      FAnnotationStyle.MeasurementUnits := 0
    Else
      If cboUnits.Text = 'Feet' Then
        FAnnotationStyle.MeasurementUnits := 1
      Else
        If cboUnits.Text = 'Yards' Then
          FAnnotationStyle.MeasurementUnits := 2
        Else
          If cboUnits.Text = 'Miles' Then
            FAnnotationStyle.MeasurementUnits := 3
          Else
            If cboUnits.Text = 'Micrometers' Then
              FAnnotationStyle.MeasurementUnits := 4
            Else
              If cboUnits.Text = 'Millimeters' Then
                FAnnotationStyle.MeasurementUnits := 5
              Else
                If cboUnits.Text = 'Centimeters' Then
                  FAnnotationStyle.MeasurementUnits := 6
                Else
                  If cboUnits.Text = 'Decimeters' Then
                    FAnnotationStyle.MeasurementUnits := 7
                  Else
                    If cboUnits.Text = 'Meters' Then
                      FAnnotationStyle.MeasurementUnits := 8
                    Else
                      If cboUnits.Text = 'Kilometers' Then
                        FAnnotationStyle.MeasurementUnits := 9
                      Else
                        If cboUnits.Text = 'Dekameter' Then
                          FAnnotationStyle.MeasurementUnits := 10;

    Result := True;
  Except
    On e: Exception Do
    Begin
      Messagedlg('You must specify the line width as a number', Mterror, TOKButtonOnly, -1);
    End;
  End;
End;

Procedure TfrmAnnotationOptions.btnApplyClick(Sender: Tobject);
Begin
  If SetAnnotationStyle() Then
  Begin
    btnCancel.Enabled := False;
    If Assigned(OnMagAnnotationStyleChangeEvent) Then
      OnMagAnnotationStyleChangeEvent(Self, FAnnotationStyle);
  End;
End;

Procedure TfrmAnnotationOptions.EdtLineWidthChange(Sender: Tobject);
Begin
  btnCancel.Enabled := True;
End;

Procedure TfrmAnnotationOptions.cboUnitsChange(Sender: Tobject);
Begin
  btnCancel.Enabled := True;
End;

End.
