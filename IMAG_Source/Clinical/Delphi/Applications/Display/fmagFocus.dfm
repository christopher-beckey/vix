object frmFocus: TfrmFocus
  Left = -3782
  Top = 443
  AlphaBlend = True
  BorderStyle = bsNone
  Caption = 'frmFocus'
  ClientHeight = 220
  ClientWidth = 220
  Color = clFuchsia
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
  object Panel1: TPanel
    Left = 0
    Top = 0
    Width = 220
    Height = 220
    Align = alClient
    BevelOuter = bvNone
    BorderStyle = bsSingle
    Caption = 'Panel1'
    Color = clYellow
    TabOrder = 0
    DesignSize = (
      216
      216)
    object Panel2: TPanel
      Left = 5
      Top = 5
      Width = 210
      Height = 210
      Anchors = [akLeft, akTop, akRight, akBottom]
      Color = clFuchsia
      TabOrder = 0
      object Label1: TLabel
        Left = 54
        Top = 18
        Width = 74
        Height = 13
        Caption = 'form3 no border'
      end
    end
  end
end
