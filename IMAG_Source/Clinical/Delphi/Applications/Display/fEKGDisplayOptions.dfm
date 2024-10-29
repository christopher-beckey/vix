object EKGDisplayOptionsForm: TEKGDisplayOptionsForm
  Left = 451
  Top = 432
  BorderStyle = bsDialog
  Caption = 'EKG Display Options'
  ClientHeight = 85
  ClientWidth = 157
  Color = clBtnFace
  Font.Charset = DEFAULT_CHARSET
  Font.Color = clWindowText
  Font.Height = -10
  Font.Name = 'MS Sans Serif'
  Font.Style = []
  OldCreateOrder = False
  OnCreate = FormCreate
  PixelsPerInch = 96
  TextHeight = 13
  object rbtnSolidGrid: TRadioButton
    Left = 7
    Top = 7
    Width = 137
    Height = 13
    Hint = 'For most normal printers'
    Caption = 'Print grid with solid lines'
    ParentShowHint = False
    ShowHint = True
    TabOrder = 0
  end
  object rbtnDottedGrid: TRadioButton
    Left = 7
    Top = 20
    Width = 137
    Height = 20
    Hint = 'For printers that don'#39't print the small grid lines correctly'
    Caption = 'Print grid with dotted lines'
    ParentShowHint = False
    ShowHint = True
    TabOrder = 1
  end
  object btnOK: TButton
    Left = 7
    Top = 52
    Width = 65
    Height = 27
    Caption = 'OK'
    TabOrder = 2
    OnClick = btnOKClick
  end
  object btnCancel: TButton
    Left = 85
    Top = 52
    Width = 65
    Height = 27
    Caption = 'Cancel'
    TabOrder = 3
    OnClick = btnCancelClick
  end
end
