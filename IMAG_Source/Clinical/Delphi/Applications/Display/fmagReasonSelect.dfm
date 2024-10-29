object frmReasonSelect: TfrmReasonSelect
  Left = 417
  Top = 122
  BorderStyle = bsToolWindow
  Caption = 'List Selection:'
  ClientHeight = 300
  ClientWidth = 508
  Color = clBtnFace
  Font.Charset = DEFAULT_CHARSET
  Font.Color = clWindowText
  Font.Height = -11
  Font.Name = 'MS Sans Serif'
  Font.Style = []
  Menu = MainMenu1
  OldCreateOrder = False
  Position = poMainFormCenter
  OnCreate = FormCreate
  OnDestroy = FormDestroy
  PixelsPerInch = 96
  TextHeight = 13
  object lbPrompt: TLabel
    Left = 56
    Top = 20
    Width = 162
    Height = 13
    Caption = 'Select Reason for '#39'Needs Review'#39
  end
  object btnOk: TBitBtn
    Left = 120
    Top = 240
    Width = 75
    Height = 25
    Enabled = False
    TabOrder = 0
    Kind = bkOK
  end
  object btnCancel: TBitBtn
    Left = 288
    Top = 240
    Width = 75
    Height = 25
    TabOrder = 1
    Kind = bkCancel
  end
  object lstReason: TListBox
    Left = 60
    Top = 60
    Width = 385
    Height = 149
    ItemHeight = 13
    TabOrder = 2
    OnClick = lstReasonClick
  end
  object MainMenu1: TMainMenu
    Left = 440
    object File1: TMenuItem
      Caption = 'File'
      object Exit1: TMenuItem
        Caption = 'Exit'
        OnClick = Exit1Click
      end
    end
    object Help1: TMenuItem
      Caption = 'Help'
      object ReasonSelectHelptopic1: TMenuItem
        Caption = 'Reason Select Help topic'
      end
    end
  end
end
