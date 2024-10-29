object frmCineView: TfrmCineView
  Left = 414
  Top = 253
  BorderIcons = [biSystemMenu]
  BorderStyle = bsSingle
  Caption = 'DICOM Multiframe Cine View'
  ClientHeight = 111
  ClientWidth = 599
  Color = clBtnFace
  Font.Charset = DEFAULT_CHARSET
  Font.Color = clWindowText
  Font.Height = -11
  Font.Name = 'MS Sans Serif'
  Font.Style = []
  Menu = MainMenu1
  OldCreateOrder = False
  OnClose = FormClose
  OnCreate = FormCreate
  OnDestroy = FormDestroy
  PixelsPerInch = 96
  TextHeight = 13
  object Label1: TLabel
    Left = 224
    Top = 24
    Width = 157
    Height = 17
    AutoSize = False
  end
  object Label2: TLabel
    Left = 408
    Top = 32
    Width = 65
    Height = 17
    AutoSize = False
    Caption = 'Cine Speed'
  end
  object lblCineSpeed: TLabel
    Left = 484
    Top = 32
    Width = 41
    Height = 17
    AutoSize = False
  end
  object Faster: TLabel
    Left = 400
    Top = 72
    Width = 33
    Height = 17
    AutoSize = False
    Caption = 'Faster'
  end
  object Label3: TLabel
    Left = 488
    Top = 72
    Width = 33
    Height = 17
    AutoSize = False
    Caption = 'Slower'
  end
  object GroupBox1: TGroupBox
    Left = 100
    Top = 12
    Width = 113
    Height = 85
    Caption = 'Play Mode:'
    TabOrder = 3
    object RadioButton1: TRadioButton
      Left = 24
      Top = 24
      Width = 73
      Height = 17
      Caption = 'Play once'
      TabOrder = 0
    end
    object RadioButton2: TRadioButton
      Left = 24
      Top = 48
      Width = 70
      Height = 17
      Caption = 'Repeat'
      TabOrder = 1
    end
  end
  object CineBar1: TScrollBar
    Left = 224
    Top = 48
    Width = 157
    Height = 16
    Min = 1
    PageSize = 0
    Position = 1
    TabOrder = 4
    OnChange = CineBar1Change
  end
  object PrevPg: TBitBtn
    Left = 224
    Top = 72
    Width = 75
    Height = 25
    Caption = '&PrevPg'
    TabOrder = 5
    OnClick = PrevPgClick
    Glyph.Data = {
      76010000424D7601000000000000760000002800000020000000100000000100
      0400000000000001000000000000000000001000000010000000000000000000
      800000800000008080008000000080008000808000007F7F7F00BFBFBF000000
      FF0000FF000000FFFF00FF000000FF00FF00FFFF0000FFFFFF00333333333333
      33333333333333333333333333333333333333333333333333FF333333333333
      3000333333FFFFF3F77733333000003000B033333777773777F733330BFBFB00
      E00033337FFF3377F7773333000FBFB0E000333377733337F7773330FBFBFBF0
      E00033F7FFFF3337F7773000000FBFB0E000377777733337F7770BFBFBFBFBF0
      E00073FFFFFFFF37F777300000000FB0E000377777777337F7773333330BFB00
      000033333373FF77777733333330003333333333333777333333333333333333
      3333333333333333333333333333333333333333333333333333333333333333
      3333333333333333333333333333333333333333333333333333}
    NumGlyphs = 2
  end
  object NextPg: TBitBtn
    Left = 310
    Top = 72
    Width = 71
    Height = 25
    Caption = '&NextPg'
    TabOrder = 6
    OnClick = NextPgClick
    Glyph.Data = {
      76010000424D7601000000000000760000002800000020000000100000000100
      0400000000000001000000000000000000001000000010000000000000000000
      800000800000008080008000000080008000808000007F7F7F00BFBFBF000000
      FF0000FF000000FFFF00FF000000FF00FF00FFFF0000FFFFFF00333333333333
      3333333333333333333333333333333333333FFF333333333333000333333333
      3333777FFF3FFFFF33330B000300000333337F777F777773F333000E00BFBFB0
      3333777F773333F7F333000E0BFBF0003333777F7F3337773F33000E0FBFBFBF
      0333777F7F3333FF7FFF000E0BFBF0000003777F7F3337777773000E0FBFBFBF
      BFB0777F7F33FFFFFFF7000E0BF000000003777F7FF777777773000000BFB033
      33337777773FF733333333333300033333333333337773333333333333333333
      3333333333333333333333333333333333333333333333333333333333333333
      3333333333333333333333333333333333333333333333333333}
    NumGlyphs = 2
  end
  object trkbrCineSpeed: TTrackBar
    Left = 400
    Top = 48
    Width = 121
    Height = 25
    Max = 200
    Min = 1
    Position = 1
    TabOrder = 7
    TickStyle = tsNone
    OnChange = trkbrCineSpeedChange
  end
  object btnCine: TBitBtn
    Left = 16
    Top = 16
    Width = 75
    Height = 25
    Caption = '&Cine'
    TabOrder = 0
    OnClick = btnCineClick
  end
  object btnStop: TBitBtn
    Left = 16
    Top = 44
    Width = 75
    Height = 25
    Caption = '&Stop'
    TabOrder = 1
    OnClick = btnStopClick
  end
  object btnReset: TBitBtn
    Left = 16
    Top = 72
    Width = 75
    Height = 25
    Caption = '&Reset'
    TabOrder = 2
    OnClick = btnResetClick
  end
  object Timer1: TTimer
    Enabled = False
    Interval = 10
    OnTimer = Timer1Timer
    Left = 448
    Top = 64
  end
  object MainMenu1: TMainMenu
    Left = 416
    Top = 8
    object Hidden1: TMenuItem
      Caption = 'Hidden'
      Visible = False
      object SetParentFocus1: TMenuItem
        Caption = 'Set Parent Focus'
        ShortCut = 16451
        OnClick = SetParentFocus1Click
      end
    end
  end
end
