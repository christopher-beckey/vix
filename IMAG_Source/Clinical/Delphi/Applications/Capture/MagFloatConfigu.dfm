object MagFloatConfig: TMagFloatConfig
  Left = 785
  Top = 348
  BorderStyle = bsToolWindow
  Caption = 'MagFloatConfig'
  ClientHeight = 276
  ClientWidth = 234
  Color = 12963793
  Font.Charset = DEFAULT_CHARSET
  Font.Color = clWindowText
  Font.Height = -11
  Font.Name = 'MS Sans Serif'
  Font.Style = []
  FormStyle = fsStayOnTop
  OldCreateOrder = True
  OnDeactivate = FormDeactivate
  PixelsPerInch = 96
  TextHeight = 13
  object Panel1: TPanel
    Left = 0
    Top = 241
    Width = 234
    Height = 35
    Align = alBottom
    BevelOuter = bvNone
    TabOrder = 0
    object pOK: TPanel
      Left = 36
      Top = 4
      Width = 157
      Height = 25
      BevelOuter = bvNone
      TabOrder = 0
      object bbok: TBitBtn
        Left = 1
        Top = 0
        Width = 55
        Height = 25
        TabOrder = 0
        OnClick = bbokClick
        Kind = bkOK
      end
      object cbQuickClose: TCheckBox
        Left = 60
        Top = 4
        Width = 93
        Height = 17
        Caption = 'close on select'
        Color = clBtnFace
        Font.Charset = ANSI_CHARSET
        Font.Color = clWindowText
        Font.Height = -11
        Font.Name = 'Arial'
        Font.Style = []
        ParentColor = False
        ParentFont = False
        TabOrder = 1
        OnClick = cbQuickCloseClick
      end
    end
  end
end
