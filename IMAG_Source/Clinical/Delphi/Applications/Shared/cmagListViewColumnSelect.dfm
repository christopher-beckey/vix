object frmColumnSelect: TfrmColumnSelect
  Left = 514
  Top = 325
  BorderIcons = [biSystemMenu]
  Caption = 'Column Selector'
  ClientHeight = 312
  ClientWidth = 217
  Color = clBtnFace
  Constraints.MinHeight = 200
  Constraints.MinWidth = 225
  Font.Charset = DEFAULT_CHARSET
  Font.Color = clWindowText
  Font.Height = -11
  Font.Name = 'MS Sans Serif'
  Font.Style = []
  OldCreateOrder = False
  Position = poScreenCenter
  OnCreate = FormCreate
  PixelsPerInch = 96
  TextHeight = 13
  object Label1: TLabel
    Left = 0
    Top = 0
    Width = 217
    Height = 13
    Align = alTop
    ExplicitWidth = 3
  end
  object chlistColumns: TCheckListBox
    Left = 36
    Top = 16
    Width = 121
    Height = 97
    ItemHeight = 13
    TabOrder = 0
  end
  object Panel1: TPanel
    Left = 0
    Top = 239
    Width = 217
    Height = 73
    Align = alBottom
    BevelOuter = bvNone
    TabOrder = 1
    DesignSize = (
      217
      73)
    object btnApply: TBitBtn
      Left = 23
      Top = 40
      Width = 75
      Height = 25
      Anchors = [akLeft, akBottom]
      Caption = 'Apply'
      Default = True
      TabOrder = 0
      OnClick = btnApplyClick
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
    object btnClose: TBitBtn
      Left = 118
      Top = 8
      Width = 75
      Height = 25
      Anchors = [akTop, akRight]
      Caption = 'Close'
      TabOrder = 1
      OnClick = btnCloseClick
      Kind = bkCancel
    end
    object btnOK: TBitBtn
      Left = 23
      Top = 8
      Width = 75
      Height = 25
      TabOrder = 2
      OnClick = btnOKClick
      Kind = bkOK
    end
    object btnAll: TBitBtn
      Left = 118
      Top = 40
      Width = 75
      Height = 25
      Anchors = [akRight, akBottom]
      Caption = '&All'
      ModalResult = 1
      TabOrder = 3
      OnClick = btnAllClick
      Glyph.Data = {
        F2010000424DF201000000000000760000002800000024000000130000000100
        0400000000007C01000000000000000000001000000000000000000000000000
        80000080000000808000800000008000800080800000C0C0C000808080000000
        FF0000FF000000FFFF00FF000000FF00FF00FFFF0000FFFFFF00333334433333
        3333333333388F3333333333000033334224333333333333338338F333333333
        0000333422224333333333333833338F33333333000033422222243333333333
        83333338F3333333000034222A22224333333338F33F33338F33333300003222
        A2A2224333333338F383F3338F33333300003A2A222A222433333338F8333F33
        38F33333000034A22222A22243333338833333F3338F333300004222A2222A22
        2433338F338F333F3338F3330000222A3A2224A22243338F3838F338F3338F33
        0000A2A333A2224A2224338F83338F338F3338F300003A33333A2224A2224338
        333338F338F3338F000033333333A2224A2243333333338F338F338F00003333
        33333A2224A2233333333338F338F83300003333333333A2224A333333333333
        8F338F33000033333333333A222433333333333338F338F30000333333333333
        A224333333333333338F38F300003333333333333A223333333333333338F8F3
        000033333333333333A3333333333333333383330000}
      NumGlyphs = 2
    end
  end
end
