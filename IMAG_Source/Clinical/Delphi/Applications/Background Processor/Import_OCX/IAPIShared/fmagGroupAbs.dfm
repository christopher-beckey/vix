object frmGroupAbs: TfrmGroupAbs
  Left = 500
  Top = 454
  HelpContext = 10000
  Caption = 'Group Window'
  ClientHeight = 451
  ClientWidth = 468
  Color = clBtnFace
  Constraints.MinHeight = 132
  Constraints.MinWidth = 125
  Font.Charset = DEFAULT_CHARSET
  Font.Color = clBlack
  Font.Height = -11
  Font.Name = 'Arial'
  Font.Style = []
  KeyPreview = True
  Menu = MainMenu1
  OldCreateOrder = True
  ShowHint = True
  OnClose = FormClose
  OnCreate = FormCreate
  OnEndDock = FormEndDock
  OnKeyDown = FormKeyDown
  OnPaint = FormPaint
  OnUnDock = FormUnDock
  PixelsPerInch = 96
  TextHeight = 14
  object Splitter1: TSplitter
    Left = 0
    Top = 21
    Width = 1
    Height = 430
    ExplicitHeight = 350
  end
  object pinfo: TPanel
    Left = 0
    Top = 0
    Width = 468
    Height = 21
    Align = alTop
    BevelInner = bvLowered
    Caption = 'pinfo'
    TabOrder = 0
    object lbGroupDesc: TLabel
      Left = 2
      Top = 2
      Width = 464
      Height = 17
      Align = alClient
      Caption = 'lbGroupDesc'
      Font.Charset = DEFAULT_CHARSET
      Font.Color = clBlack
      Font.Height = -11
      Font.Name = 'Arial'
      Font.Style = [fsBold]
      ParentFont = False
      ShowAccelChar = False
      ExplicitWidth = 71
      ExplicitHeight = 14
    end
  end
  object Mag4Viewer1: TMag4Viewer
    Left = 28
    Top = 102
    Width = 243
    Height = 169
    DragKind = dkDock
    Color = clGrayText
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
    TabOrder = 1
    OnEndDock = Mag4Viewer1EndDock
    AbsWindow = False
    DisplayStyle = MagdsLine
    ViewerStyle = MagvsDynamic
    OnViewerImageClick = Mag4Viewer1ViewerImageClick
    OnListChange = Mag4Viewer1ListChange
    PopupMenuImage = popupVImage
    MagSecurity = DMod.MagFileSecurity
    MagImageList = magImageList1
    MagUtilsDB = DMod.MagUtilsDB1
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
    AutoRedraw = False
    ClearBeforeAddDrop = False
    RowCount = 2
    RowSpacing = 1
    ColumnSpacing = 1
    ColumnCount = 2
    MaximizeImage = False
    MaxCount = 12
    LockWidth = 0
    LockHeight = 0
    ShowDescription = False
    ImagePageCount = 0
    ImagePage = 0
    MaxAutoLoad = -1
    WindowLevelSettings = MagWinLevImageSettings
    DesignSize = (
      243
      169)
  end
  object magImageList1: TMagImageList
    IsGroupList = True
    Port = 0
    Left = 68
    Top = 38
  end
  object popupVImage: TPopupMenu
    HelpContext = 999
    OnPopup = popupVImagePopup
    Left = 139
    Top = 52
    object mnuBrowsePlay: TMenuItem
      Caption = '[testing] Browse/Play'
      Visible = False
      OnClick = mnuBrowsePlayClick
    end
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
    object mnuImageSaveAs: TMenuItem
      Caption = '[testing] Image Save As...'
      Visible = False
    end
    object mnuImageDelete: TMenuItem
      Caption = 'Image Delete...'
      ImageIndex = 44
      OnClick = mnuImageDeleteClick
    end
    object mnuImageInformation: TMenuItem
      Caption = 'Image Information...'
      ImageIndex = 43
      OnClick = mnuImageInformationClick
    end
    object mnuImageInformationAdvanced: TMenuItem
      Caption = 'Image Information Advanced...'
      OnClick = mnuImageInformationAdvancedClick
    end
    object MenuItem6: TMenuItem
      Caption = '-'
    end
    object Refresh1: TMenuItem
      Caption = 'Refresh'
      ImageIndex = 12
      ShortCut = 16466
      OnClick = Refresh1Click
    end
    object ResizetheAbstracts1: TMenuItem
      Caption = 'Resize the Abstracts...'
      OnClick = ResizetheAbstracts1Click
    end
    object Options1: TMenuItem
      Caption = 'Options'
      object PrevViewerPage2: TMenuItem
        Caption = 'Prev Viewer Page'
        ShortCut = 49232
        OnClick = PrevViewerPage2Click
      end
      object NextViewerPage1: TMenuItem
        Caption = 'Next Viewer Page'
        ShortCut = 49230
        OnClick = NextViewerPage1Click
      end
      object SmallerAbs1: TMenuItem
        Caption = 'Smaller Abs'
        ShortCut = 16463
        OnClick = SmallerAbs1Click
      end
      object BiggerAbs1: TMenuItem
        Caption = 'Larger Abs'
        ShortCut = 16457
        OnClick = BiggerAbs1Click
      end
      object PrevAbs1: TMenuItem
        Caption = 'Prev Abs'
        ShortCut = 16464
        OnClick = PrevAbs1Click
      end
      object NextAbs1: TMenuItem
        Caption = 'Next Abs'
        ShortCut = 16462
        OnClick = NextAbs1Click
      end
    end
    object ViewerSettings1: TMenuItem
      Caption = '[testing] Viewer Settings...'
      Visible = False
      OnClick = ViewerSettings1Click
    end
    object N1: TMenuItem
      Caption = '-'
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
      HelpContext = 10000
      ImageIndex = 28
      OnClick = mnuHelpClick
    end
  end
  object timerResize: TTimer
    Enabled = False
    OnTimer = timerResizeTimer
    Left = 222
    Top = 46
  end
  object MainMenu1: TMainMenu
    Left = 395
    Top = 30
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
      object ActiveForms1: TMenuItem
        Caption = 'Active windows...'
        ShortCut = 16471
        OnClick = ActiveForms1Click
      end
      object testing1: TMenuItem
        Caption = 'testing'
        ShortCut = 45
        OnClick = testing1Click
      end
    end
  end
end
