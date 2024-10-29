object frmCapSaveConfig: TfrmCapSaveConfig
  Left = 854
  Top = 28
  HelpContext = 999
  BorderStyle = bsDialog
  Caption = 'Save Configuration'
  ClientHeight = 126
  ClientWidth = 305
  Color = clBtnFace
  Font.Charset = DEFAULT_CHARSET
  Font.Color = clWindowText
  Font.Height = -11
  Font.Name = 'MS Sans Serif'
  Font.Style = []
  OldCreateOrder = False
  Position = poScreenCenter
  PixelsPerInch = 96
  TextHeight = 13
  object Label1: TLabel
    Left = 18
    Top = 10
    Width = 263
    Height = 19
    AutoSize = False
    Caption = 'Save the settings from the Main Capture Window'
  end
  object Label2: TLabel
    Left = 18
    Top = 31
    Width = 82
    Height = 13
    Caption = 'as Configuration: '
  end
  object cmboxConfig: TComboBox
    Left = 18
    Top = 48
    Width = 269
    Height = 21
    DropDownCount = 20
    ItemHeight = 13
    MaxLength = 60
    TabOrder = 0
    OnChange = cmboxConfigChange
  end
  object btnOK: TBitBtn
    Left = 55
    Top = 86
    Width = 75
    Height = 25
    Enabled = False
    TabOrder = 1
    Kind = bkOK
  end
  object btnCancel: TBitBtn
    Left = 175
    Top = 86
    Width = 75
    Height = 25
    TabOrder = 2
    Kind = bkCancel
  end
end
