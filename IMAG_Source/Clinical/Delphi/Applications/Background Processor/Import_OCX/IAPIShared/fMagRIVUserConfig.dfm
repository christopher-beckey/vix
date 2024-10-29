object frmMagRIVUserConfig: TfrmMagRIVUserConfig
  Left = 589
  Top = 382
  BorderIcons = [biSystemMenu]
  BorderStyle = bsSingle
  Caption = 'Remote Image Views Configuration'
  ClientHeight = 283
  ClientWidth = 490
  Color = clBtnFace
  Font.Charset = DEFAULT_CHARSET
  Font.Color = clWindowText
  Font.Height = -11
  Font.Name = 'MS Sans Serif'
  Font.Style = []
  OldCreateOrder = False
  Position = poScreenCenter
  OnClose = FormClose
  OnCreate = FormCreate
  PixelsPerInch = 96
  TextHeight = 13
  object grpUserPreferences: TGroupBox
    Left = 8
    Top = 200
    Width = 465
    Height = 129
    Caption = 'Remote Image Views User Preferences:'
    Color = clBtnFace
    Font.Charset = DEFAULT_CHARSET
    Font.Color = clWindowText
    Font.Height = -11
    Font.Name = 'MS Sans Serif'
    Font.Style = [fsBold]
    ParentColor = False
    ParentFont = False
    TabOrder = 1
    Visible = False
    object chkEnableRIVAuto: TCheckBox
      Left = 8
      Top = 24
      Width = 281
      Height = 25
      Hint = 'Enables/Disables Remote Image Views Auto-Connection'
      Caption = 'Remote Image Views Auto-Connect Enabled'
      Checked = True
      ParentShowHint = False
      ShowHint = True
      State = cbChecked
      TabOrder = 0
      OnClick = chkEnableRIVAutoClick
    end
    object chkVISNOnly: TCheckBox
      Left = 8
      Top = 48
      Width = 265
      Height = 25
      Hint = 
        'Enables/Disables Remote Image Views connecting to sites in the l' +
        'ocal VISN only.'
      Caption = 'Only Auto-Connect to Sites in Local VISN'
      ParentShowHint = False
      ShowHint = True
      TabOrder = 1
    end
    object chkHideEmptySites: TCheckBox
      Left = 8
      Top = 72
      Width = 345
      Height = 25
      Hint = 
        'Hides sites on the toolbar where the patient has visited but doe' +
        's not have any images.'
      Caption = 'Hide '#39'Patient Active'#39' Sites With 0 Images on Toolbar'
      ParentShowHint = False
      ShowHint = True
      TabOrder = 2
    end
    object chkHideDisconnectedSites: TCheckBox
      Left = 8
      Top = 96
      Width = 361
      Height = 25
      Caption = 'Hide Disconnected Sites For Selected Patient on Toolbar'
      TabOrder = 3
    end
  end
  object grpStatus: TGroupBox
    Left = 0
    Top = 0
    Width = 490
    Height = 241
    Caption = 'Remote Site Status:'
    Font.Charset = DEFAULT_CHARSET
    Font.Color = clWindowText
    Font.Height = -11
    Font.Name = 'MS Sans Serif'
    Font.Style = [fsBold]
    ParentFont = False
    TabOrder = 0
    object lstSites: TListView
      Left = 8
      Top = 24
      Width = 473
      Height = 177
      Columns = <
        item
          Caption = 'Site Name'
          Width = 150
        end
        item
          Caption = 'Site Code'
          Width = 70
        end
        item
          Caption = 'Status'
          Width = 115
        end
        item
          Caption = 'StatusCode'
          Width = 1
        end
        item
          Caption = 'Image Count'
          Width = 90
        end>
      GridLines = True
      ReadOnly = True
      RowSelect = True
      TabOrder = 0
      ViewStyle = vsReport
      OnClick = lstSitesClick
      OnColumnClick = lstSitesColumnClick
      OnCompare = lstSitesCompare
    end
    object btnDisconnectAll: TButton
      Left = 280
      Top = 208
      Width = 99
      Height = 25
      Hint = 
        'Disconnect all connected remote brokers (including active and in' +
        'active sites)'
      Caption = 'Disconnect All'
      ParentShowHint = False
      ShowHint = True
      TabOrder = 1
      OnClick = btnDisconnectAllClick
    end
    object btnDisconnect: TButton
      Left = 184
      Top = 208
      Width = 75
      Height = 25
      Hint = 'Disconnect the selected remote site.'
      Caption = 'Disconnect'
      ParentShowHint = False
      ShowHint = True
      TabOrder = 3
      OnClick = btnDisconnectClick
    end
    object btnConnect: TButton
      Left = 88
      Top = 208
      Width = 75
      Height = 25
      Hint = 'Reconnect the selected remote site.'
      Caption = 'Connect'
      ParentShowHint = False
      ShowHint = True
      TabOrder = 2
      OnClick = btnConnectClick
    end
  end
  object btnClose: TBitBtn
    Left = 208
    Top = 248
    Width = 75
    Height = 25
    Hint = 'Close this dialog'
    Caption = '&Close'
    ParentShowHint = False
    ShowHint = True
    TabOrder = 2
    OnClick = BitBtn1Click
    Glyph.Data = {
      DE010000424DDE01000000000000760000002800000024000000120000000100
      0400000000006801000000000000000000001000000000000000000000000000
      80000080000000808000800000008000800080800000C0C0C000808080000000
      FF0000FF000000FFFF00FF000000FF00FF00FFFF0000FFFFFF00388888888877
      F7F787F8888888888333333F00004444400888FFF444448888888888F333FF8F
      000033334D5007FFF4333388888888883338888F0000333345D50FFFF4333333
      338F888F3338F33F000033334D5D0FFFF43333333388788F3338F33F00003333
      45D50FEFE4333333338F878F3338F33F000033334D5D0FFFF43333333388788F
      3338F33F0000333345D50FEFE4333333338F878F3338F33F000033334D5D0FFF
      F43333333388788F3338F33F0000333345D50FEFE4333333338F878F3338F33F
      000033334D5D0EFEF43333333388788F3338F33F0000333345D50FEFE4333333
      338F878F3338F33F000033334D5D0EFEF43333333388788F3338F33F00003333
      4444444444333333338F8F8FFFF8F33F00003333333333333333333333888888
      8888333F00003333330000003333333333333FFFFFF3333F00003333330AAAA0
      333333333333888888F3333F00003333330000003333333333338FFFF8F3333F
      0000}
    NumGlyphs = 2
  end
  object btnSave: TBitBtn
    Left = 168
    Top = 248
    Width = 75
    Height = 25
    Hint = 'Save remote image views user preferences and close this dialog.'
    Caption = 'Save'
    ParentShowHint = False
    ShowHint = True
    TabOrder = 3
    Visible = False
    OnClick = btnSaveClick
    Glyph.Data = {
      DE010000424DDE01000000000000760000002800000024000000120000000100
      0400000000006801000000000000000000001000000010000000000000000000
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
end
