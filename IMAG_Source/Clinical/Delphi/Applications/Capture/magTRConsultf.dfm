object magTRConsult: TmagTRConsult
  Left = 290
  Top = 144
  HelpContext = 10040
  BorderIcons = [biSystemMenu]
  Caption = 'TeleReader Consult Requests'
  ClientHeight = 426
  ClientWidth = 632
  Color = clBtnFace
  Constraints.MinHeight = 422
  Constraints.MinWidth = 480
  Font.Charset = DEFAULT_CHARSET
  Font.Color = clWindowText
  Font.Height = -11
  Font.Name = 'MS Sans Serif'
  Font.Style = []
  Menu = MainMenu1
  OldCreateOrder = False
  Position = poScreenCenter
  OnCreate = FormCreate
  OnDestroy = FormDestroy
  OnShow = FormShow
  DesignSize = (
    632
    426)
  PixelsPerInch = 96
  TextHeight = 13
  object lblPatName: TLabel
    Left = 0
    Top = 0
    Width = 632
    Height = 13
    Align = alTop
    Caption = 'lblPatName'
    ExplicitWidth = 54
  end
  object lblRequests: TLabel
    Left = 0
    Top = 13
    Width = 632
    Height = 13
    Align = alTop
    Alignment = taCenter
    Caption = 'Select a Consult Request'
    ExplicitWidth = 120
  end
  object StatusBar1: TStatusBar
    Left = 0
    Top = 407
    Width = 632
    Height = 19
    Anchors = []
    Panels = <
      item
        Width = 50
      end
      item
        Width = 50
      end>
  end
  object pnlhidden: TPanel
    Left = 65
    Top = 463
    Width = 161
    Height = 101
    BevelOuter = bvNone
    TabOrder = 3
    TabStop = True
    Visible = False
  end
  object lvRequests: TListView
    Left = 8
    Top = 34
    Width = 614
    Height = 316
    Anchors = [akLeft, akTop, akRight, akBottom]
    Columns = <>
    HideSelection = False
    ReadOnly = True
    RowSelect = True
    TabOrder = 0
    ViewStyle = vsReport
    OnChange = lvRequestsChange
    OnColumnClick = lvRequestsColumnClick
    OnCompare = lvRequestsCompare
    OnDblClick = lvRequestsDblClick
  end
  object btnOKCP: TBitBtn
    Left = 473
    Top = 361
    Width = 75
    Height = 25
    Anchors = [akRight, akBottom]
    Caption = 'OK'
    Default = True
    Enabled = False
    TabOrder = 1
    OnClick = btnOKCPClick
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
  object btnCancel: TBitBtn
    Left = 552
    Top = 361
    Width = 75
    Height = 25
    Anchors = [akRight, akBottom]
    TabOrder = 2
    Kind = bkCancel
  end
  object MainMenu1: TMainMenu
    Left = 368
    Top = 200
    object File1: TMenuItem
      Caption = '&File'
      object Exit1: TMenuItem
        Caption = 'E&xit'
        OnClick = Exit1Click
      end
    end
    object Options1: TMenuItem
      Caption = '&Options'
      object RefreshRequests1: TMenuItem
        Caption = 'Refresh Requests'
        OnClick = RefreshRequests1Click
      end
      object ResizeGrid1: TMenuItem
        Caption = 'Fit Columns to text'
        OnClick = ResizeGrid1Click
      end
    end
  end
  object lvRequestsutils: TMagLVutils
    ListView = lvRequests
    Left = 476
    Top = 279
  end
end
