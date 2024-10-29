object frmLog: TfrmLog
  Left = 607
  Top = 349
  Width = 499
  Height = 230
  Caption = 'DICOM Viewer Log'
  Color = clBtnFace
  Font.Charset = DEFAULT_CHARSET
  Font.Color = clWindowText
  Font.Height = -11
  Font.Name = 'MS Sans Serif'
  Font.Style = []
  OldCreateOrder = False
  OnCreate = FormCreate
  PixelsPerInch = 96
  TextHeight = 13
  object MemLog: TMemo
    Left = 40
    Top = 40
    Width = 185
    Height = 121
    Lines.Strings = (
      'MemLog')
    ReadOnly = True
    ScrollBars = ssVertical
    TabOrder = 0
  end
  object pnlTop: TPanel
    Left = 0
    Top = 0
    Width = 491
    Height = 25
    Align = alTop
    BevelOuter = bvNone
    TabOrder = 1
    object btnSave: TButton
      Left = 128
      Top = 0
      Width = 33
      Height = 25
      Caption = 'Save'
      TabOrder = 1
      OnClick = btnSaveClick
    end
    object btnClear: TButton
      Left = 184
      Top = 0
      Width = 33
      Height = 25
      Caption = 'Clear'
      TabOrder = 0
      OnClick = btnClearClick
    end
    object chkWordWrap: TCheckBox
      Left = 32
      Top = 0
      Width = 81
      Height = 25
      Caption = 'Word Wrap'
      Checked = True
      State = cbChecked
      TabOrder = 2
      OnClick = chkWordWrapClick
    end
  end
  object SaveDialog1: TSaveDialog
    Left = 240
    Top = 72
  end
end
