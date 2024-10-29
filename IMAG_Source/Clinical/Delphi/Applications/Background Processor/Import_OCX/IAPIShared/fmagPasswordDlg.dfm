object frmPasswordDlg: TfrmPasswordDlg
  Left = 448
  Top = 310
  BorderStyle = bsToolWindow
  Caption = 'Password Dialog'
  ClientHeight = 118
  ClientWidth = 317
  Color = clBtnFace
  Font.Charset = DEFAULT_CHARSET
  Font.Color = clWindowText
  Font.Height = -11
  Font.Name = 'MS Sans Serif'
  Font.Style = []
  OldCreateOrder = False
  PixelsPerInch = 96
  TextHeight = 13
  object edtpassword: TLabeledEdit
    Left = 112
    Top = 28
    Width = 121
    Height = 21
    EditLabel.Width = 86
    EditLabel.Height = 13
    EditLabel.Caption = 'Enter Password   :'
    LabelPosition = lpLeft
    PasswordChar = '*'
    TabOrder = 0
  end
  object btnOK: TBitBtn
    Left = 112
    Top = 68
    Width = 75
    Height = 25
    TabOrder = 1
    Kind = bkOK
  end
end
