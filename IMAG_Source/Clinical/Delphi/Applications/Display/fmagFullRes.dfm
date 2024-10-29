object frmFullRes: TfrmFullRes
  Left = 541
  Top = 261
  HelpContext = 10086
  Caption = 'Full Resolution Window'
  ClientHeight = 624
  ClientWidth = 702
  Color = clBtnFace
  Constraints.MinHeight = 400
  Constraints.MinWidth = 500
  Font.Charset = DEFAULT_CHARSET
  Font.Color = clBlack
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
  OnResize = ResizeAllImages
  PixelsPerInch = 96
  TextHeight = 14
  object Splitter1: TSplitter
    Left = 0
    Top = 118
    Width = 0
    Height = 487
    Color = clGrayText
    ParentColor = False
    ExplicitTop = 430
    ExplicitHeight = 151
  end
  object FullEdit1: TPanel
    Left = 0
    Top = 0
    Width = 702
    Height = 22
    Align = alTop
    BevelInner = bvLowered
    TabOrder = 0
    Visible = False
    object ImageDesc: TLabel
      Left = 5
      Top = 2
      Width = 61
      Height = 14
      Caption = 'ImageDesc'
      Font.Charset = DEFAULT_CHARSET
      Font.Color = clBlack
      Font.Height = -11
      Font.Name = 'Arial'
      Font.Style = [fsBold]
      ParentFont = False
    end
    object Label4: TLabel
      Left = 681
      Top = 2
      Width = 19
      Height = 18
      Align = alRight
      AutoSize = False
      ExplicitLeft = 674
    end
  end
  object stbarInfo: TStatusBar
    Left = 0
    Top = 605
    Width = 702
    Height = 19
    Panels = <
      item
        Alignment = taCenter
        Width = 100
      end
      item
        Width = 50
      end>
  end
  object pnlDockTarget: TPanel
    Left = 0
    Top = 118
    Width = 0
    Height = 487
    Align = alLeft
    Caption = 'pnlDockTarget'
    DockSite = True
    TabOrder = 2
    OnDockDrop = pnlDockTargetDockDrop
    OnDockOver = pnlDockTargetDockOver
    OnUnDock = pnlDockTargetUnDock
  end
  object magViewerTB1: TMagViewerTB8
    Left = 0
    Top = 22
    Width = 702
    Height = 96
    Align = alTop
    AutoSize = True
    Color = 14737359
    ParentColor = False
    ParentShowHint = False
    ShowHint = False
    TabOrder = 4
    MagViewer = Mag4Viewer1
    OnPrintClick = magViewerTB1PrintClick
    OnCopyClick = magViewerTB1CopyClick
  end
  object Mag4Viewer1: TMag4Viewer
    Left = 8
    Top = 348
    Width = 625
    Height = 149
    DragKind = dkDock
    Font.Charset = DEFAULT_CHARSET
    Font.Color = clWindowText
    Font.Height = -11
    Font.Name = 'MS Sans Serif'
    Font.Style = []
    ParentFont = False
    ParentShowHint = False
    PopupMenu = popupVImage
    ShowHint = True
    TabOrder = 3
    OnEndDock = Mag4Viewer1EndDock
    AbsWindow = False
    DisplayStyle = MagdsLine
    ViewerStyle = MagvsDynamic
    OnViewerImageClick = Mag4Viewer1ViewerImageClick
    OnListChange = Mag4Viewer1ListChange
    PopupMenuImage = popupVImage
    MagSecurity = DMod.MagFileSecurity
    ViewStyle = MagViewerViewFull
    UseAutoReAlign = True
    ImageFontSize = 8
    ShowToolbar = False
    LockSize = True
    ZoomWindow = False
    PanWindow = False
    Scrollable = False
    ScrollVertical = False
    IsDragAble = False
    IsSizeAble = False
    ApplyToAll = False
    AutoRedraw = True
    ClearBeforeAddDrop = False
    RowCount = 1
    RowSpacing = 1
    ColumnSpacing = 4
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
      625
      149)
  end
  object popupVImage: TPopupMenu
    HelpContext = 10087
    OnPopup = popupVImagePopup
    Left = 283
    Top = 296
    object mnuZoom2: TMenuItem
      Caption = 'Zoom'
      object ZoomIn2: TMenuItem
        Caption = 'Zoom In         Shift+Ctrl+I'
        OnClick = ZoomIn2Click
      end
      object ZoomOutShiftCtrlO1: TMenuItem
        Caption = 'Zoom Out      Shift+Ctrl+O'
        OnClick = ZoomOutShiftCtrlO1Click
      end
      object mnuFitToWidth2: TMenuItem
        Caption = 'Fit to Width'
        ImageIndex = 24
        OnClick = mnuFitToWidth2Click
      end
      object mnuFitToHeight2: TMenuItem
        Caption = 'Fit to Height'
        ImageIndex = 23
        OnClick = mnuFitToHeight2Click
      end
      object mmuFitToWindow2: TMenuItem
        Caption = 'Fit to Window'
        ImageIndex = 22
        OnClick = mmuFitToWindow2Click
      end
      object mnuActualSize2: TMenuItem
        Caption = 'Actual Size'
        ImageIndex = 29
        OnClick = mnuActualSize2Click
      end
    end
    object mnuMouse2: TMenuItem
      Caption = 'Mouse'
      object mnuMousePan2: TMenuItem
        Caption = 'Pan'
        ImageIndex = 7
        OnClick = mnuMousePan2Click
      end
      object mnuMouseMagnify2: TMenuItem
        Caption = 'Magnify'
        ImageIndex = 9
        OnClick = mnuMouseMagnify2Click
      end
      object mnuMouseZoom2: TMenuItem
        Caption = 'Zoom'
        ImageIndex = 10
        OnClick = mnuMouseZoom2Click
      end
      object mnuMousePointer2: TMenuItem
        Caption = 'Pointer'
        ImageIndex = 40
        OnClick = mnuMousePointer2Click
      end
    end
    object mnuRotate2: TMenuItem
      Caption = 'Rotate'
      object mnuRotateRight2: TMenuItem
        Caption = 'Right'
        ImageIndex = 26
        OnClick = mnuRotateRight2Click
      end
      object mnuRotateLeft2: TMenuItem
        Caption = 'Left'
        ImageIndex = 25
        OnClick = mnuRotateLeft2Click
      end
      object mnuRotate1802: TMenuItem
        Caption = '180'
        ImageIndex = 27
        OnClick = mnuRotate1802Click
      end
      object FlipHorizontal1: TMenuItem
        Caption = 'Flip Horizontal'
        ImageIndex = 31
        OnClick = FlipHorizontal1Click
      end
      object FlipVertical1: TMenuItem
        Caption = 'Flip Vertical'
        ImageIndex = 32
        OnClick = FlipVertical1Click
      end
    end
    object mnuInvert2: TMenuItem
      Caption = 'Invert Image'
      OnClick = mnuInvert2Click
    end
    object mnuReset2: TMenuItem
      Caption = 'Reset Image'
      ShortCut = 24659
      OnClick = mnuReset2Click
    end
    object mnuRemoveImage2: TMenuItem
      Caption = 'Close Selected Image'
      OnClick = mnuRemoveImage2Click
    end
    object N2: TMenuItem
      Caption = '-'
    end
    object mnuImageReport2: TMenuItem
      Caption = 'Image Report'
      ImageIndex = 16
      OnClick = mnuImageReport2Click
    end
    object mnuImageDelete2: TMenuItem
      Caption = 'Image Delete...'
      ImageIndex = 44
      Visible = False
      OnClick = mnuImageDelete2Click
    end
    object mnuImageInformation2: TMenuItem
      Caption = 'Image Information...'
      ImageIndex = 43
      OnClick = mnuImageInformation2Click
    end
    object mnuImageInformationAdvanced2: TMenuItem
      Caption = 'Image Information Advanced...'
      OnClick = mnuImageInformationAdvanced2Click
    end
    object MenuItem6: TMenuItem
      Caption = '-'
    end
    object mnuFontSize2: TMenuItem
      Caption = 'Font Size'
      OnClick = mnuFontSize2Click
      object mnu6pt: TMenuItem
        Tag = 6
        Caption = '6 pt'
        OnClick = mnu6ptClick
      end
      object mnu7pt: TMenuItem
        Tag = 7
        Caption = '7 pt'
        OnClick = mnu7ptClick
      end
      object mnu8pt: TMenuItem
        Tag = 8
        Caption = '8 pt'
        OnClick = mnu8ptClick
      end
      object mnu10pt: TMenuItem
        Tag = 10
        Caption = '10 pt'
        OnClick = mnu10ptClick
      end
      object mnu12pt: TMenuItem
        Tag = 12
        Caption = '12 pt'
        OnClick = mnu12ptClick
      end
    end
    object mnuToolbar2: TMenuItem
      Caption = 'Toolbar'
      Checked = True
      ShortCut = 16468
      OnClick = mnuToolbar2Click
    end
    object mnuShowHints2: TMenuItem
      Caption = 'Show Hints'
      Checked = True
      OnClick = mnuShowHints2Click
    end
    object MenuItem12: TMenuItem
      Caption = '-'
    end
    object mnuGotoMainWindow2: TMenuItem
      Caption = 'Go to Main Window'
      ShortCut = 16461
      OnClick = mnuGotoMainWindow2Click
    end
    object mnuHelp2: TMenuItem
      Caption = 'Help...'
      OnClick = mnuHelp2Click
    end
  end
  object MainMenu1: TMainMenu
    Left = 220
    Top = 156
    object File1: TMenuItem
      Caption = 'File'
      HelpContext = 10087
      OnClick = File1Click
      object mnuOpenacopy1: TMenuItem
        Caption = 'Duplicate Selected Image'
        OnClick = mnuOpenacopy1Click
      end
      object mnuCopy1: TMenuItem
        Caption = 'Copy Image to Clipboard'
        Hint = 'Copy image to Clipboard'
        ImageIndex = 14
        OnClick = mnuCopy1Click
      end
      object mnuPrint1: TMenuItem
        Caption = 'Print Image...'
        Hint = 'Print Image'
        ImageIndex = 15
        OnClick = mnuPrint1Click
      end
      object mnuImagePrintOptions: TMenuItem
        Caption = 'Print Options...'
        OnClick = mnuImagePrintOptionsClick
      end
      object mnuReport1: TMenuItem
        Caption = 'Image Report...'
        Hint = 'View the Image Report'
        ImageIndex = 16
        OnClick = mnuReport1Click
      end
      object mnuImageSaveAs1: TMenuItem
        Caption = '[]Image Save As...'
        Visible = False
      end
      object mnuDelete1: TMenuItem
        Caption = 'Image Delete...'
        Hint = 'Delete the Image'
        ImageIndex = 44
        OnClick = mnuDelete1Click
      end
      object mnuClose1: TMenuItem
        Caption = 'Close Selected Image'
        Hint = 'Close Selected Images.'
        OnClick = mnuClose1Click
      end
      object mnuCloseAll1: TMenuItem
        Caption = 'Close All Images'
        Hint = 'Close All Images.'
        OnClick = mnuCloseAll1Click
      end
      object mnuImageInformation1: TMenuItem
        Caption = 'Image Information...'
        ImageIndex = 43
        OnClick = mnuImageInformation1Click
      end
      object mnuImageInformationAdvanced1: TMenuItem
        Caption = 'Image Information Advanced...'
        OnClick = mnuImageInformationAdvanced1Click
      end
      object N1: TMenuItem
        Caption = '-'
      end
      object mnuExit1: TMenuItem
        Caption = 'Exit'
        OnClick = mnuExit1Click
      end
    end
    object mnuCTPresets: TMenuItem
      Caption = 'CT Presets'
      HelpContext = 10087
      Visible = False
      object mnuAbdomen: TMenuItem
        Caption = 'Abdomen'
        OnClick = mnuAbdomenClick
      end
      object mnuBone: TMenuItem
        Caption = 'Bone'
        OnClick = mnuBoneClick
      end
      object mnuDisk: TMenuItem
        Caption = 'Disk'
        OnClick = mnuDiskClick
      end
      object mnuHead: TMenuItem
        Caption = 'Head'
        OnClick = mnuHeadClick
      end
      object mnuLung: TMenuItem
        Caption = 'Lung'
        OnClick = mnuLungClick
      end
      object mnuMediastinum: TMenuItem
        Caption = 'Mediastinum'
        OnClick = mnuMediastinumClick
      end
    end
    object mnuImage1: TMenuItem
      Caption = 'Image'
      OnClick = mnuImage1Click
      object PagingControls1: TMenuItem
        Caption = 'Paging Controls...'
        Visible = False
      end
      object ZoomBrightnessContrast1: TMenuItem
        Caption = 'Zoom, Brightness, Contrast...'
        Visible = False
      end
      object N3: TMenuItem
        Caption = '-'
        Visible = False
      end
      object mnuApplytoAll1: TMenuItem
        Caption = 'Apply to All'
        OnClick = mnuApplytoAll1Click
      end
      object mnuZoom1: TMenuItem
        Caption = 'Zoom'
        OnClick = mnuZoom1Click
        object ZoomIn1: TMenuItem
          Caption = 'Zoom In'
          ShortCut = 24649
          OnClick = ZoomIn1Click
        end
        object ZoomOut1: TMenuItem
          Caption = 'Zoom Out'
          ShortCut = 24655
          OnClick = ZoomOut1Click
        end
        object mnuFittoWidht1: TMenuItem
          Caption = 'Fit to Width'
          ImageIndex = 24
          ShortCut = 24663
          OnClick = mnuFittoWidht1Click
        end
        object mnuFittoHeight1: TMenuItem
          Caption = 'Fit to Height'
          ImageIndex = 23
          OnClick = mnuFittoHeight1Click
        end
        object mnuFittoWindow1: TMenuItem
          Caption = 'Fit to Window'
          ImageIndex = 22
          OnClick = mnuFittoWindow1Click
        end
        object mnuActualSize1: TMenuItem
          Caption = 'Actual Size'
          ImageIndex = 29
          ShortCut = 24641
          OnClick = mnuActualSize1Click
        end
      end
      object mnuMouse1: TMenuItem
        Caption = 'Mouse'
        object mnuPan2: TMenuItem
          Caption = 'Pan'
          ImageIndex = 7
          OnClick = mnuPan2Click
        end
        object mnuMagnify2: TMenuItem
          Caption = 'Magnify'
          ImageIndex = 9
          OnClick = mnuMagnify2Click
        end
        object mnuSelect2: TMenuItem
          Caption = 'Zoom'
          ImageIndex = 8
          OnClick = mnuSelect2Click
        end
        object mnuPointer2: TMenuItem
          Caption = 'Pointer'
          ImageIndex = 40
          OnClick = mnuPointer2Click
        end
      end
      object mnuRotate1: TMenuItem
        Caption = 'Rotate'
        object Rightclockwise2: TMenuItem
          Caption = 'Right'
          Hint = 'Rotate +90 (clockwise)'
          ImageIndex = 26
          ShortCut = 24658
          OnClick = Rightclockwise2Click
        end
        object Left2: TMenuItem
          Caption = 'Left'
          Hint = 'Rotate -90 (counter-clockwise) '
          ImageIndex = 25
          OnClick = Left2Click
        end
        object N1802: TMenuItem
          Caption = '180'
          ImageIndex = 27
          OnClick = N1802Click
        end
        object mnuFlipHoriz1: TMenuItem
          Caption = 'Flip Horizontal'
          ImageIndex = 31
          OnClick = mnuFlipHoriz1Click
        end
        object mnuFlipVertical1: TMenuItem
          Caption = 'Flip Vertical'
          ImageIndex = 32
          OnClick = mnuFlipVertical1Click
        end
      end
      object mnuConBri: TMenuItem
        Caption = 'Contrast/Brightness'
        object mnuContrastP: TMenuItem
          Caption = 'Contrast +'
          OnClick = mnuContrastPClick
        end
        object mnuContrastM: TMenuItem
          Caption = 'Contrast -'
          OnClick = mnuContrastMClick
        end
        object mnuBrightnessP: TMenuItem
          Caption = 'Brightness +'
          OnClick = mnuBrightnessPClick
        end
        object mnuBrightnessM: TMenuItem
          Caption = 'Brightness -'
          OnClick = mnuBrightnessMClick
        end
      end
      object mnuInvert1: TMenuItem
        Caption = 'Invert'
        OnClick = mnuInvert1Click
      end
      object mnuRGBChanger: TMenuItem
        Caption = 'Color Channel'
        object mnuRGBFull: TMenuItem
          Caption = 'Full Color (RGB)'
          OnClick = mnuRGBFullClick
        end
        object mnuRGBRed: TMenuItem
          Caption = 'Red Channel'
          OnClick = mnuRGBRedClick
        end
        object mnuRGBGreen: TMenuItem
          Caption = 'Green Channel'
          OnClick = mnuRGBGreenClick
        end
        object mnuRGBBlue: TMenuItem
          Caption = 'Blue Channel'
          OnClick = mnuRGBBlueClick
        end
      end
      object mnuReset1: TMenuItem
        Caption = 'Reset'
        ShortCut = 24659
        OnClick = mnuReset1Click
      end
      object mnuScroll: TMenuItem
        Caption = 'Scroll'
        object mnuScrollToCornerTL: TMenuItem
          Caption = 'Top Left'
          OnClick = mnuScrollToCornerTLClick
        end
        object mnuScrollToCornerTR: TMenuItem
          Caption = 'Top Right'
          OnClick = mnuScrollToCornerTRClick
        end
        object mnuScrollToCornerBL: TMenuItem
          Caption = 'Bottom Left'
          OnClick = mnuScrollToCornerBLClick
        end
        object mnuScrollToCornerBR: TMenuItem
          Caption = 'Bottom Right'
          OnClick = mnuScrollToCornerBRClick
        end
        object mnuScrollLeft: TMenuItem
          Caption = 'Left'
          OnClick = mnuScrollLeftClick
        end
        object mnuScrollRight: TMenuItem
          Caption = 'Right'
          OnClick = mnuScrollRightClick
        end
        object mnuScrollUp: TMenuItem
          Caption = 'Up'
          OnClick = mnuScrollUpClick
        end
        object mnuScrollDown: TMenuItem
          Caption = 'Down'
          OnClick = mnuScrollDownClick
        end
      end
      object mnuMaximize1: TMenuItem
        Caption = 'Maximize Image'
        OnClick = mnuMaximize1Click
      end
      object DeSkewSmooth1: TMenuItem
        Caption = '<hidden> DeSkew && Smooth'
        Visible = False
        OnClick = DeSkewSmooth1Click
      end
      object N4: TMenuItem
        Caption = '-'
      end
      object PreviousImage1: TMenuItem
        Caption = 'Previous Image'
        ShortCut = 16464
        OnClick = PreviousImage1Click
      end
      object NextImage1: TMenuItem
        Caption = 'Next Image'
        ShortCut = 16462
        OnClick = NextImage1Click
      end
    end
    object mnuView1: TMenuItem
      Caption = 'View'
      OnClick = mnuView1Click
      object mnuundoaction: TMenuItem
        Caption = 'Can'#39't &Undo'
        Visible = False
        OnClick = mnuundoactionClick
      end
      object ViewerSettings1: TMenuItem
        Caption = 'Viewer Settings...'
        OnClick = ViewerSettings1Click
      end
      object mnuRefresh: TMenuItem
        Caption = 'Refresh'
        ImageIndex = 12
        ShortCut = 16466
        OnClick = mnuRefreshClick
      end
      object RealignImages1: TMenuItem
        Caption = 'Realign Images'
        OnClick = RealignImages1Click
      end
      object mnuLockImageSize1: TMenuItem
        Caption = 'Lock Image Size'
        Checked = True
        OnClick = mnuLockImageSize1Click
      end
      object mnuToolBar1: TMenuItem
        Caption = 'Toolbar'
        Checked = True
        ShortCut = 16468
        OnClick = mnuToolBar1Click
      end
      object mnuShowHints1: TMenuItem
        Caption = 'Show Hints'
        Checked = True
        OnClick = mnuShowHints1Click
      end
      object mnuPanWindow1: TMenuItem
        Caption = 'Pan Window'
        ImageIndex = 6
        OnClick = mnuPanWindow1Click
      end
      object N5: TMenuItem
        Caption = '-'
      end
      object GoToMainWindow1: TMenuItem
        Caption = 'GoTo Main Window'
        ShortCut = 16461
        OnClick = GoToMainWindow1Click
      end
      object ShortcutMenu1: TMenuItem
        Caption = 'Shortcut Menu'
        ShortCut = 49229
        Visible = False
        OnClick = ShortcutMenu1Click
      end
      object ActiveForms1: TMenuItem
        Caption = 'Active windows...'
        ShortCut = 16471
        OnClick = ActiveForms1Click
      end
    end
    object RowCol1: TMenuItem
      Caption = 'Layout'
      OnClick = RowCol1Click
      object mnuTileAll1: TMenuItem
        Caption = 'Tile All'
        ImageIndex = 21
        OnClick = mnuTileAll1Click
      end
      object mnuDefaultLayout1: TMenuItem
        Caption = 'Default Layout'
        OnClick = mnuDefaultLayout1Click
      end
      object mnuNextViewerPage1: TMenuItem
        Caption = 'Next Viewer Page'
        ShortCut = 49230
        OnClick = mnuNextViewerPage1Click
      end
      object mnuPreviousViewerPage1: TMenuItem
        Caption = 'Prev Viewer Page'
        ShortCut = 49232
        OnClick = mnuPreviousViewerPage1Click
      end
      object N1x1: TMenuItem
        Break = mbBarBreak
        Caption = '1x1'
        OnClick = N1x1Click
      end
      object N2x1: TMenuItem
        Caption = '2x1'
        OnClick = N2x1Click
      end
      object N3x1: TMenuItem
        Caption = '3x1'
        OnClick = N3x1Click
      end
      object N4x1: TMenuItem
        Caption = '4x1'
        OnClick = N4x1Click
      end
      object N2x2: TMenuItem
        Break = mbBreak
        Caption = '1x2'
        OnClick = N2x2Click
      end
      object N2x3: TMenuItem
        Caption = '2x2'
        OnClick = N2x3Click
      end
      object N3x2: TMenuItem
        Caption = '3x2'
        OnClick = N3x2Click
      end
      object N4x2: TMenuItem
        Caption = '4x2'
        OnClick = N4x2Click
      end
      object N1x2: TMenuItem
        Break = mbBreak
        Caption = '1x3'
        OnClick = N1x2Click
      end
      object N2x4: TMenuItem
        Caption = '2x3'
        OnClick = N2x4Click
      end
      object N3x3: TMenuItem
        Caption = '3x3'
        OnClick = N3x3Click
      end
      object N4x3: TMenuItem
        Caption = '4x3'
        OnClick = N4x3Click
      end
      object N1x3: TMenuItem
        Break = mbBreak
        Caption = '1x4'
        OnClick = N1x3Click
      end
      object N2x5: TMenuItem
        Caption = '2x4'
        OnClick = N2x5Click
      end
      object N3x4: TMenuItem
        Caption = '3x4'
        OnClick = N3x4Click
      end
      object N4x4: TMenuItem
        Caption = '4x4'
        OnClick = N4x4Click
      end
    end
    object Tools1: TMenuItem
      Caption = 'Tools'
      Visible = False
      object NewViewer1: TMenuItem
        Caption = 'New Viewer'
        OnClick = NewViewer1Click
      end
    end
    object mnuPage1: TMenuItem
      Caption = 'Page'
      OnClick = mnuPage1Click
      object mnuFirstPage: TMenuItem
        Caption = 'First'
        OnClick = mnuFirstPageClick
      end
      object mnuPreviousPage: TMenuItem
        Caption = 'Previous'
        OnClick = mnuPreviousPageClick
      end
      object mnuNextPage: TMenuItem
        Caption = 'Next'
        OnClick = mnuNextPageClick
      end
      object mnuLastPage: TMenuItem
        Caption = 'Last'
        OnClick = mnuLastPageClick
      end
    end
    object Annotations1: TMenuItem
      Caption = 'Annotations'
      Visible = False
      object Edit1: TMenuItem
        Caption = 'Edit'
        object Undo1: TMenuItem
          Caption = 'Undo'
          ImageIndex = 29
          ShortCut = 16474
          OnClick = Undo1Click
        end
        object N6: TMenuItem
          Caption = '-'
        end
        object Cut1: TMenuItem
          Caption = 'Cut'
          ImageIndex = 31
          ShortCut = 16472
          OnClick = Cut1Click
        end
        object Copy1: TMenuItem
          Caption = 'Copy'
          ImageIndex = 30
          ShortCut = 16451
          OnClick = Copy1Click
        end
        object Paste1: TMenuItem
          Caption = 'Paste'
          ImageIndex = 32
          ShortCut = 16470
          OnClick = Paste1Click
        end
        object SelectAll1: TMenuItem
          Caption = 'Select All'
          ShortCut = 16449
          OnClick = SelectAll1Click
        end
        object N7: TMenuItem
          Caption = '-'
        end
        object ClearSelecetd1: TMenuItem
          Caption = 'Clear Selected'
          ImageIndex = 33
          ShortCut = 46
          OnClick = ClearSelecetd1Click
        end
        object ClearAll1: TMenuItem
          Caption = 'Clear All'
          OnClick = ClearAll1Click
        end
      end
      object Options1: TMenuItem
        Caption = 'Options'
        object extFont1: TMenuItem
          Caption = 'Text Font'
          OnClick = extFont1Click
        end
        object AnnotationColor1: TMenuItem
          Caption = 'Annotation Color'
          OnClick = AnnotationColor1Click
        end
        object N8: TMenuItem
          Caption = '-'
        end
        object ArrowType1: TMenuItem
          Caption = 'Arrow Type'
          object Open1: TMenuItem
            Caption = 'Open'
            ImageIndex = 3
            OnClick = Open1Click
          end
          object Pointer1: TMenuItem
            Caption = 'Pointer'
            ImageIndex = 2
            OnClick = Pointer1Click
          end
          object SolidPointer1: TMenuItem
            Caption = 'Solid Pointer'
            ImageIndex = 1
            OnClick = SolidPointer1Click
          end
          object Solid1: TMenuItem
            Caption = 'Solid'
            ImageIndex = 0
            OnClick = Solid1Click
          end
        end
        object ArrowHeadLength1: TMenuItem
          Caption = 'Arrow Head Length'
          object Small1: TMenuItem
            Caption = 'Small'
            ImageIndex = 26
            OnClick = Small1Click
          end
          object Medium1: TMenuItem
            Caption = 'Medium'
            ImageIndex = 25
            OnClick = Medium1Click
          end
          object Long1: TMenuItem
            Caption = 'Long'
            ImageIndex = 24
            OnClick = Long1Click
          end
        end
        object N9: TMenuItem
          Caption = '-'
        end
        object AnnotationsOpaque1: TMenuItem
          Caption = 'Annotations Opaque'
          OnClick = AnnotationsOpaque1Click
        end
        object AnnotationsTranslucent1: TMenuItem
          Caption = 'Annotations Translucent'
          OnClick = AnnotationsTranslucent1Click
        end
      end
      object LineWidth1: TMenuItem
        Caption = 'Line Width'
        object hin1: TMenuItem
          Caption = 'Thin'
          ImageIndex = 23
          OnClick = hin1Click
        end
        object Medium2: TMenuItem
          Caption = 'Medium'
          ImageIndex = 21
          OnClick = Medium2Click
        end
        object hick1: TMenuItem
          Caption = 'Thick'
          ImageIndex = 22
          OnClick = hick1Click
        end
      end
      object Annotation1: TMenuItem
        Caption = 'Annotation'
        object mnuAnnotationPointer: TMenuItem
          Caption = 'Pointer'
          ImageIndex = 15
          OnClick = mnuAnnotationPointerClick
        end
        object mnuAnnotationFreehandLine: TMenuItem
          Caption = 'Freehand Line'
          ImageIndex = 13
          OnClick = mnuAnnotationFreehandLineClick
        end
        object mnuAnnotationStraightLine: TMenuItem
          Caption = 'Straight Line'
          ImageIndex = 17
          OnClick = mnuAnnotationStraightLineClick
        end
        object mnuAnnotationFilledRectangle: TMenuItem
          Caption = 'Filled Rectangle'
          ImageIndex = 7
          OnClick = mnuAnnotationFilledRectangleClick
        end
        object mnuAnnotationHollowRectangle: TMenuItem
          Caption = 'Hollow Rectangle'
          ImageIndex = 9
          OnClick = mnuAnnotationHollowRectangleClick
        end
        object mnuAnnotationFilledEllipse: TMenuItem
          Caption = 'Filled Ellipse'
          ImageIndex = 8
          OnClick = mnuAnnotationFilledEllipseClick
        end
        object mnuAnnotationHollowEllipse: TMenuItem
          Caption = 'Hollow Ellipse'
          ImageIndex = 4
          OnClick = mnuAnnotationHollowEllipseClick
        end
        object mnuAnnotationTypedText: TMenuItem
          Caption = 'Typed Text'
          ImageIndex = 18
          OnClick = mnuAnnotationTypedTextClick
        end
        object mnuAnnotationArrow: TMenuItem
          Caption = 'Arrow'
          ImageIndex = 2
          OnClick = mnuAnnotationArrowClick
        end
        object mnuAnnotationProtractor: TMenuItem
          Caption = 'Protractor'
          ImageIndex = 5
          OnClick = mnuAnnotationProtractorClick
        end
        object mnuAnnotationRuler: TMenuItem
          Caption = 'Ruler'
          ImageIndex = 6
          OnClick = mnuAnnotationRulerClick
        end
        object mnuAnnotationPlus: TMenuItem
          Caption = 'Plus'
          ImageIndex = 28
          OnClick = mnuAnnotationPlusClick
        end
        object mnuAnnotationMinus: TMenuItem
          Caption = 'Minus'
          ImageIndex = 27
          OnClick = mnuAnnotationMinusClick
        end
      end
    end
    object Help1: TMenuItem
      Caption = 'Help'
      object HelpFullResolutionViewer1: TMenuItem
        Caption = 'Full Resolution Viewer...'
        ImageIndex = 28
        OnClick = HelpFullResolutionViewer1Click
      end
    end
  end
  object timerResize: TTimer
    Interval = 200
    OnTimer = timerResizeTimer
    Left = 412
    Top = 271
  end
  object FontDialog1: TFontDialog
    Font.Charset = DEFAULT_CHARSET
    Font.Color = clWindowText
    Font.Height = -11
    Font.Name = 'MS Sans Serif'
    Font.Style = []
    Left = 560
    Top = 132
  end
  object ColorDialog1: TColorDialog
    Left = 632
    Top = 128
  end
end
