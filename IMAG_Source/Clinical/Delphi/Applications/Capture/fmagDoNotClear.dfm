object frmDoNotClear: TfrmDoNotClear
  Left = 286
  Top = 165
  Width = 225
  Height = 339
  BorderIcons = [biSystemMenu]
  Caption = #39'Hold'#39' Values'
  Color = clBtnFace
  Constraints.MaxWidth = 225
  Constraints.MinHeight = 225
  Constraints.MinWidth = 225
  Font.Charset = DEFAULT_CHARSET
  Font.Color = clWindowText
  Font.Height = -11
  Font.Name = 'MS Sans Serif'
  Font.Style = []
  OldCreateOrder = False
  OnCreate = FormCreate
  OnDestroy = FormDestroy
  OnShow = FormShow
  DesignSize = (
    217
    305)
  PixelsPerInch = 96
  TextHeight = 13
  object Label5: TLabel
    Left = 4
    Top = 4
    Width = 209
    Height = 45
    Anchors = [akLeft, akTop, akRight]
    AutoSize = False
    Caption = 
      'When an image is saved to VistA, the values of the checked field' +
      's will not be cleared.'
    WordWrap = True
  end
  object lstNoClear: TCheckListBox
    Left = 10
    Top = 54
    Width = 193
    Height = 206
    Anchors = [akLeft, akTop, akRight, akBottom]
    ItemHeight = 13
    TabOrder = 0
  end
  object btnOK: TBitBtn
    Left = 18
    Top = 273
    Width = 75
    Height = 25
    Anchors = [akLeft, akBottom]
    TabOrder = 1
    OnClick = btnOKClick
    Kind = bkOK
  end
  object btnCancel: TBitBtn
    Left = 118
    Top = 273
    Width = 75
    Height = 25
    Anchors = [akRight, akBottom]
    TabOrder = 2
    Kind = bkCancel
  end
end
