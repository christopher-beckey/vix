object frmRIVConfig: TfrmRIVConfig
  Left = 353
  Top = 223
  Width = 833
  Height = 433
  Caption = 'frmRIVConfig'
  Color = clBtnFace
  Font.Charset = DEFAULT_CHARSET
  Font.Color = clWindowText
  Font.Height = -11
  Font.Name = 'MS Sans Serif'
  Font.Style = []
  OldCreateOrder = False
  PixelsPerInch = 96
  TextHeight = 13
  object grpConnected: TGroupBox
    Left = 0
    Top = 0
    Width = 281
    Height = 145
    Caption = 'Connected Sites'
    Font.Charset = DEFAULT_CHARSET
    Font.Color = clWindowText
    Font.Height = -11
    Font.Name = 'MS Sans Serif'
    Font.Style = [fsBold]
    ParentFont = False
    TabOrder = 0
    object lstConnected: TListBox
      Left = 8
      Top = 16
      Width = 265
      Height = 89
      ItemHeight = 13
      TabOrder = 0
    end
    object btnDisconnect: TButton
      Left = 96
      Top = 112
      Width = 75
      Height = 25
      Caption = 'Disconnect'
      TabOrder = 1
      OnClick = btnDisconnectClick
    end
  end
  object btnClose: TButton
    Left = 96
    Top = 304
    Width = 75
    Height = 25
    Caption = 'Close'
    TabOrder = 1
    OnClick = btnCloseClick
  end
  object grpDisconnected: TGroupBox
    Left = 0
    Top = 152
    Width = 281
    Height = 145
    Caption = 'Disconnected Sites'
    Font.Charset = DEFAULT_CHARSET
    Font.Color = clWindowText
    Font.Height = -11
    Font.Name = 'MS Sans Serif'
    Font.Style = [fsBold]
    ParentFont = False
    TabOrder = 2
    object lstDisconnected: TListBox
      Left = 8
      Top = 16
      Width = 265
      Height = 89
      ItemHeight = 13
      TabOrder = 0
    end
    object btnConnect: TButton
      Left = 96
      Top = 112
      Width = 75
      Height = 25
      Caption = 'Connect'
      TabOrder = 1
      OnClick = btnConnectClick
    end
  end
  object grpSiteDetails: TGroupBox
    Left = 288
    Top = 0
    Width = 521
    Height = 201
    Caption = 'Current Remote Sites'
    Font.Charset = DEFAULT_CHARSET
    Font.Color = clWindowText
    Font.Height = -11
    Font.Name = 'MS Sans Serif'
    Font.Style = [fsBold]
    ParentFont = False
    TabOrder = 3
    object lstSites: TListView
      Left = 8
      Top = 16
      Width = 505
      Height = 177
      Columns = <
        item
          Caption = 'Site Code'
          MinWidth = 100
        end
        item
          Caption = 'Site Name'
        end
        item
          Caption = 'Status'
        end
        item
          Caption = 'Always Connect'
        end
        item
          Caption = 'Never Connect'
        end>
      TabOrder = 0
      ViewStyle = vsReport
    end
  end
  object grpNeverConnectSites: TGroupBox
    Left = 288
    Top = 208
    Width = 441
    Height = 121
    Caption = 'Sites to Never Connecto to'
    Font.Charset = DEFAULT_CHARSET
    Font.Color = clWindowText
    Font.Height = -11
    Font.Name = 'MS Sans Serif'
    Font.Style = [fsBold]
    ParentFont = False
    TabOrder = 4
    object Label1: TLabel
      Left = 8
      Top = 24
      Width = 65
      Height = 25
      AutoSize = False
      Caption = 'Site Code:'
      Font.Charset = DEFAULT_CHARSET
      Font.Color = clWindowText
      Font.Height = -11
      Font.Name = 'MS Sans Serif'
      Font.Style = [fsBold]
      ParentFont = False
    end
    object edtSiteCode: TEdit
      Left = 72
      Top = 24
      Width = 73
      Height = 21
      TabOrder = 0
    end
    object btnLookupSiteName: TButton
      Left = 152
      Top = 24
      Width = 89
      Height = 25
      Caption = 'Lookup Name'
      TabOrder = 1
      OnClick = btnLookupSiteNameClick
    end
    object edtSiteName: TEdit
      Left = 240
      Top = 24
      Width = 193
      Height = 21
      Enabled = False
      TabOrder = 2
    end
    object btnAddNeverConnectSite: TButton
      Left = 120
      Top = 56
      Width = 185
      Height = 25
      Caption = 'Add Site to Never Connect to'
      TabOrder = 3
    end
  end
end
