object frmMagAbstracts: TfrmMagAbstracts
  Left = 337
  Top = 466
  HelpContext = 10000
  Caption = 'Abstracts'
  ClientHeight = 531
  ClientWidth = 581
  Color = clBtnFace
  Constraints.MinHeight = 132
  Constraints.MinWidth = 125
  Font.Charset = ANSI_CHARSET
  Font.Color = clWindowText
  Font.Height = -11
  Font.Name = 'Arial'
  Font.Style = []
  KeyPreview = True
  Menu = MainMenu1
  OldCreateOrder = True
  Position = poDefault
  ShowHint = True
  OnClose = FormClose
  OnCreate = FormCreate
  OnDestroy = FormDestroy
  OnKeyDown = FormKeyDown
  OnPaint = FormPaint
  PixelsPerInch = 96
  TextHeight = 14
  object lbImagecount: TLabel
    Left = 0
    Top = 0
    Width = 581
    Height = 14
    Align = alTop
    Caption = '<Filter description>'
    Constraints.MinHeight = 14
    Font.Charset = ANSI_CHARSET
    Font.Color = clWindowText
    Font.Height = -11
    Font.Name = 'Arial'
    Font.Style = []
    ParentFont = False
    WordWrap = True
    ExplicitWidth = 91
  end
  object Label1: TLabel
    Left = 70
    Top = 35
    Width = 32
    Height = 14
    Caption = 'Label1'
  end
  object Splitter1: TSplitter
    Left = 0
    Top = 292
    Width = 581
    Height = 12
    Cursor = crVSplit
    Align = alBottom
    Visible = False
    ExplicitTop = 289
  end
  object Mag4Viewer1: TMag4Viewer
    Left = 12
    Top = 24
    Width = 205
    Height = 241
    DragKind = dkDock
    Color = clBtnFace
    Font.Charset = DEFAULT_CHARSET
    Font.Color = clWindowText
    Font.Height = -11
    Font.Name = 'MS Sans Serif'
    Font.Style = []
    ParentColor = False
    ParentFont = False
    ParentShowHint = False
    PopupMenu = popupVImage
    ShowHint = True
    TabOrder = 0
    OnEndDock = Mag4Viewer1EndDock
    AbsWindow = True
    DisplayStyle = MagdsLine
    ViewerStyle = MagvsDynamic
    OnViewerImageClick = Mag4Viewer1ViewerImageClick
    OnListChange = Mag4Viewer1ListChange
    PopupMenuImage = popupVImage
    MagSecurity = DMod.MagFileSecurity
    ViewStyle = MagViewerViewAbs
    UseAutoReAlign = True
    ImageFontSize = 8
    ShowToolbar = False
    LockSize = True
    ZoomWindow = False
    PanWindow = False
    Scrollable = False
    ScrollVertical = True
    IsDragAble = False
    IsSizeAble = False
    ApplyToAll = False
    AutoRedraw = True
    ClearBeforeAddDrop = False
    RowCount = 1
    RowSpacing = 1
    ColumnSpacing = 1
    ColumnCount = 1
    MaximizeImage = False
    MaxCount = 1
    LockWidth = 0
    LockHeight = 0
    ShowDescription = True
    ImagePageCount = 0
    ImagePage = 0
    MaxAutoLoad = -1
    WindowLevelSettings = MagWinLevImageSettings
    DesignSize = (
      205
      241)
  end
  object PageControl1: TPageControl
    Left = 0
    Top = 304
    Width = 581
    Height = 227
    ActivePage = TabSheet1
    Align = alBottom
    TabOrder = 1
    Visible = False
    object TabSheet1: TTabSheet
      Caption = 'TabSheet1'
    end
    object TabSheet2: TTabSheet
      Caption = 'TabSheet2'
      ImageIndex = 1
    end
  end
  object popupVImage: TPopupMenu
    HelpContext = 10000
    OnPopup = popupVImagePopup
    Left = 268
    Top = 122
    object mnuOpen: TMenuItem
      Caption = 'Open Image'
      OnClick = mnuOpenClick
    end
    object mnuViewImagein2ndRadiologyWindow: TMenuItem
      Caption = 'Open Image in 2nd Radiology Window'
      OnClick = mnuViewImagein2ndRadiologyWindowClick
    end
    object mnuImageReport: TMenuItem
      Caption = 'Image Report'
      ImageIndex = 16
      OnClick = mnuImageReportClick
    end
    object mnuImageDelete: TMenuItem
      Caption = 'Image Delete...'
      ImageIndex = 44
      OnClick = mnuImageDeleteClick
    end
    object mnuImageSaveAs: TMenuItem
      Caption = '[na] Image Save As...'
      Visible = False
      OnClick = mnuImageSaveAsClick
    end
    object mnuImageIndexEdit: TMenuItem
      Caption = '[na] Image Index Edit...'
      Visible = False
      OnClick = mnuImageIndexEditClick
    end
    object mnuImageInformation: TMenuItem
      Caption = 'Image Information...'
      HelpContext = 10095
      ImageIndex = 43
      OnClick = mnuImageInformationClick
    end
    object mnuImageInformationAdvanced: TMenuItem
      Caption = 'Image Information Advanced...'
      OnClick = mnuImageInformationAdvancedClick
    end
    object mnuCacheGroup: TMenuItem
      Caption = 'Cache Images'
      OnClick = mnuCacheGroupClick
    end
    object N1: TMenuItem
      Caption = '-'
    end
    object ImageListFilters1: TMenuItem
      Caption = 'Image List Filters...'
      HelpContext = 10093
      ImageIndex = 45
      ShortCut = 16460
      OnClick = ImageListFilters1Click
    end
    object MenuItem6: TMenuItem
      Caption = '-'
    end
    object mnuRefresh: TMenuItem
      Caption = 'Refresh'
      ImageIndex = 12
      ShortCut = 16466
      OnClick = mnuRefreshClick
    end
    object ResizetheAbstracts1: TMenuItem
      Caption = 'Resize the Abstracts...'
      OnClick = ResizetheAbstracts1Click
    end
    object mnuOptions2: TMenuItem
      Caption = 'Options'
      object PagePrevViewer: TMenuItem
        Caption = 'Prev Viewer Page'
        ShortCut = 49232
        OnClick = PagePrevViewerClick
      end
      object NextViewerPage1: TMenuItem
        Caption = 'Next Viewer Page'
        ShortCut = 49230
        OnClick = NextViewerpage1Click
      end
      object SmallerAbs1: TMenuItem
        Caption = 'Smaller Abstracts'
        ShortCut = 16463
        OnClick = SmallerAbs1Click
      end
      object LargerAbs1: TMenuItem
        Caption = 'Larger Abstracts'
        Hint = 
          'Increase the Size of all Abstracts.  Rows and Columns will reali' +
          'gn to fit the window.'
        ShortCut = 16457
        OnClick = LargerAbs1Click
      end
      object PrevAbs1: TMenuItem
        Caption = 'Previous Abstract'
        ShortCut = 16464
        OnClick = PrevAbs1Click
      end
      object NextAbs1: TMenuItem
        Caption = 'Next Abstract'
        ShortCut = 16462
        OnClick = NextAbs1Click
      end
    end
    object mnuViewerSettings: TMenuItem
      Caption = '[testing]Viewer Settings...'
      Visible = False
      OnClick = mnuViewerSettingsClick
    end
    object N3: TMenuItem
      Caption = '-'
      Visible = False
    end
    object mnuFontSize: TMenuItem
      Caption = 'Font Size'
      OnClick = mnuFontSizeClick
      object mnuFont6: TMenuItem
        Tag = 6
        Caption = '6 pt'
        OnClick = mnuFont6Click
      end
      object mnuFont7: TMenuItem
        Tag = 7
        Caption = '7 pt'
        OnClick = mnuFont7Click
      end
      object mnuFont8: TMenuItem
        Tag = 8
        Caption = '8 pt'
        OnClick = mnuFont8Click
      end
      object mnuFont10: TMenuItem
        Tag = 10
        Caption = '10 pt'
        OnClick = mnuFont10Click
      end
      object mnuFont12: TMenuItem
        Tag = 12
        Caption = '12 pt'
        OnClick = mnuFont12Click
      end
    end
    object mnuToolbar: TMenuItem
      Caption = 'Toolbar'
      Checked = True
      ShortCut = 16468
      OnClick = mnuToolbarClick
    end
    object mnuShowHints: TMenuItem
      Caption = 'Show Hints'
      Checked = True
      OnClick = mnuShowHintsClick
    end
    object mnuStayOnTop: TMenuItem
      Caption = '[testing] Stay On Top'
      Visible = False
      OnClick = mnuStayOnTopClick
    end
    object MenuItem12: TMenuItem
      Caption = '-'
    end
    object mnuGotoMainWindow: TMenuItem
      Caption = 'Go to Main Window'
      ShortCut = 16461
      OnClick = mnuGotoMainWindowClick
    end
    object Activewindows1: TMenuItem
      Caption = 'Active windows...'
      ShortCut = 16471
      OnClick = Activewindows1Click
    end
    object mnuHelp: TMenuItem
      Caption = 'Help...'
      ImageIndex = 28
      OnClick = mnuHelpClick
    end
    object Testing1: TMenuItem
      Caption = '[testing] Testing'
      Visible = False
      object testrefreshone1: TMenuItem
        Caption = 'TEST AUTOREDRAW = ? '
        OnClick = testrefreshone1Click
      end
      object testrefresh1: TMenuItem
        Caption = 'TEST FIT-TO-WIDTH'
        OnClick = testrefresh1Click
      end
      object TESTUPDATE1: TMenuItem
        Caption = 'TEST UPDATE GUI'
        OnClick = TESTUPDATE1Click
      end
      object TESTREFRESH2: TMenuItem
        Caption = 'TEST REFRESH'
        OnClick = TESTREFRESH2Click
      end
      object TESTREDRA1: TMenuItem
        Caption = 'TEST REDRAW'
        OnClick = TESTREDRA1Click
      end
      object TESTSLDFJKS1: TMenuItem
        Caption = 'TEST UPDATE'
        OnClick = TESTSLDFJKS1Click
      end
      object TESTAUTOREDRAWTRUE1: TMenuItem
        Caption = 'TEST AUTOREDRAW := TRUE'
        OnClick = TESTAUTOREDRAWTRUE1Click
      end
    end
  end
  object timerReSize: TTimer
    Enabled = False
    Interval = 100
    OnTimer = timerReSizeTimer
    Left = 316
    Top = 22
  end
  object MainMenu1: TMainMenu
    Left = 247
    Top = 22
    object mnuFile: TMenuItem
      Caption = 'File'
      Visible = False
      object mnuExit: TMenuItem
        Caption = 'Exit'
      end
    end
    object mnuOptions: TMenuItem
      Caption = 'Options'
      Visible = False
      object PrevViewerPage1: TMenuItem
        Caption = 'Prev Viewer Page'
        ShortCut = 49232
        OnClick = PrevViewerPage1Click
      end
      object NextPage1: TMenuItem
        Caption = 'Next Viewer Page'
        ShortCut = 49230
        OnClick = NextPage1Click
      end
      object mnuAbsSmaller: TMenuItem
        Caption = 'Smaller Abs '
        ShortCut = 16463
        OnClick = mnuAbsSmallerClick
      end
      object mnuAbsBigger: TMenuItem
        Caption = 'Bigger Abs'
        ShortCut = 16457
        OnClick = mnuAbsBiggerClick
      end
      object mnuPrev: TMenuItem
        Caption = 'Prev Abs'
        ShortCut = 16464
        OnClick = mnuPrevClick
      end
      object mnuNext: TMenuItem
        Caption = 'Next Abs'
        ShortCut = 16462
        OnClick = mnuNextClick
      end
      object mnuRefresh1: TMenuItem
        Caption = 'Refresh'
        ShortCut = 16466
        OnClick = mnuRefresh1Click
      end
      object mnuPopupMenu: TMenuItem
        Caption = 'Popup Menu'
        ShortCut = 49229
        OnClick = mnuPopupMenuClick
      end
      object GoToMainForm1: TMenuItem
        Caption = 'Go To Main Form '
        ShortCut = 16461
        OnClick = GoToMainForm1Click
      end
      object AcitveForms1: TMenuItem
        Caption = 'Acitve windows...'
        ShortCut = 16471
        OnClick = AcitveForms1Click
      end
    end
  end
end
