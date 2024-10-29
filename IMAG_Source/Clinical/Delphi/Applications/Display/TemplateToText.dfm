inherited templateTEXT: TtemplateTEXT
  Left = 338
  Top = 250
  Caption = 'Text Document'
  ClientHeight = 270
  ClientWidth = 492
  OnMouseUp = FormMouseUp
  ExplicitWidth = 500
  ExplicitHeight = 304
  PixelsPerInch = 96
  TextHeight = 13
  inherited pnltop: TPanel
    Width = 492
    ExplicitWidth = 492
    inherited imagedesc: TPanel
      Width = 400
      ExplicitWidth = 400
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
