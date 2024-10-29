object frmUserPref: TfrmUserPref
  Left = 0
  Top = 0
  HelpContext = 10209
  BorderIcons = [biSystemMenu]
  BorderStyle = bsSingle
  Caption = 'User Preferences'
  ClientHeight = 431
  ClientWidth = 362
  Color = clBtnFace
  Font.Charset = ANSI_CHARSET
  Font.Color = clWindowText
  Font.Height = -11
  Font.Name = 'Arial'
  Font.Style = []
  KeyPreview = True
  OldCreateOrder = True
  Position = poDesigned
  OnClose = FormClose
  OnCreate = FormCreate
  OnDestroy = FormDestroy
  OnShow = FormShow
  DesignSize = (
    362
    431)
  PixelsPerInch = 96
  TextHeight = 14
  object lbActCtrl: TLabel
    Left = 9
    Top = 360
    Width = 41
    Height = 14
    Caption = 'lbActCtrl'
    Visible = False
  end
  object cbViewJBox: TCheckBox
    Left = 208
    Top = 191
    Width = 165
    Height = 17
    Caption = 'Display Juke Box Abstracts'
    TabOrder = 0
    Visible = False
    OnClick = cbViewJBoxClick
  end
  object btnClose: TBitBtn
    Left = 142
    Top = 390
    Width = 75
    Height = 25
    Anchors = [akRight, akBottom]
    Caption = '&Close'
    TabOrder = 2
    OnClick = btnCloseClick
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
  object btnHelp: TBitBtn
    Left = 254
    Top = 390
    Width = 75
    Height = 25
    HelpContext = 10209
    Anchors = [akRight, akBottom]
    Caption = '&Help'
    TabOrder = 3
    OnClick = btnHelpClick
    Glyph.Data = {
      F6000000424DF600000000000000760000002800000010000000100000000100
      0400000000008000000000000000000000001000000010000000000000000000
      8000008000000080800080000000800080008080000080808000C0C0C0000000
      FF0000FF000000FFFF00FF000000FF00FF00FFFF0000FFFFFF00DDDDDDDDDDDD
      DDDDDDDDDD000DDDDDDDDDDDD0BBB0DDDDDDDDDDDD00077DDDDDDDDDD0BBB077
      77DDDDDDD0BBB0DDD777DDDDD0BBB0777777DD00DD00BB0D777DD0BB0DDD0BB0
      DDDDD0BBB000BBB00DDDDD0BBBBBBB070DDDDD00BBBBB00B0DDDDDD0000000BB
      0DDDDDDD00BBBBB0DDDDDDDDDD00000DDDDDDDDDDDDDDDDDDDDD}
  end
  object btnSave: TBitBtn
    Left = 31
    Top = 390
    Width = 75
    Height = 25
    Anchors = [akRight, akBottom]
    Caption = 'Save'
    Default = True
    TabOrder = 1
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
  object PageControl1: TPageControl
    Left = 5
    Top = 4
    Width = 359
    Height = 353
    ActivePage = tbshAltViewerOptions
    MultiLine = True
    TabOrder = 4
    object TabSheet1: TTabSheet
      Caption = 'Patient Selected'
      ExplicitLeft = 0
      ExplicitTop = 0
      ExplicitWidth = 0
      ExplicitHeight = 0
      DesignSize = (
        351
        305)
      object Label1: TLabel
        Left = 15
        Top = 15
        Width = 292
        Height = 37
        AutoSize = False
        Caption = 
          'Check each window that you want to open when a new patient is se' +
          'lected.'
        WordWrap = True
      end
      object grpPatientSelected: TGroupBox
        Left = 44
        Top = 66
        Width = 260
        Height = 74
        Anchors = [akLeft, akTop, akRight]
        TabOrder = 0
        object cbshowabswindow: TCheckBox
          Left = 13
          Top = 13
          Width = 213
          Height = 17
          Caption = 'Show Abstract window'
          Checked = True
          State = cbChecked
          TabOrder = 0
          OnClick = cbshowabswindowClick
        end
        object cbshowImageListWin: TCheckBox
          Left = 13
          Top = 43
          Width = 217
          Height = 17
          Caption = 'Show Image Listing window'
          Checked = True
          State = cbChecked
          TabOrder = 1
          OnClick = cbshowImageListWinClick
        end
      end
      object grpClin: TGroupBox
        Left = 44
        Top = 170
        Width = 262
        Height = 89
        Anchors = [akLeft, akTop, akRight]
        Caption = 'Clinical Data'
        TabOrder = 1
        object cbShowRadListwin: TCheckBox
          Left = 8
          Top = 16
          Width = 225
          Height = 17
          Caption = 'Show Radiology Exams window'
          TabOrder = 0
          OnClick = cbShowRadListwinClick
        end
        object cbShowMUSE: TCheckBox
          Left = 8
          Top = 40
          Width = 167
          Height = 17
          Caption = 'Show MUSE EKG'#39's'
          TabOrder = 1
          OnClick = cbShowMUSEClick
        end
        object cbShowNotes: TCheckBox
          Left = 8
          Top = 64
          Width = 207
          Height = 17
          Caption = 'Show Progress Notes'
          TabOrder = 2
          OnClick = cbShowNotesClick
        end
      end
    end
    object tbshViewers: TTabSheet
      Caption = 'Abstract && Image Viewers'
      ImageIndex = 1
      ExplicitLeft = 0
      ExplicitTop = 0
      ExplicitWidth = 0
      ExplicitHeight = 0
      object lbShowImages: TLabel
        Left = 28
        Top = 164
        Width = 214
        Height = 14
        Caption = ' Document / Image Viewer  (Non-Radiology) '
      end
      object Label2: TLabel
        Left = 15
        Top = 15
        Width = 281
        Height = 14
        Caption = 'Choose where to display Abstracts and Document Images'
      end
      object cbShowThumbs: TCheckBox
        Left = 31
        Top = 44
        Width = 137
        Height = 17
        Caption = 'Show Abstract Viewer'
        Checked = True
        State = cbChecked
        TabOrder = 0
        OnClick = cbShowThumbsClick
      end
      object rgrpThumbs: TRadioGroup
        Left = 72
        Top = 68
        Width = 200
        Height = 73
        Caption = 'Abstract Viewer'
        ItemIndex = 1
        Items.Strings = (
          ' in Image List Window'
          ' in Separate Window')
        TabOrder = 1
        OnClick = rgrpThumbsClick
      end
      object rgrpImages: TRadioGroup
        Left = 75
        Top = 184
        Width = 200
        Height = 81
        Caption = 'Open Viewer: '
        ItemIndex = 1
        Items.Strings = (
          ' in Image List Window'
          ' in Separate Window')
        TabOrder = 2
      end
    end
    object TabSheet3: TTabSheet
      Caption = 'Remote Image View'
      ImageIndex = 2
      ExplicitLeft = 0
      ExplicitTop = 0
      ExplicitWidth = 0
      ExplicitHeight = 0
      DesignSize = (
        351
        305)
      object Label4: TLabel
        Left = 15
        Top = 15
        Width = 176
        Height = 14
        Caption = 'Choose Remote Image View Options'
      end
      object cbViewRemote: TCheckBox
        Left = 26
        Top = 265
        Width = 170
        Height = 17
        Caption = 'Display Remote Abstracts'
        TabOrder = 1
        OnClick = cbViewRemoteClick
      end
      object grpRIV: TGroupBox
        Left = 8
        Top = 44
        Width = 329
        Height = 207
        Anchors = [akLeft, akTop, akRight]
        Color = clBtnFace
        Font.Charset = ANSI_CHARSET
        Font.Color = clWindowText
        Font.Height = -11
        Font.Name = 'Arial'
        Font.Style = []
        ParentColor = False
        ParentFont = False
        TabOrder = 0
        object Bevel1: TBevel
          Left = 10
          Top = 20
          Width = 309
          Height = 48
        end
        object Bevel2: TBevel
          Left = 10
          Top = 79
          Width = 309
          Height = 48
        end
        object chkEnableRIVAuto: TCheckBox
          Left = 18
          Top = 13
          Width = 140
          Height = 17
          Hint = 'Enables/Disables Remote Image Views Auto-Connection'
          Caption = 'Auto-Connect to the VA'
          Checked = True
          Font.Charset = ANSI_CHARSET
          Font.Color = clWindowText
          Font.Height = -11
          Font.Name = 'Arial'
          Font.Style = []
          ParentFont = False
          ParentShowHint = False
          ShowHint = True
          State = cbChecked
          TabOrder = 0
          OnClick = chkEnableRIVAutoClick
        end
        object chkVISNOnly: TCheckBox
          Left = 44
          Top = 40
          Width = 218
          Height = 17
          Hint = 
            'Enables/Disables Remote Image Views connecting to sites in the l' +
            'ocal VISN only.'
          Caption = 'Only Auto-Connect to Sites in Local VISN'
          ParentShowHint = False
          ShowHint = True
          TabOrder = 1
          OnClick = chkVISNOnlyClick
        end
        object chkHideEmptySites: TCheckBox
          Left = 18
          Top = 145
          Width = 297
          Height = 17
          Hint = 
            'Hides sites on the toolbar where the patient has visited but doe' +
            's not have any images.'
          Caption = 'Hide '#39'Patient Active'#39' Sites With 0 Images on Toolbar'
          ParentShowHint = False
          ShowHint = True
          TabOrder = 2
          OnClick = chkHideEmptySitesClick
        end
        object chkHideDisconnectedSites: TCheckBox
          Left = 18
          Top = 172
          Width = 298
          Height = 17
          Caption = 'Hide Disconnected Sites For Selected Patient on Toolbar'
          TabOrder = 3
          OnClick = chkHideDisconnectedSitesClick
        end
        object chkRIVDoD: TCheckBox
          Left = 18
          Top = 95
          Width = 218
          Height = 17
          Hint = 
            'Enables/Disables Remote Image Views Auto-Connecting Upon Startup' +
            ' to DoD Servers'
          Caption = 'Auto-Connect to the DoD'
          ParentShowHint = False
          ShowHint = True
          TabOrder = 4
          OnClick = chkRIVDoDClick
        end
      end
    end
    object tbshAltViewerOptions: TTabSheet
      Caption = 'Alternate Viewer Options'
      ImageIndex = 3
      ExplicitLeft = 0
      ExplicitTop = 0
      ExplicitWidth = 0
      ExplicitHeight = 0
      object Label3: TLabel
        Left = 15
        Top = 15
        Width = 308
        Height = 14
        Caption = 'Choose what viewer to use for the following image file formats.'
      end
      object grpbxPDFfiles: TGroupBox
        Left = 41
        Top = 196
        Width = 269
        Height = 81
        Caption = 'Adobe PDF Files '
        Font.Charset = ANSI_CHARSET
        Font.Color = clWindowText
        Font.Height = -11
        Font.Name = 'Arial'
        Font.Style = [fsBold]
        ParentFont = False
        TabOrder = 4
        object cbUseAltPDFViewer: TRadioButton
          Left = 24
          Top = 24
          Width = 205
          Height = 17
          Caption = 'Use Alternate PDF Viewer'
          Font.Charset = ANSI_CHARSET
          Font.Color = clWindowText
          Font.Height = -11
          Font.Name = 'Arial'
          Font.Style = []
          ParentFont = False
          TabOrder = 0
          OnClick = cbUseAltPDFViewerClick
        end
        object cbUseFullResForPDF: TRadioButton
          Left = 24
          Top = 51
          Width = 209
          Height = 21
          Caption = 'Use Imaging Viewer'
          Checked = True
          Font.Charset = ANSI_CHARSET
          Font.Color = clWindowText
          Font.Height = -11
          Font.Name = 'Arial'
          Font.Style = []
          ParentFont = False
          TabOrder = 1
          TabStop = True
        end
      end
      object GroupBox1: TGroupBox
        Left = 38
        Top = 54
        Width = 269
        Height = 112
        Caption = 'Video Files'
        Font.Charset = ANSI_CHARSET
        Font.Color = clWindowText
        Font.Height = -11
        Font.Name = 'Arial'
        Font.Style = [fsBold]
        ParentFont = False
        TabOrder = 3
      end
      object cbPlayVideoOnOpen: TCheckBox
        Left = 88
        Top = 138
        Width = 145
        Height = 13
        Caption = 'Play Video when selected'
        TabOrder = 2
      end
      object rbUseMagVideoViewer: TRadioButton
        Left = 64
        Top = 112
        Width = 169
        Height = 17
        Caption = 'Use Imaging Video Player'
        Checked = True
        TabOrder = 1
        TabStop = True
        OnClick = rbUseMagVideoViewerClick
      end
      object rbUseAltVideoViewer: TRadioButton
        Left = 64
        Top = 82
        Width = 181
        Height = 17
        Caption = 'Use Alternate Video player'
        TabOrder = 0
        OnClick = rbUseAltVideoViewerClick
      end
    end
    object tbshtLayoutStyle: TTabSheet
      Caption = 'Layout / Style'
      ImageIndex = 4
      ExplicitLeft = 0
      ExplicitTop = 0
      ExplicitWidth = 0
      ExplicitHeight = 0
      object Label5: TLabel
        Left = 15
        Top = 15
        Width = 204
        Height = 14
        Caption = 'Choose Image List and Tree View options:'
      end
      object GroupBox3: TGroupBox
        Left = 9
        Top = 171
        Width = 328
        Height = 121
        Caption = '  Click items as follows '
        TabOrder = 5
      end
      object cbShowList: TCheckBox
        Left = 40
        Top = 41
        Width = 145
        Height = 17
        Caption = 'Show Image List'
        TabOrder = 0
      end
      object GroupBox2: TGroupBox
        Left = 61
        Top = 65
        Width = 217
        Height = 71
        Caption = ' When Image List is shown'
        TabOrder = 1
        object cbPreviewThumbnail: TCheckBox
          Left = 24
          Top = 21
          Width = 137
          Height = 17
          Caption = 'Preview Abstracts'
          TabOrder = 0
        end
        object cbPreviewReport: TCheckBox
          Left = 24
          Top = 43
          Width = 129
          Height = 17
          Caption = 'Preview Report'
          TabOrder = 1
        end
      end
      object cbShowTree: TCheckBox
        Left = 40
        Top = 144
        Width = 145
        Height = 17
        Caption = 'Show Tree View'
        TabOrder = 2
      end
      object pnlItemClick: TPanel
        Left = 27
        Top = 189
        Width = 301
        Height = 91
        BevelOuter = bvNone
        Caption = 'pnlItemClick'
        TabOrder = 3
        object cbNotAutoSelect: TRadioButton
          Left = 6
          Top = 68
          Width = 265
          Height = 17
          Caption = 'Double-click to open an item (single-click to select)'
          TabOrder = 1
        end
        object cbAutoSelect: TRadioButton
          Left = 6
          Top = 2
          Width = 265
          Height = 17
          Caption = 'Single-click to open an item (point to select)'
          Checked = True
          TabOrder = 0
          TabStop = True
        end
      end
      object rgrpAutoSpeed: TRadioGroup
        Left = 61
        Top = 214
        Width = 217
        Height = 37
        Caption = 'Pointer Speed'
        Columns = 3
        ItemIndex = 0
        Items.Strings = (
          'Slow'
          'Med'
          'Fast')
        TabOrder = 4
      end
    end
    object tbshtAnnotation: TTabSheet
      Caption = 'Annotation'
      ImageIndex = 5
      ExplicitLeft = 0
      ExplicitTop = 0
      ExplicitWidth = 0
      ExplicitHeight = 0
      object lblAnnotMess: TLabel
        Left = 29
        Top = 15
        Width = 179
        Height = 14
        Caption = 'Choose preferences for annotations:'
      end
      object annotShowWithImage: TCheckBox
        Left = 29
        Top = 96
        Width = 267
        Height = 17
        Action = actAnnotAutoShow
        Caption = 'Show Annotations With Image When Displayed'
        State = cbChecked
        TabOrder = 0
      end
      object btnChangeGlobalSetting: TButton
        Left = 104
        Top = 51
        Width = 120
        Height = 25
        Caption = 'Global Attributes'
        TabOrder = 1
        OnClick = btnChangeGlobalSettingClick
      end
      object annotShowStrictRAD: TCheckBox
        Left = 29
        Top = 118
        Width = 249
        Height = 17
        Caption = 'Use Strict Mapping for VistA RAD Annotations'
        TabOrder = 2
        Visible = False
        OnClick = annotShowStrictRADClick
      end
    end
  end
  object actConfigSettings: TActionList
    Left = 152
    Top = 232
    object actAnnotAutoShow: TAction
      Caption = 'actAnnotAutoShow'
      Checked = True
      OnExecute = actAnnotAutoShowExecute
    end
  end
end
