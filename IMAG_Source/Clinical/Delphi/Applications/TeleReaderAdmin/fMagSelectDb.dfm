object frmSelectDB: TfrmSelectDB
  Left = 1004
  Top = 349
  BorderIcons = [biSystemMenu]
  BorderStyle = bsSingle
  Caption = 'VistA Database Configuration'
  ClientHeight = 142
  ClientWidth = 357
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
    Left = 30
    Top = 8
    Width = 297
    Height = 24
    Alignment = taCenter
    AutoSize = False
    Caption = 'Enter Server Configuration'
    Font.Charset = DEFAULT_CHARSET
    Font.Color = clWindowText
    Font.Height = -19
    Font.Name = 'MS Sans Serif'
    Font.Style = [fsBold]
    ParentFont = False
  end
  object edtServer: TLabeledEdit
    Left = 105
    Top = 40
    Width = 217
    Height = 21
    EditLabel.Width = 91
    EditLabel.Height = 16
    EditLabel.Caption = 'VistA Server:'
    EditLabel.Font.Charset = DEFAULT_CHARSET
    EditLabel.Font.Color = clWindowText
    EditLabel.Font.Height = -13
    EditLabel.Font.Name = 'MS Sans Serif'
    EditLabel.Font.Style = [fsBold]
    EditLabel.ParentFont = False
    Font.Charset = DEFAULT_CHARSET
    Font.Color = clWindowText
    Font.Height = -11
    Font.Name = 'MS Sans Serif'
    Font.Style = []
    LabelPosition = lpLeft
    ParentFont = False
    TabOrder = 0
    OnChange = EditChange
  end
  object edtPort: TLabeledEdit
    Left = 105
    Top = 72
    Width = 217
    Height = 21
    EditLabel.Width = 73
    EditLabel.Height = 16
    EditLabel.Caption = 'VistA Port:'
    EditLabel.Font.Charset = DEFAULT_CHARSET
    EditLabel.Font.Color = clWindowText
    EditLabel.Font.Height = -13
    EditLabel.Font.Name = 'MS Sans Serif'
    EditLabel.Font.Style = [fsBold]
    EditLabel.ParentFont = False
    LabelPosition = lpLeft
    TabOrder = 1
    OnChange = EditChange
    OnKeyPress = edtPortKeyPress
  end
  object btnOK: TButton
    Left = 101
    Top = 104
    Width = 75
    Height = 25
    Caption = 'OK'
    Default = True
    Enabled = False
    ModalResult = 1
    TabOrder = 2
    OnClick = btnOKClick
  end
  object btnCancel: TButton
    Left = 181
    Top = 104
    Width = 75
    Height = 25
    Cancel = True
    Caption = 'Cancel'
    ModalResult = 2
    TabOrder = 3
  end
  object amgrMain: TVA508AccessibilityManager
    Data = (
      (
        'Component = frmSelectDB'
        'Status = stsDefault'))
  end
end
