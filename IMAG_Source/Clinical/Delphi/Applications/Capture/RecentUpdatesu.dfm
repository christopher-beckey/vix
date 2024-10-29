object RecentUpdates: TRecentUpdates
  Left = 368
  Top = 299
  Width = 569
  Height = 217
  Caption = 'Version 2.5 Recent Updates'
  Color = clBtnFace
  Font.Charset = DEFAULT_CHARSET
  Font.Color = clWindowText
  Font.Height = -11
  Font.Name = 'MS Sans Serif'
  Font.Style = []
  OldCreateOrder = True
  OnCreate = FormCreate
  OnDestroy = FormDestroy
  PixelsPerInch = 96
  TextHeight = 13
  object Memo1: TMemo
    Left = 68
    Top = 58
    Width = 185
    Height = 89
    Font.Charset = DEFAULT_CHARSET
    Font.Color = clWindowText
    Font.Height = -13
    Font.Name = 'Arial'
    Font.Style = []
    ParentFont = False
    PopupMenu = PopupMenu1
    ScrollBars = ssBoth
    TabOrder = 0
  end
  object Panel1: TPanel
    Left = 0
    Top = 0
    Width = 561
    Height = 23
    Align = alTop
    BevelOuter = bvNone
    TabOrder = 1
  end
  object PopupMenu1: TPopupMenu
    Left = 126
    Top = 96
    object WordWrap1: TMenuItem
      Caption = 'WordWrap'
      Checked = True
      OnClick = WordWrap1Click
    end
    object N1: TMenuItem
      Caption = '-'
    end
    object Refresh1: TMenuItem
      Caption = 'Refresh this file'
      OnClick = Refresh1Click
    end
  end
end
