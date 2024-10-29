object frmSelectClinic: TfrmSelectClinic
  Left = 434
  Top = 261
  BorderStyle = bsDialog
  Caption = 'Select Clinic(s)'
  ClientHeight = 492
  ClientWidth = 655
  Color = clBtnFace
  Font.Charset = DEFAULT_CHARSET
  Font.Color = clWindowText
  Font.Height = -11
  Font.Name = 'MS Sans Serif'
  Font.Style = []
  OldCreateOrder = False
  OnClose = FormClose
  OnShow = FormShow
  PixelsPerInch = 96
  TextHeight = 13
  object Label1: TLabel
    Left = 15
    Top = 8
    Width = 117
    Height = 16
    Caption = 'Available Clinics'
    Font.Charset = DEFAULT_CHARSET
    Font.Color = clWindowText
    Font.Height = -13
    Font.Name = 'MS Sans Serif'
    Font.Style = [fsBold]
    ParentFont = False
  end
  object Label2: TLabel
    Left = 360
    Top = 8
    Width = 113
    Height = 16
    Caption = 'Selected Clinics'
    Font.Charset = DEFAULT_CHARSET
    Font.Color = clWindowText
    Font.Height = -13
    Font.Name = 'MS Sans Serif'
    Font.Style = [fsBold]
    ParentFont = False
  end
  object lstAvailable: TListBox
    Left = 15
    Top = 32
    Width = 275
    Height = 377
    ItemHeight = 13
    Sorted = True
    TabOrder = 0
    OnDblClick = btnToSelectedClick
    OnKeyDown = lstSelectedKeyDown
  end
  object lstSelected: TListBox
    Left = 360
    Top = 32
    Width = 275
    Height = 377
    ItemHeight = 13
    Sorted = True
    TabOrder = 3
    OnDblClick = btnToAvailableClick
    OnKeyDown = lstAvailableKeyDown
  end
  object btnSave: TBitBtn
    Left = 232
    Top = 437
    Width = 75
    Height = 25
    Enabled = False
    Font.Charset = DEFAULT_CHARSET
    Font.Color = clWindowText
    Font.Height = -13
    Font.Name = 'MS Sans Serif'
    Font.Style = []
    ParentFont = False
    ParentShowHint = False
    ShowHint = False
    TabOrder = 4
    Kind = bkOK
  end
  object btnCancel: TBitBtn
    Left = 348
    Top = 437
    Width = 75
    Height = 25
    Font.Charset = DEFAULT_CHARSET
    Font.Color = clWindowText
    Font.Height = -13
    Font.Name = 'MS Sans Serif'
    Font.Style = []
    ParentFont = False
    TabOrder = 5
    Kind = bkCancel
  end
  object btnToSelected2: TButton
    Left = 315
    Top = 168
    Width = 23
    Height = 25
    Caption = '>'
    Font.Charset = DEFAULT_CHARSET
    Font.Color = clWindowText
    Font.Height = -13
    Font.Name = 'MS Sans Serif'
    Font.Style = []
    ParentFont = False
    TabOrder = 1
    OnClick = btnToSelectedClick
  end
  object btnToAvailable2: TButton
    Left = 315
    Top = 208
    Width = 23
    Height = 25
    Caption = '<'
    Font.Charset = DEFAULT_CHARSET
    Font.Color = clWindowText
    Font.Height = -13
    Font.Name = 'MS Sans Serif'
    Font.Style = []
    ParentFont = False
    TabOrder = 2
    OnClick = btnToAvailableClick
  end
  object amgrMain: TVA508AccessibilityManager
    Data = (
      (
        'Component = frmSelectClinic'
        'Status = stsDefault')
      (
        'Component = btnToSelected2'
        'Text = Move To Selected'
        'Status = stsOK')
      (
        'Component = btnToAvailable2'
        'Text = Move To Available'
        'Status = stsOK'))
  end
end
