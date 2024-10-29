object frmAbout: TfrmAbout
  Left = 484
  Top = 364
  Width = 346
  Height = 214
  Caption = 'About ImageGear'
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
    Left = 16
    Top = 56
    Width = 124
    Height = 20
    Caption = 'ImageGear ver.'
    Font.Charset = DEFAULT_CHARSET
    Font.Color = clWindowText
    Font.Height = -17
    Font.Name = 'MS Sans Serif'
    Font.Style = []
    ParentFont = False
  end
  object Label2: TLabel
    Left = 16
    Top = 16
    Width = 187
    Height = 25
    Caption = 'AccuSoft Corporation'
    Font.Charset = DEFAULT_CHARSET
    Font.Color = clWindowText
    Font.Height = -23
    Font.Name = 'MS Sans Serif'
    Font.Style = []
    ParentFont = False
  end
  object lblVersion: TLabel
    Left = 144
    Top = 56
    Width = 77
    Height = 20
    Caption = '<version>'
    Font.Charset = DEFAULT_CHARSET
    Font.Color = clWindowText
    Font.Height = -17
    Font.Name = 'MS Sans Serif'
    Font.Style = []
    ParentFont = False
  end
  object btnOK: TButton
    Left = 136
    Top = 136
    Width = 89
    Height = 33
    Caption = 'OK'
    TabOrder = 0
    OnClick = btnOKClick
  end
end
