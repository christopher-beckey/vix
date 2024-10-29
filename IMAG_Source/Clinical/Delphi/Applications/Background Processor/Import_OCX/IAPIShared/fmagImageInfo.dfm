object frmMagImageInfo: TfrmMagImageInfo
  Left = 631
  Top = 215
  HelpContext = 10095
  VertScrollBar.Tracking = True
  Caption = 'Image Information'
  ClientHeight = 328
  ClientWidth = 433
  Color = clBtnFace
  Constraints.MinHeight = 340
  Constraints.MinWidth = 425
  Font.Charset = DEFAULT_CHARSET
  Font.Color = clWindowText
  Font.Height = -11
  Font.Name = 'MS Sans Serif'
  Font.Style = []
  OldCreateOrder = False
  OnClose = FormClose
  OnCreate = FormCreate
  OnDestroy = FormDestroy
  OnKeyDown = FormKeyDown
  PixelsPerInch = 96
  TextHeight = 13
  object StatusBar1: TStatusBar
    Left = 0
    Top = 309
    Width = 433
    Height = 19
    Panels = <
      item
        Width = 50
      end
      item
        Width = 50
      end>
  end
  object scboxFrames: TScrollBox
    Left = 40
    Top = 20
    Width = 333
    Height = 169
    VertScrollBar.Smooth = True
    VertScrollBar.Tracking = True
    BorderStyle = bsNone
    TabOrder = 1
  end
  object pnlClose: TPanel
    Left = 0
    Top = 262
    Width = 433
    Height = 47
    Align = alBottom
    BevelOuter = bvNone
    TabOrder = 2
    object btnClose: TBitBtn
      Left = 241
      Top = 12
      Width = 75
      Height = 25
      Caption = 'Close'
      TabOrder = 0
      OnClick = BitBtn1Click
      Kind = bkCancel
    end
  end
end
