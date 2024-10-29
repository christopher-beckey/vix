object frmGenOverlay: TfrmGenOverlay
  Left = 989
  Top = 528
  Width = 280
  Height = 293
  AlphaBlend = True
  AlphaBlendValue = 175
  BorderIcons = []
  BorderStyle = bsSizeToolWin
  Caption = 'Verify Image overlay'
  Color = clWhite
  TransparentColor = True
  TransparentColorValue = clFuchsia
  Font.Charset = DEFAULT_CHARSET
  Font.Color = clWindowText
  Font.Height = -11
  Font.Name = 'MS Sans Serif'
  Font.Style = []
  FormStyle = fsStayOnTop
  OldCreateOrder = False
  PixelsPerInch = 96
  TextHeight = 13
  object lbPatName: TLabel
    Left = 0
    Top = 40
    Width = 159
    Height = 37
    Caption = 'lbPatName'
    Font.Charset = DEFAULT_CHARSET
    Font.Color = clRed
    Font.Height = -32
    Font.Name = 'MS Sans Serif'
    Font.Style = []
    ParentFont = False
    Transparent = True
  end
  object lbImageType: TLabel
    Left = 0
    Top = 84
    Width = 183
    Height = 37
    Caption = 'lbImageType'
    Font.Charset = DEFAULT_CHARSET
    Font.Color = clRed
    Font.Height = -32
    Font.Name = 'MS Sans Serif'
    Font.Style = []
    ParentFont = False
    Transparent = True
  end
  object lbImageSpec: TLabel
    Left = 0
    Top = 136
    Width = 185
    Height = 37
    Caption = 'lbImageSpec'
    Font.Charset = DEFAULT_CHARSET
    Font.Color = clRed
    Font.Height = -32
    Font.Name = 'MS Sans Serif'
    Font.Style = []
    ParentFont = False
    Transparent = True
  end
  object btnMove: TSpeedButton
    Left = 0
    Top = 0
    Width = 113
    Height = 17
    Caption = '[move info position]'
    OnClick = btnMoveClick
  end
  object lbImageProc: TLabel
    Left = 0
    Top = 184
    Width = 179
    Height = 37
    Caption = 'lbImageProc'
    Font.Charset = DEFAULT_CHARSET
    Font.Color = clRed
    Font.Height = -32
    Font.Name = 'MS Sans Serif'
    Font.Style = []
    ParentFont = False
    Transparent = True
  end
  object btnHide: TButton
    Left = 128
    Top = 0
    Width = 37
    Height = 17
    Caption = '[close]'
    TabOrder = 0
    OnClick = btnHideClick
  end
end
