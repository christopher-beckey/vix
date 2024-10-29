object frmFormatInfo: TfrmFormatInfo
  Left = 374
  Top = 177
  Width = 608
  Height = 600
  Caption = 'Format Info'
  Color = clBtnFace
  Font.Charset = DEFAULT_CHARSET
  Font.Color = clWindowText
  Font.Height = -13
  Font.Name = 'MS Sans Serif'
  Font.Style = []
  OldCreateOrder = False
  OnActivate = FormActivate
  PixelsPerInch = 120
  TextHeight = 16
  object Label1: TLabel
    Left = 8
    Top = 8
    Width = 65
    Height = 16
    Caption = 'File Name:'
  end
  object Label2: TLabel
    Left = 8
    Top = 32
    Width = 108
    Height = 16
    Caption = 'Number of Pages:'
  end
  object Label3: TLabel
    Left = 8
    Top = 56
    Width = 70
    Height = 16
    Caption = 'File Format:'
  end
  object lblFileFormatValue: TLabel
    Left = 144
    Top = 56
    Width = 6
    Height = 16
    Caption = 'x'
  end
  object lblFileNameValue: TLabel
    Left = 144
    Top = 8
    Width = 6
    Height = 16
    Caption = 'x'
  end
  object lblPageCountValue: TLabel
    Left = 144
    Top = 32
    Width = 6
    Height = 16
    Caption = 'x'
  end
  object btnOK: TButton
    Left = 240
    Top = 528
    Width = 89
    Height = 33
    Caption = 'OK'
    TabOrder = 0
    OnClick = btnOKClick
  end
  object GroupBox1: TGroupBox
    Left = 8
    Top = 88
    Width = 585
    Height = 425
    Caption = 'Page Info'
    TabOrder = 1
    object Label4: TLabel
      Left = 16
      Top = 24
      Width = 87
      Height = 16
      Caption = 'Page Number:'
    end
    object Label5: TLabel
      Left = 16
      Top = 48
      Width = 78
      Height = 16
      Caption = 'Image Width:'
    end
    object Label6: TLabel
      Left = 16
      Top = 72
      Width = 57
      Height = 16
      Caption = 'Bit Depth:'
    end
    object Label7: TLabel
      Left = 240
      Top = 24
      Width = 83
      Height = 16
      Caption = 'Compression:'
    end
    object Label8: TLabel
      Left = 240
      Top = 48
      Width = 83
      Height = 16
      Caption = 'Image Height:'
    end
    object Label9: TLabel
      Left = 16
      Top = 96
      Width = 78
      Height = 16
      Caption = 'Color Space:'
    end
    object label10: TLabel
      Left = 184
      Top = 96
      Width = 124
      Height = 16
      Caption = 'Number of Channels:'
    end
    object Label11: TLabel
      Left = 360
      Top = 96
      Width = 98
      Height = 16
      Caption = 'Number of Tiles:'
    end
    object lblPageNumberValue: TLabel
      Left = 136
      Top = 24
      Width = 6
      Height = 16
      Caption = 'x'
    end
    object lblImageWidthValue: TLabel
      Left = 136
      Top = 48
      Width = 6
      Height = 16
      Caption = 'x'
    end
    object lblBitDepthValue: TLabel
      Left = 136
      Top = 72
      Width = 6
      Height = 16
      Caption = 'x'
    end
    object lblCompressionValue: TLabel
      Left = 344
      Top = 24
      Width = 6
      Height = 16
      Caption = 'x'
    end
    object lblImageHeightValue: TLabel
      Left = 344
      Top = 48
      Width = 6
      Height = 16
      Caption = 'x'
    end
    object lblColorSpaceValue: TLabel
      Left = 104
      Top = 96
      Width = 6
      Height = 16
      Caption = 'x'
    end
    object lblChannelCountValue: TLabel
      Left = 320
      Top = 96
      Width = 6
      Height = 16
      Caption = 'x'
    end
    object lblTileCountValue: TLabel
      Left = 472
      Top = 96
      Width = 6
      Height = 16
      Caption = 'x'
    end
    object GroupBox2: TGroupBox
      Left = 8
      Top = 120
      Width = 569
      Height = 57
      Caption = 'Channel Info'
      TabOrder = 0
      object Label12: TLabel
        Left = 8
        Top = 24
        Width = 49
        Height = 16
        Caption = 'Channel'
      end
      object Label13: TLabel
        Left = 184
        Top = 24
        Width = 35
        Height = 16
        Caption = 'Type:'
      end
      object Label14: TLabel
        Left = 344
        Top = 24
        Width = 39
        Height = 16
        Caption = 'Depth:'
      end
      object lblChannelTypeValue: TLabel
        Left = 232
        Top = 24
        Width = 6
        Height = 16
        Caption = 'x'
      end
      object lblChannelDepthValue: TLabel
        Left = 392
        Top = 24
        Width = 6
        Height = 16
        Caption = 'x'
      end
      object ListBox1: TListBox
        Left = 64
        Top = 24
        Width = 105
        Height = 17
        ItemHeight = 16
        Style = lbOwnerDrawFixed
        TabOrder = 0
      end
    end
    object GroupBox3: TGroupBox
      Left = 8
      Top = 184
      Width = 569
      Height = 57
      Caption = 'Tile Info'
      TabOrder = 1
      object Label15: TLabel
        Left = 16
        Top = 24
        Width = 23
        Height = 16
        Caption = 'Tile'
      end
      object Label16: TLabel
        Left = 184
        Top = 24
        Width = 37
        Height = 16
        Caption = 'Width:'
      end
      object Label17: TLabel
        Left = 344
        Top = 24
        Width = 42
        Height = 16
        Caption = 'Height:'
      end
      object lblTileWidthValue: TLabel
        Left = 232
        Top = 24
        Width = 6
        Height = 16
        Caption = 'x'
      end
      object lblTileHeightValue: TLabel
        Left = 392
        Top = 24
        Width = 6
        Height = 16
        Caption = 'x'
      end
      object ListBox2: TListBox
        Left = 64
        Top = 24
        Width = 105
        Height = 17
        ItemHeight = 16
        TabOrder = 0
      end
    end
    object GroupBox4: TGroupBox
      Left = 8
      Top = 248
      Width = 569
      Height = 97
      Caption = 'DIB Info'
      TabOrder = 2
      object Label18: TLabel
        Left = 8
        Top = 24
        Width = 29
        Height = 16
        Caption = 'Size:'
      end
      object Label19: TLabel
        Left = 184
        Top = 24
        Width = 37
        Height = 16
        Caption = 'Width:'
      end
      object Label20: TLabel
        Left = 344
        Top = 24
        Width = 42
        Height = 16
        Caption = 'Height:'
      end
      object Label21: TLabel
        Left = 8
        Top = 48
        Width = 45
        Height = 16
        Caption = 'Planes:'
      end
      object Label22: TLabel
        Left = 120
        Top = 48
        Width = 55
        Height = 16
        Caption = 'Bit Count:'
      end
      object Label23: TLabel
        Left = 256
        Top = 48
        Width = 83
        Height = 16
        Caption = 'Compression:'
      end
      object Label24: TLabel
        Left = 400
        Top = 48
        Width = 70
        Height = 16
        Caption = 'Image Size:'
      end
      object Label25: TLabel
        Left = 8
        Top = 72
        Width = 52
        Height = 16
        Caption = 'ClrUsed:'
      end
      object Label26: TLabel
        Left = 120
        Top = 72
        Width = 74
        Height = 16
        Caption = 'ClrImportant:'
      end
      object Label27: TLabel
        Left = 256
        Top = 72
        Width = 93
        Height = 16
        Caption = 'XPelsPerMeter:'
      end
      object Label28: TLabel
        Left = 400
        Top = 72
        Width = 94
        Height = 16
        Caption = 'YPelsPerMeter:'
      end
      object lblDibSizeValue: TLabel
        Left = 64
        Top = 24
        Width = 6
        Height = 16
        Caption = 'x'
      end
      object lblDibPlanesValue: TLabel
        Left = 64
        Top = 48
        Width = 6
        Height = 16
        Caption = 'x'
      end
      object lblDibClrUsedValue: TLabel
        Left = 64
        Top = 72
        Width = 6
        Height = 16
        Caption = 'x'
      end
      object lblDibWidthValue: TLabel
        Left = 232
        Top = 24
        Width = 6
        Height = 16
        Caption = 'x'
      end
      object lblDibHeightValue: TLabel
        Left = 400
        Top = 24
        Width = 6
        Height = 16
        Caption = 'x'
      end
      object lblDibBitCountValue: TLabel
        Left = 184
        Top = 48
        Width = 6
        Height = 16
        Caption = 'x'
      end
      object lblDibClrImportantValue: TLabel
        Left = 200
        Top = 72
        Width = 6
        Height = 16
        Caption = 'x'
      end
      object lblDibCompressionValue: TLabel
        Left = 352
        Top = 48
        Width = 6
        Height = 16
        Caption = 'x'
      end
      object lblDibXPelsPerMeterValue: TLabel
        Left = 352
        Top = 72
        Width = 6
        Height = 16
        Caption = 'x'
      end
      object lblDibImageSizeValue: TLabel
        Left = 496
        Top = 48
        Width = 6
        Height = 16
        Caption = 'x'
      end
      object lblDibYPelsPerMeterValue: TLabel
        Left = 504
        Top = 72
        Width = 6
        Height = 16
        Caption = 'x'
      end
    end
    object GroupBox5: TGroupBox
      Left = 8
      Top = 352
      Width = 569
      Height = 57
      Caption = 'Image Resolution'
      TabOrder = 3
      object Label29: TLabel
        Left = 8
        Top = 24
        Width = 33
        Height = 16
        Caption = 'Units:'
      end
      object Label30: TLabel
        Left = 160
        Top = 24
        Width = 75
        Height = 16
        Caption = 'XResolution:'
      end
      object Label31: TLabel
        Left = 352
        Top = 24
        Width = 76
        Height = 16
        Caption = 'YResolution:'
      end
      object lblResolutionUnitsValue: TLabel
        Left = 48
        Top = 24
        Width = 6
        Height = 16
        Caption = 'x'
      end
      object lblResolutionXValue: TLabel
        Left = 248
        Top = 24
        Width = 6
        Height = 16
        Caption = 'x'
      end
      object lblResolutionYValue: TLabel
        Left = 432
        Top = 24
        Width = 6
        Height = 16
        Caption = 'x'
      end
    end
  end
end
