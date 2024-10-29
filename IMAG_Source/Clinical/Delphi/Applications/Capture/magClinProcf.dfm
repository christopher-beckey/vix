object magClinProc: TmagClinProc
  Left = 379
  Top = 175
  HelpContext = 10105
  BorderIcons = [biSystemMenu]
  Caption = 'Clinical Procedure Requests'
  ClientHeight = 373
  ClientWidth = 472
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
  OnDestroy = FormDestroy
  OnShow = FormShow
  DesignSize = (
    472
    373)
  PixelsPerInch = 96
  TextHeight = 13
  object lblPatName: TLabel
    Left = 0
    Top = 0
    Width = 472
    Height = 13
    Align = alTop
    Caption = 'lblPatName'
    ExplicitWidth = 54
  end
  object lblRequests: TLabel
    Left = 0
    Top = 13
    Width = 472
    Height = 13
    Align = alTop
    Alignment = taCenter
    Caption = 'Select a Clinical Procedure Request'
    ExplicitWidth = 170
  end
  object GroupBox1: TGroupBox
    Left = 15
    Top = 185
    Width = 451
    Height = 106
    Caption = 'Capture Action'
    TabOrder = 8
  end
  object StatusBar1: TStatusBar
    Left = 0
    Top = 354
    Width = 472
    Height = 19
    Anchors = []
    Panels = <
      item
        Width = 50
      end
      item
        Width = 50
      end>
    ExplicitTop = 349
  end
  object pnlhidden: TPanel
    Left = 345
    Top = 455
    Width = 161
    Height = 101
    BevelOuter = bvNone
    TabOrder = 6
    TabStop = True
    Visible = False
    object listnotes: TListBox
      Left = 15
      Top = 6
      Width = 49
      Height = 41
      TabStop = False
      ItemHeight = 13
      TabOrder = 0
      Visible = False
    end
    object cboxCompleteRemoved: TCheckBox
      Left = 19
      Top = 60
      Width = 131
      Height = 16
      TabStop = False
      Caption = 'Mark as Completed Transaction.'
      Enabled = False
      TabOrder = 1
      Visible = False
      OnClick = cboxCompleteRemovedClick
    end
  end
  object lvRequests: TListView
    Left = 10
    Top = 34
    Width = 454
    Height = 139
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
  end
  object btnOKCP: TBitBtn
    Left = 122
    Top = 309
    Width = 75
    Height = 25
    Caption = 'OK'
    Default = True
    Enabled = False
    TabOrder = 4
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
    Left = 270
    Top = 309
    Width = 75
    Height = 25
    TabOrder = 5
    Kind = bkCancel
  end
  object rbCP0: TRadioButton
    Left = 20
    Top = 210
    Width = 436
    Height = 17
    Caption = 'A consent form is being scanned and attached to this procedure.'
    TabOrder = 1
    OnClick = rbCP0Click
  end
  object rbCP1: TRadioButton
    Left = 20
    Top = 235
    Width = 441
    Height = 17
    Caption = 
      'This procedure will not be receiving a report or additional info' +
      'rmation from the instrument.'
    TabOrder = 2
    OnClick = rbCP1Click
  end
  object rbCP2: TRadioButton
    Left = 20
    Top = 260
    Width = 441
    Height = 17
    Caption = 
      'This procedure will be receiving a report or additional data fro' +
      'm the instrument'
    TabOrder = 3
    OnClick = rbCP2Click
  end
  object MainMenu1: TMainMenu
    Left = 122
    Top = 4
    object File1: TMenuItem
      Caption = '&File'
      object mSave: TMenuItem
        Caption = '&Save'
        Enabled = False
      end
      object N1: TMenuItem
        Caption = '-'
      end
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
      object CancelVisitSelection1: TMenuItem
        Caption = 'Cancel Visit Selection'
        OnClick = CancelVisitSelection1Click
      end
      object ResizeGrid1: TMenuItem
        Caption = 'Fit Columns to text'
        OnClick = ResizeGrid1Click
      end
      object N2: TMenuItem
        Caption = '-'
      end
      object PreviewNote1: TMenuItem
        Caption = 'Preview Note'
        Enabled = False
      end
    end
    object Help1: TMenuItem
      Caption = '&Help'
      object mnuclinProc: TMenuItem
        Caption = 'Clinical Procedure list'
        HelpContext = 10105
        OnClick = mnuclinProcClick
      end
    end
  end
  object lvRequestsutils: TMagLVutils
    ListView = lvRequests
    Left = 476
    Top = 279
  end
end
