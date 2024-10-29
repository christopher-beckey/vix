inherited templateHTML: TtemplateHTML
  Left = 349
  Top = 243
  Caption = 'HTML Document'
  PixelsPerInch = 96
  TextHeight = 13
  inherited pnltop: TPanel
    inherited Bevel1: TBevel
      Left = 172
    end
    inherited Bevel2: TBevel
      Left = 175
    end
    inherited imagedesc: TPanel
      Left = 178
      Width = 289
    end
    inherited ToolBar1: TToolBar
      Width = 172
      object ToolButton3: TToolButton
        Left = 86
        Top = 0
        Hint = 'Back'
        Caption = '<'
        ImageIndex = 0
        OnClick = ToolButton3Click
      end
      object ToolButton4: TToolButton
        Left = 129
        Top = 0
        Hint = 'Forward'
        Caption = '>'
        ImageIndex = 1
        OnClick = ToolButton4Click
      end
    end
  end
  object WebBrowser1: TWebBrowser [1]
    Left = 96
    Top = 48
    Width = 300
    Height = 150
    TabOrder = 1
    ControlData = {
      4C000000021F0000810F00000100000005000000000000000000000000000000
      000000004C000000000000000000000001000000E0D057007335CF11AE690800
      2B2E126208000000000000004C0000000114020000000000C000000000000046
      8000000000000000000000000000000000000000000000000000000000000000
      00000000000000000100000000000000000000000000000000000000}
  end
  inherited MainMenu1: TMainMenu
    inherited mOptions: TMenuItem
      object mStop: TMenuItem [4]
        Caption = 'Stop'
        OnClick = mStopClick
      end
      object N2: TMenuItem [5]
        Caption = '-'
      end
    end
  end
end
