object maggsur: Tmaggsur
  Left = -893
  Top = 287
  HelpContext = 10195
  BorderIcons = [biSystemMenu, biMaximize]
  Caption = 'Surgery Case List'
  ClientHeight = 213
  ClientWidth = 437
  Color = clBtnFace
  Constraints.MinHeight = 240
  Constraints.MinWidth = 410
  Font.Charset = DEFAULT_CHARSET
  Font.Color = clBlack
  Font.Height = -11
  Font.Name = 'Arial'
  Font.Style = [fsBold]
  KeyPreview = True
  Menu = MainMenu1
  OldCreateOrder = True
  Position = poScreenCenter
  OnActivate = setcollengthClick
  OnCreate = FormCreate
  OnDestroy = FormDestroy
  PixelsPerInch = 96
  TextHeight = 14
  object Panel1: TPanel
    Left = 0
    Top = 0
    Width = 437
    Height = 28
    Align = alTop
    TabOrder = 0
    object Label1: TLabel
      Left = 423
      Top = 1
      Width = 13
      Height = 26
      Align = alRight
      Alignment = taRightJustify
      AutoSize = False
      OnDblClick = Label1DblClick
    end
    object entries: TLabel
      Left = 6
      Top = 9
      Width = 49
      Height = 14
      AutoSize = False
    end
  end
  object stg1: TStringGrid
    Left = 0
    Top = 28
    Width = 437
    Height = 107
    Align = alClient
    ColCount = 6
    Ctl3D = True
    DefaultColWidth = 22
    DefaultRowHeight = 18
    RowCount = 7
    Options = [goFixedVertLine, goFixedHorzLine, goVertLine, goColSizing, goRowSelect, goThumbTracking]
    ParentCtl3D = False
    TabOrder = 1
    OnDblClick = stg1DblClick
    ColWidths = (
      22
      54
      173
      72
      22
      74)
  end
  object Panel3: TPanel
    Left = 385
    Top = 68
    Width = 354
    Height = 80
    Caption = 'Panel3'
    TabOrder = 2
    Visible = False
    object pmsg: TLabel
      Left = 3
      Top = 29
      Width = 166
      Height = 16
      AutoSize = False
      Caption = 'pmsg'
    end
    object selection: TLabel
      Left = 108
      Top = 16
      Width = 51
      Height = 14
      Caption = 'selection'
      Visible = False
    end
    object setcollength: TButton
      Left = 256
      Top = 27
      Width = 85
      Height = 19
      Caption = 'set col length'
      TabOrder = 0
      Visible = False
      OnClick = setcollengthClick
    end
    object showcollength: TButton
      Left = 252
      Top = 6
      Width = 85
      Height = 19
      Caption = 'show col length'
      TabOrder = 1
      Visible = False
      OnClick = showcollengthClick
    end
    object SurDFN: TEdit
      Left = 164
      Top = 12
      Width = 51
      Height = 22
      TabOrder = 2
      Text = 'SurDFN'
      Visible = False
    end
    object LBB1: TListBox
      Left = 24
      Top = 42
      Width = 197
      Height = 19
      ItemHeight = 14
      TabOrder = 3
      Visible = False
    end
  end
  object Panel2: TPanel
    Left = 0
    Top = 188
    Width = 437
    Height = 25
    Align = alBottom
    Alignment = taLeftJustify
    BevelInner = bvLowered
    Font.Charset = DEFAULT_CHARSET
    Font.Color = clBlack
    Font.Height = -13
    Font.Name = 'Arial'
    Font.Style = [fsBold]
    ParentFont = False
    TabOrder = 3
    object info: TLabel
      Left = 7
      Top = 3
      Width = 4
      Height = 16
    end
  end
  object Panel4: TPanel
    Left = 0
    Top = 135
    Width = 437
    Height = 53
    Align = alBottom
    BevelInner = bvRaised
    BevelOuter = bvNone
    Font.Charset = DEFAULT_CHARSET
    Font.Color = clBlack
    Font.Height = -13
    Font.Name = 'Arial'
    Font.Style = [fsBold]
    ParentFont = False
    TabOrder = 4
    object bbOK: TBitBtn
      Left = 22
      Top = 10
      Width = 89
      Height = 30
      Caption = '&OK'
      Default = True
      TabOrder = 0
      OnClick = bbOKClick
      Glyph.Data = {
        BE060000424DBE06000000000000360400002800000024000000120000000100
        0800000000008802000000000000000000000001000000010000000000000000
        BF0000BF000000BFBF00BF000000BF00BF00BFBF0000C0C0C000C0DCC000F0C8
        A400000000000000000000000000000000000000000000000000000000000000
        0000000000000000000000000000000000000000000000000000000000000000
        0000000000000000000000000000000000000000000000000000000000000000
        0000000000000000000000000000000000000000000000000000000000000000
        0000000000000000000000000000000000000000000000000000000000000000
        0000000000000000000000000000000000000000000000000000000000000000
        0000000000000000000000000000000000000000000000000000000000000000
        0000000000000000000000000000000000000000000000000000000000000000
        0000000000000000000000000000000000000000000000000000000000000000
        0000000000000000000000000000000000000000000000000000000000000000
        0000000000000000000000000000000000000000000000000000000000000000
        0000000000000000000000000000000000000000000000000000000000000000
        0000000000000000000000000000000000000000000000000000000000000000
        0000000000000000000000000000000000000000000000000000000000000000
        0000000000000000000000000000000000000000000000000000000000000000
        0000000000000000000000000000000000000000000000000000000000000000
        0000000000000000000000000000000000000000000000000000000000000000
        0000000000000000000000000000000000000000000000000000000000000000
        0000000000000000000000000000000000000000000000000000000000000000
        0000000000000000000000000000000000000000000000000000000000000000
        0000000000000000000000000000000000000000000000000000000000000000
        0000000000000000000000000000000000000000000000000000000000000000
        0000000000000000000000000000000000000000000000000000000000000000
        0000000000000000000000000000000000000000000000000000000000000000
        0000000000000000000000000000000000000000000000000000000000000000
        0000000000000000000000000000000000000000000000000000000000000000
        0000000000000000000000000000000000000000000000000000000000000000
        0000000000000000000000000000000000000000000000000000000000000000
        0000000000000000000000000000000000000000000000000000000000000000
        000000000000000000000000000000000000F0FBFF00A4A0A000808080000000
        FF0000FF000000FFFF00FF000000FF00FF00FFFF0000FFFFFF00030303030303
        0303030303030303030303030303030303030303030303030303030303030303
        03030303030303030303030303030303030303030303FF030303030303030303
        03030303030303040403030303030303030303030303030303F8F8FF03030303
        03030303030303030303040202040303030303030303030303030303F80303F8
        FF030303030303030303030303040202020204030303030303030303030303F8
        03030303F8FF0303030303030303030304020202020202040303030303030303
        0303F8030303030303F8FF030303030303030304020202FA0202020204030303
        0303030303F8FF0303F8FF030303F8FF03030303030303020202FA03FA020202
        040303030303030303F8FF03F803F8FF0303F8FF03030303030303FA02FA0303
        03FA0202020403030303030303F8FFF8030303F8FF0303F8FF03030303030303
        FA0303030303FA0202020403030303030303F80303030303F8FF0303F8FF0303
        0303030303030303030303FA0202020403030303030303030303030303F8FF03
        03F8FF03030303030303030303030303FA020202040303030303030303030303
        0303F8FF0303F8FF03030303030303030303030303FA02020204030303030303
        03030303030303F8FF0303F8FF03030303030303030303030303FA0202020403
        030303030303030303030303F8FF0303F8FF03030303030303030303030303FA
        0202040303030303030303030303030303F8FF03F8FF03030303030303030303
        03030303FA0202030303030303030303030303030303F8FFF803030303030303
        030303030303030303FA0303030303030303030303030303030303F803030303
        0303030303030303030303030303030303030303030303030303030303030303
        0303}
      NumGlyphs = 2
      Style = bsWin31
    end
    object bbCancel: TBitBtn
      Left = 162
      Top = 10
      Width = 89
      Height = 30
      TabOrder = 1
      Kind = bkCancel
      Style = bsWin31
    end
    object BitBtn1: TBitBtn
      Left = 301
      Top = 10
      Width = 89
      Height = 30
      HelpContext = 10195
      TabOrder = 2
      OnClick = BitBtn1Click
      Kind = bkHelp
      Style = bsWin31
    end
  end
  object MainMenu1: TMainMenu
    Left = 234
    Top = 133
    object File1: TMenuItem
      Caption = '&File'
      object Save1: TMenuItem
        Caption = '&Save'
        OnClick = Save1Click
      end
      object N1: TMenuItem
        Caption = '-'
      end
      object Exit1: TMenuItem
        Caption = 'E&xit'
        OnClick = Exit1Click
      end
    end
    object OPTIONS1: TMenuItem
      Caption = '&Options'
      object Font1: TMenuItem
        Caption = 'F&ont'
        OnClick = Font1Click
      end
    end
    object Help1: TMenuItem
      Caption = '&Help'
      object SurgeryCaseList1: TMenuItem
        Caption = '&Surgery Case List...'
        OnClick = SurgeryCaseList1Click
      end
    end
  end
  object FontDialog1: TFontDialog
    Font.Charset = DEFAULT_CHARSET
    Font.Color = clWindowText
    Font.Height = -13
    Font.Name = 'System'
    Font.Style = []
    Left = 269
    Top = 111
  end
end
