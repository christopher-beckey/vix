object frmMagReportMgr: TfrmMagReportMgr
  Left = 480
  Top = 225
  Caption = ' QA Statistics Reports'
  ClientHeight = 610
  ClientWidth = 842
  Color = clBtnFace
  Constraints.MinHeight = 564
  Constraints.MinWidth = 850
  Font.Charset = DEFAULT_CHARSET
  Font.Color = clWindowText
  Font.Height = -11
  Font.Name = 'MS Sans Serif'
  Font.Style = []
  KeyPreview = True
  Menu = MainMenu1
  OldCreateOrder = False
  Position = poDesigned
  OnActivate = FormActivate
  OnClose = FormClose
  OnCreate = FormCreate
  OnDestroy = FormDestroy
  OnKeyUp = FormKeyUp
  OnPaint = FormPaint
  OnShow = FormShow
  PixelsPerInch = 96
  TextHeight = 13
  object Splitter1: TSplitter
    Left = 211
    Top = 0
    Width = 10
    Height = 591
    Cursor = crDefault
    OnCanResize = Splitter1CanResize
  end
  object pnlReportStatus: TPanel
    Left = 221
    Top = 0
    Width = 621
    Height = 591
    Align = alClient
    BevelInner = bvRaised
    BevelOuter = bvLowered
    ParentBackground = False
    TabOrder = 1
    DesignSize = (
      621
      591)
    object lbReportListTitle: TLabel
      Left = 6
      Top = 12
      Width = 603
      Height = 19
      Anchors = [akLeft, akTop, akRight]
      AutoSize = False
      Caption = 'Report Status'
      Font.Charset = DEFAULT_CHARSET
      Font.Color = clWindowText
      Font.Height = -11
      Font.Name = 'MS Sans Serif'
      Font.Style = [fsBold]
      ParentFont = False
    end
    object Label1: TLabel
      Left = 16
      Top = 446
      Width = 157
      Height = 13
      Anchors = [akLeft, akBottom]
      Caption = 'selected Report parameters'
      Font.Charset = DEFAULT_CHARSET
      Font.Color = clWindowText
      Font.Height = -11
      Font.Name = 'MS Sans Serif'
      Font.Style = [fsBold]
      ParentFont = False
      ExplicitTop = 346
    end
    object lbRefeshPending: TLabel
      Left = 6
      Top = 45
      Width = 75
      Height = 13
      Caption = 'Refreshing list...'
      Visible = False
    end
    object lbRefreshSeconds: TLabel
      Left = 186
      Top = 45
      Width = 109
      Height = 13
      Caption = 'Updating in 3 seconds.'
    end
    object lbrefreshLast: TLabel
      Left = 348
      Top = 45
      Width = 81
      Height = 13
      Caption = 'Last Refreshed : '
    end
    object lvwRptStatus: TListView
      Left = 6
      Top = 66
      Width = 607
      Height = 365
      Anchors = [akLeft, akTop, akRight, akBottom]
      Columns = <
        item
          Caption = 'Report Type'
          Width = 88
        end
        item
          Caption = 'Status'
          Width = 83
        end
        item
          Caption = 'From'
          Width = 83
        end
        item
          Caption = 'To'
          Width = 83
        end
        item
          Caption = 'Started At'
          Width = 130
        end
        item
          Caption = 'Ended At'
          Width = 130
        end>
      GridLines = True
      HideSelection = False
      HotTrackStyles = [htUnderlineHot]
      HoverTime = 100
      ReadOnly = True
      RowSelect = True
      ParentShowHint = False
      PopupMenu = PopupMenu1
      ShowHint = True
      StateImages = ImageList1
      TabOrder = 0
      ViewStyle = vsReport
      OnChanging = lvwRptStatusChanging
      OnClick = lvwRptStatusClick
      OnColumnClick = lvwRptStatusColumnClick
      OnDblClick = lvwRptStatusDblClick
      OnKeyUp = lvwRptStatusKeyUp
      OnSelectItem = lvwRptStatusSelectItem
    end
    object btnManualRefreshList: TBitBtn
      Left = 422
      Top = 475
      Width = 100
      Height = 25
      Action = ActionRefreshList
      Anchors = [akLeft, akBottom]
      Caption = 'Refresh &List'
      TabOrder = 1
    end
    object memSelSettings: TMemo
      Left = 16
      Top = 477
      Width = 185
      Height = 92
      Anchors = [akLeft, akBottom]
      BevelInner = bvNone
      BevelOuter = bvNone
      BorderStyle = bsNone
      Lines.Strings = (
        '<no selection>')
      ParentColor = True
      TabOrder = 2
    end
    object btnViewReport: TBitBtn
      Left = 235
      Top = 475
      Width = 100
      Height = 25
      Anchors = [akLeft, akBottom]
      Caption = '&View Report'
      Enabled = False
      TabOrder = 3
      OnClick = btnViewReportClick
      NumGlyphs = 2
    end
  end
  object pnlCriteriaSelection: TPanel
    Left = 0
    Top = 0
    Width = 211
    Height = 591
    Align = alLeft
    BevelInner = bvRaised
    BevelOuter = bvLowered
    ParentBackground = False
    TabOrder = 0
    object Label5: TLabel
      Left = 16
      Top = 20
      Width = 134
      Height = 13
      Caption = 'New Report parameters'
      Font.Charset = DEFAULT_CHARSET
      Font.Color = clWindowText
      Font.Height = -11
      Font.Name = 'MS Sans Serif'
      Font.Style = [fsBold]
      ParentFont = False
    end
    object btnRunReport: TBitBtn
      Left = 47
      Top = 441
      Width = 100
      Height = 25
      Caption = '&Run Report'
      TabOrder = 4
      OnClick = btnRunReportClick
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
    object cbxIncludeDeletedImages: TCheckBox
      Left = 16
      Top = 261
      Width = 129
      Height = 17
      Caption = 'Include Deleted images'
      TabOrder = 1
    end
    object cbxIncludeExistingImages: TCheckBox
      Left = 16
      Top = 292
      Width = 129
      Height = 17
      Caption = 'Include Existing images'
      Checked = True
      State = cbChecked
      TabOrder = 2
    end
    object rgImageCountsBy: TRadioGroup
      Left = 6
      Top = 332
      Width = 195
      Height = 90
      Caption = ' Return Image Counts by: '
      ItemIndex = 1
      Items.Strings = (
        'Grouped by Status'
        'Grouped by Users and Status')
      TabOrder = 3
    end
    object GroupBox1: TGroupBox
      Left = 5
      Top = 51
      Width = 196
      Height = 190
      Caption = ' Date Range '
      TabOrder = 0
      object lbSelectedRange: TLabel
        Left = 11
        Top = 132
        Width = 109
        Height = 13
        Caption = 'Selected Range: 1 day'
      end
      object lbDateConstraintMsg: TLabel
        Left = 11
        Top = 154
        Width = 128
        Height = 13
        Caption = 'Maximum Range: Unlimited'
      end
      object dtFrom: TDateTimePicker
        Left = 11
        Top = 43
        Width = 126
        Height = 21
        Date = 40297.402657326390000000
        Format = 'MM/dd/yyyy'
        Time = 40297.402657326390000000
        MinDate = 2.000000000000000000
        TabOrder = 0
        OnCloseUp = dtFromCloseUp
        OnChange = dtFromChange
        OnExit = dtFromExit
      end
      object dtTo: TDateTimePicker
        Left = 11
        Top = 96
        Width = 126
        Height = 21
        Date = 40297.402704166660000000
        Format = 'MM/dd/yyyy'
        Time = 40297.402704166660000000
        TabOrder = 1
        OnChange = dtToChange
        OnExit = dtToExit
      end
      object StaticText1: TStaticText
        Left = 11
        Top = 26
        Width = 30
        Height = 17
        Caption = 'From:'
        TabOrder = 2
      end
      object StaticText2: TStaticText
        Left = 11
        Top = 78
        Width = 20
        Height = 17
        Caption = 'To:'
        TabOrder = 3
      end
    end
  end
  object barStatus: TStatusBar
    Left = 0
    Top = 591
    Width = 842
    Height = 19
    Panels = <
      item
        Width = 100
      end
      item
        Width = 400
      end
      item
        Width = 50
      end>
  end
  object PopupMenu1: TPopupMenu
    OnPopup = PopupMenu1Popup
    Left = 417
    Top = 140
    object popViewReport: TMenuItem
      Caption = 'View Report'
      Enabled = False
      OnClick = popViewReportClick
    end
    object popRerunReport: TMenuItem
      Caption = 'Re-run Report'
      Enabled = False
      OnClick = popRerunReportClick
    end
    object N1: TMenuItem
      Caption = '-'
    end
    object popCancelReport: TMenuItem
      Caption = 'Cancel Report'
      OnClick = popCancelReportClick
    end
    object popDeleteReport: TMenuItem
      Caption = 'Delete Report'
      Enabled = False
      OnClick = popDeleteReportClick
    end
    object N3: TMenuItem
      Caption = '-'
    end
    object RefreshList2: TMenuItem
      Caption = 'Refresh List'
      OnClick = RefreshList2Click
    end
  end
  object MainMenu1: TMainMenu
    Left = 152
    object mnuFile: TMenuItem
      Caption = '&File'
      object mnuFileExit: TMenuItem
        Caption = '&Exit'
        OnClick = mnuFileExitClick
      end
    end
    object mnuAction: TMenuItem
      Caption = '&Action'
      OnClick = mnuActionClick
      object mnuViewReport: TMenuItem
        Caption = '&View Report'
        OnClick = mnuViewReportClick
      end
      object N4: TMenuItem
        Caption = '-'
      end
      object mnuRerunReport: TMenuItem
        Caption = '&Re-run Report'
        OnClick = mnuRerunReportClick
      end
      object mnuCancelReport: TMenuItem
        Caption = '&Cancel Report'
        OnClick = mnuCancelReportClick
      end
      object mnuDeleteReport: TMenuItem
        Caption = '&Delete Report'
        OnClick = mnuDeleteReportClick
      end
      object N5: TMenuItem
        Caption = '-'
      end
    end
    object mnuOptions: TMenuItem
      Caption = '&Options'
      object N2: TMenuItem
        Caption = '-'
      end
      object mnuRefreshList: TMenuItem
        Action = ActionRefreshList
      end
      object mnuActiveForms: TMenuItem
        Caption = 'Active &Windows...'
        ShortCut = 16471
        Visible = False
        OnClick = mnuActiveFormsClick
      end
      object mnuStayonTop: TMenuItem
        AutoCheck = True
        Caption = '&Stay on Top'
        OnClick = mnuStayonTopClick
      end
      object mnuAutoRefreshList: TMenuItem
        AutoCheck = True
        Caption = 'Auto-&refresh List'
        Checked = True
        OnClick = mnuAutoRefreshListClick
      end
    end
    object mnuHelp: TMenuItem
      Caption = '&Help'
      object mnuQAReportHelp: TMenuItem
        Caption = '&QA Report Help'
        OnClick = mnuQAReportHelpClick
      end
    end
  end
  object tiRefresh: TTimer
    OnTimer = tiRefreshTimer
    Left = 328
    Top = 136
  end
  object ActionManager1: TActionManager
    Left = 376
    Top = 136
    StyleName = 'XP Style'
    object ActionRefreshList: TAction
      Caption = 'Refresh List'
      ShortCut = 116
      OnExecute = ActionRefreshListExecute
    end
  end
  object ImageList1: TImageList
    Left = 428
    Top = 232
    Bitmap = {
      494C010103000400040010001000FFFFFFFFFF00FFFFFFFFFFFFFFFF424D3600
      0000000000003600000028000000400000001000000001002000000000000010
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      00000000000000000000000000000A0A9A000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      00000000000000000000000000006B3B3B000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      00000000000000000000000000000A6B0A000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      00000000000000000000000000000A0A9A000A0A9A0000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      00000000000000000000000000006B3B3B006B3B3B0000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      00000000000000000000000000000A6B0A000A6B0A0000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      00000000000000000000000000000A0A9A003B0AB9000A0A9A00000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      00000000000000000000000000006B3B3B009C5628006B3B3B00000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      00000000000000000000000000000A6B0A000A9A0A000A6B0A00000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      00000000000000000000000000000A0A9A009BAEFB003B0AB9000A0A9A000000
      0000000000000000000000000000000000000000000000000000000000000000
      00000000000000000000000000006B3B3B00FBE0B4009C5628006B3B3B000000
      0000000000000000000000000000000000000000000000000000000000000000
      00000000000000000000000000000A6B0A006BFB9A000A9A0A000A6B0A000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      000000000000000000000000000000000000000000000A0A9A000A0A9A000A0A
      9A000A0A9A000A0A9A000A0A9A000A0A9A009BAEFB000F3EFB003B0AB9000A0A
      9A0000000000000000000000000000000000000000006B3B3B006B3B3B006B3B
      3B006B3B3B006B3B3B006B3B3B006B3B3B00FBE0B400D07316009C5628006B3B
      3B0000000000000000000000000000000000000000000A6B0A000A6B0A000A6B
      0A000A6B0A000A6B0A000A6B0A000A6B0A006BFB9A0026B734000A9A0A000A6B
      0A00000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      000000000000000000000000000000000000000000000A0A9A000A2FE4003B0A
      B9003B0AB9003B0AB9003B0AB9003B0AB9001F4BFB001744FC00103FFB003B0A
      B9000A0A9A00000000000000000000000000000000006B3B3B00D4822B009C56
      28009C5628009C5628009C5628009C562800D0751900D2781F00D07417009C56
      28006B3B3B00000000000000000000000000000000000A6B0A0032C246000A9A
      0A000A9A0A000A9A0A000A9A0A000A9A0A002EBF40002ABC3B0027B736000A9A
      0A000A6B0A000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      000000000000000000000000000000000000000000000A0A9A009BAEFB005F7E
      FC005274FB00476CFB003C62FB00325AFB002952FB001F4CFC001745FB00113F
      FB003B0AB9000A0A9A000000000000000000000000006B3B3B00FBE0B400ECAC
      6B00E8A46000E49C5500E1954A00DD8D3E00D9873400D6802A00D27A2000D174
      18009C5628006B3B3B000000000000000000000000000A6B0A006BFB9A0047D7
      640043D25F003ED059003CCC530037C74E0033C347002FC041002BBD3C0028B8
      36000A9A0A000A6B0A0000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      000000000000000000000000000000000000000000000A0A9A009BAEFB006C88
      FC00607FFB005375FC00486CFB003D63FB00325AFB002953FB00204CFB001845
      FB00113FFB003B0AB9000A0A9A0000000000000000006B3B3B00FBE0B400EFB3
      7600EBAC6D00E8A56200E49D5600E1964C00DD8F4000D9873600D6812B00D37A
      2200D17419009C5628006B3B3B0000000000000000000A6B0A006BFB9A004CDC
      6C0047D8660044D461003FD15B003CCD540038C94F0035C5490031C043002CBE
      3D0029BA38000A9A0A000A6B0A00000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      000000000000000000000000000000000000000000000A0A9A009BAEFB007994
      FB006E89FC00617FFC005476FC00496DFB003E64FB00335BFB002A53FB00214D
      FB000A3BFB000A0A9A000000000000000000000000006B3B3B00FBE0B400F4BB
      8200EFB47800ECAC6E00E8A66200E49F5800E1974E00DE8F4200DA883700D682
      2C00D07519006B3B3B000000000000000000000000000A6B0A006BFB9A004FE1
      73004CDD6D0048D9670045D5620041D15C003CCE560039C9500035C64B0031C2
      45000A9A0A000A6B0A0000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      000000000000000000000000000000000000000000000A0A9A009BAEFB009BAE
      FB009BAEFB009BAEFB009BAEFB009BAEFB009BAEFB003E65FB00345DFB000A3B
      FB000A0A9A00000000000000000000000000000000006B3B3B00FBE0B400FBE0
      B400FBE0B400FBE0B400FBE0B400FBE0B400FBE0B400E2994F00DE914300D075
      19006B3B3B00000000000000000000000000000000000A6B0A006BFB9A006BFB
      9A006BFB9A006BFB9A006BFB9A006BFB9A006BFB9A003ECF58003BCB52000A9A
      0A000A6B0A000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      000000000000000000000000000000000000000000000A0A9A000A0A9A000A0A
      9A000A0A9A000A0A9A000A0A9A000A0A9A009BAEFB004B6FFB000A3BFB000A0A
      9A0000000000000000000000000000000000000000006B3B3B006B3B3B006B3B
      3B006B3B3B006B3B3B006B3B3B006B3B3B00FBE0B400E6A05B00D07519006B3B
      3B0000000000000000000000000000000000000000000A6B0A000A6B0A000A6B
      0A000A6B0A000A6B0A000A6B0A000A6B0A006BFB9A0043D360000A9A0A000A6B
      0A00000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      00000000000000000000000000000A0A9A009BAEFB000A3BFB000A0A9A000000
      0000000000000000000000000000000000000000000000000000000000000000
      00000000000000000000000000006B3B3B00FBE0B400D07519006B3B3B000000
      0000000000000000000000000000000000000000000000000000000000000000
      00000000000000000000000000000A6B0A006BFB9A000A9A0A000A6B0A000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      00000000000000000000000000000A0A9A000A34EE000A0A9A00000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      00000000000000000000000000006B3B3B00F2B87E006B3B3B00000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      00000000000000000000000000000A6B0A003ECF58000A6B0A00000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      00000000000000000000000000000A0A9A000A0A9A0000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      00000000000000000000000000006B3B3B006B3B3B0000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      00000000000000000000000000000A6B0A000A6B0A0000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      00000000000000000000000000000A0A9A000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      00000000000000000000000000006B3B3B000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      00000000000000000000000000000A6B0A000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      000000000000000000000000000000000000424D3E000000000000003E000000
      2800000040000000100000000100010000000000800000000000000000000000
      000000000000000000000000FFFFFF00FFFFFFFFFFFF0000FEFFFEFFFEFF0000
      FE7FFE7FFE7F0000FE3FFE3FFE3F0000FE1FFE1FFE1F0000800F800F800F0000
      8007800780070000800380038003000080018001800100008003800380030000
      8007800780070000800F800F800F0000FE1FFE1FFE1F0000FE3FFE3FFE3F0000
      FE7FFE7FFE7F0000FEFFFEFFFEFF0000}
  end
end
