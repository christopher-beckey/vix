object frmVerifyStats: TfrmVerifyStats
  Left = 100
  Top = 143
  Caption = 'QA Review / Image Status Report:'
  ClientHeight = 246
  ClientWidth = 592
  Color = clBtnFace
  Constraints.MinHeight = 300
  Constraints.MinWidth = 600
  Font.Charset = DEFAULT_CHARSET
  Font.Color = clWindowText
  Font.Height = -11
  Font.Name = 'MS Sans Serif'
  Font.Style = []
  Menu = MainMenu1
  OldCreateOrder = False
  Position = poDesigned
  OnClose = FormClose
  OnCreate = FormCreate
  OnDestroy = FormDestroy
  PixelsPerInch = 96
  TextHeight = 13
  object lstReport: TListView
    Left = 0
    Top = 121
    Width = 592
    Height = 125
    Align = alClient
    Columns = <
      item
        Caption = 'User'
        Width = 279
      end
      item
        Caption = 'Status'
        Width = 93
      end
      item
        Caption = 'Entries'
        Width = 46
      end
      item
        Caption = 'Pages'
        Width = 46
      end
      item
        Caption = 'QA %'
        Width = 46
      end>
    ColumnClick = False
    GridLines = True
    ReadOnly = True
    TabOrder = 0
    ViewStyle = vsReport
    OnCustomDrawItem = lstReportCustomDrawItem
  end
  object Panel1: TPanel
    Left = 0
    Top = 0
    Width = 592
    Height = 121
    Align = alTop
    BevelInner = bvLowered
    BevelOuter = bvLowered
    TabOrder = 1
    object lbReportStarted: TLabel
      Left = 24
      Top = 14
      Width = 136
      Height = 13
      Caption = 'This Report Was Started At: '
    end
    object lbReportFlags: TLabel
      Left = 24
      Top = 47
      Width = 63
      Height = 13
      Caption = 'Report Flags:'
    end
    object mmoFlagDesc: TMemo
      Left = 104
      Top = 52
      Width = 489
      Height = 52
      BorderStyle = bsNone
      Color = clBtnFace
      ReadOnly = True
      TabOrder = 0
    end
  end
  object MainMenu1: TMainMenu
    Left = 89
    Top = 91
    object mnuFile1: TMenuItem
      Caption = '&File'
      object mnuSaveAs: TMenuItem
        Action = acSaveAs
        Enabled = False
      end
      object mnuExporttoExcel: TMenuItem
        Action = acOpenInSpreadsheet
        Enabled = False
      end
      object N1: TMenuItem
        Caption = '-'
      end
      object mnuExit: TMenuItem
        Caption = '&Exit'
        OnClick = mnuExitClick
      end
    end
    object Options1: TMenuItem
      Caption = '&Options'
      object N3: TMenuItem
        Caption = '-'
      end
      object mnuActiveForms: TMenuItem
        Caption = 'Active Forms...'
        GroupIndex = 2
        ShortCut = 16471
        OnClick = mnuActiveFormsClick
      end
      object StayonTop1: TMenuItem
        AutoCheck = True
        Caption = 'Stay on Top'
        GroupIndex = 2
        OnClick = StayonTop1Click
      end
    end
    object mnuHelp1: TMenuItem
      Caption = '&Help'
      object mnuImageReports: TMenuItem
        Caption = 'Image &Reports'
        OnClick = mnuImageReportsClick
      end
    end
    object mnuVerifyTEST: TMenuItem
      Caption = 'TEST'
      Visible = False
      object mnushowRPCBrokerTimeLimit: TMenuItem
        Caption = 'showRPCBrokerTimeLimit'
        OnClick = mnushowRPCBrokerTimeLimitClick
      end
      object mnusetPCBrokerTimeLimit: TMenuItem
        Caption = 'setRPCBrokerTimeLimit'
        OnClick = mnusetPCBrokerTimeLimitClick
      end
    end
  end
  object dlgSaveAs: TSaveDialog
    DefaultExt = 'csv'
    Filter = 'CSV (Comma delimited)|*.csv|All Files|*.*'
    Options = [ofOverwritePrompt, ofHideReadOnly, ofPathMustExist, ofNoReadOnlyReturn, ofEnableSizing]
    OptionsEx = [ofExNoPlacesBar]
    Left = 151
    Top = 93
  end
  object aclMain: TActionList
    Left = 120
    Top = 93
    object acRunReport: TAction
      Caption = 'Run Report'
      OnExecute = acRunReportExecute
    end
    object acSaveAs: TAction
      Caption = 'Save As...'
      OnExecute = acSaveAsExecute
    end
    object acOpenInSpreadsheet: TAction
      Caption = 'Open in Spreadsheet'
      OnExecute = acOpenInSpreadsheetExecute
    end
  end
end
