object frmRadImageInfo: TfrmRadImageInfo
  Left = 706
  Top = 418
  BorderIcons = [biSystemMenu]
  BorderStyle = bsSingle
  Caption = 'Image Info'
  ClientHeight = 268
  ClientWidth = 305
  Color = clBtnFace
  Font.Charset = DEFAULT_CHARSET
  Font.Color = clWindowText
  Font.Height = -11
  Font.Name = 'MS Sans Serif'
  Font.Style = []
  OldCreateOrder = False
  PixelsPerInch = 96
  TextHeight = 13
  object lblMaxPixel: TLabel
    Left = 89
    Top = 136
    Width = 52
    Height = 13
    Caption = 'lblMaxPixel'
  end
  object lblFileName: TLabel
    Left = 88
    Top = 209
    Width = 54
    Height = 13
    Caption = 'lblFileName'
    Visible = False
  end
  object lblCompression: TLabel
    Left = 89
    Top = 185
    Width = 70
    Height = 13
    Caption = 'lblCompression'
  end
  object lblFormat: TLabel
    Left = 89
    Top = 161
    Width = 42
    Height = 13
    Caption = 'lblFormat'
  end
  object lblBitDepth: TLabel
    Left = 89
    Top = 113
    Width = 51
    Height = 13
    Caption = 'lblBitDepth'
  end
  object lblDimensions: TLabel
    Left = 89
    Top = 89
    Width = 64
    Height = 13
    Caption = 'lblDimensions'
  end
  object lblPageCount: TLabel
    Left = 89
    Top = 65
    Width = 63
    Height = 13
    Caption = 'lblPageCount'
  end
  object lbPtID: TLabel
    Left = 88
    Top = 40
    Width = 121
    Height = 13
    AutoSize = False
  end
  object lbPtName: TLabel
    Left = 88
    Top = 16
    Width = 177
    Height = 13
    AutoSize = False
    Caption = 'lbPtName'
  end
  object Label7: TLabel
    Left = 8
    Top = 16
    Width = 67
    Height = 13
    AutoSize = False
    Caption = 'Patient Name:'
  end
  object Label8: TLabel
    Left = 8
    Top = 40
    Width = 27
    Height = 13
    AutoSize = False
    Caption = 'Pt ID:'
  end
  object Label2: TLabel
    Left = 8
    Top = 64
    Width = 58
    Height = 13
    Caption = 'Page count:'
  end
  object Label3: TLabel
    Left = 9
    Top = 89
    Width = 57
    Height = 13
    Caption = 'Dimensions:'
  end
  object Label4: TLabel
    Left = 9
    Top = 113
    Width = 45
    Height = 13
    Caption = 'Bit depth:'
  end
  object Label9: TLabel
    Left = 9
    Top = 137
    Width = 54
    Height = 13
    Caption = 'Max. Pixel: '
  end
  object Label5: TLabel
    Left = 9
    Top = 161
    Width = 54
    Height = 13
    Caption = 'File Format:'
  end
  object Label6: TLabel
    Left = 9
    Top = 185
    Width = 63
    Height = 13
    Caption = 'Compression:'
  end
  object Label10: TLabel
    Left = 8
    Top = 209
    Width = 48
    Height = 13
    Caption = 'File name:'
    Visible = False
  end
  object btnOK: TButton
    Left = 112
    Top = 232
    Width = 81
    Height = 25
    Caption = 'OK'
    TabOrder = 0
    OnClick = btnOKClick
  end
end
