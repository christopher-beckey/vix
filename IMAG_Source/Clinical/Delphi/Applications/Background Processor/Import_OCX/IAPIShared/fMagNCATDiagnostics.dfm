object frmNCATDiagnostics: TfrmNCATDiagnostics
  Left = 0
  Top = 0
  Caption = 'NCAT Diagnostics'
  ClientHeight = 538
  ClientWidth = 1085
  Color = clBtnFace
  Font.Charset = DEFAULT_CHARSET
  Font.Color = clWindowText
  Font.Height = -11
  Font.Name = 'Tahoma'
  Font.Style = []
  OldCreateOrder = False
  OnShow = FormShow
  PixelsPerInch = 96
  TextHeight = 13
  object Splitter1: TSplitter
    Left = 0
    Top = 368
    Width = 1085
    Height = 7
    Cursor = crVSplit
    Align = alTop
    ExplicitTop = 313
  end
  object Panel1: TPanel
    Left = 0
    Top = 497
    Width = 1085
    Height = 41
    Align = alBottom
    BevelOuter = bvLowered
    TabOrder = 0
    object btnRefreshUrlMapList: TBitBtn
      Left = 16
      Top = 8
      Width = 129
      Height = 25
      Caption = 'Refresh Url Map List'
      TabOrder = 0
      OnClick = btnRefreshUrlMapListClick
    end
    object BitBtn1: TBitBtn
      Left = 1000
      Top = 9
      Width = 75
      Height = 25
      TabOrder = 1
      Kind = bkClose
    end
    object edSearch: TEdit
      Left = 303
      Top = 11
      Width = 378
      Height = 21
      TabOrder = 2
    end
    object BitBtn2: TBitBtn
      Left = 222
      Top = 9
      Width = 75
      Height = 25
      Caption = 'Search URL'
      TabOrder = 3
      OnClick = BitBtn2Click
    end
    object BitBtn3: TBitBtn
      Left = 800
      Top = 8
      Width = 75
      Height = 25
      Caption = 'Open iCache'
      TabOrder = 4
      OnClick = BitBtn3Click
    end
  end
  object Panel2: TPanel
    Left = 0
    Top = 0
    Width = 1085
    Height = 368
    Align = alTop
    TabOrder = 1
    object lvUrlMap: TListView
      Left = 1
      Top = 1
      Width = 1083
      Height = 366
      Align = alClient
      Columns = <
        item
          Caption = 'URL'
          Width = 800
        end
        item
          Caption = 'Locally Cached Filename'
          Width = 300
        end>
      GridLines = True
      HideSelection = False
      ReadOnly = True
      RowSelect = True
      TabOrder = 0
      ViewStyle = vsReport
      OnClick = lvUrlMapClick
      OnColumnClick = lvUrlMapColumnClick
      OnKeyUp = lvUrlMapKeyUp
    end
  end
  object Panel3: TPanel
    Left = 0
    Top = 375
    Width = 1085
    Height = 122
    Align = alClient
    BevelOuter = bvLowered
    TabOrder = 2
    object lbTotalEntryCount: TLabel
      Left = 16
      Top = 6
      Width = 65
      Height = 13
      Caption = 'Url Count = 0'
    end
    object lbUrlLength: TLabel
      Left = 151
      Top = 83
      Width = 69
      Height = 13
      Caption = 'Url Length = 0'
    end
    object lbLineNumber: TLabel
      Left = 16
      Top = 25
      Width = 33
      Height = 13
      Caption = 'Line # '
    end
    object mmoUrl: TMemo
      Left = 151
      Top = 6
      Width = 378
      Height = 71
      ScrollBars = ssVertical
      TabOrder = 0
    end
    object mmoMapped: TMemo
      Left = 535
      Top = 6
      Width = 378
      Height = 38
      TabOrder = 1
    end
  end
end
