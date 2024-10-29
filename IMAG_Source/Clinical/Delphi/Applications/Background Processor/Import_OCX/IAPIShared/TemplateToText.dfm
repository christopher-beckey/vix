inherited templateTEXT: TtemplateTEXT
  Left = 338
  Top = 250
  Width = 500
  Height = 304
  Caption = 'Text Document'
  OnMouseUp = FormMouseUp
  PixelsPerInch = 96
  TextHeight = 13
  inherited pnltop: TPanel
    Width = 492
    inherited imagedesc: TPanel
      Width = 400
    end
  end
  object memTextFile: TMemo [1]
    Left = 24
    Top = 40
    Width = 369
    Height = 185
    ReadOnly = True
    ScrollBars = ssBoth
    TabOrder = 1
    WordWrap = False
  end
  inherited MainMenu1: TMainMenu
    inherited mOptions: TMenuItem
      inherited mCopy: TMenuItem
        Enabled = True
        OnClick = mCopyClick
      end
      inherited mPrint: TMenuItem
        Enabled = True
        OnClick = mPrintClick
      end
      object mFont: TMenuItem [3]
        Caption = '&Font'
        OnClick = mFontClick
      end
      object mWordWrap: TMenuItem [4]
        Caption = 'Word Wrap'
        OnClick = mWordWrapClick
      end
    end
  end
  object FontDialog1: TFontDialog
    Font.Charset = DEFAULT_CHARSET
    Font.Color = clWindowText
    Font.Height = -11
    Font.Name = 'MS Sans Serif'
    Font.Style = []
    Left = 416
    Top = 120
  end
end
