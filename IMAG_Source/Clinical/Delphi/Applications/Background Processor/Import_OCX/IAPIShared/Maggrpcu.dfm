object maggrpcf: Tmaggrpcf
  Left = 271
  Top = 613
  Width = 544
  Height = 256
  HelpContext = 10210
  Caption = 'Report:'
  Color = clBtnFace
  Font.Charset = DEFAULT_CHARSET
  Font.Color = clBlack
  Font.Height = -11
  Font.Name = 'Arial'
  Font.Style = [fsBold]
  Icon.Data = {
    0000010001001010020000000000B00000001600000028000000100000002000
    0000010001000000000080000000000000000000000000000000000000000000
    0000FFFFFF000000000000000000000000000FF00000087000000FF000000810
    00000FF00000081000000FF0000008F000000F80000009A000000F8000000000
    000000000000FFFF0000FFFF0000E0070000E0070000E0070000E0070000E007
    0000E0070000E0070000E0070000E0070000E0070000E00F0000E01F0000E03F
    0000FFFF0000}
  Menu = MainMenu1
  OldCreateOrder = True
  Position = poDefault
  OnClose = FormClose
  OnCreate = FormCreate
  OnDestroy = FormDestroy
  PixelsPerInch = 96
  TextHeight = 14
  object pDesc: TPanel
    Left = 0
    Top = 0
    Width = 536
    Height = 20
    Align = alTop
    Alignment = taLeftJustify
    BevelInner = bvLowered
    Font.Charset = DEFAULT_CHARSET
    Font.Color = clBlack
    Font.Height = -12
    Font.Name = 'MS Sans Serif'
    Font.Style = []
    ParentFont = False
    TabOrder = 0
  end
  object Memo1: TMemo
    Left = 0
    Top = 20
    Width = 536
    Height = 182
    Align = alClient
    Color = clInfoBk
    Font.Charset = DEFAULT_CHARSET
    Font.Color = clBlack
    Font.Height = -13
    Font.Name = 'Courier'
    Font.Style = []
    ParentFont = False
    ReadOnly = True
    ScrollBars = ssBoth
    TabOrder = 1
  end
  object FontDialog1: TFontDialog
    Font.Charset = DEFAULT_CHARSET
    Font.Color = clBlack
    Font.Height = -16
    Font.Name = 'Arial'
    Font.Style = [fsBold]
    Left = 450
    Top = 26
  end
  object PrinterSetupDialog1: TPrinterSetupDialog
    Left = 373
    Top = 28
  end
  object PrintDialog1: TPrintDialog
    Left = 413
    Top = 27
  end
  object MainMenu1: TMainMenu
    Left = 318
    Top = 30
    object File1: TMenuItem
      Caption = '&File'
      object New1: TMenuItem
        Caption = 'New Report Window'
        OnClick = New1Click
      end
      object N4: TMenuItem
        Caption = '-'
      end
      object N2: TMenuItem
        Caption = '&Font'
        OnClick = N2Click
      end
      object N3: TMenuItem
        Caption = '-'
      end
      object Print1: TMenuItem
        Caption = '&Print...'
        OnClick = Print1Click
      end
      object PrintSetup1: TMenuItem
        Caption = 'P&rint Setup...'
        OnClick = PrintSetup1Click
      end
      object N1: TMenuItem
        Caption = '-'
      end
      object Exit1: TMenuItem
        Caption = 'E&xit'
        OnClick = Exit1Click
      end
      object ActiveForms1: TMenuItem
        Caption = 'Active Forms...'
        ShortCut = 16471
        Visible = False
        OnClick = ActiveForms1Click
      end
    end
    object Help1: TMenuItem
      Caption = '&Help'
      object ImageReports1: TMenuItem
        Caption = 'Image &Reports'
        OnClick = ImageReports1Click
      end
    end
  end
end
