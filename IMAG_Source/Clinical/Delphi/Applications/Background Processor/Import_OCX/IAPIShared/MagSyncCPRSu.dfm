object MagSyncCPRSf: TMagSyncCPRSf
  Left = 191
  Top = 107
  BorderStyle = bsSingle
  Caption = 'Imaging <-> CPRS Link'
  ClientHeight = 116
  ClientWidth = 330
  Color = clBtnFace
  Font.Charset = DEFAULT_CHARSET
  Font.Color = clWindowText
  Font.Height = -11
  Font.Name = 'MS Sans Serif'
  Font.Style = []
  OldCreateOrder = True
  OnClose = FormClose
  OnShow = FormShow
  PixelsPerInch = 96
  TextHeight = 13
  object Label1: TLabel
    Left = 22
    Top = 144
    Width = 137
    Height = 13
    Caption = 'Not Selectable in Version 2.5'
  end
  object Label2: TLabel
    Left = 14
    Top = 66
    Width = 307
    Height = 43
    AutoSize = False
    Caption = 
      'Note : To Re-Synchronize with CPRS after the Link is broken,  Yo' +
      'u  have to stop Imaging and Restart Imaging from the CPRS Tools ' +
      'menu.'
    WordWrap = True
  end
  object cbSyncOn: TCheckBox
    Left = 46
    Top = 10
    Width = 237
    Height = 17
    Caption = 'Synchronize with CPRS Patient/Note/Exam'
    Color = clSilver
    ParentColor = False
    TabOrder = 0
    OnClick = cbSyncOnClick
  end
  object rgSyncPatient: TRadioGroup
    Left = 32
    Top = 164
    Width = 283
    Height = 67
    Caption = '[Not Selectable]     Synchronize with CPRS Patient'
    Color = clSilver
    Enabled = False
    Font.Charset = DEFAULT_CHARSET
    Font.Color = clWindowText
    Font.Height = -11
    Font.Name = 'MS Sans Serif'
    Font.Style = []
    ItemIndex = 0
    Items.Strings = (
      'Always change to selected Patient'
      'Prompt when Patient changes')
    ParentColor = False
    ParentFont = False
    TabOrder = 1
  end
  object rgSyncProc: TRadioGroup
    Left = 32
    Top = 243
    Width = 283
    Height = 67
    Caption = '[Not Selectable]     Synchronize with Patient'#39's Note/Exam'
    Color = clSilver
    Enabled = False
    Items.Strings = (
      'Always change to selected Note/Exam'
      'Prompt when Note/Exam changes')
    ParentColor = False
    TabOrder = 2
  end
  object rgSyncHandle: TRadioGroup
    Left = 22
    Top = 323
    Width = 283
    Height = 67
    Caption = '[Not Selectable]      Multiple copies CPRS Running : '
    Color = clSilver
    Enabled = False
    Items.Strings = (
      'Accept messages from any CPRS Window'
      'Prompt if message is from different CPRS Window')
    ParentColor = False
    TabOrder = 3
  end
  object BitBtn1: TBitBtn
    Left = 78
    Top = 36
    Width = 75
    Height = 25
    TabOrder = 4
    Kind = bkOK
  end
  object BitBtn2: TBitBtn
    Left = 176
    Top = 36
    Width = 75
    Height = 25
    TabOrder = 5
    Kind = bkCancel
  end
  object Timer1: TTimer
    Enabled = False
    Interval = 500
    OnTimer = Timer1Timer
    Left = 274
    Top = 318
  end
end
