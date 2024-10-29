object frmEsigDialog: TfrmEsigDialog
  Left = -622
  Top = 199
  BorderIcons = [biSystemMenu]
  BorderStyle = bsSingle
  Caption = 'Electronic Signature entry'
  ClientHeight = 172
  ClientWidth = 390
  Color = clBtnFace
  Font.Charset = DEFAULT_CHARSET
  Font.Color = clWindowText
  Font.Height = -11
  Font.Name = 'MS Sans Serif'
  Font.Style = []
  OldCreateOrder = False
  Position = poMainFormCenter
  PixelsPerInch = 96
  TextHeight = 13
  object lbUserName: TLabel
    Left = 52
    Top = 18
    Width = 58
    Height = 13
    Caption = '<username>'
  end
  object lbEsigLabel: TLabel
    Left = 52
    Top = 52
    Width = 126
    Height = 13
    Caption = 'Enter Electronic Signature:'
  end
  object btnOK: TBitBtn
    Left = 82
    Top = 104
    Width = 75
    Height = 25
    TabOrder = 1
    Kind = bkOK
  end
  object btnCancel: TBitBtn
    Left = 232
    Top = 104
    Width = 75
    Height = 25
    TabOrder = 2
    Kind = bkCancel
  end
  object edtEsig: TEdit
    Left = 218
    Top = 48
    Width = 119
    Height = 21
    PasswordChar = '*'
    TabOrder = 0
  end
end
