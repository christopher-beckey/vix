object frmCapTIUOptions: TfrmCapTIUOptions
  Left = 481
  Top = 360
  BorderIcons = [biSystemMenu]
  BorderStyle = bsDialog
  Caption = 'Progress Note List Options:'
  ClientHeight = 304
  ClientWidth = 525
  Color = clBtnFace
  Font.Charset = DEFAULT_CHARSET
  Font.Color = clWindowText
  Font.Height = -11
  Font.Name = 'MS Sans Serif'
  Font.Style = []
  OldCreateOrder = False
  PixelsPerInch = 96
  TextHeight = 13
  object GroupBox2: TGroupBox
    Left = 6
    Top = 62
    Width = 245
    Height = 169
    Caption = 'Date Range'
    TabOrder = 4
    object Label1: TLabel
      Left = 14
      Top = 104
      Width = 29
      Height = 13
      Caption = 'From: '
    end
    object Label2: TLabel
      Left = 124
      Top = 104
      Width = 25
      Height = 13
      Caption = 'To  : '
    end
    object lbStaticDateFrom: TLabel
      Left = 46
      Top = 104
      Width = 32
      Height = 13
      Caption = '<from>'
    end
    object lbStaticDateTo: TLabel
      Left = 148
      Top = 104
      Width = 21
      Height = 13
      Caption = '<to>'
    end
    object rgrpMthsback: TRadioGroup
      Left = 10
      Top = 12
      Width = 225
      Height = 83
      Hint = 'Relative Date Ranges are relative to the current date.'
      Columns = 2
      Items.Strings = (
        '1 month'
        '2 months'
        '6 months'
        '1 year'
        '2 year'
        'All Dates')
      TabOrder = 0
      OnClick = rgrpMthsbackClick
    end
  end
  object GroupBox1: TGroupBox
    Left = 6
    Top = 6
    Width = 243
    Height = 51
    Caption = 'Number of Signed Notes to Return'
    TabOrder = 3
    object cmbnumber: TEdit
      Left = 10
      Top = 18
      Width = 33
      Height = 21
      Hint = 
        'Click a number to return that many Signed Notes, or enter a numb' +
        'er in the edit box.'
      TabOrder = 0
    end
  end
  object BitBtn1: TBitBtn
    Left = 157
    Top = 256
    Width = 75
    Height = 25
    TabOrder = 0
    Kind = bkOK
  end
  object BitBtn2: TBitBtn
    Left = 293
    Top = 256
    Width = 75
    Height = 25
    TabOrder = 1
    Kind = bkCancel
  end
  object btnSelectDates: TBitBtn
    Left = 14
    Top = 194
    Width = 115
    Height = 23
    Hint = 
      'Select a Static Date Range i.e. From: 1/1/2003 To: 12/31/2003 fo' +
      'r the Year 2003'
    Caption = 'Date Range'
    TabOrder = 2
    OnClick = btnSelectDatesClick
    Glyph.Data = {
      8E050000424D8E05000000000000360000002800000018000000130000000100
      1800000000005805000000000000000000000000000000000000D8E9ECD8E9EC
      D8E9ECD8E9ECD8E9ECD8E9ECD8E9ECD8E9ECD8E9ECD8E9ECD8E9ECD8E9ECD8E9
      ECD8E9ECD8E9ECD8E9ECD8E9ECD8E9ECD8E9ECD8E9ECD8E9ECD8E9ECD8E9ECD8
      E9ECD8E9EC99A8AC000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      00000000000000D8E9ECD8E9EC99A8ACFFFFFFFFFFFFD8E9ECFFFFFFFFFFFFD8
      E9ECFFFFFFFFFFFFD8E9ECFFFFFFFFFFFFD8E9ECFFFFFFFFFFFFD8E9ECFFFFFF
      FFFFFFD8E9ECFFFFFFFFFFFF000000D8E9ECD8E9EC99A8ACFFFFFFFFFFFFD8E9
      ECFFFFFFFFFFFFD8E9ECFFFFFFFFFFFFD8E9ECFFFFFFFFFFFFD8E9ECFFFFFFFF
      FFFFD8E9ECFFFFFFFFFFFFD8E9ECFFFFFFFFFFFF000000D8E9ECD8E9EC99A8AC
      D8E9ECD8E9ECD8E9ECD8E9ECD8E9ECD8E9ECD8E9ECD8E9ECD8E9ECD8E9ECD8E9
      ECD8E9ECD8E9ECD8E9ECD8E9ECD8E9ECD8E9ECD8E9ECD8E9ECD8E9EC000000D8
      E9ECD8E9EC99A8ACFFFFFFFFFFFFD8E9ECFFFFFFFFFFFFD8E9ECFFFFFFFFFFFF
      D8E9ECFFFFFFFFFFFFD8E9EC0000FF0000FFD8E9ECFFFFFFFFFFFFD8E9ECFFFF
      FFFFFFFF000000D8E9ECD8E9EC99A8ACFFFFFFFFFFFFD8E9ECFFFFFFFFFFFFD8
      E9ECFFFFFFFFFFFFD8E9ECFFFFFFFFFFFFD8E9EC0000FF0000FFD8E9ECFFFFFF
      FFFFFFD8E9ECFFFFFFFFFFFF000000D8E9ECD8E9EC99A8ACD8E9ECD8E9ECD8E9
      ECD8E9ECD8E9ECD8E9ECD8E9ECD8E9ECD8E9ECD8E9ECD8E9ECD8E9ECD8E9ECD8
      E9ECD8E9ECD8E9ECD8E9ECD8E9ECD8E9ECD8E9EC000000D8E9ECD8E9EC99A8AC
      FFFFFFFFFFFFD8E9EC0000FF0000FFD8E9ECFFFFFFFFFFFFD8E9ECFFFFFFFFFF
      FFD8E9ECFFFFFFFFFFFFD8E9ECFFFFFFFFFFFFD8E9ECFFFFFFFFFFFF000000D8
      E9ECD8E9EC99A8ACFFFFFFFFFFFFD8E9EC0000FF0000FFD8E9ECFFFFFFFFFFFF
      D8E9ECFFFFFFFFFFFFD8E9ECFFFFFFFFFFFFD8E9ECFFFFFFFFFFFFD8E9ECFFFF
      FFFFFFFF000000D8E9ECD8E9EC99A8ACD8E9ECD8E9ECD8E9ECD8E9ECD8E9ECD8
      E9ECD8E9ECD8E9ECD8E9ECD8E9ECD8E9ECD8E9ECD8E9ECD8E9ECD8E9ECD8E9EC
      D8E9ECD8E9ECD8E9ECD8E9EC000000D8E9ECD8E9EC99A8ACFFFFFFFFFFFFD8E9
      ECFFFFFFFFFFFFD8E9ECFFFFFFFFFFFFD8E9ECFFFFFFFFFFFFD8E9ECFFFFFFFF
      FFFFD8E9ECFFFFFFFFFFFFD8E9ECFFFFFFFFFFFF000000D8E9ECD8E9EC99A8AC
      FFFFFFFFFFFFD8E9ECFFFFFFFFFFFFD8E9ECFFFFFFFFFFFFD8E9ECFFFFFFFFFF
      FFD8E9ECFFFFFFFFFFFFD8E9ECFFFFFFFFFFFFD8E9ECFFFFFFFFFFFF000000D8
      E9ECD8E9EC99A8ACD8E9ECD8E9ECD8E9ECD8E9ECD8E9ECD8E9ECD8E9ECD8E9EC
      D8E9ECD8E9ECD8E9ECD8E9ECD8E9ECD8E9ECD8E9ECD8E9ECD8E9ECD8E9ECD8E9
      ECD8E9EC000000D8E9ECD8E9EC99A8AC80000080000080000080000080000080
      0000800000800000800000800000800000800000800000800000800000800000
      800000800000800000800000000000D8E9ECD8E9EC99A8AC8000008000008000
      0080000080000099A8AC99A8AC99A8AC99A8AC99A8AC99A8AC99A8AC99A8AC99
      A8AC99A8AC99A8AC800000800000800000800000000000D8E9ECD8E9EC99A8AC
      8000008000008000008000008000008000008000008000008000008000008000
      00800000800000800000800000800000800000800000800000800000000000D8
      E9ECD8E9EC99A8AC99A8AC99A8AC99A8AC99A8AC99A8AC99A8AC99A8AC99A8AC
      99A8AC99A8AC99A8AC99A8AC99A8AC99A8AC99A8AC99A8AC99A8AC99A8AC99A8
      AC99A8AC99A8ACD8E9ECD8E9ECD8E9ECD8E9ECD8E9ECD8E9ECD8E9ECD8E9ECD8
      E9ECD8E9ECD8E9ECD8E9ECD8E9ECD8E9ECD8E9ECD8E9ECD8E9ECD8E9ECD8E9EC
      D8E9ECD8E9ECD8E9ECD8E9ECD8E9ECD8E9EC}
  end
  object GroupBox3: TGroupBox
    Left = 268
    Top = 6
    Width = 245
    Height = 99
    Caption = 'Progress Note Listing'
    TabOrder = 5
    object Image1: TImage
      Left = 202
      Top = 52
      Width = 19
      Height = 23
      Picture.Data = {
        07544269746D617036040000424D360400000000000036000000280000001000
        0000100000000100200000000000000400000000000000000000000000000000
        0000FF00FF00FF00FF00FF00FF00FF00FF00FF00FF00FF00FF00FF00FF00FF00
        FF00FF00FF00FF00FF00FF00FF00FF00FF00FF00FF00FF00FF00FF00FF00FF00
        FF00FF00FF00FF00FF00FF00FF00FF00FF00FF00FF00FF00FF00FF00FF00FF00
        FF00FF00FF00FF00FF00FF00FF00FF00FF00FF00FF00FF00FF00FF00FF00FF00
        FF00FF00FF00FF00FF00FF00FF00FF00FF00FF00FF00FF00FF00FF00FF00FF00
        FF00FF00FF00FF00FF00FF00FF00FF00FF00FF00FF00FF00FF00FF00FF00FF00
        FF00FF00FF00FF00FF00FF00FF00FF00FF00FF00FF0000800000FF00FF00FF00
        FF00FF00FF00FF00FF00FF00FF00FF00FF00FF00FF00FF00FF00FF00FF00FF00
        FF00FF00FF00FF00FF00FF00FF00FF00FF000080000000FF000000800000FF00
        FF00FF00FF00FF00FF00FF00FF00FF00FF00FF00FF00FF00FF00FF00FF00FF00
        FF00FF00FF00FF00FF00FF00FF000080000000FF000000FF000000800000FF00
        FF00FF00FF00FF00FF00FF00FF00FF00FF00FF00FF00FF00FF00FF00FF00FF00
        FF00FF00FF00FF00FF00FF00FF0000FF0000FF00FF00FF00FF0000FF00000080
        0000FF00FF00FF00FF00FF00FF00FF00FF00FF00FF00FF00FF00FF00FF00FF00
        FF00FF00FF00FF00FF00FF00FF00FF00FF00FF00FF00FF00FF0000FF00000080
        0000FF00FF00FF00FF00FF00FF00FF00FF00FF00FF00FF00FF00FF00FF00FF00
        FF00FF00FF00FF00FF00FF00FF00FF00FF00FF00FF00FF00FF00FF00FF0000FF
        000000800000FF00FF00FF00FF00FF00FF00FF00FF00FF00FF00FF00FF00FF00
        FF00FF00FF00FF00FF00FF00FF00FF00FF00FF00FF00FF00FF00FF00FF0000FF
        000000800000FF00FF00FF00FF00FF00FF00FF00FF00FF00FF00FF00FF00FF00
        FF00FF00FF00FF00FF00FF00FF00FF00FF00FF00FF00FF00FF00FF00FF00FF00
        FF0000FF000000800000FF00FF00FF00FF00FF00FF00FF00FF00FF00FF00FF00
        FF00FF00FF00FF00FF00FF00FF00FF00FF00FF00FF00FF00FF00FF00FF00FF00
        FF0000FF000000800000FF00FF00FF00FF00FF00FF00FF00FF00FF00FF00FF00
        FF00FF00FF00FF00FF00FF00FF00FF00FF00FF00FF00FF00FF00FF00FF00FF00
        FF00FF00FF00FF00FF00FF00FF00FF00FF00FF00FF00FF00FF00FF00FF00FF00
        FF00FF00FF00FF00FF00FF00FF00FF00FF00FF00FF00FF00FF00FF00FF00FF00
        FF00FF00FF00FF00FF00FF00FF00FF00FF00FF00FF00FF00FF00FF00FF00FF00
        FF00FF00FF00FF00FF00FF00FF00FF00FF00FF00FF00FF00FF00FF00FF00FF00
        FF00FF00FF00FF00FF00FF00FF00FF00FF00FF00FF00FF00FF00FF00FF00FF00
        FF00FF00FF00FF00FF00FF00FF00FF00FF00FF00FF00FF00FF00FF00FF00FF00
        FF00FF00FF00FF00FF00FF00FF00FF00FF00FF00FF00FF00FF00FF00FF00FF00
        FF00}
      Transparent = True
    end
    object Image2: TImage
      Left = 78
      Top = 54
      Width = 25
      Height = 21
      Picture.Data = {
        07544269746D617036030000424D360300000000000036000000280000001000
        0000100000000100180000000000000300000000000000000000000000000000
        0000FFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFF
        FFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFF0000000000000000000000
        00000000000000000000000000000000FFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFF
        FFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFF
        FFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFF0000FFFFFFFF0000FFFF
        FFFFFFFFFFFFFF000000FFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFF
        FFFFFFFFFFFFFFFFFF0000FFFFFFFFFFFFFFFFFFFFFFFF000000000000FFFFFF
        FFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFF0000FFFFFFFF0000FFFF
        FFFFFFFFFFFFFF000000000000FFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFF
        FFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFF00000000FFFF000000
        FFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFF
        FFFFFFFFFFFFFF00000000FFFF000000FFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFF
        FFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFF00000000FFFF
        000000FFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFF
        FFFFFFFFFFFFFFFFFFFF00000000FFFF000000FFFFFFFFFFFFFFFFFFFFFFFFFF
        FFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFF000000
        00FFFF000000FFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFF
        FFFFFFFFFFFFFFFFFFFFFFFFFF00000000FFFF000000FFFFFFFFFFFFFFFFFFFF
        FFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFF
        000000C0C0C0000000FFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFF
        FFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFF0000000000FF000000FFFFFFFFFFFFFF
        FFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFF
        0000000000FF0000FF000000FFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFF
        FFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFF000000000000FFFFFFFFFFFFFF
        FFFF}
      Transparent = True
    end
    object Label3: TLabel
      Left = 10
      Top = 48
      Width = 63
      Height = 35
      AutoSize = False
      Caption = 'Unsigned UnCosigned  '
      WordWrap = True
    end
    object Label4: TLabel
      Left = 142
      Top = 48
      Width = 53
      Height = 31
      AutoSize = False
      Caption = 'Signed (Complete)'
      WordWrap = True
    end
    object cbUseStatusIcons: TCheckBox
      Left = 8
      Top = 18
      Width = 177
      Height = 17
      Hint = '<check> to Display Status Icons in the Progress Note List.'
      Caption = 'Display Status Icons in list'
      TabOrder = 0
    end
  end
  object GroupBox4: TGroupBox
    Left = 270
    Top = 138
    Width = 245
    Height = 93
    Caption = 'Note Information (main window)'
    TabOrder = 6
    object Image3: TImage
      Left = 14
      Top = 58
      Width = 55
      Height = 19
      Hint = 
        'Electronically Filed.  Note is closed without need of Physician ' +
        'Signature'
      Picture.Data = {
        07544269746D617036090000424D360900000000000036000000280000002F00
        0000100000000100180000000000000900000000000000000000000000000000
        0000FFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFF
        FFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFF
        FFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFF
        FFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFF
        FFFFFFFFFFFFFFFFFFFFFFFFFFFFFF000000FFFFFFFFFFFFFFFFFFFFFFFFFFFF
        FFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFF
        FFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFF
        FFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFF
        FFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFF00
        0000FFFFFFFFFFFFFFFFFFFFFFFF000000000000000000000000000000000000
        0000000000000000004040004040004040004040004040004040004040004040
        0040400040400040400040400040400040400040400040400040400040400040
        4000404000404000404000404000404000404000404000404000404000404000
        FFFFFFFFFFFFFFFFFFFFFFFFFFFFFF000000FFFFFFFFFFFFFFFFFF0000000000
        00B1DBDEB1DBDEB1DBDEB1DBDEB1DBDEB1DBDEB1DBDEB1DBDEB1DBDEB1DBDEB1
        DBDEB1DBDEB1DBDEB1DBDEB1DBDEB1DBDEB1DBDEB1DBDEB1DBDEB1DBDEB1DBDE
        B1DBDEB1DBDEB1DBDEB1DBDEB1DBDEB1DBDEB1DBDEB1DBDEB1DBDEB1DBDEB1DB
        DEB1DBDEB1DBDEB1DBDEB1DBDE000000000000FFFFFFFFFFFFFFFFFFFFFFFF00
        0000FFFFFFFFFFFFFFFFFF000000B1DBDEB1DBDEB1DBDE000000000000000000
        000000000000B1DBDEB1DBDEB1DBDEB1DBDEB1DBDEB1DBDEB1DBDEB1DBDE0000
        00B1DBDEB1DBDEB1DBDEB1DBDEB1DBDE000000B1DBDE000000B1DBDEB1DBDE00
        0000000000B1DBDEB1DBDEB1DBDE000000000000000000B1DBDEB1DBDEB1DBDE
        000000408080FFFFFFFFFFFFFFFFFF000000FFFFFFFFFFFFFFFFFF000000B1DB
        DEB1DBDEB1DBDE000000B1DBDEB1DBDEB1DBDEB1DBDEB1DBDEB1DBDEB1DBDEB1
        DBDEB1DBDEB1DBDEB1DBDEB1DBDE000000B1DBDEB1DBDEB1DBDEB1DBDEB1DBDE
        000000B1DBDE000000B1DBDE000000B1DBDEB1DBDEB1DBDEB1DBDE000000B1DB
        DEB1DBDE000000B1DBDEB1DBDEB1DBDE000000408080FFFFFFFFFFFFFFFFFF00
        0000FFFFFFFFFFFFFFFFFF000000B1DBDEB1DBDEB1DBDE000000B1DBDEB1DBDE
        B1DBDEB1DBDEB1DBDEB1DBDEB1DBDE000000000000B1DBDEB1DBDEB1DBDE0000
        00B1DBDEB1DBDEB1DBDEB1DBDEB1DBDE000000B1DBDE000000B1DBDE00000000
        0000000000000000B1DBDE000000B1DBDEB1DBDE000000B1DBDEB1DBDEB1DBDE
        000000408080FFFFFFFFFFFFFFFFFF000000FFFFFFFFFFFFFFFFFF000000B1DB
        DEB1DBDEB1DBDE000000000000000000000000B1DBDEB1DBDEB1DBDEB1DBDEB1
        DBDEB1DBDEB1DBDEB1DBDEB1DBDE000000000000000000000000B1DBDEB1DBDE
        000000B1DBDE000000B1DBDE000000B1DBDEB1DBDE000000B1DBDE000000B1DB
        DEB1DBDE000000B1DBDEB1DBDEB1DBDE000000408080FFFFFFFFFFFFFFFFFF00
        0000FFFFFFFFFFFFFFFFFF000000B1DBDEB1DBDEB1DBDE000000B1DBDEB1DBDE
        B1DBDEB1DBDEB1DBDEB1DBDEB1DBDEB1DBDEB1DBDEB1DBDEB1DBDEB1DBDE0000
        00B1DBDEB1DBDEB1DBDEB1DBDEB1DBDE000000B1DBDE000000B1DBDEB1DBDE00
        0000000000B1DBDEB1DBDEB1DBDE000000000000000000B1DBDEB1DBDEB1DBDE
        000000408080FFFFFFFFFFFFFFFFFF000000FFFFFFFFFFFFFFFFFF000000B1DB
        DEB1DBDEB1DBDE000000B1DBDEB1DBDEB1DBDEB1DBDEB1DBDEB1DBDEB1DBDEB1
        DBDEB1DBDEB1DBDEB1DBDEB1DBDE000000B1DBDEB1DBDEB1DBDEB1DBDEB1DBDE
        B1DBDEB1DBDE000000B1DBDEB1DBDEB1DBDEB1DBDEB1DBDEB1DBDEB1DBDEB1DB
        DEB1DBDE000000B1DBDEB1DBDEB1DBDE000000408080FFFFFFFFFFFFFFFFFF00
        0000FFFFFFFFFFFFFFFFFF000000B1DBDEB1DBDEB1DBDE000000000000000000
        000000000000B1DBDEB1DBDEB1DBDEB1DBDEB1DBDEB1DBDEB1DBDEB1DBDE0000
        00000000000000000000000000B1DBDE000000B1DBDE000000B1DBDEB1DBDEB1
        DBDEB1DBDEB1DBDEB1DBDEB1DBDEB1DBDEB1DBDE000000B1DBDEB1DBDEB1DBDE
        000000408080FFFFFFFFFFFFFFFFFF000000FFFFFFFFFFFFFFFFFF0000000000
        00B1DBDEB1DBDEB1DBDEB1DBDEB1DBDEB1DBDEB1DBDEB1DBDEB1DBDEB1DBDEB1
        DBDEB1DBDEB1DBDEB1DBDEB1DBDEB1DBDEB1DBDEB1DBDEB1DBDEB1DBDEB1DBDE
        B1DBDEB1DBDEB1DBDEB1DBDEB1DBDEB1DBDEB1DBDEB1DBDEB1DBDEB1DBDEB1DB
        DEB1DBDEB1DBDEB1DBDEB1DBDE000000000000408080FFFFFFFFFFFFFFFFFF00
        0000FFFFFFFFFFFFFFFFFFFFFFFF000000000000000000000000000000000000
        0000000000000000000000004040004040004040004040004040004040004040
        0040400040400040400040400040400040400040400040400040400040400040
        4000404000404000404000404000404000404000404000404000404000404000
        408080408080FFFFFFFFFFFFFFFFFF000000FFFFFFFFFFFFFFFFFFFFFFFF4080
        8040808040808040808040808040808040808040808040808040808040808040
        8080408080408080408080408080408080408080408080408080408080408080
        4080804080804080804080804080804080804080804080804080804080804080
        80408080408080408080408080408080408080FFFFFFFFFFFFFFFFFFFFFFFF00
        0000FFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFF
        FFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFF
        FFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFF
        FFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFF
        FFFFFFFFFFFFFFFFFFFFFFFFFFFFFF000000FFFFFFFFFFFFFFFFFFFFFFFFFFFF
        FFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFF
        FFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFF
        FFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFF
        FFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFF00
        0000}
      Transparent = True
    end
    object Image4: TImage
      Left = 76
      Top = 58
      Width = 55
      Height = 19
      Hint = 'Note is Signed.'
      Picture.Data = {
        07544269746D617076090000424D760900000000000036000000280000003100
        0000100000000100180000000000400900000000000000000000000000000000
        0000FFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFF
        FFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFF
        FFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFF
        FFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFF
        FFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFF00FFFFFFFFFFFFFFFFFFFF
        FFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFF
        FFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFF
        FFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFF
        FFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFF
        FFFFFFFFFFFFFFFFFF00FFFFFFFFFFFFFFFFFF00000000000000000000000000
        0000000000000000000000000000000000000000000000000000000000000000
        0000000000000000000000000000000000000000000000000000000000000000
        00000000000000000000000000000000000000000000FFFFFFFFFFFFFFFFFFFF
        FFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFF00FFFF
        FFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFF
        FFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFF
        FFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFF
        FFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFF008000FFFFFFFFFFFFFFFFFFFF
        FFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFF00FFFFFFFFFFFFFFFFFFFFFFFFFFFF
        FFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFF00000000000000
        0000FFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFF
        FFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFF
        FFFFFFFF00800000FF00008000FFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFF
        FFFFFFFFFF00FFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFF
        FFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFF000000FFFFFFFF
        FFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFF
        FFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFF00800000FF0000FF000080
        00FFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFF00FFFFFFFFFFFF
        FFFFFFFFFFFFFFFFFFFFFFFFFFFFFF000000000000000000FFFFFFFFFFFF0000
        00FFFFFFFFFFFF000000000000000000FFFFFF000000FFFFFFFFFFFF000000FF
        FFFFFFFFFF000000000000FFFFFFFFFFFFFFFFFF000000000000000000FFFFFF
        FFFFFFFFFFFFFFFFFF00FF00FFFFFFFFFFFF00FF00008000FFFFFFFFFFFFFFFF
        FFFFFFFFFFFFFFFFFFFFFFFFFF00FFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFF
        FFFFFF000000FFFFFFFFFFFFFFFFFF000000FFFFFF000000FFFFFF000000FFFF
        FFFFFFFF000000FFFFFF000000FFFFFFFFFFFF000000FFFFFF000000FFFFFFFF
        FFFFFFFFFFFFFFFF000000FFFFFFFFFFFF000000FFFFFFFFFFFFFFFFFFFFFFFF
        FFFFFFFFFFFF00FF00008000FFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFF
        FF00FFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFF
        FFFFFF000000FFFFFF000000FFFFFF000000FFFFFFFFFFFF000000FFFFFF0000
        00FFFFFFFFFFFF000000FFFFFF000000000000000000000000FFFFFF000000FF
        FFFFFFFFFF000000FFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFF00FF00
        008000FFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFF00FFFFFFFFFFFFFFFFFFFF
        FFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFF000000000000000000FFFFFFFFFFFF
        000000FFFFFF000000FFFFFFFFFFFF000000FFFFFF000000FFFFFFFFFFFF0000
        00FFFFFF000000FFFFFFFFFFFF000000FFFFFF000000FFFFFFFFFFFF000000FF
        FFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFF00FF00008000FFFFFFFFFFFFFFFFFF
        FFFFFFFFFFFFFFFFFF00FFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFF
        FFFF000000FFFFFFFFFFFFFFFFFFFFFFFFFFFFFF000000FFFFFFFFFFFF000000
        000000000000FFFFFF000000000000000000FFFFFFFFFFFFFFFFFF0000000000
        00FFFFFFFFFFFFFFFFFF000000000000000000FFFFFFFFFFFFFFFFFFFFFFFFFF
        FFFFFFFFFFFFFFFF00FF00008000FFFFFFFFFFFFFFFFFFFFFFFFFFFFFF00FFFF
        FFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFF000000FFFFFFFF
        FFFFFFFFFF000000FFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFF
        FFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFF
        FFFFFFFFFFFFFF000000FFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFF00FF0000
        8000FFFFFFFFFFFFFFFFFFFFFFFFFFFFFF00FFFFFFFFFFFFFFFFFFFFFFFFFFFF
        FFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFF000000000000000000FFFFFFFFFFFF00
        0000FFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFF
        FFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFF000000FFFF
        FFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFF00FF00008000FFFFFFFFFFFFFF
        FFFFFFFFFF00FFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFF
        FFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFF
        FFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFF
        FFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFF
        FFFFFFFFFFFFFF00FF00008000FFFFFFFFFFFFFFFFFFFFFFFF00FFFFFFFFFFFF
        FFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFF
        FFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFF
        FFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFF
        FFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFF
        FFFFFFFFFFFFFFFFFFFFFFFFFF00FFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFF
        FFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFF
        FFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFF
        FFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFF
        FFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFF
        FF00}
      Transparent = True
    end
    object Image5: TImage
      Left = 138
      Top = 58
      Width = 55
      Height = 19
      Hint = 'Note is UnSigned'
      Picture.Data = {
        07544269746D617036060000424D360600000000000036000000280000002000
        0000100000000100180000000000000600000000000000000000000000000000
        0000FFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFF
        FFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFF
        FFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFF
        FFFFFFFFFF000000000000000000000000000000000000000000000000000000
        0000000000000000000000000000000000000000000000000000000000000000
        00000000000000000000000000000000000000000000000000FFFFFFFFFFFFFF
        FFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFF
        FFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFF
        FFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFF
        FFFFFFFFFFFF0000FFFFFFFF0000FFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFF
        FFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFF
        FFFFFFFFFFFFFF000000FFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFF
        FFFFFFFFFFFFFFFFFF0000FFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFF
        FFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFF
        FFFFFFFFFFFFFF000000000000FFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFF
        FFFFFFFFFFFF0000FFFFFFFF0000FFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFF
        FFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFF
        FFFFFFFFFFFFFF000000000000FFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFF
        FFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFF
        FFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFF
        FFFFFFFFFFFFFF00000000FFFF000000FFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFF
        FFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFF
        FFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFF
        FFFFFFFFFFFFFF00000000FFFF000000FFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFF
        FFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFF
        FFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFF
        FFFFFFFFFFFFFFFFFFFF00000000FFFF000000FFFFFFFFFFFFFFFFFFFFFFFFFF
        FFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFF
        FFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFF
        FFFFFFFFFFFFFFFFFFFF00000000FFFF000000FFFFFFFFFFFFFFFFFFFFFFFFFF
        FFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFF
        FFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFF
        FFFFFFFFFFFFFFFFFFFFFFFFFF00000000FFFF000000FFFFFFFFFFFFFFFFFFFF
        FFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFF
        FFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFF
        FFFFFFFFFFFFFFFFFFFFFFFFFF00000000FFFF000000FFFFFFFFFFFFFFFFFFFF
        FFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFF
        FFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFF
        FFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFF000000C0C0C0000000FFFFFFFFFFFFFF
        FFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFF
        FFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFF
        FFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFF0000000000FF000000FFFFFFFFFFFFFF
        FFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFF
        FFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFF
        FFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFF0000000000FF0000FF000000FFFFFFFF
        FFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFF
        FFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFF
        FFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFF000000000000FFFFFFFFFFFFFF
        FFFF}
      Transparent = True
    end
    object cbUseNoteStatusIcons: TCheckBox
      Left = 10
      Top = 28
      Width = 167
      Height = 17
      Caption = 'Display Note-Status Icons'
      TabOrder = 0
    end
  end
  object ToolBar1: TToolBar
    Left = 62
    Top = 24
    Width = 161
    Height = 25
    Hint = 
      'Click a number to return that many Signed Notes, or enter a numb' +
      'er in the edit box.'
    Align = alNone
    ButtonHeight = 21
    ButtonWidth = 40
    Caption = 'ToolBar1'
    EdgeInner = esNone
    EdgeOuter = esNone
    Flat = True
    ShowCaptions = True
    TabOrder = 7
    object ToolButton1: TToolButton
      Left = 0
      Top = 0
      Caption = '    50   '
      ImageIndex = 0
      OnClick = ToolButton1Click
    end
    object ToolButton2: TToolButton
      Left = 40
      Top = 0
      Caption = '100'
      ImageIndex = 1
      OnClick = ToolButton2Click
    end
    object ToolButton3: TToolButton
      Left = 80
      Top = 0
      Caption = '200'
      ImageIndex = 2
      OnClick = ToolButton3Click
    end
    object ToolButton4: TToolButton
      Left = 120
      Top = 0
      Caption = '500'
      ImageIndex = 3
      OnClick = ToolButton4Click
    end
  end
end