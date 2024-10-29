object frmDateRange: TfrmDateRange
  Left = 709
  Top = 194
  BorderStyle = bsToolWindow
  Caption = 'Select a Date Range'
  ClientHeight = 173
  ClientWidth = 361
  Color = clBtnFace
  Font.Charset = DEFAULT_CHARSET
  Font.Color = clWindowText
  Font.Height = -11
  Font.Name = 'MS Sans Serif'
  Font.Style = []
  OldCreateOrder = False
  Position = poOwnerFormCenter
  OnShow = FormShow
  PixelsPerInch = 96
  TextHeight = 13
  object lbDtFrom: TLabel
    Left = 10
    Top = 48
    Width = 23
    Height = 13
    Caption = 'From'
  end
  object lbDtTo: TLabel
    Left = 175
    Top = 48
    Width = 13
    Height = 13
    Caption = 'To'
  end
  object lbMaxRange: TLabel
    Left = 10
    Top = 12
    Width = 189
    Height = 13
    Caption = '<Maximum Selectable Range: __ Days>'
  end
  object lbCurrentRange: TLabel
    Left = 10
    Top = 87
    Width = 122
    Height = 13
    Caption = 'Selected Range: __ Days'
  end
  object calDtFrom: TDateTimePicker
    Left = 45
    Top = 45
    Width = 112
    Height = 21
    Date = 40009.892389317130000000
    Time = 40009.892389317130000000
    TabOrder = 0
    OnChange = calDtFromChange
  end
  object calDtTo: TDateTimePicker
    Left = 201
    Top = 45
    Width = 115
    Height = 21
    Date = 40010.258899016200000000
    Time = 40010.258899016200000000
    TabOrder = 1
    OnChange = calDtToChange
  end
  object pnlBottom: TPanel
    Left = 0
    Top = 117
    Width = 361
    Height = 56
    Align = alBottom
    BevelOuter = bvNone
    TabOrder = 2
    object BitBtn1: TBitBtn
      Left = 74
      Top = 11
      Width = 75
      Height = 25
      Caption = 'OK'
      Default = True
      ModalResult = 1
      TabOrder = 0
      Glyph.Data = {
        DE010000424DDE01000000000000760000002800000024000000120000000100
        0400000000006801000000000000000000001000000000000000000000000000
        80000080000000808000800000008000800080800000C0C0C000808080000000
        FF0000FF000000FFFF00FF000000FF00FF00FFFF0000FFFFFF00333333333333
        3333333333333333333333330000333333333333333333333333F33333333333
        00003333344333333333333333388F3333333333000033334224333333333333
        338338F3333333330000333422224333333333333833338F3333333300003342
        222224333333333383333338F3333333000034222A22224333333338F338F333
        8F33333300003222A3A2224333333338F3838F338F33333300003A2A333A2224
        33333338F83338F338F33333000033A33333A222433333338333338F338F3333
        0000333333333A222433333333333338F338F33300003333333333A222433333
        333333338F338F33000033333333333A222433333333333338F338F300003333
        33333333A222433333333333338F338F00003333333333333A22433333333333
        3338F38F000033333333333333A223333333333333338F830000333333333333
        333A333333333333333338330000333333333333333333333333333333333333
        0000}
      NumGlyphs = 2
    end
    object BitBtn2: TBitBtn
      Left = 206
      Top = 11
      Width = 75
      Height = 25
      TabOrder = 1
      Kind = bkCancel
    end
  end
end
