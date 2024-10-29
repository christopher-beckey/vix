object PatVisitsform: TPatVisitsform
  Left = 856
  Top = 150
  Caption = 'Visit listing'
  ClientHeight = 344
  ClientWidth = 335
  Color = clBtnFace
  Constraints.MinHeight = 350
  Constraints.MinWidth = 325
  Font.Charset = DEFAULT_CHARSET
  Font.Color = clWindowText
  Font.Height = -11
  Font.Name = 'MS Sans Serif'
  Font.Style = []
  OldCreateOrder = False
  OnCreate = FormCreate
  OnDestroy = FormDestroy
  PixelsPerInch = 96
  TextHeight = 13
  object pnlVisits: TPanel
    Left = 0
    Top = 0
    Width = 335
    Height = 325
    Align = alClient
    BevelOuter = bvNone
    TabOrder = 0
    DesignSize = (
      335
      325)
    object Label1: TLabel
      Left = 0
      Top = 25
      Width = 335
      Height = 24
      Align = alTop
      Alignment = taCenter
      AutoSize = False
      Caption = 'Visit Information is required for the selected Request'
      Layout = tlCenter
    end
    object lblSelReq: TLabel
      Left = 0
      Top = 49
      Width = 335
      Height = 23
      Align = alTop
      AutoSize = False
      Caption = '<selected Request info>'
      Color = clHighlight
      Font.Charset = DEFAULT_CHARSET
      Font.Color = clWhite
      Font.Height = -11
      Font.Name = 'MS Sans Serif'
      Font.Style = []
      ParentColor = False
      ParentFont = False
      Layout = tlCenter
    end
    object lblPatName2: TLabel
      Left = 0
      Top = 0
      Width = 335
      Height = 25
      Align = alTop
      AutoSize = False
      Caption = '<patient name>'
      Layout = tlCenter
    end
    object Label3: TLabel
      Left = 5
      Top = 258
      Width = 111
      Height = 21
      Alignment = taCenter
      Anchors = [akLeft, akBottom]
      AutoSize = False
      Caption = 'New Visit Date/Time'
      Layout = tlCenter
    end
    object Label2: TLabel
      Left = 0
      Top = 72
      Width = 335
      Height = 18
      Align = alTop
      AutoSize = False
      Caption = ' Select a Visit'
      Layout = tlBottom
    end
    object edtNewVisitDate: TEdit
      Left = 124
      Top = 259
      Width = 203
      Height = 21
      Anchors = [akLeft, akRight, akBottom]
      TabOrder = 1
      OnExit = edtNewVisitDateExit
      OnKeyDown = edtNewVisitDateKeyDown
    end
    object lvVisits: TListView
      Left = 4
      Top = 96
      Width = 326
      Height = 145
      Anchors = [akLeft, akTop, akRight, akBottom]
      Columns = <>
      HideSelection = False
      ReadOnly = True
      RowSelect = True
      TabOrder = 0
      ViewStyle = vsReport
      OnChange = lvVisitsChange
      OnColumnClick = lvVisitsColumnClick
      OnCompare = lvVisitsCompare
      OnDblClick = lvVisitsDblClick
      OnKeyDown = lvVisitsKeyDown
    end
    object btnOkvisits: TBitBtn
      Left = 63
      Top = 299
      Width = 75
      Height = 25
      Anchors = [akLeft, akBottom]
      Caption = 'OK'
      Enabled = False
      ModalResult = 1
      TabOrder = 2
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
    object btnCancelvisits: TBitBtn
      Left = 205
      Top = 299
      Width = 75
      Height = 25
      Anchors = [akRight, akBottom]
      TabOrder = 3
      Kind = bkCancel
    end
  end
  object StatusBar1: TStatusBar
    Left = 0
    Top = 325
    Width = 335
    Height = 19
    Panels = <
      item
        Width = 50
      end>
  end
  object lvVisitsUtils: TMagLVutils
    ListView = lvVisits
    Left = 240
    Top = 118
  end
  object PopupMenu1: TPopupMenu
    Left = 64
    Top = 120
    object RefreshVisitList1: TMenuItem
      Caption = '&Refresh Visit List'
      OnClick = RefreshVisitList1Click
    end
  end
end
