object frmComponents: TfrmComponents
  Left = 490
  Top = 176
  Width = 485
  Height = 232
  Caption = 'frmComponents'
  Color = clBtnFace
  Font.Charset = DEFAULT_CHARSET
  Font.Color = clWindowText
  Font.Height = -13
  Font.Name = 'MS Sans Serif'
  Font.Style = []
  OldCreateOrder = False
  OnActivate = FormActivate
  PixelsPerInch = 120
  TextHeight = 16
  object Label1: TLabel
    Left = 8
    Top = 8
    Width = 133
    Height = 16
    Caption = 'Attached components:'
  end
  object Label2: TLabel
    Left = 152
    Top = 8
    Width = 96
    Height = 16
    Caption = 'Component info:'
  end
  object lstAttachedComponents: TListBox
    Left = 8
    Top = 32
    Width = 137
    Height = 121
    ItemHeight = 16
    TabOrder = 0
    OnClick = lstAttachedComponentsClick
  end
  object btnAttach: TButton
    Left = 288
    Top = 160
    Width = 89
    Height = 33
    Caption = 'Attach...'
    TabOrder = 1
    OnClick = btnAttachClick
  end
  object btnClose: TButton
    Left = 392
    Top = 160
    Width = 81
    Height = 33
    Caption = 'Close'
    TabOrder = 2
    OnClick = btnCloseClick
  end
  object txtComponentInfo: TMemo
    Left = 152
    Top = 32
    Width = 321
    Height = 121
    Enabled = False
    Lines.Strings = (
      'txtComponentInfo')
    TabOrder = 3
  end
end
