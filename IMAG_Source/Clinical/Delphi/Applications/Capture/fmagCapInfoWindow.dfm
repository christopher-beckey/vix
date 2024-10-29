object frmCapInfoWindow: TfrmCapInfoWindow
  Left = 290
  Top = 146
  AlphaBlendValue = 100
  BorderStyle = bsNone
  Caption = 'Image properties'
  ClientHeight = 234
  ClientWidth = 508
  Color = clInactiveBorder
  TransparentColorValue = clOlive
  Font.Charset = DEFAULT_CHARSET
  Font.Color = clWindowText
  Font.Height = -11
  Font.Name = 'MS Sans Serif'
  Font.Style = []
  OldCreateOrder = False
  PixelsPerInch = 96
  TextHeight = 13
  object Bevel1: TBevel
    Left = 0
    Top = 0
    Width = 508
    Height = 234
    Align = alClient
    Shape = bsFrame
    Style = bsRaised
  end
  object lbImageProperties: TLabel
    Left = 0
    Top = 0
    Width = 508
    Height = 234
    Align = alClient
    Caption = 'lbImageProperties'
    Color = clScrollBar
    Font.Charset = DEFAULT_CHARSET
    Font.Color = clMaroon
    Font.Height = -13
    Font.Name = 'MS Sans Serif'
    Font.Style = [fsBold]
    ParentColor = False
    ParentFont = False
    Transparent = True
    WordWrap = True
  end
end
