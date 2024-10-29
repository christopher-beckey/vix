object frmMagMakeAbsMain: TfrmMagMakeAbsMain
  Left = 288
  Top = 132
  Width = 506
  Height = 305
  Caption = 'MagMakeAbs'
  Color = clBtnFace
  Font.Charset = DEFAULT_CHARSET
  Font.Color = clWindowText
  Font.Height = -10
  Font.Name = 'MS Sans Serif'
  Font.Style = []
  Menu = MainMenu1
  OldCreateOrder = False
  OnActivate = FormActivate
  OnCreate = FormCreate
  OnResize = FormResize
  PixelsPerInch = 96
  TextHeight = 13
  object IGFormatsCtl1: TIGFormatsCtl
    Left = 332
    Top = 85
    Width = 32
    Height = 32
    ControlData = {10070000A5020000A5020000}
  end
  object IGProcessingCtl1: TIGProcessingCtl
    Left = 332
    Top = 117
    Width = 32
    Height = 32
    ControlData = {10070000A5020000A5020000}
  end
  object IGDisplayCtl1: TIGDisplayCtl
    Left = 332
    Top = 156
    Width = 32
    Height = 32
    ControlData = {10070000A5020000A5020000}
  end
  object IGPageViewCtl1: TIGPageViewCtl
    Left = 0
    Top = 0
    Width = 229
    Height = 203
    TabOrder = 3
    ControlData = {
      10070000AB170000FB1400000B00FFFFCDCD0B00CDCD0B00CDCD0B00CDCD0B00
      CDCD0B00CDCD0B00CDCD0B00CDCD0B00CDCD0B00FFFF09000452E30B918FCE11
      9DE300AA004BB8516C740000AC020000010000006C0000000000000000000000
      FFFFFFFFFFFFFFFF0000000000000000386300004C4F000020454D4600000100
      AC02000010000000040000000000000000000000000000000005000000040000
      FE000000CB00000000000000000000000000000030E00300F81803001B000000
      100000000000000000000000520000007001000001000000F3FFFFFF00000000
      00000000000000009001000000000001000000004D0053002000530061006E00
      7300200053006500720069006600000000000000000000000000000000000000
      0000000000000000000000000000000000000000000001000300000000000000
      4D0053002000530061006E007300200053006500720069006600000000000000
      00000000000000000000000084FB1200EF15FA77C4FA120018000000C8489100
      030000000000130003000000000FA3013547E177A56EE277010001805CFB1200
      70FA12000101010004FC12009181F9775096F8770000FFFF84FB1200CC6EE277
      0000130000000000D8701300508041009C2452018CFC12000300000068FB1200
      F84900007002F977FFFFFFFF78FB1200FB01F97700000000582D52018C961500
      4E460041000000000100004034750041582D5201FC490000582D5201F6460041
      307500411C0000003C2D520140490041ACFB1200647600080000000025000000
      0C00000001000000180000000C00000000000000260000001C00000002000000
      00000000010000000000000000000000250000000C0000000200000014000000
      0C0000000D00000027000000180000000300000000000000FFFFFF0000000000
      250000000C00000003000000190000000C000000FFFFFF00120000000C000000
      02000000250000000C00000007000080250000000C0000000500008025000000
      0C0000000D0000800E000000140000000000000010000000140000000300CDCD
      CDCD}
  end
  object IGDlgsCtl1: TIGDlgsCtl
    Left = 338
    Top = 195
    Width = 32
    Height = 32
    ControlData = {10070000A5020000A5020000}
  end
  object IGMedCtl1: TIGMedCtl
    Left = 416
    Top = 120
    Width = 32
    Height = 32
    ControlData = {100700004F0300004F030000}
  end
  object IGCoreCtl1: TIGCoreCtl
    Left = 320
    Top = 8
    Width = 32
    Height = 32
    ControlData = {100700004F0300004F030000}
  end
  object MainMenu1: TMainMenu
    Left = 408
    Top = 8
    object File1: TMenuItem
      Caption = '&File'
      object mnuFileLoad: TMenuItem
        Caption = 'Load...'
        OnClick = mnuFileLoadClick
        object File2: TMenuItem
          Caption = 'File'
          OnClick = File2Click
        end
      end
      object mnuFileSave: TMenuItem
        Caption = 'Save...'
        OnClick = mnuFileSaveClick
      end
      object mnuMakeAbs1: TMenuItem
        Caption = 'MakeAbs'
        OnClick = mnuMakeAbs1Click
      end
      object N1: TMenuItem
        Caption = '-'
      end
      object mnuFileInfo: TMenuItem
        Caption = 'Info'
        OnClick = mnuFileInfoClick
      end
      object N2: TMenuItem
        Caption = '-'
      end
      object mnuExit: TMenuItem
        Caption = 'Exit'
        OnClick = mnuExitClick
      end
    end
    object mnuView: TMenuItem
      Caption = 'View'
      object ZoomIn1: TMenuItem
        Caption = 'Zoom In'
        OnClick = ZoomIn1Click
      end
      object ZoomOut1: TMenuItem
        Caption = 'Zoom Out'
        OnClick = ZoomOut1Click
      end
      object ZoomReset1: TMenuItem
        Caption = 'Zoom Reset'
        OnClick = ZoomReset1Click
      end
    end
    object mnuAdjust1: TMenuItem
      Caption = 'Adjust'
      object mnuAutoWinLev1: TMenuItem
        Caption = 'AutoWinLev'
        OnClick = mnuAutoWinLev1Click
      end
      object mnuMaxMin1: TMenuItem
        Caption = 'MaxMin'
        OnClick = mnuMaxMin1Click
      end
      object menuReduceTo8Bits1: TMenuItem
        Caption = 'ReduceTo8Bits'
      end
    end
    object mnuColor1: TMenuItem
      Caption = 'Color'
      Hint = 'mnuColor'
      object mnuGreenOnly1: TMenuItem
        Caption = 'Green Only'
        OnClick = mnuGreenOnly1Click
      end
      object mnuBlueOnly: TMenuItem
        Caption = 'Blue Only'
      end
      object mnuRedOnly1: TMenuItem
        Caption = 'Red Only'
      end
      object mnuSwapRedandBlue1: TMenuItem
        Caption = 'SwapRedandBlue'
        OnClick = mnuSwapRedandBlue1Click
      end
    end
    object Settings1: TMenuItem
      Caption = 'Settings'
      object mnuComponents1: TMenuItem
        Caption = 'Components'
        Visible = False
        OnClick = mnuComponents1Click
      end
    end
    object mnuDataSet: TMenuItem
      Caption = 'DataSet'
      Visible = False
      object MnuCheck: TMenuItem
        Caption = 'Check for Dataset'
        Visible = False
        OnClick = MnuCheckClick
      end
    end
    object Help1: TMenuItem
      Caption = '&Help'
      object About1: TMenuItem
        Caption = 'About'
        OnClick = About1Click
      end
    end
  end
end
