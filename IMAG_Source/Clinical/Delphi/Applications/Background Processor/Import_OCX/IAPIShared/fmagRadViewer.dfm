object frmRadViewer: TfrmRadViewer
  Left = 476
  Top = 182
  ActiveControl = Mag4StackViewer2.Mag4Vgear1
  Caption = 'frmRadiology'
  ClientHeight = 638
  ClientWidth = 801
  Color = clBtnFace
  Font.Charset = DEFAULT_CHARSET
  Font.Color = clWindowText
  Font.Height = -11
  Font.Name = 'MS Sans Serif'
  Font.Style = []
  Menu = MainMenu1
  OldCreateOrder = False
  OnClose = FormClose
  OnCreate = FormCreate
  OnDestroy = FormDestroy
  OnResize = FormResize
  OnShow = FormShow
  PixelsPerInch = 96
  TextHeight = 13
  object magViewerTB1: TmagViewerRadTB2
    Left = 0
    Top = 0
    Width = 801
    Height = 65
    HelpContext = 10215
    Align = alTop
    AutoSize = True
    ParentShowHint = False
    ShowHint = True
    TabOrder = 0
    DICOMViewer = False
    OnPrintClick = magViewerTB1PrintClick
    OnCopyClick = magViewerTB1CopyClick
  end
  object Mag4StackViewer1: TMag4StackViewer
    Left = 32
    Top = 356
    Width = 333
    Height = 221
    TabOrder = 1
    CurrentStackViewMode = MagStackView11
    PageSameSettings = False
    ApplyGivenWindowSettings = False
  end
  object Mag4StackViewer2: TMag4StackViewer
    Left = 404
    Top = 168
    Width = 385
    Height = 209
    TabOrder = 2
    CurrentStackViewMode = MagStackView11
    PageSameSettings = False
    ApplyGivenWindowSettings = False
  end
  object Mag4Viewer1: TMag4Viewer
    Left = 32
    Top = 172
    Width = 333
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
    ShowHint = True
    TabOrder = 3
    AbsWindow = False
    DisplayStyle = MagdsLine
    ViewerStyle = MagvsStaticPage
    OnViewerImageClick = Mag4Viewer1ViewerImageClick
    OnViewerClick = Mag4Viewer1ViewerClick
    ViewStyle = MagViewerViewRadiology
    UseAutoReAlign = True
    ImageFontSize = 8
    ShowToolbar = True
    LockSize = False
    ZoomWindow = False
    PanWindow = False
    Scrollable = True
    ScrollVertical = True
    IsDragAble = False
    IsSizeAble = False
    ApplyToAll = False
    AutoRedraw = False
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
      333
      169)
  end
  object MainMenu1: TMainMenu
    Images = ImageList1
    Left = 128
    Top = 136
    object File1: TMenuItem
      Caption = 'File'
      HelpContext = 10214
      object OpenURL1: TMenuItem
        Caption = 'Open &URL'
        Visible = False
        OnClick = OpenURL1Click
      end
      object mnuFileOpenImage: TMenuItem
        Caption = '&Open Image'
        OnClick = mnuFileOpenImageClick
      end
      object Openin2ndStack1: TMenuItem
        Caption = 'Open in &2nd Stack'
        OnClick = Openin2ndStack1Click
      end
      object mnuFileDirectory: TMenuItem
        Caption = '&Directory'
        OnClick = mnuFileDirectoryClick
      end
      object mnuFileCloseSelected: TMenuItem
        Caption = 'Close &Selected'
        OnClick = mnuFileCloseSelectedClick
      end
      object mnuFileClearAll: TMenuItem
        Caption = 'Clear &All'
        OnClick = mnuFileClearAllClick
      end
      object mnuBar1: TMenuItem
        Caption = '-'
      end
      object mnuFileCopy: TMenuItem
        Caption = '&Copy'
        ImageIndex = 14
        OnClick = mnuFileCopyClick
      end
      object mnuFilePrint: TMenuItem
        Caption = '&Print'
        ImageIndex = 15
        OnClick = mnuFilePrintClick
      end
      object mnuFileReport: TMenuItem
        Caption = '&Report'
        ImageIndex = 16
        OnClick = mnuFileReportClick
      end
      object N1: TMenuItem
        Caption = '-'
      end
      object Exit1: TMenuItem
        Caption = 'E&xit'
        OnClick = Exit1Click
      end
    end
    object mnuImage: TMenuItem
      Caption = 'Image'
      HelpContext = 10214
      object mnuImageApplyToAll: TMenuItem
        Caption = '&Apply To All'
        OnClick = mnuImageApplyToAllClick
      end
      object mnuImageZoom: TMenuItem
        Caption = '&Zoom'
        object mnuImageZoomZoomIn: TMenuItem
          Caption = '&Zoom In'
          ShortCut = 24649
          OnClick = mnuImageZoomZoomInClick
        end
        object mnuImageZoomZoomOut: TMenuItem
          Caption = 'Z&oom Out'
          ShortCut = 24655
          OnClick = mnuImageZoomZoomOutClick
        end
        object mnuImageZoomFittoWidth: TMenuItem
          Caption = '&Fit to Width'
          ImageIndex = 24
          ShortCut = 24663
          OnClick = mnuImageZoomFittoWidthClick
        end
        object mnuImageZoomFittoHeight: TMenuItem
          Caption = 'F&it to Height'
          ImageIndex = 23
          OnClick = mnuImageZoomFittoHeightClick
        end
        object mnuImageZoomFittoWindow: TMenuItem
          Caption = 'Fi&t to Window'
          ImageIndex = 22
          OnClick = mnuImageZoomFittoWindowClick
        end
        object mnuImageZoomActualSize: TMenuItem
          Caption = '&Actual Size'
          ImageIndex = 29
          ShortCut = 24641
          OnClick = mnuImageZoomActualSizeClick
        end
      end
      object mnuImageMouse: TMenuItem
        Caption = '&Mouse'
        object mnuImageMousePan: TMenuItem
          Caption = '&Pan'
          ImageIndex = 7
          OnClick = mnuImageMousePanClick
        end
        object mnuImageMouseMagnify: TMenuItem
          Caption = '&Magnify'
          ImageIndex = 9
          OnClick = mnuImageMouseMagnifyClick
        end
        object mnuImageMouseZoom: TMenuItem
          Caption = '&Zoom'
          ImageIndex = 8
          OnClick = mnuImageMouseZoomClick
        end
        object mnuImageMouseRuler: TMenuItem
          Caption = '&Ruler'
          ImageIndex = 53
          OnClick = mnuImageMouseRulerClick
        end
        object mnuImageMouseAngleTool: TMenuItem
          Caption = '&Angle Tool'
          ImageIndex = 55
          OnClick = mnuImageMouseAngleToolClick
        end
        object mnuImageMouseRulerAnglePointer: TMenuItem
          Caption = 'R&uler/Angle Pointer'
          ImageIndex = 54
          OnClick = mnuImageMouseRulerAnglePointerClick
        end
        object mnuImageMouseAutoWindowLevel: TMenuItem
          Caption = 'Auto &Window/Level'
          ImageIndex = 52
          OnClick = mnuImageMouseAutoWindowLevelClick
        end
      end
      object mnuImageBriCon: TMenuItem
        Caption = '&Contrast/Brightness'
        object mnuImageBriConContrastUp: TMenuItem
          Caption = '&Contrast +'
          ShortCut = 24650
          OnClick = mnuImageBriConContrastUpClick
        end
        object mnuImageBriConContrastDown: TMenuItem
          Caption = 'C&ontrast -'
          ShortCut = 24651
          OnClick = mnuImageBriConContrastDownClick
        end
        object mnuImageBriConBrightnessUp: TMenuItem
          Caption = '&Brightness +'
          ShortCut = 24654
          OnClick = mnuImageBriConBrightnessUpClick
        end
        object mnuImageBriConBrightnessDown: TMenuItem
          Caption = 'B&rightness -'
          ShortCut = 24653
          OnClick = mnuImageBriConBrightnessDownClick
        end
      end
      object mnuImageWinLev: TMenuItem
        Caption = '&Window/Level'
        object mnuImageWinLevWindowUp: TMenuItem
          Caption = '&Window +'
          ShortCut = 24644
          OnClick = mnuImageWinLevWindowUpClick
        end
        object mnuImageWinLevWindowDown: TMenuItem
          Caption = 'W&indow -'
          ShortCut = 24646
          OnClick = mnuImageWinLevWindowDownClick
        end
        object mnuImageWinLevLevelUp: TMenuItem
          Caption = '&Level +'
          ShortCut = 24643
          OnClick = mnuImageWinLevLevelUpClick
        end
        object mnuImageWinLevLevelDown: TMenuItem
          Caption = 'L&evel -'
          ShortCut = 24662
          OnClick = mnuImageWinLevLevelDownClick
        end
      end
      object mnuImageInvert: TMenuItem
        Caption = '&Invert (Reverse)'
        ShortCut = 16457
        OnClick = mnuImageInvertClick
      end
      object mnuImageResetImage: TMenuItem
        Caption = 'R&eset Image'
        ImageIndex = 12
        ShortCut = 16466
        OnClick = mnuImageResetImageClick
      end
      object mnuImageResetAll: TMenuItem
        Caption = 'Reset A&ll'
        OnClick = mnuImageResetAllClick
      end
      object mnuImageScroll: TMenuItem
        Caption = '&Scroll'
        object mnuImageScrollTopLeft: TMenuItem
          Caption = '&Top Left'
          ShortCut = 24612
          OnClick = mnuImageScrollTopLeftClick
        end
        object mnuImageScrollTopRight: TMenuItem
          Caption = 'To&p Right'
          ShortCut = 24609
          OnClick = mnuImageScrollTopRightClick
        end
        object mnuImageScrollBottomLeft: TMenuItem
          Caption = '&Bottom Left'
          ShortCut = 24611
          OnClick = mnuImageScrollBottomLeftClick
        end
        object mnuImageScrollBottomRight: TMenuItem
          Caption = 'Botto&m Right'
          ShortCut = 24610
          OnClick = mnuImageScrollBottomRightClick
        end
        object mnuImageScrollLeft: TMenuItem
          Caption = '&Left'
          ShortCut = 24613
          OnClick = mnuImageScrollLeftClick
        end
        object mnuImageScrollRight: TMenuItem
          Caption = '&Right'
          ShortCut = 24615
          OnClick = mnuImageScrollRightClick
        end
        object mnuImageScrollUp: TMenuItem
          Caption = '&Up'
          ShortCut = 24614
          OnClick = mnuImageScrollUpClick
        end
        object mnuImageScrollDown: TMenuItem
          Caption = '&Down'
          ShortCut = 24616
          OnClick = mnuImageScrollDownClick
        end
      end
      object mnuImageMaximizeImage: TMenuItem
        Caption = 'Ma&ximize Image'
        OnClick = mnuImageMaximizeImageClick
      end
      object mnuImageStackCine: TMenuItem
        Caption = 'S&tack Cine'
        object mnuImageStackCineStart: TMenuItem
          Caption = '&Start'
          ShortCut = 24665
          OnClick = mnuImageStackCineStartClick
        end
        object mnuImageStackCineStop: TMenuItem
          Caption = 'Sto&p'
          ShortCut = 24660
          OnClick = mnuImageStackCineStopClick
        end
        object mnuImageStackCineBar1: TMenuItem
          Caption = '-'
        end
        object mnuImageStackCineSpeedUp: TMenuItem
          Caption = 'Speed &Up'
          ShortCut = 24648
          OnClick = mnuImageStackCineSpeedUpClick
        end
        object mnuImageStackCineSlowDown: TMenuItem
          Caption = 'Slow &Down'
          ShortCut = 24647
          OnClick = mnuImageStackCineSlowDownClick
        end
        object mnuImageStackCineBar2: TMenuItem
          Caption = '-'
        end
        object mnuImageStackCineRangeStart: TMenuItem
          Caption = 'Range S&tart'
          OnClick = mnuImageStackCineRangeStartClick
        end
        object mnuImageStackCineRangeEnd: TMenuItem
          Caption = 'Range &End'
          OnClick = mnuImageStackCineRangeEndClick
        end
        object mnuImageStackCineRangeClear: TMenuItem
          Caption = 'Range &Clear'
          OnClick = mnuImageStackCineRangeClearClick
        end
      end
      object mnuImageBar1: TMenuItem
        Caption = '-'
      end
      object mnuImageFirstImage: TMenuItem
        Caption = '&First Image'
        ShortCut = 16454
        OnClick = mnuImageFirstImageClick
      end
      object mnuImagePreviousImage: TMenuItem
        Caption = '&Previous Image'
        ShortCut = 16464
        OnClick = mnuImagePreviousImageClick
      end
      object mnuImageNextImage: TMenuItem
        Caption = '&Next Image'
        ShortCut = 16462
        OnClick = mnuImageNextImageClick
      end
      object mnuImageLastImage: TMenuItem
        Caption = '&Last Image'
        ShortCut = 16460
        OnClick = mnuImageLastImageClick
      end
      object mnuImageBar2: TMenuItem
        Caption = '-'
      end
      object mnuImageCacheStudy: TMenuItem
        Caption = '&Cache Selected Study'
        OnClick = mnuImageCacheStudyClick
      end
    end
    object mnuView: TMenuItem
      Caption = 'View'
      HelpContext = 10214
      object mnuViewPanWindow: TMenuItem
        Caption = '&Pan Window'
        ImageIndex = 6
        OnClick = mnuViewPanWindowClick
      end
      object mnuViewBar1: TMenuItem
        Caption = '-'
      end
      object mnuViewStack1: TMenuItem
        Caption = 'Select Stack 1'
        ShortCut = 24625
        OnClick = mnuViewStack1Click
      end
      object mnuViewStack2: TMenuItem
        Caption = 'Select Stack 2'
        ShortCut = 24626
        OnClick = mnuViewStack2Click
      end
      object mnuViewBar2: TMenuItem
        Caption = '-'
      end
      object mnuViewGoToMainWindow: TMenuItem
        Caption = '&GoTo Main Window'
        ShortCut = 16461
        OnClick = mnuViewGoToMainWindowClick
      end
      object mnuViewActivewindows: TMenuItem
        Caption = '&Active windows...'
        ShortCut = 16471
        OnClick = mnuViewActivewindowsClick
      end
    end
    object mnuRotate: TMenuItem
      Caption = 'Rotate'
      HelpContext = 10214
      object mnuRotateClockwise90: TMenuItem
        Caption = 'Rotate &Clockwise 90'
        ImageIndex = 17
        OnClick = mnuRotateClockwise90Click
      end
      object mnuRotateMinus90: TMenuItem
        Caption = 'Rotate &Minus 90'
        ImageIndex = 25
        OnClick = mnuRotateMinus90Click
      end
      object mnuRotate180: TMenuItem
        Caption = 'Rotate &180'
        ImageIndex = 27
        OnClick = mnuRotate180Click
      end
      object mnuRotateBar1: TMenuItem
        Caption = '-'
      end
      object mnuRotateFlipHorizontal: TMenuItem
        Caption = 'Flip &Horizontal'
        ImageIndex = 31
        OnClick = mnuRotateFlipHorizontalClick
      end
      object mnuRotateFlipVertical: TMenuItem
        Caption = 'Flip &Vertical'
        ImageIndex = 32
        OnClick = mnuRotateFlipVerticalClick
      end
    end
    object mnuCTPresets: TMenuItem
      Caption = 'CT Presets'
      HelpContext = 10214
      object mnuCTPresetsAbdomen: TMenuItem
        Caption = '&Abdomen'
        OnClick = mnuCTPresetsAbdomenClick
      end
      object mnuCTPresetsBone: TMenuItem
        Caption = '&Bone'
        OnClick = mnuCTPresetsBoneClick
      end
      object mnuCTPresetsDisk: TMenuItem
        Caption = '&Disk'
        OnClick = mnuCTPresetsDiskClick
      end
      object mnuCTPresetsHead: TMenuItem
        Caption = '&Head'
        OnClick = mnuCTPresetsHeadClick
      end
      object mnuCTPresetsLung: TMenuItem
        Caption = '&Lung'
        OnClick = mnuCTPresetsLungClick
      end
      object mnuCTPresetsMediastinum: TMenuItem
        Caption = '&Mediastinum'
        OnClick = mnuCTPresetsMediastinumClick
      end
      object mnuCTBar1: TMenuItem
        Caption = '-'
      end
      object mnuCTCustom1: TMenuItem
        Caption = 'mnuCTCustom1'
        OnClick = mnuCTCustom1Click
      end
      object mnuCTCustom2: TMenuItem
        Caption = 'mnuCTCustom2'
      end
      object mnuCTCustom3: TMenuItem
        Caption = 'mnuCTCustom3'
      end
      object mnuCTBar2: TMenuItem
        Caption = '-'
      end
      object mnuCTConfigure: TMenuItem
        Caption = '&Configure'
        OnClick = mnuCTConfigureClick
      end
    end
    object mnuViewInfo: TMenuItem
      Caption = 'ViewInfo'
      HelpContext = 10214
      object mnuViewInfoImageInfo: TMenuItem
        Caption = '&Image Info'
        ImageIndex = 56
        OnClick = mnuViewInfoImageInfoClick
      end
      object mnuViewInfoDICOMHeader: TMenuItem
        Caption = '&DICOM Header'
        OnClick = mnuViewInfoDICOMHeaderClick
      end
      object mnuViewInfotxtFile: TMenuItem
        Caption = '&Txt File Info'
        OnClick = mnuViewInfotxtFileClick
      end
      object mnuViewInfoRadiologyImageInfo: TMenuItem
        Caption = '&Radiology Image Info'
        OnClick = mnuViewInfoRadiologyImageInfoClick
      end
      object mnuViewInfoInformationAdvanced: TMenuItem
        Caption = 'Image Information &Advanced...'
        OnClick = mnuViewInfoInformationAdvancedClick
      end
    end
    object mnuFullRes: TMenuItem
      Caption = 'FullRes'
      HelpContext = 10222
      object mnuFullResView: TMenuItem
        Caption = '&View'
        OnClick = mnuFullResViewClick
      end
    end
    object ViewSettings1: TMenuItem
      Caption = 'View Settings'
      HelpContext = 10218
      object mnuViewSettings1x1: TMenuItem
        Caption = '&1x1 Stack'
        RadioItem = True
        OnClick = mnuViewSettings1x1Click
      end
      object mnuViewSettings2x1: TMenuItem
        Caption = '&2x1 Stack'
        RadioItem = True
        OnClick = mnuViewSettings2x1Click
      end
      object mnuViewSettings3x2: TMenuItem
        Caption = '&3x2 Layout'
        RadioItem = True
        OnClick = mnuViewSettings3x2Click
      end
      object mnuViewSettings4x3: TMenuItem
        Caption = '&4x3 Layout'
        RadioItem = True
        OnClick = mnuViewSettings4x3Click
      end
    end
    object mnuOptions: TMenuItem
      Caption = 'Options'
      HelpContext = 10214
      object mnuOptionsStackView: TMenuItem
        Caption = '&Stack View'
        HelpContext = 10221
        object mnuOptionsStackPageTogether: TMenuItem
          AutoCheck = True
          Caption = 'Page &Together'
          Checked = True
          OnClick = mnuOptionsStackPageTogetherClick
        end
        object mnuOptionsStackBar1: TMenuItem
          Caption = '-'
        end
        object mnuOptionsStackPageWithDifferentSettings: TMenuItem
          Caption = 'Page With &Different Settings'
          RadioItem = True
          OnClick = mnuOptionsStackPageWithDifferentSettingsClick
        end
        object mnuOptionsStackPageWithSameSettings: TMenuItem
          Caption = 'Page With &Same Settings'
          RadioItem = True
          OnClick = mnuOptionsStackPageWithSameSettingsClick
        end
        object mnuOptionsStackPageWithImageSettings: TMenuItem
          Caption = 'Page With &Image Settings'
          Checked = True
          RadioItem = True
          OnClick = mnuOptionsStackPageWithImageSettingsClick
        end
      end
      object mnuOptionsLayoutView: TMenuItem
        Caption = '&Layout View'
        HelpContext = 10219
        object mnuOptionsLayoutSelectedWindowSettings: TMenuItem
          AutoCheck = True
          Caption = 'Use Selected Window Settings'
          GroupIndex = 1
          RadioItem = True
          OnClick = mnuOptionsLayoutSelectedWindowSettingsClick
        end
        object mnuOptionsLayoutIndividualImageSettings: TMenuItem
          AutoCheck = True
          Caption = 'Use Individual Image Settings'
          Checked = True
          GroupIndex = 1
          RadioItem = True
          OnClick = mnuOptionsLayoutIndividualImageSettingsClick
        end
      end
      object mnuOptionsImageSettings: TMenuItem
        Caption = '&Image Settings'
        HelpContext = 10217
        object mnuOptionsImageSettingsDevice: TMenuItem
          Caption = 'Use &Device Window Level if Available'
          RadioItem = True
          OnClick = mnuOptionsImageSettingsDeviceClick
        end
        object mnuOptionsImageSettingsHistogram: TMenuItem
          Caption = 'Use &Histogram for Window Level'
          RadioItem = True
          OnClick = mnuOptionsImageSettingsHistogramClick
        end
      end
      object mnuOptionsMouseMagnifyShape: TMenuItem
        Caption = '&Mouse Magnify Shape'
        object mnuOptionsMouseMagnifyShapeCircle: TMenuItem
          Caption = '&Circle'
          Checked = True
          OnClick = mnuOptionsMouseMagnifyShapeCircleClick
        end
        object mnuOptionsMouseMagnifyShapeRectangle: TMenuItem
          Caption = '&Rectangle'
          OnClick = mnuOptionsMouseMagnifyShapeRectangleClick
        end
      end
      object mnuOptionsLabelsOn: TMenuItem
        AutoCheck = True
        Caption = 'Labels &On'
        OnClick = mnuOptionsLabelsOnClick
      end
    end
    object mnuTools: TMenuItem
      Caption = 'Tools'
      HelpContext = 10214
      object mnuToolsCine: TMenuItem
        Caption = '&Cine Tool'
        OnClick = mnuToolsCineClick
      end
      object CineToolFocus1: TMenuItem
        Caption = 'Cine Tool &Focus'
        ShortCut = 16451
        OnClick = CineToolFocus1Click
      end
      object mnuToolsRuler: TMenuItem
        Caption = '&Ruler/Angle Tool'
        HelpContext = 10223
        object mnuToolsRulerEnabled: TMenuItem
          Caption = 'Enable &Ruler'
          Enabled = False
          OnClick = mnuToolsRulerEnabledClick
        end
        object mnuToolsProtractorEnabled: TMenuItem
          Caption = 'Enable &Angle Tool'
          OnClick = mnuToolsProtractorEnabledClick
        end
        object mnuToolsRulerPointer: TMenuItem
          Caption = 'Ruler/Protractor &Pointer'
          OnClick = mnuToolsRulerPointerClick
        end
        object mnuToolsRulerBar1: TMenuItem
          Caption = '-'
        end
        object mnuToolsRulerDeleteSelected: TMenuItem
          Caption = '&Delete Selected Measurements'
          ShortCut = 46
          OnClick = mnuToolsRulerDeleteSelectedClick
        end
        object mnuToolsrulerClearAll: TMenuItem
          Caption = '&Clear All Measurements'
          OnClick = mnuToolsrulerClearAllClick
        end
        object mnuToolsRulerBar2: TMenuItem
          Caption = '-'
        end
        object mnuToolsRulerMeasurementOptions: TMenuItem
          Caption = 'Measurement &Options'
          OnClick = mnuToolsRulerMeasurementOptionsClick
        end
        object mnuToolsRulerMeasurementProperties: TMenuItem
          Caption = 'Measurement Proper&ties'
          OnClick = mnuToolsRulerMeasurementPropertiesClick
        end
      end
      object mnuToolsPixelValues: TMenuItem
        AutoCheck = True
        Caption = '&Pixel Values'
        OnClick = mnuToolsPixelValuesClick
      end
      object mnuToolsLog: TMenuItem
        Caption = '&Log'
        OnClick = mnuToolsLogClick
      end
    end
    object mnuHelp: TMenuItem
      Caption = 'Help'
      HelpContext = 10214
      object mnuHelpRadiologyViewer: TMenuItem
        Caption = 'Radiology Viewer...'
        ImageIndex = 28
        OnClick = mnuHelpRadiologyViewerClick
      end
      object ImageGearVersion1: TMenuItem
        Caption = 'ImageGear Version'
        OnClick = ImageGearVersion1Click
      end
      object mnuHelpAbout: TMenuItem
        Caption = '&About'
        OnClick = mnuHelpAboutClick
      end
    end
  end
  object timerReSize: TTimer
    Interval = 500
    OnTimer = timerReSizeTimer
    Left = 248
    Top = 120
  end
  object OpenDialog1: TOpenDialog
    Options = [ofHideReadOnly, ofAllowMultiSelect, ofEnableSizing]
    Left = 80
    Top = 128
  end
  object ImageList1: TImageList
    Left = 487
    Top = 112
    Bitmap = {
      494C010139003B00040010001000FFFFFFFFFF10FFFFFFFFFFFFFFFF424D3600
      000000000000360000002800000040000000F0000000010020000000000000F0
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      000000000000000000000000000000000000FEFEFE00FEFEFE00FEFEFE000000
      00000000000000000000FEFFFF00FCFFFF00FBFEFF00FCFFFF00000000000000
      00000000000000000000FEFEFE00FEFEFE000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      000000000000000000000000000000000000FEFEFE00FEFEFE00000000000000
      0000DEE0E100B0A9A300A3948700A2948800A0908400958174008F7C6E00A495
      8E00D0D0CE00FAFFFF0000000000FEFEFE000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      000000000000000000000000000000000000FEFEFE0000000000F8FCFD00CBC7
      C100A38D7800A6846700BD997700C4A48300D0AF8D00CDA78400AE8662008158
      3800684531009E938E00ECF2F300000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      000000000000000000000000000000000000FEFEFE0000000000D1CCC300B39A
      8100D3B59700EDD2B200E3B99900E9B58F00F6C29700ECB99000EDC9A500E1C2
      9E00B38C69006C43290093888100F6F9FA000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      00000000000000000000000000000000000000000000E7E4E000C0AB9500DEC4
      AA00FCE0C400FFEDCE00DFBCA000A3472000A73A1000C5886000FAE0BD00FFDF
      BC00ECCEAC00BC9977006C462F00B8B6B4000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      000000000000000000000000000000000000FCFCFD00D0C7B900D8C2AB00FCE5
      CC00FFE9CE00FFE7CC00FFF2D7009F57360084180000DFC1A300FFF0D200FFE1
      C100FDDFBF00EDD1B3009D775900867368000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      000000000000000000000000000000000000F8F7F600D0C2B200F0DECA00FFEE
      D800FEE9D300FFEBD400FBEFD700A15838008B200000E0C2A800FFF0D700FEE2
      C700FFE5C900FCE2C600CEAF9300886E5D000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      000000000000000000000000000000000000F8F7F600D7CABD00F8EAD900FFF0
      DE00FEEDDA00FFEFDB00FFFBE900A45D3E008C1E0000E0C5AD00FFF5DE00FEE7
      CE00FFE8CE00FFE8D000DEC4AC008F7767000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      000000000000000000000000000000000000F8F7F600DAD0C500F9EFE200FFF4
      E600FEF1E300FFF7E800DEC9B7008F3211007F110000DBC1AF00FFFAE800FEEB
      D500FFEBD400FFEED900E1CAB400968173000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      000000000000000000000000000000000000F9FAF800DDD7D000F6F1E900FFF9
      F000FFF5EB00FFFAEE00C6A89600AD7D6B00A4796800E5D5C800FFF8E900FEEE
      DC00FEF1E000FFF8E800DCC6B100AEA59D000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      000000000000000000000000000000000000FCFEFE00E2E3E000EAE6E200FFFC
      FA00FFFAF400FFFAF100FEFFF900EDD8CA00F5D9C300FDF8EE00FFF5E900FEF4
      E700FEFAF300FCF2E600C7B8A900D8DAD9000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      00000000000000000000000000000000000000000000F9F9F800E6E4E000F0EF
      ED00FFFEFC00FFFFFD00EFEBEA0087331B00972D0700E3D0C600FFFFFB00FFFD
      FA00FDF9F300E5DACE00D7D6D100FCFEFE000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      000000000000000000000000000000000000FEFEFE0000000000F3F5F400E9E9
      E600F2F2F100FCFCFD00FAFAF9009E7C76008F625B00F4EFEC0000000000FAF6
      F400EBE5DE00E8E6E200FDFEFE00000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      000000000000000000000000000000000000FEFEFE00FEFEFE0000000000FCFC
      FC00EAEBEB00E7EAE900F4F4F300FAFEFD00F9FDFE00F9F8F700EDECE900E5E5
      E300F3F3F2000000000000000000FEFEFE000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      000000000000000000000000000000000000FEFEFE00FEFEFE00FEFEFE000000
      0000FEFFFF00FAFBFB00FCFBFA00FDFDFE00FEFEFE00FCFBFA00F8F9F800FDFD
      FE0000000000FEFEFE00FEFEFE00FEFEFE000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      000000000000FFFFFF00FFFFFF00FFFFFF00FFFFFF00FFFFFF00000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      000000000000FFFFFF00FFFFFF00FFFFFF00FFFFFF00FFFFFF00000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      000000000000000000000000000000000000FF000000FF000000FF000000FF00
      0000FF000000FF000000FF000000FF000000FF000000FF000000FF000000FF00
      0000FF000000FF000000FF000000FF0000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      000000000000FFFFFF00FFFFFF00FFFFFF00FFFFFF00FFFFFF00FFFFFF00FFFF
      FF00000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      000000000000000000000000000000000000FF00000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000FF0000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      000000000000FFFFFF00FFFFFF00FFFFFF00FFFFFF00FFFFFF00FFFFFF000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      000000000000000000000000000000000000FF0000000000000000000000FF00
      0000FF000000FF000000FF000000FF000000FF000000FF000000FF000000FF00
      0000FF0000000000000000000000FF0000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      000000000000FFFFFF00FFFFFF00FFFFFF00FFFFFF00FFFFFF00000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      000000000000000000000000000000000000FF0000000000000000000000FF00
      0000000000000000000000000000000000000000000000000000000000000000
      0000FF0000000000000000000000FF0000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      000000000000FFFFFF00FFFFFF00FFFFFF00FFFFFF0000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      000000000000000000000000000000000000FF0000000000000000000000FF00
      0000000000000000000000000000000000000000000000000000000000000000
      0000FF0000000000000000000000FF0000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      000000000000FFFFFF00FFFFFF00FFFFFF000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      000000000000000000000000000000000000FF0000000000000000000000FF00
      0000000000000000000000000000000000000000000000000000000000000000
      0000FF0000000000000000000000FF000000000000000000000000000000C6C6
      C600C6C6C60000000000C6C6C600000000000000000000000000C6C6C6000000
      0000000000000000000000000000000000000000000000000000000000000000
      000000000000FFFFFF00FFFFFF00000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      000000000000000000000000000000000000FF00000000000000000000000000
      0000FF000000000000000000000000000000000000000000000000000000FF00
      0000000000000000000000000000FF000000000000000000000000000000C6C6
      C600C6C6C60000000000C6C6C600C6C6C6000000000000000000C6C6C6000000
      0000C6C6C600C6C6C60000000000000000000000000000000000000000000000
      000000000000FFFFFF0000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      00000000000000000000000000000000000000000000FF000000000000000000
      000000000000FF00000000000000000000000000000000000000FF0000000000
      00000000000000000000FF00000000000000000000000000000000000000C6C6
      C600C6C6C60000000000C6C6C600C6C6C60000000000C6C6C600C6C6C6000000
      000000000000C6C6C60000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000FF0000000000
      00000000000000000000FF0000000000000000000000FF000000000000000000
      000000000000FF00000000000000000000000000000000000000000000000000
      000000000000C6C6C6000000000000000000C6C6C600C6C6C60000000000C6C6
      C600C6C6C6000000000000000000000000000000000000000000C6C6C600C6C6
      C60000000000C6C6C600000000000000000000000000C6C6C600000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      000000000000000000000000000000000000000000000000000000000000FF00
      0000000000000000000000000000FF000000FF00000000000000000000000000
      0000FF0000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000C6C6C600C6C6
      C60000000000C6C6C600C6C6C6000000000000000000C6C6C60000000000C6C6
      C600C6C6C6000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000FF000000000000000000000000000000000000000000000000000000FF00
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000C6C6C600C6C6
      C60000000000C6C6C600C6C6C60000000000C6C6C600C6C6C600000000000000
      0000C6C6C6000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      000000000000FF00000000000000000000000000000000000000FF0000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000C6C6C6000000000000000000C6C6C600C6C6C60000000000C6C6C600C6C6
      C600000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      00000000000000000000FF0000000000000000000000FF000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000FF000000FF00000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      00000000000000000000FFFFFF00000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      000084FFFF000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      000000000000FFFFFF00C6C6C600848484000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000008400
      0000000000000000000000000000000000000000000000000000000000000000
      00000000000000000000000000000000000000000000000000000000000084FF
      FF0084FFFF0084FFFF0000000000000000000000000000000000000000000000
      000000000000000000000000000000000000FFFFFF00FFFFFF00FFFFFF00FFFF
      FF00FFFFFF00C6C6C600C6C6C600C6C6C6008484840000000000C6C6C600FFFF
      FF00FFFFFF00FFFFFF00FFFFFF00FFFFFF000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000840000000084
      0000840000000000000000000000000000000000000000000000000000000000
      000000000000000000000000000000000000000000000000000084FFFF0084FF
      FF0084FFFF004284FF004284FF00000000000000000000000000000000000000
      00000000000000000000000000000000000084848400C6C6C600C6C6C600C6C6
      C600FFFFFF00C6C6C600C6C6C600C6C6C600C6C6C6008484840000000000C6C6
      C600C6C6C600C6C6C600C6C6C600FFFFFF000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000084000000008400000084
      0000008400008400000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000084FFFF0084FFFF0084FF
      FF004284FF004284FF004284FF004284FF000000000000000000000000000000
      0000000000000000000000000000000000008484840000000000FFFFFF00FFFF
      FF00FFFFFF00C6C6C600C6C6C600C6C6C600C6C6C6008484840000000000FFFF
      FF00FFFFFF00FFFFFF00C6C6C600FFFFFF000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      00000000000000000000000000000000000084000000008400000084000000FF
      0000008400000084000084000000000000000000000000000000000000000000
      000000000000000000000000000000000000000000000000000084FFFF004284
      FF004284FF004284FF004284FF004284FF004284FF0000000000000000000000
      0000000000000000000000000000000000008484840000000000FFFFFF00FFFF
      FF00FFFFFF00C6C6C600C6C6C600C6C6C600C6C6C6008484840000000000FFFF
      FF00FFFFFF00FFFFFF00C6C6C600FFFFFF000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      00000000000000000000000000000000000000FF00000084000000FF00000000
      000000FF00000084000000840000840000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000004284
      FF004284FF004284FF004284FF004284FF004284FF004284FF00000000000000
      0000000000000000000000000000000000008484840000000000FFFFFF00FFFF
      FF00FFFFFF00C6C6C600C6C6C600C6C6C600C6C6C6008484840000000000FFFF
      FF00FFFFFF00FFFFFF00C6C6C600FFFFFF000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000FF0000000000000000
      00000000000000FF000000840000008400008400000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      00004284FF004284FF004284FF004284FF004284FF004284FF004284FF000000
      0000000000000000000000000000000000008484840000000000FFFFFF00FFFF
      FF00FFFFFF00C6C6C600C6C6C600C6C6C600C6C6C6008484840000000000FFFF
      FF00FFFFFF00FFFFFF00C6C6C600FFFFFF000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000FF0000008400000084000084000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000004284FF004284FF004284FF004284FF004284FF004284FF004284
      FF00000000000000000000000000000000008484840000000000FFFFFF00FFFF
      FF00FFFFFF00C6C6C600C6C6C600C6C6C600C6C6C6008484840000000000FFFF
      FF00FFFFFF00FFFFFF00C6C6C600FFFFFF000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      000000000000000000000000000000FF00000084000000840000840000000000
      0000000000000000000000000000000000000000000000000000000000000000
      000000000000000000004284FF004284FF004284FF004284FF004284FF004284
      FF004284FF000000000000000000000000008484840000000000FFFFFF00FFFF
      FF00FFFFFF00C6C6C600C6C6C600C6C6C600C6C6C6008484840000000000FFFF
      FF00FFFFFF00FFFFFF00C6C6C600FFFFFF000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      00000000000000000000000000000000000000FF000000840000008400000000
      0000000000000000000000000000000000000000000000000000000000000000
      00000000000000000000000000004284FF004284FF004284FF004284FF004284
      FF004284FF00FFFF840000000000000000008484840000000000FFFFFF00FFFF
      FF00FFFFFF00C6C6C600C6C6C600C6C6C600C6C6C6008484840000000000FFFF
      FF00FFFFFF00FFFFFF00C6C6C600FFFFFF000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000FF0000008400000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000004284FF004284FF004284FF004284
      FF00FFFF8400FFFF8400FFFF8400000000008484840000000000000000000000
      0000FFFFFF00C6C6C600C6C6C600C6C6C600C6C6C60084848400000000000000
      00000000000000000000C6C6C600FFFFFF000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      000000000000000000000000000000000000000000000000000000FF00000000
      0000000000000000000000000000000000000000000000000000000000000000
      000000000000000000000000000000000000000000004284FF004284FF00FFFF
      8400FFFF8400FFFF840000008400000000008484840084848400848484008484
      8400FFFFFF00C6C6C600C6C6C600C6C6C600C6C6C60084848400000000008484
      8400848484008484840084848400FFFFFF000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000FFFF8400FFFF
      8400FFFF8400000084000000840000000000C6C6C600C6C6C600C6C6C600C6C6
      C600FFFFFF00FFFFFF00FFFFFF00FFFFFF00FFFFFF00FFFFFF0000000000C6C6
      C600C6C6C600C6C6C600C6C6C600C6C6C6000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      000000000000000000000000000000000000000000000000000000000000FFFF
      8400000084000000840000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000C6C6C600C6C6C600C6C6C600C6C6C6000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000C6C6C600C6C6C600C6C6C600C6C6C6000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      00000000000000000000000000000000000000000000FFFFFF00FFFFFF000000
      00000000000000000000000000000000000000000000FF000000FF000000FF00
      0000FF000000FF000000FF000000FF000000FF000000FF000000FF0000000000
      0000C6C6C600C6C6C600C6C6C600C6C6C60000000000FF000000FF000000FF00
      0000FF000000FF000000FF000000FF000000FF000000FF000000FF0000000000
      0000C6C6C600C6C6C600C6C6C600C6C6C60000000000FF000000FF000000FF00
      0000FF000000FF000000FF000000FF000000FF000000FF000000FF000000FF00
      0000FF000000FF00000000000000000000000000000000000000000000000000
      00000000000000000000000000000000000000000000FFFFFF00FFFFFF000000
      00000000000000000000000000000000000000000000FF000000FF000000FF00
      0000FF000000FF000000FF000000FF000000FF000000FF000000008400000000
      00000000000000000000C6C6C600C6C6C60000000000FF000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      00000000000000000000C6C6C600C6C6C60000000000FF000000FFFFFF00FFFF
      FF00FFFFFF00FFFFFF00FFFFFF00FFFFFF00FFFFFF00FFFFFF00FFFFFF00FFFF
      FF00FFFFFF00FF00000000000000000000000000000000000000000000000000
      000000000000000000000000000000000000FFFFFF00FFFFFF00000000000000
      00000000000000000000000000000000000000000000FF000000FF000000FF00
      0000FF000000FF000000FF000000FF0000000084000000840000008400000000
      0000FF00000000000000C6C6C600C6C6C60000000000FF00000000000000FF00
      0000FF000000FF000000FF000000FF000000FF000000FF000000FF000000FF00
      0000FF00000000000000C6C6C600C6C6C60000000000FF000000FFFFFF00FFFF
      FF00FFFFFF00FFFFFF00FFFFFF00FFFFFF00FFFFFF00FFFFFF00FFFFFF00FFFF
      FF00FFFFFF00FF00000000000000000000000000000000000000000000000000
      000000000000000000000000000000000000FFFFFF00FFFFFF00000000000000
      00000000000000000000000000000000000000000000FF000000FF000000FF00
      0000FF000000FF000000FF000000FF0000000084000000840000008400000000
      00000084000000000000000000000000000000000000FF00000000000000FF00
      0000000000000000000000000000000000000000000000000000000000000000
      00000000000000000000000000000000000000000000FF000000FFFFFF00FFFF
      FF00FFFFFF00FFFFFF00FFFFFF00FFFFFF00FFFFFF00FFFFFF00FFFFFF00FFFF
      FF00FFFFFF00FF00000000000000000000000000000000000000000000000000
      0000FFFFFF000000000000000000FFFFFF00FFFFFF0000000000000000000000
      00000000000000000000000000000000000000000000FFFFFF00FFFF0000FFFF
      FF00FFFF0000FFFFFF00FFFF0000FFFFFF000084000000840000008400000000
      00000084000000000000008400000000000000000000FFFFFF0000000000FF00
      000000000000FF000000FF000000FF000000FF000000FF000000FF000000FF00
      0000FF000000FF000000FF0000000000000000000000FF000000FFFFFF00FFFF
      FF00FFFFFF00FFFFFF00FFFFFF00FFFFFF00FFFFFF00FFFFFF00FFFFFF00FFFF
      FF00FFFFFF00FF00000000000000000000000000000000000000000000000000
      0000FFFFFF00FFFFFF00FFFFFF00FFFFFF00FFFFFF0000000000000000000000
      00000000000000000000000000000000000000000000FFFF0000FFFFFF00FFFF
      0000FFFFFF00FFFF0000FFFFFF00FFFF0000FFFFFF00FFFF0000008400000000
      00000084000000000000008400000000000000000000FFFF000000000000FF00
      000000000000FF000000FF000000FF000000FF000000FF000000FF000000FF00
      0000FF000000FF000000008400000000000000000000FF000000FFFFFF00FFFF
      FF00FFFFFF00FFFFFF00FFFFFF00FFFFFF00FFFFFF00FFFFFF00FFFFFF00FFFF
      FF00FFFFFF00FF00000000000000000000000000000000000000000000000000
      0000FFFFFF00FFFFFF00FFFFFF00FFFFFF00FFFFFF0000000000000000000000
      00000000000000000000000000000000000000000000FFFFFF00FFFF0000FFFF
      FF00FFFF0000C6C6C600C6C6C600FFFFFF00FFFF0000FFFFFF00FFFF00000000
      00000084000000000000008400000000000000000000FFFFFF0000000000FFFF
      FF0000000000FF000000FF000000FF000000FF000000FF000000FF000000FF00
      00000084000000840000008400000000000000000000FF000000FFFFFF00FFFF
      FF00FFFFFF00FFFFFF00FFFFFF00FFFFFF00FFFFFF00FFFFFF00FFFFFF00FFFF
      FF00FFFFFF00FF00000000000000000000000000000000000000000000000000
      0000FFFFFF00FFFFFF00FFFFFF00FFFFFF00FFFFFF00FFFFFF00FFFFFF000000
      00000000000000000000000000000000000000000000FFFF0000FFFFFF00FFFF
      0000C6C6C600FFFFFF0000FFFF00C6C6C600FFFFFF00FFFF0000FFFFFF000000
      00000084000000000000008400000000000000000000FFFF000000000000FFFF
      000000000000FF000000FF000000FF000000FF000000FF000000FF000000FF00
      00000084000000840000008400000000000000000000FF000000FFFFFF00FFFF
      FF00FFFFFF00FFFFFF00FFFFFF00FFFFFF00FFFFFF00FFFFFF00FFFFFF00FFFF
      FF00FFFFFF00FF00000000000000000000000000000000000000000000000000
      0000FFFFFF00FFFFFF00FFFFFF00FFFFFF00FFFFFF00FFFFFF00000000000000
      00000000000000000000000000000000000000000000FFFFFF00FFFF0000FFFF
      FF00C6C6C60000FFFF00FFFFFF00C6C6C600FFFF0000FFFFFF00FFFF00000000
      0000FFFF000000000000008400000000000000000000FFFFFF0000000000FFFF
      FF0000000000FFFFFF00FFFF0000FFFFFF00FFFF0000FFFFFF00FFFF0000FFFF
      FF000084000000840000008400000000000000000000FF000000FFFFFF00FFFF
      FF00FFFFFF00FFFFFF00FFFFFF00FFFFFF00FFFFFF00FFFFFF00FFFFFF00FFFF
      FF00FFFFFF00FF00000000000000000000000000000000000000000000000000
      0000FFFFFF00FFFFFF00FFFFFF00FFFFFF00FFFFFF0000000000000000000000
      00000000000000000000000000000000000000000000FFFF0000FFFFFF00FFFF
      0000FFFFFF00C6C6C600C6C6C600FFFF0000FFFFFF00FFFF0000FFFFFF000000
      0000FFFFFF0000000000008400000000000000000000FFFF000000000000FFFF
      000000000000FFFF0000FFFFFF00FFFF0000FFFFFF00FFFF0000FFFFFF00FFFF
      0000FFFFFF00FFFF0000008400000000000000000000FF000000FFFFFF00FFFF
      FF00FFFFFF00FFFFFF00FFFFFF00FFFFFF00FFFFFF00FFFFFF00FFFFFF00FFFF
      FF00FFFFFF00FF00000000000000000000000000000000000000000000000000
      0000FFFFFF00FFFFFF00FFFFFF00FFFFFF000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000FFFF000000000000FFFF000000000000000000000000000000000000FFFF
      FF0000000000FFFFFF00FFFF0000FFFFFF00FFFF0000C6C6C600C6C6C600FFFF
      FF00FFFF0000FFFFFF00FFFF00000000000000000000FF000000FF000000FF00
      0000FF000000FF000000FF000000FF000000FF000000FF000000FF000000FF00
      0000FF000000FF00000000000000000000000000000000000000000000000000
      0000FFFFFF00FFFFFF00FFFFFF00000000000000000000000000000000000000
      000000000000000000000000000000000000C6C6C600C6C6C600C6C6C6000000
      0000FFFFFF00FFFF0000FFFFFF00FFFF0000FFFFFF00FFFF0000FFFFFF00FFFF
      0000FFFFFF0000000000FFFFFF0000000000C6C6C600C6C6C60000000000FFFF
      000000000000FFFF0000FFFFFF00FFFF0000C6C6C600FFFFFF0000FFFF00C6C6
      C600FFFFFF00FFFF0000FFFFFF00000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000FFFFFF00FFFFFF0000000000000000000000000000000000000000000000
      000000000000000000000000000000000000C6C6C600C6C6C600C6C6C6000000
      0000000000000000000000000000000000000000000000000000000000000000
      00000000000000000000FFFF000000000000C6C6C600C6C6C600000000000000
      000000000000FFFFFF00FFFF0000FFFFFF00C6C6C60000FFFF00FFFFFF00C6C6
      C600FFFF0000FFFFFF00FFFF00000000000000000000FF000000FF000000FFFF
      FF00FFFFFF00FFFFFF00FFFFFF00FFFFFF00FFFFFF00FFFFFF00FFFFFF00FFFF
      FF00FF000000FF00000000000000000000000000000000000000000000000000
      0000FFFFFF000000000000000000000000000000000000000000000000000000
      000000000000000000000000000000000000C6C6C600C6C6C600C6C6C600C6C6
      C600C6C6C60000000000FFFFFF00FFFF0000FFFFFF00FFFF0000FFFFFF00FFFF
      0000FFFFFF00FFFF0000FFFFFF0000000000C6C6C600C6C6C600C6C6C600C6C6
      C60000000000FFFF0000FFFFFF00FFFF0000FFFFFF00C6C6C600C6C6C600FFFF
      0000FFFFFF00FFFF0000FFFFFF00000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      000000000000000000000000000000000000C6C6C600C6C6C600C6C6C600C6C6
      C600C6C6C6000000000000000000000000000000000000000000000000000000
      000000000000000000000000000000000000C6C6C600C6C6C600C6C6C600C6C6
      C600000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000084848400848484008484
      8400848484008484840084848400848484008484840084848400848484008484
      84008484840084848400848484000000000000000000FFFFFF00FFFFFF00FFFF
      FF00FFFFFF00FFFFFF00FFFFFF00FFFFFF00FFFFFF00FFFFFF00FFFFFF00FFFF
      FF00FFFFFF00FFFFFF00FFFFFF000000000000008400FF000000FF000000FF00
      0000FF000000FF00000000008400000000000000000000000000000000000000
      0000000000000000000000000000000000000000840000000000000000000000
      0000000000000000000000008400000000000000840000000000000000000000
      0000000000000000000000008400000000000000000084848400848484008484
      8400848484008484840084848400848484008484840084848400848484008484
      84008484840084848400848484000000000000000000FFFFFF00000084000000
      8400FFFFFF00FFFFFF00FFFFFF00FFFFFF00FFFFFF000000840000008400FFFF
      FF00FFFFFF00FFFFFF00FFFFFF0000000000FF00000000008400000000000000
      00000000000000008400FF000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000008400000000000000
      0000000000000000840000000000000000000000000000008400000000000000
      0000000000000000840000000000000000000000000084848400848484008484
      8400848484008484840084848400848484008484840084848400848484008484
      84008484840084848400848484000000000000000000FFFFFF00000084000000
      840000008400FF000000FF000000FF000000FF0000000000840000008400FFFF
      FF00FFFFFF00FFFFFF00FFFFFF0000000000FF00000000000000000084000000
      00000000840000000000FF000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000084000000
      0000000084000000000000000000000000000000000000000000000084000000
      0000000084000000000000000000000000000000000084848400848484008484
      8400848484008484840084848400848484008484840084848400848484008484
      84008484840084848400848484000000000000000000FFFFFF00FFFFFF000000
      840000008400000084008484840084848400000084000000840000008400FFFF
      FF00FFFFFF00FFFFFF00FFFFFF0000000000FF00000000000000000000000000
      84000000000000000000FF000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      8400000000000000000000000000000000000000000000000000000000000000
      8400000000000000000000000000000000000000000084848400848484008484
      8400848484008484840084848400848484008484840084848400848484008484
      84008484840084848400848484000000000000000000FFFFFF00FFFFFF00FF00
      0000000084000000840000008400000084000000840000008400FFFFFF00FFFF
      FF00FFFFFF00FFFFFF00FFFFFF0000000000FF00000000000000000084000000
      00000000840000000000FF000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000084000000
      0000000084000000000000000000000000000000000000000000000084000000
      0000000084000000000000000000000000000000000084848400848484008484
      8400848484008484840084848400848484008484840084848400848484008484
      84008484840084848400848484000000000000000000FFFFFF00FFFFFF00FF00
      00008484840000008400000084000000840000008400FF000000FFFFFF00FFFF
      FF00FFFFFF00FFFFFF00FFFFFF0000000000FF00000000008400000000000000
      00000000000000008400FF000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000008400000000000000
      0000000000000000840000000000000000000000000000008400000000000000
      0000000000000000840000000000000000000000000084848400848484008484
      8400848484008484840084848400848484008484840084848400848484008484
      84008484840084848400848484000000000000000000FFFFFF00FFFFFF00FF00
      00008484840000008400000084000000840084848400FF000000FFFFFF00FFFF
      FF00FFFFFF00FFFFFF00FFFFFF000000000000008400FF000000FF000000FF00
      0000FF000000FF00000000008400000000000000000000000000000000000000
      0000000000000000000000000000000000000000840000000000000000000000
      0000000000000000000000008400000000000000840000000000000000000000
      0000000000000000000000008400000000000000000084848400848484008484
      8400848484008484840084848400848484008484840084848400848484008484
      84008484840084848400848484000000000000000000FFFFFF00FFFFFF00FF00
      00008484840000008400000084000000840084848400FF000000FFFFFF00FFFF
      FF00FFFFFF00FFFFFF00FFFFFF00000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000084848400848484008484
      8400848484008484840084848400848484008484840084848400848484008484
      84008484840084848400848484000000000000000000FFFFFF00FFFFFF00FF00
      00000000840000008400848484000000840000008400FF000000FFFFFF00FFFF
      FF00FFFFFF00FFFFFF00FFFFFF00000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000840000000000000000000000
      0000000000000000000000008400000000000000840000000000000000000000
      0000000000000000000000008400000000000000000084848400848484008484
      8400848484008484840084848400848484008484840084848400848484008484
      84008484840084848400848484000000000000000000FFFFFF00FFFFFF000000
      840000008400FF000000FF000000FF0000000000840000008400FFFFFF00FFFF
      FF00FFFFFF00FFFFFF00FFFFFF00000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000008400000000000000
      0000000000000000840000000000000000000000000000008400000000000000
      0000000000000000840000000000000000000000000084848400848484008484
      8400848484008484840084848400848484008484840084848400848484008484
      84008484840084848400848484000000000000000000FFFFFF00000084000000
      8400FFFFFF00FFFFFF00FFFFFF00FFFFFF00FFFFFF000000840000008400FFFF
      FF00FFFFFF00FFFFFF00FFFFFF00000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000084000000
      0000000084000000000000000000000000000000000000000000000084000000
      0000000084000000000000000000000000000000000084848400848484008484
      8400848484008484840084848400848484008484840084848400848484008484
      84008484840084848400848484000000000000000000FFFFFF00FFFFFF00FFFF
      FF00FFFFFF00FFFFFF00FFFFFF00FFFFFF00FFFFFF00FFFFFF00FFFFFF00FFFF
      FF00FFFFFF00FFFFFF00FFFFFF00000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      8400000000000000000000000000000000000000000000000000000000000000
      8400000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000084000000
      0000000084000000000000000000000000000000000000000000000084000000
      00000000840000000000000000000000000000000000FF000000FF000000FFFF
      FF00FFFFFF00FFFFFF00FFFFFF00FFFFFF00FFFFFF00FFFFFF00FFFFFF00FFFF
      FF00FFFFFF00FF000000FF0000000000000000000000FF000000FF000000FFFF
      FF00FFFFFF00FFFFFF00FFFFFF00FFFFFF00FFFFFF00FFFFFF00FFFFFF00FFFF
      FF00FFFFFF00FF000000FF000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000008400000000000000
      0000000000000000840000000000000000000000000000008400000000000000
      0000000000000000840000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000840000000000000000000000
      0000000000000000000000008400000000000000840000000000000000000000
      0000000000000000000000008400000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000084848400848484008484
      8400848484000000000084848400848484008484840084848400000000008484
      84000000840084848400848484000000000000000000C6C6C600C6C6C600C6C6
      C600C6C6C600C6C6C600C6C6C600C6C6C600C6C6C600C6C6C600C6C6C600C6C6
      C600C6C6C600C6C6C600C6C6C600000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      00000000000000000000000000000000000000000000FF000000FF000000FF00
      0000FF000000FF000000FF000000FF000000FF000000FF000000FF000000FF00
      0000FF000000FF000000FF000000000000000000000084848400848484008484
      8400848484000000000084848400848484008484840084848400000000000000
      84000000840000008400848484000000000000000000C6C6C600FFFFFF00FFFF
      FF00FFFFFF00FFFFFF00FFFFFF00FFFFFF00FFFFFF00FFFFFF00FFFFFF00FFFF
      FF00FFFFFF00FFFFFF00C6C6C600000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      00000000000000000000000000000000000000000000FF000000FFFFFF00FFFF
      FF00FFFFFF00FFFFFF00FFFFFF00FFFFFF00FFFFFF00FFFFFF00FFFFFF00FFFF
      FF00FFFFFF00FFFFFF00FF000000000000000000000084848400848484000000
      8400848484000000000084848400848484008484840084848400000084000000
      84000000840000008400000084000000000000000000C6C6C600FFFFFF00FFFF
      FF00FFFFFF00FFFFFF00FFFFFF00FFFFFF00FFFFFF00FFFFFF00FFFFFF00FFFF
      FF00FFFFFF00FFFFFF00C6C6C600000000000000000000000000FF000000FF00
      0000FF000000FF000000FF000000FF0000000000000000000000000000000000
      00000000000000000000000000000000000000000000FF000000FFFFFF00FFFF
      FF00FFFFFF00FFFFFF00FFFFFF00FFFFFF00FFFFFF00FFFFFF00FFFFFF00FFFF
      FF00FFFFFF00FFFFFF00FF000000000000000000000084848400000084000000
      8400000084000000000084848400848484008484840000008400000084000000
      84000000840000008400000084000000840000000000C6C6C600FFFFFF00FFFF
      FF00FFFFFF00FFFFFF00FFFFFF00FFFFFF00FFFFFF00FFFFFF00FFFFFF00FFFF
      FF00FFFFFF00FFFFFF00C6C6C600000000000000000000000000FF000000FFFF
      FF00FFFFFF00FFFFFF00FFFFFF00FF0000000000000000000000000000000000
      00000000000000000000000000000000000000000000FF000000FFFFFF00FFFF
      FF00FFFFFF00FFFFFF00FFFFFF00FFFFFF00FFFFFF00FFFFFF00FFFFFF00FFFF
      FF00FFFFFF00FFFFFF00FF000000000000000000000000008400000084000000
      8400000084000000840000000000000000000000000000000000000000000000
      84000000840000008400000000000000000000000000C6C6C600FFFFFF00FFFF
      FF00FFFFFF00FFFFFF00FFFFFF00FFFFFF00FFFFFF00FFFFFF00FFFFFF00FFFF
      FF00FFFFFF00FFFFFF00C6C6C600000000000000000000000000FF000000FFFF
      FF00FFFFFF00FFFFFF0000000000FF0000000000000000000000000000000000
      00000000000000000000000000000000000000000000FF000000FFFFFF00FFFF
      FF00FFFFFF00FFFFFF00FFFFFF00FFFFFF00FFFFFF00FFFFFF00FFFFFF00FFFF
      FF00FFFFFF00FFFFFF00FF000000000000000000840000008400000084000000
      8400000084000000840000008400848484008484840084848400000000000000
      84000000840000008400FFFFFF000000000000000000C6C6C600FFFFFF00FFFF
      FF00FFFFFF00FFFFFF00FFFFFF00FFFFFF00FFFFFF00FFFFFF00FFFFFF00FFFF
      FF00FFFFFF00FFFFFF00C6C6C600000000000000000000000000FF000000FFFF
      FF00FFFFFF000000000000000000000000000000000000000000000000000000
      00000000000000000000000000000000000000000000FF000000FFFFFF00FFFF
      FF00FFFFFF00FFFFFF00FFFFFF00FFFFFF00FFFFFF00FFFFFF00FFFFFF00FFFF
      FF00FFFFFF00FFFFFF00FF000000000000000000000084848400000084000000
      840000008400000000008484840084848400FFFFFF00FFFFFF00000000000000
      84000000840000008400FFFFFF000000000000000000C6C6C600FFFFFF00FFFF
      FF00FFFFFF00FFFFFF00FFFFFF00FFFFFF00FFFFFF00FFFFFF00FFFFFF00FFFF
      FF00FFFFFF00FFFFFF00C6C6C600000000000000000000000000FF000000FF00
      0000FF000000FF00000000000000000000000000000000000000000000000000
      00000000000000000000000000000000000000000000FF000000FFFFFF00FFFF
      FF00FFFFFF00FFFFFF00FFFFFF00FFFFFF00FFFFFF00FFFFFF00FFFFFF00FFFF
      FF00FFFFFF00FFFFFF00FF000000000000000000000084848400000084000000
      8400000084000000000084848400FFFFFF00FFFFFF00FFFFFF00000000000000
      84000000840000008400FFFFFF000000000000000000C6C6C600FFFFFF00FFFF
      FF00FFFFFF00FFFFFF00FFFFFF00FFFFFF00FFFFFF00FFFFFF00FFFFFF00FFFF
      FF00FFFFFF00FFFFFF00C6C6C600000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      00000000000000000000000000000000000000000000FF000000FFFFFF00FFFF
      FF00FFFFFF00FFFFFF00FFFFFF00FFFFFF00FFFFFF00FFFFFF00FFFFFF00FFFF
      FF00FFFFFF00FFFFFF00FF000000000000000000000084848400000084000000
      84000000840000000000FFFFFF00FFFFFF00FFFFFF00FFFFFF0000000000FFFF
      FF00FFFFFF00FFFFFF00FFFFFF000000000000000000C6C6C600FFFFFF00FFFF
      FF00FFFFFF00FFFFFF00FFFFFF00FFFFFF00FFFFFF00FFFFFF00FFFFFF00FFFF
      FF00FFFFFF00FFFFFF00C6C6C600000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      00000000000000000000000000000000000000000000FF000000FFFFFF00FFFF
      FF00FFFFFF00FFFFFF00FFFFFF00FFFFFF00FFFFFF00FFFFFF00FFFFFF00FFFF
      FF00FFFFFF00FFFFFF00FF000000000000000000000000000000000084000000
      8400000084000000000000000000000000000000000000000000000000000000
      00000000000000000000000000000000000000000000C6C6C600FFFFFF00FFFF
      FF00FFFFFF00FFFFFF00FFFFFF00FFFFFF00FFFFFF00FFFFFF00FFFFFF00FFFF
      FF00FFFFFF00FFFFFF00C6C6C600000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      00000000000000000000000000000000000000000000FF000000FFFFFF00FFFF
      FF00FFFFFF00FFFFFF00FFFFFF00FFFFFF00FFFFFF00FFFFFF00FFFFFF00FFFF
      FF00FFFFFF00FFFFFF00FF0000000000000000000000FFFFFF00000084000000
      84000000840000000000FFFFFF00FFFFFF00FFFFFF00FFFFFF0000000000FFFF
      FF00FFFFFF00FFFFFF00FFFFFF000000000000000000C6C6C600FFFFFF00FFFF
      FF00FFFFFF00FFFFFF00FFFFFF00FFFFFF00FFFFFF00FFFFFF00FFFFFF00FFFF
      FF00FFFFFF00FFFFFF00C6C6C600000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      00000000000000000000000000000000000000000000FF000000FFFFFF00FFFF
      FF00FFFFFF00FFFFFF00FFFFFF00FFFFFF00FFFFFF00FFFFFF00FFFFFF00FFFF
      FF00FFFFFF00FFFFFF00FF0000000000000000000000FFFFFF00000084000000
      84000000840000000000FFFFFF00FFFFFF00FFFFFF00FFFFFF0000000000FFFF
      FF00FFFFFF00FFFFFF00FFFFFF000000000000000000C6C6C600C6C6C600C6C6
      C600C6C6C600C6C6C600C6C6C600C6C6C600C6C6C600C6C6C600C6C6C600C6C6
      C600C6C6C600C6C6C600C6C6C6000000000000000000FF000000FF0000000000
      000000000000000000000000000000000000FF000000FF000000000000000000
      00000000000000000000000000000000000000000000FF000000FF000000FF00
      0000FF000000FF000000FF000000FF000000FF000000FF000000FF000000FF00
      0000FF000000FF000000FF0000000000000000000000FFFFFF00FFFFFF00FFFF
      FF00FFFFFF0000000000FFFFFF00FFFFFF00FFFFFF00FFFFFF0000000000FFFF
      FF00FFFFFF00FFFFFF00FFFFFF00000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      00000000000000000000000000000000000000000000FFFFFF00FFFFFF00FFFF
      FF00FFFFFF0000000000FFFFFF00FFFFFF00FFFFFF00FFFFFF0000000000FFFF
      FF00FFFFFF00FFFFFF00FFFFFF000000000000000000FF000000FF000000FFFF
      FF00FFFFFF00FFFFFF00FFFFFF00FFFFFF00FFFFFF00FFFFFF00FFFFFF00FFFF
      FF00FFFFFF00FF000000FF000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      00000000000000000000000000000000000000000000FF000000FF000000FFFF
      FF00FFFFFF00FFFFFF00FFFFFF00FFFFFF00FFFFFF00FFFFFF00FFFFFF00FFFF
      FF00FFFFFF00FF000000FF000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000FF000000FF00
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      00000000000000000000000000000000000000000000FFFFFF00FFFFFF00FFFF
      FF00FFFFFF00FFFFFF00FFFFFF00FFFFFF00FFFFFF00FFFFFF00FFFFFF00FFFF
      FF00FFFFFF00FFFFFF00FFFFFF00000000000000000000000000000000000000
      00000000000000000000000000000000000000000000FF000000FF000000FF00
      0000FF0000000000000000000000000000000000000000000000848484008484
      8400848484008484840084848400848484008484840084848400848484008484
      8400848484008484840000000000000000000000000000000000848484008484
      8400848484008484840084848400848484000000000000000000000000000000
      00000000000000000000000000000000000000000000FFFFFF00FFFFFF00FFFF
      FF00FFFFFF00FFFFFF00FFFFFF00FFFFFF00FFFFFF00FFFFFF00FFFFFF00FFFF
      FF00FFFFFF00FFFFFF00FFFFFF00000000000000000000000000000000000000
      000000000000000000000000000000000000FF000000FF000000FF000000FF00
      0000FF000000FF00000000000000000000000000000000000000848484008484
      8400848484008484840084848400848484008484840084848400848484008484
      8400848484008484840000000000000000000000000000000000848484008484
      8400848484008484840084848400848484000000000000000000000000000000
      00000000000000000000000000000000000000000000FFFFFF00FFFFFF00FFFF
      FF00FFFFFF00FFFFFF00FFFFFF00FFFFFF00FFFFFF00FFFFFF00FFFFFF00FFFF
      FF00FFFFFF00FFFFFF00FFFFFF00000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000FF000000FF00
      0000000000000000000000000000000000000000000000000000848484008484
      8400848484008484840084848400848484008484840084848400848484008484
      8400848484008484840000000000000000000000000000000000848484008484
      8400848484008484840000000000848484000000000000000000000000000000
      00000000000000000000000000000000000000000000FFFFFF00FFFFFF00FFFF
      FF00FFFFFF00FFFFFF00FFFFFF00FFFFFF00FFFFFF00FFFFFF00FFFFFF00FFFF
      FF00FFFFFF00FFFFFF00FFFFFF00000000000000000000000000000000000000
      0000FF000000FF00000000000000000000000000000000000000FF000000FF00
      0000000000000000000000000000000000000000000000000000848484008484
      8400848484008484840084848400848484008484840084848400848484008484
      8400848484008484840000000000000000000000000000000000848484008484
      8400848484000000000000000000000000000000000000000000000000000000
      00000000000000000000000000000000000000000000FFFFFF00FFFFFF00FFFF
      FF00FFFFFF00FFFFFF00FFFFFF00FFFFFF00FFFFFF00FFFFFF00FFFFFF00FFFF
      FF00FFFFFF00FFFFFF00FFFFFF00000000000000000000000000000000000000
      0000FF000000FF00000000000000000000000000000000000000FF000000FF00
      0000000000000000000000000000000000000000000000000000848484008484
      8400848484008484840084848400848484008484840084848400848484008484
      8400848484008484840000000000000000000000000000000000848484008484
      8400848484008484840000000000000000000000000000000000000000000000
      00000000000000000000000000000000000000000000FFFFFF00FFFFFF00FFFF
      FF00FFFFFF00FFFFFF00FFFFFF00FFFFFF00FFFFFF00FFFFFF00FFFFFF00FFFF
      FF00FFFFFF00FFFFFF00FFFFFF00000000000000000000000000000000000000
      0000FF000000FF00000000000000000000000000000000000000FF000000FF00
      0000000000000000000000000000000000000000000000000000848484008484
      8400848484008484840084848400848484008484840084848400848484008484
      8400848484008484840000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      00000000000000000000000000000000000000000000FFFFFF00FFFFFF00FFFF
      FF00FFFFFF00FFFFFF00FFFFFF00FFFFFF00FFFFFF00FFFFFF00FFFFFF00FFFF
      FF00FFFFFF00FFFFFF00FFFFFF00000000000000000000000000000000000000
      0000FF000000FF00000000000000000000000000000000000000FF000000FF00
      0000000000000000000000000000000000000000000000000000848484008484
      8400848484008484840084848400848484008484840084848400848484008484
      8400848484008484840000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      00000000000000000000000000000000000000000000FFFFFF00FFFFFF00FFFF
      FF00FFFFFF00FFFFFF00FFFFFF00FFFFFF00FFFFFF00FFFFFF00FFFFFF00FFFF
      FF00FFFFFF00FFFFFF00FFFFFF00000000000000000000000000000000000000
      0000FF000000FF00000000000000000000000000000000000000FF000000FF00
      0000000000000000000000000000000000000000000000000000848484008484
      8400848484008484840084848400848484008484840084848400848484008484
      84008484840084848400000000000000000000000000FF000000FF0000000000
      0000000000000000000000000000FF000000FF00000000000000000000000000
      00000000000000000000000000000000000000000000FFFFFF00FFFFFF00FFFF
      FF00FFFFFF00FFFFFF00FFFFFF00FFFFFF00FFFFFF00FFFFFF00FFFFFF00FFFF
      FF00FFFFFF00FFFFFF00FFFFFF00000000000000000000000000000000000000
      0000FF000000FF00000000000000000000000000000000000000FF000000FF00
      0000000000000000000000000000000000000000000000000000848484008484
      8400848484008484840084848400848484008484840084848400848484008484
      8400848484008484840000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      00000000000000000000000000000000000000000000FFFFFF00FFFFFF00FFFF
      FF00FFFFFF00FFFFFF00FFFFFF00FFFFFF00FFFFFF00FFFFFF00FFFFFF00FFFF
      FF00FFFFFF00FFFFFF00FFFFFF00000000000000000000000000000000000000
      0000FF000000FF00000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000848484008484
      8400848484008484840084848400848484008484840084848400848484008484
      8400848484008484840000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      00000000000000000000000000000000000000000000FFFFFF00FFFFFF00FFFF
      FF00FFFFFF00FFFFFF00FFFFFF00FFFFFF00FFFFFF00FFFFFF00FFFFFF00FFFF
      FF00FFFFFF00FFFFFF00FFFFFF00000000000000000000000000FF000000FF00
      0000FF000000FF000000FF000000FF0000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      00000000000000000000000000000000000000000000FFFFFF00FFFFFF00FFFF
      FF00FFFFFF00FFFFFF00FFFFFF00FFFFFF00FFFFFF00FFFFFF00FFFFFF00FFFF
      FF00FFFFFF00FFFFFF00FFFFFF0000000000000000000000000000000000FF00
      0000FF000000FF000000FF000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000FF000000FF00000000000000000000000000000000000000000000000000
      00000000000000000000000000000000000000000000FF000000FF0000000000
      0000000000000000000000000000000000000000000000000000000000000000
      000000000000FF000000FF000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      00000000000000000000000000000000000000000000FF000000FF000000FFFF
      FF00FFFFFF00FFFFFF00FFFFFF00FFFFFF00FFFFFF00FFFFFF00FFFFFF00FFFF
      FF00FFFFFF00FF000000FF000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000084000000840000008400
      0000840000008400000084000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000FFFF0000FFFF0000FFFF0000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000084000000000000000000
      0000000000000000000084000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000FF0000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000084848400848484000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000084000000000000000000
      0000000000000000000084000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000FF000000FF00000000000000000000000000000000000000000000000000
      0000000000000000000000FFFF0000FFFF0000FFFF0000000000848484008484
      8400848484008484840000000000000000000000000000000000FF0000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000FF0000000000000084000000000000000000
      0000000000000000000084000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      00000000000000000000FF000000FF000000FF000000FF000000FF000000FF00
      0000FF000000FF000000FF000000000000000000000000000000000000000000
      0000000000000000000000FFFF0000FFFF0000FFFF0000000000000000000000
      0000000000008484840084848400848484000000000000000000FF0000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000FF0000000000000084000000FF000000FF00
      0000FF000000FF00000084000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      00000000000000000000FF000000FF000000FF000000FF000000FF000000FF00
      0000FF000000FF000000FF000000000000000000000000000000000000000000
      0000000000000000000000FFFF0000FFFF0000FFFF0000000000848484008484
      8400848484008484840084848400848484000000000000000000FF0000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000FF0000000000000084000000840000008400
      0000840000008400000084000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000FF000000FF00000000000000000000000000000000000000000000000000
      00000000000000000000000000000000000000FFFF0000FFFF00000000000000
      0000848484008484840084848400000000000000000000000000FF0000000000
      00000000000000000000FF0000000000000000000000FF000000000000000000
      0000000000000000000000000000FF0000000000000000000000000000000000
      00000000000000000000000000000000000000000000FF000000FF000000FF00
      0000FF000000FF00000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000FF000000000000000000000000000000000000000000000000FFFF0000FF
      FF00000000000000000000000000000000000000000000FFFF0000FFFF000000
      0000000000000000000000000000000000000000000000000000FF0000000000
      000000000000FF000000FF000000FF000000FF000000FF000000FF0000000000
      0000000000000000000000000000FF0000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      000000000000000000000000000000000000000000000000000000000000FF00
      0000000000000000000000000000000000000000000000000000000000000000
      000000000000000000000000000000000000000000000000000000FFFF0000FF
      FF0000FFFF0000000000000000000000000000FFFF0000FFFF0000FFFF000000
      0000000000000000000000000000000000000000000000000000FF0000000000
      00000000000000000000FF0000000000000000000000FF000000000000000000
      0000000000000000000000000000FF0000000000000084848400848484008484
      8400848484008484840084848400000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000FF000000FF00
      0000000000000000000000000000000000000000000000000000000000000000
      00000000000000000000000000000000000000000000000000000000000000FF
      FF0000FFFF0000FFFF0000FFFF0000FFFF0000FFFF0000FFFF00000000008484
      840000000000000000000000000000000000FF000000FF000000FF0000000000
      0000000000000000000000000000000000000000000000000000000000000000
      000000000000FF000000FF000000FF0000000000000084848400000000000000
      0000000000000000000084848400000000000000000000000000000000000000
      00000000000000000000000000000000000000000000FF000000FF000000FF00
      0000FF000000FF000000FF000000FF000000FF000000FF000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      000000FFFF0000FFFF0000FFFF0000FFFF0000FFFF00000000000000000000FF
      FF000000000000000000000000000000000000000000FF000000FF0000000000
      0000000000000000000000000000000000000000000000000000000000000000
      00000000000000000000FF000000FF0000000000000084848400000000000000
      0000000000000000000084848400000000000000000000000000000000000000
      00000000000000000000000000000000000000000000FF000000FF000000FF00
      0000FF000000FF000000FF000000FF000000FF000000FF000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      000000000000000000000000000000000000000000000000000000FFFF0000FF
      FF00000000000000000000000000000000000000000000000000FF0000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000FF0000000000000084848400000000000000
      0000000000000000000084848400000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000FF000000FF00
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000FFFF0000FFFF0000FFFF0000FFFF0000FFFF000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000084848400FF000000FF00
      0000FF000000FF00000084848400000000000000000000000000000000000000
      0000FF000000FF0000000000000000000000000000000000000000000000FF00
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000084848400848484008484
      8400848484008484840084848400000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000FF0000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      00000000000000000000FF000000FF000000FF000000FF000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      000000000000FF000000FF000000FF000000FFFFFF00FFFFFF00FF000000FF00
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000FF0000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      000000000000FF00000000000000000000000000000000000000000000000000
      00000000000000000000FF000000FF000000FF000000FF000000FFFFFF00FFFF
      FF00FF000000FF0000000000000000000000000000000000000000000000FF00
      0000000000000000000000000000000000000000000000000000000000000000
      0000FF00000000000000000000000000000000000000FF000000FF000000FF00
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000FF000000FF000000FF000000000000000000000000000000000000000000
      0000000000000000000000000000FF0000000000000000000000FF000000FF00
      0000FFFFFF00FFFFFF00FF000000000000000000000000000000FF000000FF00
      0000000000000000000000000000000000000000000000000000000000000000
      0000FF000000FF0000000000000000000000FF000000FF000000FF000000FF00
      0000FF0000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      000000000000000000000000000000000000000000000000000000000000FF00
      0000FF000000FF000000FF000000FF0000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000FF000000FFFFFF00FF0000000000000000000000FF000000FF0000000000
      0000000000000000000000000000000000000000000000000000000000000000
      000000000000FF000000FF0000000000000000000000FF000000FFFFFF00FF00
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000FF000000FFFFFF00FF000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      000000000000FF000000FFFFFF00FF00000000000000FF000000FF0000000000
      0000000000000000000000000000000000000000000000000000000000000000
      000000000000FF000000FF0000000000000000000000FF000000FFFFFF00FF00
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000FF000000FFFFFF00FF000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      000000000000FF000000FFFFFF00FF0000000000000000000000FF000000FF00
      0000000000000000000000000000000000000000000000000000000000000000
      0000FF000000FF00000000000000000000000000000000000000FF000000FFFF
      FF00FF0000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      000000000000000000000000000000000000000000000000000000000000FF00
      0000FFFFFF00FF00000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      000000000000FF000000FFFFFF00FF000000000000000000000000000000FF00
      0000000000000000000000000000000000000000000000000000000000000000
      0000FF0000000000000000000000000000000000000000000000FF000000FFFF
      FF00FF0000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      000000000000000000000000000000000000000000000000000000000000FF00
      0000FFFFFF00FF00000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000FF000000FFFFFF00FF000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      000000000000000000000000000000000000000000000000000000000000FF00
      0000FFFFFF00FF00000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000FF000000FFFF
      FF00FF0000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000FF000000FF00
      0000FFFFFF00FFFFFF00FF000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      000000000000000000000000000000000000000000000000000000000000FF00
      0000FFFFFF00FFFFFF00FF000000FF0000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      000000000000000000000000000000000000FF000000FF000000FFFFFF00FFFF
      FF00FF0000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000FF000000FF000000FF000000FFFFFF00FFFF
      FF00FF000000FF00000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000FF000000FF000000FFFFFF00FFFFFF00FF000000FF000000FF0000000000
      0000000000000000000000000000000000000000000000000000000000000000
      000000000000FF000000FF000000FF000000FFFFFF00FFFFFF00FF000000FF00
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000FF000000FFFFFF00FFFFFF00FF000000FF00
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      00000000000000000000FF000000FF000000FFFFFF00FFFFFF00FF0000000000
      0000000000000000000000000000000000000000000000000000000000000000
      000000000000FF000000FFFFFF00FFFFFF00FF000000FF000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000FF000000FF000000FF000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      000000000000000000000000000000000000FF000000FF000000FF0000000000
      0000000000000000000000000000000000000000000000000000000000000000
      000000000000FF000000FF000000FF0000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000FF000000FF00000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000FF000000FF00000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      00000000000000000000FFFFFF00FFFFFF00FFFFFF00FFFFFF00FFFFFF00FFFF
      FF00FFFFFF00FFFFFF00000000000000000000000000FFFFFF00FFFFFF00FFFF
      FF00FFFFFF00FFFFFF00000000000000000000000000FFFFFF00FFFFFF00FFFF
      FF00FFFFFF00FFFFFF0000000000000000000000000000000000000000000000
      00000000000000000000FF000000FF000000FF000000FF000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      00000000000000000000FF000000FF000000FF000000FF000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      00000000000000000000FFFFFF00FFFFFF00FFFFFF00FFFFFF00FFFFFF00FFFF
      FF00FFFFFF00FFFFFF00000000000000000000000000FFFFFF00FFFFFF00FFFF
      FF00FFFFFF00FFFFFF00000000000000000000000000FFFFFF00FFFFFF00FFFF
      FF00FFFFFF00FFFFFF0000000000000000000000000000000000000000000000
      000000000000FF000000FF0000000000000000000000FF000000FF0000000000
      0000000000000000000000000000000000000000000000000000000000000000
      000000000000FF000000FF0000000000000000000000FF000000FF0000000000
      0000000000000000000000000000000000000000000000000000000000000000
      00000000000000000000FFFFFF00FFFFFF00FFFFFF00FFFFFF00FFFFFF00FFFF
      FF00FFFFFF00FFFFFF00000000000000000000000000FFFFFF00FFFFFF00FFFF
      FF00FFFFFF00FFFFFF00000000000000000000000000FFFFFF00FFFFFF00FFFF
      FF00FFFFFF00FFFFFF0000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      00000000000000000000FFFFFF00FFFFFF00FFFFFF00FFFFFF00FFFFFF00FFFF
      FF00FFFFFF00FFFFFF00000000000000000000000000FFFFFF00FFFFFF00FFFF
      FF00FFFFFF00FFFFFF00000000000000000000000000FFFFFF00FFFFFF00FFFF
      FF00FFFFFF00FFFFFF000000000000000000000000000000000000000000FF00
      0000000000000000000000000000000000000000000000000000000000000000
      0000FF0000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      00000000000000000000FFFFFF00FFFFFF0000000000FFFFFF00FFFFFF00FFFF
      FF00FFFFFF00FFFFFF00000000000000000000000000FF000000FF000000FF00
      0000FF000000FF000000000000000000000000000000FF000000FF000000FF00
      0000FF000000FF00000000000000000000000000000000000000FF000000FF00
      0000000000000000000000000000000000000000000000000000000000000000
      0000FF000000FF00000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      00000000000000000000FFFFFF0000000000FFFFFF00FFFFFF00FFFFFF00FFFF
      FF00FFFFFF00FFFFFF0000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      00000000000000000000000000000000000000000000FF000000FF0000000000
      0000000000000000000000000000000000000000000000000000000000000000
      000000000000FF000000FF000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000FF000000FF000000FF000000FF000000FF00
      0000FF000000FF00000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      00000000000000000000000000000000000000000000FF000000FF0000000000
      0000000000000000000000000000000000000000000000000000000000000000
      000000000000FF000000FF000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000FF000000FF00
      0000000000000000000000000000000000000000000000000000000000000000
      0000FF000000FF00000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      00000000000000000000000000000000000000000000FFFFFF00FFFFFF00FFFF
      FF00FFFFFF00FFFFFF00000000000000000000000000FFFFFF00FFFFFF00FFFF
      FF00FFFFFF00FFFFFF000000000000000000000000000000000000000000FF00
      0000000000000000000000000000000000000000000000000000000000000000
      0000FF0000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      00000000000000000000000000000000000000000000FFFFFF00FFFFFF00FFFF
      FF00FFFFFF00FFFFFF00000000000000000000000000FFFFFF00FFFFFF00FFFF
      FF00FFFFFF00FFFFFF0000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      00000000000000000000000000000000000000000000FFFFFF00FFFFFF00FFFF
      FF00FFFFFF00FFFFFF00000000000000000000000000FFFFFF00FFFFFF00FFFF
      FF00FFFFFF00FFFFFF0000000000000000000000000000000000000000000000
      000000000000FF000000FF0000000000000000000000FF000000FF0000000000
      0000000000000000000000000000000000000000000000000000000000000000
      000000000000FF000000FF0000000000000000000000FF000000FF0000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      00000000000000000000000000000000000000000000FFFFFF00FFFFFF00FFFF
      FF00FFFFFF00FFFFFF00000000000000000000000000FFFFFF00FFFFFF00FFFF
      FF00FFFFFF00FFFFFF0000000000000000000000000000000000000000000000
      00000000000000000000FF000000FF000000FF000000FF000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      00000000000000000000FF000000FF000000FF000000FF000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      00000000000000000000000000000000000000000000FF000000FF000000FF00
      0000FF000000FF000000000000000000000000000000FF000000FF000000FF00
      0000FF000000FF00000000000000000000000000000000000000000000000000
      0000000000000000000000000000FF000000FF00000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000FF000000FF00000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      000000000000FF00000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000084848400000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000FF000000FF000000FF000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000008484840084848400848484000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      000000000000000000000000000000000000000000000000000000000000FF00
      0000FF000000FF000000FF000000FF0000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      00000000000000000000000000000000000000000000FFFFFF00FFFFFF00FFFF
      FF00FFFFFF00FFFFFF00FFFFFF00000000008484840084848400848484000000
      0000FFFFFF00FFFFFF00FFFFFF00000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000FF000000FFFFFF00FF000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000008484840084848400848484000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000FF000000FFFFFF00FF000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000008484840084848400848484000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000FF000000FFFFFF00FF000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000FF000000FFFFFF00FF000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      000000000000000000000000000000000000000000000000000000000000FF00
      0000FFFFFF00FF00000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000848484000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      000000000000000000000000000000000000000000000000000000000000FF00
      0000FFFFFF00FF00000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000008484
      8400848484008484840000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000FF000000FFFF
      FF00FF0000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      00000000000000000000000000000000000000000000FFFFFF00000000008484
      8400848484008484840000000000FFFFFF00FFFFFF00FFFFFF00FFFFFF00FFFF
      FF00FFFFFF00FFFFFF00FFFFFF00000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      000000000000000000000000000000000000FF000000FF000000FFFFFF00FFFF
      FF00FF0000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000008484
      8400848484008484840000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      000000000000FF000000FF000000FF000000FFFFFF00FFFFFF00FF000000FF00
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000008484
      8400848484008484840000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      000000000000FF000000FFFFFF00FFFFFF00FF000000FF000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      000000000000FF000000FF000000FF0000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      000000000000000000000000000000FFFF007B7B7B00FFFFFF00FFFFFF00FFFF
      FF00FFFFFF00FFFFFF0000FFFF00000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000FF000000FF000000FF000000FF000000FF00000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      000000000000FFFFFF00FFFFFF00FFFFFF00FFFFFF00FFFFFF00000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      000000000000000000000000000000FFFF007B7B7B00FFFFFF00FFFFFF00FFFF
      FF00FFFFFF00FFFFFF0000FFFF00000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      FF000000FF000000FF000000FF00000000000000FF000000FF000000FF000000
      FF0000000000000000000000000000000000000000000000000000000000FFFF
      FF00FFFFFF00FFFFFF00FFFFFF0000000000FFFFFF00FFFFFF00FFFFFF00FFFF
      FF00000000000000000000000000000000000000000000000000000000000000
      000000000000000000000000000000FFFF007B7B7B00FFFFFF00FFFFFF00FFFF
      FF00FFFFFF00FFFFFF0000FFFF00000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000FF00000000000000FF000000
      FF000000FF0000000000000000000000000084848400000000000000FF000000
      FF000000FF00000000000000000000000000FFFFFF0000000000FFFFFF00FFFF
      FF00FFFFFF000000000000000000000000008484840000000000FFFFFF00FFFF
      FF00FFFFFF000000000000000000000000000000000000000000000000000000
      000000000000000000000000000000FFFF007B7B7B00FFFFFF00FFFFFF00FFFF
      FF00FFFFFF00FFFFFF0000FFFF00000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000FF000000FF000000FF000000
      FF00000000000000000000000000000000000000000000000000000000000000
      FF000000FF000000FF000000000000000000FFFFFF00FFFFFF00FFFFFF00FFFF
      FF0000000000000000000000000000000000000000000000000000000000FFFF
      FF00FFFFFF00FFFFFF0000000000000000000000000000000000000000000000
      00000000000000000000000000000000000000000000000000007B7B7B007B7B
      7B0000000000000000007B7B7B00000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000FF000000FF000000FF000000
      0000000000000000000000000000000000000000000000000000000000000000
      00000000FF000000FF000000000000000000FFFFFF00FFFFFF00FFFFFF000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000FFFFFF00FFFFFF00000000000000000000000000FFFFFF00FFFFFF00FFFF
      FF00FFFFFF00FFFFFF00FFFFFF00FFFFFF00FFFFFF0000000000000000000000
      00007B7B7B007B7B7B0000FFFF0000000000000000000000000000000000FFFF
      FF00FFFFFF0000000000FFFFFF00FFFFFF000000000000000000FFFFFF000000
      0000000000000000000000000000000000000000FF000000FF000000FF000000
      FF00000000000000000000000000000000000000000000000000000000000000
      0000000000000000FF000000FF0000000000FFFFFF00FFFFFF00FFFFFF00FFFF
      FF00000000000000000000000000000000000000000000000000000000000000
      000000000000FFFFFF00FFFFFF000000000000000000FFFFFF00FFFFFF00FFFF
      FF00FFFFFF00FFFFFF00FFFFFF00FFFFFF00FFFFFF0000000000000000000000
      00007B7B7B0000FFFF0000FFFF00000000000000000000000000000000000000
      000000000000FFFFFF000000000000000000FFFFFF00FFFFFF0000000000FFFF
      FF00FFFFFF000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000FF000000FF00000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      000000000000FFFFFF00FFFFFF000000000000000000FFFFFF00000000000000
      0000FFFFFF00000000000000000000000000FFFFFF0000000000000000000000
      00000000FF0000000000000000007B7B7B000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      00000000000000000000000000000000000000000000FFFFFF00FFFFFF00FFFF
      FF00FFFFFF00FFFFFF00FFFFFF00FFFFFF00FFFFFF0000000000000000000000
      FF000000FF000000FF0000000000000000000000000000000000000000000000
      000000000000FFFFFF00FFFFFF00FFFFFF00FFFFFF00FFFFFF00FFFFFF000000
      0000000000000000000000000000000000000000FF000000FF00000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      00000000000000000000000000000000000000000000FFFFFF00000000000000
      00000000000000000000FFFFFF0000000000FFFFFF00000000000000FF000000
      FF000000FF000000FF000000FF00000000000000000000000000000000000000
      000000000000FFFFFF00FFFFFF00FFFFFF00FFFFFF00FFFFFF00FFFFFF000000
      0000000000000000000000000000000000000000FF000000FF00000000000000
      00000000000000000000000000000000000000000000000000000000FF000000
      FF000000FF000000FF000000FF00000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      00000000000000000000000000000000000000000000FFFFFF00FFFFFF00FFFF
      FF00FFFFFF00FFFFFF00FFFFFF00FFFFFF00FFFFFF000000FF000000FF000000
      FF000000FF000000FF000000FF000000FF000000000000000000000000000000
      000000000000FFFFFF0000000000FFFFFF000000000000000000000000000000
      000000000000000000000000000000000000000000000000FF000000FF000000
      0000000000000000000000000000000000000000000000000000000000000000
      FF000000FF000000FF000000FF00000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      00000000000000000000000000000000000000000000FFFFFF00000000000000
      0000FFFFFF000000000000000000000000000000000000000000000000000000
      FF000000FF000000FF0000000000000000000000000000000000000000000000
      000000000000FFFFFF00FFFFFF00FFFFFF0000000000FFFFFF00000000000000
      000000000000000000000000000000000000000000000000FF000000FF000000
      FF00000000000000000000000000000000000000000000000000000000000000
      00000000FF000000FF000000FF00000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      00000000000000000000000000000000000000000000FFFFFF00FFFFFF00FFFF
      FF00FFFFFF0000000000FFFFFF00FFFFFF000000000000000000000000000000
      FF000000FF000000FF0000000000000000000000000000000000000000000000
      000000000000FFFFFF00FFFFFF00FFFFFF000000000000000000000000000000
      00000000000000000000000000000000000000000000000000000000FF000000
      FF000000FF0000000000000000000000000000000000000000000000FF000000
      FF000000FF000000FF000000FF00000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      00000000000000000000000000000000000000000000FFFFFF0000000000BDBD
      BD00FFFFFF0000000000FFFFFF000000000000000000000000007B7B7B000000
      FF000000FF000000FF0000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      FF000000FF000000FF000000FF00000000000000FF000000FF000000FF000000
      FF0000000000000000000000FF00000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      00000000000000000000000000000000000000000000FFFFFF00FFFFFF00FFFF
      FF00FFFFFF000000000000000000000000000000FF000000FF000000FF000000
      FF000000FF000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000FF000000FF000000FF000000FF000000FF00000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      00000000000000000000000000000000000000000000FFFFFF00FFFFFF00FFFF
      FF00FFFFFF00FFFFFF00FFFFFF00FFFFFF00FFFFFF00FFFFFF00FFFFFF00FFFF
      FF00000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      00000000000000000000000000000000000000000000FFFFFF00FFFFFF00FFFF
      FF00FFFFFF00FFFFFF00FF0000000000000000000000FF000000FFFFFF00FF00
      0000FFFFFF0000000000FFFFFF00000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000FF00000000000000FFFFFF00000000000000
      000000000000000000000000000000000000FF000000FF000000FF0000000000
      00000000000000000000000000000000000000000000FFFFFF00FFFFFF00FFFF
      FF000000000000000000FF000000FF000000FF000000FF000000000000000000
      0000FF000000FFFFFF00FFFFFF00000000008484840084848400848484008484
      8400848484000000000084848400848484008484840084848400848484000000
      0000848484008484840084848400848484000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000FFFFFF000000
      0000000000000000000000000000000000008484840084848400848484000000
      00000000000000000000000000000000000000000000FFFFFF00FFFFFF00FFFF
      FF0000000000FF000000FFFFFF008484840084848400FFFFFF00FF0000000000
      0000FFFFFF00FFFFFF00FFFFFF00000000008484840084848400848484008484
      8400848484000000000084848400848484008484840084848400848484000000
      0000848484008484840084848400848484000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      000000000000000000000000000000000000000000000000000000000000FFFF
      FF000000000000000000FF0000008484840000000000FF000000000000008484
      8400FF00000000000000000000000000000000000000FFFFFF00FFFFFF00FF00
      0000FF000000FFFFFF0084848400FFFFFF00FFFFFF0084848400FFFFFF00FF00
      0000FF000000FFFFFF00FFFFFF00000000008484840084848400848484008484
      8400848484000000000084848400848484008484840084848400848484000000
      0000848484008484840084848400848484000000000000000000000000000000
      00000000000000000000FF0000000000000000000000FF00000000000000FF00
      000000000000000000000000000000000000000000000000000000000000FFFF
      FF000000000000000000FF00000084848400FF000000FF000000FF0000008484
      8400FF00000000000000000000000000000000000000FFFFFF00FFFFFF000000
      0000FF00000084848400FFFFFF008484840084848400FFFFFF0084848400FF00
      000000000000FFFFFF00FFFFFF00000000008484840084848400848484008484
      8400848484000000000084848400848484008484840084848400848484000000
      0000848484008484840084848400848484000000000000000000000000000000
      00000000000000000000FF000000FF000000FF000000FF000000000000000000
      0000FF0000000000000000000000000000000000000000000000848484008484
      84008484840000000000FF0000008484840000000000FF000000000000008484
      8400FF00000000000000000000000000000000000000FFFFFF00FFFFFF000000
      0000FF00000084848400FFFFFF008484840084848400FFFFFF0084848400FF00
      000000000000FFFFFF00FFFFFF00000000008484840084848400848484008484
      8400848484000000000084848400848484008484840084848400848484000000
      0000848484008484840084848400848484000000000000000000000000000000
      000000000000FF00000000000000848484008484840000000000FF0000000000
      0000000000000000000000000000000000000000000084848400FFFFFF00FFFF
      FF00FFFFFF000000000000000000000000008484840084848400848484000000
      00000000000000000000000000000000000000000000FFFFFF00FFFFFF00FF00
      0000FF000000FFFFFF0084848400FFFFFF00FFFFFF0084848400FFFFFF00FF00
      0000FF000000FFFFFF00FFFFFF00000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      000000000000000000000000000000000000000000000000000000000000FF00
      0000FF000000000000008484840000000000000000008484840000000000FF00
      0000FF00000000000000000000000000000084848400FFFFFF00FFFFFF00FFFF
      FF00FFFFFF00FFFFFF000000000000000000FF000000FF000000FF0000000000
      00000000000000000000000000000000000000000000FFFFFF00FFFFFF00FFFF
      FF0000000000FF000000FFFFFF008484840084848400FFFFFF00FF0000000000
      0000FFFFFF00FFFFFF00FFFFFF00000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000FF000000848484000000000084848400848484000000000084848400FF00
      00000000000000000000000000000000000084848400FFFFFF00FFFFFF00FFFF
      FF00FFFFFF00FFFFFF0084848400000000000000000000000000000000000000
      00000000000000000000000000000000000000000000FFFFFF00FFFFFF00FFFF
      FF00FFFFFF0000000000FF000000FF000000FF000000FF00000000000000FFFF
      FF00FFFFFF00FFFFFF00FFFFFF00000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000FF000000848484000000000084848400848484000000000084848400FF00
      00000000000000000000000000000000000084848400FFFFFF00FFFFFF00FFFF
      FF00FFFFFF00FFFFFF0084848400000000000000000000000000000000000000
      00000000000000000000000000000000000000000000FFFFFF00FFFFFF00FFFF
      FF00FFFFFF00FFFFFF00FF0000000000000000000000FF000000FFFFFF00FFFF
      FF00FFFFFF00FFFFFF00FFFFFF00000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      000000000000000000000000000000000000000000000000000000000000FF00
      0000FF000000000000008484840000000000000000008484840000000000FF00
      0000FF0000000000000000000000000000008484840084848400848484008484
      8400848484008484840084848400000000000000000000000000000000000000
      00000000000000000000000000000000000000000000FFFFFF00FFFFFF00FFFF
      FF00FFFFFF00FFFFFF00FFFFFF00FFFFFF00FFFFFF00FFFFFF00FFFFFF00FFFF
      FF00FFFFFF00FFFFFF00FFFFFF00000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      000000000000FF00000000000000848484008484840000000000FF0000000000
      00000000000000000000000000000000000084848400FFFFFF00FFFFFF008484
      8400FFFFFF00FFFFFF0084848400000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      00000000000000000000FF000000FF000000FF000000FF000000000000000000
      00000000000000000000000000000000000084848400FFFFFF00FFFFFF008484
      8400FFFFFF00FFFFFF0084848400000000000000000000000000000000000000
      00000000000000000000000000000000000000000000FF000000FF000000FF00
      0000FF000000FF000000FF000000FF000000FF000000FF000000FF000000FF00
      0000FF000000FF000000FF000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      00000000000000000000FF0000000000000000000000FF000000000000000000
      0000000000000000000000000000000000000000000084848400848484008484
      8400848484008484840000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000FF0000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      000000000000000000000000FF00000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000FF000000FF000000FF000000
      FF000000FF000000FF000000FF000000FF000000FF000000FF000000FF000000
      FF000000FF000000FF000000FF000000FF000000FF0000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      000000000000000000000000FF00000000000000000084848400848484008484
      8400848484008484840000000000FFFFFF00FFFFFF00FFFFFF00FFFFFF00FFFF
      FF00848484008484840084848400000000000000000000000000000000000000
      000000000000000000000000000000000000FFFFFF00FFFFFF00FFFFFF00FFFF
      FF00FFFFFF00FFFFFF0000000000000000000000000000000000000000008400
      0000840000008400000084000000840000008400000084000000840000008400
      0000000000000000000000000000000000000000FF000000000000000000C600
      0000C6000000C6000000C6000000C6000000C6000000C6000000C6000000C600
      000000000000000000000000FF00000000000000000084848400848484008484
      8400848484008484840000000000FFFFFF00FFFFFF00FFFFFF00FFFFFF00FFFF
      FF0000000000848484008484840000000000FFFFFF0000000000000000000000
      0000000000000000000000000000FFFFFF00FFFFFF00FFFFFF00FFFFFF00FFFF
      FF00FFFFFF00FFFFFF00FFFFFF00000000000000000000000000000000008400
      0000000000000000000000000000000000000000000000000000000000008400
      0000000000000000000000000000000000000000FF000000000000000000C600
      000000000000000000000000000000000000000000000000000000000000C600
      000000000000000000000000FF00000000000000000084848400848484008484
      84008484840000000000FFFFFF00FFFFFF00FFFFFF00FFFFFF00FFFFFF00FFFF
      FF00FFFFFF0000000000848484000000000000000000FFFFFF00000000000000
      00000000000000000000FFFFFF00FFFFFF00FFFFFF00FFFFFF00FFFFFF00FFFF
      FF00FFFFFF00FFFFFF00FFFFFF00000000000000000000000000000000008400
      0000000000000000000000000000000000000000000000000000000000008400
      0000000000000000000000000000000000000000FF000000000000000000C600
      000000000000000000000000000000000000000000000000000000000000C600
      000000000000000000000000FF00000000000000000084848400848484008484
      840084848400FFFFFF00FFFFFF00FFFFFF00FFFFFF00FFFFFF00FFFFFF00FFFF
      FF00FFFFFF00FFFFFF0084848400000000000000000000000000FFFFFF000000
      00000000000000000000FFFFFF00FFFFFF00FFFFFF00FFFFFF00FFFFFF00FFFF
      FF00FFFFFF00FFFFFF00FFFFFF00000000000000000000000000000000008400
      0000000000000000000000000000000000000000000000000000000000008400
      0000000000000000000000000000000000000000FF000000000000000000C600
      000000000000000000000000000000000000000000000000000000000000C600
      000000000000000000000000FF00000000000000000084848400848484008484
      840000000000FFFFFF0000000000FFFFFF00FFFFFF00FFFFFF00FFFFFF00FFFF
      FF00FFFFFF00FFFFFF0084848400000000000000000000000000000000000000
      000000000000FFFFFF00FFFFFF0000000000FFFFFF00FFFFFF00FFFFFF00FFFF
      FF00FFFFFF00FFFFFF00FFFFFF00000000000000000000000000000000008400
      0000000000000000000000000000000000000000000000000000000000008400
      0000000000000000000000000000000000000000FF000000000000000000C600
      000000000000000000000000000000000000000000000000000000000000C600
      000000000000000000000000FF00000000000000000084848400848484000000
      0000FFFFFF000000000000000000FFFFFF0000000000FFFFFF0000000000FFFF
      FF0000000000FFFFFF0084848400000000000000000000000000000000000000
      0000FFFFFF00FFFFFF000000000000000000FFFFFF0000000000FFFFFF000000
      0000FFFFFF0000000000FFFFFF00000000000000000000000000000000008400
      0000000000000000000000000000000000000000000000000000000000008400
      0000000000000000000000000000000000000000FF000000000000000000C600
      000000000000000000000000000000000000000000000000000000000000C600
      000000000000000000000000FF00000000000000000084848400848484000000
      0000000000008484840000000000FFFFFF0000000000FFFFFF0000000000FFFF
      FF0000000000FFFFFF0084848400000000000000000000000000848484000000
      000000000000000000000000000000000000FFFFFF0000000000FFFFFF000000
      0000FFFFFF0000000000FFFFFF00000000000000000000000000000000008400
      0000000000000000000000000000000000000000000000000000000000008400
      0000000000000000000000000000000000000000FF000000000000000000C600
      000000000000000000000000000000000000000000000000000000000000C600
      000000000000000000000000FF00000000000000000084848400848484008484
      8400848484008484840000000000FFFFFF0000000000FFFFFF0000000000FFFF
      FF0000000000FFFFFF0084848400000000000000000084848400FFFFFF00FFFF
      FF00FFFFFF00848484000000000000000000FFFFFF0000000000FFFFFF000000
      0000FFFFFF0000000000FFFFFF00000000000000000000000000000000008400
      0000840000008400000084000000840000000000000000000000000000008400
      0000000000000000000000000000000000000000FF000000000000000000C600
      000000000000000000000000000000000000000000000000000000000000C600
      000000000000000000000000FF00000000000000000084848400848484008484
      8400848484008484840000000000FFFFFF0000000000FFFFFF0000000000FFFF
      FF0000000000FFFFFF00848484000000000084848400FFFFFF00FFFFFF00FFFF
      FF00FFFFFF00FFFFFF008484840000000000FFFFFF0000000000FFFFFF000000
      0000FFFFFF0000000000FFFFFF00000000000000000000000000000000008400
      0000840000000000000000000000840000000000000000000000000000008400
      0000000000000000000000000000000000000000FF000000000000000000C600
      0000C6000000C6000000C6000000C6000000000000000000000000000000C600
      000000000000000000000000FF00000000000000000084848400848484008484
      8400848484008484840000000000FFFFFF0000000000FFFFFF0000000000FFFF
      FF000000000000000000848484000000000084848400FFFFFF00FFFFFF00FFFF
      FF00FFFFFF00FFFFFF008484840000000000FFFFFF0000000000FFFFFF000000
      0000FFFFFF000000000000000000000000000000000000000000000000000000
      0000840000008400000000000000840000000000000000000000000000008400
      0000000000000000000000000000000000000000FF000000000000000000C600
      0000C60000000000000000000000C6000000000000000000000000000000C600
      000000000000000000000000FF00000000000000000084848400848484008484
      8400848484008484840000000000FFFFFF0000000000FFFFFF0000000000FFFF
      FF000000000084848400848484000000000084848400FFFFFF00FFFFFF00FFFF
      FF00FFFFFF00FFFFFF008484840000000000FFFFFF0000000000FFFFFF000000
      0000FFFFFF000000000000000000000000000000000000000000000000000000
      0000000000008400000084000000840000000000000000000000000000008400
      0000000000000000000000000000000000000000FF0000000000000000000000
      0000C6000000C600000000000000C6000000000000000000000000000000C600
      000000000000000000000000FF00000000000000000084848400848484008484
      8400848484008484840084848400000000008484840000000000848484000000
      0000848484008484840084848400000000008484840084848400848484008484
      8400848484008484840084848400000000000000000000000000FFFFFF000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000084000000840000008400000084000000840000008400
      0000000000000000000000000000000000000000FF0000000000000000000000
      000000000000C6000000C6000000C6000000000000000000000000000000C600
      000000000000000000000000FF00000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      00000000000000000000000000000000000084848400FFFFFF00FFFFFF008484
      8400FFFFFF00FFFFFF0084848400000000000000000000000000000000000000
      0000000000000000000000000000000000000000FF000000FF000000FF000000
      FF000000FF000000FF000000FF000000FF000000FF000000FF000000FF000000
      FF000000FF000000FF000000FF000000FF000000FF0000000000000000000000
      00000000000000000000C6000000C6000000C6000000C6000000C6000000C600
      000000000000000000000000FF000000000000000000FF000000FF000000FF00
      0000FF000000FF000000FF000000FF000000FF000000FF000000FF000000FF00
      0000FF000000FF000000FF0000000000000084848400FFFFFF00FFFFFF008484
      8400FFFFFF00FFFFFF0084848400000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000FF0000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      000000000000000000000000FF00000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000084848400848484008484
      8400848484008484840000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      000000000000000000000000000000000000424D3E000000000000003E000000
      2800000040000000F00000000100010000000000800700000000000000000000
      000000000000000000000000FFFFFF00FFFF0000000000001C3C000000000000
      3002000000000000400100000000000040000000000000008000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000080000000000000004021000000000000
      20060000000000001008000000000000FFFFFFFFF01FFFFFFFFFFFFFF003FFFF
      0000FFFFF007FFFF7FFEFFFFF00F80036006FFFFF01F9DFF6FF6FFFFF03F9DFF
      6FF6C003F07F9DFF6FF6C107F0FF9DFF77EEC043F1FF81FFBBDDC41B80079FFF
      DDBBDB27820F9FFFEE77C00380879FFFF7EFFFFF88379FFFFBDFFFFFB64F9FFF
      FDBFFFFF80079FFFFE7FFFFFFFFFFFFFFFFFFFFFFFFFFFFFFCFFFFFFFFFF87FF
      F87FFFFFEFFF83FF0000F6FFC7FF81FF0000F6FF83FF80FF0000F6FF01FFC07F
      0000E01F10FFE03F0000FB7FB87FF01F0000FB7FFC3FF80F0000E01FFE1FFC07
      0000FDBFFF1FFE030000FDBFFF9FFF010000FDBFFFDFFF810000FFFFFFFFFFC1
      0000FFFFFFFFFFE3FFFFFFFFFFFFFFFFFFFFFF9F800080000001FF0F80008000
      0001FF0F8000A0000001EE1F8000A0000001E61F8000A8000001E03F8000A800
      0001E03F8000A8000001E0078000A8000001E00F8000A8000001E01F8000A800
      0001E03F8000A8000001E07FFFF0E8000001E0FF100028000001E1FF1FFC3800
      0001E3FF040008000001E7FF07FF0FFF00000000FFFFFFFF0000000001010101
      00000000397D393900000000557D5555000000006D7D6D6D00000000557D5555
      00000000397D3939000000000101010100000000FFFFFFFF0000000001010101
      000000007D7D3939000000007D7D5555000000007D7D6D6D000000007D7D5555
      000000007D7D39390000000001010101FFFF0000001F0000842100007FDF0000
      842100007FDF00008401000040DF00008400000040DF000083E3000040DF0000
      0021000040DF000084210000405F0000842100007E1F0000842100007F1F0000
      C7FF00007F8F00008421000000060000842100001F0000008421000000100000
      84210000FFF00000FFFF0000FFE0000000010000003F0000FFCF7FFE7FBF0000
      FF87400240BF0000FF03400240BF0000FFCF400240BF0000F3CF400240BF0000
      F3CF4002403F0000F3CF40027E3F0000F3CF4002001F0000F3CF40021E0F0000
      F3CF400200060000F3FF4002FFE00000C0FF7FFEFFF00000E1FF0000FFF00000
      F3FF1FF8FFE0000000000000FFFF0000FFFFFFFFFFFF7FFEFC7FFFFF81017FFE
      F83FFFFFBD7D7FF6FC1FFFFFBD7D7FF2F803DFFEBD7D7C00F838DFFE817D7C00
      F800DFFE817D7FF2CC11DDBEFF017FF6870FD81EFF016FFE8007DDBE81FF4FFE
      C0071FF8BDE1003EC0079FFCBDED003EE007DFFEBDED4FFEF00FFFFF81E16FFE
      FC1FFFFF81E17FFEFFFFFFFFFFFF7FFE7FFEFFFFFFFFFFFF7FFEFFFFFFFFFEFF
      7FFEFFFFFFFFFC3F7FFEFFFFFFFFF80F7FFEDFFFFFFBFC036FF68FFFFFF1FEC1
      4FF207FFFFE0FFF11FF88FFFFFF1FFF81FF88FFFFFF1FFF84FF2C7FFFFE3FFF8
      6FF6C7FFFFE3FFF17FFEE3FFFFC7FFC17FFEE0FFFF07FE037FFEF01FF80FFE0F
      7FFEFC1FF83FFE3F7FFEFF1FF8FFFFFFFFFFFFFF00000000F80101017E7EFE7F
      F80101017C3EFC3FF8010101799EF99FF80101017FFEFFFFF80101016FF6FFFF
      D80101014FF2FFFFE80101011FF8FFFFF001FFFF1FF8FFFFCC0101014FF2FFFF
      F5FF01016FF6FFFFEAFF01017FFEFFFFDF7F0101799EF99FFBFF01017C3EFC3F
      FFFF01017E7EFE7FFBFF010100000000FFFFFFFFFFFFFFBFFFFFFFFFBBFBFF1F
      C00FFFFBB3F3FE0FDFEFFFF1A3E30000D0EFFFE083C30000DFEFFFF1A3E30000
      D02FFFF1B3F3FE0FDFEFFFF1FBFBF60FD02FFFF1FFFFE3FFDFEFFFE3BFBBC1FF
      D1EFFFE39F9B0000DF0FFFC78F8B0000D35FFF0787830000DF3FF80F8F8BC1FF
      C07FF83F9F9BC1FFFFFFF8FFBFBBFFFFFFFFFFFFFC00FFFFF83FF83FFC00FFFF
      E10FE10FFC00E00747474747FC00DFFB0FE30FE30000C0031FF31FF30000C4DB
      0FF90FF90000DB23FFF9FFF90000C003FFFFFFFF0023F00F3FFF3FFF0001F00F
      3FC13FC10000F00F9FE19FE10023F01F8FF18FF10063F07FC7C1C7C100C3F07F
      E10DE10D0107FFFFF83FF83F03FFFFFFFFFFFFFC0000FFFF557FFFF80000FFFF
      FFFFFF110000FFFF7F7CBE0300000410FFF8DD17000004107F71E8A300000410
      FC2BE803000004107007C0A300000410F24F85170000DF7D65A7020F00008E38
      E247011F00000410624701FF0000DF7DE5A701FF0000DF7D724F01FF0000DF7D
      F81F01FF0000FFFF543F83FF0000FFFFFFFF7FFD0000FE0100007FFD0000FE01
      E00F600D00007C00EFEF6FED0000B800EFEF6FED0000D800EFEF6FED0000F000
      EFEF6FED0000E000EFEF6FED0000C200EFEF6FED00008200E0EF6FED00000000
      E6EF60ED00000001F2EF66ED00000003F8EF72ED00000107FC0F78ED0000019F
      00007C0D000001FFFFFF7FFD000083FFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFF
      3FF3FFF3CFFFCFFC3FC3FFC3C3FFC3FC3F03FF03C0FFC0FC3C03FC03C03FC03C
      3003F003C00FC00C0003C003C003C0003003F003C00FC00C3C03FC03C03FC03C
      3F03FF03C0FFC0FC3FC3FFC3C3FFC3FC3FF3FFF3CFFFCFFCFFFFFFFFFFFFFFFF
      FFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFF00000000000000000000000000000000
      000000000000}
  end
  object PopupMenu1: TPopupMenu
    Left = 360
    Top = 104
  end
  object TimerScreenShot: TTimer
    Enabled = False
    OnTimer = TimerScreenShotTimer
    Left = 488
    Top = 464
  end
end
