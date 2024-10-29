object formTemplate1: TformTemplate1
  Left = 621
  Top = 322
  Caption = 'form template'
  ClientHeight = 241
  ClientWidth = 467
  Color = clBtnFace
  Constraints.MinHeight = 200
  Constraints.MinWidth = 300
  Font.Charset = DEFAULT_CHARSET
  Font.Color = clWindowText
  Font.Height = -11
  Font.Name = 'MS Sans Serif'
  Font.Style = []
  OldCreateOrder = True
  OnCreate = FormCreate
  PixelsPerInch = 96
  TextHeight = 13
  object pnltop: TPanel
    Left = 0
    Top = 0
    Width = 467
    Height = 21
    Align = alTop
    BevelOuter = bvNone
    TabOrder = 0
    object Bevel1: TBevel
      Left = 86
      Top = 0
      Width = 3
      Height = 21
      Align = alLeft
      Style = bsRaised
    end
    object Bevel2: TBevel
      Left = 89
      Top = 0
      Width = 3
      Height = 21
      Align = alLeft
      Shape = bsSpacer
    end
    object imagedesc: TPanel
      Left = 92
      Top = 0
      Width = 375
      Height = 21
      Align = alClient
      Alignment = taLeftJustify
      BevelOuter = bvNone
      Caption = 'imagedesc'
      Font.Charset = ANSI_CHARSET
      Font.Color = clWindowText
      Font.Height = -11
      Font.Name = 'Arial'
      Font.Style = [fsBold]
      ParentFont = False
      TabOrder = 0
    end
    object ToolBar1: TToolBar
      Left = 0
      Top = 0
      Width = 86
      Height = 21
      Align = alLeft
      AutoSize = True
      ButtonHeight = 21
      ButtonWidth = 43
      Caption = 'ToolBar1'
      EdgeInner = esNone
      EdgeOuter = esNone
      ShowCaptions = True
      TabOrder = 1
      object ToolButton1: TToolButton
        Left = 0
        Top = 0
        Caption = 'Options'
        Grouped = True
        MenuItem = mOptions
      end
      object ToolButton2: TToolButton
        Left = 43
        Top = 0
        Caption = 'Help'
        Grouped = True
        MenuItem = mHelp
      end
    end
  end
  object MainMenu1: TMainMenu
    Left = 392
    Top = 40
    object mOptions: TMenuItem
      Caption = 'Options'
      object mCopy: TMenuItem
        Caption = 'Copy'
        Enabled = False
      end
      object mPrint: TMenuItem
        Caption = 'Print'
        Enabled = False
      end
      object mReport: TMenuItem
        Caption = 'Report'
        OnClick = mReportClick
      end
      object N1: TMenuItem
        Caption = '-'
      end
      object mExit: TMenuItem
        Caption = 'E&xit'
        OnClick = mExitClick
      end
    end
    object mHelp: TMenuItem
      Caption = 'Help'
      object mHelp1: TMenuItem
        Caption = 'Help'
        Enabled = False
      end
    end
  end
end
