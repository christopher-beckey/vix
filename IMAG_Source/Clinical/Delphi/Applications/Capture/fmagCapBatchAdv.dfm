object frmCapBatchAdv: TfrmCapBatchAdv
  Left = 482
  Top = 282
  BorderStyle = bsToolWindow
  Caption = 'Advanced Batch Capture Options'
  ClientHeight = 162
  ClientWidth = 314
  Color = clBtnFace
  Font.Charset = DEFAULT_CHARSET
  Font.Color = clWindowText
  Font.Height = -11
  Font.Name = 'MS Sans Serif'
  Font.Style = []
  FormStyle = fsStayOnTop
  OldCreateOrder = True
  Position = poScreenCenter
  OnCreate = FormCreate
  PixelsPerInch = 96
  TextHeight = 13
  object Bevel1: TBevel
    Left = 33
    Top = 32
    Width = 248
    Height = 89
  end
  object lbModality: TLabel
    Left = 41
    Top = 71
    Width = 72
    Height = 13
    Caption = 'Select Modality'
    Enabled = False
  end
  object lbCopyAll: TLabel
    Left = 62
    Top = 43
    Width = 210
    Height = 13
    Caption = 'Copy all associated files.  i.e. BIG, TXT, ABS'
    Enabled = False
    OnClick = lbCopyAllClick
  end
  object chkCopyAll: TCheckBox
    Left = 40
    Top = 41
    Width = 19
    Height = 17
    Caption = 'Copy all associated files.  i.e. BIG, TXT, ABS'
    Enabled = False
    TabOrder = 0
    OnClick = chkCopyAllClick
  end
  object cbxModality: TComboBox
    Left = 40
    Top = 90
    Width = 197
    Height = 22
    Enabled = False
    Font.Charset = DEFAULT_CHARSET
    Font.Color = clBlack
    Font.Height = -11
    Font.Name = 'Arial'
    Font.Style = []
    ItemHeight = 14
    ParentFont = False
    TabOrder = 1
    OnChange = cbxModalityChange
    Items.Strings = (
      'CR      Computed Radiography'
      'CT      Computed Tomography'
      'MR      Magnetic Resonance'
      'XA       X-Ray Angiography'
      'US      Ultrasound'
      'NM      Nuclear Medicine'
      'OT      Other')
  end
  object btnClose: TBitBtn
    Left = 102
    Top = 128
    Width = 75
    Height = 25
    TabOrder = 2
    Kind = bkClose
  end
  object chkEnable: TCheckBox
    Left = 14
    Top = 6
    Width = 231
    Height = 17
    Caption = 'Enable Advanced Batch Capture'
    TabOrder = 3
    OnClick = chkEnableClick
  end
end
