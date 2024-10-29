object frmMagASet: TfrmMagASet
  Left = 219
  Top = 119
  BorderStyle = bsDialog
  Caption = 'VistA Imaging: AutoUpdat Config.'
  ClientHeight = 171
  ClientWidth = 306
  Color = clBtnFace
  Font.Charset = DEFAULT_CHARSET
  Font.Color = clWindowText
  Font.Height = -11
  Font.Name = 'MS Sans Serif'
  Font.Style = []
  OldCreateOrder = False
  Position = poDesktopCenter
  OnActivate = FormActivate
  PixelsPerInch = 96
  TextHeight = 13
  object lblInfo: TLabel
    Left = 16
    Top = 16
    Width = 277
    Height = 13
    Caption = 'Setup the Imaging Application to automatically update itself'
    Font.Charset = DEFAULT_CHARSET
    Font.Color = clWindowText
    Font.Height = -11
    Font.Name = 'MS Sans Serif'
    Font.Style = []
    ParentFont = False
  end
  object lblUpdatePath: TLabel
    Left = 72
    Top = 72
    Width = 3
    Height = 13
    Font.Charset = DEFAULT_CHARSET
    Font.Color = clBlue
    Font.Height = -11
    Font.Name = 'MS Sans Serif'
    Font.Style = []
    ParentFont = False
  end
  object Label1: TLabel
    Left = 16
    Top = 32
    Width = 85
    Height = 13
    Caption = 'from this directory.'
  end
  object Label2: TLabel
    Left = 16
    Top = 72
    Width = 45
    Height = 13
    Caption = 'Directory:'
  end
  object lblDone: TLabel
    Left = 16
    Top = 152
    Width = 3
    Height = 13
  end
  object btnClose: TButton
    Left = 176
    Top = 112
    Width = 73
    Height = 25
    Caption = 'Close'
    TabOrder = 0
    OnClick = btnCloseClick
  end
  object btnOK: TButton
    Left = 64
    Top = 112
    Width = 73
    Height = 25
    Caption = 'OK'
    TabOrder = 1
    OnClick = btnOKClick
  end
end
