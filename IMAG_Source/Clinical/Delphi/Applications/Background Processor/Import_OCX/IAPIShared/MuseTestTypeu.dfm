object MuseTestType: TMuseTestType
  Left = 697
  Top = 649
  HelpContext = 217
  BorderStyle = bsDialog
  Caption = 'EKG list Options'
  ClientHeight = 345
  ClientWidth = 535
  Color = clBtnFace
  Font.Charset = DEFAULT_CHARSET
  Font.Color = clWindowText
  Font.Height = -11
  Font.Name = 'MS Sans Serif'
  Font.Style = []
  OldCreateOrder = True
  Position = poScreenCenter
  OnShow = FormShow
  PixelsPerInch = 96
  TextHeight = 13
  object GroupBox1: TGroupBox
    Left = 19
    Top = 6
    Width = 497
    Height = 211
    Caption = 'Data Type'
    Font.Charset = DEFAULT_CHARSET
    Font.Color = clBlack
    Font.Height = -13
    Font.Name = 'MS Sans Serif'
    Font.Style = []
    ParentFont = False
    TabOrder = 0
    object Label3: TLabel
      Left = 12
      Top = 173
      Width = 437
      Height = 18
      AutoSize = False
      Caption = 
        'You can select an individule type of test to display, or select ' +
        #39'All Tests'#39' '
      Font.Charset = DEFAULT_CHARSET
      Font.Color = clBlack
      Font.Height = -11
      Font.Name = 'Arial'
      Font.Style = [fsBold]
      ParentFont = False
      WordWrap = True
    end
    object RadioButton1: TRadioButton
      Left = 9
      Top = 15
      Width = 186
      Height = 17
      Caption = 'Resting ECG'
      TabOrder = 0
    end
    object RadioButton2: TRadioButton
      Left = 9
      Top = 33
      Width = 186
      Height = 17
      Caption = 'Pace'
      TabOrder = 1
    end
    object RadioButton3: TRadioButton
      Left = 9
      Top = 50
      Width = 186
      Height = 17
      Caption = 'Hires'
      TabOrder = 2
    end
    object RadioButton4: TRadioButton
      Left = 9
      Top = 68
      Width = 186
      Height = 17
      Caption = 'Stress'
      TabOrder = 3
    end
    object RadioButton5: TRadioButton
      Left = 9
      Top = 85
      Width = 186
      Height = 17
      Caption = 'Holter'
      TabOrder = 4
    end
    object RadioButton6: TRadioButton
      Left = 9
      Top = 103
      Width = 186
      Height = 17
      Caption = 'Cardiac Cath'
      TabOrder = 5
    end
    object RadioButton7: TRadioButton
      Left = 9
      Top = 120
      Width = 186
      Height = 17
      Caption = 'Cardiac Ultrassound'
      TabOrder = 6
    end
    object RadioButton8: TRadioButton
      Left = 9
      Top = 138
      Width = 186
      Height = 17
      Caption = 'Defib'
      TabOrder = 7
    end
    object RadioButton9: TRadioButton
      Left = 206
      Top = 12
      Width = 199
      Height = 17
      Caption = 'Discharge Summary'
      TabOrder = 8
    end
    object RadioButton10: TRadioButton
      Left = 206
      Top = 30
      Width = 199
      Height = 17
      Caption = 'History and Physicals'
      TabOrder = 9
    end
    object RadioButton11: TRadioButton
      Left = 206
      Top = 48
      Width = 199
      Height = 17
      Caption = 'Event Recorder Info'
      TabOrder = 10
    end
    object RadioButton12: TRadioButton
      Left = 206
      Top = 66
      Width = 199
      Height = 17
      Caption = 'Nuclear Imaging'
      TabOrder = 11
    end
    object RadioButton13: TRadioButton
      Left = 206
      Top = 84
      Width = 199
      Height = 17
      Caption = 'STC'
      TabOrder = 12
    end
    object RadioButton14: TRadioButton
      Left = 206
      Top = 102
      Width = 199
      Height = 17
      Caption = 'Electrophysiology'
      TabOrder = 13
    end
    object RadioButton15: TRadioButton
      Left = 206
      Top = 120
      Width = 199
      Height = 17
      Caption = 'Chest Pain assessM'
      TabOrder = 14
    end
    object RadioButton16: TRadioButton
      Left = 206
      Top = 150
      Width = 199
      Height = 17
      Caption = 'All Tests  (default)'
      Checked = True
      TabOrder = 15
      TabStop = True
    end
  end
  object Panel1: TPanel
    Left = 19
    Top = 225
    Width = 497
    Height = 76
    TabOrder = 1
    object Label2: TLabel
      Left = 20
      Top = 46
      Width = 26
      Height = 13
      Caption = 'Date:'
      Enabled = False
      Visible = False
    end
    object Label4: TLabel
      Left = 130
      Top = 46
      Width = 26
      Height = 13
      Caption = 'Time:'
      Enabled = False
      Visible = False
    end
    object Label1: TLabel
      Left = 281
      Top = 44
      Width = 34
      Height = 14
      Caption = 'Factor'
      Font.Charset = DEFAULT_CHARSET
      Font.Color = clBlack
      Font.Height = -11
      Font.Name = 'Arial'
      Font.Style = [fsBold]
      ParentFont = False
    end
    object Label6: TLabel
      Left = 354
      Top = 20
      Width = 85
      Height = 13
      Caption = 'Pages per Screen'
      Enabled = False
      Visible = False
    end
    object lbZoom: TLabel
      Left = 400
      Top = 42
      Width = 20
      Height = 13
      Caption = '10%'
    end
    object meDate: TMaskEdit
      Left = 52
      Top = 42
      Width = 70
      Height = 21
      Enabled = False
      EditMask = '!99/99/00;1;_'
      MaxLength = 8
      TabOrder = 0
      Text = '  /  /  '
      Visible = False
    end
    object meTime: TMaskEdit
      Left = 166
      Top = 42
      Width = 52
      Height = 21
      Enabled = False
      EditMask = '!90:00:00;1;_'
      MaxLength = 8
      TabOrder = 1
      Text = '  :  :  '
      Visible = False
    end
    object rbFrom: TRadioButton
      Left = 18
      Top = 24
      Width = 193
      Height = 17
      Caption = 'Start accumulation of tests from:'
      Enabled = False
      TabOrder = 2
      Visible = False
      OnClick = rbFromClick
    end
    object rbRecent: TRadioButton
      Left = 18
      Top = 6
      Width = 175
      Height = 17
      Caption = 'Start with Most recent tests'
      Checked = True
      Enabled = False
      TabOrder = 3
      TabStop = True
      Visible = False
      OnClick = rbRecentClick
    end
    object SpinEdit2: TSpinEdit
      Left = 450
      Top = 16
      Width = 35
      Height = 22
      Enabled = False
      MaxValue = 5
      MinValue = 1
      TabOrder = 4
      Value = 1
      Visible = False
    end
    object TrackBar1: TTrackBar
      Left = 320
      Top = 36
      Width = 80
      Height = 31
      Hint = 'EKG Image will be Zoomed IN/OUT by this percentage.'
      Max = 9
      Min = 1
      Position = 1
      TabOrder = 5
      OnChange = TrackBar1Change
    end
    object bbZoomin: TBitBtn
      Left = 225
      Top = 39
      Width = 25
      Height = 25
      Hint = 'Zoom IN '
      TabOrder = 6
      OnClick = bbZoominClick
      Glyph.Data = {
        76010000424D7601000000000000760000002800000020000000100000000100
        0400000000000001000000000000000000001000000010000000000000000000
        800000800000008080008000000080008000808000007F7F7F00BFBFBF000000
        FF0000FF000000FFFF00FF000000FF00FF00FFFF0000FFFFFF00333333333333
        33033333333333333F7F3333333333333000333333333333F777333333333333
        000333333333333F777333333333333000333333333333F77733333333333300
        033333333FFF3F777333333700073B703333333F7773F77733333307777700B3
        33333377333777733333307F8F8F7033333337F333F337F3333377F8F9F8F773
        3333373337F3373F3333078F898F870333337F33F7FFF37F333307F99999F703
        33337F377777337F3333078F898F8703333373F337F33373333377F8F9F8F773
        333337F3373337F33333307F8F8F70333333373FF333F7333333330777770333
        333333773FF77333333333370007333333333333777333333333}
      NumGlyphs = 2
    end
    object bbZoomOut: TBitBtn
      Left = 251
      Top = 39
      Width = 25
      Height = 25
      Hint = 'Zoom OUT'
      TabOrder = 7
      OnClick = bbZoomOutClick
      Glyph.Data = {
        76010000424D7601000000000000760000002800000020000000100000000100
        0400000000000001000000000000000000001000000010000000000000000000
        800000800000008080008000000080008000808000007F7F7F00BFBFBF000000
        FF0000FF000000FFFF00FF000000FF00FF00FFFF0000FFFFFF00333333333333
        33033333333333333F7F3333333333333000333333333333F777333333333333
        000333333333333F777333333333333000333333333333F77733333333333300
        033333333FFF3F777333333700073B703333333F7773F77733333307777700B3
        333333773337777333333078F8F87033333337F3333337F33333778F8F8F8773
        333337333333373F333307F8F8F8F70333337F33FFFFF37F3333078999998703
        33337F377777337F333307F8F8F8F703333373F3333333733333778F8F8F8773
        333337F3333337F333333078F8F870333333373FF333F7333333330777770333
        333333773FF77333333333370007333333333333777333333333}
      NumGlyphs = 2
    end
    object cbShowDottedGridDlg: TCheckBox
      Left = 227
      Top = 8
      Width = 225
      Height = 17
      Caption = 'Show "Dotted Grid" dialog when printing'
      TabOrder = 8
      OnClick = cbShowDottedGridDlgClick
    end
    object rgGridPrintType: TRadioGroup
      Left = 8
      Top = 8
      Width = 185
      Height = 57
      Caption = 'Print Grid Type'
      TabOrder = 9
    end
    object rbSolid: TRadioButton
      Left = 16
      Top = 24
      Width = 169
      Height = 17
      Caption = 'Print grid with solid line'
      TabOrder = 10
      OnClick = rbSolidClick
    end
    object rbDotted: TRadioButton
      Left = 16
      Top = 40
      Width = 169
      Height = 17
      Caption = 'Print grid with dotted line'
      TabOrder = 11
      OnClick = rbDottedClick
    end
  end
  object BitBtn1: TBitBtn
    Left = 230
    Top = 312
    Width = 75
    Height = 25
    TabOrder = 2
    Kind = bkOK
  end
  object forceanexit: TCheckBox
    Left = 437
    Top = 314
    Width = 97
    Height = 17
    Caption = 'forceanexit'
    TabOrder = 3
    Visible = False
  end
  object BitBtn2: TBitBtn
    Left = 441
    Top = 301
    Width = 91
    Height = 25
    Hint = 'Force MUSE EKG Display to close.'
    Caption = 'Force Exit'
    TabOrder = 4
    Visible = False
    OnClick = BitBtn2Click
    Glyph.Data = {
      BE060000424DBE06000000000000360400002800000024000000120000000100
      0800000000008802000000000000000000000001000000010000000000000000
      80000080000000808000800000008000800080800000C0C0C000C0DCC000F0CA
      A600000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      000000000000000000000000000000000000F0FBFF00A4A0A000808080000000
      FF0000FF000000FFFF00FF000000FF00FF00FFFF0000FFFFFF0003F8F8F8F8F8
      F8F8F8F80707FF07FF07F807FFF8F8F8F8F8F8F8F8F8F8030303030303FF0404
      0404040000F8F8F8FFFFFF0404040404F8F8F8F8F8F8F8F8F8F8FF030303FFFF
      F8FF0303030304FD05000007FFFFFF0403030303F8F8F8F8F8F8F8F8F8F80303
      03F8F8F8F8FF030303030405FD0500FFFFFFFF040303030303030303F8FFF8F8
      F8FF030303F8FF0303FF0303030304FD05FD00FFFFFFFF040303030303030303
      F8F807F8F8FF030303F8FF0303FF030303030405FD0500FFFEFFFE0403030303
      03030303F8FFF807F8FF030303F8FF0303FF0303030304FD05FD00FFFFFFFF04
      0303030303030303F8F807F8F8FF030303F8FF0303FF030303030405FD0500FF
      FEFFFE040303030303030303F8FFF807F8FF030303F8FF0303FF0303030304FD
      05FD00FFFFFFFF040303030303030303F8F807F8F8FF030303F8FF0303FF0303
      03030405FD0500FFFEFFFE040303030303030303F8FFF807F8FF030303F8FF03
      03FF0303030304FD05FD00FEFFFEFF040303030303030303F8F807F8F8FF0303
      03F8FF0303FF030303030405FD0500FFFEFFFE040303030303030303F8FFF807
      F8FF030303F8FF0303FF0303030304FD05FD00FEFFFEFF040303030303030303
      F8F807F8F8FF030303F8FF0303FF030303030404040404040404040403030303
      03030303F8FFF8FFF8FFFFFFFFF8FF0303FF0303030303030303030303030303
      0303030303030303F8F8F8F8F8F8F8F8F8F8030303FF03030303030300000000
      000003030303030303030303030303FFFFFFFFFFFF03030303FF030303030303
      00FAFAFAFA00030303030303030303030303F8F8F8F8F8F8FF03030303FF0303
      03030303000000000000030303030303030303030303F8FFFFFFFFF8FF030303
      03FF}
    NumGlyphs = 2
  end
end
