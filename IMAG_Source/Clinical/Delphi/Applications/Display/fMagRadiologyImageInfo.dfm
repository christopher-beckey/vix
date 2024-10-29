object frmRadiologyImageInfo: TfrmRadiologyImageInfo
  Left = 287
  Top = 232
  BorderIcons = [biSystemMenu]
  BorderStyle = bsSingle
  Caption = 'Image Header Information'
  ClientHeight = 212
  ClientWidth = 318
  Color = clBtnFace
  Font.Charset = DEFAULT_CHARSET
  Font.Color = clWindowText
  Font.Height = -11
  Font.Name = 'MS Sans Serif'
  Font.Style = []
  OldCreateOrder = False
  PixelsPerInch = 96
  TextHeight = 13
  object lbModality: TLabel
    Left = 8
    Top = 16
    Width = 49
    Height = 13
    AutoSize = False
    Caption = 'Modality: '
  end
  object lbSeriesNo: TLabel
    Left = 8
    Top = 40
    Width = 49
    Height = 13
    AutoSize = False
    Caption = 'Series No:'
  end
  object lbImageNo: TLabel
    Left = 8
    Top = 64
    Width = 46
    Height = 13
    AutoSize = False
    Caption = 'ImageNo:'
  end
  object dataModality: TLabel
    Left = 56
    Top = 16
    Width = 233
    Height = 13
    AutoSize = False
  end
  object dataSeries: TLabel
    Left = 64
    Top = 40
    Width = 201
    Height = 13
    AutoSize = False
  end
  object dataImageNo: TLabel
    Left = 64
    Top = 64
    Width = 209
    Height = 17
    AutoSize = False
  end
  object lbSliceTh: TLabel
    Left = 8
    Top = 88
    Width = 81
    Height = 17
    AutoSize = False
    Caption = 'SliceThickness:'
  end
  object dataSliceTh: TLabel
    Left = 96
    Top = 88
    Width = 120
    Height = 13
    AutoSize = False
  end
  object lbContrast: TLabel
    Left = 8
    Top = 112
    Width = 81
    Height = 17
    AutoSize = False
    Caption = 'Contrast Agent:'
  end
  object dataContrast: TLabel
    Left = 96
    Top = 112
    Width = 121
    Height = 13
    AutoSize = False
  end
  object lbProtocol: TLabel
    Left = 8
    Top = 136
    Width = 57
    Height = 25
    AutoSize = False
    Caption = 'Protocol:'
  end
  object dataProtocol: TLabel
    Left = 75
    Top = 136
    Width = 173
    Height = 25
    AutoSize = False
  end
  object btOK: TButton
    Left = 120
    Top = 176
    Width = 73
    Height = 25
    Caption = 'OK'
    TabOrder = 0
    OnClick = btOKClick
  end
end
