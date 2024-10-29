object frmSaveImageAs: TfrmSaveImageAs
  Left = 437
  Top = 234
  Width = 400
  Height = 410
  BorderIcons = [biSystemMenu]
  BorderStyle = bsSizeToolWin
  Caption = 'Save Image As...'
  Color = clBtnFace
  Constraints.MaxHeight = 410
  Constraints.MinHeight = 410
  Constraints.MinWidth = 400
  Font.Charset = DEFAULT_CHARSET
  Font.Color = clWindowText
  Font.Height = -11
  Font.Name = 'MS Sans Serif'
  Font.Style = []
  OldCreateOrder = False
  DesignSize = (
    392
    376)
  PixelsPerInch = 96
  TextHeight = 13
  object lbReason: TLabel
    Left = 176
    Top = 24
    Width = 44
    Height = 13
    Caption = '<reason>'
  end
  object lbfilename: TLabel
    Left = 24
    Top = 56
    Width = 87
    Height = 13
    Caption = 'Copy to filename : '
  end
  object lbAssociated: TLabel
    Left = 24
    Top = 128
    Width = 127
    Height = 13
    Caption = 'Also copy associated files: '
  end
  object btnReason: TBitBtn
    Left = 24
    Top = 16
    Width = 113
    Height = 25
    Caption = 'Reason for Copy'
    TabOrder = 0
  end
  object btnSelect: TBitBtn
    Left = 336
    Top = 80
    Width = 25
    Height = 25
    Anchors = [akTop, akRight]
    Caption = '...'
    TabOrder = 1
  end
  object btnCopy: TBitBtn
    Left = 64
    Top = 312
    Width = 75
    Height = 25
    Enabled = False
    TabOrder = 2
    Kind = bkOK
  end
  object btnCancel: TBitBtn
    Left = 248
    Top = 312
    Width = 75
    Height = 25
    TabOrder = 3
    Kind = bkCancel
  end
  object edtFilename: TEdit
    Left = 24
    Top = 84
    Width = 297
    Height = 21
    Anchors = [akLeft, akTop, akRight]
    TabOrder = 4
  end
  object cbAbstract: TCheckBox
    Left = 96
    Top = 160
    Width = 97
    Height = 17
    Caption = 'Abstract (.ABS)'
    TabOrder = 5
  end
  object cbFull: TCheckBox
    Left = 96
    Top = 192
    Width = 97
    Height = 17
    Caption = 'Full file'
    TabOrder = 6
  end
  object cbTXT: TCheckBox
    Left = 96
    Top = 224
    Width = 97
    Height = 17
    Caption = 'Text file (.TXT)'
    TabOrder = 7
  end
  object cbBig: TCheckBox
    Left = 96
    Top = 256
    Width = 97
    Height = 17
    Caption = 'Big file (.BIG)'
    TabOrder = 8
  end
  object StatusBar1: TStatusBar
    Left = 0
    Top = 357
    Width = 392
    Height = 19
    Panels = <>
  end
end
